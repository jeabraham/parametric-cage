////////////////////////////////////
//
// Parametric chastity cage, modified from this one: https://www.thingiverse.com/thing:2764421/
// Version 3, published August 2018

// V4 update: February 2019
//    - Added option to bend the base ring, for comfort
//    - Updated variables for Thingiverse Customizer

// V5 update: June 2019
//    - Rewrote as many functions as possible

// V6 update: January 2021
//    - Another major overhaul

//////////////////////////////////////

// Use abbreviations for translate() and rotate() operations
use <handyfunctions.scad>

// Use separate module for stealth lock shape
use <stealth_lock.scad>

// Use separate module for the lock shape (modelled in Fusion 360)
use <fusion_lock.scad>

// Use separate module for torus functions
use <torus.scad>

// Use separate module for computing points along the cage path
use <vec3math.scad>

// Use metric threads for printable lock hardware
use <threads.scad>

/* [General] */

// Render cage and ring separately
separate_parts = 0; // [0: Together, 1: Separate]

// Cage diameter
cage_diameter = 28; // [26:40]

// Tilt angle of the cage at the base ring
tilt = 25; // [0:30]

// Gap between the bottom of the cage and the base ring
gap = 13; // [10:20]

/* [Cage] */

// Length of cage from base ring to cage tip
penis_length = 52; // [30:200]

// Thickness of the rings of the cage
cage_bar_thickness = 4; // [4:8]

// [Bars only] Number of vertical bars on the cage
cage_bar_count = 8;

// Main style toggle: 0 = Barred cage, 1 = Solid wall cage
solid_wall = 0; // [0: Bars, 1: Solid wall]

// [Solid wall & D-shape] Wall and floor thickness, measured outward from the cage diameter (also sets watch case wall thickness)
solid_wall_thickness = 2; // [1.2:0.1:8]

// Clear space between front bars (bars version) or width of the front slit (solid version) (mm)
slit_width = 9; // [0:40]

// [Solid wall only] Where the slit starts, in degrees over the dome from its base on the lock side (90 = the tip)
slit_start = 70; // [0:1:180]

// [Solid wall only] Where the slit ends, in degrees over the dome from its base on the lock side (180 = base on the far side)
slit_end = 130; // [0:1:180]

// X-axis coordinate of the bend point (the center of the arc the cage bends around)
bend_point_x = 35; // [0:0.1:200]

// Z-axis coordinate of the bend point (the center of the arc the cage bends around)
bend_point_z = 5; // [0:0.1:200]

/* [D-Shape Cage / Watch Chamber] */

// Use D-shaped cage cross-section for watch (vibrating or buzzing device)
d_shape = 1; // [0: Circular, 1: D-Shape]

// [Solid wall only] Extra dorsal height added to the extruded solid tube cross-section (has no effect on barred cage, where watch case depth is driven directly by watch thickness)
watch_extra_height = 10.0; // [0:0.5:20]

// Width of the watch body (mm)
watch_body_width = 36.0; // [25.0:0.1:45.0]

// Corner rounding radius for D-shape top corners (mm)
watch_corner_radius = 4.0; // [1.0:0.5:8.0]

// Total length of watch from body-side lug tips to glans-side lug tips (mm)
watch_full_length = 48.6; // [35.0:0.1:65.0]

// Length of watch body excluding lugs (mm)
watch_body_length = 42.6; // [30.0:0.1:55.0]

// Inside distance between left and right lugs for watch band (mm)
watch_band_width = 20.0; // [12.0:0.5:26.0]

// Thickness of the watch body (mm)
watch_thickness = 13.0; // [8.0:0.1:20.0]

// Width of each individual lug (mm)
lug_width = 3.5; // [1.5:0.1:6.0]

// Height/thickness of each lug perpendicular to watch face (mm)
lug_height = 4.5; // [2.0:0.1:8.0]

// Elevation of bottom of lugs above the bottom face of the watch (mm, 0 for flush)
lug_loft_above_bottom = 0.0; // [0.0:0.1:5.0]

// Distance watch is shifted back towards the body so body-side lugs straddle the lock tangent bridge (mm)
watch_shift_back = 6.9; // [0:0.1:15.0]

// Cut screen opening on top of watch case
watch_screen_opening = 1; // [0: No, 1: Yes]

// Length of the touch screen window opening (mm)
watch_screen_length = 43.0; // [15:0.5:40]

// Width of the touch screen window opening (mm)
watch_screen_width = 36.0; // [15:0.5:36]

// Solid roof margin above lock block before screen window starts (mm)
watch_screen_margin_z = 5.0; // [2:0.5:15]

// Extra forward extension of screen window to uncover haptic button at glans end (mm)
haptic_button_clearance = 2.5; // [0:0.5:8.0]

// Open front lug pockets through the front of the case for water spray cleaning
front_lug_ports = 1; // [0: Closed, 1: Open spray ports]

// Show watch preview inside the D-shape chamber
show_watch = 1; // [0: No, 1: Yes]

// Show cross-section cutaway (preview only)
show_cutaway = 0; // [0: None, 1: XZ Cutaway]

/* [Ventilation Slots] */

// [Solid wall only] Optional ventilation slots on the left and right walls of the solid cage (bars already provide open ventilation)
vent_slots = 1; // [0: None, 1: Enabled]

// [Solid wall only] Number of ventilation slots per side
vent_slot_count = 2; // [1:4]

// [Solid wall only] Height of each ventilation slot (mm)
vent_slot_height = 5.0; // [1.5:0.5:6]

// [Solid wall only] Starting position of ventilation slots along the shaft (mm)
vent_slot_start = 5.5; // [4:0.5:30]

// [Solid wall only] Ending position of ventilation slots along the shaft (mm)
vent_slot_end = 32.5; // [10:0.5:60]

/* [Charger Access Slot] */

// Enable charger access slot on the right side of the watch case
charger_slot = 1; // [0: None, 1: Enabled]

// Starting position of charger slot along watch from body side (mm)
charger_slot_start = 3.0; // [0:0.5:20]

// Length/width of charger slot along watch length (mm, 7.5mm charger -> 8-10mm)
charger_slot_width = 10.0; // [4:0.5:20]

// Depth of slot extending into the bottom of the watch case (mm)
charger_slot_depth = 6.5; // [2:0.5:10]

// Reach across the bottom of the watch from the outer wall (mm)
charger_slot_reach = 30.5; // [5:0.5:36]

// Side of charger access: -1 for Right (-Y), 1 for Left (+Y)
charger_slot_side = -1; // [1: Right (+Y), -1: Left (-Y)]

// [Bars only] Target gap between topmost bar and watch case (mm, default 9.6mm)
top_bar_gap = 9.6; // [0: Default 8-bar spacing, 5:0.1:15]

// [Bars only] Bend the topmost bar back up to normal 8-bar position after clearing the charging case
top_bar_bend = 1; // [0: No, 1: Yes]

// [Bars only] Shaft distance where the top bar starts bending back up to normal position (mm)
top_bar_bend_z = 10.0; // [10:1:60]

// [Bars only] Transition length along the shaft for the bend (mm)
top_bar_bend_len = 5.0; // [3:1:20]

// Show charger preview in slot (preview only)
show_charger = 1; // [0: No, 1: Yes]

/* [Rounded Casing] */

