1 pragma solidity ^0.4.18;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  * Library easily handles the cases of overflow as well as underflow. 
7  * Also ensures that balance does nto get naegative
8  */
9 library SafeMath {
10 	// multiplies two values safely and returns result
11 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12 		if (a == 0) {
13 			return 0;
14 		}
15 		uint256 c = a * b;
16 		assert(c / a == b);
17 		return c;
18 	}
19 
20 	// devides two values safely and returns result
21 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
22 		// assert(b > 0); // Solidity automatically throws when dividing by 0
23 		uint256 c = a / b;
24 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
25 		return c;
26 	}
27 
28 	// subtracts two values safely and returns result
29 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30 		assert(b <= a);
31 		return a - b;
32 	}
33 
34 	// adds two values safely and returns result
35 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
36 		uint256 c = a + b;
37 		assert(c >= a);
38 		return c;
39 	}
40 }
41 
42 /**
43  * @title Ownable
44  * @dev The Ownable contract has an owner address, and provides basic authorization control
45  * functions, this simplifies the implementation of "user permissions".
46  */
47 contract Ownable {
48 	address public owner;
49 
50 	// Event to log whenever the ownership is tranferred
51 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53 	/**
54 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
55 	 * account.
56 	 */
57 	function Ownable() public {
58 		owner = msg.sender;
59 	}
60 
61 	/**
62 	 * @dev Throws if called by any account other than the owner.
63 	 */
64 	modifier onlyOwner() {
65 		require(msg.sender == owner);
66 		_;
67 	}
68 
69 	/**
70 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
71 	 * @param newOwner The address to transfer ownership to.
72 	 */
73 	function transferOwnership(address newOwner) public onlyOwner {
74 		require(newOwner != address(0));
75 		OwnershipTransferred(owner, newOwner);
76 		owner = newOwner;
77 	}
78 }
79 
80 
81 /**
82  * @title ERC20Basic
83  * @dev Simpler version of ERC20 interface
84  * @dev see https://github.com/ethereum/EIPs/issues/179
85  */
86 contract ERC20Basic {
87 	uint256 public totalSupply;
88 	function balanceOf(address who) public view returns (uint256);
89 	function transfer(address to, uint256 value) public returns (bool);
90 	event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
91 }
92 
93 
94 /**
95  * @title ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/20
97  */
98 contract ERC20 is ERC20Basic {
99 	function allowance(address owner, address spender) public view returns (uint256);
100 	function transferFrom(address from, address to, uint256 value) public returns (bool);
101 	function approve(address spender, uint256 value) public returns (bool);
102 	event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @title Basic token
107  * @dev Basic version of StandardToken, with no allowances.
108  */
109 contract BasicToken is ERC20Basic {
110 	using SafeMath for uint256;
111 
112 	mapping(address => uint256) balances;
113 
114 	/**
115 	* @dev transfer token for a specified address
116 	* @param _to The address to transfer to.
117 	* @param _value The amount to be transferred.
118 	*/
119 	function transfer(address _to, uint256 _value) public returns (bool) {
120 		require(_to != address(0));
121 		require(_value <= balances[msg.sender]);
122 
123 		// SafeMath.sub will throw if there is not enough balance.
124 		balances[msg.sender] = balances[msg.sender].sub(_value);
125 		balances[_to] = balances[_to].add(_value);
126 
127 		bytes memory empty;
128 		Transfer(msg.sender, _to, _value, empty);
129 		return true;
130 	}
131 
132 	/**
133 	* @dev Gets the balance of the specified address.
134 	* @param _owner The address to query the the balance of.
135 	* @return An uint256 representing the amount owned by the passed address.
136 	*/
137 	function balanceOf(address _owner) public view returns (uint256 balance) {
138 		return balances[_owner];
139 	}
140 }
141 
142 
143 /**
144  * @title Standard ERC20 token
145  *
146  * @dev Implementation of the basic standard token.
147  * @dev https://github.com/ethereum/EIPs/issues/20
148  */
149 contract StandardToken is ERC20, BasicToken {
150 
151 	// tracks the allowance of address. 
152 	mapping (address => mapping (address => uint256)) internal allowed;
153 
154 	/**
155 	 * @dev Transfer tokens from one address to another
156 	 * @param _from address The address which you want to send tokens from
157 	 * @param _to address The address which you want to transfer to
158 	 * @param _value uint256 the amount of tokens to be transferred
159 	 */
160 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
161 		require(_to != address(0));
162 		require(_value <= balances[_from]);
163 		require(_value <= allowed[_from][msg.sender]);
164 
165 		balances[_from] = balances[_from].sub(_value);
166 		balances[_to] = balances[_to].add(_value);
167 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
168 
169 		bytes memory empty;
170 		Transfer(_from, _to, _value, empty);
171 		return true;
172 	}
173 
174 	/**
175 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
176 	 *
177 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
178 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181 	 * @param _spender The address which will spend the funds.
182 	 * @param _value The amount of tokens to be spent.
183 	 */
184 	function approve(address _spender, uint256 _value) public returns (bool) {
185 		allowed[msg.sender][_spender] = _value;
186 		Approval(msg.sender, _spender, _value);
187 		return true;
188 	}
189 
190 	/**
191 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
192 	 * @param _owner address The address which owns the funds.
193 	 * @param _spender address The address which will spend the funds.
194 	 * @return A uint256 specifying the amount of tokens still available for the spender.
195 	 */
196 	function allowance(address _owner, address _spender) public view returns (uint256) {
197 		return allowed[_owner][_spender];
198 	}
199 
200 	/**
201 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
202 	 *
203 	 * approve should be called when allowed[_spender] == 0. To increment
204 	 * allowed value is better to use this function to avoid 2 calls (and wait until
205 	 * the first transaction is mined)
206 	 * From MonolithDAO Token.sol
207 	 * @param _spender The address which will spend the funds.
208 	 * @param _addedValue The amount of tokens to increase the allowance by.
209 	 */
210 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
211 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
212 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
213 		return true;
214 	}
215 
216 	/**
217 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
218 	 *
219 	 * approve should be called when allowed[_spender] == 0. To decrement
220 	 * allowed value is better to use this function to avoid 2 calls (and wait until
221 	 * the first transaction is mined)
222 	 * From MonolithDAO Token.sol
223 	 * @param _spender The address which will spend the funds.
224 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
225 	 */
226 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
227 		uint256 oldValue = allowed[msg.sender][_spender];
228 		if (_subtractedValue > oldValue) {
229 			allowed[msg.sender][_spender] = 0;
230 		} else {
231 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
232 		}
233 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
234 		return true;
235 	}
236 
237 }
238 
239 /**
240  * @title ERC23Receiver interface
241  * @dev see https://github.com/ethereum/EIPs/issues/223
242  */
243 contract ERC223Receiver {
244 	 
245 	struct TokenStruct {
246 		address sender;
247 		uint256 value;
248 		bytes data;
249 		bytes4 sig;
250 	}
251 	
252 	/**
253 	 * @dev Fallback function. Our ICO contract should implement this contract to receve ERC23 compatible tokens.
254 	 * ERC23 protocol checks if contract has implemented this fallback method or not. 
255 	 * If this method is not implemented then tokens are not sent.
256 	 * This method is introduced to avoid loss of tokens 
257 	 *
258 	 * @param _from The address which will transfer the tokens.
259 	 * @param _value Amount of tokens received.
260 	 * @param _data Data sent along with transfer request.
261 	 */
262 	function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
263 		TokenStruct memory tkn;
264 		tkn.sender = _from;
265 		tkn.value = _value;
266 		tkn.data = _data;
267 		// uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
268 		// tkn.sig = bytes4(u);
269 	  
270 		/* tkn variable is analogue of msg variable of Ether transaction
271 		*  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
272 		*  tkn.value the number of tokens that were sent   (analogue of msg.value)
273 		*  tkn.data is data of token transaction   (analogue of msg.data)
274 		*  tkn.sig is 4 bytes signature of function
275 		*  if data of token transaction is a function execution
276 		*/
277 	}
278 }
279 
280 /**
281  * @title ERC23 interface
282  * @dev see https://github.com/ethereum/EIPs/issues/223
283  */
284 contract ERC223 {
285 	uint256 public totalSupply;
286 	function balanceOf(address who) public view returns (uint256);
287 	function transfer(address to, uint256 value) public returns (bool);
288 	function transfer(address to, uint256 value, bytes data) public returns (bool);
289 	function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool);
290 	event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
291 }
292 
293 /**
294  * @title Standard ERC223Token token
295  *
296  * @dev Implementation of the ERC23 token.
297  * @dev https://github.com/ethereum/EIPs/issues/223
298  */
299 
300 contract ERC223Token is ERC223, StandardToken {
301 	using SafeMath for uint256;
302 
303 	/**
304 	 * @dev Function that is called when a user or another contract wants to transfer funds .
305 	 * This is method where you can supply fallback function name and that function will be triggered.
306 	 * This method is added as part of ERC23 standard
307 	 *
308 	 * @param _to The address which will receive the tokens.
309 	 * @param _value Amount of tokens received.
310 	 * @param _data Data sent along with transfer request.
311 	 * @param _custom_fallback Name of the method which should be called after transfer happens. If this method does not exists on contract then transaction will fail
312 	 */
313 	function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success) {
314 		// check if receiving is contract
315 		if(isContract(_to)) {
316 			// validate the address and balance
317 			require(_to != address(0));
318 			require(_value <= balances[msg.sender]);
319 
320 			// SafeMath.sub will throw if there is not enough balance.
321 			balances[msg.sender] = balances[msg.sender].sub(_value);
322 			balances[_to] = balances[_to].add(_value);
323 	
324 			// invoke custom fallback function			
325 			assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
326 			Transfer(msg.sender, _to, _value, _data);
327 			return true;
328 		}
329 		else {
330 			// receiver is not a contract so perform normal transfer to address
331 			return transferToAddress(_to, _value, _data);
332 		}
333 	}
334   
335 
336 	/**
337 	 * @dev Function that is called when a user or another contract wants to transfer funds .
338 	 * You can pass extra data which can be tracked in event.
339 	 * This method is added as part of ERC23 standard
340 	 *
341 	 * @param _to The address which will receive the tokens.
342 	 * @param _value Amount of tokens received.
343 	 * @param _data Data sent along with transfer request.
344 	 */
345 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
346 		// check if receiver is contract address
347 		if(isContract(_to)) {
348 			// invoke transfer request to contract
349 			return transferToContract(_to, _value, _data);
350 		}
351 		else {
352 			// invoke transfer request to normal user wallet address
353 			return transferToAddress(_to, _value, _data);
354 		}
355 	}
356   
357 	/**
358 	 * @dev Standard function transfer similar to ERC20 transfer with no _data .
359 	 * Added due to backwards compatibility reasons .
360 	 *
361 	 * @param _to The address which will receive the tokens.
362 	 * @param _value Amount of tokens received.
363 	 */
364 	function transfer(address _to, uint256 _value) public returns (bool success) {
365 		//standard function transfer similar to ERC20 transfer with no _data
366 		//added due to backwards compatibility reasons
367 		bytes memory empty;
368 
369 		// check if receiver is contract address
370 		if(isContract(_to)) {
371 			// invoke transfer request to contract
372 			return transferToContract(_to, _value, empty);
373 		}
374 		else {
375 			// invoke transfer request to normal user wallet address
376 			return transferToAddress(_to, _value, empty);
377 		}
378 	}
379 
380 	/**
381 	 * @dev assemble the given address bytecode. If bytecode exists then the _addr is a contract.
382 	 *
383 	 * @param _addr The address which need to be checked if contract address or wallet address
384 	 */
385 	function isContract(address _addr) private view returns (bool is_contract) {
386 		uint256 length;
387 		assembly {
388 			//retrieve the size of the code on target address, this needs assembly
389 			length := extcodesize(_addr)
390 		}
391 		return (length > 0);
392 	}
393 
394 	/**
395 	 * @dev Function that is called when transaction target is an address. This is private method.
396 	 *
397 	 * @param _to The address which will receive the tokens.
398 	 * @param _value Amount of tokens received.
399 	 * @param _data Data sent along with transfer request.
400 	 */
401 	function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
402 		// validate the address and balance
403 		require(_to != address(0));
404 		require(_value <= balances[msg.sender]);
405 
406 		// SafeMath.sub will throw if there is not enough balance.
407 		balances[msg.sender] = balances[msg.sender].sub(_value);
408 		balances[_to] = balances[_to].add(_value);
409 
410 		// Log the transfer event
411 		Transfer(msg.sender, _to, _value, _data);
412 		return true;
413 	}
414   
415 	/**
416 	 * @dev Function that is called when transaction target is a contract. This is private method.
417 	 *
418 	 * @param _to The address which will receive the tokens.
419 	 * @param _value Amount of tokens received.
420 	 * @param _data Data sent along with transfer request.
421 	 */
422 	function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
423 		// validate the address and balance
424 		require(_to != address(0));
425 		require(_value <= balances[msg.sender]);
426 
427 		// SafeMath.sub will throw if there is not enough balance.
428 		balances[msg.sender] = balances[msg.sender].sub(_value);
429 		balances[_to] = balances[_to].add(_value);
430 
431 		// call fallback function of contract
432 		ERC223Receiver receiver = ERC223Receiver(_to);
433 		receiver.tokenFallback(msg.sender, _value, _data);
434 		
435 		// Log the transfer event
436 		Transfer(msg.sender, _to, _value, _data);
437 		return true;
438 	}
439 }
440 
441 /**
442 * @title PalestinoToken
443 * @dev Very simple ERC23 Token example, where all tokens are pre-assigned to the creator.
444 */
445 contract PalestinoToken is ERC223Token, Ownable {
446 
447 	string public constant name = "Palestino";
448 	string public constant symbol = "PALE";
449 	uint256 public constant decimals = 3;
450 
451 	uint256 constant INITIAL_SUPPLY = 10000000 * 1E3;
452 	
453 	/**
454 	* @dev Constructor that gives msg.sender all of existing tokens.
455 	*/
456 	function PalestinoToken() public {
457 		totalSupply = INITIAL_SUPPLY;
458 		balances[msg.sender] = INITIAL_SUPPLY;
459 	}
460 
461 	/**
462 	* @dev if ether is sent to this address, send it back.
463 	*/
464 	function () public {
465 		revert();
466 	}
467 }
468 
469 /**
470 * @title PalestinoTokenSale
471 * @dev This is ICO Contract. 
472 * This class accepts the token address as argument to talk with contract.
473 * Once contract is deployed, funds are transferred to ICO smart contract address and then distributed with investor.
474 * Sending funds to this ensures that no more than desired tokens are sold.
475 */
476 contract PalestinoTokenSale is Ownable, ERC223Receiver {
477 	using SafeMath for uint256;
478 
479 	// The token being sold, this holds reference to main token contract
480 	PalestinoToken public token;
481 
482 	// timestamp when sale starts
483 	uint256 public startingTimestamp = 1515974400;
484 
485 	// amount of token to be sold on sale
486 	uint256 public maxTokenForSale = 10000000 * 1E3;
487 
488 	// amount of token sold so far
489 	uint256 public totalTokenSold;
490 
491 	// amount of ether raised in sale
492 	uint256 public totalEtherRaised;
493 
494 	// ether raised per wallet
495 	mapping(address => uint256) public etherRaisedPerWallet;
496 
497 	// walle which will receive the ether funding
498 	address public wallet;
499 
500 	// is contract close and ended
501 	bool internal isClose = false;
502 
503 	struct RoundStruct {
504 		uint256 number;
505 		uint256 fromAmount;
506 		uint256 toAmount;
507 		uint256 price;
508 	}
509 
510 	RoundStruct[9] public rounds;
511 
512 	// token purchsae event
513 	event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount, uint256 _timestamp);
514 
515 	// manual transfer by admin for external purchase
516 	event TransferManual(address indexed _from, address indexed _to, uint256 _value, string _message);
517 
518 	/**
519 	* @dev Constructor that initializes token contract with token address in parameter
520 	*/
521 	function PalestinoTokenSale(address _token, address _wallet) public {
522 		// set token
523 		token = PalestinoToken(_token);
524 
525 		// set wallet
526 		wallet = _wallet;
527 
528 		// setup rounds
529 		rounds[0] = RoundStruct(0, 0	    ,  2500000E3, 0.01 ether);
530 		rounds[1] = RoundStruct(1, 2500000E3,  3000000E3, 0.02 ether);
531 		rounds[2] = RoundStruct(2, 3000000E3,  3500000E3, 0.03 ether);
532 		rounds[3] = RoundStruct(3, 3500000E3,  4000000E3, 0.06 ether);
533 		rounds[4] = RoundStruct(4, 4000000E3,  4500000E3, 0.10 ether);
534 		rounds[5] = RoundStruct(5, 4500000E3,  5000000E3, 0.18 ether);
535 		rounds[6] = RoundStruct(6, 5000000E3,  5500000E3, 0.32 ether);
536 		rounds[7] = RoundStruct(7, 5500000E3,  6000000E3, 0.57 ether);
537 		rounds[8] = RoundStruct(8, 6000000E3, 10000000E3, 1.01 ether);
538 	}
539 
540 	/**
541 	 * @dev Function that validates if the purchase is valid by verifying the parameters
542 	 *
543 	 * @param value Amount of ethers sent
544 	 * @param amount Total number of tokens user is trying to buy.
545 	 *
546 	 * @return checks various conditions and returns the bool result indicating validity.
547 	 */
548 	function isValidPurchase(uint256 value, uint256 amount) internal constant returns (bool) {
549 		// check if timestamp is falling in the range
550 		bool validTimestamp = startingTimestamp <= block.timestamp;
551 
552 		// check if value of the ether is valid
553 		bool validValue = value != 0;
554 
555 		// check if the tokens available in contract for sale
556 		bool validAmount = maxTokenForSale.sub(totalTokenSold) >= amount && amount > 0;
557 
558 		// validate if all conditions are met
559 		return validTimestamp && validValue && validAmount && !isClose;
560 	}
561 
562 	/**
563 	 * @dev Function that returns the current round
564 	 *
565 	 * @return checks various conditions and returns the current round.
566 	 */
567 	function getCurrentRound() public constant returns (RoundStruct) {
568 		for(uint256 i = 0 ; i < rounds.length ; i ++) {
569 			if(rounds[i].fromAmount <= totalTokenSold && totalTokenSold < rounds[i].toAmount) {
570 				return rounds[i];
571 			}
572 		}
573 	}
574 
575 	/**
576 	 * @dev Function that returns the estimate token round by sending amount
577 	 *
578 	 * @param amount Amount of tokens expected
579 	 *
580 	 * @return checks various conditions and returns the estimate token round.
581 	 */
582 	function getEstimatedRound(uint256 amount) public constant returns (RoundStruct) {
583 		for(uint256 i = 0 ; i < rounds.length ; i ++) {
584 			if(rounds[i].fromAmount > (totalTokenSold + amount)) {
585 				return rounds[i - 1];
586 			}
587 		}
588 
589 		return rounds[rounds.length - 1];
590 	}
591 
592 	/**
593 	 * @dev Function that returns the maximum token round by sending amount
594 	 *
595 	 * @param amount Amount of tokens expected
596 	 *
597 	 * @return checks various conditions and returns the maximum token round.
598 	 */
599 	function getMaximumRound(uint256 amount) public constant returns (RoundStruct) {
600 		for(uint256 i = 0 ; i < rounds.length ; i ++) {
601 			if((totalTokenSold + amount) <= rounds[i].toAmount) {
602 				return rounds[i];
603 			}
604 		}
605 	}
606 
607 	/**
608 	 * @dev Function that calculates the tokens which should be given to user by iterating over rounds
609 	 *
610 	 * @param value Amount of ethers sent
611 	 *
612 	 * @return checks various conditions and returns the token amount.
613 	 */
614 	function getTokenAmount(uint256 value) public constant returns (uint256 , uint256) {
615 		// assume we are sending no tokens	
616 		uint256 totalAmount = 0;
617 
618 		// interate until we have some value left for buying
619 		while(value > 0) {
620 			
621 			// get current round by passing queue value also 
622 			RoundStruct memory estimatedRound = getEstimatedRound(totalAmount);
623 			// find tokens left in current round.
624 			uint256 tokensLeft = estimatedRound.toAmount.sub(totalTokenSold.add(totalAmount));
625 
626 			// derive tokens can be bought in current round with round price 
627 			uint256 tokensBuys = value.mul(1E3).div(estimatedRound.price);
628 
629 			// check if it is last round and still value left
630 			if(estimatedRound.number == rounds[rounds.length - 1].number) {
631 				// its last round 
632 
633 				// no tokens left in round and still got value 
634 				if(tokensLeft == 0 && value > 0) {
635 					return (totalAmount , value);
636 				}
637 			}
638 
639 			// if tokens left > tokens buy 
640 			if(tokensLeft >= tokensBuys) {
641 				totalAmount = totalAmount.add(tokensBuys);
642 				value = 0;
643 				return (totalAmount , value);
644 			} else {
645 				uint256 tokensLeftValue = tokensLeft.mul(estimatedRound.price).div(1E3);
646 				totalAmount = totalAmount.add(tokensLeft);
647 				value = value.sub(tokensLeftValue);
648 			}
649 		}
650 
651 		return (0 , value);
652 	}
653 	
654 	/**
655 	 * @dev Default fallback method which will be called when any ethers are sent to contract
656 	 */
657 	function() public payable {
658 		buyTokens(msg.sender);
659 	}
660 
661 	/**
662 	 * @dev Function that is called either externally or by default payable method
663 	 *
664 	 * @param beneficiary who should receive tokens
665 	 */
666 	function buyTokens(address beneficiary) public payable {
667 		require(beneficiary != address(0));
668 
669 		// value sent by buyer
670 		uint256 value = msg.value;
671 
672 		// calculate token amount from the ethers sent
673 		var (amount, leftValue) = getTokenAmount(value);
674 
675 		// if there is any left value then return 
676 		if(leftValue > 0) {
677 			value = value.sub(leftValue);
678 			msg.sender.transfer(leftValue);
679 		}
680 
681 		// validate the purchase
682 		require(isValidPurchase(value , amount));
683 
684 		// update the state to log the sold tokens and raised ethers.
685 		totalTokenSold = totalTokenSold.add(amount);
686 		totalEtherRaised = totalEtherRaised.add(value);
687 		etherRaisedPerWallet[msg.sender] = etherRaisedPerWallet[msg.sender].add(value);
688 
689 		// transfer tokens from contract balance to beneficiary account. calling ERC223 method
690 		bytes memory empty;
691 		token.transfer(beneficiary, amount, empty);
692 		
693 		// log event for token purchase
694 		TokenPurchase(msg.sender, beneficiary, value, amount, now);
695 	}
696 
697 	/**
698 	* @dev transmit token for a specified address. 
699 	* This is owner only method and should be called using web3.js if someone is trying to buy token using bitcoin or any other altcoin.
700 	* 
701 	* @param _to The address to transmit to.
702 	* @param _value The amount to be transferred.
703 	* @param _message message to log after transfer.
704 	*/
705 	function transferManual(address _to, uint256 _value, string _message) onlyOwner public returns (bool) {
706 		require(_to != address(0));
707 
708 		// transfer tokens manually from contract balance
709 		token.transfer(_to , _value);
710 		TransferManual(msg.sender, _to, _value, _message);
711 		return true;
712 	}
713 
714 	/**
715 	* @dev Method called by owner to change the wallet address
716 	*/
717 	function setWallet(address _wallet) onlyOwner public {
718 		wallet = _wallet;
719 	}
720 
721 	/**
722 	* @dev Method called by owner of contract to withdraw funds
723 	*/
724 	function withdraw() onlyOwner public {
725 		wallet.transfer(this.balance);
726 	}
727 
728 	/**
729 	* @dev close contract 
730 	* This will send remaining token balance to owner
731 	* This will distribute available funds across team members
732 	*/	
733 	function close() onlyOwner public {
734 		// send remaining tokens back to owner.
735 		uint256 tokens = token.balanceOf(this); 
736 		token.transfer(owner , tokens);
737 
738 		// withdraw funds 
739 		withdraw();
740 
741 		// mark the flag to indicate closure of the contract
742 		isClose = true;
743 	}
744 }