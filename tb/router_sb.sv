class router_sb extends uvm_scoreboard;
	//factory registration 
	`uvm_component_utils(router_sb)

	//4 different fifo's handle for the connecting to the scoreboard
	uvm_tlm_analysis_fifo#(source_xtn) sfifoh;
	uvm_tlm_analysis_fifo#(destination_xtn) dfifoh[];

	//handles of both the transaction file
	source_xtn sxtn;
	destination_xtn dxtn;

	//functional coverage
	covergroup router_fcov1;
		option.per_instance = 1;
		
		SRC_ADDR: coverpoint sxtn.header[1:0] {
					bins addr[] = {0,1,2};
		}
		
		SRC_PAYLOADLEN: coverpoint sxtn.header[7:2]{
					bins low = {[1:15]};
					bins mid = {[16:40]};
					bins high = {[41:63]};
		}

		SRC_ERROR: coverpoint sxtn.error; //change if there is some error..................
	endgroup
		
	covergroup router_fcov2;
		option.per_instance = 1;
		
		DST_ADDR: coverpoint dxtn.header[1:0] {
					bins addr[] = {0,1,2};
		}
		
		DST_PAYLOADLEN: coverpoint dxtn.header[7:2]{
					bins low = {[1:15]};
					bins mid = {[16:40]};
					bins high = {[41:63]};
		}
	endgroup
	
					

	//methods
	extern function new(string name="router_sb", uvm_component parent);
	extern task run_phase(uvm_phase phase);
	extern task Check();
endclass

function router_sb::new(string name="router_sb", uvm_component parent);
	super.new(name, parent);
	sfifoh = new("sfifoh", this);
	dfifoh = new[3];
	foreach(dfifoh[i])
		dfifoh[i] = new($sformatf("dfifoh[%0d]",i),this);

	router_fcov1 = new();
	router_fcov2 = new();
endfunction 

task router_sb::run_phase(uvm_phase phase);
	forever 
	begin
		sfifoh.get(sxtn);
		
		sxtn.print();
		if(sxtn.header[1:0] == 2'b00)
			dfifoh[0].get(dxtn);
		if(sxtn.header[1:0] == 2'b01)
			dfifoh[1].get(dxtn);
		if(sxtn.header[1:0] == 2'b10)
			dfifoh[2].get(dxtn);
		
		dxtn.print();
		Check();	
	end
endtask

task router_sb::Check();
	`uvm_info("router_sb","inside check",UVM_MEDIUM)
	if(sxtn.header == dxtn.header)
		`uvm_info("router_sb","Header Successfully compared", UVM_LOW)
	else
		`uvm_error("router_sb","Header did not matched")

	foreach(sxtn.payload[i])
	begin
		if(sxtn.payload[i] == dxtn.payload[i])
			`uvm_info("router_sb",$sformatf("payload[%0d] Successfully compared",i), UVM_LOW)	
		else 
			`uvm_error("router_sb",$sformatf("payload[%0d] did not matched",i))
	end

	if(sxtn.parity == dxtn.parity)
		`uvm_info("router_sb","Parity successfully compared", UVM_LOW)
	else
		`uvm_error("router_sb","parity did not matched")


	router_fcov1.sample();
	router_fcov2.sample();
endtask


