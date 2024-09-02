module full_adder (
    input logic a,
    input logic b,
    input logic carry_in,
    output logic sum,
    output logic carry_out
);

    assign sum = (a & b & carry_in) | (a & ~b & ~carry_in) | (~a & b & ~carry_in) | (~a & ~b & carry_in);
    assign carry_out = (~a & b & carry_in) | (a & ~b & carry_in) | (a & b & ~carry_in) | (a & b & carry_in);

endmodule