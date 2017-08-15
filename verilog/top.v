// DottoriLog: A Verilog implementation of Sega's Dottori-Kun
// 2017 Furrtek - Public domain
// Written based on information from Chris Covell

// Altera/Terasic DE1 interface
module top(
		input [1:0] CLOCK_24,
		input [3:0] KEY,
		input [4:0] SW,
		output [3:0] VGA_R,
		output [3:0] VGA_G,
		output [3:0] VGA_B,
		output VGA_VS,
		output VGA_HS
);

// KEY[0] is Up
// KEY[1] is Down
// KEY[2] is Left
// KEY[3] is Right
// SW[0] is nRESET
// SW[1] is Button 1
// SW[2] is Button 2
// SW[3] is Start
// SW[4] is Coin-in
// VGA_VS is composite sync
// VGA_HS is always high (useful to put TVs in RGB mode)

reg CLK_4M;
reg [1:0] CLK_DIV;

wire RED, GREEN, BLUE;
wire [7:0] BUTTONS;

assign nRESET = SW[0];
assign BUTTONS = {SW[4:1], KEY};

assign VGA_HS = 1'b1;
assign VGA_R = {4{RED}};
assign VGA_G = {4{GREEN}};
assign VGA_B = {4{BLUE}};

dottori DOTTORI(CLK_4M, RED, GREEN, BLUE, VGA_VS, nRESET, BUTTONS);

// Generate 4M clock from 24M
always @(posedge CLOCK_24[0] or negedge nRESET)
begin
	if (!nRESET)
		CLK_4M <= 1'b0;
	else
	begin
		if (CLK_DIV == 2'd2)		// (24M / 4M / 2) - 1
		begin
			CLK_DIV <= 2'd0;
			CLK_4M <= ~CLK_4M;
		end
		else
			CLK_DIV <= CLK_DIV + 1'b1;
	end
end

endmodule
