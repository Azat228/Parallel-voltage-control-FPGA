`timescale 1ns / 1ps

module pin_control(
    input wire [50000:0] mat,       
    input wire clk,             // Clock input
    output reg [99:0] arr       // 100-bit output
);

    integer i;
    reg [500:0] number = 500'b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    reg [500:0] PWM [99:0];       
    integer count_num= 0;
    integer j;
    integer i;
    integer k;
    integer m;
    always @(posedge clk) begin

            if (count_num < 100) begin
                for( i = 0;i<500;i = i+1)begin
                number[i] =(mat[i+(count_num*500)]); // Take the 8-bit input
                end
               for(k = 0;k<500;k = k+1 )begin
                PWM[count_num][k]=number[k];
                PWM[count_num][500] = 1'b0;
               end

        
                count_num = count_num + 1;
                number = 0;
                
            end else begin

                for (m = 0;m<500;m = m+1) begin
                    #1; 
                    for( j = 0;j<100;j = j+1)begin
                    arr[j]<= PWM[j][m];
                    end
                end
             end
        end

endmodule