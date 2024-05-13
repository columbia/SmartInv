1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.6.12;
4 
5 import '../libraries/SafeMath.sol';
6 import '../interfaces/IBEP20.sol';
7 import '../token/SafeBEP20.sol';
8 import '@openzeppelin/contracts/access/Ownable.sol';
9 import 'hardhat/console.sol';
10 
11 import "../token/BabyToken.sol";
12 import "./SyrupBar.sol";
13 
14 // import "@nomiclabs/buidler/console.sol";
15 
16 contract ILO is Ownable {
17     using SafeMath for uint256;
18     using SafeBEP20 for IBEP20;
19 
20     struct UserInfo {
21         uint256 amount;     
22         uint256 lastTime;
23     }
24     struct PoolInfo {
25         IBEP20 lpToken;           // Address of LP token contract.
26         uint256 allocPoint;       // How many allocation points assigned to this pool. CAKEs to distribute per block.
27         uint256 totalAmount;
28     }
29 
30     BabyToken public cake;
31 
32     PoolInfo[] public poolInfo;
33     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
34     uint256 public totalAllocPoint = 0;
35     uint256 public startBlock;
36     uint256 public endBlock;
37     
38     function setStartBlock(uint256 blockNumber) public onlyOwner {
39         startBlock = blockNumber;
40     }
41 
42     function setEndBlock(uint256 blockNumber) public onlyOwner {
43         endBlock = blockNumber;
44     }
45     
46     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
47     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
48     event Claim(address indexed user, uint256 indexed pid, uint256 amount);
49 
50     constructor(
51         BabyToken _cake,
52         uint256 _startBlock,
53         uint256 _endBlock
54     ) {
55         cake = _cake;
56         startBlock = _startBlock;
57         endBlock = _endBlock;
58     }
59 
60     function poolLength() external view returns (uint256) {
61         return poolInfo.length;
62     }
63 
64     function add(uint256 _allocPoint, IBEP20 _lpToken) external onlyOwner {
65         totalAllocPoint = totalAllocPoint.add(_allocPoint);
66         poolInfo.push(PoolInfo({
67             lpToken: _lpToken,
68             allocPoint: _allocPoint,
69             totalAmount: 0
70         }));
71     }
72 
73     function pendingBaby(uint256 _pid, address _user) public view returns (uint256) {
74         PoolInfo storage pool = poolInfo[_pid];
75         UserInfo storage user = userInfo[_pid][_user];
76         uint256 balance = cake.balanceOf(address(this));
77         if (balance == 0) {
78             return 0; 
79         }
80         uint256 poolBalance = balance.mul(pool.allocPoint).div(totalAllocPoint);
81         if (poolBalance == 0) {
82             return 0;
83         }
84         if (pool.totalAmount == 0) {
85             return 0;
86         }
87         return balance.mul(pool.allocPoint).mul(user.amount).div(totalAllocPoint).div(pool.totalAmount);
88     }
89 
90     function deposit(uint256 _pid, uint256 _amount) external {
91 
92         PoolInfo storage pool = poolInfo[_pid];
93         UserInfo storage user = userInfo[_pid][msg.sender];
94         require(block.number >= startBlock, "ILO not begin");
95         require(block.number <= endBlock, "ILO already finish");
96         require(_amount > 0, "illegal amount");
97 
98         //if (_amount > 0) {
99             user.amount = user.amount.add(_amount);
100             user.lastTime = block.timestamp;
101             pool.totalAmount = pool.totalAmount.add(_amount);
102             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
103         //}
104 
105         emit Deposit(msg.sender, _pid, _amount);
106     }
107 
108 
109 
110     function withdraw(uint256 _pid) external {
111         require(block.number > endBlock, "Can not claim now");
112         PoolInfo storage pool = poolInfo[_pid];
113         UserInfo storage user = userInfo[_pid][msg.sender];
114         uint256 pendingAmount = pendingBaby(_pid, msg.sender);
115         if (pendingAmount > 0) {
116             safeCakeTransfer(msg.sender, pendingAmount);
117             emit Claim(msg.sender, _pid, pendingAmount);
118         }
119         if (user.amount > 0) {
120             uint _amount = user.amount;
121             user.amount = 0;
122             user.lastTime = block.timestamp;
123             pool.lpToken.safeTransfer(address(msg.sender), _amount);
124             emit Withdraw(msg.sender, _pid, _amount);
125         }
126     }
127 
128     function ownerWithdraw(address _to, uint256 _amount) public onlyOwner {
129         require(block.number < startBlock || block.number >= endBlock + 403200, "ILO already start");  //after a week can withdraw
130         safeCakeTransfer(_to, _amount);
131     }
132 
133     // Safe cake transfer function, just in case if rounding error causes pool to not have enough CAKEs.
134     function safeCakeTransfer(address _to, uint256 _amount) internal {
135         uint256 balance = cake.balanceOf(address(this));
136         if (_amount > balance) {
137             _amount = balance;
138         }
139         IBEP20(address(cake)).safeTransfer(_to, _amount);
140     }
141 
142 }
