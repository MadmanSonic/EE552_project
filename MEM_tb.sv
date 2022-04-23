`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module data_bucket (interface in, out);
	parameter WIDTH = 33;
	parameter BL = 0;
	logic [WIDTH-1 : 0] ReceiveValue;
	always
	begin
		in.Receive(ReceiveValue);
		#BL;
		$display("ReceiveValue = %b\n", ReceiveValue);
	end
endmodule


module MEM_tb;
        Channel #(.hsProtocol(P4PhaseBD), .WIDTH(33)) intf  [12:0] ();
        
        Mem_block Mem(.packet_in(intf[0]), .packet_out(intf[1]));
        data_bucket db(.in(intf[1]), .out(intf[0]));

        //Mem_block(interface packet_in, packet_out);
        
        initial 
        #3000 $stop;

endmodule
