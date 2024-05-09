1 contract RandomInterface {
2 	function getRandom() returns (bytes32 hash) {}
3 }
4 contract WinnerDBInterface {
5 	function Winners(uint id) constant returns(uint date, address addr, uint value, uint rate, uint bet)  {}
6 	function newWinner(uint date, address addr, uint value, uint rate, uint bet) external returns (bool) {}
7 }
8 contract dEthereumlotteryNet {
9 	/*
10 		dEthereumlotteryNet
11 		Coded by: iFA
12 		http://d.ethereumlottery.net
13 		ver: 2.2.1
14 	*/
15 	
16 	/*
17 		Vars
18 	*/
19 	address private owner;
20 	address private winnersDB;
21 	address private randomAddr;
22 	uint private constant fee = 5;
23 	uint private constant investorFee = 70;
24 	uint private constant prepareBlockDelay = 4;
25 	uint private constant rollLossBlockDelay = 30;
26 	uint private constant investUnit = 1 ether;
27 	uint private constant extraRate = 130;
28 	uint private constant minimumRollPrice = 10 finney;
29 	uint private constant investMinDuration = 1 days;
30 	uint private constant BestRollRate = 100;
31 	
32     bool public ContractEnabled = true;
33 	uint public Jackpot;
34 	uint public RollCount;
35 	uint public JackpotHits;
36 	
37 	uint private ContractDisabledBlock;
38 	uint private jackpot_;
39 	uint private extraJackpot_;
40 	uint private feeValue;
41 	uint private playersPot;
42 	
43 	struct rolls_s {
44 		uint blockNumber;
45 		bytes32 extraHash;
46 		bool valid;
47 		uint value;
48 		uint game;
49 		uint id;
50 		uint sumInvest;
51 	}
52 	
53 	mapping(address => rolls_s[]) private players;
54 	
55 	struct investors_s {
56 		address owner;
57 		uint value;
58 		uint balance;
59 		bool live;
60 		bool valid;
61 		uint timestamp;
62 	}
63 	
64 	investors_s[] private investors;
65 	
66 	string constant public Information = "http://d.ethereumlottery.net";
67 	
68 	/*
69 		Deploy
70 	*/
71 	function dEthereumlotteryNet(address _winnersDB, address _oldcontract, address _randomAddr) {
72 		owner = msg.sender;
73 		investors.length++;
74 		winnersDB = _winnersDB;
75 		randomAddr = _randomAddr;
76 		if (_oldcontract != 0x0) {
77 			RollCount = dEthereumlotteryNet( _oldcontract ).RollCount();
78 			JackpotHits = dEthereumlotteryNet( _oldcontract ).JackpotHits();
79 		}
80 	}
81 	
82 	/* 
83 		Constans functions
84 	*/
85 	function ChanceOfWinning(uint Value) constant returns(uint Rate, uint Bet) {
86 	    if (jackpot_ == 0) {
87 	        Rate = 0;
88 	        Bet = 0;
89 	        return;
90 	    }
91 		if (Value < minimumRollPrice) {
92 			Value = minimumRollPrice;
93 		}
94 		Rate = getRate(Value);
95 		Bet = getRealBet(Rate);
96 		while (Value < Bet) {
97 		    Rate++;
98 		    Bet = getRealBet(Rate);
99 		}
100 		if (Rate < BestRollRate) { 
101 		    Rate = BestRollRate;
102 		    Bet = getRealBet(Rate);
103         }
104 	}
105 	function BetPriceLimit() constant returns(uint min,uint max) {
106 		min = minimumRollPrice;
107 		max = getRealBet(BestRollRate);
108 	}
109 	function Investors(address Address) constant returns(uint Investment, uint Balance, bool Live) {
110 		uint InvestorID = getInvestorByAddress(Address);
111 		if (InvestorID == 0 || ! investors[InvestorID].valid) {
112 			Investment = 0;
113 			Balance = 0;
114 			Live = false;
115 		}
116 		Investment = investors[InvestorID].value;
117 		Balance = investors[InvestorID].balance;
118 		Live = investors[InvestorID].live;
119 	}
120 	function Winners(uint id) constant returns(uint date, address addr, uint value, uint rate, uint bet)  {
121 		return WinnerDBInterface(winnersDB).Winners(id);
122 	}
123 	
124 	/*
125 		External functions
126 	*/
127 	/* Fallback */
128 	function () {
129 		PrepareRoll(0);
130 	}
131 	/* For Investors */
132 	function Invest() external OnlyEnabled noContract {
133 		uint value_ = msg.value;
134 		if (value_ < investUnit) { throw; }
135 		if (value_ % investUnit > 0) { 
136 			if ( ! msg.sender.send(value_ % investUnit)) { throw; } 
137 			value_ = value_ - (value_ % investUnit);
138 		}
139 		uint InvestorID = getInvestorByAddress(msg.sender);
140 		if (InvestorID == 0) {
141 			InvestorID = investors.length;
142 			investors.length++;
143 		}
144 		if (investors[InvestorID].valid && investors[InvestorID].live) {
145 			investors[InvestorID].value += value_;
146 		} else {
147 			investors[InvestorID].value = value_;
148 		}
149 		investors[InvestorID].timestamp = now + investMinDuration;
150 		investors[InvestorID].valid = true;
151 		investors[InvestorID].live = true;
152 		investors[InvestorID].owner = msg.sender;
153 		jackpot_ += value_;
154 		setJackpot();
155 	}
156 	function GetMyInvestmentBalance() external noEther {
157 		uint InvestorID = getInvestorByAddress(msg.sender);
158 		if (InvestorID == 0) { throw; }
159 		if ( ! investors[InvestorID].valid) { throw; }
160 		if (investors[InvestorID].balance == 0) { throw; }
161 		if ( ! msg.sender.send( investors[InvestorID].balance )) { throw; }
162 		investors[InvestorID].balance = 0;
163 	}
164 	function CancelMyInvestment() external noEther {
165 		uint InvestorID = getInvestorByAddress(msg.sender);
166 		if (InvestorID == 0) { throw; }
167 		if ( ! investors[InvestorID].valid) { throw; }
168 		if (investors[InvestorID].timestamp > now && ContractEnabled) { throw; }
169 		uint balance_;
170 		if (investors[InvestorID].live) {
171 			jackpot_ -= investors[InvestorID].value;
172 			balance_ = investors[InvestorID].value;
173 			setJackpot();
174 		}
175 		if (investors[InvestorID].balance > 0) {
176 			balance_ += investors[InvestorID].balance;
177 		}
178 		if ( ! msg.sender.send( balance_ )) { throw; }
179 		delete investors[InvestorID];
180 	}
181 	/* For Players */
182 	function DoRoll() external noEther noContract {
183 		uint value_;
184 		bool found;
185 		for ( uint a=0 ; a < players[msg.sender].length ; a++ ) {
186 			if (players[msg.sender][a].valid) {
187 			    if (players[msg.sender][a].blockNumber+rollLossBlockDelay <= block.number) {
188 			        uint feeValue_ = players[msg.sender][a].value/2;
189 			        feeValue += feeValue_;
190 			        investorAddFee(players[msg.sender][a].value - feeValue_);
191 					playersPot -= players[msg.sender][a].value;
192 					DoRollEvent(msg.sender, players[msg.sender][a].value, players[msg.sender][a].id, false, true, false, false, 0, 0, 0);
193 					delete players[msg.sender][a];
194 					found = true;
195 					continue;
196 			    }
197 				if ( ! ContractEnabled || players[msg.sender][a].sumInvest != jackpot_ || players[msg.sender][a].game != JackpotHits) {
198 					value_ += players[msg.sender][a].value;
199 					playersPot -= players[msg.sender][a].value;
200 					DoRollEvent(msg.sender, players[msg.sender][a].value, players[msg.sender][a].id, true, false, false, false, 0, 0, 0);
201 					delete players[msg.sender][a];
202 					found = true;
203 					continue;
204 				}
205 				if (players[msg.sender][a].blockNumber < block.number) {
206 					value_ += makeRoll(a);
207 					playersPot -= players[msg.sender][a].value;
208 					delete players[msg.sender][a];
209 					found = true;
210 					continue;
211 				}
212 			}
213 		}
214 		if ( ! found) { throw; }
215 		if (value_ > 0) { if ( ! msg.sender.send(value_)) { throw; } }
216 	}
217 	function PrepareRoll(uint seed) OnlyEnabled {
218 		if (msg.value < minimumRollPrice) { throw; }
219 		if (jackpot_ == 0) { throw; }
220 		uint _rate;
221 		uint _realBet;
222 		(_rate, _realBet) = ChanceOfWinning(msg.value);
223 		if (_realBet > msg.value) { throw; }
224 		if (msg.value-_realBet > 0) {
225 			if ( ! msg.sender.send( msg.value-_realBet )) { throw; }
226 		}
227 		for (uint a = 0 ; a < players[msg.sender].length ; a++) {
228 			if ( ! players[msg.sender][a].valid) {
229 				prepareRoll( a, _realBet, seed );
230 				return;
231 			}
232 		}
233 		players[msg.sender].length++;
234 		prepareRoll( players[msg.sender].length-1, _realBet, seed );
235 	}
236 	/* For Owner */
237 	function OwnerCloseContract() external OnlyOwner noEther {
238 		if ( ! ContractEnabled) {
239 		    if (ContractDisabledBlock < block.number) {
240 				if (playersPot == 0) { throw; }
241 				if ( ! msg.sender.send( playersPot )) { throw; }
242 				playersPot = 0;
243 		    }
244 		} else {
245     		ContractEnabled = false;
246     		ContractDisabledBlock = block.number+rollLossBlockDelay;
247 			ContractDisabled(ContractDisabledBlock);
248     		feeValue += extraJackpot_;
249     		extraJackpot_ = 0;
250 		}
251 	}
252 	function OwnerGetFee() external OnlyOwner noEther {
253 		if (feeValue == 0) { throw; }
254 		if ( ! owner.send(feeValue)) { throw; }
255 		feeValue = 0;
256 	}
257 	
258 	/*
259 		Private functions
260 	*/
261 	function setJackpot() private {
262 		Jackpot = extraJackpot_ + jackpot_;
263 	}
264 	function makeRoll(uint id) private returns(uint win) {
265 		uint feeValue_ = players[msg.sender][id].value * fee / 100 ;
266 		feeValue += feeValue_;
267 		uint investorFee_ = players[msg.sender][id].value * investorFee / 100;
268 		investorAddFee(investorFee_);
269 		extraJackpot_ += players[msg.sender][id].value - feeValue_ - investorFee_;
270 		setJackpot();
271 		bytes32 hash_ = players[msg.sender][id].extraHash;
272 		for ( uint a = 1 ; a <= prepareBlockDelay ; a++ ) {
273 			hash_ = sha3(hash_, block.blockhash(players[msg.sender][id].blockNumber - prepareBlockDelay+a));
274 		}
275 		uint _rate = getRate(players[msg.sender][id].value);
276 		uint bigNumber = uint64(hash_);
277 		if (bigNumber == 0 || _rate == 0) { return; }
278 		if (bigNumber % _rate == 0 ) {
279 			win = Jackpot;
280 			for ( a=1 ; a < investors.length ; a++ ) {
281 				investors[a].live = false;
282 			}
283 			JackpotHits++;
284 			extraJackpot_ = 0;
285 			jackpot_ = 0;
286 			Jackpot = 0;
287 			WinnerDBInterface( winnersDB ).newWinner(now, msg.sender, win, _rate, players[msg.sender][id].value);
288 			DoRollEvent(msg.sender, win, players[msg.sender][id].id, false, false, false, true, bigNumber, _rate, bigNumber % _rate);
289 		} else {
290 			DoRollEvent(msg.sender, players[msg.sender][id].value, players[msg.sender][id].id, false, false, true, false, bigNumber, _rate, bigNumber % _rate);
291 		}
292 	}
293 	function investorAddFee(uint value) private {
294 		bool done;
295 		for ( uint a=1 ; a < investors.length ; a++ ) {
296 			if (investors[a].live && investors[a].valid) {
297 				investors[a].balance += value * investors[a].value / jackpot_;
298 				done = true;
299 			}
300 		}
301 		if ( ! done) {
302 			feeValue += value;
303 		}
304 	}
305 	function prepareRoll(uint rollID, uint bet, uint seed) private {
306 		RollCount++;
307 		players[msg.sender][rollID].blockNumber = block.number + prepareBlockDelay;
308 		players[msg.sender][rollID].extraHash = sha3(RollCount, now, seed, RandomInterface(randomAddr).getRandom(), address(seed).balance);
309 		players[msg.sender][rollID].valid = true;
310 		players[msg.sender][rollID].value = bet;
311 		players[msg.sender][rollID].game = JackpotHits;
312 		players[msg.sender][rollID].id = RollCount;
313 		players[msg.sender][rollID].sumInvest = jackpot_;	
314 		playersPot += bet;
315 		PrepareRollEvent(msg.sender, players[msg.sender][rollID].blockNumber, players[msg.sender][rollID].value, players[msg.sender][rollID].id);
316 	}
317 	
318 	/*
319 		Internal functions
320 	*/	
321 	function getRate(uint value) internal returns(uint){
322 		return jackpot_ * 1 ether / value * 100 / investorFee * extraRate / 100 / 1 ether;
323 	}
324 	function getRealBet(uint rate) internal returns (uint) {
325 		return jackpot_ * 1 ether / ( rate * 1 ether * investorFee / extraRate);
326 	}
327 	function getInvestorByAddress(address Address) internal returns (uint id) {
328 		for ( id=1 ; id < investors.length ; id++ ) {
329 			if (investors[id].owner == Address) {
330 				return;
331 			}
332 		}
333 		return 0;
334 	}
335 	
336 	/*
337 		Events
338 	*/	
339 	event DoRollEvent(address Player, uint Value, uint RollID, bool Refund, bool LostBet, bool LossRoll, bool WinRoll, uint BigNumber, uint Rate, uint RollResult);
340 	event PrepareRollEvent(address Player, uint Block, uint Bet, uint RollID);
341 	event ContractDisabled(uint LossAllBetBlockNumber);
342 	
343 	/*
344 		Modifiers
345 	*/
346 	modifier noContract() {if (tx.origin != msg.sender) { throw; } _ }
347 	modifier noEther() { if (msg.value > 0) { throw; } _ }
348 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
349 	modifier OnlyEnabled() { if ( ! ContractEnabled) { throw; } _ }
350 }