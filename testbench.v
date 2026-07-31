`timescale 1ns/1ps

module apb_tb;

reg PCLK;
reg PRESETn;

reg transfer;
reg write_read;

reg [31:0] addr_in;
reg [31:0] data_in;

wire [31:0] data_out;

wire ready_out;

wire [31:0] PADDR;
wire PWRITE;
wire PSEL;
wire PENABLE;
wire [31:0] PWDATA;
wire [31:0] PRDATA;
wire PREADY;

apb_master master(

.PCLK(PCLK),
.PRESETn(PRESETn),

.transfer(transfer),
.write_read(write_read),
.addr_in(addr_in),
.data_in(data_in),

.PREADY(PREADY),
.PRDATA(PRDATA),

.data_out(data_out),
.ready_out(ready_out),

.PADDR(PADDR),
.PWRITE(PWRITE),
.PSEL(PSEL),
.PENABLE(PENABLE),
.PWDATA(PWDATA)

);

apb_slave slave(

.PCLK(PCLK),
.PRESETn(PRESETn),

.PSEL(PSEL),
.PENABLE(PENABLE),
.PWRITE(PWRITE),

.PADDR(PADDR),
.PWDATA(PWDATA),

.PRDATA(PRDATA),
.PREADY(PREADY)

);

always #5 PCLK = ~PCLK;

initial
begin
    PCLK = 0;
end

initial
begin

    PRESETn = 0;

    transfer = 0;

    write_read = 0;

    addr_in = 0;

    data_in = 0;

    #20;

    PRESETn = 1;

end

task apb_write;

input [31:0] addr;
input [31:0] data;

begin

    @(posedge PCLK);

    transfer   = 1;
    write_read = 1;
    addr_in    = addr;
    data_in    = data;

    @(posedge ready_out);

    transfer = 0;

    $display("[%0t] WRITE Address=%h Data=%h",
              $time,addr,data);

end

endtask

task apb_read;

input [31:0] addr;

begin

    @(posedge PCLK);

    transfer   = 1;
    write_read = 0;
    addr_in    = addr;

    @(posedge ready_out);

    transfer = 0;

    $display("[%0t] READ Address=%h Data=%h",
              $time,addr,data_out);

end

endtask

initial
begin

    @(posedge PRESETn);

    apb_write(32'h10,32'hDEADBEEF);

    apb_write(32'h20,32'h12345678);

    apb_write(32'h30,32'hAAAAAAAA);

    apb_read(32'h10);

    apb_read(32'h20);

    apb_read(32'h30);

    #50;

    $finish;

end

initial
begin

    $dumpfile("apb.vcd");

    $dumpvars(0,apb_tb);

end

endmodule
