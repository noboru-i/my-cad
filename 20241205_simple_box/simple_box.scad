module model()
{
    // outside x [mm]
    width = 30;  // [10:0.1:180]
    // outside y [mm]
    length = 80; // [10:0.1:180]
    // outside z [mm]
    height = 30; // [10:0.1:180]

    // wall thickness [mm]
    wall = 2; // [0.5:0.1:5]

    difference() {
        cube([width, length, height]);
        translate([wall, wall, wall])
            cube([width - wall * 2, length - wall * 2, height - wall]);
    }
}

model();
