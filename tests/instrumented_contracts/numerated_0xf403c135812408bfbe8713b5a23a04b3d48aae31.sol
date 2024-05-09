1 // SPDX-License-Identifier: MIT
2 // File: contracts\Interfaces.sol
3 
4 pragma solidity 0.6.12;
5 
6 /**
7  * @dev Standard math utilities missing in the Solidity language.
8  */
9 library MathUtil {
10     /**
11      * @dev Returns the smallest of two numbers.
12      */
13     function min(uint256 a, uint256 b) internal pure returns (uint256) {
14         return a < b ? a : b;
15     }
16 }
17 
18 contract ReentrancyGuard {
19     uint256 private _guardCounter;
20 
21     constructor () internal {
22         _guardCounter = 1;
23     }
24 
25     modifier nonReentrant() {
26         _guardCounter += 1;
27         uint256 localCounter = _guardCounter;
28         _;
29         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
30     }
31 }
32 
33 interface ICurveGauge {
34     function deposit(uint256) external;
35     function balanceOf(address) external view returns (uint256);
36     function withdraw(uint256) external;
37     function claim_rewards() external;
38     function reward_tokens(uint256) external view returns(address);//v2
39     function rewarded_token() external view returns(address);//v1
40 }
41 
42 interface ICurveVoteEscrow {
43     function create_lock(uint256, uint256) external;
44     function increase_amount(uint256) external;
45     function increase_unlock_time(uint256) external;
46     function withdraw() external;
47     function smart_wallet_checker() external view returns (address);
48 }
49 
50 interface IWalletChecker {
51     function check(address) external view returns (bool);
52 }
53 
54 interface IVoting{
55     function vote(uint256, bool, bool) external; //voteId, support, executeIfDecided
56     function getVote(uint256) external view returns(bool,bool,uint64,uint64,uint64,uint64,uint256,uint256,uint256,bytes memory); 
57     function vote_for_gauge_weights(address,uint256) external;
58 }
59 
60 interface IMinter{
61     function mint(address) external;
62 }
63 
64 interface IRegistry{
65     function get_registry() external view returns(address);
66     function get_address(uint256 _id) external view returns(address);
67     function gauge_controller() external view returns(address);
68     function get_lp_token(address) external view returns(address);
69     function get_gauges(address) external view returns(address[10] memory,uint128[10] memory);
70 }
71 
72 interface IStaker{
73     function deposit(address, address) external;
74     function withdraw(address) external;
75     function withdraw(address, address, uint256) external;
76     function withdrawAll(address, address) external;
77     function createLock(uint256, uint256) external;
78     function increaseAmount(uint256) external;
79     function increaseTime(uint256) external;
80     function release() external;
81     function claimCrv(address) external returns (uint256);
82     function claimRewards(address) external;
83     function claimFees(address,address) external;
84     function setStashAccess(address, bool) external;
85     function vote(uint256,address,bool) external;
86     function voteGaugeWeight(address,uint256) external;
87     function balanceOfPool(address) external view returns (uint256);
88     function operator() external view returns (address);
89     function execute(address _to, uint256 _value, bytes calldata _data) external returns (bool, bytes memory);
90 }
91 
92 interface IRewards{
93     function stake(address, uint256) external;
94     function stakeFor(address, uint256) external;
95     function withdraw(address, uint256) external;
96     function exit(address) external;
97     function getReward(address) external;
98     function queueNewRewards(uint256) external;
99     function notifyRewardAmount(uint256) external;
100     function addExtraReward(address) external;
101     function stakingToken() external returns (address);
102 }
103 
104 interface IStash{
105     function stashRewards() external returns (bool);
106     function processStash() external returns (bool);
107     function claimRewards() external returns (bool);
108 }
109 
110 interface IFeeDistro{
111     function claim() external;
112     function token() external view returns(address);
113 }
114 
115 interface ITokenMinter{
116     function mint(address,uint256) external;
117     function burn(address,uint256) external;
118 }
119 
120 interface IDeposit{
121     function isShutdown() external view returns(bool);
122     function balanceOf(address _account) external view returns(uint256);
123     function totalSupply() external view returns(uint256);
124     function poolInfo(uint256) external view returns(address,address,address,address,address, bool);
125     function rewardClaimed(uint256,address,uint256) external;
126     function withdrawTo(uint256,uint256,address) external;
127     function claimRewards(uint256,address) external returns(bool);
128     function rewardArbitrator() external returns(address);
129 }
130 
131 interface ICrvDeposit{
132     function deposit(uint256, bool) external;
133     function lockIncentive() external view returns(uint256);
134 }
135 
136 interface IRewardFactory{
137     function setAccess(address,bool) external;
138     function CreateCrvRewards(uint256,address) external returns(address);
139     function CreateTokenRewards(address,address,address) external returns(address);
140     function activeRewardCount(address) external view returns(uint256);
141     function addActiveReward(address,uint256) external returns(bool);
142     function removeActiveReward(address,uint256) external returns(bool);
143 }
144 
145 interface IStashFactory{
146     function CreateStash(uint256,address,address,uint256) external returns(address);
147 }
148 
149 interface ITokenFactory{
150     function CreateDepositToken(address) external returns(address);
151 }
152 
153 interface IPools{
154     function addPool(address _lptoken, address _gauge, uint256 _stashVersion) external returns(bool);
155     function shutdownPool(uint256 _pid) external returns(bool);
156     function poolInfo(uint256) external view returns(address,address,address,address,address,bool);
157     function poolLength() external view returns (uint256);
158     function gaugeMap(address) external view returns(bool);
159     function setPoolManager(address _poolM) external;
160 }
161 
162 interface IVestedEscrow{
163     function fund(address[] calldata _recipient, uint256[] calldata _amount) external returns(bool);
164 }
165 
166 // File: @openzeppelin\contracts\math\SafeMath.sol
167 
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
460 pragma solidity >=0.6.2 <0.8.0;
461 
462 /**
463  * @dev Collection of functions related to the address type
464  */
465 library Address {
466     /**
467      * @dev Returns true if `account` is a contract.
468      *
469      * [IMPORTANT]
470      * ====
471      * It is unsafe to assume that an address for which this function returns
472      * false is an externally-owned account (EOA) and not a contract.
473      *
474      * Among others, `isContract` will return false for the following
475      * types of addresses:
476      *
477      *  - an externally-owned account
478      *  - a contract in construction
479      *  - an address where a contract will be created
480      *  - an address where a contract lived, but was destroyed
481      * ====
482      */
483     function isContract(address account) internal view returns (bool) {
484         // This method relies on extcodesize, which returns 0 for contracts in
485         // construction, since the code is only stored at the end of the
486         // constructor execution.
487 
488         uint256 size;
489         // solhint-disable-next-line no-inline-assembly
490         assembly { size := extcodesize(account) }
491         return size > 0;
492     }
493 
494     /**
495      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
496      * `recipient`, forwarding all available gas and reverting on errors.
497      *
498      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
499      * of certain opcodes, possibly making contracts go over the 2300 gas limit
500      * imposed by `transfer`, making them unable to receive funds via
501      * `transfer`. {sendValue} removes this limitation.
502      *
503      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
504      *
505      * IMPORTANT: because control is transferred to `recipient`, care must be
506      * taken to not create reentrancy vulnerabilities. Consider using
507      * {ReentrancyGuard} or the
508      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
509      */
510     function sendValue(address payable recipient, uint256 amount) internal {
511         require(address(this).balance >= amount, "Address: insufficient balance");
512 
513         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
514         (bool success, ) = recipient.call{ value: amount }("");
515         require(success, "Address: unable to send value, recipient may have reverted");
516     }
517 
518     /**
519      * @dev Performs a Solidity function call using a low level `call`. A
520      * plain`call` is an unsafe replacement for a function call: use this
521      * function instead.
522      *
523      * If `target` reverts with a revert reason, it is bubbled up by this
524      * function (like regular Solidity function calls).
525      *
526      * Returns the raw returned data. To convert to the expected return value,
527      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
528      *
529      * Requirements:
530      *
531      * - `target` must be a contract.
532      * - calling `target` with `data` must not revert.
533      *
534      * _Available since v3.1._
535      */
536     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
537       return functionCall(target, data, "Address: low-level call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
542      * `errorMessage` as a fallback revert reason when `target` reverts.
543      *
544      * _Available since v3.1._
545      */
546     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
547         return functionCallWithValue(target, data, 0, errorMessage);
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
552      * but also transferring `value` wei to `target`.
553      *
554      * Requirements:
555      *
556      * - the calling contract must have an ETH balance of at least `value`.
557      * - the called Solidity function must be `payable`.
558      *
559      * _Available since v3.1._
560      */
561     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
562         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
567      * with `errorMessage` as a fallback revert reason when `target` reverts.
568      *
569      * _Available since v3.1._
570      */
571     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
572         require(address(this).balance >= value, "Address: insufficient balance for call");
573         require(isContract(target), "Address: call to non-contract");
574 
575         // solhint-disable-next-line avoid-low-level-calls
576         (bool success, bytes memory returndata) = target.call{ value: value }(data);
577         return _verifyCallResult(success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
582      * but performing a static call.
583      *
584      * _Available since v3.3._
585      */
586     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
587         return functionStaticCall(target, data, "Address: low-level static call failed");
588     }
589 
590     /**
591      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
592      * but performing a static call.
593      *
594      * _Available since v3.3._
595      */
596     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
597         require(isContract(target), "Address: static call to non-contract");
598 
599         // solhint-disable-next-line avoid-low-level-calls
600         (bool success, bytes memory returndata) = target.staticcall(data);
601         return _verifyCallResult(success, returndata, errorMessage);
602     }
603 
604     /**
605      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
606      * but performing a delegate call.
607      *
608      * _Available since v3.4._
609      */
610     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
611         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
612     }
613 
614     /**
615      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
616      * but performing a delegate call.
617      *
618      * _Available since v3.4._
619      */
620     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
621         require(isContract(target), "Address: delegate call to non-contract");
622 
623         // solhint-disable-next-line avoid-low-level-calls
624         (bool success, bytes memory returndata) = target.delegatecall(data);
625         return _verifyCallResult(success, returndata, errorMessage);
626     }
627 
628     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
629         if (success) {
630             return returndata;
631         } else {
632             // Look for revert reason and bubble it up if present
633             if (returndata.length > 0) {
634                 // The easiest way to bubble the revert reason is using memory via assembly
635 
636                 // solhint-disable-next-line no-inline-assembly
637                 assembly {
638                     let returndata_size := mload(returndata)
639                     revert(add(32, returndata), returndata_size)
640                 }
641             } else {
642                 revert(errorMessage);
643             }
644         }
645     }
646 }
647 
648 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
649 
650 
651 pragma solidity >=0.6.0 <0.8.0;
652 
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
722 // File: contracts\Booster.sol
723 
724 pragma solidity 0.6.12;
725 
726 
727 
728 contract Booster{
729     using SafeERC20 for IERC20;
730     using Address for address;
731     using SafeMath for uint256;
732 
733     address public constant crv = address(0xD533a949740bb3306d119CC777fa900bA034cd52);
734     address public constant registry = address(0x0000000022D53366457F9d5E68Ec105046FC4383);
735     uint256 public constant distributionAddressId = 4;
736     address public constant voteOwnership = address(0xE478de485ad2fe566d49342Cbd03E49ed7DB3356);
737     address public constant voteParameter = address(0xBCfF8B0b9419b9A88c44546519b1e909cF330399);
738 
739     uint256 public lockIncentive = 1000; //incentive to crv stakers
740     uint256 public stakerIncentive = 450; //incentive to native token stakers
741     uint256 public earmarkIncentive = 50; //incentive to users who spend gas to make calls
742     uint256 public platformFee = 0; //possible fee to build treasury
743     uint256 public constant MaxFees = 2000;
744     uint256 public constant FEE_DENOMINATOR = 10000;
745 
746     address public owner;
747     address public feeManager;
748     address public poolManager;
749     address public immutable staker;
750     address public immutable minter;
751     address public rewardFactory;
752     address public stashFactory;
753     address public tokenFactory;
754     address public rewardArbitrator;
755     address public voteDelegate;
756     address public treasury;
757     address public stakerRewards; //cvx rewards
758     address public lockRewards; //cvxCrv rewards(crv)
759     address public lockFees; //cvxCrv vecrv fees
760     address public feeDistro;
761     address public feeToken;
762 
763     bool public isShutdown;
764 
765     struct PoolInfo {
766         address lptoken;
767         address token;
768         address gauge;
769         address crvRewards;
770         address stash;
771         bool shutdown;
772     }
773 
774     //index(pid) -> pool
775     PoolInfo[] public poolInfo;
776     mapping(address => bool) public gaugeMap;
777 
778     event Deposited(address indexed user, uint256 indexed poolid, uint256 amount);
779     event Withdrawn(address indexed user, uint256 indexed poolid, uint256 amount);
780 
781     constructor(address _staker, address _minter) public {
782         isShutdown = false;
783         staker = _staker;
784         owner = msg.sender;
785         voteDelegate = msg.sender;
786         feeManager = msg.sender;
787         poolManager = msg.sender;
788         feeDistro = address(0); //address(0xA464e6DCda8AC41e03616F95f4BC98a13b8922Dc);
789         feeToken = address(0); //address(0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490);
790         treasury = address(0);
791         minter = _minter;
792     }
793 
794 
795     /// SETTER SECTION ///
796 
797     function setOwner(address _owner) external {
798         require(msg.sender == owner, "!auth");
799         owner = _owner;
800     }
801 
802     function setFeeManager(address _feeM) external {
803         require(msg.sender == feeManager, "!auth");
804         feeManager = _feeM;
805     }
806 
807     function setPoolManager(address _poolM) external {
808         require(msg.sender == poolManager, "!auth");
809         poolManager = _poolM;
810     }
811 
812     function setFactories(address _rfactory, address _sfactory, address _tfactory) external {
813         require(msg.sender == owner, "!auth");
814         
815         //reward factory only allow this to be called once even if owner
816         //removes ability to inject malicious staking contracts
817         //token factory can also be immutable
818         if(rewardFactory == address(0)){
819             rewardFactory = _rfactory;
820             tokenFactory = _tfactory;
821         }
822 
823         //stash factory should be considered more safe to change
824         //updating may be required to handle new types of gauges
825         stashFactory = _sfactory;
826     }
827 
828     function setArbitrator(address _arb) external {
829         require(msg.sender==owner, "!auth");
830         rewardArbitrator = _arb;
831     }
832 
833     function setVoteDelegate(address _voteDelegate) external {
834         require(msg.sender==voteDelegate, "!auth");
835         voteDelegate = _voteDelegate;
836     }
837 
838     function setRewardContracts(address _rewards, address _stakerRewards) external {
839         require(msg.sender == owner, "!auth");
840         
841         //reward contracts are immutable or else the owner
842         //has a means to redeploy and mint cvx via rewardClaimed()
843         if(lockRewards == address(0)){
844             lockRewards = _rewards;
845             stakerRewards = _stakerRewards;
846         }
847     }
848 
849     // Set reward token and claim contract, get from Curve's registry
850     function setFeeInfo() external {
851         require(msg.sender==feeManager, "!auth");
852         
853         feeDistro = IRegistry(registry).get_address(distributionAddressId);
854         address _feeToken = IFeeDistro(feeDistro).token();
855         if(feeToken != _feeToken){
856             //create a new reward contract for the new token
857             lockFees = IRewardFactory(rewardFactory).CreateTokenRewards(_feeToken,lockRewards,address(this));
858             feeToken = _feeToken;
859         }
860     }
861 
862     function setFees(uint256 _lockFees, uint256 _stakerFees, uint256 _callerFees, uint256 _platform) external{
863         require(msg.sender==feeManager, "!auth");
864 
865         uint256 total = _lockFees.add(_stakerFees).add(_callerFees).add(_platform);
866         require(total <= MaxFees, ">MaxFees");
867 
868         //values must be within certain ranges     
869         if(_lockFees >= 1000 && _lockFees <= 1500
870             && _stakerFees >= 300 && _stakerFees <= 600
871             && _callerFees >= 10 && _callerFees <= 100
872             && _platform <= 200){
873             lockIncentive = _lockFees;
874             stakerIncentive = _stakerFees;
875             earmarkIncentive = _callerFees;
876             platformFee = _platform;
877         }
878     }
879 
880     function setTreasury(address _treasury) external {
881         require(msg.sender==feeManager, "!auth");
882         treasury = _treasury;
883     }
884 
885     /// END SETTER SECTION ///
886 
887 
888     function poolLength() external view returns (uint256) {
889         return poolInfo.length;
890     }
891 
892     //create a new pool
893     function addPool(address _lptoken, address _gauge, uint256 _stashVersion) external returns(bool){
894         require(msg.sender==poolManager && !isShutdown, "!add");
895         require(_gauge != address(0) && _lptoken != address(0),"!param");
896 
897         //the next pool's pid
898         uint256 pid = poolInfo.length;
899 
900         //create a tokenized deposit
901         address token = ITokenFactory(tokenFactory).CreateDepositToken(_lptoken);
902         //create a reward contract for crv rewards
903         address newRewardPool = IRewardFactory(rewardFactory).CreateCrvRewards(pid,token);
904         //create a stash to handle extra incentives
905         address stash = IStashFactory(stashFactory).CreateStash(pid,_gauge,staker,_stashVersion);
906 
907         //add the new pool
908         poolInfo.push(
909             PoolInfo({
910                 lptoken: _lptoken,
911                 token: token,
912                 gauge: _gauge,
913                 crvRewards: newRewardPool,
914                 stash: stash,
915                 shutdown: false
916             })
917         );
918         gaugeMap[_gauge] = true;
919         //give stashes access to rewardfactory and voteproxy
920         //   voteproxy so it can grab the incentive tokens off the contract after claiming rewards
921         //   reward factory so that stashes can make new extra reward contracts if a new incentive is added to the gauge
922         if(stash != address(0)){
923             poolInfo[pid].stash = stash;
924             IStaker(staker).setStashAccess(stash,true);
925             IRewardFactory(rewardFactory).setAccess(stash,true);
926         }
927         return true;
928     }
929 
930     //shutdown pool
931     function shutdownPool(uint256 _pid) external returns(bool){
932         require(msg.sender==poolManager, "!auth");
933         PoolInfo storage pool = poolInfo[_pid];
934 
935         //withdraw from gauge
936         try IStaker(staker).withdrawAll(pool.lptoken,pool.gauge){
937         }catch{}
938 
939         pool.shutdown = true;
940         gaugeMap[pool.gauge] = false;
941         return true;
942     }
943 
944     //shutdown this contract.
945     //  unstake and pull all lp tokens to this address
946     //  only allow withdrawals
947     function shutdownSystem() external{
948         require(msg.sender == owner, "!auth");
949         isShutdown = true;
950 
951         for(uint i=0; i < poolInfo.length; i++){
952             PoolInfo storage pool = poolInfo[i];
953             if (pool.shutdown) continue;
954 
955             address token = pool.lptoken;
956             address gauge = pool.gauge;
957 
958             //withdraw from gauge
959             try IStaker(staker).withdrawAll(token,gauge){
960                 pool.shutdown = true;
961             }catch{}
962         }
963     }
964 
965 
966     //deposit lp tokens and stake
967     function deposit(uint256 _pid, uint256 _amount, bool _stake) public returns(bool){
968         require(!isShutdown,"shutdown");
969         PoolInfo storage pool = poolInfo[_pid];
970         require(pool.shutdown == false, "pool is closed");
971 
972         //send to proxy to stake
973         address lptoken = pool.lptoken;
974         IERC20(lptoken).safeTransferFrom(msg.sender, staker, _amount);
975 
976         //stake
977         address gauge = pool.gauge;
978         require(gauge != address(0),"!gauge setting");
979         IStaker(staker).deposit(lptoken,gauge);
980 
981         //some gauges claim rewards when depositing, stash them in a seperate contract until next claim
982         address stash = pool.stash;
983         if(stash != address(0)){
984             IStash(stash).stashRewards();
985         }
986 
987         address token = pool.token;
988         if(_stake){
989             //mint here and send to rewards on user behalf
990             ITokenMinter(token).mint(address(this),_amount);
991             address rewardContract = pool.crvRewards;
992             IERC20(token).safeApprove(rewardContract,0);
993             IERC20(token).safeApprove(rewardContract,_amount);
994             IRewards(rewardContract).stakeFor(msg.sender,_amount);
995         }else{
996             //add user balance directly
997             ITokenMinter(token).mint(msg.sender,_amount);
998         }
999 
1000         
1001         emit Deposited(msg.sender, _pid, _amount);
1002         return true;
1003     }
1004 
1005     //deposit all lp tokens and stake
1006     function depositAll(uint256 _pid, bool _stake) external returns(bool){
1007         address lptoken = poolInfo[_pid].lptoken;
1008         uint256 balance = IERC20(lptoken).balanceOf(msg.sender);
1009         deposit(_pid,balance,_stake);
1010         return true;
1011     }
1012 
1013     //withdraw lp tokens
1014     function _withdraw(uint256 _pid, uint256 _amount, address _from, address _to) internal {
1015         PoolInfo storage pool = poolInfo[_pid];
1016         address lptoken = pool.lptoken;
1017         address gauge = pool.gauge;
1018 
1019         //remove lp balance
1020         address token = pool.token;
1021         ITokenMinter(token).burn(_from,_amount);
1022 
1023         //pull from gauge if not shutdown
1024         // if shutdown tokens will be in this contract
1025         if (!pool.shutdown) {
1026             IStaker(staker).withdraw(lptoken,gauge, _amount);
1027         }
1028 
1029         //some gauges claim rewards when withdrawing, stash them in a seperate contract until next claim
1030         //do not call if shutdown since stashes wont have access
1031         address stash = pool.stash;
1032         if(stash != address(0) && !isShutdown && !pool.shutdown){
1033             IStash(stash).stashRewards();
1034         }
1035         
1036         //return lp tokens
1037         IERC20(lptoken).safeTransfer(_to, _amount);
1038 
1039         emit Withdrawn(_to, _pid, _amount);
1040     }
1041 
1042     //withdraw lp tokens
1043     function withdraw(uint256 _pid, uint256 _amount) public returns(bool){
1044         _withdraw(_pid,_amount,msg.sender,msg.sender);
1045         return true;
1046     }
1047 
1048     //withdraw all lp tokens
1049     function withdrawAll(uint256 _pid) public returns(bool){
1050         address token = poolInfo[_pid].token;
1051         uint256 userBal = IERC20(token).balanceOf(msg.sender);
1052         withdraw(_pid, userBal);
1053         return true;
1054     }
1055 
1056     //allow reward contracts to send here and withdraw to user
1057     function withdrawTo(uint256 _pid, uint256 _amount, address _to) external returns(bool){
1058         address rewardContract = poolInfo[_pid].crvRewards;
1059         require(msg.sender == rewardContract,"!auth");
1060 
1061         _withdraw(_pid,_amount,msg.sender,_to);
1062         return true;
1063     }
1064 
1065 
1066     //delegate address votes on dao
1067     function vote(uint256 _voteId, address _votingAddress, bool _support) external returns(bool){
1068         require(msg.sender == voteDelegate, "!auth");
1069         require(_votingAddress == voteOwnership || _votingAddress == voteParameter, "!voteAddr");
1070         
1071         IStaker(staker).vote(_voteId,_votingAddress,_support);
1072         return true;
1073     }
1074 
1075     function voteGaugeWeight(address[] calldata _gauge, uint256[] calldata _weight ) external returns(bool){
1076         require(msg.sender == voteDelegate, "!auth");
1077 
1078         for(uint256 i = 0; i < _gauge.length; i++){
1079             IStaker(staker).voteGaugeWeight(_gauge[i],_weight[i]);
1080         }
1081         return true;
1082     }
1083 
1084     function claimRewards(uint256 _pid, address _gauge) external returns(bool){
1085         address stash = poolInfo[_pid].stash;
1086         require(msg.sender == stash,"!auth");
1087 
1088         IStaker(staker).claimRewards(_gauge);
1089         return true;
1090     }
1091 
1092     function setGaugeRedirect(uint256 _pid) external returns(bool){
1093         address stash = poolInfo[_pid].stash;
1094         require(msg.sender == stash,"!auth");
1095         address gauge = poolInfo[_pid].gauge;
1096         bytes memory data = abi.encodeWithSelector(bytes4(keccak256("set_rewards_receiver(address)")), stash);
1097         IStaker(staker).execute(gauge,uint256(0),data);
1098         return true;
1099     }
1100 
1101     //claim crv and extra rewards and disperse to reward contracts
1102     function _earmarkRewards(uint256 _pid) internal {
1103         PoolInfo storage pool = poolInfo[_pid];
1104         require(pool.shutdown == false, "pool is closed");
1105 
1106         address gauge = pool.gauge;
1107 
1108         //claim crv
1109         IStaker(staker).claimCrv(gauge);
1110 
1111         //check if there are extra rewards
1112         address stash = pool.stash;
1113         if(stash != address(0)){
1114             //claim extra rewards
1115             IStash(stash).claimRewards();
1116             //process extra rewards
1117             IStash(stash).processStash();
1118         }
1119 
1120         //crv balance
1121         uint256 crvBal = IERC20(crv).balanceOf(address(this));
1122 
1123         if (crvBal > 0) {
1124             uint256 _lockIncentive = crvBal.mul(lockIncentive).div(FEE_DENOMINATOR);
1125             uint256 _stakerIncentive = crvBal.mul(stakerIncentive).div(FEE_DENOMINATOR);
1126             uint256 _callIncentive = crvBal.mul(earmarkIncentive).div(FEE_DENOMINATOR);
1127             
1128             //send treasury
1129             if(treasury != address(0) && treasury != address(this) && platformFee > 0){
1130                 //only subtract after address condition check
1131                 uint256 _platform = crvBal.mul(platformFee).div(FEE_DENOMINATOR);
1132                 crvBal = crvBal.sub(_platform);
1133                 IERC20(crv).safeTransfer(treasury, _platform);
1134             }
1135 
1136             //remove incentives from balance
1137             crvBal = crvBal.sub(_lockIncentive).sub(_callIncentive).sub(_stakerIncentive);
1138 
1139             //send incentives for calling
1140             IERC20(crv).safeTransfer(msg.sender, _callIncentive);          
1141 
1142             //send crv to lp provider reward contract
1143             address rewardContract = pool.crvRewards;
1144             IERC20(crv).safeTransfer(rewardContract, crvBal);
1145             IRewards(rewardContract).queueNewRewards(crvBal);
1146 
1147             //send lockers' share of crv to reward contract
1148             IERC20(crv).safeTransfer(lockRewards, _lockIncentive);
1149             IRewards(lockRewards).queueNewRewards(_lockIncentive);
1150 
1151             //send stakers's share of crv to reward contract
1152             IERC20(crv).safeTransfer(stakerRewards, _stakerIncentive);
1153             IRewards(stakerRewards).queueNewRewards(_stakerIncentive);
1154         }
1155     }
1156 
1157     function earmarkRewards(uint256 _pid) external returns(bool){
1158         require(!isShutdown,"shutdown");
1159         _earmarkRewards(_pid);
1160         return true;
1161     }
1162 
1163     //claim fees from curve distro contract, put in lockers' reward contract
1164     function earmarkFees() external returns(bool){
1165         //claim fee rewards
1166         IStaker(staker).claimFees(feeDistro, feeToken);
1167         //send fee rewards to reward contract
1168         uint256 _balance = IERC20(feeToken).balanceOf(address(this));
1169         IERC20(feeToken).safeTransfer(lockFees, _balance);
1170         IRewards(lockFees).queueNewRewards(_balance);
1171         return true;
1172     }
1173 
1174     //callback from reward contract when crv is received.
1175     function rewardClaimed(uint256 _pid, address _address, uint256 _amount) external returns(bool){
1176         address rewardContract = poolInfo[_pid].crvRewards;
1177         require(msg.sender == rewardContract || msg.sender == lockRewards, "!auth");
1178 
1179         //mint reward tokens
1180         ITokenMinter(minter).mint(_address,_amount);
1181         
1182         return true;
1183     }
1184 
1185 }