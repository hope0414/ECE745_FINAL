class wb_transaction extends ncsu_transaction;
  `ncsu_register_object(wb_transaction)

       bit [1:0] addr;
       bit [7:0] data;
     // int num_clocks;
      bit wb_op;
      bit interrupt;
      //bit we;
      int loop;
      bit wr;




  function new(string name="");
    super.new(name);
  endfunction

  virtual function string convert2string();
     return {super.convert2string(),$sformatf("adress:0x%x data:0x%x", addr, data)};
  endfunction
/*
  function bit compare(wb_transaction rhs);
    return ((this.addr  == rhs.addr ) &&
            (this.data == rhs.data) &&
            (this.we == rhs.we));
  endfunction
*/
endclass
