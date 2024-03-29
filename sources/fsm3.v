`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.10.2023 12:48:41
// Design Name: 
// Module Name: fsm
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module fsm3 (    
    input             data_ready,
    input      [0:31] data,
    input      [2:0]  capacity,
    input             clk,
    
    output reg        ready_result,
    output reg        result_end,
    output reg [5:0]  res_count,
    output reg [9:0] result //10 bits = 5 * 2 ; 5 - переменных в импилканте, 
                             //2 - бита для кодирования одного символа в импилканте (0,1,-,*)  
);
   
parameter WAIT_FOR_DATA = 0;
parameter READ_IMPLICANTS = 1;
parameter FILLING_THE_INITIAL_GROUP = 2;
parameter COMPARE_FOR_MERGING = 3;
parameter MERGING = 4;
parameter GET_COUNT_OF_1_IN_LOCAL = 5;
parameter SET_MERGED_VAL_IN_NEXT_COLUMN = 6; //set merged value in next column of merging table
parameter COMPARE_IMPLICANTS = 7;     
parameter ITERATTION_J = 8;  //TODO: убрать вторую t 
parameter ITERATTION_I = 9;
parameter ITERATTION_CMP = 10;        
parameter FIND_SIMPLE_IMPLICANTS = 11;
parameter FILL_1_POINTS = 12;
parameter COMPARE_FOR_Q_TABLE = 13;
parameter FILL_QUINE_TABLE = 14;
parameter CORE_IMPLICANT_CHECK = 15;      
parameter FIND_CORE_IMPLICANTS = 16;
parameter INDICATE_COVERED_LINES = 17; 
parameter CREATE_PETRICK_TABLE = 18;
parameter PETRICK_METHODS_CALCULATIONS = 19;
parameter WRITE_RESULT = 20;
parameter READY_RESULT_FLAG = 21;
parameter SEND_RESULT = 22;
parameter RESET = 31;
      
reg [4:0] state;
initial begin
    state = RESET;
end
`include "fsm_regs.vh"


