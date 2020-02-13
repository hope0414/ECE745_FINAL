class coverage extends ncsu_component#(.T(wb_transaction));

  i2cmb_env_configuration     configuration;
  wb_transaction  covergae_transaction;
  //header_type_t         header_type;
  reg_type_t		reg_type;

  covergroup coverage_cg;
  	option.per_instance = 1;
    option.name = get_full_name();
    reg_type: coverpoint reg_type;

  endgroup

  function void set_configuration(i2cmb_env_configuration cfg);
  	configuration = cfg;
  endfunction

  function new(string name = "", ncsu_component_base  parent = null);
    super.new(name,parent);
    coverage_cg = new;
  endfunction

  virtual function void nb_put(T trans);
    $display({get_full_name()," ",trans.convert2string()});
    reg_type = reg_type_t'(trans.addr);
    //header_type = header_type_t'(trans.header[63:60]);
    //loopback    = configuration.loopback;
    //invert      = configuration.invert;
    coverage_cg.sample();
  endfunction

endclass
