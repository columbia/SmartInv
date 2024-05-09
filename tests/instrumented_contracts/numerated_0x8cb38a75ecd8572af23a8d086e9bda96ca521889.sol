1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin\contracts\utils\Address.sol
4 
5 pragma solidity >=0.6.2 <0.8.0;
6 
7 /**
8  * @dev Collection of functions related to the address type
9  */
10 library Address {
11     /**
12      * @dev Returns true if `account` is a contract.
13      *
14      * [IMPORTANT]
15      * ====
16      * It is unsafe to assume that an address for which this function returns
17      * false is an externally-owned account (EOA) and not a contract.
18      *
19      * Among others, `isContract` will return false for the following
20      * types of addresses:
21      *
22      *  - an externally-owned account
23      *  - a contract in construction
24      *  - an address where a contract will be created
25      *  - an address where a contract lived, but was destroyed
26      * ====
27      */
28     function isContract(address account) internal view returns (bool) {
29         // This method relies on extcodesize, which returns 0 for contracts in
30         // construction, since the code is only stored at the end of the
31         // constructor execution.
32 
33         uint256 size;
34         // solhint-disable-next-line no-inline-assembly
35         assembly { size := extcodesize(account) }
36         return size > 0;
37     }
38 
39     /**
40      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
41      * `recipient`, forwarding all available gas and reverting on errors.
42      *
43      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
44      * of certain opcodes, possibly making contracts go over the 2300 gas limit
45      * imposed by `transfer`, making them unable to receive funds via
46      * `transfer`. {sendValue} removes this limitation.
47      *
48      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
49      *
50      * IMPORTANT: because control is transferred to `recipient`, care must be
51      * taken to not create reentrancy vulnerabilities. Consider using
52      * {ReentrancyGuard} or the
53      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
54      */
55     function sendValue(address payable recipient, uint256 amount) internal {
56         require(address(this).balance >= amount, "Address: insufficient balance");
57 
58         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
59         (bool success, ) = recipient.call{ value: amount }("");
60         require(success, "Address: unable to send value, recipient may have reverted");
61     }
62 
63     /**
64      * @dev Performs a Solidity function call using a low level `call`. A
65      * plain`call` is an unsafe replacement for a function call: use this
66      * function instead.
67      *
68      * If `target` reverts with a revert reason, it is bubbled up by this
69      * function (like regular Solidity function calls).
70      *
71      * Returns the raw returned data. To convert to the expected return value,
72      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
73      *
74      * Requirements:
75      *
76      * - `target` must be a contract.
77      * - calling `target` with `data` must not revert.
78      *
79      * _Available since v3.1._
80      */
81     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
82       return functionCall(target, data, "Address: low-level call failed");
83     }
84 
85     /**
86      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
87      * `errorMessage` as a fallback revert reason when `target` reverts.
88      *
89      * _Available since v3.1._
90      */
91     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
92         return functionCallWithValue(target, data, 0, errorMessage);
93     }
94 
95     /**
96      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
97      * but also transferring `value` wei to `target`.
98      *
99      * Requirements:
100      *
101      * - the calling contract must have an ETH balance of at least `value`.
102      * - the called Solidity function must be `payable`.
103      *
104      * _Available since v3.1._
105      */
106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
108     }
109 
110     /**
111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
112      * with `errorMessage` as a fallback revert reason when `target` reverts.
113      *
114      * _Available since v3.1._
115      */
116     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
117         require(address(this).balance >= value, "Address: insufficient balance for call");
118         require(isContract(target), "Address: call to non-contract");
119 
120         // solhint-disable-next-line avoid-low-level-calls
121         (bool success, bytes memory returndata) = target.call{ value: value }(data);
122         return _verifyCallResult(success, returndata, errorMessage);
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
127      * but performing a static call.
128      *
129      * _Available since v3.3._
130      */
131     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
132         return functionStaticCall(target, data, "Address: low-level static call failed");
133     }
134 
135     /**
136      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
137      * but performing a static call.
138      *
139      * _Available since v3.3._
140      */
141     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
142         require(isContract(target), "Address: static call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.staticcall(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but performing a delegate call.
152      *
153      * _Available since v3.4._
154      */
155     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
156         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
161      * but performing a delegate call.
162      *
163      * _Available since v3.4._
164      */
165     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
166         require(isContract(target), "Address: delegate call to non-contract");
167 
168         // solhint-disable-next-line avoid-low-level-calls
169         (bool success, bytes memory returndata) = target.delegatecall(data);
170         return _verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
174         if (success) {
175             return returndata;
176         } else {
177             // Look for revert reason and bubble it up if present
178             if (returndata.length > 0) {
179                 // The easiest way to bubble the revert reason is using memory via assembly
180 
181                 // solhint-disable-next-line no-inline-assembly
182                 assembly {
183                     let returndata_size := mload(returndata)
184                     revert(add(32, returndata), returndata_size)
185                 }
186             } else {
187                 revert(errorMessage);
188             }
189         }
190     }
191 }
192 
193 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
194 pragma solidity >=0.6.0 <0.8.0;
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP.
198  */
199 interface IERC20 {
200     /**
201      * @dev Returns the amount of tokens in existence.
202      */
203     function totalSupply() external view returns (uint256);
204 
205     /**
206      * @dev Returns the amount of tokens owned by `account`.
207      */
208     function balanceOf(address account) external view returns (uint256);
209 
210     /**
211      * @dev Moves `amount` tokens from the caller's account to `recipient`.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transfer(address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Returns the remaining number of tokens that `spender` will be
221      * allowed to spend on behalf of `owner` through {transferFrom}. This is
222      * zero by default.
223      *
224      * This value changes when {approve} or {transferFrom} are called.
225      */
226     function allowance(address owner, address spender) external view returns (uint256);
227 
228     /**
229      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
230      *
231      * Returns a boolean value indicating whether the operation succeeded.
232      *
233      * IMPORTANT: Beware that changing an allowance with this method brings the risk
234      * that someone may use both the old and the new allowance by unfortunate
235      * transaction ordering. One possible solution to mitigate this race
236      * condition is to first reduce the spender's allowance to 0 and set the
237      * desired value afterwards:
238      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
239      *
240      * Emits an {Approval} event.
241      */
242     function approve(address spender, uint256 amount) external returns (bool);
243 
244     /**
245      * @dev Moves `amount` tokens from `sender` to `recipient` using the
246      * allowance mechanism. `amount` is then deducted from the caller's
247      * allowance.
248      *
249      * Returns a boolean value indicating whether the operation succeeded.
250      *
251      * Emits a {Transfer} event.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
254 
255     /**
256      * @dev Emitted when `value` tokens are moved from one account (`from`) to
257      * another (`to`).
258      *
259      * Note that `value` may be zero.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 value);
262 
263     /**
264      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
265      * a call to {approve}. `value` is the new allowance.
266      */
267     event Approval(address indexed owner, address indexed spender, uint256 value);
268 }
269 
270 
271 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
272 pragma solidity >=0.6.0 <0.8.0;
273 
274 /**
275  * @dev Wrappers over Solidity's arithmetic operations with added overflow
276  * checks.
277  *
278  * Arithmetic operations in Solidity wrap on overflow. This can easily result
279  * in bugs, because programmers usually assume that an overflow raises an
280  * error, which is the standard behavior in high level programming languages.
281  * `SafeMath` restores this intuition by reverting the transaction when an
282  * operation overflows.
283  *
284  * Using this library instead of the unchecked operations eliminates an entire
285  * class of bugs, so it's recommended to use it always.
286  */
287 library SafeMath {
288     /**
289      * @dev Returns the addition of two unsigned integers, with an overflow flag.
290      *
291      * _Available since v3.4._
292      */
293     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
294         uint256 c = a + b;
295         if (c < a) return (false, 0);
296         return (true, c);
297     }
298 
299     /**
300      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
301      *
302      * _Available since v3.4._
303      */
304     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
305         if (b > a) return (false, 0);
306         return (true, a - b);
307     }
308 
309     /**
310      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
311      *
312      * _Available since v3.4._
313      */
314     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
315         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
316         // benefit is lost if 'b' is also tested.
317         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
318         if (a == 0) return (true, 0);
319         uint256 c = a * b;
320         if (c / a != b) return (false, 0);
321         return (true, c);
322     }
323 
324     /**
325      * @dev Returns the division of two unsigned integers, with a division by zero flag.
326      *
327      * _Available since v3.4._
328      */
329     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
330         if (b == 0) return (false, 0);
331         return (true, a / b);
332     }
333 
334     /**
335      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
336      *
337      * _Available since v3.4._
338      */
339     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
340         if (b == 0) return (false, 0);
341         return (true, a % b);
342     }
343 
344     /**
345      * @dev Returns the addition of two unsigned integers, reverting on
346      * overflow.
347      *
348      * Counterpart to Solidity's `+` operator.
349      *
350      * Requirements:
351      *
352      * - Addition cannot overflow.
353      */
354     function add(uint256 a, uint256 b) internal pure returns (uint256) {
355         uint256 c = a + b;
356         require(c >= a, "SafeMath: addition overflow");
357         return c;
358     }
359 
360     /**
361      * @dev Returns the subtraction of two unsigned integers, reverting on
362      * overflow (when the result is negative).
363      *
364      * Counterpart to Solidity's `-` operator.
365      *
366      * Requirements:
367      *
368      * - Subtraction cannot overflow.
369      */
370     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
371         require(b <= a, "SafeMath: subtraction overflow");
372         return a - b;
373     }
374 
375     /**
376      * @dev Returns the multiplication of two unsigned integers, reverting on
377      * overflow.
378      *
379      * Counterpart to Solidity's `*` operator.
380      *
381      * Requirements:
382      *
383      * - Multiplication cannot overflow.
384      */
385     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
386         if (a == 0) return 0;
387         uint256 c = a * b;
388         require(c / a == b, "SafeMath: multiplication overflow");
389         return c;
390     }
391 
392     /**
393      * @dev Returns the integer division of two unsigned integers, reverting on
394      * division by zero. The result is rounded towards zero.
395      *
396      * Counterpart to Solidity's `/` operator. Note: this function uses a
397      * `revert` opcode (which leaves remaining gas untouched) while Solidity
398      * uses an invalid opcode to revert (consuming all remaining gas).
399      *
400      * Requirements:
401      *
402      * - The divisor cannot be zero.
403      */
404     function div(uint256 a, uint256 b) internal pure returns (uint256) {
405         require(b > 0, "SafeMath: division by zero");
406         return a / b;
407     }
408 
409     /**
410      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
411      * reverting when dividing by zero.
412      *
413      * Counterpart to Solidity's `%` operator. This function uses a `revert`
414      * opcode (which leaves remaining gas untouched) while Solidity uses an
415      * invalid opcode to revert (consuming all remaining gas).
416      *
417      * Requirements:
418      *
419      * - The divisor cannot be zero.
420      */
421     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
422         require(b > 0, "SafeMath: modulo by zero");
423         return a % b;
424     }
425 
426     /**
427      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
428      * overflow (when the result is negative).
429      *
430      * CAUTION: This function is deprecated because it requires allocating memory for the error
431      * message unnecessarily. For custom revert reasons use {trySub}.
432      *
433      * Counterpart to Solidity's `-` operator.
434      *
435      * Requirements:
436      *
437      * - Subtraction cannot overflow.
438      */
439     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
440         require(b <= a, errorMessage);
441         return a - b;
442     }
443 
444     /**
445      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
446      * division by zero. The result is rounded towards zero.
447      *
448      * CAUTION: This function is deprecated because it requires allocating memory for the error
449      * message unnecessarily. For custom revert reasons use {tryDiv}.
450      *
451      * Counterpart to Solidity's `/` operator. Note: this function uses a
452      * `revert` opcode (which leaves remaining gas untouched) while Solidity
453      * uses an invalid opcode to revert (consuming all remaining gas).
454      *
455      * Requirements:
456      *
457      * - The divisor cannot be zero.
458      */
459     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
460         require(b > 0, errorMessage);
461         return a / b;
462     }
463 
464     /**
465      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
466      * reverting with custom message when dividing by zero.
467      *
468      * CAUTION: This function is deprecated because it requires allocating memory for the error
469      * message unnecessarily. For custom revert reasons use {tryMod}.
470      *
471      * Counterpart to Solidity's `%` operator. This function uses a `revert`
472      * opcode (which leaves remaining gas untouched) while Solidity uses an
473      * invalid opcode to revert (consuming all remaining gas).
474      *
475      * Requirements:
476      *
477      * - The divisor cannot be zero.
478      */
479     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
480         require(b > 0, errorMessage);
481         return a % b;
482     }
483 }
484 
485 
486 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
487 
488 pragma solidity >=0.6.0 <0.8.0;
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
559 
560 pragma solidity 0.6.12;
561 
562 
563 library Math {
564     /**
565      * @dev Returns the smallest of two numbers.
566      */
567     function min(uint256 a, uint256 b) internal pure returns (uint256) {
568         return a < b ? a : b;
569     }
570 }
571 
572 interface IBasicRewards{
573     function getReward(address _account, bool _claimExtras) external;
574     function getReward(address _account) external;
575     function stakeFor(address, uint256) external;
576 }
577 
578 interface ICvxRewards{
579     function getReward(address _account, bool _claimExtras, bool _stake) external;
580 }
581 
582 interface IChefRewards{
583     function claim(uint256 _pid, address _account) external;
584 }
585 
586 interface ICvxCrvDeposit{
587     function deposit(uint256, bool) external;
588 }
589 
590 interface ISwapExchange {
591     function swapExactTokensForTokens(
592         uint256,
593         uint256,
594         address[] calldata,
595         address,
596         uint256
597     ) external;
598 }
599 
600 contract ClaimZap{
601     using SafeERC20 for IERC20;
602     using Address for address;
603     using SafeMath for uint256;
604 
605     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
606     address public constant cvx = address(0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B);
607     address public constant cvxCrv = address(0x62B9c7356A2Dc64a1969e19C23e4f579F9810Aa7);
608     address public constant crvDeposit = address(0x8014595F2AB54cD7c604B00E9fb932176fDc86Ae);
609     address public constant cvxCrvRewards = address(0x3Fe65692bfCD0e6CF84cB1E7d24108E434A7587e);
610     address public constant cvxRewards = address(0xCF50b810E57Ac33B91dCF525C6ddd9881B139332);
611 
612     address public constant exchange = address(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F);
613 
614     address public immutable owner;
615 
616     constructor() public {
617         owner = msg.sender;
618     }
619 
620     function setApprovals() external {
621         require(msg.sender == owner, "!auth");
622         IERC20(crv).safeApprove(crvDeposit, 0);
623         IERC20(crv).safeApprove(crvDeposit, uint256(-1));
624         IERC20(crv).safeApprove(exchange, 0);
625         IERC20(crv).safeApprove(exchange, uint256(-1));
626 
627         IERC20(cvx).safeApprove(cvxRewards, 0);
628         IERC20(cvx).safeApprove(cvxRewards, uint256(-1));
629 
630         IERC20(cvxCrv).safeApprove(cvxCrvRewards, 0);
631         IERC20(cvxCrv).safeApprove(cvxCrvRewards, uint256(-1));
632     }
633 
634     function claimRewards(
635         address[] calldata rewardContracts,
636         address[] calldata extraRewardContracts,
637         bool claimCvx,
638         bool claimCvxStake,
639         bool claimcvxCrv,
640         bool lockCrvDeposit,
641         uint256 depositCrvMaxAmount,
642         uint256 minAmountOut,
643         uint256 depositCvxMaxAmount
644         ) external{
645 
646         uint256 crvBalance = IERC20(crv).balanceOf(msg.sender);
647         uint256 cvxBalance = IERC20(cvx).balanceOf(msg.sender);
648 
649         //claim from main curve LP pools
650         for(uint256 i = 0; i < rewardContracts.length; i++){
651             if(rewardContracts[i] == address(0)) break;
652             IBasicRewards(rewardContracts[i]).getReward(msg.sender,true);
653         }
654 
655         for(uint256 i = 0; i < extraRewardContracts.length; i++){
656             if(extraRewardContracts[i] == address(0)) break;
657             IBasicRewards(extraRewardContracts[i]).getReward(msg.sender);
658         }
659 
660         //claim (and stake) from cvx rewards
661         if(claimCvxStake){
662             ICvxRewards(cvxRewards).getReward(msg.sender,true,true);
663         }else if(claimCvx){
664             ICvxRewards(cvxRewards).getReward(msg.sender,true,false);
665         }
666 
667         //claim from cvxCrv rewards
668         if(claimcvxCrv){
669             IBasicRewards(cvxCrvRewards).getReward(msg.sender,true);
670         }
671 
672         //lock upto given amount of crv and stake
673         if(depositCrvMaxAmount > 0){
674             crvBalance = IERC20(crv).balanceOf(msg.sender).sub(crvBalance);
675             crvBalance = Math.min(crvBalance, depositCrvMaxAmount);
676             if(crvBalance > 0){
677                 //pull crv
678                 IERC20(crv).safeTransferFrom(msg.sender, address(this), crvBalance);
679                 if(minAmountOut > 0){
680                     //swap
681                     address[] memory path = new address[](2);
682                     path[0] = crv;
683                     path[1] = cvxCrv;
684                     ISwapExchange(exchange).swapExactTokensForTokens(crvBalance,minAmountOut,path,address(this),now.add(1800));
685                 }else{
686                     //deposit
687                     ICvxCrvDeposit(crvDeposit).deposit(crvBalance,lockCrvDeposit);
688                 }
689                 //get cvxamount
690                 uint256 cvxCrvBalance = IERC20(cvxCrv).balanceOf(address(this));
691                 //stake for msg.sender
692                 IBasicRewards(cvxCrvRewards).stakeFor(msg.sender, cvxCrvBalance);
693             }
694         }
695 
696         //stake upto given amount of cvx
697         if(depositCvxMaxAmount > 0){
698             cvxBalance = IERC20(cvx).balanceOf(msg.sender).sub(cvxBalance);
699             cvxBalance = Math.min(cvxBalance, depositCvxMaxAmount);
700             if(cvxBalance > 0){
701                 //pull cvx
702                 IERC20(cvx).safeTransferFrom(msg.sender, address(this), cvxBalance);
703                 //stake for msg.sender
704                 IBasicRewards(cvxRewards).stakeFor(msg.sender, cvxBalance);
705             }
706         }
707     }
708 
709 }