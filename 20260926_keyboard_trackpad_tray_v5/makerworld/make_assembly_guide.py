# Assembly guide PDFs (English and Japanese): renders each step with
# assembly_steps.scad, lays the pages out in HTML and prints them with
# headless Chrome.
# Requires OpenSCAD (manifold backend), Pillow and Google Chrome.
#   python3 makerworld/make_assembly_guide.py
# Output: assembly_guide.pdf (English), assembly_guide_ja.pdf (Japanese)
import html
import subprocess
import tempfile
from pathlib import Path
from PIL import Image, ImageChops

OUT = Path(__file__).resolve().parent  # makerworld/
PHOTOS = OUT.parent / "images"
CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
CAMERA = "80,110,35,55,0,25,850"
IMG_SIZE = (1600, 1100)

# Badge positions on printed_parts.jpg (percent of width / height)
PARTS = [("A", (50, 74)), ("B", (29, 24)), ("C", (76, 24)), ("D", (13, 74)), ("E", (86, 74))]

TEXT = {
    "en": {
        "file": "assembly_guide.pdf",
        "lang": "en",
        "font": '"Avenir Next", "Helvetica Neue", sans-serif',
        "kicker": "For Apple Magic Keyboard &amp; Magic Trackpad",
        "title": "Keyboard + Trackpad Tray",
        "sub": "Assembly guide. Assembled size: 286 × 229.8 × 23.4 mm.",
        "need": "What you need",
        "part_head": ("Printed part", "Qty"),
        "parts": ["Trackpad frame", "Keyboard base, left", "Keyboard base, right",
                  "Wrist rest, left", "Wrist rest, right"],
        "also": [
            "Also: Magic Keyboard, Magic Trackpad and the trackpad's charging cable.",
            "No glue, screws or tools needed. All parts slide together from above.",
        ],
        "before": "Before you start",
        "before_items": [
            "Remove all support material, especially from the dovetail tongues and grooves. "
            "Leftover support stops the joints from sliding in.",
            "Some joints are tight. Be ready to press parts down firmly (see step 4).",
            "Turn on the trackpad first. Its power switch ends up under the keyboard.",
        ],
        "assembly": "Assembly",
        "legend": ("part to add", "parts already in place", "trackpad"),
        "steps": [
            ("Place the trackpad frame",
             "Put the trackpad frame on a flat surface. Leave the trackpad out for now; "
             "the tray goes over it at the end."),
            ("Add the left keyboard base",
             "Slide the left keyboard base down onto the dovetail at the back of the frame."),
            ("Add the right keyboard base",
             "Slide the right keyboard base down. It locks into the left base and the frame at the same time, "
             "so the left base has to go in first."),
            ("Add the wrist rests",
             "Lower the left and right wrist rests onto the sides. Each one locks into the frame and a keyboard base. "
             "The joints between the keyboard bases and the wrist rests (B to D, C to E) are tight. "
             "You may need to press the wrist rests down firmly."),
            ("Set the tray over the trackpad",
             "Plug the cable into the trackpad and lay it straight back from the port. "
             "Lower the assembled tray over the trackpad. The cable passes under the frame's rear wall "
             "and through the channel under the left keyboard base. "
             "The wrist rests cover 20 mm of each side of the trackpad."),
            ("Place the keyboard",
             "Set the keyboard on the base with its front edge against the wrist rests. "
             "To charge it in the tray, plug its cable in through the cutout in the rear wall."),
        ],
        "done": "Done",
        "tips": "Tips",
        "tips_items": [
            "To reach the trackpad's power switch later, slide the keyboard aside.",
            "To take the tray apart, lift the parts out in the reverse order.",
        ],
    },
    "ja": {
        "file": "assembly_guide_ja.pdf",
        "lang": "ja",
        "font": '"Avenir Next", "Hiragino Sans", sans-serif',
        "kicker": "For Apple Magic Keyboard &amp; Magic Trackpad",
        "title": "キーボード + トラックパッド トレイ",
        "sub": "組立ガイド。組立後の大きさ: 286 × 229.8 × 23.4mm",
        "need": "用意するもの",
        "part_head": ("印刷パーツ", "個数"),
        "parts": ["トラックパッド外枠", "キーボード土台 左", "キーボード土台 右",
                  "リストレスト 左", "リストレスト 右"],
        "also": [
            "ほかに Magic Keyboard、Magic Trackpad、トラックパッドの充電ケーブルを用意する。",
            "接着剤・ネジ・工具は不要。すべてのパーツを上から差し込んで組み立てる。",
        ],
        "before": "組み立ての前に",
        "before_items": [
            "サポート材をすべて取り除く。特にダブテールの凸と溝に残っていると、差し込めなくなる。",
            "きつい接合部がある。力を入れて押し込む必要がある（手順 4 を参照）。",
            "トラックパッドの電源を先に入れておく。電源スイッチは最後にキーボードの下に隠れる。",
        ],
        "assembly": "組み立て",
        "legend": ("取り付けるパーツ", "取り付け済みのパーツ", "トラックパッド"),
        "steps": [
            ("トラックパッド外枠を置く",
             "トラックパッド外枠を平らな場所に置く。トラックパッドはまだ入れない。"
             "トレイを組み立ててから、最後にトラックパッドに被せる。"),
            ("キーボード土台 左を取り付ける",
             "キーボード土台 左を、枠の奥のダブテールに上から差し込む。"),
            ("キーボード土台 右を取り付ける",
             "キーボード土台 右を上から差し込む。左の土台と枠の両方に同時に入るので、"
             "左の土台を先に取り付けておく。"),
            ("リストレストを取り付ける",
             "左右のリストレストを上から下ろす。それぞれ枠とキーボード土台に同時に入る。"
             "キーボード土台とリストレストの接合部（B と D、C と E）はきついので、"
             "力を入れて押し込む必要がある場合がある。"),
            ("トレイをトラックパッドに被せる",
             "トラックパッドにケーブルを挿し、ポートからまっすぐ後ろへ伸ばす。"
             "組み立てたトレイをトラックパッドに上から被せる。ケーブルは枠の奥壁の下を通り、"
             "キーボード土台 左の下の溝から背面へ出る。"
             "リストレストはトラックパッドの左右端を 20mm ずつ覆う。"),
            ("キーボードを置く",
             "キーボードを土台に載せ、手前の端をリストレストに当てる。"
             "トレイに置いたまま充電するときは、奥壁の切り欠きからケーブルを挿す。"),
        ],
        "done": "完成",
        "tips": "補足",
        "tips_items": [
            "あとでトラックパッドの電源スイッチを操作するときは、キーボードをずらす。",
            "分解するときは、組み立てと逆の順にパーツを上へ持ち上げて外す。",
        ],
    },
}
STEP_COUNT = 6


