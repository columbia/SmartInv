1 // CosmicKiss Staking
2 // https://cosmickiss.io
3 
4 // SPDX-License-Identifier: MIT
5 pragma solidity 0.8.4;
6 
7 
8 interface IERC20 {
9   function balanceOf(address account) external view returns (uint256);
10   function transfer(address recipient, uint256 amount) external returns (bool);
11   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12 }
13 
14 
15 contract CosmicStake {
16 
17     mapping(address => uint256) public stakingBalance;
18     mapping(address => uint256) public yeildStartTime;
19     mapping(address => uint256) public parkedYeild;
20     mapping(address => uint256) public stakeStartTime;
21     mapping(address => bool) public isStaking;
22     IERC20 public cosmicToken;
23     bool public canStake;
24     bool public canUnstake;
25     bool public canYeild;
26     bool public canReinvest; 
27 
28     enum State {stake, unstake, yeildwithdraw,reinvest}
29 
30     event StakeEvent(address indexed form,uint256 amount,uint256 timestamp,State indexed state);
31 
32     
33     uint256 public ownBalance;
34     uint256 public rate;
35     uint256 public lockTime;
36     address public owner;
37  
38     constructor(IERC20 _cosmicToken,uint256 _rate,uint256 _lockTime) {
39             cosmicToken = _cosmicToken;
40             owner = msg.sender;
41             rate = _rate;
42             lockTime = _lockTime;
43             canStake = true;
44             canUnstake = true;
45             canYeild = true;
46             canReinvest = true;
47         }
48 
49 
50     modifier onlyOwner() {
51         require(msg.sender == owner, "Not owner");
52         _;
53     }
54 
55     function updateRate(uint256 newRate) onlyOwner public returns(bool){
56         rate = newRate;
57         return true;
58     }
59     
60     function updateLockTime(uint256 newLockTime) onlyOwner public returns(bool){
61         lockTime = newLockTime;
62         return true;
63     }
64 
65     function transferOwnership(address newOwner) onlyOwner public returns(bool){
66         owner = newOwner;
67         return true;
68     }
69 
70     function updateTradingState(bool _canStake,bool _canUnstake,bool _canYeild,bool _canReinvest) onlyOwner public returns(bool){
71         canStake = _canStake;
72         canUnstake = _canUnstake;
73         canYeild = _canYeild;
74         canReinvest = _canReinvest;
75         return true;
76     }
77 
78     function emergency(uint256 amt) onlyOwner public {
79         cosmicToken.transfer(owner,amt);
80     }
81 
82     function stake(uint256 amount) public {
83         require(canStake,"function is disabled");
84         require(amount > 0,"You cannot stake zero tokens");
85             
86         if(isStaking[msg.sender] == true){
87             parkedYeild[msg.sender] += calculateYieldTotal(msg.sender);
88         }
89 
90         cosmicToken.transferFrom(msg.sender, address(this), amount);
91         stakingBalance[msg.sender] += amount;
92         ownBalance += amount;
93         stakeStartTime[msg.sender] = block.timestamp;
94         yeildStartTime[msg.sender] = block.timestamp;
95         isStaking[msg.sender] = true;
96         emit StakeEvent(msg.sender, amount,block.timestamp,State.stake);
97     }
98 
99     function unstake(uint256 amount) public {
100         require(canUnstake,"function is disabled");
101         require((stakeStartTime[msg.sender]+lockTime) < block.timestamp,"cannot unstake untill your time completes");
102         require(
103             isStaking[msg.sender] = true &&
104             stakingBalance[msg.sender] >= amount, 
105             "Nothing to unstake"
106         );
107         stakeStartTime[msg.sender] = block.timestamp;
108         yeildStartTime[msg.sender] = block.timestamp;
109         stakingBalance[msg.sender] -= amount;
110         cosmicToken.transfer(msg.sender, amount);
111         parkedYeild[msg.sender] += calculateYieldTotal(msg.sender);
112         ownBalance -= amount;
113         if(stakingBalance[msg.sender] == 0){
114             isStaking[msg.sender] = false;
115         }
116         emit StakeEvent(msg.sender, amount,block.timestamp,State.unstake);
117     }
118 
119     function calculateYieldTime(address user) public view returns(uint256){
120         uint256 end = block.timestamp;
121         uint256 totalTime = end - yeildStartTime[user];
122         return totalTime;
123     }
124 
125     function calculateYieldTotal(address user) public view returns(uint256) {
126         uint256 time = calculateYieldTime(user) * 10**18;
127         uint256 timeRate = time / rate;
128         uint256 rawYield = (stakingBalance[user] * timeRate) / 10**18;
129         return rawYield;
130     }
131 
132 
133     function reInvestRewards() public {
134         require(canReinvest,"function is disabled");
135         uint256 toReinvest = calculateYieldTotal(msg.sender);
136                     
137         if(parkedYeild[msg.sender] != 0){
138             toReinvest += parkedYeild[msg.sender];
139             parkedYeild[msg.sender] = 0;
140         }
141         require(toReinvest>0,"Nothing to reinvest");
142 
143         stakingBalance[msg.sender] += toReinvest;
144         ownBalance += toReinvest;
145         stakeStartTime[msg.sender] = block.timestamp;
146         yeildStartTime[msg.sender] = block.timestamp;
147         isStaking[msg.sender] = true;
148         emit StakeEvent(msg.sender, toReinvest,block.timestamp,State.reinvest);
149     }
150 
151     function withdrawYield() public {
152         require(canYeild,"function is disabled");
153         uint256 toTransfer = calculateYieldTotal(msg.sender);
154                     
155         if(parkedYeild[msg.sender] != 0){
156             toTransfer += parkedYeild[msg.sender];
157             parkedYeild[msg.sender] = 0;
158         }
159         require(toTransfer>0,"Nothing to yeild");
160         require((cosmicToken.balanceOf(address(this))-ownBalance)>=toTransfer,"Insufficient pool");
161         yeildStartTime[msg.sender] = block.timestamp;
162         cosmicToken.transfer(msg.sender, toTransfer);
163         emit StakeEvent(msg.sender, toTransfer,block.timestamp,State.yeildwithdraw);
164     } 
165 }