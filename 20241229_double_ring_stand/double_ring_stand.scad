// bottom radius [mm]
r1 = 12; // [10:0.1:180]
// top radius [mm]
r2 = 2; // [0:0.1:2]
// cylinder height [mm]
height = 30; // [10:0.1:180]

// stand height [mm]
stand_height = 4; // [0.5:0.1:5]

module model()
{
    cylinder(h = height, r1 = r1, r2 = r2, center = false);
    translate([0, r1*2, 0])
        cylinder(h = height, r1 = r1, r2 = r2, center = false);

    translate([-r1, 0, -stand_height])
        cube([r1*2, r1*2, stand_height]);

    translate([0, 0, -stand_height])
        cylinder(h = stand_height, r = r1, center = false);
    translate([0, r1*2, -stand_height])
        cylinder(h = stand_height, r = r1, center = false);
}

model();
