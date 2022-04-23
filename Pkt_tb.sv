`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module dg_pkt (interface S);
	parameter WIDTH = 24;
	parameter FL = 0;
	logic [WIDTH-1 : 0] packet = 0;
	always
	begin
	   $display("Start module data_generator and time is %d", $time);
		packet = { 24'b000000000000000000000001};
		#FL;
		$display("data_generator_packet = %b\n",packet);
		$display("Starting data_generator %m.Send @ %d", $time);
		S.Send(packet);
		$display("Finished data_generator %m.Send @ %d", $time);
	end
endmodule

module db_pkt (interface R);
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

module Pkt_tb;
    Channel #(.hsProtocol(P4PhaseBD)) intf  [7:0] (); 
    dg_pkt dg(.S(intf[0]));
    Pkt_PE PKT(.packet_out(intf[1]), .data_in(intf[0]));
    db_pkt DB1(.R(intf[1]));
   // module Pkt_PE (interface packet_out, data_in);
    initial 
    #50 $stop;
endmodule
