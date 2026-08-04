#==============================================================
# Synopsys IC Compiler II - Script 07: Routing
# File: 07_route.tcl
#==============================================================

source ../Script/01_setup.tcl

#--------------------------------------------------------------
# 7a. Global route options
#--------------------------------------------------------------

set_app_options -name route.global.timing_driven -value true
set_app_options -name route.global.crosstalk_driven -value false

#--------------------------------------------------------------
# 7b. Track assignment options
#--------------------------------------------------------------

set_app_options -name route.track.timing_driven -value true
set_app_options -name route.track.crosstalk_driven -value true

#--------------------------------------------------------------
# 7c. Detail route options
#--------------------------------------------------------------

set_app_options -name route.detail.timing_driven -value true
#set_app_options -name route.detail.save_after_iterations -value false
set_app_options -name route.detail.force_max_number_iterations -value false
set_app_options -name route.detail.antenna -value true
set_app_options -name route.detail.antenna_fixing_preference -value use_diodes
set_app_options -name route.detail.diode_libcell_names -value */ANTENNA_RVT

#--------------------------------------------------------------
# 7d. Atomic routing sequence
#--------------------------------------------------------------

route_global

route_track

route_detail

#--------------------------------------------------------------
# 7e. Post-route optimisation
#--------------------------------------------------------------

route_opt

#--------------------------------------------------------------
# 7f. Routing checks and reports
#--------------------------------------------------------------

check_routes \
    > $REPORTS_DIR/check_routes.rpt

report_timing -delay max -max_paths 10 \
    > $REPORTS_DIR/timing_post_route.rpt

report_timing -delay min -max_paths 10 \
    > $REPORTS_DIR/timing_hold_post_route.rpt

#--------------------------------------------------------------
# 7g. Write routed outputs
#--------------------------------------------------------------

write_verilog $OUTPUT_DIR/${DESIGN_NAME}.routed.v

write_sdc -output $OUTPUT_DIR/${DESIGN_NAME}.routed.sdc

write_parasitics \
    -format spef \
    -output $OUTPUT_DIR/${DESIGN_NAME}.spef

save_block
save_lib

puts "INFO: Routing complete."
