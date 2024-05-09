1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 pragma solidity 0.7.6;
3 
4 library Address {
5     /**
6      * @dev Returns true if `account` is a contract.
7      *
8      * [IMPORTANT]
9      * ====
10      * It is unsafe to assume that an address for which this function returns
11      * false is an externally-owned account (EOA) and not a contract.
12      *
13      * Among others, `isContract` will return false for the following
14      * types of addresses:
15      *
16      *  - an externally-owned account
17      *  - a contract in construction
18      *  - an address where a contract will be created
19      *  - an address where a contract lived, but was destroyed
20      * ====
21      */
22     function isContract(address account) internal view returns (bool) {
23         // This method relies on extcodesize, which returns 0 for contracts in
24         // construction, since the code is only stored at the end of the
25         // constructor execution.
26 
27         uint size;
28         // solhint-disable-next-line no-inline-assembly
29         assembly {
30             size := extcodesize(account)
31         }
32         return size > 0;
33     }
34 
35     /**
36      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
37      * `recipient`, forwarding all available gas and reverting on errors.
38      *
39      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
40      * of certain opcodes, possibly making contracts go over the 2300 gas limit
41      * imposed by `transfer`, making them unable to receive funds via
42      * `transfer`. {sendValue} removes this limitation.
43      *
44      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
45      *
46      * IMPORTANT: because control is transferred to `recipient`, care must be
47      * taken to not create reentrancy vulnerabilities. Consider using
48      * {ReentrancyGuard} or the
49      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
50      */
51     function sendValue(address payable recipient, uint amount) internal {
52         require(address(this).balance >= amount, "Address: insufficient balance");
53 
54         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
55         (bool success, ) = recipient.call{value: amount}("");
56         require(success, "Address: unable to send value, recipient may have reverted");
57     }
58 
59     /**
60      * @dev Performs a Solidity function call using a low level `call`. A
61      * plain`call` is an unsafe replacement for a function call: use this
62      * function instead.
63      *
64      * If `target` reverts with a revert reason, it is bubbled up by this
65      * function (like regular Solidity function calls).
66      *
67      * Returns the raw returned data. To convert to the expected return value,
68      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
69      *
70      * Requirements:
71      *
72      * - `target` must be a contract.
73      * - calling `target` with `data` must not revert.
74      *
75      * _Available since v3.1._
76      */
77     function functionCall(address target, bytes memory data)
78         internal
79         returns (bytes memory)
80     {
81         return functionCall(target, data, "Address: low-level call failed");
82     }
83 
84     /**
85      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
86      * `errorMessage` as a fallback revert reason when `target` reverts.
87      *
88      * _Available since v3.1._
89      */
90     function functionCall(
91         address target,
92         bytes memory data,
93         string memory errorMessage
94     ) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, 0, errorMessage);
96     }
97 
98     /**
99      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
100      * but also transferring `value` wei to `target`.
101      *
102      * Requirements:
103      *
104      * - the calling contract must have an ETH balance of at least `value`.
105      * - the called Solidity function must be `payable`.
106      *
107      * _Available since v3.1._
108      */
109     function functionCallWithValue(
110         address target,
111         bytes memory data,
112         uint value
113     ) internal returns (bytes memory) {
114         return
115             functionCallWithValue(
116                 target,
117                 data,
118                 value,
119                 "Address: low-level call with value failed"
120             );
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
125      * with `errorMessage` as a fallback revert reason when `target` reverts.
126      *
127      * _Available since v3.1._
128      */
129     function functionCallWithValue(
130         address target,
131         bytes memory data,
132         uint value,
133         string memory errorMessage
134     ) internal returns (bytes memory) {
135         require(
136             address(this).balance >= value,
137             "Address: insufficient balance for call"
138         );
139         require(isContract(target), "Address: call to non-contract");
140 
141         // solhint-disable-next-line avoid-low-level-calls
142         (bool success, bytes memory returndata) = target.call{value: value}(data);
143         return _verifyCallResult(success, returndata, errorMessage);
144     }
145 
146     /**
147      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
148      * but performing a static call.
149      *
150      * _Available since v3.3._
151      */
152     function functionStaticCall(address target, bytes memory data)
153         internal
154         view
155         returns (bytes memory)
156     {
157         return
158             functionStaticCall(target, data, "Address: low-level static call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a static call.
164      *
165      * _Available since v3.3._
166      */
167     function functionStaticCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal view returns (bytes memory) {
172         require(isContract(target), "Address: static call to non-contract");
173 
174         // solhint-disable-next-line avoid-low-level-calls
175         (bool success, bytes memory returndata) = target.staticcall(data);
176         return _verifyCallResult(success, returndata, errorMessage);
177     }
178 
179     /**
180      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
181      * but performing a delegate call.
182      *
183      * _Available since v3.4._
184      */
185     function functionDelegateCall(address target, bytes memory data)
186         internal
187         returns (bytes memory)
188     {
189         return
190             functionDelegateCall(
191                 target,
192                 data,
193                 "Address: low-level delegate call failed"
194             );
195     }
196 
197     /**
198      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
199      * but performing a delegate call.
200      *
201      * _Available since v3.4._
202      */
203     function functionDelegateCall(
204         address target,
205         bytes memory data,
206         string memory errorMessage
207     ) internal returns (bytes memory) {
208         require(isContract(target), "Address: delegate call to non-contract");
209 
210         // solhint-disable-next-line avoid-low-level-calls
211         (bool success, bytes memory returndata) = target.delegatecall(data);
212         return _verifyCallResult(success, returndata, errorMessage);
213     }
214 
215     function _verifyCallResult(
216         bool success,
217         bytes memory returndata,
218         string memory errorMessage
219     ) private pure returns (bytes memory) {
220         if (success) {
221             return returndata;
222         } else {
223             // Look for revert reason and bubble it up if present
224             if (returndata.length > 0) {
225                 // The easiest way to bubble the revert reason is using memory via assembly
226 
227                 // solhint-disable-next-line no-inline-assembly
228                 assembly {
229                     let returndata_size := mload(returndata)
230                     revert(add(32, returndata), returndata_size)
231                 }
232             } else {
233                 revert(errorMessage);
234             }
235         }
236     }
237 }
238 
239 interface BaseRewardPool {
240     function balanceOf(address _account) external view returns (uint);
241 
242     function getReward(address _account, bool _claimExtras) external returns (bool);
243 
244     function withdrawAndUnwrap(uint amount, bool claim) external returns (bool);
245 }
246 
247 interface Booster {
248     function poolInfo(uint _pid)
249         external
250         view
251         returns (
252             address lptoken,
253             address token,
254             address gauge,
255             address crvRewards,
256             address stash,
257             bool shutdown
258         );
259 
260     function deposit(
261         uint _pid,
262         uint _amount,
263         bool _stake
264     ) external returns (bool);
265 
266     function withdraw(uint _pid, uint _amount) external returns (bool);
267 }
268 
269 interface IERC20 {
270     /**
271      * @dev Returns the amount of tokens in existence.
272      */
273     function totalSupply() external view returns (uint);
274 
275     /**
276      * @dev Returns the amount of tokens owned by `account`.
277      */
278     function balanceOf(address account) external view returns (uint);
279 
280     /**
281      * @dev Moves `amount` tokens from the caller's account to `recipient`.
282      *
283      * Returns a boolean value indicating whether the operation succeeded.
284      *
285      * Emits a {Transfer} event.
286      */
287     function transfer(address recipient, uint amount) external returns (bool);
288 
289     /**
290      * @dev Returns the remaining number of tokens that `spender` will be
291      * allowed to spend on behalf of `owner` through {transferFrom}. This is
292      * zero by default.
293      *
294      * This value changes when {approve} or {transferFrom} are called.
295      */
296     function allowance(address owner, address spender) external view returns (uint);
297 
298     /**
299      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
300      *
301      * Returns a boolean value indicating whether the operation succeeded.
302      *
303      * IMPORTANT: Beware that changing an allowance with this method brings the risk
304      * that someone may use both the old and the new allowance by unfortunate
305      * transaction ordering. One possible solution to mitigate this race
306      * condition is to first reduce the spender's allowance to 0 and set the
307      * desired value afterwards:
308      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
309      *
310      * Emits an {Approval} event.
311      */
312     function approve(address spender, uint amount) external returns (bool);
313 
314     /**
315      * @dev Moves `amount` tokens from `sender` to `recipient` using the
316      * allowance mechanism. `amount` is then deducted from the caller's
317      * allowance.
318      *
319      * Returns a boolean value indicating whether the operation succeeded.
320      *
321      * Emits a {Transfer} event.
322      */
323     function transferFrom(
324         address sender,
325         address recipient,
326         uint amount
327     ) external returns (bool);
328 
329     /**
330      * @dev Emitted when `value` tokens are moved from one account (`from`) to
331      * another (`to`).
332      *
333      * Note that `value` may be zero.
334      */
335     event Transfer(address indexed from, address indexed to, uint value);
336 
337     /**
338      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
339      * a call to {approve}. `value` is the new allowance.
340      */
341     event Approval(address indexed owner, address indexed spender, uint value);
342 }
343 
344 interface IEthFundManager {
345     function token() external view returns (address);
346 
347     function borrow(uint amount) external returns (uint);
348 
349     function repay(uint amount) external payable returns (uint);
350 
351     function report(uint gain, uint loss) external payable;
352 
353     function getDebt(address strategy) external view returns (uint);
354 }
355 
356 library SafeERC20 {
357     using SafeMath for uint;
358     using Address for address;
359 
360     function safeTransfer(
361         IERC20 token,
362         address to,
363         uint value
364     ) internal {
365         _callOptionalReturn(
366             token,
367             abi.encodeWithSelector(token.transfer.selector, to, value)
368         );
369     }
370 
371     function safeTransferFrom(
372         IERC20 token,
373         address from,
374         address to,
375         uint value
376     ) internal {
377         _callOptionalReturn(
378             token,
379             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
380         );
381     }
382 
383     /**
384      * @dev Deprecated. This function has issues similar to the ones found in
385      * {IERC20-approve}, and its usage is discouraged.
386      *
387      * Whenever possible, use {safeIncreaseAllowance} and
388      * {safeDecreaseAllowance} instead.
389      */
390     function safeApprove(
391         IERC20 token,
392         address spender,
393         uint value
394     ) internal {
395         // safeApprove should only be called when setting an initial allowance,
396         // or when resetting it to zero. To increase and decrease it, use
397         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
398         // solhint-disable-next-line max-line-length
399         require(
400             (value == 0) || (token.allowance(address(this), spender) == 0),
401             "SafeERC20: approve from non-zero to non-zero allowance"
402         );
403         _callOptionalReturn(
404             token,
405             abi.encodeWithSelector(token.approve.selector, spender, value)
406         );
407     }
408 
409     function safeIncreaseAllowance(
410         IERC20 token,
411         address spender,
412         uint value
413     ) internal {
414         uint newAllowance = token.allowance(address(this), spender).add(value);
415         _callOptionalReturn(
416             token,
417             abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
418         );
419     }
420 
421     function safeDecreaseAllowance(
422         IERC20 token,
423         address spender,
424         uint value
425     ) internal {
426         uint newAllowance = token.allowance(address(this), spender).sub(
427             value,
428             "SafeERC20: decreased allowance below zero"
429         );
430         _callOptionalReturn(
431             token,
432             abi.encodeWithSelector(token.approve.selector, spender, newAllowance)
433         );
434     }
435 
436     /**
437      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
438      * on the return value: the return value is optional (but if data is returned, it must not be false).
439      * @param token The token targeted by the call.
440      * @param data The call data (encoded using abi.encode or one of its variants).
441      */
442     function _callOptionalReturn(IERC20 token, bytes memory data) private {
443         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
444         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
445         // the target address contains contract code and also asserts for success in the low-level call.
446 
447         bytes memory returndata = address(token).functionCall(
448             data,
449             "SafeERC20: low-level call failed"
450         );
451         if (returndata.length > 0) {
452             // Return data is optional
453             // solhint-disable-next-line max-line-length
454             require(
455                 abi.decode(returndata, (bool)),
456                 "SafeERC20: ERC20 operation did not succeed"
457             );
458         }
459     }
460 }
461 
462 library SafeMath {
463     /**
464      * @dev Returns the addition of two unsigned integers, with an overflow flag.
465      *
466      * _Available since v3.4._
467      */
468     function tryAdd(uint a, uint b) internal pure returns (bool, uint) {
469         uint c = a + b;
470         if (c < a) return (false, 0);
471         return (true, c);
472     }
473 
474     /**
475      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
476      *
477      * _Available since v3.4._
478      */
479     function trySub(uint a, uint b) internal pure returns (bool, uint) {
480         if (b > a) return (false, 0);
481         return (true, a - b);
482     }
483 
484     /**
485      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
486      *
487      * _Available since v3.4._
488      */
489     function tryMul(uint a, uint b) internal pure returns (bool, uint) {
490         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
491         // benefit is lost if 'b' is also tested.
492         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
493         if (a == 0) return (true, 0);
494         uint c = a * b;
495         if (c / a != b) return (false, 0);
496         return (true, c);
497     }
498 
499     /**
500      * @dev Returns the division of two unsigned integers, with a division by zero flag.
501      *
502      * _Available since v3.4._
503      */
504     function tryDiv(uint a, uint b) internal pure returns (bool, uint) {
505         if (b == 0) return (false, 0);
506         return (true, a / b);
507     }
508 
509     /**
510      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
511      *
512      * _Available since v3.4._
513      */
514     function tryMod(uint a, uint b) internal pure returns (bool, uint) {
515         if (b == 0) return (false, 0);
516         return (true, a % b);
517     }
518 
519     /**
520      * @dev Returns the addition of two unsigned integers, reverting on
521      * overflow.
522      *
523      * Counterpart to Solidity's `+` operator.
524      *
525      * Requirements:
526      *
527      * - Addition cannot overflow.
528      */
529     function add(uint a, uint b) internal pure returns (uint) {
530         uint c = a + b;
531         require(c >= a, "SafeMath: addition overflow");
532         return c;
533     }
534 
535     /**
536      * @dev Returns the subtraction of two unsigned integers, reverting on
537      * overflow (when the result is negative).
538      *
539      * Counterpart to Solidity's `-` operator.
540      *
541      * Requirements:
542      *
543      * - Subtraction cannot overflow.
544      */
545     function sub(uint a, uint b) internal pure returns (uint) {
546         require(b <= a, "SafeMath: subtraction overflow");
547         return a - b;
548     }
549 
550     /**
551      * @dev Returns the multiplication of two unsigned integers, reverting on
552      * overflow.
553      *
554      * Counterpart to Solidity's `*` operator.
555      *
556      * Requirements:
557      *
558      * - Multiplication cannot overflow.
559      */
560     function mul(uint a, uint b) internal pure returns (uint) {
561         if (a == 0) return 0;
562         uint c = a * b;
563         require(c / a == b, "SafeMath: multiplication overflow");
564         return c;
565     }
566 
567     /**
568      * @dev Returns the integer division of two unsigned integers, reverting on
569      * division by zero. The result is rounded towards zero.
570      *
571      * Counterpart to Solidity's `/` operator. Note: this function uses a
572      * `revert` opcode (which leaves remaining gas untouched) while Solidity
573      * uses an invalid opcode to revert (consuming all remaining gas).
574      *
575      * Requirements:
576      *
577      * - The divisor cannot be zero.
578      */
579     function div(uint a, uint b) internal pure returns (uint) {
580         require(b > 0, "SafeMath: division by zero");
581         return a / b;
582     }
583 
584     /**
585      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
586      * reverting when dividing by zero.
587      *
588      * Counterpart to Solidity's `%` operator. This function uses a `revert`
589      * opcode (which leaves remaining gas untouched) while Solidity uses an
590      * invalid opcode to revert (consuming all remaining gas).
591      *
592      * Requirements:
593      *
594      * - The divisor cannot be zero.
595      */
596     function mod(uint a, uint b) internal pure returns (uint) {
597         require(b > 0, "SafeMath: modulo by zero");
598         return a % b;
599     }
600 
601     /**
602      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
603      * overflow (when the result is negative).
604      *
605      * CAUTION: This function is deprecated because it requires allocating memory for the error
606      * message unnecessarily. For custom revert reasons use {trySub}.
607      *
608      * Counterpart to Solidity's `-` operator.
609      *
610      * Requirements:
611      *
612      * - Subtraction cannot overflow.
613      */
614     function sub(
615         uint a,
616         uint b,
617         string memory errorMessage
618     ) internal pure returns (uint) {
619         require(b <= a, errorMessage);
620         return a - b;
621     }
622 
623     /**
624      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
625      * division by zero. The result is rounded towards zero.
626      *
627      * CAUTION: This function is deprecated because it requires allocating memory for the error
628      * message unnecessarily. For custom revert reasons use {tryDiv}.
629      *
630      * Counterpart to Solidity's `/` operator. Note: this function uses a
631      * `revert` opcode (which leaves remaining gas untouched) while Solidity
632      * uses an invalid opcode to revert (consuming all remaining gas).
633      *
634      * Requirements:
635      *
636      * - The divisor cannot be zero.
637      */
638     function div(
639         uint a,
640         uint b,
641         string memory errorMessage
642     ) internal pure returns (uint) {
643         require(b > 0, errorMessage);
644         return a / b;
645     }
646 
647     /**
648      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
649      * reverting with custom message when dividing by zero.
650      *
651      * CAUTION: This function is deprecated because it requires allocating memory for the error
652      * message unnecessarily. For custom revert reasons use {tryMod}.
653      *
654      * Counterpart to Solidity's `%` operator. This function uses a `revert`
655      * opcode (which leaves remaining gas untouched) while Solidity uses an
656      * invalid opcode to revert (consuming all remaining gas).
657      *
658      * Requirements:
659      *
660      * - The divisor cannot be zero.
661      */
662     function mod(
663         uint a,
664         uint b,
665         string memory errorMessage
666     ) internal pure returns (uint) {
667         require(b > 0, errorMessage);
668         return a % b;
669     }
670 }
671 
672 interface StableSwapStEth {
673     function get_virtual_price() external view returns (uint);
674 
675     /*
676     0 ETH
677     1 STETH
678     */
679     function balances(uint _index) external view returns (uint);
680 
681     function add_liquidity(uint[2] memory amounts, uint min) external payable;
682 
683     function remove_liquidity_one_coin(
684         uint _token_amount,
685         int128 i,
686         uint min_amount
687     ) external;
688 }
689 
690 abstract contract StrategyEth {
691     using SafeERC20 for IERC20;
692     using SafeMath for uint;
693 
694     event SetNextTimeLock(address nextTimeLock);
695     event AcceptTimeLock(address timeLock);
696     event SetAdmin(address admin);
697     event Authorize(address addr, bool authorized);
698     event SetTreasury(address treasury);
699     event SetFundManager(address fundManager);
700 
701     event ReceiveEth(address indexed sender, uint amount);
702     event Deposit(uint amount, uint borrowed);
703     event Repay(uint amount, uint repaid);
704     event Withdraw(uint amount, uint withdrawn, uint loss);
705     event ClaimRewards(uint profit);
706     event Skim(uint total, uint debt, uint profit);
707     event Report(uint gain, uint loss, uint free, uint total, uint debt);
708 
709     // Privilege - time lock >= admin >= authorized addresses
710     address public timeLock;
711     address public nextTimeLock;
712     address public admin;
713     address public treasury; // Profit is sent to this address
714 
715     // authorization other than time lock and admin
716     mapping(address => bool) public authorized;
717 
718     address internal constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
719     address public constant token = ETH;
720     IEthFundManager public fundManager;
721 
722     // Performance fee sent to treasury
723     uint public perfFee = 1000;
724     uint private constant PERF_FEE_CAP = 2000; // Upper limit to performance fee
725     uint internal constant PERF_FEE_MAX = 10000;
726 
727     bool public claimRewardsOnMigrate = true;
728 
729     constructor(address _fundManager, address _treasury) {
730         // Don't allow accidentally sending perf fee to 0 address
731         require(_treasury != address(0), "treasury = 0 address");
732 
733         timeLock = msg.sender;
734         admin = msg.sender;
735         treasury = _treasury;
736 
737         require(
738             IEthFundManager(_fundManager).token() == ETH,
739             "fund manager token != ETH"
740         );
741 
742         fundManager = IEthFundManager(_fundManager);
743     }
744 
745     receive() external payable {
746         emit ReceiveEth(msg.sender, msg.value);
747     }
748 
749     function _sendEth(address _to, uint _amount) internal {
750         require(_to != address(0), "to = 0 address");
751         (bool sent, ) = _to.call{value: _amount}("");
752         require(sent, "Send ETH failed");
753     }
754 
755     modifier onlyTimeLock() {
756         require(msg.sender == timeLock, "!time lock");
757         _;
758     }
759 
760     modifier onlyTimeLockOrAdmin() {
761         require(msg.sender == timeLock || msg.sender == admin, "!auth");
762         _;
763     }
764 
765     modifier onlyAuthorized() {
766         require(
767             msg.sender == timeLock || msg.sender == admin || authorized[msg.sender],
768             "!auth"
769         );
770         _;
771     }
772 
773     modifier onlyFundManager() {
774         require(msg.sender == address(fundManager), "!fund manager");
775         _;
776     }
777 
778     /*
779     @notice Set next time lock
780     @param _nextTimeLock Address of next time lock
781     @dev nextTimeLock can become timeLock by calling acceptTimeLock()
782     */
783     function setNextTimeLock(address _nextTimeLock) external onlyTimeLock {
784         // Allow next time lock to be zero address (cancel next time lock)
785         nextTimeLock = _nextTimeLock;
786         emit SetNextTimeLock(_nextTimeLock);
787     }
788 
789     /*
790     @notice Set timeLock to msg.sender
791     @dev msg.sender must be nextTimeLock
792     */
793     function acceptTimeLock() external {
794         require(msg.sender == nextTimeLock, "!next time lock");
795         timeLock = msg.sender;
796         nextTimeLock = address(0);
797         emit AcceptTimeLock(msg.sender);
798     }
799 
800     /*
801     @notice Set admin
802     @param _admin Address of admin
803     */
804     function setAdmin(address _admin) external onlyTimeLockOrAdmin {
805         require(_admin != address(0), "admin = 0 address");
806         admin = _admin;
807         emit SetAdmin(_admin);
808     }
809 
810     /*
811     @notice Set authorization
812     @param _addr Address to authorize
813     @param _authorized Boolean
814     */
815     function authorize(address _addr, bool _authorized) external onlyTimeLockOrAdmin {
816         require(_addr != address(0), "addr = 0 address");
817         authorized[_addr] = _authorized;
818         emit Authorize(_addr, _authorized);
819     }
820 
821     /*
822     @notice Set treasury
823     @param _treasury Address of treasury
824     */
825     function setTreasury(address _treasury) external onlyTimeLockOrAdmin {
826         // Don't allow accidentally sending perf fee to 0 address
827         require(_treasury != address(0), "treasury = 0 address");
828         treasury = _treasury;
829         emit SetTreasury(_treasury);
830     }
831 
832     /*
833     @notice Set performance fee
834     @param _fee Performance fee
835     */
836     function setPerfFee(uint _fee) external onlyTimeLockOrAdmin {
837         require(_fee <= PERF_FEE_CAP, "fee > cap");
838         perfFee = _fee;
839     }
840 
841     function setFundManager(address _fundManager) external onlyTimeLock {
842         require(
843             IEthFundManager(_fundManager).token() == ETH,
844             "new fund manager token != ETH"
845         );
846 
847         fundManager = IEthFundManager(_fundManager);
848 
849         emit SetFundManager(_fundManager);
850     }
851 
852     /*
853     @notice Set `claimRewardsOnMigrate`. If `false` skip call to `claimRewards`
854             when `migrate` is called.
855     @param _claimRewards Boolean to call or skip call to `claimRewards`
856     */
857     function setClaimRewardsOnMigrate(bool _claimRewards) external onlyTimeLockOrAdmin {
858         claimRewardsOnMigrate = _claimRewards;
859     }
860 
861     /*
862     @notice Returns approximate amount of ETH locked in this contract
863     @dev Output may vary depending on price pulled from external DeFi contracts
864     */
865     function totalAssets() external view virtual returns (uint);
866 
867     /*
868     @notice Deposit into strategy
869     @param _amount Amount of ETH to deposit from fund manager
870     @param _min Minimum amount borrowed
871     */
872     function deposit(uint _amount, uint _min) external virtual;
873 
874     /*
875     @notice Withdraw ETH from this contract
876     @dev Only callable by fund manager
877     @dev Returns current loss = debt to fund manager - total assets
878     */
879     function withdraw(uint _amount) external virtual returns (uint);
880 
881     /*
882     @notice Repay fund manager
883     @param _amount Amount of ETH to repay to fund manager
884     @param _min Minimum amount repaid
885     @dev Call report after this to report any loss
886     */
887     function repay(uint _amount, uint _min) external virtual;
888 
889     /*
890     @notice Claim any reward tokens, sell for ETH
891     @param _minProfit Minumum amount of ETH to gain from selling rewards
892     */
893     function claimRewards(uint _minProfit) external virtual;
894 
895     /*
896     @notice Free up any profit over debt
897     */
898     function skim() external virtual;
899 
900     /*
901     @notice Report gain or loss back to fund manager
902     @param _minTotal Minimum value of total assets.
903                Used to protect against price manipulation.
904     @param _maxTotal Maximum value of total assets Used
905                Used to protect against price manipulation.  
906     */
907     function report(uint _minTotal, uint _maxTotal) external virtual;
908 
909     /*
910     @notice Claim rewards, skim and report
911     @param _minProfit Minumum amount of ETH to gain from selling rewards
912     @param _minTotal Minimum value of total assets.
913                Used to protect against price manipulation.
914     @param _maxTotal Maximum value of total assets Used
915                Used to protect against price manipulation.  
916     */
917     function harvest(
918         uint _minProfit,
919         uint _minTotal,
920         uint _maxTotal
921     ) external virtual;
922 
923     /*
924     @notice Migrate to new version of this strategy
925     @param _strategy Address of new strategy
926     @dev Only callable by fund manager
927     */
928     function migrate(address payable _strategy) external virtual;
929 
930     /*
931     @notice Transfer token accidentally sent here back to admin
932     @param _token Address of token to transfer
933     */
934     function sweep(address _token) external virtual;
935 }
936 
937 interface UniswapV2Router {
938     function swapExactTokensForTokens(
939         uint amountIn,
940         uint amountOutMin,
941         address[] calldata path,
942         address to,
943         uint deadline
944     ) external returns (uint[] memory amounts);
945 
946     function swapExactTokensForETH(
947         uint amountIn,
948         uint amountOutMin,
949         address[] calldata path,
950         address to,
951         uint deadline
952     ) external returns (uint[] memory amounts);
953 }
954 
955 contract StrategyConvexStEth is StrategyEth {
956     using SafeERC20 for IERC20;
957     using SafeMath for uint;
958 
959     // Uniswap and Sushiswap //
960     // UNISWAP = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
961     // SUSHISWAP = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;
962     address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
963     uint private constant NUM_REWARDS = 3;
964     // address of DEX (uniswap or sushiswap) to use for selling reward tokens
965     // CRV, CVX, LDO
966     address[NUM_REWARDS] public dex;
967 
968     address private constant CRV = 0xD533a949740bb3306d119CC777fa900bA034cd52;
969     address private constant CVX = 0x4e3FBD56CD56c3e72c1403e103b45Db9da5B9D2B;
970     address private constant LDO = 0x5A98FcBEA516Cf06857215779Fd812CA3beF1B32;
971 
972     // Solc 0.7 cannot create constant arrays
973     address[NUM_REWARDS] private REWARDS = [CRV, CVX, LDO];
974 
975     // Convex //
976     Booster private constant BOOSTER =
977         Booster(0xF403C135812408BFbE8713b5A23a04b3D48AAE31);
978     // pool id
979     uint private constant PID = 25;
980     BaseRewardPool private constant REWARD =
981         BaseRewardPool(0x0A760466E1B4621579a82a39CB56Dda2F4E70f03);
982     bool public shouldClaimExtras = true;
983 
984     // Curve //
985     // StableSwap StETH
986     StableSwapStEth private constant CURVE_POOL =
987         StableSwapStEth(0xDC24316b9AE028F1497c275EB9192a3Ea0f67022);
988     // LP token for curve pool (ETH / stETH)
989     IERC20 private constant CURVE_LP =
990         IERC20(0x06325440D014e39736583c165C2963BA99fAf14E);
991 
992     // prevent slippage from deposit / withdraw
993     uint public slip = 100;
994     uint private constant SLIP_MAX = 10000;
995 
996     /*
997     0 - ETH
998     1 - stETH
999     */
1000     uint private constant INDEX = 0; // index of token
1001 
1002     constructor(address _fundManager, address _treasury)
1003         StrategyEth(_fundManager, _treasury)
1004     {
1005         (address lptoken, , , address crvRewards, , ) = BOOSTER.poolInfo(PID);
1006         require(address(CURVE_LP) == lptoken, "curve pool lp != pool info lp");
1007         require(address(REWARD) == crvRewards, "reward != pool info reward");
1008 
1009         // deposit into BOOSTER
1010         CURVE_LP.safeApprove(address(BOOSTER), type(uint).max);
1011 
1012         _setDex(0, 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F); // CRV - sushiswap
1013         _setDex(1, 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F); // CVX - sushiswap
1014         _setDex(2, 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F); // LDO - sushiswap
1015     }
1016 
1017     function _setDex(uint _i, address _dex) private {
1018         IERC20 reward = IERC20(REWARDS[_i]);
1019 
1020         // disallow previous dex
1021         if (dex[_i] != address(0)) {
1022             reward.safeApprove(dex[_i], 0);
1023         }
1024 
1025         dex[_i] = _dex;
1026 
1027         // approve new dex
1028         reward.safeApprove(_dex, type(uint).max);
1029     }
1030 
1031     function setDex(uint _i, address _dex) external onlyTimeLock {
1032         require(_dex != address(0), "dex = 0 address");
1033         _setDex(_i, _dex);
1034     }
1035 
1036     /*
1037     @notice Set max slippage for deposit and withdraw from Curve pool
1038     @param _slip Max amount of slippage allowed
1039     */
1040     function setSlip(uint _slip) external onlyAuthorized {
1041         require(_slip <= SLIP_MAX, "slip > max");
1042         slip = _slip;
1043     }
1044 
1045     // @dev Claim extra rewards from Convex
1046     function setShouldClaimExtras(bool _shouldClaimExtras) external onlyAuthorized {
1047         shouldClaimExtras = _shouldClaimExtras;
1048     }
1049 
1050     function _totalAssets() private view returns (uint total) {
1051         /*
1052         s0 = shares in curve pool
1053         p0 = price per share of curve pool
1054         a = amount of ETH
1055 
1056         a = s0 * p0
1057         */
1058         // amount of Curve LP tokens in Convex
1059         uint lpBal = REWARD.balanceOf(address(this));
1060         // amount of ETH converted from Curve LP
1061         total = lpBal.mul(CURVE_POOL.get_virtual_price()) / 1e18;
1062 
1063         total = total.add(address(this).balance);
1064     }
1065 
1066     function totalAssets() external view override returns (uint) {
1067         return _totalAssets();
1068     }
1069 
1070     function _deposit() private {
1071         uint bal = address(this).balance;
1072         if (bal > 0) {
1073             uint[2] memory amounts;
1074             amounts[INDEX] = bal;
1075             /*
1076             shares = ETH amount * 1e18 / price per share
1077             */
1078             uint pricePerShare = CURVE_POOL.get_virtual_price();
1079             uint shares = bal.mul(1e18).div(pricePerShare);
1080             uint min = shares.mul(SLIP_MAX - slip) / SLIP_MAX;
1081 
1082             CURVE_POOL.add_liquidity{value: bal}(amounts, min);
1083         }
1084 
1085         uint lpBal = CURVE_LP.balanceOf(address(this));
1086         if (lpBal > 0) {
1087             require(BOOSTER.deposit(PID, lpBal, true), "deposit failed");
1088         }
1089     }
1090 
1091     function deposit(uint _amount, uint _min) external override onlyAuthorized {
1092         require(_amount > 0, "deposit = 0");
1093 
1094         uint borrowed = fundManager.borrow(_amount);
1095         require(borrowed >= _min, "borrowed < min");
1096 
1097         _deposit();
1098         emit Deposit(_amount, borrowed);
1099     }
1100 
1101     function _calcSharesToWithdraw(
1102         uint _amount,
1103         uint _total,
1104         uint _totalShares
1105     ) private pure returns (uint) {
1106         /*
1107         calculate shares to withdraw
1108 
1109         a = amount of ETH to withdraw
1110         T = total amount of ETH locked in external liquidity pool
1111         s = shares to withdraw
1112         P = total shares deposited into external liquidity pool
1113 
1114         a / T = s / P
1115         s = a / T * P
1116         */
1117         if (_total > 0) {
1118             // avoid rounding errors and cap shares to be <= total shares
1119             if (_amount >= _total) {
1120                 return _totalShares;
1121             }
1122             return _amount.mul(_totalShares) / _total;
1123         }
1124         return 0;
1125     }
1126 
1127     function _withdraw(uint _amount) private returns (uint) {
1128         uint bal = address(this).balance;
1129         if (_amount <= bal) {
1130             return _amount;
1131         }
1132 
1133         uint total = _totalAssets();
1134 
1135         if (_amount >= total) {
1136             _amount = total;
1137         }
1138 
1139         uint need = _amount - bal;
1140         uint totalShares = REWARD.balanceOf(address(this));
1141         // total assets is always >= bal
1142         uint shares = _calcSharesToWithdraw(need, total - bal, totalShares);
1143 
1144         // withdraw from Convex
1145         if (shares > 0) {
1146             // true = claim CRV
1147             require(REWARD.withdrawAndUnwrap(shares, false), "reward withdraw failed");
1148         }
1149 
1150         // withdraw from Curve
1151         uint lpBal = CURVE_LP.balanceOf(address(this));
1152         if (shares > lpBal) {
1153             shares = lpBal;
1154         }
1155 
1156         if (shares > 0) {
1157             uint min = need.mul(SLIP_MAX - slip) / SLIP_MAX;
1158             CURVE_POOL.remove_liquidity_one_coin(shares, int128(INDEX), min);
1159         }
1160 
1161         uint balAfter = address(this).balance;
1162         if (balAfter < _amount) {
1163             return balAfter;
1164         }
1165         // balAfter >= _amount >= total
1166         // requested to withdraw all so return balAfter
1167         if (_amount >= total) {
1168             return balAfter;
1169         }
1170         // requested withdraw < all
1171         return _amount;
1172     }
1173 
1174     function withdraw(uint _amount)
1175         external
1176         override
1177         onlyFundManager
1178         returns (uint loss)
1179     {
1180         require(_amount > 0, "withdraw = 0");
1181 
1182         // availabe <= _amount
1183         uint available = _withdraw(_amount);
1184 
1185         uint debt = fundManager.getDebt(address(this));
1186         uint total = _totalAssets();
1187         if (debt > total) {
1188             loss = debt - total;
1189         }
1190 
1191         if (available > 0) {
1192             _sendEth(msg.sender, available);
1193         }
1194 
1195         emit Withdraw(_amount, available, loss);
1196     }
1197 
1198     function repay(uint _amount, uint _min) external override onlyAuthorized {
1199         require(_amount > 0, "repay = 0");
1200         // availabe <= _amount
1201         uint available = _withdraw(_amount);
1202         uint repaid = fundManager.repay{value: available}(available);
1203         require(repaid >= _min, "repaid < min");
1204 
1205         emit Repay(_amount, repaid);
1206     }
1207 
1208     /*
1209     @dev Uniswap fails with zero address so no check is necessary here
1210     */
1211     function _swap(
1212         address _dex,
1213         address _tokenIn,
1214         uint _amount
1215     ) private {
1216         // create dynamic array with 2 elements
1217         address[] memory path = new address[](2);
1218         path[0] = _tokenIn;
1219         path[1] = WETH;
1220 
1221         UniswapV2Router(_dex).swapExactTokensForETH(
1222             _amount,
1223             1,
1224             path,
1225             address(this),
1226             block.timestamp
1227         );
1228     }
1229 
1230     function _claimRewards(uint _minProfit) private {
1231         // calculate profit = balance of ETH after - balance of ETH before
1232         uint diff = address(this).balance;
1233 
1234         require(
1235             REWARD.getReward(address(this), shouldClaimExtras),
1236             "get reward failed"
1237         );
1238 
1239         for (uint i = 0; i < NUM_REWARDS; i++) {
1240             uint rewardBal = IERC20(REWARDS[i]).balanceOf(address(this));
1241             if (rewardBal > 0) {
1242                 _swap(dex[i], REWARDS[i], rewardBal);
1243             }
1244         }
1245 
1246         diff = address(this).balance - diff;
1247         require(diff >= _minProfit, "profit < min");
1248 
1249         // transfer performance fee to treasury
1250         if (diff > 0) {
1251             uint fee = diff.mul(perfFee) / PERF_FEE_MAX;
1252             if (fee > 0) {
1253                 _sendEth(treasury, fee);
1254                 diff = diff.sub(fee);
1255             }
1256         }
1257 
1258         emit ClaimRewards(diff);
1259     }
1260 
1261     function claimRewards(uint _minProfit) external override onlyAuthorized {
1262         _claimRewards(_minProfit);
1263     }
1264 
1265     function _skim() private {
1266         uint total = _totalAssets();
1267         uint debt = fundManager.getDebt(address(this));
1268         require(total > debt, "total <= debt");
1269 
1270         uint profit = total - debt;
1271         // reassign to actual amount withdrawn
1272         profit = _withdraw(profit);
1273 
1274         emit Skim(total, debt, profit);
1275     }
1276 
1277     function skim() external override onlyAuthorized {
1278         _skim();
1279     }
1280 
1281     function _report(uint _minTotal, uint _maxTotal) private {
1282         uint total = _totalAssets();
1283         require(total >= _minTotal, "total < min");
1284         require(total <= _maxTotal, "total > max");
1285 
1286         uint gain = 0;
1287         uint loss = 0;
1288         uint free = 0; // balance of ETH
1289         uint debt = fundManager.getDebt(address(this));
1290         if (total > debt) {
1291             gain = total - debt;
1292 
1293             free = address(this).balance;
1294             if (gain > free) {
1295                 gain = free;
1296             }
1297         } else {
1298             loss = debt - total;
1299         }
1300 
1301         if (gain > 0 || loss > 0) {
1302             fundManager.report{value: gain}(gain, loss);
1303         }
1304 
1305         emit Report(gain, loss, free, total, debt);
1306     }
1307 
1308     function report(uint _minTotal, uint _maxTotal) external override onlyAuthorized {
1309         _report(_minTotal, _maxTotal);
1310     }
1311 
1312     function harvest(
1313         uint _minProfit,
1314         uint _minTotal,
1315         uint _maxTotal
1316     ) external override onlyAuthorized {
1317         _claimRewards(_minProfit);
1318         _skim();
1319         _report(_minTotal, _maxTotal);
1320     }
1321 
1322     function migrate(address payable _strategy) external override onlyFundManager {
1323         StrategyEth strat = StrategyEth(_strategy);
1324         require(address(strat.token()) == ETH, "strategy token != ETH");
1325         require(
1326             address(strat.fundManager()) == address(fundManager),
1327             "strategy fund manager != fund manager"
1328         );
1329 
1330         if (claimRewardsOnMigrate) {
1331             _claimRewards(1);
1332         }
1333 
1334         uint bal = _withdraw(type(uint).max);
1335         // WARNING: may lose all ETH if sent to wrong address
1336         _sendEth(address(strat), bal);
1337     }
1338 
1339     /*
1340     @notice Transfer token accidentally sent here to admin
1341     @param _token Address of token to transfer
1342     */
1343     function sweep(address _token) external override onlyAuthorized {
1344         for (uint i = 0; i < NUM_REWARDS; i++) {
1345             require(_token != REWARDS[i], "protected token");
1346         }
1347         IERC20(_token).safeTransfer(admin, IERC20(_token).balanceOf(address(this)));
1348     }
1349 }