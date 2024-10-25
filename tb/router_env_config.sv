class router_env_config extends uvm_object;
	//factory registration
	`uvm_object_utils(router_env_config)
		
	int no_dagent = 3;
	bit has_dagent = 1;
	bit has_sagent= 1;

 	router_source_agent_config sagent_cfg;
	router_destination_agent_config dagent_cfg[];
	
	//methods
	extern function new(string name = "router_env_config");
endclass
//constructor function
function router_env_config::new(string name = "router_env_config");
	super.new(name);
endfunction	
