//======================================================================================================
// The two-channel 122 is exactly the same chip as the eight-channel 128!  You're just not allowed to ask for the upper 6 channels, but otherwise
// the serial communication is identical.

module ADC122S021_Module	
(
	X_Time_Base_96k_pulse,
	X_ADC_SerDat_Return,
	X_512x96k_1024x48k_Clk,

	X_ADC_CS_L,
	X_ADC_Clock,
	X_End_of_Conversion_pulse,
	X_ADC_SerDat_Send_d,
	X_ADC_Ch0_Captured_Word,
	X_ADC_Ch1_Captured_Word,
	X_ADC_Previous_Input_Count											// Test
);    

	input			X_Time_Base_96k_pulse;
	input			X_ADC_SerDat_Return;
	input			X_512x96k_1024x48k_Clk;

	output			X_ADC_CS_L;
	output			X_ADC_Clock;
	output			X_End_of_Conversion_pulse;
	output			X_ADC_SerDat_Send_d;
	output	[11:0]	X_ADC_Ch0_Captured_Word;
	output	[11:0]	X_ADC_Ch1_Captured_Word;
	output	[1:0]	X_ADC_Previous_Input_Count;							// Test

	// Template:
    //------------------------------------------------------------------------------------

//	ADC122S021_Module 
//	ADC122S021_Module 
//	(
//		.X_Time_Base_96k_pulse				(X_Time_Base_96k_pulse),
//		.X_ADC_SerDat_Return				(X_ADC_SerDat_Return),    
//	    .X_512x96k_1024x48k_Clk				(X_512x96k_1024x48k_Clk),
//
//		.X_ADC_CS_L							(X_ADC_CS_L),
//		.X_ADC_Clock						(X_ADC_Clock),    		
//		.X_End_of_Conversion_pulse			(X_End_of_Conversion_pulse),    		
//		.X_ADC_SerDat_Send_d				(X_ADC_SerDat_Send_d),    		
//		.X_ADC_Ch0_Captured_Word			(X_ADC_Ch0_Captured_Word[11:0]),    		
//		.X_ADC_Ch1_Captured_Word			(X_ADC_Ch1_Captured_Word[11:0]),   		
//		.X_ADC_Previous_Input_Count			(X_ADC_Previous_Input_Count[1:0])    		
//	);    

    //==================================================================================================

