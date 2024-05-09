1 pragma solidity ^0.4.17;
2 
3 contract Ownable {
4 	address owner;
5 	address potentialOwner;
6 	
7 	modifier onlyOwner() {
8 		require(owner == msg.sender);
9 		_;
10 	}
11 
12 	function Ownable() public {
13 		owner = msg.sender;
14 	}
15 
16 	/*
17 	 * PUBLIC
18 	 * Check whether you `own` this Lottery
19 	 */
20 	function amIOwner() public view returns (bool) {
21 		return msg.sender == owner;
22 	}
23 
24 	/*
25 	 * RESTRICTED
26 	 * Transfer ownership to another address (goes into effect when other address accepts)
27 	 */
28 	function transferOwnership(address _newOwner) public onlyOwner {
29 		potentialOwner = _newOwner;
30 	}
31 
32 	/*
33 	 * RESTRICTED
34 	 * Accept ownership of the Lottery (if a transfer has been initiated with your address)
35 	 */
36 	function acceptOwnership() public {
37 		require(msg.sender == potentialOwner);
38 		owner = msg.sender;
39 		potentialOwner = address(0);
40 	}
41 }
42 
43 contract Linkable is Ownable {
44 	address[] linked;
45 
46 	modifier onlyLinked() {
47 		require(checkPermissions() == true);
48 		_;
49 	}
50 	
51 	/*
52 	 * RESTRICTED
53 	 * Link an address to this contract. This address has access to
54 	 * any `onlyLinked` function
55 	 */
56 	function link(address _address) public onlyOwner {
57 		linked.push(_address);
58 	}
59 
60 	/* 
61 	 * PUBLIC
62 	 * Check if you have been linked to this contract
63 	 */
64 	function checkPermissions() public view returns (bool) {
65 		for (uint i = 0; i < linked.length; i++)
66 			if (linked[i] == msg.sender) return true;
67 		return false;
68 	}
69 }
70 
71 contract Activity is Ownable, Linkable {
72   
73   struct Event {
74     uint id;
75     uint gameId;
76     address source;
77     address[] winners;
78     uint winningNumber;
79     uint amount;
80     uint timestamp;
81   }
82 
83   /*
84    * Get an event by it's id (index)
85    */
86   Event[] public events;
87 
88   /*
89    * Add a new event
90    */
91   function newEvent(uint _gameId, address[] _winners, uint _winningNumber, uint _amount) public onlyLinked {
92     require(_gameId > 0);
93     events.push(Event(events.length, _gameId, msg.sender, _winners, _winningNumber, _amount, now));
94   }
95 
96   /*
97    * Get the activity feed for all games
98    *
99    * NOTE: set gameId to 0 for a feed of all games
100    *
101    * RETURNS:
102    * (ids[], gameIds[], sources[], winners[] (index 0 OR msg.sender if they won), numWinners[], winningNums[], jackpots[], timestamps[])
103    */
104   function getFeed(uint _gameId, uint _page, uint _pageSize) public view
105     returns (uint[], uint[], address[], uint[], uint[], uint[], uint[]) {
106     
107     return constructResponse(getFiltered(_gameId, _page - 1, _pageSize));
108   }
109 
110   // ------------------------------------------------------------
111   // Private Helpers
112 
113   function constructResponse(Event[] _events) private view
114     returns (uint[], uint[], address[], uint[], uint[], uint[], uint[]) {
115     
116     uint[] memory _ids = new uint[](_events.length);
117     uint[] memory _gameIds = new uint[](_events.length);
118     uint[] memory _amounts = new uint[](_events.length);
119     uint[] memory _timestamps = new uint[](_events.length);
120 
121     for (uint i = 0; i < _events.length; i++) {
122       _ids[i] = _events[i].id;
123       _gameIds[i] = _events[i].gameId;
124       _amounts[i] = _events[i].amount;
125       _timestamps[i] = _events[i].timestamp;
126     }
127 
128     WinData memory _win = contructWinData(_events);
129 
130     return (_ids, _gameIds, _win.winners, _win.numWinners, _win.winningNumbers, _amounts, _timestamps);
131   }
132 
133   struct WinData {
134     address[] winners;
135     uint[] numWinners;
136     uint[] winningNumbers;
137   }
138 
139   function contructWinData(Event[] _events) private view returns (WinData) {
140     address[] memory _winners = new address[](_events.length);
141     uint[] memory _numWinners = new uint[](_events.length);
142     uint[] memory _winningNumbers = new uint[](_events.length);
143 
144     for (uint i = 0; i < _events.length; i++) {
145       _winners[i] = chooseWinnerToDisplay(_events[i].winners, msg.sender);
146       _numWinners[i] = _events[i].winners.length;
147       _winningNumbers[i] = _events[i].winningNumber;
148     }
149 
150     return WinData(_winners, _numWinners, _winningNumbers);
151   }
152 
153   function chooseWinnerToDisplay(address[] _winners, address _user) private pure returns (address) {
154     if (_winners.length < 1) return address(0);
155     address _picked = _winners[0];
156     if (_winners.length == 1) return _picked;
157     for (uint i = 1; i < _winners.length; i++)
158       if (_winners[i] == _user) _picked = _user;
159     return _picked;
160   }
161 
162   function getFiltered(uint _gameId, uint _page, uint _pageSize) private view returns (Event[]) {
163     Event[] memory _filtered = new Event[](_pageSize);
164     uint _filteredIndex;
165     uint _minIndex = _page * _pageSize;
166     uint _maxIndex = _minIndex + _pageSize;
167     uint _count;
168 
169     for (uint i = events.length; i > 0; i--) {
170       if (_gameId == 0 || events[i - 1].gameId == _gameId) {
171         if (_filteredIndex >= _minIndex && _filteredIndex < _maxIndex) {
172           _filtered[_count] = events[i - 1];
173           _count++;
174         }
175         _filteredIndex++;
176       }
177     }
178 
179     Event[] memory _events = new Event[](_count);
180     for (uint b = 0; b < _count; b++)
181       _events[b] = _filtered[b];
182 
183     return _events;
184   }
185 
186 }
187 
188 contract Affiliates is Ownable, Linkable {
189 	bool open = true;
190 	bool promoted = true;
191 
192 	/*
193 	 * Open/Close registration of new affiliates
194 	 */
195 	function setRegistrationOpen(bool _open) public onlyOwner {
196 		open = _open;
197 	}
198 
199 	function isRegistrationOpen() public view returns (bool) {
200 		return open;
201 	}
202 
203 	/*
204 	 * Should promote registration of new affiliates
205 	 */
206 	function setPromoted(bool _promoted) public onlyOwner {
207 		promoted = _promoted;
208 	}
209 
210 	function isPromoted() public view returns (bool) {
211 		return promoted;
212 	}
213 
214 	// -----------------------------------------------------------
215 
216 	mapping(uint => uint) balances; // (affiliateCode => balance)
217 	mapping(address => uint) links; // (buyer => affiliateCode)
218 	mapping(uint => bool) living; // whether a code has been used before (used for open/closing of program)
219 	
220 	/*
221 	 * PUBLIC
222 	 * Get the code for an affiliate
223 	 */
224 	function getCode() public view returns (uint) {
225 		return code(msg.sender);
226 	}
227 
228 	// Convert an affiliate's address into a code
229 	function code(address _affiliate) private pure returns (uint) {
230 		uint num = uint(uint256(keccak256(_affiliate)));
231 		return num / 10000000000000000000000000000000000000000000000000000000000000000000000;
232 	}
233 
234 	/*
235 	 * PUBLIC
236 	 * Get the address who originally referred the given user. Returns 0 if not referred
237 	 */
238 	function getAffiliation(address _user) public view onlyLinked returns (uint) {
239 		return links[_user];
240 	}
241 
242 	/*
243 	 * PUBLIC
244 	 * Set the affiliation of a user to a given code. Returns the address of the referrer
245 	 * linked to that code OR, if a user has already been linked to a referer, returns the
246 	 * address of their original referer
247 	 */
248 	function setAffiliation(address _user, uint _code) public onlyLinked returns (uint) {
249 		uint _affiliateCode = links[_user];
250 		if (_affiliateCode != 0) return _affiliateCode;
251 		links[_user] = _code;
252 		return _code;
253 	}
254 
255 	/*
256 	 * RESTRICTED
257 	 * Add Wei to multiple affiliates, be sure to send an amount of ether 
258 	 * equivalent to the sum of the _amounts array
259 	 */
260 	function deposit(uint[] _affiliateCodes, uint[] _amounts) public payable onlyLinked {
261 		require(_affiliateCodes.length == _amounts.length && _affiliateCodes.length > 0);
262 
263 		uint _total;
264 		for (uint i = 0; i < _affiliateCodes.length; i++) {
265 			balances[_affiliateCodes[i]] += _amounts[i];
266 			_total += _amounts[i];
267 		}
268 
269 		require(_total == msg.value && _total > 0);
270 	}
271 
272 	event Withdrawn(address affiliate, uint amount);
273 
274 	/* 
275 	 * PUBLIC
276 	 * Withdraw Wei into your wallet (will revert if you have no balance)
277 	 */
278 	function withdraw() public returns (uint) {
279 		uint _code = code(msg.sender);
280 		uint _amount = balances[_code];
281 		require(_amount > 0);
282 		balances[_code] = 0;
283 		msg.sender.transfer(_amount);	
284 		Withdrawn(msg.sender, _amount);
285 		return _amount;	
286 	}
287 
288 	/* 
289 	 * PUBLIC
290 	 * Get the amount of Wei you can withdraw
291 	 */
292 	function getBalance() public view returns (uint) {
293 		return balances[code(msg.sender)];
294 	}
295 }
296 
297 contract Lottery is Ownable {
298 	function Lottery() public {
299 		owner = msg.sender;
300 	}
301 
302 	// ---------------------------------------------------------------------
303 	// Lottery Identification - mainly used for Activity events
304 	
305 	uint id;
306 
307 	function setId(uint _id) public onlyOwner {
308 		require(_id > 0);
309 		id = _id;
310 	}
311 
312 	// ---------------------------------------------------------------------
313 	// Linking
314 
315 	/*
316 	 * id: a unique non-zero id for this instance. Used for Activity events
317 	 * activity: address pointing to the Activity instance
318 	 */
319 	function link(uint _id, address _activity, address _affiliates) public onlyOwner {
320 		require(_id > 0);
321 		id = _id;
322 		linkActivity(_activity);
323 		linkAffiliates(_affiliates);
324 		initialized();
325 	}
326 
327 	// Implement this
328 	function initialized() internal;
329 
330 	// ---------------------------------------------------------------------
331 	// Activity Integration
332 
333 	address public activityAddress;
334 	Activity activity;
335 
336 	function linkActivity(address _address) internal onlyOwner {
337 		activity = Activity(_address);
338 		require(activity.checkPermissions() == true);
339 		activityAddress = _address;
340 	}
341 
342 	function postEvent(address[] _winners, uint _winningNumber, uint _jackpot) internal {
343 		activity.newEvent(id, _winners, _winningNumber, _jackpot);
344 	}
345 
346 	function postEvent(address _winner, uint _winningNumber, uint _jackpot) internal {
347 		address[] memory _winners = new address[](1);
348 		_winners[0] = _winner;
349 		postEvent(_winners, _winningNumber, _jackpot);
350 	}
351 
352 	// ---------------------------------------------------------------------
353 	// Payment transfers
354 
355 	address public affiliatesAddress;
356 	Affiliates affiliates;
357 
358 	function linkAffiliates(address _address) internal onlyOwner {
359 		require(affiliatesAddress == address(0));
360 		affiliates = Affiliates(_address);
361 		require(affiliates.checkPermissions() == true);
362 		affiliatesAddress = _address;
363 	}
364 
365 	function setUserAffiliate(uint _code) internal returns (uint) {
366 		return affiliates.setAffiliation(msg.sender, _code);
367 	}
368 
369 	function userAffiliate() internal view returns (uint) {
370 		return affiliates.getAffiliation(msg.sender);
371 	}
372 
373 	function payoutToAffiliates(uint[] _addresses, uint[] _amounts, uint _total) internal {
374 		affiliates.deposit.value(_total)(_addresses, _amounts);
375 	}
376 
377 	// ---------------------------------------------------------------------
378 	// Randomness
379 
380 	function getRandomNumber(uint _max) internal returns (uint) {
381 		return uint(block.blockhash(block.number-1)) % _max + 1;
382 	}
383 }
384 
385 
386 contract SlotLottery is Lottery {
387 	
388 	function SlotLottery() Lottery() public {
389 		state = State.Uninitialized;
390 	}
391 
392 	// ---------------------------------------------------------------------
393 	// Linking
394 
395 	function initialized() internal {
396 		state = State.NotRunning;
397 	}
398 
399 	// ---------------------------------------------------------------------
400 	// State
401 
402 	State state;
403 
404 	enum State { Uninitialized, Running, Pending, GameOver, NotRunning }
405 
406 	modifier only(State _state) {
407 		require(state == _state);
408 		_;
409 	}
410 
411 	modifier not(State _state) {
412 		require(state != _state);
413 		_;
414 	}
415 
416 	modifier oneOf(State[2] memory _states) {
417 		bool _valid = false;
418 		for (uint i = 0; i < _states.length; i++)
419 			if (state == _states[i]) _valid = true;
420 		require(_valid);
421 		_;
422 	}
423 
424 	/*
425 	 * PUBLIC
426 	 * Get the current state of the Lottery
427 	 */
428 	function getState() public view returns (State) {
429 		return state;
430 	}
431 
432 	// ---------------------------------------------------------------------
433 	// Administrative
434 
435 	/*
436 	 * RESTRICTED
437 	 * Start up a new game with the given game rules
438 	 */
439 	function startGame(uint _jackpot, uint _slots, uint _price, uint _max) public only(State.NotRunning) onlyOwner {
440 		require(_price * _slots > _jackpot);
441 		nextGame(verifiedGameRules(_jackpot, _slots, _price, _max));
442 	}
443 
444 	/*
445 	 * RESTRICTED
446 	 * When the currently running game ends, a new game won't be automatically started
447 	 */
448 	function suspendGame() public onlyOwner {
449 		game.loop = false;
450 	}
451 
452 	/*
453 	 * RESTRICTED
454 	 * When the currently running game ends, a new game will be automatically started (this is the default behavior)
455 	 */
456 	function gameShouldRestart() public onlyOwner {
457 		game.loop = true;
458 	}
459 
460 	/*
461 	 * RESTRICTED
462 	 * In the event that some error occurs and the contract never gets the random callback
463 	 * the owner of the Lottery can trigger another random number to be retrieved
464 	 */
465 	function triggerFindWinner() public only(State.Pending) payable onlyOwner {
466 		state = State.Running;
467 		findWinner();
468 	}
469 
470 	/*
471 	 * RESTRICTED
472 	 * Set new rules for the next game
473 	 */
474 	function setNextRules(uint _jackpot, uint _slots, uint _price, uint _max) public not(State.NotRunning) onlyOwner {
475 		require(game.loop == true);
476 		game.nextGameRules = verifiedGameRules(_jackpot, _slots, _price, _max);
477 	}
478 
479 	/*
480 	 * RESTRICTED
481 	 * Get the rules for the upcoming game (if there even is one)
482 	 * (jackpot, numberOfTickets, ticketPrice, maxTicketsPer, willStartNewGameUponCompletion)
483 	 */
484 	function getNextRules() public view onlyOwner returns (uint, uint, uint, uint, bool) {
485 		return (game.nextGameRules.jackpot, game.nextGameRules.slots, game.nextGameRules.ticketPrice, game.nextGameRules.maxTicketsPer, game.loop);
486 	}
487 
488 	// ---------------------------------------------------------------------
489 	// Lifecycle
490 
491 	function nextGame(GameRules _rules) internal oneOf([State.GameOver, State.NotRunning]) {
492 		uint _newId = lastGame.id + 1;
493 		game = Game({
494 			id: _newId, rules: _rules, nextGameRules: _rules, loop: true, startedAt: block.timestamp, 
495 			ticketsSold: 0, winner: address(0), winningNumber: 0, finishedAt: 0
496 		});
497 		for(uint i = 1; i <= game.rules.slots; i++)
498 			game.tickets[i] = address(0);
499 		state = State.Running;
500 	}
501 
502 	function findWinner() internal only(State.Running) {
503 		require(game.ticketsSold >= game.rules.slots);
504 		require(this.balance >= game.rules.jackpot);
505 
506 		state = State.Pending;
507 		uint _winningNumber = getRandomNumber(game.rules.slots);
508 		winnerChosen(_winningNumber);
509 	}
510 
511 	function winnerChosen(uint _winningNumber) internal only(State.Pending) {
512 		state = State.GameOver;
513 
514 		address _winner = game.tickets[_winningNumber];
515 		bool _startNew = game.loop;
516 		GameRules memory _nextRules = game.nextGameRules;
517 
518 		game.finishedAt = block.timestamp;
519 		game.winner = _winner;
520 		game.winningNumber = _winningNumber;
521 		lastGame = game;
522 
523 		// Pay winner, affiliates, and owner
524 		_winner.transfer(game.rules.jackpot);
525 		payAffiliates();
526 		owner.transfer(this.balance);
527 
528 		// Post new event to Activity contract
529 		postEvent(_winner, _winningNumber, game.rules.jackpot);
530 
531 		if (!_startNew) {
532 			state = State.NotRunning;
533 			return;
534 		}
535 
536 		nextGame(_nextRules);
537 	}
538 
539 	// ---------------------------------------------------------------------
540 	// Lottery
541 
542 	Game game;
543 	Game lastGame;	
544 
545 	enum PurchaseError { InvalidTicket, OutOfTickets, NotEnoughFunds, LotteryClosed, TooManyTickets, TicketUnavailable, Unknown }
546 	event TicketsPurchased(address buyer, uint[] tickets, uint[] failedTickets, PurchaseError[] errors);
547 	event PurchaseFailed(address buyer, PurchaseError error);
548 
549 	/*
550 	 * PUBLIC
551 	 * Buy tickets for the Lottery by passing in an array of ticket numbers (starting at 1 not 0)
552 	 * This function doesn't revert when tickets fail to be purchased, it triggers events and
553 	 * refunds you for the tickets that failed to be purchased.
554 	 *
555 	 * Events:
556 	 * TicketsPurchased: One or more tickets were successfully purchased
557 	 * PurchaseFailed: Failed to purchase all of the tickets
558 	 */
559 	function purchaseTickets(uint[] _tickets) public payable {
560 		purchaseTicketsWithReferral(_tickets, 0);
561 	}
562 
563 	/*
564 	 * PUBLIC
565 	 * Buy tickets with a referral code
566 	 */
567 	function purchaseTicketsWithReferral(uint[] _tickets, uint _affiliateCode) public payable {
568 		
569 		// Check game state
570 		if (state != State.Running) {
571 			if (state == State.NotRunning) return failPurchase(PurchaseError.LotteryClosed);
572 			return failPurchase(PurchaseError.OutOfTickets);
573 		}
574 
575 		// Check sent funds
576 		if (msg.value < _tickets.length * game.rules.ticketPrice) 
577 			return failPurchase(PurchaseError.NotEnoughFunds);
578 
579 		uint[] memory _userTickets = getMyTickets();
580 
581 		// Check max tickets (checked again in the loop below)
582 		if (_userTickets.length >= game.rules.maxTicketsPer)
583 			return failPurchase(PurchaseError.TooManyTickets);
584 
585 		// Some tickets may fail while others succeed, lets keep track of all of that so it
586 		// can be returned to the frontend user
587 		uint[] memory _successful = new uint[](_tickets.length);
588 		uint[] memory _failed = new uint[](_tickets.length);
589 		PurchaseError[] memory _errors = new PurchaseError[](_tickets.length);
590 		uint _successCount;
591 		uint _errorCount;
592 
593 		for(uint i = 0; i < _tickets.length; i++) {
594 			uint _ticket = _tickets[i];
595 
596 			// Check that the ticket is a valid number
597 			if (_ticket <= 0 || _ticket > game.rules.slots) {
598 				_failed[_errorCount] = _ticket;
599 				_errors[_errorCount] = PurchaseError.InvalidTicket;
600 				_errorCount++;
601 				continue;
602 			}
603 
604 			// Check that the ticket is available for purchase
605 			if (game.tickets[_ticket] != address(0)) {
606 				_failed[_errorCount] = _ticket;
607 				_errors[_errorCount] = PurchaseError.TicketUnavailable;
608 				_errorCount++;
609 				continue;
610 			}
611 
612 			// Check that the user hasn't reached their max tickets
613 			if (_userTickets.length + _successCount >= game.rules.maxTicketsPer) {
614 				_failed[_errorCount] = _ticket;
615 				_errors[_errorCount] = PurchaseError.TooManyTickets;
616 				_errorCount++;
617 				continue;
618 			}
619 
620 			game.tickets[_ticket] = msg.sender;
621 			game.ticketsSold++;
622 
623 			_successful[_successCount] = _ticket;
624 			_successCount++;
625 		}
626 
627 		// Refund for failed tickets
628 		// Cannot refund more than received, will send what was given if refunding the free ticket
629 		if (_errorCount > 0) refund(_errorCount * game.rules.ticketPrice);
630 		
631 		// Affiliates
632 		uint _userAffiliateCode = userAffiliate();
633 		if (_affiliateCode != 0 && _userAffiliateCode == 0)
634 			_userAffiliateCode = setUserAffiliate(_affiliateCode);
635 		if (_userAffiliateCode != 0) addAffiliate(_userAffiliateCode, _successCount);
636 
637 		// TicketsPurchased(msg.sender, _normalizedSuccessful, _normalizedFailures, _normalizedErrors);
638 		TicketsPurchased(msg.sender, _successful, _failed, _errors);
639 
640 		// If the last ticket was sold, signal to find a winner
641 		if (game.ticketsSold >= game.rules.slots) findWinner();
642 	}
643 
644 	/*
645 	 * PUBLIC
646 	 * Get the tickets you have purchased for the current game
647 	 */
648 	function getMyTickets() public view returns (uint[]) {
649 		uint _userTicketCount;
650 		for(uint i = 0; i < game.rules.slots; i++)
651 			if (game.tickets[i + 1] == msg.sender) _userTicketCount += 1;
652 
653 		uint[] memory _tickets = new uint[](_userTicketCount);
654 		uint _index;
655 		for(uint b = 0; b < game.rules.slots; b++) {
656 			if (game.tickets[b + 1] == msg.sender) {
657 				_tickets[_index] = b + 1;
658 				_index++;
659 			}
660 		}
661 
662 		return _tickets;
663 	}
664 
665 	// ---------------------------------------------------------------------
666 	// Game
667 
668 	struct GameRules {
669 		uint jackpot;
670 		uint slots;
671 		uint ticketPrice;
672 		uint maxTicketsPer;
673 	}
674 
675 	function verifiedGameRules(uint _jackpot, uint _slots, uint _price, uint _max) internal pure returns (GameRules) {
676 		require((_price * _slots) - _jackpot > 100000000000000000); // margin is greater than 0.1 ETH (for callback fees)
677 		require(_max <= _slots);
678 		return GameRules(_jackpot, _slots, _price, _max);
679 	}
680 
681 	struct Game {
682 		uint id;
683 		GameRules rules;
684 		mapping(uint => address) tickets; // (ticketNumber => buyerAddress)
685 		uint ticketsSold;
686 		GameRules nextGameRules; // These rules will be used if the game recreates itself
687 		address winner;
688 		uint winningNumber;
689 		bool loop;
690 		uint startedAt;
691 		uint finishedAt;
692 	}
693 
694 	/*
695 	 * PUBLIC
696 	 * Get information pertaining to the current game
697 	 *
698 	 * returns: (id, jackpot, totalTickets, ticketsRemaining, ticketPrice, maxTickets, state,
699 	 						tickets[], yourTickets[])
700 	 * NOTE: tickets[] is an array of booleans, true = available and false = sold
701 	 */
702 	function getCurrentGame() public view 
703 		returns (uint, uint, uint, uint, uint, uint, State, bool[], uint[]) {
704 		
705 		uint _remainingTickets = game.rules.slots - game.ticketsSold;
706 		bool[] memory _tickets = new bool[](game.rules.slots);
707 		uint[] memory _userTickets = getMyTickets();
708 
709 		for (uint i = 0; i < game.rules.slots; i++)
710 			_tickets[i] = game.tickets[i + 1] == address(0);
711 
712 		return (game.id, game.rules.jackpot, game.rules.slots, _remainingTickets, 
713 			game.rules.ticketPrice, game.rules.maxTicketsPer, state, _tickets, _userTickets);
714 	}
715 
716 	/*
717 	 * PUBLIC
718 	 * Get information pertaining to the last game
719 	 *
720 	 * returns: (id, jackpot, totalTickets, ticketPrice, winner, finishedAt)
721 	 * NOTE: tickets[] is an array of booleans, true = available and false = sold
722 	 */
723 	function getLastGame() public view returns(uint, uint, uint, uint, address, uint) {
724 		return (lastGame.id, lastGame.rules.jackpot, lastGame.rules.slots, 
725 			lastGame.rules.ticketPrice, lastGame.winner, lastGame.finishedAt);
726 	}
727 
728 	// ---------------------------------------------------------------------
729 	// Affiliates
730 
731 	uint[] currentGameAffiliates;
732 	uint numAffiliates;
733 	uint affiliateCut = 2; // Example: 2 = 1/2 (50%), 3 = 1/3 (33%), etc.
734 
735 	function addAffiliate(uint _affiliate, uint _ticketCount) internal {
736 		for (uint i = 0; i < _ticketCount; i++) {
737 			if (numAffiliates >= currentGameAffiliates.length) currentGameAffiliates.length += 1;
738 			currentGameAffiliates[numAffiliates++] = _affiliate;
739 		}
740 	}
741 
742 	function payAffiliates() internal {
743 		uint profit = (game.rules.slots * game.rules.ticketPrice) - game.rules.jackpot;
744 		if (profit > this.balance) profit = this.balance;
745 
746 		uint _payment = (profit / game.rules.slots) / affiliateCut;
747 		uint _pool = _payment * numAffiliates;
748 		
749 		uint[] memory _affiliates = new uint[](numAffiliates);
750 		uint[] memory _amounts = new uint[](numAffiliates);
751 
752 		for (uint i = 0; i < numAffiliates; i++) {
753 			_affiliates[i] = currentGameAffiliates[i];
754 			_amounts[i] = _payment;
755 		}
756 
757 		// payout to given affiliates with given amounts
758 		if (numAffiliates > 0)
759 			payoutToAffiliates(_affiliates, _amounts, _pool);
760 
761 		// Clear the affiliates
762 		numAffiliates = 0;
763 	}
764 
765 	// ---------------------------------------------------------------------
766 	// Utilities
767 
768 	function randomNumberFound(uint _number, uint _secret) internal {
769 		require(state == State.Pending);
770 		require(game.id == _secret);
771 		require(_number >= 1 && _number <= game.rules.slots);
772 		winnerChosen(_number);
773 	}
774 
775 	function failPurchase(PurchaseError _error) internal {
776 		PurchaseFailed(msg.sender, _error);
777 		refund(msg.value);
778 	}
779 
780 	function refund(uint _amount) internal {
781 		if (_amount > 0 && _amount <= msg.value) {
782 			msg.sender.transfer(_amount);
783 		} else if (_amount > msg.value) {
784 			msg.sender.transfer(msg.value);
785 		}
786 	}
787 }