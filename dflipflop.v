module dflipflop (
    input wire clk,   
    input wire reset,  
    input wire d,      
    output wire q      
);

    wire nclk;           
    wire s, r;          

    //inverting for neg edge trigger
    not (nclk, clk);

    // asynchronous reset 
    assign s = reset ? 1'b1 : (d & clk);    //sr latch
    assign r = reset ? 1'b0 : (~d & nclk);  // reset for sr latch

    // nor gates
    wire q_internal, nq_internal; // latch signals
    nor (q_internal, s, nq_internal);  // nor
    nor (nq_internal, r, q_internal);  // nor

    assign q = q_internal;  // output of the D flip-flop

endmodule
