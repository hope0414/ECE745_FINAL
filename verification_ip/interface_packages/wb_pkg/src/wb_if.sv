interface wb_if     #(
      int ADDR_WIDTH = 2,
      int DATA_WIDTH = 8
      )
(
  // System sigals
  input wire clk_i,
  input wire rst_i,
  input wire irq_i,
  // Master signals
  output reg cyc_o,
  output reg stb_o,
  input wire ack_i,
  output reg [ADDR_WIDTH-1:0] adr_o,
  output reg we_o,
  // Slave signals
  input wire cyc_i,
  input wire stb_i,
  output reg ack_o,
  input wire [ADDR_WIDTH-1:0] adr_i,
  input wire we_i,
  // Shred signals
  output reg [DATA_WIDTH-1:0] dat_o,
  input wire [DATA_WIDTH-1:0] dat_i
  );

//idle or bustaken state => startpending or start state
  property write_cmdr_start;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h04 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[7:4] == 8'h03 && we_o == 0) || (adr_o == 2'b11 && dat_i[7:4] == 8'h02 && we_o == 0);
  endproperty

//setbus when idle or bustaken state => idle or bustaken
  property write_cmdr_setbus;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h06 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[7:4] == 8'h00 && we_o == 0) || (adr_o == 2'b11 && dat_i[7:4] == 8'h01 && we_o == 0);
  endproperty

//wrtie when bustaken or idle => write or idle
  property write_cmdr_write;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h01 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[7:4] == 8'h05 && we_o == 0) || (adr_o == 2'b11 && dat_i[7:4] == 8'h00 && we_o == 0);
  endproperty

  property write_cmdr_ack;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h02 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[7:4] == 8'h06 && we_o == 0) || (adr_o == 2'b11 && dat_i[7:4] == 8'h00 && we_o == 0);
  endproperty

  property write_cmdr_nack;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h03 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[7:4] == 8'h06 && we_o == 0) || (adr_o == 2'b11 && dat_i[7:4] == 8'h00 && we_o == 0);
  endproperty

  property write_cmdr_stop;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h05 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[7:4] == 8'h04 && we_o == 0) || (adr_o == 2'b11 && dat_i[7:4] == 8'h00 && we_o == 0);
  endproperty

  property write_cmdr_wait;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h00 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[7:4] == 8'h07 && we_o == 0) || (adr_o == 2'b11 && dat_i[7:4] == 8'h01 && we_o == 0);
  endproperty

  assert property(write_cmdr_start) else $error("ERRPR: write_cmdr_start");
  assert property(write_cmdr_setbus) else $error("ERRPR: write_cmdr_setbus");
  assert property(write_cmdr_write) else $error("ERRPR: write_cmdr_write");
  //assert property(write_cmdr_ack) else $error("ERRPR: write_cmdr_ack");
  assert property(write_cmdr_nack) else $error("ERRPR: write_cmdr_nack");
  assert property(write_cmdr_stop) else $error("ERRPR: write_cmdr_stop");
  assert property(write_cmdr_wait) else $error("ERRPR: write_cmdr_wait");

  cover property(write_cmdr_start);
  cover property(write_cmdr_setbus);
  cover property(write_cmdr_write);
  cover property(write_cmdr_ack);
  cover property(write_cmdr_nack);
  cover property(write_cmdr_stop);
  cover property(write_cmdr_wait);


//bit level
//start command
  property write_cmdr_start_mbit;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h04 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[3:0] == 8'h12 && we_o == 0)
      || (adr_o == 2'b11 && dat_i[3:0] == 8'h01 && we_o == 0)
      || (adr_o == 2'b11 && dat_i[3:0] == 8'h03 && we_o == 0)
      || (adr_o == 2'b11 && dat_i[3:0] == 8'h00 && we_o == 0);
  endproperty

