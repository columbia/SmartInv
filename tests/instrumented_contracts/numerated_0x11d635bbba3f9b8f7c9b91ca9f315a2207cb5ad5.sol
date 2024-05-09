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
42 
43 /**
44  * @title Ownable
45  * @dev The Ownable contract has an owner address, and provides basic authorization control
46  * functions, this simplifies the implementation of "user permissions".
47  */
48 contract Ownable {
49 	address public owner;
50 
51 	// Event to log whenever the ownership is tranferred
52 	event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54 
55 	/**
56 	 * @dev The Ownable constructor sets the original `owner` of the contract to the sender
57 	 * account.
58 	 */
59 	function Ownable() public {
60 		owner = msg.sender;
61 	}
62 
63 
64 	/**
65 	 * @dev Throws if called by any account other than the owner.
66 	 */
67 	modifier onlyOwner() {
68 		require(msg.sender == owner);
69 		_;
70 	}
71 
72 
73 	/**
74 	 * @dev Allows the current owner to transfer control of the contract to a newOwner.
75 	 * @param newOwner The address to transfer ownership to.
76 	 */
77 	function transferOwnership(address newOwner) public onlyOwner {
78 		require(newOwner != address(0));
79 		OwnershipTransferred(owner, newOwner);
80 		owner = newOwner;
81 	}
82 
83 }
84 
85 /**
86  * @title Timestamped
87  * @dev The Timestamped contract has sets dummy timestamp for method calls
88  */
89 contract Timestamped is Ownable {
90 	uint256 public ts = 0;
91 	uint256 public plus = 0;
92 
93 	function getBlockTime() public view returns (uint256) {
94 		if(ts > 0) {
95 			return ts + plus;
96 		} else {
97 			return block.timestamp + plus; 
98 		}
99 	}
100 }
101 
102 /**
103  * @title ERC20Basic
104  * @dev Simpler version of ERC20 interface
105  * @dev see https://github.com/ethereum/EIPs/issues/179
106  */
107 contract ERC20Basic {
108 	uint256 public totalSupply;
109 	function balanceOf(address who) public view returns (uint256);
110 	function transfer(address to, uint256 value) public returns (bool);
111 	event Transfer(address indexed from, address indexed to, uint256 value, bytes data);
112 }
113 
114 
115 /**
116  * @title ERC20 interface
117  * @dev see https://github.com/ethereum/EIPs/issues/20
118  */
119 contract ERC20 is ERC20Basic {
120 	function allowance(address owner, address spender) public view returns (uint256);
121 	function transferFrom(address from, address to, uint256 value) public returns (bool);
122 	function approve(address spender, uint256 value) public returns (bool);
123 	event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 /**
127  * @title Basic token
128  * @dev Basic version of StandardToken, with no allowances.
129  */
130 contract BasicToken is ERC20Basic {
131 	using SafeMath for uint256;
132 
133 	mapping(address => uint256) balances;
134 
135 	/**
136 	* @dev transfer token for a specified address
137 	* @param _to The address to transfer to.
138 	* @param _value The amount to be transferred.
139 	*/
140 	function transfer(address _to, uint256 _value) public returns (bool) {
141 		require(_to != address(0));
142 		require(_value <= balances[msg.sender]);
143 
144 		// SafeMath.sub will throw if there is not enough balance.
145 		balances[msg.sender] = balances[msg.sender].sub(_value);
146 		balances[_to] = balances[_to].add(_value);
147 
148 		bytes memory empty;
149 		Transfer(msg.sender, _to, _value, empty);
150 		return true;
151 	}
152 
153 	/**
154 	* @dev Gets the balance of the specified address.
155 	* @param _owner The address to query the the balance of.
156 	* @return An uint256 representing the amount owned by the passed address.
157 	*/
158 	function balanceOf(address _owner) public view returns (uint256 balance) {
159 		return balances[_owner];
160 	}
161 
162 }
163 
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * @dev https://github.com/ethereum/EIPs/issues/20
170  */
171 contract StandardToken is ERC20, BasicToken {
172 
173 	// tracks the allowance of address. 
174 	mapping (address => mapping (address => uint256)) internal allowed;
175 
176 
177 	/**
178 	 * @dev Transfer tokens from one address to another
179 	 * @param _from address The address which you want to send tokens from
180 	 * @param _to address The address which you want to transfer to
181 	 * @param _value uint256 the amount of tokens to be transferred
182 	 */
183 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
184 		require(_to != address(0));
185 		require(_value <= balances[_from]);
186 		require(_value <= allowed[_from][msg.sender]);
187 
188 		balances[_from] = balances[_from].sub(_value);
189 		balances[_to] = balances[_to].add(_value);
190 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
191 
192 		bytes memory empty;
193 		Transfer(_from, _to, _value, empty);
194 		return true;
195 	}
196 
197 	/**
198 	 * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
199 	 *
200 	 * Beware that changing an allowance with this method brings the risk that someone may use both the old
201 	 * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202 	 * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203 	 * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204 	 * @param _spender The address which will spend the funds.
205 	 * @param _value The amount of tokens to be spent.
206 	 */
207 	function approve(address _spender, uint256 _value) public returns (bool) {
208 		allowed[msg.sender][_spender] = _value;
209 		Approval(msg.sender, _spender, _value);
210 		return true;
211 	}
212 
213 	/**
214 	 * @dev Function to check the amount of tokens that an owner allowed to a spender.
215 	 * @param _owner address The address which owns the funds.
216 	 * @param _spender address The address which will spend the funds.
217 	 * @return A uint256 specifying the amount of tokens still available for the spender.
218 	 */
219 	function allowance(address _owner, address _spender) public view returns (uint256) {
220 		return allowed[_owner][_spender];
221 	}
222 
223 	/**
224 	 * @dev Increase the amount of tokens that an owner allowed to a spender.
225 	 *
226 	 * approve should be called when allowed[_spender] == 0. To increment
227 	 * allowed value is better to use this function to avoid 2 calls (and wait until
228 	 * the first transaction is mined)
229 	 * From MonolithDAO Token.sol
230 	 * @param _spender The address which will spend the funds.
231 	 * @param _addedValue The amount of tokens to increase the allowance by.
232 	 */
233 	function increaseApproval(address _spender, uint256 _addedValue) public returns (bool) {
234 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
235 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
236 		return true;
237 	}
238 
239 	/**
240 	 * @dev Decrease the amount of tokens that an owner allowed to a spender.
241 	 *
242 	 * approve should be called when allowed[_spender] == 0. To decrement
243 	 * allowed value is better to use this function to avoid 2 calls (and wait until
244 	 * the first transaction is mined)
245 	 * From MonolithDAO Token.sol
246 	 * @param _spender The address which will spend the funds.
247 	 * @param _subtractedValue The amount of tokens to decrease the allowance by.
248 	 */
249 	function decreaseApproval(address _spender, uint256 _subtractedValue) public returns (bool) {
250 		uint256 oldValue = allowed[msg.sender][_spender];
251 		if (_subtractedValue > oldValue) {
252 			allowed[msg.sender][_spender] = 0;
253 		} else {
254 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
255 		}
256 		Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
257 		return true;
258 	}
259 
260 }
261 
262 /**
263  * @title ERC23Receiver interface
264  * @dev see https://github.com/ethereum/EIPs/issues/223
265  */
266 contract ERC223Receiver {
267 	 
268 	struct TKN {
269 		address sender;
270 		uint256 value;
271 		bytes data;
272 		bytes4 sig;
273 	}
274 	
275 	/**
276 	 * @dev Fallback function. Our ICO contract should implement this contract to receve ERC23 compatible tokens.
277 	 * ERC23 protocol checks if contract has implemented this fallback method or not. 
278 	 * If this method is not implemented then tokens are not sent.
279 	 * This method is introduced to avoid loss of tokens 
280 	 *
281 	 * @param _from The address which will transfer the tokens.
282 	 * @param _value Amount of tokens received.
283 	 * @param _data Data sent along with transfer request.
284 	 */
285 	function tokenFallback(address _from, uint256 _value, bytes _data) public pure {
286 		TKN memory tkn;
287 		tkn.sender = _from;
288 		tkn.value = _value;
289 		tkn.data = _data;
290 		// uint32 u = uint32(_data[3]) + (uint32(_data[2]) << 8) + (uint32(_data[1]) << 16) + (uint32(_data[0]) << 24);
291 		// tkn.sig = bytes4(u);
292 	  
293 		/* tkn variable is analogue of msg variable of Ether transaction
294 		*  tkn.sender is person who initiated this token transaction   (analogue of msg.sender)
295 		*  tkn.value the number of tokens that were sent   (analogue of msg.value)
296 		*  tkn.data is data of token transaction   (analogue of msg.data)
297 		*  tkn.sig is 4 bytes signature of function
298 		*  if data of token transaction is a function execution
299 		*/
300 	}
301 }
302 
303 /**
304  * @title ERC23 interface
305  * @dev see https://github.com/ethereum/EIPs/issues/223
306  */
307 contract ERC223 {
308 	uint256 public totalSupply;
309 	function balanceOf(address who) public view returns (uint256);
310 	function transfer(address to, uint256 value) public returns (bool);
311 	function transfer(address to, uint256 value, bytes data) public returns (bool);
312 	function transfer(address to, uint256 value, bytes data, string custom_fallback) public returns (bool);
313 	event Transfer(address indexed from, address indexed to, uint256 value, bytes indexed data);
314 }
315 
316 /**
317  * @title Standard ERC223Token token
318  *
319  * @dev Implementation of the ERC23 token.
320  * @dev https://github.com/ethereum/EIPs/issues/223
321  */
322 
323 contract ERC223Token is ERC223, StandardToken {
324 	using SafeMath for uint256;
325 
326 	/**
327 	 * @dev Function that is called when a user or another contract wants to transfer funds .
328 	 * This is method where you can supply fallback function name and that function will be triggered.
329 	 * This method is added as part of ERC23 standard
330 	 *
331 	 * @param _to The address which will receive the tokens.
332 	 * @param _value Amount of tokens received.
333 	 * @param _data Data sent along with transfer request.
334 	 * @param _custom_fallback Name of the method which should be called after transfer happens. If this method does not exists on contract then transaction will fail
335 	 */
336 	function transfer(address _to, uint256 _value, bytes _data, string _custom_fallback) public returns (bool success) {
337 		// check if receiving is contract
338 		if(isContract(_to)) {
339 			// validate the address and balance
340 			require(_to != address(0));
341 			require(_value <= balances[msg.sender]);
342 
343 			// SafeMath.sub will throw if there is not enough balance.
344 			balances[msg.sender] = balances[msg.sender].sub(_value);
345 			balances[_to] = balances[_to].add(_value);
346 	
347 			// invoke custom fallback function			
348 			assert(_to.call.value(0)(bytes4(keccak256(_custom_fallback)), msg.sender, _value, _data));
349 			Transfer(msg.sender, _to, _value, _data);
350 			return true;
351 		}
352 		else {
353 			// receiver is not a contract so perform normal transfer to address
354 			return transferToAddress(_to, _value, _data);
355 		}
356 	}
357   
358 
359 	/**
360 	 * @dev Function that is called when a user or another contract wants to transfer funds .
361 	 * You can pass extra data which can be tracked in event.
362 	 * This method is added as part of ERC23 standard
363 	 *
364 	 * @param _to The address which will receive the tokens.
365 	 * @param _value Amount of tokens received.
366 	 * @param _data Data sent along with transfer request.
367 	 */
368 	function transfer(address _to, uint256 _value, bytes _data) public returns (bool success) {
369 		// check if receiver is contract address
370 		if(isContract(_to)) {
371 			// invoke transfer request to contract
372 			return transferToContract(_to, _value, _data);
373 		}
374 		else {
375 			// invoke transfer request to normal user wallet address
376 			return transferToAddress(_to, _value, _data);
377 		}
378 	}
379   
380 	/**
381 	 * @dev Standard function transfer similar to ERC20 transfer with no _data .
382 	 * Added due to backwards compatibility reasons .
383 	 *
384 	 * @param _to The address which will receive the tokens.
385 	 * @param _value Amount of tokens received.
386 	 */
387 	function transfer(address _to, uint256 _value) public returns (bool success) {
388 		//standard function transfer similar to ERC20 transfer with no _data
389 		//added due to backwards compatibility reasons
390 		bytes memory empty;
391 
392 		// check if receiver is contract address
393 		if(isContract(_to)) {
394 			// invoke transfer request to contract
395 			return transferToContract(_to, _value, empty);
396 		}
397 		else {
398 			// invoke transfer request to normal user wallet address
399 			return transferToAddress(_to, _value, empty);
400 		}
401 	}
402 
403 	/**
404 	 * @dev assemble the given address bytecode. If bytecode exists then the _addr is a contract.
405 	 *
406 	 * @param _addr The address which need to be checked if contract address or wallet address
407 	 */
408 	function isContract(address _addr) private view returns (bool is_contract) {
409 		uint256 length;
410 		assembly {
411 			//retrieve the size of the code on target address, this needs assembly
412 			length := extcodesize(_addr)
413 		}
414 		return (length > 0);
415 	}
416 
417 	/**
418 	 * @dev Function that is called when transaction target is an address. This is private method.
419 	 *
420 	 * @param _to The address which will receive the tokens.
421 	 * @param _value Amount of tokens received.
422 	 * @param _data Data sent along with transfer request.
423 	 */
424 	function transferToAddress(address _to, uint256 _value, bytes _data) private returns (bool success) {
425 		// validate the address and balance
426 		require(_to != address(0));
427 		require(_value <= balances[msg.sender]);
428 
429 		// SafeMath.sub will throw if there is not enough balance.
430 		balances[msg.sender] = balances[msg.sender].sub(_value);
431 		balances[_to] = balances[_to].add(_value);
432 
433 		// Log the transfer event
434 		Transfer(msg.sender, _to, _value, _data);
435 		return true;
436 	}
437   
438 	/**
439 	 * @dev Function that is called when transaction target is a contract. This is private method.
440 	 *
441 	 * @param _to The address which will receive the tokens.
442 	 * @param _value Amount of tokens received.
443 	 * @param _data Data sent along with transfer request.
444 	 */
445 	function transferToContract(address _to, uint256 _value, bytes _data) private returns (bool success) {
446 		// validate the address and balance
447 		require(_to != address(0));
448 		require(_value <= balances[msg.sender]);
449 
450 		// SafeMath.sub will throw if there is not enough balance.
451 		balances[msg.sender] = balances[msg.sender].sub(_value);
452 		balances[_to] = balances[_to].add(_value);
453 
454 		// call fallback function of contract
455 		ERC223Receiver receiver = ERC223Receiver(_to);
456 		receiver.tokenFallback(msg.sender, _value, _data);
457 		
458 		// Log the transfer event
459 		Transfer(msg.sender, _to, _value, _data);
460 		return true;
461 	}
462 }
463 
464 /**
465 * @title dHealthToken
466 * @dev Very simple ERC23 Token example, where all tokens are pre-assigned to the creator.
467 */
468 contract dHealthToken is ERC223Token, Ownable {
469 
470 	string public constant name = "dHealth";
471 	string public constant symbol = "dHt";
472 	uint256 public constant decimals = 18;
473 
474 	uint256 constant INITIAL_SUPPLY = 500000000 * 1E18;
475 	
476 	/**
477 	* @dev Constructor that gives msg.sender all of existing tokens.
478 	*/
479 	function dHealthToken() public {
480 		totalSupply = INITIAL_SUPPLY;
481 		balances[msg.sender] = INITIAL_SUPPLY;
482 	}
483 
484 	/**
485 	* @dev if ether is sent to this address, send it back.
486 	*/
487 	function() public payable {
488 		revert();
489 	}
490 }
491 
492 /**
493  * @title dHealthTokenDistributor
494  * @dev The Distributor contract has an list of team member addresses and their share, 
495  * and provides method which can be called to distribute available smart contract balance across users.
496  */
497 contract dHealthTokenDistributor is Ownable, Timestamped {
498 	using SafeMath for uint256;
499 
500 	// The token being sold, this holds reference to main token contract
501 	dHealthToken public token;
502 
503 	// token vesting contract addresses
504 	address public communityContract;
505 	address public foundersContract;
506 	address public technicalContract;
507 	address public managementContract;
508 
509 	// token vesting contract amounts
510 	uint256 public communityAmount;
511 	uint256 public foundersAmount;
512 	uint256 public technicalAmount;
513 	uint256 public managementAmount;
514 
515 	/**
516 	* @dev Constructor that initializes team and share
517 	*/
518 	function dHealthTokenDistributor(address _token, address _communityContract, address _foundersContract, address _technicalContract, address _managementContract) public {
519 		// set token
520 		token = dHealthToken(_token);
521 
522 		// initialize contract addresses
523 		communityContract = _communityContract;
524 		foundersContract = _foundersContract;
525 		technicalContract = _technicalContract;
526 		managementContract = _managementContract;
527 
528 		// initialize precentage share
529 		communityAmount = 10000000 * 1E18;
530 		foundersAmount = 15000000 * 1E18;
531 		technicalAmount = 55000000 * 1E18;
532 		managementAmount = 60000000 * 1E18;
533 	}
534 
535 	/**
536 	* @dev distribute funds.
537 	*/	
538 	function distribute() onlyOwner public payable {
539 		bytes memory empty;
540 
541 		// distribute funds to community 		
542 		token.transfer(communityContract, communityAmount, empty);
543 
544 		// distribute funds to founders 		
545 		token.transfer(foundersContract, foundersAmount, empty);
546 
547 		// distribute funds to technical 		
548 		token.transfer(technicalContract, technicalAmount, empty);
549 
550 		// distribute funds to management 		
551 		token.transfer(managementContract, managementAmount, empty);
552 	}
553 }
554 
555 /**
556  * @title dHealthEtherDistributor
557  * @dev The Distributor contract has an list of team member addresses and their share, 
558  * and provides method which can be called to distribute available smart contract balance across users.
559  */
560 contract dHealthEtherDistributor is Ownable, Timestamped {
561 	using SafeMath for uint256;
562 
563 	address public projectContract;	
564 	address public technologyContract;	
565 	address public founderContract;	
566 
567 	uint256 public projectShare;
568 	uint256 public technologyShare;
569 	uint256 public founderShare;
570 
571 	/**
572 	* @dev Constructor that initializes team and share
573 	*/
574 	function dHealthEtherDistributor(address _projectContract, address _technologyContract, address _founderContract) public {
575 
576 		// initialize contract addresses
577 		projectContract = _projectContract;	
578 		technologyContract = _technologyContract;	
579 		founderContract = _founderContract;	
580 
581 		// initialize precentage share
582 		projectShare = 72;
583 		technologyShare = 18;
584 		founderShare = 10;
585 	}
586 
587 	/**
588 	* @dev distribute funds.
589 	*/	
590 	function distribute() onlyOwner public payable {
591 		uint256 balance = this.balance;
592 		
593 		// distribute funds to founders 		
594 		uint256 founderPart = balance.mul(founderShare).div(100);
595 		if(founderPart > 0) {
596 			founderContract.transfer(founderPart);
597 		}
598 
599 		// distribute funds to technology 		
600 		uint256 technologyPart = balance.mul(technologyShare).div(100);
601 		if(technologyPart > 0) {
602 			technologyContract.transfer(technologyPart);
603 		}
604 
605 		// distribute left balance to project
606 		uint256 projectPart = this.balance;
607 		if(projectPart > 0) {
608 			projectContract.transfer(projectPart);
609 		}
610 	}
611 }
612 
613 /**
614 * @title dHealthTokenIncentive
615 * @dev This is token incentive contract it receives tokens and holds it for certain period of time
616 */
617 contract dHealthTokenIncentive is dHealthTokenDistributor, ERC223Receiver {
618 	using SafeMath for uint256;
619 
620 	// The token being sold, this holds reference to main token contract
621 	dHealthToken public token;
622 
623 	// amount of token on hold
624 	uint256 public maxTokenForHold = 140000000 * 1E18;
625 
626 	// contract timeout 
627 	uint256 public contractTimeout = 1555286400; // Monday, 15 April 2019 00:00:00
628 
629 	/**
630 	* @dev Constructor that initializes vesting contract with contract addresses in parameter
631 	*/
632 	function dHealthTokenIncentive(address _token, address _communityContract, address _foundersContract, address _technicalContract, address _managementContract) 
633 		dHealthTokenDistributor(_token, _communityContract, _foundersContract, _technicalContract, _managementContract)
634 		public {
635 		// set token
636 		token = dHealthToken(_token);
637 	}
638 
639 	/**
640 	* @dev Method called by owner of contract to withdraw all tokens after timeout has reached
641 	*/
642 	function withdraw() onlyOwner public {
643 		require(contractTimeout <= getBlockTime());
644 		
645 		// send remaining tokens back to owner.
646 		uint256 tokens = token.balanceOf(this); 
647 		bytes memory empty;
648 		token.transfer(owner, tokens, empty);
649 	}
650 }
651 
652 /**
653 * @title dHealthTokenGrowth
654 * @dev This is token growth contract it receives tokens and holds it for certain period of time
655 */
656 contract dHealthTokenGrowth is Ownable, ERC223Receiver, Timestamped {
657 	using SafeMath for uint256;
658 
659 	// The token being sold, this holds reference to main token contract
660 	dHealthToken public token;
661 
662 	// amount of token on hold
663 	uint256 public maxTokenForHold = 180000000 * 1E18;
664 
665 	// exchanges wallet address
666 	address public exchangesWallet;
667 	uint256 public exchangesTokens = 45000000 * 1E18;
668 	uint256 public exchangesLockEndingAt = 1523750400; // Sunday, 15 April 2018 00:00:00
669 	bool public exchangesStatus = false;
670 
671 	// countries wallet address
672 	address public countriesWallet;
673 	uint256 public countriesTokens = 45000000 * 1E18;
674 	uint256 public countriesLockEndingAt = 1525132800; // Tuesday, 1 May 2018 00:00:00
675 	bool public countriesStatus = false;
676 
677 	// acquisitions wallet address
678 	address public acquisitionsWallet;
679 	uint256 public acquisitionsTokens = 45000000 * 1E18;
680 	uint256 public acquisitionsLockEndingAt = 1526342400; // Tuesday, 15 May 2018 00:00:00
681 	bool public acquisitionsStatus = false;
682 
683 	// coindrops wallet address
684 	address public coindropsWallet;
685 	uint256 public coindropsTokens = 45000000 * 1E18;
686 	uint256 public coindropsLockEndingAt = 1527811200; // Friday, 1 June 2018 00:00:00
687 	bool public coindropsStatus = false;
688 
689 	// contract timeout 
690 	uint256 public contractTimeout = 1555286400; // Monday, 15 April 2019 00:00:00
691 
692 	/**
693 	* @dev Constructor that initializes vesting contract with contract addresses in parameter
694 	*/
695 	function dHealthTokenGrowth(address _token, address _exchangesWallet, address _countriesWallet, address _acquisitionsWallet, address _coindropsWallet) public {
696 		// set token
697 		token = dHealthToken(_token);
698 
699 		// setup wallet addresses
700 		exchangesWallet = _exchangesWallet;
701 		countriesWallet = _countriesWallet;
702 		acquisitionsWallet = _acquisitionsWallet;
703 		coindropsWallet = _coindropsWallet;
704 	}
705 
706 	/**
707 	* @dev Method called by anyone to withdraw funds to exchanges wallet after locking period
708 	*/
709 	function withdrawExchangesToken() public {
710 		// check if time has reached
711 		require(exchangesLockEndingAt <= getBlockTime());
712 		// ensure that tokens are not already transferred
713 		require(exchangesStatus == false);
714 		
715 		// transfer tokens to wallet and change status to prevent double transfer		
716 		bytes memory empty;
717 		token.transfer(exchangesWallet, exchangesTokens, empty);
718 		exchangesStatus = true;
719 	}
720 
721 	/**
722 	* @dev Method called by anyone to withdraw funds to countries wallet after locking period
723 	*/
724 	function withdrawCountriesToken() public {
725 		// check if time has reached
726 		require(countriesLockEndingAt <= getBlockTime());
727 		// ensure that tokens are not already transferred
728 		require(countriesStatus == false);
729 		
730 		// transfer tokens to wallet and change status to prevent double transfer		
731 		bytes memory empty;
732 		token.transfer(countriesWallet, countriesTokens, empty);
733 		countriesStatus = true;
734 	}
735 
736 	/**
737 	* @dev Method called by anyone to withdraw funds to acquisitions wallet after locking period
738 	*/
739 	function withdrawAcquisitionsToken() public {
740 		// check if time has reached
741 		require(acquisitionsLockEndingAt <= getBlockTime());
742 		// ensure that tokens are not already transferred
743 		require(acquisitionsStatus == false);
744 		
745 		// transfer tokens to wallet and change status to prevent double transfer		
746 		bytes memory empty;
747 		token.transfer(acquisitionsWallet, acquisitionsTokens, empty);
748 		acquisitionsStatus = true;
749 	}
750 
751 	/**
752 	* @dev Method called by anyone to withdraw funds to coindrops wallet after locking period
753 	*/
754 	function withdrawCoindropsToken() public {
755 		// check if time has reached
756 		require(coindropsLockEndingAt <= getBlockTime());
757 		// ensure that tokens are not already transferred
758 		require(coindropsStatus == false);
759 		
760 		// transfer tokens to wallet and change status to prevent double transfer		
761 		bytes memory empty;
762 		token.transfer(coindropsWallet, coindropsTokens, empty);
763 		coindropsStatus = true;
764 	}
765 
766 	/**
767 	* @dev Method called by owner of contract to withdraw all tokens after timeout has reached
768 	*/
769 	function withdraw() onlyOwner public {
770 		require(contractTimeout <= getBlockTime());
771 		
772 		// send remaining tokens back to owner.
773 		uint256 tokens = token.balanceOf(this); 
774 		bytes memory empty;
775 		token.transfer(owner, tokens, empty);
776 	}
777 }
778 
779 
780 /**
781 * @title dHealthTokenSale
782 * @dev This is ICO Contract. 
783 * This class accepts the token address as argument to talk with contract.
784 * Once contract is deployed, funds are transferred to ICO smart contract address and then distributed with investor.
785 * Sending funds to this ensures that no more than desired tokens are sold.
786 */
787 contract dHealthTokenSale is dHealthEtherDistributor, ERC223Receiver {
788 	using SafeMath for uint256;
789 
790 	// The token being sold, this holds reference to main token contract
791 	dHealthToken public token;
792 
793 	// amount of token to be sold on sale
794 	uint256 public maxTokenForSale = 180000000 * 1E18;
795 
796 	// timestamp when phase 1 starts
797 	uint256 public phase1StartingAt = 1516924800; // Friday, 26 January 2018 00:00:00
798 	uint256 public phase1EndingAt = 1518134399; // Thursday, 8 February 2018 23:59:59
799 	uint256 public phase1MaxTokenForSale = maxTokenForSale * 1 / 3;
800 	uint256 public phase1TokenPriceInEth = 0.0005 ether;
801 	uint256 public phase1TokenSold = 0;
802 
803 	// timestamp when phase 2 starts
804 	uint256 public phase2StartingAt = 1518134400; // Friday, 9 February 2018 00:00:00
805 	uint256 public phase2EndingAt = 1519343999; // Thursday, 22 February 2018 23:59:59
806 	uint256 public phase2MaxTokenForSale = maxTokenForSale * 2 / 3;
807 	uint256 public phase2TokenPriceInEth = 0.000606060606 ether;
808 	uint256 public phase2TokenSold = 0;
809 
810 	// timestamp when phase 3 starts
811 	uint256 public phase3StartingAt = 1519344000; // Friday, 23 February 2018 00:00:00
812 	uint256 public phase3EndingAt = 1520553599; // Thursday, 8 March 2018 23:59:59
813 	uint256 public phase3MaxTokenForSale = maxTokenForSale;
814 	uint256 public phase3TokenPriceInEth = 0.000769230769 ether;
815 	uint256 public phase3TokenSold = 0;
816 
817 	// contract timeout to initiate left funds and token transfer
818 	uint256 public contractTimeout = 1520553600; // Friday, 9 March 2018 00:00:00
819 
820 	// growth contract address
821 	address public growthContract;
822 
823 	// maximum ether invested per transaction
824 	uint256 public maxEthPerTransaction = 1000 ether;
825 
826 	// minimum ether invested per transaction
827 	uint256 public minEthPerTransaction = 0.01 ether;
828 
829 	// amount of token sold so far
830 	uint256 public totalTokenSold;
831 
832 	// amount of ether raised in sale
833 	uint256 public totalEtherRaised;
834 
835 	// ether raised per wallet
836 	mapping(address => uint256) public etherRaisedPerWallet;
837 
838 	// is contract close and ended
839 	bool public isClose = false;
840 
841 	// is contract paused
842 	bool public isPaused = false;
843 
844 	// token purchsae event
845 	event TokenPurchase(address indexed _purchaser, address indexed _beneficiary, uint256 _value, uint256 _amount, uint256 _timestamp);
846 
847 	// manual transfer by admin for external purchase
848 	event TransferManual(address indexed _from, address indexed _to, uint256 _value, string _message);
849 
850 	/**
851 	* @dev Constructor that initializes token contract with token address in parameter
852 	*/
853 	function dHealthTokenSale(address _token, address _projectContract, address _technologyContract, address _founderContract, address _growthContract)
854 		dHealthEtherDistributor(_projectContract, _technologyContract, _founderContract)
855 		public {
856 		// set token
857 		token = dHealthToken(_token);
858 
859 		// set growth contract address
860 		growthContract = _growthContract;
861 	}
862 
863 	/**
864 	 * @dev Function that validates if the purchase is valid by verifying the parameters
865 	 *
866 	 * @param value Amount of ethers sent
867 	 * @param amount Total number of tokens user is trying to buy.
868 	 *
869 	 * @return checks various conditions and returns the bool result indicating validity.
870 	 */
871 	function validate(uint256 value, uint256 amount) internal constant returns (bool) {
872 		// check if timestamp and amount is falling in the range
873 		bool validTimestamp = false;
874 		bool validAmount = false;
875 
876 		// check if phase 1 is running	
877 		if(phase1StartingAt <= getBlockTime() && getBlockTime() <= phase1EndingAt) {
878 			// check if tokens is falling in timerange
879 			validTimestamp = true;
880 
881 			// check if token amount is falling in limit
882 			validAmount = phase1MaxTokenForSale.sub(totalTokenSold) >= amount;
883 		}
884 
885 		// check if phase 2 is running	
886 		if(phase2StartingAt <= getBlockTime() && getBlockTime() <= phase2EndingAt) {
887 			// check if tokens is falling in timerange
888 			validTimestamp = true;
889 
890 			// check if token amount is falling in limit
891 			validAmount = phase2MaxTokenForSale.sub(totalTokenSold) >= amount;
892 		}
893 
894 		// check if phase 3 is running	
895 		if(phase3StartingAt <= getBlockTime() && getBlockTime() <= phase3EndingAt) {
896 			// check if tokens is falling in timerange
897 			validTimestamp = true;
898 
899 			// check if token amount is falling in limit
900 			validAmount = phase3MaxTokenForSale.sub(totalTokenSold) >= amount;
901 		}
902 
903 		// check if value of the ether is valid
904 		bool validValue = value != 0;
905 
906 		// check if the tokens available in contract for sale
907 		bool validToken = amount != 0;
908 
909 		// validate if all conditions are met
910 		return validTimestamp && validAmount && validValue && validToken && !isClose && !isPaused;
911 	}
912 
913 	function calculate(uint256 value) internal constant returns (uint256) {
914 		uint256 amount = 0;
915 			
916 		// check if phase 1 is running	
917 		if(phase1StartingAt <= getBlockTime() && getBlockTime() <= phase1EndingAt) {
918 			// calculate the amount of tokens
919 			amount = value.mul(1E18).div(phase1TokenPriceInEth);
920 		}
921 
922 		// check if phase 2 is running	
923 		if(phase2StartingAt <= getBlockTime() && getBlockTime() <= phase2EndingAt) {
924 			// calculate the amount of tokens
925 			amount = value.mul(1E18).div(phase2TokenPriceInEth);
926 		}
927 
928 		// check if phase 3 is running	
929 		if(phase3StartingAt <= getBlockTime() && getBlockTime() <= phase3EndingAt) {
930 			// calculate the amount of tokens
931 			amount = value.mul(1E18).div(phase3TokenPriceInEth);
932 		}
933 
934 		return amount;
935 	}
936 
937 	function update(uint256 value, uint256 amount) internal returns (bool) {
938 
939 		// update the state to log the sold tokens and raised ethers.
940 		totalTokenSold = totalTokenSold.add(amount);
941 		totalEtherRaised = totalEtherRaised.add(value);
942 		etherRaisedPerWallet[msg.sender] = etherRaisedPerWallet[msg.sender].add(value);
943 
944 		// check if phase 1 is running	
945 		if(phase1StartingAt <= getBlockTime() && getBlockTime() <= phase1EndingAt) {
946 			// add tokens to phase1 counts
947 			phase1TokenSold = phase1TokenSold.add(amount);
948 		}
949 
950 		// check if phase 2 is running	
951 		if(phase2StartingAt <= getBlockTime() && getBlockTime() <= phase2EndingAt) {
952 			// add tokens to phase2 counts
953 			phase2TokenSold = phase2TokenSold.add(amount);
954 		}
955 
956 		// check if phase 3 is running	
957 		if(phase3StartingAt <= getBlockTime() && getBlockTime() <= phase3EndingAt) {
958 			// add tokens to phase3 counts
959 			phase3TokenSold = phase3TokenSold.add(amount);
960 		}
961 	}
962 
963 	/**
964 	 * @dev Default fallback method which will be called when any ethers are sent to contract
965 	 */
966 	function() public payable {
967 		buy(msg.sender);
968 	}
969 
970 	/**
971 	 * @dev Function that is called either externally or by default payable method
972 	 *
973 	 * @param beneficiary who should receive tokens
974 	 */
975 	function buy(address beneficiary) public payable {
976 		require(beneficiary != address(0));
977 
978 		// amount of ethers sent
979 		uint256 value = msg.value;
980 
981 		// throw error if not enough ethers sent
982 		require(value >= minEthPerTransaction);
983 
984 		// refund the extra ethers if sent more than allowed
985 		if(value > maxEthPerTransaction) {
986 			// more ethers are sent so refund extra
987 			msg.sender.transfer(value.sub(maxEthPerTransaction));
988 			value = maxEthPerTransaction;
989 		}
990 		
991 		// calculate tokens
992 		uint256 tokens = calculate(value);
993 
994 		// validate the purchase
995 		require(validate(value , tokens));
996 
997 		// update current state 
998 		update(value , tokens);
999 		
1000 		// transfer tokens from contract balance to beneficiary account. calling ERC223 method
1001 		bytes memory empty;
1002 		token.transfer(beneficiary, tokens, empty);
1003 		
1004 		// log event for token purchase
1005 		TokenPurchase(msg.sender, beneficiary, value, tokens, now);
1006 	}
1007 
1008 	/**
1009 	* @dev transmit token for a specified address. 
1010 	* This is owner only method and should be called using web3.js if someone is trying to buy token using bitcoin or any other altcoin.
1011 	* 
1012 	* @param _to The address to transmit to.
1013 	* @param _value The amount to be transferred.
1014 	* @param _message message to log after transfer.
1015 	*/
1016 	function transferManual(address _to, uint256 _value, string _message) onlyOwner public returns (bool) {
1017 		require(_to != address(0));
1018 
1019 		// transfer tokens manually from contract balance
1020 		token.transfer(_to , _value);
1021 		TransferManual(msg.sender, _to, _value, _message);
1022 		return true;
1023 	}
1024 
1025 	/**
1026 	* @dev sendToGrowthContract  
1027 	* This will send remaining tokens to growth contract
1028 	*/	
1029 	function sendToGrowthContract() onlyOwner public {
1030 		require(contractTimeout <= getBlockTime());
1031 
1032 		// send remaining tokens to growth contract.
1033 		uint256 tokens = token.balanceOf(this); 
1034 		bytes memory empty;
1035 		token.transfer(growthContract, tokens, empty);
1036 	}
1037 
1038 	/**
1039 	* @dev sendToVestingContract  
1040 	* This will transfer any available ethers to vesting contracts
1041 	*/	
1042 	function sendToVestingContract() onlyOwner public {
1043 		// distribute funds 
1044 		distribute();
1045 	}
1046 
1047 	/**
1048 	* @dev withdraw funds and tokens 
1049 	* This will send remaining token balance to growth contract
1050 	* This will distribute available funds across team members
1051 	*/	
1052 	function withdraw() onlyOwner public {
1053 		require(contractTimeout <= getBlockTime());
1054 
1055 		// send remaining tokens to growth contract.
1056 		uint256 tokens = token.balanceOf(this); 
1057 		bytes memory empty;
1058 		token.transfer(growthContract, tokens, empty);
1059 
1060 		// distribute funds 
1061 		distribute();
1062 	}
1063 
1064 	/**
1065 	* @dev close contract 
1066 	* This will mark contract as closed
1067 	*/	
1068 	function close() onlyOwner public {
1069 		// mark the flag to indicate closure of the contract
1070 		isClose = true;
1071 	}
1072 
1073 	/**
1074 	* @dev pause contract 
1075 	* This will mark contract as paused
1076 	*/	
1077 	function pause() onlyOwner public {
1078 		// mark the flag to indicate pause of the contract
1079 		isPaused = true;
1080 	}
1081 
1082 	/**
1083 	* @dev resume contract 
1084 	* This will mark contract as resumed
1085 	*/	
1086 	function resume() onlyOwner public {
1087 		// mark the flag to indicate resume of the contract
1088 		isPaused = false;
1089 	}
1090 }
1091 
1092 /**
1093 * @title dHealthEtherVesting
1094 * @dev This is vesting contract it receives funds and those are used to release funds to fixed address
1095 */
1096 contract dHealthEtherVesting is Ownable, Timestamped {
1097 	using SafeMath for uint256;
1098 
1099 	// wallet address which will receive funds on pay
1100 	address public wallet;
1101 
1102 	// timestamp when vesting contract starts, this timestamp matches with sale contract
1103 	uint256 public startingAt = 1516924800; // Friday, 26 January 2018 00:00:00
1104 
1105 	// timestamp when vesting ends
1106 	uint256 public endingAt = startingAt + 540 days;
1107 
1108 	// how many % of ethers to vest on each call
1109 	uint256 public vestingAmount = 20;
1110 
1111 	// timestamp when vesting starts
1112 	uint256 public vestingPeriodLength = 30 days;
1113 
1114 	// time after which owner can withdraw all available funds
1115 	uint256 public contractTimeout = startingAt + 2 years;
1116 
1117 	// mapping that defines vesting structure
1118 	struct VestingStruct {
1119 		uint256 period; 
1120 		bool status;
1121 		address wallet;
1122 		uint256 amount;
1123 		uint256 timestamp;
1124 	}
1125 
1126 	// vesting that tracks vestings done against the period.
1127 	mapping (uint256 => VestingStruct) public vestings;
1128 
1129 	// Event to log whenever the payment is done
1130 	event Payouts(uint256 indexed period, bool status, address wallet, uint256 amount, uint256 timestamp);
1131 
1132 	/**
1133 	* @dev Constructor that does nothing 
1134 	*/
1135 	function dHealthEtherVesting(address _wallet) public {
1136 		wallet = _wallet;
1137 	}
1138 
1139 	/**
1140 	* @dev default payable method to receive funds
1141 	*/
1142 	function() public payable {
1143 		
1144 	}
1145 
1146 	/**
1147 	* @dev Method called by owner of contract to withdraw funds
1148 	*/
1149 	function pay(uint256 percentage) public payable {
1150 		// requested amount should always be less than vestingAmount variable
1151 		percentage = percentage <= vestingAmount ? percentage : vestingAmount;
1152 
1153 		// calculate amount allowed
1154 		var (period, amount) = calculate(getBlockTime() , this.balance , percentage);
1155 
1156 		// payment should not be done if period is zero
1157 		require(period > 0);
1158 		// payment should not be done already
1159 		require(vestings[period].status == false);
1160 		// wallet should not be set already.
1161 		require(vestings[period].wallet == address(0));
1162 		// there should be amount to pay
1163 		require(amount > 0);
1164 
1165 		// set period for storage
1166 		vestings[period].period = period;
1167 		// set status to avoid double payment
1168 		vestings[period].status = true;
1169 		// set wallet to track where payment was sent
1170 		vestings[period].wallet = wallet;
1171 		// set wallet to track how much amount sent
1172 		vestings[period].amount = amount;
1173 		// set timestamp of payment
1174 		vestings[period].timestamp = getBlockTime();
1175 
1176 		// transfer amount to wallet address
1177 		wallet.transfer(amount);
1178 
1179 		// log event
1180 		Payouts(period, vestings[period].status, vestings[period].wallet, vestings[period].amount, vestings[period].timestamp);
1181 	}
1182 
1183 	/**
1184 	* @dev Internal method called to current vesting period
1185 	*/
1186 	function getPeriod(uint256 timestamp) public view returns (uint256) {
1187 		for(uint256 i = 1 ; i <= 18 ; i ++) {
1188 			// calculate timestamp range
1189 			uint256 startTime = startingAt + (vestingPeriodLength * (i - 1));
1190 			uint256 endTime = startingAt + (vestingPeriodLength * (i));
1191 
1192 			if(startTime <= timestamp && timestamp < endTime) {
1193 				return i;
1194 			}
1195 		}
1196 
1197 		// calculate timestamp of last period
1198 		uint256 lastEndTime = startingAt + (vestingPeriodLength * (18));
1199 		if(lastEndTime <= timestamp) {
1200 			return 18;
1201 		}
1202 
1203 		return 0;
1204 	}
1205 
1206 	/**
1207 	* @dev Internal method called to current vesting period range
1208 	*/
1209 	function getPeriodRange(uint256 timestamp) public view returns (uint256 , uint256) {
1210 		for(uint256 i = 1 ; i <= 18 ; i ++) {
1211 			// calculate timestamp range
1212 			uint256 startTime = startingAt + (vestingPeriodLength * (i - 1));
1213 			uint256 endTime = startingAt + (vestingPeriodLength * (i));
1214 
1215 			if(startTime <= timestamp && timestamp < endTime) {
1216 				return (startTime , endTime);
1217 			}
1218 		}
1219 
1220 		// calculate timestamp of last period
1221 		uint256 lastStartTime = startingAt + (vestingPeriodLength * (17));
1222 		uint256 lastEndTime = startingAt + (vestingPeriodLength * (18));
1223 		if(lastEndTime <= timestamp) {
1224 			return (lastStartTime , lastEndTime);
1225 		}
1226 
1227 		return (0 , 0);
1228 	}
1229 
1230 	/**
1231 	* @dev Internal method called to calculate withdrawal amount
1232 	*/
1233 	function calculate(uint256 timestamp, uint256 balance , uint256 percentage) public view returns (uint256 , uint256) {
1234 		// find out current vesting period
1235 		uint256 period = getPeriod(timestamp);
1236 		if(period == 0) {
1237 			// if period is not found then return zero;
1238 			return (0 , 0);
1239 		}
1240 
1241 		// get vesting object for period
1242 		VestingStruct memory vesting = vestings[period];	
1243 		
1244 		// check if payment is already done
1245 		if(vesting.status == false) {
1246 			// payment is not done yet
1247 			uint256 amount;
1248 
1249 			// if it is last month then send all remaining balance
1250 			if(period == 18) {
1251 				// send all
1252 				amount = balance;
1253 			} else {
1254 				// calculate percentage and send
1255 				amount = balance.mul(percentage).div(100);
1256 			}
1257 			
1258 			return (period, amount);
1259 		} else {
1260 			// payment is already done 
1261 			return (period, 0);
1262 		}		
1263 	}
1264 
1265 	/**
1266 	* @dev Method called by owner to change the wallet address
1267 	*/
1268 	function setWallet(address _wallet) onlyOwner public {
1269 		wallet = _wallet;
1270 	}
1271 
1272 	/**
1273 	* @dev Method called by owner of contract to withdraw funds after timeout has reached
1274 	*/
1275 	function withdraw() onlyOwner public payable {
1276 		require(contractTimeout <= getBlockTime());
1277 		owner.transfer(this.balance);
1278 	}	
1279 }
1280 
1281 
1282 /**
1283 * @title dHealthTokenVesting
1284 * @dev This is vesting contract it receives tokens and those are used to release tokens to fixed address
1285 */
1286 contract dHealthTokenVesting is Ownable, Timestamped {
1287 	using SafeMath for uint256;
1288 
1289 	// The token being sold, this holds reference to main token contract
1290 	dHealthToken public token;
1291 
1292 	// wallet address which will receive tokens on pay
1293 	address public wallet;
1294 
1295 	// amount of token to be hold
1296 	uint256 public maxTokenForHold;
1297 
1298 	// timestamp when vesting contract starts, this timestamp matches with sale contract
1299 	uint256 public startingAt = 1522281600; // Thursday, 29 March 2018 00:00:00
1300 
1301 	// timestamp when vesting ends
1302 	uint256 public endingAt = startingAt + 540 days;
1303 
1304 	// how many % of ethers to vest on each call
1305 	uint256 public vestingAmount = 20;
1306 
1307 	// timestamp when vesting starts
1308 	uint256 public vestingPeriodLength = 30 days;
1309 
1310 	// time after which owner can withdraw all available funds
1311 	uint256 public contractTimeout = startingAt + 2 years;
1312 
1313 	// mapping that defines vesting structure
1314 	struct VestingStruct {
1315 		uint256 period; 
1316 		bool status;
1317 		address wallet;
1318 		uint256 amount;
1319 		uint256 timestamp;
1320 	}
1321 
1322 	// vesting that tracks vestings done against the period.
1323 	mapping (uint256 => VestingStruct) public vestings;
1324 
1325 	// Event to log whenever the payment is done
1326 	event Payouts(uint256 indexed period, bool status, address wallet, uint256 amount, uint256 timestamp);
1327 
1328 	/**
1329 	* @dev Constructor that initializes token contract with token address in parameter
1330 	*/
1331 	function dHealthTokenVesting(address _token, address _wallet, uint256 _maxTokenForHold, uint256 _startingAt) public {
1332 		// set token
1333 		token = dHealthToken(_token);
1334 
1335 		// set wallet address
1336 		wallet = _wallet;
1337 
1338 		// set parameter specific to contract
1339 		maxTokenForHold = _maxTokenForHold;	
1340 		
1341 		// setup timestamp
1342 		startingAt = _startingAt;
1343 		endingAt = startingAt + 540 days;
1344 	}
1345 
1346 	/**
1347 	* @dev default payable method to receive funds
1348 	*/
1349 	function() public payable {
1350 		
1351 	}
1352 
1353 	/**
1354 	* @dev Method called by owner of contract to withdraw funds
1355 	*/
1356 	function pay(uint256 percentage) public {
1357 		// requested amount should always be less than vestingAmount variable
1358 		percentage = percentage <= vestingAmount ? percentage : vestingAmount;
1359 
1360 		// get current token balance
1361 		uint256 balance = token.balanceOf(this); 
1362 		
1363 		// calculate amount allowed
1364 		var (period, amount) = calculate(getBlockTime() , balance , percentage);
1365 
1366 		// payment should not be done if period is zero
1367 		require(period > 0);
1368 		// payment should not be done already
1369 		require(vestings[period].status == false);
1370 		// wallet should not be set already.
1371 		require(vestings[period].wallet == address(0));
1372 		// there should be amount to pay
1373 		require(amount > 0);
1374 
1375 		// set period for storage
1376 		vestings[period].period = period;
1377 		// set status to avoid double payment
1378 		vestings[period].status = true;
1379 		// set wallet to track where payment was sent
1380 		vestings[period].wallet = wallet;
1381 		// set wallet to track how much amount sent
1382 		vestings[period].amount = amount;
1383 		// set timestamp of payment
1384 		vestings[period].timestamp = getBlockTime();
1385 
1386 		// transfer amount to wallet address
1387 		bytes memory empty;
1388 		token.transfer(wallet, amount, empty);
1389 
1390 		// log event
1391 		Payouts(period, vestings[period].status, vestings[period].wallet, vestings[period].amount, vestings[period].timestamp);
1392 	}
1393 
1394 	/**
1395 	* @dev Internal method called to current vesting period
1396 	*/
1397 	function getPeriod(uint256 timestamp) public view returns (uint256) {
1398 		for(uint256 i = 1 ; i <= 18 ; i ++) {
1399 			// calculate timestamp range
1400 			uint256 startTime = startingAt + (vestingPeriodLength * (i - 1));
1401 			uint256 endTime = startingAt + (vestingPeriodLength * (i));
1402 
1403 			if(startTime <= timestamp && timestamp < endTime) {
1404 				return i;
1405 			}
1406 		}
1407 
1408 		// calculate timestamp of last period
1409 		uint256 lastEndTime = startingAt + (vestingPeriodLength * (18));
1410 		if(lastEndTime <= timestamp) {
1411 			return 18;
1412 		}
1413 
1414 		return 0;
1415 	}
1416 
1417 	/**
1418 	* @dev Internal method called to current vesting period range
1419 	*/
1420 	function getPeriodRange(uint256 timestamp) public view returns (uint256 , uint256) {
1421 		for(uint256 i = 1 ; i <= 18 ; i ++) {
1422 			// calculate timestamp range
1423 			uint256 startTime = startingAt + (vestingPeriodLength * (i - 1));
1424 			uint256 endTime = startingAt + (vestingPeriodLength * (i));
1425 
1426 			if(startTime <= timestamp && timestamp < endTime) {
1427 				return (startTime , endTime);
1428 			}
1429 		}
1430 
1431 		// calculate timestamp of last period
1432 		uint256 lastStartTime = startingAt + (vestingPeriodLength * (17));
1433 		uint256 lastEndTime = startingAt + (vestingPeriodLength * (18));
1434 		if(lastEndTime <= timestamp) {
1435 			return (lastStartTime , lastEndTime);
1436 		}
1437 
1438 		return (0 , 0);
1439 	}
1440 
1441 	/**
1442 	* @dev Internal method called to calculate withdrawal amount
1443 	*/
1444 	function calculate(uint256 timestamp, uint256 balance , uint256 percentage) public view returns (uint256 , uint256) {
1445 		// find out current vesting period
1446 		uint256 period = getPeriod(timestamp);
1447 		if(period == 0) {
1448 			// if period is not found then return zero;
1449 			return (0 , 0);
1450 		}
1451 
1452 		// get vesting object for period
1453 		VestingStruct memory vesting = vestings[period];	
1454 		
1455 		// check if payment is already done
1456 		if(vesting.status == false) {
1457 			// payment is not done yet
1458 			uint256 amount;
1459 
1460 			// if it is last month then send all remaining balance
1461 			if(period == 18) {
1462 				// send all
1463 				amount = balance;
1464 			} else {
1465 				// calculate percentage and send
1466 				amount = balance.mul(percentage).div(100);
1467 			}
1468 			
1469 			return (period, amount);
1470 		} else {
1471 			// payment is already done 
1472 			return (period, 0);
1473 		}		
1474 	}
1475 
1476 	/**
1477 	* @dev Method called by owner to change the wallet address
1478 	*/
1479 	function setWallet(address _wallet) onlyOwner public {
1480 		wallet = _wallet;
1481 	}
1482 
1483 	/**
1484 	* @dev Method called by owner of contract to withdraw funds after timeout has reached
1485 	*/
1486 	function withdraw() onlyOwner public payable {
1487 		require(contractTimeout <= getBlockTime());
1488 		
1489 		// send remaining tokens back to owner.
1490 		uint256 tokens = token.balanceOf(this); 
1491 		bytes memory empty;
1492 		token.transfer(owner, tokens, empty);
1493 	}	
1494 }