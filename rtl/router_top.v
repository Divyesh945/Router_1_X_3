module router_top(input clk, resetn, read_enb_0, read_enb_1, read_enb_2, pkt_valid,
                  input [7:0]data_in,
                  output [7:0] data_out_0,data_out_1, data_out_2,
                  output valid_out_0, valid_out_1, valid_out_2,
                  output error, busy);

wire [2:0] write_enb;
wire [7:0]d_in;

router_fifo fifo_0(.clk(clk), 
				 .resetn(resetn),
				 .read_enb(read_enb_0), 
				 .write_enb(write_enb[0]), 
				 .soft_reset(soft_reset_0), 
				 .lfd_state(lfd_state),
				 .data_in(d_in), 
				 .data_out(data_out_0), 
				 .empty(empty_0),  
				 .full(full_0));
                     
				 
router_fifo fifo_1(.clk(clk), 
				 .resetn(resetn),
				 .read_enb(read_enb_1), 
				 .write_enb(write_enb[1]), 
				 .soft_reset(soft_reset_1), 
				 .lfd_state(lfd_state),
				 .data_in(d_in), 
				 .data_out(data_out_1), 
				 .empty(empty_1),  
				 .full(full_1));
				 
				 
router_fifo fifo_2(.clk(clk), 
				 .resetn(resetn), 
				 .read_enb(read_enb_2), 
				 .write_enb(write_enb[2]), 
				 .soft_reset(soft_reset_2), 
				 .lfd_state(lfd_state),
				 .data_in(d_in), 
				 .data_out(data_out_2), 
				 .empty(empty_2),  
				 .full(full_2));
                  
router_fsm fsm(.clk(clk), 
			 .resetn(resetn), 
			 .pkt_valid(pkt_valid), 
			 .low_pkt_valid(low_pkt_valid), 
			 .parity_done(parity_done), 
			 .data_in(data_in[1:0]), 
			 .soft_reset_0(soft_reset_0), 
			 .soft_reset_1(soft_reset_1), 
			 .soft_reset_2(soft_reset_2), 
			 .fifo_full(fifo_full), 
			 .fifo_empty_0(empty_0), 
			 .fifo_empty_1(empty_1), 
			 .fifo_empty_2(empty_2),
			 .detect_add(detect_add), 
			 .ld_state(ld_state), 
			 .laf_state(laf_state), 
			 .full_state(full_state), 
			 .write_enb_reg(write_enb_reg),
			 .rst_int_reg(rst_int_reg), 
			 .lfd_state(lfd_state), 
			 .busy(busy));
                  
                  
router_sync synchronizer(.clk(clk), 
					   .resetn(resetn), 
					   .read_enb_0(read_enb_0), 
					   .read_enb_1(read_enb_1), 
					   .read_enb_2(read_enb_2), 
					   .empty_0(empty_0),
					   .empty_1(empty_1), 
					   .empty_2(empty_2), 
					   .detect_add(detect_add), 
					   .write_enb_reg(write_enb_reg), 
					   .full_0(full_0), 
					   .full_1(full_1),
					   .full_2(full_2), 
					   .data_in(data_in[1:0]), 
					   .fifo_full(fifo_full),  
					   .soft_reset_0(soft_reset_0), 
					   .soft_reset_1(soft_reset_1), 
					   .soft_reset_2(soft_reset_2), 
					   .write_enb(write_enb), 
					   .vld_out_0(valid_out_0), 
					   .vld_out_1(valid_out_1), 
					   .vld_out_2(valid_out_2));
                  
                  
router_reg register(.clk(clk), 
				  .resetn(resetn), 
				  .pkt_valid(pkt_valid), 
				  .fifo_full(fifo_full), 
				  .rst_int_reg(rst_int_reg), 
				  .detect_add(detect_add),
				  .ld_state(ld_state), 
				  .laf_state(laf_state), 
				  .full_state(full_state), 
				  .lfd_state(lfd_state),
				  .data_in(data_in),
				  .parity_done(parity_done), 
				  .low_pkt_valid(low_pkt_valid), 
				  .err(error), 
				  .dout(d_in));
                  
endmodule