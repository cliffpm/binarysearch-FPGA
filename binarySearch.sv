/*
	This module is a binarySearch algorithm done on a 32x8 ROM that is intialized 
	via an .mif file pre-loaded with unsigned 8 bit numbers that are in sorted ascending order.
	This module is broken down into a control module and datapath module, allowing for a cleaner 
	top level module of the algorithm and promoting abstraction. 
	This module contains the following I/O's:
	Inputs: 
		A: An 8 bit value which serves as our target to find in our memory.
		Start: 1 bit signal to start algorithm.
		reset: 1 bit signal to reset algorithm to the reset state.
		clk: 1 bit clock signal that system is synced to.
	Outputs:
		loc: A 5 bit value that is our "mid" for the binarySearch and the index we always check in our ROM.
		done: 1 bit signal indicating we finished our binary search.
		found: 1 bit signal indicating the input was found in our ROM.
*/

module binarySearch(input logic  [7:0] A,
							input logic start, reset, clk,
							output logic [4:0]loc,
							output logic done, found);							


// control signals 
	logic init, incr_left, decr_right, calc_mid;
	
// flag signals 
	logic L_LTorEQ_R, equalA, curr_LT_A;
	
// datapath vars
	logic  [7:0] curr;
	logic  [7:0] copyA;
	

  
// 32x8 ROM memory that we do our binary search on.
	rom32x8 mem (.address(loc), .clock(clk), .q(curr));

// instantiating our control and datapath module.
	binarySearchControl ctrl (.*);
	binarySearchDatapath data (.*);
	



endmodule // binarySearch