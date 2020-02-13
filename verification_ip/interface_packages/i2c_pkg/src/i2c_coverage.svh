class i2c_coverage extends ncsu_component#(.T(i2c_transaction));

  i2c_configuration configuration;

  bit [6:0] addr;
  bit [7:0] data [];
  i2c_op_t op;
  int i;
  bit [7:0] i2c_data;

  covergroup i2c_transaction_cg;
    option.per_instance = 1;
    option.name = get_full_name();

    i2c_addr: coverpoint addr;

    i2c_data: coverpoint i2c_data;

    i2c_op:   coverpoint op
    {
    bins write = {W};
    bins read = {R};
    }

    i2c_data_x_op: cross i2c_data, op;
  endgroup



  function new(string name = "", ncsu_component_base parent = null);
    super.new(name,parent);
    i2c_transaction_cg = new;
  endfunction

  function void set_configuration(i2c_configuration cfg);
    configuration = cfg;
  endfunction

  virtual function void nb_put(T trans);
    $display("i2c_coverage::nb_put() %s called",get_full_name());
		i = 0;
    addr = trans.addr;
		op = trans.op;
    if(op == W)
       data = trans.data;
    else
      data = trans.data;
    repeat(data.size()) begin
      i2c_data = data[i];
      i++;
      i2c_transaction_cg.sample();

    end


		//cmdr



    // header_type     = header_type_t'(trans.header[63:60]);
  	// header_sub_type = header_sub_type_t'(trans.header[59:56]);
  	// trailer_type    = trailer_type_t'(trans.header[7:0]);
    //i2c.sample();
  endfunction


endclass
