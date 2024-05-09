1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity ^0.6.12;
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
89     function sub(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b <= a, errorMessage);
95         uint256 c = a - b;
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the multiplication of two unsigned integers, reverting on
102      * overflow.
103      *
104      * Counterpart to Solidity's `*` operator.
105      *
106      * Requirements:
107      * - Multiplication cannot overflow.
108      */
109     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
110         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
111         // benefit is lost if 'b' is also tested.
112         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
113         if (a == 0) {
114             return 0;
115         }
116 
117         uint256 c = a * b;
118         require(c / a == b, "SafeMath: multiplication overflow");
119 
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers. Reverts on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      * - The divisor cannot be zero.
133      */
134     function div(uint256 a, uint256 b) internal pure returns (uint256) {
135         return div(a, b, "SafeMath: division by zero");
136     }
137 
138     /**
139      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
140      * division by zero. The result is rounded towards zero.
141      *
142      * Counterpart to Solidity's `/` operator. Note: this function uses a
143      * `revert` opcode (which leaves remaining gas untouched) while Solidity
144      * uses an invalid opcode to revert (consuming all remaining gas).
145      *
146      * Requirements:
147      * - The divisor cannot be zero.
148      *
149      * _Available since v2.4.0._
150      */
151     function div(
152         uint256 a,
153         uint256 b,
154         string memory errorMessage
155     ) internal pure returns (uint256) {
156         // Solidity only automatically asserts when dividing by 0
157         require(b > 0, errorMessage);
158         uint256 c = a / b;
159         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
166      * Reverts when dividing by zero.
167      *
168      * Counterpart to Solidity's `%` operator. This function uses a `revert`
169      * opcode (which leaves remaining gas untouched) while Solidity uses an
170      * invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      * - The divisor cannot be zero.
174      */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         return mod(a, b, "SafeMath: modulo by zero");
177     }
178 
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts with custom message when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      *
190      * _Available since v2.4.0._
191      */
192     function mod(
193         uint256 a,
194         uint256 b,
195         string memory errorMessage
196     ) internal pure returns (uint256) {
197         require(b != 0, errorMessage);
198         return a % b;
199     }
200 }
201 
202 // File: @openzeppelin/contracts/GSN/Context.sol
203 
204 /*
205  * @dev Provides information about the current execution context, including the
206  * sender of the transaction and its data. While these are generally available
207  * via msg.sender and msg.data, they should not be accessed in such a direct
208  * manner, since when dealing with GSN meta-transactions the account sending and
209  * paying for execution may not be the actual sender (as far as an application
210  * is concerned).
211  *
212  * This contract is only required for intermediate, library-like contracts.
213  */
214 contract Context {
215     // Empty internal constructor, to prevent people from mistakenly deploying
216     // an instance of this contract, which should be used via inheritance.
217     constructor() internal {}
218 
219     // solhint-disable-previous-line no-empty-blocks
220 
221     function _msgSender() internal view returns (address payable) {
222         return msg.sender;
223     }
224 
225     function _msgData() internal view returns (bytes memory) {
226         this;
227         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
228         return msg.data;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/ownership/Ownable.sol
233 
234 /**
235  * @dev Contract module which provides a basic access control mechanism, where
236  * there is an account (an owner) that can be granted exclusive access to
237  * specific functions.
238  *
239  * This module is used through inheritance. It will make available the modifier
240  * `onlyOwner`, which can be applied to your functions to restrict their use to
241  * the owner.
242  */
243 contract Ownable is Context {
244     address private _owner;
245 
246     event OwnershipTransferred(
247         address indexed previousOwner,
248         address indexed newOwner
249     );
250 
251     /**
252      * @dev Initializes the contract setting the deployer as the initial owner.
253      */
254     constructor() internal {
255         _owner = _msgSender();
256         emit OwnershipTransferred(address(0), _owner);
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(isOwner(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Returns true if the caller is the current owner.
276      */
277     function isOwner() public view returns (bool) {
278         return _msgSender() == _owner;
279     }
280 
281     /**
282      * @dev Leaves the contract without owner. It will not be possible to call
283      * `onlyOwner` functions anymore. Can only be called by the current owner.
284      *
285      * NOTE: Renouncing ownership will leave the contract without an owner,
286      * thereby removing any functionality that is only available to the owner.
287      */
288     function renounceOwnership() public onlyOwner {
289         emit OwnershipTransferred(_owner, address(0));
290         _owner = address(0);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Can only be called by the current owner.
296      */
297     function transferOwnership(address newOwner) public onlyOwner {
298         _transferOwnership(newOwner);
299     }
300 
301     /**
302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
303      */
304     function _transferOwnership(address newOwner) internal {
305         require(
306             newOwner != address(0),
307             "Ownable: new owner is the zero address"
308         );
309         emit OwnershipTransferred(_owner, newOwner);
310         _owner = newOwner;
311     }
312 }
313 
314 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
315 
316 /**
317  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
318  * the optional functions; to access them see {ERC20Detailed}.
319  */
320 interface IERC20 {
321     function totalSupply() external view returns (uint256);
322 
323     function balanceOf(address account) external view returns (uint256);
324 
325     function transfer(address recipient, uint256 amount)
326         external
327         returns (bool);
328 
329     function mint(address account, uint256 amount) external;
330 
331     function burn(uint256 amount) external;
332 
333     function allowance(address owner, address spender)
334         external
335         view
336         returns (uint256);
337 
338     function approve(address spender, uint256 amount) external returns (bool);
339 
340     function transferFrom(
341         address sender,
342         address recipient,
343         uint256 amount
344     ) external returns (bool);
345 
346     event Transfer(address indexed from, address indexed to, uint256 value);
347     event Approval(
348         address indexed owner,
349         address indexed spender,
350         uint256 value
351     );
352 }
353 
354 // File: @openzeppelin/contracts/utils/Address.sol
355 
356 /**
357  * @dev Collection of functions related to the address type
358  */
359 library Address {
360     /**
361      * @dev Returns true if `account` is a contract.
362      *
363      * This test is non-exhaustive, and there may be false-negatives: during the
364      * execution of a contract's constructor, its address will be reported as
365      * not containing a contract.
366      *
367      * IMPORTANT: It is unsafe to assume that an address for which this
368      * function returns false is an externally-owned account (EOA) and not a
369      * contract.
370      */
371     function isContract(address account) internal view returns (bool) {
372         // This method relies in extcodesize, which returns 0 for contracts in
373         // construction, since the code is only stored at the end of the
374         // constructor execution.
375 
376         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
377         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
378         // for accounts without code, i.e. `keccak256('')`
379         bytes32 codehash;
380 
381 
382             bytes32 accountHash
383          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
384         // solhint-disable-next-line no-inline-assembly
385         assembly {
386             codehash := extcodehash(account)
387         }
388         return (codehash != 0x0 && codehash != accountHash);
389     }
390 
391     /**
392      * @dev Converts an `address` into `address payable`. Note that this is
393      * simply a type cast: the actual underlying value is not changed.
394      *
395      * _Available since v2.4.0._
396      */
397     function toPayable(address account)
398         internal
399         pure
400         returns (address payable)
401     {
402         return address(uint160(account));
403     }
404 }
405 
406 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
407 
408 /**
409  * @title SafeERC20
410  * @dev Wrappers around ERC20 operations that throw on failure (when the token
411  * contract returns false). Tokens that return no value (and instead revert or
412  * throw on failure) are also supported, non-reverting calls are assumed to be
413  * successful.
414  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
415  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
416  */
417 library SafeERC20 {
418     using SafeMath for uint256;
419     using Address for address;
420 
421     function safeTransfer(
422         IERC20 token,
423         address to,
424         uint256 value
425     ) internal {
426         callOptionalReturn(
427             token,
428             abi.encodeWithSelector(token.transfer.selector, to, value)
429         );
430     }
431 
432     function safeTransferFrom(
433         IERC20 token,
434         address from,
435         address to,
436         uint256 value
437     ) internal {
438         callOptionalReturn(
439             token,
440             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
441         );
442     }
443 
444     function safeApprove(
445         IERC20 token,
446         address spender,
447         uint256 value
448     ) internal {
449         // safeApprove should only be called when setting an initial allowance,
450         // or when resetting it to zero. To increase and decrease it, use
451         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
452         // solhint-disable-next-line max-line-length
453         require(
454             (value == 0) || (token.allowance(address(this), spender) == 0),
455             "SafeERC20: approve from non-zero to non-zero allowance"
456         );
457         callOptionalReturn(
458             token,
459             abi.encodeWithSelector(token.approve.selector, spender, value)
460         );
461     }
462 
463     function safeIncreaseAllowance(
464         IERC20 token,
465         address spender,
466         uint256 value
467     ) internal {
468         uint256 newAllowance = token.allowance(address(this), spender).add(
469             value
470         );
471         callOptionalReturn(
472             token,
473             abi.encodeWithSelector(
474                 token.approve.selector,
475                 spender,
476                 newAllowance
477             )
478         );
479     }
480 
481     function safeDecreaseAllowance(
482         IERC20 token,
483         address spender,
484         uint256 value
485     ) internal {
486         uint256 newAllowance = token.allowance(address(this), spender).sub(
487             value,
488             "SafeERC20: decreased allowance below zero"
489         );
490         callOptionalReturn(
491             token,
492             abi.encodeWithSelector(
493                 token.approve.selector,
494                 spender,
495                 newAllowance
496             )
497         );
498     }
499 
500     /**
501      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
502      * on the return value: the return value is optional (but if data is returned, it must not be false).
503      * @param token The token targeted by the call.
504      * @param data The call data (encoded using abi.encode or one of its variants).
505      */
506     function callOptionalReturn(IERC20 token, bytes memory data) private {
507         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
508         // we're implementing it ourselves.
509 
510         // A Solidity high level call has three parts:
511         //  1. The target address is checked to verify it contains contract code
512         //  2. The call itself is made, and success asserted
513         //  3. The return value is decoded, which in turn checks the size of the returned data.
514         // solhint-disable-next-line max-line-length
515         require(address(token).isContract(), "SafeERC20: call to non-contract");
516 
517         // solhint-disable-next-line avoid-low-level-calls
518         (bool success, bytes memory returndata) = address(token).call(data);
519         require(success, "SafeERC20: low-level call failed");
520 
521         if (returndata.length > 0) {
522             // Return data is optional
523             // solhint-disable-next-line max-line-length
524             require(
525                 abi.decode(returndata, (bool)),
526                 "SafeERC20: ERC20 operation did not succeed"
527             );
528         }
529     }
530 }
531 
532 // File: contracts/IGovernanceAddressRecipient.sol
533 
534 contract IGovernanceAddressRecipient is Ownable {
535     address GovernanceAddress;
536 
537     modifier onlyGovernanceAddress() {
538         require(
539             _msgSender() == GovernanceAddress,
540             "Caller is not reward distribution"
541         );
542         _;
543     }
544 
545     function setGovernanceAddress(address _GovernanceAddress)
546         external
547         onlyOwner
548     {
549         GovernanceAddress = _GovernanceAddress;
550     }
551 }
552 
553 // File: contracts/Rewards.sol
554 
555 contract StakeTokenWrapper {
556     using SafeMath for uint256;
557     using SafeERC20 for IERC20;
558 
559     IERC20 public stakeToken;
560 
561     uint256 constant PERCENT = 10000;
562     uint256 public DEFLATION_OUT = 0;
563     uint256 public DEFLATION_REWARD = 0;
564     address public feeAddress = address(0);
565     uint256 private _totalSupply;
566     mapping(address => uint256) private _balances;
567 
568     constructor(
569         address _stakeToken,
570         address _feeAddress,
571         uint256 _deflationReward,
572         uint256 _deflationOut
573     ) public {
574         stakeToken = IERC20(_stakeToken);
575         feeAddress = _feeAddress;
576         DEFLATION_OUT = _deflationOut;
577         DEFLATION_REWARD = _deflationReward;
578     }
579 
580     function totalSupply() public view returns (uint256) {
581         return _totalSupply;
582     }
583 
584     function balanceOf(address account) public view returns (uint256) {
585         return _balances[account];
586     }
587 
588     function stake(uint256 amount) public virtual {
589         _totalSupply = _totalSupply.add(amount);
590         _balances[msg.sender] = _balances[msg.sender].add(amount);
591         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
592     }
593 
594     function withdraw(uint256 amount) public virtual {
595         _totalSupply = _totalSupply.sub(amount);
596         _balances[msg.sender] = _balances[msg.sender].sub(amount);
597         (
598             uint256 realAmount,
599             uint256 feeAmount,
600             uint256 burnAmount
601         ) = feeTransaction(amount, DEFLATION_OUT);
602         stakeToken.safeTransfer(address(feeAddress), feeAmount);
603         stakeToken.burn(burnAmount);
604         stakeToken.safeTransfer(msg.sender, realAmount);
605     }
606 
607     function feeTransaction(uint256 amount, uint256 _deflation)
608         internal
609         pure
610         returns (
611             uint256 realAmount,
612             uint256 feeAmount,
613             uint256 burnAmount
614         )
615     {
616         burnAmount = amount.div(PERCENT).mul(_deflation).div(10);
617         feeAmount = amount.div(PERCENT).mul(_deflation).div(10).mul(9);
618         realAmount = amount.sub(burnAmount.add(feeAmount));
619     }
620 }
621 
622 contract YFFSDeflationStake is
623     StakeTokenWrapper(
624         0x90D702f071d2af33032943137AD0aB4280705817,
625         0xb22Aed36638f0Cf6B8d1092ab73A14580E6f8b99,
626         100,
627         100
628     ),
629     IGovernanceAddressRecipient
630 {
631     uint256 public constant DURATION = 60 days;
632 
633     uint256 public initReward = 0;
634     uint256 public startTime = 0;
635     uint256 public periodFinish = 0;
636     uint256 public rewardRate = 0;
637     uint256 public lastUpdateTime;
638     bool public stakeable = false;
639     uint256 public rewardPerTokenStored;
640     mapping(address => uint256) public userRewardPerTokenPaid;
641     mapping(address => uint256) public rewards;
642 
643     event DepositStake(uint256 reward);
644     event StartStaking(uint256 time);
645     event StopStaking(uint256 time);
646     event Staked(address indexed user, uint256 amount);
647     event Withdrawn(address indexed user, uint256 amount);
648     event RewardPaid(address indexed user, uint256 reward);
649 
650     modifier updateReward(address account) {
651         rewardPerTokenStored = rewardPerToken();
652         lastUpdateTime = lastTimeRewardApplicable();
653         if (account != address(0)) {
654             rewards[account] = earned(account);
655             userRewardPerTokenPaid[account] = rewardPerTokenStored;
656         }
657         _;
658     }
659 
660     modifier checkStart() {
661         require(initReward > 0, "No reward to stake.");
662         require(stakeable, "Staking is not started.");
663         _;
664     }
665 
666     constructor() public {
667         GovernanceAddress = msg.sender;
668     }
669 
670     function lastTimeRewardApplicable() public view returns (uint256) {
671         return Math.min(block.timestamp, periodFinish);
672     }
673 
674     function remainingReward() public view returns (uint256) {
675         return stakeToken.balanceOf(address(this));
676     }
677 
678     function stop() public onlyGovernanceAddress {
679         require(stakeable, "Staking is not started.");
680         stakeToken.safeTransfer(
681             address(0x489B689850999F751760a38d03693Bd979C4A690),
682             remainingReward()
683         );
684         stakeable = false;
685         initReward = 0;
686         rewardRate = 0;
687         emit StopStaking(block.timestamp);
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
712     function start() public onlyGovernanceAddress {
713         require(!stakeable, "Staking is started.");
714         require(initReward > 0, "Cannot start. Require initReward");
715         periodFinish = block.timestamp.add(DURATION);
716         stakeable = true;
717         startTime = block.timestamp;
718         emit StartStaking(block.timestamp);
719     }
720 
721     function depositReward(uint256 amount) public onlyGovernanceAddress {
722         require(!stakeable, "Staking is started.");
723         require(amount > 0, "Cannot deposit 0");
724         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
725         initReward = amount;
726         rewardRate = initReward.div(DURATION);
727         emit DepositStake(amount);
728     }
729 
730     function stake(uint256 amount)
731         public
732         override
733         updateReward(msg.sender)
734         checkStart
735     {
736         require(amount > 0, "Cannot stake 0");
737         super.stake(amount);
738         emit Staked(msg.sender, amount);
739     }
740 
741     function withdraw(uint256 amount)
742         public
743         override
744         updateReward(msg.sender)
745         checkStart
746     {
747         require(amount > 0, "Cannot withdraw 0");
748         super.withdraw(amount);
749         emit Withdrawn(msg.sender, amount);
750     }
751 
752     function exitStake() external {
753         withdraw(balanceOf(msg.sender));
754         getReward();
755     }
756 
757     function getReward() public updateReward(msg.sender) checkStart {
758         uint256 reward = earned(msg.sender);
759         if (reward > 0) {
760             rewards[msg.sender] = 0;
761             uint256 deflationReward = reward.div(PERCENT).mul(DEFLATION_REWARD);
762             stakeToken.burn(deflationReward);
763             stakeToken.safeTransfer(msg.sender, reward.sub(deflationReward));
764             emit RewardPaid(msg.sender, reward);
765         }
766     }
767 }