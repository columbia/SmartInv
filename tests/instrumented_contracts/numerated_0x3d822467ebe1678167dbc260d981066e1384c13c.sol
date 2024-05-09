1 // Created using Token Wizard https://github.com/poanetwork/token-wizard by POA Network 
2 pragma solidity ^0.4.11;
3 
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) onlyOwner public {
40     require(newOwner != address(0));
41     OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 /**
47  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
48  *
49  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
50  */
51 
52 
53 
54 
55 /**
56  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
57  *
58  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
59  */
60 
61 
62 
63 /**
64  * Interface for defining crowdsale pricing.
65  */
66 contract PricingStrategy {
67 
68   address public tier;
69 
70   /** Interface declaration. */
71   function isPricingStrategy() public constant returns (bool) {
72     return true;
73   }
74 
75   /** Self check if all references are correctly set.
76    *
77    * Checks that pricing strategy matches crowdsale parameters.
78    */
79   function isSane(address crowdsale) public constant returns (bool) {
80     return true;
81   }
82 
83   /**
84    * @dev Pricing tells if this is a presale purchase or not.
85      @param purchaser Address of the purchaser
86      @return False by default, true if a presale purchaser
87    */
88   function isPresalePurchase(address purchaser) public constant returns (bool) {
89     return false;
90   }
91 
92   /* How many weis one token costs */
93   function updateRate(uint newOneTokenInWei) public;
94 
95   /**
96    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
97    *
98    *
99    * @param value - What is the value of the transaction send in as wei
100    * @param tokensSold - how much tokens have been sold this far
101    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
102    * @param msgSender - who is the investor of this transaction
103    * @param decimals - how many decimal units the token has
104    * @return Amount of tokens the investor receives
105    */
106   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
107 }
108 
109 /**
110  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
111  *
112  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
113  */
114 
115 
116 
117 /**
118  * Safe unsigned safe math.
119  *
120  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
121  *
122  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
123  *
124  * Maintained here until merged to mainline zeppelin-solidity.
125  *
126  */
127 library SafeMathLibExt {
128 
129   function times(uint a, uint b) returns (uint) {
130     uint c = a * b;
131     assert(a == 0 || c / a == b);
132     return c;
133   }
134 
135   function divides(uint a, uint b) returns (uint) {
136     assert(b > 0);
137     uint c = a / b;
138     assert(a == b * c + a % b);
139     return c;
140   }
141 
142   function minus(uint a, uint b) returns (uint) {
143     assert(b <= a);
144     return a - b;
145   }
146 
147   function plus(uint a, uint b) returns (uint) {
148     uint c = a + b;
149     assert(c>=a);
150     return c;
151   }
152 
153 }
154 
155 
156 
157 /**
158  * Fixed crowdsale pricing - everybody gets the same price.
159  */
160 contract FlatPricingExt is PricingStrategy, Ownable {
161   using SafeMathLibExt for uint;
162 
163   /* How many weis one token costs */
164   uint public oneTokenInWei;
165 
166   // Crowdsale rate has been changed
167   event RateChanged(uint newOneTokenInWei);
168 
169   modifier onlyTier() {
170     if (msg.sender != address(tier)) throw;
171     _;
172   }
173 
174   function setTier(address _tier) onlyOwner {
175     assert(_tier != address(0));
176     assert(tier == address(0));
177     tier = _tier;
178   }
179 
180   function FlatPricingExt(uint _oneTokenInWei) onlyOwner {
181     require(_oneTokenInWei > 0);
182     oneTokenInWei = _oneTokenInWei;
183   }
184 
185   function updateRate(uint newOneTokenInWei) onlyTier {
186     oneTokenInWei = newOneTokenInWei;
187     RateChanged(newOneTokenInWei);
188   }
189 
190   /**
191    * Calculate the current price for buy in amount.
192    *
193    */
194   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
195     uint multiplier = 10 ** decimals;
196     return value.times(multiplier) / oneTokenInWei;
197   }
198 
199 }