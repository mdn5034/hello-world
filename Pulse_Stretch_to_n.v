module	Pulse_Stretch_to_n
(
	sres,
	Trigger,
	clk,

	Q
);

    parameter                               n = 3;                      // Default "n" is 3 but will
                                                                        // almost always be redefined.

    parameter                               Width = 2;                  // "Width" must be the lowest 
                                                                        // integer m for which 2^m > n.

                                                                        // Default "Width" is 2 but will
                                                                        // almost always be redefined.
	input                                   sres;			
	input	                                Trigger;
	input                                   clk;

	output                                  Q;

//	Template:
    //------------------------------------------------------------------------------------
/*
	Pulse_Stretch_to_n #(3,2)				// First parameter is "n", 2nd is least int "m" for which 2^m >n. 
	Pulse_Stretch_to_n			
	(
		.sres								(1'b 0),
		.Trigger							(),
		.clk								(),

		.Q									()
	);
*/
    //==================================================================================================
    // Register Declarations:
    
    // Flip-flops, i.e., outputs of synchronous blocks:

    //==================================================================================================
    // Wire Declarations:
    
	wire		                            Q;
	wire		    [Width-1:0]             Count;

    //==================================================================================================
    // Component Instantiations:

	SRFF
	Duration_FF
	(
		.Swin_H_Rwin_L						(1'b 1),	// swin
		.S							        (Trigger),
				
		.R							        (
												sres
												|
												(Count[Width-1:0] == (n-1))
											),

		.clk						        (clk),
		
		.Q							        (Q)
	);

    //------------------------------------------------------------------------------------

	Counter_Variable_Width #(Width)
	Duration_counter
	(
		.sres							    (Count[Width-1:0] == (n-1)),
		.ld_en								(1'b 0),
		.D									({Width{1'b 0}}),
		.cnt_en                             (Q),		
		.Up_H_Down_L						(1'b 1),		
		.clk						        (clk),
		
		.Q							        (Count[Width-1:0])
	);

    //==================================================================================================
	// Combinatorial Blocks:
    // (none)

    //==================================================================================================
    // Synchronous Blocks:
    // (none)

    //==================================================================================================

endmodule


