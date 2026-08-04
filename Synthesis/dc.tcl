##################################################
# Setup
##################################################

set project_path /home/student/prac
set_app_var search_path [list . $project_path/Design \
                       /home/student/prac/Workshop/ref/lib/ndm
]
set_app_var target_library "/home/student/prac/Workshop/ref/lib/stdcell_rvt/saed32rvt_ss0p7vn40c.db"
set_app_var link_library "* /home/student/prac/Workshop/ref/lib/stdcell_rvt/saed32rvt_ss0p7vn40c.db"

##################################################
# Read RTL
##################################################

analyze -format verilog /home/student/prac/Design/fifo.v
elaborate fifo

current_design fifo
link

##################################################
# Read Constraints
##################################################

source /home/student/prac/Design/fifo.sdc

##################################################
# Design Checks
##################################################

check_design
check_timing

##################################################
# Compile
##################################################

compile_ultra

##################################################
# Reports
##################################################

report_area > /home/student/prac/Report/report_area.rpt
report_power > /home/student/prac/Report/report_power.rpt
report_timing > /home/student/prac/Report/report_timing.rpt
report_qor > /home/student/prac/Report/report_qor.rpt
report_constraints > /home/student/prac/Report/report_constraints.rpt

##################################################
# Output Files
##################################################

write_file -format verilog -output /home/student/prac/Output/fifo_mapped.vg

write_sdc /home/student/prac/Output/fifo_mapped.sdc

##################################################
# Exit
##################################################

#exit

