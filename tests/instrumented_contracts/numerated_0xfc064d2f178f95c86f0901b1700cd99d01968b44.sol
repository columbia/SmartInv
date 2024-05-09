1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/math/SafeMath.sol
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      *
29      * - Addition cannot overflow.
30      */
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the subtraction of two unsigned integers, reverting on
40      * overflow (when the result is negative).
41      *
42      * Counterpart to Solidity's `-` operator.
43      *
44      * Requirements:
45      *
46      * - Subtraction cannot overflow.
47      */
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     /**
53      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
54      * overflow (when the result is negative).
55      *
56      * Counterpart to Solidity's `-` operator.
57      *
58      * Requirements:
59      *
60      * - Subtraction cannot overflow.
61      */
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70      * @dev Returns the multiplication of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `*` operator.
74      *
75      * Requirements:
76      *
77      * - Multiplication cannot overflow.
78      */
79     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
80         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
81         // benefit is lost if 'b' is also tested.
82         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
83         if (a == 0) {
84             return 0;
85         }
86 
87         uint256 c = a * b;
88         require(c / a == b, "SafeMath: multiplication overflow");
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the integer division of two unsigned integers. Reverts on
95      * division by zero. The result is rounded towards zero.
96      *
97      * Counterpart to Solidity's `/` operator. Note: this function uses a
98      * `revert` opcode (which leaves remaining gas untouched) while Solidity
99      * uses an invalid opcode to revert (consuming all remaining gas).
100      *
101      * Requirements:
102      *
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      *
119      * - The divisor cannot be zero.
120      */
121     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
122         require(b > 0, errorMessage);
123         uint256 c = a / b;
124         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
125 
126         return c;
127     }
128 
129     /**
130      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
131      * Reverts when dividing by zero.
132      *
133      * Counterpart to Solidity's `%` operator. This function uses a `revert`
134      * opcode (which leaves remaining gas untouched) while Solidity uses an
135      * invalid opcode to revert (consuming all remaining gas).
136      *
137      * Requirements:
138      *
139      * - The divisor cannot be zero.
140      */
141     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
142         return mod(a, b, "SafeMath: modulo by zero");
143     }
144 
145     /**
146      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
147      * Reverts with custom message when dividing by zero.
148      *
149      * Counterpart to Solidity's `%` operator. This function uses a `revert`
150      * opcode (which leaves remaining gas untouched) while Solidity uses an
151      * invalid opcode to revert (consuming all remaining gas).
152      *
153      * Requirements:
154      *
155      * - The divisor cannot be zero.
156      */
157     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
158         require(b != 0, errorMessage);
159         return a % b;
160     }
161 }
162 
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 pragma solidity ^0.6.0;
166 
167 /**
168  * @dev Interface of the ERC20 standard as defined in the EIP.
169  */
170 interface IERC20 {
171     /**
172      * @dev Returns the amount of tokens in existence.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 }
240 
241 // File: @openzeppelin/contracts/utils/Address.sol
242 
243 pragma solidity ^0.6.2;
244 
245 /**
246  * @dev Collection of functions related to the address type
247  */
248 library Address {
249     /**
250      * @dev Returns true if `account` is a contract.
251      *
252      * [IMPORTANT]
253      * ====
254      * It is unsafe to assume that an address for which this function returns
255      * false is an externally-owned account (EOA) and not a contract.
256      *
257      * Among others, `isContract` will return false for the following
258      * types of addresses:
259      *
260      *  - an externally-owned account
261      *  - a contract in construction
262      *  - an address where a contract will be created
263      *  - an address where a contract lived, but was destroyed
264      * ====
265      */
266     function isContract(address account) internal view returns (bool) {
267         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
268         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
269         // for accounts without code, i.e. `keccak256('')`
270         bytes32 codehash;
271         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
272         // solhint-disable-next-line no-inline-assembly
273         assembly { codehash := extcodehash(account) }
274         return (codehash != accountHash && codehash != 0x0);
275     }
276 
277     /**
278      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
279      * `recipient`, forwarding all available gas and reverting on errors.
280      *
281      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
282      * of certain opcodes, possibly making contracts go over the 2300 gas limit
283      * imposed by `transfer`, making them unable to receive funds via
284      * `transfer`. {sendValue} removes this limitation.
285      *
286      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
384 
385 pragma solidity ^0.6.0;
386 
387 /**
388  * @title SafeERC20
389  * @dev Wrappers around ERC20 operations that throw on failure (when the token
390  * contract returns false). Tokens that return no value (and instead revert or
391  * throw on failure) are also supported, non-reverting calls are assumed to be
392  * successful.
393  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
394  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
395  */
396 library SafeERC20 {
397     using SafeMath for uint256;
398     using Address for address;
399 
400     function safeTransfer(IERC20 token, address to, uint256 value) internal {
401         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
402     }
403 
404     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
405         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
406     }
407 
408     /**
409      * @dev Deprecated. This function has issues similar to the ones found in
410      * {IERC20-approve}, and its usage is discouraged.
411      *
412      * Whenever possible, use {safeIncreaseAllowance} and
413      * {safeDecreaseAllowance} instead.
414      */
415     function safeApprove(IERC20 token, address spender, uint256 value) internal {
416         // safeApprove should only be called when setting an initial allowance,
417         // or when resetting it to zero. To increase and decrease it, use
418         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
419         // solhint-disable-next-line max-line-length
420         require((value == 0) || (token.allowance(address(this), spender) == 0),
421             "SafeERC20: approve from non-zero to non-zero allowance"
422         );
423         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
424     }
425 
426     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
427         uint256 newAllowance = token.allowance(address(this), spender).add(value);
428         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
429     }
430 
431     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
432         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
433         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
434     }
435 
436     /**
437      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
438      * on the return value: the return value is optional (but if data is returned, it must not be false).
439      * @param token The token targeted by the call.
440      * @param data The call data (encoded using abi.encode or one of its variants).
441      */
442     function _callOptionalReturn(IERC20 token, bytes memory data) private {
443         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
444         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
445         // the target address contains contract code and also asserts for success in the low-level call.
446 
447         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
448         if (returndata.length > 0) { // Return data is optional
449             // solhint-disable-next-line max-line-length
450             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
451         }
452     }
453 }
454 
455 // File: @openzeppelin/contracts/GSN/Context.sol
456 
457 pragma solidity ^0.6.0;
458 
459 /*
460  * @dev Provides information about the current execution context, including the
461  * sender of the transaction and its data. While these are generally available
462  * via msg.sender and msg.data, they should not be accessed in such a direct
463  * manner, since when dealing with GSN meta-transactions the account sending and
464  * paying for execution may not be the actual sender (as far as an application
465  * is concerned).
466  *
467  * This contract is only required for intermediate, library-like contracts.
468  */
469 abstract contract Context {
470     function _msgSender() internal view virtual returns (address payable) {
471         return msg.sender;
472     }
473 
474     function _msgData() internal view virtual returns (bytes memory) {
475         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
476         return msg.data;
477     }
478 }
479 
480 // File: @openzeppelin/contracts/access/Ownable.sol
481 
482 pragma solidity ^0.6.0;
483 
484 /**
485  * @dev Contract module which provides a basic access control mechanism, where
486  * there is an account (an owner) that can be granted exclusive access to
487  * specific functions.
488  *
489  * By default, the owner account will be the one that deploys the contract. This
490  * can later be changed with {transferOwnership}.
491  *
492  * This module is used through inheritance. It will make available the modifier
493  * `onlyOwner`, which can be applied to your functions to restrict their use to
494  * the owner.
495  */
496 contract Ownable is Context {
497     address private _owner;
498 
499     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
500 
501     /**
502      * @dev Initializes the contract setting the deployer as the initial owner.
503      */
504     constructor () internal {
505         address msgSender = _msgSender();
506         _owner = msgSender;
507         emit OwnershipTransferred(address(0), msgSender);
508     }
509 
510     /**
511      * @dev Returns the address of the current owner.
512      */
513     function owner() public view returns (address) {
514         return _owner;
515     }
516 
517     /**
518      * @dev Throws if called by any account other than the owner.
519      */
520     modifier onlyOwner() {
521         require(_owner == _msgSender(), "Ownable: caller is not the owner");
522         _;
523     }
524 
525     /**
526      * @dev Leaves the contract without owner. It will not be possible to call
527      * `onlyOwner` functions anymore. Can only be called by the current owner.
528      *
529      * NOTE: Renouncing ownership will leave the contract without an owner,
530      * thereby removing any functionality that is only available to the owner.
531      */
532     function renounceOwnership() public virtual onlyOwner {
533         emit OwnershipTransferred(_owner, address(0));
534         _owner = address(0);
535     }
536 
537     /**
538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
539      * Can only be called by the current owner.
540      */
541     function transferOwnership(address newOwner) public virtual onlyOwner {
542         require(newOwner != address(0), "Ownable: new owner is the zero address");
543         emit OwnershipTransferred(_owner, newOwner);
544         _owner = newOwner;
545     }
546 }
547 
548 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
549 
550 pragma solidity ^0.6.0;
551 
552 /**
553  * @dev Contract module that helps prevent reentrant calls to a function.
554  *
555  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
556  * available, which can be applied to functions to make sure there are no nested
557  * (reentrant) calls to them.
558  *
559  * Note that because there is a single `nonReentrant` guard, functions marked as
560  * `nonReentrant` may not call one another. This can be worked around by making
561  * those functions `private`, and then adding `external` `nonReentrant` entry
562  * points to them.
563  *
564  * TIP: If you would like to learn more about reentrancy and alternative ways
565  * to protect against it, check out our blog post
566  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
567  */
568 contract ReentrancyGuard {
569     // Booleans are more expensive than uint256 or any type that takes up a full
570     // word because each write operation emits an extra SLOAD to first read the
571     // slot's contents, replace the bits taken up by the boolean, and then write
572     // back. This is the compiler's defense against contract upgrades and
573     // pointer aliasing, and it cannot be disabled.
574 
575     // The values being non-zero value makes deployment a bit more expensive,
576     // but in exchange the refund on every call to nonReentrant will be lower in
577     // amount. Since refunds are capped to a percentage of the total
578     // transaction's gas, it is best to keep them low in cases like this one, to
579     // increase the likelihood of the full refund coming into effect.
580     uint256 private constant _NOT_ENTERED = 1;
581     uint256 private constant _ENTERED = 2;
582 
583     uint256 private _status;
584 
585     constructor () internal {
586         _status = _NOT_ENTERED;
587     }
588 
589     /**
590      * @dev Prevents a contract from calling itself, directly or indirectly.
591      * Calling a `nonReentrant` function from another `nonReentrant`
592      * function is not supported. It is possible to prevent this from happening
593      * by making the `nonReentrant` function external, and make it call a
594      * `private` function that does the actual work.
595      */
596     modifier nonReentrant() {
597         // On the first call to nonReentrant, _notEntered will be true
598         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
599 
600         // Any calls to nonReentrant after this point will fail
601         _status = _ENTERED;
602 
603         _;
604 
605         // By storing the original value once again, a refund is triggered (see
606         // https://eips.ethereum.org/EIPS/eip-2200)
607         _status = _NOT_ENTERED;
608     }
609 }
610 
611 // File: contracts/IStaking.sol
612 
613 /*
614 Staking interface
615 
616 EIP-900 staking interface
617 
618 https://github.com/gysr-io/core
619 
620 h/t https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
621 
622 */
623 
624 pragma solidity ^0.6.12;
625 
626 interface IStaking {
627     // events
628     event Staked(
629         address indexed user,
630         uint256 amount,
631         uint256 total,
632         bytes data
633     );
634     event Unstaked(
635         address indexed user,
636         uint256 amount,
637         uint256 total,
638         bytes data
639     );
640 
641     /**
642      * @notice stakes a certain amount of tokens, transferring this amount from
643      the user to the contract
644      * @param amount number of tokens to stake
645      */
646     function stake(uint256 amount, bytes calldata) external;
647 
648     /**
649      * @notice stakes a certain amount of tokens for an address, transfering this
650      amount from the caller to the contract, on behalf of the specified address
651      * @param user beneficiary address
652      * @param amount number of tokens to stake
653      */
654     function stakeFor(
655         address user,
656         uint256 amount,
657         bytes calldata
658     ) external;
659 
660     /**
661      * @notice unstakes a certain amount of tokens, returning these tokens
662      to the user
663      * @param amount number of tokens to unstake
664      */
665     function unstake(uint256 amount, bytes calldata) external;
666 
667     /**
668      * @param addr the address of interest
669      * @return the current total of tokens staked for an address
670      */
671     function totalStakedFor(address addr) external view returns (uint256);
672 
673     /**
674      * @return the current total amount of tokens staked by all users
675      */
676     function totalStaked() external view returns (uint256);
677 
678     /**
679      * @return the staking token for this staking contract
680      */
681     function token() external view returns (address);
682 
683     /**
684      * @return true if the staking contract support history
685      */
686     function supportsHistory() external pure returns (bool);
687 }
688 
689 // File: contracts/IGeyser.sol
690 
691 /*
692 Geyser interface
693 
694 This defines the core Geyser contract interface as an extension to the
695 standard IStaking interface
696 
697 https://github.com/gysr-io/core
698 
699 */
700 
701 pragma solidity ^0.6.12;
702 
703 /**
704  * @title Geyser interface
705  */
706 abstract contract IGeyser is IStaking, Ownable {
707     // events
708     event RewardsDistributed(address indexed user, uint256 amount);
709     event RewardsFunded(
710         uint256 amount,
711         uint256 duration,
712         uint256 start,
713         uint256 total
714     );
715     event RewardsUnlocked(uint256 amount, uint256 total);
716     event RewardsExpired(uint256 amount, uint256 duration, uint256 start);
717     event GysrSpent(address indexed user, uint256 amount);
718     event GysrWithdrawn(uint256 amount);
719 
720     // IStaking
721     /**
722      * @notice no support for history
723      * @return false
724      */
725     function supportsHistory() external override pure returns (bool) {
726         return false;
727     }
728 
729     // IGeyser
730     /**
731      * @return staking token for this Geyser
732      */
733     function stakingToken() external virtual view returns (address);
734 
735     /**
736      * @return reward token for this Geyser
737      */
738     function rewardToken() external virtual view returns (address);
739 
740     /**
741      * @notice fund Geyser by locking up reward tokens for distribution
742      * @param amount number of reward tokens to lock up as funding
743      * @param duration period (seconds) over which funding will be unlocked
744      */
745     function fund(uint256 amount, uint256 duration) external virtual;
746 
747     /**
748      * @notice fund Geyser by locking up reward tokens for future distribution
749      * @param amount number of reward tokens to lock up as funding
750      * @param duration period (seconds) over which funding will be unlocked
751      * @param start time (seconds) at which funding begins to unlock
752      */
753     function fund(
754         uint256 amount,
755         uint256 duration,
756         uint256 start
757     ) external virtual;
758 
759     /**
760      * @notice withdraw GYSR tokens applied during unstaking
761      * @param amount number of GYSR to withdraw
762      */
763     function withdraw(uint256 amount) external virtual;
764 
765     /**
766      * @notice unstake while applying GYSR token for boosted rewards
767      * @param amount number of tokens to unstake
768      * @param gysr number of GYSR tokens to apply for boost
769      */
770     function unstake(
771         uint256 amount,
772         uint256 gysr,
773         bytes calldata
774     ) external virtual;
775 
776     /**
777      * @notice update accounting, unlock tokens, etc.
778      */
779     function update() external virtual;
780 
781     /**
782      * @notice clean geyser, expire old fundings, etc.
783      */
784     function clean() external virtual;
785 }
786 
787 // File: contracts/GeyserPool.sol
788 
789 /*
790 Geyser token pool
791 
792 Simple contract to implement token pool of arbitrary ERC20 token.
793 This is owned and used by a parent Geyser
794 
795 https://github.com/gysr-io/core
796 
797 h/t https://github.com/ampleforth/token-geyser
798 
799 */
800 
801 pragma solidity ^0.6.12;
802 
803 contract GeyserPool is Ownable {
804     using SafeERC20 for IERC20;
805 
806     IERC20 public token;
807 
808     constructor(address token_) public {
809         token = IERC20(token_);
810     }
811 
812     function balance() public view returns (uint256) {
813         return token.balanceOf(address(this));
814     }
815 
816     function transfer(address to, uint256 value) external onlyOwner {
817         token.safeTransfer(to, value);
818     }
819 }
820 
821 // File: contracts/MathUtils.sol
822 
823 /*
824 Math utilities
825 
826 This library implements various logarithmic math utilies which support
827 other contracts and specifically the GYSR multiplier calculation
828 
829 https://github.com/gysr-io/core
830 
831 h/t https://github.com/abdk-consulting/abdk-libraries-solidity
832 
833 */
834 
835 pragma solidity ^0.6.12;
836 
837 library MathUtils {
838     /**
839      * Calculate binary logarithm of x.  Revert if x <= 0.
840      *
841      * @param x signed 64.64-bit fixed point number
842      * @return signed 64.64-bit fixed point number
843      */
844     function logbase2(int128 x) internal pure returns (int128) {
845         require(x > 0);
846 
847         int256 msb = 0;
848         int256 xc = x;
849         if (xc >= 0x10000000000000000) {
850             xc >>= 64;
851             msb += 64;
852         }
853         if (xc >= 0x100000000) {
854             xc >>= 32;
855             msb += 32;
856         }
857         if (xc >= 0x10000) {
858             xc >>= 16;
859             msb += 16;
860         }
861         if (xc >= 0x100) {
862             xc >>= 8;
863             msb += 8;
864         }
865         if (xc >= 0x10) {
866             xc >>= 4;
867             msb += 4;
868         }
869         if (xc >= 0x4) {
870             xc >>= 2;
871             msb += 2;
872         }
873         if (xc >= 0x2) msb += 1; // No need to shift xc anymore
874 
875         int256 result = (msb - 64) << 64;
876         uint256 ux = uint256(x) << (127 - msb);
877         for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
878             ux *= ux;
879             uint256 b = ux >> 255;
880             ux >>= 127 + b;
881             result += bit * int256(b);
882         }
883 
884         return int128(result);
885     }
886 
887     /**
888      * @notice calculate natural logarithm of x
889      * @dev magic constant comes from ln(2) * 2^128 -> hex
890      * @param x signed 64.64-bit fixed point number, require x > 0
891      * @return signed 64.64-bit fixed point number
892      */
893     function ln(int128 x) internal pure returns (int128) {
894         require(x > 0);
895 
896         return
897             int128(
898                 (uint256(logbase2(x)) * 0xB17217F7D1CF79ABC9E3B39803F2F6AF) >>
899                     128
900             );
901     }
902 
903     /**
904      * @notice calculate logarithm base 10 of x
905      * @dev magic constant comes from log10(2) * 2^128 -> hex
906      * @param x signed 64.64-bit fixed point number, require x > 0
907      * @return signed 64.64-bit fixed point number
908      */
909     function logbase10(int128 x) internal pure returns (int128) {
910         require(x > 0);
911 
912         return
913             int128(
914                 (uint256(logbase2(x)) * 0x4d104d427de7fce20a6e420e02236748) >>
915                     128
916             );
917     }
918 
919     // wrapper functions to allow testing
920     function testlogbase2(int128 x) public pure returns (int128) {
921         return logbase2(x);
922     }
923 
924     function testlogbase10(int128 x) public pure returns (int128) {
925         return logbase10(x);
926     }
927 }
928 
929 // File: contracts/Geyser.sol
930 
931 /*
932 Geyser
933 
934 This implements the core Geyser contract, which allows for generalized
935 staking, yield farming, and token distribution. This also implements
936 the GYSR spending mechanic for boosted reward distribution.
937 
938 https://github.com/gysr-io/core
939 
940 h/t https://github.com/ampleforth/token-geyser
941 */
942 
943 pragma solidity ^0.6.12;
944 
945 /**
946  * @title Geyser
947  */
948 contract Geyser is IGeyser, ReentrancyGuard {
949     using SafeMath for uint256;
950     using SafeERC20 for IERC20;
951     using MathUtils for int128;
952 
953     // single stake by user
954     struct Stake {
955         uint256 shares;
956         uint256 timestamp;
957     }
958 
959     // summary of total user stake/shares
960     struct User {
961         uint256 shares;
962         uint256 shareSeconds;
963         uint256 lastUpdated;
964     }
965 
966     // single funding/reward schedule
967     struct Funding {
968         uint256 amount;
969         uint256 shares;
970         uint256 unlocked;
971         uint256 lastUpdated;
972         uint256 start;
973         uint256 end;
974         uint256 duration;
975     }
976 
977     // constants
978     uint256 public constant BONUS_DECIMALS = 18;
979     uint256 public constant INITIAL_SHARES_PER_TOKEN = 10**6;
980     uint256 public constant MAX_ACTIVE_FUNDINGS = 16;
981 
982     // token pool fields
983     GeyserPool private immutable _stakingPool;
984     GeyserPool private immutable _unlockedPool;
985     GeyserPool private immutable _lockedPool;
986     Funding[] public fundings;
987 
988     // user staking fields
989     mapping(address => User) public userTotals;
990     mapping(address => Stake[]) public userStakes;
991 
992     // time bonus fields
993     uint256 public immutable bonusMin;
994     uint256 public immutable bonusMax;
995     uint256 public immutable bonusPeriod;
996 
997     // global state fields
998     uint256 public totalLockedShares;
999     uint256 public totalStakingShares;
1000     uint256 public totalRewards;
1001     uint256 public totalGysrRewards;
1002     uint256 public totalStakingShareSeconds;
1003     uint256 public lastUpdated;
1004 
1005     // gysr fields
1006     IERC20 private immutable _gysr;
1007 
1008     /**
1009      * @param stakingToken_ the token that will be staked
1010      * @param rewardToken_ the token distributed to users as they unstake
1011      * @param bonusMin_ initial time bonus
1012      * @param bonusMax_ maximum time bonus
1013      * @param bonusPeriod_ period (in seconds) over which time bonus grows to max
1014      * @param gysr_ address for GYSR token
1015      */
1016     constructor(
1017         address stakingToken_,
1018         address rewardToken_,
1019         uint256 bonusMin_,
1020         uint256 bonusMax_,
1021         uint256 bonusPeriod_,
1022         address gysr_
1023     ) public {
1024         require(
1025             bonusMin_ <= bonusMax_,
1026             "Geyser: initial time bonus greater than max"
1027         );
1028 
1029         _stakingPool = new GeyserPool(stakingToken_);
1030         _unlockedPool = new GeyserPool(rewardToken_);
1031         _lockedPool = new GeyserPool(rewardToken_);
1032 
1033         bonusMin = bonusMin_;
1034         bonusMax = bonusMax_;
1035         bonusPeriod = bonusPeriod_;
1036 
1037         _gysr = IERC20(gysr_);
1038 
1039         lastUpdated = block.timestamp;
1040     }
1041 
1042     // IStaking
1043 
1044     /**
1045      * @inheritdoc IStaking
1046      */
1047     function stake(uint256 amount, bytes calldata) external override {
1048         _stake(msg.sender, msg.sender, amount);
1049     }
1050 
1051     /**
1052      * @inheritdoc IStaking
1053      */
1054     function stakeFor(
1055         address user,
1056         uint256 amount,
1057         bytes calldata
1058     ) external override {
1059         _stake(msg.sender, user, amount);
1060     }
1061 
1062     /**
1063      * @inheritdoc IStaking
1064      */
1065     function unstake(uint256 amount, bytes calldata) external override {
1066         _unstake(amount, 0);
1067     }
1068 
1069     /**
1070      * @inheritdoc IStaking
1071      */
1072     function totalStakedFor(address addr)
1073         public
1074         override
1075         view
1076         returns (uint256)
1077     {
1078         if (totalStakingShares == 0) {
1079             return 0;
1080         }
1081         return
1082             totalStaked().mul(userTotals[addr].shares).div(totalStakingShares);
1083     }
1084 
1085     /**
1086      * @inheritdoc IStaking
1087      */
1088     function totalStaked() public override view returns (uint256) {
1089         return _stakingPool.balance();
1090     }
1091 
1092     /**
1093      * @inheritdoc IStaking
1094      * @dev redundant with stakingToken() in order to implement IStaking (EIP-900)
1095      */
1096     function token() external override view returns (address) {
1097         return address(_stakingPool.token());
1098     }
1099 
1100     // IGeyser
1101 
1102     /**
1103      * @inheritdoc IGeyser
1104      */
1105     function stakingToken() public override view returns (address) {
1106         return address(_stakingPool.token());
1107     }
1108 
1109     /**
1110      * @inheritdoc IGeyser
1111      */
1112     function rewardToken() public override view returns (address) {
1113         return address(_unlockedPool.token());
1114     }
1115 
1116     /**
1117      * @inheritdoc IGeyser
1118      */
1119     function fund(uint256 amount, uint256 duration) public override {
1120         fund(amount, duration, block.timestamp);
1121     }
1122 
1123     /**
1124      * @inheritdoc IGeyser
1125      */
1126     function fund(
1127         uint256 amount,
1128         uint256 duration,
1129         uint256 start
1130     ) public override onlyOwner {
1131         // validate
1132         require(amount > 0, "Geyser: funding amount is zero");
1133         require(start >= block.timestamp, "Geyser: funding start is past");
1134         require(
1135             fundings.length < MAX_ACTIVE_FUNDINGS,
1136             "Geyser: exceeds max active funding schedules"
1137         );
1138 
1139         // update bookkeeping
1140         _update(msg.sender);
1141 
1142         // mint shares at current rate
1143         uint256 lockedTokens = totalLocked();
1144         uint256 mintedLockedShares = (lockedTokens > 0)
1145             ? totalLockedShares.mul(amount).div(lockedTokens)
1146             : amount.mul(INITIAL_SHARES_PER_TOKEN);
1147 
1148         totalLockedShares = totalLockedShares.add(mintedLockedShares);
1149 
1150         // create new funding
1151         fundings.push(
1152             Funding({
1153                 amount: amount,
1154                 shares: mintedLockedShares,
1155                 unlocked: 0,
1156                 lastUpdated: start,
1157                 start: start,
1158                 end: start.add(duration),
1159                 duration: duration
1160             })
1161         );
1162 
1163         // do transfer of funding
1164         _lockedPool.token().safeTransferFrom(
1165             msg.sender,
1166             address(_lockedPool),
1167             amount
1168         );
1169         emit RewardsFunded(amount, duration, start, totalLocked());
1170     }
1171 
1172     /**
1173      * @inheritdoc IGeyser
1174      */
1175     function withdraw(uint256 amount) external override onlyOwner {
1176         require(amount > 0, "Geyser: withdraw amount is zero");
1177         require(
1178             amount <= _gysr.balanceOf(address(this)),
1179             "Geyser: withdraw amount exceeds balance"
1180         );
1181         // do transfer
1182         _gysr.safeTransfer(msg.sender, amount);
1183 
1184         emit GysrWithdrawn(amount);
1185     }
1186 
1187     /**
1188      * @inheritdoc IGeyser
1189      */
1190     function unstake(
1191         uint256 amount,
1192         uint256 gysr,
1193         bytes calldata
1194     ) external override {
1195         _unstake(amount, gysr);
1196     }
1197 
1198     /**
1199      * @inheritdoc IGeyser
1200      */
1201     function update() external override nonReentrant {
1202         _update(msg.sender);
1203     }
1204 
1205     /**
1206      * @inheritdoc IGeyser
1207      */
1208     function clean() external override onlyOwner {
1209         // update bookkeeping
1210         _update(msg.sender);
1211 
1212         // check for stale funding schedules to expire
1213         uint256 removed = 0;
1214         uint256 originalSize = fundings.length;
1215         for (uint256 i = 0; i < originalSize; i++) {
1216             Funding storage funding = fundings[i.sub(removed)];
1217             uint256 idx = i.sub(removed);
1218 
1219             if (_unlockable(idx) == 0 && block.timestamp >= funding.end) {
1220                 emit RewardsExpired(
1221                     funding.amount,
1222                     funding.duration,
1223                     funding.start
1224                 );
1225 
1226                 // remove at idx by copying last element here, then popping off last
1227                 // (we don't care about order)
1228                 fundings[idx] = fundings[fundings.length.sub(1)];
1229                 fundings.pop();
1230                 removed = removed.add(1);
1231             }
1232         }
1233     }
1234 
1235     // Geyser
1236 
1237     /**
1238      * @dev internal implementation of staking methods
1239      * @param staker address to do deposit of staking tokens
1240      * @param beneficiary address to gain credit for this stake operation
1241      * @param amount number of staking tokens to deposit
1242      */
1243     function _stake(
1244         address staker,
1245         address beneficiary,
1246         uint256 amount
1247     ) private nonReentrant {
1248         // validate
1249         require(amount > 0, "Geyser: stake amount is zero");
1250         require(
1251             beneficiary != address(0),
1252             "Geyser: beneficiary is zero address"
1253         );
1254 
1255         // mint staking shares at current rate
1256         uint256 mintedStakingShares = (totalStakingShares > 0)
1257             ? totalStakingShares.mul(amount).div(totalStaked())
1258             : amount.mul(INITIAL_SHARES_PER_TOKEN);
1259         require(mintedStakingShares > 0, "Geyser: stake amount too small");
1260 
1261         // update bookkeeping
1262         _update(beneficiary);
1263 
1264         // update user staking info
1265         User storage user = userTotals[beneficiary];
1266         user.shares = user.shares.add(mintedStakingShares);
1267         user.lastUpdated = block.timestamp;
1268 
1269         userStakes[beneficiary].push(
1270             Stake(mintedStakingShares, block.timestamp)
1271         );
1272 
1273         // add newly minted shares to global total
1274         totalStakingShares = totalStakingShares.add(mintedStakingShares);
1275 
1276         // transactions
1277         _stakingPool.token().safeTransferFrom(
1278             staker,
1279             address(_stakingPool),
1280             amount
1281         );
1282 
1283         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
1284     }
1285 
1286     /**
1287      * @dev internal implementation of unstaking methods
1288      * @param amount number of tokens to unstake
1289      * @param gysr number of GYSR tokens applied to unstaking operation
1290      * @return number of reward tokens distributed
1291      */
1292     function _unstake(uint256 amount, uint256 gysr)
1293         private
1294         nonReentrant
1295         returns (uint256)
1296     {
1297         // validate
1298         require(amount > 0, "Geyser: unstake amount is zero");
1299         require(
1300             totalStakedFor(msg.sender) >= amount,
1301             "Geyser: unstake amount exceeds balance"
1302         );
1303 
1304         // update bookkeeping
1305         _update(msg.sender);
1306 
1307         // do unstaking, first-in last-out, respecting time bonus
1308         uint256 timeWeightedShareSeconds = _unstakeFirstInLastOut(amount);
1309 
1310         // compute and apply GYSR token bonus
1311         uint256 gysrWeightedShareSeconds = gysrBonus(gysr)
1312             .mul(timeWeightedShareSeconds)
1313             .div(10**BONUS_DECIMALS);
1314 
1315         uint256 rewardAmount = totalUnlocked()
1316             .mul(gysrWeightedShareSeconds)
1317             .div(totalStakingShareSeconds.add(gysrWeightedShareSeconds));
1318 
1319         // update global stats for distributions
1320         if (gysr > 0) {
1321             totalGysrRewards = totalGysrRewards.add(rewardAmount);
1322         }
1323         totalRewards = totalRewards.add(rewardAmount);
1324 
1325         // transactions
1326         _stakingPool.transfer(msg.sender, amount);
1327         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
1328         if (rewardAmount > 0) {
1329             _unlockedPool.transfer(msg.sender, rewardAmount);
1330             emit RewardsDistributed(msg.sender, rewardAmount);
1331         }
1332         if (gysr > 0) {
1333             _gysr.safeTransferFrom(msg.sender, address(this), gysr);
1334             emit GysrSpent(msg.sender, gysr);
1335         }
1336         return rewardAmount;
1337     }
1338 
1339     /**
1340      * @dev helper function to actually execute unstaking, first-in last-out, 
1341      while computing and applying time bonus. This function also updates
1342      user and global totals for shares and share-seconds.
1343      * @param amount number of staking tokens to withdraw
1344      * @return time bonus weighted staking share seconds
1345      */
1346     function _unstakeFirstInLastOut(uint256 amount) private returns (uint256) {
1347         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(
1348             totalStaked()
1349         );
1350         require(stakingSharesToBurn > 0, "Geyser: unstake amount too small");
1351 
1352         // redeem from most recent stake and go backwards in time.
1353         uint256 shareSecondsToBurn = 0;
1354         uint256 sharesLeftToBurn = stakingSharesToBurn;
1355         uint256 bonusWeightedShareSeconds = 0;
1356         Stake[] storage stakes = userStakes[msg.sender];
1357         while (sharesLeftToBurn > 0) {
1358             Stake storage lastStake = stakes[stakes.length - 1];
1359             uint256 stakeTime = block.timestamp.sub(lastStake.timestamp);
1360 
1361             uint256 bonus = timeBonus(stakeTime);
1362 
1363             if (lastStake.shares <= sharesLeftToBurn) {
1364                 // fully redeem a past stake
1365                 bonusWeightedShareSeconds = bonusWeightedShareSeconds.add(
1366                     lastStake.shares.mul(stakeTime).mul(bonus).div(
1367                         10**BONUS_DECIMALS
1368                     )
1369                 );
1370                 shareSecondsToBurn = shareSecondsToBurn.add(
1371                     lastStake.shares.mul(stakeTime)
1372                 );
1373                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.shares);
1374                 stakes.pop();
1375             } else {
1376                 // partially redeem a past stake
1377                 bonusWeightedShareSeconds = bonusWeightedShareSeconds.add(
1378                     sharesLeftToBurn.mul(stakeTime).mul(bonus).div(
1379                         10**BONUS_DECIMALS
1380                     )
1381                 );
1382                 shareSecondsToBurn = shareSecondsToBurn.add(
1383                     sharesLeftToBurn.mul(stakeTime)
1384                 );
1385                 lastStake.shares = lastStake.shares.sub(sharesLeftToBurn);
1386                 sharesLeftToBurn = 0;
1387             }
1388         }
1389         // update user totals
1390         User storage user = userTotals[msg.sender];
1391         user.shareSeconds = user.shareSeconds.sub(shareSecondsToBurn);
1392         user.shares = user.shares.sub(stakingSharesToBurn);
1393         user.lastUpdated = block.timestamp;
1394 
1395         // update global totals
1396         totalStakingShareSeconds = totalStakingShareSeconds.sub(
1397             shareSecondsToBurn
1398         );
1399         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
1400 
1401         return bonusWeightedShareSeconds;
1402     }
1403 
1404     /**
1405      * @dev internal implementation of update method
1406      * @param addr address for user accounting update
1407      */
1408     function _update(address addr) private {
1409         _unlockTokens();
1410 
1411         // global accounting
1412         uint256 deltaTotalShareSeconds = (block.timestamp.sub(lastUpdated)).mul(
1413             totalStakingShares
1414         );
1415         totalStakingShareSeconds = totalStakingShareSeconds.add(
1416             deltaTotalShareSeconds
1417         );
1418         lastUpdated = block.timestamp;
1419 
1420         // user accounting
1421         User storage user = userTotals[addr];
1422         uint256 deltaUserShareSeconds = (block.timestamp.sub(user.lastUpdated))
1423             .mul(user.shares);
1424         user.shareSeconds = user.shareSeconds.add(deltaUserShareSeconds);
1425         user.lastUpdated = block.timestamp;
1426     }
1427 
1428     /**
1429      * @dev unlocks reward tokens based on funding schedules
1430      */
1431     function _unlockTokens() private {
1432         uint256 tokensToUnlock = 0;
1433         uint256 lockedTokens = totalLocked();
1434 
1435         if (totalLockedShares == 0) {
1436             // handle any leftover
1437             tokensToUnlock = lockedTokens;
1438         } else {
1439             // normal case: unlock some shares from each funding schedule
1440             uint256 sharesToUnlock = 0;
1441             for (uint256 i = 0; i < fundings.length; i++) {
1442                 uint256 shares = _unlockable(i);
1443                 Funding storage funding = fundings[i];
1444                 if (shares > 0) {
1445                     funding.unlocked = funding.unlocked.add(shares);
1446                     funding.lastUpdated = block.timestamp;
1447                     sharesToUnlock = sharesToUnlock.add(shares);
1448                 }
1449             }
1450             tokensToUnlock = sharesToUnlock.mul(lockedTokens).div(
1451                 totalLockedShares
1452             );
1453             totalLockedShares = totalLockedShares.sub(sharesToUnlock);
1454         }
1455 
1456         if (tokensToUnlock > 0) {
1457             _lockedPool.transfer(address(_unlockedPool), tokensToUnlock);
1458             emit RewardsUnlocked(tokensToUnlock, totalUnlocked());
1459         }
1460     }
1461 
1462     /**
1463      * @dev helper function to compute updates to funding schedules
1464      * @param idx index of the funding
1465      * @return the number of unlockable shares
1466      */
1467     function _unlockable(uint256 idx) private view returns (uint256) {
1468         Funding storage funding = fundings[idx];
1469 
1470         // funding schedule is in future
1471         if (block.timestamp < funding.start) {
1472             return 0;
1473         }
1474         // empty
1475         if (funding.unlocked >= funding.shares) {
1476             return 0;
1477         }
1478         // handle zero-duration period or leftover dust from integer division
1479         if (block.timestamp >= funding.end) {
1480             return funding.shares.sub(funding.unlocked);
1481         }
1482 
1483         return
1484             (block.timestamp.sub(funding.lastUpdated)).mul(funding.shares).div(
1485                 funding.duration
1486             );
1487     }
1488 
1489     /**
1490      * @notice compute time bonus earned as a function of staking time
1491      * @param time length of time for which the tokens have been staked
1492      * @return bonus multiplier for time
1493      */
1494     function timeBonus(uint256 time) public view returns (uint256) {
1495         if (time >= bonusPeriod) {
1496             return uint256(10**BONUS_DECIMALS).add(bonusMax);
1497         }
1498 
1499         // linearly interpolate between bonus min and bonus max
1500         uint256 bonus = bonusMin.add(
1501             (bonusMax.sub(bonusMin)).mul(time).div(bonusPeriod)
1502         );
1503         return uint256(10**BONUS_DECIMALS).add(bonus);
1504     }
1505 
1506     /**
1507      * @notice compute GYSR bonus as a function of usage ratio and GYSR spent
1508      * @param gysr number of GYSR token applied to bonus
1509      * @return multiplier value
1510      */
1511     function gysrBonus(uint256 gysr) public view returns (uint256) {
1512         if (gysr == 0) {
1513             return 10**BONUS_DECIMALS;
1514         }
1515         require(
1516             gysr >= 10**BONUS_DECIMALS,
1517             "Geyser: GYSR amount is between 0 and 1"
1518         );
1519 
1520         uint256 buffer = uint256(10**(BONUS_DECIMALS - 2)); // 0.01
1521         uint256 r = ratio().add(buffer);
1522         uint256 x = gysr.add(buffer);
1523 
1524         return
1525             uint256(10**BONUS_DECIMALS).add(
1526                 uint256(int128(x.mul(2**64).div(r)).logbase10())
1527                     .mul(10**BONUS_DECIMALS)
1528                     .div(2**64)
1529             );
1530     }
1531 
1532     /**
1533      * @return portion of rewards which have been boosted by GYSR token
1534      */
1535     function ratio() public view returns (uint256) {
1536         if (totalRewards == 0) {
1537             return 0;
1538         }
1539         return totalGysrRewards.mul(10**BONUS_DECIMALS).div(totalRewards);
1540     }
1541 
1542     // Geyser -- informational functions
1543 
1544     /**
1545      * @return total number of locked reward tokens
1546      */
1547     function totalLocked() public view returns (uint256) {
1548         return _lockedPool.balance();
1549     }
1550 
1551     /**
1552      * @return total number of unlocked reward tokens
1553      */
1554     function totalUnlocked() public view returns (uint256) {
1555         return _unlockedPool.balance();
1556     }
1557 
1558     /**
1559      * @return number of active funding schedules
1560      */
1561     function fundingCount() public view returns (uint256) {
1562         return fundings.length;
1563     }
1564 
1565     /**
1566      * @param addr address of interest
1567      * @return number of active stakes for user
1568      */
1569     function stakeCount(address addr) public view returns (uint256) {
1570         return userStakes[addr].length;
1571     }
1572 
1573     /**
1574      * @notice preview estimated reward distribution for full unstake with no GYSR applied
1575      * @return estimated reward
1576      * @return estimated overall multiplier
1577      * @return estimated raw user share seconds that would be burned
1578      * @return estimated total unlocked rewards
1579      */
1580     function preview()
1581         public
1582         view
1583         returns (
1584             uint256,
1585             uint256,
1586             uint256,
1587             uint256
1588         )
1589     {
1590         return preview(msg.sender, totalStakedFor(msg.sender), 0);
1591     }
1592 
1593     /**
1594      * @notice preview estimated reward distribution for unstaking
1595      * @param addr address of interest for preview
1596      * @param amount number of tokens that would be unstaked
1597      * @param gysr number of GYSR tokens that would be applied
1598      * @return estimated reward
1599      * @return estimated overall multiplier
1600      * @return estimated raw user share seconds that would be burned
1601      * @return estimated total unlocked rewards
1602      */
1603     function preview(
1604         address addr,
1605         uint256 amount,
1606         uint256 gysr
1607     )
1608         public
1609         view
1610         returns (
1611             uint256,
1612             uint256,
1613             uint256,
1614             uint256
1615         )
1616     {
1617         // compute expected updates to global totals
1618         uint256 deltaUnlocked = 0;
1619         if (totalLockedShares != 0) {
1620             uint256 sharesToUnlock = 0;
1621             for (uint256 i = 0; i < fundings.length; i++) {
1622                 sharesToUnlock = sharesToUnlock.add(_unlockable(i));
1623             }
1624             deltaUnlocked = sharesToUnlock.mul(totalLocked()).div(
1625                 totalLockedShares
1626             );
1627         }
1628 
1629         // no need for unstaking/rewards computation
1630         if (amount == 0) {
1631             return (0, 0, 0, totalUnlocked().add(deltaUnlocked));
1632         }
1633 
1634         // check unstake amount
1635         require(
1636             amount <= totalStakedFor(addr),
1637             "Geyser: preview amount exceeds balance"
1638         );
1639 
1640         // compute unstake amount in shares
1641         uint256 shares = totalStakingShares.mul(amount).div(totalStaked());
1642         require(shares > 0, "Geyser: preview amount too small");
1643 
1644         uint256 rawShareSeconds = 0;
1645         uint256 timeBonusShareSeconds = 0;
1646 
1647         // compute first-in-last-out, time bonus weighted, share seconds
1648         uint256 i = userStakes[addr].length.sub(1);
1649         while (shares > 0) {
1650             Stake storage s = userStakes[addr][i];
1651             uint256 time = block.timestamp.sub(s.timestamp);
1652 
1653             if (s.shares < shares) {
1654                 rawShareSeconds = rawShareSeconds.add(s.shares.mul(time));
1655                 timeBonusShareSeconds = timeBonusShareSeconds.add(
1656                     s.shares.mul(time).mul(timeBonus(time)).div(
1657                         10**BONUS_DECIMALS
1658                     )
1659                 );
1660                 shares = shares.sub(s.shares);
1661             } else {
1662                 rawShareSeconds = rawShareSeconds.add(shares.mul(time));
1663                 timeBonusShareSeconds = timeBonusShareSeconds.add(
1664                     shares.mul(time).mul(timeBonus(time)).div(
1665                         10**BONUS_DECIMALS
1666                     )
1667                 );
1668                 break;
1669             }
1670             // this will throw on underflow
1671             i = i.sub(1);
1672         }
1673 
1674         // apply gysr bonus
1675         uint256 gysrBonusShareSeconds = gysrBonus(gysr)
1676             .mul(timeBonusShareSeconds)
1677             .div(10**BONUS_DECIMALS);
1678 
1679         // compute rewards based on expected updates
1680         uint256 expectedTotalShareSeconds = totalStakingShareSeconds
1681             .add((block.timestamp.sub(lastUpdated)).mul(totalStakingShares))
1682             .add(gysrBonusShareSeconds)
1683             .sub(rawShareSeconds);
1684 
1685         uint256 reward = (totalUnlocked().add(deltaUnlocked))
1686             .mul(gysrBonusShareSeconds)
1687             .div(expectedTotalShareSeconds);
1688 
1689         // compute effective bonus
1690         uint256 bonus = uint256(10**BONUS_DECIMALS)
1691             .mul(gysrBonusShareSeconds)
1692             .div(rawShareSeconds);
1693 
1694         return (
1695             reward,
1696             bonus,
1697             rawShareSeconds,
1698             totalUnlocked().add(deltaUnlocked)
1699         );
1700     }
1701 }