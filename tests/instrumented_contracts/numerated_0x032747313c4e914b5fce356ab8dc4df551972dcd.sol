1 //
2 // This file is part of TrustEth.
3 // Copyright (c) 2016 Jacob Dawid <jacob@omg-it.works>
4 //
5 // TrustEth is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU Affero General Public License as
7 // published by the Free Software Foundation, either version 3 of the
8 // License, or (at your option) any later version.
9 //
10 // TrustEth is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU Affero General Public License for more details.
14 //
15 // You should have received a copy of the GNU Affero General Public
16 // License along with TrustEth.
17 // If not, see <http://www.gnu.org/licenses/>.
18 //
19 
20 contract TrustEth {
21     // A registered transaction initiated by the seller.
22     struct Transaction {
23       // Supplied by the seller (Step 1).
24       uint sellerId; // The seller id of the seller who initiated this transaction and is about to receive the payment.
25       uint amount; // The amount to pay to the seller for this transaction.
26 
27       // Filled out by the contract when transaction has been paid (Step 2).
28       address paidWithAddress; // The address of the buyer issueing the payment.
29       bool paid; // Flag that states this transaction has already been paid.
30    
31       // Rating supplied by the buyer (Step 3, optional).
32       uint ratingValue; // Seller rating supplied by buyer.
33       string ratingComment; // Comment on this transaction supplied by the buyer.
34       bool rated; // Flag that states this transaction has already been rated.
35     }
36 
37     // A registered seller on this contract.
38     // Registered sellers can put up transactions and can be rated
39     // by those who paid the transactions.
40     struct Seller {
41       // Seller information
42       address etherAddress; // The sellers ether address.
43       uint[] ratingIds; // The ids of the rating linked with this seller.
44       uint[] transactionIds; // The ids of transactions linked with this seller.
45       
46       // Statistics about the seller
47       uint averageRating; // Average value of ratings.
48       uint transactionsPaid; // How many transactions have been paid?
49       uint transactionsRated; // How many transactions have been rated?
50     }
51 
52     Transaction[] public transactions; // All transactions.
53     Seller[] public sellers; // All sellers
54 
55     // This mapping makes it easier to loopkup the seller that belongs to a certain address.
56     mapping (address => uint) sellerLookup;
57 
58     // The sole contract owner.
59     address public owner;
60 
61     // Configured fees.
62     uint public registrationFee;
63     uint public transactionFee;
64 
65     // Only owner administration flag.
66     modifier onlyowner { if (msg.sender == owner) _ }
67 
68     // Administrative functions.
69     function TrustEth() {
70       owner = msg.sender;
71       
72       // Index 0 is a marker for invalid ids.
73       sellers.length = 1;
74       transactions.length = 1;
75 
76       // Initialize fees.
77       registrationFee = 1 ether;
78       transactionFee = 50 finney;
79     }
80 
81     function retrieveFunds() onlyowner {
82       owner.send(this.balance);
83     }
84 
85     function adjustRegistrationFee(uint fee) onlyowner {
86       registrationFee = fee;
87     }
88 
89     function adjustTransactionFee(uint fee) onlyowner {
90       transactionFee = fee;
91     }
92 
93     function setOwner(address _owner) onlyowner {
94       owner = _owner;
95     }
96 
97     // Fallback function, do not accepts payments made directly to this contract address.
98     function() {
99       throw;
100     }
101 
102     // Make a donation and acknowledge our development efforts. Thank you!
103     function donate() {
104       // That's awesome. Thank you.
105       return;
106     }
107 
108     // Register your seller address for a small fee to prevent flooding and
109     // and recurring address recreation.
110     function register() {
111       // Retrieve the amount of ethers that have been sent along.
112       uint etherPaid = msg.value;
113       
114       if(etherPaid < registrationFee) { throw; }
115 
116       // Create a new seller.
117       uint sellerId = sellers.length;
118       sellers.length += 1;
119 
120       // Store seller details and bind to address.
121       sellers[sellerId].etherAddress = msg.sender;
122       sellers[sellerId].averageRating = 0;
123 
124       // Save sellerId in lookup mapping.
125       sellerLookup[msg.sender] = sellerId;
126     }
127 
128 
129     // Workflow
130 
131     // As a seller, put up a transaction.
132     function askForEther(uint amount) {
133       // Lookup the seller.
134       uint sellerId = sellerLookup[msg.sender];
135 
136       // Check whether the seller is a registered seller.
137       if(sellerId == 0) { throw; }
138       
139       // Create a new invoice.
140       uint transactionId = transactions.length;
141       transactions.length += 1;
142 
143       // Fill out seller info.
144       transactions[transactionId].sellerId = sellerId;
145       transactions[transactionId].amount = amount;
146 
147       // -> Pass transactionId to customer now.
148     }
149 
150     // As a buyer, pay a transaction.
151     function payEther(uint transactionId) {
152       // Bail out in case the transaction id is invalid.      
153       if(transactionId < 1 || transactionId >= transactions.length) { throw; }
154 
155       // Retrieve the amount of ethers that have been sent along.
156       uint etherPaid = msg.value;
157       uint etherAskedFor = transactions[transactionId].amount;
158       uint etherNeeded = etherAskedFor + transactionFee;
159 
160       // If the amount of ethers does not suffice to pay, bail out :(      
161       if(etherPaid < etherNeeded) { throw; }
162 
163       // Calculate how much has been overpaid.
164       uint payback = etherPaid - etherNeeded;
165       // ..and kindly return the payback :)
166       msg.sender.send(payback);
167 
168       // Now take the remaining amount and send to the seller.
169       sellers[transactions[transactionId].sellerId].etherAddress.send(etherAskedFor);
170       // Rise transactions paid counter.
171       sellers[transactions[transactionId].sellerId].transactionsPaid += 1;
172 
173       // Overpaid ethers send back, seller has been paid, now we're done.
174       // Mark the transaction as finished.
175 
176       // Flag the invoice as paid.
177       transactions[transactionId].paid = true;
178       // Save the payers address so he is eligible to rate.
179       transactions[transactionId].paidWithAddress = msg.sender;
180     
181       // -> Now the transaction can be rated by the address that has paid it.
182     }
183 
184     // As a buyer, rate a transaction.
185     function rate(uint transactionId, uint ratingValue, string ratingComment) {
186       // Only the address that has paid the transaction may rate it.
187       if(transactions[transactionId].paidWithAddress != msg.sender) { throw; }
188       // Bail out in case the transaction id is invalid.        
189       if(transactionId < 1 || transactionId >= transactions.length) { throw; }
190       // Oops, transaction has already been rated!
191       if(transactions[transactionId].rated) { throw; }
192       // Oops, transaction has not been paid yet and cannot be rated!
193       if(!transactions[transactionId].paid) { throw; }
194       // Rating range is from 1 (incl.) to 10 (incl.).
195       if(ratingValue < 1 || ratingValue > 10) { throw; }
196 
197       transactions[transactionId].ratingValue = ratingValue;
198       transactions[transactionId].ratingComment = ratingComment;
199       transactions[transactionId].rated = true;
200       
201       uint previousTransactionCount = sellers[transactions[transactionId].sellerId].transactionsRated;
202       uint previousTransactionRatingSum = sellers[transactions[transactionId].sellerId].averageRating * previousTransactionCount;
203 
204       sellers[transactions[transactionId].sellerId].averageRating = (previousTransactionRatingSum + ratingValue) / (previousTransactionCount + 1);
205       sellers[transactions[transactionId].sellerId].transactionsRated += 1;
206     }
207 }