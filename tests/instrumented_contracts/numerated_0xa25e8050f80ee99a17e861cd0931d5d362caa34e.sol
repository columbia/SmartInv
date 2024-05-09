1 pragma solidity ^0.4.18;
2 
3 
4 contract GameCards {
5 
6     /// Lease record, store card tenants details
7     /// and lease details
8     struct LeaseCard {
9         uint id;
10         address tenant;
11         uint price;
12         uint untilBlock;
13         string title;
14         string url;
15         string image;
16     }
17 
18     /// Record card details
19     struct CardDetails {
20         uint8 id;
21         uint price;
22         uint priceLease; // price per block
23         uint leaseDuration; // in block
24         bool availableBuy;
25         bool availableLease;
26         uint[] leaseList;
27         mapping(uint => LeaseCard) leaseCardStructs;
28     }
29 
30     /// Record card
31     struct Card {
32         uint8 id;
33         address owner;
34         string title;
35         string url;
36         string image;
37         bool nsfw;
38     }
39 
40     /// Users pending withdrawals
41     mapping(address => uint) public pendingWithdrawals;
42 
43     mapping(uint8 => Card) public cardStructs; // random access by card key
44     uint8[] public cardList; // list of announce keys so we can enumerate them
45 
46     mapping(uint8 => CardDetails) public cardDetailsStructs; // random access by card details key
47     uint8[] public cardDetailsList; // list of cards details keys so we can enumerate them
48 
49     /// Initial card price
50     uint public initialCardPrice = 1 ether;
51 
52     /// Owner cut (1%) . This cut only apply on a user-to-user card transaction
53     uint public ownerBuyCut = 100;
54     /// fluffyCat cut (10%)
55     uint public fluffyCatCut = 1000;
56 
57     /// contractOwner can withdraw the funds
58     address public contractOwner;
59     /// fluffyCat address
60     address public fluffyCatAddress = 0x2c00A5013aA2E600663f7b197C98db73bA847e6d;
61 
62     /// Contract constructor
63     function GameCards() public {
64         contractOwner = msg.sender;
65     }
66 
67     modifier onlyContractOwner() {
68         // Throws if called by any account other than the contract owner
69         require(msg.sender == contractOwner);
70         _;
71     }
72 
73     modifier onlyCardOwner(uint8 cardId) {
74         // Throws if called by any account other than the card owner
75         require(msg.sender == cardStructs[cardId].owner);
76         _;
77     }
78 
79     modifier onlyValidCard(uint8 cardId) {
80         // Throws if card is not valid
81         require(cardId >= 1 && cardId <= 100);
82         _;
83     }
84 
85     /// Return cardList array
86     function getCards() public view returns(uint8[]) {
87         uint8[] memory result = new uint8[](cardList.length);
88         uint8 counter = 0;
89         for (uint8 i = 0; i < cardList.length; i++) {
90             result[counter] = i;
91             counter++;
92         }
93         return result;
94     }
95 
96     /// Return cardDetailsList array
97     function getCardsDetails() public view returns(uint8[]) {
98         uint8[] memory result = new uint8[](cardDetailsList.length);
99         uint8 counter = 0;
100         for (uint8 i = 0; i < cardDetailsList.length; i++) {
101             result[counter] = i;
102             counter++;
103         }
104         return result;
105     }
106 
107     /// Return card details by id
108     function getCardDetails(uint8 cardId) public view onlyValidCard(cardId)
109         returns (uint8 id, uint price, uint priceLease, uint leaseDuration, bool availableBuy, bool availableLease) {
110             bool _buyAvailability;
111             if (cardDetailsStructs[cardId].id == 0 || cardDetailsStructs[cardId].availableBuy) {
112                 _buyAvailability = true;
113             }
114 
115             CardDetails storage detail = cardDetailsStructs[cardId];
116             return (
117                 detail.id,
118                 detail.price,
119                 detail.priceLease,
120                 detail.leaseDuration,
121                 _buyAvailability,
122                 detail.availableLease
123                 );
124         }
125 
126     /// Return card by id
127     function getCard(uint8 cardId) public view onlyValidCard(cardId)
128         returns (uint8 id, address owner, string title, string url, string image, bool nsfw) {
129             Card storage card = cardStructs[cardId];
130             id = card.id;
131             owner = card.owner;
132             title = card.title;
133             url = card.url;
134             image = card.image;
135             nsfw = card.nsfw;
136         }
137 
138     /// This is called on the initial buy card, user to user buy is at buyCard()
139     /// Amount is sent to contractOwner balance and fluffycat get 10% of this amount
140     function initialBuyCard(uint8 cardId, string title, string url, string image) public
141         onlyValidCard(cardId)
142         payable
143         returns (bool success)
144     {
145         // Check sent amount
146         uint price = computeInitialPrice(cardId);
147         require(msg.value >= price);
148         // If owner is 0x0, then we are sure that
149         // this is the initial buy
150         require(cardStructs[cardId].owner == address(0));
151 
152         // Fill card
153         _fillCardStruct(cardId, msg.sender, title, url, image);
154         // Set nsfw flag to false
155         cardStructs[cardId].nsfw = false;
156         // Contract credit 10% of price to FluffyCat
157         _applyShare(contractOwner, fluffyCatAddress, fluffyCatCut);
158         // Initialize card details
159         _initCardDetails(cardId, price);
160         // Add the card to cardList
161         cardList.push(cardId);
162         return true;
163     }
164 
165     /// Perform a user to user buy transaction
166     /// Contract owner takes 1% cut on each of this transaction
167     function buyCard(uint8 cardId, string title, string url, string image) public
168         onlyValidCard(cardId)
169         payable
170         returns (bool success)
171     {
172         // Check that this is not an initial buy, i.e. that the
173         // card belongs to someone
174         require(cardStructs[cardId].owner != address(0));
175         // Check if card is on sale
176         require(cardDetailsStructs[cardId].availableBuy);
177         // Check sent amount
178         uint price = cardDetailsStructs[cardId].price;
179         require(msg.value >= price);
180 
181         address previousOwner = cardStructs[cardId].owner;
182         // Take 1% cut on buy
183         _applyShare(previousOwner, contractOwner, ownerBuyCut);
184         // Fill card
185         _fillCardStruct(cardId, msg.sender, title, url, image);
186         // Set nsfw flag to false
187         cardStructs[cardId].nsfw = false;
188         // Disable sell status
189         cardDetailsStructs[cardId].availableBuy = false;
190         return true;
191     }
192 
193     /// Allow card owner to edit his card informations
194     function editCard(uint8 cardId, string title, string url, string image) public
195         onlyValidCard(cardId)
196         onlyCardOwner(cardId)
197         returns (bool success)
198     {
199         // Fill card
200         _fillCardStruct(cardId, msg.sender, title, url, image);
201         // Disable sell status
202         return true;
203     }
204 
205     /// Allow card owner to set his card on sale at specific price
206     function sellCard(uint8 cardId, uint price) public
207         onlyValidCard(cardId)
208         onlyCardOwner(cardId)
209         returns (bool success)
210     {
211         cardDetailsStructs[cardId].price = price;
212         cardDetailsStructs[cardId].availableBuy = true;
213         return true;
214     }
215 
216     /// Allow card owner to cancel sell offer
217     function cancelSellCard(uint8 cardId) public
218         onlyValidCard(cardId)
219         onlyCardOwner(cardId)
220         returns (bool success)
221     {
222         cardDetailsStructs[cardId].availableBuy = false;
223         return true;
224     }
225 
226     /// Allow card owner to set his card on lease at fixed price per block and duration
227     function setLeaseCard(uint8 cardId, uint priceLease, uint leaseDuration) public
228         onlyValidCard(cardId)
229         onlyCardOwner(cardId)
230         returns (bool success)
231     {
232         // Card cannot be on sale when setting lease
233         // cancelSellCard() first
234         require(!cardDetailsStructs[cardId].availableBuy);
235         // Card cannot be set on lease while currently leasing
236         uint _lastLeaseId = getCardLeaseLength(cardId);
237         uint _until = cardDetailsStructs[cardId].leaseCardStructs[_lastLeaseId].untilBlock;
238         require(_until < block.number);
239 
240         cardDetailsStructs[cardId].priceLease = priceLease;
241         cardDetailsStructs[cardId].availableLease = true;
242         cardDetailsStructs[cardId].leaseDuration = leaseDuration;
243         return true;
244     }
245 
246     /// Allow card owner to cancel lease offer
247     /// Note that this do not interrupt current lease if any
248     function cancelLeaseOffer(uint8 cardId) public
249         onlyValidCard(cardId)
250         onlyCardOwner(cardId)
251         returns (bool success)
252     {
253         cardDetailsStructs[cardId].availableLease = false;
254         return true;
255     }
256 
257     /// Allow future tenant to lease a card
258     function leaseCard(uint8 cardId, string title, string url, string image) public
259         onlyValidCard(cardId)
260         payable
261         returns (bool success)
262     {
263         CardDetails storage details = cardDetailsStructs[cardId];
264         // Check that card is avaible to lease
265         require(details.availableLease);
266         // Get price (per block) and leaseDuration (block)
267         uint price = details.priceLease;
268         uint leaseDuration = details.leaseDuration;
269         uint totalAmount = price * leaseDuration;
270         // Check that amount sent is sufficient
271         require(msg.value >= totalAmount);
272         // Get new lease id
273         uint leaseId = getCardLeaseLength(cardId) + 1;
274         // Get the block number of lease end
275         uint untilBlock = block.number + leaseDuration;
276         // Take 1% cut on lease
277         Card storage card = cardStructs[cardId];
278         address _cardOwner = card.owner;
279         _applyShare(_cardOwner, contractOwner, ownerBuyCut);
280         // Fill leaseCardStructs
281         details.leaseCardStructs[leaseId].id = leaseId;
282         details.leaseCardStructs[leaseId].tenant = msg.sender;
283         details.leaseCardStructs[leaseId].price = totalAmount;
284         details.leaseCardStructs[leaseId].untilBlock = untilBlock;
285         details.leaseCardStructs[leaseId].title = title;
286         details.leaseCardStructs[leaseId].url = url;
287         details.leaseCardStructs[leaseId].image = image;
288         // Leases are now unavailable for this card
289         details.availableLease = false;
290         // Add lease to leases list of correspondant cardDetails
291         details.leaseList.push(leaseId);
292         return true;
293     }
294 
295     /// Get last lease from a card
296     function getLastLease(uint8 cardId) public view
297         returns(uint leaseIndex, address tenant, uint untilBlock, string title, string url, string image)
298     {
299         uint _leaseIndex = getCardLeaseLength(cardId);
300         return getLease(cardId, _leaseIndex);
301     }
302 
303     /// Get lease from card
304     function getLease(uint8 cardId, uint leaseId) public view
305         returns(uint leaseIndex, address tenant, uint untilBlock, string title, string url, string image)
306     {
307         return(
308             cardDetailsStructs[cardId].leaseCardStructs[leaseId].id,
309             cardDetailsStructs[cardId].leaseCardStructs[leaseId].tenant,
310             cardDetailsStructs[cardId].leaseCardStructs[leaseId].untilBlock,
311             cardDetailsStructs[cardId].leaseCardStructs[leaseId].title,
312             cardDetailsStructs[cardId].leaseCardStructs[leaseId].url,
313             cardDetailsStructs[cardId].leaseCardStructs[leaseId].image
314         );
315     }
316 
317     /// Get lease list from a card
318     function getCardLeaseLength(uint8 cardId) public view
319         returns(uint cardLeasesCount)
320     {
321         return(cardDetailsStructs[cardId].leaseList.length);
322     }
323 
324     /// Transfer the ownership of a card
325     function transferCardOwnership(address to, uint8 cardId)
326         public
327         onlyCardOwner(cardId)
328         returns (bool success)
329     {
330         // Transfer card ownership
331         cardStructs[cardId].owner = to;
332         return true;
333     }
334 
335     /// Return balance from sender
336     function getBalance()
337         public
338         view
339         returns (uint amount)
340     {
341         return pendingWithdrawals[msg.sender];
342     }
343 
344     /// Allow address to withdraw their balance
345     function withdraw()
346         public
347         returns (bool)
348     {
349         uint amount = pendingWithdrawals[msg.sender];
350         // Remember to zero the pending refund before
351         // sending to prevent re-entrancy attacks
352         pendingWithdrawals[msg.sender] = 0;
353         msg.sender.transfer(amount);
354         return true;
355     }
356 
357     /// Compute initial card price (in wei)
358     function computeInitialPrice(uint8 cardId) public view
359         onlyValidCard(cardId)
360         returns (uint price)
361     {
362         // 1 ether - 0.01 ether * (cardId - 1)
363         return initialCardPrice - ((initialCardPrice / 100) * (uint256(cardId) - 1));
364     }
365 
366     /// Allow contract owner to set NSFW flag on a card
367     function setNSFW(uint8 cardId, bool flag) public
368         onlyValidCard(cardId)
369         onlyContractOwner()
370         returns (bool success)
371     {
372         cardStructs[cardId].nsfw = flag;
373         return true;
374     }
375 
376     /// Fill Card struct
377     function _fillCardStruct(uint8 _cardId, address _owner, string _title, string _url, string _image) internal
378         returns (bool success)
379     {
380         cardStructs[_cardId].owner = _owner;
381         cardStructs[_cardId].title = _title;
382         cardStructs[_cardId].url = _url;
383         cardStructs[_cardId].image = _image;
384         return true;
385     }
386 
387     /// Initialize sell card for future
388     function _initCardDetails(uint8 cardId, uint price) internal
389         returns (bool success)
390     {
391         // priceLease, leaseDuration set to default value(= 0)
392         cardDetailsStructs[cardId].id = cardId;
393         cardDetailsStructs[cardId].price = price;
394         cardDetailsStructs[cardId].availableBuy = false;
395         cardDetailsStructs[cardId].availableLease = false;
396         cardDetailsList.push(cardId);
397         return true;
398     }
399 
400     /// Send split amounts to respective balances
401     function _applyShare(address _seller, address _auctioneer, uint _cut) internal
402         returns (bool success)
403     {
404         // Compute share
405         uint256 auctioneerCut = _computeCut(msg.value, _cut);
406         uint256 sellerProceeds = msg.value - auctioneerCut;
407         // Credit seller balance
408         pendingWithdrawals[_seller] += sellerProceeds;
409         // Credit auctionner balance
410         pendingWithdrawals[_auctioneer] += auctioneerCut;
411         return true;
412     }
413 
414     /// Compute _cut from a _price
415     function _computeCut(uint256 _price, uint256 _cut) internal pure
416         returns (uint256)
417     {
418         return _price * _cut / 10000;
419     }
420 }