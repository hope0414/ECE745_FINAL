class wb_sequence_base extends ncsu_component#(.T(wb_transaction));
	`ncsu_register_object(wb_sequence_base)

	
	wb_transaction transaction;
	ncsu_component #(wb_transaction) agent;

	function new(string name = "", ncsu_component_base parent = null);
		super.new(name, parent);
		transaction = new("transaction");
	endfunction

	virtual task run();
		
		enable();
		start_w();
		write();
		stop();
		
		start_r();
		read();
		stop();

	endtask : run

	function void set_agent(ncsu_component #(wb_transaction) agent);
		this.agent = agent;


	
	endfunction 

	task enable();
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

	endtask : enable


	task start_w();
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
	
	task write();
		for(int i = 0; i < 32; i++) begin
			$display("Write Data");
			transaction.addr = 2'b01;
			transaction.data = i;
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

	task read();
		for(int i = 0; i < 31; i++) begin
			

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