import os
import subprocess
import tempfile
from PIL import Image

def render_html_to_png(html_content, output_png_path, width=1024, height=1024):
    edge_path = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
    if not os.path.exists(edge_path):
        edge_path = r"C:\Program Files\Microsoft\Edge\Application\msedge.exe"

    with tempfile.NamedTemporaryFile(suffix=".html", delete=False, mode="w", encoding="utf-8") as f:
        f.write(html_content)
        temp_html = f.name

    try:
        cmd = [
            edge_path,
            "--headless=new",
            "--disable-gpu",
            f"--window-size={width},{height}",
            f"--screenshot={output_png_path}",
            "--default-background-color=00000000",
            f"file:///{temp_html.replace(os.sep, '/')}"
        ]
        res = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        print("Render result:", res.returncode, "for", output_png_path)
    finally:
        if os.path.exists(temp_html):
            os.remove(temp_html)

# 1. Full Icon HTML
full_icon_svg = open(r"d:\My Work\Flutter Projects\food app\assets\image\icon-1024.svg", "r", encoding="utf-8").read()
html_full = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  html, body {{ margin: 0; padding: 0; width: 1024px; height: 1024px; overflow: hidden; background: transparent; }}
  svg {{ width: 1024px; height: 1024px; display: block; }}
</style>
</head>
<body>
{full_icon_svg}
</body>
</html>
"""

# 2. Background only (1024x1024)
html_bg = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  html, body { margin: 0; padding: 0; width: 1024px; height: 1024px; overflow: hidden; }
  svg { width: 1024px; height: 1024px; display: block; }
</style>
</head>
<body>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
<defs>
  <radialGradient id="bg" cx="50%" cy="35%" r="75%">
    <stop offset="0%" stop-color="#1B4D3A"/>
    <stop offset="60%" stop-color="#103B2C"/>
    <stop offset="100%" stop-color="#093425"/>
  </radialGradient>
</defs>
<rect width="1024" height="1024" fill="url(#bg)"/>
</svg>
</body>
</html>
"""

# 3. Foreground only (transparent, scaled to 72% for adaptive safe zone)
html_fg = f"""<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  html, body {{ margin: 0; padding: 0; width: 1024px; height: 1024px; overflow: hidden; background: transparent; }}
  svg {{ width: 1024px; height: 1024px; display: block; }}
</style>
</head>
<body>
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" width="1024" height="1024">
<defs>
  <linearGradient id="gold" x1="0%" y1="0%" x2="100%" y2="100%">
    <stop offset="0%" stop-color="#FCD34D"/>
    <stop offset="100%" stop-color="#E5A83B"/>
  </linearGradient>
  <linearGradient id="sage" x1="0%" y1="0%" x2="100%" y2="100%">
    <stop offset="0%" stop-color="#D7F5E5"/>
    <stop offset="100%" stop-color="#A5D0BA"/>
  </linearGradient>
  <filter id="glow" x="-20%" y="-20%" width="140%" height="140%">
    <feGaussianBlur stdDeviation="10" result="blur"/>
    <feComposite in="SourceGraphic" in2="blur" operator="over"/>
  </filter>
</defs>

<g transform="translate(143, 143) scale(0.72)">
<g transform="translate(0, 36)">
  <!-- Botanical Aroma & Culinary Steam Wisps -->
  <path d="M350 400C320 360 380 340 350 300" fill="none" stroke="url(#sage)" stroke-width="26" stroke-linecap="round" opacity="0.85"/>
  <path d="M674 400C644 360 704 340 674 300" fill="none" stroke="url(#sage)" stroke-width="26" stroke-linecap="round" opacity="0.85"/>

  <!-- Celestial Culinary Magic Sparks (Saffron Gold) -->
  <path d="M512 165Q526 250 610 270Q526 290 512 375Q498 290 414 270Q498 250 512 165Z" fill="url(#gold)" filter="url(#glow)"/>
  <path d="M512 195Q522 255 580 270Q522 285 512 345Q502 285 444 270Q502 255 512 195Z" fill="#FFFBEB"/>
  <path d="M700 185Q706 215 734 222Q706 229 700 259Q694 229 666 222Q694 215 700 185Z" fill="url(#gold)"/>

  <!-- Dutch Oven Knob -->
  <circle cx="512" cy="410" r="34" fill="#FCFAF7"/>
  <circle cx="512" cy="410" r="18" fill="url(#gold)"/>

  <!-- Dutch Oven Lid -->
  <rect x="252" y="438" width="520" height="64" rx="32" fill="#FCFAF7"/>
  <rect x="272" y="474" width="480" height="16" rx="8" fill="url(#sage)"/>

  <!-- Side Handles -->
  <rect x="162" y="546" width="76" height="40" rx="20" fill="#FCFAF7"/>
  <rect x="786" y="546" width="76" height="40" rx="20" fill="#FCFAF7"/>

  <!-- Dutch Oven Pot Base -->
  <path d="M232 516H792V600Q792 765 632 765H392Q232 765 232 600Z" fill="#FCFAF7"/>
  <path d="M232 516H792V550H232Z" fill="#E6E2D9"/>

  <!-- Botanical Emblem Badge in Center of Pot -->
  <circle cx="512" cy="650" r="44" fill="#1B4D3A"/>
  <path d="M512 622C528 638 534 660 512 676C490 660 496 638 512 622Z" fill="url(#sage)"/>
  <path d="M512 630V668" stroke="#1B4D3A" stroke-width="3" stroke-linecap="round"/>
</g>
</g>
</svg>
</body>
</html>
"""

out_icon = r"d:\My Work\Flutter Projects\food app\assets\image\icon-1024.png"
out_bg = r"d:\My Work\Flutter Projects\food app\assets\image\icon-background.png"
out_fg = r"d:\My Work\Flutter Projects\food app\assets\image\icon-foreground.png"
out_dash = r"d:\My Work\Flutter Projects\smart_cook_dashboard\public\app-icon.png"

render_html_to_png(html_full, out_icon)
render_html_to_png(html_bg, out_bg)
render_html_to_png(html_fg, out_fg)
render_html_to_png(html_full, out_dash)

# Verify with PIL
for path in [out_icon, out_bg, out_fg, out_dash]:
    if os.path.exists(path):
        img = Image.open(path)
        print(f"Verified {path}: size={img.size}, mode={img.mode}")
    else:
        print(f"Error: missing {path}")

