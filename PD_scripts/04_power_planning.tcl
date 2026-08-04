#==============================================================
# Synopsys IC Compiler II - Script 04: Power Planning
# File: 04_power_planning.tcl
#==============================================================

source ../Script/01_setup.tcl

#--------------------------------------------------------------
# 4a. Create and connect power / ground nets
#--------------------------------------------------------------

create_net -power {VDD}
create_net -ground {VSS}

connect_pg_net -all_blocks -automatic

#--------------------------------------------------------------
# 4b. Power / ground rings
#--------------------------------------------------------------

create_pg_ring_pattern core_ring_pattern -horizontal_layer M7 -horizontal_width .4 -horizontal_spacing .3 -vertical_layer M8 -vertical_width .4 -vertical_spacing .3

set_pg_strategy core_power_ring -core -pattern {{name : core_ring_pattern}{nets : {VDD VSS}}{offset : {.5 .5}}}

compile_pg -strategies core_power_ring

#--------------------------------------------------------------
# 4c. Power mesh
#--------------------------------------------------------------

create_pg_mesh_pattern mesh -layers { {{vertical_layer: M6}{width: .34} {spacing: interleaving}{pitch: 5} {offset: .5}} {{horizontal_layer: M7}{width: .38} {spacing: interleaving} {pitch: 5} {offset: .5}} {{vertical_layer: M8}{width: .38} {spacing: interleaving}{pitch: 5} {offset: .5}}}

set_pg_strategy core_mesh -pattern { {pattern:mesh} {nets: VDD VSS}} -core -extension {stop: innermost_ring}

compile_pg -strategies core_mesh

#--------------------------------------------------------------
# 4d. Standard-cell power rails
#--------------------------------------------------------------

create_pg_std_cell_conn_pattern std_cell_rail -layers {M1} -rail_width 0.06

set_pg_strategy rail_strat -core -pattern {{name: std_cell_rail} {nets: VDD VSS} }

compile_pg -strategies rail_strat

#--------------------------------------------------------------
# 4e. Connectivity check
#--------------------------------------------------------------

check_pg_connectivity \
    > $REPORTS_DIR/pg_connectivity.rpt

save_block
save_lib

puts "INFO: Power planning complete."
