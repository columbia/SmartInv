1 pragma solidity ^0.4.23;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         if (newOwner != address(0)) {
17             owner = newOwner;
18         }
19     }
20 }
21 
22 contract token {
23     function totalSupply() public view returns (uint total);
24     function balanceOf(address _owner) public view returns (uint balance);
25     function ownerOf(uint _tokenId) external view returns (address owner);
26     function approve(address _to, uint _tokenId) external;
27     function transfer(address _to, uint _tokenId) external;
28     function transferFrom(address _from, address _to, uint _tokenId) external;
29 
30     event Transfer(address from, address to, uint tokenId);
31     event Approval(address owner, address approved, uint tokenId);
32 
33     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
34 }
35 
36 
37 contract AccessControl {
38     
39     event ContractUpgrade(address newContract);
40 
41     address public ceoAddress;
42     address public cooAddress;
43 
44     bool public paused = false;
45 
46     modifier onlyCEO() {
47         require(msg.sender == ceoAddress);
48         _;
49     }
50 
51     modifier onlyCOO() {
52         require(msg.sender == cooAddress);
53         _;
54     }
55 
56     modifier onlyCLevel() {
57         require(
58             msg.sender == cooAddress ||
59             msg.sender == ceoAddress
60         );
61         _;
62     }
63 
64     function setCEO(address _newCEO) external onlyCEO {
65         require(_newCEO != address(0));
66 
67         ceoAddress = _newCEO;
68     }
69 
70     function setCOO(address _newCOO) external onlyCEO {
71         require(_newCOO != address(0));
72 
73         cooAddress = _newCOO;
74     }
75 
76     modifier whenNotPaused() {
77         require(!paused);
78         _;
79     }
80 
81     modifier whenPaused {
82         require(paused);
83         _;
84     }
85 
86     function pause() external onlyCLevel whenNotPaused {
87         paused = true;
88     }
89 
90     function unpause() public onlyCEO whenPaused {
91         paused = false;
92     }
93 }
94 
95 contract Base is AccessControl {
96 
97     event Birth(address owner, uint clownId, uint matronId, uint sireId, uint genes);
98 
99     event Transfer(address from, address to, uint tokenId);
100 
101     event Match(uint clownId, uint price, address seller, address buyer);
102 
103     struct Clown {
104         uint genes;
105         uint64 birthTime;
106         uint32 matronId;
107         uint32 sireId;
108         uint16 sex; // 1 0
109         uint16 cooldownIndex;
110         uint16 generation;
111         uint16 growthAddition;
112         uint16 attrPower;
113         uint16 attrAgile;
114         uint16 attrWisdom;
115     }
116     
117     uint16[] digList = [300, 500, 800, 900, 950, 1000];
118 
119     uint16[] rankList;
120 
121     uint rankNum;
122     uint16[] spRank1 = [5, 25, 75, 95, 99, 100]; 
123     uint16[] spRank2 = [15, 50, 90, 100, 0, 0];  
124     uint16[] norRank1 = [10, 50, 85, 99, 100, 0];
125     uint16[] norRank2 = [25, 70, 100, 0, 0, 0];
126 
127 
128     Clown[] clowns;
129 
130     mapping (uint => address) public clownIndexToOwner;
131 
132     mapping (address => uint) ownershipTokenCount;
133 
134     mapping (uint => address) public clownIndexToApproved;
135 
136     uint _seed = now;
137 
138 
139     function _random(uint size) internal returns (uint) {
140         _seed = uint(keccak256(keccak256(block.number, _seed), now));
141         return _seed % size;
142     }
143 
144     function _subGene(uint _gene, uint _start, uint _len) internal pure returns (uint) {
145       uint result = _gene % (10**(_start+_len));
146       result = result / (10**_start);
147       return result;
148     }
149 
150     function _transfer(address _from, address _to, uint _tokenId) internal {
151         ownershipTokenCount[_to]++;
152         clownIndexToOwner[_tokenId] = _to;
153         if (_from != address(0)) {
154             ownershipTokenCount[_from]--;
155             delete clownIndexToApproved[_tokenId];
156         }
157         Transfer(_from, _to, _tokenId);
158     }
159 
160     function _createClown(
161         uint _matronId,
162         uint _sireId,
163         uint _generation,
164         uint _genes,
165         address _owner
166     )
167         internal
168         returns (uint)
169     {
170         require(_matronId == uint(uint32(_matronId)));
171         require(_sireId == uint(uint32(_sireId)));
172         require(_generation == uint(uint16(_generation)));
173 
174         uint16 cooldownIndex = uint16(_generation / 2);
175         if (cooldownIndex > 8) {
176             cooldownIndex = 8;
177         }
178         uint16[] memory randomValue = new uint16[](3);
179         
180         uint spAttr = _random(3);
181         for (uint j = 0; j < 3; j++) {
182             if (spAttr == j) {
183                 if (_generation == 0 || _subGene(_genes, 0, 2) >= 30) {
184                     rankList = spRank1;
185                 } else {
186                     rankList = spRank2;
187                 }
188             } else {
189                 if (_generation == 0 || _subGene(_genes, 0, 2) >= 30) {
190                     rankList = norRank1;
191                 } else {
192                     rankList = norRank2;
193                 }
194             }
195 
196             uint digNum = _random(100);
197             rankNum = 10;
198             for (uint k = 0; k < 6; k++) {
199                 if (rankList[k] >= digNum && rankNum == 10) {
200                     rankNum = k;
201                 }
202             }
203             
204             if (rankNum == 0 || rankNum == 10) {
205                 randomValue[j] = 100 + uint16(_random(_genes) % 200);
206             } else {
207                 randomValue[j] = digList[rankNum - 1] + uint16(_random(_genes) % (digList[rankNum] - digList[rankNum - 1]));
208             }
209         }
210 
211         Clown memory _clown = Clown({
212             genes: _genes,
213             birthTime: uint64(now),
214             matronId: uint32(_matronId),
215             sireId: uint32(_sireId),
216             sex: uint16(_genes % 2),
217             cooldownIndex: cooldownIndex,
218             generation: uint16(_generation),
219             growthAddition: 0,
220             attrPower: randomValue[0],
221             attrAgile: randomValue[1],
222             attrWisdom: randomValue[2]
223         });
224         uint newClownId = clowns.push(_clown) - 1;
225 
226         require(newClownId == uint(uint32(newClownId)));
227 
228         Birth(
229             _owner,
230             newClownId,
231             uint(_clown.matronId),
232             uint(_clown.sireId),
233             _clown.genes
234         );
235 
236         _transfer(0, _owner, newClownId);
237 
238         return newClownId;
239     }
240 
241 }
242 
243 contract Ownership is Base, token, owned {
244 
245     string public constant name = "CryptoClown";
246     string public constant symbol = "CC";
247 
248     uint public promoTypeNum;
249 
250     bytes4 constant InterfaceSignature_ERC165 =
251         bytes4(keccak256('supportsInterface(bytes4)'));
252 
253     bytes4 constant InterfaceSignature_ERC721 =
254         bytes4(keccak256('name()')) ^
255         bytes4(keccak256('symbol()')) ^
256         bytes4(keccak256('totalSupply()')) ^
257         bytes4(keccak256('balanceOf(address)')) ^
258         bytes4(keccak256('ownerOf(uint)')) ^
259         bytes4(keccak256('approve(address,uint)')) ^
260         bytes4(keccak256('transfer(address,uint)')) ^
261         bytes4(keccak256('transferFrom(address,address,uint)')) ^
262         bytes4(keccak256('tokensOfOwner(address)')) ^
263         bytes4(keccak256('tokenMetadata(uint,string)'));
264 
265 
266     function supportsInterface(bytes4 _interfaceID) external view returns (bool)
267     {
268 
269         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
270     }
271 
272     function _owns(address _claimant, uint _tokenId) internal view returns (bool) {
273         return clownIndexToOwner[_tokenId] == _claimant;
274     }
275 
276     function _approvedFor(address _claimant, uint _tokenId) internal view returns (bool) {
277         return clownIndexToApproved[_tokenId] == _claimant;
278     }
279 
280     function _approve(uint _tokenId, address _approved) internal {
281         clownIndexToApproved[_tokenId] = _approved;
282     }
283 
284     function balanceOf(address _owner) public view returns (uint count) {
285         return ownershipTokenCount[_owner];
286     }
287 
288     function transfer(
289         address _to,
290         uint _tokenId
291     )
292         external
293         whenNotPaused
294     {
295         require(_to != address(0));
296         require(_to != msg.sender);
297 
298         require(_owns(msg.sender, _tokenId));
299 
300         _transfer(msg.sender, _to, _tokenId);
301     }
302 
303     function approve(
304         address _to,
305         uint _tokenId
306     )
307         external
308         whenNotPaused
309     {
310         require(_owns(msg.sender, _tokenId));
311 
312         _approve(_tokenId, _to);
313 
314         Approval(msg.sender, _to, _tokenId);
315     }
316 
317     function transferFrom(
318         address _from,
319         address _to,
320         uint _tokenId
321     )
322         external
323         whenNotPaused
324     {
325         require(_to != address(0));
326         require(_to != msg.sender);
327         require(_approvedFor(msg.sender, _tokenId));
328         require(_owns(_from, _tokenId));
329 
330         _transfer(_from, _to, _tokenId);
331     }
332 
333     function totalSupply() public view returns (uint) {
334         return clowns.length - 2;
335     }
336 
337     function ownerOf(uint _tokenId)
338         external
339         view
340         returns (address owner)
341     {
342         owner = clownIndexToOwner[_tokenId];
343 
344         require(owner != address(0));
345     }
346 
347     function tokensOfOwner(address _owner) external view returns(uint[] ownerTokens) {
348         uint tokenCount = balanceOf(_owner);
349 
350         if (tokenCount == 0) {
351             return new uint[](0);
352         } else {
353             uint[] memory result = new uint[](tokenCount);
354             uint totalCats = totalSupply();
355             uint resultIndex = 0;
356 
357             uint catId;
358 
359             for (catId = 1; catId <= totalCats; catId++) {
360                 if (clownIndexToOwner[catId] == _owner) {
361                     result[resultIndex] = catId;
362                     resultIndex++;
363                 }
364             }
365 
366             return result;
367         }
368     }
369 
370 }
371 
372 
373 contract Minting is Ownership {
374 
375     uint public constant PROMO_CREATION_LIMIT = 5000;
376     uint public constant GEN0_CREATION_LIMIT = 45000;
377 
378     uint public promoCreatedCount;
379     uint public gen0CreatedCount;
380 
381     function createPromoClown(uint _genes, address _owner, bool _isNew) external onlyCOO {
382         address clownOwner = _owner;
383         if (clownOwner == address(0)) {
384              clownOwner = cooAddress;
385         }
386         require(promoCreatedCount < PROMO_CREATION_LIMIT);
387         if (_isNew) {
388             promoTypeNum++;
389         }
390 
391         promoCreatedCount++;
392         _createClown(0, 0, 0, _genes, clownOwner);
393     }
394 
395     function createGen0(uint _genes) external onlyCOO {
396         require(gen0CreatedCount < GEN0_CREATION_LIMIT);
397 
398         _createClown(0, 0, 0, _genes, msg.sender);
399 
400         gen0CreatedCount++;
401     }
402 
403     function useProps(uint[] _clownIds, uint16[] _values, uint16[] _types) public onlyCOO {
404         for (uint16 j = 0; j < _clownIds.length; j++) {
405             uint _clownId = _clownIds[j];
406             uint16 _value = _values[j];
407             uint16 _type = _types[j];
408             Clown storage clown = clowns[_clownId];
409 
410             if (_type == 0) {
411                 clown.growthAddition += _value;
412             } else if (_type == 1) {
413                 clown.attrPower += _value;
414             } else if (_type == 2) {
415                 clown.attrAgile += _value;
416             } else if (_type == 3) {
417                 clown.attrWisdom += _value;
418             }
419         }
420     }
421 
422 }
423 
424 contract GeneScienceInterface {
425     function isGeneScience() public pure returns (bool);
426     function mixGenes(uint genes1, uint genes2, uint promoTypeNum) public returns (uint);
427 }
428 
429 
430 contract Breeding is Ownership {
431 
432     GeneScienceInterface public geneScience;
433 
434     function setGeneScienceAddress(address _address) external onlyCEO {
435         GeneScienceInterface candidateContract = GeneScienceInterface(_address);
436 
437         require(candidateContract.isGeneScience());
438 
439         geneScience = candidateContract;
440     }
441 
442 
443     function _updateCooldown(Clown storage _clown) internal {
444         if (_clown.cooldownIndex < 7) {
445             _clown.cooldownIndex += 1;
446         }
447     }
448 
449 
450     function giveBirth(uint _matronId, uint _sireId) external onlyCOO returns(uint) {
451         Clown storage matron = clowns[_matronId];
452 
453         Clown storage sire = clowns[_sireId];
454 
455         // 限制公母
456         require(sire.sex == 1);
457         require(matron.sex == 0);
458         require(_matronId != _sireId);
459 
460         _updateCooldown(sire);
461         _updateCooldown(matron);
462 
463         require(matron.birthTime != 0);
464 
465         uint16 parentGen = matron.generation;
466         if (sire.generation > matron.generation) {
467             parentGen = sire.generation;
468         }
469 
470         uint mGenes = matron.genes;
471         uint sGenes = sire.genes;
472         uint childGenes = geneScience.mixGenes(mGenes, sGenes, promoTypeNum);
473         
474         address owner = clownIndexToOwner[_matronId];
475         uint clownId = _createClown(_matronId, _sireId, parentGen + 1, childGenes, owner);
476 
477         return clownId;
478     }
479 }
480 
481 
482 
483 contract ClownCore is Minting, Breeding {
484 
485     address public newContractAddress;
486 
487     function ClownCore() public {
488         paused = true;
489 
490         ceoAddress = msg.sender;
491 
492         cooAddress = msg.sender;
493 
494         _createClown(0, 0, 0, uint(-1), 0x0);
495         _createClown(0, 0, 0, uint(-2), 0x0);
496     }
497 
498     function setNewAddress(address _newAddress) external onlyCEO whenPaused {
499         newContractAddress = _newAddress;
500         ContractUpgrade(_newAddress);
501     }
502 
503     function getClown(uint _id)
504         external
505         view
506         returns (
507         uint cooldownIndex,
508         uint birthTime,
509         uint matronId,
510         uint sireId,
511         uint sex,
512         uint generation,
513         uint genes,
514         uint growthAddition,
515         uint attrPower,
516         uint attrAgile,
517         uint attrWisdom
518     ) {
519         Clown storage clo = clowns[_id];
520 
521         cooldownIndex = uint(clo.cooldownIndex);
522         birthTime = uint(clo.birthTime);
523         matronId = uint(clo.matronId);
524         sireId = uint(clo.sireId);
525         sex = uint(clo.sex);
526         generation = uint(clo.generation);
527         genes = uint(clo.genes);
528         growthAddition = uint(clo.growthAddition);
529         attrPower = uint(clo.attrPower);
530         attrAgile = uint(clo.attrAgile);
531         attrWisdom = uint(clo.attrWisdom);
532     }
533 
534     function unpause() public onlyCEO whenPaused {
535         
536         require(geneScience != address(0));
537         require(newContractAddress == address(0));
538 
539         super.unpause();
540     }
541 
542 }