1 pragma solidity ^0.4.19;
2 
3 
4 contract ERC721 {
5     function approve(address to, uint256 tokenId) public;
6     function balanceOf(address owner) public view returns (uint256 balance);
7     function implementsERC721() public pure returns (bool);
8     function ownerOf(uint256 tokenId) public view returns (address addr);
9     function takeOwnership(uint256 tokenId) public;
10     function totalSupply() public view returns (uint256 total);
11     function transferFrom(address from, address to, uint256 tokenId) public;
12     function transfer(address to, uint256 tokenId) public;
13 
14     event Transfer(address indexed from, address indexed to, uint256 tokenId);
15     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
16 
17     function name() external view returns (string name);
18     function symbol() external view returns (string symbol);
19     function tokenURI(uint256 _tokenId) external view returns (string uri);
20   }
21 
22 
23 contract ExoplanetToken is ERC721 {
24 
25     using SafeMath for uint256;
26 
27     event Birth(uint256 indexed tokenId, string name, uint32 numOfTokensBonusOnPurchase, address owner);
28 
29     event TokenSold(uint256 tokenId, uint256 oldPriceInEther, uint256 newPriceInEther, address prevOwner, address winner, string name);
30 
31     event Transfer(address from, address to, uint256 tokenId);
32 
33     event ContractUpgrade(address newContract);
34 
35 
36     string private constant CONTRACT_NAME = "ExoPlanets";
37 
38     string private constant CONTRACT_SYMBOL = "XPL";
39 
40     string public constant BASE_URL = "https://exoplanets.io/metadata/planet_";
41 
42     uint32 private constant NUM_EXOPLANETS_LIMIT = 10000;
43 
44     uint256 private constant STEP_1 =  5.0 ether;
45     uint256 private constant STEP_2 = 10.0 ether;
46     uint256 private constant STEP_3 = 26.0 ether;
47     uint256 private constant STEP_4 = 36.0 ether;
48     uint256 private constant STEP_5 = 47.0 ether;
49     uint256 private constant STEP_6 = 59.0 ether;
50     uint256 private constant STEP_7 = 67.85 ether;
51     uint256 private constant STEP_8 = 76.67 ether;
52 
53 
54     mapping (uint256 => address) public currentOwner;
55 
56     mapping (address => uint256) private numOwnedTokens;
57 
58     mapping (uint256 => address) public approvedToTransfer;
59 
60     mapping (uint256 => uint256) private currentPrice;
61 
62     address public ceoAddress;
63     address public cooAddress;
64 
65     bool public inPresaleMode = true;
66 
67     bool public paused = false;
68 
69     bool public allowMigrate = true;
70 
71     address public newContractAddress;
72 
73     bool public _allowBuyDirect = false;
74 
75 
76     struct ExoplanetRec {
77         uint8 lifeRate;
78         bool canBePurchased;
79         uint32 priceInExoTokens;
80         uint32 numOfTokensBonusOnPurchase;
81         string name;
82         string nickname;
83         string cryptoMatch;
84         string techBonus1;
85         string techBonus2;
86         string techBonus3;
87         string scientificData;
88     }
89 
90     ExoplanetRec[] private exoplanets;
91 
92     address public marketplaceAddress;
93 
94 
95     modifier onlyCEO() {
96       require(msg.sender == ceoAddress);
97       _;
98     }
99 
100 
101     modifier migrateAllowed() {
102         require(allowMigrate);
103         _;
104     }
105 
106     modifier whenNotPaused() {
107         require(!paused);
108         _;
109     }
110 
111     modifier whenPaused() {
112         require(paused);
113         _;
114     }
115 
116     function turnMigrateOff() public onlyCEO() {
117       allowMigrate = false;
118     }
119 
120     function pause() public onlyCEO() whenNotPaused() {
121       paused = true;
122     }
123 
124     function unpause() public onlyCEO() whenPaused() {
125       paused = false;
126     }
127 
128     modifier allowBuyDirect() {
129       require(_allowBuyDirect);
130       _;
131     }
132 
133    function setBuyDirectMode(bool newMode, address newMarketplace) public onlyCEO {
134       _allowBuyDirect = newMode;
135       marketplaceAddress = newMarketplace;
136     }
137 
138 
139     function setPurchaseableMode(uint256 tokenId, bool _canBePurchased, uint256 _newPrice) public afterPresaleMode() {
140       require(owns(msg.sender, tokenId));
141       exoplanets[tokenId].canBePurchased = _canBePurchased;
142       setPriceInEth(tokenId, _newPrice);
143     }
144 
145 
146     function getPurchaseableMode(uint256 tokenId) public view returns (bool) {
147       return exoplanets[tokenId].canBePurchased;
148     }
149 
150     function setNewAddress(address _v2Address) public onlyCEO() whenPaused() {
151       newContractAddress = _v2Address;
152       ContractUpgrade(_v2Address);
153     }
154 
155 
156     modifier onlyCOO() {
157       require(msg.sender == cooAddress);
158       _;
159     }
160 
161     modifier presaleModeActive() {
162       require(inPresaleMode);
163       _;
164     }
165 
166 
167     modifier afterPresaleMode() {
168       require(!inPresaleMode);
169       _;
170     }
171 
172 
173     modifier onlyCLevel() {
174       require(
175         msg.sender == ceoAddress ||
176         msg.sender == cooAddress
177       );
178       _;
179     }
180 
181     function setCEO(address newCEO) public onlyCEO {
182       require(newCEO != address(0));
183       ceoAddress = newCEO;
184     }
185 
186     function setCOO(address newCOO) public onlyCEO {
187       require(newCOO != address(0));
188       cooAddress = newCOO;
189     }
190 
191     function setPresaleMode(bool newMode) public onlyCEO {
192       inPresaleMode = newMode;
193     }
194 
195 
196     /*** CONSTRUCTOR ***/
197     function ExoplanetToken() public {
198         ceoAddress = msg.sender;
199         cooAddress = msg.sender;
200         marketplaceAddress = msg.sender;
201     }
202 
203 
204     function approve(address to, uint256 tokenId) public {
205         require(owns(msg.sender, tokenId));
206 
207         approvedToTransfer[tokenId] = to;
208 
209         Approval(msg.sender, to, tokenId);
210     }
211 
212     function balanceOf(address owner) public view returns (uint256 balance) {
213         balance = numOwnedTokens[owner];
214     }
215 
216     function bytes32ToString(bytes32 x) private pure returns (string) {
217         bytes memory bytesString = new bytes(32);
218         uint charCount = 0;
219         for (uint j = 0; j < 32; j++) {
220             byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
221             if (char != 0) {
222                 bytesString[charCount] = char;
223                 charCount++;
224             }
225         }
226         bytes memory bytesStringTrimmed = new bytes(charCount);
227         for (j = 0; j < charCount; j++) {
228             bytesStringTrimmed[j] = bytesString[j];
229         }
230         return string(bytesStringTrimmed);
231     }
232 
233     function migrateSinglePlanet(
234           uint256 origTokenId, string name, uint256 priceInEther, uint32 priceInExoTokens,
235           string cryptoMatch, uint32 numOfTokensBonusOnPurchase,
236           uint8 lifeRate, string scientificData, address owner) public onlyCLevel migrateAllowed {
237 
238         _migrateExoplanet(origTokenId, name, priceInEther, priceInExoTokens,
239               cryptoMatch, numOfTokensBonusOnPurchase, lifeRate, scientificData, owner);
240     }
241 
242 
243     function _migrateExoplanet(
244         uint256 origTokenId, string name, uint256 priceInEther, uint32 priceInExoTokens,
245         string cryptoMatch, uint32 numOfTokensBonusOnPurchase, uint8 lifeRate,
246         string scientificData, address owner) private {
247 
248       require(totalSupply() < NUM_EXOPLANETS_LIMIT);
249 
250       require(origTokenId == uint256(uint32(origTokenId)));
251 
252       ExoplanetRec memory _exoplanet = ExoplanetRec({
253         name: name,
254         nickname: "",
255         priceInExoTokens: priceInExoTokens,
256         cryptoMatch: cryptoMatch,
257         numOfTokensBonusOnPurchase: numOfTokensBonusOnPurchase,
258         lifeRate: lifeRate,
259         techBonus1: "",
260         techBonus2: "",
261         techBonus3: "",
262         scientificData: scientificData,
263         canBePurchased: false
264       });
265 
266       uint256 tokenId = exoplanets.push(_exoplanet) - 1;
267 
268       currentPrice[tokenId] = priceInEther;
269 
270       numOwnedTokens[owner]++;
271       exoplanets[tokenId].canBePurchased = false;
272       currentOwner[tokenId] = owner;
273     }
274 
275 
276     function createContractExoplanet(
277           string name, uint256 priceInEther, uint32 priceInExoTokens,
278           string cryptoMatch, uint32 numOfTokensBonusOnPurchase,
279           uint8 lifeRate, string scientificData) public onlyCLevel returns (uint256) {
280 
281         return _createExoplanet(name, address(this), priceInEther, priceInExoTokens,
282               cryptoMatch, numOfTokensBonusOnPurchase, lifeRate,
283               scientificData);
284     }
285 
286     function _createExoplanet(
287         string name, address owner, uint256 priceInEther, uint32 priceInExoTokens,
288         string cryptoMatch, uint32 numOfTokensBonusOnPurchase, uint8 lifeRate,
289         string scientificData) private returns (uint256) {
290 
291       require(totalSupply() < NUM_EXOPLANETS_LIMIT);
292 
293       ExoplanetRec memory _exoplanet = ExoplanetRec({
294         name: name,
295         nickname: "",
296         priceInExoTokens: priceInExoTokens,
297         cryptoMatch: cryptoMatch,
298         numOfTokensBonusOnPurchase: numOfTokensBonusOnPurchase,
299         lifeRate: lifeRate,
300         techBonus1: "",
301         techBonus2: "",
302         techBonus3: "",
303         scientificData: scientificData,
304         canBePurchased: false
305       });
306       uint256 newExoplanetId = exoplanets.push(_exoplanet) - 1;
307 
308       require(newExoplanetId == uint256(uint32(newExoplanetId)));
309 
310       Birth(newExoplanetId, name, numOfTokensBonusOnPurchase, owner);
311 
312       currentPrice[newExoplanetId] = priceInEther;
313 
314       _transfer(address(0), owner, newExoplanetId);
315 
316       return newExoplanetId;
317     }
318 
319 
320     function unownedPlanet(uint256 tokenId) private view returns (bool) {
321       return currentOwner[tokenId] == address(this);
322     }
323 
324     function getPlanetName(uint256 tokenId) public view returns (string) {
325       return exoplanets[tokenId].name;
326     }
327     function getNickname(uint256 tokenId) public view returns (string) {
328       return exoplanets[tokenId].nickname;
329     }
330 
331     function getPriceInExoTokens(uint256 tokenId) public view returns (uint32) {
332       return exoplanets[tokenId].priceInExoTokens;
333     }
334 
335     function getLifeRate(uint256 tokenId) public view returns (uint8) {
336       return exoplanets[tokenId].lifeRate;
337     }
338 
339     function getNumOfTokensBonusOnPurchase(uint256 tokenId) public view returns (uint32) {
340       return exoplanets[tokenId].numOfTokensBonusOnPurchase;
341     }
342 
343     function getCryptoMatch(uint256 tokenId) public view returns (string) {
344       return exoplanets[tokenId].cryptoMatch;
345     }
346 
347     function getTechBonus1(uint256 tokenId) public view returns (string) {
348       return exoplanets[tokenId].techBonus1;
349     }
350 
351     function getTechBonus2(uint256 tokenId) public view returns (string) {
352       return exoplanets[tokenId].techBonus2;
353     }
354 
355     function getTechBonus3(uint256 tokenId) public view returns (string) {
356       return exoplanets[tokenId].techBonus3;
357     }
358 
359     function getScientificData(uint256 tokenId) public view returns (string) {
360       return exoplanets[tokenId].scientificData;
361     }
362 
363 
364     function setTechBonus1(uint256 tokenId, string newVal) public {
365       require(msg.sender == marketplaceAddress || msg.sender == ceoAddress);
366       exoplanets[tokenId].techBonus1 = newVal;
367     }
368 
369     function setTechBonus2(uint256 tokenId, string newVal) public {
370       require(msg.sender == marketplaceAddress || msg.sender == ceoAddress);
371       exoplanets[tokenId].techBonus2 = newVal;
372     }
373 
374     function setTechBonus3(uint256 tokenId, string newVal) public {
375       require(msg.sender == marketplaceAddress || msg.sender == ceoAddress);
376       exoplanets[tokenId].techBonus3 = newVal;
377     }
378 
379     function setPriceInEth(uint256 tokenId, uint256 newPrice) public afterPresaleMode() {
380       require(owns(msg.sender, tokenId));
381       currentPrice[tokenId] = newPrice;
382     }
383 
384     function setUnownedPriceInEth(uint256 tokenId, uint256 newPrice) public onlyCLevel {
385       require(unownedPlanet(tokenId));
386       currentPrice[tokenId] = newPrice;
387     }
388 
389     function setUnownedPurchaseableMode(uint256 tokenId, bool _canBePurchased) public onlyCLevel {
390       require(unownedPlanet(tokenId));
391       exoplanets[tokenId].canBePurchased = _canBePurchased;
392     }
393 
394     function setPriceInExoTokens(uint256 tokenId, uint32 newPrice) public afterPresaleMode() {
395       require(owns(msg.sender, tokenId));
396       exoplanets[tokenId].priceInExoTokens = newPrice;
397     }
398 
399     function setUnownedPriceInExoTokens(uint256 tokenId, uint32 newPrice) public onlyCLevel {
400       require(unownedPlanet(tokenId));
401       exoplanets[tokenId].priceInExoTokens = newPrice;
402     }
403 
404     function setScientificData(uint256 tokenId, string newData) public onlyCLevel {
405       exoplanets[tokenId].scientificData = newData;
406     }
407 
408     function setUnownedName(uint256 tokenId, string newData) public onlyCLevel {
409       require(unownedPlanet(tokenId));
410       exoplanets[tokenId].name = newData;
411     }
412 
413     function setUnownedNickname(uint256 tokenId, string newData) public onlyCLevel {
414       require(unownedPlanet(tokenId));
415       exoplanets[tokenId].nickname = newData;
416     }
417 
418     function setCryptoMatchValue(uint256 tokenId, string newData) public onlyCLevel {
419       exoplanets[tokenId].cryptoMatch = newData;
420     }
421 
422     function setUnownedNumOfExoTokensBonus(uint256 tokenId, uint32 newData) public onlyCLevel {
423       require(unownedPlanet(tokenId));
424       exoplanets[tokenId].numOfTokensBonusOnPurchase = newData;
425     }
426 
427      function setUnownedLifeRate(uint256 tokenId, uint8 newData) public onlyCLevel {
428       require(unownedPlanet(tokenId));
429       exoplanets[tokenId].lifeRate = newData;
430     }
431 
432 
433 
434     function getExoplanet(uint256 tokenId) public view returns (
435         uint8 lifeRate,
436         bool canBePurchased,
437         uint32 priceInExoTokens,
438         uint32 numOfTokensBonusOnPurchase,
439         string name,
440         string nickname,
441         string cryptoMatch,
442         string scientificData,
443         uint256 sellingPriceInEther,
444         address owner) {
445 
446       ExoplanetRec storage exoplanet = exoplanets[tokenId];
447 
448       lifeRate = exoplanet.lifeRate;
449       canBePurchased = exoplanet.canBePurchased;
450       priceInExoTokens = exoplanet.priceInExoTokens;
451       numOfTokensBonusOnPurchase = exoplanet.numOfTokensBonusOnPurchase;
452       name = exoplanet.name;
453       nickname = exoplanet.nickname;
454       cryptoMatch = exoplanet.cryptoMatch;
455       scientificData = exoplanet.scientificData;
456 
457       sellingPriceInEther = currentPrice[tokenId];
458       owner = currentOwner[tokenId];
459     }
460 
461 
462     function implementsERC721() public pure returns (bool) {
463       return true;
464     }
465 
466     function ownerOf(uint256 tokenId) public view returns (address owner) {
467       owner = currentOwner[tokenId];
468     }
469 
470 
471     function transferUnownedPlanet(address newOwner, uint256 tokenId) public onlyCLevel {
472 
473       require(unownedPlanet(tokenId));
474 
475       require(newOwner != address(0));
476 
477       _transfer(currentOwner[tokenId], newOwner, tokenId);
478 
479       TokenSold(tokenId, currentPrice[tokenId], currentPrice[tokenId], address(this), newOwner, exoplanets[tokenId].name);
480     }
481 
482 
483     function purchase(uint256 tokenId) public payable whenNotPaused() presaleModeActive() {
484 
485       require(currentOwner[tokenId] != msg.sender);
486 
487       require(addressNotNull(msg.sender));
488 
489       uint256 planetPrice = currentPrice[tokenId];
490 
491       require(msg.value >= planetPrice);
492 
493       uint paymentPrcnt;
494       uint stepPrcnt;
495 
496       if (planetPrice <= STEP_1) {
497         paymentPrcnt = 93;
498         stepPrcnt = 200;
499       } else if (planetPrice <= STEP_2) {
500         paymentPrcnt = 93;
501         stepPrcnt = 150;
502       } else if (planetPrice <= STEP_3) {
503         paymentPrcnt = 93;
504         stepPrcnt = 135;
505       } else if (planetPrice <= STEP_4) {
506         paymentPrcnt = 94;
507         stepPrcnt = 125;
508       } else if (planetPrice <= STEP_5) {
509         paymentPrcnt = 94;
510         stepPrcnt = 119;
511       } else if (planetPrice <= STEP_6) {
512         paymentPrcnt = 95;
513         stepPrcnt = 117;
514       } else if (planetPrice <= STEP_7) {
515         paymentPrcnt = 95;
516         stepPrcnt = 115;
517       } else if (planetPrice <= STEP_8) {
518         paymentPrcnt = 95;
519         stepPrcnt = 113;
520       } else {
521         paymentPrcnt = 96;
522         stepPrcnt = 110;
523       }
524 
525       currentPrice[tokenId] = planetPrice.mul(stepPrcnt).div(100);
526 
527       uint256 payment = uint256(planetPrice.mul(paymentPrcnt).div(100));
528 
529       address seller = currentOwner[tokenId];
530 
531       if (seller != address(this)) {
532         seller.transfer(payment);
533       }
534 
535       _transfer(seller, msg.sender, tokenId);
536 
537       TokenSold(tokenId, planetPrice, currentPrice[tokenId], seller, msg.sender, exoplanets[tokenId].name);
538 
539     }
540 
541 
542 
543     function buyDirectInMarketplace(uint256 tokenId) public payable
544                     whenNotPaused() afterPresaleMode() allowBuyDirect() {
545 
546       require(exoplanets[tokenId].canBePurchased);
547 
548       uint256 planetPrice = currentPrice[tokenId];
549 
550       require(msg.value >= planetPrice);
551 
552       address seller = currentOwner[tokenId];
553 
554       if (seller != address(this)) {
555         seller.transfer(planetPrice);
556       }
557 
558       _transfer(seller, msg.sender, tokenId);
559 
560       TokenSold(tokenId, planetPrice, currentPrice[tokenId], seller, msg.sender, exoplanets[tokenId].name);
561     }
562 
563 
564     function priceOf(uint256 tokenId) public view returns (uint256) {
565       return currentPrice[tokenId];
566     }
567 
568 
569     function takeOwnership(uint256 tokenId) public whenNotPaused() {
570 
571       require(addressNotNull(msg.sender));
572 
573       require(approved(msg.sender, tokenId));
574 
575       _transfer(currentOwner[tokenId], msg.sender, tokenId);
576     }
577 
578     function tokensOfOwner(address owner) public view returns(uint256[] ownerTokens) {
579       uint256 tokenCount = balanceOf(owner);
580       if (tokenCount == 0) {
581         return new uint256[](0);
582       } else {
583         uint256[] memory result = new uint256[](tokenCount);
584         uint256 totalExoplanets = totalSupply();
585         uint256 resultIndex = 0;
586 
587         uint256 exoplanetId;
588         for (exoplanetId = 0; exoplanetId <= totalExoplanets; exoplanetId++) {
589           if (currentOwner[exoplanetId] == owner) {
590             result[resultIndex] = exoplanetId;
591             resultIndex++;
592           }
593         }
594         return result;
595       }
596     }
597 
598     function name() external view returns (string name) {
599       name = CONTRACT_NAME;
600     }
601 
602     function symbol() external view returns (string symbol) {
603       symbol = CONTRACT_SYMBOL;
604     }
605 
606     function tokenURI(uint256 _tokenId) external view returns (string uri) {
607       uri = appendNumToString(BASE_URL, _tokenId);
608     }
609 
610     function totalSupply() public view returns (uint256 total) {
611       total = exoplanets.length;
612     }
613 
614     function transfer(address to, uint256 tokenId) public whenNotPaused() {
615       require(owns(msg.sender, tokenId));
616       require(addressNotNull(to));
617       _transfer(msg.sender, to, tokenId);
618     }
619 
620     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused() {
621       require(owns(from, tokenId));
622       require(approved(msg.sender, tokenId));
623       require(addressNotNull(to));
624       _transfer(from, to, tokenId);
625     }
626 
627     function addressNotNull(address addr) private pure returns (bool) {
628       return addr != address(0);
629     }
630 
631     function approved(address to, uint256 tokenId) private view returns (bool) {
632       return approvedToTransfer[tokenId] == to;
633     }
634 
635 
636     function owns(address claimant, uint256 tokenId) private view returns (bool) {
637       return claimant == currentOwner[tokenId];
638     }
639 
640     function payout() public onlyCLevel {
641       ceoAddress.transfer(this.balance);
642     }
643 
644     function payoutPartial(uint256 amount) public onlyCLevel {
645       require(amount <= this.balance);
646       ceoAddress.transfer(amount);
647     }
648 
649 
650     function _transfer(address from, address to, uint256 tokenId) private {
651       numOwnedTokens[to]++;
652 
653       exoplanets[tokenId].canBePurchased = false;
654 
655       currentOwner[tokenId] = to;
656 
657       if (from != address(0)) {
658         numOwnedTokens[from]--;
659         delete approvedToTransfer[tokenId];
660       }
661 
662       Transfer(from, to, tokenId);
663     }
664 
665     function appendNumToString(string baseUrl, uint256 tokenId) private pure returns (string) {
666       string memory _b = numToString(tokenId);
667       bytes memory bytes_a = bytes(baseUrl);
668       bytes memory bytes_b = bytes(_b);
669       string memory length_ab = new string(bytes_a.length + bytes_b.length);
670       bytes memory bytes_c = bytes(length_ab);
671       uint k = 0;
672       for (uint i = 0; i < bytes_a.length; i++) {
673         bytes_c[k++] = bytes_a[i];
674       }
675       for (i = 0; i < bytes_b.length; i++) {
676         bytes_c[k++] = bytes_b[i];
677       }
678       return string(bytes_c);
679     }
680 
681     function numToString(uint256 tokenId) private pure returns (string str) {
682       uint uintVal = uint(tokenId);
683       bytes32 bytes32Val = uintToBytes32(uintVal);
684       return bytes32ToString(bytes32Val);
685     }
686 
687     function uintToBytes32(uint v) private pure returns (bytes32 ret) {
688       if (v == 0) {
689           ret = '0';
690       }
691       else {
692           while (v > 0) {
693               ret = bytes32(uint(ret) / (2 ** 8));
694               ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
695               v /= 10;
696           }
697       }
698       return ret;
699     }
700 
701 }
702 
703 
704 library SafeMath {
705 
706     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
707       if (a == 0) {
708         return 0;
709       }
710       uint256 c = a * b;
711       assert(c / a == b);
712       return c;
713     }
714 
715     function div(uint256 a, uint256 b) internal pure returns (uint256) {
716       uint256 c = a / b;
717       return c;
718     }
719 
720     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
721       assert(b <= a);
722       return a - b;
723     }
724 
725     function add(uint256 a, uint256 b) internal pure returns (uint256) {
726       uint256 c = a + b;
727       assert(c >= a);
728       return c;
729     }
730 }