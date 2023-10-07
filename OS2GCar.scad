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
mtunnelx = mx + 3;
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

//TODO: BREADBOARD
bbx = 3.4;
bby = 2.2;
bbz = 0.4;
//breadboard wire tunnel
bbtx = bbx - w/2;
bbty = bby - w;
bbtz = bbz*2;

module Breadboard() {
    cube([bbx, bby, bbz], center = true);
    translate([w/4, 0, (bbtz/2 - bbz/2)])
        cube([bbtx, bbty, bbtz], center = true);
}

//BATTERY
bx = 3.790 + t;
by = 0.979 + t;
bz = 0.779 + t;
//cable tunnel
btx = bx + 1;
bty = 0.6;
btz = bty + (bz - bty)/2;

module Battery() {
    cube([bx, by, bz], center = true);
    translate([(btx/2 - bx/2), 0, (bz - bty)/4])
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
//bread clip
bcx = bbx + w/2;
bcy = bby + w;
bcz = bbz + w;

module Breadclip() {
    difference() {
    translate([(mx/2 - mz/2), 0, 0])
    difference() {
        cube([bcx, bcy, bcz], center = true);
        translate([(w/4 + c), 0, 0])
            Breadboard();
    }
    cube([ax, (bcy + c), (bcz + c)], center = true);
    translate([(mx/2 - mz/2), 0, 0])
        cube([(bcx + c), by, (bcz + c)], center = true);
    }
}

//axel
yminOfBreadboard = bby + w;
yminOfBattery = by + w + my*2;

ax = mfinx + w;
ay = (yminOfBreadboard > yminOfBattery) ? yminOfBreadboard : yminOfBattery;
az = mz + w/2;

module Axel() {
    translate([(-mx/2 + mmountCircum/2), 0, (-az/2 + mz/2)])
    difference() {
    union() {
        cube([ax, ay, az], center = true);
        translate([0, 0, (mz/2 + bcz/2 - w/4 - c)])
            Breadclip();
    }
    translate([0, -(ay/2 - my/2 + c), (az/2 - mz/2 + c)])
        Motor();
    translate([0, (ay/2 - my/2 + c), (az/2 - mz/2 + c)])
        rotate([180, 0, 0])
        Motor();
    }
    

}

//shell
sx = bx + w;
sy = by + w;
sz = bz + w/2;

module Shell() {
    difference() {
    union() {
        Axel();
        translate([0, 0, (-sz/2 + mz/2)])
            cube([sx, sy, sz], center = true);
    }
    translate([0, 0, (-bz/2 + mz/2 + c)])
        Battery();
    }
}

Shell();