`timescale 1ns / 1ps
import SystemVerilogCSP::*;

module DPkt_PE (interface packet_in, to_filter, to_ifmap);
    parameter width = 33;
    parameter FL = 1;
    parameter BL= 1;
    parameter filter_width = 8;
    parameter ifmap_width = 1;
    //logic counter = 0; //if = 0, filter; = 1, ifmap; when control get three filters and ifmaps, it will allow data go to Pket
    logic [9*ifmap_width-1:0] ifmap_packet;
    logic [3*filter_width-1 :0] filter_packet;
    logic [width-1: 0] packet;
    logic done = 0;
    
    always begin
        
        packet_in.Receive(packet);
        #FL;
        if(packet[width-1] == 1'b1)
        begin
            //$display ("%m receieved ifmap from source %b at %d", packet[27:24], $time);
            ifmap_packet = packet [9*ifmap_width-1:0];
            //counter = 1;
            $display ("%m addr(%b) received ifmap [%b, %b, %b] from addr %b at %d ", packet[31:28], ifmap_packet[2:0], ifmap_packet[5:3], ifmap_packet[8:6], packet[27:24],$time);
            fork
            to_ifmap.Send(ifmap_packet);
           // to_control.Send(counter);
            join
        end
        else if (packet[width-1] == 1'b0)
        begin
           // $display ("%m receieved filter from source %b at %d", packet[27:24], $time);
            filter_packet = packet[3*filter_width-1 :0];
            //counter = 0;
            $display ("%m addr(%b) received filter [%d, %d, %d] from addr %b at %d ", packet[31:28], filter_packet[7:0], filter_packet[15:8], filter_packet[23:16], packet[27:24], $time);
            fork
            to_filter.Send(filter_packet);
            //to_control.Send(counter);
            join
        end
        #BL;
    end
endmodule

module Pkt_PE (interface packet_out, data_in);
    parameter packet_width = 33;
    parameter data_width = 24;
    parameter FL = 1;
    parameter BL= 1;
    parameter addr_width = 4;
    parameter PE_X = 0;
    parameter PE_Y = 0;
    logic [packet_width-1 : 0] packet; 
    logic data;
    logic [addr_width-1 : 0] this_PE_addr;
    logic [3:0] Mem_warrper_addr = 13; //4'b1101
    
    always begin
        this_PE_addr = {PE_X, PE_Y};
        //$display ("PE %b packetizer ready", this_PE_addr);
    
        data_in.Receive(data);
        //$display("%m get data [%d, %d, %d] at %d", packet[7:0], packet[15:8], packet[23:16], $time);
        #FL;
        
        packet = {1'b0, Mem_warrper_addr, this_PE_addr, 23'b00000000000000000000000,data};
        $display("packet = %b, %b, [%d]", packet[31:28], packet[27:24], packet[23:0]);
        packet_out.Send(packet);
        #BL;
        
    end
endmodule

module Filter_mem(interface filter_in, interface filter_out);
    parameter WIDTH = 8;
    parameter FL = 2;
    parameter BL = 2;
    parameter DEPTH_F = 3;
    parameter ADDR_F = 2;
    logic [WIDTH-1 : 0]mem [2 : 0];
    logic [WIDTH*3 - 1:0] data_filter;
    int i = 0;
    
    always begin
    filter_in.Receive(data_filter);
    $display("%m. Receive data_filter = %d  %d  %d\n", data_filter[7:0], data_filter[15:8], data_filter[23:16]);
    #FL;
    mem[0] = data_filter[WIDTH*1 -1 : WIDTH*0];
    mem[1] = data_filter[WIDTH*2 -1 : WIDTH*1];
    mem[2] = data_filter[WIDTH*3 -1 : WIDTH*2];
    //$display("%m. mem = %d  %d  %d\n", mem[0], mem[1], mem[2]);
    for (i=0; i<3; i++)
        begin
            filter_out.Send(mem[i]);
        end
    #BL;
    end
endmodule

module ifmap_mem(interface ifmap_in, interface ifmap_out);
    parameter WIDTH = 1;
    parameter FL = 2;
    parameter BL = 2;
    parameter DEPTH_F = 3;
    parameter ADDR_F = 2;
    //logic [WIDTH*3-1 : 0]mem[2:0] [2 : 0];
    logic [WIDTH*9 - 1:0] data_ifmap;
    int i = 0;
    int j = 0;
    
    always begin
    ifmap_in.Receive(data_ifmap);
    $display("%m get data [%d, %d, %d] at %d", data_ifmap[2:0], data_ifmap[5:3], data_ifmap[8:6], $time);
    #FL;
    for (i=0; i<9; i++)
        begin
            ifmap_out.Send(data_ifmap[i]);
        end
    #BL;
    end
endmodule

module mult(interface L1, interface L2, interface R);
  parameter WIDTH=8;
  parameter FL = 2;
  parameter BL = 2;
  logic [8:0] data1,data2;
  logic [WIDTH-1:0] out; 
  always
  begin
    fork
     L1.Receive(data1);
     L2.Receive(data2);
    join
     $display("%m. Receive data1 = %d\n", data1);
    $display("%m. Receive data2 = %d\n", data2);
     #FL;
     out = data1 * data2;
     R.Send(out);
     $display("%m. Send out = %d\n", out);
     #BL;
  end
endmodule

module adder(interface T1, interface A1, interface R);
  parameter WIDTH = 8;
  parameter FL = 2;
  parameter BL = 2;
  logic [WIDTH-1 : 0] a1,a0 = 0;
  logic [8:0] out = 0; //8_bit_data add 8_bit_data = 9 bit out
  always
  begin
        fork
        A1.Receive(a1);
        T1.Receive(a0);
        join
      #FL;
       //$display("%m.a1 receive = %d\n",a1);
       out = a1 + a0;
      R.Send(out);
      $display("%m.a0[%d] + a1[%d]= out[%d] \n",a0, a1, out);
      //$display("%m.out send = %d\n",out);
      #BL;
  end // always
endmodule

module split (interface L, interface S, interface R1, interface R2 );//R1 to compare, R2 to accumulator
    parameter  WIDTH = 8;
    parameter FL = 2;
    parameter BL = 2;
    int select = 0 ;
    logic [WIDTH-1 : 0] data;
    always
    begin
        fork
        S.Receive(select);
        L.Receive(data);
        join
        $display("select = %d at %d", select, $time);
        #FL;
        case (select)
            0 : begin
                 //L.Receive(data);
                 R2.Send(data);
                end
            1 : begin
                 //L.Receive(data);
                 R1.Send(data);
                end
		default: $display("wrong control value");
        endcase
        #BL;
    end
endmodule

module compare(interface L, R);
    parameter WIDTH = 8;
    parameter FL = 2;
    parameter BL = 2;
    parameter VT = 49; //64;
    logic [WIDTH-1 : 0] data;
    logic out;
	logic [WIDTH-1 : 0] compare_data = 0;
    
    always begin
        L.Receive(data);
        $display("%m receive = %d at %d \n",data, $time);
        #FL;
		compare_data =compare_data + data;
	    if(compare_data >= VT)
            begin
            out = {1'b1};
            compare_data = compare_data - VT;
            end
        else if (compare_data < VT)
            begin
            out = {1'b0};
            end
        $display("compare_data = %d  \n",compare_data);
        fork
            R.Send(out);
        join
        #BL;
    end
endmodule

module accumulator(interface L1, interface L2, interface R);//L1 for clear; L2 for split_data; L3 for compare_data ; R for out
	    parameter WIDTH = 8;
        parameter FL = 2;
        parameter BL = 2;
        logic [WIDTH-1 : 0] data;
        int clear = 1;
        always
        begin
            L1.Receive(clear);
            $display("%m. Receive clear = %d\n", clear); 
            #FL;
            case(clear)
            0: begin
                L2.Receive(data);
               $display("%m. Receive data = %d\n", data);
                R.Send(data);
                end
            1: begin
                R.Send(0);
               $display("%m. Send out = 0\n");
               end
            endcase
            #BL;
        end 
endmodule

module control (interface clear_acc, interface split_sel);
    parameter FL = 2;
    parameter BL = 2;
    int i = 0;
    int j = 0;
    always 
    begin
        for(i=0;i<10;i++)
        begin
        clear_acc.Send(1);//restarting the accumulator
        for (j=0; j<8; j++)
            begin
                fork
                split_sel.Send(0); //steers to accumulator
                clear_acc.Send(0); // accumulator enabled
                join
            end
        fork 
        split_sel.Send(1); //steers to compare
        //clear_acc.Send(1);
        join
    end 
    #BL;
    end
endmodule

module PE(interface packet_in, packet_out);
    parameter PE_add_X = 0;
    parameter PE_add_Y = 0;
    Channel #(.hsProtocol(P4PhaseBD), .WIDTH(33)) intf  [12:0] ();
    
    DPkt_PE  DPkt_PE(.packet_in(packet_in), .to_filter(intf[0]), .to_ifmap(intf[1]) );
    Filter_mem Filter_mem(.filter_in(intf[0]), .filter_out(intf[2]));
    ifmap_mem ifmap_mem(.ifmap_in(intf[1]), .ifmap_out(intf[3]));
    mult mult(.L1(intf[2]), .L2(intf[3]), .R(intf[4]));
    adder adder(.T1(intf[4]), .A1(intf[5]), .R(intf[6]));
    split split(.L(intf[6]), .S(intf[7]), .R1(intf[8]), .R2(intf[9]));
    compare compare(.L(intf[8]), .R(intf[11]));
    accumulator accumulator(.L1(intf[12]), .L2(intf[9]), .R(intf[5]));
    control control(.clear_acc(intf[12]), .split_sel(intf[7]));
    Pkt_PE #(.PE_X(PE_add_X), .PE_Y(PE_add_Y)) Pkt_PE(.data_in(intf[11]), .packet_out(packet_out));
    

endmodule
