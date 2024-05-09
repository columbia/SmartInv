1 pragma solidity ^0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 contract Ownable {
6   address public owner;
7 
8 
9   event OwnershipRenounced(address indexed previousOwner);
10   event OwnershipTransferred(
11     address indexed previousOwner,
12     address indexed newOwner
13   );
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   constructor() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to relinquish control of the contract.
34    */
35   function renounceOwnership() public onlyOwner {
36     emit OwnershipRenounced(owner);
37     owner = address(0);
38   }
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param _newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address _newOwner) public onlyOwner {
45     _transferOwnership(_newOwner);
46   }
47 
48   /**
49    * @dev Transfers control of the contract to a newOwner.
50    * @param _newOwner The address to transfer ownership to.
51    */
52   function _transferOwnership(address _newOwner) internal {
53     require(_newOwner != address(0));
54     emit OwnershipTransferred(owner, _newOwner);
55     owner = _newOwner;
56   }
57 }
58 
59 contract ERC20 {
60     function transfer(address _to, uint256 _value) external returns (bool);
61     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
62 }
63 
64 
65 contract V00_Marketplace is Ownable {
66 
67     /**
68     * @notice All events have the same indexed signature offsets for easy filtering
69     */
70     event MarketplaceData  (address indexed party, bytes32 ipfsHash);
71     event AffiliateAdded   (address indexed party, bytes32 ipfsHash);
72     event AffiliateRemoved (address indexed party, bytes32 ipfsHash);
73     event ListingCreated   (address indexed party, uint indexed listingID, bytes32 ipfsHash);
74     event ListingUpdated   (address indexed party, uint indexed listingID, bytes32 ipfsHash);
75     event ListingWithdrawn (address indexed party, uint indexed listingID, bytes32 ipfsHash);
76     event ListingArbitrated(address indexed party, uint indexed listingID, bytes32 ipfsHash);
77     event ListingData      (address indexed party, uint indexed listingID, bytes32 ipfsHash);
78     event OfferCreated     (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
79     event OfferAccepted    (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
80     event OfferFinalized   (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
81     event OfferWithdrawn   (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
82     event OfferFundsAdded  (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
83     event OfferDisputed    (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
84     event OfferRuling      (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash, uint ruling);
85     event OfferData        (address indexed party, uint indexed listingID, uint indexed offerID, bytes32 ipfsHash);
86 
87     struct Listing {
88         address seller;     // Seller wallet / identity contract / other contract
89         uint deposit;       // Deposit in Origin Token
90         address depositManager; // Address that decides token distribution
91     }
92 
93     struct Offer {
94         uint value;         // Amount in Eth or ERC20 buyer is offering
95         uint commission;    // Amount of commission earned if offer is finalized
96         uint refund;        // Amount to refund buyer upon finalization
97         ERC20 currency;     // Currency of listing
98         address buyer;      // Buyer wallet / identity contract / other contract
99         address affiliate;  // Address to send any commission
100         address arbitrator; // Address that settles disputes
101         uint finalizes;     // Timestamp offer finalizes
102         uint8 status;       // 0: Undefined, 1: Created, 2: Accepted, 3: Disputed
103     }
104 
105     Listing[] public listings;
106     mapping(uint => Offer[]) public offers; // listingID => Offers
107     mapping(address => bool) public allowedAffiliates;
108 
109     ERC20 public tokenAddr; // Origin Token address
110 
111     constructor(address _tokenAddr) public {
112         owner = msg.sender;
113         setTokenAddr(_tokenAddr); // Origin Token contract
114         allowedAffiliates[0x0] = true; // Allow null affiliate by default
115     }
116 
117     // @dev Return the total number of listings
118     function totalListings() public view returns (uint) {
119         return listings.length;
120     }
121 
122     // @dev Return the total number of offers
123     function totalOffers(uint listingID) public view returns (uint) {
124         return offers[listingID].length;
125     }
126 
127     // @dev Seller creates listing
128     function createListing(bytes32 _ipfsHash, uint _deposit, address _depositManager)
129         public
130     {
131         _createListing(msg.sender, _ipfsHash, _deposit, _depositManager);
132     }
133 
134     // @dev Can only be called by token
135     function createListingWithSender(
136         address _seller,
137         bytes32 _ipfsHash,
138         uint _deposit,
139         address _depositManager
140     )
141         public returns (bool)
142     {
143         require(msg.sender == address(tokenAddr), "Token must call");
144         _createListing(_seller, _ipfsHash, _deposit, _depositManager);
145         return true;
146     }
147 
148     // Private
149     function _createListing(
150         address _seller,
151         bytes32 _ipfsHash,  // IPFS JSON with details, pricing, availability
152         uint _deposit,      // Deposit in Origin Token
153         address _depositManager // Address of listing depositManager
154     )
155         private
156     {
157         /* require(_deposit > 0); // Listings must deposit some amount of Origin Token */
158         require(_depositManager != 0x0, "Must specify depositManager");
159 
160         listings.push(Listing({
161             seller: _seller,
162             deposit: _deposit,
163             depositManager: _depositManager
164         }));
165 
166         if (_deposit > 0) {
167             tokenAddr.transferFrom(_seller, this, _deposit); // Transfer Origin Token
168         }
169         emit ListingCreated(_seller, listings.length - 1, _ipfsHash);
170     }
171 
172     // @dev Seller updates listing
173     function updateListing(
174         uint listingID,
175         bytes32 _ipfsHash,
176         uint _additionalDeposit
177     ) public {
178         _updateListing(msg.sender, listingID, _ipfsHash, _additionalDeposit);
179     }
180 
181     function updateListingWithSender(
182         address _seller,
183         uint listingID,
184         bytes32 _ipfsHash,
185         uint _additionalDeposit
186     )
187         public returns (bool)
188     {
189         require(msg.sender == address(tokenAddr), "Token must call");
190         _updateListing(_seller, listingID, _ipfsHash, _additionalDeposit);
191         return true;
192     }
193 
194     function _updateListing(
195         address _seller,
196         uint listingID,
197         bytes32 _ipfsHash,      // Updated IPFS hash
198         uint _additionalDeposit // Additional deposit to add
199     ) private {
200         Listing storage listing = listings[listingID];
201         require(listing.seller == _seller, "Seller must call");
202 
203         if (_additionalDeposit > 0) {
204             tokenAddr.transferFrom(_seller, this, _additionalDeposit);
205             listing.deposit += _additionalDeposit;
206         }
207 
208         emit ListingUpdated(listing.seller, listingID, _ipfsHash);
209     }
210 
211     // @dev Listing depositManager withdraws listing. IPFS hash contains reason for withdrawl.
212     function withdrawListing(uint listingID, address _target, bytes32 _ipfsHash) public {
213         Listing storage listing = listings[listingID];
214         require(msg.sender == listing.depositManager, "Must be depositManager");
215         require(_target != 0x0, "No target");
216         tokenAddr.transfer(_target, listing.deposit); // Send deposit to target
217         emit ListingWithdrawn(_target, listingID, _ipfsHash);
218     }
219 
220     // @dev Buyer makes offer.
221     function makeOffer(
222         uint listingID,
223         bytes32 _ipfsHash,   // IPFS hash containing offer data
224         uint _finalizes,     // Timestamp an accepted offer will finalize
225         address _affiliate,  // Address to send any required commission to
226         uint256 _commission, // Amount of commission to send in Origin Token if offer finalizes
227         uint _value,         // Offer amount in ERC20 or Eth
228         ERC20 _currency,     // ERC20 token address or 0x0 for Eth
229         address _arbitrator  // Escrow arbitrator
230     )
231         public
232         payable
233     {
234         bool affiliateWhitelistDisabled = allowedAffiliates[address(this)];
235         require(
236             affiliateWhitelistDisabled || allowedAffiliates[_affiliate],
237             "Affiliate not allowed"
238         );
239 
240         if (_affiliate == 0x0) {
241             // Avoid commission tokens being trapped in marketplace contract.
242             require(_commission == 0, "commission requires affiliate");
243         }
244 
245         offers[listingID].push(Offer({
246             status: 1,
247             buyer: msg.sender,
248             finalizes: _finalizes,
249             affiliate: _affiliate,
250             commission: _commission,
251             currency: _currency,
252             value: _value,
253             arbitrator: _arbitrator,
254             refund: 0
255         }));
256 
257         if (address(_currency) == 0x0) { // Listing is in ETH
258             require(msg.value == _value, "ETH value doesn't match offer");
259         } else { // Listing is in ERC20
260             require(msg.value == 0, "ETH would be lost");
261             require(
262                 _currency.transferFrom(msg.sender, this, _value),
263                 "transferFrom failed"
264             );
265         }
266 
267         emit OfferCreated(msg.sender, listingID, offers[listingID].length-1, _ipfsHash);
268     }
269 
270     // @dev Make new offer after withdrawl
271     function makeOffer(
272         uint listingID,
273         bytes32 _ipfsHash,
274         uint _finalizes,
275         address _affiliate,
276         uint256 _commission,
277         uint _value,
278         ERC20 _currency,
279         address _arbitrator,
280         uint _withdrawOfferID
281     )
282         public
283         payable
284     {
285         withdrawOffer(listingID, _withdrawOfferID, _ipfsHash);
286         makeOffer(listingID, _ipfsHash, _finalizes, _affiliate, _commission, _value, _currency, _arbitrator);
287     }
288 
289     // @dev Seller accepts offer
290     function acceptOffer(uint listingID, uint offerID, bytes32 _ipfsHash) public {
291         Listing storage listing = listings[listingID];
292         Offer storage offer = offers[listingID][offerID];
293         require(msg.sender == listing.seller, "Seller must accept");
294         require(offer.status == 1, "status != created");
295         require(
296             listing.deposit >= offer.commission,
297             "deposit must cover commission"
298         );
299         if (offer.finalizes < 1000000000) { // Relative finalization window
300             offer.finalizes = now + offer.finalizes;
301         }
302         listing.deposit -= offer.commission; // Accepting an offer puts Origin Token into escrow
303         offer.status = 2; // Set offer to 'Accepted'
304         emit OfferAccepted(msg.sender, listingID, offerID, _ipfsHash);
305     }
306 
307     // @dev Buyer withdraws offer. IPFS hash contains reason for withdrawl.
308     function withdrawOffer(uint listingID, uint offerID, bytes32 _ipfsHash) public {
309         Listing storage listing = listings[listingID];
310         Offer storage offer = offers[listingID][offerID];
311         require(
312             msg.sender == offer.buyer || msg.sender == listing.seller,
313             "Restricted to buyer or seller"
314         );
315         require(offer.status == 1, "status != created");
316         refundBuyer(listingID, offerID);
317         emit OfferWithdrawn(msg.sender, listingID, offerID, _ipfsHash);
318         delete offers[listingID][offerID];
319     }
320 
321     // @dev Buyer adds extra funds to an accepted offer.
322     function addFunds(uint listingID, uint offerID, bytes32 _ipfsHash, uint _value) public payable {
323         Offer storage offer = offers[listingID][offerID];
324         require(msg.sender == offer.buyer, "Buyer must call");
325         require(offer.status == 2, "status != accepted");
326         if (address(offer.currency) == 0x0) { // Listing is in ETH
327             require(
328                 msg.value == _value,
329                 "sent != offered value"
330             );
331         } else { // Listing is in ERC20
332             require(msg.value == 0, "ETH must not be sent");
333             require(
334                 offer.currency.transferFrom(msg.sender, this, _value),
335                 "transferFrom failed"
336             );
337         }
338         offer.value += _value;
339         emit OfferFundsAdded(msg.sender, listingID, offerID, _ipfsHash);
340     }
341 
342     // @dev Buyer must finalize transaction to receive commission
343     function finalize(uint listingID, uint offerID, bytes32 _ipfsHash) public {
344         Listing storage listing = listings[listingID];
345         Offer storage offer = offers[listingID][offerID];
346         if (now <= offer.finalizes) { // Only buyer can finalize before finalization window
347             require(
348                 msg.sender == offer.buyer,
349                 "Only buyer can finalize"
350             );
351         } else { // Allow both seller and buyer to finalize if finalization window has passed
352             require(
353                 msg.sender == offer.buyer || msg.sender == listing.seller,
354                 "Seller or buyer must finalize"
355             );
356         }
357         require(offer.status == 2, "status != accepted");
358         paySeller(listingID, offerID); // Pay seller
359         if (msg.sender == offer.buyer) { // Only pay commission if buyer is finalizing
360             payCommission(listingID, offerID);
361         }
362         emit OfferFinalized(msg.sender, listingID, offerID, _ipfsHash);
363         delete offers[listingID][offerID];
364     }
365 
366     // @dev Buyer or seller can dispute transaction during finalization window
367     function dispute(uint listingID, uint offerID, bytes32 _ipfsHash) public {
368         Listing storage listing = listings[listingID];
369         Offer storage offer = offers[listingID][offerID];
370         require(
371             msg.sender == offer.buyer || msg.sender == listing.seller,
372             "Must be seller or buyer"
373         );
374         require(offer.status == 2, "status != accepted");
375         require(now <= offer.finalizes, "Already finalized");
376         offer.status = 3; // Set status to "Disputed"
377         emit OfferDisputed(msg.sender, listingID, offerID, _ipfsHash);
378     }
379 
380     // @dev Called by arbitrator
381     function executeRuling(
382         uint listingID,
383         uint offerID,
384         bytes32 _ipfsHash,
385         uint _ruling, // 0: Seller, 1: Buyer, 2: Com + Seller, 3: Com + Buyer
386         uint _refund
387     ) public {
388         Offer storage offer = offers[listingID][offerID];
389         require(msg.sender == offer.arbitrator, "Must be arbitrator");
390         require(offer.status == 3, "status != disputed");
391         require(_refund <= offer.value, "refund too high");
392         offer.refund = _refund;
393         if (_ruling & 1 == 1) {
394             refundBuyer(listingID, offerID);
395         } else  {
396             paySeller(listingID, offerID);
397         }
398         if (_ruling & 2 == 2) {
399             payCommission(listingID, offerID);
400         } else  { // Refund commission to seller
401             listings[listingID].deposit += offer.commission;
402         }
403         emit OfferRuling(offer.arbitrator, listingID, offerID, _ipfsHash, _ruling);
404         delete offers[listingID][offerID];
405     }
406 
407     // @dev Sets the amount that a seller wants to refund to a buyer.
408     function updateRefund(uint listingID, uint offerID, uint _refund, bytes32 _ipfsHash) public {
409         Offer storage offer = offers[listingID][offerID];
410         Listing storage listing = listings[listingID];
411         require(msg.sender == listing.seller, "Seller must call");
412         require(offer.status == 2, "status != accepted");
413         require(_refund <= offer.value, "Excessive refund");
414         offer.refund = _refund;
415         emit OfferData(msg.sender, listingID, offerID, _ipfsHash);
416     }
417 
418     // @dev Refunds buyer in ETH or ERC20 - used by 1) executeRuling() and 2) to allow a seller to refund a purchase
419     function refundBuyer(uint listingID, uint offerID) private {
420         Offer storage offer = offers[listingID][offerID];
421         if (address(offer.currency) == 0x0) {
422             require(offer.buyer.send(offer.value), "ETH refund failed");
423         } else {
424             require(
425                 offer.currency.transfer(offer.buyer, offer.value),
426                 "Refund failed"
427             );
428         }
429     }
430 
431     // @dev Pay seller in ETH or ERC20
432     function paySeller(uint listingID, uint offerID) private {
433         Listing storage listing = listings[listingID];
434         Offer storage offer = offers[listingID][offerID];
435         uint value = offer.value - offer.refund;
436 
437         if (address(offer.currency) == 0x0) {
438             require(offer.buyer.send(offer.refund), "ETH refund failed");
439             require(listing.seller.send(value), "ETH send failed");
440         } else {
441             require(
442                 offer.currency.transfer(offer.buyer, offer.refund),
443                 "Refund failed"
444             );
445             require(
446                 offer.currency.transfer(listing.seller, value),
447                 "Transfer failed"
448             );
449         }
450     }
451 
452     // @dev Pay commission to affiliate
453     function payCommission(uint listingID, uint offerID) private {
454         Offer storage offer = offers[listingID][offerID];
455         if (offer.affiliate != 0x0) {
456             require(
457                 tokenAddr.transfer(offer.affiliate, offer.commission),
458                 "Commission transfer failed"
459             );
460         }
461     }
462 
463     // @dev Associate ipfs data with the marketplace
464     function addData(bytes32 ipfsHash) public {
465         emit MarketplaceData(msg.sender, ipfsHash);
466     }
467 
468     // @dev Associate ipfs data with a listing
469     function addData(uint listingID, bytes32 ipfsHash) public {
470         emit ListingData(msg.sender, listingID, ipfsHash);
471     }
472 
473     // @dev Associate ipfs data with an offer
474     function addData(uint listingID, uint offerID, bytes32 ipfsHash) public {
475         emit OfferData(msg.sender, listingID, offerID, ipfsHash);
476     }
477 
478     // @dev Allow listing depositManager to send deposit
479     function sendDeposit(uint listingID, address target, uint value, bytes32 ipfsHash) public {
480         Listing storage listing = listings[listingID];
481         require(listing.depositManager == msg.sender, "depositManager must call");
482         require(listing.deposit >= value, "Value too high");
483         listing.deposit -= value;
484         require(tokenAddr.transfer(target, value), "Transfer failed");
485         emit ListingArbitrated(target, listingID, ipfsHash);
486     }
487 
488     // @dev Set the address of the Origin token contract
489     function setTokenAddr(address _tokenAddr) public onlyOwner {
490         tokenAddr = ERC20(_tokenAddr);
491     }
492 
493     // @dev Add affiliate to whitelist. Set to address(this) to disable.
494     function addAffiliate(address _affiliate, bytes32 ipfsHash) public onlyOwner {
495         allowedAffiliates[_affiliate] = true;
496         emit AffiliateAdded(_affiliate, ipfsHash);
497     }
498 
499     // @dev Remove affiliate from whitelist.
500     function removeAffiliate(address _affiliate, bytes32 ipfsHash) public onlyOwner {
501         delete allowedAffiliates[_affiliate];
502         emit AffiliateRemoved(_affiliate, ipfsHash);
503     }
504 }