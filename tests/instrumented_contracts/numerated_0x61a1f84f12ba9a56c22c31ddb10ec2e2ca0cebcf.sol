1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts\Interfaces.sol
4 
5 pragma solidity 0.6.12;
6 
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library MathUtil {
12     /**
13      * @dev Returns the smallest of two numbers.
14      */
15     function min(uint256 a, uint256 b) internal pure returns (uint256) {
16         return a < b ? a : b;
17     }
18 }
19 
20 contract ReentrancyGuard {
21     uint256 private _guardCounter;
22 
23     constructor () internal {
24         _guardCounter = 1;
25     }
26 
27     modifier nonReentrant() {
28         _guardCounter += 1;
29         uint256 localCounter = _guardCounter;
30         _;
31         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
32     }
33 }
34 
35 interface ICurveGauge {
36     function deposit(uint256) external;
37     function balanceOf(address) external view returns (uint256);
38     function withdraw(uint256) external;
39     function claim_rewards() external;
40     function reward_tokens(uint256) external view returns(address);//v2
41     function rewarded_token() external view returns(address);//v1
42 }
43 
44 interface ICurveVoteEscrow {
45     function create_lock(uint256, uint256) external;
46     function increase_amount(uint256) external;
47     function increase_unlock_time(uint256) external;
48     function withdraw() external;
49     function smart_wallet_checker() external view returns (address);
50 }
51 
52 interface IWalletChecker {
53     function check(address) external view returns (bool);
54 }
55 
56 interface IVoting{
57     function vote(uint256, bool, bool) external; //voteId, support, executeIfDecided
58     function getVote(uint256) external view returns(bool,bool,uint64,uint64,uint64,uint64,uint256,uint256,uint256,bytes memory); 
59     function vote_for_gauge_weights(address,uint256) external;
60 }
61 
62 interface IMinter{
63     function mint(address) external;
64 }
65 
66 interface IRegistry{
67     function get_registry() external view returns(address);
68     function get_address(uint256 _id) external view returns(address);
69     function gauge_controller() external view returns(address);
70     function get_lp_token(address) external view returns(address);
71     function get_gauges(address) external view returns(address[10] memory,uint128[10] memory);
72 }
73 
74 interface IStaker{
75     function deposit(address, address) external;
76     function withdraw(address) external;
77     function withdraw(address, address, uint256) external;
78     function withdrawAll(address, address) external;
79     function createLock(uint256, uint256) external;
80     function increaseAmount(uint256) external;
81     function increaseTime(uint256) external;
82     function release() external;
83     function claimCrv(address) external returns (uint256);
84     function claimRewards(address) external;
85     function claimFees(address,address) external;
86     function setStashAccess(address, bool) external;
87     function vote(uint256,address,bool) external;
88     function voteGaugeWeight(address,uint256) external;
89     function balanceOfPool(address) external view returns (uint256);
90     function operator() external view returns (address);
91     function execute(address _to, uint256 _value, bytes calldata _data) external returns (bool, bytes memory);
92 }
93 
94 interface IRewards{
95     function stake(address, uint256) external;
96     function stakeFor(address, uint256) external;
97     function withdraw(address, uint256) external;
98     function exit(address) external;
99     function getReward(address) external;
100     function queueNewRewards(uint256) external;
101     function notifyRewardAmount(uint256) external;
102     function addExtraReward(address) external;
103     function stakingToken() external returns (address);
104 }
105 
106 interface IStash{
107     function stashRewards() external returns (bool);
108     function processStash() external returns (bool);
109     function claimRewards() external returns (bool);
110 }
111 
112 interface IFeeDistro{
113     function claim() external;
114     function token() external view returns(address);
115 }
116 
117 interface ITokenMinter{
118     function mint(address,uint256) external;
119     function burn(address,uint256) external;
120 }
121 
122 interface IDeposit{
123     function isShutdown() external view returns(bool);
124     function balanceOf(address _account) external view returns(uint256);
125     function totalSupply() external view returns(uint256);
126     function poolInfo(uint256) external view returns(address,address,address,address,address, bool);
127     function rewardClaimed(uint256,address,uint256) external;
128     function withdrawTo(uint256,uint256,address) external;
129     function claimRewards(uint256,address) external returns(bool);
130     function rewardArbitrator() external returns(address);
131 }
132 
133 interface ICrvDeposit{
134     function deposit(uint256, bool) external;
135     function lockIncentive() external view returns(uint256);
136 }
137 
138 interface IRewardFactory{
139     function setAccess(address,bool) external;
140     function CreateCrvRewards(uint256,address) external returns(address);
141     function CreateTokenRewards(address,address,address) external returns(address);
142     function activeRewardCount(address) external view returns(uint256);
143     function addActiveReward(address,uint256) external returns(bool);
144     function removeActiveReward(address,uint256) external returns(bool);
145 }
146 
147 interface IStashFactory{
148     function CreateStash(uint256,address,address,uint256) external returns(address);
149 }
150 
151 interface ITokenFactory{
152     function CreateDepositToken(address) external returns(address);
153 }
154 
155 interface IPools{
156     function addPool(address _lptoken, address _gauge, uint256 _stashVersion) external returns(bool);
157     function shutdownPool(uint256 _pid) external returns(bool);
158     function poolInfo(uint256) external view returns(address,address,address,address,address,bool);
159     function poolLength() external view returns (uint256);
160     function gaugeMap(address) external view returns(bool);
161     function setPoolManager(address _poolM) external;
162 }
163 
164 interface IVestedEscrow{
165     function fund(address[] calldata _recipient, uint256[] calldata _amount) external returns(bool);
166 }
167 
168 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
169 
170 pragma solidity >=0.6.0 <0.8.0;
171 
172 /**
173  * @dev Interface of the ERC20 standard as defined in the EIP.
174  */
175 interface IERC20 {
176     /**
177      * @dev Returns the amount of tokens in existence.
178      */
179     function totalSupply() external view returns (uint256);
180 
181     /**
182      * @dev Returns the amount of tokens owned by `account`.
183      */
184     function balanceOf(address account) external view returns (uint256);
185 
186     /**
187      * @dev Moves `amount` tokens from the caller's account to `recipient`.
188      *
189      * Returns a boolean value indicating whether the operation succeeded.
190      *
191      * Emits a {Transfer} event.
192      */
193     function transfer(address recipient, uint256 amount) external returns (bool);
194 
195     /**
196      * @dev Returns the remaining number of tokens that `spender` will be
197      * allowed to spend on behalf of `owner` through {transferFrom}. This is
198      * zero by default.
199      *
200      * This value changes when {approve} or {transferFrom} are called.
201      */
202     function allowance(address owner, address spender) external view returns (uint256);
203 
204     /**
205      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
206      *
207      * Returns a boolean value indicating whether the operation succeeded.
208      *
209      * IMPORTANT: Beware that changing an allowance with this method brings the risk
210      * that someone may use both the old and the new allowance by unfortunate
211      * transaction ordering. One possible solution to mitigate this race
212      * condition is to first reduce the spender's allowance to 0 and set the
213      * desired value afterwards:
214      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
215      *
216      * Emits an {Approval} event.
217      */
218     function approve(address spender, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Moves `amount` tokens from `sender` to `recipient` using the
222      * allowance mechanism. `amount` is then deducted from the caller's
223      * allowance.
224      *
225      * Returns a boolean value indicating whether the operation succeeded.
226      *
227      * Emits a {Transfer} event.
228      */
229     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
230 
231     /**
232      * @dev Emitted when `value` tokens are moved from one account (`from`) to
233      * another (`to`).
234      *
235      * Note that `value` may be zero.
236      */
237     event Transfer(address indexed from, address indexed to, uint256 value);
238 
239     /**
240      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
241      * a call to {approve}. `value` is the new allowance.
242      */
243     event Approval(address indexed owner, address indexed spender, uint256 value);
244 }
245 
246 // File: @openzeppelin\contracts\utils\Address.sol
247 
248 pragma solidity >=0.6.2 <0.8.0;
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // This method relies on extcodesize, which returns 0 for contracts in
273         // construction, since the code is only stored at the end of the
274         // constructor execution.
275 
276         uint256 size;
277         // solhint-disable-next-line no-inline-assembly
278         assembly { size := extcodesize(account) }
279         return size > 0;
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
302         (bool success, ) = recipient.call{ value: amount }("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain`call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325       return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
335         return functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: value }(data);
365         return _verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
385         require(isContract(target), "Address: static call to non-contract");
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.staticcall(data);
389         return _verifyCallResult(success, returndata, errorMessage);
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
394      * but performing a delegate call.
395      *
396      * _Available since v3.4._
397      */
398     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
404      * but performing a delegate call.
405      *
406      * _Available since v3.4._
407      */
408     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
409         require(isContract(target), "Address: delegate call to non-contract");
410 
411         // solhint-disable-next-line avoid-low-level-calls
412         (bool success, bytes memory returndata) = target.delegatecall(data);
413         return _verifyCallResult(success, returndata, errorMessage);
414     }
415 
416     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
417         if (success) {
418             return returndata;
419         } else {
420             // Look for revert reason and bubble it up if present
421             if (returndata.length > 0) {
422                 // The easiest way to bubble the revert reason is using memory via assembly
423 
424                 // solhint-disable-next-line no-inline-assembly
425                 assembly {
426                     let returndata_size := mload(returndata)
427                     revert(add(32, returndata), returndata_size)
428                 }
429             } else {
430                 revert(errorMessage);
431             }
432         }
433     }
434 }
435 
436 
437 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
438 
439 
440 pragma solidity >=0.6.0 <0.8.0;
441 
442 /**
443  * @dev Wrappers over Solidity's arithmetic operations with added overflow
444  * checks.
445  *
446  * Arithmetic operations in Solidity wrap on overflow. This can easily result
447  * in bugs, because programmers usually assume that an overflow raises an
448  * error, which is the standard behavior in high level programming languages.
449  * `SafeMath` restores this intuition by reverting the transaction when an
450  * operation overflows.
451  *
452  * Using this library instead of the unchecked operations eliminates an entire
453  * class of bugs, so it's recommended to use it always.
454  */
455 library SafeMath {
456     /**
457      * @dev Returns the addition of two unsigned integers, with an overflow flag.
458      *
459      * _Available since v3.4._
460      */
461     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
462         uint256 c = a + b;
463         if (c < a) return (false, 0);
464         return (true, c);
465     }
466 
467     /**
468      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
469      *
470      * _Available since v3.4._
471      */
472     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
473         if (b > a) return (false, 0);
474         return (true, a - b);
475     }
476 
477     /**
478      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
479      *
480      * _Available since v3.4._
481      */
482     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
483         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
484         // benefit is lost if 'b' is also tested.
485         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
486         if (a == 0) return (true, 0);
487         uint256 c = a * b;
488         if (c / a != b) return (false, 0);
489         return (true, c);
490     }
491 
492     /**
493      * @dev Returns the division of two unsigned integers, with a division by zero flag.
494      *
495      * _Available since v3.4._
496      */
497     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
498         if (b == 0) return (false, 0);
499         return (true, a / b);
500     }
501 
502     /**
503      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
504      *
505      * _Available since v3.4._
506      */
507     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
508         if (b == 0) return (false, 0);
509         return (true, a % b);
510     }
511 
512     /**
513      * @dev Returns the addition of two unsigned integers, reverting on
514      * overflow.
515      *
516      * Counterpart to Solidity's `+` operator.
517      *
518      * Requirements:
519      *
520      * - Addition cannot overflow.
521      */
522     function add(uint256 a, uint256 b) internal pure returns (uint256) {
523         uint256 c = a + b;
524         require(c >= a, "SafeMath: addition overflow");
525         return c;
526     }
527 
528     /**
529      * @dev Returns the subtraction of two unsigned integers, reverting on
530      * overflow (when the result is negative).
531      *
532      * Counterpart to Solidity's `-` operator.
533      *
534      * Requirements:
535      *
536      * - Subtraction cannot overflow.
537      */
538     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
539         require(b <= a, "SafeMath: subtraction overflow");
540         return a - b;
541     }
542 
543     /**
544      * @dev Returns the multiplication of two unsigned integers, reverting on
545      * overflow.
546      *
547      * Counterpart to Solidity's `*` operator.
548      *
549      * Requirements:
550      *
551      * - Multiplication cannot overflow.
552      */
553     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
554         if (a == 0) return 0;
555         uint256 c = a * b;
556         require(c / a == b, "SafeMath: multiplication overflow");
557         return c;
558     }
559 
560     /**
561      * @dev Returns the integer division of two unsigned integers, reverting on
562      * division by zero. The result is rounded towards zero.
563      *
564      * Counterpart to Solidity's `/` operator. Note: this function uses a
565      * `revert` opcode (which leaves remaining gas untouched) while Solidity
566      * uses an invalid opcode to revert (consuming all remaining gas).
567      *
568      * Requirements:
569      *
570      * - The divisor cannot be zero.
571      */
572     function div(uint256 a, uint256 b) internal pure returns (uint256) {
573         require(b > 0, "SafeMath: division by zero");
574         return a / b;
575     }
576 
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
579      * reverting when dividing by zero.
580      *
581      * Counterpart to Solidity's `%` operator. This function uses a `revert`
582      * opcode (which leaves remaining gas untouched) while Solidity uses an
583      * invalid opcode to revert (consuming all remaining gas).
584      *
585      * Requirements:
586      *
587      * - The divisor cannot be zero.
588      */
589     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
590         require(b > 0, "SafeMath: modulo by zero");
591         return a % b;
592     }
593 
594     /**
595      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
596      * overflow (when the result is negative).
597      *
598      * CAUTION: This function is deprecated because it requires allocating memory for the error
599      * message unnecessarily. For custom revert reasons use {trySub}.
600      *
601      * Counterpart to Solidity's `-` operator.
602      *
603      * Requirements:
604      *
605      * - Subtraction cannot overflow.
606      */
607     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
608         require(b <= a, errorMessage);
609         return a - b;
610     }
611 
612     /**
613      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
614      * division by zero. The result is rounded towards zero.
615      *
616      * CAUTION: This function is deprecated because it requires allocating memory for the error
617      * message unnecessarily. For custom revert reasons use {tryDiv}.
618      *
619      * Counterpart to Solidity's `/` operator. Note: this function uses a
620      * `revert` opcode (which leaves remaining gas untouched) while Solidity
621      * uses an invalid opcode to revert (consuming all remaining gas).
622      *
623      * Requirements:
624      *
625      * - The divisor cannot be zero.
626      */
627     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
628         require(b > 0, errorMessage);
629         return a / b;
630     }
631 
632     /**
633      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
634      * reverting with custom message when dividing by zero.
635      *
636      * CAUTION: This function is deprecated because it requires allocating memory for the error
637      * message unnecessarily. For custom revert reasons use {tryMod}.
638      *
639      * Counterpart to Solidity's `%` operator. This function uses a `revert`
640      * opcode (which leaves remaining gas untouched) while Solidity uses an
641      * invalid opcode to revert (consuming all remaining gas).
642      *
643      * Requirements:
644      *
645      * - The divisor cannot be zero.
646      */
647     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
648         require(b > 0, errorMessage);
649         return a % b;
650     }
651 }
652 
653 
654 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
655 
656 pragma solidity >=0.6.0 <0.8.0;
657 
658 /**
659  * @title SafeERC20
660  * @dev Wrappers around ERC20 operations that throw on failure (when the token
661  * contract returns false). Tokens that return no value (and instead revert or
662  * throw on failure) are also supported, non-reverting calls are assumed to be
663  * successful.
664  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
665  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
666  */
667 library SafeERC20 {
668     using SafeMath for uint256;
669     using Address for address;
670 
671     function safeTransfer(IERC20 token, address to, uint256 value) internal {
672         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
673     }
674 
675     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
676         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
677     }
678 
679     /**
680      * @dev Deprecated. This function has issues similar to the ones found in
681      * {IERC20-approve}, and its usage is discouraged.
682      *
683      * Whenever possible, use {safeIncreaseAllowance} and
684      * {safeDecreaseAllowance} instead.
685      */
686     function safeApprove(IERC20 token, address spender, uint256 value) internal {
687         // safeApprove should only be called when setting an initial allowance,
688         // or when resetting it to zero. To increase and decrease it, use
689         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
690         // solhint-disable-next-line max-line-length
691         require((value == 0) || (token.allowance(address(this), spender) == 0),
692             "SafeERC20: approve from non-zero to non-zero allowance"
693         );
694         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
695     }
696 
697     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
698         uint256 newAllowance = token.allowance(address(this), spender).add(value);
699         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
700     }
701 
702     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
703         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
704         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
705     }
706 
707     /**
708      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
709      * on the return value: the return value is optional (but if data is returned, it must not be false).
710      * @param token The token targeted by the call.
711      * @param data The call data (encoded using abi.encode or one of its variants).
712      */
713     function _callOptionalReturn(IERC20 token, bytes memory data) private {
714         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
715         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
716         // the target address contains contract code and also asserts for success in the low-level call.
717 
718         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
719         if (returndata.length > 0) { // Return data is optional
720             // solhint-disable-next-line max-line-length
721             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
722         }
723     }
724 }
725 
726 // File: contracts\MerkleAirdrop.sol
727 /**
728  * Copyright (C) 2018  Smartz, LLC
729  *
730  * Licensed under the Apache License, Version 2.0 (the "License").
731  * You may not use this file except in compliance with the License.
732  *
733  * Unless required by applicable law or agreed to in writing, software
734  * distributed under the License is distributed on an "AS IS" BASIS,
735  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
736  */
737 /*
738 Changes by Convex
739 - update to solidity 0.6.12
740 - allow different types of claiming(transfer, mint, generic interaction with seperate contract)
741 */
742 
743 pragma solidity 0.6.12;
744 
745 
746 
747 contract MerkleAirdrop {
748     using SafeERC20 for IERC20;
749     using Address for address;
750 
751     address public owner;
752     bytes32 public merkleRoot;
753 
754     address public rewardContract;
755     address public rewardToken;
756     address public mintToken;
757 
758     mapping (address => bool) public hasClaimed;
759     event Claim(address addr, uint256 num);
760 
761     constructor(address _owner) public {
762         owner = _owner;
763     }
764 
765     function setOwner(address _owner) external {
766         require(msg.sender == owner);
767         owner = _owner;
768     }
769 
770     function setRewardContract(address _rewardContract) external {
771         require(msg.sender == owner);
772         rewardContract = _rewardContract;
773     }
774 
775     function setRewardToken(address _rewardToken) external {
776         require(msg.sender == owner);
777         rewardToken = _rewardToken;
778     }
779 
780     function setMintToken(address _mintToken) external {
781         require(msg.sender == owner);
782         mintToken = _mintToken;
783     }
784 
785     function setRoot(bytes32 _merkleRoot) external {
786         require(msg.sender == owner);
787         merkleRoot = _merkleRoot;
788     }
789 
790     function addressToAsciiString(address x) internal pure returns (string memory) {
791         bytes memory s = new bytes(40);
792         for (uint i = 0; i < 20; i++) {
793             byte b = byte(uint8(uint(x) / (2**(8*(19 - i)))));
794             byte hi = byte(uint8(b) / 16);
795             byte lo = byte(uint8(b) - 16 * uint8(hi));
796             s[2*i] = char(hi);
797             s[2*i+1] = char(lo);
798         }
799         return string(s);
800     }
801 
802     function char(byte b) internal pure returns (byte c) {
803         if (uint8(b) < 10) return byte(uint8(b) + 0x30);
804         else return byte(uint8(b) + 0x57);
805     }
806 
807     function uintToStr(uint _i) internal pure returns (string memory _uintAsString) {
808         if (_i == 0) {
809             return "0";
810         }
811         uint j = _i;
812         uint len;
813         while (j != 0) {
814             len++;
815             j /= 10;
816         }
817         bytes memory bstr = new bytes(len);
818         uint k = len;
819         while (_i != 0) {
820             k = k-1;
821             uint8 temp = (48 + uint8(_i - _i / 10 * 10));
822             bytes1 b1 = bytes1(temp);
823             bstr[k] = b1;
824             _i /= 10;
825         }
826         return string(bstr);
827     }
828 
829     function getLeaf(address _a, uint256 _n) internal pure returns(bytes32) {
830         string memory prefix = "0x";
831         string memory space = " ";
832 
833         return keccak256(abi.encodePacked(prefix,addressToAsciiString(_a),space,uintToStr(_n)));
834     }
835 
836 
837     function claim(bytes32[] calldata _proof, address _who, uint256 _amount) public returns(bool) {
838         require(hasClaimed[_who] != true,"already claimed");
839         require(_amount > 0);
840         require(checkProof(_proof, getLeaf(_who, _amount)),"failed proof check");
841 
842         hasClaimed[_who] = true;
843 
844         if(rewardToken != address(0)){
845             //send reward token directly
846             IERC20(rewardToken).safeTransfer(_who, _amount);
847         }else if(mintToken != address(0)){
848             //mint tokens directly
849             ITokenMinter(mintToken).mint(_who, _amount);
850         }else{
851             //inform a different reward contract that a claim has been made
852             address[] memory recip = new address[](1);
853             recip[0] = _who;
854             uint256[] memory amounts = new uint256[](1);
855             amounts[0] = _amount;
856             IVestedEscrow(rewardContract).fund(recip,amounts);
857         }
858 
859         emit Claim(_who, _amount);
860         return true;
861     }
862 
863     function checkProof(bytes32[] calldata _proof, bytes32 _hash) view internal returns (bool) {
864         bytes32 el;
865         bytes32 h = _hash;
866 
867         for (uint i = 0; i <= _proof.length - 1; i += 1) {
868             el = _proof[i];
869 
870             if (h < el) {
871                 h = keccak256(abi.encodePacked(h, el));
872             } else {
873                 h = keccak256(abi.encodePacked(el, h));
874             }
875         }
876 
877         return h == merkleRoot;
878     }
879 }