//typedef enum bit {W, R} i2c_op_t;
//`include "i2c_if_pkg.sv"
interface i2c_if #(
	int I2C_DATA_WIDTH = 8,
	int I2C_ADDR_WIDTH = 7
	)
(
	inout triand [15:0] SDA,
	input triand [15:0] SCL

	);
import i2c_pkg::*;
parameter ad = 1;

bit SDA_o = 1'b1;
bit i2c_op = 0;

reg [I2C_ADDR_WIDTH - 1 : 0] address;
bit addr_flag;
bit restart_flag;

typedef enum bit [3:0] {STOP = 4'b0000, START = 4'b0001, ADDR = 4'b0010, WRITE = 4'b0011, READ_ACK = 4'b0100, READ_NACK = 4'b101} state_t;

state_t state;

covergroup i2c_transaction_cg;
	option.per_instance = 1;
	option.name = "i2c_transaction_cg";

	i2c_state: coverpoint state
	{
	bins STOP_STOP = (STOP => STOP);
	bins STOP_START = (STOP => START);
	bins START_ADDR = (START => ADDR);
	bins ADDR_WRITE = (ADDR => WRITE);
	bins WRITE_WRITE = (WRITE => WRITE);
	bins ADDR_READ = (ADDR => READ_ACK);
	bins READ_READ = (READ_ACK => READ_ACK);
	bins WRITE_STOP = (WRITE => STOP);
	bins READ_STOP = (READ_ACK => STOP);
	}
   	
endgroup 

i2c_transaction_cg i2c = new;
assign SDA[0] = SDA_o ? 'bz:'b0;
assign SDA[1] = SDA_o ? 'bz:'b0;
assign SDA[2] = SDA_o ? 'bz:'b0;
assign SDA[3] = SDA_o ? 'bz:'b0;
assign SDA[4] = SDA_o ? 'bz:'b0;
assign SDA[5] = SDA_o ? 'bz:'b0;
assign SDA[6] = SDA_o ? 'bz:'b0;
assign SDA[7] = SDA_o ? 'bz:'b0;
assign SDA[8] = SDA_o ? 'bz:'b0;
assign SDA[9] = SDA_o ? 'bz:'b0;
assign SDA[10] = SDA_o ? 'bz:'b0;
assign SDA[11] = SDA_o ? 'bz:'b0;
assign SDA[12] = SDA_o ? 'bz:'b0;
assign SDA[13] = SDA_o ? 'bz:'b0;
assign SDA[14] = SDA_o ? 'bz:'b0;
assign SDA[15] = SDA_o ? 'bz:'b0;

int bus, bus2;


//sda = sda_o? 'bz:'b0
task wait_for_i2c_transfer ( output i2c_op_t op, output bit [I2C_DATA_WIDTH-1:0] write_data []);
//The wait_for_i2c_transfer task is called in order to wait for an i2c transfer to be initiated by the DUT.
//The task will block until the transfer has been initiated and the initial part of the transfer has been captured.
//The task returns the information received in the first part of the transfer.
	int i, j;
	//bit prev_sda;
//typedef enum {W, R} i2c_op_t;
//do begin
	if(!restart_flag) begin

		fork 
			begin: bus0
				do begin 
					@(negedge SDA[0]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[0]);
				bus = 0;
				state = START;
				i2c.sample();
			end

			begin: bus1
				do begin 
					@(negedge SDA[1]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[1]);
				bus = 1;
				state = START;
				i2c.sample();
			end

			begin: bus2
				do begin 
					@(negedge SDA[2]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[2]);
				bus = 2;
				state = START;
				i2c.sample();
			end

			begin: bus3
				do begin 
					@(negedge SDA[3]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[3]);
				bus = 3;
				state = START;
				i2c.sample();
			end

			begin: bus4
				do begin 
					@(negedge SDA[4]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[4]);
				bus = 4;
				state = START;
				i2c.sample();
			end

			begin: bus5
				do begin 
					@(negedge SDA[5]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[5]);
				bus = 5;
				state = START;
				i2c.sample();
			end

			begin: bus6
				do begin 
					@(negedge SDA[6]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[6]);
				bus = 6;
				state = START;
				i2c.sample();
			end

			begin: bus7
				do begin 
					@(negedge SDA[7]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[7]);
				bus = 7;
				state = START;
				i2c.sample();
			end

			begin: bus8
				do begin 
					@(negedge SDA[8]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[8]);
				bus = 8;
				state = START;
				i2c.sample();
			end

			begin: bus9
				do begin 
					@(negedge SDA[9]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[9]);
				bus = 9;
				state = START;
				i2c.sample();
			end

			begin: bus10
				do begin 
					@(negedge SDA[10]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[10]);
				bus = 10;
				state = START;
				i2c.sample();
			end

			begin: bus11
				do begin 
					@(negedge SDA[11]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[11]);
				bus =11;
				state = START;
				i2c.sample();
			end

			begin: bus12
				do begin 
					@(negedge SDA[12]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[12]);
				bus = 12;
				state = START;
				i2c.sample();
			end

			begin: bus13
				do begin 
					@(negedge SDA[13]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[13]);
				bus = 13;
				state = START;
				i2c.sample();
			end

			begin: bus014
				do begin 
					@(negedge SDA[14]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[14]);
				bus = 14;
				state = START;
				i2c.sample();
			end

			begin: bus15
				do begin 
					@(negedge SDA[15]);
					state = STOP;
					i2c.sample();
				end
				while(!SCL[15]);
				bus = 15;
				state = START;
				i2c.sample();
			end
		join_any;
		disable fork;

	end
	else begin
		restart_flag = 0;
		//$display("restart");
	end



	for(i = 0; i < I2C_ADDR_WIDTH; i++)
		begin
			@(posedge SCL[bus]);
			address[I2C_ADDR_WIDTH - 1 - i] = SDA[bus];
			
		end
		//$display("address: %p", address);
		state = ADDR;
		i2c.sample();

		@(posedge SCL[bus]);
		if(SDA[bus])	i2c_op = 1;
		else	i2c_op = 0;

		if(i2c_op)	begin
			op = R;
		end
		else	begin
			op = W;
		end

		//$display("I2C Address: %d", address);
		@(negedge SCL[bus]);
		if(address == ad)	begin
		SDA_o = 0;
		//addr_flag = 0;
		end
		else	begin
		SDA_o = 1;
		//addr_flag = 1;
		end

		if(op == W)	begin
			@(negedge SCL[bus]);
			SDA_o = 1;
			//$display("Yes");
		end

