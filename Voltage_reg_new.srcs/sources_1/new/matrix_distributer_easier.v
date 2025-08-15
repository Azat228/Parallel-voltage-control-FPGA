`timescale 1ns / 1ps

module matrix_distributer_easier(
    input wire  mat,       
    input wire clk,             // Clock input
    output reg [9:0] arr       // 100-bit output
);

    integer i;
    reg [79:0] number = 79'b0000000000000000000000000000000000000000000000000000000000000000000000000000000;
    reg [79:0] PWM [9:0];       
    integer count_num= 0;
    integer j;
    integer i;
    integer k;
    integer m;
    always @(posedge clk) begin

            if (count_num < 10) begin
                for( i = 0;i<79;i = i+1)begin
                number[i] =mat;
                #1;
                end
               for(k = 0;k<79;k = k+1 )begin
                PWM[count_num][k]=number[k];
                PWM[count_num][79] = 1'b0;
               end

        
                count_num = count_num + 1;
                number = 0;
                
            end else begin

                for (m = 0;m<79;m = m+1) begin
                    #1; 
                    for( j = 0;j<10;j = j+1)begin
                    arr[j]<= PWM[j][m];
                    end
                end
             end
        end

endmodule