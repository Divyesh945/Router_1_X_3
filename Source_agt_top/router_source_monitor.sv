class router_source_monitor extends uvm_monitor; //parameterized with the source xtns file
	//factory registration
	`uvm_component_utils(router_source_monitor)

	//vitural interface
	virtual source_if.SMON_MP sif;
	
	//source agent configuration
	router_source_agent_config m_cfg;

	//analysis tlm port 
	uvm_analysis_port #(source_xtn) monitor_port;

	//methods
	extern function new(string name="router_source_monitor", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);
endclass

function router_source_monitor::new(string name = "router_source_monitor", uvm_component parent);
	super.new(name, parent);
	//create object for monitor_port of analysis tlm
	monitor_port = new("monitor_port", this);
endfunction

//build phase
function void router_source_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(router_source_agent_config)::get(this,"","router_source_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction
//connect phase
function void router_source_monitor::connect_phase(uvm_phase phase);
	//connect the virtual interface
	this.sif = m_cfg.sif;
endfunction
//run phase
task router_source_monitor::run_phase(uvm_phase phase);
	forever begin
		collect_data();	
	end 
endtask

task router_source_monitor::collect_data();
	//create a handle for source xtns
	source_xtn xtn;
	//create object for source xtn
	xtn = source_xtn::type_id::create("source_xtn");
		@(sif.smon_cb);	

	wait(!sif.smon_cb.busy)
	while(!sif.smon_cb.pkt_valid)
		@(sif.smon_cb);
	xtn.header = sif.smon_cb.data_in;

	xtn.payload = new[xtn.header[7:2]];
	@(sif.smon_cb);

	foreach(xtn.payload[i])
	begin
		while(sif.smon_cb.busy)
		begin
			
			@(sif.smon_cb);
		end
		xtn.payload[i] = sif.smon_cb.data_in;
		@(sif.smon_cb);
	end
	
	xtn.parity = sif.smon_cb.data_in;
	repeat(2)
	begin
 		@(sif.smon_cb);
		
	end
	
	xtn.error = sif.smon_cb.error;
	
	`uvm_info(get_type_name(), $sformatf("Report: Router source monitor sent %s", xtn.sprint()), UVM_LOW)
	monitor_port.write(xtn);
	//increment mon_rcve_xtn_cnt
	m_cfg.mon_rcvd_xtn_cnt++;
endtask

//report phase
function void router_source_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Router Source Monitor Collected %0d Transactions", m_cfg.mon_rcvd_xtn_cnt), UVM_LOW)
endfunction
