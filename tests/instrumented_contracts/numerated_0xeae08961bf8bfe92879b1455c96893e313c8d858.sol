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
81 contract AccessNoWithdraw is AccessAdmin {
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
95     modifier onlyManager() { 
96         require(msg.sender == addrService || msg.sender == addrAdmin || msg.sender == addrFinance);
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
111 }
112 
113 interface IDataMining {
114     function getRecommender(address _target) external view returns(address);
115     function subFreeMineral(address _target) external returns(bool);
116 }
117 
118 interface IDataEquip {
119     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
120     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
121     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
122 }
123 
124 interface IDataAuction {
125     function isOnSale(uint256 _tokenId) external view returns(bool);
126     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
127     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
128 }
129 
130 interface IEOMarketToken {
131     function transfer(address _to, uint256 _value) external;
132     function transferFrom(address _from, address _to, uint256 _value) external returns (bool);
133     function approve(address _spender, uint256 _value) external; 
134     function approveAndCall(address _spender, uint256 _value, bytes _extraData) external returns (bool);
135     function balanceOf(address _from) external view returns(uint256);
136     function totalSupply() external view returns(uint256);
137     function totalSold() external view returns(uint256);
138     function getShareholders() external view returns(address[100] addrArray, uint256[100] amountArray, uint256 soldAmount);
139 }
140 
141 /**
142  * @title SafeMath
143  * @dev Math operations with safety checks that throw on error
144  */
145 library SafeMath {
146     /**
147     * @dev Multiplies two numbers, throws on overflow.
148     */
149     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
150         if (a == 0) {
151             return 0;
152         }
153         uint256 c = a * b;
154         assert(c / a == b);
155         return c;
156     }
157 
158     /**
159     * @dev Integer division of two numbers, truncating the quotient.
160     */
161     function div(uint256 a, uint256 b) internal pure returns (uint256) {
162         // assert(b > 0); // Solidity automatically throws when dividing by 0
163         uint256 c = a / b;
164         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
165         return c;
166     }
167 
168     /**
169     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
170     */
171     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
172         assert(b <= a);
173         return a - b;
174     }
175 
176     /**
177     * @dev Adds two numbers, throws on overflow.
178     */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         uint256 c = a + b;
181         assert(c >= a);
182         return c;
183     }
184 }
185 
186 contract WarToken is ERC721, AccessAdmin {
187     /// @dev The equipment info
188     struct Fashion {
189         uint16 protoId;     // 0  Equipment ID
190         uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
191         uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets
192         uint16 health;      // 3  Health
193         uint16 atkMin;      // 4  Min attack
194         uint16 atkMax;      // 5  Max attack
195         uint16 defence;     // 6  Defennse
196         uint16 crit;        // 7  Critical rate
197         uint16 isPercent;   // 8  Attr value type
198         uint16 attrExt1;    // 9  future stat 1
199         uint16 attrExt2;    // 10 future stat 2
200         uint16 attrExt3;    // 11 future stat 3
201     }
202 
203     /// @dev All equipments tokenArray (not exceeding 2^32-1)
204     Fashion[] public fashionArray;
205 
206     /// @dev Amount of tokens destroyed
207     uint256 destroyFashionCount;
208 
209     /// @dev Equipment token ID vs owner address
210     mapping (uint256 => address) fashionIdToOwner;
211 
212     /// @dev Equipments owner by the owner (array)
213     mapping (address => uint256[]) ownerToFashionArray;
214 
215     /// @dev Equipment token ID search in owner array
216     mapping (uint256 => uint256) fashionIdToOwnerIndex;
217 
218     /// @dev The authorized address for each WAR
219     mapping (uint256 => address) fashionIdToApprovals;
220 
221     /// @dev The authorized operators for each address
222     mapping (address => mapping (address => bool)) operatorToApprovals;
223 
224     /// @dev Trust contract
225     mapping (address => bool) actionContracts;
226 
227     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
228         actionContracts[_actionAddr] = _useful;
229     }
230 
231     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
232         return actionContracts[_actionAddr];
233     }
234 
235     /// @dev This emits when the approved address for an WAR is changed or reaffirmed.
236     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
237 
238     /// @dev This emits when an operator is enabled or disabled for an owner.
239     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
240 
241     /// @dev This emits when the equipment ownership changed 
242     event Transfer(address indexed from, address indexed to, uint256 tokenId);
243 
244     /// @dev This emits when the equipment created
245     event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);
246 
247     /// @dev This emits when the equipment's attributes changed
248     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
249 
250     /// @dev This emits when the equipment destroyed
251     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
252     
253     function WarToken() public {
254         addrAdmin = msg.sender;
255         fashionArray.length += 1;
256     }
257 
258     // modifier
259     /// @dev Check if token ID is valid
260     modifier isValidToken(uint256 _tokenId) {
261         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
262         require(fashionIdToOwner[_tokenId] != address(0)); 
263         _;
264     }
265 
266     modifier canTransfer(uint256 _tokenId) {
267         address owner = fashionIdToOwner[_tokenId];
268         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
269         _;
270     }
271 
272     // ERC721
273     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
274         // ERC165 || ERC721 || ERC165^ERC721
275         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
276     }
277         
278     function name() public pure returns(string) {
279         return "WAR Token";
280     }
281 
282     function symbol() public pure returns(string) {
283         return "WAR";
284     }
285 
286     /// @dev Search for token quantity address
287     /// @param _owner Address that needs to be searched
288     /// @return Returns token quantity
289     function balanceOf(address _owner) external view returns(uint256) {
290         require(_owner != address(0));
291         return ownerToFashionArray[_owner].length;
292     }
293 
294     /// @dev Find the owner of an WAR
295     /// @param _tokenId The tokenId of WAR
296     /// @return Give The address of the owner of this WAR
297     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
298         return fashionIdToOwner[_tokenId];
299     }
300 
301     /// @dev Transfers the ownership of an WAR from one address to another address
302     /// @param _from The current owner of the WAR
303     /// @param _to The new owner
304     /// @param _tokenId The WAR to transfer
305     /// @param data Additional data with no specified format, sent in call to `_to`
306     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
307         external
308         whenNotPaused
309     {
310         _safeTransferFrom(_from, _to, _tokenId, data);
311     }
312 
313     /// @dev Transfers the ownership of an WAR from one address to another address
314     /// @param _from The current owner of the WAR
315     /// @param _to The new owner
316     /// @param _tokenId The WAR to transfer
317     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
318         external
319         whenNotPaused
320     {
321         _safeTransferFrom(_from, _to, _tokenId, "");
322     }
323 
324     /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost
325     /// @param _from The current owner of the WAR
326     /// @param _to The new owner
327     /// @param _tokenId The WAR to transfer
328     function transferFrom(address _from, address _to, uint256 _tokenId)
329         external
330         whenNotPaused
331         isValidToken(_tokenId)
332         canTransfer(_tokenId)
333     {
334         address owner = fashionIdToOwner[_tokenId];
335         require(owner != address(0));
336         require(_to != address(0));
337         require(owner == _from);
338         
339         _transfer(_from, _to, _tokenId);
340     }
341 
342     /// @dev Set or reaffirm the approved address for an WAR
343     /// @param _approved The new approved WAR controller
344     /// @param _tokenId The WAR to approve
345     function approve(address _approved, uint256 _tokenId)
346         external
347         whenNotPaused
348     {
349         address owner = fashionIdToOwner[_tokenId];
350         require(owner != address(0));
351         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
352 
353         fashionIdToApprovals[_tokenId] = _approved;
354         Approval(owner, _approved, _tokenId);
355     }
356 
357     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
358     /// @param _operator Address to add to the set of authorized operators.
359     /// @param _approved True if the operators is approved, false to revoke approval
360     function setApprovalForAll(address _operator, bool _approved) 
361         external 
362         whenNotPaused
363     {
364         operatorToApprovals[msg.sender][_operator] = _approved;
365         ApprovalForAll(msg.sender, _operator, _approved);
366     }
367 
368     /// @dev Get the approved address for a single WAR
369     /// @param _tokenId The WAR to find the approved address for
370     /// @return The approved address for this WAR, or the zero address if there is none
371     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
372         return fashionIdToApprovals[_tokenId];
373     }
374 
375     /// @dev Query if an address is an authorized operator for another address
376     /// @param _owner The address that owns the WARs
377     /// @param _operator The address that acts on behalf of the owner
378     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
379     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
380         return operatorToApprovals[_owner][_operator];
381     }
382 
383     /// @dev Count WARs tracked by this contract
384     /// @return A count of valid WARs tracked by this contract, where each one of
385     ///  them has an assigned and queryable owner not equal to the zero address
386     function totalSupply() external view returns (uint256) {
387         return fashionArray.length - destroyFashionCount - 1;
388     }
389 
390     /// @dev Do the real transfer with out any condition checking
391     /// @param _from The old owner of this WAR(If created: 0x0)
392     /// @param _to The new owner of this WAR 
393     /// @param _tokenId The tokenId of the WAR
394     function _transfer(address _from, address _to, uint256 _tokenId) internal {
395         if (_from != address(0)) {
396             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
397             uint256[] storage fsArray = ownerToFashionArray[_from];
398             require(fsArray[indexFrom] == _tokenId);
399 
400             // If the WAR is not the element of array, change it to with the last
401             if (indexFrom != fsArray.length - 1) {
402                 uint256 lastTokenId = fsArray[fsArray.length - 1];
403                 fsArray[indexFrom] = lastTokenId; 
404                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
405             }
406             fsArray.length -= 1; 
407             
408             if (fashionIdToApprovals[_tokenId] != address(0)) {
409                 delete fashionIdToApprovals[_tokenId];
410             }      
411         }
412 
413         // Give the WAR to '_to'
414         fashionIdToOwner[_tokenId] = _to;
415         ownerToFashionArray[_to].push(_tokenId);
416         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
417         
418         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
419     }
420 
421     /// @dev Actually perform the safeTransferFrom
422     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
423         internal
424         isValidToken(_tokenId) 
425         canTransfer(_tokenId)
426     {
427         address owner = fashionIdToOwner[_tokenId];
428         require(owner != address(0));
429         require(_to != address(0));
430         require(owner == _from);
431         
432         _transfer(_from, _to, _tokenId);
433 
434         // Do the callback after everything is done to avoid reentrancy attack
435         uint256 codeSize;
436         assembly { codeSize := extcodesize(_to) }
437         if (codeSize == 0) {
438             return;
439         }
440         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
441         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
442         require(retval == 0xf0b9e5ba);
443     }
444 
445     //----------------------------------------------------------------------------------------------------------
446 
447     /// @dev Equipment creation
448     /// @param _owner Owner of the equipment created
449     /// @param _attrs Attributes of the equipment created
450     /// @return Token ID of the equipment created
451     function createFashion(address _owner, uint16[9] _attrs, uint16 _createType) 
452         external 
453         whenNotPaused
454         returns(uint256)
455     {
456         require(actionContracts[msg.sender]);
457         require(_owner != address(0));
458 
459         uint256 newFashionId = fashionArray.length;
460         require(newFashionId < 4294967296);
461 
462         fashionArray.length += 1;
463         Fashion storage fs = fashionArray[newFashionId];
464         fs.protoId = _attrs[0];
465         fs.quality = _attrs[1];
466         fs.pos = _attrs[2];
467         if (_attrs[3] != 0) {
468             fs.health = _attrs[3];
469         }
470         
471         if (_attrs[4] != 0) {
472             fs.atkMin = _attrs[4];
473             fs.atkMax = _attrs[5];
474         }
475        
476         if (_attrs[6] != 0) {
477             fs.defence = _attrs[6];
478         }
479         
480         if (_attrs[7] != 0) {
481             fs.crit = _attrs[7];
482         }
483 
484         if (_attrs[8] != 0) {
485             fs.isPercent = _attrs[8];
486         }
487         
488         _transfer(0, _owner, newFashionId);
489         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _createType);
490         return newFashionId;
491     }
492 
493     /// @dev One specific attribute of the equipment modified
494     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
495         if (_index == 3) {
496             _fs.health = _val;
497         } else if(_index == 4) {
498             _fs.atkMin = _val;
499         } else if(_index == 5) {
500             _fs.atkMax = _val;
501         } else if(_index == 6) {
502             _fs.defence = _val;
503         } else if(_index == 7) {
504             _fs.crit = _val;
505         } else if(_index == 9) {
506             _fs.attrExt1 = _val;
507         } else if(_index == 10) {
508             _fs.attrExt2 = _val;
509         } else if(_index == 11) {
510             _fs.attrExt3 = _val;
511         }
512     }
513 
514     /// @dev Equiment attributes modified (max 4 stats modified)
515     /// @param _tokenId Equipment Token ID
516     /// @param _idxArray Stats order that must be modified
517     /// @param _params Stat value that must be modified
518     /// @param _changeType Modification type such as enhance, socket, etc.
519     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
520         external 
521         whenNotPaused
522         isValidToken(_tokenId) 
523     {
524         require(actionContracts[msg.sender]);
525 
526         Fashion storage fs = fashionArray[_tokenId];
527         if (_idxArray[0] > 0) {
528             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
529         }
530 
531         if (_idxArray[1] > 0) {
532             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
533         }
534 
535         if (_idxArray[2] > 0) {
536             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
537         }
538 
539         if (_idxArray[3] > 0) {
540             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
541         }
542 
543         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
544     }
545 
546     /// @dev Equipment destruction
547     /// @param _tokenId Equipment Token ID
548     /// @param _deleteType Destruction type, such as craft
549     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
550         external 
551         whenNotPaused
552         isValidToken(_tokenId) 
553     {
554         require(actionContracts[msg.sender]);
555 
556         address _from = fashionIdToOwner[_tokenId];
557         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
558         uint256[] storage fsArray = ownerToFashionArray[_from]; 
559         require(fsArray[indexFrom] == _tokenId);
560 
561         if (indexFrom != fsArray.length - 1) {
562             uint256 lastTokenId = fsArray[fsArray.length - 1];
563             fsArray[indexFrom] = lastTokenId; 
564             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
565         }
566         fsArray.length -= 1; 
567 
568         fashionIdToOwner[_tokenId] = address(0);
569         delete fashionIdToOwnerIndex[_tokenId];
570         destroyFashionCount += 1;
571 
572         Transfer(_from, 0, _tokenId);
573 
574         DeleteFashion(_from, _tokenId, _deleteType);
575     }
576 
577     /// @dev Safe transfer by trust contracts
578     function safeTransferByContract(uint256 _tokenId, address _to) 
579         external
580         whenNotPaused
581     {
582         require(actionContracts[msg.sender]);
583 
584         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
585         address owner = fashionIdToOwner[_tokenId];
586         require(owner != address(0));
587         require(_to != address(0));
588         require(owner != _to);
589 
590         _transfer(owner, _to, _tokenId);
591     }
592 
593     //----------------------------------------------------------------------------------------------------------
594 
595     /// @dev Get fashion attrs by tokenId
596     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {
597         Fashion storage fs = fashionArray[_tokenId];
598         datas[0] = fs.protoId;
599         datas[1] = fs.quality;
600         datas[2] = fs.pos;
601         datas[3] = fs.health;
602         datas[4] = fs.atkMin;
603         datas[5] = fs.atkMax;
604         datas[6] = fs.defence;
605         datas[7] = fs.crit;
606         datas[8] = fs.isPercent;
607         datas[9] = fs.attrExt1;
608         datas[10] = fs.attrExt2;
609         datas[11] = fs.attrExt3;
610     }
611 
612     /// @dev Get tokenIds and flags by owner
613     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
614         require(_owner != address(0));
615         uint256[] storage fsArray = ownerToFashionArray[_owner];
616         uint256 length = fsArray.length;
617         tokens = new uint256[](length);
618         flags = new uint32[](length);
619         for (uint256 i = 0; i < length; ++i) {
620             tokens[i] = fsArray[i];
621             Fashion storage fs = fashionArray[fsArray[i]];
622             flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);
623         }
624     }
625 
626     /// @dev WAR token info returned based on Token ID transfered (64 at most)
627     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
628         uint256 length = _tokens.length;
629         require(length <= 64);
630         attrs = new uint16[](length * 11);
631         uint256 tokenId;
632         uint256 index;
633         for (uint256 i = 0; i < length; ++i) {
634             tokenId = _tokens[i];
635             if (fashionIdToOwner[tokenId] != address(0)) {
636                 index = i * 11;
637                 Fashion storage fs = fashionArray[tokenId];
638                 attrs[index] = fs.health;
639                 attrs[index + 1] = fs.atkMin;
640                 attrs[index + 2] = fs.atkMax;
641                 attrs[index + 3] = fs.defence;
642                 attrs[index + 4] = fs.crit;
643                 attrs[index + 5] = fs.isPercent;
644                 attrs[index + 6] = fs.attrExt1;
645                 attrs[index + 7] = fs.attrExt2;
646                 attrs[index + 8] = fs.attrExt3;
647             }   
648         }
649     }
650 }
651 
652 contract ActionAuction is AccessNoWithdraw {
653     using SafeMath for uint256; 
654 
655     event AuctionCreate(uint256 indexed index, address indexed seller, uint256 tokenId);
656     event AuctionSold(uint256 indexed index, address indexed seller, address indexed buyer, uint256 tokenId, uint256 price);
657     event AuctionCancel(uint256 indexed index, address indexed seller, uint256 tokenId);
658     event AuctionPriceChange(uint256 indexed index, address indexed seller, uint256 tokenId, uint64 newGwei);
659 
660     struct Auction {
661         address seller;     // Current owner
662         uint64 tokenId;     // WarToken Id
663         uint64 price;       // Sale price(Gwei)
664         uint64 tmStart;     // Sale start time(unixtime)
665         uint64 tmSell;      // Sale out time(unixtime)
666     }
667 
668     /// @dev Auction Array
669     Auction[] public auctionArray;
670     /// @dev Latest auction index by tokenId
671     mapping(uint256 => uint256) public latestAction;
672     /// @dev WarToken(NFT) contract address
673     WarToken public tokenContract;
674     /// @dev DataEquip contract address
675     IDataEquip public equipContract;
676     /// @dev EOST token address
677     IEOMarketToken public eostContract;
678     /// @dev Plat Auction address
679     IDataAuction public platAuction;
680     /// @dev prizepool contact address
681     address public poolContract;
682     /// @dev share balance
683     mapping(address => uint256) public shareBalances;
684     /// @dev share holder withdraw history
685     mapping(address => uint256) public shareHistory;
686     /// @dev Auction fee have not alloted
687     uint256 public accumulateFee;
688     /// @dev Binary search start index
689     uint64 public searchStartIndex;
690     /// @dev Auction order lifetime(sec)
691     uint64 public auctionDuration = 172800;
692     /// @dev Trade sum(Gwei)
693     uint64 public auctionSumGwei;
694 
695     function ActionAuction(address _nftAddr) public {
696         addrAdmin = msg.sender;
697         addrService = msg.sender;
698         addrFinance = msg.sender;
699 
700         tokenContract = WarToken(_nftAddr);
701 
702         Auction memory order = Auction(0, 0, 0, 1, 1);
703         auctionArray.push(order);
704     }
705 
706     function() external {}
707 
708     function setDataEquip(address _addr) external onlyAdmin {
709         require(_addr != address(0));
710         equipContract = IDataEquip(_addr);
711     }
712 
713     function setEOMarketToken(address _addr) external onlyAdmin {
714         require(_addr != address(0));
715         eostContract = IEOMarketToken(_addr);
716     }
717 
718     function setPlatAuction(address _addr) external onlyAdmin {
719         require(_addr != address(0));
720         platAuction = IDataAuction(_addr);
721     }
722 
723     function setPrizePool(address _addr) external onlyAdmin {
724         require(_addr != address(0));
725         poolContract = _addr;
726     }
727 
728     function setDuration(uint64 _duration) external onlyAdmin {
729         require(_duration >= 300 && _duration <= 8640000);
730         auctionDuration = _duration;
731     }
732 
733     function newAuction(uint256 _tokenId, uint64 _priceGwei) 
734         external
735         whenNotPaused
736     {
737         require(tokenContract.ownerOf(_tokenId) == msg.sender);
738         require(!equipContract.isEquiped(msg.sender, _tokenId));
739         require(_priceGwei >= 1000000 && _priceGwei <= 999000000000);
740 
741         uint16[12] memory fashion = tokenContract.getFashion(_tokenId);
742         require(fashion[1] > 1);
743 
744         uint64 tmNow = uint64(block.timestamp);
745         uint256 lastIndex = latestAction[_tokenId];
746         // still on selling?
747         if (lastIndex > 0) {
748             Auction storage oldOrder = auctionArray[lastIndex];
749             require((oldOrder.tmStart + auctionDuration) <= tmNow || oldOrder.tmSell > 0);
750         }
751 
752         if (address(platAuction) != address(0)) {
753             require(!platAuction.isOnSale(_tokenId));
754         }
755         
756         uint256 newAuctionIndex = auctionArray.length;
757         auctionArray.length += 1;
758         Auction storage order = auctionArray[newAuctionIndex];
759         order.seller = msg.sender;
760         order.tokenId = uint64(_tokenId);
761         order.price = _priceGwei;
762         uint64 lastActionStart = auctionArray[newAuctionIndex - 1].tmStart;
763         // Make the arry is sorted by tmStart
764         if (tmNow >= lastActionStart) {
765             order.tmStart = tmNow;
766         } else {
767             order.tmStart = lastActionStart;
768         }
769         
770         latestAction[_tokenId] = newAuctionIndex;
771 
772         AuctionCreate(newAuctionIndex, msg.sender, _tokenId);
773     }
774 
775     function cancelAuction(uint256 _tokenId) external whenNotPaused {
776         require(tokenContract.ownerOf(_tokenId) == msg.sender);
777         uint256 lastIndex = latestAction[_tokenId];
778         require(lastIndex > 0);
779         Auction storage order = auctionArray[lastIndex];
780         require(order.seller == msg.sender);
781         require(order.tmSell == 0);
782         order.tmSell = 1;
783         AuctionCancel(lastIndex, msg.sender, _tokenId);
784     }
785 
786     function changePrice(uint256 _tokenId, uint64 _priceGwei) external whenNotPaused {
787         require(tokenContract.ownerOf(_tokenId) == msg.sender);
788         uint256 lastIndex = latestAction[_tokenId];
789         require(lastIndex > 0);
790         Auction storage order = auctionArray[lastIndex];
791         require(order.seller == msg.sender);
792         require(order.tmSell == 0);
793 
794         uint64 tmNow = uint64(block.timestamp);
795         require(order.tmStart + auctionDuration > tmNow);
796         
797         require(_priceGwei >= 1000000 && _priceGwei <= 999000000000);
798         order.price = _priceGwei;
799 
800         AuctionPriceChange(lastIndex, msg.sender, _tokenId, _priceGwei);
801     }
802 
803     function _shareDevCut(uint256 val) internal {
804         uint256 shareVal = val.mul(6).div(10);
805         uint256 leftVal = val.sub(shareVal);
806         uint256 devVal = leftVal.div(2);
807         accumulateFee = accumulateFee.add(shareVal);
808         addrFinance.transfer(devVal);
809         if (poolContract != address(0)) {
810             poolContract.transfer(leftVal.sub(devVal));
811         } else {
812             accumulateFee = accumulateFee.add(leftVal.sub(devVal));
813         }
814     }
815 
816     function bid(uint256 _tokenId) 
817         external
818         payable
819         whenNotPaused
820     {
821         uint256 lastIndex = latestAction[_tokenId];
822         require(lastIndex > 0);
823         Auction storage order = auctionArray[lastIndex];
824 
825         uint64 tmNow = uint64(block.timestamp);
826         require(order.tmStart + auctionDuration > tmNow);
827         require(order.tmSell == 0);
828 
829         address realOwner = tokenContract.ownerOf(_tokenId);
830         require(realOwner == order.seller);
831         require(realOwner != msg.sender);
832 
833         uint256 price = order.price * 1000000000;
834         require(msg.value == price);
835 
836         order.tmSell = tmNow;
837         auctionSumGwei += order.price;
838         uint256 sellerProceeds = price.mul(9).div(10);
839         uint256 devCut = price.sub(sellerProceeds);
840        
841         tokenContract.safeTransferByContract(_tokenId, msg.sender);
842 
843         _shareDevCut(devCut);
844         realOwner.transfer(sellerProceeds);
845 
846         AuctionSold(lastIndex, realOwner, msg.sender, _tokenId, price);
847     }
848 
849     function updateShares() 
850         external
851         /*onlyManager*/
852     {
853         uint256 currentFee = accumulateFee;
854         var (addrArray, amountArray, soldAmount) = eostContract.getShareholders();  
855         require(soldAmount > 0); 
856         uint256 avg = currentFee.div(soldAmount);
857         uint256 shareVal;
858         address addrZero = address(0);
859         address addrHolder;
860         for (uint64 i = 0; i < 100; ++i) {
861             addrHolder = addrArray[i];
862             if (addrHolder == addrZero) {
863                 break;
864             }
865             shareVal = avg.mul(amountArray[i]);
866             uint256 oldBalance = shareBalances[addrHolder];
867             shareBalances[addrHolder] = oldBalance.add(shareVal);
868             currentFee = currentFee.sub(shareVal);
869         }
870 
871         assert(currentFee <= 100);
872         accumulateFee = currentFee;
873     }
874 
875     /// @dev For EOST holders withdraw 
876     function shareWithdraw() external {
877         address holder = msg.sender;
878         uint256 sBalance = shareBalances[holder];
879         require (sBalance > 0);
880         assert (sBalance <= this.balance);
881         shareBalances[holder] = 0;          // Must before transfer
882         shareHistory[holder] += sBalance;
883         holder.transfer(sBalance);
884     }
885 
886     /// @dev deposit bonus for EOST holders
887     function depositBonus () 
888         external 
889         payable 
890     {
891         require (msg.value > 0);
892         accumulateFee.add(msg.value);
893     }
894 
895     function _getStartIndex(uint64 startIndex) internal view returns(uint64) {
896         // use low_bound
897         uint64 tmFind = uint64(block.timestamp) - auctionDuration;
898         uint64 first = startIndex;
899         uint64 middle;
900         uint64 half;
901         uint64 len = uint64(auctionArray.length - startIndex);
902 
903         while(len > 0) {
904             half = len / 2;
905             middle = first + half;
906             if (auctionArray[middle].tmStart < tmFind) {
907                 first = middle + 1;
908                 len = len - half - 1;
909             } else {
910                 len = half;
911             }
912         }
913         return first;
914     }
915 
916     function resetSearchStartIndex () internal {
917         searchStartIndex = _getStartIndex(searchStartIndex);
918     }
919     
920     function _getAuctionIdArray(uint64 _startIndex, uint64 _count) 
921         internal 
922         view 
923         returns(uint64[])
924     {
925         uint64 tmFind = uint64(block.timestamp) - auctionDuration;
926         uint64 start = _startIndex > 0 ? _startIndex : _getStartIndex(0);
927         uint256 length = auctionArray.length;
928         uint256 maxLen = _count > 0 ? _count : length - start;
929         if (maxLen == 0) {
930             maxLen = 1;
931         }
932         uint64[] memory auctionIdArray = new uint64[](maxLen);
933         uint64 counter = 0;
934         for (uint64 i = start; i < length; ++i) {
935             if (auctionArray[i].tmStart > tmFind && auctionArray[i].tmSell == 0) {
936                 auctionIdArray[counter++] = i;
937                 if (_count > 0 && counter == _count) {
938                     break;
939                 }
940             }
941         }
942         if (counter == auctionIdArray.length) {
943             return auctionIdArray;
944         } else {
945             uint64[] memory realIdArray = new uint64[](counter);
946             for (uint256 j = 0; j < counter; ++j) {
947                 realIdArray[j] = auctionIdArray[j];
948             }
949             return realIdArray;
950         }
951     } 
952 
953     function getAuctionIdArray(uint64 _startIndex, uint64 _count) external view returns(uint64[]) {
954         return _getAuctionIdArray(_startIndex, _count);
955     }
956     
957     function getAuctionArray(uint64 _startIndex, uint64 _count) 
958         external 
959         view 
960         returns(
961         uint64[] auctionIdArray, 
962         address[] sellerArray, 
963         uint64[] tokenIdArray, 
964         uint64[] priceArray, 
965         uint64[] tmStartArray)
966     {
967         auctionIdArray = _getAuctionIdArray(_startIndex, _count);
968         uint256 length = auctionIdArray.length;
969         sellerArray = new address[](length);
970         tokenIdArray = new uint64[](length);
971         priceArray = new uint64[](length);
972         tmStartArray = new uint64[](length);
973         
974         for (uint256 i = 0; i < length; ++i) {
975             Auction storage tmpAuction = auctionArray[auctionIdArray[i]];
976             sellerArray[i] = tmpAuction.seller;
977             tokenIdArray[i] = tmpAuction.tokenId;
978             priceArray[i] = tmpAuction.price;
979             tmStartArray[i] = tmpAuction.tmStart; 
980         }
981     } 
982 
983     function getAuction(uint64 auctionId) external view returns(
984         address seller,
985         uint64 tokenId,
986         uint64 price,
987         uint64 tmStart,
988         uint64 tmSell) 
989     {
990         require (auctionId < auctionArray.length); 
991         Auction memory auction = auctionArray[auctionId];
992         seller = auction.seller;
993         tokenId = auction.tokenId;
994         price = auction.price;
995         tmStart = auction.tmStart;
996         tmSell = auction.tmSell;
997     }
998 
999     function getAuctionTotal() external view returns(uint256) {
1000         return auctionArray.length - 1;
1001     }
1002 
1003     function getStartIndex(uint64 _startIndex) external view returns(uint256) {
1004         require (_startIndex < auctionArray.length);
1005         return _getStartIndex(_startIndex);
1006     }
1007 
1008     function isOnSale(uint256 _tokenId) external view returns(bool) {
1009         uint256 lastIndex = latestAction[_tokenId];
1010         if (lastIndex > 0) {
1011             Auction storage order = auctionArray[lastIndex];
1012             uint64 tmNow = uint64(block.timestamp);
1013             if ((order.tmStart + auctionDuration > tmNow) && order.tmSell == 0) {
1014                 return true;
1015             }
1016         }
1017         return false;
1018     }
1019 
1020     function isOnSaleAny2(uint256 _tokenId1, uint256 _tokenId2) external view returns(bool) {
1021         uint256 lastIndex = latestAction[_tokenId1];
1022         uint64 tmNow = uint64(block.timestamp);
1023         if (lastIndex > 0) {
1024             Auction storage order1 = auctionArray[lastIndex];
1025             if ((order1.tmStart + auctionDuration > tmNow) && order1.tmSell == 0) {
1026                 return true;
1027             }
1028         }
1029         lastIndex = latestAction[_tokenId2];
1030         if (lastIndex > 0) {
1031             Auction storage order2 = auctionArray[lastIndex];
1032             if ((order2.tmStart + auctionDuration > tmNow) && order2.tmSell == 0) {
1033                 return true;
1034             }
1035         }
1036         return false;
1037     }
1038 
1039     function isOnSaleAny3(uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool) {
1040         uint256 lastIndex = latestAction[_tokenId1];
1041         uint64 tmNow = uint64(block.timestamp);
1042         if (lastIndex > 0) {
1043             Auction storage order1 = auctionArray[lastIndex];
1044             if ((order1.tmStart + auctionDuration > tmNow) && order1.tmSell == 0) {
1045                 return true;
1046             }
1047         }
1048         lastIndex = latestAction[_tokenId2];
1049         if (lastIndex > 0) {
1050             Auction storage order2 = auctionArray[lastIndex];
1051             if ((order2.tmStart + auctionDuration > tmNow) && order2.tmSell == 0) {
1052                 return true;
1053             }
1054         }
1055         lastIndex = latestAction[_tokenId3];
1056         if (lastIndex > 0) {
1057             Auction storage order3 = auctionArray[lastIndex];
1058             if ((order3.tmStart + auctionDuration > tmNow) && order3.tmSell == 0) {
1059                 return true;
1060             }
1061         }
1062         return false;
1063     }
1064 }