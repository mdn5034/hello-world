module Retime_Leadedge
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
	Retime_Leadedge	#()
	Retime_Leadedge
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
    
	assign	Sync_Pulse_Out_d[Width-1:0]     = 	(
													Sync_Out[Width-1:0] 
													& 
													~Sync_Out_Delay[Width-1:0]
												);

    //==================================================================================================
    // Component Instantiations:
    
	Register_Variable_Width	#(Width)
	Intermediate_reg
	(
	    .sres								(1'b 0),
	    .ld_en								(1'b 1),
	    .D									(Async_In[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Intermediate[(Width-1):0])
	);

    //------------------------------------------------------------------------------------

	Register_Variable_Width	#(Width)
	Sync_Out_reg
	(
	    .sres								(1'b 0),
	    .ld_en								(1'b 1),
	    .D									(Intermediate[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Sync_Out[(Width-1):0])
	);

    //------------------------------------------------------------------------------------

	Register_Variable_Width	#(Width)
	Sync_Out_Delay_reg
	(
	    .sres								(1'b 0),
	    .ld_en								(1'b 1),
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

    //==================================================================================================
endmodule


