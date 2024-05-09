1 pragma solidity ^0.4.23;
2 
3 // ----------------------------------------------------------------------------
4 // 'buckycoin' CROWDSALE token contract
5 //
6 // Deployed to : 0xf4bea2e58380ea34dcb45c4957af56cbce32a943
7 // Symbol      : BUC
8 // Name        : buckycoin Token
9 // Total supply: 940000000
10 // Decimals    : 18
11 //
12 // POWERED BY BUCKY HOUSE.
13 //
14 // (c) by Team @ BUCKYHOUSE  2018.
15 // ----------------------------------------------------------------------------
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
23     uint256 c = a * b;
24     assert(a == 0 || c / a == b);
25     return c;
26   }
27 
28   function div(uint256 a, uint256 b) internal constant returns (uint256) {
29     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
30     uint256 c = a / b;
31     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
32     return c;
33   }
34 
35   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   function add(uint256 a, uint256 b) internal constant returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 /**
48  * @title Crowdsale
49  * @dev Crowdsale is a base contract for managing a token crowdsale.
50  * Crowdsales have a start and end timestamps, where investors can make
51  * token purchases and the crowdsale will assign them tokens based
52  * on a token per ETH rate. Funds collected are forwarded 
53  to a wallet
54  * as they arrive.
55  */
56 contract token { function transfer(address receiver, uint amount){  } }
57 contract Crowdsale {
58   using SafeMath for uint256;
59 
60   // uint256 durationInMinutes;
61   // address where funds are collected
62   address public wallet;
63   // token address
64   address public addressOfTokenUsedAsReward;
65 
66   uint256 public price = 1000;
67   uint256 public bonusPercent = 20;
68   uint256 public referralBonusPercent = 5;
69 
70   token tokenReward;
71 
72   // mapping (address => uint) public contributions;
73   // mapping(address => bool) public whitelist;
74   mapping (address => uint) public bonuses;
75   mapping (address => uint) public bonusUnlockTime;
76 
77 
78   // start and end timestamps where investments are allowed (both inclusive)
79   // uint256 public startTime;
80   // uint256 public endTime;
81   // amount of raised money in wei
82   uint256 public weiRaised;
83   uint256 public tokensSold;
84 
85   /**
86    * event for token purchase logging
87    * @param purchaser who paid for the tokens
88    * @param beneficiary who got the tokens
89    * @param value weis paid for purchase
90    * @param amount amount of tokens purchased
91    */
92   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
93 
94 
95   function Crowdsale() {
96 
97     //You will change this to your wallet where you need the ETH 
98     wallet = 0x965A2a21C60252C09E5e2872b8d3088424c4f58A;
99     // durationInMinutes = _durationInMinutes;
100     //Here will come the checksum address we got
101     addressOfTokenUsedAsReward = 0xF86C2C4c7Dd79Ba0480eBbEbd096F51311Cfb952;
102 
103 
104     tokenReward = token(addressOfTokenUsedAsReward);
105   }
106 
107   bool public started = true;
108 
109   function startSale() {
110     require(msg.sender == wallet);
111     started = true;
112   }
113 
114   function stopSale() {
115     require(msg.sender == wallet);
116     started = false;
117   }
118 
119   function setPrice(uint256 _price) {
120     require(msg.sender == wallet);
121     price = _price;
122   }
123 
124   function changeWallet(address _wallet) {
125     require(msg.sender == wallet);
126     wallet = _wallet;
127   }
128 
129   function changeTokenReward(address _token) {
130     require(msg.sender==wallet);
131     tokenReward = token(_token);
132     addressOfTokenUsedAsReward = _token;
133   }
134 
135   function setBonusPercent(uint256 _bonusPercent) {
136     require(msg.sender == wallet);
137     bonusPercent = _bonusPercent;
138   }
139 
140   function getBonus() {
141     address sender = msg.sender;
142     require(bonuses[sender] > 0);
143     require(bonusUnlockTime[sender]!=0 && 
144       now > bonusUnlockTime[sender]);
145     tokenReward.transfer(sender, bonuses[sender]);
146     bonuses[sender] = 0;
147   }
148 
149   function setReferralBonusPercent(uint256 _referralBonusPercent) {
150     require(msg.sender == wallet);
151     referralBonusPercent = _referralBonusPercent;
152   }
153 
154 
155   // function whitelistAddresses(address[] _addrs){
156   //   require(msg.sender==wallet);
157   //   for(uint i = 0; i < _addrs.length; ++i)
158   //     whitelist[_addrs[i]] = true;
159   // }
160 
161   // function removeAddressesFromWhitelist(address[] _addrs){
162   //   require(msg.sender==wallet);
163   //   for(uint i = 0;i < _addrs.length;++i)
164   //     whitelist[_addrs[i]] = false;
165   // }
166 
167   // fallback function can be used to buy tokens
168   function () payable {
169     buyTokens(msg.sender, 0x0);
170   }
171 
172   // low level token purchase function
173   function buyTokens(address beneficiary, address referrer) payable {
174     require(beneficiary != 0x0);
175     require(validPurchase());
176     // require(whitelist[beneficiary]);
177 
178     uint256 weiAmount = msg.value;
179 
180     // if(weiAmount < 10**16) throw;
181     // if(weiAmount > 50*10**18) throw;
182 
183     // calculate token amount to be sent
184     uint256 tokens = weiAmount.mul(price);
185     uint256 bonusTokens = tokens.mul(bonusPercent)/100;
186     uint256 referralBonusTokens = tokens.mul(referralBonusPercent)/100;
187     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
188 
189 
190     // update state
191     weiRaised = weiRaised.add(weiAmount);
192     
193     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
194     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
195 
196     tokenReward.transfer(beneficiary, tokens);
197     tokensSold = tokensSold.add(tokens);
198     bonuses[beneficiary] = bonuses[beneficiary].add(bonusTokens);
199     bonusUnlockTime[beneficiary] = now.add(6*30 days);
200     tokensSold = tokensSold.add(bonusTokens);
201     if (referrer != 0x0) {
202       bonuses[referrer] = bonuses[referrer].add(referralBonusTokens);
203       bonusUnlockTime[referrer] = now.add(6*30 days);
204       tokensSold = tokensSold.add(referralBonusTokens);      
205     }
206 
207     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
208     forwardFunds();
209   }
210 
211   // send ether to the fund collection wallet
212   // override to create custom fund forwarding mechanisms
213   function forwardFunds() internal {
214     wallet.transfer(msg.value);
215   }
216 
217   // @return true if the transaction can buy tokens
218   function validPurchase() internal constant returns (bool) {
219     bool withinPeriod = started;
220     bool nonZeroPurchase = msg.value != 0;
221     return withinPeriod && nonZeroPurchase;
222   }
223 
224   function withdrawTokens(uint256 _amount) {
225     require(msg.sender==wallet);
226     tokenReward.transfer(wallet,_amount);
227   }
228 }