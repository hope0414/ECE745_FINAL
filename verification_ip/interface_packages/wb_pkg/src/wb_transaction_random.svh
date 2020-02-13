class wb_transaction_random extends wb_transaction;
	`ncsu_register_object(wb_transaction_random)


	rand int loop_tmp;
	rand bit wr_tmp; // write == 1; read == 0

	rand bit [1:0] addr_tmp;
	rand bit [7:0] data_tmp;

	function new (string name = "");
		super.new(name);
	
	endfunction 

	constraint wb{
		addr_tmp inside {2'b01};
		loop_tmp inside {[0:257]};
		//wr_tmp inside {0};
	}

	function void post_randomize();
		loop = loop_tmp;
		data = data_tmp;
		addr = addr_tmp;
		wr = wr_tmp;
	endfunction 

endclass