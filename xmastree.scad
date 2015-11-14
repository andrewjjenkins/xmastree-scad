module treeBranch(size=10, depth=3, shallow=1) {
  difference() {
    subtractive_radius = (5.5/10)*size;
    subtractive_xoffset = size/2;
    cylinder(r=size, h=depth);
    translate([-subtractive_xoffset, -1.1, -1])
      cylinder(r=subtractive_radius, h=10);
    translate([ subtractive_xoffset, -1.1, -1])
      cylinder(r=subtractive_radius, h=10);
    translate([-subtractive_radius * 2, 0, -1])
      cube(size=size * 4);
    translate([0, 0, shallow])
      cylinder(r = (0.925 * size), h = depth);
  }
}
treeBranch();
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
    translate([0, 0, 0.8 * thickness / 2])
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
translate([0, -9.75, 0]) trunk(5);
