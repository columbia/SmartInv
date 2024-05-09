1 pragma solidity 0.4.21;
2 
3 library SafeMath {
4     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5         if (a == 0) {
6             return 0;
7         }
8         uint256 c = a * b;
9         assert(c / a == b);
10         return c;
11     }
12 
13     function div(uint256 a, uint256 b) internal pure returns (uint256) {
14         // assert(b > 0); // Solidity automatically throws when dividing by 0
15         uint256 c = a / b;
16         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17         return c;
18     }
19 
20     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21         assert(b <= a);
22         return a - b;
23     }
24 
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 contract UnicornManagementInterface {
33 
34     function ownerAddress() external view returns (address);
35     function managerAddress() external view returns (address);
36     function communityAddress() external view returns (address);
37     function dividendManagerAddress() external view returns (address);
38     function walletAddress() external view returns (address);
39     function blackBoxAddress() external view returns (address);
40     function unicornBreedingAddress() external view returns (address);
41     function geneLabAddress() external view returns (address);
42     function unicornTokenAddress() external view returns (address);
43     function candyToken() external view returns (address);
44     function candyPowerToken() external view returns (address);
45 
46     function createDividendPercent() external view returns (uint);
47     function sellDividendPercent() external view returns (uint);
48     function subFreezingPrice() external view returns (uint);
49     function subFreezingTime() external view returns (uint64);
50     function subTourFreezingPrice() external view returns (uint);
51     function subTourFreezingTime() external view returns (uint64);
52     function createUnicornPrice() external view returns (uint);
53     function createUnicornPriceInCandy() external view returns (uint);
54     function oraclizeFee() external view returns (uint);
55 
56     function paused() external view returns (bool);
57     function locked() external view returns (bool);
58 
59     function isTournament(address _tournamentAddress) external view returns (bool);
60 
61     function getCreateUnicornFullPrice() external view returns (uint);
62     function getHybridizationFullPrice(uint _price) external view returns (uint);
63     function getSellUnicornFullPrice(uint _price) external view returns (uint);
64     function getCreateUnicornFullPriceInCandy() external view returns (uint);
65 
66 
67     //service
68     function registerInit(address _contract) external;
69 
70 }
71 
72 contract UnicornAccessControl {
73 
74     UnicornManagementInterface public unicornManagement;
75 
76 
77     function UnicornAccessControl(address _unicornManagementAddress) public {
78         unicornManagement = UnicornManagementInterface(_unicornManagementAddress);
79         unicornManagement.registerInit(this);
80     }
81 
82     modifier onlyOwner() {
83         require(msg.sender == unicornManagement.ownerAddress());
84         _;
85     }
86 
87     modifier onlyManager() {
88         require(msg.sender == unicornManagement.managerAddress());
89         _;
90     }
91 
92     modifier onlyCommunity() {
93         require(msg.sender == unicornManagement.communityAddress());
94         _;
95     }
96 
97     modifier onlyTournament() {
98         require(unicornManagement.isTournament(msg.sender));
99         _;
100     }
101 
102     modifier whenNotPaused() {
103         require(!unicornManagement.paused());
104         _;
105     }
106 
107     modifier whenPaused {
108         require(unicornManagement.paused());
109         _;
110     }
111 
112 //    modifier whenUnlocked() {
113 //        require(!unicornManagement.locked());
114 //        _;
115 //    }
116 
117     modifier onlyManagement() {
118         require(msg.sender == address(unicornManagement));
119         _;
120     }
121 
122     modifier onlyBreeding() {
123         require(msg.sender == unicornManagement.unicornBreedingAddress());
124         _;
125     }
126 
127     modifier onlyUnicornContract() {
128         require(msg.sender == unicornManagement.unicornBreedingAddress() || unicornManagement.isTournament(msg.sender));
129         _;
130     }
131 
132     modifier onlyGeneLab() {
133         require(msg.sender == unicornManagement.geneLabAddress());
134         _;
135     }
136 
137     modifier onlyBlackBox() {
138         require(msg.sender == unicornManagement.blackBoxAddress());
139         _;
140     }
141 
142     modifier onlyUnicornToken() {
143         require(msg.sender == unicornManagement.unicornTokenAddress());
144         _;
145     }
146 
147     function isGamePaused() external view returns (bool) {
148         return unicornManagement.paused();
149     }
150 }
151 
152 contract DividendManagerInterface {
153     function payDividend() external payable;
154 }
155 
156 contract UnicornTokenInterface {
157 
158     //ERC721
159     function balanceOf(address _owner) public view returns (uint256 _balance);
160     function ownerOf(uint256 _unicornId) public view returns (address _owner);
161     function transfer(address _to, uint256 _unicornId) public;
162     function approve(address _to, uint256 _unicornId) public;
163     function takeOwnership(uint256 _unicornId) public;
164     function totalSupply() public constant returns (uint);
165     function owns(address _claimant, uint256 _unicornId) public view returns (bool);
166     function allowance(address _claimant, uint256 _unicornId) public view returns (bool);
167     function transferFrom(address _from, address _to, uint256 _unicornId) public;
168     function createUnicorn(address _owner) external returns (uint);
169     //    function burnUnicorn(uint256 _unicornId) external;
170     function getGen(uint _unicornId) external view returns (bytes);
171     function setGene(uint _unicornId, bytes _gene) external;
172     function updateGene(uint _unicornId, bytes _gene) external;
173     function getUnicornGenByte(uint _unicornId, uint _byteNo) external view returns (uint8);
174 
175     function setName(uint256 _unicornId, string _name ) external returns (bool);
176     function plusFreezingTime(uint _unicornId) external;
177     function plusTourFreezingTime(uint _unicornId) external;
178     function minusFreezingTime(uint _unicornId, uint64 _time) external;
179     function minusTourFreezingTime(uint _unicornId, uint64 _time) external;
180     function isUnfreezed(uint _unicornId) external view returns (bool);
181     function isTourUnfreezed(uint _unicornId) external view returns (bool);
182 
183     function marketTransfer(address _from, address _to, uint256 _unicornId) external;
184 }
185 
186 
187 interface UnicornBalancesInterface {
188     //    function tokenPlus(address _token, address _user, uint _value) external returns (bool);
189     //    function tokenMinus(address _token, address _user, uint _value) external returns (bool);
190     function trustedTokens(address _token) external view returns (bool);
191     //    function balanceOf(address token, address user) external view returns (uint);
192     function transfer(address _token, address _from, address _to, uint _value) external returns (bool);
193     function transferWithFee(address _token, address _userFrom, uint _fullPrice, address _feeTaker, address _priceTaker, uint _price) external returns (bool);
194 }
195 
196 contract ERC20 {
197     //    uint256 public totalSupply;
198     function balanceOf(address who) public view returns (uint256);
199     function transfer(address to, uint256 value) public returns (bool);
200     function allowance(address owner, address spender) public view returns (uint256);
201     function transferFrom(address from, address to, uint256 value) public returns (bool);
202     function approve(address spender, uint256 value) public returns (bool);
203 }
204 
205 contract TrustedTokenInterface is ERC20 {
206     function transferFromSystem(address _from, address _to, uint256 _value) public returns (bool);
207     function burn(address _from, uint256 _value) public returns (bool);
208     function mint(address _to, uint256 _amount) public returns (bool);
209 }
210 
211 
212 // contract UnicornBreedingInterface {
213 //     function deleteOffer(uint _unicornId) external;
214 //     function deleteHybridization(uint _unicornId) external;
215 // }
216 
217 contract BlackBoxInterface {
218     function createGen0(uint _unicornId) public payable;
219     function geneCore(uint _childUnicornId, uint _parent1UnicornId, uint _parent2UnicornId) public payable;
220 }
221 
222 
223 interface BreedingDataBaseInterface {
224 
225     function gen0Limit() external view returns (uint);
226     function gen0Count() external view returns (uint);
227     function gen0Step() external view returns (uint);
228 
229     function gen0PresaleLimit() external view returns (uint);
230     function gen0PresaleCount() external view returns (uint);
231 
232     function incGen0Count() external;
233     function incGen0PresaleCount() external;
234     function incGen0Limit() external;
235 
236     function createHybridization(uint _unicornId, uint _price) external;
237     function hybridizationExists(uint _unicornId) external view returns (bool);
238     function hybridizationPrice(uint _unicornId) external view returns (uint);
239     function deleteHybridization(uint _unicornId) external returns (bool);
240 
241     function freezeIndex(uint _unicornId) external view returns (uint);
242     function freezeHybridizationsCount(uint _unicornId) external view returns (uint);
243     function freezeStatsSumHours(uint _unicornId) external view returns (uint);
244     function freezeEndTime(uint _unicornId) external view returns (uint);
245     function freezeMustCalculate(uint _unicornId) external view returns (bool);
246     function freezeExists(uint _unicornId) external view returns (bool);
247 
248     function createFreeze(uint _unicornId, uint _index) external;
249     function incFreezeHybridizationsCount(uint _unicornId) external;
250     function setFreezeHybridizationsCount(uint _unicornId, uint _count) external;
251 
252     function incFreezeIndex(uint _unicornId) external;
253     function setFreezeEndTime(uint _unicornId, uint _time) external;
254     function minusFreezeEndTime(uint _unicornId, uint _time) external;
255     function setFreezeMustCalculate(uint _unicornId, bool _mustCalculate) external;
256     function setStatsSumHours(uint _unicornId, uint _statsSumHours) external;
257 
258 
259     function offerExists(uint _unicornId) external view returns (bool);
260     function offerPriceEth(uint _unicornId) external view returns (uint);
261     function offerPriceCandy(uint _unicornId) external view returns (uint);
262 
263     function createOffer(uint _unicornId, uint _priceEth, uint _priceCandy) external;
264     function deleteOffer(uint _unicornId) external;
265 
266 }
267 
268 contract UnicornBreeding is UnicornAccessControl {
269     using SafeMath for uint;
270 
271     BlackBoxInterface public blackBox;
272     TrustedTokenInterface public megaCandyToken;
273     BreedingDataBaseInterface public breedingDB;
274     UnicornTokenInterface public unicornToken; //only on deploy
275     UnicornBalancesInterface public balances;
276 
277     address public candyTokenAddress;
278 
279     event HybridizationAdd(uint indexed unicornId, uint price);
280     event HybridizationAccept(uint indexed firstUnicornId, uint indexed secondUnicornId, uint newUnicornId, uint price);
281     event SelfHybridization(uint indexed firstUnicornId, uint indexed secondUnicornId, uint newUnicornId, uint price);
282     event HybridizationDelete(uint indexed unicornId);
283     event CreateUnicorn(address indexed owner, uint indexed unicornId, uint parent1, uint  parent2);
284     event NewGen0Limit(uint limit);
285     event NewGen0Step(uint step);
286 
287     event FreeHybridization(uint256 indexed unicornId);
288     event NewSelfHybridizationPrice(uint percentCandy);
289 
290     event UnicornFreezingTimeSet(uint indexed unicornId, uint time);
291     event MinusFreezingTime(uint indexed unicornId, uint count);
292 
293     uint public selfHybridizationPrice = 0;
294 
295     uint32[8] internal freezing = [
296     uint32(1 hours),    //1 hour
297     uint32(2 hours),    //2 - 4 hours
298     uint32(8 hours),    //8 - 12 hours
299     uint32(16 hours),   //16 - 24 hours
300     uint32(36 hours),   //36 - 48 hours
301     uint32(72 hours),   //72 - 96 hours
302     uint32(120 hours),  //120 - 144 hours
303     uint32(168 hours)   //168 hours
304     ];
305 
306     //count for random plus from 0 to ..
307     uint32[8] internal freezingPlusCount = [
308     0, 3, 5, 9, 13, 25, 25, 0
309     ];
310 
311 
312     function makeHybridization(uint _unicornId, uint _price) whenNotPaused public {
313         require(unicornToken.owns(msg.sender, _unicornId));
314         require(isUnfreezed(_unicornId));
315         require(!breedingDB.hybridizationExists(_unicornId));
316         require(unicornToken.getUnicornGenByte(_unicornId, 10) > 0);
317 
318         checkFreeze(_unicornId);
319         breedingDB.createHybridization(_unicornId, _price);
320         emit HybridizationAdd(_unicornId, _price);
321         //свободная касса)
322         if (_price == 0) {
323             emit FreeHybridization(_unicornId);
324         }
325     }
326 
327     function acceptHybridization(uint _firstUnicornId, uint _secondUnicornId) whenNotPaused public payable {
328         require(unicornToken.owns(msg.sender, _secondUnicornId));
329         require(_secondUnicornId != _firstUnicornId);
330         require(isUnfreezed(_firstUnicornId) && isUnfreezed(_secondUnicornId));
331         require(breedingDB.hybridizationExists(_firstUnicornId));
332 
333         require(unicornToken.getUnicornGenByte(_firstUnicornId, 10) > 0 && unicornToken.getUnicornGenByte(_secondUnicornId, 10) > 0);
334         require(msg.value == unicornManagement.oraclizeFee());
335 
336         uint price = breedingDB.hybridizationPrice(_firstUnicornId);
337 
338         if (price > 0) {
339             uint fullPrice = unicornManagement.getHybridizationFullPrice(price);
340 
341             require(balances.transferWithFee(candyTokenAddress, msg.sender, fullPrice, balances, unicornToken.ownerOf(_firstUnicornId), price));
342 
343         }
344 
345         plusFreezingTime(_firstUnicornId);
346         plusFreezingTime(_secondUnicornId);
347         uint256 newUnicornId = unicornToken.createUnicorn(msg.sender);
348         blackBox.geneCore.value(unicornManagement.oraclizeFee())(newUnicornId, _firstUnicornId, _secondUnicornId);
349 
350         emit HybridizationAccept(_firstUnicornId, _secondUnicornId, newUnicornId, price);
351         emit CreateUnicorn(msg.sender, newUnicornId, _firstUnicornId, _secondUnicornId);
352         _deleteHybridization(_firstUnicornId);
353     }
354 
355     function selfHybridization(uint _firstUnicornId, uint _secondUnicornId) whenNotPaused public payable {
356         require(unicornToken.owns(msg.sender, _firstUnicornId) && unicornToken.owns(msg.sender, _secondUnicornId));
357         require(_secondUnicornId != _firstUnicornId);
358         require(isUnfreezed(_firstUnicornId) && isUnfreezed(_secondUnicornId));
359         require(unicornToken.getUnicornGenByte(_firstUnicornId, 10) > 0 && unicornToken.getUnicornGenByte(_secondUnicornId, 10) > 0);
360 
361         require(msg.value == unicornManagement.oraclizeFee());
362 
363         if (selfHybridizationPrice > 0) {
364             //            require(balances.balanceOf(candyTokenAddress,msg.sender) >= selfHybridizationPrice);
365             require(balances.transfer(candyTokenAddress, msg.sender, balances, selfHybridizationPrice));
366         }
367 
368         plusFreezingTime(_firstUnicornId);
369         plusFreezingTime(_secondUnicornId);
370         uint256 newUnicornId = unicornToken.createUnicorn(msg.sender);
371         blackBox.geneCore.value(unicornManagement.oraclizeFee())(newUnicornId, _firstUnicornId, _secondUnicornId);
372         emit SelfHybridization(_firstUnicornId, _secondUnicornId, newUnicornId, selfHybridizationPrice);
373         emit CreateUnicorn(msg.sender, newUnicornId, _firstUnicornId, _secondUnicornId);
374     }
375 
376     function cancelHybridization (uint _unicornId) whenNotPaused public {
377         require(unicornToken.owns(msg.sender,_unicornId));
378         //require(breedingDB.hybridizationExists(_unicornId));
379         _deleteHybridization(_unicornId);
380     }
381 
382     function deleteHybridization(uint _unicornId) onlyUnicornToken external {
383         _deleteHybridization(_unicornId);
384     }
385 
386     function _deleteHybridization(uint _unicornId) internal {
387         if (breedingDB.deleteHybridization(_unicornId)) {
388             emit HybridizationDelete(_unicornId);
389         }
390     }
391 
392     //Create new 0 gen
393     function createUnicorn() public payable whenNotPaused returns(uint256)   {
394         require(msg.value == getCreateUnicornPrice());
395         return _createUnicorn(msg.sender);
396     }
397 
398     function createUnicornForCandy() public payable whenNotPaused returns(uint256)   {
399         require(msg.value == unicornManagement.oraclizeFee());
400         uint price = getCreateUnicornPriceInCandy();
401         //        require(balances.balanceOf(candyTokenAddress,msg.sender) >= price);
402         require(balances.transfer(candyTokenAddress, msg.sender, balances, price));
403         return _createUnicorn(msg.sender);
404     }
405 
406     function createPresaleUnicorns(uint _count, address _owner) public payable onlyManager whenPaused returns(bool) {
407         require(breedingDB.gen0PresaleCount().add(_count) <= breedingDB.gen0PresaleLimit());
408         uint256 newUnicornId;
409         address owner = _owner == address(0) ? msg.sender : _owner;
410         for (uint i = 0; i < _count; i++){
411             newUnicornId = unicornToken.createUnicorn(owner);
412             blackBox.createGen0(newUnicornId);
413             emit CreateUnicorn(owner, newUnicornId, 0, 0);
414             breedingDB.incGen0Count();
415             breedingDB.incGen0PresaleCount();
416         }
417         return true;
418     }
419 
420     function _createUnicorn(address _owner) private returns(uint256) {
421         require(breedingDB.gen0Count() < breedingDB.gen0Limit());
422         uint256 newUnicornId = unicornToken.createUnicorn(_owner);
423         blackBox.createGen0.value(unicornManagement.oraclizeFee())(newUnicornId);
424         emit CreateUnicorn(_owner, newUnicornId, 0, 0);
425         breedingDB.incGen0Count();
426         return newUnicornId;
427     }
428 
429     function plusFreezingTime(uint _unicornId) private {
430         checkFreeze(_unicornId);
431         //если меньше 3 спарок увеличиваю просто спарки, если 3 тогда увеличиваю индекс
432         if (breedingDB.freezeHybridizationsCount(_unicornId) < 3) {
433             breedingDB.incFreezeHybridizationsCount(_unicornId);
434         } else {
435             if (breedingDB.freezeIndex(_unicornId) < freezing.length - 1) {
436                 breedingDB.incFreezeIndex(_unicornId);
437                 breedingDB.setFreezeHybridizationsCount(_unicornId,0);
438             }
439         }
440 
441         uint _time = _getFreezeTime(breedingDB.freezeIndex(_unicornId)) + now;
442         breedingDB.setFreezeEndTime(_unicornId, _time);
443         emit UnicornFreezingTimeSet(_unicornId, _time);
444     }
445 
446     function checkFreeze(uint _unicornId) internal {
447         if (!breedingDB.freezeExists(_unicornId)) {
448             breedingDB.createFreeze(_unicornId, unicornToken.getUnicornGenByte(_unicornId, 163));
449         }
450         if (breedingDB.freezeMustCalculate(_unicornId)) {
451             breedingDB.setFreezeMustCalculate(_unicornId, false);
452             breedingDB.setStatsSumHours(_unicornId, _getStatsSumHours(_unicornId));
453         }
454     }
455 
456     function _getRarity(uint8 _b) internal pure returns (uint8) {
457         //        [1; 188] common
458         //        [189; 223] uncommon
459         //        [224; 243] rare
460         //        [244; 253] epic
461         //        [254; 255] legendary
462         return _b < 1 ? 0 : _b < 189 ? 1 : _b < 224 ? 2 : _b < 244 ? 3 : _b < 254 ? 4 : 5;
463     }
464 
465     function _getStatsSumHours(uint _unicornId) internal view returns (uint) {
466         uint8[5] memory physStatBytes = [
467         //physical
468         112, //strength
469         117, //agility
470         122, //speed
471         127, //intellect
472         132 //charisma
473         ];
474         uint8[10] memory rarity1Bytes = [
475         //rarity old
476         13, //body-form
477         18, //wings-form
478         23, //hoofs-form
479         28, //horn-form
480         33, //eyes-form
481         38, //hair-form
482         43, //tail-form
483         48, //stone-form
484         53, //ears-form
485         58 //head-form
486         ];
487         uint8[10] memory rarity2Bytes = [
488         //rarity new
489         87, //body-form
490         92, //wings-form
491         97, //hoofs-form
492         102, //horn-form
493         107, //eyes-form
494         137, //hair-form
495         142, //tail-form
496         147, //stone-form
497         152, //ears-form
498         157 //head-form
499         ];
500 
501         uint sum = 0;
502         uint i;
503         for(i = 0; i < 5; i++) {
504             sum += unicornToken.getUnicornGenByte(_unicornId, physStatBytes[i]);
505         }
506 
507         for(i = 0; i < 10; i++) {
508             //get v.2 rarity
509             uint rarity = unicornToken.getUnicornGenByte(_unicornId, rarity2Bytes[i]);
510             if (rarity == 0) {
511                 //get v.1 rarity
512                 rarity = _getRarity(unicornToken.getUnicornGenByte(_unicornId, rarity1Bytes[i]));
513             }
514             sum += rarity;
515         }
516         return sum * 1 hours;
517     }
518 
519     function isUnfreezed(uint _unicornId) public view returns (bool) {
520         return unicornToken.isUnfreezed(_unicornId) && breedingDB.freezeEndTime(_unicornId) <= now;
521     }
522 
523     function enableFreezePriceRateRecalc(uint _unicornId) onlyGeneLab external {
524         breedingDB.setFreezeMustCalculate(_unicornId, true);
525     }
526 
527     /*
528        (сумма генов + количество часов заморозки)/количество часов заморозки = стоимость снятия 1го часа заморозки в MegaCandy
529     */
530     function getUnfreezingPrice(uint _unicornId) public view returns (uint) {
531         uint32 freezeHours = freezing[breedingDB.freezeIndex(_unicornId)];
532         return unicornManagement.subFreezingPrice()
533         .mul(breedingDB.freezeStatsSumHours(_unicornId).add(freezeHours))
534         .div(freezeHours);
535     }
536 
537     function _getFreezeTime(uint freezingIndex) internal view returns (uint time) {
538         time = freezing[freezingIndex];
539         if (freezingPlusCount[freezingIndex] != 0) {
540             time += (uint(block.blockhash(block.number - 1)) % freezingPlusCount[freezingIndex]) * 1 hours;
541         }
542     }
543 
544     //change freezing time for megacandy
545     function minusFreezingTime(uint _unicornId, uint _count) public {
546         uint price = getUnfreezingPrice(_unicornId);
547         require(megaCandyToken.burn(msg.sender, price.mul(_count)));
548         //не минусуем на уже размороженных конях
549         require(breedingDB.freezeEndTime(_unicornId) > now);
550         //не используем safeMath, т.к. subFreezingTime в теории не должен быть больше now %)
551         breedingDB.minusFreezeEndTime(_unicornId, uint(unicornManagement.subFreezingTime()).mul(_count));
552         emit MinusFreezingTime(_unicornId,_count);
553     }
554 
555     function getHybridizationPrice(uint _unicornId) public view returns (uint) {
556         return unicornManagement.getHybridizationFullPrice(breedingDB.hybridizationPrice(_unicornId));
557     }
558 
559     function getEtherFeeForPriceInCandy() public view returns (uint) {
560         return unicornManagement.oraclizeFee();
561     }
562 
563     function getCreateUnicornPriceInCandy() public view returns (uint) {
564         return unicornManagement.getCreateUnicornFullPriceInCandy();
565     }
566 
567     function getCreateUnicornPrice() public view returns (uint) {
568         return unicornManagement.getCreateUnicornFullPrice();
569     }
570 
571     function setGen0Limit() external onlyCommunity {
572         require(breedingDB.gen0Count() == breedingDB.gen0Limit());
573         breedingDB.incGen0Limit();
574         emit NewGen0Limit(breedingDB.gen0Limit());
575     }
576 
577     function setSelfHybridizationPrice(uint _percentCandy) public onlyManager {
578         selfHybridizationPrice = _percentCandy;
579         emit NewSelfHybridizationPrice(_percentCandy);
580     }
581 
582 }
583 
584 
585 contract UnicornMarket is UnicornBreeding {
586     uint public sellDividendPercentCandy = 375; //OnlyManager 4 digits. 10.5% = 1050
587     uint public sellDividendPercentEth = 375; //OnlyManager 4 digits. 10.5% = 1050
588 
589     event NewSellDividendPercent(uint percentCandy, uint percentCandyEth);
590     event OfferAdd(uint256 indexed unicornId, uint priceEth, uint priceCandy);
591     event OfferDelete(uint256 indexed unicornId);
592     event UnicornSold(uint256 indexed unicornId, uint priceEth, uint priceCandy);
593     event FreeOffer(uint256 indexed unicornId);
594 
595 
596     function sellUnicorn(uint _unicornId, uint _priceEth, uint _priceCandy) whenNotPaused public {
597         require(unicornToken.owns(msg.sender, _unicornId));
598         require(!breedingDB.offerExists(_unicornId));
599 
600         breedingDB.createOffer(_unicornId, _priceEth, _priceCandy);
601 
602         emit OfferAdd(_unicornId, _priceEth, _priceCandy);
603         //налетай)
604         if (_priceEth == 0 && _priceCandy == 0) {
605             emit FreeOffer(_unicornId);
606         }
607     }
608 
609     function buyUnicornWithEth(uint _unicornId) whenNotPaused public payable {
610         require(breedingDB.offerExists(_unicornId));
611         uint price = breedingDB.offerPriceEth(_unicornId);
612         //Выставлять на продажу за 0 можно. Но нужно проверить чтобы и вторая цена также была 0
613         if (price == 0) {
614             require(breedingDB.offerPriceCandy(_unicornId) == 0);
615         }
616         require(msg.value == getOfferPriceEth(_unicornId));
617 
618         address owner = unicornToken.ownerOf(_unicornId);
619 
620         emit UnicornSold(_unicornId, price, 0);
621         //deleteoffer вызовется внутри transfer
622         unicornToken.marketTransfer(owner, msg.sender, _unicornId);
623         owner.transfer(price);
624     }
625 
626     function buyUnicornWithCandy(uint _unicornId) whenNotPaused public {
627         require(breedingDB.offerExists(_unicornId));
628         uint price = breedingDB.offerPriceCandy(_unicornId);
629         //Выставлять на продажу за 0 можно. Но нужно проверить чтобы и вторая цена также была 0
630         if (price == 0) {
631             require(breedingDB.offerPriceEth(_unicornId) == 0);
632         }
633 
634         address owner = unicornToken.ownerOf(_unicornId);
635 
636         if (price > 0) {
637             uint fullPrice = getOfferPriceCandy(_unicornId);
638             require(balances.transferWithFee(candyTokenAddress, msg.sender, fullPrice, balances, owner, price));
639         }
640 
641         emit UnicornSold(_unicornId, 0, price);
642         //deleteoffer вызовется внутри transfer
643         unicornToken.marketTransfer(owner, msg.sender, _unicornId);
644     }
645 
646 
647     function revokeUnicorn(uint _unicornId) whenNotPaused public {
648         require(unicornToken.owns(msg.sender, _unicornId));
649         //require(breedingDB.offerExists(_unicornId));
650         _deleteOffer(_unicornId);
651     }
652 
653 
654     function deleteOffer(uint _unicornId) onlyUnicornToken external {
655         _deleteOffer(_unicornId);
656     }
657 
658 
659     function _deleteOffer(uint _unicornId) internal {
660         if (breedingDB.offerExists(_unicornId)) {
661             breedingDB.deleteOffer(_unicornId);
662             emit OfferDelete(_unicornId);
663         }
664     }
665 
666 
667     function getOfferPriceEth(uint _unicornId) public view returns (uint) {
668         uint priceEth = breedingDB.offerPriceEth(_unicornId);
669         return priceEth.add(valueFromPercent(priceEth, sellDividendPercentEth));
670     }
671 
672 
673     function getOfferPriceCandy(uint _unicornId) public view returns (uint) {
674         uint priceCandy = breedingDB.offerPriceCandy(_unicornId);
675         return priceCandy.add(valueFromPercent(priceCandy, sellDividendPercentCandy));
676     }
677 
678 
679     function setSellDividendPercent(uint _percentCandy, uint _percentEth) public onlyManager {
680         //no more then 25%
681         require(_percentCandy < 2500 && _percentEth < 2500);
682 
683         sellDividendPercentCandy = _percentCandy;
684         sellDividendPercentEth = _percentEth;
685         emit NewSellDividendPercent(_percentCandy, _percentEth);
686     }
687 
688 
689     //1% - 100, 10% - 1000 50% - 5000
690     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
691         uint _amount = _value.mul(_percent).div(10000);
692         return (_amount);
693     }
694 }
695 
696 
697 contract UnicornCoinMarket is UnicornMarket {
698     uint public feeTake = 5000000000000000; // 0.5% percentage times (1 ether)
699     mapping (address => mapping (bytes32 => uint)) public orderFills; // mapping of user accounts to mapping of order hashes to uints (amount of order that has been filled)
700     mapping (address => bool) public tokensWithoutFee;
701 
702     /// Logging Events
703     event Trade(bytes32 indexed hash, address tokenGet, uint amountGet, address tokenGive, uint amountGive, address get, address give);
704 
705 
706     /// Changes the fee on takes.
707     function changeFeeTake(uint feeTake_) external onlyOwner {
708         feeTake = feeTake_;
709     }
710 
711 
712     function setTokenWithoutFee(address _token, bool _takeFee) external onlyOwner {
713         tokensWithoutFee[_token] = _takeFee;
714     }
715 
716 
717     ////////////////////////////////////////////////////////////////////////////////
718     // Trading
719     ////////////////////////////////////////////////////////////////////////////////
720 
721     /**
722     * Facilitates a trade from one user to another.
723     * Requires that the transaction is signed properly, the trade isn't past its expiration, and all funds are present to fill the trade.
724     * Calls tradeBalances().
725     * Updates orderFills with the amount traded.
726     * Emits a Trade event.
727     * Note: tokenGet & tokenGive can be the Ethereum contract address.
728     * Note: amount is in amountGet / tokenGet terms.
729     * @param tokenGet Ethereum contract address of the token to receive
730     * @param amountGet uint amount of tokens being received
731     * @param tokenGive Ethereum contract address of the token to give
732     * @param amountGive uint amount of tokens being given
733     * @param expires uint of block number when this order should expire
734     * @param nonce arbitrary random number
735     * @param user Ethereum address of the user who placed the order
736     * @param v part of signature for the order hash as signed by user
737     * @param r part of signature for the order hash as signed by user
738     * @param s part of signature for the order hash as signed by user
739     * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
740     */
741     function trade(address tokenGet, uint amountGet, address tokenGive, uint amountGive, uint expires, uint nonce, address user, uint8 v, bytes32 r, bytes32 s, uint amount) external {
742         bytes32 hash = sha256(balances, tokenGet, amountGet, tokenGive, amountGive, expires, nonce);
743         require(
744             ecrecover(keccak256(keccak256("bytes32 Order hash"), keccak256(hash)), v, r, s) == user &&
745             block.number <= expires &&
746             orderFills[user][hash].add(amount) <= amountGet
747         );
748         uint amount2 =  tradeBalances(tokenGet, amountGet, tokenGive, amountGive, user, amount);
749         orderFills[user][hash] = orderFills[user][hash].add(amount);
750         emit Trade(hash, tokenGet, amount, tokenGive, amount2, user, msg.sender);
751     }
752 
753     /**
754     * This is a private function and is only being called from trade().
755     * Handles the movement of funds when a trade occurs.
756     * Takes fees.
757     * Updates token balances for both buyer and seller.
758     * Note: tokenGet & tokenGive can be the Ethereum contract address.
759     * Note: amount is in amountGet / tokenGet terms.
760     * @param tokenGet Ethereum contract address of the token to receive
761     * @param amountGet uint amount of tokens being received
762     * @param tokenGive Ethereum contract address of the token to give
763     * @param amountGive uint amount of tokens being given
764     * @param user Ethereum address of the user who placed the order
765     * @param amount uint amount in terms of tokenGet that will be "buy" in the trade
766     */
767     function tradeBalances(address tokenGet, uint amountGet, address tokenGive, uint amountGive, address user, uint amount) private returns(uint amount2){
768 
769         uint _fee = 0;
770 
771         if (!tokensWithoutFee[tokenGet]) {
772             _fee = amount.mul(feeTake).div(1 ether);
773         }
774 
775 
776         if (balances.trustedTokens(tokenGet)) {
777             TrustedTokenInterface t = TrustedTokenInterface(tokenGet);
778             require(t.transferFromSystem(msg.sender, user, amount));
779             require(t.transferFromSystem(msg.sender, this, _fee));
780         } else {
781             require(
782                 balances.transferWithFee(tokenGet, msg.sender, amount, balances, user, amount.sub(_fee))
783             );
784             //            balances.tokenMinus(tokenGet, msg.sender, amount);
785             //            balances.tokenPlus(tokenGet, user, amount.sub(_fee));
786             //            balances.tokenPlus(tokenGet, this, _fee);
787         }
788 
789         amount2 = amountGive.mul(amount).div(amountGet);
790         if (balances.trustedTokens(tokenGive)) {
791             require(TrustedTokenInterface(tokenGive).transferFromSystem(user, msg.sender, amount2));
792         } else {
793             require(balances.transfer(tokenGive, user, msg.sender, amount2));
794         }
795     }
796 }
797 
798 
799 contract UnicornContract is UnicornCoinMarket {
800     event FundsTransferred(address dividendManager, uint value);
801 
802     function() public payable {
803 
804     }
805 
806     function UnicornContract(address _breedingDB, address _balances, address _unicornManagementAddress) UnicornAccessControl(_unicornManagementAddress) public {
807         candyTokenAddress = unicornManagement.candyToken();
808         breedingDB = BreedingDataBaseInterface(_breedingDB);
809         balances = UnicornBalancesInterface(_balances);
810     }
811 
812     function init() onlyManagement whenPaused external {
813         unicornToken = UnicornTokenInterface(unicornManagement.unicornTokenAddress());
814         blackBox = BlackBoxInterface(unicornManagement.blackBoxAddress());
815         megaCandyToken = TrustedTokenInterface(unicornManagement.candyPowerToken());
816     }
817 
818 
819     function transferTokensToDividendManager(address _token) onlyManager public {
820         require(ERC20(_token).balanceOf(this) > 0);
821         ERC20(_token).transfer(unicornManagement.walletAddress(), ERC20(_token).balanceOf(this));
822     }
823 
824 
825     function transferEthersToDividendManager(uint _value) onlyManager public {
826         require(address(this).balance >= _value);
827         DividendManagerInterface dividendManager = DividendManagerInterface(unicornManagement.dividendManagerAddress());
828         dividendManager.payDividend.value(_value)();
829         emit FundsTransferred(unicornManagement.dividendManagerAddress(), _value);
830     }
831 }