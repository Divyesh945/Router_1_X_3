class router_dbase_seq extends uvm_sequence#(destination_xtn);
    //factory registration
    `uvm_object_utils(router_dbase_seq)

    //methods
    extern function new(string name="router_dbase_seq");
endclass

function router_dbase_seq::new(string name="router_dbase_seq");
    super.new(name);
endfunction

//-----------------2nd class---------------------------------//
//read enable within 30 clock cycle

class router_read_enb_destination_xtn extends router_dbase_seq;
    //factory registration
    `uvm_object_utils(router_read_enb_destination_xtn)

    //methods
    extern function new(string name="router_read_enb_destination_xtn");
    extern task body();
endclass

//constructor function
function router_read_enb_destination_xtn::new(string name="router_read_enb_destination_xtn");
    super.new(name);
endfunction

//task body
task router_read_enb_destination_xtn::body();
    req = destination_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {delay inside {[14:29]}; })
    `uvm_info("ROUTER_DESTINATION_SEQUENCE",$sformatf("printit from sequence \n %s", req.sprint()),UVM_HIGH)
    finish_item(req);
endtask

//-----------------3rd class---------------------------------//
//read enable after 30 clock cycle

class router_not_read_enb_destination_xtn extends router_dbase_seq;
    //factory registration
    `uvm_object_utils(router_not_read_enb_destination_xtn)

    //methods
    extern function new(string name="router_not_read_enb_destination_xtn");
    extern task body();
endclass

//constructor function
function router_not_read_enb_destination_xtn::new(string name="router_not_read_enb_destination_xtn");
    super.new(name);
endfunction

//task body
task router_not_read_enb_destination_xtn::body();
    req = destination_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {delay inside {[30:50]}; })
    //assert(req.randomize() with {delay == 1023; })
    `uvm_info("ROUTER_DESTINATION_SEQUENCE",$sformatf("printit from sequence \n %s", req.sprint()),UVM_HIGH)
    finish_item(req);
endtask

