1 pragma solidity ^0.4.18;
2 
3 contract TittyBase {
4 
5     event Transfer(address indexed from, address indexed to);
6     event Creation(address indexed from, uint256 tittyId, uint256 wpId);
7     event AddAccessory(uint256 tittyId, uint256 accessoryId);
8 
9     struct Accessory {
10 
11         uint256 id;
12         string name;
13         uint256 price;
14         bool isActive;
15 
16     }
17 
18     struct Titty {
19 
20         uint256 id;
21         string name;
22         string gender;
23         uint256 originalPrice;
24         uint256 salePrice;
25         uint256[] accessories;
26         bool forSale;
27     }
28 
29     //Storage
30     Titty[] Titties;
31     Accessory[] Accessories;
32     mapping (uint256 => address) public tittyIndexToOwner;
33     mapping (address => uint256) public ownerTittiesCount;
34     mapping (uint256 => address) public tittyApproveIndex;
35 
36     function _transfer(address _from, address _to, uint256 _tittyId) internal {
37 
38         ownerTittiesCount[_to]++;
39 
40         tittyIndexToOwner[_tittyId] = _to;
41         if (_from != address(0)) {
42             ownerTittiesCount[_from]--;
43             delete tittyApproveIndex[_tittyId];
44         }
45 
46         Transfer(_from, _to);
47 
48     }
49 
50     function _changeTittyPrice (uint256 _newPrice, uint256 _tittyId) internal {
51 
52         require(tittyIndexToOwner[_tittyId] == msg.sender);
53         Titty storage _titty = Titties[_tittyId];
54         _titty.salePrice = _newPrice;
55 
56         Titties[_tittyId] = _titty;
57     }
58 
59     function _setTittyForSale (bool _forSale, uint256 _tittyId) internal {
60 
61         require(tittyIndexToOwner[_tittyId] == msg.sender);
62         Titty storage _titty = Titties[_tittyId];
63         _titty.forSale = _forSale;
64 
65         Titties[_tittyId] = _titty;
66     }
67 
68     function _changeName (string _name, uint256 _tittyId) internal {
69 
70         require(tittyIndexToOwner[_tittyId] == msg.sender);
71         Titty storage _titty = Titties[_tittyId];
72         _titty.name = _name;
73 
74         Titties[_tittyId] = _titty;
75     }
76 
77     function addAccessory (uint256 _id, string _name, uint256 _price, uint256 tittyId ) internal returns (uint) {
78 
79         Accessory memory _accessory = Accessory({
80 
81             id: _id,
82             name: _name,
83             price: _price,
84             isActive: true
85 
86         });
87 
88         Titty storage titty = Titties[tittyId];
89         uint256 newAccessoryId = Accessories.push(_accessory) - 1;
90         titty.accessories.push(newAccessoryId);
91         AddAccessory(tittyId, newAccessoryId);
92 
93         return newAccessoryId;
94 
95     }
96 
97     function totalAccessories(uint256 _tittyId) public view returns (uint256) {
98 
99         Titty storage titty = Titties[_tittyId];
100         return titty.accessories.length;
101 
102     }
103 
104     function getAccessory(uint256 _tittyId, uint256 _aId) public view returns (uint256 id, string name,  uint256 price, bool active) {
105 
106         Titty storage titty = Titties[_tittyId];
107         uint256 accId = titty.accessories[_aId];
108         Accessory storage accessory = Accessories[accId];
109         id = accessory.id;
110         name = accessory.name;
111         price = accessory.price;
112         active = accessory.isActive;
113 
114     }
115 
116     function createTitty (uint256 _id, string _gender, uint256 _price, address _owner, string _name) internal returns (uint) {
117         
118         Titty memory _titty = Titty({
119             id: _id,
120             name: _name,
121             gender: _gender,
122             originalPrice: _price,
123             salePrice: _price,
124             accessories: new uint256[](0),
125             forSale: false
126         });
127 
128         uint256 newTittyId = Titties.push(_titty) - 1;
129 
130         Creation(
131             _owner,
132             newTittyId,
133             _id
134         );
135 
136         _transfer(0, _owner, newTittyId);
137         return newTittyId;
138     }
139 
140     
141 
142 }
143 
144 
145 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
146 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
147 contract ERC721 {
148     function implementsERC721() public pure returns (bool);
149     function totalSupply() public view returns (uint256 total);
150     function balanceOf(address _owner) public view returns (uint256 balance);
151     function ownerOf(uint256 _tokenId) public view returns (address owner);
152     function approve(address _to, uint256 _tokenId) public;
153     function transferFrom(address _from, address _to, uint256 _tokenId) public;
154     function transfer(address _to, uint256 _tokenId) public;
155     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
156     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
157 
158     // Optional
159     // function name() public view returns (string name);
160     // function symbol() public view returns (string symbol);
161     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
162     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
163 }
164 
165 
166 
167 
168 
169 
170 
171 
172 contract TittyOwnership is TittyBase, ERC721 {
173 
174     string public name = "CryptoTittes";
175     string public symbol = "CT";
176 
177     function implementsERC721() public pure returns (bool) {
178         return true;
179     }
180 
181     function _isOwner(address _user, uint256 _tittyId) internal view returns (bool) {
182         return tittyIndexToOwner[_tittyId] == _user;
183     }
184 
185     function _approve(uint256 _tittyId, address _approved) internal {
186          tittyApproveIndex[_tittyId] = _approved; 
187     }
188 
189     function _approveFor(address _user, uint256 _tittyId) internal view returns (bool) {
190          return tittyApproveIndex[_tittyId] == _user; 
191     }
192 
193     function totalSupply() public view returns (uint256 total) {
194         return Titties.length - 1;
195     }
196 
197     function balanceOf(address _owner) public view returns (uint256 balance) {
198         return ownerTittiesCount[_owner];
199     }
200     
201     function ownerOf(uint256 _tokenId) public view returns (address owner) {
202         owner = tittyIndexToOwner[_tokenId];
203         require(owner != address(0));
204     }
205 
206     function approve(address _to, uint256 _tokenId) public {
207         require(_isOwner(msg.sender, _tokenId));
208         _approve(_tokenId, _to);
209         Approval(msg.sender, _to, _tokenId);
210     }
211 
212     function transferFrom(address _from, address _to, uint256 _tokenId) public {
213         require(_approveFor(msg.sender, _tokenId));
214         require(_isOwner(_from, _tokenId));
215 
216         _transfer(_from, _to, _tokenId);
217         
218 
219     }
220     function transfer(address _to, uint256 _tokenId) public {
221         require(_to != address(0));
222         require(_isOwner(msg.sender, _tokenId));
223 
224         _transfer(msg.sender, _to, _tokenId);
225     }
226 
227 
228 
229 }
230 
231 contract TittyPurchase is TittyOwnership {
232 
233     address private wallet;
234     address private boat;
235 
236     function TittyPurchase(address _wallet, address _boat) public {
237         wallet = _wallet;
238         boat = _boat;
239 
240         createTitty(0, "unissex", 1000000000, address(0), "genesis");
241     }
242 
243     function purchaseNew(uint256 _id, string _name, string _gender, uint256 _price) public payable {
244 
245         if (msg.value == 0 && msg.value != _price)
246             revert();
247 
248         uint256 boatFee = calculateBoatFee(msg.value);
249         createTitty(_id, _gender, _price, msg.sender, _name);
250         wallet.transfer(msg.value - boatFee);
251         boat.transfer(boatFee);
252 
253     }
254 
255     function purchaseExistent(uint256 _tittyId) public payable {
256 
257         Titty storage titty = Titties[_tittyId];
258         uint256 fee = calculateFee(titty.salePrice);
259         if (msg.value == 0 && msg.value != titty.salePrice)
260             revert();
261         
262         uint256 val = msg.value - fee;
263         address owner = tittyIndexToOwner[_tittyId];
264         _approve(_tittyId, msg.sender);
265         transferFrom(owner, msg.sender, _tittyId);
266         owner.transfer(val);
267         wallet.transfer(fee);
268 
269     }
270 
271     function purchaseAccessory(uint256 _tittyId, uint256 _accId, string _name, uint256 _price) public payable {
272 
273         if (msg.value == 0 && msg.value != _price)
274             revert();
275 
276         wallet.transfer(msg.value);
277         addAccessory(_accId, _name, _price,  _tittyId);
278         
279         
280     }
281 
282     function getAmountOfTitties() public view returns(uint) {
283         return Titties.length;
284     }
285 
286     function getLatestId() public view returns (uint) {
287         return Titties.length - 1;
288     }
289 
290     function getTittyByWpId(address _owner, uint256 _wpId) public view returns (bool own, uint256 tittyId) {
291         
292         for (uint256 i = 1; i<=totalSupply(); i++) {
293             Titty storage titty = Titties[i];
294             bool isOwner = _isOwner(_owner, i);
295             if (titty.id == _wpId && isOwner) {
296                 return (true, i);
297             }
298         }
299         
300         return (false, 0);
301     }
302 
303     function belongsTo(address _account, uint256 _tittyId) public view returns (bool) {
304         return _isOwner(_account, _tittyId);
305     }
306 
307     function changePrice(uint256 _price, uint256 _tittyId) public {
308         _changeTittyPrice(_price, _tittyId);
309     }
310 
311     function changeName(string _name, uint256 _tittyId) public {
312         _changeName(_name, _tittyId);
313     }
314 
315     function makeItSellable(uint256 _tittyId) public {
316         _setTittyForSale(true, _tittyId);
317     }
318 
319     function calculateFee (uint256 _price) internal pure returns(uint) {
320         return (_price * 10)/100;
321     }
322 
323     function calculateBoatFee (uint256 _price) internal pure returns(uint) {
324         return (_price * 25)/100;
325     }
326 
327     function() external {}
328 
329     function getATitty(uint256 _tittyId)
330         public 
331         view 
332         returns (
333         uint256 id,
334         string name,
335         string gender,
336         uint256 originalPrice,
337         uint256 salePrice,
338         bool forSale
339         ) {
340 
341             Titty storage titty = Titties[_tittyId];
342             id = titty.id;
343             name = titty.name;
344             gender = titty.gender;
345             originalPrice = titty.originalPrice;
346             salePrice = titty.salePrice;
347             forSale = titty.forSale;
348         }
349 
350 }
351 
352 contract CTAuction {
353 
354     struct Auction {
355         // Parameters of the auction. Times are either
356         // absolute unix timestamps (seconds since 1970-01-01)
357         // or time periods in seconds.
358         uint auctionEnd;
359 
360         // Current state of the auction.
361         address highestBidder;
362         uint highestBid;
363 
364         //Minumin Bid Set by the beneficiary
365         uint minimumBid;
366 
367         // Set to true at the end, disallows any change
368         bool ended;
369 
370         //Titty being Auctioned
371         uint titty;
372 
373         //Beneficiary
374         address beneficiary;
375 
376         //buynow price
377         uint buyNowPrice;
378     }
379 
380     Auction[] Auctions;
381 
382     address public owner; 
383     address public ctWallet; 
384     address public tittyContractAddress;
385 
386     // Allowed withdrawals of previous bids
387     mapping(address => uint) pendingReturns;
388 
389     // CriptoTitty Contract
390     TittyPurchase public tittyContract;
391 
392     // Events that will be fired on changes.
393     event HighestBidIncreased(uint auction, address bidder, uint amount);
394     event AuctionEnded(address winner, uint amount);
395     event BuyNow(address buyer, uint amount);
396     event AuctionCancel(uint auction);
397     event NewAuctionCreated(uint auctionId, uint titty);
398     event DidNotFinishYet(uint time, uint auctionTime);
399     event NotTheContractOwner(address owner, address sender);
400 
401     // The following is a so-called natspec comment,
402     // recognizable by the three slashes.
403     // It will be shown when the user is asked to
404     // confirm a transaction.
405 
406     /// Create a simple auction with `_biddingTime`
407     /// seconds bidding time on behalf of the
408     /// beneficiary address `_beneficiary`.
409     function CTAuction(
410         address _tittyPurchaseAddress,
411         address _wallet
412     ) public 
413     {   
414         tittyContractAddress = _tittyPurchaseAddress;
415         tittyContract = TittyPurchase(_tittyPurchaseAddress);
416         ctWallet = _wallet;
417         owner = msg.sender; 
418     }
419 
420     function createAuction(uint _biddingTime, uint _titty, uint _minimumBid, uint _buyNowPrice) public {
421 
422         address ownerAddress = tittyContract.ownerOf(_titty);
423         require(msg.sender == ownerAddress);
424 
425         Auction memory auction = Auction({
426             auctionEnd: now + _biddingTime,
427             titty: _titty,
428             beneficiary: msg.sender,
429             highestBidder: 0,
430             highestBid: 0,
431             ended: false,
432             minimumBid: _minimumBid,
433             buyNowPrice: _buyNowPrice
434         });
435 
436         uint auctionId = Auctions.push(auction) - 1;
437         NewAuctionCreated(auctionId, _titty);
438     }
439 
440     function getTittyOwner(uint _titty) public view returns (address) {
441         address ownerAddress = tittyContract.ownerOf(_titty);
442         return ownerAddress;
443     } 
444 
445     /// Bid on an auction with the value sent
446     /// together with this transaction.
447     /// The value will only be refunded if the
448     /// auction is not won.
449     function bid(uint _auction) public payable {
450 
451         Auction memory auction = Auctions[_auction];
452 
453         // Revert the call if the bidding
454         // period is over.
455         require(now <= auction.auctionEnd);
456 
457         // Revert the call value is less than the minimumBid.
458         require(msg.value >= auction.minimumBid);
459 
460         // If the bid is not higher, send the
461         // money back.
462         require(msg.value > auction.highestBid);
463 
464         if (auction.highestBid != 0) {
465             // Sending back the money by simply using
466             // highestBidder.send(highestBid) is a security risk
467             // because it could execute an untrusted contract.
468             // It is always safer to let the recipients
469             // withdraw their money themselves.
470             pendingReturns[auction.highestBidder] += auction.highestBid;
471         }
472         auction.highestBidder = msg.sender;
473         auction.highestBid = msg.value;
474         Auctions[_auction] = auction;
475         HighestBidIncreased(_auction, msg.sender, msg.value);
476     }
477 
478     function buyNow(uint _auction) public payable {
479 
480         Auction memory auction = Auctions[_auction];
481 
482         require(now >= auction.auctionEnd); // auction has ended
483         require(!auction.ended); // this function has already been called
484 
485         //Require that the value sent is the buyNowPrice Set by the Owner/Benneficary
486         require(msg.value == auction.buyNowPrice);
487 
488         //Require that there are no bids
489         require(auction.highestBid == 0);
490 
491         // End Auction
492         auction.ended = true;
493         Auctions[_auction] = auction;
494         BuyNow(msg.sender, msg.value);
495 
496         // Send the Funds
497         tittyContract.transferFrom(auction.beneficiary, msg.sender, auction.titty);
498         uint fee = calculateFee(msg.value);
499         ctWallet.transfer(fee);
500         auction.beneficiary.transfer(msg.value-fee);
501     }
502 
503     /// Withdraw a bid that was overbid.
504     function withdraw() public returns (bool) {
505         uint amount = pendingReturns[msg.sender];
506         require(amount > 0);
507         // It is important to set this to zero because the recipient
508         // can call this function again as part of the receiving call
509         // before `send` returns.
510         pendingReturns[msg.sender] = 0;
511 
512         if (!msg.sender.send(amount)) {
513             // No need to call throw here, just reset the amount owing
514             pendingReturns[msg.sender] = amount;
515             return false;
516         }
517         
518         return true;
519     }
520 
521     function auctionCancel(uint _auction) public {
522 
523         Auction memory auction = Auctions[_auction];
524 
525         //has to be the beneficiary
526         require(msg.sender == auction.beneficiary);
527 
528         //Auction Ended
529         require(now >= auction.auctionEnd);
530 
531         //has no maxbid 
532         require(auction.highestBid == 0);
533 
534         auction.ended = true;
535         Auctions[_auction] = auction;
536         AuctionCancel(_auction);
537 
538     }
539 
540     /// End the auction and send the highest bid
541     /// to the beneficiary and 10% to CT.
542     function auctionEnd(uint _auction) public {
543 
544         // Just cryptotitties CEO can end the auction
545         require (owner == msg.sender);
546 
547         Auction memory auction = Auctions[_auction];
548 
549         require (now >= auction.auctionEnd); // auction has ended
550         require(!auction.ended); // this function has already been called
551 
552         // End Auction
553         auction.ended = true;
554         Auctions[_auction] = auction;
555         AuctionEnded(auction.highestBidder, auction.highestBid);
556         if (auction.highestBid != 0) {
557             // Send the Funds
558             tittyContract.transferFrom(auction.beneficiary, auction.highestBidder, auction.titty);
559             uint fee = calculateFee(auction.highestBid);
560             ctWallet.transfer(fee);
561             auction.beneficiary.transfer(auction.highestBid-fee);
562         }
563 
564     }
565 
566     function getAuctionInfo(uint _auction) public view returns (uint end, address beneficiary, uint maxBid, address maxBidder) {
567 
568         Auction storage auction = Auctions[_auction];
569 
570         end = auction.auctionEnd;
571         beneficiary = auction.beneficiary;
572         maxBid = auction.highestBid;
573         maxBidder = auction.highestBidder;
574     }
575 
576     function calculateFee (uint256 _price) internal pure returns(uint) {
577         return (_price * 10)/100;
578     }
579 }