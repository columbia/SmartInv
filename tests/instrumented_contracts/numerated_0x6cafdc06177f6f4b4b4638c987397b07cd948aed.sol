1 contract JackPot {
2     address public host;
3 	uint minAmount;
4     uint[] public contributions;
5     address[] public contributors;
6 	uint public numPlayers;
7 	uint public nextDraw;
8 	bytes32 public seedHash;
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
19     uint recentWinsCount = 10;
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
48         host = msg.sender;
49 		seedHash = sha3('aaaa');
50 		minAmount = 10 * 1 finney;
51         recentWinsCount = 10;
52 		nextDraw = 1234;
53     }
54 
55     function() {
56         addToContribution();
57     }
58 
59     function addToContribution() {
60         addValueToContribution(msg.value);
61     }
62 
63     function addValueToContribution(uint value) internal {
64         // First, make sure this is a valid transaction.
65         if(value < minAmount) throw;
66 	    uint i;
67         for (i=0; i < numPlayers; i++) {
68 			if (contributors[i] == msg.sender) { // Already contributed?
69 				break;
70 			}
71 		}
72 		
73 		if(i == numPlayers) { // Did not find sender already in the list
74 			insert_contribution(msg.sender, value);
75         } else {
76 			contributions[i]+= value; // Update amount
77 		}
78 		
79 		random = sha3(random, block.blockhash(block.number - 1));		
80     }
81 	
82 	//drawPot triggered from Host after time has passed or pot is matured.
83 	function drawPot(string seed, string newSeed) {
84 		if(msg.sender != host) throw;
85 		if (sha3(seed) == seedHash) {
86 			
87 			// Initialize seedHash for next draw
88 			seedHash = sha3(newSeed);
89 			// Choose a winner using the seed as random
90 			uint winner_index = selectWinner(seed);
91 
92 			// Send the developer a 1% fee
93 			host.send(this.balance / 100);
94 			
95 			uint amountWon = this.balance; 
96 			
97 			// Send the winner the remaining balance on the contract.
98 			contributors[winner_index].send(this.balance);
99 			
100 			// Make a note that someone won, then start all over!
101 			recordWin(winner_index, amountWon);
102 
103 			reset();
104 			nextDraw = now + 7 days;	
105 
106 		}
107 	}
108 
109 	function setDrawDate(uint _newDraw) {
110 		if(msg.sender != host) throw;
111 		nextDraw = _newDraw;
112 	}
113 	
114 	
115     function selectWinner(string seed) internal returns (uint winner_index) {
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