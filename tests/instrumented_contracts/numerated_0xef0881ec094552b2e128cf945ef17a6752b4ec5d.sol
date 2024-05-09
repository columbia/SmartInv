1 // SPDX-License-Identifier: MIT
2 
3 // Special Thanks to @BoringCrypto for his ideas and patience
4 
5 pragma solidity 0.6.12;
6 pragma experimental ABIEncoderV2;
7 
8 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SignedSafeMath.sol
9 library SignedSafeMath {
10     int256 constant private _INT256_MIN = -2**255;
11 
12     /**
13      * @dev Returns the multiplication of two signed integers, reverting on
14      * overflow.
15      *
16      * Counterpart to Solidity's `*` operator.
17      *
18      * Requirements:
19      *
20      * - Multiplication cannot overflow.
21      */
22     function mul(int256 a, int256 b) internal pure returns (int256) {
23         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
24         // benefit is lost if 'b' is also tested.
25         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
26         if (a == 0) {
27             return 0;
28         }
29 
30         require(!(a == -1 && b == _INT256_MIN), "SignedSafeMath: multiplication overflow");
31 
32         int256 c = a * b;
33         require(c / a == b, "SignedSafeMath: multiplication overflow");
34 
35         return c;
36     }
37 
38     /**
39      * @dev Returns the integer division of two signed integers. Reverts on
40      * division by zero. The result is rounded towards zero.
41      *
42      * Counterpart to Solidity's `/` operator. Note: this function uses a
43      * `revert` opcode (which leaves remaining gas untouched) while Solidity
44      * uses an invalid opcode to revert (consuming all remaining gas).
45      *
46      * Requirements:
47      *
48      * - The divisor cannot be zero.
49      */
50     function div(int256 a, int256 b) internal pure returns (int256) {
51         require(b != 0, "SignedSafeMath: division by zero");
52         require(!(b == -1 && a == _INT256_MIN), "SignedSafeMath: division overflow");
53 
54         int256 c = a / b;
55 
56         return c;
57     }
58 
59     /**
60      * @dev Returns the subtraction of two signed integers, reverting on
61      * overflow.
62      *
63      * Counterpart to Solidity's `-` operator.
64      *
65      * Requirements:
66      *
67      * - Subtraction cannot overflow.
68      */
69     function sub(int256 a, int256 b) internal pure returns (int256) {
70         int256 c = a - b;
71         require((b >= 0 && c <= a) || (b < 0 && c > a), "SignedSafeMath: subtraction overflow");
72 
73         return c;
74     }
75 
76     /**
77      * @dev Returns the addition of two signed integers, reverting on
78      * overflow.
79      *
80      * Counterpart to Solidity's `+` operator.
81      *
82      * Requirements:
83      *
84      * - Addition cannot overflow.
85      */
86     function add(int256 a, int256 b) internal pure returns (int256) {
87         int256 c = a + b;
88         require((b >= 0 && c >= a) || (b < 0 && c < a), "SignedSafeMath: addition overflow");
89 
90         return c;
91     }
92 
93     function toUInt256(int256 a) internal pure returns (uint256) {
94         require(a >= 0, "Integer < 0");
95         return uint256(a);
96     }
97 }
98 
99 /// @notice A library for performing overflow-/underflow-safe math,
100 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
101 library BoringMath {
102     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
103         require((c = a + b) >= b, "BoringMath: Add Overflow");
104     }
105 
106     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
107         require((c = a - b) <= a, "BoringMath: Underflow");
108     }
109 
110     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
111         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
112     }
113 
114     function to128(uint256 a) internal pure returns (uint128 c) {
115         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
116         c = uint128(a);
117     }
118 
119     function to64(uint256 a) internal pure returns (uint64 c) {
120         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
121         c = uint64(a);
122     }
123 
124     function to32(uint256 a) internal pure returns (uint32 c) {
125         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
126         c = uint32(a);
127     }
128 }
129 
130 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
131 library BoringMath128 {
132     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
133         require((c = a + b) >= b, "BoringMath: Add Overflow");
134     }
135 
136     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
137         require((c = a - b) <= a, "BoringMath: Underflow");
138     }
139 }
140 
141 
142 contract BoringOwnableData {
143     address public owner;
144     address public pendingOwner;
145 }
146 
147 contract BoringOwnable is BoringOwnableData {
148     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
149 
150     /// @notice `owner` defaults to msg.sender on construction.
151     constructor() public {
152         owner = msg.sender;
153         emit OwnershipTransferred(address(0), msg.sender);
154     }
155 
156     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
157     /// Can only be invoked by the current `owner`.
158     /// @param newOwner Address of the new owner.
159     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
160     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
161     function transferOwnership(
162         address newOwner,
163         bool direct,
164         bool renounce
165     ) public onlyOwner {
166         if (direct) {
167             // Checks
168             require(newOwner != address(0) || renounce, "Ownable: zero address");
169 
170             // Effects
171             emit OwnershipTransferred(owner, newOwner);
172             owner = newOwner;
173             pendingOwner = address(0);
174         } else {
175             // Effects
176             pendingOwner = newOwner;
177         }
178     }
179 
180     /// @notice Needs to be called by `pendingOwner` to claim ownership.
181     function claimOwnership() public {
182         address _pendingOwner = pendingOwner;
183 
184         // Checks
185         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
186 
187         // Effects
188         emit OwnershipTransferred(owner, _pendingOwner);
189         owner = _pendingOwner;
190         pendingOwner = address(0);
191     }
192 
193     /// @notice Only allows the `owner` to execute the function.
194     modifier onlyOwner() {
195         require(msg.sender == owner, "Ownable: caller is not the owner");
196         _;
197     }
198 }
199 
200 interface IERC20 {
201     function totalSupply() external view returns (uint256);
202 
203     function balanceOf(address account) external view returns (uint256);
204 
205     function allowance(address owner, address spender) external view returns (uint256);
206 
207     function approve(address spender, uint256 amount) external returns (bool);
208 
209     event Transfer(address indexed from, address indexed to, uint256 value);
210     event Approval(address indexed owner, address indexed spender, uint256 value);
211 
212     /// @notice EIP 2612
213     function permit(
214         address owner,
215         address spender,
216         uint256 value,
217         uint256 deadline,
218         uint8 v,
219         bytes32 r,
220         bytes32 s
221     ) external;
222 }
223 
224 
225 library BoringERC20 {
226     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
227     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
228     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
229     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
230     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
231 
232     function returnDataToString(bytes memory data) internal pure returns (string memory) {
233         if (data.length >= 64) {
234             return abi.decode(data, (string));
235         } else if (data.length == 32) {
236             uint8 i = 0;
237             while(i < 32 && data[i] != 0) {
238                 i++;
239             }
240             bytes memory bytesArray = new bytes(i);
241             for (i = 0; i < 32 && data[i] != 0; i++) {
242                 bytesArray[i] = data[i];
243             }
244             return string(bytesArray);
245         } else {
246             return "???";
247         }
248     }
249 
250     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
251     /// @param token The address of the ERC-20 token contract.
252     /// @return (string) Token symbol.
253     function safeSymbol(IERC20 token) internal view returns (string memory) {
254         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));
255         return success ? returnDataToString(data) : "???";
256     }
257 
258     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
259     /// @param token The address of the ERC-20 token contract.
260     /// @return (string) Token name.
261     function safeName(IERC20 token) internal view returns (string memory) {
262         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));
263         return success ? returnDataToString(data) : "???";
264     }
265 
266     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
267     /// @param token The address of the ERC-20 token contract.
268     /// @return (uint8) Token decimals.
269     function safeDecimals(IERC20 token) internal view returns (uint8) {
270         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));
271         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
272     }
273 
274     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
275     /// Reverts on a failed transfer.
276     /// @param token The address of the ERC-20 token.
277     /// @param to Transfer tokens to.
278     /// @param amount The token amount.
279     function safeTransfer(
280         IERC20 token,
281         address to,
282         uint256 amount
283     ) internal {
284         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
285         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
286     }
287 
288     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
289     /// Reverts on a failed transfer.
290     /// @param token The address of the ERC-20 token.
291     /// @param from Transfer tokens from.
292     /// @param to Transfer tokens to.
293     /// @param amount The token amount.
294     function safeTransferFrom(
295         IERC20 token,
296         address from,
297         address to,
298         uint256 amount
299     ) internal {
300         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
301         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
302     }
303 }
304 
305 contract BaseBoringBatchable {
306     /// @dev Helper function to extract a useful revert message from a failed call.
307     /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
308     function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
309         // If the _res length is less than 68, then the transaction failed silently (without a revert message)
310         if (_returnData.length < 68) return "Transaction reverted silently";
311 
312         assembly {
313             // Slice the sighash.
314             _returnData := add(_returnData, 0x04)
315         }
316         return abi.decode(_returnData, (string)); // All that remains is the revert string
317     }
318 
319     /// @notice Allows batched call to self (this contract).
320     /// @param calls An array of inputs for each call.
321     /// @param revertOnFail If True then reverts after a failed call and stops doing further calls.
322     /// @return successes An array indicating the success of a call, mapped one-to-one to `calls`.
323     /// @return results An array with the returned data of each function call, mapped one-to-one to `calls`.
324     // F1: External is ok here because this is the batch function, adding it to a batch makes no sense
325     // F2: Calls in the batch may be payable, delegatecall operates in the same context, so each call in the batch has access to msg.value
326     // C3: The length of the loop is fully under user control, so can't be exploited
327     // C7: Delegatecall is only used on the same contract, so it's safe
328     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results) {
329         successes = new bool[](calls.length);
330         results = new bytes[](calls.length);
331         for (uint256 i = 0; i < calls.length; i++) {
332             (bool success, bytes memory result) = address(this).delegatecall(calls[i]);
333             require(success || !revertOnFail, _getRevertMsg(result));
334             successes[i] = success;
335             results[i] = result;
336         }
337     }
338 }
339 
340 contract BoringBatchable is BaseBoringBatchable {
341     /// @notice Call wrapper that performs `ERC20.permit` on `token`.
342     /// Lookup `IERC20.permit`.
343     // F6: Parameters can be used front-run the permit and the user's permit will fail (due to nonce or other revert)
344     //     if part of a batch this could be used to grief once as the second call would not need the permit
345     function permitToken(
346         IERC20 token,
347         address from,
348         address to,
349         uint256 amount,
350         uint256 deadline,
351         uint8 v,
352         bytes32 r,
353         bytes32 s
354     ) public {
355         token.permit(from, to, amount, deadline, v, r, s);
356     }
357 }
358 
359 interface IRewarder {
360     using BoringERC20 for IERC20;
361     function onSushiReward(uint256 pid, address user, address recipient, uint256 sushiAmount, uint256 newLpAmount) external;
362     function pendingTokens(uint256 pid, address user, uint256 sushiAmount) external view returns (IERC20[] memory, uint256[] memory);
363 }
364 
365 interface IMigratorChef {
366     // Take the current LP token address and return the new LP token address.
367     // Migrator should have full access to the caller's LP token.
368     function migrate(IERC20 token) external returns (IERC20);
369 }
370 
371 interface IMasterChef {
372     using BoringERC20 for IERC20;
373     struct UserInfo {
374         uint256 amount;     // How many LP tokens the user has provided.
375         uint256 rewardDebt; // Reward debt. See explanation below.
376     }
377 
378     struct PoolInfo {
379         IERC20 lpToken;           // Address of LP token contract.
380         uint256 allocPoint;       // How many allocation points assigned to this pool. SUSHI to distribute per block.
381         uint256 lastRewardBlock;  // Last block number that SUSHI distribution occurs.
382         uint256 accSushiPerShare; // Accumulated SUSHI per share, times 1e12. See below.
383     }
384 
385     function poolInfo(uint256 pid) external view returns (IMasterChef.PoolInfo memory);
386     function totalAllocPoint() external view returns (uint256);
387     function deposit(uint256 _pid, uint256 _amount) external;
388 }
389 
390 /// @notice The (older) MasterChef contract gives out a constant number of SUSHI tokens per block.
391 /// It is the only address with minting rights for SUSHI.
392 /// The idea for this MasterChef V2 (MCV2) contract is therefore to be the owner of a dummy token
393 /// that is deposited into the MasterChef V1 (MCV1) contract.
394 /// The allocation point for this pool on MCV1 is the total allocation point for all pools that receive double incentives.
395 contract MasterChefV2 is BoringOwnable, BoringBatchable {
396     using BoringMath for uint256;
397     using BoringMath128 for uint128;
398     using BoringERC20 for IERC20;
399     using SignedSafeMath for int256;
400 
401     /// @notice Info of each MCV2 user.
402     /// `amount` LP token amount the user has provided.
403     /// `rewardDebt` The amount of SUSHI entitled to the user.
404     struct UserInfo {
405         uint256 amount;
406         int256 rewardDebt;
407     }
408 
409     /// @notice Info of each MCV2 pool.
410     /// `allocPoint` The amount of allocation points assigned to the pool.
411     /// Also known as the amount of SUSHI to distribute per block.
412     struct PoolInfo {
413         uint128 accSushiPerShare;
414         uint64 lastRewardBlock;
415         uint64 allocPoint;
416     }
417 
418     /// @notice Address of MCV1 contract.
419     IMasterChef public immutable MASTER_CHEF;
420     /// @notice Address of SUSHI contract.
421     IERC20 public immutable SUSHI;
422     /// @notice The index of MCV2 master pool in MCV1.
423     uint256 public immutable MASTER_PID;
424     // @notice The migrator contract. It has a lot of power. Can only be set through governance (owner).
425     IMigratorChef public migrator;
426 
427     /// @notice Info of each MCV2 pool.
428     PoolInfo[] public poolInfo;
429     /// @notice Address of the LP token for each MCV2 pool.
430     IERC20[] public lpToken;
431     /// @notice Address of each `IRewarder` contract in MCV2.
432     IRewarder[] public rewarder;
433 
434     /// @notice Info of each user that stakes LP tokens.
435     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
436     /// @dev Total allocation points. Must be the sum of all allocation points in all pools.
437     uint256 public totalAllocPoint;
438 
439     uint256 private constant MASTERCHEF_SUSHI_PER_BLOCK = 1e20;
440     uint256 private constant ACC_SUSHI_PRECISION = 1e12;
441 
442     event Deposit(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
443     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
444     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount, address indexed to);
445     event Harvest(address indexed user, uint256 indexed pid, uint256 amount);
446     event LogPoolAddition(uint256 indexed pid, uint256 allocPoint, IERC20 indexed lpToken, IRewarder indexed rewarder);
447     event LogSetPool(uint256 indexed pid, uint256 allocPoint, IRewarder indexed rewarder, bool overwrite);
448     event LogUpdatePool(uint256 indexed pid, uint64 lastRewardBlock, uint256 lpSupply, uint256 accSushiPerShare);
449     event LogInit();
450 
451     /// @param _MASTER_CHEF The SushiSwap MCV1 contract address.
452     /// @param _sushi The SUSHI token contract address.
453     /// @param _MASTER_PID The pool ID of the dummy token on the base MCV1 contract.
454     constructor(IMasterChef _MASTER_CHEF, IERC20 _sushi, uint256 _MASTER_PID) public {
455         MASTER_CHEF = _MASTER_CHEF;
456         SUSHI = _sushi;
457         MASTER_PID = _MASTER_PID;
458     }
459 
460     /// @notice Deposits a dummy token to `MASTER_CHEF` MCV1. This is required because MCV1 holds the minting rights for SUSHI.
461     /// Any balance of transaction sender in `dummyToken` is transferred.
462     /// The allocation point for the pool on MCV1 is the total allocation point for all pools that receive double incentives.
463     /// @param dummyToken The address of the ERC-20 token to deposit into MCV1.
464     function init(IERC20 dummyToken) external {
465         uint256 balance = dummyToken.balanceOf(msg.sender);
466         require(balance != 0, "MasterChefV2: Balance must exceed 0");
467         dummyToken.safeTransferFrom(msg.sender, address(this), balance);
468         dummyToken.approve(address(MASTER_CHEF), balance);
469         MASTER_CHEF.deposit(MASTER_PID, balance);
470         emit LogInit();
471     }
472 
473     /// @notice Returns the number of MCV2 pools.
474     function poolLength() public view returns (uint256 pools) {
475         pools = poolInfo.length;
476     }
477 
478     /// @notice Add a new LP to the pool. Can only be called by the owner.
479     /// DO NOT add the same LP token more than once. Rewards will be messed up if you do.
480     /// @param allocPoint AP of the new pool.
481     /// @param _lpToken Address of the LP ERC-20 token.
482     /// @param _rewarder Address of the rewarder delegate.
483     function add(uint256 allocPoint, IERC20 _lpToken, IRewarder _rewarder) public onlyOwner {
484         uint256 lastRewardBlock = block.number;
485         totalAllocPoint = totalAllocPoint.add(allocPoint);
486         lpToken.push(_lpToken);
487         rewarder.push(_rewarder);
488 
489         poolInfo.push(PoolInfo({
490             allocPoint: allocPoint.to64(),
491             lastRewardBlock: lastRewardBlock.to64(),
492             accSushiPerShare: 0
493         }));
494         emit LogPoolAddition(lpToken.length.sub(1), allocPoint, _lpToken, _rewarder);
495     }
496 
497     /// @notice Update the given pool's SUSHI allocation point and `IRewarder` contract. Can only be called by the owner.
498     /// @param _pid The index of the pool. See `poolInfo`.
499     /// @param _allocPoint New AP of the pool.
500     /// @param _rewarder Address of the rewarder delegate.
501     /// @param overwrite True if _rewarder should be `set`. Otherwise `_rewarder` is ignored.
502     function set(uint256 _pid, uint256 _allocPoint, IRewarder _rewarder, bool overwrite) public onlyOwner {
503         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
504         poolInfo[_pid].allocPoint = _allocPoint.to64();
505         if (overwrite) { rewarder[_pid] = _rewarder; }
506         emit LogSetPool(_pid, _allocPoint, overwrite ? _rewarder : rewarder[_pid], overwrite);
507     }
508 
509     /// @notice Set the `migrator` contract. Can only be called by the owner.
510     /// @param _migrator The contract address to set.
511     function setMigrator(IMigratorChef _migrator) public onlyOwner {
512         migrator = _migrator;
513     }
514 
515     /// @notice Migrate LP token to another LP contract through the `migrator` contract.
516     /// @param _pid The index of the pool. See `poolInfo`.
517     function migrate(uint256 _pid) public {
518         require(address(migrator) != address(0), "MasterChefV2: no migrator set");
519         IERC20 _lpToken = lpToken[_pid];
520         uint256 bal = _lpToken.balanceOf(address(this));
521         _lpToken.approve(address(migrator), bal);
522         IERC20 newLpToken = migrator.migrate(_lpToken);
523         require(bal == newLpToken.balanceOf(address(this)), "MasterChefV2: migrated balance must match");
524         lpToken[_pid] = newLpToken;
525     }
526 
527     /// @notice View function to see pending SUSHI on frontend.
528     /// @param _pid The index of the pool. See `poolInfo`.
529     /// @param _user Address of user.
530     /// @return pending SUSHI reward for a given user.
531     function pendingSushi(uint256 _pid, address _user) external view returns (uint256 pending) {
532         PoolInfo memory pool = poolInfo[_pid];
533         UserInfo storage user = userInfo[_pid][_user];
534         uint256 accSushiPerShare = pool.accSushiPerShare;
535         uint256 lpSupply = lpToken[_pid].balanceOf(address(this));
536         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
537             uint256 blocks = block.number.sub(pool.lastRewardBlock);
538             uint256 sushiReward = blocks.mul(sushiPerBlock()).mul(pool.allocPoint) / totalAllocPoint;
539             accSushiPerShare = accSushiPerShare.add(sushiReward.mul(ACC_SUSHI_PRECISION) / lpSupply);
540         }
541         pending = int256(user.amount.mul(accSushiPerShare) / ACC_SUSHI_PRECISION).sub(user.rewardDebt).toUInt256();
542     }
543 
544     /// @notice Update reward variables for all pools. Be careful of gas spending!
545     /// @param pids Pool IDs of all to be updated. Make sure to update all active pools.
546     function massUpdatePools(uint256[] calldata pids) external {
547         uint256 len = pids.length;
548         for (uint256 i = 0; i < len; ++i) {
549             updatePool(pids[i]);
550         }
551     }
552 
553     /// @notice Calculates and returns the `amount` of SUSHI per block.
554     function sushiPerBlock() public view returns (uint256 amount) {
555         amount = uint256(MASTERCHEF_SUSHI_PER_BLOCK)
556             .mul(MASTER_CHEF.poolInfo(MASTER_PID).allocPoint) / MASTER_CHEF.totalAllocPoint();
557     }
558 
559     /// @notice Update reward variables of the given pool.
560     /// @param pid The index of the pool. See `poolInfo`.
561     /// @return pool Returns the pool that was updated.
562     function updatePool(uint256 pid) public returns (PoolInfo memory pool) {
563         pool = poolInfo[pid];
564         if (block.number > pool.lastRewardBlock) {
565             uint256 lpSupply = lpToken[pid].balanceOf(address(this));
566             if (lpSupply > 0) {
567                 uint256 blocks = block.number.sub(pool.lastRewardBlock);
568                 uint256 sushiReward = blocks.mul(sushiPerBlock()).mul(pool.allocPoint) / totalAllocPoint;
569                 pool.accSushiPerShare = pool.accSushiPerShare.add((sushiReward.mul(ACC_SUSHI_PRECISION) / lpSupply).to128());
570             }
571             pool.lastRewardBlock = block.number.to64();
572             poolInfo[pid] = pool;
573             emit LogUpdatePool(pid, pool.lastRewardBlock, lpSupply, pool.accSushiPerShare);
574         }
575     }
576 
577     /// @notice Deposit LP tokens to MCV2 for SUSHI allocation.
578     /// @param pid The index of the pool. See `poolInfo`.
579     /// @param amount LP token amount to deposit.
580     /// @param to The receiver of `amount` deposit benefit.
581     function deposit(uint256 pid, uint256 amount, address to) public {
582         PoolInfo memory pool = updatePool(pid);
583         UserInfo storage user = userInfo[pid][to];
584 
585         // Effects
586         user.amount = user.amount.add(amount);
587         user.rewardDebt = user.rewardDebt.add(int256(amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION));
588 
589         // Interactions
590         IRewarder _rewarder = rewarder[pid];
591         if (address(_rewarder) != address(0)) {
592             _rewarder.onSushiReward(pid, to, to, 0, user.amount);
593         }
594 
595         lpToken[pid].safeTransferFrom(msg.sender, address(this), amount);
596 
597         emit Deposit(msg.sender, pid, amount, to);
598     }
599 
600     /// @notice Withdraw LP tokens from MCV2.
601     /// @param pid The index of the pool. See `poolInfo`.
602     /// @param amount LP token amount to withdraw.
603     /// @param to Receiver of the LP tokens.
604     function withdraw(uint256 pid, uint256 amount, address to) public {
605         PoolInfo memory pool = updatePool(pid);
606         UserInfo storage user = userInfo[pid][msg.sender];
607 
608         // Effects
609         user.rewardDebt = user.rewardDebt.sub(int256(amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION));
610         user.amount = user.amount.sub(amount);
611 
612         // Interactions
613         IRewarder _rewarder = rewarder[pid];
614         if (address(_rewarder) != address(0)) {
615             _rewarder.onSushiReward(pid, msg.sender, to, 0, user.amount);
616         }
617         
618         lpToken[pid].safeTransfer(to, amount);
619 
620         emit Withdraw(msg.sender, pid, amount, to);
621     }
622 
623     /// @notice Harvest proceeds for transaction sender to `to`.
624     /// @param pid The index of the pool. See `poolInfo`.
625     /// @param to Receiver of SUSHI rewards.
626     function harvest(uint256 pid, address to) public {
627         PoolInfo memory pool = updatePool(pid);
628         UserInfo storage user = userInfo[pid][msg.sender];
629         int256 accumulatedSushi = int256(user.amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION);
630         uint256 _pendingSushi = accumulatedSushi.sub(user.rewardDebt).toUInt256();
631 
632         // Effects
633         user.rewardDebt = accumulatedSushi;
634 
635         // Interactions
636         if (_pendingSushi != 0) {
637             SUSHI.safeTransfer(to, _pendingSushi);
638         }
639         
640         IRewarder _rewarder = rewarder[pid];
641         if (address(_rewarder) != address(0)) {
642             _rewarder.onSushiReward( pid, msg.sender, to, _pendingSushi, user.amount);
643         }
644 
645         emit Harvest(msg.sender, pid, _pendingSushi);
646     }
647     
648     /// @notice Withdraw LP tokens from MCV2 and harvest proceeds for transaction sender to `to`.
649     /// @param pid The index of the pool. See `poolInfo`.
650     /// @param amount LP token amount to withdraw.
651     /// @param to Receiver of the LP tokens and SUSHI rewards.
652     function withdrawAndHarvest(uint256 pid, uint256 amount, address to) public {
653         PoolInfo memory pool = updatePool(pid);
654         UserInfo storage user = userInfo[pid][msg.sender];
655         int256 accumulatedSushi = int256(user.amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION);
656         uint256 _pendingSushi = accumulatedSushi.sub(user.rewardDebt).toUInt256();
657 
658         // Effects
659         user.rewardDebt = accumulatedSushi.sub(int256(amount.mul(pool.accSushiPerShare) / ACC_SUSHI_PRECISION));
660         user.amount = user.amount.sub(amount);
661         
662         // Interactions
663         SUSHI.safeTransfer(to, _pendingSushi);
664 
665         IRewarder _rewarder = rewarder[pid];
666         if (address(_rewarder) != address(0)) {
667             _rewarder.onSushiReward(pid, msg.sender, to, _pendingSushi, user.amount);
668         }
669 
670         lpToken[pid].safeTransfer(to, amount);
671 
672         emit Withdraw(msg.sender, pid, amount, to);
673         emit Harvest(msg.sender, pid, _pendingSushi);
674     }
675 
676     /// @notice Harvests SUSHI from `MASTER_CHEF` MCV1 and pool `MASTER_PID` to this MCV2 contract.
677     function harvestFromMasterChef() public {
678         MASTER_CHEF.deposit(MASTER_PID, 0);
679     }
680 
681     /// @notice Withdraw without caring about rewards. EMERGENCY ONLY.
682     /// @param pid The index of the pool. See `poolInfo`.
683     /// @param to Receiver of the LP tokens.
684     function emergencyWithdraw(uint256 pid, address to) public {
685         UserInfo storage user = userInfo[pid][msg.sender];
686         uint256 amount = user.amount;
687         user.amount = 0;
688         user.rewardDebt = 0;
689 
690         IRewarder _rewarder = rewarder[pid];
691         if (address(_rewarder) != address(0)) {
692             _rewarder.onSushiReward(pid, msg.sender, to, 0, 0);
693         }
694 
695         // Note: transfer can fail or succeed if `amount` is zero.
696         lpToken[pid].safeTransfer(to, amount);
697         emit EmergencyWithdraw(msg.sender, pid, amount, to);
698     }
699 }