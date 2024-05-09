1 pragma solidity ^0.4.18;
2 
3 
4 
5 contract TestMining{
6     
7     mapping (address => uint256) public investedETH;
8     mapping (address => uint256) public lastInvest;
9     
10     mapping (address => uint256) public affiliateCommision;
11     
12     address dev = 0x47CCf63dB09E3BF617a5578A5eBBd19a4f321F67;
13     address promoter = 0xac25639bb9B90E9ddd89620f3923E2B8fDF3759d;
14     
15     function investETH(address referral) public payable {
16         
17         require(msg.value >= 0.01 ether);
18         
19         if(getProfit(msg.sender) > 0){
20             uint256 profit = getProfit(msg.sender);
21             lastInvest[msg.sender] = now;
22             msg.sender.transfer(profit);
23         }
24         
25         uint256 amount = msg.value;
26         uint256 commision = SafeMath.div(amount, 10); 
27         if(referral != msg.sender && referral != 0x1 && referral != dev && referral != promoter){
28             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
29         }
30         
31         affiliateCommision[dev] = SafeMath.div(amount, 40);
32         affiliateCommision[promoter] = SafeMath.div(amount, 40);
33 
34         /*
35         affiliateCommision[dev] = SafeMath.add(affiliateCommision[dev], commision);
36         affiliateCommision[promoter] = SafeMath.add(affiliateCommision[promoter], commision);
37         */
38 
39         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], amount);
40         lastInvest[msg.sender] = now;
41     }
42     
43     function divestETH() public {
44         uint256 profit = getProfit(msg.sender);
45         lastInvest[msg.sender] = now;
46         
47         //20% fee on taking capital out
48         uint256 capital = investedETH[msg.sender];
49         uint256 fee = SafeMath.div(capital, 2); //50% fee to leave early
50         capital = SafeMath.sub(capital, fee);
51         
52         uint256 total = SafeMath.add(capital, profit);
53         require(total > 0);
54         investedETH[msg.sender] = 0;
55         msg.sender.transfer(total);
56     }
57     
58     function withdraw() public{
59         uint256 profit = getProfit(msg.sender);
60         require(profit > 0);
61         lastInvest[msg.sender] = now;
62         msg.sender.transfer(profit);
63     }
64     
65     function getProfitFromSender() public view returns(uint256){
66         return getProfit(msg.sender);
67     }
68 
69     function getProfit(address customer) public view returns(uint256){
70         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
71         return SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 2592000); 
72         //30 days in seconds is 2592000
73     }
74     
75     function reinvestProfit() public {
76         uint256 profit = getProfit(msg.sender);
77         require(profit > 0);
78         lastInvest[msg.sender] = now;
79         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
80     }
81     
82     function getAffiliateCommision() public view returns(uint256){
83         return affiliateCommision[msg.sender];
84     }
85     
86     function withdrawAffiliateCommision() public {
87         require(affiliateCommision[msg.sender] > 0);
88         uint256 commision = affiliateCommision[msg.sender];
89         affiliateCommision[msg.sender] = 0;
90         msg.sender.transfer(commision);
91     }
92     
93     function getInvested() public view returns(uint256){
94         return investedETH[msg.sender];
95     }
96     
97     function getBalance() public view returns(uint256){
98         return this.balance;
99     }
100 
101     function min(uint256 a, uint256 b) private pure returns (uint256) {
102         return a < b ? a : b;
103     }
104     
105     function max(uint256 a, uint256 b) private pure returns (uint256) {
106         return a > b ? a : b;
107     }
108 }
109 
110 library SafeMath {
111 
112   /**
113   * @dev Multiplies two numbers, throws on overflow.
114   */
115   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116     if (a == 0) {
117       return 0;
118     }
119     uint256 c = a * b;
120     assert(c / a == b);
121     return c;
122   }
123 
124   /**
125   * @dev Integer division of two numbers, truncating the quotient.
126   */
127   function div(uint256 a, uint256 b) internal pure returns (uint256) {
128     // assert(b > 0); // Solidity automatically throws when dividing by 0
129     uint256 c = a / b;
130     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
131     return c;
132   }
133 
134   /**
135   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
136   */
137   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138     assert(b <= a);
139     return a - b;
140   }
141 
142   /**
143   * @dev Adds two numbers, throws on overflow.
144   */
145   function add(uint256 a, uint256 b) internal pure returns (uint256) {
146     uint256 c = a + b;
147     assert(c >= a);
148     return c;
149   }
150 }