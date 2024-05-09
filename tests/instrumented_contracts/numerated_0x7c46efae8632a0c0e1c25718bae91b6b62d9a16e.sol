1 // File: @openzeppelin/contracts/cryptography/MerkleProof.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev These functions deal with verification of Merkle trees (hash trees),
9  */
10 library MerkleProof {
11     /**
12      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
13      * defined by `root`. For this, a `proof` must be provided, containing
14      * sibling hashes on the branch from the leaf to the root of the tree. Each
15      * pair of leaves and each pair of pre-images are assumed to be sorted.
16      */
17     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
18         bytes32 computedHash = leaf;
19 
20         for (uint256 i = 0; i < proof.length; i++) {
21             bytes32 proofElement = proof[i];
22 
23             if (computedHash <= proofElement) {
24                 // Hash(current computed hash + current element of the proof)
25                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
26             } else {
27                 // Hash(current element of the proof + current computed hash)
28                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
29             }
30         }
31 
32         // Check if the computed hash (root) is equal to the provided root
33         return computedHash == root;
34     }
35 }
36 
37 
38 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
39 
40 
41 pragma solidity ^0.6.0;
42 
43 /**
44  * @dev Contract module that helps prevent reentrant calls to a function.
45  *
46  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
47  * available, which can be applied to functions to make sure there are no nested
48  * (reentrant) calls to them.
49  *
50  * Note that because there is a single `nonReentrant` guard, functions marked as
51  * `nonReentrant` may not call one another. This can be worked around by making
52  * those functions `private`, and then adding `external` `nonReentrant` entry
53  * points to them.
54  *
55  * TIP: If you would like to learn more about reentrancy and alternative ways
56  * to protect against it, check out our blog post
57  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
58  */
59 contract ReentrancyGuard {
60     // Booleans are more expensive than uint256 or any type that takes up a full
61     // word because each write operation emits an extra SLOAD to first read the
62     // slot's contents, replace the bits taken up by the boolean, and then write
63     // back. This is the compiler's defense against contract upgrades and
64     // pointer aliasing, and it cannot be disabled.
65 
66     // The values being non-zero value makes deployment a bit more expensive,
67     // but in exchange the refund on every call to nonReentrant will be lower in
68     // amount. Since refunds are capped to a percentage of the total
69     // transaction's gas, it is best to keep them low in cases like this one, to
70     // increase the likelihood of the full refund coming into effect.
71     uint256 private constant _NOT_ENTERED = 1;
72     uint256 private constant _ENTERED = 2;
73 
74     uint256 private _status;
75 
76     constructor () internal {
77         _status = _NOT_ENTERED;
78     }
79 
80     /**
81      * @dev Prevents a contract from calling itself, directly or indirectly.
82      * Calling a `nonReentrant` function from another `nonReentrant`
83      * function is not supported. It is possible to prevent this from happening
84      * by making the `nonReentrant` function external, and make it call a
85      * `private` function that does the actual work.
86      */
87     modifier nonReentrant() {
88         // On the first call to nonReentrant, _notEntered will be true
89         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
90 
91         // Any calls to nonReentrant after this point will fail
92         _status = _ENTERED;
93 
94         _;
95 
96         // By storing the original value once again, a refund is triggered (see
97         // https://eips.ethereum.org/EIPS/eip-2200)
98         _status = _NOT_ENTERED;
99     }
100 }
101 
102 
103 // File: @openzeppelin/contracts/utils/Address.sol
104 
105 
106 pragma solidity ^0.6.2;
107 
108 /**
109  * @dev Collection of functions related to the address type
110  */
111 library Address {
112     /**
113      * @dev Returns true if `account` is a contract.
114      *
115      * [IMPORTANT]
116      * ====
117      * It is unsafe to assume that an address for which this function returns
118      * false is an externally-owned account (EOA) and not a contract.
119      *
120      * Among others, `isContract` will return false for the following
121      * types of addresses:
122      *
123      *  - an externally-owned account
124      *  - a contract in construction
125      *  - an address where a contract will be created
126      *  - an address where a contract lived, but was destroyed
127      * ====
128      */
129     function isContract(address account) internal view returns (bool) {
130         // This method relies in extcodesize, which returns 0 for contracts in
131         // construction, since the code is only stored at the end of the
132         // constructor execution.
133 
134         uint256 size;
135         // solhint-disable-next-line no-inline-assembly
136         assembly { size := extcodesize(account) }
137         return size > 0;
138     }
139 
140     /**
141      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
142      * `recipient`, forwarding all available gas and reverting on errors.
143      *
144      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
145      * of certain opcodes, possibly making contracts go over the 2300 gas limit
146      * imposed by `transfer`, making them unable to receive funds via
147      * `transfer`. {sendValue} removes this limitation.
148      *
149      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
150      *
151      * IMPORTANT: because control is transferred to `recipient`, care must be
152      * taken to not create reentrancy vulnerabilities. Consider using
153      * {ReentrancyGuard} or the
154      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
155      */
156     function sendValue(address payable recipient, uint256 amount) internal {
157         require(address(this).balance >= amount, "Address: insufficient balance");
158 
159         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
160         (bool success, ) = recipient.call{ value: amount }("");
161         require(success, "Address: unable to send value, recipient may have reverted");
162     }
163 
164     /**
165      * @dev Performs a Solidity function call using a low level `call`. A
166      * plain`call` is an unsafe replacement for a function call: use this
167      * function instead.
168      *
169      * If `target` reverts with a revert reason, it is bubbled up by this
170      * function (like regular Solidity function calls).
171      *
172      * Returns the raw returned data. To convert to the expected return value,
173      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
174      *
175      * Requirements:
176      *
177      * - `target` must be a contract.
178      * - calling `target` with `data` must not revert.
179      *
180      * _Available since v3.1._
181      */
182     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
183       return functionCall(target, data, "Address: low-level call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
188      * `errorMessage` as a fallback revert reason when `target` reverts.
189      *
190      * _Available since v3.1._
191      */
192     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
193         return _functionCallWithValue(target, data, 0, errorMessage);
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
198      * but also transferring `value` wei to `target`.
199      *
200      * Requirements:
201      *
202      * - the calling contract must have an ETH balance of at least `value`.
203      * - the called Solidity function must be `payable`.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
208         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
209     }
210 
211     /**
212      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
213      * with `errorMessage` as a fallback revert reason when `target` reverts.
214      *
215      * _Available since v3.1._
216      */
217     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
218         require(address(this).balance >= value, "Address: insufficient balance for call");
219         return _functionCallWithValue(target, data, value, errorMessage);
220     }
221 
222     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
223         require(isContract(target), "Address: call to non-contract");
224 
225         // solhint-disable-next-line avoid-low-level-calls
226         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
227         if (success) {
228             return returndata;
229         } else {
230             // Look for revert reason and bubble it up if present
231             if (returndata.length > 0) {
232                 // The easiest way to bubble the revert reason is using memory via assembly
233 
234                 // solhint-disable-next-line no-inline-assembly
235                 assembly {
236                     let returndata_size := mload(returndata)
237                     revert(add(32, returndata), returndata_size)
238                 }
239             } else {
240                 revert(errorMessage);
241             }
242         }
243     }
244 }
245 
246 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
247 
248 
249 pragma solidity ^0.6.0;
250 
251 /**
252  * @dev Interface of the ERC20 standard as defined in the EIP.
253  */
254 interface IERC20 {
255     /**
256      * @dev Returns the amount of tokens in existence.
257      */
258     function totalSupply() external view returns (uint256);
259 
260     /**
261      * @dev Returns the amount of tokens owned by `account`.
262      */
263     function balanceOf(address account) external view returns (uint256);
264 
265     /**
266      * @dev Moves `amount` tokens from the caller's account to `recipient`.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transfer(address recipient, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Returns the remaining number of tokens that `spender` will be
276      * allowed to spend on behalf of `owner` through {transferFrom}. This is
277      * zero by default.
278      *
279      * This value changes when {approve} or {transferFrom} are called.
280      */
281     function allowance(address owner, address spender) external view returns (uint256);
282 
283     /**
284      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * IMPORTANT: Beware that changing an allowance with this method brings the risk
289      * that someone may use both the old and the new allowance by unfortunate
290      * transaction ordering. One possible solution to mitigate this race
291      * condition is to first reduce the spender's allowance to 0 and set the
292      * desired value afterwards:
293      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294      *
295      * Emits an {Approval} event.
296      */
297     function approve(address spender, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Moves `amount` tokens from `sender` to `recipient` using the
301      * allowance mechanism. `amount` is then deducted from the caller's
302      * allowance.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Emitted when `value` tokens are moved from one account (`from`) to
312      * another (`to`).
313      *
314      * Note that `value` may be zero.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 value);
317 
318     /**
319      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
320      * a call to {approve}. `value` is the new allowance.
321      */
322     event Approval(address indexed owner, address indexed spender, uint256 value);
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
326 
327 
328 pragma solidity ^0.6.0;
329 
330 
331 
332 
333 /**
334  * @title SafeERC20
335  * @dev Wrappers around ERC20 operations that throw on failure (when the token
336  * contract returns false). Tokens that return no value (and instead revert or
337  * throw on failure) are also supported, non-reverting calls are assumed to be
338  * successful.
339  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
340  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
341  */
342 library SafeERC20 {
343     using SafeMath for uint256;
344     using Address for address;
345 
346     function safeTransfer(IERC20 token, address to, uint256 value) internal {
347         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
348     }
349 
350     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
351         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
352     }
353 
354     /**
355      * @dev Deprecated. This function has issues similar to the ones found in
356      * {IERC20-approve}, and its usage is discouraged.
357      *
358      * Whenever possible, use {safeIncreaseAllowance} and
359      * {safeDecreaseAllowance} instead.
360      */
361     function safeApprove(IERC20 token, address spender, uint256 value) internal {
362         // safeApprove should only be called when setting an initial allowance,
363         // or when resetting it to zero. To increase and decrease it, use
364         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
365         // solhint-disable-next-line max-line-length
366         require((value == 0) || (token.allowance(address(this), spender) == 0),
367             "SafeERC20: approve from non-zero to non-zero allowance"
368         );
369         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
370     }
371 
372     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
373         uint256 newAllowance = token.allowance(address(this), spender).add(value);
374         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
375     }
376 
377     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
378         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
379         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
380     }
381 
382     /**
383      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
384      * on the return value: the return value is optional (but if data is returned, it must not be false).
385      * @param token The token targeted by the call.
386      * @param data The call data (encoded using abi.encode or one of its variants).
387      */
388     function _callOptionalReturn(IERC20 token, bytes memory data) private {
389         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
390         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
391         // the target address contains contract code and also asserts for success in the low-level call.
392 
393         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
394         if (returndata.length > 0) { // Return data is optional
395             // solhint-disable-next-line max-line-length
396             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
397         }
398     }
399 }
400 
401 // File: @openzeppelin/contracts/math/SafeMath.sol
402 
403 
404 pragma solidity ^0.6.0;
405 
406 /**
407  * @dev Wrappers over Solidity's arithmetic operations with added overflow
408  * checks.
409  *
410  * Arithmetic operations in Solidity wrap on overflow. This can easily result
411  * in bugs, because programmers usually assume that an overflow raises an
412  * error, which is the standard behavior in high level programming languages.
413  * `SafeMath` restores this intuition by reverting the transaction when an
414  * operation overflows.
415  *
416  * Using this library instead of the unchecked operations eliminates an entire
417  * class of bugs, so it's recommended to use it always.
418  */
419 library SafeMath {
420     /**
421      * @dev Returns the addition of two unsigned integers, reverting on
422      * overflow.
423      *
424      * Counterpart to Solidity's `+` operator.
425      *
426      * Requirements:
427      *
428      * - Addition cannot overflow.
429      */
430     function add(uint256 a, uint256 b) internal pure returns (uint256) {
431         uint256 c = a + b;
432         require(c >= a, "SafeMath: addition overflow");
433 
434         return c;
435     }
436 
437     /**
438      * @dev Returns the subtraction of two unsigned integers, reverting on
439      * overflow (when the result is negative).
440      *
441      * Counterpart to Solidity's `-` operator.
442      *
443      * Requirements:
444      *
445      * - Subtraction cannot overflow.
446      */
447     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
448         return sub(a, b, "SafeMath: subtraction overflow");
449     }
450 
451     /**
452      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
453      * overflow (when the result is negative).
454      *
455      * Counterpart to Solidity's `-` operator.
456      *
457      * Requirements:
458      *
459      * - Subtraction cannot overflow.
460      */
461     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
462         require(b <= a, errorMessage);
463         uint256 c = a - b;
464 
465         return c;
466     }
467 
468     /**
469      * @dev Returns the multiplication of two unsigned integers, reverting on
470      * overflow.
471      *
472      * Counterpart to Solidity's `*` operator.
473      *
474      * Requirements:
475      *
476      * - Multiplication cannot overflow.
477      */
478     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
479         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
480         // benefit is lost if 'b' is also tested.
481         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
482         if (a == 0) {
483             return 0;
484         }
485 
486         uint256 c = a * b;
487         require(c / a == b, "SafeMath: multiplication overflow");
488 
489         return c;
490     }
491 
492     /**
493      * @dev Returns the integer division of two unsigned integers. Reverts on
494      * division by zero. The result is rounded towards zero.
495      *
496      * Counterpart to Solidity's `/` operator. Note: this function uses a
497      * `revert` opcode (which leaves remaining gas untouched) while Solidity
498      * uses an invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function div(uint256 a, uint256 b) internal pure returns (uint256) {
505         return div(a, b, "SafeMath: division by zero");
506     }
507 
508     /**
509      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
510      * division by zero. The result is rounded towards zero.
511      *
512      * Counterpart to Solidity's `/` operator. Note: this function uses a
513      * `revert` opcode (which leaves remaining gas untouched) while Solidity
514      * uses an invalid opcode to revert (consuming all remaining gas).
515      *
516      * Requirements:
517      *
518      * - The divisor cannot be zero.
519      */
520     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
521         require(b > 0, errorMessage);
522         uint256 c = a / b;
523         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
524 
525         return c;
526     }
527 
528     /**
529      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
530      * Reverts when dividing by zero.
531      *
532      * Counterpart to Solidity's `%` operator. This function uses a `revert`
533      * opcode (which leaves remaining gas untouched) while Solidity uses an
534      * invalid opcode to revert (consuming all remaining gas).
535      *
536      * Requirements:
537      *
538      * - The divisor cannot be zero.
539      */
540     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
541         return mod(a, b, "SafeMath: modulo by zero");
542     }
543 
544     /**
545      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
546      * Reverts with custom message when dividing by zero.
547      *
548      * Counterpart to Solidity's `%` operator. This function uses a `revert`
549      * opcode (which leaves remaining gas untouched) while Solidity uses an
550      * invalid opcode to revert (consuming all remaining gas).
551      *
552      * Requirements:
553      *
554      * - The divisor cannot be zero.
555      */
556     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
557         require(b != 0, errorMessage);
558         return a % b;
559     }
560 }
561 
562 // File: @openzeppelin/contracts/GSN/Context.sol
563 
564 
565 pragma solidity ^0.6.0;
566 
567 /*
568  * @dev Provides information about the current execution context, including the
569  * sender of the transaction and its data. While these are generally available
570  * via msg.sender and msg.data, they should not be accessed in such a direct
571  * manner, since when dealing with GSN meta-transactions the account sending and
572  * paying for execution may not be the actual sender (as far as an application
573  * is concerned).
574  *
575  * This contract is only required for intermediate, library-like contracts.
576  */
577 abstract contract Context {
578     function _msgSender() internal view virtual returns (address payable) {
579         return msg.sender;
580     }
581 
582     function _msgData() internal view virtual returns (bytes memory) {
583         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
584         return msg.data;
585     }
586 }
587 
588 // File: @openzeppelin/contracts/access/Ownable.sol
589 
590 
591 pragma solidity ^0.6.0;
592 
593 /**
594  * @dev Contract module which provides a basic access control mechanism, where
595  * there is an account (an owner) that can be granted exclusive access to
596  * specific functions.
597  *
598  * By default, the owner account will be the one that deploys the contract. This
599  * can later be changed with {transferOwnership}.
600  *
601  * This module is used through inheritance. It will make available the modifier
602  * `onlyOwner`, which can be applied to your functions to restrict their use to
603  * the owner.
604  */
605 contract Ownable is Context {
606     address private _owner;
607 
608     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
609 
610     /**
611      * @dev Initializes the contract setting the deployer as the initial owner.
612      */
613     constructor () internal {
614         address msgSender = _msgSender();
615         _owner = msgSender;
616         emit OwnershipTransferred(address(0), msgSender);
617     }
618 
619     /**
620      * @dev Returns the address of the current owner.
621      */
622     function owner() public view returns (address) {
623         return _owner;
624     }
625 
626     /**
627      * @dev Throws if called by any account other than the owner.
628      */
629     modifier onlyOwner() {
630         require(_owner == _msgSender(), "Ownable: caller is not the owner");
631         _;
632     }
633 
634     /**
635      * @dev Leaves the contract without owner. It will not be possible to call
636      * `onlyOwner` functions anymore. Can only be called by the current owner.
637      *
638      * NOTE: Renouncing ownership will leave the contract without an owner,
639      * thereby removing any functionality that is only available to the owner.
640      */
641     function renounceOwnership() public virtual onlyOwner {
642         emit OwnershipTransferred(_owner, address(0));
643         _owner = address(0);
644     }
645 
646     /**
647      * @dev Transfers ownership of the contract to a new account (`newOwner`).
648      * Can only be called by the current owner.
649      */
650     function transferOwnership(address newOwner) public virtual onlyOwner {
651         require(newOwner != address(0), "Ownable: new owner is the zero address");
652         emit OwnershipTransferred(_owner, newOwner);
653         _owner = newOwner;
654     }
655 }
656 
657 
658 // File: localhost/contracts/erc20-redeemable/contracts/MerkleRedeem.sol
659 
660 pragma solidity ^0.6.0;
661 pragma experimental ABIEncoderV2;
662 
663 
664 contract MerkleRedeem is Ownable {
665     IERC20 public token;
666 
667     event Claimed(address _claimant, uint256 _balance);
668 
669     // Recorded weeks
670     mapping(uint256 => bytes32) public weekMerkleRoots;
671     mapping(uint256 => mapping(address => bool)) public claimed;
672 
673     constructor(address _token) public {
674         token = IERC20(_token);
675     }
676 
677     function disburse(address _liquidityProvider, uint256 _balance) private {
678         if (_balance > 0) {
679             emit Claimed(_liquidityProvider, _balance);
680             require(
681                 token.transfer(_liquidityProvider, _balance),
682                 "ERR_TRANSFER_FAILED"
683             );
684         }
685     }
686 
687     function claimWeek(
688         address _liquidityProvider,
689         uint256 _week,
690         uint256 _claimedBalance,
691         bytes32[] memory _merkleProof
692     ) public {
693         require(!claimed[_week][_liquidityProvider]);
694         require(
695             verifyClaim(
696                 _liquidityProvider,
697                 _week,
698                 _claimedBalance,
699                 _merkleProof
700             ),
701             "Incorrect merkle proof"
702         );
703 
704         claimed[_week][_liquidityProvider] = true;
705         disburse(_liquidityProvider, _claimedBalance);
706     }
707 
708     struct Claim {
709         uint256 week;
710         uint256 balance;
711         bytes32[] merkleProof;
712     }
713 
714     function claimWeeks(address _liquidityProvider, Claim[] memory claims)
715         public
716     {
717         uint256 totalBalance = 0;
718         Claim memory claim;
719         for (uint256 i = 0; i < claims.length; i++) {
720             claim = claims[i];
721 
722             require(!claimed[claim.week][_liquidityProvider]);
723             require(
724                 verifyClaim(
725                     _liquidityProvider,
726                     claim.week,
727                     claim.balance,
728                     claim.merkleProof
729                 ),
730                 "Incorrect merkle proof"
731             );
732 
733             totalBalance += claim.balance;
734             claimed[claim.week][_liquidityProvider] = true;
735         }
736         disburse(_liquidityProvider, totalBalance);
737     }
738 
739     function claimStatus(
740         address _liquidityProvider,
741         uint256 _begin,
742         uint256 _end
743     ) external view returns (bool[] memory) {
744         uint256 size = 1 + _end - _begin;
745         bool[] memory arr = new bool[](size);
746         for (uint256 i = 0; i < size; i++) {
747             arr[i] = claimed[_begin + i][_liquidityProvider];
748         }
749         return arr;
750     }
751 
752     function merkleRoots(uint256 _begin, uint256 _end)
753         external
754         view
755         returns (bytes32[] memory)
756     {
757         uint256 size = 1 + _end - _begin;
758         bytes32[] memory arr = new bytes32[](size);
759         for (uint256 i = 0; i < size; i++) {
760             arr[i] = weekMerkleRoots[_begin + i];
761         }
762         return arr;
763     }
764 
765     function verifyClaim(
766         address _liquidityProvider,
767         uint256 _week,
768         uint256 _claimedBalance,
769         bytes32[] memory _merkleProof
770     ) public view returns (bool valid) {
771         bytes32 leaf = keccak256(
772             abi.encodePacked(_liquidityProvider, _claimedBalance)
773         );
774         return MerkleProof.verify(_merkleProof, weekMerkleRoots[_week], leaf);
775     }
776 
777     function seedAllocations(
778         uint256 _week,
779         bytes32 _merkleRoot,
780         uint256 _totalAllocation
781     ) external onlyOwner {
782         require(
783             weekMerkleRoots[_week] == bytes32(0),
784             "cannot rewrite merkle root"
785         );
786         weekMerkleRoots[_week] = _merkleRoot;
787 
788         require(
789             token.transferFrom(msg.sender, address(this), _totalAllocation),
790             "ERR_TRANSFER_FAILED"
791         );
792     }
793 }
794 
795 // File: @openzeppelin/contracts/utils/Pausable.sol
796 
797 
798 pragma solidity ^0.6.0;
799 
800 
801 /**
802  * @dev Contract module which allows children to implement an emergency stop
803  * mechanism that can be triggered by an authorized account.
804  *
805  * This module is used through inheritance. It will make available the
806  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
807  * the functions of your contract. Note that they will not be pausable by
808  * simply including this module, only once the modifiers are put in place.
809  */
810 contract Pausable is Context {
811     /**
812      * @dev Emitted when the pause is triggered by `account`.
813      */
814     event Paused(address account);
815 
816     /**
817      * @dev Emitted when the pause is lifted by `account`.
818      */
819     event Unpaused(address account);
820 
821     bool private _paused;
822 
823     /**
824      * @dev Initializes the contract in unpaused state.
825      */
826     constructor () internal {
827         _paused = false;
828     }
829 
830     /**
831      * @dev Returns true if the contract is paused, and false otherwise.
832      */
833     function paused() public view returns (bool) {
834         return _paused;
835     }
836 
837     /**
838      * @dev Modifier to make a function callable only when the contract is not paused.
839      *
840      * Requirements:
841      *
842      * - The contract must not be paused.
843      */
844     modifier whenNotPaused() {
845         require(!_paused, "Pausable: paused");
846         _;
847     }
848 
849     /**
850      * @dev Modifier to make a function callable only when the contract is paused.
851      *
852      * Requirements:
853      *
854      * - The contract must be paused.
855      */
856     modifier whenPaused() {
857         require(_paused, "Pausable: not paused");
858         _;
859     }
860 
861     /**
862      * @dev Triggers stopped state.
863      *
864      * Requirements:
865      *
866      * - The contract must not be paused.
867      */
868     function _pause() internal virtual whenNotPaused {
869         _paused = true;
870         emit Paused(_msgSender());
871     }
872 
873     /**
874      * @dev Returns to normal state.
875      *
876      * Requirements:
877      *
878      * - The contract must be paused.
879      */
880     function _unpause() internal virtual whenPaused {
881         _paused = false;
882         emit Unpaused(_msgSender());
883     }
884 }
885 
886 // File: localhost/contracts/Staking.sol
887 
888 
889 pragma solidity ^0.6.0;
890 
891 /**
892  * @title The staking contract for Furucombo
893  */
894 contract Staking is Ownable, Pausable, ReentrancyGuard {
895     using SafeMath for uint256;
896     using SafeERC20 for IERC20;
897 
898     IERC20 public stakingToken;
899     // The redeem contract location of claiming functions
900     MerkleRedeem public redeemable;
901 
902     mapping(address => uint256) private _balances;
903     mapping(address => mapping(address => bool)) private _approvals;
904 
905     event Staked(
906         address indexed sender,
907         address indexed onBehalfOf,
908         uint256 amount
909     );
910     event Unstaked(
911         address indexed sender,
912         address indexed onBehalfOf,
913         uint256 amount
914     );
915     event Approved(address indexed user, address indexed agent, bool approval);
916 
917     modifier onlyApproved(address owner) {
918         require(
919             _approvals[owner][msg.sender],
920             "Furucombo staking: agent is not approved"
921         );
922         _;
923     }
924 
925     /**
926      * @notice The redeem contract owner will be transferred to the deployer.
927      */
928     constructor(address _stakingToken, address _rewardToken) public {
929         stakingToken = IERC20(_stakingToken);
930         redeemable = new MerkleRedeem(_rewardToken);
931         redeemable.transferOwnership(msg.sender);
932         _pause();
933     }
934 
935     /**
936      * @notice Verify if the agent is approved by user. Approval is required to
937      * perform `unstakeFor`.
938      * @param user The user address.
939      * @param agent The agent address to be verified.
940      */
941     function isApproved(address user, address agent)
942         external
943         view
944         returns (bool)
945     {
946         return _approvals[user][agent];
947     }
948 
949     /**
950      * @notice Check the staked balance of user.
951      * @param user The user address.
952      * @return The staked balance.
953      */
954     function balanceOf(address user) external view returns (uint256) {
955         return _balances[user];
956     }
957 
958     /**
959      * @notice Set the approval for agent.
960      * @param agent The agent to be approved/disapproved.
961      * @param approval The approval.
962      */
963     function setApproval(address agent, bool approval) external {
964         require(agent != address(0), "Furucombo staking: agent is 0");
965         require(
966             _approvals[msg.sender][agent] != approval,
967             "Furucombo staking: identical approval assigned"
968         );
969         _approvals[msg.sender][agent] = approval;
970         emit Approved(msg.sender, agent, approval);
971     }
972 
973     /**
974      * @notice The staking function.
975      * @param amount The amount to be staked.
976      */
977     function stake(uint256 amount) external nonReentrant whenNotPaused {
978         _stakeInternal(msg.sender, amount);
979     }
980 
981     /**
982      * @notice The delegate staking function.
983      * @param onBehalfOf The address to be staked.
984      * @param amount The amount to be staked.
985      */
986     function stakeFor(address onBehalfOf, uint256 amount)
987         external
988         nonReentrant
989         whenNotPaused
990     {
991         _stakeInternal(onBehalfOf, amount);
992     }
993 
994     /**
995      * @notice The unstaking function.
996      * @param amount The amount to be unstaked.
997      */
998     function unstake(uint256 amount) external nonReentrant {
999         _unstakeInternal(msg.sender, amount);
1000     }
1001 
1002     /**
1003      * @notice The delegate staking function. Approval is required. The
1004      * unstaked balance will be transferred to the caller.
1005      * @param onBehalfOf The address to be unstaked.
1006      * @param amount The amount to be unstaked.
1007      */
1008     function unstakeFor(address onBehalfOf, uint256 amount)
1009         external
1010         nonReentrant
1011         onlyApproved(onBehalfOf)
1012     {
1013         _unstakeInternal(onBehalfOf, amount);
1014     }
1015 
1016     /**
1017      * @notice The claiming function. The function call is forwarded to the
1018      * redeem contract.
1019      */
1020     function claimWeek(
1021         address user,
1022         uint256 week,
1023         uint256 balance,
1024         bytes32[] memory merkleProof
1025     ) public {
1026         redeemable.claimWeek(user, week, balance, merkleProof);
1027     }
1028 
1029     /**
1030      * @notice The claiming function. The function call is forwarded to the
1031      * redeem contract.
1032      */
1033     function claimWeeks(address user, MerkleRedeem.Claim[] memory claims)
1034         public
1035     {
1036         redeemable.claimWeeks(user, claims);
1037     }
1038 
1039     /**
1040      * @notice The pausing funciton. Can only be triggered by owner.
1041      */
1042     function pause() external onlyOwner {
1043         _pause();
1044     }
1045 
1046     /**
1047      *
1048      */
1049     function unpause() external onlyOwner {
1050         _unpause();
1051     }
1052 
1053     function _stakeInternal(address user, uint256 amount) internal {
1054         require(amount > 0, "Furucombo staking: staking 0");
1055         _balances[user] = _balances[user].add(amount);
1056         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1057         emit Staked(msg.sender, user, amount);
1058     }
1059 
1060     function _unstakeInternal(address user, uint256 amount) internal {
1061         require(amount > 0, "Furucombo staking: unstaking 0");
1062         _balances[user] = _balances[user].sub(amount);
1063         stakingToken.safeTransfer(msg.sender, amount);
1064         emit Unstaked(msg.sender, user, amount);
1065     }
1066 }