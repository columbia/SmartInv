1 pragma solidity ^0.4.24;
2 
3 /*
4  * Origin Protocol
5  * https://originprotocol.com
6  *
7  * Released under the MIT license
8  * https://github.com/OriginProtocol
9  *
10  * Copyright 2019 Origin Protocol, Inc
11  *
12  * Permission is hereby granted, free of charge, to any person obtaining a copy
13  * of this software and associated documentation files (the "Software"), to deal
14  * in the Software without restriction, including without limitation the rights
15  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16  * copies of the Software, and to permit persons to whom the Software is
17  * furnished to do so, subject to the following conditions:
18  *
19  * The above copyright notice and this permission notice shall be included in
20  * all copies or substantial portions of the Software.
21  * 
22  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
25  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
28  * SOFTWARE.
29  */
30 
31 /**
32  * @title Ownable
33  * @dev The Ownable contract has an owner address, and provides basic authorization control
34  * functions, this simplifies the implementation of "user permissions".
35  */
36 contract Ownable {
37   address public owner;
38 
39 
40   event OwnershipRenounced(address indexed previousOwner);
41   event OwnershipTransferred(
42     address indexed previousOwner,
43     address indexed newOwner
44   );
45 
46 
47   /**
48    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
49    * account.
50    */
51   constructor() public {
52     owner = msg.sender;
53   }
54 
55   /**
56    * @dev Throws if called by any account other than the owner.
57    */
58   modifier onlyOwner() {
59     require(msg.sender == owner);
60     _;
61   }
62 
63   /**
64    * @dev Allows the current owner to relinquish control of the contract.
65    * @notice Renouncing to ownership will leave the contract without an owner.
66    * It will not be possible to call the functions with the `onlyOwner`
67    * modifier anymore.
68    */
69   function renounceOwnership() public onlyOwner {
70     emit OwnershipRenounced(owner);
71     owner = address(0);
72   }
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param _newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address _newOwner) public onlyOwner {
79     _transferOwnership(_newOwner);
80   }
81 
82   /**
83    * @dev Transfers control of the contract to a newOwner.
84    * @param _newOwner The address to transfer ownership to.
85    */
86   function _transferOwnership(address _newOwner) internal {
87     require(_newOwner != address(0));
88     emit OwnershipTransferred(owner, _newOwner);
89     owner = _newOwner;
90   }
91 }
92 
93 
94 contract ERC20 {
95     function transfer(address _to, uint256 _value) external returns (bool);
96     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
97 }
98 
99 
100 /**
101  * @title A Marketplace contract for managing listings, offers, payments, escrow and arbitration
102  *
103  * Listings may be priced in ETH or ERC20.
104  */
105 contract V01_Marketplace is Ownable {
106 
107     /**
108     * @notice All events have the same indexed signature offsets for easy filtering
109     */
110     event MarketplaceData  (address indexed party, bytes32 ipfsHash);
111     event AffiliateAdded   (address indexed party, bytes32 ipfsHash);
112     event AffiliateRemoved (address indexed party, bytes32 ipfsHash);
113     event ListingCreated   (address indexed party, uint indexed listingID, bytes32 ipfsHash);
114     event ListingUpdated   (address indexed party, uint indexed listingID, bytes32 ipfsHash);
115     event ListingWithdrawn (address indexed party, uint indexed listingID, bytes32 ipfsHash);
116     event ListingArbitrated(address indexed party, uint indexed listingID, bytes32 ipfsHash);
117     event ListingData      (address indexed party, uint indexed listingID, bytes32 ipfsHash);
118     event OfferCreated     (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
119     event OfferAccepted    (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
120     event OfferFinalized   (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
121     event OfferWithdrawn   (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
122     event OfferFundsAdded  (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
123     event OfferDisputed    (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
124     event OfferRuling      (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash, uint ruling);
125     event OfferData        (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
126 
127     struct Listing {
128         address seller;     // Seller wallet / identity contract / other contract
129         uint deposit;       // Deposit in Origin Token
130         address depositManager; // Address that decides token distribution
131     }
132 
133     struct Offer {
134         uint value;         // Amount in Eth or ERC20 buyer is offering
135         uint commission;    // Amount of commission earned if offer is finalized
136         uint refund;        // Amount to refund buyer upon finalization
137         ERC20 currency;     // Currency of listing
138         address buyer;      // Buyer wallet / identity contract / other contract
139         address affiliate;  // Address to send any commission
140         address arbitrator; // Address that settles disputes
141         uint finalizes;     // Timestamp offer finalizes
142         uint8 status;       // 0: Undefined, 1: Created, 2: Accepted, 3: Disputed
143     }
144 
145     Listing[] public listings;
146     mapping(uint => Offer[]) public offers; // listingID => Offers
147     mapping(address => bool) public allowedAffiliates;
148 
149     ERC20 public tokenAddr; // Origin Token address
150 
151     constructor(address _tokenAddr) public {
152         owner = msg.sender;
153         setTokenAddr(_tokenAddr); // Origin Token contract
154         allowedAffiliates[0x0] = true; // Allow null affiliate by default
155     }
156 
157     // @dev Return the total number of listings
158     function totalListings() public view returns (uint) {
159         return listings.length;
160     }
161 
162     // @dev Return the total number of offers
163     function totalOffers(uint listingID) public view returns (uint) {
164         return offers[listingID].length;
165     }
166 
167     // @dev Seller creates listing
168     function createListing(bytes32 _ipfsHash, uint _deposit, address _depositManager)
169         public
170     {
171         _createListing(msg.sender, _ipfsHash, _deposit, _depositManager);
172     }
173 
174     // @dev Can only be called by token
175     function createListingWithSender(
176         address _seller,
177         bytes32 _ipfsHash,
178         uint _deposit,
179         address _depositManager
180     )
181         public returns (bool)
182     {
183         require(msg.sender == address(tokenAddr), "Token must call");
184         _createListing(_seller, _ipfsHash, _deposit, _depositManager);
185         return true;
186     }
187 
188     // Private
189     function _createListing(
190         address _seller,
191         bytes32 _ipfsHash,  // IPFS JSON with details, pricing, availability
192         uint _deposit,      // Deposit in Origin Token
193         address _depositManager // Address of listing depositManager
194     )
195         private
196     {
197         /* require(_deposit > 0); // Listings must deposit some amount of Origin Token */
198         require(_depositManager != 0x0, "Must specify depositManager");
199 
200         listings.push(Listing({
201             seller: _seller,
202             deposit: _deposit,
203             depositManager: _depositManager
204         }));
205 
206         if (_deposit > 0) {
207             require(
208                 tokenAddr.transferFrom(_seller, this, _deposit), // Transfer Origin Token
209                 "transferFrom failed"
210             );
211         }
212         emit ListingCreated(_seller, listings.length - 1, _ipfsHash);
213     }
214 
215     // @dev Seller updates listing
216     function updateListing(
217         uint listingID,
218         bytes32 _ipfsHash,
219         uint _additionalDeposit
220     ) public {
221         _updateListing(msg.sender, listingID, _ipfsHash, _additionalDeposit);
222     }
223 
224     function updateListingWithSender(
225         address _seller,
226         uint listingID,
227         bytes32 _ipfsHash,
228         uint _additionalDeposit
229     )
230         public returns (bool)
231     {
232         require(msg.sender == address(tokenAddr), "Token must call");
233         _updateListing(_seller, listingID, _ipfsHash, _additionalDeposit);
234         return true;
235     }
236 
237     function _updateListing(
238         address _seller,
239         uint listingID,
240         bytes32 _ipfsHash,      // Updated IPFS hash
241         uint _additionalDeposit // Additional deposit to add
242     ) private {
243         Listing storage listing = listings[listingID];
244         require(listing.seller == _seller, "Seller must call");
245 
246         if (_additionalDeposit > 0) {
247             listing.deposit += _additionalDeposit;
248             require(
249                 tokenAddr.transferFrom(_seller, this, _additionalDeposit),
250                 "transferFrom failed"
251             );
252         }
253 
254         emit ListingUpdated(listing.seller, listingID, _ipfsHash);
255     }
256 
257     // @dev Listing depositManager withdraws listing. IPFS hash contains reason for withdrawl.
258     function withdrawListing(uint listingID, address _target, bytes32 _ipfsHash) public {
259         Listing storage listing = listings[listingID];
260         require(msg.sender == listing.depositManager, "Must be depositManager");
261         require(_target != 0x0, "No target");
262         uint deposit = listing.deposit;
263         listing.deposit = 0; // Prevent multiple deposit withdrawals
264         require(tokenAddr.transfer(_target, deposit), "transfer failed"); // Send deposit to target
265         emit ListingWithdrawn(_target, listingID, _ipfsHash);
266     }
267 
268     // @dev Buyer makes offer.
269     function makeOffer(
270         uint listingID,
271         bytes32 _ipfsHash,   // IPFS hash containing offer data
272         uint _finalizes,     // Timestamp an accepted offer will finalize
273         address _affiliate,  // Address to send any required commission to
274         uint256 _commission, // Amount of commission to send in Origin Token if offer finalizes
275         uint _value,         // Offer amount in ERC20 or Eth
276         ERC20 _currency,     // ERC20 token address or 0x0 for Eth
277         address _arbitrator  // Escrow arbitrator
278     )
279         public
280         payable
281     {
282         bool affiliateWhitelistDisabled = allowedAffiliates[address(this)];
283         require(
284             affiliateWhitelistDisabled || allowedAffiliates[_affiliate],
285             "Affiliate not allowed"
286         );
287 
288         if (_affiliate == 0x0) {
289             // Avoid commission tokens being trapped in marketplace contract.
290             require(_commission == 0, "commission requires affiliate");
291         }
292 
293         offers[listingID].push(Offer({
294             status: 1,
295             buyer: msg.sender,
296             finalizes: _finalizes,
297             affiliate: _affiliate,
298             commission: _commission,
299             currency: _currency,
300             value: _value,
301             arbitrator: _arbitrator,
302             refund: 0
303         }));
304 
305         if (address(_currency) == 0x0) { // Listing is in ETH
306             require(msg.value == _value, "ETH value doesn't match offer");
307         } else { // Listing is in ERC20
308             require(msg.value == 0, "ETH would be lost");
309             require(
310                 _currency.transferFrom(msg.sender, this, _value),
311                 "transferFrom failed"
312             );
313         }
314 
315         emit OfferCreated(msg.sender, listingID, offers[listingID].length-1, _ipfsHash);
316     }
317 
318     // @dev Seller accepts offer
319     function acceptOffer(uint listingID, uint offerID, bytes32 _ipfsHash) public {
320         Listing storage listing = listings[listingID];
321         Offer storage offer = offers[listingID][offerID];
322         require(msg.sender == listing.seller, "Seller must accept");
323         require(offer.status == 1, "status != created");
324         require(
325             listing.deposit >= offer.commission,
326             "deposit must cover commission"
327         );
328         if (offer.finalizes < 1000000000) { // Relative finalization window
329             offer.finalizes = now + offer.finalizes;
330         }
331         listing.deposit -= offer.commission; // Accepting an offer puts Origin Token into escrow
332         offer.status = 2; // Set offer to 'Accepted'
333         emit OfferAccepted(msg.sender, listingID, offerID, _ipfsHash);
334     }
335 
336     // @dev Buyer withdraws offer. IPFS hash contains reason for withdrawl.
337     function withdrawOffer(uint listingID, uint offerID, bytes32 _ipfsHash) public {
338         Listing storage listing = listings[listingID];
339         Offer memory offer = offers[listingID][offerID];
340         require(
341             msg.sender == offer.buyer || msg.sender == listing.seller,
342             "Restricted to buyer or seller"
343         );
344         require(offer.status == 1, "status != created");
345         delete offers[listingID][offerID];
346         refundBuyer(offer.buyer, offer.currency, offer.value);
347         emit OfferWithdrawn(msg.sender, listingID, offerID, _ipfsHash);
348     }
349 
350     // @dev Buyer adds extra funds to an accepted offer.
351     function addFunds(uint listingID, uint offerID, bytes32 _ipfsHash, uint _value) public payable {
352         Offer storage offer = offers[listingID][offerID];
353         require(msg.sender == offer.buyer, "Buyer must call");
354         require(offer.status == 2, "status != accepted");
355         offer.value += _value;
356         if (address(offer.currency) == 0x0) { // Listing is in ETH
357             require(
358                 msg.value == _value,
359                 "sent != offered value"
360             );
361         } else { // Listing is in ERC20
362             require(msg.value == 0, "ETH must not be sent");
363             require(
364                 offer.currency.transferFrom(msg.sender, this, _value),
365                 "transferFrom failed"
366             );
367         }
368         emit OfferFundsAdded(msg.sender, listingID, offerID, _ipfsHash);
369     }
370 
371     // @dev Buyer must finalize transaction to receive commission
372     function finalize(uint listingID, uint offerID, bytes32 _ipfsHash) public {
373         Listing storage listing = listings[listingID];
374         Offer memory offer = offers[listingID][offerID];
375         if (now <= offer.finalizes) { // Only buyer can finalize before finalization window
376             require(
377                 msg.sender == offer.buyer,
378                 "Only buyer can finalize"
379             );
380         } else { // Allow both seller and buyer to finalize if finalization window has passed
381             require(
382                 msg.sender == offer.buyer || msg.sender == listing.seller,
383                 "Seller or buyer must finalize"
384             );
385         }
386         require(offer.status == 2, "status != accepted");
387         delete offers[listingID][offerID];
388 
389         if (msg.sender != offer.buyer) {
390             listing.deposit += offer.commission; // Refund commission to seller
391         } else {
392             // Only pay commission if buyer is finalizing
393             payCommission(offer.affiliate, offer.commission);
394         }
395 
396         paySeller(listing.seller, offer.buyer, offer.currency, offer.value, offer.refund); // Pay seller
397 
398         emit OfferFinalized(msg.sender, listingID, offerID, _ipfsHash);
399     }
400 
401     // @dev Buyer or seller can dispute transaction during finalization window
402     function dispute(uint listingID, uint offerID, bytes32 _ipfsHash) public {
403         Listing storage listing = listings[listingID];
404         Offer storage offer = offers[listingID][offerID];
405         require(
406             msg.sender == offer.buyer || msg.sender == listing.seller,
407             "Must be seller or buyer"
408         );
409         require(offer.status == 2, "status != accepted");
410         require(now <= offer.finalizes, "Already finalized");
411         offer.status = 3; // Set status to "Disputed"
412         emit OfferDisputed(msg.sender, listingID, offerID, _ipfsHash);
413     }
414 
415     // @dev Called by arbitrator
416     function executeRuling(
417         uint listingID,
418         uint offerID,
419         bytes32 _ipfsHash,
420         uint _ruling, // 0: Seller, 1: Buyer, 2: Com + Seller, 3: Com + Buyer
421         uint _refund
422     ) public {
423         Listing storage listing = listings[listingID];
424         Offer memory offer = offers[listingID][offerID];
425         require(msg.sender == offer.arbitrator, "Must be arbitrator");
426         require(offer.status == 3, "status != disputed");
427         require(_refund <= offer.value, "refund too high");
428         delete offers[listingID][offerID];
429         if (_ruling & 2 == 2) {
430             payCommission(offer.affiliate, offer.commission);
431         } else  { // Refund commission to seller
432             listings[listingID].deposit += offer.commission;
433         }
434         if (_ruling & 1 == 1) {
435             refundBuyer(offer.buyer, offer.currency, offer.value);
436         } else  {
437             paySeller(listing.seller, offer.buyer, offer.currency, offer.value, _refund); // Pay seller
438         }
439         emit OfferRuling(offer.arbitrator, listingID, offerID, _ipfsHash, _ruling);
440     }
441 
442     // @dev Sets the amount that a seller wants to refund to a buyer.
443     function updateRefund(uint listingID, uint offerID, uint _refund, bytes32 _ipfsHash) public {
444         Offer storage offer = offers[listingID][offerID];
445         Listing storage listing = listings[listingID];
446         require(msg.sender == listing.seller, "Seller must call");
447         require(offer.status == 2, "status != accepted");
448         require(_refund <= offer.value, "Excessive refund");
449         offer.refund = _refund;
450         emit OfferData(msg.sender, listingID, offerID, _ipfsHash);
451     }
452 
453     // @dev Refunds buyer in ETH or ERC20 - used by 1) executeRuling() and 2) to allow a seller to refund a purchase
454     function refundBuyer(address buyer, ERC20 currency, uint value) private {
455         if (address(currency) == 0x0) {
456             require(buyer.send(value), "ETH refund failed");
457         } else {
458             require(
459                 currency.transfer(buyer, value),
460                 "Refund failed"
461             );
462         }
463     }
464 
465     // @dev Pay seller in ETH or ERC20
466     function paySeller(address seller, address buyer, ERC20 currency, uint offerValue, uint offerRefund) private {
467         uint value = offerValue - offerRefund;
468 
469         if (address(currency) == 0x0) {
470             require(buyer.send(offerRefund), "ETH refund failed");
471             require(seller.send(value), "ETH send failed");
472         } else {
473             require(
474                 currency.transfer(buyer, offerRefund),
475                 "Refund failed"
476             );
477             require(
478                 currency.transfer(seller, value),
479                 "Transfer failed"
480             );
481         }
482     }
483 
484     // @dev Pay commission to affiliate
485     function payCommission(address affiliate, uint commission) private {
486         if (affiliate != 0x0) {
487             require(
488                 tokenAddr.transfer(affiliate, commission),
489                 "Commission transfer failed"
490             );
491         }
492     }
493 
494     // @dev Associate ipfs data with the marketplace
495     function addData(bytes32 ipfsHash) public {
496         emit MarketplaceData(msg.sender, ipfsHash);
497     }
498 
499     // @dev Associate ipfs data with a listing
500     function addData(uint listingID, bytes32 ipfsHash) public {
501         emit ListingData(msg.sender, listingID, ipfsHash);
502     }
503 
504     // @dev Associate ipfs data with an offer
505     function addData(uint listingID, uint offerID, bytes32 ipfsHash) public {
506         emit OfferData(msg.sender, listingID, offerID, ipfsHash);
507     }
508 
509     // @dev Allow listing depositManager to send deposit
510     function sendDeposit(uint listingID, address target, uint value, bytes32 ipfsHash) public {
511         Listing storage listing = listings[listingID];
512         require(listing.depositManager == msg.sender, "depositManager must call");
513         require(listing.deposit >= value, "Value too high");
514         listing.deposit -= value;
515         require(tokenAddr.transfer(target, value), "Transfer failed");
516         emit ListingArbitrated(target, listingID, ipfsHash);
517     }
518 
519     // @dev Set the address of the Origin token contract
520     function setTokenAddr(address _tokenAddr) public onlyOwner {
521         tokenAddr = ERC20(_tokenAddr);
522     }
523 
524     // @dev Add affiliate to whitelist. Set to address(this) to disable.
525     function addAffiliate(address _affiliate, bytes32 ipfsHash) public onlyOwner {
526         allowedAffiliates[_affiliate] = true;
527         emit AffiliateAdded(_affiliate, ipfsHash);
528     }
529 
530     // @dev Remove affiliate from whitelist.
531     function removeAffiliate(address _affiliate, bytes32 ipfsHash) public onlyOwner {
532         delete allowedAffiliates[_affiliate];
533         emit AffiliateRemoved(_affiliate, ipfsHash);
534     }
535 }