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
69         if(exp >= 25 ether && exp < 125 ether){
70             level = 1;
71         } else if(exp >= 125 ether && exp < 250 ether){
72             level = 2;
73         } else if(exp >= 250 ether && exp < 1250 ether){
74             level = 3;
75         } else if(exp >= 1250 ether && exp < 2500 ether){
76             level = 4;
77         } else if(exp >= 2500 ether && exp < 12500 ether){
78             level = 5;
79         } else if(exp >= 12500 ether && exp < 25000 ether){
80             level = 6;
81         } else if(exp >= 25000 ether && exp < 125000 ether){
82             level = 7;
83         } else if(exp >= 125000 ether && exp < 250000 ether){
84             level = 8;
85         } else if(exp >= 250000 ether && exp < 1250000 ether){
86             level = 9;
87         } else if(exp >= 1250000 ether){
88             level = 10;
89         } else{
90             level = 0;
91         }
92 
93         return level;
94     }
95 
96     function getVIPBounusRate(address user) public view returns (uint256 rate){
97         uint level = getVIPLevel(user);
98         return level;
99     }
100 
101     // This function is used to bump up the jackpot fund. Cannot be used to lower it.
102     function increaseJackpot(uint increaseAmount) external onlyCaller {
103         require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
104         require (jackpotSize + increaseAmount <= address(this).balance, "Not enough funds.");
105         jackpotSize += uint128(increaseAmount);
106     }
107 
108     function payJackpotReward(address payable to) external onlyCaller{
109         to.transfer(jackpotSize);
110         jackpotSize = 0;
111     }
112 
113     function getJackpotSize() external view returns (uint256){
114         return jackpotSize;
115     }
116 
117     function increaseRankingReward(uint amount) public onlyCaller{
118         require (amount <= address(this).balance, "Increase amount larger than balance.");
119         require (rankingRewardSize + amount <= address(this).balance, "Not enough funds.");
120         rankingRewardSize += uint128(amount);
121     }
122 
123     function payRankingReward(address payable to) external onlyCaller {
124         uint128 prize = rankingRewardSize / 2;
125         rankingRewardSize = rankingRewardSize - prize;
126         if(to.send(prize)){
127             emit RankingRewardPayment(to, prize);
128         }
129     }
130 
131     function getRankingRewardSize() external view returns (uint128){
132         return rankingRewardSize;
133     }
134 }