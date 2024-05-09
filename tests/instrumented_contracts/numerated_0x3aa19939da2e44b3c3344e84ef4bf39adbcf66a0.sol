1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 /*
7 A bridge that connects AlphaHomora ibETH contracts to our STACK gauge contracts. 
8 This allows users to submit only one transaction to go from (supported ERC20 <-> AlphaHomora <-> STACK commit to VC fund)
9 They will be able to deposit & withdraw in both directions.
10 */
11 
12 pragma solidity ^0.6.11;
13 
14 /**
15  * @dev Interface of the ERC20 standard as defined in the EIP.
16  */
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, with an overflow flag.
104      *
105      * _Available since v3.4._
106      */
107     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
108         uint256 c = a + b;
109         if (c < a) return (false, 0);
110         return (true, c);
111     }
112 
113     /**
114      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         if (b > a) return (false, 0);
120         return (true, a - b);
121     }
122 
123     /**
124      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
125      *
126      * _Available since v3.4._
127      */
128     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
129         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
130         // benefit is lost if 'b' is also tested.
131         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
132         if (a == 0) return (true, 0);
133         uint256 c = a * b;
134         if (c / a != b) return (false, 0);
135         return (true, c);
136     }
137 
138     /**
139      * @dev Returns the division of two unsigned integers, with a division by zero flag.
140      *
141      * _Available since v3.4._
142      */
143     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
144         if (b == 0) return (false, 0);
145         return (true, a / b);
146     }
147 
148     /**
149      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
150      *
151      * _Available since v3.4._
152      */
153     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
154         if (b == 0) return (false, 0);
155         return (true, a % b);
156     }
157 
158     /**
159      * @dev Returns the addition of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `+` operator.
163      *
164      * Requirements:
165      *
166      * - Addition cannot overflow.
167      */
168     function add(uint256 a, uint256 b) internal pure returns (uint256) {
169         uint256 c = a + b;
170         require(c >= a, "SafeMath: addition overflow");
171         return c;
172     }
173 
174     /**
175      * @dev Returns the subtraction of two unsigned integers, reverting on
176      * overflow (when the result is negative).
177      *
178      * Counterpart to Solidity's `-` operator.
179      *
180      * Requirements:
181      *
182      * - Subtraction cannot overflow.
183      */
184     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b <= a, "SafeMath: subtraction overflow");
186         return a - b;
187     }
188 
189     /**
190      * @dev Returns the multiplication of two unsigned integers, reverting on
191      * overflow.
192      *
193      * Counterpart to Solidity's `*` operator.
194      *
195      * Requirements:
196      *
197      * - Multiplication cannot overflow.
198      */
199     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
200         if (a == 0) return 0;
201         uint256 c = a * b;
202         require(c / a == b, "SafeMath: multiplication overflow");
203         return c;
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers, reverting on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         require(b > 0, "SafeMath: division by zero");
220         return a / b;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * reverting when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         require(b > 0, "SafeMath: modulo by zero");
237         return a % b;
238     }
239 
240     /**
241      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
242      * overflow (when the result is negative).
243      *
244      * CAUTION: This function is deprecated because it requires allocating memory for the error
245      * message unnecessarily. For custom revert reasons use {trySub}.
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         return a - b;
256     }
257 
258     /**
259      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
260      * division by zero. The result is rounded towards zero.
261      *
262      * CAUTION: This function is deprecated because it requires allocating memory for the error
263      * message unnecessarily. For custom revert reasons use {tryDiv}.
264      *
265      * Counterpart to Solidity's `/` operator. Note: this function uses a
266      * `revert` opcode (which leaves remaining gas untouched) while Solidity
267      * uses an invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b > 0, errorMessage);
275         return a / b;
276     }
277 
278     /**
279      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
280      * reverting with custom message when dividing by zero.
281      *
282      * CAUTION: This function is deprecated because it requires allocating memory for the error
283      * message unnecessarily. For custom revert reasons use {tryMod}.
284      *
285      * Counterpart to Solidity's `%` operator. This function uses a `revert`
286      * opcode (which leaves remaining gas untouched) while Solidity uses an
287      * invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b > 0, errorMessage);
295         return a % b;
296     }
297 }
298 
299 /**
300  * @dev Collection of functions related to the address type
301  */
302 library Address {
303     /**
304      * @dev Returns true if `account` is a contract.
305      *
306      * [IMPORTANT]
307      * ====
308      * It is unsafe to assume that an address for which this function returns
309      * false is an externally-owned account (EOA) and not a contract.
310      *
311      * Among others, `isContract` will return false for the following
312      * types of addresses:
313      *
314      *  - an externally-owned account
315      *  - a contract in construction
316      *  - an address where a contract will be created
317      *  - an address where a contract lived, but was destroyed
318      * ====
319      */
320     function isContract(address account) internal view returns (bool) {
321         // This method relies on extcodesize, which returns 0 for contracts in
322         // construction, since the code is only stored at the end of the
323         // constructor execution.
324 
325         uint256 size;
326         // solhint-disable-next-line no-inline-assembly
327         assembly { size := extcodesize(account) }
328         return size > 0;
329     }
330 
331     /**
332      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
333      * `recipient`, forwarding all available gas and reverting on errors.
334      *
335      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
336      * of certain opcodes, possibly making contracts go over the 2300 gas limit
337      * imposed by `transfer`, making them unable to receive funds via
338      * `transfer`. {sendValue} removes this limitation.
339      *
340      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
341      *
342      * IMPORTANT: because control is transferred to `recipient`, care must be
343      * taken to not create reentrancy vulnerabilities. Consider using
344      * {ReentrancyGuard} or the
345      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
346      */
347     function sendValue(address payable recipient, uint256 amount) internal {
348         require(address(this).balance >= amount, "Address: insufficient balance");
349 
350         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
351         (bool success, ) = recipient.call{ value: amount }("");
352         require(success, "Address: unable to send value, recipient may have reverted");
353     }
354 
355     /**
356      * @dev Performs a Solidity function call using a low level `call`. A
357      * plain`call` is an unsafe replacement for a function call: use this
358      * function instead.
359      *
360      * If `target` reverts with a revert reason, it is bubbled up by this
361      * function (like regular Solidity function calls).
362      *
363      * Returns the raw returned data. To convert to the expected return value,
364      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
365      *
366      * Requirements:
367      *
368      * - `target` must be a contract.
369      * - calling `target` with `data` must not revert.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
374       return functionCall(target, data, "Address: low-level call failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
379      * `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
409         require(address(this).balance >= value, "Address: insufficient balance for call");
410         require(isContract(target), "Address: call to non-contract");
411 
412         // solhint-disable-next-line avoid-low-level-calls
413         (bool success, bytes memory returndata) = target.call{ value: value }(data);
414         return _verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a static call.
420      *
421      * _Available since v3.3._
422      */
423     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
424         return functionStaticCall(target, data, "Address: low-level static call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a static call.
430      *
431      * _Available since v3.3._
432      */
433     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
434         require(isContract(target), "Address: static call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.staticcall(data);
438         return _verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a delegate call.
444      *
445      * _Available since v3.4._
446      */
447     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
448         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return _verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 // solhint-disable-next-line no-inline-assembly
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 /**
486  * @title SafeERC20
487  * @dev Wrappers around ERC20 operations that throw on failure (when the token
488  * contract returns false). Tokens that return no value (and instead revert or
489  * throw on failure) are also supported, non-reverting calls are assumed to be
490  * successful.
491  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
492  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
493  */
494 library SafeERC20 {
495     using SafeMath for uint256;
496     using Address for address;
497 
498     function safeTransfer(IERC20 token, address to, uint256 value) internal {
499         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
500     }
501 
502     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
503         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
504     }
505 
506     /**
507      * @dev Deprecated. This function has issues similar to the ones found in
508      * {IERC20-approve}, and its usage is discouraged.
509      *
510      * Whenever possible, use {safeIncreaseAllowance} and
511      * {safeDecreaseAllowance} instead.
512      */
513     function safeApprove(IERC20 token, address spender, uint256 value) internal {
514         // safeApprove should only be called when setting an initial allowance,
515         // or when resetting it to zero. To increase and decrease it, use
516         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
517         // solhint-disable-next-line max-line-length
518         require((value == 0) || (token.allowance(address(this), spender) == 0),
519             "SafeERC20: approve from non-zero to non-zero allowance"
520         );
521         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
522     }
523 
524     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
525         uint256 newAllowance = token.allowance(address(this), spender).add(value);
526         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
527     }
528 
529     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
530         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
531         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
532     }
533 
534     /**
535      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
536      * on the return value: the return value is optional (but if data is returned, it must not be false).
537      * @param token The token targeted by the call.
538      * @param data The call data (encoded using abi.encode or one of its variants).
539      */
540     function _callOptionalReturn(IERC20 token, bytes memory data) private {
541         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
542         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
543         // the target address contains contract code and also asserts for success in the low-level call.
544 
545         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
546         if (returndata.length > 0) { // Return data is optional
547             // solhint-disable-next-line max-line-length
548             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
549         }
550     }
551 }
552 
553 /**
554  * @dev Contract module that helps prevent reentrant calls to a function.
555  *
556  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
557  * available, which can be applied to functions to make sure there are no nested
558  * (reentrant) calls to them.
559  *
560  * Note that because there is a single `nonReentrant` guard, functions marked as
561  * `nonReentrant` may not call one another. This can be worked around by making
562  * those functions `private`, and then adding `external` `nonReentrant` entry
563  * points to them.
564  *
565  * TIP: If you would like to learn more about reentrancy and alternative ways
566  * to protect against it, check out our blog post
567  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
568  */
569 abstract contract ReentrancyGuard {
570     // Booleans are more expensive than uint256 or any type that takes up a full
571     // word because each write operation emits an extra SLOAD to first read the
572     // slot's contents, replace the bits taken up by the boolean, and then write
573     // back. This is the compiler's defense against contract upgrades and
574     // pointer aliasing, and it cannot be disabled.
575 
576     // The values being non-zero value makes deployment a bit more expensive,
577     // but in exchange the refund on every call to nonReentrant will be lower in
578     // amount. Since refunds are capped to a percentage of the total
579     // transaction's gas, it is best to keep them low in cases like this one, to
580     // increase the likelihood of the full refund coming into effect.
581     uint256 private constant _NOT_ENTERED = 1;
582     uint256 private constant _ENTERED = 2;
583 
584     uint256 private _status;
585 
586     constructor () internal {
587         _status = _NOT_ENTERED;
588     }
589 
590     /**
591      * @dev Prevents a contract from calling itself, directly or indirectly.
592      * Calling a `nonReentrant` function from another `nonReentrant`
593      * function is not supported. It is possible to prevent this from happening
594      * by making the `nonReentrant` function external, and make it call a
595      * `private` function that does the actual work.
596      */
597     modifier nonReentrant() {
598         // On the first call to nonReentrant, _notEntered will be true
599         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
600 
601         // Any calls to nonReentrant after this point will fail
602         _status = _ENTERED;
603 
604         _;
605 
606         // By storing the original value once again, a refund is triggered (see
607         // https://eips.ethereum.org/EIPS/eip-2200)
608         _status = _NOT_ENTERED;
609     }
610 }
611 
612 interface IAlphaHomora_ibETH {	
613 	function deposit() payable external;
614 	function withdraw(uint256 amount) external;
615 }
616 
617 interface IGaugeD1 {	
618 	function fundOpen() external view returns (bool);
619 	function deposit(uint256 _amountCommitSoft, uint256 _amountCommitHard, address _creditTo) external;
620 	function withdraw(uint256 _amount, address _withdrawFor) external;
621 }
622 
623 contract VaultGaugeBridge is ReentrancyGuard {
624 	using SafeERC20 for IERC20;
625 	using Address for address;
626     using SafeMath for uint256;
627 
628     address payable public constant AlphaHomora_ibETH = 0xeEa3311250FE4c3268F8E684f7C87A82fF183Ec1; // AlphaHomora ibETHv2 deposit/withdraw contract & ERC20 contract
629 
630     address payable public governance;
631     address public gauge;
632 
633     constructor () public {
634     	governance = msg.sender;
635     }
636 
637     receive() external payable {
638         if (msg.sender != AlphaHomora_ibETH){
639             // if the fund is open, then hard commit to the fund, if it's not, then fallback to soft commit
640             if (IGaugeD1(gauge).fundOpen()){
641                 depositBridgeETH(true); 
642             }
643             else {
644                 depositBridgeETH(false);
645             } 
646         }
647     }
648 
649     function setGovernance(address payable _new) external {
650         require(msg.sender == governance, "BRIDGE: !governance");
651         governance = _new;
652     }
653 
654     // set the gauge to bridge ibETH to
655     function setGauge(address _gauge) external {
656     	require(msg.sender == governance, "BRIDGE: !governance");
657         require(gauge == address(0), "BRIDGE: gauge already set");
658 
659     	gauge = _gauge;
660     }
661 
662     // deposit ETH into ETH vault. WETH can be done with normal depositBridge call.
663     // public because of fallback function
664     function depositBridgeETH(bool _commit) nonReentrant public payable {
665     	require(gauge != address(0), "BRIDGE: !bridge"); // need to setup, fail
666 
667     	uint256 _beforeToken = IERC20(AlphaHomora_ibETH).balanceOf(address(this));
668     	IAlphaHomora_ibETH(AlphaHomora_ibETH).deposit{value: msg.value}();
669     	uint256 _afterToken = IERC20(AlphaHomora_ibETH).balanceOf(address(this));
670     	uint256 _receivedToken = _afterToken.sub(_beforeToken);
671 
672     	_depositGauge(_receivedToken, _commit, msg.sender);
673     }
674 
675     // withdraw as ETH from WETH vault. WETH withdraw can be from from depositBridge call.
676     function withdrawBridgeETH(uint256 _amount) nonReentrant external {
677         require(gauge != address(0), "BRIDGE: !bridge"); // need to setup, fail
678 
679         uint256 _receivedToken = _withdrawGauge(_amount, msg.sender);
680 
681         uint256 _before = address(this).balance;
682         IAlphaHomora_ibETH(AlphaHomora_ibETH).withdraw(_receivedToken);
683         uint256 _after = address(this).balance;
684         uint256 _received = _after.sub(_before);
685 
686         msg.sender.transfer(_received);
687     }
688 
689     function _withdrawGauge(uint256 _amount, address _user) internal returns (uint256){
690         uint256 _beforeToken = IERC20(AlphaHomora_ibETH).balanceOf(address(this));
691         IGaugeD1(gauge).withdraw(_amount, _user);
692         uint256 _afterToken = IERC20(AlphaHomora_ibETH).balanceOf(address(this));
693 
694         return _afterToken.sub(_beforeToken);
695     }
696 
697     function _depositGauge(uint256 _amount, bool _commit, address _user) internal {
698 		IERC20(AlphaHomora_ibETH).safeApprove(gauge, 0);
699     	IERC20(AlphaHomora_ibETH).safeApprove(gauge, _amount);
700 
701     	if (_commit){
702     		IGaugeD1(gauge).deposit(0, _amount, _user);
703     	}
704     	else {
705     		IGaugeD1(gauge).deposit(_amount, 0, _user);
706     	}
707     }
708 
709     // decentralized rescue function for any stuck tokens, will return to governance
710     function rescue(address _token, uint256 _amount) nonReentrant external {
711         require(msg.sender == governance, "BRIDGE: !governance");
712 
713         if (_token != address(0)){
714             IERC20(_token).safeTransfer(governance, _amount);
715         }
716         else { // if _tokenContract is 0x0, then escape ETH
717             governance.transfer(_amount);
718         }
719     }
720 }