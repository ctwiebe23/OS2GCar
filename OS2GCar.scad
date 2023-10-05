$fa = 1;
$fs = 0.1;

c = 0.001;
t = 0.005;
w = 0.4;

//MOTOR
mx = 0.887 + t;
my = 0.919 + t;
mz = 0.488 + t;
//fins
mfinx = 1.270 + t;
mfiny = 0.098 + t;
mfinOffset = 0.665;
//wheel mount
mmounty = 0.171 + t;
mmountCircum = mz;
//wire tunnel
mtunnelx = mx + 1;
mtunnely = 0.2;
mtunnelOffset = 0.1;

module Motor() {
    cube([mx, my, mz], center = true);
    translate([0, -(mfinOffset - my/2 + mfiny/2), 0])
        cube([mfinx, mfiny, mz], center = true);
    translate([(mx/2 - mmountCircum/2), -(mmounty/2 + my/2 - c), 0])
        rotate([90, 0, 0])
        cylinder(h = mmounty, r = mmountCircum/2, center = true);
    translate([(mtunnelx/2 - mx/2), -(-my/2 + mtunnely/2 + mtunnelOffset), 0])
        cube([mtunnelx, mtunnely, mz], center = true);
}
//BREADBOARD
bbx = 0;
bby = 0;
bbz = 0;

module Breadboard() {
    cube([bbx, bby, bbz], center = true);
}
//BATTERY
bx = 3.790 + t;
by = 0.979 + t;
bz = 0.779 + t;
//cable tunnel
btx = bx + 1;
bty = 0.6;
btz = 0.6;

module Battery() {
    cube([bx, by, bz], center = true);
    translate([(btx/2 - bx/2), 0, 0])
        cube([btx, bty, btz], center = true);
}
//BALL BEARING HOUSING

//WHEEL
wy = 0.315;
wCircum = 2.380;

module Wheel() {
    rotate([90, 0, 0])
        cylinder(h = wy, r = wCircum/2, center = true);
}
//ASSEMBLY
//axel
ax = mfinx + w;
ay = by + w + my*2 + w;
az = mz + w/2;

module Axel() {
    translate([(-mx/2 + mmountCircum/2), 0, (-az/2 + mz/2)])
    difference() {
    cube([ax, ay, az], center = true);
    translate([0, -(ay/2 - my/2 + c), (az/2 - mz/2 + c)])
        Motor();
    translate([0, (ay/2 - my/2 + c), (az/2 - mz/2 + c)])
        rotate([180, 0, 0])
        Motor();
    }
}
//shell
//bearing mount
//bread clip

Axel();