// Wrap a smooth egg-shell casing around the watch cabinet to soften the profile under clothing
rounded_casing = 1; // [0: Standard watch box, 1: Smooth egg-shell casing]

// Top dorsal crown bump (mm, arches the top between corners)
casing_top_bump = 3.0; // [0.5:0.5:8.0]

// Side flank bulge (mm, arches the sides below corners)
casing_side_bump = 2.5; // [0.5:0.5:8.0]

// Front nose blend extension (mm, curves the front forward into an egg tip)
casing_front_blend = 1.0; // [0.0:0.5:10.0]

// Corner rounding radius for blending the egg shell (mm)
casing_rounding = 4.0; // [1.0:0.5:8.0]

/* [Base ring] */

// Base ring diameter
base_ring_diameter = 45; // [30:75]

// Thickness of base ring 
base_ring_thickness = 8.0; // [6.0:0.5:10.0]

// Base ring flatness/circularness factor along Z
base_ring_flatten_factor = 1; // [1:0.1:2]

// Cross-section of the base ring and the cage ring: 0 = square (easier to print), 1 = round. Edge radius = value * base ring thickness/2; 0.33 matches the lock block at thickness 6. The wavy base ring is always round
base_ring_roundness = 0.33; // [0:0.01:1]

// Add a "wave" to the base ring (contours to the body a little better)
wavy_base = 1; // [0: Flat, 1: Wavy]

// If the base ring has a wave, set the angle of the wave
wave_angle = 8; // [0:45]

/* [Lock] */

// Lock mechanism type: 0 = Stealth lock (Holy Trainer style), 1 = Fusion 360 lock (small cylinder cam lock)
lock_type = 0; // [0: Stealth lock, 1: Fusion 360 lock]

// Stealth lock diameter (mm)
stealth_lock_diameter = 5.8; // [5.0:0.1:10.0]

// Stealth lock total length (mm)
stealth_lock_length = 18.8; // [15.0:0.1:30.0]

// Stealth lock turning cam/pin length at the far end (mm)
stealth_lock_cam_length = 4.0; // [2.0:0.1:10.0]

// Stealth lock turning cam angle in degrees (e.g. 50 degrees to minimize material removed)
stealth_lock_turn_angle = 50; // [20:5:180]

// Stealth lock pin/cam height from cylinder center (mm)
stealth_lock_pin_height = 8.1; // [4.0:0.1:12.0]

// Stealth lock pin width (mm)
stealth_lock_pin_width = 3.2; // [1.0:0.1:6.0]

// Keep the far side of the lock cavity blind/closed (0 = Through-hole to see through, 1 = Blind hole)
stealth_lock_blind = 0; // [0: Through-hole, 1: Blind hole]

// How deep the key face of the lock sits below the surface of the case
lock_key_depth = 1.5; // [0:0.1:4]

// Direction the lock core turns, seen from the key side
lock_clockwise = 1; // [1: Clockwise, 0: Counterclockwise]

// Show the lock in place (preview only)
show_lock = 0; // [0: No, 1: Unlocked, 2: Locked]

// Render 3D-printable threaded bolt and nut for the lock (Stealth lock type)
do_bolt = 0; // [0: No, 1: Yes]

// Threaded bolt length of thread
bolt_thread_length = 4;

// Bolt shaft radius
bolt_diameter = 3;

// Bolt thread diameter
bolt_thread_diameter = 6;

// Total shaft length of bolt
lock_shaft_l = 26;

/* [Clearances] */

// Hole radius clearance around lock cylinder (mm)
lock_margin = 0.25; // [0:0.01:1]

// Extra vertical slot play in inner dovetail lock hole along sliding axis to absorb 3D print layer variations (mm)
lock_vertical_play = 0.45; // [0:0.05:1.5]

// Side clearance margin per side for inner dovetail sliding between outer wings (mm)
lock_dovetail_margin = 0.2; // [0:0.05:1]

// Extra clearance between the watch holder roof and the base ring lock mechanism (mm)
extra_top_clearance = 0.0; // [0:0.05:2.0]

// If the two parts slide too stiffly, add some space here
part_margin = 0.2; // [0:0.01:1]

/* [Hidden] */

// Backward compatibility support for legacy parameter names
wavy_base_effective = !is_undef(wavyBase) ? wavyBase : wavy_base;
wave_angle_effective = !is_undef(waveAngle) ? waveAngle : wave_angle;
separate_parts_effective = !is_undef(separateParts) ? separateParts : separate_parts;
watch_length = !is_undef(watch_length) ? watch_length : watch_body_length;
watch_top_width = !is_undef(watch_top_width) ? watch_top_width : (watch_body_width + 2*part_margin);
vibe_watch_length = watch_body_length;
vibe_watch_thickness = watch_thickness;
vibe_top_width = watch_top_width;
vibe_corner_radius = watch_corner_radius;
vibe_extra_height = watch_extra_height;
vibe_screen_opening = watch_screen_opening;
vibe_screen_length = watch_screen_length;
vibe_screen_width = watch_screen_width;
vibe_screen_margin_z = watch_screen_margin_z;
show_vibe_watch = show_watch;
vibe_chamber_depth = watch_chamber_depth;

// Lug extension length beyond watch body on each end (derived from full length and body length)
lug_length = (watch_full_length - watch_body_length) / 2;

// Glans cage height (minimum is cage radius)
glans_cage_height = cage_diameter/2.2; // [15:50]

// Variables affecting the lock case
lock_case_upper_radius = 9;
lock_case_lower_radius = 4;
base_lock_bridge_width = 13;
mount_width = 5;
mount_height = 18;
mount_length = 24;

// Radius of rounded edges
rounding = .99;

// Square function for math
function sq(x) = pow(x, 2);

////////////////////////////////////
//
// Useful values calculated from parameters above
//

// Thickness of base ring of cage
cage_ring_thickness = 1.2*cage_bar_thickness;

// step: angle between cage bars
step = 360/cage_bar_count;

// R1: Inner radius of shaft of cage
// R2: Inner radius of base ring
R1 = cage_diameter/2;
R2 = base_ring_diameter/2;

// r1: cage bar radius
// r2: base ring radius
// r3: cage ring radius
r1 = cage_bar_thickness/2;
r2 = base_ring_thickness/2;
r3 = cage_ring_thickness/2;

// Total dorsal extension of watch chamber = watch thickness + tolerance + 2*wall thickness
watch_chamber_depth = watch_thickness + part_margin + 2*solid_wall_thickness;

// Lock elevation offset along X axis (elevates the lock mechanism above the watch roof with baseline part_margin + extra_top_clearance)
// Mathematically accounts for watch case tilt rotation ((depth - t)/cos(tilt) + t) and dovetail skew offset (r3 * tan(tilt)):
lock_offset_x = d_shape ? (
  (watch_chamber_depth - solid_wall_thickness) / cos(tilt)
  + solid_wall_thickness
  + r3 * tan(tilt)
  + extra_top_clearance
  - (r3 + mount_width/2)
) : 0;

// Furthest forward point of watch cabinet in tilted world Z coordinates:
z_glans_front_tilted = (-watch_shift_back + watch_body_length + part_margin + solid_wall_thickness) * cos(tilt) + (watch_thickness + part_margin + solid_wall_thickness) * sin(tilt);

// Mathematically derived front end of watch cabinet (ends right in front of watch body):
case_z_end = z_glans_front_tilted + 0.2; // ~41.0mm

