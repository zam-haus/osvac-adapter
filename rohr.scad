use <vacuum-hose-adapter-openscad/modules/connector_osvac.scad>;

connector_type = "osvac_female"; // [osvac_male, osvac_female]

/* [Connector settings] */
inner_diameter = 48;
outer_diameter = 55.5;

inner_diameter_narrow = 0.5;
outer_diameter_narrow = 0.5;

depth = 25;
wall_thickness = 3;
top_wall_thickness = 3;
chamfer_angle = 45; // [0 : 80]
full_chamfer_for_female = true;

module __sep__() {}



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

difference() {
    union() {
        difference() {
            cylinder(depth+top_wall_thickness, d = outer_diameter + 2 * wall_thickness);
            
            translate([0,0,-e]) cylinder(depth, d1 = outer_diameter, d2 = outer_diameter-outer_diameter_narrow);
        }

        cylinder(depth, d1 = inner_diameter, d2 = inner_diameter + inner_diameter_narrow);
    }
    
    translate([0,0,-e]) cylinder(depth+top_wall_thickness+e+e, d1 = inner_diameter - 2 * wall_thickness ,d2 = OSVAC_INNER_DIAMETER);
}

chamfer = 
    (full_chamfer_for_female && connector_type == "osvac_female") ?
    OSVAC_F_LEN :
    (outer_diameter + 2 * wall_thickness - osvac_outer_diam)/2 * tan(chamfer_angle);

connector_distance = (connector_type == "osvac_male") ? chamfer : 0;

translate([0,0,depth+top_wall_thickness-e]) difference() {
    cylinder(chamfer, d1 = outer_diameter + 2 * wall_thickness, d2 = osvac_outer_diam);
    translate([0,0,-e]) cylinder(chamfer+e+e, d=OSVAC_INNER_DIAMETER);
    translate([0,0,connector_distance+e]) cylinder(99999, d=osvac_outer_diam - e);
}

translate([0,0,depth+top_wall_thickness+connector_distance-e]) osvac(my_gender);
