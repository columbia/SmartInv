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
72     wallet = 0x8353A3263bc246589eE2a83427D9a805EDD79750;
73     // durationInMinutes = _durationInMinutes;
74     addressOfTokenUsedAsReward = 0x070C9244a54353a0F9c43670b21856Df2CC4e439;
75 
76 
77     tokenReward = token(addressOfTokenUsedAsReward);
78     startTime = now + 28250 * 1 minutes;
79     endTime = startTime + 64*24*60 * 1 minutes;
80   }
81 
82   // fallback function can be used to buy tokens
83   function () payable {
84     buyTokens(msg.sender);
85   }
86 
87   // low level token purchase function
88   function buyTokens(address beneficiary) payable {
89     require(beneficiary != 0x0);
90     require(validPurchase());
91 
92     uint256 weiAmount = msg.value;
93 
94     // calculate token amount to be sent
95     uint256 tokens = (weiAmount / 10000000000) * 300;
96 
97     if(now < startTime + 1*7*24*60* 1 minutes){
98       tokens += (tokens * 25) / 100;
99     }else if(now < startTime + 2*7*24*60* 1 minutes){
100       tokens += (tokens * 20) / 100;
101     }else if(now < startTime + 3*7*24*60* 1 minutes){
102       tokens += (tokens * 15) / 100;
103     }else if(now < startTime + 4*7*24*60* 1 minutes){
104       tokens += (tokens * 10) / 100;
105     }else if(now < startTime + 5*7*24*60* 1 minutes){
106       tokens += (tokens * 5) / 100;
107     }
108 
109     // update state
110     weiRaised = weiRaised.add(weiAmount);
111 
112     tokenReward.transfer(beneficiary, tokens);
113     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
114     forwardFunds();
115   }
116 
117   // send ether to the fund collection wallet
118   // override to create custom fund forwarding mechanisms
119   function forwardFunds() internal {
120     // wallet.transfer(msg.value);
121     if (!wallet.send(msg.value)) {
122       throw;
123     }
124   }
125 
126   // @return true if the transaction can buy tokens
127   function validPurchase() internal constant returns (bool) {
128     bool withinPeriod = now >= startTime && now <= endTime;
129     bool nonZeroPurchase = msg.value != 0;
130     return withinPeriod && nonZeroPurchase;
131   }
132 
133   // @return true if crowdsale event has ended
134   function hasEnded() public constant returns (bool) {
135     return now > endTime;
136   }
137 
138   function withdrawTokens(uint256 _amount) {
139     if(msg.sender!=wallet) throw;
140     tokenReward.transfer(wallet,_amount);
141   }
142 }