// Length of cage
cage_length = max(penis_length-gap, glans_cage_height+(R1+r1)*sin(tilt));

// Vertical placement of lock hole
lock_vertical = mount_height/2+1.5;
// Horizontal placement of lock hole
lock_lateral = 5.6;
// Angle the lock core turns (Fusion 360 lock)
lock_turn = 45;

// P: bend point (assumed to be on the XZ plane)
// dP: distance from origin to bend point
P = [bend_point_x, 0, bend_point_z];
dP = norm(P);

// psi: angle from origin to bend point (in degrees)
psi = atan(P.z/P.x);

// dQ: length of straight cage segment
dQ = min(dP*cos(90-tilt-psi), cage_length-glans_cage_height);

// Q: upper endpoint of straight segment of cage
Q = [dQ*sin(tilt), 0, dQ*cos(tilt)];

// Phi: arc length of curved segment of cage (in degrees)
curve_radius = norm(P-Q);
Phi = (cage_length - dQ - glans_cage_height)/curve_radius * 180/PI;

// R: endpoint of curved segment of cage
R = ry(Q-P, Phi) + P;

////////////////////////////////////
//
// Finally, here's where the modules begin
//

// Facet resolution: max angle and max length of a facet (coarser in preview for speed)
$fa = $preview ? 6 : 2;
$fs = $preview ? 1 : 0.4;
$fn = !is_undef(FN) ? FN : 0;

do_make = is_undef(render_make) ? 1 : render_make;
if (do_make) {
  if (show_cutaway == 1) {
    difference() {
      make();
      translate([0, -50, 0]) cube([250, 100, 250], center=true);
    }
  } else {
    make();
  }
}

module make() {
  cage();
  make_base();
  if (lock_type == 1 && show_lock) %lock_position() fusion_lock_body(show_lock == 2 ? lock_turn : 0, lock_clockwise);
  if (d_shape && show_watch) %watch_in_cage();
  if (d_shape && charger_slot && show_charger) %watch_charger_mockup();
  if (do_bolt) {
    if (separate_parts_effective) {
      translate([cage_diameter + 15, -15, 0]) lock_bolt();
      translate([cage_diameter + 15, 15, 0]) lock_nut();
    } else {
      lock_bolt_assembled();
      lock_nut_assembled();
    }
  }
}

module make_cage() //make me
{
  cage();
}

module make_base() //make me
{
  base_sep_dist = base_ring_diameter + cage_diameter + lock_offset_x + 20;
  baseOrigin = separate_parts_effective ? [-base_sep_dist, 0, gap] : [0, 0, 0];
  translate(baseOrigin) {
    dz(-gap) dx(R2+r2-R1-r1-gap*tan(tilt)) scale([1, 1, base_ring_flatten_factor]) base_ring();
    lock_dovetail_outer();
  }
}

module make_lock_bolt() //make me
{
  lock_bolt();
}

module make_lock_nut() //make me
{
  lock_nut();
}

// Standalone printable lock bolt, sitting flat on its head on XY plane
module lock_bolt() {
  union() {
    cylinder(r=bolt_thread_diameter, h=bolt_thread_length + 1, $fn=8);
    translate([0, 0, bolt_thread_length + 1])
      cylinder(r=bolt_diameter, h=lock_shaft_l-bolt_thread_length);
    translate([0, 0, lock_shaft_l + 1])
      metric_thread(diameter=bolt_thread_diameter, pitch=1, length=bolt_thread_length);
  }
}

// Standalone printable lock nut, sitting flat on its base on XY plane
module lock_nut() {
  difference() {
    cylinder(r=bolt_thread_diameter, h=bolt_thread_length + 1, $fn=8);
    translate([0, 0, 2])
      metric_thread(diameter=bolt_thread_diameter + part_margin, pitch=1, length=bolt_thread_length);
  }
}

// Lock bolt positioned in place in the assembled cage
module lock_bolt_assembled() {
  ry(tilt) translate([-R1-lock_offset_x-r3-mount_width/2-lock_lateral+1, 25-mount_length/2, lock_vertical - 7]) {
    rotate([90, 0, 0]) union() {
      metric_thread(diameter=bolt_thread_diameter, pitch=1, length=bolt_thread_length);
      translate([0, 0, bolt_thread_length]) cylinder(r=bolt_diameter, h=lock_shaft_l-bolt_thread_length);
      translate([0, 0, lock_shaft_l]) cylinder(r=bolt_thread_diameter, h=bolt_thread_length + 1, $fn=8);
    }
  }
}

// Lock nut positioned in place in the assembled cage
module lock_nut_assembled() {
  ry(tilt) translate([-R1-lock_offset_x-r3-mount_width/2-lock_lateral+1, lock_shaft_l-bolt_thread_length*2, lock_vertical - 7]) {
    rotate([90, 0, 0]) difference() {
      cylinder(r=bolt_thread_diameter, h=bolt_thread_length + 1, $fn=8);
      translate([0, 0, 2]) metric_thread(diameter=bolt_thread_diameter + part_margin, pitch=1, length=bolt_thread_length);
    }
  }
}

// Generate a cube with rounded edges
module rounded_cube(size, radius, center=false) {
  offset = center ? [0, 0, 0] : [radius, radius, radius];
  translate(offset) minkowski() {
    cube(size = [
      size[0] - (radius * 2),
      size[1] - (radius * 2),
      size[2] - (radius * 2)
    ], center=center);
    sphere(r = radius);
  }
}

module rounded_cylinder(r, h, r2, center=false) {
  zshift = center ? -h/2 : 0;
  dz(zshift)
    rotate_extrude(convexity=1)
      union() {
        square([r - r2, h]);
        translate([0, r2])
          square([r, h - r2*2]);
        translate([r - r2, h - r2])
          circle(r = r2);
        translate([r - r2, r2])
          circle(r = r2);
      }
}

module cage() {
  if (solid_wall) {
    // Solid wall version:
    difference() {
      union() {
        if (d_shape) {
          cage_solid_wall();
          watch_case_outer();
          if (rounded_casing) watch_rounded_casing();
          lock_dovetail_inner();
        } else {
          difference() {
            union() {
              cage_solid_wall();
              skewxz(tan(tilt)) profile_torus(R1+(r1+r3)/2, r1+r3, 2*r3, base_ring_roundness*r2/(r1+r3)*2);
            }
            lock_slide_clearance();
          }
          cage_lock();
        }
      }
      cage_cavity();
      if (d_shape) {
        watch_pocket();
        if (watch_screen_opening) watch_screen_window();
        if (charger_slot) watch_charger_slot();
        lock_cavity(z_slop=lock_vertical_play/2);
        lock_wings_clearance();
      }
      if (vent_slots) cage_vent_slots();
    }
  } else {
    // Bars version:
    difference() {
      union() {
        cage_bar_segments(); // The bars
        glans_cap(); // The cap
        profile_torus(R1+r1, 2*r3, 2*r3, base_ring_roundness*r2/r3); // Cage base ring, same edge radius as the base ring
        if (d_shape) {
          watch_case_outer();
          if (rounded_casing) watch_rounded_casing();
          lock_dovetail_inner();
        } else {
          cage_lock();
        }
      }
      if (d_shape) {
        cage_volume(R1, open_bottom=true);
        watch_pocket();
        if (watch_screen_opening) watch_screen_window();
        if (charger_slot) watch_charger_slot();
        lock_cavity(z_slop=lock_vertical_play/2);
        lock_wings_clearance();
      }
    }
  }
}

