1 /*
2    ____            __   __        __   _
3   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
4  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
5 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
6      /___/
7 
8 * Synthetix: Pyramid.sol
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
44 
45     function max(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a >= b ? a : b;
47     }
48 
49     function min(uint256 a, uint256 b) internal pure returns (uint256) {
50         return a < b ? a : b;
51     }
52 
53     function average(uint256 a, uint256 b) internal pure returns (uint256) {
54         // (a + b) / 2 can overflow, so we distribute
55         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
56     }
57 }
58 
59 // File: @openzeppelin/contracts/math/SafeMath.sol
60 
61 pragma solidity ^0.5.0;
62 
63 library SafeMath {
64 
65     function add(uint256 a, uint256 b) internal pure returns (uint256) {
66         uint256 c = a + b;
67         require(c >= a, "SafeMath: addition overflow");
68 
69         return c;
70     }
71 
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b <= a, errorMessage);
78         uint256 c = a - b;
79 
80         return c;
81     }
82 
83     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     function div(uint256 a, uint256 b) internal pure returns (uint256) {
95         return div(a, b, "SafeMath: division by zero");
96     }
97 
98     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
99         // Solidity only automatically asserts when dividing by 0
100         require(b > 0, errorMessage);
101         uint256 c = a / b;
102         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
103 
104         return c;
105     }
106 
107     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
108         return mod(a, b, "SafeMath: modulo by zero");
109     }
110 
111     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
112         require(b != 0, errorMessage);
113         return a % b;
114     }
115 }
116 
117 
118 // File: @openzeppelin/contracts/ownership/Ownable.sol
119 
120 contract Ownable {
121     address private _owner;
122 
123     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
124 
125     constructor () internal {
126         _owner = msg.sender;
127         emit OwnershipTransferred(address(0), _owner);
128     }
129 
130     function owner() public view returns (address) {
131         return _owner;
132     }
133 
134     modifier onlyOwner() {
135         require(isOwner(), "Ownable: caller is not the owner");
136         _;
137     }
138 
139     function isOwner() public view returns (bool) {
140         return msg.sender == _owner;
141     }
142 
143     function renounceOwnership() public onlyOwner {
144         emit OwnershipTransferred(_owner, address(0));
145         _owner = address(0);
146     }
147 
148     function transferOwnership(address newOwner) public onlyOwner {
149         _transferOwnership(newOwner);
150     }
151 
152     function _transferOwnership(address newOwner) internal {
153         require(newOwner != address(0), "Ownable: new owner is the zero address");
154         emit OwnershipTransferred(_owner, newOwner);
155         _owner = newOwner;
156     }
157 }
158 // File: eth-token-recover/contracts/TokenRecover.sol
159 
160 contract TokenRecover is Ownable {
161 
162     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
163         IERC20(tokenAddress).transfer(owner(), tokenAmount);
164     }
165 }
166 
167 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
171  * the optional functions; to access them see {ERC20Detailed}.
172  */
173 interface IERC20 {
174 
175     function totalStaked() external view returns (uint256);
176     function balanceOf(address account) external view returns (uint256);
177     function transfer(address recipient, uint256 amount) external returns (bool);
178     function allowance(address owner, address spender) external view returns (uint256);
179     function approve(address spender, uint256 amount) external returns (bool);
180     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
181     function burn(uint256 amount, uint256 bRate) external returns(uint256);
182 
183     event Transfer(address indexed from, address indexed to, uint256 value);
184     event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 
187 // File: @openzeppelin/contracts/utils/Address.sol
188 
189 pragma solidity ^0.5.5;
190 
191 library Address {
192     /**
193      * @dev Returns true if `account` is a contract.
194      *
195      * This test is non-exhaustive, and there may be false-negatives: during the
196      * execution of a contract's constructor, its address will be reported as
197      * not containing a contract.
198      *
199      * IMPORTANT: It is unsafe to assume that an address for which this
200      * function returns false is an externally-owned account (EOA) and not a
201      * contract.
202      */
203     function isContract(address account) internal view returns (bool) {
204         // This method relies in extcodesize, which returns 0 for contracts in
205         // construction, since the code is only stored at the end of the
206         // constructor execution.
207 
208         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
209         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
210         // for accounts without code, i.e. `keccak256('')`
211         bytes32 codehash;
212         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
213         // solhint-disable-next-line no-inline-assembly
214         assembly { codehash := extcodehash(account) }
215         return (codehash != 0x0 && codehash != accountHash);
216     }
217 
218     /**
219      * @dev Converts an `address` into `address payable`. Note that this is
220      * simply a type cast: the actual underlying value is not changed.
221      *
222      * _Available since v2.4.0._
223      */
224     function toPayable(address account) internal pure returns (address payable) {
225         return address(uint160(account));
226     }
227 
228     /**
229      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
230      * `recipient`, forwarding all available gas and reverting on errors.
231      *
232      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
233      * of certain opcodes, possibly making contracts go over the 2300 gas limit
234      * imposed by `transfer`, making them unable to receive funds via
235      * `transfer`. {sendValue} removes this limitation.
236      *
237      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
238      *
239      * IMPORTANT: because control is transferred to `recipient`, care must be
240      * taken to not create reentrancy vulnerabilities. Consider using
241      * {ReentrancyGuard} or the
242      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
243      *
244      * _Available since v2.4.0._
245      */
246     function sendValue(address payable recipient, uint256 amount) internal {
247         require(address(this).balance >= amount, "Address: insufficient balance");
248 
249         // solhint-disable-next-line avoid-call-value
250         (bool success, ) = recipient.call.value(amount)("");
251         require(success, "Address: unable to send value, recipient may have reverted");
252     }
253 }
254 
255 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
256 
257 /**
258  * @title SafeERC20
259  * @dev Wrappers around ERC20 operations that throw on failure (when the token
260  * contract returns false). Tokens that return no value (and instead revert or
261  * throw on failure) are also supported, non-reverting calls are assumed to be
262  * successful.
263  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
264  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
265  */
266 library SafeERC20 {
267     using SafeMath for uint256;
268     using Address for address;
269 
270     function safeTransfer(IERC20 token, address to, uint256 value) internal {
271         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
272     }
273 
274     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
275         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
276     }
277 
278     function safeApprove(IERC20 token, address spender, uint256 value) internal {
279         // safeApprove should only be called when setting an initial allowance,
280         // or when resetting it to zero. To increase and decrease it, use
281         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
282         // solhint-disable-next-line max-line-length
283         require((value == 0) || (token.allowance(address(this), spender) == 0),
284             "SafeERC20: approve from non-zero to non-zero allowance"
285         );
286         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
287     }
288 
289     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
290         uint256 newAllowance = token.allowance(address(this), spender).add(value);
291         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
292     }
293 
294     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
295         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
296         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
297     }
298 
299     /**
300      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
301      * on the return value: the return value is optional (but if data is returned, it must not be false).
302      * @param token The token targeted by the call.
303      * @param data The call data (encoded using abi.encode or one of its variants).
304      */
305     function callOptionalReturn(IERC20 token, bytes memory data) private {
306         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
307         // we're implementing it ourselves.
308 
309         // A Solidity high level call has three parts:
310         //  1. The target address is checked to verify it contains contract code
311         //  2. The call itself is made, and success asserted
312         //  3. The return value is decoded, which in turn checks the size of the returned data.
313         // solhint-disable-next-line max-line-length
314         require(address(token).isContract(), "SafeERC20: call to non-contract");
315 
316         // solhint-disable-next-line avoid-low-level-calls
317         (bool success, bytes memory returndata) = address(token).call(data);
318         require(success, "SafeERC20: low-level call failed");
319 
320         if (returndata.length > 0) { // Return data is optional
321             // solhint-disable-next-line max-line-length
322             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
323         }
324     }
325 }
326 
327 // File: contracts/IRewardDistributionRecipient.sol
328 
329 contract IRewardDistributionRecipient is Ownable {
330     address public rewardDistribution;
331 
332     function notifyRewardAmount(uint256 reward) external;
333 
334     modifier onlyRewardDistribution() {
335         require(msg.sender == rewardDistribution, "Caller is not reward distribution");
336         _;
337     }
338 
339     function setRewardDistribution(address _rewardDistribution)
340         external
341         onlyOwner
342     {
343         rewardDistribution = _rewardDistribution;
344     }
345 }
346 
347 // File: contracts/CurveRewards.sol
348 
349 contract LPTokenWrapper {
350     using SafeMath for uint256;
351     using SafeERC20 for IERC20;
352     
353     event Stake(address staker, uint256 amount, uint256 operateAmount);
354 
355     IERC20 public rugStake;
356     uint256 burnRate = 3;
357     uint256 redistributeRate = 7;
358 
359     uint256 internal _totalDividends;
360     uint256 internal _totalStaked;
361     uint256 internal _dividendsPerRug;
362 
363     mapping(address => uint256) internal _stakeAmount;
364     mapping(address => uint256) internal _dividendsSnapshot; // Get "position" relative to _totalDividends
365     mapping(address => uint256) internal _userDividends;
366    
367     function totalStaked() public view returns (uint256) {
368         return _totalStaked;
369     }
370 
371     function totalDividends() public view returns (uint256) {
372         return _totalDividends;
373     }
374 
375     function balanceOf(address account) public view returns (uint256) {
376         return _stakeAmount[account];
377     }
378 
379     function checkUserPayout(address staker) public view returns (uint256) {
380         return _dividendsSnapshot[staker];
381     }
382  
383     function dividendsPerRug() public view returns (uint256) {
384         return _dividendsPerRug;
385     }
386 
387     function userDividends(address account) public view returns (uint256) { // Returns the amount of dividends that has been synced by _updateDividends()
388         return _userDividends[account];
389     }
390 
391     function dividendsOf(address staker) public view returns (uint256) {
392         require(_dividendsPerRug >= _dividendsSnapshot[staker], "dividend calc overflow");
393         uint256 sum = balanceOf(staker).mul((_dividendsPerRug.sub(_dividendsSnapshot[staker]))).div(1e18);
394         return sum;
395     }
396 
397     // adds dividends to staked balance
398     function _updateDividends() internal returns(uint256) {
399 		uint256 _dividends = dividendsOf(msg.sender);
400 		require(_dividends >= 0);
401 
402         _userDividends[msg.sender] = _userDividends[msg.sender].add(_dividends);
403         _dividendsSnapshot[msg.sender] = _dividendsPerRug;
404 		return _dividends; // amount of dividends added to _userDividends[]
405     }
406 
407     function displayDividends(address staker) public view returns(uint256) { //created solely to display total amount of dividends on rug.money
408         return (dividendsOf(staker) + userDividends(staker)); 
409     }
410 
411     // withdraw only dividends 
412     function withdrawDividends() public {
413         _updateDividends();
414         uint256 amount = _userDividends[msg.sender];
415         _userDividends[msg.sender] = 0;
416         _totalDividends = _totalDividends.sub(amount);
417         rugStake.safeTransfer(msg.sender, amount);
418     }
419 
420     // 10% fee: 7% redistribution, 3% burn
421     function stake(uint256 amount) public { 
422         rugStake.safeTransferFrom(msg.sender, address(this), amount);
423 
424         bool firstTime = false;
425         if (_stakeAmount[msg.sender] == 0) firstTime = true;
426 
427         uint256 amountToStake = (amount.mul(uint256(100).sub((redistributeRate.add(burnRate)))).div(100));
428         uint256 operateAmount = amount.sub(amountToStake);
429         
430         uint256 burnAmount = operateAmount.mul(burnRate).div(10);
431         rugStake.burn(burnAmount, 100); // burns 100% of burnAmount
432        
433         uint256 dividendAmount = operateAmount.sub(burnAmount);
434 
435         _totalDividends = _totalDividends.add(dividendAmount); 
436 
437         if (_totalStaked > 0) _dividendsPerRug = _dividendsPerRug.add(dividendAmount.mul(1e18).div(_totalStaked)); // prevents division by 0
438      
439         if (firstTime) _dividendsSnapshot[msg.sender] = _dividendsPerRug; // For first time stakers
440 
441         _updateDividends(); // If you're restaking, reset snapshot back to _dividendsPerRug, reward previous staking.
442 
443         _totalStaked = _totalStaked.add(amountToStake);
444         _stakeAmount[msg.sender] = _stakeAmount[msg.sender].add(amountToStake);
445      
446         emit Stake(msg.sender, amountToStake, operateAmount);
447     }
448 
449     function withdraw(uint256 amount) public { 
450         _totalStaked = _totalStaked.sub(amount);
451         _stakeAmount[msg.sender] = _stakeAmount[msg.sender].sub(amount);
452         rugStake.safeTransfer(msg.sender, amount);
453     }
454 }
455 
456 contract PyramidPool is LPTokenWrapper, IRewardDistributionRecipient, TokenRecover {
457 
458     constructor() public {
459         rewardDistribution = msg.sender;
460     }
461 
462     IERC20 public rugReward;
463     uint256 public DURATION = 1641600; // 19 days
464 
465     uint256 public starttime = 0; 
466     uint256 public periodFinish = 0;
467     uint256 public rewardRate = 0;
468     uint256 public lastUpdateTime;
469     uint256 public rewardPerTokenStored;
470     mapping(address => uint256) public userRewardPerTokenPaid;
471     mapping(address => uint256) public rewards;
472 
473     event RewardAdded(uint256 reward);
474     event Staked(address indexed user, uint256 amount);
475     event Withdrawn(address indexed user, uint256 amount);
476     event RewardPaid(address indexed user, uint256 reward);
477     event SetRewardToken(address rewardAddress);
478     event SetStakeToken(address stakeAddress);
479     event SetStartTime(uint256 unixtime);
480     event SetDuration(uint256 duration);
481 
482     modifier checkStart() {
483         require(block.timestamp >= starttime,"Rewards haven't started yet!");
484         _;
485     }
486 
487     modifier updateReward(address account) {
488         rewardPerTokenStored = rewardPerToken();
489         lastUpdateTime = lastTimeRewardApplicable();
490         if (account != address(0)) {
491             rewards[account] = earned(account);
492             userRewardPerTokenPaid[account] = rewardPerTokenStored;
493         }
494         _;
495     }
496 
497     function lastTimeRewardApplicable() public view returns (uint256) {
498         return Math.min(block.timestamp, periodFinish);
499     }
500 
501     function rewardPerToken() public view returns (uint256) {
502         if (totalStaked() == 0) {
503             return rewardPerTokenStored;
504         }
505         return
506             rewardPerTokenStored.add(
507                 lastTimeRewardApplicable()
508                     .sub(lastUpdateTime)
509                     .mul(rewardRate)
510                     .mul(1e18)
511                     .div(totalStaked())
512             );
513     }
514 
515     function earned(address account) public view returns (uint256) {
516         return
517             balanceOf(account)
518                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
519                 .div(1e18)
520                 .add(rewards[account]);
521     }
522 
523     // stake visibility is public as overriding LPTokenWrapper's stake() function
524     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
525         require(amount > 0, "Cannot stake 0");
526         super.stake(amount);
527     }
528 
529     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
530         require(amount > 0, "Cannot withdraw 0");
531         super.withdraw(amount);
532         emit Withdrawn(msg.sender, amount);
533     }
534 
535     function exit() external {  
536         withdrawDividends();
537         getReward();
538         withdraw(balanceOf(msg.sender));
539     }
540 
541     function collectRewardsOnly() public {
542         withdrawDividends();
543         getReward();        
544     }
545 
546     function getReward() public updateReward(msg.sender) checkStart {
547         uint256 reward = earned(msg.sender);
548         if (reward > 0) {
549             rewards[msg.sender] = 0;
550             rugReward.safeTransfer(msg.sender, reward);
551             emit RewardPaid(msg.sender, reward);
552         }
553     }
554 
555     function notifyRewardAmount(uint256 reward)
556         external
557         onlyRewardDistribution
558         updateReward(address(0))
559     {
560         if (block.timestamp > starttime) {
561           if (block.timestamp >= periodFinish) {
562               rewardRate = reward.div(DURATION);
563           } else {
564               uint256 remaining = periodFinish.sub(block.timestamp);
565               uint256 leftover = remaining.mul(rewardRate);
566               rewardRate = reward.add(leftover).div(DURATION);
567           }
568           lastUpdateTime = block.timestamp;
569           periodFinish = block.timestamp.add(DURATION);
570           emit RewardAdded(reward);
571         } else {
572           rewardRate = reward.div(DURATION);
573           lastUpdateTime = starttime;
574           periodFinish = starttime.add(DURATION);
575           emit RewardAdded(reward);
576         }
577     }
578 
579     function setRewardAddress(address rewardAddress) public onlyOwner {
580         rugReward = IERC20(rewardAddress);
581         emit SetRewardToken(rewardAddress);
582     } 
583 
584     function setStakeAddress(address stakeAddress) public onlyOwner {
585         rugStake = IERC20(stakeAddress);
586         emit SetStakeToken(stakeAddress);
587     }
588 
589     function setStartTime(uint256 unixtime) public onlyOwner {
590         starttime = unixtime;
591         emit SetStartTime(unixtime);
592     }
593 
594     function setDuration(uint256 duration) public onlyOwner {
595         DURATION = duration;
596         emit SetDuration(duration);
597     }
598 
599 }