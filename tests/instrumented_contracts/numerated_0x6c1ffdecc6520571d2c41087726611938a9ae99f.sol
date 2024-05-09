1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
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
163 
164 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
165 
166 pragma solidity ^0.6.0;
167 
168 /**
169  * @dev Interface of the ERC20 standard as defined in the EIP.
170  */
171 interface IERC20 {
172     /**
173      * @dev Returns the amount of tokens in existence.
174      */
175     function totalSupply() external view returns (uint256);
176 
177     /**
178      * @dev Returns the amount of tokens owned by `account`.
179      */
180     function balanceOf(address account) external view returns (uint256);
181 
182     /**
183      * @dev Moves `amount` tokens from the caller's account to `recipient`.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transfer(address recipient, uint256 amount) external returns (bool);
190 
191     /**
192      * @dev Returns the remaining number of tokens that `spender` will be
193      * allowed to spend on behalf of `owner` through {transferFrom}. This is
194      * zero by default.
195      *
196      * This value changes when {approve} or {transferFrom} are called.
197      */
198     function allowance(address owner, address spender) external view returns (uint256);
199 
200     /**
201      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * IMPORTANT: Beware that changing an allowance with this method brings the risk
206      * that someone may use both the old and the new allowance by unfortunate
207      * transaction ordering. One possible solution to mitigate this race
208      * condition is to first reduce the spender's allowance to 0 and set the
209      * desired value afterwards:
210      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211      *
212      * Emits an {Approval} event.
213      */
214     function approve(address spender, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Moves `amount` tokens from `sender` to `recipient` using the
218      * allowance mechanism. `amount` is then deducted from the caller's
219      * allowance.
220      *
221      * Returns a boolean value indicating whether the operation succeeded.
222      *
223      * Emits a {Transfer} event.
224      */
225     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
226 
227     /**
228      * @dev Emitted when `value` tokens are moved from one account (`from`) to
229      * another (`to`).
230      *
231      * Note that `value` may be zero.
232      */
233     event Transfer(address indexed from, address indexed to, uint256 value);
234 
235     /**
236      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
237      * a call to {approve}. `value` is the new allowance.
238      */
239     event Approval(address indexed owner, address indexed spender, uint256 value);
240 }
241 
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 pragma solidity ^0.6.2;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 
386 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
387 
388 pragma solidity ^0.6.0;
389 
390 /**
391  * @title SafeERC20
392  * @dev Wrappers around ERC20 operations that throw on failure (when the token
393  * contract returns false). Tokens that return no value (and instead revert or
394  * throw on failure) are also supported, non-reverting calls are assumed to be
395  * successful.
396  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
397  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
398  */
399 library SafeERC20 {
400     using SafeMath for uint256;
401     using Address for address;
402 
403     function safeTransfer(IERC20 token, address to, uint256 value) internal {
404         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
405     }
406 
407     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
408         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
409     }
410 
411     /**
412      * @dev Deprecated. This function has issues similar to the ones found in
413      * {IERC20-approve}, and its usage is discouraged.
414      *
415      * Whenever possible, use {safeIncreaseAllowance} and
416      * {safeDecreaseAllowance} instead.
417      */
418     function safeApprove(IERC20 token, address spender, uint256 value) internal {
419         // safeApprove should only be called when setting an initial allowance,
420         // or when resetting it to zero. To increase and decrease it, use
421         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
422         // solhint-disable-next-line max-line-length
423         require((value == 0) || (token.allowance(address(this), spender) == 0),
424             "SafeERC20: approve from non-zero to non-zero allowance"
425         );
426         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
427     }
428 
429     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
430         uint256 newAllowance = token.allowance(address(this), spender).add(value);
431         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
432     }
433 
434     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
435         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
437     }
438 
439     /**
440      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
441      * on the return value: the return value is optional (but if data is returned, it must not be false).
442      * @param token The token targeted by the call.
443      * @param data The call data (encoded using abi.encode or one of its variants).
444      */
445     function _callOptionalReturn(IERC20 token, bytes memory data) private {
446         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
447         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
448         // the target address contains contract code and also asserts for success in the low-level call.
449 
450         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
451         if (returndata.length > 0) { // Return data is optional
452             // solhint-disable-next-line max-line-length
453             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
454         }
455     }
456 }
457 
458 
459 // File: @openzeppelin/contracts/GSN/Context.sol
460 
461 pragma solidity ^0.6.0;
462 
463 /*
464  * @dev Provides information about the current execution context, including the
465  * sender of the transaction and its data. While these are generally available
466  * via msg.sender and msg.data, they should not be accessed in such a direct
467  * manner, since when dealing with GSN meta-transactions the account sending and
468  * paying for execution may not be the actual sender (as far as an application
469  * is concerned).
470  *
471  * This contract is only required for intermediate, library-like contracts.
472  */
473 abstract contract Context {
474     function _msgSender() internal view virtual returns (address payable) {
475         return msg.sender;
476     }
477 
478     function _msgData() internal view virtual returns (bytes memory) {
479         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
480         return msg.data;
481     }
482 }
483 
484 
485 // File: @openzeppelin/contracts/access/Ownable.sol
486 
487 pragma solidity ^0.6.0;
488 
489 /**
490  * @dev Contract module which provides a basic access control mechanism, where
491  * there is an account (an owner) that can be granted exclusive access to
492  * specific functions.
493  *
494  * By default, the owner account will be the one that deploys the contract. This
495  * can later be changed with {transferOwnership}.
496  *
497  * This module is used through inheritance. It will make available the modifier
498  * `onlyOwner`, which can be applied to your functions to restrict their use to
499  * the owner.
500  */
501 contract Ownable is Context {
502     address private _owner;
503 
504     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
505 
506     /**
507      * @dev Initializes the contract setting the deployer as the initial owner.
508      */
509     constructor () internal {
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
547         require(newOwner != address(0), "Ownable: new owner is the zero address");
548         emit OwnershipTransferred(_owner, newOwner);
549         _owner = newOwner;
550     }
551 }
552 
553 
554 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
555 
556 pragma solidity ^0.6.0;
557 
558 /**
559  * @dev Contract module that helps prevent reentrant calls to a function.
560  *
561  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
562  * available, which can be applied to functions to make sure there are no nested
563  * (reentrant) calls to them.
564  *
565  * Note that because there is a single `nonReentrant` guard, functions marked as
566  * `nonReentrant` may not call one another. This can be worked around by making
567  * those functions `private`, and then adding `external` `nonReentrant` entry
568  * points to them.
569  *
570  * TIP: If you would like to learn more about reentrancy and alternative ways
571  * to protect against it, check out our blog post
572  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
573  */
574 contract ReentrancyGuard {
575     // Booleans are more expensive than uint256 or any type that takes up a full
576     // word because each write operation emits an extra SLOAD to first read the
577     // slot's contents, replace the bits taken up by the boolean, and then write
578     // back. This is the compiler's defense against contract upgrades and
579     // pointer aliasing, and it cannot be disabled.
580 
581     // The values being non-zero value makes deployment a bit more expensive,
582     // but in exchange the refund on every call to nonReentrant will be lower in
583     // amount. Since refunds are capped to a percentage of the total
584     // transaction's gas, it is best to keep them low in cases like this one, to
585     // increase the likelihood of the full refund coming into effect.
586     uint256 private constant _NOT_ENTERED = 1;
587     uint256 private constant _ENTERED = 2;
588 
589     uint256 private _status;
590 
591     constructor () internal {
592         _status = _NOT_ENTERED;
593     }
594 
595     /**
596      * @dev Prevents a contract from calling itself, directly or indirectly.
597      * Calling a `nonReentrant` function from another `nonReentrant`
598      * function is not supported. It is possible to prevent this from happening
599      * by making the `nonReentrant` function external, and make it call a
600      * `private` function that does the actual work.
601      */
602     modifier nonReentrant() {
603         // On the first call to nonReentrant, _notEntered will be true
604         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
605 
606         // Any calls to nonReentrant after this point will fail
607         _status = _ENTERED;
608 
609         _;
610 
611         // By storing the original value once again, a refund is triggered (see
612         // https://eips.ethereum.org/EIPS/eip-2200)
613         _status = _NOT_ENTERED;
614     }
615 }
616 
617 
618 // File: contracts/IStaking.sol
619 
620 /*
621 Staking interface
622 
623 EIP-900 staking interface
624 
625 https://github.com/gysr-io/core
626 
627 h/t https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
628 */
629 
630 pragma solidity ^0.6.12;
631 
632 interface IStaking {
633     // events
634     event Staked(
635         address indexed user,
636         uint256 amount,
637         uint256 total,
638         bytes data
639     );
640     event Unstaked(
641         address indexed user,
642         uint256 amount,
643         uint256 total,
644         bytes data
645     );
646 
647     /**
648      * @notice stakes a certain amount of tokens, transferring this amount from
649      the user to the contract
650      * @param amount number of tokens to stake
651      */
652     function stake(uint256 amount, bytes calldata) external;
653 
654     /**
655      * @notice stakes a certain amount of tokens for an address, transfering this
656      amount from the caller to the contract, on behalf of the specified address
657      * @param user beneficiary address
658      * @param amount number of tokens to stake
659      */
660     function stakeFor(
661         address user,
662         uint256 amount,
663         bytes calldata
664     ) external;
665 
666     /**
667      * @notice unstakes a certain amount of tokens, returning these tokens
668      to the user
669      * @param amount number of tokens to unstake
670      */
671     function unstake(uint256 amount, bytes calldata) external;
672 
673     /**
674      * @param addr the address of interest
675      * @return the current total of tokens staked for an address
676      */
677     function totalStakedFor(address addr) external view returns (uint256);
678 
679     /**
680      * @return the current total amount of tokens staked by all users
681      */
682     function totalStaked() external view returns (uint256);
683 
684     /**
685      * @return the staking token for this staking contract
686      */
687     function token() external view returns (address);
688 
689     /**
690      * @return true if the staking contract support history
691      */
692     function supportsHistory() external pure returns (bool);
693 }
694 
695 
696 // File: contracts/IGeyser.sol
697 
698 /*
699 Geyser interface
700 
701 This defines the core Geyser contract interface as an extension to the
702 standard IStaking interface
703 
704 https://github.com/gysr-io/core
705 */
706 
707 pragma solidity ^0.6.12;
708 
709 /**
710  * @title Geyser interface
711  */
712 abstract contract IGeyser is IStaking, Ownable {
713     // events
714     event RewardsDistributed(address indexed user, uint256 amount);
715     event RewardsFunded(
716         uint256 amount,
717         uint256 duration,
718         uint256 start,
719         uint256 total
720     );
721     event RewardsUnlocked(uint256 amount, uint256 total);
722     event RewardsExpired(uint256 amount, uint256 duration, uint256 start);
723     event GysrSpent(address indexed user, uint256 amount);
724     event GysrWithdrawn(uint256 amount);
725 
726     // IStaking
727     /**
728      * @notice no support for history
729      * @return false
730      */
731     function supportsHistory() external override pure returns (bool) {
732         return false;
733     }
734 
735     // IGeyser
736     /**
737      * @return staking token for this Geyser
738      */
739     function stakingToken() external virtual view returns (address);
740 
741     /**
742      * @return reward token for this Geyser
743      */
744     function rewardToken() external virtual view returns (address);
745 
746     /**
747      * @notice fund Geyser by locking up reward tokens for distribution
748      * @param amount number of reward tokens to lock up as funding
749      * @param duration period (seconds) over which funding will be unlocked
750      */
751     function fund(uint256 amount, uint256 duration) external virtual;
752 
753     /**
754      * @notice fund Geyser by locking up reward tokens for future distribution
755      * @param amount number of reward tokens to lock up as funding
756      * @param duration period (seconds) over which funding will be unlocked
757      * @param start time (seconds) at which funding begins to unlock
758      */
759     function fund(
760         uint256 amount,
761         uint256 duration,
762         uint256 start
763     ) external virtual;
764 
765     /**
766      * @notice withdraw GYSR tokens applied during unstaking
767      * @param amount number of GYSR to withdraw
768      */
769     function withdraw(uint256 amount) external virtual;
770 
771     /**
772      * @notice unstake while applying GYSR token for boosted rewards
773      * @param amount number of tokens to unstake
774      * @param gysr number of GYSR tokens to apply for boost
775      */
776     function unstake(
777         uint256 amount,
778         uint256 gysr,
779         bytes calldata
780     ) external virtual;
781 
782     /**
783      * @notice update accounting, unlock tokens, etc.
784      */
785     function update() external virtual;
786 
787     /**
788      * @notice clean geyser, expire old fundings, etc.
789      */
790     function clean() external virtual;
791 }
792 
793 
794 // File: contracts/GeyserPool.sol
795 
796 /*
797 Geyser token pool
798 
799 Simple contract to implement token pool of arbitrary ERC20 token.
800 This is owned and used by a parent Geyser
801 
802 https://github.com/gysr-io/core
803 
804 h/t https://github.com/ampleforth/token-geyser
805 */
806 
807 pragma solidity ^0.6.12;
808 
809 contract GeyserPool is Ownable {
810     using SafeERC20 for IERC20;
811 
812     IERC20 public token;
813 
814     constructor(address token_) public {
815         token = IERC20(token_);
816     }
817 
818     function balance() public view returns (uint256) {
819         return token.balanceOf(address(this));
820     }
821 
822     function transfer(address to, uint256 value) external onlyOwner {
823         token.safeTransfer(to, value);
824     }
825 }
826 
827 
828 // File: contracts/MathUtils.sol
829 
830 /*
831 Math utilities
832 
833 This library implements various logarithmic math utilies which support
834 other contracts and specifically the GYSR multiplier calculation
835 
836 https://github.com/gysr-io/core
837 
838 h/t https://github.com/abdk-consulting/abdk-libraries-solidity
839 */
840 
841 pragma solidity ^0.6.12;
842 
843 library MathUtils {
844     /**
845      * Calculate binary logarithm of x.  Revert if x <= 0.
846      *
847      * @param x signed 64.64-bit fixed point number
848      * @return signed 64.64-bit fixed point number
849      */
850     function logbase2(int128 x) internal pure returns (int128) {
851         require(x > 0);
852 
853         int256 msb = 0;
854         int256 xc = x;
855         if (xc >= 0x10000000000000000) {
856             xc >>= 64;
857             msb += 64;
858         }
859         if (xc >= 0x100000000) {
860             xc >>= 32;
861             msb += 32;
862         }
863         if (xc >= 0x10000) {
864             xc >>= 16;
865             msb += 16;
866         }
867         if (xc >= 0x100) {
868             xc >>= 8;
869             msb += 8;
870         }
871         if (xc >= 0x10) {
872             xc >>= 4;
873             msb += 4;
874         }
875         if (xc >= 0x4) {
876             xc >>= 2;
877             msb += 2;
878         }
879         if (xc >= 0x2) msb += 1; // No need to shift xc anymore
880 
881         int256 result = (msb - 64) << 64;
882         uint256 ux = uint256(x) << (127 - msb);
883         for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
884             ux *= ux;
885             uint256 b = ux >> 255;
886             ux >>= 127 + b;
887             result += bit * int256(b);
888         }
889 
890         return int128(result);
891     }
892 
893     /**
894      * @notice calculate natural logarithm of x
895      * @dev magic constant comes from ln(2) * 2^128 -> hex
896      * @param x signed 64.64-bit fixed point number, require x > 0
897      * @return signed 64.64-bit fixed point number
898      */
899     function ln(int128 x) internal pure returns (int128) {
900         require(x > 0);
901 
902         return
903             int128(
904                 (uint256(logbase2(x)) * 0xB17217F7D1CF79ABC9E3B39803F2F6AF) >>
905                     128
906             );
907     }
908 
909     /**
910      * @notice calculate logarithm base 10 of x
911      * @dev magic constant comes from log10(2) * 2^128 -> hex
912      * @param x signed 64.64-bit fixed point number, require x > 0
913      * @return signed 64.64-bit fixed point number
914      */
915     function logbase10(int128 x) internal pure returns (int128) {
916         require(x > 0);
917 
918         return
919             int128(
920                 (uint256(logbase2(x)) * 0x4d104d427de7fce20a6e420e02236748) >>
921                     128
922             );
923     }
924 
925     // wrapper functions to allow testing
926     function testlogbase2(int128 x) public pure returns (int128) {
927         return logbase2(x);
928     }
929 
930     function testlogbase10(int128 x) public pure returns (int128) {
931         return logbase10(x);
932     }
933 }
934 
935 
936 // File: contracts/Geyser.sol
937 
938 /*
939 Geyser
940 
941 This implements the core Geyser contract, which allows for generalized
942 staking, yield farming, and token distribution. This also implements
943 the GYSR spending mechanic for boosted reward distribution.
944 
945 https://github.com/gysr-io/core
946 
947 h/t https://github.com/ampleforth/token-geyser
948 */
949 
950 pragma solidity ^0.6.12;
951 
952 /**
953  * @title Geyser
954  */
955 contract Geyser is IGeyser, ReentrancyGuard {
956     using SafeMath for uint256;
957     using SafeERC20 for IERC20;
958     using MathUtils for int128;
959 
960     // single stake by user
961     struct Stake {
962         uint256 shares;
963         uint256 timestamp;
964     }
965 
966     // summary of total user stake/shares
967     struct User {
968         uint256 shares;
969         uint256 shareSeconds;
970         uint256 lastUpdated;
971     }
972 
973     // single funding/reward schedule
974     struct Funding {
975         uint256 amount;
976         uint256 shares;
977         uint256 unlocked;
978         uint256 lastUpdated;
979         uint256 start;
980         uint256 end;
981         uint256 duration;
982     }
983 
984     // constants
985     uint256 public constant BONUS_DECIMALS = 18;
986     uint256 public constant INITIAL_SHARES_PER_TOKEN = 10**6;
987     uint256 public constant MAX_ACTIVE_FUNDINGS = 16;
988 
989     // token pool fields
990     GeyserPool private immutable _stakingPool;
991     GeyserPool private immutable _unlockedPool;
992     GeyserPool private immutable _lockedPool;
993     Funding[] public fundings;
994 
995     // user staking fields
996     mapping(address => User) public userTotals;
997     mapping(address => Stake[]) public userStakes;
998 
999     // time bonus fields
1000     uint256 public immutable bonusMin;
1001     uint256 public immutable bonusMax;
1002     uint256 public immutable bonusPeriod;
1003 
1004     // global state fields
1005     uint256 public totalLockedShares;
1006     uint256 public totalStakingShares;
1007     uint256 public totalRewards;
1008     uint256 public totalGysrRewards;
1009     uint256 public totalStakingShareSeconds;
1010     uint256 public lastUpdated;
1011 
1012     // gysr fields
1013     IERC20 private immutable _gysr;
1014 
1015     /**
1016      * @param stakingToken_ the token that will be staked
1017      * @param rewardToken_ the token distributed to users as they unstake
1018      * @param bonusMin_ initial time bonus
1019      * @param bonusMax_ maximum time bonus
1020      * @param bonusPeriod_ period (in seconds) over which time bonus grows to max
1021      * @param gysr_ address for GYSR token
1022      */
1023     constructor(
1024         address stakingToken_,
1025         address rewardToken_,
1026         uint256 bonusMin_,
1027         uint256 bonusMax_,
1028         uint256 bonusPeriod_,
1029         address gysr_
1030     ) public {
1031         require(
1032             bonusMin_ <= bonusMax_,
1033             "Geyser: initial time bonus greater than max"
1034         );
1035 
1036         _stakingPool = new GeyserPool(stakingToken_);
1037         _unlockedPool = new GeyserPool(rewardToken_);
1038         _lockedPool = new GeyserPool(rewardToken_);
1039 
1040         bonusMin = bonusMin_;
1041         bonusMax = bonusMax_;
1042         bonusPeriod = bonusPeriod_;
1043 
1044         _gysr = IERC20(gysr_);
1045 
1046         lastUpdated = block.timestamp;
1047     }
1048 
1049     // IStaking
1050 
1051     /**
1052      * @inheritdoc IStaking
1053      */
1054     function stake(uint256 amount, bytes calldata) external override {
1055         _stake(msg.sender, msg.sender, amount);
1056     }
1057 
1058     /**
1059      * @inheritdoc IStaking
1060      */
1061     function stakeFor(
1062         address user,
1063         uint256 amount,
1064         bytes calldata
1065     ) external override {
1066         _stake(msg.sender, user, amount);
1067     }
1068 
1069     /**
1070      * @inheritdoc IStaking
1071      */
1072     function unstake(uint256 amount, bytes calldata) external override {
1073         _unstake(amount, 0);
1074     }
1075 
1076     /**
1077      * @inheritdoc IStaking
1078      */
1079     function totalStakedFor(address addr)
1080         public
1081         override
1082         view
1083         returns (uint256)
1084     {
1085         if (totalStakingShares == 0) {
1086             return 0;
1087         }
1088         return
1089             totalStaked().mul(userTotals[addr].shares).div(totalStakingShares);
1090     }
1091 
1092     /**
1093      * @inheritdoc IStaking
1094      */
1095     function totalStaked() public override view returns (uint256) {
1096         return _stakingPool.balance();
1097     }
1098 
1099     /**
1100      * @inheritdoc IStaking
1101      * @dev redundant with stakingToken() in order to implement IStaking (EIP-900)
1102      */
1103     function token() external override view returns (address) {
1104         return address(_stakingPool.token());
1105     }
1106 
1107     // IGeyser
1108 
1109     /**
1110      * @inheritdoc IGeyser
1111      */
1112     function stakingToken() public override view returns (address) {
1113         return address(_stakingPool.token());
1114     }
1115 
1116     /**
1117      * @inheritdoc IGeyser
1118      */
1119     function rewardToken() public override view returns (address) {
1120         return address(_unlockedPool.token());
1121     }
1122 
1123     /**
1124      * @inheritdoc IGeyser
1125      */
1126     function fund(uint256 amount, uint256 duration) public override {
1127         fund(amount, duration, block.timestamp);
1128     }
1129 
1130     /**
1131      * @inheritdoc IGeyser
1132      */
1133     function fund(
1134         uint256 amount,
1135         uint256 duration,
1136         uint256 start
1137     ) public override onlyOwner {
1138         // validate
1139         require(amount > 0, "Geyser: funding amount is zero");
1140         require(start >= block.timestamp, "Geyser: funding start is past");
1141         require(
1142             fundings.length < MAX_ACTIVE_FUNDINGS,
1143             "Geyser: exceeds max active funding schedules"
1144         );
1145 
1146         // update bookkeeping
1147         _update(msg.sender);
1148 
1149         // mint shares at current rate
1150         uint256 lockedTokens = totalLocked();
1151         uint256 mintedLockedShares = (lockedTokens > 0)
1152             ? totalLockedShares.mul(amount).div(lockedTokens)
1153             : amount.mul(INITIAL_SHARES_PER_TOKEN);
1154 
1155         totalLockedShares = totalLockedShares.add(mintedLockedShares);
1156 
1157         // create new funding
1158         fundings.push(
1159             Funding({
1160                 amount: amount,
1161                 shares: mintedLockedShares,
1162                 unlocked: 0,
1163                 lastUpdated: start,
1164                 start: start,
1165                 end: start.add(duration),
1166                 duration: duration
1167             })
1168         );
1169 
1170         // do transfer of funding
1171         _lockedPool.token().safeTransferFrom(
1172             msg.sender,
1173             address(_lockedPool),
1174             amount
1175         );
1176         emit RewardsFunded(amount, duration, start, totalLocked());
1177     }
1178 
1179     /**
1180      * @inheritdoc IGeyser
1181      */
1182     function withdraw(uint256 amount) external override onlyOwner {
1183         require(amount > 0, "Geyser: withdraw amount is zero");
1184         require(
1185             amount <= _gysr.balanceOf(address(this)),
1186             "Geyser: withdraw amount exceeds balance"
1187         );
1188         // do transfer
1189         _gysr.safeTransfer(msg.sender, amount);
1190 
1191         emit GysrWithdrawn(amount);
1192     }
1193 
1194     /**
1195      * @inheritdoc IGeyser
1196      */
1197     function unstake(
1198         uint256 amount,
1199         uint256 gysr,
1200         bytes calldata
1201     ) external override {
1202         _unstake(amount, gysr);
1203     }
1204 
1205     /**
1206      * @inheritdoc IGeyser
1207      */
1208     function update() external override nonReentrant {
1209         _update(msg.sender);
1210     }
1211 
1212     /**
1213      * @inheritdoc IGeyser
1214      */
1215     function clean() external override onlyOwner {
1216         // update bookkeeping
1217         _update(msg.sender);
1218 
1219         // check for stale funding schedules to expire
1220         uint256 removed = 0;
1221         uint256 originalSize = fundings.length;
1222         for (uint256 i = 0; i < originalSize; i++) {
1223             Funding storage funding = fundings[i.sub(removed)];
1224             uint256 idx = i.sub(removed);
1225 
1226             if (_unlockable(idx) == 0 && block.timestamp >= funding.end) {
1227                 emit RewardsExpired(
1228                     funding.amount,
1229                     funding.duration,
1230                     funding.start
1231                 );
1232 
1233                 // remove at idx by copying last element here, then popping off last
1234                 // (we don't care about order)
1235                 fundings[idx] = fundings[fundings.length.sub(1)];
1236                 fundings.pop();
1237                 removed = removed.add(1);
1238             }
1239         }
1240     }
1241 
1242     // Geyser
1243 
1244     /**
1245      * @dev internal implementation of staking methods
1246      * @param staker address to do deposit of staking tokens
1247      * @param beneficiary address to gain credit for this stake operation
1248      * @param amount number of staking tokens to deposit
1249      */
1250     function _stake(
1251         address staker,
1252         address beneficiary,
1253         uint256 amount
1254     ) private nonReentrant {
1255         // validate
1256         require(amount > 0, "Geyser: stake amount is zero");
1257         require(
1258             beneficiary != address(0),
1259             "Geyser: beneficiary is zero address"
1260         );
1261 
1262         // mint staking shares at current rate
1263         uint256 mintedStakingShares = (totalStakingShares > 0)
1264             ? totalStakingShares.mul(amount).div(totalStaked())
1265             : amount.mul(INITIAL_SHARES_PER_TOKEN);
1266         require(mintedStakingShares > 0, "Geyser: stake amount too small");
1267 
1268         // update bookkeeping
1269         _update(beneficiary);
1270 
1271         // update user staking info
1272         User storage user = userTotals[beneficiary];
1273         user.shares = user.shares.add(mintedStakingShares);
1274         user.lastUpdated = block.timestamp;
1275 
1276         userStakes[beneficiary].push(
1277             Stake(mintedStakingShares, block.timestamp)
1278         );
1279 
1280         // add newly minted shares to global total
1281         totalStakingShares = totalStakingShares.add(mintedStakingShares);
1282 
1283         // transactions
1284         _stakingPool.token().safeTransferFrom(
1285             staker,
1286             address(_stakingPool),
1287             amount
1288         );
1289 
1290         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
1291     }
1292 
1293     /**
1294      * @dev internal implementation of unstaking methods
1295      * @param amount number of tokens to unstake
1296      * @param gysr number of GYSR tokens applied to unstaking operation
1297      * @return number of reward tokens distributed
1298      */
1299     function _unstake(uint256 amount, uint256 gysr)
1300         private
1301         nonReentrant
1302         returns (uint256)
1303     {
1304         // validate
1305         require(amount > 0, "Geyser: unstake amount is zero");
1306         require(
1307             totalStakedFor(msg.sender) >= amount,
1308             "Geyser: unstake amount exceeds balance"
1309         );
1310 
1311         // update bookkeeping
1312         _update(msg.sender);
1313 
1314         // do unstaking, first-in last-out, respecting time bonus
1315         uint256 timeWeightedShareSeconds = _unstakeFirstInLastOut(amount);
1316 
1317         // compute and apply GYSR token bonus
1318         uint256 gysrWeightedShareSeconds = gysrBonus(gysr)
1319             .mul(timeWeightedShareSeconds)
1320             .div(10**BONUS_DECIMALS);
1321 
1322         uint256 rewardAmount = totalUnlocked()
1323             .mul(gysrWeightedShareSeconds)
1324             .div(totalStakingShareSeconds.add(gysrWeightedShareSeconds));
1325 
1326         // update global stats for distributions
1327         if (gysr > 0) {
1328             totalGysrRewards = totalGysrRewards.add(rewardAmount);
1329         }
1330         totalRewards = totalRewards.add(rewardAmount);
1331 
1332         // transactions
1333         _stakingPool.transfer(msg.sender, amount);
1334         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
1335         if (rewardAmount > 0) {
1336             _unlockedPool.transfer(msg.sender, rewardAmount);
1337             emit RewardsDistributed(msg.sender, rewardAmount);
1338         }
1339         if (gysr > 0) {
1340             _gysr.safeTransferFrom(msg.sender, address(this), gysr);
1341             emit GysrSpent(msg.sender, gysr);
1342         }
1343         return rewardAmount;
1344     }
1345 
1346     /**
1347      * @dev helper function to actually execute unstaking, first-in last-out, 
1348      while computing and applying time bonus. This function also updates
1349      user and global totals for shares and share-seconds.
1350      * @param amount number of staking tokens to withdraw
1351      * @return time bonus weighted staking share seconds
1352      */
1353     function _unstakeFirstInLastOut(uint256 amount) private returns (uint256) {
1354         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(
1355             totalStaked()
1356         );
1357         require(stakingSharesToBurn > 0, "Geyser: unstake amount too small");
1358 
1359         // redeem from most recent stake and go backwards in time.
1360         uint256 shareSecondsToBurn = 0;
1361         uint256 sharesLeftToBurn = stakingSharesToBurn;
1362         uint256 bonusWeightedShareSeconds = 0;
1363         Stake[] storage stakes = userStakes[msg.sender];
1364         while (sharesLeftToBurn > 0) {
1365             Stake storage lastStake = stakes[stakes.length - 1];
1366             uint256 stakeTime = block.timestamp.sub(lastStake.timestamp);
1367 
1368             uint256 bonus = timeBonus(stakeTime);
1369 
1370             if (lastStake.shares <= sharesLeftToBurn) {
1371                 // fully redeem a past stake
1372                 bonusWeightedShareSeconds = bonusWeightedShareSeconds.add(
1373                     lastStake.shares.mul(stakeTime).mul(bonus).div(
1374                         10**BONUS_DECIMALS
1375                     )
1376                 );
1377                 shareSecondsToBurn = shareSecondsToBurn.add(
1378                     lastStake.shares.mul(stakeTime)
1379                 );
1380                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.shares);
1381                 stakes.pop();
1382             } else {
1383                 // partially redeem a past stake
1384                 bonusWeightedShareSeconds = bonusWeightedShareSeconds.add(
1385                     sharesLeftToBurn.mul(stakeTime).mul(bonus).div(
1386                         10**BONUS_DECIMALS
1387                     )
1388                 );
1389                 shareSecondsToBurn = shareSecondsToBurn.add(
1390                     sharesLeftToBurn.mul(stakeTime)
1391                 );
1392                 lastStake.shares = lastStake.shares.sub(sharesLeftToBurn);
1393                 sharesLeftToBurn = 0;
1394             }
1395         }
1396         // update user totals
1397         User storage user = userTotals[msg.sender];
1398         user.shareSeconds = user.shareSeconds.sub(shareSecondsToBurn);
1399         user.shares = user.shares.sub(stakingSharesToBurn);
1400         user.lastUpdated = block.timestamp;
1401 
1402         // update global totals
1403         totalStakingShareSeconds = totalStakingShareSeconds.sub(
1404             shareSecondsToBurn
1405         );
1406         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
1407 
1408         return bonusWeightedShareSeconds;
1409     }
1410 
1411     /**
1412      * @dev internal implementation of update method
1413      * @param addr address for user accounting update
1414      */
1415     function _update(address addr) private {
1416         _unlockTokens();
1417 
1418         // global accounting
1419         uint256 deltaTotalShareSeconds = (block.timestamp.sub(lastUpdated)).mul(
1420             totalStakingShares
1421         );
1422         totalStakingShareSeconds = totalStakingShareSeconds.add(
1423             deltaTotalShareSeconds
1424         );
1425         lastUpdated = block.timestamp;
1426 
1427         // user accounting
1428         User storage user = userTotals[addr];
1429         uint256 deltaUserShareSeconds = (block.timestamp.sub(user.lastUpdated))
1430             .mul(user.shares);
1431         user.shareSeconds = user.shareSeconds.add(deltaUserShareSeconds);
1432         user.lastUpdated = block.timestamp;
1433     }
1434 
1435     /**
1436      * @dev unlocks reward tokens based on funding schedules
1437      */
1438     function _unlockTokens() private {
1439         uint256 tokensToUnlock = 0;
1440         uint256 lockedTokens = totalLocked();
1441 
1442         if (totalLockedShares == 0) {
1443             // handle any leftover
1444             tokensToUnlock = lockedTokens;
1445         } else {
1446             // normal case: unlock some shares from each funding schedule
1447             uint256 sharesToUnlock = 0;
1448             for (uint256 i = 0; i < fundings.length; i++) {
1449                 uint256 shares = _unlockable(i);
1450                 Funding storage funding = fundings[i];
1451                 if (shares > 0) {
1452                     funding.unlocked = funding.unlocked.add(shares);
1453                     funding.lastUpdated = block.timestamp;
1454                     sharesToUnlock = sharesToUnlock.add(shares);
1455                 }
1456             }
1457             tokensToUnlock = sharesToUnlock.mul(lockedTokens).div(
1458                 totalLockedShares
1459             );
1460             totalLockedShares = totalLockedShares.sub(sharesToUnlock);
1461         }
1462 
1463         if (tokensToUnlock > 0) {
1464             _lockedPool.transfer(address(_unlockedPool), tokensToUnlock);
1465             emit RewardsUnlocked(tokensToUnlock, totalUnlocked());
1466         }
1467     }
1468 
1469     /**
1470      * @dev helper function to compute updates to funding schedules
1471      * @param idx index of the funding
1472      * @return the number of unlockable shares
1473      */
1474     function _unlockable(uint256 idx) private view returns (uint256) {
1475         Funding storage funding = fundings[idx];
1476 
1477         // funding schedule is in future
1478         if (block.timestamp < funding.start) {
1479             return 0;
1480         }
1481         // empty
1482         if (funding.unlocked >= funding.shares) {
1483             return 0;
1484         }
1485         // handle zero-duration period or leftover dust from integer division
1486         if (block.timestamp >= funding.end) {
1487             return funding.shares.sub(funding.unlocked);
1488         }
1489 
1490         return
1491             (block.timestamp.sub(funding.lastUpdated)).mul(funding.shares).div(
1492                 funding.duration
1493             );
1494     }
1495 
1496     /**
1497      * @notice compute time bonus earned as a function of staking time
1498      * @param time length of time for which the tokens have been staked
1499      * @return bonus multiplier for time
1500      */
1501     function timeBonus(uint256 time) public view returns (uint256) {
1502         if (time >= bonusPeriod) {
1503             return uint256(10**BONUS_DECIMALS).add(bonusMax);
1504         }
1505 
1506         // linearly interpolate between bonus min and bonus max
1507         uint256 bonus = bonusMin.add(
1508             (bonusMax.sub(bonusMin)).mul(time).div(bonusPeriod)
1509         );
1510         return uint256(10**BONUS_DECIMALS).add(bonus);
1511     }
1512 
1513     /**
1514      * @notice compute GYSR bonus as a function of usage ratio and GYSR spent
1515      * @param gysr number of GYSR token applied to bonus
1516      * @return multiplier value
1517      */
1518     function gysrBonus(uint256 gysr) public view returns (uint256) {
1519         if (gysr == 0) {
1520             return 10**BONUS_DECIMALS;
1521         }
1522         require(
1523             gysr >= 10**BONUS_DECIMALS,
1524             "Geyser: GYSR amount is between 0 and 1"
1525         );
1526 
1527         uint256 buffer = uint256(10**(BONUS_DECIMALS - 2)); // 0.01
1528         uint256 r = ratio().add(buffer);
1529         uint256 x = gysr.add(buffer);
1530 
1531         return
1532             uint256(10**BONUS_DECIMALS).add(
1533                 uint256(int128(x.mul(2**64).div(r)).logbase10())
1534                     .mul(10**BONUS_DECIMALS)
1535                     .div(2**64)
1536             );
1537     }
1538 
1539     /**
1540      * @return portion of rewards which have been boosted by GYSR token
1541      */
1542     function ratio() public view returns (uint256) {
1543         if (totalRewards == 0) {
1544             return 0;
1545         }
1546         return totalGysrRewards.mul(10**BONUS_DECIMALS).div(totalRewards);
1547     }
1548 
1549     // Geyser -- informational functions
1550 
1551     /**
1552      * @return total number of locked reward tokens
1553      */
1554     function totalLocked() public view returns (uint256) {
1555         return _lockedPool.balance();
1556     }
1557 
1558     /**
1559      * @return total number of unlocked reward tokens
1560      */
1561     function totalUnlocked() public view returns (uint256) {
1562         return _unlockedPool.balance();
1563     }
1564 
1565     /**
1566      * @return number of active funding schedules
1567      */
1568     function fundingCount() public view returns (uint256) {
1569         return fundings.length;
1570     }
1571 
1572     /**
1573      * @param addr address of interest
1574      * @return number of active stakes for user
1575      */
1576     function stakeCount(address addr) public view returns (uint256) {
1577         return userStakes[addr].length;
1578     }
1579 
1580     /**
1581      * @notice preview estimated reward distribution for full unstake with no GYSR applied
1582      * @return estimated reward
1583      * @return estimated overall multiplier
1584      * @return estimated raw user share seconds that would be burned
1585      * @return estimated total unlocked rewards
1586      */
1587     function preview()
1588         public
1589         view
1590         returns (
1591             uint256,
1592             uint256,
1593             uint256,
1594             uint256
1595         )
1596     {
1597         return preview(msg.sender, totalStakedFor(msg.sender), 0);
1598     }
1599 
1600     /**
1601      * @notice preview estimated reward distribution for unstaking
1602      * @param addr address of interest for preview
1603      * @param amount number of tokens that would be unstaked
1604      * @param gysr number of GYSR tokens that would be applied
1605      * @return estimated reward
1606      * @return estimated overall multiplier
1607      * @return estimated raw user share seconds that would be burned
1608      * @return estimated total unlocked rewards
1609      */
1610     function preview(
1611         address addr,
1612         uint256 amount,
1613         uint256 gysr
1614     )
1615         public
1616         view
1617         returns (
1618             uint256,
1619             uint256,
1620             uint256,
1621             uint256
1622         )
1623     {
1624         // compute expected updates to global totals
1625         uint256 deltaUnlocked = 0;
1626         if (totalLockedShares != 0) {
1627             uint256 sharesToUnlock = 0;
1628             for (uint256 i = 0; i < fundings.length; i++) {
1629                 sharesToUnlock = sharesToUnlock.add(_unlockable(i));
1630             }
1631             deltaUnlocked = sharesToUnlock.mul(totalLocked()).div(
1632                 totalLockedShares
1633             );
1634         }
1635 
1636         // no need for unstaking/rewards computation
1637         if (amount == 0) {
1638             return (0, 0, 0, totalUnlocked().add(deltaUnlocked));
1639         }
1640 
1641         // check unstake amount
1642         require(
1643             amount <= totalStakedFor(addr),
1644             "Geyser: preview amount exceeds balance"
1645         );
1646 
1647         // compute unstake amount in shares
1648         uint256 shares = totalStakingShares.mul(amount).div(totalStaked());
1649         require(shares > 0, "Geyser: preview amount too small");
1650 
1651         uint256 rawShareSeconds = 0;
1652         uint256 timeBonusShareSeconds = 0;
1653 
1654         // compute first-in-last-out, time bonus weighted, share seconds
1655         uint256 i = userStakes[addr].length.sub(1);
1656         while (shares > 0) {
1657             Stake storage s = userStakes[addr][i];
1658             uint256 time = block.timestamp.sub(s.timestamp);
1659 
1660             if (s.shares < shares) {
1661                 rawShareSeconds = rawShareSeconds.add(s.shares.mul(time));
1662                 timeBonusShareSeconds = timeBonusShareSeconds.add(
1663                     s.shares.mul(time).mul(timeBonus(time)).div(
1664                         10**BONUS_DECIMALS
1665                     )
1666                 );
1667                 shares = shares.sub(s.shares);
1668             } else {
1669                 rawShareSeconds = rawShareSeconds.add(shares.mul(time));
1670                 timeBonusShareSeconds = timeBonusShareSeconds.add(
1671                     shares.mul(time).mul(timeBonus(time)).div(
1672                         10**BONUS_DECIMALS
1673                     )
1674                 );
1675                 break;
1676             }
1677             // this will throw on underflow
1678             i = i.sub(1);
1679         }
1680 
1681         // apply gysr bonus
1682         uint256 gysrBonusShareSeconds = gysrBonus(gysr)
1683             .mul(timeBonusShareSeconds)
1684             .div(10**BONUS_DECIMALS);
1685 
1686         // compute rewards based on expected updates
1687         uint256 expectedTotalShareSeconds = totalStakingShareSeconds
1688             .add((block.timestamp.sub(lastUpdated)).mul(totalStakingShares))
1689             .add(gysrBonusShareSeconds)
1690             .sub(rawShareSeconds);
1691 
1692         uint256 reward = (totalUnlocked().add(deltaUnlocked))
1693             .mul(gysrBonusShareSeconds)
1694             .div(expectedTotalShareSeconds);
1695 
1696         // compute effective bonus
1697         uint256 bonus = uint256(10**BONUS_DECIMALS)
1698             .mul(gysrBonusShareSeconds)
1699             .div(rawShareSeconds);
1700 
1701         return (
1702             reward,
1703             bonus,
1704             rawShareSeconds,
1705             totalUnlocked().add(deltaUnlocked)
1706         );
1707     }
1708 }