// Optional ventilation slots through the left and right walls of the cage
module cage_vent_slots() {
  vent_slot_len = max(1.0, vent_slot_end - vent_slot_start);
  slot_z_center = vent_slot_start + vent_slot_len / 2;
  skewxz(tan(tilt)) {
    for (i = [0 : vent_slot_count - 1]) {
      // Space slots along X in the lower half of the cage wall around the penis bore
      slot_x = (vent_slot_count == 1) ? 0 : (-R1/3 + i * (R1 * 0.8) / max(1, vent_slot_count - 1));
      translate([slot_x, 0, slot_z_center]) {
        for (side = [-1, 1]) {
          // Span 40mm along Y to cut completely through both the outer and inner walls
          translate([0, side * 15, 0])
            rotate([90, 0, 0])
              rounded_cube([vent_slot_height, vent_slot_len, 40], vent_slot_height/2 - 0.1, center=true);
        }
      }
    }
  }
}

// Watch seated inside the D-shape chamber, pushed back towards the body by watch_shift_back
// Physical watch has perpendicular sides (90-degree right angles, not a parallelogram)
module watch_in_cage() {
  t = solid_wall_thickness;
  z_body_start = -watch_shift_back;
  translate([-(R1 + t), 0, 0]) ry(tilt) {
    // 1. Watch body: 90-degree rectangular prism from z' = z_body_start to z_body_start + watch_body_length
    translate([-watch_thickness/2, 0, z_body_start + watch_body_length/2])
      color("darkslategray", 0.9)
        rounded_cube([watch_thickness, watch_body_width, watch_body_length], 2.5, center=true);
        
    lug_y = (watch_band_width + lug_width) / 2;
    // Lugs position in X based on lug_loft_above_bottom and lug_height:
    lug_x = -(lug_loft_above_bottom + lug_height/2);
    // Glans side lugs: extending forward from watch_body_length
    for (side = [-1, 1]) {
      translate([lug_x, side * lug_y, z_body_start + watch_body_length + lug_length/2])
        color("slategray", 0.9)
          rounded_cube([lug_height, lug_width, lug_length], 1.0, center=true);
    }
    // Body side lugs: extending backward from z_body_start (straddling the tangent bridge)
    for (side = [-1, 1]) {
      translate([lug_x, side * lug_y, z_body_start - lug_length/2])
        color("slategray", 0.9)
          rounded_cube([lug_height, lug_width, lug_length], 1.0, center=true);
    }
  }
}

// Outer solid housing for the watch, perfectly parallel to the watch pocket
// Guarantees uniform wall thickness on roof, floor, sides, and front (no thin spots, no extra front material)
module watch_case_outer() {
  t = solid_wall_thickness;
  pm = part_margin;
  z_body_start = -watch_shift_back;
  z_body_end = z_body_start + watch_body_length;
  // Front of housing is exactly solid_wall_thickness in front of watch body:
  z_front = z_body_end + pm + t;
  z_back = -20;
  z_len = z_front - z_back;
  
  box_w = watch_body_width + 2*pm + 2*t;
  box_h = watch_thickness + pm + 2*t;
  
  difference() {
    translate([-(R1 + t), 0, 0]) ry(tilt) {
      // Box centered in Y, spanning from floor (x' = +t) to roof (x' = -(box_h - t))
      translate([-box_h/2 + t, 0, z_back + z_len/2])
        rounded_cube([box_h, box_w, z_len], 2.5, center=true);
    }
    // Cleanly trim the body side so it never extends past the base ring (Z < -r3):
    translate([0, 0, -r3 - 50])
      cylinder(r=100, h=50);
  }
}

// 2D arch profile: flat bottom at x = -R1, smooth rounded arch with crown and corner rounding
module egg_arch_2d(h, w, cr) {
  cr_safe = max(0.5, min(cr, h - 0.5, w - 0.5));
  hull() {
    // Bottom flat edge at x = -R1
    translate([-R1 - 0.05, -w]) square([0.1, 2*w]);
    // Top-left and top-right rounded corners
    for (side = [-1, 1]) {
      translate([-(R1 + h - cr_safe), side * (w - cr_safe)])
        circle(r=cr_safe, $fn=32);
    }
    // Top center crown point
    translate([-(R1 + h), 0])
      circle(r=max(0.5, cr_safe/2), $fn=24);
  }
}

// Clearance cut to ensure rounded_casing and watch case never enter the sliding path of the mating outer lock wings
module lock_wings_clearance() {
  wing_w = mount_length/3 + 2*lock_dovetail_margin;
  intersection() {
    for (side = [-1, 1]) {
      translate([0, side * mount_length/3, 0]) {
        hull() {
          dz(-part_margin - r3 - 1) lock_case_shape(wing_w, outer=true);
          dz(mount_height*cos(tilt) + 10) lock_case_shape(wing_w, outer=true);
        }
      }
    }
    dz(-r3) skewxz(tan(tilt)) dz(-r3) mx() dx(R1 + lock_offset_x + r3 + mount_width/2) dy(-mount_length)
      cube([100, 2*mount_length, mount_height*cos(tilt) + 20]);
  }
}

// Smooth egg-shell casing wrapping the watch cabinet and lock receiver
// Formed by a continuous smooth egg loft that encloses the 8 corners of the watch cabinet
// and the top of the key dovetail part, with smooth curvature (no straight lines),
// without extending downwards (x+) or backwards (z-), and keeping the lock receptacle clear.
module watch_rounded_casing() {
  t = solid_wall_thickness;
  pm = part_margin;
  box_w = watch_top_width + 2*t;
  box_h = watch_thickness + pm + 2*t;
  
  // Longitudinal bounds along the tilted shaft
  z_back = -r3;
  z_front = case_z_end;
  z_nose = z_front + casing_front_blend;
  L_tot = z_nose - z_back;
  
  // Lock receiver position:
  z_lock = mount_height * cos(tilt);
  u_lock = (z_lock - z_back) / L_tot;
  u_front = (z_front - z_back) / L_tot;
  
  // Height needed over the lock key dovetail cylinder (accounting for lock elevation clearance):
  h_lock_apex = box_h + 4.0 + part_margin + extra_top_clearance;
  
  cr = casing_rounding;
  
  // Number of smooth lofting slices along Z:
  N = 24;
  
  // Helper function for height at fraction u in [0, 1]
  function egg_h(u) =
    (u <= u_front)
      ? (u <= u_lock
          ? (box_h + (h_lock_apex - box_h) * pow(u / u_lock, 2))
          : (let(v = (u - u_lock) / (u_front - u_lock))
              box_h + casing_top_bump * sin(v * 180) + (h_lock_apex - box_h) * cos(v * 90)))
      : (let(w = (u - u_front) / (1.0 - u_front))
          max(t, t + (egg_h(u_front) - t) * cos(w * 90)));

  w_lock = (mount_length/3 - 2*lock_dovetail_margin) / 2;
  w_watch = box_w/2;

  // Helper function for half-width at fraction u in [0, 1]
  // Keeps the lock region (u <= u_lock) strictly at w_lock so the lock can slide in from the side,
  // then smoothly fans outward over the watch body to the full flank width
  function egg_w(u) =
    (u <= u_front)
      ? (u <= u_lock
          ? w_lock
          : (let(v = (u - u_lock) / (u_front - u_lock))
              w_lock + (w_watch - w_lock) * sin(v * 90) + casing_side_bump * sin(v * 180)))
      : (let(w = (u - u_front) / (1.0 - u_front))
          max(0.5, (box_w/2) * cos(w * 90)));

