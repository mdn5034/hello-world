//======================================================================================================

module Register_Variable_Width
(
	sres,			
	ld_en,			
	D,
	clk,

	Q
);

	parameter								Width = 8;                  // Default width is 8 but will
	                                                                    // almost always be redefined.
	input									sres;			
	input									ld_en;			
	input			[Width-1:0]             D;
	input									clk;

	output			[Width-1:0]				Q;

//	Template:
	//------------------------------------------------------------------------------------
/*
	Register_Variable_Width					#()
	Register_Variable_Width
	(
		.sres								(1'b 0),
		.ld_en								(1'b 1),
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

	wire			[Width-1:0]				Gated_D;

    //==================================================================================================
    // Wire Assignments:

	assign			Gated_D[Width-1:0]		=	(
													sres
													?
													{Width{1'b 0}}
													:
													(
														ld_en
														?
														D[Width-1:0]
														:
														Q[Width-1:0]
													)
												);

    //==================================================================================================
    // Arrays of Instances:
    // (none)

    //==================================================================================================
    // Component Instantiations:

	DFF_Variable_Width	#(Width)
	DFF_Variable_Width
	(
		.D									(Gated_D[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Q[Width-1:0])
	);

    //==================================================================================================
    // Combinatorial Blocks:
    // (none)

    //==================================================================================================
    // Synchronous Blocks:
    // (none)

    //==================================================================================================

endmodule
