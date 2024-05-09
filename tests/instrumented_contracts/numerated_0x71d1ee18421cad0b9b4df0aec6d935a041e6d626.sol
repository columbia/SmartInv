1 pragma solidity ^0.4.11;
2 
3 //
4 // ==== DISCLAIMER ====
5 //
6 // ETHEREUM IS STILL AN EXPEREMENTAL TECHNOLOGY.
7 // ALTHOUGH THIS SMART CONTRACT WAS CREATED WITH GREAT CARE AND IN THE HOPE OF BEING USEFUL, NO GUARANTEES OF FLAWLESS OPERATION CAN BE GIVEN.
8 // IN PARTICULAR - SUBTILE BUGS, HACKER ATTACKS OR MALFUNCTION OF UNDERLYING TECHNOLOGY CAN CAUSE UNINTENTIONAL BEHAVIOUR.
9 // YOU ARE STRONGLY ENCOURAGED TO STUDY THIS SMART CONTRACT CAREFULLY IN ORDER TO UNDERSTAND POSSIBLE EDGE CASES AND RISKS.
10 // DON'T USE THIS SMART CONTRACT IF YOU HAVE SUBSTANTIAL DOUBTS OR IF YOU DON'T KNOW WHAT YOU ARE DOING.
11 //
12 // THIS SOFTWARE IS PROVIDED "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
13 // AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
14 // INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
15 // OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
16 // OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
17 // ====
18 //
19 //
20 // ==== PARANOIA NOTICE ====
21 // A careful reader will find some additional checks and excessive code, consuming some extra gas. This is intentional.
22 // Even though the contract should work without these parts, they make the code more secure in production and for future refactoring.
23 // Also, they show more clearly what we have considered and addressed during development.
24 // Discussion is welcome!
25 // ====
26 //
27 
28 /// @author ethernian
29 /// @notice report bugs to: bugs@ethernian.com
30 /// @title Presaler Voting Contract
31 
32 interface TokenStorage {
33     function balances(address account) public returns(uint balance);
34 }
35 
36 contract PresalerVoting {
37 
38     string public constant VERSION = "0.0.4";
39 
40     /* ====== configuration START ====== */
41 
42     uint public VOTING_START_BLOCKNR  = 0;
43     uint public VOTING_END_TIME       = 0;
44 
45     /* ====== configuration END ====== */
46 
47     TokenStorage PRESALE_CONTRACT = TokenStorage(0x4Fd997Ed7c10DbD04e95d3730cd77D79513076F2);
48 
49     string[3] private stateNames = ["BEFORE_START",  "VOTING_RUNNING", "CLOSED" ];
50     enum State { BEFORE_START,  VOTING_RUNNING, CLOSED }
51 
52     mapping (address => uint) public rawVotes;
53 
54     uint private constant MAX_AMOUNT_EQU_0_PERCENT   = 10 finney;
55     uint private constant MIN_AMOUNT_EQU_100_PERCENT = 1 ether ;
56 
57     address public owner;
58 
59     //constructors
60     function PresalerVoting () {
61         owner = msg.sender;
62     }
63 
64     //accept (and send back) voting payments here
65     function ()
66     onlyPresaler
67     onlyState(State.VOTING_RUNNING)
68     payable {
69         if (msg.value > 1 ether || !msg.sender.send(msg.value)) throw;
70         //special treatment for 0-ether payments
71         rawVotes[msg.sender] = msg.value > 0 ? msg.value : 1 wei;
72     }
73 
74     /// @notice start voting at `startBlockNr` for `durationHrs`.
75     /// Restricted for owner only.
76     /// @param startBlockNr block number to start voting; starts immediatly if less than current block number.
77     /// @param durationHrs voting duration (from now!); at least 1 hour.
78     function startVoting(uint startBlockNr, uint durationHrs) onlyOwner {
79         VOTING_START_BLOCKNR = max(block.number, startBlockNr);
80         VOTING_END_TIME = now + max(durationHrs,1) * 1 hours;
81     }
82 
83     function setOwner(address newOwner) onlyOwner {owner = newOwner;}
84 
85     /// @notice returns current voting result for given address in percent.
86     /// @param voter balance holder address.
87     function votedPerCent(address voter) constant external returns (uint) {
88         var rawVote = rawVotes[voter];
89         if (rawVote<=MAX_AMOUNT_EQU_0_PERCENT) return 0;
90         else if (rawVote>=MIN_AMOUNT_EQU_100_PERCENT) return 100;
91         else return rawVote * 100 / 1 ether;
92     }
93 
94     /// @notice return voting remaining time (hours, minutes).
95     function votingEndsInHHMM() constant returns (uint8, uint8) {
96         var tsec = VOTING_END_TIME - now;
97         return VOTING_END_TIME==0 ? (0,0) : (uint8(tsec / 1 hours), uint8(tsec % 1 hours / 1 minutes));
98     }
99 
100     function currentState() internal constant returns (State) {
101         if (VOTING_START_BLOCKNR == 0 || block.number < VOTING_START_BLOCKNR) {
102             return State.BEFORE_START;
103         } else if (now <= VOTING_END_TIME) {
104             return State.VOTING_RUNNING;
105         } else {
106             return State.CLOSED;
107         }
108     }
109 
110     /// @notice returns current state of the voting.
111     function state() public constant returns(string) {
112         return stateNames[uint(currentState())];
113     }
114 
115     function max(uint a, uint b) internal constant returns (uint maxValue) { return a>b ? a : b; }
116 
117     modifier onlyPresaler() {
118         if (PRESALE_CONTRACT.balances(msg.sender) == 0) throw;
119         _;
120     }
121 
122     modifier onlyState(State state) {
123         if (currentState()!=state) throw;
124         _;
125     }
126 
127     modifier onlyOwner() {
128         if (msg.sender!=owner) throw;
129         _;
130     }
131 
132 }//contract