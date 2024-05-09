1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.2;
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://eips.ethereum.org/EIPS/eip-20
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
29 pragma solidity ^0.5.2;
30 
31 /**
32  * @title SafeMath
33  * @dev Unsigned math operations with safety checks that revert on error
34  */
35 library SafeMath {
36     /**
37      * @dev Multiplies two unsigned integers, reverts on overflow.
38      */
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
54      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
55      */
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
66      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
67      */
68     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
69         require(b <= a);
70         uint256 c = a - b;
71 
72         return c;
73     }
74 
75     /**
76      * @dev Adds two unsigned integers, reverts on overflow.
77      */
78     function add(uint256 a, uint256 b) internal pure returns (uint256) {
79         uint256 c = a + b;
80         require(c >= a);
81 
82         return c;
83     }
84 
85     /**
86      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
87      * reverts when dividing by zero.
88      */
89     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
90         require(b != 0);
91         return a % b;
92     }
93 }
94 
95 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
96 
97 pragma solidity ^0.5.2;
98 
99 
100 
101 /**
102  * @title Standard ERC20 token
103  *
104  * @dev Implementation of the basic standard token.
105  * https://eips.ethereum.org/EIPS/eip-20
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
123      * @dev Total number of tokens in existence
124      */
125     function totalSupply() public view returns (uint256) {
126         return _totalSupply;
127     }
128 
129     /**
130      * @dev Gets the balance of the specified address.
131      * @param owner The address to query the balance of.
132      * @return A uint256 representing the amount owned by the passed address.
133      */
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
149      * @dev Transfer token to a specified address
150      * @param to The address to transfer to.
151      * @param value The amount to be transferred.
152      */
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
168         _approve(msg.sender, spender, value);
169         return true;
170     }
171 
172     /**
173      * @dev Transfer tokens from one address to another.
174      * Note that while this function emits an Approval event, this is not required as per the specification,
175      * and other compliant implementations may not emit the event.
176      * @param from address The address which you want to send tokens from
177      * @param to address The address which you want to transfer to
178      * @param value uint256 the amount of tokens to be transferred
179      */
180     function transferFrom(address from, address to, uint256 value) public returns (bool) {
181         _transfer(from, to, value);
182         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
183         return true;
184     }
185 
186     /**
187      * @dev Increase the amount of tokens that an owner allowed to a spender.
188      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
189      * allowed value is better to use this function to avoid 2 calls (and wait until
190      * the first transaction is mined)
191      * From MonolithDAO Token.sol
192      * Emits an Approval event.
193      * @param spender The address which will spend the funds.
194      * @param addedValue The amount of tokens to increase the allowance by.
195      */
196     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
197         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
198         return true;
199     }
200 
201     /**
202      * @dev Decrease the amount of tokens that an owner allowed to a spender.
203      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
204      * allowed value is better to use this function to avoid 2 calls (and wait until
205      * the first transaction is mined)
206      * From MonolithDAO Token.sol
207      * Emits an Approval event.
208      * @param spender The address which will spend the funds.
209      * @param subtractedValue The amount of tokens to decrease the allowance by.
210      */
211     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
212         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
213         return true;
214     }
215 
216     /**
217      * @dev Transfer token for a specified addresses
218      * @param from The address to transfer from.
219      * @param to The address to transfer to.
220      * @param value The amount to be transferred.
221      */
222     function _transfer(address from, address to, uint256 value) internal {
223         require(to != address(0));
224 
225         _balances[from] = _balances[from].sub(value);
226         _balances[to] = _balances[to].add(value);
227         emit Transfer(from, to, value);
228     }
229 
230     /**
231      * @dev Internal function that mints an amount of the token and assigns it to
232      * an account. This encapsulates the modification of balances such that the
233      * proper events are emitted.
234      * @param account The account that will receive the created tokens.
235      * @param value The amount that will be created.
236      */
237     function _mint(address account, uint256 value) internal {
238         require(account != address(0));
239 
240         _totalSupply = _totalSupply.add(value);
241         _balances[account] = _balances[account].add(value);
242         emit Transfer(address(0), account, value);
243     }
244 
245     /**
246      * @dev Internal function that burns an amount of the token of a given
247      * account.
248      * @param account The account whose tokens will be burnt.
249      * @param value The amount that will be burnt.
250      */
251     function _burn(address account, uint256 value) internal {
252         require(account != address(0));
253 
254         _totalSupply = _totalSupply.sub(value);
255         _balances[account] = _balances[account].sub(value);
256         emit Transfer(account, address(0), value);
257     }
258 
259     /**
260      * @dev Approve an address to spend another addresses' tokens.
261      * @param owner The address that owns the tokens.
262      * @param spender The address that will spend the tokens.
263      * @param value The number of tokens that can be spent.
264      */
265     function _approve(address owner, address spender, uint256 value) internal {
266         require(spender != address(0));
267         require(owner != address(0));
268 
269         _allowed[owner][spender] = value;
270         emit Approval(owner, spender, value);
271     }
272 
273     /**
274      * @dev Internal function that burns an amount of the token of a given
275      * account, deducting from the sender's allowance for said account. Uses the
276      * internal burn function.
277      * Emits an Approval event (reflecting the reduced allowance).
278      * @param account The account whose tokens will be burnt.
279      * @param value The amount that will be burnt.
280      */
281     function _burnFrom(address account, uint256 value) internal {
282         _burn(account, value);
283         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
284     }
285 }
286 
287 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
288 
289 pragma solidity ^0.5.2;
290 
291 /**
292  * @title Ownable
293  * @dev The Ownable contract has an owner address, and provides basic authorization control
294  * functions, this simplifies the implementation of "user permissions".
295  */
296 contract Ownable {
297     address private _owner;
298 
299     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
300 
301     /**
302      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
303      * account.
304      */
305     constructor () internal {
306         _owner = msg.sender;
307         emit OwnershipTransferred(address(0), _owner);
308     }
309 
310     /**
311      * @return the address of the owner.
312      */
313     function owner() public view returns (address) {
314         return _owner;
315     }
316 
317     /**
318      * @dev Throws if called by any account other than the owner.
319      */
320     modifier onlyOwner() {
321         require(isOwner());
322         _;
323     }
324 
325     /**
326      * @return true if `msg.sender` is the owner of the contract.
327      */
328     function isOwner() public view returns (bool) {
329         return msg.sender == _owner;
330     }
331 
332     /**
333      * @dev Allows the current owner to relinquish control of the contract.
334      * It will not be possible to call the functions with the `onlyOwner`
335      * modifier anymore.
336      * @notice Renouncing ownership will leave the contract without an owner,
337      * thereby removing any functionality that is only available to the owner.
338      */
339     function renounceOwnership() public onlyOwner {
340         emit OwnershipTransferred(_owner, address(0));
341         _owner = address(0);
342     }
343 
344     /**
345      * @dev Allows the current owner to transfer control of the contract to a newOwner.
346      * @param newOwner The address to transfer ownership to.
347      */
348     function transferOwnership(address newOwner) public onlyOwner {
349         _transferOwnership(newOwner);
350     }
351 
352     /**
353      * @dev Transfers control of the contract to a newOwner.
354      * @param newOwner The address to transfer ownership to.
355      */
356     function _transferOwnership(address newOwner) internal {
357         require(newOwner != address(0));
358         emit OwnershipTransferred(_owner, newOwner);
359         _owner = newOwner;
360     }
361 }
362 
363 // File: @gnosis.pm/mock-contract/contracts/MockContract.sol
364 
365 pragma solidity ^0.5.0;
366 
367 interface MockInterface {
368 	/**
369 	 * @dev After calling this method, the mock will return `response` when it is called
370 	 * with any calldata that is not mocked more specifically below
371 	 * (e.g. using givenMethodReturn).
372 	 * @param response ABI encoded response that will be returned if method is invoked
373 	 */
374 	function givenAnyReturn(bytes calldata response) external;
375 	function givenAnyReturnBool(bool response) external;
376 	function givenAnyReturnUint(uint response) external;
377 	function givenAnyReturnAddress(address response) external;
378 
379 	function givenAnyRevert() external;
380 	function givenAnyRevertWithMessage(string calldata message) external;
381 	function givenAnyRunOutOfGas() external;
382 
383 	/**
384 	 * @dev After calling this method, the mock will return `response` when the given
385 	 * methodId is called regardless of arguments. If the methodId and arguments
386 	 * are mocked more specifically (using `givenMethodAndArguments`) the latter
387 	 * will take precedence.
388 	 * @param method ABI encoded methodId. It is valid to pass full calldata (including arguments). The mock will extract the methodId from it
389 	 * @param response ABI encoded response that will be returned if method is invoked
390 	 */
391 	function givenMethodReturn(bytes calldata method, bytes calldata response) external;
392 	function givenMethodReturnBool(bytes calldata method, bool response) external;
393 	function givenMethodReturnUint(bytes calldata method, uint response) external;
394 	function givenMethodReturnAddress(bytes calldata method, address response) external;
395 
396 	function givenMethodRevert(bytes calldata method) external;
397 	function givenMethodRevertWithMessage(bytes calldata method, string calldata message) external;
398 	function givenMethodRunOutOfGas(bytes calldata method) external;
399 
400 	/**
401 	 * @dev After calling this method, the mock will return `response` when the given
402 	 * methodId is called with matching arguments. These exact calldataMocks will take
403 	 * precedence over all other calldataMocks.
404 	 * @param call ABI encoded calldata (methodId and arguments)
405 	 * @param response ABI encoded response that will be returned if contract is invoked with calldata
406 	 */
407 	function givenCalldataReturn(bytes calldata call, bytes calldata response) external;
408 	function givenCalldataReturnBool(bytes calldata call, bool response) external;
409 	function givenCalldataReturnUint(bytes calldata call, uint response) external;
410 	function givenCalldataReturnAddress(bytes calldata call, address response) external;
411 
412 	function givenCalldataRevert(bytes calldata call) external;
413 	function givenCalldataRevertWithMessage(bytes calldata call, string calldata message) external;
414 	function givenCalldataRunOutOfGas(bytes calldata call) external;
415 
416 	/**
417 	 * @dev Returns the number of times anything has been called on this mock since last reset
418 	 */
419 	function invocationCount() external returns (uint);
420 
421 	/**
422 	 * @dev Returns the number of times the given method has been called on this mock since last reset
423 	 * @param method ABI encoded methodId. It is valid to pass full calldata (including arguments). The mock will extract the methodId from it
424 	 */
425 	function invocationCountForMethod(bytes calldata method) external returns (uint);
426 
427 	/**
428 	 * @dev Returns the number of times this mock has been called with the exact calldata since last reset.
429 	 * @param call ABI encoded calldata (methodId and arguments)
430 	 */
431 	function invocationCountForCalldata(bytes calldata call) external returns (uint);
432 
433 	/**
434 	 * @dev Resets all mocked methods and invocation counts.
435 	 */
436 	 function reset() external;
437 }
438 
439 /**
440  * Implementation of the MockInterface.
441  */
442 contract MockContract is MockInterface {
443 	enum MockType { Return, Revert, OutOfGas }
444 	
445 	bytes32 public constant MOCKS_LIST_START = hex"01";
446 	bytes public constant MOCKS_LIST_END = "0xff";
447 	bytes32 public constant MOCKS_LIST_END_HASH = keccak256(MOCKS_LIST_END);
448 	bytes4 public constant SENTINEL_ANY_MOCKS = hex"01";
449 
450 	// A linked list allows easy iteration and inclusion checks
451 	mapping(bytes32 => bytes) calldataMocks;
452 	mapping(bytes => MockType) calldataMockTypes;
453 	mapping(bytes => bytes) calldataExpectations;
454 	mapping(bytes => string) calldataRevertMessage;
455 	mapping(bytes32 => uint) calldataInvocations;
456 
457 	mapping(bytes4 => bytes4) methodIdMocks;
458 	mapping(bytes4 => MockType) methodIdMockTypes;
459 	mapping(bytes4 => bytes) methodIdExpectations;
460 	mapping(bytes4 => string) methodIdRevertMessages;
461 	mapping(bytes32 => uint) methodIdInvocations;
462 
463 	MockType fallbackMockType;
464 	bytes fallbackExpectation;
465 	string fallbackRevertMessage;
466 	uint invocations;
467 	uint resetCount;
468 
469 	constructor() public {
470 		calldataMocks[MOCKS_LIST_START] = MOCKS_LIST_END;
471 		methodIdMocks[SENTINEL_ANY_MOCKS] = SENTINEL_ANY_MOCKS;
472 	}
473 
474 	function trackCalldataMock(bytes memory call) private {
475 		bytes32 callHash = keccak256(call);
476 		if (calldataMocks[callHash].length == 0) {
477 			calldataMocks[callHash] = calldataMocks[MOCKS_LIST_START];
478 			calldataMocks[MOCKS_LIST_START] = call;
479 		}
480 	}
481 
482 	function trackMethodIdMock(bytes4 methodId) private {
483 		if (methodIdMocks[methodId] == 0x0) {
484 			methodIdMocks[methodId] = methodIdMocks[SENTINEL_ANY_MOCKS];
485 			methodIdMocks[SENTINEL_ANY_MOCKS] = methodId;
486 		}
487 	}
488 
489 	function _givenAnyReturn(bytes memory response) internal {
490 		fallbackMockType = MockType.Return;
491 		fallbackExpectation = response;
492 	}
493 
494 	function givenAnyReturn(bytes calldata response) external {
495 		_givenAnyReturn(response);
496 	}
497 
498 	function givenAnyReturnBool(bool response) external {
499 		uint flag = response ? 1 : 0;
500 		_givenAnyReturn(uintToBytes(flag));
501 	}
502 
503 	function givenAnyReturnUint(uint response) external {
504 		_givenAnyReturn(uintToBytes(response));	
505 	}
506 
507 	function givenAnyReturnAddress(address response) external {
508 		_givenAnyReturn(uintToBytes(uint(response)));
509 	}
510 
511 	function givenAnyRevert() external {
512 		fallbackMockType = MockType.Revert;
513 		fallbackRevertMessage = "";
514 	}
515 
516 	function givenAnyRevertWithMessage(string calldata message) external {
517 		fallbackMockType = MockType.Revert;
518 		fallbackRevertMessage = message;
519 	}
520 
521 	function givenAnyRunOutOfGas() external {
522 		fallbackMockType = MockType.OutOfGas;
523 	}
524 
525 	function _givenCalldataReturn(bytes memory call, bytes memory response) private  {
526 		calldataMockTypes[call] = MockType.Return;
527 		calldataExpectations[call] = response;
528 		trackCalldataMock(call);
529 	}
530 
531 	function givenCalldataReturn(bytes calldata call, bytes calldata response) external  {
532 		_givenCalldataReturn(call, response);
533 	}
534 
535 	function givenCalldataReturnBool(bytes calldata call, bool response) external {
536 		uint flag = response ? 1 : 0;
537 		_givenCalldataReturn(call, uintToBytes(flag));
538 	}
539 
540 	function givenCalldataReturnUint(bytes calldata call, uint response) external {
541 		_givenCalldataReturn(call, uintToBytes(response));
542 	}
543 
544 	function givenCalldataReturnAddress(bytes calldata call, address response) external {
545 		_givenCalldataReturn(call, uintToBytes(uint(response)));
546 	}
547 
548 	function _givenMethodReturn(bytes memory call, bytes memory response) private {
549 		bytes4 method = bytesToBytes4(call);
550 		methodIdMockTypes[method] = MockType.Return;
551 		methodIdExpectations[method] = response;
552 		trackMethodIdMock(method);		
553 	}
554 
555 	function givenMethodReturn(bytes calldata call, bytes calldata response) external {
556 		_givenMethodReturn(call, response);
557 	}
558 
559 	function givenMethodReturnBool(bytes calldata call, bool response) external {
560 		uint flag = response ? 1 : 0;
561 		_givenMethodReturn(call, uintToBytes(flag));
562 	}
563 
564 	function givenMethodReturnUint(bytes calldata call, uint response) external {
565 		_givenMethodReturn(call, uintToBytes(response));
566 	}
567 
568 	function givenMethodReturnAddress(bytes calldata call, address response) external {
569 		_givenMethodReturn(call, uintToBytes(uint(response)));
570 	}
571 
572 	function givenCalldataRevert(bytes calldata call) external {
573 		calldataMockTypes[call] = MockType.Revert;
574 		calldataRevertMessage[call] = "";
575 		trackCalldataMock(call);
576 	}
577 
578 	function givenMethodRevert(bytes calldata call) external {
579 		bytes4 method = bytesToBytes4(call);
580 		methodIdMockTypes[method] = MockType.Revert;
581 		trackMethodIdMock(method);		
582 	}
583 
584 	function givenCalldataRevertWithMessage(bytes calldata call, string calldata message) external {
585 		calldataMockTypes[call] = MockType.Revert;
586 		calldataRevertMessage[call] = message;
587 		trackCalldataMock(call);
588 	}
589 
590 	function givenMethodRevertWithMessage(bytes calldata call, string calldata message) external {
591 		bytes4 method = bytesToBytes4(call);
592 		methodIdMockTypes[method] = MockType.Revert;
593 		methodIdRevertMessages[method] = message;
594 		trackMethodIdMock(method);		
595 	}
596 
597 	function givenCalldataRunOutOfGas(bytes calldata call) external {
598 		calldataMockTypes[call] = MockType.OutOfGas;
599 		trackCalldataMock(call);
600 	}
601 
602 	function givenMethodRunOutOfGas(bytes calldata call) external {
603 		bytes4 method = bytesToBytes4(call);
604 		methodIdMockTypes[method] = MockType.OutOfGas;
605 		trackMethodIdMock(method);	
606 	}
607 
608 	function invocationCount() external returns (uint) {
609 		return invocations;
610 	}
611 
612 	function invocationCountForMethod(bytes calldata call) external returns (uint) {
613 		bytes4 method = bytesToBytes4(call);
614 		return methodIdInvocations[keccak256(abi.encodePacked(resetCount, method))];
615 	}
616 
617 	function invocationCountForCalldata(bytes calldata call) external returns (uint) {
618 		return calldataInvocations[keccak256(abi.encodePacked(resetCount, call))];
619 	}
620 
621 	function reset() external {
622 		// Reset all exact calldataMocks
623 		bytes memory nextMock = calldataMocks[MOCKS_LIST_START];
624 		bytes32 mockHash = keccak256(nextMock);
625 		// We cannot compary bytes
626 		while(mockHash != MOCKS_LIST_END_HASH) {
627 			// Reset all mock maps
628 			calldataMockTypes[nextMock] = MockType.Return;
629 			calldataExpectations[nextMock] = hex"";
630 			calldataRevertMessage[nextMock] = "";
631 			// Set next mock to remove
632 			nextMock = calldataMocks[mockHash];
633 			// Remove from linked list
634 			calldataMocks[mockHash] = "";
635 			// Update mock hash
636 			mockHash = keccak256(nextMock);
637 		}
638 		// Clear list
639 		calldataMocks[MOCKS_LIST_START] = MOCKS_LIST_END;
640 
641 		// Reset all any calldataMocks
642 		bytes4 nextAnyMock = methodIdMocks[SENTINEL_ANY_MOCKS];
643 		while(nextAnyMock != SENTINEL_ANY_MOCKS) {
644 			bytes4 currentAnyMock = nextAnyMock;
645 			methodIdMockTypes[currentAnyMock] = MockType.Return;
646 			methodIdExpectations[currentAnyMock] = hex"";
647 			methodIdRevertMessages[currentAnyMock] = "";
648 			nextAnyMock = methodIdMocks[currentAnyMock];
649 			// Remove from linked list
650 			methodIdMocks[currentAnyMock] = 0x0;
651 		}
652 		// Clear list
653 		methodIdMocks[SENTINEL_ANY_MOCKS] = SENTINEL_ANY_MOCKS;
654 
655 		fallbackExpectation = "";
656 		fallbackMockType = MockType.Return;
657 		invocations = 0;
658 		resetCount += 1;
659 	}
660 
661 	function useAllGas() private {
662 		while(true) {
663 			bool s;
664 			assembly {
665 				//expensive call to EC multiply contract
666 				s := call(sub(gas, 2000), 6, 0, 0x0, 0xc0, 0x0, 0x60)
667 			}
668 		}
669 	}
670 
671 	function bytesToBytes4(bytes memory b) private pure returns (bytes4) {
672 		bytes4 out;
673 		for (uint i = 0; i < 4; i++) {
674 			out |= bytes4(b[i] & 0xFF) >> (i * 8);
675 		}
676 		return out;
677 	}
678 
679 	function uintToBytes(uint256 x) private pure returns (bytes memory b) {
680 		b = new bytes(32);
681 		assembly { mstore(add(b, 32), x) }
682 	}
683 
684 	function updateInvocationCount(bytes4 methodId, bytes memory originalMsgData) public {
685 		require(msg.sender == address(this), "Can only be called from the contract itself");
686 		invocations += 1;
687 		methodIdInvocations[keccak256(abi.encodePacked(resetCount, methodId))] += 1;
688 		calldataInvocations[keccak256(abi.encodePacked(resetCount, originalMsgData))] += 1;
689 	}
690 
691 	function() payable external {
692 		bytes4 methodId;
693 		assembly {
694 			methodId := calldataload(0)
695 		}
696 
697 		// First, check exact matching overrides
698 		if (calldataMockTypes[msg.data] == MockType.Revert) {
699 			revert(calldataRevertMessage[msg.data]);
700 		}
701 		if (calldataMockTypes[msg.data] == MockType.OutOfGas) {
702 			useAllGas();
703 		}
704 		bytes memory result = calldataExpectations[msg.data];
705 
706 		// Then check method Id overrides
707 		if (result.length == 0) {
708 			if (methodIdMockTypes[methodId] == MockType.Revert) {
709 				revert(methodIdRevertMessages[methodId]);
710 			}
711 			if (methodIdMockTypes[methodId] == MockType.OutOfGas) {
712 				useAllGas();
713 			}
714 			result = methodIdExpectations[methodId];
715 		}
716 
717 		// Last, use the fallback override
718 		if (result.length == 0) {
719 			if (fallbackMockType == MockType.Revert) {
720 				revert(fallbackRevertMessage);
721 			}
722 			if (fallbackMockType == MockType.OutOfGas) {
723 				useAllGas();
724 			}
725 			result = fallbackExpectation;
726 		}
727 
728 		// Record invocation as separate call so we don't rollback in case we are called with STATICCALL
729 		(, bytes memory r) = address(this).call.gas(100000)(abi.encodeWithSignature("updateInvocationCount(bytes4,bytes)", methodId, msg.data));
730 		assert(r.length == 0);
731 		
732 		assembly {
733 			return(add(0x20, result), mload(result))
734 		}
735 	}
736 }
737 
738 // File: openzeppelin-solidity/contracts/access/Roles.sol
739 
740 pragma solidity ^0.5.2;
741 
742 /**
743  * @title Roles
744  * @dev Library for managing addresses assigned to a Role.
745  */
746 library Roles {
747     struct Role {
748         mapping (address => bool) bearer;
749     }
750 
751     /**
752      * @dev give an account access to this role
753      */
754     function add(Role storage role, address account) internal {
755         require(account != address(0));
756         require(!has(role, account));
757 
758         role.bearer[account] = true;
759     }
760 
761     /**
762      * @dev remove an account's access to this role
763      */
764     function remove(Role storage role, address account) internal {
765         require(account != address(0));
766         require(has(role, account));
767 
768         role.bearer[account] = false;
769     }
770 
771     /**
772      * @dev check if an account has this role
773      * @return bool
774      */
775     function has(Role storage role, address account) internal view returns (bool) {
776         require(account != address(0));
777         return role.bearer[account];
778     }
779 }
780 
781 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
782 
783 pragma solidity ^0.5.2;
784 
785 
786 contract MinterRole {
787     using Roles for Roles.Role;
788 
789     event MinterAdded(address indexed account);
790     event MinterRemoved(address indexed account);
791 
792     Roles.Role private _minters;
793 
794     constructor () internal {
795         _addMinter(msg.sender);
796     }
797 
798     modifier onlyMinter() {
799         require(isMinter(msg.sender));
800         _;
801     }
802 
803     function isMinter(address account) public view returns (bool) {
804         return _minters.has(account);
805     }
806 
807     function addMinter(address account) public onlyMinter {
808         _addMinter(account);
809     }
810 
811     function renounceMinter() public {
812         _removeMinter(msg.sender);
813     }
814 
815     function _addMinter(address account) internal {
816         _minters.add(account);
817         emit MinterAdded(account);
818     }
819 
820     function _removeMinter(address account) internal {
821         _minters.remove(account);
822         emit MinterRemoved(account);
823     }
824 }
825 
826 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol
827 
828 pragma solidity ^0.5.2;
829 
830 
831 
832 /**
833  * @title ERC20Mintable
834  * @dev ERC20 minting logic
835  */
836 contract ERC20Mintable is ERC20, MinterRole {
837     /**
838      * @dev Function to mint tokens
839      * @param to The address that will receive the minted tokens.
840      * @param value The amount of tokens to mint.
841      * @return A boolean that indicates if the operation was successful.
842      */
843     function mint(address to, uint256 value) public onlyMinter returns (bool) {
844         _mint(to, value);
845         return true;
846     }
847 }
848 
849 // File: contracts/interfaces/IDutchExchange.sol
850 
851 pragma solidity ^0.5.0;
852 
853 
854 
855 contract IDutchExchange {
856 
857     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public sellerBalances;
858     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public buyerBalances;
859     mapping(address => mapping(address => mapping(uint => mapping(address => uint)))) public claimedAmounts;
860     mapping(address => mapping(address => uint)) public balances;
861 
862     function withdraw(address tokenAddress, uint amount) public returns (uint);
863     function deposit(address tokenAddress, uint amount) public returns (uint);
864     function ethToken() public returns(address);
865     function frtToken() public returns(address);
866     function owlToken() public returns(address);
867     function getAuctionIndex(address token1, address token2) public view returns(uint256);
868     function postBuyOrder(address token1, address token2, uint256 auctionIndex, uint256 amount) public returns(uint256);
869     function postSellOrder(address token1, address token2, uint256 auctionIndex, uint256 tokensBought) public returns(uint256, uint256);
870     function getCurrentAuctionPrice(address token1, address token2, uint256 auctionIndex) public view returns(uint256, uint256);
871     function claimSellerFunds(address sellToken, address buyToken, address user, uint auctionIndex) public returns (uint returned, uint frtsIssued);
872 }
873 
874 // File: @gnosis.pm/util-contracts/contracts/Proxy.sol
875 
876 pragma solidity ^0.5.2;
877 
878 /// @title Proxied - indicates that a contract will be proxied. Also defines storage requirements for Proxy.
879 /// @author Alan Lu - <alan@gnosis.pm>
880 contract Proxied {
881     address public masterCopy;
882 }
883 
884 /// @title Proxy - Generic proxy contract allows to execute all transactions applying the code of a master contract.
885 /// @author Stefan George - <stefan@gnosis.pm>
886 contract Proxy is Proxied {
887     /// @dev Constructor function sets address of master copy contract.
888     /// @param _masterCopy Master copy address.
889     constructor(address _masterCopy) public {
890         require(_masterCopy != address(0), "The master copy is required");
891         masterCopy = _masterCopy;
892     }
893 
894     /// @dev Fallback function forwards all transactions and returns all received return data.
895     function() external payable {
896         address _masterCopy = masterCopy;
897         assembly {
898             calldatacopy(0, 0, calldatasize)
899             let success := delegatecall(not(0), _masterCopy, 0, calldatasize, 0, 0)
900             returndatacopy(0, 0, returndatasize)
901             switch success
902                 case 0 {
903                     revert(0, returndatasize)
904                 }
905                 default {
906                     return(0, returndatasize)
907                 }
908         }
909     }
910 }
911 
912 // File: @gnosis.pm/util-contracts/contracts/Token.sol
913 
914 /// Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
915 pragma solidity ^0.5.2;
916 
917 /// @title Abstract token contract - Functions to be implemented by token contracts
918 contract Token {
919     /*
920      *  Events
921      */
922     event Transfer(address indexed from, address indexed to, uint value);
923     event Approval(address indexed owner, address indexed spender, uint value);
924 
925     /*
926      *  Public functions
927      */
928     function transfer(address to, uint value) public returns (bool);
929     function transferFrom(address from, address to, uint value) public returns (bool);
930     function approve(address spender, uint value) public returns (bool);
931     function balanceOf(address owner) public view returns (uint);
932     function allowance(address owner, address spender) public view returns (uint);
933     function totalSupply() public view returns (uint);
934 }
935 
936 // File: @gnosis.pm/util-contracts/contracts/Math.sol
937 
938 pragma solidity ^0.5.2;
939 
940 /// @title Math library - Allows calculation of logarithmic and exponential functions
941 /// @author Alan Lu - <alan.lu@gnosis.pm>
942 /// @author Stefan George - <stefan@gnosis.pm>
943 library GnosisMath {
944     /*
945      *  Constants
946      */
947     // This is equal to 1 in our calculations
948     uint public constant ONE = 0x10000000000000000;
949     uint public constant LN2 = 0xb17217f7d1cf79ac;
950     uint public constant LOG2_E = 0x171547652b82fe177;
951 
952     /*
953      *  Public functions
954      */
955     /// @dev Returns natural exponential function value of given x
956     /// @param x x
957     /// @return e**x
958     function exp(int x) public pure returns (uint) {
959         // revert if x is > MAX_POWER, where
960         // MAX_POWER = int(mp.floor(mp.log(mpf(2**256 - 1) / ONE) * ONE))
961         require(x <= 2454971259878909886679);
962         // return 0 if exp(x) is tiny, using
963         // MIN_POWER = int(mp.floor(mp.log(mpf(1) / ONE) * ONE))
964         if (x < -818323753292969962227) return 0;
965         // Transform so that e^x -> 2^x
966         x = x * int(ONE) / int(LN2);
967         // 2^x = 2^whole(x) * 2^frac(x)
968         //       ^^^^^^^^^^ is a bit shift
969         // so Taylor expand on z = frac(x)
970         int shift;
971         uint z;
972         if (x >= 0) {
973             shift = x / int(ONE);
974             z = uint(x % int(ONE));
975         } else {
976             shift = x / int(ONE) - 1;
977             z = ONE - uint(-x % int(ONE));
978         }
979         // 2^x = 1 + (ln 2) x + (ln 2)^2/2! x^2 + ...
980         //
981         // Can generate the z coefficients using mpmath and the following lines
982         // >>> from mpmath import mp
983         // >>> mp.dps = 100
984         // >>> ONE =  0x10000000000000000
985         // >>> print('\n'.join(hex(int(mp.log(2)**i / mp.factorial(i) * ONE)) for i in range(1, 7)))
986         // 0xb17217f7d1cf79ab
987         // 0x3d7f7bff058b1d50
988         // 0xe35846b82505fc5
989         // 0x276556df749cee5
990         // 0x5761ff9e299cc4
991         // 0xa184897c363c3
992         uint zpow = z;
993         uint result = ONE;
994         result += 0xb17217f7d1cf79ab * zpow / ONE;
995         zpow = zpow * z / ONE;
996         result += 0x3d7f7bff058b1d50 * zpow / ONE;
997         zpow = zpow * z / ONE;
998         result += 0xe35846b82505fc5 * zpow / ONE;
999         zpow = zpow * z / ONE;
1000         result += 0x276556df749cee5 * zpow / ONE;
1001         zpow = zpow * z / ONE;
1002         result += 0x5761ff9e299cc4 * zpow / ONE;
1003         zpow = zpow * z / ONE;
1004         result += 0xa184897c363c3 * zpow / ONE;
1005         zpow = zpow * z / ONE;
1006         result += 0xffe5fe2c4586 * zpow / ONE;
1007         zpow = zpow * z / ONE;
1008         result += 0x162c0223a5c8 * zpow / ONE;
1009         zpow = zpow * z / ONE;
1010         result += 0x1b5253d395e * zpow / ONE;
1011         zpow = zpow * z / ONE;
1012         result += 0x1e4cf5158b * zpow / ONE;
1013         zpow = zpow * z / ONE;
1014         result += 0x1e8cac735 * zpow / ONE;
1015         zpow = zpow * z / ONE;
1016         result += 0x1c3bd650 * zpow / ONE;
1017         zpow = zpow * z / ONE;
1018         result += 0x1816193 * zpow / ONE;
1019         zpow = zpow * z / ONE;
1020         result += 0x131496 * zpow / ONE;
1021         zpow = zpow * z / ONE;
1022         result += 0xe1b7 * zpow / ONE;
1023         zpow = zpow * z / ONE;
1024         result += 0x9c7 * zpow / ONE;
1025         if (shift >= 0) {
1026             if (result >> (256 - shift) > 0) return (2 ** 256 - 1);
1027             return result << shift;
1028         } else return result >> (-shift);
1029     }
1030 
1031     /// @dev Returns natural logarithm value of given x
1032     /// @param x x
1033     /// @return ln(x)
1034     function ln(uint x) public pure returns (int) {
1035         require(x > 0);
1036         // binary search for floor(log2(x))
1037         int ilog2 = floorLog2(x);
1038         int z;
1039         if (ilog2 < 0) z = int(x << uint(-ilog2));
1040         else z = int(x >> uint(ilog2));
1041         // z = x * 2^-⌊log₂x⌋
1042         // so 1 <= z < 2
1043         // and ln z = ln x - ⌊log₂x⌋/log₂e
1044         // so just compute ln z using artanh series
1045         // and calculate ln x from that
1046         int term = (z - int(ONE)) * int(ONE) / (z + int(ONE));
1047         int halflnz = term;
1048         int termpow = term * term / int(ONE) * term / int(ONE);
1049         halflnz += termpow / 3;
1050         termpow = termpow * term / int(ONE) * term / int(ONE);
1051         halflnz += termpow / 5;
1052         termpow = termpow * term / int(ONE) * term / int(ONE);
1053         halflnz += termpow / 7;
1054         termpow = termpow * term / int(ONE) * term / int(ONE);
1055         halflnz += termpow / 9;
1056         termpow = termpow * term / int(ONE) * term / int(ONE);
1057         halflnz += termpow / 11;
1058         termpow = termpow * term / int(ONE) * term / int(ONE);
1059         halflnz += termpow / 13;
1060         termpow = termpow * term / int(ONE) * term / int(ONE);
1061         halflnz += termpow / 15;
1062         termpow = termpow * term / int(ONE) * term / int(ONE);
1063         halflnz += termpow / 17;
1064         termpow = termpow * term / int(ONE) * term / int(ONE);
1065         halflnz += termpow / 19;
1066         termpow = termpow * term / int(ONE) * term / int(ONE);
1067         halflnz += termpow / 21;
1068         termpow = termpow * term / int(ONE) * term / int(ONE);
1069         halflnz += termpow / 23;
1070         termpow = termpow * term / int(ONE) * term / int(ONE);
1071         halflnz += termpow / 25;
1072         return (ilog2 * int(ONE)) * int(ONE) / int(LOG2_E) + 2 * halflnz;
1073     }
1074 
1075     /// @dev Returns base 2 logarithm value of given x
1076     /// @param x x
1077     /// @return logarithmic value
1078     function floorLog2(uint x) public pure returns (int lo) {
1079         lo = -64;
1080         int hi = 193;
1081         // I use a shift here instead of / 2 because it floors instead of rounding towards 0
1082         int mid = (hi + lo) >> 1;
1083         while ((lo + 1) < hi) {
1084             if (mid < 0 && x << uint(-mid) < ONE || mid >= 0 && x >> uint(mid) < ONE) hi = mid;
1085             else lo = mid;
1086             mid = (hi + lo) >> 1;
1087         }
1088     }
1089 
1090     /// @dev Returns maximum of an array
1091     /// @param nums Numbers to look through
1092     /// @return Maximum number
1093     function max(int[] memory nums) public pure returns (int maxNum) {
1094         require(nums.length > 0);
1095         maxNum = -2 ** 255;
1096         for (uint i = 0; i < nums.length; i++) if (nums[i] > maxNum) maxNum = nums[i];
1097     }
1098 
1099     /// @dev Returns whether an add operation causes an overflow
1100     /// @param a First addend
1101     /// @param b Second addend
1102     /// @return Did no overflow occur?
1103     function safeToAdd(uint a, uint b) internal pure returns (bool) {
1104         return a + b >= a;
1105     }
1106 
1107     /// @dev Returns whether a subtraction operation causes an underflow
1108     /// @param a Minuend
1109     /// @param b Subtrahend
1110     /// @return Did no underflow occur?
1111     function safeToSub(uint a, uint b) internal pure returns (bool) {
1112         return a >= b;
1113     }
1114 
1115     /// @dev Returns whether a multiply operation causes an overflow
1116     /// @param a First factor
1117     /// @param b Second factor
1118     /// @return Did no overflow occur?
1119     function safeToMul(uint a, uint b) internal pure returns (bool) {
1120         return b == 0 || a * b / b == a;
1121     }
1122 
1123     /// @dev Returns sum if no overflow occurred
1124     /// @param a First addend
1125     /// @param b Second addend
1126     /// @return Sum
1127     function add(uint a, uint b) internal pure returns (uint) {
1128         require(safeToAdd(a, b));
1129         return a + b;
1130     }
1131 
1132     /// @dev Returns difference if no overflow occurred
1133     /// @param a Minuend
1134     /// @param b Subtrahend
1135     /// @return Difference
1136     function sub(uint a, uint b) internal pure returns (uint) {
1137         require(safeToSub(a, b));
1138         return a - b;
1139     }
1140 
1141     /// @dev Returns product if no overflow occurred
1142     /// @param a First factor
1143     /// @param b Second factor
1144     /// @return Product
1145     function mul(uint a, uint b) internal pure returns (uint) {
1146         require(safeToMul(a, b));
1147         return a * b;
1148     }
1149 
1150     /// @dev Returns whether an add operation causes an overflow
1151     /// @param a First addend
1152     /// @param b Second addend
1153     /// @return Did no overflow occur?
1154     function safeToAdd(int a, int b) internal pure returns (bool) {
1155         return (b >= 0 && a + b >= a) || (b < 0 && a + b < a);
1156     }
1157 
1158     /// @dev Returns whether a subtraction operation causes an underflow
1159     /// @param a Minuend
1160     /// @param b Subtrahend
1161     /// @return Did no underflow occur?
1162     function safeToSub(int a, int b) internal pure returns (bool) {
1163         return (b >= 0 && a - b <= a) || (b < 0 && a - b > a);
1164     }
1165 
1166     /// @dev Returns whether a multiply operation causes an overflow
1167     /// @param a First factor
1168     /// @param b Second factor
1169     /// @return Did no overflow occur?
1170     function safeToMul(int a, int b) internal pure returns (bool) {
1171         return (b == 0) || (a * b / b == a);
1172     }
1173 
1174     /// @dev Returns sum if no overflow occurred
1175     /// @param a First addend
1176     /// @param b Second addend
1177     /// @return Sum
1178     function add(int a, int b) internal pure returns (int) {
1179         require(safeToAdd(a, b));
1180         return a + b;
1181     }
1182 
1183     /// @dev Returns difference if no overflow occurred
1184     /// @param a Minuend
1185     /// @param b Subtrahend
1186     /// @return Difference
1187     function sub(int a, int b) internal pure returns (int) {
1188         require(safeToSub(a, b));
1189         return a - b;
1190     }
1191 
1192     /// @dev Returns product if no overflow occurred
1193     /// @param a First factor
1194     /// @param b Second factor
1195     /// @return Product
1196     function mul(int a, int b) internal pure returns (int) {
1197         require(safeToMul(a, b));
1198         return a * b;
1199     }
1200 }
1201 
1202 // File: @gnosis.pm/util-contracts/contracts/GnosisStandardToken.sol
1203 
1204 pragma solidity ^0.5.2;
1205 
1206 
1207 
1208 
1209 /**
1210  * Deprecated: Use Open Zeppeling one instead
1211  */
1212 contract StandardTokenData {
1213     /*
1214      *  Storage
1215      */
1216     mapping(address => uint) balances;
1217     mapping(address => mapping(address => uint)) allowances;
1218     uint totalTokens;
1219 }
1220 
1221 /**
1222  * Deprecated: Use Open Zeppeling one instead
1223  */
1224 /// @title Standard token contract with overflow protection
1225 contract GnosisStandardToken is Token, StandardTokenData {
1226     using GnosisMath for *;
1227 
1228     /*
1229      *  Public functions
1230      */
1231     /// @dev Transfers sender's tokens to a given address. Returns success
1232     /// @param to Address of token receiver
1233     /// @param value Number of tokens to transfer
1234     /// @return Was transfer successful?
1235     function transfer(address to, uint value) public returns (bool) {
1236         if (!balances[msg.sender].safeToSub(value) || !balances[to].safeToAdd(value)) {
1237             return false;
1238         }
1239 
1240         balances[msg.sender] -= value;
1241         balances[to] += value;
1242         emit Transfer(msg.sender, to, value);
1243         return true;
1244     }
1245 
1246     /// @dev Allows allowed third party to transfer tokens from one address to another. Returns success
1247     /// @param from Address from where tokens are withdrawn
1248     /// @param to Address to where tokens are sent
1249     /// @param value Number of tokens to transfer
1250     /// @return Was transfer successful?
1251     function transferFrom(address from, address to, uint value) public returns (bool) {
1252         if (!balances[from].safeToSub(value) || !allowances[from][msg.sender].safeToSub(
1253             value
1254         ) || !balances[to].safeToAdd(value)) {
1255             return false;
1256         }
1257         balances[from] -= value;
1258         allowances[from][msg.sender] -= value;
1259         balances[to] += value;
1260         emit Transfer(from, to, value);
1261         return true;
1262     }
1263 
1264     /// @dev Sets approved amount of tokens for spender. Returns success
1265     /// @param spender Address of allowed account
1266     /// @param value Number of approved tokens
1267     /// @return Was approval successful?
1268     function approve(address spender, uint value) public returns (bool) {
1269         allowances[msg.sender][spender] = value;
1270         emit Approval(msg.sender, spender, value);
1271         return true;
1272     }
1273 
1274     /// @dev Returns number of allowed tokens for given address
1275     /// @param owner Address of token owner
1276     /// @param spender Address of token spender
1277     /// @return Remaining allowance for spender
1278     function allowance(address owner, address spender) public view returns (uint) {
1279         return allowances[owner][spender];
1280     }
1281 
1282     /// @dev Returns number of tokens owned by given address
1283     /// @param owner Address of token owner
1284     /// @return Balance of owner
1285     function balanceOf(address owner) public view returns (uint) {
1286         return balances[owner];
1287     }
1288 
1289     /// @dev Returns total supply of tokens
1290     /// @return Total supply
1291     function totalSupply() public view returns (uint) {
1292         return totalTokens;
1293     }
1294 }
1295 
1296 // File: @gnosis.pm/dx-contracts/contracts/TokenFRT.sol
1297 
1298 pragma solidity ^0.5.2;
1299 
1300 
1301 
1302 
1303 /// @title Standard token contract with overflow protection
1304 contract TokenFRT is Proxied, GnosisStandardToken {
1305     address public owner;
1306 
1307     string public constant symbol = "MGN";
1308     string public constant name = "Magnolia Token";
1309     uint8 public constant decimals = 18;
1310 
1311     struct UnlockedToken {
1312         uint amountUnlocked;
1313         uint withdrawalTime;
1314     }
1315 
1316     /*
1317      *  Storage
1318      */
1319     address public minter;
1320 
1321     // user => UnlockedToken
1322     mapping(address => UnlockedToken) public unlockedTokens;
1323 
1324     // user => amount
1325     mapping(address => uint) public lockedTokenBalances;
1326 
1327     /*
1328      *  Public functions
1329      */
1330 
1331     // @dev allows to set the minter of Magnolia tokens once.
1332     // @param   _minter the minter of the Magnolia tokens, should be the DX-proxy
1333     function updateMinter(address _minter) public {
1334         require(msg.sender == owner, "Only the minter can set a new one");
1335         require(_minter != address(0), "The new minter must be a valid address");
1336 
1337         minter = _minter;
1338     }
1339 
1340     // @dev the intention is to set the owner as the DX-proxy, once it is deployed
1341     // Then only an update of the DX-proxy contract after a 30 days delay could change the minter again.
1342     function updateOwner(address _owner) public {
1343         require(msg.sender == owner, "Only the owner can update the owner");
1344         require(_owner != address(0), "The new owner must be a valid address");
1345         owner = _owner;
1346     }
1347 
1348     function mintTokens(address user, uint amount) public {
1349         require(msg.sender == minter, "Only the minter can mint tokens");
1350 
1351         lockedTokenBalances[user] = add(lockedTokenBalances[user], amount);
1352         totalTokens = add(totalTokens, amount);
1353     }
1354 
1355     /// @dev Lock Token
1356     function lockTokens(uint amount) public returns (uint totalAmountLocked) {
1357         // Adjust amount by balance
1358         uint actualAmount = min(amount, balances[msg.sender]);
1359 
1360         // Update state variables
1361         balances[msg.sender] = sub(balances[msg.sender], actualAmount);
1362         lockedTokenBalances[msg.sender] = add(lockedTokenBalances[msg.sender], actualAmount);
1363 
1364         // Get return variable
1365         totalAmountLocked = lockedTokenBalances[msg.sender];
1366     }
1367 
1368     function unlockTokens() public returns (uint totalAmountUnlocked, uint withdrawalTime) {
1369         // Adjust amount by locked balances
1370         uint amount = lockedTokenBalances[msg.sender];
1371 
1372         if (amount > 0) {
1373             // Update state variables
1374             lockedTokenBalances[msg.sender] = sub(lockedTokenBalances[msg.sender], amount);
1375             unlockedTokens[msg.sender].amountUnlocked = add(unlockedTokens[msg.sender].amountUnlocked, amount);
1376             unlockedTokens[msg.sender].withdrawalTime = now + 24 hours;
1377         }
1378 
1379         // Get return variables
1380         totalAmountUnlocked = unlockedTokens[msg.sender].amountUnlocked;
1381         withdrawalTime = unlockedTokens[msg.sender].withdrawalTime;
1382     }
1383 
1384     function withdrawUnlockedTokens() public {
1385         require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
1386         balances[msg.sender] = add(balances[msg.sender], unlockedTokens[msg.sender].amountUnlocked);
1387         unlockedTokens[msg.sender].amountUnlocked = 0;
1388     }
1389 
1390     function min(uint a, uint b) public pure returns (uint) {
1391         if (a < b) {
1392             return a;
1393         } else {
1394             return b;
1395         }
1396     }
1397     
1398     /// @dev Returns whether an add operation causes an overflow
1399     /// @param a First addend
1400     /// @param b Second addend
1401     /// @return Did no overflow occur?
1402     function safeToAdd(uint a, uint b) public pure returns (bool) {
1403         return a + b >= a;
1404     }
1405 
1406     /// @dev Returns whether a subtraction operation causes an underflow
1407     /// @param a Minuend
1408     /// @param b Subtrahend
1409     /// @return Did no underflow occur?
1410     function safeToSub(uint a, uint b) public pure returns (bool) {
1411         return a >= b;
1412     }
1413 
1414     /// @dev Returns sum if no overflow occurred
1415     /// @param a First addend
1416     /// @param b Second addend
1417     /// @return Sum
1418     function add(uint a, uint b) public pure returns (uint) {
1419         require(safeToAdd(a, b), "It must be a safe adition");
1420         return a + b;
1421     }
1422 
1423     /// @dev Returns difference if no overflow occurred
1424     /// @param a Minuend
1425     /// @param b Subtrahend
1426     /// @return Difference
1427     function sub(uint a, uint b) public pure returns (uint) {
1428         require(safeToSub(a, b), "It must be a safe substraction");
1429         return a - b;
1430     }
1431 }
1432 
1433 // File: openzeppelin-solidity/contracts/utils/Address.sol
1434 
1435 pragma solidity ^0.5.2;
1436 
1437 /**
1438  * Utility library of inline functions on addresses
1439  */
1440 library Address {
1441     /**
1442      * Returns whether the target address is a contract
1443      * @dev This function will return false if invoked during the constructor of a contract,
1444      * as the code is not actually created until after the constructor finishes.
1445      * @param account address of the account to check
1446      * @return whether the target address is a contract
1447      */
1448     function isContract(address account) internal view returns (bool) {
1449         uint256 size;
1450         // XXX Currently there is no better way to check if there is a contract in an address
1451         // than to check the size of the code at that address.
1452         // See https://ethereum.stackexchange.com/a/14016/36603
1453         // for more details about how this works.
1454         // TODO Check this again before the Serenity release, because all addresses will be
1455         // contracts then.
1456         // solhint-disable-next-line no-inline-assembly
1457         assembly { size := extcodesize(account) }
1458         return size > 0;
1459     }
1460 }
1461 
1462 // File: @daostack/arc/contracts/libs/SafeERC20.sol
1463 
1464 /*
1465 
1466 SafeERC20 by daostack.
1467 The code is based on a fix by SECBIT Team.
1468 
1469 USE WITH CAUTION & NO WARRANTY
1470 
1471 REFERENCE & RELATED READING
1472 - https://github.com/ethereum/solidity/issues/4116
1473 - https://medium.com/@chris_77367/explaining-unexpected-reverts-starting-with-solidity-0-4-22-3ada6e82308c
1474 - https://medium.com/coinmonks/missing-return-value-bug-at-least-130-tokens-affected-d67bf08521ca
1475 - https://gist.github.com/BrendanChou/88a2eeb80947ff00bcf58ffdafeaeb61
1476 
1477 */
1478 pragma solidity ^0.5.2;
1479 
1480 
1481 
1482 library SafeERC20 {
1483     using Address for address;
1484 
1485     bytes4 constant private TRANSFER_SELECTOR = bytes4(keccak256(bytes("transfer(address,uint256)")));
1486     bytes4 constant private TRANSFERFROM_SELECTOR = bytes4(keccak256(bytes("transferFrom(address,address,uint256)")));
1487     bytes4 constant private APPROVE_SELECTOR = bytes4(keccak256(bytes("approve(address,uint256)")));
1488 
1489     function safeTransfer(address _erc20Addr, address _to, uint256 _value) internal {
1490 
1491         // Must be a contract addr first!
1492         require(_erc20Addr.isContract());
1493 
1494         (bool success, bytes memory returnValue) =
1495         // solhint-disable-next-line avoid-low-level-calls
1496         _erc20Addr.call(abi.encodeWithSelector(TRANSFER_SELECTOR, _to, _value));
1497         // call return false when something wrong
1498         require(success);
1499         //check return value
1500         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1501     }
1502 
1503     function safeTransferFrom(address _erc20Addr, address _from, address _to, uint256 _value) internal {
1504 
1505         // Must be a contract addr first!
1506         require(_erc20Addr.isContract());
1507 
1508         (bool success, bytes memory returnValue) =
1509         // solhint-disable-next-line avoid-low-level-calls
1510         _erc20Addr.call(abi.encodeWithSelector(TRANSFERFROM_SELECTOR, _from, _to, _value));
1511         // call return false when something wrong
1512         require(success);
1513         //check return value
1514         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1515     }
1516 
1517     function safeApprove(address _erc20Addr, address _spender, uint256 _value) internal {
1518 
1519         // Must be a contract addr first!
1520         require(_erc20Addr.isContract());
1521 
1522         // safeApprove should only be called when setting an initial allowance,
1523         // or when resetting it to zero.
1524         require((_value == 0) || (IERC20(_erc20Addr).allowance(msg.sender, _spender) == 0));
1525 
1526         (bool success, bytes memory returnValue) =
1527         // solhint-disable-next-line avoid-low-level-calls
1528         _erc20Addr.call(abi.encodeWithSelector(APPROVE_SELECTOR, _spender, _value));
1529         // call return false when something wrong
1530         require(success);
1531         //check return value
1532         require(returnValue.length == 0 || (returnValue.length == 32 && (returnValue[31] != 0)));
1533     }
1534 }
1535 
1536 // File: contracts/DxMgnPool.sol
1537 
1538 pragma solidity ^0.5.0;
1539 
1540 
1541 
1542 
1543 
1544 
1545 
1546 
1547 contract DxMgnPool is Ownable {
1548     using SafeMath for uint;
1549 
1550     uint constant OWL_ALLOWANCE = 10**36; 
1551     struct Participation {
1552         uint startAuctionCount; // how many auction passed when this participation started contributing
1553         uint poolShares; // number of shares this participation accounts for (absolute)
1554     }
1555     mapping (address => bool) public hasParticpationWithdrawn;
1556     enum State {
1557         Pooling,
1558         PoolingEnded,
1559         DepositWithdrawnFromDx,
1560         MgnUnlocked
1561     }
1562     State public currentState = State.Pooling;
1563 
1564     mapping (address => Participation[]) public participationsByAddress;
1565     uint public totalPoolShares; // total number of shares in this pool
1566     uint public totalPoolSharesCummulative; // over all auctions, the rolling sum of all shares participated
1567     uint public totalDeposit;
1568     uint public totalMgn;
1569     uint public lastParticipatedAuctionIndex;
1570     uint public auctionCount;
1571     
1572     ERC20 public depositToken;
1573     ERC20 public secondaryToken;
1574     TokenFRT public mgnToken;
1575     IDutchExchange public dx;
1576 
1577     uint public poolingPeriodEndTime;
1578 
1579     constructor (
1580         ERC20 _depositToken, 
1581         ERC20 _secondaryToken, 
1582         IDutchExchange _dx,
1583         uint _poolingTimeSeconds
1584     ) public Ownable()
1585     {
1586         depositToken = _depositToken;
1587         secondaryToken = _secondaryToken;
1588         dx = _dx;
1589         mgnToken = TokenFRT(dx.frtToken());
1590         ERC20(dx.owlToken()).approve(address(dx), OWL_ALLOWANCE);
1591         poolingPeriodEndTime = now + _poolingTimeSeconds;
1592     }
1593 
1594     /**
1595      * Public interface
1596      */
1597     function deposit(uint amount) public {
1598         checkForStateUpdate();
1599         require(currentState == State.Pooling, "Pooling is already over");
1600 
1601         uint poolShares = calculatePoolShares(amount);
1602         Participation memory participation = Participation({
1603             startAuctionCount: isDepositTokenTurn() ? auctionCount : auctionCount + 1,
1604             poolShares: poolShares
1605             });
1606         participationsByAddress[msg.sender].push(participation);
1607         totalPoolShares += poolShares;
1608         totalDeposit += amount;
1609 
1610         SafeERC20.safeTransferFrom(address(depositToken), msg.sender, address(this), amount);
1611     }
1612 
1613     function withdrawDeposit() public returns(uint) {
1614         require(currentState == State.DepositWithdrawnFromDx || currentState == State.MgnUnlocked, "Funds not yet withdrawn from dx");
1615         require(!hasParticpationWithdrawn[msg.sender],"sender has already withdrawn funds");
1616 
1617         uint totalDepositAmount = 0;
1618         Participation[] storage participations = participationsByAddress[msg.sender];
1619         uint length = participations.length;
1620         for (uint i = 0; i < length; i++) {
1621             totalDepositAmount += calculateClaimableDeposit(participations[i]);
1622         }
1623         hasParticpationWithdrawn[msg.sender] = true;
1624         SafeERC20.safeTransfer(address(depositToken), msg.sender, totalDepositAmount);
1625         return totalDepositAmount;
1626     }
1627 
1628     function withdrawMagnolia() public returns(uint) {
1629         require(currentState == State.MgnUnlocked, "MGN has not been unlocked, yet");
1630         require(hasParticpationWithdrawn[msg.sender], "Withdraw deposits first");
1631         
1632         uint totalMgnClaimed = 0;
1633         Participation[] memory participations = participationsByAddress[msg.sender];
1634         for (uint i = 0; i < participations.length; i++) {
1635             totalMgnClaimed += calculateClaimableMgn(participations[i]);
1636         }
1637         delete participationsByAddress[msg.sender];
1638         delete hasParticpationWithdrawn[msg.sender];
1639         SafeERC20.safeTransfer(address(mgnToken), msg.sender, totalMgnClaimed);
1640         return totalMgnClaimed;
1641     }
1642 
1643     function withdrawDepositandMagnolia() public returns(uint, uint){ 
1644         return (withdrawDeposit(),withdrawMagnolia());
1645     }
1646 
1647     function participateInAuction() public  onlyOwner() {
1648         checkForStateUpdate();
1649         require(currentState == State.Pooling, "Pooling period is over.");
1650 
1651         uint auctionIndex = dx.getAuctionIndex(address(depositToken), address(secondaryToken));
1652         require(auctionIndex > lastParticipatedAuctionIndex, "Has to wait for new auction to start");
1653 
1654         (address sellToken, address buyToken) = sellAndBuyToken();
1655         uint depositAmount = depositToken.balanceOf(address(this));
1656         if (isDepositTokenTurn()) {
1657             totalPoolSharesCummulative += 2 * totalPoolShares;
1658             if( depositAmount > 0){
1659                 //depositing new tokens
1660                 depositToken.approve(address(dx), depositAmount);
1661                 dx.deposit(address(depositToken), depositAmount);
1662             }
1663         }
1664         // Don't revert if we can't claimSellerFunds
1665         address(dx).call(abi.encodeWithSignature("claimSellerFunds(address,address,address,uint256)", buyToken, sellToken, address(this), lastParticipatedAuctionIndex));
1666 
1667         uint amount = dx.balances(address(sellToken), address(this));
1668         if (isDepositTokenTurn()) {
1669             totalDeposit = amount;
1670         }
1671 
1672         (lastParticipatedAuctionIndex, ) = dx.postSellOrder(sellToken, buyToken, 0, amount);
1673         auctionCount += 1;
1674     }
1675 
1676     function triggerMGNunlockAndClaimTokens() public {
1677         checkForStateUpdate();
1678         require(currentState == State.PoolingEnded, "Pooling period is not yet over.");
1679         require(
1680             dx.getAuctionIndex(address(depositToken), address(secondaryToken)) > lastParticipatedAuctionIndex, 
1681             "Last auction is still running"
1682         );      
1683         
1684         // Don't revert if wen can't claimSellerFunds
1685         address(dx).call(abi.encodeWithSignature("claimSellerFunds(address,address,address,uint256)", secondaryToken, depositToken, address(this), lastParticipatedAuctionIndex));
1686         mgnToken.unlockTokens();
1687 
1688         uint amountOfFundsInDX = dx.balances(address(depositToken), address(this));
1689         totalDeposit = amountOfFundsInDX + depositToken.balanceOf(address(this));
1690         if(amountOfFundsInDX > 0){
1691             dx.withdraw(address(depositToken), amountOfFundsInDX);
1692         }
1693         currentState = State.DepositWithdrawnFromDx;
1694     }
1695 
1696     function withdrawUnlockedMagnoliaFromDx() public {
1697         require(currentState == State.DepositWithdrawnFromDx, "Unlocking not yet triggered");
1698 
1699         // Implicitly we also have:
1700         // require(unlockedTokens[msg.sender].withdrawalTime < now, "The tokens cannot be withdrawn yet");
1701 
1702         mgnToken.withdrawUnlockedTokens();
1703         totalMgn = mgnToken.balanceOf(address(this));
1704 
1705         currentState = State.MgnUnlocked;
1706     }
1707 
1708     function checkForStateUpdate() public {
1709         if (now >= poolingPeriodEndTime && isDepositTokenTurn() && currentState == State.Pooling) {
1710             currentState = State.PoolingEnded;
1711         }
1712     }
1713 
1714     /// @dev updates state and returns val
1715     function updateAndGetCurrentState() public returns(State) {
1716         checkForStateUpdate();
1717 
1718         return currentState;
1719     }
1720 
1721     /**
1722      * Public View Functions
1723      */
1724      
1725     function numberOfParticipations(address addr) public view returns (uint) {
1726         return participationsByAddress[addr].length;
1727     }
1728 
1729     function participationAtIndex(address addr, uint index) public view returns (uint, uint) {
1730         Participation memory participation = participationsByAddress[addr][index];
1731         return (participation.startAuctionCount, participation.poolShares);
1732     }
1733 
1734     function poolSharesByAddress(address userAddress) external view returns(uint[] memory) {
1735         uint length = participationsByAddress[userAddress].length;        
1736         uint[] memory userTotalPoolShares = new uint[](length);
1737         
1738         for (uint i = 0; i < length; i++) {
1739             userTotalPoolShares[i] = participationsByAddress[userAddress][i].poolShares;
1740         }
1741 
1742         return userTotalPoolShares;
1743     }
1744 
1745     function sellAndBuyToken() public view returns(address sellToken, address buyToken) {
1746         if (isDepositTokenTurn()) {
1747             return (address(depositToken), address(secondaryToken));
1748         } else {
1749             return (address(secondaryToken), address(depositToken)); 
1750         }
1751     }
1752 
1753     function getAllClaimableMgnAndDeposits(address userAddress) external view returns(uint[] memory, uint[] memory) {
1754         uint length = participationsByAddress[userAddress].length;
1755 
1756         uint[] memory allUserClaimableMgn = new uint[](length);
1757         uint[] memory allUserClaimableDeposit = new uint[](length);
1758 
1759         for (uint i = 0; i < length; i++) {
1760             allUserClaimableMgn[i] = calculateClaimableMgn(participationsByAddress[userAddress][i]);
1761             allUserClaimableDeposit[i] = calculateClaimableDeposit(participationsByAddress[userAddress][i]);
1762         }
1763         return (allUserClaimableMgn, allUserClaimableDeposit);
1764     }
1765 
1766     /**
1767      * Internal Helpers
1768      */
1769     
1770     function calculatePoolShares(uint amount) private view returns (uint) {
1771         if (totalDeposit == 0) {
1772             return amount;
1773         } else {
1774             return totalPoolShares.mul(amount) / totalDeposit;
1775         }
1776     }
1777     
1778     function isDepositTokenTurn() private view returns (bool) {
1779         return auctionCount % 2 == 0;
1780     }
1781 
1782     function calculateClaimableMgn(Participation memory participation) private view returns (uint) {
1783         if (totalPoolSharesCummulative == 0) {
1784             return 0;
1785         }
1786         uint duration = auctionCount - participation.startAuctionCount;
1787         return totalMgn.mul(participation.poolShares).mul(duration) / totalPoolSharesCummulative;
1788     }
1789 
1790     function calculateClaimableDeposit(Participation memory participation) private view returns (uint) {
1791         if (totalPoolShares == 0) {
1792             return 0;
1793         }
1794         return totalDeposit.mul(participation.poolShares) / totalPoolShares;
1795     }
1796 }