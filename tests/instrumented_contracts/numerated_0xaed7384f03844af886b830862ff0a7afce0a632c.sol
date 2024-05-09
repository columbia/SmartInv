1 // File: contracts/lib/Ownable.sol
2 
3 /*
4 
5     Copyright 2020 DODO ZOO.
6     SPDX-License-Identifier: Apache-2.0
7 
8 */
9 
10 pragma solidity 0.6.9;
11 pragma experimental ABIEncoderV2;
12 
13 
14 /**
15  * @title Ownable
16  * @author DODO Breeder
17  *
18  * @notice Ownership related functions
19  */
20 contract Ownable {
21     address public _OWNER_;
22     address public _NEW_OWNER_;
23 
24     // ============ Events ============
25 
26     event OwnershipTransferPrepared(address indexed previousOwner, address indexed newOwner);
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     // ============ Modifiers ============
31 
32     modifier onlyOwner() {
33         require(msg.sender == _OWNER_, "NOT_OWNER");
34         _;
35     }
36 
37     // ============ Functions ============
38 
39     constructor() internal {
40         _OWNER_ = msg.sender;
41         emit OwnershipTransferred(address(0), _OWNER_);
42     }
43 
44     function transferOwnership(address newOwner) external onlyOwner {
45         require(newOwner != address(0), "INVALID_OWNER");
46         emit OwnershipTransferPrepared(_OWNER_, newOwner);
47         _NEW_OWNER_ = newOwner;
48     }
49 
50     function claimOwnership() external {
51         require(msg.sender == _NEW_OWNER_, "INVALID_CLAIM");
52         emit OwnershipTransferred(_OWNER_, _NEW_OWNER_);
53         _OWNER_ = _NEW_OWNER_;
54         _NEW_OWNER_ = address(0);
55     }
56 }
57 
58 
59 // File: contracts/lib/SafeMath.sol
60 
61 /*
62 
63     Copyright 2020 DODO ZOO.
64 
65 */
66 
67 /**
68  * @title SafeMath
69  * @author DODO Breeder
70  *
71  * @notice Math operations with safety checks that revert on error
72  */
73 library SafeMath {
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         if (a == 0) {
76             return 0;
77         }
78 
79         uint256 c = a * b;
80         require(c / a == b, "MUL_ERROR");
81 
82         return c;
83     }
84 
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         require(b > 0, "DIVIDING_ERROR");
87         return a / b;
88     }
89 
90     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
91         uint256 quotient = div(a, b);
92         uint256 remainder = a - quotient * b;
93         if (remainder > 0) {
94             return quotient + 1;
95         } else {
96             return quotient;
97         }
98     }
99 
100     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
101         require(b <= a, "SUB_ERROR");
102         return a - b;
103     }
104 
105     function add(uint256 a, uint256 b) internal pure returns (uint256) {
106         uint256 c = a + b;
107         require(c >= a, "ADD_ERROR");
108         return c;
109     }
110 
111     function sqrt(uint256 x) internal pure returns (uint256 y) {
112         uint256 z = x / 2 + 1;
113         y = x;
114         while (z < y) {
115             y = z;
116             z = (x / z + z) / 2;
117         }
118     }
119 }
120 
121 
122 // File: contracts/lib/DecimalMath.sol
123 
124 /*
125 
126     Copyright 2020 DODO ZOO.
127 
128 */
129 
130 /**
131  * @title DecimalMath
132  * @author DODO Breeder
133  *
134  * @notice Functions for fixed point number with 18 decimals
135  */
136 library DecimalMath {
137     using SafeMath for uint256;
138 
139     uint256 constant ONE = 10**18;
140 
141     function mul(uint256 target, uint256 d) internal pure returns (uint256) {
142         return target.mul(d) / ONE;
143     }
144 
145     function mulCeil(uint256 target, uint256 d) internal pure returns (uint256) {
146         return target.mul(d).divCeil(ONE);
147     }
148 
149     function divFloor(uint256 target, uint256 d) internal pure returns (uint256) {
150         return target.mul(ONE).div(d);
151     }
152 
153     function divCeil(uint256 target, uint256 d) internal pure returns (uint256) {
154         return target.mul(ONE).divCeil(d);
155     }
156 }
157 
158 
159 // File: contracts/intf/IERC20.sol
160 
161 // This is a file copied from https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
162 
163 /**
164  * @dev Interface of the ERC20 standard as defined in the EIP.
165  */
166 interface IERC20 {
167     /**
168      * @dev Returns the amount of tokens in existence.
169      */
170     function totalSupply() external view returns (uint256);
171 
172     function decimals() external view returns (uint8);
173 
174     function name() external view returns (string memory);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(
225         address sender,
226         address recipient,
227         uint256 amount
228     ) external returns (bool);
229 }
230 
231 
232 // File: contracts/lib/SafeERC20.sol
233 
234 /*
235 
236     Copyright 2020 DODO ZOO.
237     This is a simplified version of OpenZepplin's SafeERC20 library
238 
239 */
240 
241 /**
242  * @title SafeERC20
243  * @dev Wrappers around ERC20 operations that throw on failure (when the token
244  * contract returns false). Tokens that return no value (and instead revert or
245  * throw on failure) are also supported, non-reverting calls are assumed to be
246  * successful.
247  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
248  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
249  */
250 library SafeERC20 {
251     using SafeMath for uint256;
252 
253     function safeTransfer(
254         IERC20 token,
255         address to,
256         uint256 value
257     ) internal {
258         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
259     }
260 
261     function safeTransferFrom(
262         IERC20 token,
263         address from,
264         address to,
265         uint256 value
266     ) internal {
267         _callOptionalReturn(
268             token,
269             abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
270         );
271     }
272 
273     function safeApprove(
274         IERC20 token,
275         address spender,
276         uint256 value
277     ) internal {
278         // safeApprove should only be called when setting an initial allowance,
279         // or when resetting it to zero. To increase and decrease it, use
280         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
281         // solhint-disable-next-line max-line-length
282         require(
283             (value == 0) || (token.allowance(address(this), spender) == 0),
284             "SafeERC20: approve from non-zero to non-zero allowance"
285         );
286         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
287     }
288 
289     /**
290      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
291      * on the return value: the return value is optional (but if data is returned, it must not be false).
292      * @param token The token targeted by the call.
293      * @param data The call data (encoded using abi.encode or one of its variants).
294      */
295     function _callOptionalReturn(IERC20 token, bytes memory data) private {
296         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
297         // we're implementing it ourselves.
298 
299         // A Solidity high level call has three parts:
300         //  1. The target address is checked to verify it contains contract code
301         //  2. The call itself is made, and success asserted
302         //  3. The return value is decoded, which in turn checks the size of the returned data.
303         // solhint-disable-next-line max-line-length
304 
305         // solhint-disable-next-line avoid-low-level-calls
306         (bool success, bytes memory returndata) = address(token).call(data);
307         require(success, "SafeERC20: low-level call failed");
308 
309         if (returndata.length > 0) {
310             // Return data is optional
311             // solhint-disable-next-line max-line-length
312             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
313         }
314     }
315 }
316 
317 
318 // File: contracts/token/DODORewardVault.sol
319 
320 /*
321 
322     Copyright 2020 DODO ZOO.
323 
324 */
325 
326 interface IDODORewardVault {
327     function reward(address to, uint256 amount) external;
328 }
329 
330 
331 contract DODORewardVault is Ownable {
332     using SafeERC20 for IERC20;
333 
334     address public dodoToken;
335 
336     constructor(address _dodoToken) public {
337         dodoToken = _dodoToken;
338     }
339 
340     function reward(address to, uint256 amount) external onlyOwner {
341         IERC20(dodoToken).safeTransfer(to, amount);
342     }
343 }
344 
345 
346 // File: contracts/token/DODOMine.sol
347 
348 /*
349 
350     Copyright 2020 DODO ZOO.
351 
352 */
353 
354 contract DODOMine is Ownable {
355     using SafeMath for uint256;
356     using SafeERC20 for IERC20;
357 
358     // Info of each user.
359     struct UserInfo {
360         uint256 amount; // How many LP tokens the user has provided.
361         uint256 rewardDebt; // Reward debt. See explanation below.
362         //
363         // We do some fancy math here. Basically, any point in time, the amount of DODOs
364         // entitled to a user but is pending to be distributed is:
365         //
366         //   pending reward = (user.amount * pool.accDODOPerShare) - user.rewardDebt
367         //
368         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
369         //   1. The pool's `accDODOPerShare` (and `lastRewardBlock`) gets updated.
370         //   2. User receives the pending reward sent to his/her address.
371         //   3. User's `amount` gets updated.
372         //   4. User's `rewardDebt` gets updated.
373     }
374 
375     // Info of each pool.
376     struct PoolInfo {
377         address lpToken; // Address of LP token contract.
378         uint256 allocPoint; // How many allocation points assigned to this pool. DODOs to distribute per block.
379         uint256 lastRewardBlock; // Last block number that DODOs distribution occurs.
380         uint256 accDODOPerShare; // Accumulated DODOs per share, times 1e12. See below.
381     }
382 
383     address public dodoRewardVault;
384     uint256 public dodoPerBlock;
385 
386     // Info of each pool.
387     PoolInfo[] public poolInfos;
388     mapping(address => uint256) public lpTokenRegistry;
389 
390     // Info of each user that stakes LP tokens.
391     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
392     mapping(address => uint256) public realizedReward;
393 
394     // Total allocation points. Must be the sum of all allocation points in all pools.
395     uint256 public totalAllocPoint = 0;
396     // The block number when DODO mining starts.
397     uint256 public startBlock;
398 
399     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
400     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
401     event Claim(address indexed user, uint256 amount);
402 
403     constructor(address _dodoToken, uint256 _startBlock) public {
404         dodoRewardVault = address(new DODORewardVault(_dodoToken));
405         startBlock = _startBlock;
406     }
407 
408     // ============ Modifiers ============
409 
410     modifier lpTokenExist(address lpToken) {
411         require(lpTokenRegistry[lpToken] > 0, "LP Token Not Exist");
412         _;
413     }
414 
415     modifier lpTokenNotExist(address lpToken) {
416         require(lpTokenRegistry[lpToken] == 0, "LP Token Already Exist");
417         _;
418     }
419 
420     // ============ Helper ============
421 
422     function poolLength() external view returns (uint256) {
423         return poolInfos.length;
424     }
425 
426     function getPid(address _lpToken) public view lpTokenExist(_lpToken) returns (uint256) {
427         return lpTokenRegistry[_lpToken] - 1;
428     }
429 
430     function getUserLpBalance(address _lpToken, address _user) public view returns (uint256) {
431         uint256 pid = getPid(_lpToken);
432         return userInfo[pid][_user].amount;
433     }
434 
435     // ============ Ownable ============
436 
437     function addLpToken(
438         address _lpToken,
439         uint256 _allocPoint,
440         bool _withUpdate
441     ) public lpTokenNotExist(_lpToken) onlyOwner {
442         if (_withUpdate) {
443             massUpdatePools();
444         }
445         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
446         totalAllocPoint = totalAllocPoint.add(_allocPoint);
447         poolInfos.push(
448             PoolInfo({
449                 lpToken: _lpToken,
450                 allocPoint: _allocPoint,
451                 lastRewardBlock: lastRewardBlock,
452                 accDODOPerShare: 0
453             })
454         );
455         lpTokenRegistry[_lpToken] = poolInfos.length;
456     }
457 
458     function setLpToken(
459         address _lpToken,
460         uint256 _allocPoint,
461         bool _withUpdate
462     ) public onlyOwner {
463         if (_withUpdate) {
464             massUpdatePools();
465         }
466         uint256 pid = getPid(_lpToken);
467         totalAllocPoint = totalAllocPoint.sub(poolInfos[pid].allocPoint).add(_allocPoint);
468         poolInfos[pid].allocPoint = _allocPoint;
469     }
470 
471     function setReward(uint256 _dodoPerBlock, bool _withUpdate) external onlyOwner {
472         if (_withUpdate) {
473             massUpdatePools();
474         }
475         dodoPerBlock = _dodoPerBlock;
476     }
477 
478     // ============ View Rewards ============
479 
480     function getPendingReward(address _lpToken, address _user) external view returns (uint256) {
481         uint256 pid = getPid(_lpToken);
482         PoolInfo storage pool = poolInfos[pid];
483         UserInfo storage user = userInfo[pid][_user];
484         uint256 accDODOPerShare = pool.accDODOPerShare;
485         uint256 lpSupply = IERC20(pool.lpToken).balanceOf(address(this));
486         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
487             uint256 DODOReward = block
488                 .number
489                 .sub(pool.lastRewardBlock)
490                 .mul(dodoPerBlock)
491                 .mul(pool.allocPoint)
492                 .div(totalAllocPoint);
493             accDODOPerShare = accDODOPerShare.add(DecimalMath.divFloor(DODOReward, lpSupply));
494         }
495         return DecimalMath.mul(user.amount, accDODOPerShare).sub(user.rewardDebt);
496     }
497 
498     function getAllPendingReward(address _user) external view returns (uint256) {
499         uint256 length = poolInfos.length;
500         uint256 totalReward = 0;
501         for (uint256 pid = 0; pid < length; ++pid) {
502             if (userInfo[pid][_user].amount == 0 || poolInfos[pid].allocPoint == 0) {
503                 continue; // save gas
504             }
505             PoolInfo storage pool = poolInfos[pid];
506             UserInfo storage user = userInfo[pid][_user];
507             uint256 accDODOPerShare = pool.accDODOPerShare;
508             uint256 lpSupply = IERC20(pool.lpToken).balanceOf(address(this));
509             if (block.number > pool.lastRewardBlock && lpSupply != 0) {
510                 uint256 DODOReward = block
511                     .number
512                     .sub(pool.lastRewardBlock)
513                     .mul(dodoPerBlock)
514                     .mul(pool.allocPoint)
515                     .div(totalAllocPoint);
516                 accDODOPerShare = accDODOPerShare.add(DecimalMath.divFloor(DODOReward, lpSupply));
517             }
518             totalReward = totalReward.add(
519                 DecimalMath.mul(user.amount, accDODOPerShare).sub(user.rewardDebt)
520             );
521         }
522         return totalReward;
523     }
524 
525     function getRealizedReward(address _user) external view returns (uint256) {
526         return realizedReward[_user];
527     }
528 
529     function getDlpMiningSpeed(address _lpToken) external view returns (uint256) {
530         uint256 pid = getPid(_lpToken);
531         PoolInfo storage pool = poolInfos[pid];
532         return dodoPerBlock.mul(pool.allocPoint).div(totalAllocPoint);
533     }
534 
535     // ============ Update Pools ============
536 
537     // Update reward vairables for all pools. Be careful of gas spending!
538     function massUpdatePools() public {
539         uint256 length = poolInfos.length;
540         for (uint256 pid = 0; pid < length; ++pid) {
541             updatePool(pid);
542         }
543     }
544 
545     // Update reward variables of the given pool to be up-to-date.
546     function updatePool(uint256 _pid) public {
547         PoolInfo storage pool = poolInfos[_pid];
548         if (block.number <= pool.lastRewardBlock) {
549             return;
550         }
551         uint256 lpSupply = IERC20(pool.lpToken).balanceOf(address(this));
552         if (lpSupply == 0) {
553             pool.lastRewardBlock = block.number;
554             return;
555         }
556         uint256 DODOReward = block
557             .number
558             .sub(pool.lastRewardBlock)
559             .mul(dodoPerBlock)
560             .mul(pool.allocPoint)
561             .div(totalAllocPoint);
562         pool.accDODOPerShare = pool.accDODOPerShare.add(DecimalMath.divFloor(DODOReward, lpSupply));
563         pool.lastRewardBlock = block.number;
564     }
565 
566     // ============ Deposit & Withdraw & Claim ============
567     // Deposit & withdraw will also trigger claim
568 
569     function deposit(address _lpToken, uint256 _amount) public {
570         uint256 pid = getPid(_lpToken);
571         PoolInfo storage pool = poolInfos[pid];
572         UserInfo storage user = userInfo[pid][msg.sender];
573         updatePool(pid);
574         if (user.amount > 0) {
575             uint256 pending = DecimalMath.mul(user.amount, pool.accDODOPerShare).sub(
576                 user.rewardDebt
577             );
578             safeDODOTransfer(msg.sender, pending);
579         }
580         IERC20(pool.lpToken).safeTransferFrom(address(msg.sender), address(this), _amount);
581         user.amount = user.amount.add(_amount);
582         user.rewardDebt = DecimalMath.mul(user.amount, pool.accDODOPerShare);
583         emit Deposit(msg.sender, pid, _amount);
584     }
585 
586     function withdraw(address _lpToken, uint256 _amount) public {
587         uint256 pid = getPid(_lpToken);
588         PoolInfo storage pool = poolInfos[pid];
589         UserInfo storage user = userInfo[pid][msg.sender];
590         require(user.amount >= _amount, "withdraw too much");
591         updatePool(pid);
592         uint256 pending = DecimalMath.mul(user.amount, pool.accDODOPerShare).sub(user.rewardDebt);
593         safeDODOTransfer(msg.sender, pending);
594         user.amount = user.amount.sub(_amount);
595         user.rewardDebt = DecimalMath.mul(user.amount, pool.accDODOPerShare);
596         IERC20(pool.lpToken).safeTransfer(address(msg.sender), _amount);
597         emit Withdraw(msg.sender, pid, _amount);
598     }
599 
600     function withdrawAll(address _lpToken) public {
601         uint256 balance = getUserLpBalance(_lpToken, msg.sender);
602         withdraw(_lpToken, balance);
603     }
604 
605     // Withdraw without caring about rewards. EMERGENCY ONLY.
606     function emergencyWithdraw(address _lpToken) public {
607         uint256 pid = getPid(_lpToken);
608         PoolInfo storage pool = poolInfos[pid];
609         UserInfo storage user = userInfo[pid][msg.sender];
610         IERC20(pool.lpToken).safeTransfer(address(msg.sender), user.amount);
611         user.amount = 0;
612         user.rewardDebt = 0;
613     }
614 
615     function claim(address _lpToken) public {
616         uint256 pid = getPid(_lpToken);
617         if (userInfo[pid][msg.sender].amount == 0 || poolInfos[pid].allocPoint == 0) {
618             return; // save gas
619         }
620         PoolInfo storage pool = poolInfos[pid];
621         UserInfo storage user = userInfo[pid][msg.sender];
622         updatePool(pid);
623         uint256 pending = DecimalMath.mul(user.amount, pool.accDODOPerShare).sub(user.rewardDebt);
624         user.rewardDebt = DecimalMath.mul(user.amount, pool.accDODOPerShare);
625         safeDODOTransfer(msg.sender, pending);
626     }
627 
628     function claimAll() public {
629         uint256 length = poolInfos.length;
630         uint256 pending = 0;
631         for (uint256 pid = 0; pid < length; ++pid) {
632             if (userInfo[pid][msg.sender].amount == 0 || poolInfos[pid].allocPoint == 0) {
633                 continue; // save gas
634             }
635             PoolInfo storage pool = poolInfos[pid];
636             UserInfo storage user = userInfo[pid][msg.sender];
637             updatePool(pid);
638             pending = pending.add(
639                 DecimalMath.mul(user.amount, pool.accDODOPerShare).sub(user.rewardDebt)
640             );
641             user.rewardDebt = DecimalMath.mul(user.amount, pool.accDODOPerShare);
642         }
643         safeDODOTransfer(msg.sender, pending);
644     }
645 
646     // Safe DODO transfer function, just in case if rounding error causes pool to not have enough DODOs.
647     function safeDODOTransfer(address _to, uint256 _amount) internal {
648         IDODORewardVault(dodoRewardVault).reward(_to, _amount);
649         realizedReward[_to] = realizedReward[_to].add(_amount);
650         emit Claim(_to, _amount);
651     }
652 }