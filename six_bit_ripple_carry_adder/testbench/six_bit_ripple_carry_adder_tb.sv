`timescale 1ns / 1ps

module six_bit_ripple_carry_adder_tb;
    logic [5:0] a, b;
    logic carry_in;
    logic [5:0] sum;
    logic carry_out;

    // Instantiate the Unit Under Test (UUT)
    six_bit_ripple_carry_adder uut (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );

    initial begin
        // Initialize Inputs
        a = 0;
        b = 0;
        carry_in = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here
        a = 6'b101010;
        b = 6'b010101;
        carry_in = 1'b0;
        #10;
        
        // Add more test cases as needed
        
        $finish;
    end
      
    initial begin
        $dumpfile("six_bit_ripple_carry_adder/waves/six_bit_ripple_carry_adder.vcd");
        $dumpvars(0, six_bit_ripple_carry_adder_tb);
    end
endmodule