// outside x [mm]
width = 120;  // [10:0.1:180]
// outside y [mm]
length = 70; // [10:0.1:180]
// outside z [mm]
height = 65; // [10:0.1:180]

// wall thickness [mm]
wall = 5; // [1:0.1:5]

module hook()
{
    hook_width = width;
    hook_length = 18;
    hook_height = 5;
    translate([0, -hook_length, height - hook_height])
        cube([hook_width, hook_length, hook_height]);

    hook2_length = 20;
    translate([0, -hook_length, height - hook2_length])
        cube([hook_width, hook_height, hook2_length]);
}

module model()
{
    hook();
    difference() {
        cube([width, length, height]);
        translate([wall, wall, wall])
            cube([width - wall * 2, length - wall * 2, height - wall]);
    }
}

model();
