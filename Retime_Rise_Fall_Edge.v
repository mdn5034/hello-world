module Retime_Rise_Fall_Edge
(
	sres,
	Async_In,
	clk,
    
	Sync_Out,
	Sync_Rise_Pulse_Out_d,
	Sync_Fall_Pulse_Out_d,
	Sync_Trans_Pulse_Out_d
);
    
    parameter                               Width = 1;                  // Default width is 1 but will
                                                                        // almost always be redefined.
    input                                   sres;			
    input           [Width-1:0]             Async_In;
    input                                   clk;

    output          [Width-1:0]             Sync_Out;
    output          [Width-1:0]             Sync_Rise_Pulse_Out_d;
    output          [Width-1:0]             Sync_Fall_Pulse_Out_d;
    output          [Width-1:0]             Sync_Trans_Pulse_Out_d;

//	Template:
    //------------------------------------------------------------------------------------
/*
	Retime_Rise_Fall_Edge	#()
	Retime_Rise_Fall_Edge
	(
		.sres								(),		
		.Async_In							(),
		.clk								(),
	    
		.Sync_Out							(),
		.Sync_Rise_Pulse_Out_d				(),
		.Sync_Fall_Pulse_Out_d				(),
		.Sync_Trans_Pulse_Out_d				()
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
											
	wire			[Width-1:0]				Sync_Rise_Pulse_Out_d;
	wire			[Width-1:0]				Sync_Fall_Pulse_Out_d;
	wire			[Width-1:0]				Sync_Trans_Pulse_Out_d;

    //==================================================================================================
    // Wire Assignments:
    
	assign Sync_Rise_Pulse_Out_d[Width-1:0]	= 	(
													Sync_Out[Width-1:0] 
													& 
													~Sync_Out_Delay[Width-1:0]
												);

	assign Sync_Fall_Pulse_Out_d[Width-1:0]	= 	(
													~Sync_Out[Width-1:0] 
													& 
													Sync_Out_Delay[Width-1:0]
												);

	assign Sync_Trans_Pulse_Out_d[Width-1:0]
											= 	(
													Sync_Rise_Pulse_Out_d[Width-1:0] 
													| 
													Sync_Fall_Pulse_Out_d[Width-1:0]
												);

    //==================================================================================================
    // Component Instantiations:
    
	Register_Variable_Width	#(Width)
	Intermediate_reg
	(
		.sres								(sres),
		.ld_en								(1'b 1),
	    .D									(Async_In[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Intermediate[(Width-1):0])
	);

    //------------------------------------------------------------------------------------

	Register_Variable_Width	#(Width)
	Sync_Out_reg
	(
		.sres								(sres),
		.ld_en								(1'b 1),
	    .D									(Intermediate[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Sync_Out[(Width-1):0])
	);

    //------------------------------------------------------------------------------------

	Register_Variable_Width	#(Width)
	Sync_Out_Delay_reg
	(
		.sres								(sres),
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