  difference() {
    skewxz(tan(tilt)) {
      for (k = [0 : N - 1]) {
        u0 = k / N;
        u1 = (k + 1) / N;
        z0 = z_back + u0 * L_tot;
        z1 = z_back + u1 * L_tot;
        
        h0 = egg_h(u0);
        h1 = egg_h(u1);
        w0 = egg_w(u0);
        w1 = egg_w(u1);
        
        cr0 = min(cr, h0 * 0.4, w0 * 0.4);
        cr1 = min(cr, h1 * 0.4, w1 * 0.4);
        
        hull() {
          translate([0, 0, z0])
            linear_extrude(height=0.01)
              egg_arch_2d(h0, w0, cr0);
          translate([0, 0, z1])
            linear_extrude(height=0.01)
              egg_arch_2d(h1, w1, cr1);
        }
      }
    }
    // Protect the lock receptacle: keep the lock cavity and sliding wings completely clear
    lock_cavity(z_slop=lock_vertical_play/2);
    lock_wings_clearance();
  }
}

// Inner cavity for the watch body and glans lugs:
// Formed with perpendicular right angles (90 degrees, not a parallelogram) so the physical watch fits perfectly
// Keeps the bottom wall (floor) intact between watch and penis cavity!
// Opens completely through the body end (z' <= -30) so the watch slides in freely!
module watch_pocket() {
  t = solid_wall_thickness;
  pm = part_margin;
  lug_len_clear = lug_length + pm + 0.5;
  cavity_t = watch_thickness + pm;
  cavity_w = watch_top_width;
  z_body_start = -watch_shift_back;
  z_body_end = z_body_start + watch_body_length;
  
  translate([-(R1 + t), 0, 0]) ry(tilt) {
    // 1. Watch body slot extending from outside (z' = -30) through the body end to z_body_end + pm
    // Slices completely through the entrance with clearance so there is zero lip on floor, ceiling, or sides
    z_start = -30;
    z_end = z_body_end + pm;
    p_len = z_end - z_start;
    translate([-cavity_t/2, 0, z_start + p_len/2])
      cube([cavity_t + 0.6, cavity_w, p_len], center=true);
      
    // 2. Glans lug cavity: positioned using watch_band_width, lug_width, lug_height, and lug_loft_above_bottom
    lug_y = (watch_band_width + lug_width) / 2;
    lug_w = lug_width + 2*pm + 0.5;
    lug_h = lug_height + 2*pm + 0.5;
    lug_x = -(lug_loft_above_bottom + lug_h/2);
    z_lug_start = z_body_end - 0.2;
    // When front_lug_ports is enabled, push the lug holes through the front of the case for water spray cleaning
    z_lug_len = front_lug_ports ? (lug_len_clear + 35) : (lug_len_clear + 0.4);
    
    for (side = [-1, 1]) {
      translate([lug_x, side * lug_y, z_lug_start + z_lug_len/2])
        rounded_cube([lug_h, lug_w, z_lug_len], 1.0, center=true);
    }
  }
}

// Viewing/interaction window: full length forward from the lock block to the end of the watch body
module watch_screen_window() {
  t = solid_wall_thickness;
  pm = part_margin;
  cavity_t = watch_thickness + pm;
  z_body_start = -watch_shift_back;
  z_body_end = z_body_start + watch_body_length;
  win_z_start = mount_height * cos(tilt) + watch_screen_margin_z;
  // Extends past watch body by haptic_button_clearance to uncover the haptic button at top glans end
  win_z_end = z_body_end + haptic_button_clearance;
  win_len = max(0.0, win_z_end - win_z_start);
  win_w = min(watch_screen_width, watch_top_width - 2*2.5);
  cut_depth = 40 + t;
  if (win_len > 0) {
    translate([-(R1 + t), 0, 0]) ry(tilt) {
      translate([-cavity_t - cut_depth/2 + 0.1, 0, win_z_start + win_len/2])
        rounded_cube([cut_depth, win_w, win_len], 2.0, center=true);
    }
  }
}

// Charger access slot on the side of the watch case to access the bottom of the watch
module watch_charger_slot() {
  t = solid_wall_thickness;
  side = charger_slot_side; // -1 for Right (-Y), 1 for Left (+Y)
  z_body_start = -watch_shift_back;
  
  // Z span: starting from body side of watch with charger_slot_width along watch length
  z_start = z_body_start + charger_slot_start;
  z_len = charger_slot_width;
  z_center = z_start + z_len / 2;
  
  // X span: perpendicular to watch bottom, from pocket floor into gap
  x_top = -0.5; // 0.5mm into pocket for clean opening
  x_bot = t + charger_slot_depth;
  x_len = x_bot - x_top;
  x_center = (x_top + x_bot) / 2;
  
  // Y span: from outer wall reaching inward across bottom of watch
  y_outer = side * (watch_top_width/2 + t + 6);
  y_inner = side * (watch_top_width/2 - charger_slot_reach);
  y_len = abs(y_outer - y_inner);
  y_center = (y_outer + y_inner) / 2;
  
  difference() {
    // 1. Right-angled slot parallel and perpendicular to watch bottom
    translate([-(R1 + t), 0, 0]) ry(tilt) {
      translate([x_center, y_center, z_center])
        rounded_cube([x_len, y_len, z_len], 1.0, center=true);
    }
    // 2. Protect the cage base ring (at the body side) from being cut if tilt is large
    profile_torus(R1+r1+0.4, 2*r3+0.8, 2*r3+0.8, base_ring_roundness*r2/r3);
    // Also protect the space below the cage base ring
    dz(-50 - r3) cylinder(r=R1+r1+15, h=50);
  }
}

// Charger mockup seated in the access slot contacting the bottom of the watch (preview only)
module watch_charger_mockup() {
  t = solid_wall_thickness;
  side = charger_slot_side; // -1 for Right (-Y), 1 for Left (+Y)
  z_body_start = -watch_shift_back;
  
  // Center of 7.5mm charger along watch length
  z_center = z_body_start + charger_slot_start + 7.5 / 2;
  charger_thick = 5.0; // Thickness of charger head
  charger_reach = charger_slot_reach + 2;
  
  y_outer = side * (watch_top_width/2 + 2);
  y_inner = side * (watch_top_width/2 - charger_reach);
  y_center = (y_outer + y_inner) / 2;
  y_len = abs(y_outer - y_inner);
  
  // Contacts bottom of watch at X' = 0, extends downward into gap
  x_center = charger_thick / 2;
  
  translate([-(R1 + t), 0, 0]) ry(tilt) {
    // Charger head (7.5mm wide along watch length Z')
    translate([x_center, y_center, z_center])
      color("dodgerblue", 0.85)
        rounded_cube([charger_thick, y_len, 7.5], 1.0, center=true);
        
    // Cable lead extending out to the side
    translate([x_center, side * (watch_top_width/2 + 10), z_center])
      color("white", 0.9)
        rotate([0, 90, 0])
          cylinder(d=3.0, h=16, center=true);
  }
}

