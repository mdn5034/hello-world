module Toggle_Variable_Width
(
	tog_en,
	clk,
    
	Q
);
    
    parameter                               Width = 1;                  // Default width is 1 but will
                                                                        // almost always be redefined.
    input           [(Width-1):0]           tog_en;
    input                                   clk;

    output          [(Width-1):0]           Q;

	// Template:
    //------------------------------------------------------------------------------------
/*
	Toggle_Variable_Width	#(1)
	Toggle_Variable_Width
	(
		.tog_en								(),
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
    
    // Outputs of instantiated modules:

    wire            [(Width-1):0]           Q;

    // Declarations for combinatorial assignments:
	// (none)

    //==================================================================================================
    // Wire Assignments:
	// (none)
    
    //==================================================================================================
    // Component Instantiations:
    
	DFF_Variable_Width	#(Width)
	Q_FF
	(
	    .D									(
	    										tog_en[(Width-1):0]
												^
												Q[(Width-1):0]
	    									),

		.clk								(clk),
	    
		.Q									(Q[(Width-1):0])
	);

    //==================================================================================================
    // Synchronous Blocks:

//	always @(posedge clk or negedge ares_L)						        // Asynchronous reset is handled 
//	                                                                    // by including it in the sensi-
//	                                                                    // tivity list.
//	begin
//
//		if (!ares_L)
//		begin
//			Level_Delay[Width-1:0]			<= {Width{1'b 0}};
//		end
//
//		else
//		begin
//			Level_Delay[Width-1:0]  		<= Level_In[Width-1:0];
//		end
//
//	end

    //==================================================================================================

endmodule


