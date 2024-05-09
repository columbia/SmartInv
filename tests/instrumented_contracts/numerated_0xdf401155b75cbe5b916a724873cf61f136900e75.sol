1 pragma solidity ^0.4.18;
2 
3 /*
4 
5 __/\\\\\\\\\\\\_____/\\\\\\\\\\\__/\\\________/\\\_____/\\\\\\\\\\\_________________________________                 
6  _\/\\\////////\\\__\/////\\\///__\/\\\_______\/\\\___/\\\/////////\\\_______________________________                
7   _\/\\\______\//\\\_____\/\\\_____\//\\\______/\\\___\//\\\______\///________________________________               
8    _\/\\\_______\/\\\_____\/\\\______\//\\\____/\\\_____\////\\\_______________________________________              
9     _\/\\\_______\/\\\_____\/\\\_______\//\\\__/\\\_________\////\\\____________________________________             
10      _\/\\\_______\/\\\_____\/\\\________\//\\\/\\\_____________\////\\\_________________________________            
11       _\/\\\_______/\\\______\/\\\_________\//\\\\\_______/\\\______\//\\\________________________________           
12        _\/\\\\\\\\\\\\/____/\\\\\\\\\\\______\//\\\_______\///\\\\\\\\\\\/_________________________________          
13         _\////////////_____\///////////________\///__________\///////////___________________________________         
14          __________________________________________________________________________/\\\_____/\\\\\\\\\\\\____        
15           ________________________________________________________________________/\\\\\____\/\\\////////\\\__       
16            ______________________________________________________________________/\\\/\\\____\/\\\______\//\\\_      
17             ____________________________________________________________________/\\\/\/\\\____\/\\\_______\/\\\_     
18              __________________________________________________________________/\\\/__\/\\\____\/\\\_______\/\\\_    
19               ________________________________________________________________/\\\\\\\\\\\\\\\\_\/\\\_______\/\\\_   
20                _______________________________________________________________\///////////\\\//__\/\\\_______/\\\__  
21                 _________________________________________________________________________\/\\\____\/\\\\\\\\\\\\/___ 
22                  _________________________________________________________________________\///_____\////////////_____
23 
24                                    
25                               ____  ██╗    ██████╗  █████╗ ██╗   ██╗    ██████╗  ██████╗ ██╗ _____
26                            _______ ███║    ██╔══██╗██╔══██╗╚██╗ ██╔╝    ██╔══██╗██╔═══██╗██║ ________
27 ╚                         ________  ██║    ██║  ██║███████║ ╚████╔╝     ██████╔╝██║   ██║██║ _________
28                            _______  ██║    ██║  ██║██╔══██║  ╚██╔╝      ██╔══██╗██║   ██║██║ ________
29                              _____  ██║    ██████╔╝██║  ██║   ██║       ██║  ██║╚██████╔╝██║ ______
30                                ___  ╚═╝    ╚═════╝ ╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝ ╚═════╝ ╚═╝ ____
31                                 _______________________________________________________________
32                                                   _____________________________
33                                                  |      www.Divs4D.com/1Day    |
34                                                  | 100% return every 24 hours  |
35                                                  |        ROI in 1 day         |
36                                                  |    5% Referral commision    |
37                                                  |_____________________________|                            
38 */
39 contract Divs4D{
40        
41                                              /*=====================================      
42                                               |-|-|-|-|-|-|--MAPPINGS--|-|-|-|-|-|-|                   
43                                               =====================================*/      
44 
45     mapping (address => uint256) public investedETH;
46     mapping (address => uint256) public lastInvest;
47     mapping (address => uint256) public affiliateCommision;
48     
49     address dev = 0xF5c47144e20B78410f40429d78E7A18a2A429D0e;
50     address promoter = 0xC7a4Bf373476e265fC1b428CC4110E83aE32e8A3;
51     
52     
53     bool public started;
54 
55 
56                                              /*____________________________________
57                                               |   ONLY DEV CAN START THE MADNESS   |
58                                               |____________________________________*/
59     
60     
61     modifier onlyDev() {
62         require(msg.sender == dev);
63         _;
64     }
65 
66 
67                                              /*=====================================
68                                               ||||||||||||||FUNCTIONS|||||||||||||||             
69                                               =====================================*/
70 
71     function start() public onlyDev {
72         started = true;
73     }
74                                              /*____________________________________
75                                               |   Minimum of 0.01 ETHER deposit    |
76                                               |  And game must be started by dev   |      
77                                               |____________________________________*/
78     
79     
80     function investETH(address referral) public payable {
81 
82         require(msg.value >= 0.01 ether);
83         require(started);
84                               
85         if(getProfit(msg.sender) > 0){
86             uint256 profit = getProfit(msg.sender);
87             lastInvest[msg.sender] = now;
88             msg.sender.transfer(profit);
89         }
90         
91         uint256 amount = msg.value;
92         uint256 commision = SafeMath.div(amount, 20);
93         if(referral != msg.sender && referral != 0x1 && referral != dev && referral != promoter){
94             affiliateCommision[referral] = SafeMath.add(affiliateCommision[referral], commision);
95         }
96         
97         affiliateCommision[dev] = SafeMath.add(affiliateCommision[dev], commision);
98         affiliateCommision[promoter] = SafeMath.add(affiliateCommision[promoter], commision);
99         
100         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], amount);
101         lastInvest[msg.sender] = now;
102     }
103                                              /*____________________________________
104                                               |    Players can withdraw profit     |
105                                               |  anytime as long as there is ETH   |      
106                                               |____________________________________*/
107     
108     function withdraw() public{
109         uint256 profit = getProfit(msg.sender);
110         require(profit > 0);
111         lastInvest[msg.sender] = now;
112         msg.sender.transfer(profit);
113     }
114     
115     function getProfitFromSender() public view returns(uint256){
116         return getProfit(msg.sender);
117     }
118 
119     function getProfit(address customer) public view returns(uint256){
120         uint256 secondsPassed = SafeMath.sub(now, lastInvest[customer]);
121         return SafeMath.div(SafeMath.mul(secondsPassed, investedETH[customer]), 86400);
122     }
123     
124     function reinvestProfit() public {
125         uint256 profit = getProfit(msg.sender);
126         require(profit > 0);
127         lastInvest[msg.sender] = now;
128         investedETH[msg.sender] = SafeMath.add(investedETH[msg.sender], profit);
129     }
130     
131     function getAffiliateCommision() public view returns(uint256){
132         return affiliateCommision[msg.sender];
133     }
134     
135     function withdrawAffiliateCommision() public {
136         require(affiliateCommision[msg.sender] > 0);
137         uint256 commision = affiliateCommision[msg.sender];
138         affiliateCommision[msg.sender] = 0;
139         msg.sender.transfer(commision);
140     }
141     
142     function getInvested() public view returns(uint256){
143         return investedETH[msg.sender];
144     }
145     
146     function getBalance() public view returns(uint256){
147         return this.balance;
148     }
149 
150     function min(uint256 a, uint256 b) private pure returns (uint256) {
151         return a < b ? a : b;
152     }
153     
154     function max(uint256 a, uint256 b) private pure returns (uint256) {
155         return a > b ? a : b;
156     }
157 }
158 
159 
160 
161                                              /*======================================
162                                               ||||||GOTTA HAVE THAT SAFE MATH||||||||             
163                                               ======================================*/
164 
165 library SafeMath {
166 
167   /**
168   * @dev Multiplies two numbers, throws on overflow.
169   */
170   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171     if (a == 0) {
172       return 0;
173     }
174     uint256 c = a * b;
175     assert(c / a == b);
176     return c;
177   }
178 
179   /**
180   * @dev Integer division of two numbers, truncating the quotient.
181   */
182   function div(uint256 a, uint256 b) internal pure returns (uint256) {
183     // assert(b > 0); // Solidity automatically throws when dividing by 0
184     uint256 c = a / b;
185     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
186     return c;
187   }
188 
189   /**
190   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
191   */
192   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
193     assert(b <= a);
194     return a - b;
195   }
196 
197   /**
198   * @dev Adds two numbers, throws on overflow.
199   */
200   function add(uint256 a, uint256 b) internal pure returns (uint256) {
201     uint256 c = a + b;
202     assert(c >= a);
203     return c;
204   }
205 }