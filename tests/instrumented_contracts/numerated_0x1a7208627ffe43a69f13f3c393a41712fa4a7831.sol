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
50 
51     modifier onlyAdmin() {
52         require(msg.sender == addrAdmin);
53         _;
54     }
55 
56     modifier whenNotPaused() {
57         require(!isPaused);
58         _;
59     }
60 
61     modifier whenPaused {
62         require(isPaused);
63         _;
64     }
65 
66     function setAdmin(address _newAdmin) external onlyAdmin {
67         require(_newAdmin != address(0));
68         AdminTransferred(addrAdmin, _newAdmin);
69         addrAdmin = _newAdmin;
70     }
71 
72     function doPause() external onlyAdmin whenNotPaused {
73         isPaused = true;
74     }
75 
76     function doUnpause() external onlyAdmin whenPaused {
77         isPaused = false;
78     }
79 }
80 
81 contract AccessService is AccessAdmin {
82     address public addrService;
83     address public addrFinance;
84 
85     modifier onlyService() {
86         require(msg.sender == addrService);
87         _;
88     }
89 
90     modifier onlyFinance() {
91         require(msg.sender == addrFinance);
92         _;
93     }
94 
95     function setService(address _newService) external {
96         require(msg.sender == addrService || msg.sender == addrAdmin);
97         require(_newService != address(0));
98         addrService = _newService;
99     }
100 
101     function setFinance(address _newFinance) external {
102         require(msg.sender == addrFinance || msg.sender == addrAdmin);
103         require(_newFinance != address(0));
104         addrFinance = _newFinance;
105     }
106 
107     function withdraw(address _target, uint256 _amount) 
108         external 
109     {
110         require(msg.sender == addrFinance || msg.sender == addrAdmin);
111         require(_amount > 0);
112         address receiver = _target == address(0) ? addrFinance : _target;
113         uint256 balance = this.balance;
114         if (_amount < balance) {
115             receiver.transfer(_amount);
116         } else {
117             receiver.transfer(this.balance);
118         }      
119     }
120 }
121 
122 interface IDataMining {
123     function getRecommender(address _target) external view returns(address);
124     function subFreeMineral(address _target) external returns(bool);
125 }
126 
127 interface IDataEquip {
128     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
129     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
130     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
131 }
132 
133 contract Random {
134     uint256 _seed;
135 
136     function _rand() internal returns (uint256) {
137         _seed = uint256(keccak256(_seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
138         return _seed;
139     }
140 
141     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
142         return uint256(keccak256(_outSeed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
143     }
144 }
145 
146 /**
147  * @title SafeMath
148  * @dev Math operations with safety checks that throw on error
149  */
150 library SafeMath {
151     /**
152     * @dev Multiplies two numbers, throws on overflow.
153     */
154     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
155         if (a == 0) {
156             return 0;
157         }
158         uint256 c = a * b;
159         assert(c / a == b);
160         return c;
161     }
162 
163     /**
164     * @dev Integer division of two numbers, truncating the quotient.
165     */
166     function div(uint256 a, uint256 b) internal pure returns (uint256) {
167         // assert(b > 0); // Solidity automatically throws when dividing by 0
168         uint256 c = a / b;
169         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170         return c;
171     }
172 
173     /**
174     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
175     */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         assert(b <= a);
178         return a - b;
179     }
180 
181     /**
182     * @dev Adds two numbers, throws on overflow.
183     */
184     function add(uint256 a, uint256 b) internal pure returns (uint256) {
185         uint256 c = a + b;
186         assert(c >= a);
187         return c;
188     }
189 }
190 
191 contract WarToken is ERC721, AccessAdmin {
192     /// @dev The equipment info
193     struct Fashion {
194         uint16 protoId;     // 0  Equipment ID
195         uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
196         uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets
197         uint16 health;      // 3  Health
198         uint16 atkMin;      // 4  Min attack
199         uint16 atkMax;      // 5  Max attack
200         uint16 defence;     // 6  Defennse
201         uint16 crit;        // 7  Critical rate
202         uint16 isPercent;   // 8  Attr value type
203         uint16 attrExt1;    // 9  future stat 1
204         uint16 attrExt2;    // 10 future stat 2
205         uint16 attrExt3;    // 11 future stat 3
206     }
207 
208     /// @dev All equipments tokenArray (not exceeding 2^32-1)
209     Fashion[] public fashionArray;
210 
211     /// @dev Amount of tokens destroyed
212     uint256 destroyFashionCount;
213 
214     /// @dev Equipment token ID vs owner address
215     mapping (uint256 => address) fashionIdToOwner;
216 
217     /// @dev Equipments owner by the owner (array)
218     mapping (address => uint256[]) ownerToFashionArray;
219 
220     /// @dev Equipment token ID search in owner array
221     mapping (uint256 => uint256) fashionIdToOwnerIndex;
222 
223     /// @dev The authorized address for each WAR
224     mapping (uint256 => address) fashionIdToApprovals;
225 
226     /// @dev The authorized operators for each address
227     mapping (address => mapping (address => bool)) operatorToApprovals;
228 
229     /// @dev Trust contract
230     mapping (address => bool) actionContracts;
231 
232     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
233         actionContracts[_actionAddr] = _useful;
234     }
235 
236     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
237         return actionContracts[_actionAddr];
238     }
239 
240     /// @dev This emits when the approved address for an WAR is changed or reaffirmed.
241     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
242 
243     /// @dev This emits when an operator is enabled or disabled for an owner.
244     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
245 
246     /// @dev This emits when the equipment ownership changed 
247     event Transfer(address indexed from, address indexed to, uint256 tokenId);
248 
249     /// @dev This emits when the equipment created
250     event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);
251 
252     /// @dev This emits when the equipment's attributes changed
253     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
254 
255     /// @dev This emits when the equipment destroyed
256     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
257     
258     function WarToken() public {
259         addrAdmin = msg.sender;
260         fashionArray.length += 1;
261     }
262 
263     // modifier
264     /// @dev Check if token ID is valid
265     modifier isValidToken(uint256 _tokenId) {
266         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
267         require(fashionIdToOwner[_tokenId] != address(0)); 
268         _;
269     }
270 
271     modifier canTransfer(uint256 _tokenId) {
272         address owner = fashionIdToOwner[_tokenId];
273         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
274         _;
275     }
276 
277     // ERC721
278     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
279         // ERC165 || ERC721 || ERC165^ERC721
280         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
281     }
282         
283     function name() public pure returns(string) {
284         return "WAR Token";
285     }
286 
287     function symbol() public pure returns(string) {
288         return "WAR";
289     }
290 
291     /// @dev Search for token quantity address
292     /// @param _owner Address that needs to be searched
293     /// @return Returns token quantity
294     function balanceOf(address _owner) external view returns(uint256) {
295         require(_owner != address(0));
296         return ownerToFashionArray[_owner].length;
297     }
298 
299     /// @dev Find the owner of an WAR
300     /// @param _tokenId The tokenId of WAR
301     /// @return Give The address of the owner of this WAR
302     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
303         return fashionIdToOwner[_tokenId];
304     }
305 
306     /// @dev Transfers the ownership of an WAR from one address to another address
307     /// @param _from The current owner of the WAR
308     /// @param _to The new owner
309     /// @param _tokenId The WAR to transfer
310     /// @param data Additional data with no specified format, sent in call to `_to`
311     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
312         external
313         whenNotPaused
314     {
315         _safeTransferFrom(_from, _to, _tokenId, data);
316     }
317 
318     /// @dev Transfers the ownership of an WAR from one address to another address
319     /// @param _from The current owner of the WAR
320     /// @param _to The new owner
321     /// @param _tokenId The WAR to transfer
322     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
323         external
324         whenNotPaused
325     {
326         _safeTransferFrom(_from, _to, _tokenId, "");
327     }
328 
329     /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost
330     /// @param _from The current owner of the WAR
331     /// @param _to The new owner
332     /// @param _tokenId The WAR to transfer
333     function transferFrom(address _from, address _to, uint256 _tokenId)
334         external
335         whenNotPaused
336         isValidToken(_tokenId)
337         canTransfer(_tokenId)
338     {
339         address owner = fashionIdToOwner[_tokenId];
340         require(owner != address(0));
341         require(_to != address(0));
342         require(owner == _from);
343         
344         _transfer(_from, _to, _tokenId);
345     }
346 
347     /// @dev Set or reaffirm the approved address for an WAR
348     /// @param _approved The new approved WAR controller
349     /// @param _tokenId The WAR to approve
350     function approve(address _approved, uint256 _tokenId)
351         external
352         whenNotPaused
353     {
354         address owner = fashionIdToOwner[_tokenId];
355         require(owner != address(0));
356         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
357 
358         fashionIdToApprovals[_tokenId] = _approved;
359         Approval(owner, _approved, _tokenId);
360     }
361 
362     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
363     /// @param _operator Address to add to the set of authorized operators.
364     /// @param _approved True if the operators is approved, false to revoke approval
365     function setApprovalForAll(address _operator, bool _approved) 
366         external 
367         whenNotPaused
368     {
369         operatorToApprovals[msg.sender][_operator] = _approved;
370         ApprovalForAll(msg.sender, _operator, _approved);
371     }
372 
373     /// @dev Get the approved address for a single WAR
374     /// @param _tokenId The WAR to find the approved address for
375     /// @return The approved address for this WAR, or the zero address if there is none
376     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
377         return fashionIdToApprovals[_tokenId];
378     }
379 
380     /// @dev Query if an address is an authorized operator for another address
381     /// @param _owner The address that owns the WARs
382     /// @param _operator The address that acts on behalf of the owner
383     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
384     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
385         return operatorToApprovals[_owner][_operator];
386     }
387 
388     /// @dev Count WARs tracked by this contract
389     /// @return A count of valid WARs tracked by this contract, where each one of
390     ///  them has an assigned and queryable owner not equal to the zero address
391     function totalSupply() external view returns (uint256) {
392         return fashionArray.length - destroyFashionCount - 1;
393     }
394 
395     /// @dev Do the real transfer with out any condition checking
396     /// @param _from The old owner of this WAR(If created: 0x0)
397     /// @param _to The new owner of this WAR 
398     /// @param _tokenId The tokenId of the WAR
399     function _transfer(address _from, address _to, uint256 _tokenId) internal {
400         if (_from != address(0)) {
401             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
402             uint256[] storage fsArray = ownerToFashionArray[_from];
403             require(fsArray[indexFrom] == _tokenId);
404 
405             // If the WAR is not the element of array, change it to with the last
406             if (indexFrom != fsArray.length - 1) {
407                 uint256 lastTokenId = fsArray[fsArray.length - 1];
408                 fsArray[indexFrom] = lastTokenId; 
409                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
410             }
411             fsArray.length -= 1; 
412             
413             if (fashionIdToApprovals[_tokenId] != address(0)) {
414                 delete fashionIdToApprovals[_tokenId];
415             }      
416         }
417 
418         // Give the WAR to '_to'
419         fashionIdToOwner[_tokenId] = _to;
420         ownerToFashionArray[_to].push(_tokenId);
421         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
422         
423         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
424     }
425 
426     /// @dev Actually perform the safeTransferFrom
427     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
428         internal
429         isValidToken(_tokenId) 
430         canTransfer(_tokenId)
431     {
432         address owner = fashionIdToOwner[_tokenId];
433         require(owner != address(0));
434         require(_to != address(0));
435         require(owner == _from);
436         
437         _transfer(_from, _to, _tokenId);
438 
439         // Do the callback after everything is done to avoid reentrancy attack
440         uint256 codeSize;
441         assembly { codeSize := extcodesize(_to) }
442         if (codeSize == 0) {
443             return;
444         }
445         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
446         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
447         require(retval == 0xf0b9e5ba);
448     }
449 
450     //----------------------------------------------------------------------------------------------------------
451 
452     /// @dev Equipment creation
453     /// @param _owner Owner of the equipment created
454     /// @param _attrs Attributes of the equipment created
455     /// @return Token ID of the equipment created
456     function createFashion(address _owner, uint16[9] _attrs, uint16 _createType) 
457         external 
458         whenNotPaused
459         returns(uint256)
460     {
461         require(actionContracts[msg.sender]);
462         require(_owner != address(0));
463 
464         uint256 newFashionId = fashionArray.length;
465         require(newFashionId < 4294967296);
466 
467         fashionArray.length += 1;
468         Fashion storage fs = fashionArray[newFashionId];
469         fs.protoId = _attrs[0];
470         fs.quality = _attrs[1];
471         fs.pos = _attrs[2];
472         if (_attrs[3] != 0) {
473             fs.health = _attrs[3];
474         }
475         
476         if (_attrs[4] != 0) {
477             fs.atkMin = _attrs[4];
478             fs.atkMax = _attrs[5];
479         }
480        
481         if (_attrs[6] != 0) {
482             fs.defence = _attrs[6];
483         }
484         
485         if (_attrs[7] != 0) {
486             fs.crit = _attrs[7];
487         }
488 
489         if (_attrs[8] != 0) {
490             fs.isPercent = _attrs[8];
491         }
492         
493         _transfer(0, _owner, newFashionId);
494         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _createType);
495         return newFashionId;
496     }
497 
498     /// @dev One specific attribute of the equipment modified
499     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
500         if (_index == 3) {
501             _fs.health = _val;
502         } else if(_index == 4) {
503             _fs.atkMin = _val;
504         } else if(_index == 5) {
505             _fs.atkMax = _val;
506         } else if(_index == 6) {
507             _fs.defence = _val;
508         } else if(_index == 7) {
509             _fs.crit = _val;
510         } else if(_index == 9) {
511             _fs.attrExt1 = _val;
512         } else if(_index == 10) {
513             _fs.attrExt2 = _val;
514         } else if(_index == 11) {
515             _fs.attrExt3 = _val;
516         }
517     }
518 
519     /// @dev Equiment attributes modified (max 4 stats modified)
520     /// @param _tokenId Equipment Token ID
521     /// @param _idxArray Stats order that must be modified
522     /// @param _params Stat value that must be modified
523     /// @param _changeType Modification type such as enhance, socket, etc.
524     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
525         external 
526         whenNotPaused
527         isValidToken(_tokenId) 
528     {
529         require(actionContracts[msg.sender]);
530 
531         Fashion storage fs = fashionArray[_tokenId];
532         if (_idxArray[0] > 0) {
533             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
534         }
535 
536         if (_idxArray[1] > 0) {
537             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
538         }
539 
540         if (_idxArray[2] > 0) {
541             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
542         }
543 
544         if (_idxArray[3] > 0) {
545             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
546         }
547 
548         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
549     }
550 
551     /// @dev Equipment destruction
552     /// @param _tokenId Equipment Token ID
553     /// @param _deleteType Destruction type, such as craft
554     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
555         external 
556         whenNotPaused
557         isValidToken(_tokenId) 
558     {
559         require(actionContracts[msg.sender]);
560 
561         address _from = fashionIdToOwner[_tokenId];
562         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
563         uint256[] storage fsArray = ownerToFashionArray[_from]; 
564         require(fsArray[indexFrom] == _tokenId);
565 
566         if (indexFrom != fsArray.length - 1) {
567             uint256 lastTokenId = fsArray[fsArray.length - 1];
568             fsArray[indexFrom] = lastTokenId; 
569             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
570         }
571         fsArray.length -= 1; 
572 
573         fashionIdToOwner[_tokenId] = address(0);
574         delete fashionIdToOwnerIndex[_tokenId];
575         destroyFashionCount += 1;
576 
577         Transfer(_from, 0, _tokenId);
578 
579         DeleteFashion(_from, _tokenId, _deleteType);
580     }
581 
582     /// @dev Safe transfer by trust contracts
583     function safeTransferByContract(uint256 _tokenId, address _to) 
584         external
585         whenNotPaused
586     {
587         require(actionContracts[msg.sender]);
588 
589         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
590         address owner = fashionIdToOwner[_tokenId];
591         require(owner != address(0));
592         require(_to != address(0));
593         require(owner != _to);
594 
595         _transfer(owner, _to, _tokenId);
596     }
597 
598     //----------------------------------------------------------------------------------------------------------
599 
600     /// @dev Get fashion attrs by tokenId
601     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {
602         Fashion storage fs = fashionArray[_tokenId];
603         datas[0] = fs.protoId;
604         datas[1] = fs.quality;
605         datas[2] = fs.pos;
606         datas[3] = fs.health;
607         datas[4] = fs.atkMin;
608         datas[5] = fs.atkMax;
609         datas[6] = fs.defence;
610         datas[7] = fs.crit;
611         datas[8] = fs.isPercent;
612         datas[9] = fs.attrExt1;
613         datas[10] = fs.attrExt2;
614         datas[11] = fs.attrExt3;
615     }
616 
617     /// @dev Get tokenIds and flags by owner
618     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
619         require(_owner != address(0));
620         uint256[] storage fsArray = ownerToFashionArray[_owner];
621         uint256 length = fsArray.length;
622         tokens = new uint256[](length);
623         flags = new uint32[](length);
624         for (uint256 i = 0; i < length; ++i) {
625             tokens[i] = fsArray[i];
626             Fashion storage fs = fashionArray[fsArray[i]];
627             flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);
628         }
629     }
630 
631     /// @dev WAR token info returned based on Token ID transfered (64 at most)
632     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
633         uint256 length = _tokens.length;
634         require(length <= 64);
635         attrs = new uint16[](length * 11);
636         uint256 tokenId;
637         uint256 index;
638         for (uint256 i = 0; i < length; ++i) {
639             tokenId = _tokens[i];
640             if (fashionIdToOwner[tokenId] != address(0)) {
641                 index = i * 11;
642                 Fashion storage fs = fashionArray[tokenId];
643                 attrs[index] = fs.health;
644                 attrs[index + 1] = fs.atkMin;
645                 attrs[index + 2] = fs.atkMax;
646                 attrs[index + 3] = fs.defence;
647                 attrs[index + 4] = fs.crit;
648                 attrs[index + 5] = fs.isPercent;
649                 attrs[index + 6] = fs.attrExt1;
650                 attrs[index + 7] = fs.attrExt2;
651                 attrs[index + 8] = fs.attrExt3;
652             }   
653         }
654     }
655 }
656 
657 contract ActionMining is Random, AccessService {
658     using SafeMath for uint256;
659 
660     event MiningOrderCreated(uint256 indexed index, address indexed miner, uint64 chestCnt);
661     event MiningResolved(uint256 indexed index, address indexed miner, uint64 chestCnt);
662 
663     struct MiningOrder {
664         address miner;      
665         uint64 chestCnt;    
666         uint64 tmCreate;    
667         uint64 tmResolve;   
668     }
669 
670     /// @dev Max fashion suit id
671     uint16 maxProtoId;
672     /// @dev If the recommender can get reward 
673     bool isRecommendOpen;
674     /// @dev prizepool percent
675     uint256 constant prizePoolPercent = 50;
676     /// @dev prizepool contact address
677     address poolContract;
678     /// @dev WarToken(NFT) contract address
679     WarToken public tokenContract;
680     /// @dev DataMining contract address
681     IDataMining public dataContract;
682     /// @dev mining order array
683     MiningOrder[] public ordersArray;
684 
685     mapping (uint16 => uint256) public protoIdToCount;
686 
687 
688     function ActionMining(address _nftAddr, uint16 _maxProtoId) public {
689         addrAdmin = msg.sender;
690         addrService = msg.sender;
691         addrFinance = msg.sender;
692 
693         tokenContract = WarToken(_nftAddr);
694         maxProtoId = _maxProtoId;
695         
696         MiningOrder memory order = MiningOrder(0, 0, 1, 1);
697         ordersArray.push(order);
698     }
699 
700     function() external payable {
701 
702     }
703 
704     function getOrderCount() external view returns(uint256) {
705         return ordersArray.length - 1;
706     }
707 
708     function setDataMining(address _addr) external onlyAdmin {
709         require(_addr != address(0));
710         dataContract = IDataMining(_addr);
711     }
712     
713     function setPrizePool(address _addr) external onlyAdmin {
714         require(_addr != address(0));
715         poolContract = _addr;
716     }
717 
718     function setMaxProtoId(uint16 _maxProtoId) external onlyAdmin {
719         require(_maxProtoId > 0 && _maxProtoId < 10000);
720         require(_maxProtoId != maxProtoId);
721         maxProtoId = _maxProtoId;
722     }
723 
724     function setRecommendStatus(bool _isOpen) external onlyAdmin {
725         require(_isOpen != isRecommendOpen);
726         isRecommendOpen = _isOpen;
727     }
728 
729     function setFashionSuitCount(uint16 _protoId, uint256 _cnt) external onlyAdmin {
730         require(_protoId > 0 && _protoId <= maxProtoId);
731         require(_cnt > 0 && _cnt <= 5);
732         require(protoIdToCount[_protoId] != _cnt);
733         protoIdToCount[_protoId] = _cnt;
734     }
735 
736     function _getFashionParam(uint256 _seed) internal view returns(uint16[9] attrs) {
737         uint256 curSeed = _seed;
738         // quality
739         uint256 rdm = curSeed % 10000;
740         uint16 qtyParam;
741         if (rdm < 6900) {
742             attrs[1] = 1;
743             qtyParam = 0;
744         } else if (rdm < 8700) {
745             attrs[1] = 2;
746             qtyParam = 1;
747         } else if (rdm < 9600) {
748             attrs[1] = 3;
749             qtyParam = 2;
750         } else if (rdm < 9900) {
751             attrs[1] = 4;
752             qtyParam = 4;
753         } else {
754             attrs[1] = 5;
755             qtyParam = 6;
756         }
757 
758         // protoId
759         curSeed /= 10000;
760         rdm = ((curSeed % 10000) / (9999 / maxProtoId)) + 1;
761         attrs[0] = uint16(rdm <= maxProtoId ? rdm : maxProtoId);
762 
763         // pos
764         curSeed /= 10000;
765         uint256 tmpVal = protoIdToCount[attrs[0]];
766         if (tmpVal == 0) {
767             tmpVal = 5;
768         }
769         rdm = ((curSeed % 10000) / (9999 / tmpVal)) + 1;
770         uint16 pos = uint16(rdm <= tmpVal ? rdm : tmpVal);
771         attrs[2] = pos;
772 
773         rdm = attrs[0] % 3;
774 
775         curSeed /= 10000;
776         tmpVal = (curSeed % 10000) % 21 + 90;
777 
778         if (rdm == 0) {
779             if (pos == 1) {
780                 uint256 attr = (200 + qtyParam * 200) * tmpVal / 100;              // +atk
781                 attrs[4] = uint16(attr * 40 / 100);
782                 attrs[5] = uint16(attr * 160 / 100);
783             } else if (pos == 2) {
784                 attrs[6] = uint16((40 + qtyParam * 40) * tmpVal / 100);            // +def
785             } else if (pos == 3) {
786                 attrs[3] = uint16((600 + qtyParam * 600) * tmpVal / 100);          // +hp
787             } else if (pos == 4) {
788                 attrs[6] = uint16((60 + qtyParam * 60) * tmpVal / 100);            // +def
789             } else {
790                 attrs[3] = uint16((400 + qtyParam * 400) * tmpVal / 100);          // +hp
791             }
792         } else if (rdm == 1) {
793             if (pos == 1) {
794                 uint256 attr2 = (190 + qtyParam * 190) * tmpVal / 100;              // +atk
795                 attrs[4] = uint16(attr2 * 50 / 100);
796                 attrs[5] = uint16(attr2 * 150 / 100);
797             } else if (pos == 2) {
798                 attrs[6] = uint16((42 + qtyParam * 42) * tmpVal / 100);            // +def
799             } else if (pos == 3) {
800                 attrs[3] = uint16((630 + qtyParam * 630) * tmpVal / 100);          // +hp
801             } else if (pos == 4) {
802                 attrs[6] = uint16((63 + qtyParam * 63) * tmpVal / 100);            // +def
803             } else {
804                 attrs[3] = uint16((420 + qtyParam * 420) * tmpVal / 100);          // +hp
805             }
806         } else {
807             if (pos == 1) {
808                 uint256 attr3 = (210 + qtyParam * 210) * tmpVal / 100;             // +atk
809                 attrs[4] = uint16(attr3 * 30 / 100);
810                 attrs[5] = uint16(attr3 * 170 / 100);
811             } else if (pos == 2) {
812                 attrs[6] = uint16((38 + qtyParam * 38) * tmpVal / 100);            // +def
813             } else if (pos == 3) {
814                 attrs[3] = uint16((570 + qtyParam * 570) * tmpVal / 100);          // +hp
815             } else if (pos == 4) {
816                 attrs[6] = uint16((57 + qtyParam * 57) * tmpVal / 100);            // +def
817             } else {
818                 attrs[3] = uint16((380 + qtyParam * 380) * tmpVal / 100);          // +hp
819             }
820         }
821         attrs[8] = 0;
822     }
823 
824     function _addOrder(address _miner, uint64 _chestCnt) internal {
825         uint64 newOrderId = uint64(ordersArray.length);
826         ordersArray.length += 1;
827         MiningOrder storage order = ordersArray[newOrderId];
828         order.miner = _miner;
829         order.chestCnt = _chestCnt;
830         order.tmCreate = uint64(block.timestamp);
831 
832         MiningOrderCreated(newOrderId, _miner, _chestCnt);
833     }
834 
835     function _transferHelper(uint256 ethVal) private {
836         bool recommenderSended = false;
837         uint256 fVal;
838         uint256 pVal;
839         if (isRecommendOpen) {
840             address recommender = dataContract.getRecommender(msg.sender);
841             if (recommender != address(0)) {
842                 uint256 rVal = ethVal.div(10);
843                 fVal = ethVal.sub(rVal).mul(prizePoolPercent).div(100);
844                 addrFinance.transfer(fVal);
845                 recommenderSended = true;
846                 recommender.transfer(rVal);
847                 pVal = ethVal.sub(rVal).sub(fVal);
848                 if (poolContract != address(0) && pVal > 0) {
849                     poolContract.transfer(pVal);
850                 }
851             } 
852         } 
853         if (!recommenderSended) {
854             fVal = ethVal.mul(prizePoolPercent).div(100);
855             pVal = ethVal.sub(fVal);
856             addrFinance.transfer(fVal);
857             if (poolContract != address(0) && pVal > 0) {
858                 poolContract.transfer(pVal);
859             }
860         }
861     }
862 
863     function miningOneFree()
864         external
865         whenNotPaused
866     {
867         require(dataContract != address(0));
868 
869         uint256 seed = _rand();
870         uint16[9] memory attrs = _getFashionParam(seed);
871 
872         require(dataContract.subFreeMineral(msg.sender));
873 
874         tokenContract.createFashion(msg.sender, attrs, 3);
875 
876         MiningResolved(0, msg.sender, 1);
877     }
878 
879     function miningOneSelf() 
880         external 
881         payable 
882         whenNotPaused
883     {
884         require(msg.value >= 0.01 ether);
885 
886         uint256 seed = _rand();
887         uint16[9] memory attrs = _getFashionParam(seed);
888 
889         tokenContract.createFashion(msg.sender, attrs, 2);
890         _transferHelper(0.01 ether);
891 
892         if (msg.value > 0.01 ether) {
893             msg.sender.transfer(msg.value - 0.01 ether);
894         }
895 
896         MiningResolved(0, msg.sender, 1);
897     }
898 
899     function miningOne() 
900         external 
901         payable 
902         whenNotPaused
903     {
904         require(msg.value >= 0.01 ether);
905 
906         _addOrder(msg.sender, 1);
907         _transferHelper(0.01 ether);
908 
909         if (msg.value > 0.01 ether) {
910             msg.sender.transfer(msg.value - 0.01 ether);
911         }
912     }
913 
914     function miningThree() 
915         external 
916         payable 
917         whenNotPaused
918     {
919         require(msg.value >= 0.03 ether);
920 
921         _addOrder(msg.sender, 3);
922         _transferHelper(0.03 ether);
923 
924         if (msg.value > 0.03 ether) {
925             msg.sender.transfer(msg.value - 0.03 ether);
926         }
927     }
928 
929     function miningFive() 
930         external 
931         payable 
932         whenNotPaused
933     {
934         require(msg.value >= 0.0475 ether);
935 
936         _addOrder(msg.sender, 5);
937         _transferHelper(0.0475 ether);
938 
939         if (msg.value > 0.0475 ether) {
940             msg.sender.transfer(msg.value - 0.0475 ether);
941         }
942     }
943 
944     function miningTen() 
945         external 
946         payable 
947         whenNotPaused
948     {
949         require(msg.value >= 0.09 ether);
950         
951         _addOrder(msg.sender, 10);
952         _transferHelper(0.09 ether);
953 
954         if (msg.value > 0.09 ether) {
955             msg.sender.transfer(msg.value - 0.09 ether);
956         }
957     }
958 
959     function miningResolve(uint256 _orderIndex, uint256 _seed) 
960         external 
961         onlyService
962     {
963         require(_orderIndex > 0 && _orderIndex < ordersArray.length);
964         MiningOrder storage order = ordersArray[_orderIndex];
965         require(order.tmResolve == 0);
966         address miner = order.miner;
967         require(miner != address(0));
968         uint64 chestCnt = order.chestCnt;
969         require(chestCnt >= 1 && chestCnt <= 10);
970 
971         uint256 rdm = _seed;
972         uint16[9] memory attrs;
973         for (uint64 i = 0; i < chestCnt; ++i) {
974             rdm = _randBySeed(rdm);
975             attrs = _getFashionParam(rdm);
976             tokenContract.createFashion(miner, attrs, 2);
977         }
978         order.tmResolve = uint64(block.timestamp);
979         MiningResolved(_orderIndex, miner, chestCnt);
980     }
981 }