1 pragma solidity 0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
12 
13     /**
14      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
15      * account.
16      */
17     constructor() public {
18         owner = msg.sender;
19     }
20 
21 
22     /**
23      * @dev Throws if called by any account other than the owner.
24      */
25     modifier onlyOwner() {
26         require(msg.sender == owner);
27         _;
28     }
29 
30 
31     /**
32      * @dev Allows the current owner to transfer control of the contract to a newOwner.
33      * @param newOwner The address to transfer ownership to.
34      */
35     function transferOwnership(address newOwner) public onlyOwner {
36         require(newOwner != address(0));
37         emit OwnershipTransferred(owner, newOwner);
38         owner = newOwner;
39     }
40 
41 }
42 
43 /**
44  * @dev Contract that is aware of time. Useful for tests - like this
45  *      we can mock time.
46  */
47 contract TimeAware is Ownable {
48 
49     /**
50     * @dev Returns current time.
51     */
52     function getTime() public view returns (uint) {
53         return now;
54     }
55 
56 }
57 
58 /**
59  * @dev Contract that holds pending withdrawals. Responsible for withdrawals.
60  */
61 contract Withdrawable {
62 
63     mapping(address => uint) private pendingWithdrawals;
64 
65     event Withdrawal(address indexed receiver, uint amount);
66     event BalanceChanged(address indexed _address, uint oldBalance, uint newBalance);
67 
68     /**
69     * Returns amount of wei that given address is able to withdraw.
70     */
71     function getPendingWithdrawal(address _address) public view returns (uint) {
72         return pendingWithdrawals[_address];
73     }
74 
75     /**
76     * Add pending withdrawal for an address.
77     */
78     function addPendingWithdrawal(address _address, uint _amount) internal {
79         require(_address != 0x0);
80 
81         uint oldBalance = pendingWithdrawals[_address];
82         pendingWithdrawals[_address] += _amount;
83 
84         emit BalanceChanged(_address, oldBalance, oldBalance + _amount);
85     }
86 
87     /**
88     * Withdraws all pending withdrawals.
89     */
90     function withdraw() external {
91         uint amount = getPendingWithdrawal(msg.sender);
92         require(amount > 0);
93 
94         pendingWithdrawals[msg.sender] = 0;
95         msg.sender.transfer(amount);
96 
97         emit Withdrawal(msg.sender, amount);
98         emit BalanceChanged(msg.sender, amount, 0);
99     }
100 
101 }
102 
103 /**
104 * @dev This contract takes care of painting on canvases, returning artworks and creating ones. 
105 */
106 contract CanvasFactory is TimeAware {
107 
108     //@dev It means canvas is not finished yet, and bidding is not possible.
109     uint8 public constant STATE_NOT_FINISHED = 0;
110 
111     //@dev  there is ongoing bidding and anybody can bid. If there canvas can have
112     //      assigned owner, but it can change if someone will over-bid him.
113     uint8 public constant STATE_INITIAL_BIDDING = 1;
114 
115     //@dev canvas has been sold, and has the owner
116     uint8 public constant STATE_OWNED = 2;
117 
118     uint8 public constant WIDTH = 64;
119     uint8 public constant HEIGHT = 64;
120     uint32 public constant PIXEL_COUNT = 4096; //WIDTH * HEIGHT doesn't work for some reason
121 
122     uint32 public constant MAX_CANVAS_COUNT = 1000;
123     uint8 public constant MAX_ACTIVE_CANVAS = 12;
124 
125     Canvas[] canvases;
126     uint32 public activeCanvasCount = 0;
127 
128     event PixelPainted(uint32 indexed canvasId, uint32 index, uint8 color, address indexed painter);
129     event CanvasFinished(uint32 indexed canvasId);
130     event CanvasCreated(uint indexed canvasId);
131 
132     modifier notFinished(uint32 _canvasId) {
133         require(!isCanvasFinished(_canvasId));
134         _;
135     }
136 
137     modifier finished(uint32 _canvasId) {
138         require(isCanvasFinished(_canvasId));
139         _;
140     }
141 
142     modifier validPixelIndex(uint32 _pixelIndex) {
143         require(_pixelIndex < PIXEL_COUNT);
144         _;
145     }
146 
147     /**
148     * @notice   Creates new canvas. There can't be more canvases then MAX_CANVAS_COUNT.
149     *           There can't be more unfinished canvases than MAX_ACTIVE_CANVAS.
150     */
151     function createCanvas() external returns (uint canvasId) {
152         require(canvases.length < MAX_CANVAS_COUNT);
153         require(activeCanvasCount < MAX_ACTIVE_CANVAS);
154 
155         uint id = canvases.push(Canvas(STATE_NOT_FINISHED, 0x0, 0, 0, false)) - 1;
156 
157         emit CanvasCreated(id);
158         activeCanvasCount++;
159 
160         return id;
161     }
162 
163     /**
164     * @notice   Sets pixel. Given canvas can't be yet finished.
165     */
166     function setPixel(uint32 _canvasId, uint32 _index, uint8 _color) external notFinished(_canvasId) validPixelIndex(_index) {
167         require(_color > 0);
168 
169         Canvas storage canvas = _getCanvas(_canvasId);
170         Pixel storage pixel = canvas.pixels[_index];
171 
172         // pixel always has a painter. If it's equal to address(0) it means 
173         // that pixel hasn't been set.
174         if (pixel.painter == 0x0) {
175             canvas.paintedPixelsCount++;
176         } else {
177             canvas.addressToCount[pixel.painter]--;
178         }
179 
180         canvas.addressToCount[msg.sender]++;
181         canvas.pixels[_index] = Pixel(_color, msg.sender);
182 
183         if (_isCanvasFinished(canvas)) {
184             activeCanvasCount--;
185             canvas.state = STATE_INITIAL_BIDDING;
186             emit CanvasFinished(_canvasId);
187         }
188 
189         emit PixelPainted(_canvasId, _index, _color, msg.sender);
190     }
191 
192     /**
193     * @notice   Returns full bitmap for given canvas.
194     */
195     function getCanvasBitmap(uint32 _canvasId) external view returns (uint8[]) {
196         Canvas storage canvas = _getCanvas(_canvasId);
197         uint8[] memory result = new uint8[](PIXEL_COUNT);
198 
199         for (uint32 i = 0; i < PIXEL_COUNT; i++) {
200             result[i] = canvas.pixels[i].color;
201         }
202 
203         return result;
204     }
205 
206     /**
207     * @notice   Returns how many pixels has been already set.
208     */
209     function getCanvasPaintedPixelsCount(uint32 _canvasId) public view returns (uint32) {
210         return _getCanvas(_canvasId).paintedPixelsCount;
211     }
212 
213     function getPixelCount() external pure returns (uint) {
214         return PIXEL_COUNT;
215     }
216 
217     /**
218     * @notice   Returns amount of created canvases.
219     */
220     function getCanvasCount() public view returns (uint) {
221         return canvases.length;
222     }
223 
224     /**
225     * @notice   Returns true if the canvas has been already finished.
226     */
227     function isCanvasFinished(uint32 _canvasId) public view returns (bool) {
228         return _isCanvasFinished(_getCanvas(_canvasId));
229     }
230 
231     /**
232     * @notice   Returns the author of given pixel.
233     */
234     function getPixelAuthor(uint32 _canvasId, uint32 _pixelIndex) public view validPixelIndex(_pixelIndex) returns (address) {
235         return _getCanvas(_canvasId).pixels[_pixelIndex].painter;
236     }
237 
238     /**
239     * @notice   Returns number of pixels set by given address.
240     */
241     function getPaintedPixelsCountByAddress(address _address, uint32 _canvasId) public view returns (uint32) {
242         Canvas storage canvas = _getCanvas(_canvasId);
243         return canvas.addressToCount[_address];
244     }
245 
246     function _isCanvasFinished(Canvas canvas) internal pure returns (bool) {
247         return canvas.paintedPixelsCount == PIXEL_COUNT;
248     }
249 
250     function _getCanvas(uint32 _canvasId) internal view returns (Canvas storage) {
251         require(_canvasId < canvases.length);
252         return canvases[_canvasId];
253     }
254 
255     struct Pixel {
256         uint8 color;
257         address painter;
258     }
259 
260     struct Canvas {
261         /**
262         * Map of all pixels. 
263         */
264         mapping(uint32 => Pixel) pixels;
265 
266         uint8 state;
267 
268         /**
269         * Owner of canvas. Canvas doesn't have an owner until initial bidding ends. 
270         */
271         address owner;
272 
273         /**
274         * Numbers of pixels set. Canvas will be considered finished when all pixels will be set.
275         * Technically it means that setPixelsCount == PIXEL_COUNT
276         */
277         uint32 paintedPixelsCount;
278 
279         mapping(address => uint32) addressToCount;
280 
281 
282         /**
283         * Initial bidding finish time.
284         */
285         uint initialBiddingFinishTime;
286 
287         /**
288         * If commission from initial bidding has been paid.
289         */
290         bool isCommissionPaid;
291 
292         /**
293         * @dev if address has been paid a reward for drawing.
294         */
295         mapping(address => bool) isAddressPaid;
296     }
297 }
298 
299 /**
300 * @dev This contract takes care of initial bidding.
301 */
302 contract BiddableCanvas is CanvasFactory, Withdrawable {
303 
304     /**
305     * As it's hard to operate on floating numbers, each fee will be calculated like this:
306     * PRICE * COMMISSION / COMMISSION_DIVIDER. It's impossible to keep float number here.
307     *
308     * ufixed COMMISSION = 0.039; may seem useful, but it's not possible to multiply ufixed * uint.
309     */
310     uint public constant COMMISSION = 39;
311     uint public constant COMMISSION_DIVIDER = 1000;
312 
313     uint8 public constant ACTION_INITIAL_BIDDING = 0;
314     uint8 public constant ACTION_SELL_OFFER_ACCEPTED = 1;
315     uint8 public constant ACTION_BUY_OFFER_ACCEPTED = 2;
316 
317     uint public constant BIDDING_DURATION = 48 hours;
318 
319     mapping(uint32 => Bid) bids;
320     mapping(address => uint32) addressToCount;
321 
322     uint public minimumBidAmount = 0.1 ether;
323 
324     event BidPosted(uint32 indexed canvasId, address indexed bidder, uint amount, uint finishTime);
325     event RewardAddedToWithdrawals(uint32 indexed canvasId, address indexed toAddress, uint amount);
326     event CommissionAddedToWithdrawals(uint32 indexed canvasId, uint amount, uint8 indexed action);
327 
328     modifier stateBidding(uint32 _canvasId) {
329         require(getCanvasState(_canvasId) == STATE_INITIAL_BIDDING);
330         _;
331     }
332 
333     modifier stateOwned(uint32 _canvasId) {
334         require(getCanvasState(_canvasId) == STATE_OWNED);
335         _;
336     }
337 
338     /**
339     * Ensures that canvas's saved state is STATE_OWNED.
340     *
341     * Because initial bidding is based on current time, we had to find a way to
342     * trigger saving new canvas state. Every transaction (not a call) that
343     * requires state owned should use it modifier as a last one.
344     *
345     * Thank's to that, we can make sure, that canvas state gets updated.
346     */
347     modifier forceOwned(uint32 _canvasId) {
348         Canvas storage canvas = _getCanvas(_canvasId);
349         if (canvas.state != STATE_OWNED) {
350             canvas.state = STATE_OWNED;
351         }
352         _;
353     }
354 
355     /**
356     * Places bid for canvas that is in the state STATE_INITIAL_BIDDING.
357     * If somebody is outbid his pending withdrawals will be to topped up.
358     */
359     function makeBid(uint32 _canvasId) external payable stateBidding(_canvasId) {
360         Canvas storage canvas = _getCanvas(_canvasId);
361         Bid storage oldBid = bids[_canvasId];
362 
363         if (msg.value < minimumBidAmount || msg.value <= oldBid.amount) {
364             revert();
365         }
366 
367         if (oldBid.bidder != 0x0 && oldBid.amount > 0) {
368             //return old bidder his money
369             addPendingWithdrawal(oldBid.bidder, oldBid.amount);
370         }
371 
372         uint finishTime = canvas.initialBiddingFinishTime;
373         if (finishTime == 0) {
374             canvas.initialBiddingFinishTime = getTime() + BIDDING_DURATION;
375         }
376 
377         bids[_canvasId] = Bid(msg.sender, msg.value);
378 
379         if (canvas.owner != 0x0) {
380             addressToCount[canvas.owner]--;
381         }
382         canvas.owner = msg.sender;
383         addressToCount[msg.sender]++;
384 
385         emit BidPosted(_canvasId, msg.sender, msg.value, canvas.initialBiddingFinishTime);
386     }
387 
388     /**
389     * @notice   Returns last bid for canvas. If the initial bidding has been
390     *           already finished that will be winning offer.
391     */
392     function getLastBidForCanvas(uint32 _canvasId) external view returns (uint32 canvasId, address bidder, uint amount, uint finishTime) {
393         Bid storage bid = bids[_canvasId];
394         Canvas storage canvas = _getCanvas(_canvasId);
395 
396         return (_canvasId, bid.bidder, bid.amount, canvas.initialBiddingFinishTime);
397     }
398 
399     /**
400     * @notice   Returns current canvas state.
401     */
402     function getCanvasState(uint32 _canvasId) public view returns (uint8) {
403         Canvas storage canvas = _getCanvas(_canvasId);
404         if (canvas.state != STATE_INITIAL_BIDDING) {
405             //if state is set to owned, or not finished
406             //it means it doesn't depend on current time -
407             //we don't have to double check
408             return canvas.state;
409         }
410 
411         //state initial bidding - as that state depends on
412         //current time, we have to double check if initial bidding
413         //hasn't finish yet
414         uint finishTime = canvas.initialBiddingFinishTime;
415         if (finishTime == 0 || finishTime > getTime()) {
416             return STATE_INITIAL_BIDDING;
417 
418         } else {
419             return STATE_OWNED;
420         }
421     }
422 
423     /**
424     * @notice   Returns all canvas' id for a given state.
425     */
426     function getCanvasByState(uint8 _state) external view returns (uint32[]) {
427         uint size;
428         if (_state == STATE_NOT_FINISHED) {
429             size = activeCanvasCount;
430         } else {
431             size = getCanvasCount() - activeCanvasCount;
432         }
433 
434         uint32[] memory result = new uint32[](size);
435         uint currentIndex = 0;
436 
437         for (uint32 i = 0; i < canvases.length; i++) {
438             if (getCanvasState(i) == _state) {
439                 result[currentIndex] = i;
440                 currentIndex++;
441             }
442         }
443 
444         return _slice(result, 0, currentIndex);
445     }
446 
447     /**
448     * @notice   Returns reward for painting pixels in wei. That reward is proportional
449     *           to number of set pixels. For example let's assume that the address has painted
450     *           2048 pixels, which is 50% of all pixels. He will be rewarded
451     *           with 50% of winning bid minus fee.
452     */
453     function calculateReward(uint32 _canvasId, address _address)
454     public
455     view
456     stateOwned(_canvasId)
457     returns (uint32 pixelsCount, uint reward, bool isPaid) {
458 
459         Bid storage bid = bids[_canvasId];
460         Canvas storage canvas = _getCanvas(_canvasId);
461 
462         uint32 paintedPixels = getPaintedPixelsCountByAddress(_address, _canvasId);
463         uint pricePerPixel = _calculatePricePerPixel(bid.amount);
464         uint _reward = paintedPixels * pricePerPixel;
465 
466         return (paintedPixels, _reward, canvas.isAddressPaid[_address]);
467     }
468 
469     /**
470     * Withdraws reward for contributing in canvas. Calculating reward has to be triggered
471     * and calculated per canvas. Because of that it is not enough to call function
472     * withdraw(). Caller has to call  addRewardToPendingWithdrawals() separately.
473     */
474     function addRewardToPendingWithdrawals(uint32 _canvasId)
475     external
476     stateOwned(_canvasId)
477     forceOwned(_canvasId) {
478         Canvas storage canvas = _getCanvas(_canvasId);
479 
480         uint32 pixelCount;
481         uint reward;
482         bool isPaid;
483         (pixelCount, reward, isPaid) = calculateReward(_canvasId, msg.sender);
484 
485         require(pixelCount > 0);
486         require(reward > 0);
487         require(!isPaid);
488 
489         canvas.isAddressPaid[msg.sender] = true;
490         addPendingWithdrawal(msg.sender, reward);
491 
492         emit RewardAddedToWithdrawals(_canvasId, msg.sender, reward);
493     }
494 
495     /**
496     * @notice   Calculates commission that has been charged for selling the canvas.
497     */
498     function calculateCommission(uint32 _canvasId)
499     public
500     view
501     stateOwned(_canvasId)
502     returns (uint commission, bool isPaid) {
503 
504         Bid storage bid = bids[_canvasId];
505         Canvas storage canvas = _getCanvas(_canvasId);
506 
507         return (_calculateCommission(bid.amount), canvas.isCommissionPaid);
508     }
509 
510     /**
511     * @notice   Only for the owner of the contract. Adds commission to the owner's
512     *           pending withdrawals.
513     */
514     function addCommissionToPendingWithdrawals(uint32 _canvasId)
515     external
516     onlyOwner
517     stateOwned(_canvasId)
518     forceOwned(_canvasId) {
519 
520         Canvas storage canvas = _getCanvas(_canvasId);
521 
522         uint commission;
523         bool isPaid;
524         (commission, isPaid) = calculateCommission(_canvasId);
525 
526         require(commission > 0);
527         require(!isPaid);
528 
529         canvas.isCommissionPaid = true;
530         addPendingWithdrawal(owner, commission);
531 
532         emit CommissionAddedToWithdrawals(_canvasId, commission, ACTION_INITIAL_BIDDING);
533     }
534 
535     /**
536     * @notice   Returns number of canvases owned by the given address.
537     */
538     function balanceOf(address _owner) external view returns (uint) {
539         return addressToCount[_owner];
540     }
541 
542     /**
543     * @notice   Only for the owner of the contract. Sets minimum bid amount.
544     */
545     function setMinimumBidAmount(uint _amount) external onlyOwner {
546         minimumBidAmount = _amount;
547     }
548 
549     function _calculatePricePerPixel(uint _totalPrice) private pure returns (uint) {
550         return (_totalPrice - _calculateCommission(_totalPrice)) / PIXEL_COUNT;
551     }
552 
553     function _calculateCommission(uint _amount) internal pure returns (uint) {
554         return (_amount * COMMISSION) / COMMISSION_DIVIDER;
555     }
556 
557     /**
558     * @dev  Slices array from start (inclusive) to end (exclusive).
559     *       Doesn't modify input array.
560     */
561     function _slice(uint32[] memory _array, uint _start, uint _end) internal pure returns (uint32[]) {
562         require(_start <= _end);
563 
564         if (_start == 0 && _end == _array.length) {
565             return _array;
566         }
567 
568         uint size = _end - _start;
569         uint32[] memory sliced = new uint32[](size);
570 
571         for (uint i = 0; i < size; i++) {
572             sliced[i] = _array[i + _start];
573         }
574 
575         return sliced;
576     }
577 
578     struct Bid {
579         address bidder;
580         uint amount;
581     }
582 
583 }
584 
585 /**
586 * @dev  This contract takes trading our artworks. Trading can happen
587 *       if artwork has been initially bought. 
588 */
589 contract CanvasMarket is BiddableCanvas {
590 
591     mapping(uint32 => SellOffer) canvasForSale;
592     mapping(uint32 => BuyOffer) buyOffers;
593 
594     event CanvasOfferedForSale(uint32 indexed canvasId, uint minPrice, address indexed from, address indexed to);
595     event SellOfferCancelled(uint32 indexed canvasId, uint minPrice, address indexed from, address indexed to);
596     event CanvasSold(uint32 indexed canvasId, uint amount, address indexed from, address indexed to);
597     event BuyOfferMade(uint32 indexed canvasId, address indexed buyer, uint amount);
598     event BuyOfferCancelled(uint32 indexed canvasId, address indexed buyer, uint amount);
599 
600     struct SellOffer {
601         bool isForSale;
602         address seller;
603         uint minPrice;
604         address onlySellTo;     // specify to sell only to a specific address
605     }
606 
607     struct BuyOffer {
608         bool hasOffer;
609         address buyer;
610         uint amount;
611     }
612 
613     /**
614     * @notice   Buy artwork. Artwork has to be put on sale. If buyer has bid before for
615     *           that artwork, that bid will be canceled.
616     */
617     function acceptSellOffer(uint32 _canvasId)
618     external
619     payable
620     stateOwned(_canvasId)
621     forceOwned(_canvasId) {
622 
623         Canvas storage canvas = _getCanvas(_canvasId);
624         SellOffer memory sellOffer = canvasForSale[_canvasId];
625 
626         require(msg.sender != canvas.owner);
627         //don't sell for the owner
628         require(sellOffer.isForSale);
629         require(msg.value >= sellOffer.minPrice);
630         require(sellOffer.seller == canvas.owner);
631         //seller is no longer owner
632         require(sellOffer.onlySellTo == 0x0 || sellOffer.onlySellTo == msg.sender);
633         //protect from selling to unintended address
634 
635         uint fee = _calculateCommission(msg.value);
636         uint toTransfer = msg.value - fee;
637 
638         addPendingWithdrawal(sellOffer.seller, toTransfer);
639         addPendingWithdrawal(owner, fee);
640 
641         addressToCount[canvas.owner]--;
642         addressToCount[msg.sender]++;
643 
644         canvas.owner = msg.sender;
645         cancelSellOfferInternal(_canvasId, false);
646 
647         emit CanvasSold(_canvasId, msg.value, sellOffer.seller, msg.sender);
648         emit CommissionAddedToWithdrawals(_canvasId, fee, ACTION_SELL_OFFER_ACCEPTED);
649 
650         //If the buyer have placed buy offer, refund it
651         BuyOffer memory offer = buyOffers[_canvasId];
652         if (offer.buyer == msg.sender) {
653             buyOffers[_canvasId] = BuyOffer(false, 0x0, 0);
654             if (offer.amount > 0) {
655                 //refund offer
656                 addPendingWithdrawal(offer.buyer, offer.amount);
657             }
658         }
659 
660     }
661 
662     /**
663     * @notice   Offer canvas for sale for a minimal price.
664     *           Anybody can buy it for an amount grater or equal to min price.
665     */
666     function offerCanvasForSale(uint32 _canvasId, uint _minPrice) external {
667         _offerCanvasForSaleInternal(_canvasId, _minPrice, 0x0);
668     }
669 
670     /**
671     * @notice   Offer canvas for sale to a given address. Only that address
672     *           is allowed to buy canvas for an amount grater or equal
673     *           to minimal price.
674     */
675     function offerCanvasForSaleToAddress(uint32 _canvasId, uint _minPrice, address _receiver) external {
676         _offerCanvasForSaleInternal(_canvasId, _minPrice, _receiver);
677     }
678 
679     /**
680     * @notice   Cancels previously made sell offer. Caller has to be an owner
681     *           of the canvas. Function will fail if there is no sell offer
682     *           for the canvas.
683     */
684     function cancelSellOffer(uint32 _canvasId) external {
685         cancelSellOfferInternal(_canvasId, true);
686     }
687 
688     /**
689     * @notice   Places buy offer for the canvas. It cannot be called by the owner of the canvas.
690     *           New offer has to be bigger than existing offer. Returns ethers to the previous
691     *           bidder, if any.
692     */
693     function makeBuyOffer(uint32 _canvasId) external payable stateOwned(_canvasId) forceOwned(_canvasId) {
694         Canvas storage canvas = _getCanvas(_canvasId);
695         BuyOffer storage existing = buyOffers[_canvasId];
696 
697         require(canvas.owner != msg.sender);
698         require(canvas.owner != 0x0);
699         require(msg.value > existing.amount);
700 
701         if (existing.amount > 0) {
702             //refund previous buy offer.
703             addPendingWithdrawal(existing.buyer, existing.amount);
704         }
705 
706         buyOffers[_canvasId] = BuyOffer(true, msg.sender, msg.value);
707         emit BuyOfferMade(_canvasId, msg.sender, msg.value);
708     }
709 
710     /**
711     * @notice   Cancels previously made buy offer. Caller has to be an author
712     *           of the offer.
713     */
714     function cancelBuyOffer(uint32 _canvasId) external stateOwned(_canvasId) forceOwned(_canvasId) {
715         BuyOffer memory offer = buyOffers[_canvasId];
716         require(offer.buyer == msg.sender);
717 
718         buyOffers[_canvasId] = BuyOffer(false, 0x0, 0);
719         if (offer.amount > 0) {
720             //refund offer
721             addPendingWithdrawal(offer.buyer, offer.amount);
722         }
723 
724         emit BuyOfferCancelled(_canvasId, offer.buyer, offer.amount);
725     }
726 
727     /**
728     * @notice   Accepts buy offer for the canvas. Caller has to be the owner
729     *           of the canvas. You can specify minimal price, which is the
730     *           protection against accidental calls.
731     */
732     function acceptBuyOffer(uint32 _canvasId, uint _minPrice) external stateOwned(_canvasId) forceOwned(_canvasId) {
733         Canvas storage canvas = _getCanvas(_canvasId);
734         require(canvas.owner == msg.sender);
735 
736         BuyOffer memory offer = buyOffers[_canvasId];
737         require(offer.hasOffer);
738         require(offer.amount > 0);
739         require(offer.buyer != 0x0);
740         require(offer.amount >= _minPrice);
741 
742         uint fee = _calculateCommission(offer.amount);
743         uint toTransfer = offer.amount - fee;
744 
745         addressToCount[canvas.owner]--;
746         addressToCount[offer.buyer]++;
747 
748         canvas.owner = offer.buyer;
749         addPendingWithdrawal(msg.sender, toTransfer);
750         addPendingWithdrawal(owner, fee);
751 
752         buyOffers[_canvasId] = BuyOffer(false, 0x0, 0);
753         canvasForSale[_canvasId] = SellOffer(false, 0x0, 0, 0x0);
754 
755         emit CanvasSold(_canvasId, offer.amount, msg.sender, offer.buyer);
756         emit CommissionAddedToWithdrawals(_canvasId, fee, ACTION_BUY_OFFER_ACCEPTED);
757     }
758 
759     /**
760     * @notice   Returns current buy offer for the canvas.
761     */
762     function getCurrentBuyOffer(uint32 _canvasId)
763     external
764     view
765     returns (bool hasOffer, address buyer, uint amount) {
766         BuyOffer storage offer = buyOffers[_canvasId];
767         return (offer.hasOffer, offer.buyer, offer.amount);
768     }
769 
770     /**
771     * @notice   Returns current sell offer for the canvas.
772     */
773     function getCurrentSellOffer(uint32 _canvasId)
774     external
775     view
776     returns (bool isForSale, address seller, uint minPrice, address onlySellTo) {
777 
778         SellOffer storage offer = canvasForSale[_canvasId];
779         return (offer.isForSale, offer.seller, offer.minPrice, offer.onlySellTo);
780     }
781 
782     function _offerCanvasForSaleInternal(uint32 _canvasId, uint _minPrice, address _receiver)
783     private
784     stateOwned(_canvasId)
785     forceOwned(_canvasId) {
786 
787         Canvas storage canvas = _getCanvas(_canvasId);
788         require(canvas.owner == msg.sender);
789         require(_receiver != canvas.owner);
790 
791         canvasForSale[_canvasId] = SellOffer(true, msg.sender, _minPrice, _receiver);
792         emit CanvasOfferedForSale(_canvasId, _minPrice, msg.sender, _receiver);
793     }
794 
795     function cancelSellOfferInternal(uint32 _canvasId, bool emitEvent)
796     private
797     stateOwned(_canvasId)
798     forceOwned(_canvasId) {
799 
800         Canvas storage canvas = _getCanvas(_canvasId);
801         SellOffer memory oldOffer = canvasForSale[_canvasId];
802 
803         require(canvas.owner == msg.sender);
804         require(oldOffer.isForSale);
805         //don't allow to cancel if there is no offer
806 
807         canvasForSale[_canvasId] = SellOffer(false, msg.sender, 0, 0x0);
808 
809         if (emitEvent) {
810             emit SellOfferCancelled(_canvasId, oldOffer.minPrice, oldOffer.seller, oldOffer.onlySellTo);
811         }
812     }
813 
814 }
815 
816 /**
817 * CryptoCanvas Terms of Use
818 *
819 * 1. Intro
820 *
821 * CryptoCanvas is a set of collectible artworks (“Canvas”) created by the CryptoCanvas community with proof of ownership stored on the Ethereum blockchain.
822 *
823 * This agreement does a few things. First, it passes copyright ownership of a Canvas from the Canvas Authors to the first Canvas Owner. The first Canvas Owner is then obligated to pass on the copyright ownership along with the Canvas to the next owner, and so on forever, such that each owner of a Canvas is also the copyright owner. Second, it requires each Canvas Owner to allow certain uses of their Canvas image. Third, it limits the rights of Canvas owners to sue The Mindhouse and the prior owners of the Canvas.
824 *
825 * Canvases of CryptoCanvas are not an investment. They are experimental digital art.
826 *
827 * PLEASE READ THESE TERMS CAREFULLY BEFORE USING THE APP, THE SMART CONTRACTS, OR THE SITE. BY USING THE APP, THE SMART CONTRACTS, THE SITE, OR ANY PART OF THEM YOU ARE CONFIRMING THAT YOU UNDERSTAND AND AGREE TO BE BOUND BY ALL OF THESE TERMS. IF YOU ARE ACCEPTING THESE TERMS ON BEHALF OF A COMPANY OR OTHER LEGAL ENTITY, YOU REPRESENT THAT YOU HAVE THE LEGAL AUTHORITY TO ACCEPT THESE TERMS ON THAT ENTITY’S BEHALF, IN WHICH CASE “YOU” WILL MEAN THAT ENTITY. IF YOU DO NOT HAVE SUCH AUTHORITY, OR IF YOU DO NOT ACCEPT ALL OF THESE TERMS, THEN WE ARE UNWILLING TO MAKE THE APP, THE SMART CONTRACTS, OR THE SITE AVAILABLE TO YOU. IF YOU DO NOT AGREE TO THESE TERMS, YOU MAY NOT ACCESS OR USE THE APP, THE SMART CONTRACTS, OR THE SITE.
828 *
829 * 2. Definitions
830 *
831 * “Smart Contract” refers to this smart contract.
832 *
833 * “Canvas” means a collectible artwork created by the CryptoCanvas community with information about the color and author of each pixel of the Canvas, and proof of ownership stored in the Smart Contract. The Canvas is considered finished when all the pixels of the Canvas have their color set. Specifically, the Canvas is considered finished when its “state” field in the Smart Contract equals to STATE_INITIAL_BIDDING or STATE_OWNED constant.
834 *
835 * “Canvas Author” means the person who painted at least one final pixel of the finished Canvas by sending a transaction to the Smart Contract. A person whose pixel has been painted over by another person loses rights to that pixel. Specifically, Canvas Author means the person with the private key for at least one address in the “painter” field of the “pixels” field of the applicable Canvas in the Smart Contract.
836 *
837 * “Canvas Owner” means the person that can cryptographically prove ownership of the applicable Canvas. Specifically, Canvas Owner means the person with the private key for the address in the “owner” field of the applicable Canvas in the Smart Contract. The person is the Canvas Owner only after the Initial Bidding phase is finished, that is when the field “state” of the applicable Canvas equals to the STATE_OWNED constant.
838 *
839 * “Initial Bidding” means the state of the Canvas when each of its pixels has been set by Canvas Authors but it does not have the Canvas Owner yet. In this phase any user can claim the ownership of the Canvas by sending a transaction to the Smart Contract (a “Bid”). Other users have 48 hours from the time of making the first Bid on the Canvas to submit their own Bids. After that time, the user who sent the highest Bid becomes the sole Canvas Owner of the applicable Canvas. Users who placed Bids with lower amounts are able to withdraw their Bid amount from their Account Balance.
840 *
841 * “Account Balance” means the value stored in the Smart Contract assigned to an address. The Account Balance can be withdrawn by the person with the private key for the applicable address by sending a transaction to the Smart Contract. Account Balance consists of Rewards for painting, Bids from Initial Bidding which have been overbid, cancelled offers to buy a Canvas and profits from selling a Canvas.
842 *
843 * “The Mindhouse”, “we” or “us” is the group of developers who created and published the CryptoCanvas Smart Contract.
844 *
845 * “The App” means collectively the Smart Contract and the website created by The Mindhouse to interact with the Smart Contract.
846 *
847 * 3. Intellectual Property
848 *
849 * A. First Assignment
850 * The Canvas Authors of the applicable Canvas hereby assign all copyright ownership in the Canvas to the Canvas Owner. In exchange for this copyright ownership, the Canvas Owner agrees to the terms below.
851 *
852 * B. Later Assignments
853 * When the Canvas Owner transfers the Canvas to a new owner, the Canvas Owner hereby agrees to assign all copyright ownership in the Canvas to the new owner of the Canvas. In exchange for these rights, the new owner shall agree to become the Canvas Owner, and shall agree to be subject to this Terms of Use.
854 *
855 * C. No Other Assignments.
856 * The Canvas Owner shall not assign or license the copyright except as set forth in the “Later Assignments” section above.
857 *
858 * D. Third Party Permissions.
859 * The Canvas Owner agrees to allow CryptoCanvas fans to make non-commercial Use of images of the Canvas to discuss CryptoCanvas, digital collectibles and related matters. “Use” means to reproduce, display, transmit, and distribute images of the Canvas. This permission excludes the right to print the Canvas onto physical copies (including, for example, shirts and posters).
860 *
861 * 4. Fees and Payment
862 *
863 * A. If you choose to paint, make a bid or trade any Canvas of CryptoCanvas any financial transactions that you engage in will be conducted solely through the Ethereum network via MetaMask. We will have no insight into or control over these payments or transactions, nor do we have the ability to reverse any transactions. With that in mind, we will have no liability to you or to any third party for any claims or damages that may arise as a result of any transactions that you engage in via the App, or using the Smart Contracts, or any other transactions that you conduct via the Ethereum network or MetaMask.
864 *
865 * B. Ethereum requires the payment of a transaction fee (a “Gas Fee”) for every transaction that occurs on the Ethereum network. The Gas Fee funds the network of computers that run the decentralized Ethereum network. This means that you will need to pay a Gas Fee for each transaction that occurs via the App.
866 *
867 * C. In addition to the Gas Fee, each time you sell a Canvas to another user of the App, you authorize us to collect a commission of 3.9% of the total value of that transaction (a “Commission”). You acknowledge and agree that the Commission will be transferred to us through the Ethereum network as part of the payment.
868 *
869 * D. If you are the Canvas Author you are eligible to receive a reward for painting a Canvas (a “Reward”) after the Initial Bidding phase is completed. You acknowledge and agree that the Reward for the Canvas Author will be calculated by dividing the value of the highest Bid decreased by our commision of 3.9% of the total value of the Bid, by the total number of pixels of the Canvas and multiplied by the number of pixels of the Canvas that have been painted by the applicable Canvas Author. You acknowledge and agree that in order to withdraw the Reward you first need to add the Reward to your Account Balance by sending a transaction to the Smart Contract.
870 *
871 * 5. Disclaimers
872 *
873 * A. YOU EXPRESSLY UNDERSTAND AND AGREE THAT YOUR ACCESS TO AND USE OF THE APP IS AT YOUR SOLE RISK, AND THAT THE APP IS PROVIDED "AS IS" AND "AS AVAILABLE" WITHOUT WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED. TO THE FULLEST EXTENT PERMISSIBLE PURSUANT TO APPLICABLE LAW, WE, OUR SUBSIDIARIES, AFFILIATES, AND LICENSORS MAKE NO EXPRESS WARRANTIES AND HEREBY DISCLAIM ALL IMPLIED WARRANTIES REGARDING THE APP AND ANY PART OF IT (INCLUDING, WITHOUT LIMITATION, THE SITE, ANY SMART CONTRACT, OR ANY EXTERNAL WEBSITES), INCLUDING THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, NON-INFRINGEMENT, CORRECTNESS, ACCURACY, OR RELIABILITY. WITHOUT LIMITING THE GENERALITY OF THE FOREGOING, WE, OUR SUBSIDIARIES, AFFILIATES, AND LICENSORS DO NOT REPRESENT OR WARRANT TO YOU THAT: (I) YOUR ACCESS TO OR USE OF THE APP WILL MEET YOUR REQUIREMENTS, (II) YOUR ACCESS TO OR USE OF THE APP WILL BE UNINTERRUPTED, TIMELY, SECURE OR FREE FROM ERROR, (III) USAGE DATA PROVIDED THROUGH THE APP WILL BE ACCURATE, (III) THE APP OR ANY CONTENT, SERVICES, OR FEATURES MADE AVAILABLE ON OR THROUGH THE APP ARE FREE OF VIRUSES OR OTHER HARMFUL COMPONENTS, OR (IV) THAT ANY DATA THAT YOU DISCLOSE WHEN YOU USE THE APP WILL BE SECURE. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF IMPLIED WARRANTIES IN CONTRACTS WITH CONSUMERS, SO SOME OR ALL OF THE ABOVE EXCLUSIONS MAY NOT APPLY TO YOU.
874 *
875 * B. YOU ACCEPT THE INHERENT SECURITY RISKS OF PROVIDING INFORMATION AND DEALING ONLINE OVER THE INTERNET, AND AGREE THAT WE HAVE NO LIABILITY OR RESPONSIBILITY FOR ANY BREACH OF SECURITY UNLESS IT IS DUE TO OUR GROSS NEGLIGENCE.
876 *
877 * C. WE WILL NOT BE RESPONSIBLE OR LIABLE TO YOU FOR ANY LOSSES YOU INCUR AS THE RESULT OF YOUR USE OF THE ETHEREUM NETWORK OR THE METAMASK ELECTRONIC WALLET, INCLUDING BUT NOT LIMITED TO ANY LOSSES, DAMAGES OR CLAIMS ARISING FROM: (A) USER ERROR, SUCH AS FORGOTTEN PASSWORDS OR INCORRECTLY CONSTRUED SMART CONTRACTS OR OTHER TRANSACTIONS; (B) SERVER FAILURE OR DATA LOSS; (C) CORRUPTED WALLET FILES; (D) UNAUTHORIZED ACCESS OR ACTIVITIES BY THIRD PARTIES, INCLUDING BUT NOT LIMITED TO THE USE OF VIRUSES, PHISHING, BRUTEFORCING OR OTHER MEANS OF ATTACK AGAINST THE APP, ETHEREUM NETWORK, OR THE METAMASK ELECTRONIC WALLET.
878 *
879 * D. THE CANVASES OF CRYPTOCANVAS ARE INTANGIBLE DIGITAL ASSETS THAT EXIST ONLY BY VIRTUE OF THE OWNERSHIP RECORD MAINTAINED IN THE ETHEREUM NETWORK. ALL SMART CONTRACTS ARE CONDUCTED AND OCCUR ON THE DECENTRALIZED LEDGER WITHIN THE ETHEREUM PLATFORM. WE HAVE NO CONTROL OVER AND MAKE NO GUARANTEES OR PROMISES WITH RESPECT TO SMART CONTRACTS.
880 *
881 * E. THE MINDHOUSE IS NOT RESPONSIBLE FOR LOSSES DUE TO BLOCKCHAINS OR ANY OTHER FEATURES OF THE ETHEREUM NETWORK OR THE METAMASK ELECTRONIC WALLET, INCLUDING BUT NOT LIMITED TO LATE REPORT BY DEVELOPERS OR REPRESENTATIVES (OR NO REPORT AT ALL) OF ANY ISSUES WITH THE BLOCKCHAIN SUPPORTING THE ETHEREUM NETWORK, INCLUDING FORKS, TECHNICAL NODE ISSUES, OR ANY OTHER ISSUES HAVING FUND LOSSES AS A RESULT.
882 *
883 * 6. Limitation of Liability
884 * YOU UNDERSTAND AND AGREE THAT WE, OUR SUBSIDIARIES, AFFILIATES, AND LICENSORS WILL NOT BE LIABLE TO YOU OR TO ANY THIRD PARTY FOR ANY CONSEQUENTIAL, INCIDENTAL, INDIRECT, EXEMPLARY, SPECIAL, PUNITIVE, OR ENHANCED DAMAGES, OR FOR ANY LOSS OF ACTUAL OR ANTICIPATED PROFITS (REGARDLESS OF HOW THESE ARE CLASSIFIED AS DAMAGES), WHETHER ARISING OUT OF BREACH OF CONTRACT, TORT (INCLUDING NEGLIGENCE), OR OTHERWISE, REGARDLESS OF WHETHER SUCH DAMAGE WAS FORESEEABLE AND WHETHER EITHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.
885 *
886 *
887 * @dev Contract to be placed in blockchain. Contains utility methods. 
888 */
889 contract CryptoArt is CanvasMarket {
890 
891     function getCanvasInfo(uint32 _canvasId) external view returns (
892         uint32 id,
893         uint32 paintedPixels,
894         uint8 canvasState,
895         uint initialBiddingFinishTime,
896         address owner
897     ) {
898         Canvas storage canvas = _getCanvas(_canvasId);
899 
900         return (_canvasId, canvas.paintedPixelsCount, getCanvasState(_canvasId),
901         canvas.initialBiddingFinishTime, canvas.owner);
902     }
903 
904     function getCanvasByOwner(address _owner) external view returns (uint32[]) {
905         uint32[] memory result = new uint32[](canvases.length);
906         uint currentIndex = 0;
907 
908         for (uint32 i = 0; i < canvases.length; i++) {
909             if (getCanvasState(i) == STATE_OWNED) {
910                 Canvas storage canvas = _getCanvas(i);
911                 if (canvas.owner == _owner) {
912                     result[currentIndex] = i;
913                     currentIndex++;
914                 }
915             }
916         }
917 
918         return _slice(result, 0, currentIndex);
919     }
920 
921     /**
922     * @notice   Returns array of canvas's ids. Returned canvases have sell offer.
923     *           If includePrivateOffers is true, includes offers that are targeted
924     *           only to one specified address.
925     */
926     function getCanvasesWithSellOffer(bool includePrivateOffers) external view returns (uint32[]) {
927         uint32[] memory result = new uint32[](canvases.length);
928         uint currentIndex = 0;
929 
930         for (uint32 i = 0; i < canvases.length; i++) {
931             SellOffer storage offer = canvasForSale[i];
932             if (offer.isForSale && (includePrivateOffers || offer.onlySellTo == 0x0)) {
933                 result[currentIndex] = i;
934                 currentIndex++;
935             }
936         }
937 
938         return _slice(result, 0, currentIndex);
939     }
940 
941     /**
942     * @notice   Returns array of all the owners of all of pixels. If some pixel hasn't
943     *           been painted yet, 0x0 address will be returned.
944     */
945     function getCanvasPainters(uint32 _canvasId) external view returns (address[]) {
946         Canvas storage canvas = _getCanvas(_canvasId);
947         address[] memory result = new address[](PIXEL_COUNT);
948 
949         for (uint32 i = 0; i < PIXEL_COUNT; i++) {
950             result[i] = canvas.pixels[i].painter;
951         }
952 
953         return result;
954     }
955 
956 }