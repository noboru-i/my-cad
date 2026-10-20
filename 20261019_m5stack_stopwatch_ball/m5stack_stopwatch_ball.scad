// All dimensions are millimetres.
// Adjust parameters below before changing the model.
width = 76;
height = 70;
depth = 15.5;

device_diameter = 52;
clearance = 0.8;
display_tilt = 27;
button_radius = 26;
button_angle = 45;
$fn = 96;

module device_space() {
  translate([0, -5, 40])
    rotate([90 - display_tilt, 0, 0])
      children();
}

module model() {
  difference() {
    intersection() {
      translate([0, 0, 38])
        sphere(d = width);
      translate([-width / 2, -width / 2, 6])
        cube([width, width, height]);
    }

    // StopWatch body pocket. The rear face stops the device at the viewing angle.
    device_space()
      cylinder(d = device_diameter + clearance * 2, h = depth + 16);

    // Clear the space in front of the display.
    device_space()
      translate([0, 0, depth])
        cylinder(d = device_diameter + clearance * 2, h = width);

    // KEY A opening.
    device_space()
      rotate([0, 0, -button_angle])
        translate([-button_radius - 9, -10, -2])
          cube([18, 20, depth + 20]);

    // KEY B opening.
    device_space()
      rotate([0, 0, -button_angle])
        translate([-10, button_radius - 9, -2])
          cube([20, 18, depth + 20]);

    // Power button and USB-C cable opening.
    device_space()
      translate([-14, -35, -2])
        cube([28, 30, depth + 20]);
  }
}

model();