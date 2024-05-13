1 /*
2 
3     Copyright 2020 DODO ZOO.
4     SPDX-License-Identifier: Apache-2.0
5 
6 */
7 
8 pragma solidity 0.6.9;
9 pragma experimental ABIEncoderV2;
10 
11 import {Ownable} from "../lib/Ownable.sol";
12 import {DecimalMath} from "../lib/DecimalMath.sol";
13 import {SafeERC20} from "../lib/SafeERC20.sol";
14 import {SafeMath} from "../lib/SafeMath.sol";
15 import {IERC20} from "../intf/IERC20.sol";
16 import {IDODORewardVault, DODORewardVault} from "./DODORewardVault.sol";
17 
18 
19 contract DODOMine is Ownable {
20     using SafeMath for uint256;
21     using SafeERC20 for IERC20;
22 
23     // Info of each user.
24     struct UserInfo {
25         uint256 amount; // How many LP tokens the user has provided.
26         uint256 rewardDebt; // Reward debt. See explanation below.
27         //
28         // We do some fancy math here. Basically, any point in time, the amount of DODOs
29         // entitled to a user but is pending to be distributed is:
30         //
31         //   pending reward = (user.amount * pool.accDODOPerShare) - user.rewardDebt
32         //
33         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
34         //   1. The pool's `accDODOPerShare` (and `lastRewardBlock`) gets updated.
35         //   2. User receives the pending reward sent to his/her address.
36         //   3. User's `amount` gets updated.
37         //   4. User's `rewardDebt` gets updated.
38     }
39 
40     // Info of each pool.
41     struct PoolInfo {
42         address lpToken; // Address of LP token contract.
43         uint256 allocPoint; // How many allocation points assigned to this pool. DODOs to distribute per block.
44         uint256 lastRewardBlock; // Last block number that DODOs distribution occurs.
45         uint256 accDODOPerShare; // Accumulated DODOs per share, times 1e12. See below.
46     }
47 
48     address public dodoRewardVault;
49     uint256 public dodoPerBlock;
50 
51     // Info of each pool.
52     PoolInfo[] public poolInfos;
53     mapping(address => uint256) public lpTokenRegistry;
54 
55     // Info of each user that stakes LP tokens.
56     mapping(uint256 => mapping(address => UserInfo)) public userInfo;
57     mapping(address => uint256) public realizedReward;
58 
59     // Total allocation points. Must be the sum of all allocation points in all pools.
60     uint256 public totalAllocPoint = 0;
61     // The block number when DODO mining starts.
62     uint256 public startBlock;
63 
64     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
65     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
66     event Claim(address indexed user, uint256 amount);
67 
68     constructor(address _dodoToken, uint256 _startBlock) public {
69         dodoRewardVault = address(new DODORewardVault(_dodoToken));
70         startBlock = _startBlock;
71     }
72 
73     // ============ Modifiers ============
74 
75     modifier lpTokenExist(address lpToken) {
76         require(lpTokenRegistry[lpToken] > 0, "LP Token Not Exist");
77         _;
78     }
79 
80     modifier lpTokenNotExist(address lpToken) {
81         require(lpTokenRegistry[lpToken] == 0, "LP Token Already Exist");
82         _;
83     }
84 
85     // ============ Helper ============
86 
87     function poolLength() external view returns (uint256) {
88         return poolInfos.length;
89     }
90 
91     function getPid(address _lpToken) public view lpTokenExist(_lpToken) returns (uint256) {
92         return lpTokenRegistry[_lpToken] - 1;
93     }
94 
95     function getUserLpBalance(address _lpToken, address _user) public view returns (uint256) {
96         uint256 pid = getPid(_lpToken);
97         return userInfo[pid][_user].amount;
98     }
99 
100     // ============ Ownable ============
101 
102     function addLpToken(
103         address _lpToken,
104         uint256 _allocPoint,
105         bool _withUpdate
106     ) public lpTokenNotExist(_lpToken) onlyOwner {
107         if (_withUpdate) {
108             massUpdatePools();
109         }
110         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
111         totalAllocPoint = totalAllocPoint.add(_allocPoint);
112         poolInfos.push(
113             PoolInfo({
114                 lpToken: _lpToken,
115                 allocPoint: _allocPoint,
116                 lastRewardBlock: lastRewardBlock,
117                 accDODOPerShare: 0
118             })
119         );
120         lpTokenRegistry[_lpToken] = poolInfos.length;
121     }
122 
123     function setLpToken(
124         address _lpToken,
125         uint256 _allocPoint,
126         bool _withUpdate
127     ) public onlyOwner {
128         if (_withUpdate) {
129             massUpdatePools();
130         }
131         uint256 pid = getPid(_lpToken);
132         totalAllocPoint = totalAllocPoint.sub(poolInfos[pid].allocPoint).add(_allocPoint);
133         poolInfos[pid].allocPoint = _allocPoint;
134     }
135 
136     function setReward(uint256 _dodoPerBlock, bool _withUpdate) external onlyOwner {
137         if (_withUpdate) {
138             massUpdatePools();
139         }
140         dodoPerBlock = _dodoPerBlock;
141     }
142 
143     // ============ View Rewards ============
144 
145     function getPendingReward(address _lpToken, address _user) external view returns (uint256) {
146         uint256 pid = getPid(_lpToken);
147         PoolInfo storage pool = poolInfos[pid];
148         UserInfo storage user = userInfo[pid][_user];
149         uint256 accDODOPerShare = pool.accDODOPerShare;
150         uint256 lpSupply = IERC20(pool.lpToken).balanceOf(address(this));
151         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
152             uint256 DODOReward = block
153                 .number
154                 .sub(pool.lastRewardBlock)
155                 .mul(dodoPerBlock)
156                 .mul(pool.allocPoint)
157                 .div(totalAllocPoint);
158             accDODOPerShare = accDODOPerShare.add(DecimalMath.divFloor(DODOReward, lpSupply));
159         }
160         return DecimalMath.mul(user.amount, accDODOPerShare).sub(user.rewardDebt);
161     }
162 
163     function getAllPendingReward(address _user) external view returns (uint256) {
164         uint256 length = poolInfos.length;
165         uint256 totalReward = 0;
166         for (uint256 pid = 0; pid < length; ++pid) {
167             if (userInfo[pid][_user].amount == 0 || poolInfos[pid].allocPoint == 0) {
168                 continue; // save gas
169             }
170             PoolInfo storage pool = poolInfos[pid];
171             UserInfo storage user = userInfo[pid][_user];
172             uint256 accDODOPerShare = pool.accDODOPerShare;
173             uint256 lpSupply = IERC20(pool.lpToken).balanceOf(address(this));
174             if (block.number > pool.lastRewardBlock && lpSupply != 0) {
175                 uint256 DODOReward = block
176                     .number
177                     .sub(pool.lastRewardBlock)
178                     .mul(dodoPerBlock)
179                     .mul(pool.allocPoint)
180                     .div(totalAllocPoint);
181                 accDODOPerShare = accDODOPerShare.add(DecimalMath.divFloor(DODOReward, lpSupply));
182             }
183             totalReward = totalReward.add(
184                 DecimalMath.mul(user.amount, accDODOPerShare).sub(user.rewardDebt)
185             );
186         }
187         return totalReward;
188     }
189 
190     function getRealizedReward(address _user) external view returns (uint256) {
191         return realizedReward[_user];
192     }
193 
194     function getDlpMiningSpeed(address _lpToken) external view returns (uint256) {
195         uint256 pid = getPid(_lpToken);
196         PoolInfo storage pool = poolInfos[pid];
197         return dodoPerBlock.mul(pool.allocPoint).div(totalAllocPoint);
198     }
199 
200     // ============ Update Pools ============
201 
202     // Update reward vairables for all pools. Be careful of gas spending!
203     function massUpdatePools() public {
204         uint256 length = poolInfos.length;
205         for (uint256 pid = 0; pid < length; ++pid) {
206             updatePool(pid);
207         }
208     }
209 
210     // Update reward variables of the given pool to be up-to-date.
211     function updatePool(uint256 _pid) public {
212         PoolInfo storage pool = poolInfos[_pid];
213         if (block.number <= pool.lastRewardBlock) {
214             return;
215         }
216         uint256 lpSupply = IERC20(pool.lpToken).balanceOf(address(this));
217         if (lpSupply == 0) {
218             pool.lastRewardBlock = block.number;
219             return;
220         }
221         uint256 DODOReward = block
222             .number
223             .sub(pool.lastRewardBlock)
224             .mul(dodoPerBlock)
225             .mul(pool.allocPoint)
226             .div(totalAllocPoint);
227         pool.accDODOPerShare = pool.accDODOPerShare.add(DecimalMath.divFloor(DODOReward, lpSupply));
228         pool.lastRewardBlock = block.number;
229     }
230 
231     // ============ Deposit & Withdraw & Claim ============
232     // Deposit & withdraw will also trigger claim
233 
234     function deposit(address _lpToken, uint256 _amount) public {
235         uint256 pid = getPid(_lpToken);
236         PoolInfo storage pool = poolInfos[pid];
237         UserInfo storage user = userInfo[pid][msg.sender];
238         updatePool(pid);
239         if (user.amount > 0) {
240             uint256 pending = DecimalMath.mul(user.amount, pool.accDODOPerShare).sub(
241                 user.rewardDebt
242             );
243             safeDODOTransfer(msg.sender, pending);
244         }
245         IERC20(pool.lpToken).safeTransferFrom(address(msg.sender), address(this), _amount);
246         user.amount = user.amount.add(_amount);
247         user.rewardDebt = DecimalMath.mul(user.amount, pool.accDODOPerShare);
248         emit Deposit(msg.sender, pid, _amount);
249     }
250 
251     function withdraw(address _lpToken, uint256 _amount) public {
252         uint256 pid = getPid(_lpToken);
253         PoolInfo storage pool = poolInfos[pid];
254         UserInfo storage user = userInfo[pid][msg.sender];
255         require(user.amount >= _amount, "withdraw too much");
256         updatePool(pid);
257         uint256 pending = DecimalMath.mul(user.amount, pool.accDODOPerShare).sub(user.rewardDebt);
258         safeDODOTransfer(msg.sender, pending);
259         user.amount = user.amount.sub(_amount);
260         user.rewardDebt = DecimalMath.mul(user.amount, pool.accDODOPerShare);
261         IERC20(pool.lpToken).safeTransfer(address(msg.sender), _amount);
262         emit Withdraw(msg.sender, pid, _amount);
263     }
264 
265     function withdrawAll(address _lpToken) public {
266         uint256 balance = getUserLpBalance(_lpToken, msg.sender);
267         withdraw(_lpToken, balance);
268     }
269 
270     // Withdraw without caring about rewards. EMERGENCY ONLY.
271     function emergencyWithdraw(address _lpToken) public {
272         uint256 pid = getPid(_lpToken);
273         PoolInfo storage pool = poolInfos[pid];
274         UserInfo storage user = userInfo[pid][msg.sender];
275         IERC20(pool.lpToken).safeTransfer(address(msg.sender), user.amount);
276         user.amount = 0;
277         user.rewardDebt = 0;
278     }
279 
280     function claim(address _lpToken) public {
281         uint256 pid = getPid(_lpToken);
282         if (userInfo[pid][msg.sender].amount == 0 || poolInfos[pid].allocPoint == 0) {
283             return; // save gas
284         }
285         PoolInfo storage pool = poolInfos[pid];
286         UserInfo storage user = userInfo[pid][msg.sender];
287         updatePool(pid);
288         uint256 pending = DecimalMath.mul(user.amount, pool.accDODOPerShare).sub(user.rewardDebt);
289         user.rewardDebt = DecimalMath.mul(user.amount, pool.accDODOPerShare);
290         safeDODOTransfer(msg.sender, pending);
291     }
292 
293     function claimAll() public {
294         uint256 length = poolInfos.length;
295         uint256 pending = 0;
296         for (uint256 pid = 0; pid < length; ++pid) {
297             if (userInfo[pid][msg.sender].amount == 0 || poolInfos[pid].allocPoint == 0) {
298                 continue; // save gas
299             }
300             PoolInfo storage pool = poolInfos[pid];
301             UserInfo storage user = userInfo[pid][msg.sender];
302             updatePool(pid);
303             pending = pending.add(
304                 DecimalMath.mul(user.amount, pool.accDODOPerShare).sub(user.rewardDebt)
305             );
306             user.rewardDebt = DecimalMath.mul(user.amount, pool.accDODOPerShare);
307         }
308         safeDODOTransfer(msg.sender, pending);
309     }
310 
311     // Safe DODO transfer function
312     function safeDODOTransfer(address _to, uint256 _amount) internal {
313         IDODORewardVault(dodoRewardVault).reward(_to, _amount);
314         realizedReward[_to] = realizedReward[_to].add(_amount);
315         emit Claim(_to, _amount);
316     }
317 }
