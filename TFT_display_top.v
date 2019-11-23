module TFT_display_top(
	input					clk_50m,
	input					rst_n,
	
	output	[15:0]	tft_rgb,
	output				tft_vsync,
	output				tft_hsync,
	output				tft_clk,
	output				tft_de,
	output				tft_pwm,
	output				tft_blank_n
);

wire				clk_33_3m;
wire	[10:0]	hcount;
wire	[10:0]	vcount;
wire	[15:0]	data;

pll_0002 pll_inst(
	.refclk   (clk_50m),   
	.rst      (~rst_n),      
	.outclk_0 (clk_33_3m), 
	.locked   () 
);

TFT_picture u0(
	.clk_33_3m(clk_33_3m),
	.rst_n(rst_n),
	.x_pos(hcount),
	.y_pos(vcount),
	.display_data(data)
);

TFT_driver u1(
	.clk_33_3m(clk_33_3m),
	.rst_n(rst_n),
	.data_in(data),
	.hcount(hcount),
	.vcount(vcount),
	.tft_rgb(tft_rgb),
	.tft_hs(tft_hsync),
	.tft_vs(tft_vsync),
	.tft_clk(tft_clk),
	.tft_de(tft_de),
	.tft_pwm(tft_pwm),
	.tft_blank_n(tft_blank_n)
);

endmodule