//write command
  property write_cmdr_write_mbit;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h01 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[3:0] == 8'h04 && we_o == 0)
      || (adr_o == 2'b11 && dat_i[3:0] == 8'h00 && we_o == 0);
  endproperty

  property write_cmdr_ack_mbit;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h02 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[3:0] == 8'h04 && we_o == 0)
      || (adr_o == 2'b11 && dat_i[3:0] == 8'h00 && we_o == 0);
  endproperty

  property write_cmdr_nack_mbit;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h03 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[3:0] == 8'h04 && we_o == 0)
      || (adr_o == 2'b11 && dat_i[3:0] == 8'h00 && we_o == 0);
  endproperty

  property write_cmdr_stop_mbit;
  @(posedge clk_i)
  ($rose(ack_i) && adr_o == 2'b10 && dat_o == 8'h05 && we_o == 1) |=>
  ##3 (adr_o == 2'b11 && dat_i[3:0] == 8'h09 && we_o == 0)
      || (adr_o == 2'b11 && dat_i[3:0] == 8'h00 && we_o == 0);
  endproperty

  assert property(write_cmdr_start_mbit) else $error("ERRPR: write_cmdr_start_mbit");

  assert property(write_cmdr_write_mbit) else $error("ERRPR: write_cmdr_write_mbit");
  assert property(write_cmdr_ack_mbit) else $error("ERRPR: write_cmdr_ack_mbit");
  assert property(write_cmdr_nack_mbit) else $error("ERRPR: write_cmdr_nack_mbit");
  assert property(write_cmdr_stop_mbit) else $error("ERRPR: write_cmdr_stop_mbit");


  cover property(write_cmdr_start_mbit);

  cover property(write_cmdr_write_mbit);
  cover property(write_cmdr_ack_mbit);
  cover property(write_cmdr_nack_mbit);
  cover property(write_cmdr_stop_mbit);



  initial reset_bus();

// ****************************************************************************
   task wait_for_reset();
       if (rst_i !== 0) @(negedge rst_i);
   endtask

// ****************************************************************************
   task wait_for_num_clocks(int num_clocks);
       repeat (num_clocks) @(posedge clk_i);
   endtask

// ****************************************************************************
   task wait_for_interrupt();
       wait(irq_i == 1'b1);
   endtask

// ****************************************************************************
   task reset_bus();
        cyc_o <= 1'b0;
        stb_o <= 1'b0;
        we_o <= 1'b0;
        adr_o <= 'b0;
        dat_o <= 'b0;
   endtask

// ****************************************************************************
  task master_write(
                   input bit [ADDR_WIDTH-1:0]  addr,
                   input bit [DATA_WIDTH-1:0]  data
                   );

        @(posedge clk_i);
        adr_o <= addr;
        dat_o <= data;
        cyc_o <= 1'b1;
        stb_o <= 1'b1;
        we_o <= 1'b1;
        while (!ack_i) @(posedge clk_i);
        cyc_o <= 1'b0;
        stb_o <= 1'b0;
        adr_o <= 'bx;
        dat_o <= 'bx;
        we_o <= 1'b0;
        @(posedge clk_i);

endtask

// ****************************************************************************
task master_read(
                 input bit [ADDR_WIDTH-1:0]  addr,
                 output bit [DATA_WIDTH-1:0] data
                 );

        @(posedge clk_i);
        adr_o <= addr;
        dat_o <= 'bx;
        cyc_o <= 1'b1;
        stb_o <= 1'b1;
        we_o <= 1'b0;
        @(posedge clk_i);
        while (!ack_i) @(posedge clk_i);
        cyc_o <= 1'b0;
        stb_o <= 1'b0;
        adr_o <= 'bx;
        dat_o <= 'bx;
        we_o <= 1'b0;
        data = dat_i;

endtask

// ****************************************************************************
     task master_monitor(
                   output bit [ADDR_WIDTH-1:0] addr,
                   output bit [DATA_WIDTH-1:0] data,
                   output bit we
                  );

          while (!cyc_o) @(posedge clk_i);
          while (!ack_i) @(posedge clk_i);
          addr = adr_o;
          we = we_o;
          if (we_o) begin
            data = dat_o;
          end else begin
            data = dat_i;
          end
          while (cyc_o) @(posedge clk_i);
     endtask

endinterface
