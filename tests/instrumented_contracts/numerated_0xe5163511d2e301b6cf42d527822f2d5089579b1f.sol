1 pragma solidity ^0.4.17;
2 
3 contract NovaAccessControl {
4   mapping (address => bool) managers;
5   address public cfoAddress;
6 
7   function NovaAccessControl() public {
8     managers[msg.sender] = true;
9   }
10 
11   modifier onlyManager() {
12     require(managers[msg.sender]);
13     _;
14   }
15 
16   function setManager(address _newManager) external onlyManager {
17     require(_newManager != address(0));
18     managers[_newManager] = true;
19   }
20 
21   function removeManager(address mangerAddress) external onlyManager {
22     require(mangerAddress != msg.sender);
23     managers[mangerAddress] = false;
24   }
25 
26   function updateCfo(address newCfoAddress) external onlyManager {
27     require(newCfoAddress != address(0));
28     cfoAddress = newCfoAddress;
29   }
30 }
31 
32 contract NovaCoin is NovaAccessControl {
33   string public name;
34   string public symbol;
35   uint256 public totalSupply;
36   address supplier;
37   // 1:1 convert with currency, so to cent
38   uint8 public decimals = 2;
39   mapping (address => uint256) public balanceOf;
40   address public novaContractAddress;
41 
42   event Transfer(address indexed from, address indexed to, uint256 value);
43   event Burn(address indexed from, uint256 value);
44   event NovaCoinTransfer(address indexed to, uint256 value);
45 
46   function NovaCoin(uint256 initialSupply, string tokenName, string tokenSymbol) public {
47     totalSupply = initialSupply * 10 ** uint256(decimals);
48     supplier = msg.sender;
49     balanceOf[supplier] = totalSupply;
50     name = tokenName;
51     symbol = tokenSymbol;
52   }
53 
54   function _transfer(address _from, address _to, uint _value) internal {
55     require(_to != 0x0);
56     require(balanceOf[_from] >= _value);
57     require(balanceOf[_to] + _value > balanceOf[_to]);
58     balanceOf[_from] -= _value;
59     balanceOf[_to] += _value;
60   }
61 
62   // currently only permit NovaContract to consume
63   function transfer(address _to, uint256 _value) external {
64     _transfer(msg.sender, _to, _value);
65     Transfer(msg.sender, _to, _value);
66   }
67 
68   function novaTransfer(address _to, uint256 _value) external onlyManager {
69     _transfer(supplier, _to, _value);
70     NovaCoinTransfer(_to, _value);
71   }
72 
73   function updateNovaContractAddress(address novaAddress) external onlyManager {
74     novaContractAddress = novaAddress;
75   }
76 
77   // This is function is used for sell Nova properpty only
78   // coin can only be trasfered to invoker, and invoker must be Nova contract
79   function consumeCoinForNova(address _from, uint _value) external {
80     require(msg.sender == novaContractAddress);
81     require(balanceOf[_from] >= _value);
82     var _to = novaContractAddress;
83     require(balanceOf[_to] + _value > balanceOf[_to]);
84     uint previousBalances = balanceOf[_from] + balanceOf[_to];
85     balanceOf[_from] -= _value;
86     balanceOf[_to] += _value;
87   }
88 }
89 
90 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
91 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
92 contract ERC721 {
93   // Required methods
94   function totalSupply() public view returns (uint256 total);
95   function balanceOf(address _owner) public view returns (uint256 balance);
96   function ownerOf(uint256 _tokenId) external view returns (address owner);
97   function approve(address _to, uint256 _tokenId) external;
98   function transfer(address _to, uint256 _tokenId) external;
99   function transferFrom(address _from, address _to, uint256 _tokenId) external;
100 
101   // Events
102   event Transfer(address from, address to, uint256 tokenId);
103   event Approval(address owner, address approved, uint256 tokenId);
104 
105   // Optional
106   // function name() public view returns (string name);
107   // function symbol() public view returns (string symbol);
108   // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
109   // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
110 
111   // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
112   function supportsInterface(bytes4 _interfaceID) external view returns (bool);
113 }
114 
115 // just interface reference
116 contract NovaLabInterface {
117   function bornStar() external returns(uint star) {}
118   function bornMeteoriteNumber() external returns(uint mNumber) {}
119   function bornMeteorite() external returns(uint mQ) {}
120   function mergeMeteorite(uint totalQuality) external returns(bool isSuccess, uint finalMass) {}
121 }
122 
123 contract FamedStarInterface {
124   function bornFamedStar(address userAddress, uint mass) external returns(uint id, bytes32 name) {}
125   function updateFamedStarOwner(uint id, address newOwner) external {}
126 }
127 
128 contract Nova is NovaAccessControl,ERC721 {
129   // ERC721 Required
130   bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
131 
132   bytes4 constant InterfaceSignature_ERC721 =
133     bytes4(keccak256('name()')) ^
134     bytes4(keccak256('symbol()')) ^
135     bytes4(keccak256('totalSupply()')) ^
136     bytes4(keccak256('balanceOf(address)')) ^
137     bytes4(keccak256('ownerOf(uint256)')) ^
138     bytes4(keccak256('approve(address,uint256)')) ^
139     bytes4(keccak256('transfer(address,uint256)')) ^
140     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
141     bytes4(keccak256('tokensOfOwner(address)')) ^
142     bytes4(keccak256('tokenMetadata(uint256,string)'));
143 
144   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
145     return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
146   }
147 
148   function name() public pure returns (string) {
149     return "Nova";
150   }
151 
152   function symbol() public pure returns (string) {
153     return "NOVA";
154   }
155 
156   function totalSupply() public view returns (uint256 total) {
157     return validAstroCount;
158   }
159 
160   function balanceOf(address _owner) public constant returns (uint balance) {
161     return astroOwnerToIDsLen[_owner];
162   }
163 
164   function ownerOf(uint256 _tokenId) external constant returns (address owner) {
165     return astroIndexToOwners[_tokenId];
166   }
167 
168   mapping(address => mapping (address => uint256)) allowed;
169   function approve(address _to, uint256 _tokenId) external {
170     require(msg.sender == astroIndexToOwners[_tokenId]);
171     require(msg.sender != _to);
172 
173     allowed[msg.sender][_to] = _tokenId;
174     Approval(msg.sender, _to, _tokenId);
175   }
176 
177   function transfer(address _to, uint256 _tokenId) external {
178     _transfer(msg.sender, _to, _tokenId);
179     Transfer(msg.sender, _to, _tokenId);
180   }
181 
182   function transferFrom(address _from, address _to, uint256 _tokenId) external {
183     _transfer(_from, _to, _tokenId);
184   }
185 
186   function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds) {
187     return astroOwnerToIDs[_owner];
188   }
189 
190   string metaBaseUrl = "http://supernova.duelofkings.com";
191   function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl) {
192     return metaBaseUrl;
193   }
194 
195   function updateMetaBaseUrl(string newUrl) external onlyManager {
196     metaBaseUrl = newUrl;
197   }
198 
199   // END of ERC-165 ERC-721
200 
201   enum AstroType {Placeholder, Supernova, Meteorite, NormalStar, FamedStar, Dismissed}
202   uint public superNovaSupply;
203   uint public validAstroCount;
204   address public novaCoinAddress;
205   address public labAddress;
206   address public famedStarAddress;
207   uint public astroIDPool;
208   uint public priceValidSeconds = 3600; //default 1 hour
209 
210   uint novaTransferRate = 30; // 30/1000
211 
212   struct Astro {
213     uint id; //world unique, astroIDPool start from 1
214     uint createTime;
215     uint nextAttractTime;
216     // [8][8][88][88] -> L to H: astroType, cdIdx, famedID, mass
217     uint48 code;
218     bytes32 name;
219   }
220 
221   struct PurchasingRecord {
222     uint id;
223     uint priceWei;
224     uint time;
225   }
226 
227   Astro[] public supernovas;
228   Astro[] public normalStars;
229   Astro[] public famedStars;
230   Astro[] public meteorites;
231 
232   uint32[31] public cd = [
233     0,
234     uint32(360 minutes),
235     uint32(400 minutes),
236     uint32(444 minutes),
237     uint32(494 minutes),
238     uint32(550 minutes),
239     uint32(610 minutes),
240     uint32(677 minutes),
241     uint32(752 minutes),
242     uint32(834 minutes),
243     uint32(925 minutes),
244     uint32(1027 minutes),
245     uint32(1140 minutes),
246     uint32(1265 minutes),
247     uint32(1404 minutes),
248     uint32(1558 minutes),
249     uint32(1729 minutes),
250     uint32(1919 minutes),
251     uint32(2130 minutes),
252     uint32(2364 minutes),
253     uint32(2624 minutes),
254     uint32(2912 minutes),
255     uint32(3232 minutes),
256     uint32(3587 minutes),
257     uint32(3982 minutes),
258     uint32(4420 minutes),
259     uint32(4906 minutes),
260     uint32(5445 minutes),
261     uint32(6044 minutes),
262     uint32(6708 minutes),
263     uint32(7200 minutes)
264   ];
265 
266   // a mapping from astro ID to the address that owns
267   mapping (uint => address) public astroIndexToOwners;
268   mapping (address => uint[]) public astroOwnerToIDs;
269   mapping (address => uint) public astroOwnerToIDsLen;
270 
271   mapping (address => mapping(uint => uint)) public astroOwnerToIDIndex;
272 
273   mapping (uint => uint) public idToIndex;
274 
275   // a mapping from astro name to ID
276   mapping (bytes32 => uint256) astroNameToIDs;
277 
278   // purchasing mapping
279   mapping (address => PurchasingRecord) public purchasingBuyer;
280 
281   event PurchasedSupernova(address userAddress, uint astroID);
282   event ExplodedSupernova(address userAddress, uint[] newAstroIDs);
283   event MergedAstros(address userAddress, uint newAstroID);
284   event AttractedMeteorites(address userAddress, uint[] newAstroIDs);
285   event UserPurchasedAstro(address buyerAddress, address sellerAddress, uint astroID, uint recordPriceWei, uint value);
286   event NovaPurchasing(address buyAddress, uint astroID, uint priceWei);
287 
288   // initial supply to managerAddress
289   function Nova(uint32 initialSupply) public {
290     superNovaSupply = initialSupply;
291     validAstroCount = 0;
292     astroIDPool = 0;
293   }
294 
295   function updateNovaTransferRate(uint rate) external onlyManager {
296     novaTransferRate = rate;
297   }
298 
299   function updateNovaCoinAddress(address novaCoinAddr) external onlyManager {
300     novaCoinAddress = novaCoinAddr;
301   }
302 
303   function updateLabContractAddress(address addr) external onlyManager {
304     labAddress = addr;
305   }
306 
307   function updateFamedStarContractAddress(address addr) external onlyManager {
308     famedStarAddress = addr;
309   }
310 
311   function updatePriceValidSeconds(uint newSeconds) external onlyManager {
312     priceValidSeconds = newSeconds;
313   }
314 
315   function getAstrosLength() constant external returns(uint) {
316       return astroIDPool;
317   }
318 
319   function getUserAstroIDs(address userAddress) constant external returns(uint[]) {
320     return astroOwnerToIDs[userAddress];
321   }
322 
323   function getNovaOwnerAddress(uint novaID) constant external returns(address) {
324       return astroIndexToOwners[novaID];
325   }
326 
327   function getAstroInfo(uint id) constant public returns(uint novaId, uint idx, AstroType astroType, string astroName, uint mass, uint createTime, uint famedID, uint nextAttractTime, uint cdTime) {
328       if (id > astroIDPool) {
329           return;
330       }
331 
332       (idx, astroType) = _extractIndex(idToIndex[id]);
333       if (astroType == AstroType.Placeholder || astroType == AstroType.Dismissed) {
334           return;
335       }
336 
337       Astro memory astro;
338       uint cdIdx;
339 
340       var astroPool = _getAstroPoolByType(astroType);
341       astro = astroPool[idx];
342       (astroType, cdIdx, famedID, mass) = _extractCode(astro.code);
343 
344       return (id, idx, astroType, _bytes32ToString(astro.name), mass, astro.createTime, famedID, astro.nextAttractTime, cd[cdIdx]);
345   }
346 
347   function getAstroInfoByIdx(uint index, AstroType aType) constant external returns(uint novaId, uint idx, AstroType astroType, string astroName, uint mass, uint createTime, uint famedID, uint nextAttractTime, uint cdTime) {
348       if (aType == AstroType.Placeholder || aType == AstroType.Dismissed) {
349           return;
350       }
351 
352       var astroPool = _getAstroPoolByType(aType);
353       Astro memory astro = astroPool[index];
354       uint cdIdx;
355       (astroType, cdIdx, famedID, mass) = _extractCode(astro.code);
356       return (astro.id, index, astroType, _bytes32ToString(astro.name), mass, astro.createTime, famedID, astro.nextAttractTime, cd[cdIdx]);
357   }
358 
359   function getSupernovaBalance() constant external returns(uint) {
360       return superNovaSupply;
361   }
362 
363   function getAstroPoolLength(AstroType astroType) constant external returns(uint) {
364       Astro[] storage pool = _getAstroPoolByType(astroType);
365       return pool.length;
366   }
367 
368   // read from end position
369   function getAstroIdxsByPage(uint lastIndex, uint count, AstroType expectedType) constant external returns(uint[] idx, uint idxLen) {
370       if (expectedType == AstroType.Placeholder || expectedType == AstroType.Dismissed) {
371           return;
372       }
373 
374       Astro[] storage astroPool = _getAstroPoolByType(expectedType);
375 
376       if (lastIndex == 0 || astroPool.length == 0 || lastIndex > astroPool.length) {
377           return;
378       }
379 
380       uint[] memory result = new uint[](count);
381       uint start = lastIndex - 1;
382       uint i = 0;
383       for (uint cursor = start; cursor >= 0 && i < count; --cursor) {
384           var astro = astroPool[cursor];
385           if (_isValidAstro(_getAstroTypeByCode(astro.code))) {
386             result[i++] = cursor;
387           }
388           if (cursor == 0) {
389               break;
390           }
391       }
392 
393       // ugly
394       uint[] memory finalR = new uint[](i);
395       for (uint cnt = 0; cnt < i; cnt++) {
396         finalR[cnt] = result[cnt];
397       }
398 
399       return (finalR, i);
400   }
401 
402   function isUserOwnNovas(address userAddress, uint[] novaIDs) constant external returns(bool isOwn) {
403       for (uint i = 0; i < novaIDs.length; i++) {
404           if (astroIndexToOwners[novaIDs[i]] != userAddress) {
405               return false;
406           }
407       }
408 
409       return true;
410   }
411 
412   function getUserPurchasingTime(address buyerAddress) constant external returns(uint) {
413     return purchasingBuyer[buyerAddress].time;
414   }
415 
416   function _extractIndex(uint codeIdx) pure public returns(uint index, AstroType astroType) {
417       astroType = AstroType(codeIdx & 0x0000000000ff);
418       index = uint(codeIdx >> 8);
419   }
420 
421   function _combineIndex(uint index, AstroType astroType) pure public returns(uint codeIdx) {
422       codeIdx = uint((index << 8) | uint(astroType));
423   }
424 
425   function _updateAstroTypeForIndexCode(uint orgCodeIdx, AstroType astroType) pure public returns(uint) {
426       return (orgCodeIdx & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00) | (uint(astroType));
427   }
428 
429   function _updateIndexForIndexCode(uint orgCodeIdx, uint idx) pure public returns(uint) {
430       return (orgCodeIdx & 0xff) | (idx << 8);
431   }
432 
433   function _extractCode(uint48 code) pure public returns(AstroType astroType, uint cdIdx, uint famedID, uint mass) {
434      astroType = AstroType(code & 0x0000000000ff);
435      if (astroType == AstroType.NormalStar) {
436         cdIdx = (code & 0x00000000ff00) >> 8;
437         famedID = 0;
438         mass = (code & 0xffff00000000) >> 32;
439      } else if (astroType == AstroType.FamedStar) {
440         cdIdx = (code & 0x00000000ff00) >> 8;
441         famedID = (code & 0x0000ffff0000) >> 16;
442         mass = (code & 0xffff00000000) >> 32;
443      } else if (astroType == AstroType.Supernova) {
444         cdIdx = 0;
445         famedID = 0;
446         mass = 0;
447      } else {
448         cdIdx = 0;
449         famedID = 0;
450         mass = (code & 0xffff00000000) >> 32;
451      }
452   }
453 
454   function _getAstroTypeByCode(uint48 code) pure internal returns(AstroType astroType) {
455      return AstroType(code & 0x0000000000ff);
456   }
457 
458   function _getMassByCode(uint48 code) pure internal returns(uint mass) {
459      return uint((code & 0xffff00000000) >> 32);
460   }
461 
462   function _getCdIdxByCode(uint48 code) pure internal returns(uint cdIdx) {
463      return uint((code & 0x00000000ff00) >> 8);
464   }
465 
466   function _getFamedIDByCode(uint48 code) pure internal returns(uint famedID) {
467     return uint((code & 0x0000ffff0000) >> 16);
468   }
469 
470   function _combieCode(AstroType astroType, uint cdIdx, uint famedID, uint mass) pure public returns(uint48 code) {
471      if (astroType == AstroType.NormalStar) {
472         return uint48(astroType) | (uint48(cdIdx) << 8) | (uint48(mass) << 32);
473      } else if (astroType == AstroType.FamedStar) {
474         return uint48(astroType) | (uint48(cdIdx) << 8) | (uint48(famedID) << 16) | (uint48(mass) << 32);
475      } else if (astroType == AstroType.Supernova) {
476         return uint48(astroType);
477      } else {
478         return uint48(astroType) | (uint48(mass) << 32);
479      }
480   }
481 
482   function _updateAstroTypeForCode(uint48 orgCode, AstroType newType) pure public returns(uint48 newCode) {
483      return (orgCode & 0xffffffffff00) | (uint48(newType));
484   }
485 
486   function _updateCdIdxForCode(uint48 orgCode, uint newIdx) pure public returns(uint48 newCode) {
487      return (orgCode & 0xffffffff00ff) | (uint48(newIdx) << 8);
488   }
489 
490   function _getAstroPoolByType(AstroType expectedType) constant internal returns(Astro[] storage pool) {
491       if (expectedType == AstroType.Supernova) {
492           return supernovas;
493       } else if (expectedType == AstroType.Meteorite) {
494           return meteorites;
495       } else if (expectedType == AstroType.NormalStar) {
496           return normalStars;
497       } else if (expectedType == AstroType.FamedStar) {
498           return famedStars;
499       }
500   }
501 
502   function _isValidAstro(AstroType astroType) pure internal returns(bool) {
503       return astroType != AstroType.Placeholder && astroType != AstroType.Dismissed;
504   }
505 
506   function _reduceValidAstroCount() internal {
507     --validAstroCount;
508   }
509 
510   function _plusValidAstroCount() internal {
511     ++validAstroCount;
512   }
513 
514   function _addAstro(AstroType astroType, bytes32 astroName, uint mass, uint createTime, uint famedID) internal returns(uint) {
515     uint48 code = _combieCode(astroType, 0, famedID, mass);
516 
517     var astroPool = _getAstroPoolByType(astroType);
518     ++astroIDPool;
519     uint idx = astroPool.push(Astro({
520         id: astroIDPool,
521         name: astroName,
522         createTime: createTime,
523         nextAttractTime: 0,
524         code: code
525     })) - 1;
526 
527     idToIndex[astroIDPool] = _combineIndex(idx, astroType);
528 
529     return astroIDPool;
530   }
531 
532   function _removeAstroFromUser(address userAddress, uint novaID) internal {
533     uint idsLen = astroOwnerToIDsLen[userAddress];
534     uint index = astroOwnerToIDIndex[userAddress][novaID];
535 
536     if (idsLen > 1 && index != idsLen - 1) {
537         uint endNovaID = astroOwnerToIDs[userAddress][idsLen - 1];
538         astroOwnerToIDs[userAddress][index] = endNovaID;
539         astroOwnerToIDIndex[userAddress][endNovaID] = index;
540     }
541     astroOwnerToIDs[userAddress][idsLen - 1] = 0;
542     astroOwnerToIDsLen[userAddress] = idsLen - 1;
543   }
544 
545   function _addAstroToUser(address userAddress, uint novaID) internal {
546     uint idsLen = astroOwnerToIDsLen[userAddress];
547     uint arrayLen = astroOwnerToIDs[userAddress].length;
548     if (idsLen == arrayLen) {
549       astroOwnerToIDsLen[userAddress] = astroOwnerToIDs[userAddress].push(novaID);
550       astroOwnerToIDIndex[userAddress][novaID] = astroOwnerToIDsLen[userAddress] - 1;
551     } else {
552       // there is gap
553       astroOwnerToIDs[userAddress][idsLen] = novaID;
554       astroOwnerToIDsLen[userAddress] = idsLen + 1;
555       astroOwnerToIDIndex[userAddress][novaID] = idsLen;
556     }
557   }
558 
559   function _burnDownAstro(address userAddress, uint novaID) internal {
560     delete astroIndexToOwners[novaID];
561     _removeAstroFromUser(userAddress, novaID);
562 
563     uint idx;
564     AstroType astroType;
565     uint orgIdxCode = idToIndex[novaID];
566     (idx, astroType) = _extractIndex(orgIdxCode);
567 
568     var pool = _getAstroPoolByType(astroType);
569     pool[idx].code = _updateAstroTypeForCode(pool[idx].code, AstroType.Dismissed);
570 
571     idToIndex[novaID] = _updateAstroTypeForIndexCode(orgIdxCode, AstroType.Dismissed);
572 
573     _reduceValidAstroCount();
574   }
575 
576   function _insertNewAstro(address userAddress, AstroType t, uint mass, bytes32 novaName, uint famedID) internal returns(uint) {
577     uint newNovaID = _addAstro(t, novaName, mass, block.timestamp, famedID);
578     astroIndexToOwners[newNovaID] = userAddress;
579     _addAstroToUser(userAddress, newNovaID);
580 
581     _plusValidAstroCount();
582     return newNovaID;
583   }
584 
585   function _bytes32ToString(bytes32 x) internal pure returns (string) {
586     bytes memory bytesString = new bytes(32);
587     uint charCount = 0;
588     for (uint j = 0; j < 32; j++) {
589         byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
590         if (char != 0) {
591             bytesString[charCount] = char;
592             charCount++;
593         }
594     }
595     bytes memory bytesStringTrimmed = new bytes(charCount);
596     for (j = 0; j < charCount; j++) {
597         bytesStringTrimmed[j] = bytesString[j];
598     }
599     return string(bytesStringTrimmed);
600   }
601 
602   function _stringToBytes32(string source) internal pure returns (bytes32 result) {
603     bytes memory tempEmptyStringTest = bytes(source);
604     if (tempEmptyStringTest.length == 0) {
605         return 0x0;
606     }
607 
608     assembly {
609         result := mload(add(source, 32))
610     }
611   }
612 
613   function _transfer(address _from, address _to, uint _tokenId) internal {
614     require(_from == astroIndexToOwners[_tokenId]);
615     require(_from != _to && _to != address(0));
616 
617     uint poolIdx;
618     AstroType itemType;
619     (poolIdx, itemType) = _extractIndex(idToIndex[_tokenId]);
620     var pool = _getAstroPoolByType(itemType);
621     var astro = pool[poolIdx];
622     require(_getAstroTypeByCode(astro.code) != AstroType.Dismissed);
623 
624     astroIndexToOwners[_tokenId] = _to;
625 
626     _removeAstroFromUser(_from, _tokenId);
627     _addAstroToUser(_to, _tokenId);
628 
629     // Check if it's famous star
630     uint famedID = _getFamedIDByCode(astro.code);
631     if (famedID > 0) {
632       var famedstarContract = FamedStarInterface(famedStarAddress);
633       famedstarContract.updateFamedStarOwner(famedID, _to);
634     }
635   }
636 
637   // Purchase action only permit manager to use
638   function purchaseSupernova(address targetAddress, uint price) external onlyManager {
639     require(superNovaSupply >= 1);
640     NovaCoin novaCoinContract = NovaCoin(novaCoinAddress);
641     require(novaCoinContract.balanceOf(targetAddress) >= price);
642     novaCoinContract.consumeCoinForNova(targetAddress, price);
643 
644     superNovaSupply -= 1;
645     var newNovaID = _insertNewAstro(targetAddress, AstroType.Supernova, 0, 0, 0);
646     PurchasedSupernova(targetAddress, newNovaID);
647   }
648 
649   // explode one supernova from user's supernova balance, write explode result into user account
650   function explodeSupernova(address userAddress, uint novaID) external onlyManager {
651     // verifu if user own's this supernova
652     require(astroIndexToOwners[novaID] == userAddress);
653     uint poolIdx;
654     AstroType itemType;
655     (poolIdx, itemType) = _extractIndex(idToIndex[novaID]);
656     require(itemType == AstroType.Supernova);
657     // burn down user's supernova
658     _burnDownAstro(userAddress, novaID);
659 
660     uint[] memory newAstroIDs;
661 
662     var labContract = NovaLabInterface(labAddress);
663     uint star = labContract.bornStar();
664     if (star > 0) {
665         // Got star, check if it's famed star
666         newAstroIDs = new uint[](1);
667         var famedstarContract = FamedStarInterface(famedStarAddress);
668         uint famedID;
669         bytes32 novaName;
670         (famedID, novaName) = famedstarContract.bornFamedStar(userAddress, star);
671         if (famedID > 0) {
672             newAstroIDs[0] = _insertNewAstro(userAddress, AstroType.FamedStar, star, novaName, famedID);
673         } else {
674             newAstroIDs[0] = _insertNewAstro(userAddress, AstroType.NormalStar, star, 0, 0);
675         }
676     } else {
677         uint mNum = labContract.bornMeteoriteNumber();
678         newAstroIDs = new uint[](mNum);
679         uint m;
680         for (uint i = 0; i < mNum; i++) {
681             m = labContract.bornMeteorite();
682             newAstroIDs[i] = _insertNewAstro(userAddress, AstroType.Meteorite, m, 0, 0);
683         }
684     }
685     ExplodedSupernova(userAddress, newAstroIDs);
686   }
687 
688   function _merge(address userAddress, uint mergeMass) internal returns (uint famedID, bytes32 novaName, AstroType newType, uint finalMass) {
689     var labContract = NovaLabInterface(labAddress);
690     bool mergeResult;
691     (mergeResult, finalMass) = labContract.mergeMeteorite(mergeMass);
692     if (mergeResult) {
693         //got star, check if we can get famed star
694         var famedstarContract = FamedStarInterface(famedStarAddress);
695         (famedID, novaName) = famedstarContract.bornFamedStar(userAddress, mergeMass);
696         if (famedID > 0) {
697             newType = AstroType.FamedStar;
698         } else {
699             newType = AstroType.NormalStar;
700         }
701     } else {
702         newType = AstroType.Meteorite;
703     }
704     return;
705   }
706 
707   function _combine(address userAddress, uint[] astroIDs) internal returns(uint mergeMass) {
708     uint astroID;
709     mergeMass = 0;
710     uint poolIdx;
711     AstroType itemType;
712     for (uint i = 0; i < astroIDs.length; i++) {
713         astroID = astroIDs[i];
714         (poolIdx, itemType) = _extractIndex(idToIndex[astroID]);
715         require(astroIndexToOwners[astroID] == userAddress);
716         require(itemType == AstroType.Meteorite);
717         // start merge
718         //mergeMass += meteorites[idToIndex[astroID].index].mass;
719         mergeMass += _getMassByCode(meteorites[poolIdx].code);
720         // Burn down
721         _burnDownAstro(userAddress, astroID);
722     }
723   }
724 
725   function mergeAstros(address userAddress, uint novaCoinCentCost, uint[] astroIDs) external onlyManager {
726     // check nova coin balance
727     NovaCoin novaCoinContract = NovaCoin(novaCoinAddress);
728     require(novaCoinContract.balanceOf(userAddress) >= novaCoinCentCost);
729     // check astros
730     require(astroIDs.length > 1 && astroIDs.length <= 10);
731 
732     uint mergeMass = _combine(userAddress, astroIDs);
733     // Consume novaCoin
734     novaCoinContract.consumeCoinForNova(userAddress, novaCoinCentCost);
735     // start merge
736     uint famedID;
737     bytes32 novaName;
738     AstroType newType;
739     uint finalMass;
740     (famedID, novaName, newType, finalMass) = _merge(userAddress, mergeMass);
741     // Create new Astro
742     MergedAstros(userAddress, _insertNewAstro(userAddress, newType, finalMass, novaName, famedID));
743   }
744 
745   function _attractBalanceCheck(address userAddress, uint novaCoinCentCost) internal {
746     // check balance
747     NovaCoin novaCoinContract = NovaCoin(novaCoinAddress);
748     require(novaCoinContract.balanceOf(userAddress) >= novaCoinCentCost);
749 
750     // consume coin
751     novaCoinContract.consumeCoinForNova(userAddress, novaCoinCentCost);
752   }
753 
754   function attractMeteorites(address userAddress, uint novaCoinCentCost, uint starID) external onlyManager {
755     require(astroIndexToOwners[starID] == userAddress);
756     uint poolIdx;
757     AstroType itemType;
758     (poolIdx, itemType) = _extractIndex(idToIndex[starID]);
759 
760     require(itemType == AstroType.NormalStar || itemType == AstroType.FamedStar);
761 
762     var astroPool = _getAstroPoolByType(itemType);
763     Astro storage astro = astroPool[poolIdx];
764     require(astro.nextAttractTime <= block.timestamp);
765 
766     _attractBalanceCheck(userAddress, novaCoinCentCost);
767 
768     var labContract = NovaLabInterface(labAddress);
769     uint[] memory newAstroIDs = new uint[](1);
770     uint m = labContract.bornMeteorite();
771     newAstroIDs[0] = _insertNewAstro(userAddress, AstroType.Meteorite, m, 0, 0);
772     // update cd
773     uint cdIdx = _getCdIdxByCode(astro.code);
774     if (cdIdx >= cd.length - 1) {
775         astro.nextAttractTime = block.timestamp + cd[cd.length - 1];
776     } else {
777         astro.code = _updateCdIdxForCode(astro.code, ++cdIdx);
778         astro.nextAttractTime = block.timestamp + cd[cdIdx];
779     }
780 
781     AttractedMeteorites(userAddress, newAstroIDs);
782   }
783 
784   function setPurchasing(address buyerAddress, address ownerAddress, uint astroID, uint priceWei) external onlyManager {
785     require(astroIndexToOwners[astroID] == ownerAddress);
786     purchasingBuyer[buyerAddress] = PurchasingRecord({
787          id: astroID,
788          priceWei: priceWei,
789          time: block.timestamp
790     });
791     NovaPurchasing(buyerAddress, astroID, priceWei);
792   }
793 
794   function userPurchaseAstro(address ownerAddress, uint astroID) payable external {
795     // check valid purchasing tim
796     require(msg.sender.balance >= msg.value);
797     var record = purchasingBuyer[msg.sender];
798     require(block.timestamp < record.time + priceValidSeconds);
799     require(record.id == astroID);
800     require(record.priceWei <= msg.value);
801 
802     uint royalties = uint(msg.value * novaTransferRate / 1000);
803     ownerAddress.transfer(msg.value - royalties);
804     cfoAddress.transfer(royalties);
805 
806     _transfer(ownerAddress, msg.sender, astroID);
807 
808     UserPurchasedAstro(msg.sender, ownerAddress, astroID, record.priceWei, msg.value);
809     // clear purchasing state
810     delete purchasingBuyer[msg.sender];
811   }
812 }