i = 0;
	if(op == W)	begin
		forever

			begin
				@(posedge SCL[bus]);
				//prev_sda = SDA;
				
				@(SDA[bus] or negedge SCL[bus]);
				if(!SCL[bus]) begin
					write_data = new[i + 1](write_data);
					write_data[i][7] = SDA[bus];
					//$display("DATA: %d", SDA);
				end	// new data
				else if(SDA[bus])	begin
					//$display("STOP");
					state = STOP;
					i2c.sample();
					break;
				end
				else if(!SDA[bus])	begin
					restart_flag = 1;
					state = START;
					i2c.sample();
					break;
				end

				state = WRITE;
				i2c.sample();
				for(j = 6; j >= 0; j--)
					begin
						@(posedge SCL[bus]);
						//$display("DATA: %d", SDA);
						write_data[i][j] = SDA[bus];
						//$display("index: %d", j);
					end
					//$display("Write_data[%d] = %p", i, write_data[i]);
					@(negedge SCL[bus]);
					SDA_o = 0;
					@(negedge SCL[bus]);
					SDA_o = 1;
					i++;
			end

	end
endtask : wait_for_i2c_transfer
//bit [I2C_DATA_WIDTH-1:0] data;
task provide_read_data ( input bit [I2C_DATA_WIDTH-1:0] read_data []);
//If the transfer is a read operation, the responder needs to provide data to the DUT at the end of the transfer.
//The provide_read_data task provides read data to complete a read operation.
int i, j;
i = 0;
@(posedge SCL[bus]);
if(SDA[bus] == 1) begin
	@(posedge SCL[bus]);
	@(SDA[bus]);
	if(!SDA[bus]) begin
		state = START;
		i2c.sample();
		restart_flag = 1;
	end
end
else begin
	forever
		begin
 		for(j = 7; j >= 0; j--)
 			begin	//8 bit
				@(negedge SCL[bus]);
				//$display("New bit");
				SDA_o = read_data[i][j];
				//$display("SbeginDA_o: %d", SDA_o);
				//$display("index: %d", j);
				//data[j] = read_data[i][I2C_ADDR_WIDTH - 1 - j];
			end
			state = READ_ACK;
			i2c.sample();
			@(negedge SCL[bus]);
			SDA_o = 1;	//release SCL
				//data = read_data[i];

			@(posedge SCL[bus]);
			if(SDA[bus] == 0) begin
				//$display("SDA: %d, Yes, ACK", SDA);
				i++;
			end
			else
		    begin
				@(posedge SCL[bus]);
				@(SDA[bus]);
				if(!SDA[bus]) begin
					state = START;
					i2c.sample();
					restart_flag = 1;
				end
				else begin
					state = STOP;
					i2c.sample();
					//$display("==== STOP ====");
				end
				break;
			end
		end
	end

endtask : provide_read_data

//bit [I2C_DATA_WIDTH - 1: 0] monitor_data;
bit restart_flag_monitor = 0;
//restart_flag_monitor = 0;
task monitor ( output bit [I2C_ADDR_WIDTH-1:0] addr, output i2c_op_t op, output bit [I2C_DATA_WIDTH-1:0] data []);
//The monitor task observes the full transfer and returns observed information from the transfer in its arguments,
//just as the WB interface master_monitor task operated.