// Everything past the plane the base part's lock pieces slide on (the outer face of the slab)
module lock_slide_clearance() {
  h_lock = mount_height*cos(tilt) + r3 + 2;
  dz(-r3) skewxz(tan(tilt)) translate([-100, -mount_length/2-1, 0]) cube([100-(R1+lock_offset_x+r3+mount_width/2), mount_length+2, h_lock]);
}

// Inside of the cage, extended below the base so nothing is left hanging into it
module cage_cavity() {
  cage_volume(R1, open_bottom=true);
}

// Solid wall along the path of the bars: straight segment, bend around P, and a domed cap with the slit.
// The inner surface is at the cage diameter, the wall grows outward
module cage_solid_wall() {
  t = solid_wall_thickness;
  difference() {
    cage_volume(R1+t);
    cage_volume(R1, open_bottom=true);
    if (slit_width > 0) translate(R) ry(Phi+tilt) slit_cutter(R1+t/2, slit_width/2+t/2, t, slit_start, slit_end);
  }
  // Rounded lip along the slit edge; the clear opening is slit_width
  if (slit_width > 0) translate(R) ry(Phi+tilt) slit_lip(R1+t/2, slit_width/2+t/2, t, slit_start, slit_end);
}

// Slit geometry on the dome (cap frame: dome toward +Z, slit running along X, the lock side toward -X).
// Positions along the slit are angles phi in the XZ plane from +X: the dome's base on the lock side
// is phi=180, the tip is phi=90, the base on the far side is phi=0.
// The lip's center line lies on the wall's mid-sphere (radius Rm):
//  - each side is the circle where the plane y=+-c cuts the sphere (radius rho around the Y axis);
//  - each end is a half circle of radius c around rho*[cos(phi), 0, sin(phi)], tangent to both sides.
// The ends stop t/2 above the dome's base, so the lip stays on the dome.
function slit_c(Rm, c, t) = min(c, Rm*sin(80 - asin(t/2/Rm)));
function slit_th(Rm, c, t) = asin(slit_c(Rm, c, t)/Rm) + asin(t/2/Rm);
// [phi at the far-side end, phi at the lock-side end] for slit_start/slit_end (degrees from the lock-side base)
function slit_span(Rm, c, t, start, end) = let(
  th = slit_th(Rm, c, t),
  lo = min(max(180 - max(start, end), th), 180 - th),
  hi = min(max(180 - min(start, end), th), 180 - th)
) [lo, hi];

// Cone from the dome center over the slit outline, so the cut faces are normal to the wall
module slit_cutter(Rm, c0, t, start, end) {
  c = slit_c(Rm, c0, t);
  rho = sqrt(Rm*Rm - c*c);
  span = slit_span(Rm, c0, t, start, end);
  L = 2*(Rm + t);
  // Sides: |y| < c/rho * (distance from the Y axis), between the ends
  if (span[1] - span[0] > 0.01)
    rx(90) rz(span[0]) rotate_extrude(angle=span[1]-span[0]) polygon([[0, 0], [L, c/rho*L], [L, -c/rho*L]]);
  // Ends: cones around the end centers
  for (phi = span) ry(90-phi) cylinder(r1=0, r2=L*c/rho, h=L);
}

module slit_lip(Rm, c0, t, start, end) {
  c = slit_c(Rm, c0, t);
  rho = sqrt(Rm*Rm - c*c);
  span = slit_span(Rm, c0, t, start, end);
  tube_fn = 48; // multiple of 4, so the side and end tubes meet vertex to vertex
  // Sides
  if (span[1] - span[0] > 0.01)
    for (y = [-c, c]) dy(y) rx(90) rz(span[0]) rotate_extrude(angle=span[1]-span[0]) dx(rho) circle(t/2, $fn=tube_fn);
  // Ends: half rings from +Y around the outside of the slit to -Y (sgn=-1 at the far-side end, +1 at the lock side)
  for (k = [0, 1]) let(
    phi = span[k],
    sgn = k == 0 ? -1 : 1,
    n = [cos(phi), 0, sin(phi)],
    d = sgn*[-sin(phi), 0, cos(phi)],
    e = sgn*n
  ) multmatrix([[0, d.x, e.x, rho*n.x], [1, d.y, e.y, 0], [0, d.z, e.z, rho*n.z], [0, 0, 0, 1]])
      rotate_extrude(angle=180) dx(c) circle(t/2, $fn=tube_fn);
}

// Solid volume of the cage with cross-section radius r: the straight segment, the bend and a hemisphere on top
module cage_volume(r, open_bottom=false) {
  bend_steps = max(1, ceil(Phi/2));
  // Straight segment, from the base ring to Q
  hull() {
    cage_section(r);
    translate(Q) ry(tilt) cage_section(r);
  }
  // Below the base, continue along the tilt (same shear as the ring), deep enough to clear the ring
  if (open_bottom) hull() {
    cage_section(r);
    translate([-(r3+1)*tan(tilt), 0, -(r3+1)]) cage_section(r);
  }
  // Bend around P, from Q to R
  if (Phi > 0) for (i = [0:bend_steps-1]) hull() {
    translate(P) ry(i*Phi/bend_steps) translate(Q-P) ry(tilt) cage_section(r);
    translate(P) ry((i+1)*Phi/bend_steps) translate(Q-P) ry(tilt) cage_section(r);
  }
  // Dome
  translate(R) ry(Phi+tilt) {
    if (d_shape && solid_wall) {
      hull() {
        cage_section(r);
        translate([0, 0, r]) sphere(r/2, $fn=32);
      }
    } else {
      intersection() {
        sphere(r);
        translate([-r, -r, 0]) cube([2*r, 2*r, r]);
      }
    }
  }
}

// 2D D-shape profile
module d_section_2d(r, extra_h, top_w, corner_r) {
  cr = min(corner_r, extra_h/2, top_w/4);
  hull() {
    // 1. Bottom rounded semicircle (ventral half, x >= 0)
    intersection() {
      circle(r=r, $fn=64);
      translate([0, -r - 1]) square([r + 2, 2*r + 2]);
    }
    // 2. Top corner circles (dorsal flat top, x <= 0)
    for (side = [-1, 1]) {
      translate([-(r + extra_h - cr), side * (top_w/2 - cr)])
        circle(r=cr, $fn=32);
    }
    // 3. Tangent blend points at x = 0
    for (side = [-1, 1]) {
      translate([0, side * (r - cr)])
        circle(r=cr, $fn=32);
    }
  }
}

// A thin slice of the cage cross-section, in the XY plane
module cage_section(r) {
  if (d_shape && solid_wall) {
    extra_r = r - R1;
    top_w = watch_top_width + 2*extra_r;
    extra_h = watch_extra_height;
    corner_r = watch_corner_radius + extra_r;
    linear_extrude(height=0.01, center=true)
      d_section_2d(r, extra_h, top_w, corner_r);
  } else {
    cylinder(r=r, h=0.01, center=true);
  }
}

// Angle for the topmost bar to achieve top_bar_gap (default 9.6mm) clearance to the watch case
function calc_top_right_bar_theta(target_gap) =
  let(cos_th = (target_gap - (R1 - r1)) / (R1 + r1))
  (cos_th >= -1 && cos_th <= 1) ? acos(cos_th) : 112.5;

