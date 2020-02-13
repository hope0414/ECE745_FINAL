package i2c_pkg;
	import ncsu_pkg::*;
	`include "ncsu_macros.svh"
	`include "src/i2c_typedef.svh"
	
	`include "src/i2c_configuration.svh"
	`include "src/i2c_transaction.svh"

	`include "src/i2c_transaction_random.svh"

	`include "src/i2c_driver.svh"
	`include "src/i2c_monitor.svh"
	`include "src/i2c_coverage.svh"
	
	`include "src/i2c_agent.svh"

endpackage
