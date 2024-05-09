1 pragma solidity ^0.4.19; // solhint-disable-line
2 
3 library FifoLib {
4 
5     uint constant HEAD = 0;
6     
7     struct LinkedList {
8         mapping (uint => uint) list;
9         uint tail;
10         uint size;
11     }
12 
13     function size(LinkedList storage self)
14         internal view returns (uint r) {
15         return self.size;
16     }
17 
18     function next(LinkedList storage self, uint n)
19         internal view returns (uint) {
20         return self.list[n];
21     }
22 
23     // insert n after prev
24     function insert(LinkedList storage self, uint prev, uint n) internal returns (uint) {
25         require(n != HEAD && self.list[n] == HEAD && n != self.tail);
26         self.list[n] = self.list[prev];
27         self.list[prev] = n;
28         self.size++;
29         if (self.tail == prev) {
30             self.tail = n;
31         }
32         return n;
33     }
34     
35     // Remove node n preceded by prev
36     function remove(LinkedList storage self, uint prev, uint n) internal returns (uint) {
37         require(n != HEAD && self.list[prev] == n);
38         self.list[prev] = self.list[n];
39         delete self.list[n];
40         self.size--;
41         if (self.tail == n) {
42             self.tail = prev;
43         }
44         return n;
45     }
46 
47     function pushTail(LinkedList storage self, uint n) internal returns (uint) {
48         return insert(self, self.tail, n);
49     }
50     
51     function popHead(LinkedList storage self) internal returns (uint) {
52         require(self.size > 0);
53         return remove(self, HEAD, self.list[HEAD]);
54     }
55 }
56 
57 contract CompanyToken {
58     event Founded(uint256 tokenId, string name, address owner, uint256 price);
59     event SharesSold(uint256 tokenId, uint256 shares, uint256 price, address prevOwner, address newOnwer, string name);
60     event Transfer(address from, address to, uint256 tokenId, uint256 shares);
61 
62     string public constant NAME = "CryptoCompanies"; // solhint-disable-line
63     string public constant SYMBOL = "CompanyToken"; // solhint-disable-line
64 
65     uint256 private constant HEAD = 0;
66 
67     uint256 private startingPrice = 0.001 ether;
68     uint256 private constant PROMO_CREATION_LIMIT = 5000;
69     uint256 private firstStepLimit =  0.05 ether;
70     uint256 private secondStepLimit = 0.5 ether;
71 
72     uint256 public commissionPoints = 5;
73 
74     // @dev max number of shares per company
75     uint256 private constant TOTAL_SHARES = 100;
76 
77     // @dev companyIndex => (ownerAddress => numberOfShares)
78     mapping (uint256 => mapping (address => uint256)) public companyIndexToOwners;
79 
80     struct Holding {
81         address owner;
82         uint256 shares;
83     }
84 
85     // tokenId => holding fifo
86     mapping (uint256 => FifoLib.LinkedList) private fifo;
87     // tokenId => map(fifoIndex => holding)
88     mapping (uint256 => mapping (uint256 => Holding)) private fifoStorage;
89 
90     mapping (uint256 => uint256) private fifoStorageKey;
91 
92     // number of shares traded
93     // tokenId => circulatationCount
94     mapping (uint256 => uint256) private circulationCounters;
95 
96     // @dev A mapping from CompanyIDs to the price of the token.
97     mapping (uint256 => uint256) private companyIndexToPrice;
98 
99     // @dev Owner who has most shares 
100     mapping (uint256 => address) private companyIndexToChairman;
101 
102     // @dev Whether buying shares is allowed. if false, only whole purchase is allowed.
103     mapping (uint256 => bool) private shareTradingEnabled;
104 
105 
106     // The addresses of the accounts (or contracts) that can execute actions within each roles.
107     address public ceoAddress;
108     address public cooAddress;
109 
110     uint256 public promoCreatedCount;
111 
112     struct Company {
113         string name;
114     }
115 
116     Company[] private companies;
117 
118     modifier onlyCEO() {
119         require(msg.sender == ceoAddress);
120         _;
121     }
122 
123     modifier onlyCOO() {
124         require(msg.sender == cooAddress);
125         _;
126     }
127 
128     modifier onlyCLevel() {
129         require(
130             msg.sender == ceoAddress ||
131             msg.sender == cooAddress
132         );
133         _;
134     }
135 
136     function CompanyToken() public {
137         ceoAddress = msg.sender;
138         cooAddress = msg.sender;
139     }
140 
141     function createPromoCompany(address _owner, string _name, uint256 _price) public onlyCOO {
142         require(promoCreatedCount < PROMO_CREATION_LIMIT);
143 
144         address companyOwner = _owner;
145         if (companyOwner == address(0)) {
146             companyOwner = cooAddress;
147         }
148 
149         if (_price <= 0) {
150             _price = startingPrice;
151         }
152 
153         promoCreatedCount++;
154         _createCompany(_name, companyOwner, _price);
155     }
156 
157     function createContractCompany(string _name) public onlyCOO {
158         _createCompany(_name, address(this), startingPrice);
159     }
160 
161     function setShareTradingEnabled(uint256 _tokenId, bool _enabled) public onlyCOO {
162         shareTradingEnabled[_tokenId] = _enabled;
163     }
164 
165     function setCommissionPoints(uint256 _point) public onlyCOO {
166         require(_point >= 0 && _point <= 10);
167         commissionPoints = _point;
168     }
169 
170     function getCompany(uint256 _tokenId) public view returns (
171         string companyName,
172         bool isShareTradingEnabled,
173         uint256 price,
174         uint256 _nextPrice,
175         address chairman,
176         uint256 circulations
177     ) {
178         Company storage company = companies[_tokenId];
179         companyName = company.name;
180         isShareTradingEnabled = shareTradingEnabled[_tokenId];
181         price = companyIndexToPrice[_tokenId];
182         _nextPrice = nextPrice(_tokenId, price);
183         chairman = companyIndexToChairman[_tokenId];
184         circulations = circulationCounters[_tokenId];
185     }
186 
187     function name() public pure returns (string) {
188         return NAME;
189     }
190 
191     function shareHoldersOf(uint256 _tokenId) public view returns (address[] memory addrs, uint256[] memory shares) {
192         addrs = new address[](fifo[_tokenId].size);
193         shares = new uint256[](fifo[_tokenId].size);
194 
195         uint256 fifoKey = FifoLib.next(fifo[_tokenId], HEAD);
196         uint256 i;
197         while (fifoKey != HEAD) {
198             addrs[i] = fifoStorage[_tokenId][fifoKey].owner;
199             shares[i] = fifoStorage[_tokenId][fifoKey].shares;
200             fifoKey = FifoLib.next(fifo[_tokenId], fifoKey);
201             i++;
202         }
203         return (addrs, shares);
204     }
205 
206     function chairmanOf(uint256 _tokenId)
207         public
208         view
209         returns (address chairman)
210     {
211         chairman = companyIndexToChairman[_tokenId];
212         require(chairman != address(0));
213     }
214 
215     function sharesOwned(address _owner, uint256 _tokenId) public view returns (uint256 shares) {
216         return companyIndexToOwners[_tokenId][_owner];
217     }
218 
219     function payout(address _to) public onlyCLevel {
220         _payout(_to);
221     }
222 
223     function priceOf(uint256 _tokenId) public view returns (uint256 price) {
224         return companyIndexToPrice[_tokenId];
225     }
226 
227     function setCEO(address _newCEO) public onlyCEO {
228         require(_newCEO != address(0));
229 
230         ceoAddress = _newCEO;
231     }
232 
233     function setCOO(address _newCOO) public onlyCEO {
234         require(_newCOO != address(0));
235 
236         cooAddress = _newCOO;
237     }
238 
239     function symbol() public pure returns (string) {
240         return SYMBOL;
241     }
242 
243     function totalCompanies() public view returns (uint256 total) {
244         return companies.length;
245     }
246 
247 
248     function _addressNotNull(address _to) private pure returns (bool) {
249         return _to != address(0);
250     }
251 
252     /// For creating Company
253     function _createCompany(string _name, address _owner, uint256 _price) private {
254         require(_price % 100 == 0);
255 
256         Company memory _company = Company({
257             name: _name
258         });
259         uint256 newCompanyId = companies.push(_company) - 1;
260 
261         // It's probably never going to happen, 4 billion tokens are A LOT, but
262         // let's just be 100% sure we never let this happen.
263         require(newCompanyId == uint256(uint32(newCompanyId)));
264 
265         Founded(newCompanyId, _name, _owner, _price);
266 
267         companyIndexToPrice[newCompanyId] = _price;
268 
269         _transfer(address(0), _owner, newCompanyId, TOTAL_SHARES);
270     }
271 
272     /// Check for token ownership
273     function _owns(address claimant, uint256 _tokenId, uint256 _shares) private view returns (bool) {
274         return companyIndexToOwners[_tokenId][claimant] >= _shares;
275     }
276 
277     /// For paying out balance on contract
278     function _payout(address _to) private {
279         if (_to == address(0)) {
280             ceoAddress.transfer(this.balance);
281         } else {
282             _to.transfer(this.balance);
283         }
284     }
285 
286     function _purchaseProcessFifoItem(uint256 _tokenId, Holding storage _holding, uint256 _sharesToFulfill)
287         private
288         returns (uint256 sharesFulfilled, uint256 payment) {
289 
290         sharesFulfilled = Math.min(_holding.shares, _sharesToFulfill);
291 
292         // underflow is not possible because decution is the minimun of the two
293         _holding.shares -= sharesFulfilled;
294 
295         companyIndexToOwners[_tokenId][_holding.owner] = SafeMath.sub(companyIndexToOwners[_tokenId][_holding.owner], sharesFulfilled);
296 
297         uint256 currentTierLeft = SafeMath.sub(TOTAL_SHARES, circulationCounters[_tokenId] % TOTAL_SHARES);
298         uint256 currentPriceShares = Math.min(currentTierLeft, sharesFulfilled);
299         payment = SafeMath.div(SafeMath.mul(companyIndexToPrice[_tokenId], currentPriceShares), TOTAL_SHARES);
300 
301         SharesSold(_tokenId, currentPriceShares, companyIndexToPrice[_tokenId], _holding.owner, msg.sender, companies[_tokenId].name);
302 
303         if (sharesFulfilled >= currentTierLeft) {
304             uint256 newPrice = nextPrice(_tokenId, companyIndexToPrice[_tokenId]);
305             companyIndexToPrice[_tokenId] = newPrice;
306 
307             if (sharesFulfilled > currentTierLeft) {
308                 uint256 newPriceShares = sharesFulfilled - currentTierLeft;
309                 payment += SafeMath.div(SafeMath.mul(newPrice, newPriceShares), TOTAL_SHARES);
310                 SharesSold(_tokenId, newPriceShares, newPrice, _holding.owner, msg.sender, companies[_tokenId].name);
311             }
312         }
313 
314         circulationCounters[_tokenId] = SafeMath.add(circulationCounters[_tokenId], sharesFulfilled);
315 
316         // no need to transfer if seller is the contract
317         if (_holding.owner != address(this)) {
318             _holding.owner.transfer(SafeMath.div(SafeMath.mul(payment, 100 - commissionPoints), 100));
319         }
320 
321         Transfer(_holding.owner, msg.sender, _tokenId, sharesFulfilled);
322     }
323 
324     function _purchaseLoopFifo(uint256 _tokenId, uint256 _sharesToFulfill)
325         private
326         returns (uint256 sharesFulfilled, uint256 totalPayment) {
327         uint256 prevFifoKey = HEAD;
328         uint256 fifoKey = FifoLib.next(fifo[_tokenId], HEAD);
329         while (fifoKey != HEAD) {
330             Holding storage holding = fifoStorage[_tokenId][fifoKey];
331 
332             assert(holding.shares > 0);
333 
334             if (holding.owner != msg.sender) {
335                 uint256 itemSharesFulfilled;
336                 uint256 itemPayment;
337                 (itemSharesFulfilled, itemPayment) = _purchaseProcessFifoItem(_tokenId, holding, SafeMath.sub(_sharesToFulfill, sharesFulfilled));
338 
339                 sharesFulfilled += itemSharesFulfilled;
340                 totalPayment += itemPayment;
341 
342                 if (holding.shares == 0) {
343                     // delete the record from fifo
344                     FifoLib.remove(fifo[_tokenId], prevFifoKey, fifoKey);
345                     fifoKey = prevFifoKey;
346                 }
347             }
348 
349             if (sharesFulfilled == _sharesToFulfill) break;
350 
351             prevFifoKey = fifoKey;
352             fifoKey = FifoLib.next(fifo[_tokenId], fifoKey);
353         }  
354     }
355 
356     function purchase(uint256 _tokenId, uint256 _shares) public payable {
357         require(_sharesValid(_tokenId, _shares));
358         require(companyIndexToOwners[_tokenId][msg.sender] + _shares <= TOTAL_SHARES);
359 
360         uint256 estimatedPayment = estimatePurchasePayment(_tokenId, _shares);
361 
362         require(msg.value >= estimatedPayment);
363 
364         uint256 sharesFulfilled;
365         uint256 totalPayment;
366         (sharesFulfilled, totalPayment) = _purchaseLoopFifo(_tokenId, _shares);
367 
368         assert(sharesFulfilled == _shares);
369         assert(totalPayment == estimatedPayment);
370 
371         uint256 purchaseExess = SafeMath.sub(msg.value, totalPayment);
372         assert(purchaseExess >= 0);
373 
374         if (purchaseExess > 0) {
375             msg.sender.transfer(purchaseExess);
376         }
377 
378         fifoStorage[_tokenId][FifoLib.pushTail(fifo[_tokenId], _nextFifoStorageKey(_tokenId))] = Holding({owner: msg.sender, shares: _shares});
379 
380         companyIndexToOwners[_tokenId][msg.sender] += _shares;
381 
382         if (companyIndexToOwners[_tokenId][msg.sender] > companyIndexToOwners[_tokenId][companyIndexToChairman[_tokenId]]) {
383             companyIndexToChairman[_tokenId] = msg.sender;
384         }
385     }
386 
387     function estimatePurchasePayment(uint256 _tokenId, uint256 _shares) public view returns (uint256) {
388         require(_shares <= TOTAL_SHARES);
389 
390         uint256 currentPrice = companyIndexToPrice[_tokenId];
391 
392         uint256 currentPriceShares = Math.min(_shares, TOTAL_SHARES - circulationCounters[_tokenId] % TOTAL_SHARES);
393         return SafeMath.add(
394             SafeMath.div(SafeMath.mul(currentPrice, currentPriceShares), TOTAL_SHARES),
395             SafeMath.div(SafeMath.mul(nextPrice(_tokenId, currentPrice), _shares - currentPriceShares), TOTAL_SHARES)
396         );
397     }
398 
399     function nextPrice(uint256 _tokenId, uint256 _currentPrice) public view returns (uint256) {
400         uint256 price;
401         if (_currentPrice < firstStepLimit) {
402           // first stage
403           price = SafeMath.div(SafeMath.mul(_currentPrice, 200), 100);
404         } else if (_currentPrice < secondStepLimit) {
405           // second stage
406           price = SafeMath.div(SafeMath.mul(_currentPrice, 120), 100);
407         } else {
408           // third stage
409           price = SafeMath.div(SafeMath.mul(_currentPrice, 115), 100);
410         }
411 
412         return price - price % 100;
413     }
414 
415     function transfer(
416         address _to,
417         uint256 _tokenId,
418         uint256 _shares
419     ) public {
420         require(_addressNotNull(_to));
421         require(_sharesValid(_tokenId, _shares));
422         require(_owns(msg.sender, _tokenId, _shares));
423 
424         _transfer(msg.sender, _to, _tokenId, _shares);
425     }
426 
427     function transferFromContract(
428         address _to,
429         uint256 _tokenId,
430         uint256 _shares
431     ) public onlyCOO {
432         address from = address(this);
433         require(_addressNotNull(_to));
434         require(_sharesValid(_tokenId, _shares));
435         require(_owns(from, _tokenId, _shares));
436 
437         _transfer(from, _to, _tokenId, _shares);
438     }
439 
440     function _transfer(address _from, address _to, uint256 _tokenId, uint256 _shares) private {
441         if (_from != address(0)) {
442             uint256 sharesToFulfill = _shares;
443 
444             uint256 fifoKey = FifoLib.next(fifo[_tokenId], HEAD);
445             while (fifoKey != HEAD) {
446                 Holding storage holding = fifoStorage[_tokenId][fifoKey];
447 
448                 assert(holding.shares > 0);
449 
450                 if (holding.owner == _from) {
451                     uint256 fulfilled = Math.min(holding.shares, sharesToFulfill);
452 
453                     if (holding.shares == fulfilled) {
454                         // if all shares are taken, just modify the owner address in place
455                         holding.owner = _to;
456                     } else {
457                         // underflow is not possible because deduction is the minimun of the two
458                         holding.shares -= fulfilled;
459 
460                         // insert a new holding record
461                         fifoStorage[_tokenId][FifoLib.insert(fifo[_tokenId], fifoKey, _nextFifoStorageKey(_tokenId))] = Holding({owner: _to, shares: fulfilled});
462 
463                         fifoKey = FifoLib.next(fifo[_tokenId], fifoKey);
464                         // now fifoKey points to the newly inserted one 
465                     }
466 
467                     // underflow is not possible because deduction is the minimun of the two
468                     sharesToFulfill -= fulfilled;
469                 }
470 
471                 if (sharesToFulfill == 0) break;
472 
473                 fifoKey = FifoLib.next(fifo[_tokenId], fifoKey);
474             }
475 
476             require(sharesToFulfill == 0);
477 
478             companyIndexToOwners[_tokenId][_from] -= _shares;
479         } else {
480             // genesis transfer
481             fifoStorage[_tokenId][FifoLib.pushTail(fifo[_tokenId], _nextFifoStorageKey(_tokenId))] = Holding({owner: _to, shares: _shares});
482         }
483 
484         companyIndexToOwners[_tokenId][_to] += _shares;
485 
486         if (companyIndexToOwners[_tokenId][_to] > companyIndexToOwners[_tokenId][companyIndexToChairman[_tokenId]]) {
487             companyIndexToChairman[_tokenId] = _to;
488         }
489 
490         // Emit the transfer event.
491         Transfer(_from, _to, _tokenId, _shares);
492     }
493 
494     function _sharesValid(uint256 _tokenId, uint256 _shares) private view returns (bool) {
495         return (_shares > 0 && _shares <= TOTAL_SHARES) &&
496             (shareTradingEnabled[_tokenId] || _shares == TOTAL_SHARES);
497     }
498 
499     function _nextFifoStorageKey(uint256 _tokenId) private returns (uint256) {
500         return ++fifoStorageKey[_tokenId];
501     }
502 }
503 
504 
505 library SafeMath {
506 
507     /**
508     * @dev Multiplies two numbers, throws on overflow.
509     */
510     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
511         if (a == 0) {
512             return 0;
513         }
514         uint256 c = a * b;
515         assert(c / a == b);
516         return c;
517     }
518 
519     /**
520     * @dev Integer division of two numbers, truncating the quotient.
521     */
522     function div(uint256 a, uint256 b) internal pure returns (uint256) {
523         // assert(b > 0); // Solidity automatically throws when dividing by 0
524         uint256 c = a / b;
525         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
526         return c;
527     }
528 
529     /**
530     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
531     */
532     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
533         assert(b <= a);
534         return a - b;
535     }
536 
537     /**
538     * @dev Adds two numbers, throws on overflow.
539     */
540     function add(uint256 a, uint256 b) internal pure returns (uint256) {
541         uint256 c = a + b;
542         assert(c >= a);
543         return c;
544     }
545 }
546 
547 library Math {
548     function max(uint256 a, uint256 b) internal pure returns (uint256) {
549         if (a > b) return a;
550         else return b;
551     }
552     function min(uint256 a, uint256 b) internal pure returns (uint256) {
553         if (a < b) return a;
554         else return b;
555     }
556 }