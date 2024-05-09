1 pragma solidity ^0.4.11;
2 
3 contract Ownable {
4   address public owner;
5 
6 
7   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
8 
9 
10   /**
11    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
12    * account.
13    */
14   function Ownable() {
15     owner = msg.sender;
16   }
17 
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27 
28   /**
29    * @dev Allows the current owner to transfer control of the contract to a newOwner.
30    * @param newOwner The address to transfer ownership to.
31    */
32   function transferOwnership(address newOwner) onlyOwner public {
33     require(newOwner != address(0));
34     OwnershipTransferred(owner, newOwner);
35     owner = newOwner;
36   }
37 
38 }
39 /**
40  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
41  *
42  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
43  */
44 
45 
46 
47 
48 /**
49  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
50  *
51  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
52  */
53 
54 
55 
56 /**
57  * Interface for defining crowdsale pricing.
58  */
59 contract PricingStrategy {
60 
61   address public tier;
62 
63   /** Interface declaration. */
64   function isPricingStrategy() public constant returns (bool) {
65     return true;
66   }
67 
68   /** Self check if all references are correctly set.
69    *
70    * Checks that pricing strategy matches crowdsale parameters.
71    */
72   function isSane(address crowdsale) public constant returns (bool) {
73     return true;
74   }
75 
76   /**
77    * @dev Pricing tells if this is a presale purchase or not.
78      @param purchaser Address of the purchaser
79      @return False by default, true if a presale purchaser
80    */
81   function isPresalePurchase(address purchaser) public constant returns (bool) {
82     return false;
83   }
84 
85   /* How many weis one token costs */
86   function updateRate(uint newOneTokenInWei) public;
87 
88   /**
89    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
90    *
91    *
92    * @param value - What is the value of the transaction send in as wei
93    * @param tokensSold - how much tokens have been sold this far
94    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
95    * @param msgSender - who is the investor of this transaction
96    * @param decimals - how many decimal units the token has
97    * @return Amount of tokens the investor receives
98    */
99   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
100 }
101 
102 /**
103  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
104  *
105  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
106  */
107 
108 
109 
110 /**
111  * Safe unsigned safe math.
112  *
113  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
114  *
115  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
116  *
117  * Maintained here until merged to mainline zeppelin-solidity.
118  *
119  */
120 library SafeMathLibExt {
121 
122   function times(uint a, uint b) returns (uint) {
123     uint c = a * b;
124     assert(a == 0 || c / a == b);
125     return c;
126   }
127 
128   function divides(uint a, uint b) returns (uint) {
129     assert(b > 0);
130     uint c = a / b;
131     assert(a == b * c + a % b);
132     return c;
133   }
134 
135   function minus(uint a, uint b) returns (uint) {
136     assert(b <= a);
137     return a - b;
138   }
139 
140   function plus(uint a, uint b) returns (uint) {
141     uint c = a + b;
142     assert(c>=a);
143     return c;
144   }
145 
146 }
147 
148 
149 
150 /**
151  * Fixed crowdsale pricing - everybody gets the same price.
152  */
153 contract FlatPricingExt is PricingStrategy, Ownable {
154   using SafeMathLibExt for uint;
155 
156   /* How many weis one token costs */
157   uint public oneTokenInWei;
158 
159   // Crowdsale rate has been changed
160   event RateChanged(uint newOneTokenInWei);
161 
162   modifier onlyTier() {
163     if (msg.sender != address(tier)) throw;
164     _;
165   }
166 
167   function setTier(address _tier) onlyOwner {
168     assert(_tier != address(0));
169     assert(tier == address(0));
170     tier = _tier;
171   }
172 
173   function FlatPricingExt(uint _oneTokenInWei) onlyOwner {
174     require(_oneTokenInWei > 0);
175     oneTokenInWei = _oneTokenInWei;
176   }
177 
178   function updateRate(uint newOneTokenInWei) onlyTier {
179     oneTokenInWei = newOneTokenInWei;
180     RateChanged(newOneTokenInWei);
181   }
182 
183   /**
184    * Calculate the current price for buy in amount.
185    *
186    */
187   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
188     uint multiplier = 10 ** decimals;
189     return value.times(multiplier) / oneTokenInWei;
190   }
191 
192 }