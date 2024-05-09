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
98         if (purchasedAt == 0 || purchasedAt > now) {
99             throw;
100         }
101 
102         if(totalEarlyPurchaseRaised + amount >= WEI_MAXIMUM_EARLYPURCHASE){
103            purchaser.send(totalEarlyPurchaseRaised + amount - WEI_MAXIMUM_EARLYPURCHASE);
104            earlyPurchases.push(EarlyPurchase(purchaser, WEI_MAXIMUM_EARLYPURCHASE - totalEarlyPurchaseRaised, purchasedAt));
105            totalEarlyPurchaseRaised += WEI_MAXIMUM_EARLYPURCHASE - totalEarlyPurchaseRaised;
106         }
107         else{
108            earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
109            totalEarlyPurchaseRaised += amount;
110         }
111 
112         if(totalEarlyPurchaseRaised >= WEI_MAXIMUM_EARLYPURCHASE){
113             closeEarlyPurchase();
114         }
115         return true;
116     }
117 
118     /// @dev Close early purchase term
119     function closeEarlyPurchase()
120         onlyOwner
121         returns (bool)
122     {
123         earlyPurchaseClosedAt = now;
124     }
125 
126     /// @dev Setup function sets external crowdsale contract's address
127     /// @param sycCrowdsaleAddress Token address
128     function setup(address sycCrowdsaleAddress)
129         external
130         onlyOwner
131         returns (bool)
132     {
133         if (address(sycCrowdsale) == 0) {
134             sycCrowdsale = AbstractSYCCrowdsale(sycCrowdsaleAddress);
135             return true;
136         }
137         return false;
138     }
139 
140     function withdraw(uint withdrawalAmount) onlyOwner {
141           if(!owner.send(withdrawalAmount)) throw;  // send collected ETH to SynchroLife team
142     }
143 
144     function withdrawAll() onlyOwner {
145           if(!owner.send(this.balance)) throw;  // send all collected ETH to SynchroLife team
146     }
147 
148     function transferOwnership(address newOwner) onlyOwner {
149         owner = newOwner;
150     }
151 
152     /// @dev By sending Ether to the contract, early purchase will be recorded.
153     function () payable{
154         require(msg.value >= WEI_MINIMUM_PURCHASE);
155         appendEarlyPurchase(msg.sender, msg.value, block.timestamp);
156     }
157 }