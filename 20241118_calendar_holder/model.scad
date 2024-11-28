module model()
{
    width = 53;
    length = 81;
    height = 10;

    cave_height = 6;
    cave_length = 10;
    cave_offset_length = 35;
    difference() {
        cube([width*2, length, height]);
        union() {
            translate([0, cave_offset_length, height - cave_height])
                cube([width, 3, cave_height]);
            translate([width, cave_offset_length, height - cave_height])
                cube([width, cave_length, cave_height]);
        }
    }
}

model();
