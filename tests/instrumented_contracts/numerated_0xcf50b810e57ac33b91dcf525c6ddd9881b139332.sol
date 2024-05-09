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
381 pragma solidity >=0.6.0 <0.8.0;
382 
383 /**
384  * @dev Interface of the ERC20 standard as defined in the EIP.
385  */
386 interface IERC20 {
387     /**
388      * @dev Returns the amount of tokens in existence.
389      */
390     function totalSupply() external view returns (uint256);
391 
392     /**
393      * @dev Returns the amount of tokens owned by `account`.
394      */
395     function balanceOf(address account) external view returns (uint256);
396 
397     /**
398      * @dev Moves `amount` tokens from the caller's account to `recipient`.
399      *
400      * Returns a boolean value indicating whether the operation succeeded.
401      *
402      * Emits a {Transfer} event.
403      */
404     function transfer(address recipient, uint256 amount) external returns (bool);
405 
406     /**
407      * @dev Returns the remaining number of tokens that `spender` will be
408      * allowed to spend on behalf of `owner` through {transferFrom}. This is
409      * zero by default.
410      *
411      * This value changes when {approve} or {transferFrom} are called.
412      */
413     function allowance(address owner, address spender) external view returns (uint256);
414 
415     /**
416      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
417      *
418      * Returns a boolean value indicating whether the operation succeeded.
419      *
420      * IMPORTANT: Beware that changing an allowance with this method brings the risk
421      * that someone may use both the old and the new allowance by unfortunate
422      * transaction ordering. One possible solution to mitigate this race
423      * condition is to first reduce the spender's allowance to 0 and set the
424      * desired value afterwards:
425      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
426      *
427      * Emits an {Approval} event.
428      */
429     function approve(address spender, uint256 amount) external returns (bool);
430 
431     /**
432      * @dev Moves `amount` tokens from `sender` to `recipient` using the
433      * allowance mechanism. `amount` is then deducted from the caller's
434      * allowance.
435      *
436      * Returns a boolean value indicating whether the operation succeeded.
437      *
438      * Emits a {Transfer} event.
439      */
440     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
441 
442     /**
443      * @dev Emitted when `value` tokens are moved from one account (`from`) to
444      * another (`to`).
445      *
446      * Note that `value` may be zero.
447      */
448     event Transfer(address indexed from, address indexed to, uint256 value);
449 
450     /**
451      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
452      * a call to {approve}. `value` is the new allowance.
453      */
454     event Approval(address indexed owner, address indexed spender, uint256 value);
455 }
456 
457 // File: @openzeppelin\contracts\utils\Address.sol
458 
459 pragma solidity >=0.6.2 <0.8.0;
460 
461 /**
462  * @dev Collection of functions related to the address type
463  */
464 library Address {
465     /**
466      * @dev Returns true if `account` is a contract.
467      *
468      * [IMPORTANT]
469      * ====
470      * It is unsafe to assume that an address for which this function returns
471      * false is an externally-owned account (EOA) and not a contract.
472      *
473      * Among others, `isContract` will return false for the following
474      * types of addresses:
475      *
476      *  - an externally-owned account
477      *  - a contract in construction
478      *  - an address where a contract will be created
479      *  - an address where a contract lived, but was destroyed
480      * ====
481      */
482     function isContract(address account) internal view returns (bool) {
483         // This method relies on extcodesize, which returns 0 for contracts in
484         // construction, since the code is only stored at the end of the
485         // constructor execution.
486 
487         uint256 size;
488         // solhint-disable-next-line no-inline-assembly
489         assembly { size := extcodesize(account) }
490         return size > 0;
491     }
492 
493     /**
494      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
495      * `recipient`, forwarding all available gas and reverting on errors.
496      *
497      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
498      * of certain opcodes, possibly making contracts go over the 2300 gas limit
499      * imposed by `transfer`, making them unable to receive funds via
500      * `transfer`. {sendValue} removes this limitation.
501      *
502      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
503      *
504      * IMPORTANT: because control is transferred to `recipient`, care must be
505      * taken to not create reentrancy vulnerabilities. Consider using
506      * {ReentrancyGuard} or the
507      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
508      */
509     function sendValue(address payable recipient, uint256 amount) internal {
510         require(address(this).balance >= amount, "Address: insufficient balance");
511 
512         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
513         (bool success, ) = recipient.call{ value: amount }("");
514         require(success, "Address: unable to send value, recipient may have reverted");
515     }
516 
517     /**
518      * @dev Performs a Solidity function call using a low level `call`. A
519      * plain`call` is an unsafe replacement for a function call: use this
520      * function instead.
521      *
522      * If `target` reverts with a revert reason, it is bubbled up by this
523      * function (like regular Solidity function calls).
524      *
525      * Returns the raw returned data. To convert to the expected return value,
526      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
527      *
528      * Requirements:
529      *
530      * - `target` must be a contract.
531      * - calling `target` with `data` must not revert.
532      *
533      * _Available since v3.1._
534      */
535     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
536       return functionCall(target, data, "Address: low-level call failed");
537     }
538 
539     /**
540      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
541      * `errorMessage` as a fallback revert reason when `target` reverts.
542      *
543      * _Available since v3.1._
544      */
545     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
546         return functionCallWithValue(target, data, 0, errorMessage);
547     }
548 
549     /**
550      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
551      * but also transferring `value` wei to `target`.
552      *
553      * Requirements:
554      *
555      * - the calling contract must have an ETH balance of at least `value`.
556      * - the called Solidity function must be `payable`.
557      *
558      * _Available since v3.1._
559      */
560     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
561         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
566      * with `errorMessage` as a fallback revert reason when `target` reverts.
567      *
568      * _Available since v3.1._
569      */
570     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
571         require(address(this).balance >= value, "Address: insufficient balance for call");
572         require(isContract(target), "Address: call to non-contract");
573 
574         // solhint-disable-next-line avoid-low-level-calls
575         (bool success, bytes memory returndata) = target.call{ value: value }(data);
576         return _verifyCallResult(success, returndata, errorMessage);
577     }
578 
579     /**
580      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
581      * but performing a static call.
582      *
583      * _Available since v3.3._
584      */
585     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
586         return functionStaticCall(target, data, "Address: low-level static call failed");
587     }
588 
589     /**
590      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
591      * but performing a static call.
592      *
593      * _Available since v3.3._
594      */
595     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
596         require(isContract(target), "Address: static call to non-contract");
597 
598         // solhint-disable-next-line avoid-low-level-calls
599         (bool success, bytes memory returndata) = target.staticcall(data);
600         return _verifyCallResult(success, returndata, errorMessage);
601     }
602 
603     /**
604      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
605      * but performing a delegate call.
606      *
607      * _Available since v3.4._
608      */
609     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
610         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
615      * but performing a delegate call.
616      *
617      * _Available since v3.4._
618      */
619     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
620         require(isContract(target), "Address: delegate call to non-contract");
621 
622         // solhint-disable-next-line avoid-low-level-calls
623         (bool success, bytes memory returndata) = target.delegatecall(data);
624         return _verifyCallResult(success, returndata, errorMessage);
625     }
626 
627     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
628         if (success) {
629             return returndata;
630         } else {
631             // Look for revert reason and bubble it up if present
632             if (returndata.length > 0) {
633                 // The easiest way to bubble the revert reason is using memory via assembly
634 
635                 // solhint-disable-next-line no-inline-assembly
636                 assembly {
637                     let returndata_size := mload(returndata)
638                     revert(add(32, returndata), returndata_size)
639                 }
640             } else {
641                 revert(errorMessage);
642             }
643         }
644     }
645 }
646 
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
721 // File: contracts\cvxRewardPool.sol
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
735 * Synthetix: cvxRewardPool.sol
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
764 
765 contract cvxRewardPool{
766     using SafeERC20 for IERC20;
767     using SafeMath for uint256;
768 
769     IERC20 public immutable rewardToken;
770     IERC20 public immutable stakingToken;
771     uint256 public constant duration = 7 days;
772     uint256 public constant FEE_DENOMINATOR = 10000;
773 
774     address public immutable operator;
775     address public immutable crvDeposits;
776     address public immutable cvxCrvRewards;
777     IERC20 public immutable cvxCrvToken;
778     address public immutable rewardManager;
779 
780     uint256 public periodFinish = 0;
781     uint256 public rewardRate = 0;
782     uint256 public lastUpdateTime;
783     uint256 public rewardPerTokenStored;
784     uint256 public queuedRewards = 0;
785     uint256 public currentRewards = 0;
786     uint256 public historicalRewards = 0;
787     uint256 public constant newRewardRatio = 830;
788     uint256 private _totalSupply;
789     mapping(address => uint256) private _balances;
790     mapping(address => uint256) public userRewardPerTokenPaid;
791     mapping(address => uint256) public rewards;
792 
793     address[] public extraRewards;
794 
795     event RewardAdded(uint256 reward);
796     event Staked(address indexed user, uint256 amount);
797     event Withdrawn(address indexed user, uint256 amount);
798     event RewardPaid(address indexed user, uint256 reward);
799 
800     constructor(
801         address stakingToken_,
802         address rewardToken_,
803         address crvDeposits_,
804         address cvxCrvRewards_,
805         address cvxCrvToken_,
806         address operator_,
807         address rewardManager_
808     ) public {
809         stakingToken = IERC20(stakingToken_);
810         rewardToken = IERC20(rewardToken_);
811         operator = operator_;
812         rewardManager = rewardManager_;
813         crvDeposits = crvDeposits_;
814         cvxCrvRewards = cvxCrvRewards_;
815         cvxCrvToken = IERC20(cvxCrvToken_);
816     }
817 
818     function totalSupply() public view returns (uint256) {
819         return _totalSupply;
820     }
821 
822     function balanceOf(address account) public view returns (uint256) {
823         return _balances[account];
824     }
825 
826     function extraRewardsLength() external view returns (uint256) {
827         return extraRewards.length;
828     }
829 
830     function addExtraReward(address _reward) external {
831         require(msg.sender == rewardManager, "!authorized");
832         require(_reward != address(0),"!reward setting");
833 
834         extraRewards.push(_reward);
835     }
836     function clearExtraRewards() external{
837         require(msg.sender == rewardManager, "!authorized");
838         delete extraRewards;
839     }
840 
841     modifier updateReward(address account) {
842         rewardPerTokenStored = rewardPerToken();
843         lastUpdateTime = lastTimeRewardApplicable();
844         if (account != address(0)) {
845             rewards[account] = earnedReward(account);
846             userRewardPerTokenPaid[account] = rewardPerTokenStored;
847         }
848         _;
849     }
850 
851     function lastTimeRewardApplicable() public view returns (uint256) {
852         return MathUtil.min(block.timestamp, periodFinish);
853     }
854 
855     function rewardPerToken() public view returns (uint256) {
856         uint256 supply = totalSupply();
857         if (supply == 0) {
858             return rewardPerTokenStored;
859         }
860         return
861             rewardPerTokenStored.add(
862                 lastTimeRewardApplicable()
863                     .sub(lastUpdateTime)
864                     .mul(rewardRate)
865                     .mul(1e18)
866                     .div(supply)
867             );
868     }
869 
870     function earnedReward(address account) internal view returns (uint256) {
871         return
872             balanceOf(account)
873                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
874                 .div(1e18)
875                 .add(rewards[account]);
876     }
877 
878     function earned(address account) external view returns (uint256) {
879         uint256 depositFeeRate = ICrvDeposit(crvDeposits).lockIncentive();
880 
881         uint256 r = earnedReward(account);
882         uint256 fees = r.mul(depositFeeRate).div(FEE_DENOMINATOR);
883         
884         //fees dont apply until whitelist+vecrv lock begins so will report
885         //slightly less value than what is actually received.
886         return r.sub(fees);
887     }
888 
889     function stake(uint256 _amount)
890         public
891         updateReward(msg.sender)
892     {
893         require(_amount > 0, 'RewardPool : Cannot stake 0');
894 
895         //also stake to linked rewards
896         uint256 length = extraRewards.length;
897         for(uint i=0; i < length; i++){
898             IRewards(extraRewards[i]).stake(msg.sender, _amount);
899         }
900 
901         //add supply
902         _totalSupply = _totalSupply.add(_amount);
903         //add to sender balance sheet
904         _balances[msg.sender] = _balances[msg.sender].add(_amount);
905         //take tokens from sender
906         stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
907 
908         emit Staked(msg.sender, _amount);
909     }
910 
911     function stakeAll() external{
912         uint256 balance = stakingToken.balanceOf(msg.sender);
913         stake(balance);
914     }
915 
916     function stakeFor(address _for, uint256 _amount)
917         public
918         updateReward(_for)
919     {
920         require(_amount > 0, 'RewardPool : Cannot stake 0');
921 
922         //also stake to linked rewards
923         uint256 length = extraRewards.length;
924         for(uint i=0; i < length; i++){
925             IRewards(extraRewards[i]).stake(_for, _amount);
926         }
927 
928          //add supply
929         _totalSupply = _totalSupply.add(_amount);
930         //add to _for's balance sheet
931         _balances[_for] = _balances[_for].add(_amount);
932         //take tokens from sender
933         stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
934 
935         emit Staked(msg.sender, _amount);
936     }
937 
938     function withdraw(uint256 _amount, bool claim)
939         public
940         updateReward(msg.sender)
941     {
942         require(_amount > 0, 'RewardPool : Cannot withdraw 0');
943 
944         //also withdraw from linked rewards
945         uint256 length = extraRewards.length;
946         for(uint i=0; i < length; i++){
947             IRewards(extraRewards[i]).withdraw(msg.sender, _amount);
948         }
949 
950         _totalSupply = _totalSupply.sub(_amount);
951         _balances[msg.sender] = _balances[msg.sender].sub(_amount);
952         stakingToken.safeTransfer(msg.sender, _amount);
953         emit Withdrawn(msg.sender, _amount);
954 
955         if(claim){
956             getReward(msg.sender,true,false);
957         }
958     }
959 
960     function withdrawAll(bool claim) external{
961         withdraw(_balances[msg.sender],claim);
962     }
963 
964     function getReward(address _account, bool _claimExtras, bool _stake) public updateReward(_account){
965         uint256 reward = earnedReward(_account);
966         if (reward > 0) {
967             rewards[_account] = 0;
968             rewardToken.safeApprove(crvDeposits,0);
969             rewardToken.safeApprove(crvDeposits,reward);
970             ICrvDeposit(crvDeposits).deposit(reward,false);
971 
972             uint256 cvxCrvBalance = cvxCrvToken.balanceOf(address(this));
973             if(_stake){
974                 IERC20(cvxCrvToken).safeApprove(cvxCrvRewards,0);
975                 IERC20(cvxCrvToken).safeApprove(cvxCrvRewards,cvxCrvBalance);
976                 IRewards(cvxCrvRewards).stakeFor(_account,cvxCrvBalance);
977             }else{
978                 cvxCrvToken.safeTransfer(_account, cvxCrvBalance);
979             }
980             emit RewardPaid(_account, cvxCrvBalance);
981         }
982 
983         //also get rewards from linked rewards
984         if(_claimExtras){
985             uint256 length = extraRewards.length;
986             for(uint i=0; i < length; i++){
987                 IRewards(extraRewards[i]).getReward(_account);
988             }
989         }
990     }
991 
992     function getReward(bool _stake) external{
993         getReward(msg.sender,true, _stake);
994     }
995 
996     function donate(uint256 _amount) external returns(bool){
997         IERC20(rewardToken).safeTransferFrom(msg.sender, address(this), _amount);
998         queuedRewards = queuedRewards.add(_amount);
999     }
1000 
1001     function queueNewRewards(uint256 _rewards) external{
1002         require(msg.sender == operator, "!authorized");
1003 
1004         _rewards = _rewards.add(queuedRewards);
1005 
1006         if (block.timestamp >= periodFinish) {
1007             notifyRewardAmount(_rewards);
1008             queuedRewards = 0;
1009             return;
1010         }
1011 
1012         //et = now - (finish-duration)
1013         uint256 elapsedTime = block.timestamp.sub(periodFinish.sub(duration));
1014         //current at now: rewardRate * elapsedTime
1015         uint256 currentAtNow = rewardRate * elapsedTime;
1016         uint256 queuedRatio = currentAtNow.mul(1000).div(_rewards);
1017         if(queuedRatio < newRewardRatio){
1018             notifyRewardAmount(_rewards);
1019             queuedRewards = 0;
1020         }else{
1021             queuedRewards = _rewards;
1022         }
1023     }
1024 
1025     function notifyRewardAmount(uint256 reward)
1026         internal
1027         updateReward(address(0))
1028     {
1029         historicalRewards = historicalRewards.add(reward);
1030         if (block.timestamp >= periodFinish) {
1031             rewardRate = reward.div(duration);
1032         } else {
1033             uint256 remaining = periodFinish.sub(block.timestamp);
1034             uint256 leftover = remaining.mul(rewardRate);
1035             reward = reward.add(leftover);
1036             rewardRate = reward.div(duration);
1037         }
1038         currentRewards = reward;
1039         lastUpdateTime = block.timestamp;
1040         periodFinish = block.timestamp.add(duration);
1041         emit RewardAdded(reward);
1042     }
1043 }