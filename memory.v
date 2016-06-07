module memory(data_in,access_size,rd_wr,enable,addr,data_out,clk,busy);
parameter benchmark = "whatever.x";
parameter depth = 2**20; // =1 MB

input [31:0] data_in;
input [31:0] addr;
input clk,rd_wr,enable;
input [1:0] access_size; //0 1word, 1 4 words, 2 8words 3 16words

output [31:0]data_out;

reg [31:0] data_out;
reg [31:0] data [0:depth/4-1];

wire mod_add;
assign mod_add = addr>>2;
reg [31:0] rd_addr;

integer remaining; //remaining words


output busy ; //combinational logic
reg busy;

initial $readmemh(benchmark, data);

always @(posedge clk)
begin
	if(enable==1) begin
		if(remaining > 0)
		begin
			data_out = data[rd_addr];
			rd_addr = rd_addr+1;
			remaining = remaining -1; 
		end
		else
		begin
			if(rd_wr ==1) //read
			begin
				data_out = data[mod_add];
				case(access_size)
					0:remaining = 0;
					1:remaining = 3;
					2:remaining = 7;
					3:remaining = 15;
				endcase
				rd_addr = mod_add+1;
			end
			else
			begin
				data[mod_add] = data_in; //write
			end
		end
	end
	else begin
		remaining = 0;
		data_out = 32'hz;
	end
end

always @(remaining)
begin
	if(remaining == 0) begin
		busy = 0;
	end
	else begin
		busy = 1;
	end
end

endmodule
