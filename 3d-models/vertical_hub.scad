// Clean 3D Printable TOP Hub for LoRa Ground Plane Antenna
// Mounts to top of project box - vertical element only
// Simple geometry - just vertical rod socket and mounting

// Parameters
rod_diameter = 11.1;        // 7/16" fiberglass rod
tolerance = 0.8;            // Print tolerance
hole_diameter = rod_diameter + tolerance;  // 11.9mm

hub_diameter = 40;          // Smaller than bottom hub
hub_height = 15;            // Lower profile
mount_diameter = 4.0;
mount_circle = 30;          // Smaller mounting circle

// Top hub - vertical element only
difference() {
    // Solid hub cylinder
    cylinder(h=hub_height, d=hub_diameter, $fn=64);
    
    // Vertical rod socket - THROUGH HOLE for cable routing
    translate([0, 0, -1])
        cylinder(h=hub_height + 2, d=hole_diameter, $fn=32);
    
    // Mounting holes
    for(i = [0:3]) {
        rotate([0, 0, i * 90]) {
            translate([mount_circle/2, 0, -1])
                cylinder(h=hub_height + 2, d=mount_diameter, $fn=16);
        }
    }
}

// Simple top hub - just vertical rod socket and mounting holes