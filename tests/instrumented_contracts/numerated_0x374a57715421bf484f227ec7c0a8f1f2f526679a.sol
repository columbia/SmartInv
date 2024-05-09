1 pragma solidity ^0.8.4;
2 
3 interface IERC20{
4 
5   function balanceOf(address account) external view returns (uint256);
6 
7   function transfer(address recipient, uint256 amount) external returns (bool);
8 
9   function allowance(address _owner, address spender) external view returns (uint256);
10   
11   function approve(address spender, uint256 amount) external returns (bool);
12   
13   function increaseAllowance(address spender, uint256 addedValue) external;
14 
15   function decreaseAllowance(address spender, uint256 subtractedValue) external;
16 
17   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18 
19 }
20 
21 interface contract2{
22     
23     function claimRewards(address user) external returns(bool);
24 }
25 
26 interface MCHstakingInterface {
27     
28     function stakingStats(address user) external view returns(uint256 amount, uint256 stakingBlock) ;
29     
30     function totalStaked() external view returns(uint256);
31     
32     function showBlackUser(address user) external view returns(bool) ;
33     
34     function allowance(address user) external view returns(bool) ;
35     
36     function transferOwnership(address to) external ;
37     
38     function giveAllowence(address user) external ;
39     
40     function removeAllowence(address user) external ;
41     
42     function addToBlackList(address user) external ;
43 
44     function removeFromBlackList(address user) external ;
45     
46     function stakeMCH(uint256 amount) external ;
47     
48     function unstake(address user, uint256 amount) external ;
49     
50     function refreshBlock(address user) external ;    
51     
52     function setData(address user, uint256 staked, uint256 stakingBlock, uint256 stakedMCH) external ;    
53     
54     function transferMCH(address to, uint256 amount) external ;
55     
56     function emergencyWithdraw(uint256 amount) external ;    
57     
58     event Stake(address indexed staker, uint256 indexed amount);
59 }
60 contract MCHstaking is MCHstakingInterface {
61     
62     address private _owner;
63     mapping (address => bool) private _allowence;
64     IERC20 MCH;
65     contract2 MCF;
66     
67     mapping (address => uint256) private _staking;
68     mapping (address => uint256) private _block;
69     
70     uint256 _totalStaked;
71     
72     mapping (address => bool) private _blackListed;
73     
74     constructor(address MCHtoken) {
75         MCH = IERC20(MCHtoken);
76         _owner = msg.sender;
77         _allowence[msg.sender] = true;
78     }
79     
80     function setMCFcontract(address contractAddress) external {
81         require(msg.sender == _owner);
82         MCF = contract2(contractAddress);
83         _allowence[contractAddress] = true;
84     }
85     
86     //staking stats of a user
87     function stakingStats(address user) external view override returns(uint256 amount, uint256 stakingBlock){
88         amount = _staking[user];
89         stakingBlock = _block[user];
90     }
91     
92     function totalStaked() external view override returns(uint256){
93         return _totalStaked;
94     }
95     //shows if a user is black listed or not
96     function showBlackUser(address user) external view override returns(bool){
97         require(_allowence[msg.sender]);
98         return _blackListed[user];
99     }
100     
101     //shows if a user has allowance or not
102     function allowance(address user) external view override returns(bool){
103         require(_allowence[msg.sender]);
104         return _allowence[user];
105     }
106     
107     //======================================================================================================================================================
108     
109     function transferOwnership(address to) external override {
110         require(_owner == msg.sender);
111         _owner = to;
112     }
113     
114     function giveAllowence(address user) external override {
115         require(msg.sender == _owner);
116         _allowence[user] = true;
117     }
118     
119     function removeAllowence(address user) external override {
120         require(msg.sender == _owner);
121         _allowence[user] = false;
122     }  
123     
124     function addToBlackList(address user) external override {
125         require(_owner == msg.sender);
126         _blackListed[user] = true;
127     }
128 
129     function removeFromBlackList(address user) external override {
130         require(_owner == msg.sender);
131         _blackListed[user] = false;
132     }    
133     
134     function stakeMCH(uint256 amount) external override {
135         MCH.transferFrom(msg.sender, address(this), amount);
136             
137         if(address(MCF) != address(0)){MCF.claimRewards(msg.sender);}
138         _staking[msg.sender] += amount;
139         _block[msg.sender] = block.number;
140         _totalStaked += amount;
141         emit Stake(msg.sender, amount);
142     }
143     
144     function unstake(address user, uint256 amount) external override {
145         require(_allowence[msg.sender]);
146         _staking[user] -= amount;
147         _block[user] = block.number;
148         _totalStaked -= amount;
149     }
150     
151     function refreshBlock(address user) external override {
152         require(_allowence[msg.sender]);
153         _block[user] = block.number;
154     }
155     
156     function setData(address user, uint256 staked, uint256 stakingBlock, uint256 stakedMCH) external override {
157         require(_allowence[msg.sender]);
158         _staking[user] = staked;
159         _block[user] = stakingBlock;
160         _totalStaked = stakedMCH;
161         
162     }
163     
164     function transferMCH(address to, uint256 amount) external override {
165         require(_allowence[msg.sender]);
166         require(MCH.balanceOf(address(this)) - _totalStaked >= amount);
167         MCH.transfer(to, amount);
168     }
169     
170     function emergencyWithdraw(uint256 amount) external override {
171         require(msg.sender == _owner);
172         MCH.transfer(_owner, amount);
173     }
174 }