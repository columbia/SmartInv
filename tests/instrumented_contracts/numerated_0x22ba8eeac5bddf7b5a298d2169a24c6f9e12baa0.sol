1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: IERC20Upgradeable
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20Upgradeable {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount)
31         external
32         returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender)
42         external
43         view
44         returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(
72         address sender,
73         address recipient,
74         uint256 amount
75     ) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(
90         address indexed owner,
91         address indexed spender,
92         uint256 value
93     );
94 }
95 
96 // Part: IMerkleDistributor
97 
98 // Allows anyone to claim a token if they exist in a merkle root.
99 interface IMerkleDistributor {
100     // Returns true if the index has been marked claimed.
101     function isClaimed(uint256 index) external view returns (bool);
102 
103     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
104     function claim(
105         uint256 index,
106         address account,
107         uint256 amount,
108         bytes32[] calldata merkleProof
109     ) external;
110 
111     // This event is triggered whenever a call to #claim succeeds.
112     event Claimed(uint256 index, address account, uint256 amount);
113 }
114 
115 // Part: Initializable
116 
117 /**
118  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
119  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
120  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
121  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
122  *
123  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
124  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
125  *
126  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
127  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
128  */
129 abstract contract Initializable {
130     /**
131      * @dev Indicates that the contract has been initialized.
132      */
133     bool private _initialized;
134 
135     /**
136      * @dev Indicates that the contract is in the process of being initialized.
137      */
138     bool private _initializing;
139 
140     /**
141      * @dev Modifier to protect an initializer function from being invoked twice.
142      */
143     modifier initializer() {
144         require(
145             _initializing || _isConstructor() || !_initialized,
146             "Initializable: contract is already initialized"
147         );
148 
149         bool isTopLevelCall = !_initializing;
150         if (isTopLevelCall) {
151             _initializing = true;
152             _initialized = true;
153         }
154 
155         _;
156 
157         if (isTopLevelCall) {
158             _initializing = false;
159         }
160     }
161 
162     /// @dev Returns true if and only if the function is running in the constructor
163     function _isConstructor() private view returns (bool) {
164         // extcodesize checks the size of the code stored in an address, and
165         // address returns the current address. Since the code is still not
166         // deployed when running a constructor, any checks on its code size will
167         // yield zero, making it an effective way to detect if a contract is
168         // under construction or not.
169         address self = address(this);
170         uint256 cs;
171         // solhint-disable-next-line no-inline-assembly
172         assembly {
173             cs := extcodesize(self)
174         }
175         return cs == 0;
176     }
177 }
178 
179 // Part: MerkleProofUpgradeable
180 
181 /**
182  * @dev These functions deal with verification of Merkle trees (hash trees),
183  */
184 library MerkleProofUpgradeable {
185     /**
186      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
187      * defined by `root`. For this, a `proof` must be provided, containing
188      * sibling hashes on the branch from the leaf to the root of the tree. Each
189      * pair of leaves and each pair of pre-images are assumed to be sorted.
190      */
191     function verify(
192         bytes32[] memory proof,
193         bytes32 root,
194         bytes32 leaf
195     ) internal pure returns (bool) {
196         bytes32 computedHash = leaf;
197 
198         for (uint256 i = 0; i < proof.length; i++) {
199             bytes32 proofElement = proof[i];
200 
201             if (computedHash <= proofElement) {
202                 // Hash(current computed hash + current element of the proof)
203                 computedHash = keccak256(
204                     abi.encodePacked(computedHash, proofElement)
205                 );
206             } else {
207                 // Hash(current element of the proof + current computed hash)
208                 computedHash = keccak256(
209                     abi.encodePacked(proofElement, computedHash)
210                 );
211             }
212         }
213 
214         // Check if the computed hash (root) is equal to the provided root
215         return computedHash == root;
216     }
217 }
218 
219 // Part: SafeMathUpgradeable
220 
221 /**
222  * @dev Wrappers over Solidity's arithmetic operations with added overflow
223  * checks.
224  *
225  * Arithmetic operations in Solidity wrap on overflow. This can easily result
226  * in bugs, because programmers usually assume that an overflow raises an
227  * error, which is the standard behavior in high level programming languages.
228  * `SafeMath` restores this intuition by reverting the transaction when an
229  * operation overflows.
230  *
231  * Using this library instead of the unchecked operations eliminates an entire
232  * class of bugs, so it's recommended to use it always.
233  */
234 library SafeMathUpgradeable {
235     /**
236      * @dev Returns the addition of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `+` operator.
240      *
241      * Requirements:
242      *
243      * - Addition cannot overflow.
244      */
245     function add(uint256 a, uint256 b) internal pure returns (uint256) {
246         uint256 c = a + b;
247         require(c >= a, "SafeMath: addition overflow");
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, reverting on
254      * overflow (when the result is negative).
255      *
256      * Counterpart to Solidity's `-` operator.
257      *
258      * Requirements:
259      *
260      * - Subtraction cannot overflow.
261      */
262     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263         return sub(a, b, "SafeMath: subtraction overflow");
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * Counterpart to Solidity's `-` operator.
271      *
272      * Requirements:
273      *
274      * - Subtraction cannot overflow.
275      */
276     function sub(
277         uint256 a,
278         uint256 b,
279         string memory errorMessage
280     ) internal pure returns (uint256) {
281         require(b <= a, errorMessage);
282         uint256 c = a - b;
283 
284         return c;
285     }
286 
287     /**
288      * @dev Returns the multiplication of two unsigned integers, reverting on
289      * overflow.
290      *
291      * Counterpart to Solidity's `*` operator.
292      *
293      * Requirements:
294      *
295      * - Multiplication cannot overflow.
296      */
297     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
298         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
299         // benefit is lost if 'b' is also tested.
300         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
301         if (a == 0) {
302             return 0;
303         }
304 
305         uint256 c = a * b;
306         require(c / a == b, "SafeMath: multiplication overflow");
307 
308         return c;
309     }
310 
311     /**
312      * @dev Returns the integer division of two unsigned integers. Reverts on
313      * division by zero. The result is rounded towards zero.
314      *
315      * Counterpart to Solidity's `/` operator. Note: this function uses a
316      * `revert` opcode (which leaves remaining gas untouched) while Solidity
317      * uses an invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function div(uint256 a, uint256 b) internal pure returns (uint256) {
324         return div(a, b, "SafeMath: division by zero");
325     }
326 
327     /**
328      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
329      * division by zero. The result is rounded towards zero.
330      *
331      * Counterpart to Solidity's `/` operator. Note: this function uses a
332      * `revert` opcode (which leaves remaining gas untouched) while Solidity
333      * uses an invalid opcode to revert (consuming all remaining gas).
334      *
335      * Requirements:
336      *
337      * - The divisor cannot be zero.
338      */
339     function div(
340         uint256 a,
341         uint256 b,
342         string memory errorMessage
343     ) internal pure returns (uint256) {
344         require(b > 0, errorMessage);
345         uint256 c = a / b;
346         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
347 
348         return c;
349     }
350 
351     /**
352      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
353      * Reverts when dividing by zero.
354      *
355      * Counterpart to Solidity's `%` operator. This function uses a `revert`
356      * opcode (which leaves remaining gas untouched) while Solidity uses an
357      * invalid opcode to revert (consuming all remaining gas).
358      *
359      * Requirements:
360      *
361      * - The divisor cannot be zero.
362      */
363     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
364         return mod(a, b, "SafeMath: modulo by zero");
365     }
366 
367     /**
368      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
369      * Reverts with custom message when dividing by zero.
370      *
371      * Counterpart to Solidity's `%` operator. This function uses a `revert`
372      * opcode (which leaves remaining gas untouched) while Solidity uses an
373      * invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function mod(
380         uint256 a,
381         uint256 b,
382         string memory errorMessage
383     ) internal pure returns (uint256) {
384         require(b != 0, errorMessage);
385         return a % b;
386     }
387 }
388 
389 // Part: ContextUpgradeable
390 
391 /*
392  * @dev Provides information about the current execution context, including the
393  * sender of the transaction and its data. While these are generally available
394  * via msg.sender and msg.data, they should not be accessed in such a direct
395  * manner, since when dealing with GSN meta-transactions the account sending and
396  * paying for execution may not be the actual sender (as far as an application
397  * is concerned).
398  *
399  * This contract is only required for intermediate, library-like contracts.
400  */
401 abstract contract ContextUpgradeable is Initializable {
402     function __Context_init() internal initializer {
403         __Context_init_unchained();
404     }
405 
406     function __Context_init_unchained() internal initializer {}
407 
408     function _msgSender() internal virtual view returns (address payable) {
409         return msg.sender;
410     }
411 
412     function _msgData() internal virtual view returns (bytes memory) {
413         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
414         return msg.data;
415     }
416 
417     uint256[50] private __gap;
418 }
419 
420 // Part: MerkleDistributor
421 
422 contract MerkleDistributor is Initializable, IMerkleDistributor {
423     address public token;
424     bytes32 public merkleRoot;
425 
426     // This is a packed array of booleans.
427     mapping(uint256 => uint256) internal claimedBitMap;
428 
429     function __MerkleDistributor_init(address token_, bytes32 merkleRoot_)
430         public
431         initializer
432     {
433         token = token_;
434         merkleRoot = merkleRoot_;
435     }
436 
437     function isClaimed(uint256 index) public override view returns (bool) {
438         uint256 claimedWordIndex = index / 256;
439         uint256 claimedBitIndex = index % 256;
440         uint256 claimedWord = claimedBitMap[claimedWordIndex];
441         uint256 mask = (1 << claimedBitIndex);
442         return claimedWord & mask == mask;
443     }
444 
445     function _setClaimed(uint256 index) internal {
446         uint256 claimedWordIndex = index / 256;
447         uint256 claimedBitIndex = index % 256;
448         claimedBitMap[claimedWordIndex] =
449             claimedBitMap[claimedWordIndex] |
450             (1 << claimedBitIndex);
451     }
452 
453     function claim(
454         uint256 index,
455         address account,
456         uint256 amount,
457         bytes32[] calldata merkleProof
458     ) external virtual override {
459         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
460 
461         // Verify the merkle proof.
462         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
463         require(
464             MerkleProofUpgradeable.verify(merkleProof, merkleRoot, node),
465             "MerkleDistributor: Invalid proof."
466         );
467 
468         // Mark it claimed and send the token.
469         _setClaimed(index);
470         require(
471             IERC20Upgradeable(token).transfer(account, amount),
472             "MerkleDistributor: Transfer failed."
473         );
474 
475         emit Claimed(index, account, amount);
476     }
477 }
478 
479 // Part: OwnableUpgradeable
480 
481 /**
482  * @dev Contract module which provides a basic access control mechanism, where
483  * there is an account (an owner) that can be granted exclusive access to
484  * specific functions.
485  *
486  * By default, the owner account will be the one that deploys the contract. This
487  * can later be changed with {transferOwnership}.
488  *
489  * This module is used through inheritance. It will make available the modifier
490  * `onlyOwner`, which can be applied to your functions to restrict their use to
491  * the owner.
492  */
493 contract OwnableUpgradeable is Initializable, ContextUpgradeable {
494     address private _owner;
495 
496     event OwnershipTransferred(
497         address indexed previousOwner,
498         address indexed newOwner
499     );
500 
501     /**
502      * @dev Initializes the contract setting the deployer as the initial owner.
503      */
504     function __Ownable_init() internal initializer {
505         __Context_init_unchained();
506         __Ownable_init_unchained();
507     }
508 
509     function __Ownable_init_unchained() internal initializer {
510         address msgSender = _msgSender();
511         _owner = msgSender;
512         emit OwnershipTransferred(address(0), msgSender);
513     }
514 
515     /**
516      * @dev Returns the address of the current owner.
517      */
518     function owner() public view returns (address) {
519         return _owner;
520     }
521 
522     /**
523      * @dev Throws if called by any account other than the owner.
524      */
525     modifier onlyOwner() {
526         require(_owner == _msgSender(), "Ownable: caller is not the owner");
527         _;
528     }
529 
530     /**
531      * @dev Leaves the contract without owner. It will not be possible to call
532      * `onlyOwner` functions anymore. Can only be called by the current owner.
533      *
534      * NOTE: Renouncing ownership will leave the contract without an owner,
535      * thereby removing any functionality that is only available to the owner.
536      */
537     function renounceOwnership() public virtual onlyOwner {
538         emit OwnershipTransferred(_owner, address(0));
539         _owner = address(0);
540     }
541 
542     /**
543      * @dev Transfers ownership of the contract to a new account (`newOwner`).
544      * Can only be called by the current owner.
545      */
546     function transferOwnership(address newOwner) public virtual onlyOwner {
547         require(
548             newOwner != address(0),
549             "Ownable: new owner is the zero address"
550         );
551         emit OwnershipTransferred(_owner, newOwner);
552         _owner = newOwner;
553     }
554 
555     uint256[49] private __gap;
556 }
557 
558 // File: BadgerHunt.sol
559 
560 contract BadgerHunt is MerkleDistributor, OwnableUpgradeable {
561     using SafeMathUpgradeable for uint256;
562     uint256 public constant MAX_BPS = 10000;
563 
564     uint256 public claimsStart;
565     uint256 public gracePeriod;
566 
567     uint256 public epochDuration;
568     uint256 public rewardReductionPerEpoch;
569     uint256 public currentRewardRate;
570     uint256 public finalEpoch;
571 
572     address public rewardsEscrow;
573 
574     event Hunt(
575         uint256 index,
576         address indexed account,
577         uint256 amount,
578         uint256 userClaim,
579         uint256 rewardsEscrowClaim
580     );
581 
582     function initialize(
583         address token_,
584         bytes32 merkleRoot_,
585         uint256 epochDuration_,
586         uint256 rewardReductionPerEpoch_,
587         uint256 claimsStart_,
588         uint256 gracePeriod_,
589         address rewardsEscrow_,
590         address owner_
591     ) public initializer {
592         __MerkleDistributor_init(token_, merkleRoot_);
593 
594         __Ownable_init();
595         transferOwnership(owner_);
596 
597         epochDuration = epochDuration_;
598         rewardReductionPerEpoch = rewardReductionPerEpoch_;
599         claimsStart = claimsStart_;
600         gracePeriod = gracePeriod_;
601 
602         rewardsEscrow = rewardsEscrow_;
603 
604         currentRewardRate = 10000;
605 
606         finalEpoch = (currentRewardRate / rewardReductionPerEpoch_) - 1;
607     }
608 
609     /// ===== View Functions =====
610     /// @dev Get grace period end timestamp
611     function getGracePeriodEnd() public view returns (uint256) {
612         return claimsStart.add(gracePeriod);
613     }
614 
615     /// @dev Get claims start timestamp
616     function getClaimsStartTime() public view returns (uint256) {
617         return claimsStart;
618     }
619 
620     /// @dev Get the next epoch start
621     function getNextEpochStart() public view returns (uint256) {
622         uint256 epoch = getCurrentEpoch();
623 
624         if (epoch == 0) {
625             return getGracePeriodEnd();
626         } else {
627             return getGracePeriodEnd().add(epochDuration.mul(epoch));
628         }
629     }
630 
631     function getTimeUntilNextEpoch() public view returns (uint256) {
632         uint256 epoch = getCurrentEpoch();
633 
634         if (epoch == 0) {
635             return getGracePeriodEnd().sub(now);
636         } else {
637             return (getGracePeriodEnd().add(epochDuration.mul(epoch))).sub(now);
638         }
639     }
640 
641     /// @dev Get the current epoch number
642     function getCurrentEpoch() public view returns (uint256) {
643         uint256 gracePeriodEnd = claimsStart.add(gracePeriod);
644 
645         if (now < gracePeriodEnd) {
646             return 0;
647         }
648         uint256 secondsPastGracePeriod = now.sub(gracePeriodEnd);
649         return (secondsPastGracePeriod / epochDuration).add(1);
650     }
651 
652     /// @dev Get the rewards % of current epoch
653     function getCurrentRewardsRate() public view returns (uint256) {
654         uint256 epoch = getCurrentEpoch();
655         if (epoch == 0) return MAX_BPS;
656         if (epoch > finalEpoch) return 0;
657         else return MAX_BPS.sub(epoch.mul(rewardReductionPerEpoch));
658     }
659 
660     /// @dev Get the rewards % of following epoch
661     function getNextEpochRewardsRate() public view returns (uint256) {
662         uint256 epoch = getCurrentEpoch().add(1);
663         if (epoch == 0) return MAX_BPS;
664         if (epoch > finalEpoch) return 0;
665         else return MAX_BPS.sub(epoch.mul(rewardReductionPerEpoch));
666     }
667 
668     /// ===== Public Actions =====
669 
670     function claim(
671         uint256 index,
672         address account,
673         uint256 amount,
674         bytes32[] calldata merkleProof
675     ) external virtual override {
676         require(now >= claimsStart, "BadgerDistributor: Before claim start.");
677         require(
678             account == msg.sender,
679             "BadgerDistributor: Can only claim for own account."
680         );
681         require(
682             getCurrentRewardsRate() > 0,
683             "BadgerDistributor: Past rewards claim period."
684         );
685         require(!isClaimed(index), "BadgerDistributor: Drop already claimed.");
686 
687         // Verify the merkle proof.
688         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
689         require(
690             MerkleProofUpgradeable.verify(merkleProof, merkleRoot, node),
691             "BadgerDistributor: Invalid proof."
692         );
693 
694         // Mark it claimed and send the token.
695         _setClaimed(index);
696 
697         require(getCurrentRewardsRate() <= MAX_BPS, "Excessive Rewards Rate");
698         uint256 claimable = amount.mul(getCurrentRewardsRate()).div(MAX_BPS);
699 
700         require(
701             IERC20Upgradeable(token).transfer(account, claimable),
702             "Transfer to user failed."
703         );
704         emit Hunt(index, account, amount, claimable, amount.sub(claimable));
705     }
706 
707     /// ===== Gated Actions: Owner =====
708 
709     /// @notice After hunt is complete, transfer excess funds to rewardsEscrow
710     function recycleExcess() external onlyOwner {
711         require(
712             getCurrentRewardsRate() == 0 && getCurrentEpoch() > finalEpoch,
713             "Hunt period not finished"
714         );
715         uint256 remainingBalance = IERC20Upgradeable(token).balanceOf(
716             address(this)
717         );
718         IERC20Upgradeable(token).transfer(rewardsEscrow, remainingBalance);
719     }
720 
721     function setGracePeriod(uint256 duration) external onlyOwner {
722         gracePeriod = duration;
723     }
724 }
