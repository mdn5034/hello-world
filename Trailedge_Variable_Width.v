module Trailedge_Variable_Width
(
    sres,			
    ld_en,			
    Level_In,
    clk,

    Pulse_Out_d
);
    
    parameter                               Width = 1;                  // Default width is 1 but will
                                                                        // almost always be redefined.
    input                                   sres;			
    input                                   ld_en;			
    input           [Width-1:0]             Level_In;
    input                                   clk;

    output          [Width-1:0]             Pulse_Out_d;
// 	Template:
    //------------------------------------------------------------------------------------
/*
	Trailedge_Variable_Width	#(1)
	Trailedge_Variable_Width
	(
		.sres								(1'b 0),		
		.ld_en 								(1'b 1),		
		.Level_In							(),
		.clk								(),
	    
		.Pulse_Out_d						()
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

    wire            [Width-1:0]             Level_Delay;

    // Declarations for combinatorial assignments:
											
//	wire			[Width-1:0]				Pulse_Out_d;		// No need to re-declare primary output

    //==================================================================================================
    // Wire Assignments:
    
	assign			Pulse_Out_d[Width-1:0]	=	~Level_In[Width-1:0] & Level_Delay[Width-1:0];

    //==================================================================================================
    // Component Instantiations:
    
	Register_Variable_Width	#(Width)
	Level_Delay_reg
	(
		.sres								(sres),
		.ld_en								(ld_en),
	    .D									(Level_In[Width-1:0]),
		.clk								(clk),
	    
		.Q									(Level_Delay[(Width-1):0])
	);

    //===================================================================================================

endmodule


