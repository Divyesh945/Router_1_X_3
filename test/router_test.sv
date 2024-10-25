class router_test extends uvm_test;
	`uvm_component_utils(router_test)
	
	//environment handle
	router_env envh;
	//environment config handle
	router_env_config m_tb_cfg;
	//destination agent config handle
	router_destination_agent_config dagent_cfg[];
	//source agent config
	router_source_agent_config sagent_cfg;

	//variable bit[1:0]addr
	bit [1:0]addr;
	//no of destination agents
	int no_dagent = 3;
	bit has_dagent = 1;
	bit has_sagent= 1;
	
	//class methods
	extern function new(string name = "router_test", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void config_router();
endclass

function router_test::new(string name = "router_test", uvm_component parent);
	super.new(name, parent);
endfunction

//user define function called config_router()
function void router_test::config_router();
	//creating 1 source agent configuration
	if(has_sagent)
	begin
		sagent_cfg = router_source_agent_config::type_id::create("sagent_cfg", this);
		//getting the virtual interface from top and assign it to source agent configuration
		if(!uvm_config_db #(virtual source_if)::get(this,"","s_in",sagent_cfg.sif))
			`uvm_fatal("VIF CONFIG","cannot get()interface vif from uvm_config_db. Have you set() it?")
		sagent_cfg.is_active = UVM_ACTIVE;
		m_tb_cfg.sagent_cfg = sagent_cfg;
	end
	if(has_dagent)
	begin
		dagent_cfg = new[no_dagent];
		foreach(dagent_cfg[i])
		begin	
			//object for dagent_cfg
		
			dagent_cfg[i] = router_destination_agent_config::type_id::create($sformatf("dagent_cfg[%0d]",i), this);	
			dagent_cfg[i].is_active = UVM_ACTIVE;
			//getting the virtual interface from top and assign it to repective destination agent configuration
			if(!uvm_config_db #(virtual destination_if)::get(this,"",$sformatf("d_in%0d",i), dagent_cfg[i].dif))
				`uvm_fatal("VIF CONFIG","Cannot get() interface vif from uvm_config_db. Have you set() it?")
			m_tb_cfg.dagent_cfg[i] = dagent_cfg[i];
		end
	end
	m_tb_cfg.no_dagent = no_dagent;
	m_tb_cfg.has_dagent = has_dagent;
	m_tb_cfg.has_sagent = has_sagent;
endfunction

//change the test file according the the env configuration
function void router_test::build_phase(uvm_phase phase);
	
	//creating object for environment configuration
	m_tb_cfg = router_env_config::type_id::create("m_tb_cfg");
	
	

	//creating 3 destination agent configuration
	if(has_dagent)
		m_tb_cfg.dagent_cfg = new[no_dagent];

	
	
	//calling user define function
	config_router();
	
	
	//setting the environment configuration
	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",m_tb_cfg);
	
	super.build_phase(phase);
	
	//creating the object for envh
	envh = router_env::type_id::create("envh",this);
endfunction

//-------------------------2nd class-------------------------//
//small packet test
class router_small_test extends router_test;
	//factory registration
	`uvm_component_utils(router_small_test)
	
	//declare the handle of virtual seq handle
	router_small_vseq router_seqh;
	
	extern function new(string name="router_small_test", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function router_small_test::new(string name="router_small_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_small_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	//addr = $urandom_range(0,2);
	addr = 0;
	uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
endfunction

task router_small_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	router_seqh = router_small_vseq::type_id::create("router_seqh");
	router_seqh.start(envh.v_sequencer);
	// #100;
	phase.drop_objection(this);
endtask

//-------------------------3rd class-------------------------//
//medium packet test
class router_medium_test extends router_test;
	//factory registration
	`uvm_component_utils(router_medium_test)
	
	//declare the handle of virtual seq handle
	router_medium_vseq router_seqh;
	
	extern function new(string name="router_medium_test", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function router_medium_test::new(string name="router_medium_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_medium_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	//addr = $urandom_range(0,2);
	addr = 1;
	uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
endfunction

task router_medium_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	router_seqh = router_medium_vseq::type_id::create("router_seqh");
	router_seqh.start(envh.v_sequencer);
	// #100;
	phase.drop_objection(this);
endtask

//-------------------------4th class-------------------------//
//large packet test
class router_large_test extends router_test;
	//factory registration
	`uvm_component_utils(router_large_test)
	
	//declare the handle of virtual seq handle
	router_large_vseq router_seqh;
	
	extern function new(string name="router_large_test", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function router_large_test::new(string name="router_large_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_large_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	//addr = $urandom_range(0,2);
	addr = 2;
	uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
endfunction

task router_large_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	router_seqh = router_large_vseq::type_id::create("router_seqh");
	router_seqh.start(envh.v_sequencer);
	// #100;
	phase.drop_objection(this);
endtask

//-------------------------5th class-------------------------//
//large packet test
class router_not_read_enb_test extends router_test;
	//factory registration
	`uvm_component_utils(router_not_read_enb_test)
	
	//declare the handle of virtual seq handle
	router_not_read_enb_vseq router_seqh;
	
	extern function new(string name="router_not_read_enb_test", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

function router_not_read_enb_test::new(string name="router_not_read_enb_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_not_read_enb_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	addr = $urandom_range(0,2);
	uvm_config_db#(bit[1:0])::set(this,"*","bit",addr);
endfunction

task router_not_read_enb_test::run_phase(uvm_phase phase);
	phase.raise_objection(this);
	router_seqh = router_not_read_enb_vseq::type_id::create("router_seqh");
	router_seqh.start(envh.v_sequencer);
	// #100;
	phase.drop_objection(this);
endtask
