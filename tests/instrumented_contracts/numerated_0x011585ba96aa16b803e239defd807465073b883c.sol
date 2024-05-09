1 pragma solidity ^0.4.7;
2 
3 /// @title EarlyPurchase contract - Keep track of purchased amount by Early Purchasers
4 /// Project by SynchroLife Team (https://synchrolife.org)
5 /// This smart contract developed by Starbase - Token funding & payment Platform for innovative projects <support[at]starbase.co>
6 
7 contract SYCEarlyPurchase {
8     /*
9      *  Properties
10      */
11     string public constant PURCHASE_AMOUNT_UNIT = 'ETH';    // Ether
12     uint public constant WEI_MINIMUM_PURCHASE = 40 * 10 ** 18;
13     uint public constant WEI_MAXIMUM_EARLYPURCHASE = 7000 * 10 ** 18;
14     address public owner;
15     EarlyPurchase[] public earlyPurchases;
16     uint public earlyPurchaseClosedAt;
17     uint public totalEarlyPurchaseRaised;
18     address public sycCrowdsale;
19 
20 
21     /*
22      *  Types
23      */
24     struct EarlyPurchase {
25         address purchaser;
26         uint amount;        // Amount in Wei( = 1/ 10^18 Ether)
27         uint purchasedAt;   // timestamp
28     }
29 
30     /*
31      *  Modifiers
32      */
33     modifier onlyOwner() {
34         if (msg.sender != owner) {
35             throw;
36         }
37         _;
38     }
39 
40     modifier onlyEarlyPurchaseTerm() {
41         if (earlyPurchaseClosedAt > 0) {
42             throw;
43         }
44         _;
45     }
46 
47     /// @dev Contract constructor function
48     function SYCEarlyPurchase() {
49         owner = msg.sender;
50     }
51 
52     /*
53      *  Contract functions
54      */
55     /// @dev Returns early purchased amount by purchaser's address
56     /// @param purchaser Purchaser address
57     function purchasedAmountBy(address purchaser)
58         external
59         constant
60         returns (uint amount)
61     {
62         for (uint i; i < earlyPurchases.length; i++) {
63             if (earlyPurchases[i].purchaser == purchaser) {
64                 amount += earlyPurchases[i].amount;
65             }
66         }
67     }
68 
69     /// @dev Setup function sets external contracts' addresses.
70     /// @param _sycCrowdsale SYC token crowdsale address.
71     function setup(address _sycCrowdsale)
72         external
73         onlyOwner
74         returns (bool)
75     {
76         if (address(_sycCrowdsale) == 0) {
77             sycCrowdsale = _sycCrowdsale;
78             return true;
79         }
80         return false;
81     }
82 
83     /// @dev Returns number of early purchases
84     function numberOfEarlyPurchases()
85         external
86         constant
87         returns (uint)
88     {
89         return earlyPurchases.length;
90     }
91 
92     /// @dev Append an early purchase log
93     /// @param purchaser Purchaser address
94     /// @param amount Purchase amount
95     /// @param purchasedAt Timestamp of purchased date
96     function appendEarlyPurchase(address purchaser, uint amount, uint purchasedAt)
97         internal
98         onlyEarlyPurchaseTerm
99         returns (bool)
100     {
101         if (purchasedAt == 0 || purchasedAt > now) {
102             throw;
103         }
104 
105         if(totalEarlyPurchaseRaised + amount >= WEI_MAXIMUM_EARLYPURCHASE){
106            purchaser.send(totalEarlyPurchaseRaised + amount - WEI_MAXIMUM_EARLYPURCHASE);
107            earlyPurchases.push(EarlyPurchase(purchaser, WEI_MAXIMUM_EARLYPURCHASE - totalEarlyPurchaseRaised, purchasedAt));
108            totalEarlyPurchaseRaised += WEI_MAXIMUM_EARLYPURCHASE - totalEarlyPurchaseRaised;
109         }
110         else{
111            earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
112            totalEarlyPurchaseRaised += amount;
113         }
114 
115         if(totalEarlyPurchaseRaised >= WEI_MAXIMUM_EARLYPURCHASE){
116             earlyPurchaseClosedAt = now;
117         }
118         return true;
119     }
120 
121     /// @dev Close early purchase term
122     function closeEarlyPurchase()
123         onlyOwner
124         returns (bool)
125     {
126         earlyPurchaseClosedAt = now;
127     }
128 
129     function withdraw(uint withdrawalAmount) onlyOwner {
130           if(!owner.send(withdrawalAmount)) throw;  // send collected ETH to SynchroLife team
131     }
132 
133     function withdrawAll() onlyOwner {
134           if(!owner.send(this.balance)) throw;  // send all collected ETH to SynchroLife team
135     }
136 
137     function transferOwnership(address newOwner) onlyOwner {
138         owner = newOwner;
139     }
140 
141     /// @dev By sending Ether to the contract, early purchase will be recorded.
142     function () payable{
143         require(msg.value >= WEI_MINIMUM_PURCHASE);
144         appendEarlyPurchase(msg.sender, msg.value, block.timestamp);
145     }
146 }