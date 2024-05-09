1 /* ==================================================================== */
2 /* Copyright (c) 2018 The ether.online Project.  All rights reserved.
3 /* 
4 /* https://ether.online  The first RPG game of blockchain                 
5 /* ==================================================================== */
6 pragma solidity ^0.4.20;
7 
8 /// @title ERC-165 Standard Interface Detection
9 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
10 interface ERC165 {
11     function supportsInterface(bytes4 interfaceID) external view returns (bool);
12 }
13 
14 /// @title ERC-721 Non-Fungible Token Standard
15 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
16 contract ERC721 is ERC165 {
17     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
18     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
19     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
20     function balanceOf(address _owner) external view returns (uint256);
21     function ownerOf(uint256 _tokenId) external view returns (address);
22     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
23     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
24     function transferFrom(address _from, address _to, uint256 _tokenId) external;
25     function approve(address _approved, uint256 _tokenId) external;
26     function setApprovalForAll(address _operator, bool _approved) external;
27     function getApproved(uint256 _tokenId) external view returns (address);
28     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
29 }
30 
31 /// @title ERC-721 Non-Fungible Token Standard
32 interface ERC721TokenReceiver {
33 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
34 }
35 
36 contract AccessAdmin {
37     bool public isPaused = false;
38     address public addrAdmin;  
39 
40     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
41 
42     function AccessAdmin() public {
43         addrAdmin = msg.sender;
44     }  
45 
46 
47     modifier onlyAdmin() {
48         require(msg.sender == addrAdmin);
49         _;
50     }
51 
52     modifier whenNotPaused() {
53         require(!isPaused);
54         _;
55     }
56 
57     modifier whenPaused {
58         require(isPaused);
59         _;
60     }
61 
62     function setAdmin(address _newAdmin) external onlyAdmin {
63         require(_newAdmin != address(0));
64         AdminTransferred(addrAdmin, _newAdmin);
65         addrAdmin = _newAdmin;
66     }
67 
68     function doPause() external onlyAdmin whenNotPaused {
69         isPaused = true;
70     }
71 
72     function doUnpause() external onlyAdmin whenPaused {
73         isPaused = false;
74     }
75 }
76 
77 contract AccessService is AccessAdmin {
78     address public addrService;
79     address public addrFinance;
80 
81     modifier onlyService() {
82         require(msg.sender == addrService);
83         _;
84     }
85 
86     modifier onlyFinance() {
87         require(msg.sender == addrFinance);
88         _;
89     }
90 
91     function setService(address _newService) external {
92         require(msg.sender == addrService || msg.sender == addrAdmin);
93         require(_newService != address(0));
94         addrService = _newService;
95     }
96 
97     function setFinance(address _newFinance) external {
98         require(msg.sender == addrFinance || msg.sender == addrAdmin);
99         require(_newFinance != address(0));
100         addrFinance = _newFinance;
101     }
102 }
103 
104 contract WarToken is ERC721, AccessAdmin {
105     /// @dev The equipment info
106     struct Fashion {
107         uint16 protoId;     // 0  Equipment ID
108         uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
109         uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets
110         uint16 health;      // 3  Health
111         uint16 atkMin;      // 4  Min attack
112         uint16 atkMax;      // 5  Max attack
113         uint16 defence;     // 6  Defennse
114         uint16 crit;        // 7  Critical rate
115         uint16 isPercent;   // 8  Attr value type
116         uint16 attrExt1;    // 9  future stat 1
117         uint16 attrExt2;    // 10 future stat 2
118         uint16 attrExt3;    // 11 future stat 3
119     }
120 
121     /// @dev All equipments tokenArray (not exceeding 2^32-1)
122     Fashion[] public fashionArray;
123 
124     /// @dev Amount of tokens destroyed
125     uint256 destroyFashionCount;
126 
127     /// @dev Equipment token ID vs owner address
128     mapping (uint256 => address) fashionIdToOwner;
129 
130     /// @dev Equipments owner by the owner (array)
131     mapping (address => uint256[]) ownerToFashionArray;
132 
133     /// @dev Equipment token ID search in owner array
134     mapping (uint256 => uint256) fashionIdToOwnerIndex;
135 
136     /// @dev The authorized address for each WAR
137     mapping (uint256 => address) fashionIdToApprovals;
138 
139     /// @dev The authorized operators for each address
140     mapping (address => mapping (address => bool)) operatorToApprovals;
141 
142     /// @dev Trust contract
143     mapping (address => bool) actionContracts;
144 
145     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
146         actionContracts[_actionAddr] = _useful;
147     }
148 
149     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
150         return actionContracts[_actionAddr];
151     }
152 
153     /// @dev This emits when the approved address for an WAR is changed or reaffirmed.
154     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
155 
156     /// @dev This emits when an operator is enabled or disabled for an owner.
157     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
158 
159     /// @dev This emits when the equipment ownership changed 
160     event Transfer(address indexed from, address indexed to, uint256 tokenId);
161 
162     /// @dev This emits when the equipment created
163     event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);
164 
165     /// @dev This emits when the equipment's attributes changed
166     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
167 
168     /// @dev This emits when the equipment destroyed
169     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
170     
171     function WarToken() public {
172         addrAdmin = msg.sender;
173         fashionArray.length += 1;
174     }
175 
176     // modifier
177     /// @dev Check if token ID is valid
178     modifier isValidToken(uint256 _tokenId) {
179         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
180         require(fashionIdToOwner[_tokenId] != address(0)); 
181         _;
182     }
183 
184     modifier canTransfer(uint256 _tokenId) {
185         address owner = fashionIdToOwner[_tokenId];
186         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
187         _;
188     }
189 
190     // ERC721
191     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
192         // ERC165 || ERC721 || ERC165^ERC721
193         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
194     }
195         
196     function name() public pure returns(string) {
197         return "WAR Token";
198     }
199 
200     function symbol() public pure returns(string) {
201         return "WAR";
202     }
203 
204     /// @dev Search for token quantity address
205     /// @param _owner Address that needs to be searched
206     /// @return Returns token quantity
207     function balanceOf(address _owner) external view returns(uint256) {
208         require(_owner != address(0));
209         return ownerToFashionArray[_owner].length;
210     }
211 
212     /// @dev Find the owner of an WAR
213     /// @param _tokenId The tokenId of WAR
214     /// @return Give The address of the owner of this WAR
215     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
216         return fashionIdToOwner[_tokenId];
217     }
218 
219     /// @dev Transfers the ownership of an WAR from one address to another address
220     /// @param _from The current owner of the WAR
221     /// @param _to The new owner
222     /// @param _tokenId The WAR to transfer
223     /// @param data Additional data with no specified format, sent in call to `_to`
224     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
225         external
226         whenNotPaused
227     {
228         _safeTransferFrom(_from, _to, _tokenId, data);
229     }
230 
231     /// @dev Transfers the ownership of an WAR from one address to another address
232     /// @param _from The current owner of the WAR
233     /// @param _to The new owner
234     /// @param _tokenId The WAR to transfer
235     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
236         external
237         whenNotPaused
238     {
239         _safeTransferFrom(_from, _to, _tokenId, "");
240     }
241 
242     /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost
243     /// @param _from The current owner of the WAR
244     /// @param _to The new owner
245     /// @param _tokenId The WAR to transfer
246     function transferFrom(address _from, address _to, uint256 _tokenId)
247         external
248         whenNotPaused
249         isValidToken(_tokenId)
250         canTransfer(_tokenId)
251     {
252         address owner = fashionIdToOwner[_tokenId];
253         require(owner != address(0));
254         require(_to != address(0));
255         require(owner == _from);
256         
257         _transfer(_from, _to, _tokenId);
258     }
259 
260     /// @dev Set or reaffirm the approved address for an WAR
261     /// @param _approved The new approved WAR controller
262     /// @param _tokenId The WAR to approve
263     function approve(address _approved, uint256 _tokenId)
264         external
265         whenNotPaused
266     {
267         address owner = fashionIdToOwner[_tokenId];
268         require(owner != address(0));
269         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
270 
271         fashionIdToApprovals[_tokenId] = _approved;
272         Approval(owner, _approved, _tokenId);
273     }
274 
275     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
276     /// @param _operator Address to add to the set of authorized operators.
277     /// @param _approved True if the operators is approved, false to revoke approval
278     function setApprovalForAll(address _operator, bool _approved) 
279         external 
280         whenNotPaused
281     {
282         operatorToApprovals[msg.sender][_operator] = _approved;
283         ApprovalForAll(msg.sender, _operator, _approved);
284     }
285 
286     /// @dev Get the approved address for a single WAR
287     /// @param _tokenId The WAR to find the approved address for
288     /// @return The approved address for this WAR, or the zero address if there is none
289     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
290         return fashionIdToApprovals[_tokenId];
291     }
292 
293     /// @dev Query if an address is an authorized operator for another address
294     /// @param _owner The address that owns the WARs
295     /// @param _operator The address that acts on behalf of the owner
296     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
297     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
298         return operatorToApprovals[_owner][_operator];
299     }
300 
301     /// @dev Count WARs tracked by this contract
302     /// @return A count of valid WARs tracked by this contract, where each one of
303     ///  them has an assigned and queryable owner not equal to the zero address
304     function totalSupply() external view returns (uint256) {
305         return fashionArray.length - destroyFashionCount - 1;
306     }
307 
308     /// @dev Do the real transfer with out any condition checking
309     /// @param _from The old owner of this WAR(If created: 0x0)
310     /// @param _to The new owner of this WAR 
311     /// @param _tokenId The tokenId of the WAR
312     function _transfer(address _from, address _to, uint256 _tokenId) internal {
313         if (_from != address(0)) {
314             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
315             uint256[] storage fsArray = ownerToFashionArray[_from];
316             require(fsArray[indexFrom] == _tokenId);
317 
318             // If the WAR is not the element of array, change it to with the last
319             if (indexFrom != fsArray.length - 1) {
320                 uint256 lastTokenId = fsArray[fsArray.length - 1];
321                 fsArray[indexFrom] = lastTokenId; 
322                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
323             }
324             fsArray.length -= 1; 
325             
326             if (fashionIdToApprovals[_tokenId] != address(0)) {
327                 delete fashionIdToApprovals[_tokenId];
328             }      
329         }
330 
331         // Give the WAR to '_to'
332         fashionIdToOwner[_tokenId] = _to;
333         ownerToFashionArray[_to].push(_tokenId);
334         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
335         
336         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
337     }
338 
339     /// @dev Actually perform the safeTransferFrom
340     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
341         internal
342         isValidToken(_tokenId) 
343         canTransfer(_tokenId)
344     {
345         address owner = fashionIdToOwner[_tokenId];
346         require(owner != address(0));
347         require(_to != address(0));
348         require(owner == _from);
349         
350         _transfer(_from, _to, _tokenId);
351 
352         // Do the callback after everything is done to avoid reentrancy attack
353         uint256 codeSize;
354         assembly { codeSize := extcodesize(_to) }
355         if (codeSize == 0) {
356             return;
357         }
358         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
359         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
360         require(retval == 0xf0b9e5ba);
361     }
362 
363     //----------------------------------------------------------------------------------------------------------
364 
365     /// @dev Equipment creation
366     /// @param _owner Owner of the equipment created
367     /// @param _attrs Attributes of the equipment created
368     /// @return Token ID of the equipment created
369     function createFashion(address _owner, uint16[9] _attrs, uint16 _createType) 
370         external 
371         whenNotPaused
372         returns(uint256)
373     {
374         require(actionContracts[msg.sender]);
375         require(_owner != address(0));
376 
377         uint256 newFashionId = fashionArray.length;
378         require(newFashionId < 4294967296);
379 
380         fashionArray.length += 1;
381         Fashion storage fs = fashionArray[newFashionId];
382         fs.protoId = _attrs[0];
383         fs.quality = _attrs[1];
384         fs.pos = _attrs[2];
385         if (_attrs[3] != 0) {
386             fs.health = _attrs[3];
387         }
388         
389         if (_attrs[4] != 0) {
390             fs.atkMin = _attrs[4];
391             fs.atkMax = _attrs[5];
392         }
393        
394         if (_attrs[6] != 0) {
395             fs.defence = _attrs[6];
396         }
397         
398         if (_attrs[7] != 0) {
399             fs.crit = _attrs[7];
400         }
401 
402         if (_attrs[8] != 0) {
403             fs.isPercent = _attrs[8];
404         }
405         
406         _transfer(0, _owner, newFashionId);
407         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _createType);
408         return newFashionId;
409     }
410 
411     /// @dev One specific attribute of the equipment modified
412     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
413         if (_index == 3) {
414             _fs.health = _val;
415         } else if(_index == 4) {
416             _fs.atkMin = _val;
417         } else if(_index == 5) {
418             _fs.atkMax = _val;
419         } else if(_index == 6) {
420             _fs.defence = _val;
421         } else if(_index == 7) {
422             _fs.crit = _val;
423         } else if(_index == 9) {
424             _fs.attrExt1 = _val;
425         } else if(_index == 10) {
426             _fs.attrExt2 = _val;
427         } else if(_index == 11) {
428             _fs.attrExt3 = _val;
429         }
430     }
431 
432     /// @dev Equiment attributes modified (max 4 stats modified)
433     /// @param _tokenId Equipment Token ID
434     /// @param _idxArray Stats order that must be modified
435     /// @param _params Stat value that must be modified
436     /// @param _changeType Modification type such as enhance, socket, etc.
437     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
438         external 
439         whenNotPaused
440         isValidToken(_tokenId) 
441     {
442         require(actionContracts[msg.sender]);
443 
444         Fashion storage fs = fashionArray[_tokenId];
445         if (_idxArray[0] > 0) {
446             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
447         }
448 
449         if (_idxArray[1] > 0) {
450             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
451         }
452 
453         if (_idxArray[2] > 0) {
454             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
455         }
456 
457         if (_idxArray[3] > 0) {
458             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
459         }
460 
461         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
462     }
463 
464     /// @dev Equipment destruction
465     /// @param _tokenId Equipment Token ID
466     /// @param _deleteType Destruction type, such as craft
467     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
468         external 
469         whenNotPaused
470         isValidToken(_tokenId) 
471     {
472         require(actionContracts[msg.sender]);
473 
474         address _from = fashionIdToOwner[_tokenId];
475         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
476         uint256[] storage fsArray = ownerToFashionArray[_from]; 
477         require(fsArray[indexFrom] == _tokenId);
478 
479         if (indexFrom != fsArray.length - 1) {
480             uint256 lastTokenId = fsArray[fsArray.length - 1];
481             fsArray[indexFrom] = lastTokenId; 
482             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
483         }
484         fsArray.length -= 1; 
485 
486         fashionIdToOwner[_tokenId] = address(0);
487         delete fashionIdToOwnerIndex[_tokenId];
488         destroyFashionCount += 1;
489 
490         Transfer(_from, 0, _tokenId);
491 
492         DeleteFashion(_from, _tokenId, _deleteType);
493     }
494 
495     /// @dev Safe transfer by trust contracts
496     function safeTransferByContract(uint256 _tokenId, address _to) 
497         external
498         whenNotPaused
499     {
500         require(actionContracts[msg.sender]);
501 
502         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
503         address owner = fashionIdToOwner[_tokenId];
504         require(owner != address(0));
505         require(_to != address(0));
506         require(owner != _to);
507 
508         _transfer(owner, _to, _tokenId);
509     }
510 
511     //----------------------------------------------------------------------------------------------------------
512 
513     /// @dev Get fashion attrs by tokenId
514     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {
515         Fashion storage fs = fashionArray[_tokenId];
516         datas[0] = fs.protoId;
517         datas[1] = fs.quality;
518         datas[2] = fs.pos;
519         datas[3] = fs.health;
520         datas[4] = fs.atkMin;
521         datas[5] = fs.atkMax;
522         datas[6] = fs.defence;
523         datas[7] = fs.crit;
524         datas[8] = fs.isPercent;
525         datas[9] = fs.attrExt1;
526         datas[10] = fs.attrExt2;
527         datas[11] = fs.attrExt3;
528     }
529 
530     /// @dev Get tokenIds and flags by owner
531     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
532         require(_owner != address(0));
533         uint256[] storage fsArray = ownerToFashionArray[_owner];
534         uint256 length = fsArray.length;
535         tokens = new uint256[](length);
536         flags = new uint32[](length);
537         for (uint256 i = 0; i < length; ++i) {
538             tokens[i] = fsArray[i];
539             Fashion storage fs = fashionArray[fsArray[i]];
540             flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);
541         }
542     }
543 
544     /// @dev WAR token info returned based on Token ID transfered (64 at most)
545     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
546         uint256 length = _tokens.length;
547         require(length <= 64);
548         attrs = new uint16[](length * 11);
549         uint256 tokenId;
550         uint256 index;
551         for (uint256 i = 0; i < length; ++i) {
552             tokenId = _tokens[i];
553             if (fashionIdToOwner[tokenId] != address(0)) {
554                 index = i * 11;
555                 Fashion storage fs = fashionArray[tokenId];
556                 attrs[index] = fs.health;
557                 attrs[index + 1] = fs.atkMin;
558                 attrs[index + 2] = fs.atkMax;
559                 attrs[index + 3] = fs.defence;
560                 attrs[index + 4] = fs.crit;
561                 attrs[index + 5] = fs.isPercent;
562                 attrs[index + 6] = fs.attrExt1;
563                 attrs[index + 7] = fs.attrExt2;
564                 attrs[index + 8] = fs.attrExt3;
565             }   
566         }
567     }
568 }
569 
570 contract ActionPresell is AccessService {
571     WarToken tokenContract;
572     mapping (uint16 => uint16) petPresellCounter;
573     mapping (address => uint16[]) presellLimit;
574 
575     event PetPreSelled(address indexed buyer, uint16 protoId);
576 
577     function ActionPresell(address _nftAddr) public {
578         addrAdmin = msg.sender;
579         addrService = msg.sender;
580         addrFinance = msg.sender;
581 
582         tokenContract = WarToken(_nftAddr);
583 
584         petPresellCounter[10001] = 50;
585         petPresellCounter[10002] = 30;
586         petPresellCounter[10003] = 50;
587         petPresellCounter[10004] = 30;
588         petPresellCounter[10005] = 30;
589     }
590 
591     function() external payable {
592 
593     }
594 
595     function setWarTokenAddr(address _nftAddr) external onlyAdmin {
596         tokenContract = WarToken(_nftAddr);
597     }
598 
599     function petPresell(uint16 _protoId) 
600         external
601         payable
602         whenNotPaused 
603     {
604         uint16 curSupply = petPresellCounter[_protoId];
605         require(curSupply > 0);
606         uint16[] storage buyArray = presellLimit[msg.sender];
607         uint256 curBuyCnt = buyArray.length;
608         require(curBuyCnt < 10);
609 
610         uint256 payBack = 0;
611         if (_protoId == 10001) {
612             require(msg.value >= 0.66 ether);
613             payBack = (msg.value - 0.66 ether);
614             uint16[9] memory param1 = [10001, 5, 9, 40, 0, 0, 0, 0, 1];       // hp +40%
615             tokenContract.createFashion(msg.sender, param1, 1);
616             buyArray.push(10001);
617         } else if(_protoId == 10002) {
618             require(msg.value >= 0.99 ether);
619             payBack = (msg.value - 0.99 ether);
620             uint16[9] memory param2 = [10002, 5, 9, 0, 30, 30, 0, 0, 1];       // atk +30%
621             tokenContract.createFashion(msg.sender, param2, 1);
622             buyArray.push(10002);
623         } else if(_protoId == 10003) {
624             require(msg.value >= 0.66 ether);
625             payBack = (msg.value - 0.66 ether);
626             uint16[9] memory param3 = [10003, 5, 9, 0, 0, 0, 40, 0, 1];        // def +40%
627             tokenContract.createFashion(msg.sender, param3, 1);
628             buyArray.push(10003);
629         } else if(_protoId == 10004) {
630             require(msg.value >= 0.99 ether);
631             payBack = (msg.value - 0.99 ether);
632             uint16[9] memory param4 = [10004, 5, 9, 0, 0, 0, 0, 30, 1];        // crit +50%
633             tokenContract.createFashion(msg.sender, param4, 1);
634             buyArray.push(10004);
635         } else {
636             require(msg.value >= 0.99 ether);
637             payBack = (msg.value - 0.99 ether);
638             uint16[9] memory param5 = [10005, 5, 9, 20, 10, 10, 20, 0, 1];      // hp +20%, atk +10%, def +20%
639             tokenContract.createFashion(msg.sender, param5, 1);
640             buyArray.push(10005);
641         }
642 
643         petPresellCounter[_protoId] = (curSupply - 1);
644 
645         PetPreSelled(msg.sender, _protoId);
646 
647         addrFinance.transfer(msg.value - payBack);        // need 2300 gas -_-!
648         if (payBack > 0) {
649             msg.sender.transfer(payBack);
650         }
651     }
652 
653     function withdraw() 
654         external 
655     {
656         require(msg.sender == addrFinance || msg.sender == addrAdmin);
657         addrFinance.transfer(this.balance);
658     }
659 
660     function getPetCanPresellCount() external view returns (uint16[5] cntArray) {
661         cntArray[0] = petPresellCounter[10001];
662         cntArray[1] = petPresellCounter[10002];
663         cntArray[2] = petPresellCounter[10003];
664         cntArray[3] = petPresellCounter[10004];
665         cntArray[4] = petPresellCounter[10005];   
666     }
667 
668     function getBuyCount(address _owner) external view returns (uint32) {
669         return uint32(presellLimit[_owner].length);
670     }
671 
672     function getBuyArray(address _owner) external view returns (uint16[]) {
673         uint16[] storage buyArray = presellLimit[_owner];
674         return buyArray;
675     }
676 }