include <BOSL2/std.scad>

base_height = 6.5;

length = 140;

round_parameter=4;

module hole() {
    rotate([0, 90, 0])
        translate([0, 0, 0.5])
            cylinder(h = 5, r=4.5, $fn=8);
    rotate([0, 90, 0])
        cylinder(h = 0.5, r=2.5, $fn=8);
}

module model()
{
    // base
    cuboid([33, 50, base_height],
        rounding=2,
        edges=[TOP+FRONT, TOP+BACK],
        $fn=round_parameter,
        anchor=FRONT+LEFT+BOT);
    translate([0, 90, 0])
        cuboid([33, 50, base_height],
            rounding=2,
            edges=[TOP+FRONT, TOP+BACK],
            $fn=round_parameter,
            anchor=FRONT+LEFT+BOT);

    // wall
    difference() {
        cube([5.5, length, 60]);
        translate([0, 10, 50])
            hole();
        translate([0, length - 10, 50])
            hole();
    }

    // hook
    translate([33-base_height, 0, 0])
        cuboid([base_height, 50, 16],
            rounding=2,
            edges=[TOP+FRONT, TOP+LEFT, TOP+BACK, FRONT+LEFT, BACK+LEFT],
            $fn=round_parameter,
            anchor=FRONT+LEFT+BOT);
    translate([33-base_height, 90, 0])
        cuboid([base_height, 50, 16],
            rounding=2,
            edges=[TOP+FRONT, TOP+LEFT, TOP+BACK, FRONT+LEFT, BACK+LEFT],
            $fn=round_parameter,
            anchor=FRONT+LEFT+BOT);
}

model();
