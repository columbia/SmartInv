1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Collection of functions related to the address type
28  */
29 library Address {
30     /**
31      * @dev Returns true if `account` is a contract.
32      *
33      * [IMPORTANT]
34      * ====
35      * It is unsafe to assume that an address for which this function returns
36      * false is an externally-owned account (EOA) and not a contract.
37      *
38      * Among others, `isContract` will return false for the following
39      * types of addresses:
40      *
41      *  - an externally-owned account
42      *  - a contract in construction
43      *  - an address where a contract will be created
44      *  - an address where a contract lived, but was destroyed
45      * ====
46      */
47     function isContract(address account) internal view returns (bool) {
48         // This method relies on extcodesize, which returns 0 for contracts in
49         // construction, since the code is only stored at the end of the
50         // constructor execution.
51 
52         uint256 size;
53         // solhint-disable-next-line no-inline-assembly
54         assembly { size := extcodesize(account) }
55         return size > 0;
56     }
57 
58     /**
59      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
60      * `recipient`, forwarding all available gas and reverting on errors.
61      *
62      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
63      * of certain opcodes, possibly making contracts go over the 2300 gas limit
64      * imposed by `transfer`, making them unable to receive funds via
65      * `transfer`. {sendValue} removes this limitation.
66      *
67      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
68      *
69      * IMPORTANT: because control is transferred to `recipient`, care must be
70      * taken to not create reentrancy vulnerabilities. Consider using
71      * {ReentrancyGuard} or the
72      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
73      */
74     function sendValue(address payable recipient, uint256 amount) internal {
75         require(address(this).balance >= amount, "Address: insufficient balance");
76 
77         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
78         (bool success, ) = recipient.call{ value: amount }("");
79         require(success, "Address: unable to send value, recipient may have reverted");
80     }
81 
82     /**
83      * @dev Performs a Solidity function call using a low level `call`. A
84      * plain`call` is an unsafe replacement for a function call: use this
85      * function instead.
86      *
87      * If `target` reverts with a revert reason, it is bubbled up by this
88      * function (like regular Solidity function calls).
89      *
90      * Returns the raw returned data. To convert to the expected return value,
91      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
92      *
93      * Requirements:
94      *
95      * - `target` must be a contract.
96      * - calling `target` with `data` must not revert.
97      *
98      * _Available since v3.1._
99      */
100     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
101       return functionCall(target, data, "Address: low-level call failed");
102     }
103 
104     /**
105      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
106      * `errorMessage` as a fallback revert reason when `target` reverts.
107      *
108      * _Available since v3.1._
109      */
110     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
111         return functionCallWithValue(target, data, 0, errorMessage);
112     }
113 
114     /**
115      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
116      * but also transferring `value` wei to `target`.
117      *
118      * Requirements:
119      *
120      * - the calling contract must have an ETH balance of at least `value`.
121      * - the called Solidity function must be `payable`.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
126         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
127     }
128 
129     /**
130      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
131      * with `errorMessage` as a fallback revert reason when `target` reverts.
132      *
133      * _Available since v3.1._
134      */
135     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
136         require(address(this).balance >= value, "Address: insufficient balance for call");
137         require(isContract(target), "Address: call to non-contract");
138 
139         // solhint-disable-next-line avoid-low-level-calls
140         (bool success, bytes memory returndata) = target.call{ value: value }(data);
141         return _verifyCallResult(success, returndata, errorMessage);
142     }
143 
144     /**
145      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
146      * but performing a static call.
147      *
148      * _Available since v3.3._
149      */
150     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
151         return functionStaticCall(target, data, "Address: low-level static call failed");
152     }
153 
154     /**
155      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
156      * but performing a static call.
157      *
158      * _Available since v3.3._
159      */
160     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
161         require(isContract(target), "Address: static call to non-contract");
162 
163         // solhint-disable-next-line avoid-low-level-calls
164         (bool success, bytes memory returndata) = target.staticcall(data);
165         return _verifyCallResult(success, returndata, errorMessage);
166     }
167 
168     /**
169      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
170      * but performing a delegate call.
171      *
172      * _Available since v3.4._
173      */
174     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
175         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
176     }
177 
178     /**
179      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
180      * but performing a delegate call.
181      *
182      * _Available since v3.4._
183      */
184     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
185         require(isContract(target), "Address: delegate call to non-contract");
186 
187         // solhint-disable-next-line avoid-low-level-calls
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return _verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
193         if (success) {
194             return returndata;
195         } else {
196             // Look for revert reason and bubble it up if present
197             if (returndata.length > 0) {
198                 // The easiest way to bubble the revert reason is using memory via assembly
199 
200                 // solhint-disable-next-line no-inline-assembly
201                 assembly {
202                     let returndata_size := mload(returndata)
203                     revert(add(32, returndata), returndata_size)
204                 }
205             } else {
206                 revert(errorMessage);
207             }
208         }
209     }
210 }
211 
212 /**
213  * @dev Interface of the ERC20 standard as defined in the EIP.
214  */
215 interface IERC20 {
216     /**
217      * @dev Returns the amount of tokens in existence.
218      */
219     function totalSupply() external view returns (uint256);
220 
221     /**
222      * @dev Returns the amount of tokens owned by `account`.
223      */
224     function balanceOf(address account) external view returns (uint256);
225 
226     /**
227      * @dev Moves `amount` tokens from the caller's account to `recipient`.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transfer(address recipient, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Returns the remaining number of tokens that `spender` will be
237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
238      * zero by default.
239      *
240      * This value changes when {approve} or {transferFrom} are called.
241      */
242     function allowance(address owner, address spender) external view returns (uint256);
243 
244     /**
245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
250      * that someone may use both the old and the new allowance by unfortunate
251      * transaction ordering. One possible solution to mitigate this race
252      * condition is to first reduce the spender's allowance to 0 and set the
253      * desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      *
256      * Emits an {Approval} event.
257      */
258     function approve(address spender, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Moves `amount` tokens from `sender` to `recipient` using the
262      * allowance mechanism. `amount` is then deducted from the caller's
263      * allowance.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * Emits a {Transfer} event.
268      */
269     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Emitted when `value` tokens are moved from one account (`from`) to
273      * another (`to`).
274      *
275      * Note that `value` may be zero.
276      */
277     event Transfer(address indexed from, address indexed to, uint256 value);
278 
279     /**
280      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
281      * a call to {approve}. `value` is the new allowance.
282      */
283     event Approval(address indexed owner, address indexed spender, uint256 value);
284 }
285 
286 /**
287  * @dev Contract module which provides a basic access control mechanism, where
288  * there is an account (an owner) that can be granted exclusive access to
289  * specific functions.
290  *
291  * By default, the owner account will be the one that deploys the contract. This
292  * can later be changed with {transferOwnership}.
293  *
294  * This module is used through inheritance. It will make available the modifier
295  * `onlyOwner`, which can be applied to your functions to restrict their use to
296  * the owner.
297  */
298 abstract contract Ownable is Context {
299     address private _owner;
300 
301     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
302 
303     /**
304      * @dev Initializes the contract setting the deployer as the initial owner.
305      */
306     constructor () {
307         address msgSender = _msgSender();
308         _owner = msgSender;
309         emit OwnershipTransferred(address(0), msgSender);
310     }
311 
312     /**
313      * @dev Returns the address of the current owner.
314      */
315     function owner() public view virtual returns (address) {
316         return _owner;
317     }
318 
319     /**
320      * @dev Throws if called by any account other than the owner.
321      */
322     modifier onlyOwner() {
323         require(owner() == _msgSender(), "Ownable: caller is not the owner");
324         _;
325     }
326 
327     /**
328      * @dev Leaves the contract without owner. It will not be possible to call
329      * `onlyOwner` functions anymore. Can only be called by the current owner.
330      *
331      * NOTE: Renouncing ownership will leave the contract without an owner,
332      * thereby removing any functionality that is only available to the owner.
333      */
334     function renounceOwnership() public virtual onlyOwner {
335         emit OwnershipTransferred(_owner, address(0));
336         _owner = address(0);
337     }
338 
339     /**
340      * @dev Transfers ownership of the contract to a new account (`newOwner`).
341      * Can only be called by the current owner.
342      */
343     function transferOwnership(address newOwner) public virtual onlyOwner {
344         require(newOwner != address(0), "Ownable: new owner is the zero address");
345         emit OwnershipTransferred(_owner, newOwner);
346         _owner = newOwner;
347     }
348 }
349 
350 /**
351  * @title SafeERC20
352  * @dev Wrappers around ERC20 operations that throw on failure (when the token
353  * contract returns false). Tokens that return no value (and instead revert or
354  * throw on failure) are also supported, non-reverting calls are assumed to be
355  * successful.
356  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
357  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
358  */
359 library SafeERC20 {
360     using Address for address;
361 
362     function safeTransfer(IERC20 token, address to, uint256 value) internal {
363         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
364     }
365 
366     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
367         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
368     }
369 
370     /**
371      * @dev Deprecated. This function has issues similar to the ones found in
372      * {IERC20-approve}, and its usage is discouraged.
373      *
374      * Whenever possible, use {safeIncreaseAllowance} and
375      * {safeDecreaseAllowance} instead.
376      */
377     function safeApprove(IERC20 token, address spender, uint256 value) internal {
378         // safeApprove should only be called when setting an initial allowance,
379         // or when resetting it to zero. To increase and decrease it, use
380         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
381         // solhint-disable-next-line max-line-length
382         require((value == 0) || (token.allowance(address(this), spender) == 0),
383             "SafeERC20: approve from non-zero to non-zero allowance"
384         );
385         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
386     }
387 
388     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
389         uint256 newAllowance = token.allowance(address(this), spender) + value;
390         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
391     }
392 
393     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
394         unchecked {
395             uint256 oldAllowance = token.allowance(address(this), spender);
396             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
397             uint256 newAllowance = oldAllowance - value;
398             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
399         }
400     }
401 
402     /**
403      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
404      * on the return value: the return value is optional (but if data is returned, it must not be false).
405      * @param token The token targeted by the call.
406      * @param data The call data (encoded using abi.encode or one of its variants).
407      */
408     function _callOptionalReturn(IERC20 token, bytes memory data) private {
409         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
410         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
411         // the target address contains contract code and also asserts for success in the low-level call.
412 
413         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
414         if (returndata.length > 0) { // Return data is optional
415             // solhint-disable-next-line max-line-length
416             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
417         }
418     }
419 }
420 // Sorbettiere is a "semifredo of popsicle stand" this contract is created to provide single side farm for IFO of Popsicle Finance.
421 // The contract is based on famous Masterchef contract (Ty guys for that)
422 // It intakes one token and allows the user to farm another token. Due to the crosschain nature of Popsicle Stand we've swapped reward per block
423 // to reward per second. Moreover, we've implemented safe transfer of reward instead of mint in Masterchef.
424 // Future is crosschain...
425 
426 // The contract is ownable untill the DAO will be able to take over. Popsicle community shows that DAO is coming soon.
427 // And the contract ownership will be transferred to other contract
428 contract Sorbettiere is Ownable {
429     using SafeERC20 for IERC20;
430     // Info of each user.
431     struct UserInfo {
432         uint128 amount; // How many LP tokens the user has provided.
433         uint128 rewardDebt; // Reward debt. See explanation below.
434         uint128 remainingIceTokenReward;  // ICE Tokens that weren't distributed for user per pool.
435         //
436         // We do some fancy math here. Basically, any point in time, the amount of ICE
437         // entitled to a user but is pending to be distributed is:
438         //
439         //   pending reward = (user.amount * pool.accICEPerShare) - user.rewardDebt
440         //
441         // Whenever a user deposits or withdraws Staked tokens to a pool. Here's what happens:
442         //   1. The pool's `accICEPerShare` (and `lastRewardTime`) gets updated.
443         //   2. User receives the pending reward sent to his/her address.
444         //   3. User's `amount` gets updated.
445         //   4. User's `rewardDebt` gets updated.
446     }
447     // Info of each pool.
448     struct PoolInfo {
449         IERC20 stakingToken; // Contract address of staked token
450         uint128 stakingTokenTotalAmount; //Total amount of deposited tokens
451         uint128 accIcePerShare; // Accumulated ICE per share, times 1e12. See below.
452         uint32 lastRewardTime; // Last timestamp number that ICE distribution occurs.
453         uint16 allocPoint; // How many allocation points assigned to this pool. ICE to distribute per second.
454         
455         
456     }
457     
458     IERC20 immutable public ice; // The ICE TOKEN!!
459     
460     uint256 public icePerSecond; // Ice tokens vested per second.
461     
462     PoolInfo[] public poolInfo; // Info of each pool.
463     
464     mapping(uint256 => mapping(address => UserInfo)) public userInfo; // Info of each user that stakes tokens.
465     
466     uint256 public totalAllocPoint = 0; // Total allocation poitns. Must be the sum of all allocation points in all pools.
467     
468     uint32 immutable public startTime; // The timestamp when ICE farming starts.
469     
470     uint32 public endTime; // Time on which the reward calculation should end
471 
472     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
473     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
474     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
475 
476     constructor(
477         IERC20 _ice,
478         uint256 _icePerSecond,
479         uint32 _startTime
480     ) {
481         ice = _ice;
482         
483         icePerSecond = _icePerSecond;
484         startTime = _startTime;
485         endTime = _startTime + 7 days;
486     }
487     
488     function changeEndTime(uint32 addSeconds) external onlyOwner {
489         endTime += addSeconds;
490     }
491     
492     // Changes Ice token reward per second. Use this function to moderate the `lockup amount`. Essentially this function changes the amount of the reward
493     // which is entitled to the user for his token staking by the time the `endTime` is passed.
494     //Good practice to update pools without messing up the contract
495     function setIcePerSecond(uint256 _icePerSecond,  bool _withUpdate) external onlyOwner {
496         if (_withUpdate) {
497             massUpdatePools();
498         }
499         icePerSecond= _icePerSecond;
500     }
501 // How many pools are in the contract
502     function poolLength() external view returns (uint256) {
503         return poolInfo.length;
504     }
505 
506     // Add a new staking token to the pool. Can only be called by the owner.
507     // VERY IMPORTANT NOTICE 
508     // ----------- DO NOT add the same staking token more than once. Rewards will be messed up if you do. -------------
509     // Good practice to update pools without messing up the contract
510     function add(
511         uint16 _allocPoint,
512         IERC20 _stakingToken,
513         bool _withUpdate
514     ) external onlyOwner {
515         if (_withUpdate) {
516             massUpdatePools();
517         }
518         uint256 lastRewardTime =
519             block.timestamp > startTime ? block.timestamp : startTime;
520         totalAllocPoint +=_allocPoint;
521         poolInfo.push(
522             PoolInfo({
523                 stakingToken: _stakingToken,
524                 stakingTokenTotalAmount: 0,
525                 allocPoint: _allocPoint,
526                 lastRewardTime: uint32(lastRewardTime),
527                 accIcePerShare: 0
528             })
529         );
530     }
531 
532     // Update the given pool's ICE allocation point. Can only be called by the owner.
533     // Good practice to update pools without messing up the contract
534     function set(
535         uint256 _pid,
536         uint16 _allocPoint,
537         bool _withUpdate
538     ) external onlyOwner {
539         if (_withUpdate) {
540             massUpdatePools();
541         }
542         totalAllocPoint = totalAllocPoint - poolInfo[_pid].allocPoint + _allocPoint;
543         poolInfo[_pid].allocPoint = _allocPoint;
544     }
545 
546     // Return reward multiplier over the given _from to _to time.
547     function getMultiplier(uint256 _from, uint256 _to)
548         public
549         view
550         returns (uint256)
551     {
552         _from = _from > startTime ? _from : startTime;
553         if (_from > endTime || _to < startTime) {
554             return 0;
555         }
556         if (_to > endTime) {
557             return endTime - _from;
558         }
559         return _to - _from;
560     }
561 
562     // View function to see pending ICE on frontend.
563     function pendingIce(uint256 _pid, address _user)
564         external
565         view
566         returns (uint256)
567     {
568         PoolInfo storage pool = poolInfo[_pid];
569         UserInfo storage user = userInfo[_pid][_user];
570         uint256 accIcePerShare = pool.accIcePerShare;
571        
572         if (block.timestamp > pool.lastRewardTime && pool.stakingTokenTotalAmount != 0) {
573             uint256 multiplier =
574                 getMultiplier(pool.lastRewardTime, block.timestamp);
575             uint256 iceReward =
576                 multiplier * icePerSecond * pool.allocPoint / totalAllocPoint;
577             accIcePerShare += iceReward * 1e12 / pool.stakingTokenTotalAmount;
578         }
579         return user.amount * accIcePerShare / 1e12 - user.rewardDebt + user.remainingIceTokenReward;
580     }
581 
582     // Update reward vairables for all pools. Be careful of gas spending!
583     function massUpdatePools() public {
584         uint256 length = poolInfo.length;
585         for (uint256 pid = 0; pid < length; ++pid) {
586             updatePool(pid);
587         }
588     }
589 
590     // Update reward variables of the given pool to be up-to-date.
591     function updatePool(uint256 _pid) public {
592         PoolInfo storage pool = poolInfo[_pid];
593         if (block.timestamp <= pool.lastRewardTime) {
594             return;
595         }
596 
597         if (pool.stakingTokenTotalAmount == 0) {
598             pool.lastRewardTime = uint32(block.timestamp);
599             return;
600         }
601         uint256 multiplier = getMultiplier(pool.lastRewardTime, block.timestamp);
602         uint256 iceReward =
603             multiplier * icePerSecond * pool.allocPoint / totalAllocPoint;
604         pool.accIcePerShare += uint128(iceReward * 1e12 / pool.stakingTokenTotalAmount);
605         pool.lastRewardTime = uint32(block.timestamp);
606     }
607 
608     // Deposit staking tokens to Sorbettiere for ICE allocation.
609     function deposit(uint256 _pid, uint128 _amount) public {
610         PoolInfo storage pool = poolInfo[_pid];
611         UserInfo storage user = userInfo[_pid][msg.sender];
612         updatePool(_pid);
613         if (user.amount > 0) {
614             uint128 pending =
615                 user.amount * pool.accIcePerShare / 1e12 - user.rewardDebt + user.remainingIceTokenReward;
616             user.remainingIceTokenReward = safeRewardTransfer(msg.sender, pending);
617         }
618         pool.stakingToken.safeTransferFrom(
619             address(msg.sender),
620             address(this),
621             _amount
622         );
623         user.amount += _amount;
624         pool.stakingTokenTotalAmount += _amount;
625         user.rewardDebt = user.amount * pool.accIcePerShare / 1e12;
626         emit Deposit(msg.sender, _pid, _amount);
627     }
628 
629     // Withdraw staked tokens from Sorbettiere.
630     function withdraw(uint256 _pid, uint128 _amount) public {
631         PoolInfo storage pool = poolInfo[_pid];
632         UserInfo storage user = userInfo[_pid][msg.sender];
633         require(user.amount >= _amount, "Sorbettiere: you cant eat that much popsicles");
634         updatePool(_pid);
635         uint128 pending =
636             user.amount * pool.accIcePerShare / 1e12 - user.rewardDebt + user.remainingIceTokenReward;
637         user.remainingIceTokenReward = safeRewardTransfer(msg.sender, pending);
638         user.amount -= _amount;
639         pool.stakingTokenTotalAmount -= _amount;
640         user.rewardDebt = user.amount * pool.accIcePerShare / 1e12;
641         pool.stakingToken.safeTransfer(address(msg.sender), _amount);
642         emit Withdraw(msg.sender, _pid, _amount);
643     }
644 
645     // Withdraw without caring about rewards. EMERGENCY ONLY.
646     function emergencyWithdraw(uint256 _pid) public {
647         PoolInfo storage pool = poolInfo[_pid];
648         UserInfo storage user = userInfo[_pid][msg.sender];
649         user.amount = 0;
650         user.rewardDebt = 0;
651         user.remainingIceTokenReward = 0;
652         pool.stakingToken.safeTransfer(address(msg.sender), user.amount);
653         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
654     }
655 
656     // Safe ice transfer function. Just in case if the pool does not have enough ICE token,
657     // The function returns the amount which is owed to the user
658     function safeRewardTransfer(address _to, uint128 _amount) internal returns(uint128) {
659         uint256 iceTokenBalance = ice.balanceOf(address(this));
660         if (iceTokenBalance == 0) { //save some gas fee
661             return _amount;
662         }
663         if (_amount > iceTokenBalance) { //save some gas fee
664             ice.safeTransfer(_to, iceTokenBalance);
665             return _amount - uint128(iceTokenBalance);
666         }
667         ice.safeTransfer(_to, _amount);
668         return 0;
669     }
670 }