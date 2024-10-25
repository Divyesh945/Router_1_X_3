class router_destination_agent_config extends uvm_object;
	`uvm_object_utils(router_destination_agent_config)
	//declare the destination interface
	virtual destination_if dif;
	//declare the is_active variable
	uvm_active_passive_enum is_active = UVM_ACTIVE;

	//static variables to count transactions
	static int drv_data_sent_cnt = 0;
	static int mon_rcvd_xtn_cnt = 0;
	
	//methods
	extern function new(string name = "router_destination_agent_config");
endclass
function router_destination_agent_config::new(string name = "router_destination_agent_config");
	super.new(name);
endfunction
  