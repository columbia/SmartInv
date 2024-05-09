1 // SPDX-License-Identifier: MIT
2 // File: contracts\Interfaces.sol
3 
4 pragma solidity 0.6.12;
5 
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library MathUtil {
11     /**
12      * @dev Returns the smallest of two numbers.
13      */
14     function min(uint256 a, uint256 b) internal pure returns (uint256) {
15         return a < b ? a : b;
16     }
17 }
18 
19 contract ReentrancyGuard {
20     uint256 private _guardCounter;
21 
22     constructor () internal {
23         _guardCounter = 1;
24     }
25 
26     modifier nonReentrant() {
27         _guardCounter += 1;
28         uint256 localCounter = _guardCounter;
29         _;
30         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
31     }
32 }
33 
34 interface ICurveGauge {
35     function deposit(uint256) external;
36     function balanceOf(address) external view returns (uint256);
37     function withdraw(uint256) external;
38     function claim_rewards() external;
39     function reward_tokens(uint256) external view returns(address);//v2
40     function rewarded_token() external view returns(address);//v1
41 }
42 
43 interface ICurveVoteEscrow {
44     function create_lock(uint256, uint256) external;
45     function increase_amount(uint256) external;
46     function increase_unlock_time(uint256) external;
47     function withdraw() external;
48     function smart_wallet_checker() external view returns (address);
49 }
50 
51 interface IWalletChecker {
52     function check(address) external view returns (bool);
53 }
54 
55 interface IVoting{
56     function vote(uint256, bool, bool) external; //voteId, support, executeIfDecided
57     function getVote(uint256) external view returns(bool,bool,uint64,uint64,uint64,uint64,uint256,uint256,uint256,bytes memory); 
58     function vote_for_gauge_weights(address,uint256) external;
59 }
60 
61 interface IMinter{
62     function mint(address) external;
63 }
64 
65 interface IRegistry{
66     function get_registry() external view returns(address);
67     function get_address(uint256 _id) external view returns(address);
68     function gauge_controller() external view returns(address);
69     function get_lp_token(address) external view returns(address);
70     function get_gauges(address) external view returns(address[10] memory,uint128[10] memory);
71 }
72 
73 interface IStaker{
74     function deposit(address, address) external;
75     function withdraw(address) external;
76     function withdraw(address, address, uint256) external;
77     function withdrawAll(address, address) external;
78     function createLock(uint256, uint256) external;
79     function increaseAmount(uint256) external;
80     function increaseTime(uint256) external;
81     function release() external;
82     function claimCrv(address) external returns (uint256);
83     function claimRewards(address) external;
84     function claimFees(address,address) external;
85     function setStashAccess(address, bool) external;
86     function vote(uint256,address,bool) external;
87     function voteGaugeWeight(address,uint256) external;
88     function balanceOfPool(address) external view returns (uint256);
89     function operator() external view returns (address);
90     function execute(address _to, uint256 _value, bytes calldata _data) external returns (bool, bytes memory);
91 }
92 
93 interface IRewards{
94     function stake(address, uint256) external;
95     function stakeFor(address, uint256) external;
96     function withdraw(address, uint256) external;
97     function exit(address) external;
98     function getReward(address) external;
99     function queueNewRewards(uint256) external;
100     function notifyRewardAmount(uint256) external;
101     function addExtraReward(address) external;
102     function stakingToken() external returns (address);
103 }
104 
105 interface IStash{
106     function stashRewards() external returns (bool);
107     function processStash() external returns (bool);
108     function claimRewards() external returns (bool);
109 }
110 
111 interface IFeeDistro{
112     function claim() external;
113     function token() external view returns(address);
114 }
115 
116 interface ITokenMinter{
117     function mint(address,uint256) external;
118     function burn(address,uint256) external;
119 }
120 
121 interface IDeposit{
122     function isShutdown() external view returns(bool);
123     function balanceOf(address _account) external view returns(uint256);
124     function totalSupply() external view returns(uint256);
125     function poolInfo(uint256) external view returns(address,address,address,address,address, bool);
126     function rewardClaimed(uint256,address,uint256) external;
127     function withdrawTo(uint256,uint256,address) external;
128     function claimRewards(uint256,address) external returns(bool);
129     function rewardArbitrator() external returns(address);
130 }
131 
132 interface ICrvDeposit{
133     function deposit(uint256, bool) external;
134     function lockIncentive() external view returns(uint256);
135 }
136 
137 interface IRewardFactory{
138     function setAccess(address,bool) external;
139     function CreateCrvRewards(uint256,address) external returns(address);
140     function CreateTokenRewards(address,address,address) external returns(address);
141     function activeRewardCount(address) external view returns(uint256);
142     function addActiveReward(address,uint256) external returns(bool);
143     function removeActiveReward(address,uint256) external returns(bool);
144 }
145 
146 interface IStashFactory{
147     function CreateStash(uint256,address,address,uint256) external returns(address);
148 }
149 
150 interface ITokenFactory{
151     function CreateDepositToken(address) external returns(address);
152 }
153 
154 interface IPools{
155     function addPool(address _lptoken, address _gauge, uint256 _stashVersion) external returns(bool);
156     function shutdownPool(uint256 _pid) external returns(bool);
157     function poolInfo(uint256) external view returns(address,address,address,address,address,bool);
158     function poolLength() external view returns (uint256);
159     function gaugeMap(address) external view returns(bool);
160     function setPoolManager(address _poolM) external;
161 }
162 
163 interface IVestedEscrow{
164     function fund(address[] calldata _recipient, uint256[] calldata _amount) external returns(bool);
165 }
166 
167 // File: @openzeppelin\contracts\math\SafeMath.sol
168 pragma solidity >=0.6.0 <0.8.0;
169 
170 /**
171  * @dev Wrappers over Solidity's arithmetic operations with added overflow
172  * checks.
173  *
174  * Arithmetic operations in Solidity wrap on overflow. This can easily result
175  * in bugs, because programmers usually assume that an overflow raises an
176  * error, which is the standard behavior in high level programming languages.
177  * `SafeMath` restores this intuition by reverting the transaction when an
178  * operation overflows.
179  *
180  * Using this library instead of the unchecked operations eliminates an entire
181  * class of bugs, so it's recommended to use it always.
182  */
183 library SafeMath {
184     /**
185      * @dev Returns the addition of two unsigned integers, with an overflow flag.
186      *
187      * _Available since v3.4._
188      */
189     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
190         uint256 c = a + b;
191         if (c < a) return (false, 0);
192         return (true, c);
193     }
194 
195     /**
196      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
197      *
198      * _Available since v3.4._
199      */
200     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
201         if (b > a) return (false, 0);
202         return (true, a - b);
203     }
204 
205     /**
206      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
207      *
208      * _Available since v3.4._
209      */
210     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
211         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
212         // benefit is lost if 'b' is also tested.
213         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
214         if (a == 0) return (true, 0);
215         uint256 c = a * b;
216         if (c / a != b) return (false, 0);
217         return (true, c);
218     }
219 
220     /**
221      * @dev Returns the division of two unsigned integers, with a division by zero flag.
222      *
223      * _Available since v3.4._
224      */
225     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
226         if (b == 0) return (false, 0);
227         return (true, a / b);
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
232      *
233      * _Available since v3.4._
234      */
235     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
236         if (b == 0) return (false, 0);
237         return (true, a % b);
238     }
239 
240     /**
241      * @dev Returns the addition of two unsigned integers, reverting on
242      * overflow.
243      *
244      * Counterpart to Solidity's `+` operator.
245      *
246      * Requirements:
247      *
248      * - Addition cannot overflow.
249      */
250     function add(uint256 a, uint256 b) internal pure returns (uint256) {
251         uint256 c = a + b;
252         require(c >= a, "SafeMath: addition overflow");
253         return c;
254     }
255 
256     /**
257      * @dev Returns the subtraction of two unsigned integers, reverting on
258      * overflow (when the result is negative).
259      *
260      * Counterpart to Solidity's `-` operator.
261      *
262      * Requirements:
263      *
264      * - Subtraction cannot overflow.
265      */
266     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
267         require(b <= a, "SafeMath: subtraction overflow");
268         return a - b;
269     }
270 
271     /**
272      * @dev Returns the multiplication of two unsigned integers, reverting on
273      * overflow.
274      *
275      * Counterpart to Solidity's `*` operator.
276      *
277      * Requirements:
278      *
279      * - Multiplication cannot overflow.
280      */
281     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
282         if (a == 0) return 0;
283         uint256 c = a * b;
284         require(c / a == b, "SafeMath: multiplication overflow");
285         return c;
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers, reverting on
290      * division by zero. The result is rounded towards zero.
291      *
292      * Counterpart to Solidity's `/` operator. Note: this function uses a
293      * `revert` opcode (which leaves remaining gas untouched) while Solidity
294      * uses an invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function div(uint256 a, uint256 b) internal pure returns (uint256) {
301         require(b > 0, "SafeMath: division by zero");
302         return a / b;
303     }
304 
305     /**
306      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
307      * reverting when dividing by zero.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
318         require(b > 0, "SafeMath: modulo by zero");
319         return a % b;
320     }
321 
322     /**
323      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
324      * overflow (when the result is negative).
325      *
326      * CAUTION: This function is deprecated because it requires allocating memory for the error
327      * message unnecessarily. For custom revert reasons use {trySub}.
328      *
329      * Counterpart to Solidity's `-` operator.
330      *
331      * Requirements:
332      *
333      * - Subtraction cannot overflow.
334      */
335     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b <= a, errorMessage);
337         return a - b;
338     }
339 
340     /**
341      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
342      * division by zero. The result is rounded towards zero.
343      *
344      * CAUTION: This function is deprecated because it requires allocating memory for the error
345      * message unnecessarily. For custom revert reasons use {tryDiv}.
346      *
347      * Counterpart to Solidity's `/` operator. Note: this function uses a
348      * `revert` opcode (which leaves remaining gas untouched) while Solidity
349      * uses an invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      *
353      * - The divisor cannot be zero.
354      */
355     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
356         require(b > 0, errorMessage);
357         return a / b;
358     }
359 
360     /**
361      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
362      * reverting with custom message when dividing by zero.
363      *
364      * CAUTION: This function is deprecated because it requires allocating memory for the error
365      * message unnecessarily. For custom revert reasons use {tryMod}.
366      *
367      * Counterpart to Solidity's `%` operator. This function uses a `revert`
368      * opcode (which leaves remaining gas untouched) while Solidity uses an
369      * invalid opcode to revert (consuming all remaining gas).
370      *
371      * Requirements:
372      *
373      * - The divisor cannot be zero.
374      */
375     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
376         require(b > 0, errorMessage);
377         return a % b;
378     }
379 }
380 
381 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
382 
383 pragma solidity >=0.6.0 <0.8.0;
384 
385 /**
386  * @dev Interface of the ERC20 standard as defined in the EIP.
387  */
388 interface IERC20 {
389     /**
390      * @dev Returns the amount of tokens in existence.
391      */
392     function totalSupply() external view returns (uint256);
393 
394     /**
395      * @dev Returns the amount of tokens owned by `account`.
396      */
397     function balanceOf(address account) external view returns (uint256);
398 
399     /**
400      * @dev Moves `amount` tokens from the caller's account to `recipient`.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transfer(address recipient, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Returns the remaining number of tokens that `spender` will be
410      * allowed to spend on behalf of `owner` through {transferFrom}. This is
411      * zero by default.
412      *
413      * This value changes when {approve} or {transferFrom} are called.
414      */
415     function allowance(address owner, address spender) external view returns (uint256);
416 
417     /**
418      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
419      *
420      * Returns a boolean value indicating whether the operation succeeded.
421      *
422      * IMPORTANT: Beware that changing an allowance with this method brings the risk
423      * that someone may use both the old and the new allowance by unfortunate
424      * transaction ordering. One possible solution to mitigate this race
425      * condition is to first reduce the spender's allowance to 0 and set the
426      * desired value afterwards:
427      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
428      *
429      * Emits an {Approval} event.
430      */
431     function approve(address spender, uint256 amount) external returns (bool);
432 
433     /**
434      * @dev Moves `amount` tokens from `sender` to `recipient` using the
435      * allowance mechanism. `amount` is then deducted from the caller's
436      * allowance.
437      *
438      * Returns a boolean value indicating whether the operation succeeded.
439      *
440      * Emits a {Transfer} event.
441      */
442     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
443 
444     /**
445      * @dev Emitted when `value` tokens are moved from one account (`from`) to
446      * another (`to`).
447      *
448      * Note that `value` may be zero.
449      */
450     event Transfer(address indexed from, address indexed to, uint256 value);
451 
452     /**
453      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
454      * a call to {approve}. `value` is the new allowance.
455      */
456     event Approval(address indexed owner, address indexed spender, uint256 value);
457 }
458 
459 // File: @openzeppelin\contracts\utils\Address.sol
460 
461 pragma solidity >=0.6.2 <0.8.0;
462 
463 /**
464  * @dev Collection of functions related to the address type
465  */
466 library Address {
467     /**
468      * @dev Returns true if `account` is a contract.
469      *
470      * [IMPORTANT]
471      * ====
472      * It is unsafe to assume that an address for which this function returns
473      * false is an externally-owned account (EOA) and not a contract.
474      *
475      * Among others, `isContract` will return false for the following
476      * types of addresses:
477      *
478      *  - an externally-owned account
479      *  - a contract in construction
480      *  - an address where a contract will be created
481      *  - an address where a contract lived, but was destroyed
482      * ====
483      */
484     function isContract(address account) internal view returns (bool) {
485         // This method relies on extcodesize, which returns 0 for contracts in
486         // construction, since the code is only stored at the end of the
487         // constructor execution.
488 
489         uint256 size;
490         // solhint-disable-next-line no-inline-assembly
491         assembly { size := extcodesize(account) }
492         return size > 0;
493     }
494 
495     /**
496      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
497      * `recipient`, forwarding all available gas and reverting on errors.
498      *
499      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
500      * of certain opcodes, possibly making contracts go over the 2300 gas limit
501      * imposed by `transfer`, making them unable to receive funds via
502      * `transfer`. {sendValue} removes this limitation.
503      *
504      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
505      *
506      * IMPORTANT: because control is transferred to `recipient`, care must be
507      * taken to not create reentrancy vulnerabilities. Consider using
508      * {ReentrancyGuard} or the
509      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
510      */
511     function sendValue(address payable recipient, uint256 amount) internal {
512         require(address(this).balance >= amount, "Address: insufficient balance");
513 
514         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
515         (bool success, ) = recipient.call{ value: amount }("");
516         require(success, "Address: unable to send value, recipient may have reverted");
517     }
518 
519     /**
520      * @dev Performs a Solidity function call using a low level `call`. A
521      * plain`call` is an unsafe replacement for a function call: use this
522      * function instead.
523      *
524      * If `target` reverts with a revert reason, it is bubbled up by this
525      * function (like regular Solidity function calls).
526      *
527      * Returns the raw returned data. To convert to the expected return value,
528      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
529      *
530      * Requirements:
531      *
532      * - `target` must be a contract.
533      * - calling `target` with `data` must not revert.
534      *
535      * _Available since v3.1._
536      */
537     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
538       return functionCall(target, data, "Address: low-level call failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
543      * `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
548         return functionCallWithValue(target, data, 0, errorMessage);
549     }
550 
551     /**
552      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
553      * but also transferring `value` wei to `target`.
554      *
555      * Requirements:
556      *
557      * - the calling contract must have an ETH balance of at least `value`.
558      * - the called Solidity function must be `payable`.
559      *
560      * _Available since v3.1._
561      */
562     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
563         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
564     }
565 
566     /**
567      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
568      * with `errorMessage` as a fallback revert reason when `target` reverts.
569      *
570      * _Available since v3.1._
571      */
572     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
573         require(address(this).balance >= value, "Address: insufficient balance for call");
574         require(isContract(target), "Address: call to non-contract");
575 
576         // solhint-disable-next-line avoid-low-level-calls
577         (bool success, bytes memory returndata) = target.call{ value: value }(data);
578         return _verifyCallResult(success, returndata, errorMessage);
579     }
580 
581     /**
582      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
583      * but performing a static call.
584      *
585      * _Available since v3.3._
586      */
587     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
588         return functionStaticCall(target, data, "Address: low-level static call failed");
589     }
590 
591     /**
592      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
593      * but performing a static call.
594      *
595      * _Available since v3.3._
596      */
597     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
598         require(isContract(target), "Address: static call to non-contract");
599 
600         // solhint-disable-next-line avoid-low-level-calls
601         (bool success, bytes memory returndata) = target.staticcall(data);
602         return _verifyCallResult(success, returndata, errorMessage);
603     }
604 
605     /**
606      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
607      * but performing a delegate call.
608      *
609      * _Available since v3.4._
610      */
611     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
612         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
613     }
614 
615     /**
616      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
617      * but performing a delegate call.
618      *
619      * _Available since v3.4._
620      */
621     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
622         require(isContract(target), "Address: delegate call to non-contract");
623 
624         // solhint-disable-next-line avoid-low-level-calls
625         (bool success, bytes memory returndata) = target.delegatecall(data);
626         return _verifyCallResult(success, returndata, errorMessage);
627     }
628 
629     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
630         if (success) {
631             return returndata;
632         } else {
633             // Look for revert reason and bubble it up if present
634             if (returndata.length > 0) {
635                 // The easiest way to bubble the revert reason is using memory via assembly
636 
637                 // solhint-disable-next-line no-inline-assembly
638                 assembly {
639                     let returndata_size := mload(returndata)
640                     revert(add(32, returndata), returndata_size)
641                 }
642             } else {
643                 revert(errorMessage);
644             }
645         }
646     }
647 }
648 
649 
650 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
651 
652 pragma solidity >=0.6.0 <0.8.0;
653 
654 /**
655  * @title SafeERC20
656  * @dev Wrappers around ERC20 operations that throw on failure (when the token
657  * contract returns false). Tokens that return no value (and instead revert or
658  * throw on failure) are also supported, non-reverting calls are assumed to be
659  * successful.
660  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
661  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
662  */
663 library SafeERC20 {
664     using SafeMath for uint256;
665     using Address for address;
666 
667     function safeTransfer(IERC20 token, address to, uint256 value) internal {
668         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
669     }
670 
671     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
672         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
673     }
674 
675     /**
676      * @dev Deprecated. This function has issues similar to the ones found in
677      * {IERC20-approve}, and its usage is discouraged.
678      *
679      * Whenever possible, use {safeIncreaseAllowance} and
680      * {safeDecreaseAllowance} instead.
681      */
682     function safeApprove(IERC20 token, address spender, uint256 value) internal {
683         // safeApprove should only be called when setting an initial allowance,
684         // or when resetting it to zero. To increase and decrease it, use
685         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
686         // solhint-disable-next-line max-line-length
687         require((value == 0) || (token.allowance(address(this), spender) == 0),
688             "SafeERC20: approve from non-zero to non-zero allowance"
689         );
690         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
691     }
692 
693     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
694         uint256 newAllowance = token.allowance(address(this), spender).add(value);
695         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
696     }
697 
698     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
699         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
700         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
701     }
702 
703     /**
704      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
705      * on the return value: the return value is optional (but if data is returned, it must not be false).
706      * @param token The token targeted by the call.
707      * @param data The call data (encoded using abi.encode or one of its variants).
708      */
709     function _callOptionalReturn(IERC20 token, bytes memory data) private {
710         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
711         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
712         // the target address contains contract code and also asserts for success in the low-level call.
713 
714         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
715         if (returndata.length > 0) { // Return data is optional
716             // solhint-disable-next-line max-line-length
717             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
718         }
719     }
720 }
721 
722 // File: contracts\CrvDepositor.sol
723 
724 pragma solidity 0.6.12;
725 
726 
727 contract CrvDepositor{
728     using SafeERC20 for IERC20;
729     using Address for address;
730     using SafeMath for uint256;
731 
732     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
733     address public constant escrow = address(0x5f3b5DfEb7B28CDbD7FAba78963EE202a494e2A2);
734     uint256 private constant MAXTIME = 4 * 364 * 86400;
735     uint256 private constant WEEK = 7 * 86400;
736 
737     uint256 public lockIncentive = 10; //incentive to users who spend gas to lock crv
738     uint256 public constant FEE_DENOMINATOR = 10000;
739 
740     address public feeManager;
741     address public immutable staker;
742     address public immutable minter;
743     uint256 public incentiveCrv = 0;
744     uint256 public unlockTime;
745 
746     constructor(address _staker, address _minter) public {
747         staker = _staker;
748         minter = _minter;
749         feeManager = msg.sender;
750     }
751 
752     function setFeeManager(address _feeManager) external {
753         require(msg.sender == feeManager, "!auth");
754         feeManager = _feeManager;
755     }
756 
757     function setFees(uint256 _lockIncentive) external{
758         require(msg.sender==feeManager, "!auth");
759 
760         if(_lockIncentive >= 0 && _lockIncentive <= 30){
761             lockIncentive = _lockIncentive;
762        }
763     }
764 
765     function initialLock() external{
766         require(msg.sender==feeManager, "!auth");
767 
768         uint256 vecrv = IERC20(escrow).balanceOf(staker);
769         if(vecrv == 0){
770             uint256 unlockAt = block.timestamp + MAXTIME;
771             uint256 unlockInWeeks = (unlockAt/WEEK)*WEEK;
772 
773             //release old lock if exists
774             IStaker(staker).release();
775             //create new lock
776             uint256 crvBalanceStaker = IERC20(crv).balanceOf(staker);
777             IStaker(staker).createLock(crvBalanceStaker, unlockAt);
778             unlockTime = unlockInWeeks;
779         }
780     }
781 
782     //lock curve
783     function _lockCurve() internal {
784         uint256 crvBalance = IERC20(crv).balanceOf(address(this));
785         if(crvBalance > 0){
786             IERC20(crv).safeTransfer(staker, crvBalance);
787         }
788         
789         //increase ammount
790         uint256 crvBalanceStaker = IERC20(crv).balanceOf(staker);
791         if(crvBalanceStaker == 0){
792             return;
793         }
794         
795         //increase amount
796         IStaker(staker).increaseAmount(crvBalanceStaker);
797         
798 
799         uint256 unlockAt = block.timestamp + MAXTIME;
800         uint256 unlockInWeeks = (unlockAt/WEEK)*WEEK;
801 
802         //increase time too if over 2 week buffer
803         if(unlockInWeeks.sub(unlockTime) > 2){
804             IStaker(staker).increaseTime(unlockAt);
805             unlockTime = unlockInWeeks;
806         }
807     }
808 
809     function lockCurve() external {
810         _lockCurve();
811 
812         //mint incentives
813         if(incentiveCrv > 0){
814             ITokenMinter(minter).mint(msg.sender,incentiveCrv);
815             incentiveCrv = 0;
816         }
817     }
818 
819     //deposit crv for cvxCrv
820     //can locking immediately or defer locking to someone else by paying a fee.
821     //while users can choose to lock or defer, this is mostly in place so that
822     //the cvx reward contract isnt costly to claim rewards
823     function deposit(uint256 _amount, bool _lock, address _stakeAddress) public {
824         require(_amount > 0,"!>0");
825         
826         if(_lock){
827             //lock immediately, transfer directly to staker to skip an erc20 transfer
828             IERC20(crv).safeTransferFrom(msg.sender, staker, _amount);
829             _lockCurve();
830             if(incentiveCrv > 0){
831                 //add the incentive tokens here so they can be staked together
832                 _amount = _amount.add(incentiveCrv);
833                 incentiveCrv = 0;
834             }
835         }else{
836             //move tokens here
837             IERC20(crv).safeTransferFrom(msg.sender, address(this), _amount);
838             //defer lock cost to another user
839             uint256 callIncentive = _amount.mul(lockIncentive).div(FEE_DENOMINATOR);
840             _amount = _amount.sub(callIncentive);
841 
842             //add to a pool for lock caller
843             incentiveCrv = incentiveCrv.add(callIncentive);
844         }
845 
846         bool depositOnly = _stakeAddress == address(0);
847         if(depositOnly){
848             //mint for msg.sender
849             ITokenMinter(minter).mint(msg.sender,_amount);
850         }else{
851             //mint here 
852             ITokenMinter(minter).mint(address(this),_amount);
853             //stake for msg.sender
854             IERC20(minter).safeApprove(_stakeAddress,0);
855             IERC20(minter).safeApprove(_stakeAddress,_amount);
856             IRewards(_stakeAddress).stakeFor(msg.sender,_amount);
857         }
858     }
859 
860     function deposit(uint256 _amount, bool _lock) external {
861         deposit(_amount,_lock,address(0));
862     }
863 
864     function depositAll(bool _lock, address _stakeAddress) external{
865         uint256 crvBal = IERC20(crv).balanceOf(msg.sender);
866         deposit(crvBal,_lock,_stakeAddress);
867     }
868 }