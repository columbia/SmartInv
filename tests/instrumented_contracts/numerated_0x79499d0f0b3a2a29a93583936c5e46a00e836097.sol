1 contract RandomInterface {
2 	function getRandom() returns (bytes32 hash) {}
3 }
4 contract ILWinnerDBInterface {
5 	function Winners(uint id) constant returns(uint date, address addr, uint value, uint rate, uint bet) {}
6 	function newWinner(uint date, address addr, uint value, uint rate, uint bet) external returns (bool) {}
7 }
8 contract InstantLottery {
9 	/*
10 		InstantLottery
11 		Coded by: iFA
12 		http://il.ethereumlottery.net
13 		ver: 3.0.0
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
32 	bool public ContractEnabled = true;
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
66 	string constant public Information = "http://il.ethereumlottery.net";
67 	
68 	/*
69 		Deploy
70 	*/
71 	function InstantLottery(address _winnersDB, address _randomAddr, bool _oldContract, address _oldContractAddress) {
72 		owner = msg.sender;
73 		winnersDB = _winnersDB;
74 		randomAddr = _randomAddr;
75 		if (_oldContract && _oldContractAddress != 0x0) {
76 			RollCount = InstantLottery( _oldContractAddress ).RollCount();
77 			JackpotHits = InstantLottery( _oldContractAddress ).JackpotHits();
78 		}
79 	}
80 	
81 	/* 
82 		Constans functions
83 	*/
84 	function ChanceOfWinning(uint Value) constant returns(uint Rate, uint Bet) {
85 		if (jackpot_ == 0) {
86 			Rate = 0;
87 			Bet = 0;
88 			return;
89 		}
90 		if (Value < minimumRollPrice) {
91 			Value = minimumRollPrice;
92 		}
93 		Rate = getRate(Value);
94 		Bet = getRealBet(Rate);
95 		while (Value < Bet) {
96 			Rate++;
97 			Bet = getRealBet(Rate);
98 		}
99 		if (Rate < BestRollRate) { 
100 			Rate = BestRollRate;
101 			Bet = getRealBet(Rate);
102 		}
103 	}
104 	function BetPriceLimit() constant returns(uint min,uint max) {
105 		min = minimumRollPrice;
106 		max = getRealBet(BestRollRate);
107 	}
108 	function Investors(address Address) constant returns(uint Investment, uint Balance, bool Live) {
109 		var (found, InvestorID) = getInvestorByAddress(Address);
110 		if (found == false || ! investors[InvestorID].valid) {
111 			Investment = 0;
112 			Balance = 0;
113 			Live = false;
114 			return;
115 		}
116 		Investment = investors[InvestorID].value;
117 		Balance = investors[InvestorID].balance;
118 		Live = investors[InvestorID].live;
119 	}
120 	function Winners(uint id) constant returns(uint date, address addr, uint value, uint rate, uint bet) {
121 		return ILWinnerDBInterface(winnersDB).Winners(id);
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
139 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
140 		if (found == false) {
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
157 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
158 		if (found == false) { throw; }
159 		if ( ! investors[InvestorID].valid) { throw; }
160 		uint _balance = investors[InvestorID].balance;
161 		if (_balance == 0) { throw; }
162 		investors[InvestorID].balance = 0;
163 		if ( ! msg.sender.send( _balance )) { throw; }
164 	}
165 	function CancelMyInvestment() external noEther {
166 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
167 		if (found == false) { throw; }
168 		if ( ! investors[InvestorID].valid) { throw; }
169 		if (investors[InvestorID].timestamp > now && ContractEnabled) { throw; }
170 		uint balance_;
171 		if (investors[InvestorID].live) {
172 			jackpot_ -= investors[InvestorID].value;
173 			balance_ = investors[InvestorID].value;
174 			setJackpot();
175 		}
176 		if (investors[InvestorID].balance > 0) {
177 			balance_ += investors[InvestorID].balance;
178 		}
179 		delete investors[InvestorID];
180 		if ( ! msg.sender.send( balance_ )) { throw; }
181 	}
182 	/* For Players */
183 	function DoRoll() external noEther {
184 		uint value_;
185 		bool found;
186 		bool subFound;
187 		for ( uint a=0 ; a < players[msg.sender].length ; a++ ) {
188 			if (players[msg.sender][a].valid) {
189 				subFound = false;
190 				if (players[msg.sender][a].blockNumber+rollLossBlockDelay <= block.number) {
191 					uint feeValue_ = players[msg.sender][a].value/2;
192 					feeValue += feeValue_;
193 					investorAddFee(players[msg.sender][a].value - feeValue_);
194 					DoRollEvent(msg.sender, players[msg.sender][a].value, players[msg.sender][a].id, false, true, false, false, 0, 0, 0);
195 					subFound = true;
196 				}
197 				if ( ! ContractEnabled || players[msg.sender][a].sumInvest != jackpot_ || players[msg.sender][a].game != JackpotHits) {
198 					value_ += players[msg.sender][a].value;
199 					DoRollEvent(msg.sender, players[msg.sender][a].value, players[msg.sender][a].id, true, false, false, false, 0, 0, 0);
200 					subFound = true;
201 				}
202 				if (players[msg.sender][a].blockNumber < block.number) {
203 					value_ += makeRoll(a);
204 					subFound = true;
205 				}
206 				if (subFound) {
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
217 	function PrepareRoll(uint seed) OnlyEnabled noContract {
218 		if (msg.value < minimumRollPrice) { throw; }
219 		if (jackpot_ == 0) { throw; }
220 		var (_rate, _realBet) = ChanceOfWinning(msg.value);
221 		if (_realBet > msg.value) { throw; }
222 		if (msg.value-_realBet > 0) {
223 			if ( ! msg.sender.send( msg.value-_realBet )) { throw; }
224 		}
225 		for (uint a = 0 ; a < players[msg.sender].length ; a++) {
226 			if ( ! players[msg.sender][a].valid) {
227 				prepareRoll( a, _realBet, seed );
228 				return;
229 			}
230 		}
231 		players[msg.sender].length++;
232 		prepareRoll( players[msg.sender].length-1, _realBet, seed );
233 	}
234 	/* For Owner */
235 	function OwnerCloseContract() external OnlyOwner noEther {
236 		if ( ! ContractEnabled) {
237 			if (ContractDisabledBlock < block.number) {
238 				if (playersPot == 0) { throw; }
239 				uint _value = playersPot;
240 				playersPot = 0;
241 				if ( ! msg.sender.send( _value )) { throw; }
242 			}
243 		} else {
244 			ContractEnabled = false;
245 			ContractDisabledBlock = block.number+rollLossBlockDelay;
246 			ContractDisabled(ContractDisabledBlock);
247 			feeValue += extraJackpot_;
248 			extraJackpot_ = 0;
249 		}
250 	}
251 	function OwnerGetFee() external OnlyOwner noEther {
252 		if (feeValue == 0) { throw; }
253 		uint _value = playersPot;
254 		feeValue = 0;
255 		if ( ! owner.send(_value)) { throw; }
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
280 			for ( a=0 ; a < investors.length ; a++ ) {
281 				investors[a].live = false;
282 			}
283 			JackpotHits++;
284 			extraJackpot_ = 0;
285 			jackpot_ = 0;
286 			Jackpot = 0;
287 			ILWinnerDBInterface( winnersDB ).newWinner(now, msg.sender, win, _rate, players[msg.sender][id].value);
288 			DoRollEvent(msg.sender, win, players[msg.sender][id].id, false, false, false, true, bigNumber, _rate, bigNumber % _rate);
289 		} else {
290 			DoRollEvent(msg.sender, players[msg.sender][id].value, players[msg.sender][id].id, false, false, true, false, bigNumber, _rate, bigNumber % _rate);
291 		}
292 	}
293 	function investorAddFee(uint value) private {
294 		bool done;
295 		for ( uint a=0 ; a < investors.length ; a++ ) {
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
327 	function getInvestorByAddress(address Address) internal returns (bool found, uint id) {
328 		for ( id=0 ; id < investors.length ; id++ ) {
329 			if (investors[id].owner == Address) {
330 				return (true, id);
331 			}
332 		}
333 		return (false, 0);
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