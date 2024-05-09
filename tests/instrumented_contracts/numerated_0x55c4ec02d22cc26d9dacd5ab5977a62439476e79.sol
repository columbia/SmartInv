1 pragma solidity ^0.5.0;
2 
3 interface IMultiSigManager {
4 	function provideAddress(address origin, uint poolIndex) external returns (address payable);
5 	function passedContract(address) external returns (bool);
6 	function moderator() external returns(address);
7 }
8 
9 interface ICustodianToken {
10 	function emitTransfer(address from, address to, uint value) external returns (bool success);
11 }
12 
13 interface IWETH {
14 	function balanceOf(address) external returns (uint);
15 	function transfer(address to, uint value) external returns (bool success);
16 	function transferFrom(address from, address to, uint value) external returns (bool success);
17 	function approve(address spender, uint value) external returns (bool success);
18 	function allowance(address owner, address spender) external returns (uint);
19 	function withdraw(uint value) external;
20 	function deposit() external;
21 }
22 
23 interface IOracle {
24 	function getLastPrice() external returns(uint, uint);
25 	function started() external returns(bool);
26 }
27 
28 library SafeMath {
29 	function mul(uint a, uint b) internal pure returns (uint) {
30 		uint c = a * b;
31 		assert(a == 0 || c / a == b);
32 		return c;
33 	}
34 
35 	function div(uint a, uint b) internal pure returns (uint) {
36 		// assert(b > 0); // Solidity automatically throws when dividing by 0
37 		uint c = a / b;
38 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 		return c;
40 	}
41 
42 	function sub(uint a, uint b) internal pure returns (uint) {
43 		assert(b <= a);
44 		return a - b;
45 	}
46 
47 	function add(uint a, uint b) internal pure returns (uint) {
48 		uint c = a + b;
49 		assert(c >= a);
50 		return c;
51 	}
52 
53 	function diff(uint a, uint b) internal pure returns (uint) {
54 		return a > b ? sub(a, b) : sub(b, a);
55 	}
56 
57 	function gt(uint a, uint b) internal pure returns(bytes1) {
58 		bytes1 c;
59 		c = 0x00;
60 		if (a > b) {
61 			c = 0x01;
62 		}
63 		return c;
64 	}
65 }
66 
67 contract Managed {
68 	IMultiSigManager roleManager;
69 	address public roleManagerAddress;
70 	address public operator;
71 	uint public lastOperationTime;
72 	uint public operationCoolDown;
73 	uint constant BP_DENOMINATOR = 10000;
74 
75 	event UpdateRoleManager(address newManagerAddress);
76 	event UpdateOperator(address updater, address newOperator);
77 
78 	modifier only(address addr) {
79 		require(msg.sender == addr);
80 		_;
81 	}
82 
83 	modifier inUpdateWindow() {
84 		uint currentTime = getNowTimestamp();
85 		require(currentTime - lastOperationTime >= operationCoolDown);
86 		_;
87 		lastOperationTime = currentTime;
88 	}
89 
90 	constructor(
91 		address roleManagerAddr,
92 		address opt, 
93 		uint optCoolDown
94 	) public {
95 		roleManagerAddress = roleManagerAddr;
96 		roleManager = IMultiSigManager(roleManagerAddr);
97 		operator = opt;
98 		operationCoolDown = optCoolDown;
99 	}
100 
101 	function updateRoleManager(address newManagerAddr) 
102 		inUpdateWindow() 
103 		public 
104 	returns (bool) {
105 		require(roleManager.passedContract(newManagerAddr));
106 		roleManagerAddress = newManagerAddr;
107 		roleManager = IMultiSigManager(roleManagerAddress);
108 		require(roleManager.moderator() != address(0));
109 		emit UpdateRoleManager(newManagerAddr);
110 		return true;
111 	}
112 
113 	function updateOperator() public inUpdateWindow() returns (bool) {	
114 		address updater = msg.sender;	
115 		operator = roleManager.provideAddress(updater, 0);
116 		emit UpdateOperator(updater, operator);	
117 		return true;
118 	}
119 
120 	function getNowTimestamp() internal view returns (uint) {
121 		return now;
122 	}
123 }
124 
125 /// @title Custodian - every derivative contract should has basic custodian properties
126 /// @author duo.network
127 contract Custodian is Managed {
128 	using SafeMath for uint;
129 
130 	/*
131      * Constants
132      */
133 	uint constant decimals = 18;
134 	uint constant WEI_DENOMINATOR = 1000000000000000000;
135 	enum State {
136 		Inception,
137 		Trading,
138 		PreReset,
139 		Reset,
140 		Matured
141 	}
142 
143 	/*
144      * Storage
145      */
146 	IOracle oracle;
147 	ICustodianToken aToken;
148 	ICustodianToken bToken;
149 	string public contractCode;
150 	address payable feeCollector;
151 	address oracleAddress;
152 	address aTokenAddress;
153 	address bTokenAddress;
154 	mapping(address => uint)[2] public balanceOf;
155 	mapping (address => mapping (address => uint))[2] public allowance;
156 	address[] public users;
157 	mapping (address => uint) public existingUsers;
158 	State state;
159 	uint minBalance = 10000000000000000; // set at constructor
160 	uint public totalSupplyA;
161 	uint public totalSupplyB;
162 	uint ethCollateralInWei;
163 	uint navAInWei;
164 	uint navBInWei;
165 	uint lastPriceInWei;
166 	uint lastPriceTimeInSecond;
167 	uint resetPriceInWei;
168 	uint resetPriceTimeInSecond;
169 	uint createCommInBP;
170 	uint redeemCommInBP;
171 	uint period;
172 	uint maturityInSecond; // set to 0 for perpetuals
173 	uint preResetWaitingBlocks;
174 	uint priceFetchCoolDown;
175 	
176 	// cycle state variables
177 	uint lastPreResetBlockNo = 0;
178 	uint nextResetAddrIndex;
179 
180 	/*
181      *  Modifiers
182      */
183 	modifier inState(State _state) {
184 		require(state == _state);
185 		_;
186 	}
187 
188 	/*
189      *  Events
190      */
191 	event StartTrading(uint navAInWei, uint navBInWei);
192 	event StartPreReset();
193 	event StartReset(uint nextIndex, uint total);
194 	event Matured(uint navAInWei, uint navBInWei);
195 	event AcceptPrice(uint indexed priceInWei, uint indexed timeInSecond, uint navAInWei, uint navBInWei);
196 	event Create(address indexed sender, uint ethAmtInWei, uint tokenAInWei, uint tokenBInWei, uint feeInWei);
197 	event Redeem(address indexed sender, uint ethAmtInWei, uint tokenAInWei, uint tokenBInWei, uint feeInWei);
198 	event TotalSupply(uint totalSupplyAInWei, uint totalSupplyBInWei);
199 	// token events
200 	event Transfer(address indexed from, address indexed to, uint value, uint index);
201 	event Approval(address indexed tokenOwner, address indexed spender, uint tokens, uint index);
202 	// operation events
203 	event CollectFee(address addr, uint feeInWei, uint feeBalanceInWei);
204 	event UpdateOracle(address newOracleAddress);
205 	event UpdateFeeCollector(address updater, address newFeeCollector);
206 
207 	/*
208      *  Constructor
209      */
210 	/// @dev Contract constructor sets operation cool down and set address pool status.
211 	///	@param code contract name
212 	///	@param maturity marutiry time in second
213 	///	@param roleManagerAddr roleManagerContract Address
214 	///	@param fc feeCollector address
215 	///	@param comm commission rate
216 	///	@param pd period
217 	///	@param preResetWaitBlk pre reset waiting block numbers
218 	///	@param pxFetchCoolDown price fetching cool down
219 	///	@param opt operator
220 	///	@param optCoolDown operation cooldown
221 	///	@param minimumBalance niminum balance required
222 	constructor(
223 		string memory code,
224 		uint maturity,
225 		address roleManagerAddr,
226 		address payable fc,
227 		uint comm,
228 		uint pd,
229 		uint preResetWaitBlk, 
230 		uint pxFetchCoolDown,
231 		address opt,
232 		uint optCoolDown,
233 		uint minimumBalance
234 		) 
235 		public
236 		Managed(roleManagerAddr, opt, optCoolDown) 
237 	{
238 		contractCode = code;
239 		maturityInSecond = maturity;
240 		state = State.Inception;
241 		feeCollector = fc;
242 		createCommInBP = comm;
243 		redeemCommInBP = comm;
244 		period = pd;
245 		preResetWaitingBlocks = preResetWaitBlk;
246 		priceFetchCoolDown = pxFetchCoolDown;
247 		navAInWei = WEI_DENOMINATOR;
248 		navBInWei = WEI_DENOMINATOR;
249 		minBalance = minimumBalance;
250 	}
251 
252 	/*
253      * Public functions
254      */
255 
256 	/// @dev return totalUsers in the system.
257 	function totalUsers() public view returns (uint) {
258 		return users.length;
259 	}
260 
261 	function feeBalanceInWei() public view returns(uint) {
262 		return address(this).balance.sub(ethCollateralInWei);
263 	}
264 
265 	/*
266      * ERC token functions
267      */
268 	/// @dev transferInternal function.
269 	/// @param index 0 is classA , 1 is class B
270 	/// @param from  from address
271 	/// @param to   to address
272 	/// @param tokens num of tokens transferred
273 	function transferInternal(uint index, address from, address to, uint tokens) 
274 		internal 
275 		inState(State.Trading)
276 		returns (bool success) 
277 	{
278 		// Prevent transfer to 0x0 address. Use burn() instead
279 		require(to != address(0));
280 		// Check if the sender has enough
281 		require(balanceOf[index][from] >= tokens);
282 
283 		// Save this for an assertion in the future
284 		uint previousBalances = balanceOf[index][from].add(balanceOf[index][to]);
285 		// Subtract from the sender
286 		balanceOf[index][from] = balanceOf[index][from].sub(tokens);
287 		// Add the same to the recipient
288 		balanceOf[index][to] = balanceOf[index][to].add(tokens);
289 	
290 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
291 		assert(balanceOf[index][from].add(balanceOf[index][to]) == previousBalances);
292 		emit Transfer(from, to, tokens, index);
293 		checkUser(from, balanceOf[index][from], balanceOf[1 - index][from]);
294 		checkUser(to, balanceOf[index][to], balanceOf[1 - index][to]);
295 		return true;
296 	}
297 
298 	function determineAddress(uint index, address from) internal view returns (address) {
299 		return index == 0 && msg.sender == aTokenAddress || 
300 			index == 1 && msg.sender == bTokenAddress 
301 			? from : msg.sender;
302 	}
303 
304 	function transfer(uint index, address from, address to, uint tokens)
305 		public
306 		inState(State.Trading)
307 		returns (bool success) 
308 	{
309 		require(index == 0 || index == 1);
310 		return transferInternal(index, determineAddress(index, from), to, tokens);
311 	}
312 
313 	function transferFrom(uint index, address spender, address from, address to, uint tokens) 
314 		public 
315 		inState(State.Trading)
316 		returns (bool success) 
317 	{
318 		require(index == 0 || index == 1);
319 		address spenderToUse = determineAddress(index, spender);
320 		require(tokens <= allowance[index][from][spenderToUse]);	 // Check allowance
321 		allowance[index][from][spenderToUse] = allowance[index][from][spenderToUse].sub(tokens);
322 		return transferInternal(index, from, to, tokens);
323 	}
324 
325 	function approve(uint index, address sender, address spender, uint tokens) 
326 		public 
327 		returns (bool success) 
328 	{
329 		require(index == 0 || index == 1);
330 		address senderToUse = determineAddress(index, sender);
331 		allowance[index][senderToUse][spender] = tokens;
332 		emit Approval(senderToUse, spender, tokens, index);
333 		return true;
334 	}
335 	// end of token functions
336 
337 	/*
338      * Internal Functions
339      */
340 	// start of internal utility functions
341 	function checkUser(address user, uint256 balanceA, uint256 balanceB) internal {
342 		uint userIdx = existingUsers[user];
343 		if ( userIdx > 0) {
344 			if (balanceA < minBalance && balanceB < minBalance) {
345 				uint lastIdx = users.length;
346 				address lastUser = users[lastIdx - 1];
347 				if (userIdx < lastIdx) {
348 					users[userIdx - 1] = lastUser;
349 					existingUsers[lastUser] = userIdx;
350 				}
351 				delete users[lastIdx - 1];
352 				existingUsers[user] = 0;
353 				users.length--;					
354 			}
355 		} else if (balanceA >= minBalance || balanceB >= minBalance) {
356 			users.push(user);
357 			existingUsers[user] = users.length;
358 		}
359 	}
360 	// end of internal utility functions
361 
362 	/*
363      * Operation Functions
364      */
365 	function collectFee(uint amountInWei) 
366 		public 
367 		only(feeCollector) 
368 		inState(State.Trading) 
369 		returns (bool success) 
370 	{
371 		uint feeBalance = feeBalanceInWei().sub(amountInWei);
372 		feeCollector.transfer(amountInWei);
373 		emit CollectFee(feeCollector, amountInWei, feeBalance);
374 		return true;
375 	}
376 
377 	function updateOracle(address newOracleAddr) 
378 		only(roleManager.moderator())
379 		inUpdateWindow() 
380 		public 
381 	returns (bool) {
382 		require(roleManager.passedContract(newOracleAddr));
383 		oracleAddress = newOracleAddr;
384 		oracle = IOracle(oracleAddress);
385 		(uint lastPrice, uint lastPriceTime) = oracle.getLastPrice();
386 		require(lastPrice > 0 && lastPriceTime > 0);
387 		emit UpdateOracle(newOracleAddr);
388 		return true;
389 	}
390 
391 	function updateFeeCollector() 
392 		public 
393 		inUpdateWindow() 
394 	returns (bool) {
395 		address updater = msg.sender;
396 		feeCollector = roleManager.provideAddress(updater, 0);
397 		emit UpdateFeeCollector(updater, feeCollector);
398 		return true;
399 	}
400 }
401 
402 /// @title DualClassCustodian - dual class token contract
403 /// @author duo.network
404 contract DualClassCustodian is Custodian {
405 	/*
406      * Storage
407      */
408 
409 	uint alphaInBP;
410 	uint betaInWei;
411 	uint limitUpperInWei; 
412 	uint limitLowerInWei;
413 	uint iterationGasThreshold;
414 	uint periodCouponInWei; 
415 	uint limitPeriodicInWei; 
416 
417 	// reset intermediate values
418 	uint newAFromAPerA;
419 	uint newAFromBPerB;
420 	uint newBFromAPerA;
421 	uint newBFromBPerB;
422 
423 	enum ResetState {
424 		UpwardReset,
425 		DownwardReset,
426 		PeriodicReset
427 	}
428 
429 	ResetState resetState;
430 
431 	/*
432      * Events
433      */
434 	event SetValue(uint index, uint oldValue, uint newValue);
435 
436 	function() external payable {}
437 	
438 	/*
439      * Constructor
440      */
441 	constructor(
442 		string memory code,
443 		uint maturity,
444 		address roleManagerAddr,
445 		address payable fc,
446 		uint alpha,
447 		uint r,
448 		uint hp,
449 		uint hu,
450 		uint hd,
451 		uint comm,
452 		uint pd,
453 		uint optCoolDown,
454 		uint pxFetchCoolDown,
455 		uint iteGasTh,
456 		uint preResetWaitBlk,
457 		uint minimumBalance
458 		) 
459 		public 
460 		Custodian ( 
461 		code,
462 		maturity,
463 		roleManagerAddr,
464 		fc,
465 		comm,
466 		pd,
467 		preResetWaitBlk, 
468 		pxFetchCoolDown,
469 		msg.sender,
470 		optCoolDown,
471 		minimumBalance
472 		)
473 	{
474 		alphaInBP = alpha;
475 		betaInWei = WEI_DENOMINATOR;
476 		periodCouponInWei = r;
477 		limitPeriodicInWei = hp;
478 		limitUpperInWei = hu; 
479 		limitLowerInWei = hd;
480 		iterationGasThreshold = iteGasTh; // 65000;
481 	}
482 
483 
484 	/*
485      * Public Functions
486      */
487 	/// @dev startCustodian
488 	///	@param aAddr contract address of Class A
489 	///	@param bAddr contract address of Class B
490 	///	@param oracleAddr contract address of Oracle
491 	function startCustodian(
492 		address aAddr,
493 		address bAddr,
494 		address oracleAddr
495 		) 
496 		public 
497 		inState(State.Inception) 
498 		only(operator)
499 		returns (bool success) 
500 	{	
501 		aTokenAddress = aAddr;
502 		aToken = ICustodianToken(aTokenAddress);
503 		bTokenAddress = bAddr;
504 		bToken = ICustodianToken(bTokenAddress);
505 		oracleAddress = oracleAddr;
506 		oracle = IOracle(oracleAddress);
507 		(uint priceInWei, uint timeInSecond) = oracle.getLastPrice();
508 		require(priceInWei > 0 && timeInSecond > 0);
509 		lastPriceInWei = priceInWei;
510 		lastPriceTimeInSecond = timeInSecond;
511 		resetPriceInWei = priceInWei;
512 		resetPriceTimeInSecond = timeInSecond;
513 		roleManager = IMultiSigManager(roleManagerAddress);
514 		state = State.Trading;
515 		emit AcceptPrice(priceInWei, timeInSecond, WEI_DENOMINATOR, WEI_DENOMINATOR);
516 		emit StartTrading(navAInWei, navBInWei);
517 		return true;
518 	}
519 
520 	/// @dev create with ETH
521 	function create() 
522 		public 
523 		payable 
524 		inState(State.Trading) 
525 		returns (bool) 
526 	{	
527 		return createInternal(msg.sender, msg.value);
528 	}
529 
530 	/// @dev create with ETH
531 	///	@param amount amount of WETH to create
532 	///	@param wethAddr wrapEth contract address
533 	function createWithWETH(uint amount, address wethAddr)
534 		public 
535 		inState(State.Trading) 
536 		returns (bool success) 
537 	{
538 		require(amount > 0 && wethAddr != address(0));
539 		IWETH wethToken = IWETH(wethAddr);
540 		wethToken.transferFrom(msg.sender, address(this), amount);
541 		uint wethBalance = wethToken.balanceOf(address(this));
542 		require(wethBalance >= amount);
543 		uint beforeEthBalance = address(this).balance;
544         wethToken.withdraw(wethBalance);
545 		uint ethIncrement = address(this).balance.sub(beforeEthBalance);
546 		require(ethIncrement >= wethBalance);
547 		return createInternal(msg.sender, amount);
548 	}
549 
550 	function createInternal(address sender, uint ethAmtInWei) 
551 		internal 
552 		returns(bool)
553 	{
554 		require(ethAmtInWei > 0);
555 		uint feeInWei;
556 		(ethAmtInWei, feeInWei) = deductFee(ethAmtInWei, createCommInBP);
557 		ethCollateralInWei = ethCollateralInWei.add(ethAmtInWei);
558 		uint numeritor = ethAmtInWei
559 						.mul(resetPriceInWei)
560 						.mul(betaInWei)
561 						.mul(BP_DENOMINATOR
562 		);
563 		uint denominator = WEI_DENOMINATOR
564 						.mul(WEI_DENOMINATOR)
565 						.mul(alphaInBP
566 							.add(BP_DENOMINATOR)
567 		);
568 		uint tokenValueB = numeritor.div(denominator);
569 		uint tokenValueA = tokenValueB.mul(alphaInBP).div(BP_DENOMINATOR);
570 		balanceOf[0][sender] = balanceOf[0][sender].add(tokenValueA);
571 		balanceOf[1][sender] = balanceOf[1][sender].add(tokenValueB);
572 		checkUser(sender, balanceOf[0][sender], balanceOf[1][sender]);
573 		totalSupplyA = totalSupplyA.add(tokenValueA);
574 		totalSupplyB = totalSupplyB.add(tokenValueB);
575 
576 		emit Create(
577 			sender, 
578 			ethAmtInWei, 
579 			tokenValueA, 
580 			tokenValueB, 
581 			feeInWei
582 			);
583 		emit TotalSupply(totalSupplyA, totalSupplyB);
584 		aToken.emitTransfer(address(0), sender, tokenValueA);
585 		bToken.emitTransfer(address(0), sender, tokenValueB);
586 		return true;
587 
588 	}
589 
590 	function redeem(uint amtInWeiA, uint amtInWeiB) 
591 		public 
592 		inState(State.Trading) 
593 		returns (bool success) 
594 	{
595 		uint adjAmtInWeiA = amtInWeiA.mul(BP_DENOMINATOR).div(alphaInBP);
596 		uint deductAmtInWeiB = adjAmtInWeiA < amtInWeiB ? adjAmtInWeiA : amtInWeiB;
597 		uint deductAmtInWeiA = deductAmtInWeiB.mul(alphaInBP).div(BP_DENOMINATOR);
598 		address payable sender = msg.sender;
599 		require(balanceOf[0][sender] >= deductAmtInWeiA && balanceOf[1][sender] >= deductAmtInWeiB);
600 		uint ethAmtInWei = deductAmtInWeiA
601 			.add(deductAmtInWeiB)
602 			.mul(WEI_DENOMINATOR)
603 			.mul(WEI_DENOMINATOR)
604 			.div(resetPriceInWei)
605 			.div(betaInWei);
606 		return redeemInternal(sender, ethAmtInWei, deductAmtInWeiA, deductAmtInWeiB);
607 	}
608 
609 	function redeemAll() public inState(State.Matured) returns (bool success) {
610 		address payable sender = msg.sender;
611 		uint balanceAInWei = balanceOf[0][sender];
612 		uint balanceBInWei = balanceOf[1][sender];
613 		require(balanceAInWei > 0 || balanceBInWei > 0);
614 		uint ethAmtInWei = balanceAInWei
615 			.mul(navAInWei)
616 			.add(balanceBInWei
617 				.mul(navBInWei))
618 			.div(lastPriceInWei);
619 		return redeemInternal(sender, ethAmtInWei, balanceAInWei, balanceBInWei);
620 	}
621 
622 	function redeemInternal(
623 		address payable sender, 
624 		uint ethAmtInWei, 
625 		uint deductAmtInWeiA, 
626 		uint deductAmtInWeiB) 
627 		internal 
628 		returns(bool) 
629 	{
630 		require(ethAmtInWei > 0);
631 		ethCollateralInWei = ethCollateralInWei.sub(ethAmtInWei);
632 		uint feeInWei;
633 		(ethAmtInWei,  feeInWei) = deductFee(ethAmtInWei, redeemCommInBP);
634 
635 		balanceOf[0][sender] = balanceOf[0][sender].sub(deductAmtInWeiA);
636 		balanceOf[1][sender] = balanceOf[1][sender].sub(deductAmtInWeiB);
637 		checkUser(sender, balanceOf[0][sender], balanceOf[1][sender]);
638 		totalSupplyA = totalSupplyA.sub(deductAmtInWeiA);
639 		totalSupplyB = totalSupplyB.sub(deductAmtInWeiB);
640 		sender.transfer(ethAmtInWei);
641 		emit Redeem(
642 			sender, 
643 			ethAmtInWei, 
644 			deductAmtInWeiA, 
645 			deductAmtInWeiB, 
646 			feeInWei
647 		);
648 		emit TotalSupply(totalSupplyA, totalSupplyB);
649 		aToken.emitTransfer(sender, address(0), deductAmtInWeiA);
650 		bToken.emitTransfer(sender, address(0), deductAmtInWeiB);
651 		return true;
652 	}
653 
654 	function deductFee(
655 		uint ethAmtInWei, 
656 		uint commInBP
657 	) 
658 		internal pure
659 		returns (
660 			uint ethAmtAfterFeeInWei, 
661 			uint feeInWei) 
662 	{
663 		require(ethAmtInWei > 0);
664 		feeInWei = ethAmtInWei.mul(commInBP).div(BP_DENOMINATOR);
665 		ethAmtAfterFeeInWei = ethAmtInWei.sub(feeInWei);
666 	}
667 	// end of conversion
668 
669 
670 	// start of operator functions
671 	function setValue(uint idx, uint newValue) public only(operator) inState(State.Trading) inUpdateWindow() returns (bool success) {
672 		uint oldValue;
673 		if (idx == 0) {
674 			require(newValue <= BP_DENOMINATOR);
675 			oldValue = createCommInBP;
676 			createCommInBP = newValue;
677 		} else if (idx == 1) {
678 			require(newValue <= BP_DENOMINATOR);
679 			oldValue = redeemCommInBP;
680 			redeemCommInBP = newValue;
681 		} else if (idx == 2) {
682 			oldValue = iterationGasThreshold;
683 			iterationGasThreshold = newValue;
684 		} else if (idx == 3) {
685 			oldValue = preResetWaitingBlocks;
686 			preResetWaitingBlocks = newValue;
687 		} else {
688 			revert();
689 		}
690 
691 		emit SetValue(idx, oldValue, newValue);
692 		return true;
693 	}
694 	// end of operator functions
695 
696 	function getStates() public view returns (uint[30] memory) {
697 		return [
698 			// managed
699 			lastOperationTime,
700 			operationCoolDown,
701 			// custodian
702 			uint(state),
703 			minBalance,
704 			totalSupplyA,
705 			totalSupplyB,
706 			ethCollateralInWei,
707 			navAInWei,
708 			navBInWei,
709 			lastPriceInWei,
710 			lastPriceTimeInSecond,
711 			resetPriceInWei,
712 			resetPriceTimeInSecond,
713 			createCommInBP,
714 			redeemCommInBP,
715 			period,
716 			maturityInSecond,
717 			preResetWaitingBlocks,
718 			priceFetchCoolDown,
719 			nextResetAddrIndex,
720 			totalUsers(),
721 			feeBalanceInWei(),
722 			// dual class custodian
723 			uint(resetState),
724 			alphaInBP,
725 			betaInWei,
726 			periodCouponInWei, 
727 			limitPeriodicInWei, 
728 			limitUpperInWei, 
729 			limitLowerInWei,
730 			iterationGasThreshold
731 		];
732 	}
733 
734 	function getAddresses() public view returns (address[6] memory) {
735 		return [
736 			roleManagerAddress,
737 			operator,
738 			feeCollector,
739 			oracleAddress,
740 			aTokenAddress,
741 			bTokenAddress
742 		];
743 	}
744 }
745 
746 
747 /// @title Beethoven - dual class token contract
748 /// @author duo.network
749 contract Beethoven is DualClassCustodian {
750 	/*
751      * Storage
752      */
753 	// reset intermediate values
754 	uint bAdj;
755 
756 	/*
757      * Constructor
758      */
759 	constructor(
760 		string memory code,
761 		uint maturity,
762 		address roleManagerAddr,
763 		address payable fc,
764 		uint alpha,
765 		uint r,
766 		uint hp,
767 		uint hu,
768 		uint hd,
769 		uint comm,
770 		uint pd,
771 		uint optCoolDown,
772 		uint pxFetchCoolDown,
773 		uint iteGasTh,
774 		uint preResetWaitBlk,
775 		uint minimumBalance
776 		) 
777 		public 
778 		DualClassCustodian ( 
779 			code,
780 			maturity,
781 			roleManagerAddr,
782 			fc,
783 			alpha,
784 			r,
785 			hp,
786 			hu,
787 			hd,
788 			comm,
789 			pd,
790 			optCoolDown,
791 			pxFetchCoolDown,
792 			iteGasTh,
793 			preResetWaitBlk,
794 			minimumBalance
795 		)
796 	{
797 		bAdj = alphaInBP.add(BP_DENOMINATOR).mul(WEI_DENOMINATOR).div(BP_DENOMINATOR);
798 	}
799 
800 	// start of priceFetch funciton
801 	function fetchPrice() public inState(State.Trading) returns (bool) {
802 		uint currentTime = getNowTimestamp();
803 		require(currentTime > lastPriceTimeInSecond.add(priceFetchCoolDown));
804 		(uint priceInWei, uint timeInSecond) = oracle.getLastPrice();
805 		require(timeInSecond > lastPriceTimeInSecond && timeInSecond <= currentTime && priceInWei > 0);
806 		lastPriceInWei = priceInWei;
807 		lastPriceTimeInSecond = timeInSecond;
808 		(navAInWei, navBInWei) = calculateNav(
809 			priceInWei, 
810 			timeInSecond, 
811 			resetPriceInWei, 
812 			resetPriceTimeInSecond, 
813 			betaInWei);
814 		if (maturityInSecond > 0 && timeInSecond > maturityInSecond) {
815 			state = State.Matured;
816 			emit Matured(navAInWei, navBInWei);
817 		} else if (navBInWei >= limitUpperInWei || navBInWei <= limitLowerInWei || (limitPeriodicInWei > 0 && navAInWei >= limitPeriodicInWei)) {
818 			state = State.PreReset;
819 			lastPreResetBlockNo = block.number;
820 			emit StartPreReset();
821 		} 
822 		emit AcceptPrice(priceInWei, timeInSecond, navAInWei, navBInWei);
823 		return true;
824 	}
825 	
826 	function calculateNav(
827 		uint priceInWei, 
828 		uint timeInSecond, 
829 		uint rstPriceInWei, 
830 		uint rstTimeInSecond,
831 		uint bInWei) 
832 		internal 
833 		view 
834 		returns (uint, uint) 
835 	{
836 		uint numOfPeriods = timeInSecond.sub(rstTimeInSecond).div(period);
837 		uint navParent = priceInWei.mul(WEI_DENOMINATOR).div(rstPriceInWei);
838 		navParent = navParent
839 			.mul(WEI_DENOMINATOR)
840 			.mul(alphaInBP.add(BP_DENOMINATOR))
841 			.div(BP_DENOMINATOR)
842 			.div(bInWei
843 		);
844 		uint navA = periodCouponInWei.mul(numOfPeriods).add(WEI_DENOMINATOR);
845 		uint navAAdj = navA.mul(alphaInBP).div(BP_DENOMINATOR);
846 		if (navParent <= navAAdj)
847 			return (navParent.mul(BP_DENOMINATOR).div(alphaInBP), 0);
848 		else
849 			return (navA, navParent.sub(navAAdj));
850 	}
851 	// end of priceFetch function
852 
853 	// start of reset function
854 	function startPreReset() public inState(State.PreReset) returns (bool success) {
855 		if (block.number - lastPreResetBlockNo >= preResetWaitingBlocks) {
856 			uint newBFromA;
857 			uint newAFromA;
858 			if (navBInWei >= limitUpperInWei) {
859 				state = State.Reset;
860 				resetState = ResetState.UpwardReset;
861 				betaInWei = WEI_DENOMINATOR;
862 				uint excessAInWei = navAInWei.sub(WEI_DENOMINATOR);
863 				uint excessBInWei = navBInWei.sub(WEI_DENOMINATOR);
864 				// excessive B is enough to cover excessive A
865 				//if (excessBInWei >= excessAInWei) {
866 				uint excessBAfterAInWei = excessBInWei.sub(excessAInWei);
867 				newAFromAPerA = excessAInWei;
868 				newBFromAPerA = 0;
869 				uint newBFromExcessBPerB = excessBAfterAInWei.mul(betaInWei).div(bAdj);
870 				newAFromBPerB = newBFromExcessBPerB.mul(alphaInBP).div(BP_DENOMINATOR);
871 				newBFromBPerB = excessAInWei.add(newBFromExcessBPerB);			
872 				// ignore this case for now as it requires a very high coupon rate 
873 				// and very low upper limit for upward reset and a very high periodic limit
874 				/*} else {
875 					uint excessAForBInWei = excessBInWei.mul(alphaInBP).div(BP_DENOMINATOR);
876 					uint excessAAfterBInWei = excessAInWei.sub(excessAForBInWei);
877 					newAFromBPerB = 0;
878 					newBFromBPerB = excessBInWei;
879 					newBFromAPerA = excessAAfterBInWei.mul(betaInWei).div(bAdj);
880 					newAFromAPerA = excessAForBInWei.add(newBFromAPerA.mul(alphaInBP).div(BP_DENOMINATOR));
881 				}*/
882 				// adjust total supply
883 				totalSupplyA = totalSupplyA
884 					.add(totalSupplyA
885 						.mul(newAFromAPerA)
886 						.add(totalSupplyB
887 							.mul(newAFromBPerB))
888 						.div(WEI_DENOMINATOR)
889 				);
890 				totalSupplyB = totalSupplyB
891 					.add(totalSupplyA
892 						.mul(newBFromAPerA)
893 						.add(totalSupplyB
894 							.mul(newBFromBPerB))
895 						.div(WEI_DENOMINATOR)
896 				);
897 			} else if (navBInWei <= limitLowerInWei) {
898 				state = State.Reset;
899 				resetState = ResetState.DownwardReset;
900 				betaInWei = WEI_DENOMINATOR;
901 				newBFromAPerA = navAInWei.sub(navBInWei).mul(betaInWei).div(bAdj);
902 				// below are not used and set to 0
903 				newAFromAPerA = 0;
904 				newBFromBPerB = 0;
905 				newAFromBPerB = 0;
906 				// adjust total supply
907 				newBFromA = totalSupplyA.mul(newBFromAPerA).div(WEI_DENOMINATOR);
908 				newAFromA = newBFromA.mul(alphaInBP).div(BP_DENOMINATOR);
909 				totalSupplyA = totalSupplyA.mul(navBInWei).div(WEI_DENOMINATOR).add(newAFromA);
910 				totalSupplyB = totalSupplyB.mul(navBInWei).div(WEI_DENOMINATOR).add(newBFromA);
911 			} else { // limitPeriodicInWei > 0 && navAInWei >= limitPeriodicInWei
912 				state = State.Reset;
913 				resetState = ResetState.PeriodicReset;
914 				uint num = alphaInBP
915 					.add(BP_DENOMINATOR)
916 					.mul(lastPriceInWei);
917 				uint den = num
918 					.sub(
919 						resetPriceInWei
920 							.mul(alphaInBP)
921 							.mul(betaInWei)
922 							.mul(navAInWei
923 								.sub(WEI_DENOMINATOR))
924 							.div(WEI_DENOMINATOR)
925 							.div(WEI_DENOMINATOR)
926 				);
927 				betaInWei = betaInWei.mul(num).div(den);
928 				newBFromAPerA = navAInWei.sub(WEI_DENOMINATOR).mul(betaInWei).div(bAdj);
929 				// below are not used and set to 0
930 				newBFromBPerB = 0;
931 				newAFromAPerA = 0;
932 				newAFromBPerB = 0;
933 				// adjust total supply
934 				newBFromA = totalSupplyA.mul(newBFromAPerA).div(WEI_DENOMINATOR);
935 				newAFromA = newBFromA.mul(alphaInBP).div(BP_DENOMINATOR);
936 				totalSupplyA = totalSupplyA.add(newAFromA);
937 				totalSupplyB = totalSupplyB.add(newBFromA);
938 			}
939 
940 			emit TotalSupply(totalSupplyA, totalSupplyB);
941 
942 			emit StartReset(nextResetAddrIndex, users.length);
943 		} else 
944 			emit StartPreReset();
945 
946 		return true;
947 	}
948 
949 	function startReset() public inState(State.Reset) returns (bool success) {
950 		uint currentBalanceA;
951 		uint currentBalanceB;
952 		uint newBalanceA;
953 		uint newBalanceB;
954 		uint newAFromA;
955 		uint newBFromA;
956 		address currentAddress;
957 		uint localResetAddrIndex = nextResetAddrIndex;
958 		while (localResetAddrIndex < users.length && gasleft() > iterationGasThreshold) {
959 			currentAddress = users[localResetAddrIndex];
960 			currentBalanceA = balanceOf[0][currentAddress];
961 			currentBalanceB = balanceOf[1][currentAddress];
962 			if (resetState == ResetState.DownwardReset) {
963 				newBFromA = currentBalanceA.mul(newBFromAPerA).div(WEI_DENOMINATOR);
964 				newAFromA = newBFromA.mul(alphaInBP).div(BP_DENOMINATOR);
965 				newBalanceA = currentBalanceA.mul(navBInWei).div(WEI_DENOMINATOR).add(newAFromA);
966 				newBalanceB = currentBalanceB.mul(navBInWei).div(WEI_DENOMINATOR).add(newBFromA);
967 			}
968 			else if (resetState == ResetState.UpwardReset) {
969 				newBalanceA = currentBalanceA
970 					.add(currentBalanceA
971 						.mul(newAFromAPerA)
972 						.add(currentBalanceB
973 							.mul(newAFromBPerB))
974 						.div(WEI_DENOMINATOR)
975 				);
976 				newBalanceB = currentBalanceB
977 					.add(currentBalanceA
978 						.mul(newBFromAPerA)
979 						.add(currentBalanceB
980 							.mul(newBFromBPerB))
981 						.div(WEI_DENOMINATOR)
982 				);
983 			} else {
984 				newBFromA = currentBalanceA.mul(newBFromAPerA).div(WEI_DENOMINATOR);
985 				newAFromA = newBFromA.mul(alphaInBP).div(BP_DENOMINATOR);
986 				newBalanceA = currentBalanceA.add(newAFromA);
987 				newBalanceB = currentBalanceB.add(newBFromA);
988 			}
989 
990 			balanceOf[0][currentAddress] = newBalanceA;
991 			balanceOf[1][currentAddress] = newBalanceB;
992 			localResetAddrIndex++;
993 		}
994 
995 		if (localResetAddrIndex >= users.length) {
996 			if (resetState != ResetState.PeriodicReset) {
997 				resetPriceInWei = lastPriceInWei;
998 				navBInWei = WEI_DENOMINATOR;
999 			}
1000 			resetPriceTimeInSecond = lastPriceTimeInSecond;
1001 			
1002 			navAInWei = WEI_DENOMINATOR;
1003 			nextResetAddrIndex = 0;
1004 
1005 			state = State.Trading;
1006 			emit StartTrading(navAInWei, navBInWei);
1007 			return true;
1008 		} else {
1009 			nextResetAddrIndex = localResetAddrIndex;
1010 			emit StartReset(localResetAddrIndex, users.length);
1011 			return false;
1012 		}
1013 	}
1014 	// end of reset function
1015 }