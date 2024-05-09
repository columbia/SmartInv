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
163 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
164 
165 
166 
167 pragma solidity ^0.6.0;
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP.
171  */
172 interface IERC20 {
173     /**
174      * @dev Returns the amount of tokens in existence.
175      */
176     function totalSupply() external view returns (uint256);
177 
178     /**
179      * @dev Returns the amount of tokens owned by `account`.
180      */
181     function balanceOf(address account) external view returns (uint256);
182 
183     /**
184      * @dev Moves `amount` tokens from the caller's account to `recipient`.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transfer(address recipient, uint256 amount) external returns (bool);
191 
192     /**
193      * @dev Returns the remaining number of tokens that `spender` will be
194      * allowed to spend on behalf of `owner` through {transferFrom}. This is
195      * zero by default.
196      *
197      * This value changes when {approve} or {transferFrom} are called.
198      */
199     function allowance(address owner, address spender) external view returns (uint256);
200 
201     /**
202      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * IMPORTANT: Beware that changing an allowance with this method brings the risk
207      * that someone may use both the old and the new allowance by unfortunate
208      * transaction ordering. One possible solution to mitigate this race
209      * condition is to first reduce the spender's allowance to 0 and set the
210      * desired value afterwards:
211      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
212      *
213      * Emits an {Approval} event.
214      */
215     function approve(address spender, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Moves `amount` tokens from `sender` to `recipient` using the
219      * allowance mechanism. `amount` is then deducted from the caller's
220      * allowance.
221      *
222      * Returns a boolean value indicating whether the operation succeeded.
223      *
224      * Emits a {Transfer} event.
225      */
226     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Emitted when `value` tokens are moved from one account (`from`) to
230      * another (`to`).
231      *
232      * Note that `value` may be zero.
233      */
234     event Transfer(address indexed from, address indexed to, uint256 value);
235 
236     /**
237      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
238      * a call to {approve}. `value` is the new allowance.
239      */
240     event Approval(address indexed owner, address indexed spender, uint256 value);
241 }
242 
243 // File: @openzeppelin/contracts/utils/Address.sol
244 
245 
246 
247 pragma solidity ^0.6.2;
248 
249 /**
250  * @dev Collection of functions related to the address type
251  */
252 library Address {
253     /**
254      * @dev Returns true if `account` is a contract.
255      *
256      * [IMPORTANT]
257      * ====
258      * It is unsafe to assume that an address for which this function returns
259      * false is an externally-owned account (EOA) and not a contract.
260      *
261      * Among others, `isContract` will return false for the following
262      * types of addresses:
263      *
264      *  - an externally-owned account
265      *  - a contract in construction
266      *  - an address where a contract will be created
267      *  - an address where a contract lived, but was destroyed
268      * ====
269      */
270     function isContract(address account) internal view returns (bool) {
271         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
272         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
273         // for accounts without code, i.e. `keccak256('')`
274         bytes32 codehash;
275         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
276         // solhint-disable-next-line no-inline-assembly
277         assembly { codehash := extcodehash(account) }
278         return (codehash != accountHash && codehash != 0x0);
279     }
280 
281     /**
282      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
283      * `recipient`, forwarding all available gas and reverting on errors.
284      *
285      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
286      * of certain opcodes, possibly making contracts go over the 2300 gas limit
287      * imposed by `transfer`, making them unable to receive funds via
288      * `transfer`. {sendValue} removes this limitation.
289      *
290      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
291      *
292      * IMPORTANT: because control is transferred to `recipient`, care must be
293      * taken to not create reentrancy vulnerabilities. Consider using
294      * {ReentrancyGuard} or the
295      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
296      */
297     function sendValue(address payable recipient, uint256 amount) internal {
298         require(address(this).balance >= amount, "Address: insufficient balance");
299 
300         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
301         (bool success, ) = recipient.call{ value: amount }("");
302         require(success, "Address: unable to send value, recipient may have reverted");
303     }
304 
305     /**
306      * @dev Performs a Solidity function call using a low level `call`. A
307      * plain`call` is an unsafe replacement for a function call: use this
308      * function instead.
309      *
310      * If `target` reverts with a revert reason, it is bubbled up by this
311      * function (like regular Solidity function calls).
312      *
313      * Returns the raw returned data. To convert to the expected return value,
314      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
315      *
316      * Requirements:
317      *
318      * - `target` must be a contract.
319      * - calling `target` with `data` must not revert.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
324       return functionCall(target, data, "Address: low-level call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
329      * `errorMessage` as a fallback revert reason when `target` reverts.
330      *
331      * _Available since v3.1._
332      */
333     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
334         return _functionCallWithValue(target, data, 0, errorMessage);
335     }
336 
337     /**
338      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
339      * but also transferring `value` wei to `target`.
340      *
341      * Requirements:
342      *
343      * - the calling contract must have an ETH balance of at least `value`.
344      * - the called Solidity function must be `payable`.
345      *
346      * _Available since v3.1._
347      */
348     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
354      * with `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
359         require(address(this).balance >= value, "Address: insufficient balance for call");
360         return _functionCallWithValue(target, data, value, errorMessage);
361     }
362 
363     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
364         require(isContract(target), "Address: call to non-contract");
365 
366         // solhint-disable-next-line avoid-low-level-calls
367         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
368         if (success) {
369             return returndata;
370         } else {
371             // Look for revert reason and bubble it up if present
372             if (returndata.length > 0) {
373                 // The easiest way to bubble the revert reason is using memory via assembly
374 
375                 // solhint-disable-next-line no-inline-assembly
376                 assembly {
377                     let returndata_size := mload(returndata)
378                     revert(add(32, returndata), returndata_size)
379                 }
380             } else {
381                 revert(errorMessage);
382             }
383         }
384     }
385 }
386 
387 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
388 
389 
390 
391 pragma solidity ^0.6.0;
392 
393 
394 
395 
396 /**
397  * @title SafeERC20
398  * @dev Wrappers around ERC20 operations that throw on failure (when the token
399  * contract returns false). Tokens that return no value (and instead revert or
400  * throw on failure) are also supported, non-reverting calls are assumed to be
401  * successful.
402  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
403  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
404  */
405 library SafeERC20 {
406     using SafeMath for uint256;
407     using Address for address;
408 
409     function safeTransfer(IERC20 token, address to, uint256 value) internal {
410         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
411     }
412 
413     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(IERC20 token, address spender, uint256 value) internal {
425         // safeApprove should only be called when setting an initial allowance,
426         // or when resetting it to zero. To increase and decrease it, use
427         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
428         // solhint-disable-next-line max-line-length
429         require((value == 0) || (token.allowance(address(this), spender) == 0),
430             "SafeERC20: approve from non-zero to non-zero allowance"
431         );
432         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
433     }
434 
435     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
436         uint256 newAllowance = token.allowance(address(this), spender).add(value);
437         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
438     }
439 
440     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
441         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
443     }
444 
445     /**
446      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
447      * on the return value: the return value is optional (but if data is returned, it must not be false).
448      * @param token The token targeted by the call.
449      * @param data The call data (encoded using abi.encode or one of its variants).
450      */
451     function _callOptionalReturn(IERC20 token, bytes memory data) private {
452         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
453         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
454         // the target address contains contract code and also asserts for success in the low-level call.
455 
456         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
457         if (returndata.length > 0) { // Return data is optional
458             // solhint-disable-next-line max-line-length
459             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
460         }
461     }
462 }
463 
464 // File: @openzeppelin/contracts/GSN/Context.sol
465 
466 
467 
468 pragma solidity ^0.6.0;
469 
470 /*
471  * @dev Provides information about the current execution context, including the
472  * sender of the transaction and its data. While these are generally available
473  * via msg.sender and msg.data, they should not be accessed in such a direct
474  * manner, since when dealing with GSN meta-transactions the account sending and
475  * paying for execution may not be the actual sender (as far as an application
476  * is concerned).
477  *
478  * This contract is only required for intermediate, library-like contracts.
479  */
480 abstract contract Context {
481     function _msgSender() internal view virtual returns (address payable) {
482         return msg.sender;
483     }
484 
485     function _msgData() internal view virtual returns (bytes memory) {
486         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
487         return msg.data;
488     }
489 }
490 
491 // File: @openzeppelin/contracts/access/Ownable.sol
492 
493 
494 
495 pragma solidity ^0.6.0;
496 
497 /**
498  * @dev Contract module which provides a basic access control mechanism, where
499  * there is an account (an owner) that can be granted exclusive access to
500  * specific functions.
501  *
502  * By default, the owner account will be the one that deploys the contract. This
503  * can later be changed with {transferOwnership}.
504  *
505  * This module is used through inheritance. It will make available the modifier
506  * `onlyOwner`, which can be applied to your functions to restrict their use to
507  * the owner.
508  */
509 contract Ownable is Context {
510     address private _owner;
511 
512     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
513 
514     /**
515      * @dev Initializes the contract setting the deployer as the initial owner.
516      */
517     constructor () internal {
518         address msgSender = _msgSender();
519         _owner = msgSender;
520         emit OwnershipTransferred(address(0), msgSender);
521     }
522 
523     /**
524      * @dev Returns the address of the current owner.
525      */
526     function owner() public view returns (address) {
527         return _owner;
528     }
529 
530     /**
531      * @dev Throws if called by any account other than the owner.
532      */
533     modifier onlyOwner() {
534         require(_owner == _msgSender(), "Ownable: caller is not the owner");
535         _;
536     }
537 
538     /**
539      * @dev Leaves the contract without owner. It will not be possible to call
540      * `onlyOwner` functions anymore. Can only be called by the current owner.
541      *
542      * NOTE: Renouncing ownership will leave the contract without an owner,
543      * thereby removing any functionality that is only available to the owner.
544      */
545     function renounceOwnership() public virtual onlyOwner {
546         emit OwnershipTransferred(_owner, address(0));
547         _owner = address(0);
548     }
549 
550     /**
551      * @dev Transfers ownership of the contract to a new account (`newOwner`).
552      * Can only be called by the current owner.
553      */
554     function transferOwnership(address newOwner) public virtual onlyOwner {
555         require(newOwner != address(0), "Ownable: new owner is the zero address");
556         emit OwnershipTransferred(_owner, newOwner);
557         _owner = newOwner;
558     }
559 }
560 
561 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
562 
563 
564 
565 pragma solidity ^0.6.0;
566 
567 /**
568  * @dev Contract module that helps prevent reentrant calls to a function.
569  *
570  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
571  * available, which can be applied to functions to make sure there are no nested
572  * (reentrant) calls to them.
573  *
574  * Note that because there is a single `nonReentrant` guard, functions marked as
575  * `nonReentrant` may not call one another. This can be worked around by making
576  * those functions `private`, and then adding `external` `nonReentrant` entry
577  * points to them.
578  *
579  * TIP: If you would like to learn more about reentrancy and alternative ways
580  * to protect against it, check out our blog post
581  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
582  */
583 contract ReentrancyGuard {
584     // Booleans are more expensive than uint256 or any type that takes up a full
585     // word because each write operation emits an extra SLOAD to first read the
586     // slot's contents, replace the bits taken up by the boolean, and then write
587     // back. This is the compiler's defense against contract upgrades and
588     // pointer aliasing, and it cannot be disabled.
589 
590     // The values being non-zero value makes deployment a bit more expensive,
591     // but in exchange the refund on every call to nonReentrant will be lower in
592     // amount. Since refunds are capped to a percentage of the total
593     // transaction's gas, it is best to keep them low in cases like this one, to
594     // increase the likelihood of the full refund coming into effect.
595     uint256 private constant _NOT_ENTERED = 1;
596     uint256 private constant _ENTERED = 2;
597 
598     uint256 private _status;
599 
600     constructor () internal {
601         _status = _NOT_ENTERED;
602     }
603 
604     /**
605      * @dev Prevents a contract from calling itself, directly or indirectly.
606      * Calling a `nonReentrant` function from another `nonReentrant`
607      * function is not supported. It is possible to prevent this from happening
608      * by making the `nonReentrant` function external, and make it call a
609      * `private` function that does the actual work.
610      */
611     modifier nonReentrant() {
612         // On the first call to nonReentrant, _notEntered will be true
613         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
614 
615         // Any calls to nonReentrant after this point will fail
616         _status = _ENTERED;
617 
618         _;
619 
620         // By storing the original value once again, a refund is triggered (see
621         // https://eips.ethereum.org/EIPS/eip-2200)
622         _status = _NOT_ENTERED;
623     }
624 }
625 
626 // File: contracts/IStaking.sol
627 
628 /*
629 Staking interface
630 
631 EIP-900 staking interface
632 
633 https://github.com/gysr-io/core
634 
635 h/t https://github.com/ethereum/EIPs/blob/master/EIPS/eip-900.md
636 
637 
638 */
639 
640 pragma solidity ^0.6.12;
641 
642 interface IStaking {
643     // events
644     event Staked(
645         address indexed user,
646         uint256 amount,
647         uint256 total,
648         bytes data
649     );
650     event Unstaked(
651         address indexed user,
652         uint256 amount,
653         uint256 total,
654         bytes data
655     );
656 
657     /**
658      * @notice stakes a certain amount of tokens, transferring this amount from
659      the user to the contract
660      * @param amount number of tokens to stake
661      */
662     function stake(uint256 amount, bytes calldata) external;
663 
664     /**
665      * @notice stakes a certain amount of tokens for an address, transfering this
666      amount from the caller to the contract, on behalf of the specified address
667      * @param user beneficiary address
668      * @param amount number of tokens to stake
669      */
670     function stakeFor(
671         address user,
672         uint256 amount,
673         bytes calldata
674     ) external;
675 
676     /**
677      * @notice unstakes a certain amount of tokens, returning these tokens
678      to the user
679      * @param amount number of tokens to unstake
680      */
681     function unstake(uint256 amount, bytes calldata) external;
682 
683     /**
684      * @param addr the address of interest
685      * @return the current total of tokens staked for an address
686      */
687     function totalStakedFor(address addr) external view returns (uint256);
688 
689     /**
690      * @return the current total amount of tokens staked by all users
691      */
692     function totalStaked() external view returns (uint256);
693 
694     /**
695      * @return the staking token for this staking contract
696      */
697     function token() external view returns (address);
698 
699     /**
700      * @return true if the staking contract support history
701      */
702     function supportsHistory() external pure returns (bool);
703 }
704 
705 // File: contracts/IGeyser.sol
706 
707 /*
708 Geyser interface
709 
710 This defines the core Geyser contract interface as an extension to the
711 standard IStaking interface
712 
713 https://github.com/gysr-io/core
714 
715 
716 */
717 
718 pragma solidity ^0.6.12;
719 
720 
721 
722 
723 /**
724  * @title Geyser interface
725  */
726 abstract contract IGeyser is IStaking, Ownable {
727     // events
728     event RewardsDistributed(address indexed user, uint256 amount);
729     event RewardsFunded(
730         uint256 amount,
731         uint256 duration,
732         uint256 start,
733         uint256 total
734     );
735     event RewardsUnlocked(uint256 amount, uint256 total);
736     event RewardsExpired(uint256 amount, uint256 duration, uint256 start);
737     event GysrSpent(address indexed user, uint256 amount);
738     event GysrWithdrawn(uint256 amount);
739 
740     // IStaking
741     /**
742      * @notice no support for history
743      * @return false
744      */
745     function supportsHistory() external override pure returns (bool) {
746         return false;
747     }
748 
749     // IGeyser
750     /**
751      * @return staking token for this Geyser
752      */
753     function stakingToken() external virtual view returns (address);
754 
755     /**
756      * @return reward token for this Geyser
757      */
758     function rewardToken() external virtual view returns (address);
759 
760     /**
761      * @notice fund Geyser by locking up reward tokens for distribution
762      * @param amount number of reward tokens to lock up as funding
763      * @param duration period (seconds) over which funding will be unlocked
764      */
765     function fund(uint256 amount, uint256 duration) external virtual;
766 
767     /**
768      * @notice fund Geyser by locking up reward tokens for future distribution
769      * @param amount number of reward tokens to lock up as funding
770      * @param duration period (seconds) over which funding will be unlocked
771      * @param start time (seconds) at which funding begins to unlock
772      */
773     function fund(
774         uint256 amount,
775         uint256 duration,
776         uint256 start
777     ) external virtual;
778 
779     /**
780      * @notice withdraw GYSR tokens applied during unstaking
781      * @param amount number of GYSR to withdraw
782      */
783     function withdraw(uint256 amount) external virtual;
784 
785     /**
786      * @notice unstake while applying GYSR token for boosted rewards
787      * @param amount number of tokens to unstake
788      * @param gysr number of GYSR tokens to apply for boost
789      */
790     function unstake(
791         uint256 amount,
792         uint256 gysr,
793         bytes calldata
794     ) external virtual;
795 
796     /**
797      * @notice update accounting, unlock tokens, etc.
798      */
799     function update() external virtual;
800 
801     /**
802      * @notice clean geyser, expire old fundings, etc.
803      */
804     function clean() external virtual;
805 }
806 
807 // File: contracts/GeyserPool.sol
808 
809 /*
810 Geyser token pool
811 
812 Simple contract to implement token pool of arbitrary ERC20 token.
813 This is owned and used by a parent Geyser
814 
815 https://github.com/gysr-io/core
816 
817 h/t https://github.com/ampleforth/token-geyser
818 
819 
820 */
821 
822 pragma solidity ^0.6.12;
823 
824 
825 
826 
827 contract GeyserPool is Ownable {
828     using SafeERC20 for IERC20;
829 
830     IERC20 public token;
831 
832     constructor(address token_) public {
833         token = IERC20(token_);
834     }
835 
836     function balance() public view returns (uint256) {
837         return token.balanceOf(address(this));
838     }
839 
840     function transfer(address to, uint256 value) external onlyOwner {
841         token.safeTransfer(to, value);
842     }
843 }
844 
845 // File: contracts/MathUtils.sol
846 
847 /*
848 Math utilities
849 
850 This library implements various logarithmic math utilies which support
851 other contracts and specifically the GYSR multiplier calculation
852 
853 https://github.com/gysr-io/core
854 
855 h/t https://github.com/abdk-consulting/abdk-libraries-solidity
856 
857 
858 */
859 
860 pragma solidity ^0.6.12;
861 
862 library MathUtils {
863     /**
864      * Calculate binary logarithm of x.  Revert if x <= 0.
865      *
866      * @param x signed 64.64-bit fixed point number
867      * @return signed 64.64-bit fixed point number
868      */
869     function logbase2(int128 x) internal pure returns (int128) {
870         require(x > 0);
871 
872         int256 msb = 0;
873         int256 xc = x;
874         if (xc >= 0x10000000000000000) {
875             xc >>= 64;
876             msb += 64;
877         }
878         if (xc >= 0x100000000) {
879             xc >>= 32;
880             msb += 32;
881         }
882         if (xc >= 0x10000) {
883             xc >>= 16;
884             msb += 16;
885         }
886         if (xc >= 0x100) {
887             xc >>= 8;
888             msb += 8;
889         }
890         if (xc >= 0x10) {
891             xc >>= 4;
892             msb += 4;
893         }
894         if (xc >= 0x4) {
895             xc >>= 2;
896             msb += 2;
897         }
898         if (xc >= 0x2) msb += 1; // No need to shift xc anymore
899 
900         int256 result = (msb - 64) << 64;
901         uint256 ux = uint256(x) << (127 - msb);
902         for (int256 bit = 0x8000000000000000; bit > 0; bit >>= 1) {
903             ux *= ux;
904             uint256 b = ux >> 255;
905             ux >>= 127 + b;
906             result += bit * int256(b);
907         }
908 
909         return int128(result);
910     }
911 
912     /**
913      * @notice calculate natural logarithm of x
914      * @dev magic constant comes from ln(2) * 2^128 -> hex
915      * @param x signed 64.64-bit fixed point number, require x > 0
916      * @return signed 64.64-bit fixed point number
917      */
918     function ln(int128 x) internal pure returns (int128) {
919         require(x > 0);
920 
921         return
922             int128(
923                 (uint256(logbase2(x)) * 0xB17217F7D1CF79ABC9E3B39803F2F6AF) >>
924                     128
925             );
926     }
927 
928     /**
929      * @notice calculate logarithm base 10 of x
930      * @dev magic constant comes from log10(2) * 2^128 -> hex
931      * @param x signed 64.64-bit fixed point number, require x > 0
932      * @return signed 64.64-bit fixed point number
933      */
934     function logbase10(int128 x) internal pure returns (int128) {
935         require(x > 0);
936 
937         return
938             int128(
939                 (uint256(logbase2(x)) * 0x4d104d427de7fce20a6e420e02236748) >>
940                     128
941             );
942     }
943 
944     // wrapper functions to allow testing
945     function testlogbase2(int128 x) public pure returns (int128) {
946         return logbase2(x);
947     }
948 
949     function testlogbase10(int128 x) public pure returns (int128) {
950         return logbase10(x);
951     }
952 }
953 
954 // File: contracts/Geyser.sol
955 
956 /*
957 Geyser
958 
959 This implements the core Geyser contract, which allows for generalized
960 staking, yield farming, and token distribution. This also implements
961 the GYSR spending mechanic for boosted reward distribution.
962 
963 https://github.com/gysr-io/core
964 
965 h/t https://github.com/ampleforth/token-geyser
966 
967 
968 */
969 
970 pragma solidity ^0.6.12;
971 
972 
973 
974 
975 
976 
977 
978 
979 
980 /**
981  * @title Geyser
982  */
983 contract Geyser is IGeyser, ReentrancyGuard {
984     using SafeMath for uint256;
985     using SafeERC20 for IERC20;
986     using MathUtils for int128;
987 
988     // single stake by user
989     struct Stake {
990         uint256 shares;
991         uint256 timestamp;
992     }
993 
994     // summary of total user stake/shares
995     struct User {
996         uint256 shares;
997         uint256 shareSeconds;
998         uint256 lastUpdated;
999     }
1000 
1001     // single funding/reward schedule
1002     struct Funding {
1003         uint256 amount;
1004         uint256 shares;
1005         uint256 unlocked;
1006         uint256 lastUpdated;
1007         uint256 start;
1008         uint256 end;
1009         uint256 duration;
1010     }
1011 
1012     // constants
1013     uint256 public constant BONUS_DECIMALS = 18;
1014     uint256 public constant INITIAL_SHARES_PER_TOKEN = 10**6;
1015     uint256 public constant MAX_ACTIVE_FUNDINGS = 16;
1016 
1017     // token pool fields
1018     GeyserPool private immutable _stakingPool;
1019     GeyserPool private immutable _unlockedPool;
1020     GeyserPool private immutable _lockedPool;
1021     Funding[] public fundings;
1022 
1023     // user staking fields
1024     mapping(address => User) public userTotals;
1025     mapping(address => Stake[]) public userStakes;
1026 
1027     // time bonus fields
1028     uint256 public immutable bonusMin;
1029     uint256 public immutable bonusMax;
1030     uint256 public immutable bonusPeriod;
1031 
1032     // global state fields
1033     uint256 public totalLockedShares;
1034     uint256 public totalStakingShares;
1035     uint256 public totalRewards;
1036     uint256 public totalGysrRewards;
1037     uint256 public totalStakingShareSeconds;
1038     uint256 public lastUpdated;
1039 
1040     // gysr fields
1041     IERC20 private immutable _gysr;
1042 
1043     /**
1044      * @param stakingToken_ the token that will be staked
1045      * @param rewardToken_ the token distributed to users as they unstake
1046      * @param bonusMin_ initial time bonus
1047      * @param bonusMax_ maximum time bonus
1048      * @param bonusPeriod_ period (in seconds) over which time bonus grows to max
1049      * @param gysr_ address for GYSR token
1050      */
1051     constructor(
1052         address stakingToken_,
1053         address rewardToken_,
1054         uint256 bonusMin_,
1055         uint256 bonusMax_,
1056         uint256 bonusPeriod_,
1057         address gysr_
1058     ) public {
1059         require(
1060             bonusMin_ <= bonusMax_,
1061             "Geyser: initial time bonus greater than max"
1062         );
1063 
1064         _stakingPool = new GeyserPool(stakingToken_);
1065         _unlockedPool = new GeyserPool(rewardToken_);
1066         _lockedPool = new GeyserPool(rewardToken_);
1067 
1068         bonusMin = bonusMin_;
1069         bonusMax = bonusMax_;
1070         bonusPeriod = bonusPeriod_;
1071 
1072         _gysr = IERC20(gysr_);
1073 
1074         lastUpdated = block.timestamp;
1075     }
1076 
1077     // IStaking
1078 
1079     /**
1080      * @inheritdoc IStaking
1081      */
1082     function stake(uint256 amount, bytes calldata) external override {
1083         _stake(msg.sender, msg.sender, amount);
1084     }
1085 
1086     /**
1087      * @inheritdoc IStaking
1088      */
1089     function stakeFor(
1090         address user,
1091         uint256 amount,
1092         bytes calldata
1093     ) external override {
1094         _stake(msg.sender, user, amount);
1095     }
1096 
1097     /**
1098      * @inheritdoc IStaking
1099      */
1100     function unstake(uint256 amount, bytes calldata) external override {
1101         _unstake(amount, 0);
1102     }
1103 
1104     /**
1105      * @inheritdoc IStaking
1106      */
1107     function totalStakedFor(address addr)
1108         public
1109         override
1110         view
1111         returns (uint256)
1112     {
1113         if (totalStakingShares == 0) {
1114             return 0;
1115         }
1116         return
1117             totalStaked().mul(userTotals[addr].shares).div(totalStakingShares);
1118     }
1119 
1120     /**
1121      * @inheritdoc IStaking
1122      */
1123     function totalStaked() public override view returns (uint256) {
1124         return _stakingPool.balance();
1125     }
1126 
1127     /**
1128      * @inheritdoc IStaking
1129      * @dev redundant with stakingToken() in order to implement IStaking (EIP-900)
1130      */
1131     function token() external override view returns (address) {
1132         return address(_stakingPool.token());
1133     }
1134 
1135     // IGeyser
1136 
1137     /**
1138      * @inheritdoc IGeyser
1139      */
1140     function stakingToken() public override view returns (address) {
1141         return address(_stakingPool.token());
1142     }
1143 
1144     /**
1145      * @inheritdoc IGeyser
1146      */
1147     function rewardToken() public override view returns (address) {
1148         return address(_unlockedPool.token());
1149     }
1150 
1151     /**
1152      * @inheritdoc IGeyser
1153      */
1154     function fund(uint256 amount, uint256 duration) public override {
1155         fund(amount, duration, block.timestamp);
1156     }
1157 
1158     /**
1159      * @inheritdoc IGeyser
1160      */
1161     function fund(
1162         uint256 amount,
1163         uint256 duration,
1164         uint256 start
1165     ) public override onlyOwner {
1166         // validate
1167         require(amount > 0, "Geyser: funding amount is zero");
1168         require(start >= block.timestamp, "Geyser: funding start is past");
1169         require(
1170             fundings.length < MAX_ACTIVE_FUNDINGS,
1171             "Geyser: exceeds max active funding schedules"
1172         );
1173 
1174         // update bookkeeping
1175         _update(msg.sender);
1176 
1177         // mint shares at current rate
1178         uint256 lockedTokens = totalLocked();
1179         uint256 mintedLockedShares = (lockedTokens > 0)
1180             ? totalLockedShares.mul(amount).div(lockedTokens)
1181             : amount.mul(INITIAL_SHARES_PER_TOKEN);
1182 
1183         totalLockedShares = totalLockedShares.add(mintedLockedShares);
1184 
1185         // create new funding
1186         fundings.push(
1187             Funding({
1188                 amount: amount,
1189                 shares: mintedLockedShares,
1190                 unlocked: 0,
1191                 lastUpdated: start,
1192                 start: start,
1193                 end: start.add(duration),
1194                 duration: duration
1195             })
1196         );
1197 
1198         // do transfer of funding
1199         _lockedPool.token().safeTransferFrom(
1200             msg.sender,
1201             address(_lockedPool),
1202             amount
1203         );
1204         emit RewardsFunded(amount, duration, start, totalLocked());
1205     }
1206 
1207     /**
1208      * @inheritdoc IGeyser
1209      */
1210     function withdraw(uint256 amount) external override onlyOwner {
1211         require(amount > 0, "Geyser: withdraw amount is zero");
1212         require(
1213             amount <= _gysr.balanceOf(address(this)),
1214             "Geyser: withdraw amount exceeds balance"
1215         );
1216         // do transfer
1217         _gysr.safeTransfer(msg.sender, amount);
1218 
1219         emit GysrWithdrawn(amount);
1220     }
1221 
1222     /**
1223      * @inheritdoc IGeyser
1224      */
1225     function unstake(
1226         uint256 amount,
1227         uint256 gysr,
1228         bytes calldata
1229     ) external override {
1230         _unstake(amount, gysr);
1231     }
1232 
1233     /**
1234      * @inheritdoc IGeyser
1235      */
1236     function update() external override nonReentrant {
1237         _update(msg.sender);
1238     }
1239 
1240     /**
1241      * @inheritdoc IGeyser
1242      */
1243     function clean() external override onlyOwner {
1244         // update bookkeeping
1245         _update(msg.sender);
1246 
1247         // check for stale funding schedules to expire
1248         uint256 removed = 0;
1249         uint256 originalSize = fundings.length;
1250         for (uint256 i = 0; i < originalSize; i++) {
1251             Funding storage funding = fundings[i.sub(removed)];
1252             uint256 idx = i.sub(removed);
1253 
1254             if (_unlockable(idx) == 0 && block.timestamp >= funding.end) {
1255                 emit RewardsExpired(
1256                     funding.amount,
1257                     funding.duration,
1258                     funding.start
1259                 );
1260 
1261                 // remove at idx by copying last element here, then popping off last
1262                 // (we don't care about order)
1263                 fundings[idx] = fundings[fundings.length.sub(1)];
1264                 fundings.pop();
1265                 removed = removed.add(1);
1266             }
1267         }
1268     }
1269 
1270     // Geyser
1271 
1272     /**
1273      * @dev internal implementation of staking methods
1274      * @param staker address to do deposit of staking tokens
1275      * @param beneficiary address to gain credit for this stake operation
1276      * @param amount number of staking tokens to deposit
1277      */
1278     function _stake(
1279         address staker,
1280         address beneficiary,
1281         uint256 amount
1282     ) private nonReentrant {
1283         // validate
1284         require(amount > 0, "Geyser: stake amount is zero");
1285         require(
1286             beneficiary != address(0),
1287             "Geyser: beneficiary is zero address"
1288         );
1289 
1290         // mint staking shares at current rate
1291         uint256 mintedStakingShares = (totalStakingShares > 0)
1292             ? totalStakingShares.mul(amount).div(totalStaked())
1293             : amount.mul(INITIAL_SHARES_PER_TOKEN);
1294         require(mintedStakingShares > 0, "Geyser: stake amount too small");
1295 
1296         // update bookkeeping
1297         _update(beneficiary);
1298 
1299         // update user staking info
1300         User storage user = userTotals[beneficiary];
1301         user.shares = user.shares.add(mintedStakingShares);
1302         user.lastUpdated = block.timestamp;
1303 
1304         userStakes[beneficiary].push(
1305             Stake(mintedStakingShares, block.timestamp)
1306         );
1307 
1308         // add newly minted shares to global total
1309         totalStakingShares = totalStakingShares.add(mintedStakingShares);
1310 
1311         // transactions
1312         _stakingPool.token().safeTransferFrom(
1313             staker,
1314             address(_stakingPool),
1315             amount
1316         );
1317 
1318         emit Staked(beneficiary, amount, totalStakedFor(beneficiary), "");
1319     }
1320 
1321     /**
1322      * @dev internal implementation of unstaking methods
1323      * @param amount number of tokens to unstake
1324      * @param gysr number of GYSR tokens applied to unstaking operation
1325      * @return number of reward tokens distributed
1326      */
1327     function _unstake(uint256 amount, uint256 gysr)
1328         private
1329         nonReentrant
1330         returns (uint256)
1331     {
1332         // validate
1333         require(amount > 0, "Geyser: unstake amount is zero");
1334         require(
1335             totalStakedFor(msg.sender) >= amount,
1336             "Geyser: unstake amount exceeds balance"
1337         );
1338 
1339         // update bookkeeping
1340         _update(msg.sender);
1341 
1342         // do unstaking, first-in last-out, respecting time bonus
1343         uint256 timeWeightedShareSeconds = _unstakeFirstInLastOut(amount);
1344 
1345         // compute and apply GYSR token bonus
1346         uint256 gysrWeightedShareSeconds = gysrBonus(gysr)
1347             .mul(timeWeightedShareSeconds)
1348             .div(10**BONUS_DECIMALS);
1349 
1350         uint256 rewardAmount = totalUnlocked()
1351             .mul(gysrWeightedShareSeconds)
1352             .div(totalStakingShareSeconds.add(gysrWeightedShareSeconds));
1353 
1354         // update global stats for distributions
1355         if (gysr > 0) {
1356             totalGysrRewards = totalGysrRewards.add(rewardAmount);
1357         }
1358         totalRewards = totalRewards.add(rewardAmount);
1359 
1360         // transactions
1361         _stakingPool.transfer(msg.sender, amount);
1362         emit Unstaked(msg.sender, amount, totalStakedFor(msg.sender), "");
1363         if (rewardAmount > 0) {
1364             _unlockedPool.transfer(msg.sender, rewardAmount);
1365             emit RewardsDistributed(msg.sender, rewardAmount);
1366         }
1367         if (gysr > 0) {
1368             _gysr.safeTransferFrom(msg.sender, address(this), gysr);
1369             emit GysrSpent(msg.sender, gysr);
1370         }
1371         return rewardAmount;
1372     }
1373 
1374     /**
1375      * @dev helper function to actually execute unstaking, first-in last-out, 
1376      while computing and applying time bonus. This function also updates
1377      user and global totals for shares and share-seconds.
1378      * @param amount number of staking tokens to withdraw
1379      * @return time bonus weighted staking share seconds
1380      */
1381     function _unstakeFirstInLastOut(uint256 amount) private returns (uint256) {
1382         uint256 stakingSharesToBurn = totalStakingShares.mul(amount).div(
1383             totalStaked()
1384         );
1385         require(stakingSharesToBurn > 0, "Geyser: unstake amount too small");
1386 
1387         // redeem from most recent stake and go backwards in time.
1388         uint256 shareSecondsToBurn = 0;
1389         uint256 sharesLeftToBurn = stakingSharesToBurn;
1390         uint256 bonusWeightedShareSeconds = 0;
1391         Stake[] storage stakes = userStakes[msg.sender];
1392         while (sharesLeftToBurn > 0) {
1393             Stake storage lastStake = stakes[stakes.length - 1];
1394             uint256 stakeTime = block.timestamp.sub(lastStake.timestamp);
1395 
1396             uint256 bonus = timeBonus(stakeTime);
1397 
1398             if (lastStake.shares <= sharesLeftToBurn) {
1399                 // fully redeem a past stake
1400                 bonusWeightedShareSeconds = bonusWeightedShareSeconds.add(
1401                     lastStake.shares.mul(stakeTime).mul(bonus).div(
1402                         10**BONUS_DECIMALS
1403                     )
1404                 );
1405                 shareSecondsToBurn = shareSecondsToBurn.add(
1406                     lastStake.shares.mul(stakeTime)
1407                 );
1408                 sharesLeftToBurn = sharesLeftToBurn.sub(lastStake.shares);
1409                 stakes.pop();
1410             } else {
1411                 // partially redeem a past stake
1412                 bonusWeightedShareSeconds = bonusWeightedShareSeconds.add(
1413                     sharesLeftToBurn.mul(stakeTime).mul(bonus).div(
1414                         10**BONUS_DECIMALS
1415                     )
1416                 );
1417                 shareSecondsToBurn = shareSecondsToBurn.add(
1418                     sharesLeftToBurn.mul(stakeTime)
1419                 );
1420                 lastStake.shares = lastStake.shares.sub(sharesLeftToBurn);
1421                 sharesLeftToBurn = 0;
1422             }
1423         }
1424         // update user totals
1425         User storage user = userTotals[msg.sender];
1426         user.shareSeconds = user.shareSeconds.sub(shareSecondsToBurn);
1427         user.shares = user.shares.sub(stakingSharesToBurn);
1428         user.lastUpdated = block.timestamp;
1429 
1430         // update global totals
1431         totalStakingShareSeconds = totalStakingShareSeconds.sub(
1432             shareSecondsToBurn
1433         );
1434         totalStakingShares = totalStakingShares.sub(stakingSharesToBurn);
1435 
1436         return bonusWeightedShareSeconds;
1437     }
1438 
1439     /**
1440      * @dev internal implementation of update method
1441      * @param addr address for user accounting update
1442      */
1443     function _update(address addr) private {
1444         _unlockTokens();
1445 
1446         // global accounting
1447         uint256 deltaTotalShareSeconds = (block.timestamp.sub(lastUpdated)).mul(
1448             totalStakingShares
1449         );
1450         totalStakingShareSeconds = totalStakingShareSeconds.add(
1451             deltaTotalShareSeconds
1452         );
1453         lastUpdated = block.timestamp;
1454 
1455         // user accounting
1456         User storage user = userTotals[addr];
1457         uint256 deltaUserShareSeconds = (block.timestamp.sub(user.lastUpdated))
1458             .mul(user.shares);
1459         user.shareSeconds = user.shareSeconds.add(deltaUserShareSeconds);
1460         user.lastUpdated = block.timestamp;
1461     }
1462 
1463     /**
1464      * @dev unlocks reward tokens based on funding schedules
1465      */
1466     function _unlockTokens() private {
1467         uint256 tokensToUnlock = 0;
1468         uint256 lockedTokens = totalLocked();
1469 
1470         if (totalLockedShares == 0) {
1471             // handle any leftover
1472             tokensToUnlock = lockedTokens;
1473         } else {
1474             // normal case: unlock some shares from each funding schedule
1475             uint256 sharesToUnlock = 0;
1476             for (uint256 i = 0; i < fundings.length; i++) {
1477                 uint256 shares = _unlockable(i);
1478                 Funding storage funding = fundings[i];
1479                 if (shares > 0) {
1480                     funding.unlocked = funding.unlocked.add(shares);
1481                     funding.lastUpdated = block.timestamp;
1482                     sharesToUnlock = sharesToUnlock.add(shares);
1483                 }
1484             }
1485             tokensToUnlock = sharesToUnlock.mul(lockedTokens).div(
1486                 totalLockedShares
1487             );
1488             totalLockedShares = totalLockedShares.sub(sharesToUnlock);
1489         }
1490 
1491         if (tokensToUnlock > 0) {
1492             _lockedPool.transfer(address(_unlockedPool), tokensToUnlock);
1493             emit RewardsUnlocked(tokensToUnlock, totalUnlocked());
1494         }
1495     }
1496 
1497     /**
1498      * @dev helper function to compute updates to funding schedules
1499      * @param idx index of the funding
1500      * @return the number of unlockable shares
1501      */
1502     function _unlockable(uint256 idx) private view returns (uint256) {
1503         Funding storage funding = fundings[idx];
1504 
1505         // funding schedule is in future
1506         if (block.timestamp < funding.start) {
1507             return 0;
1508         }
1509         // empty
1510         if (funding.unlocked >= funding.shares) {
1511             return 0;
1512         }
1513         // handle zero-duration period or leftover dust from integer division
1514         if (block.timestamp >= funding.end) {
1515             return funding.shares.sub(funding.unlocked);
1516         }
1517 
1518         return
1519             (block.timestamp.sub(funding.lastUpdated)).mul(funding.shares).div(
1520                 funding.duration
1521             );
1522     }
1523 
1524     /**
1525      * @notice compute time bonus earned as a function of staking time
1526      * @param time length of time for which the tokens have been staked
1527      * @return bonus multiplier for time
1528      */
1529     function timeBonus(uint256 time) public view returns (uint256) {
1530         if (time >= bonusPeriod) {
1531             return uint256(10**BONUS_DECIMALS).add(bonusMax);
1532         }
1533 
1534         // linearly interpolate between bonus min and bonus max
1535         uint256 bonus = bonusMin.add(
1536             (bonusMax.sub(bonusMin)).mul(time).div(bonusPeriod)
1537         );
1538         return uint256(10**BONUS_DECIMALS).add(bonus);
1539     }
1540 
1541     /**
1542      * @notice compute GYSR bonus as a function of usage ratio and GYSR spent
1543      * @param gysr number of GYSR token applied to bonus
1544      * @return multiplier value
1545      */
1546     function gysrBonus(uint256 gysr) public view returns (uint256) {
1547         if (gysr == 0) {
1548             return 10**BONUS_DECIMALS;
1549         }
1550         require(
1551             gysr >= 10**BONUS_DECIMALS,
1552             "Geyser: GYSR amount is between 0 and 1"
1553         );
1554 
1555         uint256 buffer = uint256(10**(BONUS_DECIMALS - 2)); // 0.01
1556         uint256 r = ratio().add(buffer);
1557         uint256 x = gysr.add(buffer);
1558 
1559         return
1560             uint256(10**BONUS_DECIMALS).add(
1561                 uint256(int128(x.mul(2**64).div(r)).logbase10())
1562                     .mul(10**BONUS_DECIMALS)
1563                     .div(2**64)
1564             );
1565     }
1566 
1567     /**
1568      * @return portion of rewards which have been boosted by GYSR token
1569      */
1570     function ratio() public view returns (uint256) {
1571         if (totalRewards == 0) {
1572             return 0;
1573         }
1574         return totalGysrRewards.mul(10**BONUS_DECIMALS).div(totalRewards);
1575     }
1576 
1577     // Geyser -- informational functions
1578 
1579     /**
1580      * @return total number of locked reward tokens
1581      */
1582     function totalLocked() public view returns (uint256) {
1583         return _lockedPool.balance();
1584     }
1585 
1586     /**
1587      * @return total number of unlocked reward tokens
1588      */
1589     function totalUnlocked() public view returns (uint256) {
1590         return _unlockedPool.balance();
1591     }
1592 
1593     /**
1594      * @return number of active funding schedules
1595      */
1596     function fundingCount() public view returns (uint256) {
1597         return fundings.length;
1598     }
1599 
1600     /**
1601      * @param addr address of interest
1602      * @return number of active stakes for user
1603      */
1604     function stakeCount(address addr) public view returns (uint256) {
1605         return userStakes[addr].length;
1606     }
1607 
1608     /**
1609      * @notice preview estimated reward distribution for full unstake with no GYSR applied
1610      * @return estimated reward
1611      * @return estimated overall multiplier
1612      * @return estimated raw user share seconds that would be burned
1613      * @return estimated total unlocked rewards
1614      */
1615     function preview()
1616         public
1617         view
1618         returns (
1619             uint256,
1620             uint256,
1621             uint256,
1622             uint256
1623         )
1624     {
1625         return preview(msg.sender, totalStakedFor(msg.sender), 0);
1626     }
1627 
1628     /**
1629      * @notice preview estimated reward distribution for unstaking
1630      * @param addr address of interest for preview
1631      * @param amount number of tokens that would be unstaked
1632      * @param gysr number of GYSR tokens that would be applied
1633      * @return estimated reward
1634      * @return estimated overall multiplier
1635      * @return estimated raw user share seconds that would be burned
1636      * @return estimated total unlocked rewards
1637      */
1638     function preview(
1639         address addr,
1640         uint256 amount,
1641         uint256 gysr
1642     )
1643         public
1644         view
1645         returns (
1646             uint256,
1647             uint256,
1648             uint256,
1649             uint256
1650         )
1651     {
1652         // compute expected updates to global totals
1653         uint256 deltaUnlocked = 0;
1654         if (totalLockedShares != 0) {
1655             uint256 sharesToUnlock = 0;
1656             for (uint256 i = 0; i < fundings.length; i++) {
1657                 sharesToUnlock = sharesToUnlock.add(_unlockable(i));
1658             }
1659             deltaUnlocked = sharesToUnlock.mul(totalLocked()).div(
1660                 totalLockedShares
1661             );
1662         }
1663 
1664         // no need for unstaking/rewards computation
1665         if (amount == 0) {
1666             return (0, 0, 0, totalUnlocked().add(deltaUnlocked));
1667         }
1668 
1669         // check unstake amount
1670         require(
1671             amount <= totalStakedFor(addr),
1672             "Geyser: preview amount exceeds balance"
1673         );
1674 
1675         // compute unstake amount in shares
1676         uint256 shares = totalStakingShares.mul(amount).div(totalStaked());
1677         require(shares > 0, "Geyser: preview amount too small");
1678 
1679         uint256 rawShareSeconds = 0;
1680         uint256 timeBonusShareSeconds = 0;
1681 
1682         // compute first-in-last-out, time bonus weighted, share seconds
1683         uint256 i = userStakes[addr].length.sub(1);
1684         while (shares > 0) {
1685             Stake storage s = userStakes[addr][i];
1686             uint256 time = block.timestamp.sub(s.timestamp);
1687 
1688             if (s.shares < shares) {
1689                 rawShareSeconds = rawShareSeconds.add(s.shares.mul(time));
1690                 timeBonusShareSeconds = timeBonusShareSeconds.add(
1691                     s.shares.mul(time).mul(timeBonus(time)).div(
1692                         10**BONUS_DECIMALS
1693                     )
1694                 );
1695                 shares = shares.sub(s.shares);
1696             } else {
1697                 rawShareSeconds = rawShareSeconds.add(shares.mul(time));
1698                 timeBonusShareSeconds = timeBonusShareSeconds.add(
1699                     shares.mul(time).mul(timeBonus(time)).div(
1700                         10**BONUS_DECIMALS
1701                     )
1702                 );
1703                 break;
1704             }
1705             // this will throw on underflow
1706             i = i.sub(1);
1707         }
1708 
1709         // apply gysr bonus
1710         uint256 gysrBonusShareSeconds = gysrBonus(gysr)
1711             .mul(timeBonusShareSeconds)
1712             .div(10**BONUS_DECIMALS);
1713 
1714         // compute rewards based on expected updates
1715         uint256 expectedTotalShareSeconds = totalStakingShareSeconds
1716             .add((block.timestamp.sub(lastUpdated)).mul(totalStakingShares))
1717             .add(gysrBonusShareSeconds)
1718             .sub(rawShareSeconds);
1719 
1720         uint256 reward = (totalUnlocked().add(deltaUnlocked))
1721             .mul(gysrBonusShareSeconds)
1722             .div(expectedTotalShareSeconds);
1723 
1724         // compute effective bonus
1725         uint256 bonus = uint256(10**BONUS_DECIMALS)
1726             .mul(gysrBonusShareSeconds)
1727             .div(rawShareSeconds);
1728 
1729         return (
1730             reward,
1731             bonus,
1732             rawShareSeconds,
1733             totalUnlocked().add(deltaUnlocked)
1734         );
1735     }
1736 }