# Digital Voting Machine (Verilog)

A digital voting machine implemented in Verilog HDL using a Finite State Machine (FSM) architecture. The system supports 16 voters and 2 candidates, strictly enforcing one vote per voter through ID-based eligibility checking.

---

## 📁 Repository Structure

```
Voting_Machine/
├── source_files/
│   ├── idchecker.v          # Voter ID eligibility checker
│   ├── vote_counter.v       # Vote tallying module
│   ├── controller.v         # FSM controller
│   └── voting_machine.v     # Top-level integration
├── Testbench/
│   └── tb_voting_machine.v  # Simulation testbench
├── Output_Waveform/
│   └── waveform.png         # Simulation output waveform
└── README.md
```

---

## 🧩 Module Descriptions

### 1. ID Checker (`idchecker.v`)
Verifies voter eligibility before allowing a vote to be cast.

| Port | Direction | Description |
|---|---|---|
| `clk` | Input | System clock |
| `reset` | Input | Resets all voting flags |
| `id[3:0]` | Input | Voter ID (0–15) |
| `check` | Input | Trigger eligibility check |
| `mark_done` | Input | Marks voter as having voted |
| `id_valid` | Output | High if voter is eligible |
| `id_used` | Output | High if voter already voted |

Internally maintains a `voted_flag[15:0]` register to track which voter IDs have been used.

---

### 2. Vote Counter (`vote_counter.v`)
Tallies votes for two candidates based on a valid voter's selection.

| Port | Direction | Description |
|---|---|---|
| `clk`, `reset` | Input | Clock and reset |
| `id_valid` | Input | Enables counting only for eligible voters |
| `vote_signal` | Input | High when the voter casts their vote |
| `candidate_select` | Input | 0 = Candidate A, 1 = Candidate B |
| `votes0` | Output | Total votes for Candidate A |
| `votes1` | Output | Total votes for Candidate B |

---

### 3. Controller FSM (`controller.v`)
Manages the complete voting sequence using a 3-state FSM.

| State | Description |
|---|---|
| `IDLE` | Waits for a voter to initiate a check |
| `CHECK_ID` | Reads eligibility from the ID Checker |
| `VOTE` | Enables voting if the voter is eligible |

Outputs: `mark_done`, `vote_enable`, `current_candidate`, `vote_done`

---

### 4. Top-Level Voting Machine (`voting_machine.v`)
Integrates the ID Checker, Controller FSM, and Vote Counter. Exposes a single clean interface for the full voting system.

**Inputs:** `clk`, `reset`, `id[3:0]`, `check`, `vote_signal`, `candidate_select`

**Outputs:** `votes0`, `votes1`, `id_valid`, `id_used`, `vote_done`

---

### 5. Testbench (`tb_voting_machine.v`)
Simulates voting scenarios including valid votes and duplicate vote attempts.

**Test cases covered:**
1. Voter 1 votes for Candidate A
2. Voter 2 votes for Candidate B
3. Voter 1 attempts to vote again (rejected)
4. Final vote counts printed to console

---

## 🔄 System Workflow

```
Voter enters ID → press check
       ↓
Controller FSM reads id_valid from ID Checker
       ↓
  Eligible? ──No──→ Return to IDLE
       ↓ Yes
Voter selects candidate → presses vote_signal
       ↓
Controller sends vote_enable to Vote Counter
Controller sends mark_done to ID Checker
       ↓
Vote Counter increments candidate's tally
       ↓
FSM returns to IDLE for next voter
```

---

## ✅ Features

- Modular and easy to extend (add more candidates or voters)
- Enforces one vote per voter using hardware flags
- Supports 16 voters and 2 candidates
- Compatible with Verilog-2001 and FPGA synthesis tools

---

## 🖥️ How to Simulate

**Using ModelSim:**
1. Add all `.v` files from `source_files/` and `Testbench/`
2. Compile all sources
3. Simulate `tb_voting_machine`
4. Observe `votes0` and `votes1` updating only for valid, first-time voters

**Using Icarus Verilog (free):**
```bash
iverilog -o voting_sim source_files/*.v Testbench/tb_voting_machine.v
vvp voting_sim
```

**Using EDA Playground** (no installation needed):
- Upload all `.v` files at [edaplayground.com](https://www.edaplayground.com)

---

## 🔭 Future Improvements

- [ ] Support more than 2 candidates
- [ ] Add a display output (7-segment or LCD) for vote counts
- [ ] Implement FPGA deployment with physical buttons as inputs
- [ ] Add an admin mode to view results and reset the machine

---

## 🛠️ Tools Used

- Verilog HDL (IEEE 1364-2001)
- ModelSim / Icarus Verilog
