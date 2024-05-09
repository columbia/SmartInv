1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19 	/**
20 	 * @dev Returns the addition of two unsigned integers, reverting on
21 	 * overflow.
22 	 *
23 	 * Counterpart to Solidity's `+` operator.
24 	 *
25 	 * Requirements:
26 	 * - Addition cannot overflow.
27 	 */
28 	function add(uint256 a, uint256 b) internal pure returns (uint256) {
29 		uint256 c = a + b;
30 		require(c >= a, "SafeMath: addition overflow");
31 
32 		return c;
33 	}
34 
35 	/**
36 	 * @dev Returns the subtraction of two unsigned integers, reverting on
37 	 * overflow (when the result is negative).
38 	 *
39 	 * Counterpart to Solidity's `-` operator.
40 	 *
41 	 * Requirements:
42 	 * - Subtraction cannot overflow.
43 	 */
44 	function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45 		return sub(a, b, "SafeMath: subtraction overflow");
46 	}
47 
48 	/**
49 	 * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50 	 * overflow (when the result is negative).
51 	 *
52 	 * Counterpart to Solidity's `-` operator.
53 	 *
54 	 * Requirements:
55 	 * - Subtraction cannot overflow.
56 	 *
57 	 * _Available since v2.4.0._
58 	 */
59 	function sub(
60 		uint256 a,
61 		uint256 b,
62 		string memory errorMessage
63 	) internal pure returns (uint256) {
64 		require(b <= a, errorMessage);
65 		uint256 c = a - b;
66 
67 		return c;
68 	}
69 
70 	/**
71 	 * @dev Returns the multiplication of two unsigned integers, reverting on
72 	 * overflow.
73 	 *
74 	 * Counterpart to Solidity's `*` operator.
75 	 *
76 	 * Requirements:
77 	 * - Multiplication cannot overflow.
78 	 */
79 	function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80 		// Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81 		// benefit is lost if 'b' is also tested.
82 		// See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83 		if (a == 0) {
84 			return 0;
85 		}
86 
87 		uint256 c = a * b;
88 		require(c / a == b, "SafeMath: multiplication overflow");
89 
90 		return c;
91 	}
92 
93 	/**
94 	 * @dev Returns the integer division of two unsigned integers. Reverts on
95 	 * division by zero. The result is rounded towards zero.
96 	 *
97 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
98 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
99 	 * uses an invalid opcode to revert (consuming all remaining gas).
100 	 *
101 	 * Requirements:
102 	 * - The divisor cannot be zero.
103 	 */
104 	function div(uint256 a, uint256 b) internal pure returns (uint256) {
105 		return div(a, b, "SafeMath: division by zero");
106 	}
107 
108 	/**
109 	 * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110 	 * division by zero. The result is rounded towards zero.
111 	 *
112 	 * Counterpart to Solidity's `/` operator. Note: this function uses a
113 	 * `revert` opcode (which leaves remaining gas untouched) while Solidity
114 	 * uses an invalid opcode to revert (consuming all remaining gas).
115 	 *
116 	 * Requirements:
117 	 * - The divisor cannot be zero.
118 	 *
119 	 * _Available since v2.4.0._
120 	 */
121 	function div(
122 		uint256 a,
123 		uint256 b,
124 		string memory errorMessage
125 	) internal pure returns (uint256) {
126 		// Solidity only automatically asserts when dividing by 0
127 		require(b > 0, errorMessage);
128 		uint256 c = a / b;
129 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
130 
131 		return c;
132 	}
133 
134 	/**
135 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136 	 * Reverts when dividing by zero.
137 	 *
138 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
139 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
140 	 * invalid opcode to revert (consuming all remaining gas).
141 	 *
142 	 * Requirements:
143 	 * - The divisor cannot be zero.
144 	 */
145 	function mod(uint256 a, uint256 b) internal pure returns (uint256) {
146 		return mod(a, b, "SafeMath: modulo by zero");
147 	}
148 
149 	/**
150 	 * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
151 	 * Reverts with custom message when dividing by zero.
152 	 *
153 	 * Counterpart to Solidity's `%` operator. This function uses a `revert`
154 	 * opcode (which leaves remaining gas untouched) while Solidity uses an
155 	 * invalid opcode to revert (consuming all remaining gas).
156 	 *
157 	 * Requirements:
158 	 * - The divisor cannot be zero.
159 	 *
160 	 * _Available since v2.4.0._
161 	 */
162 	function mod(
163 		uint256 a,
164 		uint256 b,
165 		string memory errorMessage
166 	) internal pure returns (uint256) {
167 		require(b != 0, errorMessage);
168 		return a % b;
169 	}
170 }
171 
172 // File: contracts/src/common/lifecycle/Killable.sol
173 
174 pragma solidity ^0.5.0;
175 
176 /**
177  * A module that allows contracts to self-destruct.
178  */
179 contract Killable {
180 	address payable public _owner;
181 
182 	/**
183 	 * Initialized with the deployer as the owner.
184 	 */
185 	constructor() internal {
186 		_owner = msg.sender;
187 	}
188 
189 	/**
190 	 * Self-destruct the contract.
191 	 * This function can only be executed by the owner.
192 	 */
193 	function kill() public {
194 		require(msg.sender == _owner, "only owner method");
195 		selfdestruct(_owner);
196 	}
197 }
198 
199 // File: @openzeppelin/contracts/GSN/Context.sol
200 
201 pragma solidity ^0.5.0;
202 
203 /*
204  * @dev Provides information about the current execution context, including the
205  * sender of the transaction and its data. While these are generally available
206  * via msg.sender and msg.data, they should not be accessed in such a direct
207  * manner, since when dealing with GSN meta-transactions the account sending and
208  * paying for execution may not be the actual sender (as far as an application
209  * is concerned).
210  *
211  * This contract is only required for intermediate, library-like contracts.
212  */
213 contract Context {
214 	// Empty internal constructor, to prevent people from mistakenly deploying
215 	// an instance of this contract, which should be used via inheritance.
216 	constructor() internal {}
217 
218 	// solhint-disable-previous-line no-empty-blocks
219 
220 	function _msgSender() internal view returns (address payable) {
221 		return msg.sender;
222 	}
223 
224 	function _msgData() internal view returns (bytes memory) {
225 		this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
226 		return msg.data;
227 	}
228 }
229 
230 // File: @openzeppelin/contracts/ownership/Ownable.sol
231 
232 pragma solidity ^0.5.0;
233 
234 /**
235  * @dev Contract module which provides a basic access control mechanism, where
236  * there is an account (an owner) that can be granted exclusive access to
237  * specific functions.
238  *
239  * This module is used through inheritance. It will make available the modifier
240  * `onlyOwner`, which can be applied to your functions to restrict their use to
241  * the owner.
242  */
243 contract Ownable is Context {
244 	address private _owner;
245 
246 	event OwnershipTransferred(
247 		address indexed previousOwner,
248 		address indexed newOwner
249 	);
250 
251 	/**
252 	 * @dev Initializes the contract setting the deployer as the initial owner.
253 	 */
254 	constructor() internal {
255 		address msgSender = _msgSender();
256 		_owner = msgSender;
257 		emit OwnershipTransferred(address(0), msgSender);
258 	}
259 
260 	/**
261 	 * @dev Returns the address of the current owner.
262 	 */
263 	function owner() public view returns (address) {
264 		return _owner;
265 	}
266 
267 	/**
268 	 * @dev Throws if called by any account other than the owner.
269 	 */
270 	modifier onlyOwner() {
271 		require(isOwner(), "Ownable: caller is not the owner");
272 		_;
273 	}
274 
275 	/**
276 	 * @dev Returns true if the caller is the current owner.
277 	 */
278 	function isOwner() public view returns (bool) {
279 		return _msgSender() == _owner;
280 	}
281 
282 	/**
283 	 * @dev Leaves the contract without owner. It will not be possible to call
284 	 * `onlyOwner` functions anymore. Can only be called by the current owner.
285 	 *
286 	 * NOTE: Renouncing ownership will leave the contract without an owner,
287 	 * thereby removing any functionality that is only available to the owner.
288 	 */
289 	function renounceOwnership() public onlyOwner {
290 		emit OwnershipTransferred(_owner, address(0));
291 		_owner = address(0);
292 	}
293 
294 	/**
295 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
296 	 * Can only be called by the current owner.
297 	 */
298 	function transferOwnership(address newOwner) public onlyOwner {
299 		_transferOwnership(newOwner);
300 	}
301 
302 	/**
303 	 * @dev Transfers ownership of the contract to a new account (`newOwner`).
304 	 */
305 	function _transferOwnership(address newOwner) internal {
306 		require(
307 			newOwner != address(0),
308 			"Ownable: new owner is the zero address"
309 		);
310 		emit OwnershipTransferred(_owner, newOwner);
311 		_owner = newOwner;
312 	}
313 }
314 
315 // File: contracts/src/common/interface/IGroup.sol
316 
317 pragma solidity ^0.5.0;
318 
319 contract IGroup {
320 	function isGroup(address _addr) public view returns (bool);
321 
322 	function addGroup(address _addr) external;
323 
324 	function getGroupKey(address _addr) internal pure returns (bytes32) {
325 		return keccak256(abi.encodePacked("_group", _addr));
326 	}
327 }
328 
329 // File: contracts/src/common/validate/AddressValidator.sol
330 
331 pragma solidity ^0.5.0;
332 
333 /**
334  * A module that provides common validations patterns.
335  */
336 contract AddressValidator {
337 	string constant errorMessage = "this is illegal address";
338 
339 	/**
340 	 * Validates passed address is not a zero address.
341 	 */
342 	function validateIllegalAddress(address _addr) external pure {
343 		require(_addr != address(0), errorMessage);
344 	}
345 
346 	/**
347 	 * Validates passed address is included in an address set.
348 	 */
349 	function validateGroup(address _addr, address _groupAddr) external view {
350 		require(IGroup(_groupAddr).isGroup(_addr), errorMessage);
351 	}
352 
353 	/**
354 	 * Validates passed address is included in two address sets.
355 	 */
356 	function validateGroups(
357 		address _addr,
358 		address _groupAddr1,
359 		address _groupAddr2
360 	) external view {
361 		if (IGroup(_groupAddr1).isGroup(_addr)) {
362 			return;
363 		}
364 		require(IGroup(_groupAddr2).isGroup(_addr), errorMessage);
365 	}
366 
367 	/**
368 	 * Validates that the address of the first argument is equal to the address of the second argument.
369 	 */
370 	function validateAddress(address _addr, address _target) external pure {
371 		require(_addr == _target, errorMessage);
372 	}
373 
374 	/**
375 	 * Validates passed address equals to the two addresses.
376 	 */
377 	function validateAddresses(
378 		address _addr,
379 		address _target1,
380 		address _target2
381 	) external pure {
382 		if (_addr == _target1) {
383 			return;
384 		}
385 		require(_addr == _target2, errorMessage);
386 	}
387 
388 	/**
389 	 * Validates passed address equals to the three addresses.
390 	 */
391 	function validate3Addresses(
392 		address _addr,
393 		address _target1,
394 		address _target2,
395 		address _target3
396 	) external pure {
397 		if (_addr == _target1) {
398 			return;
399 		}
400 		if (_addr == _target2) {
401 			return;
402 		}
403 		require(_addr == _target3, errorMessage);
404 	}
405 }
406 
407 // File: contracts/src/common/validate/UsingValidator.sol
408 
409 pragma solidity ^0.5.0;
410 
411 // prettier-ignore
412 
413 /**
414  * Module for contrast handling AddressValidator.
415  */
416 contract UsingValidator {
417 	AddressValidator private _validator;
418 
419 	/**
420 	 * Create a new AddressValidator contract when initialize.
421 	 */
422 	constructor() public {
423 		_validator = new AddressValidator();
424 	}
425 
426 	/**
427 	 * Returns the set AddressValidator address.
428 	 */
429 	function addressValidator() internal view returns (AddressValidator) {
430 		return _validator;
431 	}
432 }
433 
434 // File: contracts/src/common/config/AddressConfig.sol
435 
436 pragma solidity ^0.5.0;
437 
438 /**
439  * A registry contract to hold the latest contract addresses.
440  * Dev Protocol will be upgradeable by this contract.
441  */
442 contract AddressConfig is Ownable, UsingValidator, Killable {
443 	address public token = 0x98626E2C9231f03504273d55f397409deFD4a093;
444 	address public allocator;
445 	address public allocatorStorage;
446 	address public withdraw;
447 	address public withdrawStorage;
448 	address public marketFactory;
449 	address public marketGroup;
450 	address public propertyFactory;
451 	address public propertyGroup;
452 	address public metricsGroup;
453 	address public metricsFactory;
454 	address public policy;
455 	address public policyFactory;
456 	address public policySet;
457 	address public policyGroup;
458 	address public lockup;
459 	address public lockupStorage;
460 	address public voteTimes;
461 	address public voteTimesStorage;
462 	address public voteCounter;
463 	address public voteCounterStorage;
464 
465 	/**
466 	 * Set the latest Allocator contract address.
467 	 * Only the owner can execute this function.
468 	 */
469 	function setAllocator(address _addr) external onlyOwner {
470 		allocator = _addr;
471 	}
472 
473 	/**
474 	 * Set the latest AllocatorStorage contract address.
475 	 * Only the owner can execute this function.
476 	 * NOTE: But currently, the AllocatorStorage contract is not used.
477 	 */
478 	function setAllocatorStorage(address _addr) external onlyOwner {
479 		allocatorStorage = _addr;
480 	}
481 
482 	/**
483 	 * Set the latest Withdraw contract address.
484 	 * Only the owner can execute this function.
485 	 */
486 	function setWithdraw(address _addr) external onlyOwner {
487 		withdraw = _addr;
488 	}
489 
490 	/**
491 	 * Set the latest WithdrawStorage contract address.
492 	 * Only the owner can execute this function.
493 	 */
494 	function setWithdrawStorage(address _addr) external onlyOwner {
495 		withdrawStorage = _addr;
496 	}
497 
498 	/**
499 	 * Set the latest MarketFactory contract address.
500 	 * Only the owner can execute this function.
501 	 */
502 	function setMarketFactory(address _addr) external onlyOwner {
503 		marketFactory = _addr;
504 	}
505 
506 	/**
507 	 * Set the latest MarketGroup contract address.
508 	 * Only the owner can execute this function.
509 	 */
510 	function setMarketGroup(address _addr) external onlyOwner {
511 		marketGroup = _addr;
512 	}
513 
514 	/**
515 	 * Set the latest PropertyFactory contract address.
516 	 * Only the owner can execute this function.
517 	 */
518 	function setPropertyFactory(address _addr) external onlyOwner {
519 		propertyFactory = _addr;
520 	}
521 
522 	/**
523 	 * Set the latest PropertyGroup contract address.
524 	 * Only the owner can execute this function.
525 	 */
526 	function setPropertyGroup(address _addr) external onlyOwner {
527 		propertyGroup = _addr;
528 	}
529 
530 	/**
531 	 * Set the latest MetricsFactory contract address.
532 	 * Only the owner can execute this function.
533 	 */
534 	function setMetricsFactory(address _addr) external onlyOwner {
535 		metricsFactory = _addr;
536 	}
537 
538 	/**
539 	 * Set the latest MetricsGroup contract address.
540 	 * Only the owner can execute this function.
541 	 */
542 	function setMetricsGroup(address _addr) external onlyOwner {
543 		metricsGroup = _addr;
544 	}
545 
546 	/**
547 	 * Set the latest PolicyFactory contract address.
548 	 * Only the owner can execute this function.
549 	 */
550 	function setPolicyFactory(address _addr) external onlyOwner {
551 		policyFactory = _addr;
552 	}
553 
554 	/**
555 	 * Set the latest PolicyGroup contract address.
556 	 * Only the owner can execute this function.
557 	 */
558 	function setPolicyGroup(address _addr) external onlyOwner {
559 		policyGroup = _addr;
560 	}
561 
562 	/**
563 	 * Set the latest PolicySet contract address.
564 	 * Only the owner can execute this function.
565 	 */
566 	function setPolicySet(address _addr) external onlyOwner {
567 		policySet = _addr;
568 	}
569 
570 	/**
571 	 * Set the latest Policy contract address.
572 	 * Only the latest PolicyFactory contract can execute this function.
573 	 */
574 	function setPolicy(address _addr) external {
575 		addressValidator().validateAddress(msg.sender, policyFactory);
576 		policy = _addr;
577 	}
578 
579 	/**
580 	 * Set the latest Dev contract address.
581 	 * Only the owner can execute this function.
582 	 */
583 	function setToken(address _addr) external onlyOwner {
584 		token = _addr;
585 	}
586 
587 	/**
588 	 * Set the latest Lockup contract address.
589 	 * Only the owner can execute this function.
590 	 */
591 	function setLockup(address _addr) external onlyOwner {
592 		lockup = _addr;
593 	}
594 
595 	/**
596 	 * Set the latest LockupStorage contract address.
597 	 * Only the owner can execute this function.
598 	 * NOTE: But currently, the LockupStorage contract is not used as a stand-alone because it is inherited from the Lockup contract.
599 	 */
600 	function setLockupStorage(address _addr) external onlyOwner {
601 		lockupStorage = _addr;
602 	}
603 
604 	/**
605 	 * Set the latest VoteTimes contract address.
606 	 * Only the owner can execute this function.
607 	 * NOTE: But currently, the VoteTimes contract is not used.
608 	 */
609 	function setVoteTimes(address _addr) external onlyOwner {
610 		voteTimes = _addr;
611 	}
612 
613 	/**
614 	 * Set the latest VoteTimesStorage contract address.
615 	 * Only the owner can execute this function.
616 	 * NOTE: But currently, the VoteTimesStorage contract is not used.
617 	 */
618 	function setVoteTimesStorage(address _addr) external onlyOwner {
619 		voteTimesStorage = _addr;
620 	}
621 
622 	/**
623 	 * Set the latest VoteCounter contract address.
624 	 * Only the owner can execute this function.
625 	 */
626 	function setVoteCounter(address _addr) external onlyOwner {
627 		voteCounter = _addr;
628 	}
629 
630 	/**
631 	 * Set the latest VoteCounterStorage contract address.
632 	 * Only the owner can execute this function.
633 	 * NOTE: But currently, the VoteCounterStorage contract is not used as a stand-alone because it is inherited from the VoteCounter contract.
634 	 */
635 	function setVoteCounterStorage(address _addr) external onlyOwner {
636 		voteCounterStorage = _addr;
637 	}
638 }
639 
640 // File: contracts/src/common/config/UsingConfig.sol
641 
642 pragma solidity ^0.5.0;
643 
644 /**
645  * Module for using AddressConfig contracts.
646  */
647 contract UsingConfig {
648 	AddressConfig private _config;
649 
650 	/**
651 	 * Initialize the argument as AddressConfig address.
652 	 */
653 	constructor(address _addressConfig) public {
654 		_config = AddressConfig(_addressConfig);
655 	}
656 
657 	/**
658 	 * Returns the latest AddressConfig instance.
659 	 */
660 	function config() internal view returns (AddressConfig) {
661 		return _config;
662 	}
663 
664 	/**
665 	 * Returns the latest AddressConfig address.
666 	 */
667 	function configAddress() external view returns (address) {
668 		return address(_config);
669 	}
670 }
671 
672 // File: contracts/src/common/storage/EternalStorage.sol
673 
674 pragma solidity ^0.5.0;
675 
676 /**
677  * Module for persisting states.
678  * Stores a map for `uint256`, `string`, `address`, `bytes32`, `bool`, and `int256` type with `bytes32` type as a key.
679  */
680 contract EternalStorage {
681 	address private currentOwner = msg.sender;
682 
683 	mapping(bytes32 => uint256) private uIntStorage;
684 	mapping(bytes32 => string) private stringStorage;
685 	mapping(bytes32 => address) private addressStorage;
686 	mapping(bytes32 => bytes32) private bytesStorage;
687 	mapping(bytes32 => bool) private boolStorage;
688 	mapping(bytes32 => int256) private intStorage;
689 
690 	/**
691 	 * Modifiers to validate that only the owner can execute.
692 	 */
693 	modifier onlyCurrentOwner() {
694 		require(msg.sender == currentOwner, "not current owner");
695 		_;
696 	}
697 
698 	/**
699 	 * Transfer the owner.
700 	 * Only the owner can execute this function.
701 	 */
702 	function changeOwner(address _newOwner) external {
703 		require(msg.sender == currentOwner, "not current owner");
704 		currentOwner = _newOwner;
705 	}
706 
707 	// *** Getter Methods ***
708 
709 	/**
710 	 * Returns the value of the `uint256` type that mapped to the given key.
711 	 */
712 	function getUint(bytes32 _key) external view returns (uint256) {
713 		return uIntStorage[_key];
714 	}
715 
716 	/**
717 	 * Returns the value of the `string` type that mapped to the given key.
718 	 */
719 	function getString(bytes32 _key) external view returns (string memory) {
720 		return stringStorage[_key];
721 	}
722 
723 	/**
724 	 * Returns the value of the `address` type that mapped to the given key.
725 	 */
726 	function getAddress(bytes32 _key) external view returns (address) {
727 		return addressStorage[_key];
728 	}
729 
730 	/**
731 	 * Returns the value of the `bytes32` type that mapped to the given key.
732 	 */
733 	function getBytes(bytes32 _key) external view returns (bytes32) {
734 		return bytesStorage[_key];
735 	}
736 
737 	/**
738 	 * Returns the value of the `bool` type that mapped to the given key.
739 	 */
740 	function getBool(bytes32 _key) external view returns (bool) {
741 		return boolStorage[_key];
742 	}
743 
744 	/**
745 	 * Returns the value of the `int256` type that mapped to the given key.
746 	 */
747 	function getInt(bytes32 _key) external view returns (int256) {
748 		return intStorage[_key];
749 	}
750 
751 	// *** Setter Methods ***
752 
753 	/**
754 	 * Maps a value of `uint256` type to a given key.
755 	 * Only the owner can execute this function.
756 	 */
757 	function setUint(bytes32 _key, uint256 _value) external onlyCurrentOwner {
758 		uIntStorage[_key] = _value;
759 	}
760 
761 	/**
762 	 * Maps a value of `string` type to a given key.
763 	 * Only the owner can execute this function.
764 	 */
765 	function setString(bytes32 _key, string calldata _value)
766 		external
767 		onlyCurrentOwner
768 	{
769 		stringStorage[_key] = _value;
770 	}
771 
772 	/**
773 	 * Maps a value of `address` type to a given key.
774 	 * Only the owner can execute this function.
775 	 */
776 	function setAddress(bytes32 _key, address _value)
777 		external
778 		onlyCurrentOwner
779 	{
780 		addressStorage[_key] = _value;
781 	}
782 
783 	/**
784 	 * Maps a value of `bytes32` type to a given key.
785 	 * Only the owner can execute this function.
786 	 */
787 	function setBytes(bytes32 _key, bytes32 _value) external onlyCurrentOwner {
788 		bytesStorage[_key] = _value;
789 	}
790 
791 	/**
792 	 * Maps a value of `bool` type to a given key.
793 	 * Only the owner can execute this function.
794 	 */
795 	function setBool(bytes32 _key, bool _value) external onlyCurrentOwner {
796 		boolStorage[_key] = _value;
797 	}
798 
799 	/**
800 	 * Maps a value of `int256` type to a given key.
801 	 * Only the owner can execute this function.
802 	 */
803 	function setInt(bytes32 _key, int256 _value) external onlyCurrentOwner {
804 		intStorage[_key] = _value;
805 	}
806 
807 	// *** Delete Methods ***
808 
809 	/**
810 	 * Deletes the value of the `uint256` type that mapped to the given key.
811 	 * Only the owner can execute this function.
812 	 */
813 	function deleteUint(bytes32 _key) external onlyCurrentOwner {
814 		delete uIntStorage[_key];
815 	}
816 
817 	/**
818 	 * Deletes the value of the `string` type that mapped to the given key.
819 	 * Only the owner can execute this function.
820 	 */
821 	function deleteString(bytes32 _key) external onlyCurrentOwner {
822 		delete stringStorage[_key];
823 	}
824 
825 	/**
826 	 * Deletes the value of the `address` type that mapped to the given key.
827 	 * Only the owner can execute this function.
828 	 */
829 	function deleteAddress(bytes32 _key) external onlyCurrentOwner {
830 		delete addressStorage[_key];
831 	}
832 
833 	/**
834 	 * Deletes the value of the `bytes32` type that mapped to the given key.
835 	 * Only the owner can execute this function.
836 	 */
837 	function deleteBytes(bytes32 _key) external onlyCurrentOwner {
838 		delete bytesStorage[_key];
839 	}
840 
841 	/**
842 	 * Deletes the value of the `bool` type that mapped to the given key.
843 	 * Only the owner can execute this function.
844 	 */
845 	function deleteBool(bytes32 _key) external onlyCurrentOwner {
846 		delete boolStorage[_key];
847 	}
848 
849 	/**
850 	 * Deletes the value of the `int256` type that mapped to the given key.
851 	 * Only the owner can execute this function.
852 	 */
853 	function deleteInt(bytes32 _key) external onlyCurrentOwner {
854 		delete intStorage[_key];
855 	}
856 }
857 
858 // File: contracts/src/common/storage/UsingStorage.sol
859 
860 pragma solidity ^0.5.0;
861 
862 /**
863  * Module for contrast handling EternalStorage.
864  */
865 contract UsingStorage is Ownable {
866 	address private _storage;
867 
868 	/**
869 	 * Modifier to verify that EternalStorage is set.
870 	 */
871 	modifier hasStorage() {
872 		require(_storage != address(0), "storage is not set");
873 		_;
874 	}
875 
876 	/**
877 	 * Returns the set EternalStorage instance.
878 	 */
879 	function eternalStorage()
880 		internal
881 		view
882 		hasStorage
883 		returns (EternalStorage)
884 	{
885 		return EternalStorage(_storage);
886 	}
887 
888 	/**
889 	 * Returns the set EternalStorage address.
890 	 */
891 	function getStorageAddress() external view hasStorage returns (address) {
892 		return _storage;
893 	}
894 
895 	/**
896 	 * Create a new EternalStorage contract.
897 	 * This function call will fail if the EternalStorage contract is already set.
898 	 * Also, only the owner can execute it.
899 	 */
900 	function createStorage() external onlyOwner {
901 		require(_storage == address(0), "storage is set");
902 		EternalStorage tmp = new EternalStorage();
903 		_storage = address(tmp);
904 	}
905 
906 	/**
907 	 * Assigns the EternalStorage contract that has already been created.
908 	 * Only the owner can execute this function.
909 	 */
910 	function setStorage(address _storageAddress) external onlyOwner {
911 		_storage = _storageAddress;
912 	}
913 
914 	/**
915 	 * Delegates the owner of the current EternalStorage contract.
916 	 * Only the owner can execute this function.
917 	 */
918 	function changeOwner(address newOwner) external onlyOwner {
919 		EternalStorage(_storage).changeOwner(newOwner);
920 	}
921 }
922 
923 // File: contracts/src/metrics/IMetricsGroup.sol
924 
925 pragma solidity ^0.5.0;
926 
927 contract IMetricsGroup is IGroup {
928 	function removeGroup(address _addr) external;
929 
930 	function totalIssuedMetrics() external view returns (uint256);
931 
932 	function getMetricsCountPerProperty(address _property)
933 		public
934 		view
935 		returns (uint256);
936 
937 	function hasAssets(address _property) public view returns (bool);
938 }
939 
940 // File: contracts/src/metrics/IMetrics.sol
941 
942 pragma solidity ^0.5.0;
943 
944 contract IMetrics {
945 	address public market;
946 	address public property;
947 }
948 
949 // File: contracts/src/metrics/MetricsGroup.sol
950 
951 pragma solidity ^0.5.0;
952 
953 contract MetricsGroup is
954 	UsingConfig,
955 	UsingStorage,
956 	UsingValidator,
957 	IMetricsGroup
958 {
959 	using SafeMath for uint256;
960 
961 	// solium-disable-next-line no-empty-blocks
962 	constructor(address _config) public UsingConfig(_config) {}
963 
964 	function addGroup(address _addr) external {
965 		addressValidator().validateAddress(
966 			msg.sender,
967 			config().metricsFactory()
968 		);
969 
970 		require(isGroup(_addr) == false, "already enabled");
971 		eternalStorage().setBool(getGroupKey(_addr), true);
972 		address property = IMetrics(_addr).property();
973 		uint256 totalCount = eternalStorage().getUint(getTotalCountKey());
974 		uint256 metricsCountPerProperty = getMetricsCountPerProperty(property);
975 		totalCount = totalCount.add(1);
976 		metricsCountPerProperty = metricsCountPerProperty.add(1);
977 		setTotalIssuedMetrics(totalCount);
978 		setMetricsCountPerProperty(property, metricsCountPerProperty);
979 	}
980 
981 	function removeGroup(address _addr) external {
982 		addressValidator().validateAddress(
983 			msg.sender,
984 			config().metricsFactory()
985 		);
986 
987 		require(isGroup(_addr), "address is not group");
988 		eternalStorage().setBool(getGroupKey(_addr), false);
989 		address property = IMetrics(_addr).property();
990 		uint256 totalCount = eternalStorage().getUint(getTotalCountKey());
991 		uint256 metricsCountPerProperty = getMetricsCountPerProperty(property);
992 		totalCount = totalCount.sub(1);
993 		metricsCountPerProperty = metricsCountPerProperty.sub(1);
994 		setTotalIssuedMetrics(totalCount);
995 		setMetricsCountPerProperty(property, metricsCountPerProperty);
996 	}
997 
998 	function setMetricsCountPerProperty(address _property, uint256 _value)
999 		internal
1000 	{
1001 		return
1002 			eternalStorage().setUint(
1003 				getMetricsCountPerPropertyKey(_property),
1004 				_value
1005 			);
1006 	}
1007 
1008 	function getMetricsCountPerProperty(address _property)
1009 		public
1010 		view
1011 		returns (uint256)
1012 	{
1013 		return
1014 			eternalStorage().getUint(getMetricsCountPerPropertyKey(_property));
1015 	}
1016 
1017 	function hasAssets(address _property) public view returns (bool) {
1018 		return getMetricsCountPerProperty(_property) > 0;
1019 	}
1020 
1021 	function setTotalIssuedMetrics(uint256 _value) internal {
1022 		eternalStorage().setUint(getTotalCountKey(), _value);
1023 	}
1024 
1025 	function isGroup(address _addr) public view returns (bool) {
1026 		return eternalStorage().getBool(getGroupKey(_addr));
1027 	}
1028 
1029 	function totalIssuedMetrics() external view returns (uint256) {
1030 		return eternalStorage().getUint(getTotalCountKey());
1031 	}
1032 
1033 	function getTotalCountKey() private pure returns (bytes32) {
1034 		return keccak256(abi.encodePacked("_totalCount"));
1035 	}
1036 
1037 	function getMetricsCountPerPropertyKey(address _property)
1038 		private
1039 		pure
1040 		returns (bytes32)
1041 	{
1042 		return
1043 			keccak256(abi.encodePacked("_metricsCountPerProperty", _property));
1044 	}
1045 }
1046 
1047 // File: contracts/src/metrics/MetricsGroupMigration.sol
1048 
1049 pragma solidity ^0.5.0;
1050 
1051 contract MetricsGroupMigration is MetricsGroup {
1052 	// solium-disable-next-line no-empty-blocks
1053 	constructor(address _config) public MetricsGroup(_config) {}
1054 
1055 	function hasAssets(address _property) public view returns (bool) {
1056 		return true;
1057 	}
1058 
1059 	function __setMetricsCountPerProperty(address _property, uint256 _value)
1060 		external
1061 		onlyOwner
1062 	{
1063 		setMetricsCountPerProperty(_property, _value);
1064 	}
1065 }