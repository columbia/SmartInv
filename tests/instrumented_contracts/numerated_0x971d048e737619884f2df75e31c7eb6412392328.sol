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
324 		mapping(address => bool) exists; // If exists[address] is true, this address has made a purchase on this group before.
325 		string name;
326 		uint256 ratio; // 1 eth:ratio tokens. This amount represents the decimal amount. ratio*10**decimal = ratio sparks.
327 		uint256 startTime; // Epoch of crowdsale start time.
328 		uint256 phase1endTime; // Epoch of phase1 end time.
329 		uint256 phase2endTime; // Epoch of phase2 end time.
330 		uint256 deadline; // No contributions allowed after this epoch.
331 		uint256 max2; // cap of phase2
332 		uint256 max3; // Total ether this group can collect in phase 3.
333 		uint256 weiTotal; // How much ether has this group collected?
334 		uint256 cap; // The hard ether cap.
335 		uint256 nextDistributionIndex; // The next index to start distributing at.
336 		address[] addresses; // List of addresses that have made a purchase on this group.
337 	}
338 
339 	address oracleAddress;
340 	bool public transferLock = true; // A Global transfer lock. Set to lock down all tokens from all groups.
341 	bool public allowedToBuyBack = false;
342 	bool public allowedToPurchase = false;
343 	string public name;									 // name for display
344 	string public symbol;								 //An identifier
345 	uint8 public decimals;							//How many decimals to show.
346 	uint256 public penalty;
347 	uint256 public maxGasPrice; // The maximum allowed gas for the purchase function.
348 	uint256 internal nextGroupNumber;
349 	uint256 public sellPrice; // sellPrice wei:1 spark token; we won't allow to sell back parts of a token.
350 	mapping(address => Member) internal members;
351 	mapping(uint256 => Group) internal groups;
352 	uint256 public openGroupNumber;
353 	event WantsToPurchase(address walletAddress, uint256 weiAmount, uint256 groupNumber, bool inPhase1);
354 	event PurchasedCallbackOnAccept(uint256 groupNumber, address[] addresses);
355 	event WantsToDistribute(uint256 groupNumber);
356 	event NearingHardCap(uint256 groupNumber, uint256 remainder);
357 	event ReachedHardCap(uint256 groupNumber);
358 	event DistributeDone(uint256 groupNumber);
359 	event DistributedBatch(uint256 groupNumber, uint256 howMany);
360 	event AirdroppedBatch(address[] addresses);
361 	event RefundedBatch(address[] addresses);
362 	event AddToGroup(address walletAddress, uint256 groupNumber);
363 	event ChangedTransferLock(bool transferLock);
364 	event ChangedAllowedToPurchase(bool allowedToPurchase);
365 	event ChangedAllowedToBuyBack(bool allowedToBuyBack);
366 	event SetSellPrice(uint256 sellPrice);
367 	
368 	modifier onlyOwnerOrOracle() {
369 		require(msg.sender == owner || msg.sender == oracleAddress);
370 		_;
371 	}
372 	
373 	// Fix for the ERC20 short address attack http://vessenes.com/the-erc20-short-address-attack-explained/
374 	modifier onlyPayloadSize(uint size) {	 
375 		require(msg.data.length == size + 4);
376 		_;
377 	}
378 
379 	modifier canTransfer() {
380 		if (msg.sender != owner) {
381 			require(!transferLock);
382 		}
383 		_;
384 	}
385 
386 	modifier canPurchase() {
387 		require(allowedToPurchase);
388 		_;
389 	}
390 
391 	modifier canSell() {
392 		require(allowedToBuyBack);
393 		_;
394 	}
395 
396 	function() public payable {
397 		purchase();
398 	}
399 
400 	constructor() public {
401 		name = "Sparkster";									// Set the name for display purposes
402 		decimals = 18;					 // Amount of decimals for display purposes
403 		symbol = "SPRK";							// Set the symbol for display purposes
404 		setMaximumGasPrice(40);
405 		mintTokens(435000000);
406 	}
407 	
408 	function setOracleAddress(address newAddress) public onlyOwner returns(bool success) {
409 		oracleAddress = newAddress;
410 		return true;
411 	}
412 
413 	function removeOracleAddress() public onlyOwner {
414 		oracleAddress = address(0);
415 	}
416 
417 	function setMaximumGasPrice(uint256 gweiPrice) public onlyOwner returns(bool success) {
418 		maxGasPrice = gweiPrice.mul(10**9); // Convert the gwei value to wei.
419 		return true;
420 	}
421 
422 	function mintTokens(uint256 amount) public onlyOwner {
423 		// Here, we'll consider amount to be the full token amount, so we have to get its decimal value.
424 		uint256 decimalAmount = amount.mul(uint(10)**decimals);
425 		totalSupply_ = totalSupply_.add(decimalAmount);
426 		balances[msg.sender] = balances[msg.sender].add(decimalAmount);
427 		emit Transfer(address(0), msg.sender, decimalAmount); // Per erc20 standards-compliance.
428 	}
429 
430 	function purchase() public canPurchase payable returns(bool success) {
431 		require(msg.sender != address(0)); // Don't allow the 0 address.
432 		Member storage memberRecord = members[msg.sender];
433 		Group storage openGroup = groups[openGroupNumber];
434 		require(openGroup.ratio > 0); // Group must be initialized.
435 		uint256 currentTimestamp = block.timestamp;
436 		require(currentTimestamp >= openGroup.startTime && currentTimestamp <= openGroup.deadline);																 //the timestamp must be greater than or equal to the start time and less than or equal to the deadline time
437 		require(!openGroup.distributing && !openGroup.distributed); // Don't allow to purchase if we're in the middle of distributing this group; Don't let someone buy tokens on the current group if that group is already distributed.
438 		require(tx.gasprice <= maxGasPrice); // Restrict maximum gas this transaction is allowed to consume.
439 		uint256 weiAmount = msg.value;																		// The amount purchased by the current member
440 		require(weiAmount >= 0.1 ether);
441 		uint256 weiTotal = openGroup.weiTotal.add(weiAmount); // Calculate total contribution of all members in this group.
442 		require(weiTotal <= openGroup.cap);														// Check to see if accepting these funds will put us above the hard ether cap.
443 		uint256 userWeiTotal = memberRecord.weiBalance[openGroupNumber].add(weiAmount);	// Calculate the total amount purchased by the current member
444 		if (!openGroup.exists[msg.sender]) { // Has this person not purchased on this group before?
445 			openGroup.addresses.push(msg.sender);
446 			openGroup.exists[msg.sender] = true;
447 		}
448 		if(currentTimestamp <= openGroup.phase1endTime){																			 // whether the current timestamp is in the first phase
449 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, true);
450 			return true;
451 		} else if (currentTimestamp <= openGroup.phase2endTime) { // Are we in phase 2?
452 			require(userWeiTotal <= openGroup.max2); // Allow to contribute no more than max2 in phase 2.
453 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, false);
454 			return true;
455 		} else { // We've passed both phases 1 and 2.
456 			require(userWeiTotal <= openGroup.max3); // Don't allow to contribute more than max3 in phase 3.
457 			emit WantsToPurchase(msg.sender, weiAmount, openGroupNumber, false);
458 			return true;
459 		}
460 	}
461 	
462 	function purchaseCallbackOnAccept(uint256 groupNumber, address[] addresses, uint256[] weiAmounts) public onlyOwnerOrOracle returns(bool success) {
463 		uint256 n = addresses.length;
464 		require(n == weiAmounts.length, "Array lengths mismatch");
465 		Group storage theGroup = groups[groupNumber];
466 		uint256 weiTotal = theGroup.weiTotal;
467 		for (uint256 i = 0; i < n; i++) {
468 			Member storage memberRecord = members[addresses[i]];
469 			uint256 weiAmount = weiAmounts[i];
470 			weiTotal = weiTotal.add(weiAmount);								 // Calculate the total amount purchased by all members in this group.
471 			memberRecord.weiBalance[groupNumber] = memberRecord.weiBalance[groupNumber].add(weiAmount);														 // Record the total amount purchased by the current member
472 		}
473 		theGroup.weiTotal = weiTotal;
474 		if (getHowMuchUntilHardCap_(groupNumber) <= 100 ether) {
475 			emit NearingHardCap(groupNumber, getHowMuchUntilHardCap_(groupNumber));
476 			if (weiTotal >= theGroup.cap) {
477 				emit ReachedHardCap(groupNumber);
478 			}
479 		}
480 		emit PurchasedCallbackOnAccept(groupNumber, addresses);
481 		return true;
482 	}
483 
484 	function insertAndApprove(uint256 groupNumber, address[] addresses, uint256[] weiAmounts) public onlyOwnerOrOracle returns(bool success) {
485 		uint256 n = addresses.length;
486 		require(n == weiAmounts.length, "Array lengtsh mismatch");
487 		Group storage theGroup = groups[groupNumber];
488 		for (uint256 i = 0; i < n; i++) {
489 			address theAddress = addresses[i];
490 			if (!theGroup.exists[theAddress]) {
491 				theGroup.addresses.push(theAddress);
492 				theGroup.exists[theAddress] = true;
493 			}
494 		}
495 		return purchaseCallbackOnAccept(groupNumber, addresses, weiAmounts);
496 	}
497 
498 	function callbackInsertApproveAndDistribute(uint256 groupNumber, address[] addresses, uint256[] weiAmounts) public onlyOwnerOrOracle returns(bool success) {
499 		uint256 n = addresses.length;
500 		require(n == weiAmounts.length, "Array lengths mismatch");
501 		Group storage theGroup = groups[groupNumber];
502 		if (!theGroup.distributing) {
503 			theGroup.distributing = true;
504 		}
505 		uint256 newOwnerSupply = balances[owner];
506 		for (uint256 i = 0; i < n; i++) {
507 			address theAddress = addresses[i];
508 			Member storage memberRecord = members[theAddress];
509 			uint256 weiAmount = weiAmounts[i];
510 			memberRecord.weiBalance[groupNumber] = memberRecord.weiBalance[groupNumber].add(weiAmount);														 // Record the total amount purchased by the current member
511 			uint256 additionalBalance = weiAmount.mul(theGroup.ratio); // Don't give cumulative tokens; one address can be distributed multiple times.
512 			if (additionalBalance > 0) { // No need to waste ticks if they have no tokens to distribute
513 				balances[theAddress] = balances[theAddress].add(additionalBalance);
514 				newOwnerSupply = newOwnerSupply.sub(additionalBalance); // Update the available number of tokens.
515 				emit Transfer(owner, theAddress, additionalBalance); // Notify exchanges of the distribution.
516 			}
517 		}
518 		balances[owner] = newOwnerSupply;
519 		emit PurchasedCallbackOnAccept(groupNumber, addresses);
520 		return true;
521 	}
522 
523 	function refund(address[] addresses, uint256[] weiAmounts) public onlyOwnerOrOracle returns(bool success) {
524 		uint256 n = addresses.length;
525 		require (n == weiAmounts.length, "Array lengths mismatch");
526 		uint256 thePenalty = penalty;
527 		for(uint256 i = 0; i < n; i++) {
528 			uint256 weiAmount = weiAmounts[i];
529 			address theAddress = addresses[i];
530 			if (thePenalty <= weiAmount) {
531 				weiAmount = weiAmount.sub(thePenalty);
532 				require(address(this).balance >= weiAmount);
533 				theAddress.transfer(weiAmount);
534 			}
535 		}
536 		emit RefundedBatch(addresses);
537 		return true;
538 	}
539 
540 	function signalDoneDistributing(uint256 groupNumber) public onlyOwnerOrOracle {
541 		Group storage theGroup = groups[groupNumber];
542 		theGroup.distributed = true;
543 		theGroup.distributing = false;
544 		emit DistributeDone(groupNumber);
545 	}
546 	
547 	function drain() public onlyOwner {
548 		owner.transfer(address(this).balance);
549 	}
550 	
551 	function setPenalty(uint256 newPenalty) public onlyOwner returns(bool success) {
552 		penalty = newPenalty;
553 		return true;
554 	}
555 	
556 	function buyback(uint256 amount) public canSell { // Can't sell unless owner has allowed it.
557 		uint256 decimalAmount = amount.mul(uint(10)**decimals); // convert the full token value to the smallest unit possible.
558 		require(balances[msg.sender].sub(decimalAmount) >= getLockedTokens_(msg.sender)); // Don't allow to sell locked tokens.
559 		balances[msg.sender] = balances[msg.sender].sub(decimalAmount); // Do this before transferring to avoid re-entrance attacks; will throw if result < 0.
560 		// Amount is considered to be how many full tokens the user wants to sell.
561 		uint256 totalCost = amount.mul(sellPrice); // sellPrice is the per-full-token value.
562 		require(address(this).balance >= totalCost); // The contract must have enough funds to cover the selling.
563 		balances[owner] = balances[owner].add(decimalAmount); // Put these tokens back into the available pile.
564 		msg.sender.transfer(totalCost); // Pay the seller for their tokens.
565 		emit Transfer(msg.sender, owner, decimalAmount); // Notify exchanges of the sell.
566 	}
567 
568 	function fundContract() public onlyOwnerOrOracle payable { // For the owner to put funds into the contract.
569 	}
570 
571 	function setSellPrice(uint256 thePrice) public onlyOwner {
572 		sellPrice = thePrice;
573 	}
574 	
575 	function setAllowedToBuyBack(bool value) public onlyOwner {
576 		allowedToBuyBack = value;
577 		emit ChangedAllowedToBuyBack(value);
578 	}
579 
580 	function setAllowedToPurchase(bool value) public onlyOwner {
581 		allowedToPurchase = value;
582 		emit ChangedAllowedToPurchase(value);
583 	}
584 	
585 	function createGroup(string groupName, uint256 startEpoch, uint256 phase1endEpoch, uint256 phase2endEpoch, uint256 deadlineEpoch, uint256 phase2weiCap, uint256 phase3weiCap, uint256 hardWeiCap, uint256 ratio) public onlyOwner returns (bool success, uint256 createdGroupNumber) {
586 		createdGroupNumber = nextGroupNumber;
587 		Group storage theGroup = groups[createdGroupNumber];
588 		theGroup.name = groupName;
589 		theGroup.startTime = startEpoch;
590 		theGroup.phase1endTime = phase1endEpoch;
591 		theGroup.phase2endTime = phase2endEpoch;
592 		theGroup.deadline = deadlineEpoch;
593 		theGroup.max2 = phase2weiCap;
594 		theGroup.max3 = phase3weiCap;
595 		theGroup.cap = hardWeiCap;
596 		theGroup.ratio = ratio;
597 		nextGroupNumber++;
598 		success = true;
599 	}
600 
601 	function getGroup(uint256 groupNumber) public view returns(string groupName, bool distributed, bool unlocked, uint256 phase2cap, uint256 phase3cap, uint256 cap, uint256 ratio, uint256 startTime, uint256 phase1endTime, uint256 phase2endTime, uint256 deadline, uint256 weiTotal) {
602 		require(groupNumber < nextGroupNumber);
603 		Group storage theGroup = groups[groupNumber];
604 		groupName = theGroup.name;
605 		distributed = theGroup.distributed;
606 		unlocked = theGroup.unlocked;
607 		phase2cap = theGroup.max2;
608 		phase3cap = theGroup.max3;
609 		cap = theGroup.cap;
610 		ratio = theGroup.ratio;
611 		startTime = theGroup.startTime;
612 		phase1endTime = theGroup.phase1endTime;
613 		phase2endTime = theGroup.phase2endTime;
614 		deadline = theGroup.deadline;
615 		weiTotal = theGroup.weiTotal;
616 	}
617 	
618 	function getHowMuchUntilHardCap_(uint256 groupNumber) internal view returns(uint256 remainder) {
619 		Group storage theGroup = groups[groupNumber];
620 		if (theGroup.weiTotal > theGroup.cap) { // calling .sub in this situation will throw.
621 			return 0;
622 		}
623 		return theGroup.cap.sub(theGroup.weiTotal);
624 	}
625 	
626 	function getHowMuchUntilHardCap() public view returns(uint256 remainder) {
627 		return getHowMuchUntilHardCap_(openGroupNumber);
628 	}
629 
630 	function addMemberToGroup(address walletAddress, uint256 groupNumber) public onlyOwner returns(bool success) {
631 		emit AddToGroup(walletAddress, groupNumber);
632 		return true;
633 	}
634 	
635 	function instructOracleToDistribute(uint256 groupNumber) public onlyOwner {
636 		Group storage theGroup = groups[groupNumber];
637 		require(groupNumber < nextGroupNumber && !theGroup.distributed); // can't have already distributed
638 		emit WantsToDistribute(groupNumber);
639 	}
640 	
641 	function distributeCallback(uint256 groupNumber, uint256 howMany) public onlyOwnerOrOracle returns (bool success) {
642 		Group storage theGroup = groups[groupNumber];
643 		require(!theGroup.distributed);
644 		if (!theGroup.distributing) {
645 			theGroup.distributing = true;
646 		}
647 		uint256 n = theGroup.addresses.length;
648 		uint256 nextDistributionIndex = theGroup.nextDistributionIndex;
649 		uint256 exclusiveEndIndex = nextDistributionIndex + howMany;
650 		if (exclusiveEndIndex > n) {
651 			exclusiveEndIndex = n;
652 		}
653 		uint256 newOwnerSupply = balances[owner];
654 		for (uint256 i = nextDistributionIndex; i < exclusiveEndIndex; i++) {
655 			address theAddress = theGroup.addresses[i];
656 			uint256 balance = getUndistributedBalanceOf_(theAddress, groupNumber);
657 			if (balance > 0) { // No need to waste ticks if they have no tokens to distribute
658 				balances[theAddress] = balances[theAddress].add(balance);
659 				newOwnerSupply = newOwnerSupply.sub(balance); // Update the available number of tokens.
660 				emit Transfer(owner, theAddress, balance); // Notify exchanges of the distribution.
661 			}
662 		}
663 		balances[owner] = newOwnerSupply;
664 		if (exclusiveEndIndex < n) {
665 			emit DistributedBatch(groupNumber, howMany);
666 		} else { // We've finished distributing people
667 			signalDoneDistributing(groupNumber);
668 		}
669 		theGroup.nextDistributionIndex = exclusiveEndIndex; // Usually not necessary if we've finished distribution, but if we don't update this, getHowManyLeftToDistribute will never show 0.
670 		return true;
671 	}
672 
673 	function getHowManyLeftToDistribute(uint256 groupNumber) public view returns(uint256 remainder) {
674 		Group storage theGroup = groups[groupNumber];
675 		return theGroup.addresses.length - theGroup.nextDistributionIndex;
676 	}
677 
678 	function changeGroupInfo(uint256 groupNumber, uint256 startEpoch, uint256 phase1endEpoch, uint256 phase2endEpoch, uint256 deadlineEpoch, uint256 phase2weiCap, uint256 phase3weiCap, uint256 hardWeiCap, uint256 ratio) public onlyOwner returns (bool success) {
679 		Group storage theGroup = groups[groupNumber];
680 		if (startEpoch > 0) {
681 			theGroup.startTime = startEpoch;
682 		}
683 		if (phase1endEpoch > 0) {
684 			theGroup.phase1endTime = phase1endEpoch;
685 		}
686 		if (phase2endEpoch > 0) {
687 			theGroup.phase2endTime = phase2endEpoch;
688 		}
689 		if (deadlineEpoch > 0) {
690 			theGroup.deadline = deadlineEpoch;
691 		}
692 		if (phase2weiCap > 0) {
693 			theGroup.max2 = phase2weiCap;
694 		}
695 		if (phase3weiCap > 0) {
696 			theGroup.max3 = phase3weiCap;
697 		}
698 		if (hardWeiCap > 0) {
699 			theGroup.cap = hardWeiCap;
700 		}
701 		if (ratio > 0) {
702 			theGroup.ratio = ratio;
703 		}
704 		return true;
705 	}
706 
707 	function relockGroup(uint256 groupNumber) public onlyOwner returns(bool success) {
708 		groups[groupNumber].unlocked = true;
709 		return true;
710 	}
711 
712 	function resetGroupInfo(uint256 groupNumber) public onlyOwner returns (bool success) {
713 		Group storage theGroup = groups[groupNumber];
714 		theGroup.startTime = 0;
715 		theGroup.phase1endTime = 0;
716 		theGroup.phase2endTime = 0;
717 		theGroup.deadline = 0;
718 		theGroup.max2 = 0;
719 		theGroup.max3 = 0;
720 		theGroup.cap = 0;
721 		theGroup.ratio = 0;
722 		return true;
723 	}
724 
725 	function unlock(uint256 groupNumber) public onlyOwner returns (bool success) {
726 		Group storage theGroup = groups[groupNumber];
727 		require(theGroup.distributed); // Distribution must have occurred first.
728 		theGroup.unlocked = true;
729 		return true;
730 	}
731 	
732 	function setGlobalLock(bool value) public onlyOwner {
733 		transferLock = value;
734 		emit ChangedTransferLock(transferLock);
735 	}
736 	
737 	function burn(uint256 amount) public onlyOwner {
738 		// Burns tokens from the owner's supply and doesn't touch allocated tokens.
739 		// Decrease totalSupply and leftOver by the amount to burn so we can decrease the circulation.
740 		balances[msg.sender] = balances[msg.sender].sub(amount); // Will throw if result < 0
741 		totalSupply_ = totalSupply_.sub(amount); // Will throw if result < 0
742 		emit Transfer(msg.sender, address(0), amount);
743 	}
744 	
745 	function splitTokensBeforeDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
746 		// SplitFactor is the multiplier per decimal of spark. splitFactor * 10**decimals = splitFactor sparks
747 		uint256 ownerBalance = balances[msg.sender];
748 		uint256 multiplier = ownerBalance.mul(splitFactor);
749 		uint256 increaseSupplyBy = multiplier.sub(ownerBalance); // We need to mint owner*splitFactor - owner additional tokens.
750 		balances[msg.sender] = multiplier;
751 		totalSupply_ = totalSupply_.mul(splitFactor);
752 		emit Transfer(address(0), msg.sender, increaseSupplyBy); // Notify exchange that we've minted tokens.
753 		// Next, increase group ratios by splitFactor, so users will receive ratio * splitFactor tokens per ether.
754 		uint256 n = nextGroupNumber;
755 		require(n > 0); // Must have at least one group.
756 		for (uint256 i = 0; i < n; i++) {
757 			Group storage currentGroup = groups[i];
758 			currentGroup.ratio = currentGroup.ratio.mul(splitFactor);
759 		}
760 		return true;
761 	}
762 
763 	function reverseSplitTokensBeforeDistribution(uint256 splitFactor) public onlyOwner returns (bool success) {
764 		// SplitFactor is the multiplier per decimal of spark. splitFactor * 10**decimals = splitFactor sparks
765 		uint256 ownerBalance = balances[msg.sender];
766 		uint256 divier = ownerBalance.div(splitFactor);
767 		uint256 decreaseSupplyBy = ownerBalance.sub(divier);
768 		// We don't use burnTokens here since the amount to subtract might be more than what the owner currently holds in their unallocated supply which will cause the function to throw.
769 		totalSupply_ = totalSupply_.div(splitFactor);
770 		balances[msg.sender] = divier;
771 		// Notify the exchanges of how many tokens were burned.
772 		emit Transfer(msg.sender, address(0), decreaseSupplyBy);
773 		// Next, decrease group ratios by splitFactor, so users will receive ratio / splitFactor tokens per ether.
774 		uint256 n = nextGroupNumber;
775 		require(n > 0); // Must have at least one group. Groups are 0-indexed.
776 		for (uint256 i = 0; i < n; i++) {
777 			Group storage currentGroup = groups[i];
778 			currentGroup.ratio = currentGroup.ratio.div(splitFactor);
779 		}
780 		return true;
781 	}
782 
783 	function airdrop( address[] addresses, uint256[] tokenDecimalAmounts) public onlyOwnerOrOracle returns (bool success) {
784 		uint256 n = addresses.length;
785 		require(n == tokenDecimalAmounts.length, "Array lengths mismatch");
786 		uint256 newOwnerBalance = balances[owner];
787 		for (uint256 i = 0; i < n; i++) {
788 			address theAddress = addresses[i];
789 			uint256 airdropAmount = tokenDecimalAmounts[i];
790 			if (airdropAmount > 0) {
791 				uint256 currentBalance = balances[theAddress];
792 				balances[theAddress] = currentBalance.add(airdropAmount);
793 				newOwnerBalance = newOwnerBalance.sub(airdropAmount);
794 				emit Transfer(owner, theAddress, airdropAmount);
795 			}
796 		}
797 		balances[owner] = newOwnerBalance;
798 		emit AirdroppedBatch(addresses);
799 		return true;
800 	}
801 
802 	function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) canTransfer returns (bool success) {		
803 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
804 		if (msg.sender != owner) { // Owner can transfer anything to anyone.
805 			require(balances[msg.sender].sub(_value) >= getLockedTokens_(msg.sender));
806 		}
807 		return super.transfer(_to, _value);
808 	}
809 
810 	function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) canTransfer returns (bool success) {
811 		// If the transferrer has purchased tokens, they must be unlocked before they can be used.
812 		if (msg.sender != owner) { // Owner not affected by locked tokens
813 			require(balances[_from].sub(_value) >= getLockedTokens_(_from));
814 		}
815 		return super.transferFrom(_from, _to, _value);
816 	}
817 
818 	function setOpenGroup(uint256 groupNumber) public onlyOwner returns (bool success) {
819 		require(groupNumber < nextGroupNumber);
820 		openGroupNumber = groupNumber;
821 		return true;
822 	}
823 
824 	function getLockedTokensInGroup_(address walletAddress, uint256 groupNumber) internal view returns (uint256 balance) {
825 		Member storage theMember = members[walletAddress];
826 		if (groups[groupNumber].unlocked) {
827 			return 0;
828 		}
829 		return theMember.weiBalance[groupNumber].mul(groups[groupNumber].ratio);
830 	}
831 
832 	function getLockedTokens_(address walletAddress) internal view returns(uint256 balance) {
833 		uint256 n = nextGroupNumber;
834 		for (uint256 i = 0; i < n; i++) {
835 			balance = balance.add(getLockedTokensInGroup_(walletAddress, i));
836 		}
837 		return balance;
838 	}
839 
840 	function getLockedTokens(address walletAddress) public view returns(uint256 balance) {
841 		return getLockedTokens_(walletAddress);
842 	}
843 
844 	function getUndistributedBalanceOf_(address walletAddress, uint256 groupNumber) internal view returns (uint256 balance) {
845 		Member storage theMember = members[walletAddress];
846 		Group storage theGroup = groups[groupNumber];
847 		if (theGroup.distributed) {
848 			return 0;
849 		}
850 		return theMember.weiBalance[groupNumber].mul(theGroup.ratio);
851 	}
852 
853 	function getUndistributedBalanceOf(address walletAddress, uint256 groupNumber) public view returns (uint256 balance) {
854 		return getUndistributedBalanceOf_(walletAddress, groupNumber);
855 	}
856 
857 	function checkMyUndistributedBalance(uint256 groupNumber) public view returns (uint256 balance) {
858 		return getUndistributedBalanceOf_(msg.sender, groupNumber);
859 	}
860 
861 	function transferRecovery(address _from, address _to, uint256 _value) public onlyOwner returns (bool success) {
862 		// Will be used if someone sends tokens to an incorrect address by accident. This way, we have the ability to recover the tokens. For example, sometimes there's a problem of lost tokens if someone sends tokens to a contract address that can't utilize the tokens.
863 		allowed[_from][msg.sender] = allowed[_from][msg.sender].add(_value); // Authorize the owner to spend on someone's behalf.
864 		return transferFrom(_from, _to, _value);
865 	}
866 }