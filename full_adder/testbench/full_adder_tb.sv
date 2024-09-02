`timescale 1ns/1ps

module full_adder_tb;

    logic a, b, carry_in;
    logic sum, carry_out;
    
    full_adder uut (
        .a(a),
        .b(b),
        .carry_in(carry_in),
        .sum(sum),
        .carry_out(carry_out)
    );
    
    integer i;
    logic [2:0] inputs;
    logic [1:0] expected_output;
    integer num_errors = 0;
    
    initial begin
        // Generate VCD file
        $dumpfile("full_adder/waves/full_adder.vcd");
        $dumpvars(0, full_adder_tb);

        for (i = 0; i < 8; i++) begin
            inputs = i[2:0];
            a = inputs[2];
            b = inputs[1];
            carry_in = inputs[0];
            
            #10; // Wait for combinational logic to settle
            
            expected_output = a + b + carry_in;
            
            if ({carry_out, sum} !== expected_output) begin
                num_errors++;
            end
        end
        
        if (num_errors == 0) begin
            $display("All tests passed successfully!");
        end else begin
            $display("%d errors found in testing.", num_errors);
        end
        
        $finish;
    end

endmodule