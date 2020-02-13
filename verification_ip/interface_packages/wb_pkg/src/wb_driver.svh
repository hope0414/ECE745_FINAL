class wb_driver extends ncsu_component#(.T(wb_transaction));

  function new(string name = "", ncsu_component_base parent = null);
    super.new(name,parent);
  endfunction

  virtual wb_if bus;
  wb_configuration configuration;
  wb_transaction wb_trans;

  function void set_configuration(wb_configuration cfg);
    configuration = cfg;
  endfunction

  byte FSMR;

  virtual task bl_put(wb_transaction trans);
    //$display({get_full_name()," ",trans.convert2string()});


    if(trans.wb_op == 0) begin
      //$display("wb_agent: bl_put_write");
       bus.master_write(trans.addr, trans.data);
       bus.master_read(2'b11, FSMR);
       //$display("FSMR: %b", FSMR);
       if(trans.interrupt)
        bus.wait_for_interrupt();
      //  else begin
      //   bus.master_read(2'b11, FSMR);
      //   $display("FSMR: %b", FSMR);
      //   end
    end
    else begin
      bus.master_read(trans.addr, trans.data);
      bus.master_read(2'b11, FSMR);
      //$display("FSMR: %b", FSMR);
      if(trans.interrupt)
       bus.wait_for_interrupt();
      // else begin
      //  bus.master_read(2'b11, FSMR);
      //  $display("FSMR: %b", FSMR);
      // end
      //bus.master_read(2'b11, FSMR);
    end
    //  if(trans.interrupt)
    //   bus.wait_for_interrupt();

  endtask



endclass