always@(posedge clk) begin
    case(state)
    WAIT_FOR_DATA: begin
        if(data_ready) begin
            state <= state + 1;//READ_IMPLICANTS
        end
    end
    READ_IMPLICANTS: begin
        if(z1 == 31) begin
            state <= state + 1;//FILLING_THE_INITIAL_GROUPs
        end
        if (data[z1] == 1'b1) begin
            implicants[ci][0] <= {1'b0, z1[4]};
            implicants[ci][1] <= {1'b0, z1[3]};
            implicants[ci][2] <= {1'b0, z1[2]};
            implicants[ci][3] <= {1'b0, z1[1]};
            implicants[ci][4] <= {1'b0, z1[0]};
            implicants[ci][5] <= 2'b00;
            ci <= ci+1;            
        end
        z1 <= z1 + 1;        
    end
    FILLING_THE_INITIAL_GROUP: begin
        ci12 <= ci;
        if (l2 < ci) begin
            cntr2 = 0;
            for(z2 = 0; z2 < 5; z2=z2+1) begin//Убрать в отдельное состояние
                if (implicants[l2][z2] == 2'b01)
                    cntr2 = cntr2+1;
            end
            groups0 [cntr2] [cn[0][cntr2]][0] <= implicants[l2][0];
            groups0 [cntr2] [cn[0][cntr2]][1] <= implicants[l2][1];    
            groups0 [cntr2] [cn[0][cntr2]][2] <= implicants[l2][2];    
            groups0 [cntr2] [cn[0][cntr2]][3] <= implicants[l2][3];    
            groups0 [cntr2] [cn[0][cntr2]][4] <= implicants[l2][4]; 
            groups0 [cntr2] [cn[0][cntr2]][5] <= implicants[l2][5];
            //c[l2] <= cntr2;
            cn[0][cntr2] <= cn[0][cntr2] + 1;   
            l2 <= l2 + 1;
        end
        else begin
            state <= state + 1;   //COMPARE_FOR_MERGING
        end    
    end 
    COMPARE_FOR_MERGING: begin //compare two implicants to understand if can we merge them  
        if (j < cn[ml][cmp_d] && i < cn[ml][cmp_u]) begin
            case(ml)
            0: begin
                for (z3 = 0; z3 < 5; z3=z3+1) begin
                    if(groups0[cmp_u][i][z3] != groups0[cmp_d][j][z3])begin
                        local_count = local_count + 1;
                        t_pos = z3;    
                    end
                end    
            end
            1: begin
                for (z3 = 0; z3 < 5; z3=z3+1) begin
                    if(groups1[cmp_u][i][z3] != groups1[cmp_d][j][z3])begin
                        local_count = local_count + 1;
                        t_pos = z3;    
                    end
                end    
            end
            2: begin
                for (z3 = 0; z3 < 5; z3=z3+1) begin
                    if(groups2[cmp_u][i][z3] != groups2[cmp_d][j][z3])begin
                        local_count = local_count + 1;
                        t_pos = z3;    
                    end
                end    
            end
            3: begin
                for (z3 = 0; z3 < 5; z3=z3+1) begin
                    if(groups3[cmp_u][i][z3] != groups3[cmp_d][j][z3])begin
                        local_count = local_count + 1;
                        t_pos = z3;    
                    end
                end    
            end
            4: begin
                for (z3 = 0; z3 < 5; z3=z3+1) begin
                    if(groups4[cmp_u][i][z3] != groups4[cmp_d][j][z3])begin
                        local_count = local_count + 1;
                        t_pos = z3;    
                    end
                end    
            end
            5: begin
                for (z3 = 0; z3 < 5; z3=z3+1) begin
                    if(groups5[cmp_u][i][z3] != groups5[cmp_d][j][z3])begin
                        local_count = local_count + 1;
                        t_pos = z3;    
                    end
                end    
            end
            endcase   
            if (local_count == 1)begin
                cmp_out <= t_pos;
            end
            else begin
                cmp_out <= 3'b111;
            end
            local_count = 0;
        end
        else begin
            cmp_out <= 3'b111;
        end 
        state <= state + 1;//MERGING
    end
    
    MERGING: begin
            if (cmp_u < 5) begin
                if (i < cn[ml_copy1][cmp_u]) begin
                    if (j < cn[ml_copy1][cmp_d]) begin
                        if (cmp_out < 7) begin
                            cf <= 1;
                            case(ml_copy1)
                            0: begin
                                local[0] <= groups0[cmp_u][i][0]; local[1] <= groups0[cmp_u][i][1]; local[2] <= groups0[cmp_u][i][2];
                                local[3] <= groups0[cmp_u][i][3]; local[4] <= groups0[cmp_u][i][4]; 
                                groups0[cmp_u][i][5] <= 2'b11;
                                groups0[cmp_d][j][5] <= 2'b11;
                            end
                            1: begin
                                local[0] <= groups1[cmp_u][i][0]; local[1] <= groups1[cmp_u][i][1]; local[2] <= groups1[cmp_u][i][2];
                                local[3] <= groups1[cmp_u][i][3]; local[4] <= groups1[cmp_u][i][4]; 
                                groups1[cmp_u][i][5] <= 2'b11;
                                groups1[cmp_d][j][5] <= 2'b11;
                            end
                            2: begin
                                local[0] <= groups2[cmp_u][i][0]; local[1] <= groups2[cmp_u][i][1]; local[2] <= groups2[cmp_u][i][2];
                                local[3] <= groups2[cmp_u][i][3]; local[4] <= groups2[cmp_u][i][4]; 
                                groups2[cmp_u][i][5] <= 2'b11;
                                groups2[cmp_d][j][5] <= 2'b11;
                            end
                            3: begin
                                local[0] <= groups3[cmp_u][i][0]; local[1] <= groups3[cmp_u][i][1]; local[2] <= groups3[cmp_u][i][2];
                                local[3] <= groups3[cmp_u][i][3]; local[4] <= groups3[cmp_u][i][4]; 
                                groups3[cmp_u][i][5] <= 2'b11;
                                groups3[cmp_d][j][5] <= 2'b11;
                            end
                            4: begin
                                local[0] <= groups4[cmp_u][i][0]; local[1] <= groups4[cmp_u][i][1]; local[2] <= groups4[cmp_u][i][2];
                                local[3] <= groups4[cmp_u][i][3]; local[4] <= groups4[cmp_u][i][4]; 
                                groups4[cmp_u][i][5] <= 2'b11;
                                groups4[cmp_d][j][5] <= 2'b11;
                            end
                            endcase
                            local[cmp_out] <= 2'b10;
                            local[5] <= 0;
                            state <= state + 1; //GET_COUNT_OF_1_IN_LOCAL
                        end
                        else begin
                            state <= state + 4; //ITERATTION_J
                        end
                    end 
                    else begin
                        state <= state + 5;  //ITERATTION_I  
                    end   
                end
                else begin
                    state <= state + 6;  //ITERATTION_CMP
                end
            end
            else begin
                cmp_u <= 0;
                ml <= ml + 1;
                ml_copy1 <= ml_copy1 + 1;
                ml_copy2 <= ml_copy2 + 1;
                ml_copy3 <= ml_copy3 + 1;
                if (cf == 0) begin
                    state <= state + 7;  //FIND_SIMPLE_IMPLICANT
                end
                cf <= 0;
            end    
    end
    GET_COUNT_OF_1_IN_LOCAL: begin
        _c = 0;
        for(z5 = 0; z5 < 5; z5=z5+1) begin
            if (local[z5] == 2'b01)
                _c = _c+1;
        end
        wf <= 1;
        state <= state + 1;         //SET_MERGED_VAL_IN_NEXT_COLUMN
    end
    
    SET_MERGED_VAL_IN_NEXT_COLUMN: begin
        if (p < cn[ml_copy2 + 1][_c])begin //Check if we already have this new implicant in table
            state <= state + 1;//COMPARE_IMPLICANTS
        end
        else begin //If we don't have it - write to table
            if (wf) begin
                case(ml_copy2)
                0: begin
                    groups1[_c][cn[1][_c]][0] <= local[0]; groups1[_c][cn[1][_c]][1] <= local[1]; groups1[_c][cn[1][_c]][2] <= local[2];
                    groups1[_c][cn[1][_c]][3] <= local[3]; groups1[_c][cn[1][_c]][4] <= local[4]; groups1[_c][cn[1][_c]][5] = local[5];
                end
                1: begin
                    groups2[_c][cn[2][_c]][0] <= local[0]; groups2[_c][cn[2][_c]][1] <= local[1]; groups2[_c][cn[2][_c]][2] <= local[2];
                    groups2[_c][cn[2][_c]][3] <= local[3]; groups2[_c][cn[2][_c]][4] <= local[4]; groups2[_c][cn[2][_c]][5] = local[5];
                end
                2: begin
                    groups3[_c][cn[3][_c]][0] <= local[0]; groups3[_c][cn[3][_c]][1] <= local[1]; groups3[_c][cn[3][_c]][2] <= local[2];
                    groups3[_c][cn[3][_c]][3] <= local[3]; groups3[_c][cn[3][_c]][4] <= local[4]; groups3[_c][cn[3][_c]][5] = local[5];
                end
                3: begin
                    groups4[_c][cn[4][_c]][0] <= local[0]; groups4[_c][cn[4][_c]][1] <= local[1]; groups4[_c][cn[4][_c]][2] <= local[2];
                    groups4[_c][cn[4][_c]][3] <= local[3]; groups4[_c][cn[4][_c]][4] <= local[4]; groups4[_c][cn[4][_c]][5] = local[5];
                end
                4: begin
                    groups5[_c][cn[5][_c]][0] <= local[0]; groups5[_c][cn[5][_c]][1] <= local[1]; groups5[_c][cn[5][_c]][2] <= local[2];
                    groups5[_c][cn[5][_c]][3] <= local[3]; groups5[_c][cn[5][_c]][4] <= local[4]; groups5[_c][cn[5][_c]][5] = local[5];
                end
                endcase
                cn[ml_copy2+1][_c] <= cn[ml_copy2+1][_c] + 1;
            end
            state <= state + 2;//ITERATTION_J
            p <= 0; 
        end                 
    end   
    COMPARE_IMPLICANTS: begin
        st7_count = 0;
        case(ml_copy3)
        0: begin
            for (z7 = 0; z7 < 5; z7=z7+1)begin
                if(local[z7] == groups1[_c][p][z7]) begin
                    st7_count = st7_count + 1;
                end    
            end
        end
        1: begin
            for (z7 = 0; z7 < 5; z7=z7+1)begin
                if(local[z7] == groups2[_c][p][z7]) begin
                    st7_count = st7_count + 1;
                end    
            end
        end
        2: begin
            for (z7 = 0; z7 < 5; z7=z7+1)begin
                if(local[z7] == groups3[_c][p][z7]) begin
                    st7_count = st7_count + 1;
                end    
            end
        end
        3: begin
            for (z7 = 0; z7 < 5; z7=z7+1)begin
                if(local[z7] == groups4[_c][p][z7]) begin
                    st7_count = st7_count + 1;
                end    
            end
        end
        4: begin
            for (z7 = 0; z7 < 5; z7=z7+1)begin
                if(local[z7] == groups5[_c][p][z7]) begin
                    st7_count = st7_count + 1;
                end    
            end
        end
        endcase
        if (st7_count == 5) begin
            wf <= 0;
        end
        state <= state - 1;//SET_MERGED_VAL_IN_NEXT_COLUMN
        p <= p + 1;
    end
    ITERATTION_J: begin
        j <= j + 1;
        state <= state - 5;//COMPARE_FOR_MERGING
    end
    ITERATTION_I: begin
        j <= 0;
        i <= i + 1;
        state <= state - 6;//COMPARE_FOR_MERGING
    end
    ITERATTION_CMP: begin
        j <= 0;
        i <= 0;
        cmp_u <= cmp_u + 1;
        state <= state - 7;//COMPARE_FOR_MERGING
    end
    FIND_SIMPLE_IMPLICANTS: begin
        if (i11 <= capacity) begin
            if (j11 <= capacity) begin
                if(z11 < cn[i11][j11]) begin
                    case(i11)
                    0: begin
                        if (groups0[j11][z11][5] == 0) begin
                            pi[cpi][0] <= groups0[j11][z11][0]; pi[cpi][1] <= groups0[j11][z11][1]; pi[cpi][2] <= groups0[j11][z11][2];
                            pi[cpi][3] <= groups0[j11][z11][3]; pi[cpi][4] <= groups0[j11][z11][4]; pi[cpi][5] <= groups0[j11][z11][5];
                            cpi <= cpi + 1;
                        end
                    end
                    1: begin
                        if (groups1[j11][z11][5] == 0) begin
                            pi[cpi][0] <= groups1[j11][z11][0]; pi[cpi][1] <= groups1[j11][z11][1]; pi[cpi][2] <= groups1[j11][z11][2];
                            pi[cpi][3] <= groups1[j11][z11][3]; pi[cpi][4] <= groups1[j11][z11][4]; pi[cpi][5] <= groups1[j11][z11][5];
                            cpi <= cpi + 1;
                        end
                    end
                    2: begin
                        if (groups2[j11][z11][5] == 0) begin
                            pi[cpi][0] <= groups2[j11][z11][0]; pi[cpi][1] <= groups2[j11][z11][1]; pi[cpi][2] <= groups2[j11][z11][2];
                            pi[cpi][3] <= groups2[j11][z11][3]; pi[cpi][4] <= groups2[j11][z11][4]; pi[cpi][5] <= groups2[j11][z11][5];
                            cpi <= cpi + 1;
                        end
                    end
                    3: begin
                        if (groups3[j11][z11][5] == 0) begin
                            pi[cpi][0] <= groups3[j11][z11][0]; pi[cpi][1] <= groups3[j11][z11][1]; pi[cpi][2] <= groups3[j11][z11][2];
                            pi[cpi][3] <= groups3[j11][z11][3]; pi[cpi][4] <= groups3[j11][z11][4]; pi[cpi][5] <= groups3[j11][z11][5];
                            cpi <= cpi + 1;
                        end
                    end
                    4: begin
                        if (groups4[j11][z11][5] == 0) begin
                            pi[cpi][0] <= groups4[j11][z11][0]; pi[cpi][1] <= groups4[j11][z11][1]; pi[cpi][2] <= groups4[j11][z11][2];
                            pi[cpi][3] <= groups4[j11][z11][3]; pi[cpi][4] <= groups4[j11][z11][4]; pi[cpi][5] <= groups4[j11][z11][5];
                            cpi <= cpi + 1;
                        end
                    end
                    5: begin
                        if (groups5[j11][z11][5] == 0) begin
                            pi[cpi][0] <= groups5[j11][z11][0]; pi[cpi][1] <= groups5[j11][z11][1]; pi[cpi][2] <= groups5[j11][z11][2];
                            pi[cpi][3] <= groups5[j11][z11][3]; pi[cpi][4] <= groups5[j11][z11][4]; pi[cpi][5] <= groups5[j11][z11][5];
                            cpi <= cpi + 1;
                        end
                    end    
                    endcase
                    z11 <= z11 + 1;
                end    
                else begin
                    z11 <= 0;
                    j11 <= j11 + 1;
                end    
            end
            else begin
                i11 <= i11 + 1;
                j11 <= 0;
            end
        end
        else begin
            state <= state + 1;//FILL_1_POINTS
            i11 <= 0;
        end    
    end
    FILL_1_POINTS: begin
        if (z12 < ci12) begin
            p1[cp1][0] <= implicants[z12][0];
            p1[cp1][1] <= implicants[z12][1];
            p1[cp1][2] <= implicants[z12][2];
            p1[cp1][3] <= implicants[z12][3];
            p1[cp1][4] <= implicants[z12][4];
            p1[cp1][5] <= 2'b00;
            cp1 <= cp1+1;
            z12 <= z12 + 1; 
        end              
        else begin
            state <= state + 1;  //COMPARE_FOR_Q_TABLE
        end      
    end
    COMPARE_FOR_Q_TABLE: begin
        if (i14 < cp1) begin
            if (j14 < cpi) begin
                for(z14 = 0; z14 < 5; z14 = z14 + 1) begin
                    if(!((p1[i14][z14] == pi[j14][z14]) || (pi[j14][z14] == 2))) begin
                        cmp_flag14 <= 0;    
                    end
                end
                state <= state + 1; //FILL_QUINE_TABLE; 
            end
            else begin
                j14 <= 0;
                i14 <= i14 + 1; 
            end
        end 
        else begin
            i14 <= 0;
            state <= state + 2;//CORE_IMPLICANT_CHECK
        end       
    end
    FILL_QUINE_TABLE: begin
        if (cmp_flag14) begin
            quine_table[i14][j14] <= 1'b1;
        end
        else begin 
            quine_table[i14][j14] <= 1'b0;
        end
        state <= state - 1; //COMPARE_FOR_Q_TABLE
        cmp_flag14 <= 1; 
        j14 <= j14 + 1; 
    end
    CORE_IMPLICANT_CHECK: begin
        if (i16 <  cp1) begin
            if (z16 < cpi) begin
                if (quine_table[i16][z16] == 1) begin
                    c16 = c16 + 1;
                    pos <= z16;
                end
                z16 <= z16 + 1;
            end    
            else begin
                z16 <= 0;
                if (c16 != 1)
                    pos <= 5'b11111;
                state <= state + 1;   //FIND_CORE_IMPLICANTS
            end
        end 
        else begin
            i16 <= 0;
            state <= state + 2; //INDICATE_COVERED_LINES
        end 
    end
    FIND_CORE_IMPLICANTS: begin
        if (pos != 5'b11111) begin
            pi[pos][5] <= 3;
        end
        i16 <= i16 + 1;
        c16 = 0;
        state <= state - 1;  //CORE_IMPLICANT_CHECK
    end
    INDICATE_COVERED_LINES: begin
        if(i17 < cpi) begin
            if (pi[i17][5] == 3) begin
                if (z17 < cp1) begin
                    if(quine_table[z17][i17] == 1) begin
                        p1[z17][5] <= 3;
                    end
                    z17 <= z17 + 1;
                end
                else begin
                    z17 <= 0;
                    i17 <= i17 + 1;
                end
            end
            else begin
                i17 <= i17 + 1;
            end
        end
        else begin
            i17 <= 0;
            state <= state + 1; //CREATE_PETRICK_TABLE
        end
    end
    CREATE_PETRICK_TABLE: begin
        if (z18 < cp1) begin
            if(p1[z18][5] == 0) begin
                if (l18 < cpi) begin
                    petrick_table0[c1pt[0]][l18] <= quine_table[z18][l18];
                    l18 <= l18 + 1;
                end
                else begin
                    z18 <= z18 + 1;
                    l18 <= 0;
                    c1pt[0] <= c1pt[0] + 1;
                end
            end
            else 
                z18 <= z18 + 1;
        end        
        else begin    
            state <= state + 1;
        end
    end
    PETRICK_METHODS_CALCULATIONS: begin
        if(c1pt[0] > 0) begin
           if (i19 < cpi) begin
                if (z19 < c1pt[pl]) begin
                    case (pl)
                    0: begin
                        if(petrick_table0[z19][i19] == 1)begin
                            c1c <= c1c + 1;
                        end
                    end
                    1: begin
                        if(petrick_table1[z19][i19] == 1)begin
                            c1c <= c1c + 1;
                        end
                    end
                    2: begin
                        if(petrick_table2[z19][i19] == 1)begin
                            c1c <= c1c + 1;
                        end
                    end
                    3: begin
                        if(petrick_table3[z19][i19] == 1)begin
                            c1c <= c1c + 1;
                        end
                    end
                    4: begin
                        if(petrick_table4[z19][i19] == 1)begin
                            c1c <= c1c + 1;
                        end
                    end
                    5: begin
                        if(petrick_table5[z19][i19] == 1)begin
                            c1c <= c1c + 1;
                        end
                    end
                    6: begin
                        if(petrick_table6[z19][i19] == 1)begin
                            c1c <= c1c + 1;
                        end
                    end
                    7: begin
                        if(petrick_table7[z19][i19] == 1)begin
                            c1c <= c1c + 1;
                        end
                    end
                    8: begin
                        if(petrick_table8[z19][i19] == 1)begin
                            c1c <= c1c + 1;
                        end
                    end
                    endcase
                    z19 <= z19 + 1;
                end
                else begin
                    z19 <= 0;
                    if (c1c > max_c1c) begin
                        max_c1c <= c1c;
                        pei <= i19;
                    end
                    c1c <= 0;
                    i19 <= i19 + 1;
                end
           end
           else begin
                pi[pei][5] <= 3;
                if (l19 < c1pt[pl]) begin
                    case (pl)
                    0: begin
                        if(petrick_table0[l19][pei] != 1) begin
                            if (t19 < cpi) begin
                                petrick_table1[c1pt[1]][t19] <= petrick_table0[l19][t19];
                                t19 <= t19 + 1;
                            end
                            else begin
                                l19 <= l19 + 1;
                                t19 <= 0;
                                c1pt[1] <= c1pt[1] + 1; 
                            end
                        end
                        else
                            l19 <= l19 + 1;
                    end
                    1: begin
                        if(petrick_table1[l19][pei] != 1) begin
                            if (t19 < cpi) begin
                                petrick_table2[c1pt[2]][t19] <= petrick_table1[l19][t19];
                                t19 <= t19 + 1;
                            end
                            else begin
                                l19 <= l19 + 1;
                                t19 <= 0;
                                c1pt[2] <= c1pt[2] + 1; 
                            end
                        end
                        else
                            l19 <= l19 + 1;
                    end
                    2: begin
                        if(petrick_table2[l19][pei] != 1) begin
                            if (t19 < cpi) begin
                                petrick_table3[c1pt[3]][t19] <= petrick_table2[l19][t19];
                                t19 <= t19 + 1;
                            end
                            else begin
                                l19 <= l19 + 1;
                                t19 <= 0;
                                c1pt[3] <= c1pt[3] + 1; 
                            end
                        end
                        else
                            l19 <= l19 + 1;
                    end
                    3: begin
                        if(petrick_table3[l19][pei] != 1) begin
                            if (t19 < cpi) begin
                                petrick_table4[c1pt[4]][t19] <= petrick_table3[l19][t19];
                                t19 <= t19 + 1;
                            end
                            else begin
                                l19 <= l19 + 1;
                                t19 <= 0;
                                c1pt[4] <= c1pt[4] + 1; 
                            end
                        end
                        else
                            l19 <= l19 + 1;
                    end
                    4: begin
                        if(petrick_table4[l19][pei] != 1) begin
                            if (t19 < cpi) begin
                                petrick_table5[c1pt[5]][t19] <= petrick_table4[l19][t19];
                                t19 <= t19 + 1;
                            end
                            else begin
                                l19 <= l19 + 1;
                                t19 <= 0;
                                c1pt[5] <= c1pt[5] + 1; 
                            end
                        end
                        else
                            l19 <= l19 + 1;
                    end
                    5: begin
                        if(petrick_table5[l19][pei] != 1) begin
                            if (t19 < cpi) begin
                                petrick_table6[c1pt[6]][t19] <= petrick_table5[l19][t19];
                                t19 <= t19 + 1;
                            end
                            else begin
                                l19 <= l19 + 1;
                                t19 <= 0;
                                c1pt[6] <= c1pt[6] + 1; 
                            end
                        end
                        else
                            l19 <= l19 + 1;
                    end
                    6: begin
                        if(petrick_table6[l19][pei] != 1) begin
                            if (t19 < cpi) begin
                                petrick_table7[c1pt[7]][t19] <= petrick_table6[l19][t19];
                                t19 <= t19 + 1;
                            end
                            else begin
                                l19 <= l19 + 1;
                                t19 <= 0;
                                c1pt[7] <= c1pt[7] + 1; 
                            end
                        end
                        else
                            l19 <= l19 + 1;
                    end
                    7: begin
                        if(petrick_table7[l19][pei] != 1) begin
                            if (t19 < cpi) begin
                                petrick_table8[c1pt[8]][t19] <= petrick_table7[l19][t19];
                                t19 <= t19 + 1;
                            end
                            else begin
                                l19 <= l19 + 1;
                                t19 <= 0;
                                c1pt[8] <= c1pt[8] + 1; 
                            end
                        end
                        else
                            l19 <= l19 + 1;
                    end
                    8: begin
                        l19 <= l19 + 1;
                    end
                    endcase
                end
                else begin
                    l19 <= 0;
                    if (c1pt[pl + 1] == 0)begin
                        state <= state + 1;
                    end
                    pl <= pl + 1;
                    max_c1c <= 0;
                    i19 <= 0;
                end
           end     
        end
        else begin
            state <= state + 1;
        end
    end
    WRITE_RESULT: begin
        if (z20 < cpi) begin
            if(pi[z20][5] == 3) begin
                result_reg[res_count][0] <= pi[z20][0]; result_reg[res_count][1] <= pi[z20][1];
                result_reg[res_count][2] <= pi[z20][2]; result_reg[res_count][3] <= pi[z20][3];
                result_reg[res_count][4] <= pi[z20][4];
                res_count <= res_count + 1;  
            end
            z20 <= z20 + 1;  
        end
        else
            state <= state + 1;
    end
    READY_RESULT_FLAG: begin
        ready_result <= 1;
        state <= state + 1;
    end
    SEND_RESULT: begin
        ready_result <= 0;
        if(i22 < res_count) begin
            result[9:8] <= result_reg[i22][0]; result[7:6] <= result_reg[i22][1];
            result[5:4] <= result_reg[i22][2]; result[3:2] <= result_reg[i22][3];
            result[1:0] <= result_reg[i22][4];
            i22 <= i22 + 1;        
        end 
        else begin
            result_end <= 1;
            state <= RESET;
        end       
    end
    RESET: begin
        result_end <= 0;
        ready_result <= 0;
        result <= 0;
        res_count <= 0;
        ci <= 5'b00000;
        i <= 0; j <= 0;
        for(k = 0; k < 6; k=k+1)begin
            for(x = 0; x < 6; x=x+1)begin
                cn[k][x] = 5'b00000;    
            end 
        end
        cf <= 0;
        ml <= 0;
        ml_copy1 <= 0;
        ml_copy2 <= 0;
        ml_copy3 <= 0;
        cmp_u <= 0;
        p <= 0;
        local_count = 0;
        cpi <= 0;
        i11 <= 0;
        j11 <= 0;
        cp1 <= 0;
        i14 <= 0;
        j14 <= 0;
        cmp_flag14 <= 1;
        i16 <= 0; z16 <= 0; pos <= 0; c16 = 0;
        i17 <= 0;
        pl <= 0;
        for (t = 0; t < 29; t = t + 1) begin
            c1pt[t] <= 6'b000000;
        end
        pei <= 0; c1c <= 0; max_c1c <= 0; i19 <= 0;
        i22 <= 0;
        state <= 0;
        k = 0; t = 0; z2 = 0; z1 = 0; z3 = 0; l2 <= 0; z5 = 0; z7 = 0; z11 <= 0; z12 <= 0; z14 = 0;
        cmp_out <= 0;
        local[0] <= 0; local[1] <= 0; local[2] <= 0;
        local[3] <= 0; local[4] <= 0; local[5] <= 0;
        t_pos = 0;
        _c = 0;
        z17 = 0; z18 <= 0; l18 <= 0; z19 <= 0; l19 <= 0; t19 <= 0; z20 <= 0;      
    end
    endcase 
end
    
endmodule
