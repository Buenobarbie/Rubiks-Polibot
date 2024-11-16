module rom_quadrados
(
    input wire [5:0] addr1,
    input wire [5:0] addr2,
    input wire [5:0] addr3,
    output wire [11:0] data1,
    output wire [11:0] data2,
    output wire [11:0] data3

);

    reg [11:0] mem [63:0];

    initial begin
        mem[0] = 0;
        mem[1] = 1;
        mem[2] = 4;
        mem[3] = 9;
        mem[4] = 16;
        mem[5] = 25;
        mem[6] = 36;
        mem[7] = 49;
        mem[8] = 64;
        mem[9] = 81;
        mem[10] = 100;
        mem[11] = 121;
        mem[12] = 144;
        mem[13] = 169;
        mem[14] = 196;
        mem[15] = 225;
        mem[16] = 256;
        mem[17] = 289;
        mem[18] = 324;
        mem[19] = 361;
        mem[20] = 400;
        mem[21] = 441;
        mem[22] = 484;
        mem[23] = 529;
        mem[24] = 576;
        mem[25] = 625;
        mem[26] = 676;
        mem[27] = 729;
        mem[28] = 784;
        mem[29] = 841;
        mem[30] = 900;
        mem[31] = 961;
        mem[32] = 1024;
        mem[33] = 1089;
        mem[34] = 1156;
        mem[35] = 1225;
        mem[36] = 1296;
        mem[37] = 1369;
        mem[38] = 1444;
        mem[39] = 1521;
        mem[40] = 1600;
        mem[41] = 1681;
        mem[42] = 1764;
        mem[43] = 1849;
        mem[44] = 1936;
        mem[45] = 2025;
        mem[46] = 2116;
        mem[47] = 2209;
        mem[48] = 2304;
        mem[49] = 2401;
        mem[50] = 2500;
        mem[51] = 2601;
        mem[52] = 2704;
        mem[53] = 2809;
        mem[54] = 2916;
        mem[55] = 3025;
        mem[56] = 3136;
        mem[57] = 3249;
        mem[58] = 3364;
        mem[59] = 3481;
        mem[60] = 3600;
        mem[61] = 3721;
        mem[62] = 3844;
        mem[63] = 3969;
    end

    assign data1 = mem[addr1];
    assign data2 = mem[addr2];
    assign data3 = mem[addr3];

endmodule