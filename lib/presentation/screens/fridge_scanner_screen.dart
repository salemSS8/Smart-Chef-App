import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/services/gemini_ai_service.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock/ingredients_data.dart';
import '../../domain/models/ingredient.dart';
import '../providers/pantry_provider.dart';

class FridgeScannerScreen extends ConsumerStatefulWidget {
  const FridgeScannerScreen({super.key});

  @override
  ConsumerState<FridgeScannerScreen> createState() => _FridgeScannerScreenState();
}

class _FridgeScannerScreenState extends ConsumerState<FridgeScannerScreen> with SingleTickerProviderStateMixin {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _imageBytes;
  String? _imageName;
  bool _isAnalyzing = false;
  String? _errorMessage;

  late AnimationController _scanAnimController;

  // قائمة المكونات المكتشفة بالذكاء الاصطناعي
  final List<Map<String, dynamic>> _detectedItems = [];

  final TextEditingController _manualItemController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scanAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanAnimController.dispose();
    _manualItemController.dispose();
    super.dispose();
  }

  Future<void> _captureOrPickImage(ImageSource source) async {
    try {
      setState(() {
        _errorMessage = null;
      });

      final XFile? file = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        maxHeight: 1280,
        imageQuality: 85,
      );

      if (file == null) return;

      final bytes = await file.readAsBytes();

      setState(() {
        _imageBytes = bytes;
        _imageName = file.name;
        _isAnalyzing = true;
        _detectedItems.clear();
      });

      // تحليل الصورة عبر Gemini Vision AI
      final geminiService = ref.read(geminiAiServiceProvider);
      final rawIngredients = await geminiService.detectIngredientsFromImage(bytes);

      _processDetectedIngredients(rawIngredients);
    } catch (e) {
      if (mounted) {
        setState(() {
          _isAnalyzing = false;
          _errorMessage = 'تعذر الوصول إلى الكاميرا أو معالجة الصورة: $e';
        });
      }
    }
  }

  void _processDetectedIngredients(List<String> rawIngredients) {
    final List<Map<String, dynamic>> processed = [];
    final seenNames = <String>{};

    for (final raw in rawIngredients) {
      final trimmed = raw.trim();
      if (trimmed.isEmpty || seenNames.contains(trimmed.toLowerCase())) continue;
      seenNames.add(trimmed.toLowerCase());

      // البحث عن مطابقة في المكونات المعرفة
      Ingredient? matched;
      for (final ing in IngredientsData.allIngredients) {
        if (ing.name.toLowerCase() == trimmed.toLowerCase() ||
            ing.synonyms.any((s) => s.toLowerCase() == trimmed.toLowerCase())) {
          matched = ing;
          break;
        }
      }

      if (matched != null) {
        processed.add({
          'id': matched.id,
          'name': matched.name,
          'emoji': matched.emoji,
          'confirmed': true,
        });
      } else {
        processed.add({
          'id': 'ing_detected_${trimmed.hashCode.abs()}',
          'name': trimmed,
          'emoji': '🥫',
          'confirmed': true,
        });
      }
    }

    if (mounted) {
      setState(() {
        _detectedItems.addAll(processed);
        _isAnalyzing = false;
      });
    }
  }

  void _addManualIngredient() {
    final text = _manualItemController.text.trim();
    if (text.isEmpty) return;

    Ingredient? matched;
    for (final ing in IngredientsData.allIngredients) {
      if (ing.name.toLowerCase() == text.toLowerCase() ||
          ing.synonyms.any((s) => s.toLowerCase() == text.toLowerCase())) {
        matched = ing;
        break;
      }
    }

    setState(() {
      _detectedItems.add({
        'id': matched?.id ?? 'ing_manual_${text.hashCode.abs()}',
        'name': matched?.name ?? text,
        'emoji': matched?.emoji ?? '🛒',
        'confirmed': true,
      });
      _manualItemController.clear();
    });
  }

  void _addDetectedToPantry() {
    final idsToAdd = _detectedItems
        .where((item) => item['confirmed'] == true)
        .map((item) => item['id'] as String)
        .toList();

    if (idsToAdd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تحديد مكون واحد على الأقل لإضافته')),
      );
      return;
    }

    ref.read(pantryProvider.notifier).addMultiple(idsToAdd);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تمت إضافة ${idsToAdd.length} مكونات إلى مطبخك بنجاح! 🥕'),
        backgroundColor: AppColors.secondary,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final confirmedCount = _detectedItems.where((i) => i['confirmed'] == true).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('ماسح الثلاجة الذكي 📷', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          if (_imageBytes != null && !_isAnalyzing)
            IconButton(
              icon: const Icon(Icons.add_a_photo_outlined),
              tooltip: 'التقاط صورة جديدة',
              onPressed: () => _captureOrPickImage(ImageSource.camera),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Viewfinder Container
            Container(
              height: 280,
              width: double.infinity,
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFF7F2E8),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: isDark ? Colors.white12 : const Color(0xFFD8CCBA), width: 1.5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (_imageBytes != null)
                      Image.memory(
                        _imageBytes!,
                        fit: BoxFit.cover,
                      )
                    else
                      // Placeholder with Camera instructions
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.kitchen_rounded,
                            size: 64,
                            color: isDark ? Colors.white30 : AppColors.primaryLight,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'وجّه الكاميرا نحو رفوف الثلاجة أو خزانة المطبخ',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'سيتعرف الذكاء الاصطناعي على كافة الأطعمة والمكونات تلقائياً',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.white60 : AppColors.textSecondaryLight,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                icon: const Icon(Icons.camera_alt_rounded, size: 20),
                                label: const Text('التقاط بالكاميرا'),
                                onPressed: () => _captureOrPickImage(ImageSource.camera),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                ),
                                icon: const Icon(Icons.photo_library_outlined, size: 20),
                                label: const Text('من المعرض'),
                                onPressed: () => _captureOrPickImage(ImageSource.gallery),
                              ),
                            ],
                          ),
                        ],
                      ),

                    // Scanning Laser & HUD Animation during AI analysis
                    if (_isAnalyzing)
                      AnimatedBuilder(
                        animation: _scanAnimController,
                        builder: (context, child) {
                          return Container(
                            color: Colors.black.withAlpha(120),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: _scanAnimController.value * 230,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    height: 3,
                                    decoration: BoxDecoration(
                                      color: AppColors.accentGold,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.accentGold.withAlpha(200),
                                          blurRadius: 12,
                                          spreadRadius: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withAlpha(180),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: AppColors.accentGold.withAlpha(100)),
                                    ),
                                    child: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircularProgressIndicator(color: AppColors.accentGold, strokeWidth: 2.5),
                                        SizedBox(height: 12),
                                        Text(
                                          'جاري تحليل الصورة بواسطة Gemini Vision AI...',
                                          style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                    // Controls overlay when image is captured
                    if (_imageBytes != null && !_isAnalyzing)
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(160),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _imageName ?? 'صورة الرف',
                                style: const TextStyle(color: Colors.white, fontSize: 11),
                              ),
                            ),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white.withAlpha(220),
                                    foregroundColor: Colors.black87,
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  icon: const Icon(Icons.refresh_rounded, size: 16),
                                  label: const Text('إعادة التقاط', style: TextStyle(fontSize: 12)),
                                  onPressed: () => _captureOrPickImage(ImageSource.camera),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withAlpha(20),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.withAlpha(60)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline_rounded, color: Colors.red),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // Results Section
            if (_detectedItems.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'وجدنا ${_detectedItems.length} مكونات ($confirmedCount محددة)',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.select_all_rounded, size: 18),
                    label: const Text('تحديد الكل'),
                    onPressed: () {
                      setState(() {
                        for (final i in _detectedItems) {
                          i['confirmed'] = true;
                        }
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'المس المكوّن لإضافته أو استبعاده من مطبخك.',
                style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight),
              ),
              const SizedBox(height: 14),

              // Interactive FilterChips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _detectedItems.map((item) {
                  final isConf = item['confirmed'] as bool;
                  return FilterChip(
                    avatar: Text(item['emoji'] ?? '🥫', style: const TextStyle(fontSize: 14)),
                    label: Text(item['name']),
                    selected: isConf,
                    selectedColor: AppColors.secondaryLight,
                    onSelected: (val) {
                      setState(() {
                        item['confirmed'] = val;
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              // Manual addition input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _manualItemController,
                      decoration: InputDecoration(
                        hintText: 'إضافة مكوّن آخر لم يتم رصده...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onSubmitted: (_) => _addManualIngredient(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    icon: const Icon(Icons.add, color: Colors.white),
                    onPressed: _addManualIngredient,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Add to pantry button
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                icon: const Icon(Icons.kitchen_rounded),
                label: Text(
                  'أضف $confirmedCount مكونات إلى مطبخي 🛒',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: confirmedCount > 0 ? _addDetectedToPantry : null,
              ),
            ] else if (_imageBytes != null && !_isAnalyzing) ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: Column(
                    children: [
                      const Text(
                        'لم نتعرف على أي أطعمة في هذه الصورة.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'حاول التقاط صورة بزاوية أوضح وإضاءة جيدة.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 14),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera_alt_outlined),
                        label: const Text('إعادة المحاولة'),
                        onPressed: () => _captureOrPickImage(ImageSource.camera),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 14),
            const Center(
              child: Text(
                '🔒 الخصوصية: لا نحتفظ بصورة ثلاجتك بعد انتهاء تحليل الأطعمة',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondaryLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
