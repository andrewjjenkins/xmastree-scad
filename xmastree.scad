module treeBranch(size=30, angle = 30, depth=3, shallow=1) {
  subtractive_radius = (5.5/10)*size;
  subtractive_xoffset = size/2;
  border_thick = 0.075;

  union() {
    difference() {
      translate([0, 0 * size, 0])
      difference() {
        // Main cylinder: foundation of the branch
        cylinder(r=size, h=depth);
        // Sub-cylinder that makes the lowered area
        translate([0, 0, shallow])
          cylinder(r = ((1 - border_thick) * size), h = depth);
      }

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

  // Raised areas on the radials where the branches end
  rotate([0, 0, 90+angle])
    translate([-border_thick * size, 0, 0])
    cube([border_thick * size, (1 - border_thick) * size, depth]);
  rotate([0, 0, -90-angle])
    cube([border_thick * size, (1 - border_thick) * size, depth]);
  }
}
treeBranch();
translate([0, 13, 0]) treeBranch(size = 22);
translate([0, 22, 0]) treeBranch(size = 15);
translate([0, 27, 0]) treeBranch(size = 8);
//translate([-6, 0, 0]) treeBranch();
//translate([0, -20, 0]) treeBranch(size=40);

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
translate([0, -29.75, 0]) trunk(size = 7, thickness = 5);
