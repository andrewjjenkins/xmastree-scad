
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

module tree(size = 1, angle = 30, depth = 3) {
  treePlate(size = size, angle = angle, depth = depth);
  translate([0, -29 * size, 0]) trunk(size = 7 * size, thickness = 5 * size);
}

tree(size = 1);
