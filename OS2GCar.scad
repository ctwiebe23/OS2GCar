$fa = 1;
$fs = 0.01;

//clipping, tolerance, wall
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
mmountd = mz;
// motor wire tunnel
mtunnelx = mx + 3;
mtunnely = 0.2;
mtunnelOffset = 0.1;

//BREADBOARD
bbx = 3.313 + t;
bby = 2.210 + t;
bbz = 0.383 + t;
//breadboard wire tunnel
bbtunnelx = bbx - w/2;
bbtunnely = bby - w;
bbtunnelz = bbz*2;
//expansion snaps
bbsnapx = bbx;
bbsnapy = bby + 0.063;
bbsnapz = 0.191 + t;

//BATTERY
bx = 3.790 + t;
by = 0.979 + t;
bz = 0.779 + t;
//cable tunnel
btunnelx = bx + 1;
btunnely = 0.6;
btunnelz = btunnely + (bz - btunnely)/2;

//WHEEL
wy = 0.315;
wd = 2.380;

//ORB HOUSING
//actual orb
oactuald = 0.5;
//negative orb
otolerance = 0.02;
od = oactuald + otolerance;
//housing
oshelld = od + w/2;
oshellOpeningz = 2.6*oshelld/7;
oshellOffsetz =  -oactuald/2 + wd/2 + mz/2 - bz + 2*c;
odiskd = by;
odiskh = w/4;
opillard = oshelld;
opillarh = oshellOffsetz - oactuald/2 + c;
ofinx = w/4;
ofiny = oshelld;
ofinz = od;

//ASSEMBLY
//bread clip
bcx = bbx + w/2;
bcy = bby + w;
bcz = bbz + w + mz;
//axel
yminOfBreadboard = bby + w;
yminOfBattery = by + w + my*2;
ax = mfinx + w;
ay = (yminOfBreadboard > yminOfBattery) ? yminOfBreadboard : yminOfBattery;
az = mz + w/2;
//shell
sx = bx + w;
sy = by + w;
sz = bz + w/2;

module Motor() {
    cube([mx, my, mz], center = true);
    translate([0, -(mfinOffset - my/2 + mfiny/2), 0])
        cube([mfinx, mfiny, mz], center = true);
    translate([(mx/2 - mmountd/2), -(mmounty/2 + my/2 - c), 0])
        rotate([90, 0, 0])
        cylinder(h = mmounty, r = mmountd/2, center = true);
    translate([(mtunnelx/2 - mx/2), -(-my/2 + mtunnely/2 + mtunnelOffset), 0])
        cube([mtunnelx, mtunnely, mz], center = true);
}

module Breadboard() {
    cube([bbx, bby, bbz], center = true);
    translate([w/4, 0, (bbtunnelz/2 - bbz/2)])
        cube([bbtunnelx, bbtunnely, bbtunnelz], center = true);
    translate([0, -(bbsnapy - bby)/2, (-bbz/2 + bbsnapz/2)])
        cube([bbsnapx, bbsnapy, bbsnapz], center = true);
}

module Battery() {
    cube([bx, by, bz], center = true);
    translate([(btunnelx/2 - bx/2), 0, (bz - btunnely)/4])
        cube([btunnelx, btunnely, btunnelz], center = true);
}

module Wheel() {
    rotate([90, 0, 0])
        cylinder(h = wy, r = wd/2, center = true);
}

module OrbFin() {
        cube([ofinx, ofiny, ofinz], center = true);
}

module Orb() {
    sphere(d = oactuald);
}

module OrbShell() {
    %Orb();
    translate([0, 0, (-od/2 + oactuald/2)])
    difference() {
        sphere(d = oshelld);
        sphere(d = od);
        translate([0, 0, (-oshelld/2 + oshellOpeningz/2)])
            cube([oshelld, oshelld, oshellOpeningz], center = true);
        OrbFin();
        rotate([0, 0, 60])
            OrbFin();
        rotate([0, 0, 120])
            OrbFin();
    }
    translate([0, 0, (-odiskh/2 + oshellOffsetz)])
        cylinder(h = odiskh, r = odiskd/2, center = true);
    translate([0, 0, (-opillarh/2 + oshellOffsetz)])
        cylinder(h = opillarh, r = opillard/2, center = true);
}

module NegativeOrbShell() {
    translate([0, 0, (-odiskh/2 + oshellOffsetz)])
        cylinder(h = (odiskh + t), r = (odiskd/2 + t), center = true);
    translate([0, 0, (-oshelld/2 + oshellOffsetz)])
        cylinder(h = oshelld, r = ((odiskd - w/2)/2 + t), center = true);
}

module Breadclip() {
    difference() {
    translate([(mx/2 - mz/2), 0, 0])
    difference() {
        translate([0, 0, -mz/2])
            cube([bcx, bcy, bcz], center = true);
        translate([(w/4 + c), 0, 0])
            Breadboard();
    }
    translate([0, 0, -mz/2])
    union() {
        cube([(ax-w), (bcy + c), (bcz + c)], center = true);
        translate([(mx/2 - mz/2), 0, 0])
            cube([(bcx + c), by, (bcz + c)], center = true);
        translate([(bcx/2 - bbx/4 + mx/2 - mz/2), 0, (bcz/2 - w/4)])
            cube([(bbx/2 + c), (bcy + c), (w/2 + c)], center = true);
    }
    }
}

module Axel() {
    translate([(-mx/2 + mmountd/2), 0, (-az/2 + mz/2)])
    difference() {
    union() {
        cube([ax, ay, az], center = true);
        translate([0, 0, (bcz/2 - w/4 - c)])
            color("red") Breadclip();
    }
    translate([0, -(ay/2 - my/2 + c), (az/2 - mz/2 + c)])
        Motor();
    translate([0, (ay/2 - my/2 + c), (az/2 - mz/2 + c)])
        rotate([180, 0, 0])
        Motor();
    }
}

module Shell() {
    difference() {
    union() {
        Axel();
        translate([0, 0, (-sz/2 + mz/2)])
            cube([sx, sy, sz], center = true);
    }
    translate([0, 0, (-bz/2 + mz/2 + c)])
        Battery();
    translate([(bx/2 - odiskd/2 - w/2), 0, (-wd/2 + oactuald/2)])
        NegativeOrbShell();
    translate([-(bx/2 - odiskd/2 - w/2), 0, (-wd/2 + oactuald/2)])
        NegativeOrbShell();
    }
}

module NotPrinted() {
    translate([(bx/2 - odiskd/2 - w/2), 0, (-wd/2 + oactuald/2)])
        OrbShell();
    translate([-(bx/2 - odiskd/2 - w/2), 0, (-wd/2 + oactuald/2)])
        OrbShell();
    translate([0, -(ay/2 + wy/2), 0])
        Wheel();
    translate([0, (ay/2 + wy/2), 0])
        Wheel();
}

Shell();
%NotPrinted();
rotate([180, 0, 0])
    *OrbShell();
rotate([180, 0, 0])
    *NegativeOrbShell();
*Orb();