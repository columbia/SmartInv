1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.12;
4 
5 import '../libraries/SafeMath.sol';
6 import '../interfaces/IBEP20.sol';
7 import '../token/SafeBEP20.sol';
8 import '@openzeppelin/contracts/access/Ownable.sol';
9 
10 // import "@nomiclabs/buidler/console.sol";
11 
12 interface IWBNB {
13     function deposit() external payable;
14     function transfer(address to, uint256 value) external returns (bool);
15     function withdraw(uint256) external;
16 }
17 
18 contract BnbStaking is Ownable {
19     using SafeMath for uint256;
20     using SafeBEP20 for IBEP20;
21 
22     // Info of each user.
23     struct UserInfo {
24         uint256 amount;     // How many LP tokens the user has provided.
25         uint256 rewardDebt; // Reward debt. See explanation below.
26         bool inBlackList;
27     }
28 
29     // Info of each pool.
30     struct PoolInfo {
31         IBEP20 lpToken;           // Address of LP token contract.
32         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
33         uint256 lastRewardBlock;  // Last block number that CAKEs distribution occurs.
34         uint256 accCakePerShare; // Accumulated CAKEs per share, times 1e12. See below.
35     }
36 
37     // The REWARD TOKEN
38     IBEP20 public rewardToken;
39 
40     // adminAddress
41     address public adminAddress;
42 
43 
44     // WBNB
45     address public immutable WBNB;
46 
47     // CAKE tokens created per block.
48     uint256 public rewardPerBlock;
49 
50     // Info of each pool.
51     PoolInfo[] public poolInfo;
52     // Info of each user that stakes LP tokens.
53     mapping (address => UserInfo) public userInfo;
54     // limit 10 BNB here
55     uint256 public limitAmount = 10000000000000000000;
56     // Total allocation poitns. Must be the sum of all allocation points in all pools.
57     uint256 public totalAllocPoint = 0;
58     // The block number when CAKE mining starts.
59     uint256 public startBlock;
60     // The block number when CAKE mining ends.
61     uint256 public bonusEndBlock;
62 
63     event Deposit(address indexed user, uint256 amount);
64     event Withdraw(address indexed user, uint256 amount);
65     event EmergencyWithdraw(address indexed user, uint256 amount);
66 
67     constructor(
68         IBEP20 _lp,
69         IBEP20 _rewardToken,
70         uint256 _rewardPerBlock,
71         uint256 _startBlock,
72         uint256 _bonusEndBlock,
73         address _adminAddress,
74         address _wbnb
75     ) {
76         rewardToken = _rewardToken;
77         rewardPerBlock = _rewardPerBlock;
78         startBlock = _startBlock;
79         bonusEndBlock = _bonusEndBlock;
80         adminAddress = _adminAddress;
81         WBNB = _wbnb;
82 
83         // staking pool
84         poolInfo.push(PoolInfo({
85             lpToken: _lp,
86             allocPoint: 1000,
87             lastRewardBlock: startBlock,
88             accCakePerShare: 0
89         }));
90 
91         totalAllocPoint = 1000;
92 
93     }
94 
95     modifier onlyAdmin() {
96         require(msg.sender == adminAddress, "admin: wut?");
97         _;
98     }
99 
100     receive() external payable {
101         assert(msg.sender == WBNB); // only accept BNB via fallback from the WBNB contract
102     }
103 
104     // Update admin address by the previous dev.
105     function setAdmin(address _adminAddress) public onlyOwner {
106         adminAddress = _adminAddress;
107     }
108 
109     function setBlackList(address _blacklistAddress) public onlyAdmin {
110         userInfo[_blacklistAddress].inBlackList = true;
111     }
112 
113     function removeBlackList(address _blacklistAddress) public onlyAdmin {
114         userInfo[_blacklistAddress].inBlackList = false;
115     }
116 
117     // Set the limit amount. Can only be called by the owner.
118     function setLimitAmount(uint256 _amount) public onlyOwner {
119         limitAmount = _amount;
120     }
121 
122     // Return reward multiplier over the given _from to _to block.
123     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
124         if (_to <= bonusEndBlock) {
125             return _to.sub(_from);
126         } else if (_from >= bonusEndBlock) {
127             return 0;
128         } else {
129             return bonusEndBlock.sub(_from);
130         }
131     }
132 
133     // View function to see pending Reward on frontend.
134     function pendingReward(address _user) external view returns (uint256) {
135         PoolInfo storage pool = poolInfo[0];
136         UserInfo storage user = userInfo[_user];
137         uint256 accCakePerShare = pool.accCakePerShare;
138         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
139         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
140             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
141             uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
142             accCakePerShare = accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
143         }
144         return user.amount.mul(accCakePerShare).div(1e12).sub(user.rewardDebt);
145     }
146 
147     // Update reward variables of the given pool to be up-to-date.
148     function updatePool(uint256 _pid) public {
149         PoolInfo storage pool = poolInfo[_pid];
150         if (block.number <= pool.lastRewardBlock) {
151             return;
152         }
153         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
154         if (lpSupply == 0) {
155             pool.lastRewardBlock = block.number;
156             return;
157         }
158         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
159         uint256 cakeReward = multiplier.mul(rewardPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
160         pool.accCakePerShare = pool.accCakePerShare.add(cakeReward.mul(1e12).div(lpSupply));
161         pool.lastRewardBlock = block.number;
162     }
163 
164     // Update reward variables for all pools. Be careful of gas spending!
165     function massUpdatePools() public {
166         uint256 length = poolInfo.length;
167         for (uint256 pid = 0; pid < length; ++pid) {
168             updatePool(pid);
169         }
170     }
171 
172 
173     // Stake tokens to SmartChef
174     function deposit() public payable {
175         PoolInfo storage pool = poolInfo[0];
176         UserInfo storage user = userInfo[msg.sender];
177 
178         require (user.amount.add(msg.value) <= limitAmount, 'exceed the top');
179         require (!user.inBlackList, 'in black list');
180 
181         updatePool(0);
182         if (user.amount > 0) {
183             uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
184             if(pending > 0) {
185                 rewardToken.safeTransfer(address(msg.sender), pending);
186             }
187         }
188         if(msg.value > 0) {
189             IWBNB(WBNB).deposit{value: msg.value}();
190             assert(IWBNB(WBNB).transfer(address(this), msg.value));
191             user.amount = user.amount.add(msg.value);
192         }
193         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
194 
195         emit Deposit(msg.sender, msg.value);
196     }
197 
198     function safeTransferBNB(address to, uint256 value) internal {
199         (bool success, ) = to.call{gas: 23000, value: value}("");
200         // (bool success,) = to.call{value:value}(new bytes(0));
201         require(success, 'TransferHelper: ETH_TRANSFER_FAILED');
202     }
203 
204     // Withdraw tokens from STAKING.
205     function withdraw(uint256 _amount) public {
206         PoolInfo storage pool = poolInfo[0];
207         UserInfo storage user = userInfo[msg.sender];
208         require(user.amount >= _amount, "withdraw: not good");
209         updatePool(0);
210         uint256 pending = user.amount.mul(pool.accCakePerShare).div(1e12).sub(user.rewardDebt);
211         if(pending > 0 && !user.inBlackList) {
212             rewardToken.safeTransfer(address(msg.sender), pending);
213         }
214         if(_amount > 0) {
215             user.amount = user.amount.sub(_amount);
216             IWBNB(WBNB).withdraw(_amount);
217             safeTransferBNB(address(msg.sender), _amount);
218         }
219         user.rewardDebt = user.amount.mul(pool.accCakePerShare).div(1e12);
220 
221         emit Withdraw(msg.sender, _amount);
222     }
223 
224     // Withdraw without caring about rewards. EMERGENCY ONLY.
225     function emergencyWithdraw() public {
226         PoolInfo storage pool = poolInfo[0];
227         UserInfo storage user = userInfo[msg.sender];
228         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
229         emit EmergencyWithdraw(msg.sender, user.amount);
230         user.amount = 0;
231         user.rewardDebt = 0;
232     }
233 
234     // Withdraw reward. EMERGENCY ONLY.
235     function emergencyRewardWithdraw(uint256 _amount) public onlyOwner {
236         require(_amount < rewardToken.balanceOf(address(this)), 'not enough token');
237         rewardToken.safeTransfer(address(msg.sender), _amount);
238     }
239 
240 }
