class i2cmb_scoreboard extends ncsu_component#(.T(i2c_transaction));
  function new(string name = "", ncsu_component_base parent = null);
    super.new(name,parent);
  endfunction

  i2c_transaction trans_in;
  i2c_transaction trans_out;

  virtual function void nb_transport(input i2c_transaction input_trans, output i2c_transaction output_trans);
    $display({get_full_name()," nb_transport: expected transaction ",input_trans.convert2string()});
    this.trans_in = input_trans;
    output_trans = trans_out;
  endfunction

  virtual function void nb_put(i2c_transaction trans);
    $display({get_full_name()," nb_put: actual transaction ",trans.convert2string()});
    //redesign compare function -- wb sequence and i2c sequence
    if ( this.trans_in.compare(trans) ) $display({get_full_name()," i2c_transaction MATCH!"});
    else                                $display({get_full_name()," i2c_transaction MISMATCH!"});
    
    //$display({get_full_name()," nb_put: actual transaction ",trans.convert2string()});


    /*if(this.trans_in.addr  == trans.addr ) $display({get_full_name()," Transaction MATCH!"});
    else  $display({get_full_name()," Transaction MISMATCH!"});
	*/
  endfunction
endclass
