1 pragma solidity ^0.4.24;
2 
3 //----------------------------------------------------------------------------
4 //Welcome to Dissidia of Contract PreSale
5 //欢迎来到契约纷争预售
6 //----------------------------------------------------------------------------
7 
8 contract SafeMath{
9     function safeAdd(uint a, uint b) public pure returns (uint c) {
10         c = a + b;
11         require(c >= a);
12     }
13     function safeSub(uint a, uint b) public pure returns (uint c) {
14         require(b <= a);
15         c = a - b;
16     }
17     function safeMul(uint a, uint b) public pure returns (uint c) {
18         c = a * b;
19         require(a == 0 || c / a == b);
20     }
21     function safeDiv(uint a, uint b) public pure returns (uint c) {
22         require(b > 0);
23         c = a / b;
24     }
25 }
26 
27 contract Administration is SafeMath{
28     event Pause();
29     event Unpause();
30     event PriceRaise();
31     event PriceStop();
32 
33     address public CEOAddress;
34     address public CTOAddress;
35     
36     uint oneEth = 1 ether;
37     uint public feeUnit = 1 finney;
38     uint public preSaleDurance = 45 days;
39 
40     bool public paused = false;
41     bool public pricePause = true;
42     
43     uint public startTime;
44     uint public endTime;
45     
46     uint[3] raiseIndex = [
47         3,
48         7,
49         5
50     ];
51     
52     uint[3] rewardPercent = [
53         15,
54         25,
55         30
56     ];
57 
58     modifier onlyCEO() {
59         require(msg.sender == CEOAddress);
60         _;
61     }
62 
63     modifier onlyAdmin() {
64         require(msg.sender == CEOAddress || msg.sender == CTOAddress);
65         _;
66     }
67 
68     function setCTO(address _newAdmin) public onlyCEO {
69         require(_newAdmin != address(0));
70         CTOAddress = _newAdmin;
71     }
72 
73     function withdrawBalanceAll() external onlyAdmin {
74         CEOAddress.transfer(address(this).balance);
75     }
76     
77     function withdrawBalance(uint _amount) external onlyAdmin {
78         CEOAddress.transfer(_amount);
79     }
80 
81     modifier whenNotPaused() {
82         require(!paused);
83         _;
84     }
85 
86     modifier whenPaused() {
87         require(paused);
88         _;
89     }
90 
91     function pause() public onlyCEO whenNotPaused returns(bool) {
92         paused = true;
93         emit Pause();
94         return true;
95     }
96 
97     function unpause() public onlyCEO whenPaused returns(bool) {
98         paused = false;
99         emit Unpause();
100         return true;
101     }
102 
103     function _random(uint _lower, uint _range, uint _jump) internal view returns (uint) {
104         uint number = uint(blockhash(block.number - _jump)) % _range;
105         if (number < _lower) {
106             number = _lower;
107         }
108         return number;
109     }
110 
111     function setFeeUnit(uint _fee) public onlyCEO {
112         feeUnit = _fee;
113     }
114     
115     function setPreSaleDurance(uint _durance) public onlyCEO {
116         preSaleDurance = _durance;
117     }
118     
119     function unPausePriceRaise() public onlyCEO {
120         require(pricePause == true);
121         pricePause = false;
122         startTime = uint(now);
123         emit PriceRaise();
124     }
125     
126     function pausePriceRaise() public onlyCEO {
127         require(pricePause == false);
128         pricePause = true;
129         endTime = uint(now);
130         emit PriceStop();
131     }
132     
133     function _computePrice(uint _startPrice, uint _endPrice, uint _totalDurance, uint _timePass) internal pure returns (uint) {
134         if (_timePass >= _totalDurance) {
135             return _endPrice;
136         } else {
137             uint totalPriceChange = safeSub(_endPrice, _startPrice);
138             uint currentPriceChange = totalPriceChange * uint(_timePass) / uint(_totalDurance);
139             uint currentPrice = uint(_startPrice) + currentPriceChange;
140 
141             return uint(currentPrice);
142         }
143     }
144     
145     function computePrice(uint _startPrice, uint _raiseIndex) public view returns (uint) {
146         if(pricePause == false) {
147             uint timePass = safeSub(uint(now), startTime);
148             return _computePrice(_startPrice, _startPrice*raiseIndex[_raiseIndex], preSaleDurance, timePass);
149         } else {
150             return _startPrice;
151         }
152     }
153     
154     function WhoIsTheContractMaster() public pure returns (string) {
155         return "Alexander The Exlosion";
156     }
157 }
158 
159 contract Broker is Administration {
160     // ----------------------------------------------------------------------------
161     // Events
162     // ----------------------------------------------------------------------------
163     event BrokerRegistered(uint indexed brokerId, address indexed broker);
164     event AppendSubBroker(uint indexed brokerId, uint indexed subBrokerId, address indexed subBroker);
165     event BrokerTransfer(address indexed newBroker, uint indexed brokerId, uint indexed subBrokerId);
166     event BrokerFeeDistrubution(address indexed vipBroker, uint indexed vipShare, address indexed broker, uint share);
167     event BrokerFeeClaim(address indexed broker, uint indexed fee);
168     
169     // ----------------------------------------------------------------------------
170     // Mappings
171     // ----------------------------------------------------------------------------
172     mapping (uint => address[]) BrokerIdToBrokers;
173     mapping (uint => uint) BrokerIdToSpots;
174     mapping (address => uint) BrokerIncoming;
175     
176     // ----------------------------------------------------------------------------
177     // Variables
178     // ----------------------------------------------------------------------------
179     uint public vipBrokerFee = 5 ether;
180     uint public brokerFee = 1.5 ether;
181     uint public vipBrokerNum = 1000;
182     uint public subBrokerNum = 5;
183     
184     // ----------------------------------------------------------------------------
185     // Modifier
186     // ----------------------------------------------------------------------------
187     
188     // ----------------------------------------------------------------------------
189     // Internal Function
190     // ----------------------------------------------------------------------------
191     function _brokerFeeDistribute(uint _price, uint _type, uint _brokerId, uint _subBrokerId) internal {
192         address vipBroker = getBrokerAddress(_brokerId, 0);
193         address broker = getBrokerAddress(_brokerId, _subBrokerId);
194         require(vipBroker != address(0) && broker != address(0));
195         uint totalShare = _price*rewardPercent[_type]/100;
196         BrokerIncoming[vipBroker] = BrokerIncoming[vipBroker] + totalShare*15/100;
197         BrokerIncoming[broker] = BrokerIncoming[broker] + totalShare*85/100;
198         
199         emit BrokerFeeDistrubution(vipBroker, totalShare*15/100, broker, totalShare*85/100);
200     }
201     
202     // ----------------------------------------------------------------------------
203     // Public Function
204     // ----------------------------------------------------------------------------
205     function registerBroker() public payable returns (uint) {
206         require(vipBrokerNum > 0);
207         require(msg.value >= vipBrokerFee);
208         vipBrokerNum--;
209         uint brokerId = 1000 - vipBrokerNum;
210         BrokerIdToBrokers[brokerId].push(msg.sender);
211         BrokerIdToSpots[brokerId] = subBrokerNum;
212         emit BrokerRegistered(brokerId, msg.sender);
213         return brokerId;
214     }
215     
216     function assignSubBroker(uint _brokerId, address _broker) public payable {
217         require(msg.sender == BrokerIdToBrokers[_brokerId][0]);
218         require(msg.value >= brokerFee);
219         require(BrokerIdToSpots[_brokerId] > 0);
220         uint newSubBrokerId = BrokerIdToBrokers[_brokerId].push(_broker) - 1;
221         BrokerIdToSpots[_brokerId]--;
222         
223         emit AppendSubBroker(_brokerId, newSubBrokerId, _broker);
224     }
225     
226     function transferBroker(address _newBroker, uint _brokerId, uint _subBrokerId) public whenNotPaused {
227         require(_brokerId > 0 && _brokerId <= 1000);
228         require(_subBrokerId >= 0 && _subBrokerId <= 5);
229         require(BrokerIdToBrokers[_brokerId][_subBrokerId] == msg.sender);
230         BrokerIdToBrokers[_brokerId][_subBrokerId] = _newBroker;
231         
232         emit BrokerTransfer(_newBroker, _brokerId, _subBrokerId);
233     }
234 
235     function claimBrokerFee() public whenNotPaused {
236         uint fee = BrokerIncoming[msg.sender];
237         require(fee > 0);
238         msg.sender.transfer(fee);
239         BrokerIncoming[msg.sender] = 0;
240         emit BrokerFeeClaim(msg.sender, fee);
241     }
242     
243     function getBrokerIncoming(address _broker) public view returns (uint) {
244         return BrokerIncoming[_broker];
245     } 
246     
247     function getBrokerInfo(uint _brokerId) public view returns (
248         address broker,
249         uint subSpot
250     ) { 
251         broker = BrokerIdToBrokers[_brokerId][0];
252         subSpot = BrokerIdToSpots[_brokerId];
253     }
254     
255     function getBrokerAddress(uint _brokerId, uint _subBrokerId) public view returns (address) {
256         return BrokerIdToBrokers[_brokerId][_subBrokerId];
257     }
258     
259     function getVipBrokerNum() public view returns (uint) {
260         return safeSub(1000, vipBrokerNum);
261     }
262 }
263 
264 contract PreSaleRealm is Broker {
265     // ----------------------------------------------------------------------------
266     // Events
267     // ----------------------------------------------------------------------------
268     event RealmSaleCreate(uint indexed saleId, uint indexed realmId, uint indexed price);
269     event BuyRealm(uint indexed saleId, uint realmId, address indexed buyer, uint indexed currentPrice);
270     event RealmOfferSubmit(uint indexed saleId, uint realmId, address indexed bidder, uint indexed price);
271     event RealmOfferAccept(uint indexed saleId, uint realmId, address indexed newOwner, uint indexed newPrice);
272     event SetRealmSale(uint indexed saleId, uint indexed price);
273     
274     event RealmAuctionCreate(uint indexed auctionId, uint indexed realmId, uint indexed startPrice);
275     event RealmAuctionBid(uint indexed auctionId, address indexed bidder, uint indexed offer);
276     
277     
278     // ----------------------------------------------------------------------------
279     // Mappings
280     // ----------------------------------------------------------------------------
281     mapping (uint => address) public RealmSaleToBuyer;
282     
283     // ----------------------------------------------------------------------------
284     // Variables
285     // ----------------------------------------------------------------------------
286     struct RealmSale {
287         uint realmId;
288         uint price;
289         bool ifSold;
290         address bidder;
291         uint offerPrice;
292         uint timestamp;
293     }
294     
295     RealmSale[] realmSales;
296     
297     // ----------------------------------------------------------------------------
298     // Modifier
299     // ----------------------------------------------------------------------------
300     
301     // ----------------------------------------------------------------------------
302     // Internal Function
303     // ----------------------------------------------------------------------------
304     function _generateRealmSale(uint _realmId, uint _price) internal returns (uint) {
305         RealmSale memory _RealmSale = RealmSale({
306             realmId: _realmId,
307             price: _price,
308             ifSold: false,
309             bidder: address(0),
310             offerPrice: 0,
311             timestamp: 0
312         });
313         uint realmSaleId = realmSales.push(_RealmSale) - 1;
314         emit RealmSaleCreate(realmSaleId, _realmId, _price);
315         
316         return realmSaleId;
317     }
318     // ----------------------------------------------------------------------------
319     // Public Function
320     // ----------------------------------------------------------------------------
321     function createRealmSale(uint _num, uint _startId, uint _price) public onlyAdmin {
322         for(uint i = 0; i<_num; i++) {
323             _generateRealmSale(_startId + i, _price);
324         }
325     }
326     
327     function buyRealm(uint _realmSaleId, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
328         RealmSale storage _realmSale = realmSales[_realmSaleId];
329         require(RealmSaleToBuyer[_realmSale.realmId] == address(0));
330         require(_realmSale.ifSold == false);
331         uint currentPrice;
332         if(pricePause == true) {
333             if(_realmSale.timestamp != 0 && _realmSale.timestamp != endTime) {
334                 uint timePass = safeSub(endTime, startTime);
335                 _realmSale.price = _computePrice(_realmSale.price, _realmSale.price*raiseIndex[0], preSaleDurance, timePass);
336                 _realmSale.timestamp = endTime;
337             }
338             _brokerFeeDistribute(_realmSale.price, 0, _brokerId, _subBrokerId);
339             require(msg.value >= _realmSale.price);
340             currentPrice = _realmSale.price;
341         } else {
342             if(_realmSale.timestamp == 0) {
343                 _realmSale.timestamp = uint(now);
344             }
345             currentPrice = _computePrice(_realmSale.price, _realmSale.price*raiseIndex[0], preSaleDurance, safeSub(uint(now), startTime));
346             _brokerFeeDistribute(currentPrice, 0, _brokerId, _subBrokerId);
347             require(msg.value >= currentPrice);
348             _realmSale.price = currentPrice;
349         }
350         RealmSaleToBuyer[_realmSale.realmId] = msg.sender;
351         _realmSale.ifSold = true;
352         emit BuyRealm(_realmSaleId, _realmSale.realmId, msg.sender, currentPrice);
353     }
354     
355     function offlineRealmSold(uint _realmSaleId, address _buyer, uint _price) public onlyAdmin {
356         RealmSale storage _realmSale = realmSales[_realmSaleId];
357         require(_realmSale.ifSold == false);
358         RealmSaleToBuyer[_realmSale.realmId] = _buyer;
359         _realmSale.ifSold = true;
360         emit BuyRealm(_realmSaleId, _realmSale.realmId, _buyer, _price);
361     }
362     
363     function OfferToRealm(uint _realmSaleId, uint _price) public payable whenNotPaused {
364         RealmSale storage _realmSale = realmSales[_realmSaleId];
365         require(_realmSale.ifSold == true);
366         require(_price >= _realmSale.offerPrice*11/10);
367         require(msg.value >= _price);
368         
369         if(_realmSale.bidder == address(0)) {
370             _realmSale.bidder = msg.sender;
371             _realmSale.offerPrice = _price;
372         } else {
373             address lastBidder = _realmSale.bidder;
374             uint lastOffer = _realmSale.price;
375             lastBidder.transfer(lastOffer);
376             
377             _realmSale.bidder = msg.sender;
378             _realmSale.offerPrice = _price;
379         }
380         
381         emit RealmOfferSubmit(_realmSaleId, _realmSale.realmId, msg.sender, _price);
382     }
383     
384     function AcceptRealmOffer(uint _realmSaleId) public whenNotPaused {
385         RealmSale storage _realmSale = realmSales[_realmSaleId];
386         require(RealmSaleToBuyer[_realmSale.realmId] == msg.sender);
387         require(_realmSale.bidder != address(0) && _realmSale.offerPrice > 0);
388         msg.sender.transfer(_realmSale.offerPrice);
389         RealmSaleToBuyer[_realmSale.realmId] = _realmSale.bidder;
390         _realmSale.price = _realmSale.offerPrice;
391         
392         emit RealmOfferAccept(_realmSaleId, _realmSale.realmId, _realmSale.bidder, _realmSale.offerPrice);
393         
394         _realmSale.bidder = address(0);
395         _realmSale.offerPrice = 0;
396     }
397     
398     function setRealmSale(uint _realmSaleId, uint _price) public onlyAdmin {
399         RealmSale storage _realmSale = realmSales[_realmSaleId];
400         require(_realmSale.ifSold == false);
401         _realmSale.price = _price;
402         emit SetRealmSale(_realmSaleId, _price);
403     }
404     
405     function getRealmSale(uint _realmSaleId) public view returns (
406         address owner,
407         uint realmId,
408         uint price,
409         bool ifSold,
410         address bidder,
411         uint offerPrice,
412         uint timestamp
413     ) {
414         RealmSale memory _RealmSale = realmSales[_realmSaleId];
415         owner = RealmSaleToBuyer[_RealmSale.realmId];
416         realmId = _RealmSale.realmId;
417         price = _RealmSale.price;
418         ifSold =_RealmSale.ifSold;
419         bidder = _RealmSale.bidder;
420         offerPrice = _RealmSale.offerPrice;
421         timestamp = _RealmSale.timestamp;
422     }
423     
424     function getRealmNum() public view returns (uint) {
425         return realmSales.length;
426     }
427 }
428 
429 contract PreSaleCastle is PreSaleRealm {
430     // ----------------------------------------------------------------------------
431     // Events
432     // ----------------------------------------------------------------------------
433     event CastleSaleCreate(uint indexed saleId, uint indexed castleId, uint indexed price, uint realmId, uint rarity);
434     event BuyCastle(uint indexed saleId, uint castleId, address indexed buyer, uint indexed currentPrice);
435     event CastleOfferSubmit(uint indexed saleId, uint castleId, address indexed bidder, uint indexed price);
436     event CastleOfferAccept(uint indexed saleId, uint castleId, address indexed newOwner, uint indexed newPrice);
437     event SetCastleSale(uint indexed saleId, uint indexed price);
438     
439     event CastleAuctionCreate(uint indexed auctionId, uint indexed castleId, uint indexed startPrice, uint realmId, uint rarity);
440     event CastleAuctionBid(uint indexed auctionId, address indexed bidder, uint indexed offer);
441     
442     
443     // ----------------------------------------------------------------------------
444     // Mappings
445     // ----------------------------------------------------------------------------
446     mapping (uint => address) public CastleSaleToBuyer;
447     
448     // ----------------------------------------------------------------------------
449     // Variables
450     // ----------------------------------------------------------------------------
451     struct CastleSale {
452         uint castleId;
453         uint realmId;
454         uint rarity;
455         uint price;
456         bool ifSold;
457         address bidder;
458         uint offerPrice;
459         uint timestamp;
460     }
461 
462     CastleSale[] castleSales;
463 
464     // ----------------------------------------------------------------------------
465     // Modifier
466     // ----------------------------------------------------------------------------
467     
468     // ----------------------------------------------------------------------------
469     // Internal Function
470     // ----------------------------------------------------------------------------
471     function _generateCastleSale(uint _castleId, uint _realmId, uint _rarity, uint _price) internal returns (uint) {
472         CastleSale memory _CastleSale = CastleSale({
473             castleId: _castleId,
474             realmId: _realmId,
475             rarity: _rarity,
476             price: _price,
477             ifSold: false,
478             bidder: address(0),
479             offerPrice: 0,
480             timestamp: 0
481         });
482         uint castleSaleId = castleSales.push(_CastleSale) - 1;
483         emit CastleSaleCreate(castleSaleId, _castleId, _price, _realmId, _rarity);
484         
485         return castleSaleId;
486     }
487 
488     // ----------------------------------------------------------------------------
489     // Public Function
490     // ----------------------------------------------------------------------------
491     function createCastleSale(uint _num, uint _startId, uint _realmId, uint _rarity, uint _price) public onlyAdmin {
492         for(uint i = 0; i<_num; i++) {
493             _generateCastleSale(_startId + i, _realmId, _rarity, _price);
494         }
495     }
496     
497     function buyCastle(uint _castleSaleId, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
498         CastleSale storage _castleSale = castleSales[_castleSaleId];
499         require(CastleSaleToBuyer[_castleSale.castleId] == address(0));
500         require(_castleSale.ifSold == false);
501         uint currentPrice;
502         if(pricePause == true) {
503             if(_castleSale.timestamp != 0 && _castleSale.timestamp != endTime) {
504                 uint timePass = safeSub(endTime, startTime);
505                 _castleSale.price = _computePrice(_castleSale.price, _castleSale.price*raiseIndex[0], preSaleDurance, timePass);
506                 _castleSale.timestamp = endTime;
507             }
508             _brokerFeeDistribute(_castleSale.price, 0, _brokerId, _subBrokerId);
509             require(msg.value >= _castleSale.price);
510             currentPrice = _castleSale.price;
511         } else {
512             if(_castleSale.timestamp == 0) {
513                 _castleSale.timestamp = uint(now);
514             }
515             currentPrice = _computePrice(_castleSale.price, _castleSale.price*raiseIndex[0], preSaleDurance, safeSub(uint(now), startTime));
516             _brokerFeeDistribute(currentPrice, 0, _brokerId, _subBrokerId);
517             require(msg.value >= currentPrice);
518             _castleSale.price = currentPrice;
519         }
520         CastleSaleToBuyer[_castleSale.castleId] = msg.sender;
521         _castleSale.ifSold = true;
522         emit BuyCastle(_castleSaleId, _castleSale.castleId, msg.sender, currentPrice);
523     }
524     
525     function OfflineCastleSold(uint _castleSaleId, address _buyer, uint _price) public onlyAdmin {
526         CastleSale storage _castleSale = castleSales[_castleSaleId];
527         require(_castleSale.ifSold == false);
528         CastleSaleToBuyer[_castleSale.castleId] = _buyer;
529         _castleSale.ifSold = true;
530         emit BuyCastle(_castleSaleId, _castleSale.castleId, _buyer, _price);
531     }
532     
533     function OfferToCastle(uint _castleSaleId, uint _price) public payable whenNotPaused {
534         CastleSale storage _castleSale = castleSales[_castleSaleId];
535         require(_castleSale.ifSold == true);
536         require(_price >= _castleSale.offerPrice*11/10);
537         require(msg.value >= _price);
538         
539         if(_castleSale.bidder == address(0)) {
540             _castleSale.bidder = msg.sender;
541             _castleSale.offerPrice = _price;
542         } else {
543             address lastBidder = _castleSale.bidder;
544             uint lastOffer = _castleSale.price;
545             lastBidder.transfer(lastOffer);
546             
547             _castleSale.bidder = msg.sender;
548             _castleSale.offerPrice = _price;
549         }
550         
551         emit CastleOfferSubmit(_castleSaleId, _castleSale.castleId, msg.sender, _price);
552     }
553     
554     function AcceptCastleOffer(uint _castleSaleId) public whenNotPaused {
555         CastleSale storage _castleSale = castleSales[_castleSaleId];
556         require(CastleSaleToBuyer[_castleSale.castleId] == msg.sender);
557         require(_castleSale.bidder != address(0) && _castleSale.offerPrice > 0);
558         msg.sender.transfer(_castleSale.offerPrice);
559         CastleSaleToBuyer[_castleSale.castleId] = _castleSale.bidder;
560         _castleSale.price = _castleSale.offerPrice;
561         
562         emit CastleOfferAccept(_castleSaleId, _castleSale.castleId, _castleSale.bidder, _castleSale.offerPrice);
563         
564         _castleSale.bidder = address(0);
565         _castleSale.offerPrice = 0;
566     }
567     
568     function setCastleSale(uint _castleSaleId, uint _price) public onlyAdmin {
569         CastleSale storage _castleSale = castleSales[_castleSaleId];
570         require(_castleSale.ifSold == false);
571         _castleSale.price = _price;
572         emit SetCastleSale(_castleSaleId, _price);
573     }
574     
575     function getCastleSale(uint _castleSaleId) public view returns (
576         address owner,
577         uint castleId,
578         uint realmId,
579         uint rarity,
580         uint price,
581         bool ifSold,
582         address bidder,
583         uint offerPrice,
584         uint timestamp
585     ) {
586         CastleSale memory _CastleSale = castleSales[_castleSaleId];
587         owner = CastleSaleToBuyer[_CastleSale.castleId];
588         castleId = _CastleSale.castleId;
589         realmId = _CastleSale.realmId;
590         rarity = _CastleSale.rarity;
591         price = _CastleSale.price;
592         ifSold =_CastleSale.ifSold;
593         bidder = _CastleSale.bidder;
594         offerPrice = _CastleSale.offerPrice;
595         timestamp = _CastleSale.timestamp;
596     }
597     
598     function getCastleNum() public view returns (uint) {
599         return castleSales.length;
600     }
601 }
602 
603 contract PreSaleGuardian is PreSaleCastle {
604     // ----------------------------------------------------------------------------
605     // Events
606     // ----------------------------------------------------------------------------
607     event GuardianSaleCreate(uint indexed saleId, uint indexed guardianId, uint indexed price, uint race, uint level, uint starRate);
608     event BuyGuardian(uint indexed saleId, uint guardianId, address indexed buyer, uint indexed currentPrice);
609     event GuardianOfferSubmit(uint indexed saleId, uint guardianId, address indexed bidder, uint indexed price);
610     event GuardianOfferAccept(uint indexed saleId, uint guardianId, address indexed newOwner, uint indexed newPrice);
611     event SetGuardianSale(uint indexed saleId, uint indexed price);
612     
613     event GuardianAuctionCreate(uint indexed auctionId, uint indexed guardianId, uint indexed startPrice, uint race, uint level, uint starRate);
614     event GuardianAuctionBid(uint indexed auctionId, address indexed bidder, uint indexed offer);
615     
616     event VendingGuardian(uint indexed vendingId, address indexed buyer);
617     event GuardianVendOffer(uint indexed vendingId, address indexed bidder, uint indexed offer);
618     event GuardianVendAccept(uint indexed vendingId, address indexed newOwner, uint indexed newPrice);
619     event SetGuardianVend(uint indexed priceId, uint indexed price);
620     
621     // ----------------------------------------------------------------------------
622     // Mappings
623     // ----------------------------------------------------------------------------
624     mapping (uint => address) public GuardianSaleToBuyer;
625     
626     mapping (uint => uint) public GuardianVendToOffer;
627     mapping (uint => address) public GuardianVendToBidder;
628     mapping (uint => uint) public GuardianVendToTime;
629     
630     // ----------------------------------------------------------------------------
631     // Variables
632     // ----------------------------------------------------------------------------
633     struct GuardianSale {
634         uint guardianId;
635         uint race;
636         uint starRate;
637         uint level;
638         uint price;
639         bool ifSold;
640         address bidder;
641         uint offerPrice;
642         uint timestamp;
643     }
644     
645     GuardianSale[] guardianSales;
646 
647     uint[5] GuardianVending = [
648         0.5 ether,
649         0.35 ether,
650         0.20 ether,
651         0.15 ether,
652         0.1 ether
653     ];
654     
655     // ----------------------------------------------------------------------------
656     // Modifier
657     // ----------------------------------------------------------------------------
658     
659     // ----------------------------------------------------------------------------
660     // Internal Function
661     // ----------------------------------------------------------------------------
662     function _generateGuardianSale(uint _guardianId, uint _race, uint _starRate, uint _level, uint _price) internal returns (uint) {
663         GuardianSale memory _GuardianSale = GuardianSale({
664             guardianId: _guardianId,
665             race: _race,
666             starRate: _starRate,
667             level: _level,
668             price: _price,
669             ifSold: false,
670             bidder: address(0),
671             offerPrice: 0,
672             timestamp: 0
673         });
674         uint guardianSaleId = guardianSales.push(_GuardianSale) - 1;
675         emit GuardianSaleCreate(guardianSaleId, _guardianId, _price, _race, _level, _starRate);
676         
677         return guardianSaleId;
678     }
679     
680     function _guardianVendPrice(uint _guardianId , uint _level) internal returns (uint) {
681         if(pricePause == true) {
682             if(GuardianVendToTime[_guardianId] != 0 && GuardianVendToTime[_guardianId] != endTime) {
683                 uint timePass = safeSub(endTime, startTime);
684                 GuardianVending[_level] = _computePrice(GuardianVending[_level], GuardianVending[_level]*raiseIndex[1], preSaleDurance, timePass);
685                 GuardianVendToTime[_guardianId] = endTime;
686             }
687             return GuardianVending[_level];
688         } else {
689             if(GuardianVendToTime[_guardianId] == 0) {
690                 GuardianVendToTime[_guardianId] = uint(now);
691             }
692             uint currentPrice = _computePrice(GuardianVending[_level], GuardianVending[_level]*raiseIndex[1], preSaleDurance, safeSub(uint(now), startTime));
693             return currentPrice;
694         }
695     }
696     
697     // ----------------------------------------------------------------------------
698     // Public Function
699     // ----------------------------------------------------------------------------
700     function createGuardianSale(uint _num, uint _startId, uint _race, uint _starRate, uint _level, uint _price) public onlyAdmin {
701         for(uint i = 0; i<_num; i++) {
702             _generateGuardianSale(_startId + i, _race, _starRate, _level, _price);
703         }
704     }
705     
706     function buyGuardian(uint _guardianSaleId, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
707         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
708         require(GuardianSaleToBuyer[_guardianSale.guardianId] == address(0));
709         require(_guardianSale.ifSold == false);
710         uint currentPrice;
711         if(pricePause == true) {
712             if(_guardianSale.timestamp != 0 && _guardianSale.timestamp != endTime) {
713                 uint timePass = safeSub(endTime, startTime);
714                 _guardianSale.price = _computePrice(_guardianSale.price, _guardianSale.price*raiseIndex[1], preSaleDurance, timePass);
715                 _guardianSale.timestamp = endTime;
716             }
717             _brokerFeeDistribute(_guardianSale.price, 1, _brokerId, _subBrokerId);
718             require(msg.value >= _guardianSale.price);
719             currentPrice = _guardianSale.price;
720         } else {
721             if(_guardianSale.timestamp == 0) {
722                 _guardianSale.timestamp = uint(now);
723             }
724             currentPrice = _computePrice(_guardianSale.price, _guardianSale.price*raiseIndex[1], preSaleDurance, safeSub(uint(now), startTime));
725             _brokerFeeDistribute(currentPrice, 1, _brokerId, _subBrokerId);
726             require(msg.value >= currentPrice);
727             _guardianSale.price = currentPrice;
728         }
729         GuardianSaleToBuyer[_guardianSale.guardianId] = msg.sender;
730         _guardianSale.ifSold = true;
731         emit BuyGuardian(_guardianSaleId, _guardianSale.guardianId, msg.sender, currentPrice);
732     }
733     
734     function offlineGuardianSold(uint _guardianSaleId, address _buyer, uint _price) public onlyAdmin {
735         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
736         require(_guardianSale.ifSold == false);
737         GuardianSaleToBuyer[_guardianSale.guardianId] = _buyer;
738         _guardianSale.ifSold = true;
739         emit BuyGuardian(_guardianSaleId, _guardianSale.guardianId, _buyer, _price);
740     }
741     
742     function OfferToGuardian(uint _guardianSaleId, uint _price) public payable whenNotPaused {
743         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
744         require(_guardianSale.ifSold == true);
745         require(_price > _guardianSale.offerPrice*11/10);
746         require(msg.value >= _price);
747         
748         if(_guardianSale.bidder == address(0)) {
749             _guardianSale.bidder = msg.sender;
750             _guardianSale.offerPrice = _price;
751         } else {
752             address lastBidder = _guardianSale.bidder;
753             uint lastOffer = _guardianSale.price;
754             lastBidder.transfer(lastOffer);
755             
756             _guardianSale.bidder = msg.sender;
757             _guardianSale.offerPrice = _price;
758         }
759         
760         emit GuardianOfferSubmit(_guardianSaleId, _guardianSale.guardianId, msg.sender, _price);
761     }
762     
763     function AcceptGuardianOffer(uint _guardianSaleId) public whenNotPaused {
764         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
765         require(GuardianSaleToBuyer[_guardianSale.guardianId] == msg.sender);
766         require(_guardianSale.bidder != address(0) && _guardianSale.offerPrice > 0);
767         msg.sender.transfer(_guardianSale.offerPrice);
768         GuardianSaleToBuyer[_guardianSale.guardianId] = _guardianSale.bidder;
769         _guardianSale.price = _guardianSale.offerPrice;
770         
771         emit GuardianOfferAccept(_guardianSaleId, _guardianSale.guardianId, _guardianSale.bidder, _guardianSale.price);
772         
773         _guardianSale.bidder = address(0);
774         _guardianSale.offerPrice = 0;
775     }
776     
777     function setGuardianSale(uint _guardianSaleId, uint _price) public onlyAdmin {
778         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
779         require(_guardianSale.ifSold == false);
780         _guardianSale.price = _price;
781         emit SetGuardianSale(_guardianSaleId, _price);
782     }
783     
784     function getGuardianSale(uint _guardianSaleId) public view returns (
785         address owner,
786         uint guardianId,
787         uint race,
788         uint starRate,
789         uint level,
790         uint price,
791         bool ifSold,
792         address bidder,
793         uint offerPrice,
794         uint timestamp
795     ) {
796         GuardianSale memory _GuardianSale = guardianSales[_guardianSaleId];
797         owner = GuardianSaleToBuyer[_GuardianSale.guardianId];
798         guardianId = _GuardianSale.guardianId;
799         race = _GuardianSale.race;
800         starRate = _GuardianSale.starRate;
801         level = _GuardianSale.level;
802         price = _GuardianSale.price;
803         ifSold =_GuardianSale.ifSold;
804         bidder = _GuardianSale.bidder;
805         offerPrice = _GuardianSale.offerPrice;
806         timestamp = _GuardianSale.timestamp;
807     }
808     
809     function getGuardianNum() public view returns (uint) {
810         return guardianSales.length;
811     }
812 
813     function vendGuardian(uint _guardianId) public payable whenNotPaused {
814         require(_guardianId > 1000 && _guardianId <= 6000);
815         if(_guardianId > 1000 && _guardianId <= 2000) {
816             require(GuardianSaleToBuyer[_guardianId] == address(0));
817             require(msg.value >= _guardianVendPrice(_guardianId, 0));
818             GuardianSaleToBuyer[_guardianId] = msg.sender;
819             GuardianVendToOffer[_guardianId] = GuardianVending[0];
820         } else if (_guardianId > 2000 && _guardianId <= 3000) {
821             require(GuardianSaleToBuyer[_guardianId] == address(0));
822             require(msg.value >= _guardianVendPrice(_guardianId, 1));
823             GuardianSaleToBuyer[_guardianId] = msg.sender;
824             GuardianVendToOffer[_guardianId] = GuardianVending[1];
825         } else if (_guardianId > 3000 && _guardianId <= 4000) {
826             require(GuardianSaleToBuyer[_guardianId] == address(0));
827             require(msg.value >= _guardianVendPrice(_guardianId, 2));
828             GuardianSaleToBuyer[_guardianId] = msg.sender;
829             GuardianVendToOffer[_guardianId] = GuardianVending[2];
830         } else if (_guardianId > 4000 && _guardianId <= 5000) {
831             require(GuardianSaleToBuyer[_guardianId] == address(0));
832             require(msg.value >= _guardianVendPrice(_guardianId, 3));
833             GuardianSaleToBuyer[_guardianId] = msg.sender;
834             GuardianVendToOffer[_guardianId] = GuardianVending[3];
835         } else if (_guardianId > 5000 && _guardianId <= 6000) {
836             require(GuardianSaleToBuyer[_guardianId] == address(0));
837             require(msg.value >= _guardianVendPrice(_guardianId, 4));
838             GuardianSaleToBuyer[_guardianId] = msg.sender;
839             GuardianVendToOffer[_guardianId] = GuardianVending[4];
840         }
841         emit VendingGuardian(_guardianId, msg.sender);
842     }
843     
844     function offerGuardianVend(uint _guardianId, uint _offer) public payable whenNotPaused {
845         require(GuardianSaleToBuyer[_guardianId] != address(0));
846         require(_offer >= GuardianVendToOffer[_guardianId]*11/10);
847         require(msg.value >= _offer);
848         address lastBidder = GuardianVendToBidder[_guardianId];
849         if(lastBidder != address(0)){
850             lastBidder.transfer(GuardianVendToOffer[_guardianId]);
851         }
852         GuardianVendToBidder[_guardianId] = msg.sender;
853         GuardianVendToOffer[_guardianId] = _offer;
854         emit GuardianVendOffer(_guardianId, msg.sender, _offer);
855     }
856     
857     function acceptGuardianVend(uint _guardianId) public whenNotPaused {
858         require(GuardianSaleToBuyer[_guardianId] == msg.sender);
859         address bidder = GuardianVendToBidder[_guardianId];
860         uint offer = GuardianVendToOffer[_guardianId];
861         require(bidder != address(0) && offer > 0);
862         msg.sender.transfer(offer);
863         GuardianSaleToBuyer[_guardianId] = bidder;
864         GuardianVendToBidder[_guardianId] = address(0);
865         GuardianVendToOffer[_guardianId] = 0;
866         emit GuardianVendAccept(_guardianId, bidder, offer);
867     }
868     
869     function setGuardianVend(uint _num, uint _price) public onlyAdmin {
870         GuardianVending[_num] = _price;
871         emit SetGuardianVend(_num, _price);
872     }
873     
874     function getGuardianVend(uint _guardianId) public view returns (
875         address owner,
876         address bidder,
877         uint offer
878     ) {
879         owner = GuardianSaleToBuyer[_guardianId];
880         bidder = GuardianVendToBidder[_guardianId];
881         offer = GuardianVendToOffer[_guardianId];
882     }
883 }
884 
885 contract PreSaleDisciple is PreSaleGuardian {
886     // ----------------------------------------------------------------------------
887     // Events
888     // ----------------------------------------------------------------------------
889     event DiscipleSaleCreate(uint indexed saleId, uint indexed discipleId, uint indexed price, uint occupation, uint level);
890     event BuyDisciple(uint indexed saleId, uint discipleId, address indexed buyer, uint indexed currentPrice);
891     event DiscipleOfferSubmit(uint indexed saleId, uint discipleId, address indexed bidder, uint indexed price);
892     event DiscipleOfferAccept(uint indexed saleId, uint discipleId, address indexed newOwner, uint indexed newPrice);
893     event SetDiscipleSale(uint indexed saleId, uint indexed price);
894     
895     event DiscipleAuctionCreate(uint indexed auctionId, uint indexed discipleId, uint indexed startPrice, uint occupation, uint level);
896     event DiscipleAuctionBid(uint indexed auctionId, address indexed bidder, uint indexed offer);
897     
898     event VendingDisciple(uint indexed vendingId, address indexed buyer);
899     event DiscipleVendOffer(uint indexed vendingId, address indexed bidder, uint indexed offer);
900     event DiscipleVendAccept(uint indexed vendingId, address indexed newOwner, uint indexed newPrice);
901     event SetDiscipleVend(uint indexed priceId, uint indexed price);
902     
903     // ----------------------------------------------------------------------------
904     // Mappings
905     // ----------------------------------------------------------------------------
906     mapping (uint => address) public DiscipleSaleToBuyer;
907     
908     mapping (uint => uint) public DiscipleVendToOffer;
909     mapping (uint => address) public DiscipleVendToBidder;
910     mapping (uint => uint) public DiscipleVendToTime;
911     
912     // ----------------------------------------------------------------------------
913     // Variables
914     // ----------------------------------------------------------------------------
915     struct DiscipleSale {
916         uint discipleId;
917         uint occupation;
918         uint level;
919         uint price;
920         bool ifSold;
921         address bidder;
922         uint offerPrice;
923         uint timestamp;
924     }
925     
926     DiscipleSale[] discipleSales;
927 
928     uint[5] DiscipleVending = [
929         0.8 ether,
930         0.65 ether,
931         0.45 ether,
932         0.35 ether,
933         0.2 ether
934     ];
935     
936     // ----------------------------------------------------------------------------
937     // Modifier
938     // ----------------------------------------------------------------------------
939     
940     // ----------------------------------------------------------------------------
941     // Internal Function
942     // ----------------------------------------------------------------------------
943     function _generateDiscipleSale(uint _discipleId, uint _occupation, uint _level, uint _price) internal returns (uint) {
944         DiscipleSale memory _DiscipleSale = DiscipleSale({
945             discipleId: _discipleId,
946             occupation: _occupation,
947             level: _level,
948             price: _price,
949             ifSold: false,
950             bidder: address(0),
951             offerPrice: 0,
952             timestamp: 0
953         });
954         uint discipleSaleId = discipleSales.push(_DiscipleSale) - 1;
955         emit DiscipleSaleCreate(discipleSaleId, _discipleId, _price, _occupation, _level);
956         
957         return discipleSaleId;
958     }
959     
960     function _discipleVendPrice(uint _discipleId , uint _level) internal returns (uint) {
961         if(pricePause == true) {
962             if(DiscipleVendToTime[_discipleId] != 0 && DiscipleVendToTime[_discipleId] != endTime) {
963                 uint timePass = safeSub(endTime, startTime);
964                 DiscipleVending[_level] = _computePrice(DiscipleVending[_level], DiscipleVending[_level]*raiseIndex[1], preSaleDurance, timePass);
965                 DiscipleVendToTime[_discipleId] = endTime;
966             }
967             return DiscipleVending[_level];
968         } else {
969             if(DiscipleVendToTime[_discipleId] == 0) {
970                 DiscipleVendToTime[_discipleId] = uint(now);
971             }
972             uint currentPrice = _computePrice(DiscipleVending[_level], DiscipleVending[_level]*raiseIndex[1], preSaleDurance, safeSub(uint(now), startTime));
973             return currentPrice;
974         }
975     }
976     // ----------------------------------------------------------------------------
977     // Public Function
978     // ----------------------------------------------------------------------------
979     function createDiscipleSale(uint _num, uint _startId, uint _occupation, uint _level, uint _price) public onlyAdmin {
980         for(uint i = 0; i<_num; i++) {
981             _generateDiscipleSale(_startId + i, _occupation, _level, _price);
982         }
983     }
984     
985     function buyDisciple(uint _discipleSaleId, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
986         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
987         require(DiscipleSaleToBuyer[_discipleSale.discipleId] == address(0));
988         require(_discipleSale.ifSold == false);
989         uint currentPrice;
990         if(pricePause == true) {
991             if(_discipleSale.timestamp != 0 && _discipleSale.timestamp != endTime) {
992                 uint timePass = safeSub(endTime, startTime);
993                 _discipleSale.price = _computePrice(_discipleSale.price, _discipleSale.price*raiseIndex[1], preSaleDurance, timePass);
994                 _discipleSale.timestamp = endTime;
995             }
996             _brokerFeeDistribute(_discipleSale.price, 1, _brokerId, _subBrokerId);
997             require(msg.value >= _discipleSale.price);
998             currentPrice = _discipleSale.price;
999         } else {
1000             if(_discipleSale.timestamp == 0) {
1001                 _discipleSale.timestamp = uint(now);
1002             }
1003             currentPrice = _computePrice(_discipleSale.price, _discipleSale.price*raiseIndex[1], preSaleDurance, safeSub(uint(now), startTime));
1004             _brokerFeeDistribute(currentPrice, 1, _brokerId, _subBrokerId);
1005             require(msg.value >= currentPrice);
1006             _discipleSale.price = currentPrice;
1007         }
1008         DiscipleSaleToBuyer[_discipleSale.discipleId] = msg.sender;
1009         _discipleSale.ifSold = true;
1010         emit BuyDisciple(_discipleSaleId, _discipleSale.discipleId, msg.sender, currentPrice);
1011     }
1012     
1013     function offlineDiscipleSold(uint _discipleSaleId, address _buyer, uint _price) public onlyAdmin {
1014         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
1015         require(_discipleSale.ifSold == false);
1016         DiscipleSaleToBuyer[_discipleSale.discipleId] = _buyer;
1017         _discipleSale.ifSold = true;
1018         emit BuyDisciple(_discipleSaleId, _discipleSale.discipleId, _buyer, _price);
1019     }
1020     
1021     function OfferToDisciple(uint _discipleSaleId, uint _price) public payable whenNotPaused {
1022         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
1023         require(_discipleSale.ifSold == true);
1024         require(_price > _discipleSale.offerPrice*11/10);
1025         require(msg.value >= _price);
1026         
1027         if(_discipleSale.bidder == address(0)) {
1028             _discipleSale.bidder = msg.sender;
1029             _discipleSale.offerPrice = _price;
1030         } else {
1031             address lastBidder = _discipleSale.bidder;
1032             uint lastOffer = _discipleSale.price;
1033             lastBidder.transfer(lastOffer);
1034             
1035             _discipleSale.bidder = msg.sender;
1036             _discipleSale.offerPrice = _price;
1037         }
1038         
1039         emit DiscipleOfferSubmit(_discipleSaleId, _discipleSale.discipleId, msg.sender, _price);
1040     }
1041     
1042     function AcceptDiscipleOffer(uint _discipleSaleId) public whenNotPaused {
1043         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
1044         require(DiscipleSaleToBuyer[_discipleSale.discipleId] == msg.sender);
1045         require(_discipleSale.bidder != address(0) && _discipleSale.offerPrice > 0);
1046         msg.sender.transfer(_discipleSale.offerPrice);
1047         DiscipleSaleToBuyer[_discipleSale.discipleId] = _discipleSale.bidder;
1048         _discipleSale.price = _discipleSale.offerPrice;
1049         
1050         emit DiscipleOfferAccept(_discipleSaleId, _discipleSale.discipleId, _discipleSale.bidder, _discipleSale.price);
1051         
1052         _discipleSale.bidder = address(0);
1053         _discipleSale.offerPrice = 0;
1054     }
1055     
1056     function setDiscipleSale(uint _discipleSaleId, uint _price) public onlyAdmin {
1057         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
1058         require(_discipleSale.ifSold == false);
1059         _discipleSale.price = _price;
1060         emit SetDiscipleSale(_discipleSaleId, _price);
1061     }
1062     
1063     function getDiscipleSale(uint _discipleSaleId) public view returns (
1064         address owner,
1065         uint discipleId,
1066         uint occupation,
1067         uint level,
1068         uint price,
1069         bool ifSold,
1070         address bidder,
1071         uint offerPrice,
1072         uint timestamp
1073     ) {
1074         DiscipleSale memory _DiscipleSale = discipleSales[_discipleSaleId];
1075         owner = DiscipleSaleToBuyer[_DiscipleSale.discipleId];
1076         discipleId = _DiscipleSale.discipleId;
1077         occupation = _DiscipleSale.occupation;
1078         level = _DiscipleSale.level;
1079         price = _DiscipleSale.price;
1080         ifSold =_DiscipleSale.ifSold;
1081         bidder = _DiscipleSale.bidder;
1082         offerPrice = _DiscipleSale.offerPrice;
1083         timestamp = _DiscipleSale.timestamp;
1084     }
1085     
1086     function getDiscipleNum() public view returns(uint) {
1087         return discipleSales.length;
1088     }
1089     
1090     function vendDisciple(uint _discipleId) public payable whenNotPaused {
1091         require(_discipleId > 1000 && _discipleId <= 10000);
1092         if(_discipleId > 1000 && _discipleId <= 2000) {
1093             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1094             require(msg.value >= _discipleVendPrice(_discipleId, 0));
1095             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1096             DiscipleVendToOffer[_discipleId] = DiscipleVending[0];
1097         } else if (_discipleId > 2000 && _discipleId <= 4000) {
1098             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1099             require(msg.value >= _discipleVendPrice(_discipleId, 1));
1100             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1101             DiscipleVendToOffer[_discipleId] = DiscipleVending[1];
1102         } else if (_discipleId > 4000 && _discipleId <= 6000) {
1103             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1104             require(msg.value >= _discipleVendPrice(_discipleId, 2));
1105             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1106             DiscipleVendToOffer[_discipleId] = DiscipleVending[2];
1107         } else if (_discipleId > 6000 && _discipleId <= 8000) {
1108             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1109             require(msg.value >= _discipleVendPrice(_discipleId, 3));
1110             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1111             DiscipleVendToOffer[_discipleId] = DiscipleVending[3];
1112         } else if (_discipleId > 8000 && _discipleId <= 10000) {
1113             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1114             require(msg.value >= _discipleVendPrice(_discipleId, 4));
1115             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1116             DiscipleVendToOffer[_discipleId] = DiscipleVending[4];
1117         }
1118         emit VendingDisciple(_discipleId, msg.sender);
1119     }
1120     
1121     function offerDiscipleVend(uint _discipleId, uint _offer) public payable whenNotPaused {
1122         require(DiscipleSaleToBuyer[_discipleId] != address(0));
1123         require(_offer >= DiscipleVendToOffer[_discipleId]*11/10);
1124         require(msg.value >= _offer);
1125         address lastBidder = DiscipleVendToBidder[_discipleId];
1126         if(lastBidder != address(0)){
1127             lastBidder.transfer(DiscipleVendToOffer[_discipleId]);
1128         }
1129         DiscipleVendToBidder[_discipleId] = msg.sender;
1130         DiscipleVendToOffer[_discipleId] = _offer;
1131         emit DiscipleVendOffer(_discipleId, msg.sender, _offer);
1132     }
1133     
1134     function acceptDiscipleVend(uint _discipleId) public whenNotPaused {
1135         require(DiscipleSaleToBuyer[_discipleId] == msg.sender);
1136         address bidder = DiscipleVendToBidder[_discipleId];
1137         uint offer = DiscipleVendToOffer[_discipleId];
1138         require(bidder != address(0) && offer > 0);
1139         msg.sender.transfer(offer);
1140         DiscipleSaleToBuyer[_discipleId] = bidder;
1141         DiscipleVendToBidder[_discipleId] = address(0);
1142         DiscipleVendToOffer[_discipleId] = 0;
1143         emit DiscipleVendAccept(_discipleId, bidder, offer);
1144     }
1145     
1146     function setDiscipleVend(uint _num, uint _price) public onlyAdmin {
1147         DiscipleVending[_num] = _price;
1148         emit SetDiscipleVend(_num, _price);
1149     }
1150     
1151     function getDiscipleVend(uint _discipleId) public view returns (
1152         address owner,
1153         address bidder,
1154         uint offer
1155     ) {
1156         owner = DiscipleSaleToBuyer[_discipleId];
1157         bidder = DiscipleVendToBidder[_discipleId];
1158         offer = DiscipleVendToOffer[_discipleId];
1159     }
1160 }
1161 
1162 contract PreSaleAssets is PreSaleDisciple {
1163     // ----------------------------------------------------------------------------
1164     // Events
1165     // ----------------------------------------------------------------------------
1166     event BuyDiscipleItem(address indexed buyer, uint indexed rarity, uint indexed number, uint currentPrice);
1167     event BuyGuardianRune(address indexed buyer, uint indexed rarity, uint indexed number, uint currentPrice);
1168     
1169     event SetDiscipleItem(uint indexed rarity, uint indexed price);
1170     event SetGuardianRune(uint indexed rarity, uint indexed price);
1171     
1172     // ----------------------------------------------------------------------------
1173     // Mappings
1174     // ----------------------------------------------------------------------------
1175     mapping (address => uint) PlayerOwnRareItem;
1176     mapping (address => uint) PlayerOwnEpicItem;
1177     mapping (address => uint) PlayerOwnLegendaryItem;
1178     mapping (address => uint) PlayerOwnUniqueItem;
1179     
1180     mapping (address => uint) PlayerOwnRareRune;
1181     mapping (address => uint) PlayerOwnEpicRune;
1182     mapping (address => uint) PlayerOwnLegendaryRune;
1183     mapping (address => uint) PlayerOwnUniqueRune;
1184     
1185     // ----------------------------------------------------------------------------
1186     // Variables
1187     // ----------------------------------------------------------------------------
1188     uint[4] public DiscipleItem = [
1189         0.68 ether,
1190         1.98 ether,
1191         4.88 ether,
1192         9.98 ether
1193     ];
1194     
1195     uint[4] public GuardianRune = [
1196         1.18 ether,
1197         4.88 ether,
1198         8.88 ether,
1199         13.88 ether
1200     ];
1201     
1202     uint itemTimeStamp;
1203     uint runeTimeStamp;
1204     // ----------------------------------------------------------------------------
1205     // Modifier
1206     // ----------------------------------------------------------------------------
1207     
1208     // ----------------------------------------------------------------------------
1209     // Internal Function
1210     // ----------------------------------------------------------------------------
1211     
1212     // ----------------------------------------------------------------------------
1213     // Public Function
1214     // ----------------------------------------------------------------------------
1215     function buyDiscipleItem(uint _rarity, uint _num, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
1216         require(_rarity >= 0 && _rarity <= 4);
1217         uint currentPrice;
1218         if(pricePause == true) {
1219             if(itemTimeStamp != 0 && itemTimeStamp != endTime) {
1220                 uint timePass = safeSub(endTime, startTime);
1221                 DiscipleItem[0] = _computePrice(DiscipleItem[0], DiscipleItem[0]*raiseIndex[2], preSaleDurance, timePass);
1222                 DiscipleItem[1] = _computePrice(DiscipleItem[1], DiscipleItem[1]*raiseIndex[2], preSaleDurance, timePass);
1223                 DiscipleItem[2] = _computePrice(DiscipleItem[2], DiscipleItem[2]*raiseIndex[2], preSaleDurance, timePass);
1224                 DiscipleItem[3] = _computePrice(DiscipleItem[3], DiscipleItem[3]*raiseIndex[2], preSaleDurance, timePass);
1225                 itemTimeStamp = endTime;
1226             }
1227             require(msg.value >= DiscipleItem[_rarity]*_num);
1228             currentPrice = DiscipleItem[_rarity]*_num;
1229             _brokerFeeDistribute(currentPrice, 2, _brokerId, _subBrokerId);
1230         } else {
1231             if(itemTimeStamp == 0) {
1232                 itemTimeStamp = uint(now);
1233             }
1234             currentPrice = _computePrice(DiscipleItem[_rarity], DiscipleItem[_rarity]*raiseIndex[2], preSaleDurance, safeSub(uint(now), startTime));
1235             require(msg.value >= currentPrice*_num);
1236             currentPrice = currentPrice*_num;
1237             _brokerFeeDistribute(currentPrice, 2, _brokerId, _subBrokerId);
1238         }
1239         if(_rarity == 0) {
1240             PlayerOwnRareItem[msg.sender] = safeAdd(PlayerOwnRareItem[msg.sender], _num);
1241         } else if (_rarity == 1) {
1242             PlayerOwnEpicItem[msg.sender] = safeAdd(PlayerOwnEpicItem[msg.sender], _num);
1243         } else if (_rarity == 2) {
1244             PlayerOwnLegendaryItem[msg.sender] = safeAdd(PlayerOwnLegendaryItem[msg.sender], _num);
1245         } else if (_rarity == 3) {
1246             PlayerOwnUniqueItem[msg.sender] = safeAdd(PlayerOwnUniqueItem[msg.sender], _num);
1247         }
1248         emit BuyDiscipleItem(msg.sender, _rarity, _num, currentPrice);
1249     }   
1250     
1251     function buyGuardianRune(uint _rarity, uint _num, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
1252         require(_rarity >= 0 && _rarity <= 4);
1253         uint currentPrice;
1254         if(pricePause == true) {
1255             if(runeTimeStamp != 0 && runeTimeStamp != endTime) {
1256                 uint timePass = safeSub(endTime, startTime);
1257                 GuardianRune[0] = _computePrice(GuardianRune[0], GuardianRune[0]*raiseIndex[2], preSaleDurance, timePass);
1258                 GuardianRune[1] = _computePrice(GuardianRune[1], GuardianRune[1]*raiseIndex[2], preSaleDurance, timePass);
1259                 GuardianRune[2] = _computePrice(GuardianRune[2], GuardianRune[2]*raiseIndex[2], preSaleDurance, timePass);
1260                 GuardianRune[3] = _computePrice(GuardianRune[3], GuardianRune[3]*raiseIndex[2], preSaleDurance, timePass);
1261                 runeTimeStamp = endTime;
1262             }
1263             require(msg.value >= GuardianRune[_rarity]*_num);
1264             currentPrice = GuardianRune[_rarity]*_num;
1265             _brokerFeeDistribute(currentPrice, 2, _brokerId, _subBrokerId);
1266         } else {
1267             if(runeTimeStamp == 0) {
1268                 runeTimeStamp = uint(now);
1269             }
1270             currentPrice = _computePrice(GuardianRune[_rarity], GuardianRune[_rarity]*raiseIndex[2], preSaleDurance, safeSub(uint(now), startTime));
1271             require(msg.value >= currentPrice*_num);
1272             currentPrice = currentPrice*_num;
1273             _brokerFeeDistribute(currentPrice, 2, _brokerId, _subBrokerId);
1274         }
1275         if(_rarity == 0) {
1276             PlayerOwnRareRune[msg.sender] = safeAdd(PlayerOwnRareRune[msg.sender], _num);
1277         } else if (_rarity == 1) {
1278             PlayerOwnEpicRune[msg.sender] = safeAdd(PlayerOwnEpicRune[msg.sender], _num);
1279         } else if (_rarity == 2) {
1280             PlayerOwnLegendaryRune[msg.sender] = safeAdd(PlayerOwnLegendaryRune[msg.sender], _num);
1281         } else if (_rarity == 3) {
1282             PlayerOwnUniqueRune[msg.sender] = safeAdd(PlayerOwnUniqueRune[msg.sender], _num);
1283         }
1284         emit BuyGuardianRune(msg.sender, _rarity, _num, currentPrice);
1285     }
1286     
1287     function setDiscipleItem(uint _rarity, uint _price) public onlyAdmin {
1288         DiscipleItem[_rarity] = _price;
1289         emit SetDiscipleItem(_rarity, _price);
1290     }
1291     
1292     function setGuardianRune(uint _rarity, uint _price) public onlyAdmin {
1293         GuardianRune[_rarity] = _price;
1294         emit SetDiscipleItem(_rarity, _price);
1295     }
1296     
1297     function getPlayerInventory(address _player) public view returns (
1298         uint rareItem,
1299         uint epicItem,
1300         uint legendaryItem,
1301         uint uniqueItem,
1302         uint rareRune,
1303         uint epicRune,
1304         uint legendaryRune,
1305         uint uniqueRune
1306     ) {
1307         rareItem = PlayerOwnRareItem[_player];
1308         epicItem = PlayerOwnEpicItem[_player];
1309         legendaryItem = PlayerOwnLegendaryItem[_player];
1310         uniqueItem = PlayerOwnUniqueItem[_player];
1311         rareRune = PlayerOwnRareRune[_player];
1312         epicRune = PlayerOwnEpicRune[_player];
1313         legendaryRune = PlayerOwnLegendaryRune[_player];
1314         uniqueRune = PlayerOwnUniqueRune[_player];
1315     }
1316 }
1317 
1318 contract PreSale is PreSaleAssets {
1319     constructor() public {
1320         CEOAddress = msg.sender;
1321         BrokerIdToBrokers[0].push(msg.sender);
1322     }
1323 }