1 pragma solidity ^0.4.13;
2 
3 /**
4  * This contract handles the actions for every collectible on DADA...
5  */
6 
7 contract DadaCollectible {
8 
9   // DADA's account
10   address owner;
11 
12 
13   // starts turned off to prepare the drawings before going public
14   bool isExecutionAllowed = false;
15 
16   // ERC20 token standard attributes
17   string public name;
18   string public symbol;
19   uint8 public decimals;
20   uint256 public totalSupply;
21 
22   struct Offer {
23       bool isForSale;
24       uint drawingId;
25       uint printIndex;
26       address seller; 
27       uint minValue;          // in ether
28       address onlySellTo;     // specify to sell only to a specific person
29       uint lastSellValue;
30   }
31 
32   struct Bid {
33       bool hasBid;
34       uint drawingId;
35       uint printIndex;
36       address bidder;
37       uint value;
38   }
39 
40   struct Collectible{
41     uint drawingId;
42     string checkSum; // digest of the drawing, created using  SHA2
43     uint totalSupply;
44     uint nextPrintIndexToAssign;
45     bool allPrintsAssigned;
46     uint initialPrice;
47     uint initialPrintIndex;
48     string collectionName;
49     uint authorUId; // drawing creator id 
50     string scarcity; // denotes how scarce is the drawing
51   }    
52 
53   // key: printIndex
54   // the value is the user who owns that specific print
55   mapping (uint => address) public DrawingPrintToAddress;
56   
57   // A record of collectibles that are offered for sale at a specific minimum value, 
58   // and perhaps to a specific person, the key to access and offer is the printIndex.
59   // since every single offer inside the Collectible struct will be tied to the main
60   // drawingId that identifies that collectible.
61   mapping (uint => Offer) public OfferedForSale;
62 
63   // A record of the highest collectible bid, the key to access a bid is the printIndex
64   mapping (uint => Bid) public Bids;
65 
66 
67   // "Hash" list of the different Collectibles available in the market place
68   mapping (uint => Collectible) public drawingIdToCollectibles;
69 
70   mapping (address => uint) public pendingWithdrawals;
71 
72   mapping (address => uint256) public balances;
73 
74   // returns the balance of a particular account
75   function balanceOf(address _owner) constant returns (uint256 balance) {
76     return balances[_owner];
77   } 
78 
79   // Events
80   event Assigned(address indexed to, uint256 collectibleIndex, uint256 printIndex);
81   event Transfer(address indexed from, address indexed to, uint256 value);
82   event CollectibleTransfer(address indexed from, address indexed to, uint256 collectibleIndex, uint256 printIndex);
83   event CollectibleOffered(uint indexed collectibleIndex, uint indexed printIndex, uint minValue, address indexed toAddress, uint lastSellValue);
84   event CollectibleBidEntered(uint indexed collectibleIndex, uint indexed printIndex, uint value, address indexed fromAddress);
85   event CollectibleBidWithdrawn(uint indexed collectibleIndex, uint indexed printIndex, uint value, address indexed fromAddress);
86   event CollectibleBought(uint indexed collectibleIndex, uint printIndex, uint value, address indexed fromAddress, address indexed toAddress);
87   event CollectibleNoLongerForSale(uint indexed collectibleIndex, uint indexed printIndex);
88 
89   // The constructor is executed only when the contract is created in the blockchain.
90   function DadaCollectible () { 
91     // assigns the address of the account creating the contract as the 
92     // "owner" of the contract. Since the contract doesn't have 
93     // a "set" function for the owner attribute this value will be immutable. 
94     owner = msg.sender;
95 
96     // Update total supply
97     totalSupply = 16600;
98     // Give to DADA all initial drawings
99     balances[owner] = totalSupply;
100 
101     // Set the name for display purposes
102     name = "DADA Collectible";
103     // Set the symbol for display purposes
104     symbol = "Ɖ";
105     // Amount of decimals for display purposes
106     decimals = 0;
107   }
108 
109   // main business logic functions
110   
111   // buyer's functions
112   function buyCollectible(uint drawingId, uint printIndex) payable {
113     require(isExecutionAllowed);
114     // requires the drawing id to actually exist
115     require(drawingIdToCollectibles[drawingId].drawingId != 0);
116     Collectible storage collectible = drawingIdToCollectibles[drawingId];
117     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) &&  (printIndex >= collectible.initialPrintIndex));
118     Offer storage offer = OfferedForSale[printIndex];
119     require(offer.drawingId != 0);
120     require(offer.isForSale); // drawing actually for sale
121     require(offer.onlySellTo == 0x0 || offer.onlySellTo == msg.sender);  // drawing can be sold to this user
122     require(msg.value >= offer.minValue); // Didn't send enough ETH
123     require(offer.seller == DrawingPrintToAddress[printIndex]); // Seller still owner of the drawing
124     require(DrawingPrintToAddress[printIndex] != msg.sender);
125 
126     address seller = offer.seller;
127     address buyer = msg.sender;
128 
129     DrawingPrintToAddress[printIndex] = buyer; // "gives" the print to the buyer
130 
131     // decrease by one the amount of prints the seller has of this particullar drawing
132     balances[seller]--;
133     // increase by one the amount of prints the buyer has of this particullar drawing
134     balances[buyer]++;
135 
136     // launch the Transfered event
137     Transfer(seller, buyer, 1);
138 
139     // transfer ETH to the seller
140     // profit delta must be equal or greater than 1e-16 to be able to divide it
141     // between the involved entities (art creator -> 30%, seller -> 60% and dada -> 10%)
142     // profit percentages can't be lower than 1e-18 which is the lowest unit in ETH
143     // equivalent to 1 wei.
144     // if(offer.lastSellValue < msg.value && (msg.value - offer.lastSellValue) >= uint(0.0000000000000001) ){ commented because we're assuming values are expressed in  "weis", adjusting in relation to that
145     if(offer.lastSellValue < msg.value && (msg.value - offer.lastSellValue) >= 100 ){ // assuming 100 (weis) wich is equivalent to 1e-16
146       uint profit = msg.value - offer.lastSellValue;
147       // seller gets base value plus 60% of the profit
148       pendingWithdrawals[seller] += offer.lastSellValue + (profit*60/100); 
149       // dada gets 10% of the profit
150       // pendingWithdrawals[owner] += (profit*10/100);
151       // dada receives 30% of the profit to give to the artist
152       // pendingWithdrawals[owner] += (profit*30/100);
153       // going manual for artist and dada percentages (30 + 10)
154       pendingWithdrawals[owner] += (profit*40/100);
155     }else{
156       // if the seller doesn't make a profit of the sell he gets the 100% of the traded
157       // value.
158       pendingWithdrawals[seller] += msg.value;
159     }
160     makeCollectibleUnavailableToSale(buyer, drawingId, printIndex, msg.value);
161 
162     // launch the CollectibleBought event    
163     CollectibleBought(drawingId, printIndex, msg.value, seller, buyer);
164 
165     // Check for the case where there is a bid from the new owner and refund it.
166     // Any other bid can stay in place.
167     Bid storage bid = Bids[printIndex];
168     if (bid.bidder == buyer) {
169       // Kill bid and refund value
170       pendingWithdrawals[buyer] += bid.value;
171       Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
172     }
173   }
174 
175   function alt_buyCollectible(uint drawingId, uint printIndex) payable {
176     require(isExecutionAllowed);
177     // requires the drawing id to actually exist
178     require(drawingIdToCollectibles[drawingId].drawingId != 0);
179     Collectible storage collectible = drawingIdToCollectibles[drawingId];
180     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) &&  (printIndex >= collectible.initialPrintIndex));
181     Offer storage offer = OfferedForSale[printIndex];
182     require(offer.drawingId == 0);
183     
184     require(msg.value >= collectible.initialPrice); // Didn't send enough ETH
185     require(DrawingPrintToAddress[printIndex] == 0x0); // should be equal to a "null" address (0x0) since it shouldn't have an owner yet
186 
187     address seller = owner;
188     address buyer = msg.sender;
189 
190     DrawingPrintToAddress[printIndex] = buyer; // "gives" the print to the buyer
191 
192     // decrease by one the amount of prints the seller has of this particullar drawing
193     // commented while we decide what to do with balances for DADA
194     balances[seller]--;
195     // increase by one the amount of prints the buyer has of this particullar drawing
196     balances[buyer]++;
197 
198     // launch the Transfered event
199     Transfer(seller, buyer, 1);
200 
201     // transfer ETH to the seller
202     // profit delta must be equal or greater than 1e-16 to be able to divide it
203     // between the involved entities (art creator -> 30%, seller -> 60% and dada -> 10%)
204     // profit percentages can't be lower than 1e-18 which is the lowest unit in ETH
205     // equivalent to 1 wei.
206 
207     pendingWithdrawals[owner] += msg.value;
208     
209     OfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, buyer, msg.value, 0x0, msg.value);
210 
211     // launch the CollectibleBought event    
212     CollectibleBought(drawingId, printIndex, msg.value, seller, buyer);
213 
214     // Check for the case where there is a bid from the new owner and refund it.
215     // Any other bid can stay in place.
216     Bid storage bid = Bids[printIndex];
217     if (bid.bidder == buyer) {
218       // Kill bid and refund value
219       pendingWithdrawals[buyer] += bid.value;
220       Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
221     }
222   }
223   
224   function enterBidForCollectible(uint drawingId, uint printIndex) payable {
225     require(isExecutionAllowed);
226     require(drawingIdToCollectibles[drawingId].drawingId != 0);
227     Collectible storage collectible = drawingIdToCollectibles[drawingId];
228     require(DrawingPrintToAddress[printIndex] != 0x0); // Print is owned by somebody
229     require(DrawingPrintToAddress[printIndex] != msg.sender); // Print is not owned by bidder
230     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) && (printIndex >= collectible.initialPrintIndex));
231 
232     require(msg.value > 0); // Bid must be greater than 0
233     // get the current bid for that print if any
234     Bid storage existing = Bids[printIndex];
235     // Must outbid previous bid by at least 5%. Apparently is not possible to 
236     // multiply by 1.05, that's why we do it manually.
237     require(msg.value >= existing.value+(existing.value*5/100));
238     if (existing.value > 0) {
239         // Refund the failing bid from the previous bidder
240         pendingWithdrawals[existing.bidder] += existing.value;
241     }
242     // add the new bid
243     Bids[printIndex] = Bid(true, collectible.drawingId, printIndex, msg.sender, msg.value);
244     CollectibleBidEntered(collectible.drawingId, printIndex, msg.value, msg.sender);
245   }
246 
247   // used by a user who wants to cancell a bid placed by her/him
248   function withdrawBidForCollectible(uint drawingId, uint printIndex) {
249     require(isExecutionAllowed);
250     require(drawingIdToCollectibles[drawingId].drawingId != 0);
251     Collectible storage collectible = drawingIdToCollectibles[drawingId];
252     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) && (printIndex >= collectible.initialPrintIndex));
253     require(DrawingPrintToAddress[printIndex] != 0x0); // Print is owned by somebody
254     require(DrawingPrintToAddress[printIndex] != msg.sender); // Print is not owned by bidder
255     Bid storage bid = Bids[printIndex];
256     require(bid.bidder == msg.sender);
257     CollectibleBidWithdrawn(drawingId, printIndex, bid.value, msg.sender);
258 
259     uint amount = bid.value;
260     Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
261     // Refund the bid money
262     msg.sender.transfer(amount);
263   }
264 
265   // seller's functions
266   function offerCollectibleForSale(uint drawingId, uint printIndex, uint minSalePriceInWei) {
267     require(isExecutionAllowed);
268     require(drawingIdToCollectibles[drawingId].drawingId != 0);
269     Collectible storage collectible = drawingIdToCollectibles[drawingId];
270     require(DrawingPrintToAddress[printIndex] == msg.sender);
271     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) && (printIndex >= collectible.initialPrintIndex));
272     uint lastSellValue = OfferedForSale[printIndex].lastSellValue;
273     OfferedForSale[printIndex] = Offer(true, collectible.drawingId, printIndex, msg.sender, minSalePriceInWei, 0x0, lastSellValue);
274     CollectibleOffered(drawingId, printIndex, minSalePriceInWei, 0x0, lastSellValue);
275   }
276 
277   function withdrawOfferForCollectible(uint drawingId, uint printIndex){
278     require(isExecutionAllowed);
279     require(drawingIdToCollectibles[drawingId].drawingId != 0);
280     Collectible storage collectible = drawingIdToCollectibles[drawingId];
281     require(DrawingPrintToAddress[printIndex] == msg.sender);
282     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) && (printIndex >= collectible.initialPrintIndex));
283 
284     uint lastSellValue = OfferedForSale[printIndex].lastSellValue;
285 
286     OfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, msg.sender, 0, 0x0, lastSellValue);
287     // launch the CollectibleNoLongerForSale event 
288     CollectibleNoLongerForSale(collectible.drawingId, printIndex);
289 
290   }
291 
292   function offerCollectibleForSaleToAddress(uint drawingId, uint printIndex, uint minSalePriceInWei, address toAddress) {
293     require(isExecutionAllowed);
294     require(drawingIdToCollectibles[drawingId].drawingId != 0);
295     Collectible storage collectible = drawingIdToCollectibles[drawingId];
296     require(DrawingPrintToAddress[printIndex] == msg.sender);
297     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) && (printIndex >= collectible.initialPrintIndex));
298     uint lastSellValue = OfferedForSale[printIndex].lastSellValue;
299     OfferedForSale[printIndex] = Offer(true, collectible.drawingId, printIndex, msg.sender, minSalePriceInWei, toAddress, lastSellValue);
300     CollectibleOffered(drawingId, printIndex, minSalePriceInWei, toAddress, lastSellValue);
301   }
302 
303   function acceptBidForCollectible(uint drawingId, uint minPrice, uint printIndex) {
304     require(isExecutionAllowed);
305     require(drawingIdToCollectibles[drawingId].drawingId != 0);
306     Collectible storage collectible = drawingIdToCollectibles[drawingId];
307     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) && (printIndex >= collectible.initialPrintIndex));
308     require(DrawingPrintToAddress[printIndex] == msg.sender);
309     address seller = msg.sender;
310 
311     Bid storage bid = Bids[printIndex];
312     require(bid.value > 0); // Will be zero if there is no actual bid
313     require(bid.value >= minPrice); // Prevent a condition where a bid is withdrawn and replaced with a lower bid but seller doesn't know
314 
315     DrawingPrintToAddress[printIndex] = bid.bidder;
316     balances[seller]--;
317     balances[bid.bidder]++;
318     Transfer(seller, bid.bidder, 1);
319     uint amount = bid.value;
320 
321     Offer storage offer = OfferedForSale[printIndex];
322     // transfer ETH to the seller
323     // profit delta must be equal or greater than 1e-16 to be able to divide it
324     // between the involved entities (art creator -> 30%, seller -> 60% and dada -> 10%)
325     // profit percentages can't be lower than 1e-18 which is the lowest unit in ETH
326     // equivalent to 1 wei.
327     // if(offer.lastSellValue > msg.value && (msg.value - offer.lastSellValue) >= uint(0.0000000000000001) ){ commented because we're assuming values are expressed in  "weis", adjusting in relation to that
328     if(offer.lastSellValue < amount && (amount - offer.lastSellValue) >= 100 ){ // assuming 100 (weis) wich is equivalent to 1e-16
329       uint profit = amount - offer.lastSellValue;
330       // seller gets base value plus 60% of the profit
331       pendingWithdrawals[seller] += offer.lastSellValue + (profit*60/100); 
332       // dada gets 10% of the profit
333       // pendingWithdrawals[owner] += (profit*10/100);
334       // dada receives 30% of the profit to give to the artist
335       // pendingWithdrawals[owner] += (profit*30/100);
336       pendingWithdrawals[owner] += (profit*40/100);
337 
338     }else{
339       // if the seller doesn't make a profit of the sell he gets the 100% of the traded
340       // value.
341       pendingWithdrawals[seller] += amount;
342     }
343     // does the same as the function makeCollectibleUnavailableToSale
344     OfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, bid.bidder, 0, 0x0, amount);
345     CollectibleBought(collectible.drawingId, printIndex, bid.value, seller, bid.bidder);
346     Bids[printIndex] = Bid(false, collectible.drawingId, printIndex, 0x0, 0);
347 
348   }
349 
350   // used by a user who wants to cashout his money
351   function withdraw() {
352     require(isExecutionAllowed);
353     uint amount = pendingWithdrawals[msg.sender];
354     // Remember to zero the pending refund before
355     // sending to prevent re-entrancy attacks
356     pendingWithdrawals[msg.sender] = 0;
357     msg.sender.transfer(amount);
358   }
359 
360   // Transfer ownership of a punk to another user without requiring payment
361   function transfer(address to, uint drawingId, uint printIndex) returns (bool success){
362     require(isExecutionAllowed);
363     require(drawingIdToCollectibles[drawingId].drawingId != 0);
364     Collectible storage collectible = drawingIdToCollectibles[drawingId];
365     // checks that the user making the transfer is the actual owner of the print
366     require(DrawingPrintToAddress[printIndex] == msg.sender);
367     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) && (printIndex >= collectible.initialPrintIndex));
368     makeCollectibleUnavailableToSale(to, drawingId, printIndex, OfferedForSale[printIndex].lastSellValue);
369     // sets the new owner of the print
370     DrawingPrintToAddress[printIndex] = to;
371     balances[msg.sender]--;
372     balances[to]++;
373     Transfer(msg.sender, to, 1);
374     CollectibleTransfer(msg.sender, to, drawingId, printIndex);
375     // Check for the case where there is a bid from the new owner and refund it.
376     // Any other bid can stay in place.
377     Bid storage bid = Bids[printIndex];
378     if (bid.bidder == to) {
379       // Kill bid and refund value
380       pendingWithdrawals[to] += bid.value;
381       Bids[printIndex] = Bid(false, drawingId, printIndex, 0x0, 0);
382     }
383     return true;
384   }
385 
386   // utility functions
387   function makeCollectibleUnavailableToSale(address to, uint drawingId, uint printIndex, uint lastSellValue) {
388     require(isExecutionAllowed);
389     require(drawingIdToCollectibles[drawingId].drawingId != 0);
390     Collectible storage collectible = drawingIdToCollectibles[drawingId];
391     require(DrawingPrintToAddress[printIndex] == msg.sender);
392     require((printIndex < (collectible.totalSupply+collectible.initialPrintIndex)) && (printIndex >= collectible.initialPrintIndex));
393     OfferedForSale[printIndex] = Offer(false, collectible.drawingId, printIndex, to, 0, 0x0, lastSellValue);
394     // launch the CollectibleNoLongerForSale event 
395     CollectibleNoLongerForSale(collectible.drawingId, printIndex);
396   }
397 
398   function newCollectible(uint drawingId, string checkSum, uint256 _totalSupply, uint initialPrice, uint initialPrintIndex, string collectionName, uint authorUId, string scarcity){
399     // requires the sender to be the same address that compiled the contract,
400     // this is ensured by storing the sender address
401     // require(owner == msg.sender);
402     require(owner == msg.sender);
403     // requires the drawing to not exist already in the scope of the contract
404     require(drawingIdToCollectibles[drawingId].drawingId == 0);
405     drawingIdToCollectibles[drawingId] = Collectible(drawingId, checkSum, _totalSupply, initialPrintIndex, false, initialPrice, initialPrintIndex, collectionName, authorUId, scarcity);
406   }
407 
408   function flipSwitchTo(bool state){
409     // require(owner == msg.sender);
410     require(owner == msg.sender);
411     isExecutionAllowed = state;
412   }
413 
414   function mintNewDrawings(uint amount){
415     require(owner == msg.sender);
416     totalSupply = totalSupply + amount;
417     balances[owner] = balances[owner] + amount;
418 
419     Transfer(0, owner, amount);
420   }
421 
422 }