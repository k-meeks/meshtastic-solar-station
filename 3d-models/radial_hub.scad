// Clean 3D Printable BOTTOM Hub for LoRa Ground Plane Antenna
// Mounts to bottom of project box - radials only
// Simple geometry - just radial holes and mounting

// Parameters
rod_diameter = 11.1;        // 7/16" fiberglass rod
tolerance = 0.8;            // Print tolerance
hole_diameter = rod_diameter + tolerance;  // 11.9mm

hub_diameter = 60;
hub_height = 20;
radial_distance = 22;       // Distance from center
mount_diameter = 4.0;
mount_circle = 45;

// Bottom hub - radials only
difference() {
    // Solid hub cylinder
    cylinder(h=hub_height, d=hub_diameter, $fn=64);
    
    // Four angled radial holes
    for(i = [0:3]) {
        rotate([0, 0, i * 90]) {
            translate([radial_distance, 0, hub_height * 0.6]) {
                rotate([0, 45, 0]) {
                    translate([0, 0, -25])
                        cylinder(h=50, d=hole_diameter, $fn=32);
                }
            }
        }
    }
    
    // Mounting holes
    for(i = [0:3]) {
        rotate([0, 0, i * 90 + 45]) {
            translate([mount_circle/2, 0, -1])
                cylinder(h=hub_height + 2, d=mount_diameter, $fn=16);
        }
    }
}

// Clean bottom hub - just radials and mounting holes