class i2c_agent extends ncsu_component#(.T(i2c_transaction));

	i2c_configuration configuration;
	i2c_driver driver;
	i2c_monitor monitor;
	i2c_coverage coverage;
	ncsu_component #(i2c_transaction) subscribers[$];
	//i2cmb_scoreboard scbd;
	virtual i2c_if bus;

	function new(string name = " ", ncsu_component_base parent = null);
		super.new(name,parent);
		if(!(ncsu_config_db#(virtual i2c_if)::get(get_full_name(), this.bus))) begin;
			$display("i2c_agent::ncsu_config_db::get() call for BFM handle failed for name: %s ", get_full_name());
			$finish;
		end

	endfunction

	function void set_configuration(i2c_configuration cfg);
		configuration = cfg;

	endfunction

	virtual function void build();
		driver = new("driver", this);
		driver.set_configuration(configuration);
		driver.build();
		driver.bus = this.bus;

		if(configuration.collect_coverage) begin

      coverage = new("coverage", this);
      coverage.set_configuration(configuration);
      coverage.build();
      connect_subscriber(coverage);



    end

		monitor = new("monitor", this);
		monitor.set_configuration(configuration);
		monitor.set_agent(this);
		monitor.build();
		monitor.bus = this.bus;

	endfunction

	virtual function void nb_put(T trans);
		foreach(subscribers[i])	subscribers[i].nb_put(trans);
	//	foreach(subscribers[i])	scbd.nb(subscribers[i].pop_front());
	endfunction

	virtual task bl_put(T trans);
		driver.bl_put(trans);
	endtask

	virtual function void connect_subscriber(ncsu_component#(T) subscriber);
		subscribers.push_back(subscriber);
	endfunction

	virtual task run();
		fork monitor.run(); join_none
	endtask

endclass : i2c_agent
