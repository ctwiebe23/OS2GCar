$fa = 1;
$fs = 0.01;

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
mtunnelx = 1.5;
mtunnely = 0.2;
mtunnelOffset = 0.1;

module MotorNegSpace() {
    cube([mx, my, mz], center = true);
    translate([0, -(mfinOffset - my/2 + mfiny/2), 0])
        cube([mfinx, mfiny, mz], center = true);
    translate([(mx/2 - mmountCircum/2), -(mmounty/2 + my/2 - t), 0])
        rotate([90, 0, 0])
        cylinder(h = mmounty, r = mmountCircum/2, center = true);
    translate([(mtunnelx/2 - mx/2), -(-my/2 + mtunnely/2 + mtunnelOffset), 0])
        cube([mtunnelx, mtunnely, mz], center = true);
}
//BREADBOARD

//BATTERY
bx = 0;
by = 1;
bz = 0;

module BatteryNegSpace() {
}
//SENSOR

//BALL BEARING

//WHEEL

//ASSEMBLY
ax = mfinx + w;
ay = by + w + my*2 + w;
az = mz + w/2 - t;

difference() {
    cube([ax, ay, az], center = true);
    translate([0, -(ay/2 - my/2 + t), (az/2 - mz/2 + t)])
        MotorNegSpace();
    translate([0, (ay/2 - my/2 + t), (az/2 - mz/2 + t)])
        rotate([180, 0, 0])
        MotorNegSpace();

}