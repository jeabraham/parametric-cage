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
separate_parts = 1; // [0: Together, 1: Separate]

// Cage shape: a full cage with bars, or a flat cap (a wall ring with a flat top plate)
flat_top = 0; // [0: Cage, 1: Flat]

// Cage diameter
cage_diameter = 27; // [26:40]

// Tilt angle of the cage at the base ring
tilt = 8; // [0:30]

// Gap between the bottom of the cage and the base ring
gap = 12; // [10:20]

/* [Cage] */

// Length of cage from base ring to cage tip
penis_length = 58; // [30:200]

// Thickness of the rings of the cage
cage_bar_thickness = 4; // [4:8]

// Number of vertical bars on the cage
cage_bar_count = 8;

// Replace the bars with a solid wall along the same shape
solid_wall = 1; // [0: Bars, 1: Solid wall]

// Thickness of the solid wall, measured outward from the cage diameter
solid_wall_thickness = 2; // [1.2:0.1:8]

// Width of the slit at the front opening
slit_width = 10; // [0:40]

// Solid wall: where the slit starts, in degrees over the dome from its base on the lock side (90 = the tip)
slit_start = 55; // [0:1:180]

// Solid wall: where the slit ends, in degrees over the dome from its base on the lock side (180 = base on the far side)
slit_end = 180; // [0:1:180]

// X-axis coordinate of the bend point (the center of the arc the cage bends around)
bend_point_x = 45; // [0:0.1:200]

// Z-axis coordinate of the bend point (the center of the arc the cage bends around)
bend_point_z = 20; // [0:0.1:200]

/* [D-Shape Cage / Vibe Chamber] */

// Use D-shaped cage cross-section for vibe watch
d_shape = 1; // [0: Circular, 1: D-Shape]

// Extra height added to the dorsal top of the cage (mm)
vibe_extra_height = 10.0; // [0:0.5:20]

// Flat top width for the vibe watch (mm)
vibe_top_width = 36.4; // 36 + 2*tolerance wide

// Corner rounding radius for D-shape top corners (mm)
vibe_corner_radius = 4.0; // [1.0:0.5:8.0]

// Watch body length (mm)
vibe_watch_length = 42.6;

// Watch thickness (mm)
vibe_watch_thickness = 10.0;

// Cut screen opening on flat top of cage
vibe_screen_opening = 1; // [0: No, 1: Yes]

// Length of the touch screen window opening (mm)
vibe_screen_length = 43.0; // [15:0.5:40]

// Width of the touch screen window opening (mm)
vibe_screen_width = 36.0; // [15:0.5:36]

// Solid roof margin above lock block before screen window starts (mm)
vibe_screen_margin_z = 8.0; // [2:0.5:15]

// Show watch preview inside the D-shape chamber
show_vibe_watch = 1; // [0: No, 1: Yes]

// Show cross-section cutaway (preview only)
show_cutaway = 0; // [0: None, 1: XZ Cutaway]

/* [Flat top] */

// Height of the wall of the flat cap, from the bottom of the cage ring to the top of the plate
flat_wall_height = 9.4; // [4.8:0.1:40]

// Thickness of the top plate
flat_plate_thickness = 1; // [0.6:0.1:4]

// Diameter of the center hole in the top plate
flat_center_hole = 6; // [0:0.5:15]

// Number of holes around the center hole
flat_hole_count = 6; // [0:12]

// Diameter of the holes around the center hole
flat_hole_diameter = 3; // [1:0.5:8]

// Radius of the circle the holes around the center sit on
flat_hole_radius = 12; // [3:0.5:16]

// Close the holes with a thin layer on the underside of the plate, so the slicer bridges the plate in one piece; poke it through after printing
flat_bridge_layer = 1; // [0: No, 1: Yes]

// Thickness of that layer (one or two print layers)
flat_bridge_layer_thickness = 0.2; // [0.1:0.05:0.6]

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
wave_angle = 16; // [0:45]

/* [Lock] */

// Lock mechanism type: 0 = Stealth lock (Holy Trainer style), 1 = Fusion 360 lock (small cylinder cam lock)
lock_type = 0; // [0: Stealth lock, 1: Fusion 360 lock]

// Fusion 360 lock: How deep the key face of the lock sits below the surface of the case
lock_key_depth = 1.5; // [0:0.1:4]

