include <MCAD/involute_gears.scad>
include <pin_connectors/pins.scad>

// Controls which objects are included in the print.
print_gears = [1, 1, 1];
print_tree = true;

// Set this to true for final printing, but false for designing
print_gears_elsewhere = true;

bore_diameter = 6;
pressure_angle = 22;
gear_thick = 4;

// Where the pins/axles are translated.
// Gears are translated here for rendering as well, but not for printing
pins_xlat = [
  [-10, -15, 0],
  [13.2, -14.9, 6.05],
  [1.6, -2.4, 0]];

gears_xlat = print_gears_elsewhere ?
  [[50, -15, 6], [40, 20, -4], [70, 10, -4]] : pins_xlat;


module gears() {
  if (print_gears[0]) {
    printFlip = print_gears_elsewhere ? [ 180, 0, 0 ] : [ 0, 0, 0 ];
    union() {
      translate(gears_xlat[0])
      rotate(printFlip)
      union() {
        translate([0, 0, 6])
        gear(number_of_teeth = 21,
             circular_pitch = 225,
             bore_diameter = bore_diameter,
             hub_diameter = 10,
             rim_width = 1,
             hub_thickness = gear_thick,
             rim_thickness = gear_thick,
             gear_thickness = gear_thick,
             pressure_angle = pressure_angle);
        gear(number_of_teeth = 20,
             circular_pitch = 175,
             bore_diameter = bore_diameter,
             hub_diameter = 22,
             rim_width = 1,
             hub_thickness = gear_thick + 2.1,
             rim_thickness = gear_thick,
             gear_thickness = gear_thick,
             pressure_angle = pressure_angle);
      }
    }
  }

  if(print_gears[1]) {
    translate(gears_xlat[1])
      gear(number_of_teeth = 15,
           circular_pitch = 225,
           bore_diameter = bore_diameter,
           hub_diameter = 8,
           rim_width = 1,
           hub_thickness = gear_thick,
           rim_thickness = gear_thick,
           gear_thickness = gear_thick,
           pressure_angle = pressure_angle);
  }

  if(print_gears[2]) {
    translate(gears_xlat[2])
      gear(number_of_teeth = 14,
           circular_pitch = 175,
           bore_diameter = bore_diameter,
           hub_diameter = 4,
           rim_width = 1,
           hub_thickness = gear_thick,
           rim_thickness = gear_thick,
           gear_thickness = gear_thick,
           pressure_angle = pressure_angle);
  }
}
gears();

module treeBranch(size=30, angle = 30, depth=3) {
  union() {
    difference() {
      // Main cylinder: foundation of the branch
      translate([0, 0 * size, 0])
        cylinder(r=size, h=depth);

      // Subtract everything beyond [-angle, angle]
      // so that the tree branch is a subset of the circle
      translate([-size, 0, -size])
        cube(size=size * 4);
      rotate([0, 0, -angle])
        translate([0, 0, -size])
        cube(size=size * 4);
      rotate([0, 0, 90 + angle])
        translate([0, 0, -size])
        cube(size=size * 4);
    }
  }
}

module treePlate(size = 1, angle = 30, depth = 3) {
  for (scale_xform = [[29, 0], [22, 13], [15, 22], [8, 27]]) {
    xlateVec = [0, scale_xform[1] * size, 0];
    scaleSize = scale_xform[0] * size;
    translate(xlateVec)
      treeBranch(size = scaleSize, angle = angle, depth = depth);
  }
}


module trunk(size=10, thickness = 3, precision = 40) {
  growth = 1.2;
  difference() {
    translate([0, 0, 0.5 * thickness / 2])
    difference() {
      trunk_r = thickness / 2;
        rotate([90, 0, 0])
          cylinder(h = size,
                   r1 = trunk_r,
                   r2 = trunk_r * growth,
                   $fn = precision);
    }
    translate([-size, -2 * size, -2 * size])
      cube([size * 2, size * 3, size * 2]);
  }
}

module tree(size = 1, angle = 30, depth = 4) {
  treePlate(size = size, angle = angle, depth = depth);
  translate([0, -28.5 * size, 0]) trunk(size = 8 * size, thickness = 5 * size);
}

if (print_tree) {
  bore_slop = 0.82;
  translate(pins_xlat[0])
    pin(h = 12.75, r= bore_slop * (bore_diameter / 2), lh=2, lt=0.5);
  translate(pins_xlat[1])
  union() {
    pin(h = 6.75, r = bore_slop * (bore_diameter / 2), lh=2, lt=0.5);
    translate([0, 0, -6.1])
    cylinder(h = 6.11, r = 8);
  }
  translate(pins_xlat[2])
    pin(h=6.75, r = bore_slop * (bore_diameter / 2), lh=2, lt=0.5);
  translate([0, 0, -4]) tree(size = 1);
}
