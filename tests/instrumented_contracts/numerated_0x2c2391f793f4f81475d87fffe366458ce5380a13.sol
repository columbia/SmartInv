1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     constructor() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         emit OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 
43 }
44 
45 contract Beneficiary is Ownable {
46 
47     address public beneficiary;
48 
49     constructor() public {
50         beneficiary = msg.sender;
51     }
52 
53     function setBeneficiary(address _beneficiary) onlyOwner public {
54         beneficiary = _beneficiary;
55     }
56 
57     function withdrawal(uint256 amount) public onlyOwner {
58         if (amount > address(this).balance) {
59             revert();
60         }
61 
62         beneficiary.transfer(amount);
63     }
64 
65     function withdrawalAll() public onlyOwner {
66         beneficiary.transfer(address(this).balance);
67     }
68 }
69 
70 contract MCPSale is Beneficiary {
71 
72     mapping(address => uint256) public balances;
73     mapping(uint256 => address) public approved;
74     mapping(int32 => mapping(int32 => uint256)) public zone;
75     mapping(uint256 => Coordinates) public zone_reverse;
76     mapping(uint16 => Region) public regions;
77     mapping(uint16 => RegionBid) public region_bids;
78 
79     bool public constant implementsERC721 = true;
80 
81     uint256 constant MINIMAL_RAISE = 0.5 ether;
82     uint256 constant AUCTION_DURATION = 7 * 24 * 60 * 60; // 7 Days
83 
84     bool public SaleActive = true;
85 
86     struct MapLand {
87         uint8 resources;
88         uint16 region;
89         uint256 buyPrice;
90         address owner;
91     }
92 
93     struct Coordinates {
94         int32 x;
95         int32 y;
96     }
97 
98     struct RegionBid {
99         address currentBuyer;
100         uint256 bid;
101         uint256 activeTill;
102     }
103 
104     struct Region {
105         address owner;
106         uint8 tax;
107         uint256 startPrice;
108         string regionName;
109         bool onSale;
110         bool allowSaleLands;
111         bool created;
112     }
113 
114 
115     uint256 public basePrice = 0.01 ether;
116     uint256 public minMargin = 0.001944 ether;
117     uint32 public divider = 8;
118     uint8 public defaultRegionTax = 10;
119 
120     MapLand[] public tokens;
121 
122     address public mapMaster;
123 
124     modifier isTokenOwner(uint256 _tokenId) {
125         if (tokens[_tokenId].owner != msg.sender) {
126 
127             if (msg.value > 0) {
128                 msg.sender.transfer(msg.value);
129             }
130 
131             return;
132 
133         }
134 
135         _;
136     }
137 
138     modifier onlyRegionOwner(uint16 _regionId) {
139         if (regions[_regionId].owner != msg.sender) {
140 
141             if (msg.value > 0) {
142                 msg.sender.transfer(msg.value);
143             }
144 
145             return;
146 
147         }
148 
149         _;
150     }
151 
152     modifier isNotNullAddress(address _address) {
153         require(address(0) != _address);
154         _;
155     }
156 
157     modifier isApproved(uint256 _tokenId, address _to) {
158         require(approved[_tokenId] == _to);
159         _;
160     }
161 
162     modifier onlyMapMaster() {
163         require(mapMaster == msg.sender);
164         _;
165     }
166 
167     modifier onlyOnActiveSale() {
168         require(SaleActive);
169         _;
170     }
171 
172     modifier canMakeBid(uint16 regionId) {
173         if ((region_bids[regionId].activeTill != 0 && region_bids[regionId].activeTill < now)
174         || regions[regionId].owner != address(0) || !regions[regionId].onSale
175         ) {
176             if (msg.value > 0) {
177                 msg.sender.transfer(msg.value);
178             }
179             return;
180         }
181 
182         _;
183     }
184 
185     constructor() public {
186         mapMaster = msg.sender;
187         tokens.length++;
188         //reserve 0 token - no binding, no sale
189         MapLand storage reserve = tokens[tokens.length - 1];
190         reserve.owner = msg.sender;
191     }
192 
193     function setMapMaster(address _mapMaster) public onlyOwner {
194         mapMaster = _mapMaster;
195     }
196 
197     function setMinMargin(uint256 _amount) public onlyOwner {
198         minMargin = _amount;
199     }
200 
201     function setBasePrice(uint256 _amount) public onlyOwner {
202         basePrice = _amount;
203     }
204 
205     function setRegionTax(uint16 regionId, uint8 tax) public onlyRegionOwner(regionId) onlyOnActiveSale {
206         require(tax <= 100 && tax >= 0);
207         regions[regionId].tax = tax;
208 
209         emit TaxUpdate(regionId, regions[regionId].tax);
210     }
211 
212     function setRegionName(uint16 regionId, string regionName) public onlyOwner {
213         regions[regionId].regionName = regionName;
214         emit ChangeRegionName(regionId, regionName);
215     }
216 
217     function setRegionOnSale(uint16 regionId) public onlyMapMaster {
218         regions[regionId].onSale = true;
219 
220         emit RegionOnSale(regionId);
221     }
222 
223     function setAllowSellLands(uint16 regionId) public onlyMapMaster {
224         regions[regionId].allowSaleLands = true;
225 
226         emit RegionAllowSaleLands(regionId);
227     }
228 
229     function setRegionPrice(uint16 regionId, uint256 price) public onlyOwner {
230         if(regions[regionId].owner == address(0) && !regions[regionId].onSale) {
231             regions[regionId].startPrice = price;
232             emit UpdateRegionPrice(regionId, price);
233         }
234     }
235 
236     function addRegion(uint16 _regionId, uint256 _startPrice, string _regionName) public onlyMapMaster onlyOnActiveSale {
237 
238         if (regions[_regionId].created) {
239             return;
240         }
241 
242         Region storage newRegion = regions[_regionId];
243         newRegion.startPrice = _startPrice;
244         newRegion.tax = defaultRegionTax;
245         newRegion.owner = address(0);
246         newRegion.regionName = _regionName;
247         newRegion.created = true;
248 
249         emit AddRegion(_regionId);
250     }
251 
252     function regionExists(uint16 _regionId) public view returns (bool) {
253         return regions[_regionId].created;
254     }
255 
256     function makeBid(uint16 regionId) payable public
257     onlyOnActiveSale
258     canMakeBid(regionId) {
259 
260         uint256 minimal_bid;
261 
262         if (region_bids[regionId].currentBuyer != address(0)) {//If have bid already
263             minimal_bid = region_bids[regionId].bid + MINIMAL_RAISE;
264         } else {
265             minimal_bid = regions[regionId].startPrice;
266         }
267 
268         if (minimal_bid > msg.value) {
269 
270             if (msg.value > 0) {
271                 msg.sender.transfer(msg.value);
272             }
273 
274             return;
275         }
276 
277         RegionBid storage bid = region_bids[regionId];
278 
279         if (bid.currentBuyer != address(0)) {
280             //Return funds to old buyer
281             bid.currentBuyer.transfer(bid.bid);
282         } else {
283             emit AuctionStarts(regionId);
284         }
285 
286         // Auction will be active for 7 days if no one make a new bid
287         bid.activeTill = now + AUCTION_DURATION;
288 
289 
290         bid.currentBuyer = msg.sender;
291         bid.bid = msg.value;
292 
293         emit RegionNewBid(regionId, msg.sender, msg.value, region_bids[regionId].activeTill);
294     }
295 
296     function completeRegionAuction(uint16 regionId) public onlyMapMaster {
297         if (region_bids[regionId].currentBuyer == address(0)) {
298             return;
299         }
300 
301         if (region_bids[regionId].activeTill > now || region_bids[regionId].activeTill == 0) {
302             return;
303         }
304 
305         transferRegion(regionId, region_bids[regionId].currentBuyer);
306     }
307 
308     function takeRegion(uint16 regionId) public {
309         require(regions[regionId].owner == address(0));
310         require(region_bids[regionId].currentBuyer == msg.sender);
311         require(region_bids[regionId].activeTill < now);
312 
313         transferRegion(regionId, region_bids[regionId].currentBuyer);
314     }
315 
316     function transferRegion(uint16 regionId, address newOwner) internal {
317         regions[regionId].owner = newOwner;
318         regions[regionId].onSale = false;
319 
320         emit RegionSold(regionId, regions[regionId].owner);
321     }
322 
323     // returns next minimal bid or final bid on auctions that already end
324     function getRegionPrice(uint16 regionId) public view returns (uint256 next_bid) {
325         if(regions[regionId].owner != address(0)) {
326             return region_bids[regionId].bid;
327         }
328 
329         if (region_bids[regionId].currentBuyer != address(0)) {//If have bid already
330             next_bid = region_bids[regionId].bid + MINIMAL_RAISE;
331         } else {
332             next_bid = regions[regionId].startPrice;
333         }
334     }
335 
336     function _activateZoneLand(int32 x, int32 y, uint8 region, uint8 resources) internal {
337         tokens.length++;
338         MapLand storage tmp = tokens[tokens.length - 1];
339 
340         tmp.region = region;
341         tmp.resources = resources;
342         tmp.buyPrice = 0;
343         zone[x][y] = tokens.length - 1;
344         zone_reverse[tokens.length - 1] = Coordinates(x, y);
345 
346         emit ActivateMap(x, y, tokens.length - 1);
347     }
348 
349     function activateZone(int32[] x, int32[] y, uint8[] region, uint8[] resources) public onlyMapMaster {
350         for (uint index = 0; index < x.length; index++) {
351             _activateZoneLand(x[index], y[index], region[index], resources[index]);
352         }
353     }
354 
355     function buyLand(int32 x, int32 y) payable public onlyOnActiveSale {
356         MapLand storage token = tokens[zone[x][y]];
357         if (zone[x][y] == 0 || token.buyPrice > 0 || token.owner != address(0)
358         || !regions[token.region].allowSaleLands) {
359 
360             if (msg.value > 0) {
361                 msg.sender.transfer(msg.value);
362             }
363 
364             return;
365         }
366 
367         uint256 buyPrice = getLandPrice(x, y);
368 
369         if (buyPrice == 0) {
370 
371             if (msg.value > 0) {
372                 msg.sender.transfer(msg.value);
373             }
374 
375             return;
376         }
377 
378         uint256[49] memory payouts;
379         address[49] memory addresses;
380         uint8 tokenBought;
381 
382 
383         if (buyPrice > msg.value) {
384 
385             if (msg.value > 0) {
386                 msg.sender.transfer(msg.value);
387             }
388 
389             return;
390         } else if (buyPrice < msg.value) {
391             msg.sender.transfer(msg.value - buyPrice);
392         }
393 
394         (payouts, addresses, tokenBought) = getPayouts(x, y);
395 
396 
397         token.owner = msg.sender;
398         token.buyPrice = buyPrice;
399         balances[msg.sender]++;
400 
401         doPayouts(payouts, addresses, buyPrice);
402 
403         uint256 tax = getRegionTax(token.region);
404 
405         if (regions[token.region].owner != address(0) && tax > 100) {
406             uint256 taxValue = ((basePrice * (tax - 100) + ((tokenBought ** 2) * minMargin * (tax - 100))) / 100);
407             regions[token.region].owner.transfer(taxValue);
408             emit RegionPayout(regions[token.region].owner, taxValue);
409         }
410 
411         emit Transfer(address(0), msg.sender, zone[x][y]);
412 
413     }
414 
415     function doPayouts(uint256[49] payouts, address[49] addresses, uint256 fullValue) internal returns (uint256){
416         for (uint8 i = 0; i < addresses.length; i++) {
417             if (addresses[i] == address(0)) {
418                 continue;
419             }
420             addresses[i].transfer(payouts[i]);
421             emit Payout(addresses[i], payouts[i]);
422             fullValue -= payouts[i];
423         }
424 
425 
426         return fullValue;
427     }
428 
429     function getPayouts(int32 x, int32 y) public view returns (uint256[49] payouts, address[49] addresses, uint8 tokenBought) {
430 
431         for (int32 xi = x - 3; xi <= x + 3; xi++) {
432             for (int32 yi = y - 3; yi <= y + 3; yi++) {
433                 if (x == xi && y == yi) {
434                     continue;
435                 }
436                 MapLand memory token = tokens[zone[xi][yi]];
437 
438                 if (token.buyPrice > 0) {
439                     payouts[tokenBought] = (token.buyPrice / divider);
440                     addresses[tokenBought] = (token.owner);
441                     tokenBought++;
442 
443                 }
444             }
445         }
446 
447 
448         return (payouts, addresses, tokenBought);
449     }
450 
451     function getLandPrice(int32 x, int32 y) public view returns (uint256 price){
452 
453         if (zone[x][y] == 0) {
454             return;
455         }
456 
457         MapLand memory token = tokens[zone[x][y]];
458 
459         int256[2] memory start;
460         start[0] = x - 3;
461         start[1] = y - 3;
462         uint256[2] memory counters = [uint256(0), 0];
463         for (int32 xi = x - 3; xi <= x + 3; xi++) {
464             for (int32 yi = y - 3; yi <= y + 3; yi++) {
465                 if (x == xi && y == yi) {
466                     continue;
467                 }
468 
469                 if (tokens[zone[xi][yi]].buyPrice > 0) {
470                     counters[1] += tokens[zone[xi][yi]].buyPrice;
471                     counters[0]++;
472                 }
473             }
474         }
475 
476         uint16 regionId = token.region;
477 
478         uint8 taxValue = getRegionTax(regionId);
479 
480         if (counters[0] == 0) {
481             price = ((basePrice * taxValue) / 100);
482         } else {
483             price = ((basePrice * taxValue) / 100) + (uint(counters[1]) / divider) + (((counters[0] ** 2) * minMargin * taxValue) / 100);
484         }
485     }
486 
487 
488     function getRegionTax(uint16 regionId) internal view returns (uint8) {
489         if (regions[regionId].owner != address(0)) {
490             return (100 + regions[regionId].tax);
491         }
492         return (100 + defaultRegionTax);
493     }
494 
495     function approve(address _to, uint256 _tokenId) public isTokenOwner(_tokenId) isNotNullAddress(_to) {
496         approved[_tokenId] = _to;
497         emit Approval(msg.sender, _to, _tokenId);
498     }
499 
500     function setRegionOwner(uint16 regionId, address owner, uint256 viewPrice) public onlyOwner {
501         require(regions[regionId].owner == address(0) && !regions[regionId].onSale);
502 
503         regions[regionId].owner = owner;
504 
505         RegionBid storage bid = region_bids[regionId];
506         bid.activeTill = now;
507         bid.currentBuyer = owner;
508         bid.bid = viewPrice;
509 
510         emit RegionSold(regionId, owner);
511 
512     }
513 
514     function transfer(address _to, uint256 _tokenId) public isTokenOwner(_tokenId) isNotNullAddress(_to) isApproved(_tokenId, _to) {
515         tokens[_tokenId].owner = _to;
516 
517         balances[msg.sender]--;
518         balances[_to]++;
519 
520         emit Transfer(msg.sender, _to, _tokenId);
521     }
522 
523 
524     function transferFrom(address _from, address _to, uint256 _tokenId) public isTokenOwner(_tokenId) isApproved(_tokenId, _to) {
525         tokens[_tokenId].owner = _to;
526 
527         emit Transfer(_from, _to, _tokenId);
528     }
529 
530     function ownerOf(uint256 _tokenId) public view returns (address owner) {
531         owner = tokens[_tokenId].owner;
532     }
533 
534     function totalSupply() public view returns (uint256) {
535         return tokens.length;
536     }
537 
538     function balanceOf(address _owner) public view returns (uint256 balance) {
539         balance = balances[_owner];
540     }
541 
542     function setSaleEnd() public onlyOwner {
543         SaleActive = false;
544         emit EndSale(true);
545     }
546 
547     function isActive() public view returns (bool) {
548         return SaleActive;
549     }
550 
551 
552     // Events
553     event Transfer(address indexed from, address indexed to, uint256 tokenId);
554     event Approval(address indexed owner, address indexed approved, uint256 tokenId);
555 
556     event RegionAllowSaleLands(uint16 regionId);
557     event ActivateMap(int256 x, int256 y, uint256 tokenId);
558     event AddRegion(uint16 indexed regionId);
559     event UpdateRegionPrice(uint16 indexed regionId, uint256 price);
560     event ChangeRegionName(uint16 indexed regionId, string regionName);
561     event TaxUpdate(uint16 indexed regionId, uint8 tax);
562     event RegionOnSale(uint16 indexed regionId);
563     event RegionNewBid(uint16 indexed regionId, address buyer, uint256 value, uint256 activeTill);
564     event AuctionStarts(uint16 indexed regionId);
565     event RegionSold(uint16 indexed regionId, address owner);
566     event Payout(address indexed to, uint256 value);
567     event RegionPayout(address indexed to, uint256 value);
568     event EndSale(bool isEnded);
569 }