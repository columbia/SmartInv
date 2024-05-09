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
50   address public addressOfTokenUsedAsReward1;
51   address public addressOfTokenUsedAsReward2;
52   address public addressOfTokenUsedAsReward3;
53   address public addressOfTokenUsedAsReward4;
54   address public addressOfTokenUsedAsReward5;
55 
56   uint256 public price = 7500;
57 
58   token tokenReward1;
59   token tokenReward2;
60   token tokenReward3;
61   token tokenReward4;
62   token tokenReward5;
63 
64   // mapping (address => uint) public contributions;
65   
66 
67 
68   // start and end timestamps where investments are allowed (both inclusive)
69   // uint256 public startTime;
70   // uint256 public endTime;
71   // amount of raised money in wei
72   uint256 public weiRaised;
73 
74   /**
75    * event for token purchase logging
76    * @param purchaser who paid for the tokens
77    * @param beneficiary who got the tokens
78    * @param value weis paid for purchase
79    * @param amount amount of tokens purchased
80    */
81   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
82 
83 
84   function Crowdsale() {
85     //You will change this to your wallet where you need the ETH 
86     wallet = 0xE37C4541C34e4A8785DaAA9aEb5005DdD29854ac;
87     // durationInMinutes = _durationInMinutes;
88     //Here will come the checksum address we got
89     //aircoin
90     addressOfTokenUsedAsReward1 = 0xBD17Dfe402f1Afa41Cda169297F8de48d6Dfb613;
91     //diamond
92     addressOfTokenUsedAsReward2 = 0x489DF6493C58642e6a4651dDcd4145eaFBAA1018;
93     //silver
94     addressOfTokenUsedAsReward3 = 0x404a639086eda1B9C8abA3e34a5f8145B4B04ea5;
95     //usdgold
96     addressOfTokenUsedAsReward4 = 0x00755562Dfc1F409ec05d38254158850E4e8362a;
97     //worldcoin
98     addressOfTokenUsedAsReward5 = 0xE7AE9dc8F5F572e4f80655C4D0Ffe32ec16fF0E3;
99 
100 
101     tokenReward1 = token(addressOfTokenUsedAsReward1);
102     tokenReward2 = token(addressOfTokenUsedAsReward2);
103     tokenReward3 = token(addressOfTokenUsedAsReward3);
104     tokenReward4 = token(addressOfTokenUsedAsReward4);
105     tokenReward5 = token(addressOfTokenUsedAsReward5);
106   }
107 
108   bool public started = true;
109 
110   function startSale(){
111     if (msg.sender != wallet) throw;
112     started = true;
113   }
114 
115   function stopSale(){
116     if(msg.sender != wallet) throw;
117     started = false;
118   }
119 
120   function setPrice(uint256 _price){
121     if(msg.sender != wallet) throw;
122     price = _price;
123   }
124   function changeWallet(address _wallet){
125   	if(msg.sender != wallet) throw;
126   	wallet = _wallet;
127   }
128 
129   // function changeTokenReward(address _token){
130   //   if(msg.sender!=wallet) throw;
131   //   tokenReward = token(_token);
132   // }
133 
134   // fallback function can be used to buy tokens
135   function () payable {
136     buyTokens(msg.sender);
137   }
138 
139   // low level token `purchase function
140   function buyTokens(address beneficiary) payable {
141     require(beneficiary != 0x0);
142     require(validPurchase());
143 
144     uint256 weiAmount = msg.value;
145 
146     // if(weiAmount < 10**16) throw;
147     // if(weiAmount > 50*10**18) throw;
148 
149     // calculate token amount to be sent
150     uint256 tokens = (weiAmount/10**10) * price;//weiamount * price 
151     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
152 
153     // update state
154     weiRaised = weiRaised.add(weiAmount);
155     
156     // if(contributions[msg.sender].add(weiAmount)>10*10**18) throw;
157     // contributions[msg.sender] = contributions[msg.sender].add(weiAmount);
158 
159     tokenReward1.transfer(beneficiary, tokens);
160     tokenReward2.transfer(beneficiary, tokens);
161     tokenReward3.transfer(beneficiary, tokens);
162     tokenReward4.transfer(beneficiary, tokens);
163     tokenReward5.transfer(beneficiary, tokens);
164     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
165     forwardFunds();
166   }
167 
168   // send ether to the fund collection wallet
169   // override to create custom fund forwarding mechanisms
170   function forwardFunds() internal {
171     // wallet.transfer(msg.value);
172     if (!wallet.send(msg.value)) {
173       throw;
174     }
175   }
176 
177   // @return true if the transaction can buy tokens
178   function validPurchase() internal constant returns (bool) {
179     bool withinPeriod = started;
180     bool nonZeroPurchase = msg.value != 0;
181     return withinPeriod && nonZeroPurchase;
182   }
183 
184   function withdrawTokens1(uint256 _amount) {
185     if(msg.sender!=wallet) throw;
186     tokenReward1.transfer(wallet,_amount);
187   }
188   function withdrawTokens2(uint256 _amount) {
189     if(msg.sender!=wallet) throw;
190     tokenReward2.transfer(wallet,_amount);
191   }
192   function withdrawTokens3(uint256 _amount) {
193     if(msg.sender!=wallet) throw;
194     tokenReward3.transfer(wallet,_amount);
195   }
196   function withdrawTokens4(uint256 _amount) {
197     if(msg.sender!=wallet) throw;
198     tokenReward4.transfer(wallet,_amount);
199   }
200   function withdrawTokens5(uint256 _amount) {
201     if(msg.sender!=wallet) throw;
202     tokenReward5.transfer(wallet,_amount);
203   }
204 }