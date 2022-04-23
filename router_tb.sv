`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module dg_R1 (interface S);
	parameter WIDTH = 33;
	parameter FL = 0;
	logic [WIDTH-1 : 0] packet0 = 0;
	//logic [WIDTH-1 : 0] packet1 = 0;
	//logic [WIDTH-1 : 0] packet2 = 0;
	//logic [WIDTH-1 : 0] packet3 = 0;
	initial
	begin
	   $display("Start module data_generator and time is %d", $time);
		packet0 = { 1'b1, 4'b0010, 4'b1101, 24'b000000000000000101010101 };
		#FL;
		$display("data_generator_packet = %b\n",packet0);
		S.Send(packet0);
		#20;
	end
endmodule


module dg_R2 (interface S);
	parameter WIDTH = 33;
	parameter FL = 0;
	logic [WIDTH-1 : 0] packet0 = 0;
	initial
	begin
	   $display("Start module data_generator and time is %d", $time);
		packet0 = { 1'b1, 4'b0110, 4'b1101, 24'b000000000000000101010101 };
		#FL;
		$display("data_generator_packet = %b\n",packet0);
		#10;
		S.Send(packet0);
		#20;
	end
endmodule

module db_R (interface R);
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

module router_tb;
    
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(33)) intf  [19:0] (); 
    
    router  #(.address_X(01), .address_Y(01)) R1(.in_right(intf[0]), .in_down(intf[1]), .out_up(intf[2]), .in_left(intf[3]), .in_up(intf[4]), .in_pe(intf[5]), .out_left(intf[6]), .out_right(intf[7]), .out_down(intf[8]), .out_pe(intf[9]) );
    dg_R1 dg1(.S(intf[0]));
    dg_R2 dg2(.S(intf[1]));
    db_R db(.R(intf[2]));

   // router (interface in_left,interface in_right,interface in_up,interface in_down,interface in_pe,interface out_left,interface out_right,interface out_up,interface out_down,interface out_pe );
initial 
    #100 $stop;


endmodule
