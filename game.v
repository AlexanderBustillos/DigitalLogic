module game(
    input Clock,
    input [2:0] state, 
    input wire selectbutton,
    input wire incbutton,
    output reg flag,
    output wire [6:0] Digital0,
    output wire [6:0] Digital1,
    output wire [6:0] Digital2,
    output wire [6:0] Digital3,
    output wire [6:0] Digital4,
    output wire [6:0] Digital5,
    output wire [9:0] LEDn,
	 input wire resetswitch
);

    // State parameters
    parameter idle = 2'b00;
	parameter choose = 2'b01;
	parameter waiting= 2'b10;
	parameter display=2'b11;


    assign LEDn = led;

    // internal registers
	reg won;
	reg lost;
    reg [3:0] bcd0;
    reg [3:0] bcd1;
    reg [3:0] bcd2;
    reg [3:0] bcd3;
    reg [3:0] bcd4;
    reg [3:0] bcd5;
    reg [24:0] scroll_counter;
    reg [9:0] led;
    reg incbutton_reg, incbutton_reg_prev;
    reg selectbutton_reg, selectbutton_reg_prev;
    reg [3:0] currentnum;
	 reg [3:0] currentnum2;
	 reg [3:0] currentnum0;
    reg [1:0] myRand; 
	 wire [9:0] LEDs;
	 reg [25:0] clk_div;         
	wire slow_clk;              
always @(posedge Clock or posedge lost) begin
    if (lost)
        clk_div <= 0;
    else
        clk_div <= clk_div + 1;
end

assign slow_clk = clk_div[25];  // slow clock
    // 7-segment display modules
    seg72 seg0(bcd0, Digital0);
    seg7 seg1(bcd1, Digital1);
    seg72 seg2(bcd2, Digital2);
    seg7 seg3(bcd3, Digital3);
    seg7 seg4(bcd4, Digital4);
    seg7 seg5(bcd5, Digital5);
	 
	ledscroller led_shifter(slow_clk,lost,LEDs);
	
    // button debounce logic
    always @(posedge Clock) begin
        incbutton_reg_prev <= incbutton_reg;
        incbutton_reg <= incbutton;
        selectbutton_reg_prev <= selectbutton_reg;
        selectbutton_reg <= selectbutton;
    end

    // main state machine
    always @(posedge Clock) begin
        case (state)
            idle: begin
                // Initialize variables
					 if(resetswitch)begin
					 bcd0 <= 0;
					 bcd2 <= 0;
					 currentnum0 =0;
					 currentnum2 =0;
					 end
                led <= 10'b1000000000;
                bcd1 <= 4;
					 bcd3 <=	4;
                bcd4 <= 5;
					 bcd5 <= 5;

                won <= 0;
                lost <= 0;
                flag <= 0;
                myRand <= (myRand + 11) % 3; // Update random choice
            end

            choose: begin
				if(resetswitch)begin
					 bcd0 <= 0;
					 bcd2 <= 0;
					 end
                led <= 10'b1011111101;
                if (incbutton_reg && !incbutton_reg_prev) begin
                    if (currentnum < 2) begin
                        currentnum = currentnum + 1;
                    end else begin
                        currentnum = 0;
                    end
                    bcd5 <= currentnum;
                end
                if (selectbutton_reg && !selectbutton_reg_prev) begin
					 if(currentnum == myRand)begin
							bcd4 <= myRand;
					 end else if(currentnum != myRand)begin  
							bcd4 <= myRand;
                        flag <= 1;
                    end
						   end
				end
				waiting: begin
				if(resetswitch)begin
					 bcd0 <= 0;
					 bcd2 <= 0;
					 currentnum0 =0;
					 currentnum2 =0;
					 end
    led <= 10'b0000000000;
    bcd4 <= myRand;

    if (currentnum == 0 && myRand == 1) begin // Rock vs Paper
        bcd4 <= myRand;
        lost <= 1;
        flag <= 0;
        if (!flag) begin
            if (currentnum0 < 9) begin
                currentnum0 = currentnum0 + 1;
            end else begin
                currentnum0 = 0;
            end
            bcd0 <= currentnum0;
            flag <= 1; 
        end
    end else if (currentnum == 0 && myRand == 2) begin // Rock vs Scissors
        bcd4 <= myRand;
        won <= 1;
		 
        flag <= 0;
        if (!flag) begin
            if (currentnum2 < 9) begin
                currentnum2 = currentnum2 + 1;
            end else begin
                currentnum2 = 0;
            end
            bcd2 <= currentnum2;
            flag <= 1; 
        end
    end else if (currentnum == 1 && myRand == 0) begin // Paper vs Rock
        bcd4 <= myRand;
        won <= 1;
		  
        flag <= 0;
        if (!flag) begin
            if (currentnum2 < 9) begin
                currentnum2 = currentnum2 + 1;
            end else begin
                currentnum2 = 0;
            end
            bcd2 <= currentnum2;
            flag <= 1; 
        end
    end else if (currentnum == 1 && myRand == 2) begin // Paper vs Scissors
        bcd4 <= myRand;
        lost <= 1;
        flag <= 0;
        if (!flag) begin
            if (currentnum0 < 9) begin
                currentnum0 = currentnum0 + 1;
            end else begin
                currentnum0 = 0;
            end
            bcd0 <= currentnum0;
            flag <= 1; 
        end
    end else if (currentnum == 2 && myRand == 0) begin // Scissors vs Rock
        bcd4 <= myRand;
        lost <= 1;
        flag <= 0;
        if (!flag) begin
            if (currentnum0 < 9) begin
                currentnum0 = currentnum0 + 1;
            end else begin
                currentnum0 = 0;
            end
            bcd0 <= currentnum0;
            flag <= 1; 
        end
    end else if (currentnum == 2 && myRand == 1) begin // Scissors vs Paper
        bcd4 <= myRand;
        won <= 1;
        flag <= 0;
		  
        if (!flag) begin
            if (currentnum2 < 9) begin
                currentnum2 = currentnum2 + 1;
            end else begin
                currentnum2 = 0;
            end
            bcd2 <= currentnum2;
            flag <= 1; 
        end
    end
end

        
            display: begin
				
				if(resetswitch)begin
					 bcd0 <= 0;
					 bcd2 <= 0;
					 currentnum0 =0;
					 currentnum2 =0;
					 end
					//win !
				if(won)begin
						led <=LEDs;
				end
				//lose
				if(lost)begin
				
                led <= 10'b0000000000;
				end
            end

 
            default: begin
                // Default case
            end
        endcase
    end
endmodule
