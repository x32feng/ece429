module mips(clk, reset,instr_addr, instr_in,data_addr, data_in, data_out,data_rd_wr,rf_rd_data0,rf_rd_data1);
		
parameter [31:0] pc_init = 0;
parameter [31:0] sp_init = 0;
parameter [31:0] ra_init = 0;

//mips
input clk,reset,data_rd_wr;
input [31:0] instr_in,data_addr,instr_addr;
input [31:0]data_in;//dmem to mips
output [31:0]data_out;//mips to dmem
reg [31:0] pc;

//regs
reg [4:0] rs_addr,rt_addr,rd_addr, rf_wr_addr;
reg [31:0] rf_wr_data;
input [31:0] rf_rd_data0, rf_rd_data1;
reg rf_wr_en;
reg [15:0] imm_data;

//ALU
reg [5:0] opcode;
reg [31:0] alu_a;
reg [31:0] alu_b;
reg [31:0] alu_out;
//instruction
reg [31:0] ir;

//5 stages
reg [2:0] current_stage;//000 IF, 001 ID, 010 EX, 011 MEM, 100 WB 

regfile regs(
.wr_num(rf_wr_addr),
.wr_data(rf_wr_data),
.wr_en(rf_wr_en), // constant function
.rd0_num(rs_addr),
.rd0_data(rf_rd_data0),
.rd1_num(rt_addr),
.rd1_data(rf_rd_data1),
.clk(clk));
always @(posedge clk)
begin
	if(reset) begin
	//reset all signals
	pc = pc_init;
	end
	else begin
		case(current_stage)
		0: begin
		//IF
		ir = instr_in;
		pc = pc + 4;
		current_stage = 1;
		end
		
		1: begin
		//ID
		opcode = ir[31:26];
		alu_a = ir[25:21];
		alu_b = ir[20:16];
		current_stage = 2;
		end
		
		2: begin
		//EX
			//case(opcode)
			
			
		current_stage = 3;
		end
		
		3: begin
		//ME
		
		current_stage = 4;
		end
		
		4:begin
		//WB
		
		current_stage = 0;
		end
		endcase
	end

end
endmodule 