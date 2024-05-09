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
38 /**
39  * @dev Standard math utilities missing in the Solidity language.
40  */
41 library Math {
42     /**
43      * @dev Returns the largest of two numbers.
44      */
45     function max(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a >= b ? a : b;
47     }
48 
49     /**
50      * @dev Returns the smallest of two numbers.
51      */
52     function min(uint256 a, uint256 b) internal pure returns (uint256) {
53         return a < b ? a : b;
54     }
55 
56     /**
57      * @dev Returns the average of two numbers. The result is rounded towards
58      * zero.
59      */
60     function average(uint256 a, uint256 b) internal pure returns (uint256) {
61         // (a + b) / 2 can overflow, so we distribute
62         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
63     }
64 }
65 
66 /**
67  * @dev Wrappers over Solidity's arithmetic operations with added overflow
68  * checks.
69  *
70  * Arithmetic operations in Solidity wrap on overflow. This can easily result
71  * in bugs, because programmers usually assume that an overflow raises an
72  * error, which is the standard behavior in high level programming languages.
73  * `SafeMath` restores this intuition by reverting the transaction when an
74  * operation overflows.
75  *
76  * Using this library instead of the unchecked operations eliminates an entire
77  * class of bugs, so it's recommended to use it always.
78  */
79 library SafeMath {
80     /**
81      * @dev Returns the addition of two unsigned integers, reverting on
82      * overflow.
83      *
84      * Counterpart to Solidity's `+` operator.
85      *
86      * Requirements:
87      * - Addition cannot overflow.
88      */
89     function add(uint256 a, uint256 b) internal pure returns (uint256) {
90         uint256 c = a + b;
91         require(c >= a, "SafeMath: addition overflow");
92 
93         return c;
94     }
95 
96     /**
97      * @dev Returns the subtraction of two unsigned integers, reverting on
98      * overflow (when the result is negative).
99      *
100      * Counterpart to Solidity's `-` operator.
101      *
102      * Requirements:
103      * - Subtraction cannot overflow.
104      */
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      * - Subtraction cannot overflow.
117      *
118      * _Available since v2.4.0._
119      */
120     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b <= a, errorMessage);
122         uint256 c = a - b;
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140         if (a == 0) {
141             return 0;
142         }
143 
144         uint256 c = a * b;
145         require(c / a == b, "SafeMath: multiplication overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the integer division of two unsigned integers. Reverts on
152      * division by zero. The result is rounded towards zero.
153      *
154      * Counterpart to Solidity's `/` operator. Note: this function uses a
155      * `revert` opcode (which leaves remaining gas untouched) while Solidity
156      * uses an invalid opcode to revert (consuming all remaining gas).
157      *
158      * Requirements:
159      * - The divisor cannot be zero.
160      */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         return div(a, b, "SafeMath: division by zero");
163     }
164 
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      *
176      * _Available since v2.4.0._
177      */
178     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         // Solidity only automatically asserts when dividing by 0
180         require(b > 0, errorMessage);
181         uint256 c = a / b;
182         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
189      * Reverts when dividing by zero.
190      *
191      * Counterpart to Solidity's `%` operator. This function uses a `revert`
192      * opcode (which leaves remaining gas untouched) while Solidity uses an
193      * invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      * - The divisor cannot be zero.
197      */
198     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
199         return mod(a, b, "SafeMath: modulo by zero");
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts with custom message when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      * - The divisor cannot be zero.
212      *
213      * _Available since v2.4.0._
214      */
215     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b != 0, errorMessage);
217         return a % b;
218     }
219 }
220 
221 /*
222  * @dev Provides information about the current execution context, including the
223  * sender of the transaction and its data. While these are generally available
224  * via msg.sender and msg.data, they should not be accessed in such a direct
225  * manner, since when dealing with GSN meta-transactions the account sending and
226  * paying for execution may not be the actual sender (as far as an application
227  * is concerned).
228  *
229  * This contract is only required for intermediate, library-like contracts.
230  */
231 contract Context {
232     // Empty internal constructor, to prevent people from mistakenly deploying
233     // an instance of this contract, which should be used via inheritance.
234     constructor () internal { }
235     // solhint-disable-previous-line no-empty-blocks
236 
237     function _msgSender() internal view returns (address payable) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view returns (bytes memory) {
242         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
243         return msg.data;
244     }
245 }
246 
247 /**
248  * @dev Contract module which provides a basic access control mechanism, where
249  * there is an account (an owner) that can be granted exclusive access to
250  * specific functions.
251  *
252  * This module is used through inheritance. It will make available the modifier
253  * `onlyOwner`, which can be applied to your functions to restrict their use to
254  * the owner.
255  */
256 contract Ownable is Context {
257     address private _owner;
258 
259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
260 
261     /**
262      * @dev Initializes the contract setting the deployer as the initial owner.
263      */
264     constructor () internal {
265         _owner = _msgSender();
266         emit OwnershipTransferred(address(0), _owner);
267     }
268 
269     /**
270      * @dev Returns the address of the current owner.
271      */
272     function owner() public view returns (address) {
273         return _owner;
274     }
275 
276     /**
277      * @dev Throws if called by any account other than the owner.
278      */
279     modifier onlyOwner() {
280         require(isOwner(), "Ownable: caller is not the owner");
281         _;
282     }
283 
284     /**
285      * @dev Returns true if the caller is the current owner.
286      */
287     function isOwner() public view returns (bool) {
288         return _msgSender() == _owner;
289     }
290 
291     /**
292      * @dev Leaves the contract without owner. It will not be possible to call
293      * `onlyOwner` functions anymore. Can only be called by the current owner.
294      *
295      * NOTE: Renouncing ownership will leave the contract without an owner,
296      * thereby removing any functionality that is only available to the owner.
297      */
298     function renounceOwnership() public onlyOwner {
299         emit OwnershipTransferred(_owner, address(0));
300         _owner = address(0);
301     }
302 
303     /**
304      * @dev Transfers ownership of the contract to a new account (`newOwner`).
305      * Can only be called by the current owner.
306      */
307     function transferOwnership(address newOwner) public onlyOwner {
308         _transferOwnership(newOwner);
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      */
314     function _transferOwnership(address newOwner) internal {
315         require(newOwner != address(0), "Ownable: new owner is the zero address");
316         emit OwnershipTransferred(_owner, newOwner);
317         _owner = newOwner;
318     }
319 }
320 
321 
322 /**
323  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
324  * the optional functions; to access them see {ERC20Detailed}.
325  */
326 interface IERC20 {
327     /**
328      * @dev Returns the amount of tokens in existence.
329      */
330     function totalSupply() external view returns (uint256);
331 
332     /**
333      * @dev Returns the amount of tokens owned by `account`.
334      */
335     function balanceOf(address account) external view returns (uint256);
336 
337     /**
338      * @dev Moves `amount` tokens from the caller's account to `recipient`.
339      *
340      * Returns a boolean value indicating whether the operation succeeded.
341      *
342      * Emits a {Transfer} event.
343      */
344     function transfer(address recipient, uint256 amount) external returns (bool);
345 
346     /**
347      * @dev Returns the remaining number of tokens that `spender` will be
348      * allowed to spend on behalf of `owner` through {transferFrom}. This is
349      * zero by default.
350      *
351      * This value changes when {approve} or {transferFrom} are called.
352      */
353     function allowance(address owner, address spender) external view returns (uint256);
354 
355     /**
356      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
357      *
358      * Returns a boolean value indicating whether the operation succeeded.
359      *
360      * IMPORTANT: Beware that changing an allowance with this method brings the risk
361      * that someone may use both the old and the new allowance by unfortunate
362      * transaction ordering. One possible solution to mitigate this race
363      * condition is to first reduce the spender's allowance to 0 and set the
364      * desired value afterwards:
365      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
366      *
367      * Emits an {Approval} event.
368      */
369     function approve(address spender, uint256 amount) external returns (bool);
370 
371     /**
372      * @dev Moves `amount` tokens from `sender` to `recipient` using the
373      * allowance mechanism. `amount` is then deducted from the caller's
374      * allowance.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Emitted when `value` tokens are moved from one account (`from`) to
384      * another (`to`).
385      *
386      * Note that `value` may be zero.
387      */
388     event Transfer(address indexed from, address indexed to, uint256 value);
389 
390     /**
391      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
392      * a call to {approve}. `value` is the new allowance.
393      */
394     event Approval(address indexed owner, address indexed spender, uint256 value);
395 }
396 
397 
398 /**
399  * @dev Collection of functions related to the address type
400  */
401 library Address {
402     /**
403      * @dev Returns true if `account` is a contract.
404      *
405      * This test is non-exhaustive, and there may be false-negatives: during the
406      * execution of a contract's constructor, its address will be reported as
407      * not containing a contract.
408      *
409      * IMPORTANT: It is unsafe to assume that an address for which this
410      * function returns false is an externally-owned account (EOA) and not a
411      * contract.
412      */
413     function isContract(address account) internal view returns (bool) {
414         // This method relies in extcodesize, which returns 0 for contracts in
415         // construction, since the code is only stored at the end of the
416         // constructor execution.
417 
418         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
419         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
420         // for accounts without code, i.e. `keccak256('')`
421         bytes32 codehash;
422         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
423         // solhint-disable-next-line no-inline-assembly
424         assembly { codehash := extcodehash(account) }
425         return (codehash != 0x0 && codehash != accountHash);
426     }
427 
428     /**
429      * @dev Converts an `address` into `address payable`. Note that this is
430      * simply a type cast: the actual underlying value is not changed.
431      *
432      * _Available since v2.4.0._
433      */
434     function toPayable(address account) internal pure returns (address payable) {
435         return address(uint160(account));
436     }
437 
438     /**
439      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
440      * `recipient`, forwarding all available gas and reverting on errors.
441      *
442      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
443      * of certain opcodes, possibly making contracts go over the 2300 gas limit
444      * imposed by `transfer`, making them unable to receive funds via
445      * `transfer`. {sendValue} removes this limitation.
446      *
447      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
448      *
449      * IMPORTANT: because control is transferred to `recipient`, care must be
450      * taken to not create reentrancy vulnerabilities. Consider using
451      * {ReentrancyGuard} or the
452      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
453      *
454      * _Available since v2.4.0._
455      */
456     function sendValue(address payable recipient, uint256 amount) internal {
457         require(address(this).balance >= amount, "Address: insufficient balance");
458 
459         // solhint-disable-next-line avoid-call-value
460         (bool success, ) = recipient.call.value(amount)("");
461         require(success, "Address: unable to send value, recipient may have reverted");
462     }
463 }
464 
465 
466 
467 /**
468  * @title SafeERC20
469  * @dev Wrappers around ERC20 operations that throw on failure (when the token
470  * contract returns false). Tokens that return no value (and instead revert or
471  * throw on failure) are also supported, non-reverting calls are assumed to be
472  * successful.
473  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
474  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
475  */
476 library SafeERC20 {
477     using SafeMath for uint256;
478     using Address for address;
479 
480     function safeTransfer(IERC20 token, address to, uint256 value) internal {
481         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
482     }
483 
484     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
485         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
486     }
487 
488     function safeApprove(IERC20 token, address spender, uint256 value) internal {
489         // safeApprove should only be called when setting an initial allowance,
490         // or when resetting it to zero. To increase and decrease it, use
491         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
492         // solhint-disable-next-line max-line-length
493         require((value == 0) || (token.allowance(address(this), spender) == 0),
494             "SafeERC20: approve from non-zero to non-zero allowance"
495         );
496         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
497     }
498 
499     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
500         uint256 newAllowance = token.allowance(address(this), spender).add(value);
501         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
502     }
503 
504     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
505         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
506         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
507     }
508 
509     /**
510      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
511      * on the return value: the return value is optional (but if data is returned, it must not be false).
512      * @param token The token targeted by the call.
513      * @param data The call data (encoded using abi.encode or one of its variants).
514      */
515     function callOptionalReturn(IERC20 token, bytes memory data) private {
516         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
517         // we're implementing it ourselves.
518 
519         // A Solidity high level call has three parts:
520         //  1. The target address is checked to verify it contains contract code
521         //  2. The call itself is made, and success asserted
522         //  3. The return value is decoded, which in turn checks the size of the returned data.
523         // solhint-disable-next-line max-line-length
524         require(address(token).isContract(), "SafeERC20: call to non-contract");
525 
526         // solhint-disable-next-line avoid-low-level-calls
527         (bool success, bytes memory returndata) = address(token).call(data);
528         require(success, "SafeERC20: low-level call failed");
529 
530         if (returndata.length > 0) { // Return data is optional
531             // solhint-disable-next-line max-line-length
532             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
533         }
534     }
535 }
536 
537 
538 
539 
540 contract IRewardDistributionRecipient is Ownable {
541     address public rewardDistribution;
542 
543     function notifyRewardAmount(uint256 reward, uint256 _duration) external;
544 
545     modifier onlyRewardDistribution() {
546         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
547         _;
548     }
549 
550     function setRewardDistribution(address _rewardDistribution) external onlyOwner {
551         rewardDistribution = _rewardDistribution;
552     }
553 }
554 
555 
556 contract LPTokenWrapper {
557     using SafeMath for uint256;
558     using SafeERC20 for IERC20;
559 
560     IERC20 public lpToken;
561 
562     uint256 private _totalSupply;
563     mapping(address => uint256) private _balances;
564 
565     constructor(address _lpToken) internal {
566         lpToken = IERC20(_lpToken);
567     }
568 
569     function totalSupply() public view returns (uint256) {
570         return _totalSupply;
571     }
572 
573     function balanceOf(address account) public view returns (uint256) {
574         return _balances[account];
575     }
576 
577     function stake(uint256 amount) public {
578         _totalSupply = _totalSupply.add(amount);
579         _balances[msg.sender] = _balances[msg.sender].add(amount);
580         lpToken.safeTransferFrom(msg.sender, address(this), amount);
581     }
582 
583     function withdraw(uint256 amount) public {
584         _totalSupply = _totalSupply.sub(amount);
585         _balances[msg.sender] = _balances[msg.sender].sub(amount);
586         lpToken.safeTransfer(msg.sender, amount);
587     }
588 }
589 
590 contract WARPool is LPTokenWrapper, IRewardDistributionRecipient {
591     IERC20 public constant war = IERC20(0xf4A81C18816C9B0AB98FAC51B36Dcb63b0E58Fde);
592 
593     string public desc;
594 
595     uint256 public DURATION;
596     uint256 public starttime;
597 
598     uint256 public periodFinish = 0;
599     uint256 public rewardRate = 0;
600     uint256 public lastUpdateTime;
601     uint256 public rewardPerTokenStored;
602     mapping(address => uint256) public userRewardPerTokenPaid;
603     mapping(address => uint256) public rewards;
604 
605     event RewardAdded(uint256 reward);
606     event Staked(address indexed user, uint256 amount);
607     event Withdrawn(address indexed user, uint256 amount);
608     event RewardPaid(address indexed user, uint256 reward);
609 
610     constructor(address _lpToken, string memory _desc, uint256 _starttime) public LPTokenWrapper(_lpToken) {
611         rewardDistribution = msg.sender;
612         desc = _desc;
613         starttime = _starttime;
614     }
615 
616     function setStartTime(uint256 _starttime) external onlyOwner {
617         require(block.timestamp < starttime, "started");
618         starttime = _starttime;
619     }
620 
621     modifier checkStart(){
622         require(block.timestamp >= starttime, "not started");
623         _;
624     }
625 
626     modifier updateReward(address account) {
627         rewardPerTokenStored = rewardPerToken();
628         lastUpdateTime = lastTimeRewardApplicable();
629         if (account != address(0)) {
630             rewards[account] = earned(account);
631             userRewardPerTokenPaid[account] = rewardPerTokenStored;
632         }
633         _;
634     }
635 
636 
637     function lastTimeRewardApplicable() public view returns (uint256) {
638         return Math.min(block.timestamp, periodFinish);
639     }
640 
641     function rewardPerToken() public view returns (uint256) {
642         if (totalSupply() == 0) {
643             return rewardPerTokenStored;
644         }
645         return
646             rewardPerTokenStored.add(
647                 lastTimeRewardApplicable()
648                     .sub(lastUpdateTime)
649                     .mul(rewardRate)
650                     .mul(1e18)
651                     .div(totalSupply())
652             );
653     }
654 
655     function earned(address account) public view returns (uint256) {
656         return
657             balanceOf(account)
658                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
659                 .div(1e18)
660                 .add(rewards[account]);
661     }
662 
663     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
664         require(amount > 0, "Cannot stake 0");
665         super.stake(amount);
666         emit Staked(msg.sender, amount);
667     }
668 
669     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
670         require(amount > 0, "Cannot withdraw 0");
671         super.withdraw(amount);
672         emit Withdrawn(msg.sender, amount);
673     }
674 
675     function exit() external {
676         withdraw(balanceOf(msg.sender));
677         getReward();
678     }
679 
680     function getReward() public updateReward(msg.sender) checkStart {
681         uint256 reward = earned(msg.sender);
682         if (reward > 0) {
683             rewards[msg.sender] = 0;
684             war.safeTransfer(msg.sender, reward);
685             emit RewardPaid(msg.sender, reward);
686         }
687     }
688 
689     function notifyRewardAmount(uint256 _reward, uint256 _duration) external onlyRewardDistribution updateReward(address(0)) {
690         require(_duration != 0, "Duration must not be 0");
691         require(_reward != 0, "Reward must not be 0");
692 
693         war.safeTransferFrom(msg.sender, address(this), _reward);
694         DURATION = _duration;
695         if (block.timestamp > starttime) {
696             if (block.timestamp >= periodFinish) {
697                 rewardRate = _reward.div(_duration);
698             } else {
699                 uint256 remaining = periodFinish.sub(block.timestamp);
700                 uint256 leftover = remaining.mul(rewardRate);
701                 rewardRate = _reward.add(leftover).div(_duration);
702             }
703             lastUpdateTime = block.timestamp;
704             periodFinish = block.timestamp.add(_duration);
705             emit RewardAdded(_reward);
706         } else {
707             rewardRate = _reward.div(_duration);
708             lastUpdateTime = starttime;
709             periodFinish = starttime.add(_duration);
710             emit RewardAdded(_reward);
711         }
712     }
713 }