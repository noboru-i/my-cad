// Hole radius
hole_r = 12.5;
// Outer radius
outer_r = 40;
// Thickness
thickness = 2;
// Height
height = 10;


module model()
{
    difference() {
        cylinder(h = height, r1 = outer_r, r2 = hole_r + thickness, center = true);
        cylinder(h = height, r1 = outer_r - thickness, r2 = hole_r, center = true);
    }
}

model();
