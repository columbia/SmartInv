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
63     uint256 public totalStaked;
64 
65     uint256 public poolStart;
66     uint256 public poolEnd;
67     uint256 public rewardPerBlock;
68 
69     IERC20 public rewardToken;
70     IERC20 public stakeToken;
71 
72     address private CONSTRUCTOR_ADDRESS;
73     address private TEAM_POOL;
74 
75     mapping (address => uint256) private STAKED_AMOUNT;
76     mapping (address => uint256) private CUMULATED_REWARD;
77     mapping (address => uint256) private UPDATED_BLOCK;
78     mapping (address => bool) private IS_REGISTED;
79     address[] private PARTICIPANT_LIST;
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
96         CONSTRUCTOR_ADDRESS = msg.sender;
97         TEAM_POOL = _teamPool;
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
109         _registAddress(msg.sender);
110         _updateReward(msg.sender);
111         stakeToken.transferFrom(msg.sender, address(this), amount);
112         STAKED_AMOUNT[msg.sender] = STAKED_AMOUNT[msg.sender].add(amount);
113         totalStaked = totalStaked.add(amount);
114     }
115 
116     function claimAndUnstake (uint256 amount) external {
117         _updateReward(msg.sender);
118         if(CUMULATED_REWARD[msg.sender] > 0){
119             uint256 rewards = CUMULATED_REWARD[msg.sender];
120             CUMULATED_REWARD[msg.sender] = 0;
121             rewardToken.transfer(msg.sender, rewards);
122         }
123         _withdraw(msg.sender, amount);
124     }
125 
126     function unstakeAll () external {
127         _updateReward(msg.sender);
128         _withdraw(msg.sender, STAKED_AMOUNT[msg.sender]);
129     }
130 
131     function emergencyExit () external {
132         _withdraw(msg.sender, STAKED_AMOUNT[msg.sender]);
133     }
134 
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
149 
150 
151     function _registAddress (address host) internal {
152         if(IS_REGISTED[host]){return;}
153         IS_REGISTED[host] = true;
154         PARTICIPANT_LIST.push(host);
155     }
156 
157     function _withdraw (address host, uint256 amount) internal {
158         STAKED_AMOUNT[host] = STAKED_AMOUNT[host].sub(amount);
159         require(STAKED_AMOUNT[host] >= 0);
160         totalStaked = totalStaked.sub(amount);
161         stakeToken.transfer(host, amount);
162     }
163 
164     function _updateAllReward () internal {
165         for(uint256 i=0; i<PARTICIPANT_LIST.length; i++){
166             _updateReward(PARTICIPANT_LIST[i]);
167         }
168     }
169 
170     function _updateReward (address host) internal {
171         uint256 elapsed = _elapsedBlock(UPDATED_BLOCK[host]);
172         if(elapsed <= 0){return;}
173         UPDATED_BLOCK[host] = block.number;
174         uint256 baseEarned = _calculateEarn(elapsed, STAKED_AMOUNT[host]);
175         CUMULATED_REWARD[host] = baseEarned.mul(95).div(100).add(CUMULATED_REWARD[host]);
176         CUMULATED_REWARD[TEAM_POOL] = baseEarned.mul(5).div(100).add(CUMULATED_REWARD[TEAM_POOL]);
177     }
178 
179     function _elapsedBlock (uint256 updated) internal view returns (uint256) {
180         uint256 open = _max(updated, poolStart);
181         uint256 close = _min(block.number, poolEnd);
182         return open >= close ? 0 : close - open;
183     }
184 
185     function _calculateEarn (uint256 elapsed, uint256 staked) internal view returns (uint256) {
186         if(staked == 0){return 0;}
187         return elapsed.mul(staked).mul(rewardPerBlock).div(totalStaked);
188     }
189 
190 
191     function changeRewardRate (uint256 rate) external {
192         require(CONSTRUCTOR_ADDRESS == msg.sender, "Only constructor can do this");
193         // _updateAllReward();
194         rewardPerBlock = rate;
195     }
196 
197 
198     function _max(uint a, uint b) private pure returns (uint) {
199         return a > b ? a : b;
200     }
201     function _min(uint a, uint b) private pure returns (uint) {
202         return a < b ? a : b;
203     }
204 }