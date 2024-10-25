class router_destination_agt_top extends uvm_env;
	`uvm_component_utils(router_destination_agt_top)
	//dynamic handle for destination agents
	router_destination_agent agnth[];
	//handle for environment configuration
	router_env_config m_cfg;
	
	//methods
	extern function new(string name="router_destination_agt_top", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function router_destination_agt_top::new(string name="router_destination_agt_top", uvm_component parent);
	super.new(name, parent);
endfunction

function void router_destination_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	//getting  the environment configuration from the test file
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal("ENV CONFIG","Cannot get() environment config from uvm_config_db. Have you set() it?")
	
	if(m_cfg.has_dagent)
	begin
		agnth = new[m_cfg.no_dagent];
		foreach(agnth[i])
		begin
			agnth[i] = router_destination_agent::type_id::create($sformatf("agnth[%0d]",i), this);
		    uvm_config_db #(router_destination_agent_config)::set(this,$sformatf("agnth[%0d]*",i),"router_destination_agent_config",m_cfg.dagent_cfg[i]);
		end
	end
endfunction

task router_destination_agt_top::run_phase(uvm_phase phase);
//	uvm_top.print_topology();
endtask	
