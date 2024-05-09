1 pragma solidity ^0.4.18;
2 
3  
4 contract Token {
5 	function SetupToken(string tokenName, string tokenSymbol, uint256 tokenSupply) public;
6     function balanceOf(address _owner) public constant returns (uint256 balance);
7     function transfer(address _to, uint256 _amount) public returns (bool success);
8     function transferFrom(address _from, address _to, uint256 _amount) public returns (bool success);
9     function approve(address _spender, uint256 _amount) public returns (bool success);
10     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
11 }
12 
13 
14 /**
15  * @title SafeMath
16  * @dev Math operations with safety checks that throw on error
17  */
18 library SafeMath {
19 
20   /**
21   * @dev Multiplies two numbers, throws on overflow.
22   */
23   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
24     if (a == 0) {
25       return 0;
26     }
27     uint256 c = a * b;
28     assert(c / a == b);
29     return c;
30   }
31 
32   /**
33   * @dev Integer division of two numbers, truncating the quotient.
34   */
35   function div(uint256 a, uint256 b) internal pure returns (uint256) {
36     // assert(b > 0); // Solidity automatically throws when dividing by 0
37     uint256 c = a / b;
38     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39     return c;
40   }
41 
42   /**
43   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
44   */
45   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46     assert(b <= a);
47     return a - b;
48   }
49 
50   /**
51   * @dev Adds two numbers, throws on overflow.
52   */
53   function add(uint256 a, uint256 b) internal pure returns (uint256) {
54     uint256 c = a + b;
55     assert(c >= a);
56     return c;
57   }
58 }
59 
60 
61 /**
62  * @title Crowdsale *Modded*
63  * @dev Crowdsale is a base contract for managing a token crowdsale.
64  * Author: https://github.com/OpenZeppelin/zeppelin-solidity/tree/master/contracts/crowdsale
65  * Crowdsales have a start and end timestamps, where investors can make
66  * token purchases and the crowdsale will assign them tokens based
67  * on a token per ETH rate. Funds collected are forwarded to a wallet
68  * as they arrive. 
69  * Modded to use preminted token contract, and graft in capped crowdsale code from the openZepplin github
70  * Adapted for VRENAR WINK tokens pre-sale
71  */
72  
73  
74 contract WinkIfYouLikeIt {
75   using SafeMath for uint256;
76 
77   Token token;
78   address public owner;
79   
80   // public cap in wei : when initialized, its per ether
81   uint256 public cap;
82   
83   // start and end timestamps where investments are allowed (both inclusive)
84   uint256 public startTime;
85   uint256 public endTime;
86 
87   // address where funds are collected
88   address public wallet;
89 
90   // how many token units a buyer gets per wei : when initialized, its per ether
91   uint256 public rate;
92 
93   // amount of raised money in wei
94   uint256 public weiRaised;
95   
96   
97   // amount of raised money in current tier in wei
98   uint256 public tierTotal;
99   
100   //tier count
101   uint256 public tierNum = 0;
102   
103   //Funding Tiers  
104   uint256[5] fundingRate = [24000, 24000, 24000, 24000, 24000]; //WINK per Eth
105   uint256[5] fundingLimit = [180000000, 180000000, 180000000, 180000000, 180000000]; //Max WINKs Available per tier
106 
107   /**
108    * event for token purchase logging
109    * @param purchaser who paid for the tokens
110    * @param beneficiary who got the tokens
111    * @param value weis paid for purchase
112    * @param amount amount of tokens purchased
113    */
114   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
115   event FailedTransfer(address indexed to, uint256 value);
116   event initialCrowdsale(uint256 _startTime, uint256 _endTime, uint256 _cap, uint256 cap, uint256 _rate, uint256 rate, address _wallet);
117 
118   function WinkIfYouLikeIt(uint256 _startTime, uint256 _endTime, uint256 _cap, address _wallet) public {
119     require(_startTime >= now);
120     require(_endTime >= _startTime);
121     require(_cap > 0);
122     require(_wallet != address(0));
123     
124     owner = msg.sender;
125     address _tokenAddr = 0x29fA00dCF17689c8654d07780F9E222311D6Bf0c; //Token Contract Address
126     token = Token(_tokenAddr);
127       
128     startTime = _startTime;
129     endTime = _endTime;
130     rate =  fundingRate[tierNum];  
131     cap = _cap.mul(1 ether);  
132     wallet = _wallet;
133     
134     initialCrowdsale(_startTime, _endTime, _cap, cap, fundingRate[tierNum], rate, _wallet);
135 
136   }
137 
138   // fallback function can be used to buy tokens
139   function () external payable {
140     buyTokens(msg.sender);
141   }
142 
143   // low level token purchase function
144   function buyTokens(address beneficiary) public payable {
145     require(beneficiary != address(0));
146     require(validPurchase());
147 
148     uint256 weiAmount = msg.value;
149 
150     // calculate token amount to be sent in wei
151     uint256 tokens = getTokenAmount(weiAmount);
152 
153     // update state
154     weiRaised = weiRaised.add(weiAmount);
155     tierTotal = tierTotal.add(weiAmount);
156 
157     // Check balance of contract
158     token.transfer(beneficiary, tokens);
159     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
160     
161     forwardFunds();
162     
163     //upgrade rate tier check
164     rateUpgrade(tierTotal);
165   }
166 
167   // @return true if crowdsale event has ended & limit has not been reached
168   function hasEnded() public view returns (bool) {
169     bool capReached = weiRaised >= cap;
170     bool timeLimit = now > endTime;
171     return capReached || timeLimit;
172   }
173 
174 
175   // If weiAmountRaised is over tier thresholds, then upgrade WINK per eth
176   function rateUpgrade(uint256 tierAmount) internal {
177     uint256 tierEthLimit  = fundingLimit[tierNum].div(fundingRate[tierNum]);
178     uint256 tierWeiLimit  = tierEthLimit.mul(1 ether);
179     if(tierAmount >= tierWeiLimit) {
180         tierNum = tierNum.add(1); //increment tier number
181         rate = fundingRate[tierNum]; // set new rate in wei
182         tierTotal = 0; //reset to 0 wei
183     }
184  }
185   // Override this method to have a way to add business logic to your crowdsale when buying
186   function getTokenAmount(uint256 weiAmount) internal view returns(uint256) {
187         return weiAmount.mul(rate);
188   }
189 
190   // send ether to the fund collection wallet
191   // override to create custom fund forwarding mechanisms
192   function forwardFunds() internal {
193     wallet.transfer(msg.value);
194   }
195   
196   // @return true if the transaction can buy tokens & within cap & nonzero
197   function validPurchase() internal view returns (bool) {
198     bool withinCap = weiRaised.add(msg.value) <= cap;
199     bool withinPeriod = now >= startTime && now <= endTime;
200     bool nonZeroPurchase = msg.value != 0;
201     return withinPeriod && withinCap && nonZeroPurchase;
202   }
203   
204   function tokensAvailable() public onlyOwner constant returns (uint256) {
205     return token.balanceOf(this);
206   }
207   
208   
209   function getRate() public onlyOwner constant returns(uint256) {
210     return rate;
211   }
212 
213   function getWallet() public onlyOwner constant returns(address) {
214     return wallet;
215   }
216   
217   function destroy() public onlyOwner payable {
218     uint256 balance = tokensAvailable();
219     if(balance > 0) {
220     token.transfer(owner, balance);
221     }
222     selfdestruct(owner);
223   }
224   
225   modifier onlyOwner() {
226     require(msg.sender == owner);
227     _;
228   }
229 
230 }