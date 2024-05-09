1 // SPDX-License-Identifier: GPL-3.0
2 pragma solidity ^0.8.0;
3 
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations.
7  *
8  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
9  * now has built in overflow checking.
10  */
11 library SafeMath {
12     /**
13      * @dev Returns the addition of two unsigned integers, with an overflow flag.
14      *
15      * _Available since v3.4._
16      */
17     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
18         unchecked {
19             uint256 c = a + b;
20             if (c < a) return (false, 0);
21             return (true, c);
22         }
23     }
24 
25     /**
26      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
27      *
28      * _Available since v3.4._
29      */
30     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
31         unchecked {
32             if (b > a) return (false, 0);
33             return (true, a - b);
34         }
35     }
36 
37     /**
38      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
39      *
40      * _Available since v3.4._
41      */
42     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
43         unchecked {
44             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
45             // benefit is lost if 'b' is also tested.
46             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
47             if (a == 0) return (true, 0);
48             uint256 c = a * b;
49             if (c / a != b) return (false, 0);
50             return (true, c);
51         }
52     }
53 
54     /**
55      * @dev Returns the division of two unsigned integers, with a division by zero flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         unchecked {
61             if (b == 0) return (false, 0);
62             return (true, a / b);
63         }
64     }
65 
66     /**
67      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
68      *
69      * _Available since v3.4._
70      */
71     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
72         unchecked {
73             if (b == 0) return (false, 0);
74             return (true, a % b);
75         }
76     }
77 
78     /**
79      * @dev Returns the addition of two unsigned integers, reverting on
80      * overflow.
81      *
82      * Counterpart to Solidity's `+` operator.
83      *
84      * Requirements:
85      *
86      * - Addition cannot overflow.
87      */
88     function add(uint256 a, uint256 b) internal pure returns (uint256) {
89         return a + b;
90     }
91 
92     /**
93      * @dev Returns the subtraction of two unsigned integers, reverting on
94      * overflow (when the result is negative).
95      *
96      * Counterpart to Solidity's `-` operator.
97      *
98      * Requirements:
99      *
100      * - Subtraction cannot overflow.
101      */
102     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
103         return a - b;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         return a * b;
118     }
119 
120     /**
121      * @dev Returns the integer division of two unsigned integers, reverting on
122      * division by zero. The result is rounded towards zero.
123      *
124      * Counterpart to Solidity's `/` operator.
125      *
126      * Requirements:
127      *
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return a / b;
132     }
133 
134     /**
135      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
136      * reverting when dividing by zero.
137      *
138      * Counterpart to Solidity's `%` operator. This function uses a `revert`
139      * opcode (which leaves remaining gas untouched) while Solidity uses an
140      * invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      *
144      * - The divisor cannot be zero.
145      */
146     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
147         return a % b;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * CAUTION: This function is deprecated because it requires allocating memory for the error
155      * message unnecessarily. For custom revert reasons use {trySub}.
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         unchecked {
165             require(b <= a, errorMessage);
166             return a - b;
167         }
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         unchecked {
188             require(b > 0, errorMessage);
189             return a / b;
190         }
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * reverting with custom message when dividing by zero.
196      *
197      * CAUTION: This function is deprecated because it requires allocating memory for the error
198      * message unnecessarily. For custom revert reasons use {tryMod}.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         unchecked {
210             require(b > 0, errorMessage);
211             return a % b;
212         }
213     }
214 }
215 
216 /**
217  * @dev Standard math utilities missing in the Solidity language.
218  */
219 library Math {
220     /**
221      * @dev Returns the largest of two numbers.
222      */
223     function max(uint256 a, uint256 b) internal pure returns (uint256) {
224         return a >= b ? a : b;
225     }
226 
227     /**
228      * @dev Returns the smallest of two numbers.
229      */
230     function min(uint256 a, uint256 b) internal pure returns (uint256) {
231         return a < b ? a : b;
232     }
233 
234     /**
235      * @dev Returns the average of two numbers. The result is rounded towards
236      * zero.
237      */
238     function average(uint256 a, uint256 b) internal pure returns (uint256) {
239         // (a + b) / 2 can overflow, so we distribute
240         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
241     }
242 }
243 
244 
245 /**
246  * @dev Interface of the ERC20 standard as defined in the EIP.
247  */
248 interface IERC20 {
249     /**
250      * @dev Returns the amount of tokens in existence.
251      */
252     function totalSupply() external view returns (uint256);
253 
254     /**
255      * @dev Returns the amount of tokens owned by `account`.
256      */
257     function balanceOf(address account) external view returns (uint256);
258 
259     /**
260      * @dev Moves `amount` tokens from the caller's account to `recipient`.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * Emits a {Transfer} event.
265      */
266     function transfer(address recipient, uint256 amount) external returns (bool);
267 
268     /**
269      * @dev Returns the remaining number of tokens that `spender` will be
270      * allowed to spend on behalf of `owner` through {transferFrom}. This is
271      * zero by default.
272      *
273      * This value changes when {approve} or {transferFrom} are called.
274      */
275     function allowance(address owner, address spender) external view returns (uint256);
276 
277     /**
278      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * IMPORTANT: Beware that changing an allowance with this method brings the risk
283      * that someone may use both the old and the new allowance by unfortunate
284      * transaction ordering. One possible solution to mitigate this race
285      * condition is to first reduce the spender's allowance to 0 and set the
286      * desired value afterwards:
287      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
288      *
289      * Emits an {Approval} event.
290      */
291     function approve(address spender, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Moves `amount` tokens from `sender` to `recipient` using the
295      * allowance mechanism. `amount` is then deducted from the caller's
296      * allowance.
297      *
298      * Returns a boolean value indicating whether the operation succeeded.
299      *
300      * Emits a {Transfer} event.
301      */
302     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Emitted when `value` tokens are moved from one account (`from`) to
306      * another (`to`).
307      *
308      * Note that `value` may be zero.
309      */
310     event Transfer(address indexed from, address indexed to, uint256 value);
311 
312     /**
313      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
314      * a call to {approve}. `value` is the new allowance.
315      */
316     event Approval(address indexed owner, address indexed spender, uint256 value);
317 }
318 
319 
320 /**
321  * @dev Collection of functions related to the address type
322  */
323 library Address {
324     /**
325      * @dev Returns true if `account` is a contract.
326      *
327      * [IMPORTANT]
328      * ====
329      * It is unsafe to assume that an address for which this function returns
330      * false is an externally-owned account (EOA) and not a contract.
331      *
332      * Among others, `isContract` will return false for the following
333      * types of addresses:
334      *
335      *  - an externally-owned account
336      *  - a contract in construction
337      *  - an address where a contract will be created
338      *  - an address where a contract lived, but was destroyed
339      * ====
340      */
341     function isContract(address account) internal view returns (bool) {
342         // This method relies on extcodesize, which returns 0 for contracts in
343         // construction, since the code is only stored at the end of the
344         // constructor execution.
345 
346         uint256 size;
347         // solhint-disable-next-line no-inline-assembly
348         assembly { size := extcodesize(account) }
349         return size > 0;
350     }
351 
352     /**
353      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
354      * `recipient`, forwarding all available gas and reverting on errors.
355      *
356      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
357      * of certain opcodes, possibly making contracts go over the 2300 gas limit
358      * imposed by `transfer`, making them unable to receive funds via
359      * `transfer`. {sendValue} removes this limitation.
360      *
361      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
362      *
363      * IMPORTANT: because control is transferred to `recipient`, care must be
364      * taken to not create reentrancy vulnerabilities. Consider using
365      * {ReentrancyGuard} or the
366      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
367      */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
372         (bool success, ) = recipient.call{ value: amount }("");
373         require(success, "Address: unable to send value, recipient may have reverted");
374     }
375 
376     /**
377      * @dev Performs a Solidity function call using a low level `call`. A
378      * plain`call` is an unsafe replacement for a function call: use this
379      * function instead.
380      *
381      * If `target` reverts with a revert reason, it is bubbled up by this
382      * function (like regular Solidity function calls).
383      *
384      * Returns the raw returned data. To convert to the expected return value,
385      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
386      *
387      * Requirements:
388      *
389      * - `target` must be a contract.
390      * - calling `target` with `data` must not revert.
391      *
392      * _Available since v3.1._
393      */
394     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
395       return functionCall(target, data, "Address: low-level call failed");
396     }
397 
398     /**
399      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
400      * `errorMessage` as a fallback revert reason when `target` reverts.
401      *
402      * _Available since v3.1._
403      */
404     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, 0, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but also transferring `value` wei to `target`.
411      *
412      * Requirements:
413      *
414      * - the calling contract must have an ETH balance of at least `value`.
415      * - the called Solidity function must be `payable`.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
425      * with `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432 
433         // solhint-disable-next-line avoid-low-level-calls
434         (bool success, bytes memory returndata) = target.call{ value: value }(data);
435         return _verifyCallResult(success, returndata, errorMessage);
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
440      * but performing a static call.
441      *
442      * _Available since v3.3._
443      */
444     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
445         return functionStaticCall(target, data, "Address: low-level static call failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
450      * but performing a static call.
451      *
452      * _Available since v3.3._
453      */
454     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
455         require(isContract(target), "Address: static call to non-contract");
456 
457         // solhint-disable-next-line avoid-low-level-calls
458         (bool success, bytes memory returndata) = target.staticcall(data);
459         return _verifyCallResult(success, returndata, errorMessage);
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
464      * but performing a delegate call.
465      *
466      * _Available since v3.4._
467      */
468     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
469         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
474      * but performing a delegate call.
475      *
476      * _Available since v3.4._
477      */
478     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
479         require(isContract(target), "Address: delegate call to non-contract");
480 
481         // solhint-disable-next-line avoid-low-level-calls
482         (bool success, bytes memory returndata) = target.delegatecall(data);
483         return _verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
487         if (success) {
488             return returndata;
489         } else {
490             // Look for revert reason and bubble it up if present
491             if (returndata.length > 0) {
492                 // The easiest way to bubble the revert reason is using memory via assembly
493 
494                 // solhint-disable-next-line no-inline-assembly
495                 assembly {
496                     let returndata_size := mload(returndata)
497                     revert(add(32, returndata), returndata_size)
498                 }
499             } else {
500                 revert(errorMessage);
501             }
502         }
503     }
504 }
505 
506 
507 /**
508  * @title SafeERC20
509  * @dev Wrappers around ERC20 operations that throw on failure (when the token
510  * contract returns false). Tokens that return no value (and instead revert or
511  * throw on failure) are also supported, non-reverting calls are assumed to be
512  * successful.
513  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
514  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
515  */
516 library SafeERC20 {
517     using Address for address;
518 
519     function safeTransfer(IERC20 token, address to, uint256 value) internal {
520         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
521     }
522 
523     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
524         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
525     }
526 
527     /**
528      * @dev Deprecated. This function has issues similar to the ones found in
529      * {IERC20-approve}, and its usage is discouraged.
530      *
531      * Whenever possible, use {safeIncreaseAllowance} and
532      * {safeDecreaseAllowance} instead.
533      */
534     function safeApprove(IERC20 token, address spender, uint256 value) internal {
535         // safeApprove should only be called when setting an initial allowance,
536         // or when resetting it to zero. To increase and decrease it, use
537         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
538         // solhint-disable-next-line max-line-length
539         require((value == 0) || (token.allowance(address(this), spender) == 0),
540             "SafeERC20: approve from non-zero to non-zero allowance"
541         );
542         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
543     }
544 
545     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
546         uint256 newAllowance = token.allowance(address(this), spender) + value;
547         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
548     }
549 
550     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
551         unchecked {
552             uint256 oldAllowance = token.allowance(address(this), spender);
553             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
554             uint256 newAllowance = oldAllowance - value;
555             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
556         }
557     }
558 
559     /**
560      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
561      * on the return value: the return value is optional (but if data is returned, it must not be false).
562      * @param token The token targeted by the call.
563      * @param data The call data (encoded using abi.encode or one of its variants).
564      */
565     function _callOptionalReturn(IERC20 token, bytes memory data) private {
566         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
567         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
568         // the target address contains contract code and also asserts for success in the low-level call.
569 
570         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
571         if (returndata.length > 0) { // Return data is optional
572             // solhint-disable-next-line max-line-length
573             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
574         }
575     }
576 }
577 
578 
579 /**
580  * @dev Contract module that helps prevent reentrant calls to a function.
581  *
582  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
583  * available, which can be applied to functions to make sure there are no nested
584  * (reentrant) calls to them.
585  *
586  * Note that because there is a single `nonReentrant` guard, functions marked as
587  * `nonReentrant` may not call one another. This can be worked around by making
588  * those functions `private`, and then adding `external` `nonReentrant` entry
589  * points to them.
590  *
591  * TIP: If you would like to learn more about reentrancy and alternative ways
592  * to protect against it, check out our blog post
593  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
594  */
595 abstract contract ReentrancyGuard {
596     // Booleans are more expensive than uint256 or any type that takes up a full
597     // word because each write operation emits an extra SLOAD to first read the
598     // slot's contents, replace the bits taken up by the boolean, and then write
599     // back. This is the compiler's defense against contract upgrades and
600     // pointer aliasing, and it cannot be disabled.
601 
602     // The values being non-zero value makes deployment a bit more expensive,
603     // but in exchange the refund on every call to nonReentrant will be lower in
604     // amount. Since refunds are capped to a percentage of the total
605     // transaction's gas, it is best to keep them low in cases like this one, to
606     // increase the likelihood of the full refund coming into effect.
607     uint256 private constant _NOT_ENTERED = 1;
608     uint256 private constant _ENTERED = 2;
609 
610     uint256 private _status;
611 
612     constructor () {
613         _status = _NOT_ENTERED;
614     }
615 
616     /**
617      * @dev Prevents a contract from calling itself, directly or indirectly.
618      * Calling a `nonReentrant` function from another `nonReentrant`
619      * function is not supported. It is possible to prevent this from happening
620      * by making the `nonReentrant` function external, and make it call a
621      * `private` function that does the actual work.
622      */
623     modifier nonReentrant() {
624         // On the first call to nonReentrant, _notEntered will be true
625         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
626 
627         // Any calls to nonReentrant after this point will fail
628         _status = _ENTERED;
629 
630         _;
631 
632         // By storing the original value once again, a refund is triggered (see
633         // https://eips.ethereum.org/EIPS/eip-2200)
634         _status = _NOT_ENTERED;
635     }
636 }
637 
638 
639 // https://docs.synthetix.io/contracts/source/interfaces/istakingrewards
640 interface IStakingRewards {
641     // Views
642     function lastTimeRewardApplicable() external view returns (uint256);
643 
644     function rewardPerToken() external view returns (uint256);
645 
646     function earned(address account) external view returns (uint256);
647 
648     function getRewardForDuration() external view returns (uint256);
649 
650     function totalSupply() external view returns (uint256);
651 
652     function balanceOf(address account) external view returns (uint256);
653 
654     // Mutative
655 
656     function stake(uint256 amount) external;
657 
658     function withdraw(uint256 amount) external;
659 
660     function getReward() external;
661 
662     function exit() external;
663 }
664 
665 
666 // https://docs.synthetix.io/contracts/source/contracts/owned
667 contract Owned {
668     address public owner;
669     address public nominatedOwner;
670 
671     constructor(address _owner) public {
672         require(_owner != address(0), "Owner address cannot be 0");
673         owner = _owner;
674         emit OwnerChanged(address(0), _owner);
675     }
676 
677     function nominateNewOwner(address _owner) external onlyOwner {
678         nominatedOwner = _owner;
679         emit OwnerNominated(_owner);
680     }
681 
682     function acceptOwnership() external {
683         require(
684             msg.sender == nominatedOwner,
685             "You must be nominated before you can accept ownership"
686         );
687         emit OwnerChanged(owner, nominatedOwner);
688         owner = nominatedOwner;
689         nominatedOwner = address(0);
690     }
691 
692     modifier onlyOwner {
693         _onlyOwner();
694         _;
695     }
696 
697     function _onlyOwner() private view {
698         require(
699             msg.sender == owner,
700             "Only the contract owner may perform this action"
701         );
702     }
703 
704     event OwnerNominated(address newOwner);
705     event OwnerChanged(address oldOwner, address newOwner);
706 }
707 
708 
709 // https://docs.synthetix.io/contracts/source/contracts/rewardsdistributionrecipient
710 abstract contract RewardsDistributionRecipient is Owned {
711     address public rewardsDistribution;
712 
713     function notifyRewardAmount(uint256 reward) external virtual;
714 
715     modifier onlyRewardsDistribution() {
716         require(
717             msg.sender == rewardsDistribution,
718             "Caller is not RewardsDistribution contract"
719         );
720         _;
721     }
722 
723     function setRewardsDistribution(address _rewardsDistribution)
724         external
725         onlyOwner
726     {
727         rewardsDistribution = _rewardsDistribution;
728     }
729 }
730 
731 
732 
733 // https://docs.synthetix.io/contracts/source/contracts/pausable
734 abstract contract Pausable is Owned {
735     uint256 public lastPauseTime;
736     bool public paused;
737 
738     constructor() internal {
739         // This contract is abstract, and thus cannot be instantiated directly
740         require(owner != address(0), "Owner must be set");
741         // Paused will be false, and lastPauseTime will be 0 upon initialisation
742     }
743 
744     /**
745      * @notice Change the paused state of the contract
746      * @dev Only the contract owner may call this.
747      */
748     function setPaused(bool _paused) external onlyOwner {
749         // Ensure we're actually changing the state before we do anything
750         if (_paused == paused) {
751             return;
752         }
753 
754         // Set our paused state.
755         paused = _paused;
756 
757         // If applicable, set the last pause time.
758         if (paused) {
759             lastPauseTime = block.timestamp;
760         }
761 
762         // Let everyone know that our pause state has changed.
763         emit PauseChanged(paused);
764     }
765 
766     event PauseChanged(bool isPaused);
767 
768     modifier notPaused {
769         require(
770             !paused,
771             "This action cannot be performed while the contract is paused"
772         );
773         _;
774     }
775 }
776 
777 
778 // https://docs.synthetix.io/contracts/source/contracts/stakingrewards
779 contract StakingRewards is
780     IStakingRewards,
781     RewardsDistributionRecipient,
782     ReentrancyGuard,
783     Pausable
784 {
785     using SafeMath for uint256;
786     using SafeERC20 for IERC20;
787 
788     /* ========== STATE VARIABLES ========== */
789 
790     IERC20 public rewardsToken;
791     IERC20 public stakingToken;
792     uint256 public periodFinish = 0;
793     uint256 public rewardRate = 0;
794     uint256 public rewardsDuration = 28 days;
795     uint256 public lastUpdateTime;
796     uint256 public rewardPerTokenStored;
797 
798     // timestamp dictating at what time of week to release rewards
799     // (ex: 1619226000 is Sat Apr 24 2021 01:00:00 GMT+0000 which will release as 1 am every saturday)
800     uint256 public startEmission;
801 
802     mapping(address => uint256) public userRewardPerTokenPaid;
803     mapping(address => uint256) public rewards;
804 
805     uint256 private _totalSupply;
806     mapping(address => uint256) private _balances;
807 
808     /* ========== CONSTRUCTOR ========== */
809 
810     constructor(
811         address _owner,
812         address _rewardsDistribution,
813         address _rewardsToken,
814         address _stakingToken,
815         uint256 _startEmission
816     ) public Owned(_owner) {
817         require(_owner != address(0), "Owner must be non-zero address");
818         require(
819             _rewardsToken != address(0),
820             "Rewards token must be non-zero address"
821         );
822         require(
823             _stakingToken != address(0),
824             "Staking token must be non-zero address"
825         );
826         require(
827             _rewardsDistribution != address(0),
828             "Rewards Distributor must be non-zero address"
829         );
830         require(
831             _startEmission > block.timestamp,
832             "Start Emission must be in the future"
833         );
834 
835         rewardsToken = IERC20(_rewardsToken);
836         stakingToken = IERC20(_stakingToken);
837         rewardsDistribution = _rewardsDistribution;
838         startEmission = _startEmission;
839     }
840 
841     /* ========== VIEWS ========== */
842 
843     function totalSupply() external view override returns (uint256) {
844         return _totalSupply;
845     }
846 
847     function balanceOf(address account)
848         external
849         view
850         override
851         returns (uint256)
852     {
853         return _balances[account];
854     }
855 
856     // The minimum between periodFinish and the last instance of the current startEmission release time
857     function lastTimeRewardApplicable() public view override returns (uint256) {
858         return
859             Math.min(
860                 _numWeeksPassed(block.timestamp).mul(1 weeks).add(startEmission),
861                 periodFinish
862             );
863     }
864 
865     function rewardPerToken() public view override returns (uint256) {
866         if (_totalSupply == 0) {
867             return rewardPerTokenStored;
868         }
869 
870         return
871             rewardPerTokenStored.add(
872                 lastTimeRewardApplicable()
873                     .sub(lastUpdateTime)
874                     .mul(rewardRate)
875                     .mul(1e18)
876                     .div(_totalSupply)
877             );
878     }
879 
880     function earned(address account) public view override returns (uint256) {
881         return
882             _balances[account]
883                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
884                 .div(1e18)
885                 .add(rewards[account]);
886     }
887 
888     function getRewardForDuration() external view override returns (uint256) {
889         return rewardRate.mul(rewardsDuration);
890     }
891 
892     /* ========== MUTATIVE FUNCTIONS ========== */
893 
894     function stake(uint256 amount)
895         external
896         override
897         nonReentrant
898         notPaused
899         updateReward(msg.sender)
900     {
901         require(amount > 0, "Cannot stake 0");
902         _totalSupply = _totalSupply.add(amount);
903         _balances[msg.sender] = _balances[msg.sender].add(amount);
904         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
905         emit Staked(msg.sender, amount);
906     }
907 
908     function withdraw(uint256 amount)
909         public
910         override
911         nonReentrant
912         updateReward(msg.sender)
913     {
914         require(amount > 0, "Cannot withdraw 0");
915         _totalSupply = _totalSupply.sub(amount);
916         _balances[msg.sender] = _balances[msg.sender].sub(amount);
917         if(block.timestamp < periodFinish.add(1 days)){
918           rewards[msg.sender] = 0;
919         }
920         stakingToken.safeTransfer(msg.sender, amount);
921         emit Withdrawn(msg.sender, amount);
922     }
923 
924     function getReward() public override nonReentrant updateReward(msg.sender) {
925         uint256 reward = block.timestamp >= periodFinish.add(1 days) ? rewards[msg.sender] : 0;
926         if (reward > 0) {
927             rewards[msg.sender] = 0;
928             rewardsToken.safeTransfer(msg.sender, Math.min(reward, rewardsToken.balanceOf(address(this))));
929             emit RewardPaid(msg.sender, reward);
930         }
931     }
932 
933     function exit() external override {
934         withdraw(_balances[msg.sender]);
935         getReward();
936     }
937 
938     function _numWeeksPassed(uint256 time) internal view returns (uint256) {
939         if (time < startEmission) {
940             return 0;
941         }
942         return time.sub(startEmission).div(1 weeks).add(1);
943     }
944 
945     /* ========== RESTRICTED FUNCTIONS ========== */
946 
947     function notifyRewardAmount(uint256 reward)
948         external
949         override
950         onlyRewardsDistribution
951         updateReward(address(0))
952     {
953         if (block.timestamp >= periodFinish) {
954             rewardRate = reward.div(rewardsDuration);
955         } else {
956             uint256 remaining = periodFinish.sub(block.timestamp);
957             uint256 leftover = remaining.mul(rewardRate);
958             rewardRate = reward.add(leftover).div(rewardsDuration);
959         }
960 
961         // Ensure the provided reward amount is not more than the balance in the contract.
962         // This keeps the reward rate in the right range, preventing overflows due to
963         // very high values of rewardRate in the earned and rewardsPerToken functions;
964         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
965         uint256 balance = rewardsToken.balanceOf(address(this));
966         require(
967             rewardRate <= balance.div(rewardsDuration),
968             "Provided reward too high"
969         );
970 
971         periodFinish = startEmission.add(rewardsDuration);
972         lastUpdateTime = lastTimeRewardApplicable();
973         emit RewardAdded(reward);
974     }
975 
976     // End rewards emission earlier
977     function updatePeriodFinish(uint256 timestamp)
978         external
979         onlyOwner
980         updateReward(address(0))
981     {
982         periodFinish = timestamp;
983     }
984 
985     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
986     function recoverERC20(address tokenAddress, uint256 tokenAmount)
987         external
988         onlyOwner
989     {
990         require(
991             tokenAddress != address(stakingToken),
992             "Cannot withdraw the staking token"
993         );
994         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
995         emit Recovered(tokenAddress, tokenAmount);
996     }
997 
998     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
999         require(
1000             block.timestamp > periodFinish,
1001             "Previous rewards period must be complete before changing the duration for the new period"
1002         );
1003         rewardsDuration = _rewardsDuration;
1004         emit RewardsDurationUpdated(rewardsDuration);
1005     }
1006 
1007     function setStartEmission(uint256 _startEmission) external onlyOwner {
1008         require(
1009             block.timestamp < _startEmission,
1010             "Start emission must be in the future"
1011         );
1012         startEmission = _startEmission;
1013         emit StartEmissionUpdated(startEmission);
1014     }
1015     /* ========== MODIFIERS ========== */
1016 
1017     modifier updateReward(address account) {
1018         rewardPerTokenStored = rewardPerToken();
1019         lastUpdateTime = lastTimeRewardApplicable();
1020         if (account != address(0)) {
1021             rewards[account] = earned(account);
1022             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1023         }
1024         _;
1025     }
1026 
1027     /* ========== EVENTS ========== */
1028 
1029     event RewardAdded(uint256 reward);
1030     event Staked(address indexed user, uint256 amount);
1031     event Withdrawn(address indexed user, uint256 amount);
1032     event RewardPaid(address indexed user, uint256 reward);
1033     event RewardsDurationUpdated(uint256 newDuration);
1034     event StartEmissionUpdated(uint256 StartEmissionUpdated);
1035     event Recovered(address token, uint256 amount);
1036 }