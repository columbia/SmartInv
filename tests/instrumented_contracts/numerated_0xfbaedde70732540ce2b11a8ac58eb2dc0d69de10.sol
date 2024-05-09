1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Staking Rewards for Balancer SNX/USDC Liquidity Providers 0x815f8ef4863451f4faf34fbc860034812e7377d9
9 * 
10 * Synthetix: StakingRewards.sol
11 *
12 * Latest source (may be newer): https://github.com/Synthetixio/synthetix/blob/master/contracts/StakingRewards.sol
13 * Docs: https://docs.synthetix.io/contracts/StakingRewards
14 *
15 * Contract Dependencies: 
16 *	- Owned
17 *	- ReentrancyGuard
18 *	- RewardsDistributionRecipient
19 *	- TokenWrapper
20 * Libraries: 
21 *	- Address
22 *	- Math
23 *	- SafeERC20
24 *	- SafeMath
25 *
26 * MIT License
27 * ===========
28 *
29 * Copyright (c) 2020 Synthetix
30 *
31 * Permission is hereby granted, free of charge, to any person obtaining a copy
32 * of this software and associated documentation files (the "Software"), to deal
33 * in the Software without restriction, including without limitation the rights
34 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
35 * copies of the Software, and to permit persons to whom the Software is
36 * furnished to do so, subject to the following conditions:
37 *
38 * The above copyright notice and this permission notice shall be included in all
39 * copies or substantial portions of the Software.
40 *
41 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
42 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
43 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
44 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
45 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
46 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
47 */
48 
49 /* ===============================================
50 * Flattened with Solidifier by Coinage
51 * 
52 * https://solidifier.coina.ge
53 * ===============================================
54 */
55 
56 
57 pragma solidity ^0.5.0;
58 
59 /**
60  * @dev Standard math utilities missing in the Solidity language.
61  */
62 library Math {
63     /**
64      * @dev Returns the largest of two numbers.
65      */
66     function max(uint256 a, uint256 b) internal pure returns (uint256) {
67         return a >= b ? a : b;
68     }
69 
70     /**
71      * @dev Returns the smallest of two numbers.
72      */
73     function min(uint256 a, uint256 b) internal pure returns (uint256) {
74         return a < b ? a : b;
75     }
76 
77     /**
78      * @dev Returns the average of two numbers. The result is rounded towards
79      * zero.
80      */
81     function average(uint256 a, uint256 b) internal pure returns (uint256) {
82         // (a + b) / 2 can overflow, so we distribute
83         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
84     }
85 }
86 
87 
88 /**
89  * @dev Wrappers over Solidity's arithmetic operations with added overflow
90  * checks.
91  *
92  * Arithmetic operations in Solidity wrap on overflow. This can easily result
93  * in bugs, because programmers usually assume that an overflow raises an
94  * error, which is the standard behavior in high level programming languages.
95  * `SafeMath` restores this intuition by reverting the transaction when an
96  * operation overflows.
97  *
98  * Using this library instead of the unchecked operations eliminates an entire
99  * class of bugs, so it's recommended to use it always.
100  */
101 library SafeMath {
102     /**
103      * @dev Returns the addition of two unsigned integers, reverting on
104      * overflow.
105      *
106      * Counterpart to Solidity's `+` operator.
107      *
108      * Requirements:
109      * - Addition cannot overflow.
110      */
111     function add(uint256 a, uint256 b) internal pure returns (uint256) {
112         uint256 c = a + b;
113         require(c >= a, "SafeMath: addition overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
128         require(b <= a, "SafeMath: subtraction overflow");
129         uint256 c = a - b;
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      * - Multiplication cannot overflow.
142      */
143     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
144         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
145         // benefit is lost if 'b' is also tested.
146         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
147         if (a == 0) {
148             return 0;
149         }
150 
151         uint256 c = a * b;
152         require(c / a == b, "SafeMath: multiplication overflow");
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers. Reverts on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator. Note: this function uses a
162      * `revert` opcode (which leaves remaining gas untouched) while Solidity
163      * uses an invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      * - The divisor cannot be zero.
167      */
168     function div(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Solidity only automatically asserts when dividing by 0
170         require(b > 0, "SafeMath: division by zero");
171         uint256 c = a / b;
172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      * - The divisor cannot be zero.
187      */
188     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
189         require(b != 0, "SafeMath: modulo by zero");
190         return a % b;
191     }
192 }
193 
194 
195 /**
196  * @dev Contract module that helps prevent reentrant calls to a function.
197  *
198  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
199  * available, which can be aplied to functions to make sure there are no nested
200  * (reentrant) calls to them.
201  *
202  * Note that because there is a single `nonReentrant` guard, functions marked as
203  * `nonReentrant` may not call one another. This can be worked around by making
204  * those functions `private`, and then adding `external` `nonReentrant` entry
205  * points to them.
206  */
207 contract ReentrancyGuard {
208     /// @dev counter to allow mutex lock with only one SSTORE operation
209     uint256 private _guardCounter;
210 
211     constructor () internal {
212         // The counter starts at one to prevent changing it from zero to a non-zero
213         // value, which is a more expensive operation.
214         _guardCounter = 1;
215     }
216 
217     /**
218      * @dev Prevents a contract from calling itself, directly or indirectly.
219      * Calling a `nonReentrant` function from another `nonReentrant`
220      * function is not supported. It is possible to prevent this from happening
221      * by making the `nonReentrant` function external, and make it call a
222      * `private` function that does the actual work.
223      */
224     modifier nonReentrant() {
225         _guardCounter += 1;
226         uint256 localCounter = _guardCounter;
227         _;
228         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
229     }
230 }
231 
232 
233 interface IERC20 {
234     // ERC20 Optional Views
235     function name() external view returns (string memory);
236 
237     function symbol() external view returns (string memory);
238 
239     function decimals() external view returns (uint8);
240 
241     // Views
242     function totalSupply() external view returns (uint);
243 
244     function balanceOf(address owner) external view returns (uint);
245 
246     function allowance(address owner, address spender) external view returns (uint);
247 
248     // Mutative functions
249     function transfer(address to, uint value) external returns (bool);
250 
251     function approve(address spender, uint value) external returns (bool);
252 
253     function transferFrom(
254         address from,
255         address to,
256         uint value
257     ) external returns (bool);
258 
259     // Events
260     event Transfer(address indexed from, address indexed to, uint value);
261 
262     event Approval(address indexed owner, address indexed spender, uint value);
263 }
264 
265 
266 /**
267  * @dev Collection of functions related to the address type,
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * This test is non-exhaustive, and there may be false-negatives: during the
274      * execution of a contract's constructor, its address will be reported as
275      * not containing a contract.
276      *
277      * > It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      */
280     function isContract(address account) internal view returns (bool) {
281         // This method relies in extcodesize, which returns 0 for contracts in
282         // construction, since the code is only stored at the end of the
283         // constructor execution.
284 
285         uint256 size;
286         // solhint-disable-next-line no-inline-assembly
287         assembly { size := extcodesize(account) }
288         return size > 0;
289     }
290 }
291 
292 
293 library SafeERC20 {
294     using SafeMath for uint256;
295     using Address for address;
296 
297     function safeTransfer(IERC20 token, address to, uint256 value) internal {
298         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
299     }
300 
301     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
302         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
303     }
304 
305     function safeApprove(IERC20 token, address spender, uint256 value) internal {
306         // safeApprove should only be called when setting an initial allowance,
307         // or when resetting it to zero. To increase and decrease it, use
308         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
309         // solhint-disable-next-line max-line-length
310         require((value == 0) || (token.allowance(address(this), spender) == 0),
311             "SafeERC20: approve from non-zero to non-zero allowance"
312         );
313         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
314     }
315 
316     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
317         uint256 newAllowance = token.allowance(address(this), spender).add(value);
318         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
319     }
320 
321     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
322         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
323         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
324     }
325 
326     /**
327      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
328      * on the return value: the return value is optional (but if data is returned, it must not be false).
329      * @param token The token targeted by the call.
330      * @param data The call data (encoded using abi.encode or one of its variants).
331      */
332     function callOptionalReturn(IERC20 token, bytes memory data) private {
333         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
334         // we're implementing it ourselves.
335 
336         // A Solidity high level call has three parts:
337         //  1. The target address is checked to verify it contains contract code
338         //  2. The call itself is made, and success asserted
339         //  3. The return value is decoded, which in turn checks the size of the returned data.
340         // solhint-disable-next-line max-line-length
341         require(address(token).isContract(), "SafeERC20: call to non-contract");
342 
343         // solhint-disable-next-line avoid-low-level-calls
344         (bool success, bytes memory returndata) = address(token).call(data);
345         require(success, "SafeERC20: low-level call failed");
346 
347         if (returndata.length > 0) { // Return data is optional
348             // solhint-disable-next-line max-line-length
349             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
350         }
351     }
352 }
353 
354 
355 // https://docs.synthetix.io/contracts/Owned
356 contract Owned {
357     address public owner;
358     address public nominatedOwner;
359 
360     constructor(address _owner) public {
361         require(_owner != address(0), "Owner address cannot be 0");
362         owner = _owner;
363         emit OwnerChanged(address(0), _owner);
364     }
365 
366     function nominateNewOwner(address _owner) external onlyOwner {
367         nominatedOwner = _owner;
368         emit OwnerNominated(_owner);
369     }
370 
371     function acceptOwnership() external {
372         require(msg.sender == nominatedOwner, "You must be nominated before you can accept ownership");
373         emit OwnerChanged(owner, nominatedOwner);
374         owner = nominatedOwner;
375         nominatedOwner = address(0);
376     }
377 
378     modifier onlyOwner {
379         require(msg.sender == owner, "Only the contract owner may perform this action");
380         _;
381     }
382 
383     event OwnerNominated(address newOwner);
384     event OwnerChanged(address oldOwner, address newOwner);
385 }
386 
387 
388 // Inheritance
389 
390 
391 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
392 contract RewardsDistributionRecipient is Owned {
393     address public rewardsDistribution;
394 
395     function notifyRewardAmount(uint256 reward) external;
396 
397     modifier onlyRewardsDistribution() {
398         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
399         _;
400     }
401 
402     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
403         rewardsDistribution = _rewardsDistribution;
404     }
405 }
406 
407 
408 contract TokenWrapper is ReentrancyGuard {
409     using SafeMath for uint256;
410     using SafeERC20 for IERC20;
411 
412     IERC20 public stakingToken;
413 
414     uint256 private _totalSupply;
415     mapping(address => uint256) private _balances;
416 
417     constructor(address _stakingToken) public {
418         stakingToken = IERC20(_stakingToken);
419     }
420 
421     function totalSupply() public view returns (uint256) {
422         return _totalSupply;
423     }
424 
425     function balanceOf(address account) public view returns (uint256) {
426         return _balances[account];
427     }
428 
429     function stake(uint256 amount) public nonReentrant {
430         _totalSupply = _totalSupply.add(amount);
431         _balances[msg.sender] = _balances[msg.sender].add(amount);
432         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
433     }
434 
435     function withdraw(uint256 amount) public nonReentrant {
436         _totalSupply = _totalSupply.sub(amount);
437         _balances[msg.sender] = _balances[msg.sender].sub(amount);
438         stakingToken.safeTransfer(msg.sender, amount);
439     }
440 }
441 
442 
443 contract StakingRewards is TokenWrapper, RewardsDistributionRecipient {
444     IERC20 public rewardsToken;
445 
446     uint256 public constant DURATION = 7 days;
447 
448     uint256 public periodFinish = 0;
449     uint256 public rewardRate = 0;
450     uint256 public lastUpdateTime;
451     uint256 public rewardPerTokenStored;
452     mapping(address => uint256) public userRewardPerTokenPaid;
453     mapping(address => uint256) public rewards;
454 
455     event RewardAdded(uint256 reward);
456     event Staked(address indexed user, uint256 amount);
457     event Withdrawn(address indexed user, uint256 amount);
458     event RewardPaid(address indexed user, uint256 reward);
459 
460     constructor(
461         address _owner,
462         address _rewardsToken, 
463         address _stakingToken
464     ) public TokenWrapper(_stakingToken) Owned(_owner) {
465         rewardsToken = IERC20(_rewardsToken);
466     }
467 
468     modifier updateReward(address account) {
469         rewardPerTokenStored = rewardPerToken();
470         lastUpdateTime = lastTimeRewardApplicable();
471         if (account != address(0)) {
472             rewards[account] = earned(account);
473             userRewardPerTokenPaid[account] = rewardPerTokenStored;
474         }
475         _;
476     }
477 
478     function lastTimeRewardApplicable() public view returns (uint256) {
479         return Math.min(block.timestamp, periodFinish);
480     }
481 
482     function rewardPerToken() public view returns (uint256) {
483         if (totalSupply() == 0) {
484             return rewardPerTokenStored;
485         }
486         return
487             rewardPerTokenStored.add(
488                 lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(totalSupply())
489             );
490     }
491 
492     function earned(address account) public view returns (uint256) {
493         return balanceOf(account).mul(rewardPerToken().sub(userRewardPerTokenPaid[account])).div(1e18).add(rewards[account]);
494     }
495 
496     // stake visibility is public as overriding LPTokenWrapper's stake() function
497     function stake(uint256 amount) public updateReward(msg.sender) {
498         require(amount > 0, "Cannot stake 0");
499         super.stake(amount);
500         emit Staked(msg.sender, amount);
501     }
502 
503     function withdraw(uint256 amount) public updateReward(msg.sender) {
504         require(amount > 0, "Cannot withdraw 0");
505         super.withdraw(amount);
506         emit Withdrawn(msg.sender, amount);
507     }
508 
509     function exit() external {
510         withdraw(balanceOf(msg.sender));
511         getReward();
512     }
513 
514     function getReward() public updateReward(msg.sender) {
515         uint256 reward = earned(msg.sender);
516         if (reward > 0) {
517             rewards[msg.sender] = 0;
518             rewardsToken.safeTransfer(msg.sender, reward);
519             emit RewardPaid(msg.sender, reward);
520         }
521     }
522 
523     function notifyRewardAmount(uint256 reward) external onlyRewardsDistribution updateReward(address(0)) {
524         if (block.timestamp >= periodFinish) {
525             rewardRate = reward.div(DURATION);
526         } else {
527             uint256 remaining = periodFinish.sub(block.timestamp);
528             uint256 leftover = remaining.mul(rewardRate);
529             rewardRate = reward.add(leftover).div(DURATION);
530         }
531         lastUpdateTime = block.timestamp;
532         periodFinish = block.timestamp.add(DURATION);
533         emit RewardAdded(reward);
534     }
535 }