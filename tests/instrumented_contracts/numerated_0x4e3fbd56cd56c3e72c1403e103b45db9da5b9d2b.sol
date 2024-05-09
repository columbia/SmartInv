1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: contracts\Interfaces.sol
5 pragma solidity 0.6.12;
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
384 
385 pragma solidity >=0.6.0 <0.8.0;
386 
387 /**
388  * @dev Interface of the ERC20 standard as defined in the EIP.
389  */
390 interface IERC20 {
391     /**
392      * @dev Returns the amount of tokens in existence.
393      */
394     function totalSupply() external view returns (uint256);
395 
396     /**
397      * @dev Returns the amount of tokens owned by `account`.
398      */
399     function balanceOf(address account) external view returns (uint256);
400 
401     /**
402      * @dev Moves `amount` tokens from the caller's account to `recipient`.
403      *
404      * Returns a boolean value indicating whether the operation succeeded.
405      *
406      * Emits a {Transfer} event.
407      */
408     function transfer(address recipient, uint256 amount) external returns (bool);
409 
410     /**
411      * @dev Returns the remaining number of tokens that `spender` will be
412      * allowed to spend on behalf of `owner` through {transferFrom}. This is
413      * zero by default.
414      *
415      * This value changes when {approve} or {transferFrom} are called.
416      */
417     function allowance(address owner, address spender) external view returns (uint256);
418 
419     /**
420      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
421      *
422      * Returns a boolean value indicating whether the operation succeeded.
423      *
424      * IMPORTANT: Beware that changing an allowance with this method brings the risk
425      * that someone may use both the old and the new allowance by unfortunate
426      * transaction ordering. One possible solution to mitigate this race
427      * condition is to first reduce the spender's allowance to 0 and set the
428      * desired value afterwards:
429      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
430      *
431      * Emits an {Approval} event.
432      */
433     function approve(address spender, uint256 amount) external returns (bool);
434 
435     /**
436      * @dev Moves `amount` tokens from `sender` to `recipient` using the
437      * allowance mechanism. `amount` is then deducted from the caller's
438      * allowance.
439      *
440      * Returns a boolean value indicating whether the operation succeeded.
441      *
442      * Emits a {Transfer} event.
443      */
444     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
445 
446     /**
447      * @dev Emitted when `value` tokens are moved from one account (`from`) to
448      * another (`to`).
449      *
450      * Note that `value` may be zero.
451      */
452     event Transfer(address indexed from, address indexed to, uint256 value);
453 
454     /**
455      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
456      * a call to {approve}. `value` is the new allowance.
457      */
458     event Approval(address indexed owner, address indexed spender, uint256 value);
459 }
460 
461 // File: @openzeppelin\contracts\utils\Address.sol
462 
463 pragma solidity >=0.6.2 <0.8.0;
464 
465 /**
466  * @dev Collection of functions related to the address type
467  */
468 library Address {
469     /**
470      * @dev Returns true if `account` is a contract.
471      *
472      * [IMPORTANT]
473      * ====
474      * It is unsafe to assume that an address for which this function returns
475      * false is an externally-owned account (EOA) and not a contract.
476      *
477      * Among others, `isContract` will return false for the following
478      * types of addresses:
479      *
480      *  - an externally-owned account
481      *  - a contract in construction
482      *  - an address where a contract will be created
483      *  - an address where a contract lived, but was destroyed
484      * ====
485      */
486     function isContract(address account) internal view returns (bool) {
487         // This method relies on extcodesize, which returns 0 for contracts in
488         // construction, since the code is only stored at the end of the
489         // constructor execution.
490 
491         uint256 size;
492         // solhint-disable-next-line no-inline-assembly
493         assembly { size := extcodesize(account) }
494         return size > 0;
495     }
496 
497     /**
498      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
499      * `recipient`, forwarding all available gas and reverting on errors.
500      *
501      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
502      * of certain opcodes, possibly making contracts go over the 2300 gas limit
503      * imposed by `transfer`, making them unable to receive funds via
504      * `transfer`. {sendValue} removes this limitation.
505      *
506      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
507      *
508      * IMPORTANT: because control is transferred to `recipient`, care must be
509      * taken to not create reentrancy vulnerabilities. Consider using
510      * {ReentrancyGuard} or the
511      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
512      */
513     function sendValue(address payable recipient, uint256 amount) internal {
514         require(address(this).balance >= amount, "Address: insufficient balance");
515 
516         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
517         (bool success, ) = recipient.call{ value: amount }("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520 
521     /**
522      * @dev Performs a Solidity function call using a low level `call`. A
523      * plain`call` is an unsafe replacement for a function call: use this
524      * function instead.
525      *
526      * If `target` reverts with a revert reason, it is bubbled up by this
527      * function (like regular Solidity function calls).
528      *
529      * Returns the raw returned data. To convert to the expected return value,
530      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
531      *
532      * Requirements:
533      *
534      * - `target` must be a contract.
535      * - calling `target` with `data` must not revert.
536      *
537      * _Available since v3.1._
538      */
539     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
540       return functionCall(target, data, "Address: low-level call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
545      * `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
550         return functionCallWithValue(target, data, 0, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but also transferring `value` wei to `target`.
556      *
557      * Requirements:
558      *
559      * - the calling contract must have an ETH balance of at least `value`.
560      * - the called Solidity function must be `payable`.
561      *
562      * _Available since v3.1._
563      */
564     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
565         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
570      * with `errorMessage` as a fallback revert reason when `target` reverts.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
575         require(address(this).balance >= value, "Address: insufficient balance for call");
576         require(isContract(target), "Address: call to non-contract");
577 
578         // solhint-disable-next-line avoid-low-level-calls
579         (bool success, bytes memory returndata) = target.call{ value: value }(data);
580         return _verifyCallResult(success, returndata, errorMessage);
581     }
582 
583     /**
584      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
585      * but performing a static call.
586      *
587      * _Available since v3.3._
588      */
589     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
590         return functionStaticCall(target, data, "Address: low-level static call failed");
591     }
592 
593     /**
594      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
595      * but performing a static call.
596      *
597      * _Available since v3.3._
598      */
599     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
600         require(isContract(target), "Address: static call to non-contract");
601 
602         // solhint-disable-next-line avoid-low-level-calls
603         (bool success, bytes memory returndata) = target.staticcall(data);
604         return _verifyCallResult(success, returndata, errorMessage);
605     }
606 
607     /**
608      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
609      * but performing a delegate call.
610      *
611      * _Available since v3.4._
612      */
613     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
614         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
619      * but performing a delegate call.
620      *
621      * _Available since v3.4._
622      */
623     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
624         require(isContract(target), "Address: delegate call to non-contract");
625 
626         // solhint-disable-next-line avoid-low-level-calls
627         (bool success, bytes memory returndata) = target.delegatecall(data);
628         return _verifyCallResult(success, returndata, errorMessage);
629     }
630 
631     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
632         if (success) {
633             return returndata;
634         } else {
635             // Look for revert reason and bubble it up if present
636             if (returndata.length > 0) {
637                 // The easiest way to bubble the revert reason is using memory via assembly
638 
639                 // solhint-disable-next-line no-inline-assembly
640                 assembly {
641                     let returndata_size := mload(returndata)
642                     revert(add(32, returndata), returndata_size)
643                 }
644             } else {
645                 revert(errorMessage);
646             }
647         }
648     }
649 }
650 
651 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
652 
653 pragma solidity >=0.6.0 <0.8.0;
654 
655 
656 /**
657  * @title SafeERC20
658  * @dev Wrappers around ERC20 operations that throw on failure (when the token
659  * contract returns false). Tokens that return no value (and instead revert or
660  * throw on failure) are also supported, non-reverting calls are assumed to be
661  * successful.
662  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
663  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
664  */
665 library SafeERC20 {
666     using SafeMath for uint256;
667     using Address for address;
668 
669     function safeTransfer(IERC20 token, address to, uint256 value) internal {
670         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
671     }
672 
673     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
674         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
675     }
676 
677     /**
678      * @dev Deprecated. This function has issues similar to the ones found in
679      * {IERC20-approve}, and its usage is discouraged.
680      *
681      * Whenever possible, use {safeIncreaseAllowance} and
682      * {safeDecreaseAllowance} instead.
683      */
684     function safeApprove(IERC20 token, address spender, uint256 value) internal {
685         // safeApprove should only be called when setting an initial allowance,
686         // or when resetting it to zero. To increase and decrease it, use
687         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
688         // solhint-disable-next-line max-line-length
689         require((value == 0) || (token.allowance(address(this), spender) == 0),
690             "SafeERC20: approve from non-zero to non-zero allowance"
691         );
692         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
693     }
694 
695     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
696         uint256 newAllowance = token.allowance(address(this), spender).add(value);
697         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
698     }
699 
700     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
701         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
702         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
703     }
704 
705     /**
706      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
707      * on the return value: the return value is optional (but if data is returned, it must not be false).
708      * @param token The token targeted by the call.
709      * @param data The call data (encoded using abi.encode or one of its variants).
710      */
711     function _callOptionalReturn(IERC20 token, bytes memory data) private {
712         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
713         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
714         // the target address contains contract code and also asserts for success in the low-level call.
715 
716         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
717         if (returndata.length > 0) { // Return data is optional
718             // solhint-disable-next-line max-line-length
719             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
720         }
721     }
722 }
723 
724 // File: node_modules\@openzeppelin\contracts\utils\Context.sol
725 
726 pragma solidity >=0.6.0 <0.8.0;
727 
728 /*
729  * @dev Provides information about the current execution context, including the
730  * sender of the transaction and its data. While these are generally available
731  * via msg.sender and msg.data, they should not be accessed in such a direct
732  * manner, since when dealing with GSN meta-transactions the account sending and
733  * paying for execution may not be the actual sender (as far as an application
734  * is concerned).
735  *
736  * This contract is only required for intermediate, library-like contracts.
737  */
738 abstract contract Context {
739     function _msgSender() internal view virtual returns (address payable) {
740         return msg.sender;
741     }
742 
743     function _msgData() internal view virtual returns (bytes memory) {
744         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
745         return msg.data;
746     }
747 }
748 
749 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
750 
751 pragma solidity >=0.6.0 <0.8.0;
752 
753 
754 /**
755  * @dev Implementation of the {IERC20} interface.
756  *
757  * This implementation is agnostic to the way tokens are created. This means
758  * that a supply mechanism has to be added in a derived contract using {_mint}.
759  * For a generic mechanism see {ERC20PresetMinterPauser}.
760  *
761  * TIP: For a detailed writeup see our guide
762  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
763  * to implement supply mechanisms].
764  *
765  * We have followed general OpenZeppelin guidelines: functions revert instead
766  * of returning `false` on failure. This behavior is nonetheless conventional
767  * and does not conflict with the expectations of ERC20 applications.
768  *
769  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
770  * This allows applications to reconstruct the allowance for all accounts just
771  * by listening to said events. Other implementations of the EIP may not emit
772  * these events, as it isn't required by the specification.
773  *
774  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
775  * functions have been added to mitigate the well-known issues around setting
776  * allowances. See {IERC20-approve}.
777  */
778 contract ERC20 is Context, IERC20 {
779     using SafeMath for uint256;
780 
781     mapping (address => uint256) private _balances;
782 
783     mapping (address => mapping (address => uint256)) private _allowances;
784 
785     uint256 private _totalSupply;
786 
787     string private _name;
788     string private _symbol;
789     uint8 private _decimals;
790 
791     /**
792      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
793      * a default value of 18.
794      *
795      * To select a different value for {decimals}, use {_setupDecimals}.
796      *
797      * All three of these values are immutable: they can only be set once during
798      * construction.
799      */
800     constructor (string memory name_, string memory symbol_) public {
801         _name = name_;
802         _symbol = symbol_;
803         _decimals = 18;
804     }
805 
806     /**
807      * @dev Returns the name of the token.
808      */
809     function name() public view virtual returns (string memory) {
810         return _name;
811     }
812 
813     /**
814      * @dev Returns the symbol of the token, usually a shorter version of the
815      * name.
816      */
817     function symbol() public view virtual returns (string memory) {
818         return _symbol;
819     }
820 
821     /**
822      * @dev Returns the number of decimals used to get its user representation.
823      * For example, if `decimals` equals `2`, a balance of `505` tokens should
824      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
825      *
826      * Tokens usually opt for a value of 18, imitating the relationship between
827      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
828      * called.
829      *
830      * NOTE: This information is only used for _display_ purposes: it in
831      * no way affects any of the arithmetic of the contract, including
832      * {IERC20-balanceOf} and {IERC20-transfer}.
833      */
834     function decimals() public view virtual returns (uint8) {
835         return _decimals;
836     }
837 
838     /**
839      * @dev See {IERC20-totalSupply}.
840      */
841     function totalSupply() public view virtual override returns (uint256) {
842         return _totalSupply;
843     }
844 
845     /**
846      * @dev See {IERC20-balanceOf}.
847      */
848     function balanceOf(address account) public view virtual override returns (uint256) {
849         return _balances[account];
850     }
851 
852     /**
853      * @dev See {IERC20-transfer}.
854      *
855      * Requirements:
856      *
857      * - `recipient` cannot be the zero address.
858      * - the caller must have a balance of at least `amount`.
859      */
860     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
861         _transfer(_msgSender(), recipient, amount);
862         return true;
863     }
864 
865     /**
866      * @dev See {IERC20-allowance}.
867      */
868     function allowance(address owner, address spender) public view virtual override returns (uint256) {
869         return _allowances[owner][spender];
870     }
871 
872     /**
873      * @dev See {IERC20-approve}.
874      *
875      * Requirements:
876      *
877      * - `spender` cannot be the zero address.
878      */
879     function approve(address spender, uint256 amount) public virtual override returns (bool) {
880         _approve(_msgSender(), spender, amount);
881         return true;
882     }
883 
884     /**
885      * @dev See {IERC20-transferFrom}.
886      *
887      * Emits an {Approval} event indicating the updated allowance. This is not
888      * required by the EIP. See the note at the beginning of {ERC20}.
889      *
890      * Requirements:
891      *
892      * - `sender` and `recipient` cannot be the zero address.
893      * - `sender` must have a balance of at least `amount`.
894      * - the caller must have allowance for ``sender``'s tokens of at least
895      * `amount`.
896      */
897     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
898         _transfer(sender, recipient, amount);
899         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
900         return true;
901     }
902 
903     /**
904      * @dev Atomically increases the allowance granted to `spender` by the caller.
905      *
906      * This is an alternative to {approve} that can be used as a mitigation for
907      * problems described in {IERC20-approve}.
908      *
909      * Emits an {Approval} event indicating the updated allowance.
910      *
911      * Requirements:
912      *
913      * - `spender` cannot be the zero address.
914      */
915     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
916         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
917         return true;
918     }
919 
920     /**
921      * @dev Atomically decreases the allowance granted to `spender` by the caller.
922      *
923      * This is an alternative to {approve} that can be used as a mitigation for
924      * problems described in {IERC20-approve}.
925      *
926      * Emits an {Approval} event indicating the updated allowance.
927      *
928      * Requirements:
929      *
930      * - `spender` cannot be the zero address.
931      * - `spender` must have allowance for the caller of at least
932      * `subtractedValue`.
933      */
934     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
935         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
936         return true;
937     }
938 
939     /**
940      * @dev Moves tokens `amount` from `sender` to `recipient`.
941      *
942      * This is internal function is equivalent to {transfer}, and can be used to
943      * e.g. implement automatic token fees, slashing mechanisms, etc.
944      *
945      * Emits a {Transfer} event.
946      *
947      * Requirements:
948      *
949      * - `sender` cannot be the zero address.
950      * - `recipient` cannot be the zero address.
951      * - `sender` must have a balance of at least `amount`.
952      */
953     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
954         require(sender != address(0), "ERC20: transfer from the zero address");
955         require(recipient != address(0), "ERC20: transfer to the zero address");
956 
957         _beforeTokenTransfer(sender, recipient, amount);
958 
959         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
960         _balances[recipient] = _balances[recipient].add(amount);
961         emit Transfer(sender, recipient, amount);
962     }
963 
964     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
965      * the total supply.
966      *
967      * Emits a {Transfer} event with `from` set to the zero address.
968      *
969      * Requirements:
970      *
971      * - `to` cannot be the zero address.
972      */
973     function _mint(address account, uint256 amount) internal virtual {
974         require(account != address(0), "ERC20: mint to the zero address");
975 
976         _beforeTokenTransfer(address(0), account, amount);
977 
978         _totalSupply = _totalSupply.add(amount);
979         _balances[account] = _balances[account].add(amount);
980         emit Transfer(address(0), account, amount);
981     }
982 
983     /**
984      * @dev Destroys `amount` tokens from `account`, reducing the
985      * total supply.
986      *
987      * Emits a {Transfer} event with `to` set to the zero address.
988      *
989      * Requirements:
990      *
991      * - `account` cannot be the zero address.
992      * - `account` must have at least `amount` tokens.
993      */
994     function _burn(address account, uint256 amount) internal virtual {
995         require(account != address(0), "ERC20: burn from the zero address");
996 
997         _beforeTokenTransfer(account, address(0), amount);
998 
999         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
1000         _totalSupply = _totalSupply.sub(amount);
1001         emit Transfer(account, address(0), amount);
1002     }
1003 
1004     /**
1005      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1006      *
1007      * This internal function is equivalent to `approve`, and can be used to
1008      * e.g. set automatic allowances for certain subsystems, etc.
1009      *
1010      * Emits an {Approval} event.
1011      *
1012      * Requirements:
1013      *
1014      * - `owner` cannot be the zero address.
1015      * - `spender` cannot be the zero address.
1016      */
1017     function _approve(address owner, address spender, uint256 amount) internal virtual {
1018         require(owner != address(0), "ERC20: approve from the zero address");
1019         require(spender != address(0), "ERC20: approve to the zero address");
1020 
1021         _allowances[owner][spender] = amount;
1022         emit Approval(owner, spender, amount);
1023     }
1024 
1025     /**
1026      * @dev Sets {decimals} to a value other than the default one of 18.
1027      *
1028      * WARNING: This function should only be called from the constructor. Most
1029      * applications that interact with token contracts will not expect
1030      * {decimals} to ever change, and may work incorrectly if it does.
1031      */
1032     function _setupDecimals(uint8 decimals_) internal virtual {
1033         _decimals = decimals_;
1034     }
1035 
1036     /**
1037      * @dev Hook that is called before any transfer of tokens. This includes
1038      * minting and burning.
1039      *
1040      * Calling conditions:
1041      *
1042      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1043      * will be to transferred to `to`.
1044      * - when `from` is zero, `amount` tokens will be minted for `to`.
1045      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1046      * - `from` and `to` are never both zero.
1047      *
1048      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1049      */
1050     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
1051 }
1052 
1053 // File: contracts\Cvx.sol
1054 
1055 pragma solidity 0.6.12;
1056 
1057 
1058 contract ConvexToken is ERC20{
1059     using SafeERC20 for IERC20;
1060     using Address for address;
1061     using SafeMath for uint256;
1062 
1063     address public operator;
1064     address public vecrvProxy;
1065 
1066     uint256 public maxSupply = 100 * 1000000 * 1e18; //100mil
1067     uint256 public totalCliffs = 1000;
1068     uint256 public reductionPerCliff;
1069 
1070     constructor(address _proxy)
1071         public
1072         ERC20(
1073             "Convex Token",
1074             "CVX"
1075         )
1076     {
1077         operator = msg.sender;
1078         vecrvProxy = _proxy;
1079         reductionPerCliff = maxSupply.div(totalCliffs);
1080     }
1081 
1082     //get current operator off proxy incase there was a change
1083     function updateOperator() public {
1084         operator = IStaker(vecrvProxy).operator();
1085     }
1086     
1087     function mint(address _to, uint256 _amount) external {
1088         if(msg.sender != operator){
1089             //dont error just return. if a shutdown happens, rewards on old system
1090             //can still be claimed, just wont mint cvx
1091             return;
1092         }
1093 
1094         uint256 supply = totalSupply();
1095         if(supply == 0){
1096             //premine, one time only
1097             _mint(_to,_amount);
1098             //automatically switch operators
1099             updateOperator();
1100             return;
1101         }
1102         
1103         //use current supply to gauge cliff
1104         //this will cause a bit of overflow into the next cliff range
1105         //but should be within reasonable levels.
1106         //requires a max supply check though
1107         uint256 cliff = supply.div(reductionPerCliff);
1108         //mint if below total cliffs
1109         if(cliff < totalCliffs){
1110             //for reduction% take inverse of current cliff
1111             uint256 reduction = totalCliffs.sub(cliff);
1112             //reduce
1113             _amount = _amount.mul(reduction).div(totalCliffs);
1114 
1115             //supply cap check
1116             uint256 amtTillMax = maxSupply.sub(supply);
1117             if(_amount > amtTillMax){
1118                 _amount = amtTillMax;
1119             }
1120 
1121             //mint
1122             _mint(_to, _amount);
1123         }
1124     }
1125 
1126 }