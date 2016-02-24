//======================================================================================================

// This module first multiplies the 24.576 MHz clock by 4 to 98.304 MHz using a first DLL.  Then that 
// clock is halved using a second DLL to create the 49.152 MHz main system clock.

module Common_24p576_MHz_DLL_Module 
(
    ares_L,
    XTAL_1x_Pin,
	Recovered_1024x96k_2048x48k_Pin,
	SH_1024x96k_2048x48k_PreBuff,

	XTAL_1x_Pre_DLL,
    XTAL_4x,
    XTAL_2x,
    DLL_0_Locked,														// Test
    DLL_1_Locked														// Test
//	RH_1024x96k_2048x48k_Clk,														
//	R_512x96k_1024x48k_Clk,														
//	SH_1024x96k_2048x48k_Clk,														
//	S_512x96k_1024x48k_Clk														
);    

    input           ares_L;
    input           XTAL_1x_Pin;
    input           Recovered_1024x96k_2048x48k_Pin;
	input			SH_1024x96k_2048x48k_PreBuff;

    output          XTAL_1x_Pre_DLL;
    output          XTAL_4x;
    output          XTAL_2x;
    output          DLL_0_Locked;										// Test
    output          DLL_1_Locked;										// Test
//	output          RH_1024x96k_2048x48k_Clk;
//	output          R_512x96k_1024x48k_Clk;
//	output          SH_1024x96k_2048x48k_Clk;
//	output          S_512x96k_1024x48k_Clk;
    

    //==================================================================================================

//    `include        "c:/Saves/ModelSim_Projects/Crew_Station/Source/CS_Includes.v"

    //==================================================================================================
    // Register Declarations:
    
    // Flip-flops, i.e., outputs of synchronous blocks:
    // (none)

    // Outputs of combinatorial blocks:
    // (none)
            
    //==================================================================================================
    // Wire Declarations:
    
    // Outputs of instantiated modules:

    wire            XTAL_1x_Pre_DLL;                     				// Output of IBUFG_0

	wire			DLL_0_1x_Feedback_Send;								// Output of DLL_0
	wire			DLL_0_4x_Unbuff;									// Output of DLL_0
	wire			DLL_0_Locked;										// Output of DLL_0

	wire			DLL_0_1x_Feedback_Return;							// Output of BUFG_1

	wire			XTAL_4x;										// Output of BUFG_2

	wire	[7:0]	DLL_0_Locked_del;									// Output of DLL_0_Locked_Shift

	wire			DLL_1_4x_Feedback_Send;								// Output of DLL_1
    wire            DLL_1_2x_Unbuff;                       				// Output of DLL_1
    wire            DLL_1_Locked;										// Output of DLL_1

	wire			DLL_1_4x_Feedback_Return;							// Output of BUFG_3

    wire            XTAL_2x;                              				// Output of BUFG_4

//	wire			RH_1024x96k_2048x48k_Clk;
//	wire			R_512x96k_1024x48k_PreBuff;
//	wire			R_512x96k_1024x48k_Clk;

//	wire			SH_1024x96k_2048x48k_Clk;
//	wire			S_512x96k_1024x48k_PreBuff;
//	wire			S_512x96k_1024x48k_Clk;

    // "Soft" buffers, i.e., declarations for name changes:
    // (none)

    // Declarations for permanent assignments:
    // (none)

    //==================================================================================================
    // Wire Assignments:

    // "Soft" buffers:
    // (none)
    
    // Permanent assignments:
    // (none)

    //==================================================================================================
    // Component Instantiations:

    IBUFG   
    IBUFG_XTAL_Clock                                                  			   
    (																	
        .I                                  (XTAL_1x_Pin),   			// Clk0 comes in on pin 55.

        .O                                  (XTAL_1x_Pre_DLL)
    );
    

    //------------------------------------------------------------------------------------

