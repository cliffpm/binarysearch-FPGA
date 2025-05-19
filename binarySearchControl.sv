/*
Our control module for the binary search algorithm. This module serves as the FSM logic so we can 
assign correct states and signals according to the ASMD. This module has the following I/O's:
	Input: 1 bit clk signal that our system is synced to, start which starts the binary search, and reset 
			 going back to the reset state shown in the ASMD.
			 1 bit signals of the following flag signals sent from the datapath module: L_LTorEQ_R, equalA, curr_LT_A.
	Output: 1 bit done when search is finished and found when the target is found. The rest are the following 
			  control signals sent to the datapath: init, incr_left, decr_right, calc_mid.
*/
module binarySearchControl(input logic clk, start, L_LTorEQ_R, equalA, curr_LT_A, reset,
									output logic init, incr_left, decr_right, calc_mid, done, found);


	// declare states as shown in ASMD.
	enum {idle, loadmem, waitmem, calcData, doneState} ps, ns;
	
	// next state logic 
	always_comb begin 
		case(ps) 
			idle: ns = start ? loadmem : idle;
			loadmem: ns = waitmem;
			waitmem: ns = calcData;
			calcData: begin 
				if (L_LTorEQ_R) begin 
					if (equalA) ns = doneState;
					else ns = loadmem;
				end // if
				else 
					ns = doneState;
			
			end // begin 
			doneState: ns = start ? doneState : idle;
		endcase // case 
	end //always_comb 
	
	
	// output assignments 
	always_comb begin 
		init = 0; incr_left = 0; decr_right = 0; calc_mid = 0; done = 0; found = 0;
		case (ps) 
		
			idle: begin 
				if (start) 
					init = 1;
			end 
			
			loadmem: calc_mid = 1;
			
			calcData: begin 
				if (L_LTorEQ_R && ~equalA) begin 
					if (curr_LT_A) 
						incr_left = 1;
					else 
						decr_right = 1;
				end // if 
				
				if (L_LTorEQ_R && equalA) begin 
					found = 1;
				end // 
			end 
			
			doneState: begin 
				done = 1;
				if (equalA) found = 1; // for user clarity to see show up longer so user knows their value was found.
			end 
			
		endcase 
	end // always_comb
	
	
	// present state logic / assignment
	always_ff @(posedge clk) begin 
		if (reset) 
			ps <= idle;
		else 
			ps <= ns;
	end //always_ff



endmodule // binarySearchControl