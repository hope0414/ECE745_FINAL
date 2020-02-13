class i2cmb_predictor extends ncsu_component#(.T(wb_transaction));

  ncsu_component#(.T(i2c_transaction)) scoreboard;
  i2c_transaction transport_trans;
  i2c_transaction not_use;
  i2cmb_env_configuration configuration;
  wb_agent agent;

  typedef enum bit [2:0] {STOP = 3'b000, START = 3'b001, WRITE = 3'b010, READ = 3'b011} state_t;

  state_t state;
  //scoreboard #(i2c_transaction) scoreboard_handle;

  function new(string name = "", ncsu_component_base parent = null);
    super.new(name,parent);
    transport_trans = new("transport_trans");
  endfunction

  function void set_configuration(i2cmb_env_configuration cfg);
    configuration = cfg;
  endfunction

  virtual function void set_scoreboard(ncsu_component #(i2c_transaction) scoreboard);
      this.scoreboard = scoreboard;
  endfunction

  int start_flag = 0;
  int stop_flag = 0;
  int restart = 0;
  bit [7:0] tmp_write[];
  bit [7:0] tmp_read[];
  bit [7:0] tmp_addr;
  int counter_w = 0;
  int counter_r = 0;
  int addr_flag = 0;
  bit [7:0] csr_exp = 0;
  bit [7:0] cmdr_exp = 0;
  bit [7:0] dpr_exp = 0;
  bit start_f = 0;
  bit write_f = 0;
  bit nak_f = 0;
  bit count_f = 0;
  bit setbut_f = 0;

   function void get_state(wb_transaction wb_trans);
    if(wb_trans.addr == 2'b00 && wb_trans.wb_op == 1'b1) begin
      csr_exp[7:6] = wb_trans.data[7:6];
    end
    else if(wb_trans.addr == 2'b10 && wb_trans.wb_op == 1'b1) 
    begin
      cmdr_exp[2:0]=wb_trans.data[2:0];
      if(wb_trans.data[2:0] == 3'b100) begin
        cmdr_exp[7:4] = 4'b1010;
        start_f = 1;
        count_f = 0;
        nak_f = 0;
      end

      if(wb_trans.data[2:0] == 3'b101) begin
        cmdr_exp[7:4] = 4'b1000;
        start_f = 0;

      end

      if(wb_trans.data[2:0] == 3'b011) begin
        if(start_f == 0) begin
          cmdr_exp[7:4] = 4'h1;
        end
      end

      if(wb_trans.data[2:0] == 3'b010) begin
        if(start_f == 0) begin
          cmdr_exp[7:4] = 4'h1;
        end
      end

      //write
      if(wb_trans.data[2:0] == 3'b001) begin
        if(start_f == 0)
          cmdr_exp[7:4] = 4'h1;

        if(count_f==0 && dpr_exp!=8'h02 && dpr_exp!= 8'h03) begin
          cmdr_exp[7:4] = 4'b0100;
          nak_f = 1;

        end

        if(count_f>1) begin
          if(nak_f==1)
            cmdr_exp[7:4] = 4'b0100;
          else
            cmdr_exp[7:4] = 4'b1000;
        end
        count_f++;
      end

      //set_bus
      if(wb_trans.data[2:0] == 3'b110) begin
        if(dpr_exp<1) begin
          cmdr_exp[7:4] = 4'h8;
          csr_exp[3:0]=dpr_exp;
        end
        else
          dpr_exp[7:4] = 4'h1;
      end

      //wait
      if(wb_trans.data[2:0] == 3'b000) begin
        if(start_f) 
          cmdr_exp[7:4]=4'h1;
        else
          cmdr_exp[7:4]=4'h8;
      end
    end
    else if(wb_trans.addr==2'b01 && wb_trans.wb_op == 1'b1) 
      dpr_exp= wb_trans.data;

    

  endfunction




  //   if(actual == STOP)
      

  // endfunction

  // property 
  // @(trans.data)

  virtual function void nb_put(wb_transaction trans);
    //$display({get_full_name()," ",trans.convert2string()});

    //$display("Predictor transaction: %p", trans.data);
    if(trans.addr==2'b00 && trans.wb_op==1'b1) CSR: assert(trans.data==8'hc0)
    else $display("trans.data=%b, csr_pred=%b, dpr_pred=%b",trans.data,csr_exp, dpr_exp);
   // if(trans.addr==2'b10 && trans.wb_op==1'b1) assert(trans.data==cmdr_exp)
   // else $display("trans.data=%b, csr_pred=%b, dpr_pred=%b",trans.data,csr_exp, dpr_exp);
     get_state(trans);
    //catch(transport_trans, trans);
    if(start_flag == 0) begin
      if(trans.data == 8'b0000_0100 && trans.addr == 2'b10)
      begin
        start_flag = 1;
        stop_flag = 0;
      //$display("Start Flags Set: %d Stop Flags Set: %d", start_flag,stop_flag);
      end
    else begin
      if(trans.data == 8'b0000_0100 && trans.addr == 2'b10)
      begin
        //start_flag = 1;
        //  stop_flag = 1;
        if(tmp_addr[0] == 0) begin
          transport_trans.write_data = tmp_write;
        end
        else  begin
          transport_trans.read_data = tmp_read;
        end
        tmp_write = null;

        tmp_read = null;
        counter_w = 0;
        counter_r = 0;

        scoreboard.nb_transport(transport_trans, not_use);
      //$display("Start Flags Set: %d Stop Flags Set: %d", start_flag,stop_flag);
      end

    end
    end



    if(stop_flag == 0 && start_flag) begin
      if(trans.data == 8'b0000_0101 && trans.addr == 2'b10) begin
        stop_flag = 1;
        start_flag = 0;
        addr_flag = 0;
        restart = 0;
        if(tmp_addr[0] == 0) begin
          transport_trans.write_data = tmp_write;
        end
        else  begin
          transport_trans.read_data = tmp_read;
        end
        tmp_write = null;

        tmp_read = null;
        counter_w = 0;
        counter_r = 0;
         
        scoreboard.nb_transport(transport_trans, not_use);
        //$display("Start Flags Set: %d Stop Flags Set: %d Addr Flags Set: %d New Trans Data: %p", start_flag,stop_flag,addr_flag,new_trans.data);
      end
      // else if(trans.data == 8'b0000_0100 && trans.addr == 2'b10)
      // begin
      //   restart = 1;
      //   stop_flag = 1;
      //   start_flag = 0;
      //
      //   if(tmp_addr[0] == 0) begin
      //     transport_trans.write_data = tmp_write;
      //   end
      //   else  begin
      //     transport_trans.read_data = tmp_read;
      //   end
      //   tmp_write = null;
      //
      //   tmp_read = null;
      //   counter_w = 0;
      //   counter_r = 0;
      //   scoreboard.nb_transport(transport_trans, not_use);
      // end
    end


    if(stop_flag == 0 && (start_flag || restart) && trans.addr == 2'b01) begin
      if(addr_flag == 0) begin

        tmp_addr = trans.data;  
        addr_flag = 1;
        end
      else if(tmp_addr[0] == 0)begin
        transport_trans.op = W;
        tmp_write = new[counter_w+ 1](tmp_write);
        tmp_write[counter_w] = trans.data;
        counter_w++;
      end
      else begin
        transport_trans.op = R;
        tmp_read = new[counter_r+ 1](tmp_read);
        tmp_read[counter_r] = trans.data;
        counter_r++;
      end
    //  end
    end


    //  if(transport_trans.op == W)
    //     $display("pred write trans: %p", transport_trans.write_data);
    //
    // else
    //     $display("pred read trans: %p", transport_trans.read_data);
    // scoreboard.nb_transport(transport_trans, not_use);
  endfunction

endclass
