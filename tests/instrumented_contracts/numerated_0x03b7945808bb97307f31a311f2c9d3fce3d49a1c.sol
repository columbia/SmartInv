1 pragma solidity ^0.4.25;
2 
3 /**
4 
5 A simple contract. A simple game. 
6 A simple way to earn. 
7 
8 Be one.eight
9 
10  */
11 
12 contract one_eight {
13     using SafeMath for uint256;
14     
15     mapping (address => uint256) public investedETH;
16     mapping (address => uint256) public lastInvest;
17     mapping (address => uint256) public affiliateCommision;
18     
19      /** the creator */
20     address creator = 0xEDa159d4AD09bEdeB9fDE7124E0F5304c30F7790;
21      /** development and maintenance */
22     address damn = 0x6a5D9648381b90AF0e6881c26739efA4379c19B2;
23      /** the peoples charity */
24     address charity = 0xF57924672D6dBF0336c618fDa50E284E02715000;
25 
26     
27     function investETH(address referral) public payable {
28         
29         require(msg.value >= .05 ether);
30         
31         if(getProfit(msg.sender) > 0){
32             uint256 profit = getProfit(msg.sender);
33             lastInvest[msg.sender] = now;
34             msg.sender.transfer(profit);
35         }
36         
37         uint256 amount = msg.value;
38         uint256 commision = SafeMath.div(amount, 40); /** partner share 2.5% */ 
39         if(referral != msg.sender && referral != 0x1){
40             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
41         }
42         
43         creator.transfer(msg.value.div(100).mul(5)); /** creator */
44         damn.transfer(msg.value.div(100).mul(3)); /** development and maintenance */
45         charity.transfer(msg.value.div(100).mul(1)); /** give away  */
46         
47         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], amount);
48         lastInvest[msg.sender] = now;
49     }
50     
51     
52     function withdraw() public{
53         uint256 profit = getProfit(msg.sender);
54         require(profit > 0);
55         lastInvest[msg.sender] = now;
56         msg.sender.transfer(profit);
57     }
58     
59     function getProfitFromSender() public view returns(uint256){
60         return getProfit(msg.sender);
61     }
62 
63     function getProfit(address customer) public view returns(uint256){
64         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
65         return SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 4800000); /** one eight */
66     }
67     
68     function reinvestProfit() public {
69         uint256 profit = getProfit(msg.sender);
70         require(profit > 0);
71         lastInvest[msg.sender] = now;
72         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
73     }
74     
75     function getAffiliateCommision() public view returns(uint256){
76         return affiliateCommision[msg.sender];
77     }
78     
79     function withdrawAffiliateCommision() public {
80         require(affiliateCommision[msg.sender] > 0);
81         uint256 commision = affiliateCommision[msg.sender];
82         affiliateCommision[msg.sender] = 0;
83         msg.sender.transfer(commision);
84     }
85     
86     function getInvested() public view returns(uint256){
87         return investedETH[msg.sender];
88     }
89     
90     function getBalance() public view returns(uint256){
91         return address(this).balance;
92     }
93     
94     function min(uint256 a, uint256 b) private pure returns (uint256) {
95         return a < b ? a : b;
96     }
97     
98     function max(uint256 a, uint256 b) private pure returns (uint256) {
99         return a > b ? a : b;
100     }
101 }
102 
103 library SafeMath {
104 
105   /**
106   * @dev Multiplies two numbers, throws on overflow.
107   */
108   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
109     if (a == 0) {
110       return 0;
111     }
112     uint256 c = a * b;
113     assert(c / a == b);
114     return c;
115   }
116 
117   /**
118   * @dev Integer division of two numbers, truncating the quotient.
119   */
120   function div(uint256 a, uint256 b) internal pure returns (uint256) {
121     // assert(b > 0); // Solidity automatically throws when dividing by 0
122     uint256 c = a / b;
123     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124     return c;
125   }
126 
127   /**
128   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
129   */
130   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
131     assert(b <= a);
132     return a - b;
133   }
134 
135   /**
136   * @dev Adds two numbers, throws on overflow.
137   */
138   function add(uint256 a, uint256 b) internal pure returns (uint256) {
139     uint256 c = a + b;
140     assert(c >= a);
141     return c;
142   }
143 }