`timescale 1ns / 1ps

module NoC(Channel PE0_in, Channel PE1_in, Channel PE2_in, Channel PE3_in, Channel PE4_in,Channel PE5_in, Channel PE6_in, Channel PE7_in, Channel PE8_in,
           Channel R1_in, Channel R2_in, Channel R3_in, Channel R4_in, Channel R5_in,Channel R6_in, Channel R7_in, Channel R8_in, Channel R9_in, Channel R10_in, Channel R11_in, Channel R12_in,
           Channel PE0_out, Channel PE1_out, Channel PE2_out, Channel PE3_out, Channel PE4_out,Channel PE5_out, Channel PE6_out, Channel PE7_out, Channel PE8_out,
           Channel R1_out, Channel R2_out, Channel R3_out, Channel R4_out, Channel R5_out,Channel R6_out, Channel R7_out, Channel R8_out, Channel R9_out, Channel R10_out, Channel R11_out, Channel R12_out,
           Channel wrapper_in, Channel wrapper_out, Channel memory_in, Channel memory_out); 
   
   parameter FL = 2;
   parameter BL = 1;
   parameter WIDTH = 33;
   
   Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) CH[26:0] ();
   
   //Router(N_in, E_in, S_in, W_in, PE_in, N_out, E_out, S_out, W_out, PE_out)
   
   //1st row, left router [0000]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(0), .address_1(0), .address_2(0), .address_3(0)) PE0_router(.N_in(R5_in), .E_in(R1_in), .S_in(CH[0]), .W_in(CH[1]), .PE_in(PE0_in), .N_out(R5_out), .E_out(R1_out), .S_out(CH[2]), .W_out(CH[3]), .PE_out(PE0_out));                                                                                                                       
   //1st row, middle router [0100]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(0), .address_1(0), .address_2(1), .address_3(0)) PE1_router(.N_in(R4_in), .E_in(R2_in), .S_in(CH[4]), .W_in(R1_in), .PE_in(PE1_in), .N_out(R4_out), .E_out(R2_out), .S_out(CH[5]), .W_out(R1_out), .PE_out(PE1_out));
   //1st row, right router [1000]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(0), .address_1(0), .address_2(0), .address_3(1)) PE2_router(.N_in(R3_in), .E_in(CH[6]), .S_in(CH[7]), .W_in(R2_in), .PE_in(PE2_in), .N_out(R3_out), .E_out(CH[8]), .S_out(CH[9]), .W_out(R2_out), .PE_out(PE2_out));
   
   //2nd row, left router [0001]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(1), .address_1(0), .address_2(0), .address_3(0)) PE3_router(.N_in(R10_in), .E_in(R6_in), .S_in(R5_in), .W_in(CH[10]), .PE_in(PE3_in), .N_out(R10_out), .E_out(R6_out), .S_out(R5_out), .W_out(CH[11]), .PE_out(PE3_out));                                                                                                                                                                                                                                                                                                                                                                                    
   //2nd row, middle router [0101]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(0), .address_1(1), .address_2(0), .address_3(1)) PE4_router(.N_in(R9_in), .E_in(R7_in), .S_in(R4_in), .W_in(R6_in), .PE_in(PE4_in), .N_out(R9_out), .E_out(R7_out), .S_out(R4_out), .W_out(R6_out), .PE_out(PE4_out));
   //2nd row, right router [1001]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(1), .address_1(0), .address_2(0), .address_3(1)) PE5_router(.N_in(R8_in), .E_in(wrapper_in), .S_in(R3_in), .W_in(R7_in), .PE_in(PE5_in), .N_out(R8_out), .E_out(wrapper_out), .S_out(R3_out), .W_out(R7_out), .PE_out(PE5_out));
   
   //3rd row, left router [0010]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(0), .address_1(1), .address_2(0), .address_3(0)) PE6_router(.N_in(CH[12]), .E_in(R11_in), .S_in(R10_in), .W_in(CH[13]), .PE_in(PE6_in), .N_out(CH[14]), .E_out(R11_out), .S_out(R10_out), .W_out(CH[15]), .PE_out(PE6_out));                                                                                                                                                                                                                                  
   //3rd row, middle router [0110]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(0), .address_1(1), .address_2(1), .address_3(0)) PE7_router(.N_in(CH[16]), .E_in(R12_in), .S_in(R9_in), .W_in(R11_in), .PE_in(PE7_in), .N_out(CH[17]), .E_out(R12_out), .S_out(R9_out), .W_out(R11_out), .PE_out(PE7_out));
   //3rd row, right router [1010]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(0), .address_1(1), .address_2(0), .address_3(1)) PE8_router(.N_in(CH[18]), .E_in(CH[19]), .S_in(R8_in), .W_in(R12_in), .PE_in(PE8_in), .N_out(CH[20]), .E_out(CH[21]), .S_out(R8_out), .W_out(R12_out), .PE_out(PE8_out));
   
   //Memory Wrapper [1101]
   router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address_0(1), .address_1(0), .address_2(1), .address_3(1)) wrap_router(.N_in(CH[22]), .E_in(memory_in), .S_in(CH[23]), .W_in(wrapper_in), .PE_in(CH[24]), .N_out(CH[25]), .E_out(memory_out), .S_out(CH[26]), .W_out(wrapper_out), .PE_out(CH[27]));                                                                                                                 
endmodule
