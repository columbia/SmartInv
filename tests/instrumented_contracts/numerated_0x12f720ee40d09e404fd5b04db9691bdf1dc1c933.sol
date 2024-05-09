1 pragma solidity >=0.4.0 <0.6.0;
2  
3  interface tokenToTransfer {
4         function transfer(address to, uint256 value) external;
5         function transferFrom(address from, address to, uint256 value) external;
6         function balanceOf(address owner) external returns (uint256);
7     }
8     
9     contract Ownable {
10         address private _owner;
11         
12         constructor() public {
13             _owner = msg.sender;
14         }
15         
16         modifier onlyOwner() {
17             require(isOwner());
18             _;
19          }
20           
21         function isOwner() public view returns(bool) {
22             return msg.sender == _owner;
23          }
24           
25         function transferOwnership(address newOwner) public onlyOwner {
26             _transferOwnership(newOwner);
27         }
28         
29         function _transferOwnership(address newOwner) internal {
30             require(newOwner != address(0));
31             _owner = newOwner;
32         }
33     }
34     
35     contract StakeImperial is Ownable {
36     //Setup of public variables for maintaing between contract transactions
37     address private ImperialAddress = address(0x25cef4fb106e76080e88135a0e4059276fa9be87);
38     tokenToTransfer private sendtTransaction;
39     
40     //Setup of staking variables for contract maintenance 
41     mapping (address => uint256) private stake;
42     mapping (address => uint256) private timeinStake;
43     mapping (address => bool) private hasUserStaked;
44     uint256 private time = now;
45     uint256 private reward;
46     uint256 private timeVariable = 86400;
47     uint256 private allStakes;
48     bool private higherReward = true;
49     
50     function View_Balance() public view returns (uint256) {
51         sendtTransaction = tokenToTransfer(ImperialAddress);
52         return sendtTransaction.balanceOf(msg.sender);
53     }
54     
55     function View_ContractBalance() public view returns (uint256) {
56         sendtTransaction = tokenToTransfer(ImperialAddress);
57         return sendtTransaction.balanceOf(address(this));
58     }
59     
60     function initateStake() public {
61         //uint256 stakedAmount = stake * 1000000;
62         sendtTransaction = tokenToTransfer(ImperialAddress);
63         uint256 stakedAmount = View_Balance();
64         
65                 if (stakedAmount == 0) {
66                     revert();
67                 }
68                 
69                 if (hasUserStaked[msg.sender] == true) {
70                     revert();
71                 }
72         
73         sendtTransaction.transferFrom(msg.sender, address(this), stakedAmount);
74         stake[msg.sender] = stakedAmount;
75         allStakes += stakedAmount;
76         timeinStake[msg.sender] = now;
77         hasUserStaked[msg.sender] = true;
78     }
79     
80     function displayStake() public view returns (uint256) {
81         return stake[msg.sender];
82     }
83     
84     function displayBalance() public view returns (uint256) {
85         uint256 balanceTime = (now - timeinStake[msg.sender]) / timeVariable;
86         if (higherReward == true) {
87         return balanceTime * reward * stake[msg.sender];
88         } else {
89         balanceTime = balanceTime * (stake[msg.sender] / reward) + stake[msg.sender];
90         return balanceTime;
91         }
92     }
93 
94     function displayTime() public view returns (uint256) {
95         return time;
96     }
97     
98     function displayAllStakes() public view returns (uint256) {
99         return allStakes;
100     }
101     
102     function displayTimeVariable() public view returns (uint256) {
103         return timeVariable;
104     }
105     
106     function displayTimeWhenUserStaked() public view returns (uint256) {
107         return timeinStake[msg.sender];
108     }
109     
110     function displayRewardBool() public view returns (bool) {
111         return higherReward;
112     }
113     
114     function displayRewardVariable() public view returns (uint256) {
115         return reward;
116     }
117     
118     /* ADMIN FUNCTIONS */
119     //Admin change address to updated address function
120     function displayUserStake(address user) public view onlyOwner returns (uint256) {
121         return stake[user];
122     }
123     
124     function adminWithdraw(uint256 amount, address ownerAddress) public onlyOwner {
125         sendtTransaction = tokenToTransfer(ImperialAddress);
126         sendtTransaction.transfer(ownerAddress, amount);
127     }
128     
129     function changeImperialAddresstoNew(address change) public onlyOwner {
130         ImperialAddress = change;
131     }
132     
133     //Admin change reward function
134     function changeReward(uint256 change) public onlyOwner {
135         reward = change;
136     }
137     
138     //Admin change reward function
139     function changeTimeVariable(uint256 change) public onlyOwner {
140         timeVariable = change;
141     }
142     
143     //Admin reward function for lower than 100%
144     function changeRewardtoLower(bool value) public onlyOwner {
145         higherReward = value;
146     }
147     
148     //Admin reset time balance to reset stake to new level
149     function resetTime() public onlyOwner {
150         time = now;
151     }
152 
153     function withdrawBalance() public {
154         uint256 balanceTime = now - timeinStake[msg.sender];
155         if (balanceTime < timeVariable) {
156                 revert();
157         }
158         
159         if (timeinStake[msg.sender] == 0) {
160             revert();
161         }
162         sendtTransaction = tokenToTransfer(ImperialAddress);
163         uint256 getUserBalance = displayBalance();
164         uint256 contractBalance = View_ContractBalance();
165         //Ensure users can get their balance
166             if (getUserBalance > contractBalance) {
167                 revert();
168             }
169         sendtTransaction.transfer(msg.sender, getUserBalance);
170         stake[msg.sender] = 0;
171         allStakes -= getUserBalance;
172         timeinStake[msg.sender] = 0;
173         hasUserStaked[msg.sender] = false;
174     }
175     
176  }