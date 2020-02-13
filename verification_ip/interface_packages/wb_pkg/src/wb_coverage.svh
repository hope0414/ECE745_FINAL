class wb_coverage extends ncsu_component#(.T(wb_transaction));

	wb_configuration configuration;
	reg_type_t reg_type;
	data_type_t data_type;

	bit [3:0] fsmr_byte;

	bit we_type;
	enable_type_t enable_type;
	//we_type_t we_type;
	interrupt_enable_type interrupt_enable;
	bus_busy_type bus_busy;
	bus_captured_type bus_captured;

	fsmr_bit_t fsmr_bit;
	

	covergroup wb_transaction_cg();
		option.per_instance = 1;
		option.name = get_full_name();

		reg_type:	coverpoint 	reg_type
		{
		bins CSR = {CSR};
		bins DPR = {DPR};
		bins CMDR = {CMDR};
		bins FSMR = {FSMR};
		}

		data_type:	coverpoint  data_type
		{
		bins ENABLE = {ENABLE};
		bins SET_BUS = {SET_BUS};
		bins START = {START};
		bins WRITE = {WRITE};
		bins READ_NAK = {READ_NAK};
		bins STOP = {STOP};
		}

		we_type:	coverpoint we_type
		{
			bins R_WE = {1'b1};
			bins W_WE = {1'b0};
		}

		enable_type:	coverpoint enable_type
		{
		bins E_E = {E_E};
		bins D_E = {D_E};
		}

		interrupt_enable: coverpoint interrupt_enable
		{
			bins E_IN = {E_IN};
			bins D_IN = {D_IN};
		}

		bus_busy:	coverpoint bus_busy
		{
			bins BUS_BUSY = {BUS_BUSY};
			bins BUS_NOT_BUSY = {BUS_NOT_BUSY};
		}

		bus_captured: coverpoint bus_captured
		{
			bins BUS_C = {BUS_C};
			bins BUS_N = {BUS_N};
		}

		csr_reg_x_enable: cross reg_type, enable_type, we_type
		{
			bins csr_enable_w = binsof(reg_type.CSR) && binsof(enable_type.E_E) && binsof(we_type.W_WE);
			bins csr_notEnable_w = binsof(reg_type.CSR) && binsof(enable_type.D_E) && binsof(we_type.W_WE);
			bins csr_enable_r = binsof(reg_type.CSR) && binsof(enable_type.E_E) && binsof(we_type.R_WE);
			bins csr_notEnable_r = binsof(reg_type.CSR) && binsof(enable_type.D_E) && binsof(we_type.R_WE);
			ignore_bins csr_ignore = binsof(reg_type.DPR) || binsof(reg_type.CMDR) || binsof(reg_type.FSMR);
		}

		csr_reg_x_interrupt: cross reg_type, interrupt_enable, we_type
		{
			bins csr_interrupt_w = binsof(reg_type.CSR) && binsof(interrupt_enable.E_IN) || binsof(we_type.W_WE);
			bins csr_notInterrupt_w = binsof(reg_type.CSR) && binsof(interrupt_enable.D_IN) || binsof(we_type.W_WE);
			bins csr_interrupt_R = binsof(reg_type.CSR) && binsof(interrupt_enable.E_IN) || binsof(we_type.R_WE);
			bins csr_notInterrupt_R = binsof(reg_type.CSR) && binsof(interrupt_enable.D_IN) || binsof(we_type.R_WE);
			ignore_bins csr_interrupt_ignore = binsof(reg_type.DPR) || binsof(reg_type.CMDR) || binsof(reg_type.FSMR);
		}

		csr_reg_x_bus_busy: cross reg_type, bus_busy
		{
			bins csr_bus_idle = binsof(reg_type.CSR) && binsof(bus_busy.BUS_NOT_BUSY);
			bins csr_bus_busy = binsof(reg_type.CSR) && binsof(bus_busy.BUS_BUSY);
			ignore_bins csr_bus_ignore = binsof(reg_type.DPR) || binsof(reg_type.CMDR) || binsof(reg_type.FSMR);
		}

		csr_reg_x_bus_captured: cross reg_type, bus_captured
		{
			bins csr_bus_captured = binsof(reg_type.CSR) && binsof(bus_captured.BUS_C);
			bins csr_bus_notCaptured = binsof(reg_type.CSR) && binsof(bus_captured.BUS_N);
			ignore_bins csr_bus_c_ignore = binsof(reg_type.DPR) || binsof(reg_type.CMDR) || binsof(reg_type.FSMR);

		}




		reg_x_data: cross reg_type, data_type
		{
		bins ENABLE_C = binsof(reg_type.CSR) && binsof(data_type.ENABLE);
		bins SET_BUS_C = binsof(reg_type.CMDR) && binsof(data_type.SET_BUS);
		bins START_C = binsof(reg_type.CMDR) && binsof(data_type.START);
		bins WRITE_C = binsof(reg_type.CMDR) && binsof(data_type.WRITE);
		bins STOP_C = binsof(reg_type.CMDR) && binsof(data_type.STOP);
		bins READ_NAK_C = binsof(reg_type.CMDR) && binsof(data_type.READ_NAK);
	    ignore_bins CMDR_I = binsof(reg_type.CMDR) && (binsof(data_type.ENABLE));
		ignore_bins FSMR_I = binsof(reg_type.FSMR);
		ignore_bins CSR_I = binsof(reg_type.CSR) && (binsof(data_type.STOP)
						|| binsof(data_type.SET_BUS) || binsof(data_type.SET_BUS));
		//bins IGNORE[] = default;
		//bins

		}

	   	fsmr_byte: coverpoint fsmr_byte
	   	{
	   	bins  idle_start_pending =  (4'b0000 => 4'b0010);
	   	bins  idle_idel = (4'b0000 => 4'b0000);
	   	bins  start_pending_start = (4'b0010 => 4'b0011);
	   	bins  start_bus_taken = (4'b0011 => 4'b0001);
	   	bins  bus_taken_write = (4'b0001 => 4'b0101);
	   	bins  bus_taken_bus_taken = (4'b0001 => 4'b0001);
	   	bins  write_bus_taken = (4'b0101 => 4'b0001);
	   	bins  bus_taken_start = (4'b0001 => 4'b0011);
	   	bins  start_idle = (4'b0011 => 4'b0000);
	   	bins  bus_taken_stop = (4'b0001 => 4'b0100);
	   	bins  stop_idle = (4'b0100 => 4'b0000);
	   	bins  bus_taken_read = (4'b0001 => 4'b0110);
	   	bins  read_bus_taken = (4'b0110 => 4'b0001);
	   	bins  read_idle = (4'b0110 => 4'b0000);
	   	bins  write_idle = (4'b0101 => 4'b0000);
	   	}

	   	byte_trans: cross reg_type, fsmr_byte
	   	{
	   	ignore_bins fsmr_byte_trans = binsof(reg_type.CSR) || binsof(reg_type.CMDR) || binsof(reg_type.DPR);
	   	}

	   	fsmr_bit: coverpoint fsmr_bit
	   	{
	   		bins S_IDLE_BIT_to_IDLE_BIT = (S_IDLE => S_IDLE);
			bins S_IDLE_BIT_to_START_A = (S_IDLE => S_START_A);
			bins S_START_A_to_START_B = (S_START_A => S_START_B);
			bins S_START_B_to_START_C = (S_START_B => S_START_C);
			bins S_START_C_to_RW_A = (S_START_C => S_RW_A);
			bins S_START_C_to_STOP_A = (S_START_C => S_STOP_A);
			bins S_START_C_to_START_C = (S_START_C => S_START_C);
			bins S_RW_A_to_RW_B = (S_RW_A => S_RW_B);
			bins S_RW_B_to_RW_C = (S_RW_B => S_RW_C);
			bins S_RW_C_to_RW_D = (S_RW_C => S_RW_D);
			bins S_RW_C_to_IDLE_BIT = (S_RW_C => S_IDLE);
			bins S_RW_D_to_RW_E = (S_RW_D => S_RW_E);
			bins S_RW_E_to_RW_A = (S_RW_E => S_RW_A);
			bins S_RW_E_to_RSTART_A = (S_RW_E => S_RESTART_A);
			bins S_RW_E_to_STOP_A = (S_RW_E => S_STOP_A);
			bins S_STOP_A_to_STOP_B = (S_STOP_A => S_STOP_B);
			bins S_STOP_B_to_STOP_C = (S_STOP_B => S_STOP_C);
			bins S_STOP_C_to_IDLE_BIT = (S_STOP_C => S_IDLE);
			bins S_RSTART_A_to_RSTART_B = (S_RESTART_A => S_RESTART_B);
			bins S_RSTART_B_to_RSTART_C = (S_RESTART_B => S_RESTART_C);
			bins S_RSTART_C_to_START_A = (S_RESTART_C => S_START_A);
			bins S_RSTART_C_to_IDLE_BIT = (S_RESTART_C => S_IDLE);
	   	}

	   	bit_trans: cross reg_type, fsmr_bit
	   	{
	   	ignore_bins fsmr_byte_trans = binsof(reg_type.CSR) || binsof(reg_type.CMDR) || binsof(reg_type.DPR);
	   	}


	endgroup : wb_transaction_cg

	function new(string name = "", ncsu_component_base parent = null);
    super.new(name,parent);
    wb_transaction_cg = new;
  endfunction

  function void set_configuration(wb_configuration cfg);
    configuration = cfg;
  endfunction

  virtual function void nb_put(T trans);
    $display("wb_coverage::nb_put() %s called",get_full_name());
		reg_type = reg_type_t'(trans.addr);
		data_type = data_type_t'(trans.data);
		fsmr_byte = trans.data[7:4];
		fsmr_bit = fsmr_bit_t'(trans.data[3:0]);
		//csr
		enable_type = enable_type_t'(trans.data[7]);
		interrupt_enable = interrupt_enable_type'(trans.data[6]);
		bus_busy = bus_busy_type'(trans.data[5]);
		bus_captured = bus_captured_type'(trans.data[4]);

		//cmdr



    // header_type     = header_type_t'(trans.header[63:60]);
  	// header_sub_type = header_sub_type_t'(trans.header[59:56]);
  	// trailer_type    = trailer_type_t'(trans.header[7:0]);
    wb_transaction_cg.sample();
  endfunction


endclass
