module piso_tb;

// Wire Declarations
reg clk;        // System clock
reg g_rst;      // System reset
reg enable;     // Parallel to serial initializer
reg [31:0] par_ser_data;  // Data into the parallel to serial converter
wire tx_serial_out;
// Instantiate the PISO module
piso dut(.clk(clk), .g_rst(g_rst), .enable(enable), .par_ser_data(par_ser_data), .tx_serial_out(tx_serial_out));
// Clock generation
always begin
    clk = 1'b0;
    #3;
    clk = 1'b1;
    #3;
end
// Initial block for testbench stimulus
initial begin
    g_rst = 1'b1;
    enable = 1'b0;
    #10;
    enable = 1'b1;
    g_rst = 1'b0;
    #10;
    par_ser_data = 32'b10100101_11001100_11100011_00001111;
    #210;
    $finish;
end
endmodule
