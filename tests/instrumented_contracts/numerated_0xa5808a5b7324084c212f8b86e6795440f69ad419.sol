1 // SPDX-License-Identifier: AGPL-3.0-only
2 
3 pragma solidity ^0.6.0;
4 pragma experimental ABIEncoderV2;
5 
6 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/math/SafeMath.sol
82 
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `*` operator.
148      *
149      * Requirements:
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      * - The divisor cannot be zero.
176      */
177     function div(uint256 a, uint256 b) internal pure returns (uint256) {
178         return div(a, b, "SafeMath: division by zero");
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         // Solidity only automatically asserts when dividing by 0
194         require(b > 0, errorMessage);
195         uint256 c = a / b;
196         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
197 
198         return c;
199     }
200 
201     /**
202      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
203      * Reverts when dividing by zero.
204      *
205      * Counterpart to Solidity's `%` operator. This function uses a `revert`
206      * opcode (which leaves remaining gas untouched) while Solidity uses an
207      * invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b != 0, errorMessage);
229         return a % b;
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/Address.sol
234 
235 pragma solidity ^0.6.2;
236 
237 /**
238  * @dev Collection of functions related to the address type
239  */
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
260         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
261         // for accounts without code, i.e. `keccak256('')`
262         bytes32 codehash;
263         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { codehash := extcodehash(account) }
266         return (codehash != accountHash && codehash != 0x0);
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 }
293 
294 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
295 
296 
297 /**
298  * @title SafeERC20
299  * @dev Wrappers around ERC20 operations that throw on failure (when the token
300  * contract returns false). Tokens that return no value (and instead revert or
301  * throw on failure) are also supported, non-reverting calls are assumed to be
302  * successful.
303  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
304  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
305  */
306 library SafeERC20 {
307     using SafeMath for uint256;
308     using Address for address;
309 
310     function safeTransfer(IERC20 token, address to, uint256 value) internal {
311         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
312     }
313 
314     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
315         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
316     }
317 
318     function safeApprove(IERC20 token, address spender, uint256 value) internal {
319         // safeApprove should only be called when setting an initial allowance,
320         // or when resetting it to zero. To increase and decrease it, use
321         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
322         // solhint-disable-next-line max-line-length
323         require((value == 0) || (token.allowance(address(this), spender) == 0),
324             "SafeERC20: approve from non-zero to non-zero allowance"
325         );
326         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
327     }
328 
329     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
330         uint256 newAllowance = token.allowance(address(this), spender).add(value);
331         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
332     }
333 
334     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
335         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
336         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
337     }
338 
339     /**
340      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
341      * on the return value: the return value is optional (but if data is returned, it must not be false).
342      * @param token The token targeted by the call.
343      * @param data The call data (encoded using abi.encode or one of its variants).
344      */
345     function _callOptionalReturn(IERC20 token, bytes memory data) private {
346         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
347         // we're implementing it ourselves.
348 
349         // A Solidity high level call has three parts:
350         //  1. The target address is checked to verify it contains contract code
351         //  2. The call itself is made, and success asserted
352         //  3. The return value is decoded, which in turn checks the size of the returned data.
353         // solhint-disable-next-line max-line-length
354         require(address(token).isContract(), "SafeERC20: call to non-contract");
355 
356         // solhint-disable-next-line avoid-low-level-calls
357         (bool success, bytes memory returndata) = address(token).call(data);
358         require(success, "SafeERC20: low-level call failed");
359 
360         if (returndata.length > 0) { // Return data is optional
361             // solhint-disable-next-line max-line-length
362             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
363         }
364     }
365 }
366 
367 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
368 
369 
370 /**
371  * @dev These functions deal with verification of Merkle trees (hash trees),
372  */
373 library MerkleProof {
374     /**
375      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
376      * defined by `root`. For this, a `proof` must be provided, containing
377      * sibling hashes on the branch from the leaf to the root of the tree. Each
378      * pair of leaves and each pair of pre-images are assumed to be sorted.
379      */
380     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
381         bytes32 computedHash = leaf;
382 
383         for (uint256 i = 0; i < proof.length; i++) {
384             bytes32 proofElement = proof[i];
385 
386             if (computedHash <= proofElement) {
387                 // Hash(current computed hash + current element of the proof)
388                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
389             } else {
390                 // Hash(current element of the proof + current computed hash)
391                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
392             }
393         }
394 
395         // Check if the computed hash (root) is equal to the provided root
396         return computedHash == root;
397     }
398 }
399 
400 // File: @openzeppelin/contracts/GSN/Context.sol
401 
402 
403 /*
404  * @dev Provides information about the current execution context, including the
405  * sender of the transaction and its data. While these are generally available
406  * via msg.sender and msg.data, they should not be accessed in such a direct
407  * manner, since when dealing with GSN meta-transactions the account sending and
408  * paying for execution may not be the actual sender (as far as an application
409  * is concerned).
410  *
411  * This contract is only required for intermediate, library-like contracts.
412  */
413 contract Context {
414     // Empty internal constructor, to prevent people from mistakenly deploying
415     // an instance of this contract, which should be used via inheritance.
416     constructor () internal { }
417 
418     function _msgSender() internal view virtual returns (address payable) {
419         return msg.sender;
420     }
421 
422     function _msgData() internal view virtual returns (bytes memory) {
423         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
424         return msg.data;
425     }
426 }
427 
428 // File: @openzeppelin/contracts/access/Ownable.sol
429 
430 
431 /**
432  * @dev Contract module which provides a basic access control mechanism, where
433  * there is an account (an owner) that can be granted exclusive access to
434  * specific functions.
435  *
436  * By default, the owner account will be the one that deploys the contract. This
437  * can later be changed with {transferOwnership}.
438  *
439  * This module is used through inheritance. It will make available the modifier
440  * `onlyOwner`, which can be applied to your functions to restrict their use to
441  * the owner.
442  */
443 contract Ownable is Context {
444     address private _owner;
445 
446     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
447 
448     /**
449      * @dev Initializes the contract setting the deployer as the initial owner.
450      */
451     constructor () internal {
452         address msgSender = _msgSender();
453         _owner = msgSender;
454         emit OwnershipTransferred(address(0), msgSender);
455     }
456 
457     /**
458      * @dev Returns the address of the current owner.
459      */
460     function owner() public view returns (address) {
461         return _owner;
462     }
463 
464     /**
465      * @dev Throws if called by any account other than the owner.
466      */
467     modifier onlyOwner() {
468         require(_owner == _msgSender(), "Ownable: caller is not the owner");
469         _;
470     }
471 
472     /**
473      * @dev Leaves the contract without owner. It will not be possible to call
474      * `onlyOwner` functions anymore. Can only be called by the current owner.
475      *
476      * NOTE: Renouncing ownership will leave the contract without an owner,
477      * thereby removing any functionality that is only available to the owner.
478      */
479     function renounceOwnership() public virtual onlyOwner {
480         emit OwnershipTransferred(_owner, address(0));
481         _owner = address(0);
482     }
483 
484     /**
485      * @dev Transfers ownership of the contract to a new account (`newOwner`).
486      * Can only be called by the current owner.
487      */
488     function transferOwnership(address newOwner) public virtual onlyOwner {
489         require(newOwner != address(0), "Ownable: new owner is the zero address");
490         emit OwnershipTransferred(_owner, newOwner);
491         _owner = newOwner;
492     }
493 }
494 
495 // File: contracts/merkle-distributor/implementation/MerkleDistributor.sol
496 
497 
498 /**
499  * Inspired by:
500  * - https://github.com/pie-dao/vested-token-migration-app
501  * - https://github.com/Uniswap/merkle-distributor
502  * - https://github.com/balancer-labs/erc20-redeemable
503  *
504  * @title  MerkleDistributor contract.
505  * @notice Allows an owner to distribute any reward ERC20 to claimants according to Merkle roots. The owner can specify
506  *         multiple Merkle roots distributions with customized reward currencies.
507  * @dev    The Merkle trees are not validated in any way, so the system assumes the contract owner behaves honestly.
508  */
509 contract MerkleDistributor is Ownable {
510     using SafeMath for uint256;
511     using SafeERC20 for IERC20;
512 
513     // A Window maps a Merkle root to a reward token address.
514     struct Window {
515         // Merkle root describing the distribution.
516         bytes32 merkleRoot;
517         // Currency in which reward is processed.
518         IERC20 rewardToken;
519         // IPFS hash of the merkle tree. Can be used to independently fetch recipient proofs and tree. Note that the canonical
520         // data type for storing an IPFS hash is a multihash which is the concatenation of  <varint hash function code>
521         // <varint digest size in bytes><hash function output>. We opted to store this in a string type to make it easier
522         // for users to query the ipfs data without needing to reconstruct the multihash. to view the IPFS data simply
523         // go to https://cloudflare-ipfs.com/ipfs/<IPFS-HASH>.
524         string ipfsHash;
525     }
526 
527     // Represents an account's claim for `amount` within the Merkle root located at the `windowIndex`.
528     struct Claim {
529         uint256 windowIndex;
530         uint256 amount;
531         uint256 accountIndex; // Used only for bitmap. Assumed to be unique for each claim.
532         address account;
533         bytes32[] merkleProof;
534     }
535 
536     // Windows are mapped to arbitrary indices.
537     mapping(uint256 => Window) public merkleWindows;
538 
539     // Index of next created Merkle root.
540     uint256 public nextCreatedIndex;
541 
542     // Track which accounts have claimed for each window index.
543     // Note: uses a packed array of bools for gas optimization on tracking certain claims. Copied from Uniswap's contract.
544     mapping(uint256 => mapping(uint256 => uint256)) private claimedBitMap;
545 
546     /****************************************
547      *                EVENTS
548      ****************************************/
549     event Claimed(
550         address indexed caller,
551         uint256 windowIndex,
552         address indexed account,
553         uint256 accountIndex,
554         uint256 amount,
555         address indexed rewardToken
556     );
557     event CreatedWindow(
558         uint256 indexed windowIndex,
559         uint256 rewardsDeposited,
560         address indexed rewardToken,
561         address owner
562     );
563     event WithdrawRewards(address indexed owner, uint256 amount, address indexed currency);
564     event DeleteWindow(uint256 indexed windowIndex, address owner);
565 
566     /****************************
567      *      ADMIN FUNCTIONS
568      ****************************/
569 
570     /**
571      * @notice Set merkle root for the next available window index and seed allocations.
572      * @notice Callable only by owner of this contract. Caller must have approved this contract to transfer
573      *      `rewardsToDeposit` amount of `rewardToken` or this call will fail. Importantly, we assume that the
574      *      owner of this contract correctly chooses an amount `rewardsToDeposit` that is sufficient to cover all
575      *      claims within the `merkleRoot`. Otherwise, a race condition can be created. This situation can occur
576      *      because we do not segregate reward balances by window, for code simplicity purposes.
577      *      (If `rewardsToDeposit` is purposefully insufficient to payout all claims, then the admin must
578      *      subsequently transfer in rewards or the following situation can occur).
579      *      Example race situation:
580      *          - Window 1 Tree: Owner sets `rewardsToDeposit=100` and insert proofs that give claimant A 50 tokens and
581      *            claimant B 51 tokens. The owner has made an error by not setting the `rewardsToDeposit` correctly to 101.
582      *          - Window 2 Tree: Owner sets `rewardsToDeposit=1` and insert proofs that give claimant A 1 token. The owner
583      *            correctly set `rewardsToDeposit` this time.
584      *          - At this point contract owns 100 + 1 = 101 tokens. Now, imagine the following sequence:
585      *              (1) Claimant A claims 50 tokens for Window 1, contract now has 101 - 50 = 51 tokens.
586      *              (2) Claimant B claims 51 tokens for Window 1, contract now has 51 - 51 = 0 tokens.
587      *              (3) Claimant A tries to claim 1 token for Window 2 but fails because contract has 0 tokens.
588      *          - In summary, the contract owner created a race for step(2) and step(3) in which the first claim would
589      *            succeed and the second claim would fail, even though both claimants would expect their claims to succeed.
590      * @param rewardsToDeposit amount of rewards to deposit to seed this allocation.
591      * @param rewardToken ERC20 reward token.
592      * @param merkleRoot merkle root describing allocation.
593      * @param ipfsHash hash of IPFS object, conveniently stored for clients
594      */
595     function setWindow(
596         uint256 rewardsToDeposit,
597         address rewardToken,
598         bytes32 merkleRoot,
599         string memory ipfsHash
600     ) external onlyOwner {
601         uint256 indexToSet = nextCreatedIndex;
602         nextCreatedIndex = indexToSet.add(1);
603 
604         _setWindow(indexToSet, rewardsToDeposit, rewardToken, merkleRoot, ipfsHash);
605     }
606 
607     /**
608      * @notice Delete merkle root at window index.
609      * @dev Callable only by owner. Likely to be followed by a withdrawRewards call to clear contract state.
610      * @param windowIndex merkle root index to delete.
611      */
612     function deleteWindow(uint256 windowIndex) external onlyOwner {
613         delete merkleWindows[windowIndex];
614         emit DeleteWindow(windowIndex, msg.sender);
615     }
616 
617     /**
618      * @notice Emergency method that transfers rewards out of the contract if the contract was configured improperly.
619      * @dev Callable only by owner.
620      * @param rewardCurrency rewards to withdraw from contract.
621      * @param amount amount of rewards to withdraw.
622      */
623     function withdrawRewards(address rewardCurrency, uint256 amount) external onlyOwner {
624         IERC20(rewardCurrency).safeTransfer(msg.sender, amount);
625         emit WithdrawRewards(msg.sender, amount, rewardCurrency);
626     }
627 
628     /****************************
629      *    NON-ADMIN FUNCTIONS
630      ****************************/
631 
632     /**
633      * @notice Batch claims to reduce gas versus individual submitting all claims. Method will fail
634      *         if any individual claims within the batch would fail.
635      * @dev    Optimistically tries to batch together consecutive claims for the same account and same
636      *         reward token to reduce gas. Therefore, the most gas-cost-optimal way to use this method
637      *         is to pass in an array of claims sorted by account and reward currency.
638      * @param claims array of claims to claim.
639      */
640     function claimMulti(Claim[] memory claims) external {
641         uint256 batchedAmount = 0;
642         uint256 claimCount = claims.length;
643         for (uint256 i = 0; i < claimCount; i++) {
644             Claim memory _claim = claims[i];
645             _verifyAndMarkClaimed(_claim);
646             batchedAmount = batchedAmount.add(_claim.amount);
647 
648             // If the next claim is NOT the same account or the same token (or this claim is the last one),
649             // then disburse the `batchedAmount` to the current claim's account for the current claim's reward token.
650             uint256 nextI = i + 1;
651             address currentRewardToken = address(merkleWindows[_claim.windowIndex].rewardToken);
652             if (
653                 nextI == claimCount ||
654                 // This claim is last claim.
655                 claims[nextI].account != _claim.account ||
656                 // Next claim account is different than current one.
657                 address(merkleWindows[claims[nextI].windowIndex].rewardToken) != currentRewardToken
658                 // Next claim reward token is different than current one.
659             ) {
660                 IERC20(currentRewardToken).safeTransfer(_claim.account, batchedAmount);
661                 batchedAmount = 0;
662             }
663         }
664     }
665 
666     /**
667      * @notice Claim amount of reward tokens for account, as described by Claim input object.
668      * @dev    If the `_claim`'s `amount`, `accountIndex`, and `account` do not exactly match the
669      *         values stored in the merkle root for the `_claim`'s `windowIndex` this method
670      *         will revert.
671      * @param _claim claim object describing amount, accountIndex, account, window index, and merkle proof.
672      */
673     function claim(Claim memory _claim) public {
674         _verifyAndMarkClaimed(_claim);
675         merkleWindows[_claim.windowIndex].rewardToken.safeTransfer(_claim.account, _claim.amount);
676     }
677 
678     /**
679      * @notice Returns True if the claim for `accountIndex` has already been completed for the Merkle root at
680      *         `windowIndex`.
681      * @dev    This method will only work as intended if all `accountIndex`'s are unique for a given `windowIndex`.
682      *         The onus is on the Owner of this contract to submit only valid Merkle roots.
683      * @param windowIndex merkle root to check.
684      * @param accountIndex account index to check within window index.
685      * @return True if claim has been executed already, False otherwise.
686      */
687     function isClaimed(uint256 windowIndex, uint256 accountIndex) public view returns (bool) {
688         uint256 claimedWordIndex = accountIndex / 256;
689         uint256 claimedBitIndex = accountIndex % 256;
690         uint256 claimedWord = claimedBitMap[windowIndex][claimedWordIndex];
691         uint256 mask = (1 << claimedBitIndex);
692         return claimedWord & mask == mask;
693     }
694 
695     /**
696      * @notice Returns True if leaf described by {account, amount, accountIndex} is stored in Merkle root at given
697      *         window index.
698      * @param _claim claim object describing amount, accountIndex, account, window index, and merkle proof.
699      * @return valid True if leaf exists.
700      */
701     function verifyClaim(Claim memory _claim) public view returns (bool valid) {
702         bytes32 leaf = keccak256(abi.encodePacked(_claim.account, _claim.amount, _claim.accountIndex));
703         return MerkleProof.verify(_claim.merkleProof, merkleWindows[_claim.windowIndex].merkleRoot, leaf);
704     }
705 
706     /****************************
707      *     PRIVATE FUNCTIONS
708      ****************************/
709 
710     // Mark claim as completed for `accountIndex` for Merkle root at `windowIndex`.
711     function _setClaimed(uint256 windowIndex, uint256 accountIndex) private {
712         uint256 claimedWordIndex = accountIndex / 256;
713         uint256 claimedBitIndex = accountIndex % 256;
714         claimedBitMap[windowIndex][claimedWordIndex] =
715             claimedBitMap[windowIndex][claimedWordIndex] |
716             (1 << claimedBitIndex);
717     }
718 
719     // Store new Merkle root at `windowindex`. Pull `rewardsDeposited` from caller to seed distribution for this root.
720     function _setWindow(
721         uint256 windowIndex,
722         uint256 rewardsDeposited,
723         address rewardToken,
724         bytes32 merkleRoot,
725         string memory ipfsHash
726     ) private {
727         Window storage window = merkleWindows[windowIndex];
728         window.merkleRoot = merkleRoot;
729         window.rewardToken = IERC20(rewardToken);
730         window.ipfsHash = ipfsHash;
731 
732         emit CreatedWindow(windowIndex, rewardsDeposited, rewardToken, msg.sender);
733 
734         window.rewardToken.safeTransferFrom(msg.sender, address(this), rewardsDeposited);
735     }
736 
737     // Verify claim is valid and mark it as completed in this contract.
738     function _verifyAndMarkClaimed(Claim memory _claim) private {
739         // Check claimed proof against merkle window at given index.
740         require(verifyClaim(_claim), "Incorrect merkle proof");
741         // Check the account has not yet claimed for this window.
742         require(!isClaimed(_claim.windowIndex, _claim.accountIndex), "Account has already claimed for this window");
743 
744         // Proof is correct and claim has not occurred yet, mark claimed complete.
745         _setClaimed(_claim.windowIndex, _claim.accountIndex);
746         emit Claimed(
747             msg.sender,
748             _claim.windowIndex,
749             _claim.account,
750             _claim.accountIndex,
751             _claim.amount,
752             address(merkleWindows[_claim.windowIndex].rewardToken)
753         );
754     }
755 }