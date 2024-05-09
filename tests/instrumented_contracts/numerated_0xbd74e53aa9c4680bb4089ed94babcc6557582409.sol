1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-04
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.2;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 
21 library SafeMath {
22     /**
23      * @dev Returns the addition of two unsigned integers, reverting on
24      * overflow.
25      *
26      * Counterpart to Solidity's `+` operator.
27      *
28      * Requirements:
29      *
30      * - Addition cannot overflow.
31      */
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35 
36         return c;
37     }
38 
39     /**
40      * @dev Returns the subtraction of two unsigned integers, reverting on
41      * overflow (when the result is negative).
42      *
43      * Counterpart to Solidity's `-` operator.
44      *
45      * Requirements:
46      *
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      *
61      * - Subtraction cannot overflow.
62      */
63     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b <= a, errorMessage);
65         uint256 c = a - b;
66 
67         return c;
68     }
69 
70     /**
71      * @dev Returns the multiplication of two unsigned integers, reverting on
72      * overflow.
73      *
74      * Counterpart to Solidity's `*` operator.
75      *
76      * Requirements:
77      *
78      * - Multiplication cannot overflow.
79      */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts on
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
106     function div(uint256 a, uint256 b) internal pure returns (uint256) {
107         return div(a, b, "SafeMath: division by zero");
108     }
109 
110     /**
111      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
112      * division by zero. The result is rounded towards zero.
113      *
114      * Counterpart to Solidity's `/` operator. Note: this function uses a
115      * `revert` opcode (which leaves remaining gas untouched) while Solidity
116      * uses an invalid opcode to revert (consuming all remaining gas).
117      *
118      * Requirements:
119      *
120      * - The divisor cannot be zero.
121      */
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b > 0, errorMessage);
124         uint256 c = a / b;
125         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
132      * Reverts when dividing by zero.
133      *
134      * Counterpart to Solidity's `%` operator. This function uses a `revert`
135      * opcode (which leaves remaining gas untouched) while Solidity uses an
136      * invalid opcode to revert (consuming all remaining gas).
137      *
138      * Requirements:
139      *
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
159         require(b != 0, errorMessage);
160         return a % b;
161     }
162 }
163 
164 
165 pragma solidity ^0.6.2;
166 
167 /**
168  * @dev Collection of functions related to the address type
169  */
170 library Address {
171     /**
172      * @dev Returns true if `account` is a contract.
173      *
174      * [IMPORTANT]
175      * ====
176      * It is unsafe to assume that an address for which this function returns
177      * false is an externally-owned account (EOA) and not a contract.
178      *
179      * Among others, `isContract` will return false for the following
180      * types of addresses:
181      *
182      *  - an externally-owned account
183      *  - a contract in construction
184      *  - an address where a contract will be created
185      *  - an address where a contract lived, but was destroyed
186      * ====
187      */
188     function isContract(address account) internal view returns (bool) {
189         // This method relies on extcodesize, which returns 0 for contracts in
190         // construction, since the code is only stored at the end of the
191         // constructor execution.
192 
193         uint256 size;
194         // solhint-disable-next-line no-inline-assembly
195         assembly { size := extcodesize(account) }
196         return size > 0;
197     }
198 
199     /**
200      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
201      * `recipient`, forwarding all available gas and reverting on errors.
202      *
203      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
204      * of certain opcodes, possibly making contracts go over the 2300 gas limit
205      * imposed by `transfer`, making them unable to receive funds via
206      * `transfer`. {sendValue} removes this limitation.
207      *
208      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
209      *
210      * IMPORTANT: because control is transferred to `recipient`, care must be
211      * taken to not create reentrancy vulnerabilities. Consider using
212      * {ReentrancyGuard} or the
213      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
214      */
215     function sendValue(address payable recipient, uint256 amount) internal {
216         require(address(this).balance >= amount, "Address: insufficient balance");
217 
218         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
219         (bool success, ) = recipient.call{ value: amount }("");
220         require(success, "Address: unable to send value, recipient may have reverted");
221     }
222 
223     /**
224      * @dev Performs a Solidity function call using a low level `call`. A
225      * plain`call` is an unsafe replacement for a function call: use this
226      * function instead.
227      *
228      * If `target` reverts with a revert reason, it is bubbled up by this
229      * function (like regular Solidity function calls).
230      *
231      * Returns the raw returned data. To convert to the expected return value,
232      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
233      *
234      * Requirements:
235      *
236      * - `target` must be a contract.
237      * - calling `target` with `data` must not revert.
238      *
239      * _Available since v3.1._
240      */
241     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
242       return functionCall(target, data, "Address: low-level call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
247      * `errorMessage` as a fallback revert reason when `target` reverts.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, 0, errorMessage);
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
257      * but also transferring `value` wei to `target`.
258      *
259      * Requirements:
260      *
261      * - the calling contract must have an ETH balance of at least `value`.
262      * - the called Solidity function must be `payable`.
263      *
264      * _Available since v3.1._
265      */
266     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
267         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
272      * with `errorMessage` as a fallback revert reason when `target` reverts.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
277         require(address(this).balance >= value, "Address: insufficient balance for call");
278         require(isContract(target), "Address: call to non-contract");
279 
280         // solhint-disable-next-line avoid-low-level-calls
281         (bool success, bytes memory returndata) = target.call{ value: value }(data);
282         return _verifyCallResult(success, returndata, errorMessage);
283     }
284 
285     /**
286      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
287      * but performing a static call.
288      *
289      * _Available since v3.3._
290      */
291     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
292         return functionStaticCall(target, data, "Address: low-level static call failed");
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
297      * but performing a static call.
298      *
299      * _Available since v3.3._
300      */
301     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
302         require(isContract(target), "Address: static call to non-contract");
303 
304         // solhint-disable-next-line avoid-low-level-calls
305         (bool success, bytes memory returndata) = target.staticcall(data);
306         return _verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but performing a delegate call.
312      *
313      * _Available since v3.3._
314      */
315     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
316         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
321      * but performing a delegate call.
322      *
323      * _Available since v3.3._
324      */
325     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
326         require(isContract(target), "Address: delegate call to non-contract");
327 
328         // solhint-disable-next-line avoid-low-level-calls
329         (bool success, bytes memory returndata) = target.delegatecall(data);
330         return _verifyCallResult(success, returndata, errorMessage);
331     }
332 
333     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
334         if (success) {
335             return returndata;
336         } else {
337             // Look for revert reason and bubble it up if present
338             if (returndata.length > 0) {
339                 // The easiest way to bubble the revert reason is using memory via assembly
340 
341                 // solhint-disable-next-line no-inline-assembly
342                 assembly {
343                     let returndata_size := mload(returndata)
344                     revert(add(32, returndata), returndata_size)
345                 }
346             } else {
347                 revert(errorMessage);
348             }
349         }
350     }
351 }
352 
353 
354 
355 pragma solidity ^0.6.0;
356 
357 /**
358  * @title SafeERC20
359  * @dev Wrappers around ERC20 operations that throw on failure (when the token
360  * contract returns false). Tokens that return no value (and instead revert or
361  * throw on failure) are also supported, non-reverting calls are assumed to be
362  * successful.
363  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
364  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
365  */
366 library SafeERC20 {
367     using SafeMath for uint256;
368     using Address for address;
369 
370     function safeTransfer(IERC20 token, address to, uint256 value) internal {
371         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
372     }
373 
374     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
375         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
376     }
377 
378     /**
379      * @dev Deprecated. This function has issues similar to the ones found in
380      * {IERC20-approve}, and its usage is discouraged.
381      *
382      * Whenever possible, use {safeIncreaseAllowance} and
383      * {safeDecreaseAllowance} instead.
384      */
385     function safeApprove(IERC20 token, address spender, uint256 value) internal {
386         // safeApprove should only be called when setting an initial allowance,
387         // or when resetting it to zero. To increase and decrease it, use
388         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
389         // solhint-disable-next-line max-line-length
390         require((value == 0) || (token.allowance(address(this), spender) == 0),
391             "SafeERC20: approve from non-zero to non-zero allowance"
392         );
393         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
394     }
395 
396     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
397         uint256 newAllowance = token.allowance(address(this), spender).add(value);
398         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
399     }
400 
401     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
402         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
403         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
404     }
405 
406     /**
407      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
408      * on the return value: the return value is optional (but if data is returned, it must not be false).
409      * @param token The token targeted by the call.
410      * @param data The call data (encoded using abi.encode or one of its variants).
411      */
412     function _callOptionalReturn(IERC20 token, bytes memory data) private {
413         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
414         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
415         // the target address contains contract code and also asserts for success in the low-level call.
416 
417         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
418         if (returndata.length > 0) { // Return data is optional
419             // solhint-disable-next-line max-line-length
420             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
421         }
422     }
423 }
424 
425 
426 contract Pausable is Context {
427     /**
428      * @dev Emitted when the pause is triggered by `account`.
429      */
430     event Paused(address account);
431 
432     /**
433      * @dev Emitted when the pause is lifted by `account`.
434      */
435     event Unpaused(address account);
436 
437     bool private _paused;
438 
439     /**
440      * @dev Initializes the contract in unpaused state.
441      */
442     constructor () internal {
443         _paused = false;
444     }
445 
446     /**
447      * @dev Returns true if the contract is paused, and false otherwise.
448      */
449     function paused() public view returns (bool) {
450         return _paused;
451     }
452 
453     /**
454      * @dev Modifier to make a function callable only when the contract is not paused.
455      *
456      * Requirements:
457      *
458      * - The contract must not be paused.
459      */
460     modifier whenNotPaused() {
461         require(!_paused, "Pausable: paused");
462         _;
463     }
464 
465     /**
466      * @dev Modifier to make a function callable only when the contract is paused.
467      *
468      * Requirements:
469      *
470      * - The contract must be paused.
471      */
472     modifier whenPaused() {
473         require(_paused, "Pausable: not paused");
474         _;
475     }
476 
477     /**
478      * @dev Triggers stopped state.
479      *
480      * Requirements:
481      *
482      * - The contract must not be paused.
483      */
484     function _pause() internal virtual whenNotPaused {
485         _paused = true;
486         emit Paused(_msgSender());
487     }
488 
489     /**
490      * @dev Returns to normal state.
491      *
492      * Requirements:
493      *
494      * - The contract must be paused.
495      */
496     function _unpause() internal virtual whenPaused {
497         _paused = false;
498         emit Unpaused(_msgSender());
499     }
500 }
501 
502 
503 contract Ownable is Context {
504     address private _owner;
505 
506     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
507 
508     /**
509      * @dev Initializes the contract setting the deployer as the initial owner.
510      */
511     constructor () internal {
512         address msgSender = _msgSender();
513         _owner = msgSender;
514         emit OwnershipTransferred(address(0), msgSender);
515     }
516 
517     /**
518      * @dev Returns the address of the current owner.
519      */
520     function owner() public view returns (address) {
521         return _owner;
522     }
523 
524     /**
525      * @dev Throws if called by any account other than the owner.
526      */
527     modifier onlyOwner() {
528         require(_owner == _msgSender(), "Ownable: caller is not the owner");
529         _;
530     }
531 
532     /**
533      * @dev Leaves the contract without owner. It will not be possible to call
534      * `onlyOwner` functions anymore. Can only be called by the current owner.
535      *
536      * NOTE: Renouncing ownership will leave the contract without an owner,
537      * thereby removing any functionality that is only available to the owner.
538      */
539     function renounceOwnership() public virtual onlyOwner {
540         emit OwnershipTransferred(_owner, address(0));
541         _owner = address(0);
542     }
543 
544     /**
545      * @dev Transfers ownership of the contract to a new account (`newOwner`).
546      * Can only be called by the current owner.
547      */
548     function transferOwnership(address newOwner) public virtual onlyOwner {
549         require(newOwner != address(0), "Ownable: new owner is the zero address");
550         emit OwnershipTransferred(_owner, newOwner);
551         _owner = newOwner;
552     }
553 }
554 
555 
556 contract ReentrancyGuard {
557     // Booleans are more expensive than uint256 or any type that takes up a full
558     // word because each write operation emits an extra SLOAD to first read the
559     // slot's contents, replace the bits taken up by the boolean, and then write
560     // back. This is the compiler's defense against contract upgrades and
561     // pointer aliasing, and it cannot be disabled.
562 
563     // The values being non-zero value makes deployment a bit more expensive,
564     // but in exchange the refund on every call to nonReentrant will be lower in
565     // amount. Since refunds are capped to a percentage of the total
566     // transaction's gas, it is best to keep them low in cases like this one, to
567     // increase the likelihood of the full refund coming into effect.
568     uint256 private constant _NOT_ENTERED = 1;
569     uint256 private constant _ENTERED = 2;
570 
571     uint256 private _status;
572 
573     constructor () internal {
574         _status = _NOT_ENTERED;
575     }
576 
577     /**
578      * @dev Prevents a contract from calling itself, directly or indirectly.
579      * Calling a `nonReentrant` function from another `nonReentrant`
580      * function is not supported. It is possible to prevent this from happening
581      * by making the `nonReentrant` function external, and make it call a
582      * `private` function that does the actual work.
583      */
584     modifier nonReentrant() {
585         // On the first call to nonReentrant, _notEntered will be true
586         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
587 
588         // Any calls to nonReentrant after this point will fail
589         _status = _ENTERED;
590 
591         _;
592 
593         // By storing the original value once again, a refund is triggered (see
594         // https://eips.ethereum.org/EIPS/eip-2200)
595         _status = _NOT_ENTERED;
596     }
597 }
598 
599 
600 pragma solidity ^0.6.0;
601 
602 /// @title LP Staking Contract
603 
604 interface IERC20 {
605     function balanceOf(address account) external view returns (uint256);
606     function approve(address spender, uint256 amount) external returns (bool);
607     function transfer(address recipient, uint256 amount) external returns (bool);
608     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
609     function allowance(address owner, address spender) external view returns (uint256);
610 }
611 
612 contract StakingRewards is ReentrancyGuard, Pausable, Ownable {
613     using SafeMath for uint256;
614     using SafeERC20 for IERC20;
615 
616     /* ========== STATE VARIABLES ========== */
617 
618     IERC20 public rewardsToken;
619     IERC20 public stakingToken;
620     uint256 public periodFinish = 0;
621     uint256 public rewardRate = 0;
622     uint256 public rewardsDuration = 16 weeks;
623     uint256 public lastUpdateTime;
624     uint256 public rewardPerTokenStored;
625     uint256 public minLp = 10000000000000000000000; // 10,000 STBU
626     uint256 public maxLp = 100000000000000000000000; // 100,000 STBU
627 
628     mapping(address => uint256) public userRewardPerTokenPaid;
629     mapping(address => uint256) public rewards;
630 
631     uint256 private _totalSupply;
632     mapping(address => uint256) private _balances;
633 
634     /* ========== CONSTRUCTOR ========== */
635 
636     constructor(address _rewardsToken, address _stakingToken) public {
637         rewardsToken = IERC20(_rewardsToken);
638         stakingToken = IERC20(_stakingToken);
639     }
640 
641     /* ========== VIEWS ========== */
642 
643     function totalSupply() external view returns (uint256) {
644         return _totalSupply;
645     }
646 
647     function balanceOf(address account) external view returns (uint256) {
648         return _balances[account];
649     }
650 
651     function lastTimeRewardApplicable() public view returns (uint256) {
652         return min(block.timestamp, periodFinish);
653     }
654 
655     function rewardPerToken() public view returns (uint256) {
656         if (_totalSupply == 0) {
657             return rewardPerTokenStored;
658         }
659         return
660             rewardPerTokenStored.add(
661                 lastTimeRewardApplicable()
662                     .sub(lastUpdateTime)
663                     .mul(rewardRate)
664                     .mul(1e18)
665                     .div(_totalSupply)
666             );
667     }
668 
669     function earned(address account) public view returns (uint256) {
670         return
671             _balances[account]
672                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
673                 .div(1e18)
674                 .add(rewards[account]);
675     }
676 
677     function getRewardForDuration() external view returns (uint256) {
678         return rewardRate.mul(rewardsDuration);
679     }
680 
681     function min(uint256 a, uint256 b) public pure returns (uint256) {
682         return a < b ? a : b;
683     }
684 
685     /* ========== MUTATIVE FUNCTIONS ========== */
686 
687     function stake(uint256 amount)
688         external
689         nonReentrant
690         whenNotPaused
691         updateReward(msg.sender)
692     {
693         require(amount > 0, "Cannot stake 0");
694         require(_balances[msg.sender].add(amount) >= minLp && _balances[msg.sender].add(amount) <= maxLp, "Wrong amount");
695         _totalSupply = _totalSupply.add(amount);
696         _balances[msg.sender] = _balances[msg.sender].add(amount);
697         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
698         emit Staked(msg.sender, amount);
699     }
700 
701     function withdraw(uint256 amount)
702         public
703         nonReentrant
704         updateReward(msg.sender)
705     {
706         require(amount > 0, "Cannot withdraw 0");
707         _totalSupply = _totalSupply.sub(amount);
708         _balances[msg.sender] = _balances[msg.sender].sub(amount);
709         stakingToken.safeTransfer(msg.sender, amount);
710         emit Withdrawn(msg.sender, amount);
711     }
712 
713     function getReward() public nonReentrant updateReward(msg.sender) {
714         uint256 reward = rewards[msg.sender];
715         if (reward > 0) {
716             rewards[msg.sender] = 0;
717             rewardsToken.safeTransfer(msg.sender, reward);
718             emit RewardPaid(msg.sender, reward);
719         }
720     }
721 
722     function exit() external {
723         withdraw(_balances[msg.sender]);
724         getReward();
725     }
726 
727     /* ========== RESTRICTED FUNCTIONS ========== */
728 
729     function notifyRewardAmount(uint256 reward)
730         external
731         onlyOwner
732         updateReward(address(0))
733     {
734         if (block.timestamp >= periodFinish) {
735             rewardRate = reward.div(rewardsDuration);
736         } else {
737             uint256 remaining = periodFinish.sub(block.timestamp);
738             uint256 leftover = remaining.mul(rewardRate);
739             rewardRate = reward.add(leftover).div(rewardsDuration);
740         }
741 
742         // Ensure the provided reward amount is not more than the balance in the contract.
743         // This keeps the reward rate in the right range, preventing overflows due to
744         // very high values of rewardRate in the earned and rewardsPerToken functions;
745         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
746         // uint256 balance = rewardsToken.balanceOf(address(this));
747         // require(
748         //     rewardRate <= balance.div(rewardsDuration),
749         //     "Provided reward too high"
750         // );
751 
752         lastUpdateTime = block.timestamp;
753         periodFinish = block.timestamp.add(rewardsDuration);
754         emit RewardAdded(reward);
755     }
756 
757     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
758     function recoverERC20(address tokenAddress, uint256 tokenAmount)
759         external
760         onlyOwner
761     {
762         // Cannot recover the staking token or the rewards token
763         require(
764             tokenAddress != address(stakingToken) &&
765                 tokenAddress != address(rewardsToken),
766             "Cannot withdraw the staking or rewards tokens"
767         );
768         IERC20(tokenAddress).safeTransfer(this.owner(), tokenAmount);
769         emit Recovered(tokenAddress, tokenAmount);
770     }
771 
772     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
773         require(
774             block.timestamp > periodFinish,
775             "Previous rewards period must be complete before changing the duration for the new period"
776         );
777         rewardsDuration = _rewardsDuration;
778         emit RewardsDurationUpdated(rewardsDuration);
779     }
780 
781     /* ========== MODIFIERS ========== */
782 
783     modifier updateReward(address account) {
784         rewardPerTokenStored = rewardPerToken();
785         lastUpdateTime = lastTimeRewardApplicable();
786         if (account != address(0)) {
787             rewards[account] = earned(account);
788             userRewardPerTokenPaid[account] = rewardPerTokenStored;
789         }
790         _;
791     }
792 
793     /* ========== EVENTS ========== */
794 
795     event RewardAdded(uint256 reward);
796     event Staked(address indexed user, uint256 amount);
797     event Withdrawn(address indexed user, uint256 amount);
798     event RewardPaid(address indexed user, uint256 reward);
799     event RewardsDurationUpdated(uint256 newDuration);
800     event Recovered(address token, uint256 amount);
801 }