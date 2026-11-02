include <handyfunctions.scad>

module stealth_lock(
  dia = 5.8,
  len = 18.8,
  cam_len = 4.0,
  pin_h = 8.1,
  pin_w = 3.2,
  cam_angle = 50,
  clockwise = true,
  blind = false,
  slop = 0,
  z_slop = 0
) {
  r = dia/2;
  dir = clockwise ? -1 : 1;
  h_cyl = blind ? len + 50 : len + 100;
  y_start = blind ? -len : -len - 50;

  union() {
    // 1. Single continuous through cylinder along Y:
    // One uninterrupted primitive cylinder guarantees 100% clean through-visibility with zero coplanar face artifacts
    if (z_slop == 0) {
      translate([0, y_start, 0])
        rotate([-90, 0, 0])
          cylinder(r=r+slop, h=h_cyl);
    } else {
      hull() {
        dz(-z_slop) translate([0, y_start, 0]) rotate([-90, 0, 0]) cylinder(r=r+slop, h=h_cyl);
        dz(z_slop)  translate([0, y_start, 0]) rotate([-90, 0, 0]) cylinder(r=r+slop, h=h_cyl);
      }
    }
    // 2. Insertion fin slot from entrance (+50) to end of lock (-len):
    if (z_slop == 0) {
      translate([-pin_w/2 - slop, -len, -pin_h - slop])
        cube([pin_w + 2*slop, len + 50, pin_h + slop]);
    } else {
      hull() {
        dz(-z_slop) translate([-pin_w/2 - slop, -len, -pin_h - slop]) cube([pin_w + 2*slop, len + 50, pin_h + slop]);
        dz(z_slop)  translate([-pin_w/2 - slop, -len, -pin_h - slop]) cube([pin_w + 2*slop, len + 50, pin_h + slop]);
      }
    }
    // 3. Turning pin pocket at the far end of the lock (last cam_len mm, swept by cam_angle):
    if (z_slop == 0) {
      translate([0, -(len - cam_len), 0])
        ry(90) rx(90) rotate_extrude(angle=dir*cam_angle) {
          square([pin_h + slop, cam_len + slop]);
        }
    } else {
      hull() {
        dz(-z_slop) translate([0, -(len - cam_len), 0])
          ry(90) rx(90) rotate_extrude(angle=dir*cam_angle) square([pin_h + slop, cam_len + slop]);
        dz(z_slop)  translate([0, -(len - cam_len), 0])
          ry(90) rx(90) rotate_extrude(angle=dir*cam_angle) square([pin_h + slop, cam_len + slop]);
      }
    }
  }
}