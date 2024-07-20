//By Alexander Peacock, undergrad at UCF ECE
//email: alexpeacock56ten@gmail.com

`timescale 1ns/1ns
`include "uButterfly.v"
`include "sobolrng.v"
`define TESTAMOUNT 10
`define NUMINPUTS_C 4

//used to check errors
class errorcheck;
    real uResult_Real [`NUMINPUTS_C-1:0];
    real uResult_Img [`NUMINPUTS_C-1:0];
    real eResult_Real [`NUMINPUTS_C-1:0];
    real eResult_Img [`NUMINPUTS_C-1:0];
    real fdenom;
    real cntReal [`NUMINPUTS_C-1:0];
    real cntImg [`NUMINPUTS_C-1:0];
    real cntiwImg;
    real cntiwReal;
    real outReal [`NUMINPUTS_C-1:0];
    real outImg [`NUMINPUTS_C-1:0];
    real asum_Real [`NUMINPUTS_C-1:0];
    real asum_Img [`NUMINPUTS_C-1:0];
    real mse_Real [`NUMINPUTS_C-1:0];
    real mse_Img [`NUMINPUTS_C-1:0];
    real rmse_Real [`NUMINPUTS_C-1:0];
    real rmse_Img [`NUMINPUTS_C-1:0];
    static int j;

    function new();
        asum_Real = '{default: '0};
        asum_Img = '{default: '0};
        fdenom = 0;
        cntReal = '{default: '0};
        cntImg = '{default: '0};
        cntiwReal = 0;
        cntiwImg = 0;
        outReal = '{default: '0};
        outImg = '{default: '0};
        j = 0;
    endfunction

    //accumulates to account for bitstreams
    function count(real a[`NUMINPUTS_C-1:0], b[`NUMINPUTS_C-1:0], c[`NUMINPUTS_C-1:0], d[`NUMINPUTS_C-1:0], oA, oB);
        for(int f = 0; f < `NUMINPUTS_C; f++) begin
            cntReal[f] = cntReal[f] + a[f];
            cntImg[f] = cntImg[f] + b[f];
            outReal[f] = outReal[f] + c[f];
            outImg[f] = outImg[f] + d[f];

        end
        cntiwReal = cntiwReal + oA;
        cntiwImg = cntiwImg + oB;
        fdenom++;
    endfunction

    //sums the results of a bitstream cycle
    function fSUM();
        real biReal [`NUMINPUTS_C-1:0]; 
        real biImg [`NUMINPUTS_C-1:0];
        real biwReal;
        real biwImg;

        //eResult for first two butterflies
        real bimid_Real [`NUMINPUTS_C-1:0];
        real bimid_Img [`NUMINPUTS_C-1:0];

        j++; //counts current run

        //bipolar representation
        for(int d = 0; d < `NUMINPUTS_C; d++) begin
            biReal[d] = (2*(cntReal[d]/fdenom)) - 1;
            biImg[d] = (2*(cntImg[d]/fdenom)) - 1;
        end
        biwReal = (2*(cntiwReal/fdenom)) - 1;
        biwImg = (2*(cntiwImg/fdenom)) - 1;


        
        $display("Run <%.0f>: ", j);
        $display("Number of 1s in input wReal = %.0f", cntiwReal);
        $display("Number of 1s in input wImg = %.0f", cntiwImg);
        $display("Length of bitstream = %.0f", fdenom);
        for(int r = 0; r < `NUMINPUTS_C; r++) begin
            $display("Number of 1s in input Real[%0d] = %.0f", r, cntReal[r]);
            $display("Number of 1s in input Img[%0d] = %.0f", r, cntImg[r]);
            $display("Number of 1s in output Real[%0d] = %.0f", r, outReal[r]);
            $display("Number of 1s in output Img[%0d] = %.0f", r, outImg[r]);
            $display("Bipolar Real[%0d] value = %.9f", r, biReal[r]);
            $display("Bipolar Image[%0d] value = %.9f\n", r, biImg[r]);
        end
        $display("Bipolar wReal value = %.9f", biwReal);
        $display("Bipolar wImg value = %.9f\n", biwImg);

        //unary result
        for(int y = 0; y < `NUMINPUTS_C; y++) begin
            uResult_Real[y] = (2*(outReal[y]/fdenom)) - 1;
            uResult_Img[y] = (2*(outImg[y]/fdenom)) - 1;
            $display("Unary result[%0d] = %.9f + %.9fi", y, uResult_Real[y], uResult_Img[y]);
        end
        
        //middle expected results      
        for(int e = 0; e < (`NUMINPUTS_C/2); e++) begin
            bimid_Real[e*2] = (biReal[(e*2)] + ((biReal[(e*2)+1]*biwReal) - (biImg[(e*2)+1]*biwImg)))/4;
            bimid_Img[e*2] = (biImg[(e*2)] + ((biReal[(e*2)+1]*biwImg) + (biImg[(e*2)+1]*biwReal)))/4;
            bimid_Real[(e*2)+1] = (biReal[(e*2)] - ((biReal[(e*2)+1]*biwReal) - (biImg[(e*2)+1]*biwImg)))/4;
            bimid_Img[(e*2)+1] = (biImg[(e*2)] - ((biReal[(e*2)+1]*biwImg) + (biImg[(e*2)+1]*biwReal)))/4;
        end
        
        //expected results
        eResult_Real[0] = (bimid_Real[0] + ((bimid_Real[2]*biwReal) - (bimid_Img[2]*biwImg)))/4; 
        eResult_Img[0] = (bimid_Img[0] + ((bimid_Real[2]*biwImg) + (bimid_Img[2]*biwReal)))/4;
        eResult_Real[2] = (bimid_Real[0] - ((bimid_Real[2]*biwReal) - (bimid_Img[2]*biwImg)))/4;
        eResult_Img[2] = (bimid_Img[0] - ((bimid_Real[2]*biwImg) + (bimid_Img[2]*biwReal)))/4;
        eResult_Real[1] = (bimid_Real[1] + ((bimid_Real[3]*biwReal) - (bimid_Img[3]*biwImg)))/4; 
        eResult_Img[1] = (bimid_Img[1] + ((bimid_Real[3]*biwImg) + (bimid_Img[3]*biwReal)))/4;
        eResult_Real[3] = (bimid_Real[1] - ((bimid_Real[3]*biwReal) - (bimid_Img[3]*biwImg)))/4;
        eResult_Img[3] = (bimid_Img[1] - ((bimid_Real[3]*biwImg) + (bimid_Img[3]*biwReal)))/4;


        for(int s = 0; s < `NUMINPUTS_C; s++) begin
            $display("Expected result[%0d] = %.9f + %.9fi", s, eResult_Real[s], eResult_Img[s]);
        end

        for(int i = 0; i < `NUMINPUTS_C; i++) begin
            asum_Real[i] = asum_Real[i] + ((uResult_Real[i] - eResult_Real[i]) * (uResult_Real[i] - eResult_Real[i]));
            asum_Img[i] = asum_Img[i] + ((uResult_Img[i] - eResult_Img[i]) * (uResult_Img[i] - eResult_Img[i]));
            $display("Real[%0d] cumulated square error = %.9f", i, asum_Real[i]);
            $display("Img[%0d] cumulated square error = %.9f", i, asum_Img[i]);
        end
        $display("\n");
        
        //resets for next bitstreams

        fdenom = 0;
        cntReal = '{default: '0};
        cntImg = '{default: '0};
        cntiwReal = 0;
        cntiwImg = 0;
        outReal = '{default: '0};
        outImg = '{default: '0};
    endfunction

    //mean squared error
    function fMSE();
        $display("Final Results: "); 
        for(int i = 0; i < `NUMINPUTS_C; i++) begin 
            mse_Real[i] = asum_Real[i] / `TESTAMOUNT;
            mse_Img[i] = asum_Img[i] / `TESTAMOUNT;
            $display("Real[%0d] mse: %.9f", i, mse_Real[i]);
            $display("Img[%0d] mse: %.9f", i, mse_Img[i]);
        end
    endfunction

    //root mean square error
    function fRMSE();
        for(int i = 0; i < `NUMINPUTS_C; i++) begin 
            rmse_Real[i] = $sqrt(mse_Real[i]);
            rmse_Img[i] = $sqrt(mse_Img[i]);
            $display("Real[%0d] rmse: %.9f", i, rmse_Real[i]);
            $display("Img[%0d] rmse: %.9f", i, rmse_Img[i]);
        end
    endfunction
    
