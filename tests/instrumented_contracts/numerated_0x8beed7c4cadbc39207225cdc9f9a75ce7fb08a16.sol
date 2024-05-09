1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/utils/math/SafeMathUpgradeable.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 // CAUTION
8 // This version of SafeMath should only be used with Solidity 0.8 or later,
9 // because it relies on the compiler's built in overflow checks.
10 
11 /**
12  * @dev Wrappers over Solidity's arithmetic operations.
13  *
14  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
15  * now has built in overflow checking.
16  */
17 library SafeMathUpgradeable {
18     /**
19      * @dev Returns the addition of two unsigned integers, with an overflow flag.
20      *
21      * _Available since v3.4._
22      */
23     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
24         unchecked {
25             uint256 c = a + b;
26             if (c < a) return (false, 0);
27             return (true, c);
28         }
29     }
30 
31     /**
32      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
33      *
34      * _Available since v3.4._
35      */
36     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
37         unchecked {
38             if (b > a) return (false, 0);
39             return (true, a - b);
40         }
41     }
42 
43     /**
44      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
45      *
46      * _Available since v3.4._
47      */
48     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
49         unchecked {
50             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
51             // benefit is lost if 'b' is also tested.
52             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
53             if (a == 0) return (true, 0);
54             uint256 c = a * b;
55             if (c / a != b) return (false, 0);
56             return (true, c);
57         }
58     }
59 
60     /**
61      * @dev Returns the division of two unsigned integers, with a division by zero flag.
62      *
63      * _Available since v3.4._
64      */
65     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
66         unchecked {
67             if (b == 0) return (false, 0);
68             return (true, a / b);
69         }
70     }
71 
72     /**
73      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
74      *
75      * _Available since v3.4._
76      */
77     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
78         unchecked {
79             if (b == 0) return (false, 0);
80             return (true, a % b);
81         }
82     }
83 
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      *
92      * - Addition cannot overflow.
93      */
94     function add(uint256 a, uint256 b) internal pure returns (uint256) {
95         return a + b;
96     }
97 
98     /**
99      * @dev Returns the subtraction of two unsigned integers, reverting on
100      * overflow (when the result is negative).
101      *
102      * Counterpart to Solidity's `-` operator.
103      *
104      * Requirements:
105      *
106      * - Subtraction cannot overflow.
107      */
108     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
109         return a - b;
110     }
111 
112     /**
113      * @dev Returns the multiplication of two unsigned integers, reverting on
114      * overflow.
115      *
116      * Counterpart to Solidity's `*` operator.
117      *
118      * Requirements:
119      *
120      * - Multiplication cannot overflow.
121      */
122     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a * b;
124     }
125 
126     /**
127      * @dev Returns the integer division of two unsigned integers, reverting on
128      * division by zero. The result is rounded towards zero.
129      *
130      * Counterpart to Solidity's `/` operator.
131      *
132      * Requirements:
133      *
134      * - The divisor cannot be zero.
135      */
136     function div(uint256 a, uint256 b) internal pure returns (uint256) {
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a % b;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * CAUTION: This function is deprecated because it requires allocating memory for the error
161      * message unnecessarily. For custom revert reasons use {trySub}.
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(
170         uint256 a,
171         uint256 b,
172         string memory errorMessage
173     ) internal pure returns (uint256) {
174         unchecked {
175             require(b <= a, errorMessage);
176             return a - b;
177         }
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         unchecked {
198             require(b > 0, errorMessage);
199             return a / b;
200         }
201     }
202 
203     /**
204      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
205      * reverting with custom message when dividing by zero.
206      *
207      * CAUTION: This function is deprecated because it requires allocating memory for the error
208      * message unnecessarily. For custom revert reasons use {tryMod}.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(
219         uint256 a,
220         uint256 b,
221         string memory errorMessage
222     ) internal pure returns (uint256) {
223         unchecked {
224             require(b > 0, errorMessage);
225             return a % b;
226         }
227     }
228 }
229 
230 // File: https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/utils/AddressUpgradeable.sol
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library AddressUpgradeable {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      */
255     function isContract(address account) internal view returns (bool) {
256         // This method relies on extcodesize, which returns 0 for contracts in
257         // construction, since the code is only stored at the end of the
258         // constructor execution.
259 
260         uint256 size;
261         assembly {
262             size := extcodesize(account)
263         }
264         return size > 0;
265     }
266 
267     /**
268      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
269      * `recipient`, forwarding all available gas and reverting on errors.
270      *
271      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
272      * of certain opcodes, possibly making contracts go over the 2300 gas limit
273      * imposed by `transfer`, making them unable to receive funds via
274      * `transfer`. {sendValue} removes this limitation.
275      *
276      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
277      *
278      * IMPORTANT: because control is transferred to `recipient`, care must be
279      * taken to not create reentrancy vulnerabilities. Consider using
280      * {ReentrancyGuard} or the
281      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
282      */
283     function sendValue(address payable recipient, uint256 amount) internal {
284         require(address(this).balance >= amount, "Address: insufficient balance");
285 
286         (bool success, ) = recipient.call{value: amount}("");
287         require(success, "Address: unable to send value, recipient may have reverted");
288     }
289 
290     /**
291      * @dev Performs a Solidity function call using a low level `call`. A
292      * plain `call` is an unsafe replacement for a function call: use this
293      * function instead.
294      *
295      * If `target` reverts with a revert reason, it is bubbled up by this
296      * function (like regular Solidity function calls).
297      *
298      * Returns the raw returned data. To convert to the expected return value,
299      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
300      *
301      * Requirements:
302      *
303      * - `target` must be a contract.
304      * - calling `target` with `data` must not revert.
305      *
306      * _Available since v3.1._
307      */
308     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
309         return functionCall(target, data, "Address: low-level call failed");
310     }
311 
312     /**
313      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
314      * `errorMessage` as a fallback revert reason when `target` reverts.
315      *
316      * _Available since v3.1._
317      */
318     function functionCall(
319         address target,
320         bytes memory data,
321         string memory errorMessage
322     ) internal returns (bytes memory) {
323         return functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(
338         address target,
339         bytes memory data,
340         uint256 value
341     ) internal returns (bytes memory) {
342         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
347      * with `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(
352         address target,
353         bytes memory data,
354         uint256 value,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         require(isContract(target), "Address: call to non-contract");
359 
360         (bool success, bytes memory returndata) = target.call{value: value}(data);
361         return _verifyCallResult(success, returndata, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but performing a static call.
367      *
368      * _Available since v3.3._
369      */
370     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
371         return functionStaticCall(target, data, "Address: low-level static call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
376      * but performing a static call.
377      *
378      * _Available since v3.3._
379      */
380     function functionStaticCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         (bool success, bytes memory returndata) = target.staticcall(data);
388         return _verifyCallResult(success, returndata, errorMessage);
389     }
390 
391     function _verifyCallResult(
392         bool success,
393         bytes memory returndata,
394         string memory errorMessage
395     ) private pure returns (bytes memory) {
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 // File: https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/token/ERC20/utils/SafeERC20Upgradeable.sol
415 
416 pragma solidity ^0.8.0;
417 
418 
419 
420 /**
421  * @title SafeERC20
422  * @dev Wrappers around ERC20 operations that throw on failure (when the token
423  * contract returns false). Tokens that return no value (and instead revert or
424  * throw on failure) are also supported, non-reverting calls are assumed to be
425  * successful.
426  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
427  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
428  */
429 library SafeERC20Upgradeable {
430     using AddressUpgradeable for address;
431 
432     function safeTransfer(
433         IERC20Upgradeable token,
434         address to,
435         uint256 value
436     ) internal {
437         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
438     }
439 
440     function safeTransferFrom(
441         IERC20Upgradeable token,
442         address from,
443         address to,
444         uint256 value
445     ) internal {
446         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
447     }
448 
449     /**
450      * @dev Deprecated. This function has issues similar to the ones found in
451      * {IERC20-approve}, and its usage is discouraged.
452      *
453      * Whenever possible, use {safeIncreaseAllowance} and
454      * {safeDecreaseAllowance} instead.
455      */
456     function safeApprove(
457         IERC20Upgradeable token,
458         address spender,
459         uint256 value
460     ) internal {
461         // safeApprove should only be called when setting an initial allowance,
462         // or when resetting it to zero. To increase and decrease it, use
463         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
464         require(
465             (value == 0) || (token.allowance(address(this), spender) == 0),
466             "SafeERC20: approve from non-zero to non-zero allowance"
467         );
468         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
469     }
470 
471     function safeIncreaseAllowance(
472         IERC20Upgradeable token,
473         address spender,
474         uint256 value
475     ) internal {
476         uint256 newAllowance = token.allowance(address(this), spender) + value;
477         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
478     }
479 
480     function safeDecreaseAllowance(
481         IERC20Upgradeable token,
482         address spender,
483         uint256 value
484     ) internal {
485         unchecked {
486             uint256 oldAllowance = token.allowance(address(this), spender);
487             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
488             uint256 newAllowance = oldAllowance - value;
489             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
490         }
491     }
492 
493     /**
494      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
495      * on the return value: the return value is optional (but if data is returned, it must not be false).
496      * @param token The token targeted by the call.
497      * @param data The call data (encoded using abi.encode or one of its variants).
498      */
499     function _callOptionalReturn(IERC20Upgradeable token, bytes memory data) private {
500         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
501         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
502         // the target address contains contract code and also asserts for success in the low-level call.
503 
504         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
505         if (returndata.length > 0) {
506             // Return data is optional
507             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
508         }
509     }
510 }
511 
512 // File: https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable/blob/master/contracts/token/ERC20/IERC20Upgradeable.sol
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Interface of the ERC20 standard as defined in the EIP.
518  */
519 interface IERC20Upgradeable {
520     /**
521      * @dev Returns the amount of tokens in existence.
522      */
523     function totalSupply() external view returns (uint256);
524 
525     /**
526      * @dev Returns the amount of tokens owned by `account`.
527      */
528     function balanceOf(address account) external view returns (uint256);
529 
530     /**
531      * @dev Moves `amount` tokens from the caller's account to `recipient`.
532      *
533      * Returns a boolean value indicating whether the operation succeeded.
534      *
535      * Emits a {Transfer} event.
536      */
537     function transfer(address recipient, uint256 amount) external returns (bool);
538 
539     /**
540      * @dev Returns the remaining number of tokens that `spender` will be
541      * allowed to spend on behalf of `owner` through {transferFrom}. This is
542      * zero by default.
543      *
544      * This value changes when {approve} or {transferFrom} are called.
545      */
546     function allowance(address owner, address spender) external view returns (uint256);
547 
548     /**
549      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
550      *
551      * Returns a boolean value indicating whether the operation succeeded.
552      *
553      * IMPORTANT: Beware that changing an allowance with this method brings the risk
554      * that someone may use both the old and the new allowance by unfortunate
555      * transaction ordering. One possible solution to mitigate this race
556      * condition is to first reduce the spender's allowance to 0 and set the
557      * desired value afterwards:
558      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
559      *
560      * Emits an {Approval} event.
561      */
562     function approve(address spender, uint256 amount) external returns (bool);
563 
564     /**
565      * @dev Moves `amount` tokens from `sender` to `recipient` using the
566      * allowance mechanism. `amount` is then deducted from the caller's
567      * allowance.
568      *
569      * Returns a boolean value indicating whether the operation succeeded.
570      *
571      * Emits a {Transfer} event.
572      */
573     function transferFrom(
574         address sender,
575         address recipient,
576         uint256 amount
577     ) external returns (bool);
578 
579     /**
580      * @dev Emitted when `value` tokens are moved from one account (`from`) to
581      * another (`to`).
582      *
583      * Note that `value` may be zero.
584      */
585     event Transfer(address indexed from, address indexed to, uint256 value);
586 
587     /**
588      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
589      * a call to {approve}. `value` is the new allowance.
590      */
591     event Approval(address indexed owner, address indexed spender, uint256 value);
592 }
593 
594 // File: DailyVesting.sol
595 
596 pragma solidity 0.8;
597 pragma experimental ABIEncoderV2;
598 
599 contract DailyVesting {
600     using SafeERC20Upgradeable for IERC20Upgradeable;
601     using SafeMathUpgradeable for uint256;
602 
603     struct VestingPeriod {
604         uint128 vestingDays;
605         uint128 tokensPerDay;
606     }
607 
608     struct VestingClaimInfo {
609         uint128 lastClaim;
610         uint128 daysClaimed;
611     }
612 
613     //token to be distributed
614     IERC20Upgradeable public token;
615     //handles setup
616     address public setupAdmin;
617     //UTC timestamp from which first vesting period begins (i.e. tokens will first be released 30 days after this time)
618     uint256 public startTime;
619     //total token obligations from all unpaid vesting amounts
620     uint256 public totalObligations;
621     //keeps track of contract state
622     bool public setupComplete;
623     // how long to wait before unlocking admin access
624     uint256 public adminAccessDelay;
625 
626     //list of all beneficiaries
627     address[] public beneficiaries;
628 
629     //amount of tokens to be received by each beneficiary
630     mapping(address => VestingPeriod) public vestingPeriods;
631     mapping(address => VestingClaimInfo) public claimInfo;
632     //tracks if addresses have already been added as beneficiaries or not
633     mapping(address => bool) public beneficiaryAdded;
634 
635     event SetupCompleted();
636     event BeneficiaryAdded(address indexed user, uint256 totalAmountToClaim);
637     event TokensClaimed(address indexed user, uint256 amount); 
638 
639     modifier setupOnly() {
640         require(!setupComplete, "setup already completed");
641         _;
642     }
643 
644     modifier claimAllowed() {
645         require(setupComplete, "setup ongoing");
646         _;
647     }
648 
649     modifier onlyAdmin() {
650         require(msg.sender == setupAdmin, "not admin");
651         _;
652     }
653 
654     modifier whenAdminAccessAvailable() {
655         uint256 _startTime = startTime;
656 
657         require(_startTime < block.timestamp && block.timestamp - _startTime > adminAccessDelay, "admin access is not active");
658         _;
659     }
660 
661     constructor(
662         IERC20Upgradeable _token,
663         address _owner,
664         uint256 _startTime,
665         uint256 _adminAccessDelay
666     ) public {
667         adminAccessDelay = _adminAccessDelay;
668         token = _token;
669         setupAdmin = msg.sender;
670         startTime = _startTime == 0 ? block.timestamp : _startTime;
671     }
672 
673     // adds a list of beneficiaries
674     function addBeneficiaries(address[] memory _beneficiaries, VestingPeriod[] memory _vestingPeriods)
675         external
676         onlyAdmin
677         setupOnly
678     {
679         _setBeneficiaries(_beneficiaries, _vestingPeriods);
680     }
681 
682     function tokensToClaim(address _beneficiary) public view returns(uint256) {        
683         (uint256 tokensAmount,) = _tokensToClaim(_beneficiary, claimInfo[_beneficiary]);
684         return tokensAmount;
685     }
686 
687     /**
688         @dev This function returns tokensAmount available to claim. Calculates it based on several vesting periods if applicable.
689      */
690     function _tokensToClaim(address _beneficiary, VestingClaimInfo memory claim) private view returns(uint256 tokensAmount, uint256 daysClaimed) {
691         uint256 lastClaim = claim.lastClaim == 0 ? startTime : claim.lastClaim;
692 
693         if (lastClaim > block.timestamp) { // last claim was in the future (means startTime was set in the future)
694             return (0, 0);
695         }
696 
697         uint256 daysElapsed = (block.timestamp - lastClaim) / 1 days;
698         VestingPeriod memory vestingPeriod = vestingPeriods[_beneficiary];
699 
700         uint256 daysInPeriodToClaim = vestingPeriod.vestingDays - claim.daysClaimed;
701         if (daysInPeriodToClaim > daysElapsed) {
702             daysInPeriodToClaim = daysElapsed;
703         }
704 
705         tokensAmount = tokensAmount.add(
706             uint256(vestingPeriod.tokensPerDay).mul(daysInPeriodToClaim)
707         );
708 
709         daysElapsed -= daysInPeriodToClaim;
710         daysClaimed += daysInPeriodToClaim;
711     }
712 
713     // claims vested tokens for a given beneficiary
714     function claimFor(address _beneficiary) external claimAllowed {
715         _processClaim(_beneficiary);
716     }
717 
718     // convenience function for beneficiaries to call to claim all of their vested tokens
719     function claimForSelf() external claimAllowed {
720         _processClaim(msg.sender);
721     }
722 
723     // claims vested tokens for all beneficiaries
724     function claimForAll() external claimAllowed {
725         for (uint256 i = 0; i < beneficiaries.length; i++) {
726             _processClaim(beneficiaries[i]);
727         }
728     }
729 
730     // complete setup once all obligations are met, to remove the ability to
731     // reclaim tokens until vesting is complete, and allow claims to start
732     function endSetup() external onlyAdmin setupOnly {
733         uint256 tokenBalance = token.balanceOf(address(this));
734         require(tokenBalance >= totalObligations, "obligations not yet met");
735         setupComplete = true;
736         setupAdmin = address(0);
737         emit SetupCompleted();
738     }
739 
740     // reclaim tokens if necessary prior to finishing setup. otherwise reclaim any
741     // extra tokens after the end of vesting
742     function reclaimTokens() external onlyAdmin setupOnly {
743         token.transfer(setupAdmin, token.balanceOf(address(this)));
744     }
745 
746     function emergencyReclaimTokens() external onlyAdmin whenAdminAccessAvailable {
747         token.transfer(setupAdmin, token.balanceOf(address(this)));
748     }
749 
750     function emergencyOverrideBenefeciaries(address[] memory _beneficiaries, VestingPeriod[] memory _vestingPeriods) external onlyAdmin whenAdminAccessAvailable {
751         for (uint256 i = 0; i < _beneficiaries.length; i++) {
752             beneficiaryAdded[_beneficiaries[i]] = false;
753         }
754         _setBeneficiaries(_beneficiaries, _vestingPeriods);
755     }
756 
757     // Calculates the claimable tokens of a beneficiary and sends them.
758     function _processClaim(address _beneficiary) internal {
759         VestingClaimInfo memory claim = claimInfo[_beneficiary];
760         (uint256 amountToClaim, uint256 daysClaimed) = _tokensToClaim(_beneficiary, claim);
761 
762         if (amountToClaim == 0) {
763             return;
764         }
765 
766         claim.daysClaimed += uint128(daysClaimed);
767         claim.lastClaim = uint128(block.timestamp);
768         claimInfo[_beneficiary] = claim;
769 
770         _sendTokens(_beneficiary, amountToClaim);
771 
772         emit TokensClaimed(_beneficiary, amountToClaim);
773     }
774 
775     // send tokens to beneficiary and remove obligation
776     function _sendTokens(address _beneficiary, uint256 _amountToSend) internal {
777         totalObligations -= _amountToSend;
778         token.transfer(_beneficiary, _amountToSend);
779     }
780 
781     function _setBeneficiaries(address[] memory _beneficiaries, VestingPeriod[] memory _vestingPeriods) private {
782         require(_beneficiaries.length == _vestingPeriods.length, "input length mismatch");
783 
784         uint256 _totalObligations;
785         for (uint256 i = 0; i < _beneficiaries.length; i++) {
786             address beneficiary = _beneficiaries[i];
787 
788             require(!beneficiaryAdded[beneficiary], "beneficiary already added");
789             beneficiaryAdded[beneficiary] = true;
790 
791             uint256 amountToClaim;
792 
793             VestingPeriod memory period = _vestingPeriods[i];
794             amountToClaim = amountToClaim.add(
795                 uint256(period.vestingDays).mul(
796                     uint256(period.tokensPerDay)
797                 )
798             );
799             vestingPeriods[beneficiary] = period;
800             beneficiaries.push(beneficiary);
801             _totalObligations = _totalObligations.add(amountToClaim);
802 
803             emit BeneficiaryAdded(beneficiary, amountToClaim);
804         }
805 
806         totalObligations = totalObligations.add(_totalObligations);
807         token.safeTransferFrom(msg.sender, address(this), _totalObligations);
808     }
809 }