module idchecker(
 input clk,
 input reset,
 input [3:0]id,
 input check,
 input mark_done,
 output reg id_valid,
 output reg id_used 
);

reg [15:0]voted_flag;

always @(posedge clk)
   begin
      if(reset)
      begin
      voted_flag<=16'b0;
      id_valid<=0;
      id_used<=0;
      end
      else
      begin
      id_valid<=0;
      id_used<=0;
     if(check)
      begin
      if(voted_flag[id]==0)
      id_valid<=1;
      else 
      id_used<=1;
      end
      if(mark_done) 
      voted_flag[id]<=1;
      end
      end
endmodule

