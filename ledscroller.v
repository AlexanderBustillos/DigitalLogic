module ledscroller(
    input clk,
    input rst,
    output [9:0] led  
);


wire [9:0] q;  
wire [9:0] d;

// make 10 flip flops cascaded
dflipflop dff0 (.clk(clk), .reset(rst), .d(d[0]), .q(q[0]));
dflipflop dff1 (.clk(clk), .reset(rst), .d(d[1]), .q(q[1]));
dflipflop dff2 (.clk(clk), .reset(rst), .d(d[2]), .q(q[2]));
dflipflop dff3 (.clk(clk), .reset(rst), .d(d[3]), .q(q[3]));
dflipflop dff4 (.clk(clk), .reset(rst), .d(d[4]), .q(q[4]));
dflipflop dff5 (.clk(clk), .reset(rst), .d(d[5]), .q(q[5]));
dflipflop dff6 (.clk(clk), .reset(rst), .d(d[6]), .q(q[6]));
dflipflop dff7 (.clk(clk), .reset(rst), .d(d[7]), .q(q[7]));
dflipflop dff8 (.clk(clk), .reset(rst), .d(d[8]), .q(q[8]));
dflipflop dff9 (.clk(clk), .reset(rst), .d(d[9]), .q(q[9]));

// shifting
assign d[0] = q[9];        
assign d[1] = q[0];        
assign d[2] = q[1];        
assign d[3] = q[2];
assign d[4] = q[3];
assign d[5] = q[4];
assign d[6] = q[5];
assign d[7] = q[6];
assign d[8] = q[7];
assign d[9] = q[8]; 

assign led = q;

endmodule
