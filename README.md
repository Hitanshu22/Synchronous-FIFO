# fifo_sync – RTL to GDSII

This project demonstrates a complete **ASIC design flow** for a **Synchronous FIFO**, implemented using Verilog and taken through the **RTL to GDSII** flow using **Synopsys tools** such as Design Compiler, IC Compiler II, and PrimeTime.

---

## Project Overview

- **Design:** Synchronous FIFO (top module: `fifo_sync`)
- **Depth:** [FILL — e.g. 16]
- **Data Width:** [FILL — e.g. 8 bits]
- **Inputs:** wr_en_i, rd_en_i, data_in[WIDTH-1:0], CLK, reset
- **Outputs:** data_out[WIDTH-1:0], full, empty, wr_error_o, rd_error_o
- **RTL Language:** Verilog HDL
- **Toolchain:** Synopsys Design Compiler (DC), IC Compiler II (ICC2), PrimeTime (W-2024.09)
- **Flow:** RTL → Synthesis → Floorplan → Placement → CTS → Routing → GDSII + STA
- **Target Clock Period:** 4.00 ns (250 MHz)

---

## Functional Description

A synchronous FIFO buffers data between a write and a read interface that share the **same clock domain**. Data is pushed in on `wr_en` when the FIFO is not full, and popped out on `rd_en` when the FIFO is not empty. `full` and `empty` flags are derived from internal read/write pointers.

```verilog
// [FILL — paste your actual fifo_sync.v pointer/flag logic here]
always @(posedge clk or posedge rst) begin
  if (rst) begin
    wr_ptr <= 0;
    rd_ptr <= 0;
  end else begin
    if (wr_en && !full)  wr_ptr <= wr_ptr + 1;
    if (rd_en && !empty) rd_ptr <= rd_ptr + 1;
  end
end
```

---

## Changes Of Path & Library Done in Project

### Changes in path of (dc_script.tcl):

```
set DESIGN_NAME "fifo_sync"
set RTL_DIR "../RTL/"
set CONSTRAINTS_FILE "../Constraints/fifo_sync.sdc"

read_verilog [list
$RTL_DIR/fifo_sync.v
]

compile_ultra
```

---

### Gates Used (dc_script.tcl):

```
#set_dont_use [get_lib_cells /FADD]
#set_dont_use [get_lib_cells /HADD]
#set_dont_use [get_lib_cells /AO]
#set_dont_use [get_lib_cells /OA]
#set_dont_use [get_lib_cells /NAND]
#set_dont_use [get_lib_cells /XOR]
set_dont_use [get_lib_cells /NOR]
#set_dont_use [get_lib_cells /XNOR]
#set_dont_use [get_lib_cells /MUX]
```

---

### Library changes in "common_setup.tcl":

```
set target_library "../ref/lib/stdcell_rvt/saed32rvt_ss0p7vn40c.db"
set link_library "* ../ref/lib/stdcell_rvt/saed32rvt_ss0p7vn40c.db ../ref/lib/stdcell_rvt/saed32rvt_ff1p16v125c.db"
```

---

### Changes in CONSTRAINTS (fifo_sync.sdc):

```
create_clock -period 4.00 -name CLK [get_ports CLK]

set_clock_uncertainty 0.2 [get_clocks CLK]
set_clock_transition 0.1 [get_clocks CLK]

set_input_delay 1.0 -clock CLK [all_inputs]
set_output_delay 1.0 -clock CLK [all_outputs]
```

---

### Changes in path of (routing.tcl):

```
write -format verilog -hierarchy
-output ./outputs/fifo_sync_netlist.v

write_sdc ./outputs/fifo_sync.sdc
```

---

### Changes in path of Prime Time (STA):

```
set link_path "../ref/lib/stdcell_rvt/saed32rvt_ff1p16v125c.db"
read_verilog "../ICCII/outputs/fifo_sync.routed.v"
read_sdc "../ICCII/outputs/fifo_sync_final.sdc"
read_parasitics "../ICCII/outputs/fifo_sync_func::nom.spef.p1_125.spef"
```

---

## 📊 Results

*(from `qor_final.rpt`, `qor_post_place.rpt`, `power_final.rpt`, `timing_final_setup.rpt`, `timing_final_hold.rpt`, `clock_qor_final.rpt`)*

- **Cell Area (netlist):** 2002.91 µm²
  - Combinational Area: 1024.96 µm²
  - Noncombinational Area: 977.95 µm²
  - Buf/Inv Area: 141.81 µm²
- **Cell Count:** 560 leaf cells (412 combinational, 148 sequential)
- **Total Power:** ~4.50 mW
- **Worst Setup Slack (WNS):** 2.54 ns *(MET, no violating paths)*
- **Worst Hold Slack:** 0.02 ns *(MET, no violating paths)*
- **Total Negative Slack (Setup & Hold):** 0.00 ns
- **Clock Latency / Global Skew:** 0.05 ns / 0.02 ns
- **Clock Period:** 4.00 ns → **Clock Frequency:** 250 MHz
- **Routing DRCs:** 0 violations across 688 nets
- **Congestion:** 0.28% max overflow (H: 0.42%, V: 0.14%) — clean
- **Legality / Pin Placement:** `check_legality` and `check_pin_placement` both pass with 0 violations

---

## 📂 Project Structure

```
fifo_sync/
│── README.md
│
├── RTL/
│   ├── fifo_sync.v
│   └── fifo_sync_tb.v
│
├── Constraints/
│   └── fifo_sync.sdc
│
├── synthesis/
│   └── dc_script.tcl
│
├── physical_design/
│   ├── 01_setup.tcl
│   ├── 02_netlist_read.tcl
│   ├── 03_floorplan.tcl
│   ├── 04_powerplanning.tcl
│   ├── 05_placement.tcl
│   ├── 06_clock.tcl
│   ├── 07_route.tcl
│   └── 08_outputs.tcl
│
├── Outputs/
│   ├── synthesis_result.jpeg
│   ├── floorplan.jpeg
│   ├── Powerplanning_&_placement.jpeg
│   ├── Routing.jpg
│   ├── verdi_block_diagram.jpeg
│   ├── verdi_gate_level_schematic.jpeg
│   └── verdi_timing_waveform.jpeg
│
├── PD_reports/
│   ├── check_design_pre_place.rpt
│   ├── check_legality.rpt
│   ├── check_pin_placement.rpt
│   ├── check_routes.rpt
│   ├── clock_qor.rpt
│   ├── clock_qor_final.rpt
│   ├── clock_settings.rpt
│   ├── congestion.rpt
│   ├── pg_connectivity.rpt
│   ├── power_final.rpt
│   ├── qor_final.rpt
│   ├── qor_post_place.rpt
│   ├── timing_final_setup.rpt
│   ├── timing_final_hold.rpt
│   ├── timing_hold_post_cts.rpt
│   ├── timing_hold_post_route.rpt
│   ├── timing_post_cts.rpt
│   ├── timing_post_place.rpt
│   └── timing_post_route.rpt
│
└── Report_file/
    └── RTL_to_GDS_Report.pdf
```

---

## 🧠 Key Learnings

- RTL modelling of a synchronous FIFO using Verilog HDL
- Logic synthesis using Design Compiler
- Floorplanning and placement using ICC2
- Routing and physical verification
- Static Timing Analysis using PrimeTime

---

## 👨‍💻 Author

Hitanshu Parikh
