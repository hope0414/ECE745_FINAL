class i2c_transaction_random extends i2c_transaction;
	`ncsu_register_object(i2c_transaction_random)

	ncsu_component #(i2c_transaction) agent;
	rand bit [7:0] data_temp;
	
	function new(string name = "");
		super.new(name);
	endfunction

	// constraint addr_c{
	// 	addr_temp inside {2'b01};
	// 	data_temp inside {[4:15]};
	// 	index_temp inside {[5:10]};
	// }
	
	// function void set_agent(ncsu_component #(i2c_transaction) agent);

	// 	this.agent = agent;
	
	// endfunction 




endclass