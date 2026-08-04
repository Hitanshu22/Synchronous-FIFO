#==============================================================
# Synopsys IC Compiler II - Script 08: Signoff & Outputs
# File: 08_signoff_outputs.tcl
#==============================================================

source ../Script/01_setup.tcl

#--------------------------------------------------------------
# 8a. Legality check
#--------------------------------------------------------------

check_legality \
    > $REPORTS_DIR/check_legality.rpt

#--------------------------------------------------------------
# 8b. Final timing, QoR, and physical reports
#--------------------------------------------------------------

report_timing -delay max -max_paths 20 -input_pins \
    > $REPORTS_DIR/timing_final_setup.rpt

report_timing -delay min -max_paths 20 -input_pins \
    > $REPORTS_DIR/timing_final_hold.rpt

report_qor \
    > $REPORTS_DIR/qor_final.rpt

report_power -hierarchy \
    > $REPORTS_DIR/power_final.rpt

report_congestion \
    > $REPORTS_DIR/congestion.rpt

report_clock_qor -summary \
    > $REPORTS_DIR/clock_qor_final.rpt

#--------------------------------------------------------------
# 8c. Write final output files
#--------------------------------------------------------------

# Final gate-level netlist
write_verilog \
    -exclude {pg_objects} \
    $OUTPUT_DIR/${DESIGN_NAME}_final.v

# DEF
write_def \
    $OUTPUT_DIR/${DESIGN_NAME}_final.def

# GDS
write_gds \
    $OUTPUT_DIR/${DESIGN_NAME}.gds

# SPEF (parasitics for signoff STA)
write_parasitics \
    -format spef \
    -output $OUTPUT_DIR/${DESIGN_NAME}_final.spef

# SDC
write_sdc -output $OUTPUT_DIR/${DESIGN_NAME}_final.sdc

#--------------------------------------------------------------
# 8d. Final save
#--------------------------------------------------------------
save_block
save_lib

puts "=========================================="
puts " ICC2 PnR COMPLETE: $DESIGN_NAME"
puts "=========================================="
