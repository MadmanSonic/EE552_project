`timescale 1ns/1ps
import SystemVerilogCSP::*;

module memory_wrapper(Channel toMemRead, Channel toMemWrite, Channel toMemT, Channel toMemX, Channel toMemY, Channel toMemSendData, Channel fromMemGetData, Channel toNOC, Channel fromNOC); 

parameter mem_delay = 15;
parameter simulating_processing_delay = 30;
parameter timesteps = 10;
parameter WIDTH = 8;
  Channel #(.hsProtocol(P4PhaseBD)) intf[9:0] (); 
  int num_filts_x = 3;
  int num_filts_y = 3;
  int ofx = 3;
  int ofy = 3;
  int ifx = 5;
  int ify = 5;
  int ift = 10;
  int FL = 2;
  int BL = 2;
  int i,j,k,t;
  int read_filts = 2;
  int read_ifmaps = 1; // write_ofmaps = 1 as well...
  int read_mempots = 0;
  int write_ofmaps = 1;
  int write_mempots = 0;
  logic [WIDTH-1:0] byteval[8:0];
  logic spikeval[24:0];
  logic [24:0] filter_packet;
  //logic [9:0] ifmap_packet;
  logic [32:0] packet;
  logic [32:0] rec_packet;
  logic [WIDTH-1 : 0] mem_potentials [2:0] [2:0];
  logic mem_spikes [2:0] [2:0];
  
// Weight stationary design
// TO DO: modify for your dataflow - can read an entire row (or write one) before #mem_delay
// TO DO: decide whether each Send(*)/Receive(*) is correct, or just a placeholder
  initial begin
	for (int i = 0; i < num_filts_x; i++) begin
		for (int j = 0; j < num_filts_y; ++j) begin
			$display("%m Requesting filter [%d][%d] at time %d",i,j,$time);
			toMemRead.Send(read_filts);
			toMemX.Send(i);
			toMemY.Send(j);
			fromMemGetData.Receive(byteval[i*3 + j]);
			$display("%m Received filter[%d][%d] = %d at time %d",i,j,byteval[i*3 + j],$time);
		end
		#mem_delay;
	end
   $display("%m Received all filters at time %d", $time);
    for (int t = 1; t <= timesteps; t++) begin
	$display("%m beginning timestep t = %d at time = %d",t,$time);
		// get the new ifmaps
		for (int i = 0; i < ifx; i++) begin
			for (int j = 0; j < ify; ++j) begin
				// TO DO: read old membrane potential (hint: you can't do it here...)
				$display("%m requesting ifm[%d][%d]",i,j);
				// request the input spikes
				toMemRead.Send(read_ifmaps);
				toMemX.Send(i);
				toMemY.Send(j);
				fromMemGetData.Receive(spikeval[i*5 + j]);
				$display("%m received ifm[%d][%d] = %b",i,j,spikeval[i*5 + j]);				
				// do processing (delete this line)
				//#simulating_processing_delay;
			end // ify
			#mem_delay; // wait for them to arrive
		end // ifx
	$display("%m received all ifmaps for timestep t = %d at time = %d",t,$time);
		
		//Send data to NOC
		for (int i = 0; i < num_filts_x; i++) begin
			//for (int j = 0; j < num_filts_y; ++j) begin
			filter_packet = {1'b0, byteval[i*3 + 2], byteval[i*3 + 1], byteval[i*3 + 0]};
			for (int j = 0; j < 9; j++) 
			begin
					if (i == 0) 
					   begin
						case (j) 
								0 : begin
									packet = {filter_packet[24], 4'b0010, 4'b1101, filter_packet[23:0]};
									toNOC.Send(packet);
									packet = {1'b1, 4'b0010, 4'b1101, 15'b000000000000000, spikeval[12], spikeval[11], spikeval[10], spikeval[7], spikeval[6], spikeval[5], spikeval[2], spikeval[1],spikeval[0]};
									toNOC.Send(packet);
									$display("j = %d", j);
									#BL;
									end
								1 : begin
									packet = {filter_packet[24], 4'b0110, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									packet = {1'b1, 4'b0110, 4'b1101, 15'b000000000000000, spikeval[13], spikeval[12], spikeval[11], spikeval[8], spikeval[7], spikeval[6], spikeval[3], spikeval[2],spikeval[1]};
									toNOC.Send(packet);
									$display("j = %d", j);
									#BL;
									end	
								2 : begin
									packet = {filter_packet[24], 4'b1010, 4'b1101, filter_packet[23:0]};
									toNOC.Send(packet);
									packet = {1'b1, 4'b1010, 4'b1101, 15'b000000000000000, spikeval[14], spikeval[13], spikeval[12], spikeval[9], spikeval[8], spikeval[7], spikeval[4], spikeval[3],spikeval[2]};
									toNOC.Send(packet);
									$display("j = %d", j);
									#BL;									
									end	
								3 : begin
									packet = {filter_packet[24], 4'b0001, 4'b1101, filter_packet[23:0]};
									toNOC.Send(packet);
									packet = {1'b1, 4'b0001, 4'b1101, 15'b000000000000000, spikeval[17], spikeval[16], spikeval[15], spikeval[12], spikeval[11], spikeval[10], spikeval[7], spikeval[6],spikeval[5]};
									toNOC.Send(packet);
									$display("j = %d", j);
									#BL;																		
									end	
								4 : begin
									packet = {filter_packet[24], 4'b0101, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									packet = {1'b1, 4'b0101, 4'b1101, 15'b000000000000000, spikeval[18], spikeval[17], spikeval[16], spikeval[13], spikeval[12], spikeval[11], spikeval[8], spikeval[7],spikeval[6]};
									toNOC.Send(packet);
									$display("j = %d", j);
									#BL;				
									end	
								5 : begin
									packet = {filter_packet[24], 4'b1001, 4'b1101, filter_packet[23:0]};
									toNOC.Send(packet);
									packet = {1'b1, 4'b1001, 4'b1101, 15'b000000000000000, spikeval[19], spikeval[18], spikeval[17], spikeval[14], spikeval[13], spikeval[12], spikeval[9], spikeval[8],spikeval[7]};
									toNOC.Send(packet);
									$display("j = %d", j);
									#BL;											
									end	
								6 : begin
									packet = {filter_packet[24], 4'b0000, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									packet = {1'b1, 4'b0000, 4'b1101, 15'b000000000000000, spikeval[22], spikeval[21], spikeval[20], spikeval[17], spikeval[16], spikeval[15], spikeval[12], spikeval[11],spikeval[10]};
									toNOC.Send(packet);
									$display("j = %d", j);
									#BL;		
									end	
								7 : begin
									packet = {filter_packet[24], 4'b0100, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									packet = {1'b1, 4'b0100, 4'b1101, 15'b000000000000000, spikeval[23], spikeval[22], spikeval[21], spikeval[18], spikeval[17], spikeval[16], spikeval[13], spikeval[12],spikeval[11]};
									toNOC.Send(packet);
									$display("j = %d", j);
									#BL;		
									end	
								8 : begin
									packet = {filter_packet[24], 4'b1000, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									packet = {1'b1, 4'b1000, 4'b1101, 15'b000000000000000, spikeval[24], spikeval[23], spikeval[22], spikeval[19], spikeval[18], spikeval[17], spikeval[14], spikeval[13],spikeval[12]};
									toNOC.Send(packet);
									$display("j = %d", j);
									#BL;		
									end	
							endcase
					   end//if
					else 
						begin
						case (j) 
								0 : begin
									packet = {filter_packet[24], 4'b0010, 4'b1101, filter_packet[23:0]};
									toNOC.Send(packet);
									#BL;
									end
								1 : begin
									packet = {filter_packet[24], 4'b0110, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									#BL;
									end	
								2 : begin
									packet = {filter_packet[24], 4'b1010, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									#BL;
									end	
								3 : begin
									packet = {filter_packet[24], 4'b0001, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									#BL;
									end	
								4 : begin
									packet = {filter_packet[24], 4'b0101, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									#BL;
									end	
								5 : begin
									packet = {filter_packet[24], 4'b1001, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									#BL;
									end	
								6 : begin
									packet = {filter_packet[24], 4'b0000, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									#BL;
									end	
								7 : begin
									packet = {filter_packet[24], 4'b0100, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									#BL;
									end	
								8 : begin
									packet = {filter_packet[24], 4'b1000, 4'b1101, filter_packet[23:0]};	
									toNOC.Send(packet);
									#BL;
									end	
							endcase
						end
			end
		end	
		
		//receive data from DPKT
        for (int i = 0; i < 9; i++) 
		begin
			fromNOC.Receive(rec_packet);
			#FL;
			case(rec_packet[27:24]) 
				4'b0010 : 	begin	
							j = 0;
							k = 0;
							mem_spikes[j][k] = rec_packet[0];
							end
				4'b0110 : 	begin	
							j = 0;
							k = 1;
							mem_spikes[j][k] = rec_packet[0];
							end
				4'b1010 : 	begin	
							j = 0;
							k = 2;
							mem_spikes[j][k] = rec_packet[0];
							end
				4'b0001 : 	begin	
							j = 1;
							k = 0;
							mem_spikes[j][k] = rec_packet[0];
							end
				4'b0101 : 	begin	
							j = 1;
							k = 1;
							mem_spikes[j][k] = rec_packet[0];
							end
				4'b1001 : 	begin	
							j = 1;
							k = 2;
							mem_spikes[j][k] = rec_packet[0];
							end
				4'b0000 : 	begin	
							j = 2;
							k = 0;
							mem_spikes[j][k] = rec_packet[0];
							end			
				4'b0100 : 	begin	
							j = 2;
							k = 1;
							mem_spikes[j][k] = rec_packet[0];
							end		
				4'b1000 : 	begin	
							j = 2;
							k = 2;
							mem_spikes[j][k] = rec_packet[0];
							end				
			endcase
		end			
		
		// write back membrane potentials & spikes
		// TO DO: you need to get them from the NoC first!
		for (int i = 0; i < ofx; i++) begin
			for (int j = 0; j < ofy; j++) begin											
				toMemWrite.Send(write_ofmaps);
				toMemX.Send(i);
				toMemY.Send(j);				
				toMemSendData.Send(mem_spikes[i][j]);
			end // ofy
		end // ofx
		
		$display("%m sent all output spikes and stored membrane potentials for timestep t = %d at time = %d",t,$time);
		toMemT.Send(t);
		$display("%m send request to advance to next timestep at time t = %d",$time);
	end // t = timesteps
	$display("%m done");
	#mem_delay; // let memory display comparison of golden vs your outputs
	$stop;
  end//initial
  
  always begin
	#200;
	$display("%m working still...");
  end
  
endmodule
