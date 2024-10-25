class router_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
	//factory registration
	`uvm_component_utils(router_virtual_sequencer)
	
	//physical handles of both the sequencer
	router_destination_sequencer dseqrh;
	router_source_sequencer sseqrh;

	//methods
	extern function new(string name = "router_virtual_sequencer", uvm_component parent);
endclass
//constructor function
function router_virtual_sequencer::new(string name = "router_virtual_sequencer", uvm_component parent);
	super.new(name, parent);
endfunction

