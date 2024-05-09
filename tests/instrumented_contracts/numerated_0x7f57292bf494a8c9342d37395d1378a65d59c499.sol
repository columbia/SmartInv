1 pragma solidity ^0.4.18;
2 
3 contract WeiCards {
4 
5     /// Lease record, store card tenants details
6     /// and lease details
7     struct LeaseCard {
8       uint id;
9       address tenant;
10       uint price;
11       uint untilBlock;
12       string title;
13       string url;
14       string image;
15     }
16 
17     /// Record card details
18     struct cardDetails {
19       uint8 id;
20       uint price;
21       uint priceLease; // price per block
22       uint leaseDuration; // in block
23       bool availableBuy;
24       bool availableLease;
25       uint[] leaseList;
26       mapping(uint => LeaseCard) leaseCardStructs;
27     }
28 
29     /// Record card
30     struct Card {
31       uint8 id;
32       address owner;
33       string title;
34       string url;
35       string image;
36       bool nsfw;
37     }
38     
39     /// Users pending withdrawals
40     mapping(address => uint) pendingWithdrawals;
41 
42     mapping(uint8 => Card) cardStructs; // random access by card key
43     uint8[] cardList; // list of announce keys so we can enumerate them
44 
45     mapping(uint8 => cardDetails) cardDetailsStructs; // random access by card details key
46     uint8[] cardDetailsList; // list of cards details keys so we can enumerate them
47 
48     /// Initial card price
49     uint initialCardPrice = 1 ether;
50 
51     /// Owner cut (1%) . This cut only apply on a user-to-user card transaction
52     uint ownerBuyCut = 100;
53     /// GiveETH cut (10%)
54     uint giveEthCut = 1000;
55 
56     /// contractOwner can withdraw the funds
57     address contractOwner;
58     /// Giveth address
59     address giveEthAddress = 0x5ADF43DD006c6C36506e2b2DFA352E60002d22Dc;
60     
61     /// Contract constructor
62     function WeiCards(address _contractOwner) public {
63       require(_contractOwner != address(0));
64       contractOwner = _contractOwner;
65     }
66 
67     modifier onlyContractOwner()
68     {
69        // Throws if called by any account other than the contract owner
70         require(msg.sender == contractOwner);
71         _;
72     }
73 
74     modifier onlyCardOwner(uint8 cardId)
75     {
76        // Throws if called by any account other than the card owner
77         require(msg.sender == cardStructs[cardId].owner);
78         _;
79     }
80 
81     modifier onlyValidCard(uint8 cardId)
82     {
83        // Throws if card is not valid
84         require(cardId >= 1 && cardId <= 100);
85         _;
86     }
87     
88     /// Return cardList array
89     function getCards() public view
90         returns(uint8[])
91     {
92       return cardList;
93     }
94 
95     /// Return cardDetailsList array
96     function getCardsDetails() public view
97         returns(uint8[])
98     {
99       return cardDetailsList;
100     }
101 
102     /// Return card details by id
103     function getCardDetails(uint8 cardId) view public
104         onlyValidCard(cardId)
105         returns (uint8 id, uint price, uint priceLease, uint leaseDuration, bool availableBuy, bool availableLease)
106     {
107         bool _buyAvailability;
108         if (cardDetailsStructs[cardId].id == 0 || cardDetailsStructs[cardId].availableBuy) {
109             _buyAvailability = true;
110         }
111 
112         return(
113           cardDetailsStructs[cardId].id,
114           cardDetailsStructs[cardId].price,
115           cardDetailsStructs[cardId].priceLease,
116           cardDetailsStructs[cardId].leaseDuration,
117           _buyAvailability,
118           cardDetailsStructs[cardId].availableLease
119         );
120     }
121 
122     /// Return card by id
123     function getCard(uint8 cardId) view public
124         onlyValidCard(cardId)
125         returns (uint8 id, address owner, string title, string url, string image, bool nsfw)
126     {
127         return(
128           cardStructs[cardId].id,
129           cardStructs[cardId].owner,
130           cardStructs[cardId].title,
131           cardStructs[cardId].url,
132           cardStructs[cardId].image,
133           cardStructs[cardId].nsfw
134         );
135     }
136     
137     /// This is called on the initial buy card, user to user buy is at buyCard()
138     /// Amount is sent to contractOwner balance and giveth get 10% of this amount
139     function initialBuyCard(uint8 cardId, string title, string url, string image) public
140         onlyValidCard(cardId)
141         payable
142         returns (bool success)
143     {
144         // Check sent amount
145         uint price = computeInitialPrice(cardId);
146         require(msg.value >= price);
147         // If owner is 0x0, then we are sure that
148         // this is the initial buy
149         require(cardStructs[cardId].owner == address(0));
150 
151         // Fill card
152         _fillCardStruct(cardId, msg.sender, title, url, image);
153         // Set nsfw flag to false
154         cardStructs[cardId].nsfw = false;
155         // Contract credit 10% of price to GiveETH
156          _applyShare(contractOwner, giveEthAddress, giveEthCut);
157         // Initialize card details
158         _initCardDetails(cardId, price);
159         // Add the card to cardList
160         cardList.push(cardId);
161         return true;
162     }
163 
164     /// Perform a user to user buy transaction
165     /// Contract owner takes 1% cut on each of this transaction
166     function buyCard(uint8 cardId, string title, string url, string image) public
167         onlyValidCard(cardId)
168         payable
169         returns (bool success)
170     {
171         // Check that this is not an initial buy, i.e. that the
172         // card belongs to someone
173         require(cardStructs[cardId].owner != address(0));
174         // Check if card is on sale
175         require(cardDetailsStructs[cardId].availableBuy);
176         // Check sent amount
177         uint price = cardDetailsStructs[cardId].price;
178         require(msg.value >= price);
179         
180         address previousOwner = cardStructs[cardId].owner;
181         // Take 1% cut on buy
182         _applyShare(previousOwner, contractOwner, ownerBuyCut);
183         // Fill card
184         _fillCardStruct(cardId, msg.sender, title, url, image);
185         // Set nsfw flag to false
186         cardStructs[cardId].nsfw = false;
187         // Disable sell status
188         cardDetailsStructs[cardId].availableBuy = false;
189         return true;
190     }
191 
192     /// Allow card owner to edit his card informations
193     function editCard(uint8 cardId, string title, string url, string image) public
194         onlyValidCard(cardId)
195         onlyCardOwner(cardId)
196         returns (bool success)
197     {
198         // Fill card
199         _fillCardStruct(cardId, msg.sender, title, url, image);
200         // Disable sell status
201         return true;
202     }
203 
204     /// Allow card owner to set his card on sale at specific price
205     function sellCard(uint8 cardId, uint price) public
206         onlyValidCard(cardId)
207         onlyCardOwner(cardId)
208         returns (bool success)
209     {
210         cardDetailsStructs[cardId].price = price;
211         cardDetailsStructs[cardId].availableBuy = true;
212         return true;
213     }
214 
215     /// Allow card owner to cancel sell offer
216     function cancelSellCard(uint8 cardId) public
217         onlyValidCard(cardId)
218         onlyCardOwner(cardId)
219         returns (bool success)
220     {
221         cardDetailsStructs[cardId].availableBuy = false;
222         return true;
223     }
224 
225     /// Allow card owner to set his card on lease at fixed price per block and duration
226     function setLeaseCard(uint8 cardId, uint priceLease, uint leaseDuration) public
227         onlyValidCard(cardId)
228         onlyCardOwner(cardId)
229         returns (bool success)
230     {
231         // Card cannot be on sale when setting lease
232         // cancelSellCard() first
233         require(!cardDetailsStructs[cardId].availableBuy);
234         // Card cannot be set on lease while currently leasing
235         uint _lastLeaseId = getCardLeaseLength(cardId);
236         uint _until = cardDetailsStructs[cardId].leaseCardStructs[_lastLeaseId].untilBlock;
237         require(_until < block.number);
238 
239         cardDetailsStructs[cardId].priceLease = priceLease;
240         cardDetailsStructs[cardId].availableLease = true;
241         cardDetailsStructs[cardId].leaseDuration = leaseDuration;
242         return true;
243     }
244 
245     /// Allow card owner to cancel lease offer
246     /// Note that this do not interrupt current lease if any
247     function cancelLeaseOffer(uint8 cardId) public
248         onlyValidCard(cardId)
249         onlyCardOwner(cardId)
250         returns (bool success)
251     {
252         cardDetailsStructs[cardId].availableLease = false;
253         return true;
254     }
255 
256     /// Allow future tenant to lease a card
257     function leaseCard(uint8 cardId, string title, string url, string image) public
258         onlyValidCard(cardId)
259         payable
260         returns (bool success)
261     {
262         // Check that card is avaible to lease
263         require(cardDetailsStructs[cardId].availableLease);
264         // Get price (per block) and leaseDuration (block)
265         uint price = cardDetailsStructs[cardId].priceLease;
266         uint leaseDuration = cardDetailsStructs[cardId].leaseDuration;
267         uint totalAmount = price * leaseDuration;
268         // Check that amount sent is sufficient
269         require(msg.value >= totalAmount);
270         // Get new lease id
271         uint leaseId = getCardLeaseLength(cardId) + 1;
272         // Get the block number of lease end
273         uint untilBlock = block.number + leaseDuration;
274         // Take 1% cut on lease
275         address _cardOwner = cardStructs[cardId].owner;
276         _applyShare(_cardOwner, contractOwner, ownerBuyCut);
277         // Fill leaseCardStructs
278         cardDetailsStructs[cardId].leaseCardStructs[leaseId].id = leaseId;
279         cardDetailsStructs[cardId].leaseCardStructs[leaseId].tenant = msg.sender;
280         cardDetailsStructs[cardId].leaseCardStructs[leaseId].price = totalAmount;
281         cardDetailsStructs[cardId].leaseCardStructs[leaseId].untilBlock = untilBlock;
282         cardDetailsStructs[cardId].leaseCardStructs[leaseId].title = title;
283         cardDetailsStructs[cardId].leaseCardStructs[leaseId].url = url;
284         cardDetailsStructs[cardId].leaseCardStructs[leaseId].image = image;
285         // Leases are now unavailable for this card
286         cardDetailsStructs[cardId].availableLease = false;
287         // Add lease to leases list of correspondant cardDetails
288         cardDetailsStructs[cardId].leaseList.push(leaseId);
289         return true;
290     }
291 
292     /// Get last lease from a card
293     function getLastLease(uint8 cardId) public constant
294         returns(uint leaseIndex, address tenant, uint untilBlock, string title, string url, string image)
295     {
296         uint _leaseIndex = getCardLeaseLength(cardId);
297         return getLease(cardId, _leaseIndex);
298     }
299 
300     /// Get lease from card
301     function getLease(uint8 cardId, uint leaseId) public constant
302         returns(uint leaseIndex, address tenant, uint untilBlock, string title, string url, string image)
303     {
304         return(
305             cardDetailsStructs[cardId].leaseCardStructs[leaseId].id,
306             cardDetailsStructs[cardId].leaseCardStructs[leaseId].tenant,
307             cardDetailsStructs[cardId].leaseCardStructs[leaseId].untilBlock,
308             cardDetailsStructs[cardId].leaseCardStructs[leaseId].title,
309             cardDetailsStructs[cardId].leaseCardStructs[leaseId].url,
310             cardDetailsStructs[cardId].leaseCardStructs[leaseId].image
311         );
312     }
313 
314     /// Get lease list from a card
315     function getCardLeaseLength(uint8 cardId) public constant
316         returns(uint cardLeasesCount)
317     {
318         return(cardDetailsStructs[cardId].leaseList.length);
319     }
320 
321     /// Transfer the ownership of a card
322     function transferCardOwnership(address to, uint8 cardId) public
323       onlyCardOwner(cardId)
324       returns (bool success)
325     {
326         // Transfer card ownership
327         cardStructs[cardId].owner = to;
328         return true;
329     }
330     
331     /// Return balance from sender
332     function getBalance() public view
333       returns (uint amount)
334     {
335         return pendingWithdrawals[msg.sender];
336     }
337     
338     /// Allow address to withdraw their balance
339     function withdraw() public
340         returns (bool) 
341     {
342         uint amount = pendingWithdrawals[msg.sender];
343         // Remember to zero the pending refund before
344         // sending to prevent re-entrancy attacks
345         pendingWithdrawals[msg.sender] = 0;
346         msg.sender.transfer(amount);
347         return true;
348     }
349     
350     /// Compute initial card price (in wei)
351     function computeInitialPrice(uint8 cardId) public view
352         onlyValidCard(cardId)
353         returns (uint price)
354     {
355         // 1 ether - 0.01 ether * (cardId - 1)
356         return initialCardPrice - ((initialCardPrice / 100) * (uint256(cardId) - 1));
357     }
358 
359     /// Allow contract owner to set NSFW flag on a card
360     function setNSFW(uint8 cardId, bool flag) public
361         onlyValidCard(cardId)
362         onlyContractOwner()
363         returns (bool success)
364     {
365         cardStructs[cardId].nsfw = flag;
366         return true;
367     }
368 
369     /// Fill Card struct
370     function _fillCardStruct(uint8 _cardId, address _owner, string _title, string _url, string _image) internal
371         returns (bool success)
372     {
373         cardStructs[_cardId].owner = _owner;
374         cardStructs[_cardId].title = _title;
375         cardStructs[_cardId].url = _url;
376         cardStructs[_cardId].image = _image;
377         return true;
378     }
379 
380     /// Initialize sell card for future
381     function _initCardDetails(uint8 cardId, uint price) internal
382         returns (bool success)
383     {
384         // priceLease, leaseDuration set to default value(= 0)
385         cardDetailsStructs[cardId].id = cardId;
386         cardDetailsStructs[cardId].price = price;
387         cardDetailsStructs[cardId].availableBuy = false;
388         cardDetailsStructs[cardId].availableLease = false;
389         cardDetailsList.push(cardId);
390         return true;
391     }
392 
393     /// Send split amounts to respective balances
394     function _applyShare(address _seller, address _auctioneer, uint _cut) internal
395         returns (bool success)
396     {
397         // Compute share
398         uint256 auctioneerCut = _computeCut(msg.value, _cut);
399         uint256 sellerProceeds = msg.value - auctioneerCut;
400         // Credit seller balance
401         pendingWithdrawals[_seller] += sellerProceeds;
402         // Credit auctionner balance
403         pendingWithdrawals[_auctioneer] += auctioneerCut;
404         return true;
405     }
406 
407     /// Compute _cut from a _price 
408     function _computeCut(uint256 _price, uint256 _cut) internal pure
409         returns (uint256)
410     {
411         return _price * _cut / 10000;
412     }
413 }