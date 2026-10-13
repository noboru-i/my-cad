# MakerWorld cover images built from the photos in images/.
# Requires Pillow and the macOS system font Avenir Next.
#   python3 images/makerworld/make_covers.py
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter, ImageFont

OUT = Path(__file__).resolve().parent  # images/makerworld/
SRC = OUT.parent  # images/

AVENIR = "/System/Library/Fonts/Avenir Next.ttc"
F_BOLD, F_DEMI, F_MED, F_REG, F_HEAVY = 0, 2, 5, 7, 8

BG_TOP = (52, 52, 56)
BG_BOTTOM = (36, 36, 39)
ACCENT = (255, 176, 64)
WHITE = (245, 245, 245)
GREY = (170, 170, 175)

KICKER = "FOR APPLE MAGIC KEYBOARD & MAGIC TRACKPAD"
TITLE = ["Keyboard + Trackpad", "Tray"]
CHIPS = ["5 parts", "Fits A1 mini (180 mm)", "No supports", "No glue needed"]


def font(size, idx=F_BOLD):
    return ImageFont.truetype(AVENIR, size, index=idx)


def background(w, h):
    bg = Image.new("RGB", (w, h))
    d = ImageDraw.Draw(bg)
    for y in range(h):
        t = y / (h - 1)
        c = tuple(round(a + (b - a) * t) for a, b in zip(BG_TOP, BG_BOTTOM))
        d.line([(0, y), (w, y)], fill=c)
    return bg


def crop_frac(img, box):
    w, h = img.size
    l, t, r, b = box
    return img.crop((round(l * w), round(t * h), round(r * w), round(b * h)))


def rounded(img, radius):
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle((0, 0, *img.size), radius, fill=255)
    out = img.convert("RGBA")
    out.putalpha(mask)
    return out