// Fusion 360 lock: Direction the lock core turns, seen from the key side
lock_clockwise = 1; // [1: Clockwise, 0: Counterclockwise]

// Fusion 360 lock: Show the lock in place (preview only)
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

// If your lock fits too tightly in the casing, add some space around it here
lock_margin = 0.1; // [0:0.01:1]

// If the two parts slide too stiffly, add some space here
part_margin = 0.2; // [0:0.01:1]

/* [Hidden] */

// Backward compatibility support for legacy parameter names
wavy_base_effective = !is_undef(wavyBase) ? wavyBase : wavy_base;
wave_angle_effective = !is_undef(waveAngle) ? waveAngle : wave_angle;
separate_parts_effective = !is_undef(separateParts) ? separateParts : separate_parts;

// Glans cage height (minimum is cage radius)
glans_cage_height = cage_diameter/2.2; // [15:50]

// Lock elevation offset along X axis (raised to make room for vibe area)
lock_offset_x = d_shape ? vibe_extra_height : 0;

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

if (show_cutaway == 1) {
  difference() {
    make();
    translate([0, -50, 0]) cube([250, 100, 250], center=true);
  }
} else {
  make();
}

module make() {
  cage();
  make_base();
  if (lock_type == 1 && show_lock) %lock_position() fusion_lock_body(show_lock == 2 ? lock_turn : 0, lock_clockwise);
  if (d_shape && show_vibe_watch) %vibe_watch_in_cage();
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
  if (flat_top || solid_wall) {
    // Closed shapes: keep the lock block and the ring out of the cavity, flush with the inner surface
    difference() {
      union() {
        if (flat_top) {
          // The flat cap's wall is upright but the lock pieces slide along a tilted plane:
          // trim the wall back to that plane so the base part's lock pieces clear it
          difference() {
            flat_cap();
            lock_slide_clearance();
          }
        } else {
          cage_solid_wall();
          // Cage entrance collar: continuous rounded rim around the entire entrance
          difference() {
            if (d_shape) {
              skewxz(tan(tilt))
                linear_extrude(height=2*r3, center=true)
                  offset(r=r3)
                    d_section_2d(R1, vibe_extra_height, vibe_top_width, vibe_corner_radius);
            } else {
              skewxz(tan(tilt)) profile_torus(R1+(r1+r3)/2, r1+r3, 2*r3, base_ring_roundness*r2/(r1+r3)*2);
            }
            lock_slide_clearance();
          }
        }
        cage_lock();
      }
      cage_cavity();
      if (d_shape) {
        if (vibe_screen_opening) vibe_screen_window();
        vibe_glans_lug_indents();
      }
    }
  } else {
    cage_bar_segments(); // The bars
    glans_cap(); // The cap
    profile_torus(R1+r1, 2*r3, 2*r3, base_ring_roundness*r2/r3); // Cage base ring, same edge radius as the base ring
    cage_lock(); // The part where the lock goes
  }
}

// Watch seated inside the D-shape chamber, resting against the back (body side) at Z = 0
module vibe_watch_in_cage() {
  skewxz(tan(tilt)) {
    // Watch body: from Z = 0 to Z = vibe_watch_length
    translate([-(R1 + vibe_watch_thickness/2), 0, vibe_watch_length/2])
      color("darkslategray", 0.9)
        rounded_cube([vibe_watch_thickness, 36.0, vibe_watch_length], 2.5, center=true);
        
    lug_y = (20.0 + 3.5) / 2;
    lug_x = -(R1 + vibe_extra_height - 4.0 - 2.25);
    // Glans side lugs: extending forward from vibe_watch_length
    for (side = [-1, 1]) {
      translate([lug_x, side * lug_y, vibe_watch_length + 3.05/2])
        color("slategray", 0.9)
          rounded_cube([4.5, 3.5, 3.05], 1.0, center=true);
    }
    // Body side lugs: extending backward from Z = 0 to straddle the connecting block
    for (side = [-1, 1]) {
      translate([lug_x, side * lug_y, -3.05/2])
        color("slategray", 0.9)
          rounded_cube([4.5, 3.5, 3.05], 1.0, center=true);
    }
  }
}

