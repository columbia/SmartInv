1 /**
2 
3 ██████╗  ██████╗ ██╗     ██╗  ██╗ █████╗ ███████╗██╗  ██╗
4 ██╔══██╗██╔═══██╗██║     ██║ ██╔╝██╔══██╗██╔════╝╚██╗██╔╝
5 ██████╔╝██║   ██║██║     █████╔╝ ███████║█████╗   ╚███╔╝
6 ██╔═══╝ ██║   ██║██║     ██╔═██╗ ██╔══██║██╔══╝   ██╔██╗
7 ██║     ╚██████╔╝███████╗██║  ██╗██║  ██║███████╗██╔╝ ██╗
8 ╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝  ╚═╝
9 
10                      www.polkaex.io
11 
12 */
13 // Sources flattened with hardhat v2.6.2 https://hardhat.org
14 
15 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.3.1
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Contract module that helps prevent reentrant calls to a function.
23  *
24  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
25  * available, which can be applied to functions to make sure there are no nested
26  * (reentrant) calls to them.
27  *
28  * Note that because there is a single `nonReentrant` guard, functions marked as
29  * `nonReentrant` may not call one another. This can be worked around by making
30  * those functions `private`, and then adding `external` `nonReentrant` entry
31  * points to them.
32  *
33  * TIP: If you would like to learn more about reentrancy and alternative ways
34  * to protect against it, check out our blog post
35  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
36  */
37 abstract contract ReentrancyGuard {
38     // Booleans are more expensive than uint256 or any type that takes up a full
39     // word because each write operation emits an extra SLOAD to first read the
40     // slot's contents, replace the bits taken up by the boolean, and then write
41     // back. This is the compiler's defense against contract upgrades and
42     // pointer aliasing, and it cannot be disabled.
43 
44     // The values being non-zero value makes deployment a bit more expensive,
45     // but in exchange the refund on every call to nonReentrant will be lower in
46     // amount. Since refunds are capped to a percentage of the total
47     // transaction's gas, it is best to keep them low in cases like this one, to
48     // increase the likelihood of the full refund coming into effect.
49     uint256 private constant _NOT_ENTERED = 1;
50     uint256 private constant _ENTERED = 2;
51 
52     uint256 private _status;
53 
54     constructor() {
55         _status = _NOT_ENTERED;
56     }
57 
58     /**
59      * @dev Prevents a contract from calling itself, directly or indirectly.
60      * Calling a `nonReentrant` function from another `nonReentrant`
61      * function is not supported. It is possible to prevent this from happening
62      * by making the `nonReentrant` function external, and make it call a
63      * `private` function that does the actual work.
64      */
65     modifier nonReentrant() {
66         // On the first call to nonReentrant, _notEntered will be true
67         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
68 
69         // Any calls to nonReentrant after this point will fail
70         _status = _ENTERED;
71 
72         _;
73 
74         // By storing the original value once again, a refund is triggered (see
75         // https://eips.ethereum.org/EIPS/eip-2200)
76         _status = _NOT_ENTERED;
77     }
78 }
79 
80 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.3.1
81 
82 pragma solidity ^0.8.0;
83 
84 // CAUTION
85 // This version of SafeMath should only be used with Solidity 0.8 or later,
86 // because it relies on the compiler's built in overflow checks.
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations.
90  *
91  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
92  * now has built in overflow checking.
93  */
94 library SafeMath {
95     /**
96      * @dev Returns the addition of two unsigned integers, with an overflow flag.
97      *
98      * _Available since v3.4._
99      */
100     function tryAdd(uint256 a, uint256 b)
101         internal
102         pure
103         returns (bool, uint256)
104     {
105         unchecked {
106             uint256 c = a + b;
107             if (c < a) return (false, 0);
108             return (true, c);
109         }
110     }
111 
112     /**
113      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
114      *
115      * _Available since v3.4._
116      */
117     function trySub(uint256 a, uint256 b)
118         internal
119         pure
120         returns (bool, uint256)
121     {
122         unchecked {
123             if (b > a) return (false, 0);
124             return (true, a - b);
125         }
126     }
127 
128     /**
129      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryMul(uint256 a, uint256 b)
134         internal
135         pure
136         returns (bool, uint256)
137     {
138         unchecked {
139             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
140             // benefit is lost if 'b' is also tested.
141             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
142             if (a == 0) return (true, 0);
143             uint256 c = a * b;
144             if (c / a != b) return (false, 0);
145             return (true, c);
146         }
147     }
148 
149     /**
150      * @dev Returns the division of two unsigned integers, with a division by zero flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryDiv(uint256 a, uint256 b)
155         internal
156         pure
157         returns (bool, uint256)
158     {
159         unchecked {
160             if (b == 0) return (false, 0);
161             return (true, a / b);
162         }
163     }
164 
165     /**
166      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
167      *
168      * _Available since v3.4._
169      */
170     function tryMod(uint256 a, uint256 b)
171         internal
172         pure
173         returns (bool, uint256)
174     {
175         unchecked {
176             if (b == 0) return (false, 0);
177             return (true, a % b);
178         }
179     }
180 
181     /**
182      * @dev Returns the addition of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `+` operator.
186      *
187      * Requirements:
188      *
189      * - Addition cannot overflow.
190      */
191     function add(uint256 a, uint256 b) internal pure returns (uint256) {
192         return a + b;
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting on
197      * overflow (when the result is negative).
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
206         return a - b;
207     }
208 
209     /**
210      * @dev Returns the multiplication of two unsigned integers, reverting on
211      * overflow.
212      *
213      * Counterpart to Solidity's `*` operator.
214      *
215      * Requirements:
216      *
217      * - Multiplication cannot overflow.
218      */
219     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a * b;
221     }
222 
223     /**
224      * @dev Returns the integer division of two unsigned integers, reverting on
225      * division by zero. The result is rounded towards zero.
226      *
227      * Counterpart to Solidity's `/` operator.
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         return a / b;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * reverting when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         return a % b;
251     }
252 
253     /**
254      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
255      * overflow (when the result is negative).
256      *
257      * CAUTION: This function is deprecated because it requires allocating memory for the error
258      * message unnecessarily. For custom revert reasons use {trySub}.
259      *
260      * Counterpart to Solidity's `-` operator.
261      *
262      * Requirements:
263      *
264      * - Subtraction cannot overflow.
265      */
266     function sub(
267         uint256 a,
268         uint256 b,
269         string memory errorMessage
270     ) internal pure returns (uint256) {
271         unchecked {
272             require(b <= a, errorMessage);
273             return a - b;
274         }
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(
290         uint256 a,
291         uint256 b,
292         string memory errorMessage
293     ) internal pure returns (uint256) {
294         unchecked {
295             require(b > 0, errorMessage);
296             return a / b;
297         }
298     }
299 
300     /**
301      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
302      * reverting with custom message when dividing by zero.
303      *
304      * CAUTION: This function is deprecated because it requires allocating memory for the error
305      * message unnecessarily. For custom revert reasons use {tryMod}.
306      *
307      * Counterpart to Solidity's `%` operator. This function uses a `revert`
308      * opcode (which leaves remaining gas untouched) while Solidity uses an
309      * invalid opcode to revert (consuming all remaining gas).
310      *
311      * Requirements:
312      *
313      * - The divisor cannot be zero.
314      */
315     function mod(
316         uint256 a,
317         uint256 b,
318         string memory errorMessage
319     ) internal pure returns (uint256) {
320         unchecked {
321             require(b > 0, errorMessage);
322             return a % b;
323         }
324     }
325 }
326 
327 // File @openzeppelin/contracts/utils/math/Math.sol@v4.3.1
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Standard math utilities missing in the Solidity language.
333  */
334 library Math {
335     /**
336      * @dev Returns the largest of two numbers.
337      */
338     function max(uint256 a, uint256 b) internal pure returns (uint256) {
339         return a >= b ? a : b;
340     }
341 
342     /**
343      * @dev Returns the smallest of two numbers.
344      */
345     function min(uint256 a, uint256 b) internal pure returns (uint256) {
346         return a < b ? a : b;
347     }
348 
349     /**
350      * @dev Returns the average of two numbers. The result is rounded towards
351      * zero.
352      */
353     function average(uint256 a, uint256 b) internal pure returns (uint256) {
354         // (a + b) / 2 can overflow.
355         return (a & b) + (a ^ b) / 2;
356     }
357 
358     /**
359      * @dev Returns the ceiling of the division of two numbers.
360      *
361      * This differs from standard division with `/` in that it rounds up instead
362      * of rounding down.
363      */
364     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
365         // (a + b - 1) / b can overflow on addition, so we distribute.
366         return a / b + (a % b == 0 ? 0 : 1);
367     }
368 }
369 
370 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.3.1
371 
372 pragma solidity ^0.8.0;
373 
374 /**
375  * @dev Interface of the ERC20 standard as defined in the EIP.
376  */
377 interface IERC20 {
378     /**
379      * @dev Returns the amount of tokens in existence.
380      */
381     function totalSupply() external view returns (uint256);
382 
383     /**
384      * @dev Returns the amount of tokens owned by `account`.
385      */
386     function balanceOf(address account) external view returns (uint256);
387 
388     /**
389      * @dev Moves `amount` tokens from the caller's account to `recipient`.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * Emits a {Transfer} event.
394      */
395     function transfer(address recipient, uint256 amount)
396         external
397         returns (bool);
398 
399     /**
400      * @dev Returns the remaining number of tokens that `spender` will be
401      * allowed to spend on behalf of `owner` through {transferFrom}. This is
402      * zero by default.
403      *
404      * This value changes when {approve} or {transferFrom} are called.
405      */
406     function allowance(address owner, address spender)
407         external
408         view
409         returns (uint256);
410 
411     /**
412      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
413      *
414      * Returns a boolean value indicating whether the operation succeeded.
415      *
416      * IMPORTANT: Beware that changing an allowance with this method brings the risk
417      * that someone may use both the old and the new allowance by unfortunate
418      * transaction ordering. One possible solution to mitigate this race
419      * condition is to first reduce the spender's allowance to 0 and set the
420      * desired value afterwards:
421      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
422      *
423      * Emits an {Approval} event.
424      */
425     function approve(address spender, uint256 amount) external returns (bool);
426 
427     /**
428      * @dev Moves `amount` tokens from `sender` to `recipient` using the
429      * allowance mechanism. `amount` is then deducted from the caller's
430      * allowance.
431      *
432      * Returns a boolean value indicating whether the operation succeeded.
433      *
434      * Emits a {Transfer} event.
435      */
436     function transferFrom(
437         address sender,
438         address recipient,
439         uint256 amount
440     ) external returns (bool);
441 
442     /**
443      * @dev Emitted when `value` tokens are moved from one account (`from`) to
444      * another (`to`).
445      *
446      * Note that `value` may be zero.
447      */
448     event Transfer(address indexed from, address indexed to, uint256 value);
449 
450     /**
451      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
452      * a call to {approve}. `value` is the new allowance.
453      */
454     event Approval(
455         address indexed owner,
456         address indexed spender,
457         uint256 value
458     );
459 }
460 
461 // File @openzeppelin/contracts/utils/Address.sol@v4.3.1
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Collection of functions related to the address type
467  */
468 library Address {
469     /**
470      * @dev Returns true if `account` is a contract.
471      *
472      * [IMPORTANT]
473      * ====
474      * It is unsafe to assume that an address for which this function returns
475      * false is an externally-owned account (EOA) and not a contract.
476      *
477      * Among others, `isContract` will return false for the following
478      * types of addresses:
479      *
480      *  - an externally-owned account
481      *  - a contract in construction
482      *  - an address where a contract will be created
483      *  - an address where a contract lived, but was destroyed
484      * ====
485      */
486     function isContract(address account) internal view returns (bool) {
487         // This method relies on extcodesize, which returns 0 for contracts in
488         // construction, since the code is only stored at the end of the
489         // constructor execution.
490 
491         uint256 size;
492         assembly {
493             size := extcodesize(account)
494         }
495         return size > 0;
496     }
497 
498     /**
499      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
500      * `recipient`, forwarding all available gas and reverting on errors.
501      *
502      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
503      * of certain opcodes, possibly making contracts go over the 2300 gas limit
504      * imposed by `transfer`, making them unable to receive funds via
505      * `transfer`. {sendValue} removes this limitation.
506      *
507      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
508      *
509      * IMPORTANT: because control is transferred to `recipient`, care must be
510      * taken to not create reentrancy vulnerabilities. Consider using
511      * {ReentrancyGuard} or the
512      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
513      */
514     function sendValue(address payable recipient, uint256 amount) internal {
515         require(
516             address(this).balance >= amount,
517             "Address: insufficient balance"
518         );
519 
520         (bool success, ) = recipient.call{value: amount}("");
521         require(
522             success,
523             "Address: unable to send value, recipient may have reverted"
524         );
525     }
526 
527     /**
528      * @dev Performs a Solidity function call using a low level `call`. A
529      * plain `call` is an unsafe replacement for a function call: use this
530      * function instead.
531      *
532      * If `target` reverts with a revert reason, it is bubbled up by this
533      * function (like regular Solidity function calls).
534      *
535      * Returns the raw returned data. To convert to the expected return value,
536      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
537      *
538      * Requirements:
539      *
540      * - `target` must be a contract.
541      * - calling `target` with `data` must not revert.
542      *
543      * _Available since v3.1._
544      */
545     function functionCall(address target, bytes memory data)
546         internal
547         returns (bytes memory)
548     {
549         return functionCall(target, data, "Address: low-level call failed");
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
554      * `errorMessage` as a fallback revert reason when `target` reverts.
555      *
556      * _Available since v3.1._
557      */
558     function functionCall(
559         address target,
560         bytes memory data,
561         string memory errorMessage
562     ) internal returns (bytes memory) {
563         return functionCallWithValue(target, data, 0, errorMessage);
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
568      * but also transferring `value` wei to `target`.
569      *
570      * Requirements:
571      *
572      * - the calling contract must have an ETH balance of at least `value`.
573      * - the called Solidity function must be `payable`.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(
578         address target,
579         bytes memory data,
580         uint256 value
581     ) internal returns (bytes memory) {
582         return
583             functionCallWithValue(
584                 target,
585                 data,
586                 value,
587                 "Address: low-level call with value failed"
588             );
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
593      * with `errorMessage` as a fallback revert reason when `target` reverts.
594      *
595      * _Available since v3.1._
596      */
597     function functionCallWithValue(
598         address target,
599         bytes memory data,
600         uint256 value,
601         string memory errorMessage
602     ) internal returns (bytes memory) {
603         require(
604             address(this).balance >= value,
605             "Address: insufficient balance for call"
606         );
607         require(isContract(target), "Address: call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.call{value: value}(
610             data
611         );
612         return verifyCallResult(success, returndata, errorMessage);
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
617      * but performing a static call.
618      *
619      * _Available since v3.3._
620      */
621     function functionStaticCall(address target, bytes memory data)
622         internal
623         view
624         returns (bytes memory)
625     {
626         return
627             functionStaticCall(
628                 target,
629                 data,
630                 "Address: low-level static call failed"
631             );
632     }
633 
634     /**
635      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
636      * but performing a static call.
637      *
638      * _Available since v3.3._
639      */
640     function functionStaticCall(
641         address target,
642         bytes memory data,
643         string memory errorMessage
644     ) internal view returns (bytes memory) {
645         require(isContract(target), "Address: static call to non-contract");
646 
647         (bool success, bytes memory returndata) = target.staticcall(data);
648         return verifyCallResult(success, returndata, errorMessage);
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
653      * but performing a delegate call.
654      *
655      * _Available since v3.4._
656      */
657     function functionDelegateCall(address target, bytes memory data)
658         internal
659         returns (bytes memory)
660     {
661         return
662             functionDelegateCall(
663                 target,
664                 data,
665                 "Address: low-level delegate call failed"
666             );
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
671      * but performing a delegate call.
672      *
673      * _Available since v3.4._
674      */
675     function functionDelegateCall(
676         address target,
677         bytes memory data,
678         string memory errorMessage
679     ) internal returns (bytes memory) {
680         require(isContract(target), "Address: delegate call to non-contract");
681 
682         (bool success, bytes memory returndata) = target.delegatecall(data);
683         return verifyCallResult(success, returndata, errorMessage);
684     }
685 
686     /**
687      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
688      * revert reason using the provided one.
689      *
690      * _Available since v4.3._
691      */
692     function verifyCallResult(
693         bool success,
694         bytes memory returndata,
695         string memory errorMessage
696     ) internal pure returns (bytes memory) {
697         if (success) {
698             return returndata;
699         } else {
700             // Look for revert reason and bubble it up if present
701             if (returndata.length > 0) {
702                 // The easiest way to bubble the revert reason is using memory via assembly
703 
704                 assembly {
705                     let returndata_size := mload(returndata)
706                     revert(add(32, returndata), returndata_size)
707                 }
708             } else {
709                 revert(errorMessage);
710             }
711         }
712     }
713 }
714 
715 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.3.1
716 
717 pragma solidity ^0.8.0;
718 
719 /**
720  * @title SafeERC20
721  * @dev Wrappers around ERC20 operations that throw on failure (when the token
722  * contract returns false). Tokens that return no value (and instead revert or
723  * throw on failure) are also supported, non-reverting calls are assumed to be
724  * successful.
725  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
726  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
727  */
728 library SafeERC20 {
729     using Address for address;
730 
731     function safeTransfer(
732         IERC20 token,
733         address to,
734         uint256 value
735     ) internal {
736         _callOptionalReturn(
737             token,
738             abi.encodeWithSelector(token.transfer.selector, to, value)
739         );
740     }
741 
742     function safeTransferFrom(
743         IERC20 token,
744         address from,
745         address to,
746         uint256 value
747     ) internal {
748         _callOptionalReturn(
749             token,
750             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
751         );
752     }
753 
754     /**
755      * @dev Deprecated. This function has issues similar to the ones found in
756      * {IERC20-approve}, and its usage is discouraged.
757      *
758      * Whenever possible, use {safeIncreaseAllowance} and
759      * {safeDecreaseAllowance} instead.
760      */
761     function safeApprove(
762         IERC20 token,
763         address spender,
764         uint256 value
765     ) internal {
766         // safeApprove should only be called when setting an initial allowance,
767         // or when resetting it to zero. To increase and decrease it, use
768         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
769         require(
770             (value == 0) || (token.allowance(address(this), spender) == 0),
771             "SafeERC20: approve from non-zero to non-zero allowance"
772         );
773         _callOptionalReturn(
774             token,
775             abi.encodeWithSelector(token.approve.selector, spender, value)
776         );
777     }
778 
779     function safeIncreaseAllowance(
780         IERC20 token,
781         address spender,
782         uint256 value
783     ) internal {
784         uint256 newAllowance = token.allowance(address(this), spender) + value;
785         _callOptionalReturn(
786             token,
787             abi.encodeWithSelector(
788                 token.approve.selector,
789                 spender,
790                 newAllowance
791             )
792         );
793     }
794 
795     function safeDecreaseAllowance(
796         IERC20 token,
797         address spender,
798         uint256 value
799     ) internal {
800         unchecked {
801             uint256 oldAllowance = token.allowance(address(this), spender);
802             require(
803                 oldAllowance >= value,
804                 "SafeERC20: decreased allowance below zero"
805             );
806             uint256 newAllowance = oldAllowance - value;
807             _callOptionalReturn(
808                 token,
809                 abi.encodeWithSelector(
810                     token.approve.selector,
811                     spender,
812                     newAllowance
813                 )
814             );
815         }
816     }
817 
818     /**
819      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
820      * on the return value: the return value is optional (but if data is returned, it must not be false).
821      * @param token The token targeted by the call.
822      * @param data The call data (encoded using abi.encode or one of its variants).
823      */
824     function _callOptionalReturn(IERC20 token, bytes memory data) private {
825         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
826         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
827         // the target address contains contract code and also asserts for success in the low-level call.
828 
829         bytes memory returndata = address(token).functionCall(
830             data,
831             "SafeERC20: low-level call failed"
832         );
833         if (returndata.length > 0) {
834             // Return data is optional
835             require(
836                 abi.decode(returndata, (bool)),
837                 "SafeERC20: ERC20 operation did not succeed"
838             );
839         }
840     }
841 }
842 
843 // File @openzeppelin/contracts/utils/Context.sol@v4.3.1
844 
845 pragma solidity ^0.8.0;
846 
847 /**
848  * @dev Provides information about the current execution context, including the
849  * sender of the transaction and its data. While these are generally available
850  * via msg.sender and msg.data, they should not be accessed in such a direct
851  * manner, since when dealing with meta-transactions the account sending and
852  * paying for execution may not be the actual sender (as far as an application
853  * is concerned).
854  *
855  * This contract is only required for intermediate, library-like contracts.
856  */
857 abstract contract Context {
858     function _msgSender() internal view virtual returns (address) {
859         return msg.sender;
860     }
861 
862     function _msgData() internal view virtual returns (bytes calldata) {
863         return msg.data;
864     }
865 }
866 
867 // File @openzeppelin/contracts/access/Ownable.sol@v4.3.1
868 
869 pragma solidity ^0.8.0;
870 
871 /**
872  * @dev Contract module which provides a basic access control mechanism, where
873  * there is an account (an owner) that can be granted exclusive access to
874  * specific functions.
875  *
876  * By default, the owner account will be the one that deploys the contract. This
877  * can later be changed with {transferOwnership}.
878  *
879  * This module is used through inheritance. It will make available the modifier
880  * `onlyOwner`, which can be applied to your functions to restrict their use to
881  * the owner.
882  */
883 abstract contract Ownable is Context {
884     address private _owner;
885 
886     event OwnershipTransferred(
887         address indexed previousOwner,
888         address indexed newOwner
889     );
890 
891     /**
892      * @dev Initializes the contract setting the deployer as the initial owner.
893      */
894     constructor() {
895         _setOwner(_msgSender());
896     }
897 
898     /**
899      * @dev Returns the address of the current owner.
900      */
901     function owner() public view virtual returns (address) {
902         return _owner;
903     }
904 
905     /**
906      * @dev Throws if called by any account other than the owner.
907      */
908     modifier onlyOwner() {
909         require(owner() == _msgSender(), "Ownable: caller is not the owner");
910         _;
911     }
912 
913     /**
914      * @dev Leaves the contract without owner. It will not be possible to call
915      * `onlyOwner` functions anymore. Can only be called by the current owner.
916      *
917      * NOTE: Renouncing ownership will leave the contract without an owner,
918      * thereby removing any functionality that is only available to the owner.
919      */
920     function renounceOwnership() public virtual onlyOwner {
921         _setOwner(address(0));
922     }
923 
924     /**
925      * @dev Transfers ownership of the contract to a new account (`newOwner`).
926      * Can only be called by the current owner.
927      */
928     function transferOwnership(address newOwner) public virtual onlyOwner {
929         require(
930             newOwner != address(0),
931             "Ownable: new owner is the zero address"
932         );
933         _setOwner(newOwner);
934     }
935 
936     function _setOwner(address newOwner) private {
937         address oldOwner = _owner;
938         _owner = newOwner;
939         emit OwnershipTransferred(oldOwner, newOwner);
940     }
941 }
942 
943 // File @openzeppelin/contracts/security/Pausable.sol@v4.3.1
944 
945 pragma solidity ^0.8.0;
946 
947 /**
948  * @dev Contract module which allows children to implement an emergency stop
949  * mechanism that can be triggered by an authorized account.
950  *
951  * This module is used through inheritance. It will make available the
952  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
953  * the functions of your contract. Note that they will not be pausable by
954  * simply including this module, only once the modifiers are put in place.
955  */
956 abstract contract Pausable is Context {
957     /**
958      * @dev Emitted when the pause is triggered by `account`.
959      */
960     event Paused(address account);
961 
962     /**
963      * @dev Emitted when the pause is lifted by `account`.
964      */
965     event Unpaused(address account);
966 
967     bool private _paused;
968 
969     /**
970      * @dev Initializes the contract in unpaused state.
971      */
972     constructor() {
973         _paused = false;
974     }
975 
976     /**
977      * @dev Returns true if the contract is paused, and false otherwise.
978      */
979     function paused() public view virtual returns (bool) {
980         return _paused;
981     }
982 
983     /**
984      * @dev Modifier to make a function callable only when the contract is not paused.
985      *
986      * Requirements:
987      *
988      * - The contract must not be paused.
989      */
990     modifier whenNotPaused() {
991         require(!paused(), "Pausable: paused");
992         _;
993     }
994 
995     /**
996      * @dev Modifier to make a function callable only when the contract is paused.
997      *
998      * Requirements:
999      *
1000      * - The contract must be paused.
1001      */
1002     modifier whenPaused() {
1003         require(paused(), "Pausable: not paused");
1004         _;
1005     }
1006 
1007     /**
1008      * @dev Triggers stopped state.
1009      *
1010      * Requirements:
1011      *
1012      * - The contract must not be paused.
1013      */
1014     function _pause() internal virtual whenNotPaused {
1015         _paused = true;
1016         emit Paused(_msgSender());
1017     }
1018 
1019     /**
1020      * @dev Returns to normal state.
1021      *
1022      * Requirements:
1023      *
1024      * - The contract must be paused.
1025      */
1026     function _unpause() internal virtual whenPaused {
1027         _paused = false;
1028         emit Unpaused(_msgSender());
1029     }
1030 }
1031 
1032 // File contracts/FarmAdditions.sol
1033 
1034 pragma solidity 0.8.0;
1035 pragma experimental ABIEncoderV2;
1036 
1037 abstract contract PkexFarm {
1038     mapping(address => uint256) public unstakeTime;
1039     mapping(address => uint256) public rewards;
1040 
1041     function balanceOf(address account) external view virtual returns (uint256);
1042 }
1043 
1044 contract PkexFarmAdditional is ReentrancyGuard, Pausable, Ownable {
1045     using SafeMath for uint256;
1046     using SafeERC20 for IERC20;
1047 
1048     PkexFarm public immutable prevFarm;
1049     IERC20 public immutable rewardsToken;
1050     address public immutable dev;
1051     mapping(address => mapping(uint256 => uint256)) public userRewarded;
1052 
1053     constructor(
1054         address _prevFarm,
1055         address _rewardsToken,
1056         address _dev
1057     ) {
1058         require(_prevFarm != address(0), "Prev farm address can't be zero");
1059         require(_dev != address(0), "Dev wallet can't be zero");
1060         prevFarm = PkexFarm(_prevFarm);
1061         rewardsToken = IERC20(_rewardsToken);
1062         dev = _dev;
1063     }
1064 
1065     function claim() external whenNotPaused nonReentrant {
1066         uint256 unstakeTime = prevFarm.unstakeTime(_msgSender());
1067         require(block.timestamp >= unstakeTime, "still in waiting period");
1068         require(
1069             prevFarm.balanceOf(_msgSender()) == 0,
1070             "You have not unstaked yet"
1071         );
1072 
1073         uint256 reward = prevFarm.rewards(msg.sender).sub(
1074             userRewarded[msg.sender][unstakeTime]
1075         );
1076         require(reward > 0, "No rewards");
1077         userRewarded[msg.sender][unstakeTime] = userRewarded[msg.sender][
1078             unstakeTime
1079         ].add(reward);
1080 
1081         safeTransferRewardsTokenTo(msg.sender, reward);
1082         emit RewardPaid(msg.sender, reward);
1083     }
1084 
1085     function pause() external whenNotPaused onlyOwner {
1086         _pause();
1087     }
1088 
1089     function unpause() external whenPaused onlyOwner {
1090         _unpause();
1091     }
1092 
1093     function safeTransferRewardsTokenTo(address to, uint256 amount) private {
1094         uint256 balance = rewardsToken.balanceOf(dev);
1095         if (balance >= amount) rewardsToken.safeTransferFrom(dev, to, amount);
1096         else rewardsToken.safeTransferFrom(dev, to, balance);
1097     }
1098 
1099     event RewardPaid(address indexed user, uint256 reward);
1100 }