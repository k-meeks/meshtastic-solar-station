# Complete Assembly Guide

## Pre-Assembly Preparation

### Tools Required

**Essential Tools:**
- Drill with metal/plastic bits (3/8", 1/4", 1/8")
- Soldering iron (25-40W) with rosin core solder
- Wire strippers and crimpers
- Digital multimeter
- Hot glue gun or marine silicone
- Electrical tape and heat shrink tubing

**Measuring Tools:**
- Ruler or calipers (metric preferred)
- Protractor or angle finder
- Level for solar panel alignment

**Safety Equipment:**
- Safety glasses
- Work gloves
- Anti-static wrist strap (for electronics)

### Materials Checklist

**Electronics:**
- [ ] ESP32 development board
- [ ] Seeed Studio WiO-SX1262 module
- [ ] Breadboard (half-size minimum)
- [ ] Jumper wires (male-to-male, male-to-female)
- [ ] 6000mAh LiPo battery
- [ ] BMS module
- [ ] 3.3V voltage regulator (if needed)

**Antenna Components:**
- [ ] 5× pieces of 7/16" fiberglass rod, each cut to 3.2" (81mm)
- [ ] ~6 feet of 12 AWG solid copper wire
- [ ] SMA bulkhead connector (female-female)
- [ ] Short SMA jumper cable (6" max)

**Enclosure and Mounting:**
- [ ] 4"×4"×4" PVC electrical box (Carlon E987N or equivalent)
- [ ] 2× 137×85×2mm 6V 250mA solar panels
- [ ] Solar panel mounting brackets
- [ ] Stainless steel screws and nuts
- [ ] Marine-grade silicone sealant
- [ ] Cable glands or grommets

**3D Printed Components:**
- [ ] Radial hub (printed from provided OpenSCAD file)

## Phase 1: 3D Print the Radial Hub

### Printing Instructions

**Printer Settings:**
```
Material: PETG (recommended) or ABS
Layer Height: 0.2mm
Infill: 25%
Print Speed: 50mm/s
Supports: Yes (for angled radial sockets)
Build Plate Adhesion: Brim recommended
```

**Print Orientation:**
- Place hub flat-side down on build plate
- Radial sockets will overhang but supports will handle this
- Print time: approximately 3-4 hours

**Post-Processing:**
1. Remove support material carefully
2. Test-fit 7/16" fiberglass rod in sockets
3. Ream holes if too tight (should be snug but not forced)
4. Sand any rough surfaces

## Phase 2: Prepare the Fiberglass Elements

### Cutting the Rods

**Critical Measurements:**
- **All elements must be exactly 3.2" (81mm) long**
- Use a fine-tooth saw or cut-off wheel
- Sand cut ends smooth to prevent wire damage
- **Mark each rod** with numbers 1-5 for assembly tracking

### Wire Installation

**Copper Wire Preparation:**
1. **Cut 20 pieces** of 12 AWG solid copper wire:
   - 4 pieces at 4" long (for vertical element)
   - 16 pieces at 4" long (for radials)
2. **Strip 1/4"** from both ends of each wire
3. **Pre-tin the stripped ends** with solder

**Attaching Wires to Rods:**
1. **Position 4 wires** around each fiberglass rod
2. **Space evenly** at 90° intervals around circumference
3. **Tape every 1/2"** with electrical tape
4. **Ensure wires extend** 1/2" beyond rod ends for connections
5. **Double-check all lengths** - trim if necessary

## Phase 3: Electronics Assembly

### Breadboard Layout

**Component Placement:**
```
ESP32 board: Left side of breadboard
WiO-SX1262: Right side of breadboard
Power rails: Top and bottom
Connections: Center area
```

**Critical Connections:**
```
ESP32 → WiO-SX1262:
- 3.3V → VCC
- GND → GND  
- GPIO18 → SCK
- GPIO19 → MISO
- GPIO23 → MOSI
- GPIO5 → NSS
- GPIO27 → RESET
- GPIO2 → DIO1
```

### Power System Wiring

**BMS Connections:**
1. **Solar input:** Red/black wires from panel series connection
2. **Battery connection:** JST connector to LiPo battery
3. **Load output:** Red/black to ESP32 power input
4. **Protection settings:** Configure per BMS documentation

**Voltage Regulation:**
- If ESP32 requires 3.3V regulated input, install regulator
- Most ESP32 boards accept 3.7-4.2V directly
- **Measure input voltage range** before connecting battery

### Initial Testing

**Pre-Installation Checks:**
1. **Power on test:** Verify ESP32 boots with battery power
2. **LoRa transmission test:** Send test packets to nearby nodes
3. **Solar charging test:** Verify BMS charges battery from panels
4. **Current consumption:** Measure actual power draw

## Phase 4: Enclosure Preparation

### PVC Box Modifications

**Required Holes:**
1. **Center top surface:** 3/8" hole for SMA bulkhead connector
2. **Side panels:** 1/4" holes for solar panel wiring (2 holes)
3. **Bottom:** 1/4" hole for mounting cable (optional)

**Drilling Tips:**
- Use stepped drill bits for clean holes in PVC
- Deburr all holes with sandpaper
- Test-fit all connectors before final assembly

### Solar Panel Mounting

**Bracket Installation:**
1. **Mark panel positions** on front face of box
2. **Angle brackets** to achieve 35° tilt facing south
3. **Use stainless steel hardware** for corrosion resistance
4. **Allow air circulation** behind panels for cooling

**Wiring Setup:**
1. **Parallel connection:** Connect positive of both panels together, negative of both panels together
2. **Output leads:** Combined positive and negative to enclosure
3. **Strain relief:** Use grommets where wires enter
