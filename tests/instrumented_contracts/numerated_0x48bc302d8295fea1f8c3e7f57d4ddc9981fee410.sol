1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library MathUtil {
9     /**
10      * @dev Returns the smallest of two numbers.
11      */
12     function min(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a < b ? a : b;
14     }
15 }
16 
17 contract ReentrancyGuard {
18     uint256 private _guardCounter;
19 
20     constructor () internal {
21         _guardCounter = 1;
22     }
23 
24     modifier nonReentrant() {
25         _guardCounter += 1;
26         uint256 localCounter = _guardCounter;
27         _;
28         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
29     }
30 }
31 
32 interface ICurveGauge {
33     function deposit(uint256) external;
34     function balanceOf(address) external view returns (uint256);
35     function withdraw(uint256) external;
36     function claim_rewards() external;
37     function reward_tokens(uint256) external view returns(address);//v2
38     function rewarded_token() external view returns(address);//v1
39 }
40 
41 interface ICurveVoteEscrow {
42     function create_lock(uint256, uint256) external;
43     function increase_amount(uint256) external;
44     function increase_unlock_time(uint256) external;
45     function withdraw() external;
46     function smart_wallet_checker() external view returns (address);
47 }
48 
49 interface IWalletChecker {
50     function check(address) external view returns (bool);
51 }
52 
53 interface IVoting{
54     function vote(uint256, bool, bool) external; //voteId, support, executeIfDecided
55     function getVote(uint256) external view returns(bool,bool,uint64,uint64,uint64,uint64,uint256,uint256,uint256,bytes memory); 
56     function vote_for_gauge_weights(address,uint256) external;
57 }
58 
59 interface IMinter{
60     function mint(address) external;
61 }
62 
63 interface IRegistry{
64     function get_registry() external view returns(address);
65     function get_address(uint256 _id) external view returns(address);
66     function gauge_controller() external view returns(address);
67     function get_lp_token(address) external view returns(address);
68     function get_gauges(address) external view returns(address[10] memory,uint128[10] memory);
69 }
70 
71 interface IStaker{
72     function deposit(address, address) external;
73     function withdraw(address) external;
74     function withdraw(address, address, uint256) external;
75     function withdrawAll(address, address) external;
76     function createLock(uint256, uint256) external;
77     function increaseAmount(uint256) external;
78     function increaseTime(uint256) external;
79     function release() external;
80     function claimCrv(address) external returns (uint256);
81     function claimRewards(address) external;
82     function claimFees(address,address) external;
83     function setStashAccess(address, bool) external;
84     function vote(uint256,address,bool) external;
85     function voteGaugeWeight(address,uint256) external;
86     function balanceOfPool(address) external view returns (uint256);
87     function operator() external view returns (address);
88     function execute(address _to, uint256 _value, bytes calldata _data) external returns (bool, bytes memory);
89 }
90 
91 interface IRewards{
92     function stake(address, uint256) external;
93     function stakeFor(address, uint256) external;
94     function withdraw(address, uint256) external;
95     function exit(address) external;
96     function getReward(address) external;
97     function queueNewRewards(uint256) external;
98     function notifyRewardAmount(uint256) external;
99     function addExtraReward(address) external;
100     function stakingToken() external returns (address);
101 }
102 
103 interface IStash{
104     function stashRewards() external returns (bool);
105     function processStash() external returns (bool);
106     function claimRewards() external returns (bool);
107 }
108 
109 interface IFeeDistro{
110     function claim() external;
111     function token() external view returns(address);
112 }
113 
114 interface ITokenMinter{
115     function mint(address,uint256) external;
116     function burn(address,uint256) external;
117 }
118 
119 interface IDeposit{
120     function isShutdown() external view returns(bool);
121     function balanceOf(address _account) external view returns(uint256);
122     function totalSupply() external view returns(uint256);
123     function poolInfo(uint256) external view returns(address,address,address,address,address, bool);
124     function rewardClaimed(uint256,address,uint256) external;
125     function withdrawTo(uint256,uint256,address) external;
126     function claimRewards(uint256,address) external returns(bool);
127     function rewardArbitrator() external returns(address);
128 }
129 
130 interface ICrvDeposit{
131     function deposit(uint256, bool) external;
132     function lockIncentive() external view returns(uint256);
133 }
134 
135 interface IRewardFactory{
136     function setAccess(address,bool) external;
137     function CreateCrvRewards(uint256,address) external returns(address);
138     function CreateTokenRewards(address,address,address) external returns(address);
139     function activeRewardCount(address) external view returns(uint256);
140     function addActiveReward(address,uint256) external returns(bool);
141     function removeActiveReward(address,uint256) external returns(bool);
142 }
143 
144 interface IStashFactory{
145     function CreateStash(uint256,address,address,uint256) external returns(address);
146 }
147 
148 interface ITokenFactory{
149     function CreateDepositToken(address) external returns(address);
150 }
151 
152 interface IPools{
153     function addPool(address _lptoken, address _gauge, uint256 _stashVersion) external returns(bool);
154     function shutdownPool(uint256 _pid) external returns(bool);
155     function poolInfo(uint256) external view returns(address,address,address,address,address,bool);
156     function poolLength() external view returns (uint256);
157     function gaugeMap(address) external view returns(bool);
158     function setPoolManager(address _poolM) external;
159 }
160 
161 interface IVestedEscrow{
162     function fund(address[] calldata _recipient, uint256[] calldata _amount) external returns(bool);
163 }
164 
165 // File: @openzeppelin\contracts\math\SafeMath.sol
166 
167 pragma solidity >=0.6.0 <0.8.0;
168 
169 /**
170  * @dev Wrappers over Solidity's arithmetic operations with added overflow
171  * checks.
172  *
173  * Arithmetic operations in Solidity wrap on overflow. This can easily result
174  * in bugs, because programmers usually assume that an overflow raises an
175  * error, which is the standard behavior in high level programming languages.
176  * `SafeMath` restores this intuition by reverting the transaction when an
177  * operation overflows.
178  *
179  * Using this library instead of the unchecked operations eliminates an entire
180  * class of bugs, so it's recommended to use it always.
181  */
182 library SafeMath {
183     /**
184      * @dev Returns the addition of two unsigned integers, with an overflow flag.
185      *
186      * _Available since v3.4._
187      */
188     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
189         uint256 c = a + b;
190         if (c < a) return (false, 0);
191         return (true, c);
192     }
193 
194     /**
195      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
196      *
197      * _Available since v3.4._
198      */
199     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
200         if (b > a) return (false, 0);
201         return (true, a - b);
202     }
203 
204     /**
205      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
206      *
207      * _Available since v3.4._
208      */
209     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
210         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
211         // benefit is lost if 'b' is also tested.
212         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
213         if (a == 0) return (true, 0);
214         uint256 c = a * b;
215         if (c / a != b) return (false, 0);
216         return (true, c);
217     }
218 
219     /**
220      * @dev Returns the division of two unsigned integers, with a division by zero flag.
221      *
222      * _Available since v3.4._
223      */
224     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         if (b == 0) return (false, 0);
226         return (true, a / b);
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
231      *
232      * _Available since v3.4._
233      */
234     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
235         if (b == 0) return (false, 0);
236         return (true, a % b);
237     }
238 
239     /**
240      * @dev Returns the addition of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `+` operator.
244      *
245      * Requirements:
246      *
247      * - Addition cannot overflow.
248      */
249     function add(uint256 a, uint256 b) internal pure returns (uint256) {
250         uint256 c = a + b;
251         require(c >= a, "SafeMath: addition overflow");
252         return c;
253     }
254 
255     /**
256      * @dev Returns the subtraction of two unsigned integers, reverting on
257      * overflow (when the result is negative).
258      *
259      * Counterpart to Solidity's `-` operator.
260      *
261      * Requirements:
262      *
263      * - Subtraction cannot overflow.
264      */
265     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b <= a, "SafeMath: subtraction overflow");
267         return a - b;
268     }
269 
270     /**
271      * @dev Returns the multiplication of two unsigned integers, reverting on
272      * overflow.
273      *
274      * Counterpart to Solidity's `*` operator.
275      *
276      * Requirements:
277      *
278      * - Multiplication cannot overflow.
279      */
280     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
281         if (a == 0) return 0;
282         uint256 c = a * b;
283         require(c / a == b, "SafeMath: multiplication overflow");
284         return c;
285     }
286 
287     /**
288      * @dev Returns the integer division of two unsigned integers, reverting on
289      * division by zero. The result is rounded towards zero.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b) internal pure returns (uint256) {
300         require(b > 0, "SafeMath: division by zero");
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting when dividing by zero.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         require(b > 0, "SafeMath: modulo by zero");
318         return a % b;
319     }
320 
321     /**
322      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
323      * overflow (when the result is negative).
324      *
325      * CAUTION: This function is deprecated because it requires allocating memory for the error
326      * message unnecessarily. For custom revert reasons use {trySub}.
327      *
328      * Counterpart to Solidity's `-` operator.
329      *
330      * Requirements:
331      *
332      * - Subtraction cannot overflow.
333      */
334     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b <= a, errorMessage);
336         return a - b;
337     }
338 
339     /**
340      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
341      * division by zero. The result is rounded towards zero.
342      *
343      * CAUTION: This function is deprecated because it requires allocating memory for the error
344      * message unnecessarily. For custom revert reasons use {tryDiv}.
345      *
346      * Counterpart to Solidity's `/` operator. Note: this function uses a
347      * `revert` opcode (which leaves remaining gas untouched) while Solidity
348      * uses an invalid opcode to revert (consuming all remaining gas).
349      *
350      * Requirements:
351      *
352      * - The divisor cannot be zero.
353      */
354     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
355         require(b > 0, errorMessage);
356         return a / b;
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
361      * reverting with custom message when dividing by zero.
362      *
363      * CAUTION: This function is deprecated because it requires allocating memory for the error
364      * message unnecessarily. For custom revert reasons use {tryMod}.
365      *
366      * Counterpart to Solidity's `%` operator. This function uses a `revert`
367      * opcode (which leaves remaining gas untouched) while Solidity uses an
368      * invalid opcode to revert (consuming all remaining gas).
369      *
370      * Requirements:
371      *
372      * - The divisor cannot be zero.
373      */
374     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
375         require(b > 0, errorMessage);
376         return a % b;
377     }
378 }
379 
380 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
381 
382 pragma solidity >=0.6.0 <0.8.0;
383 
384 /**
385  * @dev Interface of the ERC20 standard as defined in the EIP.
386  */
387 interface IERC20 {
388     /**
389      * @dev Returns the amount of tokens in existence.
390      */
391     function totalSupply() external view returns (uint256);
392 
393     /**
394      * @dev Returns the amount of tokens owned by `account`.
395      */
396     function balanceOf(address account) external view returns (uint256);
397 
398     /**
399      * @dev Moves `amount` tokens from the caller's account to `recipient`.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transfer(address recipient, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Returns the remaining number of tokens that `spender` will be
409      * allowed to spend on behalf of `owner` through {transferFrom}. This is
410      * zero by default.
411      *
412      * This value changes when {approve} or {transferFrom} are called.
413      */
414     function allowance(address owner, address spender) external view returns (uint256);
415 
416     /**
417      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
418      *
419      * Returns a boolean value indicating whether the operation succeeded.
420      *
421      * IMPORTANT: Beware that changing an allowance with this method brings the risk
422      * that someone may use both the old and the new allowance by unfortunate
423      * transaction ordering. One possible solution to mitigate this race
424      * condition is to first reduce the spender's allowance to 0 and set the
425      * desired value afterwards:
426      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
427      *
428      * Emits an {Approval} event.
429      */
430     function approve(address spender, uint256 amount) external returns (bool);
431 
432     /**
433      * @dev Moves `amount` tokens from `sender` to `recipient` using the
434      * allowance mechanism. `amount` is then deducted from the caller's
435      * allowance.
436      *
437      * Returns a boolean value indicating whether the operation succeeded.
438      *
439      * Emits a {Transfer} event.
440      */
441     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
442 
443     /**
444      * @dev Emitted when `value` tokens are moved from one account (`from`) to
445      * another (`to`).
446      *
447      * Note that `value` may be zero.
448      */
449     event Transfer(address indexed from, address indexed to, uint256 value);
450 
451     /**
452      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
453      * a call to {approve}. `value` is the new allowance.
454      */
455     event Approval(address indexed owner, address indexed spender, uint256 value);
456 }
457 
458 // File: @openzeppelin\contracts\utils\Address.sol
459 
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
650 pragma solidity >=0.6.0 <0.8.0;
651 
652 
653 /**
654  * @title SafeERC20
655  * @dev Wrappers around ERC20 operations that throw on failure (when the token
656  * contract returns false). Tokens that return no value (and instead revert or
657  * throw on failure) are also supported, non-reverting calls are assumed to be
658  * successful.
659  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
660  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
661  */
662 library SafeERC20 {
663     using SafeMath for uint256;
664     using Address for address;
665 
666     function safeTransfer(IERC20 token, address to, uint256 value) internal {
667         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
668     }
669 
670     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
671         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
672     }
673 
674     /**
675      * @dev Deprecated. This function has issues similar to the ones found in
676      * {IERC20-approve}, and its usage is discouraged.
677      *
678      * Whenever possible, use {safeIncreaseAllowance} and
679      * {safeDecreaseAllowance} instead.
680      */
681     function safeApprove(IERC20 token, address spender, uint256 value) internal {
682         // safeApprove should only be called when setting an initial allowance,
683         // or when resetting it to zero. To increase and decrease it, use
684         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
685         // solhint-disable-next-line max-line-length
686         require((value == 0) || (token.allowance(address(this), spender) == 0),
687             "SafeERC20: approve from non-zero to non-zero allowance"
688         );
689         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
690     }
691 
692     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
693         uint256 newAllowance = token.allowance(address(this), spender).add(value);
694         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
695     }
696 
697     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
698         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
699         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
700     }
701 
702     /**
703      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
704      * on the return value: the return value is optional (but if data is returned, it must not be false).
705      * @param token The token targeted by the call.
706      * @param data The call data (encoded using abi.encode or one of its variants).
707      */
708     function _callOptionalReturn(IERC20 token, bytes memory data) private {
709         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
710         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
711         // the target address contains contract code and also asserts for success in the low-level call.
712 
713         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
714         if (returndata.length > 0) { // Return data is optional
715             // solhint-disable-next-line max-line-length
716             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
717         }
718     }
719 }
720 
721 // File: contracts\BaseRewardPool.sol
722 
723 pragma solidity 0.6.12;
724 /**
725  *Submitted for verification at Etherscan.io on 2020-07-17
726  */
727 
728 /*
729    ____            __   __        __   _
730   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
731  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
732 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
733      /___/
734 
735 * Synthetix: BaseRewardPool.sol
736 *
737 * Docs: https://docs.synthetix.io/
738 *
739 *
740 * MIT License
741 * ===========
742 *
743 * Copyright (c) 2020 Synthetix
744 *
745 * Permission is hereby granted, free of charge, to any person obtaining a copy
746 * of this software and associated documentation files (the "Software"), to deal
747 * in the Software without restriction, including without limitation the rights
748 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
749 * copies of the Software, and to permit persons to whom the Software is
750 * furnished to do so, subject to the following conditions:
751 *
752 * The above copyright notice and this permission notice shall be included in all
753 * copies or substantial portions of the Software.
754 *
755 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
756 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
757 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
758 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
759 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
760 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
761 */
762 
763 
764 contract BaseRewardPool {
765      using SafeMath for uint256;
766     using SafeERC20 for IERC20;
767 
768     IERC20 public rewardToken;
769     IERC20 public stakingToken;
770     uint256 public constant duration = 7 days;
771 
772     address public operator;
773     address public rewardManager;
774 
775     uint256 public pid;
776     uint256 public periodFinish = 0;
777     uint256 public rewardRate = 0;
778     uint256 public lastUpdateTime;
779     uint256 public rewardPerTokenStored;
780     uint256 public queuedRewards = 0;
781     uint256 public currentRewards = 0;
782     uint256 public historicalRewards = 0;
783     uint256 public constant newRewardRatio = 830;
784     uint256 private _totalSupply;
785     mapping(address => uint256) public userRewardPerTokenPaid;
786     mapping(address => uint256) public rewards;
787     mapping(address => uint256) private _balances;
788 
789     address[] public extraRewards;
790 
791     event RewardAdded(uint256 reward);
792     event Staked(address indexed user, uint256 amount);
793     event Withdrawn(address indexed user, uint256 amount);
794     event RewardPaid(address indexed user, uint256 reward);
795 
796     constructor(
797         uint256 pid_,
798         address stakingToken_,
799         address rewardToken_,
800         address operator_,
801         address rewardManager_
802     ) public {
803         pid = pid_;
804         stakingToken = IERC20(stakingToken_);
805         rewardToken = IERC20(rewardToken_);
806         operator = operator_;
807         rewardManager = rewardManager_;
808     }
809 
810     function totalSupply() public view returns (uint256) {
811         return _totalSupply;
812     }
813 
814     function balanceOf(address account) public view returns (uint256) {
815         return _balances[account];
816     }
817 
818     function extraRewardsLength() external view returns (uint256) {
819         return extraRewards.length;
820     }
821 
822     function addExtraReward(address _reward) external returns(bool){
823         require(msg.sender == rewardManager, "!authorized");
824         require(_reward != address(0),"!reward setting");
825 
826         extraRewards.push(_reward);
827         return true;
828     }
829     function clearExtraRewards() external{
830         require(msg.sender == rewardManager, "!authorized");
831         delete extraRewards;
832     }
833 
834     modifier updateReward(address account) {
835         rewardPerTokenStored = rewardPerToken();
836         lastUpdateTime = lastTimeRewardApplicable();
837         if (account != address(0)) {
838             rewards[account] = earned(account);
839             userRewardPerTokenPaid[account] = rewardPerTokenStored;
840         }
841         _;
842     }
843 
844     function lastTimeRewardApplicable() public view returns (uint256) {
845         return MathUtil.min(block.timestamp, periodFinish);
846     }
847 
848     function rewardPerToken() public view returns (uint256) {
849         if (totalSupply() == 0) {
850             return rewardPerTokenStored;
851         }
852         return
853             rewardPerTokenStored.add(
854                 lastTimeRewardApplicable()
855                     .sub(lastUpdateTime)
856                     .mul(rewardRate)
857                     .mul(1e18)
858                     .div(totalSupply())
859             );
860     }
861 
862     function earned(address account) public view returns (uint256) {
863         return
864             balanceOf(account)
865                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
866                 .div(1e18)
867                 .add(rewards[account]);
868     }
869 
870     function stake(uint256 _amount)
871         public
872         updateReward(msg.sender)
873         returns(bool)
874     {
875         require(_amount > 0, 'RewardPool : Cannot stake 0');
876         
877         //also stake to linked rewards
878         for(uint i=0; i < extraRewards.length; i++){
879             IRewards(extraRewards[i]).stake(msg.sender, _amount);
880         }
881 
882         _totalSupply = _totalSupply.add(_amount);
883         _balances[msg.sender] = _balances[msg.sender].add(_amount);
884 
885         stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
886         emit Staked(msg.sender, _amount);
887 
888         
889         return true;
890     }
891 
892     function stakeAll() external returns(bool){
893         uint256 balance = stakingToken.balanceOf(msg.sender);
894         stake(balance);
895         return true;
896     }
897 
898     function stakeFor(address _for, uint256 _amount)
899         public
900         updateReward(_for)
901         returns(bool)
902     {
903         require(_amount > 0, 'RewardPool : Cannot stake 0');
904         
905         //also stake to linked rewards
906         for(uint i=0; i < extraRewards.length; i++){
907             IRewards(extraRewards[i]).stake(_for, _amount);
908         }
909 
910         //give to _for
911         _totalSupply = _totalSupply.add(_amount);
912         _balances[_for] = _balances[_for].add(_amount);
913 
914         //take away from sender
915         stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
916         emit Staked(_for, _amount);
917         
918         return true;
919     }
920 
921 
922     function withdraw(uint256 amount, bool claim)
923         public
924         updateReward(msg.sender)
925         returns(bool)
926     {
927         require(amount > 0, 'RewardPool : Cannot withdraw 0');
928 
929         //also withdraw from linked rewards
930         for(uint i=0; i < extraRewards.length; i++){
931             IRewards(extraRewards[i]).withdraw(msg.sender, amount);
932         }
933 
934         _totalSupply = _totalSupply.sub(amount);
935         _balances[msg.sender] = _balances[msg.sender].sub(amount);
936 
937         stakingToken.safeTransfer(msg.sender, amount);
938         emit Withdrawn(msg.sender, amount);
939      
940         if(claim){
941             getReward(msg.sender,true);
942         }
943 
944         return true;
945     }
946 
947     function withdrawAll(bool claim) external{
948         withdraw(_balances[msg.sender],claim);
949     }
950 
951     function withdrawAndUnwrap(uint256 amount, bool claim) public updateReward(msg.sender) returns(bool){
952 
953         //also withdraw from linked rewards
954         for(uint i=0; i < extraRewards.length; i++){
955             IRewards(extraRewards[i]).withdraw(msg.sender, amount);
956         }
957         
958         _totalSupply = _totalSupply.sub(amount);
959         _balances[msg.sender] = _balances[msg.sender].sub(amount);
960 
961         //tell operator to withdraw from here directly to user
962         IDeposit(operator).withdrawTo(pid,amount,msg.sender);
963         emit Withdrawn(msg.sender, amount);
964 
965         //get rewards too
966         if(claim){
967             getReward(msg.sender,true);
968         }
969         return true;
970     }
971 
972     function withdrawAllAndUnwrap(bool claim) external{
973         withdrawAndUnwrap(_balances[msg.sender],claim);
974     }
975 
976     function getReward(address _account, bool _claimExtras) public updateReward(_account) returns(bool){
977         uint256 reward = earned(_account);
978         if (reward > 0) {
979             rewards[_account] = 0;
980             rewardToken.safeTransfer(_account, reward);
981             IDeposit(operator).rewardClaimed(pid, _account, reward);
982             emit RewardPaid(_account, reward);
983         }
984 
985         //also get rewards from linked rewards
986         if(_claimExtras){
987             for(uint i=0; i < extraRewards.length; i++){
988                 IRewards(extraRewards[i]).getReward(_account);
989             }
990         }
991         return true;
992     }
993 
994     function getReward() external returns(bool){
995         getReward(msg.sender,true);
996         return true;
997     }
998 
999     function donate(uint256 _amount) external returns(bool){
1000         IERC20(rewardToken).safeTransferFrom(msg.sender, address(this), _amount);
1001         queuedRewards = queuedRewards.add(_amount);
1002     }
1003 
1004     function queueNewRewards(uint256 _rewards) external returns(bool){
1005         require(msg.sender == operator, "!authorized");
1006 
1007         _rewards = _rewards.add(queuedRewards);
1008 
1009         if (block.timestamp >= periodFinish) {
1010             notifyRewardAmount(_rewards);
1011             queuedRewards = 0;
1012             return true;
1013         }
1014 
1015         //et = now - (finish-duration)
1016         uint256 elapsedTime = block.timestamp.sub(periodFinish.sub(duration));
1017         //current at now: rewardRate * elapsedTime
1018         uint256 currentAtNow = rewardRate * elapsedTime;
1019         uint256 queuedRatio = currentAtNow.mul(1000).div(_rewards);
1020 
1021         //uint256 queuedRatio = currentRewards.mul(1000).div(_rewards);
1022         if(queuedRatio < newRewardRatio){
1023             notifyRewardAmount(_rewards);
1024             queuedRewards = 0;
1025         }else{
1026             queuedRewards = _rewards;
1027         }
1028         return true;
1029     }
1030 
1031     function notifyRewardAmount(uint256 reward)
1032         internal
1033         updateReward(address(0))
1034     {
1035         historicalRewards = historicalRewards.add(reward);
1036         if (block.timestamp >= periodFinish) {
1037             rewardRate = reward.div(duration);
1038         } else {
1039             uint256 remaining = periodFinish.sub(block.timestamp);
1040             uint256 leftover = remaining.mul(rewardRate);
1041             reward = reward.add(leftover);
1042             rewardRate = reward.div(duration);
1043         }
1044         currentRewards = reward;
1045         lastUpdateTime = block.timestamp;
1046         periodFinish = block.timestamp.add(duration);
1047         emit RewardAdded(reward);
1048     }
1049 }