1 pragma solidity ^0.4.25;
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
42 interface token { function transfer(address receiver, uint amount) external ; }
43 contract Crowdsale {
44   using SafeMath for uint256;
45 
46 
47   // address where funds are collected
48   address public wallet;
49   // token address
50   address public addressOfTokenUsedAsReward;
51 
52   uint256 public price = 1650;
53 
54   token tokenReward;
55 
56   // amount of raised money in wei
57   uint256 public weiRaised;
58 
59   /**
60    * event for token purchase logging
61    * @param purchaser who paid for the tokens
62    * @param beneficiary who got the tokens
63    * @param value weis paid for purchase
64    * @param amount amount of tokens purchased
65    */
66   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
67 
68 
69   constructor () public {
70     //You will change this to your wallet where you need the ETH 
71     wallet = 0x237625d599dd5F30E51ccd0F51B5Ee564d31Bd7b;
72     
73     //Here will come the checksum address we got
74     addressOfTokenUsedAsReward =  0x4a74Df6113E3d38d8e184273341Cb6BBb6885152;
75 
76     tokenReward = token(addressOfTokenUsedAsReward);
77   }
78 
79   bool public started = true;
80 
81   function startSale() public {
82     require (msg.sender == wallet);
83     started = true;
84   }
85 
86   function stopSale() public {
87     require(msg.sender == wallet);
88     started = false;
89   }
90 
91   function setPrice(uint256 _price) public {
92     require(msg.sender == wallet);
93     price = _price;
94   }
95   function changeWallet(address _wallet) public {
96   	require (msg.sender == wallet);
97   	wallet = _wallet;
98   }
99 
100 
101   // fallback function can be used to buy tokens
102   function () payable public {
103     buyTokens(msg.sender);
104   }
105 
106   // low level token purchase function
107   function buyTokens(address beneficiary) payable public {
108     require(beneficiary != 0x0);
109     require(validPurchase());
110 
111     uint256 weiAmount = msg.value;
112 
113 
114     // calculate token amount to be sent
115     uint256 tokens = (weiAmount) * price;//weiamount * price 
116     // uint256 tokens = (weiAmount/10**(18-decimals)) * price;//weiamount * price 
117 
118     // update state
119     weiRaised = weiRaised.add(weiAmount);
120 
121     tokenReward.transfer(beneficiary, tokens);
122     emit TokenPurchase(msg.sender, beneficiary, weiAmount, tokens);
123     forwardFunds();
124   }
125 
126   // send ether to the fund collection wallet
127   // override to create custom fund forwarding mechanisms
128   function forwardFunds() internal {
129      wallet.transfer(msg.value);
130   }
131 
132   // @return true if the transaction can buy tokens
133   function validPurchase() internal constant returns (bool) {
134     bool withinPeriod = started;
135     bool nonZeroPurchase = msg.value != 0;
136     return withinPeriod && nonZeroPurchase;
137   }
138 
139   function withdrawTokens(uint256 _amount) public {
140     require (msg.sender == wallet);
141     tokenReward.transfer(wallet,_amount);
142   }
143 }