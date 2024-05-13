1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.12;
4 
5 import '../libraries/SafeMath.sol';
6 import '../interfaces/IBEP20.sol';
7 import '../token/SafeBEP20.sol';
8 import '@openzeppelin/contracts/access/Ownable.sol';
9 
10 import "../token/BabyToken.sol";
11 import "./SyrupBar.sol";
12 
13 // import "@nomiclabs/buidler/console.sol";
14 
15 interface IMigratorChef {
16     // Perform LP token migration from legacy PancakeSwap to CakeSwap.
17     // Take the current LP token address and return the new LP token address.
18     // Migrator should have full access to the caller's LP token.
19     // Return the new LP token address.
20     //
21     // XXX Migrator must have allowance access to PancakeSwap LP tokens.
22     // CakeSwap must mint EXACTLY the same amount of CakeSwap LP tokens or
23     // else something bad will happen. Traditional PancakeSwap does not
24     // do that so be careful!
25     function migrate(IBEP20 token) external returns (IBEP20);
26 }
27 
28 // MasterChef is the master of Cake. He can make Cake and he is a fair guy.
29 //
30 // Note that it's ownable and the owner wields tremendous power. The ownership
31 // will be transferred to a governance smart contract once CAKE is sufficiently
32 // distributed and the community can show to govern itself.
33 //
34 // Have fun reading it. Hopefully it's bug-free. God bless.
35 contract MasterChef is Ownable {
36     using SafeMath for uint256;
37     using SafeBEP20 for IBEP20;
38 
39     // Info of each user.
40     struct UserInfo {
41         uint256 amount;     // How many LP tokens the user has provided.
42         uint256 rewardDebt; // Reward debt. See explanation below.
43         //
44         // We do some fancy math here. Basically, any point in time, the amount of CAKEs
45         // entitled to a user but is pending to be distributed is:
46         //
47         //   pending reward = (user.amount * pool.accCakePerShare) - user.rewardDebt
48         //
49         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
50         //   1. The pool's `accCakePerShare` (and `lastRewardBlock`) gets updated.
51         //   2. User receives the pending reward sent to his/her address.
52         //   3. User's `amount` gets updated.
53         //   4. User's `rewardDebt` gets updated.
54     }
55 
56     // Info of each pool.
57     struct PoolInfo {
58         IBEP20 lpToken;           // Address of LP token contract.
59         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
60         uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
61         uint256 accCakePerShare; // Accumulated CAKEs per share, times 1e12. See below.
62     }
63 
64     // The CAKE TOKEN!
65     BabyToken public cake;
66     // The SYRUP TOKEN!
67     SyrupBar public syrup;
68     // CAKE tokens created per block.
69     uint256 public cakePerBlock;
70     // Bonus muliplier for early cake makers.
71     uint256 public BONUS_MULTIPLIER = 1;
72     // The migrator contract. It has a lot of power. Can only be set through governance (owner).
73     IMigratorChef public migrator;
74 
75     // Info of each pool.
76     PoolInfo[] public poolInfo;
77     // Info of each user that stakes LP tokens.
78     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
79     // Total allocation points. Must be the sum of all allocation points in all pools.
80     uint256 public totalAllocPoint = 0;
81     // The block number when CAKE mining starts.
82     uint256 public startBlock;
83 
84     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
85     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
86     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
87 
88     constructor(
89         BabyToken _cake,
90         SyrupBar _syrup,
91         uint256 _cakePerBlock,
92         uint256 _startBlock
93     ) {
94         cake = _cake;
95         syrup = _syrup;
96         cakePerBlock = _cakePerBlock;
97         startBlock = _startBlock;
98 
99         // staking pool
100         poolInfo.push(PoolInfo({
101             lpToken: _cake,
102             allocPoint: 1000,
103             lastRewardBlock: startBlock,
104             accCakePerShare: 0
105         }));
106 
107         totalAllocPoint = 1000;
108 
109     }
110 
111     function updateMultiplier(uint256 multiplierNumber) public onlyOwner {
112         BONUS_MULTIPLIER = multiplierNumber;
113     }
114 
115     function poolLength() external view returns (uint256) {
116         return poolInfo.length;
117     }
118 
119     // Add a new lp to the pool. Can only be called by the owner.
120     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
121     function add(uint256 _allocPoint, IBEP20 _lpToken, bool _withUpdate) public onlyOwner {
122         if (_withUpdate) {
123             massUpdatePools();
124         }
125         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
126         totalAllocPoint = totalAllocPoint.add(_allocPoint);
127         poolInfo.push(PoolInfo({
128             lpToken: _lpToken,
129             allocPoint: _allocPoint,
130             lastRewardBlock: lastRewardBlock,
131             accCakePerShare: 0
132         }));
133         updateStakingPool();
134     }
135 
136     // Update the given pool's CAKE allocation point. Can only be called by the owner.
137     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
138         if (_withUpdate) {
139             massUpdatePools();
140         }
141         uint256 prevAllocPoint = poolInfo[_pid].allocPoint;
142         poolInfo[_pid].allocPoint = _allocPoint;
143         if (prevAllocPoint != _allocPoint) {
144             totalAllocPoint = totalAllocPoint.sub(prevAllocPoint).add(_allocPoint);
145             updateStakingPool();
146         }
147     }
148 
149     function updateStakingPool() internal {
150         uint256 length = poolInfo.length;
151         uint256 points = 0;
152         for (uint256 pid = 1; pid < length; ++pid) {
153             points = points.add(poolInfo[pid].allocPoint);
154         }
155         if (points != 0) {
156             points = points.div(2);
157             totalAllocPoint = totalAllocPoint.sub(poolInfo[0].allocPoint).add(points);
158             poolInfo[0].allocPoint = points;
159         }
160     }
161 
162     // Set the migrator contract. Can only be called by the owner.
163     function setMigrator(IMigratorChef _migrator) public onlyOwner {
164         migrator = _migrator;
165     }
166 
167     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
168     function migrate(uint256 _pid) public {
169         require(address(migrator) != address(0), "migrate: no migrator");
170         PoolInfo storage pool = poolInfo[_pid];
171         IBEP20 lpToken = pool.lpToken;
172         uint256 bal = lpToken.balanceOf(address(this));
173         lpToken.safeApprove(address(migrator), bal);
174         IBEP20 newLpToken = migrator.migrate(lpToken);
175         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
176         pool.lpToken = newLpToken;
177     }
178 
179     // Return reward multiplier over the given _from to _to block.
180     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
181         return _to.sub(_from).mul(BONUS_MULTIPLIER);
182     }
183 
184     // View function to see pending CAKEs on frontend.
185     function pendingCake(uint256 _pid, address _user) external view returns (uint256) {
186         PoolInfo storage pool = poolInfo[_pid];
187         UserInfo storage user = userInfo[_pid][_user];
188         uint256 accCakePerShare = pool.accCakePerShare;
189         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
190         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
191             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
192             uint256 cakeReward = multiplier.mul(cakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
193             accCakePerShare = accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
194         }
195         return user.amount.mul(accCakePerShare).div(1e12).sub(user.rewardDebt);
196     }
197 
198     // Update reward variables for all pools. Be careful of gas spending!
199     function massUpdatePools() public {
200         uint256 length = poolInfo.length;
201         for (uint256 pid = 0; pid < length; ++pid) {
202             updatePool(pid);
203         }
204     }
205 
206 
207     // Update reward variables of the given pool to be up-to-date.
208     function updatePool(uint256 _pid) public {
209         PoolInfo storage pool = poolInfo[_pid];
210         if (block.number <= pool.lastRewardBlock) {
211             return;
212         }
213         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
214         if (lpSupply == 0) {
215             pool.lastRewardBlock = block.number;
216             return;
217         }
218         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
219         uint256 cakeReward = multiplier.mul(cakePerBlock).mul(pool.allocPoint).div(totalAllocPoint);
220         cake.mintFor(address(syrup), cakeReward);
221         pool.accCakePerShare = pool.accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
222         pool.lastRewardBlock = block.number;
223     }
224 
225     // Deposit LP tokens to MasterChef for CAKE allocation.
226     function deposit(uint256 _pid, uint256 _amount) public {
227 
228         require (_pid != 0, 'deposit CAKE by staking');
229 
230         PoolInfo storage pool = poolInfo[_pid];
231         UserInfo storage user = userInfo[_pid][msg.sender];
232         updatePool(_pid);
233         if (user.amount > 0) {
234             uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
235             if(pending > 0) {
236                 safeCakeTransfer(msg.sender, pending);
237             }
238         }
239         if (_amount > 0) {
240             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
241             user.amount = user.amount.add(_amount);
242         }
243         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
244         emit Deposit(msg.sender, _pid, _amount);
245     }
246 
247     // Withdraw LP tokens from MasterChef.
248     function withdraw(uint256 _pid, uint256 _amount) public {
249 
250         require (_pid != 0, 'withdraw CAKE by unstaking');
251         PoolInfo storage pool = poolInfo[_pid];
252         UserInfo storage user = userInfo[_pid][msg.sender];
253         require(user.amount >= _amount, "withdraw: not good");
254 
255         updatePool(_pid);
256         uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
257         if(pending > 0) {
258             safeCakeTransfer(msg.sender, pending);
259         }
260         if(_amount > 0) {
261             user.amount = user.amount.sub(_amount);
262             pool.lpToken.safeTransfer(address(msg.sender), _amount);
263         }
264         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
265         emit Withdraw(msg.sender, _pid, _amount);
266     }
267 
268     // Stake CAKE tokens to MasterChef
269     function enterStaking(uint256 _amount) public {
270         PoolInfo storage pool = poolInfo[0];
271         UserInfo storage user = userInfo[0][msg.sender];
272         updatePool(0);
273         if (user.amount > 0) {
274             uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
275             if(pending > 0) {
276                 safeCakeTransfer(msg.sender, pending);
277             }
278         }
279         if(_amount > 0) {
280             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
281             user.amount = user.amount.add(_amount);
282         }
283         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
284 
285         syrup.mint(msg.sender, _amount);
286         emit Deposit(msg.sender, 0, _amount);
287     }
288 
289     // Withdraw CAKE tokens from STAKING.
290     function leaveStaking(uint256 _amount) public {
291         PoolInfo storage pool = poolInfo[0];
292         UserInfo storage user = userInfo[0][msg.sender];
293         require(user.amount >= _amount, "withdraw: not good");
294         updatePool(0);
295         uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
296         if(pending > 0) {
297             safeCakeTransfer(msg.sender, pending);
298         }
299         if(_amount > 0) {
300             user.amount = user.amount.sub(_amount);
301             pool.lpToken.safeTransfer(address(msg.sender), _amount);
302         }
303         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
304 
305         syrup.burn(msg.sender, _amount);
306         emit Withdraw(msg.sender, 0, _amount);
307     }
308 
309     // Withdraw without caring about rewards. EMERGENCY ONLY.
310     function emergencyWithdraw(uint256 _pid) public {
311         PoolInfo storage pool = poolInfo[_pid];
312         UserInfo storage user = userInfo[_pid][msg.sender];
313         uint amount = user.amount;
314         user.amount = 0;
315         user.rewardDebt = 0;
316         pool.lpToken.safeTransfer(address(msg.sender), amount);
317         if (_pid == 0) {
318             syrup.burn(msg.sender, amount);
319         }
320         emit EmergencyWithdraw(msg.sender, _pid, amount);
321     }
322 
323     // Safe cake transfer function, just in case if rounding error causes pool to not have enough CAKEs.
324     function safeCakeTransfer(address _to, uint256 _amount) internal {
325         syrup.safeCakeTransfer(_to, _amount);
326     }
327 
328     function transferBabyTokenOwnerShip(address newOwner_) public onlyOwner { 
329         require(newOwner_ != address(0), 'illegal address');
330         cake.transferOwnership(newOwner_);
331     }
332 
333     function transferSyrupOwnerShip(address newOwner_) public onlyOwner { 
334         require(newOwner_ != address(0), 'illegal address');
335         syrup.transferOwnership(newOwner_);
336     }
337 
338 }
