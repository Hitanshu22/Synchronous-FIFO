#==============================================================
# Synopsys IC Compiler II - Script 01: Setup & Environment
# File: 01_setup.tcl
#==============================================================

set DESIGN_NAME   "sync_fifo"

# Input files (from DC output)
set NETLIST_FILE  "/home/student/week_4/sync_fifo/Output/250Mhz/sync_fifo_mapped.vg"
set SDC_FILE      "/home/student/week_4/sync_fifo/Output/250Mhz/sync_fifo_mapped.sdc"

# PDK / library pathshome/student/week_4/sync_fifo/Output/250Mhz/sync_fifo_mapped.vg"
set PDK_PATH      "/home/student/week_4/sync_fifo/Workshop/ref"
set LIB_DIR       "$PDK_PATH/lib/stdcell_rvt"
set TECH_DIR      "$PDK_PATH/tech"

# Output directories
set OUTPUT_DIR    "./outputs"
set REPORTS_DIR   "./reports"

# Create output directories
file mkdir $OUTPUT_DIR
file mkdir $REPORTS_DIR

puts "INFO: Setup complete for design: $DESIGN_NAME"
