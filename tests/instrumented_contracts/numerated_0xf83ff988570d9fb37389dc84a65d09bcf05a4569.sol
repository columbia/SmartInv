1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10     function transfer(address to, uint256 value) external returns (bool);
11 
12     function approve(address spender, uint256 value) external returns (bool);
13 
14     function transferFrom(address from, address to, uint256 value) external returns (bool);
15 
16     function totalSupply() external view returns (uint256);
17 
18     function balanceOf(address who) external view returns (uint256);
19 
20     function allowance(address owner, address spender) external view returns (uint256);
21 
22     event Transfer(address indexed from, address indexed to, uint256 value);
23 
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
28 
29 pragma solidity ^0.5.0;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37     * @dev Multiplies two unsigned integers, reverts on overflow.
38     */
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
41         // benefit is lost if 'b' is also tested.
42         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
43         if (a == 0) {
44             return 0;
45         }
46 
47         uint256 c = a * b;
48         require(c / a == b);
49 
50         return c;
51     }
52 
53     /**
54     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55     */
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         // Solidity only automatically asserts when dividing by 0
58         require(b > 0);
59         uint256 c = a / b;
60         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61 
62         return c;
63     }
64 
65     /**
66     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67     */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76     * @dev Adds two unsigned integers, reverts on overflow.
77     */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87     * reverts when dividing by zero.
88     */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.0;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
106  * Originally based on code by FirstBlood:
107  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  *
109  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
110  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
111  * compliant implementations may not do it.
112  */
113 contract ERC20 is IERC20 {
114     using SafeMath for uint256;
115 
116     mapping (address => uint256) private _balances;
117 
118     mapping (address => mapping (address => uint256)) private _allowed;
119 
120     uint256 private _totalSupply;
121 
122     /**
123     * @dev Total number of tokens in existence
124     */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130     * @dev Gets the balance of the specified address.
131     * @param owner The address to query the balance of.
132     * @return An uint256 representing the amount owned by the passed address.
133     */
134     function balanceOf(address owner) public view returns (uint256) {
135         return _balances[owner];
136     }
137 
138     /**
139      * @dev Function to check the amount of tokens that an owner allowed to a spender.
140      * @param owner address The address which owns the funds.
141      * @param spender address The address which will spend the funds.
142      * @return A uint256 specifying the amount of tokens still available for the spender.
143      */
144     function allowance(address owner, address spender) public view returns (uint256) {
145         return _allowed[owner][spender];
146     }
147 
148     /**
149     * @dev Transfer token for a specified address
150     * @param to The address to transfer to.
151     * @param value The amount to be transferred.
152     */
153     function transfer(address to, uint256 value) public returns (bool) {
154         _transfer(msg.sender, to, value);
155         return true;
156     }
157 
158     /**
159      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
160      * Beware that changing an allowance with this method brings the risk that someone may use both the old
161      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164      * @param spender The address which will spend the funds.
165      * @param value The amount of tokens to be spent.
166      */
167     function approve(address spender, uint256 value) public returns (bool) {
168         require(spender != address(0));
169 
170         _allowed[msg.sender][spender] = value;
171         emit Approval(msg.sender, spender, value);
172         return true;
173     }
174 
175     /**
176      * @dev Transfer tokens from one address to another.
177      * Note that while this function emits an Approval event, this is not required as per the specification,
178      * and other compliant implementations may not emit the event.
179      * @param from address The address which you want to send tokens from
180      * @param to address The address which you want to transfer to
181      * @param value uint256 the amount of tokens to be transferred
182      */
183     function transferFrom(address from, address to, uint256 value) public returns (bool) {
184         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
185         _transfer(from, to, value);
186         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
187         return true;
188     }
189 
190     /**
191      * @dev Increase the amount of tokens that an owner allowed to a spender.
192      * approve should be called when allowed_[_spender] == 0. To increment
193      * allowed value is better to use this function to avoid 2 calls (and wait until
194      * the first transaction is mined)
195      * From MonolithDAO Token.sol
196      * Emits an Approval event.
197      * @param spender The address which will spend the funds.
198      * @param addedValue The amount of tokens to increase the allowance by.
199      */
200     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
201         require(spender != address(0));
202 
203         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
204         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
205         return true;
206     }
207 
208     /**
209      * @dev Decrease the amount of tokens that an owner allowed to a spender.
210      * approve should be called when allowed_[_spender] == 0. To decrement
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param subtractedValue The amount of tokens to decrease the allowance by.
217      */
218     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
219         require(spender != address(0));
220 
221         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
222         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223         return true;
224     }
225 
226     /**
227     * @dev Transfer token for a specified addresses
228     * @param from The address to transfer from.
229     * @param to The address to transfer to.
230     * @param value The amount to be transferred.
231     */
232     function _transfer(address from, address to, uint256 value) internal {
233         require(to != address(0));
234 
235         _balances[from] = _balances[from].sub(value);
236         _balances[to] = _balances[to].add(value);
237         emit Transfer(from, to, value);
238     }
239 
240     /**
241      * @dev Internal function that mints an amount of the token and assigns it to
242      * an account. This encapsulates the modification of balances such that the
243      * proper events are emitted.
244      * @param account The account that will receive the created tokens.
245      * @param value The amount that will be created.
246      */
247     function _mint(address account, uint256 value) internal {
248         require(account != address(0));
249 
250         _totalSupply = _totalSupply.add(value);
251         _balances[account] = _balances[account].add(value);
252         emit Transfer(address(0), account, value);
253     }
254 
255     /**
256      * @dev Internal function that burns an amount of the token of a given
257      * account.
258      * @param account The account whose tokens will be burnt.
259      * @param value The amount that will be burnt.
260      */
261     function _burn(address account, uint256 value) internal {
262         require(account != address(0));
263 
264         _totalSupply = _totalSupply.sub(value);
265         _balances[account] = _balances[account].sub(value);
266         emit Transfer(account, address(0), value);
267     }
268 
269     /**
270      * @dev Internal function that burns an amount of the token of a given
271      * account, deducting from the sender's allowance for said account. Uses the
272      * internal burn function.
273      * Emits an Approval event (reflecting the reduced allowance).
274      * @param account The account whose tokens will be burnt.
275      * @param value The amount that will be burnt.
276      */
277     function _burnFrom(address account, uint256 value) internal {
278         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
279         _burn(account, value);
280         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
281     }
282 }
283 
284 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
285 
286 pragma solidity ^0.5.0;
287 
288 /**
289  * @title Ownable
290  * @dev The Ownable contract has an owner address, and provides basic authorization control
291  * functions, this simplifies the implementation of "user permissions".
292  */
293 contract Ownable {
294     address private _owner;
295 
296     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
297 
298     /**
299      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
300      * account.
301      */
302     constructor () internal {
303         _owner = msg.sender;
304         emit OwnershipTransferred(address(0), _owner);
305     }
306 
307     /**
308      * @return the address of the owner.
309      */
310     function owner() public view returns (address) {
311         return _owner;
312     }
313 
314     /**
315      * @dev Throws if called by any account other than the owner.
316      */
317     modifier onlyOwner() {
318         require(isOwner());
319         _;
320     }
321 
322     /**
323      * @return true if `msg.sender` is the owner of the contract.
324      */
325     function isOwner() public view returns (bool) {
326         return msg.sender == _owner;
327     }
328 
329     /**
330      * @dev Allows the current owner to relinquish control of the contract.
331      * @notice Renouncing to ownership will leave the contract without an owner.
332      * It will not be possible to call the functions with the `onlyOwner`
333      * modifier anymore.
334      */
335     function renounceOwnership() public onlyOwner {
336         emit OwnershipTransferred(_owner, address(0));
337         _owner = address(0);
338     }
339 
340     /**
341      * @dev Allows the current owner to transfer control of the contract to a newOwner.
342      * @param newOwner The address to transfer ownership to.
343      */
344     function transferOwnership(address newOwner) public onlyOwner {
345         _transferOwnership(newOwner);
346     }
347 
348     /**
349      * @dev Transfers control of the contract to a newOwner.
350      * @param newOwner The address to transfer ownership to.
351      */
352     function _transferOwnership(address newOwner) internal {
353         require(newOwner != address(0));
354         emit OwnershipTransferred(_owner, newOwner);
355         _owner = newOwner;
356     }
357 }
358 
359 // File: @gnosis.pm/mock-contract/contracts/MockContract.sol
360 
361 pragma solidity ^0.5.0;
362 
363 interface MockInterface {
364 	/**
365 	 * @dev After calling this method, the mock will return `response` when it is called
366 	 * with any calldata that is not mocked more specifically below
367 	 * (e.g. using givenMethodReturn).
368 	 * @param response ABI encoded response that will be returned if method is invoked
369 	 */
370 	function givenAnyReturn(bytes calldata response) external;
371 	function givenAnyReturnBool(bool response) external;
372 	function givenAnyReturnUint(uint response) external;
373 	function givenAnyReturnAddress(address response) external;
374 
375 	function givenAnyRevert() external;
376 	function givenAnyRevertWithMessage(string calldata message) external;
377 	function givenAnyRunOutOfGas() external;
378 
379 	/**
380 	 * @dev After calling this method, the mock will return `response` when the given
381 	 * methodId is called regardless of arguments. If the methodId and arguments
382 	 * are mocked more specifically (using `givenMethodAndArguments`) the latter
383 	 * will take precedence.
384 	 * @param method ABI encoded methodId. It is valid to pass full calldata (including arguments). The mock will extract the methodId from it
385 	 * @param response ABI encoded response that will be returned if method is invoked
386 	 */
387 	function givenMethodReturn(bytes calldata method, bytes calldata response) external;
388 	function givenMethodReturnBool(bytes calldata method, bool response) external;
389 	function givenMethodReturnUint(bytes calldata method, uint response) external;
390 	function givenMethodReturnAddress(bytes calldata method, address response) external;
391 
392 	function givenMethodRevert(bytes calldata method) external;
393 	function givenMethodRevertWithMessage(bytes calldata method, string calldata message) external;
394 	function givenMethodRunOutOfGas(bytes calldata method) external;
395 
396 	/**
397 	 * @dev After calling this method, the mock will return `response` when the given
398 	 * methodId is called with matching arguments. These exact calldataMocks will take
399 	 * precedence over all other calldataMocks.
400 	 * @param call ABI encoded calldata (methodId and arguments)
401 	 * @param response ABI encoded response that will be returned if contract is invoked with calldata
402 	 */
403 	function givenCalldataReturn(bytes calldata call, bytes calldata response) external;
404 	function givenCalldataReturnBool(bytes calldata call, bool response) external;
405 	function givenCalldataReturnUint(bytes calldata call, uint response) external;
406 	function givenCalldataReturnAddress(bytes calldata call, address response) external;
407 
408 	function givenCalldataRevert(bytes calldata call) external;
409 	function givenCalldataRevertWithMessage(bytes calldata call, string calldata message) external;
410 	function givenCalldataRunOutOfGas(bytes calldata call) external;
411 
412 	/**
413 	 * @dev Returns the number of times anything has been called on this mock since last reset
414 	 */
415 	function invocationCount() external returns (uint);
416 
417 	/**
418 	 * @dev Returns the number of times the given method has been called on this mock since last reset
419 	 * @param method ABI encoded methodId. It is valid to pass full calldata (including arguments). The mock will extract the methodId from it
420 	 */
421 	function invocationCountForMethod(bytes calldata method) external returns (uint);
422 
423 	/**
424 	 * @dev Returns the number of times this mock has been called with the exact calldata since last reset.
425 	 * @param call ABI encoded calldata (methodId and arguments)
426 	 */
427 	function invocationCountForCalldata(bytes calldata call) external returns (uint);
428 
429 	/**
430 	 * @dev Resets all mocked methods and invocation counts.
431 	 */
432 	 function reset() external;
433 }
434 
435 /**
436  * Implementation of the MockInterface.
437  */
438 contract MockContract is MockInterface {
439 	enum MockType { Return, Revert, OutOfGas }
440 	
441 	bytes32 public constant MOCKS_LIST_START = hex"01";
442 	bytes public constant MOCKS_LIST_END = "0xff";
443 	bytes32 public constant MOCKS_LIST_END_HASH = keccak256(MOCKS_LIST_END);
444 	bytes4 public constant SENTINEL_ANY_MOCKS = hex"01";
445 
446 	// A linked list allows easy iteration and inclusion checks
447 	mapping(bytes32 => bytes) calldataMocks;
448 	mapping(bytes => MockType) calldataMockTypes;
449 	mapping(bytes => bytes) calldataExpectations;
450 	mapping(bytes => string) calldataRevertMessage;
451 	mapping(bytes32 => uint) calldataInvocations;
452 
453 	mapping(bytes4 => bytes4) methodIdMocks;
454 	mapping(bytes4 => MockType) methodIdMockTypes;
455 	mapping(bytes4 => bytes) methodIdExpectations;
456 	mapping(bytes4 => string) methodIdRevertMessages;
457 	mapping(bytes32 => uint) methodIdInvocations;
458 
459 	MockType fallbackMockType;
460 	bytes fallbackExpectation;
461 	string fallbackRevertMessage;
462 	uint invocations;
463 	uint resetCount;
464 
465 	constructor() public {
466 		calldataMocks[MOCKS_LIST_START] = MOCKS_LIST_END;
467 		methodIdMocks[SENTINEL_ANY_MOCKS] = SENTINEL_ANY_MOCKS;
468 	}
469 
470 	function trackCalldataMock(bytes memory call) private {
471 		bytes32 callHash = keccak256(call);
472 		if (calldataMocks[callHash].length == 0) {
473 			calldataMocks[callHash] = calldataMocks[MOCKS_LIST_START];
474 			calldataMocks[MOCKS_LIST_START] = call;
475 		}
476 	}
477 
478 	function trackMethodIdMock(bytes4 methodId) private {
479 		if (methodIdMocks[methodId] == 0x0) {
480 			methodIdMocks[methodId] = methodIdMocks[SENTINEL_ANY_MOCKS];
481 			methodIdMocks[SENTINEL_ANY_MOCKS] = methodId;
482 		}
483 	}
484 
485 	function _givenAnyReturn(bytes memory response) internal {
486 		fallbackMockType = MockType.Return;
487 		fallbackExpectation = response;
488 	}
489 
490 	function givenAnyReturn(bytes calldata response) external {
491 		_givenAnyReturn(response);
492 	}
493 
494 	function givenAnyReturnBool(bool response) external {
495 		uint flag = response ? 1 : 0;
496 		_givenAnyReturn(uintToBytes(flag));
497 	}
498 
499 	function givenAnyReturnUint(uint response) external {
500 		_givenAnyReturn(uintToBytes(response));	
501 	}
502 
503 	function givenAnyReturnAddress(address response) external {
504 		_givenAnyReturn(uintToBytes(uint(response)));
505 	}
506 
507 	function givenAnyRevert() external {
508 		fallbackMockType = MockType.Revert;
509 		fallbackRevertMessage = "";
510 	}
511 
512 	function givenAnyRevertWithMessage(string calldata message) external {
513 		fallbackMockType = MockType.Revert;
514 		fallbackRevertMessage = message;
515 	}
516 
517 	function givenAnyRunOutOfGas() external {
518 		fallbackMockType = MockType.OutOfGas;
519 	}
520 
521 	function _givenCalldataReturn(bytes memory call, bytes memory response) private  {
522 		calldataMockTypes[call] = MockType.Return;
523 		calldataExpectations[call] = response;
524 		trackCalldataMock(call);
525 	}
526 
527 	function givenCalldataReturn(bytes calldata call, bytes calldata response) external  {
528 		_givenCalldataReturn(call, response);
529 	}
530 
531 	function givenCalldataReturnBool(bytes calldata call, bool response) external {
532 		uint flag = response ? 1 : 0;
533 		_givenCalldataReturn(call, uintToBytes(flag));
534 	}
535 
536 	function givenCalldataReturnUint(bytes calldata call, uint response) external {
537 		_givenCalldataReturn(call, uintToBytes(response));
538 	}
539 
540 	function givenCalldataReturnAddress(bytes calldata call, address response) external {
541 		_givenCalldataReturn(call, uintToBytes(uint(response)));
542 	}
543 
544 	function _givenMethodReturn(bytes memory call, bytes memory response) private {
545 		bytes4 method = bytesToBytes4(call);
546 		methodIdMockTypes[method] = MockType.Return;
547 		methodIdExpectations[method] = response;
548 		trackMethodIdMock(method);		
549 	}
550 
551 	function givenMethodReturn(bytes calldata call, bytes calldata response) external {
552 		_givenMethodReturn(call, response);
553 	}
554 
555 	function givenMethodReturnBool(bytes calldata call, bool response) external {
556 		uint flag = response ? 1 : 0;
557 		_givenMethodReturn(call, uintToBytes(flag));
558 	}
559 
560 	function givenMethodReturnUint(bytes calldata call, uint response) external {
561 		_givenMethodReturn(call, uintToBytes(response));
562 	}
563 
564 	function givenMethodReturnAddress(bytes calldata call, address response) external {
565 		_givenMethodReturn(call, uintToBytes(uint(response)));
566 	}
567 
568 	function givenCalldataRevert(bytes calldata call) external {
569 		calldataMockTypes[call] = MockType.Revert;
570 		calldataRevertMessage[call] = "";
571 		trackCalldataMock(call);
572 	}
573 
574 	function givenMethodRevert(bytes calldata call) external {
575 		bytes4 method = bytesToBytes4(call);
576 		methodIdMockTypes[method] = MockType.Revert;
577 		trackMethodIdMock(method);		
578 	}
579 
580 	function givenCalldataRevertWithMessage(bytes calldata call, string calldata message) external {
581 		calldataMockTypes[call] = MockType.Revert;
582 		calldataRevertMessage[call] = message;
583 		trackCalldataMock(call);
584 	}
585 
586 	function givenMethodRevertWithMessage(bytes calldata call, string calldata message) external {
587 		bytes4 method = bytesToBytes4(call);
588 		methodIdMockTypes[method] = MockType.Revert;
589 		methodIdRevertMessages[method] = message;
590 		trackMethodIdMock(method);		
591 	}
592 
593 	function givenCalldataRunOutOfGas(bytes calldata call) external {
594 		calldataMockTypes[call] = MockType.OutOfGas;
595 		trackCalldataMock(call);
596 	}
597 
598 	function givenMethodRunOutOfGas(bytes calldata call) external {
599 		bytes4 method = bytesToBytes4(call);
600 		methodIdMockTypes[method] = MockType.OutOfGas;
601 		trackMethodIdMock(method);	
602 	}
603 
604 	function invocationCount() external returns (uint) {
605 		return invocations;
606 	}
607 
608 	function invocationCountForMethod(bytes calldata call) external returns (uint) {
609 		bytes4 method = bytesToBytes4(call);
610 		return methodIdInvocations[keccak256(abi.encodePacked(resetCount, method))];
611 	}
612 
613 	function invocationCountForCalldata(bytes calldata call) external returns (uint) {
614 		return calldataInvocations[keccak256(abi.encodePacked(resetCount, call))];
615 	}
616 
617 	function reset() external {
618 		// Reset all exact calldataMocks
619 		bytes memory nextMock = calldataMocks[MOCKS_LIST_START];
620 		bytes32 mockHash = keccak256(nextMock);
621 		// We cannot compary bytes
622 		while(mockHash != MOCKS_LIST_END_HASH) {
623 			// Reset all mock maps
624 			calldataMockTypes[nextMock] = MockType.Return;
625 			calldataExpectations[nextMock] = hex"";
626 			calldataRevertMessage[nextMock] = "";
627 			// Set next mock to remove
628 			nextMock = calldataMocks[mockHash];
629 			// Remove from linked list
630 			calldataMocks[mockHash] = "";
631 			// Update mock hash
632 			mockHash = keccak256(nextMock);
633 		}
634 		// Clear list
635 		calldataMocks[MOCKS_LIST_START] = MOCKS_LIST_END;
636 
637 		// Reset all any calldataMocks
638 		bytes4 nextAnyMock = methodIdMocks[SENTINEL_ANY_MOCKS];
639 		while(nextAnyMock != SENTINEL_ANY_MOCKS) {
640 			bytes4 currentAnyMock = nextAnyMock;
641 			methodIdMockTypes[currentAnyMock] = MockType.Return;
642 			methodIdExpectations[currentAnyMock] = hex"";
643 			methodIdRevertMessages[currentAnyMock] = "";
644 			nextAnyMock = methodIdMocks[currentAnyMock];
645 			// Remove from linked list
646 			methodIdMocks[currentAnyMock] = 0x0;
647 		}
648 		// Clear list
649 		methodIdMocks[SENTINEL_ANY_MOCKS] = SENTINEL_ANY_MOCKS;
650 
651 		fallbackExpectation = "";
652 		fallbackMockType = MockType.Return;
653 		invocations = 0;
654 		resetCount += 1;
655 	}
656 
657 	function useAllGas() private {
658 		while(true) {
659 			bool s;
660 			assembly {
661 				//expensive call to EC multiply contract
662 				s := call(sub(gas, 2000), 6, 0, 0x0, 0xc0, 0x0, 0x60)
663 			}
664 		}
665 	}
666 
667 	function bytesToBytes4(bytes memory b) private pure returns (bytes4) {
668 		bytes4 out;
669 		for (uint i = 0; i < 4; i++) {
670 			out |= bytes4(b[i] & 0xFF) >> (i * 8);
671 		}
672 		return out;
673 	}
674 
675 	function uintToBytes(uint256 x) private pure returns (bytes memory b) {
676 		b = new bytes(32);
677 		assembly { mstore(add(b, 32), x) }
678 	}
679 
680 	function updateInvocationCount(bytes4 methodId, bytes memory originalMsgData) public {
681 		require(msg.sender == address(this), "Can only be called from the contract itself");
682 		invocations += 1;
683 		methodIdInvocations[keccak256(abi.encodePacked(resetCount, methodId))] += 1;
684 		calldataInvocations[keccak256(abi.encodePacked(resetCount, originalMsgData))] += 1;
685 	}
686 
687 	function() payable external {
688 		bytes4 methodId;
689 		assembly {
690 			methodId := calldataload(0)
691 		}
692 
693 		// First, check exact matching overrides
694 		if (calldataMockTypes[msg.data] == MockType.Revert) {
695 			revert(calldataRevertMessage[msg.data]);
696 		}
697 		if (calldataMockTypes[msg.data] == MockType.OutOfGas) {
698 			useAllGas();
699 		}
700 		bytes memory result = calldataExpectations[msg.data];
701 
702 		// Then check method Id overrides
703 		if (result.length == 0) {
704 			if (methodIdMockTypes[methodId] == MockType.Revert) {
705 				revert(methodIdRevertMessages[methodId]);
706 			}
707 			if (methodIdMockTypes[methodId] == MockType.OutOfGas) {
708 				useAllGas();
709 			}
710 			result = methodIdExpectations[methodId];
711 		}
712 
713 		// Last, use the fallback override
714 		if (result.length == 0) {
715 			if (fallbackMockType == MockType.Revert) {
716 				revert(fallbackRevertMessage);
717 			}
718 			if (fallbackMockType == MockType.OutOfGas) {
719 				useAllGas();
720 			}
721 			result = fallbackExpectation;
722 		}
723 
724 		// Record invocation as separate call so we don't rollback in case we are called with STATICCALL
725 		(, bytes memory r) = address(this).call.gas(100000)(abi.encodeWithSignature("updateInvocationCount(bytes4,bytes)", methodId, msg.data));
726 		assert(r.length == 0);
727 		
728 		assembly {
729 			return(add(0x20, result), mload(result))
730 		}
731 	}
732 }
733 
734 // File: openzeppelin-solidity/contracts/access/Roles.sol
735 
736 pragma solidity ^0.5.0;
737 
738 /**
739  * @title Roles
740  * @dev Library for managing addresses assigned to a Role.
741  */
742 library Roles {
743     struct Role {
744         mapping (address => bool) bearer;
745     }
746 
747     /**
748      * @dev give an account access to this role
749      */
750     function add(Role storage role, address account) internal {
751         require(account != address(0));
752         require(!has(role, account));
753 
754         role.bearer[account] = true;
755     }
756 
757     /**
758      * @dev remove an account's access to this role
759      */
760     function remove(Role storage role, address account) internal {
761         require(account != address(0));
762         require(has(role, account));
763 
764         role.bearer[account] = false;
765     }
766 
767     /**
768      * @dev check if an account has this role
769      * @return bool
770      */
771     function has(Role storage role, address account) internal view returns (bool) {
772         require(account != address(0));
773         return role.bearer[account];
774     }
775 }
776 
777 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
778 
779 pragma solidity ^0.5.0;
780 
781 
782 contract MinterRole {
783     using Roles for Roles.Role;
784 
785     event MinterAdded(address indexed account);
786     event MinterRemoved(address indexed account);
787 
788     Roles.Role private _minters;
789 
790     constructor () internal {
791         _addMinter(msg.sender);
792     }
793 
794     modifier onlyMinter() {
795         require(isMinter(msg.sender));
796         _;
797     }
798 
799     function isMinter(address account) public view returns (bool) {
800         return _minters.has(account);
801     }
802 
803     function addMinter(address account) public onlyMinter {
804         _addMinter(account);
805     }
806 
807     function renounceMinter() public {
808         _removeMinter(msg.sender);
809     }
810 
811     function _addMinter(address account) internal {
812         _minters.add(account);
813         emit MinterAdded(account);
814     }
815 
816     function _removeMinter(address account) internal {
817         _minters.remove(account);
818         emit MinterRemoved(account);
819     }
820 }
821 
822 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
823 
824 pragma solidity ^0.5.0;
825 
826 
827 
828 /**
829  * @title ERC20Mintable
830  * @dev ERC20 minting logic
831  */
832 contract ERC20Mintable is ERC20, MinterRole {
833     /**
834      * @dev Function to mint tokens
835      * @param to The address that will receive the minted tokens.
836      * @param value The amount of tokens to mint.
837      * @return A boolean that indicates if the operation was successful.
838      */
839     function mint(address to, uint256 value) public onlyMinter returns (bool) {
840         _mint(to, value);
841         return true;
842     }
843 }
844 
845 // File: contracts/interfaces/IDutchExchange.sol
846 
847 pragma solidity ^0.5.0;
848 
849 
850 
851 contract IDutchExchange {
852 
853     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
854     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
855     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
856     mapping(address => mapping(address => uint)) public balances;
857 
858     function withdraw(address tokenAddress, uint amount) public returns (uint);
859     function deposit(address tokenAddress, uint amount) public returns (uint);
860     function ethToken() public returns(address);
861     function frtToken() public returns(address);
862     function getAuctionIndex(address token1, address token2) public view returns(uint256);
863     function postBuyOrder(address token1, address token2, uint256 auctionIndex, uint256 amount) public returns(uint256);
864     function postSellOrder(address token1, address token2, uint256 auctionIndex, uint256 tokensBought) public returns(uint256, uint256);
865     function getCurrentAuctionPrice(address token1, address token2, uint256 auctionIndex) public view returns(uint256, uint256);
866     function claimSellerFunds(address sellToken, address buyToken, address user, uint auctionIndex) public returns (uint returned, uint frtsIssued);
867 }
868 
869 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
870 
871 pragma solidity ^0.5.2;
872 
873 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
874 /// @author Alan Lu - <alan@gnosis.pm>
875 contract Proxied {
876     address public masterCopy;
877 }
878 
879 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
880 /// @author Stefan George - <stefan@gnosis.pm>
881 contract Proxy is Proxied {
882     /// @dev Constructor function sets address of master copy contract.
883     /// @param _masterCopy Master copy address.
884     constructor(address _masterCopy) public {
885         require(_masterCopy != address(0), "The master copy is required");
886         masterCopy = _masterCopy;
887     }
888 
889     /// @dev Fallback function forwards all transactions and returns all received return data.
890     function() external payable {
891         address _masterCopy = masterCopy;
892         assembly {
893             calldatacopy(0, 0, calldatasize)
894             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
895             returndatacopy(0, 0, returndatasize)
896             switch success
897                 case 0 {
898                     revert(0, returndatasize)
899                 }
900                 default {
901                     return(0, returndatasize)
902                 }
903         }
904     }
905 }
906 
907 // File: @gnosis.pm/util-contracts/contracts/Token.sol
908 
909 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
910 pragma solidity ^0.5.2;
911 
912 /// @title Abstract token contract - Functions to be implemented by token contracts
913 contract Token {
914     /*
915      *  Events
916      */
917     event Transfer(address indexed from, address indexed to, uint value);
918     event Approval(address indexed owner, address indexed spender, uint value);
919 
920     /*
921      *  Public functions
922      */
923     function transfer(address to, uint value) public returns (bool);
924     function transferFrom(address from, address to, uint value) public returns (bool);
925     function approve(address spender, uint value) public returns (bool);
926     function balanceOf(address owner) public view returns (uint);
927     function allowance(address owner, address spender) public view returns (uint);
928     function totalSupply() public view returns (uint);
929 }
930 
931 // File: @gnosis.pm/util-contracts/contracts/Math.sol
932 
933 pragma solidity ^0.5.2;
934 
935 /// @title Math library - Allows calculation of logarithmic and exponential functions
936 /// @author Alan Lu - <alan.lu@gnosis.pm>
937 /// @author Stefan George - <stefan@gnosis.pm>
938 library GnosisMath {
939     /*
940      *  Constants
941      */
942     // This is equal to 1 in our calculations
943     uint public constant ONE = 0x10000000000000000;
944     uint public constant LN2 = 0xb17217f7d1cf79ac;
945     uint public constant LOG2_E = 0x171547652b82fe177;
946 
947     /*
948      *  Public functions
949      */
950     /// @dev Returns natural exponential function value of given x
951     /// @param x x
952     /// @return e**x
953     function exp(int x) public pure returns (uint) {
954         // revert if x is > MAX_POWER, where
955         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
956         require(x <= 2454971259878909886679);
957         // return 0 if exp(x) is tiny, using
958         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
959         if (x < -818323753292969962227) return 0;
960         // Transform so that e^x -> 2^x
961         x = x * int(ONE) / int(LN2);
962         // 2^x = 2^whole(x) * 2^frac(x)
963         //       ^^^^^^^^^^ is a bit shift
964         // so Taylor expand on z = frac(x)
965         int shift;
966         uint z;
967         if (x >= 0) {
968             shift = x / int(ONE);
969             z = uint(x % int(ONE));
970         } else {
971             shift = x / int(ONE) - 1;
972             z = ONE - uint(-x % int(ONE));
973         }
974         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
975         //
976         // Can generate the z coefficients using mpmath and the following lines
977         // >>> from mpmath import mp
978         // >>> mp.dps = 100
979         // >>> ONE =  0x10000000000000000
980         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
981         // 0xb17217f7d1cf79ab
982         // 0x3d7f7bff058b1d50
983         // 0xe35846b82505fc5
984         // 0x276556df749cee5
985         // 0x5761ff9e299cc4
986         // 0xa184897c363c3
987         uint zpow = z;
988         uint result = ONE;
989         result += 0xb17217f7d1cf79ab * zpow / ONE;
990         zpow = zpow * z / ONE;
991         result += 0x3d7f7bff058b1d50 * zpow / ONE;
992         zpow = zpow * z / ONE;
993         result += 0xe35846b82505fc5 * zpow / ONE;
994         zpow = zpow * z / ONE;
995         result += 0x276556df749cee5 * zpow / ONE;
996         zpow = zpow * z / ONE;
997         result += 0x5761ff9e299cc4 * zpow / ONE;
998         zpow = zpow * z / ONE;
999         result += 0xa184897c363c3 * zpow / ONE;
1000         zpow = zpow * z / ONE;
1001         result += 0xffe5fe2c4586 * zpow / ONE;
1002         zpow = zpow * z / ONE;
1003         result += 0x162c0223a5c8 * zpow / ONE;
1004         zpow = zpow * z / ONE;
1005         result += 0x1b5253d395e * zpow / ONE;
1006         zpow = zpow * z / ONE;
1007         result += 0x1e4cf5158b * zpow / ONE;
1008         zpow = zpow * z / ONE;
1009         result += 0x1e8cac735 * zpow / ONE;
1010         zpow = zpow * z / ONE;
1011         result += 0x1c3bd650 * zpow / ONE;
1012         zpow = zpow * z / ONE;
1013         result += 0x1816193 * zpow / ONE;
1014         zpow = zpow * z / ONE;
1015         result += 0x131496 * zpow / ONE;
1016         zpow = zpow * z / ONE;
1017         result += 0xe1b7 * zpow / ONE;
1018         zpow = zpow * z / ONE;
1019         result += 0x9c7 * zpow / ONE;
1020         if (shift >= 0) {
1021             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
1022             return result << shift;
1023         } else return result >> (-shift);
1024     }
1025 
1026     /// @dev Returns natural logarithm value of given x
1027     /// @param x x
1028     /// @return ln(x)
1029     function ln(uint x) public pure returns (int) {
1030         require(x > 0);
1031         // binary search for floor(log2(x))
1032         int ilog2 = floorLog2(x);
1033         int z;
1034         if (ilog2 < 0) z = int(x << uint(-ilog2));
1035         else z = int(x >> uint(ilog2));
1036         // z = x * 2^-⌊log₂x⌋
1037         // so 1 <= z < 2
1038         // and ln z = ln x - ⌊log₂x⌋/log₂e
1039         // so just compute ln z using artanh series
1040         // and calculate ln x from that
1041         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
1042         int halflnz = term;
1043         int termpow = term * term / int(ONE) * term / int(ONE);
1044         halflnz += termpow / 3;
1045         termpow = termpow * term / int(ONE) * term / int(ONE);
1046         halflnz += termpow / 5;
1047         termpow = termpow * term / int(ONE) * term / int(ONE);
1048         halflnz += termpow / 7;
1049         termpow = termpow * term / int(ONE) * term / int(ONE);
1050         halflnz += termpow / 9;
1051         termpow = termpow * term / int(ONE) * term / int(ONE);
1052         halflnz += termpow / 11;
1053         termpow = termpow * term / int(ONE) * term / int(ONE);
1054         halflnz += termpow / 13;
1055         termpow = termpow * term / int(ONE) * term / int(ONE);
1056         halflnz += termpow / 15;
1057         termpow = termpow * term / int(ONE) * term / int(ONE);
1058         halflnz += termpow / 17;
1059         termpow = termpow * term / int(ONE) * term / int(ONE);
1060         halflnz += termpow / 19;
1061         termpow = termpow * term / int(ONE) * term / int(ONE);
1062         halflnz += termpow / 21;
1063         termpow = termpow * term / int(ONE) * term / int(ONE);
1064         halflnz += termpow / 23;
1065         termpow = termpow * term / int(ONE) * term / int(ONE);
1066         halflnz += termpow / 25;
1067         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
1068     }
1069 
1070     /// @dev Returns base 2 logarithm value of given x
1071     /// @param x x
1072     /// @return logarithmic value
1073     function floorLog2(uint x) public pure returns (int lo) {
1074         lo = -64;
1075         int hi = 193;
1076         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
1077         int mid = (hi + lo) >> 1;
1078         while ((lo + 1) < hi) {
1079             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
1080             else lo = mid;
1081             mid = (hi + lo) >> 1;
1082         }
1083     }
1084 
1085     /// @dev Returns maximum of an array
1086     /// @param nums Numbers to look through
1087     /// @return Maximum number
1088     function max(int[] memory nums) public pure returns (int maxNum) {
1089         require(nums.length > 0);
1090         maxNum = -2 ** 255;
1091         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
1092     }
1093 
1094     /// @dev Returns whether an add operation causes an overflow
1095     /// @param a First addend
1096     /// @param b Second addend
1097     /// @return Did no overflow occur?
1098     function safeToAdd(uint a, uint b) internal pure returns (bool) {
1099         return a + b >= a;
1100     }
1101 
1102     /// @dev Returns whether a subtraction operation causes an underflow
1103     /// @param a Minuend
1104     /// @param b Subtrahend
1105     /// @return Did no underflow occur?
1106     function safeToSub(uint a, uint b) internal pure returns (bool) {
1107         return a >= b;
1108     }
1109 
1110     /// @dev Returns whether a multiply operation causes an overflow
1111     /// @param a First factor
1112     /// @param b Second factor
1113     /// @return Did no overflow occur?
1114     function safeToMul(uint a, uint b) internal pure returns (bool) {
1115         return b == 0 || a * b / b == a;
1116     }
1117 
1118     /// @dev Returns sum if no overflow occurred
1119     /// @param a First addend
1120     /// @param b Second addend
1121     /// @return Sum
1122     function add(uint a, uint b) internal pure returns (uint) {
1123         require(safeToAdd(a, b));
1124         return a + b;
1125     }
1126 
1127     /// @dev Returns difference if no overflow occurred
1128     /// @param a Minuend
1129     /// @param b Subtrahend
1130     /// @return Difference
1131     function sub(uint a, uint b) internal pure returns (uint) {
1132         require(safeToSub(a, b));
1133         return a - b;
1134     }
1135 
1136     /// @dev Returns product if no overflow occurred
1137     /// @param a First factor
1138     /// @param b Second factor
1139     /// @return Product
1140     function mul(uint a, uint b) internal pure returns (uint) {
1141         require(safeToMul(a, b));
1142         return a * b;
1143     }
1144 
1145     /// @dev Returns whether an add operation causes an overflow
1146     /// @param a First addend
1147     /// @param b Second addend
1148     /// @return Did no overflow occur?
1149     function safeToAdd(int a, int b) internal pure returns (bool) {
1150         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
1151     }
1152 
1153     /// @dev Returns whether a subtraction operation causes an underflow
1154     /// @param a Minuend
1155     /// @param b Subtrahend
1156     /// @return Did no underflow occur?
1157     function safeToSub(int a, int b) internal pure returns (bool) {
1158         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
1159     }
1160 
1161     /// @dev Returns whether a multiply operation causes an overflow
1162     /// @param a First factor
1163     /// @param b Second factor
1164     /// @return Did no overflow occur?
1165     function safeToMul(int a, int b) internal pure returns (bool) {
1166         return (b == 0) || (a * b / b == a);
1167     }
1168 
1169     /// @dev Returns sum if no overflow occurred
1170     /// @param a First addend
1171     /// @param b Second addend
1172     /// @return Sum
1173     function add(int a, int b) internal pure returns (int) {
1174         require(safeToAdd(a, b));
1175         return a + b;
1176     }
1177 
1178     /// @dev Returns difference if no overflow occurred
1179     /// @param a Minuend
1180     /// @param b Subtrahend
1181     /// @return Difference
1182     function sub(int a, int b) internal pure returns (int) {
1183         require(safeToSub(a, b));
1184         return a - b;
1185     }
1186 
1187     /// @dev Returns product if no overflow occurred
1188     /// @param a First factor
1189     /// @param b Second factor
1190     /// @return Product
1191     function mul(int a, int b) internal pure returns (int) {
1192         require(safeToMul(a, b));
1193         return a * b;
1194     }
1195 }
1196 
1197 // File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol
1198 
1199 pragma solidity ^0.5.2;
1200 
1201 
1202 
1203 
1204 /**
1205  * Deprecated: Use Open Zeppeling one instead
1206  */
1207 contract StandardTokenData {
1208     /*
1209      *  Storage
1210      */
1211     mapping(address => uint) balances;
1212     mapping(address => mapping(address => uint)) allowances;
1213     uint totalTokens;
1214 }
1215 
1216 /**
1217  * Deprecated: Use Open Zeppeling one instead
1218  */
1219 /// @title Standard token contract with overflow protection
1220 contract GnosisStandardToken is Token, StandardTokenData {
1221     using GnosisMath for *;
1222 
1223     /*
1224      *  Public functions
1225      */
1226     /// @dev Transfers sender's tokens to a given address. Returns success
1227     /// @param to Address of token receiver
1228     /// @param value Number of tokens to transfer
1229     /// @return Was transfer successful?
1230     function transfer(address to, uint value) public returns (bool) {
1231         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
1232             return false;
1233         }
1234 
1235         balances[msg.sender] -= value;
1236         balances[to] += value;
1237         emit Transfer(msg.sender, to, value);
1238         return true;
1239     }
1240 
1241     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
1242     /// @param from Address from where tokens are withdrawn
1243     /// @param to Address to where tokens are sent
1244     /// @param value Number of tokens to transfer
1245     /// @return Was transfer successful?
1246     function transferFrom(address from, address to, uint value) public returns (bool) {
1247         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
1248             value
1249         ) || !balances[to].safeToAdd(value)) {
1250             return false;
1251         }
1252         balances[from] -= value;
1253         allowances[from][msg.sender] -= value;
1254         balances[to] += value;
1255         emit Transfer(from, to, value);
1256         return true;
1257     }
1258 
1259     /// @dev Sets approved amount of tokens for spender. Returns success
1260     /// @param spender Address of allowed account
1261     /// @param value Number of approved tokens
1262     /// @return Was approval successful?
1263     function approve(address spender, uint value) public returns (bool) {
1264         allowances[msg.sender][spender] = value;
1265         emit Approval(msg.sender, spender, value);
1266         return true;
1267     }
1268 
1269     /// @dev Returns number of allowed tokens for given address
1270     /// @param owner Address of token owner
1271     /// @param spender Address of token spender
1272     /// @return Remaining allowance for spender
1273     function allowance(address owner, address spender) public view returns (uint) {
1274         return allowances[owner][spender];
1275     }
1276 
1277     /// @dev Returns number of tokens owned by given address
1278     /// @param owner Address of token owner
1279     /// @return Balance of owner
1280     function balanceOf(address owner) public view returns (uint) {
1281         return balances[owner];
1282     }
1283 
1284     /// @dev Returns total supply of tokens
1285     /// @return Total supply
1286     function totalSupply() public view returns (uint) {
1287         return totalTokens;
1288     }
1289 }
1290 
1291 // File: @gnosis.pm/dx-contracts/contracts/TokenFRT.sol
1292 
1293 pragma solidity ^0.5.2;
1294 
1295 
1296 
1297 
1298 /// @title Standard token contract with overflow protection
1299 contract TokenFRT is Proxied, GnosisStandardToken {
1300     address public owner;
1301 
1302     string public constant symbol = "MGN";
1303     string public constant name = "Magnolia Token";
1304     uint8 public constant decimals = 18;
1305 
1306     struct UnlockedToken {
1307         uint amountUnlocked;
1308         uint withdrawalTime;
1309     }
1310 
1311     /*
1312      *  Storage
1313      */
1314     address public minter;
1315 
1316     // user => UnlockedToken
1317     mapping(address => UnlockedToken) public unlockedTokens;
1318 
1319     // user => amount
1320     mapping(address => uint) public lockedTokenBalances;
1321 
1322     /*
1323      *  Public functions
1324      */
1325 
1326     // @dev allows to set the minter of Magnolia tokens once.
1327     // @param   _minter the minter of the Magnolia tokens, should be the DX-proxy
1328     function updateMinter(address _minter) public {
1329         require(msg.sender == owner, "Only the minter can set a new one");
1330         require(_minter != address(0), "The new minter must be a valid address");
1331 
1332         minter = _minter;
1333     }
1334 
1335     // @dev the intention is to set the owner as the DX-proxy, once it is deployed
1336     // Then only an update of the DX-proxy contract after a 30 days delay could change the minter again.
1337     function updateOwner(address _owner) public {
1338         require(msg.sender == owner, "Only the owner can update the owner");
1339         require(_owner != address(0), "The new owner must be a valid address");
1340         owner = _owner;
1341     }
1342 
1343     function mintTokens(address user, uint amount) public {
1344         require(msg.sender == minter, "Only the minter can mint tokens");
1345 
1346         lockedTokenBalances[user] = add(lockedTokenBalances[user], amount);
1347         totalTokens = add(totalTokens, amount);
1348     }
1349 
1350     /// @dev Lock Token
1351     function lockTokens(uint amount) public returns (uint totalAmountLocked) {
1352         // Adjust amount by balance
1353         uint actualAmount = min(amount, balances[msg.sender]);
1354 
1355         // Update state variables
1356         balances[msg.sender] = sub(balances[msg.sender], actualAmount);
1357         lockedTokenBalances[msg.sender] = add(lockedTokenBalances[msg.sender], actualAmount);
1358 
1359         // Get return variable
1360         totalAmountLocked = lockedTokenBalances[msg.sender];
1361     }
1362 
1363     function unlockTokens() public returns (uint totalAmountUnlocked, uint withdrawalTime) {
1364         // Adjust amount by locked balances
1365         uint amount = lockedTokenBalances[msg.sender];
1366 
1367         if (amount > 0) {
1368             // Update state variables
1369             lockedTokenBalances[msg.sender] = sub(lockedTokenBalances[msg.sender], amount);
1370             unlockedTokens[msg.sender].amountUnlocked = add(unlockedTokens[msg.sender].amountUnlocked, amount);
1371             unlockedTokens[msg.sender].withdrawalTime = now + 24 hours;
1372         }
1373 
1374         // Get return variables
1375         totalAmountUnlocked = unlockedTokens[msg.sender].amountUnlocked;
1376         withdrawalTime = unlockedTokens[msg.sender].withdrawalTime;
1377     }
1378 
1379     function withdrawUnlockedTokens() public {
1380         require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
1381         balances[msg.sender] = add(balances[msg.sender], unlockedTokens[msg.sender].amountUnlocked);
1382         unlockedTokens[msg.sender].amountUnlocked = 0;
1383     }
1384 
1385     function min(uint a, uint b) public pure returns (uint) {
1386         if (a < b) {
1387             return a;
1388         } else {
1389             return b;
1390         }
1391     }
1392     
1393     /// @dev Returns whether an add operation causes an overflow
1394     /// @param a First addend
1395     /// @param b Second addend
1396     /// @return Did no overflow occur?
1397     function safeToAdd(uint a, uint b) public pure returns (bool) {
1398         return a + b >= a;
1399     }
1400 
1401     /// @dev Returns whether a subtraction operation causes an underflow
1402     /// @param a Minuend
1403     /// @param b Subtrahend
1404     /// @return Did no underflow occur?
1405     function safeToSub(uint a, uint b) public pure returns (bool) {
1406         return a >= b;
1407     }
1408 
1409     /// @dev Returns sum if no overflow occurred
1410     /// @param a First addend
1411     /// @param b Second addend
1412     /// @return Sum
1413     function add(uint a, uint b) public pure returns (uint) {
1414         require(safeToAdd(a, b), "It must be a safe adition");
1415         return a + b;
1416     }
1417 
1418     /// @dev Returns difference if no overflow occurred
1419     /// @param a Minuend
1420     /// @param b Subtrahend
1421     /// @return Difference
1422     function sub(uint a, uint b) public pure returns (uint) {
1423         require(safeToSub(a, b), "It must be a safe substraction");
1424         return a - b;
1425     }
1426 }
1427 
1428 // File: openzeppelin-solidity/contracts/utils/Address.sol
1429 
1430 pragma solidity ^0.5.0;
1431 
1432 /**
1433  * Utility library of inline functions on addresses
1434  */
1435 library Address {
1436     /**
1437      * Returns whether the target address is a contract
1438      * @dev This function will return false if invoked during the constructor of a contract,
1439      * as the code is not actually created until after the constructor finishes.
1440      * @param account address of the account to check
1441      * @return whether the target address is a contract
1442      */
1443     function isContract(address account) internal view returns (bool) {
1444         uint256 size;
1445         // XXX Currently there is no better way to check if there is a contract in an address
1446         // than to check the size of the code at that address.
1447         // See https://ethereum.stackexchange.com/a/14016/36603
1448         // for more details about how this works.
1449         // TODO Check this again before the Serenity release, because all addresses will be
1450         // contracts then.
1451         // solhint-disable-next-line no-inline-assembly
1452         assembly { size := extcodesize(account) }
1453         return size > 0;
1454     }
1455 }
1456 
1457 // File: @daostack/arc/contracts/libs/SafeERC20.sol
1458 
1459 /*
1460 
1461 SafeERC20 by daostack.
1462 The code is based on a fix by SECBIT Team.
1463 
1464 USE WITH CAUTION & NO WARRANTY
1465 
1466 REFERENCE & RELATED READING
1467 - https://github.com/ethereum/solidity/issues/4116
1468 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
1469 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
1470 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
1471 
1472 */
1473 pragma solidity ^0.5.2;
1474 
1475 
1476 
1477 library SafeERC20 {
1478     using Address for address;
1479 
1480     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
1481     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
1482     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
1483 
1484     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
1485 
1486         // Must be a contract addr first!
1487         require(_erc20Addr.isContract());
1488 
1489         (bool success, bytes memory returnValue) =
1490         // solhint-disable-next-line avoid-low-level-calls
1491         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
1492         // call return false when something wrong
1493         require(success);
1494         //check return value
1495         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1496     }
1497 
1498     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
1499 
1500         // Must be a contract addr first!
1501         require(_erc20Addr.isContract());
1502 
1503         (bool success, bytes memory returnValue) =
1504         // solhint-disable-next-line avoid-low-level-calls
1505         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
1506         // call return false when something wrong
1507         require(success);
1508         //check return value
1509         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1510     }
1511 
1512     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
1513 
1514         // Must be a contract addr first!
1515         require(_erc20Addr.isContract());
1516 
1517         // safeApprove should only be called when setting an initial allowance,
1518         // or when resetting it to zero.
1519         require((_value == 0) || (IERC20(_erc20Addr).allowance(msg.sender, _spender) == 0));
1520 
1521         (bool success, bytes memory returnValue) =
1522         // solhint-disable-next-line avoid-low-level-calls
1523         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
1524         // call return false when something wrong
1525         require(success);
1526         //check return value
1527         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1528     }
1529 }
1530 
1531 // File: contracts/DxMgnPool.sol
1532 
1533 pragma solidity ^0.5.0;
1534 
1535 
1536 
1537 
1538 
1539 
1540 
1541 
1542 contract DxMgnPool is Ownable {
1543     using SafeMath for uint;
1544 
1545     struct Participation {
1546         uint startAuctionCount; // how many auction passed when this participation started contributing
1547         uint poolShares; // number of shares this participation accounts for (absolute)
1548     }
1549     mapping (address => bool) hasParticpationWithdrawn;
1550     enum State {
1551         Pooling,
1552         PoolingEnded,
1553         DepositWithdrawnFromDx,
1554         MgnUnlocked
1555     }
1556     State public currentState = State.Pooling;
1557 
1558     mapping (address => Participation[]) public participationsByAddress;
1559     uint public totalPoolShares; // total number of shares in this pool
1560     uint public totalPoolSharesCummulative; // over all auctions, the rolling sum of all shares participated
1561     uint public totalDeposit;
1562     uint public totalMgn;
1563     uint public lastParticipatedAuctionIndex;
1564     uint public auctionCount;
1565     
1566     ERC20 public depositToken;
1567     ERC20 public secondaryToken;
1568     TokenFRT public mgnToken;
1569     IDutchExchange public dx;
1570 
1571     uint public poolingPeriodEndTime;
1572 
1573     constructor (
1574         ERC20 _depositToken, 
1575         ERC20 _secondaryToken, 
1576         IDutchExchange _dx,
1577         uint _poolingTimeSeconds
1578     ) public Ownable()
1579     {
1580         depositToken = _depositToken;
1581         secondaryToken = _secondaryToken;
1582         dx = _dx;
1583         mgnToken = TokenFRT(dx.frtToken());
1584         poolingPeriodEndTime = now + _poolingTimeSeconds;
1585     }
1586 
1587     /**
1588      * Public interface
1589      */
1590     function deposit(uint amount) public {
1591         checkForStateUpdate();
1592         require(currentState == State.Pooling, "Pooling is already over");
1593 
1594         uint poolShares = calculatePoolShares(amount);
1595         Participation memory participation = Participation({
1596             startAuctionCount: isDepositTokenTurn() ? auctionCount : auctionCount + 1,
1597             poolShares: poolShares
1598             });
1599         participationsByAddress[msg.sender].push(participation);
1600         totalPoolShares += poolShares;
1601         totalDeposit += amount;
1602 
1603         SafeERC20.safeTransferFrom(address(depositToken), msg.sender, address(this), amount);
1604     }
1605 
1606     function withdrawDeposit() public returns(uint) {
1607         require(currentState == State.DepositWithdrawnFromDx || currentState == State.MgnUnlocked, "Funds not yet withdrawn from dx");
1608         require(!hasParticpationWithdrawn[msg.sender],"sender has already withdrawn funds");
1609 
1610         uint totalDepositAmount = 0;
1611         Participation[] storage participations = participationsByAddress[msg.sender];
1612         uint length = participations.length;
1613         for (uint i = 0; i < length; i++) {
1614             totalDepositAmount += calculateClaimableDeposit(participations[i]);
1615         }
1616         hasParticpationWithdrawn[msg.sender] = true;
1617         SafeERC20.safeTransfer(address(depositToken), msg.sender, totalDepositAmount);
1618         return totalDepositAmount;
1619     }
1620 
1621     function withdrawMagnolia() public returns(uint) {
1622         require(currentState == State.MgnUnlocked, "MGN has not been unlocked, yet");
1623         require(hasParticpationWithdrawn[msg.sender], "Withdraw deposits first");
1624         
1625         uint totalMgnClaimed = 0;
1626         Participation[] memory participations = participationsByAddress[msg.sender];
1627         for (uint i = 0; i < participations.length; i++) {
1628             totalMgnClaimed += calculateClaimableMgn(participations[i]);
1629         }
1630         delete participationsByAddress[msg.sender];
1631         delete hasParticpationWithdrawn[msg.sender];
1632         SafeERC20.safeTransfer(address(mgnToken), msg.sender, totalMgnClaimed);
1633         return totalMgnClaimed;
1634     }
1635 
1636     function participateInAuction() public  onlyOwner() {
1637         checkForStateUpdate();
1638         require(currentState == State.Pooling, "Pooling period is over.");
1639 
1640         uint auctionIndex = dx.getAuctionIndex(address(depositToken), address(secondaryToken));
1641         require(auctionIndex > lastParticipatedAuctionIndex, "Has to wait for new auction to start");
1642 
1643         (address sellToken, address buyToken) = sellAndBuyToken();
1644         uint depositAmount = depositToken.balanceOf(address(this));
1645         if (isDepositTokenTurn()) {
1646             totalPoolSharesCummulative += 2 * totalPoolShares;
1647             if( depositAmount > 0){
1648                 //depositing new tokens
1649                 depositToken.approve(address(dx), depositAmount);
1650                 dx.deposit(address(depositToken), depositAmount);
1651             }
1652         }
1653         // Don't revert if we can't claimSellerFunds
1654         address(dx).call(abi.encodeWithSignature("claimSellerFunds(address,address,address,uint256)", buyToken, sellToken, address(this), lastParticipatedAuctionIndex));
1655 
1656         uint amount = dx.balances(address(sellToken), address(this));
1657         if (isDepositTokenTurn()) {
1658             totalDeposit = amount;
1659         }
1660 
1661         (lastParticipatedAuctionIndex, ) = dx.postSellOrder(sellToken, buyToken, 0, amount);
1662         auctionCount += 1;
1663     }
1664 
1665     function triggerMGNunlockAndClaimTokens() public {
1666         checkForStateUpdate();
1667         require(currentState == State.PoolingEnded, "Pooling period is not yet over.");
1668         require(
1669             dx.getAuctionIndex(address(depositToken), address(secondaryToken)) > lastParticipatedAuctionIndex, 
1670             "Last auction is still running"
1671         );      
1672         
1673         // Don't revert if wen can't claimSellerFunds
1674         address(dx).call(abi.encodeWithSignature("claimSellerFunds(address,address,address,uint256)", secondaryToken, depositToken, address(this), lastParticipatedAuctionIndex));
1675         mgnToken.unlockTokens();
1676 
1677         uint amountOfFundsInDX = dx.balances(address(depositToken), address(this));
1678         totalDeposit = amountOfFundsInDX + depositToken.balanceOf(address(this));
1679         if(amountOfFundsInDX > 0){
1680             dx.withdraw(address(depositToken), amountOfFundsInDX);
1681         }
1682         currentState = State.DepositWithdrawnFromDx;
1683     }
1684 
1685     function withdrawUnlockedMagnoliaFromDx() public {
1686         require(currentState == State.DepositWithdrawnFromDx, "Unlocking not yet triggered");
1687 
1688         // Implicitly we also have:
1689         // require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
1690 
1691         mgnToken.withdrawUnlockedTokens();
1692         totalMgn = mgnToken.balanceOf(address(this));
1693 
1694         currentState = State.MgnUnlocked;
1695     }
1696 
1697     function checkForStateUpdate() public {
1698         if (now >= poolingPeriodEndTime && isDepositTokenTurn() && currentState == State.Pooling) {
1699             currentState = State.PoolingEnded;
1700         }
1701     }
1702 
1703     /// @dev updates state and returns val
1704     function updateAndGetCurrentState() public returns(State) {
1705         checkForStateUpdate();
1706 
1707         return currentState;
1708     }
1709 
1710     /**
1711      * Public View Functions
1712      */
1713      
1714     function numberOfParticipations(address addr) public view returns (uint) {
1715         return participationsByAddress[addr].length;
1716     }
1717 
1718     function participationAtIndex(address addr, uint index) public view returns (uint, uint) {
1719         Participation memory participation = participationsByAddress[addr][index];
1720         return (participation.startAuctionCount, participation.poolShares);
1721     }
1722 
1723     function poolSharesByAddress(address userAddress) external view returns(uint[] memory) {
1724         uint length = participationsByAddress[userAddress].length;        
1725         uint[] memory userTotalPoolShares = new uint[](length);
1726         
1727         for (uint i = 0; i < length; i++) {
1728             userTotalPoolShares[i] = participationsByAddress[userAddress][i].poolShares;
1729         }
1730 
1731         return userTotalPoolShares;
1732     }
1733 
1734     function sellAndBuyToken() public view returns(address sellToken, address buyToken) {
1735         if (isDepositTokenTurn()) {
1736             return (address(depositToken), address(secondaryToken));
1737         } else {
1738             return (address(secondaryToken), address(depositToken)); 
1739         }
1740     }
1741 
1742     function getAllClaimableMgnAndDeposits(address userAddress) external view returns(uint[] memory, uint[] memory) {
1743         uint length = participationsByAddress[userAddress].length;
1744 
1745         uint[] memory allUserClaimableMgn = new uint[](length);
1746         uint[] memory allUserClaimableDeposit = new uint[](length);
1747 
1748         for (uint i = 0; i < length; i++) {
1749             allUserClaimableMgn[i] = calculateClaimableMgn(participationsByAddress[userAddress][i]);
1750             allUserClaimableDeposit[i] = calculateClaimableDeposit(participationsByAddress[userAddress][i]);
1751         }
1752         return (allUserClaimableMgn, allUserClaimableDeposit);
1753     }
1754 
1755     /**
1756      * Internal Helpers
1757      */
1758     
1759     function calculatePoolShares(uint amount) private view returns (uint) {
1760         if (totalDeposit == 0) {
1761             return amount;
1762         } else {
1763             return totalPoolShares.mul(amount) / totalDeposit;
1764         }
1765     }
1766     
1767     function isDepositTokenTurn() private view returns (bool) {
1768         return auctionCount % 2 == 0;
1769     }
1770 
1771     function calculateClaimableMgn(Participation memory participation) private view returns (uint) {
1772         if (totalPoolSharesCummulative == 0) {
1773             return 0;
1774         }
1775         uint duration = auctionCount - participation.startAuctionCount;
1776         return totalMgn.mul(participation.poolShares).mul(duration) / totalPoolSharesCummulative;
1777     }
1778 
1779     function calculateClaimableDeposit(Participation memory participation) private view returns (uint) {
1780         if (totalPoolShares == 0) {
1781             return 0;
1782         }
1783         return totalDeposit.mul(participation.poolShares) / totalPoolShares;
1784     }
1785 }
1786 
1787 // File: contracts/Coordinator.sol
1788 
1789 pragma solidity ^0.5.0;
1790 
1791 contract Coordinator {
1792 
1793     DxMgnPool public dxMgnPool1;
1794     DxMgnPool public dxMgnPool2;
1795 
1796     constructor (
1797         ERC20 _token1, 
1798         ERC20 _token2, 
1799         IDutchExchange _dx,
1800         uint _poolingTime
1801     ) public {
1802         dxMgnPool1 = new DxMgnPool(_token1, _token2, _dx, _poolingTime);
1803         dxMgnPool2 = new DxMgnPool(_token2, _token1, _dx, _poolingTime);
1804     }
1805 
1806     function participateInAuction() public {
1807         dxMgnPool1.participateInAuction();
1808         dxMgnPool2.participateInAuction();
1809     }
1810 
1811     function canParticipate() public returns (bool) {
1812         uint auctionIndex = dxMgnPool1.dx().getAuctionIndex(
1813             address(dxMgnPool1.depositToken()),
1814             address(dxMgnPool1.secondaryToken())
1815         );
1816         // update the state before checking the currentState
1817         dxMgnPool1.checkForStateUpdate();
1818         // Since both auctions start at the same time, it suffices to check one.
1819         return auctionIndex > dxMgnPool1.lastParticipatedAuctionIndex() && dxMgnPool1.currentState() == DxMgnPool.State.Pooling;
1820     }
1821 
1822     function withdrawMGNandDepositsFromBothPools() public {
1823         address(dxMgnPool1).delegatecall(abi.encodeWithSignature("withdrawDeposit()"));
1824         address(dxMgnPool1).delegatecall(abi.encodeWithSignature("withdrawMagnolia()"));
1825 
1826         address(dxMgnPool2).delegatecall(abi.encodeWithSignature("withdrawDeposit()"));
1827         address(dxMgnPool2).delegatecall(abi.encodeWithSignature("withdrawMagnolia()"));
1828     }
1829 }