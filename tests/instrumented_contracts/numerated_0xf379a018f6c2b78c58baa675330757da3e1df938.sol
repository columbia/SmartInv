1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-25
3 */
4 
5 /*
6 
7                                                                                                       
8       _____         ____        _____        ______  _______    ____  _____   ______         _____    
9  ____|\    \   ____|\   \   ___|\    \      |      \/       \  |    ||\    \ |\     \    ___|\    \   
10 |    | \    \ /    /\    \ |    |\    \    /          /\     \ |    | \\    \| \     \  /    /\    \  
11 |    |______/|    |  |    ||    | |    |  /     /\   / /\     ||    |  \|    \  \     ||    |  |____| 
12 |    |----'\ |    |__|    ||    |/____/  /     /\ \_/ / /    /||    |   |     \  |    ||    |    ____ 
13 |    |_____/ |    .--.    ||    |\    \ |     |  \|_|/ /    / ||    |   |      \ |    ||    |   |    |
14 |    |       |    |  |    ||    | |    ||     |       |    |  ||    |   |    |\ \|    ||    |   |_,  |
15 |____|       |____|  |____||____| |____||\____\       |____|  /|____|   |____||\_____/||\ ___\___/  /|
16 |    |       |    |  |    ||    | |    || |    |      |    | / |    |   |    |/ \|   ||| |   /____ / |
17 |____|       |____|  |____||____| |____| \|____|      |____|/  |____|   |____|   |___|/ \|___|    | / 
18   )/           \(      )/    \(     )/      \(          )/       \(       \(       )/     \( |____|/  
19   '             '      '      '     '        '          '         '        '       '       '   )/     
20                                                                                                '      
21 
22    ____            __   __        __   _
23   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
24  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
25 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
26      /___/
27 
28 * Synthetix: VAMPRewards.sol
29 *
30 * Docs: https://docs.synthetix.io/
31 *
32 *
33 * MIT License
34 * ===========
35 *
36 * Copyright (c) 2020 Synthetix
37 *
38 * Permission is hereby granted, free of charge, to any person obtaining a copy
39 * of this software and associated documentation files (the "Software"), to deal
40 * in the Software without restriction, including without limitation the rights
41 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
42 * copies of the Software, and to permit persons to whom the Software is
43 * furnished to do so, subject to the following conditions:
44 *
45 * The above copyright notice and this permission notice shall be included in all
46 * copies or substantial portions of the Software.
47 *
48 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
49 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
50 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
51 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
52 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
53 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
54 */
55 pragma solidity ^0.5.17;
56 
57 
58 /**
59  * @dev Standard math utilities missing in the Solidity language.
60  */
61 library Math {
62     /**
63      * @dev Returns the largest of two numbers.
64      */
65     function max(uint256 a, uint256 b) internal pure returns (uint256) {
66         return a >= b ? a : b;
67     }
68 
69     /**
70      * @dev Returns the smallest of two numbers.
71      */
72     function min(uint256 a, uint256 b) internal pure returns (uint256) {
73         return a < b ? a : b;
74     }
75 
76     /**
77      * @dev Returns the average of two numbers. The result is rounded towards
78      * zero.
79      */
80     function average(uint256 a, uint256 b) internal pure returns (uint256) {
81         // (a + b) / 2 can overflow, so we distribute
82         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
83     }
84 }
85 
86 // File: @openzeppelin/contracts/math/SafeMath.sol
87 
88 
89 /**
90  * @dev Wrappers over Solidity's arithmetic operations with added overflow
91  * checks.
92  *
93  * Arithmetic operations in Solidity wrap on overflow. This can easily result
94  * in bugs, because programmers usually assume that an overflow raises an
95  * error, which is the standard behavior in high level programming languages.
96  * `SafeMath` restores this intuition by reverting the transaction when an
97  * operation overflows.
98  *
99  * Using this library instead of the unchecked operations eliminates an entire
100  * class of bugs, so it's recommended to use it always.
101  */
102 library SafeMath {
103     /**
104      * @dev Returns the addition of two unsigned integers, reverting on
105      * overflow.
106      *
107      * Counterpart to Solidity's `+` operator.
108      *
109      * Requirements:
110      * - Addition cannot overflow.
111      */
112     function add(uint256 a, uint256 b) internal pure returns (uint256) {
113         uint256 c = a + b;
114         require(c >= a, "SafeMath: addition overflow");
115 
116         return c;
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      * - Subtraction cannot overflow.
140      *
141      * _Available since v2.4.0._
142      */
143     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
144         require(b <= a, errorMessage);
145         uint256 c = a - b;
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the multiplication of two unsigned integers, reverting on
152      * overflow.
153      *
154      * Counterpart to Solidity's `*` operator.
155      *
156      * Requirements:
157      * - Multiplication cannot overflow.
158      */
159     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
160         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
161         // benefit is lost if 'b' is also tested.
162         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
163         if (a == 0) {
164             return 0;
165         }
166 
167         uint256 c = a * b;
168         require(c / a == b, "SafeMath: multiplication overflow");
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the integer division of two unsigned integers. Reverts on
175      * division by zero. The result is rounded towards zero.
176      *
177      * Counterpart to Solidity's `/` operator. Note: this function uses a
178      * `revert` opcode (which leaves remaining gas untouched) while Solidity
179      * uses an invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187 
188     /**
189      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
190      * division by zero. The result is rounded towards zero.
191      *
192      * Counterpart to Solidity's `/` operator. Note: this function uses a
193      * `revert` opcode (which leaves remaining gas untouched) while Solidity
194      * uses an invalid opcode to revert (consuming all remaining gas).
195      *
196      * Requirements:
197      * - The divisor cannot be zero.
198      *
199      * _Available since v2.4.0._
200      */
201     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         // Solidity only automatically asserts when dividing by 0
203         require(b > 0, errorMessage);
204         uint256 c = a / b;
205         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      * - The divisor cannot be zero.
220      */
221     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
222         return mod(a, b, "SafeMath: modulo by zero");
223     }
224 
225     /**
226      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
227      * Reverts with custom message when dividing by zero.
228      *
229      * Counterpart to Solidity's `%` operator. This function uses a `revert`
230      * opcode (which leaves remaining gas untouched) while Solidity uses an
231      * invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      * - The divisor cannot be zero.
235      *
236      * _Available since v2.4.0._
237      */
238     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b != 0, errorMessage);
240         return a % b;
241     }
242 }
243 
244 // File: @openzeppelin/contracts/GSN/Context.sol
245 
246 
247 /*
248  * @dev Provides information about the current execution context, including the
249  * sender of the transaction and its data. While these are generally available
250  * via msg.sender and msg.data, they should not be accessed in such a direct
251  * manner, since when dealing with GSN meta-transactions the account sending and
252  * paying for execution may not be the actual sender (as far as an application
253  * is concerned).
254  *
255  * This contract is only required for intermediate, library-like contracts.
256  */
257 contract Context {
258     // Empty internal constructor, to prevent people from mistakenly deploying
259     // an instance of this contract, which should be used via inheritance.
260     constructor () internal { }
261     // solhint-disable-previous-line no-empty-blocks
262 
263     function _msgSender() internal view returns (address payable) {
264         return msg.sender;
265     }
266 
267     function _msgData() internal view returns (bytes memory) {
268         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
269         return msg.data;
270     }
271 }
272 
273 // File: @openzeppelin/contracts/ownership/Ownable.sol
274 
275 
276 
277 /**
278  * @dev Contract module which provides a basic access control mechanism, where
279  * there is an account (an owner) that can be granted exclusive access to
280  * specific functions.
281  *
282  * This module is used through inheritance. It will make available the modifier
283  * `onlyOwner`, which can be applied to your functions to restrict their use to
284  * the owner.
285  */
286 contract Ownable is Context {
287     address private _owner;
288 
289     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
290 
291     /**
292      * @dev Initializes the contract setting the deployer as the initial owner.
293      */
294     constructor () internal {
295         _owner = _msgSender();
296         emit OwnershipTransferred(address(0), _owner);
297     }
298 
299     /**
300      * @dev Returns the address of the current owner.
301      */
302     function owner() public view returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if called by any account other than the owner.
308      */
309     modifier onlyOwner() {
310         require(isOwner(), "Ownable: caller is not the owner");
311         _;
312     }
313 
314     /**
315      * @dev Returns true if the caller is the current owner.
316      */
317     function isOwner() public view returns (bool) {
318         return _msgSender() == _owner;
319     }
320 
321     /**
322      * @dev Leaves the contract without owner. It will not be possible to call
323      * `onlyOwner` functions anymore. Can only be called by the current owner.
324      *
325      * NOTE: Renouncing ownership will leave the contract without an owner,
326      * thereby removing any functionality that is only available to the owner.
327      */
328     function renounceOwnership() public onlyOwner {
329         emit OwnershipTransferred(_owner, address(0));
330         _owner = address(0);
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      * Can only be called by the current owner.
336      */
337     function transferOwnership(address newOwner) public onlyOwner {
338         _transferOwnership(newOwner);
339     }
340 
341     /**
342      * @dev Transfers ownership of the contract to a new account (`newOwner`).
343      */
344     function _transferOwnership(address newOwner) internal {
345         require(newOwner != address(0), "Ownable: new owner is the zero address");
346         emit OwnershipTransferred(_owner, newOwner);
347         _owner = newOwner;
348     }
349 }
350 
351 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
352 
353 pragma solidity ^0.5.0;
354 
355 /**
356  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
357  * the optional functions; to access them see {ERC20Detailed}.
358  */
359 interface IERC20 {
360     /**
361      * @dev Returns the amount of tokens in existence.
362      */
363     function totalSupply() external view returns (uint256);
364 
365     /**
366      * @dev Returns the amount of tokens owned by `account`.
367      */
368     function balanceOf(address account) external view returns (uint256);
369 
370     /**
371      * @dev Moves `amount` tokens from the caller's account to `recipient`.
372      *
373      * Returns a boolean value indicating whether the operation succeeded.
374      *
375      * Emits a {Transfer} event.
376      */
377     function transfer(address recipient, uint256 amount) external returns (bool);
378 
379     /**
380      * @dev Returns the remaining number of tokens that `spender` will be
381      * allowed to spend on behalf of `owner` through {transferFrom}. This is
382      * zero by default.
383      *
384      * This value changes when {approve} or {transferFrom} are called.
385      */
386     function allowance(address owner, address spender) external view returns (uint256);
387 
388     /**
389      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
390      *
391      * Returns a boolean value indicating whether the operation succeeded.
392      *
393      * IMPORTANT: Beware that changing an allowance with this method brings the risk
394      * that someone may use both the old and the new allowance by unfortunate
395      * transaction ordering. One possible solution to mitigate this race
396      * condition is to first reduce the spender's allowance to 0 and set the
397      * desired value afterwards:
398      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
399      *
400      * Emits an {Approval} event.
401      */
402     function approve(address spender, uint256 amount) external returns (bool);
403 
404     /**
405      * @dev Moves `amount` tokens from `sender` to `recipient` using the
406      * allowance mechanism. `amount` is then deducted from the caller's
407      * allowance.
408      *
409      * Returns a boolean value indicating whether the operation succeeded.
410      *
411      * Emits a {Transfer} event.
412      */
413     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
414 
415     /**
416      * @dev Emitted when `value` tokens are moved from one account (`from`) to
417      * another (`to`).
418      *
419      * Note that `value` may be zero.
420      */
421     event Transfer(address indexed from, address indexed to, uint256 value);
422 
423     /**
424      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
425      * a call to {approve}. `value` is the new allowance.
426      */
427     event Approval(address indexed owner, address indexed spender, uint256 value);
428 }
429 
430 // File: @openzeppelin/contracts/utils/Address.sol
431 
432 pragma solidity ^0.5.5;
433 
434 /**
435  * @dev Collection of functions related to the address type
436  */
437 library Address {
438     /**
439      * @dev Returns true if `account` is a contract.
440      *
441      * This test is non-exhaustive, and there may be false-negatives: during the
442      * execution of a contract's constructor, its address will be reported as
443      * not containing a contract.
444      *
445      * IMPORTANT: It is unsafe to assume that an address for which this
446      * function returns false is an externally-owned account (EOA) and not a
447      * contract.
448      */
449     function isContract(address account) internal view returns (bool) {
450         // This method relies in extcodesize, which returns 0 for contracts in
451         // construction, since the code is only stored at the end of the
452         // constructor execution.
453 
454         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
455         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
456         // for accounts without code, i.e. `keccak256('')`
457         bytes32 codehash;
458         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
459         // solhint-disable-next-line no-inline-assembly
460         assembly { codehash := extcodehash(account) }
461         return (codehash != 0x0 && codehash != accountHash);
462     }
463 
464     /**
465      * @dev Converts an `address` into `address payable`. Note that this is
466      * simply a type cast: the actual underlying value is not changed.
467      *
468      * _Available since v2.4.0._
469      */
470     function toPayable(address account) internal pure returns (address payable) {
471         return address(uint160(account));
472     }
473 
474     /**
475      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
476      * `recipient`, forwarding all available gas and reverting on errors.
477      *
478      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
479      * of certain opcodes, possibly making contracts go over the 2300 gas limit
480      * imposed by `transfer`, making them unable to receive funds via
481      * `transfer`. {sendValue} removes this limitation.
482      *
483      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
484      *
485      * IMPORTANT: because control is transferred to `recipient`, care must be
486      * taken to not create reentrancy vulnerabilities. Consider using
487      * {ReentrancyGuard} or the
488      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
489      *
490      * _Available since v2.4.0._
491      */
492     function sendValue(address payable recipient, uint256 amount) internal {
493         require(address(this).balance >= amount, "Address: insufficient balance");
494 
495         // solhint-disable-next-line avoid-call-value
496         (bool success, ) = recipient.call.value(amount)("");
497         require(success, "Address: unable to send value, recipient may have reverted");
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
502 
503 pragma solidity ^0.5.0;
504 
505 
506 
507 
508 /**
509  * @title SafeERC20
510  * @dev Wrappers around ERC20 operations that throw on failure (when the token
511  * contract returns false). Tokens that return no value (and instead revert or
512  * throw on failure) are also supported, non-reverting calls are assumed to be
513  * successful.
514  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
515  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
516  */
517 library SafeERC20 {
518     using SafeMath for uint256;
519     using Address for address;
520 
521     function safeTransfer(IERC20 token, address to, uint256 value) internal {
522         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
523     }
524 
525     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
526         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
527     }
528 
529     function safeApprove(IERC20 token, address spender, uint256 value) internal {
530         // safeApprove should only be called when setting an initial allowance,
531         // or when resetting it to zero. To increase and decrease it, use
532         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
533         // solhint-disable-next-line max-line-length
534         require((value == 0) || (token.allowance(address(this), spender) == 0),
535             "SafeERC20: approve from non-zero to non-zero allowance"
536         );
537         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
538     }
539 
540     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
541         uint256 newAllowance = token.allowance(address(this), spender).add(value);
542         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
543     }
544 
545     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
546         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
547         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
548     }
549 
550     /**
551      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
552      * on the return value: the return value is optional (but if data is returned, it must not be false).
553      * @param token The token targeted by the call.
554      * @param data The call data (encoded using abi.encode or one of its variants).
555      */
556     function callOptionalReturn(IERC20 token, bytes memory data) private {
557         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
558         // we're implementing it ourselves.
559 
560         // A Solidity high level call has three parts:
561         //  1. The target address is checked to verify it contains contract code
562         //  2. The call itself is made, and success asserted
563         //  3. The return value is decoded, which in turn checks the size of the returned data.
564         // solhint-disable-next-line max-line-length
565         require(address(token).isContract(), "SafeERC20: call to non-contract");
566 
567         // solhint-disable-next-line avoid-low-level-calls
568         (bool success, bytes memory returndata) = address(token).call(data);
569         require(success, "SafeERC20: low-level call failed");
570 
571         if (returndata.length > 0) { // Return data is optional
572             // solhint-disable-next-line max-line-length
573             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
574         }
575     }
576 }
577 
578 // File: contracts/IRewardDistributionRecipient.sol
579 
580 pragma solidity ^0.5.0;
581 
582 
583 
584 contract IRewardDistributionRecipient is Ownable {
585     address rewardDistribution;
586 
587     function notifyRewardAmount() external;
588 
589     modifier onlyRewardDistribution() {
590         require(_msgSender() == rewardDistribution, "Caller is not reward distribution");
591         _;
592     }
593 
594     function setRewardDistribution(address _rewardDistribution)
595         external
596         onlyOwner
597     {
598         rewardDistribution = _rewardDistribution;
599     }
600 }
601 
602 // File: contracts/CurveRewards.sol
603 
604 pragma solidity ^0.5.0;
605 
606 
607 
608 
609 
610 
611 pragma solidity ^0.5.17;
612 contract LPTokenWrapper {
613     using SafeMath for uint256;
614     using SafeERC20 for IERC20;
615 
616     IERC20 public uni = IERC20(0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984);
617 
618     uint256 private _totalSupply;
619     mapping(address => uint256) private _balances;
620 
621     function totalSupply() public view returns (uint256) {
622         return _totalSupply;
623     }
624 
625     function balanceOf(address account) public view returns (uint256) {
626         return _balances[account];
627     }
628 
629     function stake(uint256 amount) public {
630         _totalSupply = _totalSupply.add(amount);
631         _balances[msg.sender] = _balances[msg.sender].add(amount);
632         uni.safeTransferFrom(msg.sender, address(this), amount);
633     }
634 
635     function withdraw(uint256 amount) public {
636         _totalSupply = _totalSupply.sub(amount);
637         _balances[msg.sender] = _balances[msg.sender].sub(amount);
638         uni.safeTransfer(msg.sender, amount);
639     }
640 }
641 
642 contract VAMPUNIPOOL is LPTokenWrapper, IRewardDistributionRecipient {
643     IERC20 public vamp = IERC20(0xb2C822a1b923E06Dbd193d2cFc7ad15388EA09DD);
644     uint256 public DURATION = 7 days;
645     uint256 public generation = 3;
646     uint256 public initreward = 93500 ether;
647     uint256 public starttime = 1601308800;
648     uint256 public periodFinish = 0;
649     uint256 public rewardRate = 0;
650     uint256 public lastUpdateTime;
651     uint256 public rewardPerTokenStored;
652     mapping(address => uint256) public userRewardPerTokenPaid;
653     mapping(address => uint256) public rewards;
654 
655     event RewardAdded(uint256 reward);
656     event Staked(address indexed user, uint256 amount);
657     event Withdrawn(address indexed user, uint256 amount);
658     event RewardPaid(address indexed user, uint256 reward);
659 
660     modifier updateReward(address account) {
661         rewardPerTokenStored = rewardPerToken();
662         lastUpdateTime = lastTimeRewardApplicable();
663         if (account != address(0)) {
664             rewards[account] = earned(account);
665             userRewardPerTokenPaid[account] = rewardPerTokenStored;
666         }
667         _;
668     }
669 
670     function lastTimeRewardApplicable() public view returns (uint256) {
671         return Math.min(block.timestamp, periodFinish);
672     }
673 
674     function rewardPerToken() public view returns (uint256) {
675         if (totalSupply() == 0) {
676             return rewardPerTokenStored;
677         }
678         return
679             rewardPerTokenStored.add(
680                 lastTimeRewardApplicable()
681                     .sub(lastUpdateTime)
682                     .mul(rewardRate)
683                     .mul(1e18)
684                     .div(totalSupply())
685             );
686     }
687 
688     function earned(address account) public view returns (uint256) {
689         return
690             balanceOf(account)
691                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
692                 .div(1e18)
693                 .add(rewards[account]);
694     }
695 
696     // stake visibility is public as overriding LPTokenWrapper's stake() function
697     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart{
698         require(amount > 0, "Cannot stake 0");
699         super.stake(amount);
700         emit Staked(msg.sender, amount);
701     }
702 
703     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart{
704         require(amount > 0, "Cannot withdraw 0");
705         super.withdraw(amount);
706         emit Withdrawn(msg.sender, amount);
707     }
708 
709     function exit() external {
710         withdraw(balanceOf(msg.sender));
711         getReward();
712     }
713 
714     function getReward() public updateReward(msg.sender) checkhalve checkStart{
715         uint256 reward = earned(msg.sender);
716         if (reward > 0) {
717             rewards[msg.sender] = 0;
718             vamp.safeTransfer(msg.sender, reward);
719             emit RewardPaid(msg.sender, reward);
720         }
721     }
722 
723      modifier checkhalve() {
724     if (block.timestamp >= periodFinish) {
725         generation = generation.add(1);
726         if (generation == 4) {
727             DURATION = 6 days;
728             initreward = 136000 ether;
729             rewardRate = initreward.div(DURATION);
730             periodFinish = block.timestamp.add(DURATION);
731             emit RewardAdded(initreward);
732         } else if (generation == 5) {
733             DURATION = 5 days;
734             initreward = 178500 ether;
735             rewardRate = initreward.div(DURATION);
736             periodFinish = block.timestamp.add(DURATION);
737             emit RewardAdded(initreward);
738         } else if (generation == 6) {
739             DURATION = 3 days;
740             initreward = 229500 ether;
741             rewardRate = initreward.div(DURATION);
742             periodFinish = block.timestamp.add(DURATION);
743             emit RewardAdded(initreward);
744         } else if (generation > 6) {
745             uint256 balance = vamp.balanceOf(address(this));
746             require(balance > 0, "Contract is empty, all rewards distributed");
747             vamp.safeTransfer(owner(), balance); //transfer any leftover rewards to the owner to be burned or airdropped.
748         }
749 
750     }
751     _;
752 }
753     
754     modifier checkStart(){
755         require(block.timestamp > starttime,"not start");
756         _;
757     }
758 
759     function notifyRewardAmount()
760         external
761         onlyRewardDistribution
762         updateReward(address(0))
763     {
764         if (block.timestamp >= periodFinish) {
765             rewardRate = initreward.div(DURATION);
766         } else {
767             uint256 remaining = periodFinish.sub(block.timestamp);
768             uint256 leftover = remaining.mul(rewardRate);
769             rewardRate = initreward.add(leftover).div(DURATION);
770         }
771        // vamp.mint(address(this),initreward);
772         starttime = block.timestamp;
773         lastUpdateTime = block.timestamp;
774         periodFinish = block.timestamp.add(DURATION);
775         emit RewardAdded(initreward);
776     }
777 }