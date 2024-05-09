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
38  * on a token per ETH rate. Funds collected are forwarded 
39  to a wallet
40  * as they arrive.
41  */
42 contract token { function transfer(address receiver, uint amount){  } }
43 contract Crowdsale {
44   using SafeMath for uint256;
45 
46   // uint256 durationInMinutes;
47   // address where funds are collected
48   address public wallet;
49   // token address
50   address public addressOfTokenUsedAsReward;
51 
52   // uint256 public price = 18000;
53 
54   token tokenReward;
55 
56   // mapping (address => uint) public contributions;
57   mapping(address => bool) public whitelist;
58 
59 
60   // start and end timestamps where investments are allowed (both inclusive)
61   uint256 public startTime;
62   uint256 public endTime;
63   // amount of raised money in wei
64   uint256 public weiRaised;
65   uint256 public tokensSold;
66 
67   /**
68    * event for token purchase logging
69    * @param purchaser who paid for the tokens
70    * @param beneficiary who got the tokens
71    * @param value weis paid for purchase
72    * @param amount amount of tokens purchased
73    */
74   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
75 
76 
77   function Crowdsale() {
78     // how many minutes
79     startTime = now + 80715 * 1 minutes;
80     endTime = startTime + 31*24*60*1 minutes;
81 
82     //You will change this to your wallet where you need the ETH 
83     wallet = 0xe65b6eEAfE34adb2e19e8b2AE9c517688771548E;
84     // durationInMinutes = _durationInMinutes;
85     //Here will come the checksum address we got
86     addressOfTokenUsedAsReward = 0xA024E8057EEC474a9b2356833707Dd0579E26eF3;
87 
88 
89     tokenReward = token(addressOfTokenUsedAsReward);
90   }
91 
92   // bool public started = true;
93 
94   // function startSale(){
95   //   require(msg.sender == wallet);
96   //   started = true;
97   // }
98 
99   // function stopSale(){
100   //   require(msg.sender == wallet);
101   //   started = false;
102   // }
103 
104   // function setPrice(uint256 _price){
105   //   require(msg.sender == wallet);
106   //   price = _price;
107   // }
108 
109   function changeWallet(address _wallet){
110   	require(msg.sender == wallet);
111   	wallet = _wallet;
112   }
113 
114   // function changeTokenReward(address _token){
115   //   require(msg.sender==wallet);
116   //   tokenReward = token(_token);
117   //   addressOfTokenUsedAsReward = _token;
118   // }
119 
120   function whitelistAddresses(address[] _addrs){
121     require(msg.sender==wallet);
122     for(uint i = 0; i < _addrs.length; ++i)
123       whitelist[_addrs[i]] = true;
124   }
125 
126   function removeAddressesFromWhitelist(address[] _addrs){
127     require(msg.sender==wallet);
128     for(uint i = 0;i < _addrs.length;++i)
129       whitelist[_addrs[i]] = false;
130   }
131 
132   // fallback function can be used to buy tokens
133   function () payable {
134     buyTokens(msg.sender);
135   }
136 
137   // low level token purchase function
138   function buyTokens(address beneficiary) payable {
139     require(beneficiary != 0x0);
140     require(validPurchase());
141     require(whitelist[beneficiary]);
142 
143     uint256 weiAmount = msg.value;
144 
145     // if(weiAmount < 10**16) throw;
146     // if(weiAmount > 50*10**18) throw;
147 
148     // calculate token amount to be sent
149     uint256 tokens = (weiAmount) * 5000;//weiamount * price 
150     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
151 
152     //bonus schedule
153 
154     /*
155       PRE-ICO. (1ETH= 7000 FXY)
156       Start 1.5.2018
157       End 9.5.2018
158       Total coins with 40% bonus 14.000.000 FXY
159       ICO LEVEL 1 (1ETH=6000 FXY)
160       Start 16.5.2018
161       End 23.5.2018
162       Total coins 54.000.000 FXY with 20% bonus
163       ICO LEVEL 2 (1ETH=5000FXY)
164       Start 25.5.2018
165       End 31.5.2018
166       Total coins —> if on ICO Level 1 not sold out, it will be drop here.
167     */
168     if(now < startTime + 9*24*60* 1 minutes){
169       tokens += (tokens * 40) / 100;//40%
170       if(tokensSold>14000000*10**18) throw;
171     }else if(now < startTime + 16*24*60* 1 minutes){
172       throw;
173     }else if(now < startTime + 23*24*60* 1 minutes){
174       tokens += (tokens * 20) / 100;
175     }else if(now < startTime + 25*24*60* 1 minutes){
176       throw;
177     }
178 
179     // update state
180     weiRaised = weiRaised.add(weiAmount);
181     
182     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
183     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
184 
185     tokenReward.transfer(beneficiary, tokens);
186     tokensSold = tokensSold.add(tokens);
187     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
188     forwardFunds();
189   }
190 
191   // send ether to the fund collection wallet
192   // override to create custom fund forwarding mechanisms
193   function forwardFunds() internal {
194     wallet.transfer(msg.value);
195   }
196 
197   // @return true if the transaction can buy tokens
198   function validPurchase() internal constant returns (bool) {
199     bool withinPeriod = now >= startTime && now <= endTime;
200     bool nonZeroPurchase = msg.value != 0;
201     return withinPeriod && nonZeroPurchase;
202   }
203 
204   function withdrawTokens(uint256 _amount) {
205     require(msg.sender==wallet);
206     tokenReward.transfer(wallet,_amount);
207   }
208 }