`timescale 1ns / 1ps

module Matrix_Distributor #(
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 12,
    parameter MATRIX_SIZE = 10,
    parameter MAX_MATRICES = 10,
    parameter BITS_PER_ELEMENT = 8
)(
    // System clock and reset
    input wire sys_clk,
    input wire sys_rst_n,
    
    // AXI Lite interface
    input wire s_axi_aclk,
    input wire s_axi_aresetn,
    input wire [C_S_AXI_ADDR_WIDTH-1:0] s_axi_awaddr,
    input wire [2:0] s_axi_awprot,
    input wire s_axi_awvalid,
    output reg s_axi_awready,
    input wire [C_S_AXI_DATA_WIDTH-1:0] s_axi_wdata,
    input wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
    input wire s_axi_wvalid,
    output reg s_axi_wready,
    output reg [1:0] s_axi_bresp,
    output reg s_axi_bvalid,
    input wire s_axi_bready,
    input wire [C_S_AXI_ADDR_WIDTH-1:0] s_axi_araddr,
    input wire [2:0] s_axi_arprot,
    input wire s_axi_arvalid,
    output reg s_axi_arready,
    output reg [C_S_AXI_DATA_WIDTH-1:0] s_axi_rdata,
    output reg [1:0] s_axi_rresp,
    output reg s_axi_rvalid,
    input wire s_axi_rready,

    // PMOD outputs
    output reg pmod_out_0,
    output reg pmod_out_1,
    output reg pmod_out_2,
    output reg pmod_out_3,
    output reg pmod_out_4,
    output reg pmod_out_5,
    output reg pmod_out_6,
    output reg pmod_out_7,
    output reg pmod_out_8,
    output reg pmod_out_9
);

// AXI response codes
localparam [1:0] AXI_RESP_OK = 2'b00;
localparam [1:0] AXI_RESP_ERROR = 2'b10;

// Type definitions
reg [7:0] matrix_decimal[MAX_MATRICES-1:0][MATRIX_SIZE*MATRIX_SIZE-1:0];
integer matrix_count = 0;

// State machine states
localparam IDLE = 1'b0;
localparam DISTRIBUTE = 1'b1;
reg state = IDLE;

// Control and status registers
reg [31:0] ctrl_reg = 32'b0;
reg [31:0] status_reg = 32'b0;

// Matrix output control signals
reg matrix_output_enable = 1'b0;
integer current_row = 0;
integer current_col = 0;
integer current_bit = BITS_PER_ELEMENT - 1;

// Serial output signal for each matrix
reg [MAX_MATRICES-1:0] serial_out = {MAX_MATRICES{1'b0}};

// AXI control signals
reg [C_S_AXI_ADDR_WIDTH-1:0] axi_awaddr_reg;
reg [C_S_AXI_ADDR_WIDTH-1:0] axi_araddr_reg;

// AXI write address channel
always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
        s_axi_awready <= 1'b0;
        axi_awaddr_reg <= {C_S_AXI_ADDR_WIDTH{1'b0}};
    end else if (!s_axi_awready && s_axi_awvalid && s_axi_wvalid && !s_axi_bvalid) begin
        s_axi_awready <= 1'b1;
        axi_awaddr_reg <= s_axi_awaddr;
    end else begin
        s_axi_awready <= 1'b0;
    end
end

// AXI write data channel
always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
        s_axi_wready <= 1'b0;
        s_axi_bvalid <= 1'b0;
        s_axi_bresp <= AXI_RESP_OK;
        matrix_count <= 0;
        ctrl_reg <= 32'b0;
        
        // Initialize matrix data
        integer i, idx;
        for (i = 0; i < MAX_MATRICES; i = i + 1) begin
            for (idx = 0; idx < MATRIX_SIZE*MATRIX_SIZE; idx = idx + 1) begin
                matrix_decimal[i][idx] <= 8'b0;
            end
        end
    end else begin
        if (s_axi_bvalid && s_axi_bready) begin
            s_axi_bvalid <= 1'b0;
        end
        
        if (!s_axi_wready && s_axi_wvalid && s_axi_awvalid && !s_axi_awready && !s_axi_bvalid) begin
            s_axi_wready <= 1'b1;
            
            // Address decoding
            integer matrix_idx, row_idx, col_idx, index, addr_offset;
            addr_offset = s_axi_awaddr[11:2];
            
            if (addr_offset == 0) begin
                // Control register (0x00)
                if (s_axi_wstrb[0]) ctrl_reg[7:0] <= s_axi_wdata[7:0];
                if (s_axi_wstrb[1]) ctrl_reg[15:8] <= s_axi_wdata[15:8];
                if (s_axi_wstrb[2]) ctrl_reg[23:16] <= s_axi_wdata[23:16];
                if (s_axi_wstrb[3]) ctrl_reg[31:24] <= s_axi_wdata[31:24];
            end else if (addr_offset == 1) begin
                // Status register is read-only
            end else begin
                // Matrix data
                matrix_idx = s_axi_awaddr[11:7];
                row_idx = s_axi_awaddr[6:4];
                col_idx = s_axi_awaddr[3:2];
                
                if (matrix_idx < MAX_MATRICES && row_idx < MATRIX_SIZE && col_idx * 4 < MATRIX_SIZE) begin
                    if (s_axi_wstrb[0] && col_idx * 4 < MATRIX_SIZE) begin
                        index = row_idx * MATRIX_SIZE + col_idx * 4;
                        matrix_decimal[matrix_idx][index] <= s_axi_wdata[7:0];
                    end
                    if (s_axi_wstrb[1] && col_idx * 4 + 1 < MATRIX_SIZE) begin
                        index = row_idx * MATRIX_SIZE + col_idx * 4 + 1;
                        matrix_decimal[matrix_idx][index] <= s_axi_wdata[15:8];
                    end
                    if (s_axi_wstrb[2] && col_idx * 4 + 2 < MATRIX_SIZE) begin
                        index = row_idx * MATRIX_SIZE + col_idx * 4 + 2;
                        matrix_decimal[matrix_idx][index] <= s_axi_wdata[23:16];
                    end
                    if (s_axi_wstrb[3] && col_idx * 4 + 3 < MATRIX_SIZE) begin
                        index = row_idx * MATRIX_SIZE + col_idx * 4 + 3;
                        matrix_decimal[matrix_idx][index] <= s_axi_wdata[31:24];
                    end
                    
                    if (matrix_idx >= matrix_count) begin
                        matrix_count <= matrix_idx + 1;
                    end
                end
            end
            
            s_axi_bresp <= AXI_RESP_OK;
            s_axi_bvalid <= 1'b1;
        end else begin
            s_axi_wready <= 1'b0;
        end
    end
end

// AXI read address channel
always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
        s_axi_arready <= 1'b0;
        axi_araddr_reg <= {C_S_AXI_ADDR_WIDTH{1'b0}};
    end else if (!s_axi_arready && s_axi_arvalid && !s_axi_rvalid) begin
        s_axi_arready <= 1'b1;
        axi_araddr_reg <= s_axi_araddr;
    end else begin
        s_axi_arready <= 1'b0;
    end
end

// AXI read data channel
always @(posedge s_axi_aclk) begin
    if (!s_axi_aresetn) begin
        s_axi_rvalid <= 1'b0;
        s_axi_rdata <= {C_S_AXI_DATA_WIDTH{1'b0}};
        s_axi_rresp <= AXI_RESP_OK;
    end else if (s_axi_rvalid && s_axi_rready) begin
        s_axi_rvalid <= 1'b0;
    end else if (s_axi_arready && s_axi_arvalid && !s_axi_rvalid) begin
        // Address decoding
        integer matrix_idx, row_idx, col_idx, index, addr_offset;
        addr_offset = axi_araddr_reg[11:2];
        
        if (addr_offset == 0) begin
            // Control register (0x00)
            s_axi_rdata <= ctrl_reg;
        end else if (addr_offset == 1) begin
            // Status register (0x04)
            s_axi_rdata <= 32'b0;
            s_axi_rdata[23:16] <= (state == IDLE) ? 8'h00 : 8'h02;
            s_axi_rdata[15:8] <= current_row[7:0];
            s_axi_rdata[7:0] <= current_col[7:0];
        end else begin
            // Matrix data
            matrix_idx = axi_araddr_reg[11:7];
            row_idx = axi_araddr_reg[6:4];
            col_idx = axi_araddr_reg[3:2];
            
            if (matrix_idx < MAX_MATRICES && row_idx < MATRIX_SIZE) begin
                s_axi_rdata <= {C_S_AXI_DATA_WIDTH{1'b0}};
                
                if (col_idx * 4 < MATRIX_SIZE) begin
                    index = row_idx * MATRIX_SIZE + col_idx * 4;
                    s_axi_rdata[7:0] <= matrix_decimal[matrix_idx][index];
                end
                if (col_idx * 4 + 1 < MATRIX_SIZE) begin
                    index = row_idx * MATRIX_SIZE + col_idx * 4 + 1;
                    s_axi_rdata[15:8] <= matrix_decimal[matrix_idx][index];
                end
                if (col_idx * 4 + 2 < MATRIX_SIZE) begin
                    index = row_idx * MATRIX_SIZE + col_idx * 4 + 2;
                    s_axi_rdata[23:16] <= matrix_decimal[matrix_idx][index];
                end
                if (col_idx * 4 + 3 < MATRIX_SIZE) begin
                    index = row_idx * MATRIX_SIZE + col_idx * 4 + 3;
                    s_axi_rdata[31:24] <= matrix_decimal[matrix_idx][index];
                end
            end
        end
        
        s_axi_rresp <= AXI_RESP_OK;
        s_axi_rvalid <= 1'b1;
    end
end

// Main state machine
always @(posedge sys_clk) begin
    if (!sys_rst_n) begin
        state <= IDLE;
        matrix_output_enable <= 1'b0;
        current_row <= 0;
        current_col <= 0;
        current_bit <= BITS_PER_ELEMENT - 1;
    end else begin
        case (state)
            IDLE: begin
                if (ctrl_reg[0] && matrix_count > 0) begin
                    state <= DISTRIBUTE;
                    matrix_output_enable <= 1'b1;
                    current_row <= 0;
                    current_col <= 0;
                    current_bit <= BITS_PER_ELEMENT - 1;
                end
            end
            DISTRIBUTE: begin
                if (!ctrl_reg[0]) begin
                    state <= IDLE;
                    matrix_output_enable <= 1'b0;
                end else begin
                    if (current_bit > 0) begin
                        current_bit <= current_bit - 1;
                    end else begin
                        current_bit <= BITS_PER_ELEMENT - 1;
                        if (current_col < MATRIX_SIZE - 1) begin
                            current_col <= current_col + 1;
                        end else begin
                            current_col <= 0;
                            if (current_row < MATRIX_SIZE - 1) begin
                                current_row <= current_row + 1;
                            end else begin
                                current_row <= 0;
                            end
                        end
                    end
                end
            end
        endcase
    end
end

// Serial output to PMOD
always @(posedge sys_clk) begin
    if (!sys_rst_n) begin
        serial_out <= {MAX_MATRICES{1'b0}};
    end else if (matrix_output_enable) begin
        integer index, i;
        reg [BITS_PER_ELEMENT-1:0] temp_vector;
        index = current_row * MATRIX_SIZE + current_col;
        
        for (i = 0; i < MAX_MATRICES; i = i + 1) begin
            if (i < matrix_count) begin
                temp_vector = matrix_decimal[i][index];
                serial_out[i] <= temp_vector[current_bit];
            end else begin
                serial_out[i] <= 1'b0;
            end
        end
    end else begin
        serial_out <= {MAX_MATRICES{1'b0}};
    end
end

// PMOD output mapping
assign pmod_out_0 = serial_out[0];
assign pmod_out_1 = serial_out[1];
assign pmod_out_2 = serial_out[2];
assign pmod_out_3 = serial_out[3];
assign pmod_out_4 = serial_out[4];
assign pmod_out_5 = serial_out[5];
assign pmod_out_6 = serial_out[6];
assign pmod_out_7 = serial_out[7];
assign pmod_out_8 = serial_out[8];
assign pmod_out_9 = serial_out[9];

endmodule