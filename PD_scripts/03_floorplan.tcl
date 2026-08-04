#==============================================================
# Synopsys IC Compiler II - Script 03: Floorplan
# File: 03_floorplan.tcl
#==============================================================

source ../Script/01_setup.tcl

#--------------------------------------------------------------
# 3a.Floorplan
#--------------------------------------------------------------

#scenario1:
#initialize_floorplan -core_offset 1
#set_individual_pin_constraints -ports [get_ports] -sides 3
#place_pins -self
#create_placement -floorplan

#scenario2:
#initialize_floorplan -side_ratio {1.5 1} -core_offset 1
#set_individual_pin_constraints -ports [get_ports A] -sides 2
#place_pins -self
#create_placement -floorplan -effort very_low 

#scenario3:
#initialize_floorplan -shape L -core_offset 2 -coincident_boundary
#set_individual_pin_constraints -ports [get_ports {A B}] -sides 6
#place_pins -self
#create_placement -floorplan  -effort medium

#scenario4:

initialize_floorplan \
    -core_utilization 0.60 \
    -core_offset {3 3} \
    -coincident_boundary false

# Input pins
set_individual_pin_constraints \
    -ports [get_ports {clk_i rst_i wr_en_i rd_en_i wdata_i}] \
    -sides {1 4} \
    -pin_spacing_distance 2

# Output pins
set_individual_pin_constraints \
    -ports [get_ports {rdata_o full_o empty_o wr_error_o rd_error_o}] \
    -sides 3 \
    -pin_spacing_distance 2

place_pins -self

create_placement \
    -floorplan \
    -effort high

#scenario5:
#initialize_floorplan -shape L -control_type die  -side_length {20 30 20 20} -core_offset {5}
#set_individual_pin_constraints -ports [get_ports Clock] -exclude_sides {1 2 3 4 5}
#place_pins -self
#create_placement -floorplan  -effort low

#scenario6:
#initialize_floorplan -control_type core -shape T -orientation N -core_offset 5 -side_length {12 6 21 12 21 6}
#set_individual_pin_constraints -ports [get_ports C_in] -location {6 12}
#place_pins -self
#create_placement -floorplan -effort high

#scenario7:
#initialize_floorplan -core_utilization 0.5 -shape T -orientation S -core_offset 2 -flip_first_row true
#set_individual_pin_constraints -offset {1 20} -sides 8 -ports [get_ports] -pin_spacing_distance 3
#place_pins -self
#create_placement -floorplan

#scenario8:
#initialize_floorplan -core_utilization 0.6 -coincident_boundary true -core_offset {1 2} -shape U -orientation E
#set_individual_pin_constraints -ports [get_ports {A[0] B[1]}] -sides 6
#place_pins -self
#create_placement -floorplan -effort medium

#scenario9:
#initialize_floorplan
#create_placement_blockage -boundary {{1 1} {2 2}}
#place_pins -self
#create_placement -floorplan

#scenario10:
#initialize_floorplan -core_utilization 0.6 -coincident_boundary false -core_offset {1 2} -shape U -orientation W
#create_placement_blockage -type hard -boundary {{4 4} {4 6} {6 6} {6 4}}
#place_pins -self
#create_placement -floorplan

check_pin_placement \
    > $REPORTS_DIR/check_pin_placement.rpt

# save the block and lib
save_block -as FULL_ADDER
save_lib

puts "INFO: Floorplan complete."
