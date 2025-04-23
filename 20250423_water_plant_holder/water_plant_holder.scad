// 穴: 直径25mm
hole_r = 12.5;
// 外側: 直径80mm
outer_r = 40;
// 厚さ: 2mm
thickness = 2;
// 高さ: 10mm
height = 10;


module model()
{
    film();
}

module film()
{
    difference() {
        cylinder(h = height, r1 = outer_r, r2 = hole_r + thickness, center = true);
        cylinder(h = height, r1 = outer_r - thickness, r2 = hole_r, center = true);
    }
}

model();
