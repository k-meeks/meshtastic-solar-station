# Solar Power System Design

## Power Budget Analysis

### Load Calculation

**ESP32 Power Consumption:**
- **Active (transmitting):** ~240mA @ 3.3V = 0.79W
- **Active (receiving):** ~80mA @ 3.3V = 0.26W  
- **Deep sleep:** ~5mA @ 3.3V = 0.016W
- **Average (Meshtastic duty cycle):** ~40mA @ 3.3V = 0.13W

**WiO-SX1262 Power Consumption:**
- **Transmit (+22dBm):** ~120mA @ 3.3V = 0.40W
- **Receive:** ~12mA @ 3.3V = 0.04W
- **Sleep:** ~1.5μA @ 3.3V ≈ 0W
- **Average (LoRa duty cycle):** ~15mA @ 3.3V = 0.05W

**Total System Load:**
```
Average current: 40mA + 15mA = 55mA @ 3.3V
Daily consumption: 55mA × 24h = 1.32Ah per day
Safety margin (20%): 1.32Ah × 1.2 = 1.58Ah per day
```

## Solar Generation Analysis

### Panel Specifications

**Individual Panel:**
- **Voltage:** 6V nominal (7.2V open circuit)
- **Current:** 250mA @ full sun
- **Power:** 1.5W per panel
- **Dimensions:** 137mm × 85mm × 2mm

**Series Configuration:**
- **Total voltage:** 12V nominal (14.4V open circuit)
- **Total current:** 250mA @ full sun
- **Total power:** 3W combined

### Iowa Solar Conditions

**Daily Solar Hours by Season:**
| Season | Peak Sun Hours | Generation (mAh) |
|--------|----------------|------------------|
| Summer (June) | 7-8 hours | 1750-2000mAh |
| Spring/Fall | 5-6 hours | 1250-1500mAh |
| Winter (December) | 3-4 hours | 750-1000mAh |

**Annual Average:** ~5.5 peak sun hours = 1375mAh daily

### Panel Mounting Optimization

**35° Tilt Angle Benefits:**
- **Optimized for Iowa latitude** (41°N)
- **Year-round performance** balance
- **Snow shedding** in winter
- **Reduced summer overheating**

**Monthly Performance (Iowa):**
```
Jan: 3.5 hours × 250mA = 875mAh
Feb: 4.0 hours × 250mA = 1000mAh  
Mar: 5.0 hours × 250mA = 1250mAh
Apr: 6.0 hours × 250mA = 1500mAh
May: 7.0 hours × 250mA = 1750mAh
Jun: 7.5 hours × 250mA = 1875mAh
Jul: 7.5 hours × 250mA = 1875mAh
Aug: 7.0 hours × 250mA = 1750mAh
Sep: 6.0 hours × 250mA = 1500mAh
Oct: 5.0 hours × 250mA = 1250mAh
Nov: 3.5 hours × 250mA = 875mAh
Dec: 3.0 hours × 250mA = 750mAh
```

## Battery System Design

### LiPo Battery Selection

**6000mAh 3.7V LiPo Specifications:**
- **Capacity:** 6000mAh (6Ah)
- **Voltage range:** 3.0V - 4.2V
- **Energy:** 22.2Wh
- **Backup runtime:** 6000mAh ÷ 55mA = 109 hours = 4.5 days

### Battery Management System (BMS)

**Critical BMS Functions:**
1. **Overcharge protection** - prevents voltage >4.2V
2. **Overdischarge protection** - cuts off at 3.0V
3. **Current limiting** - protects during solar charging
4. **Temperature monitoring** - Iowa temperature extremes
5. **Cell balancing** - maintains capacity over time

**Recommended BMS Features:**
- **Charge current:** 1-2A maximum
- **Discharge current:** 3A maximum (plenty for load)
- **Protection voltage:** 3.0V cutoff, 4.2V max
- **Temperature range:** -20°C to +60°C

## Charging System Analysis

### Solar Charging Profile

**Optimal Charging Strategy:**
1. **Bulk charge:** Constant current until 4.0V
2. **Absorption:** Constant voltage 4.2V until current drops
3. **Float:** Maintain 4.0-4.1V for longevity

**Daily Charging Cycles:**
```
Best case (summer): 1875mAh generated - 1320mAh consumed = +555mAh net
Worst case (winter): 750mAh generated - 1320mAh consumed = -570mAh net
```

### Autonomy Calculation

**Backup Days Without Sun:**
- **Full battery:** 6000mAh
- **Usable capacity (80% DoD):** 4800mAh  
- **Daily consumption:** 1320mAh
- **Backup time:** 4800mAh ÷ 1320mAh = 3.6 days

