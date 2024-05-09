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
19     /**
20      * @dev Returns the addition of two unsigned integers, reverting on
21      * overflow.
22      *
23      * Counterpart to Solidity's `+` operator.
24      *
25      * Requirements:
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      * - Subtraction cannot overflow.
43      */
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     /**
49      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
50      * overflow (when the result is negative).
51      *
52      * Counterpart to Solidity's `-` operator.
53      *
54      * Requirements:
55      * - Subtraction cannot overflow.
56      *
57      * _Available since v2.4.0._
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      * - Multiplication cannot overflow.
74      */
75     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
76         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
77         // benefit is lost if 'b' is also tested.
78         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
79         if (a == 0) {
80             return 0;
81         }
82 
83         uint256 c = a * b;
84         require(c / a == b, "SafeMath: multiplication overflow");
85 
86         return c;
87     }
88 
89     /**
90      * @dev Returns the integer division of two unsigned integers. Reverts on
91      * division by zero. The result is rounded towards zero.
92      *
93      * Counterpart to Solidity's `/` operator. Note: this function uses a
94      * `revert` opcode (which leaves remaining gas untouched) while Solidity
95      * uses an invalid opcode to revert (consuming all remaining gas).
96      *
97      * Requirements:
98      * - The divisor cannot be zero.
99      */
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103 
104     /**
105      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
106      * division by zero. The result is rounded towards zero.
107      *
108      * Counterpart to Solidity's `/` operator. Note: this function uses a
109      * `revert` opcode (which leaves remaining gas untouched) while Solidity
110      * uses an invalid opcode to revert (consuming all remaining gas).
111      *
112      * Requirements:
113      * - The divisor cannot be zero.
114      *
115      * _Available since v2.4.0._
116      */
117     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         // Solidity only automatically asserts when dividing by 0
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      * - The divisor cannot be zero.
136      */
137     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
138         return mod(a, b, "SafeMath: modulo by zero");
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * Reverts with custom message when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      * - The divisor cannot be zero.
151      *
152      * _Available since v2.4.0._
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 // File: @openzeppelin/contracts/introspection/IERC165.sol
161 
162 pragma solidity ^0.5.0;
163 
164 /**
165  * @dev Interface of the ERC165 standard, as defined in the
166  * https://eips.ethereum.org/EIPS/eip-165[EIP].
167  *
168  * Implementers can declare support of contract interfaces, which can then be
169  * queried by others ({ERC165Checker}).
170  *
171  * For an implementation, see {ERC165}.
172  */
173 interface IERC165 {
174     /**
175      * @dev Returns true if this contract implements the interface defined by
176      * `interfaceId`. See the corresponding
177      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
178      * to learn more about how these ids are created.
179      *
180      * This function call must use less than 30 000 gas.
181      */
182     function supportsInterface(bytes4 interfaceId) external view returns (bool);
183 }
184 
185 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
186 
187 pragma solidity ^0.5.0;
188 
189 
190 /**
191  * @dev Required interface of an ERC721 compliant contract.
192  */
193 contract IERC721 is IERC165 {
194     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
195     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
196     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
197 
198     /**
199      * @dev Returns the number of NFTs in `owner`'s account.
200      */
201     function balanceOf(address owner) public view returns (uint256 balance);
202 
203     /**
204      * @dev Returns the owner of the NFT specified by `tokenId`.
205      */
206     function ownerOf(uint256 tokenId) public view returns (address owner);
207 
208     /**
209      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
210      * another (`to`).
211      *
212      *
213      *
214      * Requirements:
215      * - `from`, `to` cannot be zero.
216      * - `tokenId` must be owned by `from`.
217      * - If the caller is not `from`, it must be have been allowed to move this
218      * NFT by either {approve} or {setApprovalForAll}.
219      */
220     function safeTransferFrom(address from, address to, uint256 tokenId) public;
221     /**
222      * @dev Transfers a specific NFT (`tokenId`) from one account (`from`) to
223      * another (`to`).
224      *
225      * Requirements:
226      * - If the caller is not `from`, it must be approved to move this NFT by
227      * either {approve} or {setApprovalForAll}.
228      */
229     function transferFrom(address from, address to, uint256 tokenId) public;
230     function approve(address to, uint256 tokenId) public;
231     function getApproved(uint256 tokenId) public view returns (address operator);
232 
233     function setApprovalForAll(address operator, bool _approved) public;
234     function isApprovedForAll(address owner, address operator) public view returns (bool);
235 
236 
237     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
238 }
239 
240 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
241 
242 pragma solidity ^0.5.0;
243 
244 /**
245  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
246  * the optional functions; to access them see {ERC20Detailed}.
247  */
248 interface IERC20 {
249     /**
250      * @dev Returns the amount of tokens in existence.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns the amount of tokens owned by `account`.
256      */
257     function balanceOf(address account) external view returns (uint256);
258 
259     /**
260      * @dev Moves `amount` tokens from the caller's account to `recipient`.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transfer(address recipient, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Returns the remaining number of tokens that `spender` will be
270      * allowed to spend on behalf of `owner` through {transferFrom}. This is
271      * zero by default.
272      *
273      * This value changes when {approve} or {transferFrom} are called.
274      */
275     function allowance(address owner, address spender) external view returns (uint256);
276 
277     /**
278      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * IMPORTANT: Beware that changing an allowance with this method brings the risk
283      * that someone may use both the old and the new allowance by unfortunate
284      * transaction ordering. One possible solution to mitigate this race
285      * condition is to first reduce the spender's allowance to 0 and set the
286      * desired value afterwards:
287      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288      *
289      * Emits an {Approval} event.
290      */
291     function approve(address spender, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Moves `amount` tokens from `sender` to `recipient` using the
295      * allowance mechanism. `amount` is then deducted from the caller's
296      * allowance.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * Emits a {Transfer} event.
301      */
302     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Emitted when `value` tokens are moved from one account (`from`) to
306      * another (`to`).
307      *
308      * Note that `value` may be zero.
309      */
310     event Transfer(address indexed from, address indexed to, uint256 value);
311 
312     /**
313      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
314      * a call to {approve}. `value` is the new allowance.
315      */
316     event Approval(address indexed owner, address indexed spender, uint256 value);
317 }
318 
319 // File: @devprotocol/i-s-tokens/contracts/interface/ISTokensManager.sol
320 
321 // SPDX-License-Identifier: MPL-2.0
322 pragma solidity >=0.5.17;
323 
324 interface ISTokensManager {
325 	/*
326 	 * @dev The event fired when a token is minted.
327 	 * @param tokenId The ID of the created new staking position
328 	 * @param owner The address of the owner of the new staking position
329 	 * @param property The address of the Property as the staking destination
330 	 * @param amount The amount of the new staking position
331 	 * @param price The latest unit price of the cumulative staking reward
332 	 */
333 	event Minted(
334 		uint256 tokenId,
335 		address owner,
336 		address property,
337 		uint256 amount,
338 		uint256 price
339 	);
340 
341 	/*
342 	 * @dev The event fired when a token is updated.
343 	 * @param tokenId The ID of the staking position
344 	 * @param amount The new staking amount
345 	 * @param price The latest unit price of the cumulative staking reward
346 	 * This value equals the 3rd return value of the Lockup.calculateCumulativeRewardPrices
347 	 * @param cumulativeReward The cumulative withdrawn reward amount
348 	 * @param pendingReward The pending withdrawal reward amount amount
349 	 */
350 	event Updated(
351 		uint256 tokenId,
352 		uint256 amount,
353 		uint256 price,
354 		uint256 cumulativeReward,
355 		uint256 pendingReward
356 	);
357 
358 	/*
359 	 * @dev perform the initial setup
360 	 * @param _config AddressConfig
361 	 */
362 	function initialize(address _config) external;
363 
364 	/*
365 	 * @dev Creates the new staking position for the caller.
366 	 * Mint must be called from the Lockup contract.
367 	 * @param _owner The address of the owner of the new staking position
368 	 * @param _property The address of the Property as the staking destination
369 	 * @param _amount The amount of the new staking position
370 	 * @param _price The latest unit price of the cumulative staking reward
371 	 * @return uint256 The ID of the created new staking position
372 	 */
373 	function mint(
374 		address _owner,
375 		address _property,
376 		uint256 _amount,
377 		uint256 _price
378 	) external returns (uint256);
379 
380 	/*
381 	 * @dev Updates the existing staking position.
382 	 * Update must be called from the Lockup contract.
383 	 * @param _tokenId The ID of the staking position
384 	 * @param _amount The new staking amount
385 	 * @param _price The latest unit price of the cumulative staking reward
386 	 * This value equals the 3rd return value of the Lockup.calculateCumulativeRewardPrices
387 	 * @param _cumulativeReward The cumulative withdrawn reward amount
388 	 * @param _pendingReward The pending withdrawal reward amount amount
389 	 * @return bool On success, true will be returned
390 	 */
391 	function update(
392 		uint256 _tokenId,
393 		uint256 _amount,
394 		uint256 _price,
395 		uint256 _cumulativeReward,
396 		uint256 _pendingReward
397 	) external returns (bool);
398 
399 	/*
400 	 * @dev Gets the existing staking position.
401 	 * @param _tokenId The ID of the staking position
402 	 * @return address The address of the Property as the staking destination
403 	 * @return uint256 The amount of the new staking position
404 	 * @return uint256 The latest unit price of the cumulative staking reward
405 	 * @return uint256 The cumulative withdrawn reward amount
406 	 * @return uint256 The pending withdrawal reward amount amount
407 	 */
408 	function positions(uint256 _tokenId)
409 		external
410 		view
411 		returns (
412 			address,
413 			uint256,
414 			uint256,
415 			uint256,
416 			uint256
417 		);
418 
419 	/*
420 	 * @dev Gets the reward status of the staking position.
421 	 * @param _tokenId The ID of the staking position
422 	 * @return uint256 The reward amount of adding the cumulative withdrawn amount
423 	 to the withdrawable amount
424 	 * @return uint256 The cumulative withdrawn reward amount
425 	 * @return uint256 The withdrawable reward amount
426 	 */
427 	function rewards(uint256 _tokenId)
428 		external
429 		view
430 		returns (
431 			uint256,
432 			uint256,
433 			uint256
434 		);
435 
436 	/*
437 	 * @dev get token ids by property
438 	 * @param _property property address
439 	 * @return uint256[] token id list
440 	 */
441 	function positionsOfProperty(address _property)
442 		external
443 		view
444 		returns (uint256[] memory);
445 
446 	/*
447 	 * @dev get token ids by owner
448 	 * @param _owner owner address
449 	 * @return uint256[] token id list
450 	 */
451 	function positionsOfOwner(address _owner)
452 		external
453 		view
454 		returns (uint256[] memory);
455 }
456 
457 // File: contracts/src/common/libs/Decimals.sol
458 
459 pragma solidity 0.5.17;
460 
461 
462 /**
463  * Library for emulating calculations involving decimals.
464  */
465 library Decimals {
466 	using SafeMath for uint256;
467 	uint120 private constant BASIS_VAKUE = 1000000000000000000;
468 
469 	/**
470 	 * @dev Returns the ratio of the first argument to the second argument.
471 	 * @param _a Numerator.
472 	 * @param _b Fraction.
473 	 * @return Calculated ratio.
474 	 */
475 	function outOf(uint256 _a, uint256 _b)
476 		internal
477 		pure
478 		returns (uint256 result)
479 	{
480 		if (_a == 0) {
481 			return 0;
482 		}
483 		uint256 a = _a.mul(BASIS_VAKUE);
484 		if (a < _b) {
485 			return 0;
486 		}
487 		return (a.div(_b));
488 	}
489 
490 	/**
491 	 * @dev Returns multiplied the number by 10^18.
492 	 * @param _a Numerical value to be multiplied.
493 	 * @return Multiplied value.
494 	 */
495 	function mulBasis(uint256 _a) internal pure returns (uint256) {
496 		return _a.mul(BASIS_VAKUE);
497 	}
498 
499 	/**
500 	 * @dev Returns divisioned the number by 10^18.
501 	 * This function can use it to restore the number of digits in the result of `outOf`.
502 	 * @param _a Numerical value to be divisioned.
503 	 * @return Divisioned value.
504 	 */
505 	function divBasis(uint256 _a) internal pure returns (uint256) {
506 		return _a.div(BASIS_VAKUE);
507 	}
508 }
509 
510 // File: contracts/interface/IAddressConfig.sol
511 
512 // SPDX-License-Identifier: MPL-2.0
513 pragma solidity >=0.5.17;
514 
515 interface IAddressConfig {
516 	function token() external view returns (address);
517 
518 	function allocator() external view returns (address);
519 
520 	function allocatorStorage() external view returns (address);
521 
522 	function withdraw() external view returns (address);
523 
524 	function withdrawStorage() external view returns (address);
525 
526 	function marketFactory() external view returns (address);
527 
528 	function marketGroup() external view returns (address);
529 
530 	function propertyFactory() external view returns (address);
531 
532 	function propertyGroup() external view returns (address);
533 
534 	function metricsGroup() external view returns (address);
535 
536 	function metricsFactory() external view returns (address);
537 
538 	function policy() external view returns (address);
539 
540 	function policyFactory() external view returns (address);
541 
542 	function policySet() external view returns (address);
543 
544 	function policyGroup() external view returns (address);
545 
546 	function lockup() external view returns (address);
547 
548 	function lockupStorage() external view returns (address);
549 
550 	function voteTimes() external view returns (address);
551 
552 	function voteTimesStorage() external view returns (address);
553 
554 	function voteCounter() external view returns (address);
555 
556 	function voteCounterStorage() external view returns (address);
557 
558 	function setAllocator(address _addr) external;
559 
560 	function setAllocatorStorage(address _addr) external;
561 
562 	function setWithdraw(address _addr) external;
563 
564 	function setWithdrawStorage(address _addr) external;
565 
566 	function setMarketFactory(address _addr) external;
567 
568 	function setMarketGroup(address _addr) external;
569 
570 	function setPropertyFactory(address _addr) external;
571 
572 	function setPropertyGroup(address _addr) external;
573 
574 	function setMetricsFactory(address _addr) external;
575 
576 	function setMetricsGroup(address _addr) external;
577 
578 	function setPolicyFactory(address _addr) external;
579 
580 	function setPolicyGroup(address _addr) external;
581 
582 	function setPolicySet(address _addr) external;
583 
584 	function setPolicy(address _addr) external;
585 
586 	function setToken(address _addr) external;
587 
588 	function setLockup(address _addr) external;
589 
590 	function setLockupStorage(address _addr) external;
591 
592 	function setVoteTimes(address _addr) external;
593 
594 	function setVoteTimesStorage(address _addr) external;
595 
596 	function setVoteCounter(address _addr) external;
597 
598 	function setVoteCounterStorage(address _addr) external;
599 }
600 
601 // File: contracts/src/common/config/UsingConfig.sol
602 
603 pragma solidity 0.5.17;
604 
605 
606 /**
607  * Module for using AddressConfig contracts.
608  */
609 contract UsingConfig {
610 	address private _config;
611 
612 	/**
613 	 * Initialize the argument as AddressConfig address.
614 	 */
615 	constructor(address _addressConfig) public {
616 		_config = _addressConfig;
617 	}
618 
619 	/**
620 	 * Returns the latest AddressConfig instance.
621 	 */
622 	function config() internal view returns (IAddressConfig) {
623 		return IAddressConfig(_config);
624 	}
625 
626 	/**
627 	 * Returns the latest AddressConfig address.
628 	 */
629 	function configAddress() external view returns (address) {
630 		return _config;
631 	}
632 }
633 
634 // File: contracts/interface/IUsingStorage.sol
635 
636 // SPDX-License-Identifier: MPL-2.0
637 pragma solidity >=0.5.17;
638 
639 interface IUsingStorage {
640 	function getStorageAddress() external view returns (address);
641 
642 	function createStorage() external;
643 
644 	function setStorage(address _storageAddress) external;
645 
646 	function changeOwner(address newOwner) external;
647 }
648 
649 // File: @openzeppelin/contracts/GSN/Context.sol
650 
651 pragma solidity ^0.5.0;
652 
653 /*
654  * @dev Provides information about the current execution context, including the
655  * sender of the transaction and its data. While these are generally available
656  * via msg.sender and msg.data, they should not be accessed in such a direct
657  * manner, since when dealing with GSN meta-transactions the account sending and
658  * paying for execution may not be the actual sender (as far as an application
659  * is concerned).
660  *
661  * This contract is only required for intermediate, library-like contracts.
662  */
663 contract Context {
664     // Empty internal constructor, to prevent people from mistakenly deploying
665     // an instance of this contract, which should be used via inheritance.
666     constructor () internal { }
667     // solhint-disable-previous-line no-empty-blocks
668 
669     function _msgSender() internal view returns (address payable) {
670         return msg.sender;
671     }
672 
673     function _msgData() internal view returns (bytes memory) {
674         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
675         return msg.data;
676     }
677 }
678 
679 // File: @openzeppelin/contracts/ownership/Ownable.sol
680 
681 pragma solidity ^0.5.0;
682 
683 /**
684  * @dev Contract module which provides a basic access control mechanism, where
685  * there is an account (an owner) that can be granted exclusive access to
686  * specific functions.
687  *
688  * This module is used through inheritance. It will make available the modifier
689  * `onlyOwner`, which can be applied to your functions to restrict their use to
690  * the owner.
691  */
692 contract Ownable is Context {
693     address private _owner;
694 
695     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
696 
697     /**
698      * @dev Initializes the contract setting the deployer as the initial owner.
699      */
700     constructor () internal {
701         address msgSender = _msgSender();
702         _owner = msgSender;
703         emit OwnershipTransferred(address(0), msgSender);
704     }
705 
706     /**
707      * @dev Returns the address of the current owner.
708      */
709     function owner() public view returns (address) {
710         return _owner;
711     }
712 
713     /**
714      * @dev Throws if called by any account other than the owner.
715      */
716     modifier onlyOwner() {
717         require(isOwner(), "Ownable: caller is not the owner");
718         _;
719     }
720 
721     /**
722      * @dev Returns true if the caller is the current owner.
723      */
724     function isOwner() public view returns (bool) {
725         return _msgSender() == _owner;
726     }
727 
728     /**
729      * @dev Leaves the contract without owner. It will not be possible to call
730      * `onlyOwner` functions anymore. Can only be called by the current owner.
731      *
732      * NOTE: Renouncing ownership will leave the contract without an owner,
733      * thereby removing any functionality that is only available to the owner.
734      */
735     function renounceOwnership() public onlyOwner {
736         emit OwnershipTransferred(_owner, address(0));
737         _owner = address(0);
738     }
739 
740     /**
741      * @dev Transfers ownership of the contract to a new account (`newOwner`).
742      * Can only be called by the current owner.
743      */
744     function transferOwnership(address newOwner) public onlyOwner {
745         _transferOwnership(newOwner);
746     }
747 
748     /**
749      * @dev Transfers ownership of the contract to a new account (`newOwner`).
750      */
751     function _transferOwnership(address newOwner) internal {
752         require(newOwner != address(0), "Ownable: new owner is the zero address");
753         emit OwnershipTransferred(_owner, newOwner);
754         _owner = newOwner;
755     }
756 }
757 
758 // File: contracts/src/common/storage/EternalStorage.sol
759 
760 pragma solidity 0.5.17;
761 
762 /**
763  * Module for persisting states.
764  * Stores a map for `uint256`, `string`, `address`, `bytes32`, `bool`, and `int256` type with `bytes32` type as a key.
765  */
766 contract EternalStorage {
767 	address private currentOwner = msg.sender;
768 
769 	mapping(bytes32 => uint256) private uIntStorage;
770 	mapping(bytes32 => string) private stringStorage;
771 	mapping(bytes32 => address) private addressStorage;
772 	mapping(bytes32 => bytes32) private bytesStorage;
773 	mapping(bytes32 => bool) private boolStorage;
774 	mapping(bytes32 => int256) private intStorage;
775 
776 	/**
777 	 * Modifiers to validate that only the owner can execute.
778 	 */
779 	modifier onlyCurrentOwner() {
780 		require(msg.sender == currentOwner, "not current owner");
781 		_;
782 	}
783 
784 	/**
785 	 * Transfer the owner.
786 	 * Only the owner can execute this function.
787 	 */
788 	function changeOwner(address _newOwner) external {
789 		require(msg.sender == currentOwner, "not current owner");
790 		currentOwner = _newOwner;
791 	}
792 
793 	// *** Getter Methods ***
794 
795 	/**
796 	 * Returns the value of the `uint256` type that mapped to the given key.
797 	 */
798 	function getUint(bytes32 _key) external view returns (uint256) {
799 		return uIntStorage[_key];
800 	}
801 
802 	/**
803 	 * Returns the value of the `string` type that mapped to the given key.
804 	 */
805 	function getString(bytes32 _key) external view returns (string memory) {
806 		return stringStorage[_key];
807 	}
808 
809 	/**
810 	 * Returns the value of the `address` type that mapped to the given key.
811 	 */
812 	function getAddress(bytes32 _key) external view returns (address) {
813 		return addressStorage[_key];
814 	}
815 
816 	/**
817 	 * Returns the value of the `bytes32` type that mapped to the given key.
818 	 */
819 	function getBytes(bytes32 _key) external view returns (bytes32) {
820 		return bytesStorage[_key];
821 	}
822 
823 	/**
824 	 * Returns the value of the `bool` type that mapped to the given key.
825 	 */
826 	function getBool(bytes32 _key) external view returns (bool) {
827 		return boolStorage[_key];
828 	}
829 
830 	/**
831 	 * Returns the value of the `int256` type that mapped to the given key.
832 	 */
833 	function getInt(bytes32 _key) external view returns (int256) {
834 		return intStorage[_key];
835 	}
836 
837 	// *** Setter Methods ***
838 
839 	/**
840 	 * Maps a value of `uint256` type to a given key.
841 	 * Only the owner can execute this function.
842 	 */
843 	function setUint(bytes32 _key, uint256 _value) external onlyCurrentOwner {
844 		uIntStorage[_key] = _value;
845 	}
846 
847 	/**
848 	 * Maps a value of `string` type to a given key.
849 	 * Only the owner can execute this function.
850 	 */
851 	function setString(bytes32 _key, string calldata _value)
852 		external
853 		onlyCurrentOwner
854 	{
855 		stringStorage[_key] = _value;
856 	}
857 
858 	/**
859 	 * Maps a value of `address` type to a given key.
860 	 * Only the owner can execute this function.
861 	 */
862 	function setAddress(bytes32 _key, address _value)
863 		external
864 		onlyCurrentOwner
865 	{
866 		addressStorage[_key] = _value;
867 	}
868 
869 	/**
870 	 * Maps a value of `bytes32` type to a given key.
871 	 * Only the owner can execute this function.
872 	 */
873 	function setBytes(bytes32 _key, bytes32 _value) external onlyCurrentOwner {
874 		bytesStorage[_key] = _value;
875 	}
876 
877 	/**
878 	 * Maps a value of `bool` type to a given key.
879 	 * Only the owner can execute this function.
880 	 */
881 	function setBool(bytes32 _key, bool _value) external onlyCurrentOwner {
882 		boolStorage[_key] = _value;
883 	}
884 
885 	/**
886 	 * Maps a value of `int256` type to a given key.
887 	 * Only the owner can execute this function.
888 	 */
889 	function setInt(bytes32 _key, int256 _value) external onlyCurrentOwner {
890 		intStorage[_key] = _value;
891 	}
892 
893 	// *** Delete Methods ***
894 
895 	/**
896 	 * Deletes the value of the `uint256` type that mapped to the given key.
897 	 * Only the owner can execute this function.
898 	 */
899 	function deleteUint(bytes32 _key) external onlyCurrentOwner {
900 		delete uIntStorage[_key];
901 	}
902 
903 	/**
904 	 * Deletes the value of the `string` type that mapped to the given key.
905 	 * Only the owner can execute this function.
906 	 */
907 	function deleteString(bytes32 _key) external onlyCurrentOwner {
908 		delete stringStorage[_key];
909 	}
910 
911 	/**
912 	 * Deletes the value of the `address` type that mapped to the given key.
913 	 * Only the owner can execute this function.
914 	 */
915 	function deleteAddress(bytes32 _key) external onlyCurrentOwner {
916 		delete addressStorage[_key];
917 	}
918 
919 	/**
920 	 * Deletes the value of the `bytes32` type that mapped to the given key.
921 	 * Only the owner can execute this function.
922 	 */
923 	function deleteBytes(bytes32 _key) external onlyCurrentOwner {
924 		delete bytesStorage[_key];
925 	}
926 
927 	/**
928 	 * Deletes the value of the `bool` type that mapped to the given key.
929 	 * Only the owner can execute this function.
930 	 */
931 	function deleteBool(bytes32 _key) external onlyCurrentOwner {
932 		delete boolStorage[_key];
933 	}
934 
935 	/**
936 	 * Deletes the value of the `int256` type that mapped to the given key.
937 	 * Only the owner can execute this function.
938 	 */
939 	function deleteInt(bytes32 _key) external onlyCurrentOwner {
940 		delete intStorage[_key];
941 	}
942 }
943 
944 // File: contracts/src/common/storage/UsingStorage.sol
945 
946 pragma solidity 0.5.17;
947 
948 
949 
950 
951 /**
952  * Module for contrast handling EternalStorage.
953  */
954 contract UsingStorage is Ownable, IUsingStorage {
955 	address private _storage;
956 
957 	/**
958 	 * Modifier to verify that EternalStorage is set.
959 	 */
960 	modifier hasStorage() {
961 		require(_storage != address(0), "storage is not set");
962 		_;
963 	}
964 
965 	/**
966 	 * Returns the set EternalStorage instance.
967 	 */
968 	function eternalStorage()
969 		internal
970 		view
971 		hasStorage
972 		returns (EternalStorage)
973 	{
974 		return EternalStorage(_storage);
975 	}
976 
977 	/**
978 	 * Returns the set EternalStorage address.
979 	 */
980 	function getStorageAddress() external view hasStorage returns (address) {
981 		return _storage;
982 	}
983 
984 	/**
985 	 * Create a new EternalStorage contract.
986 	 * This function call will fail if the EternalStorage contract is already set.
987 	 * Also, only the owner can execute it.
988 	 */
989 	function createStorage() external onlyOwner {
990 		require(_storage == address(0), "storage is set");
991 		EternalStorage tmp = new EternalStorage();
992 		_storage = address(tmp);
993 	}
994 
995 	/**
996 	 * Assigns the EternalStorage contract that has already been created.
997 	 * Only the owner can execute this function.
998 	 */
999 	function setStorage(address _storageAddress) external onlyOwner {
1000 		_storage = _storageAddress;
1001 	}
1002 
1003 	/**
1004 	 * Delegates the owner of the current EternalStorage contract.
1005 	 * Only the owner can execute this function.
1006 	 */
1007 	function changeOwner(address newOwner) external onlyOwner {
1008 		EternalStorage(_storage).changeOwner(newOwner);
1009 	}
1010 }
1011 
1012 // File: contracts/src/lockup/LockupStorage.sol
1013 
1014 pragma solidity 0.5.17;
1015 
1016 
1017 
1018 contract LockupStorage is UsingStorage {
1019 	using SafeMath for uint256;
1020 
1021 	uint256 private constant BASIS = 100000000000000000000000000000000;
1022 
1023 	//AllValue
1024 	function setStorageAllValue(uint256 _value) internal {
1025 		bytes32 key = getStorageAllValueKey();
1026 		eternalStorage().setUint(key, _value);
1027 	}
1028 
1029 	function getStorageAllValue() public view returns (uint256) {
1030 		bytes32 key = getStorageAllValueKey();
1031 		return eternalStorage().getUint(key);
1032 	}
1033 
1034 	function getStorageAllValueKey() private pure returns (bytes32) {
1035 		return keccak256(abi.encodePacked("_allValue"));
1036 	}
1037 
1038 	//Value
1039 	function setStorageValue(
1040 		address _property,
1041 		address _sender,
1042 		uint256 _value
1043 	) internal {
1044 		bytes32 key = getStorageValueKey(_property, _sender);
1045 		eternalStorage().setUint(key, _value);
1046 	}
1047 
1048 	function getStorageValue(address _property, address _sender)
1049 		public
1050 		view
1051 		returns (uint256)
1052 	{
1053 		bytes32 key = getStorageValueKey(_property, _sender);
1054 		return eternalStorage().getUint(key);
1055 	}
1056 
1057 	function getStorageValueKey(address _property, address _sender)
1058 		private
1059 		pure
1060 		returns (bytes32)
1061 	{
1062 		return keccak256(abi.encodePacked("_value", _property, _sender));
1063 	}
1064 
1065 	//PropertyValue
1066 	function setStoragePropertyValue(address _property, uint256 _value)
1067 		internal
1068 	{
1069 		bytes32 key = getStoragePropertyValueKey(_property);
1070 		eternalStorage().setUint(key, _value);
1071 	}
1072 
1073 	function getStoragePropertyValue(address _property)
1074 		public
1075 		view
1076 		returns (uint256)
1077 	{
1078 		bytes32 key = getStoragePropertyValueKey(_property);
1079 		return eternalStorage().getUint(key);
1080 	}
1081 
1082 	function getStoragePropertyValueKey(address _property)
1083 		private
1084 		pure
1085 		returns (bytes32)
1086 	{
1087 		return keccak256(abi.encodePacked("_propertyValue", _property));
1088 	}
1089 
1090 	//InterestPrice
1091 	function setStorageInterestPrice(address _property, uint256 _value)
1092 		internal
1093 	{
1094 		// The previously used function
1095 		// This function is only used in testing
1096 		eternalStorage().setUint(getStorageInterestPriceKey(_property), _value);
1097 	}
1098 
1099 	function getStorageInterestPrice(address _property)
1100 		public
1101 		view
1102 		returns (uint256)
1103 	{
1104 		return eternalStorage().getUint(getStorageInterestPriceKey(_property));
1105 	}
1106 
1107 	function getStorageInterestPriceKey(address _property)
1108 		private
1109 		pure
1110 		returns (bytes32)
1111 	{
1112 		return keccak256(abi.encodePacked("_interestTotals", _property));
1113 	}
1114 
1115 	//LastInterestPrice
1116 	function setStorageLastInterestPrice(
1117 		address _property,
1118 		address _user,
1119 		uint256 _value
1120 	) internal {
1121 		eternalStorage().setUint(
1122 			getStorageLastInterestPriceKey(_property, _user),
1123 			_value
1124 		);
1125 	}
1126 
1127 	function getStorageLastInterestPrice(address _property, address _user)
1128 		public
1129 		view
1130 		returns (uint256)
1131 	{
1132 		return
1133 			eternalStorage().getUint(
1134 				getStorageLastInterestPriceKey(_property, _user)
1135 			);
1136 	}
1137 
1138 	function getStorageLastInterestPriceKey(address _property, address _user)
1139 		private
1140 		pure
1141 		returns (bytes32)
1142 	{
1143 		return
1144 			keccak256(
1145 				abi.encodePacked("_lastLastInterestPrice", _property, _user)
1146 			);
1147 	}
1148 
1149 	//LastSameRewardsAmountAndBlock
1150 	function setStorageLastSameRewardsAmountAndBlock(
1151 		uint256 _amount,
1152 		uint256 _block
1153 	) internal {
1154 		uint256 record = _amount.mul(BASIS).add(_block);
1155 		eternalStorage().setUint(
1156 			getStorageLastSameRewardsAmountAndBlockKey(),
1157 			record
1158 		);
1159 	}
1160 
1161 	function getStorageLastSameRewardsAmountAndBlock()
1162 		public
1163 		view
1164 		returns (uint256 _amount, uint256 _block)
1165 	{
1166 		uint256 record = eternalStorage().getUint(
1167 			getStorageLastSameRewardsAmountAndBlockKey()
1168 		);
1169 		uint256 amount = record.div(BASIS);
1170 		uint256 blockNumber = record.sub(amount.mul(BASIS));
1171 		return (amount, blockNumber);
1172 	}
1173 
1174 	function getStorageLastSameRewardsAmountAndBlockKey()
1175 		private
1176 		pure
1177 		returns (bytes32)
1178 	{
1179 		return keccak256(abi.encodePacked("_LastSameRewardsAmountAndBlock"));
1180 	}
1181 
1182 	//CumulativeGlobalRewards
1183 	function setStorageCumulativeGlobalRewards(uint256 _value) internal {
1184 		eternalStorage().setUint(
1185 			getStorageCumulativeGlobalRewardsKey(),
1186 			_value
1187 		);
1188 	}
1189 
1190 	function getStorageCumulativeGlobalRewards() public view returns (uint256) {
1191 		return eternalStorage().getUint(getStorageCumulativeGlobalRewardsKey());
1192 	}
1193 
1194 	function getStorageCumulativeGlobalRewardsKey()
1195 		private
1196 		pure
1197 		returns (bytes32)
1198 	{
1199 		return keccak256(abi.encodePacked("_cumulativeGlobalRewards"));
1200 	}
1201 
1202 	//PendingWithdrawal
1203 	function setStoragePendingInterestWithdrawal(
1204 		address _property,
1205 		address _user,
1206 		uint256 _value
1207 	) internal {
1208 		eternalStorage().setUint(
1209 			getStoragePendingInterestWithdrawalKey(_property, _user),
1210 			_value
1211 		);
1212 	}
1213 
1214 	function getStoragePendingInterestWithdrawal(
1215 		address _property,
1216 		address _user
1217 	) public view returns (uint256) {
1218 		return
1219 			eternalStorage().getUint(
1220 				getStoragePendingInterestWithdrawalKey(_property, _user)
1221 			);
1222 	}
1223 
1224 	function getStoragePendingInterestWithdrawalKey(
1225 		address _property,
1226 		address _user
1227 	) private pure returns (bytes32) {
1228 		return
1229 			keccak256(
1230 				abi.encodePacked("_pendingInterestWithdrawal", _property, _user)
1231 			);
1232 	}
1233 
1234 	//DIP4GenesisBlock
1235 	function setStorageDIP4GenesisBlock(uint256 _block) internal {
1236 		eternalStorage().setUint(getStorageDIP4GenesisBlockKey(), _block);
1237 	}
1238 
1239 	function getStorageDIP4GenesisBlock() public view returns (uint256) {
1240 		return eternalStorage().getUint(getStorageDIP4GenesisBlockKey());
1241 	}
1242 
1243 	function getStorageDIP4GenesisBlockKey() private pure returns (bytes32) {
1244 		return keccak256(abi.encodePacked("_dip4GenesisBlock"));
1245 	}
1246 
1247 	//lastStakedInterestPrice
1248 	function setStorageLastStakedInterestPrice(
1249 		address _property,
1250 		address _user,
1251 		uint256 _value
1252 	) internal {
1253 		eternalStorage().setUint(
1254 			getStorageLastStakedInterestPriceKey(_property, _user),
1255 			_value
1256 		);
1257 	}
1258 
1259 	function getStorageLastStakedInterestPrice(address _property, address _user)
1260 		public
1261 		view
1262 		returns (uint256)
1263 	{
1264 		return
1265 			eternalStorage().getUint(
1266 				getStorageLastStakedInterestPriceKey(_property, _user)
1267 			);
1268 	}
1269 
1270 	function getStorageLastStakedInterestPriceKey(
1271 		address _property,
1272 		address _user
1273 	) private pure returns (bytes32) {
1274 		return
1275 			keccak256(
1276 				abi.encodePacked("_lastStakedInterestPrice", _property, _user)
1277 			);
1278 	}
1279 
1280 	//lastStakesChangedCumulativeReward
1281 	function setStorageLastStakesChangedCumulativeReward(uint256 _value)
1282 		internal
1283 	{
1284 		eternalStorage().setUint(
1285 			getStorageLastStakesChangedCumulativeRewardKey(),
1286 			_value
1287 		);
1288 	}
1289 
1290 	function getStorageLastStakesChangedCumulativeReward()
1291 		public
1292 		view
1293 		returns (uint256)
1294 	{
1295 		return
1296 			eternalStorage().getUint(
1297 				getStorageLastStakesChangedCumulativeRewardKey()
1298 			);
1299 	}
1300 
1301 	function getStorageLastStakesChangedCumulativeRewardKey()
1302 		private
1303 		pure
1304 		returns (bytes32)
1305 	{
1306 		return
1307 			keccak256(abi.encodePacked("_lastStakesChangedCumulativeReward"));
1308 	}
1309 
1310 	//LastCumulativeHoldersRewardPrice
1311 	function setStorageLastCumulativeHoldersRewardPrice(uint256 _holders)
1312 		internal
1313 	{
1314 		eternalStorage().setUint(
1315 			getStorageLastCumulativeHoldersRewardPriceKey(),
1316 			_holders
1317 		);
1318 	}
1319 
1320 	function getStorageLastCumulativeHoldersRewardPrice()
1321 		public
1322 		view
1323 		returns (uint256)
1324 	{
1325 		return
1326 			eternalStorage().getUint(
1327 				getStorageLastCumulativeHoldersRewardPriceKey()
1328 			);
1329 	}
1330 
1331 	function getStorageLastCumulativeHoldersRewardPriceKey()
1332 		private
1333 		pure
1334 		returns (bytes32)
1335 	{
1336 		return keccak256(abi.encodePacked("0lastCumulativeHoldersRewardPrice"));
1337 	}
1338 
1339 	//LastCumulativeInterestPrice
1340 	function setStorageLastCumulativeInterestPrice(uint256 _interest) internal {
1341 		eternalStorage().setUint(
1342 			getStorageLastCumulativeInterestPriceKey(),
1343 			_interest
1344 		);
1345 	}
1346 
1347 	function getStorageLastCumulativeInterestPrice()
1348 		public
1349 		view
1350 		returns (uint256)
1351 	{
1352 		return
1353 			eternalStorage().getUint(
1354 				getStorageLastCumulativeInterestPriceKey()
1355 			);
1356 	}
1357 
1358 	function getStorageLastCumulativeInterestPriceKey()
1359 		private
1360 		pure
1361 		returns (bytes32)
1362 	{
1363 		return keccak256(abi.encodePacked("0lastCumulativeInterestPrice"));
1364 	}
1365 
1366 	//LastCumulativeHoldersRewardAmountPerProperty
1367 	function setStorageLastCumulativeHoldersRewardAmountPerProperty(
1368 		address _property,
1369 		uint256 _value
1370 	) internal {
1371 		eternalStorage().setUint(
1372 			getStorageLastCumulativeHoldersRewardAmountPerPropertyKey(
1373 				_property
1374 			),
1375 			_value
1376 		);
1377 	}
1378 
1379 	function getStorageLastCumulativeHoldersRewardAmountPerProperty(
1380 		address _property
1381 	) public view returns (uint256) {
1382 		return
1383 			eternalStorage().getUint(
1384 				getStorageLastCumulativeHoldersRewardAmountPerPropertyKey(
1385 					_property
1386 				)
1387 			);
1388 	}
1389 
1390 	function getStorageLastCumulativeHoldersRewardAmountPerPropertyKey(
1391 		address _property
1392 	) private pure returns (bytes32) {
1393 		return
1394 			keccak256(
1395 				abi.encodePacked(
1396 					"0lastCumulativeHoldersRewardAmountPerProperty",
1397 					_property
1398 				)
1399 			);
1400 	}
1401 
1402 	//LastCumulativeHoldersRewardPricePerProperty
1403 	function setStorageLastCumulativeHoldersRewardPricePerProperty(
1404 		address _property,
1405 		uint256 _price
1406 	) internal {
1407 		eternalStorage().setUint(
1408 			getStorageLastCumulativeHoldersRewardPricePerPropertyKey(_property),
1409 			_price
1410 		);
1411 	}
1412 
1413 	function getStorageLastCumulativeHoldersRewardPricePerProperty(
1414 		address _property
1415 	) public view returns (uint256) {
1416 		return
1417 			eternalStorage().getUint(
1418 				getStorageLastCumulativeHoldersRewardPricePerPropertyKey(
1419 					_property
1420 				)
1421 			);
1422 	}
1423 
1424 	function getStorageLastCumulativeHoldersRewardPricePerPropertyKey(
1425 		address _property
1426 	) private pure returns (bytes32) {
1427 		return
1428 			keccak256(
1429 				abi.encodePacked(
1430 					"0lastCumulativeHoldersRewardPricePerProperty",
1431 					_property
1432 				)
1433 			);
1434 	}
1435 
1436 	//cap
1437 	function setStorageCap(uint256 _cap) internal {
1438 		eternalStorage().setUint(getStorageCapKey(), _cap);
1439 	}
1440 
1441 	function getStorageCap() public view returns (uint256) {
1442 		return eternalStorage().getUint(getStorageCapKey());
1443 	}
1444 
1445 	function getStorageCapKey() private pure returns (bytes32) {
1446 		return keccak256(abi.encodePacked("_cap"));
1447 	}
1448 
1449 	//CumulativeHoldersRewardCap
1450 	function setStorageCumulativeHoldersRewardCap(uint256 _value) internal {
1451 		eternalStorage().setUint(
1452 			getStorageCumulativeHoldersRewardCapKey(),
1453 			_value
1454 		);
1455 	}
1456 
1457 	function getStorageCumulativeHoldersRewardCap()
1458 		public
1459 		view
1460 		returns (uint256)
1461 	{
1462 		return
1463 			eternalStorage().getUint(getStorageCumulativeHoldersRewardCapKey());
1464 	}
1465 
1466 	function getStorageCumulativeHoldersRewardCapKey()
1467 		private
1468 		pure
1469 		returns (bytes32)
1470 	{
1471 		return keccak256(abi.encodePacked("_cumulativeHoldersRewardCap"));
1472 	}
1473 
1474 	//LastCumulativeHoldersPriceCap
1475 	function setStorageLastCumulativeHoldersPriceCap(uint256 _value) internal {
1476 		eternalStorage().setUint(
1477 			getStorageLastCumulativeHoldersPriceCapKey(),
1478 			_value
1479 		);
1480 	}
1481 
1482 	function getStorageLastCumulativeHoldersPriceCap()
1483 		public
1484 		view
1485 		returns (uint256)
1486 	{
1487 		return
1488 			eternalStorage().getUint(
1489 				getStorageLastCumulativeHoldersPriceCapKey()
1490 			);
1491 	}
1492 
1493 	function getStorageLastCumulativeHoldersPriceCapKey()
1494 		private
1495 		pure
1496 		returns (bytes32)
1497 	{
1498 		return keccak256(abi.encodePacked("_lastCumulativeHoldersPriceCap"));
1499 	}
1500 
1501 	//InitialCumulativeHoldersRewardCap
1502 	function setStorageInitialCumulativeHoldersRewardCap(
1503 		address _property,
1504 		uint256 _value
1505 	) internal {
1506 		eternalStorage().setUint(
1507 			getStorageInitialCumulativeHoldersRewardCapKey(_property),
1508 			_value
1509 		);
1510 	}
1511 
1512 	function getStorageInitialCumulativeHoldersRewardCap(address _property)
1513 		public
1514 		view
1515 		returns (uint256)
1516 	{
1517 		return
1518 			eternalStorage().getUint(
1519 				getStorageInitialCumulativeHoldersRewardCapKey(_property)
1520 			);
1521 	}
1522 
1523 	function getStorageInitialCumulativeHoldersRewardCapKey(address _property)
1524 		private
1525 		pure
1526 		returns (bytes32)
1527 	{
1528 		return
1529 			keccak256(
1530 				abi.encodePacked(
1531 					"_initialCumulativeHoldersRewardCap",
1532 					_property
1533 				)
1534 			);
1535 	}
1536 
1537 	//FallbackInitialCumulativeHoldersRewardCap
1538 	function setStorageFallbackInitialCumulativeHoldersRewardCap(uint256 _value)
1539 		internal
1540 	{
1541 		eternalStorage().setUint(
1542 			getStorageFallbackInitialCumulativeHoldersRewardCapKey(),
1543 			_value
1544 		);
1545 	}
1546 
1547 	function getStorageFallbackInitialCumulativeHoldersRewardCap()
1548 		public
1549 		view
1550 		returns (uint256)
1551 	{
1552 		return
1553 			eternalStorage().getUint(
1554 				getStorageFallbackInitialCumulativeHoldersRewardCapKey()
1555 			);
1556 	}
1557 
1558 	function getStorageFallbackInitialCumulativeHoldersRewardCapKey()
1559 		private
1560 		pure
1561 		returns (bytes32)
1562 	{
1563 		return
1564 			keccak256(
1565 				abi.encodePacked("_fallbackInitialCumulativeHoldersRewardCap")
1566 			);
1567 	}
1568 }
1569 
1570 // File: contracts/interface/IDev.sol
1571 
1572 // SPDX-License-Identifier: MPL-2.0
1573 pragma solidity >=0.5.17;
1574 
1575 interface IDev {
1576 	function deposit(address _to, uint256 _amount) external returns (bool);
1577 
1578 	function depositFrom(
1579 		address _from,
1580 		address _to,
1581 		uint256 _amount
1582 	) external returns (bool);
1583 
1584 	function fee(address _from, uint256 _amount) external returns (bool);
1585 }
1586 
1587 // File: contracts/interface/IDevMinter.sol
1588 
1589 // SPDX-License-Identifier: MPL-2.0
1590 pragma solidity >=0.5.17;
1591 
1592 interface IDevMinter {
1593 	function mint(address account, uint256 amount) external returns (bool);
1594 
1595 	function renounceMinter() external;
1596 }
1597 
1598 // File: contracts/interface/IProperty.sol
1599 
1600 // SPDX-License-Identifier: MPL-2.0
1601 pragma solidity >=0.5.17;
1602 
1603 interface IProperty {
1604 	function author() external view returns (address);
1605 
1606 	function changeAuthor(address _nextAuthor) external;
1607 
1608 	function changeName(string calldata _name) external;
1609 
1610 	function changeSymbol(string calldata _symbol) external;
1611 
1612 	function withdraw(address _sender, uint256 _value) external;
1613 }
1614 
1615 // File: contracts/interface/IPolicy.sol
1616 
1617 // SPDX-License-Identifier: MPL-2.0
1618 pragma solidity >=0.5.17;
1619 
1620 interface IPolicy {
1621 	function rewards(uint256 _lockups, uint256 _assets)
1622 		external
1623 		view
1624 		returns (uint256);
1625 
1626 	function holdersShare(uint256 _amount, uint256 _lockups)
1627 		external
1628 		view
1629 		returns (uint256);
1630 
1631 	function authenticationFee(uint256 _assets, uint256 _propertyAssets)
1632 		external
1633 		view
1634 		returns (uint256);
1635 
1636 	function marketVotingBlocks() external view returns (uint256);
1637 
1638 	function policyVotingBlocks() external view returns (uint256);
1639 
1640 	function shareOfTreasury(uint256 _supply) external view returns (uint256);
1641 
1642 	function treasury() external view returns (address);
1643 
1644 	function capSetter() external view returns (address);
1645 }
1646 
1647 // File: contracts/interface/IAllocator.sol
1648 
1649 // SPDX-License-Identifier: MPL-2.0
1650 pragma solidity >=0.5.17;
1651 
1652 interface IAllocator {
1653 	function beforeBalanceChange(
1654 		address _property,
1655 		address _from,
1656 		address _to
1657 	) external;
1658 
1659 	function calculateMaxRewardsPerBlock() external view returns (uint256);
1660 }
1661 
1662 // File: contracts/interface/ILockup.sol
1663 
1664 // SPDX-License-Identifier: MPL-2.0
1665 pragma solidity >=0.5.17;
1666 
1667 interface ILockup {
1668 	function depositToProperty(address _property, uint256 _amount)
1669 		external
1670 		returns (uint256);
1671 
1672 	function depositToPosition(uint256 _tokenId, uint256 _amount)
1673 		external
1674 		returns (bool);
1675 
1676 	function lockup(
1677 		address _from,
1678 		address _property,
1679 		uint256 _value
1680 	) external;
1681 
1682 	function update() external;
1683 
1684 	function withdraw(address _property, uint256 _amount) external;
1685 
1686 	function withdrawByPosition(uint256 _tokenId, uint256 _amount)
1687 		external
1688 		returns (bool);
1689 
1690 	function calculateCumulativeRewardPrices()
1691 		external
1692 		view
1693 		returns (
1694 			uint256 _reward,
1695 			uint256 _holders,
1696 			uint256 _interest,
1697 			uint256 _holdersCap
1698 		);
1699 
1700 	function calculateRewardAmount(address _property)
1701 		external
1702 		view
1703 		returns (uint256, uint256);
1704 
1705 	/**
1706 	 * caution!!!this function is deprecated!!!
1707 	 * use calculateRewardAmount
1708 	 */
1709 	function calculateCumulativeHoldersRewardAmount(address _property)
1710 		external
1711 		view
1712 		returns (uint256);
1713 
1714 	function getPropertyValue(address _property)
1715 		external
1716 		view
1717 		returns (uint256);
1718 
1719 	function getAllValue() external view returns (uint256);
1720 
1721 	function getValue(address _property, address _sender)
1722 		external
1723 		view
1724 		returns (uint256);
1725 
1726 	function calculateWithdrawableInterestAmount(
1727 		address _property,
1728 		address _user
1729 	) external view returns (uint256);
1730 
1731 	function calculateWithdrawableInterestAmountByPosition(uint256 _tokenId)
1732 		external
1733 		view
1734 		returns (uint256);
1735 
1736 	function cap() external view returns (uint256);
1737 
1738 	function updateCap(uint256 _cap) external;
1739 
1740 	function devMinter() external view returns (address);
1741 
1742 	function sTokensManager() external view returns (address);
1743 
1744 	function migrateToSTokens(address _property) external returns (uint256);
1745 }
1746 
1747 // File: contracts/interface/IMetricsGroup.sol
1748 
1749 // SPDX-License-Identifier: MPL-2.0
1750 pragma solidity >=0.5.17;
1751 
1752 interface IMetricsGroup {
1753 	function addGroup(address _addr) external;
1754 
1755 	function removeGroup(address _addr) external;
1756 
1757 	function isGroup(address _addr) external view returns (bool);
1758 
1759 	function totalIssuedMetrics() external view returns (uint256);
1760 
1761 	function hasAssets(address _property) external view returns (bool);
1762 
1763 	function getMetricsCountPerProperty(address _property)
1764 		external
1765 		view
1766 		returns (uint256);
1767 
1768 	function totalAuthenticatedProperties() external view returns (uint256);
1769 }
1770 
1771 // File: contracts/src/lockup/Lockup.sol
1772 
1773 pragma solidity 0.5.17;
1774 
1775 // prettier-ignore
1776 
1777 
1778 
1779 
1780 
1781 
1782 
1783 
1784 
1785 
1786 
1787 
1788 
1789 
1790 
1791 /**
1792  * A contract that manages the staking of DEV tokens and calculates rewards.
1793  * Staking and the following mechanism determines that reward calculation.
1794  *
1795  * Variables:
1796  * -`M`: Maximum mint amount per block determined by Allocator contract
1797  * -`B`: Number of blocks during staking
1798  * -`P`: Total number of staking locked up in a Property contract
1799  * -`S`: Total number of staking locked up in all Property contracts
1800  * -`U`: Number of staking per account locked up in a Property contract
1801  *
1802  * Formula:
1803  * Staking Rewards = M * B * (P / S) * (U / P)
1804  *
1805  * Note:
1806  * -`M`, `P` and `S` vary from block to block, and the variation cannot be predicted.
1807  * -`B` is added every time the Ethereum block is created.
1808  * - Only `U` and `B` are predictable variables.
1809  * - As `M`, `P` and `S` cannot be observed from a staker, the "cumulative sum" is often used to calculate ratio variation with history.
1810  * - Reward withdrawal always withdraws the total withdrawable amount.
1811  *
1812  * Scenario:
1813  * - Assume `M` is fixed at 500
1814  * - Alice stakes 100 DEV on Property-A (Alice's staking state on Property-A: `M`=500, `B`=0, `P`=100, `S`=100, `U`=100)
1815  * - After 10 blocks, Bob stakes 60 DEV on Property-B (Alice's staking state on Property-A: `M`=500, `B`=10, `P`=100, `S`=160, `U`=100)
1816  * - After 10 blocks, Carol stakes 40 DEV on Property-A (Alice's staking state on Property-A: `M`=500, `B`=20, `P`=140, `S`=200, `U`=100)
1817  * - After 10 blocks, Alice withdraws Property-A staking reward. The reward at this time is 5000 DEV (10 blocks * 500 DEV) + 3125 DEV (10 blocks * 62.5% * 500 DEV) + 2500 DEV (10 blocks * 50% * 500 DEV).
1818  */
1819 contract Lockup is ILockup, UsingConfig, LockupStorage {
1820 	using SafeMath for uint256;
1821 	using Decimals for uint256;
1822 	address public devMinter;
1823 	address public sTokensManager;
1824 	struct RewardPrices {
1825 		uint256 reward;
1826 		uint256 holders;
1827 		uint256 interest;
1828 		uint256 holdersCap;
1829 	}
1830 	event Lockedup(address _from, address _property, uint256 _value);
1831 	event UpdateCap(uint256 _cap);
1832 
1833 	/**
1834 	 * Initialize the passed address as AddressConfig address and Devminter.
1835 	 */
1836 	constructor(
1837 		address _config,
1838 		address _devMinter,
1839 		address _sTokensManager
1840 	) public UsingConfig(_config) {
1841 		devMinter = _devMinter;
1842 		sTokensManager = _sTokensManager;
1843 	}
1844 
1845 	/**
1846 	 * @dev Validates the passed Property has greater than 1 asset.
1847 	 * @param _property property address
1848 	 */
1849 	modifier onlyAuthenticatedProperty(address _property) {
1850 		require(
1851 			IMetricsGroup(config().metricsGroup()).hasAssets(_property),
1852 			"unable to stake to unauthenticated property"
1853 		);
1854 		_;
1855 	}
1856 
1857 	/**
1858 	 * @dev Check if the owner of the token is a sender.
1859 	 * @param _tokenId The ID of the staking position
1860 	 */
1861 	modifier onlyPositionOwner(uint256 _tokenId) {
1862 		require(
1863 			IERC721(sTokensManager).ownerOf(_tokenId) == msg.sender,
1864 			"illegal sender"
1865 		);
1866 		_;
1867 	}
1868 
1869 	/**
1870 	 * @dev deposit dev token to dev protocol and generate s-token
1871 	 * @param _property target property address
1872 	 * @param _amount staking value
1873 	 * @return tokenId The ID of the created new staking position
1874 	 */
1875 	function depositToProperty(address _property, uint256 _amount)
1876 		external
1877 		onlyAuthenticatedProperty(_property)
1878 		returns (uint256)
1879 	{
1880 		/**
1881 		 * Validates _amount is not 0.
1882 		 */
1883 		require(_amount != 0, "illegal deposit amount");
1884 		/**
1885 		 * Gets the latest cumulative sum of the interest price.
1886 		 */
1887 		(
1888 			uint256 reward,
1889 			uint256 holders,
1890 			uint256 interest,
1891 			uint256 holdersCap
1892 		) = calculateCumulativeRewardPrices();
1893 		/**
1894 		 * Saves variables that should change due to the addition of staking.
1895 		 */
1896 		updateValues(
1897 			true,
1898 			_property,
1899 			_amount,
1900 			RewardPrices(reward, holders, interest, holdersCap)
1901 		);
1902 		/**
1903 		 * transfer dev tokens
1904 		 */
1905 		require(
1906 			IERC20(config().token()).transferFrom(
1907 				msg.sender,
1908 				_property,
1909 				_amount
1910 			),
1911 			"dev transfer failed"
1912 		);
1913 		/**
1914 		 * mint s tokens
1915 		 */
1916 		uint256 tokenId = ISTokensManager(sTokensManager).mint(
1917 			msg.sender,
1918 			_property,
1919 			_amount,
1920 			interest
1921 		);
1922 		emit Lockedup(msg.sender, _property, _amount);
1923 		return tokenId;
1924 	}
1925 
1926 	/**
1927 	 * @dev deposit dev token to dev protocol and update s-token status
1928 	 * @param _tokenId s-token id
1929 	 * @param _amount staking value
1930 	 * @return bool On success, true will be returned
1931 	 */
1932 	function depositToPosition(uint256 _tokenId, uint256 _amount)
1933 		external
1934 		onlyPositionOwner(_tokenId)
1935 		returns (bool)
1936 	{
1937 		/**
1938 		 * Validates _amount is not 0.
1939 		 */
1940 		require(_amount != 0, "illegal deposit amount");
1941 		ISTokensManager sTokenManagerInstance = ISTokensManager(sTokensManager);
1942 		/**
1943 		 * get position information
1944 		 */
1945 		(
1946 			address property,
1947 			uint256 amount,
1948 			uint256 price,
1949 			uint256 cumulativeReward,
1950 			uint256 pendingReward
1951 		) = sTokenManagerInstance.positions(_tokenId);
1952 		/**
1953 		 * Gets the withdrawable amount.
1954 		 */
1955 		(
1956 			uint256 withdrawable,
1957 			RewardPrices memory prices
1958 		) = _calculateWithdrawableInterestAmount(
1959 				property,
1960 				amount,
1961 				price,
1962 				pendingReward
1963 			);
1964 		/**
1965 		 * Saves variables that should change due to the addition of staking.
1966 		 */
1967 		updateValues(true, property, _amount, prices);
1968 		/**
1969 		 * transfer dev tokens
1970 		 */
1971 		require(
1972 			IERC20(config().token()).transferFrom(
1973 				msg.sender,
1974 				property,
1975 				_amount
1976 			),
1977 			"dev transfer failed"
1978 		);
1979 		/**
1980 		 * update position information
1981 		 */
1982 		bool result = sTokenManagerInstance.update(
1983 			_tokenId,
1984 			amount.add(_amount),
1985 			prices.interest,
1986 			cumulativeReward.add(withdrawable),
1987 			pendingReward.add(withdrawable)
1988 		);
1989 		require(result, "failed to update");
1990 		/**
1991 		 * generate events
1992 		 */
1993 		emit Lockedup(msg.sender, property, _amount);
1994 		return true;
1995 	}
1996 
1997 	/**
1998 	 * Adds staking.
1999 	 * Only the Dev contract can execute this function.
2000 	 */
2001 	function lockup(
2002 		address _from,
2003 		address _property,
2004 		uint256 _value
2005 	) external onlyAuthenticatedProperty(_property) {
2006 		/**
2007 		 * Validates the sender is Dev contract.
2008 		 */
2009 		require(msg.sender == config().token(), "this is illegal address");
2010 
2011 		/**
2012 		 * Validates _value is not 0.
2013 		 */
2014 		require(_value != 0, "illegal lockup value");
2015 
2016 		/**
2017 		 * Since the reward per block that can be withdrawn will change with the addition of staking,
2018 		 * saves the undrawn withdrawable reward before addition it.
2019 		 */
2020 		RewardPrices memory prices = updatePendingInterestWithdrawal(
2021 			_property,
2022 			_from
2023 		);
2024 
2025 		/**
2026 		 * Saves variables that should change due to the addition of staking.
2027 		 */
2028 		updateValues4Legacy(true, _from, _property, _value, prices);
2029 
2030 		emit Lockedup(_from, _property, _value);
2031 	}
2032 
2033 	/**
2034 	 * Withdraw staking.(NFT)
2035 	 * Releases staking, withdraw rewards, and transfer the staked and withdraw rewards amount to the sender.
2036 	 */
2037 	function withdrawByPosition(uint256 _tokenId, uint256 _amount)
2038 		external
2039 		onlyPositionOwner(_tokenId)
2040 		returns (bool)
2041 	{
2042 		ISTokensManager sTokenManagerInstance = ISTokensManager(sTokensManager);
2043 		/**
2044 		 * get position information
2045 		 */
2046 		(
2047 			address property,
2048 			uint256 amount,
2049 			uint256 price,
2050 			uint256 cumulativeReward,
2051 			uint256 pendingReward
2052 		) = sTokenManagerInstance.positions(_tokenId);
2053 		/**
2054 		 * If the balance of the withdrawal request is bigger than the balance you are staking
2055 		 */
2056 		require(amount >= _amount, "insufficient tokens staked");
2057 		/**
2058 		 * Withdraws the staking reward
2059 		 */
2060 		(uint256 value, RewardPrices memory prices) = _withdrawInterest(
2061 			property,
2062 			amount,
2063 			price,
2064 			pendingReward
2065 		);
2066 		/**
2067 		 * Transfer the staked amount to the sender.
2068 		 */
2069 		if (_amount != 0) {
2070 			IProperty(property).withdraw(msg.sender, _amount);
2071 		}
2072 		/**
2073 		 * Saves variables that should change due to the canceling staking..
2074 		 */
2075 		updateValues(false, property, _amount, prices);
2076 		uint256 cumulative = cumulativeReward.add(value);
2077 		/**
2078 		 * update position information
2079 		 */
2080 		return
2081 			sTokenManagerInstance.update(
2082 				_tokenId,
2083 				amount.sub(_amount),
2084 				prices.interest,
2085 				cumulative,
2086 				0
2087 			);
2088 	}
2089 
2090 	/**
2091 	 * Withdraw staking.
2092 	 * Releases staking, withdraw rewards, and transfer the staked and withdraw rewards amount to the sender.
2093 	 */
2094 	function withdraw(address _property, uint256 _amount) external {
2095 		/**
2096 		 * Validates the sender is staking to the target Property.
2097 		 */
2098 		require(
2099 			hasValue(_property, msg.sender, _amount),
2100 			"insufficient tokens staked"
2101 		);
2102 
2103 		/**
2104 		 * Withdraws the staking reward
2105 		 */
2106 		RewardPrices memory prices = _withdrawInterest4Legacy(_property);
2107 
2108 		/**
2109 		 * Transfer the staked amount to the sender.
2110 		 */
2111 		if (_amount != 0) {
2112 			IProperty(_property).withdraw(msg.sender, _amount);
2113 		}
2114 
2115 		/**
2116 		 * Saves variables that should change due to the canceling staking..
2117 		 */
2118 		updateValues4Legacy(false, msg.sender, _property, _amount, prices);
2119 	}
2120 
2121 	/**
2122 	 * get cap
2123 	 */
2124 	function cap() external view returns (uint256) {
2125 		return getStorageCap();
2126 	}
2127 
2128 	/**
2129 	 * set cap
2130 	 */
2131 	function updateCap(uint256 _cap) external {
2132 		address setter = IPolicy(config().policy()).capSetter();
2133 		require(setter == msg.sender, "illegal access");
2134 
2135 		/**
2136 		 * Updates cumulative amount of the holders reward cap
2137 		 */
2138 		(
2139 			,
2140 			uint256 holdersPrice,
2141 			,
2142 			uint256 cCap
2143 		) = calculateCumulativeRewardPrices();
2144 
2145 		// TODO: When this function is improved to be called on-chain, the source of `getStorageLastCumulativeHoldersPriceCap` can be rewritten to `getStorageLastCumulativeHoldersRewardPrice`.
2146 		setStorageCumulativeHoldersRewardCap(cCap);
2147 		setStorageLastCumulativeHoldersPriceCap(holdersPrice);
2148 		setStorageCap(_cap);
2149 		emit UpdateCap(_cap);
2150 	}
2151 
2152 	/**
2153 	 * Returns the latest cap
2154 	 */
2155 	function _calculateLatestCap(uint256 _holdersPrice)
2156 		private
2157 		view
2158 		returns (uint256)
2159 	{
2160 		uint256 cCap = getStorageCumulativeHoldersRewardCap();
2161 		uint256 lastHoldersPrice = getStorageLastCumulativeHoldersPriceCap();
2162 		uint256 additionalCap = _holdersPrice.sub(lastHoldersPrice).mul(
2163 			getStorageCap()
2164 		);
2165 		return cCap.add(additionalCap);
2166 	}
2167 
2168 	/**
2169 	 * Store staking states as a snapshot.
2170 	 */
2171 	function beforeStakesChanged(address _property, RewardPrices memory _prices)
2172 		private
2173 	{
2174 		/**
2175 		 * Gets latest cumulative holders reward for the passed Property.
2176 		 */
2177 		uint256 cHoldersReward = _calculateCumulativeHoldersRewardAmount(
2178 			_prices.holders,
2179 			_property
2180 		);
2181 
2182 		/**
2183 		 * Sets `InitialCumulativeHoldersRewardCap`.
2184 		 * Records this value only when the "first staking to the passed Property" is transacted.
2185 		 */
2186 		if (
2187 			getStorageLastCumulativeHoldersRewardPricePerProperty(_property) ==
2188 			0 &&
2189 			getStorageInitialCumulativeHoldersRewardCap(_property) == 0 &&
2190 			getStoragePropertyValue(_property) == 0
2191 		) {
2192 			setStorageInitialCumulativeHoldersRewardCap(
2193 				_property,
2194 				_prices.holdersCap
2195 			);
2196 		}
2197 
2198 		/**
2199 		 * Store each value.
2200 		 */
2201 		setStorageLastStakesChangedCumulativeReward(_prices.reward);
2202 		setStorageLastCumulativeHoldersRewardPrice(_prices.holders);
2203 		setStorageLastCumulativeInterestPrice(_prices.interest);
2204 		setStorageLastCumulativeHoldersRewardAmountPerProperty(
2205 			_property,
2206 			cHoldersReward
2207 		);
2208 		setStorageLastCumulativeHoldersRewardPricePerProperty(
2209 			_property,
2210 			_prices.holders
2211 		);
2212 		setStorageCumulativeHoldersRewardCap(_prices.holdersCap);
2213 		setStorageLastCumulativeHoldersPriceCap(_prices.holders);
2214 	}
2215 
2216 	/**
2217 	 * Gets latest value of cumulative sum of the reward amount, cumulative sum of the holders reward per stake, and cumulative sum of the stakers reward per stake.
2218 	 */
2219 	function calculateCumulativeRewardPrices()
2220 		public
2221 		view
2222 		returns (
2223 			uint256 _reward,
2224 			uint256 _holders,
2225 			uint256 _interest,
2226 			uint256 _holdersCap
2227 		)
2228 	{
2229 		uint256 lastReward = getStorageLastStakesChangedCumulativeReward();
2230 		uint256 lastHoldersPrice = getStorageLastCumulativeHoldersRewardPrice();
2231 		uint256 lastInterestPrice = getStorageLastCumulativeInterestPrice();
2232 		uint256 allStakes = getStorageAllValue();
2233 
2234 		/**
2235 		 * Gets latest cumulative sum of the reward amount.
2236 		 */
2237 		(uint256 reward, ) = dry();
2238 		uint256 mReward = reward.mulBasis();
2239 
2240 		/**
2241 		 * Calculates reward unit price per staking.
2242 		 * Later, the last cumulative sum of the reward amount is subtracted because to add the last recorded holder/staking reward.
2243 		 */
2244 		uint256 price = allStakes > 0
2245 			? mReward.sub(lastReward).div(allStakes)
2246 			: 0;
2247 
2248 		/**
2249 		 * Calculates the holders reward out of the total reward amount.
2250 		 */
2251 		uint256 holdersShare = IPolicy(config().policy()).holdersShare(
2252 			price,
2253 			allStakes
2254 		);
2255 
2256 		/**
2257 		 * Calculates and returns each reward.
2258 		 */
2259 		uint256 holdersPrice = holdersShare.add(lastHoldersPrice);
2260 		uint256 interestPrice = price.sub(holdersShare).add(lastInterestPrice);
2261 		uint256 cCap = _calculateLatestCap(holdersPrice);
2262 		return (mReward, holdersPrice, interestPrice, cCap);
2263 	}
2264 
2265 	/**
2266 	 * Calculates cumulative sum of the holders reward per Property.
2267 	 * To save computing resources, it receives the latest holder rewards from a caller.
2268 	 */
2269 	function _calculateCumulativeHoldersRewardAmount(
2270 		uint256 _holdersPrice,
2271 		address _property
2272 	) private view returns (uint256) {
2273 		(uint256 cHoldersReward, uint256 lastReward) = (
2274 			getStorageLastCumulativeHoldersRewardAmountPerProperty(_property),
2275 			getStorageLastCumulativeHoldersRewardPricePerProperty(_property)
2276 		);
2277 
2278 		/**
2279 		 * `cHoldersReward` contains the calculation of `lastReward`, so subtract it here.
2280 		 */
2281 		uint256 additionalHoldersReward = _holdersPrice.sub(lastReward).mul(
2282 			getStoragePropertyValue(_property)
2283 		);
2284 
2285 		/**
2286 		 * Calculates and returns the cumulative sum of the holder reward by adds the last recorded holder reward and the latest holder reward.
2287 		 */
2288 		return cHoldersReward.add(additionalHoldersReward);
2289 	}
2290 
2291 	/**
2292 	 * Calculates cumulative sum of the holders reward per Property.
2293 	 * caution!!!this function is deprecated!!!
2294 	 * use calculateRewardAmount
2295 	 */
2296 	function calculateCumulativeHoldersRewardAmount(address _property)
2297 		external
2298 		view
2299 		returns (uint256)
2300 	{
2301 		(, uint256 holders, , ) = calculateCumulativeRewardPrices();
2302 		return _calculateCumulativeHoldersRewardAmount(holders, _property);
2303 	}
2304 
2305 	/**
2306 	 * Calculates holders reward and cap per Property.
2307 	 */
2308 	function calculateRewardAmount(address _property)
2309 		external
2310 		view
2311 		returns (uint256, uint256)
2312 	{
2313 		(
2314 			,
2315 			uint256 holders,
2316 			,
2317 			uint256 holdersCap
2318 		) = calculateCumulativeRewardPrices();
2319 		uint256 initialCap = _getInitialCap(_property);
2320 
2321 		/**
2322 		 * Calculates the cap
2323 		 */
2324 		uint256 capValue = holdersCap.sub(initialCap);
2325 		return (
2326 			_calculateCumulativeHoldersRewardAmount(holders, _property),
2327 			capValue
2328 		);
2329 	}
2330 
2331 	function _getInitialCap(address _property) private view returns (uint256) {
2332 		uint256 initialCap = getStorageInitialCumulativeHoldersRewardCap(
2333 			_property
2334 		);
2335 		if (initialCap > 0) {
2336 			return initialCap;
2337 		}
2338 
2339 		// Fallback when there is a data past staked.
2340 		if (
2341 			getStorageLastCumulativeHoldersRewardPricePerProperty(_property) >
2342 			0 ||
2343 			getStoragePropertyValue(_property) > 0
2344 		) {
2345 			return getStorageFallbackInitialCumulativeHoldersRewardCap();
2346 		}
2347 		return 0;
2348 	}
2349 
2350 	/**
2351 	 * Updates cumulative sum of the maximum mint amount calculated by Allocator contract, the latest maximum mint amount per block,
2352 	 * and the last recorded block number.
2353 	 * The cumulative sum of the maximum mint amount is always added.
2354 	 * By recording that value when the staker last stakes, the difference from the when the staker stakes can be calculated.
2355 	 */
2356 	function update() public {
2357 		/**
2358 		 * Gets the cumulative sum of the maximum mint amount and the maximum mint number per block.
2359 		 */
2360 		(uint256 _nextRewards, uint256 _amount) = dry();
2361 
2362 		/**
2363 		 * Records each value and the latest block number.
2364 		 */
2365 		setStorageCumulativeGlobalRewards(_nextRewards);
2366 		setStorageLastSameRewardsAmountAndBlock(_amount, block.number);
2367 	}
2368 
2369 	/**
2370 	 * Referring to the values recorded in each storage to returns the latest cumulative sum of the maximum mint amount and the latest maximum mint amount per block.
2371 	 */
2372 	function dry()
2373 		private
2374 		view
2375 		returns (uint256 _nextRewards, uint256 _amount)
2376 	{
2377 		/**
2378 		 * Gets the latest mint amount per block from Allocator contract.
2379 		 */
2380 		uint256 rewardsAmount = IAllocator(config().allocator())
2381 			.calculateMaxRewardsPerBlock();
2382 
2383 		/**
2384 		 * Gets the maximum mint amount per block, and the last recorded block number from `LastSameRewardsAmountAndBlock` storage.
2385 		 */
2386 		(
2387 			uint256 lastAmount,
2388 			uint256 lastBlock
2389 		) = getStorageLastSameRewardsAmountAndBlock();
2390 
2391 		/**
2392 		 * If the recorded maximum mint amount per block and the result of the Allocator contract are different,
2393 		 * the result of the Allocator contract takes precedence as a maximum mint amount per block.
2394 		 */
2395 		uint256 lastMaxRewards = lastAmount == rewardsAmount
2396 			? rewardsAmount
2397 			: lastAmount;
2398 
2399 		/**
2400 		 * Calculates the difference between the latest block number and the last recorded block number.
2401 		 */
2402 		uint256 blocks = lastBlock > 0 ? block.number.sub(lastBlock) : 0;
2403 
2404 		/**
2405 		 * Adds the calculated new cumulative maximum mint amount to the recorded cumulative maximum mint amount.
2406 		 */
2407 		uint256 additionalRewards = lastMaxRewards.mul(blocks);
2408 		uint256 nextRewards = getStorageCumulativeGlobalRewards().add(
2409 			additionalRewards
2410 		);
2411 
2412 		/**
2413 		 * Returns the latest theoretical cumulative sum of maximum mint amount and maximum mint amount per block.
2414 		 */
2415 		return (nextRewards, rewardsAmount);
2416 	}
2417 
2418 	/**
2419 	 * Returns the staker reward as interest.
2420 	 */
2421 	function _calculateInterestAmount(uint256 _amount, uint256 _price)
2422 		private
2423 		view
2424 		returns (
2425 			uint256 amount_,
2426 			uint256 interestPrice_,
2427 			RewardPrices memory prices_
2428 		)
2429 	{
2430 		/**
2431 		 * Gets the latest cumulative sum of the interest price.
2432 		 */
2433 		(
2434 			uint256 reward,
2435 			uint256 holders,
2436 			uint256 interest,
2437 			uint256 holdersCap
2438 		) = calculateCumulativeRewardPrices();
2439 
2440 		/**
2441 		 * Calculates and returns the latest withdrawable reward amount from the difference.
2442 		 */
2443 		uint256 result = interest >= _price
2444 			? interest.sub(_price).mul(_amount).divBasis()
2445 			: 0;
2446 		return (
2447 			result,
2448 			interest,
2449 			RewardPrices(reward, holders, interest, holdersCap)
2450 		);
2451 	}
2452 
2453 	/**
2454 	 * Returns the staker reward as interest.
2455 	 */
2456 	function _calculateInterestAmount4Legacy(address _property, address _user)
2457 		private
2458 		view
2459 		returns (
2460 			uint256 _amount,
2461 			uint256 _interestPrice,
2462 			RewardPrices memory _prices
2463 		)
2464 	{
2465 		/**
2466 		 * Get the amount the user is staking for the Property.
2467 		 */
2468 		uint256 lockedUpPerAccount = getStorageValue(_property, _user);
2469 
2470 		/**
2471 		 * Gets the cumulative sum of the interest price recorded the last time you withdrew.
2472 		 */
2473 		uint256 lastInterest = getStorageLastStakedInterestPrice(
2474 			_property,
2475 			_user
2476 		);
2477 
2478 		/**
2479 		 * Gets the latest cumulative sum of the interest price.
2480 		 */
2481 		(
2482 			uint256 reward,
2483 			uint256 holders,
2484 			uint256 interest,
2485 			uint256 holdersCap
2486 		) = calculateCumulativeRewardPrices();
2487 
2488 		/**
2489 		 * Calculates and returns the latest withdrawable reward amount from the difference.
2490 		 */
2491 		uint256 result = interest >= lastInterest
2492 			? interest.sub(lastInterest).mul(lockedUpPerAccount).divBasis()
2493 			: 0;
2494 		return (
2495 			result,
2496 			interest,
2497 			RewardPrices(reward, holders, interest, holdersCap)
2498 		);
2499 	}
2500 
2501 	/**
2502 	 * Returns the total rewards currently available for withdrawal. (For calling from inside the contract)
2503 	 */
2504 	function _calculateWithdrawableInterestAmount(
2505 		address _property,
2506 		uint256 _amount,
2507 		uint256 _price,
2508 		uint256 _pendingReward
2509 	) private view returns (uint256 amount_, RewardPrices memory prices_) {
2510 		/**
2511 		 * If the passed Property has not authenticated, returns always 0.
2512 		 */
2513 		if (
2514 			IMetricsGroup(config().metricsGroup()).hasAssets(_property) == false
2515 		) {
2516 			return (0, RewardPrices(0, 0, 0, 0));
2517 		}
2518 
2519 		/**
2520 		 * Gets the latest withdrawal reward amount.
2521 		 */
2522 		(
2523 			uint256 amount,
2524 			,
2525 			RewardPrices memory prices
2526 		) = _calculateInterestAmount(_amount, _price);
2527 
2528 		/**
2529 		 * Returns the sum of all values.
2530 		 */
2531 		uint256 withdrawableAmount = amount.add(_pendingReward);
2532 		return (withdrawableAmount, prices);
2533 	}
2534 
2535 	/**
2536 	 * Returns the total rewards currently available for withdrawal. (For calling from inside the contract)
2537 	 */
2538 	function _calculateWithdrawableInterestAmount4Legacy(
2539 		address _property,
2540 		address _user
2541 	) private view returns (uint256 _amount, RewardPrices memory _prices) {
2542 		/**
2543 		 * If the passed Property has not authenticated, returns always 0.
2544 		 */
2545 		if (
2546 			IMetricsGroup(config().metricsGroup()).hasAssets(_property) == false
2547 		) {
2548 			return (0, RewardPrices(0, 0, 0, 0));
2549 		}
2550 
2551 		/**
2552 		 * Gets the reward amount in saved without withdrawal.
2553 		 */
2554 		uint256 pending = getStoragePendingInterestWithdrawal(_property, _user);
2555 
2556 		/**
2557 		 * Gets the reward amount of before DIP4.
2558 		 */
2559 		uint256 legacy = __legacyWithdrawableInterestAmount(_property, _user);
2560 
2561 		/**
2562 		 * Gets the latest withdrawal reward amount.
2563 		 */
2564 		(
2565 			uint256 amount,
2566 			,
2567 			RewardPrices memory prices
2568 		) = _calculateInterestAmount4Legacy(_property, _user);
2569 
2570 		/**
2571 		 * Returns the sum of all values.
2572 		 */
2573 		uint256 withdrawableAmount = amount.add(pending).add(legacy);
2574 		return (withdrawableAmount, prices);
2575 	}
2576 
2577 	/**
2578 	 * Returns the total rewards currently available for withdrawal. (For calling from external of the contract)
2579 	 */
2580 	function calculateWithdrawableInterestAmount(
2581 		address _property,
2582 		address _user
2583 	) external view returns (uint256) {
2584 		(uint256 amount, ) = _calculateWithdrawableInterestAmount4Legacy(
2585 			_property,
2586 			_user
2587 		);
2588 		return amount;
2589 	}
2590 
2591 	/**
2592 	 * Returns the total rewards currently available for withdrawal. (For calling from external of the contract)
2593 	 */
2594 	function calculateWithdrawableInterestAmountByPosition(uint256 _tokenId)
2595 		external
2596 		view
2597 		returns (uint256)
2598 	{
2599 		ISTokensManager sTokenManagerInstance = ISTokensManager(sTokensManager);
2600 		(
2601 			address property,
2602 			uint256 amount,
2603 			uint256 price,
2604 			,
2605 			uint256 pendingReward
2606 		) = sTokenManagerInstance.positions(_tokenId);
2607 		(uint256 result, ) = _calculateWithdrawableInterestAmount(
2608 			property,
2609 			amount,
2610 			price,
2611 			pendingReward
2612 		);
2613 		return result;
2614 	}
2615 
2616 	/**
2617 	 * Withdraws staking reward as an interest.
2618 	 */
2619 	function _withdrawInterest(
2620 		address _property,
2621 		uint256 _amount,
2622 		uint256 _price,
2623 		uint256 _pendingReward
2624 	) private returns (uint256 value_, RewardPrices memory prices_) {
2625 		/**
2626 		 * Gets the withdrawable amount.
2627 		 */
2628 		(
2629 			uint256 value,
2630 			RewardPrices memory prices
2631 		) = _calculateWithdrawableInterestAmount(
2632 				_property,
2633 				_amount,
2634 				_price,
2635 				_pendingReward
2636 			);
2637 
2638 		/**
2639 		 * Mints the reward.
2640 		 */
2641 		require(
2642 			IDevMinter(devMinter).mint(msg.sender, value),
2643 			"dev mint failed"
2644 		);
2645 
2646 		/**
2647 		 * Since the total supply of tokens has changed, updates the latest maximum mint amount.
2648 		 */
2649 		update();
2650 
2651 		return (value, prices);
2652 	}
2653 
2654 	/**
2655 	 * Withdraws staking reward as an interest.
2656 	 */
2657 	function _withdrawInterest4Legacy(address _property)
2658 		private
2659 		returns (RewardPrices memory _prices)
2660 	{
2661 		/**
2662 		 * Gets the withdrawable amount.
2663 		 */
2664 		(
2665 			uint256 value,
2666 			RewardPrices memory prices
2667 		) = _calculateWithdrawableInterestAmount4Legacy(_property, msg.sender);
2668 
2669 		/**
2670 		 * Sets the unwithdrawn reward amount to 0.
2671 		 */
2672 		setStoragePendingInterestWithdrawal(_property, msg.sender, 0);
2673 
2674 		/**
2675 		 * Updates the staking status to avoid double rewards.
2676 		 */
2677 		setStorageLastStakedInterestPrice(
2678 			_property,
2679 			msg.sender,
2680 			prices.interest
2681 		);
2682 		__updateLegacyWithdrawableInterestAmount(_property, msg.sender);
2683 
2684 		/**
2685 		 * Mints the reward.
2686 		 */
2687 		require(
2688 			IDevMinter(devMinter).mint(msg.sender, value),
2689 			"dev mint failed"
2690 		);
2691 
2692 		/**
2693 		 * Since the total supply of tokens has changed, updates the latest maximum mint amount.
2694 		 */
2695 		update();
2696 
2697 		return prices;
2698 	}
2699 
2700 	/**
2701 	 * Status updates with the addition or release of staking.
2702 	 */
2703 	function updateValues4Legacy(
2704 		bool _addition,
2705 		address _account,
2706 		address _property,
2707 		uint256 _value,
2708 		RewardPrices memory _prices
2709 	) private {
2710 		/**
2711 		 * Updates the staking status to avoid double rewards.
2712 		 */
2713 		setStorageLastStakedInterestPrice(
2714 			_property,
2715 			_account,
2716 			_prices.interest
2717 		);
2718 		updateValues(_addition, _property, _value, _prices);
2719 		/**
2720 		 * Updates the staking value of property by user
2721 		 */
2722 		if (_addition) {
2723 			addValue(_property, _account, _value);
2724 		} else {
2725 			subValue(_property, _account, _value);
2726 		}
2727 	}
2728 
2729 	/**
2730 	 * Status updates with the addition or release of staking.
2731 	 */
2732 	function updateValues(
2733 		bool _addition,
2734 		address _property,
2735 		uint256 _value,
2736 		RewardPrices memory _prices
2737 	) private {
2738 		beforeStakesChanged(_property, _prices);
2739 		/**
2740 		 * If added staking:
2741 		 */
2742 		if (_addition) {
2743 			/**
2744 			 * Updates the current staking amount of the protocol total.
2745 			 */
2746 			addAllValue(_value);
2747 
2748 			/**
2749 			 * Updates the current staking amount of the Property.
2750 			 */
2751 			addPropertyValue(_property, _value);
2752 			/**
2753 			 * If released staking:
2754 			 */
2755 		} else {
2756 			/**
2757 			 * Updates the current staking amount of the protocol total.
2758 			 */
2759 			subAllValue(_value);
2760 
2761 			/**
2762 			 * Updates the current staking amount of the Property.
2763 			 */
2764 			subPropertyValue(_property, _value);
2765 		}
2766 
2767 		/**
2768 		 * Since each staking amount has changed, updates the latest maximum mint amount.
2769 		 */
2770 		update();
2771 	}
2772 
2773 	/**
2774 	 * Returns the staking amount of the protocol total.
2775 	 */
2776 	function getAllValue() external view returns (uint256) {
2777 		return getStorageAllValue();
2778 	}
2779 
2780 	/**
2781 	 * Adds the staking amount of the protocol total.
2782 	 */
2783 	function addAllValue(uint256 _value) private {
2784 		uint256 value = getStorageAllValue();
2785 		value = value.add(_value);
2786 		setStorageAllValue(value);
2787 	}
2788 
2789 	/**
2790 	 * Subtracts the staking amount of the protocol total.
2791 	 */
2792 	function subAllValue(uint256 _value) private {
2793 		uint256 value = getStorageAllValue();
2794 		value = value.sub(_value);
2795 		setStorageAllValue(value);
2796 	}
2797 
2798 	/**
2799 	 * Returns the user's staking amount in the Property.
2800 	 */
2801 	function getValue(address _property, address _sender)
2802 		external
2803 		view
2804 		returns (uint256)
2805 	{
2806 		return getStorageValue(_property, _sender);
2807 	}
2808 
2809 	/**
2810 	 * Adds the user's staking amount in the Property.
2811 	 */
2812 	function addValue(
2813 		address _property,
2814 		address _sender,
2815 		uint256 _value
2816 	) private {
2817 		uint256 value = getStorageValue(_property, _sender);
2818 		value = value.add(_value);
2819 		setStorageValue(_property, _sender, value);
2820 	}
2821 
2822 	/**
2823 	 * Subtracts the user's staking amount in the Property.
2824 	 */
2825 	function subValue(
2826 		address _property,
2827 		address _sender,
2828 		uint256 _value
2829 	) private {
2830 		uint256 value = getStorageValue(_property, _sender);
2831 		value = value.sub(_value);
2832 		setStorageValue(_property, _sender, value);
2833 	}
2834 
2835 	/**
2836 	 * Returns whether the user is staking in the Property.
2837 	 */
2838 	function hasValue(
2839 		address _property,
2840 		address _sender,
2841 		uint256 _amount
2842 	) private view returns (bool) {
2843 		uint256 value = getStorageValue(_property, _sender);
2844 		return value >= _amount;
2845 	}
2846 
2847 	/**
2848 	 * Returns the staking amount of the Property.
2849 	 */
2850 	function getPropertyValue(address _property)
2851 		external
2852 		view
2853 		returns (uint256)
2854 	{
2855 		return getStoragePropertyValue(_property);
2856 	}
2857 
2858 	/**
2859 	 * Adds the staking amount of the Property.
2860 	 */
2861 	function addPropertyValue(address _property, uint256 _value) private {
2862 		uint256 value = getStoragePropertyValue(_property);
2863 		value = value.add(_value);
2864 		setStoragePropertyValue(_property, value);
2865 	}
2866 
2867 	/**
2868 	 * Subtracts the staking amount of the Property.
2869 	 */
2870 	function subPropertyValue(address _property, uint256 _value) private {
2871 		uint256 value = getStoragePropertyValue(_property);
2872 		uint256 nextValue = value.sub(_value);
2873 		setStoragePropertyValue(_property, nextValue);
2874 	}
2875 
2876 	/**
2877 	 * Saves the latest reward amount as an undrawn amount.
2878 	 */
2879 	function updatePendingInterestWithdrawal(address _property, address _user)
2880 		private
2881 		returns (RewardPrices memory _prices)
2882 	{
2883 		/**
2884 		 * Gets the latest reward amount.
2885 		 */
2886 		(
2887 			uint256 withdrawableAmount,
2888 			RewardPrices memory prices
2889 		) = _calculateWithdrawableInterestAmount4Legacy(_property, _user);
2890 
2891 		/**
2892 		 * Saves the amount to `PendingInterestWithdrawal` storage.
2893 		 */
2894 		setStoragePendingInterestWithdrawal(
2895 			_property,
2896 			_user,
2897 			withdrawableAmount
2898 		);
2899 
2900 		/**
2901 		 * Updates the reward amount of before DIP4 to prevent further addition it.
2902 		 */
2903 		__updateLegacyWithdrawableInterestAmount(_property, _user);
2904 
2905 		return prices;
2906 	}
2907 
2908 	/**
2909 	 * Returns the reward amount of the calculation model before DIP4.
2910 	 * It can be calculated by subtracting "the last cumulative sum of reward unit price" from
2911 	 * "the current cumulative sum of reward unit price," and multiplying by the staking amount.
2912 	 */
2913 	function __legacyWithdrawableInterestAmount(
2914 		address _property,
2915 		address _user
2916 	) private view returns (uint256) {
2917 		uint256 _last = getStorageLastInterestPrice(_property, _user);
2918 		uint256 price = getStorageInterestPrice(_property);
2919 		uint256 priceGap = price.sub(_last);
2920 		uint256 lockedUpValue = getStorageValue(_property, _user);
2921 		uint256 value = priceGap.mul(lockedUpValue);
2922 		return value.divBasis();
2923 	}
2924 
2925 	/**
2926 	 * Updates and treats the reward of before DIP4 as already received.
2927 	 */
2928 	function __updateLegacyWithdrawableInterestAmount(
2929 		address _property,
2930 		address _user
2931 	) private {
2932 		uint256 interestPrice = getStorageInterestPrice(_property);
2933 		if (getStorageLastInterestPrice(_property, _user) != interestPrice) {
2934 			setStorageLastInterestPrice(_property, _user, interestPrice);
2935 		}
2936 	}
2937 
2938 	function ___setFallbackInitialCumulativeHoldersRewardCap(uint256 _value)
2939 		external
2940 		onlyOwner
2941 	{
2942 		setStorageFallbackInitialCumulativeHoldersRewardCap(_value);
2943 	}
2944 
2945 	/**
2946 	 * migration to nft
2947 	 */
2948 	function migrateToSTokens(address _property)
2949 		external
2950 		returns (uint256 tokenId_)
2951 	{
2952 		/**
2953 		 * Get the amount the user is staking for the Property.
2954 		 */
2955 		uint256 amount = getStorageValue(_property, msg.sender);
2956 		require(amount > 0, "not staked");
2957 		/**
2958 		 * Gets the cumulative sum of the interest price recorded the last time you withdrew.
2959 		 */
2960 		uint256 price = getStorageLastStakedInterestPrice(
2961 			_property,
2962 			msg.sender
2963 		);
2964 		/**
2965 		 * Gets the reward amount in saved without withdrawal.
2966 		 */
2967 		uint256 pending = getStoragePendingInterestWithdrawal(
2968 			_property,
2969 			msg.sender
2970 		);
2971 		/**
2972 		 * Sets the unwithdrawn reward amount to 0.
2973 		 */
2974 		setStoragePendingInterestWithdrawal(_property, msg.sender, 0);
2975 		/**
2976 		 * The amount of the user's investment in the property is set to zero.
2977 		 */
2978 		setStorageValue(_property, msg.sender, 0);
2979 		ISTokensManager sTokenManagerInstance = ISTokensManager(sTokensManager);
2980 		/**
2981 		 * mint nft
2982 		 */
2983 		uint256 tokenId = sTokenManagerInstance.mint(
2984 			msg.sender,
2985 			_property,
2986 			amount,
2987 			price
2988 		);
2989 		/**
2990 		 * update position information
2991 		 */
2992 		bool result = sTokenManagerInstance.update(
2993 			tokenId,
2994 			amount,
2995 			price,
2996 			0,
2997 			pending
2998 		);
2999 		require(result, "failed to update");
3000 		return tokenId;
3001 	}
3002 }