1 /*
2 	WeeklyLotteryB
3 	Coded by: iFA
4 	http://wlb.ethereumlottery.net
5 	ver: 1.3
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
91 	uint private constant drawBlockLimit = 128;
92 	uint private constant contractDismissDelay = 5 weeks;
93 	uint private constant investUnit = 1 ether;
94 	uint private constant investMinimum = 10 ether;
95 	uint private constant investUserLimit = 200;
96 	uint private constant investMinDuration = 5; // 5 draw!
97 	uint private constant investIdleTime = 1 days;
98 	uint private constant forOwner = 2; //%
99 	uint private constant forInvestors = 40; //%
100 	uint private constant forHit2 = 30; //%
101 	/* variables */
102 	address private WLBdrawsDBAddr;
103 	address private owner;
104 	uint private currentJackpot;
105 	uint private investmentsValue;
106 	uint private extraJackpot;
107 	uint private ticketCounter;
108 	uint private currentGame;
109 	uint private ownerBalance;
110 	uint private oldContractLastGame;
111 	bool public contractEnabled = true;
112 	uint private contractDisabledTimeStamp;
113 	mapping(address => players_s) private players;
114 	games_s[] private games;
115 	investors_s[] private investors;
116 	/* events */
117 	event NewTicketEvent(address Player, uint8 Number1, uint8 Number2, uint8 Number3);
118 	event ContractDisabledEvent(uint DeadlineTime);
119 	event DrawPrepareEvent(uint BlockNumber);
120 	event DrawEvent(uint GameID, uint8 Number1, uint8 Number2, uint8 Number3, uint Hit3Count, uint Hit3Value, uint Hit2Count, uint Hit2Value);
121 	event InvestAddEvent(address Investor, uint Value);
122 	event InvestCancelEvent(address Investor, uint Value);
123 	/* constructor */
124 	function WeeklyLotteryB(address _WLBdrawsDBAddr, uint _oldContractLastGame) {
125 		WLBdrawsDBAddr = _WLBdrawsDBAddr;
126 		owner = msg.sender;
127 		currentGame = 0;
128 		oldContractLastGame = _oldContractLastGame;
129 		games.length = 1;
130 		games[0].startTimestamp = now;
131 		uint ret = 1470571200;
132 		while (ret < now) {
133 			ret += 1 weeks;
134 		}
135 		games[0].endTimestamp = ret;
136 	}
137 	/* constant functions */
138 	function Visit() constant returns (string) { return "http://wlb.ethereumlottery.net"; }
139 	function Draws(uint id) constant returns (uint date, uint8[3] Numbers, uint hit3Count, uint hit3Value, uint hit2Count, uint hit2Value) {
140 		return WLBDrawsDB( WLBdrawsDBAddr ).getDraw(id);
141 	}
142 	function CurrentGame() constant returns (uint GameID, uint Jackpot, uint Start, uint End, uint Tickets) {
143 		return (currentGame+oldContractLastGame, currentJackpot, games[currentGame].startTimestamp, games[currentGame].endTimestamp, games[currentGame].ticketsCount);
144 	}
145 	function PlayerTickets(address Player, uint GameID, uint TicketID) constant returns (uint8[3] numbers, bool Checked) {
146 		GameID -= oldContractLastGame;
147 		return ( getNumbersFromBytes( players[Player].games[GameID].numbersBytes[TicketID] ), players[Player].games[GameID].checked);
148 	}
149 	function Investors(address Address) constant returns(uint Investment, uint Balance, bool Live) {
150 		var (found, InvestorID) = getInvestorByAddress(Address);
151 		if (found == false || ! investors[InvestorID].valid) {
152 			return (0, 0, false);
153 		}
154 		return (investors[InvestorID].value, investors[InvestorID].balance, investors[InvestorID].live);
155 	}
156 	function CheckPrize(address Address) constant returns(uint value) {
157 		uint gameID;
158 		uint gameLowID;
159 		uint8[3] memory numbers;
160 		uint hit3Count;
161 		uint hit2Count;
162 		for ( gameID=currentGame ; gameID>=0 ; gameID-- ) {
163 			if ( ! players[Address].games[gameID].checked) {
164 				if (games[gameID].drawDone) {
165 					numbers = getNumbersFromBytes(games[gameID].winningNumbersBytes);
166 					hit3Count = players[Address].games[gameID].hit3Hash[sha3( numbers[0], numbers[1], numbers[2] )];
167 					value += hit3Count * games[gameID].hit3Value;
168 					hit2Count = players[Address].games[gameID].hit2Hash[sha3( numbers[0], numbers[1] )];
169 					hit2Count += players[Address].games[gameID].hit2Hash[sha3( numbers[0], numbers[2] )];
170 					hit2Count += players[Address].games[gameID].hit2Hash[sha3( numbers[1], numbers[2] )];
171 					hit2Count -= hit3Count*3;
172 					value += hit2Count * games[gameID].hit2Value;
173 				} else if ( ! contractEnabled && gameID == currentGame) {
174 					value += players[Address].games[gameID].numbersBytes.length * ticketPrice;
175 				}
176 			}
177 			if (gameID == 0 || gameID-prizeDismissDelay == gameID) { break; }
178 		}
179 	}
180 	/* callback function */
181 	function () {
182 		var Numbers = getNumbersFromHash(sha3(block.coinbase, now, ticketCounter));
183 		CreateTicket(msg.sender, Numbers[0], Numbers[1], Numbers[2]);
184 	}
185 	/* external functions for players */
186 	function BuyTicket(uint8 Number1, uint8 Number2, uint8 Number3) external {
187 	    CreateTicket(msg.sender, Number1, Number2, Number3);
188 	}
189 	function CheckTickets() external noEther noContract {
190 		uint _value;
191 		uint _subValue;
192 		uint gameID;
193 		uint gameLowID;
194 		uint8[3] memory numbers;
195 		bool changed;
196 		uint hit3Count;
197 		uint hit2Count;
198 		for ( gameID=currentGame ; gameID>=0 ; gameID-- ) {
199 			if ( ! players[msg.sender].games[gameID].checked) {
200 				if (games[gameID].drawDone) {
201 					numbers = getNumbersFromBytes(games[gameID].winningNumbersBytes);
202 					hit3Count = players[msg.sender].games[gameID].hit3Hash[sha3( numbers[0], numbers[1], numbers[2] )];
203 					_subValue += hit3Count * games[gameID].hit3Value;
204 					hit2Count = players[msg.sender].games[gameID].hit2Hash[sha3( numbers[0], numbers[1] )];
205 					hit2Count += players[msg.sender].games[gameID].hit2Hash[sha3( numbers[0], numbers[2] )];
206 					hit2Count += players[msg.sender].games[gameID].hit2Hash[sha3( numbers[1], numbers[2] )];
207 					hit2Count -= hit3Count*3;
208 					_subValue += hit2Count * games[gameID].hit2Value;
209 					games[gameID].prizePot -= _subValue;
210 					_value += _subValue;
211 					players[msg.sender].games[gameID].checked = true;
212 					changed = true;
213 				} else if ( ! contractEnabled && gameID == currentGame) {
214 					_value += players[msg.sender].games[gameID].numbersBytes.length * ticketPrice;
215 					players[msg.sender].games[gameID].checked = true;
216 					changed = true;
217 				}
218 			}
219 			if (gameID == 0 || gameID-prizeDismissDelay == gameID) { break; }
220 		}
221 		if ( ! changed) { throw; }
222 		if (_value > 0) { if ( ! msg.sender.send(_value)) { throw; } }
223 	}
224 	function BuyTicketForOther(address Address, uint8 Number1, uint8 Number2, uint8 Number3) external {
225 	    if (Address == 0x0) { throw; }
226 	    CreateTicket(Address, Number1, Number2, Number3);
227 	}
228 	/* external functions for investors */
229 	function InvestAdd() external OnlyEnabled noContract {
230 		uint value_ = msg.value;
231 		if (value_ < investUnit) { throw; }
232 		if (value_ % investUnit > 0) { 
233 			if ( ! msg.sender.send( value_ % investUnit )) { throw; } 
234 			value_ = value_ - (value_ % investUnit);
235 		}
236 		if (value_ < investMinimum) { throw; }
237 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
238 		if (found == false) {
239 			if (investors.length == investUserLimit) { throw; }
240 			InvestorID = investors.length;
241 			investors.length++;
242 		}
243 		if (investors[InvestorID].valid && investors[InvestorID].live) {
244 			investors[InvestorID].value += value_;
245 		} else {
246 			investors[InvestorID].value = value_;
247 		}
248 		investors[InvestorID].begins = currentGame;
249 		investors[InvestorID].valid = true;
250 		investors[InvestorID].live = true;
251 		investors[InvestorID].owner = msg.sender;
252 		investmentsValue += value_;
253 		setJackpot();
254 		InvestAddEvent(msg.sender, value_);
255 	}
256 	function InvestWithdraw() external noEther {
257 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
258 		if (found == false) { throw; }
259 		if ( ! investors[InvestorID].valid) { throw; }
260 		uint _balance = investors[InvestorID].balance;
261 		if (_balance == 0) { throw; }
262 		investors[InvestorID].balance = 0;
263 		if ( ! msg.sender.send( _balance )) { throw; }
264 	}
265 	function InvestCancel() external noEther {
266 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
267 		if (found == false) { throw; }
268 		if ( ! investors[InvestorID].valid) { throw; }
269 		if (contractEnabled) {
270 			if (investors[InvestorID].begins+investMinDuration < now) { throw; }
271 			if (games[currentGame].startTimestamp+investIdleTime < now) { throw; }
272 		}
273 		uint balance_;
274 		if (investors[InvestorID].live) {
275 			investmentsValue -= investors[InvestorID].value;
276 			balance_ = investors[InvestorID].value;
277 			setJackpot();
278 			InvestCancelEvent(msg.sender, investors[InvestorID].value);
279 		}
280 		if (investors[InvestorID].balance > 0) {
281 			balance_ += investors[InvestorID].balance;
282 		}
283 		delete investors[InvestorID];
284 		if ( ! msg.sender.send( balance_ )) { throw; }
285 	}
286 	/* draw functions for everyone*/
287 	function DrawPrepare() noContract OnlyEnabled noEther {
288 		if (games[currentGame].endTimestamp > now || (games[currentGame].prepareBlock != 0 && games[currentGame].prepareBlock+(drawBlockLimit-drawBlockDelay) > block.number)) { throw; }
289 		games[currentGame].prepareBlock = block.number+drawBlockDelay;
290 		DrawPrepareEvent(games[currentGame].prepareBlock);
291 	}
292 	function Draw() noContract OnlyEnabled noEther {
293 		if (games[currentGame].prepareBlock == 0 || games[currentGame].prepareBlock > block.number || games[currentGame].prepareBlock+(drawBlockLimit-drawBlockDelay) <= block.number) { throw; }
294 		bytes32 _hash;
295 		uint hit3Value;
296 		uint hit3Count;
297 		uint hit2Value;
298 		uint hit2Count;
299 		uint a;
300 		for ( a = 1 ; a <= drawBlockDelay ; a++ ) {
301 			_hash = sha3(_hash, block.blockhash(games[currentGame].prepareBlock - drawBlockDelay+a));
302 		}
303 		var numbers = getNumbersFromHash(_hash);
304 		games[currentGame].winningNumbersBytes = getBytesFromNumbers( numbers );
305 		hit3Count += games[currentGame].hit3Hash[ sha3( numbers[0], numbers[1],numbers[2] ) ];
306 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[0], numbers[1]) ];
307 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[0], numbers[2]) ];
308 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[1], numbers[2]) ];
309 		hit2Count -= hit3Count*3;
310 		uint totalPot = games[currentGame].ticketsCount*ticketPrice;
311 		hit2Value = ( totalPot * forHit2 / 100 );
312 		if (hit2Count > 0) {
313 			games[currentGame].prizePot = hit2Value;
314 		}
315 		hit2Value = hit2Value / hit2Count;
316 		totalPot -= hit2Value;
317 		uint _ownerBalance = totalPot * forOwner / 100;
318 		totalPot -= _ownerBalance;
319 		ownerBalance += _ownerBalance;
320 		uint _addInvestorsValue = totalPot * forInvestors / 100;
321 		addInvestorsValue(_addInvestorsValue);
322 		totalPot -= _addInvestorsValue;
323 		if (hit3Count > 0) {
324 			games[currentGame].prizePot += currentJackpot;
325 			for ( a=0 ; a < investors.length ; a++ ) {
326 				delete investors[a].live;
327 			}
328 			hit3Value = currentJackpot / hit3Count;
329 			extraJackpot = 0;
330 			investmentsValue = 0;
331 		}
332 		extraJackpot += totalPot;
333 		DrawEvent(currentGame+oldContractLastGame, numbers[0], numbers[1], numbers[2], hit3Count, hit3Value, hit2Count, hit2Value);
334 		WLBDrawsDB( WLBdrawsDBAddr ).newDraw( now, numbers, hit3Count, hit3Value, hit2Count, hit2Value);
335 		games[currentGame].hit3Count = hit3Count;
336 		games[currentGame].hit3Value = hit3Value;
337 		games[currentGame].hit2Count = hit2Count;
338 		games[currentGame].hit2Value = hit2Value;
339 		games[currentGame].drawDone = true;
340 		newGame();
341 		setJackpot();
342 	}
343 	/* owner functions */
344 	function OwnerGetFee() external OnlyOwner {
345 		if (ownerBalance == 0) { throw; }
346 		if (owner.send(ownerBalance) == false) { throw; }
347 		ownerBalance = 0;
348 	}
349 	function OwnerCloseContract() external OnlyOwner noEther {
350 		if ( ! contractEnabled) {
351 			if (contractDisabledTimeStamp+contractDismissDelay < now) {
352 				suicide(owner);
353 			}
354 		} else {
355 			contractEnabled = false;
356 			contractDisabledTimeStamp = now;
357 			ContractDisabledEvent(contractDisabledTimeStamp+contractDismissDelay);
358 			ownerBalance += extraJackpot;
359 			extraJackpot = 0;
360 			games[currentGame].prizePot = games[currentGame].ticketsCount*ticketPrice;
361 		}
362 	}
363 	/* private functions */
364     function CreateTicket(address Addr, uint8 Number1, uint8 Number2, uint8 Number3) private noContract OnlyEnabled {
365 		var Numbers = [Number1 , Number2 , Number3];
366 		if ( ! checkNumbers( Numbers )) { throw; }
367 		Numbers = sortNumbers(Numbers);
368 		if (msg.value < ticketPrice) { throw; }
369 		if (msg.value-ticketPrice > 0) { if ( ! Addr.send( msg.value-ticketPrice )) { throw; } }
370 		if (currentJackpot == 0) { throw; }
371 		if (games[currentGame].endTimestamp < now) { throw; }
372 		ticketCounter++;
373 		games[currentGame].ticketsCount++;
374 		bytes32 hash0 = sha3( Numbers[0], Numbers[1], Numbers[2] );
375 		bytes32 hash1 = sha3( Numbers[0], Numbers[1]);
376 		bytes32 hash2 = sha3( Numbers[0], Numbers[2]);
377 		bytes32 hash3 = sha3( Numbers[1], Numbers[2]);
378 		games[currentGame].hit3Hash[hash0]++;
379 		games[currentGame].hit2Hash[hash1]++;
380 		games[currentGame].hit2Hash[hash2]++;
381 		games[currentGame].hit2Hash[hash3]++;
382 		players[Addr].games[currentGame].numbersBytes.push ( getBytesFromNumbers(Numbers) );
383 		players[Addr].games[currentGame].hit3Hash[hash0]++;
384 		players[Addr].games[currentGame].hit2Hash[hash1]++;
385 		players[Addr].games[currentGame].hit2Hash[hash2]++;
386 		players[Addr].games[currentGame].hit2Hash[hash3]++;
387 		NewTicketEvent( Addr, Numbers[0], Numbers[1], Numbers[2] );
388 	}
389 	function addInvestorsValue(uint value) private {
390 		bool done;
391 		uint a;
392 		for ( a=0 ; a < investors.length ; a++ ) {
393 			if (investors[a].live && investors[a].valid) {
394 				investors[a].balance += value * investors[a].value / investmentsValue;
395 				done = true;
396 			}
397 		}
398 		if ( ! done) {
399 			ownerBalance += value;
400 		}
401 	}
402 	function newGame() private {
403 		var nextDraw = games[currentGame].endTimestamp  + 1 weeks;
404 		currentGame++;
405 		uint gamesID = games.length;
406 		games.length++;
407 		games[gamesID].startTimestamp = now;
408 		games[gamesID].endTimestamp = nextDraw;
409 		if (games.length > prizeDismissDelay) {
410             extraJackpot += games[currentGame-prizeDismissDelay].prizePot;
411 			delete games[currentGame-prizeDismissDelay];
412 		}
413 	}
414 	function getNumbersFromHash(bytes32 hash) private returns (uint8[3] numbers) {
415 		bool ok = true;
416 		uint8 num = 0;
417 		uint hashpos = 0;
418 		uint8 a;
419 		uint8 b;
420 		for (a = 0 ; a < numbers.length ; a++) {
421 			while (true) {
422 				ok = true;
423 				if (hashpos == 32) {
424 					hashpos = 0;
425 					hash = sha3(hash);
426 				}
427 				num = getPart( hash, hashpos );
428 				num = num % uint8(drawMaxNumber) + 1;
429 				hashpos += 1;
430 				for (b = 0 ; b < numbers.length ; b++) {
431 					if (numbers[b] == num) {
432 						ok = false;
433 						break; 
434 					}
435 				}
436 				if (ok == true) {
437 					numbers[a] = num;
438 					break;
439 				}
440 			}
441 		}
442 		numbers = sortNumbers( numbers );
443 	}
444 	function getPart(bytes32 a, uint i) private returns (uint8) { return uint8(byte(bytes32(uint(a) * 2 ** (8 * i)))); }
445 	function setJackpot() private {
446 		currentJackpot = investmentsValue + extraJackpot;
447 	}
448 	function getInvestorByAddress(address Address) private returns (bool found, uint id) {
449 		for ( id=0 ; id < investors.length ; id++ ) {
450 			if (investors[id].owner == Address) {
451 				return (true, id);
452 			}
453 		}
454 		return (false, 0);
455 	}
456 	function checkNumbers(uint8[3] Numbers) private returns (bool) {
457 		for ( uint a = 0 ; a < Numbers.length ; a++ ) {
458 			if (Numbers[a] > drawMaxNumber || Numbers[a] == 0) { return; }
459 			for ( uint b = 0 ; a < Numbers.length ; a++ ) {
460 				if (a != b && Numbers[a] == Numbers[b]) { return; }
461 			}
462 		}
463 		return true;
464 	}
465 	function sortNumbers(uint8[3] numbers) private returns(uint8[3] sNumbers) {
466 		sNumbers = numbers;
467 		for (uint8 i=0; i<numbers.length; i++) {
468 			for (uint8 j=i+1; j<numbers.length; j++) {
469 				if (sNumbers[i] > sNumbers[j]) {
470 					uint8 t = sNumbers[i];
471 					sNumbers[i] = sNumbers[j];
472 					sNumbers[j] = t;
473 				}
474 			}
475 		}
476 	}
477 	function getNumbersFromBytes(bytes3 Bytes) private returns (uint8[3] Numbers){
478 		Numbers[0] = uint8(Bytes);
479 		Numbers[1] = uint8(uint24(Bytes) /256);
480 		Numbers[2] = uint8(uint24(Bytes) /256/256);
481 	}
482 	function getBytesFromNumbers(uint8[3] Numbers) private returns (bytes3 Bytes) {
483 		return bytes3(uint(Numbers[0])+uint(Numbers[1])*256+uint(Numbers[2])*256*256);
484 	}
485 	/* modifiers */
486 	modifier noContract() {if (tx.origin != msg.sender) { throw; } _ }
487 	modifier noEther() { if (msg.value > 0) { throw; } _ }
488 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
489 	modifier OnlyEnabled() { if ( ! contractEnabled) { throw; } _ }
490 }