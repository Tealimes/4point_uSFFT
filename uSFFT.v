//By Alexander Peacock, undergrad at UCF ECE
//email: alexpeacock56ten@gmail.com

`ifndef uSFFT
`define uSFFT

`include "uButterfly.v"

module uSFFT #(
    parameter BITWIDTH = 8,
    parameter BINPUT = 2,
    parameter NUMINPUT = 4
) (
    input wire iClk,
    input wire iRstN,
    input wire loadW,
    input wire iClr,
    input wire [NUMINPUT-1:0] iReal,
    input wire [NUMINPUT-1:0] iImg,
    input wire [BITWIDTH-1:0] iwReal,
    input wire [BITWIDTH-1:0] iwImg,
    output wire oBReal,
    output wire oBImg,
    output wire [NUMINPUT-1:0] oReal,
    output wire [NUMINPUT-1:0] oImg
);

    //the ouputs of the initial input butterflies
    wire [NUMINPUT-1:0] mid_Real;
    wire [NUMINPUT-1:0] mid_Img;

    genvar i;

    generate 
        for(i=0; i<NUMINPUT/2; i = i + 1) begin
            uButterfly #(
                .BITWIDTH(BITWIDTH),
                .BINPUT(BINPUT)
            ) u_uButterfly_in (
                .iClk(iClk),
                .iRstN(iRstN),
                .loadW(loadW),
                .iClr(iClr),
                .iReal0(iReal[(i*2)]),
                .iImg0(iImg[(i*2)]),
                .iReal1(iReal[(i*2)+1]),
                .iImg1(iImg[(i*2)+1]),
                .iwReal(iwReal),
                .iwImg(iwImg),
                .oReal0(mid_Real[(i*2)]),
                .oImg0(mid_Img[(i*2)]),      
                .oReal1(mid_Real[(i*2)+1]),
                .oImg1(mid_Img[(i*2)+1])
            );
        end
    endgenerate

    genvar j;
    generate 
        for(j=0; j < NUMINPUT/2; j = j + 1) begin
            uButterfly #(
                .BITWIDTH(BITWIDTH),
                .BINPUT(BINPUT)
            ) u_uButterfly_out (
                .iClk(iClk),
                .iRstN(iRstN),
                .loadW(loadW),
                .iClr(iClr),
                .iReal0(mid_Real[j]),
                .iImg0(mid_Img[j]),
                .iReal1(mid_Real[j + NUMINPUT/2]),
                .iImg1(mid_Img[j + NUMINPUT/2]),
                .iwReal(iwReal),
                .iwImg(iwImg),
                .oReal0(oReal[j]),
                .oImg0(oImg[j]),
                .oReal1(oReal[j + NUMINPUT/2]),
                .oImg1(oImg[j + NUMINPUT/2])
            );
        end
    endgenerate
endmodule

`endif 
