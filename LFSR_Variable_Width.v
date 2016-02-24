module LFSR_Variable_Width 
(
    ld_en,
    shift_en,
    Seed_Data_In,
    Clock,

    LSFR_Data_Out                                 
);    

    parameter                               Width = 8;                  // Default width is 8 but will
                                                                        // almost always be redefined.
    input           						ld_en;                                        
    input           						shift_en;                                        
    input   		[(Width-1):0]  			Seed_Data_In;            
    input           						Clock;

    output  		[(Width-1):0]  			LSFR_Data_Out;                                 

    //==================================================================================================
	//	Template:
/*
	LFSR_Variable_Width	#(Width) 
	LFSR_Variable_Width 
	(
	    .ld_en								(),
	    .shift_en							(),
	    .Seed_Data_In						(),
	    .Clock								(),

	    .LSFR_Data_Out                      ()           
	);    
*/
    //==================================================================================================
    // Register Declarations:
    
    // Flip-flops, i.e., outputs of synchronous blocks:
    // (none)
        
    // Outputs of combinatorial blocks:

	reg										Feedback_into_LSB_d;
    
    //===================================================================================================
    // Wire Declarations:
    
    // Outputs of instantiated modules:

	wire			[(Width-1):0]			LFSR_Data_Out;

    // Declarations for combinatorial assignments:

//	wire									Feedback_into_LSB_d;
    
    //===================================================================================================
    // Wire Assignments:

	// See Clive Maxfield's Bebop to the Boolean Boogie, p. 353

//	assign			Feedback_into_LSB_d		=	(
//                                                    LSFR_Data_Out[31]
//                                                    ^
//                                                    LSFR_Data_Out[6]
//                                                    ^
//                                                    LSFR_Data_Out[5]
//                                                    ^
//                                                    LSFR_Data_Out[1]
//												);

    //==================================================================================================
    // Component Instantiations:

	Shift_Reg_Variable_Length	#(Width)
	LFSR
	(
//		.ares_L								(ares_L),
	    .sres								(1'b 0),
		.ld_en								(ld_en),		
		.D									(Seed_Data_In[(Width-1):0]),
		.shift_en							(shift_en),
		.MSB_Out_First						(1'b 1),		
	    .Ser_In								(Feedback_into_LSB_d),
		.clk								(Clock),

		.Q									(LSFR_Data_Out[(Width-1):0]),
	    .MSB_Out							(),
	    .LSB_Out							()
	);

    //==================================================================================================
    // Combinatorial Blocks:

	// See Clive Maxfield's Bebop to the Boolean Boogie, p. 353

    always @ 	(
    				Width,
					LSFR_Data_Out[(Width-1):0]
    			)
    begin

		if (LSFR_Data_Out[(Width-1):0] == {Width{1'b 0}})
		begin
			Feedback_into_LSB_d				=	1'b 1;					// Auto-Start after reset.
		end

		else
		begin

	        case (Width)

	            //-------------------------------------------------

	            32:                                                     
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[31]
	                                                ^
	                                                LSFR_Data_Out[6]
	                                                ^
	                                                LSFR_Data_Out[5]
	                                                ^
	                                                LSFR_Data_Out[1]
												);
	            end

	            //-------------------------------------------------

	            24:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[23]
	                                                ^
	                                                LSFR_Data_Out[3]
	                                                ^
	                                                LSFR_Data_Out[2]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            16:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[15]
	                                                ^
	                                                LSFR_Data_Out[4]
	                                                ^
	                                                LSFR_Data_Out[2]
	                                                ^
	                                                LSFR_Data_Out[1]
												);
				end

	            //-------------------------------------------------

	            15:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[14]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            14:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[13]
	                                                ^
	                                                LSFR_Data_Out[4]
	                                                ^
	                                                LSFR_Data_Out[2]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            13:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[12]
	                                                ^
	                                                LSFR_Data_Out[3]
	                                                ^
	                                                LSFR_Data_Out[2]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            12:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[11]
	                                                ^
	                                                LSFR_Data_Out[5]
	                                                ^
	                                                LSFR_Data_Out[3]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            11:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[10]
	                                                ^
	                                                LSFR_Data_Out[1]
												);
				end

	            //-------------------------------------------------

	            10:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[9]
	                                                ^
	                                                LSFR_Data_Out[2]
												);
				end

	            //-------------------------------------------------

	            9:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[8]
	                                                ^
	                                                LSFR_Data_Out[3]
												);
				end

	            //-------------------------------------------------

	            8:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[7]
	                                                ^
	                                                LSFR_Data_Out[3]
	                                                ^
	                                                LSFR_Data_Out[2]
	                                                ^
	                                                LSFR_Data_Out[1]
												);
				end

	            //-------------------------------------------------

	            7:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[6]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            6:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[5]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            5:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[4]
	                                                ^
	                                                LSFR_Data_Out[1]
												);
				end

	            //-------------------------------------------------

	            4:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[3]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            3:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[2]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            2:                                                    
	            begin
	                Feedback_into_LSB_d		=	(
	                                                LSFR_Data_Out[1]
	                                                ^
	                                                LSFR_Data_Out[0]
												);
				end

	            //-------------------------------------------------

	            default:
	            begin
					Feedback_into_LSB_d			= 	1'b 0;
	            end

	            //-------------------------------------------------

	        endcase

		end
            
    end

    //==================================================================================================
    // Synchronous Blocks:
    // (none)
    
    //==================================================================================================

endmodule


