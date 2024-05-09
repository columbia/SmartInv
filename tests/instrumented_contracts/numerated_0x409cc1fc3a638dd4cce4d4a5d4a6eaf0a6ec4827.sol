1 /**
2         _____________             
3 _____  ____  __ \__(_)___________ 
4 __  / / /_  /_/ /_  /__  ___/  _ \
5 _  /_/ /_  _, _/_  / _(__  )/  __/
6 _\__, / /_/ |_| /_/  /____/ \___/ 
7 /____/                            
8 
9 * Docs: https://docs.synthetix.io/
10 *
11 *
12 * MIT License
13 * ===========
14 *
15 * Copyright (c) 2020 Synthetix
16 *
17 * Permission is hereby granted, free of charge, to any person obtaining a copy
18 * of this software and associated documentation files (the "Software"), to deal
19 * in the Software without restriction, including without limitation the rights
20 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
21 * copies of the Software, and to permit persons to whom the Software is
22 * furnished to do so, subject to the following conditions:
23 *
24 * The above copyright notice and this permission notice shall be included in all
25 * copies or substantial portions of the Software.
26 *
27 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
28 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
29 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
30 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
31 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
32 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
33 */
34 
35 // File: @openzeppelin/contracts/math/Math.sol
36 
37 pragma solidity ^0.5.0;
38 
39 library Math {
40 
41     function max(uint256 a, uint256 b) internal pure returns (uint256) {
42         return a >= b ? a : b;
43     }
44 
45     function min(uint256 a, uint256 b) internal pure returns (uint256) {
46         return a < b ? a : b;
47     }
48 
49     function average(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b) / 2 can overflow, so we distribute
51         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
52     }
53 }
54 
55 // File: @openzeppelin/contracts/math/SafeMath.sol
56 
57 library SafeMath {
58 
59     function add(uint256 a, uint256 b) internal pure returns (uint256) {
60         uint256 c = a + b;
61         require(c >= a, "SafeMath: addition overflow");
62 
63         return c;
64     }
65 
66     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
67         return sub(a, b, "SafeMath: subtraction overflow");
68     }
69 
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b, "SafeMath: multiplication overflow");
84 
85         return c;
86     }
87 
88     function div(uint256 a, uint256 b) internal pure returns (uint256) {
89         return div(a, b, "SafeMath: division by zero");
90     }
91 
92     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
93         // Solidity only automatically asserts when dividing by 0
94         require(b > 0, errorMessage);
95         uint256 c = a / b;
96         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
97 
98         return c;
99     }
100 
101     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
102         return mod(a, b, "SafeMath: modulo by zero");
103     }
104 
105     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
106         require(b != 0, errorMessage);
107         return a % b;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/ownership/Ownable.sol
112 
113 contract Ownable {
114 
115     address private _owner;
116 
117     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
118 
119     constructor () internal {
120         _owner = msg.sender;
121         emit OwnershipTransferred(address(0), _owner);
122     }
123 
124     function owner() public view returns (address) {
125         return _owner;
126     }
127 
128     modifier onlyOwner() {
129         require(isOwner(), "Ownable: caller is not the owner");
130         _;
131     }
132 
133     function isOwner() public view returns (bool) {
134         return msg.sender == _owner;
135     }
136 
137     function renounceOwnership() public onlyOwner {
138         emit OwnershipTransferred(_owner, address(0));
139         _owner = address(0);
140     }
141 
142     function transferOwnership(address newOwner) public onlyOwner {
143         _transferOwnership(newOwner);
144     }
145 
146     function _transferOwnership(address newOwner) internal {
147         require(newOwner != address(0), "Ownable: new owner is the zero address");
148         emit OwnershipTransferred(_owner, newOwner);
149         _owner = newOwner;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
154 
155 interface IERC20 {
156 
157     function totalSupply() external view returns (uint256);
158     function balanceOf(address account) external view returns (uint256);
159     function transfer(address recipient, uint256 amount) external returns (bool);
160     function allowance(address owner, address spender) external view returns (uint256);
161     function approve(address spender, uint256 amount) external returns (bool);
162     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
163     function burn(uint256 amount, uint256 bRate) external returns(uint256);
164 
165     event Transfer(address indexed from, address indexed to, uint256 value);
166     event Approval(address indexed owner, address indexed spender, uint256 value);
167 }
168 
169 // File: @openzeppelin/contracts/utils/Address.sol
170 
171 pragma solidity ^0.5.5;
172 
173 library Address {
174     /**
175      * @dev Returns true if `account` is a contract.
176      *
177      * This test is non-exhaustive, and there may be false-negatives: during the
178      * execution of a contract's constructor, its address will be reported as
179      * not containing a contract.
180      *
181      * IMPORTANT: It is unsafe to assume that an address for which this
182      * function returns false is an externally-owned account (EOA) and not a
183      * contract.
184      */
185     function isContract(address account) internal view returns (bool) {
186         // This method relies in extcodesize, which returns 0 for contracts in
187         // construction, since the code is only stored at the end of the
188         // constructor execution.
189 
190         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
191         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
192         // for accounts without code, i.e. `keccak256('')`
193         bytes32 codehash;
194         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
195         // solhint-disable-next-line no-inline-assembly
196         assembly { codehash := extcodehash(account) }
197         return (codehash != 0x0 && codehash != accountHash);
198     }
199 
200     /**
201      * @dev Converts an `address` into `address payable`. Note that this is
202      * simply a type cast: the actual underlying value is not changed.
203      *
204      * _Available since v2.4.0._
205      */
206     function toPayable(address account) internal pure returns (address payable) {
207         return address(uint160(account));
208     }
209 
210     /**
211      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
212      * `recipient`, forwarding all available gas and reverting on errors.
213      *
214      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
215      * of certain opcodes, possibly making contracts go over the 2300 gas limit
216      * imposed by `transfer`, making them unable to receive funds via
217      * `transfer`. {sendValue} removes this limitation.
218      *
219      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
220      *
221      * IMPORTANT: because control is transferred to `recipient`, care must be
222      * taken to not create reentrancy vulnerabilities. Consider using
223      * {ReentrancyGuard} or the
224      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
225      *
226      * _Available since v2.4.0._
227      */
228     function sendValue(address payable recipient, uint256 amount) internal {
229         require(address(this).balance >= amount, "Address: insufficient balance");
230 
231         // solhint-disable-next-line avoid-call-value
232         (bool success, ) = recipient.call.value(amount)("");
233         require(success, "Address: unable to send value, recipient may have reverted");
234     }
235 }
236 
237 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
238 
239 /**
240  * @title SafeERC20
241  * @dev Wrappers around ERC20 operations that throw on failure (when the token
242  * contract returns false). Tokens that return no value (and instead revert or
243  * throw on failure) are also supported, non-reverting calls are assumed to be
244  * successful.
245  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
246  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
247  */
248 library SafeERC20 {
249     using SafeMath for uint256;
250     using Address for address;
251 
252     function safeTransfer(IERC20 token, address to, uint256 value) internal {
253         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
254     }
255 
256     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
257         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
258     }
259 
260     function safeApprove(IERC20 token, address spender, uint256 value) internal {
261         // safeApprove should only be called when setting an initial allowance,
262         // or when resetting it to zero. To increase and decrease it, use
263         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
264         // solhint-disable-next-line max-line-length
265         require((value == 0) || (token.allowance(address(this), spender) == 0),
266             "SafeERC20: approve from non-zero to non-zero allowance"
267         );
268         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
269     }
270 
271     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
272         uint256 newAllowance = token.allowance(address(this), spender).add(value);
273         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
274     }
275 
276     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
277         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
278         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
279     }
280 
281     /**
282      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
283      * on the return value: the return value is optional (but if data is returned, it must not be false).
284      * @param token The token targeted by the call.
285      * @param data The call data (encoded using abi.encode or one of its variants).
286      */
287     function callOptionalReturn(IERC20 token, bytes memory data) private {
288         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
289         // we're implementing it ourselves.
290 
291         // A Solidity high level call has three parts:
292         //  1. The target address is checked to verify it contains contract code
293         //  2. The call itself is made, and success asserted
294         //  3. The return value is decoded, which in turn checks the size of the returned data.
295         // solhint-disable-next-line max-line-length
296         require(address(token).isContract(), "SafeERC20: call to non-contract");
297 
298         // solhint-disable-next-line avoid-low-level-calls
299         (bool success, bytes memory returndata) = address(token).call(data);
300         require(success, "SafeERC20: low-level call failed");
301 
302         if (returndata.length > 0) { // Return data is optional
303             // solhint-disable-next-line max-line-length
304             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
305         }
306     }
307 }
308 
309 // File: contracts/IRewardDistributionRecipient.sol
310 
311 pragma solidity ^0.5.0;
312 
313 contract IRewardDistributionRecipient is Ownable {
314     address rewardDistribution;
315 
316     function notifyRewardAmount(uint256 reward) external;
317 
318     modifier onlyRewardDistribution() {
319         require(msg.sender == rewardDistribution, "Caller is not reward distribution");
320         _;
321     }
322 
323     function setRewardDistribution(address _rewardDistribution)
324         external
325         onlyOwner
326     {
327         rewardDistribution = _rewardDistribution;
328     }
329 }
330 
331 // File: contracts/CurveRewards.sol
332 
333 pragma solidity ^0.5.0;
334 
335 contract LPTokenWrapper {
336     using SafeMath for uint256;
337     using SafeERC20 for IERC20;
338 
339     IERC20 public stakeToken;
340 
341     uint256 internal _totalSupply;
342     mapping(address => uint256) internal _balances;
343    
344 
345     function totalSupply() public view returns (uint256) {
346         return _totalSupply;
347     }
348 
349     function balanceOf(address account) public view returns (uint256) {
350         return _balances[account];
351     }
352 
353     function stake(uint256 amount) public {
354         
355         _totalSupply = _totalSupply.add(amount);
356         _balances[msg.sender] = _balances[msg.sender].add(amount);
357         stakeToken.safeTransferFrom(msg.sender, address(this), amount);
358     }
359 
360     function withdraw(uint256 amount) public {
361         _totalSupply = _totalSupply.sub(amount);
362         _balances[msg.sender] = _balances[msg.sender].sub(amount);
363         stakeToken.safeTransfer(msg.sender, amount);
364     }
365     
366 }
367 
368 contract yRiseETHlpReward is LPTokenWrapper, IRewardDistributionRecipient {
369 
370     constructor() public {
371         rewardDistribution = msg.sender;
372     }
373 
374     IERC20 public yRise = IERC20(0x6051C1354Ccc51b4d561e43b02735DEaE64768B8);
375     
376     uint256 public DURATION = 7776000; // 90 days
377 
378     uint256 public starttime = 0; 
379     uint256 public periodFinish = 0;
380     uint256 public rewardRate = 0;
381     uint256 public lastUpdateTime;
382     uint256 public rewardPerTokenStored;
383     mapping(address => uint256) public userRewardPerTokenPaid;
384     mapping(address => uint256) public rewards;
385 
386     event RewardAdded(uint256 reward);
387     event Withdrawn(address indexed user, uint256 amount);
388     event RewardPaid(address indexed user, uint256 reward);
389     event SetStakeToken(address stakeAddress);
390     event SetStartTime(uint256 unixtime);
391 
392     modifier checkStart() {
393         require(block.timestamp >= starttime,"Rewards haven't started yet!");
394         _;
395     }
396 
397     modifier updateReward(address account) {
398         rewardPerTokenStored = rewardPerToken();
399         lastUpdateTime = lastTimeRewardApplicable();
400         if (account != address(0)) {
401             rewards[account] = earned(account);
402             userRewardPerTokenPaid[account] = rewardPerTokenStored;
403         }
404         _;
405     }
406 
407     function lastTimeRewardApplicable() public view returns (uint256) {
408         return Math.min(block.timestamp, periodFinish);
409     }
410     
411     function remainingReward() public view returns (uint256) {
412         return yRise.balanceOf(address(this));
413     }
414 
415     function rewardPerToken() public view returns (uint256) {
416         if (totalSupply() == 0) {
417             return rewardPerTokenStored;
418         }
419         return
420             rewardPerTokenStored.add(
421                 lastTimeRewardApplicable()
422                     .sub(lastUpdateTime)
423                     .mul(rewardRate)
424                     .mul(1e18)
425                     .div(totalSupply())
426             );
427     }
428 
429     function earned(address account) public view returns (uint256) {
430         return
431             balanceOf(account)
432                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
433                 .div(1e18)
434                 .add(rewards[account]);
435     }
436 
437     // stake visibility is public as overriding LPTokenWrapper's stake() function
438     function stake(uint256 amount) public updateReward(msg.sender) checkStart {
439         require(amount > 0, "Cannot stake 0");
440         super.stake(amount);
441     }
442 
443     function withdraw(uint256 amount) public updateReward(msg.sender) checkStart {
444         require(amount > 0, "Cannot withdraw 0");
445         super.withdraw(amount);
446         emit Withdrawn(msg.sender, amount);
447     }
448 
449     function exit() external {
450         withdraw(balanceOf(msg.sender));
451         getReward();
452     }
453 
454     function getReward() public updateReward(msg.sender) checkStart {
455         uint256 reward = earned(msg.sender);
456         if (reward > 0) {
457             rewards[msg.sender] = 0;
458             yRise.safeTransfer(msg.sender, reward);
459             emit RewardPaid(msg.sender, reward);
460         }
461     }
462 
463     function notifyRewardAmount(uint256 reward)
464         external
465         onlyRewardDistribution
466         updateReward(address(0))
467     {
468         if (block.timestamp > starttime) {
469           if (block.timestamp >= periodFinish) {
470               rewardRate = reward.div(DURATION);
471           } else {
472               uint256 remaining = periodFinish.sub(block.timestamp);
473               uint256 leftover = remaining.mul(rewardRate);
474               rewardRate = reward.add(leftover).div(DURATION);
475           }
476           lastUpdateTime = block.timestamp;
477           periodFinish = block.timestamp.add(DURATION);
478           emit RewardAdded(reward);
479         } else {
480           rewardRate = reward.div(DURATION);
481           lastUpdateTime = starttime;
482           periodFinish = starttime.add(DURATION);
483           emit RewardAdded(reward);
484         }
485     }
486 
487     function setStakeAddress(address stakeAddress) public onlyOwner {
488         stakeToken = IERC20(stakeAddress);
489         emit SetStakeToken(stakeAddress);
490     }
491 
492     function setStartTime(uint256 unixtime) public onlyOwner {
493         starttime = unixtime;
494         emit SetStartTime(unixtime);
495     }
496 
497 }