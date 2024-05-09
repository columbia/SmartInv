1 pragma solidity 0.5.17;
2 
3 /*
4    ____            __   __        __   _
5   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
6  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
7 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
8      /___/
9 
10 * Synthetix: WARRewards.sol
11 *
12 * Docs: https://docs.synthetix.io/
13 *
14 *
15 * MIT License
16 * ===========
17 *
18 * Copyright (c) 2020 Synthetix
19 *
20 * Permission is hereby granted, free of charge, to any person obtaining a copy
21 * of this software and associated documentation files (the "Software"), to deal
22 * in the Software without restriction, including without limitation the rights
23 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
24 * copies of the Software, and to permit persons to whom the Software is
25 * furnished to do so, subject to the following conditions:
26 *
27 * The above copyright notice and this permission notice shall be included in all
28 * copies or substantial portions of the Software.
29 *
30 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
31 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
32 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
33 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
34 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
35 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
36 */
37 
38 
39 
40 
41 /**
42  * @dev Standard math utilities missing in the Solidity language.
43  */
44 library Math {
45     /**
46      * @dev Returns the largest of two numbers.
47      */
48     function max(uint256 a, uint256 b) internal pure returns (uint256) {
49         return a >= b ? a : b;
50     }
51 
52     /**
53      * @dev Returns the smallest of two numbers.
54      */
55     function min(uint256 a, uint256 b) internal pure returns (uint256) {
56         return a < b ? a : b;
57     }
58 
59     /**
60      * @dev Returns the average of two numbers. The result is rounded towards
61      * zero.
62      */
63     function average(uint256 a, uint256 b) internal pure returns (uint256) {
64         // (a + b) / 2 can overflow, so we distribute
65         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
66     }
67 }
68 
69 
70 
71 
72 /**
73  * @dev Wrappers over Solidity's arithmetic operations with added overflow
74  * checks.
75  *
76  * Arithmetic operations in Solidity wrap on overflow. This can easily result
77  * in bugs, because programmers usually assume that an overflow raises an
78  * error, which is the standard behavior in high level programming languages.
79  * `SafeMath` restores this intuition by reverting the transaction when an
80  * operation overflows.
81  *
82  * Using this library instead of the unchecked operations eliminates an entire
83  * class of bugs, so it's recommended to use it always.
84  */
85 library SafeMath {
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         uint256 c = a + b;
97         require(c >= a, "SafeMath: addition overflow");
98 
99         return c;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return sub(a, b, "SafeMath: subtraction overflow");
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      * - Subtraction cannot overflow.
123      *
124      * _Available since v2.4.0._
125      */
126     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b <= a, errorMessage);
128         uint256 c = a - b;
129 
130         return c;
131     }
132 
133     /**
134      * @dev Returns the multiplication of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `*` operator.
138      *
139      * Requirements:
140      * - Multiplication cannot overflow.
141      */
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
144         // benefit is lost if 'b' is also tested.
145         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
146         if (a == 0) {
147             return 0;
148         }
149 
150         uint256 c = a * b;
151         require(c / a == b, "SafeMath: multiplication overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the integer division of two unsigned integers. Reverts on
158      * division by zero. The result is rounded towards zero.
159      *
160      * Counterpart to Solidity's `/` operator. Note: this function uses a
161      * `revert` opcode (which leaves remaining gas untouched) while Solidity
162      * uses an invalid opcode to revert (consuming all remaining gas).
163      *
164      * Requirements:
165      * - The divisor cannot be zero.
166      */
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         return div(a, b, "SafeMath: division by zero");
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      * - The divisor cannot be zero.
181      *
182      * _Available since v2.4.0._
183      */
184     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
185         // Solidity only automatically asserts when dividing by 0
186         require(b > 0, errorMessage);
187         uint256 c = a / b;
188         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
205         return mod(a, b, "SafeMath: modulo by zero");
206     }
207 
208     /**
209      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
210      * Reverts with custom message when dividing by zero.
211      *
212      * Counterpart to Solidity's `%` operator. This function uses a `revert`
213      * opcode (which leaves remaining gas untouched) while Solidity uses an
214      * invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      * - The divisor cannot be zero.
218      *
219      * _Available since v2.4.0._
220      */
221     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
222         require(b != 0, errorMessage);
223         return a % b;
224     }
225 }
226 
227 
228 
229 
230 /*
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with GSN meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 contract Context {
241     // Empty internal constructor, to prevent people from mistakenly deploying
242     // an instance of this contract, which should be used via inheritance.
243     constructor () internal { }
244     // solhint-disable-previous-line no-empty-blocks
245 
246     function _msgSender() internal view returns (address payable) {
247         return msg.sender;
248     }
249 
250     function _msgData() internal view returns (bytes memory) {
251         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
252         return msg.data;
253     }
254 }
255 
256 
257 
258 /**
259  * @dev Contract module which provides a basic access control mechanism, where
260  * there is an account (an owner) that can be granted exclusive access to
261  * specific functions.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor () internal {
276         _owner = _msgSender();
277         emit OwnershipTransferred(address(0), _owner);
278     }
279 
280     /**
281      * @dev Returns the address of the current owner.
282      */
283     function owner() public view returns (address) {
284         return _owner;
285     }
286 
287     /**
288      * @dev Throws if called by any account other than the owner.
289      */
290     modifier onlyOwner() {
291         require(isOwner(), "Ownable: caller is not the owner");
292         _;
293     }
294 
295     /**
296      * @dev Returns true if the caller is the current owner.
297      */
298     function isOwner() public view returns (bool) {
299         return _msgSender() == _owner;
300     }
301 
302     /**
303      * @dev Leaves the contract without owner. It will not be possible to call
304      * `onlyOwner` functions anymore. Can only be called by the current owner.
305      *
306      * NOTE: Renouncing ownership will leave the contract without an owner,
307      * thereby removing any functionality that is only available to the owner.
308      */
309     function renounceOwnership() public onlyOwner {
310         emit OwnershipTransferred(_owner, address(0));
311         _owner = address(0);
312     }
313 
314     /**
315      * @dev Transfers ownership of the contract to a new account (`newOwner`).
316      * Can only be called by the current owner.
317      */
318     function transferOwnership(address newOwner) public onlyOwner {
319         _transferOwnership(newOwner);
320     }
321 
322     /**
323      * @dev Transfers ownership of the contract to a new account (`newOwner`).
324      */
325     function _transferOwnership(address newOwner) internal {
326         require(newOwner != address(0), "Ownable: new owner is the zero address");
327         emit OwnershipTransferred(_owner, newOwner);
328         _owner = newOwner;
329     }
330 }
331 
332 
333 
334 
335 /**
336  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
337  * the optional functions; to access them see {ERC20Detailed}.
338  */
339 interface IERC20 {
340     /**
341      * @dev Returns the amount of tokens in existence.
342      */
343     function totalSupply() external view returns (uint256);
344 
345     /**
346      * @dev Returns the amount of tokens owned by `account`.
347      */
348     function balanceOf(address account) external view returns (uint256);
349 
350     /**
351      * @dev Moves `amount` tokens from the caller's account to `recipient`.
352      *
353      * Returns a boolean value indicating whether the operation succeeded.
354      *
355      * Emits a {Transfer} event.
356      */
357     function transfer(address recipient, uint256 amount) external returns (bool);
358 
359     /**
360      * @dev Returns the remaining number of tokens that `spender` will be
361      * allowed to spend on behalf of `owner` through {transferFrom}. This is
362      * zero by default.
363      *
364      * This value changes when {approve} or {transferFrom} are called.
365      */
366     function allowance(address owner, address spender) external view returns (uint256);
367 
368     /**
369      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
370      *
371      * Returns a boolean value indicating whether the operation succeeded.
372      *
373      * IMPORTANT: Beware that changing an allowance with this method brings the risk
374      * that someone may use both the old and the new allowance by unfortunate
375      * transaction ordering. One possible solution to mitigate this race
376      * condition is to first reduce the spender's allowance to 0 and set the
377      * desired value afterwards:
378      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
379      *
380      * Emits an {Approval} event.
381      */
382     function approve(address spender, uint256 amount) external returns (bool);
383 
384     /**
385      * @dev Moves `amount` tokens from `sender` to `recipient` using the
386      * allowance mechanism. `amount` is then deducted from the caller's
387      * allowance.
388      *
389      * Returns a boolean value indicating whether the operation succeeded.
390      *
391      * Emits a {Transfer} event.
392      */
393     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
394 
395     /**
396      * @dev Emitted when `value` tokens are moved from one account (`from`) to
397      * another (`to`).
398      *
399      * Note that `value` may be zero.
400      */
401     event Transfer(address indexed from, address indexed to, uint256 value);
402 
403     /**
404      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
405      * a call to {approve}. `value` is the new allowance.
406      */
407     event Approval(address indexed owner, address indexed spender, uint256 value);
408 }
409 
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
435         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
436         // solhint-disable-next-line no-inline-assembly
437         assembly { codehash := extcodehash(account) }
438         return (codehash != 0x0 && codehash != accountHash);
439     }
440 
441     /**
442      * @dev Converts an `address` into `address payable`. Note that this is
443      * simply a type cast: the actual underlying value is not changed.
444      *
445      * _Available since v2.4.0._
446      */
447     function toPayable(address account) internal pure returns (address payable) {
448         return address(uint160(account));
449     }
450 
451     /**
452      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
453      * `recipient`, forwarding all available gas and reverting on errors.
454      *
455      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
456      * of certain opcodes, possibly making contracts go over the 2300 gas limit
457      * imposed by `transfer`, making them unable to receive funds via
458      * `transfer`. {sendValue} removes this limitation.
459      *
460      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
461      *
462      * IMPORTANT: because control is transferred to `recipient`, care must be
463      * taken to not create reentrancy vulnerabilities. Consider using
464      * {ReentrancyGuard} or the
465      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
466      *
467      * _Available since v2.4.0._
468      */
469     function sendValue(address payable recipient, uint256 amount) internal {
470         require(address(this).balance >= amount, "Address: insufficient balance");
471 
472         // solhint-disable-next-line avoid-call-value
473         (bool success, ) = recipient.call.value(amount)("");
474         require(success, "Address: unable to send value, recipient may have reverted");
475     }
476 }
477 
478 
479 
480 /**
481  * @title SafeERC20
482  * @dev Wrappers around ERC20 operations that throw on failure (when the token
483  * contract returns false). Tokens that return no value (and instead revert or
484  * throw on failure) are also supported, non-reverting calls are assumed to be
485  * successful.
486  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
487  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
488  */
489 library SafeERC20 {
490     using SafeMath for uint256;
491     using Address for address;
492 
493     function safeTransfer(IERC20 token, address to, uint256 value) internal {
494         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
495     }
496 
497     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
498         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
499     }
500 
501     function safeApprove(IERC20 token, address spender, uint256 value) internal {
502         // safeApprove should only be called when setting an initial allowance,
503         // or when resetting it to zero. To increase and decrease it, use
504         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
505         // solhint-disable-next-line max-line-length
506         require((value == 0) || (token.allowance(address(this), spender) == 0),
507             "SafeERC20: approve from non-zero to non-zero allowance"
508         );
509         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
510     }
511 
512     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
513         uint256 newAllowance = token.allowance(address(this), spender).add(value);
514         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
515     }
516 
517     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
518         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
519         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
520     }
521 
522     /**
523      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
524      * on the return value: the return value is optional (but if data is returned, it must not be false).
525      * @param token The token targeted by the call.
526      * @param data The call data (encoded using abi.encode or one of its variants).
527      */
528     function callOptionalReturn(IERC20 token, bytes memory data) private {
529         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
530         // we're implementing it ourselves.
531 
532         // A Solidity high level call has three parts:
533         //  1. The target address is checked to verify it contains contract code
534         //  2. The call itself is made, and success asserted
535         //  3. The return value is decoded, which in turn checks the size of the returned data.
536         // solhint-disable-next-line max-line-length
537         require(address(token).isContract(), "SafeERC20: call to non-contract");
538 
539         // solhint-disable-next-line avoid-low-level-calls
540         (bool success, bytes memory returndata) = address(token).call(data);
541         require(success, "SafeERC20: low-level call failed");
542 
543         if (returndata.length > 0) { // Return data is optional
544             // solhint-disable-next-line max-line-length
545             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
546         }
547     }
548 }
549 
550 
551 
552 
553 contract IRewardDistributionRecipient is Ownable {
554     address public rewardDistribution;
555 
556     function notifyRewardAmount(uint256 reward, uint256 _duration) external;
557 
558     modifier onlyRewardDistribution() {
559         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
560         _;
561     }
562 
563     function setRewardDistribution(address _rewardDistribution) external onlyOwner {
564         rewardDistribution = _rewardDistribution;
565     }
566 }
567 
568 
569 contract LPTokenWrapper {
570     using SafeMath for uint256;
571     using SafeERC20 for IERC20;
572 
573     IERC20 public lpToken;
574 
575     uint256 private _totalSupply;
576     mapping(address => uint256) private _balances;
577 
578     constructor(address _lpToken) internal {
579         lpToken = IERC20(_lpToken);
580     }
581 
582     function totalSupply() public view returns (uint256) {
583         return _totalSupply;
584     }
585 
586     function balanceOf(address account) public view returns (uint256) {
587         return _balances[account];
588     }
589 
590     function stake(uint256 amount) public {
591         _totalSupply = _totalSupply.add(amount);
592         _balances[msg.sender] = _balances[msg.sender].add(amount);
593         lpToken.safeTransferFrom(msg.sender, address(this), amount);
594     }
595 
596     function withdraw(uint256 amount) public {
597         _totalSupply = _totalSupply.sub(amount);
598         _balances[msg.sender] = _balances[msg.sender].sub(amount);
599         lpToken.safeTransfer(msg.sender, amount);
600     }
601 }
602 
603 contract WARPool is LPTokenWrapper, IRewardDistributionRecipient {
604     IERC20 public constant war = IERC20(0xf4A81C18816C9B0AB98FAC51B36Dcb63b0E58Fde);
605 
606     string public desc;
607 
608     uint256 public DURATION;
609     uint256 public starttime;
610 
611     uint256 public maxStakeFirstDay;
612 
613     uint256 public periodFinish = 0;
614     uint256 public rewardRate = 0;
615     uint256 public lastUpdateTime;
616     uint256 public rewardPerTokenStored;
617     mapping(address => uint256) public userRewardPerTokenPaid;
618     mapping(address => uint256) public rewards;
619 
620     event RewardAdded(uint256 reward);
621     event Staked(address indexed user, uint256 amount);
622     event Withdrawn(address indexed user, uint256 amount);
623     event RewardPaid(address indexed user, uint256 reward);
624 
625     constructor(address _lpToken, string memory _desc, uint256 _maxStakeFirstDay, uint256 _starttime) public LPTokenWrapper(_lpToken) {
626         rewardDistribution = msg.sender;
627         desc = _desc;
628         maxStakeFirstDay = _maxStakeFirstDay;
629         starttime = _starttime;
630     }
631 
632     function setStartTime(uint256 _starttime) external onlyOwner {
633         require(block.timestamp < starttime, "started");
634         starttime = _starttime;
635     }
636 
637     function setMaxStakeFirstDay(uint256 _maxStakeFirstDay) external onlyOwner {
638         maxStakeFirstDay = _maxStakeFirstDay;
639     }
640 
641     modifier checkStart(){
642         require(block.timestamp >= starttime, "not started");
643         _;
644     }
645 
646     modifier updateReward(address account) {
647         rewardPerTokenStored = rewardPerToken();
648         lastUpdateTime = lastTimeRewardApplicable();
649         if (account != address(0)) {
650             rewards[account] = earned(account);
651             userRewardPerTokenPaid[account] = rewardPerTokenStored;
652         }
653         _;
654     }
655 
656     modifier checkBalance(uint256 amount) {
657         uint256 _starttime = starttime;
658         if (block.timestamp >= _starttime && block.timestamp < _starttime + 1 days) {
659             require(balanceOf(msg.sender).add(amount) <= maxStakeFirstDay, "over limit");
660         }
661         _;
662     }
663 
664 
665     function seize(IERC20 _token, uint amount) external onlyOwner {
666         if (block.timestamp >= starttime && block.timestamp < periodFinish) {
667             require(_token != lpToken, "lpToken");
668         }
669         _token.safeTransfer(msg.sender, amount);
670     }
671 
672     function lastTimeRewardApplicable() public view returns (uint256) {
673         return Math.min(block.timestamp, periodFinish);
674     }
675 
676     function rewardPerToken() public view returns (uint256) {
677         if (totalSupply() == 0) {
678             return rewardPerTokenStored;
679         }
680         return
681             rewardPerTokenStored.add(
682                 lastTimeRewardApplicable()
683                     .sub(lastUpdateTime)
684                     .mul(rewardRate)
685                     .mul(1e18)
686                     .div(totalSupply())
687             );
688     }
689 
690     function earned(address account) public view returns (uint256) {
691         return
692             balanceOf(account)
693                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
694                 .div(1e18)
695                 .add(rewards[account]);
696     }
697 
698     function stake(uint256 amount) public updateReward(msg.sender) checkStart checkBalance(amount) {
699         require(amount > 0, "Cannot stake 0");
700         super.stake(amount);
701         emit Staked(msg.sender, amount);
702     }
703 
704     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
705         require(amount > 0, "Cannot withdraw 0");
706         super.withdraw(amount);
707         emit Withdrawn(msg.sender, amount);
708     }
709 
710     function exit() external {
711         withdraw(balanceOf(msg.sender));
712         getReward();
713     }
714 
715     function getReward() public updateReward(msg.sender) checkStart {
716         uint256 reward = earned(msg.sender);
717         if (reward > 0) {
718             rewards[msg.sender] = 0;
719             war.safeTransfer(msg.sender, reward);
720             emit RewardPaid(msg.sender, reward);
721         }
722     }
723 
724     function notifyRewardAmount(uint256 _reward, uint256 _duration) external onlyRewardDistribution updateReward(address(0)) {
725         require(_duration != 0, "Duration must not be 0");
726         require(_reward != 0, "Reward must not be 0");
727 
728         war.safeTransferFrom(msg.sender, address(this), _reward);
729         DURATION = _duration;
730         if (block.timestamp > starttime) {
731             if (block.timestamp >= periodFinish) {
732                 rewardRate = _reward.div(_duration);
733             } else {
734                 uint256 remaining = periodFinish.sub(block.timestamp);
735                 uint256 leftover = remaining.mul(rewardRate);
736                 rewardRate = _reward.add(leftover).div(_duration);
737             }
738             lastUpdateTime = block.timestamp;
739             periodFinish = block.timestamp.add(_duration);
740             emit RewardAdded(_reward);
741         } else {
742             rewardRate = _reward.div(_duration);
743             lastUpdateTime = starttime;
744             periodFinish = starttime.add(_duration);
745             emit RewardAdded(_reward);
746         }
747     }
748 }