// Viewing/interaction window: full length forward from the lock block to the glans side of the watch
module vibe_screen_window() {
  win_z_start = mount_height * cos(tilt);
  win_len = vibe_watch_length - win_z_start + 0.5;
  win_w = 31.0; // full viewing width with retaining side rails
  if (win_len > 0) {
    skewxz(tan(tilt))
      translate([-(R1 + vibe_extra_height + solid_wall_thickness/2), 0, win_z_start + win_len/2])
        rounded_cube([solid_wall_thickness + 4, win_w, win_len], 2.5, center=true);
  }
}

// Lug indents on the glans side of the watch cavity (pushes through the front if cage is short)
module vibe_glans_lug_indents() {
  lug_y = (20.0 + 3.5) / 2; // 11.75mm
  lug_w = 4.8; // generous width clearance for 3.5mm lug
  lug_h = 5.2; // vertical clearance
  lug_x = -(R1 + vibe_extra_height - 4.0 - lug_h/2);
  z_start = vibe_watch_length - 0.5;
  z_len = 25.0; // extends forward to push through dome if cage is short
  skewxz(tan(tilt)) {
    for (side = [-1, 1]) {
      translate([lug_x, side * lug_y, z_start + z_len/2])
        rounded_cube([lug_h, lug_w, z_len], 1.2, center=true);
    }
  }
}

// Everything past the plane the base part's lock pieces slide on (the outer face of the slab)
module lock_slide_clearance() {
  dz(-r3) skewxz(tan(tilt)) translate([-100, -mount_length/2-1, -50]) cube([100-(R1+lock_offset_x+r3+mount_width/2), mount_length+2, 150]);
}

