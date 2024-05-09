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
47         2,
48         3,
49         3
50     ];
51     
52     uint[3] rewardPercent = [
53         10,
54         15,
55         18
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
166     event BrokerFeeDistrubution(uint brokerId, address indexed vipBroker, uint indexed vipShare, uint subBrokerId, address indexed broker, uint share);
167     event BrokerFeeClaim(address indexed broker, uint indexed fee);
168     
169     // ----------------------------------------------------------------------------
170     // Mappings
171     // ----------------------------------------------------------------------------
172     mapping (uint => address[]) BrokerIdToBrokers;
173     mapping (uint => uint) BrokerIdToSpots;
174     mapping (address => uint) BrokerIncoming;
175     mapping (address => bool) UserToIfBroker;
176     
177     // ----------------------------------------------------------------------------
178     // Variables
179     // ----------------------------------------------------------------------------
180     uint public vipBrokerFee = 1.8 ether;
181     uint public brokerFee = 0.38 ether;
182     uint public vipBrokerNum = 100;
183     uint public subBrokerNum = 5;
184     
185     // ----------------------------------------------------------------------------
186     // Modifier
187     // ----------------------------------------------------------------------------
188     
189     // ----------------------------------------------------------------------------
190     // Internal Function
191     // ----------------------------------------------------------------------------
192     function _brokerFeeDistribute(uint _price, uint _type, uint _brokerId, uint _subBrokerId) internal {
193         address vipBroker = getBrokerAddress(_brokerId, 0);
194         address broker = getBrokerAddress(_brokerId, _subBrokerId);
195         require(vipBroker != address(0) && broker != address(0));
196         uint totalShare = _price*rewardPercent[_type]/100;
197         BrokerIncoming[vipBroker] = BrokerIncoming[vipBroker] + totalShare*15/100;
198         BrokerIncoming[broker] = BrokerIncoming[broker] + totalShare*85/100;
199         
200         emit BrokerFeeDistrubution(_brokerId, vipBroker, totalShare*15/100, _subBrokerId, broker, totalShare*85/100);
201     }
202     
203     // ----------------------------------------------------------------------------
204     // Public Function
205     // ----------------------------------------------------------------------------
206     function registerBroker() public payable returns (uint) {
207         require(vipBrokerNum > 0);
208         require(msg.value >= vipBrokerFee);
209         require(UserToIfBroker[msg.sender] == false);
210         UserToIfBroker[msg.sender] = true;
211         vipBrokerNum--;
212         uint brokerId = 100 - vipBrokerNum;
213         BrokerIdToBrokers[brokerId].push(msg.sender);
214         BrokerIdToSpots[brokerId] = subBrokerNum;
215         emit BrokerRegistered(brokerId, msg.sender);
216         return brokerId;
217     }
218     
219     function assignSubBroker(uint _brokerId, address _broker) public payable {
220         require(msg.sender == BrokerIdToBrokers[_brokerId][0]);
221         require(msg.value >= brokerFee);
222         require(UserToIfBroker[_broker] == false);
223         UserToIfBroker[_broker] = true;
224         require(BrokerIdToSpots[_brokerId] > 0);
225         uint newSubBrokerId = BrokerIdToBrokers[_brokerId].push(_broker) - 1;
226         BrokerIdToSpots[_brokerId]--;
227         
228         emit AppendSubBroker(_brokerId, newSubBrokerId, _broker);
229     }
230     
231     function transferBroker(address _newBroker, uint _brokerId, uint _subBrokerId) public whenNotPaused {
232         require(_brokerId > 0 && _brokerId <= 100);
233         require(_subBrokerId >= 0 && _subBrokerId <= 5);
234         require(UserToIfBroker[msg.sender] == true);
235         UserToIfBroker[msg.sender] = false;
236         require(BrokerIdToBrokers[_brokerId][_subBrokerId] == msg.sender);
237         BrokerIdToBrokers[_brokerId][_subBrokerId] = _newBroker;
238         
239         emit BrokerTransfer(_newBroker, _brokerId, _subBrokerId);
240     }
241 
242     function claimBrokerFee() public whenNotPaused {
243         uint fee = BrokerIncoming[msg.sender];
244         require(fee > 0);
245         msg.sender.transfer(fee);
246         BrokerIncoming[msg.sender] = 0;
247         emit BrokerFeeClaim(msg.sender, fee);
248     }
249     
250     function getBrokerIncoming(address _broker) public view returns (uint) {
251         return BrokerIncoming[_broker];
252     } 
253     
254     function getBrokerInfo(uint _brokerId) public view returns (
255         address broker,
256         uint subSpot
257     ) { 
258         broker = BrokerIdToBrokers[_brokerId][0];
259         subSpot = BrokerIdToSpots[_brokerId];
260     }
261     
262     function getBrokerAddress(uint _brokerId, uint _subBrokerId) public view returns (address) {
263         return BrokerIdToBrokers[_brokerId][_subBrokerId];
264     }
265     
266     function getVipBrokerNum() public view returns (uint) {
267         return safeSub(100, vipBrokerNum);
268     }
269 }
270 
271 contract PreSaleRealm is Broker {
272     // ----------------------------------------------------------------------------
273     // Events
274     // ----------------------------------------------------------------------------
275     event RealmSaleCreate(uint indexed saleId, uint indexed realmId, uint indexed price);
276     event BuyRealm(uint indexed saleId, uint realmId, address indexed buyer, uint indexed currentPrice);
277     event RealmOfferSubmit(uint indexed saleId, uint realmId, address indexed bidder, uint indexed price);
278     event RealmOfferAccept(uint indexed saleId, uint realmId, address indexed newOwner, uint indexed newPrice);
279     event SetRealmSale(uint indexed saleId, uint indexed price);
280     
281     event RealmAuctionCreate(uint indexed auctionId, uint indexed realmId, uint indexed startPrice);
282     event RealmAuctionBid(uint indexed auctionId, address indexed bidder, uint indexed offer);
283     
284     
285     // ----------------------------------------------------------------------------
286     // Mappings
287     // ----------------------------------------------------------------------------
288     mapping (uint => address) public RealmSaleToBuyer;
289     mapping (uint => bool) RealmIdToIfCreated;
290     
291     // ----------------------------------------------------------------------------
292     // Variables
293     // ----------------------------------------------------------------------------
294     struct RealmSale {
295         uint realmId;
296         uint price;
297         bool ifSold;
298         address bidder;
299         uint offerPrice;
300         uint timestamp;
301     }
302     
303     RealmSale[] realmSales;
304     
305     // ----------------------------------------------------------------------------
306     // Modifier
307     // ----------------------------------------------------------------------------
308     
309     // ----------------------------------------------------------------------------
310     // Internal Function
311     // ----------------------------------------------------------------------------
312     function _generateRealmSale(uint _realmId, uint _price) internal returns (uint) {
313         require(RealmIdToIfCreated[_realmId] == false);
314         RealmIdToIfCreated[_realmId] = true;
315         RealmSale memory _RealmSale = RealmSale({
316             realmId: _realmId,
317             price: _price,
318             ifSold: false,
319             bidder: address(0),
320             offerPrice: 0,
321             timestamp: 0
322         });
323         uint realmSaleId = realmSales.push(_RealmSale) - 1;
324         emit RealmSaleCreate(realmSaleId, _realmId, _price);
325         
326         return realmSaleId;
327     }
328     // ----------------------------------------------------------------------------
329     // Public Function
330     // ----------------------------------------------------------------------------
331     function createRealmSale(uint _num, uint _startId, uint _price) public onlyAdmin {
332         for(uint i = 0; i<_num; i++) {
333             _generateRealmSale(_startId + i, _price);
334         }
335     }
336     
337     function buyRealm(uint _realmSaleId, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
338         RealmSale storage _realmSale = realmSales[_realmSaleId];
339         require(RealmSaleToBuyer[_realmSale.realmId] == address(0));
340         require(_realmSale.ifSold == false);
341         uint currentPrice;
342         if(pricePause == true) {
343             if(_realmSale.timestamp != 0 && _realmSale.timestamp != endTime) {
344                 uint timePass = safeSub(endTime, startTime);
345                 _realmSale.price = _computePrice(_realmSale.price, _realmSale.price*raiseIndex[0], preSaleDurance, timePass);
346                 _realmSale.timestamp = endTime;
347             }
348             _brokerFeeDistribute(_realmSale.price, 0, _brokerId, _subBrokerId);
349             require(msg.value >= _realmSale.price);
350             currentPrice = _realmSale.price;
351         } else {
352             if(_realmSale.timestamp == 0) {
353                 _realmSale.timestamp = uint(now);
354             }
355             currentPrice = _computePrice(_realmSale.price, _realmSale.price*raiseIndex[0], preSaleDurance, safeSub(uint(now), startTime));
356             _brokerFeeDistribute(currentPrice, 0, _brokerId, _subBrokerId);
357             require(msg.value >= currentPrice);
358             _realmSale.price = currentPrice;
359         }
360         RealmSaleToBuyer[_realmSale.realmId] = msg.sender;
361         _realmSale.ifSold = true;
362         emit BuyRealm(_realmSaleId, _realmSale.realmId, msg.sender, currentPrice);
363     }
364     
365     function offlineRealmSold(uint _realmSaleId, address _buyer, uint _price) public onlyAdmin {
366         RealmSale storage _realmSale = realmSales[_realmSaleId];
367         require(_realmSale.ifSold == false);
368         RealmSaleToBuyer[_realmSale.realmId] = _buyer;
369         _realmSale.ifSold = true;
370         emit BuyRealm(_realmSaleId, _realmSale.realmId, _buyer, _price);
371     }
372     
373     function OfferToRealm(uint _realmSaleId, uint _price) public payable whenNotPaused {
374         RealmSale storage _realmSale = realmSales[_realmSaleId];
375         require(_realmSale.ifSold == true);
376         require(_price >= _realmSale.offerPrice*11/10);
377         require(msg.value >= _price);
378         
379         if(_realmSale.bidder == address(0)) {
380             _realmSale.bidder = msg.sender;
381             _realmSale.offerPrice = _price;
382         } else {
383             address lastBidder = _realmSale.bidder;
384             uint lastOffer = _realmSale.price;
385             lastBidder.transfer(lastOffer);
386             
387             _realmSale.bidder = msg.sender;
388             _realmSale.offerPrice = _price;
389         }
390         
391         emit RealmOfferSubmit(_realmSaleId, _realmSale.realmId, msg.sender, _price);
392     }
393     
394     function AcceptRealmOffer(uint _realmSaleId) public whenNotPaused {
395         RealmSale storage _realmSale = realmSales[_realmSaleId];
396         require(RealmSaleToBuyer[_realmSale.realmId] == msg.sender);
397         require(_realmSale.bidder != address(0) && _realmSale.offerPrice > 0);
398         msg.sender.transfer(_realmSale.offerPrice);
399         RealmSaleToBuyer[_realmSale.realmId] = _realmSale.bidder;
400         _realmSale.price = _realmSale.offerPrice;
401         
402         emit RealmOfferAccept(_realmSaleId, _realmSale.realmId, _realmSale.bidder, _realmSale.offerPrice);
403         
404         _realmSale.bidder = address(0);
405         _realmSale.offerPrice = 0;
406     }
407     
408     function setRealmSale(uint _realmSaleId, uint _price) public onlyAdmin {
409         RealmSale storage _realmSale = realmSales[_realmSaleId];
410         require(_realmSale.ifSold == false);
411         _realmSale.price = _price;
412         emit SetRealmSale(_realmSaleId, _price);
413     }
414     
415     function getRealmSale(uint _realmSaleId) public view returns (
416         address owner,
417         uint realmId,
418         uint price,
419         bool ifSold,
420         address bidder,
421         uint offerPrice,
422         uint timestamp
423     ) {
424         RealmSale memory _RealmSale = realmSales[_realmSaleId];
425         owner = RealmSaleToBuyer[_RealmSale.realmId];
426         realmId = _RealmSale.realmId;
427         price = _RealmSale.price;
428         ifSold =_RealmSale.ifSold;
429         bidder = _RealmSale.bidder;
430         offerPrice = _RealmSale.offerPrice;
431         timestamp = _RealmSale.timestamp;
432     }
433     
434     function getRealmNum() public view returns (uint) {
435         return realmSales.length;
436     }
437 }
438 
439 contract PreSaleCastle is PreSaleRealm {
440     // ----------------------------------------------------------------------------
441     // Events
442     // ----------------------------------------------------------------------------
443     event CastleSaleCreate(uint indexed saleId, uint indexed castleId, uint indexed price, uint realmId, uint rarity);
444     event BuyCastle(uint indexed saleId, uint castleId, address indexed buyer, uint indexed currentPrice);
445     event CastleOfferSubmit(uint indexed saleId, uint castleId, address indexed bidder, uint indexed price);
446     event CastleOfferAccept(uint indexed saleId, uint castleId, address indexed newOwner, uint indexed newPrice);
447     event SetCastleSale(uint indexed saleId, uint indexed price, uint realmId, uint rarity);
448     
449     event CastleAuctionCreate(uint indexed auctionId, uint indexed castleId, uint indexed startPrice, uint realmId, uint rarity);
450     event CastleAuctionBid(uint indexed auctionId, address indexed bidder, uint indexed offer);
451     
452     
453     // ----------------------------------------------------------------------------
454     // Mappings
455     // ----------------------------------------------------------------------------
456     mapping (uint => address) public CastleSaleToBuyer;
457     mapping (uint => bool) CastleIdToIfCreated;
458     
459     // ----------------------------------------------------------------------------
460     // Variables
461     // ----------------------------------------------------------------------------
462     struct CastleSale {
463         uint castleId;
464         uint realmId;
465         uint rarity;
466         uint price;
467         bool ifSold;
468         address bidder;
469         uint offerPrice;
470         uint timestamp;
471     }
472 
473     CastleSale[] castleSales;
474 
475     // ----------------------------------------------------------------------------
476     // Modifier
477     // ----------------------------------------------------------------------------
478     
479     // ----------------------------------------------------------------------------
480     // Internal Function
481     // ----------------------------------------------------------------------------
482     function _generateCastleSale(uint _castleId, uint _realmId, uint _rarity, uint _price) internal returns (uint) {
483         require(CastleIdToIfCreated[_castleId] == false);
484         CastleIdToIfCreated[_castleId] = true;
485         CastleSale memory _CastleSale = CastleSale({
486             castleId: _castleId,
487             realmId: _realmId,
488             rarity: _rarity,
489             price: _price,
490             ifSold: false,
491             bidder: address(0),
492             offerPrice: 0,
493             timestamp: 0
494         });
495         uint castleSaleId = castleSales.push(_CastleSale) - 1;
496         emit CastleSaleCreate(castleSaleId, _castleId, _price, _realmId, _rarity);
497         
498         return castleSaleId;
499     }
500 
501     // ----------------------------------------------------------------------------
502     // Public Function
503     // ----------------------------------------------------------------------------
504     function createCastleSale(uint _num, uint _startId, uint _realmId, uint _rarity, uint _price) public onlyAdmin {
505         for(uint i = 0; i<_num; i++) {
506             _generateCastleSale(_startId + i, _realmId, _rarity, _price);
507         }
508     }
509     
510     function buyCastle(uint _castleSaleId, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
511         CastleSale storage _castleSale = castleSales[_castleSaleId];
512         require(CastleSaleToBuyer[_castleSale.castleId] == address(0));
513         require(_castleSale.ifSold == false);
514         uint currentPrice;
515         if(pricePause == true) {
516             if(_castleSale.timestamp != 0 && _castleSale.timestamp != endTime) {
517                 uint timePass = safeSub(endTime, startTime);
518                 _castleSale.price = _computePrice(_castleSale.price, _castleSale.price*raiseIndex[0], preSaleDurance, timePass);
519                 _castleSale.timestamp = endTime;
520             }
521             _brokerFeeDistribute(_castleSale.price, 0, _brokerId, _subBrokerId);
522             require(msg.value >= _castleSale.price);
523             currentPrice = _castleSale.price;
524         } else {
525             if(_castleSale.timestamp == 0) {
526                 _castleSale.timestamp = uint(now);
527             }
528             currentPrice = _computePrice(_castleSale.price, _castleSale.price*raiseIndex[0], preSaleDurance, safeSub(uint(now), startTime));
529             _brokerFeeDistribute(currentPrice, 0, _brokerId, _subBrokerId);
530             require(msg.value >= currentPrice);
531             _castleSale.price = currentPrice;
532         }
533         CastleSaleToBuyer[_castleSale.castleId] = msg.sender;
534         _castleSale.ifSold = true;
535         emit BuyCastle(_castleSaleId, _castleSale.castleId, msg.sender, currentPrice);
536     }
537     
538     function OfflineCastleSold(uint _castleSaleId, address _buyer, uint _price) public onlyAdmin {
539         CastleSale storage _castleSale = castleSales[_castleSaleId];
540         require(_castleSale.ifSold == false);
541         CastleSaleToBuyer[_castleSale.castleId] = _buyer;
542         _castleSale.ifSold = true;
543         emit BuyCastle(_castleSaleId, _castleSale.castleId, _buyer, _price);
544     }
545     
546     function OfferToCastle(uint _castleSaleId, uint _price) public payable whenNotPaused {
547         CastleSale storage _castleSale = castleSales[_castleSaleId];
548         require(_castleSale.ifSold == true);
549         require(_price >= _castleSale.offerPrice*11/10);
550         require(msg.value >= _price);
551         
552         if(_castleSale.bidder == address(0)) {
553             _castleSale.bidder = msg.sender;
554             _castleSale.offerPrice = _price;
555         } else {
556             address lastBidder = _castleSale.bidder;
557             uint lastOffer = _castleSale.price;
558             lastBidder.transfer(lastOffer);
559             
560             _castleSale.bidder = msg.sender;
561             _castleSale.offerPrice = _price;
562         }
563         
564         emit CastleOfferSubmit(_castleSaleId, _castleSale.castleId, msg.sender, _price);
565     }
566     
567     function AcceptCastleOffer(uint _castleSaleId) public whenNotPaused {
568         CastleSale storage _castleSale = castleSales[_castleSaleId];
569         require(CastleSaleToBuyer[_castleSale.castleId] == msg.sender);
570         require(_castleSale.bidder != address(0) && _castleSale.offerPrice > 0);
571         msg.sender.transfer(_castleSale.offerPrice);
572         CastleSaleToBuyer[_castleSale.castleId] = _castleSale.bidder;
573         _castleSale.price = _castleSale.offerPrice;
574         
575         emit CastleOfferAccept(_castleSaleId, _castleSale.castleId, _castleSale.bidder, _castleSale.offerPrice);
576         
577         _castleSale.bidder = address(0);
578         _castleSale.offerPrice = 0;
579     }
580     
581     function setCastleSale(uint _castleSaleId, uint _price, uint _realmId, uint _rarity) public onlyAdmin {
582         CastleSale storage _castleSale = castleSales[_castleSaleId];
583         require(_castleSale.ifSold == false);
584         _castleSale.price = _price;
585         _castleSale.realmId = _realmId;
586         _castleSale.rarity = _rarity;
587         emit SetCastleSale(_castleSaleId, _price, _realmId, _rarity);
588     }
589     
590     function getCastleSale(uint _castleSaleId) public view returns (
591         address owner,
592         uint castleId,
593         uint realmId,
594         uint rarity,
595         uint price,
596         bool ifSold,
597         address bidder,
598         uint offerPrice,
599         uint timestamp
600     ) {
601         CastleSale memory _CastleSale = castleSales[_castleSaleId];
602         owner = CastleSaleToBuyer[_CastleSale.castleId];
603         castleId = _CastleSale.castleId;
604         realmId = _CastleSale.realmId;
605         rarity = _CastleSale.rarity;
606         price = _CastleSale.price;
607         ifSold =_CastleSale.ifSold;
608         bidder = _CastleSale.bidder;
609         offerPrice = _CastleSale.offerPrice;
610         timestamp = _CastleSale.timestamp;
611     }
612     
613     function getCastleNum() public view returns (uint) {
614         return castleSales.length;
615     }
616 }
617 
618 contract PreSaleGuardian is PreSaleCastle {
619     // ----------------------------------------------------------------------------
620     // Events
621     // ----------------------------------------------------------------------------
622     event GuardianSaleCreate(uint indexed saleId, uint indexed guardianId, uint indexed price, uint race, uint level, uint starRate);
623     event BuyGuardian(uint indexed saleId, uint guardianId, address indexed buyer, uint indexed currentPrice);
624     event GuardianOfferSubmit(uint indexed saleId, uint guardianId, address indexed bidder, uint indexed price);
625     event GuardianOfferAccept(uint indexed saleId, uint guardianId, address indexed newOwner, uint indexed newPrice);
626     event SetGuardianSale(uint indexed saleId, uint indexed price, uint race, uint starRate, uint level);
627     
628     event GuardianAuctionCreate(uint indexed auctionId, uint indexed guardianId, uint indexed startPrice, uint race, uint level, uint starRate);
629     event GuardianAuctionBid(uint indexed auctionId, address indexed bidder, uint indexed offer);
630     
631     event VendingGuardian(uint indexed vendingId, address indexed buyer);
632     event GuardianVendOffer(uint indexed vendingId, address indexed bidder, uint indexed offer);
633     event GuardianVendAccept(uint indexed vendingId, address indexed newOwner, uint indexed newPrice);
634     event SetGuardianVend(uint indexed priceId, uint indexed price);
635     
636     // ----------------------------------------------------------------------------
637     // Mappings
638     // ----------------------------------------------------------------------------
639     mapping (uint => address) public GuardianSaleToBuyer;
640     mapping (uint => bool) GuardianIdToIfCreated;
641     
642     mapping (uint => uint) public GuardianVendToOffer;
643     mapping (uint => address) public GuardianVendToBidder;
644     mapping (uint => uint) public GuardianVendToTime;
645     
646     // ----------------------------------------------------------------------------
647     // Variables
648     // ----------------------------------------------------------------------------
649     struct GuardianSale {
650         uint guardianId;
651         uint race;
652         uint starRate;
653         uint level;
654         uint price;
655         bool ifSold;
656         address bidder;
657         uint offerPrice;
658         uint timestamp;
659     }
660     
661     GuardianSale[] guardianSales;
662 
663     uint[5] GuardianVending = [
664         0.5 ether,
665         0.35 ether,
666         0.20 ether,
667         0.15 ether,
668         0.1 ether
669     ];
670     
671     // ----------------------------------------------------------------------------
672     // Modifier
673     // ----------------------------------------------------------------------------
674     
675     // ----------------------------------------------------------------------------
676     // Internal Function
677     // ----------------------------------------------------------------------------
678     function _generateGuardianSale(uint _guardianId, uint _race, uint _starRate, uint _level, uint _price) internal returns (uint) {
679         require(GuardianIdToIfCreated[_guardianId] == false);
680         GuardianIdToIfCreated[_guardianId] = true;
681         GuardianSale memory _GuardianSale = GuardianSale({
682             guardianId: _guardianId,
683             race: _race,
684             starRate: _starRate,
685             level: _level,
686             price: _price,
687             ifSold: false,
688             bidder: address(0),
689             offerPrice: 0,
690             timestamp: 0
691         });
692         uint guardianSaleId = guardianSales.push(_GuardianSale) - 1;
693         emit GuardianSaleCreate(guardianSaleId, _guardianId, _price, _race, _level, _starRate);
694         
695         return guardianSaleId;
696     }
697     
698     function _guardianVendPrice(uint _guardianId , uint _level) internal returns (uint) {
699         if(pricePause == true) {
700             if(GuardianVendToTime[_guardianId] != 0 && GuardianVendToTime[_guardianId] != endTime) {
701                 uint timePass = safeSub(endTime, startTime);
702                 GuardianVending[_level] = _computePrice(GuardianVending[_level], GuardianVending[_level]*raiseIndex[1], preSaleDurance, timePass);
703                 GuardianVendToTime[_guardianId] = endTime;
704             }
705             return GuardianVending[_level];
706         } else {
707             if(GuardianVendToTime[_guardianId] == 0) {
708                 GuardianVendToTime[_guardianId] = uint(now);
709             }
710             uint currentPrice = _computePrice(GuardianVending[_level], GuardianVending[_level]*raiseIndex[1], preSaleDurance, safeSub(uint(now), startTime));
711             return currentPrice;
712         }
713     }
714     
715     // ----------------------------------------------------------------------------
716     // Public Function
717     // ----------------------------------------------------------------------------
718     function createGuardianSale(uint _num, uint _startId, uint _race, uint _starRate, uint _level, uint _price) public onlyAdmin {
719         for(uint i = 0; i<_num; i++) {
720             _generateGuardianSale(_startId + i, _race, _starRate, _level, _price);
721         }
722     }
723     
724     function buyGuardian(uint _guardianSaleId, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
725         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
726         require(GuardianSaleToBuyer[_guardianSale.guardianId] == address(0));
727         require(_guardianSale.ifSold == false);
728         uint currentPrice;
729         if(pricePause == true) {
730             if(_guardianSale.timestamp != 0 && _guardianSale.timestamp != endTime) {
731                 uint timePass = safeSub(endTime, startTime);
732                 _guardianSale.price = _computePrice(_guardianSale.price, _guardianSale.price*raiseIndex[1], preSaleDurance, timePass);
733                 _guardianSale.timestamp = endTime;
734             }
735             _brokerFeeDistribute(_guardianSale.price, 1, _brokerId, _subBrokerId);
736             require(msg.value >= _guardianSale.price);
737             currentPrice = _guardianSale.price;
738         } else {
739             if(_guardianSale.timestamp == 0) {
740                 _guardianSale.timestamp = uint(now);
741             }
742             currentPrice = _computePrice(_guardianSale.price, _guardianSale.price*raiseIndex[1], preSaleDurance, safeSub(uint(now), startTime));
743             _brokerFeeDistribute(currentPrice, 1, _brokerId, _subBrokerId);
744             require(msg.value >= currentPrice);
745             _guardianSale.price = currentPrice;
746         }
747         GuardianSaleToBuyer[_guardianSale.guardianId] = msg.sender;
748         _guardianSale.ifSold = true;
749         emit BuyGuardian(_guardianSaleId, _guardianSale.guardianId, msg.sender, currentPrice);
750     }
751     
752     function offlineGuardianSold(uint _guardianSaleId, address _buyer, uint _price) public onlyAdmin {
753         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
754         require(_guardianSale.ifSold == false);
755         GuardianSaleToBuyer[_guardianSale.guardianId] = _buyer;
756         _guardianSale.ifSold = true;
757         emit BuyGuardian(_guardianSaleId, _guardianSale.guardianId, _buyer, _price);
758     }
759     
760     function OfferToGuardian(uint _guardianSaleId, uint _price) public payable whenNotPaused {
761         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
762         require(_guardianSale.ifSold == true);
763         require(_price > _guardianSale.offerPrice*11/10);
764         require(msg.value >= _price);
765         
766         if(_guardianSale.bidder == address(0)) {
767             _guardianSale.bidder = msg.sender;
768             _guardianSale.offerPrice = _price;
769         } else {
770             address lastBidder = _guardianSale.bidder;
771             uint lastOffer = _guardianSale.price;
772             lastBidder.transfer(lastOffer);
773             
774             _guardianSale.bidder = msg.sender;
775             _guardianSale.offerPrice = _price;
776         }
777         
778         emit GuardianOfferSubmit(_guardianSaleId, _guardianSale.guardianId, msg.sender, _price);
779     }
780     
781     function AcceptGuardianOffer(uint _guardianSaleId) public whenNotPaused {
782         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
783         require(GuardianSaleToBuyer[_guardianSale.guardianId] == msg.sender);
784         require(_guardianSale.bidder != address(0) && _guardianSale.offerPrice > 0);
785         msg.sender.transfer(_guardianSale.offerPrice);
786         GuardianSaleToBuyer[_guardianSale.guardianId] = _guardianSale.bidder;
787         _guardianSale.price = _guardianSale.offerPrice;
788         
789         emit GuardianOfferAccept(_guardianSaleId, _guardianSale.guardianId, _guardianSale.bidder, _guardianSale.price);
790         
791         _guardianSale.bidder = address(0);
792         _guardianSale.offerPrice = 0;
793     }
794     
795     function setGuardianSale(uint _guardianSaleId, uint _price, uint _race, uint _starRate, uint _level) public onlyAdmin {
796         GuardianSale storage _guardianSale = guardianSales[_guardianSaleId];
797         require(_guardianSale.ifSold == false);
798         _guardianSale.price = _price;
799         _guardianSale.race = _race;
800         _guardianSale.starRate = _starRate;
801         _guardianSale.level = _level;
802         emit SetGuardianSale(_guardianSaleId, _price, _race, _starRate, _level);
803     }
804     
805     function getGuardianSale(uint _guardianSaleId) public view returns (
806         address owner,
807         uint guardianId,
808         uint race,
809         uint starRate,
810         uint level,
811         uint price,
812         bool ifSold,
813         address bidder,
814         uint offerPrice,
815         uint timestamp
816     ) {
817         GuardianSale memory _GuardianSale = guardianSales[_guardianSaleId];
818         owner = GuardianSaleToBuyer[_GuardianSale.guardianId];
819         guardianId = _GuardianSale.guardianId;
820         race = _GuardianSale.race;
821         starRate = _GuardianSale.starRate;
822         level = _GuardianSale.level;
823         price = _GuardianSale.price;
824         ifSold =_GuardianSale.ifSold;
825         bidder = _GuardianSale.bidder;
826         offerPrice = _GuardianSale.offerPrice;
827         timestamp = _GuardianSale.timestamp;
828     }
829     
830     function getGuardianNum() public view returns (uint) {
831         return guardianSales.length;
832     }
833 
834     function vendGuardian(uint _guardianId) public payable whenNotPaused {
835         require(_guardianId > 1000 && _guardianId <= 6000);
836         if(_guardianId > 1000 && _guardianId <= 2000) {
837             require(GuardianSaleToBuyer[_guardianId] == address(0));
838             require(msg.value >= _guardianVendPrice(_guardianId, 0));
839             GuardianSaleToBuyer[_guardianId] = msg.sender;
840             GuardianVendToOffer[_guardianId] = GuardianVending[0];
841         } else if (_guardianId > 2000 && _guardianId <= 3000) {
842             require(GuardianSaleToBuyer[_guardianId] == address(0));
843             require(msg.value >= _guardianVendPrice(_guardianId, 1));
844             GuardianSaleToBuyer[_guardianId] = msg.sender;
845             GuardianVendToOffer[_guardianId] = GuardianVending[1];
846         } else if (_guardianId > 3000 && _guardianId <= 4000) {
847             require(GuardianSaleToBuyer[_guardianId] == address(0));
848             require(msg.value >= _guardianVendPrice(_guardianId, 2));
849             GuardianSaleToBuyer[_guardianId] = msg.sender;
850             GuardianVendToOffer[_guardianId] = GuardianVending[2];
851         } else if (_guardianId > 4000 && _guardianId <= 5000) {
852             require(GuardianSaleToBuyer[_guardianId] == address(0));
853             require(msg.value >= _guardianVendPrice(_guardianId, 3));
854             GuardianSaleToBuyer[_guardianId] = msg.sender;
855             GuardianVendToOffer[_guardianId] = GuardianVending[3];
856         } else if (_guardianId > 5000 && _guardianId <= 6000) {
857             require(GuardianSaleToBuyer[_guardianId] == address(0));
858             require(msg.value >= _guardianVendPrice(_guardianId, 4));
859             GuardianSaleToBuyer[_guardianId] = msg.sender;
860             GuardianVendToOffer[_guardianId] = GuardianVending[4];
861         }
862         emit VendingGuardian(_guardianId, msg.sender);
863     }
864     
865     function offerGuardianVend(uint _guardianId, uint _offer) public payable whenNotPaused {
866         require(GuardianSaleToBuyer[_guardianId] != address(0));
867         require(_offer >= GuardianVendToOffer[_guardianId]*11/10);
868         require(msg.value >= _offer);
869         address lastBidder = GuardianVendToBidder[_guardianId];
870         if(lastBidder != address(0)){
871             lastBidder.transfer(GuardianVendToOffer[_guardianId]);
872         }
873         GuardianVendToBidder[_guardianId] = msg.sender;
874         GuardianVendToOffer[_guardianId] = _offer;
875         emit GuardianVendOffer(_guardianId, msg.sender, _offer);
876     }
877     
878     function acceptGuardianVend(uint _guardianId) public whenNotPaused {
879         require(GuardianSaleToBuyer[_guardianId] == msg.sender);
880         address bidder = GuardianVendToBidder[_guardianId];
881         uint offer = GuardianVendToOffer[_guardianId];
882         require(bidder != address(0) && offer > 0);
883         msg.sender.transfer(offer);
884         GuardianSaleToBuyer[_guardianId] = bidder;
885         GuardianVendToBidder[_guardianId] = address(0);
886         GuardianVendToOffer[_guardianId] = 0;
887         emit GuardianVendAccept(_guardianId, bidder, offer);
888     }
889     
890     function setGuardianVend(uint _num, uint _price) public onlyAdmin {
891         GuardianVending[_num] = _price;
892         emit SetGuardianVend(_num, _price);
893     }
894     
895     function getGuardianVend(uint _guardianId) public view returns (
896         address owner,
897         address bidder,
898         uint offer
899     ) {
900         owner = GuardianSaleToBuyer[_guardianId];
901         bidder = GuardianVendToBidder[_guardianId];
902         offer = GuardianVendToOffer[_guardianId];
903     }
904 }
905 
906 contract PreSaleDisciple is PreSaleGuardian {
907     // ----------------------------------------------------------------------------
908     // Events
909     // ----------------------------------------------------------------------------
910     event DiscipleSaleCreate(uint indexed saleId, uint indexed discipleId, uint indexed price, uint occupation, uint level);
911     event BuyDisciple(uint indexed saleId, uint discipleId, address indexed buyer, uint indexed currentPrice);
912     event DiscipleOfferSubmit(uint indexed saleId, uint discipleId, address indexed bidder, uint indexed price);
913     event DiscipleOfferAccept(uint indexed saleId, uint discipleId, address indexed newOwner, uint indexed newPrice);
914     event SetDiscipleSale(uint indexed saleId, uint indexed price, uint occupation, uint level);
915     
916     event DiscipleAuctionCreate(uint indexed auctionId, uint indexed discipleId, uint indexed startPrice, uint occupation, uint level);
917     event DiscipleAuctionBid(uint indexed auctionId, address indexed bidder, uint indexed offer);
918     
919     event VendingDisciple(uint indexed vendingId, address indexed buyer);
920     event DiscipleVendOffer(uint indexed vendingId, address indexed bidder, uint indexed offer);
921     event DiscipleVendAccept(uint indexed vendingId, address indexed newOwner, uint indexed newPrice);
922     event SetDiscipleVend(uint indexed priceId, uint indexed price);
923     
924     // ----------------------------------------------------------------------------
925     // Mappings
926     // ----------------------------------------------------------------------------
927     mapping (uint => address) public DiscipleSaleToBuyer;
928     mapping (uint => bool) DiscipleIdToIfCreated;
929     
930     mapping (uint => uint) public DiscipleVendToOffer;
931     mapping (uint => address) public DiscipleVendToBidder;
932     mapping (uint => uint) public DiscipleVendToTime;
933     
934     // ----------------------------------------------------------------------------
935     // Variables
936     // ----------------------------------------------------------------------------
937     struct DiscipleSale {
938         uint discipleId;
939         uint occupation;
940         uint level;
941         uint price;
942         bool ifSold;
943         address bidder;
944         uint offerPrice;
945         uint timestamp;
946     }
947     
948     DiscipleSale[] discipleSales;
949 
950     uint[5] DiscipleVending = [
951         0.3 ether,
952         0.2 ether,
953         0.15 ether,
954         0.1 ether,
955         0.05 ether
956     ];
957     
958     // ----------------------------------------------------------------------------
959     // Modifier
960     // ----------------------------------------------------------------------------
961     
962     // ----------------------------------------------------------------------------
963     // Internal Function
964     // ----------------------------------------------------------------------------
965     function _generateDiscipleSale(uint _discipleId, uint _occupation, uint _level, uint _price) internal returns (uint) {
966         require(DiscipleIdToIfCreated[_discipleId] == false);
967         DiscipleIdToIfCreated[_discipleId] = true;
968         DiscipleSale memory _DiscipleSale = DiscipleSale({
969             discipleId: _discipleId,
970             occupation: _occupation,
971             level: _level,
972             price: _price,
973             ifSold: false,
974             bidder: address(0),
975             offerPrice: 0,
976             timestamp: 0
977         });
978         uint discipleSaleId = discipleSales.push(_DiscipleSale) - 1;
979         emit DiscipleSaleCreate(discipleSaleId, _discipleId, _price, _occupation, _level);
980         
981         return discipleSaleId;
982     }
983     
984     function _discipleVendPrice(uint _discipleId , uint _level) internal returns (uint) {
985         if(pricePause == true) {
986             if(DiscipleVendToTime[_discipleId] != 0 && DiscipleVendToTime[_discipleId] != endTime) {
987                 uint timePass = safeSub(endTime, startTime);
988                 DiscipleVending[_level] = _computePrice(DiscipleVending[_level], DiscipleVending[_level]*raiseIndex[1], preSaleDurance, timePass);
989                 DiscipleVendToTime[_discipleId] = endTime;
990             }
991             return DiscipleVending[_level];
992         } else {
993             if(DiscipleVendToTime[_discipleId] == 0) {
994                 DiscipleVendToTime[_discipleId] = uint(now);
995             }
996             uint currentPrice = _computePrice(DiscipleVending[_level], DiscipleVending[_level]*raiseIndex[1], preSaleDurance, safeSub(uint(now), startTime));
997             return currentPrice;
998         }
999     }
1000     // ----------------------------------------------------------------------------
1001     // Public Function
1002     // ----------------------------------------------------------------------------
1003     function createDiscipleSale(uint _num, uint _startId, uint _occupation, uint _level, uint _price) public onlyAdmin {
1004         for(uint i = 0; i<_num; i++) {
1005             _generateDiscipleSale(_startId + i, _occupation, _level, _price);
1006         }
1007     }
1008     
1009     function buyDisciple(uint _discipleSaleId, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
1010         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
1011         require(DiscipleSaleToBuyer[_discipleSale.discipleId] == address(0));
1012         require(_discipleSale.ifSold == false);
1013         uint currentPrice;
1014         if(pricePause == true) {
1015             if(_discipleSale.timestamp != 0 && _discipleSale.timestamp != endTime) {
1016                 uint timePass = safeSub(endTime, startTime);
1017                 _discipleSale.price = _computePrice(_discipleSale.price, _discipleSale.price*raiseIndex[1], preSaleDurance, timePass);
1018                 _discipleSale.timestamp = endTime;
1019             }
1020             _brokerFeeDistribute(_discipleSale.price, 1, _brokerId, _subBrokerId);
1021             require(msg.value >= _discipleSale.price);
1022             currentPrice = _discipleSale.price;
1023         } else {
1024             if(_discipleSale.timestamp == 0) {
1025                 _discipleSale.timestamp = uint(now);
1026             }
1027             currentPrice = _computePrice(_discipleSale.price, _discipleSale.price*raiseIndex[1], preSaleDurance, safeSub(uint(now), startTime));
1028             _brokerFeeDistribute(currentPrice, 1, _brokerId, _subBrokerId);
1029             require(msg.value >= currentPrice);
1030             _discipleSale.price = currentPrice;
1031         }
1032         DiscipleSaleToBuyer[_discipleSale.discipleId] = msg.sender;
1033         _discipleSale.ifSold = true;
1034         emit BuyDisciple(_discipleSaleId, _discipleSale.discipleId, msg.sender, currentPrice);
1035     }
1036     
1037     function offlineDiscipleSold(uint _discipleSaleId, address _buyer, uint _price) public onlyAdmin {
1038         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
1039         require(_discipleSale.ifSold == false);
1040         DiscipleSaleToBuyer[_discipleSale.discipleId] = _buyer;
1041         _discipleSale.ifSold = true;
1042         emit BuyDisciple(_discipleSaleId, _discipleSale.discipleId, _buyer, _price);
1043     }
1044     
1045     function OfferToDisciple(uint _discipleSaleId, uint _price) public payable whenNotPaused {
1046         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
1047         require(_discipleSale.ifSold == true);
1048         require(_price > _discipleSale.offerPrice*11/10);
1049         require(msg.value >= _price);
1050         
1051         if(_discipleSale.bidder == address(0)) {
1052             _discipleSale.bidder = msg.sender;
1053             _discipleSale.offerPrice = _price;
1054         } else {
1055             address lastBidder = _discipleSale.bidder;
1056             uint lastOffer = _discipleSale.price;
1057             lastBidder.transfer(lastOffer);
1058             
1059             _discipleSale.bidder = msg.sender;
1060             _discipleSale.offerPrice = _price;
1061         }
1062         
1063         emit DiscipleOfferSubmit(_discipleSaleId, _discipleSale.discipleId, msg.sender, _price);
1064     }
1065     
1066     function AcceptDiscipleOffer(uint _discipleSaleId) public whenNotPaused {
1067         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
1068         require(DiscipleSaleToBuyer[_discipleSale.discipleId] == msg.sender);
1069         require(_discipleSale.bidder != address(0) && _discipleSale.offerPrice > 0);
1070         msg.sender.transfer(_discipleSale.offerPrice);
1071         DiscipleSaleToBuyer[_discipleSale.discipleId] = _discipleSale.bidder;
1072         _discipleSale.price = _discipleSale.offerPrice;
1073         
1074         emit DiscipleOfferAccept(_discipleSaleId, _discipleSale.discipleId, _discipleSale.bidder, _discipleSale.price);
1075         
1076         _discipleSale.bidder = address(0);
1077         _discipleSale.offerPrice = 0;
1078     }
1079     
1080     function setDiscipleSale(uint _discipleSaleId, uint _price, uint _occupation, uint _level) public onlyAdmin {
1081         DiscipleSale storage _discipleSale = discipleSales[_discipleSaleId];
1082         require(_discipleSale.ifSold == false);
1083         _discipleSale.price = _price;
1084         _discipleSale.occupation = _occupation;
1085         _discipleSale.level = _level;
1086         emit SetDiscipleSale(_discipleSaleId, _price, _occupation, _level);
1087     }
1088     
1089     function getDiscipleSale(uint _discipleSaleId) public view returns (
1090         address owner,
1091         uint discipleId,
1092         uint occupation,
1093         uint level,
1094         uint price,
1095         bool ifSold,
1096         address bidder,
1097         uint offerPrice,
1098         uint timestamp
1099     ) {
1100         DiscipleSale memory _DiscipleSale = discipleSales[_discipleSaleId];
1101         owner = DiscipleSaleToBuyer[_DiscipleSale.discipleId];
1102         discipleId = _DiscipleSale.discipleId;
1103         occupation = _DiscipleSale.occupation;
1104         level = _DiscipleSale.level;
1105         price = _DiscipleSale.price;
1106         ifSold =_DiscipleSale.ifSold;
1107         bidder = _DiscipleSale.bidder;
1108         offerPrice = _DiscipleSale.offerPrice;
1109         timestamp = _DiscipleSale.timestamp;
1110     }
1111     
1112     function getDiscipleNum() public view returns(uint) {
1113         return discipleSales.length;
1114     }
1115     
1116     function vendDisciple(uint _discipleId) public payable whenNotPaused {
1117         require(_discipleId > 1000 && _discipleId <= 10000);
1118         if(_discipleId > 1000 && _discipleId <= 2000) {
1119             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1120             require(msg.value >= _discipleVendPrice(_discipleId, 0));
1121             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1122             DiscipleVendToOffer[_discipleId] = DiscipleVending[0];
1123         } else if (_discipleId > 2000 && _discipleId <= 4000) {
1124             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1125             require(msg.value >= _discipleVendPrice(_discipleId, 1));
1126             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1127             DiscipleVendToOffer[_discipleId] = DiscipleVending[1];
1128         } else if (_discipleId > 4000 && _discipleId <= 6000) {
1129             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1130             require(msg.value >= _discipleVendPrice(_discipleId, 2));
1131             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1132             DiscipleVendToOffer[_discipleId] = DiscipleVending[2];
1133         } else if (_discipleId > 6000 && _discipleId <= 8000) {
1134             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1135             require(msg.value >= _discipleVendPrice(_discipleId, 3));
1136             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1137             DiscipleVendToOffer[_discipleId] = DiscipleVending[3];
1138         } else if (_discipleId > 8000 && _discipleId <= 10000) {
1139             require(DiscipleSaleToBuyer[_discipleId] == address(0));
1140             require(msg.value >= _discipleVendPrice(_discipleId, 4));
1141             DiscipleSaleToBuyer[_discipleId] = msg.sender;
1142             DiscipleVendToOffer[_discipleId] = DiscipleVending[4];
1143         }
1144         emit VendingDisciple(_discipleId, msg.sender);
1145     }
1146     
1147     function offerDiscipleVend(uint _discipleId, uint _offer) public payable whenNotPaused {
1148         require(DiscipleSaleToBuyer[_discipleId] != address(0));
1149         require(_offer >= DiscipleVendToOffer[_discipleId]*11/10);
1150         require(msg.value >= _offer);
1151         address lastBidder = DiscipleVendToBidder[_discipleId];
1152         if(lastBidder != address(0)){
1153             lastBidder.transfer(DiscipleVendToOffer[_discipleId]);
1154         }
1155         DiscipleVendToBidder[_discipleId] = msg.sender;
1156         DiscipleVendToOffer[_discipleId] = _offer;
1157         emit DiscipleVendOffer(_discipleId, msg.sender, _offer);
1158     }
1159     
1160     function acceptDiscipleVend(uint _discipleId) public whenNotPaused {
1161         require(DiscipleSaleToBuyer[_discipleId] == msg.sender);
1162         address bidder = DiscipleVendToBidder[_discipleId];
1163         uint offer = DiscipleVendToOffer[_discipleId];
1164         require(bidder != address(0) && offer > 0);
1165         msg.sender.transfer(offer);
1166         DiscipleSaleToBuyer[_discipleId] = bidder;
1167         DiscipleVendToBidder[_discipleId] = address(0);
1168         DiscipleVendToOffer[_discipleId] = 0;
1169         emit DiscipleVendAccept(_discipleId, bidder, offer);
1170     }
1171     
1172     function setDiscipleVend(uint _num, uint _price) public onlyAdmin {
1173         DiscipleVending[_num] = _price;
1174         emit SetDiscipleVend(_num, _price);
1175     }
1176     
1177     function getDiscipleVend(uint _discipleId) public view returns (
1178         address owner,
1179         address bidder,
1180         uint offer
1181     ) {
1182         owner = DiscipleSaleToBuyer[_discipleId];
1183         bidder = DiscipleVendToBidder[_discipleId];
1184         offer = DiscipleVendToOffer[_discipleId];
1185     }
1186 }
1187 
1188 contract PreSaleAssets is PreSaleDisciple {
1189     // ----------------------------------------------------------------------------
1190     // Events
1191     // ----------------------------------------------------------------------------
1192     event BuyDiscipleItem(address indexed buyer, uint indexed rarity, uint indexed number, uint currentPrice);
1193     event BuyGuardianRune(address indexed buyer, uint indexed rarity, uint indexed number, uint currentPrice);
1194     
1195     event SetDiscipleItem(uint indexed rarity, uint indexed price);
1196     event SetGuardianRune(uint indexed rarity, uint indexed price);
1197     
1198     // ----------------------------------------------------------------------------
1199     // Mappings
1200     // ----------------------------------------------------------------------------
1201     mapping (address => uint) PlayerOwnRareItem;
1202     mapping (address => uint) PlayerOwnEpicItem;
1203     mapping (address => uint) PlayerOwnLegendaryItem;
1204     mapping (address => uint) PlayerOwnUniqueItem;
1205     
1206     mapping (address => uint) PlayerOwnRareRune;
1207     mapping (address => uint) PlayerOwnEpicRune;
1208     mapping (address => uint) PlayerOwnLegendaryRune;
1209     mapping (address => uint) PlayerOwnUniqueRune;
1210     
1211     // ----------------------------------------------------------------------------
1212     // Variables
1213     // ----------------------------------------------------------------------------
1214     uint[4] public DiscipleItem = [
1215         0.1 ether,
1216         0.88 ether,
1217         2.88 ether,
1218         9.98 ether
1219     ];
1220     
1221     uint[4] public GuardianRune = [
1222         0.18 ether,
1223         1.18 ether,
1224         3.88 ether,
1225         10.88 ether
1226     ];
1227     
1228     uint itemTimeStamp;
1229     uint runeTimeStamp;
1230     // ----------------------------------------------------------------------------
1231     // Modifier
1232     // ----------------------------------------------------------------------------
1233     
1234     // ----------------------------------------------------------------------------
1235     // Internal Function
1236     // ----------------------------------------------------------------------------
1237     
1238     // ----------------------------------------------------------------------------
1239     // Public Function
1240     // ----------------------------------------------------------------------------
1241     function buyDiscipleItem(uint _rarity, uint _num, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
1242         require(_rarity >= 0 && _rarity <= 3);
1243         uint currentPrice;
1244         if(pricePause == true) {
1245             if(itemTimeStamp != 0 && itemTimeStamp != endTime) {
1246                 uint timePass = safeSub(endTime, startTime);
1247                 DiscipleItem[0] = _computePrice(DiscipleItem[0], DiscipleItem[0]*raiseIndex[2], preSaleDurance, timePass);
1248                 DiscipleItem[1] = _computePrice(DiscipleItem[1], DiscipleItem[1]*raiseIndex[2], preSaleDurance, timePass);
1249                 DiscipleItem[2] = _computePrice(DiscipleItem[2], DiscipleItem[2]*raiseIndex[2], preSaleDurance, timePass);
1250                 DiscipleItem[3] = _computePrice(DiscipleItem[3], DiscipleItem[3]*raiseIndex[2], preSaleDurance, timePass);
1251                 itemTimeStamp = endTime;
1252             }
1253             require(msg.value >= DiscipleItem[_rarity]*_num);
1254             currentPrice = DiscipleItem[_rarity]*_num;
1255             _brokerFeeDistribute(currentPrice, 2, _brokerId, _subBrokerId);
1256         } else {
1257             if(itemTimeStamp == 0) {
1258                 itemTimeStamp = uint(now);
1259             }
1260             currentPrice = _computePrice(DiscipleItem[_rarity], DiscipleItem[_rarity]*raiseIndex[2], preSaleDurance, safeSub(uint(now), startTime));
1261             require(msg.value >= currentPrice*_num);
1262             currentPrice = currentPrice*_num;
1263             _brokerFeeDistribute(currentPrice, 2, _brokerId, _subBrokerId);
1264         }
1265         if(_rarity == 0) {
1266             PlayerOwnRareItem[msg.sender] = safeAdd(PlayerOwnRareItem[msg.sender], _num);
1267         } else if (_rarity == 1) {
1268             PlayerOwnEpicItem[msg.sender] = safeAdd(PlayerOwnEpicItem[msg.sender], _num);
1269         } else if (_rarity == 2) {
1270             PlayerOwnLegendaryItem[msg.sender] = safeAdd(PlayerOwnLegendaryItem[msg.sender], _num);
1271         } else if (_rarity == 3) {
1272             PlayerOwnUniqueItem[msg.sender] = safeAdd(PlayerOwnUniqueItem[msg.sender], _num);
1273         }
1274         emit BuyDiscipleItem(msg.sender, _rarity, _num, currentPrice);
1275     }   
1276     
1277     function buyGuardianRune(uint _rarity, uint _num, uint _brokerId, uint _subBrokerId) public payable whenNotPaused {
1278         require(_rarity >= 0 && _rarity <= 3);
1279         uint currentPrice;
1280         if(pricePause == true) {
1281             if(runeTimeStamp != 0 && runeTimeStamp != endTime) {
1282                 uint timePass = safeSub(endTime, startTime);
1283                 GuardianRune[0] = _computePrice(GuardianRune[0], GuardianRune[0]*raiseIndex[2], preSaleDurance, timePass);
1284                 GuardianRune[1] = _computePrice(GuardianRune[1], GuardianRune[1]*raiseIndex[2], preSaleDurance, timePass);
1285                 GuardianRune[2] = _computePrice(GuardianRune[2], GuardianRune[2]*raiseIndex[2], preSaleDurance, timePass);
1286                 GuardianRune[3] = _computePrice(GuardianRune[3], GuardianRune[3]*raiseIndex[2], preSaleDurance, timePass);
1287                 runeTimeStamp = endTime;
1288             }
1289             require(msg.value >= GuardianRune[_rarity]*_num);
1290             currentPrice = GuardianRune[_rarity]*_num;
1291             _brokerFeeDistribute(currentPrice, 2, _brokerId, _subBrokerId);
1292         } else {
1293             if(runeTimeStamp == 0) {
1294                 runeTimeStamp = uint(now);
1295             }
1296             currentPrice = _computePrice(GuardianRune[_rarity], GuardianRune[_rarity]*raiseIndex[2], preSaleDurance, safeSub(uint(now), startTime));
1297             require(msg.value >= currentPrice*_num);
1298             currentPrice = currentPrice*_num;
1299             _brokerFeeDistribute(currentPrice, 2, _brokerId, _subBrokerId);
1300         }
1301         if(_rarity == 0) {
1302             PlayerOwnRareRune[msg.sender] = safeAdd(PlayerOwnRareRune[msg.sender], _num);
1303         } else if (_rarity == 1) {
1304             PlayerOwnEpicRune[msg.sender] = safeAdd(PlayerOwnEpicRune[msg.sender], _num);
1305         } else if (_rarity == 2) {
1306             PlayerOwnLegendaryRune[msg.sender] = safeAdd(PlayerOwnLegendaryRune[msg.sender], _num);
1307         } else if (_rarity == 3) {
1308             PlayerOwnUniqueRune[msg.sender] = safeAdd(PlayerOwnUniqueRune[msg.sender], _num);
1309         }
1310         emit BuyGuardianRune(msg.sender, _rarity, _num, currentPrice);
1311     }
1312     
1313     function setDiscipleItem(uint _rarity, uint _price) public onlyAdmin {
1314         DiscipleItem[_rarity] = _price;
1315         emit SetDiscipleItem(_rarity, _price);
1316     }
1317     
1318     function setGuardianRune(uint _rarity, uint _price) public onlyAdmin {
1319         GuardianRune[_rarity] = _price;
1320         emit SetDiscipleItem(_rarity, _price);
1321     }
1322     
1323     function getPlayerInventory(address _player) public view returns (
1324         uint rareItem,
1325         uint epicItem,
1326         uint legendaryItem,
1327         uint uniqueItem,
1328         uint rareRune,
1329         uint epicRune,
1330         uint legendaryRune,
1331         uint uniqueRune
1332     ) {
1333         rareItem = PlayerOwnRareItem[_player];
1334         epicItem = PlayerOwnEpicItem[_player];
1335         legendaryItem = PlayerOwnLegendaryItem[_player];
1336         uniqueItem = PlayerOwnUniqueItem[_player];
1337         rareRune = PlayerOwnRareRune[_player];
1338         epicRune = PlayerOwnEpicRune[_player];
1339         legendaryRune = PlayerOwnLegendaryRune[_player];
1340         uniqueRune = PlayerOwnUniqueRune[_player];
1341     }
1342 }
1343 
1344 contract PreSale is PreSaleAssets {
1345     constructor() public {
1346         CEOAddress = msg.sender;
1347         BrokerIdToBrokers[0].push(msg.sender);
1348     }
1349 }