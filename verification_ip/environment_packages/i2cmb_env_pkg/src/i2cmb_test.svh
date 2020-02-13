class i2cmb_test extends ncsu_component#(.T(wb_transaction));

  i2cmb_env_configuration  cfg;
  i2cmb_environment        env;
  i2cmb_generator          gen;


  function new(string name = "", ncsu_component_base parent = null);
    super.new(name,parent);
    cfg = new("cfg");
    cfg.sample_coverage();
    env = new("env",this);
    env.set_configuration(cfg);
    env.build();
    gen = new("gen",this);
    gen.set_agent(env.get_p0_agent());
    
    gen.set_agent0(env.get_p1_agent());
    // gen.set_agent2(env.get_p2_agent());
    // gen.set_agent3(env.get_p3_agent());
    // gen.set_agent4(env.get_p4_agent());
    // gen.set_agent5(env.get_p5_agent());
    // gen.set_agent6(env.get_p6_agent());
    // gen.set_agent7(env.get_p7_agent());
    // gen.set_agent8(env.get_p8_agent());
    // gen.set_agent9(env.get_p9_agent());
    // gen.set_agent10(env.get_p10_agent());
    // gen.set_agent11(env.get_p11_agent());
    // gen.set_agent12(env.get_p12_agent());
    // gen.set_agent13(env.get_p13_agent());
    // gen.set_agent14(env.get_p14_agent());
    // gen.set_agent15(env.get_p15_agent());
    // gen.set_agent16(env.get_p16_agent());
    

    
  endfunction

  virtual task run();
     env.run();
     gen.run();
  endtask

endclass
