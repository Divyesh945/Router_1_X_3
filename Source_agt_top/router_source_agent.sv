class router_source_agent extends uvm_agent;
	//factory 
	`uvm_component_utils(router_source_agent)
	
	//handle for source configuration
	router_source_agent_config m_cfg;
	
	//declaring handles of monitor, driver,sequencer
	router_source_driver drvh;
	router_source_sequencer seqrh;
	router_source_monitor monh;
	
	//methods
	extern function new(string name = "router_source_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

//constructor function
function router_source_agent::new(string name="router_source_agent", uvm_component parent);
	super.new(name , parent);
endfunction

function void router_source_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(router_source_agent_config)::get(this,"","router_source_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	monh = router_source_monitor::type_id::create("monh",this);
	if(m_cfg.is_active == UVM_ACTIVE)
	begin
		drvh = router_source_driver::type_id::create("drvh",this);
		seqrh = router_source_sequencer::type_id::create("seqrh",this);
	end
endfunction

function void router_source_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active == UVM_ACTIVE)
		drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction
	
	

	