def render_steps(tmp):
    paths = []
    for step in range(1, STEP_COUNT + 1):
        path = tmp / f"step{step}.png"
        subprocess.run(
            ["openscad", "--render", "--backend=manifold", "-D", f"step={step}",
             f"--imgsize={IMG_SIZE[0]},{IMG_SIZE[1]}", "--colorscheme=Tomorrow",
             f"--camera={CAMERA}", "-o", str(path), str(OUT / "assembly_steps.scad")],
            check=True, capture_output=True)
        paths.append(path)
    # Crop every image to the same box so the tray keeps its size and place.
    box = None
    for path in paths:
        im = Image.open(path).convert("RGB")
        bg = Image.new("RGB", im.size, im.getpixel((0, 0)))
        b = ImageChops.difference(im, bg).getbbox()
        box = b if box is None else (min(box[0], b[0]), min(box[1], b[1]), max(box[2], b[2]), max(box[3], b[3]))
    pad = 30
    box = (max(box[0] - pad, 0), max(box[1] - pad, 0), min(box[2] + pad, IMG_SIZE[0]), min(box[3] + pad, IMG_SIZE[1]))
    for path in paths:
        Image.open(path).crop(box).save(path)
    return {int(p.stem[4:]): p for p in paths}


CSS = """
@page { size: A4; margin: 16mm 16mm 14mm; }
* { box-sizing: border-box; }
body { margin: 0; font-family: FONT; color: #222; font-size: 10.5pt; line-height: 1.5; }
.page { page-break-after: always; }
.page:last-child { page-break-after: auto; }
.kicker { color: #e08a00; font-weight: 600; letter-spacing: 0.08em; font-size: 9pt; text-transform: uppercase; }
h1 { font-size: 26pt; font-weight: 800; margin: 2mm 0 1mm; line-height: 1.1; }
.sub { color: #666; margin: 0 0 6mm; }
h2 { font-size: 14pt; font-weight: 700; margin: 6mm 0 3mm; border-bottom: 2px solid #ff9f1c; padding-bottom: 1mm; }
.parts { display: grid; grid-template-columns: 1.3fr 1fr; gap: 6mm; align-items: start; }
.photo { position: relative; }
.photo img { width: 100%; border-radius: 2mm; display: block; }
.badge { position: absolute; transform: translate(-50%, -50%); width: 7mm; height: 7mm; border-radius: 50%;
  background: #ff9f1c; color: #fff; font-weight: 700; font-size: 10pt; display: flex; align-items: center; justify-content: center;
  box-shadow: 0 0 0 0.6mm #fff; }
table { border-collapse: collapse; width: 100%; }
td, th { text-align: left; padding: 1.2mm 1.5mm; border-bottom: 1px solid #e3e3e3; vertical-align: top; }
th { font-weight: 600; color: #666; font-size: 9pt; }
.key { display: inline-flex; width: 5.5mm; height: 5.5mm; border-radius: 50%; background: #ff9f1c; color: #fff;
  font-weight: 700; font-size: 8.5pt; align-items: center; justify-content: center; }
.note { break-inside: avoid; background: #fff4e3; border-left: 1.2mm solid #ff9f1c; padding: 3mm 4mm; border-radius: 1mm; margin: 4mm 0; }
.note b { display: block; margin-bottom: 1mm; }
ul { margin: 0; padding-left: 5mm; }
.step { display: grid; grid-template-columns: 1fr 0.8fr; gap: 6mm; align-items: center; margin-bottom: 4mm; break-inside: avoid; }
.step img { width: 100%; display: block; border-radius: 2mm; }
.num { display: inline-flex; width: 9mm; height: 9mm; border-radius: 50%; background: #222; color: #fff; font-weight: 700;
  font-size: 13pt; align-items: center; justify-content: center; margin-bottom: 2mm; }
.step h3 { font-size: 13pt; margin: 0 0 1.5mm; }
.step p { margin: 0; }
.legend { color: #666; font-size: 9pt; margin: -1mm 0 4mm; }
.swatch { display: inline-block; width: 3mm; height: 3mm; border-radius: 0.5mm; vertical-align: -0.3mm; margin: 0 1mm 0 3mm; }
.done { break-inside: avoid; }
.done img { width: 62%; display: block; margin: 0 auto; border-radius: 2mm; }
"""


