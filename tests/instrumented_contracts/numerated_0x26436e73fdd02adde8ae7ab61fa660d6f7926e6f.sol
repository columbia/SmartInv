1 pragma solidity ^0.4.18;
2 
3 pragma solidity ^0.4.11;
4 
5  
6 contract Token {
7 	function SetupToken(string tokenName, string tokenSymbol, uint256 tokenSupply) public;
8     function balanceOf(address _owner) public constant returns (uint256 balance);
9     function transfer(address _to, uint256 _amount) public returns (bool success);
10     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
11     function approve(address _spender, uint256 _amount) public returns (bool success);
12     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
13 }
14 pragma solidity ^0.4.18;
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
61 }
62 
63 
64 /**
65  * @title Crowdsale *Modded*
66  * @dev Crowdsale is a base contract for managing a token crowdsale.
67  * Author: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/crowdsale
68  * Crowdsales have a start and end timestamps, where investors can make
69  * token purchases and the crowdsale will assign them tokens based
70  * on a token per ETH rate. Funds collected are forwarded to a wallet
71  * as they arrive. 
72  * Modded to use preminted token contract, and graft in capped crowdsale code from the openZepplin github
73  */
74  
75  
76 contract Crowdsale {
77   using SafeMath for uint256;
78 
79   Token token;
80   address public owner;
81   
82   // public cap in wei : when initialized, its per ether
83   uint256 public cap;
84   
85   // start and end timestamps where investments are allowed (both inclusive)
86   uint256 public startTime;
87   uint256 public endTime;
88 
89   // address where funds are collected
90   address public wallet;
91 
92   // how many token units a buyer gets per wei : when initialized, its per ether
93   uint256 public rate;
94 
95   // amount of raised money in wei
96   uint256 public weiRaised;
97   
98   
99   // amount of raised money in current tier in wei
100   uint256 public tierTotal;
101   
102   //tier count
103   uint256 public tierNum = 0;
104   
105   /*  Funding Tiers
106   *   Tier  Rave/ETH Rave Limit Eth Limit
107   *   One	6000	2.000.000	333,3333
108   *   Two	5500	5.000.000	909,0909
109   *   Three	5000	9.000.000	1800,0000
110   *   Four	4500	14.000.000	3111,1111
111   *   Five	4000	20.000.000	5000,0000
112   */
113   
114    uint256[5] fundingRate = [6000, 5500, 5000, 4500, 4000]; //Rave per Eth
115    uint256[5] fundingLimit = [2000000, 5000000, 9000000, 14000000, 20000000]; //Max Rave Available per tier
116 
117   /**
118    * event for token purchase logging
119    * @param purchaser who paid for the tokens
120    * @param beneficiary who got the tokens
121    * @param value weis paid for purchase
122    * @param amount amount of tokens purchased
123    */
124   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
125   event FailedTransfer(address indexed to, uint256 value);
126   event initialCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _cap, uint256 cap, uint256 _rate, uint256 rate, address _wallet);
127 
128   function Crowdsale(uint256 _startTime, uint256 _endTime, uint256 _cap, address _wallet) public {
129     require(_startTime >= now);
130     require(_endTime >= _startTime);
131     require(_cap > 0);
132     require(_wallet != address(0));
133     
134     owner = msg.sender;
135     address _tokenAddr = 0x6A09e1b7cC5cb52FfdfC585a8dF51CED7063915C; //Token Contract Address
136     token = Token(_tokenAddr);
137       
138     startTime = _startTime;
139     endTime = _endTime;
140     rate =  fundingRate[tierNum];  
141     cap = _cap.mul(1 ether);  
142     wallet = _wallet;
143     
144     initialCrowdsale(_startTime, _endTime, _cap, cap, fundingRate[tierNum], rate, _wallet);
145 
146   }
147 
148   // fallback function can be used to buy tokens
149   function () external payable {
150     buyTokens(msg.sender);
151   }
152 
153   // low level token purchase function
154   function buyTokens(address beneficiary) public payable {
155     require(beneficiary != address(0));
156     require(validPurchase());
157 
158     uint256 weiAmount = msg.value;
159 
160     // calculate token amount to be sent in wei
161     uint256 tokens = getTokenAmount(weiAmount);
162 
163     // update state
164     weiRaised = weiRaised.add(weiAmount);
165     tierTotal = tierTotal.add(weiAmount);
166 
167     // Check balance of contract
168     token.transfer(beneficiary, tokens);
169     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
170     
171     forwardFunds();
172     
173     //upgrade rate tier check
174     rateUpgrade(tierTotal);
175   }
176 
177   // @return true if crowdsale event has ended & limit has not been reached
178   function hasEnded() public view returns (bool) {
179     bool capReached = weiRaised >= cap;
180     bool timeLimit = now > endTime;
181     return capReached || timeLimit;
182   }
183 
184 
185   // If weiAmountRaised is over tier thresholds, then upgrade rave per eth
186   function rateUpgrade(uint256 tierAmount) internal {
187     uint256 tierEthLimit  = fundingLimit[tierNum].div(fundingRate[tierNum]);
188     uint256 tierWeiLimit  = tierEthLimit.mul(1 ether);
189     if(tierAmount >= tierWeiLimit) {
190         tierNum = tierNum.add(1); //increment tier number
191         rate = fundingRate[tierNum]; // set new rate in wei
192         tierTotal = 0; //reset to 0 wei
193     }
194  }
195   // Override this method to have a way to add business logic to your crowdsale when buying
196   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
197         return weiAmount.mul(rate);
198   }
199 
200   // send ether to the fund collection wallet
201   // override to create custom fund forwarding mechanisms
202   function forwardFunds() internal {
203     wallet.transfer(msg.value);
204   }
205   
206   // @return true if the transaction can buy tokens & within cap & nonzero
207   function validPurchase() internal view returns (bool) {
208     bool withinCap = weiRaised.add(msg.value) <= cap;
209     bool withinPeriod = now >= startTime && now <= endTime;
210     bool nonZeroPurchase = msg.value != 0;
211     return withinPeriod && withinCap && nonZeroPurchase;
212   }
213   
214   function tokensAvailable() public onlyOwner constant returns (uint256) {
215     return token.balanceOf(this);
216   }
217   
218   
219   function getRate() public onlyOwner constant returns(uint256) {
220     return rate;
221   }
222 
223   function getWallet() public onlyOwner constant returns(address) {
224     return wallet;
225   }
226   
227   function destroy() public onlyOwner payable {
228     uint256 balance = tokensAvailable();
229     if(balance > 0) {
230     token.transfer(owner, balance);
231     }
232     selfdestruct(owner);
233   }
234   
235   modifier onlyOwner() {
236     require(msg.sender == owner);
237     _;
238   }
239 
240 }