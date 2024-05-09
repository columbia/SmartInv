1 pragma solidity 0.6.2;
2 
3 
4 
5 library SafeMath {
6     /**
7      * @dev Returns the addition of two unsigned integers, reverting on
8      * overflow.
9      *
10      * Counterpart to Solidity's `+` operator.
11      *
12      * Requirements:
13      *
14      * - Addition cannot overflow.
15      */
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19 
20         return c;
21     }
22 
23     /**
24      * @dev Returns the subtraction of two unsigned integers, reverting on
25      * overflow (when the result is negative).
26      *
27      * Counterpart to Solidity's `-` operator.
28      *
29      * Requirements:
30      *
31      * - Subtraction cannot overflow.
32      */
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b <= a, errorMessage);
49         uint256 c = a - b;
50 
51         return c;
52     }
53 
54     /**
55      * @dev Returns the multiplication of two unsigned integers, reverting on
56      * overflow.
57      *
58      * Counterpart to Solidity's `*` operator.
59      *
60      * Requirements:
61      *
62      * - Multiplication cannot overflow.
63      */
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
66         // benefit is lost if 'b' is also tested.
67         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
68         if (a == 0) {
69             return 0;
70         }
71 
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the integer division of two unsigned integers. Reverts on
80      * division by zero. The result is rounded towards zero.
81      *
82      * Counterpart to Solidity's `/` operator. Note: this function uses a
83      * `revert` opcode (which leaves remaining gas untouched) while Solidity
84      * uses an invalid opcode to revert (consuming all remaining gas).
85      *
86      * Requirements:
87      *
88      * - The divisor cannot be zero.
89      */
90     function div(uint256 a, uint256 b) internal pure returns (uint256) {
91         return div(a, b, "SafeMath: division by zero");
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      *
104      * - The divisor cannot be zero.
105      */
106     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
107         require(b > 0, errorMessage);
108         uint256 c = a / b;
109         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
116      * Reverts when dividing by zero.
117      *
118      * Counterpart to Solidity's `%` operator. This function uses a `revert`
119      * opcode (which leaves remaining gas untouched) while Solidity uses an
120      * invalid opcode to revert (consuming all remaining gas).
121      *
122      * Requirements:
123      *
124      * - The divisor cannot be zero.
125      */
126     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
127         return mod(a, b, "SafeMath: modulo by zero");
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts with custom message when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         require(b != 0, errorMessage);
144         return a % b;
145     }
146 }
147 
148 library Math {
149     /**
150      * @dev Returns the largest of two numbers.
151      */
152     function max(uint256 a, uint256 b) internal pure returns (uint256) {
153         return a >= b ? a : b;
154     }
155 
156     /**
157      * @dev Returns the smallest of two numbers.
158      */
159     function min(uint256 a, uint256 b) internal pure returns (uint256) {
160         return a < b ? a : b;
161     }
162 
163     /**
164      * @dev Returns the average of two numbers. The result is rounded towards
165      * zero.
166      */
167     function average(uint256 a, uint256 b) internal pure returns (uint256) {
168         // (a + b) / 2 can overflow, so we distribute
169         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
170     }
171 }
172 
173 abstract contract Context {
174     function _msgSender() internal view virtual returns (address payable) {
175         return msg.sender;
176     }
177 
178     function _msgData() internal view virtual returns (bytes memory) {
179         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
180         return msg.data;
181     }
182 }
183 
184 abstract contract Ownable is Context {
185     address private _owner;
186 
187     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
188 
189     /**
190      * @dev Initializes the contract setting the deployer as the initial owner.
191      */
192     constructor () internal {
193         address msgSender = _msgSender();
194         _owner = msgSender;
195         emit OwnershipTransferred(address(0), msgSender);
196     }
197 
198     /**
199      * @dev Returns the address of the current owner.
200      */
201     function owner() public view returns (address) {
202         return _owner;
203     }
204 
205     /**
206      * @dev Throws if called by any account other than the owner.
207      */
208     modifier onlyOwner() {
209         require(_owner == _msgSender(), "Ownable: caller is not the owner");
210         _;
211     }
212 
213     /**
214      * @dev Leaves the contract without owner. It will not be possible to call
215      * `onlyOwner` functions anymore. Can only be called by the current owner.
216      *
217      * NOTE: Renouncing ownership will leave the contract without an owner,
218      * thereby removing any functionality that is only available to the owner.
219      */
220     function renounceOwnership() public virtual onlyOwner {
221         emit OwnershipTransferred(_owner, address(0));
222         _owner = address(0);
223     }
224 
225     /**
226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
227      * Can only be called by the current owner.
228      */
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         emit OwnershipTransferred(_owner, newOwner);
232         _owner = newOwner;
233     }
234 }
235 
236 contract Operator is Context, Ownable {
237     address private _operator;
238 
239     event OperatorTransferred(
240         address indexed previousOperator,
241         address indexed newOperator
242     );
243 
244     constructor() internal {
245         _operator = _msgSender();
246         emit OperatorTransferred(address(0), _operator);
247     }
248 
249     function operator() public view returns (address) {
250         return _operator;
251     }
252 
253     modifier onlyOperator() {
254         require(
255             _operator == msg.sender,
256             'operator: caller is not the operator'
257         );
258         _;
259     }
260 
261     function isOperator() public view returns (bool) {
262         return _msgSender() == _operator;
263     }
264 
265     function transferOperator(address newOperator_) public onlyOwner {
266         _transferOperator(newOperator_);
267     }
268 
269     function _transferOperator(address newOperator_) internal {
270         require(
271             newOperator_ != address(0),
272             'operator: zero address given for new operator'
273         );
274         emit OperatorTransferred(address(0), newOperator_);
275         _operator = newOperator_;
276     }
277 }
278 
279 interface IERC20 {
280     /**
281      * @dev Returns the amount of tokens in existence.
282      */
283     function totalSupply() external view returns (uint256);
284 
285     /**
286      * @dev Returns the amount of tokens owned by `account`.
287      */
288     function balanceOf(address account) external view returns (uint256);
289 
290     /**
291      * @dev Moves `amount` tokens from the caller's account to `recipient`.
292      *
293      * Returns a boolean value indicating whether the operation succeeded.
294      *
295      * Emits a {Transfer} event.
296      */
297     function transfer(address recipient, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Returns the remaining number of tokens that `spender` will be
301      * allowed to spend on behalf of `owner` through {transferFrom}. This is
302      * zero by default.
303      *
304      * This value changes when {approve} or {transferFrom} are called.
305      */
306     function allowance(address owner, address spender) external view returns (uint256);
307 
308     /**
309      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
310      *
311      * Returns a boolean value indicating whether the operation succeeded.
312      *
313      * IMPORTANT: Beware that changing an allowance with this method brings the risk
314      * that someone may use both the old and the new allowance by unfortunate
315      * transaction ordering. One possible solution to mitigate this race
316      * condition is to first reduce the spender's allowance to 0 and set the
317      * desired value afterwards:
318      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
319      *
320      * Emits an {Approval} event.
321      */
322     function approve(address spender, uint256 amount) external returns (bool);
323 
324     /**
325      * @dev Moves `amount` tokens from `sender` to `recipient` using the
326      * allowance mechanism. `amount` is then deducted from the caller's
327      * allowance.
328      *
329      * Returns a boolean value indicating whether the operation succeeded.
330      *
331      * Emits a {Transfer} event.
332      */
333     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
334 
335     /**
336      * @dev Emitted when `value` tokens are moved from one account (`from`) to
337      * another (`to`).
338      *
339      * Note that `value` may be zero.
340      */
341     event Transfer(address indexed from, address indexed to, uint256 value);
342 
343     /**
344      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
345      * a call to {approve}. `value` is the new allowance.
346      */
347     event Approval(address indexed owner, address indexed spender, uint256 value);
348 }
349 
350 library Address {
351     /**
352      * @dev Returns true if `account` is a contract.
353      *
354      * [IMPORTANT]
355      * ====
356      * It is unsafe to assume that an address for which this function returns
357      * false is an externally-owned account (EOA) and not a contract.
358      *
359      * Among others, `isContract` will return false for the following
360      * types of addresses:
361      *
362      *  - an externally-owned account
363      *  - a contract in construction
364      *  - an address where a contract will be created
365      *  - an address where a contract lived, but was destroyed
366      * ====
367      */
368     function isContract(address account) internal view returns (bool) {
369         // This method relies on extcodesize, which returns 0 for contracts in
370         // construction, since the code is only stored at the end of the
371         // constructor execution.
372 
373         uint256 size;
374         // solhint-disable-next-line no-inline-assembly
375         assembly { size := extcodesize(account) }
376         return size > 0;
377     }
378 
379     /**
380      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
381      * `recipient`, forwarding all available gas and reverting on errors.
382      *
383      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
384      * of certain opcodes, possibly making contracts go over the 2300 gas limit
385      * imposed by `transfer`, making them unable to receive funds via
386      * `transfer`. {sendValue} removes this limitation.
387      *
388      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
389      *
390      * IMPORTANT: because control is transferred to `recipient`, care must be
391      * taken to not create reentrancy vulnerabilities. Consider using
392      * {ReentrancyGuard} or the
393      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
394      */
395     function sendValue(address payable recipient, uint256 amount) internal {
396         require(address(this).balance >= amount, "Address: insufficient balance");
397 
398         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
399         (bool success, ) = recipient.call{ value: amount }("");
400         require(success, "Address: unable to send value, recipient may have reverted");
401     }
402 
403     /**
404      * @dev Performs a Solidity function call using a low level `call`. A
405      * plain`call` is an unsafe replacement for a function call: use this
406      * function instead.
407      *
408      * If `target` reverts with a revert reason, it is bubbled up by this
409      * function (like regular Solidity function calls).
410      *
411      * Returns the raw returned data. To convert to the expected return value,
412      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
413      *
414      * Requirements:
415      *
416      * - `target` must be a contract.
417      * - calling `target` with `data` must not revert.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
422       return functionCall(target, data, "Address: low-level call failed");
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
427      * `errorMessage` as a fallback revert reason when `target` reverts.
428      *
429      * _Available since v3.1._
430      */
431     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
432         return functionCallWithValue(target, data, 0, errorMessage);
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
437      * but also transferring `value` wei to `target`.
438      *
439      * Requirements:
440      *
441      * - the calling contract must have an ETH balance of at least `value`.
442      * - the called Solidity function must be `payable`.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
447         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
457         require(address(this).balance >= value, "Address: insufficient balance for call");
458         require(isContract(target), "Address: call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = target.call{ value: value }(data);
462         return _verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
472         return functionStaticCall(target, data, "Address: low-level static call failed");
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
477      * but performing a static call.
478      *
479      * _Available since v3.3._
480      */
481     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
482         require(isContract(target), "Address: static call to non-contract");
483 
484         // solhint-disable-next-line avoid-low-level-calls
485         (bool success, bytes memory returndata) = target.staticcall(data);
486         return _verifyCallResult(success, returndata, errorMessage);
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
491      * but performing a delegate call.
492      *
493      * _Available since v3.3._
494      */
495     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
496         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
501      * but performing a delegate call.
502      *
503      * _Available since v3.3._
504      */
505     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
506         require(isContract(target), "Address: delegate call to non-contract");
507 
508         // solhint-disable-next-line avoid-low-level-calls
509         (bool success, bytes memory returndata) = target.delegatecall(data);
510         return _verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
514         if (success) {
515             return returndata;
516         } else {
517             // Look for revert reason and bubble it up if present
518             if (returndata.length > 0) {
519                 // The easiest way to bubble the revert reason is using memory via assembly
520 
521                 // solhint-disable-next-line no-inline-assembly
522                 assembly {
523                     let returndata_size := mload(returndata)
524                     revert(add(32, returndata), returndata_size)
525                 }
526             } else {
527                 revert(errorMessage);
528             }
529         }
530     }
531 }
532 
533 library SafeERC20 {
534     using SafeMath for uint256;
535     using Address for address;
536 
537     function safeTransfer(IERC20 token, address to, uint256 value) internal {
538         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
539     }
540 
541     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
542         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
543     }
544 
545     /**
546      * @dev Deprecated. This function has issues similar to the ones found in
547      * {IERC20-approve}, and its usage is discouraged.
548      *
549      * Whenever possible, use {safeIncreaseAllowance} and
550      * {safeDecreaseAllowance} instead.
551      */
552     function safeApprove(IERC20 token, address spender, uint256 value) internal {
553         // safeApprove should only be called when setting an initial allowance,
554         // or when resetting it to zero. To increase and decrease it, use
555         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
556         // solhint-disable-next-line max-line-length
557         require((value == 0) || (token.allowance(address(this), spender) == 0),
558             "SafeERC20: approve from non-zero to non-zero allowance"
559         );
560         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
561     }
562 
563     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
564         uint256 newAllowance = token.allowance(address(this), spender).add(value);
565         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
566     }
567 
568     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
569         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
570         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
571     }
572 
573     /**
574      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
575      * on the return value: the return value is optional (but if data is returned, it must not be false).
576      * @param token The token targeted by the call.
577      * @param data The call data (encoded using abi.encode or one of its variants).
578      */
579     function _callOptionalReturn(IERC20 token, bytes memory data) private {
580         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
581         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
582         // the target address contains contract code and also asserts for success in the low-level call.
583 
584         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
585         if (returndata.length > 0) { // Return data is optional
586             // solhint-disable-next-line max-line-length
587             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
588         }
589     }
590 }
591 
592 abstract contract IRewardDistributionRecipient is Ownable {
593     address public rewardDistribution;
594 
595     function notifyRewardAmount(uint256 reward) external virtual;
596 
597     modifier onlyRewardDistribution() {
598         require(
599             _msgSender() == rewardDistribution,
600             'Caller is not reward distribution'
601         );
602         _;
603     }
604 
605     function setRewardDistribution(address _rewardDistribution)
606         external
607         virtual
608         onlyOwner
609     {
610         rewardDistribution = _rewardDistribution;
611     }
612 }
613 
614 contract LPTokenWrapper {
615     using SafeMath for uint256;
616     using SafeERC20 for IERC20;
617 
618     IERC20 public lpt;
619 
620     uint256 private _totalSupply;
621     mapping(address => uint256) private _balances;
622 
623     function totalSupply() public view returns (uint256) {
624         return _totalSupply;
625     }
626 
627     function balanceOf(address account) public view returns (uint256) {
628         return _balances[account];
629     }
630 
631     function stake(uint256 amount) public virtual {
632         _totalSupply = _totalSupply.add(amount);
633         _balances[msg.sender] = _balances[msg.sender].add(amount);
634         lpt.safeTransferFrom(msg.sender, address(this), amount);
635     }
636 
637     function withdraw(uint256 amount) public virtual {
638         _totalSupply = _totalSupply.sub(amount);
639         _balances[msg.sender] = _balances[msg.sender].sub(amount);
640         lpt.safeTransfer(msg.sender, amount);
641     }
642 }
643 
644 
645 contract UBCUSDTLPTokenSharePool is
646     LPTokenWrapper,
647     IRewardDistributionRecipient
648 {
649     IERC20 public UCS;
650     uint256 public constant DURATION = 30 days;
651 
652     uint256 public initreward = 14400 * 10**18; 
653     uint256 public starttime; 
654     uint256 public periodFinish = 0;
655     uint256 public rewardRate = 0;
656     uint256 public lastUpdateTime;
657     uint256 public rewardPerTokenStored;
658     mapping(address => uint256) public userRewardPerTokenPaid;
659     mapping(address => uint256) public rewards;
660 
661     event RewardAdded(uint256 reward);
662     event Staked(address indexed user, uint256 amount);
663     event Withdrawn(address indexed user, uint256 amount);
664     event RewardPaid(address indexed user, uint256 reward);
665 
666     constructor(
667         address UCS_,
668         address lptoken_,
669         uint256 starttime_
670     ) public {
671         UCS = IERC20(UCS_);
672         lpt = IERC20(lptoken_);
673         starttime = starttime_;
674     }
675 
676     modifier updateReward(address account) {
677         rewardPerTokenStored = rewardPerToken();
678         lastUpdateTime = lastTimeRewardApplicable();
679         if (account != address(0)) {
680             rewards[account] = earned(account);
681             userRewardPerTokenPaid[account] = rewardPerTokenStored;
682         }
683         _;
684     }
685 
686     function lastTimeRewardApplicable() public view returns (uint256) {
687         return Math.min(block.timestamp, periodFinish);
688     }
689 
690     function rewardPerToken() public view returns (uint256) {
691         if (totalSupply() == 0) {
692             return rewardPerTokenStored;
693         }
694         return
695             rewardPerTokenStored.add(
696                 lastTimeRewardApplicable()
697                     .sub(lastUpdateTime)
698                     .mul(rewardRate)
699                     .mul(1e18)
700                     .div(totalSupply())
701             );
702     }
703 
704     function earned(address account) public view returns (uint256) {
705         return
706             balanceOf(account)
707                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
708                 .div(1e18)
709                 .add(rewards[account]);
710     }
711 
712     // stake visibility is public as overriding LPTokenWrapper's stake() function
713     function stake(uint256 amount)
714         public
715         override
716         updateReward(msg.sender)
717         checkhalve
718         checkStart
719     {
720         require(amount > 0, 'Cannot stake 0');
721         super.stake(amount);
722         emit Staked(msg.sender, amount);
723     }
724 
725     function withdraw(uint256 amount)
726         public
727         override
728         updateReward(msg.sender)
729         checkhalve
730         checkStart
731     {
732         require(amount > 0, 'Cannot withdraw 0');
733         super.withdraw(amount);
734         emit Withdrawn(msg.sender, amount);
735     }
736 
737     function exit() external {
738         withdraw(balanceOf(msg.sender));
739         getReward();
740     }
741 
742     function getReward() public updateReward(msg.sender) checkhalve checkStart {
743         uint256 reward = earned(msg.sender);
744         if (reward > 0) {
745             rewards[msg.sender] = 0;
746             UCS.safeTransfer(msg.sender, reward);
747             emit RewardPaid(msg.sender, reward);
748         }
749     }
750 
751     modifier checkhalve() {
752         if (block.timestamp >= periodFinish) {
753             initreward = initreward.mul(80).div(100);
754 
755             rewardRate = initreward.div(DURATION);
756             periodFinish = block.timestamp.add(DURATION);
757             emit RewardAdded(initreward);
758         }
759         _;
760     }
761 
762     modifier checkStart() {
763         require(block.timestamp >= starttime, 'not start');
764         _;
765     }
766 
767 
768 
769     function notifyRewardAmount(uint256 reward)
770         external
771         override
772         onlyRewardDistribution
773         updateReward(address(0))
774     {
775         if (block.timestamp > starttime) {
776             if (block.timestamp >= periodFinish) {
777                 rewardRate = reward.div(DURATION);
778             } else {
779                 uint256 remaining = periodFinish.sub(block.timestamp);
780                 uint256 leftover = remaining.mul(rewardRate);
781                 rewardRate = reward.add(leftover).div(DURATION);
782             }
783             lastUpdateTime = block.timestamp;
784             periodFinish = block.timestamp.add(DURATION);
785             emit RewardAdded(reward);
786         } else {
787             rewardRate = initreward.div(DURATION);
788             lastUpdateTime = starttime;
789             periodFinish = starttime.add(DURATION);
790             emit RewardAdded(reward);
791         }
792     }
793 }