//The i2c_op_t is an enumerated type, that you need to define.
//It includes all of the different operations performed by I2C in its enumerations.
int i, j;



	if(!restart_flag_monitor) begin

		fork 
			begin: bus0
				do
					@(negedge SDA[0]);
				while(!SCL[0]);

				bus2 = 0;
			end

			begin: bus1
				do
					@(negedge SDA[1]);
				while(!SCL[1]);

				bus2 = 1;
			end

			begin: bus3
				do
					@(negedge SDA[3]);
				while(!SCL[3]);

				bus2 = 3;
			end

			begin: bus4
				do
					@(negedge SDA[4]);
				while(!SCL[4]);

				bus2 = 4;
			end

			begin: bus5
				do
					@(negedge SDA[5]);
				while(!SCL[5]);

				bus2 = 5;
			end

			begin: bus6
				do
					@(negedge SDA[6]);
				while(!SCL[6]);

				bus2 = 6;
			end

			begin: bus7
				do
					@(negedge SDA[7]);
				while(!SCL[7]);

				bus2 = 7;
			end

			begin: bus8
				do
					@(negedge SDA[8]);
				while(!SCL[8]);

				bus2 = 8;
			end

			begin: bus9
				do
					@(negedge SDA[9]);
				while(!SCL[9]);

				bus2 = 9;
			end

			begin: bus10
				do
					@(negedge SDA[10]);
				while(!SCL[10]);

				bus2 = 10;
			end

			begin: bus11
				do
					@(negedge SDA[11]);
				while(!SCL[11]);

				bus2 = 11;
			end

			begin: bus12
				do
					@(negedge SDA[12]);
				while(!SCL[12]);

				bus2 = 12;
			end

			begin: bus13
				do
					@(negedge SDA[13]);
				while(!SCL[13]);

				bus2 = 13;
			end

			begin: bus14
				do
					@(negedge SDA[14]);
				while(!SCL[14]);

				bus2 = 14;
			end

			begin: bus15
				do
					@(negedge SDA[15]);
				while(!SCL[15]);

				bus2 = 15;
			end
		join_any;

		disable fork;
		//$display("========== Start ===========");
	//int i, j;
	end
	else begin
		//$display("restart");
		restart_flag_monitor = 0;
	end

	for(i = 0; i < I2C_ADDR_WIDTH; i++)
		begin
			@(posedge SCL[bus2]);
			addr[I2C_ADDR_WIDTH - 1 - i] = SDA[bus2];
		end
		//$write("address: %b, ", addr);

		@(posedge SCL[bus2]);
		if(SDA[bus2])	begin
			op = R;

		end
		else begin
			op = W;

		end

		@(negedge SCL[bus2]);
		// if(addr == ad)	begin
		
		// end
		// else	begin
		// 	break;
		// end

		if(op == W)	begin
			@(negedge SCL[bus2]);
		//	SDA_o = 1;
			//$display("Yes");
		end
	//for(i = 0; ; i++)	begin
	i = 0;
	if(op == W)	begin
		forever
		begin
			@(posedge SCL[bus2]);
			//prev_sda = SDA;
			@(SDA[bus2] or negedge SCL[bus2]);
			if(!SCL[bus2]) begin
				data = new[i + 1](data);
				data[i][7] = SDA[bus2];
				//$display("DATA: %d", SDA);
			end	// new data
			else if(SDA[bus2])	begin
				//$display("STOP");
				break;
			end
			else if(!SDA[bus2])	begin

					restart_flag_monitor = 1;
				break;
			end

			for(j = 6; j >= 0; j--)
				begin
					@(posedge SCL[bus2]);
					//$display("DATA: %d", SDA);
					data[i][j] = SDA[bus2];
					//$display("index: %d", j);
				end
				//$display("Write_data[%d] = %p", i, write_data[i]);
				@(negedge SCL[bus2]);

				@(negedge SCL[bus2]);

				i++;
		end
	end

	if(op == R) begin
		@(posedge SCL[bus2]);
		if(SDA == 1) begin
			@(posedge SCL[bus2]);
			@(SDA[bus2]);
			if(!SDA[bus2]) begin
				restart_flag_monitor = 1;
			end
		end
		else begin
			forever
				begin
				for(j = 7; j >= 0; j--)begin	//8 bit
						@(posedge SCL[bus2]);
						data = new[i + 1](data);
						//$display("New bit");
						//SDA_o = read_data[i][j];
						data[i][j] = SDA[bus2];
						//$display("SDA: %d", SDA);
						//$display("index: %d", j);
						//data[j] = read_data[i][I2C_ADDR_WIDTH - 1 - j];
					end
					@(negedge SCL[bus2]);
					//SDA_o = 1;	//release SCL
						//data = read_data[i];

					@(posedge SCL[bus2]);
					if(SDA[bus2] == 0) begin
						//$display("SDA: %d, Yes, ACK", SDA);
						i++;
					end
					else begin
						@(posedge SCL[bus2]);
						@(SDA[bus2]);
						if(!SDA[bus2]) begin
							restart_flag_monitor = 1;
							//$display("==== RE-start ====");
						end
						else begin
							//$display("==== STOP ====");
						end
						break;
					end
				end
			end
		end

endtask : monitor

endinterface
