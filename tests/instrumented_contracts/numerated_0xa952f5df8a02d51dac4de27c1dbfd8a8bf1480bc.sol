1 pragma solidity ^0.5.0;
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
31 // File: @openzeppelin/contracts/math/SafeMath.sol
32 
33 pragma solidity ^0.5.0;
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
48 library SafeMath {
49     /**
50      * @dev Returns the addition of two unsigned integers, reverting on
51      * overflow.
52      *
53      * Counterpart to Solidity's `+` operator.
54      *
55      * Requirements:
56      * - Addition cannot overflow.
57      */
58     function add(uint256 a, uint256 b) internal pure returns (uint256) {
59         uint256 c = a + b;
60         require(c >= a, "SafeMath: addition overflow");
61 
62         return c;
63     }
64 
65     /**
66      * @dev Returns the subtraction of two unsigned integers, reverting on
67      * overflow (when the result is negative).
68      *
69      * Counterpart to Solidity's `-` operator.
70      *
71      * Requirements:
72      * - Subtraction cannot overflow.
73      */
74     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75         return sub(a, b, "SafeMath: subtraction overflow");
76     }
77 
78     /**
79      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
80      * overflow (when the result is negative).
81      *
82      * Counterpart to Solidity's `-` operator.
83      *
84      * Requirements:
85      * - Subtraction cannot overflow.
86      *
87      * _Available since v2.4.0._
88      */
89     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
90         require(b <= a, errorMessage);
91         uint256 c = a - b;
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the multiplication of two unsigned integers, reverting on
98      * overflow.
99      *
100      * Counterpart to Solidity's `*` operator.
101      *
102      * Requirements:
103      * - Multiplication cannot overflow.
104      */
105     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
106         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
107         // benefit is lost if 'b' is also tested.
108         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
109         if (a == 0) {
110             return 0;
111         }
112 
113         uint256 c = a * b;
114         require(c / a == b, "SafeMath: multiplication overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the integer division of two unsigned integers. Reverts on
121      * division by zero. The result is rounded towards zero.
122      *
123      * Counterpart to Solidity's `/` operator. Note: this function uses a
124      * `revert` opcode (which leaves remaining gas untouched) while Solidity
125      * uses an invalid opcode to revert (consuming all remaining gas).
126      *
127      * Requirements:
128      * - The divisor cannot be zero.
129      */
130     function div(uint256 a, uint256 b) internal pure returns (uint256) {
131         return div(a, b, "SafeMath: division by zero");
132     }
133 
134     /**
135      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
136      * division by zero. The result is rounded towards zero.
137      *
138      * Counterpart to Solidity's `/` operator. Note: this function uses a
139      * `revert` opcode (which leaves remaining gas untouched) while Solidity
140      * uses an invalid opcode to revert (consuming all remaining gas).
141      *
142      * Requirements:
143      * - The divisor cannot be zero.
144      *
145      * _Available since v2.4.0._
146      */
147     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
148         // Solidity only automatically asserts when dividing by 0
149         require(b > 0, errorMessage);
150         uint256 c = a / b;
151         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
158      * Reverts when dividing by zero.
159      *
160      * Counterpart to Solidity's `%` operator. This function uses a `revert`
161      * opcode (which leaves remaining gas untouched) while Solidity uses an
162      * invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
168         return mod(a, b, "SafeMath: modulo by zero");
169     }
170 
171     /**
172      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
173      * Reverts with custom message when dividing by zero.
174      *
175      * Counterpart to Solidity's `%` operator. This function uses a `revert`
176      * opcode (which leaves remaining gas untouched) while Solidity uses an
177      * invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      *
182      * _Available since v2.4.0._
183      */
184     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         require(b != 0, errorMessage);
186         return a % b;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/GSN/Context.sol
191 
192 pragma solidity ^0.5.0;
193 
194 /*
195  * @dev Provides information about the current execution context, including the
196  * sender of the transaction and its data. While these are generally available
197  * via msg.sender and msg.data, they should not be accessed in such a direct
198  * manner, since when dealing with GSN meta-transactions the account sending and
199  * paying for execution may not be the actual sender (as far as an application
200  * is concerned).
201  *
202  * This contract is only required for intermediate, library-like contracts.
203  */
204 contract Context {
205     // Empty internal constructor, to prevent people from mistakenly deploying
206     // an instance of this contract, which should be used via inheritance.
207     constructor () internal {}
208     // solhint-disable-previous-line no-empty-blocks
209 
210     function _msgSender() internal view returns (address payable) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view returns (bytes memory) {
215         this;
216         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
217         return msg.data;
218     }
219 }
220 
221 // File: @openzeppelin/contracts/ownership/Ownable.sol
222 
223 pragma solidity ^0.5.0;
224 
225 /**
226  * @dev Contract module which provides a basic access control mechanism, where
227  * there is an account (an owner) that can be granted exclusive access to
228  * specific functions.
229  *
230  * This module is used through inheritance. It will make available the modifier
231  * `onlyOwner`, which can be applied to your functions to restrict their use to
232  * the owner.
233  */
234 contract Ownable is Context {
235     address private _owner;
236 
237     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
238 
239     /**
240      * @dev Initializes the contract setting the deployer as the initial owner.
241      */
242     constructor () internal {
243         _owner = _msgSender();
244         emit OwnershipTransferred(address(0), _owner);
245     }
246 
247     /**
248      * @dev Returns the address of the current owner.
249      */
250     function owner() public view returns (address) {
251         return _owner;
252     }
253 
254     /**
255      * @dev Throws if called by any account other than the owner.
256      */
257     modifier onlyOwner() {
258         require(isOwner(), "Ownable: caller is not the owner");
259         _;
260     }
261 
262     /**
263      * @dev Returns true if the caller is the current owner.
264      */
265     function isOwner() public view returns (bool) {
266         return _msgSender() == _owner;
267     }
268 
269     /**
270      * @dev Leaves the contract without owner. It will not be possible to call
271      * `onlyOwner` functions anymore. Can only be called by the current owner.
272      *
273      * NOTE: Renouncing ownership will leave the contract without an owner,
274      * thereby removing any functionality that is only available to the owner.
275      */
276     function renounceOwnership() public onlyOwner {
277         emit OwnershipTransferred(_owner, address(0));
278         _owner = address(0);
279     }
280 
281     /**
282      * @dev Transfers ownership of the contract to a new account (`newOwner`).
283      * Can only be called by the current owner.
284      */
285     function transferOwnership(address newOwner) public onlyOwner {
286         _transferOwnership(newOwner);
287     }
288 
289     /**
290      * @dev Transfers ownership of the contract to a new account (`newOwner`).
291      */
292     function _transferOwnership(address newOwner) internal {
293         require(newOwner != address(0), "Ownable: new owner is the zero address");
294         emit OwnershipTransferred(_owner, newOwner);
295         _owner = newOwner;
296     }
297 }
298 
299 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
300 
301 pragma solidity ^0.5.0;
302 
303 /**
304  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
305  * the optional functions; to access them see {ERC20Detailed}.
306  */
307 interface IERC20 {
308     /**
309      * @dev Returns the amount of tokens in existence.
310      */
311     function totalSupply() external view returns (uint256);
312 
313     /**
314      * @dev Returns the amount of tokens owned by `account`.
315      */
316     function balanceOf(address account) external view returns (uint256);
317 
318     /**
319      * @dev Moves `amount` tokens from the caller's account to `recipient`.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * Emits a {Transfer} event.
324      */
325     function transfer(address recipient, uint256 amount) external returns (bool);
326 
327     function mint(address account, uint amount) external;
328 
329     /**
330      * @dev Returns the remaining number of tokens that `spender` will be
331      * allowed to spend on behalf of `owner` through {transferFrom}. This is
332      * zero by default.
333      *
334      * This value changes when {approve} or {transferFrom} are called.
335      */
336     function allowance(address owner, address spender) external view returns (uint256);
337 
338     /**
339      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
340      *
341      * Returns a boolean value indicating whether the operation succeeded.
342      *
343      * IMPORTANT: Beware that changing an allowance with this method brings the risk
344      * that someone may use both the old and the new allowance by unfortunate
345      * transaction ordering. One possible solution to mitigate this race
346      * condition is to first reduce the spender's allowance to 0 and set the
347      * desired value afterwards:
348      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
349      *
350      * Emits an {Approval} event.
351      */
352     function approve(address spender, uint256 amount) external returns (bool);
353 
354     /**
355      * @dev Moves `amount` tokens from `sender` to `recipient` using the
356      * allowance mechanism. `amount` is then deducted from the caller's
357      * allowance.
358      *
359      * Returns a boolean value indicating whether the operation succeeded.
360      *
361      * Emits a {Transfer} event.
362      */
363     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
364 
365     /**
366      * @dev Emitted when `value` tokens are moved from one account (`from`) to
367      * another (`to`).
368      *
369      * Note that `value` may be zero.
370      */
371     event Transfer(address indexed from, address indexed to, uint256 value);
372 
373     /**
374      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
375      * a call to {approve}. `value` is the new allowance.
376      */
377     event Approval(address indexed owner, address indexed spender, uint256 value);
378 }
379 
380 // File: @openzeppelin/contracts/utils/Address.sol
381 
382 pragma solidity ^0.5.5;
383 
384 /**
385  * @dev Collection of functions related to the address type
386  */
387 library Address {
388     /**
389      * @dev Returns true if `account` is a contract.
390      *
391      * This test is non-exhaustive, and there may be false-negatives: during the
392      * execution of a contract's constructor, its address will be reported as
393      * not containing a contract.
394      *
395      * IMPORTANT: It is unsafe to assume that an address for which this
396      * function returns false is an externally-owned account (EOA) and not a
397      * contract.
398      */
399     function isContract(address account) internal view returns (bool) {
400         // This method relies in extcodesize, which returns 0 for contracts in
401         // construction, since the code is only stored at the end of the
402         // constructor execution.
403 
404         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
405         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
406         // for accounts without code, i.e. `keccak256('')`
407         bytes32 codehash;
408         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
409         // solhint-disable-next-line no-inline-assembly
410         assembly {codehash := extcodehash(account)}
411         return (codehash != 0x0 && codehash != accountHash);
412     }
413 
414     /**
415      * @dev Converts an `address` into `address payable`. Note that this is
416      * simply a type cast: the actual underlying value is not changed.
417      *
418      * _Available since v2.4.0._
419      */
420     function toPayable(address account) internal pure returns (address payable) {
421         return address(uint160(account));
422     }
423 
424     /**
425      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
426      * `recipient`, forwarding all available gas and reverting on errors.
427      *
428      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
429      * of certain opcodes, possibly making contracts go over the 2300 gas limit
430      * imposed by `transfer`, making them unable to receive funds via
431      * `transfer`. {sendValue} removes this limitation.
432      *
433      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
434      *
435      * IMPORTANT: because control is transferred to `recipient`, care must be
436      * taken to not create reentrancy vulnerabilities. Consider using
437      * {ReentrancyGuard} or the
438      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
439      *
440      * _Available since v2.4.0._
441      */
442     function sendValue(address payable recipient, uint256 amount) internal {
443         require(address(this).balance >= amount, "Address: insufficient balance");
444 
445         // solhint-disable-next-line avoid-call-value
446         (bool success,) = recipient.call.value(amount)("");
447         require(success, "Address: unable to send value, recipient may have reverted");
448     }
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
452 
453 pragma solidity ^0.5.0;
454 
455 /**
456  * @title SafeERC20
457  * @dev Wrappers around ERC20 operations that throw on failure (when the token
458  * contract returns false). Tokens that return no value (and instead revert or
459  * throw on failure) are also supported, non-reverting calls are assumed to be
460  * successful.
461  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
462  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
463  */
464 library SafeERC20 {
465     using SafeMath for uint256;
466     using Address for address;
467 
468     function safeTransfer(IERC20 token, address to, uint256 value) internal {
469         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
470     }
471 
472     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
473         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
474     }
475 
476     function safeApprove(IERC20 token, address spender, uint256 value) internal {
477         // safeApprove should only be called when setting an initial allowance,
478         // or when resetting it to zero. To increase and decrease it, use
479         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
480         // solhint-disable-next-line max-line-length
481         require((value == 0) || (token.allowance(address(this), spender) == 0),
482             "SafeERC20: approve from non-zero to non-zero allowance"
483         );
484         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
485     }
486 
487     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
488         uint256 newAllowance = token.allowance(address(this), spender).add(value);
489         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
490     }
491 
492     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
493         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
494         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
495     }
496 
497     /**
498      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
499      * on the return value: the return value is optional (but if data is returned, it must not be false).
500      * @param token The token targeted by the call.
501      * @param data The call data (encoded using abi.encode or one of its variants).
502      */
503     function callOptionalReturn(IERC20 token, bytes memory data) private {
504         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
505         // we're implementing it ourselves.
506 
507         // A Solidity high level call has three parts:
508         //  1. The target address is checked to verify it contains contract code
509         //  2. The call itself is made, and success asserted
510         //  3. The return value is decoded, which in turn checks the size of the returned data.
511         // solhint-disable-next-line max-line-length
512         require(address(token).isContract(), "SafeERC20: call to non-contract");
513 
514         // solhint-disable-next-line avoid-low-level-calls
515         (bool success, bytes memory returndata) = address(token).call(data);
516         require(success, "SafeERC20: low-level call failed");
517 
518         if (returndata.length > 0) {// Return data is optional
519             // solhint-disable-next-line max-line-length
520             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
521         }
522     }
523 }
524 
525 // File: contracts/IGovernanceAddressRecipient.sol
526 
527 pragma solidity ^0.5.0;
528 
529 contract IGovernanceAddressRecipient is Ownable {
530     address GovernanceAddress;
531 
532     modifier onlyGovernanceAddress() {
533         require(_msgSender() == GovernanceAddress, "Caller is not reward distribution");
534         _;
535     }
536 
537     function setGovernanceAddress(address _GovernanceAddress)
538     external
539     onlyOwner
540     {
541         GovernanceAddress = _GovernanceAddress;
542     }
543 }
544 
545 // File: contracts/Rewards.sol
546 
547 pragma solidity ^0.5.0;
548 
549 contract StakeTokenWrapper {
550     using SafeMath for uint256;
551     using SafeERC20 for IERC20;
552 
553     IERC20 public stakeToken;
554 
555     uint256 private _totalSupply;
556     mapping(address => uint256) private _balances;
557 
558     constructor(address _stakeToken) public {
559         stakeToken = IERC20(_stakeToken);
560     }
561 
562     function totalSupply() public view returns (uint256) {
563         return _totalSupply;
564     }
565 
566     function balanceOf(address account) public view returns (uint256) {
567         return _balances[account];
568     }
569 
570     function stake(uint256 amount) public {
571         _totalSupply = _totalSupply.add(amount);
572         _balances[msg.sender] = _balances[msg.sender].add(amount);
573         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
574     }
575 
576     function withdraw(uint256 amount) public {
577         _totalSupply = _totalSupply.sub(amount);
578         _balances[msg.sender] = _balances[msg.sender].sub(amount);
579         stakeToken.safeTransfer(msg.sender, amount);
580     }
581 }
582 
583 contract FeVaultV1 is StakeTokenWrapper(0x1C48b1DEF1404750359D3ff5a765a90C3F702999), IGovernanceAddressRecipient {
584 
585     IERC20 public FECORE = IERC20(0x704b5267FAE30C40Fd0A4b14D83E414B4A920afA);
586 
587     uint256 public constant DURATION = 180 days;
588 
589     uint256 public initReward = 0;
590     uint256 public startTime = 0;
591     uint256 public periodFinish = 0;
592     uint256 public rewardRate = 0;
593     uint256 public lastUpdateTime;
594     bool public stakeable = false;
595     uint256 public rewardPerTokenStored;
596     mapping(address => uint256) public userRewardPerTokenPaid;
597     mapping(address => uint256) public rewards;
598 
599     event DepositStake(uint256 reward);
600     event StartStaking(uint256 time);
601     event StopStaking(uint256 time);
602     event Staked(address indexed user, uint256 amount);
603     event Withdrawn(address indexed user, uint256 amount);
604     event RewardPaid(address indexed user, uint256 reward);
605 
606     modifier updateReward(address account) {
607         rewardPerTokenStored = rewardPerToken();
608         lastUpdateTime = lastTimeRewardApplicable();
609         if (account != address(0)) {
610             rewards[account] = earned(account);
611             userRewardPerTokenPaid[account] = rewardPerTokenStored;
612         }
613         _;
614     }
615 
616     modifier checkStart(){
617         require(
618             initReward > 0,
619             "No reward to stake."
620         );
621         require(
622             stakeable,
623             "Staking is not started."
624         );
625         _;
626     }
627 
628     constructor() public {
629         GovernanceAddress = msg.sender;
630     }
631 
632     function lastTimeRewardApplicable() public view returns (uint256) {
633         return Math.min(block.timestamp, periodFinish);
634     }
635 
636     function remainingReward() public view returns (uint256) {
637         return FECORE.balanceOf(address(this));
638     }
639 
640     function stop() public onlyGovernanceAddress {
641         require(stakeable, "Staking is not started.");
642         FECORE.safeTransfer(address(0x489B689850999F751760a38d03693Bd979C4A690), remainingReward());
643         stakeable = false;
644         initReward = 0;
645         rewardRate = 0;
646         emit StopStaking(block.timestamp);
647     }
648 
649     function rewardPerToken() public view returns (uint256) {
650         if (totalSupply() == 0) {
651             return rewardPerTokenStored;
652         }
653         return rewardPerTokenStored.add(
654             lastTimeRewardApplicable()
655             .sub(lastUpdateTime)
656             .mul(rewardRate)
657             .mul(1e18)
658             .div(totalSupply())
659         );
660     }
661 
662     function earned(address account) public view returns (uint256) {
663         return balanceOf(account)
664         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
665         .div(1e18)
666         .add(rewards[account]);
667     }
668 
669     function start() public onlyGovernanceAddress {
670         require(!stakeable, "Staking is started.");
671         require(initReward > 0, "Cannot start. Require initReward");
672         periodFinish = block.timestamp.add(DURATION);
673         stakeable = true;
674         startTime = block.timestamp;
675         emit StartStaking(block.timestamp);
676     }
677 
678     function depositReward(uint256 amount) public onlyGovernanceAddress {
679         require(!stakeable, "Staking is started.");
680         require(amount > 0, "Cannot deposit 0");
681         FECORE.safeTransferFrom(msg.sender, address(this), amount);
682         initReward = amount;
683         rewardRate = initReward.div(DURATION);
684         emit DepositStake(amount);
685     }
686 
687     // stake visibility is public as overriding LPTokenWrapper's stake() function
688     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
689         require(amount > 0, "Cannot stake 0");
690         super.stake(amount);
691         emit Staked(msg.sender, amount);
692     }
693 
694     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
695         require(amount > 0, "Cannot withdraw 0");
696         super.withdraw(amount);
697         emit Withdrawn(msg.sender, amount);
698     }
699 
700     function exitStake() external {
701         withdraw(balanceOf(msg.sender));
702         getReward();
703     }
704 
705     function getReward() public updateReward(msg.sender) checkStart {
706         uint256 reward = earned(msg.sender);
707         if (reward > 0) {
708             rewards[msg.sender] = 0;
709             FECORE.safeTransfer(msg.sender, reward);
710             emit RewardPaid(msg.sender, reward);
711         }
712     }
713 }