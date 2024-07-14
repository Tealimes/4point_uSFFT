//By Alexander Peacock, undergrad at UCF ECE
//email: alexpeacock56ten@gmail.com

`timescale 1ns/1ns
`include "uButterfly.v"
`include "sobolrng.v"
`define TESTAMOUNT 10
//used to check errors
class errorcheck;
    real uResult_CReal0;
    real uResult_CImg0;
    real uResult_CReal1;
    real uResult_CImg1;
    real eResult_CReal0;
    real eResult_CImg0;
    real eResult_CReal1;
    real eResult_CImg1;
    real uResult_DReal0;
    real uResult_DImg0;
    real uResult_DReal1;
    real uResult_DImg1;
    real eResult_DReal0;
    real eResult_DImg0;
    real eResult_DReal1;
    real eResult_DImg1;
    real fdenom;
    real cntAReal0;
    real cntAImg0;
    real cntAReal1;
    real cntAImg1;
    real cntBReal0;
    real cntBImg0;
    real cntBReal1;
    real cntBImg1;
    real cntiwImg;
    real cntiwReal;
    real outCReal0;
    real outCImg0;
    real outCReal1;
    real outCImg1;
    real outDReal0;
    real outDImg0;
    real outDReal1;
    real outDImg1;
    real asum_CReal0;
    real asum_CImg0;
    real asum_CReal1;
    real asum_CImg1;
    real asum_DReal0;
    real asum_DImg0;
    real asum_DReal1;
    real asum_DImg1;
    real mse_CReal0;
    real mse_CImg0;
    real mse_CReal1;
    real mse_CImg1;
    real rmse_CReal0;
    real rmse_CImg0;
    real rmse_CReal1;
    real rmse_CImg1;
    real mse_DReal0;
    real mse_DImg0;
    real mse_DReal1;
    real mse_DImg1;
    real rmse_DReal0;
    real rmse_DImg0;
    real rmse_DReal1;
    real rmse_DImg1;
    static int j;

    function new();
        asum_CReal0 = 0;
        asum_CImg0 = 0;
        asum_CReal1 = 0;
        asum_CImg1 = 0;
        asum_DReal0 = 0;
        asum_DImg0 = 0;
        asum_DReal1 = 0;
        asum_DImg1 = 0;
        fdenom = 0;
        cntAReal0 = 0;
        cntAImg0 = 0;
        cntAReal1 = 0;
        cntAImg1 = 0;
        cntBReal0 = 0;
        cntBImg0 = 0;
        cntBReal1 = 0;
        cntBImg1 = 0;
        cntiwReal = 0;
        cntiwImg = 0;
        outCReal0 = 0;
        outCImg0 = 0;
        outCReal1 = 0;
        outCImg1 = 0;
        outDReal0 = 0;
        outDImg0 = 0;
        outDReal1 = 0;
        outDImg1 = 0;
        j = 0;
    endfunction

    //accumulates to account for bitstreams
    function count(real a, b, c, d, e, f, g, h, i, j, oA, oB, oC, oD, oE, oF, oG, oH);
        cntAReal0 = cntAReal0 + a;
        cntAImg0 = cntAImg0 + b;
        cntAReal1 = cntAReal1 + c;
        cntAImg1 = cntAImg1 + d;
        cntBReal0 = cntBReal0 + e;
        cntBImg0 = cntBImg0 + f;
        cntBReal1 = cntBReal1 + g;
        cntBImg1 = cntBImg1 + h;
        cntiwReal = cntiwReal + i;
        cntiwImg = cntiwImg + j;
        outCReal0 = outCReal0 + oA;
        outCImg0 = outCImg0 + oB;
        outCReal1 = outCReal1 + oC;
        outCImg1 = outCImg1 + oD;
        outDReal0 = outDReal0 + oE;
        outDImg0 = outDImg0 + oF;
        outDReal1 = outDReal1 + oG;
        outDImg1 = outDImg1 + oH;

        fdenom++;
    endfunction

    //sums the results of a bitstream cycle
    function fSUM();
        real biAReal0; 
        real biAImg0;
        real biAReal1;
        real biAImg1;
        real biBReal0; 
        real biBImg0;
        real biBReal1;
        real biBImg1;
        real biwReal;
        real biwImg;

        //eResult for first two butterflies
        real bimid1_Real0;
        real bimid1_Img0;
        real bimid1_Real1;
        real bimid1_Img1;
        real bimid2_Real0;
        real bimid2_Img0;
        real bimid2_Real1;
        real bimid2_Img1;

        j++; //counts current run

        biAReal0 = (2*(cntAReal0/fdenom)) - 1;
        biAImg0 = (2*(cntAImg0/fdenom)) - 1;
        biAReal1 = (2*(cntAReal1/fdenom)) - 1;
        biAImg1 = (2*(cntAImg1/fdenom)) - 1;
        biBReal0 = (2*(cntBReal0/fdenom)) - 1;
        biBImg0 = (2*(cntBImg0/fdenom)) - 1;
        biBReal1 = (2*(cntBReal1/fdenom)) - 1;
        biBImg1 = (2*(cntBImg1/fdenom)) - 1;
        biwReal = (2*(cntiwReal/fdenom)) - 1;
        biwImg = (2*(cntiwImg/fdenom)) - 1;

        //bipolar representation
        
        $display("Run <%.0f>: ", j);
        $display("Length of bitstream = %.0f", fdenom);
        $display("Number of 1s in input AReal0 = %.0f", cntAReal0);
        $display("Number of 1s in input AImg0 = %.0f", cntAImg0);
        $display("Number of 1s in input AReal1 = %.0f", cntAReal1);
        $display("Number of 1s in input AImg1 = %.0f", cntAImg1);
        $display("Number of 1s in input BReal0 = %.0f", cntBReal0);
        $display("Number of 1s in input BImg0 = %.0f", cntBImg0);
        $display("Number of 1s in input BReal1 = %.0f", cntBReal1);
        $display("Number of 1s in input BImg1 = %.0f", cntBImg1);
        $display("Number of 1s in input wReal = %.0f", cntiwReal);
        $display("Number of 1s in input wImg = %.0f", cntiwImg);
        $display("Number of 1s in output CReal0 = %.0f", outCReal0);
        $display("Number of 1s in output CImg0 = %.0f", outCImg0);
        $display("Number of 1s in output CReal1 = %.0f", outCReal1);
        $display("Number of 1s in output CImg1 = %.0f\n", outCImg1);
        $display("Number of 1s in output DReal0 = %.0f", outDReal0);
        $display("Number of 1s in output DImg0 = %.0f", outDImg0);
        $display("Number of 1s in output DReal1 = %.0f", outDReal1);
        $display("Number of 1s in output DImg1 = %.0f\n", outDImg1);

        $display("Bipolar AReal0 value = %.9f", biAReal0);
        $display("Bipolar AImage0 value = %.9f", biAImg0);
        $display("Bipolar AReal1 value = %.9f", biAReal1);
        $display("Bipolar AImage1 value = %.9f", biAImg1);
        $display("Bipolar BReal0 value = %.9f", biBReal0);
        $display("Bipolar BImage0 value = %.9f", biBImg0);
        $display("Bipolar BReal1 value = %.9f", biBReal1);
        $display("Bipolar BImage1 value = %.9f", biBImg1);
        $display("Bipolar wReal value = %.9f", biwReal);
        $display("Bipolar wImg value = %.9f\n", biwImg);
        
        //unary result
        uResult_CReal0 = (2*(outCReal0/fdenom)) - 1;
        uResult_CImg0 = (2*(outCImg0/fdenom)) - 1;
        uResult_CReal1 = (2*(outCReal1/fdenom)) - 1;
        uResult_CImg1 = (2*(outCImg1/fdenom)) - 1;
        uResult_DReal0 = (2*(outDReal0/fdenom)) - 1;
        uResult_DImg0 = (2*(outDImg0/fdenom)) - 1;
        uResult_DReal1 = (2*(outDReal1/fdenom)) - 1;
        uResult_DImg1 = (2*(outDImg1/fdenom)) - 1;

        //middle expected results
        bimid1_Real0 = (biAReal0 + ((biAReal1*biwReal) - (biAImg1*biwImg)))/4;
        bimid1_Img0 = (biAImg0 + ((biAReal1*biwImg) + (biAImg1*biwReal)))/4;
        bimid1_Real1 = (biAReal0 - ((biAReal1*biwReal) - (biAImg1*biwImg)))/4;
        bimid1_Img1 = (biAImg0 - ((biAReal1*biwImg) + (biAImg1*biwReal)))/4;
        bimid2_Real0 = (biBReal0 + ((biBReal1*biwReal) - (biBImg1*biwImg)))/4;
        bimid2_Img0 = (biBImg0 + ((biBReal1*biwImg) + (biBImg1*biwReal)))/4;
        bimid2_Real1 = (biBReal0 - ((biBReal1*biwReal) - (biBImg1*biwImg)))/4;
        bimid2_Img1 = (biBImg0 - ((biBReal1*biwImg) + (biBImg1*biwReal)))/4;

        //expected results
        eResult_CReal0 = (bimid1_Real0 + ((bimid2_Real0*biwReal) - (bimid2_Img0*biwImg)))/4; 
        eResult_CImg0 = (bimid1_Img0 + ((bimid2_Real0*biwImg) + (bimid2_Img0*biwReal)))/4;
        eResult_CReal1 = (bimid1_Real0 - ((bimid2_Real0*biwReal) - (bimid2_Img0*biwImg)))/4;
        eResult_CImg1 = (bimid1_Img0 - ((bimid2_Real0*biwImg) + (bimid2_Img0*biwReal)))/4;
        eResult_DReal0 = (bimid1_Real1 + ((bimid2_Real1*biwReal) - (bimid2_Img1*biwImg)))/4; 
        eResult_DImg0 = (bimid1_Img1 + ((bimid2_Real1*biwImg) + (bimid2_Img1*biwReal)))/4;
        eResult_DReal1 = (bimid1_Real1 - ((bimid2_Real1*biwReal) - (bimid2_Img1*biwImg)))/4;
        eResult_DImg1 = (bimid1_Img1 - ((bimid2_Real1*biwImg) + (bimid2_Img1*biwReal)))/4;

        $display("Unary result C0 = %.9f + %.9fi", uResult_CReal0, uResult_CImg0);
        $display("Unary result C1 = %.9f + %.9fi", uResult_CReal1, uResult_CImg1);
        $display("Unary result D0 = %.9f + %.9fi", uResult_DReal0, uResult_DImg0);
        $display("Unary result D1 = %.9f + %.9fi\n", uResult_DReal1, uResult_DImg1);
        
        $display("Expected result C0 = %.9f + %.9fi", eResult_CReal0, eResult_CImg0);
        $display("Expected result C1 = %.9f + %.9fi", eResult_CReal1, eResult_CImg1);
        $display("Expected result D0 = %.9f + %.9fi", eResult_DReal0, eResult_DImg0);
        $display("Expected result D1 = %.9f + %.9fi\n", eResult_DReal1, eResult_DImg1);

        asum_CReal0 = asum_CReal0 + ((uResult_CReal0 - eResult_CReal0) * (uResult_CReal0 - eResult_CReal0));
        asum_CImg0 = asum_CImg0 + ((uResult_CImg0 - eResult_CImg0) * (uResult_CImg0 - eResult_CImg0));
        asum_CReal1 = asum_CReal1 + ((uResult_CReal1 - eResult_CReal1) * (uResult_CReal1 - eResult_CReal1));
        asum_CImg1 = asum_CImg1 + ((uResult_CImg1 - eResult_CImg1) * (uResult_CImg1 - eResult_CImg1));
        asum_DReal0 = asum_DReal0 + ((uResult_DReal0 - eResult_DReal0) * (uResult_DReal0 - eResult_DReal0));
        asum_DImg0 = asum_DImg0 + ((uResult_DImg0 - eResult_DImg0) * (uResult_DImg0 - eResult_DImg0));
        asum_DReal1 = asum_DReal1 + ((uResult_DReal1 - eResult_DReal1) * (uResult_DReal1 - eResult_DReal1));
        asum_DImg1 = asum_DImg1 + ((uResult_DImg1 - eResult_DImg1) * (uResult_DImg1 - eResult_DImg1));
        $display("CReal0 cumulated square error = %.9f", asum_CReal0);
        $display("CImg0 cumulated square error = %.9f", asum_CImg0);
        $display("CReal1 cumulated square error = %.9f", asum_CReal1);
        $display("CImg1 cumulated square error = %.9f\n", asum_CImg1);
        $display("DReal0 cumulated square error = %.9f", asum_DReal0);
        $display("DImg0 cumulated square error = %.9f", asum_DImg0);
        $display("DReal1 cumulated square error = %.9f", asum_DReal1);
        $display("DImg1 cumulated square error = %.9f\n", asum_DImg1);
        
        //resets for next bitstreams

        fdenom = 0;
        cntAReal0 = 0;
        cntAImg0 = 0;
        cntAReal1 = 0;
        cntAImg1 = 0;
        cntBReal0 = 0;
        cntBImg0 = 0;
        cntBReal1 = 0;
        cntBImg1 = 0;
        cntiwReal = 0;
        cntiwImg = 0;
        outCReal0 = 0;
        outCImg0 = 0;
        outCReal1 = 0;
        outCImg1 = 0;
        outDReal0 = 0;
        outDImg0 = 0;
        outDReal1 = 0;
        outDImg1 = 0;
    endfunction

    //mean squared error
    function fMSE();
        $display("Final Results: "); 
        mse_CReal0 = asum_CReal0 / `TESTAMOUNT;
        mse_CImg0 = asum_CImg0 / `TESTAMOUNT;
        mse_CReal1 = asum_CReal1 / `TESTAMOUNT;
        mse_CImg1 = asum_CImg1 / `TESTAMOUNT;
        mse_DReal0 = asum_DReal0 / `TESTAMOUNT;
        mse_DImg0 = asum_DImg0 / `TESTAMOUNT;
        mse_DReal1 = asum_DReal1 / `TESTAMOUNT;
        mse_DImg1 = asum_DImg1 / `TESTAMOUNT;
        $display("CReal0 mse: %.9f", mse_CReal0);
        $display("CImg0 mse: %.9f", mse_CImg0);
        $display("CReal1 mse: %.9f", mse_CReal1);
        $display("CImg1 mse: %.9f", mse_CImg1);
        $display("DReal0 mse: %.9f", mse_DReal0);
        $display("DImg0 mse: %.9f", mse_DImg0);
        $display("DReal1 mse: %.9f", mse_DReal1);
        $display("DImg1 mse: %.9f", mse_DImg1);
    endfunction

    //root mean square error
    function fRMSE();
        rmse_CReal0 = $sqrt(mse_CReal0);
        rmse_CImg0 = $sqrt(mse_CImg0);
        rmse_CReal1 = $sqrt(mse_CReal1);
        rmse_CImg1 = $sqrt(mse_CImg1);
        rmse_DReal0 = $sqrt(mse_DReal0);
        rmse_DImg0 = $sqrt(mse_DImg0);
        rmse_DReal1 = $sqrt(mse_DReal1);
        rmse_DImg1 = $sqrt(mse_DImg1);
        $display("CReal0 rmse: %.9f", rmse_CReal0);
        $display("CImg0 rmse: %.9f", rmse_CImg0);
        $display("CReal1 rmse: %.9f", rmse_CReal1);
        $display("CImg1 rmse: %.9f", rmse_CImg1);
        $display("DReal0 rmse: %.9f", rmse_DReal0);
        $display("DImg0 rmse: %.9f", rmse_DImg0);
        $display("DReal1 rmse: %.9f", rmse_DReal1);
        $display("DImg1 rmse: %.9f", rmse_DImg1);
    endfunction

