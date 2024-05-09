1 contract JackPot {
2     address public host;
3 	uint minAmount;
4     uint[] public contributions;
5     address[] public contributors;
6 	uint public numPlayers = 0;
7 	uint public nextDraw;
8 	bytes32 seedHash;
9 	bytes32 random;	
10 
11     struct Win {
12         address winner;
13         uint timestamp;
14         uint contribution;
15 		uint amountWon;
16     }
17 
18     Win[] public recentWins;
19     uint recentWinsCount;
20 	
21 	function insert_contribution(address addr, uint value) internal {
22 		// check if array needs extending
23 		if(numPlayers == contributions.length) {
24 			// extend the arrays
25 			contributions.length += 1;
26 			contributors.length += 1;
27 		}
28 		contributions[numPlayers] = value;
29 		contributors[numPlayers++] = addr;
30 	}
31 	
32 	function getContributions(address addr) constant returns (uint) {
33         uint i;
34         for (i=0; i < numPlayers; i++) {
35 			if (contributors[i] == addr) { // if in the list already
36 				break;
37 			}
38 		}
39 		
40 		if(i == numPlayers) { // Did not find sender already in the list
41             return 0;
42         } else {
43 			return contributions[i];
44 		}
45     }
46 	
47 	function JackPot() {
48 
49         host = msg.sender;
50 		seedHash = sha3(1111);
51 		minAmount = 10 * 1 finney;
52         recentWinsCount = 10;
53 		nextDraw = 1234; // Initialize to start time of the block
54     }
55 
56     function() {
57         addToContribution();
58     }
59 
60     function addToContribution() {
61         addValueToContribution(msg.value);
62     }
63 
64     function addValueToContribution(uint value) internal {
65         // First, make sure this is a valid transaction.
66         if(value < minAmount) throw;
67 	    uint i;
68         for (i=0; i < numPlayers; i++) {
69 			if (contributors[i] == msg.sender) { // Already contributed?
70 				break;
71 			}
72 		}
73 		
74 		if(i == numPlayers) { // Did not find sender already in the list
75 			insert_contribution(msg.sender, value);
76         } else {
77 			contributions[i]+= value; // Update amount
78 		}
79 		
80 		random = sha3(random, block.blockhash(block.number - 1));		
81     }
82 	
83 	//drawPot triggered from Host after time has passed or pot is matured.
84 	function drawPot(bytes32 seed, bytes32 newSeed) {
85 		if(msg.sender != host) throw;
86 		
87 		// check that seed given is the same as the seedHash so operators of jackpot can not cheat 
88 		if (sha3(seed) == seedHash) {
89 			seedHash = sha3(newSeed);
90 			// Choose a winner using the seed as random
91             uint winner_index = selectWinner(seed);
92 
93             // Send the developer a 1% fee
94             host.send(this.balance / 100);
95 			
96 			uint amountWon = this.balance; 
97 			
98             // Send the winner the remaining balance on the contract.
99             contributors[winner_index].send(this.balance);
100 			
101 			// Make a note that someone won, then start all over!
102             recordWin(winner_index, amountWon);
103 
104             reset();
105 			nextDraw = now + 7 days;	
106 		}
107 	}
108 
109 	function setDrawDate(uint _newDraw) {
110 		if(msg.sender != host) throw;
111 		nextDraw = _newDraw;
112 	}
113 	
114 	
115     function selectWinner(bytes32 seed) internal returns (uint winner_index) {
116 
117         uint semirandom = uint(sha3(random, seed)) % this.balance;
118         for(uint i = 0; i < numPlayers; ++i) {
119             if(semirandom < contributions[i]) return i;
120             semirandom -= contributions[i];
121         }
122     }
123 
124     function recordWin(uint winner_index, uint amount) internal {
125         if(recentWins.length < recentWinsCount) {
126             recentWins.length++;
127         } else {
128             // Already at capacity for the number of winners to remember.
129             // Forget the oldest one by shifting each entry 'left'
130             for(uint i = 0; i < recentWinsCount - 1; ++i) {
131                 recentWins[i] = recentWins[i + 1];
132             }
133         }
134 
135         recentWins[recentWins.length - 1] = Win(contributors[winner_index], block.timestamp, contributions[winner_index], amount);
136     }
137 
138     function reset() internal {
139         // Clear the lists with min gas after the draw.
140 		numPlayers = 0;
141     }
142 
143 
144     /* This should only be needed if a bug is discovered
145     in the code and the contract must be destroyed. */
146     function destroy() {
147         if(msg.sender != host) throw;
148 
149         // Refund everyone's contributions.
150         for(uint i = 0; i < numPlayers; ++i) {
151             contributors[i].send(contributions[i]);
152         }
153 
154 		reset();
155         selfdestruct(host);
156     }
157 }