`ifndef FULL_ADDER_SV
`define FULL_ADDER_SV
`include "full_adder.sv"
`endif

module six_bit_ripple_carry_adder(
    input logic [5:0] a,
    input logic [5:0] b,
    input logic carry_in,
    output logic [5:0] sum,
    output logic carry_out
);
    logic c0, c1, c2, c3, c4;

    full_adder fa1 (.a(a[0]),.b(b[0]),.carry_in(carry_in),.sum(sum[0]),.carry_out(c0));
    full_adder fa2 (.a(a[1]),.b(b[1]),.carry_in(c0),.sum(sum[1]),.carry_out(c1));
    full_adder fa3 (.a(a[2]),.b(b[2]),.carry_in(c1),.sum(sum[2]),.carry_out(c2));
    full_adder fa4 (.a(a[3]),.b(b[3]),.carry_in(c2),.sum(sum[3]),.carry_out(c3));
    full_adder fa5 (.a(a[4]),.b(b[4]),.carry_in(c3),.sum(sum[4]),.carry_out(c4));
    full_adder fa6 (.a(a[5]),.b(b[5]),.carry_in(c4),.sum(sum[5]),.carry_out(carry_out));


endmodule