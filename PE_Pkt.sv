module Pkt_PE (interface packet_out, data_in);
    parameter packet_width = 33;
    parameter data_width = 24;
    parameter FL = 1;
    parameter BL= 1;
    parameter addr_width = 4;
    parameter PE_X = 0;
    parameter PE_Y = 0;
    logic [packet_width-1 : 0] packet = 0; 
    logic [data_width-1 : 0] data = 0;
    logic [addr_width-1 : 0] this_PE_addr;
    logic [3:0] Mem_warrper_addr = 13; //4'b1101
    
    always begin
        this_PE_addr = {PE_X, PE_Y};
        $display ("PE %b packetizer ready", this_PE_addr);
    
        data_in.Receive(data);
        $display("%m get data [%d, %d, %d] at %d", packet[7:0], packet[15:8], packet[23:16], $time);
        #FL;
        
        packet = {1'b0, Mem_warrper_addr, this_PE_addr, data};
        $display("packet = %b, %b, [%d]", packet[31:28], packet[27:24], packet[23:0]);
        packet_out.Send(packet);
        #BL;
        
    end
endmodule
