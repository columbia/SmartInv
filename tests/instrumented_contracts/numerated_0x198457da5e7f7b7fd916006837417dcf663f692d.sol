1 // Sources flattened with hardhat v2.2.0 https://hardhat.org
2 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.0.0
3 
4 // SPDX-License-Identifier: MIT
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Emitted when `value` tokens are moved from one account (`from`) to
69      * another (`to`).
70      *
71      * Note that `value` may be zero.
72      */
73     event Transfer(address indexed from, address indexed to, uint256 value);
74 
75     /**
76      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
77      * a call to {approve}. `value` is the new allowance.
78      */
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 
83 // File @openzeppelin/contracts/utils/Address.sol@v4.0.0
84 
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @dev Collection of functions related to the address type
90  */
91 library Address {
92     /**
93      * @dev Returns true if `account` is a contract.
94      *
95      * [IMPORTANT]
96      * ====
97      * It is unsafe to assume that an address for which this function returns
98      * false is an externally-owned account (EOA) and not a contract.
99      *
100      * Among others, `isContract` will return false for the following
101      * types of addresses:
102      *
103      *  - an externally-owned account
104      *  - a contract in construction
105      *  - an address where a contract will be created
106      *  - an address where a contract lived, but was destroyed
107      * ====
108      */
109     function isContract(address account) internal view returns (bool) {
110         // This method relies on extcodesize, which returns 0 for contracts in
111         // construction, since the code is only stored at the end of the
112         // constructor execution.
113 
114         uint256 size;
115         // solhint-disable-next-line no-inline-assembly
116         assembly { size := extcodesize(account) }
117         return size > 0;
118     }
119 
120     /**
121      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
122      * `recipient`, forwarding all available gas and reverting on errors.
123      *
124      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
125      * of certain opcodes, possibly making contracts go over the 2300 gas limit
126      * imposed by `transfer`, making them unable to receive funds via
127      * `transfer`. {sendValue} removes this limitation.
128      *
129      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
130      *
131      * IMPORTANT: because control is transferred to `recipient`, care must be
132      * taken to not create reentrancy vulnerabilities. Consider using
133      * {ReentrancyGuard} or the
134      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
135      */
136     function sendValue(address payable recipient, uint256 amount) internal {
137         require(address(this).balance >= amount, "Address: insufficient balance");
138 
139         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
140         (bool success, ) = recipient.call{ value: amount }("");
141         require(success, "Address: unable to send value, recipient may have reverted");
142     }
143 
144     /**
145      * @dev Performs a Solidity function call using a low level `call`. A
146      * plain`call` is an unsafe replacement for a function call: use this
147      * function instead.
148      *
149      * If `target` reverts with a revert reason, it is bubbled up by this
150      * function (like regular Solidity function calls).
151      *
152      * Returns the raw returned data. To convert to the expected return value,
153      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
154      *
155      * Requirements:
156      *
157      * - `target` must be a contract.
158      * - calling `target` with `data` must not revert.
159      *
160      * _Available since v3.1._
161      */
162     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
163       return functionCall(target, data, "Address: low-level call failed");
164     }
165 
166     /**
167      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
168      * `errorMessage` as a fallback revert reason when `target` reverts.
169      *
170      * _Available since v3.1._
171      */
172     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
173         return functionCallWithValue(target, data, 0, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but also transferring `value` wei to `target`.
179      *
180      * Requirements:
181      *
182      * - the calling contract must have an ETH balance of at least `value`.
183      * - the called Solidity function must be `payable`.
184      *
185      * _Available since v3.1._
186      */
187     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
188         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
193      * with `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
198         require(address(this).balance >= value, "Address: insufficient balance for call");
199         require(isContract(target), "Address: call to non-contract");
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory returndata) = target.call{ value: value }(data);
203         return _verifyCallResult(success, returndata, errorMessage);
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
208      * but performing a static call.
209      *
210      * _Available since v3.3._
211      */
212     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
213         return functionStaticCall(target, data, "Address: low-level static call failed");
214     }
215 
216     /**
217      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
218      * but performing a static call.
219      *
220      * _Available since v3.3._
221      */
222     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
223         require(isContract(target), "Address: static call to non-contract");
224 
225         // solhint-disable-next-line avoid-low-level-calls
226         (bool success, bytes memory returndata) = target.staticcall(data);
227         return _verifyCallResult(success, returndata, errorMessage);
228     }
229 
230     /**
231      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
232      * but performing a delegate call.
233      *
234      * _Available since v3.4._
235      */
236     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
237         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
247         require(isContract(target), "Address: delegate call to non-contract");
248 
249         // solhint-disable-next-line avoid-low-level-calls
250         (bool success, bytes memory returndata) = target.delegatecall(data);
251         return _verifyCallResult(success, returndata, errorMessage);
252     }
253 
254     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
255         if (success) {
256             return returndata;
257         } else {
258             // Look for revert reason and bubble it up if present
259             if (returndata.length > 0) {
260                 // The easiest way to bubble the revert reason is using memory via assembly
261 
262                 // solhint-disable-next-line no-inline-assembly
263                 assembly {
264                     let returndata_size := mload(returndata)
265                     revert(add(32, returndata), returndata_size)
266                 }
267             } else {
268                 revert(errorMessage);
269             }
270         }
271     }
272 }
273 
274 
275 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.0.0
276 
277 
278 pragma solidity ^0.8.0;
279 
280 
281 /**
282  * @title SafeERC20
283  * @dev Wrappers around ERC20 operations that throw on failure (when the token
284  * contract returns false). Tokens that return no value (and instead revert or
285  * throw on failure) are also supported, non-reverting calls are assumed to be
286  * successful.
287  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
288  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
289  */
290 library SafeERC20 {
291     using Address for address;
292 
293     function safeTransfer(IERC20 token, address to, uint256 value) internal {
294         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
295     }
296 
297     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
298         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
299     }
300 
301     /**
302      * @dev Deprecated. This function has issues similar to the ones found in
303      * {IERC20-approve}, and its usage is discouraged.
304      *
305      * Whenever possible, use {safeIncreaseAllowance} and
306      * {safeDecreaseAllowance} instead.
307      */
308     function safeApprove(IERC20 token, address spender, uint256 value) internal {
309         // safeApprove should only be called when setting an initial allowance,
310         // or when resetting it to zero. To increase and decrease it, use
311         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
312         // solhint-disable-next-line max-line-length
313         require((value == 0) || (token.allowance(address(this), spender) == 0),
314             "SafeERC20: approve from non-zero to non-zero allowance"
315         );
316         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
317     }
318 
319     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
320         uint256 newAllowance = token.allowance(address(this), spender) + value;
321         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
322     }
323 
324     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         unchecked {
326             uint256 oldAllowance = token.allowance(address(this), spender);
327             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
328             uint256 newAllowance = oldAllowance - value;
329             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
330         }
331     }
332 
333     /**
334      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
335      * on the return value: the return value is optional (but if data is returned, it must not be false).
336      * @param token The token targeted by the call.
337      * @param data The call data (encoded using abi.encode or one of its variants).
338      */
339     function _callOptionalReturn(IERC20 token, bytes memory data) private {
340         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
341         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
342         // the target address contains contract code and also asserts for success in the low-level call.
343 
344         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
345         if (returndata.length > 0) { // Return data is optional
346             // solhint-disable-next-line max-line-length
347             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
348         }
349     }
350 }
351 
352 
353 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.0.0
354 
355 
356 pragma solidity ^0.8.0;
357 
358 // CAUTION
359 // This version of SafeMath should only be used with Solidity 0.8 or later,
360 // because it relies on the compiler's built in overflow checks.
361 
362 /**
363  * @dev Wrappers over Solidity's arithmetic operations.
364  *
365  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
366  * now has built in overflow checking.
367  */
368 library SafeMath {
369     /**
370      * @dev Returns the addition of two unsigned integers, with an overflow flag.
371      *
372      * _Available since v3.4._
373      */
374     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
375         unchecked {
376             uint256 c = a + b;
377             if (c < a) return (false, 0);
378             return (true, c);
379         }
380     }
381 
382     /**
383      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
384      *
385      * _Available since v3.4._
386      */
387     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
388         unchecked {
389             if (b > a) return (false, 0);
390             return (true, a - b);
391         }
392     }
393 
394     /**
395      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
396      *
397      * _Available since v3.4._
398      */
399     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
400         unchecked {
401             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
402             // benefit is lost if 'b' is also tested.
403             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
404             if (a == 0) return (true, 0);
405             uint256 c = a * b;
406             if (c / a != b) return (false, 0);
407             return (true, c);
408         }
409     }
410 
411     /**
412      * @dev Returns the division of two unsigned integers, with a division by zero flag.
413      *
414      * _Available since v3.4._
415      */
416     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
417         unchecked {
418             if (b == 0) return (false, 0);
419             return (true, a / b);
420         }
421     }
422 
423     /**
424      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
425      *
426      * _Available since v3.4._
427      */
428     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
429         unchecked {
430             if (b == 0) return (false, 0);
431             return (true, a % b);
432         }
433     }
434 
435     /**
436      * @dev Returns the addition of two unsigned integers, reverting on
437      * overflow.
438      *
439      * Counterpart to Solidity's `+` operator.
440      *
441      * Requirements:
442      *
443      * - Addition cannot overflow.
444      */
445     function add(uint256 a, uint256 b) internal pure returns (uint256) {
446         return a + b;
447     }
448 
449     /**
450      * @dev Returns the subtraction of two unsigned integers, reverting on
451      * overflow (when the result is negative).
452      *
453      * Counterpart to Solidity's `-` operator.
454      *
455      * Requirements:
456      *
457      * - Subtraction cannot overflow.
458      */
459     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
460         return a - b;
461     }
462 
463     /**
464      * @dev Returns the multiplication of two unsigned integers, reverting on
465      * overflow.
466      *
467      * Counterpart to Solidity's `*` operator.
468      *
469      * Requirements:
470      *
471      * - Multiplication cannot overflow.
472      */
473     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
474         return a * b;
475     }
476 
477     /**
478      * @dev Returns the integer division of two unsigned integers, reverting on
479      * division by zero. The result is rounded towards zero.
480      *
481      * Counterpart to Solidity's `/` operator.
482      *
483      * Requirements:
484      *
485      * - The divisor cannot be zero.
486      */
487     function div(uint256 a, uint256 b) internal pure returns (uint256) {
488         return a / b;
489     }
490 
491     /**
492      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
493      * reverting when dividing by zero.
494      *
495      * Counterpart to Solidity's `%` operator. This function uses a `revert`
496      * opcode (which leaves remaining gas untouched) while Solidity uses an
497      * invalid opcode to revert (consuming all remaining gas).
498      *
499      * Requirements:
500      *
501      * - The divisor cannot be zero.
502      */
503     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
504         return a % b;
505     }
506 
507     /**
508      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
509      * overflow (when the result is negative).
510      *
511      * CAUTION: This function is deprecated because it requires allocating memory for the error
512      * message unnecessarily. For custom revert reasons use {trySub}.
513      *
514      * Counterpart to Solidity's `-` operator.
515      *
516      * Requirements:
517      *
518      * - Subtraction cannot overflow.
519      */
520     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
521         unchecked {
522             require(b <= a, errorMessage);
523             return a - b;
524         }
525     }
526 
527     /**
528      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
529      * division by zero. The result is rounded towards zero.
530      *
531      * Counterpart to Solidity's `%` operator. This function uses a `revert`
532      * opcode (which leaves remaining gas untouched) while Solidity uses an
533      * invalid opcode to revert (consuming all remaining gas).
534      *
535      * Counterpart to Solidity's `/` operator. Note: this function uses a
536      * `revert` opcode (which leaves remaining gas untouched) while Solidity
537      * uses an invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
544         unchecked {
545             require(b > 0, errorMessage);
546             return a / b;
547         }
548     }
549 
550     /**
551      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
552      * reverting with custom message when dividing by zero.
553      *
554      * CAUTION: This function is deprecated because it requires allocating memory for the error
555      * message unnecessarily. For custom revert reasons use {tryMod}.
556      *
557      * Counterpart to Solidity's `%` operator. This function uses a `revert`
558      * opcode (which leaves remaining gas untouched) while Solidity uses an
559      * invalid opcode to revert (consuming all remaining gas).
560      *
561      * Requirements:
562      *
563      * - The divisor cannot be zero.
564      */
565     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
566         unchecked {
567             require(b > 0, errorMessage);
568             return a % b;
569         }
570     }
571 }
572 
573 
574 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.0.0
575 
576 
577 pragma solidity ^0.8.0;
578 
579 /**
580  * @dev Interface of the ERC165 standard, as defined in the
581  * https://eips.ethereum.org/EIPS/eip-165[EIP].
582  *
583  * Implementers can declare support of contract interfaces, which can then be
584  * queried by others ({ERC165Checker}).
585  *
586  * For an implementation, see {ERC165}.
587  */
588 interface IERC165 {
589     /**
590      * @dev Returns true if this contract implements the interface defined by
591      * `interfaceId`. See the corresponding
592      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
593      * to learn more about how these ids are created.
594      *
595      * This function call must use less than 30 000 gas.
596      */
597     function supportsInterface(bytes4 interfaceId) external view returns (bool);
598 }
599 
600 
601 // File contracts/IQLF.sol
602 
603 
604 /**
605  * @author          Yisi Liu
606  * @contact         yisiliu@gmail.com
607  * @author_time     01/06/2021
608 **/
609 
610 pragma solidity >= 0.8.0;
611 
612 abstract contract IQLF is IERC165 {
613     /**
614      * @dev Returns if the given address is qualified, implemented on demand.
615      */
616     function ifQualified (address account) virtual external view returns (bool);
617 
618     /**
619      * @dev Logs if the given address is qualified, implemented on demand.
620      */
621     function logQualified (address account, uint256 ito_start_time) virtual external returns (bool);
622 
623     /**
624      * @dev Ensure that custom contract implements `ifQualified` amd `logQualified` correctly.
625      */
626     function supportsInterface(bytes4 interfaceId) virtual external override pure returns (bool) {
627         return interfaceId == this.supportsInterface.selector || 
628             interfaceId == (this.ifQualified.selector ^ this.logQualified.selector);
629     }
630 
631     /**
632      * @dev Emit when `ifQualified` is called to decide if the given `address`
633      * is `qualified` according to the preset rule by the contract creator and 
634      * the current block `number` and the current block `timestamp`.
635      */
636     event Qualification(address account, bool qualified, uint256 blockNumber, uint256 timestamp);
637 }
638 
639 
640 // File contracts/ito.sol
641 
642 
643 /**
644  * @author          Yisi Liu
645  * @contact         yisiliu@gmail.com
646  * @author_time     01/06/2021
647  * @maintainer      Hancheng Zhou, Yisi Liu
648  * @maintain_time   04/15/2021
649 **/
650 
651 pragma solidity >= 0.8.0;
652 
653 
654 
655 
656 contract HappyTokenPool {
657 
658     struct Pool {
659         uint256 packed1;            // qualification_address(160) the smart contract address to verify qualification
660                                     // hash(40) start_time_delta(28) 
661                                     // expiration_time_delta(28) BIG ENDIAN
662         uint256 packed2;            // total_tokens(128) limit(128)
663         uint48  unlock_time;        // unlock_time + base_time = real_time
664         address creator;
665         address token_address;      // the target token address
666         address[] exchange_addrs;   // a list of ERC20 addresses for swapping
667         uint128[] exchanged_tokens; // a list of amounts of swapped tokens
668         uint128[] ratios;           // a list of swap ratios
669                                     // length = 2 * exchange_addrs.length
670                                     // [address1, target, address2, target, ...]
671                                     // e.g. [1, 10]
672                                     // represents 1 tokenA to swap 10 target token
673                                     // note: each ratio pair needs to be coprime
674         mapping(address => uint256) swapped_map;      // swapped amount of an address
675     }
676 
677     struct Packed {
678         uint256 packed1;
679         uint256 packed2;
680     }
681 
682     // swap pool filling success event
683     event FillSuccess (
684         uint256 total,
685         bytes32 id,
686         address creator,
687         uint256 creation_time,
688         address token_address,
689         string message
690     );
691 
692     // swap success event
693     event SwapSuccess (
694         bytes32 id,
695         address swapper,
696         address from_address,
697         address to_address,
698         uint256 from_value,
699         uint256 to_value
700     );
701 
702     // claim success event
703     event ClaimSuccess (
704         bytes32 id,
705         address claimer,
706         uint256 timestamp,
707         uint256 to_value,
708         address token_address
709     );
710 
711     // swap pool destruct success event
712     event DestructSuccess (
713         bytes32 id,
714         address token_address,
715         uint256 remaining_balance,
716         uint128[] exchanged_values
717     );
718 
719     // single token withdrawl from a swap pool success even
720     event WithdrawSuccess (
721         bytes32 id,
722         address token_address,
723         uint256 withdraw_balance
724     );
725 
726     modifier creatorOnly {
727         require(msg.sender == contract_creator, "Contract Creator Only");
728         _;
729     }
730 
731     using SafeERC20 for IERC20;
732     uint32 nonce;
733     uint224 base_time;                 // timestamp = base_time + delta to save gas
734     address public contract_creator;
735     mapping(bytes32 => Pool) pool_by_id;    // maps an id to a Pool instance
736     string constant private magic = "Prince Philip, Queen Elizabeth II's husband, has died aged 99, \
737     Buckingham Palace has announced. A statement issued by the palace just after midday spoke of the \
738     Queen's deep sorrow following his death at Windsor Castle on Friday morning. The Duke of Edinbur";
739     bytes32 private seed;
740     address DEFAULT_ADDRESS = 0x0000000000000000000000000000000000000000;       // a universal address
741 
742     constructor() {
743         contract_creator = msg.sender;
744         seed = keccak256(abi.encodePacked(magic, block.timestamp, contract_creator));
745         base_time = 1616976000;                                    // 00:00:00 03/30/2021 GMT(UTC+0)
746     }
747 
748     /**
749      * @dev 
750      * fill_pool() creates a swap pool with specific parameters from input
751      * _hash                sha3-256(password)
752      * _start               start time delta, real start time = base_time + _start
753      * _end                 end time delta, real end time = base_time + _end
754      * message              swap pool creation message, only stored in FillSuccess event
755      * _exchange_addrs      swap token list (0x0 for ETH, only supports ETH and ERC20 now)
756      * _ratios              swap pair ratio list
757      * _unlock_time         unlock time delta real unlock time = base_time + _unlock_time
758      * _token_addr          swap target token address
759      * _total_tokens        target token total swap amount
760      * _limit               target token single swap limit
761      * _qualification       the qualification contract address based on IQLF to determine qualification
762      * This function takes the above parameters and creates the pool. _total_tokens of the target token
763      * will be successfully transferred to this contract securely on a successful run of this function.
764     **/
765     function fill_pool (bytes32 _hash, uint256 _start, uint256 _end, string memory message,
766                         address[] memory _exchange_addrs, uint128[] memory _ratios, uint256 _unlock_time,
767                         address _token_addr, uint256 _total_tokens, uint256 _limit, address _qualification)
768     public payable {
769         nonce ++;
770         require(_start < _end, "Start time should be earlier than end time.");
771         require(_end < _unlock_time || _unlock_time == 0, "End time should be earlier than unlock time");
772         require(_limit <= _total_tokens, "Limit needs to be less than or equal to the total supply");
773         require(_total_tokens < 2 ** 128, "No more than 2^128 tokens(incluidng decimals) allowed");
774         require(IERC20(_token_addr).allowance(msg.sender, address(this)) >= _total_tokens, "Insuffcient allowance");
775         require(_exchange_addrs.length > 0, "Exchange token addresses need to be set");
776         require(_ratios.length == 2 * _exchange_addrs.length, "Size of ratios = 2 * size of exchange_addrs");
777 
778         bytes32 _id = keccak256(abi.encodePacked(msg.sender, block.timestamp, nonce, seed));
779         Pool storage pool = pool_by_id[_id];
780         pool.packed1 = wrap1(_qualification, _hash, _start, _end);      // 256 bytes    detail in wrap1()
781         pool.packed2 = wrap2(_total_tokens, _limit);                    // 256 bytes    detail in wrap2()
782         pool.unlock_time = uint48(_unlock_time);                        // 48  bytes    unlock_time 0 -> unlocked
783         pool.creator = msg.sender;                                      // 160 bytes    pool creator
784         pool.exchange_addrs = _exchange_addrs;                          // 160 bytes    target token
785         pool.token_address = _token_addr;                               // 160 bytes    target token address
786 
787         // Init each token swapped amount to 0
788         for (uint256 i = 0; i < _exchange_addrs.length; i++) {
789             if (_exchange_addrs[i] != DEFAULT_ADDRESS) {
790                 // TODO: Is there a better way to validate an ERC20?
791                 require(IERC20(_exchange_addrs[i]).totalSupply() > 0, "Not a valid ERC20");
792             }
793             pool.exchanged_tokens.push(0); 
794         }
795 
796         // Make sure each ratio is co-prime to prevent overflow
797         for (uint256 i = 0; i < _ratios.length; i+= 2) {
798             uint256 divA = SafeMath.div(_ratios[i], _ratios[i+1]);      // Non-zero checked by SafteMath.div
799             uint256 divB = SafeMath.div(_ratios[i+1], _ratios[i]);      // Non-zero checked by SafteMath.div
800             
801             if (_ratios[i] == 1) {
802                 require(divB == _ratios[i+1]);
803             } else if (_ratios[i+1] == 1) {
804                 require(divA == _ratios[i]);
805             } else {
806                 // if a and b are co-prime, then a / b * b != a and b / a * a != b
807                 require(divA * _ratios[i+1] != _ratios[i]);
808                 require(divB * _ratios[i] != _ratios[i+1]);
809             }
810         }
811         pool.ratios = _ratios;                                          // 256 * k
812         IERC20(_token_addr).safeTransferFrom(msg.sender, address(this), _total_tokens);
813 
814         emit FillSuccess(_total_tokens, _id, msg.sender, block.timestamp, _token_addr, message);
815     }
816 
817     /**
818      * @dev
819      * swap() allows users to swap tokens in a swap pool
820      * id                   swap pool id
821      * verification         sha3-256(sha3-256(password)[:40]+swapper_address)
822      * validation           sha3-256(swapper_address)
823      * exchange_addr_i     the index of the exchange address of the list
824      * input_total          the input amount of the specific token
825      * This function is called by the swapper who approves the specific ERC20 or directly transfer the ETH
826      * first and wants to swap the desired amount of the target token. The swapped amount is calculated
827      * based on the pool ratio. After swap successfully, the same account can not swap the same pool again.
828     **/
829 
830     function swap (bytes32 id, bytes32 verification, 
831                    bytes32 validation, uint256 exchange_addr_i, uint128 input_total) 
832     public payable returns (uint256 swapped) {
833 
834         Pool storage pool = pool_by_id[id];
835         Packed memory packed = Packed(pool.packed1, pool.packed2);
836         require (
837             IQLF(
838                 address(
839                     uint160(unbox(packed.packed1, 0, 160)))
840                 ).logQualified(msg.sender, uint256(unbox(packed.packed1, 200, 28) + base_time)
841             ) == true, 
842             "Not Qualified"
843         );
844         require (unbox(packed.packed1, 200, 28) + base_time < block.timestamp, "Not started.");
845         require (unbox(packed.packed1, 228, 28) + base_time > block.timestamp, "Expired.");
846         // sha3(sha3(passowrd)[:40] + msg.sender) so that the raw password will never appear in the contract
847         require (verification == keccak256(abi.encodePacked(unbox(packed.packed1, 160, 40), msg.sender)), 
848                  'Wrong Password');
849         // sha3(msg.sender) to protect from front runs (but this is kinda naive since the contract is open sourced)
850         require (validation == keccak256(abi.encodePacked(msg.sender)), "Validation Failed");
851 
852         uint256 total_tokens = unbox(packed.packed2, 0, 128);
853         // revert if the pool is empty
854         require (total_tokens > 0, "Out of Stock");
855 
856         address exchange_addr = pool.exchange_addrs[exchange_addr_i];
857         uint256 ratioA = pool.ratios[exchange_addr_i*2];
858         uint256 ratioB = pool.ratios[exchange_addr_i*2 + 1];
859         // check if the input is enough for the desired transfer
860         if (exchange_addr == DEFAULT_ADDRESS) {
861             require(msg.value == input_total, 'No enough ether.');
862         } else {
863             uint256 allowance = IERC20(exchange_addr).allowance(msg.sender, address(this));
864             require(allowance >= input_total, 'No enough allowance.');
865         }
866 
867         uint256 swapped_tokens;
868         // this calculation won't be overflow thanks to the SafeMath and the co-prime test
869         swapped_tokens = SafeMath.div(SafeMath.mul(input_total, ratioB), ratioA);       // 2^256=10e77 >> 10e18 * 10e18
870         require(swapped_tokens > 0, "Better not draw water with a sieve");
871 
872         uint256 limit = unbox(packed.packed2, 128, 128);
873         if (swapped_tokens > limit) {
874             // don't be greedy - you can only get at most limit tokens
875             swapped_tokens = limit;
876             input_total = uint128(SafeMath.div(SafeMath.mul(limit, ratioA), ratioB));           // Update input_total
877         } else if (swapped_tokens > total_tokens) {
878             // if the left tokens are not enough
879             swapped_tokens = total_tokens;
880             input_total = uint128(SafeMath.div(SafeMath.mul(total_tokens, ratioA), ratioB));    // Update input_total
881             // return the eth
882             if (exchange_addr == DEFAULT_ADDRESS)
883                 payable(msg.sender).transfer(msg.value - input_total);
884         }
885         require(swapped_tokens <= limit);                                                       // make sure again
886         pool.exchanged_tokens[exchange_addr_i] = uint128(SafeMath.add(pool.exchanged_tokens[exchange_addr_i], 
887                                                                       input_total));            // update exchanged
888 
889         // penalize greedy attackers by placing duplication check at the very last
890         require (pool.swapped_map[msg.sender] == 0, "Already swapped");
891 
892         // update the remaining tokens and swapped token mapping
893         pool.packed2 = rewriteBox(packed.packed2, 0, 128, SafeMath.sub(total_tokens, swapped_tokens));
894         pool.swapped_map[msg.sender] = swapped_tokens;
895 
896         // transfer the token after state changing
897         // ETH comes with the tx, but ERC20 does not - INPUT
898         if (exchange_addr != DEFAULT_ADDRESS) {
899             IERC20(exchange_addr).safeTransferFrom(msg.sender, address(this), input_total);
900         }
901 
902         // Swap success event
903         emit SwapSuccess(id, msg.sender, exchange_addr, pool.token_address, input_total, swapped_tokens);
904 
905         // if unlock_time == 0, transfer the swapped tokens to the recipient address (msg.sender) - OUTPUT
906         // if not, claim() needs to be called to get the token
907         if (pool.unlock_time == 0) {
908             transfer_token(pool.token_address, address(this), msg.sender, swapped_tokens);
909             emit ClaimSuccess(id, msg.sender, block.timestamp, swapped_tokens, pool.token_address);
910         }
911             
912         return swapped_tokens;
913     }
914 
915     /**
916      * check_availability() returns a bunch of pool info given a pool id
917      * id                    swap pool id
918      * this function returns 1. exchange_addrs that can be used to determine the index
919      *                       2. remaining target tokens
920      *                       3. if started
921      *                       4. if ended
922      *                       5. swapped amount of the query address
923      *                       5. exchanged amount of each token
924     **/
925 
926     function check_availability (bytes32 id) external view 
927         returns (address[] memory exchange_addrs, uint256 remaining, 
928                  bool started, bool expired, bool unlocked, uint256 unlock_time,
929                  uint256 swapped, uint128[] memory exchanged_tokens) {
930         Pool storage pool = pool_by_id[id];
931         return (
932             pool.exchange_addrs,                                                // exchange_addrs 0x0 means destructed
933             unbox(pool.packed2, 0, 128),                                        // remaining
934             block.timestamp > unbox(pool.packed1, 200, 28) + base_time,         // started
935             block.timestamp > unbox(pool.packed1, 228, 28) + base_time,         // expired
936             block.timestamp > pool.unlock_time + base_time,                     // unlocked
937             pool.unlock_time + base_time,                                       // unlock_time
938             pool.swapped_map[msg.sender],                                       // swapped number 
939             pool.exchanged_tokens                                               // exchanged tokens
940         );
941     }
942 
943     function claim(bytes32[] memory ito_ids) public {
944         uint256 claimed_amount;
945         for (uint256 i = 0; i < ito_ids.length; i++) {
946             Pool storage pool = pool_by_id[ito_ids[i]];
947             if (pool.unlock_time + base_time > block.timestamp)
948                 continue;
949             claimed_amount = pool.swapped_map[msg.sender];
950             if (claimed_amount == 0)
951                 continue;
952             pool.swapped_map[msg.sender] = 0;
953             transfer_token(pool.token_address, address(this), msg.sender, claimed_amount);
954 
955             emit ClaimSuccess(ito_ids[i], msg.sender, block.timestamp, claimed_amount, pool.token_address);
956         }
957     }
958 
959     function setUnlockTime(bytes32 id, uint256 _unlock_time) public {
960         Pool storage pool = pool_by_id[id];
961         require(pool.creator == msg.sender, "Pool Creator Only");
962         pool.unlock_time = uint48(_unlock_time);
963     }
964 
965     /**
966      * destruct() destructs the given pool given the pool id
967      * id                    swap pool id
968      * this function can only be called by the pool creator. after validation, it transfers all the remaining token 
969      * (if any) and all the swapped tokens to the pool creator. it will then destruct the pool by reseting almost 
970      * all the variables to zero to get the gas refund.
971      * note that this function may not work if a pool needs to transfer over ~200 tokens back to the address due to 
972      * the block gas limit. we have another function withdraw() to help the pool creator to withdraw a single token 
973     **/
974 
975     function destruct (bytes32 id) public {
976         Pool storage pool = pool_by_id[id];
977         require(msg.sender == pool.creator, "Only the pool creator can destruct.");
978 
979         uint256 expiration = unbox(pool.packed1, 228, 28) + base_time;
980         uint256 remaining_tokens = unbox(pool.packed2, 0, 128);
981         // only after expiration or the pool is empty
982         require(expiration <= block.timestamp || remaining_tokens == 0, "Not expired yet");
983 
984         // if any left in the pool
985         if (remaining_tokens != 0) {
986             transfer_token(pool.token_address, address(this), msg.sender, remaining_tokens);
987         }
988         
989         // transfer the swapped tokens accordingly
990         // note this loop may exceed the block gas limit so if >200 exchange_addrs this may not work
991         for (uint256 i = 0; i < pool.exchange_addrs.length; i++) {
992             if (pool.exchanged_tokens[i] > 0) {
993                 // ERC20
994                 if (pool.exchange_addrs[i] != DEFAULT_ADDRESS)
995                     transfer_token(pool.exchange_addrs[i], address(this), msg.sender, pool.exchanged_tokens[i]);
996                 // ETH
997                 else
998                     payable(msg.sender).transfer(pool.exchanged_tokens[i]);
999             }
1000         }
1001         emit DestructSuccess(id, pool.token_address, remaining_tokens, pool.exchanged_tokens);
1002 
1003         // Gas Refund
1004         pool.packed1 = 0;
1005         pool.packed2 = 0;
1006         pool.creator = DEFAULT_ADDRESS;
1007         for (uint256 i = 0; i < pool.exchange_addrs.length; i++) {
1008             pool.exchange_addrs[i] = DEFAULT_ADDRESS;
1009             pool.exchanged_tokens[i] = 0;
1010             pool.ratios[i*2] = 0;
1011             pool.ratios[i*2+1] = 0;
1012         }
1013     }
1014 
1015     /**
1016      * withdraw() transfers out a single token after a pool is expired or empty 
1017      * id                    swap pool id
1018      * addr_i                withdraw token index
1019      * this function can only be called by the pool creator. after validation, it transfers the addr_i th token 
1020      * out to the pool creator address.
1021     **/
1022 
1023     function withdraw (bytes32 id, uint256 addr_i) public {
1024         Pool storage pool = pool_by_id[id];
1025         require(msg.sender == pool.creator, "Only the pool creator can withdraw.");
1026 
1027         uint256 withdraw_balance = pool.exchanged_tokens[addr_i];
1028         require(withdraw_balance > 0, "None of this token left");
1029         uint256 expiration = unbox(pool.packed1, 228, 28) + base_time;
1030         uint256 remaining_tokens = unbox(pool.packed2, 0, 128);
1031         // only after expiration or the pool is empty
1032         require(expiration <= block.timestamp || remaining_tokens == 0, "Not expired yet");
1033         address token_address = pool.exchange_addrs[addr_i];
1034 
1035         // ERC20
1036         if (token_address != DEFAULT_ADDRESS)
1037             transfer_token(token_address, address(this), msg.sender, withdraw_balance);
1038         // ETH
1039         else
1040             payable(msg.sender).transfer(withdraw_balance);
1041         // clear the record
1042         pool.exchanged_tokens[addr_i] = 0;
1043         emit WithdrawSuccess(id, token_address, withdraw_balance);
1044     }
1045 
1046     // helper functions TODO: migrate this to a helper file
1047 
1048     /**
1049      * _qualification the smart contract address to verify qualification      160
1050      * _hash          sha3-256(password)                                      40
1051      * _start         start time delta                                        28
1052      * _end           end time  delta                                         28
1053      * wrap1() inserts the above variables into a 32-word block
1054     **/
1055 
1056     function wrap1 (address _qualification, bytes32 _hash, uint256 _start, uint256 _end) internal pure 
1057                     returns (uint256 packed1) {
1058         uint256 _packed1 = 0;
1059         _packed1 |= box(0, 160,  uint256(uint160(_qualification)));     // _qualification = 160 bits
1060         _packed1 |= box(160, 40, uint256(_hash) >> 216);                // hash = 40 bits (safe?)
1061         _packed1 |= box(200, 28, _start);                               // start_time = 28 bits 
1062         _packed1 |= box(228, 28, _end);                                 // expiration_time = 28 bits
1063         return _packed1;
1064     }
1065 
1066     /**
1067      * _total_tokens   target remaining         128
1068      * _limit          single swap limit        128
1069      * wrap2() inserts the above variables into a 32-word block
1070     **/
1071 
1072     function wrap2 (uint256 _total_tokens, uint256 _limit) internal pure returns (uint256 packed2) {
1073         uint256 _packed2 = 0;
1074         _packed2 |= box(0, 128, _total_tokens);             // total_tokens = 128 bits ~= 3.4e38
1075         _packed2 |= box(128, 128, _limit);                  // limit = 128 bits
1076         return _packed2;
1077     }
1078 
1079     /**
1080      * position      position in a memory block
1081      * size          data size
1082      * data          data
1083      * box() inserts the data in a 256bit word with the given position and returns it
1084      * data is checked by validRange() to make sure it is not over size 
1085     **/
1086 
1087     function box (uint16 position, uint16 size, uint256 data) internal pure returns (uint256 boxed) {
1088         require(validRange(size, data), "Value out of range BOX");
1089         assembly {
1090             // data << position
1091             boxed := shl(position, data)
1092         }
1093     }
1094 
1095     /**
1096      * position      position in a memory block
1097      * size          data size
1098      * base          base data
1099      * unbox() extracts the data out of a 256bit word with the given position and returns it
1100      * base is checked by validRange() to make sure it is not over size 
1101     **/
1102 
1103     function unbox (uint256 base, uint16 position, uint16 size) internal pure returns (uint256 unboxed) {
1104         require(validRange(256, base), "Value out of range UNBOX");
1105         assembly {
1106             // (((1 << size) - 1) & base >> position)
1107             unboxed := and(sub(shl(size, 1), 1), shr(position, base))
1108 
1109         }
1110     }
1111 
1112     /**
1113      * size          data size
1114      * data          data
1115      * validRange()  checks if the given data is over the specified data size
1116     **/
1117 
1118     function validRange (uint16 size, uint256 data) internal pure returns(bool ifValid) { 
1119         assembly {
1120             // 2^size > data or size ==256
1121             ifValid := or(eq(size, 256), gt(shl(size, 1), data))
1122         }
1123     }
1124 
1125     /**
1126      * _box          32byte data to be modified
1127      * position      position in a memory block
1128      * size          data size
1129      * data          data to be inserted
1130      * rewriteBox() updates a 32byte word with a data at the given position with the specified size
1131     **/
1132 
1133     function rewriteBox (uint256 _box, uint16 position, uint16 size, uint256 data) 
1134                         internal pure returns (uint256 boxed) {
1135         assembly {
1136             // mask = ~((1 << size - 1) << position)
1137             // _box = (mask & _box) | ()data << position)
1138             boxed := or( and(_box, not(shl(position, sub(shl(size, 1), 1)))), shl(position, data))
1139         }
1140     }
1141 
1142     /**
1143      * token_address      ERC20 address
1144      * sender_address     sender address
1145      * recipient_address  recipient address
1146      * amount             transfer amount
1147      * transfer_token() transfers a given amount of ERC20 from the sender address to the recipient address
1148     **/
1149    
1150     function transfer_token (address token_address, address sender_address,
1151                              address recipient_address, uint256 amount) internal {
1152         require(IERC20(token_address).balanceOf(sender_address) >= amount, "Balance not enough");
1153         IERC20(token_address).safeTransfer(recipient_address, amount);
1154     }
1155     
1156 }