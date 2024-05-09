1 pragma solidity ^0.4.18;
2 
3 /*
4                   _____                                             
5 |         | |  .-~     ~.  |         |                              
6 |_________| | :            |_________|                              
7 |         | | :     _____  |         |                              
8 |         | |  `-._____.'| |         |                              
9                                                                     
10                ______                       ____                    
11 |`````````,  .~      ~.  |        |        |            |`````````, 
12 |'''|'''''  |          | |        |        |______      |'''|'''''  
13 |    `.     |          | |        |        |            |    `.     
14 |      `.    `.______.'  |_______ |_______ |___________ |      `.   
15                                                                     
16                                _____                                
17 |    ..'' | |..          |  .-~     ~.              ..''''          
18 |..''     | |  ``..      | :                     .''                
19 |``..     | |      ``..  | :     _____        ..'                   
20 |    ``.. | |          ``|  `-._____.'| ....''                      
21                                                                     
22                                                                     
23 |``````.  | `.           .'             ..''''                      
24 |       | |   `.       .'            .''                            
25 |       | |     `.   .'           ..'                               
26 |......'  |       `.'       ....''                                  
27                                                                     
28 */
29 
30 contract HRKD{
31     
32     mapping (address => uint256) public investedETH;
33     mapping (address => uint256) public lastInvest;
34     
35     mapping (address => uint256) public affiliateCommision;
36     
37     address dev = 0xaf9c025ce6322a23ac00301c714f4f42895c9818;
38     address promoter = 0x6842a9ad0BC604c1D9330190B9035051a7525569;
39     
40     function investETH(address referral) public payable {
41         
42         require(msg.value >= 0.5 ether);
43         
44         if(getProfit(msg.sender) > 0){
45             uint256 profit = getProfit(msg.sender);
46             lastInvest[msg.sender] = now;
47             msg.sender.transfer(profit);
48         }
49         
50         uint256 amount = msg.value;
51         uint256 commision = SafeMath.div(amount, 20);
52         if(referral != msg.sender && referral != 0x1 && referral != dev && referral != promoter){
53             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
54         }
55         
56         affiliateCommision[dev] = SafeMath.add(affiliateCommision[dev], commision);
57         affiliateCommision[promoter] = SafeMath.add(affiliateCommision[promoter], commision);
58         
59         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], amount);
60         lastInvest[msg.sender] = now;
61     }
62     
63     
64     function withdraw() public{
65         uint256 profit = getProfit(msg.sender);
66         require(profit > 0);
67         lastInvest[msg.sender] = now;
68         msg.sender.transfer(profit);
69     }
70     
71     function getProfitFromSender() public view returns(uint256){
72         return getProfit(msg.sender);
73     }
74 
75     function getProfit(address customer) public view returns(uint256){
76         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
77         return SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 345600);
78     }
79     
80     function reinvestProfit() public {
81         uint256 profit = getProfit(msg.sender);
82         require(profit > 0);
83         lastInvest[msg.sender] = now;
84         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
85     }
86     
87     function getAffiliateCommision() public view returns(uint256){
88         return affiliateCommision[msg.sender];
89     }
90     
91     function withdrawAffiliateCommision() public {
92         require(affiliateCommision[msg.sender] > 0);
93         uint256 commision = affiliateCommision[msg.sender];
94         affiliateCommision[msg.sender] = 0;
95         msg.sender.transfer(commision);
96     }
97     
98     function getInvested() public view returns(uint256){
99         return investedETH[msg.sender];
100     }
101     
102     function getBalance() public view returns(uint256){
103         return this.balance;
104     }
105 
106     function min(uint256 a, uint256 b) private pure returns (uint256) {
107         return a < b ? a : b;
108     }
109     
110     function max(uint256 a, uint256 b) private pure returns (uint256) {
111         return a > b ? a : b;
112     }
113 }
114 
115 library SafeMath {
116 
117   /**
118   * @dev Multiplies two numbers, throws on overflow.
119   */
120   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
121     if (a == 0) {
122       return 0;
123     }
124     uint256 c = a * b;
125     assert(c / a == b);
126     return c;
127   }
128 
129   /**
130   * @dev Integer division of two numbers, truncating the quotient.
131   */
132   function div(uint256 a, uint256 b) internal pure returns (uint256) {
133     // assert(b > 0); // Solidity automatically throws when dividing by 0
134     uint256 c = a / b;
135     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
136     return c;
137   }
138 
139   /**
140   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
141   */
142   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143     assert(b <= a);
144     return a - b;
145   }
146 
147   /**
148   * @dev Adds two numbers, throws on overflow.
149   */
150   function add(uint256 a, uint256 b) internal pure returns (uint256) {
151     uint256 c = a + b;
152     assert(c >= a);
153     return c;
154   }
155 }