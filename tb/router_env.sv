class router_env extends uvm_env;
	//factor registration
	`uvm_component_utils(router_env)
	
	//creating handles for source and destination agent top
	router_source_agt_top sagt_top;
	router_destination_agt_top dagt_top;

	//variable bit[1:0]addr
	bit[1:0]addr;
	
	//handle for router's virtual sequencer
	router_virtual_sequencer v_sequencer;
	
	//handle for router's scoreboard
	router_sb sbh;
	
	router_env_config m_cfg;
	
	//methods
	extern function new(string name = "router_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass

function router_env::new(string name = "router_env", uvm_component parent);
	super.new(name, parent);
endfunction

function void router_env::build_phase(uvm_phase phase);
	if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	
	if(!uvm_config_db#(bit[1:0])::get(this,"","bit",addr))
		`uvm_fatal("router_env","addr getting failed")

	if(m_cfg.has_sagent)
	begin
		sagt_top = router_source_agt_top::type_id::create("sagt_top", this);
		//uvm_config_db #(router_source_agent_config)::set(this,"sagt_top.agnth*","router_source_agent_config",m_cfg.sagent_cfg);
	end

	if(m_cfg.has_dagent)
	begin
		dagt_top = router_destination_agt_top::type_id::create("dagt_top",this);
//		uvm_config_db#(router_destination_agent_config)::set(this,$sformatf("dagt_top.agnth[%0d]",i),"router_destination_agent_config",m_cfg.dagent_cfg);
	end

	//create the object for virtual sequencer and scoreboard
	v_sequencer = router_virtual_sequencer::type_id::create("v_sequencer",this);
	sbh = router_sb::type_id::create("sbh",this);
endfunction

function void router_env::connect_phase(uvm_phase phase);
	v_sequencer.sseqrh = sagt_top.agnth.seqrh;
	//connect the virtual sequencer dseqrh to agnth dseqrh;
	// v_sequencer.dseqrh = new[m_cfg.no_dagent];
	if(addr == 0)
		v_sequencer.dseqrh = dagt_top.agnth[0].seqrh;
	if(addr == 1)
		v_sequencer.dseqrh = dagt_top.agnth[1].seqrh;
	if(addr == 2)
		v_sequencer.dseqrh = dagt_top.agnth[2].seqrh;

	sagt_top.agnth.monh.monitor_port.connect(sbh.sfifoh.analysis_export);

	foreach(m_cfg.dagent_cfg[i])
	begin
		if(addr == i)
			dagt_top.agnth[i].monh.monitor_port.connect(sbh.dfifoh[i].analysis_export);
	end
	
endfunction
