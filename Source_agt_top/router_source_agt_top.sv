class router_source_agt_top extends uvm_env;
	//factory registration
	`uvm_component_utils(router_source_agt_top)
	
	//handle for sources agent
	router_source_agent agnth;
	//handle for environment configuration
	router_env_config m_cfg;

	//methods
	extern function new(string name="router_source_agt_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function router_source_agt_top::new(string name="router_source_agt_top", uvm_component parent);
	super.new(name, parent);
endfunction

function void router_source_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	//getting the environment configuration from the test file
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("ENV CONFIG","Cannot get() environment config from uvm_config_db. Have you set() it?")
	if(m_cfg.has_sagent)
	begin
		agnth = router_source_agent::type_id::create("agnth",this);
		//setting the source agent configuration for the below agents
		uvm_config_db #(router_source_agent_config)::set(this,"agnth*","router_source_agent_config",m_cfg.sagent_cfg);
	end
endfunction

task router_source_agt_top::run_phase(uvm_phase phase);
	uvm_top.print_topology();
endtask
