1 pragma solidity ^0.4.7;
2 
3 contract AbstractSYCCrowdsale {
4 }
5 
6 /// @title EarlyPurchase contract - Keep track of purchased amount by Early Purchasers
7 /// Project by SynchroLife Team (https://synchrolife.org)
8 /// This smart contract developed by Starbase - Token funding & payment Platform for innovative projects <support[at]starbase.co>
9 
10 contract SYCEarlyPurchase {
11     /*
12      *  Properties
13      */
14     string public constant PURCHASE_AMOUNT_UNIT = 'ETH';    // Ether
15     uint public constant WEI_MINIMUM_PURCHASE = 1 * 10 ** 18;
16     uint public constant WEI_MAXIMUM_EARLYPURCHASE = 2 * 10 ** 18;
17     address public owner;
18     EarlyPurchase[] public earlyPurchases;
19     uint public earlyPurchaseClosedAt;
20     uint public totalEarlyPurchaseRaised;
21 
22     /*
23      *  Types
24      */
25     struct EarlyPurchase {
26         address purchaser;
27         uint amount;        // Amount in Wei( = 1/ 10^18 Ether)
28         uint purchasedAt;   // timestamp
29     }
30 
31     /*
32      *  External contracts
33      */
34     AbstractSYCCrowdsale public sycCrowdsale;
35 
36 
37     /*
38      *  Modifiers
39      */
40     modifier onlyOwner() {
41         if (msg.sender != owner) {
42             throw;
43         }
44         _;
45     }
46 
47     modifier onlyEarlyPurchaseTerm() {
48         if (earlyPurchaseClosedAt > 0) {
49             throw;
50         }
51         _;
52     }
53 
54     /// @dev Contract constructor function
55     function SYCEarlyPurchase() {
56         owner = msg.sender;
57     }
58 
59     /*
60      *  Contract functions
61      */
62     /// @dev Returns early purchased amount by purchaser's address
63     /// @param purchaser Purchaser address
64     function purchasedAmountBy(address purchaser)
65         external
66         constant
67         returns (uint amount)
68     {
69         for (uint i; i < earlyPurchases.length; i++) {
70             if (earlyPurchases[i].purchaser == purchaser) {
71                 amount += earlyPurchases[i].amount;
72             }
73         }
74     }
75 
76     /// @dev Returns number of early purchases
77     function numberOfEarlyPurchases()
78         external
79         constant
80         returns (uint)
81     {
82         return earlyPurchases.length;
83     }
84 
85     /// @dev Append an early purchase log
86     /// @param purchaser Purchaser address
87     /// @param amount Purchase amount
88     /// @param purchasedAt Timestamp of purchased date
89     function appendEarlyPurchase(address purchaser, uint amount, uint purchasedAt)
90         internal
91         onlyEarlyPurchaseTerm
92         returns (bool)
93     {
94         if (purchasedAt == 0 || purchasedAt > now) {
95             throw;
96         }
97 
98         earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
99         if (purchasedAt == 0 || purchasedAt > now) {
100             throw;
101         }
102 
103         if(totalEarlyPurchaseRaised + amount >= WEI_MAXIMUM_EARLYPURCHASE){
104            purchaser.send(totalEarlyPurchaseRaised + amount - WEI_MAXIMUM_EARLYPURCHASE);
105            totalEarlyPurchaseRaised += WEI_MAXIMUM_EARLYPURCHASE - totalEarlyPurchaseRaised;
106         }
107         else{
108            totalEarlyPurchaseRaised += amount;
109         }
110         if(totalEarlyPurchaseRaised >= WEI_MAXIMUM_EARLYPURCHASE){
111             closeEarlyPurchase();
112         }
113         return true;
114     }
115 
116     /// @dev Close early purchase term
117     function closeEarlyPurchase()
118         onlyOwner
119         returns (bool)
120     {
121         earlyPurchaseClosedAt = now;
122     }
123 
124     /// @dev Setup function sets external crowdsale contract's address
125     /// @param sycCrowdsaleAddress Token address
126     function setup(address sycCrowdsaleAddress)
127         external
128         onlyOwner
129         returns (bool)
130     {
131         if (address(sycCrowdsale) == 0) {
132             sycCrowdsale = AbstractSYCCrowdsale(sycCrowdsaleAddress);
133             return true;
134         }
135         return false;
136     }
137 
138     function withdraw(uint withdrawalAmount) onlyOwner {
139           if(!owner.send(withdrawalAmount)) throw;  // send collected ETH to SynchroLife team
140     }
141 
142     function withdrawAll() onlyOwner {
143           if(!owner.send(this.balance)) throw;  // send all collected ETH to SynchroLife team
144     }
145 
146     function transferOwnership(address newOwner) onlyOwner {
147         owner = newOwner;
148     }
149 
150     /// @dev By sending Ether to the contract, early purchase will be recorded.
151     function () payable{
152         require(msg.value >= WEI_MINIMUM_PURCHASE);
153         appendEarlyPurchase(msg.sender, msg.value, block.timestamp);
154     }
155 }