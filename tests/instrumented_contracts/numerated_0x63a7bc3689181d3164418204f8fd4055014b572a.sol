1 // Sources flattened with hardhat v2.1.2 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
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
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File @openzeppelin/contracts/math/SafeMath.sol@v3.2.0
85 
86 // SPDX-License-Identifier: MIT
87 
88 pragma solidity ^0.6.0;
89 
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `+` operator.
109      *
110      * Requirements:
111      *
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b <= a, errorMessage);
147         uint256 c = a - b;
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `*` operator.
157      *
158      * Requirements:
159      *
160      * - Multiplication cannot overflow.
161      */
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164         // benefit is lost if 'b' is also tested.
165         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166         if (a == 0) {
167             return 0;
168         }
169 
170         uint256 c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         return div(a, b, "SafeMath: division by zero");
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b > 0, errorMessage);
206         uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225         return mod(a, b, "SafeMath: modulo by zero");
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts with custom message when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b != 0, errorMessage);
242         return a % b;
243     }
244 }
245 
246 
247 // File @openzeppelin/contracts/utils/Address.sol@v3.2.0
248 
249 // SPDX-License-Identifier: MIT
250 
251 pragma solidity ^0.6.2;
252 
253 /**
254  * @dev Collection of functions related to the address type
255  */
256 library Address {
257     /**
258      * @dev Returns true if `account` is a contract.
259      *
260      * [IMPORTANT]
261      * ====
262      * It is unsafe to assume that an address for which this function returns
263      * false is an externally-owned account (EOA) and not a contract.
264      *
265      * Among others, `isContract` will return false for the following
266      * types of addresses:
267      *
268      *  - an externally-owned account
269      *  - a contract in construction
270      *  - an address where a contract will be created
271      *  - an address where a contract lived, but was destroyed
272      * ====
273      */
274     function isContract(address account) internal view returns (bool) {
275         // This method relies in extcodesize, which returns 0 for contracts in
276         // construction, since the code is only stored at the end of the
277         // constructor execution.
278 
279         uint256 size;
280         // solhint-disable-next-line no-inline-assembly
281         assembly { size := extcodesize(account) }
282         return size > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
305         (bool success, ) = recipient.call{ value: amount }("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain`call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
319      *
320      * Requirements:
321      *
322      * - `target` must be a contract.
323      * - calling `target` with `data` must not revert.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
328       return functionCall(target, data, "Address: low-level call failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
333      * `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
338         return _functionCallWithValue(target, data, 0, errorMessage);
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
343      * but also transferring `value` wei to `target`.
344      *
345      * Requirements:
346      *
347      * - the calling contract must have an ETH balance of at least `value`.
348      * - the called Solidity function must be `payable`.
349      *
350      * _Available since v3.1._
351      */
352     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
353         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
358      * with `errorMessage` as a fallback revert reason when `target` reverts.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
363         require(address(this).balance >= value, "Address: insufficient balance for call");
364         return _functionCallWithValue(target, data, value, errorMessage);
365     }
366 
367     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
368         require(isContract(target), "Address: call to non-contract");
369 
370         // solhint-disable-next-line avoid-low-level-calls
371         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
372         if (success) {
373             return returndata;
374         } else {
375             // Look for revert reason and bubble it up if present
376             if (returndata.length > 0) {
377                 // The easiest way to bubble the revert reason is using memory via assembly
378 
379                 // solhint-disable-next-line no-inline-assembly
380                 assembly {
381                     let returndata_size := mload(returndata)
382                     revert(add(32, returndata), returndata_size)
383                 }
384             } else {
385                 revert(errorMessage);
386             }
387         }
388     }
389 }
390 
391 
392 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.2.0
393 
394 // SPDX-License-Identifier: MIT
395 
396 pragma solidity ^0.6.0;
397 
398 
399 
400 /**
401  * @title SafeERC20
402  * @dev Wrappers around ERC20 operations that throw on failure (when the token
403  * contract returns false). Tokens that return no value (and instead revert or
404  * throw on failure) are also supported, non-reverting calls are assumed to be
405  * successful.
406  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
407  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
408  */
409 library SafeERC20 {
410     using SafeMath for uint256;
411     using Address for address;
412 
413     function safeTransfer(IERC20 token, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
415     }
416 
417     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
418         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
419     }
420 
421     /**
422      * @dev Deprecated. This function has issues similar to the ones found in
423      * {IERC20-approve}, and its usage is discouraged.
424      *
425      * Whenever possible, use {safeIncreaseAllowance} and
426      * {safeDecreaseAllowance} instead.
427      */
428     function safeApprove(IERC20 token, address spender, uint256 value) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         // solhint-disable-next-line max-line-length
433         require((value == 0) || (token.allowance(address(this), spender) == 0),
434             "SafeERC20: approve from non-zero to non-zero allowance"
435         );
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
437     }
438 
439     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
440         uint256 newAllowance = token.allowance(address(this), spender).add(value);
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
442     }
443 
444     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
446         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     /**
450      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
451      * on the return value: the return value is optional (but if data is returned, it must not be false).
452      * @param token The token targeted by the call.
453      * @param data The call data (encoded using abi.encode or one of its variants).
454      */
455     function _callOptionalReturn(IERC20 token, bytes memory data) private {
456         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
457         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
458         // the target address contains contract code and also asserts for success in the low-level call.
459 
460         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
461         if (returndata.length > 0) { // Return data is optional
462             // solhint-disable-next-line max-line-length
463             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
464         }
465     }
466 }
467 
468 
469 // File @openzeppelin/contracts/GSN/Context.sol@v3.2.0
470 
471 // SPDX-License-Identifier: MIT
472 
473 pragma solidity ^0.6.0;
474 
475 /*
476  * @dev Provides information about the current execution context, including the
477  * sender of the transaction and its data. While these are generally available
478  * via msg.sender and msg.data, they should not be accessed in such a direct
479  * manner, since when dealing with GSN meta-transactions the account sending and
480  * paying for execution may not be the actual sender (as far as an application
481  * is concerned).
482  *
483  * This contract is only required for intermediate, library-like contracts.
484  */
485 abstract contract Context {
486     function _msgSender() internal view virtual returns (address payable) {
487         return msg.sender;
488     }
489 
490     function _msgData() internal view virtual returns (bytes memory) {
491         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
492         return msg.data;
493     }
494 }
495 
496 
497 // File @openzeppelin/contracts/access/Ownable.sol@v3.2.0
498 
499 // SPDX-License-Identifier: MIT
500 
501 pragma solidity ^0.6.0;
502 
503 /**
504  * @dev Contract module which provides a basic access control mechanism, where
505  * there is an account (an owner) that can be granted exclusive access to
506  * specific functions.
507  *
508  * By default, the owner account will be the one that deploys the contract. This
509  * can later be changed with {transferOwnership}.
510  *
511  * This module is used through inheritance. It will make available the modifier
512  * `onlyOwner`, which can be applied to your functions to restrict their use to
513  * the owner.
514  */
515 contract Ownable is Context {
516     address private _owner;
517 
518     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
519 
520     /**
521      * @dev Initializes the contract setting the deployer as the initial owner.
522      */
523     constructor () internal {
524         address msgSender = _msgSender();
525         _owner = msgSender;
526         emit OwnershipTransferred(address(0), msgSender);
527     }
528 
529     /**
530      * @dev Returns the address of the current owner.
531      */
532     function owner() public view returns (address) {
533         return _owner;
534     }
535 
536     /**
537      * @dev Throws if called by any account other than the owner.
538      */
539     modifier onlyOwner() {
540         require(_owner == _msgSender(), "Ownable: caller is not the owner");
541         _;
542     }
543 
544     /**
545      * @dev Leaves the contract without owner. It will not be possible to call
546      * `onlyOwner` functions anymore. Can only be called by the current owner.
547      *
548      * NOTE: Renouncing ownership will leave the contract without an owner,
549      * thereby removing any functionality that is only available to the owner.
550      */
551     function renounceOwnership() public virtual onlyOwner {
552         emit OwnershipTransferred(_owner, address(0));
553         _owner = address(0);
554     }
555 
556     /**
557      * @dev Transfers ownership of the contract to a new account (`newOwner`).
558      * Can only be called by the current owner.
559      */
560     function transferOwnership(address newOwner) public virtual onlyOwner {
561         require(newOwner != address(0), "Ownable: new owner is the zero address");
562         emit OwnershipTransferred(_owner, newOwner);
563         _owner = newOwner;
564     }
565 }
566 
567 
568 // File @openzeppelin/contracts/cryptography/MerkleProof.sol@v3.2.0
569 
570 // SPDX-License-Identifier: MIT
571 
572 pragma solidity ^0.6.0;
573 
574 /**
575  * @dev These functions deal with verification of Merkle trees (hash trees),
576  */
577 library MerkleProof {
578     /**
579      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
580      * defined by `root`. For this, a `proof` must be provided, containing
581      * sibling hashes on the branch from the leaf to the root of the tree. Each
582      * pair of leaves and each pair of pre-images are assumed to be sorted.
583      */
584     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
585         bytes32 computedHash = leaf;
586 
587         for (uint256 i = 0; i < proof.length; i++) {
588             bytes32 proofElement = proof[i];
589 
590             if (computedHash <= proofElement) {
591                 // Hash(current computed hash + current element of the proof)
592                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
593             } else {
594                 // Hash(current element of the proof + current computed hash)
595                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
596             }
597         }
598 
599         // Check if the computed hash (root) is equal to the provided root
600         return computedHash == root;
601     }
602 }
603 
604 
605 // File contracts/IMerkleDistributor.sol
606 
607 // SPDX-License-Identifier: UNLICENSED
608 pragma solidity ^0.6.5;
609 
610 // Allows anyone to claim a token if they exist in a merkle root.
611 interface IMerkleDistributor {
612     // Returns the address of the token distributed by this contract.
613     function token() external view returns (address);
614     // Returns the merkle root of the merkle tree containing account balances available to claim.
615     function merkleRoot() external view returns (bytes32);
616     // Returns true if the index has been marked claimed.
617     function isClaimed(uint256 index) external view returns (bool);
618     // Claim the given amount of the token to the given address. Reverts if the inputs are invalid.
619     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external;
620 
621     // This event is triggered whenever a call to #claim succeeds.
622     event Claimed(uint256 index, address account, uint256 amount);
623 }
624 
625 
626 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.2.0
627 
628 // SPDX-License-Identifier: MIT
629 
630 pragma solidity ^0.6.0;
631 
632 
633 
634 
635 /**
636  * @dev Implementation of the {IERC20} interface.
637  *
638  * This implementation is agnostic to the way tokens are created. This means
639  * that a supply mechanism has to be added in a derived contract using {_mint}.
640  * For a generic mechanism see {ERC20PresetMinterPauser}.
641  *
642  * TIP: For a detailed writeup see our guide
643  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
644  * to implement supply mechanisms].
645  *
646  * We have followed general OpenZeppelin guidelines: functions revert instead
647  * of returning `false` on failure. This behavior is nonetheless conventional
648  * and does not conflict with the expectations of ERC20 applications.
649  *
650  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
651  * This allows applications to reconstruct the allowance for all accounts just
652  * by listening to said events. Other implementations of the EIP may not emit
653  * these events, as it isn't required by the specification.
654  *
655  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
656  * functions have been added to mitigate the well-known issues around setting
657  * allowances. See {IERC20-approve}.
658  */
659 contract ERC20 is Context, IERC20 {
660     using SafeMath for uint256;
661     using Address for address;
662 
663     mapping (address => uint256) private _balances;
664 
665     mapping (address => mapping (address => uint256)) private _allowances;
666 
667     uint256 private _totalSupply;
668 
669     string private _name;
670     string private _symbol;
671     uint8 private _decimals;
672 
673     /**
674      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
675      * a default value of 18.
676      *
677      * To select a different value for {decimals}, use {_setupDecimals}.
678      *
679      * All three of these values are immutable: they can only be set once during
680      * construction.
681      */
682     constructor (string memory name, string memory symbol) public {
683         _name = name;
684         _symbol = symbol;
685         _decimals = 18;
686     }
687 
688     /**
689      * @dev Returns the name of the token.
690      */
691     function name() public view returns (string memory) {
692         return _name;
693     }
694 
695     /**
696      * @dev Returns the symbol of the token, usually a shorter version of the
697      * name.
698      */
699     function symbol() public view returns (string memory) {
700         return _symbol;
701     }
702 
703     /**
704      * @dev Returns the number of decimals used to get its user representation.
705      * For example, if `decimals` equals `2`, a balance of `505` tokens should
706      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
707      *
708      * Tokens usually opt for a value of 18, imitating the relationship between
709      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
710      * called.
711      *
712      * NOTE: This information is only used for _display_ purposes: it in
713      * no way affects any of the arithmetic of the contract, including
714      * {IERC20-balanceOf} and {IERC20-transfer}.
715      */
716     function decimals() public view returns (uint8) {
717         return _decimals;
718     }
719 
720     /**
721      * @dev See {IERC20-totalSupply}.
722      */
723     function totalSupply() public view override returns (uint256) {
724         return _totalSupply;
725     }
726 
727     /**
728      * @dev See {IERC20-balanceOf}.
729      */
730     function balanceOf(address account) public view override returns (uint256) {
731         return _balances[account];
732     }
733 
734     /**
735      * @dev See {IERC20-transfer}.
736      *
737      * Requirements:
738      *
739      * - `recipient` cannot be the zero address.
740      * - the caller must have a balance of at least `amount`.
741      */
742     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
743         _transfer(_msgSender(), recipient, amount);
744         return true;
745     }
746 
747     /**
748      * @dev See {IERC20-allowance}.
749      */
750     function allowance(address owner, address spender) public view virtual override returns (uint256) {
751         return _allowances[owner][spender];
752     }
753 
754     /**
755      * @dev See {IERC20-approve}.
756      *
757      * Requirements:
758      *
759      * - `spender` cannot be the zero address.
760      */
761     function approve(address spender, uint256 amount) public virtual override returns (bool) {
762         _approve(_msgSender(), spender, amount);
763         return true;
764     }
765 
766     /**
767      * @dev See {IERC20-transferFrom}.
768      *
769      * Emits an {Approval} event indicating the updated allowance. This is not
770      * required by the EIP. See the note at the beginning of {ERC20};
771      *
772      * Requirements:
773      * - `sender` and `recipient` cannot be the zero address.
774      * - `sender` must have a balance of at least `amount`.
775      * - the caller must have allowance for ``sender``'s tokens of at least
776      * `amount`.
777      */
778     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
779         _transfer(sender, recipient, amount);
780         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
781         return true;
782     }
783 
784     /**
785      * @dev Atomically increases the allowance granted to `spender` by the caller.
786      *
787      * This is an alternative to {approve} that can be used as a mitigation for
788      * problems described in {IERC20-approve}.
789      *
790      * Emits an {Approval} event indicating the updated allowance.
791      *
792      * Requirements:
793      *
794      * - `spender` cannot be the zero address.
795      */
796     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
797         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
798         return true;
799     }
800 
801     /**
802      * @dev Atomically decreases the allowance granted to `spender` by the caller.
803      *
804      * This is an alternative to {approve} that can be used as a mitigation for
805      * problems described in {IERC20-approve}.
806      *
807      * Emits an {Approval} event indicating the updated allowance.
808      *
809      * Requirements:
810      *
811      * - `spender` cannot be the zero address.
812      * - `spender` must have allowance for the caller of at least
813      * `subtractedValue`.
814      */
815     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
816         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
817         return true;
818     }
819 
820     /**
821      * @dev Moves tokens `amount` from `sender` to `recipient`.
822      *
823      * This is internal function is equivalent to {transfer}, and can be used to
824      * e.g. implement automatic token fees, slashing mechanisms, etc.
825      *
826      * Emits a {Transfer} event.
827      *
828      * Requirements:
829      *
830      * - `sender` cannot be the zero address.
831      * - `recipient` cannot be the zero address.
832      * - `sender` must have a balance of at least `amount`.
833      */
834     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
835         require(sender != address(0), "ERC20: transfer from the zero address");
836         require(recipient != address(0), "ERC20: transfer to the zero address");
837 
838         _beforeTokenTransfer(sender, recipient, amount);
839 
840         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
841         _balances[recipient] = _balances[recipient].add(amount);
842         emit Transfer(sender, recipient, amount);
843     }
844 
845     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
846      * the total supply.
847      *
848      * Emits a {Transfer} event with `from` set to the zero address.
849      *
850      * Requirements
851      *
852      * - `to` cannot be the zero address.
853      */
854     function _mint(address account, uint256 amount) internal virtual {
855         require(account != address(0), "ERC20: mint to the zero address");
856 
857         _beforeTokenTransfer(address(0), account, amount);
858 
859         _totalSupply = _totalSupply.add(amount);
860         _balances[account] = _balances[account].add(amount);
861         emit Transfer(address(0), account, amount);
862     }
863 
864     /**
865      * @dev Destroys `amount` tokens from `account`, reducing the
866      * total supply.
867      *
868      * Emits a {Transfer} event with `to` set to the zero address.
869      *
870      * Requirements
871      *
872      * - `account` cannot be the zero address.
873      * - `account` must have at least `amount` tokens.
874      */
875     function _burn(address account, uint256 amount) internal virtual {
876         require(account != address(0), "ERC20: burn from the zero address");
877 
878         _beforeTokenTransfer(account, address(0), amount);
879 
880         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
881         _totalSupply = _totalSupply.sub(amount);
882         emit Transfer(account, address(0), amount);
883     }
884 
885     /**
886      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
887      *
888      * This internal function is equivalent to `approve`, and can be used to
889      * e.g. set automatic allowances for certain subsystems, etc.
890      *
891      * Emits an {Approval} event.
892      *
893      * Requirements:
894      *
895      * - `owner` cannot be the zero address.
896      * - `spender` cannot be the zero address.
897      */
898     function _approve(address owner, address spender, uint256 amount) internal virtual {
899         require(owner != address(0), "ERC20: approve from the zero address");
900         require(spender != address(0), "ERC20: approve to the zero address");
901 
902         _allowances[owner][spender] = amount;
903         emit Approval(owner, spender, amount);
904     }
905 
906     /**
907      * @dev Sets {decimals} to a value other than the default one of 18.
908      *
909      * WARNING: This function should only be called from the constructor. Most
910      * applications that interact with token contracts will not expect
911      * {decimals} to ever change, and may work incorrectly if it does.
912      */
913     function _setupDecimals(uint8 decimals_) internal {
914         _decimals = decimals_;
915     }
916 
917     /**
918      * @dev Hook that is called before any transfer of tokens. This includes
919      * minting and burning.
920      *
921      * Calling conditions:
922      *
923      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
924      * will be to transferred to `to`.
925      * - when `from` is zero, `amount` tokens will be minted for `to`.
926      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
927      * - `from` and `to` are never both zero.
928      *
929      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
930      */
931     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
932 }
933 
934 // File contracts/ForefrontMerkle.sol
935 
936 // SPDX-License-Identifier: UNLICENSED
937 pragma solidity ^0.6.5;
938 
939 
940 
941 
942 
943 contract ForefrontMerkle is IMerkleDistributor, Ownable {
944     address public immutable override token;
945     bytes32 public immutable override merkleRoot;
946 
947     event Withdraw(uint256 amount, address recipient);
948 
949     // This is a packed array of booleans.
950     mapping(uint256 => uint256) private claimedBitMap;
951 
952     constructor(address token_, bytes32 merkleRoot_) public {
953         token = token_;
954         merkleRoot = merkleRoot_;
955     }
956 
957     function isClaimed(uint256 index) public view override returns (bool) {
958         uint256 claimedWordIndex = index / 256;
959         uint256 claimedBitIndex = index % 256;
960         uint256 claimedWord = claimedBitMap[claimedWordIndex];
961         uint256 mask = (1 << claimedBitIndex);
962         return claimedWord & mask == mask;
963     }
964 
965     function _setClaimed(uint256 index) private {
966         uint256 claimedWordIndex = index / 256;
967         uint256 claimedBitIndex = index % 256;
968         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
969     }
970 
971     function claim(uint256 index, address account, uint256 amount, bytes32[] calldata merkleProof) external override {
972         require(!isClaimed(index), 'MerkleDistributor: Drop already claimed.');
973 
974         // Verify the merkle proof.
975         bytes32 node = keccak256(abi.encodePacked(index, account, amount));
976         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'MerkleDistributor: Invalid proof.');
977 
978         // Mark it claimed and send the token.
979         _setClaimed(index);
980         require(IERC20(token).transfer(account, amount), 'MerkleDistributor: Transfer failed.');
981 
982         emit Claimed(index, account, amount);
983     }
984 
985     // Allows the authorized user to reclaim the tokens deposited in this contract
986     function withdraw(address recipient) public onlyOwner() {
987         require(
988             IERC20(token).transfer(recipient, IERC20(token).balanceOf(address(this))),
989             'MerkleDistributor: Withdraw transfer failed.'
990         );
991         emit Withdraw(IERC20(token).balanceOf(address(this)), recipient);
992     }
993 
994     function totalSupply() view public returns(uint256) {
995         return IERC20(token).balanceOf(address(this));
996     }
997 
998 }