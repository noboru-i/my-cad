base_height = 6.5;

module hole() {
    rotate([0, 90, 0])
        translate([0, 0, 0.5])
            cylinder(h = 6, r=4.5);
    rotate([0, 90, 0])
        cylinder(h = 0.5, r=2.5);
}

module model()
{
    // base
    cube([42, 50, base_height]);
    translate([0, 100, 0])
        cube([42, 50, base_height]);

    // wall
    difference() {
        cube([6.5, 150, 60]);
        translate([0, 10, 50])
            hole();
        translate([0, 150 - 10, 50])
            hole();
    }

    // hook
    translate([35.5, 0, 0])
        cube([base_height, 50, 30]);
    translate([35.5, 100, 0])
        cube([base_height, 50, 30]);
}

model();
