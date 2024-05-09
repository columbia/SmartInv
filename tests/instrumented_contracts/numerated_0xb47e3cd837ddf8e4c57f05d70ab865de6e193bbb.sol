1 pragma solidity ^0.4.8;
2 contract CryptoPunksMarket {
3 
4     // You can use this hash to verify the image file containing all the punks
5     string public imageHash = "ac39af4793119ee46bbff351d8cb6b5f23da60222126add4268e261199a2921b";
6 
7     address owner;
8 
9     string public standard = 'CryptoPunks';
10     string public name;
11     string public symbol;
12     uint8 public decimals;
13     uint256 public totalSupply;
14 
15     uint public nextPunkIndexToAssign = 0;
16 
17     bool public allPunksAssigned = false;
18     uint public punksRemainingToAssign = 0;
19 
20     //mapping (address => uint) public addressToPunkIndex;
21     mapping (uint => address) public punkIndexToAddress;
22 
23     /* This creates an array with all balances */
24     mapping (address => uint256) public balanceOf;
25 
26     struct Offer {
27         bool isForSale;
28         uint punkIndex;
29         address seller;
30         uint minValue;          // in ether
31         address onlySellTo;     // specify to sell only to a specific person
32     }
33 
34     struct Bid {
35         bool hasBid;
36         uint punkIndex;
37         address bidder;
38         uint value;
39     }
40 
41     // A record of punks that are offered for sale at a specific minimum value, and perhaps to a specific person
42     mapping (uint => Offer) public punksOfferedForSale;
43 
44     // A record of the highest punk bid
45     mapping (uint => Bid) public punkBids;
46 
47     mapping (address => uint) public pendingWithdrawals;
48 
49     event Assign(address indexed to, uint256 punkIndex);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event PunkTransfer(address indexed from, address indexed to, uint256 punkIndex);
52     event PunkOffered(uint indexed punkIndex, uint minValue, address indexed toAddress);
53     event PunkBidEntered(uint indexed punkIndex, uint value, address indexed fromAddress);
54     event PunkBidWithdrawn(uint indexed punkIndex, uint value, address indexed fromAddress);
55     event PunkBought(uint indexed punkIndex, uint value, address indexed fromAddress, address indexed toAddress);
56     event PunkNoLongerForSale(uint indexed punkIndex);
57 
58     /* Initializes contract with initial supply tokens to the creator of the contract */
59     function CryptoPunksMarket() payable {
60         //        balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
61         owner = msg.sender;
62         totalSupply = 10000;                        // Update total supply
63         punksRemainingToAssign = totalSupply;
64         name = "CRYPTOPUNKS";                                   // Set the name for display purposes
65         symbol = "Ͼ";                               // Set the symbol for display purposes
66         decimals = 0;                                       // Amount of decimals for display purposes
67     }
68 
69     function setInitialOwner(address to, uint punkIndex) {
70         if (msg.sender != owner) throw;
71         if (allPunksAssigned) throw;
72         if (punkIndex >= 10000) throw;
73         if (punkIndexToAddress[punkIndex] != to) {
74             if (punkIndexToAddress[punkIndex] != 0x0) {
75                 balanceOf[punkIndexToAddress[punkIndex]]--;
76             } else {
77                 punksRemainingToAssign--;
78             }
79             punkIndexToAddress[punkIndex] = to;
80             balanceOf[to]++;
81             Assign(to, punkIndex);
82         }
83     }
84 
85     function setInitialOwners(address[] addresses, uint[] indices) {
86         if (msg.sender != owner) throw;
87         uint n = addresses.length;
88         for (uint i = 0; i < n; i++) {
89             setInitialOwner(addresses[i], indices[i]);
90         }
91     }
92 
93     function allInitialOwnersAssigned() {
94         if (msg.sender != owner) throw;
95         allPunksAssigned = true;
96     }
97 
98     function getPunk(uint punkIndex) {
99         if (!allPunksAssigned) throw;
100         if (punksRemainingToAssign == 0) throw;
101         if (punkIndexToAddress[punkIndex] != 0x0) throw;
102         if (punkIndex >= 10000) throw;
103         punkIndexToAddress[punkIndex] = msg.sender;
104         balanceOf[msg.sender]++;
105         punksRemainingToAssign--;
106         Assign(msg.sender, punkIndex);
107     }
108 
109     // Transfer ownership of a punk to another user without requiring payment
110     function transferPunk(address to, uint punkIndex) {
111         if (!allPunksAssigned) throw;
112         if (punkIndexToAddress[punkIndex] != msg.sender) throw;
113         if (punkIndex >= 10000) throw;
114         if (punksOfferedForSale[punkIndex].isForSale) {
115             punkNoLongerForSale(punkIndex);
116         }
117         punkIndexToAddress[punkIndex] = to;
118         balanceOf[msg.sender]--;
119         balanceOf[to]++;
120         Transfer(msg.sender, to, 1);
121         PunkTransfer(msg.sender, to, punkIndex);
122         // Check for the case where there is a bid from the new owner and refund it.
123         // Any other bid can stay in place.
124         Bid bid = punkBids[punkIndex];
125         if (bid.bidder == to) {
126             // Kill bid and refund value
127             pendingWithdrawals[to] += bid.value;
128             punkBids[punkIndex] = Bid(false, punkIndex, 0x0, 0);
129         }
130     }
131 
132     function punkNoLongerForSale(uint punkIndex) {
133         if (!allPunksAssigned) throw;
134         if (punkIndexToAddress[punkIndex] != msg.sender) throw;
135         if (punkIndex >= 10000) throw;
136         punksOfferedForSale[punkIndex] = Offer(false, punkIndex, msg.sender, 0, 0x0);
137         PunkNoLongerForSale(punkIndex);
138     }
139 
140     function offerPunkForSale(uint punkIndex, uint minSalePriceInWei) {
141         if (!allPunksAssigned) throw;
142         if (punkIndexToAddress[punkIndex] != msg.sender) throw;
143         if (punkIndex >= 10000) throw;
144         punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, 0x0);
145         PunkOffered(punkIndex, minSalePriceInWei, 0x0);
146     }
147 
148     function offerPunkForSaleToAddress(uint punkIndex, uint minSalePriceInWei, address toAddress) {
149         if (!allPunksAssigned) throw;
150         if (punkIndexToAddress[punkIndex] != msg.sender) throw;
151         if (punkIndex >= 10000) throw;
152         punksOfferedForSale[punkIndex] = Offer(true, punkIndex, msg.sender, minSalePriceInWei, toAddress);
153         PunkOffered(punkIndex, minSalePriceInWei, toAddress);
154     }
155 
156     function buyPunk(uint punkIndex) payable {
157         if (!allPunksAssigned) throw;
158         Offer offer = punksOfferedForSale[punkIndex];
159         if (punkIndex >= 10000) throw;
160         if (!offer.isForSale) throw;                // punk not actually for sale
161         if (offer.onlySellTo != 0x0 && offer.onlySellTo != msg.sender) throw;  // punk not supposed to be sold to this user
162         if (msg.value < offer.minValue) throw;      // Didn't send enough ETH
163         if (offer.seller != punkIndexToAddress[punkIndex]) throw; // Seller no longer owner of punk
164 
165         address seller = offer.seller;
166 
167         punkIndexToAddress[punkIndex] = msg.sender;
168         balanceOf[seller]--;
169         balanceOf[msg.sender]++;
170         Transfer(seller, msg.sender, 1);
171 
172         punkNoLongerForSale(punkIndex);
173         pendingWithdrawals[seller] += msg.value;
174         PunkBought(punkIndex, msg.value, seller, msg.sender);
175 
176         // Check for the case where there is a bid from the new owner and refund it.
177         // Any other bid can stay in place.
178         Bid bid = punkBids[punkIndex];
179         if (bid.bidder == msg.sender) {
180             // Kill bid and refund value
181             pendingWithdrawals[msg.sender] += bid.value;
182             punkBids[punkIndex] = Bid(false, punkIndex, 0x0, 0);
183         }
184     }
185 
186     function withdraw() {
187         if (!allPunksAssigned) throw;
188         uint amount = pendingWithdrawals[msg.sender];
189         // Remember to zero the pending refund before
190         // sending to prevent re-entrancy attacks
191         pendingWithdrawals[msg.sender] = 0;
192         msg.sender.transfer(amount);
193     }
194 
195     function enterBidForPunk(uint punkIndex) payable {
196         if (punkIndex >= 10000) throw;
197         if (!allPunksAssigned) throw;                
198         if (punkIndexToAddress[punkIndex] == 0x0) throw;
199         if (punkIndexToAddress[punkIndex] == msg.sender) throw;
200         if (msg.value == 0) throw;
201         Bid existing = punkBids[punkIndex];
202         if (msg.value <= existing.value) throw;
203         if (existing.value > 0) {
204             // Refund the failing bid
205             pendingWithdrawals[existing.bidder] += existing.value;
206         }
207         punkBids[punkIndex] = Bid(true, punkIndex, msg.sender, msg.value);
208         PunkBidEntered(punkIndex, msg.value, msg.sender);
209     }
210 
211     function acceptBidForPunk(uint punkIndex, uint minPrice) {
212         if (punkIndex >= 10000) throw;
213         if (!allPunksAssigned) throw;                
214         if (punkIndexToAddress[punkIndex] != msg.sender) throw;
215         address seller = msg.sender;
216         Bid bid = punkBids[punkIndex];
217         if (bid.value == 0) throw;
218         if (bid.value < minPrice) throw;
219 
220         punkIndexToAddress[punkIndex] = bid.bidder;
221         balanceOf[seller]--;
222         balanceOf[bid.bidder]++;
223         Transfer(seller, bid.bidder, 1);
224 
225         punksOfferedForSale[punkIndex] = Offer(false, punkIndex, bid.bidder, 0, 0x0);
226         uint amount = bid.value;
227         punkBids[punkIndex] = Bid(false, punkIndex, 0x0, 0);
228         pendingWithdrawals[seller] += amount;
229         PunkBought(punkIndex, bid.value, seller, bid.bidder);
230     }
231 
232     function withdrawBidForPunk(uint punkIndex) {
233         if (punkIndex >= 10000) throw;
234         if (!allPunksAssigned) throw;                
235         if (punkIndexToAddress[punkIndex] == 0x0) throw;
236         if (punkIndexToAddress[punkIndex] == msg.sender) throw;
237         Bid bid = punkBids[punkIndex];
238         if (bid.bidder != msg.sender) throw;
239         PunkBidWithdrawn(punkIndex, bid.value, msg.sender);
240         uint amount = bid.value;
241         punkBids[punkIndex] = Bid(false, punkIndex, 0x0, 0);
242         // Refund the bid money
243         msg.sender.transfer(amount);
244     }
245 
246 }