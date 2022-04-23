`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module dg_PE (interface S);
	parameter WIDTH = 33;
	parameter FL = 0;
	logic [WIDTH-1 : 0] packet0 = 0;
	logic [WIDTH-1 : 0] packet1 = 0;
	logic [WIDTH-1 : 0] packet2 = 0;
	logic [WIDTH-1 : 0] packet3 = 0;
	initial
	begin
	   $display("Start module data_generator and time is %d", $time);
		packet0 = { 1'b1, 4'b0010, 4'b1101, 24'b000000000000000101010101 };
		packet1 = { 1'b0, 4'b0010, 4'b1101, 24'b000000110000001000000001 };
		packet2 = { 1'b0, 4'b0010, 4'b1101, 24'b000001100000010100000100 };
		packet3 = { 1'b0, 4'b0010, 4'b1101, 24'b000010010000100000000111 };
		#FL;
		$display("data_generator_packet = %b\n",packet0);
		$display("data_generator_packet = %b\n",packet1);
		$display("data_generator_packet = %b\n",packet2);
		$display("data_generator_packet = %b\n",packet3);
		S.Send(packet0);
		#20;
		S.Send(packet1);
		#20;
		S.Send(packet2);
		#20;
		S.Send(packet3);
		#30
		S.Send(packet0);
		#20;
		S.Send(packet1);
		#20;
		S.Send(packet2);
		#20;
		S.Send(packet3);
	end
endmodule

module db_PE (interface R);
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

module PE_TB;
    Channel #(.hsProtocol(P4PhaseBD)) intf  [7:0] (); 
    dg_PE dg(.S(intf[0]));
    PE  #(.PE_add_X(2'b00), .PE_add_Y(2'b10)) PE(.packet_in(intf[0]), .packet_out(intf[1]));
    db_PE DB1(.R(intf[1]));
//module PE(interface packet_in, packet_out);

    initial 
    #300 $stop;
endmodule
