use <vacuum-hose-adapter-openscad/modules/connector_osvac.scad>;

connector_type = "osvac_female"; // [osvac_male, osvac_female]

/* [Connector settings] */
wall_thickness = 3;
top_wall_thickness = 3;
chamfer_angle = 45; // [0 : 80]
full_chamfer_for_female = true;

/* [Hose thread settings] */
thread_depth = 1.5;
thread_width = 2.5;
thread_pitch = 5;
thread_length = 30;

/* [View settings] */
disable_thread_in_preview = false;

module __sep__() {}

disable_thread = $preview && disable_thread_in_preview;


// Epsilon.
e = $preview ? 2e-2 : 1e-3;

OSVAC_M_OUTER_DIAM = 37.8;
OSVAC_F_OUTER_DIAM = 47.265;
OSVAC_M_LEN = 30;
OSVAC_F_LEN = 34;
OSVAC_INNER_DIAMETER = 32;

osvac_outer_diam = (connector_type == "osvac_male") ? OSVAC_M_OUTER_DIAM : OSVAC_F_OUTER_DIAM;

module osvac(gender="m") {
    if (gender=="m") {
       rotate([0,0,180]) rotate([180,0,0]) translate([0,0,-OSVAC_M_LEN]) osVacMaleConnector();
    }
    else {
       rotate([180,0,0]) translate([0,0,-OSVAC_F_LEN]) osVacFemaleConnector();
    }
}

my_gender = (connector_type == "osvac_male") ? "m" : "f";


$fa = 1;
$fs = 1;

use <threads.scad>;


angle = atan((thread_width * 0.666)/thread_depth/2);

echo("angle is", angle);


difference() {
    cylinder(thread_length + top_wall_thickness, d1=41+2*wall_thickness, d2 = max(41+2*wall_thickness, osvac_outer_diam));
    translate([0,0,-e]) mirror([1,0,0]) {
        if (disable_thread) {
            cylinder(thread_length+e+e, d=41);
        }
        else {
            metric_thread(41, thread_pitch, thread_length+e+e, thread_size=thread_width, angle=angle, groove=true);
        }
    }
    translate([0,0,thread_length-e]) cylinder(top_wall_thickness+e+e, d=41);
}

outer_diameter = 41;


chamfer = 
    (full_chamfer_for_female && connector_type == "osvac_female") ?
    OSVAC_F_LEN :
    (outer_diameter + 2 * wall_thickness - osvac_outer_diam)/2 * tan(chamfer_angle);

connector_distance = (connector_type == "osvac_male") ? chamfer : 3.5;

translate([0,0,thread_length+top_wall_thickness-e]) difference() {
    cylinder(chamfer, d1 = outer_diameter + 2 * wall_thickness, d2 = osvac_outer_diam);
    translate([0,0,-e]) cylinder(connector_distance+e+e+e, d2=OSVAC_INNER_DIAMETER, d1 = outer_diameter);
    translate([0,0,connector_distance+e]) cylinder(99999, d=osvac_outer_diam - e);
}

translate([0,0,thread_length+top_wall_thickness+connector_distance-e]) osvac(my_gender);
