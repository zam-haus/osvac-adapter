use <vacuum-hose-adapter-openscad/modules/connector_osvac.scad>;


/* [Connector settings] */
wall_thickness = 2.5;
top_wall_thickness = 3;
chamfer_angle = 45; // [0 : 80]
full_chamfer_for_female = true;

module __sep__() {}

connector_type = "osvac_female"; // [osvac_male, osvac_female]


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

inner_diam = 34.8 - 2*wall_thickness;

difference() {
    union() {
    difference() {
        cylinder(OSVAC_F_LEN, d1 = 51.5, d2 = OSVAC_F_OUTER_DIAM);
        translate([0,0,-e]) cylinder(OSVAC_F_LEN+e+e, d=OSVAC_F_OUTER_DIAM-e);
    }
    translate([0,0,-4]) {
        cylinder(4+e, d=51.5);
        translate([0,0,-10]) {
            cylinder(10+e, d=41);
            
            translate([0,0,-10.5]) {
                cylinder(10.5+e, d=34.8);
                
                translate([0,0,-25]) {
                    cylinder(25+e, d=38.5);
                    
                    translate([0,0,-4])
                    cylinder(4+e, d2=38.5, d1=37);
                }
            }
        }
    }
    }
    cylinder(d=inner_diam, h=200, center=true);
    mirror([0,0,1]) cylinder(d2=inner_diam, d1=OSVAC_INNER_DIAMETER, h=10);
}

translate([0,0,0]) osvac(my_gender);
