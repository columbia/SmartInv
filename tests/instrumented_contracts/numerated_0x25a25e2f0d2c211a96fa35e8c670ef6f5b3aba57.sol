1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/RewardsRecipient.sol
4 
5 
6 
7 pragma solidity 0.8.6;
8 
9 abstract contract RewardsRecipient {
10     address public rewardsDistributor;
11 
12     modifier onlyRewardsDistributor() {
13         require(msg.sender == rewardsDistributor, "!rewardsDistributor");
14         _;
15     }
16 
17     function notifyRewardAmount(uint256 rewardTokenIndex, uint256 amount) external virtual;
18 }
19 
20 // File: contracts/IStakingRewards.sol
21 
22 
23 
24 pragma solidity 0.8.6;
25 
26 interface IStakingRewards {
27     // Mutative
28     function stake(uint256 amount) external;
29 
30     function unstakeAndClaimRewards(uint256 unstakeAmount) external;
31 
32     function unstake(uint256 amount) external;
33 
34     function claimRewards() external;
35 
36     // Views
37     function lastTimeRewardApplicable() external view returns (uint256);
38 
39     function rewardPerToken(uint256 rewardTokenIndex) external view returns (uint256);
40 
41     function earned(address account, uint256 rewardTokenIndex) external view returns (uint256);
42 
43     function getRewardForDuration(uint256 rewardTokenIndex) external view returns (uint256);
44 
45     function totalSupply() external view returns (uint256);
46 
47     function balanceOf(address account) external view returns (uint256);
48 }
49 // File: contracts/ILinkswapERC20.sol
50 
51 
52 
53 pragma solidity 0.8.6;
54 
55 interface ILinkswapERC20 {
56     function permit(
57         address owner,
58         address spender,
59         uint256 value,
60         uint256 deadline,
61         uint8 v,
62         bytes32 r,
63         bytes32 s
64     ) external;
65 }
66 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
67 
68 
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev Contract module that helps prevent reentrant calls to a function.
74  *
75  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
76  * available, which can be applied to functions to make sure there are no nested
77  * (reentrant) calls to them.
78  *
79  * Note that because there is a single `nonReentrant` guard, functions marked as
80  * `nonReentrant` may not call one another. This can be worked around by making
81  * those functions `private`, and then adding `external` `nonReentrant` entry
82  * points to them.
83  *
84  * TIP: If you would like to learn more about reentrancy and alternative ways
85  * to protect against it, check out our blog post
86  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
87  */
88 abstract contract ReentrancyGuard {
89     // Booleans are more expensive than uint256 or any type that takes up a full
90     // word because each write operation emits an extra SLOAD to first read the
91     // slot's contents, replace the bits taken up by the boolean, and then write
92     // back. This is the compiler's defense against contract upgrades and
93     // pointer aliasing, and it cannot be disabled.
94 
95     // The values being non-zero value makes deployment a bit more expensive,
96     // but in exchange the refund on every call to nonReentrant will be lower in
97     // amount. Since refunds are capped to a percentage of the total
98     // transaction's gas, it is best to keep them low in cases like this one, to
99     // increase the likelihood of the full refund coming into effect.
100     uint256 private constant _NOT_ENTERED = 1;
101     uint256 private constant _ENTERED = 2;
102 
103     uint256 private _status;
104 
105     constructor() {
106         _status = _NOT_ENTERED;
107     }
108 
109     /**
110      * @dev Prevents a contract from calling itself, directly or indirectly.
111      * Calling a `nonReentrant` function from another `nonReentrant`
112      * function is not supported. It is possible to prevent this from happening
113      * by making the `nonReentrant` function external, and make it call a
114      * `private` function that does the actual work.
115      */
116     modifier nonReentrant() {
117         // On the first call to nonReentrant, _notEntered will be true
118         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
119 
120         // Any calls to nonReentrant after this point will fail
121         _status = _ENTERED;
122 
123         _;
124 
125         // By storing the original value once again, a refund is triggered (see
126         // https://eips.ethereum.org/EIPS/eip-2200)
127         _status = _NOT_ENTERED;
128     }
129 }
130 
131 // File: @openzeppelin/contracts/utils/Address.sol
132 
133 
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Collection of functions related to the address type
139  */
140 library Address {
141     /**
142      * @dev Returns true if `account` is a contract.
143      *
144      * [IMPORTANT]
145      * ====
146      * It is unsafe to assume that an address for which this function returns
147      * false is an externally-owned account (EOA) and not a contract.
148      *
149      * Among others, `isContract` will return false for the following
150      * types of addresses:
151      *
152      *  - an externally-owned account
153      *  - a contract in construction
154      *  - an address where a contract will be created
155      *  - an address where a contract lived, but was destroyed
156      * ====
157      */
158     function isContract(address account) internal view returns (bool) {
159         // This method relies on extcodesize, which returns 0 for contracts in
160         // construction, since the code is only stored at the end of the
161         // constructor execution.
162 
163         uint256 size;
164         assembly {
165             size := extcodesize(account)
166         }
167         return size > 0;
168     }
169 
170     /**
171      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
172      * `recipient`, forwarding all available gas and reverting on errors.
173      *
174      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
175      * of certain opcodes, possibly making contracts go over the 2300 gas limit
176      * imposed by `transfer`, making them unable to receive funds via
177      * `transfer`. {sendValue} removes this limitation.
178      *
179      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
180      *
181      * IMPORTANT: because control is transferred to `recipient`, care must be
182      * taken to not create reentrancy vulnerabilities. Consider using
183      * {ReentrancyGuard} or the
184      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
185      */
186     function sendValue(address payable recipient, uint256 amount) internal {
187         require(address(this).balance >= amount, "Address: insufficient balance");
188 
189         (bool success, ) = recipient.call{value: amount}("");
190         require(success, "Address: unable to send value, recipient may have reverted");
191     }
192 
193     /**
194      * @dev Performs a Solidity function call using a low level `call`. A
195      * plain `call` is an unsafe replacement for a function call: use this
196      * function instead.
197      *
198      * If `target` reverts with a revert reason, it is bubbled up by this
199      * function (like regular Solidity function calls).
200      *
201      * Returns the raw returned data. To convert to the expected return value,
202      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
203      *
204      * Requirements:
205      *
206      * - `target` must be a contract.
207      * - calling `target` with `data` must not revert.
208      *
209      * _Available since v3.1._
210      */
211     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
212         return functionCall(target, data, "Address: low-level call failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
217      * `errorMessage` as a fallback revert reason when `target` reverts.
218      *
219      * _Available since v3.1._
220      */
221     function functionCall(
222         address target,
223         bytes memory data,
224         string memory errorMessage
225     ) internal returns (bytes memory) {
226         return functionCallWithValue(target, data, 0, errorMessage);
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
231      * but also transferring `value` wei to `target`.
232      *
233      * Requirements:
234      *
235      * - the calling contract must have an ETH balance of at least `value`.
236      * - the called Solidity function must be `payable`.
237      *
238      * _Available since v3.1._
239      */
240     function functionCallWithValue(
241         address target,
242         bytes memory data,
243         uint256 value
244     ) internal returns (bytes memory) {
245         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
250      * with `errorMessage` as a fallback revert reason when `target` reverts.
251      *
252      * _Available since v3.1._
253      */
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value,
258         string memory errorMessage
259     ) internal returns (bytes memory) {
260         require(address(this).balance >= value, "Address: insufficient balance for call");
261         require(isContract(target), "Address: call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.call{value: value}(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
269      * but performing a static call.
270      *
271      * _Available since v3.3._
272      */
273     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
274         return functionStaticCall(target, data, "Address: low-level static call failed");
275     }
276 
277     /**
278      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
279      * but performing a static call.
280      *
281      * _Available since v3.3._
282      */
283     function functionStaticCall(
284         address target,
285         bytes memory data,
286         string memory errorMessage
287     ) internal view returns (bytes memory) {
288         require(isContract(target), "Address: static call to non-contract");
289 
290         (bool success, bytes memory returndata) = target.staticcall(data);
291         return verifyCallResult(success, returndata, errorMessage);
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
296      * but performing a delegate call.
297      *
298      * _Available since v3.4._
299      */
300     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
301         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
306      * but performing a delegate call.
307      *
308      * _Available since v3.4._
309      */
310     function functionDelegateCall(
311         address target,
312         bytes memory data,
313         string memory errorMessage
314     ) internal returns (bytes memory) {
315         require(isContract(target), "Address: delegate call to non-contract");
316 
317         (bool success, bytes memory returndata) = target.delegatecall(data);
318         return verifyCallResult(success, returndata, errorMessage);
319     }
320 
321     /**
322      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
323      * revert reason using the provided one.
324      *
325      * _Available since v4.3._
326      */
327     function verifyCallResult(
328         bool success,
329         bytes memory returndata,
330         string memory errorMessage
331     ) internal pure returns (bytes memory) {
332         if (success) {
333             return returndata;
334         } else {
335             // Look for revert reason and bubble it up if present
336             if (returndata.length > 0) {
337                 // The easiest way to bubble the revert reason is using memory via assembly
338 
339                 assembly {
340                     let returndata_size := mload(returndata)
341                     revert(add(32, returndata), returndata_size)
342                 }
343             } else {
344                 revert(errorMessage);
345             }
346         }
347     }
348 }
349 
350 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
351 
352 
353 
354 pragma solidity ^0.8.0;
355 
356 /**
357  * @dev Interface of the ERC20 standard as defined in the EIP.
358  */
359 interface IERC20 {
360     /**
361      * @dev Returns the amount of tokens in existence.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     /**
366      * @dev Returns the amount of tokens owned by `account`.
367      */
368     function balanceOf(address account) external view returns (uint256);
369 
370     /**
371      * @dev Moves `amount` tokens from the caller's account to `recipient`.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transfer(address recipient, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Returns the remaining number of tokens that `spender` will be
381      * allowed to spend on behalf of `owner` through {transferFrom}. This is
382      * zero by default.
383      *
384      * This value changes when {approve} or {transferFrom} are called.
385      */
386     function allowance(address owner, address spender) external view returns (uint256);
387 
388     /**
389      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * IMPORTANT: Beware that changing an allowance with this method brings the risk
394      * that someone may use both the old and the new allowance by unfortunate
395      * transaction ordering. One possible solution to mitigate this race
396      * condition is to first reduce the spender's allowance to 0 and set the
397      * desired value afterwards:
398      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
399      *
400      * Emits an {Approval} event.
401      */
402     function approve(address spender, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Moves `amount` tokens from `sender` to `recipient` using the
406      * allowance mechanism. `amount` is then deducted from the caller's
407      * allowance.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(
414         address sender,
415         address recipient,
416         uint256 amount
417     ) external returns (bool);
418 
419     /**
420      * @dev Emitted when `value` tokens are moved from one account (`from`) to
421      * another (`to`).
422      *
423      * Note that `value` may be zero.
424      */
425     event Transfer(address indexed from, address indexed to, uint256 value);
426 
427     /**
428      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
429      * a call to {approve}. `value` is the new allowance.
430      */
431     event Approval(address indexed owner, address indexed spender, uint256 value);
432 }
433 
434 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
435 
436 
437 
438 pragma solidity ^0.8.0;
439 
440 
441 
442 /**
443  * @title SafeERC20
444  * @dev Wrappers around ERC20 operations that throw on failure (when the token
445  * contract returns false). Tokens that return no value (and instead revert or
446  * throw on failure) are also supported, non-reverting calls are assumed to be
447  * successful.
448  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
449  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
450  */
451 library SafeERC20 {
452     using Address for address;
453 
454     function safeTransfer(
455         IERC20 token,
456         address to,
457         uint256 value
458     ) internal {
459         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
460     }
461 
462     function safeTransferFrom(
463         IERC20 token,
464         address from,
465         address to,
466         uint256 value
467     ) internal {
468         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
469     }
470 
471     /**
472      * @dev Deprecated. This function has issues similar to the ones found in
473      * {IERC20-approve}, and its usage is discouraged.
474      *
475      * Whenever possible, use {safeIncreaseAllowance} and
476      * {safeDecreaseAllowance} instead.
477      */
478     function safeApprove(
479         IERC20 token,
480         address spender,
481         uint256 value
482     ) internal {
483         // safeApprove should only be called when setting an initial allowance,
484         // or when resetting it to zero. To increase and decrease it, use
485         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
486         require(
487             (value == 0) || (token.allowance(address(this), spender) == 0),
488             "SafeERC20: approve from non-zero to non-zero allowance"
489         );
490         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
491     }
492 
493     function safeIncreaseAllowance(
494         IERC20 token,
495         address spender,
496         uint256 value
497     ) internal {
498         uint256 newAllowance = token.allowance(address(this), spender) + value;
499         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
500     }
501 
502     function safeDecreaseAllowance(
503         IERC20 token,
504         address spender,
505         uint256 value
506     ) internal {
507         unchecked {
508             uint256 oldAllowance = token.allowance(address(this), spender);
509             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
510             uint256 newAllowance = oldAllowance - value;
511             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
512         }
513     }
514 
515     /**
516      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
517      * on the return value: the return value is optional (but if data is returned, it must not be false).
518      * @param token The token targeted by the call.
519      * @param data The call data (encoded using abi.encode or one of its variants).
520      */
521     function _callOptionalReturn(IERC20 token, bytes memory data) private {
522         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
523         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
524         // the target address contains contract code and also asserts for success in the low-level call.
525 
526         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
527         if (returndata.length > 0) {
528             // Return data is optional
529             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
530         }
531     }
532 }
533 
534 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
535 
536 
537 
538 pragma solidity ^0.8.0;
539 
540 // CAUTION
541 // This version of SafeMath should only be used with Solidity 0.8 or later,
542 // because it relies on the compiler's built in overflow checks.
543 
544 /**
545  * @dev Wrappers over Solidity's arithmetic operations.
546  *
547  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
548  * now has built in overflow checking.
549  */
550 library SafeMath {
551     /**
552      * @dev Returns the addition of two unsigned integers, with an overflow flag.
553      *
554      * _Available since v3.4._
555      */
556     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
557         unchecked {
558             uint256 c = a + b;
559             if (c < a) return (false, 0);
560             return (true, c);
561         }
562     }
563 
564     /**
565      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
566      *
567      * _Available since v3.4._
568      */
569     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
570         unchecked {
571             if (b > a) return (false, 0);
572             return (true, a - b);
573         }
574     }
575 
576     /**
577      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
578      *
579      * _Available since v3.4._
580      */
581     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
582         unchecked {
583             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
584             // benefit is lost if 'b' is also tested.
585             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
586             if (a == 0) return (true, 0);
587             uint256 c = a * b;
588             if (c / a != b) return (false, 0);
589             return (true, c);
590         }
591     }
592 
593     /**
594      * @dev Returns the division of two unsigned integers, with a division by zero flag.
595      *
596      * _Available since v3.4._
597      */
598     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
599         unchecked {
600             if (b == 0) return (false, 0);
601             return (true, a / b);
602         }
603     }
604 
605     /**
606      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
607      *
608      * _Available since v3.4._
609      */
610     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
611         unchecked {
612             if (b == 0) return (false, 0);
613             return (true, a % b);
614         }
615     }
616 
617     /**
618      * @dev Returns the addition of two unsigned integers, reverting on
619      * overflow.
620      *
621      * Counterpart to Solidity's `+` operator.
622      *
623      * Requirements:
624      *
625      * - Addition cannot overflow.
626      */
627     function add(uint256 a, uint256 b) internal pure returns (uint256) {
628         return a + b;
629     }
630 
631     /**
632      * @dev Returns the subtraction of two unsigned integers, reverting on
633      * overflow (when the result is negative).
634      *
635      * Counterpart to Solidity's `-` operator.
636      *
637      * Requirements:
638      *
639      * - Subtraction cannot overflow.
640      */
641     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
642         return a - b;
643     }
644 
645     /**
646      * @dev Returns the multiplication of two unsigned integers, reverting on
647      * overflow.
648      *
649      * Counterpart to Solidity's `*` operator.
650      *
651      * Requirements:
652      *
653      * - Multiplication cannot overflow.
654      */
655     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
656         return a * b;
657     }
658 
659     /**
660      * @dev Returns the integer division of two unsigned integers, reverting on
661      * division by zero. The result is rounded towards zero.
662      *
663      * Counterpart to Solidity's `/` operator.
664      *
665      * Requirements:
666      *
667      * - The divisor cannot be zero.
668      */
669     function div(uint256 a, uint256 b) internal pure returns (uint256) {
670         return a / b;
671     }
672 
673     /**
674      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
675      * reverting when dividing by zero.
676      *
677      * Counterpart to Solidity's `%` operator. This function uses a `revert`
678      * opcode (which leaves remaining gas untouched) while Solidity uses an
679      * invalid opcode to revert (consuming all remaining gas).
680      *
681      * Requirements:
682      *
683      * - The divisor cannot be zero.
684      */
685     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
686         return a % b;
687     }
688 
689     /**
690      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
691      * overflow (when the result is negative).
692      *
693      * CAUTION: This function is deprecated because it requires allocating memory for the error
694      * message unnecessarily. For custom revert reasons use {trySub}.
695      *
696      * Counterpart to Solidity's `-` operator.
697      *
698      * Requirements:
699      *
700      * - Subtraction cannot overflow.
701      */
702     function sub(
703         uint256 a,
704         uint256 b,
705         string memory errorMessage
706     ) internal pure returns (uint256) {
707         unchecked {
708             require(b <= a, errorMessage);
709             return a - b;
710         }
711     }
712 
713     /**
714      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
715      * division by zero. The result is rounded towards zero.
716      *
717      * Counterpart to Solidity's `/` operator. Note: this function uses a
718      * `revert` opcode (which leaves remaining gas untouched) while Solidity
719      * uses an invalid opcode to revert (consuming all remaining gas).
720      *
721      * Requirements:
722      *
723      * - The divisor cannot be zero.
724      */
725     function div(
726         uint256 a,
727         uint256 b,
728         string memory errorMessage
729     ) internal pure returns (uint256) {
730         unchecked {
731             require(b > 0, errorMessage);
732             return a / b;
733         }
734     }
735 
736     /**
737      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
738      * reverting with custom message when dividing by zero.
739      *
740      * CAUTION: This function is deprecated because it requires allocating memory for the error
741      * message unnecessarily. For custom revert reasons use {tryMod}.
742      *
743      * Counterpart to Solidity's `%` operator. This function uses a `revert`
744      * opcode (which leaves remaining gas untouched) while Solidity uses an
745      * invalid opcode to revert (consuming all remaining gas).
746      *
747      * Requirements:
748      *
749      * - The divisor cannot be zero.
750      */
751     function mod(
752         uint256 a,
753         uint256 b,
754         string memory errorMessage
755     ) internal pure returns (uint256) {
756         unchecked {
757             require(b > 0, errorMessage);
758             return a % b;
759         }
760     }
761 }
762 
763 // File: @openzeppelin/contracts/utils/math/Math.sol
764 
765 
766 
767 pragma solidity ^0.8.0;
768 
769 /**
770  * @dev Standard math utilities missing in the Solidity language.
771  */
772 library Math {
773     /**
774      * @dev Returns the largest of two numbers.
775      */
776     function max(uint256 a, uint256 b) internal pure returns (uint256) {
777         return a >= b ? a : b;
778     }
779 
780     /**
781      * @dev Returns the smallest of two numbers.
782      */
783     function min(uint256 a, uint256 b) internal pure returns (uint256) {
784         return a < b ? a : b;
785     }
786 
787     /**
788      * @dev Returns the average of two numbers. The result is rounded towards
789      * zero.
790      */
791     function average(uint256 a, uint256 b) internal pure returns (uint256) {
792         // (a + b) / 2 can overflow.
793         return (a & b) + (a ^ b) / 2;
794     }
795 
796     /**
797      * @dev Returns the ceiling of the division of two numbers.
798      *
799      * This differs from standard division with `/` in that it rounds up instead
800      * of rounding down.
801      */
802     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
803         // (a + b - 1) / b can overflow on addition, so we distribute.
804         return a / b + (a % b == 0 ? 0 : 1);
805     }
806 }
807 
808 // File: contracts/StakingRewards.sol
809 
810 
811 
812 pragma solidity 0.8.6;
813 
814 
815 
816 
817 
818 
819 
820 
821 contract StakingRewards is IStakingRewards, RewardsRecipient, ReentrancyGuard {
822     using SafeMath for uint256;
823     using SafeERC20 for IERC20;
824 
825     /* ========== EVENTS ========== */
826 
827     event RewardAdded(address indexed rewardToken, uint256 amount);
828     event Staked(address indexed user, uint256 amount);
829     event Unstaked(address indexed user, uint256 amount);
830     event RewardPaid(address indexed user, address indexed rewardToken, uint256 amount);
831 
832     /* ========== STATE VARIABLES ========== */
833 
834     address public owner;
835     IERC20 public stakingToken;
836     uint256 public lastUpdateTime;
837     uint256 public periodFinish;
838     uint256 public rewardsDuration;
839 
840     IERC20[2] public rewardTokens;
841     uint256[2] public rewardRate;
842     uint256[2] public rewardPerTokenStored;
843     mapping(address => uint256)[2] public userRewardPerTokenPaid;
844     mapping(address => uint256)[2] public unclaimedRewards;
845 
846     uint256 private _totalSupply;
847     mapping(address => uint256) private _balances;
848 
849     /* ========== CONSTRUCTOR ========== */
850 
851     constructor(
852         address _stakingToken,
853         address _rewardsDistributor,
854         address _varenToken,
855         address _extraRewardToken, // optional
856         uint256 _rewardsDuration,
857         address _owner
858     ) {
859         require(
860             _rewardsDistributor != address(0) &&
861                 _varenToken != address(0) &&
862                 _stakingToken != address(0),
863             "address(0)"
864         );
865         require(_rewardsDuration > 0, "rewardsDuration=0");
866         rewardsDistributor = _rewardsDistributor;
867         rewardTokens[0] = IERC20(_varenToken);
868         rewardTokens[1] = IERC20(_extraRewardToken);
869         stakingToken = IERC20(_stakingToken);
870         rewardsDuration = _rewardsDuration;
871         owner = _owner;
872     }
873 
874     /* ========== MODIFIERS ========== */
875 
876     modifier updateReward(address account) {
877         rewardPerTokenStored[0] = rewardPerToken(0);
878         if (address(rewardTokens[1]) != address(0)) rewardPerTokenStored[1] = rewardPerToken(1);
879         lastUpdateTime = lastTimeRewardApplicable();
880         if (account != address(0)) {
881             unclaimedRewards[0][account] = earned(account, 0);
882             unclaimedRewards[1][account] = earned(account, 1);
883             userRewardPerTokenPaid[0][account] = rewardPerTokenStored[0];
884             userRewardPerTokenPaid[1][account] = rewardPerTokenStored[1];
885         }
886         _;
887     }
888 
889     /* ========== VIEWS ========== */
890 
891     function totalSupply() external view override returns (uint256) {
892         return _totalSupply;
893     }
894 
895     function balanceOf(address account) external view override returns (uint256) {
896         return _balances[account];
897     }
898 
899     function getRewardForDuration(uint256 rewardTokenIndex) external view override returns (uint256) {
900         return rewardRate[rewardTokenIndex].mul(rewardsDuration);
901     }
902 
903     function lastTimeRewardApplicable() public view override returns (uint256) {
904         return Math.min(block.timestamp, periodFinish);
905     }
906 
907     function rewardPerToken(uint256 rewardTokenIndex) public view override returns (uint256) {
908         if (_totalSupply == 0) {
909             return rewardPerTokenStored[rewardTokenIndex];
910         }
911         return
912             rewardPerTokenStored[rewardTokenIndex].add(
913                 lastTimeRewardApplicable()
914                     .sub(lastUpdateTime)
915                     .mul(rewardRate[rewardTokenIndex])
916                     .mul(1e18)
917                     .div(_totalSupply)
918             );
919     }
920 
921     function earned(address account, uint256 rewardTokenIndex) public view override returns (uint256) {
922         return
923             _balances[account]
924                 .mul(
925                 rewardPerToken(rewardTokenIndex).sub(
926                     userRewardPerTokenPaid[rewardTokenIndex][account]
927                 )
928             )
929                 .div(1e18)
930                 .add(unclaimedRewards[rewardTokenIndex][account]);
931     }
932 
933     /* ========== MUTATIVE FUNCTIONS ========== */
934 
935     function stakeWithPermit(
936         uint256 amount,
937         uint256 deadline,
938         uint8 v,
939         bytes32 r,
940         bytes32 s
941     ) external nonReentrant updateReward(msg.sender) {
942         require(amount > 0, "Cannot stake 0");
943         _totalSupply = _totalSupply.add(amount);
944         _balances[msg.sender] = _balances[msg.sender].add(amount);
945         ILinkswapERC20(address(stakingToken)).permit(
946             msg.sender,
947             address(this),
948             amount,
949             deadline,
950             v,
951             r,
952             s
953         );
954         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
955         emit Staked(msg.sender, amount);
956     }
957 
958     function stake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
959         _stake(amount);
960     }
961 
962     function unstakeAndClaimRewards(uint256 unstakeAmount)
963         external override
964         nonReentrant
965         updateReward(msg.sender)
966     {
967         _unstake(unstakeAmount);
968         _claimReward(0);
969         _claimReward(1);
970     }
971 
972     // Unstake without claiming rewards. For emergency use if claiming rewards is failing.
973     function unstake(uint256 amount) external override nonReentrant updateReward(msg.sender) {
974         _unstake(amount);
975     }
976 
977     // Sends to the caller any unclaimed rewards earned by the caller.
978     function claimRewards() external override nonReentrant updateReward(msg.sender) {
979         _claimReward(0);
980         _claimReward(1);
981     }
982 
983     /* ========== PRIVATE FUNCTIONS ========== */
984 
985     function _stake(uint256 amount) private {
986         require(amount > 0, "Cannot stake 0");
987         _totalSupply = _totalSupply.add(amount);
988         _balances[msg.sender] = _balances[msg.sender].add(amount);
989         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
990         emit Staked(msg.sender, amount);
991     }
992 
993     function _unstake(uint256 amount) private {
994         require(amount > 0, "Cannot unstake 0");
995         _totalSupply = _totalSupply.sub(amount);
996         _balances[msg.sender] = _balances[msg.sender].sub(amount);
997         stakingToken.safeTransfer(msg.sender, amount);
998         emit Unstaked(msg.sender, amount);
999     }
1000 
1001     function _claimReward(uint256 rewardTokenIndex) private {
1002         uint256 rewardAmount = unclaimedRewards[rewardTokenIndex][msg.sender];
1003         if (rewardAmount > 0) {
1004             uint256 rewardsBal = rewardTokens[rewardTokenIndex].balanceOf(address(this));
1005             if (rewardsBal == 0) return;
1006             // avoid paying more than total rewards balance
1007             rewardAmount = rewardsBal < rewardAmount ? rewardsBal : rewardAmount;
1008             unclaimedRewards[rewardTokenIndex][msg.sender] = unclaimedRewards[rewardTokenIndex][msg
1009                 .sender]
1010                 .sub(rewardAmount);
1011             rewardTokens[rewardTokenIndex].safeTransfer(msg.sender, rewardAmount);
1012             emit RewardPaid(msg.sender, address(rewardTokens[rewardTokenIndex]), rewardAmount);
1013         }
1014     }
1015 
1016     /* ========== RESTRICTED FUNCTIONS ========== */
1017 
1018     function notifyRewardAmount(uint256 amount, uint256 extraAmount)
1019         external override
1020         onlyRewardsDistributor
1021         updateReward(address(0))
1022     {
1023         require(amount > 0 || extraAmount > 0, "zero amount");
1024         if (extraAmount > 0) {
1025             require(address(rewardTokens[1]) != address(0), "extraRewardToken=0x0");
1026         }
1027         if (block.timestamp >= periodFinish) {
1028             rewardRate[0] = amount.div(rewardsDuration);
1029             if (extraAmount > 0) rewardRate[1] = extraAmount.div(rewardsDuration);
1030         } else {
1031             uint256 remaining = periodFinish.sub(block.timestamp);
1032             uint256 leftover = remaining.mul(rewardRate[0]);
1033             rewardRate[0] = amount.add(leftover).div(rewardsDuration);
1034             if (extraAmount > 0) {
1035                 leftover = remaining.mul(rewardRate[1]);
1036                 rewardRate[1] = extraAmount.add(leftover).div(rewardsDuration);
1037             }
1038         }
1039 
1040         // Ensure the provided reward amount is not more than the balance in the contract.
1041         // This keeps the reward rate in the right range, preventing overflows due to
1042         // very high values of rewardRate in the earned and rewardsPerToken functions;
1043         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1044         uint256 balance = rewardTokens[0].balanceOf(address(this));
1045         require(rewardRate[0] <= balance.div(rewardsDuration), "Provided reward too high");
1046         if (extraAmount > 0) {
1047             balance = rewardTokens[1].balanceOf(address(this));
1048             require(
1049                 rewardRate[1] <= balance.div(rewardsDuration),
1050                 "Provided extra reward too high"
1051             );
1052         }
1053 
1054         lastUpdateTime = block.timestamp;
1055         periodFinish = block.timestamp.add(rewardsDuration);
1056         emit RewardAdded(address(rewardTokens[0]), amount);
1057         if (extraAmount > 0) emit RewardAdded(address(rewardTokens[1]), extraAmount);
1058     }
1059 }