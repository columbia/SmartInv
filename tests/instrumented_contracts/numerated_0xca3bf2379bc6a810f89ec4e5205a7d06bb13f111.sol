1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
9     uint256 c = a * b;
10     assert(a == 0 || c / a == b);
11     return c;
12   }
13 
14   function div(uint256 a, uint256 b) internal pure returns (uint256) {
15     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
16     uint256 c = a / b;
17     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
18     return c;
19   }
20 
21   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22     assert(b <= a);
23     return a - b;
24   }
25 
26   function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
42 interface token { function transfer(address, uint) external; }
43 contract Crowdsale {
44   using SafeMath for uint256;
45 
46   // uint256 durationInMinutes;
47   // address where funds are collected
48   address public wallet;
49   // token address
50   address public addressOfTokenUsedAsReward;
51 
52   uint256 public price = 25000;
53 
54   token tokenReward;
55 
56   
57 
58 
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
72   constructor () public {
73     //You will change this to your wallet where you need the ETH 
74     wallet = 0x6F3D70BAe7Cb77F064B7bD1773D5c1fB38F67cbE;
75     // this the token contract address
76     addressOfTokenUsedAsReward = 0x85C77C93B730Bc4F568aff15F98Cea8Bd7230E1c  ;
77 
78 
79     tokenReward = token(addressOfTokenUsedAsReward);
80   }
81 
82   bool public started = true;
83 
84 
85   function stopSale() public {
86     require (msg.sender == wallet);
87     started = false;
88   }
89 
90 
91   // fallback function can be used to buy tokens
92   function () payable public {
93     buyTokens(msg.sender);
94   }
95 
96   // low level token purchase function
97   function buyTokens(address beneficiary) payable public {
98     require(beneficiary != 0x0);
99     require(validPurchase());
100 
101     uint256 weiAmount = msg.value;
102 
103     require (weiAmount >= 5**16);
104 
105     // calculate token amount to be sent
106     uint256 tokens = (weiAmount/10**10) * price;// weiamount/(10**(18-decimals)) * price 
107 
108     // update state
109     weiRaised = weiRaised.add(weiAmount);
110     
111 
112     tokenReward.transfer(beneficiary, tokens);
113     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
114     forwardFunds();
115   }
116 
117   // send ether to the fund collection wallet
118   // override to create custom fund forwarding mechanisms
119   function forwardFunds() internal {
120     wallet.transfer(msg.value);
121   }
122 
123   // @return true if the transaction can buy tokens
124   function validPurchase() internal constant returns (bool) {
125     bool withinPeriod = started;
126     bool nonZeroPurchase = msg.value != 0;
127     return withinPeriod && nonZeroPurchase;
128   }
129 
130   function withdrawTokens(uint256 _amount) public {
131     require (msg.sender==wallet);
132     tokenReward.transfer(wallet,_amount);
133   }
134 }