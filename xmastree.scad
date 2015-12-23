include <MCAD/involute_gears.scad>

bore_diameter = 6;
pressure_angle = 25;
gear_thick = 4;

print_gears = true;
print_tree = true;

if (print_gears) {
  translate([-10, -15, 0])
  union() {
    gear(number_of_teeth = 21,
         circular_pitch = 300,
         bore_diameter = bore_diameter,
         hub_diameter = 4,
         rim_width = 1,
         hub_thickness = gear_thick,
         rim_thickness = gear_thick,
         gear_thickness = gear_thick,
         pressure_angle = pressure_angle);

    translate([0, 0, 4])
      gear(number_of_teeth = 19,
           circular_pitch = 250,
           bore_diameter = bore_diameter,
           hub_diameter = 4,
           rim_width = 1,
           hub_thickness = gear_thick,
           rim_thickness = gear_thick,
           gear_thickness = gear_thick,
           pressure_angle = pressure_angle);

    translate([35, 0, 0])
      gear(number_of_teeth = 15,
           circular_pitch = 300,
           bore_diameter = bore_diameter,
           hub_diameter = 4,
           rim_width = 1,
           hub_thickness = gear_thick,
           rim_thickness = gear_thick,
           gear_thickness = gear_thick,
           pressure_angle = pressure_angle);

    translate([70, 0, 0])
      gear(number_of_teeth = 18,
           circular_pitch = 350,
           bore_diameter = bore_diameter,
           hub_diameter = 4,
           rim_width = 1,
           hub_thickness = gear_thick,
           rim_thickness = gear_thick,
           gear_thickness = gear_thick,
           pressure_angle = pressure_angle);
  }
}

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

  module trunkVein(rot = 0) {
    r = thickness / 8;
    y_deg = atan((growth - 1) / size);
    rotate([0, 0, y_deg])
    translate([1.2 * thickness / 2, -0.1 * size, 0])
    rotate([90, 0, 0])
    cylinder(h = 0.8 * size, r = r, $fn = precision);
  }
  
  difference() {
    translate([0, 0, 0.5 * thickness / 2])
    difference() {
      trunk_r = thickness / 2;
        rotate([90, 0, 0])
          cylinder(h = size,
                   r1 = trunk_r,
                   r2 = trunk_r * growth,
                   $fn = precision);
        rotate([0, -160, 0]) trunkVein();
        rotate([0, -110, 0]) trunkVein();
        rotate([0, -80, 0]) trunkVein();
        rotate([0, -40, 0]) trunkVein();
        rotate([0, -5, 0]) trunkVein();
    }
    translate([-size, -2 * size, -2 * size])
      cube([size * 2, size * 3, size * 2]);
  }
}

module tree(size = 1, angle = 30, depth = 4) {
  treePlate(size = size, angle = angle, depth = depth);
  translate([0, -29 * size, 0]) trunk(size = 7 * size, thickness = 5 * size);
}

if (print_tree) {
  translate([0, 0, -4]) tree(size = 1);
}
