module Retime_Trailedge
(
	Async_In,
	clk,
    
	Sync_Pulse_Out_d
);
    
    parameter                               Width = 1;                  // Default width is 1 but will
                                                                        // almost always be redefined.
    input           [Width-1:0]             Async_In;
    input                                   clk;

    output          [Width-1:0]             Sync_Pulse_Out_d;

//	Template:
    //------------------------------------------------------------------------------------
/*
	Retime_Trailedge	#()
	Retime_Trailedge
	(
		.Async_In							(),
		.clk								(),
	    
		.Sync_Pulse_Out_d					()
	);
*/
    //==================================================================================================
    // Register Declarations:
    
    // Flip-flops, i.e., outputs of synchronous blocks:
    // (none)

    // Outputs of combinatorial blocks:
    // (none)

    //==================================================================================================
    // Wire Declarations:
    
    // Outputs of instantiated modules:

    wire			[Width-1:0]             Intermediate;
    wire			[Width-1:0]             Sync_Out;
    wire			[Width-1:0]             Sync_Out_Delay;

    // Declarations for combinatorial assignments:
											
	wire			[Width-1:0]				Sync_Pulse_Out_d;

    //==================================================================================================
    // Wire Assignments:
    
	assign Sync_Pulse_Out_d[Width-1:0]      = 	(
													~Sync_Out[Width-1:0] 
													& 
													Sync_Out_Delay[Width-1:0]
												);

    //==================================================================================================
    // Component Instantiations:
    
	DFF_Variable_Width	#(Width)
	Intermediate_reg
	(
	    .D									(Async_In[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Intermediate[(Width-1):0])
	);

    //------------------------------------------------------------------------------------

	DFF_Variable_Width	#(Width)
	Sync_Out_reg
	(
	    .D									(Intermediate[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Sync_Out[(Width-1):0])
	);

    //------------------------------------------------------------------------------------

	DFF_Variable_Width	#(Width)
	Sync_Out_Delay_reg
	(
	    .D									(Sync_Out[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Sync_Out_Delay[(Width-1):0])
	);

    //==================================================================================================
    // Combinatorial Blocks:
    // (none)

    //==================================================================================================
    // Synchronous Blocks:
    // (none)

//	always @(posedge clk or negedge ares_L)						        // Asynchronous reset is handled 
//                                                                        // by including it in the sensi-
//                                                                        // tivity list.
//    begin
//    
//		if (!ares_L)
//		begin
//			Intermediate   			        <= {Width{1'b 0}};
//			Sync_Out					    <= {Width{1'b 0}};
//			Sync_Out_Delay					<= {Width{1'b 0}};
//		end
//
//		else
//		begin
//			Intermediate				    <= Async_In;
//			Sync_Out					    <= Intermediate;
//			Sync_Out_Delay  			    <= Sync_Out;
//		end
//
//    end

	//-----------------------------------------------------------------------------------------------------------------------------

    //==================================================================================================

endmodule


