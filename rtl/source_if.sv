interface source_if(input bit clk);
	//declare all the singal for the source side
	bit [7:0] data_in;
	bit resetn, pkt_valid, error, busy;
	
	//clocking block for source driver
	clocking sdrv_cb @(posedge clk);
		//initializing the setup and hold time
		default input #1 output #1;
		//giving direction for all the driver signals
		output data_in;
		output resetn;
		output pkt_valid;
		input error;
		input busy;
	endclocking 

	//clocking block for source monitor
	clocking smon_cb @(posedge clk);
		//initializing the setup and hold time
		default input #1 output #1;
		//giving direction for all the monitor signals
		input data_in;
		input resetn;
		input pkt_valid;
		input error;
		input busy;
	endclocking
	
	//modport for source driver 
	modport SDRV_MP(clocking sdrv_cb);

	//modport for source monitor
	modport SMON_MP(clocking smon_cb);
endinterface 
