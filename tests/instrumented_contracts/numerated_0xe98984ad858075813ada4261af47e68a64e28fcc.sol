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
168 
169 pragma solidity >=0.6.0 <0.8.0;
170 
171 /**
172  * @dev Wrappers over Solidity's arithmetic operations with added overflow
173  * checks.
174  *
175  * Arithmetic operations in Solidity wrap on overflow. This can easily result
176  * in bugs, because programmers usually assume that an overflow raises an
177  * error, which is the standard behavior in high level programming languages.
178  * `SafeMath` restores this intuition by reverting the transaction when an
179  * operation overflows.
180  *
181  * Using this library instead of the unchecked operations eliminates an entire
182  * class of bugs, so it's recommended to use it always.
183  */
184 library SafeMath {
185     /**
186      * @dev Returns the addition of two unsigned integers, with an overflow flag.
187      *
188      * _Available since v3.4._
189      */
190     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
191         uint256 c = a + b;
192         if (c < a) return (false, 0);
193         return (true, c);
194     }
195 
196     /**
197      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
198      *
199      * _Available since v3.4._
200      */
201     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
202         if (b > a) return (false, 0);
203         return (true, a - b);
204     }
205 
206     /**
207      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
208      *
209      * _Available since v3.4._
210      */
211     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
213         // benefit is lost if 'b' is also tested.
214         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
215         if (a == 0) return (true, 0);
216         uint256 c = a * b;
217         if (c / a != b) return (false, 0);
218         return (true, c);
219     }
220 
221     /**
222      * @dev Returns the division of two unsigned integers, with a division by zero flag.
223      *
224      * _Available since v3.4._
225      */
226     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
227         if (b == 0) return (false, 0);
228         return (true, a / b);
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         if (b == 0) return (false, 0);
238         return (true, a % b);
239     }
240 
241     /**
242      * @dev Returns the addition of two unsigned integers, reverting on
243      * overflow.
244      *
245      * Counterpart to Solidity's `+` operator.
246      *
247      * Requirements:
248      *
249      * - Addition cannot overflow.
250      */
251     function add(uint256 a, uint256 b) internal pure returns (uint256) {
252         uint256 c = a + b;
253         require(c >= a, "SafeMath: addition overflow");
254         return c;
255     }
256 
257     /**
258      * @dev Returns the subtraction of two unsigned integers, reverting on
259      * overflow (when the result is negative).
260      *
261      * Counterpart to Solidity's `-` operator.
262      *
263      * Requirements:
264      *
265      * - Subtraction cannot overflow.
266      */
267     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
268         require(b <= a, "SafeMath: subtraction overflow");
269         return a - b;
270     }
271 
272     /**
273      * @dev Returns the multiplication of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `*` operator.
277      *
278      * Requirements:
279      *
280      * - Multiplication cannot overflow.
281      */
282     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
283         if (a == 0) return 0;
284         uint256 c = a * b;
285         require(c / a == b, "SafeMath: multiplication overflow");
286         return c;
287     }
288 
289     /**
290      * @dev Returns the integer division of two unsigned integers, reverting on
291      * division by zero. The result is rounded towards zero.
292      *
293      * Counterpart to Solidity's `/` operator. Note: this function uses a
294      * `revert` opcode (which leaves remaining gas untouched) while Solidity
295      * uses an invalid opcode to revert (consuming all remaining gas).
296      *
297      * Requirements:
298      *
299      * - The divisor cannot be zero.
300      */
301     function div(uint256 a, uint256 b) internal pure returns (uint256) {
302         require(b > 0, "SafeMath: division by zero");
303         return a / b;
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * reverting when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         require(b > 0, "SafeMath: modulo by zero");
320         return a % b;
321     }
322 
323     /**
324      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
325      * overflow (when the result is negative).
326      *
327      * CAUTION: This function is deprecated because it requires allocating memory for the error
328      * message unnecessarily. For custom revert reasons use {trySub}.
329      *
330      * Counterpart to Solidity's `-` operator.
331      *
332      * Requirements:
333      *
334      * - Subtraction cannot overflow.
335      */
336     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         require(b <= a, errorMessage);
338         return a - b;
339     }
340 
341     /**
342      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
343      * division by zero. The result is rounded towards zero.
344      *
345      * CAUTION: This function is deprecated because it requires allocating memory for the error
346      * message unnecessarily. For custom revert reasons use {tryDiv}.
347      *
348      * Counterpart to Solidity's `/` operator. Note: this function uses a
349      * `revert` opcode (which leaves remaining gas untouched) while Solidity
350      * uses an invalid opcode to revert (consuming all remaining gas).
351      *
352      * Requirements:
353      *
354      * - The divisor cannot be zero.
355      */
356     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
357         require(b > 0, errorMessage);
358         return a / b;
359     }
360 
361     /**
362      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
363      * reverting with custom message when dividing by zero.
364      *
365      * CAUTION: This function is deprecated because it requires allocating memory for the error
366      * message unnecessarily. For custom revert reasons use {tryMod}.
367      *
368      * Counterpart to Solidity's `%` operator. This function uses a `revert`
369      * opcode (which leaves remaining gas untouched) while Solidity uses an
370      * invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      *
374      * - The divisor cannot be zero.
375      */
376     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
377         require(b > 0, errorMessage);
378         return a % b;
379     }
380 }
381 
382 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
383 
384 pragma solidity >=0.6.0 <0.8.0;
385 
386 /**
387  * @dev Interface of the ERC20 standard as defined in the EIP.
388  */
389 interface IERC20 {
390     /**
391      * @dev Returns the amount of tokens in existence.
392      */
393     function totalSupply() external view returns (uint256);
394 
395     /**
396      * @dev Returns the amount of tokens owned by `account`.
397      */
398     function balanceOf(address account) external view returns (uint256);
399 
400     /**
401      * @dev Moves `amount` tokens from the caller's account to `recipient`.
402      *
403      * Returns a boolean value indicating whether the operation succeeded.
404      *
405      * Emits a {Transfer} event.
406      */
407     function transfer(address recipient, uint256 amount) external returns (bool);
408 
409     /**
410      * @dev Returns the remaining number of tokens that `spender` will be
411      * allowed to spend on behalf of `owner` through {transferFrom}. This is
412      * zero by default.
413      *
414      * This value changes when {approve} or {transferFrom} are called.
415      */
416     function allowance(address owner, address spender) external view returns (uint256);
417 
418     /**
419      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
420      *
421      * Returns a boolean value indicating whether the operation succeeded.
422      *
423      * IMPORTANT: Beware that changing an allowance with this method brings the risk
424      * that someone may use both the old and the new allowance by unfortunate
425      * transaction ordering. One possible solution to mitigate this race
426      * condition is to first reduce the spender's allowance to 0 and set the
427      * desired value afterwards:
428      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
429      *
430      * Emits an {Approval} event.
431      */
432     function approve(address spender, uint256 amount) external returns (bool);
433 
434     /**
435      * @dev Moves `amount` tokens from `sender` to `recipient` using the
436      * allowance mechanism. `amount` is then deducted from the caller's
437      * allowance.
438      *
439      * Returns a boolean value indicating whether the operation succeeded.
440      *
441      * Emits a {Transfer} event.
442      */
443     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
444 
445     /**
446      * @dev Emitted when `value` tokens are moved from one account (`from`) to
447      * another (`to`).
448      *
449      * Note that `value` may be zero.
450      */
451     event Transfer(address indexed from, address indexed to, uint256 value);
452 
453     /**
454      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
455      * a call to {approve}. `value` is the new allowance.
456      */
457     event Approval(address indexed owner, address indexed spender, uint256 value);
458 }
459 
460 // File: @openzeppelin\contracts\utils\Address.sol
461 
462 pragma solidity >=0.6.2 <0.8.0;
463 
464 /**
465  * @dev Collection of functions related to the address type
466  */
467 library Address {
468     /**
469      * @dev Returns true if `account` is a contract.
470      *
471      * [IMPORTANT]
472      * ====
473      * It is unsafe to assume that an address for which this function returns
474      * false is an externally-owned account (EOA) and not a contract.
475      *
476      * Among others, `isContract` will return false for the following
477      * types of addresses:
478      *
479      *  - an externally-owned account
480      *  - a contract in construction
481      *  - an address where a contract will be created
482      *  - an address where a contract lived, but was destroyed
483      * ====
484      */
485     function isContract(address account) internal view returns (bool) {
486         // This method relies on extcodesize, which returns 0 for contracts in
487         // construction, since the code is only stored at the end of the
488         // constructor execution.
489 
490         uint256 size;
491         // solhint-disable-next-line no-inline-assembly
492         assembly { size := extcodesize(account) }
493         return size > 0;
494     }
495 
496     /**
497      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
498      * `recipient`, forwarding all available gas and reverting on errors.
499      *
500      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
501      * of certain opcodes, possibly making contracts go over the 2300 gas limit
502      * imposed by `transfer`, making them unable to receive funds via
503      * `transfer`. {sendValue} removes this limitation.
504      *
505      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
506      *
507      * IMPORTANT: because control is transferred to `recipient`, care must be
508      * taken to not create reentrancy vulnerabilities. Consider using
509      * {ReentrancyGuard} or the
510      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
511      */
512     function sendValue(address payable recipient, uint256 amount) internal {
513         require(address(this).balance >= amount, "Address: insufficient balance");
514 
515         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
516         (bool success, ) = recipient.call{ value: amount }("");
517         require(success, "Address: unable to send value, recipient may have reverted");
518     }
519 
520     /**
521      * @dev Performs a Solidity function call using a low level `call`. A
522      * plain`call` is an unsafe replacement for a function call: use this
523      * function instead.
524      *
525      * If `target` reverts with a revert reason, it is bubbled up by this
526      * function (like regular Solidity function calls).
527      *
528      * Returns the raw returned data. To convert to the expected return value,
529      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
530      *
531      * Requirements:
532      *
533      * - `target` must be a contract.
534      * - calling `target` with `data` must not revert.
535      *
536      * _Available since v3.1._
537      */
538     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
539       return functionCall(target, data, "Address: low-level call failed");
540     }
541 
542     /**
543      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
544      * `errorMessage` as a fallback revert reason when `target` reverts.
545      *
546      * _Available since v3.1._
547      */
548     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
549         return functionCallWithValue(target, data, 0, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but also transferring `value` wei to `target`.
555      *
556      * Requirements:
557      *
558      * - the calling contract must have an ETH balance of at least `value`.
559      * - the called Solidity function must be `payable`.
560      *
561      * _Available since v3.1._
562      */
563     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
564         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
569      * with `errorMessage` as a fallback revert reason when `target` reverts.
570      *
571      * _Available since v3.1._
572      */
573     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
574         require(address(this).balance >= value, "Address: insufficient balance for call");
575         require(isContract(target), "Address: call to non-contract");
576 
577         // solhint-disable-next-line avoid-low-level-calls
578         (bool success, bytes memory returndata) = target.call{ value: value }(data);
579         return _verifyCallResult(success, returndata, errorMessage);
580     }
581 
582     /**
583      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
584      * but performing a static call.
585      *
586      * _Available since v3.3._
587      */
588     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
589         return functionStaticCall(target, data, "Address: low-level static call failed");
590     }
591 
592     /**
593      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
594      * but performing a static call.
595      *
596      * _Available since v3.3._
597      */
598     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
599         require(isContract(target), "Address: static call to non-contract");
600 
601         // solhint-disable-next-line avoid-low-level-calls
602         (bool success, bytes memory returndata) = target.staticcall(data);
603         return _verifyCallResult(success, returndata, errorMessage);
604     }
605 
606     /**
607      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
608      * but performing a delegate call.
609      *
610      * _Available since v3.4._
611      */
612     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
613         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
614     }
615 
616     /**
617      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
618      * but performing a delegate call.
619      *
620      * _Available since v3.4._
621      */
622     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
623         require(isContract(target), "Address: delegate call to non-contract");
624 
625         // solhint-disable-next-line avoid-low-level-calls
626         (bool success, bytes memory returndata) = target.delegatecall(data);
627         return _verifyCallResult(success, returndata, errorMessage);
628     }
629 
630     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
631         if (success) {
632             return returndata;
633         } else {
634             // Look for revert reason and bubble it up if present
635             if (returndata.length > 0) {
636                 // The easiest way to bubble the revert reason is using memory via assembly
637 
638                 // solhint-disable-next-line no-inline-assembly
639                 assembly {
640                     let returndata_size := mload(returndata)
641                     revert(add(32, returndata), returndata_size)
642                 }
643             } else {
644                 revert(errorMessage);
645             }
646         }
647     }
648 }
649 
650 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
651 
652 pragma solidity >=0.6.0 <0.8.0;
653 
654 
655 /**
656  * @title SafeERC20
657  * @dev Wrappers around ERC20 operations that throw on failure (when the token
658  * contract returns false). Tokens that return no value (and instead revert or
659  * throw on failure) are also supported, non-reverting calls are assumed to be
660  * successful.
661  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
662  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
663  */
664 library SafeERC20 {
665     using SafeMath for uint256;
666     using Address for address;
667 
668     function safeTransfer(IERC20 token, address to, uint256 value) internal {
669         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
670     }
671 
672     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
673         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
674     }
675 
676     /**
677      * @dev Deprecated. This function has issues similar to the ones found in
678      * {IERC20-approve}, and its usage is discouraged.
679      *
680      * Whenever possible, use {safeIncreaseAllowance} and
681      * {safeDecreaseAllowance} instead.
682      */
683     function safeApprove(IERC20 token, address spender, uint256 value) internal {
684         // safeApprove should only be called when setting an initial allowance,
685         // or when resetting it to zero. To increase and decrease it, use
686         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
687         // solhint-disable-next-line max-line-length
688         require((value == 0) || (token.allowance(address(this), spender) == 0),
689             "SafeERC20: approve from non-zero to non-zero allowance"
690         );
691         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
692     }
693 
694     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
695         uint256 newAllowance = token.allowance(address(this), spender).add(value);
696         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
697     }
698 
699     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
700         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
701         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
702     }
703 
704     /**
705      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
706      * on the return value: the return value is optional (but if data is returned, it must not be false).
707      * @param token The token targeted by the call.
708      * @param data The call data (encoded using abi.encode or one of its variants).
709      */
710     function _callOptionalReturn(IERC20 token, bytes memory data) private {
711         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
712         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
713         // the target address contains contract code and also asserts for success in the low-level call.
714 
715         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
716         if (returndata.length > 0) { // Return data is optional
717             // solhint-disable-next-line max-line-length
718             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
719         }
720     }
721 }
722 
723 // File: contracts\VestedEscrow.sol
724 
725 pragma solidity 0.6.12;
726 
727 /*
728 Rewrite of Curve Finance's Vested Escrow
729 found at https://github.com/curvefi/curve-dao-contracts/blob/master/contracts/VestingEscrow.vy
730 
731 Changes:
732 - no disable methods
733 - only one fund admin
734 - add claim and stake
735 */
736 
737 contract VestedEscrow is ReentrancyGuard{
738     using SafeMath for uint256;
739     using SafeERC20 for IERC20;
740 
741     IERC20 public rewardToken;
742     address public admin;
743     address public fundAdmin;
744     address public stakeContract;
745     
746     uint256 public startTime;
747     uint256 public endTime;
748     uint256 public totalTime;
749     uint256 public initialLockedSupply;
750     uint256 public unallocatedSupply;
751 
752     mapping(address => uint256) public initialLocked;
753     mapping(address => uint256) public totalClaimed;
754 
755     address[] public extraRewards;
756 
757     event Fund(address indexed recipient, uint256 reward);
758     event Claim(address indexed user, uint256 amount);
759 
760     constructor(
761         address rewardToken_,
762         uint256 starttime_,
763         uint256 endtime_,
764         address stakeContract_,
765         address fundAdmin_
766     ) public {
767         require(starttime_ >= block.timestamp,"start must be future");
768         require(endtime_ > starttime_,"end must be greater");
769 
770         rewardToken = IERC20(rewardToken_);
771         startTime = starttime_;
772         endTime = endtime_;
773         totalTime = endTime.sub(startTime);
774         admin = msg.sender;
775         fundAdmin = fundAdmin_;
776         stakeContract = stakeContract_;
777     }
778 
779     function setAdmin(address _admin) external {
780         require(msg.sender == admin, "!auth");
781         admin = _admin;
782     }
783 
784     function setFundAdmin(address _fundadmin) external {
785         require(msg.sender == admin, "!auth");
786         fundAdmin = _fundadmin;
787     }
788 
789     function addTokens(uint256 _amount) external returns(bool){
790         require(msg.sender == admin, "!auth");
791 
792         rewardToken.safeTransferFrom(msg.sender, address(this), _amount);
793         unallocatedSupply = unallocatedSupply.add(_amount);
794         return true;
795     }
796     
797     function fund(address[] calldata _recipient, uint256[] calldata _amount) external nonReentrant returns(bool){
798         require(msg.sender == fundAdmin || msg.sender == admin, "!auth");
799 
800         uint256 totalAmount = 0;
801         for(uint256 i = 0; i < _recipient.length; i++){
802             uint256 amount = _amount[i];
803             initialLocked[_recipient[i]] = initialLocked[_recipient[i]].add(amount);
804             totalAmount = totalAmount.add(amount);
805             emit Fund(_recipient[i],amount);
806         }
807 
808         initialLockedSupply = initialLockedSupply.add(totalAmount);
809         unallocatedSupply = unallocatedSupply.sub(totalAmount);
810         return true;
811     }
812 
813     function _totalVestedOf(address _recipient, uint256 _time) internal view returns(uint256){
814         if(_time < startTime){
815             return 0;
816         }
817         uint256 locked = initialLocked[_recipient];
818         uint256 elapsed = _time.sub(startTime);
819         uint256 total = MathUtil.min(locked * elapsed / totalTime, locked );
820         return total;
821     }
822 
823     function _totalVested() internal view returns(uint256){
824         uint256 _time = block.timestamp;
825         if(_time < startTime){
826             return 0;
827         }
828         uint256 locked = initialLockedSupply;
829         uint256 elapsed = _time.sub(startTime);
830         uint256 total = MathUtil.min(locked * elapsed / totalTime, locked );
831         return total;
832     }
833 
834     function vestedSupply() external view returns(uint256){
835         return _totalVested();
836     }
837 
838     function lockedSupply() external view returns(uint256){
839         return initialLockedSupply.sub(_totalVested());
840     }
841 
842     function vestedOf(address _recipient) external view returns(uint256){
843         return _totalVestedOf(_recipient, block.timestamp);
844     }
845 
846     function balanceOf(address _recipient) external view returns(uint256){
847         uint256 vested = _totalVestedOf(_recipient, block.timestamp);
848         return vested.sub(totalClaimed[_recipient]);
849     }
850 
851     function lockedOf(address _recipient) external view returns(uint256){
852         uint256 vested = _totalVestedOf(_recipient, block.timestamp);
853         return initialLocked[_recipient].sub(vested);
854     }
855 
856     function claim(address _recipient) public nonReentrant{
857         uint256 vested = _totalVestedOf(_recipient, block.timestamp);
858         uint256 claimable = vested.sub(totalClaimed[_recipient]);
859 
860         totalClaimed[_recipient] = totalClaimed[_recipient].add(claimable);
861         rewardToken.safeTransfer(_recipient, claimable);
862 
863         emit Claim(msg.sender, claimable);
864     }
865 
866     function claim() external{
867         claim(msg.sender);
868     }
869 
870     function claimAndStake(address _recipient) internal nonReentrant{
871         require(stakeContract != address(0),"no staking contract");
872         require(IRewards(stakeContract).stakingToken() == address(rewardToken),"stake token mismatch");
873         
874         uint256 vested = _totalVestedOf(_recipient, block.timestamp);
875         uint256 claimable = vested.sub(totalClaimed[_recipient]);
876 
877         totalClaimed[_recipient] = totalClaimed[_recipient].add(claimable);
878         
879         rewardToken.safeApprove(stakeContract,0);
880         rewardToken.safeApprove(stakeContract,claimable);
881         IRewards(stakeContract).stakeFor(_recipient, claimable);
882 
883         emit Claim(_recipient, claimable);
884     }
885 
886     function claimAndStake() external{
887         claimAndStake(msg.sender);
888     }
889 }