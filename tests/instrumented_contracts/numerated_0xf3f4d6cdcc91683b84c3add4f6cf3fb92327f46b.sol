1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) onlyOwner public {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 /**
46  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
47  *
48  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
49  */
50 
51 
52 
53 
54 /**
55  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
56  *
57  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
58  */
59 
60 
61 
62 /**
63  * Interface for defining crowdsale pricing.
64  */
65 contract PricingStrategy {
66 
67   address public tier;
68 
69   /** Interface declaration. */
70   function isPricingStrategy() public constant returns (bool) {
71     return true;
72   }
73 
74   /** Self check if all references are correctly set.
75    *
76    * Checks that pricing strategy matches crowdsale parameters.
77    */
78   function isSane(address crowdsale) public constant returns (bool) {
79     return true;
80   }
81 
82   /**
83    * @dev Pricing tells if this is a presale purchase or not.
84      @param purchaser Address of the purchaser
85      @return False by default, true if a presale purchaser
86    */
87   function isPresalePurchase(address purchaser) public constant returns (bool) {
88     return false;
89   }
90 
91   /* How many weis one token costs */
92   function updateRate(uint newOneTokenInWei) public;
93 
94   /**
95    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
96    *
97    *
98    * @param value - What is the value of the transaction send in as wei
99    * @param tokensSold - how much tokens have been sold this far
100    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
101    * @param msgSender - who is the investor of this transaction
102    * @param decimals - how many decimal units the token has
103    * @return Amount of tokens the investor receives
104    */
105   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
106 }
107 
108 /**
109  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
110  *
111  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
112  */
113 
114 
115 
116 /**
117  * Safe unsigned safe math.
118  *
119  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
120  *
121  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
122  *
123  * Maintained here until merged to mainline zeppelin-solidity.
124  *
125  */
126 library SafeMathLibExt {
127 
128   function times(uint a, uint b) returns (uint) {
129     uint c = a * b;
130     assert(a == 0 || c / a == b);
131     return c;
132   }
133 
134   function divides(uint a, uint b) returns (uint) {
135     assert(b > 0);
136     uint c = a / b;
137     assert(a == b * c + a % b);
138     return c;
139   }
140 
141   function minus(uint a, uint b) returns (uint) {
142     assert(b <= a);
143     return a - b;
144   }
145 
146   function plus(uint a, uint b) returns (uint) {
147     uint c = a + b;
148     assert(c>=a);
149     return c;
150   }
151 
152 }
153 
154 
155 
156 /**
157  * Fixed crowdsale pricing - everybody gets the same price.
158  */
159 contract FlatPricingExt is PricingStrategy, Ownable {
160   using SafeMathLibExt for uint;
161 
162   /* How many weis one token costs */
163   uint public oneTokenInWei;
164 
165   // Crowdsale rate has been changed
166   event RateChanged(uint newOneTokenInWei);
167 
168   modifier onlyTier() {
169     if (msg.sender != address(tier)) throw;
170     _;
171   }
172 
173   function setTier(address _tier) onlyOwner {
174     assert(_tier != address(0));
175     assert(tier == address(0));
176     tier = _tier;
177   }
178 
179   function FlatPricingExt(uint _oneTokenInWei) onlyOwner {
180     require(_oneTokenInWei > 0);
181     oneTokenInWei = _oneTokenInWei;
182   }
183 
184   function updateRate(uint newOneTokenInWei) onlyTier {
185     oneTokenInWei = newOneTokenInWei;
186     RateChanged(newOneTokenInWei);
187   }
188 
189   /**
190    * Calculate the current price for buy in amount.
191    *
192    */
193   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
194     uint multiplier = 10 ** decimals;
195     return value.times(multiplier) / oneTokenInWei;
196   }
197 
198 }