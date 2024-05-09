1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title ERC721 Non-Fungible Token Standard basic interface
6  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
7  */
8 contract ERC721 {
9   // Required:
10     function approve(address to, uint256 tokenId) public; 
11     function balanceOf(address owner) public view returns (uint256 balance);
12     function implementsERC721() public pure returns (bool);
13     function ownerOf(uint256 tokenId) public view returns (address addr);
14     function takeOwnership(uint256 tokenId) public;
15     function totalSupply() public view returns (uint256 total);
16     function transferFrom(address from, address to, uint256 tokenId) public;
17     function transfer(address to, uint256 tokenId) public;
18 
19     event Transfer(address indexed from, address indexed to, uint256 tokenId);
20     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
21 
22     /** ERC721Metadata */ 
23     function name() external view returns (string name);
24     function symbol() external view returns (string symbol);
25     function tokenURI(uint256 _tokenId) external view returns (string uri); 
26   }
27 
28 
29 
30 /**
31  * @title ExoPlanets crypto game
32  * ExoPlanets is a space exploration crypto game with real data from NASA, that will allow the players to own ExoPlanets, 
33  * evolve life and civilizations all the way to the “Space Age” and send exploration ships to other 
34  * planets for resources and tokens mining.
35  * ExoPlanets is based on the ERC721 standard with several extensions (cryptoMatch, lifeRate..) to
36  * make the gaming experience more realistic (and exciting).
37  */
38 contract ExoplanetToken is ERC721 {
39 
40     using SafeMath for uint256; 
41     event Birth(uint256 indexed tokenId, string name, uint32 numOfTokensBonusOnPurchase, address owner);
42     event TokenSold(uint256 tokenId, uint256 oldPriceInEther, uint256 newPriceInEther, address prevOwner, address winner, string name);
43     event Transfer(address from, address to, uint256 tokenId);
44     event ContractUpgrade(address newContract);
45 
46     string public constant NAME = "ExoPlanets"; 
47 
48     string public constant SYMBOL = "XPL"; 
49 
50     string public constant BASE_URL = "https://exoplanets.io/metadata/planet_"; 
51 
52     uint32 private constant NUM_EXOPLANETS_LIMIT = 4700;  
53 
54     uint256 private constant STEP_1 =  5.0 ether; 
55     uint256 private constant STEP_2 = 10.0 ether;
56     uint256 private constant STEP_3 = 26.0 ether;
57     uint256 private constant STEP_4 = 36.0 ether;
58     uint256 private constant STEP_5 = 47.0 ether;
59     uint256 private constant STEP_6 = 59.0 ether;
60     uint256 private constant STEP_7 = 67.85 ether;
61     uint256 private constant STEP_8 = 76.67 ether;
62 
63     mapping (uint256 => address) public currentOwner;
64     mapping (address => uint256) private numOwnedTokens;
65     mapping (uint256 => address) public approvedToTransfer;
66     mapping (uint256 => uint256) private currentPrice;
67     address public ceoAddress;
68     address public cooAddress;
69 
70     bool public inPresaleMode = true;
71     bool public paused = false; 
72     address public newContractAddress;
73 
74     struct ExoplanetRec { 
75         uint8 lifeRate; 
76         uint32 priceInExoTokens; 
77         uint32 numOfTokensBonusOnPurchase; 
78         string name;
79         string cryptoMatch; 
80         string techBonus1;
81         string techBonus2;
82         string techBonus3;
83         string scientificData;
84     }
85 
86     ExoplanetRec[] private exoplanets;
87 
88     modifier onlyCEO() {
89       require(msg.sender == ceoAddress);
90       _;  
91     }
92 
93     modifier whenNotPaused() { 
94         require(!paused);
95         _;
96     }
97 
98     modifier whenPaused() { 
99         require(paused);
100         _;
101     }
102 
103     function pause() public onlyCEO() whenNotPaused() {
104       paused = true;
105     }
106 
107     function unpause() public onlyCEO() whenPaused() {
108       paused = false;
109     }
110 
111    
112     function setNewAddress(address _v2Address) public onlyCEO() whenPaused() {
113       newContractAddress = _v2Address;
114       ContractUpgrade(_v2Address);
115     }
116 
117 
118     modifier onlyCOO() {
119       require(msg.sender == cooAddress);
120       _;
121     }
122 
123     modifier presaleModeActive() {
124       require(inPresaleMode);
125       _;
126     }
127 
128     
129     modifier afterPresaleMode() {
130       require(!inPresaleMode);
131       _;
132     }
133 
134     
135 
136     modifier onlyCLevel() {
137       require(
138         msg.sender == ceoAddress ||
139         msg.sender == cooAddress
140       );
141       _;
142     }
143 
144     function setCEO(address newCEO) public onlyCEO {
145       require(newCEO != address(0));
146       ceoAddress = newCEO;
147     }
148 
149     function setCOO(address newCOO) public onlyCEO {
150       require(newCOO != address(0));
151       cooAddress = newCOO;
152     }
153     
154     function setPresaleMode(bool newMode) public onlyCEO {
155       inPresaleMode = newMode;
156     }    
157 
158     
159     function ExoplanetToken() public {
160         ceoAddress = msg.sender;
161         cooAddress = msg.sender;
162     }
163 
164     function approve(address to, uint256 tokenId) public {
165     
166         require(owns(msg.sender, tokenId));
167 
168         approvedToTransfer[tokenId] = to;
169 
170         Approval(msg.sender, to, tokenId);
171     }
172 
173     function balanceOf(address owner) public view returns (uint256 balance) {
174         balance = numOwnedTokens[owner];
175     }
176 
177 
178     function createContractExoplanet(
179           string name, uint256 priceInEther, uint32 priceInExoTokens, 
180           string cryptoMatch, uint32 numOfTokensBonusOnPurchase, 
181           uint8 lifeRate, string scientificData) public onlyCLevel { 
182 
183         _createExoplanet(name, address(this), priceInEther, priceInExoTokens, 
184               cryptoMatch, numOfTokensBonusOnPurchase, lifeRate, scientificData);
185     }
186 
187     
188     function getName(uint256 tokenId) public view returns (string) {
189       return exoplanets[tokenId].name;
190     }
191 
192     function getPriceInExoTokens(uint256 tokenId) public view returns (uint32) {
193       return exoplanets[tokenId].priceInExoTokens;
194     }
195 
196     function getLifeRate(uint256 tokenId) public view returns (uint8) {
197       return exoplanets[tokenId].lifeRate;
198     }
199 
200     function getNumOfTokensBonusOnPurchase(uint256 tokenId) public view returns (uint32) {
201       return exoplanets[tokenId].numOfTokensBonusOnPurchase;
202     }
203 
204     function getCryptoMatch(uint256 tokenId) public view returns (string) {
205       return exoplanets[tokenId].cryptoMatch;
206     }
207 
208     function getTechBonus1(uint256 tokenId) public view returns (string) {
209       return exoplanets[tokenId].techBonus1;
210     }
211 
212     function getTechBonus2(uint256 tokenId) public view returns (string) {
213       return exoplanets[tokenId].techBonus2;
214     }
215 
216     function getTechBonus3(uint256 tokenId) public view returns (string) {
217       return exoplanets[tokenId].techBonus3;
218     }
219 
220     function getScientificData(uint256 tokenId) public view returns (string) {
221       return exoplanets[tokenId].scientificData;
222     }
223 
224   
225     function setTechBonus1(uint256 tokenId, string newVal) public {
226 
227       require(owns(msg.sender, tokenId)); 
228       exoplanets[tokenId].techBonus1 = newVal;
229     }
230 
231     function setTechBonus2(uint256 tokenId, string newVal) public {
232       require(owns(msg.sender, tokenId)); 
233       exoplanets[tokenId].techBonus2 = newVal;
234     }
235 
236     function setTechBonus3(uint256 tokenId, string newVal) public {
237       require(owns(msg.sender, tokenId)); 
238       exoplanets[tokenId].techBonus3 = newVal;
239     }
240 
241     function setPriceInEth(uint256 tokenId, uint256 newPrice) public afterPresaleMode() {
242       require(owns(msg.sender, tokenId)); 
243       currentPrice[tokenId] = newPrice;
244     }
245 
246     function setPriceInExoTokens(uint256 tokenId, uint32 newPrice) public afterPresaleMode() {
247       require(owns(msg.sender, tokenId)); 
248       exoplanets[tokenId].priceInExoTokens = newPrice;
249     }
250 
251     function setScientificData(uint256 tokenId, string newData) public onlyCLevel { 
252       exoplanets[tokenId].scientificData = newData;
253     }
254 
255 
256     function getExoplanet(uint256 tokenId) public view returns ( 
257       string exoplanetName,
258       uint256 sellingPriceInEther,
259       address owner,
260       uint8 lifeRate,
261       uint32 priceInExoTokens,
262       uint32 numOfTokensBonusOnPurchase,
263       string cryptoMatch,
264       string scientificData) {
265 
266 
267       ExoplanetRec storage exoplanet = exoplanets[tokenId];       
268       exoplanetName = exoplanet.name;
269       lifeRate = exoplanet.lifeRate;
270       priceInExoTokens = exoplanet.priceInExoTokens;
271       numOfTokensBonusOnPurchase = exoplanet.numOfTokensBonusOnPurchase;
272       cryptoMatch = exoplanet.cryptoMatch;
273       scientificData = exoplanet.scientificData;
274       
275       sellingPriceInEther = currentPrice[tokenId];
276       owner = currentOwner[tokenId];
277     }  
278 
279 
280     function implementsERC721() public pure returns (bool) {
281       return true;
282     }
283 
284     function ownerOf(uint256 tokenId) public view returns (address owner) {   
285       owner = currentOwner[tokenId];
286     }
287 
288 
289     function transferUnownedPlanet(address newOwner, uint256 tokenId) public onlyCLevel { 
290       
291       require(currentOwner[tokenId] == address(this));
292 
293       require(newOwner != address(0));
294 
295       _transfer(currentOwner[tokenId], newOwner, tokenId);    
296 
297       TokenSold(tokenId, currentPrice[tokenId], currentPrice[tokenId], address(this), newOwner, exoplanets[tokenId].name);
298     }
299 
300 
301     function purchase(uint256 tokenId) public payable whenNotPaused() presaleModeActive() {
302     
303       require(currentOwner[tokenId] != msg.sender);
304 
305       require(addressNotNull(msg.sender));
306 
307       uint256 planetPrice = currentPrice[tokenId]; 
308 
309       require(msg.value >= planetPrice);
310 
311 
312       uint256 purchaseExcess = msg.value.sub(planetPrice); 
313 
314       uint paymentPrcnt;
315       uint stepPrcnt;
316 
317       if (planetPrice <= STEP_1) {        
318         paymentPrcnt = 93; 
319         stepPrcnt = 200;
320       } else if (planetPrice <= STEP_2) {
321         paymentPrcnt = 93; 
322         stepPrcnt = 150;
323       } else if (planetPrice <= STEP_3) {
324         paymentPrcnt = 93; 
325         stepPrcnt = 135;
326       } else if (planetPrice <= STEP_4) {
327         paymentPrcnt = 94; 
328         stepPrcnt = 125;
329       } else if (planetPrice <= STEP_5) {
330         paymentPrcnt = 94; 
331         stepPrcnt = 119;
332       } else if (planetPrice <= STEP_6) {
333         paymentPrcnt = 95; 
334         stepPrcnt = 117;    
335       } else if (planetPrice <= STEP_7) {
336         paymentPrcnt = 95; 
337         stepPrcnt = 115;
338       } else if (planetPrice <= STEP_8) {
339         paymentPrcnt = 95; 
340         stepPrcnt = 113;
341       } else {  
342         paymentPrcnt = 96; 
343         stepPrcnt = 110;
344       }
345 
346       currentPrice[tokenId] = planetPrice.mul(stepPrcnt).div(100);
347 
348       uint256 payment = uint256(planetPrice.mul(paymentPrcnt).div(100));
349 
350       address seller = currentOwner[tokenId];
351       
352       if (seller != address(this)) {  
353         seller.transfer(payment); 
354       }
355 
356       _transfer(seller, msg.sender, tokenId); 
357 
358       TokenSold(tokenId, planetPrice, currentPrice[tokenId], seller, msg.sender, exoplanets[tokenId].name);
359 
360       msg.sender.transfer(purchaseExcess); 
361     }
362 
363 
364     function priceOf(uint256 tokenId) public view returns (uint256) {
365       return currentPrice[tokenId];
366     }
367 
368 
369     function takeOwnership(uint256 tokenId) public whenNotPaused() { 
370 
371       require(addressNotNull(msg.sender));
372 
373       require(approved(msg.sender, tokenId));
374 
375       _transfer(currentOwner[tokenId], msg.sender, tokenId);
376     }
377 
378     
379     function tokensOfOwner(address owner) public view returns(uint256[] ownerTokens) {
380       uint256 tokenCount = balanceOf(owner);
381       if (tokenCount == 0) {
382         return new uint256[](0);
383       } else {
384         uint256[] memory result = new uint256[](tokenCount);
385         uint256 totalExoplanets = totalSupply();
386         uint256 resultIndex = 0;
387 
388         uint256 exoplanetId;
389         for (exoplanetId = 0; exoplanetId <= totalExoplanets; exoplanetId++) {
390           if (currentOwner[exoplanetId] == owner) {
391             result[resultIndex] = exoplanetId;
392             resultIndex++;
393           }
394         }
395         return result;
396       }
397     }
398 
399     function name() external view returns (string name) {
400       name = NAME;
401     }
402 
403 
404     function symbol() external view returns (string symbol) {
405       symbol = SYMBOL;
406     }
407 
408 
409     function tokenURI(uint256 _tokenId) external view returns (string uri) {
410       uri = appendNumToString(BASE_URL, _tokenId);
411     }
412 
413 
414     function totalSupply() public view returns (uint256 total) { 
415       total = exoplanets.length;
416     }
417 
418     
419     function transfer(address to, uint256 tokenId) public whenNotPaused() {
420       require(owns(msg.sender, tokenId));
421       require(addressNotNull(to));
422       _transfer(msg.sender, to, tokenId);
423     }
424 
425    
426     function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused() {
427       require(approved(from, tokenId));
428       require(addressNotNull(to));
429       _transfer(from, to, tokenId);
430     }
431 
432    
433     function addressNotNull(address addr) private pure returns (bool) {
434       return addr != address(0);
435     }
436 
437    
438     function approved(address to, uint256 tokenId) private view returns (bool) {
439       return approvedToTransfer[tokenId] == to;
440     }
441 
442     
443     function _createExoplanet(
444         string name, address owner, uint256 priceInEther, uint32 priceInExoTokens, 
445         string cryptoMatch, uint32 numOfTokensBonusOnPurchase, uint8 lifeRate, 
446         string scientificData) private {
447 
448       
449       require(totalSupply() < NUM_EXOPLANETS_LIMIT);
450 
451       ExoplanetRec memory _exoplanet = ExoplanetRec({  
452         name: name,
453         priceInExoTokens: priceInExoTokens,
454         cryptoMatch: cryptoMatch,
455         numOfTokensBonusOnPurchase: numOfTokensBonusOnPurchase,
456         lifeRate: lifeRate,
457         techBonus1: "",
458         techBonus2: "",
459         techBonus3: "",
460         scientificData: scientificData
461       });
462       uint256 newExoplanetId = exoplanets.push(_exoplanet) - 1;
463 
464       
465       require(newExoplanetId == uint256(uint32(newExoplanetId)));
466 
467       Birth(newExoplanetId, name, numOfTokensBonusOnPurchase, owner);
468 
469       currentPrice[newExoplanetId] = priceInEther;
470 
471       
472       _transfer(address(0), owner, newExoplanetId);
473     }
474 
475 
476     
477     function owns(address claimant, uint256 tokenId) private view returns (bool) {
478       return claimant == currentOwner[tokenId];
479     }
480 
481     function payout() public onlyCLevel {
482       ceoAddress.transfer(this.balance);
483     }
484 
485     function payoutPartial(uint256 amount) public onlyCLevel {
486       require(amount <= this.balance);
487       ceoAddress.transfer(amount);
488     }
489 
490     
491     function _transfer(address from, address to, uint256 tokenId) private {
492       
493       numOwnedTokens[to]++;
494 
495       
496       currentOwner[tokenId] = to;
497 
498       
499       if (from != address(0)) {
500         numOwnedTokens[from]--;
501       
502         delete approvedToTransfer[tokenId];
503       }
504 
505      
506       Transfer(from, to, tokenId);
507     }
508 
509     function appendNumToString(string baseUrl, uint256 tokenId) private pure returns (string) {
510       string memory _b = numToString(tokenId);
511       bytes memory bytes_a = bytes(baseUrl);
512       bytes memory bytes_b = bytes(_b);
513       string memory length_ab = new string(bytes_a.length + bytes_b.length);
514       bytes memory bytes_c = bytes(length_ab);
515       uint k = 0;
516       for (uint i = 0; i < bytes_a.length; i++) {
517         bytes_c[k++] = bytes_a[i];
518       }
519       for (i = 0; i < bytes_b.length; i++) {
520         bytes_c[k++] = bytes_b[i];
521       }
522       return string(bytes_c);
523     }
524 
525     function numToString(uint256 tokenId) private pure returns (string str) {
526       uint uintVal = uint(tokenId);
527       bytes32 bytes32Val = uintToBytes32(uintVal);  
528       return bytes32ToString(bytes32Val);
529     }
530 
531     function uintToBytes32(uint v) private pure returns (bytes32 ret) {
532       if (v == 0) {
533           ret = '0';
534       }
535       else {
536           while (v > 0) {
537               ret = bytes32(uint(ret) / (2 ** 8));
538               ret |= bytes32(((v % 10) + 48) * 2 ** (8 * 31));
539               v /= 10;
540           }
541       }
542       return ret;
543     }    
544 
545     function bytes32ToString(bytes32 x) private pure returns (string) {
546       bytes memory bytesString = new bytes(32);
547       uint charCount = 0;
548       for (uint j = 0; j < 32; j++) {
549           byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
550           if (char != 0) {
551               bytesString[charCount] = char;
552               charCount++;
553           }
554       }
555       bytes memory bytesStringTrimmed = new bytes(charCount);
556       for (j = 0; j < charCount; j++) {
557           bytesStringTrimmed[j] = bytesString[j];
558       }
559       return string(bytesStringTrimmed);
560     }    
561 
562 }
563 
564 
565 library SafeMath {
566 
567     /**
568     * @dev Multiplies two numbers, throws on overflow.
569     */
570     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
571       if (a == 0) {
572         return 0;
573       }
574       uint256 c = a * b;
575       assert(c / a == b);
576       return c;
577     }
578 
579     /**
580     * @dev Integer division of two numbers, truncating the quotient.
581     */
582     function div(uint256 a, uint256 b) internal pure returns (uint256) {
583       // assert(b > 0); // Solidity automatically throws when dividing by 0
584       uint256 c = a / b;
585       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
586       return c;
587     }
588 
589     /**
590     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
591     */
592     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
593       assert(b <= a);
594       return a - b;
595     }
596 
597     /**
598     * @dev Adds two numbers, throws on overflow.
599     */
600     function add(uint256 a, uint256 b) internal pure returns (uint256) {
601       uint256 c = a + b;
602       assert(c >= a);
603       return c;
604     }
605 }