// Inside of the flat cap / solid wall, extended below the base so nothing is left hanging into it
module cage_cavity() {
  if (flat_top) {
    wall_h = max(flat_wall_height, 2*r3);
    dz(-r3-1) cylinder(r=R1+r1-r3, h=wall_h-flat_plate_thickness+1);
  } else {
    cage_volume(R1, open_bottom=true);
  }
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
    if (d_shape) {
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
  if (d_shape) {
    extra_r = r - R1;
    top_w = vibe_top_width + 2*extra_r;
    extra_h = vibe_extra_height;
    corner_r = vibe_corner_radius + extra_r;
    linear_extrude(height=0.01, center=true)
      d_section_2d(r, extra_h, top_w, corner_r);
  } else {
    cylinder(r=r, h=0.01, center=true);
  }
}

// Flat cap: the cage ring grown upward into a wall, closed by a plate with holes
module flat_cap() {
  wall_h = max(flat_wall_height, 2*r3);
  // Wall: the cage ring with a rectangular section, same edge radius as the base ring
  dz(-r3+wall_h/2) profile_torus(R1+r1, 2*r3, wall_h, base_ring_roundness*r2/r3);
  // Top plate, flush with the top of the wall
  dz(-r3+wall_h-flat_plate_thickness) difference() {
    cylinder(r=R1+r1, h=flat_plate_thickness);
    // Holes start above the bridge layer when it is on, otherwise they go right through
    hole_start = flat_bridge_layer ? flat_bridge_layer_thickness : -1;
    dz(hole_start) {
      if (flat_center_hole > 0) cylinder(d=flat_center_hole, h=flat_plate_thickness-hole_start+1);
      if (flat_hole_count > 0) for (i = [0:flat_hole_count-1]) rz(i*360/flat_hole_count) dx(flat_hole_radius) cylinder(d=flat_hole_diameter, h=flat_plate_thickness-hole_start+1);
    }
  }
}

module cage_bar_segments() {
  for (theta = [step/2:step:360-step/2]) {
    // Straight segment begins at a point along the base ring, and ends at a point a distance R1 from point Q
    straightSegStart = rz([R1+r1, 0, 0], theta);
    straightSegEnd = Q + ry(straightSegStart, tilt);
    curveSegEnd = ry(straightSegEnd-P, Phi)+P;
    
    // make a cylinder between straightSegStart and straightSegEnd
    segAngle = 90-atan2(straightSegEnd.z - straightSegStart.z, straightSegEnd.x - straightSegStart.x);
    segLength = norm(straightSegEnd - straightSegStart);
    translate(straightSegStart) ry(segAngle) cylinder(r=r1, h=segLength);
    
    // Make a torus between straightSegEnd and curveSegEnd, if necessary
    if (Phi>0) {
      // First, find the angle between the ends of the curve
      vec1 = [straightSegEnd.x, 0, straightSegEnd.z]-P;
      vec2 = [curveSegEnd.x, 0, curveSegEnd.z]-P;
      curveAngle = acos(dot(vec1, vec2)/(norm(vec1)*norm(vec2)));
      curveRad = norm(vec1);
      translate(straightSegEnd) ry(-180+tilt) dx(-curveRad) rx(90) torus(curveRad, r1, -curveAngle, rounded=true);
    }
  }
}

module glans_cap() {
  // First, ensure the slit width is within the bounds of the cage geometry
  real_slit_width = max(min(slit_width, cage_diameter), 0.1);
  translate(R) ry(Phi+tilt) {
    // Ring around base of glans cap
    ring_opening = (360/cage_bar_count);
    rotate([0,0,ring_opening/2])
      torus(R1+r1, r1, phi=(360-ring_opening));
    // Calculate the start and end points of the bars that create the front slit
    slitRadius = (R1+r1)*cos(asin(real_slit_width/2/(R1+r1)));
    slitStart = [slitRadius, -real_slit_width/2, 0];
    slitEnd = mx(slitStart);
    
    // Draw slit bars
    dy(-real_slit_width/2) rx(90) torus(slitRadius, r1, 180);
    dy(real_slit_width/2) rx(90) torus(slitRadius, r1, 180);
    dy(-real_slit_width/2) dx(slitRadius) sphere(r=r1);
    dy(real_slit_width/2) dx(slitRadius) sphere(r=r1);
    
    // Draw each cage bar (minus the part that would enter the slit area)
    *for (theta = [step/2:step:180-step/2]) {
      // Do not calculate/draw the bar if the bar begins within the slit area
      if ((R1+r1)*sin(theta) > real_slit_width/2) {
        // Compute arc length of this side bar
        distanceInSlit = (real_slit_width/2)/sin(theta);
        arcLength = acos(distanceInSlit/(R1+r1));
        rz(theta) rx(90) torus(R1+r1, r1, arcLength);
        rz(180+theta) rx(90) torus(R1+r1, r1, arcLength);
      }
    }
  }
}

module cage_lock() {
  // Create the solid arc that interfaces with the mating parts (a flat cap or a solid wall does this job itself)
  if (!flat_top && !solid_wall) mount_arc();
  // Create the flat plane on which the mating parts slide
  mount_flat();
  // Create the cage's piece of the lock
  lock_dovetail_inner();
}

// Place the Fusion 360 lock: axis along Y, key face toward +Y, recessed lock_key_depth below the case surface
module lock_position() {
  dx(-R1-lock_offset_x-r3-mount_width/2-lock_lateral) ry(tilt) dz(lock_vertical) dy(mount_length/2-lock_key_depth) rz(90) children();
}

// Cut a cavity for the lock module
module lock_cavity() {
  if (lock_type == 0) {
    dx(-R1-lock_offset_x-r3-mount_width/2-lock_lateral) ry(tilt) dz(lock_vertical) dy(19-mount_length/2) {
      stealth_lock(lock_margin);
      rx(-90) cylinder(r=3.5+lock_margin, h=mount_length-19);
    }
  } else {
    lock_position() fusion_lock_cavity(lock_margin, lock_turn, lock_clockwise, ext=lock_key_depth+5);
  }
}

module lock_dovetail_inner() {
  inner_dovetail_length = mount_length/3 - part_margin;
  difference() {
    lock_case_shape(inner_dovetail_length);
    // Ensure the lock body does not enter the cage itself
    dz(-r3) skewxz(tan(tilt)) cylinder(r=R1+lock_offset_x+r3, h=100, center=true);
    // Cut a cavity for the lock module
    lock_cavity();
  }
}

// 2D common-tangent bridge between lock holder and body side of base ring
//
// In this 2D module (XZ cross-section plane):
//   - The 2D X-axis represents the 3D X-axis (radial: negative is lock/dorsal, positive is ventral).
//   - The 2D Y-axis represents the 3D Z-axis (height: negative is base ring, positive is glans).
//   - The convex hull between two circles produces the exact mathematical external common-tangent line!
//   - The 3D module below extrudes this 2D profile across width w (along 3D Y-axis).

module lock_tangent_bridge_2d() {

  // ==============================================================================
  // TOP EDGE ANCHOR (CHOOSE ONE OPTION):
  // ==============================================================================

