1 pragma solidity ^0.4.16;
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
43 contract ProvidencePresale {
44   using SafeMath for uint256;
45 
46   // uint256 durationInMinutes;
47   // address where funds are collected
48   address public wallet;
49   // token address
50   address addressOfTokenUsedAsReward;
51 
52   token tokenReward;
53 
54 
55 
56   // start and end timestamps where investments are allowed (both inclusive)
57   uint256 public startTime;
58   uint256 public endTime;
59   // amount of raised money in wei
60   uint256 public weiRaised;
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
72   function ProvidencePresale() {
73     // ether address
74     wallet = 0x2F81D169A4A773e614eC6958817Ed76381089615;
75     // durationInMinutes = _durationInMinutes;
76     addressOfTokenUsedAsReward = 0x50584a9bDfAb54B82e620b8a14cC082B07886841;
77     tokenReward = token(addressOfTokenUsedAsReward);
78     startTime = now; // now
79     endTime = startTime + 14*24*60 * 1 minutes;  // 
80   }
81 
82   // fallback function can be used to buy tokens
83   function () payable {
84     buyTokens(msg.sender);
85   }
86 
87   // low level token purchase function
88 
89   function buyTokens(address beneficiary) payable {
90     require(beneficiary != 0x0);
91     require(validPurchase());
92 
93     uint256 weiAmount = msg.value;
94     if(weiAmount < 1 * 10**18) throw;
95 
96     // calculate token amount to be sent
97     uint256 tokens = (weiAmount) * 810;
98 
99     // update state
100     weiRaised = weiRaised.add(weiAmount);
101 
102     tokenReward.transfer(beneficiary, tokens);
103     TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
104     forwardFunds();
105   }
106 
107   // send ether to the fund collection wallet
108   // override to create custom fund forwarding mechanisms
109   function forwardFunds() internal {
110     // wallet.transfer(msg.value);
111     if (!wallet.send(msg.value)) {
112       throw;
113     }
114   }
115 
116   // @return true if the transaction can buy tokens
117   function validPurchase() internal constant returns (bool) {
118     bool withinPeriod = now >= startTime && now <= endTime;
119     bool nonZeroPurchase = msg.value != 0;
120     return withinPeriod && nonZeroPurchase;
121   }
122 
123   // @return true if crowdsale event has ended
124   function hasEnded() public constant returns (bool) {
125     return now > endTime;
126   }
127 
128   function withdrawTokens(uint256 _amount) {
129     if(msg.sender!=wallet) throw;
130     tokenReward.transfer(wallet,_amount);
131   }
132 }