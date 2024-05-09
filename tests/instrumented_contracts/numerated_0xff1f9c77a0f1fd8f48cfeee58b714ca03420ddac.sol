1 pragma solidity ^0.4.8;
2 
3 // version (ZK)
4 
5 
6 contract iE4RowEscrow {
7 	function getNumGamesStarted() constant returns (int ngames);
8 }
9 
10 
11 contract E4RowEscrow is iE4RowEscrow {
12 
13 event StatEvent(string msg);
14 event StatEventI(string msg, uint val);
15 event StatEventA(string msg, address addr);
16 
17 	uint constant MAX_PLAYERS = 5;
18 
19 	enum EndReason  {erWinner, erTimeOut, erCancel}
20 	enum SettingStateValue  {debug, release, lockedRelease}
21 
22 	struct gameInstance {
23 		address[5] players;
24 		uint[5] playerPots;
25 		uint numPlayers;
26 
27 		bool active; // active
28 		bool allocd; //  allocated already. 
29 		uint started; // time game started
30 		uint lastMoved; // time game last moved
31 		uint payout; // payout amont
32 		address winner; // address of winner
33 		
34 
35 		EndReason reasonEnded; // enum reason of ended
36 		
37 	}
38 	
39 	struct arbiter {
40 		mapping (uint => uint)  gameIndexes; // game handles
41 
42 		uint arbToken; // 2 bytes
43 		uint gameSlots; // a counter of alloc'd game structs (they can be reused)
44 		uint gamesStarted; // total games started
45 		uint gamesCompleted;
46 		uint gamesCanceled; // also tied
47 		uint gamesTimedout;
48 		uint numPlayers;
49 		bool registered; 
50 		bool locked;
51 	}
52 
53 
54 	address public  owner; 	// owner is address that deployed contract
55 	address public  tokenPartner; 	// the address of partner that receives rake fees
56 	uint public numArbiters; 	// number of arbiters
57 
58 	int numGamesStarted;	// total stats from all arbiters
59 
60 	uint public numGamesCompleted; // ...
61 	uint public numGamesCanceled; 	// tied and canceled
62 	uint public numGamesTimedOut;	// ...
63 
64 	uint public houseFeeHoldover; // hold fee till threshold
65 	uint public lastPayoutTime; 	// timestamp of last payout time
66 
67 
68 	// configurables
69 	uint public gameTimeOut;
70 	uint public registrationFee;
71 	uint public houseFeeThreshold;
72 	uint public payoutInterval;
73 
74 	uint raGas; // for register arb
75 	uint sgGas;// for start game
76 	uint wpGas; // for winner paid
77 	uint rfGas; // for refund
78 	uint feeGas; // for rake fee payout
79 
80 	SettingStateValue public settingsState = SettingStateValue.debug; 
81 	
82 
83 	mapping (address => arbiter)  arbiters;
84 	mapping (uint => address)  arbiterTokens;
85 	mapping (uint => address)  arbiterIndexes;
86 	mapping (uint => gameInstance)  games;
87 
88 
89 	function E4RowEscrow() public
90 	{
91 		owner = msg.sender;
92 	}
93 
94 
95 	function applySettings(SettingStateValue _state, uint _fee, uint _threshold, uint _timeout, uint _interval)
96 	{
97 		if (msg.sender != owner) 
98 			throw;
99 
100 		// ----------------------------------------------
101 		// these items are tweakable for game optimization
102 		// ----------------------------------------------
103 		houseFeeThreshold = _threshold;
104 		gameTimeOut = _timeout;
105 		payoutInterval = _interval;
106 	
107 		if (settingsState == SettingStateValue.lockedRelease) {
108 			StatEvent("Settings Tweaked");
109 			return;
110 		}
111 
112  	 	settingsState = _state;
113 		registrationFee = _fee;
114 
115 		// set default op gas -  any futher settings done in set up gas
116 		raGas = 150000; 
117 		sgGas = 110000;
118 		wpGas = 20000; 
119 		rfGas = 20000; 
120 		feeGas = 360000; 
121 
122 		StatEvent("Settings Changed");
123 
124 	
125 	}
126 
127 	//-----------------------------
128 	// return an arbiter token from an hGame
129 	//-----------------------------
130 	function ArbTokFromHGame(uint _hGame) returns (uint _tok)
131 	{ 
132 		_tok =  (_hGame / (2 ** 48)) & 0xffff;
133 	}
134 
135 
136 	//-----------------------------
137 	// suicide the contract, not called for release
138 	//-----------------------------
139 	function HaraKiri()
140 	{
141 		if ((msg.sender == owner) && (settingsState != SettingStateValue.lockedRelease))
142 			  suicide(tokenPartner);
143 		else
144 			StatEvent("Kill attempt failed");
145 	}
146 
147 
148 
149 
150 	//-----------------------------
151 	// default function
152 	// who are we to look a gift-horse in the mouth?
153 	//-----------------------------
154  	function() payable  {
155 		StatEvent("thanks!");
156   	}
157 
158 	//------------------------------------------------------
159 	// check active game and valid player, return player index
160 	//-------------------------------------------------------
161 	function validPlayer(uint _hGame, address _addr)  internal returns( bool _valid, uint _pidx)
162 	{
163 		_valid = false;
164 		if (activeGame(_hGame)) {
165 			for (uint i = 0; i < games[_hGame].numPlayers; i++) {
166 				if (games[_hGame].players[i] == _addr) {
167 					_valid=true;
168 					_pidx = i;
169 					break;
170 				}
171 			}
172 		}			
173 	}
174 
175 	//------------------------------------------------------
176 	// check valid player, return player index
177 	//-------------------------------------------------------
178 	function validPlayer2(uint _hGame, address _addr) internal  returns( bool _valid, uint _pidx)
179 	{
180 		_valid = false;
181 		for (uint i = 0; i < games[_hGame].numPlayers; i++) {
182 			if (games[_hGame].players[i] == _addr) {
183 				_valid=true;
184 				_pidx = i;
185 				break;
186 			}
187 		}
188 	}
189 
190 	//------------------------------------------------------
191 	// check the arbiter is valid by comparing token
192 	//------------------------------------------------------
193 	function validArb(address _addr, uint _tok) internal  returns( bool _valid)
194 	{
195 		_valid = false;
196 
197 		if ((arbiters[_addr].registered)
198 			&& (arbiters[_addr].arbToken == _tok)) 
199 			_valid = true;
200 	}
201 
202 	//------------------------------------------------------
203 	// check the arbiter is valid without comparing token
204 	//------------------------------------------------------
205 	function validArb2(address _addr) internal  returns( bool _valid)
206 	{
207 		_valid = false;
208 		if (arbiters[_addr].registered)
209 			_valid = true;
210 	}
211 
212 	//------------------------------------------------------
213 	// check if arbiter is locked out
214 	//------------------------------------------------------
215 	function arbLocked(address _addr) internal  returns( bool _locked)
216 	{
217 		_locked = false;
218 		if (validArb2(_addr)) 
219 			_locked = arbiters[_addr].locked;
220 	}
221 
222 	//------------------------------------------------------
223 	// return if game is active
224 	//------------------------------------------------------
225 	function activeGame(uint _hGame) internal  returns( bool _valid)
226 	{
227 		_valid = false;
228 		if ((_hGame > 0)
229 			&& (games[_hGame].active))
230 			_valid = true;
231 	}
232 
233 
234 	//------------------------------------------------------
235 	// register game arbiter, max players of 5, pass in exact registration fee
236 	//------------------------------------------------------
237 	function registerArbiter(uint _numPlayers, uint _arbToken) public payable 
238 	{
239 
240 		if (msg.value != registrationFee) {
241 			throw;  //Insufficient Fee
242 		}
243 
244 		if (_arbToken == 0) {
245 			throw; // invalid token
246 		}
247 
248 		if (arbTokenExists(_arbToken & 0xffff)) {
249 			throw; // Token Already Exists
250 		}
251 
252 		if (arbiters[msg.sender].registered) {
253 			throw; // Arb Already Registered
254 		}
255 		
256 		if (_numPlayers > MAX_PLAYERS) {
257 			throw; // Exceeds Max Players
258 		}
259 
260 		arbiters[msg.sender].gamesStarted = 0;
261 		arbiters[msg.sender].gamesCompleted = 0;
262 		arbiters[msg.sender].gamesCanceled = 0; 
263 		arbiters[msg.sender].gamesTimedout = 0;
264 		arbiters[msg.sender].locked = false;
265 		arbiters[msg.sender].arbToken = _arbToken & 0xffff;
266 		arbiters[msg.sender].numPlayers = _numPlayers;
267 		arbiters[msg.sender].registered = true;
268 
269 		arbiterTokens[(_arbToken & 0xffff)] = msg.sender;
270 		arbiterIndexes[numArbiters++] = msg.sender;
271 	
272 
273 		if (!tokenPartner.call.gas(raGas).value(msg.value)()) {
274 			//Statvent("Send Error"); // event never registers
275 		        throw;
276 		}
277 		StatEventI("Arb Added", _arbToken);
278 	}
279 
280 
281 	//------------------------------------------------------
282 	// start game.  pass in valid hGame containing token in top two bytes
283 	//------------------------------------------------------
284 	function startGame(uint _hGame, int _hkMax, address[] _players) public 
285 
286 	{
287 		uint ntok = ArbTokFromHGame(_hGame);
288 		if (!validArb(msg.sender, ntok )) {
289 			StatEvent("Invalid Arb");
290 			return;
291 		}
292 
293 
294 		if (arbLocked(msg.sender)) {
295 			StatEvent("Arb Locked");
296 			return; 
297 		}
298 
299 		arbiter xarb = arbiters[msg.sender];
300 		if (_players.length != xarb.numPlayers) { 
301 			StatEvent("Incorrect num players");
302 			return; 
303 		}
304 
305 		if (games[_hGame].active) {
306 			// guard-rail. just in case to return funds
307 			abortGame(msg.sender, _hGame, EndReason.erCancel);
308 
309 		} else if (_hkMax > 0) {
310 			houseKeep(_hkMax, ntok); 
311 		}
312 
313 		if (!games[_hGame].allocd) {
314 			games[_hGame].allocd = true;
315 			xarb.gameIndexes[xarb.gameSlots++] = _hGame;
316 		} 
317 		numGamesStarted++; // always inc this one
318 		xarb.gamesStarted++;
319 
320 		games[_hGame].active = true;
321 		games[_hGame].started = now; 
322 		games[_hGame].lastMoved = now; 
323 		games[_hGame].payout = 0; 
324 		games[_hGame].winner = address(0);
325 
326 		games[_hGame].numPlayers = _players.length; // we'll be the judge of how many unique players
327 		for (uint i = 0; i< _players.length && i < MAX_PLAYERS; i++) {
328 	            games[_hGame].players[i] = _players[i];
329 		    games[_hGame].playerPots[i] = 0;
330 		}
331 
332 		StatEventI("Game Added", _hGame);
333 		
334 
335 	}
336 	
337 	//------------------------------------------------------
338 	// clean up game, set to inactive, refund any balances
339 	// called by housekeep ONLY
340 	//------------------------------------------------------
341 	function abortGame(address _arb, uint  _hGame, EndReason _reason) private returns(bool _success)
342 	{
343 	     gameInstance nGame = games[_hGame];
344 	     
345 		// find game in game id, 
346 		if (nGame.active) {
347 			_success = true;
348 			for (uint i = 0; i < nGame.numPlayers; i++) {
349 				if (nGame.playerPots[i] > 0) {
350 					address a = nGame.players[i];
351 					uint nsend = nGame.playerPots[i];
352 					nGame.playerPots[i] = 0;
353 					if (!a.call.gas(rfGas).value(nsend)()) {
354 						houseFeeHoldover += nsend; // cannot refund due to error, give to the house
355 					        StatEventA("Cannot Refund Address", a);
356 					}
357 				}
358 			}
359 			nGame.active = false;
360 			nGame.reasonEnded = _reason;
361 			if (_reason == EndReason.erCancel) {
362 				numGamesCanceled++;
363 				arbiters[_arb].gamesCanceled++;
364 				StatEvent("Game canceled");
365 			} else if (_reason == EndReason.erTimeOut) {
366 				numGamesTimedOut++;
367 				arbiters[_arb].gamesTimedout++;
368 				StatEvent("Game timed out");
369 			} else 
370 				StatEvent("Game aborted");
371 		}
372 	}
373 
374 
375 	//------------------------------------------------------
376 	// called by arbiter when winner is decided
377 	// *pass in high num for winnerbal for tie games
378 	//------------------------------------------------------
379 	function winnerDecided(uint _hGame, address _winner, uint _winnerBal) public
380 	{
381 
382 		if (!validArb(msg.sender, ArbTokFromHGame(_hGame))) {
383 			StatEvent("Invalid Arb");	
384 			return; // no throw no change made
385 		}
386 
387 		var (valid, pidx) = validPlayer(_hGame, _winner);
388 		if (!valid) {
389 			StatEvent("Invalid Player");	
390 			return;
391 		}
392 
393 		arbiter xarb = arbiters[msg.sender];
394 		gameInstance xgame = games[_hGame];
395 
396 		uint totalPot = 0;
397 
398 		if (xgame.playerPots[pidx] < _winnerBal) {
399 		    abortGame(msg.sender, _hGame, EndReason.erCancel);
400   		    return;
401 		}
402 
403 		for (uint i = 0; i < xgame.numPlayers; i++) {
404 			totalPot += xgame.playerPots[i];
405 		}
406 		
407 		uint nportion;
408 		uint nremnant;
409 		if (totalPot > 0) {
410 		 	nportion = totalPot/50; // 2 percent fixed
411 			nremnant = totalPot-nportion;
412 		} else {
413 			nportion = 0;
414 			nremnant = 0;
415 		}
416 		
417 
418 		xgame.lastMoved = now;
419 		xgame.active = false;
420 		xgame.reasonEnded = EndReason.erWinner;
421 		xgame.winner = _winner;
422 		xgame.payout = nremnant;
423 		
424 		if (nportion > 0) {
425 			houseFeeHoldover += nportion;
426 			if ((houseFeeHoldover > houseFeeThreshold)
427 				&& (now > (lastPayoutTime + payoutInterval))) {
428 				uint ntmpho = houseFeeHoldover;
429 				houseFeeHoldover = 0;
430 				lastPayoutTime = now; // reset regardless of succeed/fail
431 				if (!tokenPartner.call.gas(feeGas).value(ntmpho)()) {
432 					houseFeeHoldover = ntmpho; // put it back
433 					StatEvent("House-Fee Error1");
434 				} 
435 			}
436 		}
437 	
438 		for (i = 0; i < xgame.numPlayers; i++) {
439 			xgame.playerPots[i] = 0;
440 		}
441 
442 		xarb.gamesCompleted++;
443 		numGamesCompleted++;
444 		if (nremnant > 0) {
445 			if (!_winner.call.gas(wpGas).value(uint(nremnant))()) {
446 				// StatEvent("Send Error");
447 			        throw; // if you cant pay the winner - very bad
448 			} else {
449 				StatEventI("Winner Paid", _hGame);		
450 			}
451 		}
452 	}
453 
454 	//------------------------------------------------------
455 	// handle a bet made by a player, validate the player and game
456 	// add to players balance
457 	//------------------------------------------------------
458 	function handleBet(uint _hGame) public payable 
459 	{
460 		address narb = arbiterTokens[ArbTokFromHGame(_hGame)];
461 		if (narb == address(0)) {
462 			throw; // "Invalid hGame"
463 		}
464 
465 		var (valid, pidx) = validPlayer(_hGame, msg.sender);
466 		if (!valid) {
467 			throw; // "Invalid Player"
468 		}
469 
470 		games[_hGame].playerPots[pidx] += msg.value;
471 		games[_hGame].lastMoved = now;
472 
473 		StatEventI("Bet Added", _hGame);
474 
475 	}
476 
477 
478 	//------------------------------------------------------
479 	// return if arb token exists
480 	//------------------------------------------------------
481 	function arbTokenExists(uint _tok) constant returns (bool _exists)
482 	{
483 		_exists = false;
484 		if ((_tok > 0)
485 			&& (arbiterTokens[_tok] != address(0))
486 			&& arbiters[arbiterTokens[_tok]].registered)
487 			_exists = true;
488 
489 	}
490 
491 
492 
493 
494 	//------------------------------------------------------
495 	// called by ico token contract 
496 	//------------------------------------------------------
497 	function getNumGamesStarted() constant returns (int _games) 
498 	{
499 		_games = numGamesStarted;
500 	}
501 
502 	//------------------------------------------------------
503 	// return arbiter game stats
504 	//------------------------------------------------------
505 	function getArbInfo(uint _idx) constant  returns (address _addr, uint _started, uint _completed, uint _canceled, uint _timedOut) 
506 	{
507 		if (_idx >= numArbiters) {
508 			StatEvent("Invalid Arb");
509 			return;
510 		}
511 		_addr = arbiterIndexes[_idx];
512 		if ((_addr == address(0))
513 			|| (!arbiters[_addr].registered)) {
514 			StatEvent("Invalid Arb");
515 			return;
516 		}
517 		arbiter xarb = arbiters[_addr];
518 		_started = xarb.gamesStarted;
519 		_completed = xarb.gamesCompleted;
520 		_timedOut = xarb.gamesTimedout;
521 		_canceled = xarb.gamesCanceled;
522 	}
523 
524 
525 	//------------------------------------------------------
526 	// scan for a game 10 minutes old
527 	// if found abort the game, causing funds to be returned
528 	//------------------------------------------------------
529 	function houseKeep(int _max, uint _arbToken) public
530 	{	
531 		uint gi;
532 		address a;
533 		int aborted = 0;
534 		
535 		arbiter xarb = arbiters[msg.sender];// have to set it to something
536 	        
537          
538 		if (msg.sender == owner) {
539 			for (uint ar = 0; (ar < numArbiters) && (aborted < _max) ; ar++) {
540 			    a = arbiterIndexes[ar];
541 			    xarb = arbiters[a];    
542 
543 			    for ( gi = 0; (gi < xarb.gameSlots) && (aborted < _max); gi++) {
544 				gameInstance ngame0 = games[xarb.gameIndexes[gi]];
545 				if ((ngame0.active)
546 				    && ((now - ngame0.lastMoved) > gameTimeOut)) {
547 					abortGame(a, xarb.gameIndexes[gi], EndReason.erTimeOut);
548 					++aborted;
549 				}
550 			    }
551 			}
552 
553 		} else {
554 			if (!validArb(msg.sender, _arbToken))
555 				StatEvent("Housekeep invalid arbiter");
556 			else {
557 			    a = msg.sender;
558 			    xarb = arbiters[a];    
559 			    for (gi = 0; (gi < xarb.gameSlots) && (aborted < _max); gi++) {
560 				gameInstance ngame1 = games[xarb.gameIndexes[gi]];
561 				if ((ngame1.active)
562 				    && ((now - ngame1.lastMoved) > gameTimeOut)) {
563 					abortGame(a, xarb.gameIndexes[gi], EndReason.erTimeOut);
564 					++aborted;
565 				}
566 			    }
567 
568 			}	
569 		}
570 	}
571 
572 
573 	//------------------------------------------------------
574 	// return game info
575 	//------------------------------------------------------
576 	function getGameInfo(uint _hGame)  constant  returns (EndReason _reason, uint _players, uint _payout, bool _active, address _winner )
577 	{
578 		gameInstance ngame = games[_hGame];
579 		_active = ngame.active;
580 		_players = ngame.numPlayers;
581 		_winner = ngame.winner;
582 		_payout = ngame.payout;
583 		_reason = ngame.reasonEnded;
584 
585 	}
586 
587 	//------------------------------------------------------
588 	// return arbToken and low bytes from an HGame
589 	//------------------------------------------------------
590 	function checkHGame(uint _hGame) constant returns(uint _arbTok, uint _lowWords)
591 	{
592 		_arbTok = ArbTokFromHGame(_hGame);
593 		_lowWords = _hGame & 0xffffffffffff;
594 		
595 	}
596 
597 	//------------------------------------------------------
598 	// get operation gas amounts
599 	//------------------------------------------------------
600 	function getOpGas() constant returns (uint _ra, uint _sg, uint _wp, uint _rf, uint _fg) 
601 	{
602 		_ra = raGas; // register arb
603 		_sg = sgGas; // start game
604 		_wp = wpGas; // winner paid
605 		_rf = rfGas; // refund
606 		_fg = feeGas; // rake fee gas
607 	}
608 
609 
610 	//------------------------------------------------------
611 	// set operation gas amounts for forwading operations
612 	//------------------------------------------------------
613 	function setOpGas(uint _ra, uint _sg, uint _wp, uint _rf, uint _fg) 
614 	{
615 		if (msg.sender != owner)
616 			throw;
617 
618 		raGas = _ra;
619 		sgGas = _sg;
620 		wpGas = _wp;
621 		rfGas = _rf;
622 		feeGas = _fg;
623 	}
624 
625 	//------------------------------------------------------
626 	// set a micheivous arbiter to locked
627 	//------------------------------------------------------
628 	function setArbiterLocked(address _addr, bool _lock)  public 
629 	{
630 		if (owner != msg.sender)  {
631 			throw; 
632 		} else if (!validArb2(_addr)) {
633 			StatEvent("invalid arb");
634 		} else {
635 			arbiters[_addr].locked = _lock;
636 		}
637 		
638 	}
639 
640 	//------------------------------------------------------
641 	// flush the house fees whenever commanded to.
642 	// ignore the threshold and the last payout time
643 	// but this time only reset lastpayouttime upon success
644 	//------------------------------------------------------
645 	function flushHouseFees()
646 	{
647 		if (msg.sender != owner) {
648 			StatEvent("only owner calls this function");
649 		} else if (houseFeeHoldover > 0) {
650 			uint ntmpho = houseFeeHoldover;
651 			houseFeeHoldover = 0;
652 			if (!tokenPartner.call.gas(feeGas).value(ntmpho)()) {
653 				houseFeeHoldover = ntmpho; // put it back
654 				StatEvent("House-Fee Error2"); 
655 			} else {
656 				lastPayoutTime = now;
657  				StatEvent("House-Fee Paid");
658 	 		}
659 		}
660 
661 	}
662 
663 
664 	//------------------------------------------------------
665 	// set the token partner
666 	//------------------------------------------------------
667 	function setTokenPartner(address _addr) public
668 	{
669 		if (msg.sender != owner) {
670 			throw;
671 		} 
672 
673 		if ((settingsState == SettingStateValue.lockedRelease) 
674 			&& (tokenPartner == address(0))) {
675 			tokenPartner = _addr;
676 			StatEvent("Token Partner Final!");
677 		} else if (settingsState != SettingStateValue.lockedRelease) {
678 			tokenPartner = _addr;
679 			StatEvent("Token Partner Assigned!");
680 		}
681 			
682 	}
683 
684 	// ----------------------------
685 	// swap executor
686 	// ----------------------------
687 	function changeOwner(address _addr) 
688 	{
689 		if (msg.sender != owner
690 			|| settingsState == SettingStateValue.lockedRelease)
691 			 throw;
692 
693 		owner = _addr;
694 	}
695 
696 
697 
698 }