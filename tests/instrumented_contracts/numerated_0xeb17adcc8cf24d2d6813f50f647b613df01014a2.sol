1 contract dEthereumlotteryNet {
2 	/*
3 		dEthereumlotteryNet
4 		Coded by: iFA
5 		https://d.ethereumlottery.net
6 		ver: 1.0.0
7 	*/
8 	address private owner;
9 	uint private constant fee = 5;
10 	uint private constant investorFee = 50;
11 	uint private constant prepareBlockDelay = 4;
12 	uint private constant rollLossBlockDelay = 30;
13 	uint private constant investUnit = 1 ether;
14 	uint private constant extraDifficulty = 130;
15 	uint private constant minimumRollPrice = 10 finney;
16 	uint private constant minimumRollDiv = 10;
17 	uint private constant difficultyMultipler = 1000000;
18 	uint private constant investMinDuration = 1 days;
19 	
20     bool public ContractEnabled = true;
21     uint public ContractDisabledBlock;
22 	uint public Jackpot;
23 	uint public RollCount;
24 	uint public JackpotHits;
25 	
26 	uint private jackpot_;
27 	uint private extraJackpot_;
28 	uint private feeValue;
29 	
30 	struct rolls_s {
31 		uint blockNumber;
32 		bytes32 extraHash;
33 		bool valid;
34 		uint value;
35 		uint game;
36 	}
37 	
38 	mapping(address => rolls_s[]) private players;
39 	
40 	struct investors_s {
41 		address owner;
42 		uint value;
43 		uint balance;
44 		bool live;
45 		bool valid;
46 		uint timestamp;
47 	}
48 	
49 	investors_s[] investors;
50 	
51 	string constant public Information = "https://d.ethereumlottery.net";
52 	
53 	function ChanceOfWinning(uint Bet) constant returns(uint Rate) {
54 		Rate = getDifficulty(Bet);
55 		if (Bet < minimumRollPrice) { Rate = 0; }
56 		if (jackpot_/minimumRollDiv < Bet) { Rate = 0; }
57 	}
58 	function BetPriceLimit() constant returns(uint min,uint max) {
59 		min = minimumRollPrice;
60 		max = jackpot_/minimumRollDiv;
61 	}
62 	function Investors(uint id) constant returns(address Owner, uint Investment, uint Balance, bool Live) {
63 		if (id < investors.length) {
64 			Owner = investors[id].owner;
65 			Investment = investors[id].value;
66 			Balance = investors[id].balance;
67 			Live = investors[id].live;
68 		} else {
69 			Owner = 0;
70 			Investment = 0;
71 			Balance = 0;
72 			Live = false;
73 		}
74 	}
75 	function dEthereumlotteryNet() {
76 		owner = msg.sender;
77 	}
78 	function Invest() OnlyEnabled external {
79 		uint value_ = msg.value;
80 		if (value_ < investUnit) { throw; }
81 		if (value_ % investUnit > 0) { 
82 			if (msg.sender.send(value_ % investUnit) == false) { throw; } 
83 			value_ = value_ - (value_ % investUnit);
84 		}
85 		for ( uint a=0 ; a < investors.length ; a++ ) {
86 			if (investors[a].valid == false) {
87 				newInvest(a,msg.sender,value_);
88 				return;
89 			}
90 		}
91 		investors.length++;
92 		newInvest(investors.length-1,msg.sender,value_);
93 	}
94 	function newInvest(uint investorsID, address investor, uint value) private {
95 		investors[investorsID].owner = investor;
96 		investors[investorsID].value = value;
97 		investors[investorsID].balance = 0;
98 		investors[investorsID].valid = true;
99 		investors[investorsID].live = true;
100 		investors[investorsID].timestamp = now + investMinDuration;
101 		jackpot_ += value;
102 		setJackpot();
103 	}
104 	function GetMyInvestFee() external {
105 		reFund();
106 		uint balance_;
107 		for ( uint a=0 ; a < investors.length ; a++ ) {
108 			if (investors[a].owner == msg.sender && investors[a].valid == true) {
109 				balance_ = investors[a].balance;
110 				investors[a].valid = false;
111 			}
112 		}
113 		if (balance_ > 0) { if (msg.sender.send(balance_) == false) { throw; } }
114 	}
115 	function CancelMyInvest() external {
116 		reFund();
117 		uint balance_;
118 		for ( uint a=0 ; a < investors.length ; a++ ) {
119 			if (investors[a].owner == msg.sender && investors[a].valid == true && investors[a].timestamp < now) {
120 				if (investors[a].live == true) {
121 					balance_ = investors[a].value + investors[a].balance;
122 					jackpot_ -= investors[a].value;
123 					delete investors[a];
124 				} else {
125 					balance_ = investors[a].balance;
126 					delete investors[a];
127 				}
128 			}
129 		}
130 		setJackpot();
131 		if (balance_ > 0) { if (msg.sender.send(balance_) == false) { throw; } }
132 	}
133 	function setJackpot() private {
134 		Jackpot = extraJackpot_ + jackpot_;
135 	}
136 	function DoRoll() external {
137 		reFund();
138 		uint value_;
139 		bool found;
140 		for ( uint a=0 ; a < players[msg.sender].length ; a++ ) {
141 			if (players[msg.sender][a].valid == true) {
142 			    if (players[msg.sender][a].blockNumber+rollLossBlockDelay <= block.number) {
143 			        uint feeValue_ = players[msg.sender][a].value/2;
144 			        feeValue += feeValue_;
145 			        investorAddFee(players[msg.sender][a].value - feeValue_);
146 					delete players[msg.sender][a];
147 					found = true;
148 					continue;
149 			    }
150 				if (ContractEnabled == false || jackpot_ == 0 || players[msg.sender][a].game != JackpotHits) {
151 					value_ += players[msg.sender][a].value;
152 					delete players[msg.sender][a];
153 					found = true;
154 					continue;
155 				}
156 				if (players[msg.sender][a].blockNumber < block.number) {
157 					value_ += makeRoll(a);
158 					delete players[msg.sender][a];
159 					found = true;
160 					continue;
161 				}
162 			}
163 		}
164 		if (value_ > 0) { if (msg.sender.send(value_) == false) { throw; } }
165 		if (found == false) { throw; }
166 	}
167 	event RollEvent(address Player,uint Difficulty, uint Result, uint Number, uint Win);
168 	function makeRoll(uint id) private returns(uint win) {
169 		uint feeValue_ = players[msg.sender][id].value * fee / 100 ;
170 		feeValue += feeValue_;
171 		uint investorFee_ = players[msg.sender][id].value * investorFee / 100;
172 		investorAddFee(investorFee_);
173 		extraJackpot_ += players[msg.sender][id].value - feeValue_ - investorFee_;
174 		setJackpot();
175 		bytes32 hash_ = players[msg.sender][id].extraHash;
176 		for ( uint a = 1 ; a <= prepareBlockDelay ; a++ ) {
177 			hash_ = sha3(hash_, block.blockhash(players[msg.sender][id].blockNumber - prepareBlockDelay+a));
178 		}
179 		uint difficulty_ = getDifficulty(players[msg.sender][id].value);
180 		uint bigNumber = uint64(hash_);
181 		if (bigNumber * difficultyMultipler % difficulty_ == 0) {
182 			win = Jackpot;
183 			for ( a=0 ; a < investors.length ; a++ ) {
184 				investors[a].live = false;
185 			}
186 			JackpotHits++;
187 			extraJackpot_ = 0;
188 			jackpot_ = 0;
189 			Jackpot = 0;
190 		}
191 		RollEvent(msg.sender, difficulty_, bigNumber * difficultyMultipler % difficulty_, bigNumber * difficultyMultipler,win);
192 		delete players[msg.sender][id];
193 	}
194 	function getDifficulty(uint value) private returns(uint){
195 		return jackpot_ * difficultyMultipler / value * 100 / investorFee * extraDifficulty / 100;
196 	}
197 	function investorAddFee(uint value) private {
198 		for ( uint a=0 ; a < investors.length ; a++ ) {
199 			if (investors[a].live == true) {
200 				investors[a].balance += value * investors[a].value / jackpot_;
201 			}
202 		}
203 	}
204 	event PrepareRollEvent(address Player, uint Block);
205 	function prepareRoll(uint rollID, uint seed) private {
206 		players[msg.sender][rollID].blockNumber = block.number + prepareBlockDelay;
207 		players[msg.sender][rollID].extraHash = sha3(RollCount, now, seed);
208 		players[msg.sender][rollID].valid = true;
209 		players[msg.sender][rollID].value = msg.value;
210 		players[msg.sender][rollID].game = JackpotHits;
211 		RollCount++;
212 		PrepareRollEvent(msg.sender, players[msg.sender][rollID].blockNumber);
213 	}
214 	function PrepareRoll(uint seed) OnlyEnabled {
215 		if (msg.value < minimumRollPrice) { throw; }
216 		if (jackpot_/minimumRollDiv < msg.value) { throw; }
217 		if (jackpot_ == 0) { throw; }
218 		for (uint a = 0 ; a < players[msg.sender].length ; a++) {
219 			if (players[msg.sender][a].valid == false) {
220 				prepareRoll(a,seed);
221 				return;
222 			}
223 		}
224 		players[msg.sender].length++;
225 		prepareRoll(players[msg.sender].length-1,seed);
226 	}
227 	function () {
228 		PrepareRoll(0);
229 	}
230 	function reFund() private { if (msg.value > 0) { if (msg.sender.send(msg.value) == false) { throw; } } }
231 	function OwnerCloseContract() external OnlyOwner {
232 		reFund();
233 		if (ContractEnabled == false) {
234 		    if (ContractDisabledBlock < block.number) {
235 		        uint balance_ = this.balance;
236 		        for ( uint a=0 ; a < investors.length ; a++ ) {
237 		            balance_ -= investors[a].balance;
238 		        }
239 		        if (balance_ > 0) {
240                     if (msg.sender.send(balance_) == false) { throw; }
241 		        }
242 		    }
243 		} else {
244     		ContractEnabled = false;
245     		ContractDisabledBlock = block.number+rollLossBlockDelay;
246     		feeValue += extraJackpot_;
247     		extraJackpot_ = 0;
248 		}
249 	}
250 	function OwnerGetFee() external OnlyOwner {
251 		reFund();
252 		if (feeValue == 0) { throw; }
253 		if (owner.send(feeValue) == false) { throw; }
254 		feeValue = 0;
255 	}
256 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
257 	modifier OnlyEnabled() { if (!ContractEnabled) { throw; } _	}
258 }