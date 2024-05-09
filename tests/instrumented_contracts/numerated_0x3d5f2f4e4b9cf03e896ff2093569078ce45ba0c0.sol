1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   /**
14    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15    * account.
16    */
17   function Ownable() {
18     owner = msg.sender;
19   }
20 
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30 
31   /**
32    * @dev Allows the current owner to transfer control of the contract to a newOwner.
33    * @param newOwner The address to transfer ownership to.
34    */
35   function transferOwnership(address newOwner) onlyOwner {
36     if (newOwner != address(0)) {
37       owner = newOwner;
38     }
39   }
40 
41 }
42 
43 
44 
45 /**
46  * @title Pausable
47  * @dev Base contract which allows children to implement an emergency stop mechanism.
48  */
49 contract Pausable is Ownable {
50   event Pause();
51   event Unpause();
52 
53   bool public paused = false;
54 
55 
56   /**
57    * @dev modifier to allow actions only when the contract IS paused
58    */
59   modifier whenNotPaused() {
60     require(!paused);
61     _;
62   }
63 
64   /**
65    * @dev modifier to allow actions only when the contract IS NOT paused
66    */
67   modifier whenPaused {
68     require(paused);
69     _;
70   }
71 
72   /**
73    * @dev called by the owner to pause, triggers stopped state
74    */
75   function pause() onlyOwner whenNotPaused returns (bool) {
76     paused = true;
77     Pause();
78     return true;
79   }
80 
81   /**
82    * @dev called by the owner to unpause, returns to normal state
83    */
84   function unpause() onlyOwner whenPaused returns (bool) {
85     paused = false;
86     Unpause();
87     return true;
88   }
89 }
90 
91 
92 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
93 contract ERC721 {
94     function implementsERC721() public pure returns (bool);
95     function totalSupply() public view returns (uint256 total);
96     function balanceOf(address _owner) public view returns (uint256 balance);
97     function ownerOf(uint256 _tokenId) public view returns (address owner);
98     function approve(address _to, uint256 _tokenId) public;
99     function transferFrom(address _from, address _to, uint256 _tokenId) public;
100     function transfer(address _to, uint256 _tokenId) public;
101     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
102     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
103     function promoBun(address _address) public;
104 }
105 
106 contract ClockAuctionBase {
107 
108     // Represents an auction on an NFT
109     struct Auction {
110         // Current owner of NFT
111         address seller;
112         // Price (in wei) at beginning of auction
113         uint128 startingPrice;
114         // Price (in wei) at end of auction
115         uint128 endingPrice;
116         // Duration (in seconds) of auction
117         uint128  startingPriceEth;
118         uint128  endingPriceEth;
119         
120         uint64 duration;
121         // Time when auction started
122         // NOTE: 0 if this auction has been concluded
123         uint64 startedAt;
124     }
125 
126     ERC721 public nonFungibleContract;
127 
128     uint256 public ownerCut;
129 
130     mapping (uint256 => Auction) tokenIdToAuction;
131 
132     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice,uint256 startingPriceEth, uint256 endingPriceEth, uint256 duration);
133     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice,uint ccy, address winner);
134     event AuctionCancelled(uint256 tokenId);
135 
136     function() external {}
137 
138     modifier canBeStoredWith64Bits(uint256 _value) {
139         require(_value <= 18446744073709551615);
140         _;
141     }
142 
143     modifier canBeStoredWith128Bits(uint256 _value) {
144         require(_value < 340282366920938463463374607431768211455);
145         _;
146     }
147 
148     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
149         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
150     }
151 
152     function _escrow(address _owner, uint256 _tokenId) internal {
153         nonFungibleContract.transferFrom(_owner, this, _tokenId);
154     }
155 
156     function _transfer(address _receiver, uint256 _tokenId) internal {
157         nonFungibleContract.transfer(_receiver, _tokenId);
158     }
159 
160     function _addAuction(uint256 _tokenId, Auction _auction) internal {
161         require(_auction.duration >= 1 minutes);
162 
163         tokenIdToAuction[_tokenId] = _auction;
164         
165         AuctionCreated(
166             uint256(_tokenId),
167             uint256(_auction.startingPrice),
168             uint256(_auction.endingPrice),
169             uint256(_auction.startingPriceEth),
170             uint256(_auction.endingPriceEth),
171             uint256(_auction.duration)
172         );
173     }
174     function _cancelAuction(uint256 _tokenId, address _seller) internal {
175         _removeAuction(_tokenId);
176         _transfer(_seller, _tokenId);
177         AuctionCancelled(_tokenId);
178     }
179     
180     function _order(uint256 _tokenId, uint256 _orderAmount, uint8 ccy)
181         internal
182         returns (uint256)
183     {
184         Auction storage auction = tokenIdToAuction[_tokenId];
185 
186         require(_isOnAuction(auction));
187 
188         uint256 price = _currentPrice(auction,0,ccy);
189         require(_orderAmount >= price);
190 
191         address seller = auction.seller;
192 
193         _removeAuction(_tokenId);
194 
195         if (price > 0 && ccy ==0) {
196             uint256 auctioneerCut = _computeCut(price);
197             uint256 sellerProceeds = price - auctioneerCut;
198             seller.transfer(sellerProceeds);
199         }
200         AuctionSuccessful(_tokenId, price,ccy, msg.sender);
201 
202         return price;
203     }
204     
205     function _removeAuction(uint256 _tokenId) internal {
206         delete tokenIdToAuction[_tokenId];
207     }
208     
209     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
210         return (_auction.startedAt > 0);
211     }
212     
213     function _currentPrice(Auction storage _auction, uint256 timeDelay, uint8 ccy)
214         internal
215         view
216         returns (uint256)
217     {
218         uint256 secondsPassed = 0;
219         if (now > _auction.startedAt) {
220             secondsPassed = now - _auction.startedAt + timeDelay;
221         }
222         if(ccy == 0){
223 	        return _computeCurrentPrice(
224 	            _auction.startingPriceEth,
225 	            _auction.endingPriceEth,
226 	            _auction.duration,
227 	            secondsPassed
228 	        );
229         }else{
230           return _computeCurrentPrice(
231             _auction.startingPrice,
232             _auction.endingPrice,
233             _auction.duration,
234             secondsPassed
235         ); 
236         }
237         
238     }
239 
240     function _computeCurrentPrice(
241         uint256 _startingPrice,
242         uint256 _endingPrice,
243         uint256 _duration,
244         uint256 _secondsPassed
245     )
246         internal
247         pure
248         returns (uint256)
249     {
250         if (_secondsPassed >= _duration) {
251             return _endingPrice;
252         } else {
253             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
254             
255             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
256             
257             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
258             
259             return uint256(currentPrice);
260         }
261     }
262 
263     function _computeCut(uint256 _price) internal view returns (uint256) {
264         return _price * ownerCut / 10000;
265     }
266 
267 }
268 
269 
270 contract ClockAuction is Pausable, ClockAuctionBase {
271    // bool public isClockAuction = true;
272     mapping (address => mapping (uint256 => uint256)) public addressIndexToAuctionCount;
273     mapping (address => mapping (uint256 => uint256)) public addressIndexToOrderCount;
274    
275     event DayPass(uint256 _dayPass, uint256 _startTime, uint256 _now, uint256 time );
276     
277     uint256 public startTime = now;
278     uint256 public aDay = 86400;
279     
280     
281     
282     function _calculateDayPass() internal returns (uint256 dayPass) {
283        dayPass = (now -startTime) / aDay;
284        DayPass(dayPass,startTime,now,(aDay));
285     }
286    
287    
288    
289     function ClockAuction(address _nftAddress, uint256 _cut) public {
290         require(_cut <= 10000);
291         ownerCut = _cut;
292         
293         ERC721 candidateContract = ERC721(_nftAddress);
294         require(candidateContract.implementsERC721());
295         nonFungibleContract = candidateContract;
296     }
297 
298     function withdrawBalance() external {
299         address nftAddress = address(nonFungibleContract);
300 
301         require(
302             msg.sender == owner ||
303             msg.sender == nftAddress
304         );
305         nftAddress.transfer(this.balance);
306     }
307 
308     function createAuction(
309         uint256 _tokenId,
310         uint256 _startingPrice,
311         uint256 _endingPrice,
312         uint256 _startingPriceEth,
313         uint256 _endingPriceEth,
314         uint256 _duration,
315         address _seller
316     )
317         public
318         whenNotPaused
319         canBeStoredWith128Bits(_startingPrice)
320         canBeStoredWith128Bits(_endingPrice)
321         canBeStoredWith64Bits(_duration)
322     {
323         require(_owns(msg.sender, _tokenId));
324         _escrow(msg.sender, _tokenId);
325         Auction memory auction = Auction(
326             _seller,
327             uint128(_startingPrice),
328             uint128(_endingPrice),
329             uint128(_startingPriceEth),
330             uint128(_endingPriceEth),
331             uint64(_duration),
332             uint64(now)
333         );
334         _addAuction(_tokenId, auction);
335     }
336 
337     function cancelAuction(uint256 _tokenId)
338         public
339     {
340         Auction storage auction = tokenIdToAuction[_tokenId];
341         require(_isOnAuction(auction));
342         address seller = auction.seller;
343         require(msg.sender == seller);
344         _cancelAuction(_tokenId, seller);
345     }
346 
347     function cancelAuctionWhenPaused(uint256 _tokenId)
348         whenPaused
349         onlyOwner
350         public
351     {
352         Auction storage auction = tokenIdToAuction[_tokenId];
353         require(_isOnAuction(auction));
354         _cancelAuction(_tokenId, auction.seller);
355     }
356 
357     function getAuction(uint256 _tokenId)
358         public
359         view
360         returns
361     (
362         address seller,
363         uint256 startingPrice,
364         uint256 endingPrice,
365         uint256 startingPriceEth,
366         uint256 endingPriceEth,
367         uint256 duration,
368         uint256 startedAt
369     ) {
370         Auction storage auction = tokenIdToAuction[_tokenId];
371         require(_isOnAuction(auction));
372         return (
373             auction.seller,
374             auction.startingPrice,
375             auction.endingPrice,
376             auction.startingPriceEth,
377             auction.endingPriceEth,
378             auction.duration,
379             auction.startedAt
380         );
381     }
382     
383      function getSeller(uint256 _tokenId) public view returns(address seller) {
384         Auction storage auction = tokenIdToAuction[_tokenId];
385         require(_isOnAuction(auction));
386         return auction.seller;
387     }
388 
389     function getCurrentPrice(uint256 _tokenId,uint8 ccy)
390         public
391         view
392         returns (uint256)
393     {
394         Auction storage auction = tokenIdToAuction[_tokenId];
395         require(_isOnAuction(auction));
396         return _currentPrice(auction, 0,ccy);
397     }
398     
399     
400     function getCurrentPrice(uint256 _tokenId, uint256 timeDelay,uint8 ccy)
401         public
402         view
403         returns (uint256)
404     {
405         Auction storage auction = tokenIdToAuction[_tokenId];
406         require(_isOnAuction(auction));
407         return _currentPrice(auction, timeDelay,ccy);
408     }
409 
410 }
411 
412 
413 contract FightClockAuction is ClockAuction {
414     bool public isFightClockAuction = true;
415     function FightClockAuction(address _nftAddr, uint256 _cut) public
416         ClockAuction(_nftAddr, _cut) {}
417 
418     function createAuction(
419         uint256 _tokenId,
420         uint256 _startingPrice,
421         uint256 _endingPrice,
422         uint256 _startingPriceEth,
423         uint256 _endingPriceEth,
424         uint256 _duration,
425         address _seller
426     )
427         public
428         canBeStoredWith128Bits(_startingPrice)
429         canBeStoredWith128Bits(_endingPrice)
430         canBeStoredWith128Bits(_startingPriceEth)
431         canBeStoredWith128Bits(_endingPriceEth)
432         canBeStoredWith64Bits(_duration)
433     {
434         require(msg.sender == address(nonFungibleContract));
435         _escrow(_seller, _tokenId);
436         Auction memory auction = Auction(
437             _seller,
438             uint128(_startingPrice),
439             uint128(_endingPrice),
440             uint128(0),
441             uint128(0),
442             uint64(_duration),
443             uint64(now)
444         );
445         _addAuction(_tokenId, auction);
446         addressIndexToAuctionCount[_seller][_calculateDayPass()] += 1;
447     }
448 
449     function order(uint256 _tokenId,  uint256 orderAmount ,address buyer)
450         public
451         returns (bool)
452     {
453         require(msg.sender == address(nonFungibleContract));
454         //require(orderAmount > 0);
455         address seller = tokenIdToAuction[_tokenId].seller;
456         _order(_tokenId, orderAmount,1);
457         _transfer(seller, _tokenId);
458         addressIndexToOrderCount[buyer][_calculateDayPass()] +=1;
459         bool flag = true;
460         return flag;
461     }
462 
463 }