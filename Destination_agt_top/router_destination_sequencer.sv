class router_destination_sequencer extends uvm_sequencer#(destination_xtn); //right now I have not parameterized afterwards to it with destination xtns
	//factory registration
	`uvm_component_utils(router_destination_sequencer)
	
	//methods
	extern function new(string name="router_destination_sequencer",uvm_component parent);
endclass
//constructor function
function router_destination_sequencer::new(string name ="router_destination_sequencer", uvm_component parent);
	super.new(name, parent);
endfunction	