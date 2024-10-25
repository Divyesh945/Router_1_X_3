module router_sync(input clk, resetn, read_enb_0, read_enb_1, read_enb_2,
                   input empty_0, empty_1, empty_2, detect_add, write_enb_reg, full_0, full_1, full_2,
                   input [1:0] data_in,
                   output reg fifo_full, soft_reset_0, soft_reset_1, soft_reset_2,
                   output reg [2:0] write_enb,
                   output vld_out_0,vld_out_1, vld_out_2);
                   reg [1:0] temp_data_in;
                   reg [4:0]temp_counter_0, temp_counter_1, temp_counter_2;
 
always@(posedge clk)
begin
	if (!resetn)
	begin
		temp_data_in <= 2'b0;
	end
	else if (detect_add)
		temp_data_in<= data_in;
end

always@(*)
begin
	case (temp_data_in)
		2'b00:  begin
				fifo_full <= full_0;
				if (write_enb_reg)
					write_enb <= 3'b001;
				else
					write_enb <=0;
				end
		 2'b01: begin
				fifo_full <= full_1;
				if (write_enb_reg)
					write_enb <= 3'b010;
				else
					write_enb <=0;
				end
		2'b10:  begin
				fifo_full <= full_2;
				if (write_enb_reg)
					write_enb <=3'b100;
				else
					write_enb <=0;
				end
		default:begin
				write_enb <= 0;
					fifo_full <= 0;  
				end  
	endcase            
end

assign vld_out_0 = ~empty_0;
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;
       
//soft_reset counter_0
always@(posedge clk)
begin
	if (!resetn)
	begin
		temp_counter_0 <= 0;
		soft_reset_0 <= 0;
	end
	else if (vld_out_0)
	begin
		if(~read_enb_0)
		begin
			if(temp_counter_0==29)
			begin
				soft_reset_0 <= 1'b1;
				temp_counter_0 <= 0;
			end
			else
			begin
				temp_counter_0<= temp_counter_0+ 1'b1;
				soft_reset_0 <=0;
			end
		end
		else
			temp_counter_0 <=0; 
	 end
end
           
//soft_reset counter_1
always@(posedge clk)
begin
	if (!resetn)
	begin
		temp_counter_1 <= 0;
		soft_reset_1 <= 0;
	end
	else if (vld_out_1)
	begin
		if(~read_enb_1)
		begin
			if(temp_counter_1==29)
			begin
				soft_reset_1 <= 1'b1;
				temp_counter_1 <= 0;
			end
			else
			begin
				temp_counter_1<= temp_counter_1+ 1'b1;
				soft_reset_1 <=0;
			end
		end
		else
			temp_counter_1 <=0; 
	end
end
       
//soft_reset counter_2
always@(posedge clk)
begin
	if (!resetn)
	begin
		temp_counter_2 <= 0;
		soft_reset_2 <= 0;
	end
	else if (vld_out_2)
	begin
		if(~read_enb_2)
		begin
			if(temp_counter_2==29)
			begin
				soft_reset_2 <= 1'b1;
				temp_counter_2 <= 0;
			end
			else
			begin
				temp_counter_2<= temp_counter_2+ 1'b1;
				soft_reset_2 <=0;
			 end
		end
		else
			temp_counter_2 <=0; 
	 end
end       
       
endmodule