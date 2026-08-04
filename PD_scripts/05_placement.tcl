#==============================================================
# Synopsys IC Compiler II - Script 05: Placement
# File: 05_placement.tcl
#==============================================================

source ../Script/01_setup.tcl

#--------------------------------------------------------------
# 5a. Timing mode / corner / scenario setup
#--------------------------------------------------------------

set mode1     "func"
set corner1   "nom"
set scenario1 "${mode1}::${corner1}"

remove_modes -all
remove_corners -all
remove_scenarios -all

create_mode   $mode1
create_corner $corner1
create_scenario -name func::nom -mode func -corner nom

current_mode     func
current_scenario func::nom

# Load SDC
source $SDC_FILE

#--------------------------------------------------------------
# 5b. Parasitic technology
#--------------------------------------------------------------

set parasitic1 "p1"
set tluplus_file$parasitic1 "$PDK_PATH/tech/star_rcxt/saed32nm_1p9m_Cmax.tluplus"
set layer_map_file$parasitic1 "$PDK_PATH/tech/star_rcxt/saed32nm_tf_itf_tluplus.map"

set parasitic2 "p2"
set tluplus_file$parasitic2 "$PDK_PATH/tech/star_rcxt/saed32nm_1p9m_Cmin.tluplus"
set layer_map_file$parasitic2 "$PDK_PATH/tech/star_rcxt/saed32nm_tf_itf_tluplus.map"

read_parasitic_tech -tlup $tluplus_filep1 -layermap $layer_map_filep1 -name p1
read_parasitic_tech -tlup $tluplus_filep2 -layermap $layer_map_filep2 -name p2

set_parasitic_parameters -late_spec $parasitic1 -early_spec $parasitic2

#--------------------------------------------------------------
# 5c. Placement app options
#--------------------------------------------------------------

set_app_options -name place.coarse.continue_on_missing_scandef -value true

#--------------------------------------------------------------
# 5d. Run placement
#--------------------------------------------------------------

place_pins -self
place_opt
legalize_placement

#--------------------------------------------------------------
# 5e. Reports
#--------------------------------------------------------------

check_legality -verbose \
    > $REPORTS_DIR/check_legality.rpt

report_timing -delay max -max_paths 10 \
    > $REPORTS_DIR/timing_post_place.rpt

report_qor -summary \
    > $REPORTS_DIR/qor_post_place.rpt

save_block -as full_adder_placement
save_lib

puts "INFO: Placement complete."