//	`include		"c:/Saves/ModelSim_Projects/MyProject/Source/MyProject_Includes.v"

	//==================================================================================================
	// Register Declarations:

	// Flip-flops, i.e., outputs of synchronous blocks:
	// (none)

	// Outputs of combinatorial blocks:
	// (none)
	        
	//==================================================================================================
	// Wire Declarations:

	// Outputs of instantiated modules:

	wire			X_ADC_CS_L;
	wire	[5:0]	X_ADC_Count;
	wire			X_ADC_Clock;
	wire			X_End_of_Conversion_pulse;
	wire	[11:0]	X_ADC_Shifting_Word;
	wire	[1:0]	X_ADC_Input_Count;
	wire	[1:0]	X_ADC_Previous_Input_Count;
	wire	[11:0]	X_ADC_Ch0_Captured_Word;
	wire	[11:0]	X_ADC_Ch1_Captured_Word;

    // Declarations for combinatorial assignments:

	wire			X_ADC_SerDat_Send_d;

    //==================================================================================================
    // Wire Assignments:

	assign			X_ADC_SerDat_Send_d		=	(
													(
														(X_ADC_Count[5:2] == 4'h C)
														&
														X_ADC_Input_Count[1]
													)
													| 
													(
														(X_ADC_Count[5:2] == 4'h B)
														&
														X_ADC_Input_Count[0]
													)
												);

    //==================================================================================================

//	The broad brush strokes are that we activate the CS_L line and issue 16 low-going clock pulses (the
//	clock line is normally high).  The serial data comes back as four zeroes followed by the 12-bit
//	conversion word, MSB first.  While the serial data comes back, we also send serial data which is
//	all useless except for 3 bits, which tell the converter which input we want NEXT time (the very 1st
//	conversion is always input channel zero).

//	The maximum serial clock rate for the ADC128 chip is 16 MHz, so we'll try 12.288, which is our basic
//	clock divided by four.

//	We're going to sample at 96k, which is a lot slower than this chip can run.  But that means each
// 	or our four channels gets sampled at 24k, which is plenty fast, I should think.  The chip can run
//	up to 500ksps, so we can always boost the frequeny later.  But right now, the 96k pulses are
//	convenient.

    //==================================================================================================
    // Component Instantiations:

	SRFF_NoAsyncReset
	X_ADC_CS_L_FF
	(
		.Swin_H_Rwin_L						(1'b 0),
		.S									(X_ADC_Count[5:0] == 6'h 00),
		.R									(X_Time_Base_96k_pulse),
		.clk								(X_512x96k_1024x48k_Clk),

		.Q									(X_ADC_CS_L)
	);

    //------------------------------------------------------------------------------------

	// We'll use a 64-tick frame for 16 bits.  That means 4 ticks per bit.  The count sits at zero 
	// between conversions.  Then it's bumped to max and counts down.	

	Counter_Variable_Width	#(6)
	X_ADC_Counter
	(
		.sres								(1'b 0),
		.ld_en								(X_Time_Base_96k_pulse),
		.D									(6'h 3F),
		.cnt_en								(X_ADC_Count[5:0] != 6'h 00),
		.Up_H_Down_L						(1'b 0),		
		.clk								(X_512x96k_1024x48k_Clk),
	    
		.Q									(X_ADC_Count[5:0])
	);

    //------------------------------------------------------------------------------------

	// One pulse per four ticks, which is 12.288 MHz.  So, Remember, X_ADC_Count is counting DOWN.
  
	SRFF_NoAsyncReset
	X_ADC_Clock_FF
	(
		.Swin_H_Rwin_L						(1'b 0),
		.S									(X_ADC_Count[1:0] == 2'h 3),
		.R									(X_ADC_Count[1:0] == 2'h 1),
		.clk								(X_512x96k_1024x48k_Clk),

		.Q									(X_ADC_Clock)
	);

    //------------------------------------------------------------------------------------

	Leadedge_Variable_Width	#(1)
	Leadedge_Variable_Width
	(
        .sres                             	(1'b 0),
        .ld_en                             	(1'b 1),
		.Level_In							(X_ADC_Count[5:0] == 6'h 00),
		.clk								(X_512x96k_1024x48k_Clk),
	    
		.Pulse_Out_d						(X_End_of_Conversion_pulse)
	);

    //------------------------------------------------------------------------------------
	
	// The MSB arrives from the converter first, and enters the LSB end of the shift register to slowly
	// shift upwards.  16 bits from the converter shift through this 12-bit shift register, so the first
	// four bits to arrive shift completely through the shift register to be discarded out the other 
	// side.  Only the last 12 bits to arrive remain in the shift register at the end of the frame.

	ShiftReg_Variable_Length	#(12)
	ADC_SerDat_shift_reg
	(
	    .sres								(1'b 0),
		.ld_en								(1'b 0),
		.D									(12'h 000),
		.shift_en							(X_ADC_Count[1:0] == 2'h 1),
		.MSB_Out_First						(1'b 1),		
	    .Ser_In								(X_ADC_SerDat_Return),
		.clk								(X_512x96k_1024x48k_Clk),

		.Q									(X_ADC_Shifting_Word[11:0]),
	    .MSB_Out							(),
	    .LSB_Out							()
	);

    //------------------------------------------------------------------------------------

	// This counter keeps track of which ADC input channel is being converted.  It's just a free-running
	// counter.  The contents get shifted out to the ADC to tell it which channel to convert NEXT time.	

	Counter_Variable_Width	#(2)
	X_ADC_Input_Counter
	(
	    .sres								(1'b 0),
		.ld_en								(1'b 0),
		.D									(2'h 0),
		.cnt_en								(X_Time_Base_96k_pulse),
		.Up_H_Down_L						(1'b 0),					// Scah in decreasing order		
		.clk								(X_512x96k_1024x48k_Clk),
	    
		.Q									(X_ADC_Input_Count[1:0])
	);
        	    
    //------------------------------------------------------------------------------------

	Register_Variable_Width	#(2)
	X_ADC_Previous_Input_Count_reg
	(
		.sres								(1'b 0),
		.ld_en								(X_Time_Base_96k_pulse),
		.D									(X_ADC_Input_Count[1:0]),
		.clk								(X_512x96k_1024x48k_Clk),

		.Q									(X_ADC_Previous_Input_Count[1:0])
	);

    //------------------------------------------------------------------------------------

	Register_Variable_Width	#(12)
	X_ADC_Ch0_Captured_Word_reg
	(
		.sres								(1'b 0),

		.ld_en								(
												X_End_of_Conversion_pulse
												&
												(X_ADC_Previous_Input_Count[1:0] == 2'h 0)
											),

		.D									(X_ADC_Shifting_Word[11:0]),
		.clk								(X_512x96k_1024x48k_Clk),

		.Q									(X_ADC_Ch0_Captured_Word[11:0])
	);

    //------------------------------------------------------------------------------------

	Register_Variable_Width	#(12)
	X_ADC_Ch1_Captured_Word_reg
	(
		.sres								(1'b 0),

		.ld_en								(
												X_End_of_Conversion_pulse
												&
												(X_ADC_Previous_Input_Count[1:0] == 2'h 1)
											),

		.D									(X_ADC_Shifting_Word[11:0]),
		.clk								(X_512x96k_1024x48k_Clk),

		.Q									(X_ADC_Ch1_Captured_Word[11:0])
	);

    //==================================================================================================
    // Combinatorial Blocks:
    // (none)

    //==================================================================================================
    // Synchronous Blocks:
    // (none)
        
    //==================================================================================================

endmodule


