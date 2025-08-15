module Matrix_Distributor #(
    // AXI parameters
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 12,
    
    // Matrix configuration parameters
    parameter MATRIX_SIZE = 10,
    parameter MAX_MATRICES = 10,
    parameter BITS_PER_ELEMENT = 8,
    parameter NUM_ROWS = 1
)(
    // System clock and reset signals
    input wire sys_clk,
    input wire sys_rst_n,
    
    // AXI Lite signals
    input wire s_axi_aclk,
    input wire s_axi_aresetn,
    
    // AXI write address channel
    input wire [C_S_AXI_ADDR_WIDTH-1:0] s_axi_awaddr,
    input wire [2:0] s_axi_awprot,
    input wire s_axi_awvalid,
    output reg s_axi_awready,
    
    // AXI write data channel
    input wire [C_S_AXI_DATA_WIDTH-1:0] s_axi_wdata,
    input wire [(C_S_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb,
    input wire s_axi_wvalid,
    output reg s_axi_wready,
    
    // AXI write response channel
    output reg [1:0] s_axi_bresp,
    output reg s_axi_bvalid,
    input wire s_axi_bready,
    
    // AXI read address channel
    input wire [C_S_AXI_ADDR_WIDTH-1:0] s_axi_araddr,
    input wire [2:0] s_axi_arprot,
    input wire s_axi_arvalid,
    output reg s_axi_arready,
    
    // AXI read data channel
    output reg [C_S_AXI_DATA_WIDTH-1:0] s_axi_rdata,
    output reg [1:0] s_axi_rresp,
    output reg s_axi_rvalid,
    input wire s_axi_rready,
    
    // PMOD outputs for serial data
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

    // Constants
    localparam [1:0] AXI_RESP_OK = 2'b00;
    localparam [1:0] AXI_RESP_ERROR = 2'b10;

    // State machine states
    localparam IDLE = 2'b00;
    localparam DISTRIBUTE = 2'b01;

    // State registers
    reg [1:0] state;

    // Matrix data storage
    reg [7:0] matrix_decimal[MAX_MATRICES-1:0][MATRIX_SIZE*NUM_ROWS-1:0];
    reg [31:0] matrix_count;

    // Control signals
    reg matrix_output_enable;
    reg [31:0] ctrl_reg;
    reg [31:0] status_reg;

    // Current row, column, and bit being processed
    reg [31:0] current_row;
    reg [31:0] current_col;
    reg [BITS_PER_ELEMENT-1:0] current_bit;

    // Serial output control
    reg [MAX_MATRICES-1:0] serial_out;

    // Internal AXI signals
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_awaddr_reg;
    reg [C_S_AXI_ADDR_WIDTH-1:0] axi_araddr_reg;

    // Initialize signals
    integer i, idx;

    initial begin
        state = IDLE;
        matrix_output_enable = 0;
        matrix_count = 0;
        ctrl_reg = 0;
        status_reg = 0;
        current_row = 0;
        current_col = 0;
        current_bit = BITS_PER_ELEMENT-1;

        for (i = 0; i < MAX_MATRICES; i = i + 1) begin
            for (idx = 0; idx < MATRIX_SIZE*NUM_ROWS; idx = idx + 1) begin
                matrix_decimal[i][idx] = 0;
            end
        end
    end

    // AXI write address channel handling
    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            s_axi_awready <= 0;
            axi_awaddr_reg <= 0;
        end else begin
            if (!s_axi_awready && s_axi_awvalid && s_axi_wvalid && !s_axi_bvalid) begin
                s_axi_awready <= 1;
                axi_awaddr_reg <= s_axi_awaddr;
            end else begin
                s_axi_awready <= 0;
            end
        end
    end

    // AXI write data channel handling
    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            s_axi_wready <= 0;
            s_axi_bvalid <= 0;
            s_axi_bresp <= AXI_RESP_OK;
            ctrl_reg <= 0;
            matrix_count <= 0;
        end else begin
            if (s_axi_bvalid && s_axi_bready) begin
                s_axi_bvalid <= 0;
            end

            if (!s_axi_wready && s_axi_wvalid && s_axi_awvalid && !s_axi_awready && !s_axi_bvalid) begin
                s_axi_wready <= 1;

                // Handle control register writes
                if (axi_awaddr_reg[11:2] == 0) begin
                    if (s_axi_wstrb[0]) ctrl_reg[7:0] <= s_axi_wdata[7:0];
                    if (s_axi_wstrb[1]) ctrl_reg[15:8] <= s_axi_wdata[15:8];
                    if (s_axi_wstrb[2]) ctrl_reg[23:16] <= s_axi_wdata[23:16];
                    if (s_axi_wstrb[3]) ctrl_reg[31:24] <= s_axi_wdata[31:24];
                end

                s_axi_bvalid <= 1;
                s_axi_bresp <= AXI_RESP_OK;
            end else begin
                s_axi_wready <= 0;
            end
        end
    end

    // AXI read address channel handling
    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            s_axi_arready <= 0;
            axi_araddr_reg <= 0;
        end else begin
            if (!s_axi_arready && s_axi_arvalid && !s_axi_rvalid) begin
                s_axi_arready <= 1;
                axi_araddr_reg <= s_axi_araddr;
            end else begin
                s_axi_arready <= 0;
            end
        end
    end

    // AXI read data channel handling
    always @(posedge s_axi_aclk or negedge s_axi_aresetn) begin
        if (!s_axi_aresetn) begin
            s_axi_rvalid <= 0;
            s_axi_rdata <= 0;
            s_axi_rresp <= AXI_RESP_OK;
        end else begin
            if (s_axi_rvalid && s_axi_rready) begin
                s_axi_rvalid <= 0;
            end

            if (s_axi_arready && s_axi_arvalid && !s_axi_rvalid) begin
                // Read control register
                if (axi_araddr_reg[11:2] == 0) begin
                    s_axi_rdata <= ctrl_reg;
                end

                s_axi_rvalid <= 1;
                s_axi_rresp <= AXI_RESP_OK;
            end
        end
    end

    // State machine for matrix distribution
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            state <= IDLE;
            matrix_output_enable <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (ctrl_reg[0] && matrix_count > 0) begin
                        state <= DISTRIBUTE;
                        matrix_output_enable <= 1;
                        current_row <= 0;
                        current_col <= 0;
                        current_bit <= BITS_PER_ELEMENT-1;
                    end
                end
                DISTRIBUTE: begin
                    if (!ctrl_reg[0]) begin
                        state <= IDLE;
                        matrix_output_enable <= 0;
                    end else begin
                        if (current_bit > 0) begin
                            current_bit <= current_bit - 1;
                        end else begin
                            current_bit <= BITS_PER_ELEMENT-1;
                            if (current_col < MATRIX_SIZE-1) begin
                                current_col <= current_col + 1;
                            end else begin
                                current_col <= 0;
                                if (current_row < NUM_ROWS-1) begin
                                    current_row <= current_row + 1;
                                end else begin
                                    current_row <= 0;
                                end
                            end
                        end
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Serialize matrix data to PMOD outputs
    always @(posedge sys_clk or negedge sys_rst_n) begin
        if (!sys_rst_n) begin
            serial_out <= 0;
        end else if (matrix_output_enable) begin
            for (i = 0; i < MAX_MATRICES; i = i + 1) begin
                serial_out[i] <= matrix_decimal[i][current_row * MATRIX_SIZE + current_col][current_bit];
            end
        end else begin
            serial_out <= 0;
        end
    end

    // Map serial_out to PMOD outputs
    always @* begin
        pmod_out_0 = serial_out[0];
        pmod_out_1 = serial_out[1];
        pmod_out_2 = serial_out[2];
        pmod_out_3 = serial_out[3];
        pmod_out_4 = serial_out[4];
        pmod_out_5 = serial_out[5];
        pmod_out_6 = serial_out[6];
        pmod_out_7 = serial_out[7];
        pmod_out_8 = serial_out[8];
        pmod_out_9 = serial_out[9];
    end

endmodule