class router_source_sequencer extends uvm_sequencer#(source_xtn); //right now I have not parameterized but have to do it with the source sequencer
	//factory registration 
	`uvm_component_utils(router_source_sequencer)
	
	//methods
	extern function new(string name="router_source_sequencer", uvm_component parent);
endclass
//constructor function
function router_source_sequencer::new(string name = "router_source_sequencer", uvm_component parent);
	super.new(name, parent);
endfunction
