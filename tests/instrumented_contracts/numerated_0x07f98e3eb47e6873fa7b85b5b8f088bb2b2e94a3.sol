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
40 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
41 interface ERC721Metadata /* is ERC721 */ {
42     function name() external pure returns (string _name);
43     function symbol() external pure returns (string _symbol);
44     function tokenURI(uint256 _tokenId) external view returns (string);
45 }
46 
47 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
48 interface ERC721Enumerable /* is ERC721 */ {
49     function totalSupply() external view returns (uint256);
50     function tokenByIndex(uint256 _index) external view returns (uint256);
51     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
52 }
53 
54 
55 contract AccessAdmin {
56     bool public isPaused = false;
57     address public addrAdmin;  
58 
59     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
60 
61     function AccessAdmin() public {
62         addrAdmin = msg.sender;
63     }  
64 
65 
66     modifier onlyAdmin() {
67         require(msg.sender == addrAdmin);
68         _;
69     }
70 
71     modifier whenNotPaused() {
72         require(!isPaused);
73         _;
74     }
75 
76     modifier whenPaused {
77         require(isPaused);
78         _;
79     }
80 
81     function setAdmin(address _newAdmin) external onlyAdmin {
82         require(_newAdmin != address(0));
83         AdminTransferred(addrAdmin, _newAdmin);
84         addrAdmin = _newAdmin;
85     }
86 
87     function doPause() external onlyAdmin whenNotPaused {
88         isPaused = true;
89     }
90 
91     function doUnpause() external onlyAdmin whenPaused {
92         isPaused = false;
93     }
94 }
95 
96 
97 contract AccessService is AccessAdmin {
98     address public addrService;
99     address public addrFinance;
100 
101     modifier onlyService() {
102         require(msg.sender == addrService);
103         _;
104     }
105 
106     modifier onlyFinance() {
107         require(msg.sender == addrFinance);
108         _;
109     }
110 
111     function setService(address _newService) external {
112         require(msg.sender == addrService || msg.sender == addrAdmin);
113         require(_newService != address(0));
114         addrService = _newService;
115     }
116 
117     function setFinance(address _newFinance) external {
118         require(msg.sender == addrFinance || msg.sender == addrAdmin);
119         require(_newFinance != address(0));
120         addrFinance = _newFinance;
121     }
122 
123     function withdraw(address _target, uint256 _amount) 
124         external 
125     {
126         require(msg.sender == addrFinance || msg.sender == addrAdmin);
127         require(_amount > 0);
128         address receiver = _target == address(0) ? addrFinance : _target;
129         uint256 balance = this.balance;
130         if (_amount < balance) {
131             receiver.transfer(_amount);
132         } else {
133             receiver.transfer(this.balance);
134         }      
135     }
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
604 /**
605  * @title SafeMath
606  * @dev Math operations with safety checks that throw on error
607  */
608 library SafeMath {
609     /**
610     * @dev Multiplies two numbers, throws on overflow.
611     */
612     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
613         if (a == 0) {
614             return 0;
615         }
616         uint256 c = a * b;
617         assert(c / a == b);
618         return c;
619     }
620 
621     /**
622     * @dev Integer division of two numbers, truncating the quotient.
623     */
624     function div(uint256 a, uint256 b) internal pure returns (uint256) {
625         // assert(b > 0); // Solidity automatically throws when dividing by 0
626         uint256 c = a / b;
627         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
628         return c;
629     }
630 
631     /**
632     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
633     */
634     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
635         assert(b <= a);
636         return a - b;
637     }
638 
639     /**
640     * @dev Adds two numbers, throws on overflow.
641     */
642     function add(uint256 a, uint256 b) internal pure returns (uint256) {
643         uint256 c = a + b;
644         assert(c >= a);
645         return c;
646     }
647 }
648 
649 interface IDataMining {
650     function getRecommender(address _target) external view returns(address);
651     function subFreeMineral(address _target) external returns(bool);
652 }
653 
654 interface IDataEquip {
655     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
656     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
657     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
658 }
659 
660 interface IDataAuction {
661     function isOnSale(uint256 _tokenId) external view returns(bool);
662     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
663     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
664 }
665 
666 interface IBitGuildToken {
667     function transfer(address _to, uint256 _value) external;
668     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
669     function approve(address _spender, uint256 _value) external; 
670     function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool);
671     function balanceOf(address _from) external view returns(uint256);
672 }
673 
674 contract ActionAuctionPlat is AccessService {
675     using SafeMath for uint256; 
676 
677     event AuctionPlatCreate(uint256 indexed index, address indexed seller, uint256 tokenId);
678     event AuctionPlatSold(uint256 indexed index, address indexed seller, address indexed buyer, uint256 tokenId, uint256 price);
679     event AuctionPlatCancel(uint256 indexed index, address indexed seller, uint256 tokenId);
680     event AuctionPlatPriceChange(uint256 indexed index, address indexed seller, uint256 tokenId, uint64 platVal);
681 
682     struct Auction {
683         address seller;     // Current owner
684         uint64 tokenId;     // WarToken Id
685         uint64 price;       // Sale price(PLAT)
686         uint64 tmStart;     // Sale start time(unixtime)
687         uint64 tmSell;      // Sale out time(unixtime)
688     }
689 
690     /// @dev Auction Array
691     Auction[] public auctionArray;
692     /// @dev Latest auction index by tokenId
693     mapping(uint256 => uint256) public latestAction;
694     /// @dev WarToken(NFT) contract address
695     WarToken public tokenContract;
696     /// @dev DataEquip contract address
697     IDataEquip public equipContract;
698     /// @dev BitGuildToken address
699     IBitGuildToken public bitGuildContract;
700     /// @dev Plat Auction address
701     IDataAuction public ethAuction;
702     /// @dev Binary search start index
703     uint64 public searchStartIndex;
704     /// @dev Auction order lifetime(sec)
705     uint64 public auctionDuration = 172800;
706     /// @dev Trade sum(Gwei)
707     uint64 public auctionSumPlat;
708 
709     function ActionAuctionPlat(address _nftAddr, address _platAddr) public {
710         addrAdmin = msg.sender;
711         addrService = msg.sender;
712         addrFinance = msg.sender;
713 
714         tokenContract = WarToken(_nftAddr);
715 
716         Auction memory order = Auction(0, 0, 0, 1, 1);
717         auctionArray.push(order);
718 
719         bitGuildContract = IBitGuildToken(_platAddr);
720     }
721 
722     function() external {}
723 
724     function setDataEquip(address _addr) external onlyAdmin {
725         require(_addr != address(0));
726         equipContract = IDataEquip(_addr);
727     }
728 
729     function setEthAuction(address _addr) external onlyAdmin {
730         require(_addr != address(0));
731         ethAuction = IDataAuction(_addr);
732     }
733 
734     function setDuration(uint64 _duration) external onlyAdmin {
735         require(_duration >= 300 && _duration <= 8640000);
736         auctionDuration = _duration;
737     }
738 
739     function newAuction(uint256 _tokenId, uint64 _pricePlat) 
740         external
741         whenNotPaused
742     {
743         require(tokenContract.ownerOf(_tokenId) == msg.sender);
744         require(!equipContract.isEquiped(msg.sender, _tokenId));
745         require(_pricePlat >= 1 && _pricePlat <= 999999);
746 
747         uint16[12] memory fashion = tokenContract.getFashion(_tokenId);
748         require(fashion[1] > 1);
749 
750         uint64 tmNow = uint64(block.timestamp);
751         uint256 lastIndex = latestAction[_tokenId];
752         if (lastIndex > 0) {
753             Auction memory oldOrder = auctionArray[lastIndex];
754             require((oldOrder.tmStart + auctionDuration) <= tmNow || oldOrder.tmSell > 0);
755         }
756 
757         if (address(ethAuction) != address(0)) {
758             require(!ethAuction.isOnSale(_tokenId));
759         }
760 
761         uint256 newAuctionIndex = auctionArray.length;
762         auctionArray.length += 1;
763         Auction storage order = auctionArray[newAuctionIndex];
764         order.seller = msg.sender;
765         order.tokenId = uint64(_tokenId);
766         order.price = _pricePlat;
767         uint64 lastActionStart = auctionArray[newAuctionIndex - 1].tmStart;
768         if (tmNow >= lastActionStart) {
769             order.tmStart = tmNow;
770         } else {
771             order.tmStart = lastActionStart;
772         }
773         
774         latestAction[_tokenId] = newAuctionIndex;
775 
776         AuctionPlatCreate(newAuctionIndex, msg.sender, _tokenId);
777     }
778 
779     function cancelAuction(uint256 _tokenId) external whenNotPaused {
780         require(tokenContract.ownerOf(_tokenId) == msg.sender);
781         uint256 lastIndex = latestAction[_tokenId];
782         require(lastIndex > 0);
783         Auction storage order = auctionArray[lastIndex];
784         require(order.seller == msg.sender);
785         require(order.tmSell == 0);
786         order.tmSell = 1;
787         AuctionPlatCancel(lastIndex, msg.sender, _tokenId);
788     }
789 
790     function changePrice(uint256 _tokenId, uint64 _pricePlat) external whenNotPaused {
791         require(tokenContract.ownerOf(_tokenId) == msg.sender);
792         uint256 lastIndex = latestAction[_tokenId];
793         require(lastIndex > 0);
794         Auction storage order = auctionArray[lastIndex];
795         require(order.seller == msg.sender);
796         require(order.tmSell == 0);
797 
798         uint64 tmNow = uint64(block.timestamp);
799         require(order.tmStart + auctionDuration > tmNow);
800         
801         require(_pricePlat >= 1 && _pricePlat <= 999999);
802         order.price = _pricePlat;
803 
804         AuctionPlatPriceChange(lastIndex, msg.sender, _tokenId, _pricePlat);
805     }
806 
807     function _bid(address _sender, uint256 _platVal, uint256 _tokenId) internal {
808         uint256 lastIndex = latestAction[_tokenId];
809         require(lastIndex > 0);
810         Auction storage order = auctionArray[lastIndex];
811 
812         uint64 tmNow = uint64(block.timestamp);
813         require(order.tmStart + auctionDuration > tmNow);
814         require(order.tmSell == 0);
815 
816         address realOwner = tokenContract.ownerOf(_tokenId);
817         require(realOwner == order.seller);
818         require(realOwner != _sender);
819 
820         uint256 price = (uint256(order.price)).mul(1000000000000000000);
821         require(price == _platVal);
822 
823         require(bitGuildContract.transferFrom(_sender, address(this), _platVal));
824         order.tmSell = tmNow;
825         auctionSumPlat += order.price;
826         uint256 sellerProceeds = price.mul(9).div(10);
827         tokenContract.safeTransferByContract(_tokenId, _sender);
828         bitGuildContract.transfer(realOwner, sellerProceeds);
829 
830         AuctionPlatSold(lastIndex, realOwner, _sender, _tokenId, price);
831     }
832 
833     function _getTokenIdFromBytes(bytes _extraData) internal pure returns(uint256) {
834         uint256 val = 0;
835         uint256 index = 0;
836         uint256 length = _extraData.length;
837         while (index < length) {
838             val += (uint256(_extraData[index]) * (256 ** (length - index - 1)));
839             index += 1;
840         }
841         return val;
842     }
843 
844     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData) 
845         external 
846         whenNotPaused 
847     {
848         require(msg.sender == address(bitGuildContract));
849         require(_extraData.length <= 8);
850         uint256 tokenId = _getTokenIdFromBytes(_extraData);
851         _bid(_sender, _value, tokenId);
852     }
853 
854     function _getStartIndex(uint64 startIndex) internal view returns(uint64) {
855         // use low_bound
856         uint64 tmFind = uint64(block.timestamp) - auctionDuration;
857         uint64 first = startIndex;
858         uint64 middle;
859         uint64 half;
860         uint64 len = uint64(auctionArray.length - startIndex);
861 
862         while(len > 0) {
863             half = len / 2;
864             middle = first + half;
865             if (auctionArray[middle].tmStart < tmFind) {
866                 first = middle + 1;
867                 len = len - half - 1;
868             } else {
869                 len = half;
870             }
871         }
872         return first;
873     }
874 
875     function resetSearchStartIndex () internal {
876         searchStartIndex = _getStartIndex(searchStartIndex);
877     }
878     
879     function _getAuctionIdArray(uint64 _startIndex, uint64 _count) 
880         internal 
881         view 
882         returns(uint64[])
883     {
884         uint64 tmFind = uint64(block.timestamp) - auctionDuration;
885         uint64 start = _startIndex > 0 ? _startIndex : _getStartIndex(0);
886         uint256 length = auctionArray.length;
887         uint256 maxLen = _count > 0 ? _count : length - start;
888         if (maxLen == 0) {
889             maxLen = 1;
890         }
891         uint64[] memory auctionIdArray = new uint64[](maxLen);
892         uint64 counter = 0;
893         for (uint64 i = start; i < length; ++i) {
894             if (auctionArray[i].tmStart > tmFind && auctionArray[i].tmSell == 0) {
895                 auctionIdArray[counter++] = i;
896                 if (_count > 0 && counter == _count) {
897                     break;
898                 }
899             }
900         }
901         if (counter == auctionIdArray.length) {
902             return auctionIdArray;
903         } else {
904             uint64[] memory realIdArray = new uint64[](counter);
905             for (uint256 j = 0; j < counter; ++j) {
906                 realIdArray[j] = auctionIdArray[j];
907             }
908             return realIdArray;
909         }
910     } 
911 
912     function getPlatBalance() external view returns(uint256) {
913         return bitGuildContract.balanceOf(this);
914     }
915 
916     function withdrawPlat() external {
917         require(msg.sender == addrFinance || msg.sender == addrAdmin);
918         uint256 balance = bitGuildContract.balanceOf(this);
919         require(balance > 0);
920         bitGuildContract.transfer(addrFinance, balance);
921     }
922 
923     function getAuctionIdArray(uint64 _startIndex, uint64 _count) external view returns(uint64[]) {
924         return _getAuctionIdArray(_startIndex, _count);
925     }
926     
927     function getAuctionArray(uint64 _startIndex, uint64 _count) 
928         external 
929         view 
930         returns(
931         uint64[] auctionIdArray, 
932         address[] sellerArray, 
933         uint64[] tokenIdArray, 
934         uint64[] priceArray, 
935         uint64[] tmStartArray)
936     {
937         auctionIdArray = _getAuctionIdArray(_startIndex, _count);
938         uint256 length = auctionIdArray.length;
939         sellerArray = new address[](length);
940         tokenIdArray = new uint64[](length);
941         priceArray = new uint64[](length);
942         tmStartArray = new uint64[](length);
943         
944         for (uint256 i = 0; i < length; ++i) {
945             Auction storage tmpAuction = auctionArray[auctionIdArray[i]];
946             sellerArray[i] = tmpAuction.seller;
947             tokenIdArray[i] = tmpAuction.tokenId;
948             priceArray[i] = tmpAuction.price;
949             tmStartArray[i] = tmpAuction.tmStart; 
950         }
951     } 
952 
953     function getAuction(uint64 auctionId) external view returns(
954         address seller,
955         uint64 tokenId,
956         uint64 price,
957         uint64 tmStart,
958         uint64 tmSell) 
959     {
960         require (auctionId < auctionArray.length); 
961         Auction memory auction = auctionArray[auctionId];
962         seller = auction.seller;
963         tokenId = auction.tokenId;
964         price = auction.price;
965         tmStart = auction.tmStart;
966         tmSell = auction.tmSell;
967     }
968 
969     function getAuctionTotal() external view returns(uint256) {
970         return auctionArray.length;
971     }
972 
973     function getStartIndex(uint64 _startIndex) external view returns(uint256) {
974         require (_startIndex < auctionArray.length);
975         return _getStartIndex(_startIndex);
976     }
977 
978     function isOnSale(uint256 _tokenId) external view returns(bool) {
979         uint256 lastIndex = latestAction[_tokenId];
980         if (lastIndex > 0) {
981             Auction storage order = auctionArray[lastIndex];
982             uint64 tmNow = uint64(block.timestamp);
983             if ((order.tmStart + auctionDuration > tmNow) && order.tmSell == 0) {
984                 return true;
985             }
986         }
987         return false;
988     }
989 
990     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool) {
991         uint256 lastIndex = latestAction[_tokenId1];
992         uint64 tmNow = uint64(block.timestamp);
993         if (lastIndex > 0) {
994             Auction storage order1 = auctionArray[lastIndex];
995             if ((order1.tmStart + auctionDuration > tmNow) && order1.tmSell == 0) {
996                 return true;
997             }
998         }
999         lastIndex = latestAction[_tokenId2];
1000         if (lastIndex > 0) {
1001             Auction storage order2 = auctionArray[lastIndex];
1002             if ((order2.tmStart + auctionDuration > tmNow) && order2.tmSell == 0) {
1003                 return true;
1004             }
1005         }
1006         return false;
1007     }
1008 
1009     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool) {
1010         uint256 lastIndex = latestAction[_tokenId1];
1011         uint64 tmNow = uint64(block.timestamp);
1012         if (lastIndex > 0) {
1013             Auction storage order1 = auctionArray[lastIndex];
1014             if ((order1.tmStart + auctionDuration > tmNow) && order1.tmSell == 0) {
1015                 return true;
1016             }
1017         }
1018         lastIndex = latestAction[_tokenId2];
1019         if (lastIndex > 0) {
1020             Auction storage order2 = auctionArray[lastIndex];
1021             if ((order2.tmStart + auctionDuration > tmNow) && order2.tmSell == 0) {
1022                 return true;
1023             }
1024         }
1025         lastIndex = latestAction[_tokenId3];
1026         if (lastIndex > 0) {
1027             Auction storage order3 = auctionArray[lastIndex];
1028             if ((order3.tmStart + auctionDuration > tmNow) && order3.tmSell == 0) {
1029                 return true;
1030             }
1031         }
1032         return false;
1033     }
1034 }