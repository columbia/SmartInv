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
82 contract DividendManagerInterface {
83     function payDividend() external payable;
84 }
85 
86 contract BlackBoxInterface {
87     function createGen0(uint _unicornId) public payable;
88     function geneCore(uint _childUnicornId, uint _parent1UnicornId, uint _parent2UnicornId) public payable;
89 }
90 
91 contract UnicornTokenInterface {
92 
93     //ERC721
94     function balanceOf(address _owner) public view returns (uint256 _balance);
95     function ownerOf(uint256 _unicornId) public view returns (address _owner);
96     function transfer(address _to, uint256 _unicornId) public;
97     function approve(address _to, uint256 _unicornId) public;
98     function takeOwnership(uint256 _unicornId) public;
99     function totalSupply() public constant returns (uint);
100     function owns(address _claimant, uint256 _unicornId) public view returns (bool);
101     function allowance(address _claimant, uint256 _unicornId) public view returns (bool);
102     function transferFrom(address _from, address _to, uint256 _unicornId) public;
103 
104     //specific
105     function createUnicorn(address _owner) external returns (uint);
106     //    function burnUnicorn(uint256 _unicornId) external;
107     function getGen(uint _unicornId) external view returns (bytes);
108     function setGene(uint _unicornId, bytes _gene) external;
109     function updateGene(uint _unicornId, bytes _gene) external;
110     function getUnicornGenByte(uint _unicornId, uint _byteNo) external view returns (uint8);
111 
112     function setName(uint256 _unicornId, string _name ) external returns (bool);
113     function plusFreezingTime(uint _unicornId) external;
114     function plusTourFreezingTime(uint _unicornId) external;
115     function minusFreezingTime(uint _unicornId, uint64 _time) external;
116     function minusTourFreezingTime(uint _unicornId, uint64 _time) external;
117     function isUnfreezed(uint _unicornId) external view returns (bool);
118     function isTourUnfreezed(uint _unicornId) external view returns (bool);
119 
120     function marketTransfer(address _from, address _to, uint256 _unicornId) external;
121 }
122 
123 
124 
125 contract UnicornAccessControl {
126 
127     UnicornManagementInterface public unicornManagement;
128 
129     function UnicornAccessControl(address _unicornManagementAddress) public {
130         unicornManagement = UnicornManagementInterface(_unicornManagementAddress);
131         unicornManagement.registerInit(this);
132     }
133 
134     modifier onlyOwner() {
135         require(msg.sender == unicornManagement.ownerAddress());
136         _;
137     }
138 
139     modifier onlyManager() {
140         require(msg.sender == unicornManagement.managerAddress());
141         _;
142     }
143 
144     modifier onlyCommunity() {
145         require(msg.sender == unicornManagement.communityAddress());
146         _;
147     }
148 
149     modifier onlyTournament() {
150         require(unicornManagement.isTournament(msg.sender));
151         _;
152     }
153 
154     modifier whenNotPaused() {
155         require(!unicornManagement.paused());
156         _;
157     }
158 
159     modifier whenPaused {
160         require(unicornManagement.paused());
161         _;
162     }
163 
164 
165     modifier onlyManagement() {
166         require(msg.sender == address(unicornManagement));
167         _;
168     }
169 
170     modifier onlyBreeding() {
171         require(msg.sender == unicornManagement.unicornBreedingAddress());
172         _;
173     }
174 
175     modifier onlyGeneLab() {
176         require(msg.sender == unicornManagement.geneLabAddress());
177         _;
178     }
179 
180     modifier onlyBlackBox() {
181         require(msg.sender == unicornManagement.blackBoxAddress());
182         _;
183     }
184 
185     modifier onlyUnicornToken() {
186         require(msg.sender == unicornManagement.unicornTokenAddress());
187         _;
188     }
189 
190     function isGamePaused() external view returns (bool) {
191         return unicornManagement.paused();
192     }
193 }
194 
195 contract UnicornBreeding is UnicornAccessControl {
196     using SafeMath for uint;
197     //onlyOwner
198     UnicornTokenInterface public unicornToken; //only on deploy
199     BlackBoxInterface public blackBox;
200 
201     event HybridizationAdd(uint indexed unicornId, uint price);
202     event HybridizationAccept(uint indexed firstUnicornId, uint indexed secondUnicornId, uint newUnicornId);
203     event HybridizationDelete(uint indexed unicornId);
204     event FundsTransferred(address dividendManager, uint value);
205     event CreateUnicorn(address indexed owner, uint indexed unicornId, uint parent1, uint  parent2);
206     event NewGen0Limit(uint limit);
207     event NewGen0Step(uint step);
208 
209 
210     event OfferAdd(uint256 indexed unicornId, uint price);
211     event OfferDelete(uint256 indexed unicornId);
212     event UnicornSold(uint256 indexed unicornId);
213 
214     ERC20 public candyToken;
215     ERC20 public candyPowerToken;
216 
217     //counter for gen0
218     uint public gen0Limit = 30000;
219     uint public gen0Count = 0;
220     uint public gen0Step = 1000;
221 
222     //counter for presale gen0
223     uint public gen0PresaleLimit = 1000;
224     uint public gen0PresaleCount = 0;
225 
226     struct Hybridization{
227         uint listIndex;
228         uint price;
229         bool exists;
230     }
231 
232     // Mapping from unicorn ID to Hybridization struct
233     mapping (uint => Hybridization) public hybridizations;
234     mapping(uint => uint) public hybridizationList;
235     uint public hybridizationListSize = 0;
236 
237 
238     function() public payable {
239 
240     }
241 
242     function UnicornBreeding(address _unicornManagementAddress) UnicornAccessControl(_unicornManagementAddress) public {
243         candyToken = ERC20(unicornManagement.candyToken());
244 
245     }
246 
247     function init() onlyManagement whenPaused external {
248         unicornToken = UnicornTokenInterface(unicornManagement.unicornTokenAddress());
249         blackBox = BlackBoxInterface(unicornManagement.blackBoxAddress());
250         candyPowerToken = ERC20(unicornManagement.candyPowerToken());
251     }
252 
253     function makeHybridization(uint _unicornId, uint _price) public {
254         require(unicornToken.owns(msg.sender, _unicornId));
255         require(unicornToken.isUnfreezed(_unicornId));
256         require(!hybridizations[_unicornId].exists);
257 
258         hybridizations[_unicornId] = Hybridization({
259             price: _price,
260             exists: true,
261             listIndex: hybridizationListSize
262             });
263         hybridizationList[hybridizationListSize++] = _unicornId;
264 
265         emit HybridizationAdd(_unicornId, _price);
266     }
267 
268 
269     function acceptHybridization(uint _firstUnicornId, uint _secondUnicornId) whenNotPaused public payable {
270         require(unicornToken.owns(msg.sender, _secondUnicornId));
271         require(_secondUnicornId != _firstUnicornId);
272         require(unicornToken.isUnfreezed(_firstUnicornId) && unicornToken.isUnfreezed(_secondUnicornId));
273         require(hybridizations[_firstUnicornId].exists);
274         require(msg.value == unicornManagement.oraclizeFee());
275         if (hybridizations[_firstUnicornId].price > 0) {
276             require(candyToken.transferFrom(msg.sender, this, getHybridizationPrice(_firstUnicornId)));
277         }
278 
279         plusFreezingTime(_secondUnicornId);
280         uint256 newUnicornId = unicornToken.createUnicorn(msg.sender);
281         blackBox.geneCore.value(unicornManagement.oraclizeFee())(newUnicornId, _firstUnicornId, _secondUnicornId);
282         emit CreateUnicorn(msg.sender, newUnicornId, _firstUnicornId, _secondUnicornId);
283         if (hybridizations[_firstUnicornId].price > 0) {
284             candyToken.transfer(unicornToken.ownerOf(_firstUnicornId), hybridizations[_firstUnicornId].price);
285         }
286         emit HybridizationAccept(_firstUnicornId, _secondUnicornId, newUnicornId);
287         _deleteHybridization(_firstUnicornId);
288     }
289 
290 
291     function cancelHybridization (uint _unicornId) public {
292         require(unicornToken.owns(msg.sender,_unicornId));
293         require(hybridizations[_unicornId].exists);
294         _deleteHybridization(_unicornId);
295     }
296 
297     function deleteHybridization(uint _unicornId) onlyUnicornToken external {
298         _deleteHybridization(_unicornId);
299     }
300 
301     function _deleteHybridization(uint _unicornId) internal {
302         if (hybridizations[_unicornId].exists) {
303             hybridizations[hybridizationList[--hybridizationListSize]].listIndex = hybridizations[_unicornId].listIndex;
304             hybridizationList[hybridizations[_unicornId].listIndex] = hybridizationList[hybridizationListSize];
305             delete hybridizationList[hybridizationListSize];
306             delete hybridizations[_unicornId];
307             emit HybridizationDelete(_unicornId);
308         }
309     }
310 
311     //Create new 0 gen
312     function createUnicorn() public payable whenNotPaused returns(uint256)   {
313         require(msg.value == getCreateUnicornPrice());
314         return _createUnicorn(msg.sender);
315     }
316 
317     function createUnicornForCandy() public payable whenNotPaused returns(uint256)   {
318         require(msg.value == unicornManagement.oraclizeFee());
319         require(candyToken.transferFrom(msg.sender, this, getCreateUnicornPriceInCandy()));
320         return _createUnicorn(msg.sender);
321     }
322 
323     function createPresaleUnicorns(uint _count, address _owner) public payable onlyManager whenPaused returns(bool) {
324         require(gen0PresaleCount.add(_count) <= gen0PresaleLimit);
325         uint256 newUnicornId;
326         address owner = _owner == address(0) ? msg.sender : _owner;
327         for (uint i = 0; i < _count; i++){
328             newUnicornId = unicornToken.createUnicorn(owner);
329             blackBox.createGen0(newUnicornId);
330             emit CreateUnicorn(owner, newUnicornId, 0, 0);
331             gen0Count = gen0Count.add(1);
332             gen0PresaleCount = gen0PresaleCount.add(1);
333         }
334         return true;
335     }
336 
337     function _createUnicorn(address _owner) private returns(uint256) {
338         require(gen0Count < gen0Limit);
339         uint256 newUnicornId = unicornToken.createUnicorn(_owner);
340         blackBox.createGen0.value(unicornManagement.oraclizeFee())(newUnicornId);
341         emit CreateUnicorn(_owner, newUnicornId, 0, 0);
342         gen0Count = gen0Count.add(1);
343         return newUnicornId;
344     }
345 
346     function plusFreezingTime(uint _unicornId) private {
347         unicornToken.plusFreezingTime(_unicornId);
348     }
349 
350     function plusTourFreezingTime(uint _unicornId) onlyTournament public {
351         unicornToken.plusTourFreezingTime(_unicornId);
352     }
353 
354     //change freezing time for candy
355     function minusFreezingTime(uint _unicornId) public {
356         require(candyPowerToken.transferFrom(msg.sender, this, unicornManagement.subFreezingPrice()));
357         unicornToken.minusFreezingTime(_unicornId, unicornManagement.subFreezingTime());
358     }
359 
360     //change tour freezing time for candy
361     function minusTourFreezingTime(uint _unicornId) public {
362         require(candyPowerToken.transferFrom(msg.sender, this, unicornManagement.subTourFreezingPrice()));
363         unicornToken.minusTourFreezingTime(_unicornId, unicornManagement.subTourFreezingTime());
364     }
365 
366     function getHybridizationPrice(uint _unicornId) public view returns (uint) {
367         return unicornManagement.getHybridizationFullPrice(hybridizations[_unicornId].price);
368     }
369 
370     function getEtherFeeForPriceInCandy() public view returns (uint) {
371         return unicornManagement.oraclizeFee();
372     }
373 
374     function getCreateUnicornPriceInCandy() public view returns (uint) {
375         return unicornManagement.getCreateUnicornFullPriceInCandy();
376     }
377 
378 
379     function getCreateUnicornPrice() public view returns (uint) {
380         return unicornManagement.getCreateUnicornFullPrice();
381     }
382 
383 
384     function withdrawTokens() onlyManager public {
385         require(candyToken.balanceOf(this) > 0 || candyPowerToken.balanceOf(this) > 0);
386         if (candyToken.balanceOf(this) > 0) {
387             candyToken.transfer(unicornManagement.walletAddress(), candyToken.balanceOf(this));
388         }
389         if (candyPowerToken.balanceOf(this) > 0) {
390             candyPowerToken.transfer(unicornManagement.walletAddress(), candyPowerToken.balanceOf(this));
391         }
392     }
393 
394 
395     function transferEthersToDividendManager(uint _value) onlyManager public {
396         require(address(this).balance >= _value);
397         DividendManagerInterface dividendManager = DividendManagerInterface(unicornManagement.dividendManagerAddress());
398         dividendManager.payDividend.value(_value)();
399         emit FundsTransferred(unicornManagement.dividendManagerAddress(), _value);
400     }
401 
402 
403     function setGen0Limit() external onlyCommunity {
404         require(gen0Count == gen0Limit);
405         gen0Limit = gen0Limit.add(gen0Step);
406         emit NewGen0Limit(gen0Limit);
407     }
408 
409     function setGen0Step(uint _step) external onlyCommunity {
410         gen0Step = _step;
411         emit NewGen0Step(gen0Limit);
412     }
413 
414 
415 
416 
417 
418     ////MARKET
419     struct Offer{
420         uint marketIndex;
421         uint price;
422         bool exists;
423     }
424 
425     // Mapping from unicorn ID to Offer struct
426     mapping (uint => Offer) public offers;
427     // market index => offerId
428     mapping(uint => uint) public market;
429     uint public marketSize = 0;
430 
431 
432     function sellUnicorn(uint _unicornId, uint _price) public {
433         require(unicornToken.owns(msg.sender, _unicornId));
434         require(!offers[_unicornId].exists);
435 
436         offers[_unicornId] = Offer({
437             price: _price,
438             exists: true,
439             marketIndex: marketSize
440             });
441 
442         market[marketSize++] = _unicornId;
443 
444         emit OfferAdd(_unicornId, _price);
445     }
446 
447 
448     function buyUnicorn(uint _unicornId) public payable {
449         require(offers[_unicornId].exists);
450         uint price = offers[_unicornId].price;
451         require(msg.value == unicornManagement.getSellUnicornFullPrice(price));
452 
453         address owner = unicornToken.ownerOf(_unicornId);
454 
455         emit UnicornSold(_unicornId);
456         //deleteoffer вызовется внутри transfer
457         unicornToken.marketTransfer(owner, msg.sender, _unicornId);
458         owner.transfer(price);
459 //        _deleteOffer(_unicornId);
460     }
461 
462 
463     function revokeUnicorn(uint _unicornId) public {
464         require(unicornToken.owns(msg.sender, _unicornId));
465         require(offers[_unicornId].exists);
466         _deleteOffer(_unicornId);
467     }
468 
469 
470     function deleteOffer(uint _unicornId) onlyUnicornToken external {
471         _deleteOffer(_unicornId);
472     }
473 
474 
475     function _deleteOffer(uint _unicornId) internal {
476         if (offers[_unicornId].exists) {
477             offers[market[--marketSize]].marketIndex = offers[_unicornId].marketIndex;
478             market[offers[_unicornId].marketIndex] = market[marketSize];
479             delete market[marketSize];
480             delete offers[_unicornId];
481             emit OfferDelete(_unicornId);
482         }
483     }
484 
485     function getOfferPrice(uint _unicornId) public view returns (uint) {
486         return unicornManagement.getSellUnicornFullPrice(offers[_unicornId].price);
487     }
488 
489 }