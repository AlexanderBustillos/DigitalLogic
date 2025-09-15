module dflipflopbehave (
    input wire D,      
    input wire clk,    
    input wire reset, 
    output reg Q      
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        Q <= 0;      
    end else begin
        Q <= D;      
    end
end

endmodule
