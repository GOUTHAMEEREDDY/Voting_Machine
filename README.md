# Digital Voting Machine Using Verilog

## Project Overview
This project implements a **digital voting machine** using Verilog HDL. It supports **16 voters** and **2 candidates**, ensuring **one vote per voter**. The system is modular, consisting of:

1. **ID Checker** – Verifies voter eligibility.
2. **Vote Counter** – Counts votes for each candidate.
3. **Controller FSM** – Manages the voting process sequence.
4. **Top-Level Voting Machine** – Integrates all modules.
5. **Testbench** – Simulates the complete system.

---

## Module Descriptions

### 1. ID Checker (`idchecker.v`)
**Purpose:**  
- Checks whether a voter has already voted.  
- Outputs `id_valid` if voter is eligible, `id_used` if already voted.

**Inputs:**  
- `clk` – System clock  
- `reset` – Resets module and voting flags  
- `id[3:0]` – Voter ID (0–15)  
- `check` – Signal to check voter eligibility  
- `mark_done` – Marks voter as having voted  

**Outputs:**  
- `id_valid` – 1 if voter can vote  
- `id_used` – 1 if voter already voted  

**Internal:**  
- `voted_flag[15:0]` – Keeps track of which IDs have voted  

---

### 2. Vote Counter (`vote_counter.v`)
**Purpose:**  
- Counts votes for two candidates based on voter selection.  

**Inputs:**  
- `clk`, `reset` – Clock and reset signals  
- `id_valid` – Enables vote counting only for valid voters  
- `vote_signal` – High when voter casts vote  
- `candidate_select` – 0 or 1 to select candidate  

**Outputs:**  
- `votes0` – Total votes for candidate 0  
- `votes1` – Total votes for candidate 1  

---

### 3. Controller FSM (`controller.v`)
**Purpose:**  
- Manages the voting sequence: check ID → enable voting → mark done → return to idle.  
- Prevents multiple votes per voter and synchronizes voting signals.

**Inputs:**  
- `clk`, `reset`  
- `id_valid`, `id_used`  
- `id[3:0]`, `check`, `vote_signal`, `candidate_select`  

**Outputs:**  
- `mark_done` – Marks voter as voted in ID Checker  
- `vote_enable` – Enables Vote Counter  
- `current_candidate` – Passes selected candidate to Vote Counter  
- `vote_done` – Indicates voting for a voter is complete  

**States:**  
1. **Idle** – Waits for voter to press check  
2. **Check_ID** – Reads `id_valid` from ID Checker  
3. **Vote** – Enables voting if eligible  

---

### 4. Top-Level Voting Machine (`voting_machine.v`)
**Purpose:**  
- Integrates ID Checker, Controller FSM, and Vote Counter.  
- Connects signals between modules to form a complete voting system.

**Inputs:**  
- `clk`, `reset`, `id[3:0]`, `check`, `vote_signal`, `candidate_select`  

**Outputs:**  
- `votes0`, `votes1` – Final vote counts  
- `id_valid`, `id_used` – Voter status  
- `vote_done` – Indicates vote is processed  

**Connections:**  
- `mark_done` and `vote_enable` signals coordinate ID Checker and Vote Counter via Controller FSM.  

---

### 5. Testbench (`tb_voting_machine.v`)
**Purpose:**  
- Simulates voting for multiple voters, including repeated attempts.  
- Verifies **one vote per voter** rule.

**Test Cases:**  
1. Voter 1 votes for candidate 0  
2. Voter 2 votes for candidate 1  
3. Voter 1 tries to vote again (should be rejected)  
4. Prints final vote counts  

---

## System Workflow

1. Voter enters ID and presses `check`.  
2. Controller FSM reads `id_valid` from ID Checker:  
   - If eligible → allow voting  
   - If already voted → return to idle  
3. Voter selects candidate and presses `vote_signal`.  
4. Controller enables vote counting (`vote_enable`) and signals `mark_done` to ID Checker.  
5. Vote Counter increments the selected candidate’s vote.  
6. FSM returns to Idle for the next voter.  

---

## Features
- Modular and easy to expand  
- Enforces **one vote per voter**  
- Supports **16 voters** and **2 candidates**  
- Compatible with Verilog-2001 and FPGA synthesis tools  

---

## Simulation
- Run `tb_voting_machine.v` in your simulator.  
- Observe `votes0` and `votes1` updating only for valid voters.  
- Repeated votes by the same ID are ignored.
