1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.7.4;
4 
5 import '@openzeppelin/contracts/token/ERC20/SafeERC20.sol';
6 import '@openzeppelin/contracts/token/ERC20/IERC20.sol';
7 import '@openzeppelin/contracts/math/SafeMath.sol';
8 import '../core/SafeOwnable.sol';
9 import '../token/BabyVault.sol';
10 
11 contract BabyFarmV2 is SafeOwnable {
12     using SafeMath for uint256;
13     using SafeERC20 for IERC20;
14 
15     struct UserInfo {
16         uint256 amount;     // How many LP tokens the user has provided.
17         uint256 rewardDebt; // Reward debt. See explanation below.
18     }
19 
20     struct PoolInfo {
21         IERC20 lpToken;           // Address of LP token contract.
22         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
23         uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
24         uint256 accRewardPerShare; // Accumulated CAKEs per share, times 1e12. See below.
25     }
26 
27     enum FETCH_VAULT_TYPE {
28         FROM_ALL,
29         FROM_BALANCE,
30         FROM_TOKEN
31     }
32 
33     IERC20 public immutable rewardToken;
34     uint256 public startBlock;
35 
36     BabyVault public vault;
37     uint256 public rewardPerBlock;
38 
39     PoolInfo[] public poolInfo;
40     mapping(IERC20 => bool) public pairExist;
41     mapping(uint => bool) public pidInBlacklist;
42     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
43     uint256 public totalAllocPoint = 0;
44     FETCH_VAULT_TYPE public fetchVaultType;
45 
46     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
47     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
48     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
49 
50     modifier legalPid(uint _pid) {
51         require(_pid > 0 && _pid < poolInfo.length, "illegal pid"); 
52         _;
53     }
54 
55     modifier availablePid(uint _pid) {
56         require(!pidInBlacklist[_pid], "illegal pid ");
57         _;
58     }
59 
60     function fetch(address _to, uint _amount) internal returns(uint) {
61         if (fetchVaultType == FETCH_VAULT_TYPE.FROM_ALL) {
62             return vault.mint(msg.sender, _amount);
63         } else if (fetchVaultType == FETCH_VAULT_TYPE.FROM_BALANCE) {
64             return vault.mintOnlyFromBalance(_to, _amount);
65         } else if (fetchVaultType == FETCH_VAULT_TYPE.FROM_TOKEN) {
66             return vault.mintOnlyFromToken(_to, _amount);
67         } 
68     }
69     
70     constructor(BabyVault _vault, uint256 _rewardPerBlock, uint256 _startBlock, address _owner, uint[] memory _allocPoints, IERC20[] memory _lpTokens) {
71         rewardToken = _vault.babyToken();
72         require(_startBlock >= block.number, "illegal startBlock");
73         startBlock = _startBlock;
74         vault = _vault;
75         rewardPerBlock = _rewardPerBlock;
76         //we skip the zero index pool, and start at index 1
77         poolInfo.push(PoolInfo({
78             lpToken: IERC20(address(0)),
79             allocPoint: 0,
80             lastRewardBlock: block.number,
81             accRewardPerShare: 0
82         }));
83         require(_allocPoints.length > 0 && _allocPoints.length == _lpTokens.length, "illegal data");
84         for (uint i = 0; i < _allocPoints.length; i ++) {
85             require(!pairExist[_lpTokens[i]], "already exist");
86             totalAllocPoint = totalAllocPoint.add(_allocPoints[i]);
87             poolInfo.push(PoolInfo({
88                 lpToken: _lpTokens[i],
89                 allocPoint: _allocPoints[i],
90                 lastRewardBlock: _startBlock,
91                 accRewardPerShare: 0
92             }));
93             pairExist[_lpTokens[i]] = true;
94         }
95         if (_owner != address(0)) {
96             _transferOwnership(_owner);
97         }
98     }
99 
100     function setVault(BabyVault _vault) external onlyOwner {
101         require(_vault.babyToken() == rewardToken, "illegal vault");
102         vault = _vault;
103     }
104 
105     function disablePid(uint _pid) external onlyOwner {
106         pidInBlacklist[_pid] = true;
107     }
108 
109     function enablePid(uint _pid) external onlyOwner {
110         delete pidInBlacklist[_pid];
111     }
112 
113     function setRewardPerBlock(uint _rewardPerBlock) external onlyOwner {
114         massUpdatePools();
115         rewardPerBlock = _rewardPerBlock;
116     }
117 
118     function setFetchVaultType(FETCH_VAULT_TYPE _newType) external onlyOwner {
119         fetchVaultType = _newType;
120     }
121 
122     function setStartBlock(uint _newStartBlock) external onlyOwner {
123         require(block.number < startBlock && _newStartBlock >= block.number, "illegal start Block Number");
124         startBlock = _newStartBlock;
125     }
126 
127     function poolLength() external view returns (uint256) {
128         return poolInfo.length;
129     }
130 
131     function updatePool(uint256 _pid) public {
132         PoolInfo storage pool = poolInfo[_pid];
133         if (block.number <= pool.lastRewardBlock) {
134             return;
135         }
136         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
137         if (lpSupply == 0 || totalAllocPoint == 0) {
138             pool.lastRewardBlock = block.number;
139             return;
140         }
141         uint256 multiplier = block.number.sub(pool.lastRewardBlock);
142         uint256 reward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
143         pool.accRewardPerShare = pool.accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
144         pool.lastRewardBlock = block.number;
145     }
146 
147     function massUpdatePools() public {
148         uint256 length = poolInfo.length;
149         for (uint256 pid = 1; pid < length; ++pid) {
150             if (!pidInBlacklist[pid]) {
151                 updatePool(pid);
152             }
153         }
154     }
155 
156     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
157         require(!pairExist[_lpToken], "already exist");
158         if (_withUpdate) {
159             massUpdatePools();
160         }
161         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
162         totalAllocPoint = totalAllocPoint.add(_allocPoint);
163         poolInfo.push(PoolInfo({
164             lpToken: _lpToken,
165             allocPoint: _allocPoint,
166             lastRewardBlock: lastRewardBlock,
167             accRewardPerShare: 0
168         }));
169         pairExist[_lpToken] = true;
170     }
171 
172     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner legalPid(_pid) {
173         require (_pid > 0 && _pid < poolInfo.length, 'pid begin at 1');
174         if (_withUpdate) {
175             massUpdatePools();
176         }
177         uint256 prevAllocPoint = poolInfo[_pid].allocPoint;
178         poolInfo[_pid].allocPoint = _allocPoint;
179         if (prevAllocPoint != _allocPoint) {
180             totalAllocPoint = totalAllocPoint.sub(prevAllocPoint).add(_allocPoint);
181         }
182     }
183 
184     function pendingReward(uint256 _pid, address _user) external view legalPid(_pid) returns (uint256) {
185         PoolInfo storage pool = poolInfo[_pid];
186         UserInfo storage user = userInfo[_pid][_user];
187         uint256 accRewardPerShare = pool.accRewardPerShare;
188         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
189         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
190             uint256 multiplier = block.number.sub(pool.lastRewardBlock);
191             uint256 reward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
192             accRewardPerShare = accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
193         }
194         return user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
195     }
196 
197     function deposit(uint256 _pid, uint256 _amount) external legalPid(_pid) availablePid(_pid) {
198         PoolInfo storage pool = poolInfo[_pid];
199         UserInfo storage user = userInfo[_pid][msg.sender];
200         updatePool(_pid);
201         if (user.amount > 0) {
202             uint256 pending = user.amount.mul(pool.accRewardPerShare).div(1e12).sub(user.rewardDebt);
203             if(pending > 0) {
204                 fetch(msg.sender, pending);
205             }
206         }
207         if (_amount > 0) {
208             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
209             user.amount = user.amount.add(_amount);
210         }
211         user.rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e12);
212         emit Deposit(msg.sender, _pid, _amount);
213     }
214 
215     function withdraw(uint256 _pid, uint256 _amount) external legalPid(_pid) {
216         PoolInfo storage pool = poolInfo[_pid];
217         UserInfo storage user = userInfo[_pid][msg.sender];
218         require(user.amount >= _amount, "withdraw: not enough");
219         updatePool(_pid);
220         uint256 pending = user.amount.mul(pool.accRewardPerShare).div(1e12).sub(user.rewardDebt);
221         if(pending > 0) {
222             fetch(msg.sender, pending);
223         }
224         if(_amount > 0) {
225             user.amount = user.amount.sub(_amount);
226             pool.lpToken.safeTransfer(address(msg.sender), _amount);
227         }
228         user.rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e12);
229         emit Withdraw(msg.sender, _pid, _amount);
230     }
231 
232     function emergencyWithdraw(uint256 _pid) public legalPid(_pid) {
233         PoolInfo storage pool = poolInfo[_pid];
234         UserInfo storage user = userInfo[_pid][msg.sender];
235         uint amount = user.amount;
236         user.amount = 0;
237         user.rewardDebt = 0;
238         pool.lpToken.safeTransfer(address(msg.sender), amount);
239         emit EmergencyWithdraw(msg.sender, _pid, amount);
240     }
241 }
