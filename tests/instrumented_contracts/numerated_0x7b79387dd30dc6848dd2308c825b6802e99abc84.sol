1 // VERSION M(A)
2 
3 pragma solidity ^0.4.8;
4 
5 
6 //
7 // FOR REFERENCE - INCLUDE  iE4RowEscrow  (interface) CONTRACT at the top .....
8 //
9 
10 contract iE4RowEscrow {
11 	function getNumGamesStarted() constant returns (int ngames);
12 }
13 
14 // Abstract contract for the full ERC 20 Token standard
15 // https://github.com/ethereum/EIPs/issues/20
16 
17 // ---------------------------------
18 // ABSTRACT standard token class
19 // ---------------------------------
20 contract Token { 
21     function totalSupply() constant returns (uint256 supply);
22     function balanceOf(address _owner) constant returns (uint256 balance);
23     function transfer(address _to, uint256 _value) returns (bool success);
24     function transferFrom(address _from, address _to, uint256 _value) returns (bool success);
25     function approve(address _spender, uint256 _value) returns (bool success);
26     function allowance(address _owner, address _spender) constant returns (uint256 remaining);
27 
28     event Transfer(address indexed _from, address indexed _to, uint256 _value);
29     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
30 }
31 
32 
33 // --------------------------
34 //  E4RowRewards - abstract e4 dividend contract
35 // --------------------------
36 contract E4RowRewards
37 {
38 	function checkDividends(address _addr) constant returns(uint _amount);
39 	function withdrawDividends() public returns (uint namount);
40 }
41 
42 // --------------------------
43 //  Finney Chip - token contract
44 // --------------------------
45 contract E4Token is Token, E4RowRewards {
46     	event StatEvent(string msg);
47     	event StatEventI(string msg, uint val);
48 
49 	enum SettingStateValue  {debug, release, lockedRelease}
50 	enum IcoStatusValue {anouncement, saleOpen, saleClosed, failed, succeeded}
51 
52 
53 
54 
55 	struct tokenAccount {
56 		bool alloced; // flag to ascert prior allocation
57 		uint tokens; // num tokens
58 		uint balance; // rewards balance
59 	}
60 // -----------------------------
61 //  data storage
62 // ----------------------------------------
63 	address developers; // developers token holding address
64 	address public owner; // deployer executor
65 	address founderOrg; // founder orginaization contract
66 	address auxPartner; // aux partner (pr/auditing) - 1 percent upon close
67 	address e4_partner; // e4row  contract addresses
68 
69 
70 	mapping (address => tokenAccount) holderAccounts ; // who holds how many tokens (high two bytes contain curPayId)
71 	mapping (uint => address) holderIndexes ; // for iteration thru holder
72 	uint numAccounts;
73 
74 	uint partnerCredits; // amount partner (e4row)  has paid
75 	mapping (address => mapping (address => uint256)) allowed; // approvals
76 
77 
78 	uint maxMintableTokens; // ...
79 	uint minIcoTokenGoal;// token goal by sale end
80 	uint minUsageGoal; //  num games goal by usage deadline
81 	uint public  tokenPrice; // price per token
82 	uint public payoutThreshold; // threshold till payout
83 
84 	uint totalTokenFundsReceived; 	// running total of token funds received
85 	uint public totalTokensMinted; 	// total number of tokens minted
86 	uint public holdoverBalance; 		// hold this amount until threshhold before reward payout
87 	int public payoutBalance; 		// hold this amount until threshhold before reward payout
88 	int prOrigPayoutBal;			// original payout balance before run
89 	uint prOrigTokensMint; 			// tokens minted at start of pay run
90 	uint public curPayoutId;		// current payout id
91 	uint public lastPayoutIndex;		// payout idx between run segments
92 	uint public maxPaysPer;			// num pays per segment
93 	uint public minPayInterval;		// min interval between start pay run
94 
95 
96 	uint fundingStart; 		// funding start time immediately after anouncement
97 	uint fundingDeadline; 		// funding end time
98 	uint usageDeadline; 		// deadline where minimum usage needs to be met before considered success
99 	uint public lastPayoutTime; 	// timestamp of last payout time
100 	uint vestTime; 		// 1 year past sale vest developer tokens
101 	uint numDevTokens; 	// 10 per cent of tokens after close to developers
102 	bool developersGranted; 		// flag
103 	uint remunerationStage; 	// 0 for not yet, 1 for 10 percent, 2 for remaining  upon succeeded.
104 	uint public remunerationBalance; 	// remuneration balance to release token funds
105 	uint auxPartnerBalance; 	// aux partner balance - 1 percent
106 	uint rmGas; // remuneration gas
107 	uint rwGas; // reward gas
108 	uint rfGas; // refund gas
109 
110 	IcoStatusValue icoStatus;  // current status of ico
111 	SettingStateValue public settingsState;
112 
113 
114 	// --------------------
115 	// contract constructor
116 	// --------------------
117 	function E4Token() 
118 	{
119 		owner = msg.sender;
120 		developers = msg.sender;
121 	}
122 
123 	// -----------------------------------
124 	// use this to reset everything, will never be called after lockRelease
125 	// -----------------------------------
126 	function applySettings(SettingStateValue qState, uint _saleStart, uint _saleEnd, uint _usageEnd, uint _minUsage, uint _tokGoal, uint  _maxMintable, uint _threshold, uint _price, uint _mpp, uint _mpi )
127 	{
128 		if (msg.sender != owner) 
129 			return;
130 
131 		// these settings are permanently tweakable for performance adjustments
132 		payoutThreshold = _threshold;
133 		maxPaysPer = _mpp;
134 		minPayInterval = _mpi;
135 
136 		// this first test checks if already locked
137 		if (settingsState == SettingStateValue.lockedRelease)
138 			return;
139 
140  	 	settingsState = qState;
141 
142 		// this second test allows locking without changing other permanent settings
143 		// WARNING, MAKE SURE YOUR'RE HAPPY WITH ALL SETTINGS 
144 		// BEFORE LOCKING
145 
146 		if (qState == SettingStateValue.lockedRelease) {
147 			StatEvent("Locking!");
148 			return;
149 		}
150 
151 		icoStatus = IcoStatusValue.anouncement;
152 
153 		rmGas = 100000; // remuneration gas
154 		rwGas = 10000; // reward gas
155 		rfGas = 10000; // refund gas
156 
157 
158 		// zero out all token holders.  
159 		// leave alloced on, leave num accounts
160 		// cant delete them anyways
161 	
162 		if (totalTokensMinted > 0) {
163 			for (uint i = 0; i < numAccounts; i++ ) {
164 				address a = holderIndexes[i];
165 				if (a != address(0)) {
166 					holderAccounts[a].tokens = 0;
167 					holderAccounts[a].balance = 0;
168 				}
169 			}
170 		}
171 		// do not reset numAccounts!
172 
173 		totalTokensMinted = 0; // this will erase
174 		totalTokenFundsReceived = 0; // this will erase.
175 		partnerCredits = 0; // reset all partner credits
176 
177 		fundingStart =  _saleStart;
178 		fundingDeadline = _saleEnd;
179 		usageDeadline = _usageEnd;
180 		minUsageGoal = _minUsage;
181 		minIcoTokenGoal = _tokGoal;
182 		maxMintableTokens = _maxMintable;
183 		tokenPrice = _price;
184 
185 		vestTime = fundingStart + (365 days);
186 		numDevTokens = 0;
187 		
188 		holdoverBalance = 0;
189 		payoutBalance = 0;
190 		curPayoutId = 1;
191 		lastPayoutIndex = 0;
192 		remunerationStage = 0;
193 		remunerationBalance = 0;
194 		auxPartnerBalance = 0;
195 		developersGranted = false;
196 		lastPayoutTime = 0;
197 
198 		if (this.balance > 0) {
199 			if (!owner.call.gas(rfGas).value(this.balance)())
200 				StatEvent("ERROR!");
201 		}
202 		StatEvent("ok");
203 
204 	}
205 
206 
207 	// ---------------------------------------------------
208 	// tokens held reserve the top two bytes for the payid last paid.
209 	// this is so holders at the top of the list dont transfer tokens 
210 	// to themselves on the bottom of the list thus scamming the 
211 	// system. this function deconstructs the tokenheld value.
212 	// ---------------------------------------------------
213 	function getPayIdAndHeld(uint _tokHeld) internal returns (uint _payId, uint _held)
214 	{
215 		_payId = (_tokHeld / (2 ** 48)) & 0xffff;
216 		_held = _tokHeld & 0xffffffffffff;
217 	}
218 	function getHeld(uint _tokHeld) internal  returns (uint _held)
219 	{
220 		_held = _tokHeld & 0xffffffffffff;
221 	}
222 	// ---------------------------------------------------
223 	// allocate a new account by setting alloc to true
224 	// set the top to bytes of tokens to cur pay id to leave out of current round
225 	// add holder index, bump the num accounts
226 	// ---------------------------------------------------
227 	function addAccount(address _addr) internal  {
228 		holderAccounts[_addr].alloced = true;
229 		holderAccounts[_addr].tokens = (curPayoutId * (2 ** 48));
230 		holderIndexes[numAccounts++] = _addr;
231 	}
232 	
233 
234 // --------------------------------------
235 // BEGIN ERC-20 from StandardToken
236 // --------------------------------------
237 	function totalSupply() constant returns (uint256 supply)
238 	{
239 		if (icoStatus == IcoStatusValue.saleOpen
240 			|| icoStatus == IcoStatusValue.anouncement)
241 			supply = maxMintableTokens;
242 		else
243 			supply = totalTokensMinted;
244 	}
245 
246 	function transfer(address _to, uint256 _value) returns (bool success) {
247 
248 		if ((msg.sender == developers) 
249 			&&  (now < vestTime)) {
250 			//statEvent("Tokens not yet vested.");
251 			return false;
252 		}
253 
254 
255 	        //Default assumes totalSupply can't be over max (2^256 - 1).
256 	        //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
257 	        //Replace the if with this one instead.
258 	        //if (holderAccounts[msg.sender] >= _value && balances[_to] + _value > holderAccounts[_to]) {
259 
260 		var (pidFrom, heldFrom) = getPayIdAndHeld(holderAccounts[msg.sender].tokens);
261 	        if (heldFrom >= _value && _value > 0) {
262 
263 	            holderAccounts[msg.sender].tokens -= _value;
264 
265 		    if (!holderAccounts[_to].alloced) {
266 			addAccount(_to);
267 		    }
268 
269 		    uint newHeld = _value + getHeld(holderAccounts[_to].tokens);
270 		    if (icoStatus == IcoStatusValue.saleOpen) // avoid mcgees gambit
271 		    	pidFrom = curPayoutId;
272 		    holderAccounts[_to].tokens = newHeld | (pidFrom * (2 ** 48));
273 
274 	            Transfer(msg.sender, _to, _value);
275 	            return true;
276 	        } else { 
277 			return false; 
278 		}
279     	}
280 
281     	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
282 
283 		if ((_from == developers) 
284 			&&  (now < vestTime)) {
285 			//statEvent("Tokens not yet vested.");
286 			return false;
287 		}
288 
289 
290         //same as above. Replace this line with the following if you want to protect against wrapping uints.
291         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
292 
293 		var (pidFrom, heldFrom) = getPayIdAndHeld(holderAccounts[_from].tokens);
294         	if (heldFrom >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
295 	            holderAccounts[_from].tokens -= _value;
296 
297 		    if (!holderAccounts[_to].alloced)
298 			addAccount(_to);
299 
300 		    uint newHeld = _value + getHeld(holderAccounts[_to].tokens);
301 
302 		    if (icoStatus == IcoStatusValue.saleOpen) // avoid mcgees gambit
303 		    	pidFrom = curPayoutId;
304 		    holderAccounts[_to].tokens = newHeld | (pidFrom * (2 ** 48));
305 
306 	            allowed[_from][msg.sender] -= _value;
307 	            Transfer(_from, _to, _value);
308 	            return true;
309 	        } else { 
310 		    return false; 
311 		}
312 	}
313 
314 
315     	function balanceOf(address _owner) constant returns (uint256 balance) {
316 		// vars default to 0
317 		if (holderAccounts[_owner].alloced) {
318 	        	balance = getHeld(holderAccounts[_owner].tokens);
319 		} 
320     	}
321 
322     	function approve(address _spender, uint256 _value) returns (bool success) {
323         	allowed[msg.sender][_spender] = _value;
324         	Approval(msg.sender, _spender, _value);
325         	return true;
326     	}
327 
328     	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
329       		return allowed[_owner][_spender];
330     	}
331 // ----------------------------------
332 // END ERC20
333 // ----------------------------------
334 
335   
336 
337 
338 
339 	// -------------------------------------------
340 	// default payable function.
341 	// if sender is e4row  partner, this is a rake fee payment
342 	// otherwise this is a token purchase.
343 	// tokens only purchaseable between tokenfundingstart and end
344 	// -------------------------------------------
345 	function () payable {
346 		if (msg.sender == e4_partner) {
347 		     feePayment(); // from e4row game escrow contract
348 		} else {
349 		     purchaseToken();
350 		}
351 	}
352 
353 	// -----------------------------
354 	// purchase token function - tokens only sold during sale period up until the max tokens
355 	// purchase price is tokenPrice.  all units in wei.
356 	// purchaser will not be included in current pay run
357 	// -----------------------------
358 	function purchaseToken() payable {
359 
360 		uint nvalue = msg.value; // being careful to preserve msg.value
361 		address npurchaser = msg.sender;
362 		if (nvalue < tokenPrice) 
363 			throw;
364 
365 		uint qty = nvalue/tokenPrice;
366 		updateIcoStatus();
367 		if (icoStatus != IcoStatusValue.saleOpen) // purchase is closed
368 			throw;
369 		if (totalTokensMinted + qty > maxMintableTokens)
370 			throw;
371 		if (!holderAccounts[npurchaser].alloced)
372 			addAccount(npurchaser);
373 		
374 		// purchaser waits for next payrun. otherwise can disrupt cur pay run
375 		uint newHeld = qty + getHeld(holderAccounts[npurchaser].tokens);
376 		holderAccounts[npurchaser].tokens = newHeld | (curPayoutId * (2 ** 48));
377 
378 		totalTokensMinted += qty;
379 		totalTokenFundsReceived += nvalue;
380 
381 		if (totalTokensMinted == maxMintableTokens) {
382 			icoStatus = IcoStatusValue.saleClosed;
383 			//test unnecessary -  if (getNumTokensPurchased() >= minIcoTokenGoal)
384 			doDeveloperGrant();
385 			StatEventI("Purchased,Granted", qty);
386 		} else
387 			StatEventI("Purchased", qty);
388 
389 	}
390 
391 
392 	// ---------------------------
393 	// accept payment from e4row contract
394 	// WARNING! DO NOT CALL THIS FUNCTION LEST YOU LOSE YOUR MONEY
395 	// HOWEVER ADD THIS GIFT TO THE HOLDOVERBALANCE
396 	// YOU HAVE BEEN WARNED
397 	// ---------------------------
398 	function feePayment() payable  
399 	{
400 		if (msg.sender != e4_partner) {
401 			if (msg.value > 0)
402 				holdoverBalance += msg.value;
403 			StatEvent("forbidden");
404 			return; // thank you
405 		}
406 		uint nfvalue = msg.value; // preserve value in case changed in dev grant
407 
408 		updateIcoStatus();
409 
410 		holdoverBalance += nfvalue;
411 		partnerCredits += nfvalue;
412 		StatEventI("Payment", nfvalue);
413 
414 		if (holdoverBalance > payoutThreshold
415 			|| payoutBalance > 0)
416 			doPayout(maxPaysPer);
417 		
418 	
419 	}
420 
421 	// ---------------------------
422 	// set the e4row partner, this is only done once
423 	// ---------------------------
424 	function setE4RowPartner(address _addr) public	
425 	{
426 	// ONLY owner can set and ONLY ONCE! (unless "unlocked" debug)
427 	// once its locked. ONLY ONCE!
428 		if (msg.sender == owner) {
429 			if ((e4_partner == address(0)) || (settingsState == SettingStateValue.debug)) {
430 				e4_partner = _addr;
431 				partnerCredits = 0;
432 				//StatEventI("E4-Set", 0);
433 			} else {
434 				StatEvent("Already Set");
435 			}
436 		}
437 	}
438 
439 	// ----------------------------
440 	// return the total tokens purchased
441 	// ----------------------------
442 	function getNumTokensPurchased() constant returns(uint _purchased)
443 	{
444 		_purchased = totalTokensMinted-numDevTokens;
445 	}
446 
447 	// ----------------------------
448 	// return the num games as reported from the e4row  contract
449 	// ----------------------------
450 	function getNumGames() constant returns(uint _games)
451 	{
452 		//_games = 0;
453 		if (e4_partner != address(0)) {
454 			iE4RowEscrow pe4 = iE4RowEscrow(e4_partner);
455 			_games = uint(pe4.getNumGamesStarted());
456 		} 
457 		//else
458 		//StatEvent("Empty E4");
459 	}
460 
461 	// ------------------------------------------------
462 	// get the founders, auxPartner, developer
463 	// --------------------------------------------------
464 	function getSpecialAddresses() constant returns (address _fndr, address _aux, address _dev, address _e4)
465 	{
466 		//if (_sender == owner) { // no msg.sender on constant functions at least in mew
467 			_fndr = founderOrg;
468 			_aux = auxPartner;
469 			_dev = developers;
470 			_e4  = e4_partner;
471 		//}
472 	}
473 
474 
475 
476 	// ----------------------------
477 	// update the ico status
478 	// ----------------------------
479 	function updateIcoStatus() public
480 	{
481 		if (icoStatus == IcoStatusValue.succeeded 
482 			|| icoStatus == IcoStatusValue.failed)
483 			return;
484 		else if (icoStatus == IcoStatusValue.anouncement) {
485 			if (now > fundingStart && now <= fundingDeadline) {
486 				icoStatus = IcoStatusValue.saleOpen;
487 				
488 			} else if (now > fundingDeadline) {
489 				// should not be here - this will eventually fail
490 				icoStatus = IcoStatusValue.saleClosed;
491 			}
492 		} else {
493 			uint numP = getNumTokensPurchased();
494 			uint numG = getNumGames();
495 			if ((now > fundingDeadline && numP < minIcoTokenGoal)
496 				|| (now > usageDeadline && numG < minUsageGoal)) {
497 				icoStatus = IcoStatusValue.failed;
498 			} else if ((now > fundingDeadline) // dont want to prevent more token sales
499 				&& (numP >= minIcoTokenGoal)
500 				&& (numG >= minUsageGoal)) {
501 				icoStatus = IcoStatusValue.succeeded; // hooray
502 			}
503 			if (icoStatus == IcoStatusValue.saleOpen
504 				&& ((numP >= maxMintableTokens)
505 				|| (now > fundingDeadline))) {
506 					icoStatus = IcoStatusValue.saleClosed;
507 				}
508 		}
509 
510 		if (!developersGranted
511 			&& icoStatus != IcoStatusValue.saleOpen 
512 			&& icoStatus != IcoStatusValue.anouncement
513 			&& getNumTokensPurchased() >= minIcoTokenGoal) {
514 				doDeveloperGrant(); // grant whenever status goes from open to anything...
515 		}
516 
517 	
518 	}
519 
520 	
521 	// ----------------------------
522 	// request refund. Caller must call to request and receive refund 
523 	// WARNING - withdraw rewards/dividends before calling.
524 	// YOU HAVE BEEN WARNED
525 	// ----------------------------
526 	function requestRefund()
527 	{
528 		address nrequester = msg.sender;
529 		updateIcoStatus();
530 
531 		uint ntokens = getHeld(holderAccounts[nrequester].tokens);
532 		if (icoStatus != IcoStatusValue.failed)
533 			StatEvent("No Refund");
534 		else if (ntokens == 0)
535 			StatEvent("No Tokens");
536 		else {
537 			uint nrefund = ntokens * tokenPrice;
538 			if (getNumTokensPurchased() >= minIcoTokenGoal)
539 				nrefund -= (nrefund /10); // only 90 percent b/c 10 percent payout
540 
541 			if (!holderAccounts[developers].alloced) 
542 				addAccount(developers);
543 			holderAccounts[developers].tokens += ntokens;
544 			holderAccounts[nrequester].tokens = 0;
545 			if (holderAccounts[nrequester].balance > 0) {
546 				// see above warning!!
547 				holderAccounts[developers].balance += holderAccounts[nrequester].balance;
548 				holderAccounts[nrequester].balance = 0;
549 			}
550 
551 			if (!nrequester.call.gas(rfGas).value(nrefund)())
552 				throw;
553 			//StatEventI("Refunded", nrefund);
554 		}
555 	}
556 
557 
558 
559 	// ---------------------------------------------------
560 	// payout rewards to all token holders
561 	// use a second holding variable called PayoutBalance to do 
562 	// the actual payout from b/c too much gas to iterate thru 
563 	// each payee. Only start a new run at most once per "minpayinterval".
564 	// Its done in runs of "_numPays"
565 	// we use special coding for the holderAccounts to avoid a hack
566 	// of getting paid at the top of the list then transfering tokens
567 	// to another address at the bottom of the list.
568 	// because of that each holderAccounts entry gets the payoutid stamped upon it (top two bytes)
569 	// also a token transfer will transfer the payout id.
570 	// ---------------------------------------------------
571 	function doPayout(uint _numPays)  internal
572 	{
573 		if (totalTokensMinted == 0)
574 			return;
575 
576 		if ((holdoverBalance > 0) 
577 			&& (payoutBalance == 0)
578 			&& (now > (lastPayoutTime+minPayInterval))) {
579 			// start a new run
580 			curPayoutId++;
581 			if (curPayoutId >= 32768)
582 				curPayoutId = 1;
583 			lastPayoutTime = now;
584 			payoutBalance = int(holdoverBalance);
585 			prOrigPayoutBal = payoutBalance;
586 			prOrigTokensMint = totalTokensMinted;
587 			holdoverBalance = 0;
588 			lastPayoutIndex = 0;
589 			StatEventI("StartRun", uint(curPayoutId));
590 		} else if (payoutBalance > 0) {
591 			// work down the p.o.b
592 			uint nAmount;
593 			uint nPerTokDistrib = uint(prOrigPayoutBal)/prOrigTokensMint;
594 			uint paids = 0;
595 			uint i; // intentional
596 			for (i = lastPayoutIndex; (paids < _numPays) && (i < numAccounts) && (payoutBalance > 0); i++ ) {
597 				address a = holderIndexes[i];
598 				if (a == address(0)) {
599 					continue;
600 				}
601 				var (pid, held) = getPayIdAndHeld(holderAccounts[a].tokens);
602 				if ((held > 0) && (pid != curPayoutId)) {
603 					nAmount = nPerTokDistrib * held;
604 					if (int(nAmount) <= payoutBalance){
605 						holderAccounts[a].balance += nAmount; 
606 						holderAccounts[a].tokens = (curPayoutId * (2 ** 48)) | held;
607 						payoutBalance -= int(nAmount);					
608 						paids++;
609 					}
610 				}
611 			}
612 			lastPayoutIndex = i;
613 			if (lastPayoutIndex >= numAccounts || payoutBalance <= 0) {
614 				lastPayoutIndex = 0;
615 				if (payoutBalance > 0)
616 					holdoverBalance += uint(payoutBalance);// put back any leftovers
617 				payoutBalance = 0;
618 				StatEventI("RunComplete", uint(prOrigPayoutBal) );
619 
620 			} else {
621 				StatEventI("PayRun", paids );
622 			}
623 		}
624 		
625 	}
626 
627 
628 	// ----------------------------
629 	// sender withdraw entire rewards/dividends
630 	// ----------------------------
631 	function withdrawDividends() public returns (uint _amount)
632 	{
633 		if (holderAccounts[msg.sender].balance == 0) { 
634 			//_amount = 0;
635 			StatEvent("0 Balance");
636 			return;
637 		} else {
638 			if ((msg.sender == developers) 
639 				&&  (now < vestTime)) {
640 				//statEvent("Tokens not yet vested.");
641 				//_amount = 0;
642 				return;
643 			}
644 
645 			_amount = holderAccounts[msg.sender].balance; 
646 			holderAccounts[msg.sender].balance = 0; 
647 			if (!msg.sender.call.gas(rwGas).value(_amount)())
648 				throw;
649 			//StatEventI("Paid", _amount);
650 	
651 		}
652 
653 	}
654 
655 	// ----------------------------
656 	// set gas for operations
657 	// ----------------------------
658 	function setOpGas(uint _rm, uint _rf, uint _rw)
659 	{
660 		if (msg.sender != owner && msg.sender != developers) {
661 			//StatEvent("only owner calls");
662 			return;
663 		} else {
664 			rmGas = _rm;
665 			rfGas = _rf;
666 			rwGas = _rw;
667 		}
668 	}
669 
670 	// ----------------------------
671 	// get gas for operations
672 	// ----------------------------
673 	function getOpGas() constant returns (uint _rm, uint _rf, uint _rw)
674 	{
675 		_rm = rmGas;
676 		_rf = rfGas;
677 		_rw = rwGas;
678 	}
679  
680 
681 	// ----------------------------
682 	// check rewards.  pass in address of token holder
683 	// ----------------------------
684 	function checkDividends(address _addr) constant returns(uint _amount)
685 	{
686 		if (holderAccounts[_addr].alloced)
687 			_amount = holderAccounts[_addr].balance;
688 	}		
689 
690 
691 	// ------------------------------------------------
692 	// icoCheckup - check up call for administrators
693 	// after sale is closed if min ico tokens sold, 10 percent will be distributed to 
694 	// company to cover various operating expenses
695 	// after sale and usage dealines have been met, remaining 90 percent will be distributed to
696 	// company.
697 	// ------------------------------------------------
698 	function icoCheckup() public
699 	{
700 		if (msg.sender != owner && msg.sender != developers)
701 			throw;
702 
703 		uint nmsgmask;
704 		//nmsgmask = 0;
705 	
706 		if (icoStatus == IcoStatusValue.saleClosed) {
707 			if ((getNumTokensPurchased() >= minIcoTokenGoal)
708 				&& (remunerationStage == 0 )) {
709 				remunerationStage = 1;
710 				remunerationBalance = (totalTokenFundsReceived/100)*9; // 9 percent
711 				auxPartnerBalance =  (totalTokenFundsReceived/100); // 1 percent
712 				nmsgmask |= 1;
713 			} 
714 		}
715 		if (icoStatus == IcoStatusValue.succeeded) {
716 		
717 			if (remunerationStage == 0 ) {
718 				remunerationStage = 1;
719 				remunerationBalance = (totalTokenFundsReceived/100)*9; 
720 				auxPartnerBalance =  (totalTokenFundsReceived/100);
721 				nmsgmask |= 4;
722 			}
723 			if (remunerationStage == 1) { // we have already suceeded
724 				remunerationStage = 2;
725 				remunerationBalance += totalTokenFundsReceived - (totalTokenFundsReceived/10); // 90 percent
726 				nmsgmask |= 8;
727 			}
728 
729 		}
730 
731 		uint ntmp;
732 
733 		if (remunerationBalance > 0) { 
734 		// only pay one entity per call, dont want to run out of gas
735 				ntmp = remunerationBalance;
736 				remunerationBalance = 0;
737 				if (!founderOrg.call.gas(rmGas).value(ntmp)()) {
738 					remunerationBalance = ntmp;
739 					nmsgmask |= 32;
740 				} else {
741 					nmsgmask |= 64;
742 				}	
743 		} else 	if (auxPartnerBalance > 0) {
744 		// note the "else" only pay one entity per call, dont want to run out of gas
745 			ntmp = auxPartnerBalance;
746 			auxPartnerBalance = 0;
747 			if (!auxPartner.call.gas(rmGas).value(ntmp)()) {
748 				auxPartnerBalance = ntmp;
749 				nmsgmask |= 128;
750 			}  else {
751 				nmsgmask |= 256;
752 			}
753 
754 		} 
755 		
756 		StatEventI("ico-checkup", nmsgmask);
757 	}
758 
759 
760 	// ----------------------------
761 	// swap executor
762 	// ----------------------------
763 	function changeOwner(address _addr) 
764 	{
765 		if (msg.sender != owner
766 			|| settingsState == SettingStateValue.lockedRelease)
767 			 throw;
768 
769 		owner = _addr;
770 	}
771 
772 	// ----------------------------
773 	// swap developers account
774 	// ----------------------------
775 	function changeDevevoperAccont(address _addr) 
776 	{
777 		if (msg.sender != owner
778 			|| settingsState == SettingStateValue.lockedRelease)
779 			 throw;
780 		developers = _addr;
781 	}
782 
783 	// ----------------------------
784 	// change founder
785 	// ----------------------------
786 	function changeFounder(address _addr) 
787 	{
788 		if (msg.sender != owner
789 			|| settingsState == SettingStateValue.lockedRelease)
790 			 throw;
791 		founderOrg = _addr;
792 	}
793 
794 	// ----------------------------
795 	// change auxPartner
796 	// ----------------------------
797 	function changeAuxPartner(address _aux) 
798 	{
799 		if (msg.sender != owner
800 			|| settingsState == SettingStateValue.lockedRelease)
801 			 throw;
802 		auxPartner = _aux;
803 	}
804 
805 
806 	// ----------------------------
807 	// DEBUG ONLY - end this contract, suicide to developers
808 	// ----------------------------
809 	function haraKiri()
810 	{
811 		if (settingsState != SettingStateValue.debug)
812 			throw;
813 		if (msg.sender != owner)
814 			 throw;
815 		suicide(developers);
816 	}
817 
818 	// ----------------------------
819 	// get all ico status, funding and usage info
820 	// ----------------------------
821 	function getIcoInfo() constant returns(IcoStatusValue _status, uint _saleStart, uint _saleEnd, uint _usageEnd, uint _saleGoal, uint _usageGoal, uint _sold, uint _used, uint _funds, uint _credits, uint _remuStage, uint _vest)
822 	{
823 		_status = icoStatus;
824 		_saleStart = fundingStart;
825 		_saleEnd = fundingDeadline;
826 		_usageEnd = usageDeadline;
827 		_vest = vestTime;
828 		_saleGoal = minIcoTokenGoal;
829 		_usageGoal = minUsageGoal;
830 		_sold = getNumTokensPurchased();
831 		_used = getNumGames();
832 		_funds = totalTokenFundsReceived;
833 		_credits = partnerCredits;
834 		_remuStage = remunerationStage;
835 	}
836 
837 	// ----------------------------
838 	// NOTE! CALL AT THE RISK OF RUNNING OUT OF GAS.
839 	// ANYONE CAN CALL THIS FUNCTION BUT YOU HAVE TO SUPPLY 
840 	// THE CORRECT AMOUNT OF GAS WHICH MAY DEPEND ON 
841 	// THE _NUMPAYS PARAMETER.  WHICH MUST BE BETWEEN 1 AND 1000
842 	// THE STANDARD VALUE IS STORED IN "maxPaysPer"
843 	// ----------------------------
844 	function flushDividends(uint _numPays)
845 	{
846 		if ((_numPays == 0) || (_numPays > 1000)) {
847 			StatEvent("Invalid.");
848 		} else if (holdoverBalance > 0 || payoutBalance > 0) {
849 			doPayout(_numPays);
850 		} else {
851 			StatEvent("Nothing to do.");
852 		}
853 				
854 	}
855 
856 	function doDeveloperGrant() internal
857 	{
858 		if (!developersGranted) {
859 			developersGranted = true;
860 			numDevTokens = (totalTokensMinted * 15)/100;
861 			totalTokensMinted += numDevTokens;
862 			if (!holderAccounts[developers].alloced) 
863 				addAccount(developers);
864 			uint newHeld = getHeld(holderAccounts[developers].tokens) + numDevTokens;
865 			holderAccounts[developers].tokens = newHeld |  (curPayoutId * (2 ** 48));
866 
867 		}
868 	}
869 
870 
871 }