module router_fifo( input clk, resetn, read_enb, write_enb, soft_reset, lfd_state,
             input [7:0] data_in, 
             output reg [7:0] data_out, 
             output empty, full);
             
reg [4:0] wr_ptr = 5'b0;
reg [4:0] rd_ptr =5'b0;
reg [6:0] temp;
reg temp_lfd;
reg [8:0] mem [15:0];
integer i;


assign empty = (wr_ptr == rd_ptr); // wtr pointer increase to 16
assign full = (wr_ptr== ({~rd_ptr[4], rd_ptr[3:0]})); // wtr pointer increase to 16 only the msb is 1, so negate and comparing

always @(posedge clk)
begin
	if(!resetn)
		temp_lfd <= 1'b0;
	else	
		temp_lfd <= lfd_state;
end

// read
always @ (posedge clk)
begin
	if (!resetn)
	begin
		data_out <= 8'b0; 
		rd_ptr <= 5'b0;// changed
	end
	
	else if (soft_reset) // if the read_enb s/g is not received from dst the device calls for internal reset
	begin
		data_out <= 8'bz;   
		rd_ptr <= 5'b0;// changed
	end
		 
	/*else if (temp==0 && data_out==0) //updated //I commented
	begin
		data_out <= 8'bz;
		rd_ptr <= 5'b0;
	end */
	
	else if ((read_enb == 1) && (empty ==0))
	begin
		data_out<=mem[rd_ptr[3:0]][7:0]; // no need of lfd state so [7:0]
		rd_ptr <= rd_ptr+1;
	end 
	else 
		data_out <= data_out;
 end        
      
//temp variable
always @(posedge clk)
begin
	if (!resetn)
		temp <= 7'b0;
	else if (soft_reset)
		temp <= 7'b0; 
	else if ((read_enb == 1) && (empty ==0))
	begin  
		if (mem[rd_ptr[3:0]][8]==1) // check the msb of mem pointed by rd_ptr is 1 or not i.e, checks for lfd_state
			temp <= mem[rd_ptr[3:0]][7:2] + 1'b1; // adding the parity byte's length to the payload length. avoids the address
			
		else if (temp != 0)
			temp <= temp - 1'b1; /* for each clk, the temp is decreased by 1. this is for d_out to high impedence state-> if all the data is read;
						 Acts as a counter*/
		
		else	
			temp <= temp;
	end
end
        
// write  
always @ (posedge clk)
begin
	if (!resetn)
	begin
		for(i=0; i<16; i=i+1)
			mem[i] <= 0;
		wr_ptr <= 5'b0;                    
	end
	else if (soft_reset)
	begin
		for(i=0; i<16; i=i+1)
			mem[i] <= 0;
		wr_ptr <= 5'b0;
				
	end
		
	else if ((write_enb == 1) && (full ==0))
	begin
		mem[wr_ptr[3:0]]<= {temp_lfd, data_in}; // lfd means lower first data
		wr_ptr <= wr_ptr+1;
	end 
	else 
		wr_ptr <= wr_ptr;
end               
endmodule
