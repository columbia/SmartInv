1 pragma solidity 0.4.18;
2 
3 /*
4 
5   Sketches:
6   - can be created
7   - can be traded: you make a bid, the other party can accept or you can withdraw the bid
8   - can not be destroyed
9 
10 */
11 
12 contract Ownable {
13   address public owner;
14 
15 
16   function Ownable() public {
17     owner = msg.sender;
18   }
19 
20 
21   modifier onlyOwner() {
22     require(msg.sender == owner);
23     _;
24   }
25 
26   function transferOwnership(address newOwner) external onlyOwner {
27     require(newOwner != address(0));
28     owner = newOwner;
29   }
30 
31 }
32 
33 
34 contract SketchMarket is Ownable {
35   // ERC-20 compatibility {
36   string public standard = "CryptoSketches";
37   string public name;
38   string public symbol;
39   uint8 public decimals;
40   uint256 public totalSupply;
41 
42   mapping (address => uint256) public balanceOf;
43 
44   event Transfer(address indexed from, address indexed to, uint256 value);
45   // }
46 
47   // Sketch storage {
48   mapping(uint256 => string)  public sketchIndexToName;
49   mapping(uint256 => string)  public sketchIndexToData;
50   mapping(uint256 => address) public sketchIndexToHolder;
51   mapping(uint256 => address) public sketchIndexToAuthor;
52   mapping(uint256 => uint8)   public sketchIndexToOwnerFlag;
53 
54   mapping(address => uint256) public sketchAuthorCount;
55 
56   event SketchCreated(address indexed author, uint256 indexed sketchIndex);
57   // }
58 
59   // Sketch trading {
60 
61   // Cut owner takes on each auction, measured in basis points (1/100 of a percent).
62   // Values 0-10,000 map to 0%-100%
63   uint256 public ownerCut;
64 
65   // Amount owner takes on each submission, measured in Wei.
66   uint256 public listingFeeInWei;
67 
68   mapping (uint256 => Offer) public sketchIndexToOffer;
69   mapping (uint256 => Bid) public sketchIndexToHighestBid;
70   mapping (address => uint256) public accountToWithdrawableValue;
71 
72   event SketchTransfer(uint256 indexed sketchIndex, address indexed fromAddress, address indexed toAddress);
73   event SketchOffered(uint256 indexed sketchIndex, uint256 minValue, address indexed toAddress);
74   event SketchBidEntered(uint256 indexed sketchIndex, uint256 value, address indexed fromAddress);
75   event SketchBidWithdrawn(uint256 indexed sketchIndex, uint256 value, address indexed fromAddress);
76   event SketchBought(uint256 indexed sketchIndex, uint256 value, address indexed fromAddress, address indexed toAddress);
77   event SketchNoLongerForSale(uint256 indexed sketchIndex);
78 
79   struct Offer {
80     bool isForSale;
81     uint256 sketchIndex;
82     address seller;
83     uint256 minValue;   // ETH
84     address onlySellTo; // require a specific seller address
85   }
86 
87   struct Bid {
88     bool hasBid;
89     uint256 sketchIndex;
90     address bidder;
91     uint256 value;
92   }
93   // }
94 
95   // -- Constructor (see also: Ownable)
96 
97   function SketchMarket() public payable {
98     // ERC-20 token
99     totalSupply = 0;
100     name = "CRYPTOSKETCHES";
101     symbol = "S̈";
102     decimals = 0; // whole number; number of sketches owned
103 
104     // Trading parameters
105     ownerCut = 375; // 3.75% cut to auctioneer
106     listingFeeInWei = 5000000000000000; // 0.005 ETH, to discourage spam
107   }
108 
109   function setOwnerCut(uint256 _ownerCut) external onlyOwner {
110     require(_ownerCut == uint256(uint16(_ownerCut)));
111     require(_ownerCut <= 10000);
112     ownerCut = _ownerCut;
113   }
114 
115   function setListingFeeInWei(uint256 _listingFeeInWei) external onlyOwner {
116     require(_listingFeeInWei == uint256(uint128(_listingFeeInWei))); // length check
117     listingFeeInWei = _listingFeeInWei;
118   }
119 
120   // -- Creation and fetching methods
121 
122   function createSketch(string _name, string _data) external payable {
123     require(msg.value == listingFeeInWei);
124     require(bytes(_name).length < 256);     // limit name byte size to 255
125     require(bytes(_data).length < 1048576); // limit drawing byte size to 1,048,576
126 
127     accountToWithdrawableValue[owner] += msg.value; // auctioneer gets paid
128 
129     sketchIndexToHolder[totalSupply] = msg.sender;
130     sketchIndexToAuthor[totalSupply] = msg.sender;
131     sketchAuthorCount[msg.sender]++;
132 
133     sketchIndexToName[totalSupply] = _name;
134     sketchIndexToData[totalSupply] = _data;
135 
136     balanceOf[msg.sender]++;
137 
138     SketchCreated(msg.sender, totalSupply);
139 
140     totalSupply++;
141   }
142 
143   function setOwnerFlag(uint256 index, uint8 _ownerFlag) external onlyOwner {
144     sketchIndexToOwnerFlag[index] = _ownerFlag;
145   }
146 
147   function getSketch(uint256 index) external view returns (string _name, string _data, address _holder, address _author, uint8 _ownerFlag, uint256 _highestBidValue, uint256 _offerMinValue) {
148     require(totalSupply != 0);
149     require(index < totalSupply);
150 
151     _name = sketchIndexToName[index];
152     _data = sketchIndexToData[index];
153     _holder = sketchIndexToHolder[index];
154     _author = sketchIndexToAuthor[index];
155     _ownerFlag = sketchIndexToOwnerFlag[index];
156     _highestBidValue = sketchIndexToHighestBid[index].value;
157     _offerMinValue = sketchIndexToOffer[index].minValue;
158   }
159 
160   function getBidCountForSketchesWithHolder(address _holder) external view returns (uint256) {
161     uint256 count = balanceOf[_holder];
162 
163     if (count == 0) {
164       return 0;
165     } else {
166       uint256 result = 0;
167       uint256 totalCount = totalSupply;
168       uint256 sketchIndex;
169 
170       for (sketchIndex = 0; sketchIndex <= totalCount; sketchIndex++) {
171         if ((sketchIndexToHolder[sketchIndex] == _holder) && sketchIndexToHighestBid[sketchIndex].hasBid) {
172           result++;
173         }
174       }
175       return result;
176     }
177   }
178 
179   function getSketchesOnOffer() external view returns (uint256[]) {
180     if (totalSupply == 0) {
181       return new uint256[](0);
182     }
183 
184     uint256 count = 0;
185     uint256 totalCount = totalSupply;
186     uint256 sketchIndex;
187 
188     for (sketchIndex = 0; sketchIndex <= totalCount; sketchIndex++) {
189       if (sketchIndexToOffer[sketchIndex].isForSale) {
190         count++;
191       }
192     }
193 
194     if (count == 0) {
195       return new uint256[](0);
196     }
197 
198     uint256[] memory result = new uint256[](count);
199     uint256 resultIndex = 0;
200 
201     for (sketchIndex = 0; sketchIndex <= totalCount; sketchIndex++) {
202       if (sketchIndexToOffer[sketchIndex].isForSale) {
203         result[resultIndex] = sketchIndex;
204         resultIndex++;
205       }
206     }
207     return result;
208   }
209 
210   function getSketchesOnOfferWithHolder(address _holder) external view returns (uint256[]) {
211     if (totalSupply == 0) {
212       return new uint256[](0);
213     }
214 
215     uint256 count = 0;
216     uint256 totalCount = totalSupply;
217     uint256 sketchIndex;
218 
219     for (sketchIndex = 0; sketchIndex <= totalCount; sketchIndex++) {
220       if (sketchIndexToOffer[sketchIndex].isForSale && (sketchIndexToHolder[sketchIndex] == _holder)) {
221         count++;
222       }
223     }
224 
225     if (count == 0) {
226       return new uint256[](0);
227     }
228 
229     uint256[] memory result = new uint256[](count);
230     uint256 resultIndex = 0;
231 
232     for (sketchIndex = 0; sketchIndex <= totalCount; sketchIndex++) {
233       if (sketchIndexToOffer[sketchIndex].isForSale && (sketchIndexToHolder[sketchIndex] == _holder)) {
234         result[resultIndex] = sketchIndex;
235         resultIndex++;
236       }
237     }
238     return result;
239   }
240 
241   function getSketchesWithHolder(address _holder) external view returns (uint256[]) {
242     uint256 count = balanceOf[_holder];
243 
244     if (count == 0) {
245       return new uint256[](0);
246     } else {
247       uint256[] memory result = new uint256[](count);
248       uint256 totalCount = totalSupply;
249       uint256 resultIndex = 0;
250       uint256 sketchIndex;
251 
252       for (sketchIndex = 0; sketchIndex <= totalCount; sketchIndex++) {
253         if (sketchIndexToHolder[sketchIndex] == _holder) {
254           result[resultIndex] = sketchIndex;
255           resultIndex++;
256         }
257       }
258       return result;
259     }
260   }
261 
262   function getSketchesWithAuthor(address _author) external view returns (uint256[]) {
263     uint256 count = sketchAuthorCount[_author];
264 
265     if (count == 0) {
266       return new uint256[](0);      
267     } else {
268       uint256[] memory result = new uint256[](count);
269       uint256 totalCount = totalSupply;
270       uint256 resultIndex = 0;
271       uint256 sketchIndex;
272 
273       for (sketchIndex = 0; sketchIndex <= totalCount; sketchIndex++) {
274         if (sketchIndexToAuthor[sketchIndex] == _author) {
275           result[resultIndex] = sketchIndex;
276           resultIndex++;
277         }
278       }
279       return result;
280     }
281   }
282 
283   // -- Trading methods
284 
285   modifier onlyHolderOf(uint256 sketchIndex) {
286     require(totalSupply != 0);
287     require(sketchIndex < totalSupply);
288     require(sketchIndexToHolder[sketchIndex] == msg.sender);
289     _;
290  }
291 
292   // Transfer holdership without requiring payment
293   function transferSketch(address to, uint256 sketchIndex) external onlyHolderOf(sketchIndex) {
294     require(to != address(0));
295     require(balanceOf[msg.sender] > 0);
296 
297     if (sketchIndexToOffer[sketchIndex].isForSale) {
298       sketchNoLongerForSale(sketchIndex); // remove the offer
299     }
300 
301     sketchIndexToHolder[sketchIndex] = to;
302     balanceOf[msg.sender]--;
303     balanceOf[to]++;
304 
305     Transfer(msg.sender, to, 1); // ERC-20
306     SketchTransfer(sketchIndex, msg.sender, to);
307 
308     // If the recipient had bid for the Sketch, remove the bid and make it possible to refund its value
309     Bid storage bid = sketchIndexToHighestBid[sketchIndex];
310     if (bid.bidder == to) {
311         accountToWithdrawableValue[to] += bid.value;
312         sketchIndexToHighestBid[sketchIndex] = Bid(false, sketchIndex, 0x0, 0);
313     }
314   }
315 
316   // Withdraw Sketch from sale (NOTE: does not cancel bids, since bids must be withdrawn manually by bidders)
317   function sketchNoLongerForSale(uint256 _sketchIndex) public onlyHolderOf(_sketchIndex) {
318     sketchIndexToOffer[_sketchIndex] = Offer(false, _sketchIndex, msg.sender, 0, 0x0);
319     SketchNoLongerForSale(_sketchIndex);
320   }
321 
322   // Place a Sketch up for sale, to any buyer
323   function offerSketchForSale(uint256 _sketchIndex, uint256 _minSalePriceInWei) public onlyHolderOf(_sketchIndex) {
324     sketchIndexToOffer[_sketchIndex] = Offer(true, _sketchIndex, msg.sender, _minSalePriceInWei, 0x0);
325     SketchOffered(_sketchIndex, _minSalePriceInWei, 0x0);
326   }
327 
328   // Place a Sketch up for sale, but only to a specific buyer
329   function offerSketchForSaleToAddress(uint256 _sketchIndex, uint256 _minSalePriceInWei, address _toAddress) public onlyHolderOf(_sketchIndex) {
330     require(_toAddress != address(0));
331     require(_toAddress != msg.sender);
332 
333     sketchIndexToOffer[_sketchIndex] = Offer(true, _sketchIndex, msg.sender, _minSalePriceInWei, _toAddress);
334     SketchOffered(_sketchIndex, _minSalePriceInWei, _toAddress);
335   }
336 
337   // Accept a bid for a Sketch that you own, receiving the amount for withdrawal at any time - note minPrice safeguard!
338   function acceptBidForSketch(uint256 sketchIndex, uint256 minPrice) public onlyHolderOf(sketchIndex) {
339     address seller = msg.sender;    
340     require(balanceOf[seller] > 0);
341 
342     Bid storage bid = sketchIndexToHighestBid[sketchIndex];
343     uint256 price = bid.value;
344     address bidder = bid.bidder;
345 
346     require(price > 0);
347     require(price == uint256(uint128(price))); // length check for computeCut(...)
348     require(minPrice == uint256(uint128(minPrice))); // length check for computeCut(...)
349     require(price >= minPrice); // you may be accepting a different bid than you think, but its value will be at least as high
350 
351     sketchIndexToHolder[sketchIndex] = bidder; // transfer actual holdership!
352     balanceOf[seller]--; // update balances
353     balanceOf[bidder]++;
354     Transfer(seller, bidder, 1);
355 
356     sketchIndexToOffer[sketchIndex] = Offer(false, sketchIndex, bidder, 0, 0x0); // remove the offer    
357     sketchIndexToHighestBid[sketchIndex] = Bid(false, sketchIndex, 0x0, 0); // remove the bid
358 
359     uint256 ownerProceeds = computeCut(price);
360     uint256 holderProceeds = price - ownerProceeds;
361 
362     accountToWithdrawableValue[seller] += holderProceeds; // make profit available to seller for withdrawal
363     accountToWithdrawableValue[owner] += ownerProceeds;   // make cut available to auctioneer for withdrawal
364 
365     SketchBought(sketchIndex, price, seller, bidder); // note that SketchNoLongerForSale event will not be fired
366   }
367 
368   // Buy a Sketch that's up for sale now, provided you've matched the Offer price and it's not on offer to a specific buyer
369   function buySketch(uint256 sketchIndex) external payable {      
370     Offer storage offer = sketchIndexToOffer[sketchIndex];
371     uint256 messageValue = msg.value;
372 
373     require(totalSupply != 0);
374     require(sketchIndex < totalSupply);
375     require(offer.isForSale);
376     require(offer.onlySellTo == 0x0 || offer.onlySellTo == msg.sender);
377     require(messageValue >= offer.minValue);
378     require(messageValue == uint256(uint128(messageValue))); // length check for computeCut(...)
379     require(offer.seller == sketchIndexToHolder[sketchIndex]); // the holder may have changed since an Offer was last put up
380 
381     address holder = offer.seller;
382     require(balanceOf[holder] > 0);
383 
384     sketchIndexToHolder[sketchIndex] = msg.sender; // transfer actual holdership!
385     balanceOf[holder]--; // update balances
386     balanceOf[msg.sender]++;
387     Transfer(holder, msg.sender, 1);
388 
389     sketchNoLongerForSale(sketchIndex); // remove the offer
390 
391     uint256 ownerProceeds = computeCut(messageValue);
392     uint256 holderProceeds = messageValue - ownerProceeds;
393 
394     accountToWithdrawableValue[owner] += ownerProceeds;
395     accountToWithdrawableValue[holder] += holderProceeds;
396 
397     SketchBought(sketchIndex, messageValue, holder, msg.sender);
398 
399     // Refund any bid the new buyer had placed for this Sketch.
400     // Other bids have to stay put for continued consideration or until their values have been withdrawn.
401     Bid storage bid = sketchIndexToHighestBid[sketchIndex];
402     if (bid.bidder == msg.sender) {
403         accountToWithdrawableValue[msg.sender] += bid.value;
404         sketchIndexToHighestBid[sketchIndex] = Bid(false, sketchIndex, 0x0, 0); // remove the bid
405     }
406   }
407 
408   // Withdraw any value owed to:
409   // (a) a buyer that withdraws their bid or invalidates it by purchasing a Sketch outright for its asking price
410   // (b) a seller owed funds from the sale of a Sketch
411   function withdraw() external {
412       uint256 amount = accountToWithdrawableValue[msg.sender];
413       // Zero the pending refund before transferring to prevent re-entrancy attacks
414       accountToWithdrawableValue[msg.sender] = 0;
415       msg.sender.transfer(amount);
416   }
417 
418   // Enter a bid, regardless of whether the Sketch holder wishes to sell or not
419   function enterBidForSketch(uint256 sketchIndex) external payable {
420       require(totalSupply != 0);
421       require(sketchIndex < totalSupply);
422       require(sketchIndexToHolder[sketchIndex] != 0x0); // can't bid on "non-owned" Sketch (theoretically impossible anyway)
423       require(sketchIndexToHolder[sketchIndex] != msg.sender); // can't bid on a Sketch that you own
424 
425       uint256 price = msg.value; // in wei
426 
427       require(price > 0); // can't bid zero
428       require(price == uint256(uint128(price))); // length check for computeCut(...)      
429 
430       Bid storage existing = sketchIndexToHighestBid[sketchIndex];
431 
432       require(price > existing.value); // can't bid less than highest bid
433 
434       if (existing.value > 0) {
435           // Place the amount from the previous highest bid into escrow for withdrawal at any time
436           accountToWithdrawableValue[existing.bidder] += existing.value;
437       }
438       sketchIndexToHighestBid[sketchIndex] = Bid(true, sketchIndex, msg.sender, price);
439 
440       SketchBidEntered(sketchIndex, price, msg.sender);
441   }
442 
443   function withdrawBidForSketch(uint256 sketchIndex) public {
444     require(totalSupply != 0);
445     require(sketchIndex < totalSupply);
446     require(sketchIndexToHolder[sketchIndex] != 0x0); // can't bid on "non-owned" Sketch (theoretically impossible anyway)
447     require(sketchIndexToHolder[sketchIndex] != msg.sender); // can't withdraw a bid for a Sketch that you own
448       
449     Bid storage bid = sketchIndexToHighestBid[sketchIndex];
450     require(bid.bidder == msg.sender); // it has to be your bid
451 
452     SketchBidWithdrawn(sketchIndex, bid.value, msg.sender);
453 
454     uint256 amount = bid.value;
455     sketchIndexToHighestBid[sketchIndex] = Bid(false, sketchIndex, 0x0, 0);
456 
457     // Refund the bid money directly
458     msg.sender.transfer(amount);
459   }
460 
461   function computeCut(uint256 price) internal view returns (uint256) {
462     // NOTE: We don't use SafeMath (or similar) in this function because
463     //  all of our entry functions carefully cap the maximum values for
464     //  currency (at 128-bits), and ownerCut <= 10000. The result of this
465     //  function is always guaranteed to be <= _price.
466     return price * ownerCut / 10000;
467   }
468 
469 }