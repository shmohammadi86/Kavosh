# Kavosh - Network Motif Discovery Tool

A high-performance tool for discovering network motifs (recurring subgraph patterns) in complex networks using the nauty library for graph isomorphism testing [1](#1-0).

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Input Format](#input-format)
- [Output](#output)
- [Examples](#examples)
- [Algorithm](#algorithm)
- [Contributing](#contributing)
- [Notes](#notes)

## Overview

Kavosh systematically enumerates all connected subgraphs of a specified size within an input network and compares their frequencies against randomized null models to identify statistically significant motifs [2](#1-1).

## Prerequisites

- **C++ Compiler**: g++ with C++11 support  
- **Build System**: GNU Make  
- **Libraries**: nauty library (included in repository)  

## Installation

### Build from Source

1. Clone the repository:
```bash
git clone <repository-url>
cd Kavosh
````

2. Compile the project:

```bash
make
```

3. (Optional) Install to `../bin` directory:

```bash
make install
```

4. Clean build files:

```bash
make clean
```

> The build system automatically compiles both Kavosh source files and the required nauty library components (Makefile:14-27).

## Usage

### Basic Syntax

```bash
./Kavosh -i <input_file> -s <motif_size> [OPTIONS]
```

### Command-Line Options

| Option | Long Form | Required | Description                                                   |
| ------ | --------- | -------- | ------------------------------------------------------------- |
| -i     | --input   | Yes      | Input network file path                                       |
| -s     | --size    | Yes      | Size of motifs to discover (number of nodes)                  |
| -r     | --random  | No       | Number of random graphs for statistical analysis (default: 0) |
| -o     | --output  | No       | Output directory (default: "result")                          |
| -h     | --help    | No       | Display usage information                                     |

> Both input file (-i) and motif size (-s) are mandatory. The program will exit with an error message if either is missing (main.cpp:338-346).

## Input Format

The input file should contain the network in **edge list format**:

```
<number_of_vertices>
<vertex1> <vertex2>
<vertex1> <vertex3>
...
```

**Example:**

```
4
1 2
2 3
3 4
4 1
```

* First line: Total number of vertices in the network
* Subsequent lines: Edges as pairs of vertex IDs
* Self-loops (edges where source equals target) are automatically ignored (main.cpp:79-83)

## Output

### Standard Output

* Motif size and input file information
* Total number of enumerated subgraphs
* Execution time statistics
* Number of random graphs processed (if applicable)

### Output Files

Results are written to the specified output directory (default: `result/`):

* **Motif counts**: Classification results for discovered motifs
* **ZScore.txt**: Statistical significance analysis (when random graphs are used) (graph.cpp:509-533)

## Examples

### Basic Motif Discovery

```bash
./Kavosh -i networks/sample.txt -s 3
```

### Statistical Analysis

```bash
./Kavosh -i networks/social_network.txt -s 4 -r 100
```

### Custom Output Directory

```bash
./Kavosh -i networks/biological.txt -s 3 -r 50 -o my_results/
```

## Algorithm

Kavosh implements a recursive enumeration algorithm that:

* **Vertex-centered exploration**: Uses each vertex as a potential root for subgraph discovery (main.cpp:260-271)
* **Layer-by-layer enumeration**: Builds subgraphs recursively using depth-first search (main.cpp:128-206)
* **Graph isomorphism testing**: Classifies subgraphs using the nauty library for canonical labeling (graph.cpp:313-314)
* **Statistical analysis**: Computes Z-scores by comparing real network motif frequencies against randomized null models (graph.cpp:496-507)

### Performance Characteristics

* **Time complexity**: Depends on network structure and motif size
* **Memory usage**: Scales with maximum vertex degree and motif size
* **Optimization**: Uses Gray code enumeration for efficient combination generation

## Contributing

### Development Setup

1. Fork the repository
2. Create a feature branch:

```bash
git checkout -b feature/your-feature
```

3. Make your changes
4. Test the build:

```bash
make clean && make
```

5. Commit your changes:

```bash
git commit -m "Description of changes"
```

6. Push to your fork:

```bash
git push origin feature/your-feature
```

7. Create a Pull Request

### Code Structure

* `src/main.cpp`: Main program logic and command-line interface
* `src/graph.cpp`: Graph data structure and motif classification
* `src/ZeroOneTree.cpp`: Tree structure for motif counting
* `src/randomGenerator.cpp`: Random graph generation utilities
* `nauty/`: External nauty library for graph isomorphism testing

### License

[Include appropriate license information]

## Notes

This README provides comprehensive documentation based on the actual codebase structure and functionality. The build system uses standard Make with automatic dependency resolution [12](#1-11), and the algorithm implements sophisticated graph enumeration with statistical analysis capabilities for motif discovery in complex networks.

**Wiki pages you might want to explore:**

* [Getting Started (shmohammadi86/Kavosh)](/wiki/shmohammadi86/Kavosh#2)
* [Main Algorithm and Execution Flow (shmohammadi86/Kavosh)](/wiki/shmohammadi86/Kavosh#3)

> Documentation adapted by [SubaruDev0](https://github.com/SubaruDev0) for clarity and usage guidance.
