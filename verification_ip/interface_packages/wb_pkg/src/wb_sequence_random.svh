class wb_sequence_random extends wb_sequence_base;
	`ncsu_register_object(wb_sequence_random)

	wb_transaction transaction;
	wb_transaction_random trans_random;

	ncsu_component #(wb_transaction) agent;

	function new(string name = "");
		super.new(name);
		transaction = new("transaction");
		trans_random = new("trans_random");
	endfunction : new

	virtual task run();
		enable();
		assert(trans_random.randomize());
		$display("wr: %d", trans_random.wr);
		if(trans_random.wr == 1) begin
			start_w();
			write(trans_random.loop);
			
		end
		else begin
			start_r();
			read(trans_random.loop);
			
		end
		stop();

	endtask : run

	function void set_agent(ncsu_component #(wb_transaction) agent);
		this.agent = agent;
	endfunction

	task enable();
		//$display("This is enable------------------------");
		transaction.interrupt = 0;
		transaction.addr = 2'b00;
		transaction.data = 8'b1100_0000;
		transaction.wb_op = 0;
		agent.bl_put(transaction);

		//write bus ID
		transaction.addr = 2'b01;
		transaction.data = 8'b01;
		transaction.wb_op = 0;
		agent.bl_put(transaction);

		//set bus
		transaction.addr = 2'b10;
		transaction.data = 8'b0000_0110;
		transaction.wb_op = 0;
		transaction.interrupt = 1;
		agent.bl_put(transaction);

		//clear interrupt
		transaction.addr = 2'b10;
		transaction.wb_op = 1;
		transaction.interrupt = 0;
		agent.bl_put(transaction);

	//	$display("enable finish-------------------------");

	endtask : enable


	task start_w();
	//	$display("this is write start------------------");
		//start command
		transaction.addr = 2'b10;
		transaction.data = 8'b0000_0100;
		transaction.wb_op = 0;
		transaction.interrupt = 1;
		agent.bl_put(transaction);

		//write command 
		
		transaction.addr = 2'b01;
		transaction.data = 8'h02;
		transaction.wb_op = 0;
		agent.bl_put(transaction);


		
		//write command
		transaction.addr = 2'b10;
		transaction.data = 8'b0000_0001;
		transaction.wb_op = 0;
		transaction.interrupt = 1;
		agent.bl_put(transaction);
		//wait for irq and clear interrupt
		transaction.addr = 2'b10;
		transaction.wb_op = 1;
		transaction.interrupt = 0;
		agent.bl_put(transaction);



	endtask


	task start_r();
		//$display("this is read start---------------------");
		transaction.addr = 2'b10;
		transaction.data = 8'b0000_0100;
		transaction.wb_op = 0;
		transaction.interrupt = 1;
		agent.bl_put(transaction);

		
		//read command
		transaction.addr = 2'b01;
		transaction.data = 8'h03;
		transaction.wb_op = 0;
		agent.bl_put(transaction);
		
		//write command
		transaction.addr = 2'b10;
		transaction.data = 8'b0000_0001;
		transaction.wb_op = 0;
		transaction.interrupt = 1;
		agent.bl_put(transaction);
		//wait for irq and clear interrupt
		transaction.addr = 2'b10;
		transaction.wb_op = 1;
		transaction.interrupt = 0;
		agent.bl_put(transaction);
	endtask
	
	task write(int times);
	//	$display("this is write---------------------");
		for(int i = 0; i < times; i++) begin
			assert(trans_random.randomize());
			transaction.addr = 2'b01;
			transaction.data = trans_random.data;
			transaction.wb_op = 0;
			agent.bl_put(transaction);

			transaction.addr = 2'b10;
			transaction.data = 8'b0000_0001;
			transaction.wb_op = 0;
			transaction.interrupt = 1;
			agent.bl_put(transaction);

			transaction.addr = 2'b10;
			transaction.wb_op = 1;
			transaction.interrupt = 0;
			agent.bl_put(transaction);

		end


	endtask

	task read(int times);
		$display("this is read------------------");
		for(int i = 0; i < times - 1; i++) begin

			transaction.addr = 2'b10;
			transaction.data = 8'b0000_0010;
			transaction.wb_op = 0;
			transaction.interrupt = 1;
			agent.bl_put(transaction);

			transaction.addr = 2'b10;
			transaction.wb_op = 1;
			transaction.interrupt = 0;
			agent.bl_put(transaction);

			transaction.addr = 2'b01;
			transaction.wb_op = 1;
			agent.bl_put(transaction);

		end

		transaction.addr = 2'b10;
		transaction.data = 8'b0000_0011;
		transaction.wb_op = 0;
		transaction.interrupt = 1;
		agent.bl_put(transaction);

		transaction.addr = 2'b10;
		transaction.wb_op = 1;
		transaction.interrupt = 0;
		agent.bl_put(transaction);

		transaction.addr = 2'b01;
		transaction.wb_op = 1;
		agent.bl_put(transaction);

	endtask


	task stop(); 
		//$display("this is stop--------------------");
		transaction.addr = 2'b10;
	    transaction.data = 8'bxxxx_x101;
	    transaction.wb_op = 0;
	    transaction.interrupt = 1;
	    agent.bl_put(transaction);
	  // //  read_fmsr();

	    transaction.addr = 2'b10;
	    transaction.wb_op = 1;
	    transaction.interrupt = 0;
	    agent.bl_put(transaction);

	endtask


endclass