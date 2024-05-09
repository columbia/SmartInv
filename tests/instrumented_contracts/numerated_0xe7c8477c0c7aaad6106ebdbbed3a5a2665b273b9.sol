1 // SPDX-License-Identifier: MIT
2 
3 /*
4  *       $$$$$$_$$__$$__$$$$__$$$$$$
5  *       ____$$_$$__$$_$$_______$$
6  *       ____$$_$$__$$__$$$$____$$
7  *       $$__$$_$$__$$_____$$___$$
8  *       _$$$$___$$$$___$$$$____$$
9  *
10  *       $$__$$_$$$$$$_$$$$$__$$_____$$$$$
11  *       _$$$$____$$___$$_____$$_____$$__$$
12  *       __$$_____$$___$$$$___$$_____$$__$$
13  *       __$$_____$$___$$_____$$_____$$__$$
14  *       __$$___$$$$$$_$$$$$__$$$$$$_$$$$$
15  *
16  *       $$___$_$$$$$$_$$$$$$_$$__$$
17  *       $$___$___$$_____$$___$$__$$
18  *       $$_$_$___$$_____$$___$$$$$$
19  *       $$$$$$___$$_____$$___$$__$$
20  *       _$$_$$_$$$$$$___$$___$$__$$
21  *
22  *       $$__$$_$$$$$__$$
23  *       _$$$$__$$_____$$
24  *       __$$___$$$$___$$
25  *       __$$___$$_____$$
26  *       __$$___$$$$$__$$$$$$
27  */
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev Collection of functions related to the address type
33  */
34 library Address {
35     /**
36      * @dev Returns true if `account` is a contract.
37      *
38      * [IMPORTANT]
39      * ====
40      * It is unsafe to assume that an address for which this function returns
41      * false is an externally-owned account (EOA) and not a contract.
42      *
43      * Among others, `isContract` will return false for the following
44      * types of addresses:
45      *
46      *  - an externally-owned account
47      *  - a contract in construction
48      *  - an address where a contract will be created
49      *  - an address where a contract lived, but was destroyed
50      * ====
51      */
52     function isContract(address account) internal view returns (bool) {
53         // This method relies on extcodesize, which returns 0 for contracts in
54         // construction, since the code is only stored at the end of the
55         // constructor execution.
56 
57         uint256 size;
58         // solhint-disable-next-line no-inline-assembly
59         assembly { size := extcodesize(account) }
60         return size > 0;
61     }
62 
63     /**
64      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
65      * `recipient`, forwarding all available gas and reverting on errors.
66      *
67      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
68      * of certain opcodes, possibly making contracts go over the 2300 gas limit
69      * imposed by `transfer`, making them unable to receive funds via
70      * `transfer`. {sendValue} removes this limitation.
71      *
72      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
73      *
74      * IMPORTANT: because control is transferred to `recipient`, care must be
75      * taken to not create reentrancy vulnerabilities. Consider using
76      * {ReentrancyGuard} or the
77      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
78      */
79     function sendValue(address payable recipient, uint256 amount) internal {
80         require(address(this).balance >= amount, "Address: insufficient balance");
81 
82         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
83         (bool success, ) = recipient.call{ value: amount }("");
84         require(success, "Address: unable to send value, recipient may have reverted");
85     }
86 
87     /**
88      * @dev Performs a Solidity function call using a low level `call`. A
89      * plain`call` is an unsafe replacement for a function call: use this
90      * function instead.
91      *
92      * If `target` reverts with a revert reason, it is bubbled up by this
93      * function (like regular Solidity function calls).
94      *
95      * Returns the raw returned data. To convert to the expected return value,
96      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
97      *
98      * Requirements:
99      *
100      * - `target` must be a contract.
101      * - calling `target` with `data` must not revert.
102      *
103      * _Available since v3.1._
104      */
105     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
106         return functionCall(target, data, "Address: low-level call failed");
107     }
108 
109     /**
110      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
111      * `errorMessage` as a fallback revert reason when `target` reverts.
112      *
113      * _Available since v3.1._
114      */
115     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, 0, errorMessage);
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
121      * but also transferring `value` wei to `target`.
122      *
123      * Requirements:
124      *
125      * - the calling contract must have an ETH balance of at least `value`.
126      * - the called Solidity function must be `payable`.
127      *
128      * _Available since v3.1._
129      */
130     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
136      * with `errorMessage` as a fallback revert reason when `target` reverts.
137      *
138      * _Available since v3.1._
139      */
140     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
141         require(address(this).balance >= value, "Address: insufficient balance for call");
142         require(isContract(target), "Address: call to non-contract");
143 
144         // solhint-disable-next-line avoid-low-level-calls
145         (bool success, bytes memory returndata) = target.call{ value: value }(data);
146         return _verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
156         return functionStaticCall(target, data, "Address: low-level static call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
161      * but performing a static call.
162      *
163      * _Available since v3.3._
164      */
165     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
166         require(isContract(target), "Address: static call to non-contract");
167 
168         // solhint-disable-next-line avoid-low-level-calls
169         (bool success, bytes memory returndata) = target.staticcall(data);
170         return _verifyCallResult(success, returndata, errorMessage);
171     }
172 
173     /**
174      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
175      * but performing a delegate call.
176      *
177      * _Available since v3.4._
178      */
179     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
180         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
185      * but performing a delegate call.
186      *
187      * _Available since v3.4._
188      */
189     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
190         require(isContract(target), "Address: delegate call to non-contract");
191 
192         // solhint-disable-next-line avoid-low-level-calls
193         (bool success, bytes memory returndata) = target.delegatecall(data);
194         return _verifyCallResult(success, returndata, errorMessage);
195     }
196 
197     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
198         if (success) {
199             return returndata;
200         } else {
201             // Look for revert reason and bubble it up if present
202             if (returndata.length > 0) {
203                 // The easiest way to bubble the revert reason is using memory via assembly
204 
205                 // solhint-disable-next-line no-inline-assembly
206                 assembly {
207                     let returndata_size := mload(returndata)
208                     revert(add(32, returndata), returndata_size)
209                 }
210             } else {
211                 revert(errorMessage);
212             }
213         }
214     }
215 }
216 
217 /**
218  * @dev Interface of the ERC20 standard as defined in the EIP.
219  */
220 interface IERC20 {
221     /**
222      * @dev Returns the amount of tokens in existence.
223      */
224     function totalSupply() external view returns (uint256);
225 
226     /**
227      * @dev Returns the amount of tokens owned by `account`.
228      */
229     function balanceOf(address account) external view returns (uint256);
230 
231     /**
232      * @dev Moves `amount` tokens from the caller's account to `recipient`.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transfer(address recipient, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Returns the remaining number of tokens that `spender` will be
242      * allowed to spend on behalf of `owner` through {transferFrom}. This is
243      * zero by default.
244      *
245      * This value changes when {approve} or {transferFrom} are called.
246      */
247     function allowance(address owner, address spender) external view returns (uint256);
248 
249     /**
250      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
251      *
252      * Returns a boolean value indicating whether the operation succeeded.
253      *
254      * IMPORTANT: Beware that changing an allowance with this method brings the risk
255      * that someone may use both the old and the new allowance by unfortunate
256      * transaction ordering. One possible solution to mitigate this race
257      * condition is to first reduce the spender's allowance to 0 and set the
258      * desired value afterwards:
259      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address spender, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Moves `amount` tokens from `sender` to `recipient` using the
267      * allowance mechanism. `amount` is then deducted from the caller's
268      * allowance.
269      *
270      * Returns a boolean value indicating whether the operation succeeded.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Emitted when `value` tokens are moved from one account (`from`) to
278      * another (`to`).
279      *
280      * Note that `value` may be zero.
281      */
282     event Transfer(address indexed from, address indexed to, uint256 value);
283 
284     /**
285      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
286      * a call to {approve}. `value` is the new allowance.
287      */
288     event Approval(address indexed owner, address indexed spender, uint256 value);
289 }
290 
291 /**
292  * @dev Contract module which provides a basic access control mechanism, where
293  * there is an account (an owner) that can be granted exclusive access to
294  * specific functions.
295  *
296  * By default, the owner account will be the one that deploys the contract. This
297  * can later be changed with {transferOwnership}.
298  *
299  * This module is used through inheritance. It will make available the modifier
300  * `onlyOwner`, which can be applied to your functions to restrict their use to
301  * the owner.
302  */
303 contract OwnableData {
304     address public owner;
305     address public pendingOwner;
306 }
307 
308 abstract contract Ownable is OwnableData {
309     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
310 
311     constructor () {
312         owner = 0x4e5b3043FEB9f939448e2F791a66C4EA65A315a8;
313         emit OwnershipTransferred(address(0), owner);
314     }
315 
316     function transferOwnership(address newOwner, bool direct, bool renounce) public onlyOwner {
317         if (direct) {
318 
319             require(newOwner != address(0) || renounce, "Ownable: zero address");
320 
321             emit OwnershipTransferred(owner, newOwner);
322             owner = newOwner;
323         } else {
324             pendingOwner = newOwner;
325         }
326     }
327 
328     function claimOwnership() public {
329         address _pendingOwner = pendingOwner;
330 
331         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
332 
333         emit OwnershipTransferred(owner, _pendingOwner);
334         owner = _pendingOwner;
335         pendingOwner = address(0);
336     }
337 
338     modifier onlyOwner() {
339         require(msg.sender == owner, "Ownable: caller is not the owner");
340         _;
341     }
342 }
343 
344 /**
345  * @title SafeERC20
346  * @dev Wrappers around ERC20 operations that throw on failure (when the token
347  * contract returns false). Tokens that return no value (and instead revert or
348  * throw on failure) are also supported, non-reverting calls are assumed to be
349  * successful.
350  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
351  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
352  */
353 library SafeERC20 {
354     using Address for address;
355 
356     function safeTransfer(IERC20 token, address to, uint256 value) internal {
357         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
358     }
359 
360     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
361         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
362     }
363 
364     /**
365      * @dev Deprecated. This function has issues similar to the ones found in
366      * {IERC20-approve}, and its usage is discouraged.
367      *
368      * Whenever possible, use {safeIncreaseAllowance} and
369      * {safeDecreaseAllowance} instead.
370      */
371     function safeApprove(IERC20 token, address spender, uint256 value) internal {
372         // safeApprove should only be called when setting an initial allowance,
373         // or when resetting it to zero. To increase and decrease it, use
374         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
375         // solhint-disable-next-line max-line-length
376         require((value == 0) || (token.allowance(address(this), spender) == 0),
377             "SafeERC20: approve from non-zero to non-zero allowance"
378         );
379         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
380     }
381 
382     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
383         uint256 newAllowance = token.allowance(address(this), spender) + value;
384         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
385     }
386 
387     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
388         unchecked {
389             uint256 oldAllowance = token.allowance(address(this), spender);
390             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
391             uint256 newAllowance = oldAllowance - value;
392             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
393         }
394     }
395 
396     /**
397      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
398      * on the return value: the return value is optional (but if data is returned, it must not be false).
399      * @param token The token targeted by the call.
400      * @param data The call data (encoded using abi.encode or one of its variants).
401      */
402     function _callOptionalReturn(IERC20 token, bytes memory data) private {
403         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
404         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
405         // the target address contains contract code and also asserts for success in the low-level call.
406 
407         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
408         if (returndata.length > 0) { // Return data is optional
409             // solhint-disable-next-line max-line-length
410             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
411         }
412     }
413 }
414 
415 // Genetic & Genome intakes one token and allows the user to farm another token.
416 
417 contract GeneticAndGenome is Ownable {
418     using SafeERC20 for IERC20;
419     // Info of each user.
420     struct UserInfo {
421         uint256 amount; // How many tokens the user has provided.
422         uint256 rewardDebt; // Reward debt. See explanation below.
423         uint256 remainingYelTokenReward;  // YEL Tokens that weren't distributed for user per pool.
424         //
425         // Any point in time, the amount of YEL entitled to a user but is pending to be distributed is:
426         // pending reward = (user.amount * pool.accYELPerShare) - user.rewardDebt
427         //
428         // Whenever a user deposits or withdraws Staked tokens to a pool. Here's what happens:
429         //   1. The pool's `accYELPerShare` (and `lastRewardTime`) gets updated.
430         //   2. User receives the pending reward sent to his/her address.
431         //   3. User's `amount` gets updated.
432         //   4. User's `rewardDebt` gets updated.
433     }
434     // Info of each pool.
435     struct PoolInfo {
436         IERC20 stakingToken; // Contract address of staked token
437         uint256 stakingTokenTotalAmount; //Total amount of deposited tokens
438         uint256 accYelPerShare; // Accumulated YEL per share, times 1e12. See below.
439         uint32 lastRewardTime; // Last timestamp number that YEL distribution occurs.
440         uint16 allocPoint; // How many allocation points assigned to this pool. YEL to distribute per second.
441     }
442     
443     IERC20 immutable public yel; // The YEL token
444     
445     uint256 public yelPerSecond; // YEL tokens vested per second.
446     
447     PoolInfo[] public poolInfo; // Info of each pool.
448     
449     mapping(uint256 => mapping(address => UserInfo)) public userInfo; // Info of each user that stakes tokens.
450     
451     uint256 public totalAllocPoint = 0; // Total allocation points. Must be the sum of all allocation points in all pools.
452     
453     uint32 immutable public startTime; // The timestamp when YEL farming starts.
454     
455     uint32 public endTime; // Time on which the reward calculation should end
456 
457     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
458     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
459     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
460 
461     constructor(
462         IERC20 _yel,
463         uint256 _yelPerSecond,
464         uint32 _startTime
465     ) {
466         yel = _yel;
467 
468         yelPerSecond = _yelPerSecond;
469         startTime = _startTime;
470         endTime = _startTime + 7 days;
471     }
472     
473     function changeEndTime(uint32 addSeconds) external onlyOwner {
474         endTime += addSeconds;
475     }
476     
477     // Changes YEL token reward per second. Use this function to moderate the `lockup amount`.
478     // Essentially this function changes the amount of the reward which is entitled to the user
479     // for his token staking by the time the `endTime` is passed.
480     // Good practice to update pools without messing up the contract
481     function setYelPerSecond(uint256 _yelPerSecond,  bool _withUpdate) external onlyOwner {
482         if (_withUpdate) {
483             massUpdatePools();
484         }
485         yelPerSecond= _yelPerSecond;
486     }
487 
488     // How many pools are in the contract
489     function poolLength() external view returns (uint256) {
490         return poolInfo.length;
491     }
492 
493     // Add a new staking token to the pool. Can only be called by the owner.
494     // VERY IMPORTANT NOTICE 
495     // ----------- DO NOT add the same staking token more than once. Rewards will be messed up if you do. -------------
496     // Good practice to update pools without messing up the contract
497     function add(
498         uint16 _allocPoint,
499         IERC20 _stakingToken,
500         bool _withUpdate
501     ) external onlyOwner {
502         if (_withUpdate) {
503             massUpdatePools();
504         }
505         uint256 lastRewardTime =
506             block.timestamp > startTime ? block.timestamp : startTime;
507         totalAllocPoint +=_allocPoint;
508         poolInfo.push(
509             PoolInfo({
510                 stakingToken: _stakingToken,
511                 stakingTokenTotalAmount: 0,
512                 allocPoint: _allocPoint,
513                 lastRewardTime: uint32(lastRewardTime),
514                 accYelPerShare: 0
515             })
516         );
517     }
518 
519     // Update the given pool's YEL allocation point. Can only be called by the owner.
520     // Good practice to update pools without messing up the contract
521     function set(
522         uint256 _pid,
523         uint16 _allocPoint,
524         bool _withUpdate
525     ) external onlyOwner {
526         if (_withUpdate) {
527             massUpdatePools();
528         }
529         totalAllocPoint = totalAllocPoint - poolInfo[_pid].allocPoint + _allocPoint;
530         poolInfo[_pid].allocPoint = _allocPoint;
531     }
532 
533     // Return reward multiplier over the given _from to _to time.
534     function getMultiplier(uint256 _from, uint256 _to)
535         public
536         view
537         returns (uint256)
538     {
539         _from = _from > startTime ? _from : startTime;
540         if (_from > endTime || _to < startTime) {
541             return 0;
542         }
543         if (_to > endTime) {
544             return endTime - _from;
545         }
546         return _to - _from;
547     }
548 
549     // View function to see pending YEL on frontend.
550     function pendingYel(uint256 _pid, address _user)
551         external
552         view
553         returns (uint256)
554     {
555         PoolInfo storage pool = poolInfo[_pid];
556         UserInfo storage user = userInfo[_pid][_user];
557         uint256 accYelPerShare = pool.accYelPerShare;
558        
559         if (block.timestamp > pool.lastRewardTime && pool.stakingTokenTotalAmount != 0) {
560             uint256 multiplier =
561                 getMultiplier(pool.lastRewardTime, block.timestamp);
562             uint256 yelReward =
563                 multiplier * yelPerSecond * pool.allocPoint / totalAllocPoint;
564             accYelPerShare += yelReward * 1e12 / pool.stakingTokenTotalAmount;
565         }
566         return user.amount * accYelPerShare / 1e12 - user.rewardDebt + user.remainingYelTokenReward;
567     }
568 
569     // Update reward variables for all pools. Be careful of gas spending!
570     function massUpdatePools() public {
571         uint256 length = poolInfo.length;
572         for (uint256 pid = 0; pid < length; ++pid) {
573             updatePool(pid);
574         }
575     }
576 
577     // Update reward variables of the given pool to be up-to-date.
578     function updatePool(uint256 _pid) public {
579         PoolInfo storage pool = poolInfo[_pid];
580         if (block.timestamp <= pool.lastRewardTime) {
581             return;
582         }
583 
584         if (pool.stakingTokenTotalAmount == 0) {
585             pool.lastRewardTime = uint32(block.timestamp);
586             return;
587         }
588         uint256 multiplier = getMultiplier(pool.lastRewardTime, block.timestamp);
589         uint256 yelReward =
590             multiplier * yelPerSecond * pool.allocPoint / totalAllocPoint;
591         pool.accYelPerShare += yelReward * 1e12 / pool.stakingTokenTotalAmount;
592         pool.lastRewardTime = uint32(block.timestamp);
593     }
594 
595     // Deposit staking tokens to Genetic & Genome for YEL allocation.
596     function deposit(uint256 _pid, uint256 _amount) public {
597         PoolInfo storage pool = poolInfo[_pid];
598         UserInfo storage user = userInfo[_pid][msg.sender];
599         updatePool(_pid);
600         if (user.amount > 0) {
601             uint256 pending =
602                 user.amount * pool.accYelPerShare / 1e12 - user.rewardDebt + user.remainingYelTokenReward;
603             user.remainingYelTokenReward = safeRewardTransfer(msg.sender, pending);
604         }
605         pool.stakingToken.safeTransferFrom(
606             address(msg.sender),
607             address(this),
608             _amount
609         );
610         user.amount += _amount;
611         pool.stakingTokenTotalAmount += _amount;
612         user.rewardDebt = user.amount * pool.accYelPerShare / 1e12;
613         emit Deposit(msg.sender, _pid, _amount);
614     }
615 
616     // Withdraw staked tokens from Genetic & Genome.
617     function withdraw(uint256 _pid, uint256 _amount) public {
618         PoolInfo storage pool = poolInfo[_pid];
619         UserInfo storage user = userInfo[_pid][msg.sender];
620         require(user.amount >= _amount, "Genetic & Genome: you do not have enough tokens to complete this operation");
621         updatePool(_pid);
622         uint256 pending =
623             user.amount * pool.accYelPerShare / 1e12 - user.rewardDebt + user.remainingYelTokenReward;
624         user.remainingYelTokenReward = safeRewardTransfer(msg.sender, pending);
625         user.amount -= _amount;
626         pool.stakingTokenTotalAmount -= _amount;
627         user.rewardDebt = user.amount * pool.accYelPerShare / 1e12;
628         pool.stakingToken.safeTransfer(address(msg.sender), _amount);
629         emit Withdraw(msg.sender, _pid, _amount);
630     }
631     
632     // Withdraw without caring about rewards. EMERGENCY ONLY.
633     function emergencyWithdraw(uint256 _pid) public {
634         PoolInfo storage pool = poolInfo[_pid];
635         UserInfo storage user = userInfo[_pid][msg.sender];
636         uint256 userAmount = user.amount;
637         pool.stakingTokenTotalAmount -= userAmount;
638         user.amount = 0;
639         user.rewardDebt = 0;
640         user.remainingYelTokenReward = 0;
641         pool.stakingToken.safeTransfer(address(msg.sender), userAmount);
642         emit EmergencyWithdraw(msg.sender, _pid, userAmount);
643     }
644 
645     // Safe YEL transfer function. Just in case if the pool does not have enough YEL token,
646     // The function returns the amount which is owed to the user
647     function safeRewardTransfer(address _to, uint256 _amount) internal returns(uint256) {
648         uint256 yelTokenBalance = yel.balanceOf(address(this));
649         if (_amount > yelTokenBalance) {
650             yel.safeTransfer(_to, yelTokenBalance);
651             return _amount - yelTokenBalance;
652         }
653         yel.safeTransfer(_to, _amount);
654         return 0;
655     }
656 }