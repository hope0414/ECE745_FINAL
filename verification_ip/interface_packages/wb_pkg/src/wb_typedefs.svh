typedef enum bit [1:0] {CSR = 2'b00, DPR = 2'b01, CMDR = 2'b10, FSMR = 2'b11} reg_type_t;

typedef enum bit [7:0] {ENABLE = 8'b1100_0000, SET_BUS = 8'b0000_0110, START = 8'b0000_0100, 
		WRITE = 8'b0000_0001, READ_NAK = 8'b0000_0011, READ_ACK = 8'b0000_0010, STOP = 8'b0000_0101} data_type_t;

typedef enum bit {E_E = 1'b1, D_E = 1'b0} enable_type_t;

typedef enum bit {D_IN = 1'b0, E_IN = 1'b1} interrupt_enable_type;
 
typedef enum bit {BUS_NOT_BUSY = 1'b0, BUS_BUSY = 1'b1} bus_busy_type;

typedef enum bit {BUS_N = 1'b0, BUS_C = 1'b1} bus_captured_type;

typedef enum bit [3:0] {S_IDLE = 4'b0000,
      S_START_A   = 4'b0001,
      S_START_B   = 4'b0010,
      S_START_C   = 4'b0011,
      S_RW_A      = 4'b0100,
      S_RW_B      = 4'b0101,
      S_RW_C      = 4'b0110,
      S_RW_D      = 4'b0111,
      S_RW_E      = 4'b1000,
      S_STOP_A    = 4'b1001,
      S_STOP_B    = 4'b1010,
      S_STOP_C    = 4'b1011,
      S_RESTART_A  = 4'b1100,
      S_RESTART_B  = 4'b1101,
      S_RESTART_C  = 4'b1110
} fsmr_bit_t;



//typedef enum bit [1:0] {WRITE, READ} we_type_t;
