1 pragma solidity ^0.4.21;
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
32 
33 
34 contract UnicornManagementInterface {
35 
36     function ownerAddress() external view returns (address);
37     function managerAddress() external view returns (address);
38     function communityAddress() external view returns (address);
39     function dividendManagerAddress() external view returns (address);
40     function walletAddress() external view returns (address);
41     function blackBoxAddress() external view returns (address);
42     function unicornBreedingAddress() external view returns (address);
43     function geneLabAddress() external view returns (address);
44     function unicornTokenAddress() external view returns (address);
45     function candyToken() external view returns (address);
46     function candyPowerToken() external view returns (address);
47 
48     function createDividendPercent() external view returns (uint);
49     function sellDividendPercent() external view returns (uint);
50     function subFreezingPrice() external view returns (uint);
51     function subFreezingTime() external view returns (uint64);
52     function subTourFreezingPrice() external view returns (uint);
53     function subTourFreezingTime() external view returns (uint64);
54     function createUnicornPrice() external view returns (uint);
55     function createUnicornPriceInCandy() external view returns (uint);
56     function oraclizeFee() external view returns (uint);
57 
58     function paused() external view returns (bool);
59     //    function locked() external view returns (bool);
60 
61     function isTournament(address _tournamentAddress) external view returns (bool);
62 
63     function getCreateUnicornFullPrice() external view returns (uint);
64     function getHybridizationFullPrice(uint _price) external view returns (uint);
65     function getSellUnicornFullPrice(uint _price) external view returns (uint);
66     function getCreateUnicornFullPriceInCandy() external view returns (uint);
67 
68 
69     //service
70     function registerInit(address _contract) external;
71 
72 }
73 
74 contract ERC20 {
75     function balanceOf(address who) public view returns (uint256);
76     function transfer(address to, uint256 value) public returns (bool);
77     function allowance(address owner, address spender) public view returns (uint256);
78     function transferFrom(address from, address to, uint256 value) public returns (bool);
79     function approve(address spender, uint256 value) public returns (bool);
80 }
81 
82 contract megaCandyInterface is ERC20 {
83     function transferFromSystem(address _from, address _to, uint256 _value) public returns (bool);
84     function burn(address _from, uint256 _value) public returns (bool);
85     function mint(address _to, uint256 _amount) public returns (bool);
86 }
87 
88 contract DividendManagerInterface {
89     function payDividend() external payable;
90 }
91 
92 contract BlackBoxInterface {
93     function createGen0(uint _unicornId) public payable;
94     function geneCore(uint _childUnicornId, uint _parent1UnicornId, uint _parent2UnicornId) public payable;
95 }
96 
97 contract UnicornTokenInterface {
98 
99     //ERC721
100     function balanceOf(address _owner) public view returns (uint256 _balance);
101     function ownerOf(uint256 _unicornId) public view returns (address _owner);
102     function transfer(address _to, uint256 _unicornId) public;
103     function approve(address _to, uint256 _unicornId) public;
104     function takeOwnership(uint256 _unicornId) public;
105     function totalSupply() public constant returns (uint);
106     function owns(address _claimant, uint256 _unicornId) public view returns (bool);
107     function allowance(address _claimant, uint256 _unicornId) public view returns (bool);
108     function transferFrom(address _from, address _to, uint256 _unicornId) public;
109 
110     //specific
111     function createUnicorn(address _owner) external returns (uint);
112     //    function burnUnicorn(uint256 _unicornId) external;
113     function getGen(uint _unicornId) external view returns (bytes);
114     function setGene(uint _unicornId, bytes _gene) external;
115     function updateGene(uint _unicornId, bytes _gene) external;
116     function getUnicornGenByte(uint _unicornId, uint _byteNo) external view returns (uint8);
117 
118     function setName(uint256 _unicornId, string _name ) external returns (bool);
119     function plusFreezingTime(uint _unicornId) external;
120     function plusTourFreezingTime(uint _unicornId) external;
121     function minusFreezingTime(uint _unicornId, uint64 _time) external;
122     function minusTourFreezingTime(uint _unicornId, uint64 _time) external;
123     function isUnfreezed(uint _unicornId) external view returns (bool);
124     function isTourUnfreezed(uint _unicornId) external view returns (bool);
125 
126     function marketTransfer(address _from, address _to, uint256 _unicornId) external;
127 }
128 
129 
130 
131 contract UnicornAccessControl {
132 
133     UnicornManagementInterface public unicornManagement;
134 
135     function UnicornAccessControl(address _unicornManagementAddress) public {
136         unicornManagement = UnicornManagementInterface(_unicornManagementAddress);
137         unicornManagement.registerInit(this);
138     }
139 
140     modifier onlyOwner() {
141         require(msg.sender == unicornManagement.ownerAddress());
142         _;
143     }
144 
145     modifier onlyManager() {
146         require(msg.sender == unicornManagement.managerAddress());
147         _;
148     }
149 
150     modifier onlyCommunity() {
151         require(msg.sender == unicornManagement.communityAddress());
152         _;
153     }
154 
155     modifier onlyTournament() {
156         require(unicornManagement.isTournament(msg.sender));
157         _;
158     }
159 
160     modifier whenNotPaused() {
161         require(!unicornManagement.paused());
162         _;
163     }
164 
165     modifier whenPaused {
166         require(unicornManagement.paused());
167         _;
168     }
169 
170 
171     modifier onlyManagement() {
172         require(msg.sender == address(unicornManagement));
173         _;
174     }
175 
176     modifier onlyBreeding() {
177         require(msg.sender == unicornManagement.unicornBreedingAddress());
178         _;
179     }
180 
181     modifier onlyGeneLab() {
182         require(msg.sender == unicornManagement.geneLabAddress());
183         _;
184     }
185 
186     modifier onlyBlackBox() {
187         require(msg.sender == unicornManagement.blackBoxAddress());
188         _;
189     }
190 
191     modifier onlyUnicornToken() {
192         require(msg.sender == unicornManagement.unicornTokenAddress());
193         _;
194     }
195 
196     function isGamePaused() external view returns (bool) {
197         return unicornManagement.paused();
198     }
199 }
200 
201 contract UnicornBreeding is UnicornAccessControl {
202     using SafeMath for uint;
203     //onlyOwner
204     UnicornTokenInterface public unicornToken; //only on deploy
205     BlackBoxInterface public blackBox;
206 
207     event HybridizationAdd(uint indexed unicornId, uint price);
208     event HybridizationAccept(uint indexed firstUnicornId, uint indexed secondUnicornId, uint newUnicornId);
209     event HybridizationDelete(uint indexed unicornId);
210     event FundsTransferred(address dividendManager, uint value);
211     event CreateUnicorn(address indexed owner, uint indexed unicornId, uint parent1, uint  parent2);
212     event NewGen0Limit(uint limit);
213     event NewGen0Step(uint step);
214 
215 
216     event OfferAdd(uint256 indexed unicornId, uint priceEth, uint priceCandy);
217     event OfferDelete(uint256 indexed unicornId);
218     event UnicornSold(uint256 indexed unicornId);
219 
220     event NewSellDividendPercent(uint percentCandy, uint percentCandyEth);
221 
222     ERC20 public candyToken;
223     megaCandyInterface public megaCandyToken;
224 
225     uint public sellDividendPercentCandy = 375; //OnlyManager 4 digits. 10.5% = 1050
226     uint public sellDividendPercentEth = 375; //OnlyManager 4 digits. 10.5% = 1050
227 
228     //counter for gen0
229     uint public gen0Limit = 30000;
230     uint public gen0Count = 1805;
231     uint public gen0Step = 1000;
232 
233     //counter for presale gen0
234     uint public gen0PresaleLimit = 1000;
235     uint public gen0PresaleCount = 0;
236 
237     struct Hybridization{
238         uint listIndex;
239         uint price;
240         //        uint second_unicorn_id;
241         //        bool accepted;
242         bool exists;
243     }
244 
245     // Mapping from unicorn ID to Hybridization struct
246     mapping (uint => Hybridization) public hybridizations;
247     mapping(uint => uint) public hybridizationList;
248     uint public hybridizationListSize = 0;
249 
250 
251     function() public payable {
252 
253     }
254 
255     function UnicornBreeding(address _unicornManagementAddress) UnicornAccessControl(_unicornManagementAddress) public {
256         candyToken = ERC20(unicornManagement.candyToken());
257 
258     }
259 
260     function init() onlyManagement whenPaused external {
261         unicornToken = UnicornTokenInterface(unicornManagement.unicornTokenAddress());
262         blackBox = BlackBoxInterface(unicornManagement.blackBoxAddress());
263         megaCandyToken = megaCandyInterface(unicornManagement.candyPowerToken());
264     }
265 
266     function makeHybridization(uint _unicornId, uint _price) public {
267         require(unicornToken.owns(msg.sender, _unicornId));
268         require(unicornToken.isUnfreezed(_unicornId));
269         require(!hybridizations[_unicornId].exists);
270 
271         hybridizations[_unicornId] = Hybridization({
272             price: _price,
273             exists: true,
274             listIndex: hybridizationListSize
275             });
276         hybridizationList[hybridizationListSize++] = _unicornId;
277 
278         emit HybridizationAdd(_unicornId, _price);
279     }
280 
281 
282     function acceptHybridization(uint _firstUnicornId, uint _secondUnicornId) whenNotPaused public payable {
283         require(unicornToken.owns(msg.sender, _secondUnicornId));
284         require(_secondUnicornId != _firstUnicornId);
285         require(unicornToken.isUnfreezed(_firstUnicornId) && unicornToken.isUnfreezed(_secondUnicornId));
286         require(hybridizations[_firstUnicornId].exists);
287         require(msg.value == unicornManagement.oraclizeFee());
288         if (hybridizations[_firstUnicornId].price > 0) {
289             require(candyToken.transferFrom(msg.sender, this, getHybridizationPrice(_firstUnicornId)));
290         }
291 
292         plusFreezingTime(_firstUnicornId);
293         plusFreezingTime(_secondUnicornId);
294         uint256 newUnicornId = unicornToken.createUnicorn(msg.sender);
295         //        BlackBoxInterface blackBox = BlackBoxInterface(unicornManagement.blackBoxAddress());
296         blackBox.geneCore.value(unicornManagement.oraclizeFee())(newUnicornId, _firstUnicornId, _secondUnicornId);
297         emit CreateUnicorn(msg.sender, newUnicornId, _firstUnicornId, _secondUnicornId);
298         if (hybridizations[_firstUnicornId].price > 0) {
299             candyToken.transfer(unicornToken.ownerOf(_firstUnicornId), hybridizations[_firstUnicornId].price);
300         }
301         emit HybridizationAccept(_firstUnicornId, _secondUnicornId, newUnicornId);
302         _deleteHybridization(_firstUnicornId);
303     }
304 
305 
306     function cancelHybridization (uint _unicornId) public {
307         require(unicornToken.owns(msg.sender,_unicornId));
308         require(hybridizations[_unicornId].exists);
309         _deleteHybridization(_unicornId);
310     }
311 
312     function deleteHybridization(uint _unicornId) onlyUnicornToken external {
313         _deleteHybridization(_unicornId);
314     }
315 
316     function _deleteHybridization(uint _unicornId) internal {
317         if (hybridizations[_unicornId].exists) {
318             hybridizations[hybridizationList[--hybridizationListSize]].listIndex = hybridizations[_unicornId].listIndex;
319             hybridizationList[hybridizations[_unicornId].listIndex] = hybridizationList[hybridizationListSize];
320             delete hybridizationList[hybridizationListSize];
321             delete hybridizations[_unicornId];
322             emit HybridizationDelete(_unicornId);
323         }
324     }
325 
326     //Create new 0 gen
327     function createUnicorn() public payable whenNotPaused returns(uint256)   {
328         require(msg.value == getCreateUnicornPrice());
329         return _createUnicorn(msg.sender);
330     }
331 
332     function createUnicornForCandy() public payable whenNotPaused returns(uint256)   {
333         require(msg.value == unicornManagement.oraclizeFee());
334         require(candyToken.transferFrom(msg.sender, this, getCreateUnicornPriceInCandy()));
335         return _createUnicorn(msg.sender);
336     }
337 
338     function createPresaleUnicorns(uint _count, address _owner) public payable onlyManager whenPaused returns(bool) {
339         require(gen0PresaleCount.add(_count) <= gen0PresaleLimit);
340         uint256 newUnicornId;
341         address owner = _owner == address(0) ? msg.sender : _owner;
342         for (uint i = 0; i < _count; i++){
343             newUnicornId = unicornToken.createUnicorn(owner);
344             blackBox.createGen0(newUnicornId);
345             emit CreateUnicorn(owner, newUnicornId, 0, 0);
346             gen0Count = gen0Count.add(1);
347             gen0PresaleCount = gen0PresaleCount.add(1);
348         }
349         return true;
350     }
351 
352     function _createUnicorn(address _owner) private returns(uint256) {
353         require(gen0Count < gen0Limit);
354         uint256 newUnicornId = unicornToken.createUnicorn(_owner);
355         //        BlackBoxInterface blackBox = BlackBoxInterface(unicornManagement.blackBoxAddress());
356         blackBox.createGen0.value(unicornManagement.oraclizeFee())(newUnicornId);
357         emit CreateUnicorn(_owner, newUnicornId, 0, 0);
358         gen0Count = gen0Count.add(1);
359         return newUnicornId;
360     }
361 
362     function plusFreezingTime(uint _unicornId) private {
363         unicornToken.plusFreezingTime(_unicornId);
364     }
365 
366     function plusTourFreezingTime(uint _unicornId) onlyTournament public {
367         unicornToken.plusTourFreezingTime(_unicornId);
368     }
369 
370     //change freezing time for megacandy
371     function minusFreezingTime(uint _unicornId, uint _count) public { 
372         require(megaCandyToken.burn(msg.sender,   unicornManagement.subFreezingPrice().mul(_count)));
373         unicornToken.minusFreezingTime(_unicornId,  unicornManagement.subFreezingTime() * uint64(_count));
374     }
375 
376     //change tour freezing time for megacandy
377     function minusTourFreezingTime(uint _unicornId, uint _count) public { 
378         require(megaCandyToken.burn(msg.sender, unicornManagement.subTourFreezingPrice().mul(_count)));
379         unicornToken.minusTourFreezingTime(_unicornId, unicornManagement.subTourFreezingTime() * uint64(_count));
380     }
381 
382     function getHybridizationPrice(uint _unicornId) public view returns (uint) {
383         return unicornManagement.getHybridizationFullPrice(hybridizations[_unicornId].price);
384     }
385 
386     function getEtherFeeForPriceInCandy() public view returns (uint) {
387         return unicornManagement.oraclizeFee();
388     }
389 
390     function getCreateUnicornPriceInCandy() public view returns (uint) {
391         return unicornManagement.getCreateUnicornFullPriceInCandy();
392     }
393 
394 
395     function getCreateUnicornPrice() public view returns (uint) {
396         return unicornManagement.getCreateUnicornFullPrice();
397     }
398 
399 
400     function withdrawTokens() onlyManager public {
401         require(candyToken.balanceOf(this) > 0); 
402         candyToken.transfer(unicornManagement.walletAddress(), candyToken.balanceOf(this)); 
403     }
404 
405 
406     function transferEthersToDividendManager(uint _value) onlyManager public {
407         require(address(this).balance >= _value);
408         DividendManagerInterface dividendManager = DividendManagerInterface(unicornManagement.dividendManagerAddress());
409         dividendManager.payDividend.value(_value)();
410         emit FundsTransferred(unicornManagement.dividendManagerAddress(), _value);
411     }
412 
413 
414     function setGen0Limit() external onlyCommunity {
415         require(gen0Count == gen0Limit);
416         gen0Limit = gen0Limit.add(gen0Step);
417         emit NewGen0Limit(gen0Limit);
418     }
419  
420 
421     ////MARKET
422     struct Offer{
423         uint marketIndex;
424         uint priceEth;
425         uint priceCandy;
426         bool exists;
427     }
428 
429     // Mapping from unicorn ID to Offer struct
430     mapping (uint => Offer) public offers;
431     // Mapping from unicorn ID to offer ID
432     //    mapping (uint => uint) public unicornOffer;
433     // market index => offerId
434     mapping(uint => uint) public market;
435     uint public marketSize = 0;
436 
437 
438     function sellUnicorn(uint _unicornId, uint _priceEth, uint _priceCandy) public {
439         require(unicornToken.owns(msg.sender, _unicornId));
440         require(!offers[_unicornId].exists);
441 
442         offers[_unicornId] = Offer({
443             priceEth: _priceEth,
444             priceCandy: _priceCandy,
445             exists: true,
446             marketIndex: marketSize
447             });
448 
449         market[marketSize++] = _unicornId;
450 
451         emit OfferAdd(_unicornId, _priceEth, _priceCandy);
452     }
453 
454 
455     function buyUnicornWithEth(uint _unicornId) public payable {
456         require(offers[_unicornId].exists);
457         uint price = offers[_unicornId].priceEth;
458         //Выставлять на продажу за 0 можно. Но нужно проверить чтобы и вторая цена также была 0
459         if (price == 0) {
460             require(offers[_unicornId].priceCandy == 0);
461         }
462         require(msg.value == getOfferPriceEth(_unicornId));
463 
464         address owner = unicornToken.ownerOf(_unicornId);
465 
466         emit UnicornSold(_unicornId);
467         //deleteoffer вызовется внутри transfer
468         unicornToken.marketTransfer(owner, msg.sender, _unicornId);
469         owner.transfer(price);
470     }
471 
472 
473     function buyUnicornWithCandy(uint _unicornId) public {
474         require(offers[_unicornId].exists);
475         uint price = offers[_unicornId].priceCandy;
476         //Выставлять на продажу за 0 можно. Но нужно проверить чтобы и вторая цена также была 0
477         if (price == 0) {
478             require(offers[_unicornId].priceEth == 0);
479         }
480 
481         address owner = unicornToken.ownerOf(_unicornId);
482 
483         if (price > 0) {
484             require(candyToken.transferFrom(msg.sender, this, getOfferPriceCandy(_unicornId)));
485             candyToken.transfer(owner, price);
486         }
487 
488         emit UnicornSold(_unicornId);
489         //deleteoffer вызовется внутри transfer
490         unicornToken.marketTransfer(owner, msg.sender, _unicornId);
491     }
492 
493 
494     function revokeUnicorn(uint _unicornId) public {
495         require(unicornToken.owns(msg.sender, _unicornId));
496         require(offers[_unicornId].exists);
497         _deleteOffer(_unicornId);
498     }
499 
500 
501     function deleteOffer(uint _unicornId) onlyUnicornToken external {
502         _deleteOffer(_unicornId);
503     }
504 
505 
506     function _deleteOffer(uint _unicornId) internal {
507         if (offers[_unicornId].exists) {
508             offers[market[--marketSize]].marketIndex = offers[_unicornId].marketIndex;
509             market[offers[_unicornId].marketIndex] = market[marketSize];
510             delete market[marketSize];
511             delete offers[_unicornId];
512             emit OfferDelete(_unicornId);
513         }
514     }
515 
516 
517     function getOfferPriceEth(uint _unicornId) public view returns (uint) {
518         return offers[_unicornId].priceEth.add(valueFromPercent(offers[_unicornId].priceEth, sellDividendPercentEth));
519     }
520 
521 
522     function getOfferPriceCandy(uint _unicornId) public view returns (uint) {
523         return offers[_unicornId].priceCandy.add(valueFromPercent(offers[_unicornId].priceCandy, sellDividendPercentCandy));
524     }
525 
526 
527     function setSellDividendPercent(uint _percentCandy, uint _percentEth) public onlyManager {
528         //no more then 25%
529         require(_percentCandy < 2500 && _percentEth < 2500);
530 
531         sellDividendPercentCandy = _percentCandy;
532         sellDividendPercentEth = _percentEth;
533         emit NewSellDividendPercent(_percentCandy, _percentEth);
534     }
535 
536 
537     //1% - 100, 10% - 1000 50% - 5000
538     function valueFromPercent(uint _value, uint _percent) internal pure returns (uint amount)    {
539         uint _amount = _value.mul(_percent).div(10000);
540         return (_amount);
541     }
542 
543 }