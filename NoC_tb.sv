`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module dg_NoC1 (interface S);
	parameter WIDTH = 33;
	parameter FL = 0;
	logic [WIDTH-1 : 0] packet0 = 0;
	//logic [WIDTH-1 : 0] packet1 = 0;
	//logic [WIDTH-1 : 0] packet2 = 0;
	//logic [WIDTH-1 : 0] packet3 = 0;
	initial
	begin
	   $display("Start module data_generator and time is %d", $time);
		packet0 = { 1'b1, 4'b1010, 4'b1101, 24'b000000000000000101010101 };
		#FL;
		$display("data_generator_packet = %b\n",packet0);
		S.Send(packet0);
		#20;
	end
endmodule


module dg_NoC2 (interface S);
	parameter WIDTH = 33;
	parameter FL = 0;
	logic [WIDTH-1 : 0] packet0 = 0;
	initial
	begin
	   $display("Start module data_generator and time is %d", $time);
		packet0 = { 1'b1, 4'b1010, 4'b1101, 24'b000000000000000101010101 };
		#FL;
		$display("data_generator_packet = %b\n",packet0);
		#10;
		S.Send(packet0);
		#20;
	end
endmodule

module db_NoC (interface R);
	parameter WIDTH = 33;
	parameter BL = 0;
	logic [WIDTH-1 : 0] ReceiveValue = 0;
	always
	begin
		R.Receive(ReceiveValue);
		$display("Finished data_bucket %m.Receive @ %d", $time);
		#BL;
		$display("ReceiveValue = %b\n", ReceiveValue);
		
	end
endmodule

module NoC_tb;
    
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(33)) intf  [19:0] (); 
    
    NoC   NoC(.PE_0010_i(intf[2]), .PE_0110_i(intf[3]), .PE_1010_i(intf[4]), .PE_0001_i(intf[5]), .PE_0101_i(intf[6]), .PE_1001_i(intf[7]), .PE_0000_i(intf[8]), .PE_0100_i(intf[9]), .PE_1000_i(intf[0]), .memblock_i(intf[10]), .PE_0010_o(intf[1]), .PE_0110_o(intf[11]), .PE_1010_o(intf[12]), .PE_0001_o(intf[13]), .PE_0101_o(intf[14]), .PE_1001_o(intf[15]), .PE_0000_o(intf[16]), .PE_0100_o(intf[17]), .PE_1000_o(intf[18]), .memblock_o(intf[19]));
    dg_NoC1 dg_NoC1(.S(intf[5]));
    dg_NoC2 dg_NoC2(.S(intf[8]));
    db_NoC db_NoC1(.R(intf[12]));

   // NoC (interface PE_0010_i, PE_0110_i, PE_1010_i, PE_0001_i, PE_0101_i, PE_1001_i, PE_0000_i, PE_0100_i, PE_1000_i, memblock_i, PE_0010_o, PE_0110_o, PE_1010_o, PE_0001_o, PE_0101_o, PE_1001_o, PE_0000_o, PE_0100_o, PE_1000_o, memblock_o);
    initial
    #500 $stop;


endmodule