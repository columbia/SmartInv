1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-26
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/math/Math.sol
7 pragma solidity ^0.5.0;
8 
9 /**
10  * @dev Standard math utilities missing in the Solidity language.
11  */
12 library Math {
13     /**
14      * @dev Returns the largest of two numbers.
15      */
16     function max(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a >= b ? a : b;
18     }
19 
20     /**
21      * @dev Returns the smallest of two numbers.
22      */
23     function min(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a < b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the average of two numbers. The result is rounded towards
29      * zero.
30      */
31     function average(uint256 a, uint256 b) internal pure returns (uint256) {
32         // (a + b) / 2 can overflow, so we distribute
33         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
34     }
35 }
36 
37 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
38 
39 pragma solidity ^0.5.0;
40 
41 /**
42  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
43  * the optional functions; to access them see {ERC20Detailed}.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 // File: @openzeppelin/contracts/GSN/Context.sol
117 /*
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with GSN meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 contract Context {
128     // Empty internal constructor, to prevent people from mistakenly deploying
129     // an instance of this contract, which should be used via inheritance.
130     constructor () internal { }
131     // solhint-disable-previous-line no-empty-blocks
132 
133     function _msgSender() internal view returns (address payable) {
134         return msg.sender;
135     }
136 
137     function _msgData() internal view returns (bytes memory) {
138         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
139         return msg.data;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/ownership/Ownable.sol
144 /**
145  * @dev Contract module which provides a basic access control mechanism, where
146  * there is an account (an owner) that can be granted exclusive access to
147  * specific functions.
148  *
149  * This module is used through inheritance. It will make available the modifier
150  * `onlyOwner`, which can be applied to your functions to restrict their use to
151  * the owner.
152  */
153 contract Ownable is Context {
154     address public _owner;
155 
156     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
157 
158     /**
159      * @dev Initializes the contract setting the deployer as the initial owner.
160      */
161     constructor () internal {
162         address msgSender = _msgSender();
163         _owner = msgSender;
164         emit OwnershipTransferred(address(0), msgSender);
165     }
166 
167     /**
168      * @dev Returns the address of the current owner.
169      */
170     function owner() public view returns (address) {
171         return _owner;
172     }
173 
174     /**
175      * @dev Throws if called by any account other than the owner.
176      */
177     modifier onlyOwner() {
178         require(isOwner(), "Ownable: caller is not the owner");
179         _;
180     }
181 
182     /**
183      * @dev Returns true if the caller is the current owner.
184      */
185     function isOwner() public view returns (bool) {
186         return _msgSender() == _owner;
187     }
188 
189     /**
190      * @dev Leaves the contract without owner. It will not be possible to call
191      * `onlyOwner` functions anymore. Can only be called by the current owner.
192      *
193      * NOTE: Renouncing ownership will leave the contract without an owner,
194      * thereby removing any functionality that is only available to the owner.
195      */
196     function renounceOwnership() public onlyOwner {
197         emit OwnershipTransferred(_owner, address(0));
198         _owner = address(0);
199     }
200 
201     /**
202      * @dev Transfers ownership of the contract to a new account (`newOwner`).
203      * Can only be called by the current owner.
204      */
205     function transferOwnership(address newOwner) public onlyOwner {
206         _transferOwnership(newOwner);
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      */
212     function _transferOwnership(address newOwner) internal {
213         require(newOwner != address(0), "Ownable: new owner is the zero address");
214         emit OwnershipTransferred(_owner, newOwner);
215         _owner = newOwner;
216     }
217 }
218 
219 
220 pragma solidity ^0.5.0;
221 
222 
223 contract IRewardDistributionRecipient is Ownable {
224     address public rewardDistribution;
225 
226     function notifyRewardAmount(uint256 reward, uint256 _duration) external;
227 
228     modifier onlyRewardDistribution() {
229         require(
230             _msgSender() == rewardDistribution,
231             "Caller is not reward distribution"
232         );
233         _;
234     }
235 
236     function setRewardDistribution(address _rewardDistribution)
237         external
238         onlyOwner
239     {
240         rewardDistribution = _rewardDistribution;
241     }
242 }
243 
244 // File: @openzeppelin/contracts/math/SafeMath.sol
245 
246 pragma solidity ^0.5.0;
247 
248 /**
249  * @dev Wrappers over Solidity's arithmetic operations with added overflow
250  * checks.
251  *
252  * Arithmetic operations in Solidity wrap on overflow. This can easily result
253  * in bugs, because programmers usually assume that an overflow raises an
254  * error, which is the standard behavior in high level programming languages.
255  * `SafeMath` restores this intuition by reverting the transaction when an
256  * operation overflows.
257  *
258  * Using this library instead of the unchecked operations eliminates an entire
259  * class of bugs, so it's recommended to use it always.
260  */
261 library SafeMath {
262     /**
263      * @dev Returns the addition of two unsigned integers, reverting on
264      * overflow.
265      *
266      * Counterpart to Solidity's `+` operator.
267      *
268      * Requirements:
269      * - Addition cannot overflow.
270      */
271     function add(uint256 a, uint256 b) internal pure returns (uint256) {
272         uint256 c = a + b;
273         require(c >= a, "SafeMath: addition overflow");
274 
275         return c;
276     }
277 
278     /**
279      * @dev Returns the subtraction of two unsigned integers, reverting on
280      * overflow (when the result is negative).
281      *
282      * Counterpart to Solidity's `-` operator.
283      *
284      * Requirements:
285      * - Subtraction cannot overflow.
286      */
287     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
288         return sub(a, b, "SafeMath: subtraction overflow");
289     }
290 
291     /**
292      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
293      * overflow (when the result is negative).
294      *
295      * Counterpart to Solidity's `-` operator.
296      *
297      * Requirements:
298      * - Subtraction cannot overflow.
299      *
300      * _Available since v2.4.0._
301      */
302     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
303         require(b <= a, errorMessage);
304         uint256 c = a - b;
305 
306         return c;
307     }
308 
309     /**
310      * @dev Returns the multiplication of two unsigned integers, reverting on
311      * overflow.
312      *
313      * Counterpart to Solidity's `*` operator.
314      *
315      * Requirements:
316      * - Multiplication cannot overflow.
317      */
318     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
319         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
320         // benefit is lost if 'b' is also tested.
321         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
322         if (a == 0) {
323             return 0;
324         }
325 
326         uint256 c = a * b;
327         require(c / a == b, "SafeMath: multiplication overflow");
328 
329         return c;
330     }
331 
332     /**
333      * @dev Returns the integer division of two unsigned integers. Reverts on
334      * division by zero. The result is rounded towards zero.
335      *
336      * Counterpart to Solidity's `/` operator. Note: this function uses a
337      * `revert` opcode (which leaves remaining gas untouched) while Solidity
338      * uses an invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      * - The divisor cannot be zero.
342      */
343     function div(uint256 a, uint256 b) internal pure returns (uint256) {
344         return div(a, b, "SafeMath: division by zero");
345     }
346 
347     /**
348      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
349      * division by zero. The result is rounded towards zero.
350      *
351      * Counterpart to Solidity's `/` operator. Note: this function uses a
352      * `revert` opcode (which leaves remaining gas untouched) while Solidity
353      * uses an invalid opcode to revert (consuming all remaining gas).
354      *
355      * Requirements:
356      * - The divisor cannot be zero.
357      *
358      * _Available since v2.4.0._
359      */
360     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
361         // Solidity only automatically asserts when dividing by 0
362         require(b > 0, errorMessage);
363         uint256 c = a / b;
364         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
365 
366         return c;
367     }
368 
369     /**
370      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
371      * Reverts when dividing by zero.
372      *
373      * Counterpart to Solidity's `%` operator. This function uses a `revert`
374      * opcode (which leaves remaining gas untouched) while Solidity uses an
375      * invalid opcode to revert (consuming all remaining gas).
376      *
377      * Requirements:
378      * - The divisor cannot be zero.
379      */
380     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
381         return mod(a, b, "SafeMath: modulo by zero");
382     }
383 
384     /**
385      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
386      * Reverts with custom message when dividing by zero.
387      *
388      * Counterpart to Solidity's `%` operator. This function uses a `revert`
389      * opcode (which leaves remaining gas untouched) while Solidity uses an
390      * invalid opcode to revert (consuming all remaining gas).
391      *
392      * Requirements:
393      * - The divisor cannot be zero.
394      *
395      * _Available since v2.4.0._
396      */
397     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
398         require(b != 0, errorMessage);
399         return a % b;
400     }
401 }
402 
403 // File: @openzeppelin/contracts/utils/Address.sol
404 
405 pragma solidity ^0.5.5;
406 
407 /**
408  * @dev Collection of functions related to the address type
409  */
410 library Address {
411     /**
412      * @dev Returns true if `account` is a contract.
413      *
414      * [IMPORTANT]
415      * ====
416      * It is unsafe to assume that an address for which this function returns
417      * false is an externally-owned account (EOA) and not a contract.
418      *
419      * Among others, `isContract` will return false for the following 
420      * types of addresses:
421      *
422      *  - an externally-owned account
423      *  - a contract in construction
424      *  - an address where a contract will be created
425      *  - an address where a contract lived, but was destroyed
426      * ====
427      */
428     function isContract(address account) internal view returns (bool) {
429         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
430         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
431         // for accounts without code, i.e. `keccak256('')`
432         bytes32 codehash;
433         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
434         // solhint-disable-next-line no-inline-assembly
435         assembly { codehash := extcodehash(account) }
436         return (codehash != accountHash && codehash != 0x0);
437     }
438 
439     /**
440      * @dev Converts an `address` into `address payable`. Note that this is
441      * simply a type cast: the actual underlying value is not changed.
442      *
443      * _Available since v2.4.0._
444      */
445     function toPayable(address account) internal pure returns (address payable) {
446         return address(uint160(account));
447     }
448 
449     /**
450      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
451      * `recipient`, forwarding all available gas and reverting on errors.
452      *
453      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
454      * of certain opcodes, possibly making contracts go over the 2300 gas limit
455      * imposed by `transfer`, making them unable to receive funds via
456      * `transfer`. {sendValue} removes this limitation.
457      *
458      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
459      *
460      * IMPORTANT: because control is transferred to `recipient`, care must be
461      * taken to not create reentrancy vulnerabilities. Consider using
462      * {ReentrancyGuard} or the
463      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
464      *
465      * _Available since v2.4.0._
466      */
467     function sendValue(address payable recipient, uint256 amount) internal {
468         require(address(this).balance >= amount, "Address: insufficient balance");
469 
470         // solhint-disable-next-line avoid-call-value
471         (bool success, ) = recipient.call.value(amount)("");
472         require(success, "Address: unable to send value, recipient may have reverted");
473     }
474 }
475 
476 contract LPTokenWrapper {
477     using SafeMath for uint256;
478 
479     IERC20 public depositToken = IERC20(0x768D5C16a34E11e8383eC294e989a8d704545B61);
480 
481     uint256 private _totalSupply;
482     mapping(address => uint256) private _balances;
483 
484     function totalSupply() public view returns (uint256) {
485         return _totalSupply;
486     }
487 
488     function balanceOf(address account) public view returns (uint256) {
489         return _balances[account];
490     }
491 
492     function stake(uint256 amount) public {
493         _totalSupply = _totalSupply.add(amount);
494         _balances[msg.sender] = _balances[msg.sender].add(amount);
495         depositToken.transferFrom(msg.sender, address(this), amount);
496     }
497 
498     function withdraw(uint256 amount) public {
499         _totalSupply = _totalSupply.sub(amount);
500         _balances[msg.sender] = _balances[msg.sender].sub(amount);
501         depositToken.transfer(msg.sender, amount);
502     }
503 }
504 
505 contract RewardPool is LPTokenWrapper, IRewardDistributionRecipient {
506     IERC20 public layerx = IERC20(0xfe56E974C1C85e9351325fb2D62963A022Ad624F);
507     uint256 public duration = 7 days;
508 
509     uint256 public periodFinish = 0;
510     uint256 public rewardRate = 0;
511     uint256 public lastUpdateTime;
512     uint256 public rewardPerTokenStored;
513     mapping(address => uint256) public userRewardPerTokenPaid;
514     mapping(address => uint256) public rewards;
515 
516     event RewardAdded(uint256 reward);
517     event Staked(address indexed user, uint256 amount);
518     event Withdrawn(address indexed user, uint256 amount);
519     event RewardPaid(address indexed user, uint256 reward);
520 
521     modifier updateReward(address account) {
522         rewardPerTokenStored = rewardPerToken();
523         lastUpdateTime = lastTimeRewardApplicable();
524         if (account != address(0)) {
525             rewards[account] = earned(account);
526             userRewardPerTokenPaid[account] = rewardPerTokenStored;
527         }
528         _;
529     }
530     
531     constructor(address owner,address _rewardDistribution) public {
532         _owner = owner;
533         rewardDistribution = _rewardDistribution;
534         
535     }
536     
537     function lastTimeRewardApplicable() public view returns (uint256) {
538         return Math.min(block.timestamp, periodFinish);
539     }
540 
541     function rewardPerToken() public view returns (uint256) {
542         if (totalSupply() == 0) {
543             return rewardPerTokenStored;
544         }
545         return
546             rewardPerTokenStored.add(
547                 lastTimeRewardApplicable()
548                     .sub(lastUpdateTime)
549                     .mul(rewardRate)
550                     .mul(1e18)
551                     .div(totalSupply())
552             );
553     }
554 
555     function earned(address account) public view returns (uint256) {
556         return
557             balanceOf(account)
558                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
559                 .div(1e18)
560                 .add(rewards[account]);
561     }
562 
563     // stake visibility is public as overriding LPTokenWrapper's stake() function
564     function stake(uint256 amount) public updateReward(msg.sender) {
565         require(amount > 0, "Cannot stake 0");
566         super.stake(amount);
567         emit Staked(msg.sender, amount);
568     }
569 
570     function withdraw(uint256 amount) public updateReward(msg.sender) {
571         require(amount > 0, "Cannot withdraw 0");
572         super.withdraw(amount);
573         emit Withdrawn(msg.sender, amount);
574     }
575 
576     function exit() external {
577         withdraw(balanceOf(msg.sender));
578         getReward();
579     }
580 
581     function getReward() public updateReward(msg.sender) {
582         uint256 reward = earned(msg.sender);
583         if (reward > 0) {
584             rewards[msg.sender] = 0;
585             layerx.transfer(msg.sender, reward);
586             emit RewardPaid(msg.sender, reward);
587         }
588     }
589 
590     function notifyRewardAmount(uint256 reward, uint256 _duration)
591         external
592         onlyRewardDistribution
593         updateReward(address(0))
594     {
595         require(_duration > 0, "duration should be more than 0");
596         duration = _duration;
597         if (block.timestamp >= periodFinish) {
598             rewardRate = reward.div(duration);
599         } else {
600             uint256 remaining = periodFinish.sub(block.timestamp);
601             uint256 leftover = remaining.mul(rewardRate);
602             rewardRate = reward.add(leftover).div(duration);
603         }
604         lastUpdateTime = block.timestamp;
605         periodFinish = block.timestamp.add(duration);
606         emit RewardAdded(reward);
607     }
608     
609     // only when emergency withdraw
610     function withdrawLAYERx(uint256 amount)
611         external
612         onlyRewardDistribution
613     {
614         require(layerx.balanceOf(address(this)) > amount, "amount exceeds");
615         rewardRate = 0;
616         periodFinish = 0;
617         layerx.transfer(msg.sender, amount);
618     }
619     
620     function destroyContract() external onlyOwner {
621         selfdestruct(msg.sender);
622     }  
623     
624 }