1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity >=0.6.12 <0.7.0;
3 
4 /**
5  * @dev This is a base contract to aid in writing upgradeable contracts, or any kind of contract that will be deployed
6  * behind a proxy. Since a proxied contract can't have a constructor, it's common to move constructor logic to an
7  * external initializer function, usually called `initialize`. It then becomes necessary to protect this initializer
8  * function so it can only be called once. The {initializer} modifier provided by this contract will have this effect.
9  * 
10  * TIP: To avoid leaving the proxy in an uninitialized state, the initializer function should be called as early as
11  * possible by providing the encoded function call as the `_data` argument to {UpgradeableProxy-constructor}.
12  * 
13  * CAUTION: When used with inheritance, manual care must be taken to not invoke a parent initializer twice, or to ensure
14  * that all initializers are idempotent. This is not verified automatically as constructors are by Solidity.
15  */
16 abstract contract Initializable {
17 
18     /**
19      * @dev Indicates that the contract has been initialized.
20      */
21     bool private _initialized;
22 
23     /**
24      * @dev Indicates that the contract is in the process of being initialized.
25      */
26     bool private _initializing;
27 
28     /**
29      * @dev Modifier to protect an initializer function from being invoked twice.
30      */
31     modifier initializer() {
32         require(_initializing || _isConstructor() || !_initialized, "Initializable: contract is already initialized");
33 
34         bool isTopLevelCall = !_initializing;
35         if (isTopLevelCall) {
36             _initializing = true;
37             _initialized = true;
38         }
39 
40         _;
41 
42         if (isTopLevelCall) {
43             _initializing = false;
44         }
45     }
46 
47     /// @dev Returns true if and only if the function is running in the constructor
48     function _isConstructor() private view returns (bool) {
49         // extcodesize checks the size of the code stored in an address, and
50         // address returns the current address. Since the code is still not
51         // deployed when running a constructor, any checks on its code size will
52         // yield zero, making it an effective way to detect if a contract is
53         // under construction or not.
54         address self = address(this);
55         uint256 cs;
56         // solhint-disable-next-line no-inline-assembly
57         assembly { cs := extcodesize(self) }
58         return cs == 0;
59     }
60 }
61 
62 /*
63  * @dev Provides information about the current execution context, including the
64  * sender of the transaction and its data. While these are generally available
65  * via msg.sender and msg.data, they should not be accessed in such a direct
66  * manner, since when dealing with GSN meta-transactions the account sending and
67  * paying for execution may not be the actual sender (as far as an application
68  * is concerned).
69  *
70  * This contract is only required for intermediate, library-like contracts.
71  */
72 abstract contract ContextUpgradeable is Initializable {
73     function __Context_init() internal initializer {
74         __Context_init_unchained();
75     }
76 
77     function __Context_init_unchained() internal initializer {
78     }
79     function _msgSender() internal view virtual returns (address payable) {
80         return msg.sender;
81     }
82 
83     function _msgData() internal view virtual returns (bytes memory) {
84         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
85         return msg.data;
86     }
87     uint256[50] private __gap;
88 }
89 
90 /**
91  * @dev Contract module which provides a basic access control mechanism, where
92  * there is an account (an owner) that can be granted exclusive access to
93  * specific functions.
94  *
95  * By default, the owner account will be the one that deploys the contract. This
96  * can later be changed with {transferOwnership}.
97  *
98  * This module is used through inheritance. It will make available the modifier
99  * `onlyOwner`, which can be applied to your functions to restrict their use to
100  * the owner.
101  */
102 contract OwnableUpgradeable is Initializable, ContextUpgradeable {
103     address private _owner;
104 
105     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
106 
107     /**
108      * @dev Initializes the contract setting the deployer as the initial owner.
109      */
110     function __Ownable_init() internal initializer {
111         __Context_init_unchained();
112         __Ownable_init_unchained();
113     }
114 
115     function __Ownable_init_unchained() internal initializer {
116         address msgSender = _msgSender();
117         _owner = msgSender;
118         emit OwnershipTransferred(address(0), msgSender);
119     }
120 
121     /**
122      * @dev Returns the address of the current owner.
123      */
124     function owner() public view returns (address) {
125         return _owner;
126     }
127 
128     /**
129      * @dev Throws if called by any account other than the owner.
130      */
131     modifier onlyOwner() {
132         require(_owner == _msgSender(), "Ownable: caller is not the owner");
133         _;
134     }
135 
136     /**
137      * @dev Leaves the contract without owner. It will not be possible to call
138      * `onlyOwner` functions anymore. Can only be called by the current owner.
139      *
140      * NOTE: Renouncing ownership will leave the contract without an owner,
141      * thereby removing any functionality that is only available to the owner.
142      */
143     function renounceOwnership() public virtual onlyOwner {
144         emit OwnershipTransferred(_owner, address(0));
145         _owner = address(0);
146     }
147 
148     /**
149      * @dev Transfers ownership of the contract to a new account (`newOwner`).
150      * Can only be called by the current owner.
151      */
152     function transferOwnership(address newOwner) public virtual onlyOwner {
153         require(newOwner != address(0), "Ownable: new owner is the zero address");
154         emit OwnershipTransferred(_owner, newOwner);
155         _owner = newOwner;
156     }
157     uint256[49] private __gap;
158 }
159 
160 /**
161  * @dev Wrappers over Solidity's arithmetic operations with added overflow
162  * checks.
163  *
164  * Arithmetic operations in Solidity wrap on overflow. This can easily result
165  * in bugs, because programmers usually assume that an overflow raises an
166  * error, which is the standard behavior in high level programming languages.
167  * `SafeMath` restores this intuition by reverting the transaction when an
168  * operation overflows.
169  *
170  * Using this library instead of the unchecked operations eliminates an entire
171  * class of bugs, so it's recommended to use it always.
172  */
173 library SafeMathUpgradeable {
174     /**
175      * @dev Returns the addition of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `+` operator.
179      *
180      * Requirements:
181      *
182      * - Addition cannot overflow.
183      */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         require(c >= a, "SafeMath: addition overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the subtraction of two unsigned integers, reverting on
193      * overflow (when the result is negative).
194      *
195      * Counterpart to Solidity's `-` operator.
196      *
197      * Requirements:
198      *
199      * - Subtraction cannot overflow.
200      */
201     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
202         return sub(a, b, "SafeMath: subtraction overflow");
203     }
204 
205     /**
206      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
207      * overflow (when the result is negative).
208      *
209      * Counterpart to Solidity's `-` operator.
210      *
211      * Requirements:
212      *
213      * - Subtraction cannot overflow.
214      */
215     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b <= a, errorMessage);
217         uint256 c = a - b;
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the multiplication of two unsigned integers, reverting on
224      * overflow.
225      *
226      * Counterpart to Solidity's `*` operator.
227      *
228      * Requirements:
229      *
230      * - Multiplication cannot overflow.
231      */
232     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
233         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
234         // benefit is lost if 'b' is also tested.
235         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
236         if (a == 0) {
237             return 0;
238         }
239 
240         uint256 c = a * b;
241         require(c / a == b, "SafeMath: multiplication overflow");
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the integer division of two unsigned integers. Reverts on
248      * division by zero. The result is rounded towards zero.
249      *
250      * Counterpart to Solidity's `/` operator. Note: this function uses a
251      * `revert` opcode (which leaves remaining gas untouched) while Solidity
252      * uses an invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function div(uint256 a, uint256 b) internal pure returns (uint256) {
259         return div(a, b, "SafeMath: division by zero");
260     }
261 
262     /**
263      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
264      * division by zero. The result is rounded towards zero.
265      *
266      * Counterpart to Solidity's `/` operator. Note: this function uses a
267      * `revert` opcode (which leaves remaining gas untouched) while Solidity
268      * uses an invalid opcode to revert (consuming all remaining gas).
269      *
270      * Requirements:
271      *
272      * - The divisor cannot be zero.
273      */
274     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
275         require(b > 0, errorMessage);
276         uint256 c = a / b;
277         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
278 
279         return c;
280     }
281 
282     /**
283      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
284      * Reverts when dividing by zero.
285      *
286      * Counterpart to Solidity's `%` operator. This function uses a `revert`
287      * opcode (which leaves remaining gas untouched) while Solidity uses an
288      * invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
295         return mod(a, b, "SafeMath: modulo by zero");
296     }
297 
298     /**
299      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
300      * Reverts with custom message when dividing by zero.
301      *
302      * Counterpart to Solidity's `%` operator. This function uses a `revert`
303      * opcode (which leaves remaining gas untouched) while Solidity uses an
304      * invalid opcode to revert (consuming all remaining gas).
305      *
306      * Requirements:
307      *
308      * - The divisor cannot be zero.
309      */
310     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
311         require(b != 0, errorMessage);
312         return a % b;
313     }
314 }
315 
316 /**
317  * @dev Interface of the ERC20 standard as defined in the EIP.
318  */
319 interface IERC20Upgradeable {
320     /**
321      * @dev Returns the amount of tokens in existence.
322      */
323     function totalSupply() external view returns (uint256);
324 
325     /**
326      * @dev Returns the amount of tokens owned by `account`.
327      */
328     function balanceOf(address account) external view returns (uint256);
329 
330     /**
331      * @dev Moves `amount` tokens from the caller's account to `recipient`.
332      *
333      * Returns a boolean value indicating whether the operation succeeded.
334      *
335      * Emits a {Transfer} event.
336      */
337     function transfer(address recipient, uint256 amount) external returns (bool);
338 
339     /**
340      * @dev Returns the remaining number of tokens that `spender` will be
341      * allowed to spend on behalf of `owner` through {transferFrom}. This is
342      * zero by default.
343      *
344      * This value changes when {approve} or {transferFrom} are called.
345      */
346     function allowance(address owner, address spender) external view returns (uint256);
347 
348     /**
349      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
350      *
351      * Returns a boolean value indicating whether the operation succeeded.
352      *
353      * IMPORTANT: Beware that changing an allowance with this method brings the risk
354      * that someone may use both the old and the new allowance by unfortunate
355      * transaction ordering. One possible solution to mitigate this race
356      * condition is to first reduce the spender's allowance to 0 and set the
357      * desired value afterwards:
358      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
359      *
360      * Emits an {Approval} event.
361      */
362     function approve(address spender, uint256 amount) external returns (bool);
363 
364     /**
365      * @dev Moves `amount` tokens from `sender` to `recipient` using the
366      * allowance mechanism. `amount` is then deducted from the caller's
367      * allowance.
368      *
369      * Returns a boolean value indicating whether the operation succeeded.
370      *
371      * Emits a {Transfer} event.
372      */
373     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Emitted when `value` tokens are moved from one account (`from`) to
377      * another (`to`).
378      *
379      * Note that `value` may be zero.
380      */
381     event Transfer(address indexed from, address indexed to, uint256 value);
382 
383     /**
384      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
385      * a call to {approve}. `value` is the new allowance.
386      */
387     event Approval(address indexed owner, address indexed spender, uint256 value);
388 }
389 
390 /**
391  * @dev These functions deal with verification of Merkle trees (hash trees),
392  */
393 library MerkleProofUpgradeable {
394     /**
395      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
396      * defined by `root`. For this, a `proof` must be provided, containing
397      * sibling hashes on the branch from the leaf to the root of the tree. Each
398      * pair of leaves and each pair of pre-images are assumed to be sorted.
399      */
400     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
401         bytes32 computedHash = leaf;
402 
403         for (uint256 i = 0; i < proof.length; i++) {
404             bytes32 proofElement = proof[i];
405 
406             if (computedHash <= proofElement) {
407                 // Hash(current computed hash + current element of the proof)
408                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
409             } else {
410                 // Hash(current element of the proof + current computed hash)
411                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
412             }
413         }
414 
415         // Check if the computed hash (root) is equal to the provided root
416         return computedHash == root;
417     }
418 }
419 
420 // Allows anyone to claim a token if they exist in a merkle root.
421 interface IMerkleDistributor {
422     // Returns true if the index has been marked claimed.
423     function isClaimed(uint256 index) external view returns (bool);
424     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
425     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
426 
427     // This event is triggered whenever a call to #claim succeeds.
428     event Claimed(uint256 index, address account, uint256 amount);
429 }
430 
431 contract MerkleDistributor is Initializable, IMerkleDistributor {
432     address public token;
433     bytes32 public merkleRoot;
434 
435     // This is a packed array of booleans.
436     mapping(uint256 => uint256) internal claimedBitMap;
437 
438     function __MerkleDistributor_init(address token_, bytes32 merkleRoot_) public initializer {
439         token = token_;
440         merkleRoot = merkleRoot_;
441     }
442 
443     function isClaimed(uint256 index) public override view returns (bool) {
444         uint256 claimedWordIndex = index / 256;
445         uint256 claimedBitIndex = index % 256;
446         uint256 claimedWord = claimedBitMap[claimedWordIndex];
447         uint256 mask = (1 << claimedBitIndex);
448         return claimedWord & mask == mask;
449     }
450 
451     function _setClaimed(uint256 index) internal {
452         uint256 claimedWordIndex = index / 256;
453         uint256 claimedBitIndex = index % 256;
454         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
455     }
456 
457     function claim(
458         uint256 index,
459         address account,
460         uint256 amount,
461         bytes32[] calldata merkleProof
462     ) external virtual override {
463         require(!isClaimed(index), "MerkleDistributor: Drop already claimed.");
464 
465         // Verify the merkle proof.
466         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
467         require(MerkleProofUpgradeable.verify(merkleProof, merkleRoot, node), "MerkleDistributor: Invalid proof.");
468 
469         // Mark it claimed and send the token.
470         _setClaimed(index);
471         require(IERC20Upgradeable(token).transfer(account, amount), "MerkleDistributor: Transfer failed.");
472 
473         emit Claimed(index, account, amount);
474     }
475 }
476 
477 contract TokenDistributor is MerkleDistributor, OwnableUpgradeable {
478     using SafeMathUpgradeable for uint256;
479     uint256 public constant MAX_BPS = 10000;
480 
481     uint256 public claimsStart;
482     uint256 public gracePeriod;
483 
484     uint256 public epochDuration;
485     uint256 public rewardReductionPerEpoch;
486     uint256 public currentRewardRate;
487     uint256 public finalEpoch;
488 
489     address public rewardsEscrow;
490 
491     event Claimed(uint256 index, address indexed account, uint256 amount, uint256 userClaim, uint256 rewardsEscrowClaim);
492 
493     function initialize(
494         address token_,
495         bytes32 merkleRoot_,
496         uint256 epochDuration_,
497         uint256 rewardReductionPerEpoch_,
498         uint256 claimsStart_,
499         uint256 gracePeriod_,
500         address rewardsEscrow_,
501         address owner_
502     ) public initializer {
503         __MerkleDistributor_init(token_, merkleRoot_);
504 
505         __Ownable_init();
506         transferOwnership(owner_);
507 
508         epochDuration = epochDuration_;
509         rewardReductionPerEpoch = rewardReductionPerEpoch_;
510         claimsStart = claimsStart_;
511         gracePeriod = gracePeriod_;
512 
513         rewardsEscrow = rewardsEscrow_;
514 
515         currentRewardRate = 10000;
516 
517         finalEpoch = (currentRewardRate / rewardReductionPerEpoch_) - 1;
518     }
519 
520     /// ===== View Functions =====
521     /// @dev Get grace period end timestamp
522     function getGracePeriodEnd() public view returns (uint256) {
523         return claimsStart.add(gracePeriod);
524     }
525 
526     /// @dev Get claims start timestamp
527     function getClaimsStartTime() public view returns (uint256) {
528         return claimsStart;
529     }
530 
531     /// @dev Get the next epoch start
532     function getNextEpochStart() public view returns (uint256) {
533         uint256 epoch = getCurrentEpoch();
534 
535         if (epoch == 0) {
536             return getGracePeriodEnd();
537         } else {
538             return getGracePeriodEnd().add(epochDuration.mul(epoch));
539         }
540     }
541 
542     function getTimeUntilNextEpoch() public view returns (uint256) {
543         uint256 epoch = getCurrentEpoch();
544 
545         if (epoch == 0) {
546             return getGracePeriodEnd().sub(now);
547         } else {
548             return (getGracePeriodEnd().add(epochDuration.mul(epoch))).sub(now);
549         }
550     }
551 
552     /// @dev Get the current epoch number
553     function getCurrentEpoch() public view returns (uint256) {
554         uint256 gracePeriodEnd = claimsStart.add(gracePeriod);
555 
556         if (now < gracePeriodEnd) {
557             return 0;
558         }
559         uint256 secondsPastGracePeriod = now.sub(gracePeriodEnd);
560         return (secondsPastGracePeriod / epochDuration).add(1);
561     }
562 
563     /// @dev Get the rewards % of current epoch
564     function getCurrentRewardsRate() public view returns (uint256) {
565         uint256 epoch = getCurrentEpoch();
566         if (epoch == 0) return MAX_BPS;
567         if (epoch > finalEpoch) return 0;
568         else return MAX_BPS.sub(epoch.mul(rewardReductionPerEpoch));
569     }
570 
571     /// @dev Get the rewards % of following epoch
572     function getNextEpochRewardsRate() public view returns (uint256) {
573         uint256 epoch = getCurrentEpoch().add(1);
574         if (epoch == 0) return MAX_BPS;
575         if (epoch > finalEpoch) return 0;
576         else return MAX_BPS.sub(epoch.mul(rewardReductionPerEpoch));
577     }
578 
579     /// ===== Public Actions =====
580 
581     function claim(
582         uint256 index,
583         address account,
584         uint256 amount,
585         bytes32[] calldata merkleProof
586     ) external virtual override {
587         require(now >= claimsStart, "TokenDistributor: Before claim start.");
588 
589         // Intentionally commented out so users can pay gas for others claims
590         // require(account == msg.sender, "TokenDistributor: Can only claim for own account.");
591         require(getCurrentRewardsRate() > 0, "TokenDistributor: Past rewards claim period.");
592         require(!isClaimed(index), "TokenDistributor: Drop already claimed.");
593 
594         // Verify the merkle proof.
595         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
596         require(MerkleProofUpgradeable.verify(merkleProof, merkleRoot, node), "TokenDistributor: Invalid proof.");
597 
598         // Mark it claimed and send the token.
599         _setClaimed(index);
600 
601         require(getCurrentRewardsRate() <= MAX_BPS, "Excessive Rewards Rate");
602         uint256 claimable = amount.mul(getCurrentRewardsRate()).div(MAX_BPS);
603 
604         require(IERC20Upgradeable(token).transfer(account, claimable), "Transfer to user failed.");
605         emit Claimed(index, account, amount, claimable, amount.sub(claimable));
606     }
607 
608     /// ===== Gated Actions: Owner =====
609 
610     /// @notice After claim period is complete, transfer excess funds to rewardsEscrow
611     function recycleExcess() external onlyOwner {
612         require(getCurrentRewardsRate() == 0 && getCurrentEpoch() > finalEpoch, "Claim period not finished");
613         uint256 remainingBalance = IERC20Upgradeable(token).balanceOf(address(this));
614         IERC20Upgradeable(token).transfer(rewardsEscrow, remainingBalance);
615     }
616 
617     function setGracePeriod(uint256 duration) external onlyOwner {
618         gracePeriod = duration;
619     }
620 }