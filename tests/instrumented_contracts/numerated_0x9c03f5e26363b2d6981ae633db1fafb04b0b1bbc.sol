1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title AdvertisingInterface
5  */
6 interface AdvertisingInterface {
7 	function incrementBetCounter() external returns (bool);
8 }
9 
10 
11 
12 
13 // https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21 		if (a == 0) {
22 			return 0;
23 		}
24 		uint256 c = a * b;
25 		assert(c / a == b);
26 		return c;
27 	}
28 
29 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
30 		// assert(b > 0); // Solidity automatically throws when dividing by 0
31 		uint256 c = a / b;
32 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 		return c;
34 	}
35 
36 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37 		assert(b <= a);
38 		return a - b;
39 	}
40 
41 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
42 		uint256 c = a + b;
43 		assert(c >= a);
44 		return c;
45 	}
46 }
47 
48 
49 
50 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; }
51 
52 contract TokenERC20 {
53 	// Public variables of the token
54 	string public name;
55 	string public symbol;
56 	uint8 public decimals = 18;
57 	// 18 decimals is the strongly suggested default, avoid changing it
58 	uint256 public totalSupply;
59 
60 	// This creates an array with all balances
61 	mapping (address => uint256) public balanceOf;
62 	mapping (address => mapping (address => uint256)) public allowance;
63 
64 	// This generates a public event on the blockchain that will notify clients
65 	event Transfer(address indexed from, address indexed to, uint256 value);
66 
67 	// This generates a public event on the blockchain that will notify clients
68 	event Approval(address indexed _owner, address indexed _spender, uint256 _value);
69 
70 	// This notifies clients about the amount burnt
71 	event Burn(address indexed from, uint256 value);
72 
73 	/**
74 	 * Constructor function
75 	 *
76 	 * Initializes contract with initial supply tokens to the creator of the contract
77 	 */
78 	constructor(
79 		uint256 initialSupply,
80 		string tokenName,
81 		string tokenSymbol
82 	) public {
83 		totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
84 		balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
85 		name = tokenName;                                   // Set the name for display purposes
86 		symbol = tokenSymbol;                               // Set the symbol for display purposes
87 	}
88 
89 	/**
90 	 * Internal transfer, only can be called by this contract
91 	 */
92 	function _transfer(address _from, address _to, uint _value) internal {
93 		// Prevent transfer to 0x0 address. Use burn() instead
94 		require(_to != 0x0);
95 		// Check if the sender has enough
96 		require(balanceOf[_from] >= _value);
97 		// Check for overflows
98 		require(balanceOf[_to] + _value > balanceOf[_to]);
99 		// Save this for an assertion in the future
100 		uint previousBalances = balanceOf[_from] + balanceOf[_to];
101 		// Subtract from the sender
102 		balanceOf[_from] -= _value;
103 		// Add the same to the recipient
104 		balanceOf[_to] += _value;
105 		emit Transfer(_from, _to, _value);
106 		// Asserts are used to use static analysis to find bugs in your code. They should never fail
107 		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
108 	}
109 
110 	/**
111 	 * Transfer tokens
112 	 *
113 	 * Send `_value` tokens to `_to` from your account
114 	 *
115 	 * @param _to The address of the recipient
116 	 * @param _value the amount to send
117 	 */
118 	function transfer(address _to, uint256 _value) public returns (bool success) {
119 		_transfer(msg.sender, _to, _value);
120 		return true;
121 	}
122 
123 	/**
124 	 * Transfer tokens from other address
125 	 *
126 	 * Send `_value` tokens to `_to` in behalf of `_from`
127 	 *
128 	 * @param _from The address of the sender
129 	 * @param _to The address of the recipient
130 	 * @param _value the amount to send
131 	 */
132 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
133 		require(_value <= allowance[_from][msg.sender]);     // Check allowance
134 		allowance[_from][msg.sender] -= _value;
135 		_transfer(_from, _to, _value);
136 		return true;
137 	}
138 
139 	/**
140 	 * Set allowance for other address
141 	 *
142 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf
143 	 *
144 	 * @param _spender The address authorized to spend
145 	 * @param _value the max amount they can spend
146 	 */
147 	function approve(address _spender, uint256 _value) public returns (bool success) {
148 		allowance[msg.sender][_spender] = _value;
149 		emit Approval(msg.sender, _spender, _value);
150 		return true;
151 	}
152 
153 	/**
154 	 * Set allowance for other address and notify
155 	 *
156 	 * Allows `_spender` to spend no more than `_value` tokens in your behalf, and then ping the contract about it
157 	 *
158 	 * @param _spender The address authorized to spend
159 	 * @param _value the max amount they can spend
160 	 * @param _extraData some extra information to send to the approved contract
161 	 */
162 	function approveAndCall(address _spender, uint256 _value, bytes _extraData)
163 		public
164 		returns (bool success) {
165 		tokenRecipient spender = tokenRecipient(_spender);
166 		if (approve(_spender, _value)) {
167 			spender.receiveApproval(msg.sender, _value, this, _extraData);
168 			return true;
169 		}
170 	}
171 
172 	/**
173 	 * Destroy tokens
174 	 *
175 	 * Remove `_value` tokens from the system irreversibly
176 	 *
177 	 * @param _value the amount of money to burn
178 	 */
179 	function burn(uint256 _value) public returns (bool success) {
180 		require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
181 		balanceOf[msg.sender] -= _value;            // Subtract from the sender
182 		totalSupply -= _value;                      // Updates totalSupply
183 		emit Burn(msg.sender, _value);
184 		return true;
185 	}
186 
187 	/**
188 	 * Destroy tokens from other account
189 	 *
190 	 * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
191 	 *
192 	 * @param _from the address of the sender
193 	 * @param _value the amount of money to burn
194 	 */
195 	function burnFrom(address _from, uint256 _value) public returns (bool success) {
196 		require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
197 		require(_value <= allowance[_from][msg.sender]);    // Check allowance
198 		balanceOf[_from] -= _value;                         // Subtract from the targeted balance
199 		allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
200 		totalSupply -= _value;                              // Update totalSupply
201 		emit Burn(_from, _value);
202 		return true;
203 	}
204 }
205 
206 contract developed {
207 	address public developer;
208 
209 	/**
210 	 * Constructor
211 	 */
212 	constructor() public {
213 		developer = msg.sender;
214 	}
215 
216 	/**
217 	 * @dev Checks only developer address is calling
218 	 */
219 	modifier onlyDeveloper {
220 		require(msg.sender == developer);
221 		_;
222 	}
223 
224 	/**
225 	 * @dev Allows developer to switch developer address
226 	 * @param _developer The new developer address to be set
227 	 */
228 	function changeDeveloper(address _developer) public onlyDeveloper {
229 		developer = _developer;
230 	}
231 
232 	/**
233 	 * @dev Allows developer to withdraw ERC20 Token
234 	 */
235 	function withdrawToken(address tokenContractAddress) public onlyDeveloper {
236 		TokenERC20 _token = TokenERC20(tokenContractAddress);
237 		if (_token.balanceOf(this) > 0) {
238 			_token.transfer(developer, _token.balanceOf(this));
239 		}
240 	}
241 }
242 
243 
244 
245 /**
246  * @title Advertising
247  */
248 contract Advertising is developed, AdvertisingInterface {
249 	using SafeMath for uint256;
250 	address private incrementer;
251 
252 	bool public paused;
253 	bool public contractKilled;
254 
255 	uint256 public numCreatives;
256 	uint256 public numCreativeTypes;
257 	uint256 public maxCountPerCreativeType;
258 	uint256 public earnedBalance;
259 
260 	struct Creative {
261 		bytes32 creativeId;
262 		address advertiser;
263 		uint256 creativeTypeId;       // This determines the creative size and where we display it
264 		string name;
265 		uint256 weiBudget;
266 		uint256 weiPerBet;
267 		uint256 betCounter;
268 		int256 position;
269 		string url;
270 		string imageUrl;
271 		bool approved;
272 		uint256 createdOn;
273 	}
274 
275 	struct CreativeType {
276 		string name;
277 		uint256 width;
278 		uint256 height;
279 		/**
280 		 * @dev Where to display the creative
281 		 * 1 = top
282 		 * 2 = right
283 		 * 3 = bottom
284 		 * 4 = left
285 		 */
286 		uint256 position;
287 		bool active;
288 	}
289 
290 	mapping (bytes32 => Creative) public creatives;
291 	mapping (bytes32 => uint256) private creativeIdLookup;
292 	mapping (uint256 => CreativeType) public creativeTypes;
293 	mapping (address => uint256) public advertiserPendingWithdrawals;
294 	mapping (uint256 => bytes32[]) public pendingCreativePosition;
295 	mapping (uint256 => bytes32[]) public approvedCreativePosition;
296 
297 	/**
298 	 * @dev Log when dev add new creative type
299 	 */
300 	event LogAddCreativeType(uint256 indexed creativeTypeId, string name, uint256 width, uint256 height, uint256 position);
301 
302 	/**
303 	 * @dev Log when dev activate/deactivate creative type
304 	 */
305 	event LogSetActiveCreativeType(uint256 creativeTypeId, bool active);
306 
307 	/**
308 	 * @dev Log when dev approves creative
309 	 */
310 	event LogApproveCreative(bytes32 indexed creativeId, address indexed advertiser, uint256 indexed creativeTypeId, int256 position);
311 
312 	/**
313 	 * @dev Log when dev set contract to emergency mode
314 	 */
315 	event LogEscapeHatch();
316 
317 	/**
318 	 * @dev Log when advertiser creates creative
319 	 */
320 	event LogCreateCreative(bytes32 indexed creativeId, address indexed advertiser, uint256 indexed creativeTypeId, string name, uint256 weiBudget, uint256 weiPerBet, int256 position);
321 
322 	/**
323 	 * @dev Log when we refund creative
324 	 * creativeStatus:
325 	 * 0 = pending
326 	 * 1 = approved
327 	 * refundStatus:
328 	 * 0 = failed
329 	 * 1 = success
330 	 */
331 	event LogRefundCreative(bytes32 indexed creativeId, address indexed advertiser, uint256 refundAmount, uint256 creativeStatus, uint256 refundStatus);
332 
333 	/**
334 	 * @dev Log when advertiser withdraws balance from failed transfer
335 	 *
336 	 * Status:
337 	 * 0 = failed
338 	 * 1 = success
339 	 */
340 	event LogWithdrawBalance(address indexed advertiser, uint256 withdrawAmount, uint256 status);
341 
342 	/**
343 	 * @dev Log when we increment bet counter for a creative
344 	 */
345 	event LogIncrementBetCounter(bytes32 indexed creativeId, address indexed advertiser, uint256 numBets);
346 
347 	/**
348 	 * Constructor
349 	 */
350 	constructor(address _incrementer) public {
351 		devSetMaxCountPerCreativeType(10);
352 		devSetIncrementer(_incrementer);
353 	}
354 
355 	/**
356 	 * @dev Checks if the contract is currently alive
357 	 */
358 	modifier contractIsAlive {
359 		require(contractKilled == false);
360 		_;
361 	}
362 
363 	/**
364 	 * @dev Checks if contract is active
365 	 */
366 	modifier isActive {
367 		require(paused == false);
368 		_;
369 	}
370 
371 	/**
372 	 * @dev Check if creative is valid
373 	 * @param creativeTypeId The creative type ID
374 	 * @param name The name of this creative
375 	 * @param weiBudget The budget for this creative
376 	 * @param weiPerBet Cost per bet for an ad
377 	 * @param url The url of the ad that we want to redirect to
378 	 * @param imageUrl The image url for this ad
379 	 */
380 	modifier creativeIsValid(uint256 creativeTypeId, string name, uint256 weiBudget, uint256 weiPerBet, string url, string imageUrl) {
381 		require (creativeTypes[creativeTypeId].active == true &&
382 			 bytes(name).length > 0 &&
383 			 weiBudget > 0 &&
384 			 weiPerBet > 0 &&
385 			 weiBudget >= weiPerBet &&
386 			 bytes(url).length > 0 &&
387 			 bytes(imageUrl).length > 0 &&
388 			 (pendingCreativePosition[creativeTypeId].length < maxCountPerCreativeType ||
389 			  (pendingCreativePosition[creativeTypeId].length == maxCountPerCreativeType && weiPerBet > creatives[pendingCreativePosition[creativeTypeId][maxCountPerCreativeType-1]].weiPerBet)
390 			 )
391 		);
392 		_;
393 	}
394 
395 	/**
396 	 * @dev Checks is caller is from incrementer
397 	 */
398 	modifier onlyIncrementer {
399 		require (msg.sender == incrementer);
400 		_;
401 	}
402 
403 	/******************************************/
404 	/*       DEVELOPER ONLY METHODS           */
405 	/******************************************/
406 	/**
407 	 * @dev Dev sets address that is allowed to increment ad metrics
408 	 * @param _incrementer The address to be set
409 	 */
410 	function devSetIncrementer(address _incrementer) public onlyDeveloper {
411 		incrementer = _incrementer;
412 	}
413 
414 	/**
415 	 * @dev Dev get incrementer address
416 	 */
417 	function devGetIncrementer() public onlyDeveloper constant returns (address) {
418 		return incrementer;
419 	}
420 
421 	/**
422 	 * @dev Dev sets max count per creative type
423 	 * @param _maxCountPerCreativeType The max number of ad for a creative type
424 	 */
425 	function devSetMaxCountPerCreativeType(uint256 _maxCountPerCreativeType) public onlyDeveloper {
426 		require (_maxCountPerCreativeType > 0);
427 		maxCountPerCreativeType = _maxCountPerCreativeType;
428 	}
429 
430 	/**
431 	 * @dev Dev add creative type
432 	 * @param name The name of this creative type
433 	 * @param width The width of the creative
434 	 * @param height The height of the creative
435 	 * @param position The position of the creative
436 	 */
437 	function devAddCreativeType(string name, uint256 width, uint256 height, uint256 position) public onlyDeveloper {
438 		require (width > 0 && height > 0 && position > 0);
439 
440 		// Increment num creative types
441 		numCreativeTypes++;
442 
443 		CreativeType storage _creativeType = creativeTypes[numCreativeTypes];
444 
445 		// Store the info about this creative type
446 		_creativeType.name = name;
447 		_creativeType.width = width;
448 		_creativeType.height = height;
449 		_creativeType.position = position;
450 		_creativeType.active = true;
451 
452 		emit LogAddCreativeType(numCreativeTypes, _creativeType.name, _creativeType.width, _creativeType.height, _creativeType.position);
453 	}
454 
455 	/**
456 	 * @dev Dev activate/deactivate creative type
457 	 * @param creativeTypeId The creative type ID to be set
458 	 * @param active The bool value to be set
459 	 */
460 	function devSetActiveCreativeType(uint256 creativeTypeId, bool active) public onlyDeveloper {
461 		creativeTypes[creativeTypeId].active = active;
462 		emit LogSetActiveCreativeType(creativeTypeId, active);
463 	}
464 
465 	/**
466 	 * @dev Allows dev to approve/disapprove a creative
467 	 * @param creativeId The creative ID to be approved
468 	 */
469 	function devApproveCreative(bytes32 creativeId) public onlyDeveloper {
470 		Creative storage _creative = creatives[creativeId];
471 		require (_creative.approved == false && _creative.position > -1 && _creative.createdOn > 0);
472 		_creative.approved = true;
473 		_removePending(creativeId);
474 		_insertSortApprovedCreative(_creative.creativeTypeId, _creative.creativeId);
475 	}
476 
477 	/**
478 	 * @dev Allows dev to withdraw earned balance
479 	 */
480 	function devWithdrawEarnedBalance() public onlyDeveloper returns (bool) {
481 		require (earnedBalance > 0);
482 		require (address(this).balance >= earnedBalance);
483 		uint256 withdrawAmount = earnedBalance;
484 		earnedBalance = 0;
485 		if (!developer.send(withdrawAmount)) {
486 			earnedBalance = withdrawAmount;
487 			return false;
488 		} else {
489 			return true;
490 		}
491 	}
492 
493 	/**
494 	 * @dev Dev ends the ad
495 	 * @param creativeId The creative ID to be ended
496 	 */
497 	function devEndCreative(bytes32 creativeId) public onlyDeveloper {
498 		_endCreative(creativeId);
499 	}
500 
501 	/**
502 	 * @dev Allows developer to pause the contract
503 	 * @param _paused The new paused value to be set
504 	 */
505 	function devSetPaused(bool _paused) public onlyDeveloper {
506 		paused = _paused;
507 	}
508 
509 	/**
510 	 * @dev Allows developer to trigger emergency mode.
511 	 */
512 	function escapeHatch() public onlyDeveloper contractIsAlive returns (bool) {
513 		contractKilled = true;
514 		if (earnedBalance > 0) {
515 			uint256 withdrawAmount = earnedBalance;
516 			earnedBalance = 0;
517 			if (!developer.send(withdrawAmount)) {
518 				earnedBalance = withdrawAmount;
519 			}
520 		}
521 
522 		if (numCreativeTypes > 0) {
523 			for (uint256 i=1; i <= numCreativeTypes; i++) {
524 				/*
525 				 * First, we refund all the pending creatives.
526 				 * Instead of sending the refund amount, we ask advertisers to withdraw the refunded amount themselves
527 				 */
528 				uint256 creativeCount = pendingCreativePosition[i].length;
529 				if (creativeCount > 0) {
530 					for (uint256 j=0; j < creativeCount; j++) {
531 						Creative memory _creative = creatives[pendingCreativePosition[i][j]];
532 
533 						// let advertiser withdraw via advertiserPendingWithdrawals
534 						advertiserPendingWithdrawals[_creative.advertiser] = advertiserPendingWithdrawals[_creative.advertiser].add(_creative.weiBudget);
535 					}
536 				}
537 
538 				/*
539 				 * Then, we refund all the approved creatives
540 				 */
541 				creativeCount = approvedCreativePosition[i].length;
542 				if (creativeCount > 0) {
543 					for (j=0; j < creativeCount; j++) {
544 						_creative = creatives[approvedCreativePosition[i][j]];
545 						uint256 refundAmount = _creative.weiBudget.sub(_creative.betCounter.mul(_creative.weiPerBet));
546 						// let advertiser withdraw via advertiserPendingWithdrawals
547 						advertiserPendingWithdrawals[_creative.advertiser] = advertiserPendingWithdrawals[_creative.advertiser].add(refundAmount);
548 					}
549 				}
550 			}
551 		}
552 
553 		emit LogEscapeHatch();
554 		return true;
555 	}
556 
557 	/******************************************/
558 	/*      INCREMENT ADDRESS METHODS         */
559 	/******************************************/
560 	function incrementBetCounter() public onlyIncrementer contractIsAlive isActive returns (bool) {
561 		if (numCreativeTypes > 0) {
562 			for (uint256 i=1; i <= numCreativeTypes; i++) {
563 				CreativeType memory _creativeType = creativeTypes[i];
564 				uint256 creativeCount = approvedCreativePosition[i].length;
565 				if (_creativeType.active == false || creativeCount == 0) {
566 					continue;
567 				}
568 
569 				Creative storage _creative = creatives[approvedCreativePosition[i][0]];
570 				_creative.betCounter++;
571 				emit LogIncrementBetCounter(_creative.creativeId, _creative.advertiser, _creative.betCounter);
572 
573 				uint256 totalSpent = _creative.weiPerBet.mul(_creative.betCounter);
574 				if (totalSpent > _creative.weiBudget) {
575 					earnedBalance = earnedBalance.add(_creative.weiBudget.sub(_creative.weiPerBet.mul(_creative.betCounter.sub(1))));
576 					_removeApproved(_creative.creativeId);
577 				} else {
578 					earnedBalance = earnedBalance.add(_creative.weiPerBet);
579 				}
580 			}
581 		}
582 		return true;
583 	}
584 
585 	/******************************************/
586 	/*             PUBLIC METHODS             */
587 	/******************************************/
588 
589 	/**
590 	 * @dev Advertiser submits an ad
591 	 * @param creativeTypeId The creative type ID (determines where we display it)
592 	 * @param name The name of this creative
593 	 * @param weiPerBet Cost per bet for an ad
594 	 * @param url The url of the ad that we want to redirect to
595 	 * @param imageUrl The image url for this ad
596 	 */
597 	function createCreative(uint256 creativeTypeId, string name, uint256 weiPerBet, string url, string imageUrl)
598 		public
599 		payable
600 		contractIsAlive
601 		isActive
602 		creativeIsValid(creativeTypeId, name, msg.value, weiPerBet, url, imageUrl) {
603 		// Increment num creatives
604 		numCreatives++;
605 
606 		// Generate ID for this creative
607 		bytes32 creativeId = keccak256(abi.encodePacked(this, msg.sender, numCreatives));
608 
609 		Creative storage _creative = creatives[creativeId];
610 
611 		// Store the info about this creative
612 		_creative.creativeId = creativeId;
613 		_creative.advertiser = msg.sender;
614 		_creative.creativeTypeId = creativeTypeId;
615 		_creative.name = name;
616 		_creative.weiBudget = msg.value;
617 		_creative.weiPerBet = weiPerBet;
618 		_creative.url = url;
619 		_creative.imageUrl = imageUrl;
620 		_creative.createdOn = now;
621 
622 		// Decide which position this creative is
623 		_insertSortPendingCreative(creativeTypeId, creativeId);
624 	}
625 
626 	/**
627 	 * @dev Advertiser ends the ad
628 	 * @param creativeId The creative ID to be ended
629 	 */
630 	function endCreative(bytes32 creativeId) public
631 		contractIsAlive
632 		isActive {
633 		Creative storage _creative = creatives[creativeId];
634 		require (_creative.advertiser == msg.sender);
635 		_endCreative(creativeId);
636 	}
637 
638 	/**
639 	 * @dev withdraws balance in case of a failed refund or failed win send
640 	 */
641 	function withdrawPendingTransactions() public {
642 		uint256 withdrawAmount = advertiserPendingWithdrawals[msg.sender];
643 		require (withdrawAmount > 0);
644 		require (address(this).balance >= withdrawAmount);
645 
646 		advertiserPendingWithdrawals[msg.sender] = 0;
647 
648 		// External call to untrusted contract
649 		if (msg.sender.send(withdrawAmount)) {
650 			emit LogWithdrawBalance(msg.sender, withdrawAmount, 1);
651 		} else {
652 			/*
653 			 * If send failed, revert advertiserPendingWithdrawals[msg.sender] = 0
654 			 * so that player can try to withdraw again later
655 			 */
656 			advertiserPendingWithdrawals[msg.sender] = withdrawAmount;
657 			emit LogWithdrawBalance(msg.sender, withdrawAmount, 0);
658 		}
659 	}
660 
661 	/******************************************/
662 	/*           INTERNAL METHODS             */
663 	/******************************************/
664 
665 	/**
666 	 * @dev Insert the newly submitted creative and sort the array to determine its position.
667 	 *      If the array container length is greater than max count, then we want to refund the last element
668 	 * @param creativeTypeId The creative type ID of this ad
669 	 * @param creativeId The creative ID of this ad
670 	 */
671 	function _insertSortPendingCreative(uint256 creativeTypeId, bytes32 creativeId) internal {
672 		pendingCreativePosition[creativeTypeId].push(creativeId);
673 
674 		uint256 pendingCount = pendingCreativePosition[creativeTypeId].length;
675 		bytes32[] memory copyArray = new bytes32[](pendingCount);
676 
677 		for (uint256 i=0; i<pendingCount; i++) {
678 			copyArray[i] = pendingCreativePosition[creativeTypeId][i];
679 		}
680 
681 		uint256 value;
682 		bytes32 key;
683 		for (i = 1; i < copyArray.length; i++) {
684 			key = copyArray[i];
685 			value = creatives[copyArray[i]].weiPerBet;
686 			for (uint256 j=i; j > 0 && creatives[copyArray[j-1]].weiPerBet < value; j--) {
687 				copyArray[j] = copyArray[j-1];
688 			}
689 			copyArray[j] = key;
690 		}
691 
692 		for (i=0; i<pendingCount; i++) {
693 			pendingCreativePosition[creativeTypeId][i] = copyArray[i];
694 			creatives[copyArray[i]].position = int(i);
695 		}
696 
697 		Creative memory _creative = creatives[creativeId];
698 		emit LogCreateCreative(_creative.creativeId, _creative.advertiser, _creative.creativeTypeId, _creative.name, _creative.weiBudget, _creative.weiPerBet, _creative.position);
699 
700 		// If total count is more than max count, then we want to refund the last ad
701 		if (pendingCount > maxCountPerCreativeType) {
702 			bytes32 removeCreativeId = pendingCreativePosition[creativeTypeId][pendingCount-1];
703 			creatives[removeCreativeId].position = -1;
704 			delete pendingCreativePosition[creativeTypeId][pendingCount-1];
705 			pendingCreativePosition[creativeTypeId].length--;
706 			_refundPending(removeCreativeId);
707 		}
708 	}
709 
710 	/**
711 	 * @dev Refund the pending creative
712 	 * @param creativeId The creative ID of this ad
713 	 */
714 	function _refundPending(bytes32 creativeId) internal {
715 		Creative memory _creative = creatives[creativeId];
716 		require (address(this).balance >= _creative.weiBudget);
717 		require (_creative.position == -1);
718 		if (!_creative.advertiser.send(_creative.weiBudget)) {
719 			emit LogRefundCreative(_creative.creativeId, _creative.advertiser, _creative.weiBudget, 0, 0);
720 
721 			// If send failed, let advertiser withdraw via advertiserPendingWithdrawals
722 			advertiserPendingWithdrawals[_creative.advertiser] = advertiserPendingWithdrawals[_creative.advertiser].add(_creative.weiBudget);
723 		} else {
724 			emit LogRefundCreative(_creative.creativeId, _creative.advertiser, _creative.weiBudget, 0, 1);
725 		}
726 	}
727 
728 	/**
729 	 * @dev Insert the newly approved creative and sort the array to determine its position.
730 	 *      If the array container length is greater than max count, then we want to refund the last element.
731 	 * @param creativeTypeId The creative type ID of this ad
732 	 * @param creativeId The creative ID of this ad
733 	 */
734 	function _insertSortApprovedCreative(uint256 creativeTypeId, bytes32 creativeId) internal {
735 		approvedCreativePosition[creativeTypeId].push(creativeId);
736 
737 		uint256 approvedCount = approvedCreativePosition[creativeTypeId].length;
738 		bytes32[] memory copyArray = new bytes32[](approvedCount);
739 
740 		for (uint256 i=0; i<approvedCount; i++) {
741 			copyArray[i] = approvedCreativePosition[creativeTypeId][i];
742 		}
743 
744 		uint256 value;
745 		bytes32 key;
746 		for (i = 1; i < copyArray.length; i++) {
747 			key = copyArray[i];
748 			value = creatives[copyArray[i]].weiPerBet;
749 			for (uint256 j=i; j > 0 && creatives[copyArray[j-1]].weiPerBet < value; j--) {
750 				copyArray[j] = copyArray[j-1];
751 			}
752 			copyArray[j] = key;
753 		}
754 
755 		for (i=0; i<approvedCount; i++) {
756 			approvedCreativePosition[creativeTypeId][i] = copyArray[i];
757 			creatives[copyArray[i]].position = int(i);
758 		}
759 
760 		Creative memory _creative = creatives[creativeId];
761 		emit LogApproveCreative(_creative.creativeId, _creative.advertiser, _creative.creativeTypeId, _creative.position);
762 
763 		// If total count is more than max count, then we want to refund the last ad
764 		if (approvedCount > maxCountPerCreativeType) {
765 			bytes32 removeCreativeId = approvedCreativePosition[creativeTypeId][approvedCount-1];
766 			creatives[removeCreativeId].position = -1;
767 			delete approvedCreativePosition[creativeTypeId][approvedCount-1];
768 			approvedCreativePosition[creativeTypeId].length--;
769 			_refundApproved(removeCreativeId);
770 		}
771 	}
772 
773 	/**
774 	 * @dev Refund the approved creative
775 	 * @param creativeId The creative ID of this ad
776 	 */
777 	function _refundApproved(bytes32 creativeId) internal {
778 		Creative memory _creative = creatives[creativeId];
779 		uint256 refundAmount = _creative.weiBudget.sub(_creative.betCounter.mul(_creative.weiPerBet));
780 		require (address(this).balance >= refundAmount);
781 		require (_creative.position == -1);
782 		if (!_creative.advertiser.send(refundAmount)) {
783 			emit LogRefundCreative(_creative.creativeId, _creative.advertiser, refundAmount, 1, 0);
784 
785 			// If send failed, let advertiser withdraw via advertiserPendingWithdrawals
786 			advertiserPendingWithdrawals[_creative.advertiser] = advertiserPendingWithdrawals[_creative.advertiser].add(refundAmount);
787 		} else {
788 			emit LogRefundCreative(_creative.creativeId, _creative.advertiser, refundAmount, 1, 1);
789 		}
790 	}
791 
792 	/**
793 	 * @dev End creative
794 	 * @param creativeId The creative ID to be removed
795 	 */
796 	function _endCreative(bytes32 creativeId) internal {
797 		Creative storage _creative = creatives[creativeId];
798 		require (_creative.position > -1 && _creative.createdOn > 0);
799 
800 		if (_creative.approved == false) {
801 			_removePending(creativeId);
802 			_refundPending(creativeId);
803 		} else {
804 			_removeApproved(creativeId);
805 			_refundApproved(creativeId);
806 		}
807 	}
808 
809 	/**
810 	 * @dev Remove element in pending creatives array
811 	 * @param creativeId The creative ID to be removed
812 	 */
813 	function _removePending(bytes32 creativeId) internal {
814 		Creative storage _creative = creatives[creativeId];
815 		uint256 pendingCount = pendingCreativePosition[_creative.creativeTypeId].length;
816 
817 		if (_creative.position >= int256(pendingCount)) return;
818 
819 		for (uint256 i = uint256(_creative.position); i < pendingCount-1; i++){
820 			pendingCreativePosition[_creative.creativeTypeId][i] = pendingCreativePosition[_creative.creativeTypeId][i+1];
821 			creatives[pendingCreativePosition[_creative.creativeTypeId][i]].position = int256(i);
822 		}
823 		_creative.position = -1;
824 		delete pendingCreativePosition[_creative.creativeTypeId][pendingCount-1];
825 		pendingCreativePosition[_creative.creativeTypeId].length--;
826 	}
827 
828 	/**
829 	 * @dev Remove element in approved creatives array
830 	 * @param creativeId The creative ID to be removed
831 	 */
832 	function _removeApproved(bytes32 creativeId) internal {
833 		Creative storage _creative = creatives[creativeId];
834 		uint256 approvedCount = approvedCreativePosition[_creative.creativeTypeId].length;
835 
836 		if (_creative.position >= int256(approvedCount)) return;
837 
838 		for (uint256 i = uint256(_creative.position); i < approvedCount-1; i++){
839 			approvedCreativePosition[_creative.creativeTypeId][i] = approvedCreativePosition[_creative.creativeTypeId][i+1];
840 			creatives[approvedCreativePosition[_creative.creativeTypeId][i]].position = int256(i);
841 		}
842 		_creative.position = -1;
843 		delete approvedCreativePosition[_creative.creativeTypeId][approvedCount-1];
844 		approvedCreativePosition[_creative.creativeTypeId].length--;
845 	}
846 }