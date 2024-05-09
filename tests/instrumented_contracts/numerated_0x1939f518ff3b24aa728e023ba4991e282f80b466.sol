1 pragma solidity ^0.4.7;
2 
3 /// @title 2nd EarlyPurchase contract - Keep track of purchased amount by Early Purchasers
4 /// Project by SynchroLife Team (https://synchrolife.org)
5 /// This smart contract developed by Starbase - Token funding & payment Platform for innovative projects <support[at]starbase.co>
6 /// 1504526400  = Starting：9/4 12:00GMT
7 /// 1504785599 = Ending: 9/7 11:59GMT
8 /// now (uint): current block timestamp (alias for block.timestamp)
9 
10 contract SYC2ndEarlyPurchase {
11     /*
12      *  Properties
13      */
14     string public constant PURCHASE_AMOUNT_UNIT = 'ETH';    // Ether
15     uint public constant WEI_MINIMUM_PURCHASE = 10 * 10 ** 18;
16     uint public constant WEI_MAXIMUM_EARLYPURCHASE = 7000 * 10 ** 18;
17     uint public constant STARTING_TIME = 1504526400;
18     uint public constant ENDING_TIME = 1504785599;
19     address public owner;
20     EarlyPurchase[] public earlyPurchases;
21     uint public earlyPurchaseClosedAt;
22     uint public totalEarlyPurchaseRaised;
23     address public sycCrowdsale;
24 
25 
26     /*
27      *  Types
28      */
29     struct EarlyPurchase {
30         address purchaser;
31         uint amount;        // Amount in Wei( = 1/ 10^18 Ether)
32         uint purchasedAt;   // timestamp
33     }
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
45     modifier onlyEarlyPurchaseTerm() {
46         if (earlyPurchaseClosedAt > 0 || now < STARTING_TIME || now > ENDING_TIME) {
47             throw;
48         }
49         _;
50     }
51 
52     /// @dev Contract constructor function
53     function SYC2ndEarlyPurchase() {
54         owner = msg.sender;
55     }
56 
57     /*
58      *  Contract functions
59      */
60     /// @dev Returns early purchased amount by purchaser's address
61     /// @param purchaser Purchaser address
62     function purchasedAmountBy(address purchaser)
63         external
64         constant
65         returns (uint amount)
66     {
67         for (uint i; i < earlyPurchases.length; i++) {
68             if (earlyPurchases[i].purchaser == purchaser) {
69                 amount += earlyPurchases[i].amount;
70             }
71         }
72     }
73 
74     /// @dev Setup function sets external contracts' addresses.
75     /// @param _sycCrowdsale SYC token crowdsale address.
76     function setup(address _sycCrowdsale)
77         external
78         onlyOwner
79         returns (bool)
80     {
81         if (address(_sycCrowdsale) == 0) {
82             sycCrowdsale = _sycCrowdsale;
83             return true;
84         }
85         return false;
86     }
87 
88     /// @dev Returns number of early purchases
89     function numberOfEarlyPurchases()
90         external
91         constant
92         returns (uint)
93     {
94         return earlyPurchases.length;
95     }
96 
97     /// @dev Append an early purchase log
98     /// @param purchaser Purchaser address
99     /// @param amount Purchase amount
100     /// @param purchasedAt Timestamp of purchased date
101     function appendEarlyPurchase(address purchaser, uint amount, uint purchasedAt)
102         internal
103         onlyEarlyPurchaseTerm
104         returns (bool)
105     {
106         if (purchasedAt == 0 || purchasedAt > now) {
107             throw;
108         }
109 
110         if(totalEarlyPurchaseRaised + amount >= WEI_MAXIMUM_EARLYPURCHASE){
111            purchaser.send(totalEarlyPurchaseRaised + amount - WEI_MAXIMUM_EARLYPURCHASE);
112            earlyPurchases.push(EarlyPurchase(purchaser, WEI_MAXIMUM_EARLYPURCHASE - totalEarlyPurchaseRaised, purchasedAt));
113            totalEarlyPurchaseRaised += WEI_MAXIMUM_EARLYPURCHASE - totalEarlyPurchaseRaised;
114         }
115         else{
116            earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
117            totalEarlyPurchaseRaised += amount;
118         }
119 
120         if(totalEarlyPurchaseRaised >= WEI_MAXIMUM_EARLYPURCHASE || now >= ENDING_TIME){
121             earlyPurchaseClosedAt = now;
122         }
123         return true;
124     }
125 
126     /// @dev Close early purchase term
127     function closeEarlyPurchase()
128         onlyOwner
129         returns (bool)
130     {
131         earlyPurchaseClosedAt = now;
132     }
133 
134     function withdraw(uint withdrawalAmount) onlyOwner {
135           if(!owner.send(withdrawalAmount)) throw;  // send collected ETH to SynchroLife team
136     }
137 
138     function withdrawAll() onlyOwner {
139           if(!owner.send(this.balance)) throw;  // send all collected ETH to SynchroLife team
140     }
141 
142     function transferOwnership(address newOwner) onlyOwner {
143         owner = newOwner;
144     }
145 
146     /// @dev By sending Ether to the contract, early purchase will be recorded.
147     function () payable{
148         require(msg.value >= WEI_MINIMUM_PURCHASE);
149         appendEarlyPurchase(msg.sender, msg.value, now);
150     }
151 }