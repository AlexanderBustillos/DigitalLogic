/*************************************************************
* This code corresponds to Figure 5.63
* Description: 2-digit Binary Coded Decimal File
* Note: Update to be consistent with our truth table
* EECE 235
*************************************************************/
module seg7 (bcd, leds);
	input [3:0] bcd;
	output reg [6:0] leds;
	
	always @(bcd)
	begin
		case (bcd) //this case statement assumes active high
			0: leds = 7'b1101101;//R
			1: leds = 7'b0110011;//P
			2: leds = 7'b1110011;//S
			3: leds = 7'b1001111;
			4: leds = 7'b1000000;
			5: leds = 7'b0111111;
			default: leds = 7'b0000000;
		endcase
		

	
	end

		
endmodule 