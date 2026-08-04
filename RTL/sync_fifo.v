//=========================================================
// Synchronous FIFO - Optimized for RTL-to-GDS
//=========================================================

module fifo #(
    parameter DEPTH     = 16,
    parameter WIDTH     = 8,
    parameter PTR_WIDTH = 4
)(
    input                     clk_i,
    input                     rst_i,

    // Write Interface
    input                     wr_en_i,
    input      [WIDTH-1:0]    wdata_i,

    // Read Interface
    input                     rd_en_i,

    output reg [WIDTH-1:0]    rdata_o,
    output reg                full_o,
    output reg                empty_o,
    output reg                wr_error_o,
    output reg                rd_error_o
);

    reg                       wr_toggle_f;
    reg                       rd_toggle_f;

    reg [PTR_WIDTH-1:0]       wr_ptr;
    reg [PTR_WIDTH-1:0]       rd_ptr;

    // Memory array (No reset logic allows clean RF/SRAM inference)
    reg [WIDTH-1:0]           mem [0:DEPTH-1];

    // Determine safe look-ahead status for writes and reads
    wire wr_valid = wr_en_i && !full_o;
    wire rd_valid = rd_en_i && !empty_o;

    //-----------------------------------------------------
    // FIFO Sequential Logic
    //-----------------------------------------------------
    always @(posedge clk_i) begin
        if (rst_i) begin
            wr_ptr      <= 0;
            rd_ptr      <= 0;
            wr_toggle_f <= 0;
            rd_toggle_f <= 0;
            rdata_o     <= 0;
            wr_error_o  <= 0;
            rd_error_o  <= 0;
            full_o      <= 1'b0;
            empty_o     <= 1'b1; // FIFO starts empty
        end
        else begin
            // Error Flags act as sticky pulses for single clock cycle
            wr_error_o <= wr_en_i && full_o;
            rd_error_o <= rd_en_i && empty_o;

            // Write Operation
            if (wr_valid) begin
                mem[wr_ptr] <= wdata_i;
                if (wr_ptr == DEPTH-1) begin
                    wr_ptr      <= 0;
                    wr_toggle_f <= ~wr_toggle_f;
                end
                else begin
                    wr_ptr      <= wr_ptr + 1'b1;
                end
            end

            // Read Operation
            if (rd_valid) begin
                rdata_o <= mem[rd_ptr];
                if (rd_ptr == DEPTH-1) begin
                    rd_ptr      <= 0;
                    rd_toggle_f <= ~rd_toggle_f;
                end
                else begin
                    rd_ptr      <= rd_ptr + 1'b1;
                end
            end

            //-----------------------------------------------------
            // Sequential Status Flag Generation (Avoids combo loops)
            //-----------------------------------------------------
            // Compute next pointer values for accurate status evaluation
            begin: status_update
                reg [PTR_WIDTH-1:0] next_wr_ptr;
                reg [PTR_WIDTH-1:0] next_rd_ptr;
                reg                 next_wr_toggle;
                reg                 next_rd_toggle;

                next_wr_ptr    = wr_valid ? ((wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1) : wr_ptr;
                next_wr_toggle = wr_valid ? ((wr_ptr == DEPTH-1) ? ~wr_toggle_f : wr_toggle_f) : wr_toggle_f;
                
                next_rd_ptr    = rd_valid ? ((rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1) : rd_ptr;
                next_rd_toggle = rd_valid ? ((rd_ptr == DEPTH-1) ? ~rd_toggle_f : rd_toggle_f) : rd_toggle_f;

                empty_o <= (next_wr_ptr == next_rd_ptr) && (next_wr_toggle == next_rd_toggle);
                full_o  <= (next_wr_ptr == next_rd_ptr) && (next_wr_toggle != next_rd_toggle);
            end

        end
    end

endmodule

