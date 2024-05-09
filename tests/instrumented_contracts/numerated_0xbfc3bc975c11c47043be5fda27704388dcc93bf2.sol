1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
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
84 
85 pragma solidity ^0.6.0;
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      *
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b <= a, errorMessage);
144         uint256 c = a - b;
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `*` operator.
154      *
155      * Requirements:
156      *
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      *
183      * - The divisor cannot be zero.
184      */
185     function div(uint256 a, uint256 b) internal pure returns (uint256) {
186         return div(a, b, "SafeMath: division by zero");
187     }
188 
189     /**
190      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
191      * division by zero. The result is rounded towards zero.
192      *
193      * Counterpart to Solidity's `/` operator. Note: this function uses a
194      * `revert` opcode (which leaves remaining gas untouched) while Solidity
195      * uses an invalid opcode to revert (consuming all remaining gas).
196      *
197      * Requirements:
198      *
199      * - The divisor cannot be zero.
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b > 0, errorMessage);
203         uint256 c = a / b;
204         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
211      * Reverts when dividing by zero.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b != 0, errorMessage);
239         return a % b;
240     }
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
561 // File: contracts/lib/Shutdownable.sol
562 
563 
564 pragma solidity ^0.6.0;
565 
566 
567 contract Shutdownable is Ownable {
568     bool public isShutdown;
569 
570     event Shutdown();
571 
572     modifier notShutdown {
573         require(!isShutdown, "Smart contract is shut down.");
574         _;
575     }
576 
577     function shutdown() public onlyOwner {
578         isShutdown = true;
579         emit Shutdown();
580     }
581 }
582 
583 // File: contracts/lib/UniversalERC20.sol
584 
585 
586 pragma solidity ^0.6.0;
587 
588 
589 
590 
591 /**
592  * @dev See https://github.com/CryptoManiacsZone/1inchProtocol/blob/master/contracts/UniversalERC20.sol
593  */
594 library UniversalERC20 {
595     using SafeMath for uint256;
596     using SafeERC20 for IERC20;
597 
598     IERC20 private constant ZERO_ADDRESS = IERC20(0x0000000000000000000000000000000000000000);
599     IERC20 private constant ETH_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
600 
601     function universalTransfer(
602         IERC20 token,
603         address to,
604         uint256 amount
605     ) internal returns (bool) {
606         if (amount == 0) {
607             return true;
608         }
609 
610         if (isETH(token)) {
611             payable(to).transfer(amount);
612             return true;
613         } else {
614             token.safeTransfer(to, amount);
615             return true;
616         }
617     }
618 
619     function universalTransferFrom(
620         IERC20 token,
621         address from,
622         address to,
623         uint256 amount
624     ) internal {
625         if (amount == 0) {
626             return;
627         }
628 
629         if (isETH(token)) {
630             require(from == msg.sender && msg.value >= amount, "Wrong useage of ETH.universalTransferFrom()");
631             if (to != address(this)) {
632                 address(uint160(to)).transfer(amount);
633             }
634             if (msg.value > amount) {
635                 // return the remainder
636                 msg.sender.transfer(msg.value.sub(amount));
637             }
638         } else {
639             token.safeTransferFrom(from, to, amount);
640         }
641     }
642 
643     function universalTransferFromSenderToThis(IERC20 token, uint256 amount) internal {
644         if (amount == 0) {
645             return;
646         }
647 
648         if (isETH(token)) {
649             if (msg.value > amount) {
650                 // return the remainder
651                 msg.sender.transfer(msg.value.sub(amount));
652             }
653         } else {
654             token.safeTransferFrom(msg.sender, address(this), amount);
655         }
656     }
657 
658     function universalApprove(
659         IERC20 token,
660         address to,
661         uint256 amount
662     ) internal {
663         if (!isETH(token)) {
664             if (amount == 0) {
665                 token.safeApprove(to, 0);
666                 return;
667             }
668 
669             uint256 allowance = token.allowance(address(this), to);
670             if (allowance < amount) {
671                 if (allowance > 0) {
672                     token.safeApprove(to, 0);
673                 }
674                 token.safeApprove(to, amount);
675             }
676         }
677     }
678 
679     function universalBalanceOf(IERC20 token, address who) internal view returns (uint256) {
680         if (isETH(token)) {
681             return who.balance;
682         } else {
683             return token.balanceOf(who);
684         }
685     }
686 
687     function universalDecimals(IERC20 token) internal view returns (uint256) {
688         if (isETH(token)) {
689             return 18;
690         }
691 
692         (bool success, bytes memory data) = address(token).staticcall{gas: 10000}(abi.encodeWithSignature("decimals()"));
693         if (!success || data.length == 0) {
694             (success, data) = address(token).staticcall{gas: 10000}(abi.encodeWithSignature("DECIMALS()"));
695         }
696 
697         return (success && data.length > 0) ? abi.decode(data, (uint256)) : 18;
698     }
699 
700     function isETH(IERC20 token) internal pure returns (bool) {
701         return (address(token) == address(ZERO_ADDRESS) || address(token) == address(ETH_ADDRESS));
702     }
703 
704     function notExist(IERC20 token) internal pure returns (bool) {
705         return (address(token) == address(-1));
706     }
707 }
708 
709 // File: contracts/lib/ExternalCall.sol
710 
711 
712 pragma solidity ^0.6.0;
713 
714 library ExternalCall {
715     // Source: https://github.com/gnosis/MultiSigWallet/blob/master/contracts/MultiSigWallet.sol
716     // call has been separated into its own function in order to take advantage
717     // of the Solidity's code generator to produce a loop that copies tx.data into memory.
718     function externalCall(
719         address target,
720         uint256 value,
721         bytes memory data,
722         uint256 dataOffset,
723         uint256 dataLength,
724         uint256 gasLimit
725     ) internal returns (bool result) {
726         if (gasLimit == 0) {
727             gasLimit = gasleft() - 40000;
728         }
729         assembly {
730             let x := mload(0x40) // "Allocate" memory for output (0x40 is where "free memory" pointer is stored by convention)
731             let d := add(data, 32) // First 32 bytes are the padded length of data, so exclude that
732             result := call(
733                 gasLimit,
734                 target,
735                 value,
736                 add(d, dataOffset),
737                 dataLength, // Size of the input (in bytes) - this is what fixes the padding problem
738                 x,
739                 0 // Output is ignored, therefore the output size is zero
740             )
741         }
742     }
743 }
744 
745 // File: contracts/OpenOceanExchange.sol
746 
747 
748 pragma solidity ^0.6.0;
749 
750 
751 
752 
753 
754 
755 contract OpenOceanExchange is Shutdownable {
756     using SafeMath for uint256;
757     using SafeERC20 for IERC20;
758     using UniversalERC20 for IERC20;
759     using ExternalCall for address;
760 
761     uint256 private feeRate;
762 
763     event FeeRateChanged(uint256 indexed oldFeeRate, uint256 indexed newFeeRate);
764 
765     event Order(address indexed sender, IERC20 indexed inToken, IERC20 indexed outToken, uint256 inAmount, uint256 outAmount);
766 
767     event Swapped(
768         IERC20 indexed inToken,
769         IERC20 indexed outToken,
770         address indexed referrer,
771         uint256 inAmount,
772         uint256 outAmount,
773         uint256 fee,
774         uint256 referrerFee
775     );
776 
777     constructor(address _owner, uint256 _feeRate) public {
778         transferOwnership(_owner);
779         feeRate = _feeRate;
780     }
781 
782     function changeFeeRate(uint256 _feeRate) public onlyOwner {
783         uint256 oldFeeRate = feeRate;
784         feeRate = _feeRate;
785         emit FeeRateChanged(oldFeeRate, _feeRate);
786     }
787 
788     receive() external payable notShutdown {
789         require(msg.sender != tx.origin);
790     }
791 
792     function swap(
793         IERC20 inToken,
794         IERC20 outToken,
795         uint256 inAmount,
796         uint256 minOutAmount,
797         uint256 guaranteedAmount,
798         address payable referrer,
799         address[] memory addressesToCall,
800         bytes memory dataToCall,
801         uint256[] memory offsets,
802         uint256[] memory gasLimitsAndValues
803     ) public payable notShutdown returns (uint256 outAmount) {
804         require(minOutAmount > 0, "Min out amount should be greater than zero.");
805         require(addressesToCall.length > 0, "Call data should exists.");
806         require((msg.value != 0) == inToken.isETH(), "OpenOcean: msg.value should be used only for ETH swap");
807 
808         if (!inToken.isETH()) {
809             inToken.safeTransferFrom(msg.sender, address(this), inAmount);
810         }
811 
812         for (uint256 i = 0; i < addressesToCall.length; i++) {
813             require(
814                 addressesToCall[i].externalCall(
815                     gasLimitsAndValues[i] & ((1 << 128) - 1),
816                     dataToCall,
817                     offsets[i],
818                     offsets[i + 1] - offsets[i],
819                     gasLimitsAndValues[i] >> 128
820                 )
821             );
822         }
823 
824         inToken.universalTransfer(msg.sender, inToken.universalBalanceOf(address(this)));
825         outAmount = outToken.universalBalanceOf(address(this));
826         uint256 fee;
827         uint256 referrerFee;
828         (outAmount, fee, referrerFee) = handleFees(outToken, outAmount, guaranteedAmount, referrer);
829 
830         require(outAmount >= minOutAmount, "Return amount less than the minimum required amount");
831         outToken.universalTransfer(msg.sender, outAmount);
832 
833         emit Order(msg.sender, inToken, outToken, inAmount, outAmount);
834         emit Swapped(inToken, outToken, referrer, inAmount, outAmount, fee, referrerFee);
835     }
836 
837     function handleFees(
838         IERC20 toToken,
839         uint256 outAmount,
840         uint256 guaranteedAmount,
841         address referrer
842     )
843         internal
844         returns (
845             uint256 realOutAmount,
846             uint256 fee,
847             uint256 referrerFee
848         )
849     {
850         if (outAmount <= guaranteedAmount || feeRate == 0) {
851             return (outAmount, 0, 0);
852         }
853 
854         fee = outAmount.sub(guaranteedAmount).mul(feeRate).div(10000);
855 
856         if (referrer != address(0) && referrer != msg.sender && referrer != tx.origin) {
857             referrerFee = fee.div(10);
858             if (toToken.universalTransfer(referrer, referrerFee)) {
859                 outAmount = outAmount.sub(referrerFee);
860                 fee = fee.sub(referrerFee);
861             } else {
862                 referrerFee = 0;
863             }
864         }
865 
866         if (toToken.universalTransfer(owner(), fee)) {
867             outAmount = outAmount.sub(fee);
868         }
869 
870         return (outAmount, fee, referrerFee);
871     }
872 }