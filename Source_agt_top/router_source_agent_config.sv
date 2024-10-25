class router_source_agent_config extends uvm_object;
	`uvm_object_utils(router_source_agent_config)
	//declare the virtual interface
	virtual source_if sif;
	//declare is active variable as UVM_ACTIVE
	uvm_active_passive_enum is_active = UVM_ACTIVE;
	
	//static variables to count transactions
	static int drv_data_sent_cnt = 0;
	static int mon_rcvd_xtn_cnt = 0;
	
	//methods
	extern function new(string name = "router_source_agent_config");
endclass

function router_source_agent_config::new(string name = "router_source_agent_config");
	super.new(name);
endfunction
