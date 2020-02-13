class i2c_transaction extends ncsu_transaction;
	`ncsu_register_object(i2c_transaction)


	bit [7:0] write_data [];
	bit [7:0] read_data [];
	bit [6:0] addr;
	bit [7:0] data [];
	bit [7:0] data_random;
	rand bit [7:0] data_temp;
	i2c_op_t op;
	function new(string name = "");
		super.new(name);
	endfunction : new

	virtual function string convert2string();
		if(op == W)
			return {super.convert2string(), $sformatf("write data: %p", write_data)};
		else
			return {super.convert2string(), $sformatf("read data: %p", read_data)};
	endfunction

	function bit compare (i2c_transaction rhs);
		return  ((this.write_data == rhs.write_data) || (this.read_data == rhs.read_data));

	endfunction


	function void post_randomize();
		data_random = data_temp;
	endfunction
endclass