  // --- OPTION A (COMMENTED OUT): Tangent to the TOP rounded cylinder of the lock case ---
  // This targets the upper crest of the lock assembly at Z = mount_height * cos(tilt) ≈ 17.8mm.
  // c_lock_x = -3 - R1 - lock_offset_x - r3 - mount_width/2;
  // c_lock_z = mount_height * cos(tilt) - lock_case_upper_radius;
  // r_lock = lock_case_upper_radius; // 9.0mm

  // --- OPTION B (ACTIVE): Tangent to the LOWER-OUTER rounded corner of the lock case ---
  // This targets the rounded corner closest to the wearer's body (at Z ≈ -2.8mm, X ≈ -35.4mm).
  // Because Z <= -r3, it stays completely below the cage entrance and never cuts into the watch chamber!
  r_lock = 11.0; // matches lower_radius in lock_case_shape (outer lock piece)
  c_lock_x = -R1 - lock_offset_x - r3 - mount_width/2 - lock_case_upper_radius + r_lock -5;
  c_lock_z = r_lock - 2*r3; // matches (lower_radius - r3 - extra) where extra = r3

  // ==============================================================================
  // BASE RING WIRE ANCHOR (TANGENT TO BODY SIDE):
  // ==============================================================================
  // Center of the circular base ring in 3D X:
  ring_cx = R2 + r2 - R1 - r1 - gap * tan(tilt);

  // Center of the base ring wire cross-section directly under the lock (-X side):
  c_ring_x = ring_cx - (R2 + r2); // X position of the ring wire center
  c_ring_z = -gap;                // Z position of the ring center (-12mm)
  r_ring = r2;                    // Radius of the ring wire cross-section (4mm)

  // ==============================================================================
  // SLIDING PLANE:
  // ==============================================================================
  // The vertical sliding face where the cage dovetail slides down onto the base ring:
  slide_x = -(R1 + lock_offset_x + r3 + mount_width/2);

  difference() {
    // ----------------------------------------------------------------------------
    // 1. CONVEX HULL: Produces the exact external common-tangent between both circles!
    // ----------------------------------------------------------------------------
    hull() {
      // Circle at the lock anchor (Option A or Option B above):
      translate([c_lock_x, c_lock_z])
        circle(r=r_lock, $fn=64);

      // Circle at the base ring wire (tangent to the body side):
      translate([c_ring_x, c_ring_z])
        circle(r=r_ring, $fn=64);
    }
    
    // ----------------------------------------------------------------------------
    // 2. SLIDING CLEARANCE: Clear above Z = -r3 and X > slide_x so the cage can slide down
    // ----------------------------------------------------------------------------
    translate([slide_x, -r3])
      square([50, 50]);
      
    // ----------------------------------------------------------------------------
    // 3. INNER BORE CLEARANCE: Clear the inner circle of the base ring (radius R2)
    // ----------------------------------------------------------------------------
    // Guarantees zero support material can ever intrude into the scrotal/penis bore!
    translate([ring_cx, c_ring_z])
      circle(r=R2, $fn=64);
      
    // ----------------------------------------------------------------------------
    // 4. UNDERSIDE CLEARANCE: Clear below the bottom of the base ring wire
    // ----------------------------------------------------------------------------
    // Guarantees the body-facing underside of the ring remains smooth and rounded!
    translate([c_ring_x - 50, -gap - 50])
      square([100, 50 - r_ring]);
  }
}

// 3D extrusion of the 2D profile across width w (along 3D Y-axis):
module lock_tangent_bridge_3d(w) {
  rotate([90, 0, 0])
    linear_extrude(height=w, center=true)
      lock_tangent_bridge_2d();
}


module lock_dovetail_outer() {
  bridge_w = d_shape ? (20.0 - 2*part_margin) : mount_length;
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
      // Ensure the cage's inner dovetail sliding track is clear
      dz(-r3) skewxz(tan(tilt))
        translate([-100, -(mount_length/6 + part_margin), -r3])
          cube([150, 2*(mount_length/6 + part_margin), mount_height*cos(tilt) + 2*r3]);
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
  closed = flat_top || solid_wall;
  // On a closed shape the slab reaches in past the wall at its ends, so its sides run straight into the wall;
  // cage() then trims it flush with the inner surface
  inner = closed ? sqrt(max(sq(R1) - sq(mount_length/2), 0)) : R1+lock_offset_x+r3-mount_width/2;
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
