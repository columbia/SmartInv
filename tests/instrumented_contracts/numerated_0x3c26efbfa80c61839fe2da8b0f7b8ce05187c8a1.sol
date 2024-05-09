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
32 /// @title Interface for contracts conforming to ERC-721: Non-Fungible Tokens
33 /// @author Dieter Shirley <dete@axiomzen.co> (https://github.com/dete)
34 contract ERC721 {
35   // Required methods
36   function totalSupply() public view returns (uint256 total);
37   function balanceOf(address _owner) public view returns (uint256 balance);
38   function ownerOf(uint256 _tokenId) external view returns (address owner);
39   function approve(address _to, uint256 _tokenId) external;
40   function transfer(address _to, uint256 _tokenId) external;
41   function transferFrom(address _from, address _to, uint256 _tokenId) external;
42 
43   // Events
44   event Transfer(address from, address to, uint256 tokenId);
45   event Approval(address owner, address approved, uint256 tokenId);
46 
47   // Optional
48   // function name() public view returns (string name);
49   // function symbol() public view returns (string symbol);
50   // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
51   // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);
52 
53   // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
54   function supportsInterface(bytes4 _interfaceID) external view returns (bool);
55 }
56 
57 // just interface reference
58 contract NovaLabInterface {
59   function bornStar() external returns(uint star) {}
60   function bornMeteoriteNumber() external returns(uint mNumber) {}
61   function bornMeteorite() external returns(uint mQ) {}
62   function mergeMeteorite(uint totalQuality) external returns(bool isSuccess, uint finalMass) {}
63 }
64 
65 contract FamedStarInterface {
66   function bornFamedStar(address userAddress, uint mass) external returns(uint id, bytes32 name) {}
67   function updateFamedStarOwner(uint id, address newOwner) external {}
68 }
69 
70 contract NovaCoinInterface {
71   function consumeCoinForNova(address _from, uint _value) external {}
72   function balanceOf(address _owner) public view returns (uint256 balance) {}
73 }
74 
75 contract Nova is NovaAccessControl,ERC721 {
76   // ERC721 Required
77   bytes4 constant InterfaceSignature_ERC165 = bytes4(keccak256('supportsInterface(bytes4)'));
78 
79   bytes4 constant InterfaceSignature_ERC721 =
80     bytes4(keccak256('name()')) ^
81     bytes4(keccak256('symbol()')) ^
82     bytes4(keccak256('totalSupply()')) ^
83     bytes4(keccak256('balanceOf(address)')) ^
84     bytes4(keccak256('ownerOf(uint256)')) ^
85     bytes4(keccak256('approve(address,uint256)')) ^
86     bytes4(keccak256('transfer(address,uint256)')) ^
87     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
88     bytes4(keccak256('tokensOfOwner(address)')) ^
89     bytes4(keccak256('tokenMetadata(uint256,string)'));
90 
91   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
92     return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
93   }
94 
95   function name() public pure returns (string) {
96     return "Nova";
97   }
98 
99   function symbol() public pure returns (string) {
100     return "NOVA";
101   }
102 
103   function totalSupply() public view returns (uint256 total) {
104     return validAstroCount;
105   }
106 
107   function balanceOf(address _owner) public constant returns (uint balance) {
108     return astroOwnerToIDsLen[_owner];
109   }
110 
111   function ownerOf(uint256 _tokenId) external constant returns (address owner) {
112     return astroIndexToOwners[_tokenId];
113   }
114 
115   mapping(address => mapping (address => uint256)) allowed;
116   function approve(address _to, uint256 _tokenId) external {
117     require(msg.sender == astroIndexToOwners[_tokenId]);
118     require(msg.sender != _to);
119 
120     allowed[msg.sender][_to] = _tokenId;
121     Approval(msg.sender, _to, _tokenId);
122   }
123 
124   function transfer(address _to, uint256 _tokenId) external {
125     _transfer(msg.sender, _to, _tokenId);
126     Transfer(msg.sender, _to, _tokenId);
127   }
128 
129   function transferFrom(address _from, address _to, uint256 _tokenId) external {
130     _transfer(_from, _to, _tokenId);
131   }
132 
133   function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds) {
134     return astroOwnerToIDs[_owner];
135   }
136 
137   string metaBaseUrl = "http://supernova.duelofkings.com";
138   function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl) {
139     return metaBaseUrl;
140   }
141 
142   function updateMetaBaseUrl(string newUrl) external onlyManager {
143     metaBaseUrl = newUrl;
144   }
145 
146   // END of ERC-165 ERC-721
147 
148   enum AstroType {Placeholder, Supernova, Meteorite, NormalStar, FamedStar, Dismissed}
149   uint public superNovaSupply;
150   uint public validAstroCount;
151   address public novaCoinAddress;
152   address public labAddress;
153   address public famedStarAddress;
154   uint public astroIDPool;
155   uint public priceValidSeconds = 3600; //default 1 hour
156 
157   uint novaTransferRate = 30; // 30/1000
158 
159   struct Astro {
160     uint id; //world unique, astroIDPool start from 1
161     uint createTime;
162     uint nextAttractTime;
163     // [8][8][88][88] -> L to H: astroType, cdIdx, famedID, mass
164     uint48 code;
165     bytes32 name;
166   }
167 
168   struct PurchasingRecord {
169     uint id;
170     uint priceWei;
171     uint time;
172   }
173 
174   Astro[] public supernovas;
175   Astro[] public normalStars;
176   Astro[] public famedStars;
177   Astro[] public meteorites;
178 
179   uint32[31] public cd = [
180     0,
181     uint32(360 minutes),
182     uint32(400 minutes),
183     uint32(444 minutes),
184     uint32(494 minutes),
185     uint32(550 minutes),
186     uint32(610 minutes),
187     uint32(677 minutes),
188     uint32(752 minutes),
189     uint32(834 minutes),
190     uint32(925 minutes),
191     uint32(1027 minutes),
192     uint32(1140 minutes),
193     uint32(1265 minutes),
194     uint32(1404 minutes),
195     uint32(1558 minutes),
196     uint32(1729 minutes),
197     uint32(1919 minutes),
198     uint32(2130 minutes),
199     uint32(2364 minutes),
200     uint32(2624 minutes),
201     uint32(2912 minutes),
202     uint32(3232 minutes),
203     uint32(3587 minutes),
204     uint32(3982 minutes),
205     uint32(4420 minutes),
206     uint32(4906 minutes),
207     uint32(5445 minutes),
208     uint32(6044 minutes),
209     uint32(6708 minutes),
210     uint32(7200 minutes)
211   ];
212 
213   // a mapping from astro ID to the address that owns
214   mapping (uint => address) public astroIndexToOwners;
215   mapping (address => uint[]) public astroOwnerToIDs;
216   mapping (address => uint) public astroOwnerToIDsLen;
217 
218   mapping (address => mapping(uint => uint)) public astroOwnerToIDIndex;
219 
220   mapping (uint => uint) public idToIndex;
221 
222   // a mapping from astro name to ID
223   mapping (bytes32 => uint256) astroNameToIDs;
224 
225   // purchasing mapping
226   mapping (address => PurchasingRecord) public purchasingBuyer;
227 
228   event PurchasedSupernova(address userAddress, uint astroID);
229   event ExplodedSupernova(address userAddress, uint[] newAstroIDs);
230   event MergedAstros(address userAddress, uint newAstroID);
231   event AttractedMeteorites(address userAddress, uint[] newAstroIDs);
232   event UserPurchasedAstro(address buyerAddress, address sellerAddress, uint astroID, uint recordPriceWei, uint value);
233   event NovaPurchasing(address buyAddress, uint astroID, uint priceWei);
234 
235   // initial supply to managerAddress
236   function Nova(uint32 initialSupply) public {
237     superNovaSupply = initialSupply;
238     validAstroCount = 0;
239     astroIDPool = 0;
240   }
241 
242   function updateNovaTransferRate(uint rate) external onlyManager {
243     novaTransferRate = rate;
244   }
245 
246   function updateNovaCoinAddress(address novaCoinAddr) external onlyManager {
247     novaCoinAddress = novaCoinAddr;
248   }
249 
250   function updateLabContractAddress(address addr) external onlyManager {
251     labAddress = addr;
252   }
253 
254   function updateFamedStarContractAddress(address addr) external onlyManager {
255     famedStarAddress = addr;
256   }
257 
258   function updatePriceValidSeconds(uint newSeconds) external onlyManager {
259     priceValidSeconds = newSeconds;
260   }
261 
262   function getAstrosLength() constant external returns(uint) {
263       return astroIDPool;
264   }
265 
266   function getUserAstroIDs(address userAddress) constant external returns(uint[]) {
267     return astroOwnerToIDs[userAddress];
268   }
269 
270   function getNovaOwnerAddress(uint novaID) constant external returns(address) {
271       return astroIndexToOwners[novaID];
272   }
273 
274   function getAstroInfo(uint id) constant public returns(uint novaId, uint idx, AstroType astroType, string astroName, uint mass, uint createTime, uint famedID, uint nextAttractTime, uint cdTime) {
275       if (id > astroIDPool) {
276           return;
277       }
278 
279       (idx, astroType) = _extractIndex(idToIndex[id]);
280       if (astroType == AstroType.Placeholder || astroType == AstroType.Dismissed) {
281           return;
282       }
283 
284       Astro memory astro;
285       uint cdIdx;
286 
287       var astroPool = _getAstroPoolByType(astroType);
288       astro = astroPool[idx];
289       (astroType, cdIdx, famedID, mass) = _extractCode(astro.code);
290 
291       return (id, idx, astroType, _bytes32ToString(astro.name), mass, astro.createTime, famedID, astro.nextAttractTime, cd[cdIdx]);
292   }
293 
294   function getAstroInfoByIdx(uint index, AstroType aType) constant external returns(uint novaId, uint idx, AstroType astroType, string astroName, uint mass, uint createTime, uint famedID, uint nextAttractTime, uint cdTime) {
295       if (aType == AstroType.Placeholder || aType == AstroType.Dismissed) {
296           return;
297       }
298 
299       var astroPool = _getAstroPoolByType(aType);
300       Astro memory astro = astroPool[index];
301       uint cdIdx;
302       (astroType, cdIdx, famedID, mass) = _extractCode(astro.code);
303       return (astro.id, index, astroType, _bytes32ToString(astro.name), mass, astro.createTime, famedID, astro.nextAttractTime, cd[cdIdx]);
304   }
305 
306   function getSupernovaBalance() constant external returns(uint) {
307       return superNovaSupply;
308   }
309 
310   function getAstroPoolLength(AstroType astroType) constant external returns(uint) {
311       Astro[] storage pool = _getAstroPoolByType(astroType);
312       return pool.length;
313   }
314 
315   // read from end position
316   function getAstroIdxsByPage(uint lastIndex, uint count, AstroType expectedType) constant external returns(uint[] idx, uint idxLen) {
317       if (expectedType == AstroType.Placeholder || expectedType == AstroType.Dismissed) {
318           return;
319       }
320 
321       Astro[] storage astroPool = _getAstroPoolByType(expectedType);
322 
323       if (lastIndex == 0 || astroPool.length == 0 || lastIndex > astroPool.length) {
324           return;
325       }
326 
327       uint[] memory result = new uint[](count);
328       uint start = lastIndex - 1;
329       uint i = 0;
330       for (uint cursor = start; cursor >= 0 && i < count; --cursor) {
331           var astro = astroPool[cursor];
332           if (_isValidAstro(_getAstroTypeByCode(astro.code))) {
333             result[i++] = cursor;
334           }
335           if (cursor == 0) {
336               break;
337           }
338       }
339 
340       // ugly
341       uint[] memory finalR = new uint[](i);
342       for (uint cnt = 0; cnt < i; cnt++) {
343         finalR[cnt] = result[cnt];
344       }
345 
346       return (finalR, i);
347   }
348 
349   function isUserOwnNovas(address userAddress, uint[] novaIDs) constant external returns(bool isOwn) {
350       for (uint i = 0; i < novaIDs.length; i++) {
351           if (astroIndexToOwners[novaIDs[i]] != userAddress) {
352               return false;
353           }
354       }
355 
356       return true;
357   }
358 
359   function getUserPurchasingTime(address buyerAddress) constant external returns(uint) {
360     return purchasingBuyer[buyerAddress].time;
361   }
362 
363   function _extractIndex(uint codeIdx) pure public returns(uint index, AstroType astroType) {
364       astroType = AstroType(codeIdx & 0x0000000000ff);
365       index = uint(codeIdx >> 8);
366   }
367 
368   function _combineIndex(uint index, AstroType astroType) pure public returns(uint codeIdx) {
369       codeIdx = uint((index << 8) | uint(astroType));
370   }
371 
372   function _updateAstroTypeForIndexCode(uint orgCodeIdx, AstroType astroType) pure public returns(uint) {
373       return (orgCodeIdx & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00) | (uint(astroType));
374   }
375 
376   function _updateIndexForIndexCode(uint orgCodeIdx, uint idx) pure public returns(uint) {
377       return (orgCodeIdx & 0xff) | (idx << 8);
378   }
379 
380   function _extractCode(uint48 code) pure public returns(AstroType astroType, uint cdIdx, uint famedID, uint mass) {
381      astroType = AstroType(code & 0x0000000000ff);
382      if (astroType == AstroType.NormalStar) {
383         cdIdx = (code & 0x00000000ff00) >> 8;
384         famedID = 0;
385         mass = (code & 0xffff00000000) >> 32;
386      } else if (astroType == AstroType.FamedStar) {
387         cdIdx = (code & 0x00000000ff00) >> 8;
388         famedID = (code & 0x0000ffff0000) >> 16;
389         mass = (code & 0xffff00000000) >> 32;
390      } else if (astroType == AstroType.Supernova) {
391         cdIdx = 0;
392         famedID = 0;
393         mass = 0;
394      } else {
395         cdIdx = 0;
396         famedID = 0;
397         mass = (code & 0xffff00000000) >> 32;
398      }
399   }
400 
401   function _getAstroTypeByCode(uint48 code) pure internal returns(AstroType astroType) {
402      return AstroType(code & 0x0000000000ff);
403   }
404 
405   function _getMassByCode(uint48 code) pure internal returns(uint mass) {
406      return uint((code & 0xffff00000000) >> 32);
407   }
408 
409   function _getCdIdxByCode(uint48 code) pure internal returns(uint cdIdx) {
410      return uint((code & 0x00000000ff00) >> 8);
411   }
412 
413   function _getFamedIDByCode(uint48 code) pure internal returns(uint famedID) {
414     return uint((code & 0x0000ffff0000) >> 16);
415   }
416 
417   function _combieCode(AstroType astroType, uint cdIdx, uint famedID, uint mass) pure public returns(uint48 code) {
418      if (astroType == AstroType.NormalStar) {
419         return uint48(astroType) | (uint48(cdIdx) << 8) | (uint48(mass) << 32);
420      } else if (astroType == AstroType.FamedStar) {
421         return uint48(astroType) | (uint48(cdIdx) << 8) | (uint48(famedID) << 16) | (uint48(mass) << 32);
422      } else if (astroType == AstroType.Supernova) {
423         return uint48(astroType);
424      } else {
425         return uint48(astroType) | (uint48(mass) << 32);
426      }
427   }
428 
429   function _updateAstroTypeForCode(uint48 orgCode, AstroType newType) pure public returns(uint48 newCode) {
430      return (orgCode & 0xffffffffff00) | (uint48(newType));
431   }
432 
433   function _updateCdIdxForCode(uint48 orgCode, uint newIdx) pure public returns(uint48 newCode) {
434      return (orgCode & 0xffffffff00ff) | (uint48(newIdx) << 8);
435   }
436 
437   function _getAstroPoolByType(AstroType expectedType) constant internal returns(Astro[] storage pool) {
438       if (expectedType == AstroType.Supernova) {
439           return supernovas;
440       } else if (expectedType == AstroType.Meteorite) {
441           return meteorites;
442       } else if (expectedType == AstroType.NormalStar) {
443           return normalStars;
444       } else if (expectedType == AstroType.FamedStar) {
445           return famedStars;
446       }
447   }
448 
449   function _isValidAstro(AstroType astroType) pure internal returns(bool) {
450       return astroType != AstroType.Placeholder && astroType != AstroType.Dismissed;
451   }
452 
453   function _reduceValidAstroCount() internal {
454     --validAstroCount;
455   }
456 
457   function _plusValidAstroCount() internal {
458     ++validAstroCount;
459   }
460 
461   function _addAstro(AstroType astroType, bytes32 astroName, uint mass, uint createTime, uint famedID) internal returns(uint) {
462     uint48 code = _combieCode(astroType, 0, famedID, mass);
463 
464     var astroPool = _getAstroPoolByType(astroType);
465     ++astroIDPool;
466     uint idx = astroPool.push(Astro({
467         id: astroIDPool,
468         name: astroName,
469         createTime: createTime,
470         nextAttractTime: 0,
471         code: code
472     })) - 1;
473 
474     idToIndex[astroIDPool] = _combineIndex(idx, astroType);
475 
476     return astroIDPool;
477   }
478 
479   function _removeAstroFromUser(address userAddress, uint novaID) internal {
480     uint idsLen = astroOwnerToIDsLen[userAddress];
481     uint index = astroOwnerToIDIndex[userAddress][novaID];
482 
483     if (idsLen > 1 && index != idsLen - 1) {
484         uint endNovaID = astroOwnerToIDs[userAddress][idsLen - 1];
485         astroOwnerToIDs[userAddress][index] = endNovaID;
486         astroOwnerToIDIndex[userAddress][endNovaID] = index;
487     }
488     astroOwnerToIDs[userAddress][idsLen - 1] = 0;
489     astroOwnerToIDsLen[userAddress] = idsLen - 1;
490   }
491 
492   function _addAstroToUser(address userAddress, uint novaID) internal {
493     uint idsLen = astroOwnerToIDsLen[userAddress];
494     uint arrayLen = astroOwnerToIDs[userAddress].length;
495     if (idsLen == arrayLen) {
496       astroOwnerToIDsLen[userAddress] = astroOwnerToIDs[userAddress].push(novaID);
497       astroOwnerToIDIndex[userAddress][novaID] = astroOwnerToIDsLen[userAddress] - 1;
498     } else {
499       // there is gap
500       astroOwnerToIDs[userAddress][idsLen] = novaID;
501       astroOwnerToIDsLen[userAddress] = idsLen + 1;
502       astroOwnerToIDIndex[userAddress][novaID] = idsLen;
503     }
504   }
505 
506   function _burnDownAstro(address userAddress, uint novaID) internal {
507     delete astroIndexToOwners[novaID];
508     _removeAstroFromUser(userAddress, novaID);
509 
510     uint idx;
511     AstroType astroType;
512     uint orgIdxCode = idToIndex[novaID];
513     (idx, astroType) = _extractIndex(orgIdxCode);
514 
515     var pool = _getAstroPoolByType(astroType);
516     pool[idx].code = _updateAstroTypeForCode(pool[idx].code, AstroType.Dismissed);
517 
518     idToIndex[novaID] = _updateAstroTypeForIndexCode(orgIdxCode, AstroType.Dismissed);
519 
520     _reduceValidAstroCount();
521   }
522 
523   function _insertNewAstro(address userAddress, AstroType t, uint mass, bytes32 novaName, uint famedID) internal returns(uint) {
524     uint newNovaID = _addAstro(t, novaName, mass, block.timestamp, famedID);
525     astroIndexToOwners[newNovaID] = userAddress;
526     _addAstroToUser(userAddress, newNovaID);
527 
528     _plusValidAstroCount();
529     return newNovaID;
530   }
531 
532   function _bytes32ToString(bytes32 x) internal pure returns (string) {
533     bytes memory bytesString = new bytes(32);
534     uint charCount = 0;
535     for (uint j = 0; j < 32; j++) {
536         byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
537         if (char != 0) {
538             bytesString[charCount] = char;
539             charCount++;
540         }
541     }
542     bytes memory bytesStringTrimmed = new bytes(charCount);
543     for (j = 0; j < charCount; j++) {
544         bytesStringTrimmed[j] = bytesString[j];
545     }
546     return string(bytesStringTrimmed);
547   }
548 
549   function _stringToBytes32(string source) internal pure returns (bytes32 result) {
550     bytes memory tempEmptyStringTest = bytes(source);
551     if (tempEmptyStringTest.length == 0) {
552         return 0x0;
553     }
554 
555     assembly {
556         result := mload(add(source, 32))
557     }
558   }
559 
560   function _transfer(address _from, address _to, uint _tokenId) internal {
561     require(_from == astroIndexToOwners[_tokenId]);
562     require(_from != _to && _to != address(0));
563 
564     uint poolIdx;
565     AstroType itemType;
566     (poolIdx, itemType) = _extractIndex(idToIndex[_tokenId]);
567     var pool = _getAstroPoolByType(itemType);
568     var astro = pool[poolIdx];
569     require(_getAstroTypeByCode(astro.code) != AstroType.Dismissed);
570 
571     astroIndexToOwners[_tokenId] = _to;
572 
573     _removeAstroFromUser(_from, _tokenId);
574     _addAstroToUser(_to, _tokenId);
575 
576     // Check if it's famous star
577     uint famedID = _getFamedIDByCode(astro.code);
578     if (famedID > 0) {
579       var famedstarContract = FamedStarInterface(famedStarAddress);
580       famedstarContract.updateFamedStarOwner(famedID, _to);
581     }
582   }
583 
584   // Purchase action only permit manager to use
585   function purchaseSupernova(address targetAddress, uint price) external onlyManager {
586     require(superNovaSupply >= 1);
587     NovaCoinInterface novaCoinContract = NovaCoinInterface(novaCoinAddress);
588     require(novaCoinContract.balanceOf(targetAddress) >= price);
589     novaCoinContract.consumeCoinForNova(targetAddress, price);
590 
591     superNovaSupply -= 1;
592     var newNovaID = _insertNewAstro(targetAddress, AstroType.Supernova, 0, 0, 0);
593     PurchasedSupernova(targetAddress, newNovaID);
594   }
595 
596   // explode one supernova from user's supernova balance, write explode result into user account
597   function explodeSupernova(address userAddress, uint novaID) external onlyManager {
598     // verifu if user own's this supernova
599     require(astroIndexToOwners[novaID] == userAddress);
600     uint poolIdx;
601     AstroType itemType;
602     (poolIdx, itemType) = _extractIndex(idToIndex[novaID]);
603     require(itemType == AstroType.Supernova);
604     // burn down user's supernova
605     _burnDownAstro(userAddress, novaID);
606 
607     uint[] memory newAstroIDs;
608 
609     var labContract = NovaLabInterface(labAddress);
610     uint star = labContract.bornStar();
611     if (star > 0) {
612         // Got star, check if it's famed star
613         newAstroIDs = new uint[](1);
614         var famedstarContract = FamedStarInterface(famedStarAddress);
615         uint famedID;
616         bytes32 novaName;
617         (famedID, novaName) = famedstarContract.bornFamedStar(userAddress, star);
618         if (famedID > 0) {
619             newAstroIDs[0] = _insertNewAstro(userAddress, AstroType.FamedStar, star, novaName, famedID);
620         } else {
621             newAstroIDs[0] = _insertNewAstro(userAddress, AstroType.NormalStar, star, 0, 0);
622         }
623     } else {
624         uint mNum = labContract.bornMeteoriteNumber();
625         newAstroIDs = new uint[](mNum);
626         uint m;
627         for (uint i = 0; i < mNum; i++) {
628             m = labContract.bornMeteorite();
629             newAstroIDs[i] = _insertNewAstro(userAddress, AstroType.Meteorite, m, 0, 0);
630         }
631     }
632     ExplodedSupernova(userAddress, newAstroIDs);
633   }
634 
635   function _merge(address userAddress, uint mergeMass) internal returns (uint famedID, bytes32 novaName, AstroType newType, uint finalMass) {
636     var labContract = NovaLabInterface(labAddress);
637     bool mergeResult;
638     (mergeResult, finalMass) = labContract.mergeMeteorite(mergeMass);
639     if (mergeResult) {
640         //got star, check if we can get famed star
641         var famedstarContract = FamedStarInterface(famedStarAddress);
642         (famedID, novaName) = famedstarContract.bornFamedStar(userAddress, mergeMass);
643         if (famedID > 0) {
644             newType = AstroType.FamedStar;
645         } else {
646             newType = AstroType.NormalStar;
647         }
648     } else {
649         newType = AstroType.Meteorite;
650     }
651     return;
652   }
653 
654   function _combine(address userAddress, uint[] astroIDs) internal returns(uint mergeMass) {
655     uint astroID;
656     mergeMass = 0;
657     uint poolIdx;
658     AstroType itemType;
659     for (uint i = 0; i < astroIDs.length; i++) {
660         astroID = astroIDs[i];
661         (poolIdx, itemType) = _extractIndex(idToIndex[astroID]);
662         require(astroIndexToOwners[astroID] == userAddress);
663         require(itemType == AstroType.Meteorite);
664         // start merge
665         //mergeMass += meteorites[idToIndex[astroID].index].mass;
666         mergeMass += _getMassByCode(meteorites[poolIdx].code);
667         // Burn down
668         _burnDownAstro(userAddress, astroID);
669     }
670   }
671 
672   function mergeAstros(address userAddress, uint novaCoinCentCost, uint[] astroIDs) external onlyManager {
673     // check nova coin balance
674     NovaCoinInterface novaCoinContract = NovaCoinInterface(novaCoinAddress);
675     require(novaCoinContract.balanceOf(userAddress) >= novaCoinCentCost);
676     // check astros
677     require(astroIDs.length > 1 && astroIDs.length <= 10);
678 
679     uint mergeMass = _combine(userAddress, astroIDs);
680     // Consume novaCoin
681     novaCoinContract.consumeCoinForNova(userAddress, novaCoinCentCost);
682     // start merge
683     uint famedID;
684     bytes32 novaName;
685     AstroType newType;
686     uint finalMass;
687     (famedID, novaName, newType, finalMass) = _merge(userAddress, mergeMass);
688     // Create new Astro
689     MergedAstros(userAddress, _insertNewAstro(userAddress, newType, finalMass, novaName, famedID));
690   }
691 
692   function _attractBalanceCheck(address userAddress, uint novaCoinCentCost) internal {
693     // check balance
694     NovaCoinInterface novaCoinContract = NovaCoinInterface(novaCoinAddress);
695     require(novaCoinContract.balanceOf(userAddress) >= novaCoinCentCost);
696 
697     // consume coin
698     novaCoinContract.consumeCoinForNova(userAddress, novaCoinCentCost);
699   }
700 
701   function attractMeteorites(address userAddress, uint novaCoinCentCost, uint starID) external onlyManager {
702     require(astroIndexToOwners[starID] == userAddress);
703     uint poolIdx;
704     AstroType itemType;
705     (poolIdx, itemType) = _extractIndex(idToIndex[starID]);
706 
707     require(itemType == AstroType.NormalStar || itemType == AstroType.FamedStar);
708 
709     var astroPool = _getAstroPoolByType(itemType);
710     Astro storage astro = astroPool[poolIdx];
711     require(astro.nextAttractTime <= block.timestamp);
712 
713     _attractBalanceCheck(userAddress, novaCoinCentCost);
714 
715     var labContract = NovaLabInterface(labAddress);
716     uint[] memory newAstroIDs = new uint[](1);
717     uint m = labContract.bornMeteorite();
718     newAstroIDs[0] = _insertNewAstro(userAddress, AstroType.Meteorite, m, 0, 0);
719     // update cd
720     uint cdIdx = _getCdIdxByCode(astro.code);
721     if (cdIdx >= cd.length - 1) {
722         astro.nextAttractTime = block.timestamp + cd[cd.length - 1];
723     } else {
724         astro.code = _updateCdIdxForCode(astro.code, ++cdIdx);
725         astro.nextAttractTime = block.timestamp + cd[cdIdx];
726     }
727 
728     AttractedMeteorites(userAddress, newAstroIDs);
729   }
730 
731   function setPurchasing(address buyerAddress, address ownerAddress, uint astroID, uint priceWei) external onlyManager {
732     require(astroIndexToOwners[astroID] == ownerAddress);
733     purchasingBuyer[buyerAddress] = PurchasingRecord({
734          id: astroID,
735          priceWei: priceWei,
736          time: block.timestamp
737     });
738     NovaPurchasing(buyerAddress, astroID, priceWei);
739   }
740 
741   function userPurchaseAstro(address ownerAddress, uint astroID) payable external {
742     // check valid purchasing tim
743     require(msg.sender.balance >= msg.value);
744     var record = purchasingBuyer[msg.sender];
745     require(block.timestamp < record.time + priceValidSeconds);
746     require(record.id == astroID);
747     require(record.priceWei <= msg.value);
748 
749     uint royalties = uint(msg.value * novaTransferRate / 1000);
750     ownerAddress.transfer(msg.value - royalties);
751     cfoAddress.transfer(royalties);
752 
753     _transfer(ownerAddress, msg.sender, astroID);
754 
755     UserPurchasedAstro(msg.sender, ownerAddress, astroID, record.priceWei, msg.value);
756     // clear purchasing state
757     delete purchasingBuyer[msg.sender];
758   }
759 }