endclass

module uSFFT_TB ();
    parameter BITWIDTH = 8;
    parameter BINPUT = 2;
    logic iClk;
    logic iRstN;
    logic iAReal0;
    logic iAImg0;
    logic iAReal1;
    logic iAImg1;
    logic iBReal0;
    logic iBImg0;
    logic iBReal1;
    logic iBImg1;
    logic iClr;
    logic loadW;
    logic oBReal;
    logic oBImg;
    logic oCReal0;
    logic oCImg0;
    logic oCReal1;
    logic oCImg1;
    logic oDReal0;
    logic oDImg0;
    logic oDReal1;
    logic oDImg1;

    
    errorcheck error; //class for error checking

    //used for bitstream generation
    logic [BITWIDTH-1:0] sobolseq_tbA1;
    logic [BITWIDTH-1:0] sobolseq_tbB1;
    logic [BITWIDTH-1:0] sobolseq_tbC1;
    logic [BITWIDTH-1:0] sobolseq_tbD1;
    logic [BITWIDTH-1:0] sobolseq_tbA2;
    logic [BITWIDTH-1:0] sobolseq_tbB2;
    logic [BITWIDTH-1:0] sobolseq_tbC2;
    logic [BITWIDTH-1:0] sobolseq_tbD2;
    logic [BITWIDTH-1:0] rand_iAReal0;
    logic [BITWIDTH-1:0] rand_iAImg0;
    logic [BITWIDTH-1:0] rand_iAReal1;
    logic [BITWIDTH-1:0] rand_iAImg1;
    logic [BITWIDTH-1:0] rand_iBReal0;
    logic [BITWIDTH-1:0] rand_iBImg0;
    logic [BITWIDTH-1:0] rand_iBReal1;
    logic [BITWIDTH-1:0] rand_iBImg1;
    logic [BITWIDTH-1:0] iwReal;
    logic [BITWIDTH-1:0] iwImg;

    
    // This code is used to delay the expected output
    parameter PPCYCLE = 1;

    // dont change code below
    logic result1 [PPCYCLE-1:0];
    logic result_expected1;
    assign result_expected1 = oCReal0;
    logic result2 [PPCYCLE-1:0];
    logic result_expected2;
    assign result_expected2 = oCImg0;
    logic result3 [PPCYCLE-1:0];
    logic result_expected3;
    assign result_expected3 = oCReal1;
    logic result4 [PPCYCLE-1:0];
    logic result_expected4;
    assign result_expected4 = oCImg1;

    logic result5 [PPCYCLE-1:0];
    logic result_expected5;
    assign result_expected5 = oDReal0;
    logic result6 [PPCYCLE-1:0];
    logic result_expected6;
    assign result_expected6 = oDImg0;
    logic result7 [PPCYCLE-1:0];
    logic result_expected7;
    assign result_expected7 = oDReal1;
    logic result8 [PPCYCLE-1:0];
    logic result_expected8;
    assign result_expected8 = oDImg1;

    genvar i;
    generate
        for (i = 1; i < PPCYCLE; i = i + 1) begin
            always@(posedge iClk or negedge iRstN) begin
                if (~iRstN) begin
                    result1[i] <= 0;
                    result2[i] <= 0;
                    result3[i] <= 0;
                    result4[i] <= 0;
                    result5[i] <= 0;
                    result6[i] <= 0;
                    result7[i] <= 0;
                    result8[i] <= 0;
                end else begin
                    result1[i] <= result1[i-1];
                    result2[i] <= result2[i-1];
                    result3[i] <= result3[i-1];
                    result4[i] <= result4[i-1];
                    result5[i] <= result5[i-1];
                    result6[i] <= result6[i-1];
                    result7[i] <= result7[i-1];
                    result8[i] <= result8[i-1];
                end
            end
        end
    endgenerate

    always@(posedge iClk or negedge iRstN) begin
        if (~iRstN) begin
            result1[0] <= 0;
            result2[0] <= 0;
            result3[0] <= 0;
            result4[0] <= 0;
            result5[0] <= 0;
            result6[0] <= 0;
            result7[0] <= 0;
            result8[0] <= 0;
        end else begin
            result1[0] <= result_expected1;
            result2[0] <= result_expected2;
            result3[0] <= result_expected3;
            result4[0] <= result_expected4;
            result5[0] <= result_expected5;
            result6[0] <= result_expected6;
            result7[0] <= result_expected7;
            result8[0] <= result_expected8;
        end
    end
    // end here
    

    //generates two stochastic bitstreams
    sobolrng #(
        .BITWIDTH(BITWIDTH)
    ) u_sobolrng_tbA1 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(1),
        .iClr(iClr),
        .sobolseq(sobolseq_tbA1)
    );
    
    sobolrng #(
        .BITWIDTH(BITWIDTH)
    ) u_sobolrng_tbB1 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(1),
        .iClr(iClr),
        .sobolseq(sobolseq_tbB1)
    );

    sobolrng #(
        .BITWIDTH(BITWIDTH)
    ) u_sobolrng_tbC1 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(1),
        .iClr(iClr),
        .sobolseq(sobolseq_tbC1)
    );

    sobolrng #(
        .BITWIDTH(BITWIDTH)
    ) u_sobolrng_tbD1 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(1),
        .iClr(iClr),
        .sobolseq(sobolseq_tbD1)
    );

    sobolrng #(
        .BITWIDTH(BITWIDTH)
    ) u_sobolrng_tbA2 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(1),
        .iClr(iClr),
        .sobolseq(sobolseq_tbA2)
    );
    
    sobolrng #(
        .BITWIDTH(BITWIDTH)
    ) u_sobolrng_tbB2 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(1),
        .iClr(iClr),
        .sobolseq(sobolseq_tbB2)
    );

    sobolrng #(
        .BITWIDTH(BITWIDTH)
    ) u_sobolrng_tbC2 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(1),
        .iClr(iClr),
        .sobolseq(sobolseq_tbC2)
    );

    sobolrng #(
        .BITWIDTH(BITWIDTH)
    ) u_sobolrng_tbD2 (
        .iClk(iClk),
        .iRstN(iRstN),
        .iEn(1),
        .iClr(iClr),
        .sobolseq(sobolseq_tbD2)
    );

    uSFFT #(
        .BITWIDTH(BITWIDTH),
        .BINPUT(BINPUT)
    ) u_uSFFT(
        .iClk(iClk),
        .iRstN(iRstN),
        .iClr(iClr),
        .loadW(loadW),
        .iAReal0(iAReal0),
        .iAImg0(iAImg0),
        .iAReal1(iAReal1),
        .iAImg1(iAImg1),
        .iBReal0(iBReal0),
        .iBImg0(iBImg0),
        .iBReal1(iBReal1),
        .iBImg1(iBImg1),
        .iwReal(iwReal),
        .iwImg(iwImg),
        .oBReal(oBReal),
        .oBImg(oBImg),
        .oCReal0(oCReal0),
        .oCImg0(oCImg0),
        .oCReal1(oCReal1),
        .oCImg1(oCImg1),
        .oDReal0(oDReal0),
        .oDImg0(oDImg0),
        .oDReal1(oDReal1),
        .oDImg1(oDImg1)
    );

    always #5 iClk = ~iClk;

    initial begin 
        $dumpfile("uButterfly_tb.vcd"); $dumpvars;

        iClk = 1;
        iAReal0 = 0;
        iAImg0 = 0;
        iAReal1 = 0;
        iAImg1 = 0;
        iBReal0 = 0;
        iBImg0 = 0;
        iBReal1 = 0;
        iBImg1 = 0;
        iRstN = 0;
        iwReal = 0;
        iwImg = 0;
        rand_iAReal0 = 0;
        rand_iAImg0 = 0;
        rand_iAReal1 = 0;
        rand_iAImg1 = 0;
        rand_iBReal0 = 0;
        rand_iBImg0 = 0;
        rand_iBReal1 = 0;
        rand_iBImg1 = 0;
        iClr = 0;
        loadW = 1;
        error = new;


        #10;
        iRstN = 1;

        
        //specified cycles of unary bitstreams
        repeat(`TESTAMOUNT) begin
            rand_iAReal0 = $urandom_range(255);
            rand_iAImg0 = $urandom_range(255);
            rand_iAReal1 = $urandom_range(255);
            rand_iAImg1 = $urandom_range(255);
            rand_iBReal0 = $urandom_range(255);
            rand_iBImg0 = $urandom_range(255);
            rand_iBReal1 = $urandom_range(255);
            rand_iBImg1 = $urandom_range(255);
            iwReal = $urandom_range(255);
            iwImg = $urandom_range(255);

            repeat(256) begin
                #10; 
                iAReal0 = (rand_iAReal0 > sobolseq_tbA1);
                iAImg0 = (rand_iAImg0 > sobolseq_tbB1);
                iAReal1 = (rand_iAReal1 > sobolseq_tbC1);
                iAImg1 = (rand_iAImg1 > sobolseq_tbD1);
                iBReal0 = (rand_iBReal0 > sobolseq_tbA2);
                iBImg0 = (rand_iBImg0 > sobolseq_tbB2);
                iBReal1 = (rand_iBReal1 > sobolseq_tbC2);
                iBImg1 = (rand_iBImg1 > sobolseq_tbD2);
                error.count(iAReal0, iAImg0, iAReal1, iAImg1, iBReal0, iBImg0, iBReal1, iBImg1, oBReal, oBImg, 
                oCReal0, oCImg0, oCReal1, oCImg1, oDReal0, oDImg0, oDReal1, oDImg1);

            end
            error.fSUM();

        end

        //gives final error results

        iClr = 1;
        iAReal0 = 0;
        iAImg0 = 0;
        iAReal1 = 0;
        iAImg1 = 0;
        iBReal0 = 0;
        iBImg0 = 0;
        iBReal1 = 0;
        iBImg1 = 0;
        iwReal = 0;
        iwImg = 0;
        #400;
        
        #10;
        #100;

        $finish;

    end

endmodule 
