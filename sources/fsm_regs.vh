reg [1:0] implicants [0:31][0:5]; //импликанты, заданные вектором
reg [5:0] ci; //count of implicants
reg [5:0] ci12;

reg [1:0] groups0 [0:5][0:9][0:5];
reg [1:0] groups1 [0:4][0:29][0:5];
reg [1:0] groups2 [0:3][0:29][0:5];
reg [1:0] groups3 [0:2][0:19][0:5];
reg [1:0] groups4 [0:1][0:4][0:5];
reg [1:0] groups5 [0:1][0:1][0:5];
//
reg [4:0] cn [0:5][0:5];
reg [2:0] cntr2;
//reg [7:0]   z30, k30, t30;
reg [4:0] i, j, z1;
reg [4:0] t, p,  z11;
reg [5:0] l2, z12;
reg [2:0] z5, x, k, z14, z7, z3, z2;

reg cf, //comparing flag used to show that it was comparing on this comparing level
    wf; //write flag
reg [2:0] cmp_out; //result of compare two numbers
reg [2:0] cmp_u; //compare up
reg [2:0] ml; //merging level
reg [2:0] ml_copy1; //merging level
reg [2:0] ml_copy2; //merging level
reg [2:0] ml_copy3; //merging level
reg [1:0] local [0:5]; //new number got by merging
reg [2:0] local_count, t_pos;
wire [2:0] cmp_d; //compare down
assign cmp_d = cmp_u + 1;

reg [2:0] st7_count; 
//STATE : SET_MERGED_VAL_IN_NEXT_COLUMN
reg [2:0] _c;

//STATE : FIND_SIMPLE_IMPLICANTS
reg quine_table [0:25][0:25]; //Quine table
reg [1:0] pi [0:31][0:5]; //prime implicants
reg [4:0] cpi; //count of prime implicants
reg [2:0] i11;
reg [2:0] j11;

//STATE : FILL_1_POINTS
reg [1:0] p1 [0:31][0:5];
reg [5:0] cp1;

//STATE : FILL_QUINE_TABLE
reg [5:0] i14, j14;
reg cmp_flag14;

//STATE: FIND_CORE_IMPLICANTS
reg [5:0] i16, z16;
reg [4:0] pos;
reg [5:0] c16;

//STATE: INDICATE_COVERED_LINES
reg [5:0] i17, z17;

//STATE: CREATE_PETRICK_TABLE
reg [4:0] c1pt [0:32];
//
reg petrick_table0 [0:20][0:20];
reg petrick_table1 [0:16][0:20];
reg petrick_table2 [0:12][0:20];
reg petrick_table3 [0:10][0:20];
reg petrick_table4 [0:8][0:20];
reg petrick_table5 [0:6][0:20];
reg petrick_table6 [0:4][0:20];
reg petrick_table7 [0:2][0:20];
reg petrick_table8 [0:1][0:20];
//
reg [4:0] pl; //petrick table level
reg [5:0] z18, l18;
//STATE: PETRICK_METHODS_CALCULATIONS
reg [4:0] l19, t19;
reg [4:0] i19, z19;
reg [4:0] pei;//position of extra implicant
reg [5:0] c1c;//count of 1 in column
reg [5:0] max_c1c;
//STATE: WRITE RESULT
reg [1:0] result_reg [0:15][0:4];
reg [4:0] z20;
//STATE: SEND_RESULT
reg [5:0] i22;