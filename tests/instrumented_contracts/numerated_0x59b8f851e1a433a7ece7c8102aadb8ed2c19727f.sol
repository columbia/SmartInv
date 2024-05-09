1 /*
2 	WeeklyLotteryB
3 	Coded by: iFA
4 	http://wlb.ethereumlottery.net
5 	ver: 1.1
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
25 		uint hit3Count;
26 		uint hit3Value;
27 		uint hit2Count;
28 		uint hit2Value;
29 	}
30 	struct playerGames_s {
31 		bytes3[] numbersBytes;
32 		mapping(bytes32 => uint) hit3Hash;
33 		mapping(bytes32 => uint) hit2Hash;
34 		bool checked;
35 	}
36 	struct players_s {
37 		mapping(uint => playerGames_s) games;
38 	}
39 	struct investors_s {
40 		address owner;
41 		uint value;
42 		uint balance;
43 		bool live;
44 		bool valid;
45 		uint begins;
46 	}
47 	struct draws_s {
48 		uint date;
49 		uint gameID;
50 		bytes3 numbersBytes;
51 		uint hit3Count;
52 		uint hit3Value;
53 		uint hit2Count;
54 		uint hit2Value;
55 	}
56 	/* config */
57 	uint public constant ticketPrice = 100 finney; // 0.1 ether
58 	uint private constant drawMaxNumber = 50;
59 	uint private constant drawBlockDelay = 5;
60 	uint private constant prizeDismissDelay = 5;
61 	uint private constant contractDismissDelay = 5 weeks;
62 	uint private constant investUnit = 1 ether;
63 	uint private constant investMinimum = 10 ether;
64 	uint private constant investUserLimit = 200;
65 	uint private constant investMinDuration = 5; // 5 draw!
66 	uint private constant investIdleTime = 1 days;
67 	uint private constant forOwner = 2; //%
68 	uint private constant forInvestors = 40; //%
69 	uint private constant forHit2 = 30; //%
70 	/* variables */
71 	address private WLBdrawsDB;
72 	address private owner;
73 	uint private currentJackpot;
74 	uint private investmentsValue;
75 	uint private extraJackpot;
76 	uint private ticketCounter;
77 	uint private currentGame;
78 	uint private ownerBalance;
79 	bool public contractEnabled = true;
80 	uint private contractDisabledTimeStamp;
81 	mapping(address => players_s) private players;
82 	games_s[] private games;
83 	investors_s[] private investors;
84 	/* events */
85 	event NewTicketEvent(address Player, uint8 Number1, uint8 Number2, uint8 Number3);
86 	event ContractDisabledEvent(uint DeadlineTime);
87 	event DrawPrepareEvent(uint BlockNumber);
88 	event DrawEvent(uint GameID, uint8 Number1, uint8 Number2, uint8 Number3, uint Hit3Count, uint Hit3Value, uint Hit2Count, uint Hit2Value);
89 	event InvestAddEvent(address Investor, uint Value);
90 	event InvestCancelEvent(address Investor, uint Value);
91 	/* constructor */
92 	function WeeklyLotteryB(address _WLBdrawsDB) {
93 		WLBdrawsDB = _WLBdrawsDB;
94 		owner = msg.sender;
95 		currentGame = 1;
96 		games.length = 2;
97 		games[1].startTimestamp = now;
98 		games[1].endTimestamp = calcNextDrawTime();
99 	}
100 	/* constant functions */
101 	function Visit() constant returns (string) { return "http://wlb.ethereumlottery.net"; }
102 	function Draws(uint id) constant returns (uint date, uint8[3] Numbers, uint hit3Count, uint hit3Value, uint hit2Count, uint hit2Value) {
103 		return WLBdrawsDBInterface( WLBdrawsDB ).getDraw(id);
104 	}
105 	function CurrentGame() constant returns (uint GameID, uint Jackpot, uint Start, uint End, uint Tickets) {
106 		return (currentGame, currentJackpot, games[currentGame].startTimestamp, games[currentGame].endTimestamp, games[currentGame].ticketsCount);
107 	}
108 	function PlayerTickets(address Player, uint GameID, uint TicketID) constant returns (uint8[3] numbers, bool Checked) {
109 		return ( getNumbersFromBytes( players[Player].games[GameID].numbersBytes[TicketID] ), players[Player].games[GameID].checked);
110 	}
111 	function Investors(address Address) constant returns(uint Investment, uint Balance, bool Live) {
112 		var (found, InvestorID) = getInvestorByAddress(Address);
113 		if (found == false || ! investors[InvestorID].valid) {
114 			return (0, 0, false);
115 		}
116 		return (investors[InvestorID].value, investors[InvestorID].balance, investors[InvestorID].live);
117 	}
118 	function CheckPrize(address Address) constant returns(uint value) {
119 		uint gameID;
120 		uint gameLowID;
121 		uint8[3] memory numbers;
122 		uint hit3Count;
123 		uint hit2Count;
124 		if (currentGame < prizeDismissDelay) {
125 			gameLowID = 1;
126 		} else {
127 			gameLowID = currentGame-prizeDismissDelay;
128 		}
129 		for ( gameID=currentGame ; gameID>=gameLowID ; gameID-- ) {
130 			if ( ! players[Address].games[gameID].checked) {
131 				if (games[gameID].drawDone) {
132 					numbers = getNumbersFromBytes(games[gameID].winningNumbersBytes);
133 					hit3Count = players[Address].games[gameID].hit3Hash[sha3( numbers[0], numbers[1], numbers[2] )];
134 					value += hit3Count * games[gameID].hit3Value;
135 					hit2Count = players[Address].games[gameID].hit2Hash[sha3( numbers[0], numbers[1] )];
136 					hit2Count += players[Address].games[gameID].hit2Hash[sha3( numbers[0], numbers[2] )];
137 					hit2Count += players[Address].games[gameID].hit2Hash[sha3( numbers[1], numbers[2] )];
138 					hit2Count -= hit3Count*3;
139 					value += hit2Count * games[gameID].hit2Value;
140 				} else if ( ! contractEnabled && gameID == currentGame) {
141 					value += players[Address].games[gameID].numbersBytes.length * ticketPrice;
142 				}
143 			}
144 		}
145 	}
146 	/* callback function */
147 	function () {
148 		var Numbers = getNumbersFromHash(sha3(block.coinbase, now, ticketCounter));
149 		BuyTicket(Numbers[0],Numbers[1],Numbers[2]);
150 	}
151 	/* external functions for players */
152 	function BuyTicket(uint8 Number1, uint8 Number2, uint8 Number3) noContract OnlyEnabled {
153 		var Numbers = [Number1 , Number2 , Number3];
154 		if ( ! checkNumbers( Numbers )) { throw; }
155 		Numbers = sortNumbers(Numbers);
156 		if (msg.value < ticketPrice) { throw; }
157 		if (msg.value-ticketPrice > 0) { if ( ! msg.sender.send( msg.value-ticketPrice )) { throw; } }
158 		if (currentJackpot == 0) { throw; }
159 		if (games[currentGame].endTimestamp < now) { throw; }
160 		ticketCounter++;
161 		games[currentGame].ticketsCount++;
162 		bytes32 hash0 = sha3( Numbers[0], Numbers[1], Numbers[2] );
163 		bytes32 hash1 = sha3( Numbers[0], Numbers[1]);
164 		bytes32 hash2 = sha3( Numbers[0], Numbers[2]);
165 		bytes32 hash3 = sha3( Numbers[1], Numbers[2]);
166 		games[currentGame].hit3Hash[hash0]++;
167 		games[currentGame].hit2Hash[hash1]++;
168 		games[currentGame].hit2Hash[hash2]++;
169 		games[currentGame].hit2Hash[hash3]++;
170 		players[msg.sender].games[currentGame].numbersBytes.push ( getBytesFromNumbers(Numbers) );
171 		players[msg.sender].games[currentGame].hit3Hash[hash0]++;
172 		players[msg.sender].games[currentGame].hit2Hash[hash1]++;
173 		players[msg.sender].games[currentGame].hit2Hash[hash2]++;
174 		players[msg.sender].games[currentGame].hit2Hash[hash3]++;
175 		NewTicketEvent( msg.sender, Numbers[0], Numbers[1], Numbers[2] );
176 	}
177 	function CheckTickets() external noEther noContract {
178 		uint _value;
179 		uint _subValue;
180 		uint gameID;
181 		uint gameLowID;
182 		uint8[3] memory numbers;
183 		bool changed;
184 		uint hit3Count;
185 		uint hit2Count;
186 		if (currentGame < prizeDismissDelay) {
187 			gameLowID = 1;
188 		} else {
189 			gameLowID = currentGame-prizeDismissDelay;
190 		}
191 		for ( gameID=currentGame ; gameID>=gameLowID ; gameID-- ) {
192 			if ( ! players[msg.sender].games[gameID].checked) {
193 				if (games[gameID].drawDone) {
194 					numbers = getNumbersFromBytes(games[gameID].winningNumbersBytes);
195 					hit3Count = players[msg.sender].games[gameID].hit3Hash[sha3( numbers[0], numbers[1], numbers[2] )];
196 					_subValue += hit3Count * games[gameID].hit3Value;
197 					hit2Count = players[msg.sender].games[gameID].hit2Hash[sha3( numbers[0], numbers[1] )];
198 					hit2Count += players[msg.sender].games[gameID].hit2Hash[sha3( numbers[0], numbers[2] )];
199 					hit2Count += players[msg.sender].games[gameID].hit2Hash[sha3( numbers[1], numbers[2] )];
200 					hit2Count -= hit3Count*3;
201 					_subValue += hit2Count * games[gameID].hit2Value;
202 					games[gameID].prizePot -= _subValue;
203 					_value += _subValue;
204 					players[msg.sender].games[gameID].checked = true;
205 					changed = true;
206 				} else if ( ! contractEnabled && gameID == currentGame) {
207 					_value += players[msg.sender].games[gameID].numbersBytes.length * ticketPrice;
208 					players[msg.sender].games[gameID].checked = true;
209 					changed = true;
210 				}
211 			}
212 		}
213 		if ( ! changed) { throw; }
214 		if (_value > 0) { if ( ! msg.sender.send(_value)) { throw; } }
215 	}
216 	/* external functions for investors */
217 	function InvestAdd() external OnlyEnabled noContract {
218 		uint value_ = msg.value;
219 		if (value_ < investUnit) { throw; }
220 		if (value_ % investUnit > 0) { 
221 			if ( ! msg.sender.send( value_ % investUnit )) { throw; } 
222 			value_ = value_ - (value_ % investUnit);
223 		}
224 		if (value_ < investMinimum) { throw; }
225 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
226 		if (found == false) {
227 			if (investors.length == investUserLimit) { throw; }
228 			InvestorID = investors.length;
229 			investors.length++;
230 		}
231 		if (investors[InvestorID].valid && investors[InvestorID].live) {
232 			investors[InvestorID].value += value_;
233 		} else {
234 			investors[InvestorID].value = value_;
235 		}
236 		investors[InvestorID].begins = currentGame;
237 		investors[InvestorID].valid = true;
238 		investors[InvestorID].live = true;
239 		investors[InvestorID].owner = msg.sender;
240 		investmentsValue += value_;
241 		setJackpot();
242 		InvestAddEvent(msg.sender, value_);
243 	}
244 	function InvestWithdraw() external noEther {
245 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
246 		if (found == false) { throw; }
247 		if ( ! investors[InvestorID].valid) { throw; }
248 		uint _balance = investors[InvestorID].balance;
249 		if (_balance == 0) { throw; }
250 		investors[InvestorID].balance = 0;
251 		if ( ! msg.sender.send( _balance )) { throw; }
252 	}
253 	function InvestCancel() external noEther {
254 		var (found, InvestorID) = getInvestorByAddress(msg.sender);
255 		if (found == false) { throw; }
256 		if ( ! investors[InvestorID].valid) { throw; }
257 		if (contractEnabled) {
258 			if (investors[InvestorID].begins+investMinDuration > now) { throw; }
259 			if (games[currentGame].startTimestamp+investIdleTime > now) { throw; }
260 		}
261 		uint balance_;
262 		if (investors[InvestorID].live) {
263 			investmentsValue -= investors[InvestorID].value;
264 			balance_ = investors[InvestorID].value;
265 			setJackpot();
266 			InvestCancelEvent(msg.sender, investors[InvestorID].value);
267 		}
268 		if (investors[InvestorID].balance > 0) {
269 			balance_ += investors[InvestorID].balance;
270 		}
271 		delete investors[InvestorID];
272 		if ( ! msg.sender.send( balance_ )) { throw; }
273 	}
274 	/* draw functions for everyone*/
275 	function DrawPrepare() noContract OnlyEnabled noEther {
276 		if (games[currentGame].endTimestamp > now || games[currentGame].prepareBlock != 0) { throw; }
277 		games[currentGame].prepareBlock = block.number+drawBlockDelay;
278 		DrawPrepareEvent(games[currentGame].prepareBlock);
279 	}
280 	function Draw() noContract OnlyEnabled noEther {
281 		if (games[currentGame].prepareBlock == 0 || games[currentGame].prepareBlock > block.number) { throw; }
282 		bytes32 _hash;
283 		uint hit3Value;
284 		uint hit3Count;
285 		uint hit2Value;
286 		uint hit2Count;
287 		uint a;
288 		for ( a = 1 ; a <= drawBlockDelay ; a++ ) {
289 			_hash = sha3(_hash, block.blockhash(games[currentGame].prepareBlock - drawBlockDelay+a));
290 		}
291 		var numbers = getNumbersFromHash(_hash);
292 		games[currentGame].winningNumbersBytes = getBytesFromNumbers( numbers );
293 		hit3Count += games[currentGame].hit3Hash[ sha3( numbers[0], numbers[1],numbers[2] ) ];
294 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[0], numbers[1]) ];
295 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[0], numbers[2]) ];
296 		hit2Count += games[currentGame].hit2Hash[ sha3( numbers[1], numbers[2]) ];
297 		hit2Count -= hit3Count*3;
298 		uint totalPot = games[currentGame].ticketsCount*ticketPrice;
299 		hit2Value = ( totalPot * forHit2 / 100 );
300 		games[currentGame].prizePot = hit2Value;
301 		hit2Value = hit2Value / hit2Count;
302 		totalPot -= hit2Value;
303 		uint _ownerBalance = totalPot * forHit2 / 100;
304 		totalPot -= _ownerBalance;
305 		ownerBalance += _ownerBalance;
306 		uint _addInvestorsValue = totalPot * forInvestors / 100;
307 		addInvestorsValue(_addInvestorsValue);
308 		totalPot -= _addInvestorsValue;
309 		if (hit3Count > 0) {
310 			games[currentGame].prizePot += currentJackpot;
311 			for ( a=0 ; a < investors.length ; a++ ) {
312 				delete investors[a].live;
313 			}
314 			hit3Value = currentJackpot / hit3Count;
315 			extraJackpot = 0;
316 			investmentsValue = 0;
317 		}
318 		extraJackpot += totalPot;
319 		setJackpot();
320 		DrawEvent(currentGame, numbers[0], numbers[1], numbers[2], hit3Count, hit3Value, hit2Count, hit2Value);
321 		WLBdrawsDBInterface( WLBdrawsDB ).newDraw( now, numbers, hit3Count, hit3Value, hit2Count, hit2Value);
322 		games[currentGame].hit3Count = hit3Count;
323 		games[currentGame].hit3Value = hit3Value;
324 		games[currentGame].hit2Count = hit2Count;
325 		games[currentGame].hit2Value = hit2Value;
326 		games[currentGame].drawDone = true;
327 		newGame();
328 	}
329 	/* owner functions */
330 	function OwnerGetFee() external OnlyOwner {
331 		if (ownerBalance == 0) { throw; }
332 		if (owner.send(ownerBalance) == false) { throw; }
333 		ownerBalance = 0;
334 	}
335 	function OwnerCloseContract() external OnlyOwner noEther {
336 		if ( ! contractEnabled) {
337 			if (contractDisabledTimeStamp+contractDismissDelay < now) {
338 				suicide(owner);
339 			}
340 		} else {
341 			contractEnabled = false;
342 			contractDisabledTimeStamp = now;
343 			ContractDisabledEvent(contractDisabledTimeStamp+contractDismissDelay);
344 			ownerBalance += extraJackpot;
345 			extraJackpot = 0;
346 			games[currentGame].prizePot = games[currentGame].ticketsCount*ticketPrice;
347 		}
348 	}
349 	/* private functions */
350 	function addInvestorsValue(uint value) private {
351 		bool done;
352 		uint a;
353 		for ( a=0 ; a < investors.length ; a++ ) {
354 			if (investors[a].live && investors[a].valid) {
355 				investors[a].balance += value * investors[a].value / investmentsValue;
356 				done = true;
357 			}
358 		}
359 		if ( ! done) {
360 			ownerBalance += value;
361 		}
362 	}
363 	function newGame() private {
364 		currentGame++;
365 		uint gamesID = games.length;
366 		games.length++;
367 		games[gamesID].startTimestamp = now;
368 		games[gamesID].endTimestamp = calcNextDrawTime();
369 		if (games.length > prizeDismissDelay) {
370 			ownerBalance += games[currentGame-prizeDismissDelay].prizePot;
371 			delete games[currentGame-prizeDismissDelay];
372 		}
373 	}
374 	function getNumbersFromHash(bytes32 hash) private returns (uint8[3] numbers) {
375 		bool ok = true;
376 		uint8 num = 0;
377 		uint hashpos = 0;
378 		uint8 a;
379 		uint8 b;
380 		for (a = 0 ; a < numbers.length ; a++) {
381 			while (true) {
382 				ok = true;
383 				if (hashpos == 32) {
384 					hashpos = 0;
385 					hash = sha3(hash);
386 				}
387 				num = getPart( hash, hashpos );
388 				num = num % uint8(drawMaxNumber) + 1;
389 				hashpos += 1;
390 				for (b = 0 ; b < numbers.length ; b++) {
391 					if (numbers[b] == num) {
392 						ok = false;
393 						break; 
394 					}
395 				}
396 				if (ok == true) {
397 					numbers[a] = num;
398 					break;
399 				}
400 			}
401 		}
402 		numbers = sortNumbers( numbers );
403 	}
404 	function getPart(bytes32 a, uint i) private returns (uint8) { return uint8(byte(bytes32(uint(a) * 2 ** (8 * i)))); }
405 	function setJackpot() private {
406 		currentJackpot = investmentsValue + extraJackpot;
407 	}
408 	function getInvestorByAddress(address Address) private returns (bool found, uint id) {
409 		for ( id=0 ; id < investors.length ; id++ ) {
410 			if (investors[id].owner == Address) {
411 				return (true, id);
412 			}
413 		}
414 		return (false, 0);
415 	}
416 	function checkNumbers(uint8[3] Numbers) private returns (bool) {
417 		for ( uint a = 0 ; a < Numbers.length ; a++ ) {
418 			if (Numbers[a] > drawMaxNumber || Numbers[a] == 0) { return; }
419 			for ( uint b = 0 ; a < Numbers.length ; a++ ) {
420 				if (a != b && Numbers[a] == Numbers[b]) { return; }
421 			}
422 		}
423 		return true;
424 	}
425 	function calcNextDrawTime() private returns (uint ret) {
426 		ret = 1468152000;
427 		while (ret < now) {
428 			ret += 1 weeks;
429 		}
430 	}
431 	function sortNumbers(uint8[3] numbers) private returns(uint8[3] sNumbers) {
432 		sNumbers = numbers;
433 		for (uint8 i=0; i<numbers.length; i++) {
434 			for (uint8 j=i+1; j<numbers.length; j++) {
435 				if (sNumbers[i] > sNumbers[j]) {
436 					uint8 t = sNumbers[i];
437 					sNumbers[i] = sNumbers[j];
438 					sNumbers[j] = t;
439 				}
440 			}
441 		}
442 	}
443 	function getNumbersFromBytes(bytes3 Bytes) private returns (uint8[3] Numbers){
444 		Numbers[0] = uint8(Bytes);
445 		Numbers[1] = uint8(uint24(Bytes) /256);
446 		Numbers[2] = uint8(uint24(Bytes) /256/256);
447 	}
448 	function getBytesFromNumbers(uint8[3] Numbers) private returns (bytes3 Bytes) {
449 		return bytes3(uint(Numbers[0])+uint(Numbers[1])*256+uint(Numbers[2])*256*256);
450 	}
451 	/* modifiers */
452 	modifier noContract() {if (tx.origin != msg.sender) { throw; } _ }
453 	modifier noEther() { if (msg.value > 0) { throw; } _ }
454 	modifier OnlyOwner() { if (owner != msg.sender) { throw; } _ }
455 	modifier OnlyEnabled() { if ( ! contractEnabled) { throw; } _ }
456 }