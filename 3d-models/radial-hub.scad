// 3D Printable Radial Hub for LoRa Ground Plane Antenna
// Designed for 7/16" (11.1mm) fiberglass rods at 45° angles
// Compatible with 4x4x4 PVC electrical box
// 
// Print Settings:
// - Material: PETG or ABS (outdoor UV resistance)
// - Layer Height: 0.2mm
// - Infill: 25-30%
// - Supports: Yes (for angled radial sockets)
// - Print Time: ~3-4 hours

// ============================================================================
// PARAMETERS - Modify these for different configurations
// ============================================================================

// Rod specifications
rod_diameter = 11.1;        // 7/16" fiberglass rod in mm
rod_tolerance = 0.3;        // Printing tolerance for fit
rod_insertion_depth = 15;   // How deep rods insert into hub

// Hub dimensions
hub_height = 25;            // Height of main hub body
hub_diameter = 50;          // Main hub diameter
wall_thickness = 3;         // Minimum wall thickness

// Antenna geometry
radial_angle = 45;          // Radial angle from horizontal (critical!)
num_radials = 4;            // Number of radial elements

// Connector specifications
sma_hole_diameter = 6.5;    // SMA connector hole (6.35mm + tolerance)
vertical_rod_depth = 15;    // Vertical rod socket depth

// Mounting
mounting_hole_diameter = 3.5;  // #6 screw holes for PVC box mounting
mounting_hole_spacing = 35;    // Distance from center to mounting holes

// ============================================================================
// CALCULATED VALUES - Do not modify
// ============================================================================

radial_offset = (hub_diameter/2) - (wall_thickness + rod_diameter/2 + 2);
effective_rod_diameter = rod_diameter + rod_tolerance;

// ============================================================================
// MAIN HUB BODY
// ============================================================================

module main_hub_body() {
    difference() {
        // Main cylindrical hub
        cylinder(h=hub_height, d=hub_diameter, $fn=64);
        
        // Central SMA connector hole (full height)
        translate([0, 0, -0.5])
            cylinder(h=hub_height+1, d=sma_hole_diameter, $fn=32);
        
        // Vertical rod socket from top
        translate([0, 0, hub_height-vertical_rod_depth])
            cylinder(h=vertical_rod_depth+0.5, d=effective_rod_diameter, $fn=32);
        
        // Four radial rod sockets at specified angle
        for (i = [0:num_radials-1]) {
            rotate([0, 0, i*360/num_radials]) {
                translate([radial_offset, 0, hub_height/2]) {
                    rotate([0, radial_angle, 0]) {
                        translate([0, 0, -rod_insertion_depth/2])
                            cylinder(h=rod_insertion_depth, d=effective_rod_diameter, $fn=32);
                    }
                }
            }
        }
        
        // Mounting holes for attachment to PVC box
        for (i = [0:3]) {
            rotate([0, 0, i*90 + 45]) {
                translate([mounting_hole_spacing, 0, -0.5])
                    cylinder(h=hub_height+1, d=mounting_hole_diameter, $fn=16);
            }
        }
    }
}

// ============================================================================
// RADIAL SOCKET GUIDES AND REINFORCEMENT
// ============================================================================

module radial_socket_guides() {
    for (i = [0:num_radials-1]) {
        rotate([0, 0, i*360/num_radials]) {
            translate([radial_offset, 0, hub_height/2]) {
                rotate([0, radial_angle, 0]) {
                    difference() {
                        // Outer guide cylinder
                        cylinder(h=rod_insertion_depth, d=effective_rod_diameter+6, $fn=32);
                        
                        // Inner rod hole
                        translate([0, 0, -0.5])
                            cylinder(h=rod_insertion_depth+1, d=effective_rod_diameter, $fn=32);
                        
                        // Split for rod insertion (makes it slightly flexible)
                        translate([-effective_rod_diameter, -0.8, -0.5])
                            cube([effective_rod_diameter*2, 1.6, rod_insertion_depth+1]);
                    }
                }
            }
        }
    }
}

// ============================================================================
// WIRE MANAGEMENT CHANNELS
// ============================================================================

