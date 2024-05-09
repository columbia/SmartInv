1 /*
2 	WeeklyLotteryB
3 	Coded by: iFA
4 	http://wlb.ethereumlottery.net
5 	ver: 1.0
6 */
7 
8 contract WLBdrawsDBInterface {
9 	function newDraw(uint date, uint8[3] numbers, uint hit3Count, uint hit3Value, uint hit2Count, uint hit2Value);
10 	function getDraw(uint id) constant returns (uint date, uint8[3] numbers, uint hit3Count, uint hit3Value, uint hit2Count, uint hit2Value);
11 }
12 
13 contract WeeklyLotteryB {
14 	/* structures */
15 	struct games_s {
16 		uint ticketsCount;
17 		mapping(bytes32 => uint) hit3Hash;
18 		mapping(bytes32 => uint) hit2Hash;
19 		uint startTimestamp;
20 		uint endTimestamp;
21 		bytes3 winningNumbersBytes;
22 		uint prepareBlock;
23 		bool drawDone;
24 		uint prizePot;
25 		uint paidPot;
26 		uint hit3Count;
27 		uint hit3Value;
28 		uint hit2Count;
29 		uint hit2Value;
30 	}
31 	struct playerGames_s {
32 		bytes3[] numbersBytes;
33 		mapping(bytes32 => uint) hit3Hash;
34 		mapping(bytes32 => uint) hit2Hash;
35 		bool checked;
36 	}
37 	struct players_s {
38 		mapping(uint => playerGames_s) games;
39 	}
40 	struct investors_s {
41 		address owner;
42 		uint value;
43 		uint balance;
44 		bool live;
45 		bool valid;
46 		uint begins;
47 	}
48 	struct draws_s {
49 		uint date;
50 		uint gameID;
51 		bytes3 numbersBytes;
52 		uint hit3Count;
53 		uint hit3Value;
54 		uint hit2Count;
55 		uint hit2Value;
56 	}
57 	/* config */
58 	uint public constant ticketPrice = 100 finney; // 0.1 ether
59 	uint private constant drawMaxNumber = 50;
60 	uint private constant drawBlockDelay = 5;
61 	uint private constant prizeDismissDelay = 5;
62 	uint private constant contractDismissDelay = 5 weeks;
63 	uint private constant investUnit = 1 ether;
64 	uint private constant investMinimum = 10 ether;
65 	uint private constant investUserLimit = 200;
66 	uint private constant investMinDuration = 5; // 5 draw!
67 	uint private constant investIdleTime = 1 days;
68 	uint private constant forOwner = 2; //%
69 	uint private constant forInvestors = 40; //%
70 	uint private constant forHit2 = 30; //%
71 	/* variables */
72 	address private WLBdrawsDB;
73 	address private owner;
74 	uint private currentJackpot;
75 	uint private investmentsValue;
76 	uint private extraJackpot;
77 	uint private ticketCounter;
78 	uint private currentGame;
79 	uint private ownerBalance;
80 	bool public contractEnabled = true;
81 	uint private contractDisabledTimeStamp;
82 	mapping(address => players_s) private players;
83 	games_s[] private games;
84 	investors_s[] private investors;
85 	/* events */
86 	event NewTicketEvent(address Player, uint8 Number1, uint8 Number2, uint8 Number3);
87 	event ContractDisabledEvent(uint DeadlineTime);
88 	event DrawPrepareEvent(uint BlockNumber);
89 	event DrawEvent(uint GameID, uint8 Number1, uint8 Number2, uint8 Number3, uint Hit3Count, uint Hit3Value, uint Hit2Count, uint Hit2Value);
90 	event InvestAddEvent(address Investor, uint Value);
91 	event InvestCancelEvent(address Investor, uint Value);
92 	/* constructor */
93 	function WeeklyLotteryB(address _WLBdrawsDB) {
94 		WLBdrawsDB = _WLBdrawsDB;
95 		owner = msg.sender;
96 		currentGame = 1;
97 		games.length = 2;
98 		games[1].startTimestamp = now;
99 		games[1].endTimestamp = calcNextDrawTime();
100 	}
101 	/* constant functions */
102 	function Visit() constant returns (string) { return "http://wlb.ethereumlottery.net"; }
103 	function Draws(uint id) constant returns (uint date, uint8[3] Numbers, uint hit3Count, uint hit3Value, uint hit2Count, uint hit2Value) {
104 		return WLBdrawsDBInterface( WLBdrawsDB ).getDraw(id);
105 	}
106 	function CurrentGame() constant returns (uint GameID, uint Jackpot, uint Start, uint End, uint Tickets) {
107 		return (currentGame, currentJackpot, games[currentGame].startTimestamp, games[currentGame].endTimestamp, games[currentGame].ticketsCount);
108 	}
109 	function PlayerTickets(address Player, uint GameID, uint TicketID) constant returns (uint8[3] numbers, bool Checked) {
110 		return ( getNumbersFromBytes( players[Player].games[GameID].numbersBytes[TicketID] ), players[Player].games[GameID].checked);
111 	}
112 	function Investors(address Address) constant returns(uint Investment, uint Balance, bool Live) {
113 		var (found, InvestorID) = getInvestorByAddress(Address);
114 		if (found == false || ! investors[InvestorID].valid) {
115 			return (0, 0, false);
116 		}
117 		return (investors[InvestorID].value, investors[InvestorID].balance, investors[InvestorID].live);
118 	}
119 	/* callback function */
120 	function () {
121 		var Numbers = getNumbersFromHash(sha3(block.coinbase, now, ticketCounter));
122 		BuyTicket(Numbers[0],Numbers[1],Numbers[2]);
123 	}
124 	/* external functions for players */
125 	function BuyTicket(uint8 Number1, uint8 Number2, uint8 Number3) noContract OnlyEnabled {
126 		var Numbers = [Number1 , Number2 , Number3];
127 		if ( ! checkNumbers( Numbers )) { throw; }
128 		Numbers = sortNumbers(Numbers);
129 		if (msg.value < ticketPrice) { throw; }
130 		if (msg.value-ticketPrice > 0) { if ( ! msg.sender.send( msg.value-ticketPrice )) { throw; } }
131 		if (currentJackpot == 0) { throw; }
132 		if (games[currentGame].endTimestamp < now) { throw; }
133 		ticketCounter++;
134 		games[currentGame].ticketsCount++;
135 		bytes32 hash0 = sha3( Numbers[0], Numbers[1], Numbers[2] );
136 		bytes32 hash1 = sha3( Numbers[0], Numbers[1]);
137 		bytes32 hash2 = sha3( Numbers[0], Numbers[2]);
138 		bytes32 hash3 = sha3( Numbers[1], Numbers[2]);
139 		games[currentGame].hit3Hash[hash0]++;
140 		games[currentGame].hit2Hash[hash1]++;
141 		games[currentGame].hit2Hash[hash2]++;
142 		games[currentGame].hit2Hash[hash3]++;
143 		players[msg.sender].games[currentGame].numbersBytes.push ( getBytesFromNumbers(Numbers) );
144 		players[msg.sender].games[currentGame].hit3Hash[hash0]++;
145 		players[msg.sender].games[currentGame].hit2Hash[hash1]++;
146 		players[msg.sender].games[currentGame].hit2Hash[hash2]++;
147 		players[msg.sender].games[currentGame].hit2Hash[hash3]++;
148 		NewTicketEvent( msg.sender, Numbers[0], Numbers[1], Numbers[2] );
149 	}
150 	function CheckTickets() external noEther noContract {
151 		uint _value;
152 		uint gameID;
153 		uint gameLowID;
154 		uint8[3] memory numbers;
155 		bool ok;
156 		uint hit3Count;
157 		uint hit2Count;
158 		if (currentGame < prizeDismissDelay) {
159 			gameLowID = 1;
160 		} else {
161 			gameLowID = currentGame-prizeDismissDelay;
162 		}
163 		for ( gameID=currentGame ; gameID>=gameLowID ; gameID-- ) {
164 			if ( ! players[msg.sender].games[gameID].checked) {
165 				if (games[gameID].drawDone) {
166 					numbers = getNumbersFromBytes(games[gameID].winningNumbersBytes);
167 					hit3Count = players[msg.sender].games[gameID].hit3Hash[sha3( numbers[0], numbers[1], numbers[2] )];
168 					_value += hit3Count * games[gameID].hit3Value;
169 					hit2Count = players[msg.sender].games[gameID].hit2Hash[sha3( numbers[0], numbers[1] )];
170 					hit2Count += players[msg.sender].games[gameID].hit2Hash[sha3( numbers[0], numbers[2] )];
171 					hit2Count += players[msg.sender].games[gameID].hit2Hash[sha3( numbers[1], numbers[2] )];
172 					hit2Count -= hit3Count*3;
173 					_value += hit2Count * games[gameID].hit2Value;
174 					players[msg.sender].games[gameID].checked = true;
175 					ok = true;
176 				} else if ( ! contractEnabled && gameID == currentGame) {
177 					_value += players[msg.sender].games[gameID].numbersBytes.length * ticketPrice;
178 					players[msg.sender].games[gameID].checked = true;
179 					ok = true;
180 				}
181 			}
182 		}
183 		if ( ! ok) { throw; }
184 		if (_value > 0) { if ( ! msg.sender.send(_value)) { throw; } }
185 	}
186 	/* external functions for investors */
187 	function InvestAdd() external OnlyEnabled noContract {
188 		uint value_ = msg.value;
189 		if (value_ < investUnit) { throw; }
190 		if (value_ % investUnit > 0) { 
191 			if ( ! msg.sender.send( value_ % investUnit )) { throw; } 
192 			value_ = value_ - (value_ % investUnit);
193 		}
194 		if (value_ < investMinimum) { throw; }
195 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
196 		if (found == false) {
197 			if (investors.length == investUserLimit) { throw; }
198 			InvestorID = investors.length;
199 			investors.length++;
200 		}
201 		if (investors[InvestorID].valid && investors[InvestorID].live) {
202 			investors[InvestorID].value += value_;
203 		} else {
204 			investors[InvestorID].value = value_;
205 		}
206 		investors[InvestorID].begins = currentGame;
207 		investors[InvestorID].valid = true;
208 		investors[InvestorID].live = true;
209 		investors[InvestorID].owner = msg.sender;
210 		investmentsValue += value_;
211 		setJackpot();
212 		InvestAddEvent(msg.sender, value_);
213 	}
214 	function InvestWithdraw() external noEther {
215 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
216 		if (found == false) { throw; }
217 		if ( ! investors[InvestorID].valid) { throw; }
218 		uint _balance = investors[InvestorID].balance;
219 		if (_balance == 0) { throw; }
220 		investors[InvestorID].balance = 0;
221 		if ( ! msg.sender.send( _balance )) { throw; }
222 	}
223 	function InvestCancel() external noEther {
224 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
225 		if (found == false) { throw; }
226 		if ( ! investors[InvestorID].valid) { throw; }
227 		if (contractEnabled) {
228 			if (investors[InvestorID].begins+investMinDuration > now) { throw; }
229 			if (games[currentGame].startTimestamp+investIdleTime > now) { throw; }
230 		}
231 		uint balance_;
232 		if (investors[InvestorID].live) {
233 			investmentsValue -= investors[InvestorID].value;
234 			balance_ = investors[InvestorID].value;
235 			setJackpot();
236 			InvestCancelEvent(msg.sender, investors[InvestorID].value);
237 		}
238 		if (investors[InvestorID].balance > 0) {
239 			balance_ += investors[InvestorID].balance;
240 		}
241 		delete investors[InvestorID];
242 		if ( ! msg.sender.send( balance_ )) { throw; }
243 	}
244 	/* draw functions for everyone*/
245 	function DrawPrepare() noContract OnlyEnabled noEther {
246 		if (games[currentGame].endTimestamp > now || games[currentGame].prepareBlock != 0) { throw; }
247 		games[currentGame].prepareBlock = block.number+drawBlockDelay;
248 		DrawPrepareEvent(games[currentGame].prepareBlock);
249 	}
250 	function Draw() noContract OnlyEnabled noEther {
251 		if (games[currentGame].prepareBlock == 0 || games[currentGame].prepareBlock > block.number) { throw; }
252 		bytes32 _hash;
253 		uint hit3Value;
254 		uint hit3Count;
255 		uint hit2Value;
256 		uint hit2Count;
257 		uint a;
258 		for ( a = 1 ; a <= drawBlockDelay ; a++ ) {
259 			_hash = sha3(_hash, block.blockhash(games[currentGame].prepareBlock - drawBlockDelay+a));
260 		}
261 		var numbers = getNumbersFromHash(_hash);
262 		games[currentGame].winningNumbersBytes = getBytesFromNumbers( numbers );
263 		hit3Count += games[currentGame].hit3Hash[ sha3( numbers[0], numbers[1],numbers[2] ) ];
264 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[0], numbers[1]) ];
265 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[0], numbers[2]) ];
266 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[1], numbers[2]) ];
267 		hit2Count -= hit3Count*3;
268 		uint totalPot = games[currentGame].ticketsCount*ticketPrice;
269 		hit2Value = ( totalPot * forHit2 / 100 );
270 		games[currentGame].prizePot = hit2Value;
271 		hit2Value = hit2Value / hit2Count;
272 		totalPot -= hit2Value;
273 		uint _ownerBalance = totalPot * forHit2 / 100;
274 		totalPot -= _ownerBalance;
275 		ownerBalance += _ownerBalance;
276 		uint _addInvestorsValue = totalPot * forInvestors / 100;
277 		addInvestorsValue(_addInvestorsValue);
278 		totalPot -= _addInvestorsValue;
279 		if (hit3Count > 0) {
280 			games[currentGame].prizePot += currentJackpot;
281 			for ( a=0 ; a < investors.length ; a++ ) {
282 				delete investors[a].live;
283 			}
284 			hit3Value = currentJackpot / hit3Count;
285 			extraJackpot = 0;
286 			investmentsValue = 0;
287 		}
288 		extraJackpot += totalPot;
289 		setJackpot();
290 		DrawEvent(currentGame, numbers[0], numbers[1], numbers[2], hit3Count, hit3Value, hit2Count, hit2Value);
291 		WLBdrawsDBInterface( WLBdrawsDB ).newDraw( now, numbers, hit3Count, hit3Value, hit2Count, hit2Value);
292 		games[currentGame].hit3Count = hit3Count;
293 		games[currentGame].hit3Value = hit3Value;
294 		games[currentGame].hit2Count = hit2Count;
295 		games[currentGame].hit2Value = hit2Value;
296 		games[currentGame].drawDone = true;
297 		newGame();
298 	}
299 	/* owner functions */
300 	function OwnerGetFee() external OnlyOwner {
301 		if (ownerBalance == 0) { throw; }
302 		if (owner.send(ownerBalance) == false) { throw; }
303 		ownerBalance = 0;
304 	}
305 	function OwnerCloseContract() external OnlyOwner noEther {
306 		if ( ! contractEnabled) {
307 			if (contractDisabledTimeStamp+contractDismissDelay < now) {
308 				suicide(owner);
309 			}
310 		} else {
311 			contractEnabled = false;
312 			contractDisabledTimeStamp = now;
313 			ContractDisabledEvent(contractDisabledTimeStamp+contractDismissDelay);
314 			ownerBalance += extraJackpot;
315 			extraJackpot = 0;
316 		}
317 	}
318 	/* private functions */
319 	function addInvestorsValue(uint value) private {
320 		bool done;
321 		uint a;
322 		for ( a=0 ; a < investors.length ; a++ ) {
323 			if (investors[a].live && investors[a].valid) {
324 				investors[a].balance += value * investors[a].value / investmentsValue;
325 				done = true;
326 			}
327 		}
328 		if ( ! done) {
329 			ownerBalance += value;
330 		}
331 	}
332 	function newGame() private {
333 		currentGame++;
334 		uint gamesID = games.length;
335 		games.length++;
336 		games[gamesID].startTimestamp = now;
337 		games[gamesID].endTimestamp = calcNextDrawTime();
338 		if (games.length > prizeDismissDelay) {
339 			ownerBalance += games[currentGame-prizeDismissDelay].prizePot;
340 			delete games[currentGame-prizeDismissDelay];
341 		}
342 	}
343 	function getNumbersFromHash(bytes32 hash) private returns (uint8[3] numbers) {
344 		bool ok = true;
345 		uint8 num = 0;
346 		uint hashpos = 0;
347 		uint8 a;
348 		uint8 b;
349 		for (a = 0 ; a < numbers.length ; a++) {
350 			while (true) {
351 				ok = true;
352 				if (hashpos == 32) {
353 					hashpos = 0;
354 					hash = sha3(hash);
355 				}
356 				num = getPart( hash, hashpos );
357 				num = num % uint8(drawMaxNumber) + 1;
358 				hashpos += 1;
359 				for (b = 0 ; b < numbers.length ; b++) {
360 					if (numbers[b] == num) {
361 						ok = false;
362 						break; 
363 					}
364 				}
365 				if (ok == true) {
366 					numbers[a] = num;
367 					break;
368 				}
369 			}
370 		}
371 		numbers = sortNumbers( numbers );
372 	}
373 	function getPart(bytes32 a, uint i) private returns (uint8) { return uint8(byte(bytes32(uint(a) * 2 ** (8 * i)))); }
374 	function setJackpot() private {
375 		currentJackpot = investmentsValue + extraJackpot;
376 	}
377 	function getInvestorByAddress(address Address) private returns (bool found, uint id) {
378 		for ( id=0 ; id < investors.length ; id++ ) {
379 			if (investors[id].owner == Address) {
380 				return (true, id);
381 			}
382 		}
383 		return (false, 0);
384 	}
385 	function checkNumbers(uint8[3] Numbers) private returns (bool) {
386 		for ( uint a = 0 ; a < Numbers.length ; a++ ) {
387 			if (Numbers[a] > drawMaxNumber || Numbers[a] == 0) { return; }
388 			for ( uint b = 0 ; a < Numbers.length ; a++ ) {
389 				if (a != b && Numbers[a] == Numbers[b]) { return; }
390 			}
391 		}
392 		return true;
393 	}
394 	function calcNextDrawTime() private returns (uint ret) {
395 		ret = 1468152000;
396 		while (ret < now) {
397 			ret += 1 weeks;
398 		}
399 	}
400 	function sortNumbers(uint8[3] numbers) private returns(uint8[3] sNumbers) {
401 		sNumbers = numbers;
402 		for (uint8 i=0; i<numbers.length; i++) {
403 			for (uint8 j=i+1; j<numbers.length; j++) {
404 				if (sNumbers[i] > sNumbers[j]) {
405 					uint8 t = sNumbers[i];
406 					sNumbers[i] = sNumbers[j];
407 					sNumbers[j] = t;
408 				}
409 			}
410 		}
411 	}
412 	function getNumbersFromBytes(bytes3 Bytes) private returns (uint8[3] Numbers){
413 		Numbers[0] = uint8(Bytes);
414 		Numbers[1] = uint8(uint24(Bytes) /256);
415 		Numbers[2] = uint8(uint24(Bytes) /256/256);
416 	}
417 	function getBytesFromNumbers(uint8[3] Numbers) private returns (bytes3 Bytes) {
418 		return bytes3(uint(Numbers[0])+uint(Numbers[1])*256+uint(Numbers[2])*256*256);
419 	}
420 	/* modifiers */
421 	modifier noContract() {if (tx.origin != msg.sender) { throw; } _ }
422 	modifier noEther() { if (msg.value > 0) { throw; } _ }
423 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
424 	modifier OnlyEnabled() { if ( ! contractEnabled) { throw; } _ }
425 }