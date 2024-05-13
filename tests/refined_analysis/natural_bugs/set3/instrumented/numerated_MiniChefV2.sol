1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 import "@boringcrypto/boring-solidity-e06e943/contracts/libraries/BoringMath.sol";
7 import "@boringcrypto/boring-solidity-e06e943/contracts/BoringBatchable.sol";
8 import "@boringcrypto/boring-solidity-e06e943/contracts/BoringOwnable.sol";
9 import "../libraries/SignedSafeMath.sol";
10 import "../interfaces/IRewarder.sol";
11 import "../interfaces/IMasterChef.sol";
12 
13 /// @notice The (older) MasterChef contract gives out a constant number of SADDLE tokens per block.
14 /// It is the only address with minting rights for SADDLE.
15 /// The idea for this MasterChef V2 (MCV2) contract is therefore to be the owner of a dummy token
16 /// that is deposited into the MasterChef V1 (MCV1) contract.
17 /// The allocation point for this pool on MCV1 is the total allocation point for all pools that receive double incentives.
18 contract MiniChefV2 is BoringOwnable, BoringBatchable {
19     using BoringMath for uint256;
20     using BoringMath128 for uint128;
21     using BoringERC20 for IERC20;
22     using SignedSafeMath for int256;
23 
24     /// @notice Info of each MCV2 user.
25     /// `amount` LP token amount the user has provided.
26     /// `rewardDebt` The amount of SADDLE entitled to the user.
27     struct UserInfo {
28         uint256 amount;
29         int256 rewardDebt;
30     }
31 
32     /// @notice Info of each MCV2 pool.
33     /// `allocPoint` The amount of allocation points assigned to the pool.
34     /// Also known as the amount of SADDLE to distribute per block.
35     struct PoolInfo {
36         uint128 accSaddlePerShare;
37         uint64 lastRewardTime;
38         uint64 allocPoint;
39     }
40 
41     /// @notice Address of SADDLE contract.
42     IERC20 public immutable SADDLE;
43 
44     /// @notice Info of each MCV2 pool.
45     PoolInfo[] public poolInfo;
46     /// @notice Address of the LP token for each MCV2 pool.
47     IERC20[] public lpToken;
48     /// @notice Address of each `IRewarder` contract in MCV2.
49     IRewarder[] public rewarder;
50 
51     /// @notice Info of each user that stakes LP tokens.
52     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
53     /// @dev Total allocation points. Must be the sum of all allocation points in all pools.
54     uint256 public totalAllocPoint;
55 
56     uint256 public saddlePerSecond;
57     uint256 private constant ACC_SADDLE_PRECISION = 1e12;
58 
59     event Deposit(
60         address indexed user,
61         uint256 indexed pid,
62         uint256 amount,
63         address indexed to
64     );
65     event Withdraw(
66         address indexed user,
67         uint256 indexed pid,
68         uint256 amount,
69         address indexed to
70     );
71     event EmergencyWithdraw(
72         address indexed user,
73         uint256 indexed pid,
74         uint256 amount,
75         address indexed to
76     );
77     event Harvest(address indexed user, uint256 indexed pid, uint256 amount);
78     event LogPoolAddition(
79         uint256 indexed pid,
80         uint256 allocPoint,
81         IERC20 indexed lpToken,
82         IRewarder indexed rewarder
83     );
84     event LogSetPool(
85         uint256 indexed pid,
86         uint256 allocPoint,
87         IRewarder indexed rewarder,
88         bool overwrite
89     );
90     event LogUpdatePool(
91         uint256 indexed pid,
92         uint64 lastRewardTime,
93         uint256 lpSupply,
94         uint256 accSaddlePerShare
95     );
96     event LogSaddlePerSecond(uint256 saddlePerSecond);
97 
98     /// @param _saddle The SADDLE token contract address.
99     constructor(IERC20 _saddle) public {
100         SADDLE = _saddle;
101     }
102 
103     /// @notice Returns the number of MCV2 pools.
104     function poolLength() public view returns (uint256 pools) {
105         pools = poolInfo.length;
106     }
107 
108     /// @notice Add a new LP to the pool. Can only be called by the owner.
109     /// DO NOT add the same LP token more than once. Rewards will be messed up if you do.
110     /// @param allocPoint AP of the new pool.
111     /// @param _lpToken Address of the LP ERC-20 token.
112     /// @param _rewarder Address of the rewarder delegate.
113     function add(
114         uint256 allocPoint,
115         IERC20 _lpToken,
116         IRewarder _rewarder
117     ) public onlyOwner {
118         totalAllocPoint = totalAllocPoint.add(allocPoint);
119         lpToken.push(_lpToken);
120         rewarder.push(_rewarder);
121 
122         poolInfo.push(
123             PoolInfo({
124                 allocPoint: allocPoint.to64(),
125                 lastRewardTime: block.timestamp.to64(),
126                 accSaddlePerShare: 0
127             })
128         );
129         emit LogPoolAddition(
130             lpToken.length.sub(1),
131             allocPoint,
132             _lpToken,
133             _rewarder
134         );
135     }
136 
137     /// @notice Update the given pool's SADDLE allocation point and `IRewarder` contract. Can only be called by the owner.
138     /// @param _pid The index of the pool. See `poolInfo`.
139     /// @param _allocPoint New AP of the pool.
140     /// @param _rewarder Address of the rewarder delegate.
141     /// @param overwrite True if _rewarder should be `set`. Otherwise `_rewarder` is ignored.
142     function set(
143         uint256 _pid,
144         uint256 _allocPoint,
145         IRewarder _rewarder,
146         bool overwrite
147     ) public onlyOwner {
148         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(
149             _allocPoint
150         );
151         poolInfo[_pid].allocPoint = _allocPoint.to64();
152         if (overwrite) {
153             rewarder[_pid] = _rewarder;
154         }
155         emit LogSetPool(
156             _pid,
157             _allocPoint,
158             overwrite ? _rewarder : rewarder[_pid],
159             overwrite
160         );
161     }
162 
163     /// @notice Sets the saddle per second to be distributed. Can only be called by the owner.
164     /// @param _saddlePerSecond The amount of Saddle to be distributed per second.
165     function setSaddlePerSecond(uint256 _saddlePerSecond) public onlyOwner {
166         saddlePerSecond = _saddlePerSecond;
167         emit LogSaddlePerSecond(_saddlePerSecond);
168     }
169 
170     /// @notice View function to see pending SADDLE on frontend.
171     /// @param _pid The index of the pool. See `poolInfo`.
172     /// @param _user Address of user.
173     /// @return pending SADDLE reward for a given user.
174     function pendingSaddle(uint256 _pid, address _user)
175         external
176         view
177         returns (uint256 pending)
178     {
179         PoolInfo memory pool = poolInfo[_pid];
180         UserInfo storage user = userInfo[_pid][_user];
181         uint256 accSaddlePerShare = pool.accSaddlePerShare;
182         uint256 lpSupply = lpToken[_pid].balanceOf(address(this));
183         if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
184             uint256 time = block.timestamp.sub(pool.lastRewardTime);
185             uint256 saddleReward = time.mul(saddlePerSecond).mul(
186                 pool.allocPoint
187             ) / totalAllocPoint;
188             accSaddlePerShare = accSaddlePerShare.add(
189                 saddleReward.mul(ACC_SADDLE_PRECISION) / lpSupply
190             );
191         }
192         pending = int256(
193             user.amount.mul(accSaddlePerShare) / ACC_SADDLE_PRECISION
194         ).sub(user.rewardDebt).toUInt256();
195     }
196 
197     /// @notice Update reward variables for all pools. Be careful of gas spending!
198     /// @param pids Pool IDs of all to be updated. Make sure to update all active pools.
199     function massUpdatePools(uint256[] calldata pids) external {
200         uint256 len = pids.length;
201         for (uint256 i = 0; i < len; ++i) {
202             updatePool(pids[i]);
203         }
204     }
205 
206     /// @notice Update reward variables of the given pool.
207     /// @param pid The index of the pool. See `poolInfo`.
208     /// @return pool Returns the pool that was updated.
209     function updatePool(uint256 pid) public returns (PoolInfo memory pool) {
210         pool = poolInfo[pid];
211         if (block.timestamp > pool.lastRewardTime) {
212             uint256 lpSupply = lpToken[pid].balanceOf(address(this));
213             if (lpSupply > 0) {
214                 uint256 time = block.timestamp.sub(pool.lastRewardTime);
215                 uint256 saddleReward = time.mul(saddlePerSecond).mul(
216                     pool.allocPoint
217                 ) / totalAllocPoint;
218                 pool.accSaddlePerShare = pool.accSaddlePerShare.add(
219                     (saddleReward.mul(ACC_SADDLE_PRECISION) / lpSupply).to128()
220                 );
221             }
222             pool.lastRewardTime = block.timestamp.to64();
223             poolInfo[pid] = pool;
224             emit LogUpdatePool(
225                 pid,
226                 pool.lastRewardTime,
227                 lpSupply,
228                 pool.accSaddlePerShare
229             );
230         }
231     }
232 
233     /// @notice Deposit LP tokens to MCV2 for SADDLE allocation.
234     /// @param pid The index of the pool. See `poolInfo`.
235     /// @param amount LP token amount to deposit.
236     /// @param to The receiver of `amount` deposit benefit.
237     function deposit(
238         uint256 pid,
239         uint256 amount,
240         address to
241     ) public {
242         PoolInfo memory pool = updatePool(pid);
243         UserInfo storage user = userInfo[pid][to];
244 
245         // Effects
246         user.amount = user.amount.add(amount);
247         user.rewardDebt = user.rewardDebt.add(
248             int256(amount.mul(pool.accSaddlePerShare) / ACC_SADDLE_PRECISION)
249         );
250 
251         // Interactions
252         IRewarder _rewarder = rewarder[pid];
253         if (address(_rewarder) != address(0)) {
254             _rewarder.onSaddleReward(pid, to, to, 0, user.amount);
255         }
256 
257         lpToken[pid].safeTransferFrom(msg.sender, address(this), amount);
258 
259         emit Deposit(msg.sender, pid, amount, to);
260     }
261 
262     /// @notice Withdraw LP tokens from MCV2.
263     /// @param pid The index of the pool. See `poolInfo`.
264     /// @param amount LP token amount to withdraw.
265     /// @param to Receiver of the LP tokens.
266     function withdraw(
267         uint256 pid,
268         uint256 amount,
269         address to
270     ) public {
271         PoolInfo memory pool = updatePool(pid);
272         UserInfo storage user = userInfo[pid][msg.sender];
273 
274         // Effects
275         user.rewardDebt = user.rewardDebt.sub(
276             int256(amount.mul(pool.accSaddlePerShare) / ACC_SADDLE_PRECISION)
277         );
278         user.amount = user.amount.sub(amount);
279 
280         // Interactions
281         IRewarder _rewarder = rewarder[pid];
282         if (address(_rewarder) != address(0)) {
283             _rewarder.onSaddleReward(pid, msg.sender, to, 0, user.amount);
284         }
285 
286         lpToken[pid].safeTransfer(to, amount);
287 
288         emit Withdraw(msg.sender, pid, amount, to);
289     }
290 
291     /// @notice Harvest proceeds for transaction sender to `to`.
292     /// @param pid The index of the pool. See `poolInfo`.
293     /// @param to Receiver of SADDLE rewards.
294     function harvest(uint256 pid, address to) public {
295         PoolInfo memory pool = updatePool(pid);
296         UserInfo storage user = userInfo[pid][msg.sender];
297         int256 accumulatedSaddle = int256(
298             user.amount.mul(pool.accSaddlePerShare) / ACC_SADDLE_PRECISION
299         );
300         uint256 _pendingSaddle = accumulatedSaddle
301             .sub(user.rewardDebt)
302             .toUInt256();
303 
304         // Effects
305         user.rewardDebt = accumulatedSaddle;
306 
307         // Interactions
308         if (_pendingSaddle != 0) {
309             SADDLE.safeTransfer(to, _pendingSaddle);
310         }
311 
312         IRewarder _rewarder = rewarder[pid];
313         if (address(_rewarder) != address(0)) {
314             _rewarder.onSaddleReward(
315                 pid,
316                 msg.sender,
317                 to,
318                 _pendingSaddle,
319                 user.amount
320             );
321         }
322 
323         emit Harvest(msg.sender, pid, _pendingSaddle);
324     }
325 
326     /// @notice Withdraw LP tokens from MCV2 and harvest proceeds for transaction sender to `to`.
327     /// @param pid The index of the pool. See `poolInfo`.
328     /// @param amount LP token amount to withdraw.
329     /// @param to Receiver of the LP tokens and SADDLE rewards.
330     function withdrawAndHarvest(
331         uint256 pid,
332         uint256 amount,
333         address to
334     ) public {
335         PoolInfo memory pool = updatePool(pid);
336         UserInfo storage user = userInfo[pid][msg.sender];
337         int256 accumulatedSaddle = int256(
338             user.amount.mul(pool.accSaddlePerShare) / ACC_SADDLE_PRECISION
339         );
340         uint256 _pendingSaddle = accumulatedSaddle
341             .sub(user.rewardDebt)
342             .toUInt256();
343 
344         // Effects
345         user.rewardDebt = accumulatedSaddle.sub(
346             int256(amount.mul(pool.accSaddlePerShare) / ACC_SADDLE_PRECISION)
347         );
348         user.amount = user.amount.sub(amount);
349 
350         // Interactions
351         SADDLE.safeTransfer(to, _pendingSaddle);
352 
353         IRewarder _rewarder = rewarder[pid];
354         if (address(_rewarder) != address(0)) {
355             _rewarder.onSaddleReward(
356                 pid,
357                 msg.sender,
358                 to,
359                 _pendingSaddle,
360                 user.amount
361             );
362         }
363 
364         lpToken[pid].safeTransfer(to, amount);
365 
366         emit Withdraw(msg.sender, pid, amount, to);
367         emit Harvest(msg.sender, pid, _pendingSaddle);
368     }
369 
370     /// @notice Withdraw without caring about rewards. EMERGENCY ONLY.
371     /// @param pid The index of the pool. See `poolInfo`.
372     /// @param to Receiver of the LP tokens.
373     function emergencyWithdraw(uint256 pid, address to) public {
374         UserInfo storage user = userInfo[pid][msg.sender];
375         uint256 amount = user.amount;
376         user.amount = 0;
377         user.rewardDebt = 0;
378 
379         IRewarder _rewarder = rewarder[pid];
380         if (address(_rewarder) != address(0)) {
381             _rewarder.onSaddleReward(pid, msg.sender, to, 0, 0);
382         }
383 
384         // Note: transfer can fail or succeed if `amount` is zero.
385         lpToken[pid].safeTransfer(to, amount);
386         emit EmergencyWithdraw(msg.sender, pid, amount, to);
387     }
388 }