def build_html(renders, t):
    e = html.escape
    badges = "".join(
        f'<span class="badge" style="left:{x}%;top:{y}%">{k}</span>' for k, (x, y) in PARTS)
    rows = "".join(f'<tr><td><span class="key">{k}</span></td><td>{e(n)}</td><td>1</td></tr>'
                   for (k, _), n in zip(PARTS, t["parts"]))
    steps = [
        f'<div class="step"><img src="{renders[i].as_uri()}">'
        f'<div><div class="num">{i}</div><h3>{e(title)}</h3><p>{e(desc)}</p></div></div>'
        for i, (title, desc) in enumerate(t["steps"], 1)]
    add, placed, trackpad = (e(x) for x in t["legend"])
    legend = ('<p class="legend">'
              f'<span class="swatch" style="background:#ff9f1c;margin-left:0"></span>{add}'
              f'<span class="swatch" style="background:#5c5c63"></span>{placed}'
              f'<span class="swatch" style="background:#b9cde3"></span>{trackpad}</p>')
    also = "".join(f'<p{" style=\"margin-top:3mm\"" if i == 0 else ""}>{e(x)}</p>' for i, x in enumerate(t["also"]))
    before = "".join(f"<li>{e(x)}</li>" for x in t["before_items"])
    tips = "".join(f"<li>{e(x)}</li>" for x in t["tips_items"])
    css = CSS.replace("FONT", t["font"])
    return f"""<!doctype html><html lang="{t['lang']}"><head><meta charset="utf-8"><title>{e(t['title'])}</title><style>{css}</style></head><body>
<section class="page">
  <div class="kicker">{t['kicker']}</div>
  <h1>{e(t['title'])}</h1>
  <p class="sub">{e(t['sub'])}</p>
  <h2>{e(t['need'])}</h2>
  <div class="parts">
    <div class="photo"><img src="{(PHOTOS / 'printed_parts.jpg').as_uri()}">{badges}</div>
    <div>
      <table><tr><th></th><th>{e(t['part_head'][0])}</th><th>{e(t['part_head'][1])}</th></tr>{rows}</table>
      {also}
    </div>
  </div>
  <div class="note"><b>{e(t['before'])}</b>
    <ul>{before}</ul>
  </div>
  <h2>{e(t['assembly'])}</h2>
  {legend}
  {steps[0]}
</section>
<section class="page">
  {''.join(steps[1:4])}
</section>
<section class="page">
  {''.join(steps[4:])}
  <div class="done">
  <h2>{e(t['done'])}</h2>
  <img src="{(PHOTOS / 'in_use.jpg').as_uri()}">
  <div class="note"><b>{e(t['tips'])}</b>
    <ul>{tips}</ul>
  </div>
  </div>
</section>
</body></html>"""


def main():
    with tempfile.TemporaryDirectory() as d:
        tmp = Path(d)
        renders = render_steps(tmp)
        for lang, t in TEXT.items():
            page = tmp / f"guide_{lang}.html"
            page.write_text(build_html(renders, t), encoding="utf-8")
            subprocess.run(
                [CHROME, "--headless=new", "--no-pdf-header-footer", "--disable-gpu",
                 f"--print-to-pdf={OUT / t['file']}", page.as_uri()],
                check=True, capture_output=True)


main()
