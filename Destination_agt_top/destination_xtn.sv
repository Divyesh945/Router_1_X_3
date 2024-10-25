class destination_xtn extends uvm_sequence_item;
    bit[7:0] header;
    bit [7:0] payload[];
    bit [7:0] parity;
    rand bit[9:0] delay;
    bit read_enb;
    bit valid_out;
    //factory registration 
    `uvm_object_utils(destination_xtn)

    extern function new(string name="destination_xtn");
    extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    extern function void do_print(uvm_printer printer);
endclass

function destination_xtn::new(string name="destination_xtn");
    super.new(name);
endfunction

function bit destination_xtn::do_compare(uvm_object rhs, uvm_comparer comparer);
    destination_xtn rhs_;
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
            `uvm_fatal("do_compare","do_compare failed for payload")
            return 0;
        end
    end
    payload_true = 1;
    return super.do_compare(rhs,comparer) &&
    header == rhs_.header &&
    payload_true &&
    parity == rhs_.parity;
endfunction

function void destination_xtn::do_print(uvm_printer printer);
    super.do_print(printer);
    printer.print_field("header",this.header, 8, UVM_BIN);
    foreach(payload[i])
        printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8, UVM_DEC);
    printer.print_field("parity",this.parity, 8, UVM_DEC);
    printer.print_field("read_enb",this.read_enb,1, UVM_DEC);
    printer.print_field("valid_out",this.valid_out,1,UVM_DEC);
    printer.print_field("delay",this.delay,10, UVM_DEC);
endfunction
  