module wire_channels() {
    // Small channels around each radial socket for 4 copper wires
    for (i = [0:num_radials-1]) {
        rotate([0, 0, i*360/num_radials]) {
            translate([radial_offset, 0, hub_height/2]) {
                rotate([0, radial_angle, 0]) {
                    // Four small channels around the rod socket
                    for (j = [0:3]) {
                        rotate([0, 0, j*90]) {
                            translate([effective_rod_diameter/2 + 1, 0, rod_insertion_depth/2]) {
                                cylinder(h=rod_insertion_depth/2 + 5, d=1.5, $fn=12);
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Central wire management area
    translate([0, 0, hub_height-8]) {
        cylinder(h=8, d=sma_hole_diameter+4, $fn=32);
    }
}

// ============================================================================
// STRUCTURAL REINFORCEMENT
// ============================================================================

module reinforcement_ribs() {
    // Radial ribs between center and radial sockets for strength
    for (i = [0:num_radials-1]) {
        rotate([0, 0, i*360/num_radials]) {
            hull() {
                // Center attachment
                cylinder(h=3, d=sma_hole_diameter+6, $fn=32);
                
                // Outer attachment point
                translate([radial_offset*0.7, 0, 0])
                    cylinder(h=3, d=8, $fn=16);
            }
        }
    }
    
    // Diagonal reinforcement ribs
    for (i = [0:num_radials-1]) {
        rotate([0, 0, i*360/num_radials + 180/num_radials]) {
            hull() {
                cylinder(h=2, d=10, $fn=16);
                translate([hub_diameter/3, 0, 0])
                    cylinder(h=2, d=6, $fn=16);
            }
        }
    }
}

// ============================================================================
// ASSEMBLY MARKINGS AND LABELS
// ============================================================================

module assembly_markings() {
    // Number each radial position
    for (i = [0:num_radials-1]) {
        rotate([0, 0, i*360/num_radials]) {
            translate([hub_diameter/2-3, 0, hub_height-1.5]) {
                linear_extrude(height=2) {
                    text(str(i+1), size=5, halign="center", valign="center", 
                         font="Arial:style=Bold");
                }
            }
        }
    }
    
    // Center SMA marking
    translate([0, 0, hub_height-1.5]) {
        linear_extrude(height=2) {
            text("SMA", size=4, halign="center", valign="center",
                 font="Arial:style=Bold");
        }
    }
    
    // Angle marking for reference
    translate([0, hub_diameter/2-8, hub_height-1.5]) {
        linear_extrude(height=2) {
            text("45°", size=3, halign="center", valign="center",
                 font="Arial:style=Bold");
        }
    }
    
    // Version and frequency marking
    translate([0, -hub_diameter/2+6, 1.5]) {
        linear_extrude(height=1.5) {
            text("915MHz v1.0", size=2.5, halign="center", valign="center",
                 font="Arial:style=Regular");
        }
    }
}

// ============================================================================
// DRAINAGE AND VENTILATION
// ============================================================================

module drainage_features() {
    // Small drainage holes at low points
    for (i = [0:3]) {
        rotate([0, 0, i*90 + 45]) {
            translate([hub_diameter/2-8, 0, 1]) {
                cylinder(h=3, d=1.5, $fn=8);
            }
        }
    }
}

// ============================================================================
// MAIN ASSEMBLY
// ============================================================================

module complete_radial_hub() {
    difference() {
        union() {
            // Main structural components
            main_hub_body();
            radial_socket_guides();
            reinforcement_ribs();
        }
        
        // Features to subtract
        wire_channels();
        drainage_features();
    }
    
    // Features to add on top
    assembly_markings();
}

// ============================================================================
// RENDER THE COMPLETE HUB
// ============================================================================

complete_radial_hub();

// ============================================================================
// PRINT INFORMATION AND SETTINGS
// ============================================================================

/*
PRINT SETTINGS SUMMARY:
======================
Material: PETG (recommended) or ABS for UV resistance
Layer Height: 0.2mm for good surface finish
Infill: 25-30% for strength without excessive material
Supports: YES - required for angled radial sockets
Support Overhang: 45° (default)
Build Plate Adhesion: Brim recommended for stability
Print Speed: 50mm/s or slower for quality

ORIENTATION:
===========
Print with the flat bottom surface on the build plate.
The radial sockets will overhang at 45°, which requires supports.

POST-PROCESSING:
===============
1. Remove support material carefully from radial sockets
2. Test-fit 7/16" fiberglass rod - should be snug but not tight
3. If holes are too tight, use drill bit to carefully enlarge
4. Sand any rough surfaces for professional appearance

ASSEMBLY NOTES:
==============
- Rod insertion depth is 15mm - sufficient for mechanical strength
- Wire channels accommodate 4 copper wires per radial (16 total + 4 vertical)
- Mounting holes are sized for #6 screws to attach to PVC box
- SMA hole is sized for standard bulkhead connector with slight clearance

CUSTOMIZATION:
=============
To modify for different rod sizes, change 'rod_diameter' parameter.
To adjust radial angle, modify 'radial_angle' (45° is optimal for 50Ω match).
For different PVC box sizes, adjust 'mounting_hole_spacing'.

BUILD TIME: Approximately 3-4 hours depending on printer speed and infill.
MATERIAL USAGE: ~50-75g of filament.
*/
