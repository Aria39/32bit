module gap(data,clk,rst,gap);

input clk,rst;
input [31:0] data;
output [4:0] gap;


reg [4:0] gap,tmp,k;
reg flush_tmp,store_tmp,incr_k,incr_tmp;
parameter s_idle=0,s_1=1,s_2=2,s_done=3;
reg[1:0] state,next_state;
wire Bit=data[k];

always @(posedge clk,posedge rst)
	if(rst)
		state<=s_idle;
	else 
		state<=next_state;
		
always @(state or Bit or k)
	begin
	next_state=state;
	incr_tmp=0;
	incr_k=0;
	store_tmp=0;
	flush_tmp=0;
	
		case(state)
			s_idle : if(k==31) next_state=s_done;
						else if(Bit == 0) begin next_state=s_1;incr_k=1;end 
						else begin next_state=s_idle;incr_k=1;end 
			s_1    : if(k==31) next_state=s_done;
						else if(Bit) begin next_state=s_2;incr_k=1;incr_tmp=1;end
								else begin next_state=s_1;incr_k=1;end 
			s_2    : if(k==31) 
							if(Bit == 0)
								if(tmp > gap)
									begin store_tmp=1;next_state=s_done;end
								else next_state=s_done;
							else next_state=s_done;
						else begin 
							if(Bit == 0)
								if(tmp > gap)
									begin store_tmp=1;next_state=s_1;incr_k=1;flush_tmp=1;end 
								else begin flush_tmp=1;incr_k=1;next_state=s_1;end
							else begin incr_tmp=1;incr_k=1;next_state=s_2;end
						end 
			s_done  : begin next_state=s_idle;incr_k=1;end 
			default :next_state=s_idle;
		endcase	
	end
always @(posedge clk,posedge rst)
		begin
			if(rst)
				begin
					k<=0;
					tmp<=0;
					gap<=0;
				end
				else 
					begin
						if(flush_tmp) tmp<=0;
						if(store_tmp) gap<=tmp;
						if(incr_k)k<=k+1;
						if(incr_tmp) tmp<=tmp+1;
				end 
		 end
endmodule