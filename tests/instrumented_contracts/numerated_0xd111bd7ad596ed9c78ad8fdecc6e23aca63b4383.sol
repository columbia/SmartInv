1 pragma solidity ^0.4.7;
2 
3 contract AbstractZENOSCrowdsale {
4     function crowdsaleStartingBlock() constant returns (uint256 startingBlock) {}
5 }
6 
7 /// @title EarlyPurchase contract - Keep track of purchased amount by Early Purchasers
8 /// Project by ZENOS Team (http://www.thezenos.com/)
9 /// This smart contract developed by Starbase - Token funding & payment Platform for innovative projects <support[at]starbase.co>
10 
11 contract ZENOSEarlyPurchase {
12     /*
13      *  Properties
14      */
15     string public constant PURCHASE_AMOUNT_UNIT = 'ETH';    // Ether
16     address public owner;
17     EarlyPurchase[] public earlyPurchases;
18     uint public earlyPurchaseClosedAt;
19 
20     /*
21      *  Types
22      */
23     struct EarlyPurchase {
24         address purchaser;
25         uint amount;        // Amount in Wei( = 1/ 10^18 Ether)
26         uint purchasedAt;   // timestamp
27     }
28 
29     /*
30      *  External contracts
31      */
32     AbstractZENOSCrowdsale public zenOSCrowdsale;
33 
34 
35     /*
36      *  Modifiers
37      */
38     modifier onlyOwner() {
39         if (msg.sender != owner) {
40             throw;
41         }
42         _;
43     }
44 
45     modifier onlyBeforeCrowdsale() {
46         if (address(zenOSCrowdsale) != 0 &&
47             zenOSCrowdsale.crowdsaleStartingBlock() > 0)
48         {
49             throw;
50         }
51         _;
52     }
53 
54     modifier onlyEarlyPurchaseTerm() {
55         if (earlyPurchaseClosedAt > 0) {
56             throw;
57         }
58         _;
59     }
60 
61     /// @dev Contract constructor function
62     function ZENOSEarlyPurchase() {
63         owner = msg.sender;
64     }
65 
66     /*
67      *  Contract functions
68      */
69     /// @dev Returns early purchased amount by purchaser's address
70     /// @param purchaser Purchaser address
71     function purchasedAmountBy(address purchaser)
72         external
73         constant
74         returns (uint amount)
75     {
76         for (uint i; i < earlyPurchases.length; i++) {
77             if (earlyPurchases[i].purchaser == purchaser) {
78                 amount += earlyPurchases[i].amount;
79             }
80         }
81     }
82 
83     /// @dev Returns total amount of raised funds by Early Purchasers
84     function totalAmountOfEarlyPurchases()
85         constant
86         returns (uint totalAmount)
87     {
88         for (uint i; i < earlyPurchases.length; i++) {
89             totalAmount += earlyPurchases[i].amount;
90         }
91     }
92 
93     /// @dev Returns number of early purchases
94     function numberOfEarlyPurchases()
95         external
96         constant
97         returns (uint)
98     {
99         return earlyPurchases.length;
100     }
101 
102     /// @dev Append an early purchase log
103     /// @param purchaser Purchaser address
104     /// @param amount Purchase amount
105     /// @param purchasedAt Timestamp of purchased date
106     function appendEarlyPurchase(address purchaser, uint amount, uint purchasedAt)
107         internal
108         onlyBeforeCrowdsale
109         onlyEarlyPurchaseTerm
110         returns (bool)
111     {
112 
113         if (purchasedAt == 0 || purchasedAt > now) {
114             throw;
115         }
116 
117         earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
118         return true;
119     }
120 
121     /// @dev Close early purchase term
122     function closeEarlyPurchase()
123         external
124         onlyOwner
125         returns (bool)
126     {
127         earlyPurchaseClosedAt = now;
128     }
129 
130     /// @dev Setup function sets external crowdsale contract's address
131     /// @param zenOSCrowdsaleAddress Token address
132     function setup(address zenOSCrowdsaleAddress)
133         external
134         onlyOwner
135         returns (bool)
136     {
137         if (address(zenOSCrowdsale) == 0) {
138             zenOSCrowdsale = AbstractZENOSCrowdsale(zenOSCrowdsaleAddress);
139             return true;
140         }
141         return false;
142     }
143 
144     function withdraw(uint withdrawalAmount) onlyOwner {
145           if(!owner.send(withdrawalAmount)) throw;  // send collected ETH to ZENOS team
146     }
147 
148     function transferOwnership(address newOwner) onlyOwner {
149         owner = newOwner;
150     }
151 
152     /// @dev By sending Ether to the contract, early purchase will be recorded.
153     function () payable {
154         appendEarlyPurchase(msg.sender, msg.value, block.timestamp);
155     }
156 }