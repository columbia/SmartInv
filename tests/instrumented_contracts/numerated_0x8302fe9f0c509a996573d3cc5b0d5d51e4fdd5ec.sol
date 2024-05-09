1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Staking Rewards for UNI-V2 sGOLD Liquidity Providers 
9 * Synthetix: StakingRewards.sol
10 *
11 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/StakingRewards.sol
12 * Docs: https://docs.synthetix.io/contracts/StakingRewards
13 *
14 * Contract Dependencies: 
15 *	- Owned
16 *	- ReentrancyGuard
17 *	- RewardsDistributionRecipient
18 *	- TokenWrapper
19 * Libraries: 
20 *	- Address
21 *	- Math
22 *	- SafeERC20
23 *	- SafeMath
24 *
25 * MIT License
26 * ===========
27 *
28 * Copyright (c) 2020 Synthetix
29 *
30 * Permission is hereby granted, free of charge, to any person obtaining a copy
31 * of this software and associated documentation files (the "Software"), to deal
32 * in the Software without restriction, including without limitation the rights
33 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
34 * copies of the Software, and to permit persons to whom the Software is
35 * furnished to do so, subject to the following conditions:
36 *
37 * The above copyright notice and this permission notice shall be included in all
38 * copies or substantial portions of the Software.
39 *
40 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
41 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
42 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
43 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
44 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
45 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
46 */
47 
48 /* ===============================================
49 * Flattened with Solidifier by Coinage
50 * 
51 * https://solidifier.coina.ge
52 * ===============================================
53 */
54 
55 
56 pragma solidity ^0.5.0;
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
86 
87 /**
88  * @dev Wrappers over Solidity's arithmetic operations with added overflow
89  * checks.
90  *
91  * Arithmetic operations in Solidity wrap on overflow. This can easily result
92  * in bugs, because programmers usually assume that an overflow raises an
93  * error, which is the standard behavior in high level programming languages.
94  * `SafeMath` restores this intuition by reverting the transaction when an
95  * operation overflows.
96  *
97  * Using this library instead of the unchecked operations eliminates an entire
98  * class of bugs, so it's recommended to use it always.
99  */
100 library SafeMath {
101     /**
102      * @dev Returns the addition of two unsigned integers, reverting on
103      * overflow.
104      *
105      * Counterpart to Solidity's `+` operator.
106      *
107      * Requirements:
108      * - Addition cannot overflow.
109      */
110     function add(uint256 a, uint256 b) internal pure returns (uint256) {
111         uint256 c = a + b;
112         require(c >= a, "SafeMath: addition overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         require(b <= a, "SafeMath: subtraction overflow");
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
145         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
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
168         // Solidity only automatically asserts when dividing by 0
169         require(b > 0, "SafeMath: division by zero");
170         uint256 c = a / b;
171         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
178      * Reverts when dividing by zero.
179      *
180      * Counterpart to Solidity's `%` operator. This function uses a `revert`
181      * opcode (which leaves remaining gas untouched) while Solidity uses an
182      * invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      * - The divisor cannot be zero.
186      */
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         require(b != 0, "SafeMath: modulo by zero");
189         return a % b;
190     }
191 }
192 
193 
194 /**
195  * @dev Contract module that helps prevent reentrant calls to a function.
196  *
197  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
198  * available, which can be aplied to functions to make sure there are no nested
199  * (reentrant) calls to them.
200  *
201  * Note that because there is a single `nonReentrant` guard, functions marked as
202  * `nonReentrant` may not call one another. This can be worked around by making
203  * those functions `private`, and then adding `external` `nonReentrant` entry
204  * points to them.
205  */
206 contract ReentrancyGuard {
207     /// @dev counter to allow mutex lock with only one SSTORE operation
208     uint256 private _guardCounter;
209 
210     constructor () internal {
211         // The counter starts at one to prevent changing it from zero to a non-zero
212         // value, which is a more expensive operation.
213         _guardCounter = 1;
214     }
215 
216     /**
217      * @dev Prevents a contract from calling itself, directly or indirectly.
218      * Calling a `nonReentrant` function from another `nonReentrant`
219      * function is not supported. It is possible to prevent this from happening
220      * by making the `nonReentrant` function external, and make it call a
221      * `private` function that does the actual work.
222      */
223     modifier nonReentrant() {
224         _guardCounter += 1;
225         uint256 localCounter = _guardCounter;
226         _;
227         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
228     }
229 }
230 
231 
232 interface IERC20 {
233     // ERC20 Optional Views
234     function name() external view returns (string memory);
235 
236     function symbol() external view returns (string memory);
237 
238     function decimals() external view returns (uint8);
239 
240     // Views
241     function totalSupply() external view returns (uint);
242 
243     function balanceOf(address owner) external view returns (uint);
244 
245     function allowance(address owner, address spender) external view returns (uint);
246 
247     // Mutative functions
248     function transfer(address to, uint value) external returns (bool);
249 
250     function approve(address spender, uint value) external returns (bool);
251 
252     function transferFrom(
253         address from,
254         address to,
255         uint value
256     ) external returns (bool);
257 
258     // Events
259     event Transfer(address indexed from, address indexed to, uint value);
260 
261     event Approval(address indexed owner, address indexed spender, uint value);
262 }
263 
264 
265 /**
266  * @dev Collection of functions related to the address type,
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * This test is non-exhaustive, and there may be false-negatives: during the
273      * execution of a contract's constructor, its address will be reported as
274      * not containing a contract.
275      *
276      * > It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      */
279     function isContract(address account) internal view returns (bool) {
280         // This method relies in extcodesize, which returns 0 for contracts in
281         // construction, since the code is only stored at the end of the
282         // constructor execution.
283 
284         uint256 size;
285         // solhint-disable-next-line no-inline-assembly
286         assembly { size := extcodesize(account) }
287         return size > 0;
288     }
289 }
290 
291 
292 library SafeERC20 {
293     using SafeMath for uint256;
294     using Address for address;
295 
296     function safeTransfer(IERC20 token, address to, uint256 value) internal {
297         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
298     }
299 
300     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
301         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
302     }
303 
304     function safeApprove(IERC20 token, address spender, uint256 value) internal {
305         // safeApprove should only be called when setting an initial allowance,
306         // or when resetting it to zero. To increase and decrease it, use
307         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
308         // solhint-disable-next-line max-line-length
309         require((value == 0) || (token.allowance(address(this), spender) == 0),
310             "SafeERC20: approve from non-zero to non-zero allowance"
311         );
312         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
313     }
314 
315     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
316         uint256 newAllowance = token.allowance(address(this), spender).add(value);
317         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
318     }
319 
320     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
321         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
322         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
323     }
324 
325     /**
326      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
327      * on the return value: the return value is optional (but if data is returned, it must not be false).
328      * @param token The token targeted by the call.
329      * @param data The call data (encoded using abi.encode or one of its variants).
330      */
331     function callOptionalReturn(IERC20 token, bytes memory data) private {
332         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
333         // we're implementing it ourselves.
334 
335         // A Solidity high level call has three parts:
336         //  1. The target address is checked to verify it contains contract code
337         //  2. The call itself is made, and success asserted
338         //  3. The return value is decoded, which in turn checks the size of the returned data.
339         // solhint-disable-next-line max-line-length
340         require(address(token).isContract(), "SafeERC20: call to non-contract");
341 
342         // solhint-disable-next-line avoid-low-level-calls
343         (bool success, bytes memory returndata) = address(token).call(data);
344         require(success, "SafeERC20: low-level call failed");
345 
346         if (returndata.length > 0) { // Return data is optional
347             // solhint-disable-next-line max-line-length
348             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
349         }
350     }
351 }
352 
353 
354 // https://docs.synthetix.io/contracts/Owned
355 contract Owned {
356     address public owner;
357     address public nominatedOwner;
358 
359     constructor(address _owner) public {
360         require(_owner != address(0), "Owner address cannot be 0");
361         owner = _owner;
362         emit OwnerChanged(address(0), _owner);
363     }
364 
365     function nominateNewOwner(address _owner) external onlyOwner {
366         nominatedOwner = _owner;
367         emit OwnerNominated(_owner);
368     }
369 
370     function acceptOwnership() external {
371         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
372         emit OwnerChanged(owner, nominatedOwner);
373         owner = nominatedOwner;
374         nominatedOwner = address(0);
375     }
376 
377     modifier onlyOwner {
378         require(msg.sender == owner, "Only the contract owner may perform this action");
379         _;
380     }
381 
382     event OwnerNominated(address newOwner);
383     event OwnerChanged(address oldOwner, address newOwner);
384 }
385 
386 
387 // Inheritance
388 
389 
390 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
391 contract RewardsDistributionRecipient is Owned {
392     address public rewardsDistribution;
393 
394     function notifyRewardAmount(uint256 reward) external;
395 
396     modifier onlyRewardsDistribution() {
397         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
398         _;
399     }
400 
401     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
402         rewardsDistribution = _rewardsDistribution;
403     }
404 }
405 
406 
407 contract TokenWrapper is ReentrancyGuard {
408     using SafeMath for uint256;
409     using SafeERC20 for IERC20;
410 
411     IERC20 public stakingToken;
412 
413     uint256 private _totalSupply;
414     mapping(address => uint256) private _balances;
415 
416     constructor(address _stakingToken) public {
417         stakingToken = IERC20(_stakingToken);
418     }
419 
420     function totalSupply() public view returns (uint256) {
421         return _totalSupply;
422     }
423 
424     function balanceOf(address account) public view returns (uint256) {
425         return _balances[account];
426     }
427 
428     function stake(uint256 amount) public nonReentrant {
429         _totalSupply = _totalSupply.add(amount);
430         _balances[msg.sender] = _balances[msg.sender].add(amount);
431         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
432     }
433 
434     function withdraw(uint256 amount) public nonReentrant {
435         _totalSupply = _totalSupply.sub(amount);
436         _balances[msg.sender] = _balances[msg.sender].sub(amount);
437         stakingToken.safeTransfer(msg.sender, amount);
438     }
439 }
440 
441 
442 contract StakingRewards is TokenWrapper, RewardsDistributionRecipient {
443     IERC20 public rewardsToken;
444 
445     uint256 public constant DURATION = 7 days;
446 
447     uint256 public periodFinish = 0;
448     uint256 public rewardRate = 0;
449     uint256 public lastUpdateTime;
450     uint256 public rewardPerTokenStored;
451     mapping(address => uint256) public userRewardPerTokenPaid;
452     mapping(address => uint256) public rewards;
453 
454     event RewardAdded(uint256 reward);
455     event Staked(address indexed user, uint256 amount);
456     event Withdrawn(address indexed user, uint256 amount);
457     event RewardPaid(address indexed user, uint256 reward);
458 
459     constructor(
460         address _owner,
461         address _rewardsToken, 
462         address _stakingToken
463     ) public TokenWrapper(_stakingToken) Owned(_owner) {
464         rewardsToken = IERC20(_rewardsToken);
465     }
466 
467     modifier updateReward(address account) {
468         rewardPerTokenStored = rewardPerToken();
469         lastUpdateTime = lastTimeRewardApplicable();
470         if (account != address(0)) {
471             rewards[account] = earned(account);
472             userRewardPerTokenPaid[account] = rewardPerTokenStored;
473         }
474         _;
475     }
476 
477     function lastTimeRewardApplicable() public view returns (uint256) {
478         return Math.min(block.timestamp, periodFinish);
479     }
480 
481     function rewardPerToken() public view returns (uint256) {
482         if (totalSupply() == 0) {
483             return rewardPerTokenStored;
484         }
485         return
486             rewardPerTokenStored.add(
487                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply())
488             );
489     }
490 
491     function earned(address account) public view returns (uint256) {
492         return balanceOf(account).mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
493     }
494 
495     // stake visibility is public as overriding LPTokenWrapper's stake() function
496     function stake(uint256 amount) public updateReward(msg.sender) {
497         require(amount > 0, "Cannot stake 0");
498         super.stake(amount);
499         emit Staked(msg.sender, amount);
500     }
501 
502     function withdraw(uint256 amount) public updateReward(msg.sender) {
503         require(amount > 0, "Cannot withdraw 0");
504         super.withdraw(amount);
505         emit Withdrawn(msg.sender, amount);
506     }
507 
508     function exit() external {
509         withdraw(balanceOf(msg.sender));
510         getReward();
511     }
512 
513     function getReward() public updateReward(msg.sender) {
514         uint256 reward = earned(msg.sender);
515         if (reward > 0) {
516             rewards[msg.sender] = 0;
517             rewardsToken.safeTransfer(msg.sender, reward);
518             emit RewardPaid(msg.sender, reward);
519         }
520     }
521 
522     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
523         if (block.timestamp >= periodFinish) {
524             rewardRate = reward.div(DURATION);
525         } else {
526             uint256 remaining = periodFinish.sub(block.timestamp);
527             uint256 leftover = remaining.mul(rewardRate);
528             rewardRate = reward.add(leftover).div(DURATION);
529         }
530         lastUpdateTime = block.timestamp;
531         periodFinish = block.timestamp.add(DURATION);
532         emit RewardAdded(reward);
533     }
534 }