# MetaSandwich-IL-Jacket (formerly SooMa): Insertion Loss for Multilayer Pipeline Jackets

(Formerly **SooMa**: (SO)und insertion l(O)ss of (M)ultilayer pipeline j(A)cket.)

[![MATLAB](https://img.shields.io/badge/MATLAB-R2018b+-orange.svg)](https://www.mathworks.com/products/matlab.html)
[![License](https://img.shields.io/badge/License-BSD--3--Clause-blue.svg)](#license)

## Overview

SooMa is a MATLAB-based acoustic simulation tool that calculates the **sound insertion loss** of multilayer pipeline jacket systems using the **Transfer Matrix Method**. This tool is designed for acoustic engineers working on pipeline noise control, particularly for industrial applications where sound transmission through pipe walls needs to be minimized.

### Key Features

- 🔧 **Transfer Matrix Method** implementation for acoustic wave propagation
- 🏗️ **Multi-layer geometry** analysis (pipe + porous layer + jacket)
- 📊 **Frequency domain analysis** (50-6000 Hz, optimized for ≤2000 Hz)
- 📈 **Experimental validation** with measured data comparison
- 🎯 **Insertion loss calculation** comparing treated vs. bare pipe systems
- 📋 **Octave band analysis** for standardized reporting

## System Architecture

The analysis considers a three-layer cylindrical system:

```
    ┌─────────────────────────────────────┐
    │        Outer Jacket (Layer 3)       │  ← Impervious barrier
    │  ┌───────────────────────────────┐   │
    │  │    Porous Layer (Layer 2)    │   │  ← Acoustic damping
    │  │  ┌─────────────────────────┐  │   │
    │  │  │   Steel Pipe (Layer 1)  │  │   │  ← Structural pipe
    │  │  │                         │  │   │
    │  │  └─────────────────────────┘  │   │
    │  └───────────────────────────────┘   │
    └─────────────────────────────────────┘
```

## Project Structure

```
SooMa/
├── README.md                          # This file
├── main.m                             # Main simulation script
├── data/
│   └── measured_insertion_loss.mat    # Experimental validation data
└── src/
    ├── parameter_pressure_acoustics.m # Air properties & frequency range
    ├── parameter12.m                  # Steel pipe material properties
    ├── parameter34_jacket.m           # Jacket material properties
    ├── fun_octave.m                   # Octave band analysis utility
    ├── fun_narrow_to_one_third_octave.m # Third-octave processing
    └── savefigure.m                   # Figure export utility
```

## Quick Start

### Prerequisites

- MATLAB R2018b or later
- Signal Processing Toolbox (for Bessel functions)

### Installation

1. Clone or download this repository
2. Open MATLAB and navigate to the SooMa directory
3. Run the main script:

```matlab
>> main
```

### Expected Output

The simulation will:
1. Load material and acoustic parameters
2. Calculate pipe impedance and wave propagation
3. Compute transfer matrices for the porous layer
4. Calculate insertion loss for the complete system
5. Generate a comparison plot with experimental data
6. Display key results in the command window

## Physical Parameters

### Default Configuration

| Parameter | Value | Unit | Description |
|-----------|-------|------|-------------|
| Inner radius (r₁) | 0.15 | m | Pipe inner radius |
| Pipe thickness | 0.0045 | m | Steel wall thickness |
| Porous layer thickness | 0.05 | m | Damping material thickness |
| Jacket thickness | 0.0005 | m | Outer barrier thickness |
| Pipe length | 6 | m | Analysis length |
| Frequency range | 50-6000 | Hz | Analysis bandwidth |

### Material Properties

**Steel Pipe:**
- Density: 7800 kg/m³
- Young's modulus: 20 GPa (with 0.2% damping)
- Poisson's ratio: 0.27

**Air (Standard conditions):**
- Density: 1.2 kg/m³
- Sound speed: 343 m/s

**Porous Material:**
- Specific impedance: 2500 Pa·s/m (with 0.1% loss)

## Customization

To modify the analysis for your specific application:

1. **Geometry**: Edit dimensions in `main.m` (lines 45-55)
2. **Materials**: Modify properties in `src/parameter*.m` files
3. **Frequency range**: Adjust in `src/parameter_pressure_acoustics.m`
4. **Porous material**: Change properties in `main.m` (line 105)

## Theory Background

The simulation implements the **Transfer Matrix Method** for acoustic wave propagation in cylindrical multilayer systems. Key theoretical elements include:

- **Pipe impedance**: Considers mass, stiffness, and damping effects
- **Wave propagation**: Uses Bessel functions for cylindrical geometry
- **Porous media**: Simplified model with complex impedance
- **Radiation loading**: Hankel functions for external radiation
- **Power balance**: Insertion loss from transmitted power ratios

### Assumptions

- Linear acoustic theory (small amplitude waves)
- Cylindrical symmetry with radial wave propagation
- Frequency-independent material properties
- Optimized for low-frequency range (≤ 2000 Hz)

## Results Interpretation

**Insertion Loss (IL)** represents the additional sound reduction provided by the multilayer jacket system compared to a bare pipe:

- **Positive IL**: Jacket system reduces sound transmission
- **Negative IL**: Jacket system increases sound transmission
- **Typical range**: 0-40 dB for effective designs

## Validation

The code includes experimental validation data (`measured_insertion_loss.mat`) for comparison with theoretical predictions. The main script automatically generates a comparison plot showing:

- Theoretical results (Transfer Matrix Method)
- Experimental measurements
- Frequency-dependent performance

## Contributing

Contributions are welcome! Please consider:

- Reporting bugs or issues
- Suggesting improvements to the documentation
- Adding new material models or geometries
- Extending to higher frequency ranges

## Citation

If you use this code in your research, please cite the relevant papers by Zibo Liu. For specific citation information, please contact:

**Author**: Zibo Liu  
**Email**: zibo@kth.se  
**Institution**: KTH Royal Institute of Technology

## License

BSD-3-Clause (see `LICENSE`).

## Troubleshooting

### Common Issues

1. **Missing Bessel functions**: Ensure Signal Processing Toolbox is installed
2. **Path errors**: Verify all files are in the correct directory structure
3. **Memory issues**: Reduce frequency range for large analyses
4. **Convergence problems**: Check material property values for physical consistency

### Support

For technical support or questions about the implementation, please contact the author at zibo@kth.se.

---

*Last updated: 2021-05-18*  
*Enhanced documentation: 2025-01-25*
