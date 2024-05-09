1 // Original code courtesy of mStable: https://github.com/mstable/merkle-drop
2 // Extended by dHEDGE DAO - https://www.dhedge.org
3 
4 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
5 
6 pragma solidity ^0.5.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle trees (hash trees),
10  */
11 library MerkleProof {
12     /**
13      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
14      * defined by `root`. For this, a `proof` must be provided, containing
15      * sibling hashes on the branch from the leaf to the root of the tree. Each
16      * pair of leaves and each pair of pre-images are assumed to be sorted.
17      */
18     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
19         bytes32 computedHash = leaf;
20 
21         for (uint256 i = 0; i < proof.length; i++) {
22             bytes32 proofElement = proof[i];
23 
24             if (computedHash <= proofElement) {
25                 // Hash(current computed hash + current element of the proof)
26                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
27             } else {
28                 // Hash(current element of the proof + current computed hash)
29                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
30             }
31         }
32 
33         // Check if the computed hash (root) is equal to the provided root
34         return computedHash == root;
35     }
36 }
37 
38 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
39 
40 pragma solidity ^0.5.0;
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
44  * the optional functions; to access them see {ERC20Detailed}.
45  */
46 interface IERC20 {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58      * @dev Moves `amount` tokens from the caller's account to `recipient`.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Returns the remaining number of tokens that `spender` will be
68      * allowed to spend on behalf of `owner` through {transferFrom}. This is
69      * zero by default.
70      *
71      * This value changes when {approve} or {transferFrom} are called.
72      */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 // File: @openzeppelin/contracts/math/SafeMath.sol
118 
119 pragma solidity ^0.5.0;
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `+` operator.
140      *
141      * Requirements:
142      * - Addition cannot overflow.
143      */
144     function add(uint256 a, uint256 b) internal pure returns (uint256) {
145         uint256 c = a + b;
146         require(c >= a, "SafeMath: addition overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      * - Subtraction cannot overflow.
172      *
173      * _Available since v2.4.0._
174      */
175     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b <= a, errorMessage);
177         uint256 c = a - b;
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the multiplication of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `*` operator.
187      *
188      * Requirements:
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193         // benefit is lost if 'b' is also tested.
194         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195         if (a == 0) {
196             return 0;
197         }
198 
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      * - The divisor cannot be zero.
230      *
231      * _Available since v2.4.0._
232      */
233     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         // Solidity only automatically asserts when dividing by 0
235         require(b > 0, errorMessage);
236         uint256 c = a / b;
237         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return mod(a, b, "SafeMath: modulo by zero");
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts with custom message when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      * - The divisor cannot be zero.
267      *
268      * _Available since v2.4.0._
269      */
270     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         require(b != 0, errorMessage);
272         return a % b;
273     }
274 }
275 
276 // File: @openzeppelin/contracts/utils/Address.sol
277 
278 pragma solidity ^0.5.5;
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following 
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
303         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
304         // for accounts without code, i.e. `keccak256('')`
305         bytes32 codehash;
306         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { codehash := extcodehash(account) }
309         return (codehash != accountHash && codehash != 0x0);
310     }
311 
312     /**
313      * @dev Converts an `address` into `address payable`. Note that this is
314      * simply a type cast: the actual underlying value is not changed.
315      *
316      * _Available since v2.4.0._
317      */
318     function toPayable(address account) internal pure returns (address payable) {
319         return address(uint160(account));
320     }
321 
322     /**
323      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
324      * `recipient`, forwarding all available gas and reverting on errors.
325      *
326      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
327      * of certain opcodes, possibly making contracts go over the 2300 gas limit
328      * imposed by `transfer`, making them unable to receive funds via
329      * `transfer`. {sendValue} removes this limitation.
330      *
331      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
332      *
333      * IMPORTANT: because control is transferred to `recipient`, care must be
334      * taken to not create reentrancy vulnerabilities. Consider using
335      * {ReentrancyGuard} or the
336      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
337      *
338      * _Available since v2.4.0._
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(address(this).balance >= amount, "Address: insufficient balance");
342 
343         // solhint-disable-next-line avoid-call-value
344         (bool success, ) = recipient.call.value(amount)("");
345         require(success, "Address: unable to send value, recipient may have reverted");
346     }
347 }
348 
349 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
350 
351 pragma solidity ^0.5.0;
352 
353 
354 
355 
356 /**
357  * @title SafeERC20
358  * @dev Wrappers around ERC20 operations that throw on failure (when the token
359  * contract returns false). Tokens that return no value (and instead revert or
360  * throw on failure) are also supported, non-reverting calls are assumed to be
361  * successful.
362  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
363  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
364  */
365 library SafeERC20 {
366     using SafeMath for uint256;
367     using Address for address;
368 
369     function safeTransfer(IERC20 token, address to, uint256 value) internal {
370         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
371     }
372 
373     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
374         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
375     }
376 
377     function safeApprove(IERC20 token, address spender, uint256 value) internal {
378         // safeApprove should only be called when setting an initial allowance,
379         // or when resetting it to zero. To increase and decrease it, use
380         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
381         // solhint-disable-next-line max-line-length
382         require((value == 0) || (token.allowance(address(this), spender) == 0),
383             "SafeERC20: approve from non-zero to non-zero allowance"
384         );
385         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
386     }
387 
388     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
389         uint256 newAllowance = token.allowance(address(this), spender).add(value);
390         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
391     }
392 
393     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
394         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
395         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
396     }
397 
398     /**
399      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
400      * on the return value: the return value is optional (but if data is returned, it must not be false).
401      * @param token The token targeted by the call.
402      * @param data The call data (encoded using abi.encode or one of its variants).
403      */
404     function callOptionalReturn(IERC20 token, bytes memory data) private {
405         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
406         // we're implementing it ourselves.
407 
408         // A Solidity high level call has three parts:
409         //  1. The target address is checked to verify it contains contract code
410         //  2. The call itself is made, and success asserted
411         //  3. The return value is decoded, which in turn checks the size of the returned data.
412         // solhint-disable-next-line max-line-length
413         require(address(token).isContract(), "SafeERC20: call to non-contract");
414 
415         // solhint-disable-next-line avoid-low-level-calls
416         (bool success, bytes memory returndata) = address(token).call(data);
417         require(success, "SafeERC20: low-level call failed");
418 
419         if (returndata.length > 0) { // Return data is optional
420             // solhint-disable-next-line max-line-length
421             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
422         }
423     }
424 }
425 
426 // File: @openzeppelin/contracts/GSN/Context.sol
427 
428 pragma solidity ^0.5.0;
429 
430 /*
431  * @dev Provides information about the current execution context, including the
432  * sender of the transaction and its data. While these are generally available
433  * via msg.sender and msg.data, they should not be accessed in such a direct
434  * manner, since when dealing with GSN meta-transactions the account sending and
435  * paying for execution may not be the actual sender (as far as an application
436  * is concerned).
437  *
438  * This contract is only required for intermediate, library-like contracts.
439  */
440 contract Context {
441     // Empty internal constructor, to prevent people from mistakenly deploying
442     // an instance of this contract, which should be used via inheritance.
443     constructor () internal { }
444     // solhint-disable-previous-line no-empty-blocks
445 
446     function _msgSender() internal view returns (address payable) {
447         return msg.sender;
448     }
449 
450     function _msgData() internal view returns (bytes memory) {
451         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
452         return msg.data;
453     }
454 }
455 
456 // File: @openzeppelin/contracts/ownership/Ownable.sol
457 
458 pragma solidity ^0.5.0;
459 
460 /**
461  * @dev Contract module which provides a basic access control mechanism, where
462  * there is an account (an owner) that can be granted exclusive access to
463  * specific functions.
464  *
465  * This module is used through inheritance. It will make available the modifier
466  * `onlyOwner`, which can be applied to your functions to restrict their use to
467  * the owner.
468  */
469 contract Ownable is Context {
470     address private _owner;
471 
472     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
473 
474     /**
475      * @dev Initializes the contract setting the deployer as the initial owner.
476      */
477     constructor () internal {
478         address msgSender = _msgSender();
479         _owner = msgSender;
480         emit OwnershipTransferred(address(0), msgSender);
481     }
482 
483     /**
484      * @dev Returns the address of the current owner.
485      */
486     function owner() public view returns (address) {
487         return _owner;
488     }
489 
490     /**
491      * @dev Throws if called by any account other than the owner.
492      */
493     modifier onlyOwner() {
494         require(isOwner(), "Ownable: caller is not the owner");
495         _;
496     }
497 
498     /**
499      * @dev Returns true if the caller is the current owner.
500      */
501     function isOwner() public view returns (bool) {
502         return _msgSender() == _owner;
503     }
504 
505     /**
506      * @dev Leaves the contract without owner. It will not be possible to call
507      * `onlyOwner` functions anymore. Can only be called by the current owner.
508      *
509      * NOTE: Renouncing ownership will leave the contract without an owner,
510      * thereby removing any functionality that is only available to the owner.
511      */
512     function renounceOwnership() public onlyOwner {
513         emit OwnershipTransferred(_owner, address(0));
514         _owner = address(0);
515     }
516 
517     /**
518      * @dev Transfers ownership of the contract to a new account (`newOwner`).
519      * Can only be called by the current owner.
520      */
521     function transferOwnership(address newOwner) public onlyOwner {
522         _transferOwnership(newOwner);
523     }
524 
525     /**
526      * @dev Transfers ownership of the contract to a new account (`newOwner`).
527      */
528     function _transferOwnership(address newOwner) internal {
529         require(newOwner != address(0), "Ownable: new owner is the zero address");
530         emit OwnershipTransferred(_owner, newOwner);
531         _owner = newOwner;
532     }
533 }
534 
535 // File: contracts/MerkleDrop.sol
536 
537 pragma solidity 0.5.16;
538 pragma experimental ABIEncoderV2;
539 
540 
541 
542 
543 
544 
545 contract MerkleDrop is Ownable {
546 
547     using SafeERC20 for IERC20;
548     using SafeMath for uint256;
549 
550     event Claimed(address claimant, uint256 week, uint256 balance);
551     event TrancheAdded(uint256 tranche, bytes32 merkleRoot, uint256 totalAmount);
552     event TrancheExpired(uint256 tranche);
553 
554     IERC20 public token;
555 
556     mapping(uint256 => bytes32) public merkleRoots;
557     mapping(uint256 => mapping(address => bool)) public claimed;
558     uint256 public tranches;
559 
560     constructor(
561         IERC20 _token
562     )
563         public
564     {
565         token = _token;
566     }
567 
568     /***************************************
569                     ADMIN
570     ****************************************/
571 
572     function seedNewAllocations(bytes32 _merkleRoot, uint256 _totalAllocation)
573         public
574         onlyOwner
575     returns (uint256 trancheId)
576     {
577         token.safeTransferFrom(msg.sender, address(this), _totalAllocation);
578 
579         trancheId = tranches;
580         merkleRoots[trancheId] = _merkleRoot;
581 
582         tranches = tranches.add(1);
583 
584         emit TrancheAdded(trancheId, _merkleRoot, _totalAllocation);
585     }
586 
587     function expireTranche(uint256 _trancheId)
588         public
589         onlyOwner
590     {
591         merkleRoots[_trancheId] = bytes32(0);
592 
593         emit TrancheExpired(_trancheId);
594     }
595 
596     function adminWithdraw(uint256 _amount)
597         public
598         onlyOwner
599     {
600         token.safeTransfer(msg.sender, _amount);
601     }
602 
603     /***************************************
604                   CLAIMING
605     ****************************************/
606 
607 
608     function claimWeek(
609         address _liquidityProvider,
610         uint256 _tranche,
611         uint256 _balance,
612         bytes32[] memory _merkleProof
613     )
614         public
615     {
616         _claimWeek(_liquidityProvider, _tranche, _balance, _merkleProof);
617         _disburse(_liquidityProvider, _balance);
618     }
619 
620 
621     function claimWeeks(
622         address _liquidityProvider,
623         uint256[] memory _tranches,
624         uint256[] memory _balances,
625         bytes32[][] memory _merkleProofs
626     )
627         public
628     {
629         uint256 len = _tranches.length;
630         require(len == _balances.length && len == _merkleProofs.length, "Mismatching inputs");
631 
632         uint256 totalBalance = 0;
633         for(uint256 i = 0; i < len; i++) {
634             _claimWeek(_liquidityProvider, _tranches[i], _balances[i], _merkleProofs[i]);
635             totalBalance = totalBalance.add(_balances[i]);
636         }
637         _disburse(_liquidityProvider, totalBalance);
638     }
639 
640 
641     function verifyClaim(
642         address _liquidityProvider,
643         uint256 _tranche,
644         uint256 _balance,
645         bytes32[] memory _merkleProof
646     )
647         public
648         view
649         returns (bool valid)
650     {
651         return _verifyClaim(_liquidityProvider, _tranche, _balance, _merkleProof);
652     }
653 
654 
655     /***************************************
656               CLAIMING - INTERNAL
657     ****************************************/
658 
659 
660     function _claimWeek(
661         address _liquidityProvider,
662         uint256 _tranche,
663         uint256 _balance,
664         bytes32[] memory _merkleProof
665     )
666         private
667     {
668         require(_tranche < tranches, "Week cannot be in the future");
669 
670         require(!claimed[_tranche][_liquidityProvider], "LP has already claimed");
671         require(_verifyClaim(_liquidityProvider, _tranche, _balance, _merkleProof), "Incorrect merkle proof");
672 
673         claimed[_tranche][_liquidityProvider] = true;
674 
675         emit Claimed(_liquidityProvider, _tranche, _balance);
676     }
677 
678 
679     function _verifyClaim(
680         address _liquidityProvider,
681         uint256 _tranche,
682         uint256 _balance,
683         bytes32[] memory _merkleProof
684     )
685         private
686         view
687         returns (bool valid)
688     {
689         bytes32 leaf = keccak256(abi.encodePacked(_liquidityProvider, _balance));
690         return MerkleProof.verify(_merkleProof, merkleRoots[_tranche], leaf);
691     }
692 
693 
694     function _disburse(address _liquidityProvider, uint256 _balance) private {
695         if (_balance > 0) {
696             token.safeTransfer(_liquidityProvider, _balance);
697         } else {
698             revert("No balance would be transferred - not going to waste your gas");
699         }
700     }
701 }