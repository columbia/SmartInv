1 //   _    _ _   _                __ _                            
2 //  | |  (_) | | |              / _(_)                           
3 //  | | ___| |_| |_ ___ _ __   | |_ _ _ __   __ _ _ __   ___ ___ 
4 //  | |/ / | __| __/ _ \ '_ \  |  _| | '_ \ / _` | '_ \ / __/ _ \
5 //  |   <| | |_| ||  __/ | | |_| | | | | | | (_| | | | | (_|  __/
6 //  |_|\_\_|\__|\__\___|_| |_(_)_| |_|_| |_|\__,_|_| |_|\___\___|
7 /*
8    ____            __   __        __   _
9   / __/__ __ ___  / /_ / /  ___  / /_ (_)__ __
10  _\ \ / // // _ \/ __// _ \/ -_)/ __// / \ \ /
11 /___/ \_, //_//_/\__//_//_/\__/ \__//_/ /_\_\
12      /___/
13 
14 * Synthetix: YFIRewards.sol
15 *
16 * Docs: https://docs.synthetix.io/
17 *
18 *
19 * MIT License
20 * ===========
21 *
22 * Copyright (c) 2020 Synthetix
23 *
24 * Permission is hereby granted, free of charge, to any person obtaining a copy
25 * of this software and associated documentation files (the "Software"), to deal
26 * in the Software without restriction, including without limitation the rights
27 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
28 * copies of the Software, and to permit persons to whom the Software is
29 * furnished to do so, subject to the following conditions:
30 *
31 * The above copyright notice and this permission notice shall be included in all
32 * copies or substantial portions of the Software.
33 *
34 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
35 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
36 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
37 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
38 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
39 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
40 */
41 
42 // File: @openzeppelin/contracts/math/Math.sol
43 
44 pragma solidity ^0.5.0;
45 
46 /**
47  * @dev Standard math utilities missing in the Solidity language.
48  */
49 library Math {
50     function max(uint256 a, uint256 b) internal pure returns (uint256) {
51         return a >= b ? a : b;
52     }
53     function min(uint256 a, uint256 b) internal pure returns (uint256) {
54         return a < b ? a : b;
55     }
56 }
57 
58 // File: @openzeppelin/contracts/math/SafeMath.sol
59 
60 pragma solidity ^0.5.0;
61 
62 library SafeMath {
63     function add(uint256 a, uint256 b) internal pure returns (uint256) {
64         uint256 c = a + b;
65         require(c >= a, "SafeMath: addition overflow");
66 
67         return c;
68     }
69 
70     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
71         return sub(a, b, "SafeMath: subtraction overflow");
72     }
73 
74     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b <= a, errorMessage);
76         uint256 c = a - b;
77 
78         return c;
79     }
80 
81     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
82         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
83         // benefit is lost if 'b' is also tested.
84         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
85         if (a == 0) {
86             return 0;
87         }
88 
89         uint256 c = a * b;
90         require(c / a == b, "SafeMath: multiplication overflow");
91 
92         return c;
93     }
94 
95     function div(uint256 a, uint256 b) internal pure returns (uint256) {
96         return div(a, b, "SafeMath: division by zero");
97     }
98 
99     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
100         // Solidity only automatically asserts when dividing by 0
101         require(b > 0, errorMessage);
102         uint256 c = a / b;
103         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
104 
105         return c;
106     }
107 
108     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
109         return mod(a, b, "SafeMath: modulo by zero");
110     }
111 
112     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         require(b != 0, errorMessage);
114         return a % b;
115     }
116 }
117 
118 // File: @openzeppelin/contracts/GSN/Context.sol
119 
120 pragma solidity ^0.5.0;
121 
122 /*
123  * @dev Provides information about the current execution context, including the
124  * sender of the transaction and its data. While these are generally available
125  * via msg.sender and msg.data, they should not be accessed in such a direct
126  * manner, since when dealing with GSN meta-transactions the account sending and
127  * paying for execution may not be the actual sender (as far as an application
128  * is concerned).
129  *
130  * This contract is only required for intermediate, library-like contracts.
131  */
132 contract Context {
133     // Empty internal constructor, to prevent people from mistakenly deploying
134     // an instance of this contract, which should be used via inheritance.
135     constructor () internal { }
136     // solhint-disable-previous-line no-empty-blocks
137 
138     function _msgSender() internal view returns (address payable) {
139         return msg.sender;
140     }
141 
142     function _msgData() internal view returns (bytes memory) {
143         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
144         return msg.data;
145     }
146 }
147 
148 // File: @openzeppelin/contracts/ownership/Ownable.sol
149 
150 pragma solidity ^0.5.0;
151 
152 /**
153  * @dev Contract module which provides a basic access control mechanism, where
154  * there is an account (an owner) that can be granted exclusive access to
155  * specific functions.
156  *
157  * This module is used through inheritance. It will make available the modifier
158  * `onlyOwner`, which can be applied to your functions to restrict their use to
159  * the owner.
160  */
161 contract Ownable is Context {
162     address private _owner;
163 
164     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
165 
166     /**
167      * @dev Initializes the contract setting the deployer as the initial owner.
168      */
169     constructor () internal {
170         _owner = _msgSender();
171         emit OwnershipTransferred(address(0), _owner);
172     }
173 
174     /**
175      * @dev Returns the address of the current owner.
176      */
177     function owner() public view returns (address) {
178         return _owner;
179     }
180 
181     /**
182      * @dev Throws if called by any account other than the owner.
183      */
184     modifier onlyOwner() {
185         require(isOwner(), "Ownable: caller is not the owner");
186         _;
187     }
188 
189     /**
190      * @dev Returns true if the caller is the current owner.
191      */
192     function isOwner() public view returns (bool) {
193         return _msgSender() == _owner;
194     }
195 
196     /**
197      * @dev Leaves the contract without owner. It will not be possible to call
198      * `onlyOwner` functions anymore. Can only be called by the current owner.
199      *
200      * NOTE: Renouncing ownership will leave the contract without an owner,
201      * thereby removing any functionality that is only available to the owner.
202      */
203     function renounceOwnership() public onlyOwner {
204         emit OwnershipTransferred(_owner, address(0));
205         _owner = address(0);
206     }
207 
208     /**
209      * @dev Transfers ownership of the contract to a new account (`newOwner`).
210      * Can only be called by the current owner.
211      */
212     function transferOwnership(address newOwner) public onlyOwner {
213         _transferOwnership(newOwner);
214     }
215 
216     /**
217      * @dev Transfers ownership of the contract to a new account (`newOwner`).
218      */
219     function _transferOwnership(address newOwner) internal {
220         require(newOwner != address(0), "Ownable: new owner is the zero address");
221         emit OwnershipTransferred(_owner, newOwner);
222         _owner = newOwner;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
227 
228 pragma solidity ^0.5.0;
229 
230 /**
231  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
232  * the optional functions; to access them see {ERC20Detailed}.
233  */
234 interface IERC20 {
235     /**
236      * @dev Returns the amount of tokens in existence.
237      */
238     function totalSupply() external view returns (uint256);
239 
240     /**
241      * @dev Returns the amount of tokens owned by `account`.
242      */
243     function balanceOf(address account) external view returns (uint256);
244 
245     /**
246      * @dev Moves `amount` tokens from the caller's account to `recipient`.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transfer(address recipient, uint256 amount) external returns (bool);
253     function mint(address account, uint amount) external;
254 
255     /**
256      * @dev Returns the remaining number of tokens that `spender` will be
257      * allowed to spend on behalf of `owner` through {transferFrom}. This is
258      * zero by default.
259      *
260      * This value changes when {approve} or {transferFrom} are called.
261      */
262     function allowance(address owner, address spender) external view returns (uint256);
263 
264     /**
265      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
266      *
267      * Returns a boolean value indicating whether the operation succeeded.
268      *
269      * IMPORTANT: Beware that changing an allowance with this method brings the risk
270      * that someone may use both the old and the new allowance by unfortunate
271      * transaction ordering. One possible solution to mitigate this race
272      * condition is to first reduce the spender's allowance to 0 and set the
273      * desired value afterwards:
274      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
275      *
276      * Emits an {Approval} event.
277      */
278     function approve(address spender, uint256 amount) external returns (bool);
279 
280     /**
281      * @dev Moves `amount` tokens from `sender` to `recipient` using the
282      * allowance mechanism. `amount` is then deducted from the caller's
283      * allowance.
284      *
285      * Returns a boolean value indicating whether the operation succeeded.
286      *
287      * Emits a {Transfer} event.
288      */
289     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
290 
291     /**
292      * @dev Emitted when `value` tokens are moved from one account (`from`) to
293      * another (`to`).
294      *
295      * Note that `value` may be zero.
296      */
297     event Transfer(address indexed from, address indexed to, uint256 value);
298 
299     /**
300      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
301      * a call to {approve}. `value` is the new allowance.
302      */
303     event Approval(address indexed owner, address indexed spender, uint256 value);
304 }
305 
306 // File: @openzeppelin/contracts/utils/Address.sol
307 
308 pragma solidity ^0.5.5;
309 
310 /**
311  * @dev Collection of functions related to the address type
312  */
313 library Address {
314     /**
315      * @dev Returns true if `account` is a contract.
316      *
317      * This test is non-exhaustive, and there may be false-negatives: during the
318      * execution of a contract's constructor, its address will be reported as
319      * not containing a contract.
320      *
321      * IMPORTANT: It is unsafe to assume that an address for which this
322      * function returns false is an externally-owned account (EOA) and not a
323      * contract.
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies in extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
331         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
332         // for accounts without code, i.e. `keccak256('')`
333         bytes32 codehash;
334         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
335         // solhint-disable-next-line no-inline-assembly
336         assembly { codehash := extcodehash(account) }
337         return (codehash != 0x0 && codehash != accountHash);
338     }
339 
340     /**
341      * @dev Converts an `address` into `address payable`. Note that this is
342      * simply a type cast: the actual underlying value is not changed.
343      *
344      * _Available since v2.4.0._
345      */
346     function toPayable(address account) internal pure returns (address payable) {
347         return address(uint160(account));
348     }
349 
350     /**
351      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
352      * `recipient`, forwarding all available gas and reverting on errors.
353      *
354      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
355      * of certain opcodes, possibly making contracts go over the 2300 gas limit
356      * imposed by `transfer`, making them unable to receive funds via
357      * `transfer`. {sendValue} removes this limitation.
358      *
359      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
360      *
361      * IMPORTANT: because control is transferred to `recipient`, care must be
362      * taken to not create reentrancy vulnerabilities. Consider using
363      * {ReentrancyGuard} or the
364      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
365      *
366      * _Available since v2.4.0._
367      */
368     function sendValue(address payable recipient, uint256 amount) internal {
369         require(address(this).balance >= amount, "Address: insufficient balance");
370 
371         // solhint-disable-next-line avoid-call-value
372         (bool success, ) = recipient.call.value(amount)("");
373         require(success, "Address: unable to send value, recipient may have reverted");
374     }
375 }
376 
377 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
378 
379 pragma solidity ^0.5.0;
380 
381 /**
382  * @title SafeERC20
383  * @dev Wrappers around ERC20 operations that throw on failure (when the token
384  * contract returns false). Tokens that return no value (and instead revert or
385  * throw on failure) are also supported, non-reverting calls are assumed to be
386  * successful.
387  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
388  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
389  */
390 library SafeERC20 {
391     using SafeMath for uint256;
392     using Address for address;
393 
394     function safeTransfer(IERC20 token, address to, uint256 value) internal {
395         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
396     }
397 
398     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
399         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
400     }
401 
402     function safeApprove(IERC20 token, address spender, uint256 value) internal {
403         // safeApprove should only be called when setting an initial allowance,
404         // or when resetting it to zero. To increase and decrease it, use
405         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
406         // solhint-disable-next-line max-line-length
407         require((value == 0) || (token.allowance(address(this), spender) == 0),
408             "SafeERC20: approve from non-zero to non-zero allowance"
409         );
410         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
411     }
412 
413     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
414         uint256 newAllowance = token.allowance(address(this), spender).add(value);
415         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
416     }
417 
418     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
419         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
420         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
421     }
422 
423     /**
424      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
425      * on the return value: the return value is optional (but if data is returned, it must not be false).
426      * @param token The token targeted by the call.
427      * @param data The call data (encoded using abi.encode or one of its variants).
428      */
429     function callOptionalReturn(IERC20 token, bytes memory data) private {
430         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
431         // we're implementing it ourselves.
432 
433         // A Solidity high level call has three parts:
434         //  1. The target address is checked to verify it contains contract code
435         //  2. The call itself is made, and success asserted
436         //  3. The return value is decoded, which in turn checks the size of the returned data.
437         // solhint-disable-next-line max-line-length
438         require(address(token).isContract(), "SafeERC20: call to non-contract");
439 
440         // solhint-disable-next-line avoid-low-level-calls
441         (bool success, bytes memory returndata) = address(token).call(data);
442         require(success, "SafeERC20: low-level call failed");
443 
444         if (returndata.length > 0) { // Return data is optional
445             // solhint-disable-next-line max-line-length
446             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
447         }
448     }
449 }
450 
451 // File: contracts/CurveRewards.sol
452 
453 pragma solidity ^0.5.0;
454 
455 contract LPTokenWrapper {
456     using SafeMath for uint256;
457     using SafeERC20 for IERC20;
458     using Address for address;
459 
460     IERC20 public LP_TOKEN = IERC20(0x177BA0cac51bFC7eA24BAd39d81dcEFd59d74fAa); // EDIT_ME: Stake LP token
461 
462     uint256 private _totalSupply;
463     mapping(address => uint256) private _balances;
464 
465     function totalSupply() public view returns (uint256) {
466         return _totalSupply;
467     }
468 
469     function balanceOf(address account) public view returns (uint256) {
470         return _balances[account];
471     }
472 
473     function stake(uint256 amount) public {
474         address sender = msg.sender;
475         require(!address(sender).isContract(), "plz farm by hand");
476         require(tx.origin == sender, "plz farm by hand");
477         _totalSupply = _totalSupply.add(amount);
478         _balances[sender] = _balances[sender].add(amount);
479         LP_TOKEN.safeTransferFrom(sender, address(this), amount);
480     }
481 
482     function withdraw(uint256 amount) public {
483         _totalSupply = _totalSupply.sub(amount);
484         _balances[msg.sender] = _balances[msg.sender].sub(amount);
485         LP_TOKEN.safeTransfer(msg.sender, amount);
486     }
487 }
488 
489 contract KittenPool is LPTokenWrapper, Ownable {
490     IERC20 public REWARD_TOKEN = IERC20(0x124c6092c469716A661b5B0609F205050b26b50f); // EDIT_ME: Reward token
491     uint256 public constant DURATION = 7 days;
492 
493     uint256 public origTotalSupply = 0;
494 
495     uint256 public initreward = 0;
496     uint256 public starttime = 1600956000; // EDIT_ME: 2020-09-24T14:00:00+00:00
497     uint256 public periodFinish = 0;
498     uint256 public rewardRate = 0;
499     uint256 public lastUpdateTime;
500     uint256 public rewardPerTokenStored;
501     mapping(address => uint256) public userRewardPerTokenPaid;
502     mapping(address => uint256) public rewards;
503 
504     event RewardAdded(uint256 reward);
505     event Staked(address indexed user, uint256 amount);
506     event Withdrawn(address indexed user, uint256 amount);
507     event RewardPaid(address indexed user, uint256 reward);
508 
509     constructor () public {
510         origTotalSupply = REWARD_TOKEN.totalSupply();
511 
512         // 3 pools, 0.080 / 0.080 / 0.085 => 0.32 / 0.32 / 0.34 => total 98%
513         initreward = origTotalSupply.mul(80).div(1000);
514 
515         notifyRewardAmount(initreward);
516         renounceOwnership();
517     }
518 
519     modifier updateReward(address account) {
520         rewardPerTokenStored = rewardPerToken();
521         lastUpdateTime = lastTimeRewardApplicable();
522         if (account != address(0)) {
523             rewards[account] = earned(account);
524             userRewardPerTokenPaid[account] = rewardPerTokenStored;
525         }
526         _;
527     }
528 
529     function lastTimeRewardApplicable() public view returns (uint256) {
530         return Math.min(block.timestamp, periodFinish);
531     }
532 
533     function rewardPerToken() public view returns (uint256) {
534         if (totalSupply() == 0) {
535             return rewardPerTokenStored;
536         }
537         return
538             rewardPerTokenStored.add(
539                 lastTimeRewardApplicable()
540                     .sub(lastUpdateTime)
541                     .mul(rewardRate)
542                     .mul(1e18)
543                     .div(totalSupply())
544             );
545     }
546 
547     function earned(address account) public view returns (uint256) {
548         return
549             balanceOf(account)
550                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
551                 .div(1e18)
552                 .add(rewards[account]);
553     }
554 
555     // stake visibility is public as overriding LPTokenWrapper's stake() function
556     function stake(uint256 amount) public updateReward(msg.sender) checkhalve checkStart { 
557         require(amount > 0, "Cannot stake 0");
558         super.stake(amount);
559         emit Staked(msg.sender, amount);
560     }
561 
562     function withdraw(uint256 amount) public updateReward(msg.sender) {
563         require(amount > 0, "Cannot withdraw 0");
564         super.withdraw(amount);
565         emit Withdrawn(msg.sender, amount);
566     }
567 
568     function exit() external {
569         withdraw(balanceOf(msg.sender));
570         getReward();
571     }
572 
573     function getReward() public updateReward(msg.sender) checkhalve {
574         uint256 reward = earned(msg.sender);
575         if (reward > 0) {
576             rewards[msg.sender] = 0;
577 
578             // scaled by nowTotalSupply / origTotalSupply when claiming reward
579             uint256 nowTotalSupply = REWARD_TOKEN.totalSupply();
580             reward = reward.mul(nowTotalSupply).div(origTotalSupply);
581 
582             REWARD_TOKEN.safeTransfer(msg.sender, reward);
583             
584             emit RewardPaid(msg.sender, reward);
585         }
586     }
587 
588     modifier checkhalve(){
589         if (block.timestamp >= periodFinish) {
590             initreward = initreward.mul(75).div(100); // yield reduces to 75% every week
591 
592             rewardRate = initreward.div(DURATION);
593             periodFinish = block.timestamp.add(DURATION);
594             emit RewardAdded(initreward);
595         }
596         _;
597     }
598     modifier checkStart(){
599         require(block.timestamp > starttime,"not start");
600         _;
601     }
602 
603     function notifyRewardAmount(uint256 reward) private
604         updateReward(address(0))
605     {
606         if (block.timestamp >= periodFinish) {
607             rewardRate = reward.div(DURATION);
608         } else {
609             uint256 remaining = periodFinish.sub(block.timestamp);
610             uint256 leftover = remaining.mul(rewardRate);
611             rewardRate = reward.add(leftover).div(DURATION);
612         }
613 
614         lastUpdateTime = block.timestamp;
615         periodFinish = block.timestamp.add(DURATION);
616         emit RewardAdded(reward);
617     }
618 }