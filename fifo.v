module fifo(clk,rst,w_data,r_data,wr_en,rd_en,full,empty,wr_error,rd_error);
parameter WIDTH=8;
parameter DEPTH=16;
parameter PTR_WIDTH=$clog2(DEPTH);

//inputs
input clk,rst,wr_en,rd_en;
input [WIDTH-1:0]w_data;

//outputs
output reg full,empty,wr_error,rd_error;
output reg [WIDTH-1:0]r_data;

//extra registers required
reg [PTR_WIDTH-1:0] wr_ptr,rd_ptr;
reg wr_t,rd_t;

//DECLARE THE FIFO
reg [WIDTH-1:0]fifo[DEPTH-1:0];
integer i;

always@(posedge clk)begin 
		if(rst)begin 
			full=0;
			empty=1;
			wr_error=0;
			rd_error=0;
			r_data=0;
			wr_ptr=0;
			rd_ptr=0;
			wr_t=0;
			rd_t=0;
			for(i=0;i<DEPTH;i=i+1) fifo[i]=0;
		end
		else begin 
			wr_error=0;
			rd_error=0;
			if(wr_en)begin 
				if(full)begin 
					wr_error=1;
				end
				else begin 
					fifo[wr_ptr]=w_data;
					if(wr_ptr==DEPTH-1) wr_t=~wr_t;      //roll over condition
					else wr_ptr=wr_ptr+1;
				end
			end
			if(rd_en)begin 
				if(empty)begin 
					rd_error=1;
				end
				else begin 
					r_data=fifo[rd_ptr];
					if(rd_ptr==DEPTH-1) rd_t=~rd_t;
					else rd_ptr=rd_ptr+1;
				end
			end
		end
end

always@(*)begin
	full=0;empty=0;
	if(wr_ptr==rd_ptr && wr_t==rd_t) empty=1;
	else empty=0;
	if(wr_ptr==rd_ptr && wr_t!=rd_t) full=1;
	else full=0;
end
endmodule
