1 //"SPDX-License-Identifier: MIT"
2 // File: @openzeppelin/contracts/math/Math.sol
3 pragma solidity ^0.7.5;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     /**
10      * @dev Returns the largest of two numbers.
11      */
12     function max(uint256 a, uint256 b) internal pure returns (uint256) {
13         return a >= b ? a : b;
14     }
15 
16     /**
17      * @dev Returns the smallest of two numbers.
18      */
19     function min(uint256 a, uint256 b) internal pure returns (uint256) {
20         return a < b ? a : b;
21     }
22 
23     /**
24      * @dev Returns the average of two numbers. The result is rounded towards
25      * zero.
26      */
27     function average(uint256 a, uint256 b) internal pure returns (uint256) {
28         // (a + b) / 2 can overflow, so we distribute
29         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
30     }
31 }
32 
33 // File: @openzeppelin/contracts/math/SafeMath.sol
34 /**
35  * @dev Wrappers over Solidity's arithmetic operations with added overflow
36  * checks.
37  *
38  * Arithmetic operations in Solidity wrap on overflow. This can easily result
39  * in bugs, because programmers usually assume that an overflow raises an
40  * error, which is the standard behavior in high level programming languages.
41  * `SafeMath` restores this intuition by reverting the transaction when an
42  * operation overflows.
43  *
44  * Using this library instead of the unchecked operations eliminates an entire
45  * class of bugs, so it's recommended to use it always.
46  */
47 library SafeMath {
48     /**
49      * @dev Returns the addition of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `+` operator.
53      *
54      * Requirements:
55      * - Addition cannot overflow.
56      */
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      * - Subtraction cannot overflow.
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      * - Subtraction cannot overflow.
85      *
86      * _Available since v2.4.0._
87      */
88     function sub(
89         uint256 a,
90         uint256 b,
91         string memory errorMessage
92     ) internal pure returns (uint256) {
93         require(b <= a, errorMessage);
94         uint256 c = a - b;
95 
96         return c;
97     }
98 
99     /**
100      * @dev Returns the multiplication of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `*` operator.
104      *
105      * Requirements:
106      * - Multiplication cannot overflow.
107      */
108     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
110         // benefit is lost if 'b' is also tested.
111         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
112         if (a == 0) {
113             return 0;
114         }
115 
116         uint256 c = a * b;
117         require(c / a == b, "SafeMath: multiplication overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the integer division of two unsigned integers. Reverts on
124      * division by zero. The result is rounded towards zero.
125      *
126      * Counterpart to Solidity's `/` operator. Note: this function uses a
127      * `revert` opcode (which leaves remaining gas untouched) while Solidity
128      * uses an invalid opcode to revert (consuming all remaining gas).
129      *
130      * Requirements:
131      * - The divisor cannot be zero.
132      */
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136 
137     /**
138      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
139      * division by zero. The result is rounded towards zero.
140      *
141      * Counterpart to Solidity's `/` operator. Note: this function uses a
142      * `revert` opcode (which leaves remaining gas untouched) while Solidity
143      * uses an invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      * - The divisor cannot be zero.
147      *
148      * _Available since v2.4.0._
149      */
150     function div(
151         uint256 a,
152         uint256 b,
153         string memory errorMessage
154     ) internal pure returns (uint256) {
155         // Solidity only automatically asserts when dividing by 0
156         require(b > 0, errorMessage);
157         uint256 c = a / b;
158         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
165      * Reverts when dividing by zero.
166      *
167      * Counterpart to Solidity's `%` operator. This function uses a `revert`
168      * opcode (which leaves remaining gas untouched) while Solidity uses an
169      * invalid opcode to revert (consuming all remaining gas).
170      *
171      * Requirements:
172      * - The divisor cannot be zero.
173      */
174     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
175         return mod(a, b, "SafeMath: modulo by zero");
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
180      * Reverts with custom message when dividing by zero.
181      *
182      * Counterpart to Solidity's `%` operator. This function uses a `revert`
183      * opcode (which leaves remaining gas untouched) while Solidity uses an
184      * invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      * - The divisor cannot be zero.
188      *
189      * _Available since v2.4.0._
190      */
191     function mod(
192         uint256 a,
193         uint256 b,
194         string memory errorMessage
195     ) internal pure returns (uint256) {
196         require(b != 0, errorMessage);
197         return a % b;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/GSN/Context.sol
202 /*
203  * @dev Provides information about the current execution context, including the
204  * sender of the transaction and its data. While these are generally available
205  * via msg.sender and msg.data, they should not be accessed in such a direct
206  * manner, since when dealing with GSN meta-transactions the account sending and
207  * paying for execution may not be the actual sender (as far as an application
208  * is concerned).
209  *
210  * This contract is only required for intermediate, library-like contracts.
211  */
212 contract Context {
213     // Empty internal constructor, to prevent people from mistakenly deploying an instance of this contract, which should be used via inheritance.
214     constructor() {
215         //require(false, "Context contract: Do not deploy");
216     }
217 
218     // solhint-disable-previous-line no-empty-blocks
219 
220     function _msgSender() internal view returns (address payable) {
221         return msg.sender;
222     }
223 
224     function _msgData() internal view returns (bytes memory) {
225         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
226         return msg.data;
227     }
228 }
229 
230 // File: @openzeppelin/contracts/ownership/Ownable.sol
231 /**
232  * @dev Contract module which provides a basic access control mechanism, where
233  * there is an account (an owner) that can be granted exclusive access to
234  * specific functions.
235  *
236  * This module is used through inheritance. It will make available the modifier
237  * `onlyOwner`, which can be applied to your functions to restrict their use to
238  * the owner.
239  */
240 contract Ownable is Context {
241     address private _owner;
242 
243     event OwnershipTransferred(
244         address indexed previousOwner,
245         address indexed newOwner
246     );
247 
248     /**
249      * @dev Initializes the contract setting the deployer as the initial owner.
250      */
251     constructor() {
252         _owner = _msgSender();
253         emit OwnershipTransferred(address(0), _owner);
254     }
255 
256     /**
257      * @dev Returns the address of the current owner.
258      */
259     function owner() public view returns (address) {
260         return _owner;
261     }
262 
263     /**
264      * @dev Throws if called by any account other than the owner.
265      */
266     modifier onlyOwner() {
267         require(isOwner(), "Ownable: caller is not the owner");
268         _;
269     }
270 
271     /**
272      * @dev Returns true if the caller is the current owner.
273      */
274     function isOwner() public view returns (bool) {
275         return _msgSender() == _owner;
276     }
277 
278     /**
279      * @dev Leaves the contract without owner. It will not be possible to call
280      * `onlyOwner` functions anymore. Can only be called by the current owner.
281      *
282      * NOTE: Renouncing ownership will leave the contract without an owner,
283      * thereby removing any functionality that is only available to the owner.
284      */
285     function renounceOwnership() public onlyOwner {
286         emit OwnershipTransferred(_owner, address(0));
287         _owner = address(0);
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      * Can only be called by the current owner.
293      */
294     function transferOwnership(address newOwner) public onlyOwner {
295         _transferOwnership(newOwner);
296     }
297 
298     /**
299      * @dev Transfers ownership of the contract to a new account (`newOwner`).
300      */
301     function _transferOwnership(address newOwner) internal {
302         require(
303             newOwner != address(0),
304             "Ownable: new owner is the zero address"
305         );
306         emit OwnershipTransferred(_owner, newOwner);
307         _owner = newOwner;
308     }
309 }
310 
311 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
312 /**
313  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
314  * the optional functions; to access them see {ERC20Detailed}.
315  */
316 interface IERC20 {
317     /**
318      * @dev Returns the amount of tokens in existence.
319      */
320     function totalSupply() external view returns (uint256);
321 
322     /**
323      * @dev Returns the amount of tokens owned by `account`.
324      */
325     function balanceOf(address account) external view returns (uint256);
326 
327     /**
328      * @dev Moves `amount` tokens from the caller's account to `recipient`.
329      *
330      * Returns a boolean value indicating whether the operation succeeded.
331      *
332      * Emits a {Transfer} event.
333      */
334     function transfer(address recipient, uint256 amount)
335         external
336         returns (bool);
337 
338     /**
339      * @dev Returns the remaining number of tokens that `spender` will be
340      * allowed to spend on behalf of `owner` through {transferFrom}. This is
341      * zero by default.
342      *
343      * This value changes when {approve} or {transferFrom} are called.
344      */
345     function allowance(address owner, address spender)
346         external
347         view
348         returns (uint256);
349 
350     /**
351      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * IMPORTANT: Beware that changing an allowance with this method brings the risk
356      * that someone may use both the old and the new allowance by unfortunate
357      * transaction ordering. One possible solution to mitigate this race
358      * condition is to first reduce the spender's allowance to 0 and set the
359      * desired value afterwards:
360      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
361      *
362      * Emits an {Approval} event.
363      */
364     function approve(address spender, uint256 amount) external returns (bool);
365 
366     /**
367      * @dev Moves `amount` tokens from `sender` to `recipient` using the
368      * allowance mechanism. `amount` is then deducted from the caller's
369      * allowance.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * Emits a {Transfer} event.
374      */
375     function transferFrom(
376         address sender,
377         address recipient,
378         uint256 amount
379     ) external returns (bool);
380 
381     /**
382      * @dev Emitted when `value` tokens are moved from one account (`from`) to
383      * another (`to`).
384      *
385      * Note that `value` may be zero.
386      */
387     event Transfer(address indexed from, address indexed to, uint256 value);
388 
389     /**
390      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
391      * a call to {approve}. `value` is the new allowance.
392      */
393     event Approval(
394         address indexed owner,
395         address indexed spender,
396         uint256 value
397     );
398 }
399 
400 // File: @openzeppelin/contracts/utils/Address.sol
401 /**
402  * @dev Collection of functions related to the address type
403  */
404 library Address {
405     /**
406      * @dev Returns true if `account` is a contract.
407      *
408      * This test is non-exhaustive, and there may be false-negatives: during the
409      * execution of a contract's constructor, its address will be reported as
410      * not containing a contract.
411      *
412      * IMPORTANT: It is unsafe to assume that an address for which this
413      * function returns false is an externally-owned account (EOA) and not a
414      * contract.
415      */
416     function isContract(address account) internal view returns (bool) {
417         // This method relies in extcodesize, which returns 0 for contracts in
418         // construction, since the code is only stored at the end of the
419         // constructor execution.
420 
421         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
422         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
423         // for accounts without code, i.e. `keccak256('')`
424         uint256 size;
425         // solhint-disable-next-line no-inline-assembly
426         assembly { size := extcodesize(account) }
427         return size > 0;
428     }
429 
430     /**
431      * @dev Converts an `address` into `address payable`. Note that this is
432      * simply a type cast: the actual underlying value is not changed.
433      *
434      * _Available since v2.4.0._
435      */
436     function toPayable(address account)
437         internal
438         pure
439         returns (address payable)
440     {
441         return address(uint160(account));
442     }
443 
444 
445     /**
446      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
447      * `recipient`, forwarding all available gas and reverting on errors.
448      *
449      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
450      * of certain opcodes, possibly making contracts go over the 2300 gas limit
451      * imposed by `transfer`, making them unable to receive funds via
452      * `transfer`. {sendValue} removes this limitation.
453      *
454      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
455      *
456      * IMPORTANT: because control is transferred to `recipient`, care must be
457      * taken to not create reentrancy vulnerabilities. Consider using
458      * {ReentrancyGuard} or the
459      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
460      */
461     function sendValue(address payable recipient, uint256 amount) internal {
462         require(address(this).balance >= amount, "Address: insufficient balance");
463 
464         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
465         (bool success, ) = recipient.call{ value: amount }("");
466         require(success, "Address: unable to send value, recipient may have reverted");
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
471 /**
472  * @title SafeERC20
473  * @dev Wrappers around ERC20 operations that throw on failure (when the token contract returns false). Tokens that return no value (and instead revert or throw on failure) are also supported, non-reverting calls are assumed to be successful.
474  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
475  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
476  */
477 library SafeERC20 {
478     using SafeMath for uint256;
479     using Address for address;
480 
481     function safeTransfer(
482         IERC20 token,
483         address to,
484         uint256 value
485     ) internal {
486         callOptionalReturn(
487             token,
488             abi.encodeWithSelector(token.transfer.selector, to, value)
489         );
490     }
491 
492     function safeTransferFrom(
493         IERC20 token,
494         address from,
495         address to,
496         uint256 value
497     ) internal {
498         callOptionalReturn(
499             token,
500             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
501         );
502     }
503 
504     function safeApprove(
505         IERC20 token,
506         address spender,
507         uint256 value
508     ) internal {
509         // safeApprove should only be called when setting an initial allowance,
510         // or when resetting it to zero. To increase and decrease it, use
511         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
512         // solhint-disable-next-line max-line-length
513         require(
514             (value == 0) || (token.allowance(address(this), spender) == 0),
515             "SafeERC20: approve from non-zero to non-zero allowance"
516         );
517         callOptionalReturn(
518             token,
519             abi.encodeWithSelector(token.approve.selector, spender, value)
520         );
521     }
522 
523     function safeIncreaseAllowance(
524         IERC20 token,
525         address spender,
526         uint256 value
527     ) internal {
528         uint256 newAllowance = token.allowance(address(this), spender).add(
529             value
530         );
531         callOptionalReturn(
532             token,
533             abi.encodeWithSelector(
534                 token.approve.selector,
535                 spender,
536                 newAllowance
537             )
538         );
539     }
540 
541     function safeDecreaseAllowance(
542         IERC20 token,
543         address spender,
544         uint256 value
545     ) internal {
546         uint256 newAllowance = token.allowance(address(this), spender).sub(
547             value,
548             "SafeERC20: decreased allowance below zero"
549         );
550         callOptionalReturn(
551             token,
552             abi.encodeWithSelector(
553                 token.approve.selector,
554                 spender,
555                 newAllowance
556             )
557         );
558     }
559 
560     /**
561      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
562      * on the return value: the return value is optional (but if data is returned, it must not be false).
563      * @param token The token targeted by the call.
564      * @param data The call data (encoded using abi.encode or one of its variants).
565      */
566     function callOptionalReturn(IERC20 token, bytes memory data) private {
567         //console.log("callOptionalReturn");
568         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
569         // we're implementing it ourselves.
570 
571         // A Solidity high level call has three parts:
572         //  1. The target address is checked to verify it contains contract code
573         //  2. The call itself is made, and success asserted
574         //  3. The return value is decoded, which in turn checks the size of the returned data.
575         // solhint-disable-next-line max-line-length
576         require(address(token).isContract(), "SafeERC20: call to non-contract");
577 
578         // solhint-disable-next-line avoid-low-level-calls
579         (bool success, bytes memory returndata) = address(token).call(data);
580         //console.log("success:", success, ", returndata length:", returndata.length);
581         //console.logBytes(returndata);
582         //console.log(abi.decode(returndata, (bool)));
583         //console.logBytes32(returndata);
584 
585         //", abi.decode:", abi.decode(returndata, (bool))
586 
587         require(success, "SafeERC20: low-level call failed");
588         if (returndata.length > 0) {
589             // Return data is optional
590             // solhint-disable-next-line max-line-length
591             require(
592                 abi.decode(returndata, (bool)),
593                 "SafeERC20: ERC20 operation did not succeed"
594             );
595         }
596     }
597 }
598 
599 // File: contracts/IRewardDistributionRecipient.sol
600 abstract contract IRewardDistributionRecipient is Ownable {
601     address public rewardDistribution;//added "public"
602 
603     function notifyRewardAmount(uint256 reward) external virtual;
604 
605     modifier onlyRewardDistribution() {
606         require(
607             _msgSender() == rewardDistribution,
608             "Caller is not reward distribution"
609         );
610         _;
611     }
612     //added func
613     function isOnlyRewardDistribution() external view returns (bool) {
614         return _msgSender() == rewardDistribution;
615     }
616     function setRewardDistribution(address _rewardDistribution)
617         external
618         onlyOwner
619     {
620         //console.log("sc setRewardDistribution... ");
621         rewardDistribution = _rewardDistribution;
622     }
623 }
624 
625 // File: contracts/CurveRewards.sol
626 contract LPTokenWrapper {
627     using SafeMath for uint256;
628     using SafeERC20 for IERC20;
629     IERC20 public lpToken;
630     uint256 private _totalSupply;
631     mapping(address => uint256) private _balances;
632 
633     function totalSupply() public view returns (uint256) {
634         return _totalSupply;
635     }
636 
637     function balanceOf(address account) public view returns (uint256) {
638         return _balances[account];
639     }
640 
641     function stake(uint256 amount) public virtual {
642       //console.log("LPTokenWrapper stake() with amount:", amount);
643         _totalSupply = _totalSupply.add(amount);
644         _balances[msg.sender] = _balances[msg.sender].add(amount);
645         lpToken.safeTransferFrom(msg.sender, address(this), amount);
646     }
647 
648     function withdraw(uint256 amount) public virtual {
649         _totalSupply = _totalSupply.sub(amount);
650         _balances[msg.sender] = _balances[msg.sender].sub(amount);
651         lpToken.safeTransfer(msg.sender, amount);
652     }
653 
654     function setLpToken(address _lpToken) internal {
655         lpToken = IERC20(_lpToken);
656     }
657 }
658 
659 contract Rewards is LPTokenWrapper, IRewardDistributionRecipient {
660     using SafeMath for uint256;
661     using SafeERC20 for IERC20;
662     IERC20 public erc20Token;//rewardToken
663     uint256 public constant DURATION = 7 days;
664     uint256 public periodFinish = 0;
665     uint256 public rewardRate = 0;
666     uint256 public lastUpdateTime;
667     uint256 public rewardPerTokenStored;
668     mapping(address => uint256) public userRewardPerTokenPaid;
669     mapping(address => uint256) public rewards;
670     event RewardAdded(uint256 reward);
671     event Staked(address indexed user, uint256 amount);    
672     event Withdrawn(address indexed user, uint256 amount);
673     event RewardPaid(address indexed user, uint256 reward);
674 
675     function getData2() public view returns (uint256, uint256, uint256, uint256, uint256) {
676         return (lastUpdateTime, rewardPerTokenStored, periodFinish, rewardRate, block.timestamp);
677     }
678     //function getRewardToken() public view returns (address) {
679     //    return (erc20Token);
680     //}
681 
682 
683     modifier updateReward(address account) {
684         rewardPerTokenStored = rewardPerToken();
685         lastUpdateTime = lastTimeRewardApplicable();
686         if (account != address(0)) {
687             rewards[account] = earned(account);
688             userRewardPerTokenPaid[account] = rewardPerTokenStored;
689         }
690         _;
691     }
692 
693     constructor(address _lpToken, address _rewardToken) {
694         //console.log("sc deploying rewards ctrt");
695         super.setLpToken(_lpToken);
696         erc20Token = IERC20(_rewardToken);
697     }
698 
699     function lastTimeRewardApplicable() public view returns (uint256) {
700         return Math.min(block.timestamp, periodFinish);
701     }
702 
703     function rewardPerToken() public view returns (uint256) {
704         if (totalSupply() == 0) {
705             return rewardPerTokenStored;
706         }
707         return
708             rewardPerTokenStored.add(
709                 lastTimeRewardApplicable()
710                     .sub(lastUpdateTime)
711                     .mul(rewardRate)
712                     .mul(1e18)
713                     .div(totalSupply())
714             );
715     }
716 
717     function earned(address account) public view returns (uint256) {
718         return
719             balanceOf(account)
720                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
721                 .div(1e18)
722                 .add(rewards[account]);
723     }
724 
725     // stake visibility is public as overriding LPTokenWrapper's stake() function
726     function stake(uint256 amount) public updateReward(msg.sender) override {
727         require(amount > 0, "Cannot stake 0");
728         super.stake(amount);
729         emit Staked(msg.sender, amount);
730     }
731 
732     function withdraw(uint256 amount) public updateReward(msg.sender) override {
733         require(amount > 0, "Cannot withdraw 0");
734         super.withdraw(amount);
735         emit Withdrawn(msg.sender, amount);
736     }
737 
738     function exit() external {
739         withdraw(balanceOf(msg.sender));
740         getReward();
741     }
742 
743     // user: stake, claim:getReward, unstake:withdraw
744     function getReward() public updateReward(msg.sender) {
745         uint256 reward = earned(msg.sender);
746         if (reward > 0) {
747             //console.log("sc reward > 0");
748             rewards[msg.sender] = 0;
749             erc20Token.safeTransfer(msg.sender, reward);
750             emit RewardPaid(msg.sender, reward);
751         }
752     }
753 
754     function getData1() public view returns (uint256, uint256, uint256, uint256) {
755         return (block.timestamp, periodFinish, rewardRate, DURATION);
756     }
757 
758     // admin: reset periodFinish, lastUpdateTime, rewardRate
759     function notifyRewardAmount(uint256 reward)
760         external override
761         onlyRewardDistribution
762         updateReward(address(0))
763     {
764         if (block.timestamp >= periodFinish) {
765             rewardRate = reward.div(DURATION);
766         } else {
767             uint256 remaining = periodFinish.sub(block.timestamp);
768             uint256 leftover = remaining.mul(rewardRate);
769             rewardRate = reward.add(leftover).div(DURATION);
770         }
771         lastUpdateTime = block.timestamp;
772         periodFinish = block.timestamp.add(DURATION);
773         emit RewardAdded(reward);
774     }
775 }
776 
777 /**
778  * MIT License
779  * ===========
780  *
781  * Copyright (c) 2020 Aries Financial
782  *
783  * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
784  *
785  * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
786  *
787  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
788  */