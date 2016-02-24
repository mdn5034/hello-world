module Shift_Reg_Var_Len_Wid
(
    sres,
	ld_en,		
	D,
	shift_en,
	MSword_Out_First,		
    Individual_Word_In,
	clk,

	Q,
    MSword_Out,
    LSword_Out
);

    parameter                               Length = 1;                 // Default length is 1 but will
                                                                        // almost always be redefined.

    parameter                               Width = 1;                 	// Default width is 1 but will
                                                                        // almost always be redefined.

    input                                   sres;			
    input                                   ld_en;			
    input           [((Length*Width)-1):0]	D;
    input                                   shift_en;			
    input                                   MSword_Out_First;			
    input           [Width-1:0]				Individual_Word_In;
    input                                   clk;

    output          [((Length*Width)-1):0]  Q;
    output          [(Width-1):0]			MSword_Out;
    output          [(Width-1):0]			LSword_Out;

//	Template:
    //------------------------------------------------------------------------------------
/*
	Shift_Reg_Var_Len_Wid	#(llll, wwww)
	Shift_Reg_Var_Len_Wid
	(
	    .sres								(),
		.ld_en								(),		
		.D									(),
		.shift_en							(),
		.MSword_Out_First					(),		
	    .Individual_Word_In					(),
		.clk								(),

		.Q									(),
	    .MSword_Out							(),
	    .LSword_Out							()
	);
*/
    //==================================================================================================
    // Register Declarations:
    
    // Flip-flops, i.e., outputs of synchronous blocks:
    
    reg          	[((Length*Width)-1):0]	Q;

    //==================================================================================================
    // Wire Declarations:
    
    // "Soft Buffer", i.e., rename:
    
    wire			[(Width-1):0]			MSword_Out;
    wire			[(Width-1):0]			LSword_Out;

    //==================================================================================================
    // Wire Assignments:
    
    // "Soft Buffer", i.e., rename:
    
    assign      MSword_Out                  = Q[((Length*Width)-1):((Length-1)*Width)];
    assign      LSword_Out                  = Q[(Width-1):0];

    //==================================================================================================
    // Synchronous Blocks:

	always @(posedge clk)						        

    begin

		if (sres)
        begin
			Q							    <= {(Length*Width){1'b 0}};
        end

	    else if (ld_en)
        begin
		    Q                               <= D;
        end

		else if (shift_en)
        begin
            if (MSword_Out_First)
            begin
			    Q					        <= {
			                                        Q[ ( ( (Length-1) * Width) - 1 ) : 0 ],
                                                    Individual_Word_In
			                                   };						// Shift into LSB, out from MSB
            end

            else
            begin
			    Q					        <= {
                                                    Individual_Word_In,
			                                        Q[ ( (Length*Width) - 1) : Width ]
			                                   };						// Shift into MSB, out from LSB
            end
        end

    end

    //==================================================================================================

endmodule