1 // VERSION K
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
270 		    holderAccounts[_to].tokens = newHeld | (pidFrom * (2 ** 48));
271 	            Transfer(msg.sender, _to, _value);
272 	            return true;
273 	        } else { 
274 			return false; 
275 		}
276     	}
277 
278     	function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
279 
280 		if ((_from == developers) 
281 			&&  (now < vestTime)) {
282 			//statEvent("Tokens not yet vested.");
283 			return false;
284 		}
285 
286 
287         //same as above. Replace this line with the following if you want to protect against wrapping uints.
288         //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
289 
290 		var (pidFrom, heldFrom) = getPayIdAndHeld(holderAccounts[_from].tokens);
291         	if (heldFrom >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
292 	            holderAccounts[_from].tokens -= _value;
293 
294 		    if (!holderAccounts[_to].alloced)
295 			addAccount(_to);
296 
297 		    uint newHeld = _value + getHeld(holderAccounts[_to].tokens);
298 
299 		    holderAccounts[_to].tokens = newHeld | (pidFrom * (2 ** 48));
300 	            allowed[_from][msg.sender] -= _value;
301 	            Transfer(_from, _to, _value);
302 	            return true;
303 	        } else { 
304 		    return false; 
305 		}
306 	}
307 
308 
309     	function balanceOf(address _owner) constant returns (uint256 balance) {
310 		// vars default to 0
311 		if (holderAccounts[_owner].alloced) {
312 	        	balance = getHeld(holderAccounts[_owner].tokens);
313 		} 
314     	}
315 
316     	function approve(address _spender, uint256 _value) returns (bool success) {
317         	allowed[msg.sender][_spender] = _value;
318         	Approval(msg.sender, _spender, _value);
319         	return true;
320     	}
321 
322     	function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
323       		return allowed[_owner][_spender];
324     	}
325 // ----------------------------------
326 // END ERC20
327 // ----------------------------------
328 
329   
330 
331 
332 
333 	// -------------------------------------------
334 	// default payable function.
335 	// if sender is e4row  partner, this is a rake fee payment
336 	// otherwise this is a token purchase.
337 	// tokens only purchaseable between tokenfundingstart and end
338 	// -------------------------------------------
339 	function () payable {
340 		if (msg.sender == e4_partner) {
341 		     feePayment(); // from e4row game escrow contract
342 		} else {
343 		     purchaseToken();
344 		}
345 	}
346 
347 	// -----------------------------
348 	// purchase token function - tokens only sold during sale period up until the max tokens
349 	// purchase price is tokenPrice.  all units in wei.
350 	// purchaser will not be included in current pay run
351 	// -----------------------------
352 	function purchaseToken() payable {
353 
354 		uint nvalue = msg.value; // being careful to preserve msg.value
355 		address npurchaser = msg.sender;
356 		if (nvalue < tokenPrice) 
357 			throw;
358 
359 		uint qty = nvalue/tokenPrice;
360 		updateIcoStatus();
361 		if (icoStatus != IcoStatusValue.saleOpen) // purchase is closed
362 			throw;
363 		if (totalTokensMinted + qty > maxMintableTokens)
364 			throw;
365 		if (!holderAccounts[npurchaser].alloced)
366 			addAccount(npurchaser);
367 		
368 		// purchaser waits for next payrun. otherwise can disrupt cur pay run
369 		uint newHeld = qty + getHeld(holderAccounts[npurchaser].tokens);
370 		holderAccounts[npurchaser].tokens = newHeld | (curPayoutId * (2 ** 48));
371 
372 		totalTokensMinted += qty;
373 		totalTokenFundsReceived += nvalue;
374 
375 		if (totalTokensMinted == maxMintableTokens) {
376 			icoStatus = IcoStatusValue.saleClosed;
377 			//test unnecessary -  if (getNumTokensPurchased() >= minIcoTokenGoal)
378 			doDeveloperGrant();
379 			StatEventI("Purchased,Granted", qty);
380 		} else
381 			StatEventI("Purchased", qty);
382 
383 	}
384 
385 
386 	// ---------------------------
387 	// accept payment from e4row contract
388 	// DO NOT CALL THIS FUNCTION LEST YOU LOSE YOUR MONEY
389 	// ---------------------------
390 	function feePayment() payable  
391 	{
392 		if (msg.sender != e4_partner) {
393 			StatEvent("forbidden");
394 			return; // thank you
395 		}
396 		uint nfvalue = msg.value; // preserve value in case changed in dev grant
397 
398 		updateIcoStatus();
399 
400 		holdoverBalance += nfvalue;
401 		partnerCredits += nfvalue;
402 		StatEventI("Payment", nfvalue);
403 
404 		if (holdoverBalance > payoutThreshold
405 			|| payoutBalance > 0)
406 			doPayout(maxPaysPer);
407 		
408 	
409 	}
410 
411 	// ---------------------------
412 	// set the e4row partner, this is only done once
413 	// ---------------------------
414 	function setE4RowPartner(address _addr) public	
415 	{
416 	// ONLY owner can set and ONLY ONCE! (unless "unlocked" debug)
417 	// once its locked. ONLY ONCE!
418 		if (msg.sender == owner) {
419 			if ((e4_partner == address(0)) || (settingsState == SettingStateValue.debug)) {
420 				e4_partner = _addr;
421 				partnerCredits = 0;
422 				//StatEventI("E4-Set", 0);
423 			} else {
424 				StatEvent("Already Set");
425 			}
426 		}
427 	}
428 
429 	// ----------------------------
430 	// return the total tokens purchased
431 	// ----------------------------
432 	function getNumTokensPurchased() constant returns(uint _purchased)
433 	{
434 		_purchased = totalTokensMinted-numDevTokens;
435 	}
436 
437 	// ----------------------------
438 	// return the num games as reported from the e4row  contract
439 	// ----------------------------
440 	function getNumGames() constant returns(uint _games)
441 	{
442 		//_games = 0;
443 		if (e4_partner != address(0)) {
444 			iE4RowEscrow pe4 = iE4RowEscrow(e4_partner);
445 			_games = uint(pe4.getNumGamesStarted());
446 		} 
447 		//else
448 		//StatEvent("Empty E4");
449 	}
450 
451 	// ------------------------------------------------
452 	// get the founders, auxPartner, developer
453 	// --------------------------------------------------
454 	function getSpecialAddresses() constant returns (address _fndr, address _aux, address _dev, address _e4)
455 	{
456 		//if (_sender == owner) { // no msg.sender on constant functions at least in mew
457 			_fndr = founderOrg;
458 			_aux = auxPartner;
459 			_dev = developers;
460 			_e4  = e4_partner;
461 		//}
462 	}
463 
464 
465 
466 	// ----------------------------
467 	// update the ico status
468 	// ----------------------------
469 	function updateIcoStatus() public
470 	{
471 		if (icoStatus == IcoStatusValue.succeeded 
472 			|| icoStatus == IcoStatusValue.failed)
473 			return;
474 		else if (icoStatus == IcoStatusValue.anouncement) {
475 			if (now > fundingStart && now <= fundingDeadline) {
476 				icoStatus = IcoStatusValue.saleOpen;
477 				
478 			} else if (now > fundingDeadline) {
479 				// should not be here - this will eventually fail
480 				icoStatus = IcoStatusValue.saleClosed;
481 			}
482 		} else {
483 			uint numP = getNumTokensPurchased();
484 			uint numG = getNumGames();
485 			if ((now > fundingDeadline && numP < minIcoTokenGoal)
486 				|| (now > usageDeadline && numG < minUsageGoal)) {
487 				icoStatus = IcoStatusValue.failed;
488 			} else if ((now > fundingDeadline) // dont want to prevent more token sales
489 				&& (numP >= minIcoTokenGoal)
490 				&& (numG >= minUsageGoal)) {
491 				icoStatus = IcoStatusValue.succeeded; // hooray
492 			}
493 			if (icoStatus == IcoStatusValue.saleOpen
494 				&& ((numP >= maxMintableTokens)
495 				|| (now > fundingDeadline))) {
496 					icoStatus = IcoStatusValue.saleClosed;
497 				}
498 		}
499 
500 		if (!developersGranted
501 			&& icoStatus != IcoStatusValue.saleOpen 
502 			&& icoStatus != IcoStatusValue.anouncement
503 			&& getNumTokensPurchased() >= minIcoTokenGoal) {
504 				doDeveloperGrant(); // grant whenever status goes from open to anything...
505 		}
506 
507 	
508 	}
509 
510 	
511 	// ----------------------------
512 	// request refund. Caller must call to request and receive refund 
513 	// WARNING - withdraw rewards/dividends before calling.
514 	// YOU HAVE BEEN WARNED
515 	// ----------------------------
516 	function requestRefund()
517 	{
518 		address nrequester = msg.sender;
519 		updateIcoStatus();
520 
521 		uint ntokens = getHeld(holderAccounts[nrequester].tokens);
522 		if (icoStatus != IcoStatusValue.failed)
523 			StatEvent("No Refund");
524 		else if (ntokens == 0)
525 			StatEvent("No Tokens");
526 		else {
527 			uint nrefund = ntokens * tokenPrice;
528 			if (getNumTokensPurchased() >= minIcoTokenGoal)
529 				nrefund -= (nrefund /10); // only 90 percent b/c 10 percent payout
530 
531 			holderAccounts[developers].tokens += ntokens;
532 			holderAccounts[nrequester].tokens = 0;
533 			if (holderAccounts[nrequester].balance > 0) {
534 				// see above warning!!
535 				if (!holderAccounts[developers].alloced) 
536 					addAccount(developers);
537 				holderAccounts[developers].balance += holderAccounts[nrequester].balance;
538 				holderAccounts[nrequester].balance = 0;
539 			}
540 
541 			if (!nrequester.call.gas(rfGas).value(nrefund)())
542 				throw;
543 			//StatEventI("Refunded", nrefund);
544 		}
545 	}
546 
547 
548 
549 	// ---------------------------------------------------
550 	// payout rewards to all token holders
551 	// use a second holding variable called PayoutBalance to do 
552 	// the actual payout from b/c too much gas to iterate thru 
553 	// each payee. Only start a new run at most once per "minpayinterval".
554 	// Its done in runs of "_numPays"
555 	// we use special coding for the holderAccounts to avoid a hack
556 	// of getting paid at the top of the list then transfering tokens
557 	// to another address at the bottom of the list.
558 	// because of that each holderAccounts entry gets the payoutid stamped upon it (top two bytes)
559 	// also a token transfer will transfer the payout id.
560 	// ---------------------------------------------------
561 	function doPayout(uint _numPays)  internal
562 	{
563 		if (totalTokensMinted == 0)
564 			return;
565 
566 		if ((holdoverBalance > 0) 
567 			&& (payoutBalance == 0)
568 			&& (now > (lastPayoutTime+minPayInterval))) {
569 			// start a new run
570 			curPayoutId++;
571 			if (curPayoutId >= 32768)
572 				curPayoutId = 1;
573 			lastPayoutTime = now;
574 			payoutBalance = int(holdoverBalance);
575 			prOrigPayoutBal = payoutBalance;
576 			prOrigTokensMint = totalTokensMinted;
577 			holdoverBalance = 0;
578 			lastPayoutIndex = 0;
579 			StatEventI("StartRun", uint(curPayoutId));
580 		} else if (payoutBalance > 0) {
581 			// work down the p.o.b
582 			uint nAmount;
583 			uint nPerTokDistrib = uint(prOrigPayoutBal)/prOrigTokensMint;
584 			uint paids = 0;
585 			uint i; // intentional
586 			for (i = lastPayoutIndex; (paids < _numPays) && (i < numAccounts) && (payoutBalance > 0); i++ ) {
587 				address a = holderIndexes[i];
588 				if (a == address(0)) {
589 					continue;
590 				}
591 				var (pid, held) = getPayIdAndHeld(holderAccounts[a].tokens);
592 				if ((held > 0) && (pid != curPayoutId)) {
593 					nAmount = nPerTokDistrib * held;
594 					if (int(nAmount) <= payoutBalance){
595 						holderAccounts[a].balance += nAmount; 
596 						holderAccounts[a].tokens = (curPayoutId * (2 ** 48)) | held;
597 						payoutBalance -= int(nAmount);					
598 						paids++;
599 					}
600 				}
601 			}
602 			lastPayoutIndex = i;
603 			if (lastPayoutIndex >= numAccounts || payoutBalance <= 0) {
604 				lastPayoutIndex = 0;
605 				if (payoutBalance > 0)
606 					holdoverBalance += uint(payoutBalance);// put back any leftovers
607 				payoutBalance = 0;
608 				StatEventI("RunComplete", uint(prOrigPayoutBal) );
609 
610 			} else {
611 				StatEventI("PayRun", paids );
612 			}
613 		}
614 		
615 	}
616 
617 
618 	// ----------------------------
619 	// sender withdraw entire rewards/dividends
620 	// ----------------------------
621 	function withdrawDividends() public returns (uint _amount)
622 	{
623 		if (holderAccounts[msg.sender].balance == 0) { 
624 			//_amount = 0;
625 			StatEvent("0 Balance");
626 			return;
627 		} else {
628 			if ((msg.sender == developers) 
629 				&&  (now < vestTime)) {
630 				//statEvent("Tokens not yet vested.");
631 				//_amount = 0;
632 				return;
633 			}
634 
635 			_amount = holderAccounts[msg.sender].balance; 
636 			holderAccounts[msg.sender].balance = 0; 
637 			if (!msg.sender.call.gas(rwGas).value(_amount)())
638 				throw;
639 			//StatEventI("Paid", _amount);
640 	
641 		}
642 
643 	}
644 
645 	// ----------------------------
646 	// set gas for operations
647 	// ----------------------------
648 	function setOpGas(uint _rm, uint _rf, uint _rw)
649 	{
650 		if (msg.sender != owner && msg.sender != developers) {
651 			//StatEvent("only owner calls");
652 			return;
653 		} else {
654 			rmGas = _rm;
655 			rfGas = _rf;
656 			rwGas = _rw;
657 		}
658 	}
659 
660 	// ----------------------------
661 	// get gas for operations
662 	// ----------------------------
663 	function getOpGas() constant returns (uint _rm, uint _rf, uint _rw)
664 	{
665 		_rm = rmGas;
666 		_rf = rfGas;
667 		_rw = rwGas;
668 	}
669  
670 
671 	// ----------------------------
672 	// check rewards.  pass in address of token holder
673 	// ----------------------------
674 	function checkDividends(address _addr) constant returns(uint _amount)
675 	{
676 		if (holderAccounts[_addr].alloced)
677 			_amount = holderAccounts[_addr].balance;
678 	}		
679 
680 
681 	// ------------------------------------------------
682 	// icoCheckup - check up call for administrators
683 	// after sale is closed if min ico tokens sold, 10 percent will be distributed to 
684 	// company to cover various operating expenses
685 	// after sale and usage dealines have been met, remaining 90 percent will be distributed to
686 	// company.
687 	// ------------------------------------------------
688 	function icoCheckup() public
689 	{
690 		if (msg.sender != owner && msg.sender != developers)
691 			throw;
692 
693 		uint nmsgmask;
694 		//nmsgmask = 0;
695 	
696 		if (icoStatus == IcoStatusValue.saleClosed) {
697 			if ((getNumTokensPurchased() >= minIcoTokenGoal)
698 				&& (remunerationStage == 0 )) {
699 				remunerationStage = 1;
700 				remunerationBalance = (totalTokenFundsReceived/100)*9; // 9 percent
701 				auxPartnerBalance =  (totalTokenFundsReceived/100); // 1 percent
702 				nmsgmask |= 1;
703 			} 
704 		}
705 		if (icoStatus == IcoStatusValue.succeeded) {
706 		
707 			if (remunerationStage == 0 ) {
708 				remunerationStage = 1;
709 				remunerationBalance = (totalTokenFundsReceived/100)*9; 
710 				auxPartnerBalance =  (totalTokenFundsReceived/100);
711 				nmsgmask |= 4;
712 			}
713 			if (remunerationStage == 1) { // we have already suceeded
714 				remunerationStage = 2;
715 				remunerationBalance += totalTokenFundsReceived - (totalTokenFundsReceived/10); // 90 percent
716 				nmsgmask |= 8;
717 			}
718 
719 		}
720 
721 		uint ntmp;
722 
723 		if (remunerationBalance > 0) { 
724 		// only pay one entity per call, dont want to run out of gas
725 				ntmp = remunerationBalance;
726 				remunerationBalance = 0;
727 				if (!founderOrg.call.gas(rmGas).value(ntmp)()) {
728 					remunerationBalance = ntmp;
729 					nmsgmask |= 32;
730 				} else {
731 					nmsgmask |= 64;
732 				}	
733 		} else 	if (auxPartnerBalance > 0) {
734 		// note the "else" only pay one entity per call, dont want to run out of gas
735 			ntmp = auxPartnerBalance;
736 			auxPartnerBalance = 0;
737 			if (!auxPartner.call.gas(rmGas).value(ntmp)()) {
738 				auxPartnerBalance = ntmp;
739 				nmsgmask |= 128;
740 			}  else {
741 				nmsgmask |= 256;
742 			}
743 
744 		} 
745 		
746 		StatEventI("ico-checkup", nmsgmask);
747 	}
748 
749 
750 	// ----------------------------
751 	// swap executor
752 	// ----------------------------
753 	function changeOwner(address _addr) 
754 	{
755 		if (msg.sender != owner
756 			|| settingsState == SettingStateValue.lockedRelease)
757 			 throw;
758 
759 		owner = _addr;
760 	}
761 
762 	// ----------------------------
763 	// swap developers account
764 	// ----------------------------
765 	function changeDevevoperAccont(address _addr) 
766 	{
767 		if (msg.sender != owner
768 			|| settingsState == SettingStateValue.lockedRelease)
769 			 throw;
770 		developers = _addr;
771 	}
772 
773 	// ----------------------------
774 	// change founder
775 	// ----------------------------
776 	function changeFounder(address _addr) 
777 	{
778 		if (msg.sender != owner
779 			|| settingsState == SettingStateValue.lockedRelease)
780 			 throw;
781 		founderOrg = _addr;
782 	}
783 
784 	// ----------------------------
785 	// change auxPartner
786 	// ----------------------------
787 	function changeAuxPartner(address _aux) 
788 	{
789 		if (msg.sender != owner
790 			|| settingsState == SettingStateValue.lockedRelease)
791 			 throw;
792 		auxPartner = _aux;
793 	}
794 
795 
796 	// ----------------------------
797 	// DEBUG ONLY - end this contract, suicide to developers
798 	// ----------------------------
799 	function haraKiri()
800 	{
801 		if (settingsState != SettingStateValue.debug)
802 			throw;
803 		if (msg.sender != owner)
804 			 throw;
805 		suicide(developers);
806 	}
807 
808 	// ----------------------------
809 	// get all ico status, funding and usage info
810 	// ----------------------------
811 	function getIcoInfo() constant returns(IcoStatusValue _status, uint _saleStart, uint _saleEnd, uint _usageEnd, uint _saleGoal, uint _usageGoal, uint _sold, uint _used, uint _funds, uint _credits, uint _remuStage, uint _vest)
812 	{
813 		_status = icoStatus;
814 		_saleStart = fundingStart;
815 		_saleEnd = fundingDeadline;
816 		_usageEnd = usageDeadline;
817 		_vest = vestTime;
818 		_saleGoal = minIcoTokenGoal;
819 		_usageGoal = minUsageGoal;
820 		_sold = getNumTokensPurchased();
821 		_used = getNumGames();
822 		_funds = totalTokenFundsReceived;
823 		_credits = partnerCredits;
824 		_remuStage = remunerationStage;
825 	}
826 
827 	// ----------------------------
828 	// NOTE! CALL AT THE RISK OF RUNNING OUT OF GAS.
829 	// ANYONE CAN CALL THIS FUNCTION BUT YOU HAVE TO SUPPLY 
830 	// THE CORRECT AMOUNT OF GAS WHICH MAY DEPEND ON 
831 	// THE _NUMPAYS PARAMETER.  WHICH MUST BE BETWEEN 1 AND 1000
832 	// THE STANDARD VALUE IS STORED IN "maxPaysPer"
833 	// ----------------------------
834 	function flushDividends(uint _numPays)
835 	{
836 		if ((_numPays == 0) || (_numPays > 1000)) {
837 			StatEvent("Invalid.");
838 		} else if (holdoverBalance > 0 || payoutBalance > 0) {
839 			doPayout(_numPays);
840 		} else {
841 			StatEvent("Nothing to do.");
842 		}
843 				
844 	}
845 
846 	function doDeveloperGrant() internal
847 	{
848 		if (!developersGranted) {
849 			developersGranted = true;
850 			numDevTokens = (totalTokensMinted * 15)/100;
851 			totalTokensMinted += numDevTokens;
852 			if (!holderAccounts[developers].alloced) 
853 				addAccount(developers);
854 			uint newHeld = getHeld(holderAccounts[developers].tokens) + numDevTokens;
855 			holderAccounts[developers].tokens = newHeld |  (curPayoutId * (2 ** 48));
856 
857 		}
858 	}
859 
860 
861 }