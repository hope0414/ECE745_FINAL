`timescale 1ns / 10ps

//`include "../../../verification_ip/interface_packages/i2c_pkg/src/i2c_if_pkg.sv"

module top();
import ncsu_pkg::*;
import i2c_pkg::*;
import wb_pkg::*;
import i2cmb_env_pkg::*;


parameter int WB_ADDR_WIDTH = 2;
parameter int WB_DATA_WIDTH = 8;
parameter int NUM_I2C_SLAVES = 16;
parameter int I2C_ADDR_WIDTH = 7;
parameter int I2C_DATA_WIDTH = 8;

i2cmb_test tst;

bit  clk;
bit  rst = 1'b1;
wire cyc;
wire stb;
wire we;
tri ack;
wire [WB_ADDR_WIDTH-1:0] adr;
wire [WB_DATA_WIDTH-1:0] dat_wr_o;
wire [WB_DATA_WIDTH-1:0] dat_rd_i;
wire irq;
tri  [NUM_I2C_SLAVES-1:0] scl;
tri  [NUM_I2C_SLAVES-1:0] sda;



// ****************************************************************************
// Clock generator
initial begin: clk_gen
	clk = 1'b0;
	forever begin

	#5 clk = ~clk;
	end
end: clk_gen

// ****************************************************************************
// Reset generator
initial begin: rst_gen
	#113 rst = 0;
end: rst_gen


// ****************************************************************************
// Instantiate the Wishbone master Bus Functional Model
wb_if       #(
      .ADDR_WIDTH(WB_ADDR_WIDTH),
      .DATA_WIDTH(WB_DATA_WIDTH)
      )
p0_bus (
  // System sigals
	.irq_i(irq),
  .clk_i(clk),
  .rst_i(rst),
  // Master signals
  .cyc_o(cyc),
  .stb_o(stb),
  .ack_i(ack),
  .adr_o(adr),
  .we_o(we),
  // Slave signals
  .cyc_i(),
  .stb_i(),
  .ack_o(),
  .adr_i(),
  .we_i(),
  // Shred signals
  .dat_o(dat_wr_o),
  .dat_i(dat_rd_i)
  );

// ****************************************************************************
// Instantiate the DUT - I2C Multi-Bus Controller
\work.iicmb_m_wb(str) #(.g_bus_num(NUM_I2C_SLAVES)) DUT
  (
    // ------------------------------------
    // -- Wishbone signals:
    .clk_i(clk),         // in    std_logic;                            -- Clock
    .rst_i(rst),         // in    std_logic;                            -- Synchronous reset (active high)
    // -------------
    .cyc_i(cyc),         // in    std_logic;                            -- Valid bus cycle indication
    .stb_i(stb),         // in    std_logic;                            -- Slave selection
    .ack_o(ack),         //   out std_logic;                            -- Acknowledge output
    .adr_i(adr),         // in    std_logic_vector(1 downto 0);         -- Low bits of Wishbone address
    .we_i(we),           // in    std_logic;                            -- Write enable
    .dat_i(dat_wr_o),    // in    std_logic_vector(7 downto 0);         -- Data input
    .dat_o(dat_rd_i),    //   out std_logic_vector(7 downto 0);         -- Data output
    // ------------------------------------
    // ------------------------------------
    // -- Interrupt request:
    .irq(irq),           //   out std_logic;                            -- Interrupt request
    // ------------------------------------
    // ------------------------------------
    // -- I2C interfaces:
    .scl_i(scl),         // in    std_logic_vector(0 to g_bus_num - 1); -- I2C Clock inputs
    .sda_i(sda),         // in    std_logic_vector(0 to g_bus_num - 1); -- I2C Data inputs
    .scl_o(scl),         //   out std_logic_vector(0 to g_bus_num - 1); -- I2C Clock outputs
    .sda_o(sda)          //   out std_logic_vector(0 to g_bus_num - 1)  -- I2C Data outputs
    // ------------------------------------
  );

i2c_if p1_bus(
	.SDA(sda),
	.SCL(scl)

	);


initial begin: test_flow
ncsu_config_db#(virtual wb_if)::set("tst.env.p0_agent", p0_bus);

ncsu_config_db#(virtual i2c_if)::set("tst.env.p1_agent", p1_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p2_agent", p2_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p3_agent", p3_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p4_agent", p4_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p5_agent", p5_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p6_agent", p6_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p7_agent", p7_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p8_agent", p8_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p9_agent", p9_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p10_agent", p10_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p11_agent", p11_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p12_agent", p12_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p13_agent", p13_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p14_agent", p14_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p15_agent", p15_bus);
// ncsu_config_db#(virtual i2c_if)::set("tst.env.p16_agent", p16_bus);

//p0_bus.enable_driver
wait(rst == 0);
tst = new("tst", null);

tst.run();
#100ns $finish();
end

endmodule