def paste_card(canvas, img, xy, radius=28, shadow=40):
    card = rounded(img, radius)
    sh = Image.new("RGBA", (card.width + shadow * 4, card.height + shadow * 4), (0, 0, 0, 0))
    ImageDraw.Draw(sh).rounded_rectangle(
        (shadow * 2, shadow * 2, shadow * 2 + card.width, shadow * 2 + card.height),
        radius, fill=(0, 0, 0, 200))
    sh = sh.filter(ImageFilter.GaussianBlur(shadow))
    x, y = xy
    canvas.alpha_composite(sh, (x - shadow * 2, y - shadow * 2 + shadow // 2))
    canvas.alpha_composite(card, (x, y))


def fit_w(img, w):
    return img.resize((w, round(img.height * w / img.width)), Image.LANCZOS)


def fit_h(img, h):
    return img.resize((round(img.width * h / img.height), h), Image.LANCZOS)


def draw_chip(d, xy, text, size):
    f = font(size, F_DEMI)
    x, y = xy
    l, t, r, b = d.textbbox((0, 0), text, font=f)
    pad_x, pad_y = round(size * 0.75), round(size * 0.45)
    dot = round(size * 0.42)
    w = pad_x + dot + round(size * 0.5) + (r - l) + pad_x
    h = round(size * 1.25) + pad_y * 2
    d.rounded_rectangle((x, y, x + w, y + h), h // 2, outline=(110, 110, 116), width=3, fill=(62, 62, 67))
    cy = y + h / 2
    d.ellipse((x + pad_x, cy - dot / 2, x + pad_x + dot, cy + dot / 2), fill=ACCENT)
    d.text((x + pad_x + dot + round(size * 0.5), cy), text, font=f, fill=WHITE, anchor="lm")
    return w, h


def draw_tracked(d, xy, text, f, fill, tracking):
    # Pillow has no letter-spacing, so draw one character at a time.
    x, y = xy
    for ch in text:
        d.text((x, y), ch, font=f, fill=fill, anchor="la")
        x += d.textlength(ch, font=f) + tracking


def draw_text_block(d, x, y, kicker_size, title_size, title_lines=TITLE):
    draw_tracked(d, (x, y), KICKER, font(kicker_size, F_DEMI), ACCENT, 2)
    y += round(kicker_size * 1.7)
    for line in title_lines:
        d.text((x, y), line, font=font(title_size, F_HEAVY), fill=WHITE, anchor="la")
        y += round(title_size * 1.12)
    return y


in_use = Image.open(SRC / "in_use.jpg").convert("RGB")
parts = Image.open(SRC / "printed_parts.jpg").convert("RGB")
parts_crop = crop_frac(parts, (0.0, 0.025, 1.0, 1.0))
front = Image.open(SRC / "front_view.jpg").convert("RGB")
front_crop = crop_frac(front, (0.0, 0.36, 1.0, 0.6))
side = Image.open(SRC / "side_view.jpg").convert("RGB")
hero = crop_frac(in_use, (0.045, 0.04, 0.94, 0.995))
side_crop = crop_frac(side, (0.02, 0.32, 0.93, 0.545))


def side_inset(c, d, x, y, w, label_size):
    s_img = fit_w(side_crop, w)
    d.text((x, y), "Side view: sloped to match the trackpad", font=font(label_size, F_DEMI), fill=GREY, anchor="la")
    y += round(label_size * 1.5)
    paste_card(c, s_img, (x, y), radius=18, shadow=20)
    return y + s_img.height


def cover_4x3():
    W, H = 2400, 1800
    c = background(W, H).convert("RGBA")
    d = ImageDraw.Draw(c)
    m = 90
    y = draw_text_block(d, m, m, 34, 120, ["Keyboard + Trackpad Tray"])
    hero_y = y + 56
    col_min = 560
    max_hero_w = W - m * 2 - 60 - col_min
    h_img = fit_h(hero, H - m - hero_y)
    if h_img.width > max_hero_w:
        h_img = fit_w(hero, max_hero_w)
    # Split any leftover height evenly above and below the hero.
    hero_y = round((hero_y + H - m - h_img.height) / 2)
    paste_card(c, h_img, (m, hero_y))
    col_x = m + h_img.width + 60
    col_w = W - m - col_x
    bottom = hero_y + h_img.height
    chip_size = 38
    chip_h = round(chip_size * 1.25) + round(chip_size * 0.45) * 2
    chips_h = chip_h * len(CHIPS) + 22 * (len(CHIPS) - 1)
    lab = 28
    lab_h = round(lab * 1.5)
    insets = [
        ("The 5 printed parts", fit_w(parts_crop, col_w)),
        ("Front view", fit_w(front_crop, col_w)),
        ("Side view: sloped to match the trackpad", fit_w(side_crop, col_w)),
    ]
    total = chips_h + sum(lab_h + im.height for _, im in insets)
    gap = (bottom - hero_y - total) / len(insets)
    cy = hero_y
    for chip in CHIPS:
        draw_chip(d, (col_x, cy), chip, chip_size)
        cy += chip_h + 22
    cy = hero_y + chips_h
    for label, im in insets:
        cy += gap
        d.text((col_x, round(cy)), label, font=font(lab, F_DEMI), fill=GREY, anchor="la")
        paste_card(c, im, (col_x, round(cy) + lab_h), radius=18, shadow=20)
        cy += lab_h + im.height
    return c.convert("RGB")


def cover_3x4():
    W, H = 1800, 2400
    c = background(W, H).convert("RGBA")
    d = ImageDraw.Draw(c)
    m = 90
    inner_w = W - m * 2
    title = " ".join(TITLE)
    title_size = 118
    while d.textlength(title, font=font(title_size, F_HEAVY)) > inner_w:
        title_size -= 1
    h_img = fit_w(hero, inner_w)
    s_img = fit_w(side_crop, inner_w)
    chip_size, chip_gap, lab = 40, 28, 32
    chip_h = round(chip_size * 1.25) + round(chip_size * 0.45) * 2
    text_h = round(34 * 1.7) + round(title_size * 1.12)
    side_h = round(lab * 1.5) + s_img.height
    gap = (H - m * 2 - text_h - h_img.height - chip_h - side_h) / 3
    y = m
    draw_text_block(d, m, y, 34, title_size, [title])
    y += text_h + gap
    paste_card(c, h_img, (m, round(y)))
    y += h_img.height + gap
    x = m
    for chip in CHIPS:
        cw, _ = draw_chip(d, (x, round(y)), chip, chip_size)
        x += cw + chip_gap
    y += chip_h + gap
    side_inset(c, d, m, round(y), inner_w, lab)
    return c.convert("RGB")


def render_4x3():
    # Crop the sides of the 3D view screenshot to 4:3; the model stays inside.
    im = Image.open(SRC / "assembled_render.png").convert("RGB")
    w = round(im.height * 4 / 3)
    x = 92
    return im.crop((x, 0, x + w, im.height))


cover_4x3().save(OUT / "cover_4x3.jpg", quality=92)
cover_3x4().save(OUT / "cover_3x4.jpg", quality=92)
render_4x3().save(OUT / "render_4x3.png")
