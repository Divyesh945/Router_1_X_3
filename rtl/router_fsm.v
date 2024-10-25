module router_fsm( input clk, resetn, pkt_valid, low_pkt_valid, parity_done,
                   input [1:0] data_in,
                   input soft_reset_0, soft_reset_1, soft_reset_2, fifo_full, fifo_empty_0, fifo_empty_1, fifo_empty_2,
                   output detect_add, ld_state, laf_state, full_state, write_enb_reg, rst_int_reg, lfd_state, busy);
                   
parameter DECODE_ADDRESS = 3'b000,
		 LOAD_FIRST_DATA = 3'b001,
		 LOAD_DATA = 3'b010,
		 WAIT_TILL_EMPTY = 3'b011,
		 LOAD_PARITY = 3'b100,
		 FIFO_FULL_STATE = 3'b101,
		 CHECK_PARITY_ERROR = 3'b110,
		 LOAD_AFTER_FULL = 3'b111;
		 
reg [2:0] present, next;
reg [1:0] temp_data_in;
                   
always @(posedge clk)
begin
	if(~resetn)
		temp_data_in <= 2'b00;
	else 
		temp_data_in <= data_in;
end
                    
always @(posedge clk)
begin
	if(~resetn)
		present <= DECODE_ADDRESS;
	else 
		present <= next;
end
                    
                    
always @(*)
begin
	next <= DECODE_ADDRESS;
	case(present)
		DECODE_ADDRESS: begin
							if (((pkt_valid) && (data_in[1:0] ==2'b00) && (fifo_empty_0)) || ((pkt_valid) && (data_in[1:0] == 2'b01) && (fifo_empty_1)) 
								|| ((pkt_valid) && (data_in[1:0] == 2'b10) && (fifo_empty_2)))
					
								next <= LOAD_FIRST_DATA;
					 
							else if (((pkt_valid) && (data_in[1:0] == 2'b00) && (!fifo_empty_0)) || ((pkt_valid) && (data_in[1:0] == 2'b01) && (!fifo_empty_1))
									|| ((pkt_valid) && (data_in[1:0] == 2'b10) && (!fifo_empty_2)))
								
								next <= WAIT_TILL_EMPTY;
						
							else 
								next <= DECODE_ADDRESS;
						end
					  
		LOAD_FIRST_DATA: next <= LOAD_DATA;
	
		LOAD_DATA:  begin
						if(fifo_full)
							next <= FIFO_FULL_STATE;
						else if(!fifo_full && !pkt_valid)
							next <= LOAD_PARITY;
						else 
							next <= LOAD_DATA;
					end
                        
		FIFO_FULL_STATE:begin
							if(fifo_full)
								next <= FIFO_FULL_STATE;
							else 
								next <= LOAD_AFTER_FULL;
						end
			
		LOAD_AFTER_FULL:begin
							if (!parity_done && !low_pkt_valid)
								next <= LOAD_DATA;
							else if (!parity_done && low_pkt_valid)
								next <= LOAD_PARITY;
							else if(parity_done)
								next <= DECODE_ADDRESS;
						  end
							 
			LOAD_PARITY : next <= CHECK_PARITY_ERROR;
			
			CHECK_PARITY_ERROR : begin
									if (fifo_full)
										next <= FIFO_FULL_STATE;
									else
										next <= DECODE_ADDRESS;
								 end 
                        
			WAIT_TILL_EMPTY:begin
								if(((fifo_empty_0)&& (temp_data_in[1:0]==2'b00)) || ((fifo_empty_1)&& (temp_data_in[1:0]==2'b01)) || ((fifo_empty_2)&& (temp_data_in[1:0]==2'b10)))
									next <= LOAD_FIRST_DATA;
								else
									next <= WAIT_TILL_EMPTY;
							end 
	 endcase                             
end
          
assign detect_add = ((present==DECODE_ADDRESS)?1:0); 
assign ld_state = ((present==LOAD_DATA)?1:0);
assign laf_state = ((present==LOAD_AFTER_FULL)?1:0);
assign rst_int_reg = ((present==CHECK_PARITY_ERROR)?1:0);
assign lfd_state = ((present==LOAD_FIRST_DATA)?1:0);
assign full_state = ((present==FIFO_FULL_STATE)?1:0);
assign write_enb_reg = ((present==LOAD_PARITY || present==LOAD_AFTER_FULL || present==LOAD_DATA)?1:0);
assign busy = ((present==LOAD_AFTER_FULL || present==LOAD_FIRST_DATA || present==CHECK_PARITY_ERROR || 
			  present== FIFO_FULL_STATE || present==LOAD_PARITY  || present==WAIT_TILL_EMPTY)?1:0);
		  
                   
endmodule