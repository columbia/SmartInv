1 /**
2  * Copyright 2017 Icofunding S.L. (https://icofunding.com)
3  * 
4  */
5 
6 /**
7  * Math operations with safety checks
8  * Reference: https://github.com/OpenZeppelin/zeppelin-solidity/commit/353285e5d96477b4abb86f7cde9187e84ed251ac
9  */
10 contract SafeMath {
11   function safeMul(uint a, uint b) internal constant returns (uint) {
12     uint c = a * b;
13 
14     assert(a == 0 || c / a == b);
15 
16     return c;
17   }
18 
19   function safeDiv(uint a, uint b) internal constant returns (uint) {    
20     uint c = a / b;
21 
22     return c;
23   }
24 
25   function safeSub(uint a, uint b) internal constant returns (uint) {
26     require(b <= a);
27 
28     return a - b;
29   }
30 
31   function safeAdd(uint a, uint b) internal constant returns (uint) {
32     uint c = a + b;
33 
34     assert(c>=a && c>=b);
35 
36     return c;
37   }
38 }
39 
40 contract MintInterface {
41   function mint(address recipient, uint amount) returns (bool success);
42 }
43 
44 // Interface
45 contract PriceModel {
46   function getPrice(uint block) constant returns (uint);
47 }
48 
49 contract EtherReceiverInterface {
50   function receiveEther() public payable;
51 }
52 
53 /**
54  * Crowdsale contract. Defines the minting process in exchange of ether
55  */
56 contract CrowdsaleTokens is SafeMath {
57 
58   address public tokenContract; // address of the token
59   address public priceModel; // address of the contract with the prices
60   address public vaultAddress; // address that will receive the ether collected
61 
62   // blocks
63   uint public crowdsaleStarts; // block in which the ICO starts
64   uint public crowdsaleEnds; // block in which the ICO ends
65 
66   // wei
67   uint public totalCollected; // amount of wei collected
68 
69   // tokens
70   uint public tokensIssued; // number of tokens (plus decimals) issued so far
71   uint public tokenCap; // maximum number of tokens to be issued
72 
73   modifier crowdsalePeriod() {
74     require(block.number >= crowdsaleStarts && block.number < crowdsaleEnds);
75 
76     _;
77   }
78 
79   function CrowdsaleTokens(
80     address _tokenContract,
81     address _priceModel,
82     address _vaultAddress,
83     uint _crowdsaleStarts,
84     uint _crowdsaleEnds,
85     uint _tokenCap
86   ) {
87     tokenContract = _tokenContract;
88     priceModel = _priceModel;
89     vaultAddress = _vaultAddress;
90     crowdsaleStarts = _crowdsaleStarts;
91     crowdsaleEnds = _crowdsaleEnds;
92     tokenCap = _tokenCap;
93   }
94 
95   // Same as buy()
96   function() payable {
97     buy();
98   }
99 
100   // Allows anyone to buy tokens in exchange of ether.
101   // Only executed after "crowdsaleStarts" and before "crowdsaleEnds"
102   function buy() public payable crowdsalePeriod {
103     // Calculate price
104     uint price = calculatePrice(block.number);
105 
106     // Process purchase
107     processPurchase(price);
108   }
109 
110   // Manages the purchase of the tokens for a given price.
111   // The maximum amount of tokens that can be purchased is given by the "remaining" function
112   function processPurchase(uint price) private {
113     // number of the tokens to be purchased  for the given price and ether sent
114     uint numTokens = safeDiv(safeMul(msg.value, price), 1 ether);
115 
116     // token cap
117     assert(numTokens <= remaining() && remaining() > 0);
118 
119     // update variables
120     totalCollected = safeAdd(totalCollected, msg.value);
121     tokensIssued = safeAdd(tokensIssued, numTokens);
122 
123     // send the ether to a trusted wallet
124     EtherReceiverInterface(vaultAddress).receiveEther.value(msg.value)();
125 
126     // mint tokens
127     if (!MintInterface(tokenContract).mint(msg.sender, numTokens))
128       revert();
129   }
130 
131   // Returns the number of tokens to be purchased by 1 ether at the given block
132   function calculatePrice(uint block) public constant returns (uint) {
133     return PriceModel(priceModel).getPrice(block);
134   }
135 
136   // Returns the number of tokens available for sale
137   function remaining() public constant returns (uint) {
138 
139     return safeSub(tokenCap, tokensIssued);
140   }
141 }