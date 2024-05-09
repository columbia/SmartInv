1 pragma solidity ^0.4.21;
2 
3 contract ERC721 {
4     // Required methods
5     function totalSupply() public view returns (uint256 total);
6     function balanceOf(address _owner) public view returns (uint256 balance);
7     function ownerOf(uint256 _tokenId) external view returns (address owner);
8     function approve(address _to, uint256 _tokenId) external;
9     function transfer(address _to, uint256 _tokenId) external;
10     function transferFrom(address _from, address _to, uint256 _tokenId) external;
11 
12     // Events
13     event Transfer(address from, address to, uint256 tokenId);
14     event Approval(address owner, address approved, uint256 tokenId);
15 
16     // Optional
17     // function name() public view returns (string name);
18     // function symbol() public view returns (string symbol);
19     // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
20     // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
21 
22     // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
23     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
24 }
25 
26 contract Ownable {
27     address public owner;
28 
29     event OwnershipTransferred(address previousOwner, address newOwner);
30 
31     function Ownable() public {
32         owner = msg.sender;
33     }
34 
35     modifier onlyOwner() {
36         require(msg.sender == owner);
37         _;
38     }
39 
40     function transferOwnership(address newOwner) public onlyOwner {
41         require(newOwner != address(0));
42         emit OwnershipTransferred(owner, newOwner);
43         owner = newOwner;
44     }
45 }
46 
47 contract StorageBase is Ownable {
48 
49     function withdrawBalance() external onlyOwner returns (bool) {
50         // The owner has a method to withdraw balance from multiple contracts together,
51         // use send here to make sure even if one withdrawBalance fails the others will still work
52         bool res = msg.sender.send(address(this).balance);
53         return res;
54     }
55 }
56 
57 contract ClockAuctionStorage is StorageBase {
58 
59     // Represents an auction on an NFT
60     struct Auction {
61         // Current owner of NFT
62         address seller;
63         // Price (in wei) at beginning of auction
64         uint128 startingPrice;
65         // Price (in wei) at end of auction
66         uint128 endingPrice;
67         // Duration (in seconds) of auction
68         uint64 duration;
69         // Time when auction started
70         // NOTE: 0 if this auction has been concluded
71         uint64 startedAt;
72     }
73 
74     // Map from token ID to their corresponding auction.
75     mapping (uint256 => Auction) tokenIdToAuction;
76 
77     function addAuction(
78         uint256 _tokenId,
79         address _seller,
80         uint128 _startingPrice,
81         uint128 _endingPrice,
82         uint64 _duration,
83         uint64 _startedAt
84     )
85         external
86         onlyOwner
87     {
88         tokenIdToAuction[_tokenId] = Auction(
89             _seller,
90             _startingPrice,
91             _endingPrice,
92             _duration,
93             _startedAt
94         );
95     }
96 
97     function removeAuction(uint256 _tokenId) public onlyOwner {
98         delete tokenIdToAuction[_tokenId];
99     }
100 
101     function getAuction(uint256 _tokenId)
102         external
103         view
104         returns (
105             address seller,
106             uint128 startingPrice,
107             uint128 endingPrice,
108             uint64 duration,
109             uint64 startedAt
110         )
111     {
112         Auction storage auction = tokenIdToAuction[_tokenId];
113         return (
114             auction.seller,
115             auction.startingPrice,
116             auction.endingPrice,
117             auction.duration,
118             auction.startedAt
119         );
120     }
121 
122     function isOnAuction(uint256 _tokenId) external view returns (bool) {
123         return (tokenIdToAuction[_tokenId].startedAt > 0);
124     }
125 
126     function getSeller(uint256 _tokenId) external view returns (address) {
127         return tokenIdToAuction[_tokenId].seller;
128     }
129 
130     function transfer(ERC721 _nonFungibleContract, address _receiver, uint256 _tokenId) external onlyOwner {
131         // it will throw if transfer fails
132         _nonFungibleContract.transfer(_receiver, _tokenId);
133     }
134 }
135 
136 contract SiringClockAuctionStorage is ClockAuctionStorage {
137     bool public isSiringClockAuctionStorage = true;
138 }
139 
140 contract Pausable is Ownable {
141     event Pause();
142     event Unpause();
143 
144     bool public paused = false;
145 
146     modifier whenNotPaused() {
147         require(!paused);
148         _;
149     }
150 
151     modifier whenPaused {
152         require(paused);
153         _;
154     }
155 
156     function pause() public onlyOwner whenNotPaused {
157         paused = true;
158         emit Pause();
159     }
160 
161     function unpause() public onlyOwner whenPaused {
162         paused = false;
163         emit Unpause();
164     }
165 }
166 
167 contract HasNoContracts is Pausable {
168 
169     function reclaimContract(address _contractAddr) external onlyOwner whenPaused {
170         Ownable contractInst = Ownable(_contractAddr);
171         contractInst.transferOwnership(owner);
172     }
173 }
174 
175 contract LogicBase is HasNoContracts {
176 
177     /// The ERC-165 interface signature for ERC-721.
178     ///  Ref: https://github.com/ethereum/EIPs/issues/165
179     ///  Ref: https://github.com/ethereum/EIPs/issues/721
180     bytes4 constant InterfaceSignature_NFC = bytes4(0x9f40b779);
181 
182     // Reference to contract tracking NFT ownership
183     ERC721 public nonFungibleContract;
184 
185     // Reference to storage contract
186     StorageBase public storageContract;
187 
188     function LogicBase(address _nftAddress, address _storageAddress) public {
189         // paused by default
190         paused = true;
191 
192         setNFTAddress(_nftAddress);
193 
194         require(_storageAddress != address(0));
195         storageContract = StorageBase(_storageAddress);
196     }
197 
198     // Very dangerous action, only when new contract has been proved working
199     // Requires storageContract already transferOwnership to the new contract
200     // This method is only used to transfer the balance to owner
201     function destroy() external onlyOwner whenPaused {
202         address storageOwner = storageContract.owner();
203         // owner of storageContract must not be the current contract otherwise the storageContract will forever not accessible
204         require(storageOwner != address(this));
205         // Transfers the current balance to the owner and terminates the contract
206         selfdestruct(owner);
207     }
208 
209     // Very dangerous action, only when new contract has been proved working
210     // Requires storageContract already transferOwnership to the new contract
211     // This method is only used to transfer the balance to the new contract
212     function destroyAndSendToStorageOwner() external onlyOwner whenPaused {
213         address storageOwner = storageContract.owner();
214         // owner of storageContract must not be the current contract otherwise the storageContract will forever not accessible
215         require(storageOwner != address(this));
216         // Transfers the current balance to the new owner of the storage contract and terminates the contract
217         selfdestruct(storageOwner);
218     }
219 
220     // override to make sure everything is initialized before the unpause
221     function unpause() public onlyOwner whenPaused {
222         // can not unpause when the logic contract is not initialzed
223         require(nonFungibleContract != address(0));
224         require(storageContract != address(0));
225         // can not unpause when ownership of storage contract is not the current contract
226         require(storageContract.owner() == address(this));
227 
228         super.unpause();
229     }
230 
231     function setNFTAddress(address _nftAddress) public onlyOwner {
232         require(_nftAddress != address(0));
233         ERC721 candidateContract = ERC721(_nftAddress);
234         require(candidateContract.supportsInterface(InterfaceSignature_NFC));
235         nonFungibleContract = candidateContract;
236     }
237 
238     // Withdraw balance to the Core Contract
239     function withdrawBalance() external returns (bool) {
240         address nftAddress = address(nonFungibleContract);
241         // either Owner or Core Contract can trigger the withdraw
242         require(msg.sender == owner || msg.sender == nftAddress);
243         // The owner has a method to withdraw balance from multiple contracts together,
244         // use send here to make sure even if one withdrawBalance fails the others will still work
245         bool res = nftAddress.send(address(this).balance);
246         return res;
247     }
248 
249     function withdrawBalanceFromStorageContract() external returns (bool) {
250         address nftAddress = address(nonFungibleContract);
251         // either Owner or Core Contract can trigger the withdraw
252         require(msg.sender == owner || msg.sender == nftAddress);
253         // The owner has a method to withdraw balance from multiple contracts together,
254         // use send here to make sure even if one withdrawBalance fails the others will still work
255         bool res = storageContract.withdrawBalance();
256         return res;
257     }
258 }
259 
260 contract ClockAuction is LogicBase {
261     
262     // Reference to contract tracking auction state variables
263     ClockAuctionStorage public clockAuctionStorage;
264 
265     // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
266     // Values 0-10,000 map to 0%-100%
267     uint256 public ownerCut;
268 
269     // Minimum cut value on each auction (in WEI)
270     uint256 public minCutValue;
271 
272     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice, uint256 duration);
273     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice, address winner, address seller, uint256 sellerProceeds);
274     event AuctionCancelled(uint256 tokenId);
275 
276     function ClockAuction(address _nftAddress, address _storageAddress, uint256 _cut, uint256 _minCutValue) 
277         LogicBase(_nftAddress, _storageAddress) public
278     {
279         setOwnerCut(_cut);
280         setMinCutValue(_minCutValue);
281 
282         clockAuctionStorage = ClockAuctionStorage(_storageAddress);
283     }
284 
285     function setOwnerCut(uint256 _cut) public onlyOwner {
286         require(_cut <= 10000);
287         ownerCut = _cut;
288     }
289 
290     function setMinCutValue(uint256 _minCutValue) public onlyOwner {
291         minCutValue = _minCutValue;
292     }
293 
294     function getMinPrice() public view returns (uint256) {
295         // return ownerCut > 0 ? (minCutValue / ownerCut * 10000) : 0;
296         // use minCutValue directly, when the price == minCutValue seller will get no profit
297         return minCutValue;
298     }
299 
300     // Only auction from none system user need to verify the price
301     // System auction can set any price
302     function isValidPrice(uint256 _startingPrice, uint256 _endingPrice) public view returns (bool) {
303         return (_startingPrice < _endingPrice ? _startingPrice : _endingPrice) >= getMinPrice();
304     }
305 
306     function createAuction(
307         uint256 _tokenId,
308         uint256 _startingPrice,
309         uint256 _endingPrice,
310         uint256 _duration,
311         address _seller
312     )
313         public
314         whenNotPaused
315     {
316         require(_startingPrice == uint256(uint128(_startingPrice)));
317         require(_endingPrice == uint256(uint128(_endingPrice)));
318         require(_duration == uint256(uint64(_duration)));
319 
320         require(msg.sender == address(nonFungibleContract));
321         
322         // assigning ownership to this clockAuctionStorage when in auction
323         // it will throw if transfer fails
324         nonFungibleContract.transferFrom(_seller, address(clockAuctionStorage), _tokenId);
325 
326         // Require that all auctions have a duration of at least one minute.
327         require(_duration >= 1 minutes);
328 
329         clockAuctionStorage.addAuction(
330             _tokenId,
331             _seller,
332             uint128(_startingPrice),
333             uint128(_endingPrice),
334             uint64(_duration),
335             uint64(now)
336         );
337 
338         emit AuctionCreated(_tokenId, _startingPrice, _endingPrice, _duration);
339     }
340 
341     function cancelAuction(uint256 _tokenId) external {
342         require(clockAuctionStorage.isOnAuction(_tokenId));
343         address seller = clockAuctionStorage.getSeller(_tokenId);
344         require(msg.sender == seller);
345         _cancelAuction(_tokenId, seller);
346     }
347 
348     function cancelAuctionWhenPaused(uint256 _tokenId) external whenPaused onlyOwner {
349         require(clockAuctionStorage.isOnAuction(_tokenId));
350         address seller = clockAuctionStorage.getSeller(_tokenId);
351         _cancelAuction(_tokenId, seller);
352     }
353 
354     function getAuction(uint256 _tokenId)
355         public
356         view
357         returns
358     (
359         address seller,
360         uint256 startingPrice,
361         uint256 endingPrice,
362         uint256 duration,
363         uint256 startedAt
364     ) {
365         require(clockAuctionStorage.isOnAuction(_tokenId));
366         return clockAuctionStorage.getAuction(_tokenId);
367     }
368 
369     function getCurrentPrice(uint256 _tokenId)
370         external
371         view
372         returns (uint256)
373     {
374         require(clockAuctionStorage.isOnAuction(_tokenId));
375         return _currentPrice(_tokenId);
376     }
377 
378     function _cancelAuction(uint256 _tokenId, address _seller) internal {
379         clockAuctionStorage.removeAuction(_tokenId);
380         clockAuctionStorage.transfer(nonFungibleContract, _seller, _tokenId);
381         emit AuctionCancelled(_tokenId);
382     }
383 
384     function _bid(uint256 _tokenId, uint256 _bidAmount, address bidder) internal returns (uint256) {
385 
386         require(clockAuctionStorage.isOnAuction(_tokenId));
387 
388         // Check that the bid is greater than or equal to the current price
389         uint256 price = _currentPrice(_tokenId);
390         require(_bidAmount >= price);
391 
392         address seller = clockAuctionStorage.getSeller(_tokenId);
393         uint256 sellerProceeds = 0;
394 
395         // Remove the auction before sending the fees to the sender so we can't have a reentrancy attack
396         clockAuctionStorage.removeAuction(_tokenId);
397 
398         // Transfer proceeds to seller (if there are any!)
399         if (price > 0) {
400             // Calculate the auctioneer's cut, so this subtraction can't go negative
401             uint256 auctioneerCut = _computeCut(price);
402             sellerProceeds = price - auctioneerCut;
403 
404             // transfer the sellerProceeds
405             seller.transfer(sellerProceeds);
406         }
407 
408         // Calculate any excess funds included with the bid
409         // transfer it back to bidder.
410         // this cannot underflow.
411         uint256 bidExcess = _bidAmount - price;
412         bidder.transfer(bidExcess);
413 
414         emit AuctionSuccessful(_tokenId, price, bidder, seller, sellerProceeds);
415 
416         return price;
417     }
418 
419     function _currentPrice(uint256 _tokenId) internal view returns (uint256) {
420 
421         uint256 secondsPassed = 0;
422 
423         address seller;
424         uint128 startingPrice;
425         uint128 endingPrice;
426         uint64 duration;
427         uint64 startedAt;
428         (seller, startingPrice, endingPrice, duration, startedAt) = clockAuctionStorage.getAuction(_tokenId);
429 
430         if (now > startedAt) {
431             secondsPassed = now - startedAt;
432         }
433 
434         return _computeCurrentPrice(
435             startingPrice,
436             endingPrice,
437             duration,
438             secondsPassed
439         );
440     }
441 
442     function _computeCurrentPrice(
443         uint256 _startingPrice,
444         uint256 _endingPrice,
445         uint256 _duration,
446         uint256 _secondsPassed
447     )
448         internal
449         pure
450         returns (uint256)
451     {
452         if (_secondsPassed >= _duration) {
453             return _endingPrice;
454         } else {
455             // this delta can be negative.
456             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
457 
458             // This multiplication can't overflow, _secondsPassed will easily fit within
459             // 64-bits, and totalPriceChange will easily fit within 128-bits, their product
460             // will always fit within 256-bits.
461             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
462 
463             // this result will always end up positive.
464             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
465 
466             return uint256(currentPrice);
467         }
468     }
469 
470     function _computeCut(uint256 _price) internal view returns (uint256) {
471         uint256 cutValue = _price * ownerCut / 10000;
472         if (_price < minCutValue) return cutValue;
473         if (cutValue > minCutValue) return cutValue;
474         return minCutValue;
475     }
476 }
477 
478 contract SiringClockAuction is ClockAuction {
479 
480     bool public isSiringClockAuction = true;
481 
482     function SiringClockAuction(address _nftAddr, address _storageAddress, uint256 _cut, uint256 _minCutValue) 
483         ClockAuction(_nftAddr, _storageAddress, _cut, _minCutValue) public
484     {
485         require(SiringClockAuctionStorage(_storageAddress).isSiringClockAuctionStorage());
486     }
487 
488     function bid(uint256 _tokenId, address bidder) external payable {
489         // can only be called by CryptoZoo
490         require(msg.sender == address(nonFungibleContract));
491         // get seller before the _bid for the auction will be removed once the bid success
492         address seller = clockAuctionStorage.getSeller(_tokenId);
493         // _bid checks that token ID is valid and will throw if bid fails
494         _bid(_tokenId, msg.value, bidder);
495         // transfer the monster back to the seller, the winner will get the child
496         clockAuctionStorage.transfer(nonFungibleContract, seller, _tokenId);
497     }
498 }