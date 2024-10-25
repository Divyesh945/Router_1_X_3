class router_vbase_seq extends uvm_sequence#(uvm_sequence_item);
	
	//factory registration
	`uvm_object_utils(router_vbase_seq)
	
	//variable called addr
	bit[1:0]addr;

	//handle for virtual seqeuncer
	router_virtual_sequencer vseqrh;

	//handle for physical sequencer
	router_source_sequencer sseqrh;
	router_destination_sequencer dseqrh;

	//declare the handles for all the source sequences
	router_small_source_xtn small_sxtn;
	router_medium_source_xtn medium_sxtn;
	router_large_source_xtn large_sxtn;

	//declare the handles for all the destination sequences
	router_read_enb_destination_xtn dread_enb_xtn;
	router_not_read_enb_destination_xtn dnot_read_enb_xtn;

	//declare the handle for the environment sequence
	router_env_config m_cfg;
	//methods
	extern function new(string name="router_vbase_seq");
	extern task body();
endclass

//constructor function
function router_vbase_seq::new(string name = "router_vbase_seq");
	super.new(name);
endfunction

task router_vbase_seq::body();
	if(!uvm_config_db#(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	
	assert($cast(vseqrh,m_sequencer)) else `uvm_error("BODY","Error in $cast of virtual sequencer")

	sseqrh = vseqrh.sseqrh;
	// dseqrh=new[m_cfg.no_dagent];
	// foreach(dseqrh[i])
	dseqrh = vseqrh.dseqrh;
endtask

//-------------------------2nd class-------------------------//
//source small sequence
class router_small_vseq extends router_vbase_seq;
	//factory registration
	`uvm_object_utils(router_small_vseq)
	
	extern function new(string name="router_small_vseq");
	extern task body();
endclass

function router_small_vseq::new(string name="router_small_vseq");
	super.new(name);
endfunction

task router_small_vseq::body();
	`uvm_info("router_small_vseq","Present inside the small virtual sequence",UVM_HIGH)
	super.body();
	small_sxtn = router_small_source_xtn::type_id::create("small_sxtn");
	dread_enb_xtn = router_read_enb_destination_xtn::type_id::create("dread_enb_xtn");
	fork
		begin
			if(m_cfg.has_sagent)
				small_sxtn.start(sseqrh);
		end
		begin
			if(m_cfg.has_dagent)
			begin
					// read_enb_xtn.start(dseqrh);
					// read_enb_xtn.start(dseqrh);
					dread_enb_xtn.start(dseqrh);
			end
		end
	join
endtask

//-------------------------3rd class-------------------------//
//source medium sequence
class router_medium_vseq extends router_vbase_seq;
	//factory registration
	`uvm_object_utils(router_medium_vseq)
	
	extern function new(string name="router_medium_vseq");
	extern task body();
endclass

function router_medium_vseq::new(string name="router_medium_vseq");
	super.new(name);
endfunction

task router_medium_vseq::body();
	`uvm_info("router_medium_vseq","Present inside the small virtual sequence",UVM_HIGH)
	super.body();
	medium_sxtn = router_medium_source_xtn::type_id::create("medium_sxtn");
	dread_enb_xtn = router_read_enb_destination_xtn::type_id::create("dread_enb_xtn");
	fork
		begin
			if(m_cfg.has_sagent)
				medium_sxtn.start(sseqrh);
		end
		begin
			if(m_cfg.has_dagent)
			begin
					// read_enb_xtn.start(dseqrh);
					// read_enb_xtn.start(dseqrh);
					dread_enb_xtn.start(dseqrh);
			end
		end
	join
endtask

//-------------------------4th class-------------------------//
//source large sequence
class router_large_vseq extends router_vbase_seq;
	//factory registration
	`uvm_object_utils(router_large_vseq)
	
	extern function new(string name="router_large_vseq");
	extern task body();
endclass

function router_large_vseq::new(string name="router_large_vseq");
	super.new(name);
endfunction

task router_large_vseq::body();
	`uvm_info("router_large_vseq","Present inside the small virtual sequence",UVM_HIGH)
	super.body();
	large_sxtn = router_large_source_xtn::type_id::create("large_sxtn");
	dread_enb_xtn = router_read_enb_destination_xtn::type_id::create("dread_enb_xtn");
	fork
		begin
			if(m_cfg.has_sagent)
				large_sxtn.start(sseqrh);
		end
		begin
			if(m_cfg.has_dagent)
			begin
					// read_enb_xtn.start(dseqrh);
					// read_enb_xtn.start(dseqrh);
					dread_enb_xtn.start(dseqrh);
			end
		end
	join
endtask

//-------------------------5th class-------------------------//
//destination not read enb and source large sequence
class router_not_read_enb_vseq extends router_vbase_seq;
	//factory registration
	`uvm_object_utils(router_not_read_enb_vseq)
	
	extern function new(string name="router_not_read_enb_vseq");
	extern task body();
endclass

function router_not_read_enb_vseq::new(string name="router_not_read_enb_vseq");
	super.new(name);
endfunction

task router_not_read_enb_vseq::body();
	`uvm_info("router_not_read_enb_vseq","Present inside the small virtual sequence",UVM_HIGH)
	super.body();
	large_sxtn = router_large_source_xtn::type_id::create("large_sxtn");
	dnot_read_enb_xtn = router_not_read_enb_destination_xtn::type_id::create("dnot_read_enb_xtn");
	fork
		begin
			if(m_cfg.has_sagent)
				large_sxtn.start(sseqrh);
		end
		begin
			if(m_cfg.has_dagent)
			begin
					// read_enb_xtn.start(dseqrh);
					// read_enb_xtn.start(dseqrh);
					dnot_read_enb_xtn.start(dseqrh);
			end
		end
	join
endtask