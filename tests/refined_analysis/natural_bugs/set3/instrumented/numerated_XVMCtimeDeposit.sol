1 /**
2  *Submitted for verification at polygonscan.com on 2022-06-05
3 */
4 
5 // File: xvmc-contracts/libs/poolLibraries.sol
6 
7 
8 
9 pragma solidity 0.6.12;
10 //openZeppelin contracts(also used by Pancakeswap).
11 //modified IERC20 and SafeERC20(using transferXVMC instead of standard transferFrom)
12 
13 // File: @openzeppelin/contracts/utils/Context.sol
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 
37 /**
38  * @dev Contract module that helps prevent reentrant calls to a function.
39  *
40  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
41  * available, which can be applied to functions to make sure there are no nested
42  * (reentrant) calls to them.
43  *
44  * Note that because there is a single `nonReentrant` guard, functions marked as
45  * `nonReentrant` may not call one another. This can be worked around by making
46  * those functions `private`, and then adding `external` `nonReentrant` entry
47  * points to them.
48  *
49  * TIP: If you would like to learn more about reentrancy and alternative ways
50  * to protect against it, check out our blog post
51  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
52  */
53 abstract contract ReentrancyGuard {
54     // Booleans are more expensive than uint256 or any type that takes up a full
55     // word because each write operation emits an extra SLOAD to first read the
56     // slot's contents, replace the bits taken up by the boolean, and then write
57     // back. This is the compiler's defense against contract upgrades and
58     // pointer aliasing, and it cannot be disabled.
59 
60     // The values being non-zero value makes deployment a bit more expensive,
61     // but in exchange the refund on every call to nonReentrant will be lower in
62     // amount. Since refunds are capped to a percentage of the total
63     // transaction's gas, it is best to keep them low in cases like this one, to
64     // increase the likelihood of the full refund coming into effect.
65     uint256 private constant _NOT_ENTERED = 1;
66     uint256 private constant _ENTERED = 2;
67 
68     uint256 private _status;
69 
70     constructor () internal {
71         _status = _NOT_ENTERED;
72     }
73 
74     /**
75      * @dev Prevents a contract from calling itself, directly or indirectly.
76      * Calling a `nonReentrant` function from another `nonReentrant`
77      * function is not supported. It is possible to prevent this from happening
78      * by making the `nonReentrant` function external, and make it call a
79      * `private` function that does the actual work.
80      */
81     modifier nonReentrant() {
82         // On the first call to nonReentrant, _notEntered will be true
83         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
84 
85         // Any calls to nonReentrant after this point will fail
86         _status = _ENTERED;
87 
88         _;
89 
90         // By storing the original value once again, a refund is triggered (see
91         // https://eips.ethereum.org/EIPS/eip-2200)
92         _status = _NOT_ENTERED;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/math/SafeMath.sol
97 
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations with added overflow
101  * checks.
102  *
103  * Arithmetic operations in Solidity wrap on overflow. This can easily result
104  * in bugs, because programmers usually assume that an overflow raises an
105  * error, which is the standard behavior in high level programming languages.
106  * `SafeMath` restores this intuition by reverting the transaction when an
107  * operation overflows.
108  *
109  * Using this library instead of the unchecked operations eliminates an entire
110  * class of bugs, so it's recommended to use it always.
111  */
112 library SafeMath {
113     /**
114      * @dev Returns the addition of two unsigned integers, with an overflow flag.
115      *
116      * _Available since v3.4._
117      */
118     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
119         uint256 c = a + b;
120         if (c < a) return (false, 0);
121         return (true, c);
122     }
123 
124     /**
125      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
126      *
127      * _Available since v3.4._
128      */
129     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         if (b > a) return (false, 0);
131         return (true, a - b);
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
143         if (a == 0) return (true, 0);
144         uint256 c = a * b;
145         if (c / a != b) return (false, 0);
146         return (true, c);
147     }
148 
149     /**
150      * @dev Returns the division of two unsigned integers, with a division by zero flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         if (b == 0) return (false, 0);
156         return (true, a / b);
157     }
158 
159     /**
160      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
161      *
162      * _Available since v3.4._
163      */
164     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
165         if (b == 0) return (false, 0);
166         return (true, a % b);
167     }
168 
169     /**
170      * @dev Returns the addition of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `+` operator.
174      *
175      * Requirements:
176      *
177      * - Addition cannot overflow.
178      */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         uint256 c = a + b;
181         require(c >= a, "SafeMath: addition overflow");
182         return c;
183     }
184 
185     /**
186      * @dev Returns the subtraction of two unsigned integers, reverting on
187      * overflow (when the result is negative).
188      *
189      * Counterpart to Solidity's `-` operator.
190      *
191      * Requirements:
192      *
193      * - Subtraction cannot overflow.
194      */
195     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
196         require(b <= a, "SafeMath: subtraction overflow");
197         return a - b;
198     }
199 
200     /**
201      * @dev Returns the multiplication of two unsigned integers, reverting on
202      * overflow.
203      *
204      * Counterpart to Solidity's `*` operator.
205      *
206      * Requirements:
207      *
208      * - Multiplication cannot overflow.
209      */
210     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
211         if (a == 0) return 0;
212         uint256 c = a * b;
213         require(c / a == b, "SafeMath: multiplication overflow");
214         return c;
215     }
216 
217     /**
218      * @dev Returns the integer division of two unsigned integers, reverting on
219      * division by zero. The result is rounded towards zero.
220      *
221      * Counterpart to Solidity's `/` operator. Note: this function uses a
222      * `revert` opcode (which leaves remaining gas untouched) while Solidity
223      * uses an invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      *
227      * - The divisor cannot be zero.
228      */
229     function div(uint256 a, uint256 b) internal pure returns (uint256) {
230         require(b > 0, "SafeMath: division by zero");
231         return a / b;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * reverting when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         require(b > 0, "SafeMath: modulo by zero");
248         return a % b;
249     }
250 
251     /**
252      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
253      * overflow (when the result is negative).
254      *
255      * CAUTION: This function is deprecated because it requires allocating memory for the error
256      * message unnecessarily. For custom revert reasons use {trySub}.
257      *
258      * Counterpart to Solidity's `-` operator.
259      *
260      * Requirements:
261      *
262      * - Subtraction cannot overflow.
263      */
264     function sub(
265         uint256 a,
266         uint256 b,
267         string memory errorMessage
268     ) internal pure returns (uint256) {
269         require(b <= a, errorMessage);
270         return a - b;
271     }
272 
273     /**
274      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
275      * division by zero. The result is rounded towards zero.
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {tryDiv}.
279      *
280      * Counterpart to Solidity's `/` operator. Note: this function uses a
281      * `revert` opcode (which leaves remaining gas untouched) while Solidity
282      * uses an invalid opcode to revert (consuming all remaining gas).
283      *
284      * Requirements:
285      *
286      * - The divisor cannot be zero.
287      */
288     function div(
289         uint256 a,
290         uint256 b,
291         string memory errorMessage
292     ) internal pure returns (uint256) {
293         require(b > 0, errorMessage);
294         return a / b;
295     }
296 
297     /**
298      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
299      * reverting with custom message when dividing by zero.
300      *
301      * CAUTION: This function is deprecated because it requires allocating memory for the error
302      * message unnecessarily. For custom revert reasons use {tryMod}.
303      *
304      * Counterpart to Solidity's `%` operator. This function uses a `revert`
305      * opcode (which leaves remaining gas untouched) while Solidity uses an
306      * invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function mod(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         require(b > 0, errorMessage);
318         return a % b;
319     }
320 }
321 
322 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
323 
324 
325 /**
326  * @dev Interface of the ERC20 standard as defined in the EIP.
327  */
328 interface IERC20 {
329     /**
330      * @dev Returns the amount of tokens in existence.
331      */
332     function totalSupply() external view returns (uint256);
333 
334     /**
335      * @dev Returns the amount of tokens owned by `account`.
336      */
337     function balanceOf(address account) external view returns (uint256);
338 
339     /**
340      * @dev Moves `amount` tokens from the caller's account to `recipient`.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * Emits a {Transfer} event.
345      */
346     function transfer(address recipient, uint256 amount) external returns (bool);
347 
348     /**
349      * @dev Returns the remaining number of tokens that `spender` will be
350      * allowed to spend on behalf of `owner` through {transferFrom}. This is
351      * zero by default.
352      *
353      * This value changes when {approve} or {transferFrom} are called.
354      */
355     function allowance(address owner, address spender) external view returns (uint256);
356 
357     /**
358      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * IMPORTANT: Beware that changing an allowance with this method brings the risk
363      * that someone may use both the old and the new allowance by unfortunate
364      * transaction ordering. One possible solution to mitigate this race
365      * condition is to first reduce the spender's allowance to 0 and set the
366      * desired value afterwards:
367      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368      *
369      * Emits an {Approval} event.
370      */
371     function approve(address spender, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Moves `amount` tokens from `sender` to `recipient` using the
375      * allowance mechanism. `amount` is then deducted from the caller's
376      * allowance.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * Emits a {Transfer} event.
381      */
382     function transferFrom(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) external returns (bool);
387     
388 	//transfers XVMC without allowance
389     function transferXVMC(address _sender, address _recipient, uint256 _amount) external returns (bool);
390 	
391 	//returns owner address
392 	function owner() external view returns (address);
393 
394     /**
395      * @dev Emitted when `value` tokens are moved from one account (`from`) to
396      * another (`to`).
397      *
398      * Note that `value` may be zero.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 value);
401 
402     /**
403      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
404      * a call to {approve}. `value` is the new allowance.
405      */
406     event Approval(address indexed owner, address indexed spender, uint256 value);
407 }
408 
409 
410 
411 // File: @openzeppelin/contracts/utils/Address.sol
412 
413 /**
414  * @dev Collection of functions related to the address type
415  */
416 library Address {
417     /**
418      * @dev Returns true if `account` is a contract.
419      *
420      * [IMPORTANT]
421      * ====
422      * It is unsafe to assume that an address for which this function returns
423      * false is an externally-owned account (EOA) and not a contract.
424      *
425      * Among others, `isContract` will return false for the following
426      * types of addresses:
427      *
428      *  - an externally-owned account
429      *  - a contract in construction
430      *  - an address where a contract will be created
431      *  - an address where a contract lived, but was destroyed
432      * ====
433      */
434     function isContract(address account) internal view returns (bool) {
435         // This method relies on extcodesize, which returns 0 for contracts in
436         // construction, since the code is only stored at the end of the
437         // constructor execution.
438 
439         uint256 size;
440         // solhint-disable-next-line no-inline-assembly
441         assembly {
442             size := extcodesize(account)
443         }
444         return size > 0;
445     }
446 
447     /**
448      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
449      * `recipient`, forwarding all available gas and reverting on errors.
450      *
451      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
452      * of certain opcodes, possibly making contracts go over the 2300 gas limit
453      * imposed by `transfer`, making them unable to receive funds via
454      * `transfer`. {sendValue} removes this limitation.
455      *
456      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
457      *
458      * IMPORTANT: because control is transferred to `recipient`, care must be
459      * taken to not create reentrancy vulnerabilities. Consider using
460      * {ReentrancyGuard} or the
461      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
462      */
463     function sendValue(address payable recipient, uint256 amount) internal {
464         require(address(this).balance >= amount, "Address: insufficient balance");
465 
466         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
467         (bool success, ) = recipient.call{value: amount}("");
468         require(success, "Address: unable to send value, recipient may have reverted");
469     }
470 
471     /**
472      * @dev Performs a Solidity function call using a low level `call`. A
473      * plain`call` is an unsafe replacement for a function call: use this
474      * function instead.
475      *
476      * If `target` reverts with a revert reason, it is bubbled up by this
477      * function (like regular Solidity function calls).
478      *
479      * Returns the raw returned data. To convert to the expected return value,
480      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
481      *
482      * Requirements:
483      *
484      * - `target` must be a contract.
485      * - calling `target` with `data` must not revert.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
490         return functionCall(target, data, "Address: low-level call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
495      * `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal returns (bytes memory) {
504         return functionCallWithValue(target, data, 0, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but also transferring `value` wei to `target`.
510      *
511      * Requirements:
512      *
513      * - the calling contract must have an ETH balance of at least `value`.
514      * - the called Solidity function must be `payable`.
515      *
516      * _Available since v3.1._
517      */
518     function functionCallWithValue(
519         address target,
520         bytes memory data,
521         uint256 value
522     ) internal returns (bytes memory) {
523         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
528      * with `errorMessage` as a fallback revert reason when `target` reverts.
529      *
530      * _Available since v3.1._
531      */
532     function functionCallWithValue(
533         address target,
534         bytes memory data,
535         uint256 value,
536         string memory errorMessage
537     ) internal returns (bytes memory) {
538         require(address(this).balance >= value, "Address: insufficient balance for call");
539         require(isContract(target), "Address: call to non-contract");
540 
541         // solhint-disable-next-line avoid-low-level-calls
542         (bool success, bytes memory returndata) = target.call{value: value}(data);
543         return _verifyCallResult(success, returndata, errorMessage);
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
548      * but performing a static call.
549      *
550      * _Available since v3.3._
551      */
552     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
553         return functionStaticCall(target, data, "Address: low-level static call failed");
554     }
555 
556     /**
557      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
558      * but performing a static call.
559      *
560      * _Available since v3.3._
561      */
562     function functionStaticCall(
563         address target,
564         bytes memory data,
565         string memory errorMessage
566     ) internal view returns (bytes memory) {
567         require(isContract(target), "Address: static call to non-contract");
568 
569         // solhint-disable-next-line avoid-low-level-calls
570         (bool success, bytes memory returndata) = target.staticcall(data);
571         return _verifyCallResult(success, returndata, errorMessage);
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
576      * but performing a delegate call.
577      *
578      * _Available since v3.4._
579      */
580     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
581         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
582     }
583 
584     /**
585      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
586      * but performing a delegate call.
587      *
588      * _Available since v3.4._
589      */
590     function functionDelegateCall(
591         address target,
592         bytes memory data,
593         string memory errorMessage
594     ) internal returns (bytes memory) {
595         require(isContract(target), "Address: delegate call to non-contract");
596 
597         // solhint-disable-next-line avoid-low-level-calls
598         (bool success, bytes memory returndata) = target.delegatecall(data);
599         return _verifyCallResult(success, returndata, errorMessage);
600     }
601 
602     function _verifyCallResult(
603         bool success,
604         bytes memory returndata,
605         string memory errorMessage
606     ) private pure returns (bytes memory) {
607         if (success) {
608             return returndata;
609         } else {
610             // Look for revert reason and bubble it up if present
611             if (returndata.length > 0) {
612                 // The easiest way to bubble the revert reason is using memory via assembly
613 
614                 // solhint-disable-next-line no-inline-assembly
615                 assembly {
616                     let returndata_size := mload(returndata)
617                     revert(add(32, returndata), returndata_size)
618                 }
619             } else {
620                 revert(errorMessage);
621             }
622         }
623     }
624 }
625 
626 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
627 
628 /**
629  * @title SafeERC20
630  * @dev Wrappers around ERC20 operations that throw on failure (when the token
631  * contract returns false). Tokens that return no value (and instead revert or
632  * throw on failure) are also supported, non-reverting calls are assumed to be
633  * successful.
634  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
635  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
636  */
637 library SafeERC20 {
638     using SafeMath for uint256;
639     using Address for address;
640 
641     function safeTransfer(
642         IERC20 token,
643         address to,
644         uint256 value
645     ) internal {
646         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
647     }
648 
649     function safeTransferFrom(
650         IERC20 token,
651         address from,
652         address to,
653         uint256 value
654     ) internal {
655         _callOptionalReturn(token, abi.encodeWithSelector(token.transferXVMC.selector, from, to, value));
656     }
657 
658     /**
659      * @dev Deprecated. This function has issues similar to the ones found in
660      * {IERC20-approve}, and its usage is discouraged.
661      *
662      * Whenever possible, use {safeIncreaseAllowance} and
663      * {safeDecreaseAllowance} instead.
664      */
665     function safeApprove(
666         IERC20 token,
667         address spender,
668         uint256 value
669     ) internal {
670         // safeApprove should only be called when setting an initial allowance,
671         // or when resetting it to zero. To increase and decrease it, use
672         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
673         // solhint-disable-next-line max-line-length
674         require(
675             (value == 0) || (token.allowance(address(this), spender) == 0),
676             "SafeERC20: approve from non-zero to non-zero allowance"
677         );
678         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
679     }
680 
681     function safeIncreaseAllowance(
682         IERC20 token,
683         address spender,
684         uint256 value
685     ) internal {
686         uint256 newAllowance = token.allowance(address(this), spender).add(value);
687         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
688     }
689 
690     function safeDecreaseAllowance(
691         IERC20 token,
692         address spender,
693         uint256 value
694     ) internal {
695         uint256 newAllowance =
696             token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
697         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
698     }
699 
700     /**
701      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
702      * on the return value: the return value is optional (but if data is returned, it must not be false).
703      * @param token The token targeted by the call.
704      * @param data The call data (encoded using abi.encode or one of its variants).
705      */
706     function _callOptionalReturn(IERC20 token, bytes memory data) private {
707         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
708         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
709         // the target address contains contract code and also asserts for success in the low-level call.
710 
711         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
712         if (returndata.length > 0) {
713             // Return data is optional
714             // solhint-disable-next-line max-line-length
715             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
716         }
717     }
718 }
719 
720 // File: xvmc-contracts/pools/1year.sol
721 
722 
723 
724 pragma solidity 0.6.12;
725 
726 
727 interface IMasterChef {
728     function deposit(uint256 _pid, uint256 _amount) external;
729     function withdraw(uint256 _pid, uint256 _amount) external;
730     function pendingEgg(uint256 _pid, address _user) external view returns (uint256);
731     function userInfo(uint256 _pid, address _user) external view returns (uint256, uint256);
732     function emergencyWithdraw(uint256 _pid) external;
733     function feeAddress() external view returns (address);
734     function owner() external view returns (address);
735 }
736 
737 interface IacPool {
738     function hopDeposit(uint256 _amount, address _recipientAddress, uint256 previousLastDepositedTime, uint256 _mandatoryTime) external;
739     function getUserShares(address wallet) external view returns (uint256);
740     function getNrOfStakes(address _user) external view returns (uint256);
741 	function giftDeposit(uint256 _amount, address _toAddress, uint256 _minToServeInSecs) external;
742 }
743 
744 interface IGovernance {
745     function costToVote() external view returns (uint256);
746     function rebalancePools() external;
747     function getRollBonus(address _bonusForPool) external view returns (uint256);
748     function stakeRolloverBonus(address _toAddress, address _depositToPool, uint256 _bonusToPay, uint256 _stakeID) external;
749 	function treasuryWallet() external view returns (address);
750 }
751 interface IVoting {
752     function addCredit(uint256 amount, address _beneficiary) external;
753 }
754 
755 
756 /**
757  * XVMC time-locked deposit
758  * Auto-compounding pool
759  * !!! Warning: !!! Licensed under Business Source License 1.1 (BSL 1.1)
760  */
761 contract XVMCtimeDeposit is ReentrancyGuard {
762     using SafeERC20 for IERC20;
763     using SafeMath for uint256;
764 
765     struct UserInfo {
766         uint256 shares; // number of shares for a user
767         uint256 lastDepositedTime; // keeps track of deposited time for potential penalty
768         uint256 xvmcAtLastUserAction; // keeps track of XVMC deposited at the last user action
769         uint256 lastUserActionTime; // keeps track of the last user action time
770         uint256 mandatoryTimeToServe; // optional: disables early withdraw
771     }
772 	//allows stakes to be transferred, similar to token transfers
773 	struct StakeTransfer {
774 		uint256 shares; // ALLOWANCE of shares
775         uint256 lastDepositedTime;
776         uint256 mandatoryTimeToServe; 
777 	}
778 
779     IERC20 public immutable token; // XVMC token
780 	
781 	IERC20 public immutable oldToken = IERC20(0x6d0c966c8A09e354Df9C48b446A474CE3343D912);
782     
783     IERC20 public immutable dummyToken; 
784 
785     IMasterChef public masterchef;  
786     
787     uint256 public immutable withdrawFeePeriod = 365 days;
788     uint256 public immutable gracePeriod = 14 days;
789 
790     mapping(address => UserInfo[]) public userInfo;
791     mapping(address => uint256) public userVote; //the ID the user is voting for
792     mapping(uint256 => uint256) public totalVotesForID; //total votes for a given ID
793 	mapping(address => address) public userDelegate; //user can delegate their voting to another wallet
794 	
795 	mapping(address => bool) public trustedSender; //Pools with shorter lockup duration(trustedSender(contracts) can transfer into this pool)
796 	mapping(address => bool) public trustedPool; //Pools with longer lockup duration(can transfer from this pool into trustedPool(contracts))
797 	
798 	mapping(address => mapping(address => StakeTransfer[])) private _stakeAllowances; 
799 	//similar to token allowances, difference being it's not for amount of tokens, but for a specific stake defined by shares, latdeposittime and mandatorytime
800 
801 	uint256 public poolID; 
802     uint256 public totalShares;
803     address public admin; //admin = governing contract!
804     address public treasury; //penalties go to this address
805     address public migrationPool; //if pools are to change
806 	
807 	address public votingCreditAddress;
808 	
809 	uint256 public minimumGift = 1000000 * 1e18;
810 	bool public updateMinGiftGovernor = true; //allows automatic update by anybody to costToVote from governing contract
811     
812     uint256 public callFee = 5; // call fee paid for rebalancing pools
813 	
814 	bool public allowStakeTransfer = true; //enable/disable transferring of stakes to another wallet
815 	bool public allowStakeTransferFrom = false; //allow third party transfers(disabled initially)
816 	
817 	bool public partialWithdrawals = true; //partial withdrawals from stakes
818 	bool public partialTransfers = true; //allows transferring a portion of  a stake
819 	
820 	bool public allowOrigin = true; //(dis)allows tx.origin for voting
821 	//safe to use tx.origin IMO. Can be disabled and use msg.sender instead
822 	//it allows the voting and delegating in a single transaction for all pools through a proxy contract
823 	
824 	// Easier to verify (opposed to checking event logs)
825 	uint256 public trustedSenderCount;
826 	uint256 public trustedPoolCount;
827 
828     event Deposit(address indexed sender, uint256 amount, uint256 shares, uint256 lastDepositedTime);
829     event GiftDeposit(address indexed sender, address indexed recipient, uint256 amount, uint256 shares, uint256 lastDepositedTime);
830     event AddAndExtendStake(address indexed sender, address indexed recipient, uint256 amount, uint256 stakeID, uint256 shares, uint256 lastDepositedTime);
831     event Withdraw(address indexed sender, uint256 amount, uint256 penalty, uint256 shares);
832     
833 	event TransferStake(address indexed sender, address indexed recipient, uint256 shares, uint256 stakeID);
834     event HopPool(address indexed sender, uint256 XVMCamount, uint256 shares, address indexed newPool);
835     event MigrateStake(address indexed goodSamaritan, uint256 XVMCamount, uint256 shares, address indexed recipient);
836    
837     event HopDeposit(address indexed recipient, uint256 amount, uint256 shares, uint256 previousLastDepositedTime, uint256 mandatoryTime);
838 	
839     event RemoveVotes(address indexed voter, uint256 proposalID, uint256 change);
840     event AddVotes(address indexed voter, uint256 proposalID, uint256 change);
841 	
842 	event TrustedSender(address contractAddress, bool setting);
843 	event TrustedPool(address contractAddress, bool setting);
844 	
845 	event StakeApproval(address owner, address spender, uint256 allowanceID, uint256 shareAllowance, uint256 lastDeposit, uint256 mandatoryTime);
846 	event StakeAllowanceRevoke(address owner, address spender, uint256 allowanceID);
847 	event TransferStakeFrom(address _from, address _to, uint256 _stakeID, uint256 _allowanceID);
848 	
849 	event SetDelegate(address userDelegating, address delegatee);
850 
851     /**
852      * @notice Constructor
853      * @param _token: XVMC token contract
854      * @param _dummyToken: Dummy token contract
855      * @param _masterchef: MasterChef contract
856      * @param _admin: address of the admin
857      * @param _treasury: address of the treasury (collects fees)
858      */
859     constructor(
860         IERC20 _token,
861         IERC20 _dummyToken,
862         IMasterChef _masterchef,
863         address _admin,
864         address _treasury,
865         uint256 _poolID
866     ) public {
867         token = _token;
868         dummyToken = _dummyToken;
869         masterchef = _masterchef;
870         admin = _admin;
871         treasury = _treasury;
872         poolID = _poolID;
873 
874         IERC20(_dummyToken).safeApprove(address(_masterchef), uint256(-1));
875     }
876     
877     /**
878      * @notice Checks if the msg.sender is the admin
879      */
880     modifier adminOnly() {
881         require(msg.sender == admin, "admin: wut?");
882         _;
883     }
884 	
885     /**
886      * @notice Deposits funds into the XVMC time-locked vault
887      * @param _amount: number of tokens to deposit (in XVMC)
888      * 
889      * Creates a NEW stake
890      */
891     function deposit(uint256 _amount) external nonReentrant {
892     	require(_amount > 0, "Nothing to deposit");
893 	
894         uint256 pool = balanceOf();
895         token.safeTransferFrom(msg.sender, address(this), _amount);
896         uint256 currentShares = 0;
897         if (totalShares != 0) {
898             currentShares = (_amount.mul(totalShares)).div(pool);
899         } else {
900             currentShares = _amount;
901         }
902         
903         totalShares = totalShares.add(currentShares);
904         
905         userInfo[msg.sender].push(
906                 UserInfo(currentShares, block.timestamp, _amount, block.timestamp, 0)
907             );
908         
909 		uint256 votingFor = userVote[msg.sender];
910         if(votingFor != 0) {
911             _updateVotingAddDiff(msg.sender, votingFor, currentShares);
912         }
913 
914         emit Deposit(msg.sender, _amount, currentShares, block.timestamp);
915     }
916 
917     /**
918      * Equivalent to Deposit
919      * Instead of crediting the msg.sender, it credits custom recipient
920      * A mechanism to gift a time-locked stake to another wallet
921      * Users can withdraw at any time(but will pay a penalty)
922      * Optionally stake can be irreversibly locked for a minimum period of time(minToServe)
923      */
924     function giftDeposit(uint256 _amount, address _toAddress, uint256 _minToServeInSecs) external nonReentrant {
925         require(_amount >= minimumGift, "Below Minimum Gift");
926 
927         uint256 pool = balanceOf();
928         token.safeTransferFrom(msg.sender, address(this), _amount);
929         uint256 currentShares = 0;
930         if (totalShares != 0) {
931             currentShares = (_amount.mul(totalShares)).div(pool);
932         } else {
933             currentShares = _amount;
934         }
935         
936         totalShares = totalShares.add(currentShares);
937         
938         userInfo[_toAddress].push(
939                 UserInfo(currentShares, block.timestamp, _amount, block.timestamp, _minToServeInSecs)
940             );
941 			
942         uint256 votingFor = userVote[_toAddress];
943         if(votingFor != 0) {
944             _updateVotingAddDiff(_toAddress, votingFor, currentShares);
945         }
946 
947         emit GiftDeposit(msg.sender, _toAddress, _amount, currentShares, block.timestamp);
948     }
949     
950     /**
951      * @notice Deposits funds into the XVMC time-locked vault
952      * @param _amount: number of tokens to deposit (in XVMC)
953      * 
954      * Deposits into existing stake, effectively extending the stake
955      * It's used for rolling over stakes by the governor(admin) as well
956      * Mandatory Lock Up period can only be Increased
957 	 * It can be Decreased if stake is being extended(after it matures)
958      */
959     function addAndExtendStake(address _recipientAddr, uint256 _amount, uint256 _stakeID, uint256 _lockUpTokensInSeconds) external nonReentrant {
960         require(_amount > 0, "Nothing to deposit");
961         require(userInfo[_recipientAddr].length > _stakeID, "wrong Stake ID");
962         
963         if(msg.sender != admin) { require(_recipientAddr == msg.sender, "can only extend your own stake"); }
964 
965         uint256 pool = balanceOf();
966         token.safeTransferFrom(msg.sender, address(this), _amount);
967         uint256 currentShares = 0;
968         if (totalShares != 0) {
969             currentShares = (_amount.mul(totalShares)).div(pool);
970         } else {
971             currentShares = _amount;
972         }
973         UserInfo storage user = userInfo[_recipientAddr][_stakeID];
974 
975         user.shares = user.shares.add(currentShares);
976         totalShares = totalShares.add(currentShares);
977         
978         if(_lockUpTokensInSeconds > user.mandatoryTimeToServe || 
979 				block.timestamp > user.lastDepositedTime.add(withdrawFeePeriod)) { 
980 			user.mandatoryTimeToServe = _lockUpTokensInSeconds; 
981 		}
982 		
983         user.xvmcAtLastUserAction = user.shares.mul(balanceOf()).div(totalShares);
984         user.lastUserActionTime = block.timestamp;
985 		user.lastDepositedTime = block.timestamp;
986         
987 		uint256 votingFor = userVote[_recipientAddr];
988         if(votingFor != 0) {
989             _updateVotingAddDiff(_recipientAddr, votingFor, currentShares);
990         }
991 
992         emit AddAndExtendStake(msg.sender, _recipientAddr, _amount, _stakeID, currentShares, block.timestamp);
993     }
994  
995 
996     function withdrawAll(uint256 _stakeID) external {
997         withdraw(userInfo[msg.sender][_stakeID].shares, _stakeID);
998     }
999 
1000 	
1001     /**
1002      * Harvest pending rewards from masterchef
1003 	 * Governor pays the rewards for harvesting and rebalancing
1004      */
1005     function harvest() external {
1006         IMasterChef(masterchef).withdraw(poolID, 0);
1007     }
1008 
1009     
1010     /**
1011      * @notice Sets admin address and treasury
1012      * If new governor is set, anyone can pay the gas to update the addresses
1013 	 * Masterchef owns the token, the governor owns the Masterchef
1014 	 * Treasury is feeAddress from masterchef(which collects fees from deposits into masterchef)
1015 	 * Currently all penalties are going to fee address(currently governing contract)
1016 	 * Alternatively, fee address can be set as a separate contract, which would re-distribute
1017 	 * The tokens back into pool(so honest stakers would directly receive penalties from prematurely ended stakes)
1018 	 * Alternatively could also split: a portion to honest stakers, a portion into governing contract. 
1019 	 * With initial setting, all penalties are going towards governing contract
1020      */
1021     function setAdmin() external {
1022         admin = IMasterChef(masterchef).owner();
1023         treasury = IMasterChef(masterchef).feeAddress();
1024     }
1025 	
1026 	//updates minimum gift to costToVote from Governing contract
1027 	function updateMinimumGift() external {
1028 		require(updateMinGiftGovernor, "automatic update disabled");
1029 		minimumGift = IGovernance(admin).costToVote();
1030 	}
1031 
1032     /**
1033      * @notice Withdraws from funds from the XVMC time-locked vault
1034      * @param _shares: Number of shares to withdraw
1035      */
1036     function withdraw(uint256 _shares, uint256 _stakeID) public {
1037         require(_stakeID < userInfo[msg.sender].length, "invalid stake ID");
1038         UserInfo storage user = userInfo[msg.sender][_stakeID];
1039         require(_shares > 0, "Nothing to withdraw");
1040         require(_shares <= user.shares, "Withdraw amount exceeds balance");
1041         require(block.timestamp > user.lastDepositedTime.add(user.mandatoryTimeToServe), "must serve mandatory time");
1042         if(!partialWithdrawals) { require(_shares == user.shares, "must transfer full stake"); }
1043 
1044         uint256 currentAmount = (balanceOf().mul(_shares)).div(totalShares);
1045         user.shares = user.shares.sub(_shares);
1046         totalShares = totalShares.sub(_shares);
1047 
1048         uint256 currentWithdrawFee = 0;
1049         
1050         if (block.timestamp < user.lastDepositedTime.add(withdrawFeePeriod)) {
1051            uint256 withdrawFee = uint256(5000).sub(((block.timestamp - user.lastDepositedTime).div(86400)).mul(1337).div(100));
1052             currentWithdrawFee = currentAmount.mul(withdrawFee).div(10000);
1053             token.safeTransfer(treasury, currentWithdrawFee); 
1054             currentAmount = currentAmount.sub(currentWithdrawFee);
1055         } else if(block.timestamp > user.lastDepositedTime.add(withdrawFeePeriod).add(gracePeriod)) {
1056             uint256 withdrawFee = block.timestamp.sub(user.lastDepositedTime.add(withdrawFeePeriod)).div(86400).mul(1337).div(100);
1057             if(withdrawFee > 5000) { withdrawFee = 5000; }
1058             currentWithdrawFee = currentAmount.mul(withdrawFee).div(10000);
1059             token.safeTransfer(treasury, currentWithdrawFee); 
1060             currentAmount = currentAmount.sub(currentWithdrawFee);
1061         }
1062 
1063         if (user.shares > 0) {
1064             user.xvmcAtLastUserAction = user.shares.mul(balanceOf().sub(currentAmount)).div(totalShares);
1065             user.lastUserActionTime = block.timestamp;
1066         } else {
1067             _removeStake(msg.sender, _stakeID); //delete the stake
1068         }
1069         
1070 		uint256 votingFor = userVote[msg.sender];
1071         if(votingFor != 0) {
1072             _updateVotingSubDiff(msg.sender, votingFor, _shares);
1073         }
1074 
1075 		emit Withdraw(msg.sender, currentAmount, currentWithdrawFee, _shares);
1076 		
1077         token.safeTransfer(msg.sender, currentAmount);
1078     } 
1079     
1080     /**
1081      * Users can transfer their stake to another pool
1082      * Can only transfer to pool with longer lock-up period(trusted pools)
1083      * Equivalent to withdrawing, but it deposits the stake into another pool as hopDeposit
1084      * Users can transfer stake without penalty
1085      * Time served gets transferred 
1086      * The pool is "registered" as a "trustedSender" to another pool
1087      */
1088     function hopStakeToAnotherPool(uint256 _shares, uint256 _stakeID, address _poolAddress) public {
1089         require(_shares > 0, "Nothing to withdraw");
1090 		require(_stakeID < userInfo[msg.sender].length, "wrong stake ID");
1091 		
1092         UserInfo storage user = userInfo[msg.sender][_stakeID];
1093 		require(_shares <= user.shares, "Withdraw amount exceeds balance");
1094         if(!partialWithdrawals) { require(_shares == user.shares, "must transfer full stake"); } 
1095         
1096 		uint256 _lastDepositedTime = user.lastDepositedTime;
1097         if(trustedPool[_poolAddress]) { 
1098 			if(block.timestamp > _lastDepositedTime.add(withdrawFeePeriod).add(gracePeriod)) {
1099 				_lastDepositedTime = block.timestamp; //if after grace period, resets timer
1100 			}
1101         } else { 
1102 			//can only hop into trusted Pools or into trusted sender(lower pool) after time has been served within grace period
1103 			//only meant for stakeRollover. After hop, stake is extended and timer reset
1104             require(trustedSender[_poolAddress] && block.timestamp > _lastDepositedTime.add(withdrawFeePeriod) &&
1105                                 block.timestamp < _lastDepositedTime.add(withdrawFeePeriod).add(gracePeriod),
1106                                         "can only hop into pre-set Pools");
1107 		}
1108 
1109         uint256 currentAmount = (balanceOf().mul(_shares)).div(totalShares);
1110         user.shares = user.shares.sub(_shares);
1111         totalShares = totalShares.sub(_shares);
1112 		
1113 		uint256 votingFor = userVote[msg.sender];
1114         if(votingFor != 0) {
1115             _updateVotingSubDiff(msg.sender, votingFor, _shares);
1116         }
1117 		
1118 		IacPool(_poolAddress).hopDeposit(currentAmount, msg.sender, _lastDepositedTime, user.mandatoryTimeToServe);
1119 		//_poolAddress can only be trusted pool(contract)
1120 
1121         if (user.shares > 0) {
1122             user.xvmcAtLastUserAction = user.shares.mul(balanceOf()).div(totalShares);
1123             user.lastUserActionTime = block.timestamp;
1124         } else {
1125             _removeStake(msg.sender, _stakeID); //delete the stake
1126         }
1127         
1128         emit HopPool(msg.sender, currentAmount, _shares, _poolAddress);
1129     }
1130 
1131     
1132     /**
1133      * hopDeposit is equivalent to gift deposit, exception being that the time served can be passed
1134      * The msg.sender can only be a trusted contract
1135      * The checks are already made in the hopStakeToAnotherPool function
1136      * msg sender can only be trusted senders
1137      */
1138      
1139     function hopDeposit(uint256 _amount, address _recipientAddress, uint256 previousLastDepositedTime, uint256 _mandatoryTime) external {
1140         require(trustedSender[msg.sender] || trustedPool[msg.sender], "only trusted senders(other pools)");
1141 		//only trustedSenders allowed. TrustedPools are under condition that the stake has matured(hopStake checks condition)
1142         
1143         uint256 pool = balanceOf();
1144         token.safeTransferFrom(msg.sender, address(this), _amount);
1145         uint256 currentShares = 0;
1146         if (totalShares != 0) {
1147             currentShares = (_amount.mul(totalShares)).div(pool);
1148         } else {
1149             currentShares = _amount;
1150         }
1151         
1152         totalShares = totalShares.add(currentShares);
1153         
1154         userInfo[_recipientAddress].push(
1155                 UserInfo(currentShares, previousLastDepositedTime, _amount,
1156                     block.timestamp, _mandatoryTime)
1157             );
1158 
1159 		uint256 votingFor = userVote[_recipientAddress];
1160         if(votingFor != 0) {
1161             _updateVotingAddDiff(_recipientAddress, votingFor, currentShares);
1162         }
1163 
1164         emit HopDeposit(_recipientAddress, _amount, currentShares, previousLastDepositedTime, _mandatoryTime);
1165     }
1166 	
1167     /**
1168      * Users are encouraged to keep staking
1169      * Governor pays bonuses to re-commit and roll over your stake
1170      * Higher bonuses available for hopping into pools with longer lockup period
1171      */
1172     function stakeRollover(address _poolInto, uint256 _stakeID) external {
1173         require(userInfo[msg.sender].length > _stakeID, "invalid stake ID");
1174         
1175         UserInfo storage user = userInfo[msg.sender][_stakeID];
1176         
1177         require(block.timestamp > user.lastDepositedTime.add(withdrawFeePeriod), "stake not yet mature");
1178         
1179         uint256 currentAmount = (balanceOf().mul(user.shares)).div(totalShares); 
1180         uint256 toPay = currentAmount.mul(IGovernance(admin).getRollBonus(_poolInto)).div(10000);
1181 
1182         require(IERC20(token).balanceOf(admin) >= toPay, "governor reserves are currently insufficient");
1183         
1184         if(_poolInto == address(this)) {
1185             IGovernance(admin).stakeRolloverBonus(msg.sender, _poolInto, toPay, _stakeID); //gov sends tokens to extend the stake
1186         } else {
1187 			hopStakeToAnotherPool(user.shares, _stakeID, _poolInto); //will revert if pool is wrong
1188 			IGovernance(admin).stakeRolloverBonus(msg.sender, _poolInto, toPay, IacPool(_poolInto).getNrOfStakes(msg.sender) - 1); //extends latest stake
1189         }
1190     }
1191     
1192     /**
1193      * Transfer stake to another account(another wallet address)
1194      */
1195     function transferStakeToAnotherWallet(uint256 _shares, uint256 _stakeID, address _recipientAddress) external {
1196         require(allowStakeTransfer, "transfers disabled");
1197 		require(_recipientAddress != msg.sender, "can't transfer to self");
1198         require(_stakeID < userInfo[msg.sender].length, "wrong stake ID");
1199         UserInfo storage user = userInfo[msg.sender][_stakeID];
1200 		uint256 _tokensTransferred = _shares.mul(balanceOf()).div(totalShares);
1201         require(_tokensTransferred >= minimumGift, "Below minimum threshold");
1202         require(_shares <= user.shares, "Withdraw amount exceeds balance");
1203         if(!partialTransfers) { require(_shares == user.shares, "must transfer full stake"); }
1204         
1205         user.shares = user.shares.sub(_shares);
1206 
1207 		uint256 votingFor = userVote[msg.sender];
1208         if(votingFor != 0) {
1209             _updateVotingSubDiff(msg.sender, votingFor, _shares);
1210         }
1211 		votingFor = userVote[_recipientAddress];
1212         if(votingFor != 0) {
1213             _updateVotingAddDiff(_recipientAddress, votingFor, _shares);
1214         }
1215         
1216         userInfo[_recipientAddress].push(
1217                 UserInfo(_shares, user.lastDepositedTime, _tokensTransferred, block.timestamp, user.mandatoryTimeToServe)
1218             );
1219 
1220         if (user.shares > 0) {
1221             user.xvmcAtLastUserAction = user.shares.mul(balanceOf()).div(totalShares);
1222             user.lastUserActionTime = block.timestamp;
1223         } else {
1224             _removeStake(msg.sender, _stakeID); //delete the stake
1225         }
1226 
1227         emit TransferStake(msg.sender, _recipientAddress, _shares, _stakeID);
1228     }
1229 
1230     /**
1231      * user delegates their shares to cast a vote on a proposal
1232      * casting to proposal ID = 0 is basically neutral position (not voting)
1233 	 * Is origin is allowed, proxy contract can be used to vote in all pools in a single tx
1234      */
1235     function voteForProposal(uint256 proposalID) external {
1236         address _wallet;
1237 		allowOrigin ? _wallet = tx.origin : _wallet = msg.sender;
1238         uint256 votingFor = userVote[_wallet]; //the ID the user is voting for(before change)
1239 		
1240         if(proposalID != votingFor) { // do nothing if false(already voting for that ID)
1241 	
1242 			uint256 userTotalShares = getUserTotalShares(_wallet);
1243 			if(userTotalShares > 0) { //if false, no shares, thus just assign proposal ID to userVote
1244 				if(proposalID != 0) { // Allocates vote to an ID
1245 					if(votingFor == 0) { //starts voting, adds votes
1246 						_updateVotingAddDiff(_wallet, proposalID, userTotalShares);
1247 					} else { //removes from previous vote, adds to new
1248 						_updateVotingSubDiff(_wallet, votingFor, userTotalShares);
1249 						_updateVotingAddDiff(_wallet, proposalID, userTotalShares);
1250 					}
1251 				} else { //stops voting (previously voted, now going into neutral (=0)
1252 					_updateVotingSubDiff(_wallet, votingFor, userTotalShares);
1253 				}
1254 			}
1255 			userVote[_wallet] = proposalID;
1256 		}
1257     }
1258 	
1259 	/*
1260 	* delegatee can vote with shares of another user
1261 	*/
1262     function delegateeVote(address[] calldata votingAddress, uint256 proposalID) external {
1263         for(uint256 i = 0; i < votingAddress.length; i++) { 
1264 			if(userDelegate[votingAddress[i]] == msg.sender) {
1265 				uint256 votingFor = userVote[votingAddress[i]]; //the ID the user is voting for(before change)
1266 				
1267 				if(proposalID != votingFor){
1268 				
1269 					uint256 userTotalShares = getUserTotalShares(votingAddress[i]);
1270 					if(userTotalShares > 0) {
1271 						if(proposalID != 0) { 
1272 							if(votingFor == 0) {
1273 								_updateVotingAddDiff(votingAddress[i], proposalID, userTotalShares);
1274 							} else {
1275 								_updateVotingSubDiff(votingAddress[i], votingFor, userTotalShares);
1276 								_updateVotingAddDiff(votingAddress[i], proposalID, userTotalShares);
1277 							}
1278 						} else {
1279 							_updateVotingSubDiff(votingAddress[i], votingFor, userTotalShares);
1280 						}
1281 					}
1282 					userVote[votingAddress[i]] = proposalID;
1283 				}
1284 			}
1285 		}
1286     }
1287 	
1288      /**
1289      * Users can delegate their shares
1290      */
1291     function setDelegate(address _delegate) external {
1292         address _wallet;
1293 		allowOrigin ? _wallet=tx.origin : _wallet=msg.sender;
1294         userDelegate[_wallet] = _delegate;
1295         
1296 		emit SetDelegate(_wallet, _delegate);
1297     }
1298 	
1299 	//allows third party stake transfer(stake IDs can be changed, so instead of being identified through ID, it's identified by shares, lastdeposit and mandatory time
1300     function giveStakeAllowance(address spender, uint256 _stakeID) external {
1301 		UserInfo storage user = userInfo[msg.sender][_stakeID];
1302 		require(user.shares.mul(balanceOf()).div(totalShares) >= minimumGift, "below minimum threshold");
1303 		
1304 		uint256 _allowanceID = _stakeAllowances[msg.sender][spender].length;
1305 
1306 		_stakeAllowances[msg.sender][spender].push(
1307 			StakeTransfer(user.shares, user.lastDepositedTime, user.mandatoryTimeToServe)
1308 		);
1309 		
1310 		emit StakeApproval(msg.sender, spender, _allowanceID, user.shares, user.lastDepositedTime, user.mandatoryTimeToServe);
1311     }
1312 	
1313     //Note: allowanceID (and not ID of the stake!)
1314 	function revokeStakeAllowance(address spender, uint256 allowanceID) external {
1315 		StakeTransfer[] storage allowances = _stakeAllowances[msg.sender][spender];
1316         uint256 lastAllowanceID = allowances.length.sub(1);
1317         
1318         if(allowanceID != lastAllowanceID) {
1319             allowances[allowanceID] = allowances[lastAllowanceID];
1320         }
1321         
1322         allowances.pop();
1323 		
1324 		emit StakeAllowanceRevoke(msg.sender, spender, allowanceID);
1325 	}
1326 	
1327     function nrOfstakeAllowances(address owner, address spender) public view returns (uint256) {
1328         return _stakeAllowances[owner][spender].length;
1329     }
1330 	
1331     function stakeAllowances(address owner, address spender, uint256 allowanceID) public view returns (uint256, uint256, uint256) {
1332         StakeTransfer storage stakeStore = _stakeAllowances[owner][spender][allowanceID];
1333         return (stakeStore.shares, stakeStore.lastDepositedTime, stakeStore.mandatoryTimeToServe);
1334     }
1335 	
1336     /**
1337      * A third party can transfer the stake(allowance required)
1338 	 * Allows smart contract inter-operability similar to how regular tokens work
1339 	 * Can only transfer full stake (You can split the stake through other methods)
1340 	 * Bad: makes illiquid stakes liquid
1341 	 * I think best is to have the option, but leave it unavailable unless desired
1342      */
1343     function transferStakeFrom(address _from, uint256 _stakeID, uint256 allowanceID, address _to) external returns (bool) {
1344         require(allowStakeTransferFrom, "third party stake transfers disabled");
1345 		
1346 		require(_from != _to, "can't transfer to self");
1347         require(_stakeID < userInfo[_from].length, "wrong stake ID");
1348         UserInfo storage user = userInfo[_from][_stakeID];
1349 		
1350 		(uint256 _shares, uint256 _lastDeposit, uint256 _mandatoryTime) = stakeAllowances(_from, msg.sender, allowanceID);
1351 
1352 		//since stake ID can change, the stake to transfer is identified through number of shares, last deposit and mandatory time
1353 		//checks if stake allowance(for allowanceID) matches the actual stake of a user
1354 		require(_shares == user.shares, "incorrect stake or allowance");
1355 		require(_lastDeposit == user.lastDepositedTime, "incorrect stake or allowance");
1356 		require(_mandatoryTime == user.mandatoryTimeToServe, "incorrect stake or allowance");
1357      
1358 		uint256 votingFor = userVote[_from];
1359         if(votingFor != 0) {
1360             _updateVotingSubDiff(_from, votingFor, _shares);
1361         }
1362 		votingFor = userVote[_to];
1363         if(votingFor != 0) {
1364             _updateVotingAddDiff(_to, votingFor, _shares);
1365         }
1366 
1367         _removeStake(_from, _stakeID); //transfer from must transfer full stake
1368 		_revokeStakeAllowance(_from, allowanceID);
1369 		
1370         userInfo[_to].push(
1371                 UserInfo(_shares, _lastDeposit, _shares.mul(balanceOf()).div(totalShares),
1372                     block.timestamp, _mandatoryTime)
1373             );
1374 
1375         emit TransferStakeFrom(_from, _to, _stakeID, allowanceID);
1376 		
1377 		return true;
1378     }
1379 
1380 	/**
1381      * Ability to withdraw tokens from the stake, and add voting credit
1382      * At the time of launch there is no option(voting with credit), but can be added later on
1383     */
1384 	function votingCredit(uint256 _shares, uint256 _stakeID) public {
1385         require(votingCreditAddress != address(0), "disabled");
1386         require(_stakeID < userInfo[msg.sender].length, "invalid stake ID");
1387         UserInfo storage user = userInfo[msg.sender][_stakeID];
1388         require(_shares > 0, "Nothing to withdraw");
1389         require(_shares <= user.shares, "Withdraw amount exceeds balance");
1390 
1391         uint256 currentAmount = (balanceOf().mul(_shares)).div(totalShares);
1392         user.shares = user.shares.sub(_shares);
1393         totalShares = totalShares.sub(_shares);
1394 
1395         if (user.shares > 0) {
1396             user.xvmcAtLastUserAction = user.shares.mul(balanceOf().sub(currentAmount)).div(totalShares);
1397             user.lastUserActionTime = block.timestamp;
1398         } else {
1399             _removeStake(msg.sender, _stakeID); //delete the stake
1400         }
1401 
1402 		uint256 votingFor = userVote[msg.sender];
1403         if(votingFor != 0) {
1404             _updateVotingSubDiff(msg.sender, votingFor, _shares);
1405         }
1406 
1407 		emit Withdraw(votingCreditAddress, currentAmount, 0, _shares);
1408 
1409         token.safeTransfer(votingCreditAddress, currentAmount);
1410 		IVoting(votingCreditAddress).addCredit(currentAmount, msg.sender); //in the votingCreditAddress regulate how much is credited, depending on where it's coming from (msg.sender)
1411     } 
1412 	
1413     /**
1414 	 * Allows the pools to be changed to new contracts
1415      * if migration Pool is set
1416      * anyone can be a "good Samaritan"
1417      * and transfer the stake of another user to the new pool
1418      */
1419     function migrateStake(address _staker, uint256 _stakeID) public {
1420         require(migrationPool != address(0), "migration not activated");
1421         require(_stakeID < userInfo[_staker].length, "invalid stake ID");
1422         UserInfo storage user = userInfo[_staker][_stakeID];
1423 		require(user.shares > 0, "no balance");
1424         
1425         uint256 currentAmount = (balanceOf().mul(user.shares)).div(totalShares);
1426         totalShares = totalShares.sub(user.shares);
1427 		
1428         user.shares = 0; // equivalent to deleting the stake. Pools are no longer to be used,
1429 						//setting user shares to 0 is sufficient
1430 		
1431 		IacPool(migrationPool).hopDeposit(currentAmount, _staker, user.lastDepositedTime, user.mandatoryTimeToServe);
1432 
1433         emit MigrateStake(msg.sender, currentAmount, user.shares, _staker);
1434     }
1435 
1436     /**
1437      * loop and migrate all user stakes
1438      * could run out of gas if too many stakes
1439      */
1440     function migrateAllStakes(address _staker) external {
1441         UserInfo[] storage user = userInfo[_staker];
1442         uint256 userStakes = user.length;
1443         
1444         for(uint256 i=0; i < userStakes; i++) {
1445             migrateStake(_staker, i);
1446         }
1447     }
1448 	
1449     
1450     /**
1451      * Returns number of stakes for a user
1452      */
1453     function getNrOfStakes(address _user) external view returns (uint256) {
1454         return userInfo[_user].length;
1455     }
1456     
1457     /**
1458      * Returns all shares for a user
1459      */
1460     function getUserTotalShares(address _user) public view returns (uint256) {
1461         UserInfo[] storage _stake = userInfo[_user];
1462         uint256 nrOfUserStakes = _stake.length;
1463 
1464 		uint256 countShares = 0;
1465 		
1466 		for(uint256 i=0; i < nrOfUserStakes; i++) {
1467 			countShares += _stake[i].shares;
1468 		}
1469 		
1470 		return countShares;
1471     }
1472 	
1473     /**
1474      * @notice Calculates the expected harvest reward from third party
1475      * @return Expected reward to collect in XVMC
1476      */
1477     function calculateHarvestXVMCRewards() external view returns (uint256) {
1478         uint256 amount = IMasterChef(masterchef).pendingEgg(poolID, address(this));
1479         uint256 currentCallFee = amount.mul(callFee).div(10000);
1480 
1481         return currentCallFee;
1482     }
1483 
1484     /**
1485      * @return Returns total pending xvmc rewards
1486      */
1487     function calculateTotalPendingXVMCRewards() external view returns (uint256) {
1488         uint256 amount = IMasterChef(masterchef).pendingEgg(poolID, address(this));
1489 
1490         return amount;
1491     }
1492 
1493     /**
1494      * @notice Calculates the price per share
1495      */
1496     function getPricePerFullShare() external view returns (uint256) {
1497         return totalShares == 0 ? 1e18 : balanceOf().mul(1e18).div(totalShares);
1498     }
1499     
1500     /**
1501      * @notice returns number of shares for a certain stake of an user
1502      */
1503     function getUserShares(address _wallet, uint256 _stakeID) public view returns (uint256) {
1504         return userInfo[_wallet][_stakeID].shares;
1505     }
1506 	
1507     /**
1508      * @notice Calculates the total underlying tokens
1509      * @dev It includes tokens held by the contract and held in MasterChef
1510      */
1511     function balanceOf() public view returns (uint256) {
1512         uint256 amount = IMasterChef(masterchef).pendingEgg(poolID, address(this)); 
1513         return token.balanceOf(address(this)).add(amount); 
1514     }
1515 	
1516     
1517 	//enables or disables ability to draw stake from another wallet(allowance required)
1518 	function enableDisableStakeTransferFrom(bool _setting) external adminOnly {
1519 		allowStakeTransferFrom = _setting;
1520 	}
1521 
1522     /**
1523      * @notice Sets call fee 
1524      * @dev Only callable by the contract admin.
1525      */
1526     function setCallFee(uint256 _callFee) external adminOnly {
1527         callFee = _callFee;
1528     }
1529 
1530      /*
1531      * set trusted senders, other pools that we can receive from (that can hopDeposit)
1532      * guaranteed to be trusted (they rely lastDepositTime)
1533      */
1534     function setTrustedSender(address _sender, bool _setting) external adminOnly {
1535         if(trustedSender[_sender] != _setting) {
1536 			trustedSender[_sender] = _setting;
1537 			
1538 			_setting ? trustedSenderCount++ : trustedSenderCount--;
1539 
1540 			emit TrustedSender(_sender, _setting);
1541 		}
1542     }
1543     
1544      /**
1545      * set trusted pools, the smart contracts that we can send the tokens to without penalty
1546 	 * NOTICE: new pool must be set as trusted contract(to be able to draw balance without allowance)
1547      */
1548     function setTrustedPool(address _pool, bool _setting) external adminOnly {
1549         if(trustedPool[_pool] != _setting) {
1550 			trustedPool[_pool] = _setting;
1551 			
1552 			_setting ? trustedPoolCount++ : trustedPoolCount--;
1553 
1554 			emit TrustedPool(_pool, _setting);
1555 		}
1556     }
1557 
1558 
1559      /**
1560      * set address of new pool that we can migrate into
1561 	 * !!! NOTICE !!!
1562      *  new pool must be set as trusted contract in the token contract by the governor(to be able to draw balance without allowance)
1563      */
1564     function setMigrationPool(address _newPool) external adminOnly {
1565 		migrationPool = _newPool;
1566     }
1567     
1568      /**
1569      * Enable or disable partial withdrawals from stakes
1570      */
1571     function modifyPartialWithdrawals(bool _decision) external adminOnly {
1572         partialWithdrawals = _decision;
1573     }
1574 	function modifyPartialTransfers(bool _decision) external adminOnly {
1575         partialTransfers = _decision;
1576     }
1577 	
1578 	function enableDisableStakeTransfer(bool _setting) external adminOnly {
1579 		allowStakeTransfer = _setting;
1580 	}
1581 
1582     /**
1583      * @notice Withdraws from MasterChef to Vault without caring about rewards.
1584      * @dev EMERGENCY ONLY. Only callable by the contract admin.
1585      */
1586     function emergencyWithdraw() external adminOnly {
1587         IMasterChef(masterchef).emergencyWithdraw(poolID);
1588         token.safeTransfer(admin, token.balanceOf(address(this)));
1589     }
1590 	
1591 	/*
1592 	 * Unlikely, but Masterchef can be changed if needed to be used without changing pools
1593 	 * masterchef = IMasterChef(token.owner());
1594 	 * Must stop earning first(withdraw tokens from old chef)
1595 	*/
1596 	function setMasterChefAddress(IMasterChef _masterchef, uint256 _newPoolID) external adminOnly {
1597 		masterchef = _masterchef;
1598 		poolID = _newPoolID; //in case pool ID changes
1599 		
1600 		uint256 _dummyAllowance = IERC20(dummyToken).allowance(address(this), address(masterchef));
1601 		if(_dummyAllowance == 0) {
1602 			IERC20(dummyToken).safeApprove(address(_masterchef), type(uint256).max);
1603 		}
1604 	}
1605 	
1606     /**
1607      * When contract is launched, dummyToken shall be deposited to start earning rewards
1608      */
1609     function startEarning() external adminOnly {
1610 		IMasterChef(masterchef).deposit(poolID, dummyToken.balanceOf(address(this)));
1611     }
1612 	
1613     /**
1614      * Dummy token can be withdrawn if ever needed(allows for flexibility)
1615      */
1616 	function stopEarning(uint256 _withdrawAmount) external adminOnly {
1617 		if(_withdrawAmount == 0) { 
1618 			IMasterChef(masterchef).withdraw(poolID, dummyToken.balanceOf(address(masterchef)));
1619 		} else {
1620 			IMasterChef(masterchef).withdraw(poolID, _withdrawAmount);
1621 		}
1622 	}
1623 	
1624     /**
1625      * Withdraws dummyToken to owner(who can burn it if needed)
1626      */
1627     function withdrawDummy(uint256 _amount) external adminOnly {	
1628         if(_amount == 0) { 
1629 			dummyToken.safeTransfer(admin, dummyToken.balanceOf(address(this)));
1630 		} else {
1631 			dummyToken.safeTransfer(admin, _amount);
1632 		}
1633     }
1634 	
1635 	function allowTxOrigin(bool _setting) external adminOnly {
1636 		allowOrigin = _setting;
1637 	}
1638 	
1639 	//sets minimum amount(for sending gift, transferring to another wallet,...)
1640 	//if setting is enabled, minimumGift can be auto-updated to costToVote from governor by anybody
1641 	function setMinimumGiftDeposit(uint256 _amount, bool _setting) external adminOnly {
1642 		minimumGift = _amount;
1643 		updateMinGiftGovernor = _setting;
1644 	}
1645 	
1646     function regulateVotingCredit(address _newAddress) external adminOnly {
1647         votingCreditAddress = _newAddress;
1648     }
1649 	
1650 	/**
1651 	 * option to withdraw wrongfully sent tokens(but requires change of the governing contract to do so)
1652 	 * If you send wrong tokens to the contract address, consider them lost. Though there is possibility of recovery
1653 	 */
1654 	function withdrawStuckTokens(address _tokenAddress) external adminOnly {
1655 		require(_tokenAddress != address(token), "wrong token");
1656 		require(_tokenAddress != address(dummyToken), "wrong token");
1657 		
1658 		IERC20(_tokenAddress).safeTransfer(IGovernance(admin).treasuryWallet(), IERC20(_tokenAddress).balanceOf(address(this)));
1659 	}
1660 	
1661 	
1662     //Note: allowanceID (and not ID of the stake!)
1663 	function _revokeStakeAllowance(address owner, uint256 allowanceID) private {
1664 		StakeTransfer[] storage allowances = _stakeAllowances[owner][msg.sender];
1665         uint256 lastAllowanceID = allowances.length.sub(1);
1666         
1667         if(allowanceID != lastAllowanceID) {
1668             allowances[allowanceID] = allowances[lastAllowanceID];
1669         }
1670         
1671         allowances.pop();
1672 		
1673 		emit StakeAllowanceRevoke(owner, msg.sender, allowanceID);
1674 	}
1675 	
1676     /**
1677      * updates votes(whenever there is transfer of funds)
1678      */
1679     function _updateVotingAddDiff(address voter, uint256 proposalID, uint256 diff) private {
1680         totalVotesForID[proposalID] = totalVotesForID[proposalID].add(diff);
1681         
1682         emit AddVotes(voter, proposalID, diff);
1683     }
1684     function _updateVotingSubDiff(address voter, uint256 proposalID, uint256 diff) private {
1685         totalVotesForID[proposalID] = totalVotesForID[proposalID].sub(diff);
1686         
1687         emit RemoveVotes(voter, proposalID, diff);
1688     }
1689     
1690     /**
1691      * removes the stake
1692      */
1693     function _removeStake(address _staker, uint256 _stakeID) private {
1694         UserInfo[] storage stakes = userInfo[_staker];
1695         uint256 lastStakeID = stakes.length - 1;
1696         
1697         if(_stakeID != lastStakeID) {
1698             stakes[_stakeID] = stakes[lastStakeID];
1699         }
1700         
1701         stakes.pop();
1702     }
1703 }