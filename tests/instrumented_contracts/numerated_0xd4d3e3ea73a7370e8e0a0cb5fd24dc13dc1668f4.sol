1 
2 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
3 
4 pragma solidity ^0.5.0;
5 
6 /**
7  * @title ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/20
9  */
10 interface IERC20 {
11     function transfer(address to, uint256 value) external returns (bool);
12 
13     function approve(address spender, uint256 value) external returns (bool);
14 
15     function transferFrom(address from, address to, uint256 value) external returns (bool);
16 
17     function totalSupply() external view returns (uint256);
18 
19     function balanceOf(address who) external view returns (uint256);
20 
21     function allowance(address owner, address spender) external view returns (uint256);
22 
23     event Transfer(address indexed from, address indexed to, uint256 value);
24 
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
29 
30 pragma solidity ^0.5.0;
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error
35  */
36 library SafeMath {
37     /**
38     * @dev Multiplies two unsigned integers, reverts on overflow.
39     */
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42         // benefit is lost if 'b' is also tested.
43         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b);
50 
51         return c;
52     }
53 
54     /**
55     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
56     */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Solidity only automatically asserts when dividing by 0
59         require(b > 0);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     /**
67     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68     */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b <= a);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77     * @dev Adds two unsigned integers, reverts on overflow.
78     */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a);
82 
83         return c;
84     }
85 
86     /**
87     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
88     * reverts when dividing by zero.
89     */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0);
92         return a % b;
93     }
94 }
95 
96 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
97 
98 pragma solidity ^0.5.0;
99 
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
107  * Originally based on code by FirstBlood:
108  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  *
110  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
111  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
112  * compliant implementations may not do it.
113  */
114 contract ERC20 is IERC20 {
115     using SafeMath for uint256;
116 
117     mapping (address => uint256) private _balances;
118 
119     mapping (address => mapping (address => uint256)) private _allowed;
120 
121     uint256 private _totalSupply;
122 
123     /**
124     * @dev Total number of tokens in existence
125     */
126     function totalSupply() public view returns (uint256) {
127         return _totalSupply;
128     }
129 
130     /**
131     * @dev Gets the balance of the specified address.
132     * @param owner The address to query the balance of.
133     * @return An uint256 representing the amount owned by the passed address.
134     */
135     function balanceOf(address owner) public view returns (uint256) {
136         return _balances[owner];
137     }
138 
139     /**
140      * @dev Function to check the amount of tokens that an owner allowed to a spender.
141      * @param owner address The address which owns the funds.
142      * @param spender address The address which will spend the funds.
143      * @return A uint256 specifying the amount of tokens still available for the spender.
144      */
145     function allowance(address owner, address spender) public view returns (uint256) {
146         return _allowed[owner][spender];
147     }
148 
149     /**
150     * @dev Transfer token for a specified address
151     * @param to The address to transfer to.
152     * @param value The amount to be transferred.
153     */
154     function transfer(address to, uint256 value) public returns (bool) {
155         _transfer(msg.sender, to, value);
156         return true;
157     }
158 
159     /**
160      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
161      * Beware that changing an allowance with this method brings the risk that someone may use both the old
162      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
163      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
164      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
165      * @param spender The address which will spend the funds.
166      * @param value The amount of tokens to be spent.
167      */
168     function approve(address spender, uint256 value) public returns (bool) {
169         require(spender != address(0));
170 
171         _allowed[msg.sender][spender] = value;
172         emit Approval(msg.sender, spender, value);
173         return true;
174     }
175 
176     /**
177      * @dev Transfer tokens from one address to another.
178      * Note that while this function emits an Approval event, this is not required as per the specification,
179      * and other compliant implementations may not emit the event.
180      * @param from address The address which you want to send tokens from
181      * @param to address The address which you want to transfer to
182      * @param value uint256 the amount of tokens to be transferred
183      */
184     function transferFrom(address from, address to, uint256 value) public returns (bool) {
185         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
186         _transfer(from, to, value);
187         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
188         return true;
189     }
190 
191     /**
192      * @dev Increase the amount of tokens that an owner allowed to a spender.
193      * approve should be called when allowed_[_spender] == 0. To increment
194      * allowed value is better to use this function to avoid 2 calls (and wait until
195      * the first transaction is mined)
196      * From MonolithDAO Token.sol
197      * Emits an Approval event.
198      * @param spender The address which will spend the funds.
199      * @param addedValue The amount of tokens to increase the allowance by.
200      */
201     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
202         require(spender != address(0));
203 
204         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
205         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
206         return true;
207     }
208 
209     /**
210      * @dev Decrease the amount of tokens that an owner allowed to a spender.
211      * approve should be called when allowed_[_spender] == 0. To decrement
212      * allowed value is better to use this function to avoid 2 calls (and wait until
213      * the first transaction is mined)
214      * From MonolithDAO Token.sol
215      * Emits an Approval event.
216      * @param spender The address which will spend the funds.
217      * @param subtractedValue The amount of tokens to decrease the allowance by.
218      */
219     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
220         require(spender != address(0));
221 
222         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
223         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
224         return true;
225     }
226 
227     /**
228     * @dev Transfer token for a specified addresses
229     * @param from The address to transfer from.
230     * @param to The address to transfer to.
231     * @param value The amount to be transferred.
232     */
233     function _transfer(address from, address to, uint256 value) internal {
234         require(to != address(0));
235 
236         _balances[from] = _balances[from].sub(value);
237         _balances[to] = _balances[to].add(value);
238         emit Transfer(from, to, value);
239     }
240 
241     /**
242      * @dev Internal function that mints an amount of the token and assigns it to
243      * an account. This encapsulates the modification of balances such that the
244      * proper events are emitted.
245      * @param account The account that will receive the created tokens.
246      * @param value The amount that will be created.
247      */
248     function _mint(address account, uint256 value) internal {
249         require(account != address(0));
250 
251         _totalSupply = _totalSupply.add(value);
252         _balances[account] = _balances[account].add(value);
253         emit Transfer(address(0), account, value);
254     }
255 
256     /**
257      * @dev Internal function that burns an amount of the token of a given
258      * account.
259      * @param account The account whose tokens will be burnt.
260      * @param value The amount that will be burnt.
261      */
262     function _burn(address account, uint256 value) internal {
263         require(account != address(0));
264 
265         _totalSupply = _totalSupply.sub(value);
266         _balances[account] = _balances[account].sub(value);
267         emit Transfer(account, address(0), value);
268     }
269 
270     /**
271      * @dev Internal function that burns an amount of the token of a given
272      * account, deducting from the sender's allowance for said account. Uses the
273      * internal burn function.
274      * Emits an Approval event (reflecting the reduced allowance).
275      * @param account The account whose tokens will be burnt.
276      * @param value The amount that will be burnt.
277      */
278     function _burnFrom(address account, uint256 value) internal {
279         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
280         _burn(account, value);
281         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
282     }
283 }
284 
285 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
286 
287 pragma solidity ^0.5.0;
288 
289 /**
290  * @title Ownable
291  * @dev The Ownable contract has an owner address, and provides basic authorization control
292  * functions, this simplifies the implementation of "user permissions".
293  */
294 contract Ownable {
295     address private _owner;
296 
297     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
298 
299     /**
300      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
301      * account.
302      */
303     constructor () internal {
304         _owner = msg.sender;
305         emit OwnershipTransferred(address(0), _owner);
306     }
307 
308     /**
309      * @return the address of the owner.
310      */
311     function owner() public view returns (address) {
312         return _owner;
313     }
314 
315     /**
316      * @dev Throws if called by any account other than the owner.
317      */
318     modifier onlyOwner() {
319         require(isOwner());
320         _;
321     }
322 
323     /**
324      * @return true if `msg.sender` is the owner of the contract.
325      */
326     function isOwner() public view returns (bool) {
327         return msg.sender == _owner;
328     }
329 
330     /**
331      * @dev Allows the current owner to relinquish control of the contract.
332      * @notice Renouncing to ownership will leave the contract without an owner.
333      * It will not be possible to call the functions with the `onlyOwner`
334      * modifier anymore.
335      */
336     function renounceOwnership() public onlyOwner {
337         emit OwnershipTransferred(_owner, address(0));
338         _owner = address(0);
339     }
340 
341     /**
342      * @dev Allows the current owner to transfer control of the contract to a newOwner.
343      * @param newOwner The address to transfer ownership to.
344      */
345     function transferOwnership(address newOwner) public onlyOwner {
346         _transferOwnership(newOwner);
347     }
348 
349     /**
350      * @dev Transfers control of the contract to a newOwner.
351      * @param newOwner The address to transfer ownership to.
352      */
353     function _transferOwnership(address newOwner) internal {
354         require(newOwner != address(0));
355         emit OwnershipTransferred(_owner, newOwner);
356         _owner = newOwner;
357     }
358 }
359 
360 // File: @gnosis.pm/mock-contract/contracts/MockContract.sol
361 
362 pragma solidity ^0.5.0;
363 
364 interface MockInterface {
365 	/**
366 	 * @dev After calling this method, the mock will return `response` when it is called
367 	 * with any calldata that is not mocked more specifically below
368 	 * (e.g. using givenMethodReturn).
369 	 * @param response ABI encoded response that will be returned if method is invoked
370 	 */
371 	function givenAnyReturn(bytes calldata response) external;
372 	function givenAnyReturnBool(bool response) external;
373 	function givenAnyReturnUint(uint response) external;
374 	function givenAnyReturnAddress(address response) external;
375 
376 	function givenAnyRevert() external;
377 	function givenAnyRevertWithMessage(string calldata message) external;
378 	function givenAnyRunOutOfGas() external;
379 
380 	/**
381 	 * @dev After calling this method, the mock will return `response` when the given
382 	 * methodId is called regardless of arguments. If the methodId and arguments
383 	 * are mocked more specifically (using `givenMethodAndArguments`) the latter
384 	 * will take precedence.
385 	 * @param method ABI encoded methodId. It is valid to pass full calldata (including arguments). The mock will extract the methodId from it
386 	 * @param response ABI encoded response that will be returned if method is invoked
387 	 */
388 	function givenMethodReturn(bytes calldata method, bytes calldata response) external;
389 	function givenMethodReturnBool(bytes calldata method, bool response) external;
390 	function givenMethodReturnUint(bytes calldata method, uint response) external;
391 	function givenMethodReturnAddress(bytes calldata method, address response) external;
392 
393 	function givenMethodRevert(bytes calldata method) external;
394 	function givenMethodRevertWithMessage(bytes calldata method, string calldata message) external;
395 	function givenMethodRunOutOfGas(bytes calldata method) external;
396 
397 	/**
398 	 * @dev After calling this method, the mock will return `response` when the given
399 	 * methodId is called with matching arguments. These exact calldataMocks will take
400 	 * precedence over all other calldataMocks.
401 	 * @param call ABI encoded calldata (methodId and arguments)
402 	 * @param response ABI encoded response that will be returned if contract is invoked with calldata
403 	 */
404 	function givenCalldataReturn(bytes calldata call, bytes calldata response) external;
405 	function givenCalldataReturnBool(bytes calldata call, bool response) external;
406 	function givenCalldataReturnUint(bytes calldata call, uint response) external;
407 	function givenCalldataReturnAddress(bytes calldata call, address response) external;
408 
409 	function givenCalldataRevert(bytes calldata call) external;
410 	function givenCalldataRevertWithMessage(bytes calldata call, string calldata message) external;
411 	function givenCalldataRunOutOfGas(bytes calldata call) external;
412 
413 	/**
414 	 * @dev Returns the number of times anything has been called on this mock since last reset
415 	 */
416 	function invocationCount() external returns (uint);
417 
418 	/**
419 	 * @dev Returns the number of times the given method has been called on this mock since last reset
420 	 * @param method ABI encoded methodId. It is valid to pass full calldata (including arguments). The mock will extract the methodId from it
421 	 */
422 	function invocationCountForMethod(bytes calldata method) external returns (uint);
423 
424 	/**
425 	 * @dev Returns the number of times this mock has been called with the exact calldata since last reset.
426 	 * @param call ABI encoded calldata (methodId and arguments)
427 	 */
428 	function invocationCountForCalldata(bytes calldata call) external returns (uint);
429 
430 	/**
431 	 * @dev Resets all mocked methods and invocation counts.
432 	 */
433 	 function reset() external;
434 }
435 
436 /**
437  * Implementation of the MockInterface.
438  */
439 contract MockContract is MockInterface {
440 	enum MockType { Return, Revert, OutOfGas }
441 	
442 	bytes32 public constant MOCKS_LIST_START = hex"01";
443 	bytes public constant MOCKS_LIST_END = "0xff";
444 	bytes32 public constant MOCKS_LIST_END_HASH = keccak256(MOCKS_LIST_END);
445 	bytes4 public constant SENTINEL_ANY_MOCKS = hex"01";
446 
447 	// A linked list allows easy iteration and inclusion checks
448 	mapping(bytes32 => bytes) calldataMocks;
449 	mapping(bytes => MockType) calldataMockTypes;
450 	mapping(bytes => bytes) calldataExpectations;
451 	mapping(bytes => string) calldataRevertMessage;
452 	mapping(bytes32 => uint) calldataInvocations;
453 
454 	mapping(bytes4 => bytes4) methodIdMocks;
455 	mapping(bytes4 => MockType) methodIdMockTypes;
456 	mapping(bytes4 => bytes) methodIdExpectations;
457 	mapping(bytes4 => string) methodIdRevertMessages;
458 	mapping(bytes32 => uint) methodIdInvocations;
459 
460 	MockType fallbackMockType;
461 	bytes fallbackExpectation;
462 	string fallbackRevertMessage;
463 	uint invocations;
464 	uint resetCount;
465 
466 	constructor() public {
467 		calldataMocks[MOCKS_LIST_START] = MOCKS_LIST_END;
468 		methodIdMocks[SENTINEL_ANY_MOCKS] = SENTINEL_ANY_MOCKS;
469 	}
470 
471 	function trackCalldataMock(bytes memory call) private {
472 		bytes32 callHash = keccak256(call);
473 		if (calldataMocks[callHash].length == 0) {
474 			calldataMocks[callHash] = calldataMocks[MOCKS_LIST_START];
475 			calldataMocks[MOCKS_LIST_START] = call;
476 		}
477 	}
478 
479 	function trackMethodIdMock(bytes4 methodId) private {
480 		if (methodIdMocks[methodId] == 0x0) {
481 			methodIdMocks[methodId] = methodIdMocks[SENTINEL_ANY_MOCKS];
482 			methodIdMocks[SENTINEL_ANY_MOCKS] = methodId;
483 		}
484 	}
485 
486 	function _givenAnyReturn(bytes memory response) internal {
487 		fallbackMockType = MockType.Return;
488 		fallbackExpectation = response;
489 	}
490 
491 	function givenAnyReturn(bytes calldata response) external {
492 		_givenAnyReturn(response);
493 	}
494 
495 	function givenAnyReturnBool(bool response) external {
496 		uint flag = response ? 1 : 0;
497 		_givenAnyReturn(uintToBytes(flag));
498 	}
499 
500 	function givenAnyReturnUint(uint response) external {
501 		_givenAnyReturn(uintToBytes(response));	
502 	}
503 
504 	function givenAnyReturnAddress(address response) external {
505 		_givenAnyReturn(uintToBytes(uint(response)));
506 	}
507 
508 	function givenAnyRevert() external {
509 		fallbackMockType = MockType.Revert;
510 		fallbackRevertMessage = "";
511 	}
512 
513 	function givenAnyRevertWithMessage(string calldata message) external {
514 		fallbackMockType = MockType.Revert;
515 		fallbackRevertMessage = message;
516 	}
517 
518 	function givenAnyRunOutOfGas() external {
519 		fallbackMockType = MockType.OutOfGas;
520 	}
521 
522 	function _givenCalldataReturn(bytes memory call, bytes memory response) private  {
523 		calldataMockTypes[call] = MockType.Return;
524 		calldataExpectations[call] = response;
525 		trackCalldataMock(call);
526 	}
527 
528 	function givenCalldataReturn(bytes calldata call, bytes calldata response) external  {
529 		_givenCalldataReturn(call, response);
530 	}
531 
532 	function givenCalldataReturnBool(bytes calldata call, bool response) external {
533 		uint flag = response ? 1 : 0;
534 		_givenCalldataReturn(call, uintToBytes(flag));
535 	}
536 
537 	function givenCalldataReturnUint(bytes calldata call, uint response) external {
538 		_givenCalldataReturn(call, uintToBytes(response));
539 	}
540 
541 	function givenCalldataReturnAddress(bytes calldata call, address response) external {
542 		_givenCalldataReturn(call, uintToBytes(uint(response)));
543 	}
544 
545 	function _givenMethodReturn(bytes memory call, bytes memory response) private {
546 		bytes4 method = bytesToBytes4(call);
547 		methodIdMockTypes[method] = MockType.Return;
548 		methodIdExpectations[method] = response;
549 		trackMethodIdMock(method);		
550 	}
551 
552 	function givenMethodReturn(bytes calldata call, bytes calldata response) external {
553 		_givenMethodReturn(call, response);
554 	}
555 
556 	function givenMethodReturnBool(bytes calldata call, bool response) external {
557 		uint flag = response ? 1 : 0;
558 		_givenMethodReturn(call, uintToBytes(flag));
559 	}
560 
561 	function givenMethodReturnUint(bytes calldata call, uint response) external {
562 		_givenMethodReturn(call, uintToBytes(response));
563 	}
564 
565 	function givenMethodReturnAddress(bytes calldata call, address response) external {
566 		_givenMethodReturn(call, uintToBytes(uint(response)));
567 	}
568 
569 	function givenCalldataRevert(bytes calldata call) external {
570 		calldataMockTypes[call] = MockType.Revert;
571 		calldataRevertMessage[call] = "";
572 		trackCalldataMock(call);
573 	}
574 
575 	function givenMethodRevert(bytes calldata call) external {
576 		bytes4 method = bytesToBytes4(call);
577 		methodIdMockTypes[method] = MockType.Revert;
578 		trackMethodIdMock(method);		
579 	}
580 
581 	function givenCalldataRevertWithMessage(bytes calldata call, string calldata message) external {
582 		calldataMockTypes[call] = MockType.Revert;
583 		calldataRevertMessage[call] = message;
584 		trackCalldataMock(call);
585 	}
586 
587 	function givenMethodRevertWithMessage(bytes calldata call, string calldata message) external {
588 		bytes4 method = bytesToBytes4(call);
589 		methodIdMockTypes[method] = MockType.Revert;
590 		methodIdRevertMessages[method] = message;
591 		trackMethodIdMock(method);		
592 	}
593 
594 	function givenCalldataRunOutOfGas(bytes calldata call) external {
595 		calldataMockTypes[call] = MockType.OutOfGas;
596 		trackCalldataMock(call);
597 	}
598 
599 	function givenMethodRunOutOfGas(bytes calldata call) external {
600 		bytes4 method = bytesToBytes4(call);
601 		methodIdMockTypes[method] = MockType.OutOfGas;
602 		trackMethodIdMock(method);	
603 	}
604 
605 	function invocationCount() external returns (uint) {
606 		return invocations;
607 	}
608 
609 	function invocationCountForMethod(bytes calldata call) external returns (uint) {
610 		bytes4 method = bytesToBytes4(call);
611 		return methodIdInvocations[keccak256(abi.encodePacked(resetCount, method))];
612 	}
613 
614 	function invocationCountForCalldata(bytes calldata call) external returns (uint) {
615 		return calldataInvocations[keccak256(abi.encodePacked(resetCount, call))];
616 	}
617 
618 	function reset() external {
619 		// Reset all exact calldataMocks
620 		bytes memory nextMock = calldataMocks[MOCKS_LIST_START];
621 		bytes32 mockHash = keccak256(nextMock);
622 		// We cannot compary bytes
623 		while(mockHash != MOCKS_LIST_END_HASH) {
624 			// Reset all mock maps
625 			calldataMockTypes[nextMock] = MockType.Return;
626 			calldataExpectations[nextMock] = hex"";
627 			calldataRevertMessage[nextMock] = "";
628 			// Set next mock to remove
629 			nextMock = calldataMocks[mockHash];
630 			// Remove from linked list
631 			calldataMocks[mockHash] = "";
632 			// Update mock hash
633 			mockHash = keccak256(nextMock);
634 		}
635 		// Clear list
636 		calldataMocks[MOCKS_LIST_START] = MOCKS_LIST_END;
637 
638 		// Reset all any calldataMocks
639 		bytes4 nextAnyMock = methodIdMocks[SENTINEL_ANY_MOCKS];
640 		while(nextAnyMock != SENTINEL_ANY_MOCKS) {
641 			bytes4 currentAnyMock = nextAnyMock;
642 			methodIdMockTypes[currentAnyMock] = MockType.Return;
643 			methodIdExpectations[currentAnyMock] = hex"";
644 			methodIdRevertMessages[currentAnyMock] = "";
645 			nextAnyMock = methodIdMocks[currentAnyMock];
646 			// Remove from linked list
647 			methodIdMocks[currentAnyMock] = 0x0;
648 		}
649 		// Clear list
650 		methodIdMocks[SENTINEL_ANY_MOCKS] = SENTINEL_ANY_MOCKS;
651 
652 		fallbackExpectation = "";
653 		fallbackMockType = MockType.Return;
654 		invocations = 0;
655 		resetCount += 1;
656 	}
657 
658 	function useAllGas() private {
659 		while(true) {
660 			bool s;
661 			assembly {
662 				//expensive call to EC multiply contract
663 				s := call(sub(gas, 2000), 6, 0, 0x0, 0xc0, 0x0, 0x60)
664 			}
665 		}
666 	}
667 
668 	function bytesToBytes4(bytes memory b) private pure returns (bytes4) {
669 		bytes4 out;
670 		for (uint i = 0; i < 4; i++) {
671 			out |= bytes4(b[i] & 0xFF) >> (i * 8);
672 		}
673 		return out;
674 	}
675 
676 	function uintToBytes(uint256 x) private pure returns (bytes memory b) {
677 		b = new bytes(32);
678 		assembly { mstore(add(b, 32), x) }
679 	}
680 
681 	function updateInvocationCount(bytes4 methodId, bytes memory originalMsgData) public {
682 		require(msg.sender == address(this), "Can only be called from the contract itself");
683 		invocations += 1;
684 		methodIdInvocations[keccak256(abi.encodePacked(resetCount, methodId))] += 1;
685 		calldataInvocations[keccak256(abi.encodePacked(resetCount, originalMsgData))] += 1;
686 	}
687 
688 	function() payable external {
689 		bytes4 methodId;
690 		assembly {
691 			methodId := calldataload(0)
692 		}
693 
694 		// First, check exact matching overrides
695 		if (calldataMockTypes[msg.data] == MockType.Revert) {
696 			revert(calldataRevertMessage[msg.data]);
697 		}
698 		if (calldataMockTypes[msg.data] == MockType.OutOfGas) {
699 			useAllGas();
700 		}
701 		bytes memory result = calldataExpectations[msg.data];
702 
703 		// Then check method Id overrides
704 		if (result.length == 0) {
705 			if (methodIdMockTypes[methodId] == MockType.Revert) {
706 				revert(methodIdRevertMessages[methodId]);
707 			}
708 			if (methodIdMockTypes[methodId] == MockType.OutOfGas) {
709 				useAllGas();
710 			}
711 			result = methodIdExpectations[methodId];
712 		}
713 
714 		// Last, use the fallback override
715 		if (result.length == 0) {
716 			if (fallbackMockType == MockType.Revert) {
717 				revert(fallbackRevertMessage);
718 			}
719 			if (fallbackMockType == MockType.OutOfGas) {
720 				useAllGas();
721 			}
722 			result = fallbackExpectation;
723 		}
724 
725 		// Record invocation as separate call so we don't rollback in case we are called with STATICCALL
726 		(, bytes memory r) = address(this).call.gas(100000)(abi.encodeWithSignature("updateInvocationCount(bytes4,bytes)", methodId, msg.data));
727 		assert(r.length == 0);
728 		
729 		assembly {
730 			return(add(0x20, result), mload(result))
731 		}
732 	}
733 }
734 
735 // File: openzeppelin-solidity/contracts/access/Roles.sol
736 
737 pragma solidity ^0.5.0;
738 
739 /**
740  * @title Roles
741  * @dev Library for managing addresses assigned to a Role.
742  */
743 library Roles {
744     struct Role {
745         mapping (address => bool) bearer;
746     }
747 
748     /**
749      * @dev give an account access to this role
750      */
751     function add(Role storage role, address account) internal {
752         require(account != address(0));
753         require(!has(role, account));
754 
755         role.bearer[account] = true;
756     }
757 
758     /**
759      * @dev remove an account's access to this role
760      */
761     function remove(Role storage role, address account) internal {
762         require(account != address(0));
763         require(has(role, account));
764 
765         role.bearer[account] = false;
766     }
767 
768     /**
769      * @dev check if an account has this role
770      * @return bool
771      */
772     function has(Role storage role, address account) internal view returns (bool) {
773         require(account != address(0));
774         return role.bearer[account];
775     }
776 }
777 
778 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
779 
780 pragma solidity ^0.5.0;
781 
782 
783 contract MinterRole {
784     using Roles for Roles.Role;
785 
786     event MinterAdded(address indexed account);
787     event MinterRemoved(address indexed account);
788 
789     Roles.Role private _minters;
790 
791     constructor () internal {
792         _addMinter(msg.sender);
793     }
794 
795     modifier onlyMinter() {
796         require(isMinter(msg.sender));
797         _;
798     }
799 
800     function isMinter(address account) public view returns (bool) {
801         return _minters.has(account);
802     }
803 
804     function addMinter(address account) public onlyMinter {
805         _addMinter(account);
806     }
807 
808     function renounceMinter() public {
809         _removeMinter(msg.sender);
810     }
811 
812     function _addMinter(address account) internal {
813         _minters.add(account);
814         emit MinterAdded(account);
815     }
816 
817     function _removeMinter(address account) internal {
818         _minters.remove(account);
819         emit MinterRemoved(account);
820     }
821 }
822 
823 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
824 
825 pragma solidity ^0.5.0;
826 
827 
828 
829 /**
830  * @title ERC20Mintable
831  * @dev ERC20 minting logic
832  */
833 contract ERC20Mintable is ERC20, MinterRole {
834     /**
835      * @dev Function to mint tokens
836      * @param to The address that will receive the minted tokens.
837      * @param value The amount of tokens to mint.
838      * @return A boolean that indicates if the operation was successful.
839      */
840     function mint(address to, uint256 value) public onlyMinter returns (bool) {
841         _mint(to, value);
842         return true;
843     }
844 }
845 
846 // File: contracts/interfaces/IDutchExchange.sol
847 
848 pragma solidity ^0.5.0;
849 
850 
851 
852 contract IDutchExchange {
853 
854     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
855     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
856     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
857     mapping(address => mapping(address => uint)) public balances;
858 
859     function withdraw(address tokenAddress, uint amount) public returns (uint);
860     function deposit(address tokenAddress, uint amount) public returns (uint);
861     function ethToken() public returns(address);
862     function frtToken() public returns(address);
863     function owlToken() public returns(address);
864     function getAuctionIndex(address token1, address token2) public view returns(uint256);
865     function postBuyOrder(address token1, address token2, uint256 auctionIndex, uint256 amount) public returns(uint256);
866     function postSellOrder(address token1, address token2, uint256 auctionIndex, uint256 tokensBought) public returns(uint256, uint256);
867     function getCurrentAuctionPrice(address token1, address token2, uint256 auctionIndex) public view returns(uint256, uint256);
868     function claimSellerFunds(address sellToken, address buyToken, address user, uint auctionIndex) public returns (uint returned, uint frtsIssued);
869 }
870 
871 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
872 
873 pragma solidity ^0.5.2;
874 
875 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
876 /// @author Alan Lu - <alan@gnosis.pm>
877 contract Proxied {
878     address public masterCopy;
879 }
880 
881 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
882 /// @author Stefan George - <stefan@gnosis.pm>
883 contract Proxy is Proxied {
884     /// @dev Constructor function sets address of master copy contract.
885     /// @param _masterCopy Master copy address.
886     constructor(address _masterCopy) public {
887         require(_masterCopy != address(0), "The master copy is required");
888         masterCopy = _masterCopy;
889     }
890 
891     /// @dev Fallback function forwards all transactions and returns all received return data.
892     function() external payable {
893         address _masterCopy = masterCopy;
894         assembly {
895             calldatacopy(0, 0, calldatasize)
896             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
897             returndatacopy(0, 0, returndatasize)
898             switch success
899                 case 0 {
900                     revert(0, returndatasize)
901                 }
902                 default {
903                     return(0, returndatasize)
904                 }
905         }
906     }
907 }
908 
909 // File: @gnosis.pm/util-contracts/contracts/Token.sol
910 
911 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
912 pragma solidity ^0.5.2;
913 
914 /// @title Abstract token contract - Functions to be implemented by token contracts
915 contract Token {
916     /*
917      *  Events
918      */
919     event Transfer(address indexed from, address indexed to, uint value);
920     event Approval(address indexed owner, address indexed spender, uint value);
921 
922     /*
923      *  Public functions
924      */
925     function transfer(address to, uint value) public returns (bool);
926     function transferFrom(address from, address to, uint value) public returns (bool);
927     function approve(address spender, uint value) public returns (bool);
928     function balanceOf(address owner) public view returns (uint);
929     function allowance(address owner, address spender) public view returns (uint);
930     function totalSupply() public view returns (uint);
931 }
932 
933 // File: @gnosis.pm/util-contracts/contracts/Math.sol
934 
935 pragma solidity ^0.5.2;
936 
937 /// @title Math library - Allows calculation of logarithmic and exponential functions
938 /// @author Alan Lu - <alan.lu@gnosis.pm>
939 /// @author Stefan George - <stefan@gnosis.pm>
940 library GnosisMath {
941     /*
942      *  Constants
943      */
944     // This is equal to 1 in our calculations
945     uint public constant ONE = 0x10000000000000000;
946     uint public constant LN2 = 0xb17217f7d1cf79ac;
947     uint public constant LOG2_E = 0x171547652b82fe177;
948 
949     /*
950      *  Public functions
951      */
952     /// @dev Returns natural exponential function value of given x
953     /// @param x x
954     /// @return e**x
955     function exp(int x) public pure returns (uint) {
956         // revert if x is > MAX_POWER, where
957         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
958         require(x <= 2454971259878909886679);
959         // return 0 if exp(x) is tiny, using
960         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
961         if (x < -818323753292969962227) return 0;
962         // Transform so that e^x -> 2^x
963         x = x * int(ONE) / int(LN2);
964         // 2^x = 2^whole(x) * 2^frac(x)
965         //       ^^^^^^^^^^ is a bit shift
966         // so Taylor expand on z = frac(x)
967         int shift;
968         uint z;
969         if (x >= 0) {
970             shift = x / int(ONE);
971             z = uint(x % int(ONE));
972         } else {
973             shift = x / int(ONE) - 1;
974             z = ONE - uint(-x % int(ONE));
975         }
976         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
977         //
978         // Can generate the z coefficients using mpmath and the following lines
979         // >>> from mpmath import mp
980         // >>> mp.dps = 100
981         // >>> ONE =  0x10000000000000000
982         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
983         // 0xb17217f7d1cf79ab
984         // 0x3d7f7bff058b1d50
985         // 0xe35846b82505fc5
986         // 0x276556df749cee5
987         // 0x5761ff9e299cc4
988         // 0xa184897c363c3
989         uint zpow = z;
990         uint result = ONE;
991         result += 0xb17217f7d1cf79ab * zpow / ONE;
992         zpow = zpow * z / ONE;
993         result += 0x3d7f7bff058b1d50 * zpow / ONE;
994         zpow = zpow * z / ONE;
995         result += 0xe35846b82505fc5 * zpow / ONE;
996         zpow = zpow * z / ONE;
997         result += 0x276556df749cee5 * zpow / ONE;
998         zpow = zpow * z / ONE;
999         result += 0x5761ff9e299cc4 * zpow / ONE;
1000         zpow = zpow * z / ONE;
1001         result += 0xa184897c363c3 * zpow / ONE;
1002         zpow = zpow * z / ONE;
1003         result += 0xffe5fe2c4586 * zpow / ONE;
1004         zpow = zpow * z / ONE;
1005         result += 0x162c0223a5c8 * zpow / ONE;
1006         zpow = zpow * z / ONE;
1007         result += 0x1b5253d395e * zpow / ONE;
1008         zpow = zpow * z / ONE;
1009         result += 0x1e4cf5158b * zpow / ONE;
1010         zpow = zpow * z / ONE;
1011         result += 0x1e8cac735 * zpow / ONE;
1012         zpow = zpow * z / ONE;
1013         result += 0x1c3bd650 * zpow / ONE;
1014         zpow = zpow * z / ONE;
1015         result += 0x1816193 * zpow / ONE;
1016         zpow = zpow * z / ONE;
1017         result += 0x131496 * zpow / ONE;
1018         zpow = zpow * z / ONE;
1019         result += 0xe1b7 * zpow / ONE;
1020         zpow = zpow * z / ONE;
1021         result += 0x9c7 * zpow / ONE;
1022         if (shift >= 0) {
1023             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
1024             return result << shift;
1025         } else return result >> (-shift);
1026     }
1027 
1028     /// @dev Returns natural logarithm value of given x
1029     /// @param x x
1030     /// @return ln(x)
1031     function ln(uint x) public pure returns (int) {
1032         require(x > 0);
1033         // binary search for floor(log2(x))
1034         int ilog2 = floorLog2(x);
1035         int z;
1036         if (ilog2 < 0) z = int(x << uint(-ilog2));
1037         else z = int(x >> uint(ilog2));
1038         // z = x * 2^-⌊log₂x⌋
1039         // so 1 <= z < 2
1040         // and ln z = ln x - ⌊log₂x⌋/log₂e
1041         // so just compute ln z using artanh series
1042         // and calculate ln x from that
1043         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
1044         int halflnz = term;
1045         int termpow = term * term / int(ONE) * term / int(ONE);
1046         halflnz += termpow / 3;
1047         termpow = termpow * term / int(ONE) * term / int(ONE);
1048         halflnz += termpow / 5;
1049         termpow = termpow * term / int(ONE) * term / int(ONE);
1050         halflnz += termpow / 7;
1051         termpow = termpow * term / int(ONE) * term / int(ONE);
1052         halflnz += termpow / 9;
1053         termpow = termpow * term / int(ONE) * term / int(ONE);
1054         halflnz += termpow / 11;
1055         termpow = termpow * term / int(ONE) * term / int(ONE);
1056         halflnz += termpow / 13;
1057         termpow = termpow * term / int(ONE) * term / int(ONE);
1058         halflnz += termpow / 15;
1059         termpow = termpow * term / int(ONE) * term / int(ONE);
1060         halflnz += termpow / 17;
1061         termpow = termpow * term / int(ONE) * term / int(ONE);
1062         halflnz += termpow / 19;
1063         termpow = termpow * term / int(ONE) * term / int(ONE);
1064         halflnz += termpow / 21;
1065         termpow = termpow * term / int(ONE) * term / int(ONE);
1066         halflnz += termpow / 23;
1067         termpow = termpow * term / int(ONE) * term / int(ONE);
1068         halflnz += termpow / 25;
1069         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
1070     }
1071 
1072     /// @dev Returns base 2 logarithm value of given x
1073     /// @param x x
1074     /// @return logarithmic value
1075     function floorLog2(uint x) public pure returns (int lo) {
1076         lo = -64;
1077         int hi = 193;
1078         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
1079         int mid = (hi + lo) >> 1;
1080         while ((lo + 1) < hi) {
1081             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
1082             else lo = mid;
1083             mid = (hi + lo) >> 1;
1084         }
1085     }
1086 
1087     /// @dev Returns maximum of an array
1088     /// @param nums Numbers to look through
1089     /// @return Maximum number
1090     function max(int[] memory nums) public pure returns (int maxNum) {
1091         require(nums.length > 0);
1092         maxNum = -2 ** 255;
1093         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
1094     }
1095 
1096     /// @dev Returns whether an add operation causes an overflow
1097     /// @param a First addend
1098     /// @param b Second addend
1099     /// @return Did no overflow occur?
1100     function safeToAdd(uint a, uint b) internal pure returns (bool) {
1101         return a + b >= a;
1102     }
1103 
1104     /// @dev Returns whether a subtraction operation causes an underflow
1105     /// @param a Minuend
1106     /// @param b Subtrahend
1107     /// @return Did no underflow occur?
1108     function safeToSub(uint a, uint b) internal pure returns (bool) {
1109         return a >= b;
1110     }
1111 
1112     /// @dev Returns whether a multiply operation causes an overflow
1113     /// @param a First factor
1114     /// @param b Second factor
1115     /// @return Did no overflow occur?
1116     function safeToMul(uint a, uint b) internal pure returns (bool) {
1117         return b == 0 || a * b / b == a;
1118     }
1119 
1120     /// @dev Returns sum if no overflow occurred
1121     /// @param a First addend
1122     /// @param b Second addend
1123     /// @return Sum
1124     function add(uint a, uint b) internal pure returns (uint) {
1125         require(safeToAdd(a, b));
1126         return a + b;
1127     }
1128 
1129     /// @dev Returns difference if no overflow occurred
1130     /// @param a Minuend
1131     /// @param b Subtrahend
1132     /// @return Difference
1133     function sub(uint a, uint b) internal pure returns (uint) {
1134         require(safeToSub(a, b));
1135         return a - b;
1136     }
1137 
1138     /// @dev Returns product if no overflow occurred
1139     /// @param a First factor
1140     /// @param b Second factor
1141     /// @return Product
1142     function mul(uint a, uint b) internal pure returns (uint) {
1143         require(safeToMul(a, b));
1144         return a * b;
1145     }
1146 
1147     /// @dev Returns whether an add operation causes an overflow
1148     /// @param a First addend
1149     /// @param b Second addend
1150     /// @return Did no overflow occur?
1151     function safeToAdd(int a, int b) internal pure returns (bool) {
1152         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
1153     }
1154 
1155     /// @dev Returns whether a subtraction operation causes an underflow
1156     /// @param a Minuend
1157     /// @param b Subtrahend
1158     /// @return Did no underflow occur?
1159     function safeToSub(int a, int b) internal pure returns (bool) {
1160         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
1161     }
1162 
1163     /// @dev Returns whether a multiply operation causes an overflow
1164     /// @param a First factor
1165     /// @param b Second factor
1166     /// @return Did no overflow occur?
1167     function safeToMul(int a, int b) internal pure returns (bool) {
1168         return (b == 0) || (a * b / b == a);
1169     }
1170 
1171     /// @dev Returns sum if no overflow occurred
1172     /// @param a First addend
1173     /// @param b Second addend
1174     /// @return Sum
1175     function add(int a, int b) internal pure returns (int) {
1176         require(safeToAdd(a, b));
1177         return a + b;
1178     }
1179 
1180     /// @dev Returns difference if no overflow occurred
1181     /// @param a Minuend
1182     /// @param b Subtrahend
1183     /// @return Difference
1184     function sub(int a, int b) internal pure returns (int) {
1185         require(safeToSub(a, b));
1186         return a - b;
1187     }
1188 
1189     /// @dev Returns product if no overflow occurred
1190     /// @param a First factor
1191     /// @param b Second factor
1192     /// @return Product
1193     function mul(int a, int b) internal pure returns (int) {
1194         require(safeToMul(a, b));
1195         return a * b;
1196     }
1197 }
1198 
1199 // File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol
1200 
1201 pragma solidity ^0.5.2;
1202 
1203 
1204 
1205 
1206 /**
1207  * Deprecated: Use Open Zeppeling one instead
1208  */
1209 contract StandardTokenData {
1210     /*
1211      *  Storage
1212      */
1213     mapping(address => uint) balances;
1214     mapping(address => mapping(address => uint)) allowances;
1215     uint totalTokens;
1216 }
1217 
1218 /**
1219  * Deprecated: Use Open Zeppeling one instead
1220  */
1221 /// @title Standard token contract with overflow protection
1222 contract GnosisStandardToken is Token, StandardTokenData {
1223     using GnosisMath for *;
1224 
1225     /*
1226      *  Public functions
1227      */
1228     /// @dev Transfers sender's tokens to a given address. Returns success
1229     /// @param to Address of token receiver
1230     /// @param value Number of tokens to transfer
1231     /// @return Was transfer successful?
1232     function transfer(address to, uint value) public returns (bool) {
1233         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
1234             return false;
1235         }
1236 
1237         balances[msg.sender] -= value;
1238         balances[to] += value;
1239         emit Transfer(msg.sender, to, value);
1240         return true;
1241     }
1242 
1243     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
1244     /// @param from Address from where tokens are withdrawn
1245     /// @param to Address to where tokens are sent
1246     /// @param value Number of tokens to transfer
1247     /// @return Was transfer successful?
1248     function transferFrom(address from, address to, uint value) public returns (bool) {
1249         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
1250             value
1251         ) || !balances[to].safeToAdd(value)) {
1252             return false;
1253         }
1254         balances[from] -= value;
1255         allowances[from][msg.sender] -= value;
1256         balances[to] += value;
1257         emit Transfer(from, to, value);
1258         return true;
1259     }
1260 
1261     /// @dev Sets approved amount of tokens for spender. Returns success
1262     /// @param spender Address of allowed account
1263     /// @param value Number of approved tokens
1264     /// @return Was approval successful?
1265     function approve(address spender, uint value) public returns (bool) {
1266         allowances[msg.sender][spender] = value;
1267         emit Approval(msg.sender, spender, value);
1268         return true;
1269     }
1270 
1271     /// @dev Returns number of allowed tokens for given address
1272     /// @param owner Address of token owner
1273     /// @param spender Address of token spender
1274     /// @return Remaining allowance for spender
1275     function allowance(address owner, address spender) public view returns (uint) {
1276         return allowances[owner][spender];
1277     }
1278 
1279     /// @dev Returns number of tokens owned by given address
1280     /// @param owner Address of token owner
1281     /// @return Balance of owner
1282     function balanceOf(address owner) public view returns (uint) {
1283         return balances[owner];
1284     }
1285 
1286     /// @dev Returns total supply of tokens
1287     /// @return Total supply
1288     function totalSupply() public view returns (uint) {
1289         return totalTokens;
1290     }
1291 }
1292 
1293 // File: @gnosis.pm/dx-contracts/contracts/TokenFRT.sol
1294 
1295 pragma solidity ^0.5.2;
1296 
1297 
1298 
1299 
1300 /// @title Standard token contract with overflow protection
1301 contract TokenFRT is Proxied, GnosisStandardToken {
1302     address public owner;
1303 
1304     string public constant symbol = "MGN";
1305     string public constant name = "Magnolia Token";
1306     uint8 public constant decimals = 18;
1307 
1308     struct UnlockedToken {
1309         uint amountUnlocked;
1310         uint withdrawalTime;
1311     }
1312 
1313     /*
1314      *  Storage
1315      */
1316     address public minter;
1317 
1318     // user => UnlockedToken
1319     mapping(address => UnlockedToken) public unlockedTokens;
1320 
1321     // user => amount
1322     mapping(address => uint) public lockedTokenBalances;
1323 
1324     /*
1325      *  Public functions
1326      */
1327 
1328     // @dev allows to set the minter of Magnolia tokens once.
1329     // @param   _minter the minter of the Magnolia tokens, should be the DX-proxy
1330     function updateMinter(address _minter) public {
1331         require(msg.sender == owner, "Only the minter can set a new one");
1332         require(_minter != address(0), "The new minter must be a valid address");
1333 
1334         minter = _minter;
1335     }
1336 
1337     // @dev the intention is to set the owner as the DX-proxy, once it is deployed
1338     // Then only an update of the DX-proxy contract after a 30 days delay could change the minter again.
1339     function updateOwner(address _owner) public {
1340         require(msg.sender == owner, "Only the owner can update the owner");
1341         require(_owner != address(0), "The new owner must be a valid address");
1342         owner = _owner;
1343     }
1344 
1345     function mintTokens(address user, uint amount) public {
1346         require(msg.sender == minter, "Only the minter can mint tokens");
1347 
1348         lockedTokenBalances[user] = add(lockedTokenBalances[user], amount);
1349         totalTokens = add(totalTokens, amount);
1350     }
1351 
1352     /// @dev Lock Token
1353     function lockTokens(uint amount) public returns (uint totalAmountLocked) {
1354         // Adjust amount by balance
1355         uint actualAmount = min(amount, balances[msg.sender]);
1356 
1357         // Update state variables
1358         balances[msg.sender] = sub(balances[msg.sender], actualAmount);
1359         lockedTokenBalances[msg.sender] = add(lockedTokenBalances[msg.sender], actualAmount);
1360 
1361         // Get return variable
1362         totalAmountLocked = lockedTokenBalances[msg.sender];
1363     }
1364 
1365     function unlockTokens() public returns (uint totalAmountUnlocked, uint withdrawalTime) {
1366         // Adjust amount by locked balances
1367         uint amount = lockedTokenBalances[msg.sender];
1368 
1369         if (amount > 0) {
1370             // Update state variables
1371             lockedTokenBalances[msg.sender] = sub(lockedTokenBalances[msg.sender], amount);
1372             unlockedTokens[msg.sender].amountUnlocked = add(unlockedTokens[msg.sender].amountUnlocked, amount);
1373             unlockedTokens[msg.sender].withdrawalTime = now + 24 hours;
1374         }
1375 
1376         // Get return variables
1377         totalAmountUnlocked = unlockedTokens[msg.sender].amountUnlocked;
1378         withdrawalTime = unlockedTokens[msg.sender].withdrawalTime;
1379     }
1380 
1381     function withdrawUnlockedTokens() public {
1382         require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
1383         balances[msg.sender] = add(balances[msg.sender], unlockedTokens[msg.sender].amountUnlocked);
1384         unlockedTokens[msg.sender].amountUnlocked = 0;
1385     }
1386 
1387     function min(uint a, uint b) public pure returns (uint) {
1388         if (a < b) {
1389             return a;
1390         } else {
1391             return b;
1392         }
1393     }
1394     
1395     /// @dev Returns whether an add operation causes an overflow
1396     /// @param a First addend
1397     /// @param b Second addend
1398     /// @return Did no overflow occur?
1399     function safeToAdd(uint a, uint b) public pure returns (bool) {
1400         return a + b >= a;
1401     }
1402 
1403     /// @dev Returns whether a subtraction operation causes an underflow
1404     /// @param a Minuend
1405     /// @param b Subtrahend
1406     /// @return Did no underflow occur?
1407     function safeToSub(uint a, uint b) public pure returns (bool) {
1408         return a >= b;
1409     }
1410 
1411     /// @dev Returns sum if no overflow occurred
1412     /// @param a First addend
1413     /// @param b Second addend
1414     /// @return Sum
1415     function add(uint a, uint b) public pure returns (uint) {
1416         require(safeToAdd(a, b), "It must be a safe adition");
1417         return a + b;
1418     }
1419 
1420     /// @dev Returns difference if no overflow occurred
1421     /// @param a Minuend
1422     /// @param b Subtrahend
1423     /// @return Difference
1424     function sub(uint a, uint b) public pure returns (uint) {
1425         require(safeToSub(a, b), "It must be a safe substraction");
1426         return a - b;
1427     }
1428 }
1429 
1430 // File: openzeppelin-solidity/contracts/utils/Address.sol
1431 
1432 pragma solidity ^0.5.0;
1433 
1434 /**
1435  * Utility library of inline functions on addresses
1436  */
1437 library Address {
1438     /**
1439      * Returns whether the target address is a contract
1440      * @dev This function will return false if invoked during the constructor of a contract,
1441      * as the code is not actually created until after the constructor finishes.
1442      * @param account address of the account to check
1443      * @return whether the target address is a contract
1444      */
1445     function isContract(address account) internal view returns (bool) {
1446         uint256 size;
1447         // XXX Currently there is no better way to check if there is a contract in an address
1448         // than to check the size of the code at that address.
1449         // See https://ethereum.stackexchange.com/a/14016/36603
1450         // for more details about how this works.
1451         // TODO Check this again before the Serenity release, because all addresses will be
1452         // contracts then.
1453         // solhint-disable-next-line no-inline-assembly
1454         assembly { size := extcodesize(account) }
1455         return size > 0;
1456     }
1457 }
1458 
1459 // File: @daostack/arc/contracts/libs/SafeERC20.sol
1460 
1461 /*
1462 
1463 SafeERC20 by daostack.
1464 The code is based on a fix by SECBIT Team.
1465 
1466 USE WITH CAUTION & NO WARRANTY
1467 
1468 REFERENCE & RELATED READING
1469 - https://github.com/ethereum/solidity/issues/4116
1470 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
1471 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
1472 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
1473 
1474 */
1475 pragma solidity ^0.5.2;
1476 
1477 
1478 
1479 library SafeERC20 {
1480     using Address for address;
1481 
1482     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
1483     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
1484     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
1485 
1486     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
1487 
1488         // Must be a contract addr first!
1489         require(_erc20Addr.isContract());
1490 
1491         (bool success, bytes memory returnValue) =
1492         // solhint-disable-next-line avoid-low-level-calls
1493         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
1494         // call return false when something wrong
1495         require(success);
1496         //check return value
1497         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1498     }
1499 
1500     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
1501 
1502         // Must be a contract addr first!
1503         require(_erc20Addr.isContract());
1504 
1505         (bool success, bytes memory returnValue) =
1506         // solhint-disable-next-line avoid-low-level-calls
1507         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
1508         // call return false when something wrong
1509         require(success);
1510         //check return value
1511         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1512     }
1513 
1514     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
1515 
1516         // Must be a contract addr first!
1517         require(_erc20Addr.isContract());
1518 
1519         // safeApprove should only be called when setting an initial allowance,
1520         // or when resetting it to zero.
1521         require((_value == 0) || (IERC20(_erc20Addr).allowance(msg.sender, _spender) == 0));
1522 
1523         (bool success, bytes memory returnValue) =
1524         // solhint-disable-next-line avoid-low-level-calls
1525         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
1526         // call return false when something wrong
1527         require(success);
1528         //check return value
1529         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1530     }
1531 }
1532 
1533 // File: contracts/DxMgnPool.sol
1534 
1535 pragma solidity ^0.5.0;
1536 
1537 
1538 
1539 
1540 
1541 
1542 
1543 
1544 contract DxMgnPool is Ownable {
1545     using SafeMath for uint;
1546 
1547     uint constant OWL_ALLOWANCE = 10**36; 
1548     struct Participation {
1549         uint startAuctionCount; // how many auction passed when this participation started contributing
1550         uint poolShares; // number of shares this participation accounts for (absolute)
1551     }
1552     mapping (address => bool) public hasParticpationWithdrawn;
1553     enum State {
1554         Pooling,
1555         PoolingEnded,
1556         DepositWithdrawnFromDx,
1557         MgnUnlocked
1558     }
1559     State public currentState = State.Pooling;
1560 
1561     mapping (address => Participation[]) public participationsByAddress;
1562     uint public totalPoolShares; // total number of shares in this pool
1563     uint public totalPoolSharesCummulative; // over all auctions, the rolling sum of all shares participated
1564     uint public totalDeposit;
1565     uint public totalMgn;
1566     uint public lastParticipatedAuctionIndex;
1567     uint public auctionCount;
1568     
1569     ERC20 public depositToken;
1570     ERC20 public secondaryToken;
1571     TokenFRT public mgnToken;
1572     IDutchExchange public dx;
1573 
1574     uint public poolingPeriodEndTime;
1575 
1576     constructor (
1577         ERC20 _depositToken, 
1578         ERC20 _secondaryToken, 
1579         IDutchExchange _dx,
1580         uint _poolingTimeSeconds
1581     ) public Ownable()
1582     {
1583         depositToken = _depositToken;
1584         secondaryToken = _secondaryToken;
1585         dx = _dx;
1586         mgnToken = TokenFRT(dx.frtToken());
1587         ERC20(dx.owlToken()).approve(address(dx), OWL_ALLOWANCE);
1588         poolingPeriodEndTime = now + _poolingTimeSeconds;
1589     }
1590 
1591     /**
1592      * Public interface
1593      */
1594     function deposit(uint amount) public {
1595         checkForStateUpdate();
1596         require(currentState == State.Pooling, "Pooling is already over");
1597 
1598         uint poolShares = calculatePoolShares(amount);
1599         Participation memory participation = Participation({
1600             startAuctionCount: isDepositTokenTurn() ? auctionCount : auctionCount + 1,
1601             poolShares: poolShares
1602             });
1603         participationsByAddress[msg.sender].push(participation);
1604         totalPoolShares += poolShares;
1605         totalDeposit += amount;
1606 
1607         SafeERC20.safeTransferFrom(address(depositToken), msg.sender, address(this), amount);
1608     }
1609 
1610     function withdrawDeposit() public returns(uint) {
1611         require(currentState == State.DepositWithdrawnFromDx || currentState == State.MgnUnlocked, "Funds not yet withdrawn from dx");
1612         require(!hasParticpationWithdrawn[msg.sender],"sender has already withdrawn funds");
1613 
1614         uint totalDepositAmount = 0;
1615         Participation[] storage participations = participationsByAddress[msg.sender];
1616         uint length = participations.length;
1617         for (uint i = 0; i < length; i++) {
1618             totalDepositAmount += calculateClaimableDeposit(participations[i]);
1619         }
1620         hasParticpationWithdrawn[msg.sender] = true;
1621         SafeERC20.safeTransfer(address(depositToken), msg.sender, totalDepositAmount);
1622         return totalDepositAmount;
1623     }
1624 
1625     function withdrawMagnolia() public returns(uint) {
1626         require(currentState == State.MgnUnlocked, "MGN has not been unlocked, yet");
1627         require(hasParticpationWithdrawn[msg.sender], "Withdraw deposits first");
1628         
1629         uint totalMgnClaimed = 0;
1630         Participation[] memory participations = participationsByAddress[msg.sender];
1631         for (uint i = 0; i < participations.length; i++) {
1632             totalMgnClaimed += calculateClaimableMgn(participations[i]);
1633         }
1634         delete participationsByAddress[msg.sender];
1635         delete hasParticpationWithdrawn[msg.sender];
1636         SafeERC20.safeTransfer(address(mgnToken), msg.sender, totalMgnClaimed);
1637         return totalMgnClaimed;
1638     }
1639 
1640     function withdrawDepositandMagnolia() public returns(uint, uint){ 
1641         return (withdrawDeposit(),withdrawMagnolia());
1642     }
1643 
1644     function participateInAuction() public  onlyOwner() {
1645         checkForStateUpdate();
1646         require(currentState == State.Pooling, "Pooling period is over.");
1647 
1648         uint auctionIndex = dx.getAuctionIndex(address(depositToken), address(secondaryToken));
1649         require(auctionIndex > lastParticipatedAuctionIndex, "Has to wait for new auction to start");
1650 
1651         (address sellToken, address buyToken) = sellAndBuyToken();
1652         uint depositAmount = depositToken.balanceOf(address(this));
1653         if (isDepositTokenTurn()) {
1654             totalPoolSharesCummulative += 2 * totalPoolShares;
1655             if( depositAmount > 0){
1656                 //depositing new tokens
1657                 depositToken.approve(address(dx), depositAmount);
1658                 dx.deposit(address(depositToken), depositAmount);
1659             }
1660         }
1661         // Don't revert if we can't claimSellerFunds
1662         address(dx).call(abi.encodeWithSignature("claimSellerFunds(address,address,address,uint256)", buyToken, sellToken, address(this), lastParticipatedAuctionIndex));
1663 
1664         uint amount = dx.balances(address(sellToken), address(this));
1665         if (isDepositTokenTurn()) {
1666             totalDeposit = amount;
1667         }
1668 
1669         (lastParticipatedAuctionIndex, ) = dx.postSellOrder(sellToken, buyToken, 0, amount);
1670         auctionCount += 1;
1671     }
1672 
1673     function triggerMGNunlockAndClaimTokens() public {
1674         checkForStateUpdate();
1675         require(currentState == State.PoolingEnded, "Pooling period is not yet over.");
1676         require(
1677             dx.getAuctionIndex(address(depositToken), address(secondaryToken)) > lastParticipatedAuctionIndex, 
1678             "Last auction is still running"
1679         );      
1680         
1681         // Don't revert if wen can't claimSellerFunds
1682         address(dx).call(abi.encodeWithSignature("claimSellerFunds(address,address,address,uint256)", secondaryToken, depositToken, address(this), lastParticipatedAuctionIndex));
1683         mgnToken.unlockTokens();
1684 
1685         uint amountOfFundsInDX = dx.balances(address(depositToken), address(this));
1686         totalDeposit = amountOfFundsInDX + depositToken.balanceOf(address(this));
1687         if(amountOfFundsInDX > 0){
1688             dx.withdraw(address(depositToken), amountOfFundsInDX);
1689         }
1690         currentState = State.DepositWithdrawnFromDx;
1691     }
1692 
1693     function withdrawUnlockedMagnoliaFromDx() public {
1694         require(currentState == State.DepositWithdrawnFromDx, "Unlocking not yet triggered");
1695 
1696         // Implicitly we also have:
1697         // require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
1698 
1699         mgnToken.withdrawUnlockedTokens();
1700         totalMgn = mgnToken.balanceOf(address(this));
1701 
1702         currentState = State.MgnUnlocked;
1703     }
1704 
1705     function checkForStateUpdate() public {
1706         if (now >= poolingPeriodEndTime && isDepositTokenTurn() && currentState == State.Pooling) {
1707             currentState = State.PoolingEnded;
1708         }
1709     }
1710 
1711     /// @dev updates state and returns val
1712     function updateAndGetCurrentState() public returns(State) {
1713         checkForStateUpdate();
1714 
1715         return currentState;
1716     }
1717 
1718     /**
1719      * Public View Functions
1720      */
1721      
1722     function numberOfParticipations(address addr) public view returns (uint) {
1723         return participationsByAddress[addr].length;
1724     }
1725 
1726     function participationAtIndex(address addr, uint index) public view returns (uint, uint) {
1727         Participation memory participation = participationsByAddress[addr][index];
1728         return (participation.startAuctionCount, participation.poolShares);
1729     }
1730 
1731     function poolSharesByAddress(address userAddress) external view returns(uint[] memory) {
1732         uint length = participationsByAddress[userAddress].length;        
1733         uint[] memory userTotalPoolShares = new uint[](length);
1734         
1735         for (uint i = 0; i < length; i++) {
1736             userTotalPoolShares[i] = participationsByAddress[userAddress][i].poolShares;
1737         }
1738 
1739         return userTotalPoolShares;
1740     }
1741 
1742     function sellAndBuyToken() public view returns(address sellToken, address buyToken) {
1743         if (isDepositTokenTurn()) {
1744             return (address(depositToken), address(secondaryToken));
1745         } else {
1746             return (address(secondaryToken), address(depositToken)); 
1747         }
1748     }
1749 
1750     function getAllClaimableMgnAndDeposits(address userAddress) external view returns(uint[] memory, uint[] memory) {
1751         uint length = participationsByAddress[userAddress].length;
1752 
1753         uint[] memory allUserClaimableMgn = new uint[](length);
1754         uint[] memory allUserClaimableDeposit = new uint[](length);
1755 
1756         for (uint i = 0; i < length; i++) {
1757             allUserClaimableMgn[i] = calculateClaimableMgn(participationsByAddress[userAddress][i]);
1758             allUserClaimableDeposit[i] = calculateClaimableDeposit(participationsByAddress[userAddress][i]);
1759         }
1760         return (allUserClaimableMgn, allUserClaimableDeposit);
1761     }
1762 
1763     /**
1764      * Internal Helpers
1765      */
1766     
1767     function calculatePoolShares(uint amount) private view returns (uint) {
1768         if (totalDeposit == 0) {
1769             return amount;
1770         } else {
1771             return totalPoolShares.mul(amount) / totalDeposit;
1772         }
1773     }
1774     
1775     function isDepositTokenTurn() private view returns (bool) {
1776         return auctionCount % 2 == 0;
1777     }
1778 
1779     function calculateClaimableMgn(Participation memory participation) private view returns (uint) {
1780         if (totalPoolSharesCummulative == 0) {
1781             return 0;
1782         }
1783         uint duration = auctionCount - participation.startAuctionCount;
1784         return totalMgn.mul(participation.poolShares).mul(duration) / totalPoolSharesCummulative;
1785     }
1786 
1787     function calculateClaimableDeposit(Participation memory participation) private view returns (uint) {
1788         if (totalPoolShares == 0) {
1789             return 0;
1790         }
1791         return totalDeposit.mul(participation.poolShares) / totalPoolShares;
1792     }
1793 }
1794 
1795 // File: contracts/Coordinator.sol
1796 
1797 pragma solidity ^0.5.0;
1798 
1799 contract Coordinator {
1800 
1801     DxMgnPool public dxMgnPool1;
1802     DxMgnPool public dxMgnPool2;
1803 
1804     constructor (
1805         ERC20 _token1,
1806         ERC20 _token2,
1807         IDutchExchange _dx,
1808         uint _poolingTime
1809     ) public {
1810         dxMgnPool1 = new DxMgnPool(_token1, _token2, _dx, _poolingTime);
1811         dxMgnPool2 = new DxMgnPool(_token2, _token1, _dx, _poolingTime);
1812     }
1813 
1814     function participateInAuction() public {
1815         dxMgnPool1.participateInAuction();
1816         dxMgnPool2.participateInAuction();
1817     }
1818 
1819     function canParticipate() public returns (bool) {
1820         uint auctionIndex = dxMgnPool1.dx().getAuctionIndex(
1821             address(dxMgnPool1.depositToken()),
1822             address(dxMgnPool1.secondaryToken())
1823         );
1824         // update the state before checking the currentState
1825         dxMgnPool1.checkForStateUpdate();
1826         // Since both auctions start at the same time, it suffices to check one.
1827         return auctionIndex > dxMgnPool1.lastParticipatedAuctionIndex() && dxMgnPool1.currentState() == DxMgnPool.State.Pooling;
1828     }
1829 
1830 }
