class router_source_driver extends uvm_driver#(source_xtn); //parametrized it with the source xtns file after wards
	//factory registration
	`uvm_component_utils(router_source_driver)

	//virtual interface
	virtual source_if.SDRV_MP sif;
	
	//source agent configuration
	router_source_agent_config m_cfg;
	
	//methods
	extern function new(string name="router_source_driver", uvm_component parent);
	extern function void build_phase (uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(source_xtn req);
	extern function void report_phase(uvm_phase phase);
endclass

//constructor function
function router_source_driver::new(string name="router_source_driver",uvm_component parent);
	super.new(name, parent);
endfunction

function void router_source_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db#(router_source_agent_config)::get(this,"","router_source_agent_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction

function void router_source_driver::connect_phase(uvm_phase phase);
	//connect the virtual interface;
	this.sif = m_cfg.sif;
endfunction

task router_source_driver::run_phase(uvm_phase phase);

	forever
	begin
		seq_item_port.get_next_item(req);
			@(sif.sdrv_cb);
		sif.sdrv_cb.resetn <= 1'b0;
			@(sif.sdrv_cb);
		sif.sdrv_cb.resetn <= 1'b1;
		send_to_dut(req);
		seq_item_port.item_done();
	end
endtask	

task router_source_driver::send_to_dut(source_xtn req);
	`uvm_info(get_type_name(), $sformatf("Report: Router source driver sent %s", req.sprint()), UVM_LOW)

	while(sif.sdrv_cb.busy != 0)
		@(sif.sdrv_cb);
	sif.sdrv_cb.pkt_valid <= 1'b1;
	sif.sdrv_cb.data_in <= req.header;
	@(sif.sdrv_cb);
	foreach(req.payload[i])
	begin
		while(sif.sdrv_cb.busy != 0)
			@(sif.sdrv_cb);
		sif.sdrv_cb.data_in <=req.payload[i];
		@(sif.sdrv_cb);
	end	
	while(sif.sdrv_cb.busy != 0)
		@(sif.sdrv_cb);
	sif.sdrv_cb.pkt_valid <= 1'b0;
	sif.sdrv_cb.data_in <= req.parity;

	//incrementing the transaction	
	m_cfg.drv_data_sent_cnt++;
endtask

// UVM report_phase
function void router_source_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Router source driver sent %0d transactions", m_cfg.drv_data_sent_cnt), UVM_LOW)
endfunction
