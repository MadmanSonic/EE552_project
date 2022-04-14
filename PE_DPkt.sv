module DPkt_PE (interface packet_in, to_filter, to_ifmap, to_control);
    parameter width = 33;
    parameter FL = 1;
    parameter BL= 1;
    parameter filter_width = 8;
    parameter ifmap_width = 1;
    logic counter = 0; //if = 0, filter; = 1, ifmap; when control get three filters and ifmaps, it will allow data go to Pket
    logic [9*ifmap_width-1:0] ifmap_packet;
    logic [3*filter_width-1 :0] filter_packet;
    logic [width-1: 0] packet = 0;
    
    always begin
        packet_in.Receive(packet);
        #FL;
        if(packet[width-1] == 1'b1)
        begin
            $display ("%m receieved ifmap from source %b at %d", packet[27:24], $time);
            ifmap_packet = packet [9*ifmap_width-1:0];
            counter = 1;
            $display ("%m addr(%b) received ifmap [%b, %b, %b] from addr %b at %d ", packet[31:28], ifmap_packet[2:0], ifmap_packet[5:3], ifmap_packet[8:6], packet[27:24],$time);
            fork
            to_ifmap.Send(ifmap_packet);
            to_control.Send(counter);
            join
        end
        else if (packet[width-1] == 1'b0)
        begin
            $display ("%m receieved filter from source %b at %d", packet[27:24], $time);
            filter_packet = packet[3*filter_width-1 :0];
            counter = 0;
            $display ("%m addr(%b) received filter [%d, %d, %d] from addr %b at %d ", packet[31:28], filter_packet[7:0], filter_packet[15:8], filter_packet[23:16], packet[27:24], $time);
            fork
            to_filter.Send(filter_packet);
            to_control.Send(counter);
            join
        end
        #BL;
    end
endmodule
