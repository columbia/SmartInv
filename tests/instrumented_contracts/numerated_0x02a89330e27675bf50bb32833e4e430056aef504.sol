1 pragma solidity ^0.4.18;
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
42 
43 contract SmartBondsSale {
44   using SafeMath for uint256;
45 
46   // uint256 durationInMinutes;
47   // address where funds are collected
48   address public badgerWallet;
49   address public investmentFundWallet;
50   address public buyoutWallet;
51   // token address
52   address addressOfTokenUsedAsReward;
53 
54   token tokenReward;
55 
56 
57 
58   // start and end timestamps where investments are allowed (both inclusive)
59   uint256 public startTime;
60   uint256 public endTime;
61   // amount of raised money in wei
62   uint256 public weiRaised;
63   
64   uint256 public badgerAmount;
65   uint256 public investAmount;
66   uint256 public buyoutAmount;
67 
68   /**
69    * event for token purchase logging
70    * @param purchaser who paid for the tokens
71    * @param beneficiary who got the tokens
72    * @param value weis paid for purchase
73    * @param amount amount of tokens purchased
74    */
75   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
76 
77 
78   function SmartBondsSale() {
79     // ether addressess where funds will be distributed
80     badgerWallet = 0x5cB7a6547A9408e3C9B09FB5c640d4fB767b8070; 
81     investmentFundWallet = 0x8F2d31E3c259F65222D0748e416A79e51589Ce3b;
82     buyoutWallet = 0x336b903eF5e3c911df7f8172EcAaAA651B80CA1D;
83    
84     // address of SmartBonds Token 
85     addressOfTokenUsedAsReward = 0x38dCb83980183f089FC7D147c5bF82E5C9b8F237;
86     tokenReward = token(addressOfTokenUsedAsReward);
87     
88     // start and end times of contract sale 
89     startTime = 1533583718; // now
90     endTime = startTime + 182 * 1 days; // 182 days
91   }
92 
93   // fallback function can be used to buy tokens
94   function () payable {
95     buyTokens(msg.sender);
96   }
97 
98   // low level token purchase function
99   function buyTokens(address beneficiary) payable {
100     require(beneficiary != 0x0);
101     require(validPurchase());
102 
103     // minimum amount is 2.5 eth, and max is 25 eth 
104     uint256 weiAmount = msg.value;
105     if(weiAmount < 2.5 * 10**18) throw; 
106     if(weiAmount > 25 * 10**18) throw;
107     
108     // divide wei sent into distribution wallets 
109     badgerAmount = (5 * weiAmount)/100;
110     buyoutAmount = (25 * weiAmount)/100;
111     investAmount = (70 * weiAmount)/100;
112 
113     // tokenPrice
114     uint256 tokenPrice = 25000000000000000;
115     // calculate token amount to be sent
116     uint256 tokens = (weiAmount *10**18) / tokenPrice;
117 
118     // update state
119     weiRaised = weiRaised.add(weiAmount);
120 
121     tokenReward.transfer(beneficiary, tokens);
122     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
123     forwardFunds();
124   }
125 
126   // send ether to the fund collection wallet
127   // override to create custom fund forwarding mechanisms
128   function forwardFunds() internal {
129     // wallet.transfer(msg.value);
130     if (!badgerWallet.send(badgerAmount)) {
131       throw;
132     }
133     if (!investmentFundWallet.send(investAmount)){
134         throw;
135     }
136     if (!buyoutWallet.send(buyoutAmount)){
137         throw;
138     }
139   }
140 
141   // @return true if the transaction can buy tokens
142   function validPurchase() internal constant returns (bool) {
143     bool withinPeriod = now >= startTime && now <= endTime;
144     bool nonZeroPurchase = msg.value != 0;
145     return withinPeriod && nonZeroPurchase;
146   }
147 
148   // @return true if crowdsale event has ended
149   function hasEnded() public constant returns (bool) {
150     return now > endTime;
151   }
152 
153   function withdrawTokens(uint256 _amount) {
154     if(msg.sender!=badgerWallet) throw;
155     tokenReward.transfer(badgerWallet,_amount);
156   }
157 }