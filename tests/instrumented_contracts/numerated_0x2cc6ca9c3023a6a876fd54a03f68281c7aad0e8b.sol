1 pragma solidity ^0.4.13;
2 
3 contract ComplianceService {
4 	function validate(address _from, address _to, uint256 _amount) public returns (bool allowed) {
5 		return true;
6 	}
7 }
8 
9 contract ERC20 {
10 	function balanceOf(address _owner) public constant returns (uint256 balance);
11 	function transfer(address _to, uint256 _amount) public returns (bool success);
12 	function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
13 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
14 	function totalSupply() public constant returns (uint);
15 }
16 
17 contract HardcodedWallets {
18 	// **** DATA
19 
20 	address public walletFounder1; // founder #1 wallet, CEO, compulsory
21 	address public walletFounder2; // founder #2 wallet
22 	address public walletFounder3; // founder #3 wallet
23 	address public walletCommunityReserve;	// Distribution wallet
24 	address public walletCompanyReserve;	// Distribution wallet
25 	address public walletTeamAdvisors;		// Distribution wallet
26 	address public walletBountyProgram;		// Distribution wallet
27 
28 
29 	// **** FUNCTIONS
30 
31 	/**
32 	 * @notice Constructor, set up the compliance officer oracle wallet
33 	 */
34 	constructor() public {
35 		// set up the founders' oracle wallets
36 		walletFounder1             = 0x5E69332F57Ac45F5fCA43B6b007E8A7b138c2938; // founder #1 (CEO) wallet
37 		walletFounder2             = 0x852f9a94a29d68CB95Bf39065BED6121ABf87607; // founder #2 wallet
38 		walletFounder3             = 0x0a339965e52dF2c6253989F5E9173f1F11842D83; // founder #3 wallet
39 
40 		// set up the wallets for distribution of the total supply of tokens
41 		walletCommunityReserve = 0xB79116a062939534042d932fe5DF035E68576547;
42 		walletCompanyReserve = 0xA6845689FE819f2f73a6b9C6B0D30aD6b4a006d8;
43 		walletTeamAdvisors = 0x0227038b2560dF1abf3F8C906016Af0040bc894a;
44 		walletBountyProgram = 0xdd401Df9a049F6788cA78b944c64D21760757D73;
45 
46 	}
47 }
48 
49 library SafeMath {
50 
51 	/**
52     * @dev Multiplies two numbers, throws on overflow.
53     */
54 	function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55 		if (a == 0) {
56 			return 0;
57 		}
58 		c = a * b;
59 		assert(c / a == b);
60 		return c;
61 	}
62 
63 	/**
64     * @dev Integer division of two numbers, truncating the quotient.
65     */
66 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
67 		// assert(b > 0); // Solidity automatically throws when dividing by 0
68 		// uint256 c = a / b;
69 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
70 		return a / b;
71 	}
72 
73 	/**
74     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75     */
76 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77 		assert(b <= a);
78 		return a - b;
79 	}
80 
81 	/**
82     * @dev Adds two numbers, throws on overflow.
83     */
84 	function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85 		c = a + b;
86 		assert(c >= a);
87 		return c;
88 	}
89 }
90 
91 contract System {
92 	using SafeMath for uint256;
93 	
94 	address owner;
95 	
96 	// **** MODIFIERS
97 
98 	// @notice To limit functions usage to contract owner
99 	modifier onlyOwner() {
100 		if (msg.sender != owner) {
101 			error('System: onlyOwner function called by user that is not owner');
102 		} else {
103 			_;
104 		}
105 	}
106 
107 	// **** FUNCTIONS
108 	
109 	// @notice Calls whenever an error occurs, logs it or reverts transaction
110 	function error(string _error) internal {
111 		revert(_error);
112 		// in case revert with error msg is not yet fully supported
113 		//	emit Error(_error);
114 		// throw;
115 	}
116 
117 	// @notice For debugging purposes when using solidity online browser, remix and sandboxes
118 	function whoAmI() public constant returns (address) {
119 		return msg.sender;
120 	}
121 	
122 	// @notice Get the current timestamp from last mined block
123 	function timestamp() public constant returns (uint256) {
124 		return block.timestamp;
125 	}
126 	
127 	// @notice Get the balance in weis of this contract
128 	function contractBalance() public constant returns (uint256) {
129 		return address(this).balance;
130 	}
131 	
132 	// @notice System constructor, defines owner
133 	constructor() public {
134 		// This is the constructor, so owner should be equal to msg.sender, and this method should be called just once
135 		owner = msg.sender;
136 		
137 		// make sure owner address is configured
138 		if(owner == 0x0) error('System constructor: Owner address is 0x0'); // Never should happen, but just in case...
139 	}
140 	
141 	// **** EVENTS
142 
143 	// @notice A generic error log
144 	event Error(string _error);
145 
146 	// @notice For debug purposes
147 	event DebugUint256(uint256 _data);
148 
149 }
150 
151 contract Escrow is System, HardcodedWallets {
152 	using SafeMath for uint256;
153 
154 	// **** DATA
155 	mapping (address => uint256) public deposited;
156 	uint256 nextStage;
157 
158 	// Circular reference to ICO contract
159 	address public addressSCICO;
160 
161 	// Circular reference to Tokens contract
162 	address public addressSCTokens;
163 	Tokens public SCTokens;
164 
165 
166 	// **** FUNCTIONS
167 
168 	/**
169 	 * @notice Constructor, set up the state
170 	 */
171 	constructor() public {
172 		// copy totalSupply from Tokens to save gas
173 		uint256 totalSupply = 1350000000 ether;
174 
175 
176 		deposited[this] = totalSupply.mul(50).div(100);
177 		deposited[walletCommunityReserve] = totalSupply.mul(20).div(100);
178 		deposited[walletCompanyReserve] = totalSupply.mul(14).div(100);
179 		deposited[walletTeamAdvisors] = totalSupply.mul(15).div(100);
180 		deposited[walletBountyProgram] = totalSupply.mul(1).div(100);
181 	}
182 
183 	function deposit(uint256 _amount) public returns (bool) {
184 		// only ICO could deposit
185 		if (msg.sender != addressSCICO) {
186 			error('Escrow: not allowed to deposit');
187 			return false;
188 		}
189 		deposited[this] = deposited[this].add(_amount);
190 		return true;
191 	}
192 
193 	/**
194 	 * @notice Withdraw funds from the tokens contract
195 	 */
196 	function withdraw(address _address, uint256 _amount) public onlyOwner returns (bool) {
197 		if (deposited[_address]<_amount) {
198 			error('Escrow: not enough balance');
199 			return false;
200 		}
201 		deposited[_address] = deposited[_address].sub(_amount);
202 		return SCTokens.transfer(_address, _amount);
203 	}
204 
205 	/**
206 	 * @notice Withdraw funds from the tokens contract
207 	 */
208 	function fundICO(uint256 _amount, uint8 _stage) public returns (bool) {
209 		if(nextStage !=_stage) {
210 			error('Escrow: ICO stage already funded');
211 			return false;
212 		}
213 
214 		if (msg.sender != addressSCICO || tx.origin != owner) {
215 			error('Escrow: not allowed to fund the ICO');
216 			return false;
217 		}
218 		if (deposited[this]<_amount) {
219 			error('Escrow: not enough balance');
220 			return false;
221 		}
222 		bool success = SCTokens.transfer(addressSCICO, _amount);
223 		if(success) {
224 			deposited[this] = deposited[this].sub(_amount);
225 			nextStage++;
226 			emit FundICO(addressSCICO, _amount);
227 		}
228 		return success;
229 	}
230 
231 	/**
232  	* @notice The owner can specify which ICO contract is allowed to transfer tokens while timelock is on
233  	*/
234 	function setMyICOContract(address _SCICO) public onlyOwner {
235 		addressSCICO = _SCICO;
236 	}
237 
238 	/**
239  	* @notice Set the tokens contract
240  	*/
241 	function setTokensContract(address _addressSCTokens) public onlyOwner {
242 		addressSCTokens = _addressSCTokens;
243 		SCTokens = Tokens(_addressSCTokens);
244 	}
245 
246 	/**
247 	 * @notice Returns balance of given address
248 	 */
249 	function balanceOf(address _address) public constant returns (uint256 balance) {
250 		return deposited[_address];
251 	}
252 
253 
254 	// **** EVENTS
255 
256 	// Triggered when an investor buys some tokens directly with Ethers
257 	event FundICO(address indexed _addressICO, uint256 _amount);
258 
259 
260 }
261 
262 contract RefundVault is HardcodedWallets, System {
263 	using SafeMath for uint256;
264 
265 	enum State { Active, Refunding, Closed }
266 
267 
268 	// **** DATA
269 
270 	mapping (address => uint256) public deposited;
271 	mapping (address => uint256) public tokensAcquired;
272 	State public state;
273 
274 	// Circular reference to ICO contract
275 	address public addressSCICO;
276 	
277 	
278 
279 	// **** MODIFIERS
280 
281 	// @notice To limit functions usage to contract owner
282 	modifier onlyICOContract() {
283 		if (msg.sender != addressSCICO) {
284 			error('RefundVault: onlyICOContract function called by user that is not ICOContract');
285 		} else {
286 			_;
287 		}
288 	}
289 
290 
291 	// **** FUNCTIONS
292 
293 	/**
294 	 * @notice Constructor, set up the state
295 	 */
296 	constructor() public {
297 		state = State.Active;
298 	}
299 
300 	function weisDeposited(address _investor) public constant returns (uint256) {
301 		return deposited[_investor];
302 	}
303 
304 	function getTokensAcquired(address _investor) public constant returns (uint256) {
305 		return tokensAcquired[_investor];
306 	}
307 
308 	/**
309 	 * @notice Registers how many tokens have each investor and how many ethers they spent (When ICOing through PayIn this function is not called)
310 	 */
311 	function deposit(address _investor, uint256 _tokenAmount) onlyICOContract public payable returns (bool) {
312 		if (state != State.Active) {
313 			error('deposit: state != State.Active');
314 			return false;
315 		}
316 		deposited[_investor] = deposited[_investor].add(msg.value);
317 		tokensAcquired[_investor] = tokensAcquired[_investor].add(_tokenAmount);
318 
319 		return true;
320 	}
321 
322 	/**
323 	 * @notice When ICO finalizes funds are transferred to founders' wallets
324 	 */
325 	function close() onlyICOContract public returns (bool) {
326 		if (state != State.Active) {
327 			error('close: state != State.Active');
328 			return false;
329 		}
330 		state = State.Closed;
331 
332 		walletFounder1.transfer(address(this).balance.mul(33).div(100)); // Forwards 33% to 1st founder wallet
333 		walletFounder2.transfer(address(this).balance.mul(50).div(100)); // Forwards 33% to 2nd founder wallet
334 		walletFounder3.transfer(address(this).balance);                  // Forwards 34% to 3rd founder wallet
335 
336 		emit Closed(); // Event log
337 
338 		return true;
339 	}
340 
341 	/**
342 	 * @notice When ICO finalizes owner toggles refunding
343 	 */
344 	function enableRefunds() onlyICOContract public returns (bool) {
345 		if (state != State.Active) {
346 			error('enableRefunds: state != State.Active');
347 			return false;
348 		}
349 		state = State.Refunding;
350 
351 		emit RefundsEnabled(); // Event log
352 
353 		return true;
354 	}
355 
356 	/**
357 	 * @notice ICO Smart Contract can call this function for the investor to refund
358 	 */
359 	function refund(address _investor) onlyICOContract public returns (bool) {
360 		if (state != State.Refunding) {
361 			error('refund: state != State.Refunding');
362 			return false;
363 		}
364 		if (deposited[_investor] == 0) {
365 			error('refund: no deposit to refund');
366 			return false;
367 		}
368 		uint256 depositedValue = deposited[_investor];
369 		deposited[_investor] = 0;
370 		tokensAcquired[_investor] = 0; // tokens should have been returned previously to the ICO
371 		_investor.transfer(depositedValue);
372 
373 		emit Refunded(_investor, depositedValue); // Event log
374 
375 		return true;
376 	}
377 
378 	/**
379 	 * @notice To allow ICO contracts to check whether RefundVault is ready to refund investors
380 	 */
381 	function isRefunding() public constant returns (bool) {
382 		return (state == State.Refunding);
383 	}
384 
385 	/**
386 	 * @notice The owner must specify which ICO contract is allowed call for refunds
387 	 */
388 	function setMyICOContract(address _SCICO) public onlyOwner {
389 		require(address(this).balance == 0);
390 		addressSCICO = _SCICO;
391 	}
392 
393 
394 
395 	// **** EVENTS
396 
397 	// Triggered when ICO contract closes the vault and forwards funds to the founders' wallets
398 	event Closed();
399 
400 	// Triggered when ICO contract initiates refunding
401 	event RefundsEnabled();
402 
403 	// Triggered when an investor claims (through ICO contract) and gets its funds
404 	event Refunded(address indexed beneficiary, uint256 weiAmount);
405 }
406 
407 contract Haltable is System {
408 	bool public halted;
409 	
410 	// **** MODIFIERS
411 
412 	modifier stopInEmergency {
413 		if (halted) {
414 			error('Haltable: stopInEmergency function called and contract is halted');
415 		} else {
416 			_;
417 		}
418 	}
419 
420 	modifier onlyInEmergency {
421 		if (!halted) {
422 			error('Haltable: onlyInEmergency function called and contract is not halted');
423 		} {
424 			_;
425 		}
426 	}
427 
428 	// **** FUNCTIONS
429 	
430 	// called by the owner on emergency, triggers stopped state
431 	function halt() external onlyOwner {
432 		halted = true;
433 		emit Halt(true, msg.sender, timestamp()); // Event log
434 	}
435 
436 	// called by the owner on end of emergency, returns to normal state
437 	function unhalt() external onlyOwner onlyInEmergency {
438 		halted = false;
439 		emit Halt(false, msg.sender, timestamp()); // Event log
440 	}
441 	
442 	// **** EVENTS
443 	// @notice Triggered when owner halts contract
444 	event Halt(bool _switch, address _halter, uint256 _timestamp);
445 }
446 
447 contract ICO is HardcodedWallets, Haltable {
448 	// **** DATA
449 
450 	// Linked Contracts
451 	Tokens public SCTokens;	// The token being sold
452 	RefundVault public SCRefundVault;	// The vault for softCap refund
453 	Whitelist public SCWhitelist;	// The whitelist of allowed wallets to buy tokens on ICO
454 	Escrow public SCEscrow; // Escrow service
455 
456 	// start and end timestamps where investments are allowed (both inclusive)
457 	uint256 public startTime;
458 	uint256 public endTime;
459 	bool public isFinalized = false;
460 
461 	uint256 public weisPerBigToken; // how many weis a buyer pays to get a big token (10^18 tokens)
462 	uint256 public weisPerEther;
463 	uint256 public tokensPerEther; // amount of tokens with multiplier received on ICO when paying with 1 Ether, discounts included
464 	uint256 public bigTokensPerEther; // amount of tokens w/omultiplier received on ICO when paying with 1 Ether, discounts included
465 
466 	uint256 public weisRaised; // amount of Weis raised
467 	uint256 public etherHardCap; // Max amount of Ethers to raise
468 	uint256 public tokensHardCap; // Max amount of Tokens for sale
469 	uint256 public weisHardCap; // Max amount of Weis raised
470 	uint256 public weisMinInvestment; // Min amount of Weis to perform a token sale
471 	uint256 public etherSoftCap; // Min amount of Ethers for sale to ICO become successful
472 	uint256 public tokensSoftCap; // Min amount of Tokens for sale to ICO become successful
473 	uint256 public weisSoftCap; // Min amount of Weis raised to ICO become successful
474 
475 	uint256 public discount; // Applies to token price when investor buys tokens. It is a number between 0-100
476 	uint256 discountedPricePercentage;
477 	uint8 ICOStage;
478 
479 
480 
481 	// **** MODIFIERS
482 
483 	
484 	// **** FUNCTIONS
485 
486 	// fallback function can be used to buy tokens
487 	function () payable public {
488 		buyTokens();
489 	}
490 	
491 
492 	/**
493 	 * @notice Token purchase function direclty through ICO Smart Contract. Beneficiary = msg.sender
494 	 */
495 	function buyTokens() public stopInEmergency payable returns (bool) {
496 		if (msg.value == 0) {
497 			error('buyTokens: ZeroPurchase');
498 			return false;
499 		}
500 
501 		uint256 tokenAmount = buyTokensLowLevel(msg.sender, msg.value);
502 
503 		// Send the investor's ethers to the vault
504 		if (!SCRefundVault.deposit.value(msg.value)(msg.sender, tokenAmount)) {
505 			revert('buyTokens: unable to transfer collected funds from ICO contract to Refund Vault'); // Revert needed to refund investor on error
506 			// error('buyTokens: unable to transfer collected funds from ICO contract to Refund Vault');
507 			// return false;
508 		}
509 
510 		emit BuyTokens(msg.sender, msg.value, tokenAmount); // Event log
511 
512 		return true;
513 	}
514 
515 	/**
516 	 * @notice Token purchase function through Oracle PayIn by MarketPay.io API
517 	 */
518 	/* // Deactivated to save ICO contract deployment gas cost
519 	function buyTokensOraclePayIn(address _beneficiary, uint256 _weisAmount) public onlyCustodyFiat stopInEmergency returns (bool) {
520 		uint256 tokenAmount = buyTokensLowLevel(_beneficiary, _weisAmount);
521 
522 		emit BuyTokensOraclePayIn(msg.sender, _beneficiary, _weisAmount, tokenAmount); // Event log
523 
524 		return true;
525 	}*/
526 
527 	/**
528 	 * @notice Low level token purchase function, w/o ether transfer from investor
529 	 */
530 	function buyTokensLowLevel(address _beneficiary, uint256 _weisAmount) private stopInEmergency returns (uint256 tokenAmount) {
531 		if (_beneficiary == 0x0) {
532 			revert('buyTokensLowLevel: _beneficiary == 0x0'); // Revert needed to refund investor on error
533 			// error('buyTokensLowLevel: _beneficiary == 0x0');
534 			// return 0;
535 		}
536 		if (timestamp() < startTime || timestamp() > endTime) {
537 			revert('buyTokensLowLevel: Not withinPeriod'); // Revert needed to refund investor on error
538 			// error('buyTokensLowLevel: Not withinPeriod');
539 			// return 0;
540 		}
541 		if (!SCWhitelist.isInvestor(_beneficiary)) {
542 			revert('buyTokensLowLevel: Investor is not registered on the whitelist'); // Revert needed to refund investor on error
543 			// error('buyTokensLowLevel: Investor is not registered on the whitelist');
544 			// return 0;
545 		}
546 		if (isFinalized) {
547 			revert('buyTokensLowLevel: ICO is already finalized'); // Revert needed to refund investor on error
548 			// error('buyTokensLowLevel: ICO is already finalized');
549 			// return 0;
550 		}
551 
552 		// Verify whether enough ether has been sent to buy the min amount of investment
553 		if (_weisAmount < weisMinInvestment) {
554 			revert('buyTokensLowLevel: Minimal investment not reached. Not enough ethers to perform the minimal purchase'); // Revert needed to refund investor on error
555 			// error('buyTokensLowLevel: Minimal investment not reached. Not enough ethers to perform the minimal purchase');
556 			// return 0;
557 		}
558 
559 		// Verify whether there are enough tokens to sell
560 		if (weisRaised.add(_weisAmount) > weisHardCap) {
561 			revert('buyTokensLowLevel: HardCap reached. Not enough tokens on ICO contract to perform this purchase'); // Revert needed to refund investor on error
562 			// error('buyTokensLowLevel: HardCap reached. Not enough tokens on ICO contract to perform this purchase');
563 			// return 0;
564 		}
565 
566 		// Calculate token amount to be sold
567 		tokenAmount = _weisAmount.mul(weisPerEther).div(weisPerBigToken);
568 
569 		// Applying discount
570 		tokenAmount = tokenAmount.mul(100).div(discountedPricePercentage);
571 
572 		// Update state
573 		weisRaised = weisRaised.add(_weisAmount);
574 
575 		// Send the tokens to the investor
576 		if (!SCTokens.transfer(_beneficiary, tokenAmount)) {
577 			revert('buyTokensLowLevel: unable to transfer tokens from ICO contract to beneficiary'); // Revert needed to refund investor on error
578 			// error('buyTokensLowLevel: unable to transfer tokens from ICO contract to beneficiary');
579 			// return 0;
580 		}
581 		emit BuyTokensLowLevel(msg.sender, _beneficiary, _weisAmount, tokenAmount); // Event log
582 
583 		return tokenAmount;
584 	}
585 
586 	/**
587 	 * @return true if ICO event has ended
588 	 */
589 	/* // Deactivated to save ICO contract deployment gas cost
590 	function hasEnded() public constant returns (bool) {
591 		return timestamp() > endTime;
592 	}*/
593 
594 	/**
595 	 * @notice Called by owner to alter the ICO deadline
596 	 */
597 	function updateEndTime(uint256 _endTime) onlyOwner public returns (bool) {
598 		endTime = _endTime;
599 
600 		emit UpdateEndTime(_endTime); // Event log
601 	}
602 
603 
604 	/**
605 	 * @notice Must be called by owner before or after ICO ends, to check whether soft cap is reached and transfer collected funds
606 	 */
607 	function finalize(bool _forceRefund) onlyOwner public returns (bool) {
608 		if (isFinalized) {
609 			error('finalize: ICO is already finalized.');
610 			return false;
611 		}
612 
613 		if (weisRaised >= weisSoftCap && !_forceRefund) {
614 			if (!SCRefundVault.close()) {
615 				error('finalize: SCRefundVault.close() failed');
616 				return false;
617 			}
618 		} else {
619 			if (!SCRefundVault.enableRefunds()) {
620 				error('finalize: SCRefundVault.enableRefunds() failed');
621 				return false;
622 			}
623 			if(_forceRefund) {
624 				emit ForceRefund(); // Event log
625 			}
626 		}
627 
628 		// Move remaining ICO tokens back to the Escrow
629 		uint256 balanceAmount = SCTokens.balanceOf(this);
630 		if (!SCTokens.transfer(address(SCEscrow), balanceAmount)) {
631 			error('finalize: unable to return remaining ICO tokens');
632 			return false;
633 		}
634 		// Adjust Escrow balance correctly
635 		if(!SCEscrow.deposit(balanceAmount)) {
636 			error('finalize: unable to return remaining ICO tokens');
637 			return false;
638 		}
639 
640 		isFinalized = true;
641 
642 		emit Finalized(); // Event log
643 
644 		return true;
645 	}
646 
647 	/**
648 	 * @notice If ICO is unsuccessful, investors can claim refunds here
649 	 */
650 	function claimRefund() public stopInEmergency returns (bool) {
651 		if (!isFinalized) {
652 			error('claimRefund: ICO is not yet finalized.');
653 			return false;
654 		}
655 
656 		if (!SCRefundVault.isRefunding()) {
657 			error('claimRefund: RefundVault state != State.Refunding');
658 			return false;
659 		}
660 
661 		// Before transfering the ETHs to the investor, get back the tokens bought on ICO
662 		uint256 tokenAmount = SCRefundVault.getTokensAcquired(msg.sender);
663 		emit GetBackTokensOnRefund(msg.sender, this, tokenAmount); // Event Log
664 		if (!SCTokens.refundTokens(msg.sender, tokenAmount)) {
665 			error('claimRefund: unable to transfer investor tokens to ICO contract before refunding');
666 			return false;
667 		}
668 
669 		if (!SCRefundVault.refund(msg.sender)) {
670 			error('claimRefund: SCRefundVault.refund() failed');
671 			return false;
672 		}
673 
674 		return true;
675 	}
676 
677 	function fundICO() public onlyOwner {
678 		if (!SCEscrow.fundICO(tokensHardCap, ICOStage)) {
679 			revert('ICO funding failed');
680 		}
681 	}
682 
683 
684 
685 
686 // **** EVENTS
687 
688 	// Triggered when an investor buys some tokens directly with Ethers
689 	event BuyTokens(address indexed _purchaser, uint256 _value, uint256 _amount);
690 
691 	// Triggered when Owner says some investor has requested tokens on PayIn MarketPay.io API
692 	event BuyTokensOraclePayIn(address indexed _purchaser, address indexed _beneficiary, uint256 _weisAmount, uint256 _tokenAmount);
693 
694 	// Triggered when an investor buys some tokens directly with Ethers or through payin Oracle
695 	event BuyTokensLowLevel(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount);
696 
697 	// Triggered when an SC owner request to end the ICO, transferring funds to founders wallet or ofeering them as a refund
698 	event Finalized();
699 
700 	// Triggered when an SC owner request to end the ICO and allow transfer of funds to founders wallets as a refund
701 	event ForceRefund();
702 
703 	// Triggered when RefundVault is created
704 	//event AddressSCRefundVault(address _scAddress);
705 
706 	// Triggered when investor refund and their tokens got back to ICO contract
707 	event GetBackTokensOnRefund(address _from, address _to, uint256 _amount);
708 
709 	// Triggered when Owner updates ICO deadlines
710 	event UpdateEndTime(uint256 _endTime);
711 }
712 
713 contract ICOPreSale is ICO {
714 	/**
715 	 * @notice ICO constructor. Definition of ICO parameters and subcontracts autodeployment
716 	 */
717 	constructor(address _SCEscrow, address _SCTokens, address _SCWhitelist, address _SCRefundVault) public {
718 		if (_SCTokens == 0x0) {
719 			revert('Tokens Constructor: _SCTokens == 0x0');
720 		}
721 		if (_SCWhitelist == 0x0) {
722 			revert('Tokens Constructor: _SCWhitelist == 0x0');
723 		}
724 		if (_SCRefundVault == 0x0) {
725 			revert('Tokens Constructor: _SCRefundVault == 0x0');
726 		}
727 		
728 		SCTokens = Tokens(_SCTokens);
729 		SCWhitelist = Whitelist(_SCWhitelist);
730 		SCRefundVault = RefundVault(_SCRefundVault);
731 		
732 		weisPerEther = 1 ether; // 10e^18 multiplier
733 
734 		// Deadline
735 		startTime = timestamp();
736 		endTime = timestamp().add(24 days); // from 8th June to 2th July 2018
737 
738 		// Token Price
739 		bigTokensPerEther = 7500; // tokens (w/o multiplier) got for 1 ether
740 		tokensPerEther = bigTokensPerEther.mul(weisPerEther); // tokens (with multiplier) got for 1 ether
741 
742 		discount = 45; // pre-sale 45%
743 		discountedPricePercentage = 100;
744 		discountedPricePercentage = discountedPricePercentage.sub(discount);
745 
746 		weisMinInvestment = weisPerEther.mul(1);
747 
748 		// 2018-05-10: alvaro.ariet@lacomunity.com Los Hardcap que indicas no son los últimos comentados. Los correctos serían:
749 		//    Pre-Sale:     8.470 ETH
750 		//    1st Tier:       8.400 ETH
751 		//    2nd Tier:     68.600 ETH
752 
753 		// HardCap
754 		// etherHardCap = 8500; // As of 2018-05-09 => Hardcap pre sale: 8.500 ETH
755 		 // As of 2018-05-10 => Pre-Sale:     8.470 ETH
756 		etherHardCap = 8067; // As of 2018-05-24 => Pre-Sale:     8067 ETH
757 		tokensHardCap = tokensPerEther.mul(etherHardCap).mul(100).div(discountedPricePercentage);
758 
759 		weisPerBigToken = weisPerEther.div(bigTokensPerEther);
760 		// weisHardCap = weisPerBigToken.mul(tokensHardCap).div(weisPerEther);
761 		weisHardCap = weisPerEther.mul(etherHardCap);
762 
763 		// SoftCap
764 		etherSoftCap = 750; // As of 2018-05-09 => Softcap pre sale: 750 ETH
765 		weisSoftCap = weisPerEther.mul(etherSoftCap);
766 
767 		SCEscrow = Escrow(_SCEscrow);
768 
769 		ICOStage = 0;
770 	}
771 
772 }
773 
774 contract Tokens is HardcodedWallets, ERC20, Haltable {
775 
776 	// **** DATA
777 
778 	mapping (address => uint256) balances;
779 	mapping (address => mapping (address => uint256)) allowed;
780 	uint256 public _totalSupply; 
781 
782 	// Public variables of the token, all used for display
783 	string public name;
784 	string public symbol;
785 	uint8 public decimals;
786 	string public standard = 'H0.1'; // HumanStandardToken is a specialisation of ERC20 defining these parameters
787 
788 	// Timelock
789 	uint256 public timelockEndTime;
790 
791 	// Circular reference to ICO contract
792 	address public addressSCICO;
793 
794 	// Circular reference to Escrow contract
795 	address public addressSCEscrow;
796 
797 	// Reference to ComplianceService contract
798 	address public addressSCComplianceService;
799 	ComplianceService public SCComplianceService;
800 
801 	// **** MODIFIERS
802 
803 	// @notice To limit token transfers while timelocked
804 	modifier notTimeLocked() {
805 		if (now < timelockEndTime && msg.sender != addressSCICO && msg.sender != addressSCEscrow) {
806 			error('notTimeLocked: Timelock still active. Function is yet unavailable.');
807 		} else {
808 			_;
809 		}
810 	}
811 
812 
813 	// **** FUNCTIONS
814 	/**
815 	 * @notice Constructor: set up token properties and owner token balance
816 	 */
817 	constructor(address _addressSCEscrow, address _addressSCComplianceService) public {
818 		name = "TheRentalsToken";
819 		symbol = "TRT";
820 		decimals = 18; // 18 decimal places, the same as ETH
821 
822 		// initialSupply = 2000000000 ether; // 2018-04-21: ICO summary.docx: ...Dicho valor generaría un Total Supply de 2.000 millones de TRT.
823         _totalSupply = 1350000000 ether; // 2018-05-10: alvaro.ariet@lacomunity.com ...tenemos una emisión de 1.350 millones de Tokens
824 
825 		timelockEndTime = timestamp().add(45 days); // Default timelock
826 
827 		addressSCEscrow = _addressSCEscrow;
828 		addressSCComplianceService = _addressSCComplianceService;
829 		SCComplianceService = ComplianceService(addressSCComplianceService);
830 
831 		// Token distribution
832 		balances[_addressSCEscrow] = _totalSupply;
833 		emit Transfer(0x0, _addressSCEscrow, _totalSupply);
834 
835 	}
836 
837     /**
838      * @notice Get the token total supply
839      */
840     function totalSupply() public constant returns (uint) {
841 
842         return _totalSupply  - balances[address(0)];
843 
844     }
845 
846 	/**
847 	 * @notice Get the token balance of a wallet with address _owner
848 	 */
849 	function balanceOf(address _owner) public constant returns (uint256 balance) {
850 		return balances[_owner];
851 	}
852 
853 	/**
854 	 * @notice Send _amount amount of tokens to address _to
855 	 */
856 	function transfer(address _to, uint256 _amount) public notTimeLocked stopInEmergency returns (bool success) {
857 		if (balances[msg.sender] < _amount) {
858 			error('transfer: the amount to transfer is higher than your token balance');
859 			return false;
860 		}
861 
862 		if(!SCComplianceService.validate(msg.sender, _to, _amount)) {
863 			error('transfer: not allowed by the compliance service');
864 			return false;
865 		}
866 
867 		balances[msg.sender] = balances[msg.sender].sub(_amount);
868 		balances[_to] = balances[_to].add(_amount);
869 		emit Transfer(msg.sender, _to, _amount); // Event log
870 
871 		return true;
872 	}
873 
874 	/**
875 	 * @notice Send _amount amount of tokens from address _from to address _to
876  	 * @notice The transferFrom method is used for a withdraw workflow, allowing contracts to send 
877  	 * @notice tokens on your behalf, for example to "deposit" to a contract address and/or to charge 
878  	 * @notice fees in sub-currencies; the command should fail unless the _from account has 
879  	 * @notice deliberately authorized the sender of the message via some mechanism
880  	 */
881 	function transferFrom(address _from, address _to, uint256 _amount) public notTimeLocked stopInEmergency returns (bool success) {
882 		if (balances[_from] < _amount) {
883 			error('transferFrom: the amount to transfer is higher than the token balance of the source');
884 			return false;
885 		}
886 		if (allowed[_from][msg.sender] < _amount) {
887 			error('transferFrom: the amount to transfer is higher than the maximum token transfer allowed by the source');
888 			return false;
889 		}
890 
891 		if(!SCComplianceService.validate(_from, _to, _amount)) {
892 			error('transfer: not allowed by the compliance service');
893 			return false;
894 		}
895 
896 		balances[_from] = balances[_from].sub(_amount);
897 		balances[_to] = balances[_to].add(_amount);
898 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
899 		emit Transfer(_from, _to, _amount); // Event log
900 
901 		return true;
902 	}
903 
904 	/**
905 	 * @notice Allow _spender to withdraw from your account, multiple times, up to the _amount amount. 
906  	 * @notice If this function is called again it overwrites the current allowance with _amount.
907 	 */
908 	function approve(address _spender, uint256 _amount) public returns (bool success) {
909 		allowed[msg.sender][_spender] = _amount;
910 		emit Approval(msg.sender, _spender, _amount); // Event log
911 
912 		return true;
913 	}
914 
915 	/**
916 	 * @notice Returns the amount which _spender is still allowed to withdraw from _owner
917 	 */
918 	function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
919 		return allowed[_owner][_spender];
920 	}
921 
922 	/**
923        * @dev Increase the amount of tokens that an owner allowed to a spender.
924        *
925        * approve should be called when allowed[_spender] == 0. To increment
926        * allowed value is better to use this function to avoid 2 calls (and wait until
927        * the first transaction is mined)
928        * From MonolithDAO Token.sol
929        * @param _spender The address which will spend the funds.
930        * @param _addedValue The amount of tokens to increase the allowance by.
931        */
932 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
933 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
934 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
935 		return true;
936 	}
937 
938 	/**
939      * @dev Decrease the amount of tokens that an owner allowed to a spender.
940      *
941      * approve should be called when allowed[_spender] == 0. To decrement
942      * allowed value is better to use this function to avoid 2 calls (and wait until
943      * the first transaction is mined)
944      * From MonolithDAO Token.sol
945      * @param _spender The address which will spend the funds.
946      * @param _subtractedValue The amount of tokens to decrease the allowance by.
947      */
948 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
949 		uint oldValue = allowed[msg.sender][_spender];
950 		if (_subtractedValue > oldValue) {
951 			allowed[msg.sender][_spender] = 0;
952 		} else {
953 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
954 		}
955 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
956 		return true;
957 	}
958 	
959 	/**
960 	 * @notice This is out of ERC20 standard but it is necessary to build market escrow contracts of assets
961 	 * @notice Send _amount amount of tokens to from tx.origin to address _to
962 	 */
963 	function refundTokens(address _from, uint256 _amount) public notTimeLocked stopInEmergency returns (bool success) {
964         if (tx.origin != _from) {
965             error('refundTokens: tx.origin did not request the refund directly');
966             return false;
967         }
968 
969         if (addressSCICO != msg.sender) {
970             error('refundTokens: caller is not the current ICO address');
971             return false;
972         }
973 
974         if (balances[_from] < _amount) {
975             error('refundTokens: the amount to transfer is higher than your token balance');
976             return false;
977         }
978 
979         if(!SCComplianceService.validate(_from, addressSCICO, _amount)) {
980 			error('transfer: not allowed by the compliance service');
981 			return false;
982 		}
983 
984 		balances[_from] = balances[_from].sub(_amount);
985 		balances[addressSCICO] = balances[addressSCICO].add(_amount);
986 		emit Transfer(_from, addressSCICO, _amount); // Event log
987 
988 		return true;
989 	}
990 
991 	/**
992 	 * @notice The owner can specify which ICO contract is allowed to transfer tokens while timelock is on
993 	 */
994 	function setMyICOContract(address _SCICO) public onlyOwner {
995 		addressSCICO = _SCICO;
996 	}
997 
998 	function setComplianceService(address _addressSCComplianceService) public onlyOwner {
999 		addressSCComplianceService = _addressSCComplianceService;
1000 		SCComplianceService = ComplianceService(addressSCComplianceService);
1001 	}
1002 
1003 	/**
1004 	 * @notice Called by owner to alter the token timelock
1005 	 */
1006 	function updateTimeLock(uint256 _timelockEndTime) onlyOwner public returns (bool) {
1007 		timelockEndTime = _timelockEndTime;
1008 
1009 		emit UpdateTimeLock(_timelockEndTime); // Event log
1010 
1011 		return true;
1012 	}
1013 
1014 
1015 	// **** EVENTS
1016 
1017 	// Triggered when tokens are transferred
1018 	event Transfer(address indexed _from, address indexed _to, uint256 _amount);
1019 
1020 	// Triggered when someone approves a spender to move its tokens
1021 	event Approval(address indexed _owner, address indexed _spender, uint256 _amount);
1022 
1023 	// Triggered when Owner updates token timelock
1024 	event UpdateTimeLock(uint256 _timelockEndTime);
1025 }
1026 
1027 contract Whitelist is HardcodedWallets, System {
1028 	// **** DATA
1029 
1030 	mapping (address => bool) public walletsICO;
1031 	mapping (address => bool) public managers;
1032 
1033 	// Checks whether a given wallet is authorized to ICO investing
1034 	function isInvestor(address _wallet) public constant returns (bool) {
1035 		return (walletsICO[_wallet]);
1036 	}
1037 
1038 	/**
1039 	 * @notice Registers an investor
1040 	 */
1041 	function addInvestor(address _wallet) external isManager returns (bool) {
1042 		// Checks whether this wallet has been previously added as an investor
1043 		if (walletsICO[_wallet]) {
1044 			error('addInvestor: this wallet has been previously granted as ICO investor');
1045 			return false;
1046 		}
1047 
1048 		walletsICO[_wallet] = true;
1049 
1050 		emit AddInvestor(_wallet, timestamp()); // Event log
1051 		return true;
1052 	}
1053 
1054 	modifier isManager(){
1055 		if (managers[msg.sender] || msg.sender == owner) {
1056 			_;
1057 		} else {
1058 			error("isManager: called by user that is not owner or manager");
1059 		}
1060 	}
1061 
1062 	// adds an address that will have the right to add investors
1063 	function addManager(address _managerAddr) external onlyOwner returns (bool) {
1064 		if(managers[_managerAddr]){
1065 			error("addManager: manager account already exists.");
1066 			return false;
1067 		}
1068 
1069 		managers[_managerAddr] = true;
1070 
1071 		emit AddManager(_managerAddr, timestamp());
1072 	}
1073 
1074 	// removes a manager address
1075 	function delManager(address _managerAddr) external onlyOwner returns (bool) {
1076 		if(!managers[_managerAddr]){
1077 			error("delManager: manager account not found.");
1078 			return false;
1079 		}
1080 
1081 		delete managers[_managerAddr];
1082 
1083 		emit DelManager(_managerAddr, timestamp());
1084 	}
1085 
1086 	// **** EVENTS
1087 
1088 	// Triggered when a wallet is granted to become an ICO investor
1089 	event AddInvestor(address indexed _wallet, uint256 _timestamp);
1090 	// Triggered when a manager is added
1091 	event AddManager(address indexed _managerAddr, uint256 _timestamp);
1092 	// Triggered when a manager is removed
1093 	event DelManager(address indexed _managerAddr, uint256 _timestamp);
1094 }