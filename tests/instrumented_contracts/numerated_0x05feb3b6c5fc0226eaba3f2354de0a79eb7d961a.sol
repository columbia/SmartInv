1 pragma solidity ^0.4.11;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal constant returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal constant returns (uint256) {
27     uint256 c = a + b;
28     assert(c >= a);
29     return c;
30   }
31 }
32 
33 /**
34  * @title Crowdsale
35  * @dev Crowdsale is a base contract for managing a token crowdsale.
36  * Crowdsales have a start and end timestamps, where investors can make
37  * token purchases and the crowdsale will assign them tokens based
38  * on a token per ETH rate. Funds collected are forwarded to a wallet
39  * as they arrive.
40  */
41 contract token { function transfer(address receiver, uint amount){  } }
42 contract Crowdsale {
43   using SafeMath for uint256;
44 
45   // uint256 durationInMinutes;
46   // address where funds are collected
47   address public wallet;
48   // token address
49   address public addressOfTokenUsedAsReward;
50 
51   uint256 public price = 300;
52   uint256 public priceBeforeGoalReached;
53   uint256 public tokensSoldGoal;
54   uint256 public tokensSold;
55   uint256 public minBuy;
56   uint256 public maxBuy;
57 
58   token tokenReward;
59 
60   // mapping (address => uint) public contributions;
61   
62 
63 
64   // start and end timestamps where investments are allowed (both inclusive)
65   uint256 public startTime;
66   // uint256 public endTime;
67   // amount of raised money in wei
68   uint256 public weiRaised;
69 
70   /**
71    * event for token purchase logging
72    * @param purchaser who paid for the tokens
73    * @param beneficiary who got the tokens
74    * @param value weis paid for purchase
75    * @param amount amount of tokens purchased
76    */
77   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
78 
79 
80   function Crowdsale() {
81     //You will change this to your wallet where you need the ETH 
82     wallet = 0xD975c18B7B9e6a0821cD86126705f9544B6e392d;
83     // durationInMinutes = _durationInMinutes;
84     //Here will come the checksum address we got
85     addressOfTokenUsedAsReward = 0x2f5381bA547332d2a972189B5a4bB895A32aE4B6;
86 
87 
88     tokenReward = token(addressOfTokenUsedAsReward);
89   }
90 
91   bool public started = false;
92 
93   function startSale(uint256 _delayInMinutes){
94     if (msg.sender != wallet) throw;
95     startTime = now + _delayInMinutes*1 minutes;
96     started = true;
97   }
98 
99   function stopSale(){
100     if(msg.sender != wallet) throw;
101     started = false;
102   }
103 
104   function setPrice(uint256 _price){
105     if(msg.sender != wallet) throw;
106     price = _price;
107   }
108 
109   function setMinBuy(uint256 _minBuy){
110     if(msg.sender!=wallet) throw;
111     minBuy = _minBuy;
112   }
113 
114   function setMaxBuy(uint256 _maxBuy){
115     if(msg.sender != wallet) throw;
116     maxBuy = _maxBuy;
117   }
118 
119   function changeWallet(address _wallet){
120   	if(msg.sender != wallet) throw;
121   	wallet = _wallet;
122   }
123 
124   function changeTokenReward(address _token){
125     if(msg.sender!=wallet) throw;
126     tokenReward = token(_token);
127   }
128 
129   function setTokensSoldGoal(uint256 _goal){
130     if(msg.sender!=wallet) throw;
131     tokensSoldGoal = _goal;
132   }
133 
134   function setPriceBeforeGoalReached(uint256 _price){
135     if(msg.sender!=wallet) throw;
136     priceBeforeGoalReached = _price;
137   }
138 
139   // fallback function can be used to buy tokens
140   function () payable {
141     buyTokens(msg.sender);
142   }
143 
144   // low level token purchase function
145   function buyTokens(address beneficiary) payable {
146     require(beneficiary != 0x0);
147     require(validPurchase());
148 
149     uint256 weiAmount = msg.value;
150 
151     if(weiAmount < 10**17) throw;
152 
153     // calculate token amount to be sent
154     uint256 tokens;
155 
156     if (tokensSoldGoal>0&&tokensSold<tokensSoldGoal*10**18)
157       tokens = (weiAmount) * priceBeforeGoalReached; 
158     else tokens = (weiAmount) * price;
159     
160     if(minBuy!=0){
161       if(tokens < minBuy*10**18) throw;
162     }
163 
164     if(maxBuy!=0){
165       if(tokens > maxBuy*10**18) throw;
166     }
167 
168     // update state
169     weiRaised = weiRaised.add(weiAmount);
170     tokensSold = tokensSold.add(tokens);
171     
172     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
173     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
174 
175     tokenReward.transfer(beneficiary, tokens);
176     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
177     forwardFunds();
178   }
179 
180   // send ether to the fund collection wallet
181   // override to create custom fund forwarding mechanisms
182   function forwardFunds() internal {
183     // wallet.transfer(msg.value);
184     if (!wallet.send(msg.value)) {
185       throw;
186     }
187   }
188 
189   // @return true if the transaction can buy tokens
190   function validPurchase() internal constant returns (bool) {
191     bool withinPeriod = started&&(now>=startTime);
192     bool nonZeroPurchase = msg.value != 0;
193     return withinPeriod && nonZeroPurchase;
194   }
195 
196   function withdrawTokens(uint256 _amount) {
197     if(msg.sender!=wallet) throw;
198     tokenReward.transfer(wallet,_amount);
199   }
200 }