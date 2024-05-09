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
127 
128 interface IDataEquip {
129     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
130     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
131     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
132 }
133 
134 interface IDataAuction {
135     function isOnSale(uint256 _tokenId) external view returns(bool);
136     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
137     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
138 }
139 
140 interface IBitGuildToken {
141     function transfer(address _to, uint256 _value) external;
142     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
143     function approve(address _spender, uint256 _value) external; 
144     function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool);
145     function balanceOf(address _from) external view returns(uint256);
146 }
147 
148 /**
149  * @title SafeMath
150  * @dev Math operations with safety checks that throw on error
151  */
152 library SafeMath {
153     /**
154     * @dev Multiplies two numbers, throws on overflow.
155     */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         if (a == 0) {
158             return 0;
159         }
160         uint256 c = a * b;
161         assert(c / a == b);
162         return c;
163     }
164 
165     /**
166     * @dev Integer division of two numbers, truncating the quotient.
167     */
168     function div(uint256 a, uint256 b) internal pure returns (uint256) {
169         // assert(b > 0); // Solidity automatically throws when dividing by 0
170         uint256 c = a / b;
171         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
172         return c;
173     }
174 
175     /**
176     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
177     */
178     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
179         assert(b <= a);
180         return a - b;
181     }
182 
183     /**
184     * @dev Adds two numbers, throws on overflow.
185     */
186     function add(uint256 a, uint256 b) internal pure returns (uint256) {
187         uint256 c = a + b;
188         assert(c >= a);
189         return c;
190     }
191 }
192 
193 contract WarToken is ERC721, AccessAdmin {
194     /// @dev The equipment info
195     struct Fashion {
196         uint16 protoId;     // 0  Equipment ID
197         uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
198         uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets
199         uint16 health;      // 3  Health
200         uint16 atkMin;      // 4  Min attack
201         uint16 atkMax;      // 5  Max attack
202         uint16 defence;     // 6  Defennse
203         uint16 crit;        // 7  Critical rate
204         uint16 isPercent;   // 8  Attr value type
205         uint16 attrExt1;    // 9  future stat 1
206         uint16 attrExt2;    // 10 future stat 2
207         uint16 attrExt3;    // 11 future stat 3
208     }
209 
210     /// @dev All equipments tokenArray (not exceeding 2^32-1)
211     Fashion[] public fashionArray;
212 
213     /// @dev Amount of tokens destroyed
214     uint256 destroyFashionCount;
215 
216     /// @dev Equipment token ID vs owner address
217     mapping (uint256 => address) fashionIdToOwner;
218 
219     /// @dev Equipments owner by the owner (array)
220     mapping (address => uint256[]) ownerToFashionArray;
221 
222     /// @dev Equipment token ID search in owner array
223     mapping (uint256 => uint256) fashionIdToOwnerIndex;
224 
225     /// @dev The authorized address for each WAR
226     mapping (uint256 => address) fashionIdToApprovals;
227 
228     /// @dev The authorized operators for each address
229     mapping (address => mapping (address => bool)) operatorToApprovals;
230 
231     /// @dev Trust contract
232     mapping (address => bool) actionContracts;
233 
234     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
235         actionContracts[_actionAddr] = _useful;
236     }
237 
238     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
239         return actionContracts[_actionAddr];
240     }
241 
242     /// @dev This emits when the approved address for an WAR is changed or reaffirmed.
243     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
244 
245     /// @dev This emits when an operator is enabled or disabled for an owner.
246     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
247 
248     /// @dev This emits when the equipment ownership changed 
249     event Transfer(address indexed from, address indexed to, uint256 tokenId);
250 
251     /// @dev This emits when the equipment created
252     event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);
253 
254     /// @dev This emits when the equipment's attributes changed
255     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
256 
257     /// @dev This emits when the equipment destroyed
258     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
259     
260     function WarToken() public {
261         addrAdmin = msg.sender;
262         fashionArray.length += 1;
263     }
264 
265     // modifier
266     /// @dev Check if token ID is valid
267     modifier isValidToken(uint256 _tokenId) {
268         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
269         require(fashionIdToOwner[_tokenId] != address(0)); 
270         _;
271     }
272 
273     modifier canTransfer(uint256 _tokenId) {
274         address owner = fashionIdToOwner[_tokenId];
275         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
276         _;
277     }
278 
279     // ERC721
280     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
281         // ERC165 || ERC721 || ERC165^ERC721
282         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
283     }
284         
285     function name() public pure returns(string) {
286         return "WAR Token";
287     }
288 
289     function symbol() public pure returns(string) {
290         return "WAR";
291     }
292 
293     /// @dev Search for token quantity address
294     /// @param _owner Address that needs to be searched
295     /// @return Returns token quantity
296     function balanceOf(address _owner) external view returns(uint256) {
297         require(_owner != address(0));
298         return ownerToFashionArray[_owner].length;
299     }
300 
301     /// @dev Find the owner of an WAR
302     /// @param _tokenId The tokenId of WAR
303     /// @return Give The address of the owner of this WAR
304     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
305         return fashionIdToOwner[_tokenId];
306     }
307 
308     /// @dev Transfers the ownership of an WAR from one address to another address
309     /// @param _from The current owner of the WAR
310     /// @param _to The new owner
311     /// @param _tokenId The WAR to transfer
312     /// @param data Additional data with no specified format, sent in call to `_to`
313     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
314         external
315         whenNotPaused
316     {
317         _safeTransferFrom(_from, _to, _tokenId, data);
318     }
319 
320     /// @dev Transfers the ownership of an WAR from one address to another address
321     /// @param _from The current owner of the WAR
322     /// @param _to The new owner
323     /// @param _tokenId The WAR to transfer
324     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
325         external
326         whenNotPaused
327     {
328         _safeTransferFrom(_from, _to, _tokenId, "");
329     }
330 
331     /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost
332     /// @param _from The current owner of the WAR
333     /// @param _to The new owner
334     /// @param _tokenId The WAR to transfer
335     function transferFrom(address _from, address _to, uint256 _tokenId)
336         external
337         whenNotPaused
338         isValidToken(_tokenId)
339         canTransfer(_tokenId)
340     {
341         address owner = fashionIdToOwner[_tokenId];
342         require(owner != address(0));
343         require(_to != address(0));
344         require(owner == _from);
345         
346         _transfer(_from, _to, _tokenId);
347     }
348 
349     /// @dev Set or reaffirm the approved address for an WAR
350     /// @param _approved The new approved WAR controller
351     /// @param _tokenId The WAR to approve
352     function approve(address _approved, uint256 _tokenId)
353         external
354         whenNotPaused
355     {
356         address owner = fashionIdToOwner[_tokenId];
357         require(owner != address(0));
358         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
359 
360         fashionIdToApprovals[_tokenId] = _approved;
361         Approval(owner, _approved, _tokenId);
362     }
363 
364     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
365     /// @param _operator Address to add to the set of authorized operators.
366     /// @param _approved True if the operators is approved, false to revoke approval
367     function setApprovalForAll(address _operator, bool _approved) 
368         external 
369         whenNotPaused
370     {
371         operatorToApprovals[msg.sender][_operator] = _approved;
372         ApprovalForAll(msg.sender, _operator, _approved);
373     }
374 
375     /// @dev Get the approved address for a single WAR
376     /// @param _tokenId The WAR to find the approved address for
377     /// @return The approved address for this WAR, or the zero address if there is none
378     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
379         return fashionIdToApprovals[_tokenId];
380     }
381 
382     /// @dev Query if an address is an authorized operator for another address
383     /// @param _owner The address that owns the WARs
384     /// @param _operator The address that acts on behalf of the owner
385     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
386     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
387         return operatorToApprovals[_owner][_operator];
388     }
389 
390     /// @dev Count WARs tracked by this contract
391     /// @return A count of valid WARs tracked by this contract, where each one of
392     ///  them has an assigned and queryable owner not equal to the zero address
393     function totalSupply() external view returns (uint256) {
394         return fashionArray.length - destroyFashionCount - 1;
395     }
396 
397     /// @dev Do the real transfer with out any condition checking
398     /// @param _from The old owner of this WAR(If created: 0x0)
399     /// @param _to The new owner of this WAR 
400     /// @param _tokenId The tokenId of the WAR
401     function _transfer(address _from, address _to, uint256 _tokenId) internal {
402         if (_from != address(0)) {
403             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
404             uint256[] storage fsArray = ownerToFashionArray[_from];
405             require(fsArray[indexFrom] == _tokenId);
406 
407             // If the WAR is not the element of array, change it to with the last
408             if (indexFrom != fsArray.length - 1) {
409                 uint256 lastTokenId = fsArray[fsArray.length - 1];
410                 fsArray[indexFrom] = lastTokenId; 
411                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
412             }
413             fsArray.length -= 1; 
414             
415             if (fashionIdToApprovals[_tokenId] != address(0)) {
416                 delete fashionIdToApprovals[_tokenId];
417             }      
418         }
419 
420         // Give the WAR to '_to'
421         fashionIdToOwner[_tokenId] = _to;
422         ownerToFashionArray[_to].push(_tokenId);
423         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
424         
425         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
426     }
427 
428     /// @dev Actually perform the safeTransferFrom
429     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
430         internal
431         isValidToken(_tokenId) 
432         canTransfer(_tokenId)
433     {
434         address owner = fashionIdToOwner[_tokenId];
435         require(owner != address(0));
436         require(_to != address(0));
437         require(owner == _from);
438         
439         _transfer(_from, _to, _tokenId);
440 
441         // Do the callback after everything is done to avoid reentrancy attack
442         uint256 codeSize;
443         assembly { codeSize := extcodesize(_to) }
444         if (codeSize == 0) {
445             return;
446         }
447         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
448         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
449         require(retval == 0xf0b9e5ba);
450     }
451 
452     //----------------------------------------------------------------------------------------------------------
453 
454     /// @dev Equipment creation
455     /// @param _owner Owner of the equipment created
456     /// @param _attrs Attributes of the equipment created
457     /// @return Token ID of the equipment created
458     function createFashion(address _owner, uint16[9] _attrs, uint16 _createType) 
459         external 
460         whenNotPaused
461         returns(uint256)
462     {
463         require(actionContracts[msg.sender]);
464         require(_owner != address(0));
465 
466         uint256 newFashionId = fashionArray.length;
467         require(newFashionId < 4294967296);
468 
469         fashionArray.length += 1;
470         Fashion storage fs = fashionArray[newFashionId];
471         fs.protoId = _attrs[0];
472         fs.quality = _attrs[1];
473         fs.pos = _attrs[2];
474         if (_attrs[3] != 0) {
475             fs.health = _attrs[3];
476         }
477         
478         if (_attrs[4] != 0) {
479             fs.atkMin = _attrs[4];
480             fs.atkMax = _attrs[5];
481         }
482        
483         if (_attrs[6] != 0) {
484             fs.defence = _attrs[6];
485         }
486         
487         if (_attrs[7] != 0) {
488             fs.crit = _attrs[7];
489         }
490 
491         if (_attrs[8] != 0) {
492             fs.isPercent = _attrs[8];
493         }
494         
495         _transfer(0, _owner, newFashionId);
496         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _createType);
497         return newFashionId;
498     }
499 
500     /// @dev One specific attribute of the equipment modified
501     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
502         if (_index == 3) {
503             _fs.health = _val;
504         } else if(_index == 4) {
505             _fs.atkMin = _val;
506         } else if(_index == 5) {
507             _fs.atkMax = _val;
508         } else if(_index == 6) {
509             _fs.defence = _val;
510         } else if(_index == 7) {
511             _fs.crit = _val;
512         } else if(_index == 9) {
513             _fs.attrExt1 = _val;
514         } else if(_index == 10) {
515             _fs.attrExt2 = _val;
516         } else if(_index == 11) {
517             _fs.attrExt3 = _val;
518         }
519     }
520 
521     /// @dev Equiment attributes modified (max 4 stats modified)
522     /// @param _tokenId Equipment Token ID
523     /// @param _idxArray Stats order that must be modified
524     /// @param _params Stat value that must be modified
525     /// @param _changeType Modification type such as enhance, socket, etc.
526     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
527         external 
528         whenNotPaused
529         isValidToken(_tokenId) 
530     {
531         require(actionContracts[msg.sender]);
532 
533         Fashion storage fs = fashionArray[_tokenId];
534         if (_idxArray[0] > 0) {
535             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
536         }
537 
538         if (_idxArray[1] > 0) {
539             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
540         }
541 
542         if (_idxArray[2] > 0) {
543             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
544         }
545 
546         if (_idxArray[3] > 0) {
547             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
548         }
549 
550         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
551     }
552 
553     /// @dev Equipment destruction
554     /// @param _tokenId Equipment Token ID
555     /// @param _deleteType Destruction type, such as craft
556     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
557         external 
558         whenNotPaused
559         isValidToken(_tokenId) 
560     {
561         require(actionContracts[msg.sender]);
562 
563         address _from = fashionIdToOwner[_tokenId];
564         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
565         uint256[] storage fsArray = ownerToFashionArray[_from]; 
566         require(fsArray[indexFrom] == _tokenId);
567 
568         if (indexFrom != fsArray.length - 1) {
569             uint256 lastTokenId = fsArray[fsArray.length - 1];
570             fsArray[indexFrom] = lastTokenId; 
571             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
572         }
573         fsArray.length -= 1; 
574 
575         fashionIdToOwner[_tokenId] = address(0);
576         delete fashionIdToOwnerIndex[_tokenId];
577         destroyFashionCount += 1;
578 
579         Transfer(_from, 0, _tokenId);
580 
581         DeleteFashion(_from, _tokenId, _deleteType);
582     }
583 
584     /// @dev Safe transfer by trust contracts
585     function safeTransferByContract(uint256 _tokenId, address _to) 
586         external
587         whenNotPaused
588     {
589         require(actionContracts[msg.sender]);
590 
591         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
592         address owner = fashionIdToOwner[_tokenId];
593         require(owner != address(0));
594         require(_to != address(0));
595         require(owner != _to);
596 
597         _transfer(owner, _to, _tokenId);
598     }
599 
600     //----------------------------------------------------------------------------------------------------------
601 
602     /// @dev Get fashion attrs by tokenId
603     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {
604         Fashion storage fs = fashionArray[_tokenId];
605         datas[0] = fs.protoId;
606         datas[1] = fs.quality;
607         datas[2] = fs.pos;
608         datas[3] = fs.health;
609         datas[4] = fs.atkMin;
610         datas[5] = fs.atkMax;
611         datas[6] = fs.defence;
612         datas[7] = fs.crit;
613         datas[8] = fs.isPercent;
614         datas[9] = fs.attrExt1;
615         datas[10] = fs.attrExt2;
616         datas[11] = fs.attrExt3;
617     }
618 
619     /// @dev Get tokenIds and flags by owner
620     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
621         require(_owner != address(0));
622         uint256[] storage fsArray = ownerToFashionArray[_owner];
623         uint256 length = fsArray.length;
624         tokens = new uint256[](length);
625         flags = new uint32[](length);
626         for (uint256 i = 0; i < length; ++i) {
627             tokens[i] = fsArray[i];
628             Fashion storage fs = fashionArray[fsArray[i]];
629             flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);
630         }
631     }
632 
633     /// @dev WAR token info returned based on Token ID transfered (64 at most)
634     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
635         uint256 length = _tokens.length;
636         require(length <= 64);
637         attrs = new uint16[](length * 11);
638         uint256 tokenId;
639         uint256 index;
640         for (uint256 i = 0; i < length; ++i) {
641             tokenId = _tokens[i];
642             if (fashionIdToOwner[tokenId] != address(0)) {
643                 index = i * 11;
644                 Fashion storage fs = fashionArray[tokenId];
645                 attrs[index] = fs.health;
646                 attrs[index + 1] = fs.atkMin;
647                 attrs[index + 2] = fs.atkMax;
648                 attrs[index + 3] = fs.defence;
649                 attrs[index + 4] = fs.crit;
650                 attrs[index + 5] = fs.isPercent;
651                 attrs[index + 6] = fs.attrExt1;
652                 attrs[index + 7] = fs.attrExt2;
653                 attrs[index + 8] = fs.attrExt3;
654             }   
655         }
656     }
657 }
658 
659 contract ActionAuctionPlat is AccessService {
660     using SafeMath for uint256; 
661 
662     event AuctionPlatCreate(uint256 indexed index, address indexed seller, uint256 tokenId);
663     event AuctionPlatSold(uint256 indexed index, address indexed seller, address indexed buyer, uint256 tokenId, uint256 price);
664     event AuctionPlatCancel(uint256 indexed index, address indexed seller, uint256 tokenId);
665     event AuctionPlatPriceChange(uint256 indexed index, address indexed seller, uint256 tokenId, uint64 platVal);
666 
667     struct Auction {
668         address seller;     // Current owner
669         uint64 tokenId;     // WarToken Id
670         uint64 price;       // Sale price(PLAT)
671         uint64 tmStart;     // Sale start time(unixtime)
672         uint64 tmSell;      // Sale out time(unixtime)
673     }
674 
675     /// @dev Auction Array
676     Auction[] public auctionArray;
677     /// @dev Latest auction index by tokenId
678     mapping(uint256 => uint256) public latestAction;
679     /// @dev WarToken(NFT) contract address
680     WarToken public tokenContract;
681     /// @dev DataEquip contract address
682     IDataEquip public equipContract;
683     /// @dev BitGuildToken address
684     IBitGuildToken public bitGuildContract;
685     /// @dev Plat Auction address
686     IDataAuction public ethAuction;
687     /// @dev Binary search start index
688     uint64 public searchStartIndex;
689     /// @dev Auction order lifetime(sec)
690     uint64 public auctionDuration = 172800;
691     /// @dev Trade sum(Gwei)
692     uint64 public auctionSumPlat;
693 
694     function ActionAuctionPlat(address _nftAddr, address _platAddr) public {
695         addrAdmin = msg.sender;
696         addrService = msg.sender;
697         addrFinance = msg.sender;
698 
699         tokenContract = WarToken(_nftAddr);
700 
701         Auction memory order = Auction(0, 0, 0, 1, 1);
702         auctionArray.push(order);
703 
704         bitGuildContract = IBitGuildToken(_platAddr);
705     }
706 
707     function() external {}
708 
709     function setDataEquip(address _addr) external onlyAdmin {
710         require(_addr != address(0));
711         equipContract = IDataEquip(_addr);
712     }
713 
714     function setEthAuction(address _addr) external onlyAdmin {
715         require(_addr != address(0));
716         ethAuction = IDataAuction(_addr);
717     }
718 
719     function setDuration(uint64 _duration) external onlyAdmin {
720         require(_duration >= 300 && _duration <= 8640000);
721         auctionDuration = _duration;
722     }
723 
724     function newAuction(uint256 _tokenId, uint64 _pricePlat) 
725         external
726         whenNotPaused
727     {
728         require(tokenContract.ownerOf(_tokenId) == msg.sender);
729         require(!equipContract.isEquiped(msg.sender, _tokenId));
730         require(_pricePlat >= 1 && _pricePlat <= 999999);
731 
732         uint16[12] memory fashion = tokenContract.getFashion(_tokenId);
733         require(fashion[1] > 1);
734 
735         uint64 tmNow = uint64(block.timestamp);
736         uint256 lastIndex = latestAction[_tokenId];
737         if (lastIndex > 0) {
738             Auction memory oldOrder = auctionArray[lastIndex];
739             require((oldOrder.tmStart + auctionDuration) <= tmNow || oldOrder.tmSell > 0);
740         }
741 
742         if (address(ethAuction) != address(0)) {
743             require(!ethAuction.isOnSale(_tokenId));
744         }
745 
746         uint256 newAuctionIndex = auctionArray.length;
747         auctionArray.length += 1;
748         Auction storage order = auctionArray[newAuctionIndex];
749         order.seller = msg.sender;
750         order.tokenId = uint64(_tokenId);
751         order.price = _pricePlat;
752         uint64 lastActionStart = auctionArray[newAuctionIndex - 1].tmStart;
753         if (tmNow >= lastActionStart) {
754             order.tmStart = tmNow;
755         } else {
756             order.tmStart = lastActionStart;
757         }
758         
759         latestAction[_tokenId] = newAuctionIndex;
760 
761         AuctionPlatCreate(newAuctionIndex, msg.sender, _tokenId);
762     }
763 
764     function cancelAuction(uint256 _tokenId) external whenNotPaused {
765         require(tokenContract.ownerOf(_tokenId) == msg.sender);
766         uint256 lastIndex = latestAction[_tokenId];
767         require(lastIndex > 0);
768         Auction storage order = auctionArray[lastIndex];
769         require(order.seller == msg.sender);
770         require(order.tmSell == 0);
771         order.tmSell = 1;
772         AuctionPlatCancel(lastIndex, msg.sender, _tokenId);
773     }
774 
775     function changePrice(uint256 _tokenId, uint64 _pricePlat) external whenNotPaused {
776         require(tokenContract.ownerOf(_tokenId) == msg.sender);
777         uint256 lastIndex = latestAction[_tokenId];
778         require(lastIndex > 0);
779         Auction storage order = auctionArray[lastIndex];
780         require(order.seller == msg.sender);
781         require(order.tmSell == 0);
782 
783         uint64 tmNow = uint64(block.timestamp);
784         require(order.tmStart + auctionDuration > tmNow);
785         
786         require(_pricePlat >= 1 && _pricePlat <= 999999);
787         order.price = _pricePlat;
788 
789         AuctionPlatPriceChange(lastIndex, msg.sender, _tokenId, _pricePlat);
790     }
791 
792     function _bid(address _sender, uint256 _platVal, uint256 _tokenId) internal {
793         uint256 lastIndex = latestAction[_tokenId];
794         require(lastIndex > 0);
795         Auction storage order = auctionArray[lastIndex];
796 
797         uint64 tmNow = uint64(block.timestamp);
798         require(order.tmStart + auctionDuration > tmNow);
799         require(order.tmSell == 0);
800 
801         address realOwner = tokenContract.ownerOf(_tokenId);
802         require(realOwner == order.seller);
803         require(realOwner != _sender);
804 
805         uint256 price = (uint256(order.price)).mul(1000000000000000000);
806         require(price == _platVal);
807 
808         require(bitGuildContract.transferFrom(_sender, address(this), _platVal));
809         order.tmSell = tmNow;
810         auctionSumPlat += order.price;
811         uint256 sellerProceeds = price.mul(9).div(10);
812         tokenContract.safeTransferByContract(_tokenId, _sender);
813         bitGuildContract.transfer(realOwner, sellerProceeds);
814 
815         AuctionPlatSold(lastIndex, realOwner, _sender, _tokenId, price);
816     }
817 
818     function _getTokenIdFromBytes(bytes _extraData) internal pure returns(uint256) {
819         uint256 val = 0;
820         uint256 index = 0;
821         uint256 length = _extraData.length;
822         while (index < length) {
823             val += (uint256(_extraData[index]) * (256 ** (length - index - 1)));
824             index += 1;
825         }
826         return val;
827     }
828 
829     function receiveApproval(address _sender, uint256 _value, address _tokenContract, bytes _extraData) 
830         external 
831         whenNotPaused 
832     {
833         require(msg.sender == address(bitGuildContract));
834         require(_extraData.length <= 8);
835         uint256 tokenId = _getTokenIdFromBytes(_extraData);
836         _bid(_sender, _value, tokenId);
837     }
838 
839     function _getStartIndex(uint64 startIndex) internal view returns(uint64) {
840         // use low_bound
841         uint64 tmFind = uint64(block.timestamp) - auctionDuration;
842         uint64 first = startIndex;
843         uint64 middle;
844         uint64 half;
845         uint64 len = uint64(auctionArray.length - startIndex);
846 
847         while(len > 0) {
848             half = len / 2;
849             middle = first + half;
850             if (auctionArray[middle].tmStart < tmFind) {
851                 first = middle + 1;
852                 len = len - half - 1;
853             } else {
854                 len = half;
855             }
856         }
857         return first;
858     }
859 
860     function resetSearchStartIndex () internal {
861         searchStartIndex = _getStartIndex(searchStartIndex);
862     }
863     
864     function _getAuctionIdArray(uint64 _startIndex, uint64 _count) 
865         internal 
866         view 
867         returns(uint64[])
868     {
869         uint64 tmFind = uint64(block.timestamp) - auctionDuration;
870         uint64 start = _startIndex > 0 ? _startIndex : _getStartIndex(0);
871         uint256 length = auctionArray.length;
872         uint256 maxLen = _count > 0 ? _count : length - start;
873         if (maxLen == 0) {
874             maxLen = 1;
875         }
876         uint64[] memory auctionIdArray = new uint64[](maxLen);
877         uint64 counter = 0;
878         for (uint64 i = start; i < length; ++i) {
879             if (auctionArray[i].tmStart > tmFind && auctionArray[i].tmSell == 0) {
880                 auctionIdArray[counter++] = i;
881                 if (_count > 0 && counter == _count) {
882                     break;
883                 }
884             }
885         }
886         if (counter == auctionIdArray.length) {
887             return auctionIdArray;
888         } else {
889             uint64[] memory realIdArray = new uint64[](counter);
890             for (uint256 j = 0; j < counter; ++j) {
891                 realIdArray[j] = auctionIdArray[j];
892             }
893             return realIdArray;
894         }
895     } 
896 
897     function getAuctionIdArray(uint64 _startIndex, uint64 _count) external view returns(uint64[]) {
898         return _getAuctionIdArray(_startIndex, _count);
899     }
900     
901     function getAuctionArray(uint64 _startIndex, uint64 _count) 
902         external 
903         view 
904         returns(
905         uint64[] auctionIdArray, 
906         address[] sellerArray, 
907         uint64[] tokenIdArray, 
908         uint64[] priceArray, 
909         uint64[] tmStartArray)
910     {
911         auctionIdArray = _getAuctionIdArray(_startIndex, _count);
912         uint256 length = auctionIdArray.length;
913         sellerArray = new address[](length);
914         tokenIdArray = new uint64[](length);
915         priceArray = new uint64[](length);
916         tmStartArray = new uint64[](length);
917         
918         for (uint256 i = 0; i < length; ++i) {
919             Auction storage tmpAuction = auctionArray[auctionIdArray[i]];
920             sellerArray[i] = tmpAuction.seller;
921             tokenIdArray[i] = tmpAuction.tokenId;
922             priceArray[i] = tmpAuction.price;
923             tmStartArray[i] = tmpAuction.tmStart; 
924         }
925     } 
926 
927     function getAuction(uint64 auctionId) external view returns(
928         address seller,
929         uint64 tokenId,
930         uint64 price,
931         uint64 tmStart,
932         uint64 tmSell) 
933     {
934         require (auctionId < auctionArray.length); 
935         Auction memory auction = auctionArray[auctionId];
936         seller = auction.seller;
937         tokenId = auction.tokenId;
938         price = auction.price;
939         tmStart = auction.tmStart;
940         tmSell = auction.tmSell;
941     }
942 
943     function getAuctionTotal() external view returns(uint256) {
944         return auctionArray.length;
945     }
946 
947     function getStartIndex(uint64 _startIndex) external view returns(uint256) {
948         require (_startIndex < auctionArray.length);
949         return _getStartIndex(_startIndex);
950     }
951 
952     function isOnSale(uint256 _tokenId) external view returns(bool) {
953         uint256 lastIndex = latestAction[_tokenId];
954         if (lastIndex > 0) {
955             Auction storage order = auctionArray[lastIndex];
956             uint64 tmNow = uint64(block.timestamp);
957             if ((order.tmStart + auctionDuration > tmNow) && order.tmSell == 0) {
958                 return true;
959             }
960         }
961         return false;
962     }
963 
964     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool) {
965         uint256 lastIndex = latestAction[_tokenId1];
966         uint64 tmNow = uint64(block.timestamp);
967         if (lastIndex > 0) {
968             Auction storage order1 = auctionArray[lastIndex];
969             if ((order1.tmStart + auctionDuration > tmNow) && order1.tmSell == 0) {
970                 return true;
971             }
972         }
973         lastIndex = latestAction[_tokenId2];
974         if (lastIndex > 0) {
975             Auction storage order2 = auctionArray[lastIndex];
976             if ((order2.tmStart + auctionDuration > tmNow) && order2.tmSell == 0) {
977                 return true;
978             }
979         }
980         return false;
981     }
982 
983     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool) {
984         uint256 lastIndex = latestAction[_tokenId1];
985         uint64 tmNow = uint64(block.timestamp);
986         if (lastIndex > 0) {
987             Auction storage order1 = auctionArray[lastIndex];
988             if ((order1.tmStart + auctionDuration > tmNow) && order1.tmSell == 0) {
989                 return true;
990             }
991         }
992         lastIndex = latestAction[_tokenId2];
993         if (lastIndex > 0) {
994             Auction storage order2 = auctionArray[lastIndex];
995             if ((order2.tmStart + auctionDuration > tmNow) && order2.tmSell == 0) {
996                 return true;
997             }
998         }
999         lastIndex = latestAction[_tokenId3];
1000         if (lastIndex > 0) {
1001             Auction storage order3 = auctionArray[lastIndex];
1002             if ((order3.tmStart + auctionDuration > tmNow) && order3.tmSell == 0) {
1003                 return true;
1004             }
1005         }
1006         return false;
1007     }
1008 }