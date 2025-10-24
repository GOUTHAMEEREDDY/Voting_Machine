module tb_voting_machine;

reg clk;
reg reset;
reg [3:0] id;
reg check;
reg vote_signal;
reg candidate_select;
wire [7:0] votes0;
wire [7:0] votes1;
wire id_valid;
wire id_used;
wire vote_done;

// top-level voting machine
voting_machine uut (
    .clk(clk),
    .reset(reset),
    .id(id),
    .check(check),
    .vote_signal(vote_signal),
    .candidate_select(candidate_select),
    .votes0(votes0),
    .votes1(votes1),
    .id_valid(id_valid),
    .id_used(id_used),
    .vote_done(vote_done)
);

// Clock 
always #5 clk = ~clk;

// Test cases
initial begin    
    clk = 0;
    reset = 1;
    check = 0;
    vote_signal = 0;
    candidate_select = 0;
    id = 0;
    #20 reset = 0;

    // Voter 1 checks and votes for candidate 0
    id = 4'd1;
    check = 1;
    #10 check = 0;
    #10 vote_signal = 1;
    candidate_select = 0;
    #10 vote_signal = 0;
    #20;

    // Voter 2 checks and votes for candidate 1
    id = 4'd2;
    check = 1;
    #10 check = 0;
    #10 vote_signal = 1;
    candidate_select = 1;
    #10 vote_signal = 0;
    #20;

    // Same voter (ID=1) tries again (should be rejected)
    id = 4'd1;
    check = 1;
    #10 check = 0;
    #10 vote_signal = 1;
    candidate_select = 1;
    #10 vote_signal = 0;
    #20;

  
    $display("Final Vote Counts: Candidate0=%d Candidate1=%d", votes0, votes1);
    #50 $finish;
end

endmodule