endclass

module uSFFT_TB ();
    parameter BITWIDTH = 8;
    parameter BINPUT = 2;
    parameter NUMINPUTS = 4;
    logic iClk;
    logic iRstN;
    logic iReal [NUMINPUTS-1:0];
    logic iImg [NUMINPUTS-1:0];
    logic iClr;
    logic loadW;
    logic oBReal;
    logic oBImg;
    logic oReal [NUMINPUTS-1:0];
    logic oImg [NUMINPUTS-1:0];

    errorcheck error; //class for error checking

    //used for bitstream generation
    logic [BITWIDTH-1:0] sobolseq_tb [(NUMINPUTS*2)-1:0];
    logic [BITWIDTH-1:0] randReal [NUMINPUTS-1:0];
    logic [BITWIDTH-1:0] randImg [NUMINPUTS-1:0];
    logic [BITWIDTH-1:0] iwReal;
    logic [BITWIDTH-1:0] iwImg;

    
    // This code is used to delay the expected output
    parameter PPCYCLE = 1;

    // dont change code below
    logic resultReal [PPCYCLE-1:0][NUMINPUTS-1:0];
    logic resultImg [PPCYCLE-1:0][NUMINPUTS-1:0];
    logic result_expectedReal [NUMINPUTS-1:0];
    logic result_expectedImg [NUMINPUTS-1:0];

    integer l;
    always@(*) begin
        for(l = 0; l < NUMINPUTS; l = l + 1) begin
            result_expectedReal[l] = oReal[l];
            result_expectedImg[l] = oImg[l];
        end
    end

    genvar i;
    generate
        for (i = 1; i < PPCYCLE; i = i + 1) begin
            always@(posedge iClk or negedge iRstN) begin
                integer k;
                if (~iRstN) begin
                    for(k = 0; k < NUMINPUTS; k = k + 1) begin 
                        resultReal[i][k] <= 0;
                        resultImg[i][k] <= 0;
                    end
                end else begin
                    for(k = 0; k < NUMINPUTS; k = k + 1) begin
                        resultReal[i][k] <= resultReal[i-1][k];
                        resultImg[i][k] <= resultImg[i-1][k];
                    end
                end
            end
        end
    endgenerate

    integer m;

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            for(m = 0; m < NUMINPUTS; m = m + 1) begin 
                resultReal[0][m] <= 0;
                resultImg[0][m] <= 0;
            end
        end else begin
            for(m = 0; m < NUMINPUTS; m = m + 1) begin 
                resultReal[0][m] <= result_expectedReal[m];
                resultImg[0][m] <= result_expectedImg[m];
            end
        end
    end
    // end here
    
    genvar h;

    //generates stochastic bitstreams
    generate
    for(h = 0; h < NUMINPUTS*2; h = h + 1) begin :sobolrng_loop
        sobolrng #(
            .BITWIDTH(BITWIDTH)
        ) u_sobolrng_tbA1 (
            .iClk(iClk),
            .iRstN(iRstN),
            .iEn(1),
            .iClr(iClr),
            .sobolseq(sobolseq_tb[h])
        );
    end
    endgenerate
    

    uSFFT #(
        .BITWIDTH(BITWIDTH),
        .BINPUT(BINPUT)
    ) u_uSFFT(
        .iClk(iClk),
        .iRstN(iRstN),
        .iClr(iClr),
        .loadW(loadW),
        .iAReal0(iReal[0]),
        .iAImg0(iImg[0]),
        .iAReal1(iReal[1]),
        .iAImg1(iImg[1]),
        .iBReal0(iReal[2]),
        .iBImg0(iImg[2]),
        .iBReal1(iReal[3]),
        .iBImg1(iImg[3]),
        .iwReal(iwReal),
        .iwImg(iwImg),
        .oBReal(oBReal),
        .oBImg(oBImg),
        .o13Real0(oReal[0]),
        .o13Img0(oImg[0]), //TODO: CHANGE BACK IF DOESNT WORK MADE IT LOGIC WITH 
        .o13Real1(oReal[2]),
        .o13Img1(oImg[2]),
        .o24Real0(oReal[1]),
        .o24Img0(oImg[1]),
        .o24Real1(oReal[3]),
        .o24Img1(oImg[3])

    );

    always #5 iClk = ~iClk;

    initial begin 
        $dumpfile("uButterfly_tb.vcd"); $dumpvars;

        iClk = 1;
        iReal = '{default: '0};
        iImg = '{default: '0};
        iRstN = 0;
        iwReal = 0;
        iwImg = 0;
        randReal = '{default: '0};
        randImg = '{default: '0};
        iClr = 0;
        loadW = 1;
        error = new;

        #10;
        iRstN = 1;

        //specified cycles of unary bitstreams
        repeat(`TESTAMOUNT) begin
            for(int n = 0; n < NUMINPUTS; n++) begin
                randReal[n] = $urandom_range(255);
                randImg[n] = $urandom_range(255);
            end
            iwReal = $urandom_range(255);
            iwImg = $urandom_range(255);

            repeat(256) begin
                #10; 
                for(int u = 0; u < NUMINPUTS; u++) begin
                    iReal[u] = (randReal[u] > sobolseq_tb[u]);
                    iImg[u] = (randImg[u] > sobolseq_tb[u+4]);
                end
                error.count(iReal, iImg, resultReal[PPCYCLE-1], resultImg[PPCYCLE-1], oBReal, oBImg);

            end
            error.fSUM();

        end

        //gives final error results
        error.fMSE();
        error.fRMSE();

        iClr = 1;
        iReal = '{default: '0};
        iImg = '{default: '0};
        iwReal = 0;
        iwImg = 0;
        #400;
        
        #10;
        #100;

        $finish;

    end

endmodule 
