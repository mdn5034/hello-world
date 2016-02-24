//======================================================================================================

module ShiftReg_Variable_Length
(
	sres,			
	ld_en,			
	D,
    shift_en,			
    MSB_Out_First,			
    Ser_In,
	clk,

	Q,
    MSB_Out,
    LSB_Out
);

	parameter								Length = 8;					// Default width is 8 but will
	                                                                    // almost always be redefined.
	input									sres;			
	input									ld_en;			
	input			[Length-1:0]			D;
    input                                   shift_en;			
    input                                   MSB_Out_First;			
    input                                   Ser_In;
	input									clk;

	output			[Length-1:0]			Q;
    output                                  MSB_Out;
    output                                  LSB_Out;
//	Template:
	//------------------------------------------------------------------------------------
/*
	ShiftReg_Variable_Length	#()
	ShiftReg_Variable_Length
	(
		.sres								(),
		.ld_en								(),
		.D									(),
		.shift_en							(),
		.MSB_Out_First						(),		
	    .Ser_In								(),
		.clk								(),
	    
		.Q									(),
	    .MSB_Out							(),
	    .LSB_Out							()
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

//	wire			[Length-1:0]			Q;					// No need to re-declare primary output

    // Declarations for combinatorial assignments:

	wire			[Length-1:0]			Gated_D;
//	wire									MSB_Out;			// No need to re-declare primary output
//	wire									LSB_Out;			// No need to re-declare primary output

    //==================================================================================================
    // Wire Assignments:

	assign			Gated_D[Length-1:0]		=	(
													sres
													?
													{Length{1'b 0}}
													:
													(
														ld_en
														?
														D[Length-1:0]
														:
														(
															shift_en
															?
															(
																MSB_Out_First
																?
																{
																	Q[(Length-2):0],
																	Ser_In
																}						// Shift into LSB, out from MSB
																:
																{
																	Ser_In,
																	Q[(Length-1):1]
																}						// Shift into LSB, out from MSB
															)
															:
															Q[Length-1:0]
														)
													)
												);

    //------------------------------------------------------------------------------------

    assign      MSB_Out                     = Q[(Length-1)];
    assign      LSB_Out                     = Q[0];

    //==================================================================================================
    // Arrays of Instances:
    // (none)

    //==================================================================================================
    // Component Instantiations:

	DFF_Variable_Width	#(Length)
	DFF_Variable_Width
	(
		.D									(Gated_D[Length-1:0]),
		.clk								(clk),
	    
		.Q									(Q[Length-1:0])
	);

    //==================================================================================================
    // Combinatorial Blocks:
    // (none)

    //==================================================================================================
    // Synchronous Blocks:
    // (none)

    //==================================================================================================

endmodule
