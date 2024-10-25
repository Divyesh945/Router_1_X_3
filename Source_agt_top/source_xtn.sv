class source_xtn extends uvm_sequence_item;
	//variables
	rand bit[7:0] header;
	rand bit[7:0] payload[];
	rand bit [7:0] parity;
	bit error;
	//factory registration
	`uvm_object_utils(source_xtn)
//		`uvm_field_int(header, UVM_ALL_ON)
//		`uvm_field_int(payload, UVM_ALL_ON)
//		`uvm_field_int(parity, UVM_ALL_ON)
//	`uvm_object_utils_end

	//constraints
	constraint c1 { header [1:0] != 2'b11;}
	constraint c2 { payload.size == header[7:2];}
	constraint c3 { header[7:2] != 0;};

	//post_randomize function
	function void post_randomize();
		parity = header ^ 0;
		foreach(payload[i])
			parity = parity ^ payload[i];
	endfunction

	//methods 
	extern function new(string name = "source_xtn");
	extern function void do_copy(uvm_object rhs);
	extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
	extern function void do_print(uvm_printer printer);
endclass

//constructor function
function source_xtn::new(string name ="source_xtn");
	super.new(name);
endfunction

//do_copy function
function void source_xtn::do_copy(uvm_object rhs);
	source_xtn rhs_;
	
	if(!$cast(rhs_, rhs))
		`uvm_fatal("do_copy","do copy casting failed")
	super.do_copy(rhs);
	header = rhs_.header;
	foreach(payload[i])
		payload[i] = rhs_.payload[i];
	parity = rhs_.parity;
endfunction

//do_compare function
function bit source_xtn::do_compare(uvm_object rhs, uvm_comparer comparer);
	source_xtn rhs_;
	bit payload_true;
	if(!$cast(rhs_, rhs))
	begin
		`uvm_fatal("do_compare","do compare casting failed")
		return 0;
	end

	foreach(payload[i])
	begin
		if(payload[i] != rhs_.payload[i])
		begin
			`uvm_error("do_compare","do_compare failed for payload")
			return 0;
		end
	end
	payload_true = 1;
	return super.do_compare(rhs,comparer) &&
	header == rhs_.header &&
	payload_true&&
	parity == rhs_.parity;
endfunction 

//do print function
function void source_xtn::do_print(uvm_printer printer);
	super.do_print(printer);	
	printer.print_field("header", this.header, 8, UVM_BIN);
	foreach(payload[i])
		printer.print_field($sformatf("payload[%0d]",i), this.payload[i], 8, UVM_DEC);
	printer.print_field("parity", this.parity, 8, UVM_DEC);
	printer.print_field("error", this.error, 8, UVM_DEC);
endfunction