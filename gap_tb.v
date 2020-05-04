//`timescale 1 ns/ 1 ps
module gap_tb();
reg clk;
reg [31:0] data;
reg rst;                                          
wire [4:0]  gap;                        
gap i1 (  
	.clk(clk),
	.data(data),
	.gap(gap),
	.rst(rst)
);
initial                                                
begin                                                                           
rst=1;
clk=0;
#10 rst=0; data=32'b1111_1111_1111_1111_1111_1111_1111_1111; 
#640 rst=1; data=32'b1111_1111_1111_1111_0111_1111_1011_1111; 
#10 rst=0;
#640 rst=1; data=32'b0101_1001_1110_1011_1111_1011_1000_1110; 
#10 rst=0;                                          
$display("Running testbench");                       
end  
                                                  
always #20 clk=~clk;       
                                         
endmodule
