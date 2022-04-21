`timescale 1ns / 1ps

import SystemVerilogCSP::*;

module NoC_tb();
    
    parameter WIDTH = 33;
    parameter FL = 2;
    parameter BL = 1;
    parameter packet_delay = 32;
    parameter add_width = 4;
    
    logic [WIDTH-1:0] packet = 0;
    lgoic filt_bit = 1'b0;
    logic [add_width-1: 0] destination_addr = 0;
    logic [add_width-1: 0] source_addr = 0;
    
    // PE_in Channel
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE0_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE1_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE2_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE3_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE4_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE5_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE6_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE7_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE8_in;
    
    //PE_out Channel
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE0_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE1_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE2_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE3_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE4_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE5_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE6_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE7_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) PE8_out;
    
    // Router_in Channel
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R1_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R2_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R3_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R4_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R5_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R6_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R7_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R8_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R9_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R10_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R11_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R12_in;
    
    // Router_out Channel
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R1_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R2_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R3_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R4_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R5_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R6_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R7_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R8_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R9_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R10_out;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R11_in;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) R12_out;
    
    //wrapper_in and wrapper_out Channel   
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) wrapper_in();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) wrapper_out();
    
    //memory_in and memory_out Channel
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) memory_in();
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(WIDTH)) memory_out();
    
    NoC #(.WIDTH(WIDTH), .FL(FL), .BL(BL)) NoC_Sim(.PE0_in(PE0_in), .PE1_in(PE1_in), .PE2_in(PE2_in), .PE3_in(PE3_in), .PE4_in(PE4_in), .PE5_in(PE5_in), .PE6_in(PE6_in), .PE7_in(PE7_in), .PE8_in(PE8_in),
                                                   .PE0_out(PE0_out), .PE1_out(PE1_out), .PE2_out(PE2_out), .PE3_out(PE3_out), .PE4_out(PE4_out), .PE5_out(PE5_out), .PE6_out(PE6_out), .PE7_out(PE7_out), .PE8_out(PE8_out),
                                                   .R1_in(R1_in), .R2_in(R2_in), .R3_in(R3_in), .R4_in(R4_in), .R5_in(R5_in), .R6_in(R6_in), .R7_in(R7_in), .R8_in(R8_in), .R9_in(R9_in), .R10_in(R10_in), .R11_in(R11_in), .R12_in(R12_in),
                                                   .R1_out(R1_out), .R2_out(R2_out), .R3_out(R3_out), .R4_out(R4_out), .R5_out(R5_out), .R6_out(R6_out), .R7_out(R7_out), .R8_out(R8_out), .R9_out(R9_out), .R10_out(R10_out), .R11_out(R11_out), .R12_out(R12_out),
                                                   .wrapper_in(wrapper_in), .wrapper_out(wrapper_out), .memory_in(memory_in), .memory_out(memory_out));
                                                   
    logic [4:0] k = 0;
    logic [23:0] data;
    
    initial
    begin
    
    while ( k < 50)
        begin
            destination_addr = $urandom % 16;
            source_addr = $urandom % 16;
            
            while (destination_addr == source_addr)
            begin
                
                destination_addr = $urandom % 8;
                source_addr = $urandom % 8;
                
                while((source_addr != 4'b0000) || (source_addr != 4'b0100) || (source_addr != 4'b1000) || (source_addr != 4'b1001) || (source_addr != 4'b0101) || (source_addr != 4'b0001) || (source_addr != 4'b0010) || (source_addr != 4'b0110) || (source_addr != 4'b1010) || (source_addr != 4'b1101))
                    begin
                        source_addr = $random();
                    end
                    
                while((destination_addr != 4'b0000) || (destination_addr != 4'b0100) || (destination_addr != 4'b1000) || (destination_addr != 4'b1001) || (destination_addr != 4'b0101) || (destination_addr != 4'b0001) || (destination_addr != 4'b0010) || (destination_addr != 4'b0110) || (destination_addr != 4'b1010) || (destination_addr != 4'b1101))
                    begin
                        destination_addr = $random();
                    end
            end
            
            while((source_addr != 4'b0000) || (source_addr != 4'b0100) || (source_addr != 4'b1000) || (source_addr != 4'b1001) || (source_addr != 4'b0101) || (source_addr != 4'b0001) || (source_addr != 4'b0010) || (source_addr != 4'b0110) || (source_addr != 4'b1010) || (source_addr != 4'b1101))
                    begin
                        source_addr = $random();
                    end
                    
            while((destination_addr != 4'b0000) || (destination_addr != 4'b0100) || (destination_addr != 4'b1000) || (destination_addr != 4'b1001) || (destination_addr != 4'b0101) || (destination_addr != 4'b0001) || (destination_addr != 4'b0010) || (destination_addr != 4'b0110) || (destination_addr != 4'b1010) || (destination_addr != 4'b1101))
                    begin
                        destination_addr = $random();
                    end                           
      
        data = $urandom % 1024;
        filt_bit = $random()%2;
        packet = {filt_bit, destination_addr[add_width-1:0], source_addr [add_width-1:0], data[23:0]};
        
        case(source_addr)
            4'b0000: begin
                        PE0_in.Send(packet);
                        R5_in.Send(packet);
                        R1_in.Send(packet);
                     end
            4'b0100: begin
                        R1_in.Send(packet);
                        R4_in.Send(packet);
                        R2_in.Send(packet);
                     end
            4'b1000: begin
                        PE2_in.Send(packet);
                        R2_in.Send(packet);
                        R3_in.Send(packet);                       
                     end
            4'b0001:begin
                        PE3_in.Send(packet);
                        R10_in.Send(packet);
                        R6_in.Send(packet);
                        R5_in.Send(packet);
                    end
            4'b0101:begin
                        PE4_in.Send(packet);
                        R6_in.Send(packet);
                        R9_in.Send(packet);
                        R7_in.Send(packet);
                        R4_in.Send(packet);
                    end               
            
            4'b1001 : begin
                        PE5_in.Send(packet);
                        wrapper_in.Send(packet);
                        R8_in.Send(packet);
                        R7_in.Send(packet);
                        R3_in.Send(packet);
                      end
            4'b0010:begin
                        PE6_in.Send(packet);
                        R11_in.Send(packet);
                        R10_in.Send(packet);
                    end 
            
            4'b0110:begin
                        PE7_in.Send(packet);
                        R11_in.Send(packet);
                        R12_in.Send(packet);
                        R9_in.Send(packet);
                    end
            4'b1010: begin
                        PE8_in.Send(packet);
                        R12_in.Send(packet);
                        R8_in.Send(packet);
                    end
            4'b1101 : memory_in.Send(packet);
        endcase 
           
        case(destination_addr)
            4'b0000: begin
                        PE0_out.Receive(packet);
                        R5_out.Receive(packet);
                        R1_out.Receive(packet);
                     end
            4'b0100: begin
                        PE1_out.Receive(packet);
                        R1_out.Receive(packet);
                        R2_out.Receive(packet);
                        R4_out.Receive(packet);
                     end
            4'b1000: begin
                        PE2_out.Receive(packet);
                        R2_out.Receive(packet);
                        R3_out.Receive(packet);                       
                     end
            4'b0001:begin
                        PE3_out.Receive(packet);
                        R5_out.Receive(packet);
                        R6_out.Receive(packet);
                        R10_out.Receive(packet);
                    end
            4'b0101:begin
                        PE4_out.Receive(packet);
                        R6_out.Receive(packet);
                        R4_out.Receive(packet);
                        R9_out.Receive(packet);
                        R7_out.Receive(packet);
                    end               
            
            4'b1001 : begin
                        PE5_out.Receive(packet);
                        R7_out.Receive(packet);
                        R8_out.Receive(packet);
                        R3_out.Receive(packet);
                        wrapper_out.Receive(packet);
                      end
            4'b0010:begin
                        PE26out.Receive(packet);
                        R10_out.Receive(packet);
                        R11_out.Receive(packet);
                    end 
            
            4'b0110:begin
                        PE7_out.Receive(packet);
                        R11_out.Receive(packet);
                        R12_out.Receive(packet);
                        R9_out.Receive(packet);
                    end
            4'b1010: begin
                        PE8_out.Receive(packet);
                        R12_out.Receive(packet);
                        R8_out.Receive(packet);
                    end
            4'b1101 : memory_out.Receive(packet);           
        endcase
        
        k++;
        #packet_delay;
       end
       
       #500;
       $display("Finished");
    end    
endmodule