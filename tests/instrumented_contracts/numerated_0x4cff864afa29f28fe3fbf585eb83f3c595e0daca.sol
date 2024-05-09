1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: DONDIRewards.sol
9 *
10 * Docs: https://docs.synthetix.io/
11 *
12 *
13 * MIT License
14 * ===========
15 *
16 * Copyright (c) 2020 Synthetix
17 *
18 * Permission is hereby granted, free of charge, to any person obtaining a copy
19 * of this software and associated documentation files (the "Software"), to deal
20 * in the Software without restriction, including without limitation the rights
21 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
22 * copies of the Software, and to permit persons to whom the Software is
23 * furnished to do so, subject to the following conditions:
24 *
25 * The above copyright notice and this permission notice shall be included in all
26 * copies or substantial portions of the Software.
27 *
28 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
29 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
30 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
31 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
32 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
33 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
34 */
35 
36 // File: @openzeppelin/contracts/math/Math.sol
37 
38 pragma solidity ^0.5.0;
39 
40 /**
41  * @dev Standard math utilities missing in the Solidity language.
42  */
43 library Math {
44     /**
45      * @dev Returns the largest of two numbers.
46      */
47     function max(uint256 a, uint256 b) internal pure returns (uint256) {
48         return a >= b ? a : b;
49     }
50 
51     /**
52      * @dev Returns the smallest of two numbers.
53      */
54     function min(uint256 a, uint256 b) internal pure returns (uint256) {
55         return a < b ? a : b;
56     }
57 
58     /**
59      * @dev Returns the average of two numbers. The result is rounded towards
60      * zero.
61      */
62     function average(uint256 a, uint256 b) internal pure returns (uint256) {
63         // (a + b) / 2 can overflow, so we distribute
64         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
65     }
66 }
67 
68 // File: @openzeppelin/contracts/math/SafeMath.sol
69 
70 /**
71  * @dev Wrappers over Solidity's arithmetic operations with added overflow
72  * checks.
73  *
74  * Arithmetic operations in Solidity wrap on overflow. This can easily result
75  * in bugs, because programmers usually assume that an overflow raises an
76  * error, which is the standard behavior in high level programming languages.
77  * `SafeMath` restores this intuition by reverting the transaction when an
78  * operation overflows.
79  *
80  * Using this library instead of the unchecked operations eliminates an entire
81  * class of bugs, so it's recommended to use it always.
82  */
83 library SafeMath {
84     /**
85      * @dev Returns the addition of two unsigned integers, reverting on
86      * overflow.
87      *
88      * Counterpart to Solidity's `+` operator.
89      *
90      * Requirements:
91      * - Addition cannot overflow.
92      */
93     function add(uint256 a, uint256 b) internal pure returns (uint256) {
94         uint256 c = a + b;
95         require(c >= a, "SafeMath: addition overflow");
96 
97         return c;
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return sub(a, b, "SafeMath: subtraction overflow");
111     }
112 
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      * - Subtraction cannot overflow.
121      *
122      * _Available since v2.4.0._
123      */
124     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
125         require(b <= a, errorMessage);
126         uint256 c = a - b;
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the multiplication of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `*` operator.
136      *
137      * Requirements:
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
144         if (a == 0) {
145             return 0;
146         }
147 
148         uint256 c = a * b;
149         require(c / a == b, "SafeMath: multiplication overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the integer division of two unsigned integers. Reverts on
156      * division by zero. The result is rounded towards zero.
157      *
158      * Counterpart to Solidity's `/` operator. Note: this function uses a
159      * `revert` opcode (which leaves remaining gas untouched) while Solidity
160      * uses an invalid opcode to revert (consuming all remaining gas).
161      *
162      * Requirements:
163      * - The divisor cannot be zero.
164      */
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         return div(a, b, "SafeMath: division by zero");
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      * - The divisor cannot be zero.
179      *
180      * _Available since v2.4.0._
181      */
182     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
183         // Solidity only automatically asserts when dividing by 0
184         require(b > 0, errorMessage);
185         uint256 c = a / b;
186         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
193      * Reverts when dividing by zero.
194      *
195      * Counterpart to Solidity's `%` operator. This function uses a `revert`
196      * opcode (which leaves remaining gas untouched) while Solidity uses an
197      * invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      * - The divisor cannot be zero.
201      */
202     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
203         return mod(a, b, "SafeMath: modulo by zero");
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts with custom message when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      * - The divisor cannot be zero.
216      *
217      * _Available since v2.4.0._
218      */
219     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b != 0, errorMessage);
221         return a % b;
222     }
223 }
224 
225 // File: @openzeppelin/contracts/GSN/Context.sol
226 
227 /*
228  * @dev Provides information about the current execution context, including the
229  * sender of the transaction and its data. While these are generally available
230  * via msg.sender and msg.data, they should not be accessed in such a direct
231  * manner, since when dealing with GSN meta-transactions the account sending and
232  * paying for execution may not be the actual sender (as far as an application
233  * is concerned).
234  *
235  * This contract is only required for intermediate, library-like contracts.
236  */
237 contract Context {
238     // Empty internal constructor, to prevent people from mistakenly deploying
239     // an instance of this contract, which should be used via inheritance.
240     constructor () internal { }
241     // solhint-disable-previous-line no-empty-blocks
242 
243     function _msgSender() internal view returns (address payable) {
244         return msg.sender;
245     }
246 
247     function _msgData() internal view returns (bytes memory) {
248         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
249         return msg.data;
250     }
251 }
252 
253 // File: @openzeppelin/contracts/ownership/Ownable.sol
254 
255 /**
256  * @dev Contract module which provides a basic access control mechanism, where
257  * there is an account (an owner) that can be granted exclusive access to
258  * specific functions.
259  *
260  * This module is used through inheritance. It will make available the modifier
261  * `onlyOwner`, which can be applied to your functions to restrict their use to
262  * the owner.
263  */
264 contract Ownable is Context {
265     address private _owner;
266 
267     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
268 
269     /**
270      * @dev Initializes the contract setting the deployer as the initial owner.
271      */
272     constructor () internal {
273         _owner = _msgSender();
274         emit OwnershipTransferred(address(0), _owner);
275     }
276 
277     /**
278      * @dev Returns the address of the current owner.
279      */
280     function owner() public view returns (address) {
281         return _owner;
282     }
283 
284     /**
285      * @dev Throws if called by any account other than the owner.
286      */
287     modifier onlyOwner() {
288         require(isOwner(), "Ownable: caller is not the owner");
289         _;
290     }
291 
292     /**
293      * @dev Returns true if the caller is the current owner.
294      */
295     function isOwner() public view returns (bool) {
296         return _msgSender() == _owner;
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public onlyOwner {
307         emit OwnershipTransferred(_owner, address(0));
308         _owner = address(0);
309     }
310 
311     /**
312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
313      * Can only be called by the current owner.
314      */
315     function transferOwnership(address newOwner) public onlyOwner {
316         _transferOwnership(newOwner);
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      */
322     function _transferOwnership(address newOwner) internal {
323         require(newOwner != address(0), "Ownable: new owner is the zero address");
324         emit OwnershipTransferred(_owner, newOwner);
325         _owner = newOwner;
326     }
327 }
328 
329 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
330 
331 /**
332  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
333  * the optional functions; to access them see {ERC20Detailed}.
334  */
335 interface IERC20 {
336     /**
337      * @dev Returns the amount of tokens in existence.
338      */
339     function totalSupply() external view returns (uint256);
340 
341     /**
342      * @dev Returns the amount of tokens owned by `account`.
343      */
344     function balanceOf(address account) external view returns (uint256);
345 
346     /**
347      * @dev Moves `amount` tokens from the caller's account to `recipient`.
348      *
349      * Returns a boolean value indicating whether the operation succeeded.
350      *
351      * Emits a {Transfer} event.
352      */
353     function transfer(address recipient, uint256 amount) external returns (bool);
354     function mint(address account, uint amount) external;
355     /**
356      * @dev Returns the remaining number of tokens that `spender` will be
357      * allowed to spend on behalf of `owner` through {transferFrom}. This is
358      * zero by default.
359      *
360      * This value changes when {approve} or {transferFrom} are called.
361      */
362     function allowance(address owner, address spender) external view returns (uint256);
363 
364     /**
365      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
366      *
367      * Returns a boolean value indicating whether the operation succeeded.
368      *
369      * IMPORTANT: Beware that changing an allowance with this method brings the risk
370      * that someone may use both the old and the new allowance by unfortunate
371      * transaction ordering. One possible solution to mitigate this race
372      * condition is to first reduce the spender's allowance to 0 and set the
373      * desired value afterwards:
374      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
375      *
376      * Emits an {Approval} event.
377      */
378     function approve(address spender, uint256 amount) external returns (bool);
379 
380     /**
381      * @dev Moves `amount` tokens from `sender` to `recipient` using the
382      * allowance mechanism. `amount` is then deducted from the caller's
383      * allowance.
384      *
385      * Returns a boolean value indicating whether the operation succeeded.
386      *
387      * Emits a {Transfer} event.
388      */
389     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
390 
391     /**
392      * @dev Emitted when `value` tokens are moved from one account (`from`) to
393      * another (`to`).
394      *
395      * Note that `value` may be zero.
396      */
397     event Transfer(address indexed from, address indexed to, uint256 value);
398 
399     /**
400      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
401      * a call to {approve}. `value` is the new allowance.
402      */
403     event Approval(address indexed owner, address indexed spender, uint256 value);
404 }
405 
406 // File: @openzeppelin/contracts/utils/Address.sol
407 
408 /**
409  * @dev Collection of functions related to the address type
410  */
411 library Address {
412     /**
413      * @dev Returns true if `account` is a contract.
414      *
415      * This test is non-exhaustive, and there may be false-negatives: during the
416      * execution of a contract's constructor, its address will be reported as
417      * not containing a contract.
418      *
419      * IMPORTANT: It is unsafe to assume that an address for which this
420      * function returns false is an externally-owned account (EOA) and not a
421      * contract.
422      */
423     function isContract(address account) internal view returns (bool) {
424         // This method relies in extcodesize, which returns 0 for contracts in
425         // construction, since the code is only stored at the end of the
426         // constructor execution.
427 
428         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
429         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
430         // for accounts without code, i.e. `keccak256('')`
431         bytes32 codehash;
432         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
433         // solhint-disable-next-line no-inline-assembly
434         assembly { codehash := extcodehash(account) }
435         return (codehash != 0x0 && codehash != accountHash);
436     }
437 
438     /**
439      * @dev Converts an `address` into `address payable`. Note that this is
440      * simply a type cast: the actual underlying value is not changed.
441      *
442      * _Available since v2.4.0._
443      */
444     function toPayable(address account) internal pure returns (address payable) {
445         return address(uint160(account));
446     }
447 
448     /**
449      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
450      * `recipient`, forwarding all available gas and reverting on errors.
451      *
452      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
453      * of certain opcodes, possibly making contracts go over the 2300 gas limit
454      * imposed by `transfer`, making them unable to receive funds via
455      * `transfer`. {sendValue} removes this limitation.
456      *
457      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
458      *
459      * IMPORTANT: because control is transferred to `recipient`, care must be
460      * taken to not create reentrancy vulnerabilities. Consider using
461      * {ReentrancyGuard} or the
462      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
463      *
464      * _Available since v2.4.0._
465      */
466     function sendValue(address payable recipient, uint256 amount) internal {
467         require(address(this).balance >= amount, "Address: insufficient balance");
468 
469         // solhint-disable-next-line avoid-call-value
470         (bool success, ) = recipient.call.value(amount)("");
471         require(success, "Address: unable to send value, recipient may have reverted");
472     }
473 }
474 
475 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
476 
477 /**
478  * @title SafeERC20
479  * @dev Wrappers around ERC20 operations that throw on failure (when the token
480  * contract returns false). Tokens that return no value (and instead revert or
481  * throw on failure) are also supported, non-reverting calls are assumed to be
482  * successful.
483  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
484  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
485  */
486 library SafeERC20 {
487     using SafeMath for uint256;
488     using Address for address;
489 
490     function safeTransfer(IERC20 token, address to, uint256 value) internal {
491         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
492     }
493 
494     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
495         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
496     }
497 
498     function safeApprove(IERC20 token, address spender, uint256 value) internal {
499         // safeApprove should only be called when setting an initial allowance,
500         // or when resetting it to zero. To increase and decrease it, use
501         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
502         // solhint-disable-next-line max-line-length
503         require((value == 0) || (token.allowance(address(this), spender) == 0),
504             "SafeERC20: approve from non-zero to non-zero allowance"
505         );
506         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
507     }
508 
509     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
510         uint256 newAllowance = token.allowance(address(this), spender).add(value);
511         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
512     }
513 
514     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
515         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
516         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
517     }
518 
519     /**
520      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
521      * on the return value: the return value is optional (but if data is returned, it must not be false).
522      * @param token The token targeted by the call.
523      * @param data The call data (encoded using abi.encode or one of its variants).
524      */
525     function callOptionalReturn(IERC20 token, bytes memory data) private {
526         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
527         // we're implementing it ourselves.
528 
529         // A Solidity high level call has three parts:
530         //  1. The target address is checked to verify it contains contract code
531         //  2. The call itself is made, and success asserted
532         //  3. The return value is decoded, which in turn checks the size of the returned data.
533         // solhint-disable-next-line max-line-length
534         require(address(token).isContract(), "SafeERC20: call to non-contract");
535 
536         // solhint-disable-next-line avoid-low-level-calls
537         (bool success, bytes memory returndata) = address(token).call(data);
538         require(success, "SafeERC20: low-level call failed");
539 
540         if (returndata.length > 0) { // Return data is optional
541             // solhint-disable-next-line max-line-length
542             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
543         }
544     }
545 }
546 
547 // File: contracts/IRewardDistributionRecipient.sol
548 
549 contract IRewardDistributionRecipient is Ownable {
550     address public rewardDistribution;
551 
552     function notifyRewardAmount(uint256 reward) external;
553 
554     modifier onlyRewardDistribution() {
555         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
556         _;
557     }
558 
559     function setRewardDistribution(address _rewardDistribution)
560         external
561         onlyOwner
562     {
563         rewardDistribution = _rewardDistribution;
564     }
565 }
566 
567 // File: contracts/CurveRewards.sol
568 
569 interface DONDI {
570     function dondisScalingFactor() external returns (uint256);
571     function mint(address to, uint256 amount) external;
572 }
573 
574 interface DONDIAirdrop {
575     function airdrop(uint256 value) external;
576     function airdropAll() external;
577     function getRemainAirdrop(address pool) external view returns (uint256);
578 }
579 
580 contract LPTokenWrapper {
581     using SafeMath for uint256;
582     using SafeERC20 for IERC20;
583 
584     IERC20 public uni_lp = IERC20(0x8DB4E6a2FC02B331d97db9702a9dDA4D6F4ACF6E);    // need to update
585 
586     uint256 private _totalSupply;
587     mapping(address => uint256) private _balances;
588 
589     function totalSupply() public view returns (uint256) {
590         return _totalSupply;
591     }
592 
593     function balanceOf(address account) public view returns (uint256) {
594         return _balances[account];
595     }
596 
597     function stake(uint256 amount) public {
598         _totalSupply = _totalSupply.add(amount);
599         _balances[msg.sender] = _balances[msg.sender].add(amount);
600         uni_lp.safeTransferFrom(msg.sender, address(this), amount);
601     }
602 
603     function withdraw(uint256 amount) public {
604         _totalSupply = _totalSupply.sub(amount);
605         _balances[msg.sender] = _balances[msg.sender].sub(amount);
606         uni_lp.safeTransfer(msg.sender, amount);
607     }
608 }
609 
610 contract DONDIDONDIETHPool is LPTokenWrapper, IRewardDistributionRecipient {
611     // new
612     struct MyAction {	
613         mapping(uint32 => uint256) amount;	
614         mapping(uint32 => uint256) time;	
615         uint32 length;	
616     }
617 
618     IERC20 public dondi = IERC20(0x45Ed25A237B6AB95cE69aF7555CF8D7A2FfEE67c);       // need to update address
619     DONDIAirdrop public airdrop = DONDIAirdrop(0xbd1A31ac12Cd16bacE58519c91a4562069d5A6A6);        // need to update address
620 
621     uint256 public constant DURATION = 5184000; // 60 days	
622     uint256 public initreward = 5 * 10**6 * 10**18; // 5M
623 
624     uint256 public starttime = 1604113200; // 2020-10-31 03:00:00 AM (UTC UTC +00:00)
625     uint256 public periodFinish = 0;
626     uint256 public rewardRate = 0;
627     uint256 public lastUpdateTime;
628     uint256 public rewardPerTokenStored;
629 
630     // new
631     mapping(address => MyAction) private stakes;	
632     mapping(address => MyAction) private withdraws;	
633     mapping(address => MyAction) private boosts;
634 
635     mapping(address => uint256) public boostStarttime;
636     mapping(address => uint8) public currentBoost;
637     mapping(address => uint8) public x2Count;
638     mapping(address => uint8) public x4Count;
639     mapping(address => uint8) public x8Count;
640     mapping(address => uint8) public x10Count;
641 
642     mapping(address => uint256) public userRewardPerTokenPaid;
643     mapping(address => uint256) public rewards;
644 
645     event RewardAdded(uint256 reward);
646     event Staked(address indexed user, uint256 amount);
647     event Withdrawn(address indexed user, uint256 amount);
648     event RewardPaid(address indexed user, uint256 reward);
649 
650     modifier checkBoostStatus() {
651         require(block.timestamp >= boostStarttime[msg.sender] + 1 hours, "already boost");
652         _;
653     }
654 
655     modifier checkStart() {
656         require(block.timestamp >= starttime,"not start");
657         _;
658     }
659 
660     modifier checkhalve() {	
661         if (block.timestamp >= periodFinish) {	
662             initreward = initreward.mul(50).div(100);	
663             uint256 scalingFactor = DONDI(address(dondi)).dondisScalingFactor();	
664             uint256 newRewards = initreward.mul(scalingFactor).div(10**18);	
665             dondi.mint(address(this), newRewards);	
666             rewardRate = initreward.div(DURATION);	
667             periodFinish = block.timestamp.add(DURATION);	
668             emit RewardAdded(initreward);	
669         }	
670         _;	
671     }
672 
673     modifier updateReward(address account) {
674         rewardPerTokenStored = rewardPerToken();
675         lastUpdateTime = lastTimeRewardApplicable();
676         if (account != address(0)) {
677             rewards[account] = earned(account);
678             userRewardPerTokenPaid[account] = rewardPerTokenStored;
679         }
680         _;
681     }
682 
683     function lastTimeRewardApplicable() public view returns (uint256) {
684         return Math.min(block.timestamp, periodFinish);
685     }
686 
687     function rewardPerToken() public view returns (uint256) {
688         if (totalSupply() == 0) {
689             return rewardPerTokenStored;
690         }
691         return
692             rewardPerTokenStored.add(
693                 lastTimeRewardApplicable()
694                     .sub(lastUpdateTime)
695                     .mul(rewardRate)
696                     .mul(1e18)
697                     .div(totalSupply())
698             );
699     }
700 
701     function earned(address account) public view returns (uint256) {
702         return
703             balanceOf(account)
704                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
705                 .div(1e18)
706                 .add(rewards[account]);
707     }
708 
709     // stake visibility is public as overriding LPTokenWrapper's stake() function
710     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart {
711         require(amount > 0, "Cannot stake 0");
712         super.stake(amount);
713 
714         // new
715         stakes[msg.sender].amount[stakes[msg.sender].length] = amount;	
716         stakes[msg.sender].time[stakes[msg.sender].length] = now;	
717         stakes[msg.sender].length++;
718 
719         emit Staked(msg.sender, amount);
720     }
721 
722     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
723         require(amount > 0, "Cannot withdraw 0");
724         super.withdraw(amount);
725 
726         // new
727         withdraws[msg.sender].amount[withdraws[msg.sender].length] = amount;	
728         withdraws[msg.sender].time[withdraws[msg.sender].length] = now;	
729         withdraws[msg.sender].length++;
730 
731         emit Withdrawn(msg.sender, amount);
732     }
733 
734     function exit() external {
735         withdraw(balanceOf(msg.sender));
736         getReward();
737     }
738 
739     // new
740     function getBoostReward(uint256 trueReward) private view returns(uint256){	
741         uint256 additionTime = 0;	
742         uint256 startTime = stakes[msg.sender].time[0];	
743         uint256 boostReward = 0;	
744         uint256 fullAmount = 0;	
745         uint32 i;	
746         uint32 j;	
747         for (i = 0; i < stakes[msg.sender].length; i++) {	
748             additionTime = 0;	
749             uint256 stakeTime = stakes[msg.sender].time[i];	
750             for (j = 0; j < boosts[msg.sender].length; j++) {	
751                 uint256 boostTime = boosts[msg.sender].time[j];	
752                 uint256 boostAmount = boosts[msg.sender].amount[j];	
753                 if (boostTime < stakeTime && boostTime + 1 hours < stakeTime) {	
754                     if (boostTime.add(1 hours) > now) {	
755                         additionTime = additionTime.add(uint256(uint256(now).sub(stakeTime)).mul(boostAmount - 1));	
756                     } else {	
757                         additionTime = additionTime.add(uint256(boostTime.add(1 hours).sub(stakeTime)).mul(boostAmount - 1));	
758                     }	
759                 } else if (boostTime > stakeTime) {	
760                     if (boostTime.add(1 hours) > now) {	
761                         additionTime = additionTime.add(uint256(uint256(now).sub(boostTime)).mul(boostAmount - 1));	
762                     } else {	
763                         additionTime = additionTime.add(uint256(1 hours).mul(boostAmount - 1));	
764                     }	
765                 }	
766             }	
767             if (balanceOf(msg.sender) > 0) {	
768                 fullAmount = balanceOf(msg.sender);	
769             } else {	
770                 fullAmount = withdraws[msg.sender].amount[withdraws[msg.sender].length - 1];	
771             }	
772             uint256 addReward = trueReward.mul(stakes[msg.sender].amount[i]).div(fullAmount);	
773             addReward = addReward.mul(additionTime).div(uint256(now).sub(startTime));	
774             boostReward = boostReward.add(addReward);	
775         }	
776         if (withdraws[msg.sender].length > 0) {	
777             for (i = 0; i < withdraws[msg.sender].length; i++) {	
778                 additionTime = 0;	
779                 uint256 withdrawTime = withdraws[msg.sender].time[i];	
780                 for (j = 0; j < boosts[msg.sender].length; j++) {	
781                     uint256 boostTime = boosts[msg.sender].time[j];	
782                     uint256 boostAmount = boosts[msg.sender].amount[j];	
783                     if (boostTime < withdrawTime && boostTime + 1 hours < withdrawTime) {	
784                         if (boostTime.add(1 hours) > now) {	
785                             additionTime = additionTime.add(uint256(uint256(now).sub(withdrawTime)).mul(boostAmount - 1));	
786                         } else {	
787                             additionTime = additionTime.add(uint256(boostTime.add(1 hours).sub(withdrawTime)).mul(boostAmount - 1));	
788                         }	
789                     } else if (boostTime > withdrawTime) {	
790                         if (boostTime.add(1 hours) > now) {	
791                             additionTime = additionTime.add(uint256(uint256(now).sub(boostTime)).mul(boostAmount - 1));	
792                         } else {	
793                             additionTime = additionTime.add(uint256(1 hours).mul(boostAmount - 1));	
794                         }	
795                     }	
796                 }	
797                 if (balanceOf(msg.sender) > 0) {	
798                     fullAmount = balanceOf(msg.sender);	
799                 } else {	
800                     fullAmount = withdraws[msg.sender].amount[withdraws[msg.sender].length - 1];	
801                 }	
802                 uint256 subReward = trueReward.mul(withdraws[msg.sender].amount[i]).div(fullAmount);	
803                 subReward = subReward.mul(additionTime).div(uint256(now).sub(startTime));	
804                 boostReward = boostReward.sub(subReward);	
805             }	
806         }	
807         return boostReward;	
808     }
809 
810     // new
811     function getReward() public updateReward(msg.sender) checkhalve checkStart {	
812         uint256 reward = earned(msg.sender);	
813         if (reward > 0) {	
814             rewards[msg.sender] = 0;	
815             uint256 scalingFactor = DONDI(address(dondi)).dondisScalingFactor();	
816             uint256 trueReward = reward.mul(scalingFactor).div(10**18);	
817             uint256 remainAirdrop = airdrop.getRemainAirdrop(address(this));	
818             if (block.timestamp < boostStarttime[msg.sender] + 1 hours && remainAirdrop > 0) {	
819                 	
820                 uint256 boostReward = getBoostReward(trueReward);	
821                 if (boostReward < remainAirdrop) {	
822                     airdrop.airdrop(boostReward);	
823                     dondi.safeTransfer(msg.sender, trueReward.add(boostReward));	
824                     emit RewardPaid(msg.sender, trueReward.add(boostReward));	
825                 }	
826                 else {	
827                     airdrop.airdropAll();	
828                     dondi.safeTransfer(msg.sender, trueReward.add(remainAirdrop));	
829                     emit RewardPaid(msg.sender, trueReward.add(remainAirdrop));	
830                 }	
831             }	
832             else {	
833                 dondi.safeTransfer(msg.sender, trueReward);	
834                 emit RewardPaid(msg.sender, trueReward);	
835             }	
836             stakes[msg.sender].amount[0] = balanceOf(msg.sender);	
837             stakes[msg.sender].time[0] = now;	
838             stakes[msg.sender].length = 1;	
839             withdraws[msg.sender].length = 0;	
840         }	
841     }
842 
843     function notifyRewardAmount(uint256 reward)	
844         external	
845         onlyRewardDistribution	
846         updateReward(address(0))	
847     {	
848         if (block.timestamp > starttime) {	
849           if (block.timestamp >= periodFinish) {	
850               rewardRate = reward.div(DURATION);	
851           } else {	
852               uint256 remaining = periodFinish.sub(block.timestamp);	
853               uint256 leftover = remaining.mul(rewardRate);	
854               rewardRate = reward.add(leftover).div(DURATION);	
855           }	
856           lastUpdateTime = block.timestamp;	
857           periodFinish = block.timestamp.add(DURATION);	
858           emit RewardAdded(reward);	
859         } else {	
860           require(dondi.balanceOf(address(this)) == 0, "already initialized");	
861           dondi.mint(address(this), initreward);	
862           rewardRate = initreward.div(DURATION);	
863           lastUpdateTime = starttime;	
864           periodFinish = starttime.add(DURATION);	
865           emit RewardAdded(reward);	
866         }	
867     }
868 
869     function boostx2() external payable checkBoostStatus checkStart {
870         address payable fundaddress = 0x1912780CA1056fB9B5f3B4C241881f69Ed225861;
871         uint256 boostCost = uint256(15).mul(uint256(2) ** x2Count[msg.sender]).mul(10 ** 18).div(1000);
872         require(msg.value == boostCost, "Wrong cost");
873 
874         currentBoost[msg.sender] = 2;
875         x2Count[msg.sender] = x2Count[msg.sender] + 1;
876         boostStarttime[msg.sender] = block.timestamp;
877 
878         // new
879         boosts[msg.sender].amount[boosts[msg.sender].length] = 2;	
880         boosts[msg.sender].time[boosts[msg.sender].length] = now;	
881         boosts[msg.sender].length++;
882 
883         if (!fundaddress.send(boostCost)) {
884             return fundaddress.transfer(address(this).balance);
885         }
886     }
887 
888     function boostx4() external payable checkBoostStatus checkStart {
889         address payable fundaddress = 0x1912780CA1056fB9B5f3B4C241881f69Ed225861;
890         uint256 boostCost = uint256(15).mul(uint256(2) ** x4Count[msg.sender]).mul(10 ** 18).div(1000);
891         require(msg.value == boostCost, "Wrong cost");
892 
893         currentBoost[msg.sender] = 4;
894         x4Count[msg.sender] = x4Count[msg.sender] + 1;
895         boostStarttime[msg.sender] = block.timestamp;
896 
897         // new
898         boosts[msg.sender].amount[boosts[msg.sender].length] = 4;	
899         boosts[msg.sender].time[boosts[msg.sender].length] = now;	
900         boosts[msg.sender].length++;
901 
902         if (!fundaddress.send(boostCost)) {
903             return fundaddress.transfer(address(this).balance);
904         }
905     }
906     
907     function boostx8() external payable checkBoostStatus checkStart {
908         address payable fundaddress = 0x1912780CA1056fB9B5f3B4C241881f69Ed225861;
909         uint256 boostCost = uint256(15).mul(uint256(2) ** x8Count[msg.sender]).mul(10 ** 18).div(1000);
910         require(msg.value == boostCost, "Wrong cost");
911 
912         currentBoost[msg.sender] = 8;
913         x8Count[msg.sender] = x8Count[msg.sender] + 1;
914         boostStarttime[msg.sender] = block.timestamp;
915 
916         // new
917         boosts[msg.sender].amount[boosts[msg.sender].length] = 8;	
918         boosts[msg.sender].time[boosts[msg.sender].length] = now;	
919         boosts[msg.sender].length++;
920 
921         if (!fundaddress.send(boostCost)) {
922             return fundaddress.transfer(address(this).balance);
923         }
924     }
925     
926     function boostx10() external payable checkBoostStatus checkStart {
927         address payable fundaddress = 0x1912780CA1056fB9B5f3B4C241881f69Ed225861;
928         uint256 boostCost = uint256(15).mul(uint256(2) ** x10Count[msg.sender]).mul(10 ** 18).div(1000);
929         require(msg.value == boostCost, "Wrong cost");
930 
931         currentBoost[msg.sender] = 10;
932         x10Count[msg.sender] = x10Count[msg.sender] + 1;
933         boostStarttime[msg.sender] = block.timestamp;
934 
935         // new
936         boosts[msg.sender].amount[boosts[msg.sender].length] = 10;	
937         boosts[msg.sender].time[boosts[msg.sender].length] = now;	
938         boosts[msg.sender].length++;
939 
940         if (!fundaddress.send(boostCost)) {
941             return fundaddress.transfer(address(this).balance);
942         }
943     }
944 }