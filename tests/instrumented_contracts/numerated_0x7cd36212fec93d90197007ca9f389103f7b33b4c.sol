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
49   address addressOfTokenUsedAsReward;
50 
51   token tokenReward;
52 
53 
54 
55   // start and end timestamps where investments are allowed (both inclusive)
56   uint256 public startTime;
57   uint256 public endTime;
58   // amount of raised money in wei
59   uint256 public weiRaised;
60   uint256 public price = 4000;
61 
62   /**
63    * event for token purchase logging
64    * @param purchaser who paid for the tokens
65    * @param beneficiary who got the tokens
66    * @param value weis paid for purchase
67    * @param amount amount of tokens purchased
68    */
69   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
70 
71 
72   function Crowdsale() {
73     //You will change this to your wallet where you need the ETH 
74     wallet = 0x423A3438cF5b954689a85D45B302A5D1F3C763D4;
75     // durationInMinutes = _durationInMinutes;
76     //Here will come the checksum address we got
77     addressOfTokenUsedAsReward = 0xdd007278B667F6bef52fD0a4c23604aA1f96039a;
78 
79 
80     tokenReward = token(addressOfTokenUsedAsReward);
81   }
82 
83   bool started = false;
84 
85   function startSale(uint256 delay){
86     if (msg.sender != wallet || started) throw;
87     startTime = now + delay * 1 minutes;
88     endTime = startTime + 45 * 24 * 60 * 1 minutes;
89     started = true;
90   }
91 
92   function setPrice(uint256 _price){
93     if(msg.sender != wallet) throw;
94     price = _price;
95   }
96 
97   // fallback function can be used to buy tokens
98   function () payable {
99     buyTokens(msg.sender);
100   }
101 
102   // low level token purchase function
103   function buyTokens(address beneficiary) payable {
104     require(beneficiary != 0x0);
105     require(validPurchase());
106 
107     uint256 weiAmount = msg.value;
108 
109     // calculate token amount to be sent
110     uint256 tokens = (weiAmount/10**10) * price;//weiamount * price 
111 
112     //bonus schedule
113     // if(now < startTime + 1*7*24*60* 1 minutes){//First week
114     //   tokens += (tokens * 60) / 100;//60%
115     // }else if(now < startTime + 2*7*24*60* 1 minutes){//Second week
116     //   tokens += (tokens * 40) / 100;//40%
117     // }else if(now < startTime + 3*7*24*60* 1 minutes){//3rd week
118     //   tokens += (tokens * 30) / 100;//30% and so on
119     // }else if(now < startTime + 4*7*24*60* 1 minutes){
120     //   tokens += (tokens * 20) / 100;
121     // }else if(now < startTime + 5*7*24*60* 1 minutes){
122     //   tokens += (tokens * 10) / 100;
123     // }
124 
125     if(now<startTime+27*24*60* 1 minutes){
126       if(weiAmount>=10**18)
127         tokens+=(tokens*60)/100;
128       else if(weiAmount>=5*10**17)
129         tokens+=(tokens*25)/100;
130       else if(weiAmount>=4*10**17)
131         tokens+=(tokens*20)/100;
132       else if(weiAmount>=3*10**17)
133         tokens+=(tokens*15)/100;
134       else if(weiAmount>=2*10**17)
135         tokens+=(tokens*10)/100;
136       else if(weiAmount>=10**17)
137         tokens+=(tokens*5)/100;
138     }
139 
140     // update state
141     weiRaised = weiRaised.add(weiAmount);
142 
143     tokenReward.transfer(beneficiary, tokens);
144     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
145     forwardFunds();
146   }
147 
148   // send ether to the fund collection wallet
149   // override to create custom fund forwarding mechanisms
150   function forwardFunds() internal {
151     // wallet.transfer(msg.value);
152     if (!wallet.send(msg.value)) {
153       throw;
154     }
155   }
156 
157   // @return true if the transaction can buy tokens
158   function validPurchase() internal constant returns (bool) {
159     bool withinPeriod = now >= startTime && now <= endTime;
160     bool nonZeroPurchase = msg.value != 0;
161     return withinPeriod && nonZeroPurchase;
162   }
163 
164   // @return true if crowdsale event has ended
165   function hasEnded() public constant returns (bool) {
166     return now > endTime;
167   }
168 
169   function withdrawTokens(uint256 _amount) {
170     if(msg.sender!=wallet) throw;
171     tokenReward.transfer(wallet,_amount);
172   }
173 }