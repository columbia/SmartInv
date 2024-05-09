1 pragma solidity ^0.4.18;
2 
3 contract RegalX{
4     
5     mapping (address => uint256) public investedETH;
6     mapping (address => uint256) public lastInvest;
7     
8     mapping (address => uint256) public affiliateCommision;
9     
10     address promoter = 0xE22Dcbd53690764462522Bb09Af5fbE2F1ee4f2B;
11     address promoter1 = 0x8d07A25b37AA62898cb7B796cA710A8D2FAD98b4;
12     
13     function investETH(address referral) public payable {
14         
15         require(msg.value >= 0.1 ether);
16         
17         if(getProfit(msg.sender) > 0){
18             uint256 profit = getProfit(msg.sender);
19             lastInvest[msg.sender] = now;
20             msg.sender.transfer(profit);
21         }
22         
23         uint256 amount = msg.value;
24         uint256 commision = SafeMath.div(amount, 20);
25         if(referral != msg.sender && referral != 0x1 && referral != promoter && referral != promoter1){
26             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
27         }
28         
29         affiliateCommision[promoter] = SafeMath.add(affiliateCommision[promoter], commision);
30         affiliateCommision[promoter1] = SafeMath.add(affiliateCommision[promoter1], commision);
31         
32         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], amount);
33         lastInvest[msg.sender] = now;
34     }
35     
36     function divestETH() public {
37         uint256 profit = getProfit(msg.sender);
38         lastInvest[msg.sender] = now;
39         
40         //20% fee on taking capital out
41         uint256 capital = investedETH[msg.sender];
42         uint256 fee = SafeMath.div(capital, 5);
43         capital = SafeMath.sub(capital, fee);
44         
45         uint256 total = SafeMath.add(capital, profit);
46         require(total > 0);
47         investedETH[msg.sender] = 0;
48         msg.sender.transfer(total);
49     }
50     
51     function withdraw() public{
52         uint256 profit = getProfit(msg.sender);
53         require(profit > 0);
54         lastInvest[msg.sender] = now;
55         msg.sender.transfer(profit);
56     }
57     
58     function getProfitFromSender() public view returns(uint256){
59         return getProfit(msg.sender);
60     }
61 
62     function getProfit(address customer) public view returns(uint256){
63         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
64         uint256 profit = SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 8640000);
65         uint256 bonus = getBonus();
66         if(bonus == 0){
67             return profit;
68         }
69         return SafeMath.add(profit, SafeMath.div(SafeMath.mul(profit, bonus), 100));
70     }
71     
72     function getBonus() public view returns(uint256){
73         uint256 invested = getInvested();
74         if(invested >= 0.1 ether && 4 ether >= invested){
75             return 0;
76         }else if(invested >= 4.01 ether && 7 ether >= invested){
77             return 5;
78         }else if(invested >= 7.01 ether && 10 ether >= invested){
79             return 10;
80         }else if(invested >= 10.01 ether && 15 ether >= invested){
81             return 15;
82         }else if(invested >= 15.01 ether){
83             return 25;
84         }
85     }
86     
87     function reinvestProfit() public {
88         uint256 profit = getProfit(msg.sender);
89         require(profit > 0);
90         lastInvest[msg.sender] = now;
91         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
92     }
93     
94     function getAffiliateCommision() public view returns(uint256){
95         return affiliateCommision[msg.sender];
96     }
97     
98     function withdrawAffiliateCommision() public {
99         require(affiliateCommision[msg.sender] > 0);
100         uint256 commision = affiliateCommision[msg.sender];
101         affiliateCommision[msg.sender] = 0;
102         msg.sender.transfer(commision);
103     }
104     
105     function getInvested() public view returns(uint256){
106         return investedETH[msg.sender];
107     }
108     
109     function getBalance() public view returns(uint256){
110         return this.balance;
111     }
112 
113     function min(uint256 a, uint256 b) private pure returns (uint256) {
114         return a < b ? a : b;
115     }
116     
117     function max(uint256 a, uint256 b) private pure returns (uint256) {
118         return a > b ? a : b;
119     }
120 }
121 
122 library SafeMath {
123 
124   /**
125   * @dev Multiplies two numbers, throws on overflow.
126   */
127   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128     if (a == 0) {
129       return 0;
130     }
131     uint256 c = a * b;
132     assert(c / a == b);
133     return c;
134   }
135 
136   /**
137   * @dev Integer division of two numbers, truncating the quotient.
138   */
139   function div(uint256 a, uint256 b) internal pure returns (uint256) {
140     // assert(b > 0); // Solidity automatically throws when dividing by 0
141     uint256 c = a / b;
142     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
143     return c;
144   }
145 
146   /**
147   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
148   */
149   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150     assert(b <= a);
151     return a - b;
152   }
153 
154   /**
155   * @dev Adds two numbers, throws on overflow.
156   */
157   function add(uint256 a, uint256 b) internal pure returns (uint256) {
158     uint256 c = a + b;
159     assert(c >= a);
160     return c;
161   }
162 }