`timescale 1ns / 1ps


module RingOsc_tb();

	wire clk;
    reg reset;
    reg enable;
    reg [19:0] counter_output;
    reg comm_pin;

	// Instantiate the Unit Under Test (UUT)
	RingOsc uut (
		.clk(clk), 
		.reset(reset), 
		.enable(enable), 
		.counter_output(counter_output),
		.comm_pin(comm_pin)
	);

    initial begin
        clk = 1'b0;
        forever #1 clk =~clk;
     end
     
     initial begin
        reset = 1'b1;
        #10 reset = 1'b0;
     end
     
        
	initial begin
	
	     $monitor("time=%3d, clk=%b, reset=%b, enable=%b, counter_output=%20b, comm_pin=%b \n",
              $time, clk, reset, enable, counter_output, comm_pin);

		// Initialize Inputs
		clk = 0;
		reset = 0;
		enable = 0;
       
       #10 clk = 0;
		reset = 0;
		enable = 1;
		
		#10 clk = 0;
		reset = 1;
		enable = 0;
		
       
       #10 clk = 0;
		reset = 1;
		enable = 1;
       
       #10 clk = 1;
		reset = 0;
		enable = 0;
       
       #10 clk = 1;
		reset = 0;
		enable = 1;
		
		#10 clk = 1;
		reset = 1;
		enable = 0;
		
		#10 clk = 1;
		reset = 1;
		enable = 1;
       

	end
endmodule : RingOsc_tb