function bar_theta(i) =
  let(base_th = step/2 + i*step)
  (d_shape && charger_slot && top_bar_gap > 0)
    ? (charger_slot_side == -1
        ? (abs(base_th - 247.5) < step/2 ? (360 - calc_top_right_bar_theta(top_bar_gap)) : base_th)
        : (abs(base_th - 112.5) < step/2 ? calc_top_right_bar_theta(top_bar_gap) : base_th))
    : base_th;

// Helper to compute point along shaft at fraction u (0..1) and angle th
function bar_straight_pt(u, th) =
  (1 - u) * rz([R1+r1, 0, 0], th) + u * (Q + ry(rz([R1+r1, 0, 0], th), tilt));

module cage_bar_segments() {
  for (i = [0 : cage_bar_count - 1]) {
    base_th = step/2 + i*step;
    is_charger_bar = d_shape && charger_slot && top_bar_gap > 0 &&
      (charger_slot_side == -1 ? (abs(base_th - 247.5) < step/2) : (abs(base_th - 112.5) < step/2));

    if (is_charger_bar && top_bar_bend && dQ > 5) {
      // Bent bar: lowered to theta_gap near body for 9.6mm clearance, then bends back up to normal position
      th_normal = base_th;
      th_gap = charger_slot_side == -1
        ? (360 - calc_top_right_bar_theta(top_bar_gap))
        : calc_top_right_bar_theta(top_bar_gap);

      u1 = min(max(top_bar_bend_z / dQ, 0.1), 0.85);
      u2 = min(max((top_bar_bend_z + top_bar_bend_len) / dQ, u1 + 0.05), 0.98);

      P0 = bar_straight_pt(0, th_gap);
      P1 = bar_straight_pt(u1, th_gap);
      P2 = bar_straight_pt(u2, th_normal);
      P3 = bar_straight_pt(1, th_normal);

      // 3 segments forming the bent bar with spherical ball joints
      hull() {
        translate(P0) sphere(r=r1, $fn=16);
        translate(P1) sphere(r=r1, $fn=16);
      }
      hull() {
        translate(P1) sphere(r=r1, $fn=16);
        translate(P2) sphere(r=r1, $fn=16);
      }
      hull() {
        translate(P2) sphere(r=r1, $fn=16);
        translate(P3) sphere(r=r1, $fn=16);
      }

      // Curved torus segment to glans cap at the normal 8-bar position
      straightSegEnd = P3;
      curveSegEnd = ry(straightSegEnd - P, Phi) + P;
      if (Phi > 0.05) {
        vec1 = [straightSegEnd.x, 0, straightSegEnd.z] - P;
        vec2 = [curveSegEnd.x, 0, curveSegEnd.z] - P;
        cos_val = dot(vec1, vec2) / (norm(vec1) * norm(vec2));
        curveAngle = acos(max(-1, min(1, cos_val)));
        curveRad = norm(vec1);
        translate(straightSegEnd) ry(-180 + tilt) dx(-curveRad) rx(90) torus(curveRad, r1, -curveAngle, rounded=true);
      }
    } else {
      theta = bar_theta(i);
      straightSegStart = rz([R1+r1, 0, 0], theta);
      straightSegEnd = Q + ry(straightSegStart, tilt);
      curveSegEnd = ry(straightSegEnd - P, Phi) + P;

      segAngle = 90 - atan2(straightSegEnd.z - straightSegStart.z, straightSegEnd.x - straightSegStart.x);
      segLength = norm(straightSegEnd - straightSegStart);
      translate(straightSegStart) ry(segAngle) cylinder(r=r1, h=segLength);

      if (Phi > 0.05) {
        vec1 = [straightSegEnd.x, 0, straightSegEnd.z] - P;
        vec2 = [curveSegEnd.x, 0, curveSegEnd.z] - P;
        cos_val = dot(vec1, vec2) / (norm(vec1) * norm(vec2));
        curveAngle = acos(max(-1, min(1, cos_val)));
        curveRad = norm(vec1);
        translate(straightSegEnd) ry(-180 + tilt) dx(-curveRad) rx(90) torus(curveRad, r1, -curveAngle, rounded=true);
      }
    }
  }
}

module glans_cap() {
  // Clear space between front bars = slit_width; centerline distance = slit_width + 2*r1
  c_slit_max = R1 + r1 - 0.5;
  c_slit = min(max(slit_width, 0.1)/2 + r1, c_slit_max);
  translate(R) ry(Phi+tilt) {
    // Ring around base of glans cap
    ring_opening = (360/cage_bar_count);
    rotate([0,0,ring_opening/2])
      torus(R1+r1, r1, phi=(360-ring_opening));
    // Calculate the start and end points of the bars that create the front slit
    slitRadius = (R1+r1)*cos(asin(c_slit/(R1+r1)));
    slitStart = [slitRadius, -c_slit, 0];
    slitEnd = mx(slitStart);
    
    // Draw slit bars (clear space between them is exactly slit_width)
    dy(-c_slit) rx(90) torus(slitRadius, r1, 180);
    dy(c_slit) rx(90) torus(slitRadius, r1, 180);
    dy(-c_slit) dx(slitRadius) sphere(r=r1);
    dy(c_slit) dx(slitRadius) sphere(r=r1);
    dy(-c_slit) dx(-slitRadius) sphere(r=r1);
    dy(c_slit) dx(-slitRadius) sphere(r=r1);
    
    // Draw each cage bar (minus the part that would enter the slit area)
    *for (theta = [step/2:step:180-step/2]) {
      // Do not calculate/draw the bar if the bar begins within the slit area
      if ((R1+r1)*sin(theta) > c_slit) {
        // Compute arc length of this side bar
        distanceInSlit = c_slit/sin(theta);
        arcLength = acos(distanceInSlit/(R1+r1));
        rz(theta) rx(90) torus(R1+r1, r1, arcLength);
        rz(180+theta) rx(90) torus(R1+r1, r1, arcLength);
      }
    }
  }
}

module cage_lock() {
  // Create the solid arc that interfaces with the mating parts (a solid wall or d_shape does this job itself)
  if (!solid_wall && !d_shape) mount_arc();
  // Create the flat plane on which the mating parts slide
  mount_flat();
  // Create the cage's piece of the lock
  lock_dovetail_inner();
}

// Place the Fusion 360 lock: axis along Y, key face toward +Y, recessed lock_key_depth below the case surface
module lock_position() {
  dx(-R1-lock_offset_x-r3-mount_width/2-lock_lateral) ry(tilt) dz(lock_vertical) dy(mount_length/2-lock_key_depth) rz(90) children();
}

// Cut a cavity for the lock module (with optional vertical elongation slop along sliding axis)
module lock_cavity(z_slop=0) {
  if (lock_type == 0) {
    dx(-R1-lock_offset_x-r3-mount_width/2-lock_lateral) ry(tilt) dz(lock_vertical) dy(mount_length/2 - lock_key_depth) {
      stealth_lock(
        dia = stealth_lock_diameter,
        len = stealth_lock_length,
        cam_len = stealth_lock_cam_length,
        pin_h = stealth_lock_pin_height,
        pin_w = stealth_lock_pin_width,
        cam_angle = stealth_lock_turn_angle,
        clockwise = lock_clockwise,
        blind = (stealth_lock_blind == 1),
        slop = lock_margin,
        z_slop = z_slop
      );
    }
  } else {
    lock_position() fusion_lock_cavity(lock_margin, lock_turn, lock_clockwise, ext=lock_key_depth+50, z_slop=z_slop);
  }
}

