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
15     // assert(b > 0); // Solidity automatically throws when dividing by 0
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
60 
61   /**
62    * event for token purchase logging
63    * @param purchaser who paid for the tokens
64    * @param beneficiary who got the tokens
65    * @param value weis paid for purchase
66    * @param amount amount of tokens purchased
67    */
68   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
69 
70 
71   function Crowdsale() {
72     wallet = 0xA10f6f8A723038ca267FD8D5354d1563238dc1De;
73     // durationInMinutes = _durationInMinutes;
74     addressOfTokenUsedAsReward = 0xdFF8e7f5496D1e1A4Af3497Cb4712017a9C65442;
75 
76 
77     tokenReward = token(addressOfTokenUsedAsReward);
78   }
79 
80   bool started = false;
81 
82   function startSale(uint256 delay){
83     if (msg.sender != wallet || started) throw;
84     startTime = now + delay * 1 minutes;
85     endTime = startTime + 42 * 24 * 60 * 1 minutes;
86     started = true;
87   }
88 
89   // fallback function can be used to buy tokens
90   function () payable {
91     buyTokens(msg.sender);
92   }
93 
94   // low level token purchase function
95   function buyTokens(address beneficiary) payable {
96     require(beneficiary != 0x0);
97     require(validPurchase());
98 
99     uint256 weiAmount = msg.value;
100 
101     // calculate token amount to be sent
102     uint256 tokens = (weiAmount) * 3000;
103 
104     if(now < startTime + 1*7*24*60* 1 minutes){
105       tokens += (tokens * 60) / 100;
106     }else if(now < startTime + 2*7*24*60* 1 minutes){
107       tokens += (tokens * 40) / 100;
108     }else if(now < startTime + 3*7*24*60* 1 minutes){
109       tokens += (tokens * 30) / 100;
110     }else if(now < startTime + 4*7*24*60* 1 minutes){
111       tokens += (tokens * 20) / 100;
112     }else if(now < startTime + 5*7*24*60* 1 minutes){
113       tokens += (tokens * 10) / 100;
114     }
115 
116     // update state
117     weiRaised = weiRaised.add(weiAmount);
118 
119     tokenReward.transfer(beneficiary, tokens);
120     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
121     forwardFunds();
122   }
123 
124   // send ether to the fund collection wallet
125   // override to create custom fund forwarding mechanisms
126   function forwardFunds() internal {
127     // wallet.transfer(msg.value);
128     if (!wallet.send(msg.value)) {
129       throw;
130     }
131   }
132 
133   // @return true if the transaction can buy tokens
134   function validPurchase() internal constant returns (bool) {
135     bool withinPeriod = now >= startTime && now <= endTime;
136     bool nonZeroPurchase = msg.value != 0;
137     return withinPeriod && nonZeroPurchase;
138   }
139 
140   // @return true if crowdsale event has ended
141   function hasEnded() public constant returns (bool) {
142     return now > endTime;
143   }
144 
145   function withdrawTokens(uint256 _amount) {
146     if(msg.sender!=wallet) throw;
147     tokenReward.transfer(wallet,_amount);
148   }
149 }