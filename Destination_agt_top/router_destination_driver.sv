class router_destination_driver extends uvm_driver#(destination_xtn); //parametrized it with the source xtns file after wards
	//factory registration
	`uvm_component_utils(router_destination_driver)

	//virtual interface
	virtual destination_if.DDRV_MP dif;
	
	//source agent configuration
	router_destination_agent_config m_cfg;
	
	//methods
	extern function new(string name="router_destination_driver", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(destination_xtn req);
	extern function void report_phase(uvm_phase phase);
endclass

//constructor function
function router_destination_driver::new(string name="router_destination_driver",uvm_component parent);
	super.new(name, parent);
endfunction

function void router_destination_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(router_destination_agent_config)::get(this,"","router_destination_agent_config",m_cfg))
		`uvm_fatal("CONFIG","Cannot get() dagent config from uvm_config_db. Have you set() it?")
endfunction

function void router_destination_driver::connect_phase(uvm_phase phase);
	//connect the virtual interface;
	this.dif = m_cfg.dif;
endfunction

task router_destination_driver::run_phase(uvm_phase phase);
	forever
	begin
		seq_item_port.get_next_item(req);
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask

task router_destination_driver::send_to_dut(destination_xtn req);

	while(dif.ddrv_cb.valid_out == 0)
		@(dif.ddrv_cb);
	dif.ddrv_cb.read_enb<=1'b0;	
	repeat(req.delay)
		@(dif.ddrv_cb);
	
	dif.ddrv_cb.read_enb <= 1'b1;
	//req.read_enb = dif.ddrv_cb.read_enb;
	`uvm_info(get_type_name(), $sformatf("Report: Router destination driver sent %s, %0t",req.sprint(),$time),UVM_LOW)

	while(dif.ddrv_cb.valid_out == 1)
		@(dif.ddrv_cb);

	dif.ddrv_cb.read_enb<=1'b0;

	//incrementing the transaction
	m_cfg.drv_data_sent_cnt++;
endtask

// UVM report_phase
function void router_destination_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Router destination driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
endfunction
