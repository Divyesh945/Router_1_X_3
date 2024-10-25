interface destination_if(input bit clk);
	//declare all the signals for destination side
	logic [7:0] data_out;
	logic valid_out;
	logic read_enb;
	
	//clocking block for destination driver
	clocking ddrv_cb@(posedge clk);
		//initializing the default setup and hold time
		default input #1 output #1;
		//giving direction to the siganls for driver
		input valid_out;
		output read_enb;
	endclocking

	//clocking block for destination monitor
	clocking dmon_cb@(posedge clk);
		//initializing the default setup and hold time
		default input #1 output #1;
		//givinig direction to all the singals for the monitor
		input data_out;
		input valid_out;
		input read_enb;
	endclocking

	//modport for the destination driver
	modport DDRV_MP(clocking ddrv_cb);
	
	//modport for the destination monitor
	modport DMON_MP(clocking dmon_cb);
endinterface 
