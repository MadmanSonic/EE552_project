`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module router_tb();

    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 1;
    parameter address = 3'b010;
    logic [3:0] destination_addr = 0;
    logic [WIDTH-1: 0] packet = 33'b100100101110100101110010110111000;
    
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) N_in();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) E_in();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) S_in();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) W_in();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE_in();
    
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) N_out();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) E_out();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) S_out();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) W_out();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE_out();
     
    //router(N_in, E_in, S_in, W_in, PE_in, N_out, E_out, S_out, W_out, PE_out)
    router #(.WIDTH(WIDTH), .FL(FL), .BL(BL), .address(address)) rt(.N_in(N_in), .E_in(E_in), .S_in(S_in),.W_in(W_in),.PE_in(PE_in),.N_out(N_out), .E_out(E_out), .S_out(S_out),.W_out(W_out),.PE_out(PE_out));
    
    integer k;
    
    initial
    begin
         
         //Testing North -> Others
         $display("Input from North to other direction");
         $display("from North to East/n/n");
         destination_addr = 4'b1001;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            N_in.Send(packet);
            E_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
        $display("from North to South");
         destination_addr = 4'b0100;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            N_in.Send(packet);
            W_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
        
        $display("from North to West");
         destination_addr = 4'b0001;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            N_in.Send(packet);
            S_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
                        
       $display("from North to PE");
         destination_addr = 4'b0101;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            N_in.Send(packet);
            PE_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
         //Testing East -> Others   
         $display("Testing Input from East to other direction");
         $display("from East to South");
         destination_addr = 4'b0100;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            E_in.Send(packet);
            S_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
        $display("from East to West");
         destination_addr = 4'b0001;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            E_in.Send(packet);
            W_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
        
        $display("from East to North");
         destination_addr = 4'b0110;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            E_in.Send(packet);
            N_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
       $display("from East to PE");
         destination_addr = 4'b0101;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            E_in.Send(packet);
            PE_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
         
         //Testing South -> Others   
         $display("Testing Input from South to other direction");
         $display("from South to West");
         destination_addr = 4'b0001;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            S_in.Send(packet);
            W_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
        $display("from South to North");
         destination_addr = 4'b0110;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            S_in.Send(packet);
            N_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
        
        $display("from South to East");
         destination_addr = 4'b1001;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            S_in.Send(packet);
            E_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
       $display("from South to PE");
         destination_addr = 4'b0101;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            S_in.Send(packet);
            PE_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
       
       //Testing West -> Others
         $display("Testing Input from West to other direction");
         $display("from West to North");
         destination_addr = 4'b0110;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            W_in.Send(packet);
            N_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
        $display("from West to East");
         destination_addr = 4'b1001;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            W_in.Send(packet);
            E_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
        
        $display("from Wesst to South");
         destination_addr = 4'b0100;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            W_in.Send(packet);
            S_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
       $display("from West to PE");
         destination_addr = 4'b0101;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            W_in.Send(packet);
            PE_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
       //Testing PE -> Others
         $display("Testing Input from PE to other direction");
         $display("from PE to North");
         destination_addr = 4'b0110;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            PE_in.Send(packet);
            N_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
        $display("from PE to East");
         destination_addr = 4'b1001;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            PE_in.Send(packet);
            E_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
        
        $display("from PE to South");
         destination_addr = 4'b0100;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            PE_in.Send(packet);
            S_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
       $display("from PE to West");
         destination_addr = 4'b0001;
         packet = {packet[32], destination_addr[3:0], packet[27:0]};
         #5;
            PE_in.Send(packet);
            W_out.Receive(packet);
            $display("address = %b, destination = %b", address, destination_address);
            $display("Communication Achieved!!");
            
       $display("Finished");
       $stop;     
       end
       
endmodule
