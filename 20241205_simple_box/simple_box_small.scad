// outside x [mm]
width = 20;  // [10:0.1:180]
// outside y [mm]
length = 20; // [10:0.1:180]
// outside z [mm]
height = 10; // [10:0.1:180]

// wall thickness [mm]
wall = 1; // [0.5:0.1:5]

module model()
{
    difference() {
        cube([width, length, height]);
        translate([wall, wall, wall])
            cube([width - wall * 2, length - wall * 2, height - wall]);
    }
}

model();
