class router_sbase_seq extends uvm_sequence#(source_xtn);
	//factory registration
	`uvm_object_utils(router_sbase_seq)
	
	//variable bit[1:0]addr
	bit[1:0]addr;

	//methods
	extern function new(string name="router_sbase_seq");
endclass

function router_sbase_seq::new(string name = "router_sbase_seq");
	super.new(name);
endfunction

//-------------------------2nd class-------------------------//
//small packet sequence
class router_small_source_xtn extends router_sbase_seq;
	`uvm_object_utils(router_small_source_xtn)

	//methods
	extern function new(string name = "router_small_source_xtn");
	extern task body();
endclass

function router_small_source_xtn::new(string name ="router_small_source_xtn");
	super.new(name);
endfunction

task router_small_source_xtn::body();
	//repeat(10)
	//begin
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
			`uvm_fatal("ROUTER_SOURCE_SEQUENCE","addr getting failed")
		req=source_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {payload.size inside {[1:15]}; header[1:0]==addr;})
		`uvm_info("ROUTER_SOURCE_SEQUENCE",$sformatf("printit from sequence \n %s", req.sprint()),UVM_HIGH)
		finish_item(req);
	//end
endtask

//-------------------------3rd class-------------------------//
//medium packet sequence
class router_medium_source_xtn extends router_sbase_seq;
	`uvm_object_utils(router_medium_source_xtn)

	//methods
	extern function new(string name = "router_medium_source_xtn");
	extern task body();
endclass

function router_medium_source_xtn::new(string name ="router_medium_source_xtn");
	super.new(name);
endfunction

task router_medium_source_xtn::body();
	//repeat(10)
	//begin
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
			`uvm_fatal("ROUTER_SOURCE_SEQUENCE","addr getting failed")
		req=source_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {payload.size inside {[16:40]}; header[1:0]==addr;})
		`uvm_info("ROUTER_SOURCE_SEQUENCE",$sformatf("printit from sequence \n %s", req.sprint()),UVM_HIGH)
		finish_item(req);
	//end
endtask

//-------------------------4th class-------------------------//
//large packet sequence
class router_large_source_xtn extends router_sbase_seq;
	`uvm_object_utils(router_large_source_xtn)

	//methods
	extern function new(string name = "router_large_source_xtn");
	extern task body();
endclass

function router_large_source_xtn::new(string name ="router_large_source_xtn");
	super.new(name);
endfunction

task router_large_source_xtn::body();
	//repeat(10)
	//begin
		if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit",addr))
			`uvm_fatal("ROUTER_SOURCE_SEQUENCE","addr getting failed")
		req=source_xtn::type_id::create("req");
		start_item(req);
		assert(req.randomize() with {payload.size inside {[41:63]}; header[1:0]==addr;})
		`uvm_info("ROUTER_SOURCE_SEQUENCE",$sformatf("printit from sequence \n %s", req.sprint()),UVM_HIGH)
		finish_item(req);
	//end
endtask