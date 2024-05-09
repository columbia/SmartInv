1 pragma solidity ^0.5.8;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7 
8         return c;
9     }
10     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
11         return sub(a, b, "SafeMath: subtraction overflow");
12     }
13     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
14         require(b <= a, errorMessage);
15         uint256 c = a - b;
16 
17         return c;
18     }
19     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b, "SafeMath: multiplication overflow");
26 
27         return c;
28     }
29     function div(uint256 a, uint256 b) internal pure returns (uint256) {
30         return div(a, b, "SafeMath: division by zero");
31     }
32     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b > 0, errorMessage);
34         uint256 c = a / b;
35 
36         return c;
37     }
38     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
39         return mod(a, b, "SafeMath: modulo by zero");
40     }
41     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b != 0, errorMessage);
43         return a % b;
44     }
45 }
46 
47 interface IERC20 {
48     function totalSupply() external view returns (uint256);
49     function balanceOf(address account) external view returns (uint256);
50     function transfer(address recipient, uint256 amount) external returns (bool);
51     function allowance(address owner, address spender) external view returns (uint256);
52     function approve(address spender, uint256 amount) external returns (bool);
53     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 }
58 
59 contract Pool {
60     using SafeMath for uint256;
61     
62     string public name;
63 
64     uint256 public poolStart;
65     uint256 public poolEnd;
66 
67     IERC20 public rewardToken;
68     IERC20 public stakeToken;
69 
70     uint256 public rewardPerBlock;
71 
72     uint256 public TOTAL_STAKED;
73 
74     address private CONSTRUCTOR_ADDRESS;
75     address private TEAM_POOL;
76 
77     mapping (address => uint256) private STAKED_AMOUNT;
78     mapping (address => uint256) private CUMULATED_REWARD;
79     mapping (address => uint256) private UPDATED_BLOCK;
80 
81     constructor (
82         string memory _name,
83         uint256 _poolStart,
84         uint256 _poolEnd,
85         uint256 _rewardPerBlock,
86         address _rewardToken, 
87         address _stakeToken,
88         address _teamPool
89     ) public {
90         rewardToken = IERC20(_rewardToken);
91         stakeToken = IERC20(_stakeToken);
92         name = _name;
93         poolStart = _poolStart;
94         poolEnd = _poolEnd;
95         rewardPerBlock = _rewardPerBlock;
96         TEAM_POOL = _teamPool;
97         CONSTRUCTOR_ADDRESS = msg.sender;
98     }
99 
100     function claimAllReward () external{
101         _updateReward(msg.sender);
102         require(CUMULATED_REWARD[msg.sender] > 0, "Nothing to claim");
103         uint256 amount = CUMULATED_REWARD[msg.sender];
104         CUMULATED_REWARD[msg.sender] = 0;
105         rewardToken.transfer(msg.sender, amount);
106     }
107 
108     function stake (uint256 amount) external {
109         uint256 oldBalance = stakeToken.balanceOf(address(this));
110         _updateReward(msg.sender);
111         stakeToken.transferFrom(msg.sender, address(this), amount);
112         require(stakeToken.balanceOf(address(this)) == oldBalance.add(amount), 'Stake failed');
113         STAKED_AMOUNT[msg.sender] = STAKED_AMOUNT[msg.sender].add(amount);
114         TOTAL_STAKED = TOTAL_STAKED.add(amount);
115     }
116 
117     function claimAndUnstake (uint256 amount) external {
118         _updateReward(msg.sender);
119         if(CUMULATED_REWARD[msg.sender] > 0){
120             uint256 rewards = CUMULATED_REWARD[msg.sender];
121             CUMULATED_REWARD[msg.sender] = 0;
122             rewardToken.transfer(msg.sender, rewards);
123         }
124         _withdraw(msg.sender, amount);
125     }
126 
127     function unstakeAll () external {
128         _updateReward(msg.sender);
129         _withdraw(msg.sender, STAKED_AMOUNT[msg.sender]);
130     }
131 
132     function emergencyExit () external {
133         _withdraw(msg.sender, STAKED_AMOUNT[msg.sender]);
134     }
135 
136     function inquiryDeposit (address host) external view returns (uint256) {
137         return STAKED_AMOUNT[host];
138     }
139     function inquiryRemainReward (address host) external view returns (uint256) {
140         return CUMULATED_REWARD[host];
141     }
142     function inquiryExpectedReward (address host) external view returns (uint256) {
143         return _calculateEarn(
144             _max(0, _elapsedBlock(UPDATED_BLOCK[host])), 
145             STAKED_AMOUNT[host]
146         ).mul(95).div(100).add(CUMULATED_REWARD[host]);
147     }
148 
149     function _withdraw (address host, uint256 amount) internal {
150         STAKED_AMOUNT[host] = STAKED_AMOUNT[host].sub(amount);
151         require(STAKED_AMOUNT[host] >= 0);
152         TOTAL_STAKED = TOTAL_STAKED.sub(amount);
153         stakeToken.transfer(host, amount);
154     }
155 
156     function _updateReward (address host) internal {
157         uint256 elapsed = _elapsedBlock(UPDATED_BLOCK[host]);
158         if(elapsed <= 0){return;}
159         UPDATED_BLOCK[host] = block.number;
160         uint256 baseEarned = _calculateEarn(elapsed, STAKED_AMOUNT[host]);
161         CUMULATED_REWARD[host] = baseEarned.mul(95).div(100).add(CUMULATED_REWARD[host]);
162         CUMULATED_REWARD[TEAM_POOL] = baseEarned.mul(5).div(100).add(CUMULATED_REWARD[TEAM_POOL]);
163     }
164 
165     function _elapsedBlock (uint256 updated) internal view returns (uint256) {
166         uint256 open = _max(updated, poolStart);
167         uint256 close = _min(block.number, poolEnd);
168         return open >= close ? 0 : close - open;
169     }
170 
171     function _calculateEarn (uint256 elapsed, uint256 staked) internal view returns (uint256) {
172         if(staked == 0){return 0;}
173         return elapsed.mul(staked).mul(rewardPerBlock).div(TOTAL_STAKED);
174     }
175 
176 
177     function _max(uint a, uint b) private pure returns (uint) {
178         return a > b ? a : b;
179     }
180     function _min(uint a, uint b) private pure returns (uint) {
181         return a < b ? a : b;
182     }
183 }