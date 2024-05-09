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
192 
193 pragma solidity >=0.6.0 <0.8.0;
194 
195 /**
196  * @dev Interface of the ERC20 standard as defined in the EIP.
197  */
198 interface IERC20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `recipient`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `sender` to `recipient` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Emitted when `value` tokens are moved from one account (`from`) to
256      * another (`to`).
257      *
258      * Note that `value` may be zero.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     /**
263      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
264      * a call to {approve}. `value` is the new allowance.
265      */
266     event Approval(address indexed owner, address indexed spender, uint256 value);
267 }
268 
269 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
270 
271 pragma solidity >=0.6.0 <0.8.0;
272 
273 /**
274  * @dev Wrappers over Solidity's arithmetic operations with added overflow
275  * checks.
276  *
277  * Arithmetic operations in Solidity wrap on overflow. This can easily result
278  * in bugs, because programmers usually assume that an overflow raises an
279  * error, which is the standard behavior in high level programming languages.
280  * `SafeMath` restores this intuition by reverting the transaction when an
281  * operation overflows.
282  *
283  * Using this library instead of the unchecked operations eliminates an entire
284  * class of bugs, so it's recommended to use it always.
285  */
286 library SafeMath {
287     /**
288      * @dev Returns the addition of two unsigned integers, with an overflow flag.
289      *
290      * _Available since v3.4._
291      */
292     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
293         uint256 c = a + b;
294         if (c < a) return (false, 0);
295         return (true, c);
296     }
297 
298     /**
299      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
300      *
301      * _Available since v3.4._
302      */
303     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
304         if (b > a) return (false, 0);
305         return (true, a - b);
306     }
307 
308     /**
309      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
310      *
311      * _Available since v3.4._
312      */
313     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
314         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
315         // benefit is lost if 'b' is also tested.
316         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
317         if (a == 0) return (true, 0);
318         uint256 c = a * b;
319         if (c / a != b) return (false, 0);
320         return (true, c);
321     }
322 
323     /**
324      * @dev Returns the division of two unsigned integers, with a division by zero flag.
325      *
326      * _Available since v3.4._
327      */
328     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
329         if (b == 0) return (false, 0);
330         return (true, a / b);
331     }
332 
333     /**
334      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
335      *
336      * _Available since v3.4._
337      */
338     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
339         if (b == 0) return (false, 0);
340         return (true, a % b);
341     }
342 
343     /**
344      * @dev Returns the addition of two unsigned integers, reverting on
345      * overflow.
346      *
347      * Counterpart to Solidity's `+` operator.
348      *
349      * Requirements:
350      *
351      * - Addition cannot overflow.
352      */
353     function add(uint256 a, uint256 b) internal pure returns (uint256) {
354         uint256 c = a + b;
355         require(c >= a, "SafeMath: addition overflow");
356         return c;
357     }
358 
359     /**
360      * @dev Returns the subtraction of two unsigned integers, reverting on
361      * overflow (when the result is negative).
362      *
363      * Counterpart to Solidity's `-` operator.
364      *
365      * Requirements:
366      *
367      * - Subtraction cannot overflow.
368      */
369     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
370         require(b <= a, "SafeMath: subtraction overflow");
371         return a - b;
372     }
373 
374     /**
375      * @dev Returns the multiplication of two unsigned integers, reverting on
376      * overflow.
377      *
378      * Counterpart to Solidity's `*` operator.
379      *
380      * Requirements:
381      *
382      * - Multiplication cannot overflow.
383      */
384     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
385         if (a == 0) return 0;
386         uint256 c = a * b;
387         require(c / a == b, "SafeMath: multiplication overflow");
388         return c;
389     }
390 
391     /**
392      * @dev Returns the integer division of two unsigned integers, reverting on
393      * division by zero. The result is rounded towards zero.
394      *
395      * Counterpart to Solidity's `/` operator. Note: this function uses a
396      * `revert` opcode (which leaves remaining gas untouched) while Solidity
397      * uses an invalid opcode to revert (consuming all remaining gas).
398      *
399      * Requirements:
400      *
401      * - The divisor cannot be zero.
402      */
403     function div(uint256 a, uint256 b) internal pure returns (uint256) {
404         require(b > 0, "SafeMath: division by zero");
405         return a / b;
406     }
407 
408     /**
409      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
410      * reverting when dividing by zero.
411      *
412      * Counterpart to Solidity's `%` operator. This function uses a `revert`
413      * opcode (which leaves remaining gas untouched) while Solidity uses an
414      * invalid opcode to revert (consuming all remaining gas).
415      *
416      * Requirements:
417      *
418      * - The divisor cannot be zero.
419      */
420     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
421         require(b > 0, "SafeMath: modulo by zero");
422         return a % b;
423     }
424 
425     /**
426      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
427      * overflow (when the result is negative).
428      *
429      * CAUTION: This function is deprecated because it requires allocating memory for the error
430      * message unnecessarily. For custom revert reasons use {trySub}.
431      *
432      * Counterpart to Solidity's `-` operator.
433      *
434      * Requirements:
435      *
436      * - Subtraction cannot overflow.
437      */
438     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
439         require(b <= a, errorMessage);
440         return a - b;
441     }
442 
443     /**
444      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
445      * division by zero. The result is rounded towards zero.
446      *
447      * CAUTION: This function is deprecated because it requires allocating memory for the error
448      * message unnecessarily. For custom revert reasons use {tryDiv}.
449      *
450      * Counterpart to Solidity's `/` operator. Note: this function uses a
451      * `revert` opcode (which leaves remaining gas untouched) while Solidity
452      * uses an invalid opcode to revert (consuming all remaining gas).
453      *
454      * Requirements:
455      *
456      * - The divisor cannot be zero.
457      */
458     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
459         require(b > 0, errorMessage);
460         return a / b;
461     }
462 
463     /**
464      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
465      * reverting with custom message when dividing by zero.
466      *
467      * CAUTION: This function is deprecated because it requires allocating memory for the error
468      * message unnecessarily. For custom revert reasons use {tryMod}.
469      *
470      * Counterpart to Solidity's `%` operator. This function uses a `revert`
471      * opcode (which leaves remaining gas untouched) while Solidity uses an
472      * invalid opcode to revert (consuming all remaining gas).
473      *
474      * Requirements:
475      *
476      * - The divisor cannot be zero.
477      */
478     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
479         require(b > 0, errorMessage);
480         return a % b;
481     }
482 }
483 
484 
485 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
486 
487 pragma solidity >=0.6.0 <0.8.0;
488 
489 
490 
491 /**
492  * @title SafeERC20
493  * @dev Wrappers around ERC20 operations that throw on failure (when the token
494  * contract returns false). Tokens that return no value (and instead revert or
495  * throw on failure) are also supported, non-reverting calls are assumed to be
496  * successful.
497  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
498  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
499  */
500 library SafeERC20 {
501     using SafeMath for uint256;
502     using Address for address;
503 
504     function safeTransfer(IERC20 token, address to, uint256 value) internal {
505         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
506     }
507 
508     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
509         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
510     }
511 
512     /**
513      * @dev Deprecated. This function has issues similar to the ones found in
514      * {IERC20-approve}, and its usage is discouraged.
515      *
516      * Whenever possible, use {safeIncreaseAllowance} and
517      * {safeDecreaseAllowance} instead.
518      */
519     function safeApprove(IERC20 token, address spender, uint256 value) internal {
520         // safeApprove should only be called when setting an initial allowance,
521         // or when resetting it to zero. To increase and decrease it, use
522         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
523         // solhint-disable-next-line max-line-length
524         require((value == 0) || (token.allowance(address(this), spender) == 0),
525             "SafeERC20: approve from non-zero to non-zero allowance"
526         );
527         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
528     }
529 
530     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
531         uint256 newAllowance = token.allowance(address(this), spender).add(value);
532         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
533     }
534 
535     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
536         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
537         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
538     }
539 
540     /**
541      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
542      * on the return value: the return value is optional (but if data is returned, it must not be false).
543      * @param token The token targeted by the call.
544      * @param data The call data (encoded using abi.encode or one of its variants).
545      */
546     function _callOptionalReturn(IERC20 token, bytes memory data) private {
547         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
548         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
549         // the target address contains contract code and also asserts for success in the low-level call.
550 
551         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
552         if (returndata.length > 0) { // Return data is optional
553             // solhint-disable-next-line max-line-length
554             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
555         }
556     }
557 }
558 
559 
560 // File: contracts\ClaimZap.sol
561 
562 pragma solidity 0.6.12;
563 
564 
565 library Math {
566     /**
567      * @dev Returns the smallest of two numbers.
568      */
569     function min(uint256 a, uint256 b) internal pure returns (uint256) {
570         return a < b ? a : b;
571     }
572 }
573 
574 interface IBasicRewards{
575     function getReward(address _account, bool _claimExtras) external;
576     function stakeFor(address, uint256) external;
577 }
578 
579 interface ICvxRewards{
580     function getReward(address _account, bool _claimExtras, bool _stake) external;
581 }
582 
583 interface IChefRewards{
584     function claim(uint256 _pid, address _account) external;
585 }
586 
587 interface ICvxCrvDeposit{
588     function deposit(uint256, bool) external;
589 }
590 
591 contract ClaimZap{
592     using SafeERC20 for IERC20;
593     using Address for address;
594     using SafeMath for uint256;
595 
596     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
597 
598     address public owner;
599     address public cvx;
600     address public cvxRewards;
601     address public cvxCrvRewards;
602     address public chefRewards;
603     address public crvDeposit;
604     address public cvxCrv;
605 
606     constructor(address _cvxRewards, address _cvxCrvRewards, address _chefRewards, address _cvx, address _cvxCrv, address _crvDeposit) public {
607         owner = msg.sender;
608         cvxRewards = _cvxRewards;
609         cvxCrvRewards = _cvxCrvRewards;
610         chefRewards = _chefRewards;
611         cvx = _cvx;
612         cvxCrv = _cvxCrv;
613         crvDeposit = _crvDeposit;
614     }
615 
616     function setCvxRewards(address _rewards) external {
617         require(msg.sender == owner, "!auth");
618         cvxRewards = _rewards;
619         IERC20(cvx).safeApprove(cvxRewards, 0);
620         IERC20(cvx).safeApprove(cvxRewards, uint256(-1));
621     }
622 
623     function setCvxCrvRewards(address _rewards) external {
624         require(msg.sender == owner, "!auth");
625         cvxCrvRewards = _rewards;
626         IERC20(cvxCrv).safeApprove(cvxCrvRewards, 0);
627         IERC20(cvxCrv).safeApprove(cvxCrvRewards, uint256(-1));
628     }
629 
630     function setChefRewards(address _rewards) external {
631         require(msg.sender == owner, "!auth");
632         chefRewards = _rewards;
633     }
634 
635     function setApprovals() external {
636         require(msg.sender == owner, "!auth");
637         IERC20(cvx).safeApprove(cvxRewards, 0);
638         IERC20(cvx).safeApprove(cvxRewards, uint256(-1));
639         IERC20(cvxCrv).safeApprove(cvxCrvRewards, 0);
640         IERC20(cvxCrv).safeApprove(cvxCrvRewards, uint256(-1));
641     }
642 
643     function claimRewards(
644         address[] calldata rewardContracts,
645         uint256[] calldata chefIds,
646         bool claimCvx,
647         bool claimCvxStake,
648         bool claimcvxCrv,
649         uint256 depositCrvMaxAmount,
650         uint256 depositCvxMaxAmount
651         ) external{
652 
653         //claim from main curve LP pools
654         for(uint256 i = 0; i < rewardContracts.length; i++){
655             if(rewardContracts[i] == address(0)) break;
656             IBasicRewards(rewardContracts[i]).getReward(msg.sender,true);
657         }
658 
659         //claim from master chef
660         for(uint256 i = 0; i < chefIds.length; i++){
661             IChefRewards(chefRewards).claim(chefIds[i],msg.sender);
662         }
663 
664         //claim (and stake) from cvx rewards
665         if(claimCvxStake){
666             ICvxRewards(cvxRewards).getReward(msg.sender,true,true);
667         }else if(claimCvx){
668             ICvxRewards(cvxRewards).getReward(msg.sender,true,false);
669         }
670 
671         //claim from cvxCrv rewards
672         if(claimcvxCrv){
673             IBasicRewards(cvxCrvRewards).getReward(msg.sender,true);
674         }
675 
676         //lock upto given amount of crv and stake
677         if(depositCrvMaxAmount > 0){
678             uint256 crvBalance = IERC20(crv).balanceOf(msg.sender);
679             crvBalance = Math.min(crvBalance, depositCrvMaxAmount);
680             if(crvBalance > 0){
681                 //pull crv
682                 IERC20(crv).safeTransferFrom(msg.sender, address(this), crvBalance);
683                 //deposit
684                 ICvxCrvDeposit(crvDeposit).deposit(crvBalance,true);
685                 //get cvxamount
686                 uint256 cvxCrvBalance = IERC20(cvxCrv).balanceOf(address(this));
687                 //stake for msg.sender
688                 IBasicRewards(cvxCrvRewards).stakeFor(msg.sender, cvxCrvBalance);
689             }
690         }
691 
692         //stake upto given amount of cvx
693         if(depositCvxMaxAmount > 0){
694             uint256 cvxBalance = IERC20(cvx).balanceOf(msg.sender);
695             cvxBalance = Math.min(cvxBalance, depositCvxMaxAmount);
696             if(cvxBalance > 0){
697                 //pull cvx
698                 IERC20(cvx).safeTransferFrom(msg.sender, address(this), cvxBalance);
699                 //stake for msg.sender
700                 IBasicRewards(cvxRewards).stakeFor(msg.sender, cvxBalance);
701             }
702         }
703     }
704 }