1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.2 <0.8.0;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies on extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { size := extcodesize(account) }
34         return size > 0;
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         require(isContract(target), "Address: call to non-contract");
117 
118         // solhint-disable-next-line avoid-low-level-calls
119         (bool success, bytes memory returndata) = target.call{ value: value }(data);
120         return _verifyCallResult(success, returndata, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
125      * but performing a static call.
126      *
127      * _Available since v3.3._
128      */
129     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
130         return functionStaticCall(target, data, "Address: low-level static call failed");
131     }
132 
133     /**
134      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
135      * but performing a static call.
136      *
137      * _Available since v3.3._
138      */
139     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
140         require(isContract(target), "Address: static call to non-contract");
141 
142         // solhint-disable-next-line avoid-low-level-calls
143         (bool success, bytes memory returndata) = target.staticcall(data);
144         return _verifyCallResult(success, returndata, errorMessage);
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
149      * but performing a delegate call.
150      *
151      * _Available since v3.4._
152      */
153     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
159      * but performing a delegate call.
160      *
161      * _Available since v3.4._
162      */
163     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
164         require(isContract(target), "Address: delegate call to non-contract");
165 
166         // solhint-disable-next-line avoid-low-level-calls
167         (bool success, bytes memory returndata) = target.delegatecall(data);
168         return _verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
172         if (success) {
173             return returndata;
174         } else {
175             // Look for revert reason and bubble it up if present
176             if (returndata.length > 0) {
177                 // The easiest way to bubble the revert reason is using memory via assembly
178 
179                 // solhint-disable-next-line no-inline-assembly
180                 assembly {
181                     let returndata_size := mload(returndata)
182                     revert(add(32, returndata), returndata_size)
183                 }
184             } else {
185                 revert(errorMessage);
186             }
187         }
188     }
189 }
190 
191 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
192 pragma solidity >=0.6.0 <0.8.0;
193 
194 /**
195  * @dev Interface of the ERC20 standard as defined in the EIP.
196  */
197 interface IERC20 {
198     /**
199      * @dev Returns the amount of tokens in existence.
200      */
201     function totalSupply() external view returns (uint256);
202 
203     /**
204      * @dev Returns the amount of tokens owned by `account`.
205      */
206     function balanceOf(address account) external view returns (uint256);
207 
208     /**
209      * @dev Moves `amount` tokens from the caller's account to `recipient`.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transfer(address recipient, uint256 amount) external returns (bool);
216 
217     /**
218      * @dev Returns the remaining number of tokens that `spender` will be
219      * allowed to spend on behalf of `owner` through {transferFrom}. This is
220      * zero by default.
221      *
222      * This value changes when {approve} or {transferFrom} are called.
223      */
224     function allowance(address owner, address spender) external view returns (uint256);
225 
226     /**
227      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * IMPORTANT: Beware that changing an allowance with this method brings the risk
232      * that someone may use both the old and the new allowance by unfortunate
233      * transaction ordering. One possible solution to mitigate this race
234      * condition is to first reduce the spender's allowance to 0 and set the
235      * desired value afterwards:
236      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
237      *
238      * Emits an {Approval} event.
239      */
240     function approve(address spender, uint256 amount) external returns (bool);
241 
242     /**
243      * @dev Moves `amount` tokens from `sender` to `recipient` using the
244      * allowance mechanism. `amount` is then deducted from the caller's
245      * allowance.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * Emits a {Transfer} event.
250      */
251     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
252 
253     /**
254      * @dev Emitted when `value` tokens are moved from one account (`from`) to
255      * another (`to`).
256      *
257      * Note that `value` may be zero.
258      */
259     event Transfer(address indexed from, address indexed to, uint256 value);
260 
261     /**
262      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
263      * a call to {approve}. `value` is the new allowance.
264      */
265     event Approval(address indexed owner, address indexed spender, uint256 value);
266 }
267 
268 
269 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
270 pragma solidity >=0.6.0 <0.8.0;
271 
272 /**
273  * @dev Wrappers over Solidity's arithmetic operations with added overflow
274  * checks.
275  *
276  * Arithmetic operations in Solidity wrap on overflow. This can easily result
277  * in bugs, because programmers usually assume that an overflow raises an
278  * error, which is the standard behavior in high level programming languages.
279  * `SafeMath` restores this intuition by reverting the transaction when an
280  * operation overflows.
281  *
282  * Using this library instead of the unchecked operations eliminates an entire
283  * class of bugs, so it's recommended to use it always.
284  */
285 library SafeMath {
286     /**
287      * @dev Returns the addition of two unsigned integers, with an overflow flag.
288      *
289      * _Available since v3.4._
290      */
291     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
292         uint256 c = a + b;
293         if (c < a) return (false, 0);
294         return (true, c);
295     }
296 
297     /**
298      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
299      *
300      * _Available since v3.4._
301      */
302     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
303         if (b > a) return (false, 0);
304         return (true, a - b);
305     }
306 
307     /**
308      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
309      *
310      * _Available since v3.4._
311      */
312     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
313         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
314         // benefit is lost if 'b' is also tested.
315         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
316         if (a == 0) return (true, 0);
317         uint256 c = a * b;
318         if (c / a != b) return (false, 0);
319         return (true, c);
320     }
321 
322     /**
323      * @dev Returns the division of two unsigned integers, with a division by zero flag.
324      *
325      * _Available since v3.4._
326      */
327     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
328         if (b == 0) return (false, 0);
329         return (true, a / b);
330     }
331 
332     /**
333      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
334      *
335      * _Available since v3.4._
336      */
337     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
338         if (b == 0) return (false, 0);
339         return (true, a % b);
340     }
341 
342     /**
343      * @dev Returns the addition of two unsigned integers, reverting on
344      * overflow.
345      *
346      * Counterpart to Solidity's `+` operator.
347      *
348      * Requirements:
349      *
350      * - Addition cannot overflow.
351      */
352     function add(uint256 a, uint256 b) internal pure returns (uint256) {
353         uint256 c = a + b;
354         require(c >= a, "SafeMath: addition overflow");
355         return c;
356     }
357 
358     /**
359      * @dev Returns the subtraction of two unsigned integers, reverting on
360      * overflow (when the result is negative).
361      *
362      * Counterpart to Solidity's `-` operator.
363      *
364      * Requirements:
365      *
366      * - Subtraction cannot overflow.
367      */
368     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
369         require(b <= a, "SafeMath: subtraction overflow");
370         return a - b;
371     }
372 
373     /**
374      * @dev Returns the multiplication of two unsigned integers, reverting on
375      * overflow.
376      *
377      * Counterpart to Solidity's `*` operator.
378      *
379      * Requirements:
380      *
381      * - Multiplication cannot overflow.
382      */
383     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
384         if (a == 0) return 0;
385         uint256 c = a * b;
386         require(c / a == b, "SafeMath: multiplication overflow");
387         return c;
388     }
389 
390     /**
391      * @dev Returns the integer division of two unsigned integers, reverting on
392      * division by zero. The result is rounded towards zero.
393      *
394      * Counterpart to Solidity's `/` operator. Note: this function uses a
395      * `revert` opcode (which leaves remaining gas untouched) while Solidity
396      * uses an invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      *
400      * - The divisor cannot be zero.
401      */
402     function div(uint256 a, uint256 b) internal pure returns (uint256) {
403         require(b > 0, "SafeMath: division by zero");
404         return a / b;
405     }
406 
407     /**
408      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
409      * reverting when dividing by zero.
410      *
411      * Counterpart to Solidity's `%` operator. This function uses a `revert`
412      * opcode (which leaves remaining gas untouched) while Solidity uses an
413      * invalid opcode to revert (consuming all remaining gas).
414      *
415      * Requirements:
416      *
417      * - The divisor cannot be zero.
418      */
419     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
420         require(b > 0, "SafeMath: modulo by zero");
421         return a % b;
422     }
423 
424     /**
425      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
426      * overflow (when the result is negative).
427      *
428      * CAUTION: This function is deprecated because it requires allocating memory for the error
429      * message unnecessarily. For custom revert reasons use {trySub}.
430      *
431      * Counterpart to Solidity's `-` operator.
432      *
433      * Requirements:
434      *
435      * - Subtraction cannot overflow.
436      */
437     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
438         require(b <= a, errorMessage);
439         return a - b;
440     }
441 
442     /**
443      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
444      * division by zero. The result is rounded towards zero.
445      *
446      * CAUTION: This function is deprecated because it requires allocating memory for the error
447      * message unnecessarily. For custom revert reasons use {tryDiv}.
448      *
449      * Counterpart to Solidity's `/` operator. Note: this function uses a
450      * `revert` opcode (which leaves remaining gas untouched) while Solidity
451      * uses an invalid opcode to revert (consuming all remaining gas).
452      *
453      * Requirements:
454      *
455      * - The divisor cannot be zero.
456      */
457     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
458         require(b > 0, errorMessage);
459         return a / b;
460     }
461 
462     /**
463      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
464      * reverting with custom message when dividing by zero.
465      *
466      * CAUTION: This function is deprecated because it requires allocating memory for the error
467      * message unnecessarily. For custom revert reasons use {tryMod}.
468      *
469      * Counterpart to Solidity's `%` operator. This function uses a `revert`
470      * opcode (which leaves remaining gas untouched) while Solidity uses an
471      * invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      *
475      * - The divisor cannot be zero.
476      */
477     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
478         require(b > 0, errorMessage);
479         return a % b;
480     }
481 }
482 
483 
484 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
485 pragma solidity >=0.6.0 <0.8.0;
486 
487 
488 
489 
490 /**
491  * @title SafeERC20
492  * @dev Wrappers around ERC20 operations that throw on failure (when the token
493  * contract returns false). Tokens that return no value (and instead revert or
494  * throw on failure) are also supported, non-reverting calls are assumed to be
495  * successful.
496  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
497  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
498  */
499 library SafeERC20 {
500     using SafeMath for uint256;
501     using Address for address;
502 
503     function safeTransfer(IERC20 token, address to, uint256 value) internal {
504         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
505     }
506 
507     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
508         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
509     }
510 
511     /**
512      * @dev Deprecated. This function has issues similar to the ones found in
513      * {IERC20-approve}, and its usage is discouraged.
514      *
515      * Whenever possible, use {safeIncreaseAllowance} and
516      * {safeDecreaseAllowance} instead.
517      */
518     function safeApprove(IERC20 token, address spender, uint256 value) internal {
519         // safeApprove should only be called when setting an initial allowance,
520         // or when resetting it to zero. To increase and decrease it, use
521         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
522         // solhint-disable-next-line max-line-length
523         require((value == 0) || (token.allowance(address(this), spender) == 0),
524             "SafeERC20: approve from non-zero to non-zero allowance"
525         );
526         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
527     }
528 
529     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
530         uint256 newAllowance = token.allowance(address(this), spender).add(value);
531         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
532     }
533 
534     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
535         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
536         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
537     }
538 
539     /**
540      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
541      * on the return value: the return value is optional (but if data is returned, it must not be false).
542      * @param token The token targeted by the call.
543      * @param data The call data (encoded using abi.encode or one of its variants).
544      */
545     function _callOptionalReturn(IERC20 token, bytes memory data) private {
546         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
547         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
548         // the target address contains contract code and also asserts for success in the low-level call.
549 
550         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
551         if (returndata.length > 0) { // Return data is optional
552             // solhint-disable-next-line max-line-length
553             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
554         }
555     }
556 }
557 
558 // File: contracts\ClaimZap.sol
559 pragma solidity 0.6.12;
560 
561 
562 library Math {
563     /**
564      * @dev Returns the smallest of two numbers.
565      */
566     function min(uint256 a, uint256 b) internal pure returns (uint256) {
567         return a < b ? a : b;
568     }
569 }
570 
571 interface IBasicRewards{
572     function getReward(address _account, bool _claimExtras) external;
573     function stakeFor(address, uint256) external;
574 }
575 
576 interface ICvxRewards{
577     function getReward(address _account, bool _claimExtras, bool _stake) external;
578 }
579 
580 interface IChefRewards{
581     function claim(uint256 _pid, address _account) external;
582 }
583 
584 interface ICvxCrvDeposit{
585     function deposit(uint256, bool) external;
586 }
587 
588 contract ClaimZap{
589     using SafeERC20 for IERC20;
590     using Address for address;
591     using SafeMath for uint256;
592 
593     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
594     address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
595     address public constant cvxCrv = address(0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7);
596     address public constant crvDeposit = address(0x8014595F2AB54cD7c604B00E9fb932176fDc86Ae);
597     address public constant cvxCrvRewards = address(0x3Fe65692bfCD0e6CF84cB1E7d24108E434A7587e);
598     address public constant cvxRewards = address(0xCF50b810E57Ac33B91dCF525C6ddd9881B139332);
599 
600     address public immutable owner;
601     address public chefRewards;
602 
603     constructor() public {
604         owner = msg.sender;
605         chefRewards = address(0x5F465e9fcfFc217c5849906216581a657cd60605);
606     }
607 
608     function setChefRewards(address _rewards) external {
609         require(msg.sender == owner, "!auth");
610         chefRewards = _rewards;
611     }
612 
613     function setApprovals() external {
614         require(msg.sender == owner, "!auth");
615         IERC20(crv).safeApprove(crvDeposit, 0);
616         IERC20(crv).safeApprove(crvDeposit, uint256(-1));
617         IERC20(cvx).safeApprove(cvxRewards, 0);
618         IERC20(cvx).safeApprove(cvxRewards, uint256(-1));
619         IERC20(cvxCrv).safeApprove(cvxCrvRewards, 0);
620         IERC20(cvxCrv).safeApprove(cvxCrvRewards, uint256(-1));
621     }
622 
623     function claimRewards(
624         address[] calldata rewardContracts,
625         uint256[] calldata chefIds,
626         bool claimCvx,
627         bool claimCvxStake,
628         bool claimcvxCrv,
629         uint256 depositCrvMaxAmount,
630         uint256 depositCvxMaxAmount
631         ) external{
632 
633         //claim from main curve LP pools
634         for(uint256 i = 0; i < rewardContracts.length; i++){
635             if(rewardContracts[i] == address(0)) break;
636             IBasicRewards(rewardContracts[i]).getReward(msg.sender,true);
637         }
638 
639         //claim from master chef
640         for(uint256 i = 0; i < chefIds.length; i++){
641             IChefRewards(chefRewards).claim(chefIds[i],msg.sender);
642         }
643 
644         //claim (and stake) from cvx rewards
645         if(claimCvxStake){
646             ICvxRewards(cvxRewards).getReward(msg.sender,true,true);
647         }else if(claimCvx){
648             ICvxRewards(cvxRewards).getReward(msg.sender,true,false);
649         }
650 
651         //claim from cvxCrv rewards
652         if(claimcvxCrv){
653             IBasicRewards(cvxCrvRewards).getReward(msg.sender,true);
654         }
655 
656         //lock upto given amount of crv and stake
657         if(depositCrvMaxAmount > 0){
658             uint256 crvBalance = IERC20(crv).balanceOf(msg.sender);
659             crvBalance = Math.min(crvBalance, depositCrvMaxAmount);
660             if(crvBalance > 0){
661                 //pull crv
662                 IERC20(crv).safeTransferFrom(msg.sender, address(this), crvBalance);
663                 //deposit
664                 ICvxCrvDeposit(crvDeposit).deposit(crvBalance,true);
665                 //get cvxamount
666                 uint256 cvxCrvBalance = IERC20(cvxCrv).balanceOf(address(this));
667                 //stake for msg.sender
668                 IBasicRewards(cvxCrvRewards).stakeFor(msg.sender, cvxCrvBalance);
669             }
670         }
671 
672         //stake upto given amount of cvx
673         if(depositCvxMaxAmount > 0){
674             uint256 cvxBalance = IERC20(cvx).balanceOf(msg.sender);
675             cvxBalance = Math.min(cvxBalance, depositCvxMaxAmount);
676             if(cvxBalance > 0){
677                 //pull cvx
678                 IERC20(cvx).safeTransferFrom(msg.sender, address(this), cvxBalance);
679                 //stake for msg.sender
680                 IBasicRewards(cvxRewards).stakeFor(msg.sender, cvxBalance);
681             }
682         }
683     }
684 }