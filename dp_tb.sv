`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module data_generator (interface S);
	parameter WIDTH = 33;
	parameter FL = 0;
	logic [WIDTH-1 : 0] packet = 0;
	always
	begin
	   $display("Start module data_generator and time is %d", $time);
		packet = {1'b1, 4'b1101, 4'b0011, 24'b101010101010101010101010};
		#FL;
		$display("data_generator_packet = %b\n",packet);
		$display("Starting data_generator %m.Send @ %d", $time);
		S.Send(packet);
		$display("Finished data_generator %m.Send @ %d", $time);
	end
endmodule

module data_bucket (interface R);
	parameter WIDTH = 24;
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

module dp_tb;
    Channel #(.hsProtocol(P4PhaseBD)) intf  [7:0] (); 
    data_generator dg(.S(intf[0]));
    DPkt_PE DP(.packet_in(intf[0]), .to_filter(intf[1]), .to_ifmap(intf[2]));
    data_bucket DB1(.R(intf[1]));
    data_bucket DB2(.R(intf[1]));

initial 
    #50 $stop;

endmodule
