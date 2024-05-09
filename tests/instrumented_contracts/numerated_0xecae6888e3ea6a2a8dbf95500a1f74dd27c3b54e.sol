1 contract dEthereumlotteryNet {
2 	/*
3 		dEthereumlotteryNet
4 		Coded by: iFA
5 		http://d.ethereumlottery.net
6 		ver: 2.1.1
7 	*/
8 	
9 	/*
10 		Vars
11 	*/
12 	address private owner;
13 	uint private constant fee = 5;
14 	uint private constant investorFee = 50;
15 	uint private constant prepareBlockDelay = 4;
16 	uint private constant rollLossBlockDelay = 30;
17 	uint private constant investUnit = 1 ether;
18 	uint private constant extraRate = 130;
19 	uint private constant minimumRollPrice = 10 finney;
20 	uint private constant investMinDuration = 1 days;
21 	uint private constant BestRollRate = 26;
22 	
23     bool public ContractEnabled = true;
24 	uint public Jackpot;
25 	uint public RollCount;
26 	uint public JackpotHits;
27 	
28 	uint private ContractDisabledBlock;
29 	uint private jackpot_;
30 	uint private extraJackpot_;
31 	uint private feeValue;
32 	uint private playersPot;
33 	
34 	struct rolls_s {
35 		uint blockNumber;
36 		bytes32 extraHash;
37 		bool valid;
38 		uint value;
39 		uint game;
40 		uint id;
41 	}
42 	
43 	mapping(address => rolls_s[]) private players;
44 	
45 	struct investors_s {
46 		address owner;
47 		uint value;
48 		uint balance;
49 		bool live;
50 		bool valid;
51 		uint timestamp;
52 	}
53 	
54 	investors_s[] private investors;
55 	
56 	string constant public Information = "http://d.ethereumlottery.net";
57 	
58 	/*
59 		Deploy
60 	*/
61 	function dEthereumlotteryNet() {
62 		owner = msg.sender;
63 		investors.length = 1;
64 	}
65 	
66 	/* 
67 		Constans functions
68 	*/
69 	function ChanceOfWinning(uint Value) constant returns(uint Rate, uint Bet) {
70 	    if (jackpot_ == 0) {
71 	        Rate = 0;
72 	        Bet = 0;
73 	        return;
74 	    }
75 		if (Value < minimumRollPrice) {
76 			Value = minimumRollPrice;
77 		}
78 		Rate = getRate(Value);
79 		Bet = getRealBet(Rate);
80 		while (Value < Bet) {
81 		    Rate++;
82 		    Bet = getRealBet(Rate);
83 		}
84 		if (Rate < BestRollRate) { 
85 		    Rate = BestRollRate;
86 		    Bet = getRealBet(Rate);
87         }
88 	}
89 	function BetPriceLimit() constant returns(uint min,uint max) {
90 		min = minimumRollPrice;
91 		max = getRealBet(BestRollRate);
92 	}
93 	function Investors(address Address) constant returns(uint Investment, uint Balance, bool Live) {
94 		uint InvestorID = getInvestorByAddress(Address);
95 		if (InvestorID == 0 || ! investors[InvestorID].valid) {
96 			Investment = 0;
97 			Balance = 0;
98 			Live = false;
99 		}
100 		Investment = investors[InvestorID].value;
101 		Balance = investors[InvestorID].balance;
102 		Live = investors[InvestorID].live;
103 	}
104 	
105 	/*
106 		External functions
107 	*/
108 	/* Fallback */
109 	function () {
110 		PrepareRoll(0);
111 	}
112 	/* For Investors */
113 	function Invest() OnlyEnabled external {
114 		uint value_ = msg.value;
115 		if (value_ < investUnit) { throw; }
116 		if (value_ % investUnit > 0) { 
117 			if ( ! msg.sender.send(value_ % investUnit)) { throw; } 
118 			value_ = value_ - (value_ % investUnit);
119 		}
120 		uint InvestorID = getInvestorByAddress(msg.sender);
121 		if (InvestorID == 0) {
122 			InvestorID = investors.length;
123 			investors.length++;
124 		}
125 		if (investors[InvestorID].valid && investors[InvestorID].live) {
126 			investors[InvestorID].value += value_;
127 		} else {
128 			investors[InvestorID].value = value_;
129 		}
130 		investors[InvestorID].timestamp = now + investMinDuration;
131 		investors[InvestorID].valid = true;
132 		investors[InvestorID].live = true;
133 		investors[InvestorID].owner = msg.sender;
134 		jackpot_ += value_;
135 		setJackpot();
136 	}
137 	function GetMyInvestmentBalance() external noEther {
138 		uint InvestorID = getInvestorByAddress(msg.sender);
139 		if (InvestorID == 0) { throw; }
140 		if ( ! investors[InvestorID].valid) { throw; }
141 		if (investors[InvestorID].balance == 0) { throw; }
142 		if ( ! msg.sender.send( investors[InvestorID].balance )) { throw; }
143 		investors[InvestorID].balance = 0;
144 	}
145 	function CancelMyInvestment() external noEther {
146 		uint InvestorID = getInvestorByAddress(msg.sender);
147 		if (InvestorID == 0) { throw; }
148 		if ( ! investors[InvestorID].valid) { throw; }
149 		if (investors[InvestorID].timestamp > now && ContractEnabled) { throw; }
150 		uint balance_;
151 		if (investors[InvestorID].live) {
152 			jackpot_ -= investors[InvestorID].value;
153 			balance_ = investors[InvestorID].value;
154 			setJackpot();
155 		}
156 		if (investors[InvestorID].balance > 0) {
157 			balance_ += investors[InvestorID].balance;
158 		}
159 		if ( ! msg.sender.send( balance_ )) { throw; }
160 		delete investors[InvestorID];
161 	}
162 	/* For Players */
163 	function DoRoll() external noEther {
164 		uint value_;
165 		bool found;
166 		for ( uint a=0 ; a < players[msg.sender].length ; a++ ) {
167 			if (players[msg.sender][a].valid) {
168 			    if (players[msg.sender][a].blockNumber+rollLossBlockDelay <= block.number) {
169 			        uint feeValue_ = players[msg.sender][a].value/2;
170 			        feeValue += feeValue_;
171 			        investorAddFee(players[msg.sender][a].value - feeValue_);
172 					playersPot -= players[msg.sender][a].value;
173 					DoRollEvent(msg.sender, players[msg.sender][a].value, players[msg.sender][a].id, false, true, false, false, 0, 0, 0);
174 					delete players[msg.sender][a];
175 					found = true;
176 					continue;
177 			    }
178 				if ( ! ContractEnabled || jackpot_ == 0 || players[msg.sender][a].game != JackpotHits) {
179 					value_ += players[msg.sender][a].value;
180 					playersPot -= players[msg.sender][a].value;
181 					DoRollEvent(msg.sender, players[msg.sender][a].value, players[msg.sender][a].id, true, false, false, false, 0, 0, 0);
182 					delete players[msg.sender][a];
183 					found = true;
184 					continue;
185 				}
186 				if (players[msg.sender][a].blockNumber < block.number) {
187 					value_ += makeRoll(a);
188 					playersPot -= players[msg.sender][a].value;
189 					delete players[msg.sender][a];
190 					found = true;
191 					continue;
192 				}
193 			}
194 		}
195 		if ( ! found) { throw; }
196 		if (value_ > 0) { if ( ! msg.sender.send(value_)) { throw; } }
197 	}
198 	function PrepareRoll(uint seed) OnlyEnabled {
199 		if (msg.value < minimumRollPrice) { throw; }
200 		if (jackpot_ == 0) { throw; }
201 		uint _rate;
202 		uint _realBet;
203 		(_rate, _realBet) = ChanceOfWinning(msg.value);
204 		if (_realBet > msg.value) { throw; }
205 		if (msg.value-_realBet > 0) {
206 			if ( ! msg.sender.send( msg.value-_realBet )) { throw; }
207 		}
208 		for (uint a = 0 ; a < players[msg.sender].length ; a++) {
209 			if ( ! players[msg.sender][a].valid) {
210 				prepareRoll( a, _realBet, seed );
211 				return;
212 			}
213 		}
214 		players[msg.sender].length++;
215 		prepareRoll( players[msg.sender].length-1, _realBet, seed );
216 	}
217 	/* For Owner */
218 	function OwnerCloseContract() external OnlyOwner noEther {
219 		if ( ! ContractEnabled) {
220 		    if (ContractDisabledBlock < block.number) {
221 				if (playersPot == 0) { throw; }
222 				if ( ! msg.sender.send( playersPot )) { throw; }
223 				playersPot = 0;
224 		    }
225 		} else {
226     		ContractEnabled = false;
227     		ContractDisabledBlock = block.number+rollLossBlockDelay;
228 			ContractDisabled(ContractDisabledBlock);
229     		feeValue += extraJackpot_;
230     		extraJackpot_ = 0;
231 		}
232 	}
233 	function OwnerGetFee() external OnlyOwner noEther {
234 		if (feeValue == 0) { throw; }
235 		if ( ! owner.send(feeValue)) { throw; }
236 		feeValue = 0;
237 	}
238 	
239 	/*
240 		Private functions
241 	*/
242 	function setJackpot() private {
243 		Jackpot = extraJackpot_ + jackpot_;
244 	}
245 	function makeRoll(uint id) private returns(uint win) {
246 		uint feeValue_ = players[msg.sender][id].value * fee / 100 ;
247 		feeValue += feeValue_;
248 		uint investorFee_ = players[msg.sender][id].value * investorFee / 100;
249 		investorAddFee(investorFee_);
250 		extraJackpot_ += players[msg.sender][id].value - feeValue_ - investorFee_;
251 		setJackpot();
252 		bytes32 hash_ = players[msg.sender][id].extraHash;
253 		for ( uint a = 1 ; a <= prepareBlockDelay ; a++ ) {
254 			hash_ = sha3(hash_, block.blockhash(players[msg.sender][id].blockNumber - prepareBlockDelay+a));
255 		}
256 		uint _rate = getRate(players[msg.sender][id].value);
257 		uint bigNumber = uint64(hash_);
258 		if (bigNumber % _rate == 0 ) {
259 			win = Jackpot;
260 			for ( a=1 ; a < investors.length ; a++ ) {
261 				investors[a].live = false;
262 			}
263 			JackpotHits++;
264 			extraJackpot_ = 0;
265 			jackpot_ = 0;
266 			Jackpot = 0;
267 			DoRollEvent(msg.sender, win, players[msg.sender][id].id, false, false, false, true, bigNumber, _rate, bigNumber % _rate);
268 		} else {
269 			DoRollEvent(msg.sender, players[msg.sender][id].value, players[msg.sender][id].id, false, false, true, false, bigNumber, _rate, bigNumber % _rate);
270 		}
271 	}
272 	function investorAddFee(uint value) private {
273 		bool done;
274 		for ( uint a=1 ; a < investors.length ; a++ ) {
275 			if (investors[a].live && investors[a].valid) {
276 				investors[a].balance += value * investors[a].value / jackpot_;
277 				done = true;
278 			}
279 		}
280 		if ( ! done) {
281 			feeValue += value;
282 		}
283 	}
284 	function prepareRoll(uint rollID, uint bet, uint seed) private {
285 		RollCount++;
286 		players[msg.sender][rollID].blockNumber = block.number + prepareBlockDelay;
287 		players[msg.sender][rollID].extraHash = sha3(RollCount, now, seed);
288 		players[msg.sender][rollID].valid = true;
289 		players[msg.sender][rollID].value = bet;
290 		players[msg.sender][rollID].game = JackpotHits;
291 		players[msg.sender][rollID].id = RollCount;
292 		playersPot += bet;
293 		PrepareRollEvent(msg.sender, players[msg.sender][rollID].blockNumber, players[msg.sender][rollID].value, players[msg.sender][rollID].id);
294 	}
295 	
296 	/*
297 		Internal functions
298 	*/	
299 	function getRate(uint value) internal returns(uint){
300 		return jackpot_ * 1 ether / value * 100 / investorFee * extraRate / 100 / 1 ether;
301 	}
302 	function getRealBet(uint rate) internal returns (uint) {
303 		return jackpot_ * 1 ether / ( rate * 1 ether * investorFee / extraRate);
304 	}
305 	function getInvestorByAddress(address Address) internal returns (uint id) {
306 		for ( id=1 ; id < investors.length ; id++ ) {
307 			if (investors[id].owner == Address) {
308 				return;
309 			}
310 		}
311 		return 0;
312 	}
313 	
314 	/*
315 		Events
316 	*/	
317 	event DoRollEvent(address Player, uint Value, uint RollID, bool Refund, bool LostBet, bool LossRoll, bool WinRoll, uint BigNumber, uint Rate, uint RollResult);
318 	event PrepareRollEvent(address Player, uint Block, uint Bet, uint RollID);
319 	event ContractDisabled(uint LossAllBetBlockNumber);
320 	
321 	/*
322 		Modifiers
323 	*/
324 	modifier noEther() { if (msg.value > 0) { throw; } _ }
325 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
326 	modifier OnlyEnabled() { if ( ! ContractEnabled) { throw; } _ }
327 }