#!/usr/bin/env python3
"""Generate the Sakeena launcher icon set with no external dependencies.

The mark is a minimal counter dial: a cream ring with a solid dot in the
middle, on the app's olive identity colour. It is drawn analytically
(1px feather) so it stays crisp at 48 px and at 1024 px alike.

Run from the project root:

    python3 tool/generate_icons.py
"""

from __future__ import annotations

import math
import os
import struct
import zlib

OLIVE = (0x6F, 0x7C, 0x4E)
CREAM = (0xF2, 0xF1, 0xEA)

RES = os.path.join("android", "app", "src", "main", "res")
ASSETS = os.path.join("assets", "icon")

LEGACY_SIZES = {"mdpi": 48, "hdpi": 72, "xhdpi": 96, "xxhdpi": 144, "xxxhdpi": 192}
FOREGROUND_SIZES = {"mdpi": 108, "hdpi": 162, "xhdpi": 216, "xxhdpi": 324, "xxxhdpi": 432}


def _clamp01(value: float) -> float:
    if value < 0.0:
        return 0.0
    if value > 1.0:
        return 1.0
    return value


def render(
    size: int,
    *,
    disk_radius: float = 0.0,
    ring_outer: float = 0.0,
    ring_thickness: float = 0.0,
    dot_radius: float = 0.0,
) -> list[bytearray]:
    """Return RGBA rows for one icon.

    All radii are in pixels. A radius of 0 disables that shape.
    """
    centre = size / 2.0
    ring_inner = ring_outer - ring_thickness
    rows: list[bytearray] = []

    for y in range(size):
        dy = y + 0.5 - centre
        row = bytearray()
        for x in range(size):
            dx = x + 0.5 - centre
            distance = math.hypot(dx, dy)

            red = green = blue = alpha = 0.0

            if disk_radius > 0.0:
                coverage = _clamp01(0.5 + disk_radius - distance)
                if coverage > 0.0:
                    red, green, blue = (float(channel) for channel in OLIVE)
                    alpha = coverage

            coverage = 0.0
            if ring_outer > 0.0 and distance <= ring_outer + 1.0:
                coverage = min(
                    _clamp01(0.5 + ring_outer - distance),
                    _clamp01(0.5 + distance - ring_inner),
                )
            if dot_radius > 0.0 and distance <= dot_radius + 1.0:
                coverage = max(coverage, _clamp01(0.5 + dot_radius - distance))

            if coverage > 0.0:
                keep = 1.0 - coverage
                red = CREAM[0] * coverage + red * keep
                green = CREAM[1] * coverage + green * keep
                blue = CREAM[2] * coverage + blue * keep
                alpha = coverage + alpha * keep

            row += bytes(
                (
                    int(red + 0.5),
                    int(green + 0.5),
                    int(blue + 0.5),
                    int(alpha * 255.0 + 0.5),
                )
            )
        rows.append(row)

    return rows


def write_png(path: str, size: int, rows: list[bytearray]) -> None:
    def chunk(kind: bytes, payload: bytes) -> bytes:
        body = kind + payload
        return struct.pack(">I", len(payload)) + body + struct.pack(">I", zlib.crc32(body))

    raw = b"".join(b"\x00" + bytes(row) for row in rows)
    header = struct.pack(">IIBBBBB", size, size, 8, 6, 0, 0, 0)
    png = (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", header)
        + chunk(b"IDAT", zlib.compress(raw, 9))
        + chunk(b"IEND", b"")
    )

    os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "wb") as handle:
        handle.write(png)


def legacy_mark(size: int) -> list[bytearray]:
    """Round olive badge with the cream dial — used below Android 8.0."""
    outer = size * 0.36
    return render(
        size,
        disk_radius=size * 0.5,
        ring_outer=outer,
        ring_thickness=outer * 0.22,
        dot_radius=size * 0.09,
    )


def adaptive_foreground(size: int) -> list[bytearray]:
    """Transparent 108dp canvas; the mark stays inside the 72dp safe zone."""
    outer = size * 0.30
    return render(
        size,
        ring_outer=outer,
        ring_thickness=outer * 0.22,
        dot_radius=size * 0.09,
    )


def square_icon(size: int) -> list[bytearray]:
    """Full-bleed olive square for tooling (flutter_launcher_icons source)."""
    outer = size * 0.36
    return render(
        size,
        disk_radius=size,
        ring_outer=outer,
        ring_thickness=outer * 0.22,
        dot_radius=size * 0.09,
    )


def main() -> None:
    for density, size in LEGACY_SIZES.items():
        write_png(os.path.join(RES, f"mipmap-{density}", "ic_launcher.png"), size, legacy_mark(size))

    for density, size in FOREGROUND_SIZES.items():
        write_png(
            os.path.join(RES, f"drawable-{density}", "ic_launcher_foreground.png"),
            size,
            adaptive_foreground(size),
        )

    write_png(os.path.join(ASSETS, "icon.png"), 1024, square_icon(1024))
    write_png(os.path.join(ASSETS, "icon_foreground.png"), 1024, adaptive_foreground(1024))

    print("Icons written.")


if __name__ == "__main__":
    main()
