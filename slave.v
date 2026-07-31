module apb_slave #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32,
    parameter DEPTH = 256
)(
    input                       PCLK,
    input                       PRESETn,

    input                       PSEL,
    input                       PENABLE,
    input                       PWRITE,

    input [ADDR_WIDTH-1:0]      PADDR,
    input [DATA_WIDTH-1:0]      PWDATA,

    output reg [DATA_WIDTH-1:0] PRDATA,
    output                      PREADY
);

reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

assign PREADY = 1'b1;

integer i;

always @(posedge PCLK or negedge PRESETn)
begin

    if(!PRESETn)
    begin

        PRDATA <= 0;

        for(i=0;i<DEPTH;i=i+1)
            mem[i] <= 0;

    end

    else if(PSEL && PENABLE)
    begin

        if(PWRITE)
            mem[PADDR[7:0]] <= PWDATA;
        else
            PRDATA <= mem[PADDR[7:0]];

    end

end

endmodule
