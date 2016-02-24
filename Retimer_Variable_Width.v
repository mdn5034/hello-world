//======================================================================================================

module Retimer_Variable_Width
(
    Async_In,
    clk,

    Sync_Out
);

    parameter                               Width = 8;                  // Default width is 8 but will
                                                                        // almost always be redefined.
    input           [Width-1:0]             Async_In;
    input                                   clk;

    output          [Width-1:0]             Sync_Out;
//	Template:
	//------------------------------------------------------------------------------------
/*
	Retimer_Variable_Width	#()
	Retimer_Variable_Width
	(
		.Async_In							(),
		.clk								(),
	    
		.Sync_Out							()
	);
*/
    //==================================================================================================
    // Include Files:
    // (none)

    //==================================================================================================
    // Register Declarations:
    
    // Flip-flops, i.e., outputs of synchronous blocks:
    // (none)

    // Outputs of combinatorial blocks:
    // (none)
            
    //==================================================================================================
    // Wire Declarations:
    
    // Outputs of instantiated modules:

	wire			[Width-1:0]				Intermediate;			
//	wire			[Width-1:0]				Sync_Out;			// No need to re-declare primary output

    // Declarations for combinatorial assignments:
    // (none)

    //==================================================================================================
    // Wire Assignments:
    // (none)

    //==================================================================================================
    // Arrays of Instances:
    // (none)

    //==================================================================================================
    // Component Instantiations:

	DFF_Variable_Width	#(Width)
	Intermediate_reg
	(
		.D									(Async_In[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Intermediate[Width-1:0])
	);

	//------------------------------------------------------------------------------------

	DFF_Variable_Width	#(Width)
	Sync_Out_Reg
	(
		.D									(Intermediate[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Sync_Out[Width-1:0])
	);

    //==================================================================================================
    // Combinatorial Blocks:
    // (none)

    //==================================================================================================
    // Synchronous Blocks:
    // (none)

    //==================================================================================================

endmodule
