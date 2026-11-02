// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isStapleMeta = const VerificationMeta(
    'isStaple',
  );
  @override
  late final GeneratedColumn<bool> isStaple = GeneratedColumn<bool>(
    'is_staple',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_staple" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _defaultUnitMeta = const VerificationMeta(
    'defaultUnit',
  );
  @override
  late final GeneratedColumn<String> defaultUnit = GeneratedColumn<String>(
    'default_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shelfLifeFridgeDaysMeta =
      const VerificationMeta('shelfLifeFridgeDays');
  @override
  late final GeneratedColumn<int> shelfLifeFridgeDays = GeneratedColumn<int>(
    'shelf_life_fridge_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _shelfLifePantryDaysMeta =
      const VerificationMeta('shelfLifePantryDays');
  @override
  late final GeneratedColumn<int> shelfLifePantryDays = GeneratedColumn<int>(
    'shelf_life_pantry_days',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _allergensMeta = const VerificationMeta(
    'allergens',
  );
  @override
  late final GeneratedColumn<String> allergens = GeneratedColumn<String>(
    'allergens',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _dietFlagsMeta = const VerificationMeta(
    'dietFlags',
  );
  @override
  late final GeneratedColumn<String> dietFlags = GeneratedColumn<String>(
    'diet_flags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    category,
    parentId,
    isStaple,
    defaultUnit,
    shelfLifeFridgeDays,
    shelfLifePantryDays,
    allergens,
    dietFlags,
    imageUrl,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ingredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('is_staple')) {
      context.handle(
        _isStapleMeta,
        isStaple.isAcceptableOrUnknown(data['is_staple']!, _isStapleMeta),
      );
    }
    if (data.containsKey('default_unit')) {
      context.handle(
        _defaultUnitMeta,
        defaultUnit.isAcceptableOrUnknown(
          data['default_unit']!,
          _defaultUnitMeta,
        ),
      );
    }
    if (data.containsKey('shelf_life_fridge_days')) {
      context.handle(
        _shelfLifeFridgeDaysMeta,
        shelfLifeFridgeDays.isAcceptableOrUnknown(
          data['shelf_life_fridge_days']!,
          _shelfLifeFridgeDaysMeta,
        ),
      );
    }
    if (data.containsKey('shelf_life_pantry_days')) {
      context.handle(
        _shelfLifePantryDaysMeta,
        shelfLifePantryDays.isAcceptableOrUnknown(
          data['shelf_life_pantry_days']!,
          _shelfLifePantryDaysMeta,
        ),
      );
    }
    if (data.containsKey('allergens')) {
      context.handle(
        _allergensMeta,
        allergens.isAcceptableOrUnknown(data['allergens']!, _allergensMeta),
      );
    }
    if (data.containsKey('diet_flags')) {
      context.handle(
        _dietFlagsMeta,
        dietFlags.isAcceptableOrUnknown(data['diet_flags']!, _dietFlagsMeta),
      );
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      isStaple: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_staple'],
      )!,
      defaultUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_unit'],
      ),
      shelfLifeFridgeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shelf_life_fridge_days'],
      ),
      shelfLifePantryDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shelf_life_pantry_days'],
      ),
      allergens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergens'],
      )!,
      dietFlags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_flags'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final String id;
  final String category;
  final String? parentId;
  final bool isStaple;
  final String? defaultUnit;
  final int? shelfLifeFridgeDays;
  final int? shelfLifePantryDays;
  final String allergens;
  final String dietFlags;
  final String? imageUrl;
  final DateTime updatedAt;
  const Ingredient({
    required this.id,
    required this.category,
    this.parentId,
    required this.isStaple,
    this.defaultUnit,
    this.shelfLifeFridgeDays,
    this.shelfLifePantryDays,
    required this.allergens,
    required this.dietFlags,
    this.imageUrl,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category'] = Variable<String>(category);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['is_staple'] = Variable<bool>(isStaple);
    if (!nullToAbsent || defaultUnit != null) {
      map['default_unit'] = Variable<String>(defaultUnit);
    }
    if (!nullToAbsent || shelfLifeFridgeDays != null) {
      map['shelf_life_fridge_days'] = Variable<int>(shelfLifeFridgeDays);
    }
    if (!nullToAbsent || shelfLifePantryDays != null) {
      map['shelf_life_pantry_days'] = Variable<int>(shelfLifePantryDays);
    }
    map['allergens'] = Variable<String>(allergens);
    map['diet_flags'] = Variable<String>(dietFlags);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      category: Value(category),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isStaple: Value(isStaple),
      defaultUnit: defaultUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultUnit),
      shelfLifeFridgeDays: shelfLifeFridgeDays == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLifeFridgeDays),
      shelfLifePantryDays: shelfLifePantryDays == null && nullToAbsent
          ? const Value.absent()
          : Value(shelfLifePantryDays),
      allergens: Value(allergens),
      dietFlags: Value(dietFlags),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      updatedAt: Value(updatedAt),
    );
  }

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<String>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      isStaple: serializer.fromJson<bool>(json['isStaple']),
      defaultUnit: serializer.fromJson<String?>(json['defaultUnit']),
      shelfLifeFridgeDays: serializer.fromJson<int?>(
        json['shelfLifeFridgeDays'],
      ),
      shelfLifePantryDays: serializer.fromJson<int?>(
        json['shelfLifePantryDays'],
      ),
      allergens: serializer.fromJson<String>(json['allergens']),
      dietFlags: serializer.fromJson<String>(json['dietFlags']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'category': serializer.toJson<String>(category),
      'parentId': serializer.toJson<String?>(parentId),
      'isStaple': serializer.toJson<bool>(isStaple),
      'defaultUnit': serializer.toJson<String?>(defaultUnit),
      'shelfLifeFridgeDays': serializer.toJson<int?>(shelfLifeFridgeDays),
      'shelfLifePantryDays': serializer.toJson<int?>(shelfLifePantryDays),
      'allergens': serializer.toJson<String>(allergens),
      'dietFlags': serializer.toJson<String>(dietFlags),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Ingredient copyWith({
    String? id,
    String? category,
    Value<String?> parentId = const Value.absent(),
    bool? isStaple,
    Value<String?> defaultUnit = const Value.absent(),
    Value<int?> shelfLifeFridgeDays = const Value.absent(),
    Value<int?> shelfLifePantryDays = const Value.absent(),
    String? allergens,
    String? dietFlags,
    Value<String?> imageUrl = const Value.absent(),
    DateTime? updatedAt,
  }) => Ingredient(
    id: id ?? this.id,
    category: category ?? this.category,
    parentId: parentId.present ? parentId.value : this.parentId,
    isStaple: isStaple ?? this.isStaple,
    defaultUnit: defaultUnit.present ? defaultUnit.value : this.defaultUnit,
    shelfLifeFridgeDays: shelfLifeFridgeDays.present
        ? shelfLifeFridgeDays.value
        : this.shelfLifeFridgeDays,
    shelfLifePantryDays: shelfLifePantryDays.present
        ? shelfLifePantryDays.value
        : this.shelfLifePantryDays,
    allergens: allergens ?? this.allergens,
    dietFlags: dietFlags ?? this.dietFlags,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isStaple: data.isStaple.present ? data.isStaple.value : this.isStaple,
      defaultUnit: data.defaultUnit.present
          ? data.defaultUnit.value
          : this.defaultUnit,
      shelfLifeFridgeDays: data.shelfLifeFridgeDays.present
          ? data.shelfLifeFridgeDays.value
          : this.shelfLifeFridgeDays,
      shelfLifePantryDays: data.shelfLifePantryDays.present
          ? data.shelfLifePantryDays.value
          : this.shelfLifePantryDays,
      allergens: data.allergens.present ? data.allergens.value : this.allergens,
      dietFlags: data.dietFlags.present ? data.dietFlags.value : this.dietFlags,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('parentId: $parentId, ')
          ..write('isStaple: $isStaple, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('shelfLifeFridgeDays: $shelfLifeFridgeDays, ')
          ..write('shelfLifePantryDays: $shelfLifePantryDays, ')
          ..write('allergens: $allergens, ')
          ..write('dietFlags: $dietFlags, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    category,
    parentId,
    isStaple,
    defaultUnit,
    shelfLifeFridgeDays,
    shelfLifePantryDays,
    allergens,
    dietFlags,
    imageUrl,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.category == this.category &&
          other.parentId == this.parentId &&
          other.isStaple == this.isStaple &&
          other.defaultUnit == this.defaultUnit &&
          other.shelfLifeFridgeDays == this.shelfLifeFridgeDays &&
          other.shelfLifePantryDays == this.shelfLifePantryDays &&
          other.allergens == this.allergens &&
          other.dietFlags == this.dietFlags &&
          other.imageUrl == this.imageUrl &&
          other.updatedAt == this.updatedAt);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<String> id;
  final Value<String> category;
  final Value<String?> parentId;
  final Value<bool> isStaple;
  final Value<String?> defaultUnit;
  final Value<int?> shelfLifeFridgeDays;
  final Value<int?> shelfLifePantryDays;
  final Value<String> allergens;
  final Value<String> dietFlags;
  final Value<String?> imageUrl;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isStaple = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.shelfLifeFridgeDays = const Value.absent(),
    this.shelfLifePantryDays = const Value.absent(),
    this.allergens = const Value.absent(),
    this.dietFlags = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientsCompanion.insert({
    required String id,
    required String category,
    this.parentId = const Value.absent(),
    this.isStaple = const Value.absent(),
    this.defaultUnit = const Value.absent(),
    this.shelfLifeFridgeDays = const Value.absent(),
    this.shelfLifePantryDays = const Value.absent(),
    this.allergens = const Value.absent(),
    this.dietFlags = const Value.absent(),
    this.imageUrl = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       category = Value(category),
       updatedAt = Value(updatedAt);
  static Insertable<Ingredient> custom({
    Expression<String>? id,
    Expression<String>? category,
    Expression<String>? parentId,
    Expression<bool>? isStaple,
    Expression<String>? defaultUnit,
    Expression<int>? shelfLifeFridgeDays,
    Expression<int>? shelfLifePantryDays,
    Expression<String>? allergens,
    Expression<String>? dietFlags,
    Expression<String>? imageUrl,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (parentId != null) 'parent_id': parentId,
      if (isStaple != null) 'is_staple': isStaple,
      if (defaultUnit != null) 'default_unit': defaultUnit,
      if (shelfLifeFridgeDays != null)
        'shelf_life_fridge_days': shelfLifeFridgeDays,
      if (shelfLifePantryDays != null)
        'shelf_life_pantry_days': shelfLifePantryDays,
      if (allergens != null) 'allergens': allergens,
      if (dietFlags != null) 'diet_flags': dietFlags,
      if (imageUrl != null) 'image_url': imageUrl,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientsCompanion copyWith({
    Value<String>? id,
    Value<String>? category,
    Value<String?>? parentId,
    Value<bool>? isStaple,
    Value<String?>? defaultUnit,
    Value<int?>? shelfLifeFridgeDays,
    Value<int?>? shelfLifePantryDays,
    Value<String>? allergens,
    Value<String>? dietFlags,
    Value<String?>? imageUrl,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      parentId: parentId ?? this.parentId,
      isStaple: isStaple ?? this.isStaple,
      defaultUnit: defaultUnit ?? this.defaultUnit,
      shelfLifeFridgeDays: shelfLifeFridgeDays ?? this.shelfLifeFridgeDays,
      shelfLifePantryDays: shelfLifePantryDays ?? this.shelfLifePantryDays,
      allergens: allergens ?? this.allergens,
      dietFlags: dietFlags ?? this.dietFlags,
      imageUrl: imageUrl ?? this.imageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (isStaple.present) {
      map['is_staple'] = Variable<bool>(isStaple.value);
    }
    if (defaultUnit.present) {
      map['default_unit'] = Variable<String>(defaultUnit.value);
    }
    if (shelfLifeFridgeDays.present) {
      map['shelf_life_fridge_days'] = Variable<int>(shelfLifeFridgeDays.value);
    }
    if (shelfLifePantryDays.present) {
      map['shelf_life_pantry_days'] = Variable<int>(shelfLifePantryDays.value);
    }
    if (allergens.present) {
      map['allergens'] = Variable<String>(allergens.value);
    }
    if (dietFlags.present) {
      map['diet_flags'] = Variable<String>(dietFlags.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('parentId: $parentId, ')
          ..write('isStaple: $isStaple, ')
          ..write('defaultUnit: $defaultUnit, ')
          ..write('shelfLifeFridgeDays: $shelfLifeFridgeDays, ')
          ..write('shelfLifePantryDays: $shelfLifePantryDays, ')
          ..write('allergens: $allergens, ')
          ..write('dietFlags: $dietFlags, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientNamesTable extends IngredientNames
    with TableInfo<$IngredientNamesTable, IngredientName> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientNamesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _langMeta = const VerificationMeta('lang');
  @override
  late final GeneratedColumn<String> lang = GeneratedColumn<String>(
    'lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedMeta = const VerificationMeta(
    'normalized',
  );
  @override
  late final GeneratedColumn<String> normalized = GeneratedColumn<String>(
    'normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPrimaryMeta = const VerificationMeta(
    'isPrimary',
  );
  @override
  late final GeneratedColumn<bool> isPrimary = GeneratedColumn<bool>(
    'is_primary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_primary" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    ingredientId,
    lang,
    region,
    name,
    normalized,
    isPrimary,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_names';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientName> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('lang')) {
      context.handle(
        _langMeta,
        lang.isAcceptableOrUnknown(data['lang']!, _langMeta),
      );
    } else if (isInserting) {
      context.missing(_langMeta);
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized')) {
      context.handle(
        _normalizedMeta,
        normalized.isAcceptableOrUnknown(data['normalized']!, _normalizedMeta),
      );
    } else if (isInserting) {
      context.missing(_normalizedMeta);
    }
    if (data.containsKey('is_primary')) {
      context.handle(
        _isPrimaryMeta,
        isPrimary.isAcceptableOrUnknown(data['is_primary']!, _isPrimaryMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ingredientId, lang, name};
  @override
  IngredientName map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientName(
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      lang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lang'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      normalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized'],
      )!,
      isPrimary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_primary'],
      )!,
    );
  }

  @override
  $IngredientNamesTable createAlias(String alias) {
    return $IngredientNamesTable(attachedDatabase, alias);
  }
}

class IngredientName extends DataClass implements Insertable<IngredientName> {
  final String ingredientId;
  final String lang;
  final String? region;
  final String name;
  final String normalized;
  final bool isPrimary;
  const IngredientName({
    required this.ingredientId,
    required this.lang,
    this.region,
    required this.name,
    required this.normalized,
    required this.isPrimary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['lang'] = Variable<String>(lang);
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    map['name'] = Variable<String>(name);
    map['normalized'] = Variable<String>(normalized);
    map['is_primary'] = Variable<bool>(isPrimary);
    return map;
  }

  IngredientNamesCompanion toCompanion(bool nullToAbsent) {
    return IngredientNamesCompanion(
      ingredientId: Value(ingredientId),
      lang: Value(lang),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      name: Value(name),
      normalized: Value(normalized),
      isPrimary: Value(isPrimary),
    );
  }

  factory IngredientName.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientName(
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      lang: serializer.fromJson<String>(json['lang']),
      region: serializer.fromJson<String?>(json['region']),
      name: serializer.fromJson<String>(json['name']),
      normalized: serializer.fromJson<String>(json['normalized']),
      isPrimary: serializer.fromJson<bool>(json['isPrimary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ingredientId': serializer.toJson<String>(ingredientId),
      'lang': serializer.toJson<String>(lang),
      'region': serializer.toJson<String?>(region),
      'name': serializer.toJson<String>(name),
      'normalized': serializer.toJson<String>(normalized),
      'isPrimary': serializer.toJson<bool>(isPrimary),
    };
  }

  IngredientName copyWith({
    String? ingredientId,
    String? lang,
    Value<String?> region = const Value.absent(),
    String? name,
    String? normalized,
    bool? isPrimary,
  }) => IngredientName(
    ingredientId: ingredientId ?? this.ingredientId,
    lang: lang ?? this.lang,
    region: region.present ? region.value : this.region,
    name: name ?? this.name,
    normalized: normalized ?? this.normalized,
    isPrimary: isPrimary ?? this.isPrimary,
  );
  IngredientName copyWithCompanion(IngredientNamesCompanion data) {
    return IngredientName(
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      lang: data.lang.present ? data.lang.value : this.lang,
      region: data.region.present ? data.region.value : this.region,
      name: data.name.present ? data.name.value : this.name,
      normalized: data.normalized.present
          ? data.normalized.value
          : this.normalized,
      isPrimary: data.isPrimary.present ? data.isPrimary.value : this.isPrimary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientName(')
          ..write('ingredientId: $ingredientId, ')
          ..write('lang: $lang, ')
          ..write('region: $region, ')
          ..write('name: $name, ')
          ..write('normalized: $normalized, ')
          ..write('isPrimary: $isPrimary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(ingredientId, lang, region, name, normalized, isPrimary);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientName &&
          other.ingredientId == this.ingredientId &&
          other.lang == this.lang &&
          other.region == this.region &&
          other.name == this.name &&
          other.normalized == this.normalized &&
          other.isPrimary == this.isPrimary);
}

class IngredientNamesCompanion extends UpdateCompanion<IngredientName> {
  final Value<String> ingredientId;
  final Value<String> lang;
  final Value<String?> region;
  final Value<String> name;
  final Value<String> normalized;
  final Value<bool> isPrimary;
  final Value<int> rowid;
  const IngredientNamesCompanion({
    this.ingredientId = const Value.absent(),
    this.lang = const Value.absent(),
    this.region = const Value.absent(),
    this.name = const Value.absent(),
    this.normalized = const Value.absent(),
    this.isPrimary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientNamesCompanion.insert({
    required String ingredientId,
    required String lang,
    this.region = const Value.absent(),
    required String name,
    required String normalized,
    this.isPrimary = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ingredientId = Value(ingredientId),
       lang = Value(lang),
       name = Value(name),
       normalized = Value(normalized);
  static Insertable<IngredientName> custom({
    Expression<String>? ingredientId,
    Expression<String>? lang,
    Expression<String>? region,
    Expression<String>? name,
    Expression<String>? normalized,
    Expression<bool>? isPrimary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (lang != null) 'lang': lang,
      if (region != null) 'region': region,
      if (name != null) 'name': name,
      if (normalized != null) 'normalized': normalized,
      if (isPrimary != null) 'is_primary': isPrimary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientNamesCompanion copyWith({
    Value<String>? ingredientId,
    Value<String>? lang,
    Value<String?>? region,
    Value<String>? name,
    Value<String>? normalized,
    Value<bool>? isPrimary,
    Value<int>? rowid,
  }) {
    return IngredientNamesCompanion(
      ingredientId: ingredientId ?? this.ingredientId,
      lang: lang ?? this.lang,
      region: region ?? this.region,
      name: name ?? this.name,
      normalized: normalized ?? this.normalized,
      isPrimary: isPrimary ?? this.isPrimary,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (lang.present) {
      map['lang'] = Variable<String>(lang.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalized.present) {
      map['normalized'] = Variable<String>(normalized.value);
    }
    if (isPrimary.present) {
      map['is_primary'] = Variable<bool>(isPrimary.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientNamesCompanion(')
          ..write('ingredientId: $ingredientId, ')
          ..write('lang: $lang, ')
          ..write('region: $region, ')
          ..write('name: $name, ')
          ..write('normalized: $normalized, ')
          ..write('isPrimary: $isPrimary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IngredientSubstitutesTable extends IngredientSubstitutes
    with TableInfo<$IngredientSubstitutesTable, IngredientSubstitute> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientSubstitutesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _substituteIdMeta = const VerificationMeta(
    'substituteId',
  );
  @override
  late final GeneratedColumn<String> substituteId = GeneratedColumn<String>(
    'substitute_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _ratioMeta = const VerificationMeta('ratio');
  @override
  late final GeneratedColumn<double> ratio = GeneratedColumn<double>(
    'ratio',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _qualityMeta = const VerificationMeta(
    'quality',
  );
  @override
  late final GeneratedColumn<String> quality = GeneratedColumn<String>(
    'quality',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextTagsMeta = const VerificationMeta(
    'contextTags',
  );
  @override
  late final GeneratedColumn<String> contextTags = GeneratedColumn<String>(
    'context_tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _noteArMeta = const VerificationMeta('noteAr');
  @override
  late final GeneratedColumn<String> noteAr = GeneratedColumn<String>(
    'note_ar',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    ingredientId,
    substituteId,
    ratio,
    quality,
    contextTags,
    noteAr,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredient_substitutes';
  @override
  VerificationContext validateIntegrity(
    Insertable<IngredientSubstitute> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('substitute_id')) {
      context.handle(
        _substituteIdMeta,
        substituteId.isAcceptableOrUnknown(
          data['substitute_id']!,
          _substituteIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_substituteIdMeta);
    }
    if (data.containsKey('ratio')) {
      context.handle(
        _ratioMeta,
        ratio.isAcceptableOrUnknown(data['ratio']!, _ratioMeta),
      );
    }
    if (data.containsKey('quality')) {
      context.handle(
        _qualityMeta,
        quality.isAcceptableOrUnknown(data['quality']!, _qualityMeta),
      );
    } else if (isInserting) {
      context.missing(_qualityMeta);
    }
    if (data.containsKey('context_tags')) {
      context.handle(
        _contextTagsMeta,
        contextTags.isAcceptableOrUnknown(
          data['context_tags']!,
          _contextTagsMeta,
        ),
      );
    }
    if (data.containsKey('note_ar')) {
      context.handle(
        _noteArMeta,
        noteAr.isAcceptableOrUnknown(data['note_ar']!, _noteArMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {ingredientId, substituteId};
  @override
  IngredientSubstitute map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IngredientSubstitute(
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      substituteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}substitute_id'],
      )!,
      ratio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ratio'],
      )!,
      quality: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}quality'],
      )!,
      contextTags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_tags'],
      )!,
      noteAr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_ar'],
      ),
    );
  }

  @override
  $IngredientSubstitutesTable createAlias(String alias) {
    return $IngredientSubstitutesTable(attachedDatabase, alias);
  }
}

class IngredientSubstitute extends DataClass
    implements Insertable<IngredientSubstitute> {
  final String ingredientId;
  final String substituteId;
  final double ratio;
  final String quality;
  final String contextTags;
  final String? noteAr;
  const IngredientSubstitute({
    required this.ingredientId,
    required this.substituteId,
    required this.ratio,
    required this.quality,
    required this.contextTags,
    this.noteAr,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['substitute_id'] = Variable<String>(substituteId);
    map['ratio'] = Variable<double>(ratio);
    map['quality'] = Variable<String>(quality);
    map['context_tags'] = Variable<String>(contextTags);
    if (!nullToAbsent || noteAr != null) {
      map['note_ar'] = Variable<String>(noteAr);
    }
    return map;
  }

  IngredientSubstitutesCompanion toCompanion(bool nullToAbsent) {
    return IngredientSubstitutesCompanion(
      ingredientId: Value(ingredientId),
      substituteId: Value(substituteId),
      ratio: Value(ratio),
      quality: Value(quality),
      contextTags: Value(contextTags),
      noteAr: noteAr == null && nullToAbsent
          ? const Value.absent()
          : Value(noteAr),
    );
  }

  factory IngredientSubstitute.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IngredientSubstitute(
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      substituteId: serializer.fromJson<String>(json['substituteId']),
      ratio: serializer.fromJson<double>(json['ratio']),
      quality: serializer.fromJson<String>(json['quality']),
      contextTags: serializer.fromJson<String>(json['contextTags']),
      noteAr: serializer.fromJson<String?>(json['noteAr']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'ingredientId': serializer.toJson<String>(ingredientId),
      'substituteId': serializer.toJson<String>(substituteId),
      'ratio': serializer.toJson<double>(ratio),
      'quality': serializer.toJson<String>(quality),
      'contextTags': serializer.toJson<String>(contextTags),
      'noteAr': serializer.toJson<String?>(noteAr),
    };
  }

  IngredientSubstitute copyWith({
    String? ingredientId,
    String? substituteId,
    double? ratio,
    String? quality,
    String? contextTags,
    Value<String?> noteAr = const Value.absent(),
  }) => IngredientSubstitute(
    ingredientId: ingredientId ?? this.ingredientId,
    substituteId: substituteId ?? this.substituteId,
    ratio: ratio ?? this.ratio,
    quality: quality ?? this.quality,
    contextTags: contextTags ?? this.contextTags,
    noteAr: noteAr.present ? noteAr.value : this.noteAr,
  );
  IngredientSubstitute copyWithCompanion(IngredientSubstitutesCompanion data) {
    return IngredientSubstitute(
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      substituteId: data.substituteId.present
          ? data.substituteId.value
          : this.substituteId,
      ratio: data.ratio.present ? data.ratio.value : this.ratio,
      quality: data.quality.present ? data.quality.value : this.quality,
      contextTags: data.contextTags.present
          ? data.contextTags.value
          : this.contextTags,
      noteAr: data.noteAr.present ? data.noteAr.value : this.noteAr,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IngredientSubstitute(')
          ..write('ingredientId: $ingredientId, ')
          ..write('substituteId: $substituteId, ')
          ..write('ratio: $ratio, ')
          ..write('quality: $quality, ')
          ..write('contextTags: $contextTags, ')
          ..write('noteAr: $noteAr')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    ingredientId,
    substituteId,
    ratio,
    quality,
    contextTags,
    noteAr,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IngredientSubstitute &&
          other.ingredientId == this.ingredientId &&
          other.substituteId == this.substituteId &&
          other.ratio == this.ratio &&
          other.quality == this.quality &&
          other.contextTags == this.contextTags &&
          other.noteAr == this.noteAr);
}

class IngredientSubstitutesCompanion
    extends UpdateCompanion<IngredientSubstitute> {
  final Value<String> ingredientId;
  final Value<String> substituteId;
  final Value<double> ratio;
  final Value<String> quality;
  final Value<String> contextTags;
  final Value<String?> noteAr;
  final Value<int> rowid;
  const IngredientSubstitutesCompanion({
    this.ingredientId = const Value.absent(),
    this.substituteId = const Value.absent(),
    this.ratio = const Value.absent(),
    this.quality = const Value.absent(),
    this.contextTags = const Value.absent(),
    this.noteAr = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IngredientSubstitutesCompanion.insert({
    required String ingredientId,
    required String substituteId,
    this.ratio = const Value.absent(),
    required String quality,
    this.contextTags = const Value.absent(),
    this.noteAr = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : ingredientId = Value(ingredientId),
       substituteId = Value(substituteId),
       quality = Value(quality);
  static Insertable<IngredientSubstitute> custom({
    Expression<String>? ingredientId,
    Expression<String>? substituteId,
    Expression<double>? ratio,
    Expression<String>? quality,
    Expression<String>? contextTags,
    Expression<String>? noteAr,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (substituteId != null) 'substitute_id': substituteId,
      if (ratio != null) 'ratio': ratio,
      if (quality != null) 'quality': quality,
      if (contextTags != null) 'context_tags': contextTags,
      if (noteAr != null) 'note_ar': noteAr,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IngredientSubstitutesCompanion copyWith({
    Value<String>? ingredientId,
    Value<String>? substituteId,
    Value<double>? ratio,
    Value<String>? quality,
    Value<String>? contextTags,
    Value<String?>? noteAr,
    Value<int>? rowid,
  }) {
    return IngredientSubstitutesCompanion(
      ingredientId: ingredientId ?? this.ingredientId,
      substituteId: substituteId ?? this.substituteId,
      ratio: ratio ?? this.ratio,
      quality: quality ?? this.quality,
      contextTags: contextTags ?? this.contextTags,
      noteAr: noteAr ?? this.noteAr,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (substituteId.present) {
      map['substitute_id'] = Variable<String>(substituteId.value);
    }
    if (ratio.present) {
      map['ratio'] = Variable<double>(ratio.value);
    }
    if (quality.present) {
      map['quality'] = Variable<String>(quality.value);
    }
    if (contextTags.present) {
      map['context_tags'] = Variable<String>(contextTags.value);
    }
    if (noteAr.present) {
      map['note_ar'] = Variable<String>(noteAr.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientSubstitutesCompanion(')
          ..write('ingredientId: $ingredientId, ')
          ..write('substituteId: $substituteId, ')
          ..write('ratio: $ratio, ')
          ..write('quality: $quality, ')
          ..write('contextTags: $contextTags, ')
          ..write('noteAr: $noteAr, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cuisineMeta = const VerificationMeta(
    'cuisine',
  );
  @override
  late final GeneratedColumn<String> cuisine = GeneratedColumn<String>(
    'cuisine',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _prepMinutesMeta = const VerificationMeta(
    'prepMinutes',
  );
  @override
  late final GeneratedColumn<int> prepMinutes = GeneratedColumn<int>(
    'prep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookMinutesMeta = const VerificationMeta(
    'cookMinutes',
  );
  @override
  late final GeneratedColumn<int> cookMinutes = GeneratedColumn<int>(
    'cook_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalMinutesMeta = const VerificationMeta(
    'totalMinutes',
  );
  @override
  late final GeneratedColumn<int> totalMinutes = GeneratedColumn<int>(
    'total_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baseServingsMeta = const VerificationMeta(
    'baseServings',
  );
  @override
  late final GeneratedColumn<int> baseServings = GeneratedColumn<int>(
    'base_servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _caloriesPerServingMeta =
      const VerificationMeta('caloriesPerServing');
  @override
  late final GeneratedColumn<int> caloriesPerServing = GeneratedColumn<int>(
    'calories_per_serving',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _dietFlagsMeta = const VerificationMeta(
    'dietFlags',
  );
  @override
  late final GeneratedColumn<String> dietFlags = GeneratedColumn<String>(
    'diet_flags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _allergensMeta = const VerificationMeta(
    'allergens',
  );
  @override
  late final GeneratedColumn<String> allergens = GeneratedColumn<String>(
    'allergens',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourceTypeMeta = const VerificationMeta(
    'sourceType',
  );
  @override
  late final GeneratedColumn<String> sourceType = GeneratedColumn<String>(
    'source_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('editorial'),
  );
  static const VerificationMeta _verifiedMeta = const VerificationMeta(
    'verified',
  );
  @override
  late final GeneratedColumn<bool> verified = GeneratedColumn<bool>(
    'verified',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("verified" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _heroImageUrlMeta = const VerificationMeta(
    'heroImageUrl',
  );
  @override
  late final GeneratedColumn<String> heroImageUrl = GeneratedColumn<String>(
    'hero_image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _blurhashMeta = const VerificationMeta(
    'blurhash',
  );
  @override
  late final GeneratedColumn<String> blurhash = GeneratedColumn<String>(
    'blurhash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingAvgMeta = const VerificationMeta(
    'ratingAvg',
  );
  @override
  late final GeneratedColumn<double> ratingAvg = GeneratedColumn<double>(
    'rating_avg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _ratingCountMeta = const VerificationMeta(
    'ratingCount',
  );
  @override
  late final GeneratedColumn<int> ratingCount = GeneratedColumn<int>(
    'rating_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('published'),
  );
  static const VerificationMeta _publishedAtMeta = const VerificationMeta(
    'publishedAt',
  );
  @override
  late final GeneratedColumn<DateTime> publishedAt = GeneratedColumn<DateTime>(
    'published_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slug,
    title,
    description,
    cuisine,
    mealType,
    difficulty,
    prepMinutes,
    cookMinutes,
    totalMinutes,
    baseServings,
    caloriesPerServing,
    equipment,
    dietFlags,
    allergens,
    sourceType,
    verified,
    heroImageUrl,
    blurhash,
    ratingAvg,
    ratingCount,
    status,
    publishedAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('cuisine')) {
      context.handle(
        _cuisineMeta,
        cuisine.isAcceptableOrUnknown(data['cuisine']!, _cuisineMeta),
      );
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('prep_minutes')) {
      context.handle(
        _prepMinutesMeta,
        prepMinutes.isAcceptableOrUnknown(
          data['prep_minutes']!,
          _prepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('cook_minutes')) {
      context.handle(
        _cookMinutesMeta,
        cookMinutes.isAcceptableOrUnknown(
          data['cook_minutes']!,
          _cookMinutesMeta,
        ),
      );
    }
    if (data.containsKey('total_minutes')) {
      context.handle(
        _totalMinutesMeta,
        totalMinutes.isAcceptableOrUnknown(
          data['total_minutes']!,
          _totalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('base_servings')) {
      context.handle(
        _baseServingsMeta,
        baseServings.isAcceptableOrUnknown(
          data['base_servings']!,
          _baseServingsMeta,
        ),
      );
    }
    if (data.containsKey('calories_per_serving')) {
      context.handle(
        _caloriesPerServingMeta,
        caloriesPerServing.isAcceptableOrUnknown(
          data['calories_per_serving']!,
          _caloriesPerServingMeta,
        ),
      );
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    }
    if (data.containsKey('diet_flags')) {
      context.handle(
        _dietFlagsMeta,
        dietFlags.isAcceptableOrUnknown(data['diet_flags']!, _dietFlagsMeta),
      );
    }
    if (data.containsKey('allergens')) {
      context.handle(
        _allergensMeta,
        allergens.isAcceptableOrUnknown(data['allergens']!, _allergensMeta),
      );
    }
    if (data.containsKey('source_type')) {
      context.handle(
        _sourceTypeMeta,
        sourceType.isAcceptableOrUnknown(data['source_type']!, _sourceTypeMeta),
      );
    }
    if (data.containsKey('verified')) {
      context.handle(
        _verifiedMeta,
        verified.isAcceptableOrUnknown(data['verified']!, _verifiedMeta),
      );
    }
    if (data.containsKey('hero_image_url')) {
      context.handle(
        _heroImageUrlMeta,
        heroImageUrl.isAcceptableOrUnknown(
          data['hero_image_url']!,
          _heroImageUrlMeta,
        ),
      );
    }
    if (data.containsKey('blurhash')) {
      context.handle(
        _blurhashMeta,
        blurhash.isAcceptableOrUnknown(data['blurhash']!, _blurhashMeta),
      );
    }
    if (data.containsKey('rating_avg')) {
      context.handle(
        _ratingAvgMeta,
        ratingAvg.isAcceptableOrUnknown(data['rating_avg']!, _ratingAvgMeta),
      );
    }
    if (data.containsKey('rating_count')) {
      context.handle(
        _ratingCountMeta,
        ratingCount.isAcceptableOrUnknown(
          data['rating_count']!,
          _ratingCountMeta,
        ),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('published_at')) {
      context.handle(
        _publishedAtMeta,
        publishedAt.isAcceptableOrUnknown(
          data['published_at']!,
          _publishedAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      cuisine: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cuisine'],
      ),
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      prepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_minutes'],
      ),
      cookMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_minutes'],
      ),
      totalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minutes'],
      ),
      baseServings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_servings'],
      )!,
      caloriesPerServing: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories_per_serving'],
      ),
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      dietFlags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_flags'],
      )!,
      allergens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergens'],
      )!,
      sourceType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_type'],
      )!,
      verified: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}verified'],
      )!,
      heroImageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hero_image_url'],
      ),
      blurhash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blurhash'],
      ),
      ratingAvg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}rating_avg'],
      )!,
      ratingCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating_count'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      publishedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}published_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final String slug;
  final String title;
  final String? description;
  final String? cuisine;
  final String mealType;
  final int difficulty;
  final int? prepMinutes;
  final int? cookMinutes;
  final int? totalMinutes;
  final int baseServings;
  final int? caloriesPerServing;
  final String equipment;
  final String dietFlags;
  final String allergens;
  final String sourceType;
  final bool verified;
  final String? heroImageUrl;
  final String? blurhash;
  final double ratingAvg;
  final int ratingCount;
  final String status;
  final DateTime? publishedAt;
  final DateTime updatedAt;
  const Recipe({
    required this.id,
    required this.slug,
    required this.title,
    this.description,
    this.cuisine,
    required this.mealType,
    required this.difficulty,
    this.prepMinutes,
    this.cookMinutes,
    this.totalMinutes,
    required this.baseServings,
    this.caloriesPerServing,
    required this.equipment,
    required this.dietFlags,
    required this.allergens,
    required this.sourceType,
    required this.verified,
    this.heroImageUrl,
    this.blurhash,
    required this.ratingAvg,
    required this.ratingCount,
    required this.status,
    this.publishedAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['slug'] = Variable<String>(slug);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || cuisine != null) {
      map['cuisine'] = Variable<String>(cuisine);
    }
    map['meal_type'] = Variable<String>(mealType);
    map['difficulty'] = Variable<int>(difficulty);
    if (!nullToAbsent || prepMinutes != null) {
      map['prep_minutes'] = Variable<int>(prepMinutes);
    }
    if (!nullToAbsent || cookMinutes != null) {
      map['cook_minutes'] = Variable<int>(cookMinutes);
    }
    if (!nullToAbsent || totalMinutes != null) {
      map['total_minutes'] = Variable<int>(totalMinutes);
    }
    map['base_servings'] = Variable<int>(baseServings);
    if (!nullToAbsent || caloriesPerServing != null) {
      map['calories_per_serving'] = Variable<int>(caloriesPerServing);
    }
    map['equipment'] = Variable<String>(equipment);
    map['diet_flags'] = Variable<String>(dietFlags);
    map['allergens'] = Variable<String>(allergens);
    map['source_type'] = Variable<String>(sourceType);
    map['verified'] = Variable<bool>(verified);
    if (!nullToAbsent || heroImageUrl != null) {
      map['hero_image_url'] = Variable<String>(heroImageUrl);
    }
    if (!nullToAbsent || blurhash != null) {
      map['blurhash'] = Variable<String>(blurhash);
    }
    map['rating_avg'] = Variable<double>(ratingAvg);
    map['rating_count'] = Variable<int>(ratingCount);
    map['status'] = Variable<String>(status);
    if (!nullToAbsent || publishedAt != null) {
      map['published_at'] = Variable<DateTime>(publishedAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      slug: Value(slug),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      cuisine: cuisine == null && nullToAbsent
          ? const Value.absent()
          : Value(cuisine),
      mealType: Value(mealType),
      difficulty: Value(difficulty),
      prepMinutes: prepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(prepMinutes),
      cookMinutes: cookMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(cookMinutes),
      totalMinutes: totalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(totalMinutes),
      baseServings: Value(baseServings),
      caloriesPerServing: caloriesPerServing == null && nullToAbsent
          ? const Value.absent()
          : Value(caloriesPerServing),
      equipment: Value(equipment),
      dietFlags: Value(dietFlags),
      allergens: Value(allergens),
      sourceType: Value(sourceType),
      verified: Value(verified),
      heroImageUrl: heroImageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(heroImageUrl),
      blurhash: blurhash == null && nullToAbsent
          ? const Value.absent()
          : Value(blurhash),
      ratingAvg: Value(ratingAvg),
      ratingCount: Value(ratingCount),
      status: Value(status),
      publishedAt: publishedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(publishedAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      slug: serializer.fromJson<String>(json['slug']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      cuisine: serializer.fromJson<String?>(json['cuisine']),
      mealType: serializer.fromJson<String>(json['mealType']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      prepMinutes: serializer.fromJson<int?>(json['prepMinutes']),
      cookMinutes: serializer.fromJson<int?>(json['cookMinutes']),
      totalMinutes: serializer.fromJson<int?>(json['totalMinutes']),
      baseServings: serializer.fromJson<int>(json['baseServings']),
      caloriesPerServing: serializer.fromJson<int?>(json['caloriesPerServing']),
      equipment: serializer.fromJson<String>(json['equipment']),
      dietFlags: serializer.fromJson<String>(json['dietFlags']),
      allergens: serializer.fromJson<String>(json['allergens']),
      sourceType: serializer.fromJson<String>(json['sourceType']),
      verified: serializer.fromJson<bool>(json['verified']),
      heroImageUrl: serializer.fromJson<String?>(json['heroImageUrl']),
      blurhash: serializer.fromJson<String?>(json['blurhash']),
      ratingAvg: serializer.fromJson<double>(json['ratingAvg']),
      ratingCount: serializer.fromJson<int>(json['ratingCount']),
      status: serializer.fromJson<String>(json['status']),
      publishedAt: serializer.fromJson<DateTime?>(json['publishedAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'slug': serializer.toJson<String>(slug),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'cuisine': serializer.toJson<String?>(cuisine),
      'mealType': serializer.toJson<String>(mealType),
      'difficulty': serializer.toJson<int>(difficulty),
      'prepMinutes': serializer.toJson<int?>(prepMinutes),
      'cookMinutes': serializer.toJson<int?>(cookMinutes),
      'totalMinutes': serializer.toJson<int?>(totalMinutes),
      'baseServings': serializer.toJson<int>(baseServings),
      'caloriesPerServing': serializer.toJson<int?>(caloriesPerServing),
      'equipment': serializer.toJson<String>(equipment),
      'dietFlags': serializer.toJson<String>(dietFlags),
      'allergens': serializer.toJson<String>(allergens),
      'sourceType': serializer.toJson<String>(sourceType),
      'verified': serializer.toJson<bool>(verified),
      'heroImageUrl': serializer.toJson<String?>(heroImageUrl),
      'blurhash': serializer.toJson<String?>(blurhash),
      'ratingAvg': serializer.toJson<double>(ratingAvg),
      'ratingCount': serializer.toJson<int>(ratingCount),
      'status': serializer.toJson<String>(status),
      'publishedAt': serializer.toJson<DateTime?>(publishedAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Recipe copyWith({
    String? id,
    String? slug,
    String? title,
    Value<String?> description = const Value.absent(),
    Value<String?> cuisine = const Value.absent(),
    String? mealType,
    int? difficulty,
    Value<int?> prepMinutes = const Value.absent(),
    Value<int?> cookMinutes = const Value.absent(),
    Value<int?> totalMinutes = const Value.absent(),
    int? baseServings,
    Value<int?> caloriesPerServing = const Value.absent(),
    String? equipment,
    String? dietFlags,
    String? allergens,
    String? sourceType,
    bool? verified,
    Value<String?> heroImageUrl = const Value.absent(),
    Value<String?> blurhash = const Value.absent(),
    double? ratingAvg,
    int? ratingCount,
    String? status,
    Value<DateTime?> publishedAt = const Value.absent(),
    DateTime? updatedAt,
  }) => Recipe(
    id: id ?? this.id,
    slug: slug ?? this.slug,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    cuisine: cuisine.present ? cuisine.value : this.cuisine,
    mealType: mealType ?? this.mealType,
    difficulty: difficulty ?? this.difficulty,
    prepMinutes: prepMinutes.present ? prepMinutes.value : this.prepMinutes,
    cookMinutes: cookMinutes.present ? cookMinutes.value : this.cookMinutes,
    totalMinutes: totalMinutes.present ? totalMinutes.value : this.totalMinutes,
    baseServings: baseServings ?? this.baseServings,
    caloriesPerServing: caloriesPerServing.present
        ? caloriesPerServing.value
        : this.caloriesPerServing,
    equipment: equipment ?? this.equipment,
    dietFlags: dietFlags ?? this.dietFlags,
    allergens: allergens ?? this.allergens,
    sourceType: sourceType ?? this.sourceType,
    verified: verified ?? this.verified,
    heroImageUrl: heroImageUrl.present ? heroImageUrl.value : this.heroImageUrl,
    blurhash: blurhash.present ? blurhash.value : this.blurhash,
    ratingAvg: ratingAvg ?? this.ratingAvg,
    ratingCount: ratingCount ?? this.ratingCount,
    status: status ?? this.status,
    publishedAt: publishedAt.present ? publishedAt.value : this.publishedAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      slug: data.slug.present ? data.slug.value : this.slug,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      cuisine: data.cuisine.present ? data.cuisine.value : this.cuisine,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      prepMinutes: data.prepMinutes.present
          ? data.prepMinutes.value
          : this.prepMinutes,
      cookMinutes: data.cookMinutes.present
          ? data.cookMinutes.value
          : this.cookMinutes,
      totalMinutes: data.totalMinutes.present
          ? data.totalMinutes.value
          : this.totalMinutes,
      baseServings: data.baseServings.present
          ? data.baseServings.value
          : this.baseServings,
      caloriesPerServing: data.caloriesPerServing.present
          ? data.caloriesPerServing.value
          : this.caloriesPerServing,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      dietFlags: data.dietFlags.present ? data.dietFlags.value : this.dietFlags,
      allergens: data.allergens.present ? data.allergens.value : this.allergens,
      sourceType: data.sourceType.present
          ? data.sourceType.value
          : this.sourceType,
      verified: data.verified.present ? data.verified.value : this.verified,
      heroImageUrl: data.heroImageUrl.present
          ? data.heroImageUrl.value
          : this.heroImageUrl,
      blurhash: data.blurhash.present ? data.blurhash.value : this.blurhash,
      ratingAvg: data.ratingAvg.present ? data.ratingAvg.value : this.ratingAvg,
      ratingCount: data.ratingCount.present
          ? data.ratingCount.value
          : this.ratingCount,
      status: data.status.present ? data.status.value : this.status,
      publishedAt: data.publishedAt.present
          ? data.publishedAt.value
          : this.publishedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('cuisine: $cuisine, ')
          ..write('mealType: $mealType, ')
          ..write('difficulty: $difficulty, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('cookMinutes: $cookMinutes, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('baseServings: $baseServings, ')
          ..write('caloriesPerServing: $caloriesPerServing, ')
          ..write('equipment: $equipment, ')
          ..write('dietFlags: $dietFlags, ')
          ..write('allergens: $allergens, ')
          ..write('sourceType: $sourceType, ')
          ..write('verified: $verified, ')
          ..write('heroImageUrl: $heroImageUrl, ')
          ..write('blurhash: $blurhash, ')
          ..write('ratingAvg: $ratingAvg, ')
          ..write('ratingCount: $ratingCount, ')
          ..write('status: $status, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    slug,
    title,
    description,
    cuisine,
    mealType,
    difficulty,
    prepMinutes,
    cookMinutes,
    totalMinutes,
    baseServings,
    caloriesPerServing,
    equipment,
    dietFlags,
    allergens,
    sourceType,
    verified,
    heroImageUrl,
    blurhash,
    ratingAvg,
    ratingCount,
    status,
    publishedAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.slug == this.slug &&
          other.title == this.title &&
          other.description == this.description &&
          other.cuisine == this.cuisine &&
          other.mealType == this.mealType &&
          other.difficulty == this.difficulty &&
          other.prepMinutes == this.prepMinutes &&
          other.cookMinutes == this.cookMinutes &&
          other.totalMinutes == this.totalMinutes &&
          other.baseServings == this.baseServings &&
          other.caloriesPerServing == this.caloriesPerServing &&
          other.equipment == this.equipment &&
          other.dietFlags == this.dietFlags &&
          other.allergens == this.allergens &&
          other.sourceType == this.sourceType &&
          other.verified == this.verified &&
          other.heroImageUrl == this.heroImageUrl &&
          other.blurhash == this.blurhash &&
          other.ratingAvg == this.ratingAvg &&
          other.ratingCount == this.ratingCount &&
          other.status == this.status &&
          other.publishedAt == this.publishedAt &&
          other.updatedAt == this.updatedAt);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<String> slug;
  final Value<String> title;
  final Value<String?> description;
  final Value<String?> cuisine;
  final Value<String> mealType;
  final Value<int> difficulty;
  final Value<int?> prepMinutes;
  final Value<int?> cookMinutes;
  final Value<int?> totalMinutes;
  final Value<int> baseServings;
  final Value<int?> caloriesPerServing;
  final Value<String> equipment;
  final Value<String> dietFlags;
  final Value<String> allergens;
  final Value<String> sourceType;
  final Value<bool> verified;
  final Value<String?> heroImageUrl;
  final Value<String?> blurhash;
  final Value<double> ratingAvg;
  final Value<int> ratingCount;
  final Value<String> status;
  final Value<DateTime?> publishedAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.slug = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.cuisine = const Value.absent(),
    this.mealType = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.cookMinutes = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.baseServings = const Value.absent(),
    this.caloriesPerServing = const Value.absent(),
    this.equipment = const Value.absent(),
    this.dietFlags = const Value.absent(),
    this.allergens = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.verified = const Value.absent(),
    this.heroImageUrl = const Value.absent(),
    this.blurhash = const Value.absent(),
    this.ratingAvg = const Value.absent(),
    this.ratingCount = const Value.absent(),
    this.status = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required String slug,
    required String title,
    this.description = const Value.absent(),
    this.cuisine = const Value.absent(),
    this.mealType = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.cookMinutes = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.baseServings = const Value.absent(),
    this.caloriesPerServing = const Value.absent(),
    this.equipment = const Value.absent(),
    this.dietFlags = const Value.absent(),
    this.allergens = const Value.absent(),
    this.sourceType = const Value.absent(),
    this.verified = const Value.absent(),
    this.heroImageUrl = const Value.absent(),
    this.blurhash = const Value.absent(),
    this.ratingAvg = const Value.absent(),
    this.ratingCount = const Value.absent(),
    this.status = const Value.absent(),
    this.publishedAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       slug = Value(slug),
       title = Value(title),
       updatedAt = Value(updatedAt);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<String>? slug,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? cuisine,
    Expression<String>? mealType,
    Expression<int>? difficulty,
    Expression<int>? prepMinutes,
    Expression<int>? cookMinutes,
    Expression<int>? totalMinutes,
    Expression<int>? baseServings,
    Expression<int>? caloriesPerServing,
    Expression<String>? equipment,
    Expression<String>? dietFlags,
    Expression<String>? allergens,
    Expression<String>? sourceType,
    Expression<bool>? verified,
    Expression<String>? heroImageUrl,
    Expression<String>? blurhash,
    Expression<double>? ratingAvg,
    Expression<int>? ratingCount,
    Expression<String>? status,
    Expression<DateTime>? publishedAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slug != null) 'slug': slug,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (cuisine != null) 'cuisine': cuisine,
      if (mealType != null) 'meal_type': mealType,
      if (difficulty != null) 'difficulty': difficulty,
      if (prepMinutes != null) 'prep_minutes': prepMinutes,
      if (cookMinutes != null) 'cook_minutes': cookMinutes,
      if (totalMinutes != null) 'total_minutes': totalMinutes,
      if (baseServings != null) 'base_servings': baseServings,
      if (caloriesPerServing != null)
        'calories_per_serving': caloriesPerServing,
      if (equipment != null) 'equipment': equipment,
      if (dietFlags != null) 'diet_flags': dietFlags,
      if (allergens != null) 'allergens': allergens,
      if (sourceType != null) 'source_type': sourceType,
      if (verified != null) 'verified': verified,
      if (heroImageUrl != null) 'hero_image_url': heroImageUrl,
      if (blurhash != null) 'blurhash': blurhash,
      if (ratingAvg != null) 'rating_avg': ratingAvg,
      if (ratingCount != null) 'rating_count': ratingCount,
      if (status != null) 'status': status,
      if (publishedAt != null) 'published_at': publishedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<String>? slug,
    Value<String>? title,
    Value<String?>? description,
    Value<String?>? cuisine,
    Value<String>? mealType,
    Value<int>? difficulty,
    Value<int?>? prepMinutes,
    Value<int?>? cookMinutes,
    Value<int?>? totalMinutes,
    Value<int>? baseServings,
    Value<int?>? caloriesPerServing,
    Value<String>? equipment,
    Value<String>? dietFlags,
    Value<String>? allergens,
    Value<String>? sourceType,
    Value<bool>? verified,
    Value<String?>? heroImageUrl,
    Value<String?>? blurhash,
    Value<double>? ratingAvg,
    Value<int>? ratingCount,
    Value<String>? status,
    Value<DateTime?>? publishedAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      slug: slug ?? this.slug,
      title: title ?? this.title,
      description: description ?? this.description,
      cuisine: cuisine ?? this.cuisine,
      mealType: mealType ?? this.mealType,
      difficulty: difficulty ?? this.difficulty,
      prepMinutes: prepMinutes ?? this.prepMinutes,
      cookMinutes: cookMinutes ?? this.cookMinutes,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      baseServings: baseServings ?? this.baseServings,
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
      equipment: equipment ?? this.equipment,
      dietFlags: dietFlags ?? this.dietFlags,
      allergens: allergens ?? this.allergens,
      sourceType: sourceType ?? this.sourceType,
      verified: verified ?? this.verified,
      heroImageUrl: heroImageUrl ?? this.heroImageUrl,
      blurhash: blurhash ?? this.blurhash,
      ratingAvg: ratingAvg ?? this.ratingAvg,
      ratingCount: ratingCount ?? this.ratingCount,
      status: status ?? this.status,
      publishedAt: publishedAt ?? this.publishedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (cuisine.present) {
      map['cuisine'] = Variable<String>(cuisine.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (prepMinutes.present) {
      map['prep_minutes'] = Variable<int>(prepMinutes.value);
    }
    if (cookMinutes.present) {
      map['cook_minutes'] = Variable<int>(cookMinutes.value);
    }
    if (totalMinutes.present) {
      map['total_minutes'] = Variable<int>(totalMinutes.value);
    }
    if (baseServings.present) {
      map['base_servings'] = Variable<int>(baseServings.value);
    }
    if (caloriesPerServing.present) {
      map['calories_per_serving'] = Variable<int>(caloriesPerServing.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (dietFlags.present) {
      map['diet_flags'] = Variable<String>(dietFlags.value);
    }
    if (allergens.present) {
      map['allergens'] = Variable<String>(allergens.value);
    }
    if (sourceType.present) {
      map['source_type'] = Variable<String>(sourceType.value);
    }
    if (verified.present) {
      map['verified'] = Variable<bool>(verified.value);
    }
    if (heroImageUrl.present) {
      map['hero_image_url'] = Variable<String>(heroImageUrl.value);
    }
    if (blurhash.present) {
      map['blurhash'] = Variable<String>(blurhash.value);
    }
    if (ratingAvg.present) {
      map['rating_avg'] = Variable<double>(ratingAvg.value);
    }
    if (ratingCount.present) {
      map['rating_count'] = Variable<int>(ratingCount.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<DateTime>(publishedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('slug: $slug, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('cuisine: $cuisine, ')
          ..write('mealType: $mealType, ')
          ..write('difficulty: $difficulty, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('cookMinutes: $cookMinutes, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('baseServings: $baseServings, ')
          ..write('caloriesPerServing: $caloriesPerServing, ')
          ..write('equipment: $equipment, ')
          ..write('dietFlags: $dietFlags, ')
          ..write('allergens: $allergens, ')
          ..write('sourceType: $sourceType, ')
          ..write('verified: $verified, ')
          ..write('heroImageUrl: $heroImageUrl, ')
          ..write('blurhash: $blurhash, ')
          ..write('ratingAvg: $ratingAvg, ')
          ..write('ratingCount: $ratingCount, ')
          ..write('status: $status, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeIngredientsTable extends RecipeIngredients
    with TableInfo<$RecipeIngredientsTable, RecipeIngredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeIngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayTextMeta = const VerificationMeta(
    'displayText',
  );
  @override
  late final GeneratedColumn<String> displayText = GeneratedColumn<String>(
    'display_text',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _groupLabelMeta = const VerificationMeta(
    'groupLabel',
  );
  @override
  late final GeneratedColumn<String> groupLabel = GeneratedColumn<String>(
    'group_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    recipeId,
    ingredientId,
    role,
    amount,
    unit,
    displayText,
    groupLabel,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeIngredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('display_text')) {
      context.handle(
        _displayTextMeta,
        displayText.isAcceptableOrUnknown(
          data['display_text']!,
          _displayTextMeta,
        ),
      );
    }
    if (data.containsKey('group_label')) {
      context.handle(
        _groupLabelMeta,
        groupLabel.isAcceptableOrUnknown(data['group_label']!, _groupLabelMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeId, ingredientId, groupLabel};
  @override
  RecipeIngredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeIngredient(
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      displayText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_text'],
      ),
      groupLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_label'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $RecipeIngredientsTable createAlias(String alias) {
    return $RecipeIngredientsTable(attachedDatabase, alias);
  }
}

class RecipeIngredient extends DataClass
    implements Insertable<RecipeIngredient> {
  final String recipeId;
  final String ingredientId;
  final String role;
  final double? amount;
  final String? unit;
  final String? displayText;
  final String groupLabel;
  final int sortOrder;
  const RecipeIngredient({
    required this.recipeId,
    required this.ingredientId,
    required this.role,
    this.amount,
    this.unit,
    this.displayText,
    required this.groupLabel,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_id'] = Variable<String>(recipeId);
    map['ingredient_id'] = Variable<String>(ingredientId);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || displayText != null) {
      map['display_text'] = Variable<String>(displayText);
    }
    map['group_label'] = Variable<String>(groupLabel);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  RecipeIngredientsCompanion toCompanion(bool nullToAbsent) {
    return RecipeIngredientsCompanion(
      recipeId: Value(recipeId),
      ingredientId: Value(ingredientId),
      role: Value(role),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      displayText: displayText == null && nullToAbsent
          ? const Value.absent()
          : Value(displayText),
      groupLabel: Value(groupLabel),
      sortOrder: Value(sortOrder),
    );
  }

  factory RecipeIngredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeIngredient(
      recipeId: serializer.fromJson<String>(json['recipeId']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      role: serializer.fromJson<String>(json['role']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      displayText: serializer.fromJson<String?>(json['displayText']),
      groupLabel: serializer.fromJson<String>(json['groupLabel']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipeId': serializer.toJson<String>(recipeId),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'role': serializer.toJson<String>(role),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'displayText': serializer.toJson<String?>(displayText),
      'groupLabel': serializer.toJson<String>(groupLabel),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  RecipeIngredient copyWith({
    String? recipeId,
    String? ingredientId,
    String? role,
    Value<double?> amount = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> displayText = const Value.absent(),
    String? groupLabel,
    int? sortOrder,
  }) => RecipeIngredient(
    recipeId: recipeId ?? this.recipeId,
    ingredientId: ingredientId ?? this.ingredientId,
    role: role ?? this.role,
    amount: amount.present ? amount.value : this.amount,
    unit: unit.present ? unit.value : this.unit,
    displayText: displayText.present ? displayText.value : this.displayText,
    groupLabel: groupLabel ?? this.groupLabel,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  RecipeIngredient copyWithCompanion(RecipeIngredientsCompanion data) {
    return RecipeIngredient(
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      role: data.role.present ? data.role.value : this.role,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      displayText: data.displayText.present
          ? data.displayText.value
          : this.displayText,
      groupLabel: data.groupLabel.present
          ? data.groupLabel.value
          : this.groupLabel,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredient(')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('role: $role, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('displayText: $displayText, ')
          ..write('groupLabel: $groupLabel, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    recipeId,
    ingredientId,
    role,
    amount,
    unit,
    displayText,
    groupLabel,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeIngredient &&
          other.recipeId == this.recipeId &&
          other.ingredientId == this.ingredientId &&
          other.role == this.role &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.displayText == this.displayText &&
          other.groupLabel == this.groupLabel &&
          other.sortOrder == this.sortOrder);
}

class RecipeIngredientsCompanion extends UpdateCompanion<RecipeIngredient> {
  final Value<String> recipeId;
  final Value<String> ingredientId;
  final Value<String> role;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> displayText;
  final Value<String> groupLabel;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const RecipeIngredientsCompanion({
    this.recipeId = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.role = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.displayText = const Value.absent(),
    this.groupLabel = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeIngredientsCompanion.insert({
    required String recipeId,
    required String ingredientId,
    required String role,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.displayText = const Value.absent(),
    this.groupLabel = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : recipeId = Value(recipeId),
       ingredientId = Value(ingredientId),
       role = Value(role);
  static Insertable<RecipeIngredient> custom({
    Expression<String>? recipeId,
    Expression<String>? ingredientId,
    Expression<String>? role,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? displayText,
    Expression<String>? groupLabel,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeId != null) 'recipe_id': recipeId,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (role != null) 'role': role,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (displayText != null) 'display_text': displayText,
      if (groupLabel != null) 'group_label': groupLabel,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeIngredientsCompanion copyWith({
    Value<String>? recipeId,
    Value<String>? ingredientId,
    Value<String>? role,
    Value<double?>? amount,
    Value<String?>? unit,
    Value<String?>? displayText,
    Value<String>? groupLabel,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return RecipeIngredientsCompanion(
      recipeId: recipeId ?? this.recipeId,
      ingredientId: ingredientId ?? this.ingredientId,
      role: role ?? this.role,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      displayText: displayText ?? this.displayText,
      groupLabel: groupLabel ?? this.groupLabel,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (displayText.present) {
      map['display_text'] = Variable<String>(displayText.value);
    }
    if (groupLabel.present) {
      map['group_label'] = Variable<String>(groupLabel.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeIngredientsCompanion(')
          ..write('recipeId: $recipeId, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('role: $role, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('displayText: $displayText, ')
          ..write('groupLabel: $groupLabel, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeStepsTable extends RecipeSteps
    with TableInfo<$RecipeStepsTable, RecipeStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _stepNoMeta = const VerificationMeta('stepNo');
  @override
  late final GeneratedColumn<int> stepNo = GeneratedColumn<int>(
    'step_no',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepTextMeta = const VerificationMeta(
    'stepText',
  );
  @override
  late final GeneratedColumn<String> stepText = GeneratedColumn<String>(
    'step_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _imageUrlMeta = const VerificationMeta(
    'imageUrl',
  );
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
    'image_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _timerSecondsMeta = const VerificationMeta(
    'timerSeconds',
  );
  @override
  late final GeneratedColumn<int> timerSeconds = GeneratedColumn<int>(
    'timer_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tipMeta = const VerificationMeta('tip');
  @override
  late final GeneratedColumn<String> tip = GeneratedColumn<String>(
    'tip',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    recipeId,
    stepNo,
    stepText,
    imageUrl,
    timerSeconds,
    tip,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('step_no')) {
      context.handle(
        _stepNoMeta,
        stepNo.isAcceptableOrUnknown(data['step_no']!, _stepNoMeta),
      );
    } else if (isInserting) {
      context.missing(_stepNoMeta);
    }
    if (data.containsKey('step_text')) {
      context.handle(
        _stepTextMeta,
        stepText.isAcceptableOrUnknown(data['step_text']!, _stepTextMeta),
      );
    } else if (isInserting) {
      context.missing(_stepTextMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(
        _imageUrlMeta,
        imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta),
      );
    }
    if (data.containsKey('timer_seconds')) {
      context.handle(
        _timerSecondsMeta,
        timerSeconds.isAcceptableOrUnknown(
          data['timer_seconds']!,
          _timerSecondsMeta,
        ),
      );
    }
    if (data.containsKey('tip')) {
      context.handle(
        _tipMeta,
        tip.isAcceptableOrUnknown(data['tip']!, _tipMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeId, stepNo};
  @override
  RecipeStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeStep(
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      stepNo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_no'],
      )!,
      stepText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}step_text'],
      )!,
      imageUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_url'],
      ),
      timerSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timer_seconds'],
      ),
      tip: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tip'],
      ),
    );
  }

  @override
  $RecipeStepsTable createAlias(String alias) {
    return $RecipeStepsTable(attachedDatabase, alias);
  }
}

class RecipeStep extends DataClass implements Insertable<RecipeStep> {
  final String recipeId;
  final int stepNo;
  final String stepText;
  final String? imageUrl;
  final int? timerSeconds;
  final String? tip;
  const RecipeStep({
    required this.recipeId,
    required this.stepNo,
    required this.stepText,
    this.imageUrl,
    this.timerSeconds,
    this.tip,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_id'] = Variable<String>(recipeId);
    map['step_no'] = Variable<int>(stepNo);
    map['step_text'] = Variable<String>(stepText);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    if (!nullToAbsent || timerSeconds != null) {
      map['timer_seconds'] = Variable<int>(timerSeconds);
    }
    if (!nullToAbsent || tip != null) {
      map['tip'] = Variable<String>(tip);
    }
    return map;
  }

  RecipeStepsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepsCompanion(
      recipeId: Value(recipeId),
      stepNo: Value(stepNo),
      stepText: Value(stepText),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      timerSeconds: timerSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(timerSeconds),
      tip: tip == null && nullToAbsent ? const Value.absent() : Value(tip),
    );
  }

  factory RecipeStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeStep(
      recipeId: serializer.fromJson<String>(json['recipeId']),
      stepNo: serializer.fromJson<int>(json['stepNo']),
      stepText: serializer.fromJson<String>(json['stepText']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      timerSeconds: serializer.fromJson<int?>(json['timerSeconds']),
      tip: serializer.fromJson<String?>(json['tip']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipeId': serializer.toJson<String>(recipeId),
      'stepNo': serializer.toJson<int>(stepNo),
      'stepText': serializer.toJson<String>(stepText),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'timerSeconds': serializer.toJson<int?>(timerSeconds),
      'tip': serializer.toJson<String?>(tip),
    };
  }

  RecipeStep copyWith({
    String? recipeId,
    int? stepNo,
    String? stepText,
    Value<String?> imageUrl = const Value.absent(),
    Value<int?> timerSeconds = const Value.absent(),
    Value<String?> tip = const Value.absent(),
  }) => RecipeStep(
    recipeId: recipeId ?? this.recipeId,
    stepNo: stepNo ?? this.stepNo,
    stepText: stepText ?? this.stepText,
    imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
    timerSeconds: timerSeconds.present ? timerSeconds.value : this.timerSeconds,
    tip: tip.present ? tip.value : this.tip,
  );
  RecipeStep copyWithCompanion(RecipeStepsCompanion data) {
    return RecipeStep(
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      stepNo: data.stepNo.present ? data.stepNo.value : this.stepNo,
      stepText: data.stepText.present ? data.stepText.value : this.stepText,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      timerSeconds: data.timerSeconds.present
          ? data.timerSeconds.value
          : this.timerSeconds,
      tip: data.tip.present ? data.tip.value : this.tip,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStep(')
          ..write('recipeId: $recipeId, ')
          ..write('stepNo: $stepNo, ')
          ..write('stepText: $stepText, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('timerSeconds: $timerSeconds, ')
          ..write('tip: $tip')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(recipeId, stepNo, stepText, imageUrl, timerSeconds, tip);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeStep &&
          other.recipeId == this.recipeId &&
          other.stepNo == this.stepNo &&
          other.stepText == this.stepText &&
          other.imageUrl == this.imageUrl &&
          other.timerSeconds == this.timerSeconds &&
          other.tip == this.tip);
}

class RecipeStepsCompanion extends UpdateCompanion<RecipeStep> {
  final Value<String> recipeId;
  final Value<int> stepNo;
  final Value<String> stepText;
  final Value<String?> imageUrl;
  final Value<int?> timerSeconds;
  final Value<String?> tip;
  final Value<int> rowid;
  const RecipeStepsCompanion({
    this.recipeId = const Value.absent(),
    this.stepNo = const Value.absent(),
    this.stepText = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.timerSeconds = const Value.absent(),
    this.tip = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeStepsCompanion.insert({
    required String recipeId,
    required int stepNo,
    required String stepText,
    this.imageUrl = const Value.absent(),
    this.timerSeconds = const Value.absent(),
    this.tip = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : recipeId = Value(recipeId),
       stepNo = Value(stepNo),
       stepText = Value(stepText);
  static Insertable<RecipeStep> custom({
    Expression<String>? recipeId,
    Expression<int>? stepNo,
    Expression<String>? stepText,
    Expression<String>? imageUrl,
    Expression<int>? timerSeconds,
    Expression<String>? tip,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeId != null) 'recipe_id': recipeId,
      if (stepNo != null) 'step_no': stepNo,
      if (stepText != null) 'step_text': stepText,
      if (imageUrl != null) 'image_url': imageUrl,
      if (timerSeconds != null) 'timer_seconds': timerSeconds,
      if (tip != null) 'tip': tip,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeStepsCompanion copyWith({
    Value<String>? recipeId,
    Value<int>? stepNo,
    Value<String>? stepText,
    Value<String?>? imageUrl,
    Value<int?>? timerSeconds,
    Value<String?>? tip,
    Value<int>? rowid,
  }) {
    return RecipeStepsCompanion(
      recipeId: recipeId ?? this.recipeId,
      stepNo: stepNo ?? this.stepNo,
      stepText: stepText ?? this.stepText,
      imageUrl: imageUrl ?? this.imageUrl,
      timerSeconds: timerSeconds ?? this.timerSeconds,
      tip: tip ?? this.tip,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (stepNo.present) {
      map['step_no'] = Variable<int>(stepNo.value);
    }
    if (stepText.present) {
      map['step_text'] = Variable<String>(stepText.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (timerSeconds.present) {
      map['timer_seconds'] = Variable<int>(timerSeconds.value);
    }
    if (tip.present) {
      map['tip'] = Variable<String>(tip.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepsCompanion(')
          ..write('recipeId: $recipeId, ')
          ..write('stepNo: $stepNo, ')
          ..write('stepText: $stepText, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('timerSeconds: $timerSeconds, ')
          ..write('tip: $tip, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PantryItemsTable extends PantryItems
    with TableInfo<$PantryItemsTable, PantryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PantryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES ingredients (id)',
    ),
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _expiresOnMeta = const VerificationMeta(
    'expiresOn',
  );
  @override
  late final GeneratedColumn<DateTime> expiresOn = GeneratedColumn<DateTime>(
    'expires_on',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ingredientId,
    quantity,
    unit,
    location,
    addedAt,
    expiresOn,
    source,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pantry_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<PantryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ingredientIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('expires_on')) {
      context.handle(
        _expiresOnMeta,
        expiresOn.isAcceptableOrUnknown(data['expires_on']!, _expiresOnMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PantryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PantryItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      expiresOn: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}expires_on'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $PantryItemsTable createAlias(String alias) {
    return $PantryItemsTable(attachedDatabase, alias);
  }
}

class PantryItem extends DataClass implements Insertable<PantryItem> {
  final String id;
  final String ingredientId;
  final double? quantity;
  final String? unit;
  final String? location;
  final DateTime addedAt;
  final DateTime? expiresOn;
  final String source;
  final bool isSynced;
  const PantryItem({
    required this.id,
    required this.ingredientId,
    this.quantity,
    this.unit,
    this.location,
    required this.addedAt,
    this.expiresOn,
    required this.source,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['ingredient_id'] = Variable<String>(ingredientId);
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    if (!nullToAbsent || expiresOn != null) {
      map['expires_on'] = Variable<DateTime>(expiresOn);
    }
    map['source'] = Variable<String>(source);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  PantryItemsCompanion toCompanion(bool nullToAbsent) {
    return PantryItemsCompanion(
      id: Value(id),
      ingredientId: Value(ingredientId),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      addedAt: Value(addedAt),
      expiresOn: expiresOn == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresOn),
      source: Value(source),
      isSynced: Value(isSynced),
    );
  }

  factory PantryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PantryItem(
      id: serializer.fromJson<String>(json['id']),
      ingredientId: serializer.fromJson<String>(json['ingredientId']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      location: serializer.fromJson<String?>(json['location']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      expiresOn: serializer.fromJson<DateTime?>(json['expiresOn']),
      source: serializer.fromJson<String>(json['source']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ingredientId': serializer.toJson<String>(ingredientId),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'location': serializer.toJson<String?>(location),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'expiresOn': serializer.toJson<DateTime?>(expiresOn),
      'source': serializer.toJson<String>(source),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  PantryItem copyWith({
    String? id,
    String? ingredientId,
    Value<double?> quantity = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> location = const Value.absent(),
    DateTime? addedAt,
    Value<DateTime?> expiresOn = const Value.absent(),
    String? source,
    bool? isSynced,
  }) => PantryItem(
    id: id ?? this.id,
    ingredientId: ingredientId ?? this.ingredientId,
    quantity: quantity.present ? quantity.value : this.quantity,
    unit: unit.present ? unit.value : this.unit,
    location: location.present ? location.value : this.location,
    addedAt: addedAt ?? this.addedAt,
    expiresOn: expiresOn.present ? expiresOn.value : this.expiresOn,
    source: source ?? this.source,
    isSynced: isSynced ?? this.isSynced,
  );
  PantryItem copyWithCompanion(PantryItemsCompanion data) {
    return PantryItem(
      id: data.id.present ? data.id.value : this.id,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      location: data.location.present ? data.location.value : this.location,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      expiresOn: data.expiresOn.present ? data.expiresOn.value : this.expiresOn,
      source: data.source.present ? data.source.value : this.source,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PantryItem(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('location: $location, ')
          ..write('addedAt: $addedAt, ')
          ..write('expiresOn: $expiresOn, ')
          ..write('source: $source, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ingredientId,
    quantity,
    unit,
    location,
    addedAt,
    expiresOn,
    source,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PantryItem &&
          other.id == this.id &&
          other.ingredientId == this.ingredientId &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.location == this.location &&
          other.addedAt == this.addedAt &&
          other.expiresOn == this.expiresOn &&
          other.source == this.source &&
          other.isSynced == this.isSynced);
}

class PantryItemsCompanion extends UpdateCompanion<PantryItem> {
  final Value<String> id;
  final Value<String> ingredientId;
  final Value<double?> quantity;
  final Value<String?> unit;
  final Value<String?> location;
  final Value<DateTime> addedAt;
  final Value<DateTime?> expiresOn;
  final Value<String> source;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const PantryItemsCompanion({
    this.id = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.location = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.expiresOn = const Value.absent(),
    this.source = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PantryItemsCompanion.insert({
    required String id,
    required String ingredientId,
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.location = const Value.absent(),
    required DateTime addedAt,
    this.expiresOn = const Value.absent(),
    this.source = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ingredientId = Value(ingredientId),
       addedAt = Value(addedAt);
  static Insertable<PantryItem> custom({
    Expression<String>? id,
    Expression<String>? ingredientId,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? location,
    Expression<DateTime>? addedAt,
    Expression<DateTime>? expiresOn,
    Expression<String>? source,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (location != null) 'location': location,
      if (addedAt != null) 'added_at': addedAt,
      if (expiresOn != null) 'expires_on': expiresOn,
      if (source != null) 'source': source,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PantryItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? ingredientId,
    Value<double?>? quantity,
    Value<String?>? unit,
    Value<String?>? location,
    Value<DateTime>? addedAt,
    Value<DateTime?>? expiresOn,
    Value<String>? source,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return PantryItemsCompanion(
      id: id ?? this.id,
      ingredientId: ingredientId ?? this.ingredientId,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      location: location ?? this.location,
      addedAt: addedAt ?? this.addedAt,
      expiresOn: expiresOn ?? this.expiresOn,
      source: source ?? this.source,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (expiresOn.present) {
      map['expires_on'] = Variable<DateTime>(expiresOn.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PantryItemsCompanion(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('location: $location, ')
          ..write('addedAt: $addedAt, ')
          ..write('expiresOn: $expiresOn, ')
          ..write('source: $source, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FavoritesTable extends Favorites
    with TableInfo<$FavoritesTable, Favorite> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoritesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [recipeId, createdAt, isSynced];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorites';
  @override
  VerificationContext validateIntegrity(
    Insertable<Favorite> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recipeId};
  @override
  Favorite map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Favorite(
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $FavoritesTable createAlias(String alias) {
    return $FavoritesTable(attachedDatabase, alias);
  }
}

class Favorite extends DataClass implements Insertable<Favorite> {
  final String recipeId;
  final DateTime createdAt;
  final bool isSynced;
  const Favorite({
    required this.recipeId,
    required this.createdAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['recipe_id'] = Variable<String>(recipeId);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  FavoritesCompanion toCompanion(bool nullToAbsent) {
    return FavoritesCompanion(
      recipeId: Value(recipeId),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
    );
  }

  factory Favorite.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Favorite(
      recipeId: serializer.fromJson<String>(json['recipeId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recipeId': serializer.toJson<String>(recipeId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  Favorite copyWith({String? recipeId, DateTime? createdAt, bool? isSynced}) =>
      Favorite(
        recipeId: recipeId ?? this.recipeId,
        createdAt: createdAt ?? this.createdAt,
        isSynced: isSynced ?? this.isSynced,
      );
  Favorite copyWithCompanion(FavoritesCompanion data) {
    return Favorite(
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Favorite(')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(recipeId, createdAt, isSynced);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Favorite &&
          other.recipeId == this.recipeId &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced);
}

class FavoritesCompanion extends UpdateCompanion<Favorite> {
  final Value<String> recipeId;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const FavoritesCompanion({
    this.recipeId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoritesCompanion.insert({
    required String recipeId,
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : recipeId = Value(recipeId),
       createdAt = Value(createdAt);
  static Insertable<Favorite> custom({
    Expression<String>? recipeId,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recipeId != null) 'recipe_id': recipeId,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoritesCompanion copyWith({
    Value<String>? recipeId,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return FavoritesCompanion(
      recipeId: recipeId ?? this.recipeId,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoritesCompanion(')
          ..write('recipeId: $recipeId, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CookSessionsTable extends CookSessions
    with TableInfo<$CookSessionsTable, CookSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CookSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id)',
    ),
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    startedAt,
    completedAt,
    servings,
    rating,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cook_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<CookSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CookSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CookSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $CookSessionsTable createAlias(String alias) {
    return $CookSessionsTable(attachedDatabase, alias);
  }
}

class CookSession extends DataClass implements Insertable<CookSession> {
  final String id;
  final String recipeId;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? servings;
  final int? rating;
  final bool isSynced;
  const CookSession({
    required this.id,
    required this.recipeId,
    required this.startedAt,
    this.completedAt,
    this.servings,
    this.rating,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['recipe_id'] = Variable<String>(recipeId);
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || servings != null) {
      map['servings'] = Variable<int>(servings);
    }
    if (!nullToAbsent || rating != null) {
      map['rating'] = Variable<int>(rating);
    }
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  CookSessionsCompanion toCompanion(bool nullToAbsent) {
    return CookSessionsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      servings: servings == null && nullToAbsent
          ? const Value.absent()
          : Value(servings),
      rating: rating == null && nullToAbsent
          ? const Value.absent()
          : Value(rating),
      isSynced: Value(isSynced),
    );
  }

  factory CookSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CookSession(
      id: serializer.fromJson<String>(json['id']),
      recipeId: serializer.fromJson<String>(json['recipeId']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      servings: serializer.fromJson<int?>(json['servings']),
      rating: serializer.fromJson<int?>(json['rating']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'recipeId': serializer.toJson<String>(recipeId),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'servings': serializer.toJson<int?>(servings),
      'rating': serializer.toJson<int?>(rating),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  CookSession copyWith({
    String? id,
    String? recipeId,
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> servings = const Value.absent(),
    Value<int?> rating = const Value.absent(),
    bool? isSynced,
  }) => CookSession(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    servings: servings.present ? servings.value : this.servings,
    rating: rating.present ? rating.value : this.rating,
    isSynced: isSynced ?? this.isSynced,
  );
  CookSession copyWithCompanion(CookSessionsCompanion data) {
    return CookSession(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      servings: data.servings.present ? data.servings.value : this.servings,
      rating: data.rating.present ? data.rating.value : this.rating,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CookSession(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('servings: $servings, ')
          ..write('rating: $rating, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recipeId,
    startedAt,
    completedAt,
    servings,
    rating,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CookSession &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.servings == this.servings &&
          other.rating == this.rating &&
          other.isSynced == this.isSynced);
}

class CookSessionsCompanion extends UpdateCompanion<CookSession> {
  final Value<String> id;
  final Value<String> recipeId;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int?> servings;
  final Value<int?> rating;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const CookSessionsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.servings = const Value.absent(),
    this.rating = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CookSessionsCompanion.insert({
    required String id,
    required String recipeId,
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.servings = const Value.absent(),
    this.rating = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       recipeId = Value(recipeId),
       startedAt = Value(startedAt);
  static Insertable<CookSession> custom({
    Expression<String>? id,
    Expression<String>? recipeId,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? servings,
    Expression<int>? rating,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (servings != null) 'servings': servings,
      if (rating != null) 'rating': rating,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CookSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? recipeId,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int?>? servings,
    Value<int?>? rating,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return CookSessionsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      servings: servings ?? this.servings,
      rating: rating ?? this.rating,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CookSessionsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('servings: $servings, ')
          ..write('rating: $rating, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ingredientIdMeta = const VerificationMeta(
    'ingredientId',
  );
  @override
  late final GeneratedColumn<String> ingredientId = GeneratedColumn<String>(
    'ingredient_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customNameMeta = const VerificationMeta(
    'customName',
  );
  @override
  late final GeneratedColumn<String> customName = GeneratedColumn<String>(
    'custom_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _checkedMeta = const VerificationMeta(
    'checked',
  );
  @override
  late final GeneratedColumn<bool> checked = GeneratedColumn<bool>(
    'checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceRecipeIdMeta = const VerificationMeta(
    'sourceRecipeId',
  );
  @override
  late final GeneratedColumn<String> sourceRecipeId = GeneratedColumn<String>(
    'source_recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ingredientId,
    customName,
    quantity,
    unit,
    checked,
    sourceRecipeId,
    addedAt,
    isSynced,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('ingredient_id')) {
      context.handle(
        _ingredientIdMeta,
        ingredientId.isAcceptableOrUnknown(
          data['ingredient_id']!,
          _ingredientIdMeta,
        ),
      );
    }
    if (data.containsKey('custom_name')) {
      context.handle(
        _customNameMeta,
        customName.isAcceptableOrUnknown(data['custom_name']!, _customNameMeta),
      );
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('checked')) {
      context.handle(
        _checkedMeta,
        checked.isAcceptableOrUnknown(data['checked']!, _checkedMeta),
      );
    }
    if (data.containsKey('source_recipe_id')) {
      context.handle(
        _sourceRecipeIdMeta,
        sourceRecipeId.isAcceptableOrUnknown(
          data['source_recipe_id']!,
          _sourceRecipeIdMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ingredientId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredient_id'],
      ),
      customName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_name'],
      ),
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      checked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}checked'],
      )!,
      sourceRecipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_recipe_id'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingItem extends DataClass implements Insertable<ShoppingItem> {
  final String id;
  final String? ingredientId;
  final String? customName;
  final double? quantity;
  final String? unit;
  final bool checked;
  final String? sourceRecipeId;
  final DateTime addedAt;
  final bool isSynced;
  const ShoppingItem({
    required this.id,
    this.ingredientId,
    this.customName,
    this.quantity,
    this.unit,
    required this.checked,
    this.sourceRecipeId,
    required this.addedAt,
    required this.isSynced,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || ingredientId != null) {
      map['ingredient_id'] = Variable<String>(ingredientId);
    }
    if (!nullToAbsent || customName != null) {
      map['custom_name'] = Variable<String>(customName);
    }
    if (!nullToAbsent || quantity != null) {
      map['quantity'] = Variable<double>(quantity);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    map['checked'] = Variable<bool>(checked);
    if (!nullToAbsent || sourceRecipeId != null) {
      map['source_recipe_id'] = Variable<String>(sourceRecipeId);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    map['is_synced'] = Variable<bool>(isSynced);
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      ingredientId: ingredientId == null && nullToAbsent
          ? const Value.absent()
          : Value(ingredientId),
      customName: customName == null && nullToAbsent
          ? const Value.absent()
          : Value(customName),
      quantity: quantity == null && nullToAbsent
          ? const Value.absent()
          : Value(quantity),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      checked: Value(checked),
      sourceRecipeId: sourceRecipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRecipeId),
      addedAt: Value(addedAt),
      isSynced: Value(isSynced),
    );
  }

  factory ShoppingItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItem(
      id: serializer.fromJson<String>(json['id']),
      ingredientId: serializer.fromJson<String?>(json['ingredientId']),
      customName: serializer.fromJson<String?>(json['customName']),
      quantity: serializer.fromJson<double?>(json['quantity']),
      unit: serializer.fromJson<String?>(json['unit']),
      checked: serializer.fromJson<bool>(json['checked']),
      sourceRecipeId: serializer.fromJson<String?>(json['sourceRecipeId']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ingredientId': serializer.toJson<String?>(ingredientId),
      'customName': serializer.toJson<String?>(customName),
      'quantity': serializer.toJson<double?>(quantity),
      'unit': serializer.toJson<String?>(unit),
      'checked': serializer.toJson<bool>(checked),
      'sourceRecipeId': serializer.toJson<String?>(sourceRecipeId),
      'addedAt': serializer.toJson<DateTime>(addedAt),
      'isSynced': serializer.toJson<bool>(isSynced),
    };
  }

  ShoppingItem copyWith({
    String? id,
    Value<String?> ingredientId = const Value.absent(),
    Value<String?> customName = const Value.absent(),
    Value<double?> quantity = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    bool? checked,
    Value<String?> sourceRecipeId = const Value.absent(),
    DateTime? addedAt,
    bool? isSynced,
  }) => ShoppingItem(
    id: id ?? this.id,
    ingredientId: ingredientId.present ? ingredientId.value : this.ingredientId,
    customName: customName.present ? customName.value : this.customName,
    quantity: quantity.present ? quantity.value : this.quantity,
    unit: unit.present ? unit.value : this.unit,
    checked: checked ?? this.checked,
    sourceRecipeId: sourceRecipeId.present
        ? sourceRecipeId.value
        : this.sourceRecipeId,
    addedAt: addedAt ?? this.addedAt,
    isSynced: isSynced ?? this.isSynced,
  );
  ShoppingItem copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingItem(
      id: data.id.present ? data.id.value : this.id,
      ingredientId: data.ingredientId.present
          ? data.ingredientId.value
          : this.ingredientId,
      customName: data.customName.present
          ? data.customName.value
          : this.customName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      checked: data.checked.present ? data.checked.value : this.checked,
      sourceRecipeId: data.sourceRecipeId.present
          ? data.sourceRecipeId.value
          : this.sourceRecipeId,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItem(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('customName: $customName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('checked: $checked, ')
          ..write('sourceRecipeId: $sourceRecipeId, ')
          ..write('addedAt: $addedAt, ')
          ..write('isSynced: $isSynced')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ingredientId,
    customName,
    quantity,
    unit,
    checked,
    sourceRecipeId,
    addedAt,
    isSynced,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItem &&
          other.id == this.id &&
          other.ingredientId == this.ingredientId &&
          other.customName == this.customName &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.checked == this.checked &&
          other.sourceRecipeId == this.sourceRecipeId &&
          other.addedAt == this.addedAt &&
          other.isSynced == this.isSynced);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingItem> {
  final Value<String> id;
  final Value<String?> ingredientId;
  final Value<String?> customName;
  final Value<double?> quantity;
  final Value<String?> unit;
  final Value<bool> checked;
  final Value<String?> sourceRecipeId;
  final Value<DateTime> addedAt;
  final Value<bool> isSynced;
  final Value<int> rowid;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.ingredientId = const Value.absent(),
    this.customName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.checked = const Value.absent(),
    this.sourceRecipeId = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    required String id,
    this.ingredientId = const Value.absent(),
    this.customName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.checked = const Value.absent(),
    this.sourceRecipeId = const Value.absent(),
    required DateTime addedAt,
    this.isSynced = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       addedAt = Value(addedAt);
  static Insertable<ShoppingItem> custom({
    Expression<String>? id,
    Expression<String>? ingredientId,
    Expression<String>? customName,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<bool>? checked,
    Expression<String>? sourceRecipeId,
    Expression<DateTime>? addedAt,
    Expression<bool>? isSynced,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ingredientId != null) 'ingredient_id': ingredientId,
      if (customName != null) 'custom_name': customName,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (checked != null) 'checked': checked,
      if (sourceRecipeId != null) 'source_recipe_id': sourceRecipeId,
      if (addedAt != null) 'added_at': addedAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingItemsCompanion copyWith({
    Value<String>? id,
    Value<String?>? ingredientId,
    Value<String?>? customName,
    Value<double?>? quantity,
    Value<String?>? unit,
    Value<bool>? checked,
    Value<String?>? sourceRecipeId,
    Value<DateTime>? addedAt,
    Value<bool>? isSynced,
    Value<int>? rowid,
  }) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      ingredientId: ingredientId ?? this.ingredientId,
      customName: customName ?? this.customName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      checked: checked ?? this.checked,
      sourceRecipeId: sourceRecipeId ?? this.sourceRecipeId,
      addedAt: addedAt ?? this.addedAt,
      isSynced: isSynced ?? this.isSynced,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ingredientId.present) {
      map['ingredient_id'] = Variable<String>(ingredientId.value);
    }
    if (customName.present) {
      map['custom_name'] = Variable<String>(customName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (checked.present) {
      map['checked'] = Variable<bool>(checked.value);
    }
    if (sourceRecipeId.present) {
      map['source_recipe_id'] = Variable<String>(sourceRecipeId.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('ingredientId: $ingredientId, ')
          ..write('customName: $customName, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('checked: $checked, ')
          ..write('sourceRecipeId: $sourceRecipeId, ')
          ..write('addedAt: $addedAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTableTable extends UserPreferencesTable
    with TableInfo<$UserPreferencesTableTable, UserPreferencesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('ar'),
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _measurementSystemMeta = const VerificationMeta(
    'measurementSystem',
  );
  @override
  late final GeneratedColumn<String> measurementSystem =
      GeneratedColumn<String>(
        'measurement_system',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('metric'),
      );
  static const VerificationMeta _allergensMeta = const VerificationMeta(
    'allergens',
  );
  @override
  late final GeneratedColumn<String> allergens = GeneratedColumn<String>(
    'allergens',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _dietsMeta = const VerificationMeta('diets');
  @override
  late final GeneratedColumn<String> diets = GeneratedColumn<String>(
    'diets',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _excludedIngredientsMeta =
      const VerificationMeta('excludedIngredients');
  @override
  late final GeneratedColumn<String> excludedIngredients =
      GeneratedColumn<String>(
        'excluded_ingredients',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _householdSizeMeta = const VerificationMeta(
    'householdSize',
  );
  @override
  late final GeneratedColumn<int> householdSize = GeneratedColumn<int>(
    'household_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _assumeStaplesMeta = const VerificationMeta(
    'assumeStaples',
  );
  @override
  late final GeneratedColumn<bool> assumeStaples = GeneratedColumn<bool>(
    'assume_staples',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("assume_staples" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _equipmentMeta = const VerificationMeta(
    'equipment',
  );
  @override
  late final GeneratedColumn<String> equipment = GeneratedColumn<String>(
    'equipment',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    locale,
    region,
    measurementSystem,
    allergens,
    diets,
    excludedIngredients,
    householdSize,
    assumeStaples,
    equipment,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserPreferencesTableData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('measurement_system')) {
      context.handle(
        _measurementSystemMeta,
        measurementSystem.isAcceptableOrUnknown(
          data['measurement_system']!,
          _measurementSystemMeta,
        ),
      );
    }
    if (data.containsKey('allergens')) {
      context.handle(
        _allergensMeta,
        allergens.isAcceptableOrUnknown(data['allergens']!, _allergensMeta),
      );
    }
    if (data.containsKey('diets')) {
      context.handle(
        _dietsMeta,
        diets.isAcceptableOrUnknown(data['diets']!, _dietsMeta),
      );
    }
    if (data.containsKey('excluded_ingredients')) {
      context.handle(
        _excludedIngredientsMeta,
        excludedIngredients.isAcceptableOrUnknown(
          data['excluded_ingredients']!,
          _excludedIngredientsMeta,
        ),
      );
    }
    if (data.containsKey('household_size')) {
      context.handle(
        _householdSizeMeta,
        householdSize.isAcceptableOrUnknown(
          data['household_size']!,
          _householdSizeMeta,
        ),
      );
    }
    if (data.containsKey('assume_staples')) {
      context.handle(
        _assumeStaplesMeta,
        assumeStaples.isAcceptableOrUnknown(
          data['assume_staples']!,
          _assumeStaplesMeta,
        ),
      );
    }
    if (data.containsKey('equipment')) {
      context.handle(
        _equipmentMeta,
        equipment.isAcceptableOrUnknown(data['equipment']!, _equipmentMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreferencesTableData map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreferencesTableData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      measurementSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}measurement_system'],
      )!,
      allergens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergens'],
      )!,
      diets: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diets'],
      )!,
      excludedIngredients: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}excluded_ingredients'],
      )!,
      householdSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}household_size'],
      )!,
      assumeStaples: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}assume_staples'],
      )!,
      equipment: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}equipment'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserPreferencesTableTable createAlias(String alias) {
    return $UserPreferencesTableTable(attachedDatabase, alias);
  }
}

class UserPreferencesTableData extends DataClass
    implements Insertable<UserPreferencesTableData> {
  final int id;
  final String locale;
  final String? region;
  final String measurementSystem;
  final String allergens;
  final String diets;
  final String excludedIngredients;
  final int householdSize;
  final bool assumeStaples;
  final String equipment;
  final DateTime updatedAt;
  const UserPreferencesTableData({
    required this.id,
    required this.locale,
    this.region,
    required this.measurementSystem,
    required this.allergens,
    required this.diets,
    required this.excludedIngredients,
    required this.householdSize,
    required this.assumeStaples,
    required this.equipment,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['locale'] = Variable<String>(locale);
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    map['measurement_system'] = Variable<String>(measurementSystem);
    map['allergens'] = Variable<String>(allergens);
    map['diets'] = Variable<String>(diets);
    map['excluded_ingredients'] = Variable<String>(excludedIngredients);
    map['household_size'] = Variable<int>(householdSize);
    map['assume_staples'] = Variable<bool>(assumeStaples);
    map['equipment'] = Variable<String>(equipment);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserPreferencesTableCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesTableCompanion(
      id: Value(id),
      locale: Value(locale),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      measurementSystem: Value(measurementSystem),
      allergens: Value(allergens),
      diets: Value(diets),
      excludedIngredients: Value(excludedIngredients),
      householdSize: Value(householdSize),
      assumeStaples: Value(assumeStaples),
      equipment: Value(equipment),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserPreferencesTableData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreferencesTableData(
      id: serializer.fromJson<int>(json['id']),
      locale: serializer.fromJson<String>(json['locale']),
      region: serializer.fromJson<String?>(json['region']),
      measurementSystem: serializer.fromJson<String>(json['measurementSystem']),
      allergens: serializer.fromJson<String>(json['allergens']),
      diets: serializer.fromJson<String>(json['diets']),
      excludedIngredients: serializer.fromJson<String>(
        json['excludedIngredients'],
      ),
      householdSize: serializer.fromJson<int>(json['householdSize']),
      assumeStaples: serializer.fromJson<bool>(json['assumeStaples']),
      equipment: serializer.fromJson<String>(json['equipment']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'locale': serializer.toJson<String>(locale),
      'region': serializer.toJson<String?>(region),
      'measurementSystem': serializer.toJson<String>(measurementSystem),
      'allergens': serializer.toJson<String>(allergens),
      'diets': serializer.toJson<String>(diets),
      'excludedIngredients': serializer.toJson<String>(excludedIngredients),
      'householdSize': serializer.toJson<int>(householdSize),
      'assumeStaples': serializer.toJson<bool>(assumeStaples),
      'equipment': serializer.toJson<String>(equipment),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserPreferencesTableData copyWith({
    int? id,
    String? locale,
    Value<String?> region = const Value.absent(),
    String? measurementSystem,
    String? allergens,
    String? diets,
    String? excludedIngredients,
    int? householdSize,
    bool? assumeStaples,
    String? equipment,
    DateTime? updatedAt,
  }) => UserPreferencesTableData(
    id: id ?? this.id,
    locale: locale ?? this.locale,
    region: region.present ? region.value : this.region,
    measurementSystem: measurementSystem ?? this.measurementSystem,
    allergens: allergens ?? this.allergens,
    diets: diets ?? this.diets,
    excludedIngredients: excludedIngredients ?? this.excludedIngredients,
    householdSize: householdSize ?? this.householdSize,
    assumeStaples: assumeStaples ?? this.assumeStaples,
    equipment: equipment ?? this.equipment,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserPreferencesTableData copyWithCompanion(
    UserPreferencesTableCompanion data,
  ) {
    return UserPreferencesTableData(
      id: data.id.present ? data.id.value : this.id,
      locale: data.locale.present ? data.locale.value : this.locale,
      region: data.region.present ? data.region.value : this.region,
      measurementSystem: data.measurementSystem.present
          ? data.measurementSystem.value
          : this.measurementSystem,
      allergens: data.allergens.present ? data.allergens.value : this.allergens,
      diets: data.diets.present ? data.diets.value : this.diets,
      excludedIngredients: data.excludedIngredients.present
          ? data.excludedIngredients.value
          : this.excludedIngredients,
      householdSize: data.householdSize.present
          ? data.householdSize.value
          : this.householdSize,
      assumeStaples: data.assumeStaples.present
          ? data.assumeStaples.value
          : this.assumeStaples,
      equipment: data.equipment.present ? data.equipment.value : this.equipment,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableData(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('region: $region, ')
          ..write('measurementSystem: $measurementSystem, ')
          ..write('allergens: $allergens, ')
          ..write('diets: $diets, ')
          ..write('excludedIngredients: $excludedIngredients, ')
          ..write('householdSize: $householdSize, ')
          ..write('assumeStaples: $assumeStaples, ')
          ..write('equipment: $equipment, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    locale,
    region,
    measurementSystem,
    allergens,
    diets,
    excludedIngredients,
    householdSize,
    assumeStaples,
    equipment,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreferencesTableData &&
          other.id == this.id &&
          other.locale == this.locale &&
          other.region == this.region &&
          other.measurementSystem == this.measurementSystem &&
          other.allergens == this.allergens &&
          other.diets == this.diets &&
          other.excludedIngredients == this.excludedIngredients &&
          other.householdSize == this.householdSize &&
          other.assumeStaples == this.assumeStaples &&
          other.equipment == this.equipment &&
          other.updatedAt == this.updatedAt);
}

class UserPreferencesTableCompanion
    extends UpdateCompanion<UserPreferencesTableData> {
  final Value<int> id;
  final Value<String> locale;
  final Value<String?> region;
  final Value<String> measurementSystem;
  final Value<String> allergens;
  final Value<String> diets;
  final Value<String> excludedIngredients;
  final Value<int> householdSize;
  final Value<bool> assumeStaples;
  final Value<String> equipment;
  final Value<DateTime> updatedAt;
  const UserPreferencesTableCompanion({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.region = const Value.absent(),
    this.measurementSystem = const Value.absent(),
    this.allergens = const Value.absent(),
    this.diets = const Value.absent(),
    this.excludedIngredients = const Value.absent(),
    this.householdSize = const Value.absent(),
    this.assumeStaples = const Value.absent(),
    this.equipment = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  UserPreferencesTableCompanion.insert({
    this.id = const Value.absent(),
    this.locale = const Value.absent(),
    this.region = const Value.absent(),
    this.measurementSystem = const Value.absent(),
    this.allergens = const Value.absent(),
    this.diets = const Value.absent(),
    this.excludedIngredients = const Value.absent(),
    this.householdSize = const Value.absent(),
    this.assumeStaples = const Value.absent(),
    this.equipment = const Value.absent(),
    required DateTime updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<UserPreferencesTableData> custom({
    Expression<int>? id,
    Expression<String>? locale,
    Expression<String>? region,
    Expression<String>? measurementSystem,
    Expression<String>? allergens,
    Expression<String>? diets,
    Expression<String>? excludedIngredients,
    Expression<int>? householdSize,
    Expression<bool>? assumeStaples,
    Expression<String>? equipment,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (locale != null) 'locale': locale,
      if (region != null) 'region': region,
      if (measurementSystem != null) 'measurement_system': measurementSystem,
      if (allergens != null) 'allergens': allergens,
      if (diets != null) 'diets': diets,
      if (excludedIngredients != null)
        'excluded_ingredients': excludedIngredients,
      if (householdSize != null) 'household_size': householdSize,
      if (assumeStaples != null) 'assume_staples': assumeStaples,
      if (equipment != null) 'equipment': equipment,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  UserPreferencesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? locale,
    Value<String?>? region,
    Value<String>? measurementSystem,
    Value<String>? allergens,
    Value<String>? diets,
    Value<String>? excludedIngredients,
    Value<int>? householdSize,
    Value<bool>? assumeStaples,
    Value<String>? equipment,
    Value<DateTime>? updatedAt,
  }) {
    return UserPreferencesTableCompanion(
      id: id ?? this.id,
      locale: locale ?? this.locale,
      region: region ?? this.region,
      measurementSystem: measurementSystem ?? this.measurementSystem,
      allergens: allergens ?? this.allergens,
      diets: diets ?? this.diets,
      excludedIngredients: excludedIngredients ?? this.excludedIngredients,
      householdSize: householdSize ?? this.householdSize,
      assumeStaples: assumeStaples ?? this.assumeStaples,
      equipment: equipment ?? this.equipment,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (measurementSystem.present) {
      map['measurement_system'] = Variable<String>(measurementSystem.value);
    }
    if (allergens.present) {
      map['allergens'] = Variable<String>(allergens.value);
    }
    if (diets.present) {
      map['diets'] = Variable<String>(diets.value);
    }
    if (excludedIngredients.present) {
      map['excluded_ingredients'] = Variable<String>(excludedIngredients.value);
    }
    if (householdSize.present) {
      map['household_size'] = Variable<int>(householdSize.value);
    }
    if (assumeStaples.present) {
      map['assume_staples'] = Variable<bool>(assumeStaples.value);
    }
    if (equipment.present) {
      map['equipment'] = Variable<String>(equipment.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesTableCompanion(')
          ..write('id: $id, ')
          ..write('locale: $locale, ')
          ..write('region: $region, ')
          ..write('measurementSystem: $measurementSystem, ')
          ..write('allergens: $allergens, ')
          ..write('diets: $diets, ')
          ..write('excludedIngredients: $excludedIngredients, ')
          ..write('householdSize: $householdSize, ')
          ..write('assumeStaples: $assumeStaples, ')
          ..write('equipment: $equipment, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $SyncQueueTable extends SyncQueue
    with TableInfo<$SyncQueueTable, SyncQueueData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncQueueTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSyncedMeta = const VerificationMeta(
    'isSynced',
  );
  @override
  late final GeneratedColumn<bool> isSynced = GeneratedColumn<bool>(
    'is_synced',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_synced" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _retryCountMeta = const VerificationMeta(
    'retryCount',
  );
  @override
  late final GeneratedColumn<int> retryCount = GeneratedColumn<int>(
    'retry_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    targetTable,
    recordId,
    operation,
    payload,
    createdAt,
    isSynced,
    retryCount,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_queue';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncQueueData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['table_name']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('is_synced')) {
      context.handle(
        _isSyncedMeta,
        isSynced.isAcceptableOrUnknown(data['is_synced']!, _isSyncedMeta),
      );
    }
    if (data.containsKey('retry_count')) {
      context.handle(
        _retryCountMeta,
        retryCount.isAcceptableOrUnknown(data['retry_count']!, _retryCountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncQueueData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncQueueData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      isSynced: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_synced'],
      )!,
      retryCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}retry_count'],
      )!,
    );
  }

  @override
  $SyncQueueTable createAlias(String alias) {
    return $SyncQueueTable(attachedDatabase, alias);
  }
}

class SyncQueueData extends DataClass implements Insertable<SyncQueueData> {
  final int id;
  final String targetTable;
  final String recordId;
  final String operation;
  final String payload;
  final DateTime createdAt;
  final bool isSynced;
  final int retryCount;
  const SyncQueueData({
    required this.id,
    required this.targetTable,
    required this.recordId,
    required this.operation,
    required this.payload,
    required this.createdAt,
    required this.isSynced,
    required this.retryCount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['table_name'] = Variable<String>(targetTable);
    map['record_id'] = Variable<String>(recordId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['is_synced'] = Variable<bool>(isSynced);
    map['retry_count'] = Variable<int>(retryCount);
    return map;
  }

  SyncQueueCompanion toCompanion(bool nullToAbsent) {
    return SyncQueueCompanion(
      id: Value(id),
      targetTable: Value(targetTable),
      recordId: Value(recordId),
      operation: Value(operation),
      payload: Value(payload),
      createdAt: Value(createdAt),
      isSynced: Value(isSynced),
      retryCount: Value(retryCount),
    );
  }

  factory SyncQueueData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncQueueData(
      id: serializer.fromJson<int>(json['id']),
      targetTable: serializer.fromJson<String>(json['targetTable']),
      recordId: serializer.fromJson<String>(json['recordId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      isSynced: serializer.fromJson<bool>(json['isSynced']),
      retryCount: serializer.fromJson<int>(json['retryCount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'targetTable': serializer.toJson<String>(targetTable),
      'recordId': serializer.toJson<String>(recordId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'isSynced': serializer.toJson<bool>(isSynced),
      'retryCount': serializer.toJson<int>(retryCount),
    };
  }

  SyncQueueData copyWith({
    int? id,
    String? targetTable,
    String? recordId,
    String? operation,
    String? payload,
    DateTime? createdAt,
    bool? isSynced,
    int? retryCount,
  }) => SyncQueueData(
    id: id ?? this.id,
    targetTable: targetTable ?? this.targetTable,
    recordId: recordId ?? this.recordId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    createdAt: createdAt ?? this.createdAt,
    isSynced: isSynced ?? this.isSynced,
    retryCount: retryCount ?? this.retryCount,
  );
  SyncQueueData copyWithCompanion(SyncQueueCompanion data) {
    return SyncQueueData(
      id: data.id.present ? data.id.value : this.id,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isSynced: data.isSynced.present ? data.isSynced.value : this.isSynced,
      retryCount: data.retryCount.present
          ? data.retryCount.value
          : this.retryCount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueData(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    targetTable,
    recordId,
    operation,
    payload,
    createdAt,
    isSynced,
    retryCount,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncQueueData &&
          other.id == this.id &&
          other.targetTable == this.targetTable &&
          other.recordId == this.recordId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt &&
          other.isSynced == this.isSynced &&
          other.retryCount == this.retryCount);
}

class SyncQueueCompanion extends UpdateCompanion<SyncQueueData> {
  final Value<int> id;
  final Value<String> targetTable;
  final Value<String> recordId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<DateTime> createdAt;
  final Value<bool> isSynced;
  final Value<int> retryCount;
  const SyncQueueCompanion({
    this.id = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.recordId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isSynced = const Value.absent(),
    this.retryCount = const Value.absent(),
  });
  SyncQueueCompanion.insert({
    this.id = const Value.absent(),
    required String targetTable,
    required String recordId,
    required String operation,
    required String payload,
    required DateTime createdAt,
    this.isSynced = const Value.absent(),
    this.retryCount = const Value.absent(),
  }) : targetTable = Value(targetTable),
       recordId = Value(recordId),
       operation = Value(operation),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<SyncQueueData> custom({
    Expression<int>? id,
    Expression<String>? targetTable,
    Expression<String>? recordId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<bool>? isSynced,
    Expression<int>? retryCount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (targetTable != null) 'table_name': targetTable,
      if (recordId != null) 'record_id': recordId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (isSynced != null) 'is_synced': isSynced,
      if (retryCount != null) 'retry_count': retryCount,
    });
  }

  SyncQueueCompanion copyWith({
    Value<int>? id,
    Value<String>? targetTable,
    Value<String>? recordId,
    Value<String>? operation,
    Value<String>? payload,
    Value<DateTime>? createdAt,
    Value<bool>? isSynced,
    Value<int>? retryCount,
  }) {
    return SyncQueueCompanion(
      id: id ?? this.id,
      targetTable: targetTable ?? this.targetTable,
      recordId: recordId ?? this.recordId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      isSynced: isSynced ?? this.isSynced,
      retryCount: retryCount ?? this.retryCount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (targetTable.present) {
      map['table_name'] = Variable<String>(targetTable.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (isSynced.present) {
      map['is_synced'] = Variable<bool>(isSynced.value);
    }
    if (retryCount.present) {
      map['retry_count'] = Variable<int>(retryCount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncQueueCompanion(')
          ..write('id: $id, ')
          ..write('targetTable: $targetTable, ')
          ..write('recordId: $recordId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('isSynced: $isSynced, ')
          ..write('retryCount: $retryCount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $IngredientNamesTable ingredientNames = $IngredientNamesTable(
    this,
  );
  late final $IngredientSubstitutesTable ingredientSubstitutes =
      $IngredientSubstitutesTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeIngredientsTable recipeIngredients =
      $RecipeIngredientsTable(this);
  late final $RecipeStepsTable recipeSteps = $RecipeStepsTable(this);
  late final $PantryItemsTable pantryItems = $PantryItemsTable(this);
  late final $FavoritesTable favorites = $FavoritesTable(this);
  late final $CookSessionsTable cookSessions = $CookSessionsTable(this);
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  late final $UserPreferencesTableTable userPreferencesTable =
      $UserPreferencesTableTable(this);
  late final $SyncQueueTable syncQueue = $SyncQueueTable(this);
  late final IngredientDao ingredientDao = IngredientDao(this as AppDatabase);
  late final RecipeDao recipeDao = RecipeDao(this as AppDatabase);
  late final PantryDao pantryDao = PantryDao(this as AppDatabase);
  late final ShoppingDao shoppingDao = ShoppingDao(this as AppDatabase);
  late final SyncDao syncDao = SyncDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    ingredients,
    ingredientNames,
    ingredientSubstitutes,
    recipes,
    recipeIngredients,
    recipeSteps,
    pantryItems,
    favorites,
    cookSessions,
    shoppingItems,
    userPreferencesTable,
    syncQueue,
  ];
}

typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      required String id,
      required String category,
      Value<String?> parentId,
      Value<bool> isStaple,
      Value<String?> defaultUnit,
      Value<int?> shelfLifeFridgeDays,
      Value<int?> shelfLifePantryDays,
      Value<String> allergens,
      Value<String> dietFlags,
      Value<String?> imageUrl,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<String> id,
      Value<String> category,
      Value<String?> parentId,
      Value<bool> isStaple,
      Value<String?> defaultUnit,
      Value<int?> shelfLifeFridgeDays,
      Value<int?> shelfLifePantryDays,
      Value<String> allergens,
      Value<String> dietFlags,
      Value<String?> imageUrl,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$IngredientNamesTable, List<IngredientName>>
  _ingredientNamesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredientNames,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.ingredientNames.ingredientId,
    ),
  );

  $$IngredientNamesTableProcessedTableManager get ingredientNamesRefs {
    final manager = $$IngredientNamesTableTableManager(
      $_db,
      $_db.ingredientNames,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _ingredientNamesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $IngredientSubstitutesTable,
    List<IngredientSubstitute>
  >
  _sourceSubstitutesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredientSubstitutes,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.ingredientSubstitutes.ingredientId,
    ),
  );

  $$IngredientSubstitutesTableProcessedTableManager get sourceSubstitutes {
    final manager = $$IngredientSubstitutesTableTableManager(
      $_db,
      $_db.ingredientSubstitutes,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_sourceSubstitutesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $IngredientSubstitutesTable,
    List<IngredientSubstitute>
  >
  _targetSubstitutesTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredientSubstitutes,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.ingredientSubstitutes.substituteId,
    ),
  );

  $$IngredientSubstitutesTableProcessedTableManager get targetSubstitutes {
    final manager = $$IngredientSubstitutesTableTableManager(
      $_db,
      $_db.ingredientSubstitutes,
    ).filter((f) => f.substituteId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_targetSubstitutesTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredient>>
  _recipeIngredientsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeIngredients,
        aliasName: $_aliasNameGenerator(
          db.ingredients.id,
          db.recipeIngredients.ingredientId,
        ),
      );

  $$RecipeIngredientsTableProcessedTableManager get recipeIngredientsRefs {
    final manager = $$RecipeIngredientsTableTableManager(
      $_db,
      $_db.recipeIngredients,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PantryItemsTable, List<PantryItem>>
  _pantryItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.pantryItems,
    aliasName: $_aliasNameGenerator(
      db.ingredients.id,
      db.pantryItems.ingredientId,
    ),
  );

  $$PantryItemsTableProcessedTableManager get pantryItemsRefs {
    final manager = $$PantryItemsTableTableManager(
      $_db,
      $_db.pantryItems,
    ).filter((f) => f.ingredientId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_pantryItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isStaple => $composableBuilder(
    column: $table.isStaple,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shelfLifeFridgeDays => $composableBuilder(
    column: $table.shelfLifeFridgeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shelfLifePantryDays => $composableBuilder(
    column: $table.shelfLifePantryDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietFlags => $composableBuilder(
    column: $table.dietFlags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> ingredientNamesRefs(
    Expression<bool> Function($$IngredientNamesTableFilterComposer f) f,
  ) {
    final $$IngredientNamesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientNames,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientNamesTableFilterComposer(
            $db: $db,
            $table: $db.ingredientNames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> sourceSubstitutes(
    Expression<bool> Function($$IngredientSubstitutesTableFilterComposer f) f,
  ) {
    final $$IngredientSubstitutesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientSubstitutes,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientSubstitutesTableFilterComposer(
                $db: $db,
                $table: $db.ingredientSubstitutes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> targetSubstitutes(
    Expression<bool> Function($$IngredientSubstitutesTableFilterComposer f) f,
  ) {
    final $$IngredientSubstitutesTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientSubstitutes,
          getReferencedColumn: (t) => t.substituteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientSubstitutesTableFilterComposer(
                $db: $db,
                $table: $db.ingredientSubstitutes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> recipeIngredientsRefs(
    Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f,
  ) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeIngredients,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.recipeIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> pantryItemsRefs(
    Expression<bool> Function($$PantryItemsTableFilterComposer f) f,
  ) {
    final $$PantryItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pantryItems,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PantryItemsTableFilterComposer(
            $db: $db,
            $table: $db.pantryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get parentId => $composableBuilder(
    column: $table.parentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isStaple => $composableBuilder(
    column: $table.isStaple,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shelfLifeFridgeDays => $composableBuilder(
    column: $table.shelfLifeFridgeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shelfLifePantryDays => $composableBuilder(
    column: $table.shelfLifePantryDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietFlags => $composableBuilder(
    column: $table.dietFlags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get parentId =>
      $composableBuilder(column: $table.parentId, builder: (column) => column);

  GeneratedColumn<bool> get isStaple =>
      $composableBuilder(column: $table.isStaple, builder: (column) => column);

  GeneratedColumn<String> get defaultUnit => $composableBuilder(
    column: $table.defaultUnit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shelfLifeFridgeDays => $composableBuilder(
    column: $table.shelfLifeFridgeDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shelfLifePantryDays => $composableBuilder(
    column: $table.shelfLifePantryDays,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergens =>
      $composableBuilder(column: $table.allergens, builder: (column) => column);

  GeneratedColumn<String> get dietFlags =>
      $composableBuilder(column: $table.dietFlags, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> ingredientNamesRefs<T extends Object>(
    Expression<T> Function($$IngredientNamesTableAnnotationComposer a) f,
  ) {
    final $$IngredientNamesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredientNames,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientNamesTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredientNames,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> sourceSubstitutes<T extends Object>(
    Expression<T> Function($$IngredientSubstitutesTableAnnotationComposer a) f,
  ) {
    final $$IngredientSubstitutesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientSubstitutes,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientSubstitutesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientSubstitutes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> targetSubstitutes<T extends Object>(
    Expression<T> Function($$IngredientSubstitutesTableAnnotationComposer a) f,
  ) {
    final $$IngredientSubstitutesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.ingredientSubstitutes,
          getReferencedColumn: (t) => t.substituteId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IngredientSubstitutesTableAnnotationComposer(
                $db: $db,
                $table: $db.ingredientSubstitutes,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recipeIngredientsRefs<T extends Object>(
    Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f,
  ) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeIngredients,
          getReferencedColumn: (t) => t.ingredientId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> pantryItemsRefs<T extends Object>(
    Expression<T> Function($$PantryItemsTableAnnotationComposer a) f,
  ) {
    final $$PantryItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.pantryItems,
      getReferencedColumn: (t) => t.ingredientId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PantryItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.pantryItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          Ingredient,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (Ingredient, $$IngredientsTableReferences),
          Ingredient,
          PrefetchHooks Function({
            bool ingredientNamesRefs,
            bool sourceSubstitutes,
            bool targetSubstitutes,
            bool recipeIngredientsRefs,
            bool pantryItemsRefs,
          })
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<bool> isStaple = const Value.absent(),
                Value<String?> defaultUnit = const Value.absent(),
                Value<int?> shelfLifeFridgeDays = const Value.absent(),
                Value<int?> shelfLifePantryDays = const Value.absent(),
                Value<String> allergens = const Value.absent(),
                Value<String> dietFlags = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                category: category,
                parentId: parentId,
                isStaple: isStaple,
                defaultUnit: defaultUnit,
                shelfLifeFridgeDays: shelfLifeFridgeDays,
                shelfLifePantryDays: shelfLifePantryDays,
                allergens: allergens,
                dietFlags: dietFlags,
                imageUrl: imageUrl,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String category,
                Value<String?> parentId = const Value.absent(),
                Value<bool> isStaple = const Value.absent(),
                Value<String?> defaultUnit = const Value.absent(),
                Value<int?> shelfLifeFridgeDays = const Value.absent(),
                Value<int?> shelfLifePantryDays = const Value.absent(),
                Value<String> allergens = const Value.absent(),
                Value<String> dietFlags = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => IngredientsCompanion.insert(
                id: id,
                category: category,
                parentId: parentId,
                isStaple: isStaple,
                defaultUnit: defaultUnit,
                shelfLifeFridgeDays: shelfLifeFridgeDays,
                shelfLifePantryDays: shelfLifePantryDays,
                allergens: allergens,
                dietFlags: dietFlags,
                imageUrl: imageUrl,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                ingredientNamesRefs = false,
                sourceSubstitutes = false,
                targetSubstitutes = false,
                recipeIngredientsRefs = false,
                pantryItemsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (ingredientNamesRefs) db.ingredientNames,
                    if (sourceSubstitutes) db.ingredientSubstitutes,
                    if (targetSubstitutes) db.ingredientSubstitutes,
                    if (recipeIngredientsRefs) db.recipeIngredients,
                    if (pantryItemsRefs) db.pantryItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (ingredientNamesRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          IngredientName
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._ingredientNamesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientNamesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (sourceSubstitutes)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          IngredientSubstitute
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._sourceSubstitutesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).sourceSubstitutes,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (targetSubstitutes)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          IngredientSubstitute
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._targetSubstitutesTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).targetSubstitutes,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.substituteId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeIngredientsRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          RecipeIngredient
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._recipeIngredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeIngredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (pantryItemsRefs)
                        await $_getPrefetchedData<
                          Ingredient,
                          $IngredientsTable,
                          PantryItem
                        >(
                          currentTable: table,
                          referencedTable: $$IngredientsTableReferences
                              ._pantryItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IngredientsTableReferences(
                                db,
                                table,
                                p0,
                              ).pantryItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.ingredientId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      Ingredient,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (Ingredient, $$IngredientsTableReferences),
      Ingredient,
      PrefetchHooks Function({
        bool ingredientNamesRefs,
        bool sourceSubstitutes,
        bool targetSubstitutes,
        bool recipeIngredientsRefs,
        bool pantryItemsRefs,
      })
    >;
typedef $$IngredientNamesTableCreateCompanionBuilder =
    IngredientNamesCompanion Function({
      required String ingredientId,
      required String lang,
      Value<String?> region,
      required String name,
      required String normalized,
      Value<bool> isPrimary,
      Value<int> rowid,
    });
typedef $$IngredientNamesTableUpdateCompanionBuilder =
    IngredientNamesCompanion Function({
      Value<String> ingredientId,
      Value<String> lang,
      Value<String?> region,
      Value<String> name,
      Value<String> normalized,
      Value<bool> isPrimary,
      Value<int> rowid,
    });

final class $$IngredientNamesTableReferences
    extends
        BaseReferences<_$AppDatabase, $IngredientNamesTable, IngredientName> {
  $$IngredientNamesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(
          db.ingredientNames.ingredientId,
          db.ingredients.id,
        ),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngredientNamesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientNamesTable> {
  $$IngredientNamesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalized => $composableBuilder(
    column: $table.normalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnFilters(column),
  );

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientNamesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientNamesTable> {
  $$IngredientNamesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get lang => $composableBuilder(
    column: $table.lang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalized => $composableBuilder(
    column: $table.normalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPrimary => $composableBuilder(
    column: $table.isPrimary,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientNamesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientNamesTable> {
  $$IngredientNamesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get lang =>
      $composableBuilder(column: $table.lang, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalized => $composableBuilder(
    column: $table.normalized,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPrimary =>
      $composableBuilder(column: $table.isPrimary, builder: (column) => column);

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientNamesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientNamesTable,
          IngredientName,
          $$IngredientNamesTableFilterComposer,
          $$IngredientNamesTableOrderingComposer,
          $$IngredientNamesTableAnnotationComposer,
          $$IngredientNamesTableCreateCompanionBuilder,
          $$IngredientNamesTableUpdateCompanionBuilder,
          (IngredientName, $$IngredientNamesTableReferences),
          IngredientName,
          PrefetchHooks Function({bool ingredientId})
        > {
  $$IngredientNamesTableTableManager(
    _$AppDatabase db,
    $IngredientNamesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientNamesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientNamesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientNamesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> ingredientId = const Value.absent(),
                Value<String> lang = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> normalized = const Value.absent(),
                Value<bool> isPrimary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientNamesCompanion(
                ingredientId: ingredientId,
                lang: lang,
                region: region,
                name: name,
                normalized: normalized,
                isPrimary: isPrimary,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ingredientId,
                required String lang,
                Value<String?> region = const Value.absent(),
                required String name,
                required String normalized,
                Value<bool> isPrimary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientNamesCompanion.insert(
                ingredientId: ingredientId,
                lang: lang,
                region: region,
                name: name,
                normalized: normalized,
                isPrimary: isPrimary,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientNamesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable:
                                    $$IngredientNamesTableReferences
                                        ._ingredientIdTable(db),
                                referencedColumn:
                                    $$IngredientNamesTableReferences
                                        ._ingredientIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IngredientNamesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientNamesTable,
      IngredientName,
      $$IngredientNamesTableFilterComposer,
      $$IngredientNamesTableOrderingComposer,
      $$IngredientNamesTableAnnotationComposer,
      $$IngredientNamesTableCreateCompanionBuilder,
      $$IngredientNamesTableUpdateCompanionBuilder,
      (IngredientName, $$IngredientNamesTableReferences),
      IngredientName,
      PrefetchHooks Function({bool ingredientId})
    >;
typedef $$IngredientSubstitutesTableCreateCompanionBuilder =
    IngredientSubstitutesCompanion Function({
      required String ingredientId,
      required String substituteId,
      Value<double> ratio,
      required String quality,
      Value<String> contextTags,
      Value<String?> noteAr,
      Value<int> rowid,
    });
typedef $$IngredientSubstitutesTableUpdateCompanionBuilder =
    IngredientSubstitutesCompanion Function({
      Value<String> ingredientId,
      Value<String> substituteId,
      Value<double> ratio,
      Value<String> quality,
      Value<String> contextTags,
      Value<String?> noteAr,
      Value<int> rowid,
    });

final class $$IngredientSubstitutesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IngredientSubstitutesTable,
          IngredientSubstitute
        > {
  $$IngredientSubstitutesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(
          db.ingredientSubstitutes.ingredientId,
          db.ingredients.id,
        ),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _substituteIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(
          db.ingredientSubstitutes.substituteId,
          db.ingredients.id,
        ),
      );

  $$IngredientsTableProcessedTableManager get substituteId {
    final $_column = $_itemColumn<String>('substitute_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_substituteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngredientSubstitutesTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientSubstitutesTable> {
  $$IngredientSubstitutesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextTags => $composableBuilder(
    column: $table.contextTags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteAr => $composableBuilder(
    column: $table.noteAr,
    builder: (column) => ColumnFilters(column),
  );

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get substituteId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.substituteId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientSubstitutesTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientSubstitutesTable> {
  $$IngredientSubstitutesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get ratio => $composableBuilder(
    column: $table.ratio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get quality => $composableBuilder(
    column: $table.quality,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextTags => $composableBuilder(
    column: $table.contextTags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteAr => $composableBuilder(
    column: $table.noteAr,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get substituteId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.substituteId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientSubstitutesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientSubstitutesTable> {
  $$IngredientSubstitutesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get ratio =>
      $composableBuilder(column: $table.ratio, builder: (column) => column);

  GeneratedColumn<String> get quality =>
      $composableBuilder(column: $table.quality, builder: (column) => column);

  GeneratedColumn<String> get contextTags => $composableBuilder(
    column: $table.contextTags,
    builder: (column) => column,
  );

  GeneratedColumn<String> get noteAr =>
      $composableBuilder(column: $table.noteAr, builder: (column) => column);

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get substituteId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.substituteId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientSubstitutesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientSubstitutesTable,
          IngredientSubstitute,
          $$IngredientSubstitutesTableFilterComposer,
          $$IngredientSubstitutesTableOrderingComposer,
          $$IngredientSubstitutesTableAnnotationComposer,
          $$IngredientSubstitutesTableCreateCompanionBuilder,
          $$IngredientSubstitutesTableUpdateCompanionBuilder,
          (IngredientSubstitute, $$IngredientSubstitutesTableReferences),
          IngredientSubstitute,
          PrefetchHooks Function({bool ingredientId, bool substituteId})
        > {
  $$IngredientSubstitutesTableTableManager(
    _$AppDatabase db,
    $IngredientSubstitutesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientSubstitutesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$IngredientSubstitutesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IngredientSubstitutesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> ingredientId = const Value.absent(),
                Value<String> substituteId = const Value.absent(),
                Value<double> ratio = const Value.absent(),
                Value<String> quality = const Value.absent(),
                Value<String> contextTags = const Value.absent(),
                Value<String?> noteAr = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientSubstitutesCompanion(
                ingredientId: ingredientId,
                substituteId: substituteId,
                ratio: ratio,
                quality: quality,
                contextTags: contextTags,
                noteAr: noteAr,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String ingredientId,
                required String substituteId,
                Value<double> ratio = const Value.absent(),
                required String quality,
                Value<String> contextTags = const Value.absent(),
                Value<String?> noteAr = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IngredientSubstitutesCompanion.insert(
                ingredientId: ingredientId,
                substituteId: substituteId,
                ratio: ratio,
                quality: quality,
                contextTags: contextTags,
                noteAr: noteAr,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientSubstitutesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({ingredientId = false, substituteId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (ingredientId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.ingredientId,
                                    referencedTable:
                                        $$IngredientSubstitutesTableReferences
                                            ._ingredientIdTable(db),
                                    referencedColumn:
                                        $$IngredientSubstitutesTableReferences
                                            ._ingredientIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (substituteId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.substituteId,
                                    referencedTable:
                                        $$IngredientSubstitutesTableReferences
                                            ._substituteIdTable(db),
                                    referencedColumn:
                                        $$IngredientSubstitutesTableReferences
                                            ._substituteIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$IngredientSubstitutesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientSubstitutesTable,
      IngredientSubstitute,
      $$IngredientSubstitutesTableFilterComposer,
      $$IngredientSubstitutesTableOrderingComposer,
      $$IngredientSubstitutesTableAnnotationComposer,
      $$IngredientSubstitutesTableCreateCompanionBuilder,
      $$IngredientSubstitutesTableUpdateCompanionBuilder,
      (IngredientSubstitute, $$IngredientSubstitutesTableReferences),
      IngredientSubstitute,
      PrefetchHooks Function({bool ingredientId, bool substituteId})
    >;
typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      required String id,
      required String slug,
      required String title,
      Value<String?> description,
      Value<String?> cuisine,
      Value<String> mealType,
      Value<int> difficulty,
      Value<int?> prepMinutes,
      Value<int?> cookMinutes,
      Value<int?> totalMinutes,
      Value<int> baseServings,
      Value<int?> caloriesPerServing,
      Value<String> equipment,
      Value<String> dietFlags,
      Value<String> allergens,
      Value<String> sourceType,
      Value<bool> verified,
      Value<String?> heroImageUrl,
      Value<String?> blurhash,
      Value<double> ratingAvg,
      Value<int> ratingCount,
      Value<String> status,
      Value<DateTime?> publishedAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<String> id,
      Value<String> slug,
      Value<String> title,
      Value<String?> description,
      Value<String?> cuisine,
      Value<String> mealType,
      Value<int> difficulty,
      Value<int?> prepMinutes,
      Value<int?> cookMinutes,
      Value<int?> totalMinutes,
      Value<int> baseServings,
      Value<int?> caloriesPerServing,
      Value<String> equipment,
      Value<String> dietFlags,
      Value<String> allergens,
      Value<String> sourceType,
      Value<bool> verified,
      Value<String?> heroImageUrl,
      Value<String?> blurhash,
      Value<double> ratingAvg,
      Value<int> ratingCount,
      Value<String> status,
      Value<DateTime?> publishedAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeIngredientsTable, List<RecipeIngredient>>
  _recipeIngredientsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recipeIngredients,
        aliasName: $_aliasNameGenerator(
          db.recipes.id,
          db.recipeIngredients.recipeId,
        ),
      );

  $$RecipeIngredientsTableProcessedTableManager get recipeIngredientsRefs {
    final manager = $$RecipeIngredientsTableTableManager(
      $_db,
      $_db.recipeIngredients,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recipeIngredientsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$RecipeStepsTable, List<RecipeStep>>
  _recipeStepsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeSteps,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.recipeSteps.recipeId),
  );

  $$RecipeStepsTableProcessedTableManager get recipeStepsRefs {
    final manager = $$RecipeStepsTableTableManager(
      $_db,
      $_db.recipeSteps,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeStepsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FavoritesTable, List<Favorite>>
  _favoritesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.favorites,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.favorites.recipeId),
  );

  $$FavoritesTableProcessedTableManager get favoritesRefs {
    final manager = $$FavoritesTableTableManager(
      $_db,
      $_db.favorites,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_favoritesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CookSessionsTable, List<CookSession>>
  _cookSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cookSessions,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.cookSessions.recipeId),
  );

  $$CookSessionsTableProcessedTableManager get cookSessionsRefs {
    final manager = $$CookSessionsTableTableManager(
      $_db,
      $_db.cookSessions,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cookSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cuisine => $composableBuilder(
    column: $table.cuisine,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseServings => $composableBuilder(
    column: $table.baseServings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietFlags => $composableBuilder(
    column: $table.dietFlags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get heroImageUrl => $composableBuilder(
    column: $table.heroImageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get blurhash => $composableBuilder(
    column: $table.blurhash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get ratingAvg => $composableBuilder(
    column: $table.ratingAvg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recipeIngredientsRefs(
    Expression<bool> Function($$RecipeIngredientsTableFilterComposer f) f,
  ) {
    final $$RecipeIngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeIngredients,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeIngredientsTableFilterComposer(
            $db: $db,
            $table: $db.recipeIngredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recipeStepsRefs(
    Expression<bool> Function($$RecipeStepsTableFilterComposer f) f,
  ) {
    final $$RecipeStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeStepsTableFilterComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> favoritesRefs(
    Expression<bool> Function($$FavoritesTableFilterComposer f) f,
  ) {
    final $$FavoritesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableFilterComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> cookSessionsRefs(
    Expression<bool> Function($$CookSessionsTableFilterComposer f) f,
  ) {
    final $$CookSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cookSessions,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CookSessionsTableFilterComposer(
            $db: $db,
            $table: $db.cookSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cuisine => $composableBuilder(
    column: $table.cuisine,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseServings => $composableBuilder(
    column: $table.baseServings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietFlags => $composableBuilder(
    column: $table.dietFlags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get verified => $composableBuilder(
    column: $table.verified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get heroImageUrl => $composableBuilder(
    column: $table.heroImageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get blurhash => $composableBuilder(
    column: $table.blurhash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get ratingAvg => $composableBuilder(
    column: $table.ratingAvg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get cuisine =>
      $composableBuilder(column: $table.cuisine, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseServings => $composableBuilder(
    column: $table.baseServings,
    builder: (column) => column,
  );

  GeneratedColumn<int> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<String> get dietFlags =>
      $composableBuilder(column: $table.dietFlags, builder: (column) => column);

  GeneratedColumn<String> get allergens =>
      $composableBuilder(column: $table.allergens, builder: (column) => column);

  GeneratedColumn<String> get sourceType => $composableBuilder(
    column: $table.sourceType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get verified =>
      $composableBuilder(column: $table.verified, builder: (column) => column);

  GeneratedColumn<String> get heroImageUrl => $composableBuilder(
    column: $table.heroImageUrl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get blurhash =>
      $composableBuilder(column: $table.blurhash, builder: (column) => column);

  GeneratedColumn<double> get ratingAvg =>
      $composableBuilder(column: $table.ratingAvg, builder: (column) => column);

  GeneratedColumn<int> get ratingCount => $composableBuilder(
    column: $table.ratingCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get publishedAt => $composableBuilder(
    column: $table.publishedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> recipeIngredientsRefs<T extends Object>(
    Expression<T> Function($$RecipeIngredientsTableAnnotationComposer a) f,
  ) {
    final $$RecipeIngredientsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recipeIngredients,
          getReferencedColumn: (t) => t.recipeId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecipeIngredientsTableAnnotationComposer(
                $db: $db,
                $table: $db.recipeIngredients,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recipeStepsRefs<T extends Object>(
    Expression<T> Function($$RecipeStepsTableAnnotationComposer a) f,
  ) {
    final $$RecipeStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> favoritesRefs<T extends Object>(
    Expression<T> Function($$FavoritesTableAnnotationComposer a) f,
  ) {
    final $$FavoritesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.favorites,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FavoritesTableAnnotationComposer(
            $db: $db,
            $table: $db.favorites,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> cookSessionsRefs<T extends Object>(
    Expression<T> Function($$CookSessionsTableAnnotationComposer a) f,
  ) {
    final $$CookSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cookSessions,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CookSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.cookSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, $$RecipesTableReferences),
          Recipe,
          PrefetchHooks Function({
            bool recipeIngredientsRefs,
            bool recipeStepsRefs,
            bool favoritesRefs,
            bool cookSessionsRefs,
          })
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> cuisine = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<int?> prepMinutes = const Value.absent(),
                Value<int?> cookMinutes = const Value.absent(),
                Value<int?> totalMinutes = const Value.absent(),
                Value<int> baseServings = const Value.absent(),
                Value<int?> caloriesPerServing = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<String> dietFlags = const Value.absent(),
                Value<String> allergens = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String?> heroImageUrl = const Value.absent(),
                Value<String?> blurhash = const Value.absent(),
                Value<double> ratingAvg = const Value.absent(),
                Value<int> ratingCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                slug: slug,
                title: title,
                description: description,
                cuisine: cuisine,
                mealType: mealType,
                difficulty: difficulty,
                prepMinutes: prepMinutes,
                cookMinutes: cookMinutes,
                totalMinutes: totalMinutes,
                baseServings: baseServings,
                caloriesPerServing: caloriesPerServing,
                equipment: equipment,
                dietFlags: dietFlags,
                allergens: allergens,
                sourceType: sourceType,
                verified: verified,
                heroImageUrl: heroImageUrl,
                blurhash: blurhash,
                ratingAvg: ratingAvg,
                ratingCount: ratingCount,
                status: status,
                publishedAt: publishedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String slug,
                required String title,
                Value<String?> description = const Value.absent(),
                Value<String?> cuisine = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<int?> prepMinutes = const Value.absent(),
                Value<int?> cookMinutes = const Value.absent(),
                Value<int?> totalMinutes = const Value.absent(),
                Value<int> baseServings = const Value.absent(),
                Value<int?> caloriesPerServing = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<String> dietFlags = const Value.absent(),
                Value<String> allergens = const Value.absent(),
                Value<String> sourceType = const Value.absent(),
                Value<bool> verified = const Value.absent(),
                Value<String?> heroImageUrl = const Value.absent(),
                Value<String?> blurhash = const Value.absent(),
                Value<double> ratingAvg = const Value.absent(),
                Value<int> ratingCount = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime?> publishedAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                slug: slug,
                title: title,
                description: description,
                cuisine: cuisine,
                mealType: mealType,
                difficulty: difficulty,
                prepMinutes: prepMinutes,
                cookMinutes: cookMinutes,
                totalMinutes: totalMinutes,
                baseServings: baseServings,
                caloriesPerServing: caloriesPerServing,
                equipment: equipment,
                dietFlags: dietFlags,
                allergens: allergens,
                sourceType: sourceType,
                verified: verified,
                heroImageUrl: heroImageUrl,
                blurhash: blurhash,
                ratingAvg: ratingAvg,
                ratingCount: ratingCount,
                status: status,
                publishedAt: publishedAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recipeIngredientsRefs = false,
                recipeStepsRefs = false,
                favoritesRefs = false,
                cookSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipeIngredientsRefs) db.recipeIngredients,
                    if (recipeStepsRefs) db.recipeSteps,
                    if (favoritesRefs) db.favorites,
                    if (cookSessionsRefs) db.cookSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipeIngredientsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeIngredient
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._recipeIngredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeIngredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recipeStepsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeStep
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._recipeStepsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeStepsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (favoritesRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          Favorite
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._favoritesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).favoritesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (cookSessionsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          CookSession
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._cookSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).cookSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, $$RecipesTableReferences),
      Recipe,
      PrefetchHooks Function({
        bool recipeIngredientsRefs,
        bool recipeStepsRefs,
        bool favoritesRefs,
        bool cookSessionsRefs,
      })
    >;
typedef $$RecipeIngredientsTableCreateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      required String recipeId,
      required String ingredientId,
      required String role,
      Value<double?> amount,
      Value<String?> unit,
      Value<String?> displayText,
      Value<String> groupLabel,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$RecipeIngredientsTableUpdateCompanionBuilder =
    RecipeIngredientsCompanion Function({
      Value<String> recipeId,
      Value<String> ingredientId,
      Value<String> role,
      Value<double?> amount,
      Value<String?> unit,
      Value<String?> displayText,
      Value<String> groupLabel,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$RecipeIngredientsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient
        > {
  $$RecipeIngredientsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.recipeIngredients.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(
          db.recipeIngredients.ingredientId,
          db.ingredients.id,
        ),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeIngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayText => $composableBuilder(
    column: $table.displayText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayText => $composableBuilder(
    column: $table.displayText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeIngredientsTable> {
  $$RecipeIngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get displayText => $composableBuilder(
    column: $table.displayText,
    builder: (column) => column,
  );

  GeneratedColumn<String> get groupLabel => $composableBuilder(
    column: $table.groupLabel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeIngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeIngredientsTable,
          RecipeIngredient,
          $$RecipeIngredientsTableFilterComposer,
          $$RecipeIngredientsTableOrderingComposer,
          $$RecipeIngredientsTableAnnotationComposer,
          $$RecipeIngredientsTableCreateCompanionBuilder,
          $$RecipeIngredientsTableUpdateCompanionBuilder,
          (RecipeIngredient, $$RecipeIngredientsTableReferences),
          RecipeIngredient,
          PrefetchHooks Function({bool recipeId, bool ingredientId})
        > {
  $$RecipeIngredientsTableTableManager(
    _$AppDatabase db,
    $RecipeIngredientsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeIngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeIngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeIngredientsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> recipeId = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> displayText = const Value.absent(),
                Value<String> groupLabel = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion(
                recipeId: recipeId,
                ingredientId: ingredientId,
                role: role,
                amount: amount,
                unit: unit,
                displayText: displayText,
                groupLabel: groupLabel,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recipeId,
                required String ingredientId,
                required String role,
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> displayText = const Value.absent(),
                Value<String> groupLabel = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeIngredientsCompanion.insert(
                recipeId: recipeId,
                ingredientId: ingredientId,
                role: role,
                amount: amount,
                unit: unit,
                displayText: displayText,
                groupLabel: groupLabel,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeIngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false, ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable:
                                    $$RecipeIngredientsTableReferences
                                        ._recipeIdTable(db),
                                referencedColumn:
                                    $$RecipeIngredientsTableReferences
                                        ._recipeIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable:
                                    $$RecipeIngredientsTableReferences
                                        ._ingredientIdTable(db),
                                referencedColumn:
                                    $$RecipeIngredientsTableReferences
                                        ._ingredientIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeIngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeIngredientsTable,
      RecipeIngredient,
      $$RecipeIngredientsTableFilterComposer,
      $$RecipeIngredientsTableOrderingComposer,
      $$RecipeIngredientsTableAnnotationComposer,
      $$RecipeIngredientsTableCreateCompanionBuilder,
      $$RecipeIngredientsTableUpdateCompanionBuilder,
      (RecipeIngredient, $$RecipeIngredientsTableReferences),
      RecipeIngredient,
      PrefetchHooks Function({bool recipeId, bool ingredientId})
    >;
typedef $$RecipeStepsTableCreateCompanionBuilder =
    RecipeStepsCompanion Function({
      required String recipeId,
      required int stepNo,
      required String stepText,
      Value<String?> imageUrl,
      Value<int?> timerSeconds,
      Value<String?> tip,
      Value<int> rowid,
    });
typedef $$RecipeStepsTableUpdateCompanionBuilder =
    RecipeStepsCompanion Function({
      Value<String> recipeId,
      Value<int> stepNo,
      Value<String> stepText,
      Value<String?> imageUrl,
      Value<int?> timerSeconds,
      Value<String?> tip,
      Value<int> rowid,
    });

final class $$RecipeStepsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeStepsTable, RecipeStep> {
  $$RecipeStepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.recipeSteps.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeStepsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get stepNo => $composableBuilder(
    column: $table.stepNo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stepText => $composableBuilder(
    column: $table.stepText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tip => $composableBuilder(
    column: $table.tip,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get stepNo => $composableBuilder(
    column: $table.stepNo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stepText => $composableBuilder(
    column: $table.stepText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageUrl => $composableBuilder(
    column: $table.imageUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tip => $composableBuilder(
    column: $table.tip,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get stepNo =>
      $composableBuilder(column: $table.stepNo, builder: (column) => column);

  GeneratedColumn<String> get stepText =>
      $composableBuilder(column: $table.stepText, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tip =>
      $composableBuilder(column: $table.tip, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeStepsTable,
          RecipeStep,
          $$RecipeStepsTableFilterComposer,
          $$RecipeStepsTableOrderingComposer,
          $$RecipeStepsTableAnnotationComposer,
          $$RecipeStepsTableCreateCompanionBuilder,
          $$RecipeStepsTableUpdateCompanionBuilder,
          (RecipeStep, $$RecipeStepsTableReferences),
          RecipeStep,
          PrefetchHooks Function({bool recipeId})
        > {
  $$RecipeStepsTableTableManager(_$AppDatabase db, $RecipeStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> recipeId = const Value.absent(),
                Value<int> stepNo = const Value.absent(),
                Value<String> stepText = const Value.absent(),
                Value<String?> imageUrl = const Value.absent(),
                Value<int?> timerSeconds = const Value.absent(),
                Value<String?> tip = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeStepsCompanion(
                recipeId: recipeId,
                stepNo: stepNo,
                stepText: stepText,
                imageUrl: imageUrl,
                timerSeconds: timerSeconds,
                tip: tip,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recipeId,
                required int stepNo,
                required String stepText,
                Value<String?> imageUrl = const Value.absent(),
                Value<int?> timerSeconds = const Value.absent(),
                Value<String?> tip = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeStepsCompanion.insert(
                recipeId: recipeId,
                stepNo: stepNo,
                stepText: stepText,
                imageUrl: imageUrl,
                timerSeconds: timerSeconds,
                tip: tip,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeStepsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$RecipeStepsTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$RecipeStepsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeStepsTable,
      RecipeStep,
      $$RecipeStepsTableFilterComposer,
      $$RecipeStepsTableOrderingComposer,
      $$RecipeStepsTableAnnotationComposer,
      $$RecipeStepsTableCreateCompanionBuilder,
      $$RecipeStepsTableUpdateCompanionBuilder,
      (RecipeStep, $$RecipeStepsTableReferences),
      RecipeStep,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$PantryItemsTableCreateCompanionBuilder =
    PantryItemsCompanion Function({
      required String id,
      required String ingredientId,
      Value<double?> quantity,
      Value<String?> unit,
      Value<String?> location,
      required DateTime addedAt,
      Value<DateTime?> expiresOn,
      Value<String> source,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$PantryItemsTableUpdateCompanionBuilder =
    PantryItemsCompanion Function({
      Value<String> id,
      Value<String> ingredientId,
      Value<double?> quantity,
      Value<String?> unit,
      Value<String?> location,
      Value<DateTime> addedAt,
      Value<DateTime?> expiresOn,
      Value<String> source,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$PantryItemsTableReferences
    extends BaseReferences<_$AppDatabase, $PantryItemsTable, PantryItem> {
  $$PantryItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $IngredientsTable _ingredientIdTable(_$AppDatabase db) =>
      db.ingredients.createAlias(
        $_aliasNameGenerator(db.pantryItems.ingredientId, db.ingredients.id),
      );

  $$IngredientsTableProcessedTableManager get ingredientId {
    final $_column = $_itemColumn<String>('ingredient_id')!;

    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ingredientIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$PantryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get expiresOn => $composableBuilder(
    column: $table.expiresOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$IngredientsTableFilterComposer get ingredientId {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PantryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get expiresOn => $composableBuilder(
    column: $table.expiresOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$IngredientsTableOrderingComposer get ingredientId {
    final $$IngredientsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableOrderingComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PantryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PantryItemsTable> {
  $$PantryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get expiresOn =>
      $composableBuilder(column: $table.expiresOn, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$IngredientsTableAnnotationComposer get ingredientId {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ingredientId,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PantryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PantryItemsTable,
          PantryItem,
          $$PantryItemsTableFilterComposer,
          $$PantryItemsTableOrderingComposer,
          $$PantryItemsTableAnnotationComposer,
          $$PantryItemsTableCreateCompanionBuilder,
          $$PantryItemsTableUpdateCompanionBuilder,
          (PantryItem, $$PantryItemsTableReferences),
          PantryItem,
          PrefetchHooks Function({bool ingredientId})
        > {
  $$PantryItemsTableTableManager(_$AppDatabase db, $PantryItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PantryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PantryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PantryItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ingredientId = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<DateTime?> expiresOn = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PantryItemsCompanion(
                id: id,
                ingredientId: ingredientId,
                quantity: quantity,
                unit: unit,
                location: location,
                addedAt: addedAt,
                expiresOn: expiresOn,
                source: source,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ingredientId,
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> location = const Value.absent(),
                required DateTime addedAt,
                Value<DateTime?> expiresOn = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PantryItemsCompanion.insert(
                id: id,
                ingredientId: ingredientId,
                quantity: quantity,
                unit: unit,
                location: location,
                addedAt: addedAt,
                expiresOn: expiresOn,
                source: source,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PantryItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({ingredientId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (ingredientId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.ingredientId,
                                referencedTable: $$PantryItemsTableReferences
                                    ._ingredientIdTable(db),
                                referencedColumn: $$PantryItemsTableReferences
                                    ._ingredientIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$PantryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PantryItemsTable,
      PantryItem,
      $$PantryItemsTableFilterComposer,
      $$PantryItemsTableOrderingComposer,
      $$PantryItemsTableAnnotationComposer,
      $$PantryItemsTableCreateCompanionBuilder,
      $$PantryItemsTableUpdateCompanionBuilder,
      (PantryItem, $$PantryItemsTableReferences),
      PantryItem,
      PrefetchHooks Function({bool ingredientId})
    >;
typedef $$FavoritesTableCreateCompanionBuilder =
    FavoritesCompanion Function({
      required String recipeId,
      required DateTime createdAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$FavoritesTableUpdateCompanionBuilder =
    FavoritesCompanion Function({
      Value<String> recipeId,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$FavoritesTableReferences
    extends BaseReferences<_$AppDatabase, $FavoritesTable, Favorite> {
  $$FavoritesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) => db.recipes
      .createAlias($_aliasNameGenerator(db.favorites.recipeId, db.recipes.id));

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FavoritesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoritesTable> {
  $$FavoritesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FavoritesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoritesTable,
          Favorite,
          $$FavoritesTableFilterComposer,
          $$FavoritesTableOrderingComposer,
          $$FavoritesTableAnnotationComposer,
          $$FavoritesTableCreateCompanionBuilder,
          $$FavoritesTableUpdateCompanionBuilder,
          (Favorite, $$FavoritesTableReferences),
          Favorite,
          PrefetchHooks Function({bool recipeId})
        > {
  $$FavoritesTableTableManager(_$AppDatabase db, $FavoritesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoritesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoritesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoritesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> recipeId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoritesCompanion(
                recipeId: recipeId,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String recipeId,
                required DateTime createdAt,
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoritesCompanion.insert(
                recipeId: recipeId,
                createdAt: createdAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$FavoritesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$FavoritesTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$FavoritesTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FavoritesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoritesTable,
      Favorite,
      $$FavoritesTableFilterComposer,
      $$FavoritesTableOrderingComposer,
      $$FavoritesTableAnnotationComposer,
      $$FavoritesTableCreateCompanionBuilder,
      $$FavoritesTableUpdateCompanionBuilder,
      (Favorite, $$FavoritesTableReferences),
      Favorite,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$CookSessionsTableCreateCompanionBuilder =
    CookSessionsCompanion Function({
      required String id,
      required String recipeId,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<int?> servings,
      Value<int?> rating,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$CookSessionsTableUpdateCompanionBuilder =
    CookSessionsCompanion Function({
      Value<String> id,
      Value<String> recipeId,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int?> servings,
      Value<int?> rating,
      Value<bool> isSynced,
      Value<int> rowid,
    });

final class $$CookSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $CookSessionsTable, CookSession> {
  $$CookSessionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.cookSessions.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<String>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CookSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $CookSessionsTable> {
  $$CookSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CookSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CookSessionsTable> {
  $$CookSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CookSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CookSessionsTable> {
  $$CookSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CookSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CookSessionsTable,
          CookSession,
          $$CookSessionsTableFilterComposer,
          $$CookSessionsTableOrderingComposer,
          $$CookSessionsTableAnnotationComposer,
          $$CookSessionsTableCreateCompanionBuilder,
          $$CookSessionsTableUpdateCompanionBuilder,
          (CookSession, $$CookSessionsTableReferences),
          CookSession,
          PrefetchHooks Function({bool recipeId})
        > {
  $$CookSessionsTableTableManager(_$AppDatabase db, $CookSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CookSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CookSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CookSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> recipeId = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> servings = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CookSessionsCompanion(
                id: id,
                recipeId: recipeId,
                startedAt: startedAt,
                completedAt: completedAt,
                servings: servings,
                rating: rating,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String recipeId,
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> servings = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CookSessionsCompanion.insert(
                id: id,
                recipeId: recipeId,
                startedAt: startedAt,
                completedAt: completedAt,
                servings: servings,
                rating: rating,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CookSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$CookSessionsTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$CookSessionsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CookSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CookSessionsTable,
      CookSession,
      $$CookSessionsTableFilterComposer,
      $$CookSessionsTableOrderingComposer,
      $$CookSessionsTableAnnotationComposer,
      $$CookSessionsTableCreateCompanionBuilder,
      $$CookSessionsTableUpdateCompanionBuilder,
      (CookSession, $$CookSessionsTableReferences),
      CookSession,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$ShoppingItemsTableCreateCompanionBuilder =
    ShoppingItemsCompanion Function({
      required String id,
      Value<String?> ingredientId,
      Value<String?> customName,
      Value<double?> quantity,
      Value<String?> unit,
      Value<bool> checked,
      Value<String?> sourceRecipeId,
      required DateTime addedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });
typedef $$ShoppingItemsTableUpdateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<String> id,
      Value<String?> ingredientId,
      Value<String?> customName,
      Value<double?> quantity,
      Value<String?> unit,
      Value<bool> checked,
      Value<String?> sourceRecipeId,
      Value<DateTime> addedAt,
      Value<bool> isSynced,
      Value<int> rowid,
    });

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRecipeId => $composableBuilder(
    column: $table.sourceRecipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get checked => $composableBuilder(
    column: $table.checked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRecipeId => $composableBuilder(
    column: $table.sourceRecipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ingredientId => $composableBuilder(
    column: $table.ingredientId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customName => $composableBuilder(
    column: $table.customName,
    builder: (column) => column,
  );

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<bool> get checked =>
      $composableBuilder(column: $table.checked, builder: (column) => column);

  GeneratedColumn<String> get sourceRecipeId => $composableBuilder(
    column: $table.sourceRecipeId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);
}

class $$ShoppingItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingItemsTable,
          ShoppingItem,
          $$ShoppingItemsTableFilterComposer,
          $$ShoppingItemsTableOrderingComposer,
          $$ShoppingItemsTableAnnotationComposer,
          $$ShoppingItemsTableCreateCompanionBuilder,
          $$ShoppingItemsTableUpdateCompanionBuilder,
          (
            ShoppingItem,
            BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>,
          ),
          ShoppingItem,
          PrefetchHooks Function()
        > {
  $$ShoppingItemsTableTableManager(_$AppDatabase db, $ShoppingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> ingredientId = const Value.absent(),
                Value<String?> customName = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<String?> sourceRecipeId = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingItemsCompanion(
                id: id,
                ingredientId: ingredientId,
                customName: customName,
                quantity: quantity,
                unit: unit,
                checked: checked,
                sourceRecipeId: sourceRecipeId,
                addedAt: addedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> ingredientId = const Value.absent(),
                Value<String?> customName = const Value.absent(),
                Value<double?> quantity = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<bool> checked = const Value.absent(),
                Value<String?> sourceRecipeId = const Value.absent(),
                required DateTime addedAt,
                Value<bool> isSynced = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingItemsCompanion.insert(
                id: id,
                ingredientId: ingredientId,
                customName: customName,
                quantity: quantity,
                unit: unit,
                checked: checked,
                sourceRecipeId: sourceRecipeId,
                addedAt: addedAt,
                isSynced: isSynced,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShoppingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingItemsTable,
      ShoppingItem,
      $$ShoppingItemsTableFilterComposer,
      $$ShoppingItemsTableOrderingComposer,
      $$ShoppingItemsTableAnnotationComposer,
      $$ShoppingItemsTableCreateCompanionBuilder,
      $$ShoppingItemsTableUpdateCompanionBuilder,
      (
        ShoppingItem,
        BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>,
      ),
      ShoppingItem,
      PrefetchHooks Function()
    >;
typedef $$UserPreferencesTableTableCreateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      Value<int> id,
      Value<String> locale,
      Value<String?> region,
      Value<String> measurementSystem,
      Value<String> allergens,
      Value<String> diets,
      Value<String> excludedIngredients,
      Value<int> householdSize,
      Value<bool> assumeStaples,
      Value<String> equipment,
      required DateTime updatedAt,
    });
typedef $$UserPreferencesTableTableUpdateCompanionBuilder =
    UserPreferencesTableCompanion Function({
      Value<int> id,
      Value<String> locale,
      Value<String?> region,
      Value<String> measurementSystem,
      Value<String> allergens,
      Value<String> diets,
      Value<String> excludedIngredients,
      Value<int> householdSize,
      Value<bool> assumeStaples,
      Value<String> equipment,
      Value<DateTime> updatedAt,
    });

class $$UserPreferencesTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get measurementSystem => $composableBuilder(
    column: $table.measurementSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get diets => $composableBuilder(
    column: $table.diets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get excludedIngredients => $composableBuilder(
    column: $table.excludedIngredients,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get householdSize => $composableBuilder(
    column: $table.householdSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get assumeStaples => $composableBuilder(
    column: $table.assumeStaples,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserPreferencesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get measurementSystem => $composableBuilder(
    column: $table.measurementSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get diets => $composableBuilder(
    column: $table.diets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get excludedIngredients => $composableBuilder(
    column: $table.excludedIngredients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get householdSize => $composableBuilder(
    column: $table.householdSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get assumeStaples => $composableBuilder(
    column: $table.assumeStaples,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get equipment => $composableBuilder(
    column: $table.equipment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserPreferencesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTableTable> {
  $$UserPreferencesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<String> get measurementSystem => $composableBuilder(
    column: $table.measurementSystem,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergens =>
      $composableBuilder(column: $table.allergens, builder: (column) => column);

  GeneratedColumn<String> get diets =>
      $composableBuilder(column: $table.diets, builder: (column) => column);

  GeneratedColumn<String> get excludedIngredients => $composableBuilder(
    column: $table.excludedIngredients,
    builder: (column) => column,
  );

  GeneratedColumn<int> get householdSize => $composableBuilder(
    column: $table.householdSize,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get assumeStaples => $composableBuilder(
    column: $table.assumeStaples,
    builder: (column) => column,
  );

  GeneratedColumn<String> get equipment =>
      $composableBuilder(column: $table.equipment, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserPreferencesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData,
          $$UserPreferencesTableTableFilterComposer,
          $$UserPreferencesTableTableOrderingComposer,
          $$UserPreferencesTableTableAnnotationComposer,
          $$UserPreferencesTableTableCreateCompanionBuilder,
          $$UserPreferencesTableTableUpdateCompanionBuilder,
          (
            UserPreferencesTableData,
            BaseReferences<
              _$AppDatabase,
              $UserPreferencesTableTable,
              UserPreferencesTableData
            >,
          ),
          UserPreferencesTableData,
          PrefetchHooks Function()
        > {
  $$UserPreferencesTableTableTableManager(
    _$AppDatabase db,
    $UserPreferencesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String> measurementSystem = const Value.absent(),
                Value<String> allergens = const Value.absent(),
                Value<String> diets = const Value.absent(),
                Value<String> excludedIngredients = const Value.absent(),
                Value<int> householdSize = const Value.absent(),
                Value<bool> assumeStaples = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => UserPreferencesTableCompanion(
                id: id,
                locale: locale,
                region: region,
                measurementSystem: measurementSystem,
                allergens: allergens,
                diets: diets,
                excludedIngredients: excludedIngredients,
                householdSize: householdSize,
                assumeStaples: assumeStaples,
                equipment: equipment,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> locale = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<String> measurementSystem = const Value.absent(),
                Value<String> allergens = const Value.absent(),
                Value<String> diets = const Value.absent(),
                Value<String> excludedIngredients = const Value.absent(),
                Value<int> householdSize = const Value.absent(),
                Value<bool> assumeStaples = const Value.absent(),
                Value<String> equipment = const Value.absent(),
                required DateTime updatedAt,
              }) => UserPreferencesTableCompanion.insert(
                id: id,
                locale: locale,
                region: region,
                measurementSystem: measurementSystem,
                allergens: allergens,
                diets: diets,
                excludedIngredients: excludedIngredients,
                householdSize: householdSize,
                assumeStaples: assumeStaples,
                equipment: equipment,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserPreferencesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserPreferencesTableTable,
      UserPreferencesTableData,
      $$UserPreferencesTableTableFilterComposer,
      $$UserPreferencesTableTableOrderingComposer,
      $$UserPreferencesTableTableAnnotationComposer,
      $$UserPreferencesTableTableCreateCompanionBuilder,
      $$UserPreferencesTableTableUpdateCompanionBuilder,
      (
        UserPreferencesTableData,
        BaseReferences<
          _$AppDatabase,
          $UserPreferencesTableTable,
          UserPreferencesTableData
        >,
      ),
      UserPreferencesTableData,
      PrefetchHooks Function()
    >;
typedef $$SyncQueueTableCreateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      required String targetTable,
      required String recordId,
      required String operation,
      required String payload,
      required DateTime createdAt,
      Value<bool> isSynced,
      Value<int> retryCount,
    });
typedef $$SyncQueueTableUpdateCompanionBuilder =
    SyncQueueCompanion Function({
      Value<int> id,
      Value<String> targetTable,
      Value<String> recordId,
      Value<String> operation,
      Value<String> payload,
      Value<DateTime> createdAt,
      Value<bool> isSynced,
      Value<int> retryCount,
    });

class $$SyncQueueTableFilterComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncQueueTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSynced => $composableBuilder(
    column: $table.isSynced,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncQueueTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncQueueTable> {
  $$SyncQueueTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isSynced =>
      $composableBuilder(column: $table.isSynced, builder: (column) => column);

  GeneratedColumn<int> get retryCount => $composableBuilder(
    column: $table.retryCount,
    builder: (column) => column,
  );
}

class $$SyncQueueTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncQueueTable,
          SyncQueueData,
          $$SyncQueueTableFilterComposer,
          $$SyncQueueTableOrderingComposer,
          $$SyncQueueTableAnnotationComposer,
          $$SyncQueueTableCreateCompanionBuilder,
          $$SyncQueueTableUpdateCompanionBuilder,
          (
            SyncQueueData,
            BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
          ),
          SyncQueueData,
          PrefetchHooks Function()
        > {
  $$SyncQueueTableTableManager(_$AppDatabase db, $SyncQueueTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncQueueTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncQueueTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncQueueTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<bool> isSynced = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => SyncQueueCompanion(
                id: id,
                targetTable: targetTable,
                recordId: recordId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                isSynced: isSynced,
                retryCount: retryCount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String targetTable,
                required String recordId,
                required String operation,
                required String payload,
                required DateTime createdAt,
                Value<bool> isSynced = const Value.absent(),
                Value<int> retryCount = const Value.absent(),
              }) => SyncQueueCompanion.insert(
                id: id,
                targetTable: targetTable,
                recordId: recordId,
                operation: operation,
                payload: payload,
                createdAt: createdAt,
                isSynced: isSynced,
                retryCount: retryCount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncQueueTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncQueueTable,
      SyncQueueData,
      $$SyncQueueTableFilterComposer,
      $$SyncQueueTableOrderingComposer,
      $$SyncQueueTableAnnotationComposer,
      $$SyncQueueTableCreateCompanionBuilder,
      $$SyncQueueTableUpdateCompanionBuilder,
      (
        SyncQueueData,
        BaseReferences<_$AppDatabase, $SyncQueueTable, SyncQueueData>,
      ),
      SyncQueueData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$IngredientNamesTableTableManager get ingredientNames =>
      $$IngredientNamesTableTableManager(_db, _db.ingredientNames);
  $$IngredientSubstitutesTableTableManager get ingredientSubstitutes =>
      $$IngredientSubstitutesTableTableManager(_db, _db.ingredientSubstitutes);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeIngredientsTableTableManager get recipeIngredients =>
      $$RecipeIngredientsTableTableManager(_db, _db.recipeIngredients);
  $$RecipeStepsTableTableManager get recipeSteps =>
      $$RecipeStepsTableTableManager(_db, _db.recipeSteps);
  $$PantryItemsTableTableManager get pantryItems =>
      $$PantryItemsTableTableManager(_db, _db.pantryItems);
  $$FavoritesTableTableManager get favorites =>
      $$FavoritesTableTableManager(_db, _db.favorites);
  $$CookSessionsTableTableManager get cookSessions =>
      $$CookSessionsTableTableManager(_db, _db.cookSessions);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
  $$UserPreferencesTableTableTableManager get userPreferencesTable =>
      $$UserPreferencesTableTableTableManager(_db, _db.userPreferencesTable);
  $$SyncQueueTableTableManager get syncQueue =>
      $$SyncQueueTableTableManager(_db, _db.syncQueue);
}
