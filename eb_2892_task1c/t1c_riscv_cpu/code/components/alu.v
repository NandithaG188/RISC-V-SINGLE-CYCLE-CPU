/*
module alu #(parameter WIDTH = 32) (
    input wire [WIDTH-1:0] a, b,
    input [2:0] alu_ctrl,
    output reg [WIDTH-1:0] alu_out,
    output  zero
);

always @(*) begin
    case (alu_ctrl)
        3'b000: alu_out <= a + b; // ADD
        3'b001: alu_out <= a + ~b + 1; // SUB
        3'b010: alu_out <= a & b; // AND
        3'b011: alu_out <= a | b; // OR
        3'b100: alu_out <= a ^ b; // XOR
        3'b101:  begin                   // SLT
                     if (a[31] != b[31]) alu_out <= a[31] ? 0 : 1;
                     else alu_out <= a < b ? 1 : 0;
                 end
        default: alu_out <= 0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;
endmodule
*/


// alu.v - ALU module

module alu #(parameter WIDTH = 32) (
    input       wire [WIDTH-1:0] a, b,       // operands
    input       [3:0] alu_ctrl,         // ALU control
    output reg  [WIDTH-1:0] alu_out,    // ALU output
    output      zero                    // zero flag
);

always @(a, b, alu_ctrl) begin
    casez (alu_ctrl)
        4'b0000:  alu_out <= a + b;       // ADD
        4'b0001:  alu_out <= a + ~b + 1;  // SUB
        4'b0010:  alu_out <= a & b;       // AND
        4'b0011:  alu_out <= a | b;       // OR
		  4'b0100:  alu_out <= a ^ b;      // xor
        4'b0101:  begin                   // SLT
                     if (a[31] != b[31]) alu_out <= a[31] ? 1 : 0;
                     else if((a[31]==1 )&( b[31]==1 ))alu_out <= a < b ? 0 : 1;
							else if((a[31]==0 )&( b[31]==0 )) alu_out <= a < b ? 1 : 0;
							else alu_out <=32'hDEADBEEF;
                 end 
					  
			4'b0110:  begin//SLTU
					  alu_out <= a < b ? 1 : 0;
					  end
			4'b0111: alu_out <= a<<b[4:0];//SLL/slli
			4'b1000: alu_out <= a>>b[4:0];//SRL/srli
			4'b1001: alu_out <= $signed(a)>>>b[4:0];//SRA //HERE FUNCT7 010000 SHOULD I INCLUDE THAT ALSO OR ONLY THE LAST 5 BITS 
			//4'b1010: alu_out <= a>>>(b[4:0]);//SRAi
			4'b1?1?:alu_out <=32'hDEADBEEF;
        default: alu_out <=0;
    endcase
end

assign zero = (alu_out == 0) ? 1'b1 : 1'b0;

endmodule

//check if the xor added is correct or not 
//CHECK WHAT DOES A<B ACTUALLY DO 
