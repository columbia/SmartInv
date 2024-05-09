1 pragma solidity ^0.4.21;
2 
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11 	
12 	address public owner;
13 	address public potentialOwner;
14 	
15 	
16 	event OwnershipRemoved(address indexed previousOwner);
17 	event OwnershipTransfer(address indexed previousOwner, address indexed newOwner);
18 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 	
20 	
21 	/**
22 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
23 	 * account.
24 	 */
25 	function Ownable() public {
26 		owner = msg.sender;
27 	}
28 	
29 	
30 	/**
31 	 * @dev Throws if called by any account other than the owner.
32 	 */
33 	modifier onlyOwner() {
34 		require(msg.sender == owner);
35 		_;
36 	}
37 	
38 	
39 	/**
40 	 * @dev Throws if called by any account other than the owner.
41 	 */
42 	modifier onlyPotentialOwner() {
43 		require(msg.sender == potentialOwner);
44 		_;
45 	}
46 	
47 	
48 	/**
49 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
50 	 * @param newOwner The address of potential new owner to transfer ownership to.
51 	 */
52 	function transferOwnership(address newOwner) public onlyOwner {
53 		require(newOwner != address(0));
54 		emit OwnershipTransfer(owner, newOwner);
55 		potentialOwner = newOwner;
56 	}
57 	
58 	
59 	/**
60 	 * @dev Allow the potential owner confirm ownership of the contract.
61 	 */
62 	function confirmOwnership() public onlyPotentialOwner {
63 		emit OwnershipTransferred(owner, potentialOwner);
64 		owner = potentialOwner;
65 		potentialOwner = address(0);
66 	}
67 	
68 	
69 	/**
70 	 * @dev Remove the contract owner permanently
71 	 */
72 	function removeOwnership() public onlyOwner {
73 		emit OwnershipRemoved(owner);
74 		owner = address(0);
75 	}
76 	
77 }
78 
79 /**
80  * @title AddressTools
81  * @dev Useful tools for address type
82  */
83 library AddressTools {
84 	
85 	/**
86 	* @dev Returns true if given address is the contract address, otherwise - returns false
87 	*/
88 	function isContract(address a) internal view returns (bool) {
89 		if(a == address(0)) {
90 			return false;
91 		}
92 		
93 		uint codeSize;
94 		// solium-disable-next-line security/no-inline-assembly
95 		assembly {
96 			codeSize := extcodesize(a)
97 		}
98 		
99 		if(codeSize > 0) {
100 			return true;
101 		}
102 		
103 		return false;
104 	}
105 	
106 }
107 
108 /**
109 * @title Contract that will work with ERC223 tokens
110 */
111 contract ERC223Reciever {
112 	
113 	/**
114 	 * @dev Standard ERC223 function that will handle incoming token transfers
115 	 *
116 	 * @param _from address  Token sender address
117 	 * @param _value uint256 Amount of tokens
118 	 * @param _data bytes  Transaction metadata
119 	 */
120 	function tokenFallback(address _from, uint256 _value, bytes _data) external returns (bool);
121 	
122 }
123 
124 /**
125  * @title SafeMath
126  * @dev Math operations with safety checks that throw on error
127  */
128 library SafeMath {
129 	
130 	/**
131 	* @dev Multiplies two numbers, throws on overflow.
132 	*/
133 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
134 		if (a == 0) {
135 			return 0;
136 		}
137 		uint256 c = a * b;
138 		assert(c / a == b);
139 		return c;
140 	}
141 	
142 	
143 	/**
144 	* @dev Integer division of two numbers, truncating the quotient.
145 	*/
146 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
147 		uint256 c = a / b;
148 		return c;
149 	}
150 	
151 	
152 	/**
153 	* @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
154 	*/
155 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156 		assert(b <= a);
157 		return a - b;
158 	}
159 	
160 	
161 	/**
162 	* @dev Adds two numbers, throws on overflow.
163 	*/
164 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
165 		uint256 c = a + b;
166 		assert(c >= a);
167 		return c;
168 	}
169 	
170 	
171 	/**
172 	* @dev Powers the first number to the second, throws on overflow.
173 	*/
174 	function pow(uint a, uint b) internal pure returns (uint) {
175 		if (b == 0) {
176 			return 1;
177 		}
178 		uint c = a ** b;
179 		assert(c >= a);
180 		return c;
181 	}
182 	
183 	
184 	/**
185 	 * @dev Multiplies the given number by 10**decimals
186 	 */
187 	function withDecimals(uint number, uint decimals) internal pure returns (uint) {
188 		return mul(number, pow(10, decimals));
189 	}
190 	
191 }
192 
193 /**
194  * @title ERC20Basic
195  * @dev Simpler version of ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/179
197  */
198 contract ERC20Basic {
199 	function totalSupply() public view returns (uint256);
200 	function balanceOf(address who) public view returns (uint256);
201 	function transfer(address to, uint256 value) public returns (bool);
202 	event Transfer(address indexed from, address indexed to, uint256 value);
203 }
204 
205 /**
206  * @title Basic token
207  * @dev Basic version of StandardToken, with no allowances.
208  */
209 contract BasicToken is ERC20Basic {
210 	
211 	using SafeMath for uint256;
212 	
213 	mapping(address => uint256) public balances;
214 	
215 	uint256 public totalSupply_;
216 	
217 	
218 	/**
219 	* @dev total number of tokens in existence
220 	*/
221 	function totalSupply() public view returns (uint256) {
222 		return totalSupply_;
223 	}
224 	
225 	
226 	/**
227 	* @dev transfer token for a specified address
228 	* @param _to The address to transfer to.
229 	* @param _value The amount to be transferred.
230 	*/
231 	function transfer(address _to, uint256 _value) public returns (bool) {
232 		require(_to != address(0));
233 		require(_value <= balances[msg.sender]);
234 		
235 		// SafeMath.sub will throw if there is not enough balance.
236 		balances[msg.sender] = balances[msg.sender].sub(_value);
237 		balances[_to] = balances[_to].add(_value);
238 		emit Transfer(msg.sender, _to, _value);
239 		return true;
240 	}
241 	
242 	
243 	/**
244 	* @dev Gets the balance of the specified address.
245 	* @param _owner The address to query the the balance of.
246 	* @return An uint256 representing the amount owned by the passed address.
247 	*/
248 	function balanceOf(address _owner) public view returns (uint256 balance) {
249 		return balances[_owner];
250 	}
251 	
252 }
253 
254 /**
255  * @title Burnable Token
256  * @dev Token that can be irreversibly burned (destroyed).
257  */
258 contract BurnableToken is BasicToken {
259 	
260 	event Burn(address indexed burner, uint256 value);
261 	
262 	/**
263 	 * @dev Burns a specific amount of tokens.
264 	 * @param _value The amount of token to be burned.
265 	 */
266 	function burn(uint256 _value) public {
267 		require(_value <= balances[msg.sender]);
268 		// no need to require value <= totalSupply, since that would imply the
269 		// sender's balance is greater than the totalSupply, which *should* be an assertion failure
270 		
271 		address burner = msg.sender;
272 		balances[burner] = balances[burner].sub(_value);
273 		totalSupply_ = totalSupply_.sub(_value);
274 		emit Burn(burner, _value);
275 		emit Transfer(burner, address(0), _value);
276 	}
277 }
278 
279 /**
280  * @title ERC20 interface
281  * @dev see https://github.com/ethereum/EIPs/issues/20
282  */
283 contract ERC20 is ERC20Basic {
284 	function allowance(address owner, address spender) public view returns (uint256);
285 	function transferFrom(address from, address to, uint256 value) public returns (bool);
286 	function approve(address spender, uint256 value) public returns (bool);
287 	event Approval(address indexed owner, address indexed spender, uint256 value);
288 }
289 
290 /**
291  * @title Standard ERC20 token
292  *
293  * @dev Implementation of the basic standard token.
294  * @dev https://github.com/ethereum/EIPs/issues/20
295  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
296  */
297 contract StandardToken is ERC20, BasicToken {
298 	
299 	mapping (address => mapping (address => uint256)) internal allowed;
300 	
301 	
302 	/**
303 	 * @dev Transfer tokens from one address to another
304 	 * @param _from address The address which you want to send tokens from
305 	 * @param _to address The address which you want to transfer to
306 	 * @param _value uint256 the amount of tokens to be transferred
307 	 */
308 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
309 		require(_to != address(0));
310 		require(_value <= balances[_from]);
311 		require(_value <= allowed[_from][msg.sender]);
312 		
313 		balances[_from] = balances[_from].sub(_value);
314 		balances[_to] = balances[_to].add(_value);
315 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
316 		emit Transfer(_from, _to, _value);
317 		return true;
318 	}
319 	
320 	
321 	/**
322 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
323 	 *
324 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
325 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
326 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
327 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
328 	 * @param _spender The address which will spend the funds.
329 	 * @param _value The amount of tokens to be spent.
330 	 */
331 	function approve(address _spender, uint256 _value) public returns (bool) {
332 		allowed[msg.sender][_spender] = _value;
333 		emit Approval(msg.sender, _spender, _value);
334 		return true;
335 	}
336 	
337 	
338 	/**
339 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
340 	 * @param _owner address The address which owns the funds.
341 	 * @param _spender address The address which will spend the funds.
342 	 * @return A uint256 specifying the amount of tokens still available for the spender.
343 	 */
344 	function allowance(address _owner, address _spender) public view returns (uint256) {
345 		return allowed[_owner][_spender];
346 	}
347 	
348 	/**
349 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
350 	 *
351 	 * approve should be called when allowed[_spender] == 0. To increment
352 	 * allowed value is better to use this function to avoid 2 calls (and wait until
353 	 * the first transaction is mined)
354 	 * From MonolithDAO Token.sol
355 	 * @param _spender The address which will spend the funds.
356 	 * @param _addedValue The amount of tokens to increase the allowance by.
357 	 */
358 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
359 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
360 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
361 		return true;
362 	}
363 	
364 	
365 	/**
366 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
367 	 *
368 	 * approve should be called when allowed[_spender] == 0. To decrement
369 	 * allowed value is better to use this function to avoid 2 calls (and wait until
370 	 * the first transaction is mined)
371 	 * From MonolithDAO Token.sol
372 	 * @param _spender The address which will spend the funds.
373 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
374 	 */
375 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
376 		uint oldValue = allowed[msg.sender][_spender];
377 		if (_subtractedValue > oldValue) {
378 			allowed[msg.sender][_spender] = 0;
379 		} else {
380 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
381 		}
382 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
383 		return true;
384 	}
385 
386 }
387 
388 /**
389  * @title ERC223 interface
390  * @dev see https://github.com/ethereum/EIPs/issues/223
391  */
392 contract ERC223 is ERC20 {
393 	function transfer(address to, uint256 value, bytes data) public returns (bool);
394 	event ERC223Transfer(address indexed from, address indexed to, uint256 value, bytes data);
395 }
396 
397 /**
398  * @title (Not)Reference implementation of the ERC223 standard token.
399  */
400 contract ERC223Token is ERC223, StandardToken {
401 	
402 	using AddressTools for address;
403 	
404 	
405 	/**
406 	 * @dev Transfer the specified amount of tokens to the specified address.
407 	 *      Invokes the `tokenFallback` function if the recipient is a contract.
408 	 *      The token transfer fails if the recipient is a contract
409 	 *      but does not implement the `tokenFallback` function
410 	 *      or the fallback function to receive funds.
411 	 *
412 	 * @param _to    Receiver address
413 	 * @param _value Amount of tokens that will be transferred
414 	 * @param _data  Transaction metadata
415 	 */
416 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
417 		return executeTransfer(_to, _value, _data);
418 	}
419 	
420 	
421 	/**
422 	 * @dev Transfer the specified amount of tokens to the specified address.
423 	 *      This function works the same with the previous one
424 	 *      but doesn"t contain `_data` param.
425 	 *      Added due to backwards compatibility reasons.
426 	 *
427 	 * @param _to    Receiver address
428 	 * @param _value Amount of tokens that will be transferred
429 	 */
430 	function transfer(address _to, uint256 _value) public returns (bool) {
431 		bytes memory _data;
432 		
433 		return executeTransfer(_to, _value, _data);
434 	}
435 	
436 	
437 	/**
438 	 * @dev Makes execution of the token fallback method from if reciever address is contract
439 	 */
440 	function executeTokenFallback(address _to, uint256 _value, bytes _data) private returns (bool) {
441 		ERC223Reciever receiver = ERC223Reciever(_to);
442 		
443 		return receiver.tokenFallback(msg.sender, _value, _data);
444 	}
445 	
446 	
447 	/**
448 	 * @dev Makes execution of the tokens transfer method from super class
449 	 */
450 	function executeTransfer(address _to, uint256 _value, bytes _data) private returns (bool) {
451 		require(super.transfer(_to, _value));
452 		
453 		if(_to.isContract()) {
454 			require(executeTokenFallback(_to, _value, _data));
455 			emit ERC223Transfer(msg.sender, _to, _value, _data);
456 		}
457 		
458 		return true;
459 	}
460 	
461 }
462 
463 /**
464  * @title UKTTokenBasic
465  * @dev UKTTokenBasic interface
466  */
467 contract UKTTokenBasic is ERC223, BurnableToken {
468 	
469 	bool public isControlled = false;
470 	bool public isConfigured = false;
471 	bool public isAllocated = false;
472 	
473 	// mapping of string labels to initial allocated addresses
474 	mapping(bytes32 => address) public allocationAddressesTypes;
475 	// mapping of addresses to time lock period
476 	mapping(address => uint32) public timelockedAddresses;
477 	// mapping of addresses to lock flag
478 	mapping(address => bool) public lockedAddresses;
479 	
480 	
481 	function setConfiguration(string _name, string _symbol, uint _totalSupply) external returns (bool);
482 	function setInitialAllocation(address[] addresses, bytes32[] addressesTypes, uint[] amounts) external returns (bool);
483 	function setInitialAllocationLock(address allocationAddress ) external returns (bool);
484 	function setInitialAllocationUnlock(address allocationAddress ) external returns (bool);
485 	function setInitialAllocationTimelock(address allocationAddress, uint32 timelockTillDate ) external returns (bool);
486 	
487 	// fires when the token contract becomes controlled
488 	event Controlled(address indexed tokenController);
489 	// fires when the token contract becomes configured
490 	event Configured(string tokenName, string tokenSymbol, uint totalSupply);
491 	event InitiallyAllocated(address indexed owner, bytes32 addressType, uint balance);
492 	event InitiallAllocationLocked(address indexed owner);
493 	event InitiallAllocationUnlocked(address indexed owner);
494 	event InitiallAllocationTimelocked(address indexed owner, uint32 timestamp);
495 	
496 }
497 
498 /**
499  * @title  Basic UKT token contract
500  * @author  Oleg Levshin <levshin@ucoz-team.net>
501  */
502 contract UKTToken is UKTTokenBasic, ERC223Token, Ownable {
503 	
504 	using AddressTools for address;
505 	
506 	string public name;
507 	string public symbol;
508 	uint public constant decimals = 18;
509 	
510 	// address of the controller contract
511 	address public controller;
512 	
513 	
514 	modifier onlyController() {
515 		require(msg.sender == controller);
516 		_;
517 	}
518 	
519 	modifier onlyUnlocked(address _address) {
520 		address from = _address != address(0) ? _address : msg.sender;
521 		require(
522 			lockedAddresses[from] == false &&
523 			(
524 				timelockedAddresses[from] == 0 ||
525 				timelockedAddresses[from] <= now
526 			)
527 		);
528 		_;
529 	}
530 	
531 	
532 	/**
533 	 * @dev Sets the controller contract address and removes token contract ownership
534 	 */
535 	function setController(
536 		address _controller
537 	) public onlyOwner {
538 		// cannot be invoked after initial setting
539 		require(!isControlled);
540 		// _controller should be an address of the smart contract
541 		require(_controller.isContract());
542 		
543 		controller = _controller;
544 		removeOwnership();
545 		
546 		emit Controlled(controller);
547 		
548 		isControlled = true;
549 	}
550 	
551 	
552 	/**
553 	 * @dev Sets the token contract configuration
554 	 */
555 	function setConfiguration(
556 		string _name,
557 		string _symbol,
558 		uint _totalSupply
559 	) external onlyController returns (bool) {
560 		// not configured yet
561 		require(!isConfigured);
562 		// not empty name of the token
563 		require(bytes(_name).length > 0);
564 		// not empty ticker symbol of the token
565 		require(bytes(_symbol).length > 0);
566 		// pre-defined total supply
567 		require(_totalSupply > 0);
568 		
569 		name = _name;
570 		symbol = _symbol;
571 		totalSupply_ = _totalSupply.withDecimals(decimals);
572 		
573 		emit Configured(name, symbol, totalSupply_);
574 		
575 		isConfigured = true;
576 		
577 		return isConfigured;
578 	}
579 	
580 	
581 	/**
582 	 * @dev Sets initial balances allocation
583 	 */
584 	function setInitialAllocation(
585 		address[] addresses,
586 		bytes32[] addressesTypes,
587 		uint[] amounts
588 	) external onlyController returns (bool) {
589 		// cannot be invoked after initial allocation
590 		require(!isAllocated);
591 		// the array of addresses should be the same length as the array of addresses types
592 		require(addresses.length == addressesTypes.length);
593 		// the array of addresses should be the same length as the array of allocating amounts
594 		require(addresses.length == amounts.length);
595 		// sum of the allocating balances should be equal to totalSupply
596 		uint balancesSum = 0;
597 		for(uint b = 0; b < amounts.length; b++) {
598 			balancesSum = balancesSum.add(amounts[b]);
599 		}
600 		require(balancesSum.withDecimals(decimals) == totalSupply_);
601 		
602 		for(uint a = 0; a < addresses.length; a++) {
603 			balances[addresses[a]] = amounts[a].withDecimals(decimals);
604 			allocationAddressesTypes[addressesTypes[a]] = addresses[a];
605 			emit InitiallyAllocated(addresses[a], addressesTypes[a], balanceOf(addresses[a]));
606 		}
607 		
608 		isAllocated = true;
609 		
610 		return isAllocated;
611 	}
612 	
613 	
614 	/**
615 	 * @dev Sets lock for given allocation address
616 	 */
617 	function setInitialAllocationLock(
618 		address allocationAddress
619 	) external onlyController returns (bool) {
620 		require(allocationAddress != address(0));
621 		
622 		lockedAddresses[allocationAddress] = true;
623 		
624 		emit InitiallAllocationLocked(allocationAddress);
625 		
626 		return true;
627 	}
628 	
629 	
630 	/**
631 	 * @dev Sets unlock for given allocation address
632 	 */
633 	function setInitialAllocationUnlock(
634 		address allocationAddress
635 	) external onlyController returns (bool) {
636 		require(allocationAddress != address(0));
637 		
638 		lockedAddresses[allocationAddress] = false;
639 		
640 		emit InitiallAllocationUnlocked(allocationAddress);
641 		
642 		return true;
643 	}
644 	
645 	
646 	/**
647 	 * @dev Sets time lock for given allocation address
648 	 */
649 	function setInitialAllocationTimelock(
650 		address allocationAddress,
651 		uint32 timelockTillDate
652 	) external onlyController returns (bool) {
653 		require(allocationAddress != address(0));
654 		require(timelockTillDate >= now);
655 		
656 		timelockedAddresses[allocationAddress] = timelockTillDate;
657 		
658 		emit InitiallAllocationTimelocked(allocationAddress, timelockTillDate);
659 		
660 		return true;
661 	}
662 	
663 	
664 	/**
665 	 * @dev Allows transfer of the tokens after locking conditions checking
666 	 */
667 	function transfer(
668 		address _to,
669 		uint256 _value
670 	) public onlyUnlocked(address(0)) returns (bool) {
671 		require(super.transfer(_to, _value));
672 		return true;
673 	}
674 	
675 	
676 	/**
677 	 * @dev Allows transfer of the tokens (with additional _data) after locking conditions checking
678 	 */
679 	function transfer(
680 		address _to,
681 		uint256 _value,
682 		bytes _data
683 	) public onlyUnlocked(address(0)) returns (bool) {
684 		require(super.transfer(_to, _value, _data));
685 		return true;
686 	}
687 	
688 	
689 	/**
690 	 * @dev Allows transfer of the tokens after locking conditions checking
691 	 */
692 	function transferFrom(
693 		address _from,
694 		address _to,
695 		uint256 _value
696 	) public onlyUnlocked(_from) returns (bool) {
697 		require(super.transferFrom(_from, _to, _value));
698 		return true;
699 	}
700 	
701 }