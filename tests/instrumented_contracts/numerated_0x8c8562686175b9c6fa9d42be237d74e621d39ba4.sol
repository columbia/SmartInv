1 pragma solidity ^0.6.0;
2 
3 /**
4  * @dev Standard math utilities missing in the Solidity language.
5  */
6 library Math {
7     /**
8      * @dev Returns the largest of two numbers.
9      */
10     function max(uint256 a, uint256 b) internal pure returns (uint256) {
11         return a >= b ? a : b;
12     }
13 
14     /**
15      * @dev Returns the smallest of two numbers.
16      */
17     function min(uint256 a, uint256 b) internal pure returns (uint256) {
18         return a < b ? a : b;
19     }
20 
21     /**
22      * @dev Returns the average of two numbers. The result is rounded towards
23      * zero.
24      */
25     function average(uint256 a, uint256 b) internal pure returns (uint256) {
26         // (a + b) / 2 can overflow, so we distribute
27         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
28     }
29 }
30 
31 // File: @openzeppelin\contracts\math\SafeMath.sol
32 
33 pragma solidity ^0.6.0;
34 
35 /**
36  * @dev Wrappers over Solidity's arithmetic operations with added overflow
37  * checks.
38  *
39  * Arithmetic operations in Solidity wrap on overflow. This can easily result
40  * in bugs, because programmers usually assume that an overflow raises an
41  * error, which is the standard behavior in high level programming languages.
42  * `SafeMath` restores this intuition by reverting the transaction when an
43  * operation overflows.
44  *
45  * Using this library instead of the unchecked operations eliminates an entire
46  * class of bugs, so it's recommended to use it always.
47  */
48 
49 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
50 
51 pragma solidity ^0.6.0;
52 
53 /*
54  * @dev Provides information about the current execution context, including the
55  * sender of the transaction and its data. While these are generally available
56  * via msg.sender and msg.data, they should not be accessed in such a direct
57  * manner, since when dealing with GSN meta-transactions the account sending and
58  * paying for execution may not be the actual sender (as far as an application
59  * is concerned).
60  *
61  * This contract is only required for intermediate, library-like contracts.
62  */
63 abstract contract Context {
64     function _msgSender() internal view virtual returns (address payable) {
65         return msg.sender;
66     }
67 
68     function _msgData() internal view virtual returns (bytes memory) {
69         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
70         return msg.data;
71     }
72 }
73 
74 // File: @openzeppelin\contracts\access\Ownable.sol
75 
76 pragma solidity ^0.6.0;
77 
78 /**
79  * @dev Contract module which provides a basic access control mechanism, where
80  * there is an account (an owner) that can be granted exclusive access to
81  * specific functions.
82  *
83  * By default, the owner account will be the one that deploys the contract. This
84  * can later be changed with {transferOwnership}.
85  *
86  * This module is used through inheritance. It will make available the modifier
87  * `onlyOwner`, which can be applied to your functions to restrict their use to
88  * the owner.
89  */
90 contract Ownable is Context {
91     address private _owner;
92 
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     /**
96      * @dev Initializes the contract setting the deployer as the initial owner.
97      */
98     constructor () internal {
99         address msgSender = _msgSender();
100         _owner = msgSender;
101         emit OwnershipTransferred(address(0), msgSender);
102     }
103 
104     /**
105      * @dev Returns the address of the current owner.
106      */
107     function owner() public view returns (address) {
108         return _owner;
109     }
110 
111     /**
112      * @dev Throws if called by any account other than the owner.
113      */
114     modifier onlyOwner() {
115         require(_owner == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119     /**
120      * @dev Leaves the contract without owner. It will not be possible to call
121      * `onlyOwner` functions anymore. Can only be called by the current owner.
122      *
123      * NOTE: Renouncing ownership will leave the contract without an owner,
124      * thereby removing any functionality that is only available to the owner.
125      */
126     function renounceOwnership() public virtual onlyOwner {
127         emit OwnershipTransferred(_owner, address(0));
128         _owner = address(0);
129     }
130 
131     /**
132      * @dev Transfers ownership of the contract to a new account (`newOwner`).
133      * Can only be called by the current owner.
134      */
135     function transferOwnership(address newOwner) public virtual onlyOwner {
136         require(newOwner != address(0), "Ownable: new owner is the zero address");
137         emit OwnershipTransferred(_owner, newOwner);
138         _owner = newOwner;
139     }
140 }
141 
142 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
143 
144 pragma solidity ^0.6.0;
145 
146 /**
147  * @dev Interface of the ERC20 standard as defined in the EIP.
148  */
149 interface IERC20 {
150     /**
151      * @dev Returns the amount of tokens in existence.
152      */
153     function totalSupply() external view returns (uint256);
154 
155     /**
156      * @dev Returns the amount of tokens owned by `account`.
157      */
158     function balanceOf(address account) external view returns (uint256);
159 
160     /**
161      * @dev Moves `amount` tokens from the caller's account to `recipient`.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transfer(address recipient, uint256 amount) external returns (bool);
168 
169     /**
170      * @dev Returns the remaining number of tokens that `spender` will be
171      * allowed to spend on behalf of `owner` through {transferFrom}. This is
172      * zero by default.
173      *
174      * This value changes when {approve} or {transferFrom} are called.
175      */
176     function allowance(address owner, address spender) external view returns (uint256);
177 
178     /**
179      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * IMPORTANT: Beware that changing an allowance with this method brings the risk
184      * that someone may use both the old and the new allowance by unfortunate
185      * transaction ordering. One possible solution to mitigate this race
186      * condition is to first reduce the spender's allowance to 0 and set the
187      * desired value afterwards:
188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
189      *
190      * Emits an {Approval} event.
191      */
192     function approve(address spender, uint256 amount) external returns (bool);
193 
194     /**
195      * @dev Moves `amount` tokens from `sender` to `recipient` using the
196      * allowance mechanism. `amount` is then deducted from the caller's
197      * allowance.
198      *
199      * Returns a boolean value indicating whether the operation succeeded.
200      *
201      * Emits a {Transfer} event.
202      */
203     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
204 
205     /**
206      * @dev Emitted when `value` tokens are moved from one account (`from`) to
207      * another (`to`).
208      *
209      * Note that `value` may be zero.
210      */
211     event Transfer(address indexed from, address indexed to, uint256 value);
212 
213     /**
214      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
215      * a call to {approve}. `value` is the new allowance.
216      */
217     event Approval(address indexed owner, address indexed spender, uint256 value);
218 }
219 
220 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
221 
222 pragma solidity ^0.6.0;
223 
224 /**
225  * @dev Wrappers over Solidity's arithmetic operations with added overflow
226  * checks.
227  *
228  * Arithmetic operations in Solidity wrap on overflow. This can easily result
229  * in bugs, because programmers usually assume that an overflow raises an
230  * error, which is the standard behavior in high level programming languages.
231  * `SafeMath` restores this intuition by reverting the transaction when an
232  * operation overflows.
233  *
234  * Using this library instead of the unchecked operations eliminates an entire
235  * class of bugs, so it's recommended to use it always.
236  */
237 library SafeMath {
238     /**
239      * @dev Returns the addition of two unsigned integers, reverting on
240      * overflow.
241      *
242      * Counterpart to Solidity's `+` operator.
243      *
244      * Requirements:
245      *
246      * - Addition cannot overflow.
247      */
248     function add(uint256 a, uint256 b) internal pure returns (uint256) {
249         uint256 c = a + b;
250         require(c >= a, "SafeMath: addition overflow");
251 
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
266         return sub(a, b, "SafeMath: subtraction overflow");
267     }
268 
269     /**
270      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
271      * overflow (when the result is negative).
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b <= a, errorMessage);
281         uint256 c = a - b;
282 
283         return c;
284     }
285 
286     /**
287      * @dev Returns the multiplication of two unsigned integers, reverting on
288      * overflow.
289      *
290      * Counterpart to Solidity's `*` operator.
291      *
292      * Requirements:
293      *
294      * - Multiplication cannot overflow.
295      */
296     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
297         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
298         // benefit is lost if 'b' is also tested.
299         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
300         if (a == 0) {
301             return 0;
302         }
303 
304         uint256 c = a * b;
305         require(c / a == b, "SafeMath: multiplication overflow");
306 
307         return c;
308     }
309 
310     /**
311      * @dev Returns the integer division of two unsigned integers. Reverts on
312      * division by zero. The result is rounded towards zero.
313      *
314      * Counterpart to Solidity's `/` operator. Note: this function uses a
315      * `revert` opcode (which leaves remaining gas untouched) while Solidity
316      * uses an invalid opcode to revert (consuming all remaining gas).
317      *
318      * Requirements:
319      *
320      * - The divisor cannot be zero.
321      */
322     function div(uint256 a, uint256 b) internal pure returns (uint256) {
323         return div(a, b, "SafeMath: division by zero");
324     }
325 
326     /**
327      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
328      * division by zero. The result is rounded towards zero.
329      *
330      * Counterpart to Solidity's `/` operator. Note: this function uses a
331      * `revert` opcode (which leaves remaining gas untouched) while Solidity
332      * uses an invalid opcode to revert (consuming all remaining gas).
333      *
334      * Requirements:
335      *
336      * - The divisor cannot be zero.
337      */
338     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
339         require(b > 0, errorMessage);
340         uint256 c = a / b;
341         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
342 
343         return c;
344     }
345 
346     /**
347      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
348      * Reverts when dividing by zero.
349      *
350      * Counterpart to Solidity's `%` operator. This function uses a `revert`
351      * opcode (which leaves remaining gas untouched) while Solidity uses an
352      * invalid opcode to revert (consuming all remaining gas).
353      *
354      * Requirements:
355      *
356      * - The divisor cannot be zero.
357      */
358     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
359         return mod(a, b, "SafeMath: modulo by zero");
360     }
361 
362     /**
363      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
364      * Reverts with custom message when dividing by zero.
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
375         require(b != 0, errorMessage);
376         return a % b;
377     }
378 }
379 
380 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
381 
382 pragma solidity ^0.6.2;
383 
384 /**
385  * @dev Collection of functions related to the address type
386  */
387 library Address {
388     /**
389      * @dev Returns true if `account` is a contract.
390      *
391      * [IMPORTANT]
392      * ====
393      * It is unsafe to assume that an address for which this function returns
394      * false is an externally-owned account (EOA) and not a contract.
395      *
396      * Among others, `isContract` will return false for the following
397      * types of addresses:
398      *
399      *  - an externally-owned account
400      *  - a contract in construction
401      *  - an address where a contract will be created
402      *  - an address where a contract lived, but was destroyed
403      * ====
404      */
405     function isContract(address account) internal view returns (bool) {
406         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
407         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
408         // for accounts without code, i.e. `keccak256('')`
409         bytes32 codehash;
410         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
411         // solhint-disable-next-line no-inline-assembly
412         assembly { codehash := extcodehash(account) }
413         return (codehash != accountHash && codehash != 0x0);
414     }
415 
416     /**
417      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
418      * `recipient`, forwarding all available gas and reverting on errors.
419      *
420      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
421      * of certain opcodes, possibly making contracts go over the 2300 gas limit
422      * imposed by `transfer`, making them unable to receive funds via
423      * `transfer`. {sendValue} removes this limitation.
424      *
425      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
426      *
427      * IMPORTANT: because control is transferred to `recipient`, care must be
428      * taken to not create reentrancy vulnerabilities. Consider using
429      * {ReentrancyGuard} or the
430      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
431      */
432     function sendValue(address payable recipient, uint256 amount) internal {
433         require(address(this).balance >= amount, "Address: insufficient balance");
434 
435         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
436         (bool success, ) = recipient.call{ value: amount }("");
437         require(success, "Address: unable to send value, recipient may have reverted");
438     }
439 
440     /**
441      * @dev Performs a Solidity function call using a low level `call`. A
442      * plain`call` is an unsafe replacement for a function call: use this
443      * function instead.
444      *
445      * If `target` reverts with a revert reason, it is bubbled up by this
446      * function (like regular Solidity function calls).
447      *
448      * Returns the raw returned data. To convert to the expected return value,
449      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
450      *
451      * Requirements:
452      *
453      * - `target` must be a contract.
454      * - calling `target` with `data` must not revert.
455      *
456      * _Available since v3.1._
457      */
458     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
459       return functionCall(target, data, "Address: low-level call failed");
460     }
461 
462     /**
463      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
464      * `errorMessage` as a fallback revert reason when `target` reverts.
465      *
466      * _Available since v3.1._
467      */
468     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
469         return _functionCallWithValue(target, data, 0, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but also transferring `value` wei to `target`.
475      *
476      * Requirements:
477      *
478      * - the calling contract must have an ETH balance of at least `value`.
479      * - the called Solidity function must be `payable`.
480      *
481      * _Available since v3.1._
482      */
483     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
484         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
489      * with `errorMessage` as a fallback revert reason when `target` reverts.
490      *
491      * _Available since v3.1._
492      */
493     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
494         require(address(this).balance >= value, "Address: insufficient balance for call");
495         return _functionCallWithValue(target, data, value, errorMessage);
496     }
497 
498     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
499         require(isContract(target), "Address: call to non-contract");
500 
501         // solhint-disable-next-line avoid-low-level-calls
502         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
503         if (success) {
504             return returndata;
505         } else {
506             // Look for revert reason and bubble it up if present
507             if (returndata.length > 0) {
508                 // The easiest way to bubble the revert reason is using memory via assembly
509 
510                 // solhint-disable-next-line no-inline-assembly
511                 assembly {
512                     let returndata_size := mload(returndata)
513                     revert(add(32, returndata), returndata_size)
514                 }
515             } else {
516                 revert(errorMessage);
517             }
518         }
519     }
520 }
521 
522 // File: @openzeppelin\contracts\token\ERC20\SafeERC20.sol
523 
524 pragma solidity ^0.6.0;
525 
526 
527 
528 
529 /**
530  * @title SafeERC20
531  * @dev Wrappers around ERC20 operations that throw on failure (when the token
532  * contract returns false). Tokens that return no value (and instead revert or
533  * throw on failure) are also supported, non-reverting calls are assumed to be
534  * successful.
535  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
536  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
537  */
538 library SafeERC20 {
539     using SafeMath for uint256;
540     using Address for address;
541 
542     function safeTransfer(IERC20 token, address to, uint256 value) internal {
543         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
544     }
545 
546     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
547         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
548     }
549 
550     /**
551      * @dev Deprecated. This function has issues similar to the ones found in
552      * {IERC20-approve}, and its usage is discouraged.
553      *
554      * Whenever possible, use {safeIncreaseAllowance} and
555      * {safeDecreaseAllowance} instead.
556      */
557     function safeApprove(IERC20 token, address spender, uint256 value) internal {
558         // safeApprove should only be called when setting an initial allowance,
559         // or when resetting it to zero. To increase and decrease it, use
560         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
561         // solhint-disable-next-line max-line-length
562         require((value == 0) || (token.allowance(address(this), spender) == 0),
563             "SafeERC20: approve from non-zero to non-zero allowance"
564         );
565         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
566     }
567 
568     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
569         uint256 newAllowance = token.allowance(address(this), spender).add(value);
570         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
571     }
572 
573     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
574         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
575         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
576     }
577 
578     /**
579      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
580      * on the return value: the return value is optional (but if data is returned, it must not be false).
581      * @param token The token targeted by the call.
582      * @param data The call data (encoded using abi.encode or one of its variants).
583      */
584     function _callOptionalReturn(IERC20 token, bytes memory data) private {
585         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
586         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
587         // the target address contains contract code and also asserts for success in the low-level call.
588 
589         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
590         if (returndata.length > 0) { // Return data is optional
591             // solhint-disable-next-line max-line-length
592             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
593         }
594     }
595 }
596 
597 // File: contracts\IRewardDistributionRecipient.sol
598 
599 pragma solidity ^0.6.0;
600 
601 contract IRewardDistributionRecipient is Ownable {
602     address public rewardDistribution;
603 
604     function notifyRewardAmount(uint256 reward) virtual external{}
605 
606     modifier onlyRewardDistribution() {
607         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
608         _;
609     }
610 
611     function setRewardDistribution(address _rewardDistribution)
612         external
613         onlyOwner
614     {
615         rewardDistribution = _rewardDistribution;
616     }
617 }
618 
619 // File: contracts\fnt.sol
620 
621 pragma solidity ^0.6.0;
622 
623 contract LPTokenWrapper {
624     using SafeMath for uint256;
625     using SafeERC20 for IERC20;
626 
627     IERC20 public uni = IERC20(0x50e3D53b4a22e94ee1cE5c3A852D94d145d5852e);
628 
629     uint256 private _totalSupply;
630     mapping(address => uint256) private _balances;
631 
632     function totalSupply() public view returns (uint256) {
633         return _totalSupply;
634     }
635 
636     function balanceOf(address account) public view returns (uint256) {
637         return _balances[account];
638     }
639 
640     function stake(uint256 amount) public virtual {
641         _totalSupply = _totalSupply.add(amount);
642         _balances[msg.sender] = _balances[msg.sender].add(amount);
643         uni.safeTransferFrom(msg.sender, address(this), amount);
644     }
645 
646     function withdraw(uint256 amount) public virtual {
647         _totalSupply = _totalSupply.sub(amount);
648         _balances[msg.sender] = _balances[msg.sender].sub(amount);
649         uni.safeTransfer(msg.sender, amount);
650     }
651 }
652 
653 contract Unipool is LPTokenWrapper, IRewardDistributionRecipient {
654     IERC20 public fnt = IERC20(0xDc5864eDe28BD4405aa04d93E05A0531797D9D59);
655     uint256 public constant DURATION = 28 days;
656 
657     uint256 public periodFinish = 0;
658     uint256 public rewardRate = 0;
659     uint256 public lastUpdateTime;
660     uint256 public rewardPerTokenStored;
661     mapping(address => uint256) public userRewardPerTokenPaid;
662     mapping(address => uint256) public rewards;
663 
664     event RewardAdded(uint256 reward);
665     event Staked(address indexed user, uint256 amount);
666     event Withdrawn(address indexed user, uint256 amount);
667     event RewardPaid(address indexed user, uint256 reward);
668 
669     modifier updateReward(address account) {
670         rewardPerTokenStored = rewardPerToken();
671         lastUpdateTime = lastTimeRewardApplicable();
672         if (account != address(0)) {
673             rewards[account] = earned(account);
674             userRewardPerTokenPaid[account] = rewardPerTokenStored;
675         }
676         _;
677     }
678 
679     function lastTimeRewardApplicable() public view returns (uint256) {
680         return Math.min(block.timestamp, periodFinish);
681     }
682 
683     function rewardPerToken() public view returns (uint256) {
684         if (totalSupply() == 0) {
685             return rewardPerTokenStored;
686         }
687         return
688             rewardPerTokenStored.add(
689                 lastTimeRewardApplicable()
690                     .sub(lastUpdateTime)
691                     .mul(rewardRate)
692                     .mul(1e18)
693                     .div(totalSupply())
694             );
695     }
696 
697     function earned(address account) public view returns (uint256) {
698         return
699             balanceOf(account)
700                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
701                 .div(1e18)
702                 .add(rewards[account]);
703     }
704 
705     // stake visibility is public as overriding LPTokenWrapper's stake() function
706     function stake(uint256 amount) public override updateReward(msg.sender) {
707         require(amount > 0, "Cannot stake 0");
708         super.stake(amount);
709         emit Staked(msg.sender, amount);
710     }
711 
712     function withdraw(uint256 amount) public override updateReward(msg.sender) {
713         require(amount > 0, "Cannot withdraw 0");
714         super.withdraw(amount);
715         emit Withdrawn(msg.sender, amount);
716     }
717 
718     function exit() external {
719         withdraw(balanceOf(msg.sender));
720         getReward();
721     }
722 
723     function getReward() public updateReward(msg.sender) {
724         uint256 reward = earned(msg.sender);
725         if (reward > 0) {
726             rewards[msg.sender] = 0;
727             fnt.safeTransfer(msg.sender, reward);
728             emit RewardPaid(msg.sender, reward);
729         }
730     }
731 
732     function notifyRewardAmount(uint256 reward)
733         external
734         onlyRewardDistribution
735 	override
736         updateReward(address(0))
737     {
738         if (block.timestamp >= periodFinish) {
739             rewardRate = reward.div(DURATION);
740         } else {
741             uint256 remaining = periodFinish.sub(block.timestamp);
742             uint256 leftover = remaining.mul(rewardRate);
743             rewardRate = reward.add(leftover).div(DURATION);
744         }
745         lastUpdateTime = block.timestamp;
746         periodFinish = block.timestamp.add(DURATION);
747         emit RewardAdded(reward);
748     }
749 }