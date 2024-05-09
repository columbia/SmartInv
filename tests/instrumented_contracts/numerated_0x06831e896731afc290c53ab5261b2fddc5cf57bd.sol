1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IERC20 {
6   function initialize() external;
7   function totalSupply() external view returns (uint);
8   function balanceOf(address account) external view returns (uint);
9   function transfer(address recipient, uint256 amount) external returns (bool);
10   function allowance(address owner, address spender) external view returns (uint);
11   function symbol() external view returns (string memory);
12   function decimals() external view returns (uint);
13   function approve(address spender, uint amount) external returns (bool);
14   function mint(address account, uint amount) external;
15   function burn(address account, uint amount) external;
16   function transferFrom(address sender, address recipient, uint amount) external returns (bool);
17   event Transfer(address indexed from, address indexed to, uint value);
18   event Approval(address indexed owner, address indexed spender, uint value);
19 }
20 
21 contract Ownable {
22 
23   address public owner;
24 
25   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
26 
27   constructor() {
28     owner = msg.sender;
29     emit OwnershipTransferred(address(0), owner);
30   }
31 
32   modifier onlyOwner() {
33     require(isOwner(), "Ownable: caller is not the owner");
34     _;
35   }
36 
37   function isOwner() public view returns (bool) {
38     return msg.sender == owner;
39   }
40 
41   function renounceOwnership() public onlyOwner {
42     emit OwnershipTransferred(owner, address(0));
43     owner = address(0);
44   }
45 
46   function transferOwnership(address newOwner) public onlyOwner {
47     _transferOwnership(newOwner);
48   }
49 
50   function _transferOwnership(address newOwner) internal {
51     require(newOwner != address(0), "Ownable: new owner is the zero address");
52     emit OwnershipTransferred(owner, newOwner);
53     owner = newOwner;
54   }
55 }
56 
57 contract MasterPool is Ownable {
58 
59   struct UserInfo {
60     uint amount;
61     uint rewardDebt;
62   }
63 
64   // Info of each pool.
65   struct PoolInfo {
66     IERC20 lpToken;        // Address of LP token contract.
67     uint allocPoints;      // How many allocation points assigned to this pool. RewardTokens to distribute per block.
68     uint lastRewardBlock;  // Last block number that RewardTokens distribution occurs.
69     uint accRewardTokenPerShare; // Accumulated RewardTokens per share, times 1e12. See below.
70   }
71 
72   struct PoolPosition {
73     uint pid;
74     bool added; // To prevent duplicates.
75   }
76 
77   IERC20 public rewardToken;
78   uint public rewardTokenPerBlock;
79 
80   // Info of each pool.
81   PoolInfo[] public poolInfo;
82   // Info of each user that stakes LP tokens.
83   mapping (uint => mapping (address => UserInfo)) public userInfo;
84   mapping (address => PoolPosition) public pidByToken;
85   // Total allocation poitns. Must be the sum of all allocation points in all pools.
86   uint public totalAllocPoints;
87   // The block number when RewardToken mining starts.
88   uint public startBlock;
89 
90   event Deposit(address indexed user, uint indexed pid, uint amount);
91   event Withdraw(address indexed user, uint indexed pid, uint amount);
92   event EmergencyWithdraw(address indexed user, uint indexed pid, uint amount);
93 
94   event PoolUpdate(
95     address indexed lpToken,
96     uint    indexed pid,
97     uint            allocPoints,
98     bool    indexed withUpdate
99   );
100 
101   constructor(
102     IERC20 _rewardToken,
103     uint _rewardTokenPerBlock,
104     uint _startBlock
105   ) {
106     rewardToken = _rewardToken;
107     rewardTokenPerBlock = _rewardTokenPerBlock;
108     startBlock = _startBlock;
109   }
110 
111   function poolLength() external view returns (uint) {
112     return poolInfo.length;
113   }
114 
115   // Add a new lp to the pool. Can only be called by the owner.
116   function add(address _lpToken, uint _allocPoints, bool _withUpdate) public onlyOwner {
117 
118     require(pidByToken[_lpToken].added == false, "MasterPool: already added");
119 
120     if (_withUpdate) {
121       massUpdatePools();
122     }
123 
124     uint lastRewardBlock = block.number > startBlock ? block.number : startBlock;
125     totalAllocPoints = totalAllocPoints + _allocPoints;
126     poolInfo.push(PoolInfo({
127       lpToken: IERC20(_lpToken),
128       allocPoints: _allocPoints,
129       lastRewardBlock: lastRewardBlock,
130       accRewardTokenPerShare: 0
131     }));
132 
133     pidByToken[_lpToken] = PoolPosition({
134       pid: poolInfo.length - 1,
135       added: true
136     });
137 
138     emit PoolUpdate(_lpToken, poolInfo.length - 1, _allocPoints, _withUpdate);
139   }
140 
141   // Update the given pool's RewardToken allocation point. Can only be called by the owner.
142   function set(uint _pid, uint _allocPoints, bool _withUpdate) public onlyOwner {
143 
144     if (_withUpdate) {
145       massUpdatePools();
146     }
147 
148     totalAllocPoints = totalAllocPoints - poolInfo[_pid].allocPoints + _allocPoints;
149     poolInfo[_pid].allocPoints = _allocPoints;
150 
151     emit PoolUpdate(address(poolInfo[_pid].lpToken), _pid, _allocPoints, _withUpdate);
152   }
153 
154   // View function to see pending RewardTokens on frontend.
155   function pendingRewards(uint _pid, address _user) external view returns (uint) {
156 
157     PoolInfo storage pool = poolInfo[_pid];
158     UserInfo storage user = userInfo[_pid][_user];
159     uint accRewardTokenPerShare = pool.accRewardTokenPerShare;
160     uint lpSupply = pool.lpToken.balanceOf(address(this));
161 
162     if (block.number > pool.lastRewardBlock && lpSupply != 0) {
163       uint multiplier = block.number - pool.lastRewardBlock;
164       uint rewardTokenReward = multiplier * rewardTokenPerBlock * pool.allocPoints / totalAllocPoints;
165       accRewardTokenPerShare += rewardTokenReward * 1e12 / lpSupply;
166     }
167 
168     return (user.amount * accRewardTokenPerShare / 1e12) - user.rewardDebt;
169   }
170 
171   // Update reward vairables for all pools. Be careful of gas spending!
172   function massUpdatePools() public {
173       uint length = poolInfo.length;
174       for (uint pid = 0; pid < length; ++pid) {
175         updatePool(pid);
176       }
177   }
178 
179   // Update reward variables of the given pool to be up-to-date.
180   function updatePool(uint _pid) public {
181     PoolInfo storage pool = poolInfo[_pid];
182     if (block.number <= pool.lastRewardBlock) {
183       return;
184     }
185     uint lpSupply = pool.lpToken.balanceOf(address(this));
186     if (lpSupply == 0) {
187       pool.lastRewardBlock = block.number;
188       return;
189     }
190     uint multiplier = block.number - pool.lastRewardBlock;
191     uint rewardTokenReward = multiplier * rewardTokenPerBlock * pool.allocPoints / totalAllocPoints;
192     pool.accRewardTokenPerShare += rewardTokenReward * 1e12 / lpSupply;
193     pool.lastRewardBlock = block.number;
194   }
195 
196   function deposit(uint _pid, uint _amount) public {
197     PoolInfo storage pool = poolInfo[_pid];
198     UserInfo storage user = userInfo[_pid][msg.sender];
199     updatePool(_pid);
200 
201     if (user.amount > 0) {
202       uint pending = (user.amount * pool.accRewardTokenPerShare / 1e12) - user.rewardDebt;
203       safeRewardTokenTransfer(msg.sender, pending);
204     }
205 
206     pool.lpToken.transferFrom(address(msg.sender), address(this), _amount);
207     user.amount += _amount;
208     user.rewardDebt = user.amount * pool.accRewardTokenPerShare / 1e12;
209     emit Deposit(msg.sender, _pid, _amount);
210   }
211 
212   function withdraw(uint _pid, uint _amount) public {
213     PoolInfo storage pool = poolInfo[_pid];
214     UserInfo storage user = userInfo[_pid][msg.sender];
215     require(user.amount >= _amount, "MasterPool: user.amount >= _amount");
216     updatePool(_pid);
217     uint pending = (user.amount * pool.accRewardTokenPerShare / 1e12) - user.rewardDebt;
218     safeRewardTokenTransfer(msg.sender, pending);
219     user.amount = user.amount - _amount;
220     user.rewardDebt = user.amount * pool.accRewardTokenPerShare / 1e12;
221     pool.lpToken.transfer(address(msg.sender), _amount);
222     emit Withdraw(msg.sender, _pid, _amount);
223   }
224 
225   function emergencyWithdraw(uint _pid) public {
226     PoolInfo storage pool = poolInfo[_pid];
227     UserInfo storage user = userInfo[_pid][msg.sender];
228     pool.lpToken.transfer(address(msg.sender), user.amount);
229     emit EmergencyWithdraw(msg.sender, _pid, user.amount);
230     user.amount = 0;
231     user.rewardDebt = 0;
232   }
233 
234   // Allows to migrate rewards to a new staking contract.
235   function migrateRewards(address _recipient, uint _amount) public onlyOwner {
236     rewardToken.transfer(_recipient, _amount);
237   }
238 
239   // Safe rewardToken transfer function, just in case if rounding error causes pool to not have enough RewardTokens.
240   function safeRewardTokenTransfer(address _to, uint _amount) internal {
241     uint rewardTokenBal = rewardToken.balanceOf(address(this));
242     if (_amount > rewardTokenBal) {
243       rewardToken.transfer(_to, rewardTokenBal);
244     } else {
245       rewardToken.transfer(_to, _amount);
246     }
247   }
248 }