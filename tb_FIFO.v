`include"fifo.v"
module tb;
parameter WIDTH=8;
parameter DEPTH=16;
parameter PTR_WIDTH=$clog2(DEPTH);

//inputs
reg clk,rst,wr_en,rd_en;
reg [WIDTH-1:0]w_data;

//outputs
wire full,empty,wr_error,rd_error;
wire [WIDTH-1:0]r_data;

//extra registers required
reg [PTR_WIDTH-1:0] wr_ptr,rd_ptr;
reg wr_t,rd_t;
reg [8*50:0] testcase;

//DECLARE THE FIFO
reg [WIDTH-1:0]fifo[DEPTH-1:0];
integer i,a,b;


fifo #(.WIDTH(WIDTH),.DEPTH(DEPTH),.PTR_WIDTH(PTR_WIDTH))dut(clk,rst,w_data,r_data,wr_en,rd_en,full,empty,wr_error,rd_error);

initial begin 
clk=0;
forever #5 clk=~clk;
end
initial begin 
rst=1;
reset();
repeat(2)@(posedge clk);
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
				read(0,DEPTH);
			end
			"read_error":begin 
				write(0,DEPTH);
				read(0,DEPTH+1);
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

task reset();
begin 
	wr_en=0;
	rd_en=0;
	w_data=0;
	wr_ptr=0;
	rd_ptr=0;
	//for(i=0;i<DEPTH;i=i+1) fifo[i]=0;
end
endtask


//write
task write(input  [PTR_WIDTH-1:0]st,input  [PTR_WIDTH:0]en);
begin 
	for(i=st;i<=en;i=i+1)begin
		@(posedge clk);
		wr_ptr=i;
		w_data=$random;
		wr_en=1;
	end
	@(posedge clk);
	reset();
end
endtask
//read
task read(input  [PTR_WIDTH-1:0]st,input  [PTR_WIDTH:0]en);
begin 
	for(i=st;i<en;i=i+1)begin
		@(posedge clk);
		rd_ptr=i;
		rd_en=1;
	end
	@(posedge clk);
	reset();

end
endtask
initial #500 $finish();
endmodule
