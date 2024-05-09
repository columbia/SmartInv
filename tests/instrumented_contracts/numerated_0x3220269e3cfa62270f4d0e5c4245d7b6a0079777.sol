1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.6;
4 
5 interface IERC20 {
6   function totalSupply() external view returns (uint);
7   function balanceOf(address account) external view returns (uint);
8   function transfer(address recipient, uint256 amount) external returns (bool);
9   function allowance(address owner, address spender) external view returns (uint);
10   function symbol() external view returns (string memory);
11   function decimals() external view returns (uint);
12   function approve(address spender, uint amount) external returns (bool);
13   function mint(address account, uint amount) external;
14   function burn(address account, uint amount) external;
15   function transferFrom(address sender, address recipient, uint amount) external returns (bool);
16   event Transfer(address indexed from, address indexed to, uint value);
17   event Approval(address indexed owner, address indexed spender, uint value);
18 }
19 
20 contract Ownable {
21 
22   address public owner;
23   address public pendingOwner;
24 
25   event OwnershipTransferInitiated(address indexed previousOwner, address indexed newOwner);
26   event OwnershipTransferConfirmed(address indexed previousOwner, address indexed newOwner);
27 
28   constructor() {
29     owner = msg.sender;
30     emit OwnershipTransferConfirmed(address(0), owner);
31   }
32 
33   modifier onlyOwner() {
34     require(isOwner(), "Ownable: caller is not the owner");
35     _;
36   }
37 
38   function isOwner() public view returns (bool) {
39     return msg.sender == owner;
40   }
41 
42   function transferOwnership(address _newOwner) external onlyOwner {
43     require(_newOwner != address(0), "Ownable: new owner is the zero address");
44     emit OwnershipTransferInitiated(owner, _newOwner);
45     pendingOwner = _newOwner;
46   }
47 
48   function acceptOwnership() external {
49     require(msg.sender == pendingOwner, "Ownable: caller is not pending owner");
50     emit OwnershipTransferConfirmed(owner, pendingOwner);
51     owner = pendingOwner;
52     pendingOwner = address(0);
53   }
54 }
55 
56 // Calling setTotalRewardPerBlock, addPool or setReward, pending rewards will be changed.
57 // Since all pools are likely to get accrued every hour or so, this is an acceptable deviation.
58 // Accruing all pools here may consume too much gas.
59 // up to the point of exceeding the gas limit if there are too many pools.
60 
61 contract MasterPool is Ownable {
62 
63   struct UserInfo {
64     uint amount;
65     uint rewardDebt;
66   }
67 
68   // Info of each pool.
69   struct Pool {
70     IERC20 lpToken;        // Address of LP token contract.
71     uint points;      // How many allocation points assigned to this pool. RewardTokens to distribute per block.
72     uint lastRewardBlock;  // Last block number that RewardTokens distribution occurs.
73     uint accRewardTokenPerShare; // Accumulated RewardTokens per share, times 1e12. See below.
74   }
75 
76   struct PoolPosition {
77     uint pid;
78     bool added; // To prevent duplicates.
79   }
80 
81   IERC20 public rewardToken;
82   uint public totalRewardPerBlock;
83 
84   // Info of each pool.
85   Pool[] public pools;
86   // Info of each user that stakes LP tokens.
87   mapping (uint => mapping (address => UserInfo)) public userInfo;
88   mapping (address => PoolPosition) public pidByToken;
89   // Total allocation poitns. Must be the sum of all allocation points in all pools.
90   uint public totalPoints;
91 
92   event RewardRateUpdate(uint value);
93   event Deposit(address indexed user, uint indexed pid, uint amount);
94   event Withdraw(address indexed user, uint indexed pid, uint amount);
95   event EmergencyWithdraw(address indexed user, uint indexed pid, uint amount);
96 
97   event PoolUpdate(
98     address indexed lpToken,
99     uint    indexed pid,
100     uint            points
101   );
102 
103   constructor(
104     IERC20 _rewardToken,
105     uint _totalRewardPerBlock
106   ) {
107     rewardToken = _rewardToken;
108     totalRewardPerBlock = _totalRewardPerBlock;
109   }
110 
111   function poolLength() external view returns (uint) {
112     return pools.length;
113   }
114 
115   // Pending rewards will be changed. See class comments.
116   function addPool(address _lpToken, uint _points) external onlyOwner {
117 
118     require(pidByToken[_lpToken].added == false, "MasterPool: already added");
119 
120     totalPoints = totalPoints + _points;
121 
122     pools.push(Pool({
123       lpToken: IERC20(_lpToken),
124       points: _points,
125       lastRewardBlock: block.number,
126       accRewardTokenPerShare: 0
127     }));
128 
129     uint pid = pools.length - 1;
130 
131     pidByToken[_lpToken] = PoolPosition({
132       pid: pid,
133       added: true
134     });
135 
136     emit PoolUpdate(_lpToken, pid, _points);
137   }
138 
139   // Pending rewards will be changed. See class comments.
140   function setReward(uint _pid, uint _points) external onlyOwner {
141 
142     accruePool(_pid);
143 
144     totalPoints = totalPoints - pools[_pid].points + _points;
145     pools[_pid].points = _points;
146 
147     emit PoolUpdate(address(pools[_pid].lpToken), _pid, _points);
148   }
149 
150   // Pending rewards will be changed. See class comments.
151   function setTotalRewardPerBlock(uint _value) external onlyOwner {
152     totalRewardPerBlock = _value;
153     emit RewardRateUpdate(_value);
154   }
155 
156   // View function to see pending RewardTokens on frontend.
157   function pendingRewards(uint _pid, address _user) external view returns (uint) {
158 
159     Pool storage pool = pools[_pid];
160     UserInfo storage user = userInfo[_pid][_user];
161     uint accRewardTokenPerShare = pool.accRewardTokenPerShare;
162     uint lpSupply = pool.lpToken.balanceOf(address(this));
163 
164     if (block.number > pool.lastRewardBlock && lpSupply != 0) {
165       uint multiplier = block.number - pool.lastRewardBlock;
166       uint rewardTokenReward = multiplier * totalRewardPerBlock * pool.points / totalPoints;
167       accRewardTokenPerShare += rewardTokenReward * 1e12 / lpSupply;
168     }
169 
170     return (user.amount * accRewardTokenPerShare / 1e12) - user.rewardDebt;
171   }
172 
173   function accrueAllPools() public {
174       uint length = pools.length;
175       for (uint pid = 0; pid < length; ++pid) {
176         accruePool(pid);
177       }
178   }
179 
180   // Update reward variables of the given pool to be up-to-date.
181   function accruePool(uint _pid) public {
182     Pool storage pool = pools[_pid];
183     if (block.number <= pool.lastRewardBlock) {
184       return;
185     }
186     uint lpSupply = pool.lpToken.balanceOf(address(this));
187     if (lpSupply == 0) {
188       pool.lastRewardBlock = block.number;
189       return;
190     }
191     uint multiplier = block.number - pool.lastRewardBlock;
192     uint rewardTokenReward = multiplier * totalRewardPerBlock * pool.points / totalPoints;
193     pool.accRewardTokenPerShare += rewardTokenReward * 1e12 / lpSupply;
194     pool.lastRewardBlock = block.number;
195   }
196 
197   function deposit(uint _pid, uint _amount) external {
198     Pool storage pool = pools[_pid];
199     UserInfo storage user = userInfo[_pid][msg.sender];
200     accruePool(_pid);
201 
202     if (user.amount > 0) {
203       uint pending = (user.amount * pool.accRewardTokenPerShare / 1e12) - user.rewardDebt;
204       _safeRewardTokenTransfer(msg.sender, pending);
205     }
206 
207     pool.lpToken.transferFrom(address(msg.sender), address(this), _amount);
208     user.amount += _amount;
209     user.rewardDebt = user.amount * pool.accRewardTokenPerShare / 1e12;
210     emit Deposit(msg.sender, _pid, _amount);
211   }
212 
213   function withdraw(uint _pid, uint _amount) external {
214     Pool storage pool = pools[_pid];
215     UserInfo storage user = userInfo[_pid][msg.sender];
216     require(user.amount >= _amount, "MasterPool: user.amount >= _amount");
217     accruePool(_pid);
218     uint pending = (user.amount * pool.accRewardTokenPerShare / 1e12) - user.rewardDebt;
219     _safeRewardTokenTransfer(msg.sender, pending);
220     user.amount = user.amount - _amount;
221     user.rewardDebt = user.amount * pool.accRewardTokenPerShare / 1e12;
222     pool.lpToken.transfer(address(msg.sender), _amount);
223     emit Withdraw(msg.sender, _pid, _amount);
224   }
225 
226   function emergencyWithdraw(uint _pid) external {
227     Pool storage pool = pools[_pid];
228     UserInfo storage user = userInfo[_pid][msg.sender];
229     pool.lpToken.transfer(address(msg.sender), user.amount);
230     emit EmergencyWithdraw(msg.sender, _pid, user.amount);
231     user.amount = 0;
232     user.rewardDebt = 0;
233   }
234 
235   // Allows to migrate rewards to a new staking contract.
236   function migrateRewards(address _recipient, uint _amount) external onlyOwner {
237     rewardToken.transfer(_recipient, _amount);
238   }
239 
240   // Safe rewardToken transfer function, just in case if rounding error causes pool to not have enough RewardTokens.
241   function _safeRewardTokenTransfer(address _to, uint _amount) internal {
242     uint rewardTokenBal = rewardToken.balanceOf(address(this));
243     if (_amount > rewardTokenBal) {
244       rewardToken.transfer(_to, rewardTokenBal);
245     } else {
246       rewardToken.transfer(_to, _amount);
247     }
248   }
249 }