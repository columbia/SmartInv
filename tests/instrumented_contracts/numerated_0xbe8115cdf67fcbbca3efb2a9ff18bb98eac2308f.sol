1 pragma solidity ^0.4.20;
2 
3 /// @title ERC-165 Standard Interface Detection
4 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
5 interface ERC165 {
6     function supportsInterface(bytes4 interfaceID) external view returns (bool);
7 }
8 
9 /// @title ERC-721 Non-Fungible Token Standard
10 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
11 contract ERC721 is ERC165 {
12     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
13     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
14     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
15     function balanceOf(address _owner) external view returns (uint256);
16     function ownerOf(uint256 _tokenId) external view returns (address);
17     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
18     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
19     function transferFrom(address _from, address _to, uint256 _tokenId) external;
20     function approve(address _approved, uint256 _tokenId) external;
21     function setApprovalForAll(address _operator, bool _approved) external;
22     function getApproved(uint256 _tokenId) external view returns (address);
23     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
24 }
25 
26 /// @title ERC-721 Non-Fungible Token Standard
27 interface ERC721TokenReceiver {
28 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
29 }
30 
31 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
32 interface ERC721Metadata /* is ERC721 */ {
33     function name() external pure returns (string _name);
34     function symbol() external pure returns (string _symbol);
35     function tokenURI(uint256 _tokenId) external view returns (string);
36 }
37 
38 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
39 interface ERC721Enumerable /* is ERC721 */ {
40     function totalSupply() external view returns (uint256);
41     function tokenByIndex(uint256 _index) external view returns (uint256);
42     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
43 }
44 
45 contract AccessAdmin {
46     bool public isPaused = false;
47     address public addrAdmin;  
48 
49     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
50 
51     function AccessAdmin() public {
52         addrAdmin = msg.sender;
53     }  
54 
55 
56     modifier onlyAdmin() {
57         require(msg.sender == addrAdmin);
58         _;
59     }
60 
61     modifier whenNotPaused() {
62         require(!isPaused);
63         _;
64     }
65 
66     modifier whenPaused {
67         require(isPaused);
68         _;
69     }
70 
71     function setAdmin(address _newAdmin) external onlyAdmin {
72         require(_newAdmin != address(0));
73         AdminTransferred(addrAdmin, _newAdmin);
74         addrAdmin = _newAdmin;
75     }
76 
77     function doPause() external onlyAdmin whenNotPaused {
78         isPaused = true;
79     }
80 
81     function doUnpause() external onlyAdmin whenPaused {
82         isPaused = false;
83     }
84 }
85 
86 contract AccessService is AccessAdmin {
87     address public addrService;
88     address public addrFinance;
89 
90     modifier onlyService() {
91         require(msg.sender == addrService);
92         _;
93     }
94 
95     modifier onlyFinance() {
96         require(msg.sender == addrFinance);
97         _;
98     }
99 
100     function setService(address _newService) external {
101         require(msg.sender == addrService || msg.sender == addrAdmin);
102         require(_newService != address(0));
103         addrService = _newService;
104     }
105 
106     function setFinance(address _newFinance) external {
107         require(msg.sender == addrFinance || msg.sender == addrAdmin);
108         require(_newFinance != address(0));
109         addrFinance = _newFinance;
110     }
111 
112     function withdraw(address _target, uint256 _amount) 
113         external 
114     {
115         require(msg.sender == addrFinance || msg.sender == addrAdmin);
116         require(_amount > 0);
117         address receiver = _target == address(0) ? addrFinance : _target;
118         uint256 balance = this.balance;
119         if (_amount < balance) {
120             receiver.transfer(_amount);
121         } else {
122             receiver.transfer(this.balance);
123         }      
124     }
125 }
126 
127 contract WarToken is ERC721, AccessAdmin {
128     /// @dev The equipment info
129     struct Fashion {
130         uint16 protoId;     // 0  Equipment ID
131         uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
132         uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets
133         uint16 health;      // 3  Health
134         uint16 atkMin;      // 4  Min attack
135         uint16 atkMax;      // 5  Max attack
136         uint16 defence;     // 6  Defennse
137         uint16 crit;        // 7  Critical rate
138         uint16 isPercent;   // 8  Attr value type
139         uint16 attrExt1;    // 9  future stat 1
140         uint16 attrExt2;    // 10 future stat 2
141         uint16 attrExt3;    // 11 future stat 3
142     }
143 
144     /// @dev All equipments tokenArray (not exceeding 2^32-1)
145     Fashion[] public fashionArray;
146 
147     /// @dev Amount of tokens destroyed
148     uint256 destroyFashionCount;
149 
150     /// @dev Equipment token ID vs owner address
151     mapping (uint256 => address) fashionIdToOwner;
152 
153     /// @dev Equipments owner by the owner (array)
154     mapping (address => uint256[]) ownerToFashionArray;
155 
156     /// @dev Equipment token ID search in owner array
157     mapping (uint256 => uint256) fashionIdToOwnerIndex;
158 
159     /// @dev The authorized address for each WAR
160     mapping (uint256 => address) fashionIdToApprovals;
161 
162     /// @dev The authorized operators for each address
163     mapping (address => mapping (address => bool)) operatorToApprovals;
164 
165     /// @dev Trust contract
166     mapping (address => bool) actionContracts;
167 
168     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
169         actionContracts[_actionAddr] = _useful;
170     }
171 
172     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
173         return actionContracts[_actionAddr];
174     }
175 
176     /// @dev This emits when the approved address for an WAR is changed or reaffirmed.
177     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
178 
179     /// @dev This emits when an operator is enabled or disabled for an owner.
180     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
181 
182     /// @dev This emits when the equipment ownership changed 
183     event Transfer(address indexed from, address indexed to, uint256 tokenId);
184 
185     /// @dev This emits when the equipment created
186     event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);
187 
188     /// @dev This emits when the equipment's attributes changed
189     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
190 
191     /// @dev This emits when the equipment destroyed
192     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
193     
194     function WarToken() public {
195         addrAdmin = msg.sender;
196         fashionArray.length += 1;
197     }
198 
199     // modifier
200     /// @dev Check if token ID is valid
201     modifier isValidToken(uint256 _tokenId) {
202         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
203         require(fashionIdToOwner[_tokenId] != address(0)); 
204         _;
205     }
206 
207     modifier canTransfer(uint256 _tokenId) {
208         address owner = fashionIdToOwner[_tokenId];
209         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
210         _;
211     }
212 
213     // ERC721
214     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
215         // ERC165 || ERC721 || ERC165^ERC721
216         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
217     }
218         
219     function name() public pure returns(string) {
220         return "WAR Token";
221     }
222 
223     function symbol() public pure returns(string) {
224         return "WAR";
225     }
226 
227     /// @dev Search for token quantity address
228     /// @param _owner Address that needs to be searched
229     /// @return Returns token quantity
230     function balanceOf(address _owner) external view returns(uint256) {
231         require(_owner != address(0));
232         return ownerToFashionArray[_owner].length;
233     }
234 
235     /// @dev Find the owner of an WAR
236     /// @param _tokenId The tokenId of WAR
237     /// @return Give The address of the owner of this WAR
238     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
239         return fashionIdToOwner[_tokenId];
240     }
241 
242     /// @dev Transfers the ownership of an WAR from one address to another address
243     /// @param _from The current owner of the WAR
244     /// @param _to The new owner
245     /// @param _tokenId The WAR to transfer
246     /// @param data Additional data with no specified format, sent in call to `_to`
247     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
248         external
249         whenNotPaused
250     {
251         _safeTransferFrom(_from, _to, _tokenId, data);
252     }
253 
254     /// @dev Transfers the ownership of an WAR from one address to another address
255     /// @param _from The current owner of the WAR
256     /// @param _to The new owner
257     /// @param _tokenId The WAR to transfer
258     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
259         external
260         whenNotPaused
261     {
262         _safeTransferFrom(_from, _to, _tokenId, "");
263     }
264 
265     /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost
266     /// @param _from The current owner of the WAR
267     /// @param _to The new owner
268     /// @param _tokenId The WAR to transfer
269     function transferFrom(address _from, address _to, uint256 _tokenId)
270         external
271         whenNotPaused
272         isValidToken(_tokenId)
273         canTransfer(_tokenId)
274     {
275         address owner = fashionIdToOwner[_tokenId];
276         require(owner != address(0));
277         require(_to != address(0));
278         require(owner == _from);
279         
280         _transfer(_from, _to, _tokenId);
281     }
282 
283     /// @dev Set or reaffirm the approved address for an WAR
284     /// @param _approved The new approved WAR controller
285     /// @param _tokenId The WAR to approve
286     function approve(address _approved, uint256 _tokenId)
287         external
288         whenNotPaused
289     {
290         address owner = fashionIdToOwner[_tokenId];
291         require(owner != address(0));
292         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
293 
294         fashionIdToApprovals[_tokenId] = _approved;
295         Approval(owner, _approved, _tokenId);
296     }
297 
298     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
299     /// @param _operator Address to add to the set of authorized operators.
300     /// @param _approved True if the operators is approved, false to revoke approval
301     function setApprovalForAll(address _operator, bool _approved) 
302         external 
303         whenNotPaused
304     {
305         operatorToApprovals[msg.sender][_operator] = _approved;
306         ApprovalForAll(msg.sender, _operator, _approved);
307     }
308 
309     /// @dev Get the approved address for a single WAR
310     /// @param _tokenId The WAR to find the approved address for
311     /// @return The approved address for this WAR, or the zero address if there is none
312     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
313         return fashionIdToApprovals[_tokenId];
314     }
315 
316     /// @dev Query if an address is an authorized operator for another address
317     /// @param _owner The address that owns the WARs
318     /// @param _operator The address that acts on behalf of the owner
319     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
320     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
321         return operatorToApprovals[_owner][_operator];
322     }
323 
324     /// @dev Count WARs tracked by this contract
325     /// @return A count of valid WARs tracked by this contract, where each one of
326     ///  them has an assigned and queryable owner not equal to the zero address
327     function totalSupply() external view returns (uint256) {
328         return fashionArray.length - destroyFashionCount - 1;
329     }
330 
331     /// @dev Do the real transfer with out any condition checking
332     /// @param _from The old owner of this WAR(If created: 0x0)
333     /// @param _to The new owner of this WAR 
334     /// @param _tokenId The tokenId of the WAR
335     function _transfer(address _from, address _to, uint256 _tokenId) internal {
336         if (_from != address(0)) {
337             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
338             uint256[] storage fsArray = ownerToFashionArray[_from];
339             require(fsArray[indexFrom] == _tokenId);
340 
341             // If the WAR is not the element of array, change it to with the last
342             if (indexFrom != fsArray.length - 1) {
343                 uint256 lastTokenId = fsArray[fsArray.length - 1];
344                 fsArray[indexFrom] = lastTokenId; 
345                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
346             }
347             fsArray.length -= 1; 
348             
349             if (fashionIdToApprovals[_tokenId] != address(0)) {
350                 delete fashionIdToApprovals[_tokenId];
351             }      
352         }
353 
354         // Give the WAR to '_to'
355         fashionIdToOwner[_tokenId] = _to;
356         ownerToFashionArray[_to].push(_tokenId);
357         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
358         
359         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
360     }
361 
362     /// @dev Actually perform the safeTransferFrom
363     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
364         internal
365         isValidToken(_tokenId) 
366         canTransfer(_tokenId)
367     {
368         address owner = fashionIdToOwner[_tokenId];
369         require(owner != address(0));
370         require(_to != address(0));
371         require(owner == _from);
372         
373         _transfer(_from, _to, _tokenId);
374 
375         // Do the callback after everything is done to avoid reentrancy attack
376         uint256 codeSize;
377         assembly { codeSize := extcodesize(_to) }
378         if (codeSize == 0) {
379             return;
380         }
381         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
382         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
383         require(retval == 0xf0b9e5ba);
384     }
385 
386     //----------------------------------------------------------------------------------------------------------
387 
388     /// @dev Equipment creation
389     /// @param _owner Owner of the equipment created
390     /// @param _attrs Attributes of the equipment created
391     /// @return Token ID of the equipment created
392     function createFashion(address _owner, uint16[9] _attrs, uint16 _createType) 
393         external 
394         whenNotPaused
395         returns(uint256)
396     {
397         require(actionContracts[msg.sender]);
398         require(_owner != address(0));
399 
400         uint256 newFashionId = fashionArray.length;
401         require(newFashionId < 4294967296);
402 
403         fashionArray.length += 1;
404         Fashion storage fs = fashionArray[newFashionId];
405         fs.protoId = _attrs[0];
406         fs.quality = _attrs[1];
407         fs.pos = _attrs[2];
408         if (_attrs[3] != 0) {
409             fs.health = _attrs[3];
410         }
411         
412         if (_attrs[4] != 0) {
413             fs.atkMin = _attrs[4];
414             fs.atkMax = _attrs[5];
415         }
416        
417         if (_attrs[6] != 0) {
418             fs.defence = _attrs[6];
419         }
420         
421         if (_attrs[7] != 0) {
422             fs.crit = _attrs[7];
423         }
424 
425         if (_attrs[8] != 0) {
426             fs.isPercent = _attrs[8];
427         }
428         
429         _transfer(0, _owner, newFashionId);
430         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _createType);
431         return newFashionId;
432     }
433 
434     /// @dev One specific attribute of the equipment modified
435     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
436         if (_index == 3) {
437             _fs.health = _val;
438         } else if(_index == 4) {
439             _fs.atkMin = _val;
440         } else if(_index == 5) {
441             _fs.atkMax = _val;
442         } else if(_index == 6) {
443             _fs.defence = _val;
444         } else if(_index == 7) {
445             _fs.crit = _val;
446         } else if(_index == 9) {
447             _fs.attrExt1 = _val;
448         } else if(_index == 10) {
449             _fs.attrExt2 = _val;
450         } else if(_index == 11) {
451             _fs.attrExt3 = _val;
452         }
453     }
454 
455     /// @dev Equiment attributes modified (max 4 stats modified)
456     /// @param _tokenId Equipment Token ID
457     /// @param _idxArray Stats order that must be modified
458     /// @param _params Stat value that must be modified
459     /// @param _changeType Modification type such as enhance, socket, etc.
460     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
461         external 
462         whenNotPaused
463         isValidToken(_tokenId) 
464     {
465         require(actionContracts[msg.sender]);
466 
467         Fashion storage fs = fashionArray[_tokenId];
468         if (_idxArray[0] > 0) {
469             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
470         }
471 
472         if (_idxArray[1] > 0) {
473             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
474         }
475 
476         if (_idxArray[2] > 0) {
477             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
478         }
479 
480         if (_idxArray[3] > 0) {
481             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
482         }
483 
484         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
485     }
486 
487     /// @dev Equipment destruction
488     /// @param _tokenId Equipment Token ID
489     /// @param _deleteType Destruction type, such as craft
490     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
491         external 
492         whenNotPaused
493         isValidToken(_tokenId) 
494     {
495         require(actionContracts[msg.sender]);
496 
497         address _from = fashionIdToOwner[_tokenId];
498         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
499         uint256[] storage fsArray = ownerToFashionArray[_from]; 
500         require(fsArray[indexFrom] == _tokenId);
501 
502         if (indexFrom != fsArray.length - 1) {
503             uint256 lastTokenId = fsArray[fsArray.length - 1];
504             fsArray[indexFrom] = lastTokenId; 
505             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
506         }
507         fsArray.length -= 1; 
508 
509         fashionIdToOwner[_tokenId] = address(0);
510         delete fashionIdToOwnerIndex[_tokenId];
511         destroyFashionCount += 1;
512 
513         Transfer(_from, 0, _tokenId);
514 
515         DeleteFashion(_from, _tokenId, _deleteType);
516     }
517 
518     /// @dev Safe transfer by trust contracts
519     function safeTransferByContract(uint256 _tokenId, address _to) 
520         external
521         whenNotPaused
522     {
523         require(actionContracts[msg.sender]);
524 
525         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
526         address owner = fashionIdToOwner[_tokenId];
527         require(owner != address(0));
528         require(_to != address(0));
529         require(owner != _to);
530 
531         _transfer(owner, _to, _tokenId);
532     }
533 
534     //----------------------------------------------------------------------------------------------------------
535 
536     /// @dev Get fashion attrs by tokenId
537     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {
538         Fashion storage fs = fashionArray[_tokenId];
539         datas[0] = fs.protoId;
540         datas[1] = fs.quality;
541         datas[2] = fs.pos;
542         datas[3] = fs.health;
543         datas[4] = fs.atkMin;
544         datas[5] = fs.atkMax;
545         datas[6] = fs.defence;
546         datas[7] = fs.crit;
547         datas[8] = fs.isPercent;
548         datas[9] = fs.attrExt1;
549         datas[10] = fs.attrExt2;
550         datas[11] = fs.attrExt3;
551     }
552 
553     /// @dev Get tokenIds and flags by owner
554     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
555         require(_owner != address(0));
556         uint256[] storage fsArray = ownerToFashionArray[_owner];
557         uint256 length = fsArray.length;
558         tokens = new uint256[](length);
559         flags = new uint32[](length);
560         for (uint256 i = 0; i < length; ++i) {
561             tokens[i] = fsArray[i];
562             Fashion storage fs = fashionArray[fsArray[i]];
563             flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);
564         }
565     }
566 
567     /// @dev WAR token info returned based on Token ID transfered (64 at most)
568     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
569         uint256 length = _tokens.length;
570         require(length <= 64);
571         attrs = new uint16[](length * 11);
572         uint256 tokenId;
573         uint256 index;
574         for (uint256 i = 0; i < length; ++i) {
575             tokenId = _tokens[i];
576             if (fashionIdToOwner[tokenId] != address(0)) {
577                 index = i * 11;
578                 Fashion storage fs = fashionArray[tokenId];
579                 attrs[index] = fs.health;
580                 attrs[index + 1] = fs.atkMin;
581                 attrs[index + 2] = fs.atkMax;
582                 attrs[index + 3] = fs.defence;
583                 attrs[index + 4] = fs.crit;
584                 attrs[index + 5] = fs.isPercent;
585                 attrs[index + 6] = fs.attrExt1;
586                 attrs[index + 7] = fs.attrExt2;
587                 attrs[index + 8] = fs.attrExt3;
588             }   
589         }
590     }
591 }
592 
593 /// This Random is inspired by https://github.com/axiomzen/eth-random
594 contract Random {
595     uint256 _seed;
596 
597     function _rand() internal returns (uint256) {
598         _seed = uint256(keccak256(_seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
599         return _seed;
600     }
601 
602     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
603         return uint256(keccak256(_outSeed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
604     }
605 
606     /*
607     function _randByRange(uint256 _min, uint256 _max) internal returns (uint256) {
608         if (_min >= _max) {
609             return _min;
610         }
611         return (_rand() % (_max - _min)) + _min;
612     }
613 
614     function _rankByNumber(uint256 _max) internal returns (uint256) {
615         return _rand() % _max;
616     }
617     */
618 }
619 
620 interface IDataMining {
621     function getRecommender(address _target) external view returns(address);
622     function subFreeMineral(address _target) external returns(bool);
623 }
624 
625 interface IDataEquip {
626     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
627     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
628     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
629 }
630 
631 interface IDataAuction {
632     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
633     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
634 }
635 
636 /**
637  * @title SafeMath
638  * @dev Math operations with safety checks that throw on error
639  */
640 library SafeMath {
641     /**
642     * @dev Multiplies two numbers, throws on overflow.
643     */
644     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
645         if (a == 0) {
646             return 0;
647         }
648         uint256 c = a * b;
649         assert(c / a == b);
650         return c;
651     }
652 
653     /**
654     * @dev Integer division of two numbers, truncating the quotient.
655     */
656     function div(uint256 a, uint256 b) internal pure returns (uint256) {
657         // assert(b > 0); // Solidity automatically throws when dividing by 0
658         uint256 c = a / b;
659         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
660         return c;
661     }
662 
663     /**
664     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
665     */
666     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
667         assert(b <= a);
668         return a - b;
669     }
670 
671     /**
672     * @dev Adds two numbers, throws on overflow.
673     */
674     function add(uint256 a, uint256 b) internal pure returns (uint256) {
675         uint256 c = a + b;
676         assert(c >= a);
677         return c;
678     }
679 }
680 
681 contract ActionCompose is Random, AccessService {
682     using SafeMath for uint256;
683 
684     event ComposeSuccess(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos);
685     
686     /// @dev If the recommender can get reward 
687     bool isRecommendOpen;
688     /// @dev Auction contract address
689     IDataAuction public auctionContract;
690     /// @dev DataEquip contract address
691     IDataEquip public equipContract;
692     /// @dev WarToken(NFT) contract address
693     WarToken public tokenContract;
694 
695     function ActionCompose(address _nftAddr) public {
696         addrAdmin = msg.sender;
697         addrService = msg.sender;
698         addrFinance = msg.sender;
699 
700         tokenContract = WarToken(_nftAddr);
701     }
702 
703     function() external payable {
704 
705     }
706 
707     function setRecommendStatus(bool _isOpen) external onlyAdmin {
708         require(_isOpen != isRecommendOpen);
709         isRecommendOpen = _isOpen;
710     }
711 
712     function setDataAuction(address _addr) external onlyAdmin {
713         require(_addr != address(0));
714         auctionContract = IDataAuction(_addr);
715     }
716 
717     function setDataEquip(address _addr) external onlyAdmin {
718         require(_addr != address(0));
719         equipContract = IDataEquip(_addr);
720     }
721 
722     function _getFashionParam(uint256 _seed, uint16 _protoId, uint16 _quality, uint16 _pos) internal pure returns(uint16[9] attrs) {
723         uint256 curSeed = _seed;
724         attrs[0] = _protoId;
725         attrs[1] = _quality;
726         attrs[2] = _pos;
727 
728         uint16 qtyParam = 0;
729         if (_quality <= 3) {
730             qtyParam = _quality - 1;
731         } else if (_quality == 4) {
732             qtyParam = 4;
733         } else if (_quality == 5) {
734             qtyParam = 6;
735         }
736 
737         // 生成属性
738         uint256 rdm = _protoId % 3;
739 
740         curSeed /= 10000;
741         uint256 tmpVal = (curSeed % 10000) % 21 + 90;
742 
743         // 武器1/帽子2/衣服3/裤子4/鞋子5
744         if (rdm == 0) {
745             if (_pos == 1) {
746                 uint256 attr = (200 + qtyParam * 200) * tmpVal / 100;              // 武器+atk
747                 attrs[4] = uint16(attr * 40 / 100);
748                 attrs[5] = uint16(attr * 160 / 100);
749             } else if (_pos == 2) {
750                 attrs[6] = uint16((40 + qtyParam * 40) * tmpVal / 100);            // 帽子+def
751             } else if (_pos == 3) {
752                 attrs[3] = uint16((600 + qtyParam * 600) * tmpVal / 100);          // 衣服+hp
753             } else if (_pos == 4) {
754                 attrs[6] = uint16((60 + qtyParam * 60) * tmpVal / 100);            // 裤子+def
755             } else {
756                 attrs[3] = uint16((400 + qtyParam * 400) * tmpVal / 100);          // 鞋子+hp
757             }
758         } else if (rdm == 1) {
759             if (_pos == 1) {
760                 uint256 attr2 = (190 + qtyParam * 190) * tmpVal / 100;              // 武器+atk
761                 attrs[4] = uint16(attr2 * 50 / 100);
762                 attrs[5] = uint16(attr2 * 150 / 100);
763             } else if (_pos == 2) {
764                 attrs[6] = uint16((42 + qtyParam * 42) * tmpVal / 100);            // 帽子+def
765             } else if (_pos == 3) {
766                 attrs[3] = uint16((630 + qtyParam * 630) * tmpVal / 100);          // 衣服+hp
767             } else if (_pos == 4) {
768                 attrs[6] = uint16((63 + qtyParam * 63) * tmpVal / 100);            // 裤子+def
769             } else {
770                 attrs[3] = uint16((420 + qtyParam * 420) * tmpVal / 100);          // 鞋子+hp
771             }
772         } else {
773             if (_pos == 1) {
774                 uint256 attr3 = (210 + qtyParam * 210) * tmpVal / 100;             // 武器+atk
775                 attrs[4] = uint16(attr3 * 30 / 100);
776                 attrs[5] = uint16(attr3 * 170 / 100);
777             } else if (_pos == 2) {
778                 attrs[6] = uint16((38 + qtyParam * 38) * tmpVal / 100);            // 帽子+def
779             } else if (_pos == 3) {
780                 attrs[3] = uint16((570 + qtyParam * 570) * tmpVal / 100);          // 衣服+hp
781             } else if (_pos == 4) {
782                 attrs[6] = uint16((57 + qtyParam * 57) * tmpVal / 100);            // 裤子+def
783             } else {
784                 attrs[3] = uint16((380 + qtyParam * 380) * tmpVal / 100);          // 鞋子+hp
785             }
786         }
787         attrs[8] = 0;
788     }
789 
790     // gas 210019
791     function lowCompose(uint256 token1, uint256 token2) 
792         external
793         whenNotPaused
794     {
795         require(tokenContract.ownerOf(token1) == msg.sender);
796         require(tokenContract.ownerOf(token2) == msg.sender);
797         require(!equipContract.isEquipedAny2(msg.sender, token1, token2));
798 
799         if (address(auctionContract) != address(0)) {
800             require(!auctionContract.isOnSaleAny2(token1, token2));
801         }
802 
803         tokenContract.ownerOf(token1);
804 
805         uint16 protoId;
806         uint16 quality;
807         uint16 pos; 
808         uint16[12] memory fashionData = tokenContract.getFashion(token1);
809         protoId = fashionData[0];
810         quality = fashionData[1];
811         pos = fashionData[2];
812 
813         require(quality == 1 || quality == 2); 
814 
815         fashionData = tokenContract.getFashion(token2);
816         require(protoId == fashionData[0]);
817         require(quality == fashionData[1]);
818         require(pos == fashionData[2]);
819 
820         uint256 seed = _rand();
821         uint16[9] memory attrs = _getFashionParam(seed, protoId, quality + 1, pos);
822 
823         tokenContract.destroyFashion(token1, 1);
824         tokenContract.destroyFashion(token2, 1);
825 
826         uint256 newTokenId = tokenContract.createFashion(msg.sender, attrs, 3);
827 
828         ComposeSuccess(msg.sender, newTokenId, attrs[0], attrs[1], attrs[2]);
829     }
830 
831     // gas 198125
832     function highCompose(uint256 token1, uint256 token2, uint256 token3) 
833         external
834         whenNotPaused
835     {
836         require(tokenContract.ownerOf(token1) == msg.sender);
837         require(tokenContract.ownerOf(token2) == msg.sender);
838         require(tokenContract.ownerOf(token3) == msg.sender);
839         require(!equipContract.isEquipedAny3(msg.sender, token1, token2, token3));
840 
841         if (address(auctionContract) != address(0)) {
842             require(!auctionContract.isOnSaleAny3(token1, token2, token3));
843         }
844 
845         uint16 protoId;
846         uint16 quality;
847         uint16 pos; 
848         uint16[12] memory fashionData = tokenContract.getFashion(token1);
849         protoId = fashionData[0];
850         quality = fashionData[1];
851         pos = fashionData[2];
852 
853         require(quality == 3 || quality == 4);       
854 
855         fashionData = tokenContract.getFashion(token2);
856         require(protoId == fashionData[0]);
857         require(quality == fashionData[1]);
858         require(pos == fashionData[2]);
859 
860         fashionData = tokenContract.getFashion(token3);
861         require(protoId == fashionData[0]);
862         require(quality == fashionData[1]);
863         require(pos == fashionData[2]);
864 
865         uint256 seed = _rand();
866         uint16[9] memory attrs = _getFashionParam(seed, protoId, quality + 1, pos);
867 
868         tokenContract.destroyFashion(token1, 1);
869         tokenContract.destroyFashion(token2, 1);
870         tokenContract.destroyFashion(token3, 1);
871 
872         uint256 newTokenId = tokenContract.createFashion(msg.sender, attrs, 4);
873 
874         ComposeSuccess(msg.sender, newTokenId, attrs[0], attrs[1], attrs[2]);
875     }
876 }