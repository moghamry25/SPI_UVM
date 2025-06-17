# SPI_UVM
## 🚀 Key Features

- ✅ UVM-based modular testbench architecture
- ✅ Reusable UVM agents for RAM and SPI slave
- ✅ Functional coverage for individual components and system integration
- ✅ Golden reference models for checking DUT behavior
- ✅ Layered sequences and constrained-random stimulus
- ✅ Assertion-based checks for protocol correctness

## 📈 Functional Coverage

Functional coverage was written for:
- **RAM interface signals** (read/write/enable)
- **SPI protocol** (command decoding, data transfer, edge handling)
- **Wrapper behavior** (combined transaction coverage, integration flow)

## 🧪 Reference Models

Golden models were developed for:
- `RAM`
- `SPI Slave`
- `Wrapper (system level)`
These models ensure the DUT output matches the expected behavior under all test conditions.

## 🛠️ How to Run

### Requirements
- SystemVerilog Simulator (e.g., **QuestaSim**)
- UVM Library (1.2 or compatible)

