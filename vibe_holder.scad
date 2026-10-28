// Parametric Vibe Holder Box
// Standalone model for digital watch-shaped vibrating device

/* [Tolerance & Clearances] */
// Part clearance tolerance (mm)
part_margin = 0.2; // [0.05:0.05:0.5]

// Lug slot extra clearance (mm)
lug_slot_margin = 0.6; // [0.2:0.1:1.2]

/* [Watch Dimensions] */
// Watch body length (excluding lugs, mm)
watch_body_length = 42.6;

// Watch body width (mm)
watch_body_width = 36.0;

// Total watch length with lugs (mm)
watch_total_length = 48.7;

// Watch body thickness (mm)
watch_thickness = 10;

// Vertical drop from top glass face to top of lugs (mm)
lug_drop = 4.0;

// Watch band lug spacing (inner width between lugs, mm)
lug_gap = 20.0;

// Individual lug width/thickness (mm)
lug_thick = 4.0;

// Lug pin hole diameter (mm)
pin_dia = 2.0;

/* [Holder Box Geometry] */
// Side wall thickness along width (mm)
wall_side = 3.0;

// End wall thickness beyond lugs (mm)
wall_end = 1.5;

// Corner rounding radius on outer box (mm)
outer_radius = 6.5;

// Corner rounding radius on top screen opening (mm)
screen_radius = 5.0;

/* [Preview Options] */
// Show watch mockup inside holder
show_watch = 1; // [0: No, 1: Yes]

// Show cross-section cutaway (preview only)
show_cutaway = 0; // [0: None, 1: XZ Cutaway, 2: YZ Cutaway]

// Resolution
$fn = 32;

////////////////////////////////////
//
// Derived Dimensions
//

// Inner cavity dimensions with tolerance
cavity_w = watch_body_width + 2*part_margin;
cavity_l = watch_body_length + 2*part_margin;
cavity_total_l = watch_total_length + 2*part_margin;
cavity_t = watch_thickness + part_margin;

// Outer holder dimensions
box_w = cavity_w + 2*wall_side;
box_l = cavity_total_l + 2*wall_end;
box_t = cavity_t;

// Lug extension beyond main body at each end
lug_ext = (watch_total_length - watch_body_length) / 2;

// Lug slot width with clearance
lug_slot_w = lug_thick + 2*lug_slot_margin;

// Y center position of lugs
lug_y_pos = (lug_gap + lug_thick) / 2;

////////////////////////////////////
//
// Helper Modules
//

// 2D rounded rectangle
module rounded_rect(w, l, r) {
  rad = min(r, w/2 - 0.1, l/2 - 0.1);
  hull() {
    for (x = [-1, 1], y = [-1, 1]) {
      translate([x*(l/2 - rad), y*(w/2 - rad)])
        circle(r=rad);
    }
  }
}

// 3D rounded box extruded along Z
module rounded_prism_z(length, width, height, radius, center=true) {
  z_offset = center ? -height/2 : 0;
  translate([0, 0, z_offset])
    linear_extrude(height=height)
      rounded_rect(width, length, radius);
}

////////////////////////////////////
//
// Watch 3D Mockup
//

module watch_mockup() {
  w = watch_body_width;
  l = watch_body_length;
  tl = watch_total_length;
  t = watch_thickness;
  
  color("dimgray", 0.9) {
    difference() {
      union() {
        // 1. Main body
        rounded_prism_z(l, w, t, 2.5, center=false);
        
        // 2. Lugs at both ends (4mm down from top face, 3.5mm wide)
        for (end = [-1, 1]) {
          for (side = [-1, 1]) {
            lug_y = side * lug_y_pos;
            lug_x = end * (l/2 + lug_ext/2);
            translate([lug_x, lug_y, t - lug_drop - 2.25])
              rounded_prism_z(lug_ext + 0.8, lug_thick, 4.5, 1.0, center=true);
          }
        }
        
        // 3. Sensor dome on back (Z = 0)
        translate([0, 0, 0])
          scale([1, 1, 0.4])
            sphere(d=16);
      }
      
      // Screen bevel / outline on top face (Z = t)
      translate([0, 0, t - 0.3])
        rounded_prism_z(l - 4, w - 4, 1, 2, center=false);
        
      // Capacitive touch button outline
      translate([-(l/2 - 6), 0, t - 0.2])
        rounded_prism_z(4, 12, 1, 1.5, center=false);
        
      // Spring bar holes in lugs (diameter 1.5mm)
      for (end = [-1, 1]) {
        translate([end * (tl/2 - 1.5), 0, t - lug_drop - 2.25])
          rotate([90, 0, 0])
            cylinder(d=1.5, h=w + 2, center=true);
      }
    }
  }
}

////////////////////////////////////
//
// Vibe Holder Body
//

module vibe_holder_outer() {
  rounded_prism_z(box_l, box_w, box_t, outer_radius, center=false);
}

module vibe_holder_cavity() {
  // 1. Main watch body pocket + top opening for touch screen (42.6+tol x 36+tol)
  // Passes completely through from bottom (Z = -1) to top (Z = box_t + 1)
  // Top opening is perfectly clean, rectangular with rounded corners!
  translate([0, 0, -1])
    rounded_prism_z(cavity_l, cavity_w, box_t + 2, screen_radius, center=false);
    
  // 2. Dedicated lug clearance slots at each end:
  // Open at bottom (Z = -1) so the watch and lugs slide in smoothly together from below.
  // Stops at Z = box_t - lug_drop, so the top face has ZERO holes over the lugs!
  // In the center 20mm (|Y| < 10) and corners (|Y| > 13.5), the shorter walls are THICK!
  lug_slot_len = lug_ext + part_margin + 0.2;
  lug_slot_h = box_t - lug_drop + 1;
  for (end = [-1, 1]) {
    for (side = [-1, 1]) {
      translate([end * (cavity_l/2 + lug_slot_len/2 - 0.1), side * lug_y_pos, -1])
        rounded_prism_z(lug_slot_len + 0.2, lug_slot_w, lug_slot_h, 1.0, center=false);
    }
  }
    
  // 3. Spring bar pin holes (transverse along Y)
  // Passes through the outer corners, through the lug slots, and through the thick center wall
  pin_z = box_t - lug_drop - 2.25;
  for (end = [-1, 1]) {
    pin_x = end * (watch_total_length/2 - 1.5);
    translate([pin_x, 0, pin_z]) {
      rotate([90, 0, 0])
        cylinder(d=pin_dia, h=box_w + 5, center=true);
    }
  }
}

// Complete vibe holder
module vibe_holder() {
  difference() {
    vibe_holder_outer();
    vibe_holder_cavity();
  }
}

////////////////////////////////////
//
// Scene Render
//

module scene() {
  vibe_holder();
  if (show_watch) {
    translate([0, 0, 0])
      watch_mockup();
  }
}

// Cutaway and inspection modes
if (show_cutaway == 1) {
  // XZ cutaway (cuts front half Y > 0)
  difference() {
    scene();
    translate([0, 50, 0]) cube([150, 100, 150], center=true);
  }
} else if (show_cutaway == 2) {
  // YZ cutaway (cuts half X > 0)
  difference() {
    scene();
    translate([50, 0, 0]) cube([100, 150, 150], center=true);
  }
} else {
  scene();
}
