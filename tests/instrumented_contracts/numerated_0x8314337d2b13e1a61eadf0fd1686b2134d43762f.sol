1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/ownership/Ownable.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Contract module which provides a basic access control mechanism, where
37  * there is an account (an owner) that can be granted exclusive access to
38  * specific functions.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(isOwner(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Returns true if the caller is the current owner.
75      */
76     function isOwner() public view returns (bool) {
77         return _msgSender() == _owner;
78     }
79 
80     /**
81      * @dev Leaves the contract without owner. It will not be possible to call
82      * `onlyOwner` functions anymore. Can only be called by the current owner.
83      *
84      * NOTE: Renouncing ownership will leave the contract without an owner,
85      * thereby removing any functionality that is only available to the owner.
86      */
87     function renounceOwnership() public onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) public onlyOwner {
97         _transferOwnership(newOwner);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      */
103     function _transferOwnership(address newOwner) internal {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         emit OwnershipTransferred(_owner, newOwner);
106         _owner = newOwner;
107     }
108 }
109 
110 // File: localhost/contracts/IRewardDistributionRecipient.sol
111 
112 pragma solidity ^0.5.0;
113 
114 
115 
116 contract IRewardDistributionRecipient is Ownable {
117     address public rewardDistribution;
118 
119     function notifyRewardAmount(uint256 reward) external;
120 
121     modifier onlyRewardDistribution() {
122         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
123         _;
124     }
125 
126     function setRewardDistribution(address _rewardDistribution)
127         external
128         onlyOwner
129     {
130         rewardDistribution = _rewardDistribution;
131     }
132 }
133 // File: @openzeppelin/contracts/utils/Address.sol
134 
135 pragma solidity ^0.5.5;
136 
137 /**
138  * @dev Collection of functions related to the address type
139  */
140 library Address {
141     /**
142      * @dev Returns true if `account` is a contract.
143      *
144      * [IMPORTANT]
145      * ====
146      * It is unsafe to assume that an address for which this function returns
147      * false is an externally-owned account (EOA) and not a contract.
148      *
149      * Among others, `isContract` will return false for the following 
150      * types of addresses:
151      *
152      *  - an externally-owned account
153      *  - a contract in construction
154      *  - an address where a contract will be created
155      *  - an address where a contract lived, but was destroyed
156      * ====
157      */
158     function isContract(address account) internal view returns (bool) {
159         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
160         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
161         // for accounts without code, i.e. `keccak256('')`
162         bytes32 codehash;
163         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
164         // solhint-disable-next-line no-inline-assembly
165         assembly { codehash := extcodehash(account) }
166         return (codehash != accountHash && codehash != 0x0);
167     }
168 
169     /**
170      * @dev Converts an `address` into `address payable`. Note that this is
171      * simply a type cast: the actual underlying value is not changed.
172      *
173      * _Available since v2.4.0._
174      */
175     function toPayable(address account) internal pure returns (address payable) {
176         return address(uint160(account));
177     }
178 
179     /**
180      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
181      * `recipient`, forwarding all available gas and reverting on errors.
182      *
183      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
184      * of certain opcodes, possibly making contracts go over the 2300 gas limit
185      * imposed by `transfer`, making them unable to receive funds via
186      * `transfer`. {sendValue} removes this limitation.
187      *
188      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
189      *
190      * IMPORTANT: because control is transferred to `recipient`, care must be
191      * taken to not create reentrancy vulnerabilities. Consider using
192      * {ReentrancyGuard} or the
193      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
194      *
195      * _Available since v2.4.0._
196      */
197     function sendValue(address payable recipient, uint256 amount) internal {
198         require(address(this).balance >= amount, "Address: insufficient balance");
199 
200         // solhint-disable-next-line avoid-call-value
201         (bool success, ) = recipient.call.value(amount)("");
202         require(success, "Address: unable to send value, recipient may have reverted");
203     }
204 }
205 
206 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
207 
208 pragma solidity ^0.5.0;
209 
210 /**
211  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
212  * the optional functions; to access them see {ERC20Detailed}.
213  */
214 interface IERC20 {
215     /**
216      * @dev Returns the amount of tokens in existence.
217      */
218     function totalSupply() external view returns (uint256);
219 
220     /**
221      * @dev Returns the amount of tokens owned by `account`.
222      */
223     function balanceOf(address account) external view returns (uint256);
224 
225     /**
226      * @dev Moves `amount` tokens from the caller's account to `recipient`.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * Emits a {Transfer} event.
231      */
232     function transfer(address recipient, uint256 amount) external returns (bool);
233 
234     /**
235      * @dev Returns the remaining number of tokens that `spender` will be
236      * allowed to spend on behalf of `owner` through {transferFrom}. This is
237      * zero by default.
238      *
239      * This value changes when {approve} or {transferFrom} are called.
240      */
241     function allowance(address owner, address spender) external view returns (uint256);
242 
243     /**
244      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * IMPORTANT: Beware that changing an allowance with this method brings the risk
249      * that someone may use both the old and the new allowance by unfortunate
250      * transaction ordering. One possible solution to mitigate this race
251      * condition is to first reduce the spender's allowance to 0 and set the
252      * desired value afterwards:
253      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
254      *
255      * Emits an {Approval} event.
256      */
257     function approve(address spender, uint256 amount) external returns (bool);
258 
259     /**
260      * @dev Moves `amount` tokens from `sender` to `recipient` using the
261      * allowance mechanism. `amount` is then deducted from the caller's
262      * allowance.
263      *
264      * Returns a boolean value indicating whether the operation succeeded.
265      *
266      * Emits a {Transfer} event.
267      */
268     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
269 
270     /**
271      * @dev Emitted when `value` tokens are moved from one account (`from`) to
272      * another (`to`).
273      *
274      * Note that `value` may be zero.
275      */
276     event Transfer(address indexed from, address indexed to, uint256 value);
277 
278     /**
279      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
280      * a call to {approve}. `value` is the new allowance.
281      */
282     event Approval(address indexed owner, address indexed spender, uint256 value);
283 }
284 
285 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
286 
287 pragma solidity ^0.5.0;
288 
289 
290 
291 
292 /**
293  * @title SafeERC20
294  * @dev Wrappers around ERC20 operations that throw on failure (when the token
295  * contract returns false). Tokens that return no value (and instead revert or
296  * throw on failure) are also supported, non-reverting calls are assumed to be
297  * successful.
298  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
299  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
300  */
301 library SafeERC20 {
302     using SafeMath for uint256;
303     using Address for address;
304 
305     function safeTransfer(IERC20 token, address to, uint256 value) internal {
306         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
307     }
308 
309     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
310         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
311     }
312 
313     function safeApprove(IERC20 token, address spender, uint256 value) internal {
314         // safeApprove should only be called when setting an initial allowance,
315         // or when resetting it to zero. To increase and decrease it, use
316         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
317         // solhint-disable-next-line max-line-length
318         require((value == 0) || (token.allowance(address(this), spender) == 0),
319             "SafeERC20: approve from non-zero to non-zero allowance"
320         );
321         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
322     }
323 
324     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
325         uint256 newAllowance = token.allowance(address(this), spender).add(value);
326         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
327     }
328 
329     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
330         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
331         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
332     }
333 
334     /**
335      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
336      * on the return value: the return value is optional (but if data is returned, it must not be false).
337      * @param token The token targeted by the call.
338      * @param data The call data (encoded using abi.encode or one of its variants).
339      */
340     function callOptionalReturn(IERC20 token, bytes memory data) private {
341         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
342         // we're implementing it ourselves.
343 
344         // A Solidity high level call has three parts:
345         //  1. The target address is checked to verify it contains contract code
346         //  2. The call itself is made, and success asserted
347         //  3. The return value is decoded, which in turn checks the size of the returned data.
348         // solhint-disable-next-line max-line-length
349         require(address(token).isContract(), "SafeERC20: call to non-contract");
350 
351         // solhint-disable-next-line avoid-low-level-calls
352         (bool success, bytes memory returndata) = address(token).call(data);
353         require(success, "SafeERC20: low-level call failed");
354 
355         if (returndata.length > 0) { // Return data is optional
356             // solhint-disable-next-line max-line-length
357             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
358         }
359     }
360 }
361 
362 // File: @openzeppelin/contracts/math/SafeMath.sol
363 
364 pragma solidity ^0.5.0;
365 
366 /**
367  * @dev Wrappers over Solidity's arithmetic operations with added overflow
368  * checks.
369  *
370  * Arithmetic operations in Solidity wrap on overflow. This can easily result
371  * in bugs, because programmers usually assume that an overflow raises an
372  * error, which is the standard behavior in high level programming languages.
373  * `SafeMath` restores this intuition by reverting the transaction when an
374  * operation overflows.
375  *
376  * Using this library instead of the unchecked operations eliminates an entire
377  * class of bugs, so it's recommended to use it always.
378  */
379 library SafeMath {
380     /**
381      * @dev Returns the addition of two unsigned integers, reverting on
382      * overflow.
383      *
384      * Counterpart to Solidity's `+` operator.
385      *
386      * Requirements:
387      * - Addition cannot overflow.
388      */
389     function add(uint256 a, uint256 b) internal pure returns (uint256) {
390         uint256 c = a + b;
391         require(c >= a, "SafeMath: addition overflow");
392 
393         return c;
394     }
395 
396     /**
397      * @dev Returns the subtraction of two unsigned integers, reverting on
398      * overflow (when the result is negative).
399      *
400      * Counterpart to Solidity's `-` operator.
401      *
402      * Requirements:
403      * - Subtraction cannot overflow.
404      */
405     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
406         return sub(a, b, "SafeMath: subtraction overflow");
407     }
408 
409     /**
410      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
411      * overflow (when the result is negative).
412      *
413      * Counterpart to Solidity's `-` operator.
414      *
415      * Requirements:
416      * - Subtraction cannot overflow.
417      *
418      * _Available since v2.4.0._
419      */
420     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
421         require(b <= a, errorMessage);
422         uint256 c = a - b;
423 
424         return c;
425     }
426 
427     /**
428      * @dev Returns the multiplication of two unsigned integers, reverting on
429      * overflow.
430      *
431      * Counterpart to Solidity's `*` operator.
432      *
433      * Requirements:
434      * - Multiplication cannot overflow.
435      */
436     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
437         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
438         // benefit is lost if 'b' is also tested.
439         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
440         if (a == 0) {
441             return 0;
442         }
443 
444         uint256 c = a * b;
445         require(c / a == b, "SafeMath: multiplication overflow");
446 
447         return c;
448     }
449 
450     /**
451      * @dev Returns the integer division of two unsigned integers. Reverts on
452      * division by zero. The result is rounded towards zero.
453      *
454      * Counterpart to Solidity's `/` operator. Note: this function uses a
455      * `revert` opcode (which leaves remaining gas untouched) while Solidity
456      * uses an invalid opcode to revert (consuming all remaining gas).
457      *
458      * Requirements:
459      * - The divisor cannot be zero.
460      */
461     function div(uint256 a, uint256 b) internal pure returns (uint256) {
462         return div(a, b, "SafeMath: division by zero");
463     }
464 
465     /**
466      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
467      * division by zero. The result is rounded towards zero.
468      *
469      * Counterpart to Solidity's `/` operator. Note: this function uses a
470      * `revert` opcode (which leaves remaining gas untouched) while Solidity
471      * uses an invalid opcode to revert (consuming all remaining gas).
472      *
473      * Requirements:
474      * - The divisor cannot be zero.
475      *
476      * _Available since v2.4.0._
477      */
478     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
479         // Solidity only automatically asserts when dividing by 0
480         require(b > 0, errorMessage);
481         uint256 c = a / b;
482         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
483 
484         return c;
485     }
486 
487     /**
488      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
489      * Reverts when dividing by zero.
490      *
491      * Counterpart to Solidity's `%` operator. This function uses a `revert`
492      * opcode (which leaves remaining gas untouched) while Solidity uses an
493      * invalid opcode to revert (consuming all remaining gas).
494      *
495      * Requirements:
496      * - The divisor cannot be zero.
497      */
498     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
499         return mod(a, b, "SafeMath: modulo by zero");
500     }
501 
502     /**
503      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
504      * Reverts with custom message when dividing by zero.
505      *
506      * Counterpart to Solidity's `%` operator. This function uses a `revert`
507      * opcode (which leaves remaining gas untouched) while Solidity uses an
508      * invalid opcode to revert (consuming all remaining gas).
509      *
510      * Requirements:
511      * - The divisor cannot be zero.
512      *
513      * _Available since v2.4.0._
514      */
515     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
516         require(b != 0, errorMessage);
517         return a % b;
518     }
519 }
520 
521 // File: @openzeppelin/contracts/math/Math.sol
522 
523 pragma solidity ^0.5.0;
524 
525 /**
526  * @dev Standard math utilities missing in the Solidity language.
527  */
528 library Math {
529     /**
530      * @dev Returns the largest of two numbers.
531      */
532     function max(uint256 a, uint256 b) internal pure returns (uint256) {
533         return a >= b ? a : b;
534     }
535 
536     /**
537      * @dev Returns the smallest of two numbers.
538      */
539     function min(uint256 a, uint256 b) internal pure returns (uint256) {
540         return a < b ? a : b;
541     }
542 
543     /**
544      * @dev Returns the average of two numbers. The result is rounded towards
545      * zero.
546      */
547     function average(uint256 a, uint256 b) internal pure returns (uint256) {
548         // (a + b) / 2 can overflow, so we distribute
549         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
550     }
551 }
552 
553 // File: localhost/contracts/ReferralRewards.sol
554 
555 pragma solidity ^0.5.0;
556 
557 
558 
559 
560 
561 contract LPTokenWrapper {
562     using SafeMath for uint256;
563     using SafeERC20 for IERC20;
564 
565     IERC20 public uni = IERC20(0xFAE2809935233d4BfE8a56c2355c4A2e7d1fFf1A);
566 
567     uint256 private _totalSupply;
568     mapping(address => uint256) private _balances;
569 
570     function totalSupply() public view returns (uint256) {
571         return _totalSupply;
572     }
573 
574     function balanceOf(address account) public view returns (uint256) {
575         return _balances[account];
576     }
577 
578     function stake(uint256 amount) public {
579         _totalSupply = _totalSupply.add(amount);
580         _balances[msg.sender] = _balances[msg.sender].add(amount);
581         uni.safeTransferFrom(msg.sender, address(this), amount);
582     }
583 
584     function withdraw(uint256 amount) public {
585         _totalSupply = _totalSupply.sub(amount);
586         _balances[msg.sender] = _balances[msg.sender].sub(amount);
587         uni.safeTransfer(msg.sender, amount);
588     }
589 }
590 
591 contract ReferralRewards is LPTokenWrapper, IRewardDistributionRecipient {
592     IERC20 public dough = IERC20(0xad32A8e6220741182940c5aBF610bDE99E737b2D);
593     uint256 public constant DURATION = 7 days;
594 
595     uint256 public periodFinish = 0;
596     uint256 public rewardRate = 0;
597     uint256 public lastUpdateTime;
598     uint256 public rewardPerTokenStored;
599     mapping(address => uint256) public userRewardPerTokenPaid;
600     mapping(address => uint256) public rewards;
601 
602     event RewardAdded(uint256 reward);
603     event Staked(address indexed user, uint256 amount);
604     event Withdrawn(address indexed user, uint256 amount);
605     event RewardPaid(address indexed user, uint256 reward);
606     event ReferralSet(address indexed user, address indexed referral);
607     event ReferralReward(address indexed user, address indexed referral, uint256 amount);
608 
609     mapping(address => address) public referralOf;
610     // 1%
611     uint256 referralPercentage = 1 * 10 ** 16;
612 
613     modifier updateReward(address account) {
614         rewardPerTokenStored = rewardPerToken();
615         lastUpdateTime = lastTimeRewardApplicable();
616         if (account != address(0)) {
617             rewards[account] = earned(account);
618             userRewardPerTokenPaid[account] = rewardPerTokenStored;
619         }
620         _;
621     }
622 
623     function lastTimeRewardApplicable() public view returns (uint256) {
624         return Math.min(block.timestamp, periodFinish);
625     }
626 
627     function rewardPerToken() public view returns (uint256) {
628         if (totalSupply() == 0) {
629             return rewardPerTokenStored;
630         }
631         return
632             rewardPerTokenStored.add(
633                 lastTimeRewardApplicable()
634                     .sub(lastUpdateTime)
635                     .mul(rewardRate)
636                     .mul(1e18)
637                     .div(totalSupply())
638             );
639     }
640 
641     function earned(address account) public view returns (uint256) {
642         return
643             balanceOf(account)
644                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
645                 .div(1e18)
646                 .add(rewards[account]);
647     }
648 
649     // stake visibility is public as overriding LPTokenWrapper's stake() function
650     function stake(uint256 amount) public updateReward(msg.sender) {
651         require(amount > 0, "Cannot stake 0");
652         super.stake(amount);
653         emit Staked(msg.sender, amount);
654     }
655 
656     function stake(uint256 amount, address referral) public {
657         stake(amount);
658         
659         // Only set if referral is not set yet
660         if(referralOf[msg.sender] == address(0) && referral != msg.sender && referral != address(0)) {
661             referralOf[msg.sender] = referral;
662             emit ReferralSet(msg.sender, referral);
663         }
664     }
665 
666     function withdraw(uint256 amount) public updateReward(msg.sender) {
667         require(amount > 0, "Cannot withdraw 0");
668         super.withdraw(amount);
669         emit Withdrawn(msg.sender, amount);
670     }
671 
672     function exit() external {
673         withdraw(balanceOf(msg.sender));
674         getReward();
675     }
676 
677     function getReward() public updateReward(msg.sender) {
678         uint256 reward = earned(msg.sender);
679         if (reward > 0) {
680             rewards[msg.sender] = 0;
681             dough.safeTransfer(msg.sender, reward);
682             emit RewardPaid(msg.sender, reward);
683         }
684 
685         if(referralOf[msg.sender] != address(0)) {
686             address referral = referralOf[msg.sender];
687             uint256 referralReward = reward.mul(referralPercentage).div(10**18);
688             rewards[referral] = rewards[referral].add(referralReward);
689             emit ReferralReward(msg.sender, referral, referralReward);
690         }
691     }
692 
693     function notifyRewardAmount(uint256 reward)
694         external
695         onlyRewardDistribution
696         updateReward(address(0))
697     {
698         if (block.timestamp >= periodFinish) {
699             rewardRate = reward.div(DURATION);
700         } else {
701             uint256 remaining = periodFinish.sub(block.timestamp);
702             uint256 leftover = remaining.mul(rewardRate);
703             rewardRate = reward.add(leftover).div(DURATION);
704         }
705         lastUpdateTime = block.timestamp;
706         periodFinish = block.timestamp.add(DURATION);
707         emit RewardAdded(reward);
708     }
709 
710     function saveToken(address _token) external {
711         require(_token != address(dough) && _token != address(uni), "INVALID_TOKEN");
712 
713         IERC20 token = IERC20(_token);
714 
715         token.transfer(address(0x4efD8CEad66bb0fA64C8d53eBE65f31663199C6d), token.balanceOf(address(this)));
716     }
717 }