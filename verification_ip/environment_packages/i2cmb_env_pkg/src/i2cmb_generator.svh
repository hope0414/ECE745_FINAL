// class generator #(type GEN_TRANS)  extends ncsu_component#(.T(abc_transaction_base));
class i2cmb_generator extends ncsu_component#(.T(wb_transaction));


  //ncsu_component #(i2c_transaction) i2c_agent;
  //16 i2c slaves
  ncsu_component #(i2c_transaction) i2c_agent0;
  // ncsu_component #(i2c_transaction) i2c_agent1;
  // ncsu_component #(i2c_transaction) i2c_agent2;
  // ncsu_component #(i2c_transaction) i2c_agent3;
  // ncsu_component #(i2c_transaction) i2c_agent4;
  // ncsu_component #(i2c_transaction) i2c_agent5;
  // ncsu_component #(i2c_transaction) i2c_agent6;
  // ncsu_component #(i2c_transaction) i2c_agent7;
  // ncsu_component #(i2c_transaction) i2c_agent8;
  // ncsu_component #(i2c_transaction) i2c_agent9;
  // ncsu_component #(i2c_transaction) i2c_agent10;
  // ncsu_component #(i2c_transaction) i2c_agent11;
  // ncsu_component #(i2c_transaction) i2c_agent12;
  // ncsu_component #(i2c_transaction) i2c_agent13;
  // ncsu_component #(i2c_transaction) i2c_agent14;
  // ncsu_component #(i2c_transaction) i2c_agent15;

  ncsu_component #(wb_transaction) w_agent;
  //wb_agent w_agent.;
  string trans_name;
int write_data = 0;
int k;

    wb_transaction  wb_tran;
    i2c_transaction  i2c_tran;

    wb_sequence_random wb_seq;
    //wb_sequence_base wb_seq;
    string seq_name;
    ncsu_component #(wb_transaction) wb0_agent;

    i2c_transaction_random i2c_random;


//start_transaction = new[9];

  function new(string name = "", ncsu_component_base parent = null);
    super.new(name,parent);
    if ( !$value$plusargs("GEN_TRANS_TYPE=%s", seq_name))
    begin
      $display("FATAL: +GEN_TRANS_TYPE plusarg not found on command line");
      $fatal;
    end
    $display("%m found +GEN_TRANS_TYPE=%s", seq_name);
  endfunction



bit[7:0] array[];
bit[7:0] array2[];
bit[7:0] array_random[];
i2c_transaction get_i2c;
task i2c_test_flow();
	bit test = 1;
  $cast(i2c_tran,ncsu_object_factory::create("i2c_transaction"));
  //i2c_agent.bl_put(i2c_tran);

	// array2 = new[1];
	// array2[0] = 64;
	// array = new[32];
  array_random = new[257];

	foreach(array_random[k]) 
  begin 
    assert(i2c_tran.randomize());
    array_random[k] =i2c_tran.data_random;
    
  end

  forever begin

    // if(test != 0)
    // begin

      i2c_tran.read_data = array_random;
      //test--;
    // end
    // else begin
    //    i2c_tran.read_data = array2;

    //  end


		

    i2c_agent0.bl_put(i2c_tran);
    // i2c_agent1.bl_put(i2c_tran);
    // i2c_agent2.bl_put(i2c_tran);
    // i2c_agent3.bl_put(i2c_tran);
    // i2c_agent4.bl_put(i2c_tran);
    // i2c_agent5.bl_put(i2c_tran);
    // i2c_agent6.bl_put(i2c_tran);
    // i2c_agent7.bl_put(i2c_tran);
    // i2c_agent8.bl_put(i2c_tran);
    // i2c_agent9.bl_put(i2c_tran);
    // i2c_agent10.bl_put(i2c_tran);
    // i2c_agent11.bl_put(i2c_tran);
    // i2c_agent12.bl_put(i2c_tran);
    // i2c_agent13.bl_put(i2c_tran);
    // i2c_agent14.bl_put(i2c_tran);
    // i2c_agent15.bl_put(i2c_tran);

    // if(i2c_tran.op == R)
    // begin
    // if(test) test--;
    // array2[0]--;
    // end

  end




  //$display("Function II");
 // array = new[32];
 // foreach(array[k]) array[k] = 100 + k;


   // i2c_tran.read_data = array;
   // i2c_agent.bl_put(i2c_tran);
    // if(i2c_tran.op == R)  begin
    //   i2c_tran.read_data = array;
    //   i2c_agent.bl_put(i2c_tran);
    // end

endtask

task wb_test_flow();
 


  
endtask

virtual task run();
  fork
    begin
      $cast(wb_seq, ncsu_object_factory::create(seq_name));
      wb_seq.set_agent(wb0_agent);
      wb_seq.run();
      #500 $finish;
    end

    begin
      i2c_test_flow();
 

     
    end


  join_any



  // fork
  //  begin
  //     $cast(wb_tran,ncsu_object_factory::create(trans_name));
  //     read_bytes(32);
  //
  //
  //   end
  //
  //   begin
  //     $cast(i2c_tran, ncsu_object_factory::create("i2c_transaction"));
  //     forever begin
  //      i2c_agent.bl_put(i2c_tran);
  //     end
  //
  //   end
  //
  // join

endtask

  function void set_agent(ncsu_component #(wb_transaction) agent);
		wb0_agent = agent;
  endfunction

  function void set_agent0(ncsu_component #(i2c_transaction) agent);
    i2c_agent0= agent;
endfunction

//  function void set_agent1(ncsu_component #(i2c_transaction) agent);
//     i2c_agent1= agent;
// endfunction

//  function void set_agent2(ncsu_component #(i2c_transaction) agent);
//     i2c_agent2= agent;
// endfunction

//  function void set_agent3(ncsu_component #(i2c_transaction) agent);
//     i2c_agent3= agent;
// endfunction

//  function void set_agent4(ncsu_component #(i2c_transaction) agent);
//     i2c_agent4= agent;
// endfunction

//  function void set_agent5(ncsu_component #(i2c_transaction) agent);
//     i2c_agent5= agent;
// endfunction

//  function void set_agent6(ncsu_component #(i2c_transaction) agent);
//     i2c_agent6= agent;
// endfunction

//  function void set_agent7(ncsu_component #(i2c_transaction) agent);
//     i2c_agent7= agent;
// endfunction

//  function void set_agent8(ncsu_component #(i2c_transaction) agent);
//     i2c_agent8= agent;
// endfunction

//  function void set_agent9(ncsu_component #(i2c_transaction) agent);
//     i2c_agent9= agent;
// endfunction

//  function void set_agent10(ncsu_component #(i2c_transaction) agent);
//     i2c_agent10= agent;
// endfunction

//  function void set_agent11(ncsu_component #(i2c_transaction) agent);
//     i2c_agent11= agent;
// endfunction

//  function void set_agent12(ncsu_component #(i2c_transaction) agent);
//     i2c_agent12= agent;
// endfunction

//  function void set_agent13(ncsu_component #(i2c_transaction) agent);
//     i2c_agent13= agent;
// endfunction

//  function void set_agent14(ncsu_component #(i2c_transaction) agent);
//     i2c_agent14= agent;
// endfunction

//  function void set_agent15(ncsu_component #(i2c_transaction) agent);
//     i2c_agent15= agent;
// endfunction


endclass
