module top;

	//import pakage file
	import router_test_pkg::*;
	//import uvm_pkg file
	import uvm_pkg::*;
	

	//generate the clock singal
	bit clock;
	initial begin
		clock = 1'b0;
		forever #5 clock = !clock;
	end

	//Instantiation of interface
	source_if s_in(clock);
	destination_if d_in0(clock);
	destination_if d_in1(clock);
	destination_if d_in2(clock);

	//Instantiation of dut
	router_top DUT(.clk(clock), .resetn(s_in.resetn), .read_enb_0(d_in0.read_enb), .read_enb_1(d_in1.read_enb), .read_enb_2(d_in2.read_enb), .pkt_valid(s_in.pkt_valid), .data_in(s_in.data_in), .data_out_0(d_in0.data_out), .data_out_1(d_in1.data_out), .data_out_2(d_in2.data_out), .valid_out_0(d_in0.valid_out), .valid_out_1(d_in1.valid_out), .valid_out_2(d_in2.valid_out), .error(s_in.error), .busy(s_in.busy));

	//initial begin block
	initial begin
		`ifdef VCS
		$fsdbDumpvars(0, top);
		`endif
		//set the instance of virtual interface
		uvm_config_db#(virtual source_if)::set(null,"*","s_in",s_in);
		uvm_config_db#(virtual destination_if)::set(null,"*","d_in0",d_in0);
		uvm_config_db#(virtual destination_if)::set(null,"*","d_in1",d_in1);
		uvm_config_db#(virtual destination_if)::set(null,"*","d_in2",d_in2);
		//invoke all the phases
		run_test();
	end
endmodule
