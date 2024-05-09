1 // VERSION J
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
175 		e4_partner = address(0); // must be reset again
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
330 	// -------------------------------------------
331 	// check the alloced
332 	// -------------------------------------------
333 	function holderExists(address _addr) returns(bool _exist)
334 	{
335 		_exist = holderAccounts[_addr].alloced;
336 	}
337 
338 
339 
340 	// -------------------------------------------
341 	// default payable function.
342 	// if sender is e4row  partner, this is a rake fee payment
343 	// otherwise this is a token purchase.
344 	// tokens only purchaseable between tokenfundingstart and end
345 	// -------------------------------------------
346 	function () payable {
347 		if (msg.sender == e4_partner) {
348 		     feePayment(); // from e4row game escrow contract
349 		} else {
350 		     purchaseToken();
351 		}
352 	}
353 
354 	// -----------------------------
355 	// purchase token function - tokens only sold during sale period up until the max tokens
356 	// purchase price is tokenPrice.  all units in wei.
357 	// purchaser will not be included in current pay run
358 	// -----------------------------
359 	function purchaseToken() payable {
360 
361 		uint nvalue = msg.value; // being careful to preserve msg.value
362 		address npurchaser = msg.sender;
363 		if (nvalue < tokenPrice) 
364 			throw;
365 
366 		uint qty = nvalue/tokenPrice;
367 		updateIcoStatus();
368 		if (icoStatus != IcoStatusValue.saleOpen) // purchase is closed
369 			throw;
370 		if (totalTokensMinted + qty > maxMintableTokens)
371 			throw;
372 		if (!holderAccounts[npurchaser].alloced)
373 			addAccount(npurchaser);
374 		
375 		// purchaser waits for next payrun. otherwise can disrupt cur pay run
376 		uint newHeld = qty + getHeld(holderAccounts[npurchaser].tokens);
377 		holderAccounts[npurchaser].tokens = newHeld | (curPayoutId * (2 ** 48));
378 
379 		totalTokensMinted += qty;
380 		totalTokenFundsReceived += nvalue;
381 
382 		if (totalTokensMinted == maxMintableTokens) {
383 			icoStatus = IcoStatusValue.saleClosed;
384 			//test unnecessary -  if (getNumTokensPurchased() >= minIcoTokenGoal)
385 			doDeveloperGrant();
386 			StatEventI("Purchased,Granted", qty);
387 		} else
388 			StatEventI("Purchased", qty);
389 
390 	}
391 
392 
393 	// ---------------------------
394 	// accept payment from e4row contract
395 	// ---------------------------
396 	function feePayment() payable  
397 	{
398 		if (msg.sender != e4_partner) {
399 			StatEvent("forbidden");
400 			return; // thank you
401 		}
402 		uint nfvalue = msg.value; // preserve value in case changed in dev grant
403 
404 		updateIcoStatus();
405 
406 		holdoverBalance += nfvalue;
407 		partnerCredits += nfvalue;
408 		StatEventI("Payment", nfvalue);
409 
410 		if (holdoverBalance > payoutThreshold
411 			|| payoutBalance > 0)
412 			doPayout(maxPaysPer);
413 		
414 	
415 	}
416 
417 	// ---------------------------
418 	// set the e4row partner, this is only done once
419 	// ---------------------------
420 	function setE4RowPartner(address _addr) public	
421 	{
422 	// ONLY owner can set and ONLY ONCE! (unless "unlocked" debug)
423 	// once its locked. ONLY ONCE!
424 		if (msg.sender == owner) {
425 			if ((e4_partner == address(0)) || (settingsState == SettingStateValue.debug)) {
426 				e4_partner = _addr;
427 				partnerCredits = 0;
428 				//StatEventI("E4-Set", 0);
429 			} else {
430 				StatEvent("Already Set");
431 			}
432 		}
433 	}
434 
435 	// ----------------------------
436 	// return the total tokens purchased
437 	// ----------------------------
438 	function getNumTokensPurchased() constant returns(uint _purchased)
439 	{
440 		_purchased = totalTokensMinted-numDevTokens;
441 	}
442 
443 	// ----------------------------
444 	// return the num games as reported from the e4row  contract
445 	// ----------------------------
446 	function getNumGames() constant returns(uint _games)
447 	{
448 		//_games = 0;
449 		if (e4_partner != address(0)) {
450 			iE4RowEscrow pe4 = iE4RowEscrow(e4_partner);
451 			_games = uint(pe4.getNumGamesStarted());
452 		} 
453 		//else
454 		//StatEvent("Empty E4");
455 	}
456 
457 	// ------------------------------------------------
458 	// get the founders, auxPartner, developer
459 	// --------------------------------------------------
460 	function getSpecialAddresses() constant returns (address _fndr, address _aux, address _dev, address _e4)
461 	{
462 		//if (_sender == owner) { // no msg.sender on constant functions at least in mew
463 			_fndr = founderOrg;
464 			_aux = auxPartner;
465 			_dev = developers;
466 			_e4  = e4_partner;
467 		//}
468 	}
469 
470 
471 
472 	// ----------------------------
473 	// update the ico status
474 	// ----------------------------
475 	function updateIcoStatus() public
476 	{
477 		if (icoStatus == IcoStatusValue.succeeded 
478 			|| icoStatus == IcoStatusValue.failed)
479 			return;
480 		else if (icoStatus == IcoStatusValue.anouncement) {
481 			if (now > fundingStart && now <= fundingDeadline) {
482 				icoStatus = IcoStatusValue.saleOpen;
483 				
484 			} else if (now > fundingDeadline) {
485 				// should not be here - this will eventually fail
486 				icoStatus = IcoStatusValue.saleClosed;
487 			}
488 		} else {
489 			uint numP = getNumTokensPurchased();
490 			uint numG = getNumGames();
491 			if ((now > fundingDeadline && numP < minIcoTokenGoal)
492 				|| (now > usageDeadline && numG < minUsageGoal)) {
493 				icoStatus = IcoStatusValue.failed;
494 			} else if ((now > fundingDeadline) // dont want to prevent more token sales
495 				&& (numP >= minIcoTokenGoal)
496 				&& (numG >= minUsageGoal)) {
497 				icoStatus = IcoStatusValue.succeeded; // hooray
498 			}
499 			if (icoStatus == IcoStatusValue.saleOpen
500 				&& ((numP >= maxMintableTokens)
501 				|| (now > fundingDeadline))) {
502 					icoStatus = IcoStatusValue.saleClosed;
503 				}
504 		}
505 
506 		if (!developersGranted
507 			&& icoStatus != IcoStatusValue.saleOpen 
508 			&& icoStatus != IcoStatusValue.anouncement
509 			&& getNumTokensPurchased() >= minIcoTokenGoal) {
510 				doDeveloperGrant(); // grant whenever status goes from open to anything...
511 		}
512 
513 	
514 	}
515 
516 	
517 	// ----------------------------
518 	// request refund. Caller must call to request and receive refund 
519 	// WARNING - withdraw rewards/dividends before calling.
520 	// YOU HAVE BEEN WARNED
521 	// ----------------------------
522 	function requestRefund()
523 	{
524 		address nrequester = msg.sender;
525 		updateIcoStatus();
526 
527 		uint ntokens = getHeld(holderAccounts[nrequester].tokens);
528 		if (icoStatus != IcoStatusValue.failed)
529 			StatEvent("No Refund");
530 		else if (ntokens == 0)
531 			StatEvent("No Tokens");
532 		else {
533 			uint nrefund = ntokens * tokenPrice;
534 			if (getNumTokensPurchased() >= minIcoTokenGoal)
535 				nrefund -= (nrefund /10); // only 90 percent b/c 10 percent payout
536 
537 			holderAccounts[developers].tokens += ntokens;
538 			holderAccounts[nrequester].tokens = 0;
539 			if (holderAccounts[nrequester].balance > 0) {
540 				// see above warning!!
541 				if (!holderAccounts[developers].alloced) 
542 					addAccount(developers);
543 				holderAccounts[developers].balance += holderAccounts[nrequester].balance;
544 				holderAccounts[nrequester].balance = 0;
545 			}
546 
547 			if (!nrequester.call.gas(rfGas).value(nrefund)())
548 				throw;
549 			//StatEventI("Refunded", nrefund);
550 		}
551 	}
552 
553 
554 
555 	// ---------------------------------------------------
556 	// payout rewards to all token holders
557 	// use a second holding variable called PayoutBalance to do 
558 	// the actual payout from b/c too much gas to iterate thru 
559 	// each payee. Only start a new run at most once per "minpayinterval".
560 	// Its done in runs of "_numPays"
561 	// we use special coding for the holderAccounts to avoid a hack
562 	// of getting paid at the top of the list then transfering tokens
563 	// to another address at the bottom of the list.
564 	// because of that each holderAccounts entry gets the payoutid stamped upon it (top two bytes)
565 	// also a token transfer will transfer the payout id.
566 	// ---------------------------------------------------
567 	function doPayout(uint _numPays)  internal
568 	{
569 		if (totalTokensMinted == 0)
570 			return;
571 
572 		if ((holdoverBalance > 0) 
573 			&& (payoutBalance == 0)
574 			&& (now > (lastPayoutTime+minPayInterval))) {
575 			// start a new run
576 			curPayoutId++;
577 			if (curPayoutId >= 32768)
578 				curPayoutId = 1;
579 			lastPayoutTime = now;
580 			payoutBalance = int(holdoverBalance);
581 			prOrigPayoutBal = payoutBalance;
582 			prOrigTokensMint = totalTokensMinted;
583 			holdoverBalance = 0;
584 			lastPayoutIndex = 0;
585 			StatEventI("StartRun", uint(curPayoutId));
586 		} else if (payoutBalance > 0) {
587 			// work down the p.o.b
588 			uint nAmount;
589 			uint nPerTokDistrib = uint(prOrigPayoutBal)/prOrigTokensMint;
590 			uint paids = 0;
591 			uint i; // intentional
592 			for (i = lastPayoutIndex; (paids < _numPays) && (i < numAccounts) && (payoutBalance > 0); i++ ) {
593 				address a = holderIndexes[i];
594 				if (a == address(0)) {
595 					continue;
596 				}
597 				var (pid, held) = getPayIdAndHeld(holderAccounts[a].tokens);
598 				if ((held > 0) && (pid != curPayoutId)) {
599 					nAmount = nPerTokDistrib * held;
600 					if (int(nAmount) <= payoutBalance){
601 						holderAccounts[a].balance += nAmount; 
602 						holderAccounts[a].tokens = (curPayoutId * (2 ** 48)) | held;
603 						payoutBalance -= int(nAmount);					
604 						paids++;
605 					}
606 				}
607 			}
608 			lastPayoutIndex = i;
609 			if (lastPayoutIndex >= numAccounts || payoutBalance <= 0) {
610 				lastPayoutIndex = 0;
611 				if (payoutBalance > 0)
612 					holdoverBalance += uint(payoutBalance);// put back any leftovers
613 				payoutBalance = 0;
614 				StatEventI("RunComplete", uint(prOrigPayoutBal) );
615 
616 			} else {
617 				StatEventI("PayRun", paids );
618 			}
619 		}
620 		
621 	}
622 
623 
624 	// ----------------------------
625 	// sender withdraw entire rewards/dividends
626 	// ----------------------------
627 	function withdrawDividends() public returns (uint _amount)
628 	{
629 		if (holderAccounts[msg.sender].balance == 0) { 
630 			//_amount = 0;
631 			StatEvent("0 Balance");
632 			return;
633 		} else {
634 			if ((msg.sender == developers) 
635 				&&  (now < vestTime)) {
636 				//statEvent("Tokens not yet vested.");
637 				//_amount = 0;
638 				return;
639 			}
640 
641 			_amount = holderAccounts[msg.sender].balance; 
642 			holderAccounts[msg.sender].balance = 0; 
643 			if (!msg.sender.call.gas(rwGas).value(_amount)())
644 				throw;
645 			//StatEventI("Paid", _amount);
646 	
647 		}
648 
649 	}
650 
651 	// ----------------------------
652 	// set gas for operations
653 	// ----------------------------
654 	function setOpGas(uint _rm, uint _rf, uint _rw)
655 	{
656 		if (msg.sender != owner && msg.sender != developers) {
657 			//StatEvent("only owner calls");
658 			return;
659 		} else {
660 			rmGas = _rm;
661 			rfGas = _rf;
662 			rwGas = _rw;
663 		}
664 	}
665 
666 	// ----------------------------
667 	// get gas for operations
668 	// ----------------------------
669 	function getOpGas() constant returns (uint _rm, uint _rf, uint _rw)
670 	{
671 		_rm = rmGas;
672 		_rf = rfGas;
673 		_rw = rwGas;
674 	}
675  
676 
677 	// ----------------------------
678 	// check rewards.  pass in address of token holder
679 	// ----------------------------
680 	function checkDividends(address _addr) constant returns(uint _amount)
681 	{
682 		if (holderAccounts[_addr].alloced)
683 			_amount = holderAccounts[_addr].balance;
684 	}		
685 
686 
687 	// ------------------------------------------------
688 	// icoCheckup - check up call for administrators
689 	// after sale is closed if min ico tokens sold, 10 percent will be distributed to 
690 	// company to cover various operating expenses
691 	// after sale and usage dealines have been met, remaining 90 percent will be distributed to
692 	// company.
693 	// ------------------------------------------------
694 	function icoCheckup() public
695 	{
696 		if (msg.sender != owner && msg.sender != developers)
697 			throw;
698 
699 		uint nmsgmask;
700 		//nmsgmask = 0;
701 	
702 		if (icoStatus == IcoStatusValue.saleClosed) {
703 			if ((getNumTokensPurchased() >= minIcoTokenGoal)
704 				&& (remunerationStage == 0 )) {
705 				remunerationStage = 1;
706 				remunerationBalance = (totalTokenFundsReceived/100)*9; // 9 percent
707 				auxPartnerBalance =  (totalTokenFundsReceived/100); // 1 percent
708 				nmsgmask |= 1;
709 			} 
710 		}
711 		if (icoStatus == IcoStatusValue.succeeded) {
712 		
713 			if (remunerationStage == 0 ) {
714 				remunerationStage = 1;
715 				remunerationBalance = (totalTokenFundsReceived/100)*9; 
716 				auxPartnerBalance =  (totalTokenFundsReceived/100);
717 				nmsgmask |= 4;
718 			}
719 			if (remunerationStage == 1) { // we have already suceeded
720 				remunerationStage = 2;
721 				remunerationBalance += totalTokenFundsReceived - (totalTokenFundsReceived/10); // 90 percent
722 				nmsgmask |= 8;
723 			}
724 
725 		}
726 
727 		uint ntmp;
728 
729 		if (remunerationBalance > 0) { 
730 		// only pay one entity per call, dont want to run out of gas
731 				ntmp = remunerationBalance;
732 				remunerationBalance = 0;
733 				if (!founderOrg.call.gas(rmGas).value(ntmp)()) {
734 					remunerationBalance = ntmp;
735 					nmsgmask |= 32;
736 				} else {
737 					nmsgmask |= 64;
738 				}	
739 		} else 	if (auxPartnerBalance > 0) {
740 		// note the "else" only pay one entity per call, dont want to run out of gas
741 			ntmp = auxPartnerBalance;
742 			auxPartnerBalance = 0;
743 			if (!auxPartner.call.gas(rmGas).value(ntmp)()) {
744 				auxPartnerBalance = ntmp;
745 				nmsgmask |= 128;
746 			}  else {
747 				nmsgmask |= 256;
748 			}
749 
750 		} 
751 		
752 		StatEventI("ico-checkup", nmsgmask);
753 	}
754 
755 
756 	// ----------------------------
757 	// swap executor
758 	// ----------------------------
759 	function changeOwner(address _addr) 
760 	{
761 		if (msg.sender != owner
762 			|| settingsState == SettingStateValue.lockedRelease)
763 			 throw;
764 
765 		owner = _addr;
766 	}
767 
768 	// ----------------------------
769 	// swap developers account
770 	// ----------------------------
771 	function changeDevevoperAccont(address _addr) 
772 	{
773 		if (msg.sender != owner
774 			|| settingsState == SettingStateValue.lockedRelease)
775 			 throw;
776 		developers = _addr;
777 	}
778 
779 	// ----------------------------
780 	// change founder
781 	// ----------------------------
782 	function changeFounder(address _addr) 
783 	{
784 		if (msg.sender != owner
785 			|| settingsState == SettingStateValue.lockedRelease)
786 			 throw;
787 		founderOrg = _addr;
788 	}
789 
790 	// ----------------------------
791 	// change auxPartner
792 	// ----------------------------
793 	function changeAuxPartner(address _aux) 
794 	{
795 		if (msg.sender != owner
796 			|| settingsState == SettingStateValue.lockedRelease)
797 			 throw;
798 		auxPartner = _aux;
799 	}
800 
801 
802 	// ----------------------------
803 	// DEBUG ONLY - end this contract, suicide to developers
804 	// ----------------------------
805 	function haraKiri()
806 	{
807 		if (settingsState != SettingStateValue.debug)
808 			throw;
809 		if (msg.sender != owner)
810 			 throw;
811 		suicide(developers);
812 	}
813 
814 	// ----------------------------
815 	// get all ico status, funding and usage info
816 	// ----------------------------
817 	function getIcoInfo() constant returns(IcoStatusValue _status, uint _saleStart, uint _saleEnd, uint _usageEnd, uint _saleGoal, uint _usageGoal, uint _sold, uint _used, uint _funds, uint _credits, uint _remuStage, uint _vest)
818 	{
819 		_status = icoStatus;
820 		_saleStart = fundingStart;
821 		_saleEnd = fundingDeadline;
822 		_usageEnd = usageDeadline;
823 		_vest = vestTime;
824 		_saleGoal = minIcoTokenGoal;
825 		_usageGoal = minUsageGoal;
826 		_sold = getNumTokensPurchased();
827 		_used = getNumGames();
828 		_funds = totalTokenFundsReceived;
829 		_credits = partnerCredits;
830 		_remuStage = remunerationStage;
831 	}
832 
833 	// ----------------------------
834 	// NOTE! CALL AT THE RISK OF RUNNING OUT OF GAS.
835 	// ANYONE CAN CALL THIS FUNCTION BUT YOU HAVE TO SUPPLY 
836 	// THE CORRECT AMOUNT OF GAS WHICH MAY DEPEND ON 
837 	// THE _NUMPAYS PARAMETER.  WHICH MUST BE BETWEEN 1 AND 1000
838 	// THE STANDARD VALUE IS STORED IN "maxPaysPer"
839 	// ----------------------------
840 	function flushDividends(uint _numPays)
841 	{
842 		if ((_numPays == 0) || (_numPays > 1000)) {
843 			StatEvent("Invalid.");
844 		} else if (holdoverBalance > 0 || payoutBalance > 0) {
845 			doPayout(_numPays);
846 		} else {
847 			StatEvent("Nothing to do.");
848 		}
849 				
850 	}
851 
852 	function doDeveloperGrant() internal
853 	{
854 		if (!developersGranted) {
855 			developersGranted = true;
856 			numDevTokens = totalTokensMinted/10;
857 			totalTokensMinted += numDevTokens;
858 			if (!holderAccounts[developers].alloced) 
859 				addAccount(developers);
860 			uint newHeld = getHeld(holderAccounts[developers].tokens) + numDevTokens;
861 			holderAccounts[developers].tokens = newHeld |  (curPayoutId * (2 ** 48));
862 
863 		}
864 	}
865 
866 
867 }