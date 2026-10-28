use <handyfunctions.scad>
use <stealth_lock.scad>
use <fusion_lock.scad>
use <torus.scad>
use <vec3math.scad>
use <threads.scad>

use <d_cage.scad>

R1 = 13.5;
lock_offset_x = 10.0;
r3 = 2.4;
mount_width = 5.0;
mount_height = 18.0;
tilt = 8.0;
gap = 12.0;
R2 = 21.0;
r2 = 4.0;
r1 = 2.0;

lock_case_upper_radius = 9.0;
lock_case_lower_radius = 4.0;
mount_length = 24.0;
part_margin = 0.2;
bridge_w = 20.0 - 2*part_margin; // 19.6mm

// Circle 1: Top of lock
c_top_x = -3 - R1 - lock_offset_x - r3 - mount_width/2;
c_top_z = mount_height * cos(tilt) - lock_case_upper_radius;
r_top = lock_case_upper_radius;

// Circle 2: That corner radius we are targeting!
lower_r = 2.0;
c_corner_x = -R1 - lock_offset_x - r3 - mount_width/2 - lock_case_upper_radius + lower_r;
c_corner_z = lower_r - 2*r3;
r_corner = lower_r;

// Circle 3: Base ring wire
ring_cx = R2 + r2 - R1 - r1 - gap * tan(tilt);
c_ring_x = ring_cx - (R2 + r2);
c_ring_z = -gap;
r_ring = r2;

slide_x = -(R1 + lock_offset_x + r3 + mount_width/2);

module test_three_circle_bridge_2d() {
  difference() {
    // Convex hull of all three circles:
    hull() {
      translate([c_top_x, c_top_z]) circle(r=r_top, $fn=64);
      translate([c_corner_x, c_corner_z]) circle(r=r_corner, $fn=64);
      translate([c_ring_x, c_ring_z]) circle(r=r_ring, $fn=64);
    }
    
    // Clear sliding face above Z = -r3
    translate([slide_x, -r3]) square([50, 50]);
    
    // Clear inner bore of base ring
    translate([ring_cx, c_ring_z]) circle(r=R2, $fn=64);
    
    // Clear below body side of base ring
    translate([c_ring_x - 50, -gap - 50]) square([100, 50 - r_ring]);
  }
}

module test_three_circle_bridge_3d(w) {
  rotate([90, 0, 0])
    linear_extrude(height=w, center=true)
      test_three_circle_bridge_2d();
}

// Show assembled cage and base ring
cage();
dz(-gap) dx(R2+r2-R1-r1-gap*tan(tilt)) scale([1, 1, 1]) base_ring();

difference() {
  union() {
    dy(mount_length/3) lock_case_shape(mount_length/3, outer=true);
    my() dy(mount_length/3) lock_case_shape(mount_length/3, outer=true);
    test_three_circle_bridge_3d(bridge_w);
  }
  lock_cavity();
  dz(-r3) skewxz(tan(tilt))
    translate([-100, -(mount_length/6 + part_margin), -r3])
      cube([150, 2*(mount_length/6 + part_margin), mount_height*cos(tilt) + 2*r3]);
}
