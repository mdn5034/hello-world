//======================================================================================================

module DFF_Variable_Width
(
	D,
	clk,

	Q
);

    parameter                               Width = 1;                  // Default width is 8 but will
                                                                        // almost always be redefined.
    input           [Width-1:0]             D;
    input                                   clk;

    output          [Width-1:0]             Q;

//	Template:
	//------------------------------------------------------------------------------------
/*
	DFF_Variable_Width	#()
	DFF_Variable_Width
	(
		.D									(),
		.clk								(),
	    
		.Q									()
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

//	wire			[Width-1:0]				Q;					// No need to re-declare primary output

    // Declarations for combinatorial assignments:
    // (none)

    //==================================================================================================
    // Wire Assignments:
    // (none)

    //==================================================================================================
    // Arrays of Instances:

	// This is an array of Xilinx "FD" instances, which are simple D Flip-Flops.  The FD verilog file
	// is located in the unisims directory.  Here is the path:

	// c:/Xilinx/13.2/ISE_DS/verilog/src/unisims

	FD i[Width-1:0] (Q, clk, D);			// MUST BE IN SAME ORDER AS PRIMITIVE'S VERILOG FILE ORDER, 
											// BUT NAMES ARE THIS LEVEL'S NAMES.

	// The IF/THEN/ELSE way of inferring flip-flops doesn't work, only because Xilinx isn't smart about
	// being able to initialize inferred flip-flops for simulation.  Which means, in turn, that you have
	// to use a global reset or you can't simulate because everything is declared "unknown" for all
	// time.

	// No, you have to use Xilinx's own flip-flop model, which initializes correctly in simulation 
	// without need for a global reset.

    //==================================================================================================
    // Component Instantiations:
    // (none)

    //==================================================================================================
    // Combinatorial Blocks:
    // (none)

    //==================================================================================================
    // Synchronous Blocks:
    // (none)

    //==================================================================================================

endmodule
