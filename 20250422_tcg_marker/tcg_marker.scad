include <BOSL2/std.scad>

width = 60;
height = 40;
thickness = 4;

module model()
{
    difference() {
        cuboid([width, height, thickness], rounding=1);
        translate([0, 0, thickness/2-1])
            my_text("先攻");
        translate([0, 0, -thickness/2])
            mirror([1,0,0])
                my_text("後攻");
    }
}

module my_text(text)
{
    linear_extrude(1)
        text(text, size=16, font="ヒラギノ角ゴシック:style=W6", valign="center", halign="center");
}

model();
