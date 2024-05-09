1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: MIT
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
567 // File: solidity/contracts/converter/ConverterVersion.sol
568 
569 
570 pragma solidity 0.6.12;
571 
572 contract ConverterVersion {
573     uint16 public constant version = 46;
574 }
575 
576 // File: solidity/contracts/utility/interfaces/IOwned.sol
577 
578 
579 pragma solidity 0.6.12;
580 
581 /*
582     Owned contract interface
583 */
584 interface IOwned {
585     // this function isn't since the compiler emits automatically generated getter functions as external
586     function owner() external view returns (address);
587 
588     function transferOwnership(address _newOwner) external;
589 
590     function acceptOwnership() external;
591 }
592 
593 // File: solidity/contracts/converter/interfaces/IConverterAnchor.sol
594 
595 
596 pragma solidity 0.6.12;
597 
598 
599 /*
600     Converter Anchor interface
601 */
602 interface IConverterAnchor is IOwned {
603 
604 }
605 
606 // File: solidity/contracts/converter/interfaces/IConverter.sol
607 
608 
609 pragma solidity 0.6.12;
610 
611 
612 
613 
614 /*
615     Converter interface
616 */
617 interface IConverter is IOwned {
618     function converterType() external pure returns (uint16);
619 
620     function anchor() external view returns (IConverterAnchor);
621 
622     function isActive() external view returns (bool);
623 
624     function targetAmountAndFee(
625         IERC20 _sourceToken,
626         IERC20 _targetToken,
627         uint256 _amount
628     ) external view returns (uint256, uint256);
629 
630     function convert(
631         IERC20 _sourceToken,
632         IERC20 _targetToken,
633         uint256 _amount,
634         address _trader,
635         address payable _beneficiary
636     ) external payable returns (uint256);
637 
638     function conversionFee() external view returns (uint32);
639 
640     function maxConversionFee() external view returns (uint32);
641 
642     function reserveBalance(IERC20 _reserveToken) external view returns (uint256);
643 
644     receive() external payable;
645 
646     function transferAnchorOwnership(address _newOwner) external;
647 
648     function acceptAnchorOwnership() external;
649 
650     function setConversionFee(uint32 _conversionFee) external;
651 
652     function addReserve(IERC20 _token, uint32 _weight) external;
653 
654     function transferReservesOnUpgrade(address _newConverter) external;
655 
656     function onUpgradeComplete() external;
657 
658     // deprecated, backward compatibility
659     function token() external view returns (IConverterAnchor);
660 
661     function transferTokenOwnership(address _newOwner) external;
662 
663     function acceptTokenOwnership() external;
664 
665     function connectors(IERC20 _address)
666         external
667         view
668         returns (
669             uint256,
670             uint32,
671             bool,
672             bool,
673             bool
674         );
675 
676     function getConnectorBalance(IERC20 _connectorToken) external view returns (uint256);
677 
678     function connectorTokens(uint256 _index) external view returns (IERC20);
679 
680     function connectorTokenCount() external view returns (uint16);
681 
682     /**
683      * @dev triggered when the converter is activated
684      *
685      * @param _type        converter type
686      * @param _anchor      converter anchor
687      * @param _activated   true if the converter was activated, false if it was deactivated
688      */
689     event Activation(uint16 indexed _type, IConverterAnchor indexed _anchor, bool indexed _activated);
690 
691     /**
692      * @dev triggered when a conversion between two tokens occurs
693      *
694      * @param _fromToken       source ERC20 token
695      * @param _toToken         target ERC20 token
696      * @param _trader          wallet that initiated the trade
697      * @param _amount          input amount in units of the source token
698      * @param _return          output amount minus conversion fee in units of the target token
699      * @param _conversionFee   conversion fee in units of the target token
700      */
701     event Conversion(
702         IERC20 indexed _fromToken,
703         IERC20 indexed _toToken,
704         address indexed _trader,
705         uint256 _amount,
706         uint256 _return,
707         int256 _conversionFee
708     );
709 
710     /**
711      * @dev triggered when the rate between two tokens in the converter changes
712      * note that the event might be dispatched for rate updates between any two tokens in the converter
713      *
714      * @param  _token1 address of the first token
715      * @param  _token2 address of the second token
716      * @param  _rateN  rate of 1 unit of `_token1` in `_token2` (numerator)
717      * @param  _rateD  rate of 1 unit of `_token1` in `_token2` (denominator)
718      */
719     event TokenRateUpdate(IERC20 indexed _token1, IERC20 indexed _token2, uint256 _rateN, uint256 _rateD);
720 
721     /**
722      * @dev triggered when the conversion fee is updated
723      *
724      * @param  _prevFee    previous fee percentage, represented in ppm
725      * @param  _newFee     new fee percentage, represented in ppm
726      */
727     event ConversionFeeUpdate(uint32 _prevFee, uint32 _newFee);
728 }
729 
730 // File: solidity/contracts/converter/interfaces/IConverterUpgrader.sol
731 
732 
733 pragma solidity 0.6.12;
734 
735 /*
736     Converter Upgrader interface
737 */
738 interface IConverterUpgrader {
739     function upgrade(bytes32 _version) external;
740 
741     function upgrade(uint16 _version) external;
742 }
743 
744 // File: solidity/contracts/utility/interfaces/ITokenHolder.sol
745 
746 
747 pragma solidity 0.6.12;
748 
749 
750 
751 /*
752     Token Holder interface
753 */
754 interface ITokenHolder is IOwned {
755     receive() external payable;
756 
757     function withdrawTokens(
758         IERC20 token,
759         address payable to,
760         uint256 amount
761     ) external;
762 
763     function withdrawTokensMultiple(
764         IERC20[] calldata tokens,
765         address payable to,
766         uint256[] calldata amounts
767     ) external;
768 }
769 
770 // File: solidity/contracts/INetworkSettings.sol
771 
772 
773 pragma solidity 0.6.12;
774 
775 
776 interface INetworkSettings {
777     function networkFeeParams() external view returns (ITokenHolder, uint32);
778 
779     function networkFeeWallet() external view returns (ITokenHolder);
780 
781     function networkFee() external view returns (uint32);
782 }
783 
784 // File: solidity/contracts/token/interfaces/IDSToken.sol
785 
786 
787 pragma solidity 0.6.12;
788 
789 
790 
791 
792 /*
793     DSToken interface
794 */
795 interface IDSToken is IConverterAnchor, IERC20 {
796     function issue(address _to, uint256 _amount) external;
797 
798     function destroy(address _from, uint256 _amount) external;
799 }
800 
801 // File: solidity/contracts/utility/MathEx.sol
802 
803 
804 pragma solidity 0.6.12;
805 
806 /**
807  * @dev This library provides a set of complex math operations.
808  */
809 library MathEx {
810     uint256 private constant MAX_EXP_BIT_LEN = 4;
811     uint256 private constant MAX_EXP = 2**MAX_EXP_BIT_LEN - 1;
812     uint256 private constant MAX_UINT128 = 2**128 - 1;
813 
814     /**
815      * @dev returns the largest integer smaller than or equal to the square root of a positive integer
816      *
817      * @param _num a positive integer
818      *
819      * @return the largest integer smaller than or equal to the square root of the positive integer
820      */
821     function floorSqrt(uint256 _num) internal pure returns (uint256) {
822         uint256 x = _num / 2 + 1;
823         uint256 y = (x + _num / x) / 2;
824         while (x > y) {
825             x = y;
826             y = (x + _num / x) / 2;
827         }
828         return x;
829     }
830 
831     /**
832      * @dev returns the smallest integer larger than or equal to the square root of a positive integer
833      *
834      * @param _num a positive integer
835      *
836      * @return the smallest integer larger than or equal to the square root of the positive integer
837      */
838     function ceilSqrt(uint256 _num) internal pure returns (uint256) {
839         uint256 x = floorSqrt(_num);
840         return x * x == _num ? x : x + 1;
841     }
842 
843     /**
844      * @dev computes a powered ratio
845      *
846      * @param _n   ratio numerator
847      * @param _d   ratio denominator
848      * @param _exp ratio exponent
849      *
850      * @return powered ratio's numerator and denominator
851      */
852     function poweredRatio(
853         uint256 _n,
854         uint256 _d,
855         uint256 _exp
856     ) internal pure returns (uint256, uint256) {
857         require(_exp <= MAX_EXP, "ERR_EXP_TOO_LARGE");
858 
859         uint256[MAX_EXP_BIT_LEN] memory ns;
860         uint256[MAX_EXP_BIT_LEN] memory ds;
861 
862         (ns[0], ds[0]) = reducedRatio(_n, _d, MAX_UINT128);
863         for (uint256 i = 0; (_exp >> i) > 1; i++) {
864             (ns[i + 1], ds[i + 1]) = reducedRatio(ns[i] ** 2, ds[i] ** 2, MAX_UINT128);
865         }
866 
867         uint256 n = 1;
868         uint256 d = 1;
869 
870         for (uint256 i = 0; (_exp >> i) > 0; i++) {
871             if (((_exp >> i) & 1) > 0) {
872                 (n, d) = reducedRatio(n * ns[i], d * ds[i], MAX_UINT128);
873             }
874         }
875 
876         return (n, d);
877     }
878 
879     /**
880      * @dev computes a reduced-scalar ratio
881      *
882      * @param _n   ratio numerator
883      * @param _d   ratio denominator
884      * @param _max maximum desired scalar
885      *
886      * @return ratio's numerator and denominator
887      */
888     function reducedRatio(
889         uint256 _n,
890         uint256 _d,
891         uint256 _max
892     ) internal pure returns (uint256, uint256) {
893         (uint256 n, uint256 d) = (_n, _d);
894         if (n > _max || d > _max) {
895             (n, d) = normalizedRatio(n, d, _max);
896         }
897         if (n != d) {
898             return (n, d);
899         }
900         return (1, 1);
901     }
902 
903     /**
904      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)".
905      */
906     function normalizedRatio(
907         uint256 _a,
908         uint256 _b,
909         uint256 _scale
910     ) internal pure returns (uint256, uint256) {
911         if (_a <= _b) {
912             return accurateRatio(_a, _b, _scale);
913         }
914         (uint256 y, uint256 x) = accurateRatio(_b, _a, _scale);
915         return (x, y);
916     }
917 
918     /**
919      * @dev computes "scale * a / (a + b)" and "scale * b / (a + b)", assuming that "a <= b".
920      */
921     function accurateRatio(
922         uint256 _a,
923         uint256 _b,
924         uint256 _scale
925     ) internal pure returns (uint256, uint256) {
926         uint256 maxVal = uint256(-1) / _scale;
927         if (_a > maxVal) {
928             uint256 c = _a / (maxVal + 1) + 1;
929             _a /= c; // we can now safely compute `_a * _scale`
930             _b /= c;
931         }
932         if (_a != _b) {
933             uint256 n = _a * _scale;
934             uint256 d = _a + _b; // can overflow
935             if (d >= _a) {
936                 // no overflow in `_a + _b`
937                 uint256 x = roundDiv(n, d); // we can now safely compute `_scale - x`
938                 uint256 y = _scale - x;
939                 return (x, y);
940             }
941             if (n < _b - (_b - _a) / 2) {
942                 return (0, _scale); // `_a * _scale < (_a + _b) / 2 < MAX_UINT256 < _a + _b`
943             }
944             return (1, _scale - 1); // `(_a + _b) / 2 < _a * _scale < MAX_UINT256 < _a + _b`
945         }
946         return (_scale / 2, _scale / 2); // allow reduction to `(1, 1)` in the calling function
947     }
948 
949     /**
950      * @dev computes the nearest integer to a given quotient without overflowing or underflowing.
951      */
952     function roundDiv(uint256 _n, uint256 _d) internal pure returns (uint256) {
953         return _n / _d + (_n % _d) / (_d - _d / 2);
954     }
955 
956     /**
957      * @dev returns the average number of decimal digits in a given list of positive integers
958      *
959      * @param _values  list of positive integers
960      *
961      * @return the average number of decimal digits in the given list of positive integers
962      */
963     function geometricMean(uint256[] memory _values) internal pure returns (uint256) {
964         uint256 numOfDigits = 0;
965         uint256 length = _values.length;
966         for (uint256 i = 0; i < length; i++) {
967             numOfDigits += decimalLength(_values[i]);
968         }
969         return uint256(10)**(roundDivUnsafe(numOfDigits, length) - 1);
970     }
971 
972     /**
973      * @dev returns the number of decimal digits in a given positive integer
974      *
975      * @param _x   positive integer
976      *
977      * @return the number of decimal digits in the given positive integer
978      */
979     function decimalLength(uint256 _x) internal pure returns (uint256) {
980         uint256 y = 0;
981         for (uint256 x = _x; x > 0; x /= 10) {
982             y++;
983         }
984         return y;
985     }
986 
987     /**
988      * @dev returns the nearest integer to a given quotient
989      * the computation is overflow-safe assuming that the input is sufficiently small
990      *
991      * @param _n   quotient numerator
992      * @param _d   quotient denominator
993      *
994      * @return the nearest integer to the given quotient
995      */
996     function roundDivUnsafe(uint256 _n, uint256 _d) internal pure returns (uint256) {
997         return (_n + _d / 2) / _d;
998     }
999 
1000     /**
1001      * @dev returns the larger of two values
1002      *
1003      * @param _val1 the first value
1004      * @param _val2 the second value
1005      */
1006     function max(uint256 _val1, uint256 _val2) internal pure returns (uint256) {
1007         return _val1 > _val2 ? _val1 : _val2;
1008     }
1009 }
1010 
1011 // File: solidity/contracts/utility/Owned.sol
1012 
1013 
1014 pragma solidity 0.6.12;
1015 
1016 
1017 /**
1018  * @dev This contract provides support and utilities for contract ownership.
1019  */
1020 contract Owned is IOwned {
1021     address public override owner;
1022     address public newOwner;
1023 
1024     /**
1025      * @dev triggered when the owner is updated
1026      *
1027      * @param _prevOwner previous owner
1028      * @param _newOwner  new owner
1029      */
1030     event OwnerUpdate(address indexed _prevOwner, address indexed _newOwner);
1031 
1032     /**
1033      * @dev initializes a new Owned instance
1034      */
1035     constructor() public {
1036         owner = msg.sender;
1037     }
1038 
1039     // allows execution by the owner only
1040     modifier ownerOnly {
1041         _ownerOnly();
1042         _;
1043     }
1044 
1045     // error message binary size optimization
1046     function _ownerOnly() internal view {
1047         require(msg.sender == owner, "ERR_ACCESS_DENIED");
1048     }
1049 
1050     /**
1051      * @dev allows transferring the contract ownership
1052      * the new owner still needs to accept the transfer
1053      * can only be called by the contract owner
1054      *
1055      * @param _newOwner    new contract owner
1056      */
1057     function transferOwnership(address _newOwner) public override ownerOnly {
1058         require(_newOwner != owner, "ERR_SAME_OWNER");
1059         newOwner = _newOwner;
1060     }
1061 
1062     /**
1063      * @dev used by a new owner to accept an ownership transfer
1064      */
1065     function acceptOwnership() public override {
1066         require(msg.sender == newOwner, "ERR_ACCESS_DENIED");
1067         emit OwnerUpdate(owner, newOwner);
1068         owner = newOwner;
1069         newOwner = address(0);
1070     }
1071 }
1072 
1073 // File: solidity/contracts/utility/Utils.sol
1074 
1075 
1076 pragma solidity 0.6.12;
1077 
1078 
1079 /**
1080  * @dev Utilities & Common Modifiers
1081  */
1082 contract Utils {
1083     uint32 internal constant PPM_RESOLUTION = 1000000;
1084     IERC20 internal constant NATIVE_TOKEN_ADDRESS = IERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);
1085 
1086     // verifies that a value is greater than zero
1087     modifier greaterThanZero(uint256 _value) {
1088         _greaterThanZero(_value);
1089         _;
1090     }
1091 
1092     // error message binary size optimization
1093     function _greaterThanZero(uint256 _value) internal pure {
1094         require(_value > 0, "ERR_ZERO_VALUE");
1095     }
1096 
1097     // validates an address - currently only checks that it isn't null
1098     modifier validAddress(address _address) {
1099         _validAddress(_address);
1100         _;
1101     }
1102 
1103     // error message binary size optimization
1104     function _validAddress(address _address) internal pure {
1105         require(_address != address(0), "ERR_INVALID_ADDRESS");
1106     }
1107 
1108     // ensures that the portion is valid
1109     modifier validPortion(uint32 _portion) {
1110         _validPortion(_portion);
1111         _;
1112     }
1113 
1114     // error message binary size optimization
1115     function _validPortion(uint32 _portion) internal pure {
1116         require(_portion > 0 && _portion <= PPM_RESOLUTION, "ERR_INVALID_PORTION");
1117     }
1118 
1119     // validates an external address - currently only checks that it isn't null or this
1120     modifier validExternalAddress(address _address) {
1121         _validExternalAddress(_address);
1122         _;
1123     }
1124 
1125     // error message binary size optimization
1126     function _validExternalAddress(address _address) internal view {
1127         require(_address != address(0) && _address != address(this), "ERR_INVALID_EXTERNAL_ADDRESS");
1128     }
1129 
1130     // ensures that the fee is valid
1131     modifier validFee(uint32 fee) {
1132         _validFee(fee);
1133         _;
1134     }
1135 
1136     // error message binary size optimization
1137     function _validFee(uint32 fee) internal pure {
1138         require(fee <= PPM_RESOLUTION, "ERR_INVALID_FEE");
1139     }
1140 }
1141 
1142 // File: solidity/contracts/utility/interfaces/IContractRegistry.sol
1143 
1144 
1145 pragma solidity 0.6.12;
1146 
1147 /*
1148     Contract Registry interface
1149 */
1150 interface IContractRegistry {
1151     function addressOf(bytes32 _contractName) external view returns (address);
1152 }
1153 
1154 // File: solidity/contracts/utility/ContractRegistryClient.sol
1155 
1156 
1157 pragma solidity 0.6.12;
1158 
1159 
1160 
1161 
1162 /**
1163  * @dev This is the base contract for ContractRegistry clients.
1164  */
1165 contract ContractRegistryClient is Owned, Utils {
1166     bytes32 internal constant CONTRACT_REGISTRY = "ContractRegistry";
1167     bytes32 internal constant BANCOR_NETWORK = "BancorNetwork";
1168     bytes32 internal constant BANCOR_FORMULA = "BancorFormula";
1169     bytes32 internal constant CONVERTER_FACTORY = "ConverterFactory";
1170     bytes32 internal constant CONVERSION_PATH_FINDER = "ConversionPathFinder";
1171     bytes32 internal constant CONVERTER_UPGRADER = "BancorConverterUpgrader";
1172     bytes32 internal constant CONVERTER_REGISTRY = "BancorConverterRegistry";
1173     bytes32 internal constant CONVERTER_REGISTRY_DATA = "BancorConverterRegistryData";
1174     bytes32 internal constant BNT_TOKEN = "BNTToken";
1175     bytes32 internal constant BANCOR_X = "BancorX";
1176     bytes32 internal constant BANCOR_X_UPGRADER = "BancorXUpgrader";
1177     bytes32 internal constant LIQUIDITY_PROTECTION = "LiquidityProtection";
1178     bytes32 internal constant NETWORK_SETTINGS = "NetworkSettings";
1179 
1180     IContractRegistry public registry; // address of the current contract-registry
1181     IContractRegistry public prevRegistry; // address of the previous contract-registry
1182     bool public onlyOwnerCanUpdateRegistry; // only an owner can update the contract-registry
1183 
1184     /**
1185      * @dev verifies that the caller is mapped to the given contract name
1186      *
1187      * @param _contractName    contract name
1188      */
1189     modifier only(bytes32 _contractName) {
1190         _only(_contractName);
1191         _;
1192     }
1193 
1194     // error message binary size optimization
1195     function _only(bytes32 _contractName) internal view {
1196         require(msg.sender == addressOf(_contractName), "ERR_ACCESS_DENIED");
1197     }
1198 
1199     /**
1200      * @dev initializes a new ContractRegistryClient instance
1201      *
1202      * @param  _registry   address of a contract-registry contract
1203      */
1204     constructor(IContractRegistry _registry) internal validAddress(address(_registry)) {
1205         registry = IContractRegistry(_registry);
1206         prevRegistry = IContractRegistry(_registry);
1207     }
1208 
1209     /**
1210      * @dev updates to the new contract-registry
1211      */
1212     function updateRegistry() public {
1213         // verify that this function is permitted
1214         require(msg.sender == owner || !onlyOwnerCanUpdateRegistry, "ERR_ACCESS_DENIED");
1215 
1216         // get the new contract-registry
1217         IContractRegistry newRegistry = IContractRegistry(addressOf(CONTRACT_REGISTRY));
1218 
1219         // verify that the new contract-registry is different and not zero
1220         require(newRegistry != registry && address(newRegistry) != address(0), "ERR_INVALID_REGISTRY");
1221 
1222         // verify that the new contract-registry is pointing to a non-zero contract-registry
1223         require(newRegistry.addressOf(CONTRACT_REGISTRY) != address(0), "ERR_INVALID_REGISTRY");
1224 
1225         // save a backup of the current contract-registry before replacing it
1226         prevRegistry = registry;
1227 
1228         // replace the current contract-registry with the new contract-registry
1229         registry = newRegistry;
1230     }
1231 
1232     /**
1233      * @dev restores the previous contract-registry
1234      */
1235     function restoreRegistry() public ownerOnly {
1236         // restore the previous contract-registry
1237         registry = prevRegistry;
1238     }
1239 
1240     /**
1241      * @dev restricts the permission to update the contract-registry
1242      *
1243      * @param _onlyOwnerCanUpdateRegistry  indicates whether or not permission is restricted to owner only
1244      */
1245     function restrictRegistryUpdate(bool _onlyOwnerCanUpdateRegistry) public ownerOnly {
1246         // change the permission to update the contract-registry
1247         onlyOwnerCanUpdateRegistry = _onlyOwnerCanUpdateRegistry;
1248     }
1249 
1250     /**
1251      * @dev returns the address associated with the given contract name
1252      *
1253      * @param _contractName    contract name
1254      *
1255      * @return contract address
1256      */
1257     function addressOf(bytes32 _contractName) internal view returns (address) {
1258         return registry.addressOf(_contractName);
1259     }
1260 }
1261 
1262 // File: solidity/contracts/utility/ReentrancyGuard.sol
1263 
1264 
1265 pragma solidity 0.6.12;
1266 
1267 /**
1268  * @dev This contract provides protection against calling a function
1269  * (directly or indirectly) from within itself.
1270  */
1271 contract ReentrancyGuard {
1272     uint256 private constant UNLOCKED = 1;
1273     uint256 private constant LOCKED = 2;
1274 
1275     // LOCKED while protected code is being executed, UNLOCKED otherwise
1276     uint256 private state = UNLOCKED;
1277 
1278     /**
1279      * @dev ensures instantiation only by sub-contracts
1280      */
1281     constructor() internal {}
1282 
1283     // protects a function against reentrancy attacks
1284     modifier protected() {
1285         _protected();
1286         state = LOCKED;
1287         _;
1288         state = UNLOCKED;
1289     }
1290 
1291     // error message binary size optimization
1292     function _protected() internal view {
1293         require(state == UNLOCKED, "ERR_REENTRANCY");
1294     }
1295 }
1296 
1297 // File: solidity/contracts/utility/Time.sol
1298 
1299 
1300 pragma solidity 0.6.12;
1301 
1302 /*
1303     Time implementing contract
1304 */
1305 contract Time {
1306     /**
1307      * @dev returns the current time
1308      */
1309     function time() internal view virtual returns (uint256) {
1310         return block.timestamp;
1311     }
1312 }
1313 
1314 // File: solidity/contracts/converter/types/standard-pool/StandardPoolConverter.sol
1315 
1316 
1317 pragma solidity 0.6.12;
1318 
1319 
1320 
1321 
1322 
1323 
1324 
1325 
1326 
1327 
1328 
1329 
1330 
1331 /**
1332  * @dev This contract is a specialized version of the converter, which is
1333  * optimized for a liquidity pool that has 2 reserves with 50%/50% weights.
1334  */
1335 contract StandardPoolConverter is ConverterVersion, IConverter, ContractRegistryClient, ReentrancyGuard, Time {
1336     using SafeMath for uint256;
1337     using SafeERC20 for IERC20;
1338     using MathEx for *;
1339 
1340     uint256 private constant MAX_UINT128 = 2**128 - 1;
1341     uint256 private constant MAX_UINT112 = 2**112 - 1;
1342     uint256 private constant MAX_UINT32 = 2**32 - 1;
1343     uint256 private constant AVERAGE_RATE_PERIOD = 10 minutes;
1344 
1345     uint256 private __reserveBalances;
1346     uint256 private _reserveBalancesProduct;
1347     IERC20[] private __reserveTokens;
1348     mapping(IERC20 => uint256) private __reserveIds;
1349 
1350     IConverterAnchor public override anchor; // converter anchor contract
1351     uint32 public override maxConversionFee; // maximum conversion fee, represented in ppm, 0...1000000
1352     uint32 public override conversionFee; // current conversion fee, represented in ppm, 0...maxConversionFee
1353 
1354     // average rate details:
1355     // bits 0...111 represent the numerator of the rate between reserve token 0 and reserve token 1
1356     // bits 111...223 represent the denominator of the rate between reserve token 0 and reserve token 1
1357     // bits 224...255 represent the update-time of the rate between reserve token 0 and reserve token 1
1358     // where `numerator / denominator` gives the worth of one reserve token 0 in units of reserve token 1
1359     uint256 public averageRateInfo;
1360 
1361     /**
1362      * @dev triggered after liquidity is added
1363      *
1364      * @param  _provider       liquidity provider
1365      * @param  _reserveToken   reserve token address
1366      * @param  _amount         reserve token amount
1367      * @param  _newBalance     reserve token new balance
1368      * @param  _newSupply      pool token new supply
1369      */
1370     event LiquidityAdded(
1371         address indexed _provider,
1372         IERC20 indexed _reserveToken,
1373         uint256 _amount,
1374         uint256 _newBalance,
1375         uint256 _newSupply
1376     );
1377 
1378     /**
1379      * @dev triggered after liquidity is removed
1380      *
1381      * @param  _provider       liquidity provider
1382      * @param  _reserveToken   reserve token address
1383      * @param  _amount         reserve token amount
1384      * @param  _newBalance     reserve token new balance
1385      * @param  _newSupply      pool token new supply
1386      */
1387     event LiquidityRemoved(
1388         address indexed _provider,
1389         IERC20 indexed _reserveToken,
1390         uint256 _amount,
1391         uint256 _newBalance,
1392         uint256 _newSupply
1393     );
1394 
1395     /**
1396      * @dev initializes a new StandardPoolConverter instance
1397      *
1398      * @param  _anchor             anchor governed by the converter
1399      * @param  _registry           address of a contract registry contract
1400      * @param  _maxConversionFee   maximum conversion fee, represented in ppm
1401      */
1402     constructor(
1403         IConverterAnchor _anchor,
1404         IContractRegistry _registry,
1405         uint32 _maxConversionFee
1406     ) public ContractRegistryClient(_registry) validAddress(address(_anchor)) validConversionFee(_maxConversionFee) {
1407         anchor = _anchor;
1408         maxConversionFee = _maxConversionFee;
1409     }
1410 
1411     // ensures that the converter is active
1412     modifier active() {
1413         _active();
1414         _;
1415     }
1416 
1417     // error message binary size optimization
1418     function _active() internal view {
1419         require(isActive(), "ERR_INACTIVE");
1420     }
1421 
1422     // ensures that the converter is not active
1423     modifier inactive() {
1424         _inactive();
1425         _;
1426     }
1427 
1428     // error message binary size optimization
1429     function _inactive() internal view {
1430         require(!isActive(), "ERR_ACTIVE");
1431     }
1432 
1433     // validates a reserve token address - verifies that the address belongs to one of the reserve tokens
1434     modifier validReserve(IERC20 _address) {
1435         _validReserve(_address);
1436         _;
1437     }
1438 
1439     // error message binary size optimization
1440     function _validReserve(IERC20 _address) internal view {
1441         require(__reserveIds[_address] != 0, "ERR_INVALID_RESERVE");
1442     }
1443 
1444     // validates conversion fee
1445     modifier validConversionFee(uint32 _conversionFee) {
1446         _validConversionFee(_conversionFee);
1447         _;
1448     }
1449 
1450     // error message binary size optimization
1451     function _validConversionFee(uint32 _conversionFee) internal pure {
1452         require(_conversionFee <= PPM_RESOLUTION, "ERR_INVALID_CONVERSION_FEE");
1453     }
1454 
1455     // validates reserve weight
1456     modifier validReserveWeight(uint32 _weight) {
1457         _validReserveWeight(_weight);
1458         _;
1459     }
1460 
1461     // error message binary size optimization
1462     function _validReserveWeight(uint32 _weight) internal pure {
1463         require(_weight == PPM_RESOLUTION / 2, "ERR_INVALID_RESERVE_WEIGHT");
1464     }
1465 
1466     /**
1467      * @dev returns the converter type
1468      *
1469      * @return see the converter types in the the main contract doc
1470      */
1471     function converterType() public pure virtual override returns (uint16) {
1472         return 3;
1473     }
1474 
1475     /**
1476      * @dev deposits ether
1477      * can only be called if the converter has an ETH reserve
1478      */
1479     receive() external payable override(IConverter) validReserve(NATIVE_TOKEN_ADDRESS) {}
1480 
1481     /**
1482      * @dev checks whether or not the converter version is 28 or higher
1483      *
1484      * @return true, since the converter version is 28 or higher
1485      */
1486     function isV28OrHigher() public pure returns (bool) {
1487         return true;
1488     }
1489 
1490     /**
1491      * @dev returns true if the converter is active, false otherwise
1492      *
1493      * @return true if the converter is active, false otherwise
1494      */
1495     function isActive() public view virtual override returns (bool) {
1496         return anchor.owner() == address(this);
1497     }
1498 
1499     /**
1500      * @dev transfers the anchor ownership
1501      * the new owner needs to accept the transfer
1502      * can only be called by the converter upgrader while the upgrader is the owner
1503      * note that prior to version 28, you should use 'transferAnchorOwnership' instead
1504      *
1505      * @param _newOwner    new token owner
1506      */
1507     function transferAnchorOwnership(address _newOwner) public override ownerOnly only(CONVERTER_UPGRADER) {
1508         anchor.transferOwnership(_newOwner);
1509     }
1510 
1511     /**
1512      * @dev accepts ownership of the anchor after an ownership transfer
1513      * most converters are also activated as soon as they accept the anchor ownership
1514      * can only be called by the contract owner
1515      * note that prior to version 28, you should use 'acceptTokenOwnership' instead
1516      */
1517     function acceptAnchorOwnership() public virtual override ownerOnly {
1518         // verify the the converter has exactly two reserves
1519         require(reserveTokenCount() == 2, "ERR_INVALID_RESERVE_COUNT");
1520         anchor.acceptOwnership();
1521         syncReserveBalances(0);
1522         emit Activation(converterType(), anchor, true);
1523     }
1524 
1525     /**
1526      * @dev updates the current conversion fee
1527      * can only be called by the contract owner
1528      *
1529      * @param _conversionFee new conversion fee, represented in ppm
1530      */
1531     function setConversionFee(uint32 _conversionFee) public override ownerOnly {
1532         require(_conversionFee <= maxConversionFee, "ERR_INVALID_CONVERSION_FEE");
1533         emit ConversionFeeUpdate(conversionFee, _conversionFee);
1534         conversionFee = _conversionFee;
1535     }
1536 
1537     /**
1538      * @dev transfers reserve balances to a new converter during an upgrade
1539      * can only be called by the converter upgraded which should be set at its owner
1540      *
1541      * @param _newConverter address of the converter to receive the new amount
1542      */
1543     function transferReservesOnUpgrade(address _newConverter)
1544         external
1545         override
1546         protected
1547         ownerOnly
1548         only(CONVERTER_UPGRADER)
1549     {
1550         uint256 reserveCount = __reserveTokens.length;
1551         for (uint256 i = 0; i < reserveCount; ++i) {
1552             IERC20 reserveToken = __reserveTokens[i];
1553 
1554             uint256 amount;
1555             if (reserveToken == NATIVE_TOKEN_ADDRESS) {
1556                 amount = address(this).balance;
1557             } else {
1558                 amount = reserveToken.balanceOf(address(this));
1559             }
1560 
1561             safeTransfer(reserveToken, _newConverter, amount);
1562 
1563             syncReserveBalance(reserveToken);
1564         }
1565     }
1566 
1567     /**
1568      * @dev upgrades the converter to the latest version
1569      * can only be called by the owner
1570      * note that the owner needs to call acceptOwnership on the new converter after the upgrade
1571      */
1572     function upgrade() public ownerOnly {
1573         IConverterUpgrader converterUpgrader = IConverterUpgrader(addressOf(CONVERTER_UPGRADER));
1574 
1575         // trigger de-activation event
1576         emit Activation(converterType(), anchor, false);
1577 
1578         transferOwnership(address(converterUpgrader));
1579         converterUpgrader.upgrade(version);
1580         acceptOwnership();
1581     }
1582 
1583     /**
1584      * @dev executed by the upgrader at the end of the upgrade process to handle custom pool logic
1585      */
1586     function onUpgradeComplete()
1587         external
1588         override
1589         protected
1590         ownerOnly
1591         only(CONVERTER_UPGRADER)
1592     {
1593         (uint256 reserveBalance0, uint256 reserveBalance1) = reserveBalances(1, 2);
1594         _reserveBalancesProduct = reserveBalance0 * reserveBalance1;
1595     }
1596 
1597     /**
1598      * @dev returns the number of reserve tokens
1599      * note that prior to version 17, you should use 'connectorTokenCount' instead
1600      *
1601      * @return number of reserve tokens
1602      */
1603     function reserveTokenCount() public view returns (uint16) {
1604         return uint16(__reserveTokens.length);
1605     }
1606 
1607     /**
1608      * @dev returns the array of reserve tokens
1609      *
1610      * @return array of reserve tokens
1611      */
1612     function reserveTokens() public view returns (IERC20[] memory) {
1613         return __reserveTokens;
1614     }
1615 
1616     /**
1617      * @dev defines a new reserve token for the converter
1618      * can only be called by the owner while the converter is inactive
1619      *
1620      * @param _token   address of the reserve token
1621      * @param _weight  reserve weight, represented in ppm, 1-1000000
1622      */
1623     function addReserve(IERC20 _token, uint32 _weight)
1624         public
1625         virtual
1626         override
1627         ownerOnly
1628         inactive
1629         validExternalAddress(address(_token))
1630         validReserveWeight(_weight)
1631     {
1632         // validate input
1633         require(address(_token) != address(anchor) && __reserveIds[_token] == 0, "ERR_INVALID_RESERVE");
1634         require(reserveTokenCount() < 2, "ERR_INVALID_RESERVE_COUNT");
1635 
1636         __reserveTokens.push(_token);
1637         __reserveIds[_token] = __reserveTokens.length;
1638     }
1639 
1640     /**
1641      * @dev returns the reserve's weight
1642      * added in version 28
1643      *
1644      * @param _reserveToken    reserve token contract address
1645      *
1646      * @return reserve weight
1647      */
1648     function reserveWeight(IERC20 _reserveToken) public view validReserve(_reserveToken) returns (uint32) {
1649         return PPM_RESOLUTION / 2;
1650     }
1651 
1652     /**
1653      * @dev returns the balance of a given reserve token
1654      *
1655      * @param _reserveToken    reserve token contract address
1656      *
1657      * @return the balance of the given reserve token
1658      */
1659     function reserveBalance(IERC20 _reserveToken) public view override returns (uint256) {
1660         uint256 reserveId = __reserveIds[_reserveToken];
1661         require(reserveId != 0, "ERR_INVALID_RESERVE");
1662         return reserveBalance(reserveId);
1663     }
1664 
1665     /**
1666      * @dev returns the balances of both reserve tokens
1667      *
1668      * @return the balances of both reserve tokens
1669      */
1670     function reserveBalances() public view returns (uint256, uint256) {
1671         return reserveBalances(1, 2);
1672     }
1673 
1674     /**
1675      * @dev syncs all stored reserve balances
1676      */
1677     function syncReserveBalances() external {
1678         syncReserveBalances(0);
1679     }
1680 
1681     /**
1682      * @dev calculates the accumulated network fee and transfers it to the network fee wallet
1683      */
1684     function processNetworkFees() external protected {
1685         (uint256 reserveBalance0, uint256 reserveBalance1) = processNetworkFees(0);
1686         _reserveBalancesProduct = reserveBalance0 * reserveBalance1;
1687     }
1688 
1689     /**
1690      * @dev calculates the accumulated network fee and transfers it to the network fee wallet
1691      *
1692      * @param _value amount of ether to exclude from the ether reserve balance (if relevant)
1693      *
1694      * @return new reserve balances
1695      */
1696     function processNetworkFees(uint256 _value) internal returns (uint256, uint256) {
1697         syncReserveBalances(_value);
1698         (uint256 reserveBalance0, uint256 reserveBalance1) = reserveBalances(1, 2);
1699         (ITokenHolder wallet, uint256 fee0, uint256 fee1) = networkWalletAndFees(reserveBalance0, reserveBalance1);
1700         reserveBalance0 -= fee0;
1701         reserveBalance1 -= fee1;
1702         setReserveBalances(1, 2, reserveBalance0, reserveBalance1);
1703         safeTransfer(__reserveTokens[0], address(wallet), fee0);
1704         safeTransfer(__reserveTokens[1], address(wallet), fee1);
1705         return (reserveBalance0, reserveBalance1);
1706     }
1707 
1708     /**
1709      * @dev returns the reserve balances of the given reserve tokens minus their corresponding fees
1710      *
1711      * @param _reserveTokens reserve tokens
1712      *
1713      * @return reserve balances minus their corresponding fees
1714      */
1715     function baseReserveBalances(IERC20[] memory _reserveTokens) internal view returns (uint256[2] memory) {
1716         uint256 reserveId0 = __reserveIds[_reserveTokens[0]];
1717         uint256 reserveId1 = __reserveIds[_reserveTokens[1]];
1718         (uint256 reserveBalance0, uint256 reserveBalance1) = reserveBalances(reserveId0, reserveId1);
1719         (, uint256 fee0, uint256 fee1) = networkWalletAndFees(reserveBalance0, reserveBalance1);
1720         return [reserveBalance0 - fee0, reserveBalance1 - fee1];
1721     }
1722 
1723     /**
1724      * @dev converts a specific amount of source tokens to target tokens
1725      * can only be called by the bancor network contract
1726      *
1727      * @param _sourceToken source ERC20 token
1728      * @param _targetToken target ERC20 token
1729      * @param _amount      amount of tokens to convert (in units of the source token)
1730      * @param _trader      address of the caller who executed the conversion
1731      * @param _beneficiary wallet to receive the conversion result
1732      *
1733      * @return amount of tokens received (in units of the target token)
1734      */
1735     function convert(
1736         IERC20 _sourceToken,
1737         IERC20 _targetToken,
1738         uint256 _amount,
1739         address _trader,
1740         address payable _beneficiary
1741     ) public payable override protected only(BANCOR_NETWORK) returns (uint256) {
1742         // validate input
1743         require(_sourceToken != _targetToken, "ERR_SAME_SOURCE_TARGET");
1744 
1745         return doConvert(_sourceToken, _targetToken, _amount, _trader, _beneficiary);
1746     }
1747 
1748     /**
1749      * @dev returns the conversion fee for a given target amount
1750      *
1751      * @param _targetAmount  target amount
1752      *
1753      * @return conversion fee
1754      */
1755     function calculateFee(uint256 _targetAmount) internal view returns (uint256) {
1756         return _targetAmount.mul(conversionFee) / PPM_RESOLUTION;
1757     }
1758 
1759     /**
1760      * @dev returns the conversion fee taken from a given target amount
1761      *
1762      * @param _targetAmount  target amount
1763      *
1764      * @return conversion fee
1765      */
1766     function calculateFeeInv(uint256 _targetAmount) internal view returns (uint256) {
1767         return _targetAmount.mul(conversionFee).div(PPM_RESOLUTION - conversionFee);
1768     }
1769 
1770     /**
1771      * @dev loads the stored reserve balance for a given reserve id
1772      *
1773      * @param _reserveId   reserve id
1774      */
1775     function reserveBalance(uint256 _reserveId) internal view returns (uint256) {
1776         return decodeReserveBalance(__reserveBalances, _reserveId);
1777     }
1778 
1779     /**
1780      * @dev loads the stored reserve balances
1781      *
1782      * @param _sourceId    source reserve id
1783      * @param _targetId    target reserve id
1784      */
1785     function reserveBalances(uint256 _sourceId, uint256 _targetId) internal view returns (uint256, uint256) {
1786         require((_sourceId == 1 && _targetId == 2) || (_sourceId == 2 && _targetId == 1), "ERR_INVALID_RESERVES");
1787         return decodeReserveBalances(__reserveBalances, _sourceId, _targetId);
1788     }
1789 
1790     /**
1791      * @dev stores the stored reserve balance for a given reserve id
1792      *
1793      * @param _reserveId       reserve id
1794      * @param _reserveBalance  reserve balance
1795      */
1796     function setReserveBalance(uint256 _reserveId, uint256 _reserveBalance) internal {
1797         require(_reserveBalance <= MAX_UINT128, "ERR_RESERVE_BALANCE_OVERFLOW");
1798         uint256 otherBalance = decodeReserveBalance(__reserveBalances, 3 - _reserveId);
1799         __reserveBalances = encodeReserveBalances(_reserveBalance, _reserveId, otherBalance, 3 - _reserveId);
1800     }
1801 
1802     /**
1803      * @dev stores the stored reserve balances
1804      *
1805      * @param _sourceId        source reserve id
1806      * @param _targetId        target reserve id
1807      * @param _sourceBalance   source reserve balance
1808      * @param _targetBalance   target reserve balance
1809      */
1810     function setReserveBalances(
1811         uint256 _sourceId,
1812         uint256 _targetId,
1813         uint256 _sourceBalance,
1814         uint256 _targetBalance
1815     ) internal {
1816         require(_sourceBalance <= MAX_UINT128 && _targetBalance <= MAX_UINT128, "ERR_RESERVE_BALANCE_OVERFLOW");
1817         __reserveBalances = encodeReserveBalances(_sourceBalance, _sourceId, _targetBalance, _targetId);
1818     }
1819 
1820     /**
1821      * @dev syncs the stored reserve balance for a given reserve with the real reserve balance
1822      *
1823      * @param _reserveToken    address of the reserve token
1824      */
1825     function syncReserveBalance(IERC20 _reserveToken) internal {
1826         uint256 reserveId = __reserveIds[_reserveToken];
1827         uint256 balance =
1828             _reserveToken == NATIVE_TOKEN_ADDRESS ? address(this).balance : _reserveToken.balanceOf(address(this));
1829         setReserveBalance(reserveId, balance);
1830     }
1831 
1832     /**
1833      * @dev syncs all stored reserve balances, excluding a given amount of ether from the ether reserve balance (if relevant)
1834      *
1835      * @param _value   amount of ether to exclude from the ether reserve balance (if relevant)
1836      */
1837     function syncReserveBalances(uint256 _value) internal {
1838         IERC20 _reserveToken0 = __reserveTokens[0];
1839         IERC20 _reserveToken1 = __reserveTokens[1];
1840         uint256 balance0 =
1841             _reserveToken0 == NATIVE_TOKEN_ADDRESS
1842                 ? address(this).balance - _value
1843                 : _reserveToken0.balanceOf(address(this));
1844         uint256 balance1 =
1845             _reserveToken1 == NATIVE_TOKEN_ADDRESS
1846                 ? address(this).balance - _value
1847                 : _reserveToken1.balanceOf(address(this));
1848         setReserveBalances(1, 2, balance0, balance1);
1849     }
1850 
1851     /**
1852      * @dev helper, dispatches the Conversion event
1853      *
1854      * @param _sourceToken     source ERC20 token
1855      * @param _targetToken     target ERC20 token
1856      * @param _trader          address of the caller who executed the conversion
1857      * @param _amount          amount purchased/sold (in the source token)
1858      * @param _returnAmount    amount returned (in the target token)
1859      */
1860     function dispatchConversionEvent(
1861         IERC20 _sourceToken,
1862         IERC20 _targetToken,
1863         address _trader,
1864         uint256 _amount,
1865         uint256 _returnAmount,
1866         uint256 _feeAmount
1867     ) internal {
1868         emit Conversion(_sourceToken, _targetToken, _trader, _amount, _returnAmount, int256(_feeAmount));
1869     }
1870 
1871     /**
1872      * @dev returns the expected amount and expected fee for converting one reserve to another
1873      *
1874      * @param _sourceToken address of the source reserve token contract
1875      * @param _targetToken address of the target reserve token contract
1876      * @param _amount      amount of source reserve tokens converted
1877      *
1878      * @return expected amount in units of the target reserve token
1879      * @return expected fee in units of the target reserve token
1880      */
1881     function targetAmountAndFee(
1882         IERC20 _sourceToken,
1883         IERC20 _targetToken,
1884         uint256 _amount
1885     ) public view virtual override active returns (uint256, uint256) {
1886         uint256 sourceId = __reserveIds[_sourceToken];
1887         uint256 targetId = __reserveIds[_targetToken];
1888 
1889         (uint256 sourceBalance, uint256 targetBalance) = reserveBalances(sourceId, targetId);
1890 
1891         return targetAmountAndFee(_sourceToken, _targetToken, sourceBalance, targetBalance, _amount);
1892     }
1893 
1894     /**
1895      * @dev returns the expected amount and expected fee for converting one reserve to another
1896      *
1897      * @param _sourceBalance    balance in the source reserve token contract
1898      * @param _targetBalance    balance in the target reserve token contract
1899      * @param _amount           amount of source reserve tokens converted
1900      *
1901      * @return expected amount in units of the target reserve token
1902      * @return expected fee in units of the target reserve token
1903      */
1904     function targetAmountAndFee(
1905         IERC20, /* _sourceToken */
1906         IERC20, /* _targetToken */
1907         uint256 _sourceBalance,
1908         uint256 _targetBalance,
1909         uint256 _amount
1910     ) internal view virtual returns (uint256, uint256) {
1911         uint256 amount = crossReserveTargetAmount(_sourceBalance, _targetBalance, _amount);
1912 
1913         uint256 fee = calculateFee(amount);
1914 
1915         return (amount - fee, fee);
1916     }
1917 
1918     /**
1919      * @dev returns the required amount and expected fee for converting one reserve to another
1920      *
1921      * @param _sourceToken address of the source reserve token contract
1922      * @param _targetToken address of the target reserve token contract
1923      * @param _amount      amount of target reserve tokens desired
1924      *
1925      * @return required amount in units of the source reserve token
1926      * @return expected fee in units of the target reserve token
1927      */
1928     function sourceAmountAndFee(
1929         IERC20 _sourceToken,
1930         IERC20 _targetToken,
1931         uint256 _amount
1932     ) public view virtual active returns (uint256, uint256) {
1933         uint256 sourceId = __reserveIds[_sourceToken];
1934         uint256 targetId = __reserveIds[_targetToken];
1935 
1936         (uint256 sourceBalance, uint256 targetBalance) = reserveBalances(sourceId, targetId);
1937 
1938         uint256 fee = calculateFeeInv(_amount);
1939 
1940         uint256 amount = crossReserveSourceAmount(sourceBalance, targetBalance, _amount.add(fee));
1941 
1942         return (amount, fee);
1943     }
1944 
1945     /**
1946      * @dev converts a specific amount of source tokens to target tokens
1947      *
1948      * @param _sourceToken source ERC20 token
1949      * @param _targetToken target ERC20 token
1950      * @param _amount      amount of tokens to convert (in units of the source token)
1951      * @param _trader      address of the caller who executed the conversion
1952      * @param _beneficiary wallet to receive the conversion result
1953      *
1954      * @return amount of tokens received (in units of the target token)
1955      */
1956     function doConvert(
1957         IERC20 _sourceToken,
1958         IERC20 _targetToken,
1959         uint256 _amount,
1960         address _trader,
1961         address payable _beneficiary
1962     ) internal returns (uint256) {
1963         // update the recent average rate
1964         updateRecentAverageRate();
1965 
1966         uint256 sourceId = __reserveIds[_sourceToken];
1967         uint256 targetId = __reserveIds[_targetToken];
1968 
1969         (uint256 sourceBalance, uint256 targetBalance) = reserveBalances(sourceId, targetId);
1970 
1971         // get the target amount minus the conversion fee and the conversion fee
1972         (uint256 amount, uint256 fee) =
1973             targetAmountAndFee(_sourceToken, _targetToken, sourceBalance, targetBalance, _amount);
1974 
1975         // ensure that the trade gives something in return
1976         require(amount != 0, "ERR_ZERO_TARGET_AMOUNT");
1977 
1978         // ensure that the trade won't deplete the reserve balance
1979         assert(amount < targetBalance);
1980 
1981         // ensure that the input amount was already deposited
1982         uint256 actualSourceBalance;
1983         if (_sourceToken == NATIVE_TOKEN_ADDRESS) {
1984             actualSourceBalance = address(this).balance;
1985             require(msg.value == _amount, "ERR_ETH_AMOUNT_MISMATCH");
1986         } else {
1987             actualSourceBalance = _sourceToken.balanceOf(address(this));
1988             require(msg.value == 0 && actualSourceBalance.sub(sourceBalance) >= _amount, "ERR_INVALID_AMOUNT");
1989         }
1990 
1991         // sync the reserve balances
1992         setReserveBalances(sourceId, targetId, actualSourceBalance, targetBalance - amount);
1993 
1994         // transfer funds to the beneficiary in the to reserve token
1995         safeTransfer(_targetToken, _beneficiary, amount);
1996 
1997         // dispatch the conversion event
1998         dispatchConversionEvent(_sourceToken, _targetToken, _trader, _amount, amount, fee);
1999 
2000         // dispatch rate updates
2001         dispatchTokenRateUpdateEvents(_sourceToken, _targetToken, actualSourceBalance, targetBalance - amount);
2002 
2003         return amount;
2004     }
2005 
2006     /**
2007      * @dev returns the recent average rate of 1 `_token` in the other reserve token units
2008      *
2009      * @param _token   token to get the rate for
2010      *
2011      * @return recent average rate between the reserves (numerator)
2012      * @return recent average rate between the reserves (denominator)
2013      */
2014     function recentAverageRate(IERC20 _token) external view validReserve(_token) returns (uint256, uint256) {
2015         // get the recent average rate of reserve 0
2016         uint256 rate = calcRecentAverageRate(averageRateInfo);
2017 
2018         uint256 rateN = decodeAverageRateN(rate);
2019         uint256 rateD = decodeAverageRateD(rate);
2020 
2021         if (_token == __reserveTokens[0]) {
2022             return (rateN, rateD);
2023         }
2024 
2025         return (rateD, rateN);
2026     }
2027 
2028     /**
2029      * @dev updates the recent average rate if needed
2030      */
2031     function updateRecentAverageRate() internal {
2032         uint256 averageRateInfo1 = averageRateInfo;
2033         uint256 averageRateInfo2 = calcRecentAverageRate(averageRateInfo1);
2034         if (averageRateInfo1 != averageRateInfo2) {
2035             averageRateInfo = averageRateInfo2;
2036         }
2037     }
2038 
2039     /**
2040      * @dev returns the recent average rate of 1 reserve token 0 in reserve token 1 units
2041      *
2042      * @param _averageRateInfo a local copy of the `averageRateInfo` state-variable
2043      *
2044      * @return recent average rate between the reserves
2045      */
2046     function calcRecentAverageRate(uint256 _averageRateInfo) internal view returns (uint256) {
2047         // get the previous average rate and its update-time
2048         uint256 prevAverageRateT = decodeAverageRateT(_averageRateInfo);
2049         uint256 prevAverageRateN = decodeAverageRateN(_averageRateInfo);
2050         uint256 prevAverageRateD = decodeAverageRateD(_averageRateInfo);
2051 
2052         // get the elapsed time since the previous average rate was calculated
2053         uint256 currentTime = time();
2054         uint256 timeElapsed = currentTime - prevAverageRateT;
2055 
2056         // if the previous average rate was calculated in the current block, the average rate remains unchanged
2057         if (timeElapsed == 0) {
2058             return _averageRateInfo;
2059         }
2060 
2061         // get the current rate between the reserves
2062         (uint256 currentRateD, uint256 currentRateN) = reserveBalances();
2063 
2064         // if the previous average rate was calculated a while ago or never, the average rate is equal to the current rate
2065         if (timeElapsed >= AVERAGE_RATE_PERIOD || prevAverageRateT == 0) {
2066             (currentRateN, currentRateD) = MathEx.reducedRatio(currentRateN, currentRateD, MAX_UINT112);
2067             return encodeAverageRateInfo(currentTime, currentRateN, currentRateD);
2068         }
2069 
2070         uint256 x = prevAverageRateD.mul(currentRateN);
2071         uint256 y = prevAverageRateN.mul(currentRateD);
2072 
2073         // since we know that timeElapsed < AVERAGE_RATE_PERIOD, we can avoid using SafeMath:
2074         uint256 newRateN = y.mul(AVERAGE_RATE_PERIOD - timeElapsed).add(x.mul(timeElapsed));
2075         uint256 newRateD = prevAverageRateD.mul(currentRateD).mul(AVERAGE_RATE_PERIOD);
2076 
2077         (newRateN, newRateD) = MathEx.reducedRatio(newRateN, newRateD, MAX_UINT112);
2078         return encodeAverageRateInfo(currentTime, newRateN, newRateD);
2079     }
2080 
2081     /**
2082      * @dev increases the pool's liquidity and mints new shares in the pool to the caller
2083      *
2084      * @param _reserveTokens   address of each reserve token
2085      * @param _reserveAmounts  amount of each reserve token
2086      * @param _minReturn       token minimum return-amount
2087      *
2088      * @return amount of pool tokens issued
2089      */
2090     function addLiquidity(
2091         IERC20[] memory _reserveTokens,
2092         uint256[] memory _reserveAmounts,
2093         uint256 _minReturn
2094     ) public payable protected active returns (uint256) {
2095         // verify the user input
2096         verifyLiquidityInput(_reserveTokens, _reserveAmounts, _minReturn);
2097 
2098         // if one of the reserves is ETH, then verify that the input amount of ETH is equal to the input value of ETH
2099         for (uint256 i = 0; i < 2; i++) {
2100             if (_reserveTokens[i] == NATIVE_TOKEN_ADDRESS) {
2101                 require(_reserveAmounts[i] == msg.value, "ERR_ETH_AMOUNT_MISMATCH");
2102             }
2103         }
2104 
2105         // if the input value of ETH is larger than zero, then verify that one of the reserves is ETH
2106         if (msg.value > 0) {
2107             require(__reserveIds[NATIVE_TOKEN_ADDRESS] != 0, "ERR_NO_ETH_RESERVE");
2108         }
2109 
2110         // save a local copy of the pool token
2111         IDSToken poolToken = IDSToken(address(anchor));
2112 
2113         // get the total supply
2114         uint256 totalSupply = poolToken.totalSupply();
2115 
2116         uint256[2] memory prevReserveBalances;
2117         uint256[2] memory newReserveBalances;
2118 
2119         // process the network fees and get the reserve balances
2120         (prevReserveBalances[0], prevReserveBalances[1]) = processNetworkFees(msg.value);
2121 
2122         uint256 amount;
2123         uint256[2] memory reserveAmounts;
2124 
2125         // calculate the amount of pool tokens to mint for the caller
2126         // and the amount of reserve tokens to transfer from the caller
2127         if (totalSupply == 0) {
2128             amount = MathEx.geometricMean(_reserveAmounts);
2129             reserveAmounts[0] = _reserveAmounts[0];
2130             reserveAmounts[1] = _reserveAmounts[1];
2131         } else {
2132             (amount, reserveAmounts) = addLiquidityAmounts(
2133                 _reserveTokens,
2134                 _reserveAmounts,
2135                 prevReserveBalances,
2136                 totalSupply
2137             );
2138         }
2139 
2140         uint256 newPoolTokenSupply = totalSupply.add(amount);
2141         for (uint256 i = 0; i < 2; i++) {
2142             IERC20 reserveToken = _reserveTokens[i];
2143             uint256 reserveAmount = reserveAmounts[i];
2144             require(reserveAmount > 0, "ERR_ZERO_TARGET_AMOUNT");
2145             assert(reserveAmount <= _reserveAmounts[i]);
2146 
2147             // transfer each one of the reserve amounts from the user to the pool
2148             if (reserveToken != NATIVE_TOKEN_ADDRESS) {
2149                 // ETH has already been transferred as part of the transaction
2150                 reserveToken.safeTransferFrom(msg.sender, address(this), reserveAmount);
2151             } else if (_reserveAmounts[i] > reserveAmount) {
2152                 // transfer the extra amount of ETH back to the user
2153                 msg.sender.transfer(_reserveAmounts[i] - reserveAmount);
2154             }
2155 
2156             // save the new reserve balance
2157             newReserveBalances[i] = prevReserveBalances[i].add(reserveAmount);
2158 
2159             emit LiquidityAdded(msg.sender, reserveToken, reserveAmount, newReserveBalances[i], newPoolTokenSupply);
2160 
2161             // dispatch the `TokenRateUpdate` event for the pool token
2162             emit TokenRateUpdate(poolToken, reserveToken, newReserveBalances[i], newPoolTokenSupply);
2163         }
2164 
2165         // set the reserve balances
2166         setReserveBalances(1, 2, newReserveBalances[0], newReserveBalances[1]);
2167 
2168         // set the reserve balances product
2169         _reserveBalancesProduct = newReserveBalances[0] * newReserveBalances[1];
2170 
2171         // verify that the equivalent amount of tokens is equal to or larger than the user's expectation
2172         require(amount >= _minReturn, "ERR_RETURN_TOO_LOW");
2173 
2174         // issue the tokens to the user
2175         poolToken.issue(msg.sender, amount);
2176 
2177         // return the amount of pool tokens issued
2178         return amount;
2179     }
2180 
2181     /**
2182      * @dev get the amount of pool tokens to mint for the caller
2183      * and the amount of reserve tokens to transfer from the caller
2184      *
2185      * @param _reserveAmounts   amount of each reserve token
2186      * @param _reserveBalances  balance of each reserve token
2187      * @param _totalSupply      total supply of pool tokens
2188      *
2189      * @return amount of pool tokens to mint for the caller
2190      * @return amount of reserve tokens to transfer from the caller
2191      */
2192     function addLiquidityAmounts(
2193         IERC20[] memory, /* _reserveTokens */
2194         uint256[] memory _reserveAmounts,
2195         uint256[2] memory _reserveBalances,
2196         uint256 _totalSupply
2197     ) internal view virtual returns (uint256, uint256[2] memory) {
2198         this;
2199 
2200         uint256 index =
2201             _reserveAmounts[0].mul(_reserveBalances[1]) < _reserveAmounts[1].mul(_reserveBalances[0]) ? 0 : 1;
2202         uint256 amount = fundSupplyAmount(_totalSupply, _reserveBalances[index], _reserveAmounts[index]);
2203 
2204         uint256[2] memory reserveAmounts =
2205             [fundCost(_totalSupply, _reserveBalances[0], amount), fundCost(_totalSupply, _reserveBalances[1], amount)];
2206 
2207         return (amount, reserveAmounts);
2208     }
2209 
2210     /**
2211      * @dev decreases the pool's liquidity and burns the caller's shares in the pool
2212      *
2213      * @param _amount                  token amount
2214      * @param _reserveTokens           address of each reserve token
2215      * @param _reserveMinReturnAmounts minimum return-amount of each reserve token
2216      *
2217      * @return the amount of each reserve token granted for the given amount of pool tokens
2218      */
2219     function removeLiquidity(
2220         uint256 _amount,
2221         IERC20[] memory _reserveTokens,
2222         uint256[] memory _reserveMinReturnAmounts
2223     ) public protected active returns (uint256[] memory) {
2224         // verify the user input
2225         bool inputRearranged = verifyLiquidityInput(_reserveTokens, _reserveMinReturnAmounts, _amount);
2226 
2227         // save a local copy of the pool token
2228         IDSToken poolToken = IDSToken(address(anchor));
2229 
2230         // get the total supply BEFORE destroying the user tokens
2231         uint256 totalSupply = poolToken.totalSupply();
2232 
2233         // destroy the user tokens
2234         poolToken.destroy(msg.sender, _amount);
2235 
2236         uint256 newPoolTokenSupply = totalSupply.sub(_amount);
2237 
2238         uint256[2] memory prevReserveBalances;
2239         uint256[2] memory newReserveBalances;
2240 
2241         // process the network fees and get the reserve balances
2242         (prevReserveBalances[0], prevReserveBalances[1]) = processNetworkFees(0);
2243 
2244         uint256[] memory reserveAmounts = removeLiquidityReserveAmounts(_amount, totalSupply, prevReserveBalances);
2245 
2246         for (uint256 i = 0; i < 2; i++) {
2247             IERC20 reserveToken = _reserveTokens[i];
2248             uint256 reserveAmount = reserveAmounts[i];
2249             require(reserveAmount >= _reserveMinReturnAmounts[i], "ERR_ZERO_TARGET_AMOUNT");
2250 
2251             // save the new reserve balance
2252             newReserveBalances[i] = prevReserveBalances[i].sub(reserveAmount);
2253 
2254             // transfer each one of the reserve amounts from the pool to the user
2255             safeTransfer(reserveToken, msg.sender, reserveAmount);
2256 
2257             emit LiquidityRemoved(msg.sender, reserveToken, reserveAmount, newReserveBalances[i], newPoolTokenSupply);
2258 
2259             // dispatch the `TokenRateUpdate` event for the pool token
2260             emit TokenRateUpdate(poolToken, reserveToken, newReserveBalances[i], newPoolTokenSupply);
2261         }
2262 
2263         // set the reserve balances
2264         setReserveBalances(1, 2, newReserveBalances[0], newReserveBalances[1]);
2265 
2266         // set the reserve balances product
2267         _reserveBalancesProduct = newReserveBalances[0] * newReserveBalances[1];
2268 
2269         if (inputRearranged) {
2270             uint256 tempReserveAmount = reserveAmounts[0];
2271             reserveAmounts[0] = reserveAmounts[1];
2272             reserveAmounts[1] = tempReserveAmount;
2273         }
2274 
2275         // return the amount of each reserve token granted for the given amount of pool tokens
2276         return reserveAmounts;
2277     }
2278 
2279     /**
2280      * @dev given the amount of one of the reserve tokens to add liquidity of,
2281      * returns the required amount of each one of the other reserve tokens
2282      * since an empty pool can be funded with any list of non-zero input amounts,
2283      * this function assumes that the pool is not empty (has already been funded)
2284      *
2285      * @param _reserveTokens       address of each reserve token
2286      * @param _reserveTokenIndex   index of the relevant reserve token
2287      * @param _reserveAmount       amount of the relevant reserve token
2288      *
2289      * @return the required amount of each one of the reserve tokens
2290      */
2291     function addLiquidityCost(
2292         IERC20[] memory _reserveTokens,
2293         uint256 _reserveTokenIndex,
2294         uint256 _reserveAmount
2295     ) public view returns (uint256[] memory) {
2296         uint256 totalSupply = IDSToken(address(anchor)).totalSupply();
2297         uint256[2] memory baseBalances = baseReserveBalances(_reserveTokens);
2298         uint256 amount = fundSupplyAmount(totalSupply, baseBalances[_reserveTokenIndex], _reserveAmount);
2299 
2300         uint256[] memory reserveAmounts = new uint256[](2);
2301         reserveAmounts[0] = fundCost(totalSupply, baseBalances[0], amount);
2302         reserveAmounts[1] = fundCost(totalSupply, baseBalances[1], amount);
2303         return reserveAmounts;
2304     }
2305 
2306     /**
2307      * @dev returns the amount of pool tokens entitled for given amounts of reserve tokens
2308      * since an empty pool can be funded with any list of non-zero input amounts,
2309      * this function assumes that the pool is not empty (has already been funded)
2310      *
2311      * @param _reserveTokens   address of each reserve token
2312      * @param _reserveAmounts  amount of each reserve token
2313      *
2314      * @return the amount of pool tokens entitled for the given amounts of reserve tokens
2315      */
2316     function addLiquidityReturn(IERC20[] memory _reserveTokens, uint256[] memory _reserveAmounts)
2317         public
2318         view
2319         returns (uint256)
2320     {
2321         uint256 totalSupply = IDSToken(address(anchor)).totalSupply();
2322         uint256[2] memory baseBalances = baseReserveBalances(_reserveTokens);
2323         (uint256 amount, ) = addLiquidityAmounts(_reserveTokens, _reserveAmounts, baseBalances, totalSupply);
2324         return amount;
2325     }
2326 
2327     /**
2328      * @dev returns the amount of each reserve token entitled for a given amount of pool tokens
2329      *
2330      * @param _amount          amount of pool tokens
2331      * @param _reserveTokens   address of each reserve token
2332      *
2333      * @return the amount of each reserve token entitled for the given amount of pool tokens
2334      */
2335     function removeLiquidityReturn(uint256 _amount, IERC20[] memory _reserveTokens)
2336         public
2337         view
2338         returns (uint256[] memory)
2339     {
2340         uint256 totalSupply = IDSToken(address(anchor)).totalSupply();
2341         uint256[2] memory baseBalances = baseReserveBalances(_reserveTokens);
2342         return removeLiquidityReserveAmounts(_amount, totalSupply, baseBalances);
2343     }
2344 
2345     /**
2346      * @dev verifies that a given array of tokens is identical to the converter's array of reserve tokens
2347      * we take this input in order to allow specifying the corresponding reserve amounts in any order
2348      * this function rearranges the input arrays according to the converter's array of reserve tokens
2349      *
2350      * @param _reserveTokens   array of reserve tokens
2351      * @param _reserveAmounts  array of reserve amounts
2352      * @param _amount          token amount
2353      *
2354      * @return true if the function has rearranged the input arrays; false otherwise
2355      */
2356     function verifyLiquidityInput(
2357         IERC20[] memory _reserveTokens,
2358         uint256[] memory _reserveAmounts,
2359         uint256 _amount
2360     ) private view returns (bool) {
2361         require(validReserveAmounts(_reserveAmounts) && _amount > 0, "ERR_ZERO_AMOUNT");
2362 
2363         uint256 reserve0Id = __reserveIds[_reserveTokens[0]];
2364         uint256 reserve1Id = __reserveIds[_reserveTokens[1]];
2365 
2366         if (reserve0Id == 2 && reserve1Id == 1) {
2367             IERC20 tempReserveToken = _reserveTokens[0];
2368             _reserveTokens[0] = _reserveTokens[1];
2369             _reserveTokens[1] = tempReserveToken;
2370             uint256 tempReserveAmount = _reserveAmounts[0];
2371             _reserveAmounts[0] = _reserveAmounts[1];
2372             _reserveAmounts[1] = tempReserveAmount;
2373             return true;
2374         }
2375 
2376         require(reserve0Id == 1 && reserve1Id == 2, "ERR_INVALID_RESERVE");
2377         return false;
2378     }
2379 
2380     /**
2381      * @dev checks whether or not both reserve amounts are larger than zero
2382      *
2383      * @param _reserveAmounts  array of reserve amounts
2384      *
2385      * @return true if both reserve amounts are larger than zero; false otherwise
2386      */
2387     function validReserveAmounts(uint256[] memory _reserveAmounts) internal pure virtual returns (bool) {
2388         return _reserveAmounts[0] > 0 && _reserveAmounts[1] > 0;
2389     }
2390 
2391     /**
2392      * @dev returns the amount of each reserve token entitled for a given amount of pool tokens
2393      *
2394      * @param _amount          amount of pool tokens
2395      * @param _totalSupply     total supply of pool tokens
2396      * @param _reserveBalances balance of each reserve token
2397      *
2398      * @return the amount of each reserve token entitled for the given amount of pool tokens
2399      */
2400     function removeLiquidityReserveAmounts(
2401         uint256 _amount,
2402         uint256 _totalSupply,
2403         uint256[2] memory _reserveBalances
2404     ) private pure returns (uint256[] memory) {
2405         uint256[] memory reserveAmounts = new uint256[](2);
2406         reserveAmounts[0] = liquidateReserveAmount(_totalSupply, _reserveBalances[0], _amount);
2407         reserveAmounts[1] = liquidateReserveAmount(_totalSupply, _reserveBalances[1], _amount);
2408         return reserveAmounts;
2409     }
2410 
2411     /**
2412      * @dev dispatches token rate update events for the reserve tokens and the pool token
2413      *
2414      * @param _sourceToken     address of the source reserve token
2415      * @param _targetToken     address of the target reserve token
2416      * @param _sourceBalance   balance of the source reserve token
2417      * @param _targetBalance   balance of the target reserve token
2418      */
2419     function dispatchTokenRateUpdateEvents(
2420         IERC20 _sourceToken,
2421         IERC20 _targetToken,
2422         uint256 _sourceBalance,
2423         uint256 _targetBalance
2424     ) private {
2425         // save a local copy of the pool token
2426         IDSToken poolToken = IDSToken(address(anchor));
2427 
2428         // get the total supply of pool tokens
2429         uint256 poolTokenSupply = poolToken.totalSupply();
2430 
2431         // dispatch token rate update event for the reserve tokens
2432         emit TokenRateUpdate(_sourceToken, _targetToken, _targetBalance, _sourceBalance);
2433 
2434         // dispatch token rate update events for the pool token
2435         emit TokenRateUpdate(poolToken, _sourceToken, _sourceBalance, poolTokenSupply);
2436         emit TokenRateUpdate(poolToken, _targetToken, _targetBalance, poolTokenSupply);
2437     }
2438 
2439     function encodeReserveBalance(uint256 _balance, uint256 _id) private pure returns (uint256) {
2440         assert(_balance <= MAX_UINT128 && (_id == 1 || _id == 2));
2441         return _balance << ((_id - 1) * 128);
2442     }
2443 
2444     function decodeReserveBalance(uint256 _balances, uint256 _id) private pure returns (uint256) {
2445         assert(_id == 1 || _id == 2);
2446         return (_balances >> ((_id - 1) * 128)) & MAX_UINT128;
2447     }
2448 
2449     function encodeReserveBalances(
2450         uint256 _balance0,
2451         uint256 _id0,
2452         uint256 _balance1,
2453         uint256 _id1
2454     ) private pure returns (uint256) {
2455         return encodeReserveBalance(_balance0, _id0) | encodeReserveBalance(_balance1, _id1);
2456     }
2457 
2458     function decodeReserveBalances(
2459         uint256 _balances,
2460         uint256 _id0,
2461         uint256 _id1
2462     ) private pure returns (uint256, uint256) {
2463         return (decodeReserveBalance(_balances, _id0), decodeReserveBalance(_balances, _id1));
2464     }
2465 
2466     function encodeAverageRateInfo(
2467         uint256 _averageRateT,
2468         uint256 _averageRateN,
2469         uint256 _averageRateD
2470     ) private pure returns (uint256) {
2471         assert(_averageRateT <= MAX_UINT32 && _averageRateN <= MAX_UINT112 && _averageRateD <= MAX_UINT112);
2472         return (_averageRateT << 224) | (_averageRateN << 112) | _averageRateD;
2473     }
2474 
2475     function decodeAverageRateT(uint256 _averageRateInfo) private pure returns (uint256) {
2476         return _averageRateInfo >> 224;
2477     }
2478 
2479     function decodeAverageRateN(uint256 _averageRateInfo) private pure returns (uint256) {
2480         return (_averageRateInfo >> 112) & MAX_UINT112;
2481     }
2482 
2483     function decodeAverageRateD(uint256 _averageRateInfo) private pure returns (uint256) {
2484         return _averageRateInfo & MAX_UINT112;
2485     }
2486 
2487     /**
2488      * @dev returns the largest integer smaller than or equal to the square root of a given value
2489      *
2490      * @param x the given value
2491      *
2492      * @return the largest integer smaller than or equal to the square root of the given value
2493      */
2494     function floorSqrt(uint256 x) private pure returns (uint256) {
2495         return x > 0 ? MathEx.floorSqrt(x) : 0;
2496     }
2497 
2498     function crossReserveTargetAmount(
2499         uint256 _sourceReserveBalance,
2500         uint256 _targetReserveBalance,
2501         uint256 _amount
2502     ) private pure returns (uint256) {
2503         // validate input
2504         require(_sourceReserveBalance > 0 && _targetReserveBalance > 0, "ERR_INVALID_RESERVE_BALANCE");
2505 
2506         return _targetReserveBalance.mul(_amount) / _sourceReserveBalance.add(_amount);
2507     }
2508 
2509     function crossReserveSourceAmount(
2510         uint256 _sourceReserveBalance,
2511         uint256 _targetReserveBalance,
2512         uint256 _amount
2513     ) private pure returns (uint256) {
2514         // validate input
2515         require(_sourceReserveBalance > 0, "ERR_INVALID_RESERVE_BALANCE");
2516         require(_amount < _targetReserveBalance, "ERR_INVALID_AMOUNT");
2517 
2518         if (_amount == 0) {
2519             return 0;
2520         }
2521 
2522         return (_sourceReserveBalance.mul(_amount) - 1) / (_targetReserveBalance - _amount) + 1;
2523     }
2524 
2525     function fundCost(
2526         uint256 _supply,
2527         uint256 _reserveBalance,
2528         uint256 _amount
2529     ) private pure returns (uint256) {
2530         // validate input
2531         require(_supply > 0, "ERR_INVALID_SUPPLY");
2532         require(_reserveBalance > 0, "ERR_INVALID_RESERVE_BALANCE");
2533 
2534         // special case for 0 amount
2535         if (_amount == 0) {
2536             return 0;
2537         }
2538 
2539         return (_amount.mul(_reserveBalance) - 1) / _supply + 1;
2540     }
2541 
2542     function fundSupplyAmount(
2543         uint256 _supply,
2544         uint256 _reserveBalance,
2545         uint256 _amount
2546     ) private pure returns (uint256) {
2547         // validate input
2548         require(_supply > 0, "ERR_INVALID_SUPPLY");
2549         require(_reserveBalance > 0, "ERR_INVALID_RESERVE_BALANCE");
2550 
2551         // special case for 0 amount
2552         if (_amount == 0) {
2553             return 0;
2554         }
2555 
2556         return _amount.mul(_supply) / _reserveBalance;
2557     }
2558 
2559     function liquidateReserveAmount(
2560         uint256 _supply,
2561         uint256 _reserveBalance,
2562         uint256 _amount
2563     ) private pure returns (uint256) {
2564         // validate input
2565         require(_supply > 0, "ERR_INVALID_SUPPLY");
2566         require(_reserveBalance > 0, "ERR_INVALID_RESERVE_BALANCE");
2567         require(_amount <= _supply, "ERR_INVALID_AMOUNT");
2568 
2569         // special case for 0 amount
2570         if (_amount == 0) {
2571             return 0;
2572         }
2573 
2574         // special case for liquidating the entire supply
2575         if (_amount == _supply) {
2576             return _reserveBalance;
2577         }
2578 
2579         return _amount.mul(_reserveBalance) / _supply;
2580     }
2581 
2582     /**
2583      * @dev returns the network wallet and fees
2584      *
2585      * @param reserveBalance0 1st reserve balance
2586      * @param reserveBalance1 2nd reserve balance
2587      *
2588      * @return the network wallet
2589      * @return the network fee on the 1st reserve
2590      * @return the network fee on the 2nd reserve
2591      */
2592     function networkWalletAndFees(uint256 reserveBalance0, uint256 reserveBalance1)
2593         private
2594         view
2595         returns (
2596             ITokenHolder,
2597             uint256,
2598             uint256
2599         )
2600     {
2601         uint256 prevPoint = floorSqrt(_reserveBalancesProduct);
2602         uint256 currPoint = floorSqrt(reserveBalance0 * reserveBalance1);
2603 
2604         if (prevPoint >= currPoint) {
2605             return (ITokenHolder(address(0)), 0, 0);
2606         }
2607 
2608         (ITokenHolder networkFeeWallet, uint32 networkFee) =
2609             INetworkSettings(addressOf(NETWORK_SETTINGS)).networkFeeParams();
2610         uint256 n = (currPoint - prevPoint) * networkFee;
2611         uint256 d = currPoint * PPM_RESOLUTION;
2612         return (networkFeeWallet, reserveBalance0.mul(n).div(d), reserveBalance1.mul(n).div(d));
2613     }
2614 
2615     /**
2616      * @dev transfers funds held by the contract and sends them to an account
2617      *
2618      * @param token ERC20 token contract address
2619      * @param to account to receive the new amount
2620      * @param amount amount to withdraw
2621      */
2622     function safeTransfer(
2623         IERC20 token,
2624         address to,
2625         uint256 amount
2626     ) private {
2627         if (amount == 0) {
2628             return;
2629         }
2630 
2631         if (token == NATIVE_TOKEN_ADDRESS) {
2632             payable(to).transfer(amount);
2633         } else {
2634             token.safeTransfer(to, amount);
2635         }
2636     }
2637 
2638     /**
2639      * @dev deprecated since version 28, backward compatibility - use only for earlier versions
2640      */
2641     function token() public view override returns (IConverterAnchor) {
2642         return anchor;
2643     }
2644 
2645     /**
2646      * @dev deprecated, backward compatibility
2647      */
2648     function transferTokenOwnership(address _newOwner) public override ownerOnly {
2649         transferAnchorOwnership(_newOwner);
2650     }
2651 
2652     /**
2653      * @dev deprecated, backward compatibility
2654      */
2655     function acceptTokenOwnership() public override ownerOnly {
2656         acceptAnchorOwnership();
2657     }
2658 
2659     /**
2660      * @dev deprecated, backward compatibility
2661      */
2662     function connectors(IERC20 _address)
2663         public
2664         view
2665         override
2666         returns (
2667             uint256,
2668             uint32,
2669             bool,
2670             bool,
2671             bool
2672         )
2673     {
2674         uint256 reserveId = __reserveIds[_address];
2675         if (reserveId != 0) {
2676             return (reserveBalance(reserveId), PPM_RESOLUTION / 2, false, false, true);
2677         }
2678         return (0, 0, false, false, false);
2679     }
2680 
2681     /**
2682      * @dev deprecated, backward compatibility
2683      */
2684     function connectorTokens(uint256 _index) public view override returns (IERC20) {
2685         return __reserveTokens[_index];
2686     }
2687 
2688     /**
2689      * @dev deprecated, backward compatibility
2690      */
2691     function connectorTokenCount() public view override returns (uint16) {
2692         return reserveTokenCount();
2693     }
2694 
2695     /**
2696      * @dev deprecated, backward compatibility
2697      */
2698     function getConnectorBalance(IERC20 _connectorToken) public view override returns (uint256) {
2699         return reserveBalance(_connectorToken);
2700     }
2701 
2702     /**
2703      * @dev deprecated, backward compatibility
2704      */
2705     function getReturn(
2706         IERC20 _sourceToken,
2707         IERC20 _targetToken,
2708         uint256 _amount
2709     ) public view returns (uint256, uint256) {
2710         return targetAmountAndFee(_sourceToken, _targetToken, _amount);
2711     }
2712 }
