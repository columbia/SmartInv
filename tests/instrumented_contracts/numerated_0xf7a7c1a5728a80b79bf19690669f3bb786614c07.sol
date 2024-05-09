1 pragma solidity 0.4.24;
2 // ----------------------------------------------------------------------------
3 // 'RIPT' token crowdsale contract
4 //
5 // Deployed to : 0xef9EcD8a0A2E4b31d80B33E243761f4D93c990a8
6 // Symbol      : RIPT
7 // Name        : RiptideCoin
8 //
9 // Copyright (c) Riptidecoin.com The MIT Licence.
10 // Contract crafted by: GDO Infotech Pvt Ltd (https://GDO.co.in) 
11 // ----------------------------------------------------------------------------
12    
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that throw on error
16  */
17 library SafeMath {
18   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
19     uint256 c = a * b;
20     assert(a == 0 || c / a == b);
21     return c;
22   }
23 
24   function div(uint256 a, uint256 b) internal constant returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function add(uint256 a, uint256 b) internal constant returns (uint256) {
37     uint256 c = a + b;
38     assert(c >= a);
39     return c;
40   }
41 }
42 
43 /**
44  * @title Crowdsale
45  * @dev Crowdsale is a base contract for managing a token crowdsale.
46  * Crowdsales have a start and end timestamps, where investors can make
47  * token purchases and the crowdsale will assign them tokens based
48  * on a token per ETH rate. Funds collected are forwarded to a wallet
49  * as they arrive.
50  */
51 contract token { function transfer(address receiver, uint amount){  } }
52 contract Crowdsale {
53   using SafeMath for uint256;
54 
55   // uint256 durationInMinutes;
56   // address where funds are collected
57   address public wallet;
58   // token address
59   address addressOfTokenUsedAsReward;
60 
61   token tokenReward;
62 
63 
64 
65   // start and end timestamps where investments are allowed (both inclusive)
66   uint256 public startTime;
67   uint256 public endTime;
68   // amount of raised money in wei
69   uint256 public weiRaised;
70   uint256 public price = 42000;
71 
72   /**
73    * event for token purchase logging
74    * @param purchaser who paid for the tokens
75    * @param beneficiary who got the tokens
76    * @param value weis paid for purchase
77    * @param amount amount of tokens purchased
78    */
79   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
80 
81 
82   function Crowdsale() {
83     //You will change this to your wallet where you need the ETH 
84     wallet = 0x423A3438cF5b954689a85D45B302A5D1F3C763D4;
85     // durationInMinutes = _durationInMinutes;
86     //Here will come the checksum address we got
87     addressOfTokenUsedAsReward = 0xdd007278B667F6bef52fD0a4c23604aA1f96039a;
88 
89 
90     tokenReward = token(addressOfTokenUsedAsReward);
91   }
92 
93   bool started = false;
94  /*    
95   function startSale(uint256 delay){
96     if (msg.sender != wallet || started) throw;
97     startTime = now + delay * 1 minutes;
98     endTime = startTime + 45 * 24 * 60 * 1 minutes;
99     started = true;
100   }
101 */
102  
103     function startSale(uint256 Start,uint256 End,uint256 amount) public
104     {
105      if (msg.sender != wallet || started) throw;
106      require(Start < End);
107   require(now < Start);
108   //require(balanceOf[msg.sender] > amount);
109   startTime=Start;
110   endTime=End;
111   tokenReward.transfer(this,amount);
112     }
113  function stopSale()  public{
114             require(msg.sender == wallet);
115             endTime = 0;
116         }
117   function setPrice(uint256 _price){
118     if(msg.sender != wallet) throw;
119     price = _price;
120   }
121  function manualEtherWithdraw() public{
122       require(msg.sender == wallet); 
123    if (!wallet.send(address(this).balance)) {
124      throw;
125    }
126   }
127   // fallback function can be used to buy tokens
128   function () payable {
129     buyTokens(msg.sender);
130   }
131 
132   // low level token purchase function
133   function buyTokens(address beneficiary) payable {
134     require(beneficiary != 0x0);
135     require(validPurchase());
136 
137     uint256 weiAmount = msg.value;
138 
139     // calculate token amount to be sent
140     uint256 tokens = (weiAmount/
141 10**10) * price;//weiamount * price 
142 
143     //bonus schedule
144     // if(now < startTime + 1*7*24*60* 1 minutes){//First week
145     //   tokens += (tokens * 60) / 100;//60%
146     // }else if(now < startTime + 2*7*24*60* 1 minutes){//Second week
147     //   tokens += (tokens * 40) / 100;//40%
148     // }else if(now < startTime + 3*7*24*60* 1 minutes){//3rd week
149     //   tokens += (tokens * 30) / 100;//30% and so on
150     // }else if(now < startTime + 4*7*24*60* 1 minutes){
151     //   tokens += (tokens * 20) / 100;
152     // }else if(now < startTime + 5*7*24*60* 1 minutes){
153     //   tokens += (tokens * 10) / 100;
154     // }
155     /*
156     if(now<startTime+27*24*60* 1 minutes){
157       if(weiAmount>=10**18)
158         tokens+=(tokens*60)/100;
159       else if(weiAmount>=5*10**17)
160         tokens+=(tokens*25)/100;
161       else if(weiAmount>=4*10**17)
162         tokens+=(tokens*20)/100;
163       else if(weiAmount>=3*10**17)
164         tokens+=(tokens*15)/100;
165       else if(weiAmount>=2*10**17)
166         tokens+=(tokens*10)/100;
167       else if(weiAmount>=10**17)
168         tokens+=(tokens*5)/100;
169     }
170     */
171     // update state
172     weiRaised = weiRaised.add(weiAmount);
173 
174     tokenReward.transfer(beneficiary, tokens);
175     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
176     forwardFunds();
177   }
178 
179   // send ether to the fund collection wallet
180   // override to create custom fund forwarding mechanisms
181   function forwardFunds() internal {
182     // wallet.transfer(msg.value);
183     if (!wallet.send(msg.value)) {
184       throw;
185     }
186   }
187 
188   // @return true if the transaction can buy tokens
189   function validPurchase() internal constant returns (bool) {
190     bool withinPeriod = now >= startTime && now <= endTime;
191     bool nonZeroPurchase = msg.value != 0;
192     return withinPeriod && nonZeroPurchase;
193   }
194 
195   // @return true if crowdsale event has ended
196   function hasEnded() public constant returns (bool) {
197     return now > endTime;
198   }
199 
200   function withdrawTokens(uint256 _amount) {
201     if(msg.sender!=wallet) throw;
202     tokenReward.transfer(wallet,_amount);
203   }
204 }