**Iowa Weather Patterns:**
- **Cloudy periods:** Rarely exceed 3-4 consecutive days
- **Winter storms:** System survives typical weather patterns
- **Safety margin:** 20% additional capacity factored in

## System Integration

### Charging Circuit Design

**Solar → BMS → Battery → Load Path:**
```
Solar Panels (12V, 250mA)
    ↓
Blocking Diode (Schottky, 1A)
    ↓  
BMS Input (charge management)
    ↓
LiPo Battery (6000mAh)
    ↓
BMS Output (discharge management)
    ↓
ESP32/SX1262 Load (3.3V via regulator)
```

### Voltage Regulation

**3.3V Supply Options:**
1. **Linear regulator** (LM1117-3.3) - simple, some efficiency loss
2. **Switching regulator** (AMS1117-3.3) - higher efficiency
3. **ESP32 internal regulator** - if input voltage compatible

**Efficiency Considerations:**
- **Linear regulator:** ~75% efficiency (3.3V/4.2V)
- **Switching regulator:** ~85-90% efficiency
- **Power savings:** Switching recommended for battery life

## Environmental Factors

### Temperature Effects

**Battery Performance vs Temperature:**
| Temperature | Capacity | Charging |
|-------------|----------|----------|
| -20°F (-29°C) | 60% | Not recommended |
| 32°F (0°C) | 80% | Reduced rate |
| 77°F (25°C) | 100% | Normal |
| 100°F (38°C) | 95% | Normal |
| 120°F (49°C) | 85% | Reduced rate |

**Solar Panel Temperature Effects:**
- **Power decreases** ~0.4% per °C above 25°C
- **Summer derating:** ~10% in Iowa heat
- **Winter benefit:** Higher efficiency in cold

### Weather Resilience

**System Robustness:**
- **Sealed enclosure** protects electronics
- **Condensation management** with desiccant packs
- **Ice loading** - panels shed ice due to tilt
- **Wind resistance** - low profile mounting

## Monitoring and Diagnostics

### Recommended Sensors

**Battery Monitoring:**
- **Voltage measurement** via ESP32 ADC
- **Current sensing** with Hall effect sensor
- **Temperature probe** for battery pack

**Solar Monitoring:**
- **Panel voltage** measurement
- **Charging current** sensing
- **Daily energy** accumulation tracking

### Meshtastic Integration

**Telemetry Packets:**
```json
{
  "battery_voltage": 3.8,
  "battery_percent": 75,
  "solar_voltage": 12.4,
  "charge_current": 180,
  "daily_generation": 1450,
  "days_since_full": 2
}
```

## Performance Optimization

### Energy Efficiency Improvements

**Software Optimizations:**
1. **Deep sleep** between transmissions
2. **Reduce beacon interval** during low battery
3. **Dynamic power management** based on solar conditions
4. **Voltage-based duty cycle** adjustment

**Hardware Optimizations:**
1. **Low-dropout regulators** for efficiency
2. **Power switches** for non-essential functions
3. **LED indicators** only when needed
4. **Efficient antenna design** reduces required TX power

### Maintenance Schedule

**Monthly Tasks:**
- **Visual inspection** of solar panels
- **Battery voltage** check via telemetry
- **Connection integrity** verification

**Seasonal Tasks:**
- **Panel cleaning** (dust, pollen, bird droppings)
- **Desiccant replacement** if needed
- **Performance data** analysis

**Annual Tasks:**
- **Battery capacity** test
- **Full system** inspection and resealing

## Cost Analysis

### Component Costs

| Component | Cost | Source |
|-----------|------|--------|
| 2× Solar Panels | $25 | Amazon/AliExpress |
| 6000mAh LiPo | $20 | Hobby suppliers |
| BMS Module | $8 | Electronic suppliers |
| Mounting hardware | $5 | Hardware store |
| **Total Solar System** | **$58** | |

**Compare to Alternatives:**
- **Grid power + UPS:** $100+ plus monthly costs
- **Commercial solar kit:** $150-200
- **Generator backup:** $200+ plus fuel costs

## Future Expansion Options

### Scalability Features

**Power System Upgrades:**
- **Additional panels** in parallel for more current
- **Larger battery** for extended autonomy  
- **Wind generator** supplement for winter
- **Grid-tie option** for permanent installations

**Load Expansion:**
- **Environmental sensors** (weather station)
- **Security cameras** with motion detection
- **WiFi hotspot** functionality
- **Emergency communications** during outages

---

*This solar power system transforms the Meshtastic node from a temporary installation into permanent infrastructure.*
