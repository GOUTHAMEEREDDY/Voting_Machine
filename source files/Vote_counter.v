module vote_counter(
  input clk,
  input reset,
  input id_valid,
  input vote_signal,
  input candidate_select,
  output reg [7:0]votes0, //here the number of candiddates are 2
  output reg [7:0]votes1
);
always @(posedge clk)
begin
   if(reset) begin
   votes0<=8'b0;
   votes1<=8'b0;
   end
   if(vote_signal && id_valid)begin
   if(candidate_select==1'b0)
       votes0<=votes0+1;
   else
       votes1<=votes1+1;
   end
end
endmodule
