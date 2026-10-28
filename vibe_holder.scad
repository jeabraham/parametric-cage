// Parametric Vibe Holder Box
// Standalone model for digital watch-shaped vibrating device

/* [Tolerance & Clearances] */
// Part clearance tolerance (mm)
part_margin = 0.2; // [0.05:0.05:0.5]

/* [Watch Dimensions] */
// Watch body length (excluding lugs, mm)
watch_body_length = 42.6;

// Watch body width (mm)
watch_body_width = 36.0;

// Total watch length with lugs (mm)
watch_total_length = 48.7;

// Watch body thickness (mm)
watch_thickness = 11.2;

// Vertical drop from top glass face to top of lugs (mm)
lug_drop = 4.0;

// Watch band lug spacing (inner width between lugs, mm)
lug_gap = 20.0;

// Individual lug thickness (mm)
lug_thick = 2.8;

// Lug pin hole diameter (mm)
pin_dia = 2.0;

/* [Holder Box Geometry] */
// Side wall thickness along width (mm)
wall_side = 3.0;

// End wall thickness beyond lugs (mm)
wall_end = 1.5;

// Bottom retaining shelf lip (inward retention lip at bottom, mm)
bottom_lip = 1.2;

// Bottom retaining shelf thickness (mm)
bottom_lip_thickness = 1.5;

// Corner rounding radius on outer box (mm)
outer_radius = 3.0;

// Corner rounding radius on top screen opening (mm)
screen_radius = 2.5;

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
box_t = cavity_t + bottom_lip_thickness;

// Lug extension beyond main body at each end
lug_ext = (watch_total_length - watch_body_length) / 2;

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
  lw = lug_gap;
  
  color("dimgray", 0.9) {
    difference() {
      union() {
        // 1. Main body
        rounded_prism_z(l, w, t, 2.5, center=false);
        
        // 2. Lugs at both ends (4mm down from top face)
        // Top face of watch is at Z = t
        // Top of lugs is at Z = t - lug_drop
        for (end = [-1, 1]) {
          for (side = [-1, 1]) {
            // Position lugs
            lug_y = side * (lw/2 + lug_thick/2);
            lug_x = end * (l/2 + lug_ext/2);
            translate([lug_x, lug_y, t - lug_drop - 2.5])
              rounded_prism_z(lug_ext + 1, lug_thick, 4.5, 1.2, center=true);
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
        translate([end * (tl/2 - 1.5), 0, t - lug_drop - 2.5])
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
  // Outer solid block
  rounded_prism_z(box_l, box_w, box_t, outer_radius, center=false);
}

module vibe_holder_cavity() {
  // Coordinate frame:
  // Z = 0 is bottom face of holder
  // Z = bottom_lip_thickness is bottom of watch cavity
  // Z = bottom_lip_thickness + cavity_t is top face of watch / inner roof
  // Z = box_t is top face of holder
  
  // 1. Top opening for touch screen (42.6+tol x 36+tol)
  // Cuts completely through the top face
  translate([0, 0, bottom_lip_thickness])
    rounded_prism_z(cavity_l, cavity_w, cavity_t + 5, screen_radius, center=false);
    
  // 2. Lug channels / cavity (extends to cavity_total_l = 48.7+tol)
  // The lugs are 4mm down from top face, so this cavity is capped by the 4mm ceiling at ends
  translate([0, 0, -1])
    rounded_prism_z(cavity_total_l, cavity_w, bottom_lip_thickness + cavity_t - lug_drop + 1, 1.5, center=false);
    
  // 3. Bottom sliding entrance:
  // The watch slides in from the bottom.
  // The entrance opening at Z=0 allows the watch body to enter.
  // A subtle perimeter retention lip (bottom_lip) supports the back edges,
  // or is open across the main center so the sensor contacts the skin.
  translate([0, 0, -1])
    rounded_prism_z(cavity_total_l - 2*bottom_lip, cavity_w - 2*bottom_lip, bottom_lip_thickness + 2, 2.0, center=false);
    
  // 4. Spring bar pin holes (transverse along Y)
  // Placed right at the watch lug pin positions:
  // Z position: bottom_lip_thickness + cavity_t - lug_drop - 2.5
  pin_z = bottom_lip_thickness + cavity_t - lug_drop - 2.5;
  for (end = [-1, 1]) {
    pin_x = end * (watch_total_length/2 - 1.5);
    translate([pin_x, 0, pin_z]) {
      // Pin hole through entire width of holder
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
    // Position watch inside cavity
    translate([0, 0, bottom_lip_thickness])
      watch_mockup();
  }
}

// Handle cutaway views for inspection
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
