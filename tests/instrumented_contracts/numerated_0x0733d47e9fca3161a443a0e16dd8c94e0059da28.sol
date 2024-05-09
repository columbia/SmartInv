1 pragma solidity ^0.5.17;
2 /**
3 */
4 
5 /*
6    ____            __   __        __   _
7   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
8  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
9 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
10      /___/
11 
12 * Synthetix: YFIRewards.sol
13 *
14 * Docs: https://docs.synthetix.io/
15 *
16 */
17 
18 
19 
20 /**
21  * @dev Standard math utilities missing in the Solidity language.
22  */
23 library Math {
24     /**
25      * @dev Returns the largest of two numbers.
26      */
27     function max(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a >= b ? a : b;
29     }
30 
31     /**
32      * @dev Returns the smallest of two numbers.
33      */
34     function min(uint256 a, uint256 b) internal pure returns (uint256) {
35         return a < b ? a : b;
36     }
37 
38     /**
39      * @dev Returns the average of two numbers. The result is rounded towards
40      * zero.
41      */
42     function average(uint256 a, uint256 b) internal pure returns (uint256) {
43         // (a + b) / 2 can overflow, so we distribute
44         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
45     }
46 }
47 
48 /**
49  * @dev Wrappers over Solidity's arithmetic operations with added overflow
50  * checks.
51  *
52  * Arithmetic operations in Solidity wrap on overflow. This can easily result
53  * in bugs, because programmers usually assume that an overflow raises an
54  * error, which is the standard behavior in high level programming languages.
55  * `SafeMath` restores this intuition by reverting the transaction when an
56  * operation overflows.
57  *
58  * Using this library instead of the unchecked operations eliminates an entire
59  * class of bugs, so it's recommended to use it always.
60  */
61 library SafeMath {
62     /**
63      * @dev Returns the addition of two unsigned integers, reverting on
64      * overflow.
65      *
66      * Counterpart to Solidity's `+` operator.
67      *
68      * Requirements:
69      * - Addition cannot overflow.
70      */
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74 
75         return c;
76     }
77 
78     /**
79      * @dev Returns the subtraction of two unsigned integers, reverting on
80      * overflow (when the result is negative).
81      *
82      * Counterpart to Solidity's `-` operator.
83      *
84      * Requirements:
85      * - Subtraction cannot overflow.
86      */
87     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
88         return sub(a, b, "SafeMath: subtraction overflow");
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      * - Subtraction cannot overflow.
99      *
100      * _Available since v2.4.0._
101      */
102     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
103         require(b <= a, errorMessage);
104         uint256 c = a - b;
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the multiplication of two unsigned integers, reverting on
111      * overflow.
112      *
113      * Counterpart to Solidity's `*` operator.
114      *
115      * Requirements:
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
120         // benefit is lost if 'b' is also tested.
121         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
122         if (a == 0) {
123             return 0;
124         }
125 
126         uint256 c = a * b;
127         require(c / a == b, "SafeMath: multiplication overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the integer division of two unsigned integers. Reverts on
134      * division by zero. The result is rounded towards zero.
135      *
136      * Counterpart to Solidity's `/` operator. Note: this function uses a
137      * `revert` opcode (which leaves remaining gas untouched) while Solidity
138      * uses an invalid opcode to revert (consuming all remaining gas).
139      *
140      * Requirements:
141      * - The divisor cannot be zero.
142      */
143     function div(uint256 a, uint256 b) internal pure returns (uint256) {
144         return div(a, b, "SafeMath: division by zero");
145     }
146 
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      *
158      * _Available since v2.4.0._
159      */
160     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         // Solidity only automatically asserts when dividing by 0
162         require(b > 0, errorMessage);
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      */
180     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
181         return mod(a, b, "SafeMath: modulo by zero");
182     }
183 
184     /**
185      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
186      * Reverts with custom message when dividing by zero.
187      *
188      * Counterpart to Solidity's `%` operator. This function uses a `revert`
189      * opcode (which leaves remaining gas untouched) while Solidity uses an
190      * invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      * - The divisor cannot be zero.
194      *
195      * _Available since v2.4.0._
196      */
197     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b != 0, errorMessage);
199         return a % b;
200     }
201 }
202 
203 /*
204  * @dev Provides information about the current execution context, including the
205  * sender of the transaction and its data. While these are generally available
206  * via msg.sender and msg.data, they should not be accessed in such a direct
207  * manner, since when dealing with GSN meta-transactions the account sending and
208  * paying for execution may not be the actual sender (as far as an application
209  * is concerned).
210  *
211  * This contract is only required for intermediate, library-like contracts.
212  */
213 contract Context {
214     // Empty internal constructor, to prevent people from mistakenly deploying
215     // an instance of this contract, which should be used via inheritance.
216     constructor () internal { }
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
229 /**
230  * @dev Contract module which provides a basic access control mechanism, where
231  * there is an account (an owner) that can be granted exclusive access to
232  * specific functions.
233  *
234  * This module is used through inheritance. It will make available the modifier
235  * `onlyOwner`, which can be applied to your functions to restrict their use to
236  * the owner.
237  */
238 contract Ownable is Context {
239     address private _owner;
240 
241     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
242 
243     /**
244      * @dev Initializes the contract setting the deployer as the initial owner.
245      */
246     constructor () internal {
247         _owner = _msgSender();
248         emit OwnershipTransferred(address(0), _owner);
249     }
250 
251     /**
252      * @dev Returns the address of the current owner.
253      */
254     function owner() public view returns (address) {
255         return _owner;
256     }
257 
258     /**
259      * @dev Throws if called by any account other than the owner.
260      */
261     modifier onlyOwner() {
262         require(isOwner(), "Ownable: caller is not the owner");
263         _;
264     }
265 
266     /**
267      * @dev Returns true if the caller is the current owner.
268      */
269     function isOwner() public view returns (bool) {
270         return _msgSender() == _owner;
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions anymore. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby removing any functionality that is only available to the owner.
279      */
280     function renounceOwnership() public onlyOwner {
281         emit OwnershipTransferred(_owner, address(0));
282         _owner = address(0);
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public onlyOwner {
290         _transferOwnership(newOwner);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      */
296     function _transferOwnership(address newOwner) internal {
297         require(newOwner != address(0), "Ownable: new owner is the zero address");
298         emit OwnershipTransferred(_owner, newOwner);
299         _owner = newOwner;
300     }
301 }
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
326     function mint(address account, uint amount) external;
327 
328     /**
329      * @dev Returns the remaining number of tokens that `spender` will be
330      * allowed to spend on behalf of `owner` through {transferFrom}. This is
331      * zero by default.
332      *
333      * This value changes when {approve} or {transferFrom} are called.
334      */
335     function allowance(address owner, address spender) external view returns (uint256);
336 
337     /**
338      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * IMPORTANT: Beware that changing an allowance with this method brings the risk
343      * that someone may use both the old and the new allowance by unfortunate
344      * transaction ordering. One possible solution to mitigate this race
345      * condition is to first reduce the spender's allowance to 0 and set the
346      * desired value afterwards:
347      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
348      *
349      * Emits an {Approval} event.
350      */
351     function approve(address spender, uint256 amount) external returns (bool);
352 
353     /**
354      * @dev Moves `amount` tokens from `sender` to `recipient` using the
355      * allowance mechanism. `amount` is then deducted from the caller's
356      * allowance.
357      *
358      * Returns a boolean value indicating whether the operation succeeded.
359      *
360      * Emits a {Transfer} event.
361      */
362     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
363 
364     /**
365      * @dev Emitted when `value` tokens are moved from one account (`from`) to
366      * another (`to`).
367      *
368      * Note that `value` may be zero.
369      */
370     event Transfer(address indexed from, address indexed to, uint256 value);
371 
372     /**
373      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
374      * a call to {approve}. `value` is the new allowance.
375      */
376     event Approval(address indexed owner, address indexed spender, uint256 value);
377 }
378 
379 // File: @openzeppelin/contracts/utils/Address.sol
380 
381 pragma solidity ^0.5.5;
382 
383 /**
384  * @dev Collection of functions related to the address type
385  */
386 library Address {
387     /**
388      * @dev Returns true if `account` is a contract.
389      *
390      * This test is non-exhaustive, and there may be false-negatives: during the
391      * execution of a contract's constructor, its address will be reported as
392      * not containing a contract.
393      *
394      * IMPORTANT: It is unsafe to assume that an address for which this
395      * function returns false is an externally-owned account (EOA) and not a
396      * contract.
397      */
398     function isContract(address account) internal view returns (bool) {
399         // This method relies in extcodesize, which returns 0 for contracts in
400         // construction, since the code is only stored at the end of the
401         // constructor execution.
402 
403         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
404         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
405         // for accounts without code, i.e. `keccak256('')`
406         bytes32 codehash;
407         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
408         // solhint-disable-next-line no-inline-assembly
409         assembly { codehash := extcodehash(account) }
410         return (codehash != 0x0 && codehash != accountHash);
411     }
412 
413     /**
414      * @dev Converts an `address` into `address payable`. Note that this is
415      * simply a type cast: the actual underlying value is not changed.
416      *
417      * _Available since v2.4.0._
418      */
419     function toPayable(address account) internal pure returns (address payable) {
420         return address(uint160(account));
421     }
422 
423     /**
424      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
425      * `recipient`, forwarding all available gas and reverting on errors.
426      *
427      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
428      * of certain opcodes, possibly making contracts go over the 2300 gas limit
429      * imposed by `transfer`, making them unable to receive funds via
430      * `transfer`. {sendValue} removes this limitation.
431      *
432      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
433      *
434      * IMPORTANT: because control is transferred to `recipient`, care must be
435      * taken to not create reentrancy vulnerabilities. Consider using
436      * {ReentrancyGuard} or the
437      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
438      *
439      * _Available since v2.4.0._
440      */
441     function sendValue(address payable recipient, uint256 amount) internal {
442         require(address(this).balance >= amount, "Address: insufficient balance");
443 
444         // solhint-disable-next-line avoid-call-value
445         (bool success, ) = recipient.call.value(amount)("");
446         require(success, "Address: unable to send value, recipient may have reverted");
447     }
448 }
449 
450 /**
451  * @title SafeERC20
452  * @dev Wrappers around ERC20 operations that throw on failure (when the token
453  * contract returns false). Tokens that return no value (and instead revert or
454  * throw on failure) are also supported, non-reverting calls are assumed to be
455  * successful.
456  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
457  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
458  */
459 library SafeERC20 {
460     using SafeMath for uint256;
461     using Address for address;
462 
463     function safeTransfer(IERC20 token, address to, uint256 value) internal {
464         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
465     }
466 
467     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
468         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
469     }
470 
471     function safeApprove(IERC20 token, address spender, uint256 value) internal {
472         // safeApprove should only be called when setting an initial allowance,
473         // or when resetting it to zero. To increase and decrease it, use
474         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
475         // solhint-disable-next-line max-line-length
476         require((value == 0) || (token.allowance(address(this), spender) == 0),
477             "SafeERC20: approve from non-zero to non-zero allowance"
478         );
479         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
480     }
481 
482     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
483         uint256 newAllowance = token.allowance(address(this), spender).add(value);
484         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
485     }
486 
487     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
488         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
489         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
490     }
491 
492     /**
493      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
494      * on the return value: the return value is optional (but if data is returned, it must not be false).
495      * @param token The token targeted by the call.
496      * @param data The call data (encoded using abi.encode or one of its variants).
497      */
498     function callOptionalReturn(IERC20 token, bytes memory data) private {
499         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
500         // we're implementing it ourselves.
501 
502         // A Solidity high level call has three parts:
503         //  1. The target address is checked to verify it contains contract code
504         //  2. The call itself is made, and success asserted
505         //  3. The return value is decoded, which in turn checks the size of the returned data.
506         // solhint-disable-next-line max-line-length
507         require(address(token).isContract(), "SafeERC20: call to non-contract");
508 
509         // solhint-disable-next-line avoid-low-level-calls
510         (bool success, bytes memory returndata) = address(token).call(data);
511         require(success, "SafeERC20: low-level call failed");
512 
513         if (returndata.length > 0) { // Return data is optional
514             // solhint-disable-next-line max-line-length
515             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
516         }
517     }
518 }
519 
520 contract IRewardDistributionRecipient is Ownable {
521     address rewardDistribution = 0x680b6e26C9b0107fda32D8395a977F3F00fa0c7F;
522 
523     function notifyRewardAmount(uint256 reward) external;
524 
525     modifier onlyRewardDistribution() {
526         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
527         _;
528     }
529 
530     function setRewardDistribution(address _rewardDistribution)
531         external
532         onlyOwner
533     {
534         rewardDistribution = _rewardDistribution;
535     }
536 }
537 contract YRXPoolone {
538      function balanceOf(address account) external view returns (uint256);
539 }
540 
541 contract LPTokenWrapper is YRXPoolone {
542     using SafeMath for uint256;
543     using SafeERC20 for IERC20;
544     address public poolSetter = 0x680b6e26C9b0107fda32D8395a977F3F00fa0c7F; //LOS + rrvx deployer
545 
546     IERC20 public rvx = IERC20(0x91d6f6e9026E43240ce6F06Af6a4b33129EBdE94); 
547     IERC20 public rRvx = IERC20(0x6f7B10841eABd73ad226BBf653989539f1BFf809); 
548     YRXPoolone public yrx;
549     address public constant rRVXcollection = 0x680b6e26C9b0107fda32D8395a977F3F00fa0c7F; //change RRVX deyploer
550   
551 
552     uint256 private _totalSupply;
553     mapping(address => uint256) private _balances;
554     
555     modifier onlyPoolSetter() {
556         require(msg.sender == poolSetter);
557         _;
558     }
559     
560 
561     function setYRXPoolOne(address _address) public onlyPoolSetter {
562         yrx = YRXPoolone(_address);
563         
564     }
565 
566     function totalSupply() public view returns (uint256) {
567         return _totalSupply;
568     }
569 
570     function balanceOf(address account) public view returns (uint256) {
571         return _balances[account];
572     }
573 
574     function adjustStake(address account) internal {
575         uint256 rrvxbal = rRvx.balanceOf(account);
576         uint256 rrvxpoolbal = yrx.balanceOf(account);
577         uint256 newbal = rrvxbal.add(rrvxpoolbal);
578         _balances[account] = newbal;
579 
580     }
581     function stake(uint256 amount) public {
582         _totalSupply = _totalSupply.add(amount);
583         _balances[msg.sender] = _balances[msg.sender].add(amount);
584         rvx.safeTransferFrom(msg.sender, address(this), amount);
585     }
586     
587      function getrRVX(uint256 amount) internal {
588 
589         rRvx.mint(msg.sender,amount); //contract needs to be minter of RRVX
590     }
591     
592     function burnrRVX(uint256 amount) internal { //rRVX sent to collection address (maybe timelocked wallet)
593 
594         rRvx.safeTransferFrom(msg.sender,rRVXcollection,amount);
595     }
596 
597     function withdrawRvx(uint256 amount) internal {
598         require(amount <= rRvx.balanceOf(msg.sender),"Can't withdrawrvx more than your amount");
599         if(amount > _balances[msg.sender] || amount > _totalSupply) { //check if amount is higher than total supply of deposited RVX (should happen in rare scenarios)
600             _totalSupply = 0;
601             _balances[msg.sender] = 0;
602             rvx.safeTransfer(msg.sender, amount);
603         } else {
604             _totalSupply = _totalSupply.sub(amount);
605             _balances[msg.sender] = _balances[msg.sender].sub(amount);
606              rvx.safeTransfer(msg.sender, amount);
607         }
608         
609     }
610 
611 }
612 
613 contract Losv2 is LPTokenWrapper, IRewardDistributionRecipient {
614     IERC20 public rvx = IERC20(0x91d6f6e9026E43240ce6F06Af6a4b33129EBdE94);
615     uint8 public constant NUMBER_EPOCHS = 11;
616      uint256 public constant EPOCH_REWARD = 63636 ether;
617       uint256 public constant TOTAL_REWARD = EPOCH_REWARD * NUMBER_EPOCHS;
618     uint256 public constant DURATION = 7 days;
619      uint256 public currentEpochReward = EPOCH_REWARD;
620      uint256 public totalAccumulatedReward = 0;
621       uint8 public currentEpoch = 0;
622     uint256 public starttime = 1602237600; //Friday, October 9, 2020 12:00:00 PM GMT+02:00 || Friday, October 9, 6 PM SGT
623     uint256 public periodFinish = 0;
624     uint256 public rewardRate = 0;
625     uint256 public lastUpdateTime;
626     uint256 public rewardPerTokenStored;
627     mapping(address => uint256) public userRewardPerTokenPaid;
628     mapping(address => uint256) public rewards;
629 
630     event RewardAdded(uint256 reward);
631     event Staked(address indexed user, uint256 amount);
632     event Withdrawn(address indexed user, uint256 amount);
633     event RewardPaid(address indexed user, uint256 reward);
634 
635     modifier updateReward(address account) {
636        
637         rewardPerTokenStored = rewardPerToken();
638         lastUpdateTime = lastTimeRewardApplicable();
639         if (account != address(0)) {
640             rewards[account] = earned(account);
641             userRewardPerTokenPaid[account] = rewardPerTokenStored;
642         }
643         _;
644     }
645 
646     function lastTimeRewardApplicable() public view returns (uint256) {
647         return Math.min(block.timestamp, periodFinish);
648     }
649 
650     function rewardPerToken() public view returns (uint256) {
651         if (totalSupply() == 0) {
652             return rewardPerTokenStored;
653         }
654         return
655             rewardPerTokenStored.add(
656                 lastTimeRewardApplicable()
657                     .sub(lastUpdateTime)
658                     .mul(rewardRate)
659                     .mul(1e18)
660                     .div(totalSupply())
661             );
662     }
663 
664     function earned(address account) public view returns (uint256) {
665         return
666             balanceOf(account)
667                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
668                 .div(1e18)
669                 .add(rewards[account]);
670     }
671 
672     // stake visibility is public as overriding LPTokenWrapper's stake() function
673     function stake(uint256 amount) public updateReward(msg.sender) checkNextEpoch checkStart{
674         require(amount > 0, "Cannot stake 0");
675         super.stake(amount); //stake RVX
676         super.getrRVX(amount); //get equal amount rRVX
677         emit Staked(msg.sender, amount);
678     }
679 
680     function withdraw(uint256 amount) public updateReward(msg.sender) checkNextEpoch checkStart{
681         require(amount > 0, "Cannot withdraw 0");
682         require(amount <= rRvx.balanceOf(msg.sender),"Can't withdraw more rrvx than you have"); //amount can't be higher than users rRVX balance.
683         super.withdrawRvx(amount); //RVX is withdrawn based on rRVX amount.
684         super.burnrRVX(amount); //rRVX is sent to collection address
685         emit Withdrawn(msg.sender, amount);
686     }
687 
688     function exit() external {
689         withdraw(rRvx.balanceOf(msg.sender)); //withdraws all users RVX + reward based on rRVX balance
690         getReward();
691     }
692     
693     function getRRVXBalance(address account) public view returns(uint256) { //testing
694         return rRvx.balanceOf(account);
695     }
696 
697     function getReward() public updateReward(msg.sender) checkNextEpoch checkStart{
698        
699         uint256 reward = earned(msg.sender);
700         if (reward > 0) {
701             rewards[msg.sender] = 0;
702             rvx.safeTransfer(msg.sender, reward);
703             emit RewardPaid(msg.sender, reward);
704             super.adjustStake(msg.sender);
705         }
706     }
707 
708   modifier checkNextEpoch() {
709         if (block.timestamp >= periodFinish) {
710             currentEpochReward = EPOCH_REWARD;
711 
712             if (totalAccumulatedReward.add(currentEpochReward) > TOTAL_REWARD) {
713                 currentEpochReward = TOTAL_REWARD.sub(totalAccumulatedReward); // limit total reward
714             }
715 
716             if (currentEpochReward > 0) {
717                 totalAccumulatedReward = totalAccumulatedReward.add(currentEpochReward);
718                 currentEpoch++;
719             }
720 
721             rewardRate = currentEpochReward.div(DURATION);
722             lastUpdateTime = block.timestamp;
723             periodFinish = block.timestamp.add(DURATION);
724             emit RewardAdded(currentEpochReward);
725         }
726         _;
727     }
728     
729     function emergencyDrain(address _addy) public onlyRewardDistribution{
730         IERC20 token = IERC20(_addy);
731         token.safeTransfer(msg.sender,token.balanceOf(address(this)));
732     }
733     
734     modifier checkStart(){
735         require(block.timestamp > starttime,"not start");
736         _;
737     }
738 
739     function notifyRewardAmount(uint256 reward)
740         external
741         onlyRewardDistribution
742         updateReward(address(0))
743     {
744         currentEpochReward = reward;
745          if (totalAccumulatedReward.add(currentEpochReward) > TOTAL_REWARD) {
746             currentEpochReward = TOTAL_REWARD.sub(totalAccumulatedReward); // limit total reward
747         }
748         
749         rewardRate = currentEpochReward.div(DURATION);
750         totalAccumulatedReward = totalAccumulatedReward.add(currentEpochReward);
751         currentEpoch++;
752         lastUpdateTime = block.timestamp;
753         periodFinish = starttime.add(DURATION);
754         emit RewardAdded(currentEpochReward);
755     }
756 }