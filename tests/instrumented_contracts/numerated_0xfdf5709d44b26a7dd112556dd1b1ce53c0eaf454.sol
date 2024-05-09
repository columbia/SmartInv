1 pragma solidity ^0.6.6;
2 // SPDX-License-Identifier: MIT
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  * 
9  * @dev We've added a second owner to share control of the timelocked owner contract.
10  */
11 contract Ownable {
12     address private _owner;
13     address private _pendingOwner;
14     
15     // Second allows a DAO to share control.
16     address private _secondOwner;
17     address private _pendingSecond;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20     event SecondOwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     /**
23      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24      * account.
25      */
26     function initializeOwnable() internal {
27         require(_owner == address(0), "already initialized");
28         _owner = msg.sender;
29         _secondOwner = msg.sender;
30         emit OwnershipTransferred(address(0), msg.sender);
31         emit SecondOwnershipTransferred(address(0), msg.sender);
32     }
33 
34 
35     /**
36      * @return the address of the owner.
37      */
38     function owner() public view returns (address) {
39         return _owner;
40     }
41 
42     /**
43      * @return the address of the owner.
44      */
45     function secondOwner() public view returns (address) {
46         return _secondOwner;
47     }
48 
49     /**
50      * @dev Throws if called by any account other than the owner.
51      */
52     modifier onlyOwner() {
53         require(isOwner(), "msg.sender is not owner");
54         _;
55     }
56     
57     modifier onlyFirstOwner() {
58         require(msg.sender == _owner, "msg.sender is not owner");
59         _;
60     }
61     
62     modifier onlySecondOwner() {
63         require(msg.sender == _secondOwner, "msg.sender is not owner");
64         _;
65     }
66 
67     /**
68      * @return true if `msg.sender` is the owner of the contract.
69      */
70     function isOwner() public view returns (bool) {
71         return msg.sender == _owner || msg.sender == _secondOwner;
72 
73     }
74 
75     /**
76      * @dev Allows the current owner to transfer control of the contract to a newOwner.
77      * @param newOwner The address to transfer ownership to.
78      */
79     function transferOwnership(address newOwner) public onlyFirstOwner {
80         _pendingOwner = newOwner;
81     }
82 
83     function receiveOwnership() public {
84         require(msg.sender == _pendingOwner, "only pending owner can call this function");
85         _transferOwnership(_pendingOwner);
86         _pendingOwner = address(0);
87     }
88 
89     /**
90      * @dev Transfers control of the contract to a newOwner.
91      * @param newOwner The address to transfer ownership to.
92      */
93     function _transferOwnership(address newOwner) internal {
94         require(newOwner != address(0));
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 
99     /**
100      * @dev Allows the current owner to transfer control of the contract to a newOwner.
101      * @param newOwner The address to transfer ownership to.
102      */
103     function transferSecondOwnership(address newOwner) public onlySecondOwner {
104         _pendingSecond = newOwner;
105     }
106 
107     function receiveSecondOwnership() public {
108         require(msg.sender == _pendingSecond, "only pending owner can call this function");
109         _transferSecondOwnership(_pendingSecond);
110         _pendingSecond = address(0);
111     }
112 
113     /**
114      * @dev Transfers control of the contract to a newOwner.
115      * @param newOwner The address to transfer ownership to.
116      */
117     function _transferSecondOwnership(address newOwner) internal {
118         require(newOwner != address(0));
119         emit SecondOwnershipTransferred(_secondOwner, newOwner);
120         _secondOwner = newOwner;
121     }
122 
123     uint256[50] private __gap;
124 }
125 
126 /**
127  * @dev Interface of the ERC20 standard as defined in the EIP.
128  */
129 interface IERC20 {
130     /**
131      * @dev Returns the amount of tokens in existence.
132      */
133     function totalSupply() external view returns (uint256);
134 
135     /**
136      * @dev Returns the amount of tokens owned by `account`.
137      */
138     function balanceOf(address account) external view returns (uint256);
139 
140     /**
141      * @dev Moves `amount` tokens from the caller's account to `recipient`.
142      *
143      * Returns a boolean value indicating whether the operation succeeded.
144      *
145      * Emits a {Transfer} event.
146      */
147     function transfer(address recipient, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Returns the remaining number of tokens that `spender` will be
151      * allowed to spend on behalf of `owner` through {transferFrom}. This is
152      * zero by default.
153      *
154      * This value changes when {approve} or {transferFrom} are called.
155      */
156     function allowance(address owner, address spender) external view returns (uint256);
157 
158     /**
159      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
160      *
161      * Returns a boolean value indicating whether the operation succeeded.
162      *
163      * IMPORTANT: Beware that changing an allowance with this method brings the risk
164      * that someone may use both the old and the new allowance by unfortunate
165      * transaction ordering. One possible solution to mitigate this race
166      * condition is to first reduce the spender's allowance to 0 and set the
167      * desired value afterwards:
168      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
169      *
170      * Emits an {Approval} event.
171      */
172     function approve(address spender, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Moves `amount` tokens from `sender` to `recipient` using the
176      * allowance mechanism. `amount` is then deducted from the caller's
177      * allowance.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
184 
185     /**
186      * @dev Emitted when `value` tokens are moved from one account (`from`) to
187      * another (`to`).
188      *
189      * Note that `value` may be zero.
190      */
191     event Transfer(address indexed from, address indexed to, uint256 value);
192 
193     /**
194      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
195      * a call to {approve}. `value` is the new allowance.
196      */
197     event Approval(address indexed owner, address indexed spender, uint256 value);
198 }
199 
200 interface IRewardDistributionRecipientTokenOnly {
201     function rewardToken() external view returns(IERC20);
202     function notifyRewardAmount(uint256 reward) external;
203     function setRewardDistribution(address rewardDistribution) external;
204 }
205 
206 /**
207  * @dev Collection of functions related to the address type
208  */
209 library Address {
210     /**
211      * @dev Returns true if `account` is a contract.
212      *
213      * This test is non-exhaustive, and there may be false-negatives: during the
214      * execution of a contract's constructor, its address will be reported as
215      * not containing a contract.
216      *
217      * IMPORTANT: It is unsafe to assume that an address for which this
218      * function returns false is an externally-owned account (EOA) and not a
219      * contract.
220      */
221     function isContract(address account) internal view returns (bool) {
222         // This method relies in extcodesize, which returns 0 for contracts in
223         // construction, since the code is only stored at the end of the
224         // constructor execution.
225 
226         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
227         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
228         // for accounts without code, i.e. `keccak256('')`
229         bytes32 codehash;
230         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
231         // solhint-disable-next-line no-inline-assembly
232         assembly { codehash := extcodehash(account) }
233         return (codehash != 0x0 && codehash != accountHash);
234     }
235 
236     /**
237      * @dev Converts an `address` into `address payable`. Note that this is
238      * simply a type cast: the actual underlying value is not changed.
239      *
240      * _Available since v2.4.0._
241      */
242     function toPayable(address account) internal pure returns (address payable) {
243         return address(uint160(account));
244     }
245 
246     /**
247      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
248      * `recipient`, forwarding all available gas and reverting on errors.
249      *
250      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
251      * of certain opcodes, possibly making contracts go over the 2300 gas limit
252      * imposed by `transfer`, making them unable to receive funds via
253      * `transfer`. {sendValue} removes this limitation.
254      *
255      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
256      *
257      * IMPORTANT: because control is transferred to `recipient`, care must be
258      * taken to not create reentrancy vulnerabilities. Consider using
259      * {ReentrancyGuard} or the
260      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
261      *
262      * _Available since v2.4.0._
263      */
264     function sendValue(address payable recipient, uint256 amount) internal {
265         require(address(this).balance >= amount, "Address: insufficient balance");
266 
267         // solhint-disable-next-line avoid-call-value
268         (bool success, ) = recipient.call{value: amount}("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 }
272 
273 
274 /**
275  * @title SafeMath
276  * @dev Unsigned math operations with safety checks that revert on error
277  * 
278  * @dev Default OpenZeppelin
279  */
280 library SafeMath {
281     /**
282      * @dev Multiplies two unsigned integers, reverts on overflow.
283      */
284     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
285         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
286         // benefit is lost if 'b' is also tested.
287         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
288         if (a == 0) {
289             return 0;
290         }
291 
292         uint256 c = a * b;
293         require(c / a == b);
294 
295         return c;
296     }
297 
298     /**
299      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
300      */
301     function div(uint256 a, uint256 b) internal pure returns (uint256) {
302         // Solidity only automatically asserts when dividing by 0
303         require(b > 0);
304         uint256 c = a / b;
305         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
306 
307         return c;
308     }
309 
310     /**
311      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
312      */
313     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
314         require(b <= a);
315         uint256 c = a - b;
316 
317         return c;
318     }
319 
320     /**
321      * @dev Adds two unsigned integers, reverts on overflow.
322      */
323     function add(uint256 a, uint256 b) internal pure returns (uint256) {
324         uint256 c = a + b;
325         require(c >= a);
326 
327         return c;
328     }
329 
330     /**
331      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
332      * reverts when dividing by zero.
333      */
334     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
335         require(b != 0);
336         return a % b;
337     }
338 }
339 
340 
341 /**
342  * @title SafeERC20
343  * @dev Wrappers around ERC20 operations that throw on failure (when the token
344  * contract returns false). Tokens that return no value (and instead revert or
345  * throw on failure) are also supported, non-reverting calls are assumed to be
346  * successful.
347  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
348  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
349  */
350 library SafeERC20 {
351     using SafeMath for uint256;
352     using Address for address;
353 
354     function safeTransfer(IERC20 token, address to, uint256 value) internal {
355         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
356     }
357 
358     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
359         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
360     }
361 
362     function safeApprove(IERC20 token, address spender, uint256 value) internal {
363         // safeApprove should only be called when setting an initial allowance,
364         // or when resetting it to zero. To increase and decrease it, use
365         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
366         // solhint-disable-next-line max-line-length
367         require((value == 0) || (token.allowance(address(this), spender) == 0),
368             "SafeERC20: approve from non-zero to non-zero allowance"
369         );
370         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
371     }
372 
373     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
374         uint256 newAllowance = token.allowance(address(this), spender).add(value);
375         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
376     }
377 
378     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
379         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
380         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
381     }
382 
383     /**
384      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
385      * on the return value: the return value is optional (but if data is returned, it must not be false).
386      * @param token The token targeted by the call.
387      * @param data The call data (encoded using abi.encode or one of its variants).
388      */
389     function callOptionalReturn(IERC20 token, bytes memory data) private {
390         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
391         // we're implementing it ourselves.
392 
393         // A Solidity high level call has three parts:
394         //  1. The target address is checked to verify it contains contract code
395         //  2. The call itself is made, and success asserted
396         //  3. The return value is decoded, which in turn checks the size of the returned data.
397         // solhint-disable-next-line max-line-length
398         require(address(token).isContract(), "SafeERC20: call to non-contract");
399 
400         // solhint-disable-next-line avoid-low-level-calls
401         (bool success, bytes memory returndata) = address(token).call(data);
402         require(success, "SafeERC20: low-level call failed");
403 
404         if (returndata.length > 0) { // Return data is optional
405             // solhint-disable-next-line max-line-length
406             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
407         }
408     }
409 }
410 
411 contract FarmController is Ownable {
412     using SafeMath for uint256;
413     using SafeERC20 for IERC20;
414 
415     IRewardDistributionRecipientTokenOnly[] public farms;
416     mapping(address => address) public lpFarm;
417     mapping(address => uint256) public rate;
418     uint256 public weightSum;
419     IERC20 public rewardToken;
420 
421     mapping(address => bool) public blackListed;
422 
423     function initialize(address token) external {
424         Ownable.initializeOwnable();
425         rewardToken = IERC20(token);
426     }
427 
428     function addFarm(address _lptoken) external onlyOwner returns(address farm){
429         require(lpFarm[_lptoken] == address(0), "farm exists.");
430         bytes memory bytecode = type(LPFarm).creationCode;
431         bytes32 salt = keccak256(abi.encodePacked(_lptoken));
432         assembly {
433             farm := create2(0, add(bytecode, 32), mload(bytecode), salt)
434         }
435         LPFarm(farm).initialize(_lptoken, address(this));
436         farms.push(IRewardDistributionRecipientTokenOnly(farm));
437         rewardToken.approve(farm, uint256(-1));
438         lpFarm[_lptoken] = farm;
439         // it will just set the rates to zero before it get's it's own rate
440     }
441 
442     function setRates(uint256[] memory _rates) external onlyOwner {
443         require(_rates.length == farms.length);
444         uint256 sum = 0;
445         for(uint256 i = 0; i<_rates.length; i++){
446             sum += _rates[i];
447             rate[address(farms[i])] = _rates[i];
448         }
449         weightSum = sum;
450     }
451 
452     function setRateOf(address _farm, uint256 _rate) external onlyOwner {
453         weightSum -= rate[_farm];
454         weightSum += _rate;
455         rate[_farm] = _rate;
456     }
457 
458     function notifyRewards(uint256 amount) external onlyOwner {
459         rewardToken.transferFrom(msg.sender, address(this), amount);
460         for(uint256 i = 0; i<farms.length; i++){
461             IRewardDistributionRecipientTokenOnly farm = farms[i];
462             farm.notifyRewardAmount(amount.mul(rate[address(farm)]).div(weightSum));
463         }
464     }
465 
466     // should transfer rewardToken prior to calling this contract
467     // this is implemented to take care of the out-of-gas situation
468     function notifyRewardsPartial(uint256 amount, uint256 from, uint256 to) external onlyOwner {
469         require(from < to, "from should be smaller than to");
470         require(to <= farms.length, "to should be smaller or equal to farms.length");
471         for(uint256 i = from; i < to; i++){
472             IRewardDistributionRecipientTokenOnly farm = farms[i];
473             farm.notifyRewardAmount(amount.mul(rate[address(farm)]).div(weightSum));
474         }
475     }
476 
477     function blockUser(address target) external onlyOwner {
478         blackListed[target] = true;
479     }
480 
481     function unblockUser(address target) external onlyOwner {
482         blackListed[target] = false;
483     }
484 }
485 
486 
487 contract TokenWrapper {
488     using SafeMath for uint256;
489     using SafeERC20 for IERC20;
490 
491     IERC20 public stakeToken;
492 
493     uint256 private _totalSupply;
494     mapping(address => uint256) private _balances;
495 
496     function totalSupply() public view returns (uint256) {
497         return _totalSupply;
498     }
499 
500     function balanceOf(address account) public view returns (uint256) {
501         return _balances[account];
502     }
503 
504     function stake(uint256 amount) public virtual {
505         _totalSupply = _totalSupply.add(amount);
506         _balances[msg.sender] = _balances[msg.sender].add(amount);
507         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
508     }
509 
510     function withdraw(uint256 amount) public virtual {
511         _totalSupply = _totalSupply.sub(amount);
512         _balances[msg.sender] = _balances[msg.sender].sub(amount);
513         stakeToken.safeTransfer(msg.sender, amount);
514     }
515 }
516 
517 /**
518  * @dev Standard math utilities missing in the Solidity language.
519  */
520 library Math {
521     /**
522      * @dev Returns the largest of two numbers.
523      */
524     function max(uint256 a, uint256 b) internal pure returns (uint256) {
525         return a >= b ? a : b;
526     }
527 
528     /**
529      * @dev Returns the smallest of two numbers.
530      */
531     function min(uint256 a, uint256 b) internal pure returns (uint256) {
532         return a < b ? a : b;
533     }
534 
535     /**
536      * @dev Returns the average of two numbers. The result is rounded towards
537      * zero.
538      */
539     function average(uint256 a, uint256 b) internal pure returns (uint256) {
540         // (a + b) / 2 can overflow, so we distribute
541         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
542     }
543 }
544 
545 /**
546 * MIT License
547 * ===========
548 *
549 * Copyright (c) 2020 Synthetix
550 *
551 * Permission is hereby granted, free of charge, to any person obtaining a copy
552 * of this software and associated documentation files (the "Software"), to deal
553 * in the Software without restriction, including without limitation the rights
554 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
555 * copies of the Software, and to permit persons to whom the Software is
556 * furnished to do so, subject to the following conditions:
557 *
558 * The above copyright notice and this permission notice shall be included in all
559 * copies or substantial portions of the Software.
560 *
561 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
562 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
563 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
564 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
565 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
566 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
567 */
568 
569 contract LPFarm is TokenWrapper, IRewardDistributionRecipientTokenOnly {
570     IERC20 public override rewardToken;
571     address public rewardDistribution;
572     FarmController public controller;
573     uint256 public constant DURATION = 7 days;
574 
575     uint256 public periodFinish = 0;
576     uint256 public rewardRate = 0;
577     uint256 public lastUpdateTime;
578     uint256 public rewardPerTokenStored;
579     mapping(address => uint256) public userRewardPerTokenPaid;
580     mapping(address => uint256) public rewards;
581 
582     event RewardAdded(uint256 reward);
583     event Staked(address indexed user, uint256 amount);
584     event Withdrawn(address indexed user, uint256 amount);
585     event RewardPaid(address indexed user, uint256 reward);
586 
587     modifier updateReward(address account) {
588         rewardPerTokenStored = rewardPerToken();
589         lastUpdateTime = lastTimeRewardApplicable();
590         if (account != address(0)) {
591             rewards[account] = earned(account);
592             userRewardPerTokenPaid[account] = rewardPerTokenStored;
593         }
594         _;
595     }
596 
597     modifier onlyController() {
598         require(msg.sender == address(controller), "Caller is not controller");
599         _;
600     }
601 
602     modifier onlyOwner() {
603         require(msg.sender == Ownable(address(controller)).owner(), "Caller is not owner");
604         _;
605     }
606 
607     modifier checkBlackList(address user) {
608         require(!controller.blackListed(user), "User is blacklisted");
609         _;
610     }
611 
612     function initialize(address _stakeToken, address _controller)
613       external
614     {
615         require(address(stakeToken) == address(0), "already initialized");
616         stakeToken = IERC20(_stakeToken);
617         controller = FarmController(_controller);
618         rewardToken = controller.rewardToken();
619     }
620 
621     function setRewardDistribution(address _rewardDistribution)
622         external
623         override
624         onlyOwner
625     {
626     }
627 
628 
629     function lastTimeRewardApplicable() public view returns (uint256) {
630         return Math.min(block.timestamp, periodFinish);
631     }
632 
633     function rewardPerToken() public view returns (uint256) {
634         if (totalSupply() == 0) {
635             return rewardPerTokenStored;
636         }
637         return
638             rewardPerTokenStored.add(
639                 lastTimeRewardApplicable()
640                     .sub(lastUpdateTime)
641                     .mul(rewardRate)
642                     .mul(1e18)
643                     .div(totalSupply())
644             );
645     }
646 
647     function earned(address account) public view returns (uint256) {
648         return
649             balanceOf(account)
650                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
651                 .div(1e18)
652                 .add(rewards[account]);
653     }
654 
655     // stake visibility is public as overriding LPTokenWrapper's stake() function
656     function stake(uint256 amount) public override checkBlackList(msg.sender) updateReward(msg.sender) {
657         require(amount > 0, "Cannot stake 0");
658         super.stake(amount);
659         emit Staked(msg.sender, amount);
660     }
661 
662     function withdraw(uint256 amount) public override checkBlackList(msg.sender) updateReward(msg.sender) {
663         require(amount > 0, "Cannot withdraw 0");
664         super.withdraw(amount);
665         emit Withdrawn(msg.sender, amount);
666     }
667 
668     function exit() external {
669         withdraw(balanceOf(msg.sender));
670         getReward();
671     }
672 
673     function getReward() public checkBlackList(msg.sender) updateReward(msg.sender) {
674         uint256 reward = earned(msg.sender);
675         if (reward > 0) {
676             rewards[msg.sender] = 0;
677             rewardToken.safeTransfer(msg.sender, reward);
678             emit RewardPaid(msg.sender, reward);
679         }
680     }
681 
682     function notifyRewardAmount(uint256 reward)
683         external
684         override
685         onlyController
686         updateReward(address(0))
687     {
688         rewardToken.safeTransferFrom(msg.sender, address(this), reward);
689         if (block.timestamp >= periodFinish) {
690             rewardRate = reward.div(DURATION);
691         } else {
692             uint256 remaining = periodFinish.sub(block.timestamp);
693             uint256 leftover = remaining.mul(rewardRate);
694             rewardRate = reward.add(leftover).div(DURATION);
695         }
696         lastUpdateTime = block.timestamp;
697         periodFinish = block.timestamp.add(DURATION);
698         emit RewardAdded(reward);
699     }
700 }