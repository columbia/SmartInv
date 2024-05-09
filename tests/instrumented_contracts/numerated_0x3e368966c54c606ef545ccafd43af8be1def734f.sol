1 /*
2 	WeeklyLotteryB
3 	Coded by: iFA
4 	http://wlb.ethereumlottery.net
5 	ver: 1.2
6 */
7 contract WLBDrawsDB {
8 	address private owner;
9 	address private game;
10 	
11 	struct draws_s {
12 		uint date;
13 		uint8[3] numbers;
14 		uint hit3Count;
15 		uint hit3Value;
16 		uint hit2Count;
17 		uint hit2Value;
18 	}
19 	
20 	draws_s[] private draws;
21 	
22 	function WLBDrawsDB() {
23 		owner = msg.sender;
24 	}
25 	
26 	function newDraw(uint date, uint8[3] numbers, uint hit3Count, uint hit3Value, uint hit2Count, uint hit2Value) noEther {
27 		if ( msg.sender != owner && msg.sender != game ) { throw; }
28 		draws.push( draws_s( date, numbers, hit3Count, hit3Value, hit2Count, hit2Value) );
29 	}
30 	
31 	function getDraw(uint id) constant returns (uint date, uint8[3] numbers, uint hit3Count, uint hit3Value, uint hit2Count, uint hit2Value) {
32 		return ( draws[id].date, draws[id].numbers, draws[id].hit3Count, draws[id].hit3Value, draws[id].hit2Count, draws[id].hit2Value );
33 	}
34 	
35 	function setGameAddress(address _game) noEther OnlyOwner external {
36 		game = _game;
37 	}
38 	
39 	modifier noEther() { if (msg.value > 0) { throw; } _ }
40 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
41 }
42 
43 contract WeeklyLotteryB {
44 	/* structures */
45 	struct games_s {
46 		uint ticketsCount;
47 		mapping(bytes32 => uint) hit3Hash;
48 		mapping(bytes32 => uint) hit2Hash;
49 		uint startTimestamp;
50 		uint endTimestamp;
51 		bytes3 winningNumbersBytes;
52 		uint prepareBlock;
53 		bool drawDone;
54 		uint prizePot;
55 		uint hit3Count;
56 		uint hit3Value;
57 		uint hit2Count;
58 		uint hit2Value;
59 	}
60 	struct playerGames_s {
61 		bytes3[] numbersBytes;
62 		mapping(bytes32 => uint) hit3Hash;
63 		mapping(bytes32 => uint) hit2Hash;
64 		bool checked;
65 	}
66 	struct players_s {
67 		mapping(uint => playerGames_s) games;
68 	}
69 	struct investors_s {
70 		address owner;
71 		uint value;
72 		uint balance;
73 		bool live;
74 		bool valid;
75 		uint begins;
76 	}
77 	struct draws_s {
78 		uint date;
79 		uint gameID;
80 		bytes3 numbersBytes;
81 		uint hit3Count;
82 		uint hit3Value;
83 		uint hit2Count;
84 		uint hit2Value;
85 	}
86 	/* config */
87 	uint public constant ticketPrice = 100 finney; // 0.1 ether
88 	uint private constant drawMaxNumber = 50;
89 	uint private constant drawBlockDelay = 5;
90 	uint private constant prizeDismissDelay = 5;
91 	uint private constant contractDismissDelay = 5 weeks;
92 	uint private constant investUnit = 1 ether;
93 	uint private constant investMinimum = 10 ether;
94 	uint private constant investUserLimit = 200;
95 	uint private constant investMinDuration = 5; // 5 draw!
96 	uint private constant investIdleTime = 1 days;
97 	uint private constant forOwner = 2; //%
98 	uint private constant forInvestors = 40; //%
99 	uint private constant forHit2 = 30; //%
100 	/* variables */
101 	address private WLBdrawsDBAddr;
102 	address private owner;
103 	uint private currentJackpot;
104 	uint private investmentsValue;
105 	uint private extraJackpot;
106 	uint private ticketCounter;
107 	uint private currentGame;
108 	uint private ownerBalance;
109 	uint private oldContractLastGame;
110 	bool public contractEnabled = true;
111 	uint private contractDisabledTimeStamp;
112 	mapping(address => players_s) private players;
113 	games_s[] private games;
114 	investors_s[] private investors;
115 	/* events */
116 	event NewTicketEvent(address Player, uint8 Number1, uint8 Number2, uint8 Number3);
117 	event ContractDisabledEvent(uint DeadlineTime);
118 	event DrawPrepareEvent(uint BlockNumber);
119 	event DrawEvent(uint GameID, uint8 Number1, uint8 Number2, uint8 Number3, uint Hit3Count, uint Hit3Value, uint Hit2Count, uint Hit2Value);
120 	event InvestAddEvent(address Investor, uint Value);
121 	event InvestCancelEvent(address Investor, uint Value);
122 	/* constructor */
123 	function WeeklyLotteryB(address _WLBdrawsDBAddr, uint _oldContractLastGame) {
124 		WLBdrawsDBAddr = _WLBdrawsDBAddr;
125 		owner = msg.sender;
126 		currentGame = 0;
127 		oldContractLastGame = _oldContractLastGame;
128 		games.length = 1;
129 		games[0].startTimestamp = now;
130 		uint ret = 1470571200;
131 		while (ret < now) {
132 			ret += 1 weeks;
133 		}
134 		games[0].endTimestamp = ret;
135 	}
136 	/* constant functions */
137 	function Visit() constant returns (string) { return "http://wlb.ethereumlottery.net"; }
138 	function Draws(uint id) constant returns (uint date, uint8[3] Numbers, uint hit3Count, uint hit3Value, uint hit2Count, uint hit2Value) {
139 		return WLBDrawsDB( WLBdrawsDBAddr ).getDraw(id);
140 	}
141 	function CurrentGame() constant returns (uint GameID, uint Jackpot, uint Start, uint End, uint Tickets) {
142 		return (currentGame+oldContractLastGame, currentJackpot, games[currentGame].startTimestamp, games[currentGame].endTimestamp, games[currentGame].ticketsCount);
143 	}
144 	function PlayerTickets(address Player, uint GameID, uint TicketID) constant returns (uint8[3] numbers, bool Checked) {
145 		GameID -= oldContractLastGame;
146 		return ( getNumbersFromBytes( players[Player].games[GameID].numbersBytes[TicketID] ), players[Player].games[GameID].checked);
147 	}
148 	function Investors(address Address) constant returns(uint Investment, uint Balance, bool Live) {
149 		var (found, InvestorID) = getInvestorByAddress(Address);
150 		if (found == false || ! investors[InvestorID].valid) {
151 			return (0, 0, false);
152 		}
153 		return (investors[InvestorID].value, investors[InvestorID].balance, investors[InvestorID].live);
154 	}
155 	function CheckPrize(address Address) constant returns(uint value) {
156 		uint gameID;
157 		uint gameLowID;
158 		uint8[3] memory numbers;
159 		uint hit3Count;
160 		uint hit2Count;
161 		for ( gameID=currentGame ; gameID>=0 ; gameID-- ) {
162 			if ( ! players[Address].games[gameID].checked) {
163 				if (games[gameID].drawDone) {
164 					numbers = getNumbersFromBytes(games[gameID].winningNumbersBytes);
165 					hit3Count = players[Address].games[gameID].hit3Hash[sha3( numbers[0], numbers[1], numbers[2] )];
166 					value += hit3Count * games[gameID].hit3Value;
167 					hit2Count = players[Address].games[gameID].hit2Hash[sha3( numbers[0], numbers[1] )];
168 					hit2Count += players[Address].games[gameID].hit2Hash[sha3( numbers[0], numbers[2] )];
169 					hit2Count += players[Address].games[gameID].hit2Hash[sha3( numbers[1], numbers[2] )];
170 					hit2Count -= hit3Count*3;
171 					value += hit2Count * games[gameID].hit2Value;
172 				} else if ( ! contractEnabled && gameID == currentGame) {
173 					value += players[Address].games[gameID].numbersBytes.length * ticketPrice;
174 				}
175 			}
176 			if (gameID == 0 || gameID-prizeDismissDelay == gameID) { break; }
177 		}
178 	}
179 	/* callback function */
180 	function () {
181 		var Numbers = getNumbersFromHash(sha3(block.coinbase, now, ticketCounter));
182 		BuyTicket(Numbers[0],Numbers[1],Numbers[2]);
183 	}
184 	/* external functions for players */
185 	function BuyTicket(uint8 Number1, uint8 Number2, uint8 Number3) noContract OnlyEnabled {
186 		var Numbers = [Number1 , Number2 , Number3];
187 		if ( ! checkNumbers( Numbers )) { throw; }
188 		Numbers = sortNumbers(Numbers);
189 		if (msg.value < ticketPrice) { throw; }
190 		if (msg.value-ticketPrice > 0) { if ( ! msg.sender.send( msg.value-ticketPrice )) { throw; } }
191 		if (currentJackpot == 0) { throw; }
192 		if (games[currentGame].endTimestamp < now) { throw; }
193 		ticketCounter++;
194 		games[currentGame].ticketsCount++;
195 		bytes32 hash0 = sha3( Numbers[0], Numbers[1], Numbers[2] );
196 		bytes32 hash1 = sha3( Numbers[0], Numbers[1]);
197 		bytes32 hash2 = sha3( Numbers[0], Numbers[2]);
198 		bytes32 hash3 = sha3( Numbers[1], Numbers[2]);
199 		games[currentGame].hit3Hash[hash0]++;
200 		games[currentGame].hit2Hash[hash1]++;
201 		games[currentGame].hit2Hash[hash2]++;
202 		games[currentGame].hit2Hash[hash3]++;
203 		players[msg.sender].games[currentGame].numbersBytes.push ( getBytesFromNumbers(Numbers) );
204 		players[msg.sender].games[currentGame].hit3Hash[hash0]++;
205 		players[msg.sender].games[currentGame].hit2Hash[hash1]++;
206 		players[msg.sender].games[currentGame].hit2Hash[hash2]++;
207 		players[msg.sender].games[currentGame].hit2Hash[hash3]++;
208 		NewTicketEvent( msg.sender, Numbers[0], Numbers[1], Numbers[2] );
209 	}
210 	function CheckTickets() external noEther noContract {
211 		uint _value;
212 		uint _subValue;
213 		uint gameID;
214 		uint gameLowID;
215 		uint8[3] memory numbers;
216 		bool changed;
217 		uint hit3Count;
218 		uint hit2Count;
219 		for ( gameID=currentGame ; gameID>=0 ; gameID-- ) {
220 			if ( ! players[msg.sender].games[gameID].checked) {
221 				if (games[gameID].drawDone) {
222 					numbers = getNumbersFromBytes(games[gameID].winningNumbersBytes);
223 					hit3Count = players[msg.sender].games[gameID].hit3Hash[sha3( numbers[0], numbers[1], numbers[2] )];
224 					_subValue += hit3Count * games[gameID].hit3Value;
225 					hit2Count = players[msg.sender].games[gameID].hit2Hash[sha3( numbers[0], numbers[1] )];
226 					hit2Count += players[msg.sender].games[gameID].hit2Hash[sha3( numbers[0], numbers[2] )];
227 					hit2Count += players[msg.sender].games[gameID].hit2Hash[sha3( numbers[1], numbers[2] )];
228 					hit2Count -= hit3Count*3;
229 					_subValue += hit2Count * games[gameID].hit2Value;
230 					games[gameID].prizePot -= _subValue;
231 					_value += _subValue;
232 					players[msg.sender].games[gameID].checked = true;
233 					changed = true;
234 				} else if ( ! contractEnabled && gameID == currentGame) {
235 					_value += players[msg.sender].games[gameID].numbersBytes.length * ticketPrice;
236 					players[msg.sender].games[gameID].checked = true;
237 					changed = true;
238 				}
239 			}
240 			if (gameID == 0 || gameID-prizeDismissDelay == gameID) { break; }
241 		}
242 		if ( ! changed) { throw; }
243 		if (_value > 0) { if ( ! msg.sender.send(_value)) { throw; } }
244 	}
245 	/* external functions for investors */
246 	function InvestAdd() external OnlyEnabled noContract {
247 		uint value_ = msg.value;
248 		if (value_ < investUnit) { throw; }
249 		if (value_ % investUnit > 0) { 
250 			if ( ! msg.sender.send( value_ % investUnit )) { throw; } 
251 			value_ = value_ - (value_ % investUnit);
252 		}
253 		if (value_ < investMinimum) { throw; }
254 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
255 		if (found == false) {
256 			if (investors.length == investUserLimit) { throw; }
257 			InvestorID = investors.length;
258 			investors.length++;
259 		}
260 		if (investors[InvestorID].valid && investors[InvestorID].live) {
261 			investors[InvestorID].value += value_;
262 		} else {
263 			investors[InvestorID].value = value_;
264 		}
265 		investors[InvestorID].begins = currentGame;
266 		investors[InvestorID].valid = true;
267 		investors[InvestorID].live = true;
268 		investors[InvestorID].owner = msg.sender;
269 		investmentsValue += value_;
270 		setJackpot();
271 		InvestAddEvent(msg.sender, value_);
272 	}
273 	function InvestWithdraw() external noEther {
274 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
275 		if (found == false) { throw; }
276 		if ( ! investors[InvestorID].valid) { throw; }
277 		uint _balance = investors[InvestorID].balance;
278 		if (_balance == 0) { throw; }
279 		investors[InvestorID].balance = 0;
280 		if ( ! msg.sender.send( _balance )) { throw; }
281 	}
282 	function InvestCancel() external noEther {
283 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
284 		if (found == false) { throw; }
285 		if ( ! investors[InvestorID].valid) { throw; }
286 		if (contractEnabled) {
287 			if (investors[InvestorID].begins+investMinDuration < now) { throw; }
288 			if (games[currentGame].startTimestamp+investIdleTime < now) { throw; }
289 		}
290 		uint balance_;
291 		if (investors[InvestorID].live) {
292 			investmentsValue -= investors[InvestorID].value;
293 			balance_ = investors[InvestorID].value;
294 			setJackpot();
295 			InvestCancelEvent(msg.sender, investors[InvestorID].value);
296 		}
297 		if (investors[InvestorID].balance > 0) {
298 			balance_ += investors[InvestorID].balance;
299 		}
300 		delete investors[InvestorID];
301 		if ( ! msg.sender.send( balance_ )) { throw; }
302 	}
303 	/* draw functions for everyone*/
304 	function DrawPrepare() noContract OnlyEnabled noEther {
305 		if (games[currentGame].endTimestamp > now || games[currentGame].prepareBlock != 0) { throw; }
306 		games[currentGame].prepareBlock = block.number+drawBlockDelay;
307 		DrawPrepareEvent(games[currentGame].prepareBlock);
308 	}
309 	function Draw() noContract OnlyEnabled noEther {
310 		if (games[currentGame].prepareBlock == 0 || games[currentGame].prepareBlock > block.number) { throw; }
311 		bytes32 _hash;
312 		uint hit3Value;
313 		uint hit3Count;
314 		uint hit2Value;
315 		uint hit2Count;
316 		uint a;
317 		for ( a = 1 ; a <= drawBlockDelay ; a++ ) {
318 			_hash = sha3(_hash, block.blockhash(games[currentGame].prepareBlock - drawBlockDelay+a));
319 		}
320 		var numbers = getNumbersFromHash(_hash);
321 		games[currentGame].winningNumbersBytes = getBytesFromNumbers( numbers );
322 		hit3Count += games[currentGame].hit3Hash[ sha3( numbers[0], numbers[1],numbers[2] ) ];
323 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[0], numbers[1]) ];
324 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[0], numbers[2]) ];
325 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[1], numbers[2]) ];
326 		hit2Count -= hit3Count*3;
327 		uint totalPot = games[currentGame].ticketsCount*ticketPrice;
328 		hit2Value = ( totalPot * forHit2 / 100 );
329 		if (hit2Count > 0) {
330 			games[currentGame].prizePot = hit2Value;
331 		}
332 		hit2Value = hit2Value / hit2Count;
333 		totalPot -= hit2Value;
334 		uint _ownerBalance = totalPot * forOwner / 100;
335 		totalPot -= _ownerBalance;
336 		ownerBalance += _ownerBalance;
337 		uint _addInvestorsValue = totalPot * forInvestors / 100;
338 		addInvestorsValue(_addInvestorsValue);
339 		totalPot -= _addInvestorsValue;
340 		if (hit3Count > 0) {
341 			games[currentGame].prizePot += currentJackpot;
342 			for ( a=0 ; a < investors.length ; a++ ) {
343 				delete investors[a].live;
344 			}
345 			hit3Value = currentJackpot / hit3Count;
346 			extraJackpot = 0;
347 			investmentsValue = 0;
348 		}
349 		extraJackpot += totalPot;
350 		setJackpot();
351 		DrawEvent(currentGame+oldContractLastGame, numbers[0], numbers[1], numbers[2], hit3Count, hit3Value, hit2Count, hit2Value);
352 		WLBDrawsDB( WLBdrawsDBAddr ).newDraw( now, numbers, hit3Count, hit3Value, hit2Count, hit2Value);
353 		games[currentGame].hit3Count = hit3Count;
354 		games[currentGame].hit3Value = hit3Value;
355 		games[currentGame].hit2Count = hit2Count;
356 		games[currentGame].hit2Value = hit2Value;
357 		games[currentGame].drawDone = true;
358 		newGame();
359 	}
360 	/* owner functions */
361 	function OwnerGetFee() external OnlyOwner {
362 		if (ownerBalance == 0) { throw; }
363 		if (owner.send(ownerBalance) == false) { throw; }
364 		ownerBalance = 0;
365 	}
366 	function OwnerCloseContract() external OnlyOwner noEther {
367 		if ( ! contractEnabled) {
368 			if (contractDisabledTimeStamp+contractDismissDelay < now) {
369 				suicide(owner);
370 			}
371 		} else {
372 			contractEnabled = false;
373 			contractDisabledTimeStamp = now;
374 			ContractDisabledEvent(contractDisabledTimeStamp+contractDismissDelay);
375 			ownerBalance += extraJackpot;
376 			extraJackpot = 0;
377 			games[currentGame].prizePot = games[currentGame].ticketsCount*ticketPrice;
378 		}
379 	}
380 	/* private functions */
381 	function addInvestorsValue(uint value) private {
382 		bool done;
383 		uint a;
384 		for ( a=0 ; a < investors.length ; a++ ) {
385 			if (investors[a].live && investors[a].valid) {
386 				investors[a].balance += value * investors[a].value / investmentsValue;
387 				done = true;
388 			}
389 		}
390 		if ( ! done) {
391 			ownerBalance += value;
392 		}
393 	}
394 	function newGame() private {
395 		var nextDraw = games[currentGame].endTimestamp  + 1 weeks;
396 		currentGame++;
397 		uint gamesID = games.length;
398 		games.length++;
399 		games[gamesID].startTimestamp = now;
400 		games[gamesID].endTimestamp = nextDraw;
401 		if (games.length > prizeDismissDelay) {
402 			ownerBalance += games[currentGame-prizeDismissDelay].prizePot;
403 			delete games[currentGame-prizeDismissDelay];
404 		}
405 	}
406 	function getNumbersFromHash(bytes32 hash) private returns (uint8[3] numbers) {
407 		bool ok = true;
408 		uint8 num = 0;
409 		uint hashpos = 0;
410 		uint8 a;
411 		uint8 b;
412 		for (a = 0 ; a < numbers.length ; a++) {
413 			while (true) {
414 				ok = true;
415 				if (hashpos == 32) {
416 					hashpos = 0;
417 					hash = sha3(hash);
418 				}
419 				num = getPart( hash, hashpos );
420 				num = num % uint8(drawMaxNumber) + 1;
421 				hashpos += 1;
422 				for (b = 0 ; b < numbers.length ; b++) {
423 					if (numbers[b] == num) {
424 						ok = false;
425 						break; 
426 					}
427 				}
428 				if (ok == true) {
429 					numbers[a] = num;
430 					break;
431 				}
432 			}
433 		}
434 		numbers = sortNumbers( numbers );
435 	}
436 	function getPart(bytes32 a, uint i) private returns (uint8) { return uint8(byte(bytes32(uint(a) * 2 ** (8 * i)))); }
437 	function setJackpot() private {
438 		currentJackpot = investmentsValue + extraJackpot;
439 	}
440 	function getInvestorByAddress(address Address) private returns (bool found, uint id) {
441 		for ( id=0 ; id < investors.length ; id++ ) {
442 			if (investors[id].owner == Address) {
443 				return (true, id);
444 			}
445 		}
446 		return (false, 0);
447 	}
448 	function checkNumbers(uint8[3] Numbers) private returns (bool) {
449 		for ( uint a = 0 ; a < Numbers.length ; a++ ) {
450 			if (Numbers[a] > drawMaxNumber || Numbers[a] == 0) { return; }
451 			for ( uint b = 0 ; a < Numbers.length ; a++ ) {
452 				if (a != b && Numbers[a] == Numbers[b]) { return; }
453 			}
454 		}
455 		return true;
456 	}
457 	function sortNumbers(uint8[3] numbers) private returns(uint8[3] sNumbers) {
458 		sNumbers = numbers;
459 		for (uint8 i=0; i<numbers.length; i++) {
460 			for (uint8 j=i+1; j<numbers.length; j++) {
461 				if (sNumbers[i] > sNumbers[j]) {
462 					uint8 t = sNumbers[i];
463 					sNumbers[i] = sNumbers[j];
464 					sNumbers[j] = t;
465 				}
466 			}
467 		}
468 	}
469 	function getNumbersFromBytes(bytes3 Bytes) private returns (uint8[3] Numbers){
470 		Numbers[0] = uint8(Bytes);
471 		Numbers[1] = uint8(uint24(Bytes) /256);
472 		Numbers[2] = uint8(uint24(Bytes) /256/256);
473 	}
474 	function getBytesFromNumbers(uint8[3] Numbers) private returns (bytes3 Bytes) {
475 		return bytes3(uint(Numbers[0])+uint(Numbers[1])*256+uint(Numbers[2])*256*256);
476 	}
477 	/* modifiers */
478 	modifier noContract() {if (tx.origin != msg.sender) { throw; } _ }
479 	modifier noEther() { if (msg.value > 0) { throw; } _ }
480 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
481 	modifier OnlyEnabled() { if ( ! contractEnabled) { throw; } _ }
482 }