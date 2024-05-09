1 /* ==================================================================== */
2 /* Copyright (c) 2018 The CryptoRacing Project.  All rights reserved.
3 /* 
4 /*   The first idle car race game of blockchain                 
5 /* ==================================================================== */
6 
7 pragma solidity ^0.4.20;
8 
9 /// @title ERC-165 Standard Interface Detection
10 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
11 interface ERC165 {
12     function supportsInterface(bytes4 interfaceID) external view returns (bool);
13 }
14 
15 /// @title ERC-721 Non-Fungible Token Standard
16 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
17 contract ERC721 is ERC165 {
18     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
19     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
20     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
21     function balanceOf(address _owner) external view returns (uint256);
22     function ownerOf(uint256 _tokenId) external view returns (address);
23     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
24     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
25     function transferFrom(address _from, address _to, uint256 _tokenId) external;
26     function approve(address _approved, uint256 _tokenId) external;
27     function setApprovalForAll(address _operator, bool _approved) external;
28     function getApproved(uint256 _tokenId) external view returns (address);
29     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
30 }
31 
32 /// @title ERC-721 Non-Fungible Token Standard
33 interface ERC721TokenReceiver {
34 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
35 }
36 
37 contract AccessAdmin {
38     bool public isPaused = false;
39     address public addrAdmin;  
40 
41     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
42 
43     function AccessAdmin() public {
44         addrAdmin = msg.sender;
45     }  
46 
47 
48     modifier onlyAdmin() {
49         require(msg.sender == addrAdmin);
50         _;
51     }
52 
53     modifier whenNotPaused() {
54         require(!isPaused);
55         _;
56     }
57 
58     modifier whenPaused {
59         require(isPaused);
60         _;
61     }
62 
63     function setAdmin(address _newAdmin) external onlyAdmin {
64         require(_newAdmin != address(0));
65         AdminTransferred(addrAdmin, _newAdmin);
66         addrAdmin = _newAdmin;
67     }
68 
69     function doPause() external onlyAdmin whenNotPaused {
70         isPaused = true;
71     }
72 
73     function doUnpause() external onlyAdmin whenPaused {
74         isPaused = false;
75     }
76 }
77 
78 contract AccessService is AccessAdmin {
79     address public addrService;
80     address public addrFinance;
81 
82     modifier onlyService() {
83         require(msg.sender == addrService);
84         _;
85     }
86 
87     modifier onlyFinance() {
88         require(msg.sender == addrFinance);
89         _;
90     }
91 
92     function setService(address _newService) external {
93         require(msg.sender == addrService || msg.sender == addrAdmin);
94         require(_newService != address(0));
95         addrService = _newService;
96     }
97 
98     function setFinance(address _newFinance) external {
99         require(msg.sender == addrFinance || msg.sender == addrAdmin);
100         require(_newFinance != address(0));
101         addrFinance = _newFinance;
102     }
103 
104     function withdraw(address _target, uint256 _amount) 
105         external 
106     {
107         require(msg.sender == addrFinance || msg.sender == addrAdmin);
108         require(_amount > 0);
109         address receiver = _target == address(0) ? addrFinance : _target;
110         uint256 balance = this.balance;
111         if (_amount < balance) {
112             receiver.transfer(_amount);
113         } else {
114             receiver.transfer(this.balance);
115         }      
116     }
117 }
118 
119 
120 interface IDataEquip {
121     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
122     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
123     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
124 }
125 
126 
127 interface IRaceCoin {
128     function addTotalEtherPool(uint256 amount) external;
129     function addPlayerToList(address player) external;
130     function increasePlayersAttribute(address player, uint16[13] param) external;
131     function reducePlayersAttribute(address player, uint16[13] param) external;
132 }
133 
134 contract Random {
135     uint256 _seed;
136 
137     function _rand() internal returns (uint256) {
138         _seed = uint256(keccak256(_seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
139         return _seed;
140     }
141 
142     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
143         return uint256(keccak256(_outSeed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
144     }
145 }
146 
147 /**
148  * @title SafeMath
149  * @dev Math operations with safety checks that throw on error
150  */
151 library SafeMath {
152     /**
153     * @dev Multiplies two numbers, throws on overflow.
154     */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         if (a == 0) {
157             return 0;
158         }
159         uint256 c = a * b;
160         assert(c / a == b);
161         return c;
162     }
163 
164     /**
165     * @dev Integer division of two numbers, truncating the quotient.
166     */
167     function div(uint256 a, uint256 b) internal pure returns (uint256) {
168         // assert(b > 0); // Solidity automatically throws when dividing by 0
169         uint256 c = a / b;
170         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
171         return c;
172     }
173 
174     /**
175     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
176     */
177     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
178         assert(b <= a);
179         return a - b;
180     }
181 
182     /**
183     * @dev Adds two numbers, throws on overflow.
184     */
185     function add(uint256 a, uint256 b) internal pure returns (uint256) {
186         uint256 c = a + b;
187         assert(c >= a);
188         return c;
189     }
190 }
191 
192 contract RaceToken is ERC721, AccessAdmin {
193     /// @dev The equipment info
194     struct Fashion {
195         uint16 equipmentId;             // 0  Equipment ID
196         uint16 quality;     	        // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
197         uint16 pos;         	        // 2  Slots: 1 Engine/2 Turbine/3 BodySystem/4 Pipe/5 Suspension/6 NO2/7 Tyre/8 Transmission/9 Car
198         uint16 production;    	        // 3  Race bonus productivity
199         uint16 attack;	                // 4  Attack
200         uint16 defense;                 // 5  Defense
201         uint16 plunder;     	        // 6  Plunder
202         uint16 productionMultiplier;    // 7  Percent value
203         uint16 attackMultiplier;     	// 8  Percent value
204         uint16 defenseMultiplier;     	// 9  Percent value
205         uint16 plunderMultiplier;     	// 10 Percent value
206         uint16 level;       	        // 11 level
207         uint16 isPercent;   	        // 12  Percent value
208     }
209 
210     /// @dev All equipments tokenArray (not exceeding 2^32-1)
211     Fashion[] public fashionArray;
212 
213     /// @dev Amount of tokens destroyed
214     uint256 destroyFashionCount;
215 
216     /// @dev Equipment token ID belong to owner address
217     mapping (uint256 => address) fashionIdToOwner;
218 
219     /// @dev Equipments owner by the owner (array)
220     mapping (address => uint256[]) ownerToFashionArray;
221 
222     /// @dev Equipment token ID search in owner array
223     mapping (uint256 => uint256) fashionIdToOwnerIndex;
224 
225     /// @dev The authorized address for each Race
226     mapping (uint256 => address) fashionIdToApprovals;
227 
228     /// @dev The authorized operators for each address
229     mapping (address => mapping (address => bool)) operatorToApprovals;
230 
231     /// @dev Trust contract
232     mapping (address => bool) actionContracts;
233 
234 	
235     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
236         actionContracts[_actionAddr] = _useful;
237     }
238 
239     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
240         return actionContracts[_actionAddr];
241     }
242 
243     /// @dev This emits when the approved address for an Race is changed or reaffirmed.
244     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
245 
246     /// @dev This emits when an operator is enabled or disabled for an owner.
247     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
248 
249     /// @dev This emits when the equipment ownership changed 
250     event Transfer(address indexed from, address indexed to, uint256 tokenId);
251 
252     /// @dev This emits when the equipment created
253     event CreateFashion(address indexed owner, uint256 tokenId, uint16 equipmentId, uint16 quality, uint16 pos, uint16 level, uint16 createType);
254 
255     /// @dev This emits when the equipment's attributes changed
256     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
257 
258     /// @dev This emits when the equipment destroyed
259     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
260     
261     function RaceToken() public {
262         addrAdmin = msg.sender;
263         fashionArray.length += 1;
264     }
265 
266     // modifier
267     /// @dev Check if token ID is valid
268     modifier isValidToken(uint256 _tokenId) {
269         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
270         require(fashionIdToOwner[_tokenId] != address(0)); 
271         _;
272     }
273 
274     modifier canTransfer(uint256 _tokenId) {
275         address owner = fashionIdToOwner[_tokenId];
276         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
277         _;
278     }
279 
280     // ERC721
281     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
282         // ERC165 || ERC721 || ERC165^ERC721
283         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
284     }
285         
286     function name() public pure returns(string) {
287         return "Race Token";
288     }
289 
290     function symbol() public pure returns(string) {
291         return "Race";
292     }
293 
294     /// @dev Search for token quantity address
295     /// @param _owner Address that needs to be searched
296     /// @return Returns token quantity
297     function balanceOf(address _owner) external view returns(uint256) {
298         require(_owner != address(0));
299         return ownerToFashionArray[_owner].length;
300     }
301 
302     /// @dev Find the owner of an Race
303     /// @param _tokenId The tokenId of Race
304     /// @return Give The address of the owner of this Race
305     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
306         return fashionIdToOwner[_tokenId];
307     }
308 
309     /// @dev Transfers the ownership of an Race from one address to another address
310     /// @param _from The current owner of the Race
311     /// @param _to The new owner
312     /// @param _tokenId The Race to transfer
313     /// @param data Additional data with no specified format, sent in call to `_to`
314     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
315         external
316         whenNotPaused
317     {
318         _safeTransferFrom(_from, _to, _tokenId, data);
319     }
320 
321     /// @dev Transfers the ownership of an Race from one address to another address
322     /// @param _from The current owner of the Race
323     /// @param _to The new owner
324     /// @param _tokenId The Race to transfer
325     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
326         external
327         whenNotPaused
328     {
329         _safeTransferFrom(_from, _to, _tokenId, "");
330     }
331 
332     /// @dev Transfer ownership of an Race, '_to' must be a vaild address, or the Race will lost
333     /// @param _from The current owner of the Race
334     /// @param _to The new owner
335     /// @param _tokenId The Race to transfer
336     function transferFrom(address _from, address _to, uint256 _tokenId)
337         external
338         whenNotPaused
339         isValidToken(_tokenId)
340         canTransfer(_tokenId)
341     {
342         address owner = fashionIdToOwner[_tokenId];
343         require(owner != address(0));
344         require(_to != address(0));
345         require(owner == _from);
346         
347         _transfer(_from, _to, _tokenId);
348     }
349 
350     /// @dev Set or reaffirm the approved address for an Race
351     /// @param _approved The new approved Race controller
352     /// @param _tokenId The Race to approve
353     function approve(address _approved, uint256 _tokenId)
354         external
355         whenNotPaused
356     {
357         address owner = fashionIdToOwner[_tokenId];
358         require(owner != address(0));
359         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
360 
361         fashionIdToApprovals[_tokenId] = _approved;
362         Approval(owner, _approved, _tokenId);
363     }
364 
365     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
366     /// @param _operator Address to add to the set of authorized operators.
367     /// @param _approved True if the operators is approved, false to revoke approval
368     function setApprovalForAll(address _operator, bool _approved) 
369         external 
370         whenNotPaused
371     {
372         operatorToApprovals[msg.sender][_operator] = _approved;
373         ApprovalForAll(msg.sender, _operator, _approved);
374     }
375 
376     /// @dev Get the approved address for a single Race
377     /// @param _tokenId The Race to find the approved address for
378     /// @return The approved address for this Race, or the zero address if there is none
379     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
380         return fashionIdToApprovals[_tokenId];
381     }
382 
383     /// @dev Query if an address is an authorized operator for another address
384     /// @param _owner The address that owns the Races
385     /// @param _operator The address that acts on behalf of the owner
386     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
387     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
388         return operatorToApprovals[_owner][_operator];
389     }
390 
391     /// @dev Count Races tracked by this contract
392     /// @return A count of valid Races tracked by this contract, where each one of
393     ///  them has an assigned and queryable owner not equal to the zero address
394     function totalSupply() external view returns (uint256) {
395         return fashionArray.length - destroyFashionCount - 1;
396     }
397 
398     /// @dev Do the real transfer with out any condition checking
399     /// @param _from The old owner of this Race(If created: 0x0)
400     /// @param _to The new owner of this Race 
401     /// @param _tokenId The tokenId of the Race
402     function _transfer(address _from, address _to, uint256 _tokenId) internal {
403         if (_from != address(0)) {
404             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
405             uint256[] storage fsArray = ownerToFashionArray[_from];
406             require(fsArray[indexFrom] == _tokenId);
407 
408             // If the Race is not the element of array, change it to with the last
409             if (indexFrom != fsArray.length - 1) {
410                 uint256 lastTokenId = fsArray[fsArray.length - 1];
411                 fsArray[indexFrom] = lastTokenId; 
412                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
413             }
414             fsArray.length -= 1; 
415             
416             if (fashionIdToApprovals[_tokenId] != address(0)) {
417                 delete fashionIdToApprovals[_tokenId];
418             }      
419         }
420 
421         // Give the Race to '_to'
422         fashionIdToOwner[_tokenId] = _to;
423         ownerToFashionArray[_to].push(_tokenId);
424         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
425         
426         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
427     }
428 
429     /// @dev Actually perform the safeTransferFrom
430     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
431         internal
432         isValidToken(_tokenId) 
433         canTransfer(_tokenId)
434     {
435         address owner = fashionIdToOwner[_tokenId];
436         require(owner != address(0));
437         require(_to != address(0));
438         require(owner == _from);
439         
440         _transfer(_from, _to, _tokenId);
441 
442         // Do the callback after everything is done to avoid reentrancy attack
443         uint256 codeSize;
444         assembly { codeSize := extcodesize(_to) }
445         if (codeSize == 0) {
446             return;
447         }
448         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
449         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
450         require(retval == 0xf0b9e5ba);
451     }
452 
453     //----------------------------------------------------------------------------------------------------------
454 
455     /// @dev Equipment creation
456     /// @param _owner Owner of the equipment created
457     /// @param _attrs Attributes of the equipment created
458     /// @return Token ID of the equipment created
459     function createFashion(address _owner, uint16[13] _attrs, uint16 _createType) 
460         external 
461         whenNotPaused
462         returns(uint256)
463     {
464         require(actionContracts[msg.sender]);
465         require(_owner != address(0));
466 
467         uint256 newFashionId = fashionArray.length;
468         require(newFashionId < 4294967296);
469 
470         fashionArray.length += 1;
471         Fashion storage fs = fashionArray[newFashionId];
472         fs.equipmentId = _attrs[0];
473         fs.quality = _attrs[1];
474         fs.pos = _attrs[2];
475         if (_attrs[3] != 0) {
476             fs.production = _attrs[3];
477         }
478         
479         if (_attrs[4] != 0) {
480             fs.attack = _attrs[4];
481         }
482 		
483 		if (_attrs[5] != 0) {
484             fs.defense = _attrs[5];
485         }
486        
487         if (_attrs[6] != 0) {
488             fs.plunder = _attrs[6];
489         }
490         
491         if (_attrs[7] != 0) {
492             fs.productionMultiplier = _attrs[7];
493         }
494 
495         if (_attrs[8] != 0) {
496             fs.attackMultiplier = _attrs[8];
497         }
498 
499         if (_attrs[9] != 0) {
500             fs.defenseMultiplier = _attrs[9];
501         }
502 
503         if (_attrs[10] != 0) {
504             fs.plunderMultiplier = _attrs[10];
505         }
506 
507         if (_attrs[11] != 0) {
508             fs.level = _attrs[11];
509         }
510 
511         if (_attrs[12] != 0) {
512             fs.isPercent = _attrs[12];
513         }
514         
515         _transfer(0, _owner, newFashionId);
516         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _attrs[11], _createType);
517         return newFashionId;
518     }
519 
520     /// @dev One specific attribute of the equipment modified
521     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
522         if (_index == 3) {
523             _fs.production = _val;
524         } else if(_index == 4) {
525             _fs.attack = _val;
526         } else if(_index == 5) {
527             _fs.defense = _val;
528         } else if(_index == 6) {
529             _fs.plunder = _val;
530         }else if(_index == 7) {
531             _fs.productionMultiplier = _val;
532         }else if(_index == 8) {
533             _fs.attackMultiplier = _val;
534         }else if(_index == 9) {
535             _fs.defenseMultiplier = _val;
536         }else if(_index == 10) {
537             _fs.plunderMultiplier = _val;
538         } else if(_index == 11) {
539             _fs.level = _val;
540         } 
541        
542     }
543 
544     /// @dev Equiment attributes modified (max 4 stats modified)
545     /// @param _tokenId Equipment Token ID
546     /// @param _idxArray Stats order that must be modified
547     /// @param _params Stat value that must be modified
548     /// @param _changeType Modification type such as enhance, socket, etc.
549     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
550         external 
551         whenNotPaused
552         isValidToken(_tokenId) 
553     {
554         require(actionContracts[msg.sender]);
555 
556         Fashion storage fs = fashionArray[_tokenId];
557         if (_idxArray[0] > 0) {
558             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
559         }
560 
561         if (_idxArray[1] > 0) {
562             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
563         }
564 
565         if (_idxArray[2] > 0) {
566             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
567         }
568 
569         if (_idxArray[3] > 0) {
570             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
571         }
572 
573         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
574     }
575 
576     /// @dev Equipment destruction
577     /// @param _tokenId Equipment Token ID
578     /// @param _deleteType Destruction type, such as craft
579     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
580         external 
581         whenNotPaused
582         isValidToken(_tokenId) 
583     {
584         require(actionContracts[msg.sender]);
585 
586         address _from = fashionIdToOwner[_tokenId];
587         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
588         uint256[] storage fsArray = ownerToFashionArray[_from]; 
589         require(fsArray[indexFrom] == _tokenId);
590 
591         if (indexFrom != fsArray.length - 1) {
592             uint256 lastTokenId = fsArray[fsArray.length - 1];
593             fsArray[indexFrom] = lastTokenId; 
594             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
595         }
596         fsArray.length -= 1; 
597 
598         fashionIdToOwner[_tokenId] = address(0);
599         delete fashionIdToOwnerIndex[_tokenId];
600         destroyFashionCount += 1;
601 
602         Transfer(_from, 0, _tokenId);
603 
604         DeleteFashion(_from, _tokenId, _deleteType);
605     }
606 
607     /// @dev Safe transfer by trust contracts
608     function safeTransferByContract(uint256 _tokenId, address _to) 
609         external
610         whenNotPaused
611     {
612         require(actionContracts[msg.sender]);
613 
614         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
615         address owner = fashionIdToOwner[_tokenId];
616         require(owner != address(0));
617         require(_to != address(0));
618         require(owner != _to);
619 
620         _transfer(owner, _to, _tokenId);
621     }
622 
623     //----------------------------------------------------------------------------------------------------------
624 
625     /// @dev Get fashion attrs by tokenId front
626     function getFashionFront(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint256[14] datas) {
627         Fashion storage fs = fashionArray[_tokenId];
628         datas[0] = fs.equipmentId;
629         datas[1] = fs.quality;
630         datas[2] = fs.pos;
631         datas[3] = fs.production;
632         datas[4] = fs.attack;
633         datas[5] = fs.defense;
634         datas[6] = fs.plunder;
635         datas[7] = fs.productionMultiplier;
636         datas[8] = fs.attackMultiplier;
637         datas[9] = fs.defenseMultiplier;
638         datas[10] = fs.plunderMultiplier;
639         datas[11] = fs.level;
640         datas[12] = fs.isPercent; 
641         datas[13] = _tokenId;      
642     }
643 
644     /// @dev Get fashion attrs by tokenId back
645     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[13] datas) {
646         Fashion storage fs = fashionArray[_tokenId];
647         datas[0] = fs.equipmentId;
648         datas[1] = fs.quality;
649         datas[2] = fs.pos;
650         datas[3] = fs.production;
651         datas[4] = fs.attack;
652         datas[5] = fs.defense;
653         datas[6] = fs.plunder;
654         datas[7] = fs.productionMultiplier;
655         datas[8] = fs.attackMultiplier;
656         datas[9] = fs.defenseMultiplier;
657         datas[10] = fs.plunderMultiplier;
658         datas[11] = fs.level;
659         datas[12] = fs.isPercent;      
660     }
661 
662 
663     /// @dev Get tokenIds and flags by owner
664     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
665         require(_owner != address(0));
666         uint256[] storage fsArray = ownerToFashionArray[_owner];
667         uint256 length = fsArray.length;
668         tokens = new uint256[](length);
669         flags = new uint32[](length);
670         for (uint256 i = 0; i < length; ++i) {
671             tokens[i] = fsArray[i];
672             Fashion storage fs = fashionArray[fsArray[i]];
673             flags[i] = uint32(uint32(fs.equipmentId) * 10000 + uint32(fs.quality) * 100 + fs.pos);
674         }
675     }
676 
677 
678     /// @dev Race token info returned based on Token ID transfered (64 at most)
679     function getFashionsAttrs(uint256[] _tokens) external view returns(uint256[] attrs) {
680         uint256 length = _tokens.length;
681         attrs = new uint256[](length * 14);
682         uint256 tokenId;
683         uint256 index;
684         for (uint256 i = 0; i < length; ++i) {
685             tokenId = _tokens[i];
686             if (fashionIdToOwner[tokenId] != address(0)) {
687                 index = i * 14;
688                 Fashion storage fs = fashionArray[tokenId];
689                 attrs[index]     = fs.equipmentId;
690 				attrs[index + 1] = fs.quality;
691                 attrs[index + 2] = fs.pos;
692                 attrs[index + 3] = fs.production;
693                 attrs[index + 4] = fs.attack;
694                 attrs[index + 5] = fs.defense;
695                 attrs[index + 6] = fs.plunder;
696                 attrs[index + 7] = fs.productionMultiplier;
697                 attrs[index + 8] = fs.attackMultiplier;
698                 attrs[index + 9] = fs.defenseMultiplier;
699                 attrs[index + 10] = fs.plunderMultiplier;
700                 attrs[index + 11] = fs.level;
701                 attrs[index + 12] = fs.isPercent; 
702                 attrs[index + 13] = tokenId;  
703             }   
704         }
705     }
706 }
707 
708 
709 
710 contract DataEquip is AccessService, IDataEquip {
711     event EquipChanged(address indexed _target);
712 
713 
714     /// @dev RaceToken(NFT) contract address
715     RaceToken public tokenContract;
716 
717     IRaceCoin public raceCoinContract;
718 
719     mapping (address => uint256[]) public slotlist;
720 
721     mapping (uint256 => uint256) public carSlot;
722 
723     mapping (uint256 => uint256) public slotEngine;
724     mapping (uint256 => uint256) public slotTurbine;
725     mapping (uint256 => uint256) public slotBodySystem;
726     mapping (uint256 => uint256) public slotPipe;
727     mapping (uint256 => uint256) public slotSuspension;
728     mapping (uint256 => uint256) public slotNO2;
729     mapping (uint256 => uint256) public slotTyre;
730     mapping (uint256 => uint256) public slotTransmission;
731  
732 
733     function DataEquip(address _nftTokenAddr) public {
734         addrAdmin = msg.sender;
735         addrService = msg.sender;
736         addrFinance = msg.sender;
737 
738         tokenContract = RaceToken(_nftTokenAddr);
739     }
740 
741     //Set up tournament bonus address
742     function setRaceCoin(address _addr) external onlyAdmin {
743         require(_addr != address(0));
744         raceCoinContract = IRaceCoin(_addr);
745     }
746 
747 
748     function getCarSlotInt(address _owner, uint256 _carTokenId) public view returns(uint256,uint256,uint256,uint256){
749         require(tokenContract.ownerOf(_carTokenId) == _owner);  
750         return ( slotEngine[_carTokenId],
751                  slotTurbine[_carTokenId],
752                  slotBodySystem[_carTokenId],
753                  slotPipe[_carTokenId]
754                 );
755     }
756 
757 
758     function getCarSlotMult(address _owner, uint256 _carTokenId) public view returns(uint256,uint256,uint256,uint256){
759         require(tokenContract.ownerOf(_carTokenId) == _owner);  
760         return ( slotSuspension[_carTokenId],
761                  slotNO2[_carTokenId],
762                  slotTyre[_carTokenId],
763                  slotTransmission[_carTokenId]
764                 );
765     }
766 
767 
768     
769     function _equipUpOne(address _owner, uint256 _carTokenId, uint256 _partsTokenId) private {
770         require(tokenContract.ownerOf(_carTokenId) == _owner);
771         require(tokenContract.ownerOf(_partsTokenId) == _owner);
772         uint16[13] memory attrs = tokenContract.getFashion(_partsTokenId);
773         uint16 pos = attrs[2];
774         bool isEquip = this.isEquiped(_owner, _partsTokenId);
775 
776         uint256[] storage sArray =  slotlist[_owner];
777         uint256 i = 0;
778 
779         uint16[13] memory attrsOldParts;
780 
781         if(!isEquip){
782             if (pos == 1) {
783                 if (slotEngine[_carTokenId] != _partsTokenId) {
784 
785                     if(slotEngine[_carTokenId] > 0){
786                         attrsOldParts = tokenContract.getFashion(slotEngine[_carTokenId]);
787                         raceCoinContract.reducePlayersAttribute(_owner, attrsOldParts);
788                     }
789  
790                     
791 
792                     
793                     for( i = 0; i < sArray.length; i++){
794                         if(sArray[i] == slotEngine[_carTokenId]){
795                             delete sArray[i];
796                         }
797                     }
798 
799                     if(slotEngine[_carTokenId] > 0){
800 
801                     }else{
802                         carSlot[_carTokenId]++;
803                     }
804 
805                     slotEngine[_carTokenId] = _partsTokenId;
806                     slotlist[_owner].push(_partsTokenId);
807                     raceCoinContract.increasePlayersAttribute(_owner, attrs);
808                 }
809             } else if (pos == 2) {
810                 if (slotTurbine[_carTokenId] != _partsTokenId) {
811                     
812                   
813 
814                     if(slotTurbine[_carTokenId] > 0){
815                         attrsOldParts = tokenContract.getFashion(slotTurbine[_carTokenId]);
816                         raceCoinContract.reducePlayersAttribute(_owner, attrsOldParts);
817                     }
818                     
819                    
820                     for( i = 0; i < sArray.length; i++){
821                         if(sArray[i] == slotTurbine[_carTokenId]){
822                             delete sArray[i];
823                         }
824                     }
825 
826                     if(slotTurbine[_carTokenId] > 0){
827 
828                     }else{
829                         carSlot[_carTokenId]++;
830                     }
831 
832                     slotTurbine[_carTokenId] = _partsTokenId;
833                     slotlist[_owner].push(_partsTokenId);
834                     raceCoinContract.increasePlayersAttribute(_owner, attrs);
835                 }
836             } else if (pos == 3) {
837                 if (slotBodySystem[_carTokenId] != _partsTokenId) {
838 
839                    
840                    
841 
842                     if(slotBodySystem[_carTokenId] > 0){
843                         attrsOldParts = tokenContract.getFashion(slotBodySystem[_carTokenId]);
844                         raceCoinContract.reducePlayersAttribute(_owner, attrsOldParts);
845                     }
846                     
847                     
848                     for( i = 0; i < sArray.length; i++){
849                         if(sArray[i] == slotBodySystem[_carTokenId]){
850                             delete sArray[i];
851                         }
852                     }
853 
854                     if(slotBodySystem[_carTokenId] > 0){
855 
856                     }else{
857                         carSlot[_carTokenId]++;
858                     }
859 
860                     slotBodySystem[_carTokenId] = _partsTokenId;
861                     slotlist[_owner].push(_partsTokenId);
862                     raceCoinContract.increasePlayersAttribute(_owner, attrs);
863                 }
864             } else if (pos == 4) {
865                 if (slotPipe[_carTokenId] != _partsTokenId) {
866 
867                     
868                    
869 
870                     if(slotPipe[_carTokenId] > 0){
871                         attrsOldParts = tokenContract.getFashion(slotPipe[_carTokenId]);
872                         raceCoinContract.reducePlayersAttribute(_owner, attrsOldParts);
873                     }
874 
875                     
876 
877                     for( i = 0; i < sArray.length; i++){
878                         if(sArray[i] == slotPipe[_carTokenId]){
879                             delete sArray[i];
880                         }
881                     }
882 
883                     if(slotPipe[_carTokenId] > 0){
884 
885                     }else{
886                         carSlot[_carTokenId]++;
887                     }
888 
889                     slotPipe[_carTokenId] = _partsTokenId;
890                     slotlist[_owner].push(_partsTokenId);
891                     raceCoinContract.increasePlayersAttribute(_owner, attrs);
892                 }
893             } else if (pos == 5) {
894                 if (slotSuspension[_carTokenId] != _partsTokenId) {
895 
896                    
897                   
898 
899                     if(slotSuspension[_carTokenId] > 0){
900                         attrsOldParts = tokenContract.getFashion(slotSuspension[_carTokenId]);
901                         raceCoinContract.reducePlayersAttribute(_owner, attrsOldParts);
902                     }
903 
904                     
905 
906                     for( i = 0; i < sArray.length; i++){
907                         if(sArray[i] == slotSuspension[_carTokenId]){
908                             delete sArray[i];
909                         }
910                     }
911 
912                     if(slotSuspension[_carTokenId] > 0){
913 
914                     }else{
915                         carSlot[_carTokenId]++;
916                     }
917 
918                     slotSuspension[_carTokenId] = _partsTokenId;
919                     slotlist[_owner].push(_partsTokenId);
920                     raceCoinContract.increasePlayersAttribute(_owner, attrs);
921                 }
922             } else if (pos == 6) {
923                 if (slotNO2[_carTokenId] != _partsTokenId) {
924 
925                    
926                    
927 
928                     if(slotNO2[_carTokenId] > 0){
929                         attrsOldParts = tokenContract.getFashion(slotNO2[_carTokenId]);
930                         raceCoinContract.reducePlayersAttribute(_owner, attrsOldParts);
931                     }
932 
933                     
934 
935                     for( i = 0; i < sArray.length; i++){
936                         if(sArray[i] == slotNO2[_carTokenId]){
937                             delete sArray[i];
938                         }
939                     }
940 
941                     if(slotNO2[_carTokenId] > 0){
942 
943                     }else{
944                         carSlot[_carTokenId]++;
945                     }
946 
947                     slotNO2[_carTokenId] = _partsTokenId;
948                     slotlist[_owner].push(_partsTokenId);
949                     raceCoinContract.increasePlayersAttribute(_owner, attrs);
950                 }
951             } else if (pos == 7) {
952                 if (slotTyre[_carTokenId] != _partsTokenId) {
953 
954                    
955                  
956 
957                     if(slotTyre[_carTokenId] > 0){
958                          attrsOldParts = tokenContract.getFashion(slotTyre[_carTokenId]);
959                         raceCoinContract.reducePlayersAttribute(_owner, attrsOldParts);
960                     }
961 
962                    
963 
964 
965                     for( i = 0; i < sArray.length; i++){
966                         if(sArray[i] == slotTyre[_carTokenId]){
967                             delete sArray[i];
968                         }
969                     }
970 
971                     if(slotTyre[_carTokenId] > 0){
972 
973                     }else{
974                         carSlot[_carTokenId]++;
975                     }
976 
977                     slotTyre[_carTokenId] = _partsTokenId;
978                     slotlist[_owner].push(_partsTokenId);
979                     raceCoinContract.increasePlayersAttribute(_owner, attrs);
980                 }
981             } else if (pos == 8) {
982                 if (slotTransmission[_carTokenId] != _partsTokenId) {
983 
984         
985                   
986 
987                     if(slotTransmission[_carTokenId] > 0){
988                         attrsOldParts = tokenContract.getFashion(slotTransmission[_carTokenId]);
989                         raceCoinContract.reducePlayersAttribute(_owner, attrsOldParts);
990                     }
991 
992                     
993 
994 
995                     for( i = 0; i < sArray.length; i++){
996                         if(sArray[i] == slotTransmission[_carTokenId]){
997                             delete sArray[i];
998                         }
999                     }
1000 
1001                     if(slotTransmission[_carTokenId] > 0){
1002 
1003                     }else{
1004                         carSlot[_carTokenId]++;
1005                     }
1006 
1007                     slotTransmission[_carTokenId] = _partsTokenId;
1008                     slotlist[_owner].push(_partsTokenId);
1009                     raceCoinContract.increasePlayersAttribute(_owner, attrs);
1010                 }
1011             }
1012         }   
1013     }
1014 
1015     function _equipDownOne(address _owner, uint256 _carTokenId, uint256 _partsTokenId) private {
1016         require(tokenContract.ownerOf(_carTokenId) == _owner);
1017         uint16[13] memory attrs = tokenContract.getFashion(_partsTokenId);
1018         uint16 pos = attrs[2];
1019         bool b = false;
1020         if (pos == 1) {
1021             if (slotEngine[_carTokenId] != 0) {
1022                 slotEngine[_carTokenId] = 0;
1023                 b = true;
1024                 carSlot[_carTokenId]--;
1025             }
1026         } else if (pos == 2) {
1027             if (slotTurbine[_carTokenId] != 0) {
1028                 slotTurbine[_carTokenId] = 0;
1029                 b = true;
1030                 carSlot[_carTokenId]--;
1031             }
1032         } else if (pos == 3) {
1033             if (slotBodySystem[_carTokenId] != 0) {
1034                 slotBodySystem[_carTokenId] = 0;
1035                 b = true;
1036                 carSlot[_carTokenId]--;
1037             }
1038         } else if (pos == 4) {
1039             if (slotPipe[_carTokenId] != 0) {
1040                 slotPipe[_carTokenId] = 0;
1041                 b = true;
1042                 carSlot[_carTokenId]--;
1043             }
1044         } else if (pos == 5) {
1045             if (slotSuspension[_carTokenId] != 0) {
1046                 slotSuspension[_carTokenId] = 0;
1047                 b = true;
1048                 carSlot[_carTokenId]--;
1049             }
1050         } else if (pos == 6) {
1051             if (slotNO2[_carTokenId] != 0) {
1052                 slotNO2[_carTokenId] = 0;
1053                 b = true;
1054                 carSlot[_carTokenId]--;
1055             }
1056         } else if (pos == 7) {
1057             if (slotTyre[_carTokenId] != 0) {
1058                 slotTyre[_carTokenId] = 0;
1059                 b = true;
1060                 carSlot[_carTokenId]--;
1061             }
1062         } else if (pos == 8) {
1063             if (slotTransmission[_carTokenId] != 0) {
1064                 slotTransmission[_carTokenId] = 0;
1065                 b = true;
1066                 carSlot[_carTokenId]--;
1067             }
1068         }
1069 
1070         if(b){  
1071 
1072             uint256[] storage sArray =  slotlist[_owner];
1073 
1074             for(uint256 i = 0; i < sArray.length; i++){
1075                 if(sArray[i] == _partsTokenId){
1076                     delete sArray[i];
1077                 }
1078             }
1079         }
1080 
1081         raceCoinContract.reducePlayersAttribute(_owner, attrs);
1082     }
1083 
1084     function equipUp(uint256 _carTokenId, uint256[8] _tokens) 
1085         external 
1086         whenNotPaused
1087     {
1088         for (uint16 i = 0; i < 8; ++i) {
1089             if (_tokens[i] > 0) {
1090                 _equipUpOne(msg.sender,_carTokenId, _tokens[i]);
1091             }  
1092         }
1093         emit EquipChanged(msg.sender);
1094     }
1095 
1096     function equipDown(uint256 _carTokenId, uint256[8] _tokens) 
1097         external
1098         whenNotPaused 
1099     {
1100         for (uint16 i = 0; i < 8; ++i) {
1101             if (_tokens[i] > 0) {
1102                 _equipDownOne(msg.sender,_carTokenId, _tokens[i]);
1103             }  
1104         }
1105         emit EquipChanged(msg.sender);
1106     }    
1107 
1108     function isEquiped(address _target, uint256 _tokenId) external view returns(bool) {
1109         require(_target != address(0));
1110         require(_tokenId > 0);
1111 
1112         uint16[13] memory attrs = tokenContract.getFashion(_tokenId);
1113         uint16 pos = attrs[2];
1114 
1115         if(pos == 9){
1116 
1117             if(carSlot[_tokenId] > 0){
1118                 return true;
1119             }
1120 
1121         }else{
1122 
1123             uint256[] memory sArray =  slotlist[_target];
1124 
1125             for(uint256 i = 0; i < sArray.length; i++){
1126                 if(sArray[i] == _tokenId){
1127                     return true;
1128                 }
1129             }
1130         }
1131 
1132 
1133         return false;
1134     }
1135 
1136     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool) {
1137         require(_target != address(0));
1138         require(_tokenId1 > 0);
1139         require(_tokenId2 > 0);
1140 
1141         uint256[] memory sArray =  slotlist[_target];
1142 
1143         for(uint256 i = 0; i < sArray.length; i++){
1144             if(sArray[i] == _tokenId1 || sArray[i] == _tokenId2){
1145                 return true;
1146             }
1147         }
1148           
1149         return false;
1150     }
1151 
1152     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool) {
1153         require(_target != address(0));
1154         require(_tokenId1 > 0);
1155         require(_tokenId2 > 0);
1156         require(_tokenId3 > 0);
1157         
1158         uint256[] memory sArray =  slotlist[_target];
1159 
1160         for(uint256 i = 0; i < sArray.length; i++){
1161             if(sArray[i] == _tokenId1 || sArray[i] == _tokenId2 || sArray[i] == _tokenId3){
1162                 return true;
1163             }
1164         }
1165 
1166         return false;
1167     }
1168 
1169     function getEquipTokens(address _target, uint256 _carTokenId) external view returns(uint256[8] tokens) {
1170 
1171         require(tokenContract.ownerOf(_carTokenId) == _target);
1172 
1173         tokens[0] = slotEngine[_carTokenId];
1174         tokens[1] = slotTurbine[_carTokenId];
1175         tokens[2] = slotBodySystem[_carTokenId];
1176         tokens[3] = slotPipe[_carTokenId];
1177         tokens[4] = slotSuspension[_carTokenId];
1178         tokens[5] = slotNO2[_carTokenId];
1179         tokens[6] = slotTyre[_carTokenId];
1180         tokens[7] = slotTransmission[_carTokenId];
1181     }
1182 }