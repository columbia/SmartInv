1 
2 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
3 
4 pragma solidity ^0.5.2;
5 
6 /**
7  * @title ERC20 interface
8  * @dev see https://eips.ethereum.org/EIPS/eip-20
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
30 pragma solidity ^0.5.2;
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error
35  */
36 library SafeMath {
37     /**
38      * @dev Multiplies two unsigned integers, reverts on overflow.
39      */
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
55      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
56      */
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
67      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b <= a);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77      * @dev Adds two unsigned integers, reverts on overflow.
78      */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a);
82 
83         return c;
84     }
85 
86     /**
87      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
88      * reverts when dividing by zero.
89      */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0);
92         return a % b;
93     }
94 }
95 
96 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
97 
98 pragma solidity ^0.5.2;
99 
100 
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://eips.ethereum.org/EIPS/eip-20
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
124      * @dev Total number of tokens in existence
125      */
126     function totalSupply() public view returns (uint256) {
127         return _totalSupply;
128     }
129 
130     /**
131      * @dev Gets the balance of the specified address.
132      * @param owner The address to query the balance of.
133      * @return A uint256 representing the amount owned by the passed address.
134      */
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
150      * @dev Transfer token to a specified address
151      * @param to The address to transfer to.
152      * @param value The amount to be transferred.
153      */
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
169         _approve(msg.sender, spender, value);
170         return true;
171     }
172 
173     /**
174      * @dev Transfer tokens from one address to another.
175      * Note that while this function emits an Approval event, this is not required as per the specification,
176      * and other compliant implementations may not emit the event.
177      * @param from address The address which you want to send tokens from
178      * @param to address The address which you want to transfer to
179      * @param value uint256 the amount of tokens to be transferred
180      */
181     function transferFrom(address from, address to, uint256 value) public returns (bool) {
182         _transfer(from, to, value);
183         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
184         return true;
185     }
186 
187     /**
188      * @dev Increase the amount of tokens that an owner allowed to a spender.
189      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
190      * allowed value is better to use this function to avoid 2 calls (and wait until
191      * the first transaction is mined)
192      * From MonolithDAO Token.sol
193      * Emits an Approval event.
194      * @param spender The address which will spend the funds.
195      * @param addedValue The amount of tokens to increase the allowance by.
196      */
197     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
198         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
199         return true;
200     }
201 
202     /**
203      * @dev Decrease the amount of tokens that an owner allowed to a spender.
204      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
205      * allowed value is better to use this function to avoid 2 calls (and wait until
206      * the first transaction is mined)
207      * From MonolithDAO Token.sol
208      * Emits an Approval event.
209      * @param spender The address which will spend the funds.
210      * @param subtractedValue The amount of tokens to decrease the allowance by.
211      */
212     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
213         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
214         return true;
215     }
216 
217     /**
218      * @dev Transfer token for a specified addresses
219      * @param from The address to transfer from.
220      * @param to The address to transfer to.
221      * @param value The amount to be transferred.
222      */
223     function _transfer(address from, address to, uint256 value) internal {
224         require(to != address(0));
225 
226         _balances[from] = _balances[from].sub(value);
227         _balances[to] = _balances[to].add(value);
228         emit Transfer(from, to, value);
229     }
230 
231     /**
232      * @dev Internal function that mints an amount of the token and assigns it to
233      * an account. This encapsulates the modification of balances such that the
234      * proper events are emitted.
235      * @param account The account that will receive the created tokens.
236      * @param value The amount that will be created.
237      */
238     function _mint(address account, uint256 value) internal {
239         require(account != address(0));
240 
241         _totalSupply = _totalSupply.add(value);
242         _balances[account] = _balances[account].add(value);
243         emit Transfer(address(0), account, value);
244     }
245 
246     /**
247      * @dev Internal function that burns an amount of the token of a given
248      * account.
249      * @param account The account whose tokens will be burnt.
250      * @param value The amount that will be burnt.
251      */
252     function _burn(address account, uint256 value) internal {
253         require(account != address(0));
254 
255         _totalSupply = _totalSupply.sub(value);
256         _balances[account] = _balances[account].sub(value);
257         emit Transfer(account, address(0), value);
258     }
259 
260     /**
261      * @dev Approve an address to spend another addresses' tokens.
262      * @param owner The address that owns the tokens.
263      * @param spender The address that will spend the tokens.
264      * @param value The number of tokens that can be spent.
265      */
266     function _approve(address owner, address spender, uint256 value) internal {
267         require(spender != address(0));
268         require(owner != address(0));
269 
270         _allowed[owner][spender] = value;
271         emit Approval(owner, spender, value);
272     }
273 
274     /**
275      * @dev Internal function that burns an amount of the token of a given
276      * account, deducting from the sender's allowance for said account. Uses the
277      * internal burn function.
278      * Emits an Approval event (reflecting the reduced allowance).
279      * @param account The account whose tokens will be burnt.
280      * @param value The amount that will be burnt.
281      */
282     function _burnFrom(address account, uint256 value) internal {
283         _burn(account, value);
284         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
285     }
286 }
287 
288 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
289 
290 pragma solidity ^0.5.2;
291 
292 /**
293  * @title Ownable
294  * @dev The Ownable contract has an owner address, and provides basic authorization control
295  * functions, this simplifies the implementation of "user permissions".
296  */
297 contract Ownable {
298     address private _owner;
299 
300     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
301 
302     /**
303      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
304      * account.
305      */
306     constructor () internal {
307         _owner = msg.sender;
308         emit OwnershipTransferred(address(0), _owner);
309     }
310 
311     /**
312      * @return the address of the owner.
313      */
314     function owner() public view returns (address) {
315         return _owner;
316     }
317 
318     /**
319      * @dev Throws if called by any account other than the owner.
320      */
321     modifier onlyOwner() {
322         require(isOwner());
323         _;
324     }
325 
326     /**
327      * @return true if `msg.sender` is the owner of the contract.
328      */
329     function isOwner() public view returns (bool) {
330         return msg.sender == _owner;
331     }
332 
333     /**
334      * @dev Allows the current owner to relinquish control of the contract.
335      * It will not be possible to call the functions with the `onlyOwner`
336      * modifier anymore.
337      * @notice Renouncing ownership will leave the contract without an owner,
338      * thereby removing any functionality that is only available to the owner.
339      */
340     function renounceOwnership() public onlyOwner {
341         emit OwnershipTransferred(_owner, address(0));
342         _owner = address(0);
343     }
344 
345     /**
346      * @dev Allows the current owner to transfer control of the contract to a newOwner.
347      * @param newOwner The address to transfer ownership to.
348      */
349     function transferOwnership(address newOwner) public onlyOwner {
350         _transferOwnership(newOwner);
351     }
352 
353     /**
354      * @dev Transfers control of the contract to a newOwner.
355      * @param newOwner The address to transfer ownership to.
356      */
357     function _transferOwnership(address newOwner) internal {
358         require(newOwner != address(0));
359         emit OwnershipTransferred(_owner, newOwner);
360         _owner = newOwner;
361     }
362 }
363 
364 // File: @gnosis.pm/mock-contract/contracts/MockContract.sol
365 
366 pragma solidity ^0.5.0;
367 
368 interface MockInterface {
369 	/**
370 	 * @dev After calling this method, the mock will return `response` when it is called
371 	 * with any calldata that is not mocked more specifically below
372 	 * (e.g. using givenMethodReturn).
373 	 * @param response ABI encoded response that will be returned if method is invoked
374 	 */
375 	function givenAnyReturn(bytes calldata response) external;
376 	function givenAnyReturnBool(bool response) external;
377 	function givenAnyReturnUint(uint response) external;
378 	function givenAnyReturnAddress(address response) external;
379 
380 	function givenAnyRevert() external;
381 	function givenAnyRevertWithMessage(string calldata message) external;
382 	function givenAnyRunOutOfGas() external;
383 
384 	/**
385 	 * @dev After calling this method, the mock will return `response` when the given
386 	 * methodId is called regardless of arguments. If the methodId and arguments
387 	 * are mocked more specifically (using `givenMethodAndArguments`) the latter
388 	 * will take precedence.
389 	 * @param method ABI encoded methodId. It is valid to pass full calldata (including arguments). The mock will extract the methodId from it
390 	 * @param response ABI encoded response that will be returned if method is invoked
391 	 */
392 	function givenMethodReturn(bytes calldata method, bytes calldata response) external;
393 	function givenMethodReturnBool(bytes calldata method, bool response) external;
394 	function givenMethodReturnUint(bytes calldata method, uint response) external;
395 	function givenMethodReturnAddress(bytes calldata method, address response) external;
396 
397 	function givenMethodRevert(bytes calldata method) external;
398 	function givenMethodRevertWithMessage(bytes calldata method, string calldata message) external;
399 	function givenMethodRunOutOfGas(bytes calldata method) external;
400 
401 	/**
402 	 * @dev After calling this method, the mock will return `response` when the given
403 	 * methodId is called with matching arguments. These exact calldataMocks will take
404 	 * precedence over all other calldataMocks.
405 	 * @param call ABI encoded calldata (methodId and arguments)
406 	 * @param response ABI encoded response that will be returned if contract is invoked with calldata
407 	 */
408 	function givenCalldataReturn(bytes calldata call, bytes calldata response) external;
409 	function givenCalldataReturnBool(bytes calldata call, bool response) external;
410 	function givenCalldataReturnUint(bytes calldata call, uint response) external;
411 	function givenCalldataReturnAddress(bytes calldata call, address response) external;
412 
413 	function givenCalldataRevert(bytes calldata call) external;
414 	function givenCalldataRevertWithMessage(bytes calldata call, string calldata message) external;
415 	function givenCalldataRunOutOfGas(bytes calldata call) external;
416 
417 	/**
418 	 * @dev Returns the number of times anything has been called on this mock since last reset
419 	 */
420 	function invocationCount() external returns (uint);
421 
422 	/**
423 	 * @dev Returns the number of times the given method has been called on this mock since last reset
424 	 * @param method ABI encoded methodId. It is valid to pass full calldata (including arguments). The mock will extract the methodId from it
425 	 */
426 	function invocationCountForMethod(bytes calldata method) external returns (uint);
427 
428 	/**
429 	 * @dev Returns the number of times this mock has been called with the exact calldata since last reset.
430 	 * @param call ABI encoded calldata (methodId and arguments)
431 	 */
432 	function invocationCountForCalldata(bytes calldata call) external returns (uint);
433 
434 	/**
435 	 * @dev Resets all mocked methods and invocation counts.
436 	 */
437 	 function reset() external;
438 }
439 
440 /**
441  * Implementation of the MockInterface.
442  */
443 contract MockContract is MockInterface {
444 	enum MockType { Return, Revert, OutOfGas }
445 	
446 	bytes32 public constant MOCKS_LIST_START = hex"01";
447 	bytes public constant MOCKS_LIST_END = "0xff";
448 	bytes32 public constant MOCKS_LIST_END_HASH = keccak256(MOCKS_LIST_END);
449 	bytes4 public constant SENTINEL_ANY_MOCKS = hex"01";
450 
451 	// A linked list allows easy iteration and inclusion checks
452 	mapping(bytes32 => bytes) calldataMocks;
453 	mapping(bytes => MockType) calldataMockTypes;
454 	mapping(bytes => bytes) calldataExpectations;
455 	mapping(bytes => string) calldataRevertMessage;
456 	mapping(bytes32 => uint) calldataInvocations;
457 
458 	mapping(bytes4 => bytes4) methodIdMocks;
459 	mapping(bytes4 => MockType) methodIdMockTypes;
460 	mapping(bytes4 => bytes) methodIdExpectations;
461 	mapping(bytes4 => string) methodIdRevertMessages;
462 	mapping(bytes32 => uint) methodIdInvocations;
463 
464 	MockType fallbackMockType;
465 	bytes fallbackExpectation;
466 	string fallbackRevertMessage;
467 	uint invocations;
468 	uint resetCount;
469 
470 	constructor() public {
471 		calldataMocks[MOCKS_LIST_START] = MOCKS_LIST_END;
472 		methodIdMocks[SENTINEL_ANY_MOCKS] = SENTINEL_ANY_MOCKS;
473 	}
474 
475 	function trackCalldataMock(bytes memory call) private {
476 		bytes32 callHash = keccak256(call);
477 		if (calldataMocks[callHash].length == 0) {
478 			calldataMocks[callHash] = calldataMocks[MOCKS_LIST_START];
479 			calldataMocks[MOCKS_LIST_START] = call;
480 		}
481 	}
482 
483 	function trackMethodIdMock(bytes4 methodId) private {
484 		if (methodIdMocks[methodId] == 0x0) {
485 			methodIdMocks[methodId] = methodIdMocks[SENTINEL_ANY_MOCKS];
486 			methodIdMocks[SENTINEL_ANY_MOCKS] = methodId;
487 		}
488 	}
489 
490 	function _givenAnyReturn(bytes memory response) internal {
491 		fallbackMockType = MockType.Return;
492 		fallbackExpectation = response;
493 	}
494 
495 	function givenAnyReturn(bytes calldata response) external {
496 		_givenAnyReturn(response);
497 	}
498 
499 	function givenAnyReturnBool(bool response) external {
500 		uint flag = response ? 1 : 0;
501 		_givenAnyReturn(uintToBytes(flag));
502 	}
503 
504 	function givenAnyReturnUint(uint response) external {
505 		_givenAnyReturn(uintToBytes(response));	
506 	}
507 
508 	function givenAnyReturnAddress(address response) external {
509 		_givenAnyReturn(uintToBytes(uint(response)));
510 	}
511 
512 	function givenAnyRevert() external {
513 		fallbackMockType = MockType.Revert;
514 		fallbackRevertMessage = "";
515 	}
516 
517 	function givenAnyRevertWithMessage(string calldata message) external {
518 		fallbackMockType = MockType.Revert;
519 		fallbackRevertMessage = message;
520 	}
521 
522 	function givenAnyRunOutOfGas() external {
523 		fallbackMockType = MockType.OutOfGas;
524 	}
525 
526 	function _givenCalldataReturn(bytes memory call, bytes memory response) private  {
527 		calldataMockTypes[call] = MockType.Return;
528 		calldataExpectations[call] = response;
529 		trackCalldataMock(call);
530 	}
531 
532 	function givenCalldataReturn(bytes calldata call, bytes calldata response) external  {
533 		_givenCalldataReturn(call, response);
534 	}
535 
536 	function givenCalldataReturnBool(bytes calldata call, bool response) external {
537 		uint flag = response ? 1 : 0;
538 		_givenCalldataReturn(call, uintToBytes(flag));
539 	}
540 
541 	function givenCalldataReturnUint(bytes calldata call, uint response) external {
542 		_givenCalldataReturn(call, uintToBytes(response));
543 	}
544 
545 	function givenCalldataReturnAddress(bytes calldata call, address response) external {
546 		_givenCalldataReturn(call, uintToBytes(uint(response)));
547 	}
548 
549 	function _givenMethodReturn(bytes memory call, bytes memory response) private {
550 		bytes4 method = bytesToBytes4(call);
551 		methodIdMockTypes[method] = MockType.Return;
552 		methodIdExpectations[method] = response;
553 		trackMethodIdMock(method);		
554 	}
555 
556 	function givenMethodReturn(bytes calldata call, bytes calldata response) external {
557 		_givenMethodReturn(call, response);
558 	}
559 
560 	function givenMethodReturnBool(bytes calldata call, bool response) external {
561 		uint flag = response ? 1 : 0;
562 		_givenMethodReturn(call, uintToBytes(flag));
563 	}
564 
565 	function givenMethodReturnUint(bytes calldata call, uint response) external {
566 		_givenMethodReturn(call, uintToBytes(response));
567 	}
568 
569 	function givenMethodReturnAddress(bytes calldata call, address response) external {
570 		_givenMethodReturn(call, uintToBytes(uint(response)));
571 	}
572 
573 	function givenCalldataRevert(bytes calldata call) external {
574 		calldataMockTypes[call] = MockType.Revert;
575 		calldataRevertMessage[call] = "";
576 		trackCalldataMock(call);
577 	}
578 
579 	function givenMethodRevert(bytes calldata call) external {
580 		bytes4 method = bytesToBytes4(call);
581 		methodIdMockTypes[method] = MockType.Revert;
582 		trackMethodIdMock(method);		
583 	}
584 
585 	function givenCalldataRevertWithMessage(bytes calldata call, string calldata message) external {
586 		calldataMockTypes[call] = MockType.Revert;
587 		calldataRevertMessage[call] = message;
588 		trackCalldataMock(call);
589 	}
590 
591 	function givenMethodRevertWithMessage(bytes calldata call, string calldata message) external {
592 		bytes4 method = bytesToBytes4(call);
593 		methodIdMockTypes[method] = MockType.Revert;
594 		methodIdRevertMessages[method] = message;
595 		trackMethodIdMock(method);		
596 	}
597 
598 	function givenCalldataRunOutOfGas(bytes calldata call) external {
599 		calldataMockTypes[call] = MockType.OutOfGas;
600 		trackCalldataMock(call);
601 	}
602 
603 	function givenMethodRunOutOfGas(bytes calldata call) external {
604 		bytes4 method = bytesToBytes4(call);
605 		methodIdMockTypes[method] = MockType.OutOfGas;
606 		trackMethodIdMock(method);	
607 	}
608 
609 	function invocationCount() external returns (uint) {
610 		return invocations;
611 	}
612 
613 	function invocationCountForMethod(bytes calldata call) external returns (uint) {
614 		bytes4 method = bytesToBytes4(call);
615 		return methodIdInvocations[keccak256(abi.encodePacked(resetCount, method))];
616 	}
617 
618 	function invocationCountForCalldata(bytes calldata call) external returns (uint) {
619 		return calldataInvocations[keccak256(abi.encodePacked(resetCount, call))];
620 	}
621 
622 	function reset() external {
623 		// Reset all exact calldataMocks
624 		bytes memory nextMock = calldataMocks[MOCKS_LIST_START];
625 		bytes32 mockHash = keccak256(nextMock);
626 		// We cannot compary bytes
627 		while(mockHash != MOCKS_LIST_END_HASH) {
628 			// Reset all mock maps
629 			calldataMockTypes[nextMock] = MockType.Return;
630 			calldataExpectations[nextMock] = hex"";
631 			calldataRevertMessage[nextMock] = "";
632 			// Set next mock to remove
633 			nextMock = calldataMocks[mockHash];
634 			// Remove from linked list
635 			calldataMocks[mockHash] = "";
636 			// Update mock hash
637 			mockHash = keccak256(nextMock);
638 		}
639 		// Clear list
640 		calldataMocks[MOCKS_LIST_START] = MOCKS_LIST_END;
641 
642 		// Reset all any calldataMocks
643 		bytes4 nextAnyMock = methodIdMocks[SENTINEL_ANY_MOCKS];
644 		while(nextAnyMock != SENTINEL_ANY_MOCKS) {
645 			bytes4 currentAnyMock = nextAnyMock;
646 			methodIdMockTypes[currentAnyMock] = MockType.Return;
647 			methodIdExpectations[currentAnyMock] = hex"";
648 			methodIdRevertMessages[currentAnyMock] = "";
649 			nextAnyMock = methodIdMocks[currentAnyMock];
650 			// Remove from linked list
651 			methodIdMocks[currentAnyMock] = 0x0;
652 		}
653 		// Clear list
654 		methodIdMocks[SENTINEL_ANY_MOCKS] = SENTINEL_ANY_MOCKS;
655 
656 		fallbackExpectation = "";
657 		fallbackMockType = MockType.Return;
658 		invocations = 0;
659 		resetCount += 1;
660 	}
661 
662 	function useAllGas() private {
663 		while(true) {
664 			bool s;
665 			assembly {
666 				//expensive call to EC multiply contract
667 				s := call(sub(gas, 2000), 6, 0, 0x0, 0xc0, 0x0, 0x60)
668 			}
669 		}
670 	}
671 
672 	function bytesToBytes4(bytes memory b) private pure returns (bytes4) {
673 		bytes4 out;
674 		for (uint i = 0; i < 4; i++) {
675 			out |= bytes4(b[i] & 0xFF) >> (i * 8);
676 		}
677 		return out;
678 	}
679 
680 	function uintToBytes(uint256 x) private pure returns (bytes memory b) {
681 		b = new bytes(32);
682 		assembly { mstore(add(b, 32), x) }
683 	}
684 
685 	function updateInvocationCount(bytes4 methodId, bytes memory originalMsgData) public {
686 		require(msg.sender == address(this), "Can only be called from the contract itself");
687 		invocations += 1;
688 		methodIdInvocations[keccak256(abi.encodePacked(resetCount, methodId))] += 1;
689 		calldataInvocations[keccak256(abi.encodePacked(resetCount, originalMsgData))] += 1;
690 	}
691 
692 	function() payable external {
693 		bytes4 methodId;
694 		assembly {
695 			methodId := calldataload(0)
696 		}
697 
698 		// First, check exact matching overrides
699 		if (calldataMockTypes[msg.data] == MockType.Revert) {
700 			revert(calldataRevertMessage[msg.data]);
701 		}
702 		if (calldataMockTypes[msg.data] == MockType.OutOfGas) {
703 			useAllGas();
704 		}
705 		bytes memory result = calldataExpectations[msg.data];
706 
707 		// Then check method Id overrides
708 		if (result.length == 0) {
709 			if (methodIdMockTypes[methodId] == MockType.Revert) {
710 				revert(methodIdRevertMessages[methodId]);
711 			}
712 			if (methodIdMockTypes[methodId] == MockType.OutOfGas) {
713 				useAllGas();
714 			}
715 			result = methodIdExpectations[methodId];
716 		}
717 
718 		// Last, use the fallback override
719 		if (result.length == 0) {
720 			if (fallbackMockType == MockType.Revert) {
721 				revert(fallbackRevertMessage);
722 			}
723 			if (fallbackMockType == MockType.OutOfGas) {
724 				useAllGas();
725 			}
726 			result = fallbackExpectation;
727 		}
728 
729 		// Record invocation as separate call so we don't rollback in case we are called with STATICCALL
730 		(, bytes memory r) = address(this).call.gas(100000)(abi.encodeWithSignature("updateInvocationCount(bytes4,bytes)", methodId, msg.data));
731 		assert(r.length == 0);
732 		
733 		assembly {
734 			return(add(0x20, result), mload(result))
735 		}
736 	}
737 }
738 
739 // File: openzeppelin-solidity/contracts/access/Roles.sol
740 
741 pragma solidity ^0.5.2;
742 
743 /**
744  * @title Roles
745  * @dev Library for managing addresses assigned to a Role.
746  */
747 library Roles {
748     struct Role {
749         mapping (address => bool) bearer;
750     }
751 
752     /**
753      * @dev give an account access to this role
754      */
755     function add(Role storage role, address account) internal {
756         require(account != address(0));
757         require(!has(role, account));
758 
759         role.bearer[account] = true;
760     }
761 
762     /**
763      * @dev remove an account's access to this role
764      */
765     function remove(Role storage role, address account) internal {
766         require(account != address(0));
767         require(has(role, account));
768 
769         role.bearer[account] = false;
770     }
771 
772     /**
773      * @dev check if an account has this role
774      * @return bool
775      */
776     function has(Role storage role, address account) internal view returns (bool) {
777         require(account != address(0));
778         return role.bearer[account];
779     }
780 }
781 
782 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
783 
784 pragma solidity ^0.5.2;
785 
786 
787 contract MinterRole {
788     using Roles for Roles.Role;
789 
790     event MinterAdded(address indexed account);
791     event MinterRemoved(address indexed account);
792 
793     Roles.Role private _minters;
794 
795     constructor () internal {
796         _addMinter(msg.sender);
797     }
798 
799     modifier onlyMinter() {
800         require(isMinter(msg.sender));
801         _;
802     }
803 
804     function isMinter(address account) public view returns (bool) {
805         return _minters.has(account);
806     }
807 
808     function addMinter(address account) public onlyMinter {
809         _addMinter(account);
810     }
811 
812     function renounceMinter() public {
813         _removeMinter(msg.sender);
814     }
815 
816     function _addMinter(address account) internal {
817         _minters.add(account);
818         emit MinterAdded(account);
819     }
820 
821     function _removeMinter(address account) internal {
822         _minters.remove(account);
823         emit MinterRemoved(account);
824     }
825 }
826 
827 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
828 
829 pragma solidity ^0.5.2;
830 
831 
832 
833 /**
834  * @title ERC20Mintable
835  * @dev ERC20 minting logic
836  */
837 contract ERC20Mintable is ERC20, MinterRole {
838     /**
839      * @dev Function to mint tokens
840      * @param to The address that will receive the minted tokens.
841      * @param value The amount of tokens to mint.
842      * @return A boolean that indicates if the operation was successful.
843      */
844     function mint(address to, uint256 value) public onlyMinter returns (bool) {
845         _mint(to, value);
846         return true;
847     }
848 }
849 
850 // File: contracts/interfaces/IDutchExchange.sol
851 
852 pragma solidity ^0.5.0;
853 
854 
855 
856 contract IDutchExchange {
857 
858     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
859     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
860     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
861     mapping(address => mapping(address => uint)) public balances;
862 
863     function withdraw(address tokenAddress, uint amount) public returns (uint);
864     function deposit(address tokenAddress, uint amount) public returns (uint);
865     function ethToken() public returns(address);
866     function frtToken() public returns(address);
867     function owlToken() public returns(address);
868     function getAuctionIndex(address token1, address token2) public view returns(uint256);
869     function postBuyOrder(address token1, address token2, uint256 auctionIndex, uint256 amount) public returns(uint256);
870     function postSellOrder(address token1, address token2, uint256 auctionIndex, uint256 tokensBought) public returns(uint256, uint256);
871     function getCurrentAuctionPrice(address token1, address token2, uint256 auctionIndex) public view returns(uint256, uint256);
872     function claimSellerFunds(address sellToken, address buyToken, address user, uint auctionIndex) public returns (uint returned, uint frtsIssued);
873 }
874 
875 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
876 
877 pragma solidity ^0.5.2;
878 
879 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
880 /// @author Alan Lu - <alan@gnosis.pm>
881 contract Proxied {
882     address public masterCopy;
883 }
884 
885 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
886 /// @author Stefan George - <stefan@gnosis.pm>
887 contract Proxy is Proxied {
888     /// @dev Constructor function sets address of master copy contract.
889     /// @param _masterCopy Master copy address.
890     constructor(address _masterCopy) public {
891         require(_masterCopy != address(0), "The master copy is required");
892         masterCopy = _masterCopy;
893     }
894 
895     /// @dev Fallback function forwards all transactions and returns all received return data.
896     function() external payable {
897         address _masterCopy = masterCopy;
898         assembly {
899             calldatacopy(0, 0, calldatasize)
900             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
901             returndatacopy(0, 0, returndatasize)
902             switch success
903                 case 0 {
904                     revert(0, returndatasize)
905                 }
906                 default {
907                     return(0, returndatasize)
908                 }
909         }
910     }
911 }
912 
913 // File: @gnosis.pm/util-contracts/contracts/Token.sol
914 
915 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
916 pragma solidity ^0.5.2;
917 
918 /// @title Abstract token contract - Functions to be implemented by token contracts
919 contract Token {
920     /*
921      *  Events
922      */
923     event Transfer(address indexed from, address indexed to, uint value);
924     event Approval(address indexed owner, address indexed spender, uint value);
925 
926     /*
927      *  Public functions
928      */
929     function transfer(address to, uint value) public returns (bool);
930     function transferFrom(address from, address to, uint value) public returns (bool);
931     function approve(address spender, uint value) public returns (bool);
932     function balanceOf(address owner) public view returns (uint);
933     function allowance(address owner, address spender) public view returns (uint);
934     function totalSupply() public view returns (uint);
935 }
936 
937 // File: @gnosis.pm/util-contracts/contracts/Math.sol
938 
939 pragma solidity ^0.5.2;
940 
941 /// @title Math library - Allows calculation of logarithmic and exponential functions
942 /// @author Alan Lu - <alan.lu@gnosis.pm>
943 /// @author Stefan George - <stefan@gnosis.pm>
944 library GnosisMath {
945     /*
946      *  Constants
947      */
948     // This is equal to 1 in our calculations
949     uint public constant ONE = 0x10000000000000000;
950     uint public constant LN2 = 0xb17217f7d1cf79ac;
951     uint public constant LOG2_E = 0x171547652b82fe177;
952 
953     /*
954      *  Public functions
955      */
956     /// @dev Returns natural exponential function value of given x
957     /// @param x x
958     /// @return e**x
959     function exp(int x) public pure returns (uint) {
960         // revert if x is > MAX_POWER, where
961         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
962         require(x <= 2454971259878909886679);
963         // return 0 if exp(x) is tiny, using
964         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
965         if (x < -818323753292969962227) return 0;
966         // Transform so that e^x -> 2^x
967         x = x * int(ONE) / int(LN2);
968         // 2^x = 2^whole(x) * 2^frac(x)
969         //       ^^^^^^^^^^ is a bit shift
970         // so Taylor expand on z = frac(x)
971         int shift;
972         uint z;
973         if (x >= 0) {
974             shift = x / int(ONE);
975             z = uint(x % int(ONE));
976         } else {
977             shift = x / int(ONE) - 1;
978             z = ONE - uint(-x % int(ONE));
979         }
980         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
981         //
982         // Can generate the z coefficients using mpmath and the following lines
983         // >>> from mpmath import mp
984         // >>> mp.dps = 100
985         // >>> ONE =  0x10000000000000000
986         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
987         // 0xb17217f7d1cf79ab
988         // 0x3d7f7bff058b1d50
989         // 0xe35846b82505fc5
990         // 0x276556df749cee5
991         // 0x5761ff9e299cc4
992         // 0xa184897c363c3
993         uint zpow = z;
994         uint result = ONE;
995         result += 0xb17217f7d1cf79ab * zpow / ONE;
996         zpow = zpow * z / ONE;
997         result += 0x3d7f7bff058b1d50 * zpow / ONE;
998         zpow = zpow * z / ONE;
999         result += 0xe35846b82505fc5 * zpow / ONE;
1000         zpow = zpow * z / ONE;
1001         result += 0x276556df749cee5 * zpow / ONE;
1002         zpow = zpow * z / ONE;
1003         result += 0x5761ff9e299cc4 * zpow / ONE;
1004         zpow = zpow * z / ONE;
1005         result += 0xa184897c363c3 * zpow / ONE;
1006         zpow = zpow * z / ONE;
1007         result += 0xffe5fe2c4586 * zpow / ONE;
1008         zpow = zpow * z / ONE;
1009         result += 0x162c0223a5c8 * zpow / ONE;
1010         zpow = zpow * z / ONE;
1011         result += 0x1b5253d395e * zpow / ONE;
1012         zpow = zpow * z / ONE;
1013         result += 0x1e4cf5158b * zpow / ONE;
1014         zpow = zpow * z / ONE;
1015         result += 0x1e8cac735 * zpow / ONE;
1016         zpow = zpow * z / ONE;
1017         result += 0x1c3bd650 * zpow / ONE;
1018         zpow = zpow * z / ONE;
1019         result += 0x1816193 * zpow / ONE;
1020         zpow = zpow * z / ONE;
1021         result += 0x131496 * zpow / ONE;
1022         zpow = zpow * z / ONE;
1023         result += 0xe1b7 * zpow / ONE;
1024         zpow = zpow * z / ONE;
1025         result += 0x9c7 * zpow / ONE;
1026         if (shift >= 0) {
1027             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
1028             return result << shift;
1029         } else return result >> (-shift);
1030     }
1031 
1032     /// @dev Returns natural logarithm value of given x
1033     /// @param x x
1034     /// @return ln(x)
1035     function ln(uint x) public pure returns (int) {
1036         require(x > 0);
1037         // binary search for floor(log2(x))
1038         int ilog2 = floorLog2(x);
1039         int z;
1040         if (ilog2 < 0) z = int(x << uint(-ilog2));
1041         else z = int(x >> uint(ilog2));
1042         // z = x * 2^-⌊log₂x⌋
1043         // so 1 <= z < 2
1044         // and ln z = ln x - ⌊log₂x⌋/log₂e
1045         // so just compute ln z using artanh series
1046         // and calculate ln x from that
1047         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
1048         int halflnz = term;
1049         int termpow = term * term / int(ONE) * term / int(ONE);
1050         halflnz += termpow / 3;
1051         termpow = termpow * term / int(ONE) * term / int(ONE);
1052         halflnz += termpow / 5;
1053         termpow = termpow * term / int(ONE) * term / int(ONE);
1054         halflnz += termpow / 7;
1055         termpow = termpow * term / int(ONE) * term / int(ONE);
1056         halflnz += termpow / 9;
1057         termpow = termpow * term / int(ONE) * term / int(ONE);
1058         halflnz += termpow / 11;
1059         termpow = termpow * term / int(ONE) * term / int(ONE);
1060         halflnz += termpow / 13;
1061         termpow = termpow * term / int(ONE) * term / int(ONE);
1062         halflnz += termpow / 15;
1063         termpow = termpow * term / int(ONE) * term / int(ONE);
1064         halflnz += termpow / 17;
1065         termpow = termpow * term / int(ONE) * term / int(ONE);
1066         halflnz += termpow / 19;
1067         termpow = termpow * term / int(ONE) * term / int(ONE);
1068         halflnz += termpow / 21;
1069         termpow = termpow * term / int(ONE) * term / int(ONE);
1070         halflnz += termpow / 23;
1071         termpow = termpow * term / int(ONE) * term / int(ONE);
1072         halflnz += termpow / 25;
1073         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
1074     }
1075 
1076     /// @dev Returns base 2 logarithm value of given x
1077     /// @param x x
1078     /// @return logarithmic value
1079     function floorLog2(uint x) public pure returns (int lo) {
1080         lo = -64;
1081         int hi = 193;
1082         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
1083         int mid = (hi + lo) >> 1;
1084         while ((lo + 1) < hi) {
1085             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
1086             else lo = mid;
1087             mid = (hi + lo) >> 1;
1088         }
1089     }
1090 
1091     /// @dev Returns maximum of an array
1092     /// @param nums Numbers to look through
1093     /// @return Maximum number
1094     function max(int[] memory nums) public pure returns (int maxNum) {
1095         require(nums.length > 0);
1096         maxNum = -2 ** 255;
1097         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
1098     }
1099 
1100     /// @dev Returns whether an add operation causes an overflow
1101     /// @param a First addend
1102     /// @param b Second addend
1103     /// @return Did no overflow occur?
1104     function safeToAdd(uint a, uint b) internal pure returns (bool) {
1105         return a + b >= a;
1106     }
1107 
1108     /// @dev Returns whether a subtraction operation causes an underflow
1109     /// @param a Minuend
1110     /// @param b Subtrahend
1111     /// @return Did no underflow occur?
1112     function safeToSub(uint a, uint b) internal pure returns (bool) {
1113         return a >= b;
1114     }
1115 
1116     /// @dev Returns whether a multiply operation causes an overflow
1117     /// @param a First factor
1118     /// @param b Second factor
1119     /// @return Did no overflow occur?
1120     function safeToMul(uint a, uint b) internal pure returns (bool) {
1121         return b == 0 || a * b / b == a;
1122     }
1123 
1124     /// @dev Returns sum if no overflow occurred
1125     /// @param a First addend
1126     /// @param b Second addend
1127     /// @return Sum
1128     function add(uint a, uint b) internal pure returns (uint) {
1129         require(safeToAdd(a, b));
1130         return a + b;
1131     }
1132 
1133     /// @dev Returns difference if no overflow occurred
1134     /// @param a Minuend
1135     /// @param b Subtrahend
1136     /// @return Difference
1137     function sub(uint a, uint b) internal pure returns (uint) {
1138         require(safeToSub(a, b));
1139         return a - b;
1140     }
1141 
1142     /// @dev Returns product if no overflow occurred
1143     /// @param a First factor
1144     /// @param b Second factor
1145     /// @return Product
1146     function mul(uint a, uint b) internal pure returns (uint) {
1147         require(safeToMul(a, b));
1148         return a * b;
1149     }
1150 
1151     /// @dev Returns whether an add operation causes an overflow
1152     /// @param a First addend
1153     /// @param b Second addend
1154     /// @return Did no overflow occur?
1155     function safeToAdd(int a, int b) internal pure returns (bool) {
1156         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
1157     }
1158 
1159     /// @dev Returns whether a subtraction operation causes an underflow
1160     /// @param a Minuend
1161     /// @param b Subtrahend
1162     /// @return Did no underflow occur?
1163     function safeToSub(int a, int b) internal pure returns (bool) {
1164         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
1165     }
1166 
1167     /// @dev Returns whether a multiply operation causes an overflow
1168     /// @param a First factor
1169     /// @param b Second factor
1170     /// @return Did no overflow occur?
1171     function safeToMul(int a, int b) internal pure returns (bool) {
1172         return (b == 0) || (a * b / b == a);
1173     }
1174 
1175     /// @dev Returns sum if no overflow occurred
1176     /// @param a First addend
1177     /// @param b Second addend
1178     /// @return Sum
1179     function add(int a, int b) internal pure returns (int) {
1180         require(safeToAdd(a, b));
1181         return a + b;
1182     }
1183 
1184     /// @dev Returns difference if no overflow occurred
1185     /// @param a Minuend
1186     /// @param b Subtrahend
1187     /// @return Difference
1188     function sub(int a, int b) internal pure returns (int) {
1189         require(safeToSub(a, b));
1190         return a - b;
1191     }
1192 
1193     /// @dev Returns product if no overflow occurred
1194     /// @param a First factor
1195     /// @param b Second factor
1196     /// @return Product
1197     function mul(int a, int b) internal pure returns (int) {
1198         require(safeToMul(a, b));
1199         return a * b;
1200     }
1201 }
1202 
1203 // File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol
1204 
1205 pragma solidity ^0.5.2;
1206 
1207 
1208 
1209 
1210 /**
1211  * Deprecated: Use Open Zeppeling one instead
1212  */
1213 contract StandardTokenData {
1214     /*
1215      *  Storage
1216      */
1217     mapping(address => uint) balances;
1218     mapping(address => mapping(address => uint)) allowances;
1219     uint totalTokens;
1220 }
1221 
1222 /**
1223  * Deprecated: Use Open Zeppeling one instead
1224  */
1225 /// @title Standard token contract with overflow protection
1226 contract GnosisStandardToken is Token, StandardTokenData {
1227     using GnosisMath for *;
1228 
1229     /*
1230      *  Public functions
1231      */
1232     /// @dev Transfers sender's tokens to a given address. Returns success
1233     /// @param to Address of token receiver
1234     /// @param value Number of tokens to transfer
1235     /// @return Was transfer successful?
1236     function transfer(address to, uint value) public returns (bool) {
1237         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
1238             return false;
1239         }
1240 
1241         balances[msg.sender] -= value;
1242         balances[to] += value;
1243         emit Transfer(msg.sender, to, value);
1244         return true;
1245     }
1246 
1247     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
1248     /// @param from Address from where tokens are withdrawn
1249     /// @param to Address to where tokens are sent
1250     /// @param value Number of tokens to transfer
1251     /// @return Was transfer successful?
1252     function transferFrom(address from, address to, uint value) public returns (bool) {
1253         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
1254             value
1255         ) || !balances[to].safeToAdd(value)) {
1256             return false;
1257         }
1258         balances[from] -= value;
1259         allowances[from][msg.sender] -= value;
1260         balances[to] += value;
1261         emit Transfer(from, to, value);
1262         return true;
1263     }
1264 
1265     /// @dev Sets approved amount of tokens for spender. Returns success
1266     /// @param spender Address of allowed account
1267     /// @param value Number of approved tokens
1268     /// @return Was approval successful?
1269     function approve(address spender, uint value) public returns (bool) {
1270         allowances[msg.sender][spender] = value;
1271         emit Approval(msg.sender, spender, value);
1272         return true;
1273     }
1274 
1275     /// @dev Returns number of allowed tokens for given address
1276     /// @param owner Address of token owner
1277     /// @param spender Address of token spender
1278     /// @return Remaining allowance for spender
1279     function allowance(address owner, address spender) public view returns (uint) {
1280         return allowances[owner][spender];
1281     }
1282 
1283     /// @dev Returns number of tokens owned by given address
1284     /// @param owner Address of token owner
1285     /// @return Balance of owner
1286     function balanceOf(address owner) public view returns (uint) {
1287         return balances[owner];
1288     }
1289 
1290     /// @dev Returns total supply of tokens
1291     /// @return Total supply
1292     function totalSupply() public view returns (uint) {
1293         return totalTokens;
1294     }
1295 }
1296 
1297 // File: @gnosis.pm/dx-contracts/contracts/TokenFRT.sol
1298 
1299 pragma solidity ^0.5.2;
1300 
1301 
1302 
1303 
1304 /// @title Standard token contract with overflow protection
1305 contract TokenFRT is Proxied, GnosisStandardToken {
1306     address public owner;
1307 
1308     string public constant symbol = "MGN";
1309     string public constant name = "Magnolia Token";
1310     uint8 public constant decimals = 18;
1311 
1312     struct UnlockedToken {
1313         uint amountUnlocked;
1314         uint withdrawalTime;
1315     }
1316 
1317     /*
1318      *  Storage
1319      */
1320     address public minter;
1321 
1322     // user => UnlockedToken
1323     mapping(address => UnlockedToken) public unlockedTokens;
1324 
1325     // user => amount
1326     mapping(address => uint) public lockedTokenBalances;
1327 
1328     /*
1329      *  Public functions
1330      */
1331 
1332     // @dev allows to set the minter of Magnolia tokens once.
1333     // @param   _minter the minter of the Magnolia tokens, should be the DX-proxy
1334     function updateMinter(address _minter) public {
1335         require(msg.sender == owner, "Only the minter can set a new one");
1336         require(_minter != address(0), "The new minter must be a valid address");
1337 
1338         minter = _minter;
1339     }
1340 
1341     // @dev the intention is to set the owner as the DX-proxy, once it is deployed
1342     // Then only an update of the DX-proxy contract after a 30 days delay could change the minter again.
1343     function updateOwner(address _owner) public {
1344         require(msg.sender == owner, "Only the owner can update the owner");
1345         require(_owner != address(0), "The new owner must be a valid address");
1346         owner = _owner;
1347     }
1348 
1349     function mintTokens(address user, uint amount) public {
1350         require(msg.sender == minter, "Only the minter can mint tokens");
1351 
1352         lockedTokenBalances[user] = add(lockedTokenBalances[user], amount);
1353         totalTokens = add(totalTokens, amount);
1354     }
1355 
1356     /// @dev Lock Token
1357     function lockTokens(uint amount) public returns (uint totalAmountLocked) {
1358         // Adjust amount by balance
1359         uint actualAmount = min(amount, balances[msg.sender]);
1360 
1361         // Update state variables
1362         balances[msg.sender] = sub(balances[msg.sender], actualAmount);
1363         lockedTokenBalances[msg.sender] = add(lockedTokenBalances[msg.sender], actualAmount);
1364 
1365         // Get return variable
1366         totalAmountLocked = lockedTokenBalances[msg.sender];
1367     }
1368 
1369     function unlockTokens() public returns (uint totalAmountUnlocked, uint withdrawalTime) {
1370         // Adjust amount by locked balances
1371         uint amount = lockedTokenBalances[msg.sender];
1372 
1373         if (amount > 0) {
1374             // Update state variables
1375             lockedTokenBalances[msg.sender] = sub(lockedTokenBalances[msg.sender], amount);
1376             unlockedTokens[msg.sender].amountUnlocked = add(unlockedTokens[msg.sender].amountUnlocked, amount);
1377             unlockedTokens[msg.sender].withdrawalTime = now + 24 hours;
1378         }
1379 
1380         // Get return variables
1381         totalAmountUnlocked = unlockedTokens[msg.sender].amountUnlocked;
1382         withdrawalTime = unlockedTokens[msg.sender].withdrawalTime;
1383     }
1384 
1385     function withdrawUnlockedTokens() public {
1386         require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
1387         balances[msg.sender] = add(balances[msg.sender], unlockedTokens[msg.sender].amountUnlocked);
1388         unlockedTokens[msg.sender].amountUnlocked = 0;
1389     }
1390 
1391     function min(uint a, uint b) public pure returns (uint) {
1392         if (a < b) {
1393             return a;
1394         } else {
1395             return b;
1396         }
1397     }
1398     
1399     /// @dev Returns whether an add operation causes an overflow
1400     /// @param a First addend
1401     /// @param b Second addend
1402     /// @return Did no overflow occur?
1403     function safeToAdd(uint a, uint b) public pure returns (bool) {
1404         return a + b >= a;
1405     }
1406 
1407     /// @dev Returns whether a subtraction operation causes an underflow
1408     /// @param a Minuend
1409     /// @param b Subtrahend
1410     /// @return Did no underflow occur?
1411     function safeToSub(uint a, uint b) public pure returns (bool) {
1412         return a >= b;
1413     }
1414 
1415     /// @dev Returns sum if no overflow occurred
1416     /// @param a First addend
1417     /// @param b Second addend
1418     /// @return Sum
1419     function add(uint a, uint b) public pure returns (uint) {
1420         require(safeToAdd(a, b), "It must be a safe adition");
1421         return a + b;
1422     }
1423 
1424     /// @dev Returns difference if no overflow occurred
1425     /// @param a Minuend
1426     /// @param b Subtrahend
1427     /// @return Difference
1428     function sub(uint a, uint b) public pure returns (uint) {
1429         require(safeToSub(a, b), "It must be a safe substraction");
1430         return a - b;
1431     }
1432 }
1433 
1434 // File: openzeppelin-solidity/contracts/utils/Address.sol
1435 
1436 pragma solidity ^0.5.2;
1437 
1438 /**
1439  * Utility library of inline functions on addresses
1440  */
1441 library Address {
1442     /**
1443      * Returns whether the target address is a contract
1444      * @dev This function will return false if invoked during the constructor of a contract,
1445      * as the code is not actually created until after the constructor finishes.
1446      * @param account address of the account to check
1447      * @return whether the target address is a contract
1448      */
1449     function isContract(address account) internal view returns (bool) {
1450         uint256 size;
1451         // XXX Currently there is no better way to check if there is a contract in an address
1452         // than to check the size of the code at that address.
1453         // See https://ethereum.stackexchange.com/a/14016/36603
1454         // for more details about how this works.
1455         // TODO Check this again before the Serenity release, because all addresses will be
1456         // contracts then.
1457         // solhint-disable-next-line no-inline-assembly
1458         assembly { size := extcodesize(account) }
1459         return size > 0;
1460     }
1461 }
1462 
1463 // File: @daostack/arc/contracts/libs/SafeERC20.sol
1464 
1465 /*
1466 
1467 SafeERC20 by daostack.
1468 The code is based on a fix by SECBIT Team.
1469 
1470 USE WITH CAUTION & NO WARRANTY
1471 
1472 REFERENCE & RELATED READING
1473 - https://github.com/ethereum/solidity/issues/4116
1474 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
1475 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
1476 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
1477 
1478 */
1479 pragma solidity ^0.5.2;
1480 
1481 
1482 
1483 library SafeERC20 {
1484     using Address for address;
1485 
1486     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
1487     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
1488     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
1489 
1490     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
1491 
1492         // Must be a contract addr first!
1493         require(_erc20Addr.isContract());
1494 
1495         (bool success, bytes memory returnValue) =
1496         // solhint-disable-next-line avoid-low-level-calls
1497         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
1498         // call return false when something wrong
1499         require(success);
1500         //check return value
1501         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1502     }
1503 
1504     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
1505 
1506         // Must be a contract addr first!
1507         require(_erc20Addr.isContract());
1508 
1509         (bool success, bytes memory returnValue) =
1510         // solhint-disable-next-line avoid-low-level-calls
1511         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
1512         // call return false when something wrong
1513         require(success);
1514         //check return value
1515         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1516     }
1517 
1518     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
1519 
1520         // Must be a contract addr first!
1521         require(_erc20Addr.isContract());
1522 
1523         // safeApprove should only be called when setting an initial allowance,
1524         // or when resetting it to zero.
1525         require((_value == 0) || (IERC20(_erc20Addr).allowance(msg.sender, _spender) == 0));
1526 
1527         (bool success, bytes memory returnValue) =
1528         // solhint-disable-next-line avoid-low-level-calls
1529         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
1530         // call return false when something wrong
1531         require(success);
1532         //check return value
1533         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1534     }
1535 }
1536 
1537 // File: contracts/DxMgnPool.sol
1538 
1539 pragma solidity ^0.5.0;
1540 
1541 
1542 
1543 
1544 
1545 
1546 
1547 
1548 contract DxMgnPool is Ownable {
1549     using SafeMath for uint;
1550 
1551     uint constant OWL_ALLOWANCE = 10**36; 
1552     struct Participation {
1553         uint startAuctionCount; // how many auction passed when this participation started contributing
1554         uint poolShares; // number of shares this participation accounts for (absolute)
1555     }
1556     mapping (address => bool) public hasParticpationWithdrawn;
1557     enum State {
1558         Pooling,
1559         PoolingEnded,
1560         DepositWithdrawnFromDx,
1561         MgnUnlocked
1562     }
1563     State public currentState = State.Pooling;
1564 
1565     mapping (address => Participation[]) public participationsByAddress;
1566     uint public totalPoolShares; // total number of shares in this pool
1567     uint public totalPoolSharesCummulative; // over all auctions, the rolling sum of all shares participated
1568     uint public totalDeposit;
1569     uint public totalMgn;
1570     uint public lastParticipatedAuctionIndex;
1571     uint public auctionCount;
1572     
1573     ERC20 public depositToken;
1574     ERC20 public secondaryToken;
1575     TokenFRT public mgnToken;
1576     IDutchExchange public dx;
1577 
1578     uint public poolingPeriodEndTime;
1579 
1580     constructor (
1581         ERC20 _depositToken, 
1582         ERC20 _secondaryToken, 
1583         IDutchExchange _dx,
1584         uint _poolingTimeSeconds
1585     ) public Ownable()
1586     {
1587         depositToken = _depositToken;
1588         secondaryToken = _secondaryToken;
1589         dx = _dx;
1590         mgnToken = TokenFRT(dx.frtToken());
1591         ERC20(dx.owlToken()).approve(address(dx), OWL_ALLOWANCE);
1592         poolingPeriodEndTime = now + _poolingTimeSeconds;
1593     }
1594 
1595     /**
1596      * Public interface
1597      */
1598     function deposit(uint amount) public {
1599         checkForStateUpdate();
1600         require(currentState == State.Pooling, "Pooling is already over");
1601 
1602         uint poolShares = calculatePoolShares(amount);
1603         Participation memory participation = Participation({
1604             startAuctionCount: isDepositTokenTurn() ? auctionCount : auctionCount + 1,
1605             poolShares: poolShares
1606             });
1607         participationsByAddress[msg.sender].push(participation);
1608         totalPoolShares += poolShares;
1609         totalDeposit += amount;
1610 
1611         SafeERC20.safeTransferFrom(address(depositToken), msg.sender, address(this), amount);
1612     }
1613 
1614     function withdrawDeposit() public returns(uint) {
1615         require(currentState == State.DepositWithdrawnFromDx || currentState == State.MgnUnlocked, "Funds not yet withdrawn from dx");
1616         require(!hasParticpationWithdrawn[msg.sender],"sender has already withdrawn funds");
1617 
1618         uint totalDepositAmount = 0;
1619         Participation[] storage participations = participationsByAddress[msg.sender];
1620         uint length = participations.length;
1621         for (uint i = 0; i < length; i++) {
1622             totalDepositAmount += calculateClaimableDeposit(participations[i]);
1623         }
1624         hasParticpationWithdrawn[msg.sender] = true;
1625         SafeERC20.safeTransfer(address(depositToken), msg.sender, totalDepositAmount);
1626         return totalDepositAmount;
1627     }
1628 
1629     function withdrawMagnolia() public returns(uint) {
1630         require(currentState == State.MgnUnlocked, "MGN has not been unlocked, yet");
1631         require(hasParticpationWithdrawn[msg.sender], "Withdraw deposits first");
1632         
1633         uint totalMgnClaimed = 0;
1634         Participation[] memory participations = participationsByAddress[msg.sender];
1635         for (uint i = 0; i < participations.length; i++) {
1636             totalMgnClaimed += calculateClaimableMgn(participations[i]);
1637         }
1638         delete participationsByAddress[msg.sender];
1639         delete hasParticpationWithdrawn[msg.sender];
1640         SafeERC20.safeTransfer(address(mgnToken), msg.sender, totalMgnClaimed);
1641         return totalMgnClaimed;
1642     }
1643 
1644     function withdrawDepositandMagnolia() public returns(uint, uint){ 
1645         return (withdrawDeposit(),withdrawMagnolia());
1646     }
1647 
1648     function participateInAuction() public  onlyOwner() {
1649         checkForStateUpdate();
1650         require(currentState == State.Pooling, "Pooling period is over.");
1651 
1652         uint auctionIndex = dx.getAuctionIndex(address(depositToken), address(secondaryToken));
1653         require(auctionIndex > lastParticipatedAuctionIndex, "Has to wait for new auction to start");
1654 
1655         (address sellToken, address buyToken) = sellAndBuyToken();
1656         uint depositAmount = depositToken.balanceOf(address(this));
1657         if (isDepositTokenTurn()) {
1658             totalPoolSharesCummulative += 2 * totalPoolShares;
1659             if( depositAmount > 0){
1660                 //depositing new tokens
1661                 depositToken.approve(address(dx), depositAmount);
1662                 dx.deposit(address(depositToken), depositAmount);
1663             }
1664         }
1665         // Don't revert if we can't claimSellerFunds
1666         address(dx).call(abi.encodeWithSignature("claimSellerFunds(address,address,address,uint256)", buyToken, sellToken, address(this), lastParticipatedAuctionIndex));
1667 
1668         uint amount = dx.balances(address(sellToken), address(this));
1669         if (isDepositTokenTurn()) {
1670             totalDeposit = amount;
1671         }
1672 
1673         (lastParticipatedAuctionIndex, ) = dx.postSellOrder(sellToken, buyToken, 0, amount);
1674         auctionCount += 1;
1675     }
1676 
1677     function triggerMGNunlockAndClaimTokens() public {
1678         checkForStateUpdate();
1679         require(currentState == State.PoolingEnded, "Pooling period is not yet over.");
1680         require(
1681             dx.getAuctionIndex(address(depositToken), address(secondaryToken)) > lastParticipatedAuctionIndex, 
1682             "Last auction is still running"
1683         );      
1684         
1685         // Don't revert if wen can't claimSellerFunds
1686         address(dx).call(abi.encodeWithSignature("claimSellerFunds(address,address,address,uint256)", secondaryToken, depositToken, address(this), lastParticipatedAuctionIndex));
1687         mgnToken.unlockTokens();
1688 
1689         uint amountOfFundsInDX = dx.balances(address(depositToken), address(this));
1690         totalDeposit = amountOfFundsInDX + depositToken.balanceOf(address(this));
1691         if(amountOfFundsInDX > 0){
1692             dx.withdraw(address(depositToken), amountOfFundsInDX);
1693         }
1694         currentState = State.DepositWithdrawnFromDx;
1695     }
1696 
1697     function withdrawUnlockedMagnoliaFromDx() public {
1698         require(currentState == State.DepositWithdrawnFromDx, "Unlocking not yet triggered");
1699 
1700         // Implicitly we also have:
1701         // require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
1702 
1703         mgnToken.withdrawUnlockedTokens();
1704         totalMgn = mgnToken.balanceOf(address(this));
1705 
1706         currentState = State.MgnUnlocked;
1707     }
1708 
1709     function checkForStateUpdate() public {
1710         if (now >= poolingPeriodEndTime && isDepositTokenTurn() && currentState == State.Pooling) {
1711             currentState = State.PoolingEnded;
1712         }
1713     }
1714 
1715     /// @dev updates state and returns val
1716     function updateAndGetCurrentState() public returns(State) {
1717         checkForStateUpdate();
1718 
1719         return currentState;
1720     }
1721 
1722     /**
1723      * Public View Functions
1724      */
1725      
1726     function numberOfParticipations(address addr) public view returns (uint) {
1727         return participationsByAddress[addr].length;
1728     }
1729 
1730     function participationAtIndex(address addr, uint index) public view returns (uint, uint) {
1731         Participation memory participation = participationsByAddress[addr][index];
1732         return (participation.startAuctionCount, participation.poolShares);
1733     }
1734 
1735     function poolSharesByAddress(address userAddress) external view returns(uint[] memory) {
1736         uint length = participationsByAddress[userAddress].length;        
1737         uint[] memory userTotalPoolShares = new uint[](length);
1738         
1739         for (uint i = 0; i < length; i++) {
1740             userTotalPoolShares[i] = participationsByAddress[userAddress][i].poolShares;
1741         }
1742 
1743         return userTotalPoolShares;
1744     }
1745 
1746     function sellAndBuyToken() public view returns(address sellToken, address buyToken) {
1747         if (isDepositTokenTurn()) {
1748             return (address(depositToken), address(secondaryToken));
1749         } else {
1750             return (address(secondaryToken), address(depositToken)); 
1751         }
1752     }
1753 
1754     function getAllClaimableMgnAndDeposits(address userAddress) external view returns(uint[] memory, uint[] memory) {
1755         uint length = participationsByAddress[userAddress].length;
1756 
1757         uint[] memory allUserClaimableMgn = new uint[](length);
1758         uint[] memory allUserClaimableDeposit = new uint[](length);
1759 
1760         for (uint i = 0; i < length; i++) {
1761             allUserClaimableMgn[i] = calculateClaimableMgn(participationsByAddress[userAddress][i]);
1762             allUserClaimableDeposit[i] = calculateClaimableDeposit(participationsByAddress[userAddress][i]);
1763         }
1764         return (allUserClaimableMgn, allUserClaimableDeposit);
1765     }
1766 
1767     /**
1768      * Internal Helpers
1769      */
1770     
1771     function calculatePoolShares(uint amount) private view returns (uint) {
1772         if (totalDeposit == 0) {
1773             return amount;
1774         } else {
1775             return totalPoolShares.mul(amount) / totalDeposit;
1776         }
1777     }
1778     
1779     function isDepositTokenTurn() private view returns (bool) {
1780         return auctionCount % 2 == 0;
1781     }
1782 
1783     function calculateClaimableMgn(Participation memory participation) private view returns (uint) {
1784         if (totalPoolSharesCummulative == 0) {
1785             return 0;
1786         }
1787         uint duration = auctionCount - participation.startAuctionCount;
1788         return totalMgn.mul(participation.poolShares).mul(duration) / totalPoolSharesCummulative;
1789     }
1790 
1791     function calculateClaimableDeposit(Participation memory participation) private view returns (uint) {
1792         if (totalPoolShares == 0) {
1793             return 0;
1794         }
1795         return totalDeposit.mul(participation.poolShares) / totalPoolShares;
1796     }
1797 }
1798 
1799 // File: contracts/Coordinator.sol
1800 
1801 pragma solidity ^0.5.0;
1802 
1803 contract Coordinator {
1804 
1805     DxMgnPool public dxMgnPool1;
1806     DxMgnPool public dxMgnPool2;
1807 
1808     constructor (
1809         ERC20 _token1,
1810         ERC20 _token2,
1811         IDutchExchange _dx,
1812         uint _poolingTime
1813     ) public {
1814         dxMgnPool1 = new DxMgnPool(_token1, _token2, _dx, _poolingTime);
1815         dxMgnPool2 = new DxMgnPool(_token2, _token1, _dx, _poolingTime);
1816     }
1817 
1818     function participateInAuction() public {
1819         dxMgnPool1.participateInAuction();
1820         dxMgnPool2.participateInAuction();
1821     }
1822 
1823     function canParticipate() public returns (bool) {
1824         uint auctionIndex = dxMgnPool1.dx().getAuctionIndex(
1825             address(dxMgnPool1.depositToken()),
1826             address(dxMgnPool1.secondaryToken())
1827         );
1828         // update the state before checking the currentState
1829         dxMgnPool1.checkForStateUpdate();
1830         // Since both auctions start at the same time, it suffices to check one.
1831         return auctionIndex > dxMgnPool1.lastParticipatedAuctionIndex() && dxMgnPool1.currentState() == DxMgnPool.State.Pooling;
1832     }
1833 
1834 }
