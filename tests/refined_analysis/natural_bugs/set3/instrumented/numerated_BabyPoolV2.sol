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
11 contract BabyPoolV2 is SafeOwnable {
12     using SafeMath for uint256;
13     using SafeERC20 for IERC20;
14 
15     struct UserInfo {
16         uint256 amount;     // How many LP tokens the user has provided.
17         uint256 rewardDebt; // Reward debt. See explanation below.
18     }
19 
20     enum FETCH_VAULT_TYPE {
21         FROM_ALL,
22         FROM_BALANCE,
23         FROM_TOKEN
24     }
25 
26     IERC20 public immutable token;
27     uint256 public startBlock;
28     uint256 lastRewardBlock;                    // Last block number that CAKEs distribution occurs.
29     uint256 accRewardPerShare;                  // Accumulated CAKEs per share, times 1e12. See below.
30 
31     BabyVault public vault;
32     uint256 public rewardPerBlock;
33 
34     mapping (address => UserInfo) public userInfo;
35     FETCH_VAULT_TYPE public fetchVaultType;
36 
37     event Deposit(address indexed user, uint256 amount);
38     event Withdraw(address indexed user, uint256 amount);
39     event EmergencyWithdraw(address indexed user, uint256 amount);
40 
41     function fetch(address _to, uint _amount) internal returns(uint) {
42         if (fetchVaultType == FETCH_VAULT_TYPE.FROM_ALL) {
43             return vault.mint(msg.sender, _amount);
44         } else if (fetchVaultType == FETCH_VAULT_TYPE.FROM_BALANCE) {
45             return vault.mintOnlyFromBalance(_to, _amount);
46         } else if (fetchVaultType == FETCH_VAULT_TYPE.FROM_TOKEN) {
47             return vault.mintOnlyFromToken(_to, _amount);
48         } 
49     }
50     
51     constructor(BabyVault _vault, uint256 _rewardPerBlock, uint256 _startBlock, address _owner) {
52         token = _vault.babyToken();
53         require(_startBlock >= block.number, "illegal startBlock");
54         startBlock = _startBlock;
55         vault = _vault;
56         rewardPerBlock = _rewardPerBlock;
57         lastRewardBlock = block.number > _startBlock ? block.number : _startBlock;
58         if (_owner != address(0)) {
59             _transferOwnership(_owner);
60         }
61     }
62 
63     function poolInfo(uint _pid) external view returns (IERC20 token, uint256 allocPoint, uint256 lastRewardBlock, uint256 accRewardPerShare) {
64         require(_pid == 0, "illegal pid");
65         return (token, 0, lastRewardBlock, accRewardPerShare);
66     }
67 
68     function setVault(BabyVault _vault) external onlyOwner {
69         require(_vault.babyToken() == token, "illegal vault");
70         vault = _vault;
71     }
72 
73     function setRewardPerBlock(uint _rewardPerBlock) external onlyOwner {
74         updatePool();
75         rewardPerBlock = _rewardPerBlock;
76     }
77 
78     function setStartBlock(uint _newStartBlock) external onlyOwner {
79         require(block.number < startBlock && _newStartBlock >= block.number, "illegal start Block Number");
80         startBlock = _newStartBlock;
81     }
82 
83     function updatePool() public {
84         if (block.number <= lastRewardBlock) {
85             return;
86         }
87         uint256 depositSupply = token.balanceOf(address(this));
88         if (depositSupply == 0) {
89             lastRewardBlock = block.number;
90             return;
91         }
92         uint256 multiplier = block.number.sub(lastRewardBlock);
93         uint256 reward = multiplier.mul(rewardPerBlock);
94         accRewardPerShare = accRewardPerShare.add(reward.mul(1e12).div(depositSupply));
95         lastRewardBlock = block.number;
96     }
97 
98     function pendingReward(address _user) external view returns (uint256) {
99         UserInfo storage user = userInfo[_user];
100         uint acc = accRewardPerShare;
101         uint256 depositSupply = token.balanceOf(address(this));
102         if (block.number > lastRewardBlock && depositSupply != 0) {
103             uint256 multiplier = block.number.sub(lastRewardBlock);
104             uint256 reward = multiplier.mul(rewardPerBlock);
105             acc = acc.add(reward.mul(1e12).div(depositSupply));
106         }
107         return user.amount.mul(acc).div(1e12).sub(user.rewardDebt);
108     }
109 
110     function enterStaking(uint256 _amount) public {
111         UserInfo storage user = userInfo[msg.sender];
112         updatePool();
113         if (user.amount > 0) {
114             uint256 pending = user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
115             if(pending > 0) {
116                 fetch(msg.sender, pending);
117             }
118         }
119         if(_amount > 0) {
120             token.safeTransferFrom(address(msg.sender), address(this), _amount);
121             user.amount = user.amount.add(_amount);
122         }
123         user.rewardDebt = user.amount.mul(accRewardPerShare).div(1e12);
124         emit Deposit(msg.sender, _amount);
125     }
126 
127     function leaveStaking(uint256 _amount) public {
128         UserInfo storage user = userInfo[msg.sender];
129         require(user.amount >= _amount, "withdraw: not enough");
130         updatePool();
131         uint256 pending = user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
132         if(pending > 0) {
133             fetch(msg.sender, pending);
134         }
135         if(_amount > 0) {
136             user.amount = user.amount.sub(_amount);
137             token.safeTransfer(address(msg.sender), _amount);
138         }
139         user.rewardDebt = user.amount.mul(accRewardPerShare).div(1e12);
140         emit Withdraw(msg.sender, _amount);
141     }
142 
143     function emergencyWithdraw() public {
144         UserInfo storage user = userInfo[msg.sender];
145         uint amount = user.amount;
146         user.amount = 0;
147         user.rewardDebt = 0;
148         token.safeTransfer(address(msg.sender), amount);
149         emit EmergencyWithdraw(msg.sender, amount);
150     }
151 }
