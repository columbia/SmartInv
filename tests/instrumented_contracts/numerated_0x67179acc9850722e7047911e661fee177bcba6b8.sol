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
32 contract TokenStorage {
33     function balances(address account) public returns(uint balance);
34 }
35 
36 contract PresalerVoting {
37 
38     string public constant VERSION = "0.0.8";
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
56     uint public constant TOTAL_BONUS_SUPPLY_ETH = 12000;
57 
58 
59 
60     address public owner;
61     address[] public voters;
62     uint16 public stakeVoted_Eth;
63     uint16 public stakeRemainingToVote_Eth;
64     uint16 public stakeWaived_Eth;
65     uint16 public stakeConfirmed_Eth;
66 
67     //constructors
68     function PresalerVoting () {
69         owner = msg.sender;
70     }
71 
72     //accept (and send back) voting payments here
73     function ()
74     onlyState(State.VOTING_RUNNING)
75     payable {
76         uint bonusVoted;
77         uint bonus = PRESALE_CONTRACT.balances(msg.sender);
78         assert (bonus > 0); // only presaler allowed in.
79         if (msg.value > 1 ether || !msg.sender.send(msg.value)) throw;
80         if (rawVotes[msg.sender] == 0) {
81             voters.push(msg.sender);
82             stakeVoted_Eth += uint16(bonus / 1 ether);
83         } else {
84             //clear statistik related to old voting state for this sender
85             bonusVoted           = votedPerCent(msg.sender) * bonus / 100;
86             stakeWaived_Eth     -= uint16((bonus - bonusVoted) / 1 ether);
87             stakeConfirmed_Eth  -= uint16(bonusVoted / 1 ether);
88         }
89         //special treatment for 0-ether payment
90         rawVotes[msg.sender] = msg.value > 0 ? msg.value : 1 wei;
91 
92         bonusVoted           = votedPerCent(msg.sender) * bonus / 100;
93         stakeWaived_Eth     += uint16((bonus - bonusVoted) / 1 ether);
94         stakeConfirmed_Eth  += uint16(bonusVoted / 1 ether);
95 
96         stakeRemainingToVote_Eth = uint16((TOTAL_BONUS_SUPPLY_ETH - stakeConfirmed_Eth)/1 ether);
97 
98     }
99 
100     function votersLen() external returns (uint) { return voters.length; }
101 
102     /// @notice start voting at `startBlockNr` for `durationHrs`.
103     /// Restricted for owner only.
104     /// @param startBlockNr block number to start voting; starts immediatly if less than current block number.
105     /// @param durationHrs voting duration (from now!); at least 1 hour.
106     function startVoting(uint startBlockNr, uint durationHrs) onlyOwner {
107         VOTING_START_BLOCKNR = max(block.number, startBlockNr);
108         VOTING_END_TIME = now + max(durationHrs,1) * 1 hours;
109     }
110 
111     function setOwner(address newOwner) onlyOwner { owner = newOwner; }
112 
113     /// @notice returns current voting result for given address in percent.
114     /// @param voter balance holder address.
115     function votedPerCent(address voter) constant public returns (uint) {
116         var rawVote = rawVotes[voter];
117         if (rawVote < MAX_AMOUNT_EQU_0_PERCENT) return 0;
118         else if (rawVote >= MIN_AMOUNT_EQU_100_PERCENT) return 100;
119         else return rawVote * 100 / 1 ether;
120     }
121 
122     /// @notice return voting remaining time (hours, minutes).
123     function votingEndsInHHMM() constant returns (uint8, uint8) {
124         var tsec = VOTING_END_TIME - now;
125         return VOTING_END_TIME==0 ? (0,0) : (uint8(tsec / 1 hours), uint8(tsec % 1 hours / 1 minutes));
126     }
127 
128     function currentState() internal constant returns (State) {
129         if (VOTING_START_BLOCKNR == 0 || block.number < VOTING_START_BLOCKNR) {
130             return State.BEFORE_START;
131         } else if (now <= VOTING_END_TIME) {
132             return State.VOTING_RUNNING;
133         } else {
134             return State.CLOSED;
135         }
136     }
137 
138     /// @notice returns current state of the voting.
139     function state() public constant returns(string) {
140         return stateNames[uint(currentState())];
141     }
142 
143     function max(uint a, uint b) internal constant returns (uint maxValue) { return a>b ? a : b; }
144 
145     modifier onlyState(State state) {
146         if (currentState()!=state) throw;
147         _;
148     }
149 
150     modifier onlyOwner() {
151         if (msg.sender!=owner) throw;
152         _;
153     }
154 
155 }//contract