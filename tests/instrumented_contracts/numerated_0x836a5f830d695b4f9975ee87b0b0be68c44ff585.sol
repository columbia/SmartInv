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
92 contract HeroCore{
93 
94    function ownerIndexToERC20Balance(address _address) public returns (uint256);
95    function useItems(uint32 _items, uint256 tokenId, address owner,uint256 fee) public returns (bool);
96    function ownerOf(uint256 _tokenId) public returns (address);
97    function getHeroItems(uint256 _id) public returns ( uint32);
98     
99    function reduceCDFee(uint256 heroId) 
100          public 
101          view 
102          returns (uint256);
103    
104 }
105 
106 
107 
108 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
109 contract ERC721 {
110     function implementsERC721() public pure returns (bool);
111     function totalSupply() public view returns (uint256 total);
112     function balanceOf(address _owner) public view returns (uint256 balance);
113     function ownerOf(uint256 _tokenId) public view returns (address owner);
114     function approve(address _to, uint256 _tokenId) public;
115     function transferFrom(address _from, address _to, uint256 _tokenId) public;
116     function transfer(address _to, uint256 _tokenId) public;
117     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
118     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
119     function promoBun(address _address) public;
120 }
121 
122 contract ClockAuctionBase {
123 
124     // Represents an auction on an NFT
125     struct Auction {
126         // Current owner of NFT
127         address seller;
128         // Price (in wei) at beginning of auction
129         uint128 startingPrice;
130         // Price (in wei) at end of auction
131         uint128 endingPrice;
132         // Duration (in seconds) of auction
133         uint128  startingPriceEth;
134         uint128  endingPriceEth;
135         
136         uint64 duration;
137         // Time when auction started
138         // NOTE: 0 if this auction has been concluded
139         uint64 startedAt;
140     }
141 
142     ERC721 public nonFungibleContract;
143 
144     uint256 public ownerCut;
145 
146     mapping (uint256 => Auction) tokenIdToAuction;
147 
148     event AuctionCreated(uint256 tokenId, uint256 startingPrice, uint256 endingPrice,uint256 startingPriceEth, uint256 endingPriceEth, uint256 duration);
149     event AuctionSuccessful(uint256 tokenId, uint256 totalPrice,uint ccy, address winner);
150     event AuctionCancelled(uint256 tokenId);
151 
152     function() external {}
153 
154     modifier canBeStoredWith64Bits(uint256 _value) {
155         require(_value <= 18446744073709551615);
156         _;
157     }
158 
159     modifier canBeStoredWith128Bits(uint256 _value) {
160         require(_value < 340282366920938463463374607431768211455);
161         _;
162     }
163 
164     function _owns(address _claimant, uint256 _tokenId) internal view returns (bool) {
165         return (nonFungibleContract.ownerOf(_tokenId) == _claimant);
166     }
167 
168     function _escrow(address _owner, uint256 _tokenId) internal {
169         nonFungibleContract.transferFrom(_owner, this, _tokenId);
170     }
171 
172     function _transfer(address _receiver, uint256 _tokenId) internal {
173         nonFungibleContract.transfer(_receiver, _tokenId);
174     }
175 
176     function _addAuction(uint256 _tokenId, Auction _auction) internal {
177         require(_auction.duration >= 1 minutes);
178 
179         tokenIdToAuction[_tokenId] = _auction;
180         
181         AuctionCreated(
182             uint256(_tokenId),
183             uint256(_auction.startingPrice),
184             uint256(_auction.endingPrice),
185             uint256(_auction.startingPriceEth),
186             uint256(_auction.endingPriceEth),
187             uint256(_auction.duration)
188         );
189     }
190     function _cancelAuction(uint256 _tokenId, address _seller) internal {
191         _removeAuction(_tokenId);
192         _transfer(_seller, _tokenId);
193         AuctionCancelled(_tokenId);
194     }
195     
196     function _order(uint256 _tokenId, uint256 _orderAmount, uint8 ccy)
197         internal
198         returns (uint256)
199     {
200         Auction storage auction = tokenIdToAuction[_tokenId];
201 
202         require(_isOnAuction(auction));
203 
204         uint256 price = _currentPrice(auction,0,ccy);
205         require(_orderAmount >= price);
206 
207         address seller = auction.seller;
208 
209         _removeAuction(_tokenId);
210 
211         if (price > 0 && ccy ==0) {
212             uint256 auctioneerCut = _computeCut(price);
213             uint256 sellerProceeds = price - auctioneerCut;
214             seller.transfer(sellerProceeds);
215         }
216         AuctionSuccessful(_tokenId, price,ccy, msg.sender);
217 
218         return price;
219     }
220     
221     function _removeAuction(uint256 _tokenId) internal {
222         delete tokenIdToAuction[_tokenId];
223     }
224     
225     function _isOnAuction(Auction storage _auction) internal view returns (bool) {
226         return (_auction.startedAt > 0);
227     }
228     
229     function _currentPrice(Auction storage _auction, uint256 timeDelay, uint8 ccy)
230         internal
231         view
232         returns (uint256)
233     {
234         uint256 secondsPassed = 0;
235         if (now > _auction.startedAt) {
236             secondsPassed = now - _auction.startedAt + timeDelay;
237         }
238         if(ccy == 0){
239 	        return _computeCurrentPrice(
240 	            _auction.startingPriceEth,
241 	            _auction.endingPriceEth,
242 	            _auction.duration,
243 	            secondsPassed
244 	        );
245         }else{
246           return _computeCurrentPrice(
247             _auction.startingPrice,
248             _auction.endingPrice,
249             _auction.duration,
250             secondsPassed
251         ); 
252         }
253         
254     }
255 
256     function _computeCurrentPrice(
257         uint256 _startingPrice,
258         uint256 _endingPrice,
259         uint256 _duration,
260         uint256 _secondsPassed
261     )
262         internal
263         pure
264         returns (uint256)
265     {
266         if (_secondsPassed >= _duration) {
267             return _endingPrice;
268         } else {
269             int256 totalPriceChange = int256(_endingPrice) - int256(_startingPrice);
270             
271             int256 currentPriceChange = totalPriceChange * int256(_secondsPassed) / int256(_duration);
272             
273             int256 currentPrice = int256(_startingPrice) + currentPriceChange;
274             
275             return uint256(currentPrice);
276         }
277     }
278 
279     function _computeCut(uint256 _price) internal view returns (uint256) {
280         return _price * ownerCut / 10000;
281     }
282 
283 }
284 
285 
286 contract ClockAuction is Pausable, ClockAuctionBase {
287    // bool public isClockAuction = true;
288     mapping (address => mapping (uint256 => uint256)) public addressIndexToAuctionCount;
289     mapping (address => mapping (uint256 => uint256)) public addressIndexToOrderCount;
290    
291     event DayPass(uint256 _dayPass, uint256 _startTime, uint256 _now, uint256 time );
292     
293     uint256 public startTime = now;
294     uint256 public aDay = 86400;
295     
296     
297     
298     function _calculateDayPass() internal returns (uint256 dayPass) {
299        dayPass = (now -startTime) / aDay;
300        DayPass(dayPass,startTime,now,(aDay));
301     }
302    
303    
304    
305     function ClockAuction(address _nftAddress, uint256 _cut) public {
306         require(_cut <= 10000);
307         ownerCut = _cut;
308         
309         ERC721 candidateContract = ERC721(_nftAddress);
310         require(candidateContract.implementsERC721());
311         nonFungibleContract = candidateContract;
312     }
313 
314     function withdrawBalance() external {
315         address nftAddress = address(nonFungibleContract);
316 
317         require(
318             msg.sender == owner ||
319             msg.sender == nftAddress
320         );
321         nftAddress.transfer(this.balance);
322     }
323 
324     function createAuction(
325         uint256 _tokenId,
326         uint256 _startingPrice,
327         uint256 _endingPrice,
328         uint256 _startingPriceEth,
329         uint256 _endingPriceEth,
330         uint256 _duration,
331         address _seller
332     )
333         public
334         whenNotPaused
335         canBeStoredWith128Bits(_startingPrice)
336         canBeStoredWith128Bits(_endingPrice)
337         canBeStoredWith64Bits(_duration)
338     {
339         require(_owns(msg.sender, _tokenId));
340         _escrow(msg.sender, _tokenId);
341         Auction memory auction = Auction(
342             _seller,
343             uint128(_startingPrice),
344             uint128(_endingPrice),
345             uint128(_startingPriceEth),
346             uint128(_endingPriceEth),
347             uint64(_duration),
348             uint64(now)
349         );
350         _addAuction(_tokenId, auction);
351     }
352 
353     function cancelAuction(uint256 _tokenId)
354         public
355     {
356         Auction storage auction = tokenIdToAuction[_tokenId];
357         require(_isOnAuction(auction));
358         address seller = auction.seller;
359         require(msg.sender == seller);
360         _cancelAuction(_tokenId, seller);
361     }
362 
363     function cancelAuctionWhenPaused(uint256 _tokenId)
364         whenPaused
365         onlyOwner
366         public
367     {
368         Auction storage auction = tokenIdToAuction[_tokenId];
369         require(_isOnAuction(auction));
370         _cancelAuction(_tokenId, auction.seller);
371     }
372 
373     function getAuction(uint256 _tokenId)
374         public
375         view
376         returns
377     (
378         address seller,
379         uint256 startingPrice,
380         uint256 endingPrice,
381         uint256 startingPriceEth,
382         uint256 endingPriceEth,
383         uint256 duration,
384         uint256 startedAt
385     ) {
386         Auction storage auction = tokenIdToAuction[_tokenId];
387         require(_isOnAuction(auction));
388         return (
389             auction.seller,
390             auction.startingPrice,
391             auction.endingPrice,
392             auction.startingPriceEth,
393             auction.endingPriceEth,
394             auction.duration,
395             auction.startedAt
396         );
397     }
398     
399      function getSeller(uint256 _tokenId) public view returns(address seller) {
400         Auction storage auction = tokenIdToAuction[_tokenId];
401         require(_isOnAuction(auction));
402         return auction.seller;
403     }
404 
405     function getCurrentPrice(uint256 _tokenId,uint8 ccy)
406         public
407         view
408         returns (uint256)
409     {
410         Auction storage auction = tokenIdToAuction[_tokenId];
411         require(_isOnAuction(auction));
412         return _currentPrice(auction, 0,ccy);
413     }
414     
415     
416     function getCurrentPrice(uint256 _tokenId, uint256 timeDelay,uint8 ccy)
417         public
418         view
419         returns (uint256)
420     {
421         Auction storage auction = tokenIdToAuction[_tokenId];
422         require(_isOnAuction(auction));
423         return _currentPrice(auction, timeDelay,ccy);
424     }
425 
426 }
427 
428 
429 contract SaleClockAuction is ClockAuction {
430     bool public isSaleClockAuction = true;
431     uint256 public gen0SaleCount;
432     uint256[5] public lastGen0SalePrices;
433     function SaleClockAuction(address _nftAddr, uint256 _cut) public
434         ClockAuction(_nftAddr, _cut) {}
435         
436     function createAuction(
437         uint256 _tokenId,
438         uint256 _startingPrice,
439         uint256 _endingPrice,
440         uint256 _startingPriceEth,
441         uint256 _endingPriceEth,
442         uint256 _duration,
443         address _seller
444     )
445         public
446         canBeStoredWith128Bits(_startingPrice)
447         canBeStoredWith128Bits(_endingPrice)
448         canBeStoredWith128Bits(_startingPriceEth)
449         canBeStoredWith128Bits(_endingPriceEth)
450         canBeStoredWith64Bits(_duration)
451     {
452         require(msg.sender == address(nonFungibleContract));
453         _escrow(_seller, _tokenId);
454         Auction memory auction = Auction(
455             _seller,
456             uint128(_startingPrice),
457             uint128(_endingPrice),
458             uint128(_startingPriceEth),
459             uint128(_endingPriceEth),
460             uint64(_duration),
461             uint64(now)
462         );
463         _addAuction(_tokenId, auction);
464         addressIndexToAuctionCount[_seller][_calculateDayPass()] += 1;
465     }
466     
467     function order(uint256 _tokenId, uint256 orderAmount ,address buyer)
468         public returns (bool)
469     {
470         require(msg.sender == address(nonFungibleContract));
471         address seller = tokenIdToAuction[_tokenId].seller;
472         require(seller !=address(nonFungibleContract));        
473         uint256 price =  _order(_tokenId,  orderAmount , 1 ) ;
474         _transfer(buyer, _tokenId);
475         addressIndexToOrderCount[buyer][_calculateDayPass()] +=1;
476         bool flag = true;
477         return flag;      
478     }
479     
480      function orderOnSaleAuction(uint256 _tokenId)
481         public
482         payable
483     {
484         address seller = tokenIdToAuction[_tokenId].seller;
485         uint256 price = _order(_tokenId, msg.value,0);
486         _transfer(msg.sender, _tokenId);
487         if (seller == address(nonFungibleContract)) {
488             lastGen0SalePrices[gen0SaleCount % 5] = price;
489             gen0SaleCount++;
490             nonFungibleContract.promoBun(msg.sender);
491         }
492         addressIndexToOrderCount[msg.sender][_calculateDayPass()] +=1;
493     }
494     
495 
496     function averageGen0SalePrice() public view returns (uint256) {
497         uint256 sum = 0;
498         for (uint256 i = 0; i < 5; i++) {
499             sum += lastGen0SalePrices[i];
500         }
501         return sum / 5;
502     }
503 
504 }