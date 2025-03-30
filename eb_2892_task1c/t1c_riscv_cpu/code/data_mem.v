
// data_mem.v - data memory

module data_mem #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, MEM_SIZE = 64) (
    input       clk, wr_en,
    input       [ADDR_WIDTH-1:0] wr_addr, wr_data,
	 input [2:0] funct3,
    output reg [DATA_WIDTH-1:0] rd_data_mem
);

// array of 64 32-bit words or data
reg [DATA_WIDTH-1:0] data_ram [0:MEM_SIZE-1];
wire [ADDR_WIDTH-1:0] word_addr=wr_addr[DATA_WIDTH-1:2] % 64;


always @(posedge clk) begin
    if (wr_en) begin
        case (funct3)
            3'b000: data_ram[word_addr][wr_addr[1:0]*8 +: 8] <= wr_data[7:0];
            3'b001: data_ram[word_addr][wr_addr[1]*16 +: 16] <= wr_data[15:0];
            3'b010: data_ram[word_addr] <= wr_data;
				default:data_ram[word_addr] <=32'hDEADBEEF;
        endcase
    end
end

always @(*) begin
    rd_data_mem = 32'b0;
    case (funct3)
        3'b000: rd_data_mem = {{24{data_ram[word_addr][wr_addr[1:0]*8 + 7]}}, data_ram[word_addr][wr_addr[1:0]*8 +: 8]};
        3'b001: rd_data_mem = {{16{data_ram[word_addr][wr_addr[1]*16 + 15]}}, data_ram[word_addr][wr_addr[1]*16 +: 16]};
        3'b010: rd_data_mem <= data_ram[word_addr];
        3'b100: rd_data_mem = {24'b0, data_ram[word_addr][wr_addr[1:0]*8 +: 8]};
        3'b101: rd_data_mem = {16'b0, data_ram[word_addr][wr_addr[1]*16 +: 16]};
		  default:rd_data_mem <=32'hDEADBEEF;
    endcase
end

endmodule

