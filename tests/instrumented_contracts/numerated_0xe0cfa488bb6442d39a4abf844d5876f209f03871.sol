1 contract dEthereumlotteryNet {
2 	/*
3 		dEthereumlotteryNet
4 		Coded by: iFA
5 		https://d.ethereumlottery.net
6 		ver: 2.0.0
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
24     uint public ContractDisabledBlock;
25 	uint public Jackpot;
26 	uint public RollCount;
27 	uint public JackpotHits;
28 	
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
40 	}
41 	
42 	mapping(address => rolls_s[]) private players;
43 	
44 	struct investors_s {
45 		address owner;
46 		uint value;
47 		uint balance;
48 		bool live;
49 		bool valid;
50 		uint timestamp;
51 	}
52 	
53 	investors_s[] investors;
54 	
55 	string constant public Information = "https://d.ethereumlottery.net";
56 	
57 	/*
58 		Deploy
59 	*/
60 	function dEthereumlotteryNet() {
61 		owner = msg.sender;
62 	}
63 	
64 	/* 
65 		Constans functions
66 	*/
67 	function ChanceOfWinning(uint Value) constant returns(uint Rate, uint Bet) {
68 	    if (jackpot_ == 0) {
69 	        Rate = 0;
70 	        Bet = 0;
71 	        return;
72 	    }
73 		if (Value < minimumRollPrice) {
74 			Value = minimumRollPrice;
75 		}
76 		Rate = getRate(Value);
77 		Bet = getRealBet(Rate);
78 		if (Value < Bet) {
79 		    Rate++;
80 		    Bet = getRealBet(Rate);
81 		}
82 		if (Rate < BestRollRate) { 
83 		    Rate = BestRollRate;
84 		    Bet = getRealBet(Rate);
85         }
86 	}
87 	function BetPriceLimit() constant returns(uint min,uint max) {
88 		min = minimumRollPrice;
89 		max = getRealBet(BestRollRate);
90 	}
91 	function Investors(uint id) constant returns(address Owner, uint Investment, uint Balance, bool Live) {
92 		if (id < investors.length) {
93 			Owner = investors[id].owner;
94 			Investment = investors[id].value;
95 			Balance = investors[id].balance;
96 			Live = investors[id].live;
97 		} else {
98 			Owner = 0;
99 			Investment = 0;
100 			Balance = 0;
101 			Live = false;
102 		}
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
120 		for ( uint a=0 ; a < investors.length ; a++ ) {
121 			if ( ! investors[a].valid) {
122 				newInvest(a,msg.sender,value_);
123 				return;
124 			}
125 		}
126 		investors.length++;
127 		newInvest(investors.length-1,msg.sender,value_);
128 	}
129 	function GetMyInvestFee() external {
130 		reFund();
131 		uint balance_;
132 		for ( uint a=0 ; a < investors.length ; a++ ) {
133 			if (investors[a].owner == msg.sender && ! investors[a].valid) {
134 				balance_ = investors[a].balance;
135 				investors[a].valid = false;
136 			}
137 		}
138 		if (balance_ > 0) { if ( ! msg.sender.send(balance_)) { throw; } }
139 	}
140 	function CancelMyInvest() external {
141 		reFund();
142 		uint balance_;
143 		for ( uint a=0 ; a < investors.length ; a++ ) {
144 			if ((investors[a].owner == msg.sender && investors[a].valid)) {
145 			    if (investors[a].timestamp < now || ! ContractEnabled) {
146     				if (investors[a].live) {
147     					balance_ = investors[a].value + investors[a].balance;
148     					jackpot_ -= investors[a].value;
149     					delete investors[a];
150     				} else {
151     					balance_ = investors[a].balance;
152     					delete investors[a];
153     				}
154 			    }
155 			}
156 		}
157 		setJackpot();
158 		if (balance_ > 0) { if ( ! msg.sender.send(balance_)) { throw; } }
159 	}
160 	/* For Players */
161 	function DoRoll() external {
162 		reFund();
163 		uint value_;
164 		bool found;
165 		for ( uint a=0 ; a < players[msg.sender].length ; a++ ) {
166 			if (players[msg.sender][a].valid) {
167 			    if (players[msg.sender][a].blockNumber+rollLossBlockDelay <= block.number) {
168 			        uint feeValue_ = players[msg.sender][a].value/2;
169 			        feeValue += feeValue_;
170 			        investorAddFee(players[msg.sender][a].value - feeValue_);
171 					playersPot -= players[msg.sender][a].value;
172 					delete players[msg.sender][a];
173 					found = true;
174 					continue;
175 			    }
176 				if ( ! ContractEnabled || jackpot_ == 0 || players[msg.sender][a].game != JackpotHits) {
177 					value_ += players[msg.sender][a].value;
178 					playersPot -= players[msg.sender][a].value;
179 					delete players[msg.sender][a];
180 					found = true;
181 					continue;
182 				}
183 				if (players[msg.sender][a].blockNumber < block.number) {
184 					value_ += makeRoll(a);
185 					playersPot -= players[msg.sender][a].value;
186 					delete players[msg.sender][a];
187 					found = true;
188 					continue;
189 				}
190 			}
191 		}
192 		if (value_ > 0) { if (msg.sender.send(value_)) { throw; } }
193 		if ( ! found) { throw; }
194 	}
195 	function PrepareRoll(uint seed) OnlyEnabled {
196 		if (msg.value < minimumRollPrice) { throw; }
197 		if (jackpot_ == 0) { throw; }
198 		uint _rate = getRate(msg.value);
199 		uint _realBet = getRealBet(_rate);
200 		if (msg.value < _realBet) {
201 		    _rate++;
202 		    _realBet = getRealBet(_rate);
203 		}
204 		if (_rate < BestRollRate) { 
205 		    _rate = BestRollRate;
206 		    _realBet = getRealBet(_rate);
207         }
208 		if (msg.value-_realBet > 0) {
209 			if ( ! msg.sender.send( msg.value-_realBet )) { throw; }
210 		}
211 		for (uint a = 0 ; a < players[msg.sender].length ; a++) {
212 			if ( ! players[msg.sender][a].valid) {
213 				prepareRoll( a, _realBet, seed );
214 				return;
215 			}
216 		}
217 		players[msg.sender].length++;
218 		prepareRoll( players[msg.sender].length-1, _realBet, seed );
219 	}
220 	/* For Owner */
221 	function OwnerCloseContract() external OnlyOwner {
222 		reFund();
223 		if ( ! ContractEnabled) {
224 		    if (ContractDisabledBlock < block.number) {
225 		        uint balance_ = this.balance;
226 		        for ( uint a=0 ; a < investors.length ; a++ ) {
227 		            balance_ -= investors[a].balance;
228 		        }
229 		        if (balance_ > 0) {
230                     if ( ! msg.sender.send(balance_)) { throw; }
231 		        }
232 		    }
233 		} else {
234     		ContractEnabled = false;
235     		ContractDisabledBlock = block.number+rollLossBlockDelay;
236     		feeValue += extraJackpot_;
237     		extraJackpot_ = 0;
238 		}
239 	}
240 	function OwnerGetFee() external OnlyOwner {
241 		reFund();
242 		if (feeValue == 0) { throw; }
243 		if ( ! owner.send(feeValue)) { throw; }
244 		feeValue = 0;
245 	}
246 	
247 	/*
248 		Private functions
249 	*/
250 	function newInvest(uint investorsID, address investor, uint value) private {
251 		investors[investorsID].owner = investor;
252 		investors[investorsID].value = value;
253 		investors[investorsID].balance = 0;
254 		investors[investorsID].valid = true;
255 		investors[investorsID].live = true;
256 		investors[investorsID].timestamp = now + investMinDuration;
257 		jackpot_ += value;
258 		setJackpot();
259 	}
260 	function setJackpot() private {
261 		Jackpot = extraJackpot_ + jackpot_;
262 	}
263 	function makeRoll(uint id) private returns(uint win) {
264 		uint feeValue_ = players[msg.sender][id].value * fee / 100 ;
265 		feeValue += feeValue_;
266 		uint investorFee_ = players[msg.sender][id].value * investorFee / 100;
267 		investorAddFee(investorFee_);
268 		extraJackpot_ += players[msg.sender][id].value - feeValue_ - investorFee_;
269 		setJackpot();
270 		bytes32 hash_ = players[msg.sender][id].extraHash;
271 		for ( uint a = 1 ; a <= prepareBlockDelay ; a++ ) {
272 			hash_ = sha3(hash_, block.blockhash(players[msg.sender][id].blockNumber - prepareBlockDelay+a));
273 		}
274 		uint _rate = getRate(players[msg.sender][id].value);
275 		uint bigNumber = uint64(hash_);
276 		if (bigNumber % _rate == 0 ) {
277 			win = Jackpot;
278 			for ( a=0 ; a < investors.length ; a++ ) {
279 				investors[a].live = false;
280 			}
281 			JackpotHits++;
282 			extraJackpot_ = 0;
283 			jackpot_ = 0;
284 			Jackpot = 0;
285 		}
286 		RollEvent(msg.sender, _rate, bigNumber % _rate, bigNumber ,win);
287 		delete players[msg.sender][id];
288 	}
289 	function investorAddFee(uint value) private {
290 		bool done;
291 		for ( uint a=0 ; a < investors.length ; a++ ) {
292 			if (investors[a].live) {
293 				investors[a].balance += value * investors[a].value / jackpot_;
294 				done = true;
295 			}
296 		}
297 		if ( ! done) {
298 			feeValue += value;
299 		}
300 	}
301 	function reFund() private { if (msg.value > 0) { if ( ! msg.sender.send(msg.value)) { throw; } } }
302 	function prepareRoll(uint rollID, uint bet, uint seed) private {
303 		players[msg.sender][rollID].blockNumber = block.number + prepareBlockDelay;
304 		players[msg.sender][rollID].extraHash = sha3(RollCount, now, seed);
305 		players[msg.sender][rollID].valid = true;
306 		players[msg.sender][rollID].value = bet;
307 		players[msg.sender][rollID].game = JackpotHits;
308 		RollCount++;
309 		playersPot += bet;
310 		PrepareRollEvent(msg.sender, players[msg.sender][rollID].blockNumber, bet);
311 	}
312 	
313 	/*
314 		Internal functions
315 	*/	
316 	function getRate(uint value) internal returns(uint){
317 		return jackpot_ * 1000000 / value * 100 / investorFee * extraRate / 100 / 1000000;
318 	}
319 	function getRealBet(uint rate) internal returns (uint) {
320 		return jackpot_ * 1000000 / ( rate * 1000000 * investorFee / extraRate);
321 	}
322 	
323 	/*
324 		Events
325 	*/	
326 	event RollEvent(address Player, uint Rate, uint Result, uint Number, uint Win);
327 	event PrepareRollEvent(address Player, uint Block, uint Bet);
328 	
329 	/*
330 		Modifiders
331 	*/
332 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
333 	modifier OnlyEnabled() { if ( ! ContractEnabled) { throw; } _ }
334 }