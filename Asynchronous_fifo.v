module asyn_fifo(wr_clk,rd_clk,rst,wr_en,rd_en,w_data,r_data,full,empty,wr_error,rd_error);
parameter WIDTH=8;
parameter DEPTH=16;
parameter PTR_WIDTH=$clog2(DEPTH);

//port directions
input wr_clk,rd_clk,rst,wr_en,rd_en;
input [WIDTH-1:0] w_data;
output reg [WIDTH-1:0] r_data;
output reg full,empty,wr_error,rd_error;

//internal registers
reg [PTR_WIDTH-1:0] wr_ptr,rd_ptr,wr_ptr_rd_clk,rd_ptr_wr_clk,rd_ptr_gray,wr_ptr_gray;
reg wr_t,rd_t,rd_t_wr_clk,wr_t_rd_clk;

//declaration of fifo
reg [WIDTH-1:0] fifo [DEPTH-1:0];
integer i;

//Read operation
always@(posedge wr_clk)begin 
		if(rst)begin 
			full=0;empty=1;
			wr_error=0;rd_error=0;
			r_data=0;
			wr_ptr=0;rd_ptr=0;
			wr_t=0;rd_t=0;
			for(i=0;i<DEPTH;i=i+1) fifo[i]=0;
		end
		else begin 
			wr_error=0;
			if(wr_en)begin 
				if(full)begin 
					wr_error=1;
				end
				else begin 
					fifo[wr_ptr]=w_data;
					if(wr_ptr==DEPTH-1) begin 
						wr_t=~wr_t;
					end
					else begin 
						wr_ptr=wr_ptr+1;
						wr_ptr_gray={wr_ptr[PTR_WIDTH-1],wr_ptr[PTR_WIDTH-1:1] ^ wr_ptr[PTR_WIDTH-2:0]};
					end
				end
			end
		end
end
// READ operation
always@(posedge rd_clk)begin 
			rd_error=0;
			if(rd_en)begin 
				if(empty)begin 
					rd_error=1;
				end
				else begin 
					r_data=fifo[rd_ptr];
					if(rd_ptr==DEPTH-1)begin 
						rd_t=~rd_t;
					end
					else begin 
						rd_ptr=rd_ptr+1;
						//gray counter convert
						rd_ptr_gray={rd_ptr[PTR_WIDTH-1],rd_ptr[PTR_WIDTH-1:1] ^ rd_ptr[PTR_WIDTH-2:0]};
					end
				end
			end
end

//synchronization with rd & wr clock

always@(posedge wr_clk)begin 
	rd_ptr_wr_clk <= rd_ptr_gray;
	rd_t_wr_clk <=rd_t;
end

always@(posedge rd_clk)begin 
	wr_ptr_rd_clk <= wr_ptr_gray;
	wr_t_rd_clk <= wr_t;
end

// FULL and EMPTY condition

always@(*)begin 
		full=0;empty=0;
		if(wr_ptr_gray==rd_ptr_wr_clk && wr_t!=rd_t_wr_clk) full=1;
		else full=0;
		if(rd_ptr_gray==wr_ptr_rd_clk && rd_t==wr_t_rd_clk) empty=1;
		else empty=0;
end


endmodule
