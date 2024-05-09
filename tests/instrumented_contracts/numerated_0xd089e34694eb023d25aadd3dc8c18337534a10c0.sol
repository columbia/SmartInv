1 pragma solidity ^0.4.18;
2 
3 /*
4 * SmartEtherMining
5 */
6 
7 contract SmartEtherMining{
8     
9     mapping (address => uint256) public investedETH;
10     mapping (address => uint256) public lastInvest;
11     
12     mapping (address => uint256) public affiliateCommision;
13     
14     address dev = 0xbbe810596f6b9dc9713e9393b79599a6a54ec2d5;
15     address promoter = 0xE6f43c670CC8a366bBcf6677F43B02754BFB5855;
16     
17     function investETH(address referral) public payable {
18         
19         require(msg.value >= 0.01 ether);
20         
21         if(getProfit(msg.sender) > 0){
22             uint256 profit = getProfit(msg.sender);
23             lastInvest[msg.sender] = now;
24             msg.sender.transfer(profit);
25         }
26         
27         uint256 amount = msg.value;
28         uint256 commision = SafeMath.div(amount, 20);
29         if(referral != msg.sender && referral != 0x1 && referral != dev && referral != promoter){
30             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
31         }
32         
33         affiliateCommision[dev] = SafeMath.add(affiliateCommision[dev], commision);
34         affiliateCommision[promoter] = SafeMath.add(affiliateCommision[promoter], commision);
35         
36         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], amount);
37         lastInvest[msg.sender] = now;
38     }
39     
40     function divestETH() public {
41         uint256 profit = getProfit(msg.sender);
42         lastInvest[msg.sender] = now;
43         
44         //20% fee on taking capital out
45         uint256 capital = investedETH[msg.sender];
46         uint256 fee = SafeMath.div(capital, 5);
47         capital = SafeMath.sub(capital, fee);
48         
49         uint256 total = SafeMath.add(capital, profit);
50         require(total > 0);
51         investedETH[msg.sender] = 0;
52         msg.sender.transfer(total);
53     }
54     
55     function withdraw() public{
56         uint256 profit = getProfit(msg.sender);
57         require(profit > 0);
58         lastInvest[msg.sender] = now;
59         msg.sender.transfer(profit);
60     }
61     
62     function getProfitFromSender() public view returns(uint256){
63         return getProfit(msg.sender);
64     }
65 
66     function getProfit(address customer) public view returns(uint256){
67         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
68         return SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 4320000);
69     }
70     
71     function reinvestProfit() public {
72         uint256 profit = getProfit(msg.sender);
73         require(profit > 0);
74         lastInvest[msg.sender] = now;
75         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
76     }
77     
78     function getAffiliateCommision() public view returns(uint256){
79         return affiliateCommision[msg.sender];
80     }
81     
82     function withdrawAffiliateCommision() public {
83         require(affiliateCommision[msg.sender] > 0);
84         uint256 commision = affiliateCommision[msg.sender];
85         affiliateCommision[msg.sender] = 0;
86         msg.sender.transfer(commision);
87     }
88     
89     function getInvested() public view returns(uint256){
90         return investedETH[msg.sender];
91     }
92     
93     function getBalance() public view returns(uint256){
94         return this.balance;
95     }
96 
97     function min(uint256 a, uint256 b) private pure returns (uint256) {
98         return a < b ? a : b;
99     }
100     
101     function max(uint256 a, uint256 b) private pure returns (uint256) {
102         return a > b ? a : b;
103     }
104 }
105 
106 library SafeMath {
107 
108   /**
109   * @dev Multiplies two numbers, throws on overflow.
110   */
111   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
112     if (a == 0) {
113       return 0;
114     }
115     uint256 c = a * b;
116     assert(c / a == b);
117     return c;
118   }
119 
120   /**
121   * @dev Integer division of two numbers, truncating the quotient.
122   */
123   function div(uint256 a, uint256 b) internal pure returns (uint256) {
124     // assert(b > 0); // Solidity automatically throws when dividing by 0
125     uint256 c = a / b;
126     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127     return c;
128   }
129 
130   /**
131   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
132   */
133   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134     assert(b <= a);
135     return a - b;
136   }
137 
138   /**
139   * @dev Adds two numbers, throws on overflow.
140   */
141   function add(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a + b;
143     assert(c >= a);
144     return c;
145   }
146 }