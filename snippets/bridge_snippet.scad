// Parameterized tangent bridge using your exact geometry:
//
// Math explanation:
// In your formula:
//   c_lock_x = -R1 - lock_offset_x - r3 - mount_width/2 - lock_case_upper_radius + r_lock - 5;
// When r_lock = 11.0 and lock_case_upper_radius = 9.0:
//   (-lock_case_upper_radius + r_lock - 5) = (-9.0 + 11.0 - 5.0) = -3.0
//
// That -3.0 is the exact X-offset of the lock cylinder from lock_case_shape:
//   dx(-3 - R1 - lock_offset_x - r3 - mount_width/2)
//
// So the "-5" completely disappears and becomes the standard lock cylinder offset (-3)!

module lock_tangent_bridge_2d() {
  // Radius of the bridge anchor at the lock:
  r_lock = lock_case_upper_radius + 2.0; // 9.0 + 2.0 = 11.0mm

  // X position: perfectly aligns with the lock cylinder from lock_case_shape:
  c_lock_x = -3 - R1 - lock_offset_x - r3 - mount_width/2;

  // Z position: matches your exact formula (r_lock - 2*r3):
  c_lock_z = r_lock - 2*r3;

  // Base ring wire center under lock (-X side):
  ring_cx = R2 + r2 - R1 - r1 - gap * tan(tilt);
  c_ring_x = ring_cx - (R2 + r2);
  c_ring_z = -gap;
  r_ring = r2;

  // Sliding plane of the dovetail:
  slide_x = -(R1 + lock_offset_x + r3 + mount_width/2);

  difference() {
    // 1. Common-tangent hull between the lock anchor and the base ring wire:
    hull() {
      translate([c_lock_x, c_lock_z])
        circle(r=r_lock, $fn=64);
      translate([c_ring_x, c_ring_z])
        circle(r=r_ring, $fn=64);
    }
    
    // 2. Clear sliding face above Z = -r3 so the cage slides freely:
    translate([slide_x, -r3])
      square([50, 50]);
      
    // 3. Clear inner bore of base ring:
    translate([ring_cx, c_ring_z])
      circle(r=R2, $fn=64);
      
    // 4. Clear below the base ring wire:
    translate([c_ring_x - 50, -gap - 50])
      square([100, 50 - r_ring]);
  }
}

module lock_tangent_bridge_3d(w) {
  rotate([90, 0, 0])
    linear_extrude(height=w, center=true)
      lock_tangent_bridge_2d();
}
