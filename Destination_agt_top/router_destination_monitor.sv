class router_destination_monitor extends uvm_monitor; //parameterized with the source xtns file
	//factory registration
	`uvm_component_utils(router_destination_monitor)

	//vitural interface
	virtual destination_if.DMON_MP dif;
	
	//source agent configuration
	router_destination_agent_config m_cfg;

	//analysis tlm port 
	uvm_analysis_port #(destination_xtn) monitor_port;

	//methods
	extern function new(string name="router_destination_monitor", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);
endclass

function router_destination_monitor::new(string name = "router_destination_monitor", uvm_component parent);
	super.new(name, parent);
	monitor_port = new("monitor_port", this);
endfunction

function void router_destination_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_destination_agent_config)::get(this,"","router_destination_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")

endfunction

function void router_destination_monitor::connect_phase(uvm_phase phase);
	//connect the virtual interface
	this.dif = m_cfg.dif;
endfunction

task router_destination_monitor::run_phase(uvm_phase phase);
	forever
		collect_data();
endtask

task router_destination_monitor::collect_data();
	destination_xtn xtn;
	xtn = destination_xtn::type_id::create("xtn");

	while(dif.dmon_cb.read_enb!==1'b1)
	begin
		`uvm_info("Destination Monitor","Inside read enb == 0 ",UVM_HIGH)
		`uvm_info("Destination Monitor",$sformatf("inside read enbcb %s",xtn.sprint()),UVM_HIGH)
		@(dif.dmon_cb);
	end

	
	@(dif.dmon_cb);

	xtn.read_enb = dif.dmon_cb.read_enb;
	xtn.valid_out = dif.dmon_cb.valid_out;

	xtn.header = dif.dmon_cb.data_out;
	xtn.payload = new[xtn.header[7:2]];
	@(dif.dmon_cb);
	foreach(xtn.payload[i])
	begin
		xtn.payload[i] = dif.dmon_cb.data_out;
		@(dif.dmon_cb);
	end
	xtn.parity = dif.dmon_cb.data_out;

	`uvm_info(get_type_name(),$sformatf("Report: Router destination monitor send %s",xtn.sprint()),UVM_LOW)
	monitor_port.write(xtn);
	//increment mon_rcve_xtn_cnt
	m_cfg.mon_rcvd_xtn_cnt++;	
endtask

//report phase
function void router_destination_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Router Destination Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction
