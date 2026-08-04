create_clock -name CLK -period 4.0 [get_ports clk_i]

set_clock_uncertainty 0.2 [get_clocks CLK]

set_clock_transition 0.2 [get_clocks CLK]

set_input_delay 1.0 -clock CLK \
    [get_ports {rst_i wr_en_i rd_en_i wdata_i[*]}]

set_output_delay 1.0 -clock CLK \
    [get_ports {rdata_o[*] full_o empty_o wr_error_o rd_error_o}]

set_driving_cell \
    -lib_cell BUFX2 \
    [remove_from_collection [all_inputs] [get_ports clk_i]]

set_load 0.15 [all_outputs]

