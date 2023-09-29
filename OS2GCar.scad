$fa = 1;
$fs = 0.1;

t = 0.005;

//MOTOR
mx = 0.887 + t;
my = 0.919 + t;
mz = 0.488 + t;
//fins
mfinx = 1.270 + t;
mfiny = 0.098 + t;
mfinOffset = 0.665;
//wheel mount
mmounty = 0.171;
mmountCircum = mz;
union() {
cube([mx, my, mz], center = true);
translate([0, -(mfinOffset - my/2 + mfiny/2), 0])
    cube([mfinx, mfiny, mz], center = true);
translate([(mx/2 - mmountCircum/2), -(mmounty/2 + my/2), 0])
    rotate([90, 0, 0])
    cylinder(h = mmounty, r = mmountCircum/2, center = true);
}

//BREADBOARD

//BATTERY

//SENSOR

//BALL BEARING

//WHEEL