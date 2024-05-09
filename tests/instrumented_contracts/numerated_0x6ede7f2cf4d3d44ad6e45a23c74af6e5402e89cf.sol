1 pragma solidity 0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * See https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 /**
16  * @title Basic token
17  * @dev Basic version of StandardToken, with no allowances.
18  */
19 contract BasicToken is ERC20Basic {
20   using SafeMath for uint256;
21 
22   mapping(address => uint256) balances;
23 
24   uint256 totalSupply_;
25 
26   /**
27   * @dev Total number of tokens in existence
28   */
29   function totalSupply() public view returns (uint256) {
30     return totalSupply_;
31   }
32 
33   /**
34   * @dev Transfer token for a specified address
35   * @param _to The address to transfer to.
36   * @param _value The amount to be transferred.
37   */
38   function transfer(address _to, uint256 _value) public returns (bool) {
39     require(_to != address(0));
40     require(_value <= balances[msg.sender]);
41 
42     balances[msg.sender] = balances[msg.sender].sub(_value);
43     balances[_to] = balances[_to].add(_value);
44     emit Transfer(msg.sender, _to, _value);
45     return true;
46   }
47 
48   /**
49   * @dev Gets the balance of the specified address.
50   * @param _owner The address to query the the balance of.
51   * @return An uint256 representing the amount owned by the passed address.
52   */
53   function balanceOf(address _owner) public view returns (uint256) {
54     return balances[_owner];
55   }
56 
57 }
58 
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 is ERC20Basic {
65   function allowance(address owner, address spender)
66     public view returns (uint256);
67 
68   function transferFrom(address from, address to, uint256 value)
69     public returns (bool);
70 
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(
73     address indexed owner,
74     address indexed spender,
75     uint256 value
76   );
77 }
78 
79 
80 /**
81  * @title Standard ERC20 token
82  *
83  * @dev Implementation of the basic standard token.
84  * https://github.com/ethereum/EIPs/issues/20
85  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
86  */
87 contract StandardToken is ERC20, BasicToken {
88 
89   mapping (address => mapping (address => uint256)) internal allowed;
90 
91 
92   /**
93    * @dev Transfer tokens from one address to another
94    * @param _from address The address which you want to send tokens from
95    * @param _to address The address which you want to transfer to
96    * @param _value uint256 the amount of tokens to be transferred
97    */
98   function transferFrom(
99     address _from,
100     address _to,
101     uint256 _value
102   )
103     public
104     returns (bool)
105   {
106     require(_to != address(0));
107     require(_value <= balances[_from]);
108     require(_value <= allowed[_from][msg.sender]);
109 
110     balances[_from] = balances[_from].sub(_value);
111     balances[_to] = balances[_to].add(_value);
112     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
113     emit Transfer(_from, _to, _value);
114     return true;
115   }
116 
117   /**
118    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
119    * Beware that changing an allowance with this method brings the risk that someone may use both the old
120    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
121    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
122    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123    * @param _spender The address which will spend the funds.
124    * @param _value The amount of tokens to be spent.
125    */
126   function approve(address _spender, uint256 _value) public returns (bool) {
127     allowed[msg.sender][_spender] = _value;
128     emit Approval(msg.sender, _spender, _value);
129     return true;
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param _owner address The address which owns the funds.
135    * @param _spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address _owner,
140     address _spender
141    )
142     public
143     view
144     returns (uint256)
145   {
146     return allowed[_owner][_spender];
147   }
148 
149   /**
150    * @dev Increase the amount of tokens that an owner allowed to a spender.
151    * approve should be called when allowed[_spender] == 0. To increment
152    * allowed value is better to use this function to avoid 2 calls (and wait until
153    * the first transaction is mined)
154    * From MonolithDAO Token.sol
155    * @param _spender The address which will spend the funds.
156    * @param _addedValue The amount of tokens to increase the allowance by.
157    */
158   function increaseApproval(
159     address _spender,
160     uint256 _addedValue
161   )
162     public
163     returns (bool)
164   {
165     allowed[msg.sender][_spender] = (
166       allowed[msg.sender][_spender].add(_addedValue));
167     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
168     return true;
169   }
170 
171   /**
172    * @dev Decrease the amount of tokens that an owner allowed to a spender.
173    * approve should be called when allowed[_spender] == 0. To decrement
174    * allowed value is better to use this function to avoid 2 calls (and wait until
175    * the first transaction is mined)
176    * From MonolithDAO Token.sol
177    * @param _spender The address which will spend the funds.
178    * @param _subtractedValue The amount of tokens to decrease the allowance by.
179    */
180   function decreaseApproval(
181     address _spender,
182     uint256 _subtractedValue
183   )
184     public
185     returns (bool)
186   {
187     uint256 oldValue = allowed[msg.sender][_spender];
188     if (_subtractedValue > oldValue) {
189       allowed[msg.sender][_spender] = 0;
190     } else {
191       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192     }
193     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194     return true;
195   }
196 
197 }
198 
199 
200 /**
201  * @title Ownable
202  * @dev The Ownable contract has an owner address, and provides basic authorization control
203  * functions, this simplifies the implementation of "user permissions".
204  */
205 contract Ownable {
206   address public owner;
207 
208 
209   event OwnershipRenounced(address indexed previousOwner);
210   event OwnershipTransferred(
211     address indexed previousOwner,
212     address indexed newOwner
213   );
214 
215 
216   /**
217    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
218    * account.
219    */
220   constructor() public {
221     owner = msg.sender;
222   }
223 
224   /**
225    * @dev Throws if called by any account other than the owner.
226    */
227   modifier onlyOwner() {
228     require(msg.sender == owner);
229     _;
230   }
231 
232   /**
233    * @dev Allows the current owner to relinquish control of the contract.
234    * @notice Renouncing to ownership will leave the contract without an owner.
235    * It will not be possible to call the functions with the `onlyOwner`
236    * modifier anymore.
237    */
238   function renounceOwnership() public onlyOwner {
239     emit OwnershipRenounced(owner);
240     owner = address(0);
241   }
242 
243   /**
244    * @dev Allows the current owner to transfer control of the contract to a newOwner.
245    * @param _newOwner The address to transfer ownership to.
246    */
247   function transferOwnership(address _newOwner) public onlyOwner {
248     _transferOwnership(_newOwner);
249   }
250 
251   /**
252    * @dev Transfers control of the contract to a newOwner.
253    * @param _newOwner The address to transfer ownership to.
254    */
255   function _transferOwnership(address _newOwner) internal {
256     require(_newOwner != address(0));
257     emit OwnershipTransferred(owner, _newOwner);
258     owner = _newOwner;
259   }
260 }
261 
262 
263 /**
264  * @title SafeMath
265  * @dev Math operations with safety checks that throw on error
266  */
267 library SafeMath {
268 
269   /**
270   * @dev Multiplies two numbers, throws on overflow.
271   */
272   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
273     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
274     // benefit is lost if 'b' is also tested.
275     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
276     if (a == 0) {
277       return 0;
278     }
279 
280     c = a * b;
281     assert(c / a == b);
282     return c;
283   }
284 
285   /**
286   * @dev Integer division of two numbers, truncating the quotient.
287   */
288   function div(uint256 a, uint256 b) internal pure returns (uint256) {
289     // assert(b > 0); // Solidity automatically throws when dividing by 0
290     // uint256 c = a / b;
291     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
292     return a / b;
293   }
294 
295   /**
296   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
297   */
298   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
299     assert(b <= a);
300     return a - b;
301   }
302 
303   /**
304   * @dev Adds two numbers, throws on overflow.
305   */
306   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
307     c = a + b;
308     assert(c >= a);
309     return c;
310   }
311 }
312 
313 
314 contract SparksterToken is StandardToken, Ownable{
315 	using SafeMath for uint256;
316 	struct Member {
317 		mapping(uint256 => uint256) weiBalance; // How much wei has this member contributed for this group?
318 	}
319 
320 	struct Group {
321 		bool distributed; // Whether or not tokens in this group have been distributed.
322 		bool distributing; // This flag is set when we first enter the distribute function and is there to prevent race conditions, since distribution might take a long time.
323 		bool unlocked; // Whether or not tokens in this group have been unlocked.
324 		uint256 ratio; // 1 eth:ratio tokens. This amount represents the decimal amount. ratio*10**decimal = ratio sparks.
325 		uint256 startTime; // Epoch of crowdsale start time.
326 		uint256 phase1endTime; // Epoch of phase1 end time.
327 		uint256 phase2endTime; // Epoch of phase2 end time.
328 		uint256 deadline; // No contributions allowed after this epoch.
329 		uint256 max2; // cap of phase2
330 		uint256 max3; // Total ether this group can collect in phase 3.
331 		uint256 weiTotal; // How much ether has this group collected?
332 		uint256 cap; // The hard ether cap.
333 	}
334 
335 	address oracleAddress;
336 	bool public transferLock = true; // A Global transfer lock. Set to lock down all tokens from all groups.
337 	bool public allowedToBuyBack = false;
338 	bool public allowedToPurchase = false;
339 	string public name;									 // name for display
340 	string public symbol;								 //An identifier
341 	uint8 public decimals;							//How many decimals to show.
342 	uint256 public penalty;
343 	uint256 public maxGasPrice; // The maximum allowed gas for the purchase function.
344 	uint256 internal nextGroupNumber;
345 	uint256 public sellPrice; // sellPrice wei:1 spark token; we won't allow to sell back parts of a token.
346 	mapping(address => Member) internal members;
347 	mapping(uint256 => Group) internal groups;
348 	uint256 public openGroupNumber;
349 	event WantsToPurchase(address walletAddress, uint256 weiAmount, uint256 groupNumber, bool inPhase1);
350 	event PurchasedCallbackOnAccept(uint256 groupNumber, address[] addresses);
351 	event WantsToDistribute(uint256 groupNumber);
352 	event NearingHardCap(uint256 groupNumber, uint256 remainder);
353 	event ReachedHardCap(uint256 groupNumber);
354 	event DistributeDone(uint256 groupNumber);
355 	event DistributedBatch(uint256 groupNumber, address[] addresses);
356 	event AirdroppedBatch(address[] addresses);
357 	event RefundedBatch(address[] addresses);
358 	event AddToGroup(address walletAddress, uint256 groupNumber);
359 	event ChangedTransferLock(bool transferLock);
360 	event ChangedAllowedToPurchase(bool allowedToPurchase);
361 	event ChangedAllowedToBuyBack(bool allowedToBuyBack);
362 	event SetSellPrice(uint256 sellPrice);
363 	
364 	modifier onlyOwnerOrOracle() {
365 		require(msg.sender == owner || msg.sender == oracleAddress);
366 		_;
367 	}
368 	
369 	// Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
370 	modifier onlyPayloadSize(uint size) {	 
371 		require(msg.data.length == size + 4);
372 		_;
373 	}
374 
375 	modifier canTransfer() {
376 		if (msg.sender != owner) {
377 			require(!transferLock);
378 		}
379 		_;
380 	}
381 
382 	modifier canPurchase() {
383 		require(allowedToPurchase);
384 		_;
385 	}
386 
387 	modifier canSell() {
388 		require(allowedToBuyBack);
389 		_;
390 	}
391 
392 	function() public payable {
393 		purchase();
394 	}
395 
396 	constructor() public {
397 		name = "Sparkster";									// Set the name for display purposes
398 		decimals = 18;					 // Amount of decimals for display purposes
399 		symbol = "SPRK";							// Set the symbol for display purposes
400 		setMaximumGasPrice(40);
401 		mintTokens(435000000);
402 	}
403 	
404 	function setOracleAddress(address newAddress) public onlyOwner returns(bool success) {
405 		oracleAddress = newAddress;
406 		return true;
407 	}
408 
409 	function removeOracleAddress() public onlyOwner {
410 		oracleAddress = address(0);
411 	}
412 
413 	function setMaximumGasPrice(uint256 gweiPrice) public onlyOwner returns(bool success) {
414 		maxGasPrice = gweiPrice.mul(10**9); // Convert the gwei value to wei.
415 		return true;
416 	}
417 
418 	function mintTokens(uint256 amount) public onlyOwner {
419 		// Here, we'll consider amount to be the full token amount, so we have to get its decimal value.
420 		uint256 decimalAmount = amount.mul(uint(10)**decimals);
421 		totalSupply_ = totalSupply_.add(decimalAmount);
422 		balances[msg.sender] = balances[msg.sender].add(decimalAmount);
423 		emit Transfer(address(0), msg.sender, decimalAmount); // Per erc20 standards-compliance.
424 	}
425 
426 	function purchase() public canPurchase payable returns(bool success) {
427 		require(msg.sender != address(0)); // Don't allow the 0 address.
428 		Member storage memberRecord = members[msg.sender];
429 		Group storage openGroup = groups[openGroupNumber];
430 		require(openGroup.ratio > 0); // Group must be initialized.
431 		uint256 currentTimestamp = block.timestamp;
432 		require(currentTimestamp >= openGroup.startTime && currentTimestamp <= openGroup.deadline);																 //the timestamp must be greater than or equal to the start time and less than or equal to the deadline time
433 		require(!openGroup.distributing && !openGroup.distributed); // Don't allow to purchase if we're in the middle of distributing this group; Don't let someone buy tokens on the current group if that group is already distributed.
434 		require(tx.gasprice <= maxGasPrice); // Restrict maximum gas this transaction is allowed to consume.
435 		uint256 weiAmount = msg.value;																		// The amount purchased by the current member
436 		require(weiAmount >= 0.1 ether);
437 		uint256 weiTotal = openGroup.weiTotal.add(weiAmount); // Calculate total contribution of all members in this group.
438 		require(weiTotal <= openGroup.cap);														// Check to see if accepting these funds will put us above the hard ether cap.
439 		uint256 userWeiTotal = memberRecord.weiBalance[openGroupNumber].add(weiAmount);	// Calculate the total amount purchased by the current member
440 		if(currentTimestamp <= openGroup.phase1endTime){																			 // whether the current timestamp is in the first phase
441 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, true);
442 			return true;
443 		} else if (currentTimestamp <= openGroup.phase2endTime) { // Are we in phase 2?
444 			require(userWeiTotal <= openGroup.max2); // Allow to contribute no more than max2 in phase 2.
445 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, false);
446 			return true;
447 		} else { // We've passed both phases 1 and 2.
448 			require(userWeiTotal <= openGroup.max3); // Don't allow to contribute more than max3 in phase 3.
449 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, false);
450 			return true;
451 		}
452 	}
453 	
454 	function purchaseCallbackOnAccept(uint256 groupNumber, address[] addresses, uint256[] weiAmounts) public onlyOwnerOrOracle returns(bool success) {
455 		uint256 n = addresses.length;
456 		require(n == weiAmounts.length, "Array lengths mismatch");
457 		Group storage theGroup = groups[groupNumber];
458 		uint256 weiTotal = theGroup.weiTotal;
459 		for (uint256 i = 0; i < n; i++) {
460 			Member storage memberRecord = members[addresses[i]];
461 			uint256 weiAmount = weiAmounts[i];
462 			weiTotal = weiTotal.add(weiAmount);								 // Calculate the total amount purchased by all members in this group.
463 			memberRecord.weiBalance[groupNumber] = memberRecord.weiBalance[groupNumber].add(weiAmount);														 // Record the total amount purchased by the current member
464 		}
465 		theGroup.weiTotal = weiTotal;
466 		if (getHowMuchUntilHardCap_(groupNumber) <= 100 ether) {
467 			emit NearingHardCap(groupNumber, getHowMuchUntilHardCap_(groupNumber));
468 			if (weiTotal >= theGroup.cap) {
469 				emit ReachedHardCap(groupNumber);
470 			}
471 		}
472 		emit PurchasedCallbackOnAccept(groupNumber, addresses);
473 		return true;
474 	}
475 
476 	function purchaseCallbackOnAcceptAndDistribute(uint256 groupNumber, address[] addresses, uint256[] weiAmounts) public onlyOwnerOrOracle returns(bool success) {
477 		uint256 n = addresses.length;
478 		require(n == weiAmounts.length, "Array lengths mismatch");
479 		Group storage theGroup = groups[groupNumber];
480 		if (!theGroup.distributing) {
481 			theGroup.distributing = true;
482 		}
483 		uint256 newOwnerSupply = balances[owner];
484 		for (uint256 i = 0; i < n; i++) {
485 			address theAddress = addresses[i];
486 			Member storage memberRecord = members[theAddress];
487 			uint256 weiAmount = weiAmounts[i];
488 			memberRecord.weiBalance[groupNumber] = memberRecord.weiBalance[groupNumber].add(weiAmount);														 // Record the total amount purchased by the current member
489 			uint256 balance = getUndistributedBalanceOf_(theAddress, groupNumber);
490 			if (balance > 0) { // No need to waste ticks if they have no tokens to distribute
491 				balances[theAddress] = balances[theAddress].add(balance);
492 				newOwnerSupply = newOwnerSupply.sub(balance); // Update the available number of tokens.
493 				emit Transfer(owner, theAddress, balance); // Notify exchanges of the distribution.
494 			}
495 		}
496 		balances[owner] = newOwnerSupply;
497 		emit PurchasedCallbackOnAccept(groupNumber, addresses);
498 		return true;
499 	}
500 
501 	function refund(address[] addresses, uint256[] weiAmounts) public onlyOwnerOrOracle returns(bool success) {
502 		uint256 n = addresses.length;
503 		require (n == weiAmounts.length, "Array lengths mismatch");
504 		uint256 thePenalty = penalty;
505 		for(uint256 i = 0; i < n; i++) {
506 			uint256 weiAmount = weiAmounts[i];
507 			address theAddress = addresses[i];
508 			if (thePenalty <= weiAmount) {
509 				weiAmount = weiAmount.sub(thePenalty);
510 				require(address(this).balance >= weiAmount);
511 				theAddress.transfer(weiAmount);
512 			}
513 		}
514 		emit RefundedBatch(addresses);
515 		return true;
516 	}
517 
518 	function signalDoneDistributing(uint256 groupNumber) public onlyOwnerOrOracle {
519 		Group storage theGroup = groups[groupNumber];
520 		theGroup.distributed = true;
521 		theGroup.distributing = false;
522 		emit DistributeDone(groupNumber);
523 	}
524 	
525 	function drain() public onlyOwner {
526 		owner.transfer(address(this).balance);
527 	}
528 	
529 	function setPenalty(uint256 newPenalty) public onlyOwner returns(bool success) {
530 		penalty = newPenalty;
531 		return true;
532 	}
533 	
534 	function buyback(uint256 amount) public canSell { // Can't sell unless owner has allowed it.
535 		uint256 decimalAmount = amount.mul(uint(10)**decimals); // convert the full token value to the smallest unit possible.
536 		require(balances[msg.sender].sub(decimalAmount) >= getLockedTokens_(msg.sender)); // Don't allow to sell locked tokens.
537 		balances[msg.sender] = balances[msg.sender].sub(decimalAmount); // Do this before transferring to avoid re-entrance attacks; will throw if result < 0.
538 		// Amount is considered to be how many full tokens the user wants to sell.
539 		uint256 totalCost = amount.mul(sellPrice); // sellPrice is the per-full-token value.
540 		require(address(this).balance >= totalCost); // The contract must have enough funds to cover the selling.
541 		balances[owner] = balances[owner].add(decimalAmount); // Put these tokens back into the available pile.
542 		msg.sender.transfer(totalCost); // Pay the seller for their tokens.
543 		emit Transfer(msg.sender, owner, decimalAmount); // Notify exchanges of the sell.
544 	}
545 
546 	function fundContract() public onlyOwnerOrOracle payable { // For the owner to put funds into the contract.
547 	}
548 
549 	function setSellPrice(uint256 thePrice) public onlyOwner {
550 		sellPrice = thePrice;
551 	}
552 	
553 	function setAllowedToBuyBack(bool value) public onlyOwner {
554 		allowedToBuyBack = value;
555 		emit ChangedAllowedToBuyBack(value);
556 	}
557 
558 	function setAllowedToPurchase(bool value) public onlyOwner {
559 		allowedToPurchase = value;
560 		emit ChangedAllowedToPurchase(value);
561 	}
562 	
563 	function createGroup(uint256 startEpoch, uint256 phase1endEpoch, uint256 phase2endEpoch, uint256 deadlineEpoch, uint256 phase2weiCap, uint256 phase3weiCap, uint256 hardWeiCap, uint256 ratio) public onlyOwner returns (bool success, uint256 createdGroupNumber) {
564 		createdGroupNumber = nextGroupNumber;
565 		Group storage theGroup = groups[createdGroupNumber];
566 		theGroup.startTime = startEpoch;
567 		theGroup.phase1endTime = phase1endEpoch;
568 		theGroup.phase2endTime = phase2endEpoch;
569 		theGroup.deadline = deadlineEpoch;
570 		theGroup.max2 = phase2weiCap;
571 		theGroup.max3 = phase3weiCap;
572 		theGroup.cap = hardWeiCap;
573 		theGroup.ratio = ratio;
574 		nextGroupNumber++;
575 		success = true;
576 	}
577 
578 	function createGroup() public onlyOwner returns (bool success, uint256 createdGroupNumber) {
579 		return createGroup(0, 0, 0, 0, 0, 0, 0, 0);
580 	}
581 
582 	function getGroup(uint256 groupNumber) public view returns(bool distributed, bool distributing, bool unlocked, uint256 phase2cap, uint256 phase3cap, uint256 cap, uint256 ratio, uint256 startTime, uint256 phase1endTime, uint256 phase2endTime, uint256 deadline, uint256 weiTotal) {
583 		require(groupNumber < nextGroupNumber);
584 		Group storage theGroup = groups[groupNumber];
585 		distributed = theGroup.distributed;
586 		distributing = theGroup.distributing;
587 		unlocked = theGroup.unlocked;
588 		phase2cap = theGroup.max2;
589 		phase3cap = theGroup.max3;
590 		cap = theGroup.cap;
591 		ratio = theGroup.ratio;
592 		startTime = theGroup.startTime;
593 		phase1endTime = theGroup.phase1endTime;
594 		phase2endTime = theGroup.phase2endTime;
595 		deadline = theGroup.deadline;
596 		weiTotal = theGroup.weiTotal;
597 	}
598 	
599 	function getHowMuchUntilHardCap_(uint256 groupNumber) internal view returns(uint256 remainder) {
600 		Group storage theGroup = groups[groupNumber];
601 		if (theGroup.weiTotal > theGroup.cap) { // calling .sub in this situation will throw.
602 			return 0;
603 		}
604 		return theGroup.cap.sub(theGroup.weiTotal);
605 	}
606 	
607 	function getHowMuchUntilHardCap() public view returns(uint256 remainder) {
608 		return getHowMuchUntilHardCap_(openGroupNumber);
609 	}
610 
611 	function addMemberToGroup(address walletAddress, uint256 groupNumber) public onlyOwner returns(bool success) {
612 		emit AddToGroup(walletAddress, groupNumber);
613 		return true;
614 	}
615 	
616 	function instructOracleToDistribute(uint256 groupNumber) public onlyOwner {
617 		Group storage theGroup = groups[groupNumber];
618 		require(groupNumber < nextGroupNumber && !theGroup.distributed); // can't have already distributed
619 		emit WantsToDistribute(groupNumber);
620 	}
621 	
622 	function distributeCallback(uint256 groupNumber, address[] addresses) public onlyOwnerOrOracle returns (bool success) {
623 		Group storage theGroup = groups[groupNumber];
624 		if (!theGroup.distributing) {
625 			theGroup.distributing = true;
626 		}
627 		uint256 n = addresses.length;
628 		uint256 newOwnerBalance = balances[owner];
629 		for (uint256 i = 0; i < n; i++) {
630 			address memberAddress = addresses[i];
631 			uint256 balance = getUndistributedBalanceOf_(memberAddress, groupNumber);
632 			if (balance > 0) { // No need to waste ticks if they have no tokens to distribute
633 				balances[memberAddress] = balances[memberAddress].add(balance);
634 				newOwnerBalance = newOwnerBalance.sub(balance); // Deduct from owner.
635 				emit Transfer(owner, memberAddress, balance); // Notify exchanges of the distribution.
636 			}
637 		}
638 		balances[owner] = newOwnerBalance;
639 		emit DistributedBatch(groupNumber, addresses);
640 		return true;
641 	}
642 
643 	function unlock(uint256 groupNumber) public onlyOwner returns (bool success) {
644 		Group storage theGroup = groups[groupNumber];
645 		require(theGroup.distributed); // Distribution must have occurred first.
646 		theGroup.unlocked = true;
647 		return true;
648 	}
649 	
650 	function setGlobalLock(bool value) public onlyOwner {
651 		transferLock = value;
652 		emit ChangedTransferLock(transferLock);
653 	}
654 	
655 	function burn(uint256 amount) public onlyOwner {
656 		// Burns tokens from the owner's supply and doesn't touch allocated tokens.
657 		// Decrease totalSupply and leftOver by the amount to burn so we can decrease the circulation.
658 		balances[msg.sender] = balances[msg.sender].sub(amount); // Will throw if result < 0
659 		totalSupply_ = totalSupply_.sub(amount); // Will throw if result < 0
660 		emit Transfer(msg.sender, address(0), amount);
661 	}
662 	
663 	function splitTokensBeforeDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
664 		// SplitFactor is the multiplier per decimal of spark. splitFactor * 10**decimals = splitFactor sparks
665 		uint256 ownerBalance = balances[msg.sender];
666 		uint256 multiplier = ownerBalance.mul(splitFactor);
667 		uint256 increaseSupplyBy = multiplier.sub(ownerBalance); // We need to mint owner*splitFactor - owner additional tokens.
668 		balances[msg.sender] = multiplier;
669 		totalSupply_ = totalSupply_.mul(splitFactor);
670 		emit Transfer(address(0), msg.sender, increaseSupplyBy); // Notify exchange that we've minted tokens.
671 		// Next, increase group ratios by splitFactor, so users will receive ratio * splitFactor tokens per ether.
672 		uint256 n = nextGroupNumber;
673 		require(n > 0); // Must have at least one group.
674 		for (uint256 i = 0; i < n; i++) {
675 			Group storage currentGroup = groups[i];
676 			currentGroup.ratio = currentGroup.ratio.mul(splitFactor);
677 		}
678 		return true;
679 	}
680 
681 	function reverseSplitTokensBeforeDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
682 		// SplitFactor is the multiplier per decimal of spark. splitFactor * 10**decimals = splitFactor sparks
683 		uint256 ownerBalance = balances[msg.sender];
684 		uint256 divier = ownerBalance.div(splitFactor);
685 		uint256 decreaseSupplyBy = ownerBalance.sub(divier);
686 		// We don't use burnTokens here since the amount to subtract might be more than what the owner currently holds in their unallocated supply which will cause the function to throw.
687 		totalSupply_ = totalSupply_.div(splitFactor);
688 		balances[msg.sender] = divier;
689 		// Notify the exchanges of how many tokens were burned.
690 		emit Transfer(msg.sender, address(0), decreaseSupplyBy);
691 		// Next, decrease group ratios by splitFactor, so users will receive ratio / splitFactor tokens per ether.
692 		uint256 n = nextGroupNumber;
693 		require(n > 0); // Must have at least one group. Groups are 0-indexed.
694 		for (uint256 i = 0; i < n; i++) {
695 			Group storage currentGroup = groups[i];
696 			currentGroup.ratio = currentGroup.ratio.div(splitFactor);
697 		}
698 		return true;
699 	}
700 
701 	function airdrop( address[] addresses, uint256[] tokenDecimalAmounts) public onlyOwnerOrOracle returns (bool success) {
702 		uint256 n = addresses.length;
703 		require(n == tokenDecimalAmounts.length, "Array lengths mismatch");
704 		uint256 newOwnerBalance = balances[owner];
705 		for (uint256 i = 0; i < n; i++) {
706 			address theAddress = addresses[i];
707 			uint256 airdropAmount = tokenDecimalAmounts[i];
708 			if (airdropAmount > 0) {
709 				uint256 currentBalance = balances[theAddress];
710 				balances[theAddress] = currentBalance.add(airdropAmount);
711 				newOwnerBalance = newOwnerBalance.sub(airdropAmount);
712 				emit Transfer(owner, theAddress, airdropAmount);
713 			}
714 		}
715 		balances[owner] = newOwnerBalance;
716 		emit AirdroppedBatch(addresses);
717 		return true;
718 	}
719 
720 	function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) canTransfer returns (bool success) {		
721 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
722 		if (msg.sender != owner) { // Owner can transfer anything to anyone.
723 			require(balances[msg.sender].sub(_value) >= getLockedTokens_(msg.sender));
724 		}
725 		return super.transfer(_to, _value);
726 	}
727 
728 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) canTransfer returns (bool success) {
729 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
730 		if (msg.sender != owner) { // Owner not affected by locked tokens
731 			require(balances[_from].sub(_value) >= getLockedTokens_(_from));
732 		}
733 		return super.transferFrom(_from, _to, _value);
734 	}
735 
736 	function setOpenGroup(uint256 groupNumber) public onlyOwner returns (bool success) {
737 		require(groupNumber < nextGroupNumber);
738 		openGroupNumber = groupNumber;
739 		return true;
740 	}
741 
742 	function getLockedTokensInGroup_(address walletAddress, uint256 groupNumber) internal view returns (uint256 balance) {
743 		Member storage theMember = members[walletAddress];
744 		if (groups[groupNumber].unlocked) {
745 			return 0;
746 		}
747 		return theMember.weiBalance[groupNumber].mul(groups[groupNumber].ratio);
748 	}
749 
750 	function getLockedTokens_(address walletAddress) internal view returns(uint256 balance) {
751 		uint256 n = nextGroupNumber;
752 		for (uint256 i = 0; i < n; i++) {
753 			balance = balance.add(getLockedTokensInGroup_(walletAddress, i));
754 		}
755 		return balance;
756 	}
757 
758 	function getLockedTokens(address walletAddress) public view returns(uint256 balance) {
759 		return getLockedTokens_(walletAddress);
760 	}
761 
762 	function getUndistributedBalanceOf_(address walletAddress, uint256 groupNumber) internal view returns (uint256 balance) {
763 		Member storage theMember = members[walletAddress];
764 		Group storage theGroup = groups[groupNumber];
765 		if (theGroup.distributed) {
766 			return 0;
767 		}
768 		return theMember.weiBalance[groupNumber].mul(theGroup.ratio);
769 	}
770 
771 	function getUndistributedBalanceOf(address walletAddress, uint256 groupNumber) public view returns (uint256 balance) {
772 		return getUndistributedBalanceOf_(walletAddress, groupNumber);
773 	}
774 
775 	function checkMyUndistributedBalance(uint256 groupNumber) public view returns (uint256 balance) {
776 		return getUndistributedBalanceOf_(msg.sender, groupNumber);
777 	}
778 
779 	function transferRecovery(address _from, address _to, uint256 _value) public onlyOwner returns (bool success) {
780 		// Will be used if someone sends tokens to an incorrect address by accident. This way, we have the ability to recover the tokens. For example, sometimes there's a problem of lost tokens if someone sends tokens to a contract address that can't utilize the tokens.
781 		allowed[_from][msg.sender] = allowed[_from][msg.sender].add(_value); // Authorize the owner to spend on someone's behalf.
782 		return transferFrom(_from, _to, _value);
783 	}
784 }