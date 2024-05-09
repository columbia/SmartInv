1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/math/SafeMath.sol
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
219 
220 
221 
222 pragma solidity >=0.6.0 <0.8.0;
223 
224 /**
225  * @dev Interface of the ERC20 standard as defined in the EIP.
226  */
227 interface IERC20 {
228     /**
229      * @dev Returns the amount of tokens in existence.
230      */
231     function totalSupply() external view returns (uint256);
232 
233     /**
234      * @dev Returns the amount of tokens owned by `account`.
235      */
236     function balanceOf(address account) external view returns (uint256);
237 
238     /**
239      * @dev Moves `amount` tokens from the caller's account to `recipient`.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * Emits a {Transfer} event.
244      */
245     function transfer(address recipient, uint256 amount) external returns (bool);
246 
247     /**
248      * @dev Returns the remaining number of tokens that `spender` will be
249      * allowed to spend on behalf of `owner` through {transferFrom}. This is
250      * zero by default.
251      *
252      * This value changes when {approve} or {transferFrom} are called.
253      */
254     function allowance(address owner, address spender) external view returns (uint256);
255 
256     /**
257      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * IMPORTANT: Beware that changing an allowance with this method brings the risk
262      * that someone may use both the old and the new allowance by unfortunate
263      * transaction ordering. One possible solution to mitigate this race
264      * condition is to first reduce the spender's allowance to 0 and set the
265      * desired value afterwards:
266      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
267      *
268      * Emits an {Approval} event.
269      */
270     function approve(address spender, uint256 amount) external returns (bool);
271 
272     /**
273      * @dev Moves `amount` tokens from `sender` to `recipient` using the
274      * allowance mechanism. `amount` is then deducted from the caller's
275      * allowance.
276      *
277      * Returns a boolean value indicating whether the operation succeeded.
278      *
279      * Emits a {Transfer} event.
280      */
281     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
282 
283     /**
284      * @dev Emitted when `value` tokens are moved from one account (`from`) to
285      * another (`to`).
286      *
287      * Note that `value` may be zero.
288      */
289     event Transfer(address indexed from, address indexed to, uint256 value);
290 
291     /**
292      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
293      * a call to {approve}. `value` is the new allowance.
294      */
295     event Approval(address indexed owner, address indexed spender, uint256 value);
296 }
297 
298 // File: @openzeppelin/contracts/utils/Address.sol
299 
300 
301 
302 pragma solidity >=0.6.2 <0.8.0;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         // solhint-disable-next-line no-inline-assembly
332         assembly { size := extcodesize(account) }
333         return size > 0;
334     }
335 
336     /**
337      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
338      * `recipient`, forwarding all available gas and reverting on errors.
339      *
340      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
341      * of certain opcodes, possibly making contracts go over the 2300 gas limit
342      * imposed by `transfer`, making them unable to receive funds via
343      * `transfer`. {sendValue} removes this limitation.
344      *
345      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
346      *
347      * IMPORTANT: because control is transferred to `recipient`, care must be
348      * taken to not create reentrancy vulnerabilities. Consider using
349      * {ReentrancyGuard} or the
350      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
356         (bool success, ) = recipient.call{ value: amount }("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain`call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
379       return functionCall(target, data, "Address: low-level call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
384      * `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, 0, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but also transferring `value` wei to `target`.
395      *
396      * Requirements:
397      *
398      * - the calling contract must have an ETH balance of at least `value`.
399      * - the called Solidity function must be `payable`.
400      *
401      * _Available since v3.1._
402      */
403     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         require(isContract(target), "Address: call to non-contract");
416 
417         // solhint-disable-next-line avoid-low-level-calls
418         (bool success, bytes memory returndata) = target.call{ value: value }(data);
419         return _verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
424      * but performing a static call.
425      *
426      * _Available since v3.3._
427      */
428     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
429         return functionStaticCall(target, data, "Address: low-level static call failed");
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
439         require(isContract(target), "Address: static call to non-contract");
440 
441         // solhint-disable-next-line avoid-low-level-calls
442         (bool success, bytes memory returndata) = target.staticcall(data);
443         return _verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a delegate call.
449      *
450      * _Available since v3.4._
451      */
452     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
453         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a delegate call.
459      *
460      * _Available since v3.4._
461      */
462     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
463         require(isContract(target), "Address: delegate call to non-contract");
464 
465         // solhint-disable-next-line avoid-low-level-calls
466         (bool success, bytes memory returndata) = target.delegatecall(data);
467         return _verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
471         if (success) {
472             return returndata;
473         } else {
474             // Look for revert reason and bubble it up if present
475             if (returndata.length > 0) {
476                 // The easiest way to bubble the revert reason is using memory via assembly
477 
478                 // solhint-disable-next-line no-inline-assembly
479                 assembly {
480                     let returndata_size := mload(returndata)
481                     revert(add(32, returndata), returndata_size)
482                 }
483             } else {
484                 revert(errorMessage);
485             }
486         }
487     }
488 }
489 
490 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
491 
492 
493 
494 pragma solidity >=0.6.0 <0.8.0;
495 
496 
497 
498 
499 /**
500  * @title SafeERC20
501  * @dev Wrappers around ERC20 operations that throw on failure (when the token
502  * contract returns false). Tokens that return no value (and instead revert or
503  * throw on failure) are also supported, non-reverting calls are assumed to be
504  * successful.
505  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
506  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
507  */
508 library SafeERC20 {
509     using SafeMath for uint256;
510     using Address for address;
511 
512     function safeTransfer(IERC20 token, address to, uint256 value) internal {
513         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
514     }
515 
516     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
518     }
519 
520     /**
521      * @dev Deprecated. This function has issues similar to the ones found in
522      * {IERC20-approve}, and its usage is discouraged.
523      *
524      * Whenever possible, use {safeIncreaseAllowance} and
525      * {safeDecreaseAllowance} instead.
526      */
527     function safeApprove(IERC20 token, address spender, uint256 value) internal {
528         // safeApprove should only be called when setting an initial allowance,
529         // or when resetting it to zero. To increase and decrease it, use
530         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
531         // solhint-disable-next-line max-line-length
532         require((value == 0) || (token.allowance(address(this), spender) == 0),
533             "SafeERC20: approve from non-zero to non-zero allowance"
534         );
535         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
536     }
537 
538     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
539         uint256 newAllowance = token.allowance(address(this), spender).add(value);
540         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
541     }
542 
543     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
544         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
545         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
546     }
547 
548     /**
549      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
550      * on the return value: the return value is optional (but if data is returned, it must not be false).
551      * @param token The token targeted by the call.
552      * @param data The call data (encoded using abi.encode or one of its variants).
553      */
554     function _callOptionalReturn(IERC20 token, bytes memory data) private {
555         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
556         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
557         // the target address contains contract code and also asserts for success in the low-level call.
558 
559         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
560         if (returndata.length > 0) { // Return data is optional
561             // solhint-disable-next-line max-line-length
562             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
563         }
564     }
565 }
566 
567 // File: @openzeppelin/contracts/utils/Context.sol
568 
569 
570 
571 pragma solidity >=0.6.0 <0.8.0;
572 
573 /*
574  * @dev Provides information about the current execution context, including the
575  * sender of the transaction and its data. While these are generally available
576  * via msg.sender and msg.data, they should not be accessed in such a direct
577  * manner, since when dealing with GSN meta-transactions the account sending and
578  * paying for execution may not be the actual sender (as far as an application
579  * is concerned).
580  *
581  * This contract is only required for intermediate, library-like contracts.
582  */
583 abstract contract Context {
584     function _msgSender() internal view virtual returns (address payable) {
585         return msg.sender;
586     }
587 
588     function _msgData() internal view virtual returns (bytes memory) {
589         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
590         return msg.data;
591     }
592 }
593 
594 // File: @openzeppelin/contracts/GSN/Context.sol
595 
596 
597 
598 pragma solidity >=0.6.0 <0.8.0;
599 
600 // File: contracts/Pausable.sol
601 
602 
603 
604 pragma solidity 0.6.12;
605 
606 
607 /**
608  * @dev Contract module which allows children to implement an emergency stop
609  * mechanism that can be triggered by an authorized account.
610  *
611  */
612 contract Pausable is Context {
613     event Paused(address account);
614     event Shutdown(address account);
615     event Unpaused(address account);
616     event Open(address account);
617 
618     bool public paused;
619     bool public stopEverything;
620 
621     modifier whenNotPaused() {
622         require(!paused, "Pausable: paused");
623         _;
624     }
625     modifier whenPaused() {
626         require(paused, "Pausable: not paused");
627         _;
628     }
629 
630     modifier whenNotShutdown() {
631         require(!stopEverything, "Pausable: shutdown");
632         _;
633     }
634 
635     modifier whenShutdown() {
636         require(stopEverything, "Pausable: not shutdown");
637         _;
638     }
639 
640     /// @dev Pause contract operations, if contract is not paused.
641     function _pause() internal virtual whenNotPaused {
642         paused = true;
643         emit Paused(_msgSender());
644     }
645 
646     /// @dev Unpause contract operations, allow only if contract is paused and not shutdown.
647     function _unpause() internal virtual whenPaused whenNotShutdown {
648         paused = false;
649         emit Unpaused(_msgSender());
650     }
651 
652     /// @dev Shutdown contract operations, if not already shutdown.
653     function _shutdown() internal virtual whenNotShutdown {
654         stopEverything = true;
655         paused = true;
656         emit Shutdown(_msgSender());
657     }
658 
659     /// @dev Open contract operations, if contract is in shutdown state
660     function _open() internal virtual whenShutdown {
661         stopEverything = false;
662         emit Open(_msgSender());
663     }
664 }
665 
666 // File: contracts/interfaces/vesper/IController.sol
667 
668 
669 
670 pragma solidity 0.6.12;
671 
672 interface IController {
673     function aaveReferralCode() external view returns (uint16);
674 
675     function feeCollector(address) external view returns (address);
676 
677     function founderFee() external view returns (uint256);
678 
679     function founderVault() external view returns (address);
680 
681     function interestFee(address) external view returns (uint256);
682 
683     function isPool(address) external view returns (bool);
684 
685     function pools() external view returns (address);
686 
687     function strategy(address) external view returns (address);
688 
689     function rebalanceFriction(address) external view returns (uint256);
690 
691     function poolRewards(address) external view returns (address);
692 
693     function treasuryPool() external view returns (address);
694 
695     function uniswapRouter() external view returns (address);
696 
697     function withdrawFee(address) external view returns (uint256);
698 }
699 
700 // File: contracts/interfaces/vesper/IVesperPool.sol
701 
702 
703 
704 pragma solidity 0.6.12;
705 
706 
707 interface IVesperPool is IERC20 {
708     function approveToken() external;
709 
710     function deposit() external payable;
711 
712     function deposit(uint256) external;
713 
714     function multiTransfer(uint256[] memory) external returns (bool);
715 
716     function permit(
717         address,
718         address,
719         uint256,
720         uint256,
721         uint8,
722         bytes32,
723         bytes32
724     ) external;
725 
726     function rebalance() external;
727 
728     function resetApproval() external;
729 
730     function sweepErc20(address) external;
731 
732     function withdraw(uint256) external;
733 
734     function withdrawETH(uint256) external;
735 
736     function withdrawByStrategy(uint256) external;
737 
738     function feeCollector() external view returns (address);
739 
740     function getPricePerShare() external view returns (uint256);
741 
742     function token() external view returns (address);
743 
744     function tokensHere() external view returns (uint256);
745 
746     function totalValue() external view returns (uint256);
747 
748     function withdrawFee() external view returns (uint256);
749 }
750 
751 // File: contracts/interfaces/uniswap/IUniswapV2Router01.sol
752 
753 
754 
755 pragma solidity 0.6.12;
756 
757 interface IUniswapV2Router01 {
758     function factory() external pure returns (address);
759 
760     function swapExactTokensForTokens(
761         uint256 amountIn,
762         uint256 amountOutMin,
763         address[] calldata path,
764         address to,
765         uint256 deadline
766     ) external returns (uint256[] memory amounts);
767 
768     function swapTokensForExactTokens(
769         uint256 amountOut,
770         uint256 amountInMax,
771         address[] calldata path,
772         address to,
773         uint256 deadline
774     ) external returns (uint256[] memory amounts);
775 
776     function swapExactETHForTokens(
777         uint256 amountOutMin,
778         address[] calldata path,
779         address to,
780         uint256 deadline
781     ) external payable returns (uint256[] memory amounts);
782 
783     function swapTokensForExactETH(
784         uint256 amountOut,
785         uint256 amountInMax,
786         address[] calldata path,
787         address to,
788         uint256 deadline
789     ) external returns (uint256[] memory amounts);
790 
791     function swapExactTokensForETH(
792         uint256 amountIn,
793         uint256 amountOutMin,
794         address[] calldata path,
795         address to,
796         uint256 deadline
797     ) external returns (uint256[] memory amounts);
798 
799     function swapETHForExactTokens(
800         uint256 amountOut,
801         address[] calldata path,
802         address to,
803         uint256 deadline
804     ) external payable returns (uint256[] memory amounts);
805 
806     function quote(
807         uint256 amountA,
808         uint256 reserveA,
809         uint256 reserveB
810     ) external pure returns (uint256 amountB);
811 
812     function getAmountOut(
813         uint256 amountIn,
814         uint256 reserveIn,
815         uint256 reserveOut
816     ) external pure returns (uint256 amountOut);
817 
818     function getAmountIn(
819         uint256 amountOut,
820         uint256 reserveIn,
821         uint256 reserveOut
822     ) external pure returns (uint256 amountIn);
823 
824     function getAmountsOut(uint256 amountIn, address[] calldata path)
825         external
826         view
827         returns (uint256[] memory amounts);
828 
829     function getAmountsIn(uint256 amountOut, address[] calldata path)
830         external
831         view
832         returns (uint256[] memory amounts);
833 }
834 
835 // File: contracts/interfaces/uniswap/IUniswapV2Router02.sol
836 
837 
838 
839 pragma solidity 0.6.12;
840 
841 
842 interface IUniswapV2Router02 is IUniswapV2Router01 {
843     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
844         uint256 amountIn,
845         uint256 amountOutMin,
846         address[] calldata path,
847         address to,
848         uint256 deadline
849     ) external;
850 
851     function swapExactETHForTokensSupportingFeeOnTransferTokens(
852         uint256 amountOutMin,
853         address[] calldata path,
854         address to,
855         uint256 deadline
856     ) external payable;
857 
858     function swapExactTokensForETHSupportingFeeOnTransferTokens(
859         uint256 amountIn,
860         uint256 amountOutMin,
861         address[] calldata path,
862         address to,
863         uint256 deadline
864     ) external;
865 }
866 
867 // File: contracts/interfaces/bloq/ISwapManager.sol
868 
869 
870 
871 pragma solidity 0.6.12;
872 
873 
874 interface ISwapManager {
875     event OracleCreated(address indexed _sender, address indexed _newOracle);
876 
877     function N_DEX() external view returns (uint256);
878 
879     function ROUTERS(uint256 i) external view returns (IUniswapV2Router02);
880 
881     function bestOutputFixedInput(
882         address _from,
883         address _to,
884         uint256 _amountIn
885     )
886         external
887         view
888         returns (
889             address[] memory path,
890             uint256 amountOut,
891             uint256 rIdx
892         );
893 
894     function bestPathFixedInput(
895         address _from,
896         address _to,
897         uint256 _amountIn,
898         uint256 _i
899     ) external view returns (address[] memory path, uint256 amountOut);
900 
901     function bestInputFixedOutput(
902         address _from,
903         address _to,
904         uint256 _amountOut
905     )
906         external
907         view
908         returns (
909             address[] memory path,
910             uint256 amountIn,
911             uint256 rIdx
912         );
913 
914     function bestPathFixedOutput(
915         address _from,
916         address _to,
917         uint256 _amountOut,
918         uint256 _i
919     ) external view returns (address[] memory path, uint256 amountIn);
920 
921     function safeGetAmountsOut(
922         uint256 _amountIn,
923         address[] memory _path,
924         uint256 _i
925     ) external view returns (uint256[] memory result);
926 
927     function unsafeGetAmountsOut(
928         uint256 _amountIn,
929         address[] memory _path,
930         uint256 _i
931     ) external view returns (uint256[] memory result);
932 
933     function safeGetAmountsIn(
934         uint256 _amountOut,
935         address[] memory _path,
936         uint256 _i
937     ) external view returns (uint256[] memory result);
938 
939     function unsafeGetAmountsIn(
940         uint256 _amountOut,
941         address[] memory _path,
942         uint256 _i
943     ) external view returns (uint256[] memory result);
944 
945     function comparePathsFixedInput(
946         address[] memory pathA,
947         address[] memory pathB,
948         uint256 _amountIn,
949         uint256 _i
950     ) external view returns (address[] memory path, uint256 amountOut);
951 
952     function comparePathsFixedOutput(
953         address[] memory pathA,
954         address[] memory pathB,
955         uint256 _amountOut,
956         uint256 _i
957     ) external view returns (address[] memory path, uint256 amountIn);
958 
959     function ours(address a) external view returns (bool);
960 
961     function oracleCount() external view returns (uint256);
962 
963     function oracleAt(uint256 idx) external view returns (address);
964 
965     function getOracle(
966         address _tokenA,
967         address _tokenB,
968         uint256 _period,
969         uint256 _i
970     ) external view returns (address);
971 
972     function createOracle(
973         address _tokenA,
974         address _tokenB,
975         uint256 _period,
976         uint256 _i
977     ) external returns (address oracleAddr);
978 
979     function consultForFree(
980         address _from,
981         address _to,
982         uint256 _amountIn,
983         uint256 _period,
984         uint256 _i
985     ) external view returns (uint256 amountOut, uint256 lastUpdatedAt);
986 
987     /// get the data we want and pay the gas to update
988     function consult(
989         address _from,
990         address _to,
991         uint256 _amountIn,
992         uint256 _period,
993         uint256 _i
994     )
995         external
996         returns (
997             uint256 amountOut,
998             uint256 lastUpdatedAt,
999             bool updated
1000         );
1001 }
1002 
1003 // File: sol-address-list/contracts/interfaces/IAddressList.sol
1004 
1005 
1006 
1007 pragma solidity ^0.6.6;
1008 
1009 interface IAddressList {
1010     event AddressUpdated(address indexed a, address indexed sender);
1011     event AddressRemoved(address indexed a, address indexed sender);
1012 
1013     function add(address a) external returns (bool);
1014 
1015     function addValue(address a, uint256 v) external returns (bool);
1016 
1017     function addMulti(address[] calldata addrs) external returns (uint256);
1018 
1019     function addValueMulti(address[] calldata addrs, uint256[] calldata values) external returns (uint256);
1020 
1021     function remove(address a) external returns (bool);
1022 
1023     function removeMulti(address[] calldata addrs) external returns (uint256);
1024 
1025     function get(address a) external view returns (uint256);
1026 
1027     function contains(address a) external view returns (bool);
1028 
1029     function at(uint256 index) external view returns (address, uint256);
1030 
1031     function length() external view returns (uint256);
1032 }
1033 
1034 // File: sol-address-list/contracts/interfaces/IAddressListExt.sol
1035 
1036 
1037 
1038 pragma solidity ^0.6.6;
1039 
1040 
1041 interface IAddressListExt is IAddressList {
1042     function hasRole(bytes32 role, address account) external view returns (bool);
1043 
1044     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1045 
1046     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1047 
1048     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1049 
1050     function grantRole(bytes32 role, address account) external;
1051 
1052     function revokeRole(bytes32 role, address account) external;
1053 
1054     function renounceRole(bytes32 role, address account) external;
1055 }
1056 
1057 // File: sol-address-list/contracts/interfaces/IAddressListFactory.sol
1058 
1059 
1060 
1061 pragma solidity ^0.6.6;
1062 
1063 interface IAddressListFactory {
1064     event ListCreated(address indexed _sender, address indexed _newList);
1065 
1066     function ours(address a) external view returns (bool);
1067 
1068     function listCount() external view returns (uint256);
1069 
1070     function listAt(uint256 idx) external view returns (address);
1071 
1072     function createList() external returns (address listaddr);
1073 }
1074 
1075 // File: contracts/strategies/VSPStrategy.sol
1076 
1077 
1078 
1079 pragma solidity 0.6.12;
1080 
1081 
1082 
1083 
1084 
1085 
1086 
1087 
1088 
1089 
1090 contract VSPStrategy is Pausable {
1091     using SafeMath for uint256;
1092     using SafeERC20 for IERC20;
1093 
1094     uint256 public lastRebalanceBlock;
1095     IController public immutable controller;
1096     IVesperPool public immutable vvsp;
1097     IAddressListExt public immutable keepers;
1098     ISwapManager public swapManager;
1099     address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1100     uint256 public nextPoolIdx;
1101     address[] public pools;
1102     uint256[] public liquidationLimit;
1103     string public constant NAME = "Strategy-VSP";
1104     string public constant VERSION = "2.0.3";
1105 
1106     event UpdatedSwapManager(address indexed previousSwapManager, address indexed newSwapManager);
1107 
1108     constructor(
1109         address _controller,
1110         address _vvsp,
1111         address _swapManager
1112     ) public {
1113         vvsp = IVesperPool(_vvsp);
1114         controller = IController(_controller);
1115         IAddressListFactory factory =
1116             IAddressListFactory(0xD57b41649f822C51a73C44Ba0B3da4A880aF0029);
1117         IAddressListExt _keepers = IAddressListExt(factory.createList());
1118         _keepers.grantRole(keccak256("LIST_ADMIN"), _controller);
1119         keepers = _keepers;
1120         swapManager = ISwapManager(_swapManager);
1121     }
1122 
1123     modifier onlyKeeper() {
1124         require(keepers.contains(_msgSender()), "caller-is-not-keeper");
1125         _;
1126     }
1127 
1128     modifier onlyController() {
1129         require(_msgSender() == address(controller), "Caller is not the controller");
1130         _;
1131     }
1132 
1133     function pause() external onlyController {
1134         _pause();
1135     }
1136 
1137     function unpause() external onlyController {
1138         _unpause();
1139     }
1140 
1141     /**
1142      * @notice Update swap manager address
1143      * @param _swapManager swap manager address
1144      */
1145     function updateSwapManager(address _swapManager) external onlyController {
1146         require(_swapManager != address(0), "sm-address-is-zero");
1147         require(_swapManager != address(swapManager), "sm-is-same");
1148         emit UpdatedSwapManager(address(swapManager), _swapManager);
1149         swapManager = ISwapManager(_swapManager);
1150     }
1151 
1152     function updateLiquidationQueue(address[] calldata _pools, uint256[] calldata _limit)
1153         external
1154         onlyController
1155     {
1156         for (uint256 i = 0; i < _pools.length; i++) {
1157             require(controller.isPool(_pools[i]), "Not a valid pool");
1158             require(_limit[i] != 0, "Limit cannot be zero");
1159         }
1160         pools = _pools;
1161         liquidationLimit = _limit;
1162         nextPoolIdx = 0;
1163     }
1164 
1165     function isUpgradable() external view returns (bool) {
1166         return IERC20(vvsp.token()).balanceOf(address(this)) == 0;
1167     }
1168 
1169     function pool() external view returns (address) {
1170         return address(vvsp);
1171     }
1172 
1173     /**
1174         withdraw Vtoken from vvsp => Deposit vpool => withdraw collateral => swap in uni for VSP => transfer vsp to vvsp pool
1175         VETH => ETH => VSP
1176      */
1177     function rebalance() external whenNotPaused onlyKeeper {
1178         require(
1179             block.number - lastRebalanceBlock >= controller.rebalanceFriction(address(vvsp)),
1180             "Can not rebalance"
1181         );
1182         lastRebalanceBlock = block.number;
1183 
1184         if (nextPoolIdx == pools.length) {
1185             nextPoolIdx = 0;
1186         }
1187 
1188         IVesperPool _poolToken = IVesperPool(pools[nextPoolIdx]);
1189         uint256 _balance = _poolToken.balanceOf(address(vvsp));
1190         if (_balance != 0 && address(_poolToken) != address(vvsp)) {
1191             if (_balance > liquidationLimit[nextPoolIdx]) {
1192                 _balance = liquidationLimit[nextPoolIdx];
1193             }
1194             _rebalanceEarned(_poolToken, _balance);
1195         }
1196         nextPoolIdx++;
1197     }
1198 
1199     /// @dev sweep given token to vsp pool
1200     function sweepErc20(address _fromToken) external {
1201         uint256 amount = IERC20(_fromToken).balanceOf(address(this));
1202         IERC20(_fromToken).safeTransfer(address(vvsp), amount);
1203     }
1204 
1205     function _rebalanceEarned(IVesperPool _poolToken, uint256 _amt) internal {
1206         IERC20(address(_poolToken)).safeTransferFrom(address(vvsp), address(this), _amt);
1207         _poolToken.withdrawByStrategy(_amt);
1208         IERC20 from = IERC20(_poolToken.token());
1209         IERC20 vsp = IERC20(vvsp.token());
1210         (address[] memory path, uint256 amountOut, uint256 rIdx) =
1211             swapManager.bestOutputFixedInput(
1212                 address(from),
1213                 address(vsp),
1214                 from.balanceOf(address(this))
1215             );
1216         if (amountOut != 0) {
1217             from.safeApprove(address(swapManager.ROUTERS(rIdx)), 0);
1218             from.safeApprove(address(swapManager.ROUTERS(rIdx)), from.balanceOf(address(this)));
1219             swapManager.ROUTERS(rIdx).swapExactTokensForTokens(
1220                 from.balanceOf(address(this)),
1221                 1,
1222                 path,
1223                 address(this),
1224                 now + 30
1225             );
1226             vsp.safeTransfer(address(vvsp), vsp.balanceOf(address(this)));
1227         }
1228     }
1229 }