1 pragma solidity ^0.4.18;
2 
3 
4 contract ExternalCurrencyPrice {
5     struct CurrencyValue {
6         uint64 value;
7         uint8 decimals;
8     }
9 
10     struct Transaction {
11         string currency;
12         uint64 value;
13         string transactionId;
14         uint64 price;
15         uint8  decimals;
16     }
17 
18     struct RefundTransaction {
19         uint sourceTransaction;
20         uint88 refundAmount;
21     }
22 
23     mapping(string => CurrencyValue) prices;
24 
25     Transaction[] public transactions;
26     RefundTransaction[] public refundTransactions;
27 
28     address owner;
29 
30     event NewTransaction(string currency, uint64 value, string transactionId,
31                                                             uint64 price, uint8 decimals);
32     event NewRefundTransaction(uint sourceTransaction, uint88 refundAmount);
33     event PriceSet(string currency, uint64 value, uint8 decimals);
34 
35     modifier onlyAdministrator() {
36         require(tx.origin == owner);
37         _;
38     }
39 
40     function ExternalCurrencyPrice()
41         public
42     {
43         owner = tx.origin;
44     }
45 
46     //Example: 0.00007115 BTC will be setPrice("BTC", 7115, 8)
47     function setPrice(string currency, uint64 value, uint8 decimals)
48         public
49         onlyAdministrator
50     {
51         prices[currency].value = value;
52         prices[currency].decimals = decimals;
53         PriceSet(currency, value, decimals);
54     }
55 
56     function getPrice(string currency)
57         public
58         view
59         returns(uint64 value, uint8 decimals)
60     {
61         value = prices[currency].value;
62         decimals = prices[currency].decimals;
63     }
64 
65     //Value is returned with accuracy of 18 decimals (same as token)
66     //Example: to calculate value of 1 BTC call
67     // should look like calculateAmount("BTC", 100000000)
68     // See setPrice example (8 decimals)
69     function calculateAmount(string currency, uint64 value)
70         public
71         view
72         returns (uint88 amount)
73     {
74         require(prices[currency].value > 0);
75         require(value >= prices[currency].value);
76 
77         amount = uint88( ( uint(value) * ( 10**18 ) ) / prices[currency].value );
78     }
79 
80     function calculatePrice(string currency, uint88 amount)
81         public
82         view
83         returns (uint64 price)
84     {
85         require(prices[currency].value > 0);
86 
87         price = uint64( amount * prices[currency].value );
88     }
89 
90     function addTransaction(string currency, uint64 value, string transactionId)
91         public
92         onlyAdministrator
93         returns (uint newTransactionId)
94     {
95         require(prices[currency].value > 0);
96 
97         newTransactionId = transactions.length;
98 
99         Transaction memory transaction;
100 
101         transaction.currency = currency;
102         transaction.value = value;
103         transaction.decimals = prices[currency].decimals;
104         transaction.price = prices[currency].value;
105         transaction.transactionId = transactionId;
106 
107         transactions.push(transaction);
108 
109         NewTransaction(transaction.currency, transaction.value, transaction.transactionId,
110             transaction.price, transaction.decimals);
111     }
112 
113     function getNumTransactions()
114         public
115         constant
116         returns(uint length)
117     {
118         length = transactions.length;
119     }
120 
121     function addRefundTransaction(uint sourceTransaction, uint88 refundAmount)
122         public
123         onlyAdministrator
124         returns (uint newTransactionId)
125     {
126         require(sourceTransaction < transactions.length);
127 
128         newTransactionId = refundTransactions.length;
129 
130         RefundTransaction memory transaction;
131 
132         transaction.sourceTransaction = sourceTransaction;
133         transaction.refundAmount = refundAmount;
134 
135         refundTransactions.push(transaction);
136 
137         NewRefundTransaction(transaction.sourceTransaction, transaction.refundAmount);
138     }
139 
140     function getNumRefundTransactions()
141         public
142         constant
143         returns(uint length)
144     {
145         length = refundTransactions.length;
146     }
147 }