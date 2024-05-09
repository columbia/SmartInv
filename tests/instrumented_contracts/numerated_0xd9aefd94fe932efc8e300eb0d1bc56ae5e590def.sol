1 // solium-disable linebreak-style
2 pragma solidity ^0.5.0;
3 
4 contract CryptoTycoonsVIPLib{
5     
6     address payable public owner;
7     
8     // Accumulated jackpot fund.
9     uint128 public jackpotSize;
10     uint128 public rankingRewardSize;
11     
12     mapping (address => uint) userExpPool;
13     mapping (address => bool) public callerMap;
14 
15     event RankingRewardPayment(address indexed beneficiary, uint amount);
16 
17     modifier onlyOwner {
18         require(msg.sender == owner, "OnlyOwner methods called by non-owner.");
19         _;
20     }
21 
22     modifier onlyCaller {
23         bool isCaller = callerMap[msg.sender];
24         require(isCaller, "onlyCaller methods called by non-caller.");
25         _;
26     }
27 
28     constructor() public{
29         owner = msg.sender;
30         callerMap[owner] = true;
31     }
32 
33     // Fallback function deliberately left empty. It's primary use case
34     // is to top up the bank roll.
35     function () external payable {
36     }
37 
38     function kill() external onlyOwner {
39         selfdestruct(owner);
40     }
41 
42     function addCaller(address caller) public onlyOwner{
43         bool isCaller = callerMap[caller];
44         if (isCaller == false){
45             callerMap[caller] = true;
46         }
47     }
48 
49     function deleteCaller(address caller) external onlyOwner {
50         bool isCaller = callerMap[caller];
51         if (isCaller == true) {
52             callerMap[caller] = false;
53         }
54     }
55 
56     function addUserExp(address addr, uint256 amount) public onlyCaller{
57         uint exp = userExpPool[addr];
58         exp = exp + amount;
59         userExpPool[addr] = exp;
60     }
61 
62     function getUserExp(address addr) public view returns(uint256 exp){
63         return userExpPool[addr];
64     }
65 
66     function getVIPLevel(address user) public view returns (uint256 level) {
67         uint exp = userExpPool[user];
68 
69         if(exp >= 30 ether && exp < 150 ether){
70             level = 1;
71         } else if(exp >= 150 ether && exp < 300 ether){
72             level = 2;
73         } else if(exp >= 300 ether && exp < 1500 ether){
74             level = 3;
75         } else if(exp >= 1500 ether && exp < 3000 ether){
76             level = 4;
77         } else if(exp >= 3000 ether && exp < 15000 ether){
78             level = 5;
79         } else if(exp >= 15000 ether && exp < 30000 ether){
80             level = 6;
81         } else if(exp >= 30000 ether && exp < 150000 ether){
82             level = 7;
83         } else if(exp >= 150000 ether){
84             level = 8;
85         } else{
86             level = 0;
87         }
88 
89         return level;
90     }
91 
92     function getVIPBounusRate(address user) public view returns (uint256 rate){
93         uint level = getVIPLevel(user);
94 
95         if(level == 1){
96             rate = 1;
97         } else if(level == 2){
98             rate = 2;
99         } else if(level == 3){
100             rate = 3;
101         } else if(level == 4){
102             rate = 4;
103         } else if(level == 5){
104             rate = 5;
105         } else if(level == 6){
106             rate = 7;
107         } else if(level == 7){
108             rate = 9;
109         } else if(level == 8){
110             rate = 11;
111         } else if(level == 9){
112             rate = 13;
113         } else if(level == 10){
114             rate = 15;
115         } else{
116             rate = 0;
117         }
118     }
119 
120     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
121     function increaseJackpot(uint increaseAmount) external onlyCaller {
122         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
123         require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");
124         jackpotSize += uint128(increaseAmount);
125     }
126 
127     function payJackpotReward(address payable to) external onlyCaller{
128         to.transfer(jackpotSize);
129         jackpotSize = 0;
130     }
131 
132     function getJackpotSize() external view returns (uint256){
133         return jackpotSize;
134     }
135 
136     function increaseRankingReward(uint amount) public onlyCaller{
137         require (amount <= address(this).balance, "Increase amount larger than balance.");
138         require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");
139         rankingRewardSize += uint128(amount);
140     }
141 
142     function payRankingReward(address payable to) external onlyCaller {
143         uint128 prize = rankingRewardSize / 2;
144         rankingRewardSize = rankingRewardSize - prize;
145         if(to.send(prize)){
146             emit RankingRewardPayment(to, prize);
147         }
148     }
149 
150     function getRankingRewardSize() external view returns (uint128){
151         return rankingRewardSize;
152     }
153 }