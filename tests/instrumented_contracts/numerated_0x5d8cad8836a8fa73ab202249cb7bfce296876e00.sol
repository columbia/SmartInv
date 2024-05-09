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
133 interface IDataAuction {
134     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
135     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
136 }
137 
138 interface IBitGuildToken {
139     function transfer(address _to, uint256 _value) external;
140     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
141     function approve(address _spender, uint256 _value) external; 
142     function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool);
143     function balanceOf(address _from) external view returns(uint256);
144 }
145 
146 contract Random {
147     uint256 _seed;
148 
149     function _rand() internal returns (uint256) {
150         _seed = uint256(keccak256(_seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
151         return _seed;
152     }
153 
154     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
155         return uint256(keccak256(_outSeed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
156     }
157 }
158 
159 /**
160  * @title SafeMath
161  * @dev Math operations with safety checks that throw on error
162  */
163 library SafeMath {
164     /**
165     * @dev Multiplies two numbers, throws on overflow.
166     */
167     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
168         if (a == 0) {
169             return 0;
170         }
171         uint256 c = a * b;
172         assert(c / a == b);
173         return c;
174     }
175 
176     /**
177     * @dev Integer division of two numbers, truncating the quotient.
178     */
179     function div(uint256 a, uint256 b) internal pure returns (uint256) {
180         // assert(b > 0); // Solidity automatically throws when dividing by 0
181         uint256 c = a / b;
182         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
183         return c;
184     }
185 
186     /**
187     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
188     */
189     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
190         assert(b <= a);
191         return a - b;
192     }
193 
194     /**
195     * @dev Adds two numbers, throws on overflow.
196     */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         uint256 c = a + b;
199         assert(c >= a);
200         return c;
201     }
202 }
203 
204 contract WarToken is ERC721, AccessAdmin {
205     /// @dev The equipment info
206     struct Fashion {
207         uint16 protoId;     // 0  Equipment ID
208         uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
209         uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets
210         uint16 health;      // 3  Health
211         uint16 atkMin;      // 4  Min attack
212         uint16 atkMax;      // 5  Max attack
213         uint16 defence;     // 6  Defennse
214         uint16 crit;        // 7  Critical rate
215         uint16 isPercent;   // 8  Attr value type
216         uint16 attrExt1;    // 9  future stat 1
217         uint16 attrExt2;    // 10 future stat 2
218         uint16 attrExt3;    // 11 future stat 3
219     }
220 
221     /// @dev All equipments tokenArray (not exceeding 2^32-1)
222     Fashion[] public fashionArray;
223 
224     /// @dev Amount of tokens destroyed
225     uint256 destroyFashionCount;
226 
227     /// @dev Equipment token ID vs owner address
228     mapping (uint256 => address) fashionIdToOwner;
229 
230     /// @dev Equipments owner by the owner (array)
231     mapping (address => uint256[]) ownerToFashionArray;
232 
233     /// @dev Equipment token ID search in owner array
234     mapping (uint256 => uint256) fashionIdToOwnerIndex;
235 
236     /// @dev The authorized address for each WAR
237     mapping (uint256 => address) fashionIdToApprovals;
238 
239     /// @dev The authorized operators for each address
240     mapping (address => mapping (address => bool)) operatorToApprovals;
241 
242     /// @dev Trust contract
243     mapping (address => bool) actionContracts;
244 
245     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
246         actionContracts[_actionAddr] = _useful;
247     }
248 
249     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
250         return actionContracts[_actionAddr];
251     }
252 
253     /// @dev This emits when the approved address for an WAR is changed or reaffirmed.
254     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
255 
256     /// @dev This emits when an operator is enabled or disabled for an owner.
257     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
258 
259     /// @dev This emits when the equipment ownership changed 
260     event Transfer(address indexed from, address indexed to, uint256 tokenId);
261 
262     /// @dev This emits when the equipment created
263     event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);
264 
265     /// @dev This emits when the equipment's attributes changed
266     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
267 
268     /// @dev This emits when the equipment destroyed
269     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
270     
271     function WarToken() public {
272         addrAdmin = msg.sender;
273         fashionArray.length += 1;
274     }
275 
276     // modifier
277     /// @dev Check if token ID is valid
278     modifier isValidToken(uint256 _tokenId) {
279         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
280         require(fashionIdToOwner[_tokenId] != address(0)); 
281         _;
282     }
283 
284     modifier canTransfer(uint256 _tokenId) {
285         address owner = fashionIdToOwner[_tokenId];
286         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
287         _;
288     }
289 
290     // ERC721
291     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
292         // ERC165 || ERC721 || ERC165^ERC721
293         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
294     }
295         
296     function name() public pure returns(string) {
297         return "WAR Token";
298     }
299 
300     function symbol() public pure returns(string) {
301         return "WAR";
302     }
303 
304     /// @dev Search for token quantity address
305     /// @param _owner Address that needs to be searched
306     /// @return Returns token quantity
307     function balanceOf(address _owner) external view returns(uint256) {
308         require(_owner != address(0));
309         return ownerToFashionArray[_owner].length;
310     }
311 
312     /// @dev Find the owner of an WAR
313     /// @param _tokenId The tokenId of WAR
314     /// @return Give The address of the owner of this WAR
315     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
316         return fashionIdToOwner[_tokenId];
317     }
318 
319     /// @dev Transfers the ownership of an WAR from one address to another address
320     /// @param _from The current owner of the WAR
321     /// @param _to The new owner
322     /// @param _tokenId The WAR to transfer
323     /// @param data Additional data with no specified format, sent in call to `_to`
324     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
325         external
326         whenNotPaused
327     {
328         _safeTransferFrom(_from, _to, _tokenId, data);
329     }
330 
331     /// @dev Transfers the ownership of an WAR from one address to another address
332     /// @param _from The current owner of the WAR
333     /// @param _to The new owner
334     /// @param _tokenId The WAR to transfer
335     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
336         external
337         whenNotPaused
338     {
339         _safeTransferFrom(_from, _to, _tokenId, "");
340     }
341 
342     /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost
343     /// @param _from The current owner of the WAR
344     /// @param _to The new owner
345     /// @param _tokenId The WAR to transfer
346     function transferFrom(address _from, address _to, uint256 _tokenId)
347         external
348         whenNotPaused
349         isValidToken(_tokenId)
350         canTransfer(_tokenId)
351     {
352         address owner = fashionIdToOwner[_tokenId];
353         require(owner != address(0));
354         require(_to != address(0));
355         require(owner == _from);
356         
357         _transfer(_from, _to, _tokenId);
358     }
359 
360     /// @dev Set or reaffirm the approved address for an WAR
361     /// @param _approved The new approved WAR controller
362     /// @param _tokenId The WAR to approve
363     function approve(address _approved, uint256 _tokenId)
364         external
365         whenNotPaused
366     {
367         address owner = fashionIdToOwner[_tokenId];
368         require(owner != address(0));
369         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
370 
371         fashionIdToApprovals[_tokenId] = _approved;
372         Approval(owner, _approved, _tokenId);
373     }
374 
375     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
376     /// @param _operator Address to add to the set of authorized operators.
377     /// @param _approved True if the operators is approved, false to revoke approval
378     function setApprovalForAll(address _operator, bool _approved) 
379         external 
380         whenNotPaused
381     {
382         operatorToApprovals[msg.sender][_operator] = _approved;
383         ApprovalForAll(msg.sender, _operator, _approved);
384     }
385 
386     /// @dev Get the approved address for a single WAR
387     /// @param _tokenId The WAR to find the approved address for
388     /// @return The approved address for this WAR, or the zero address if there is none
389     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
390         return fashionIdToApprovals[_tokenId];
391     }
392 
393     /// @dev Query if an address is an authorized operator for another address
394     /// @param _owner The address that owns the WARs
395     /// @param _operator The address that acts on behalf of the owner
396     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
397     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
398         return operatorToApprovals[_owner][_operator];
399     }
400 
401     /// @dev Count WARs tracked by this contract
402     /// @return A count of valid WARs tracked by this contract, where each one of
403     ///  them has an assigned and queryable owner not equal to the zero address
404     function totalSupply() external view returns (uint256) {
405         return fashionArray.length - destroyFashionCount - 1;
406     }
407 
408     /// @dev Do the real transfer with out any condition checking
409     /// @param _from The old owner of this WAR(If created: 0x0)
410     /// @param _to The new owner of this WAR 
411     /// @param _tokenId The tokenId of the WAR
412     function _transfer(address _from, address _to, uint256 _tokenId) internal {
413         if (_from != address(0)) {
414             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
415             uint256[] storage fsArray = ownerToFashionArray[_from];
416             require(fsArray[indexFrom] == _tokenId);
417 
418             // If the WAR is not the element of array, change it to with the last
419             if (indexFrom != fsArray.length - 1) {
420                 uint256 lastTokenId = fsArray[fsArray.length - 1];
421                 fsArray[indexFrom] = lastTokenId; 
422                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
423             }
424             fsArray.length -= 1; 
425             
426             if (fashionIdToApprovals[_tokenId] != address(0)) {
427                 delete fashionIdToApprovals[_tokenId];
428             }      
429         }
430 
431         // Give the WAR to '_to'
432         fashionIdToOwner[_tokenId] = _to;
433         ownerToFashionArray[_to].push(_tokenId);
434         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
435         
436         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
437     }
438 
439     /// @dev Actually perform the safeTransferFrom
440     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
441         internal
442         isValidToken(_tokenId) 
443         canTransfer(_tokenId)
444     {
445         address owner = fashionIdToOwner[_tokenId];
446         require(owner != address(0));
447         require(_to != address(0));
448         require(owner == _from);
449         
450         _transfer(_from, _to, _tokenId);
451 
452         // Do the callback after everything is done to avoid reentrancy attack
453         uint256 codeSize;
454         assembly { codeSize := extcodesize(_to) }
455         if (codeSize == 0) {
456             return;
457         }
458         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
459         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
460         require(retval == 0xf0b9e5ba);
461     }
462 
463     //----------------------------------------------------------------------------------------------------------
464 
465     /// @dev Equipment creation
466     /// @param _owner Owner of the equipment created
467     /// @param _attrs Attributes of the equipment created
468     /// @return Token ID of the equipment created
469     function createFashion(address _owner, uint16[9] _attrs, uint16 _createType) 
470         external 
471         whenNotPaused
472         returns(uint256)
473     {
474         require(actionContracts[msg.sender]);
475         require(_owner != address(0));
476 
477         uint256 newFashionId = fashionArray.length;
478         require(newFashionId < 4294967296);
479 
480         fashionArray.length += 1;
481         Fashion storage fs = fashionArray[newFashionId];
482         fs.protoId = _attrs[0];
483         fs.quality = _attrs[1];
484         fs.pos = _attrs[2];
485         if (_attrs[3] != 0) {
486             fs.health = _attrs[3];
487         }
488         
489         if (_attrs[4] != 0) {
490             fs.atkMin = _attrs[4];
491             fs.atkMax = _attrs[5];
492         }
493        
494         if (_attrs[6] != 0) {
495             fs.defence = _attrs[6];
496         }
497         
498         if (_attrs[7] != 0) {
499             fs.crit = _attrs[7];
500         }
501 
502         if (_attrs[8] != 0) {
503             fs.isPercent = _attrs[8];
504         }
505         
506         _transfer(0, _owner, newFashionId);
507         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _createType);
508         return newFashionId;
509     }
510 
511     /// @dev One specific attribute of the equipment modified
512     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
513         if (_index == 3) {
514             _fs.health = _val;
515         } else if(_index == 4) {
516             _fs.atkMin = _val;
517         } else if(_index == 5) {
518             _fs.atkMax = _val;
519         } else if(_index == 6) {
520             _fs.defence = _val;
521         } else if(_index == 7) {
522             _fs.crit = _val;
523         } else if(_index == 9) {
524             _fs.attrExt1 = _val;
525         } else if(_index == 10) {
526             _fs.attrExt2 = _val;
527         } else if(_index == 11) {
528             _fs.attrExt3 = _val;
529         }
530     }
531 
532     /// @dev Equiment attributes modified (max 4 stats modified)
533     /// @param _tokenId Equipment Token ID
534     /// @param _idxArray Stats order that must be modified
535     /// @param _params Stat value that must be modified
536     /// @param _changeType Modification type such as enhance, socket, etc.
537     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
538         external 
539         whenNotPaused
540         isValidToken(_tokenId) 
541     {
542         require(actionContracts[msg.sender]);
543 
544         Fashion storage fs = fashionArray[_tokenId];
545         if (_idxArray[0] > 0) {
546             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
547         }
548 
549         if (_idxArray[1] > 0) {
550             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
551         }
552 
553         if (_idxArray[2] > 0) {
554             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
555         }
556 
557         if (_idxArray[3] > 0) {
558             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
559         }
560 
561         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
562     }
563 
564     /// @dev Equipment destruction
565     /// @param _tokenId Equipment Token ID
566     /// @param _deleteType Destruction type, such as craft
567     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
568         external 
569         whenNotPaused
570         isValidToken(_tokenId) 
571     {
572         require(actionContracts[msg.sender]);
573 
574         address _from = fashionIdToOwner[_tokenId];
575         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
576         uint256[] storage fsArray = ownerToFashionArray[_from]; 
577         require(fsArray[indexFrom] == _tokenId);
578 
579         if (indexFrom != fsArray.length - 1) {
580             uint256 lastTokenId = fsArray[fsArray.length - 1];
581             fsArray[indexFrom] = lastTokenId; 
582             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
583         }
584         fsArray.length -= 1; 
585 
586         fashionIdToOwner[_tokenId] = address(0);
587         delete fashionIdToOwnerIndex[_tokenId];
588         destroyFashionCount += 1;
589 
590         Transfer(_from, 0, _tokenId);
591 
592         DeleteFashion(_from, _tokenId, _deleteType);
593     }
594 
595     /// @dev Safe transfer by trust contracts
596     function safeTransferByContract(uint256 _tokenId, address _to) 
597         external
598         whenNotPaused
599     {
600         require(actionContracts[msg.sender]);
601 
602         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
603         address owner = fashionIdToOwner[_tokenId];
604         require(owner != address(0));
605         require(_to != address(0));
606         require(owner != _to);
607 
608         _transfer(owner, _to, _tokenId);
609     }
610 
611     //----------------------------------------------------------------------------------------------------------
612 
613     /// @dev Get fashion attrs by tokenId
614     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {
615         Fashion storage fs = fashionArray[_tokenId];
616         datas[0] = fs.protoId;
617         datas[1] = fs.quality;
618         datas[2] = fs.pos;
619         datas[3] = fs.health;
620         datas[4] = fs.atkMin;
621         datas[5] = fs.atkMax;
622         datas[6] = fs.defence;
623         datas[7] = fs.crit;
624         datas[8] = fs.isPercent;
625         datas[9] = fs.attrExt1;
626         datas[10] = fs.attrExt2;
627         datas[11] = fs.attrExt3;
628     }
629 
630     /// @dev Get tokenIds and flags by owner
631     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
632         require(_owner != address(0));
633         uint256[] storage fsArray = ownerToFashionArray[_owner];
634         uint256 length = fsArray.length;
635         tokens = new uint256[](length);
636         flags = new uint32[](length);
637         for (uint256 i = 0; i < length; ++i) {
638             tokens[i] = fsArray[i];
639             Fashion storage fs = fashionArray[fsArray[i]];
640             flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);
641         }
642     }
643 
644     /// @dev WAR token info returned based on Token ID transfered (64 at most)
645     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
646         uint256 length = _tokens.length;
647         require(length <= 64);
648         attrs = new uint16[](length * 11);
649         uint256 tokenId;
650         uint256 index;
651         for (uint256 i = 0; i < length; ++i) {
652             tokenId = _tokens[i];
653             if (fashionIdToOwner[tokenId] != address(0)) {
654                 index = i * 11;
655                 Fashion storage fs = fashionArray[tokenId];
656                 attrs[index] = fs.health;
657                 attrs[index + 1] = fs.atkMin;
658                 attrs[index + 2] = fs.atkMax;
659                 attrs[index + 3] = fs.defence;
660                 attrs[index + 4] = fs.crit;
661                 attrs[index + 5] = fs.isPercent;
662                 attrs[index + 6] = fs.attrExt1;
663                 attrs[index + 7] = fs.attrExt2;
664                 attrs[index + 8] = fs.attrExt3;
665             }   
666         }
667     }
668 }
669 
670 contract ActionMiningPlat is Random, AccessService {
671     using SafeMath for uint256;
672 
673     event MiningOrderPlatCreated(uint256 indexed index, address indexed miner, uint64 chestCnt);
674     event MiningPlatResolved(uint256 indexed index, address indexed miner, uint64 chestCnt);
675 
676     struct MiningOrder {
677         address miner; 
678         uint64 chestCnt;
679         uint64 tmCreate;
680         uint64 tmResolve;
681     }
682 
683     /// @dev Max fashion suit id
684     uint16 maxProtoId;
685     /// @dev If the recommender can get reward 
686     bool isRecommendOpen;
687     /// @dev WarToken(NFT) contract address
688     WarToken public tokenContract;
689     /// @dev DataMining contract address
690     IDataMining public dataContract;
691     /// @dev mining order array
692     MiningOrder[] public ordersArray;
693     /// @dev suit count
694     mapping (uint16 => uint256) public protoIdToCount;
695     /// @dev BitGuildToken address
696     IBitGuildToken public bitGuildContract;
697     /// @dev mining Price of PLAT
698     uint256 public miningOnePlat = 600000000000000000000;
699     uint256 public miningThreePlat = 1800000000000000000000;
700     uint256 public miningFivePlat = 2850000000000000000000;
701     uint256 public miningTenPlat = 5400000000000000000000;
702 
703     function ActionMiningPlat(address _nftAddr, uint16 _maxProtoId, address _platAddr) public {
704         addrAdmin = msg.sender;
705         addrService = msg.sender;
706         addrFinance = msg.sender;
707 
708         tokenContract = WarToken(_nftAddr);
709         maxProtoId = _maxProtoId;
710         
711         MiningOrder memory order = MiningOrder(0, 0, 1, 1);
712         ordersArray.push(order);
713 
714         bitGuildContract = IBitGuildToken(_platAddr);
715     }
716 
717     function() external payable {
718 
719     }
720 
721     function getPlatBalance() external view returns(uint256) {
722         return bitGuildContract.balanceOf(this);
723     }
724 
725     function withdrawPlat() external {
726         require(msg.sender == addrFinance || msg.sender == addrAdmin);
727         uint256 balance = bitGuildContract.balanceOf(this);
728         require(balance > 0);
729         bitGuildContract.transfer(addrFinance, balance);
730     }
731 
732     function getOrderCount() external view returns(uint256) {
733         return ordersArray.length - 1;
734     }
735 
736     function setDataMining(address _addr) external onlyAdmin {
737         require(_addr != address(0));
738         dataContract = IDataMining(_addr);
739     }
740 
741     function setMaxProtoId(uint16 _maxProtoId) external onlyAdmin {
742         require(_maxProtoId > 0 && _maxProtoId < 10000);
743         require(_maxProtoId != maxProtoId);
744         maxProtoId = _maxProtoId;
745     }
746 
747     function setRecommendStatus(bool _isOpen) external onlyAdmin {
748         require(_isOpen != isRecommendOpen);
749         isRecommendOpen = _isOpen;
750     }
751 
752     function setFashionSuitCount(uint16 _protoId, uint256 _cnt) external onlyAdmin {
753         require(_protoId > 0 && _protoId <= maxProtoId);
754         require(_cnt > 0 && _cnt <= 5);
755         require(protoIdToCount[_protoId] != _cnt);
756         protoIdToCount[_protoId] = _cnt;
757     }
758 
759     function changePlatPrice(uint32 miningType, uint256 price) external onlyAdmin {
760         require(price > 0 && price < 100000);
761         uint256 newPrice = price * 1000000000000000000;
762         if (miningType == 1) {
763             miningOnePlat = newPrice;
764         } else if (miningType == 3) {
765             miningThreePlat = newPrice;
766         } else if (miningType == 5) {
767             miningFivePlat = newPrice;
768         } else if (miningType == 10) {
769             miningTenPlat = newPrice;
770         } else {
771             require(false);
772         }
773     }
774 
775     function _getFashionParam(uint256 _seed) internal view returns(uint16[9] attrs) {
776         uint256 curSeed = _seed;
777         // quality
778         uint256 rdm = curSeed % 10000;
779         uint16 qtyParam;
780         if (rdm < 6900) {
781             attrs[1] = 1;
782             qtyParam = 0;
783         } else if (rdm < 8700) {
784             attrs[1] = 2;
785             qtyParam = 1;
786         } else if (rdm < 9600) {
787             attrs[1] = 3;
788             qtyParam = 2;
789         } else if (rdm < 9900) {
790             attrs[1] = 4;
791             qtyParam = 4;
792         } else {
793             attrs[1] = 5;
794             qtyParam = 6;
795         }
796 
797         // protoId
798         curSeed /= 10000;
799         rdm = ((curSeed % 10000) / (9999 / maxProtoId)) + 1;
800         attrs[0] = uint16(rdm <= maxProtoId ? rdm : maxProtoId);
801 
802         // pos
803         curSeed /= 10000;
804         uint256 tmpVal = protoIdToCount[attrs[0]];
805         if (tmpVal == 0) {
806             tmpVal = 5;
807         }
808         rdm = ((curSeed % 10000) / (9999 / tmpVal)) + 1;
809         uint16 pos = uint16(rdm <= tmpVal ? rdm : tmpVal);
810         attrs[2] = pos;
811 
812         rdm = attrs[0] % 3;
813 
814         curSeed /= 10000;
815         tmpVal = (curSeed % 10000) % 21 + 90;
816 
817         if (rdm == 0) {
818             if (pos == 1) {
819                 uint256 attr = (200 + qtyParam * 200) * tmpVal / 100;              // +atk
820                 attrs[4] = uint16(attr * 40 / 100);
821                 attrs[5] = uint16(attr * 160 / 100);
822             } else if (pos == 2) {
823                 attrs[6] = uint16((40 + qtyParam * 40) * tmpVal / 100);            // +def
824             } else if (pos == 3) {
825                 attrs[3] = uint16((600 + qtyParam * 600) * tmpVal / 100);          // +hp
826             } else if (pos == 4) {
827                 attrs[6] = uint16((60 + qtyParam * 60) * tmpVal / 100);            // +def
828             } else {
829                 attrs[3] = uint16((400 + qtyParam * 400) * tmpVal / 100);          // +hp
830             }
831         } else if (rdm == 1) {
832             if (pos == 1) {
833                 uint256 attr2 = (190 + qtyParam * 190) * tmpVal / 100;              // +atk
834                 attrs[4] = uint16(attr2 * 50 / 100);
835                 attrs[5] = uint16(attr2 * 150 / 100);
836             } else if (pos == 2) {
837                 attrs[6] = uint16((42 + qtyParam * 42) * tmpVal / 100);            // +def
838             } else if (pos == 3) {
839                 attrs[3] = uint16((630 + qtyParam * 630) * tmpVal / 100);          // +hp
840             } else if (pos == 4) {
841                 attrs[6] = uint16((63 + qtyParam * 63) * tmpVal / 100);            // +def
842             } else {
843                 attrs[3] = uint16((420 + qtyParam * 420) * tmpVal / 100);          // +hp
844             }
845         } else {
846             if (pos == 1) {
847                 uint256 attr3 = (210 + qtyParam * 210) * tmpVal / 100;             // +atk
848                 attrs[4] = uint16(attr3 * 30 / 100);
849                 attrs[5] = uint16(attr3 * 170 / 100);
850             } else if (pos == 2) {
851                 attrs[6] = uint16((38 + qtyParam * 38) * tmpVal / 100);            // +def
852             } else if (pos == 3) {
853                 attrs[3] = uint16((570 + qtyParam * 570) * tmpVal / 100);          // +hp
854             } else if (pos == 4) {
855                 attrs[6] = uint16((57 + qtyParam * 57) * tmpVal / 100);            // +def
856             } else {
857                 attrs[3] = uint16((380 + qtyParam * 380) * tmpVal / 100);          // +hp
858             }
859         }
860         attrs[8] = 0;
861     }
862 
863     function _addOrder(address _miner, uint64 _chestCnt) internal {
864         uint64 newOrderId = uint64(ordersArray.length);
865         ordersArray.length += 1;
866         MiningOrder storage order = ordersArray[newOrderId];
867         order.miner = _miner;
868         order.chestCnt = _chestCnt;
869         order.tmCreate = uint64(block.timestamp);
870 
871         MiningOrderPlatCreated(newOrderId, _miner, _chestCnt);
872     }
873 
874     function _transferHelper(address _player, uint256 _platVal) private {
875         if (isRecommendOpen) {
876             address recommender = dataContract.getRecommender(_player);
877             if (recommender != address(0)) {
878                 uint256 rVal = _platVal.div(10);
879                 if (rVal > 0) {
880                     bitGuildContract.transfer(recommender, rVal);
881                 }   
882             }
883         } 
884     }
885 
886     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData) 
887         external 
888         whenNotPaused 
889     {
890         require(msg.sender == address(bitGuildContract));
891         require(_extraData.length == 1);
892         uint32 miningType = uint32(_extraData[0]);
893         if (miningType == 0) {
894             require(_value == miningOnePlat);
895             require(bitGuildContract.transferFrom(_sender, address(this), _value));
896             _miningOneSelf(_sender);
897         } else if (miningType == 10) {
898             require(_value == miningTenPlat);
899             require(bitGuildContract.transferFrom(_sender, address(this), _value));
900             _addOrder(_sender, 10);
901         } else if (miningType == 3) {
902             require(_value == miningThreePlat);
903             require(bitGuildContract.transferFrom(_sender, address(this), _value));
904             _addOrder(_sender, 3);
905         } else if (miningType == 5) {
906             require(_value == miningFivePlat);
907             require(bitGuildContract.transferFrom(_sender, address(this), _value));
908             _addOrder(_sender, 5);
909         } else if (miningType == 1) {
910             require(_value == miningOnePlat);
911             require(bitGuildContract.transferFrom(_sender, address(this), _value));
912             _addOrder(_sender, 1);
913         } else {
914             require(false);
915         }
916         _transferHelper(_sender, _value);
917     }
918 
919     function _miningOneSelf(address _sender) internal {
920         uint256 seed = _rand();
921         uint16[9] memory attrs = _getFashionParam(seed);
922 
923         tokenContract.createFashion(_sender, attrs, 6);
924 
925         MiningPlatResolved(0, _sender, 1);
926     }
927 
928     function miningResolve(uint256 _orderIndex, uint256 _seed) 
929         external 
930         onlyService
931     {
932         require(_orderIndex > 0 && _orderIndex < ordersArray.length);
933         MiningOrder storage order = ordersArray[_orderIndex];
934         require(order.tmResolve == 0);
935         address miner = order.miner;
936         require(miner != address(0));
937         uint64 chestCnt = order.chestCnt;
938         require(chestCnt >= 1 && chestCnt <= 10);
939 
940         uint256 rdm = _seed;
941         uint16[9] memory attrs;
942         for (uint64 i = 0; i < chestCnt; ++i) {
943             rdm = _randBySeed(rdm);
944             attrs = _getFashionParam(rdm);
945             tokenContract.createFashion(miner, attrs, 6);
946         }
947         order.tmResolve = uint64(block.timestamp);
948         MiningPlatResolved(_orderIndex, miner, chestCnt);
949     }
950 }