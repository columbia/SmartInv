1 contract AbstractStarbaseCrowdsale {
2     function startDate() constant returns (uint256 startDate) {}
3 }
4 
5 /// @title EarlyPurchase contract - Keep track of purchased amount by Early Purchasers
6 /// @author Starbase PTE. LTD. - <info@starbase.co>
7 contract StarbaseEarlyPurchase {
8     /*
9      *  Constants
10      */
11     string public constant PURCHASE_AMOUNT_UNIT = 'CNY';    // Chinese Yuan
12     string public constant PURCHASE_AMOUNT_RATE_REFERENCE = 'http://www.xe.com/currencytables/';
13     uint public constant PURCHASE_AMOUNT_CAP = 9000000;
14 
15     /*
16      *  Types
17      */
18     struct EarlyPurchase {
19         address purchaser;
20         uint amount;        // CNY based amount
21         uint purchasedAt;   // timestamp
22     }
23 
24     /*
25      *  External contracts
26      */
27     AbstractStarbaseCrowdsale public starbaseCrowdsale;
28 
29     /*
30      *  Storage
31      */
32     address public owner;
33     EarlyPurchase[] public earlyPurchases;
34     uint public earlyPurchaseClosedAt;
35 
36     /*
37      *  Modifiers
38      */
39     modifier noEther() {
40         if (msg.value > 0) {
41             throw;
42         }
43         _;
44     }
45 
46     modifier onlyOwner() {
47         if (msg.sender != owner) {
48             throw;
49         }
50         _;
51     }
52 
53     modifier onlyBeforeCrowdsale() {
54         if (address(starbaseCrowdsale) != 0 &&
55             starbaseCrowdsale.startDate() > 0)
56         {
57             throw;
58         }
59         _;
60     }
61 
62     modifier onlyEarlyPurchaseTerm() {
63         if (earlyPurchaseClosedAt > 0) {
64             throw;
65         }
66         _;
67     }
68 
69     /*
70      *  Contract functions
71      */
72     /// @dev Returns early purchased amount by purchaser's address
73     /// @param purchaser Purchaser address
74     function purchasedAmountBy(address purchaser)
75         external
76         constant
77         noEther
78         returns (uint amount)
79     {
80         for (uint i; i < earlyPurchases.length; i++) {
81             if (earlyPurchases[i].purchaser == purchaser) {
82                 amount += earlyPurchases[i].amount;
83             }
84         }
85     }
86 
87     /// @dev Returns total amount of raised funds by Early Purchasers
88     function totalAmountOfEarlyPurchases()
89         constant
90         noEther
91         returns (uint totalAmount)
92     {
93         for (uint i; i < earlyPurchases.length; i++) {
94             totalAmount += earlyPurchases[i].amount;
95         }
96     }
97 
98     /// @dev Returns number of early purchases
99     function numberOfEarlyPurchases()
100         external
101         constant
102         noEther
103         returns (uint)
104     {
105         return earlyPurchases.length;
106     }
107 
108     /// @dev Append an early purchase log
109     /// @param purchaser Purchaser address
110     /// @param amount Purchase amount
111     /// @param purchasedAt Timestamp of purchased date
112     function appendEarlyPurchase(address purchaser, uint amount, uint purchasedAt)
113         external
114         noEther
115         onlyOwner
116         onlyBeforeCrowdsale
117         onlyEarlyPurchaseTerm
118         returns (bool)
119     {
120         if (amount == 0 ||
121             totalAmountOfEarlyPurchases() + amount > PURCHASE_AMOUNT_CAP)
122         {
123             return false;
124         }
125 
126         if (purchasedAt == 0 || purchasedAt > now) {
127             throw;
128         }
129 
130         earlyPurchases.push(EarlyPurchase(purchaser, amount, purchasedAt));
131         return true;
132     }
133 
134     /// @dev Close early purchase term
135     function closeEarlyPurchase()
136         external
137         noEther
138         onlyOwner
139         returns (bool)
140     {
141         earlyPurchaseClosedAt = now;
142     }
143 
144     /// @dev Setup function sets external contract's address
145     /// @param starbaseCrowdsaleAddress Token address
146     function setup(address starbaseCrowdsaleAddress)
147         external
148         noEther
149         onlyOwner
150         returns (bool)
151     {
152         if (address(starbaseCrowdsale) == 0) {
153             starbaseCrowdsale = AbstractStarbaseCrowdsale(starbaseCrowdsaleAddress);
154             return true;
155         }
156         return false;
157     }
158 
159     /// @dev Contract constructor function
160     function StarbaseEarlyPurchase() noEther {
161         owner = msg.sender;
162     }
163 
164     /// @dev Fallback function always fails
165     function () {
166         throw;
167     }
168 }