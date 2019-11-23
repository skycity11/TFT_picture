module TFT_driver(
	input						clk_33_3m,
	input						rst_n,
	
	input			[15:0]	data_in,
	
	output		[10:0]	hcount,
	output		[10:0]	vcount,
	output		[15:0]	tft_rgb,
	output					tft_hs,
	output					tft_vs,
	output					tft_clk,
	output					tft_de,
	output					tft_pwm,
	output					tft_blank_n
);
/*
parameter  H_SYNC   =  11'd2;      //行同步
parameter  H_BACK   =  11'd44;     //行显示后沿
parameter  H_DISP   =  11'd800;    //行有效数据
parameter  H_FRONT   =  11'd210;    //行显示前沿
parameter  H_TOTAL  =  11'd1056;   //行扫描周期
   
parameter  V_SYNC   =  11'd2;      //场同步
parameter  V_BACK   =  11'd22;     //场显示后沿
parameter  V_DISP   =  11'd480;    //场有效数据
parameter  V_FRONT  =  11'd22;     //场显示前沿
parameter  V_TOTAL  =  11'd524;    //场扫描周期  
*/
parameter	H_SYNC  = 11'd128,
				H_BACK  = 11'd88,
				H_DISP  = 11'd800,
				H_FRONT = 11'd40,
				H_TOTAL = 11'd1056,
				V_SYNC  = 11'd2,
				V_BACK  = 11'd33,
				V_DISP  = 11'd480,
				V_FRONT = 11'd10,
				V_TOTAL = 11'd525;

parameter	X_START = 11'd0,	
				X_ZOOM  = 11'd800,
				Y_START = 11'd0,
				Y_ZOOM  = 11'd480;

//hcount_r
reg		[10:0]		hcount_r;
always @(posedge clk_33_3m or negedge rst_n) begin
	if(!rst_n)
		hcount_r = 11'd0;
	else
		if(hcount_r == H_TOTAL)
			hcount_r <= 11'd0;
		else
			hcount_r <= hcount_r + 1'b1;
end

//vcount_r
reg		[10:0]		vcount_r;
always @(posedge clk_33_3m or negedge rst_n) begin
	if(!rst_n)
		vcount_r = 11'd0;
	else if(hcount_r == H_TOTAL)
		if(vcount_r == V_TOTAL)
			vcount_r <= 11'd0;
		else
			vcount_r <= vcount_r + 1'b1;
	else
		vcount_r <= vcount_r;
end

//HS & VS
assign tft_hs = (hcount <= (H_SYNC - 1'b1)) ? 1'b0 : 1'b1;
assign tft_vs = (vcount <= (V_SYNC - 1'b1)) ? 1'b0 : 1'b1;
//de
assign tft_de= ((hcount_r >= (H_SYNC + H_BACK - 1'b1)) && (hcount_r < (H_SYNC + H_BACK + H_DISP - 1'b1)))
				&& ((vcount_r >= (V_SYNC + V_BACK - 1'b1)) && (vcount_r < (V_SYNC + V_BACK + V_DISP - 1'b1))) ? 1'b1:1'b0;
//data
wire tft_req = ((hcount_r >= (H_SYNC + H_BACK + X_START - 1'b1)) && (hcount_r < (H_SYNC + H_BACK  + X_START + X_ZOOM - 1'b1)))
				&& ((vcount_r >= (V_SYNC + V_BACK + Y_START - 1'b1)) && (vcount_r < (V_SYNC + V_BACK  + Y_START + Y_ZOOM - 1'b1)));
				
assign tft_rgb = (tft_req) ? data_in : 16'd0;

//hcount & vcount
assign hcount= (tft_req) ? (hcount_r - (H_SYNC + H_BACK + X_START - 1'b1)) : 11'd0;  
assign vcount= (tft_req) ? (vcount_r - (V_SYNC + V_BACK + Y_START - 1'b1)) : 11'd0;

//Other Pins
assign tft_clk = clk_33_3m;
assign tft_pwm = rst_n;
assign tft_blank_n = tft_de;
endmodule