// The XTAL is 24.576 MHz, which we need to multiply by four to 98.304 MHz.  Luckily, we don't have to
// set any parameters since the default multiplier is 4.

  	DCM 
	DLL_0 
	( 
	    .RST								(!ares_L), 
	    .DSSEN								(1'b 0), 
	    .PSCLK								(1'b 0), 
	    .PSEN								(1'b 0), 
	    .PSINCDEC							(1'b 0),
	    .CLKFB								(DLL_0_1x_Feedback_Return), 
		.CLKIN								(XTAL_1x_Pre_DLL), 
	     
	    .CLK0								(DLL_0_1x_Feedback_Send), 
	    .CLKFX								(DLL_0_4x_Unbuff), 
	    .CLKFX180							(), 
	    .LOCKED								(DLL_0_Locked),
		.CLK180								(), 
		.CLK270								(), 
		.CLK2X								(), 
		.CLK2X180							(), 
		.CLK90								(),
		.CLKDV								(), 
		.PSDONE								(), 
		.STATUS								()
  	);
  	
    //------------------------------------------------------------------------------------

    BUFG   
    BUFG_1   
    (
        .I                                  (DLL_0_1x_Feedback_Send),   

        .O                                  (DLL_0_1x_Feedback_Return)
    );
    
    //------------------------------------------------------------------------------------

    BUFG   
    BUFG_2   
    (
        .I                                  (DLL_0_4x_Unbuff),
        									   
        .O                                  (XTAL_4x)
    );
    
    //------------------------------------------------------------------------------------

    DFF_Variable_Width #(8)   
    DLL_0_Locked_Shift_Reg   
    (
        .ares_L                             (ares_L),

        .D                             		(
        										{
													DLL_0_Locked_del[6:0],
        											DLL_0_Locked
        										}
        									),

        .clk                             	(XTAL_4x),
        									   
        .Q                                  (DLL_0_Locked_del[7:0])
    );
    
    //------------------------------------------------------------------------------------

    CLKDLL 
    DLL_1                                                          
    (
        .RST                                (!ares_L | !DLL_0_Locked_del[7]),
        .CLKFB                              (DLL_1_4x_Feedback_Return),    
        .CLKIN                              (XTAL_4x), 

        .CLK0                               (DLL_1_4x_Feedback_Send), 
        .CLK90                              (), 
        .CLK180                             (), 
        .CLK270                             (),
        .CLK2X                              (),     
        .CLKDV                              (DLL_1_2x_Unbuff),     		// Main system clock.
        .LOCKED                             (DLL_1_Locked)
    );

    //------------------------------------------------------------------------------------

    BUFG   
    BUFG_3   
    (
        .I                                  (DLL_1_4x_Feedback_Send),
           
        .O                                  (DLL_1_4x_Feedback_Return)
    );
    
    //------------------------------------------------------------------------------------
    BUFG   
    BUFG_4   
    (
        .I                                  (DLL_1_2x_Unbuff),
           
        .O                                  (XTAL_2x)
    );
    
    //------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------
/*
    IBUFG   
    IBUFG_CY2302_Return_Clk   
    (				
        .I                                  (Recovered_1024x96k_2048x48k_Pin),   
        .O                                  (RH_1024x96k_2048x48k_Clk)
    );

    //-------------------------------------------------------------

	Counter_Variable_Width	#(1)
	Recovered_Clk_Divide_by_Two
	(
		.ares_L								(ares_L),
		.clk								(RH_1024x96k_2048x48k_Clk),
	    
		.Q									(R_512x96k_1024x48k_PreBuff)
	);

    //------------------------------------------------------------------------------------

    BUFG   
    BUFG_CY2302_Return_Clk   
    (				
        .I                                  (R_512x96k_1024x48k_PreBuff),   
        .O                                  (R_512x96k_1024x48k_Clk)
    );

    //------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------

    BUFG   
    IBUFG_SH_Clk   
    (				
        .I                                  (SH_1024x96k_2048x48k_PreBuff),   
        .O                                  (SH_1024x96k_2048x48k_Clk)
    );

    //-------------------------------------------------------------

	Counter_Variable_Width	#(1)
	Selected_Clk_Divide_by_Two
	(
		.ares_L								(ares_L),
		.clk								(SH_1024x96k_2048x48k_Clk),
	    
		.Q									(S_512x96k_1024x48k_PreBuff)
	);

    //------------------------------------------------------------------------------------

    BUFG   
    IBUFG_S_Clk   
    (				
        .I                                  (S_512x96k_1024x48k_PreBuff),   
        .O                                  (S_512x96k_1024x48k_Clk)
    );
*/
    //==================================================================================================
    // Combinatorial Blocks:
    // (none)

    //==================================================================================================
    // Synchronous Blocks:
    // (none)
        
    //==================================================================================================

endmodule