// this is our datapath module for the binary search algorithm. This module updates 
// our datapath variables based on the provided control signals from the control module. 
// The following I/O for this module are:
// inputs: 
//			  1 bit clk signal that our system is synced to.
//			  8 bit input A which is our "target" to find and 8 bit curr which is our current value read from the ROM to check with A.
//			  1 bit control signals : init, incr_left, decr_right, calc_mid.
// outputs: 
//			  5 bit loc, which is our "mid" value that we search in the ROM and compare.
//			  1 bit flag signals fed into the control module: L_LTorEQ_R, equalA, curr_LT_A.
//

module binarySearchDatapath (input logic clk, init, incr_left, decr_right, calc_mid,
									  output logic  L_LTorEQ_R, equalA, curr_LT_A,
									  input logic  [7:0] A,
									  output logic [4:0] loc,
									  input logic  [7:0] curr);
// local variables needed in our binary search 
	logic  [4:0] L, R;
// auxillary register to store copy of input A, so search isn't interupted if A is changed midway.
	logic [7:0] copyA;
	
// assign flag signal values.
	assign L_LTorEQ_R = (L <= R);
	assign equalA = (curr == copyA);
	assign curr_LT_A = (curr < copyA);
	
	
	// operations done based on control signals from control module.
	always_ff @(posedge clk) begin 
		if (init) begin 
			L <= 0; 
			R <= 31;
			copyA <= A;
			loc <= (L+R)/2;
		end 
		
		if (incr_left)
			L <= loc + 1;
		
		if (decr_right)
			R <= loc - 1;
			
		if (calc_mid)
			loc <= (L+R)/2;
	
	
	end // always_ff 
	
endmodule // binarySearchDatapath