1 /* ==================================================================== */
2 /* Copyright (c) 2018 The ether.online Project.  All rights reserved.
3 /* 
4 /* https://ether.online  The first RPG game of blockchain 
5 /*  
6 /* authors rickhunter.shen@gmail.com   
7 /*         ssesunding@gmail.com            
8 /* ==================================================================== */
9 
10 pragma solidity ^0.4.20;
11 
12 /// @title ERC-165 Standard Interface Detection
13 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
14 interface ERC165 {
15     function supportsInterface(bytes4 interfaceID) external view returns (bool);
16 }
17 
18 /// @title ERC-721 Non-Fungible Token Standard
19 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
20 contract ERC721 is ERC165 {
21     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
22     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
23     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
24     function balanceOf(address _owner) external view returns (uint256);
25     function ownerOf(uint256 _tokenId) external view returns (address);
26     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
27     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
28     function transferFrom(address _from, address _to, uint256 _tokenId) external;
29     function approve(address _approved, uint256 _tokenId) external;
30     function setApprovalForAll(address _operator, bool _approved) external;
31     function getApproved(uint256 _tokenId) external view returns (address);
32     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
33 }
34 
35 /// @title ERC-721 Non-Fungible Token Standard
36 interface ERC721TokenReceiver {
37 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
38 }
39 
40 contract AccessAdmin {
41     bool public isPaused = false;
42     address public addrAdmin;  
43 
44     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
45 
46     function AccessAdmin() public {
47         addrAdmin = msg.sender;
48     }  
49 
50     modifier onlyAdmin() {
51         require(msg.sender == addrAdmin);
52         _;
53     }
54 
55     modifier whenNotPaused() {
56         require(!isPaused);
57         _;
58     }
59 
60     modifier whenPaused {
61         require(isPaused);
62         _;
63     }
64 
65     function setAdmin(address _newAdmin) external onlyAdmin {
66         require(_newAdmin != address(0));
67         AdminTransferred(addrAdmin, _newAdmin);
68         addrAdmin = _newAdmin;
69     }
70 
71     function doPause() external onlyAdmin whenNotPaused {
72         isPaused = true;
73     }
74 
75     function doUnpause() external onlyAdmin whenPaused {
76         isPaused = false;
77     }
78 }
79 
80 contract AccessService is AccessAdmin {
81     address public addrService;
82     address public addrFinance;
83 
84     modifier onlyService() {
85         require(msg.sender == addrService);
86         _;
87     }
88 
89     modifier onlyFinance() {
90         require(msg.sender == addrFinance);
91         _;
92     }
93 
94     function setService(address _newService) external {
95         require(msg.sender == addrService || msg.sender == addrAdmin);
96         require(_newService != address(0));
97         addrService = _newService;
98     }
99 
100     function setFinance(address _newFinance) external {
101         require(msg.sender == addrFinance || msg.sender == addrAdmin);
102         require(_newFinance != address(0));
103         addrFinance = _newFinance;
104     }
105 
106     function withdraw(address _target, uint256 _amount) 
107         external 
108     {
109         require(msg.sender == addrFinance || msg.sender == addrAdmin);
110         require(_amount > 0);
111         address receiver = _target == address(0) ? addrFinance : _target;
112         uint256 balance = this.balance;
113         if (_amount < balance) {
114             receiver.transfer(_amount);
115         } else {
116             receiver.transfer(this.balance);
117         }      
118     }
119 }
120 
121 interface IDataMining {
122     function getRecommender(address _target) external view returns(address);
123     function subFreeMineral(address _target) external returns(bool);
124 }
125 
126 interface IDataEquip {
127     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
128     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
129     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
130 }
131 
132 interface IDataAuction {
133     function isOnSale(uint256 _tokenId) external view returns(bool);
134     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
135     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
136 }
137 
138 contract WarToken is ERC721, AccessAdmin {
139     /// @dev The equipment info
140     struct Fashion {
141         uint16 protoId;     // 0  Equipment ID
142         uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
143         uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets
144         uint16 health;      // 3  Health
145         uint16 atkMin;      // 4  Min attack
146         uint16 atkMax;      // 5  Max attack
147         uint16 defence;     // 6  Defennse
148         uint16 crit;        // 7  Critical rate
149         uint16 isPercent;   // 8  Attr value type
150         uint16 attrExt1;    // 9  future stat 1
151         uint16 attrExt2;    // 10 future stat 2
152         uint16 attrExt3;    // 11 future stat 3
153     }
154 
155     /// @dev All equipments tokenArray (not exceeding 2^32-1)
156     Fashion[] public fashionArray;
157 
158     /// @dev Amount of tokens destroyed
159     uint256 destroyFashionCount;
160 
161     /// @dev Equipment token ID vs owner address
162     mapping (uint256 => address) fashionIdToOwner;
163 
164     /// @dev Equipments owner by the owner (array)
165     mapping (address => uint256[]) ownerToFashionArray;
166 
167     /// @dev Equipment token ID search in owner array
168     mapping (uint256 => uint256) fashionIdToOwnerIndex;
169 
170     /// @dev The authorized address for each WAR
171     mapping (uint256 => address) fashionIdToApprovals;
172 
173     /// @dev The authorized operators for each address
174     mapping (address => mapping (address => bool)) operatorToApprovals;
175 
176     /// @dev Trust contract
177     mapping (address => bool) actionContracts;
178 
179     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
180         actionContracts[_actionAddr] = _useful;
181     }
182 
183     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
184         return actionContracts[_actionAddr];
185     }
186 
187     /// @dev This emits when the approved address for an WAR is changed or reaffirmed.
188     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
189 
190     /// @dev This emits when an operator is enabled or disabled for an owner.
191     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
192 
193     /// @dev This emits when the equipment ownership changed 
194     event Transfer(address indexed from, address indexed to, uint256 tokenId);
195 
196     /// @dev This emits when the equipment created
197     event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);
198 
199     /// @dev This emits when the equipment's attributes changed
200     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
201 
202     /// @dev This emits when the equipment destroyed
203     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
204     
205     function WarToken() public {
206         addrAdmin = msg.sender;
207         fashionArray.length += 1;
208     }
209 
210     // modifier
211     /// @dev Check if token ID is valid
212     modifier isValidToken(uint256 _tokenId) {
213         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
214         require(fashionIdToOwner[_tokenId] != address(0)); 
215         _;
216     }
217 
218     modifier canTransfer(uint256 _tokenId) {
219         address owner = fashionIdToOwner[_tokenId];
220         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
221         _;
222     }
223 
224     // ERC721
225     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
226         // ERC165 || ERC721 || ERC165^ERC721
227         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
228     }
229         
230     function name() public pure returns(string) {
231         return "WAR Token";
232     }
233 
234     function symbol() public pure returns(string) {
235         return "WAR";
236     }
237 
238     /// @dev Search for token quantity address
239     /// @param _owner Address that needs to be searched
240     /// @return Returns token quantity
241     function balanceOf(address _owner) external view returns(uint256) {
242         require(_owner != address(0));
243         return ownerToFashionArray[_owner].length;
244     }
245 
246     /// @dev Find the owner of an WAR
247     /// @param _tokenId The tokenId of WAR
248     /// @return Give The address of the owner of this WAR
249     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
250         return fashionIdToOwner[_tokenId];
251     }
252 
253     /// @dev Transfers the ownership of an WAR from one address to another address
254     /// @param _from The current owner of the WAR
255     /// @param _to The new owner
256     /// @param _tokenId The WAR to transfer
257     /// @param data Additional data with no specified format, sent in call to `_to`
258     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
259         external
260         whenNotPaused
261     {
262         _safeTransferFrom(_from, _to, _tokenId, data);
263     }
264 
265     /// @dev Transfers the ownership of an WAR from one address to another address
266     /// @param _from The current owner of the WAR
267     /// @param _to The new owner
268     /// @param _tokenId The WAR to transfer
269     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
270         external
271         whenNotPaused
272     {
273         _safeTransferFrom(_from, _to, _tokenId, "");
274     }
275 
276     /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost
277     /// @param _from The current owner of the WAR
278     /// @param _to The new owner
279     /// @param _tokenId The WAR to transfer
280     function transferFrom(address _from, address _to, uint256 _tokenId)
281         external
282         whenNotPaused
283         isValidToken(_tokenId)
284         canTransfer(_tokenId)
285     {
286         address owner = fashionIdToOwner[_tokenId];
287         require(owner != address(0));
288         require(_to != address(0));
289         require(owner == _from);
290         
291         _transfer(_from, _to, _tokenId);
292     }
293 
294     /// @dev Set or reaffirm the approved address for an WAR
295     /// @param _approved The new approved WAR controller
296     /// @param _tokenId The WAR to approve
297     function approve(address _approved, uint256 _tokenId)
298         external
299         whenNotPaused
300     {
301         address owner = fashionIdToOwner[_tokenId];
302         require(owner != address(0));
303         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
304 
305         fashionIdToApprovals[_tokenId] = _approved;
306         Approval(owner, _approved, _tokenId);
307     }
308 
309     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
310     /// @param _operator Address to add to the set of authorized operators.
311     /// @param _approved True if the operators is approved, false to revoke approval
312     function setApprovalForAll(address _operator, bool _approved) 
313         external 
314         whenNotPaused
315     {
316         operatorToApprovals[msg.sender][_operator] = _approved;
317         ApprovalForAll(msg.sender, _operator, _approved);
318     }
319 
320     /// @dev Get the approved address for a single WAR
321     /// @param _tokenId The WAR to find the approved address for
322     /// @return The approved address for this WAR, or the zero address if there is none
323     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
324         return fashionIdToApprovals[_tokenId];
325     }
326 
327     /// @dev Query if an address is an authorized operator for another address
328     /// @param _owner The address that owns the WARs
329     /// @param _operator The address that acts on behalf of the owner
330     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
331     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
332         return operatorToApprovals[_owner][_operator];
333     }
334 
335     /// @dev Count WARs tracked by this contract
336     /// @return A count of valid WARs tracked by this contract, where each one of
337     ///  them has an assigned and queryable owner not equal to the zero address
338     function totalSupply() external view returns (uint256) {
339         return fashionArray.length - destroyFashionCount - 1;
340     }
341 
342     /// @dev Do the real transfer with out any condition checking
343     /// @param _from The old owner of this WAR(If created: 0x0)
344     /// @param _to The new owner of this WAR 
345     /// @param _tokenId The tokenId of the WAR
346     function _transfer(address _from, address _to, uint256 _tokenId) internal {
347         if (_from != address(0)) {
348             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
349             uint256[] storage fsArray = ownerToFashionArray[_from];
350             require(fsArray[indexFrom] == _tokenId);
351 
352             // If the WAR is not the element of array, change it to with the last
353             if (indexFrom != fsArray.length - 1) {
354                 uint256 lastTokenId = fsArray[fsArray.length - 1];
355                 fsArray[indexFrom] = lastTokenId; 
356                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
357             }
358             fsArray.length -= 1; 
359             
360             if (fashionIdToApprovals[_tokenId] != address(0)) {
361                 delete fashionIdToApprovals[_tokenId];
362             }      
363         }
364 
365         // Give the WAR to '_to'
366         fashionIdToOwner[_tokenId] = _to;
367         ownerToFashionArray[_to].push(_tokenId);
368         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
369         
370         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
371     }
372 
373     /// @dev Actually perform the safeTransferFrom
374     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
375         internal
376         isValidToken(_tokenId) 
377         canTransfer(_tokenId)
378     {
379         address owner = fashionIdToOwner[_tokenId];
380         require(owner != address(0));
381         require(_to != address(0));
382         require(owner == _from);
383         
384         _transfer(_from, _to, _tokenId);
385 
386         // Do the callback after everything is done to avoid reentrancy attack
387         uint256 codeSize;
388         assembly { codeSize := extcodesize(_to) }
389         if (codeSize == 0) {
390             return;
391         }
392         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
393         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
394         require(retval == 0xf0b9e5ba);
395     }
396 
397     //----------------------------------------------------------------------------------------------------------
398 
399     /// @dev Equipment creation
400     /// @param _owner Owner of the equipment created
401     /// @param _attrs Attributes of the equipment created
402     /// @return Token ID of the equipment created
403     function createFashion(address _owner, uint16[9] _attrs, uint16 _createType) 
404         external 
405         whenNotPaused
406         returns(uint256)
407     {
408         require(actionContracts[msg.sender]);
409         require(_owner != address(0));
410 
411         uint256 newFashionId = fashionArray.length;
412         require(newFashionId < 4294967296);
413 
414         fashionArray.length += 1;
415         Fashion storage fs = fashionArray[newFashionId];
416         fs.protoId = _attrs[0];
417         fs.quality = _attrs[1];
418         fs.pos = _attrs[2];
419         if (_attrs[3] != 0) {
420             fs.health = _attrs[3];
421         }
422         
423         if (_attrs[4] != 0) {
424             fs.atkMin = _attrs[4];
425             fs.atkMax = _attrs[5];
426         }
427        
428         if (_attrs[6] != 0) {
429             fs.defence = _attrs[6];
430         }
431         
432         if (_attrs[7] != 0) {
433             fs.crit = _attrs[7];
434         }
435 
436         if (_attrs[8] != 0) {
437             fs.isPercent = _attrs[8];
438         }
439         
440         _transfer(0, _owner, newFashionId);
441         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _createType);
442         return newFashionId;
443     }
444 
445     /// @dev One specific attribute of the equipment modified
446     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
447         if (_index == 3) {
448             _fs.health = _val;
449         } else if(_index == 4) {
450             _fs.atkMin = _val;
451         } else if(_index == 5) {
452             _fs.atkMax = _val;
453         } else if(_index == 6) {
454             _fs.defence = _val;
455         } else if(_index == 7) {
456             _fs.crit = _val;
457         } else if(_index == 9) {
458             _fs.attrExt1 = _val;
459         } else if(_index == 10) {
460             _fs.attrExt2 = _val;
461         } else if(_index == 11) {
462             _fs.attrExt3 = _val;
463         }
464     }
465 
466     /// @dev Equiment attributes modified (max 4 stats modified)
467     /// @param _tokenId Equipment Token ID
468     /// @param _idxArray Stats order that must be modified
469     /// @param _params Stat value that must be modified
470     /// @param _changeType Modification type such as enhance, socket, etc.
471     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
472         external 
473         whenNotPaused
474         isValidToken(_tokenId) 
475     {
476         require(actionContracts[msg.sender]);
477 
478         Fashion storage fs = fashionArray[_tokenId];
479         if (_idxArray[0] > 0) {
480             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
481         }
482 
483         if (_idxArray[1] > 0) {
484             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
485         }
486 
487         if (_idxArray[2] > 0) {
488             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
489         }
490 
491         if (_idxArray[3] > 0) {
492             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
493         }
494 
495         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
496     }
497 
498     /// @dev Equipment destruction
499     /// @param _tokenId Equipment Token ID
500     /// @param _deleteType Destruction type, such as craft
501     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
502         external 
503         whenNotPaused
504         isValidToken(_tokenId) 
505     {
506         require(actionContracts[msg.sender]);
507 
508         address _from = fashionIdToOwner[_tokenId];
509         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
510         uint256[] storage fsArray = ownerToFashionArray[_from]; 
511         require(fsArray[indexFrom] == _tokenId);
512 
513         if (indexFrom != fsArray.length - 1) {
514             uint256 lastTokenId = fsArray[fsArray.length - 1];
515             fsArray[indexFrom] = lastTokenId; 
516             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
517         }
518         fsArray.length -= 1; 
519 
520         fashionIdToOwner[_tokenId] = address(0);
521         delete fashionIdToOwnerIndex[_tokenId];
522         destroyFashionCount += 1;
523 
524         Transfer(_from, 0, _tokenId);
525 
526         DeleteFashion(_from, _tokenId, _deleteType);
527     }
528 
529     /// @dev Safe transfer by trust contracts
530     function safeTransferByContract(uint256 _tokenId, address _to) 
531         external
532         whenNotPaused
533     {
534         require(actionContracts[msg.sender]);
535 
536         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
537         address owner = fashionIdToOwner[_tokenId];
538         require(owner != address(0));
539         require(_to != address(0));
540         require(owner != _to);
541 
542         _transfer(owner, _to, _tokenId);
543     }
544 
545     //----------------------------------------------------------------------------------------------------------
546 
547     /// @dev Get fashion attrs by tokenId
548     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {
549         Fashion storage fs = fashionArray[_tokenId];
550         datas[0] = fs.protoId;
551         datas[1] = fs.quality;
552         datas[2] = fs.pos;
553         datas[3] = fs.health;
554         datas[4] = fs.atkMin;
555         datas[5] = fs.atkMax;
556         datas[6] = fs.defence;
557         datas[7] = fs.crit;
558         datas[8] = fs.isPercent;
559         datas[9] = fs.attrExt1;
560         datas[10] = fs.attrExt2;
561         datas[11] = fs.attrExt3;
562     }
563 
564     /// @dev Get tokenIds and flags by owner
565     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
566         require(_owner != address(0));
567         uint256[] storage fsArray = ownerToFashionArray[_owner];
568         uint256 length = fsArray.length;
569         tokens = new uint256[](length);
570         flags = new uint32[](length);
571         for (uint256 i = 0; i < length; ++i) {
572             tokens[i] = fsArray[i];
573             Fashion storage fs = fashionArray[fsArray[i]];
574             flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);
575         }
576     }
577 
578     /// @dev WAR token info returned based on Token ID transfered (64 at most)
579     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
580         uint256 length = _tokens.length;
581         require(length <= 64);
582         attrs = new uint16[](length * 11);
583         uint256 tokenId;
584         uint256 index;
585         for (uint256 i = 0; i < length; ++i) {
586             tokenId = _tokens[i];
587             if (fashionIdToOwner[tokenId] != address(0)) {
588                 index = i * 11;
589                 Fashion storage fs = fashionArray[tokenId];
590                 attrs[index] = fs.health;
591                 attrs[index + 1] = fs.atkMin;
592                 attrs[index + 2] = fs.atkMax;
593                 attrs[index + 3] = fs.defence;
594                 attrs[index + 4] = fs.crit;
595                 attrs[index + 5] = fs.isPercent;
596                 attrs[index + 6] = fs.attrExt1;
597                 attrs[index + 7] = fs.attrExt2;
598                 attrs[index + 8] = fs.attrExt3;
599             }   
600         }
601     }
602 }
603 
604 contract ActionStarUp is AccessService {
605     event StarUpSuccess(address indexed owner, uint256 tokenId, uint16 star);
606 
607     /// @dev Auction contract address
608     IDataAuction public auctionContract;
609     /// @dev DataEquip contract address
610     IDataEquip public equipContract;
611     /// @dev WarToken(NFT) contract address
612     WarToken public tokenContract;
613 
614     function ActionStarUp(address _nftAddr) public {
615         addrAdmin = msg.sender;
616         addrService = msg.sender;
617         addrFinance = msg.sender;
618 
619         tokenContract = WarToken(_nftAddr);
620     }
621 
622     function setDataAuction(address _addr) external onlyAdmin {
623         require(_addr != address(0));
624         auctionContract = IDataAuction(_addr);
625     }
626 
627     function setDataEquip(address _addr) external onlyAdmin {
628         require(_addr != address(0));
629         equipContract = IDataEquip(_addr);
630     }
631 
632     function starUpZero(uint256 _tokenDest, uint256 _token1, uint256 _token2) 
633         external
634         whenNotPaused
635     {
636         require(tokenContract.ownerOf(_tokenDest) == msg.sender);
637         require(tokenContract.ownerOf(_token1) == msg.sender);
638         require(tokenContract.ownerOf(_token2) == msg.sender);
639         require(!equipContract.isEquipedAny2(msg.sender, _token1, _token2));
640 
641         if (address(auctionContract) != address(0)) {
642             require(!auctionContract.isOnSaleAny2(_token1, _token2));
643         }
644 
645         uint16 quality;
646         uint16 pos; 
647         uint16 star;
648         uint16[12] memory fashionData = tokenContract.getFashion(_tokenDest);
649         quality = fashionData[1];
650         pos = fashionData[2];
651         star = fashionData[9];
652 
653         require(quality == 5 && pos <= 5 && star == 0); 
654 
655         fashionData = tokenContract.getFashion(_token1);
656         require(fashionData[1] == 5 && fashionData[2] == pos && fashionData[9] == 0); 
657 
658         fashionData = tokenContract.getFashion(_token2);
659         require(fashionData[1] == 5 && fashionData[2] == pos && fashionData[9] == 0);
660 
661         tokenContract.destroyFashion(_token1, 2);
662         tokenContract.destroyFashion(_token2, 2);
663         uint16[4] memory idxArray = [uint16(9), 0, 0, 0];
664         uint16[4] memory params = [uint16(1), 0, 0, 0];
665         tokenContract.changeFashionAttr(_tokenDest, idxArray, params, 2);
666 
667         StarUpSuccess(msg.sender, _tokenDest, 1);
668     }
669 
670     function starUp(uint256 _tokenDest, uint256 _token1, uint256 _token2, uint256 _token3) 
671         external
672         whenNotPaused
673     {
674         require(tokenContract.ownerOf(_tokenDest) == msg.sender);
675         require(tokenContract.ownerOf(_token1) == msg.sender);
676         require(tokenContract.ownerOf(_token2) == msg.sender);
677         require(tokenContract.ownerOf(_token3) == msg.sender);
678         require(!equipContract.isEquipedAny3(msg.sender, _token1, _token2, _token3));
679 
680         if (address(auctionContract) != address(0)) {
681             require(!auctionContract.isOnSaleAny3(_token1, _token2, _token3));
682         }
683 
684         uint16 quality;
685         uint16 pos; 
686         uint16 star;
687         uint16[12] memory fashionData = tokenContract.getFashion(_tokenDest);
688         quality = fashionData[1];
689         pos = fashionData[2];
690         star = fashionData[9];
691 
692         require(quality == 5 && pos <= 5 && star > 0 && star < 5); 
693 
694         fashionData = tokenContract.getFashion(_token1);
695         require(fashionData[1] == 5 && fashionData[2] == pos && fashionData[9] == (star - 1)); 
696 
697         fashionData = tokenContract.getFashion(_token2);
698         require(fashionData[1] == 5 && fashionData[2] == pos && fashionData[9] == (star - 1));
699 
700         fashionData = tokenContract.getFashion(_token3);
701         require(fashionData[1] == 5 && fashionData[2] == pos && fashionData[9] == (star - 1));
702 
703         tokenContract.destroyFashion(_token1, 2);
704         tokenContract.destroyFashion(_token2, 2);
705         tokenContract.destroyFashion(_token3, 2);
706         uint16[4] memory idxArray = [uint16(9), 0, 0, 0];
707         uint16[4] memory params = [star + 1, 0, 0, 0];
708         tokenContract.changeFashionAttr(_tokenDest, idxArray, params, 2);
709 
710         StarUpSuccess(msg.sender, _tokenDest, 1);
711     }
712 }