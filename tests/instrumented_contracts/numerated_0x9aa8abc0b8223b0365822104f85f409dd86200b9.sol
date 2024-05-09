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
27         return (a / 2) + (b / 2) + (((a % 2) + (b % 2)) / 2);
28     }
29 }
30 
31 pragma solidity ^0.5.0;
32 
33 /**
34  * @dev Wrappers over Solidity's arithmetic operations with added overflow
35  * checks.
36  *
37  * Arithmetic operations in Solidity wrap on overflow. This can easily result
38  * in bugs, because programmers usually assume that an overflow raises an
39  * error, which is the standard behavior in high level programming languages.
40  * `SafeMath` restores this intuition by reverting the transaction when an
41  * operation overflows.
42  *
43  * Using this library instead of the unchecked operations eliminates an entire
44  * class of bugs, so it's recommended to use it always.
45  */
46 library SafeMath {
47     /**
48      * @dev Returns the addition of two unsigned integers, reverting on
49      * overflow.
50      *
51      * Counterpart to Solidity's `+` operator.
52      *
53      * Requirements:
54      * - Addition cannot overflow.
55      */
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59 
60         return c;
61     }
62 
63     /**
64      * @dev Returns the subtraction of two unsigned integers, reverting on
65      * overflow (when the result is negative).
66      *
67      * Counterpart to Solidity's `-` operator.
68      *
69      * Requirements:
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      * - Subtraction cannot overflow.
84      *
85      * _Available since v2.4.0._
86      */
87     function sub(
88         uint256 a,
89         uint256 b,
90         string memory errorMessage
91     ) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      *
147      * _Available since v2.4.0._
148      */
149     function div(
150         uint256 a,
151         uint256 b,
152         string memory errorMessage
153     ) internal pure returns (uint256) {
154         // Solidity only automatically asserts when dividing by 0
155         require(b > 0, errorMessage);
156         uint256 c = a / b;
157         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
164      * Reverts when dividing by zero.
165      *
166      * Counterpart to Solidity's `%` operator. This function uses a `revert`
167      * opcode (which leaves remaining gas untouched) while Solidity uses an
168      * invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      * - The divisor cannot be zero.
172      */
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         return mod(a, b, "SafeMath: modulo by zero");
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts with custom message when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      *
188      * _Available since v2.4.0._
189      */
190     function mod(
191         uint256 a,
192         uint256 b,
193         string memory errorMessage
194     ) internal pure returns (uint256) {
195         require(b != 0, errorMessage);
196         return a % b;
197     }
198 }
199 
200 pragma solidity ^0.5.0;
201 
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
213     // Empty internal constructor, to prevent people from mistakenly deploying
214     // an instance of this contract, which should be used via inheritance.
215     constructor() internal {}
216 
217     // solhint-disable-previous-line no-empty-blocks
218 
219     function _msgSender() internal view returns (address payable) {
220         return msg.sender;
221     }
222 
223     function _msgData() internal view returns (bytes memory) {
224         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
225         return msg.data;
226     }
227 }
228 
229 // File: @openzeppelin/contracts/ownership/Ownable.sol
230 
231 pragma solidity ^0.5.0;
232 
233 /**
234  * @dev Contract module which provides a basic access control mechanism, where
235  * there is an account (an owner) that can be granted exclusive access to
236  * specific functions.
237  *
238  * This module is used through inheritance. It will make available the modifier
239  * `onlyOwner`, which can be applied to your functions to restrict their use to
240  * the owner.
241  */
242 contract Ownable is Context {
243     address private _owner;
244 
245     event OwnershipTransferred(
246         address indexed previousOwner,
247         address indexed newOwner
248     );
249 
250     /**
251      * @dev Initializes the contract setting the deployer as the initial owner.
252      */
253     constructor() internal {
254         _owner = _msgSender();
255         emit OwnershipTransferred(address(0), _owner);
256     }
257 
258     /**
259      * @dev Returns the address of the current owner.
260      */
261     function owner() public view returns (address) {
262         return _owner;
263     }
264 
265     /**
266      * @dev Throws if called by any account other than the owner.
267      */
268     modifier onlyOwner() {
269         require(isOwner(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     /**
274      * @dev Returns true if the caller is the current owner.
275      */
276     function isOwner() public view returns (bool) {
277         return _msgSender() == _owner;
278     }
279 
280     /**
281      * @dev Leaves the contract without owner. It will not be possible to call
282      * `onlyOwner` functions anymore. Can only be called by the current owner.
283      *
284      * NOTE: Renouncing ownership will leave the contract without an owner,
285      * thereby removing any functionality that is only available to the owner.
286      */
287     function renounceOwnership() public onlyOwner {
288         emit OwnershipTransferred(_owner, address(0));
289         _owner = address(0);
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Can only be called by the current owner.
295      */
296     function transferOwnership(address newOwner) public onlyOwner {
297         _transferOwnership(newOwner);
298     }
299 
300     /**
301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
302      */
303     function _transferOwnership(address newOwner) internal {
304         require(
305             newOwner != address(0),
306             "Ownable: new owner is the zero address"
307         );
308         emit OwnershipTransferred(_owner, newOwner);
309         _owner = newOwner;
310     }
311 }
312 
313 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
314 
315 pragma solidity ^0.5.0;
316 
317 /**
318  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
319  * the optional functions; to access them see {ERC20Detailed}.
320  */
321 interface IERC20 {
322     /**
323      * @dev Returns the amount of tokens in existence.
324      */
325     function totalSupply() external view returns (uint256);
326 
327     /**
328      * @dev Returns the amount of tokens owned by `account`.
329      */
330     function balanceOf(address account) external view returns (uint256);
331 
332     /**
333      * @dev Moves `amount` tokens from the caller's account to `recipient`.
334      *
335      * Returns a boolean value indicating whether the operation succeeded.
336      *
337      * Emits a {Transfer} event.
338      */
339     function transfer(address recipient, uint256 amount)
340         external
341         returns (bool);
342 
343     function mint(address account, uint256 amount) external;
344 
345     /**
346      * @dev Returns the remaining number of tokens that `spender` will be
347      * allowed to spend on behalf of `owner` through {transferFrom}. This is
348      * zero by default.
349      *
350      * This value changes when {approve} or {transferFrom} are called.
351      */
352     function allowance(address owner, address spender)
353         external
354         view
355         returns (uint256);
356 
357     /**
358      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * IMPORTANT: Beware that changing an allowance with this method brings the risk
363      * that someone may use both the old and the new allowance by unfortunate
364      * transaction ordering. One possible solution to mitigate this race
365      * condition is to first reduce the spender's allowance to 0 and set the
366      * desired value afterwards:
367      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
368      *
369      * Emits an {Approval} event.
370      */
371     function approve(address spender, uint256 amount) external returns (bool);
372 
373     /**
374      * @dev Moves `amount` tokens from `sender` to `recipient` using the
375      * allowance mechanism. `amount` is then deducted from the caller's
376      * allowance.
377      *
378      * Returns a boolean value indicating whether the operation succeeded.
379      *
380      * Emits a {Transfer} event.
381      */
382     function transferFrom(
383         address sender,
384         address recipient,
385         uint256 amount
386     ) external returns (bool);
387 
388     /**
389      * @dev Emitted when `value` tokens are moved from one account (`from`) to
390      * another (`to`).
391      *
392      * Note that `value` may be zero.
393      */
394     event Transfer(address indexed from, address indexed to, uint256 value);
395 
396     /**
397      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
398      * a call to {approve}. `value` is the new allowance.
399      */
400     event Approval(
401         address indexed owner,
402         address indexed spender,
403         uint256 value
404     );
405 }
406 
407 // File: @openzeppelin/contracts/utils/Address.sol
408 
409 pragma solidity ^0.5.5;
410 
411 /**
412  * @dev Collection of functions related to the address type
413  */
414 library Address {
415     /**
416      * @dev Returns true if `account` is a contract.
417      *
418      * This test is non-exhaustive, and there may be false-negatives: during the
419      * execution of a contract's constructor, its address will be reported as
420      * not containing a contract.
421      *
422      * IMPORTANT: It is unsafe to assume that an address for which this
423      * function returns false is an externally-owned account (EOA) and not a
424      * contract.
425      */
426     function isContract(address account) internal view returns (bool) {
427         // This method relies in extcodesize, which returns 0 for contracts in
428         // construction, since the code is only stored at the end of the
429         // constructor execution.
430 
431         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
432         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
433         // for accounts without code, i.e. `keccak256('')`
434         bytes32 codehash;
435 
436 
437             bytes32 accountHash
438          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
439         // solhint-disable-next-line no-inline-assembly
440         assembly {
441             codehash := extcodehash(account)
442         }
443         return (codehash != 0x0 && codehash != accountHash);
444     }
445 
446     /**
447      * @dev Converts an `address` into `address payable`. Note that this is
448      * simply a type cast: the actual underlying value is not changed.
449      *
450      * _Available since v2.4.0._
451      */
452     function toPayable(address account)
453         internal
454         pure
455         returns (address payable)
456     {
457         return address(uint160(account));
458     }
459 
460     /**
461      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
462      * `recipient`, forwarding all available gas and reverting on errors.
463      *
464      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
465      * of certain opcodes, possibly making contracts go over the 2300 gas limit
466      * imposed by `transfer`, making them unable to receive funds via
467      * `transfer`. {sendValue} removes this limitation.
468      *
469      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
470      *
471      * IMPORTANT: because control is transferred to `recipient`, care must be
472      * taken to not create reentrancy vulnerabilities. Consider using
473      * {ReentrancyGuard} or the
474      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
475      *
476      * _Available since v2.4.0._
477      */
478     function sendValue(address payable recipient, uint256 amount) internal {
479         require(
480             address(this).balance >= amount,
481             "Address: insufficient balance"
482         );
483 
484         // solhint-disable-next-line avoid-call-value
485         (bool success, ) = recipient.call.value(amount)("");
486         require(
487             success,
488             "Address: unable to send value, recipient may have reverted"
489         );
490     }
491 }
492 
493 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
494 
495 pragma solidity ^0.5.0;
496 
497 /**
498  * @title SafeERC20
499  * @dev Wrappers around ERC20 operations that throw on failure (when the token
500  * contract returns false). Tokens that return no value (and instead revert or
501  * throw on failure) are also supported, non-reverting calls are assumed to be
502  * successful.
503  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
504  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
505  */
506 library SafeERC20 {
507     using SafeMath for uint256;
508     using Address for address;
509 
510     function safeTransfer(
511         IERC20 token,
512         address to,
513         uint256 value
514     ) internal {
515         callOptionalReturn(
516             token,
517             abi.encodeWithSelector(token.transfer.selector, to, value)
518         );
519     }
520 
521     function safeTransferFrom(
522         IERC20 token,
523         address from,
524         address to,
525         uint256 value
526     ) internal {
527         callOptionalReturn(
528             token,
529             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
530         );
531     }
532 
533     function safeApprove(
534         IERC20 token,
535         address spender,
536         uint256 value
537     ) internal {
538         // safeApprove should only be called when setting an initial allowance,
539         // or when resetting it to zero. To increase and decrease it, use
540         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
541         // solhint-disable-next-line max-line-length
542         require(
543             (value == 0) || (token.allowance(address(this), spender) == 0),
544             "SafeERC20: approve from non-zero to non-zero allowance"
545         );
546         callOptionalReturn(
547             token,
548             abi.encodeWithSelector(token.approve.selector, spender, value)
549         );
550     }
551 
552     function safeIncreaseAllowance(
553         IERC20 token,
554         address spender,
555         uint256 value
556     ) internal {
557         uint256 newAllowance = token.allowance(address(this), spender).add(
558             value
559         );
560         callOptionalReturn(
561             token,
562             abi.encodeWithSelector(
563                 token.approve.selector,
564                 spender,
565                 newAllowance
566             )
567         );
568     }
569 
570     function safeDecreaseAllowance(
571         IERC20 token,
572         address spender,
573         uint256 value
574     ) internal {
575         uint256 newAllowance = token.allowance(address(this), spender).sub(
576             value,
577             "SafeERC20: decreased allowance below zero"
578         );
579         callOptionalReturn(
580             token,
581             abi.encodeWithSelector(
582                 token.approve.selector,
583                 spender,
584                 newAllowance
585             )
586         );
587     }
588 
589     /**
590      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
591      * on the return value: the return value is optional (but if data is returned, it must not be false).
592      * @param token The token targeted by the call.
593      * @param data The call data (encoded using abi.encode or one of its variants).
594      */
595     function callOptionalReturn(IERC20 token, bytes memory data) private {
596         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
597         // we're implementing it ourselves.
598 
599         // A Solidity high level call has three parts:
600         //  1. The target address is checked to verify it contains contract code
601         //  2. The call itself is made, and success asserted
602         //  3. The return value is decoded, which in turn checks the size of the returned data.
603         // solhint-disable-next-line max-line-length
604         require(address(token).isContract(), "SafeERC20: call to non-contract");
605 
606         // solhint-disable-next-line avoid-low-level-calls
607         (bool success, bytes memory returndata) = address(token).call(data);
608         require(success, "SafeERC20: low-level call failed");
609 
610         if (returndata.length > 0) {
611             // Return data is optional
612             // solhint-disable-next-line max-line-length
613             require(
614                 abi.decode(returndata, (bool)),
615                 "SafeERC20: ERC20 operation did not succeed"
616             );
617         }
618     }
619 }
620 
621 pragma solidity ^0.5.0;
622 
623 contract IRewardDistributionRecipient is Ownable {
624     address rewardDistribution;
625 
626     // function notifyRewardAmount(uint256 reward) external;
627 
628     modifier onlyRewardDistribution() {
629         require(
630             _msgSender() == rewardDistribution,
631             "Caller is not reward distribution"
632         );
633         _;
634     }
635 
636     function setRewardDistribution(address _rewardDistribution)
637         external
638         onlyOwner
639     {
640         require(
641             _rewardDistribution != address(0),
642             "rewardDistribution can't be address(0) !"
643         );
644         rewardDistribution = _rewardDistribution;
645     }
646 }
647 
648 pragma solidity ^0.5.0;
649 
650 contract LPTokenWrapper {
651     using SafeMath for uint256;
652     using SafeERC20 for IERC20;
653 
654     IERC20 public y = IERC20(0xa3548AA71378b08966Dc80865438ac01a929E8a7);
655 
656     uint256 private _totalSupply;
657     mapping(address => uint256) private _balances;
658 
659     function totalSupply() public view returns (uint256) {
660         return _totalSupply;
661     }
662 
663     function balanceOf(address account) public view returns (uint256) {
664         return _balances[account];
665     }
666 
667     function stake(uint256 amount) public {
668         _totalSupply = _totalSupply.add(amount);
669         _balances[msg.sender] = _balances[msg.sender].add(amount);
670         y.safeTransferFrom(msg.sender, address(this), amount);
671     }
672 
673     function withdraw(uint256 amount) public {
674         _totalSupply = _totalSupply.sub(amount);
675         _balances[msg.sender] = _balances[msg.sender].sub(amount);
676         y.safeTransfer(msg.sender, amount);
677     }
678 }
679 
680 contract RGRewardUBSCETHPool is LPTokenWrapper, IRewardDistributionRecipient {
681 
682     address public developer;
683 
684     bool isInit = true;
685 
686     IERC20 public yieldToken = IERC20(0x54091956C7d7b2E0fCD669D41dC8e41d464CbD76);
687 
688     uint256 public constant DURATION = 10 days;
689 
690     // init 100, total 400. 50% reduction in production every 10 days
691     uint256 public initreward = 100 * 1e18;
692     uint256 public starttime = 1602504000;
693     uint256 public periodFinish = 0;
694     uint256 public rewardRate = 0;
695     uint256 public lastUpdateTime;
696     uint256 public rewardPerTokenStored;
697     mapping(address => uint256) public userRewardPerTokenPaid;
698     mapping(address => uint256) public rewards;
699 
700     event RewardAdded(uint256 reward);
701     event Staked(address indexed user, uint256 amount);
702     event Withdrawn(address indexed user, uint256 amount);
703     event RewardPaid(address indexed user, uint256 reward);
704 
705     modifier onlyDeveloper() {
706         require(msg.sender == developer);
707         _;
708     }
709 
710     constructor() public {
711         developer = msg.sender;
712         periodFinish = starttime.add(DURATION);
713     }
714 
715     modifier updateReward(address account) {
716         rewardPerTokenStored = rewardPerToken();
717         lastUpdateTime = lastTimeRewardApplicable();
718         if (account != address(0)) {
719             rewards[account] = earned(account);
720             userRewardPerTokenPaid[account] = rewardPerTokenStored;
721         }
722         _;
723     }
724 
725     function lastTimeRewardApplicable() public view returns (uint256) {
726         return Math.min(block.timestamp, periodFinish);
727     }
728 
729     function rewardPerToken() public view returns (uint256) {
730         if (totalSupply() == 0) {
731             return rewardPerTokenStored;
732         }
733         return
734             rewardPerTokenStored.add(
735                 lastTimeRewardApplicable()
736                     .sub(lastUpdateTime)
737                     .mul(rewardRate)
738                     .mul(1e18)
739                     .div(totalSupply())
740             );
741     }
742 
743     function earned(address account) public view returns (uint256) {
744         return
745             balanceOf(account)
746                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
747                 .div(1e18)
748                 .add(rewards[account]);
749     }
750 
751     // stake visibility is public as overriding LPTokenWrapper's stake() function
752     function stake(uint256 amount)
753         public
754         updateReward(msg.sender)
755         checkhalve
756         checkStart
757     {
758         require(amount > 0, "Cannot stake 0");
759         super.stake(amount);
760         emit Staked(msg.sender, amount);
761     }
762 
763     function withdraw(uint256 amount)
764         public
765         updateReward(msg.sender)
766         checkhalve
767         checkStart
768     {
769         require(amount > 0, "Cannot withdraw 0");
770         super.withdraw(amount);
771         emit Withdrawn(msg.sender, amount);
772     }
773 
774     function exit() external {
775         withdraw(balanceOf(msg.sender));
776         getReward();
777     }
778 
779     function setDeveloper(address _developer) public onlyDeveloper {
780         require(_developer != address(0), "developer can't be address(0)");
781         developer = _developer;
782     }
783 
784     function getReward() public updateReward(msg.sender) checkhalve checkStart {
785         uint256 reward = earned(msg.sender);
786         if (reward > 0) {
787             rewards[msg.sender] = 0;
788             yieldToken.safeTransfer(msg.sender, reward);
789             emit RewardPaid(msg.sender, reward);
790         }
791     }
792 
793     modifier checkhalve() {
794         if (block.timestamp >= periodFinish) {
795             initreward = initreward.mul(50).div(100);
796             yieldToken.mint(address(this), initreward);
797             yieldToken.mint(developer, initreward.mul(10).div(100));
798 
799             rewardRate = initreward.div(DURATION);
800             periodFinish = block.timestamp.add(DURATION);
801             emit RewardAdded(initreward);
802         }
803         _;
804     }
805     
806     modifier checkStart() {
807         require(block.timestamp > starttime, "not start");
808         _;
809     }
810 
811     function initialization() external onlyDeveloper updateReward(address(0)) {
812         require(isInit, "not initialization");
813 
814         rewardRate = initreward.div(DURATION);
815         yieldToken.mint(address(this), initreward);
816         yieldToken.mint(developer, initreward.mul(10).div(100));
817 
818         isInit = false;
819         emit RewardAdded(initreward);
820     }
821 }