module voting_machine(
    input clk,
    input reset,
    input [3:0] id,
    input check,
    input vote_signal,
    input candidate_select,
    output [7:0] votes0,
    output [7:0] votes1,
    output id_valid,
    output id_used,
    output vote_done
);

wire mark_done;
wire vote_enable;
wire current_candidate;

// Instantiate ID Checker
idchecker id_checker_inst (
    .clk(clk),
    .reset(reset),
    .id(id),
    .check(check),
    .mark_done(mark_done),
    .id_valid(id_valid),
    .id_used(id_used)
);

// Instantiate Controller
controller controller_inst (
    .clk(clk),
    .reset(reset),
    .id_valid(id_valid),
    .id_used(id_used),
    .id(id),
    .check(check),
    .vote_signal(vote_signal),
    .candidate_select(candidate_select),
    .mark_done(mark_done),
    .vote_enable(vote_enable),
    .current_candidate(current_candidate),
    .vote_done(vote_done)
);

// Instantiate Vote Counter
vote_counter vote_counter_inst (
    .clk(clk),
    .reset(reset),
    .id_valid(id_valid & vote_enable),
    .vote_signal(vote_signal),
    .candidate_select(current_candidate),
    .votes0(votes0),
    .votes1(votes1)
);

endmodule

