module SRFF
(
	input   		Swin_H_Rwin_L,
	input   		S,
	input   		R,
	input   		clk,

	output  		Q
);

	// Template:
    //------------------------------------------------------------------------------------
/*
	SRFF
	SRFF
	(
		.Swin_H_Rwin_L						(1'b 0),	// rwin
		.S									(),
		.R									(),
		.clk								(),
	    
		.Q									()
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
    
    // Declarations for combinatorial assignments:
    // (none)

    // Outputs of instantiated modules:

//	wire			Q;											// No need to re-declare primary output

    //==================================================================================================
    // Wire Assignments:
    
//	assign			S_OR_R_is_Active_d		=	S | R;

    //==================================================================================================
    // Component Instantiations:
    
	Register_Variable_Width	#(1)
	Register_Variable_Width
	(
		.sres								(1'b 0),
		.ld_en								(S | R),
				
		.D									(
												Swin_H_Rwin_L
												?
												S 
												:
												(S & !R)
											),

		.clk								(clk),
	    
		.Q									(Q)
	);

    //===================================================================================================
	// Combinatorial Blocks:
	// (none)

    //===================================================================================================
    // Synchronous Blocks:
	// (none)

    //===================================================================================================

endmodule


