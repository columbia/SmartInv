1 contract HonestDice {
2 	
3 	event Bet(address indexed user, uint blocknum, uint256 amount, uint chance);
4 	event Won(address indexed user, uint256 amount, uint chance);
5 	
6 	struct Roll {
7 		uint256 value;
8 		uint chance;
9 		uint blocknum;
10 		bytes32 secretHash;
11 		bytes32 serverSeed;
12 	}
13 	
14 	uint betsLocked;
15 	address owner;
16 	address feed;				   
17 	uint256 minimumBet = 1 * 1000000000000000000; // 1 Ether
18 	uint256 constant maxPayout = 5; // 5% of bankroll
19 	uint constant seedCost = 100000000000000000; // This is the cost of supplyin the server seed, deduct it;
20 	mapping (address => Roll) rolls;
21 	uint constant timeout = 20; // 5 Minutes
22 	
23 	function HonestDice() {
24 		owner = msg.sender;
25 		feed = msg.sender;
26 	}
27 	
28 	function roll(uint chance, bytes32 secretHash) {
29 		if (chance < 1 || chance > 255 || msg.value < minimumBet || calcWinnings(msg.value, chance) > getMaxPayout() || betsLocked != 0) { 
30 			msg.sender.send(msg.value); // Refund
31 			return;
32 		}
33 		rolls[msg.sender] = Roll(msg.value, chance, block.number, secretHash, 0);
34 		Bet(msg.sender, block.number, msg.value, chance);
35 	}
36 	
37 	function serverSeed(address user, bytes32 seed) {
38 		// The server calls this with a random seed
39 		if (msg.sender != feed) return;
40 		if (rolls[user].serverSeed != 0) return;
41 		rolls[user].serverSeed = seed;
42 	}
43 	
44 	function hashTo256(bytes32 hash) constant returns (uint _r) {
45 		// Returns a number between 0 - 255 from a hash
46 		return uint(hash) & 0xff;
47 	}
48 	
49 	function hash(bytes32 input) constant returns (uint _r) {
50 		// Simple sha3 hash. Not to be called via the blockchain
51 		return uint(sha3(input));
52 	}
53 	
54 	function isReady() constant returns (bool _r) {
55 		return isReadyFor(msg.sender);
56 	}
57 	
58 	function isReadyFor(address _user) constant returns (bool _r) {
59 		Roll r = rolls[_user];
60 		if (r.serverSeed == 0) return false;
61 		return true;
62 	}
63 	
64 	function getResult(bytes32 secret) constant returns (uint _r) {
65 		// Get the result number of the roll
66 		Roll r = rolls[msg.sender];
67 		if (r.serverSeed == 0) return;
68 		if (sha3(secret) != r.secretHash) return;
69 		return hashTo256(sha3(secret, r.serverSeed));
70 	}
71 	
72 	function didWin(bytes32 secret) constant returns (bool _r) {
73 		// Returns if the player won or not
74 		Roll r = rolls[msg.sender];
75 		if (r.serverSeed == 0) return;
76 		if (sha3(secret) != r.secretHash) return;
77 		if (hashTo256(sha3(secret, r.serverSeed)) < r.chance) { // Winner
78 			return true;
79 		}
80 		return false;
81 	}
82 	
83 	function calcWinnings(uint256 value, uint chance) constant returns (uint256 _r) {
84 		// 1% house edge
85 		return (value * 99 / 100) * 256 / chance;
86 	}
87 	
88 	function getMaxPayout() constant returns (uint256 _r) {
89 		return this.balance * maxPayout / 100;
90 	}
91 	
92 	function claim(bytes32 secret) {
93 		Roll r = rolls[msg.sender];
94 		if (r.serverSeed == 0) return;
95 		if (sha3(secret) != r.secretHash) return;
96 		if (hashTo256(sha3(secret, r.serverSeed)) < r.chance) { // Winner
97 			msg.sender.send(calcWinnings(r.value, r.chance) - seedCost);
98 			Won(msg.sender, r.value, r.chance);
99 		}
100 		
101 		delete rolls[msg.sender];
102 	}
103 	
104 	function canClaimTimeout() constant returns (bool _r) {
105 		Roll r = rolls[msg.sender];
106 		if (r.serverSeed != 0) return false;
107 		if (r.value <= 0) return false;
108 		if (block.number < r.blocknum + timeout) return false;
109 		return true;
110 	}
111 	
112 	function claimTimeout() {
113 		// Get your monies back if the server isn't responding with a seed
114 		if (!canClaimTimeout()) return;
115 		Roll r = rolls[msg.sender];
116 		msg.sender.send(r.value);
117 		delete rolls[msg.sender];
118 	}
119 	
120 	function getMinimumBet() constant returns (uint _r) {
121 		return minimumBet;
122 	}
123 	
124 	function getBankroll() constant returns (uint256 _r) {
125 		return this.balance;
126 	}
127 	
128 	function getBetsLocked() constant returns (uint _r) {
129 		return betsLocked;
130 	}
131 	
132 	function setFeed(address newFeed) {
133 		if (msg.sender != owner) return;
134 		feed = newFeed;
135 	}
136 	
137 	function lockBetsForWithdraw() {
138 		if (msg.sender != owner) return;
139 		uint betsLocked = block.number;
140 	}
141 	
142 	function unlockBets() {
143 		if (msg.sender != owner) return;
144 		uint betsLocked = 0;
145 	}
146 	
147 	function withdraw(uint amount) {
148 		if (msg.sender != owner) return;
149 		if (betsLocked == 0 || block.number < betsLocked + 5760) return;
150 		owner.send(amount);
151 	}
152 }