module controller(
   input clk,
   input reset,
   input id_valid, id_used,
   input [3:0] id,
   input check,
   input vote_signal,
   input candidate_select,
   output reg mark_done,
   output reg vote_enable,
   output reg current_candidate,
   output reg vote_done
);


parameter Idle      = 2'b00;
parameter Check_ID  = 2'b01;
parameter Vote      = 2'b10;

reg [1:0] state, next_state;

// Sequential block
always @(posedge clk or posedge reset) begin
   if (reset) begin
      state <= Idle;
      mark_done <= 0;
      vote_enable <= 0;
      current_candidate <= 0;
      vote_done <= 0;
   end else begin
      state <= next_state;
   end
end

// Combinational block
always @(*) begin
   // Default outputs
   mark_done = 0;
   vote_enable = 0;
   current_candidate = 0;
   vote_done = 0;
   next_state = state;

   case (state)
      Idle: begin
         if (check)
            next_state = Check_ID;
         else
            next_state = Idle;
      end

      Check_ID: begin
         if (id_valid)
            next_state = Vote;
         else
            next_state = Idle;
      end

      Vote: begin
         if (vote_signal && id_valid) begin
            vote_enable = 1;
            current_candidate = candidate_select;
            mark_done = 1;
            vote_done = 1;
            next_state = Idle;
         end else begin
            next_state = Idle;
         end
      end

      default: next_state = Idle;
   endcase
end

endmodule

