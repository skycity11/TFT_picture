module TFT_picture(
	input						clk_33_3m,
	input						rst_n,
	
	input		[10:0]		x_pos,
	input		[10:0]		y_pos,
	
	output	[15:0]	display_data
);

localparam	H_DISP = 10'd800,
				V_DISP = 10'd480,
				POS_X  = 10'd0,
				POS_Y	 = 10'd0,
				WIDTH	 = 10'd800,
				HEIGHT = 10'd480,
				TOTAL  = 17'd120000,
				BLACK  = 16'h0000;
				
//display_data
wire		[15:0]	rom_data;
assign	display_data = rom_valid ? rom_data : BLACK;

//rom_rd_en
wire				rom_rd_en;
assign	rom_rd_en = ((x_pos >= POS_X) && (x_pos < (POS_X + WIDTH)) && (y_pos >= POS_Y) && (y_pos < (POS_Y + HEIGHT))) ? 1'b1 : 1'b0;

//rom_addr
wire	[16:0]	rom_addr;
assign	rom_addr = x_pos[10:1] + y_pos[10:1] * 400;

//rom_valid
reg				rom_valid;
always @(posedge clk_33_3m or negedge rst_n) begin
	if(!rst_n)
		rom_valid <= 1'b0;
	else
		rom_valid <= rom_rd_en;
end

pic_rom	pic_rom_inst(
	.address(rom_addr),
	.clock(clk_33_3m),
	.rden(rom_rd_en),
	.q(rom_data)
);

endmodule
