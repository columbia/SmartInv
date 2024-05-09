1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // This method relies on extcodesize, which returns 0 for contracts in
28         // construction, since the code is only stored at the end of the
29         // constructor execution.
30 
31         uint256 size;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { size := extcodesize(account) }
34         return size > 0;
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         require(isContract(target), "Address: call to non-contract");
117 
118         // solhint-disable-next-line avoid-low-level-calls
119         (bool success, bytes memory returndata) = target.call{ value: value }(data);
120         return _verifyCallResult(success, returndata, errorMessage);
121     }
122 
123     /**
124      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
125      * but performing a static call.
126      *
127      * _Available since v3.3._
128      */
129     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
130         return functionStaticCall(target, data, "Address: low-level static call failed");
131     }
132 
133     /**
134      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
135      * but performing a static call.
136      *
137      * _Available since v3.3._
138      */
139     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
140         require(isContract(target), "Address: static call to non-contract");
141 
142         // solhint-disable-next-line avoid-low-level-calls
143         (bool success, bytes memory returndata) = target.staticcall(data);
144         return _verifyCallResult(success, returndata, errorMessage);
145     }
146 
147     /**
148      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
149      * but performing a delegate call.
150      *
151      * _Available since v3.4._
152      */
153     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
154         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
155     }
156 
157     /**
158      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
159      * but performing a delegate call.
160      *
161      * _Available since v3.4._
162      */
163     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
164         require(isContract(target), "Address: delegate call to non-contract");
165 
166         // solhint-disable-next-line avoid-low-level-calls
167         (bool success, bytes memory returndata) = target.delegatecall(data);
168         return _verifyCallResult(success, returndata, errorMessage);
169     }
170 
171     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
172         if (success) {
173             return returndata;
174         } else {
175             // Look for revert reason and bubble it up if present
176             if (returndata.length > 0) {
177                 // The easiest way to bubble the revert reason is using memory via assembly
178 
179                 // solhint-disable-next-line no-inline-assembly
180                 assembly {
181                     let returndata_size := mload(returndata)
182                     revert(add(32, returndata), returndata_size)
183                 }
184             } else {
185                 revert(errorMessage);
186             }
187         }
188     }
189 }
190 
191 /**
192  * @dev Interface of the ERC20 standard as defined in the EIP.
193  */
194 interface IERC20 {
195     /**
196      * @dev Returns the amount of tokens in existence.
197      */
198     function totalSupply() external view returns (uint256);
199 
200     /**
201      * @dev Returns the amount of tokens owned by `account`.
202      */
203     function balanceOf(address account) external view returns (uint256);
204 
205     /**
206      * @dev Moves `amount` tokens from the caller's account to `recipient`.
207      *
208      * Returns a boolean value indicating whether the operation succeeded.
209      *
210      * Emits a {Transfer} event.
211      */
212     function transfer(address recipient, uint256 amount) external returns (bool);
213 
214     /**
215      * @dev Returns the remaining number of tokens that `spender` will be
216      * allowed to spend on behalf of `owner` through {transferFrom}. This is
217      * zero by default.
218      *
219      * This value changes when {approve} or {transferFrom} are called.
220      */
221     function allowance(address owner, address spender) external view returns (uint256);
222 
223     /**
224      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
225      *
226      * Returns a boolean value indicating whether the operation succeeded.
227      *
228      * IMPORTANT: Beware that changing an allowance with this method brings the risk
229      * that someone may use both the old and the new allowance by unfortunate
230      * transaction ordering. One possible solution to mitigate this race
231      * condition is to first reduce the spender's allowance to 0 and set the
232      * desired value afterwards:
233      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
234      *
235      * Emits an {Approval} event.
236      */
237     function approve(address spender, uint256 amount) external returns (bool);
238 
239     /**
240      * @dev Moves `amount` tokens from `sender` to `recipient` using the
241      * allowance mechanism. `amount` is then deducted from the caller's
242      * allowance.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Emitted when `value` tokens are moved from one account (`from`) to
252      * another (`to`).
253      *
254      * Note that `value` may be zero.
255      */
256     event Transfer(address indexed from, address indexed to, uint256 value);
257 
258     /**
259      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
260      * a call to {approve}. `value` is the new allowance.
261      */
262     event Approval(address indexed owner, address indexed spender, uint256 value);
263 }
264 
265 /**
266  * @dev Contract module which provides a basic access control mechanism, where
267  * there is an account (an owner) that can be granted exclusive access to
268  * specific functions.
269  *
270  * By default, the owner account will be the one that deploys the contract. This
271  * can later be changed with {transferOwnership}.
272  *
273  * This module is used through inheritance. It will make available the modifier
274  * `onlyOwner`, which can be applied to your functions to restrict their use to
275  * the owner.
276  */
277 contract OwnableData {
278     address public owner;
279     address public pendingOwner;
280 }
281 
282 abstract contract Ownable is OwnableData {
283     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285     constructor () {
286         owner = msg.sender;
287         emit OwnershipTransferred(address(0), msg.sender);
288     }
289 
290     function transferOwnership(address newOwner, bool direct, bool renounce) public onlyOwner {
291         if (direct) {
292 
293             require(newOwner != address(0) || renounce, "Ownable: zero address");
294 
295             emit OwnershipTransferred(owner, newOwner);
296             owner = newOwner;
297         } else {
298             pendingOwner = newOwner;
299         }
300     }
301 
302     function claimOwnership() public {
303         address _pendingOwner = pendingOwner;
304 
305         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
306 
307         emit OwnershipTransferred(owner, _pendingOwner);
308         owner = _pendingOwner;
309         pendingOwner = address(0);
310     }
311 
312     modifier onlyOwner() {
313         require(msg.sender == owner, "Ownable: caller is not the owner");
314         _;
315     }
316 }
317 
318 /**
319  * @title SafeERC20
320  * @dev Wrappers around ERC20 operations that throw on failure (when the token
321  * contract returns false). Tokens that return no value (and instead revert or
322  * throw on failure) are also supported, non-reverting calls are assumed to be
323  * successful.
324  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
325  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
326  */
327 library SafeERC20 {
328     using Address for address;
329 
330     function safeTransfer(IERC20 token, address to, uint256 value) internal {
331         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
332     }
333 
334     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
335         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
336     }
337 
338     /**
339      * @dev Deprecated. This function has issues similar to the ones found in
340      * {IERC20-approve}, and its usage is discouraged.
341      *
342      * Whenever possible, use {safeIncreaseAllowance} and
343      * {safeDecreaseAllowance} instead.
344      */
345     function safeApprove(IERC20 token, address spender, uint256 value) internal {
346         // safeApprove should only be called when setting an initial allowance,
347         // or when resetting it to zero. To increase and decrease it, use
348         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
349         // solhint-disable-next-line max-line-length
350         require((value == 0) || (token.allowance(address(this), spender) == 0),
351             "SafeERC20: approve from non-zero to non-zero allowance"
352         );
353         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
354     }
355 
356     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
357         uint256 newAllowance = token.allowance(address(this), spender) + value;
358         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
359     }
360 
361     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
362         unchecked {
363             uint256 oldAllowance = token.allowance(address(this), spender);
364             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
365             uint256 newAllowance = oldAllowance - value;
366             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
367         }
368     }
369 
370     /**
371      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
372      * on the return value: the return value is optional (but if data is returned, it must not be false).
373      * @param token The token targeted by the call.
374      * @param data The call data (encoded using abi.encode or one of its variants).
375      */
376     function _callOptionalReturn(IERC20 token, bytes memory data) private {
377         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
378         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
379         // the target address contains contract code and also asserts for success in the low-level call.
380 
381         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
382         if (returndata.length > 0) { // Return data is optional
383             // solhint-disable-next-line max-line-length
384             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
385         }
386     }
387 }
388 // Sorbettiere is a "semifredo of popsicle stand" this contract is created to provide single side farm for IFO of Popsicle Finance.
389 // The contract is based on famous Masterchef contract (Ty guys for that)
390 // It intakes one token and allows the user to farm another token. Due to the crosschain nature of Popsicle Stand we've swapped reward per block
391 // to reward per second. Moreover, we've implemented safe transfer of reward instead of mint in Masterchef.
392 // Future is crosschain...
393 
394 // The contract is ownable untill the DAO will be able to take over. Popsicle community shows that DAO is coming soon.
395 // And the contract ownership will be transferred to other contract
396 contract Sorbettiere is Ownable {
397     using SafeERC20 for IERC20;
398     // Info of each user.
399     struct UserInfo {
400         uint256 amount; // How many LP tokens the user has provided.
401         uint256 rewardDebt; // Reward debt. See explanation below.
402         uint256 remainingIceTokenReward;  // ICE Tokens that weren't distributed for user per pool.
403         //
404         // We do some fancy math here. Basically, any point in time, the amount of ICE
405         // entitled to a user but is pending to be distributed is:
406         //
407         //   pending reward = (user.amount * pool.accICEPerShare) - user.rewardDebt
408         //
409         // Whenever a user deposits or withdraws Staked tokens to a pool. Here's what happens:
410         //   1. The pool's `accICEPerShare` (and `lastRewardTime`) gets updated.
411         //   2. User receives the pending reward sent to his/her address.
412         //   3. User's `amount` gets updated.
413         //   4. User's `rewardDebt` gets updated.
414     }
415     // Info of each pool.
416     struct PoolInfo {
417         IERC20 stakingToken; // Contract address of staked token
418         uint256 stakingTokenTotalAmount; //Total amount of deposited tokens
419         uint256 accIcePerShare; // Accumulated ICE per share, times 1e12. See below.
420         uint32 lastRewardTime; // Last timestamp number that ICE distribution occurs.
421         uint16 allocPoint; // How many allocation points assigned to this pool. ICE to distribute per second.
422         
423         
424     }
425     
426     IERC20 immutable public ice; // The ICE TOKEN!!
427     
428     uint256 public icePerSecond; // Ice tokens vested per second.
429     
430     PoolInfo[] public poolInfo; // Info of each pool.
431     
432     mapping(uint256 => mapping(address => UserInfo)) public userInfo; // Info of each user that stakes tokens.
433     
434     uint256 public totalAllocPoint = 0; // Total allocation poitns. Must be the sum of all allocation points in all pools.
435     
436     uint32 immutable public startTime; // The timestamp when ICE farming starts.
437     
438     uint32 public endTime; // Time on which the reward calculation should end
439 
440     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
441     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
442     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
443 
444     constructor(
445         IERC20 _ice,
446         uint256 _icePerSecond,
447         uint32 _startTime
448     ) {
449         ice = _ice;
450         
451         icePerSecond = _icePerSecond;
452         startTime = _startTime;
453         endTime = _startTime + 7 days;
454     }
455     
456     function changeEndTime(uint32 addSeconds) external onlyOwner {
457         endTime += addSeconds;
458     }
459     
460     // Changes Ice token reward per second. Use this function to moderate the `lockup amount`. Essentially this function changes the amount of the reward
461     // which is entitled to the user for his token staking by the time the `endTime` is passed.
462     //Good practice to update pools without messing up the contract
463     function setIcePerSecond(uint256 _icePerSecond,  bool _withUpdate) external onlyOwner {
464         if (_withUpdate) {
465             massUpdatePools();
466         }
467         icePerSecond= _icePerSecond;
468     }
469 // How many pools are in the contract
470     function poolLength() external view returns (uint256) {
471         return poolInfo.length;
472     }
473 
474     // Add a new staking token to the pool. Can only be called by the owner.
475     // VERY IMPORTANT NOTICE 
476     // ----------- DO NOT add the same staking token more than once. Rewards will be messed up if you do. -------------
477     // Good practice to update pools without messing up the contract
478     function add(
479         uint16 _allocPoint,
480         IERC20 _stakingToken,
481         bool _withUpdate
482     ) external onlyOwner {
483         if (_withUpdate) {
484             massUpdatePools();
485         }
486         uint256 lastRewardTime =
487             block.timestamp > startTime ? block.timestamp : startTime;
488         totalAllocPoint +=_allocPoint;
489         poolInfo.push(
490             PoolInfo({
491                 stakingToken: _stakingToken,
492                 stakingTokenTotalAmount: 0,
493                 allocPoint: _allocPoint,
494                 lastRewardTime: uint32(lastRewardTime),
495                 accIcePerShare: 0
496             })
497         );
498     }
499 
500     // Update the given pool's ICE allocation point. Can only be called by the owner.
501     // Good practice to update pools without messing up the contract
502     function set(
503         uint256 _pid,
504         uint16 _allocPoint,
505         bool _withUpdate
506     ) external onlyOwner {
507         if (_withUpdate) {
508             massUpdatePools();
509         }
510         totalAllocPoint = totalAllocPoint - poolInfo[_pid].allocPoint + _allocPoint;
511         poolInfo[_pid].allocPoint = _allocPoint;
512     }
513 
514     // Return reward multiplier over the given _from to _to time.
515     function getMultiplier(uint256 _from, uint256 _to)
516         public
517         view
518         returns (uint256)
519     {
520         _from = _from > startTime ? _from : startTime;
521         if (_from > endTime || _to < startTime) {
522             return 0;
523         }
524         if (_to > endTime) {
525             return endTime - _from;
526         }
527         return _to - _from;
528     }
529 
530     // View function to see pending ICE on frontend.
531     function pendingIce(uint256 _pid, address _user)
532         external
533         view
534         returns (uint256)
535     {
536         PoolInfo storage pool = poolInfo[_pid];
537         UserInfo storage user = userInfo[_pid][_user];
538         uint256 accIcePerShare = pool.accIcePerShare;
539        
540         if (block.timestamp > pool.lastRewardTime && pool.stakingTokenTotalAmount != 0) {
541             uint256 multiplier =
542                 getMultiplier(pool.lastRewardTime, block.timestamp);
543             uint256 iceReward =
544                 multiplier * icePerSecond * pool.allocPoint / totalAllocPoint;
545             accIcePerShare += iceReward * 1e12 / pool.stakingTokenTotalAmount;
546         }
547         return user.amount * accIcePerShare / 1e12 - user.rewardDebt + user.remainingIceTokenReward;
548     }
549 
550     // Update reward vairables for all pools. Be careful of gas spending!
551     function massUpdatePools() public {
552         uint256 length = poolInfo.length;
553         for (uint256 pid = 0; pid < length; ++pid) {
554             updatePool(pid);
555         }
556     }
557 
558     // Update reward variables of the given pool to be up-to-date.
559     function updatePool(uint256 _pid) public {
560         PoolInfo storage pool = poolInfo[_pid];
561         if (block.timestamp <= pool.lastRewardTime) {
562             return;
563         }
564 
565         if (pool.stakingTokenTotalAmount == 0) {
566             pool.lastRewardTime = uint32(block.timestamp);
567             return;
568         }
569         uint256 multiplier = getMultiplier(pool.lastRewardTime, block.timestamp);
570         uint256 iceReward =
571             multiplier * icePerSecond * pool.allocPoint / totalAllocPoint;
572         pool.accIcePerShare += iceReward * 1e12 / pool.stakingTokenTotalAmount;
573         pool.lastRewardTime = uint32(block.timestamp);
574     }
575 
576     // Deposit staking tokens to Sorbettiere for ICE allocation.
577     function deposit(uint256 _pid, uint256 _amount) public {
578         PoolInfo storage pool = poolInfo[_pid];
579         UserInfo storage user = userInfo[_pid][msg.sender];
580         updatePool(_pid);
581         if (user.amount > 0) {
582             uint256 pending =
583                 user.amount * pool.accIcePerShare / 1e12 - user.rewardDebt + user.remainingIceTokenReward;
584             user.remainingIceTokenReward = safeRewardTransfer(msg.sender, pending);
585         }
586         pool.stakingToken.safeTransferFrom(
587             address(msg.sender),
588             address(this),
589             _amount
590         );
591         user.amount += _amount;
592         pool.stakingTokenTotalAmount += _amount;
593         user.rewardDebt = user.amount * pool.accIcePerShare / 1e12;
594         emit Deposit(msg.sender, _pid, _amount);
595     }
596 
597     // Withdraw staked tokens from Sorbettiere.
598     function withdraw(uint256 _pid, uint256 _amount) public {
599         PoolInfo storage pool = poolInfo[_pid];
600         UserInfo storage user = userInfo[_pid][msg.sender];
601         require(user.amount >= _amount, "Sorbettiere: you cant eat that much popsicles");
602         updatePool(_pid);
603         uint256 pending =
604             user.amount * pool.accIcePerShare / 1e12 - user.rewardDebt + user.remainingIceTokenReward;
605         user.remainingIceTokenReward = safeRewardTransfer(msg.sender, pending);
606         user.amount -= _amount;
607         pool.stakingTokenTotalAmount -= _amount;
608         user.rewardDebt = user.amount * pool.accIcePerShare / 1e12;
609         pool.stakingToken.safeTransfer(address(msg.sender), _amount);
610         emit Withdraw(msg.sender, _pid, _amount);
611     }
612     
613     // Withdraw without caring about rewards. EMERGENCY ONLY.
614     function emergencyWithdraw(uint256 _pid) public {
615         PoolInfo storage pool = poolInfo[_pid];
616         UserInfo storage user = userInfo[_pid][msg.sender];
617         uint256 userAmount = user.amount;
618         pool.stakingTokenTotalAmount -= userAmount;
619         delete userInfo[_pid][msg.sender];
620         pool.stakingToken.safeTransfer(address(msg.sender), userAmount);
621         emit EmergencyWithdraw(msg.sender, _pid, userAmount);
622     }
623 
624     // Safe ice transfer function. Just in case if the pool does not have enough ICE token,
625     // The function returns the amount which is owed to the user
626     function safeRewardTransfer(address _to, uint256 _amount) internal returns(uint256) {
627         uint256 iceTokenBalance = ice.balanceOf(address(this));
628         if (iceTokenBalance == 0) { //save some gas fee
629             return _amount;
630         }
631         if (_amount > iceTokenBalance) { //save some gas fee
632             ice.safeTransfer(_to, iceTokenBalance);
633             return _amount - iceTokenBalance;
634         }
635         ice.safeTransfer(_to, _amount);
636         return 0;
637     }
638 }