module lock_dovetail_inner() {
  inner_dovetail_length = mount_length/3 - 2*lock_dovetail_margin;
  difference() {
    lock_case_shape(inner_dovetail_length);
    // Ensure the lock body does not enter the cage itself
    dz(-r3) skewxz(tan(tilt)) cylinder(r=R1+lock_offset_x+r3, h=100, center=true);
    // Cut an elongated cavity along the sliding axis for print tolerance
    lock_cavity(z_slop=lock_vertical_play/2);
  }
}

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
  slide_x = -(R1 + lock_offset_x + r3 + mount_width/2 + part_margin);

  difference() {
    // 1. Common-tangent hull between the lock anchor and the base ring wire:
    hull() {
      translate([c_lock_x, c_lock_z])
        circle(r=r_lock, $fn=64);
      translate([c_ring_x, c_ring_z])
        circle(r=r_ring, $fn=64);
    }
    
    // 2. Clear sliding face above Z = -r3 so the cage slides freely:
    translate([slide_x, -r3 - part_margin])
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


module lock_dovetail_outer() {
  bridge_w = d_shape ? (20.0 - 2*part_margin) : mount_length;
  slot_w = mount_length/3 + 2*lock_dovetail_margin;
  union() {
    // 1. Outer lock dovetail wings
    intersection () {
      difference() {
        union() {
          dy(mount_length/3) lock_case_shape(mount_length/3, outer=true);
          my() dy(mount_length/3) lock_case_shape(mount_length/3, outer=true);
        }
        // Cut a cavity for the lock module
        if (lock_type == 0) {
          sy(1.01) lock_cavity();
        } else {
          lock_cavity();
        }
      }
      union() {
        dz(-r3) skewxz(tan(tilt)) dz(-r3) mx() dx(R1+lock_offset_x+r3+mount_width/2 + part_margin) dy(-mount_length/2) rounded_cube([50, mount_length/3, mount_height*cos(tilt)+2*r3], rounding);
        my() dz(-r3) skewxz(tan(tilt)) dz(-r3) mx() dx(R1+lock_offset_x+r3+mount_width/2 + part_margin) dy(-mount_length/2) rounded_cube([50, mount_length/3, mount_height*cos(tilt)+2*r3], rounding);
      }
    }
    // 2. Pure common-tangent bridge connecting base ring to the lock body
    difference() {
      lock_tangent_bridge_3d(bridge_w);
      // Cut lock cavity through the bridge if it intersects
      if (lock_type == 0) {
        sy(1.01) lock_cavity();
      } else {
        lock_cavity();
      }
      // Subtract where the cage part of the lock mechanism goes (and slides down):
      hull() {
        dz(-part_margin) dx(-part_margin) lock_case_shape(slot_w);
        dz(mount_height*cos(tilt) + 10) dx(-part_margin) lock_case_shape(slot_w);
      }
      // When d_shape, cut away the bridge so it is flush with the back face of the watch (+ part_margin tolerance):
      if (d_shape) {
        translate([-(R1 + solid_wall_thickness), 0, 0]) ry(tilt) {
          z_flush = -watch_shift_back - part_margin;
          translate([-watch_thickness/2, 0, z_flush + 60/2])
            cube([watch_thickness + 20, bridge_w + 2, 60], center=true);
        }
      }
    }
  }
}

// A hull of four rounded cylinders to create the main lock body. It extends down a bit more for the outer lock piece
module lock_case_shape(length, outer=false) {
  extra = outer ? r3 : 0;
  lower_radius = outer ? 2 : lock_case_lower_radius;
  
  hull() {
    dx(-R1-lock_offset_x-r3-mount_width/2-lock_case_upper_radius+lower_radius) dz(lower_radius-r3-extra) rx(90) rounded_cylinder(lower_radius, length, rounding, center=true);
    dx(-3-R1-lock_offset_x-r3-mount_width/2) dz(mount_height*cos(tilt) - lock_case_upper_radius) rx(90) rounded_cylinder(lock_case_upper_radius, length, rounding, center=true);
    dz(lower_radius-r3-extra) rx(90) rounded_cylinder(lower_radius, length, rounding, center=true);
    dz(mount_height*cos(tilt)-lower_radius) rx(90) rounded_cylinder(lower_radius, length, rounding, center=true);
  }
}

module mount_arc(arcLength=60) {
  skewxz(tan(tilt)) {
    rz(180-arcLength/2) {
      rotate_extrude(angle=arcLength) {
        dx(R1) offset(r=rounding) offset(delta=-rounding) square([cage_bar_thickness, mount_height*cos(tilt)]);
      }
      // Put smooth caps on the sides of the mount arc
      dx(R1+r1) rounded_cylinder(r1, mount_height*cos(tilt), rounding);
      rz(arcLength) dx(R1+r1) rounded_cylinder(r1, mount_height*cos(tilt), rounding);
    }
  }
}

module mount_flat() {
  closed = solid_wall || d_shape;
  // On a closed shape the slab reaches in past the wall at its ends, so its sides run straight into the wall;
  // In d_shape, it attaches solidly to the outer roof of the watch cabinet
  inner = closed ? (d_shape ? (R1 + watch_chamber_depth - solid_wall_thickness) : sqrt(max(sq(R1) - sq(mount_length/2), 0))) : R1+lock_offset_x+r3-mount_width/2;
  dz(-r3) skewxz(tan(tilt)) difference() {
    translate([-R1-lock_offset_x-r3-mount_width/2, -mount_length/2, 0]) rounded_cube([R1+lock_offset_x+r3+mount_width/2-inner, mount_length, mount_height*cos(tilt)+r3], rounding);
    // For the barred cage, keep the block outside the cage ring
    if (!closed) cylinder(r=R1+lock_offset_x+r3, h=100);
  }
}

module base_ring() {
  if (wavy_base_effective) {
    wavy_torus(R2+r2, r2, wave_angle_effective);
  } else {
    profile_torus(R2+r2, 2*r2, 2*r2, base_ring_roundness);
  }
}

module wavy_torus(R, r, pitch) {
  union() {
    translate([-sin(-45)*R*(1-cos(pitch)), 0, -R*sin(-45)*sin(pitch)]) ry(pitch) rz(-45) {
      torus(R, r, 90);
      dx(R) sphere(r);
    }
    translate([0, sin(45)*R*(1-cos(pitch)), -R*sin(45)*sin(pitch)]) rx(pitch) rz(45) {
      torus(R, r, 90);
      dx(R) sphere(r);
    }
    translate([-sin(135)*R*(1-cos(pitch)), 0, -R*sin(135)*sin(-pitch)]) ry(-pitch) rz(135) {
      torus(R, r, 90);
      dx(R) sphere(r);
    }
    translate([0, sin(-135)*R*(1-cos(pitch)), -R*sin(-135)*sin(-pitch)]) rx(-pitch) rz(-135) {
      torus(R, r, 90);
      dx(R) sphere(r);
    }
  }
}

// Backward-compatibility module aliases for legacy vibe_* names
module vibe_watch_in_cage() { watch_in_cage(); }
module vibe_watch_case_outer() { watch_case_outer(); }
module vibe_watch_pocket() { watch_pocket(); }
module vibe_screen_window() { watch_screen_window(); }
module vibe_charger_slot() { watch_charger_slot(); }
module vibe_charger_mockup() { watch_charger_mockup(); }

