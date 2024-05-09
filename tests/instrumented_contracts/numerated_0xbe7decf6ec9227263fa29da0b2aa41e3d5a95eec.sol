1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 pragma solidity ^0.4.15;
8 
9 
10 
11 /**
12  * @title SafeMath
13  * @dev Math operations with safety checks that throw on error
14  */
15 library SafeMath {
16   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17     if (a == 0) {
18       return 0;
19     }
20     uint256 c = a * b;
21     assert(c / a == b);
22     return c;
23   }
24 
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   function add(uint256 a, uint256 b) internal pure returns (uint256) {
38     uint256 c = a + b;
39     assert(c >= a);
40     return c;
41   }
42 }
43 
44 
45 /**
46  * @title Ownable
47  * @dev The Ownable contract has an owner address, and provides basic authorization control
48  * functions, this simplifies the implementation of "user permissions".
49  */
50 contract Ownable {
51   address public owner;
52 
53 
54   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55 
56 
57   /**
58    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
59    * account.
60    */
61   function Ownable() public {
62     owner = msg.sender;
63   }
64 
65 
66   /**
67    * @dev Throws if called by any account other than the owner.
68    */
69   modifier onlyOwner() {
70     require(msg.sender == owner);
71     _;
72   }
73 
74 
75   /**
76    * @dev Allows the current owner to transfer control of the contract to a newOwner.
77    * @param newOwner The address to transfer ownership to.
78    */
79   function transferOwnership(address newOwner) public onlyOwner {
80     require(newOwner != address(0));
81     OwnershipTransferred(owner, newOwner);
82     owner = newOwner;
83   }
84 
85 }
86 
87 
88 /**
89  * Interface for defining crowdsale pricing.
90  */
91 contract PricingStrategy is Ownable {
92 
93   /** Interface declaration. */
94   function isPricingStrategy() public constant returns (bool) {
95     return true;
96   }
97 
98   /** Self check if all references are correctly set.
99    *
100    * Checks that pricing strategy matches crowdsale parameters.
101    */
102   function isSane(address crowdsale) public constant returns (bool) {
103     return true;
104   }
105 
106   /**
107    * @dev Pricing tells if this is a presale purchase or not.
108      @param purchaser Address of the purchaser
109      @return False by default, true if a presale purchaser
110    */
111   function isPresalePurchase(address purchaser) public constant returns (bool) {
112     return false;
113   }
114 
115   /**
116    * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
117    *
118    *
119    * @param value - What is the value of the transaction send in as wei
120    * @param tokensSold - how much tokens have been sold this far
121    * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
122    * @param msgSender - who is the investor of this transaction
123    * @param decimals - how many decimal units the token has
124    * @return Amount of tokens the investor receives
125    */
126   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
127 }
128 
129 /**
130  * Fixed crowdsale pricing - everybody gets the same price.
131  */
132 contract FlatPricing is PricingStrategy {
133 
134   using SafeMath for uint;
135 
136   /* How many weis one token costs */
137   uint public oneTokenInWei;
138 
139   function FlatPricing(uint _oneTokenInWei) {
140     require(_oneTokenInWei > 0);
141     oneTokenInWei = _oneTokenInWei;
142   }
143 
144   function setOneTokenInWei(uint _oneTokenInWei) onlyOwner {
145     require(_oneTokenInWei > 0);
146     oneTokenInWei = _oneTokenInWei;
147   }
148 
149   /**
150    * Calculate the current price for buy in amount.
151    *
152    */
153   function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
154     uint multiplier = 10 ** decimals;
155     return value.mul(multiplier).div(oneTokenInWei);
156   }
157 
158 }