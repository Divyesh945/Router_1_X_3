class router_destination_agent extends uvm_agent;
	//factory registration
	`uvm_component_utils(router_destination_agent)
	
	//handle for destination configuratoin
	router_destination_agent_config m_cfg;
	
	//declaring handles for monitor, seqeuencer, driver
	router_destination_driver drvh;
	router_destination_monitor monh;
	router_destination_sequencer seqrh;

	//methods
	extern function new(string name="router_destination_agent", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

//constructor function
function router_destination_agent::new(string name="router_destination_agent", uvm_component parent);
	super.new(name , parent);
endfunction

function void router_destination_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(router_destination_agent_config)::get(this,"","router_destination_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	monh = router_destination_monitor::type_id::create("monh",this);
	if(m_cfg.is_active == UVM_ACTIVE)
	begin
		drvh = router_destination_driver::type_id::create("drvh",this);
		seqrh = router_destination_sequencer::type_id::create("seqrh", this);
	end
endfunction

function void router_destination_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active == UVM_ACTIVE)
		drvh.seq_item_port.connect(seqrh.seq_item_export);
endfunction

