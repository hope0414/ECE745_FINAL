class i2c_sequence_base extends ncsu_component#(.T(i2c_transaction));
	`ncsu_register_object(i2c_sequence_base)

	i2c_transaction transaction;
	ncsu_component #(i2c_transaction) agent;

	function new(string name = "", ncsu_component_base parent = null);
		super.new(name, parent);
		transaction = new("transaction");
	endfunction






endclass