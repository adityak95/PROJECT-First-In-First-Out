`include"Asynchronous_fifo.v"
module tb;
parameter WIDTH=8;
parameter DEPTH=16;
parameter PTR_WIDTH=$clog2(DEPTH);

//port directions
reg wr_clk,rd_clk,rst,wr_en,rd_en;
reg [WIDTH-1:0] w_data;
wire [WIDTH-1:0] r_data;
wire full,empty,wr_error,rd_error;

//internal registers
reg [PTR_WIDTH-1:0] wr_ptr,rd_ptr,wr_ptr_rd_clk,rd_ptr_wr_clk;
reg wr_t,rd_t,rd_t_wr_clk,wr_t_rd_clk;
reg [8*100:0]testcase;

//declaration of fifo
reg [WIDTH-1:0] fifo [DEPTH-1:0];
integer i,a,b;


asyn_fifo #(.WIDTH(WIDTH),.DEPTH(DEPTH),.PTR_WIDTH(PTR_WIDTH)) dut(wr_clk,rd_clk,rst,wr_en,rd_en,w_data,r_data,full,empty,wr_error,rd_error);

initial begin 
wr_clk=0;
forever #5 wr_clk=~wr_clk;
end
initial begin 
#5;
rd_clk=0;
forever #5 rd_clk=~rd_clk;
end
initial begin 
rst=1;
repeat(2)@(posedge rd_clk);
rst=0;
$value$plusargs("testcase=%s",testcase);
			case(testcase)
			"wr_rd":begin 
				write(0,DEPTH);
				read(0,DEPTH);
			end
			"full":begin 
				write(0,DEPTH);
			end
			"empty":begin 
				write(0,DEPTH);
				read(0,DEPTH+1);
			end
			"write_error":begin 
				write(0,DEPTH+1);
			//	read(0,DEPTH);
			end
			"read_error":begin 
				write(0,DEPTH);
				read(0,DEPTH+4);
			end
			"user_defined":begin
				$value$plusarge("a=%d",a);
				$value$plusarge("b=%d",b);
				write(a,b);
				read(a,b);
			end
			"random":begin 
				write($random,$random);
				read($random,$random);
			end
			"urandom":begin 
				write($urandom_range(0,10),$urandom_range(10,13));
				read($urandom_range(0,10),$urandom_range(10,13));
			end
			"minus":begin 
				write(0,DEPTH-1);
				read(0,DEPTH-1);
			end
			"quater":begin 
				write(0,DEPTH/4);
				read(0,DEPTH/4);
			end
			"half":begin 
				write(0,DEPTH/2);
				read(0,DEPTH/2);
			end
			"halfplus":begin 
				write(0,(DEPTH/2)+1);
				read(0,(DEPTH/2)+1);
			end
			"halfminus":begin 
				write(0,(DEPTH/2)-1);
				read(0,(DEPTH/2)-1);
			end
			"concurrent_wr_rd":begin
			fork 
				write(0,DEPTH);
				read(0,DEPTH);
			join
			end

		endcase
end

// RESET TASK
task reset();
begin 
		wr_en=0;
		rd_en=0;
		w_data=0;
end
endtask

// WRITE TASK
task write(input [PTR_WIDTH-1:0]st,input [PTR_WIDTH:0]en);
begin 
		for(i=st;i<en;i=i+1)begin 
			@(posedge wr_clk);
			wr_en=1;
			wr_ptr=i;
			w_data=$random;

		end
		@(posedge wr_clk);
		reset();
end
endtask

// READ TASK
task read(input [PTR_WIDTH-1:0]st,input [PTR_WIDTH:0]en);
begin 
		for(i=st;i<en;i=i+1)begin 
			@(posedge rd_clk);
			rd_en=1;
			rd_ptr=i;
		end
		@(posedge rd_clk);
		reset();
end
endtask

initial begin 
#500;
$finish();
end


endmodule
