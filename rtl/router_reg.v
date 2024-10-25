module router_reg(input clk, resetn, pkt_valid,
				   input fifo_full, rst_int_reg, detect_add, ld_state, laf_state, full_state, lfd_state,
				   input [7:0]data_in,
				   output reg parity_done, low_pkt_valid, err,
				   output reg [7:0] dout);
                       
reg [7:0] header_byte, fifo_full_state_byte, internal_parity_byte, packet_parity_byte;
                       
                       

                         
always@(posedge clk)
begin 
	if(!resetn)
	begin 
		dout <= 8'b0;
		fifo_full_state_byte <=0;
	end
	else if (detect_add && pkt_valid && data_in[1:0]!=3)
		dout <= dout;
	else if (lfd_state)
		dout<= header_byte;
	else if (ld_state && !fifo_full)
		dout<= data_in;
	else if (ld_state && fifo_full)
		fifo_full_state_byte <= data_in;
	else if (laf_state)
		dout <= fifo_full_state_byte;
	else
		dout <= dout;
end

//header logic
always@(posedge clk)
begin
	if(!resetn)
		header_byte<=8'b0;
	 else if (detect_add && pkt_valid && data_in[1:0]!=3)
		header_byte <= data_in;
	 else 
		header_byte<=header_byte;
end    
                            
//internal parity
always@(posedge clk)
begin
	if(!resetn)
		internal_parity_byte <= 8'b0;
	else if (detect_add)
		internal_parity_byte <= 8'b0;
//                             else if (lfd_state)
	else if (lfd_state && pkt_valid)
		internal_parity_byte <= internal_parity_byte^ header_byte;
	else if (pkt_valid && ld_state && !full_state)
		internal_parity_byte <= internal_parity_byte^data_in;
	else 
		internal_parity_byte<=internal_parity_byte;
end
                             
//packet parity
always@(posedge clk)
begin
	if(!resetn)
		packet_parity_byte <= 8'b0;
	else if (detect_add)
		packet_parity_byte <= 8'b0;
	else if((ld_state && !fifo_full && !pkt_valid) || (laf_state && !parity_done && low_pkt_valid))
		packet_parity_byte <= data_in;
end

//low packet valid
always@(posedge clk)
begin
	if(!resetn)
		low_pkt_valid <= 0;
	else if(rst_int_reg)
		low_pkt_valid <= 0; 
	else if (ld_state && !pkt_valid)
		low_pkt_valid <=  1;
end                                    

//parity done
always@(posedge clk)
begin
	if(!resetn)
		parity_done <= 0;
	else if(detect_add)
		parity_done <= 0; 
	else if ((ld_state && !pkt_valid && !fifo_full) || (laf_state && low_pkt_valid && !parity_done))
		parity_done <=  1;
end
                             
//error
always@(posedge clk)
begin
	if(!resetn)
		err <= 0;
	else if (parity_done)
	begin
		if (packet_parity_byte == internal_parity_byte)
			err <= 0;
		else
			err <= 1;
	end
	else 
		err <= 0;
end

endmodule