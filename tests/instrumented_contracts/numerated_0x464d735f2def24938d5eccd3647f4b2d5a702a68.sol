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
119 interface IDataMining {
120     function subFreeMineral(address _target) external returns(bool);
121 }
122 
123 interface IDataEquip {
124     function isEquiped(address _target, uint256 _tokenId) external view returns(bool);
125     function isEquipedAny2(address _target, uint256 _tokenId1, uint256 _tokenId2) external view returns(bool);
126     function isEquipedAny3(address _target, uint256 _tokenId1, uint256 _tokenId2, uint256 _tokenId3) external view returns(bool);
127 }
128 
129 contract Random {
130     uint256 _seed;
131 
132     function _rand() internal returns (uint256) {
133         _seed = uint256(keccak256(_seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
134         return _seed;
135     }
136 
137     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
138         return uint256(keccak256(_outSeed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
139     }
140 }
141 
142 /**
143  * @title SafeMath
144  * @dev Math operations with safety checks that throw on error
145  */
146 library SafeMath {
147     /**
148     * @dev Multiplies two numbers, throws on overflow.
149     */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         if (a == 0) {
152             return 0;
153         }
154         uint256 c = a * b;
155         assert(c / a == b);
156         return c;
157     }
158 
159     /**
160     * @dev Integer division of two numbers, truncating the quotient.
161     */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         // assert(b > 0); // Solidity automatically throws when dividing by 0
164         uint256 c = a / b;
165         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
166         return c;
167     }
168 
169     /**
170     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
171     */
172     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
173         assert(b <= a);
174         return a - b;
175     }
176 
177     /**
178     * @dev Adds two numbers, throws on overflow.
179     */
180     function add(uint256 a, uint256 b) internal pure returns (uint256) {
181         uint256 c = a + b;
182         assert(c >= a);
183         return c;
184     }
185 }
186 
187 contract RaceToken is ERC721, AccessAdmin {
188     /// @dev The equipment info
189     struct Fashion {
190         uint16 equipmentId;             // 0  Equipment ID
191         uint16 quality;     	        // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
192         uint16 pos;         	        // 2  Slots: 1 Engine/2 Turbine/3 BodySystem/4 Pipe/5 Suspension/6 NO2/7 Tyre/8 Transmission/9 Car
193         uint16 production;    	        // 3  Race bonus productivity
194         uint16 attack;	                // 4  Attack
195         uint16 defense;                 // 5  Defense
196         uint16 plunder;     	        // 6  Plunder
197         uint16 productionMultiplier;    // 7  Percent value
198         uint16 attackMultiplier;     	// 8  Percent value
199         uint16 defenseMultiplier;     	// 9  Percent value
200         uint16 plunderMultiplier;     	// 10 Percent value
201         uint16 level;       	        // 11 level
202         uint16 isPercent;   	        // 12  Percent value
203     }
204 
205     /// @dev All equipments tokenArray (not exceeding 2^32-1)
206     Fashion[] public fashionArray;
207 
208     /// @dev Amount of tokens destroyed
209     uint256 destroyFashionCount;
210 
211     /// @dev Equipment token ID belong to owner address
212     mapping (uint256 => address) fashionIdToOwner;
213 
214     /// @dev Equipments owner by the owner (array)
215     mapping (address => uint256[]) ownerToFashionArray;
216 
217     /// @dev Equipment token ID search in owner array
218     mapping (uint256 => uint256) fashionIdToOwnerIndex;
219 
220     /// @dev The authorized address for each Race
221     mapping (uint256 => address) fashionIdToApprovals;
222 
223     /// @dev The authorized operators for each address
224     mapping (address => mapping (address => bool)) operatorToApprovals;
225 
226     /// @dev Trust contract
227     mapping (address => bool) actionContracts;
228 
229 	
230     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
231         actionContracts[_actionAddr] = _useful;
232     }
233 
234     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
235         return actionContracts[_actionAddr];
236     }
237 
238     /// @dev This emits when the approved address for an Race is changed or reaffirmed.
239     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
240 
241     /// @dev This emits when an operator is enabled or disabled for an owner.
242     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
243 
244     /// @dev This emits when the equipment ownership changed 
245     event Transfer(address indexed from, address indexed to, uint256 tokenId);
246 
247     /// @dev This emits when the equipment created
248     event CreateFashion(address indexed owner, uint256 tokenId, uint16 equipmentId, uint16 quality, uint16 pos, uint16 level, uint16 createType);
249 
250     /// @dev This emits when the equipment's attributes changed
251     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
252 
253     /// @dev This emits when the equipment destroyed
254     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
255     
256     function RaceToken() public {
257         addrAdmin = msg.sender;
258         fashionArray.length += 1;
259     }
260 
261     // modifier
262     /// @dev Check if token ID is valid
263     modifier isValidToken(uint256 _tokenId) {
264         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
265         require(fashionIdToOwner[_tokenId] != address(0)); 
266         _;
267     }
268 
269     modifier canTransfer(uint256 _tokenId) {
270         address owner = fashionIdToOwner[_tokenId];
271         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
272         _;
273     }
274 
275     // ERC721
276     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
277         // ERC165 || ERC721 || ERC165^ERC721
278         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
279     }
280         
281     function name() public pure returns(string) {
282         return "Race Token";
283     }
284 
285     function symbol() public pure returns(string) {
286         return "Race";
287     }
288 
289     /// @dev Search for token quantity address
290     /// @param _owner Address that needs to be searched
291     /// @return Returns token quantity
292     function balanceOf(address _owner) external view returns(uint256) {
293         require(_owner != address(0));
294         return ownerToFashionArray[_owner].length;
295     }
296 
297     /// @dev Find the owner of an Race
298     /// @param _tokenId The tokenId of Race
299     /// @return Give The address of the owner of this Race
300     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
301         return fashionIdToOwner[_tokenId];
302     }
303 
304     /// @dev Transfers the ownership of an Race from one address to another address
305     /// @param _from The current owner of the Race
306     /// @param _to The new owner
307     /// @param _tokenId The Race to transfer
308     /// @param data Additional data with no specified format, sent in call to `_to`
309     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
310         external
311         whenNotPaused
312     {
313         _safeTransferFrom(_from, _to, _tokenId, data);
314     }
315 
316     /// @dev Transfers the ownership of an Race from one address to another address
317     /// @param _from The current owner of the Race
318     /// @param _to The new owner
319     /// @param _tokenId The Race to transfer
320     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
321         external
322         whenNotPaused
323     {
324         _safeTransferFrom(_from, _to, _tokenId, "");
325     }
326 
327     /// @dev Transfer ownership of an Race, '_to' must be a vaild address, or the Race will lost
328     /// @param _from The current owner of the Race
329     /// @param _to The new owner
330     /// @param _tokenId The Race to transfer
331     function transferFrom(address _from, address _to, uint256 _tokenId)
332         external
333         whenNotPaused
334         isValidToken(_tokenId)
335         canTransfer(_tokenId)
336     {
337         address owner = fashionIdToOwner[_tokenId];
338         require(owner != address(0));
339         require(_to != address(0));
340         require(owner == _from);
341         
342         _transfer(_from, _to, _tokenId);
343     }
344 
345     /// @dev Set or reaffirm the approved address for an Race
346     /// @param _approved The new approved Race controller
347     /// @param _tokenId The Race to approve
348     function approve(address _approved, uint256 _tokenId)
349         external
350         whenNotPaused
351     {
352         address owner = fashionIdToOwner[_tokenId];
353         require(owner != address(0));
354         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
355 
356         fashionIdToApprovals[_tokenId] = _approved;
357         Approval(owner, _approved, _tokenId);
358     }
359 
360     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
361     /// @param _operator Address to add to the set of authorized operators.
362     /// @param _approved True if the operators is approved, false to revoke approval
363     function setApprovalForAll(address _operator, bool _approved) 
364         external 
365         whenNotPaused
366     {
367         operatorToApprovals[msg.sender][_operator] = _approved;
368         ApprovalForAll(msg.sender, _operator, _approved);
369     }
370 
371     /// @dev Get the approved address for a single Race
372     /// @param _tokenId The Race to find the approved address for
373     /// @return The approved address for this Race, or the zero address if there is none
374     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
375         return fashionIdToApprovals[_tokenId];
376     }
377 
378     /// @dev Query if an address is an authorized operator for another address
379     /// @param _owner The address that owns the Races
380     /// @param _operator The address that acts on behalf of the owner
381     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
382     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
383         return operatorToApprovals[_owner][_operator];
384     }
385 
386     /// @dev Count Races tracked by this contract
387     /// @return A count of valid Races tracked by this contract, where each one of
388     ///  them has an assigned and queryable owner not equal to the zero address
389     function totalSupply() external view returns (uint256) {
390         return fashionArray.length - destroyFashionCount - 1;
391     }
392 
393     /// @dev Do the real transfer with out any condition checking
394     /// @param _from The old owner of this Race(If created: 0x0)
395     /// @param _to The new owner of this Race 
396     /// @param _tokenId The tokenId of the Race
397     function _transfer(address _from, address _to, uint256 _tokenId) internal {
398         if (_from != address(0)) {
399             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
400             uint256[] storage fsArray = ownerToFashionArray[_from];
401             require(fsArray[indexFrom] == _tokenId);
402 
403             // If the Race is not the element of array, change it to with the last
404             if (indexFrom != fsArray.length - 1) {
405                 uint256 lastTokenId = fsArray[fsArray.length - 1];
406                 fsArray[indexFrom] = lastTokenId; 
407                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
408             }
409             fsArray.length -= 1; 
410             
411             if (fashionIdToApprovals[_tokenId] != address(0)) {
412                 delete fashionIdToApprovals[_tokenId];
413             }      
414         }
415 
416         // Give the Race to '_to'
417         fashionIdToOwner[_tokenId] = _to;
418         ownerToFashionArray[_to].push(_tokenId);
419         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
420         
421         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
422     }
423 
424     /// @dev Actually perform the safeTransferFrom
425     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
426         internal
427         isValidToken(_tokenId) 
428         canTransfer(_tokenId)
429     {
430         address owner = fashionIdToOwner[_tokenId];
431         require(owner != address(0));
432         require(_to != address(0));
433         require(owner == _from);
434         
435         _transfer(_from, _to, _tokenId);
436 
437         // Do the callback after everything is done to avoid reentrancy attack
438         uint256 codeSize;
439         assembly { codeSize := extcodesize(_to) }
440         if (codeSize == 0) {
441             return;
442         }
443         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
444         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
445         require(retval == 0xf0b9e5ba);
446     }
447 
448     //----------------------------------------------------------------------------------------------------------
449 
450     /// @dev Equipment creation
451     /// @param _owner Owner of the equipment created
452     /// @param _attrs Attributes of the equipment created
453     /// @return Token ID of the equipment created
454     function createFashion(address _owner, uint16[13] _attrs, uint16 _createType) 
455         external 
456         whenNotPaused
457         returns(uint256)
458     {
459         require(actionContracts[msg.sender]);
460         require(_owner != address(0));
461 
462         uint256 newFashionId = fashionArray.length;
463         require(newFashionId < 4294967296);
464 
465         fashionArray.length += 1;
466         Fashion storage fs = fashionArray[newFashionId];
467         fs.equipmentId = _attrs[0];
468         fs.quality = _attrs[1];
469         fs.pos = _attrs[2];
470         if (_attrs[3] != 0) {
471             fs.production = _attrs[3];
472         }
473         
474         if (_attrs[4] != 0) {
475             fs.attack = _attrs[4];
476         }
477 		
478 		if (_attrs[5] != 0) {
479             fs.defense = _attrs[5];
480         }
481        
482         if (_attrs[6] != 0) {
483             fs.plunder = _attrs[6];
484         }
485         
486         if (_attrs[7] != 0) {
487             fs.productionMultiplier = _attrs[7];
488         }
489 
490         if (_attrs[8] != 0) {
491             fs.attackMultiplier = _attrs[8];
492         }
493 
494         if (_attrs[9] != 0) {
495             fs.defenseMultiplier = _attrs[9];
496         }
497 
498         if (_attrs[10] != 0) {
499             fs.plunderMultiplier = _attrs[10];
500         }
501 
502         if (_attrs[11] != 0) {
503             fs.level = _attrs[11];
504         }
505 
506         if (_attrs[12] != 0) {
507             fs.isPercent = _attrs[12];
508         }
509         
510         _transfer(0, _owner, newFashionId);
511         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _attrs[11], _createType);
512         return newFashionId;
513     }
514 
515     /// @dev One specific attribute of the equipment modified
516     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
517         if (_index == 3) {
518             _fs.production = _val;
519         } else if(_index == 4) {
520             _fs.attack = _val;
521         } else if(_index == 5) {
522             _fs.defense = _val;
523         } else if(_index == 6) {
524             _fs.plunder = _val;
525         }else if(_index == 7) {
526             _fs.productionMultiplier = _val;
527         }else if(_index == 8) {
528             _fs.attackMultiplier = _val;
529         }else if(_index == 9) {
530             _fs.defenseMultiplier = _val;
531         }else if(_index == 10) {
532             _fs.plunderMultiplier = _val;
533         } else if(_index == 11) {
534             _fs.level = _val;
535         } 
536        
537     }
538 
539     /// @dev Equiment attributes modified (max 4 stats modified)
540     /// @param _tokenId Equipment Token ID
541     /// @param _idxArray Stats order that must be modified
542     /// @param _params Stat value that must be modified
543     /// @param _changeType Modification type such as enhance, socket, etc.
544     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
545         external 
546         whenNotPaused
547         isValidToken(_tokenId) 
548     {
549         require(actionContracts[msg.sender]);
550 
551         Fashion storage fs = fashionArray[_tokenId];
552         if (_idxArray[0] > 0) {
553             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
554         }
555 
556         if (_idxArray[1] > 0) {
557             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
558         }
559 
560         if (_idxArray[2] > 0) {
561             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
562         }
563 
564         if (_idxArray[3] > 0) {
565             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
566         }
567 
568         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
569     }
570 
571     /// @dev Equipment destruction
572     /// @param _tokenId Equipment Token ID
573     /// @param _deleteType Destruction type, such as craft
574     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
575         external 
576         whenNotPaused
577         isValidToken(_tokenId) 
578     {
579         require(actionContracts[msg.sender]);
580 
581         address _from = fashionIdToOwner[_tokenId];
582         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
583         uint256[] storage fsArray = ownerToFashionArray[_from]; 
584         require(fsArray[indexFrom] == _tokenId);
585 
586         if (indexFrom != fsArray.length - 1) {
587             uint256 lastTokenId = fsArray[fsArray.length - 1];
588             fsArray[indexFrom] = lastTokenId; 
589             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
590         }
591         fsArray.length -= 1; 
592 
593         fashionIdToOwner[_tokenId] = address(0);
594         delete fashionIdToOwnerIndex[_tokenId];
595         destroyFashionCount += 1;
596 
597         Transfer(_from, 0, _tokenId);
598 
599         DeleteFashion(_from, _tokenId, _deleteType);
600     }
601 
602     /// @dev Safe transfer by trust contracts
603     function safeTransferByContract(uint256 _tokenId, address _to) 
604         external
605         whenNotPaused
606     {
607         require(actionContracts[msg.sender]);
608 
609         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
610         address owner = fashionIdToOwner[_tokenId];
611         require(owner != address(0));
612         require(_to != address(0));
613         require(owner != _to);
614 
615         _transfer(owner, _to, _tokenId);
616     }
617 
618     //----------------------------------------------------------------------------------------------------------
619 
620     /// @dev Get fashion attrs by tokenId front
621     function getFashionFront(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint256[14] datas) {
622         Fashion storage fs = fashionArray[_tokenId];
623         datas[0] = fs.equipmentId;
624         datas[1] = fs.quality;
625         datas[2] = fs.pos;
626         datas[3] = fs.production;
627         datas[4] = fs.attack;
628         datas[5] = fs.defense;
629         datas[6] = fs.plunder;
630         datas[7] = fs.productionMultiplier;
631         datas[8] = fs.attackMultiplier;
632         datas[9] = fs.defenseMultiplier;
633         datas[10] = fs.plunderMultiplier;
634         datas[11] = fs.level;
635         datas[12] = fs.isPercent; 
636         datas[13] = _tokenId;      
637     }
638 
639     /// @dev Get fashion attrs by tokenId back
640     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[13] datas) {
641         Fashion storage fs = fashionArray[_tokenId];
642         datas[0] = fs.equipmentId;
643         datas[1] = fs.quality;
644         datas[2] = fs.pos;
645         datas[3] = fs.production;
646         datas[4] = fs.attack;
647         datas[5] = fs.defense;
648         datas[6] = fs.plunder;
649         datas[7] = fs.productionMultiplier;
650         datas[8] = fs.attackMultiplier;
651         datas[9] = fs.defenseMultiplier;
652         datas[10] = fs.plunderMultiplier;
653         datas[11] = fs.level;
654         datas[12] = fs.isPercent;      
655     }
656 
657 
658     /// @dev Get tokenIds and flags by owner
659     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
660         require(_owner != address(0));
661         uint256[] storage fsArray = ownerToFashionArray[_owner];
662         uint256 length = fsArray.length;
663         tokens = new uint256[](length);
664         flags = new uint32[](length);
665         for (uint256 i = 0; i < length; ++i) {
666             tokens[i] = fsArray[i];
667             Fashion storage fs = fashionArray[fsArray[i]];
668             flags[i] = uint32(uint32(fs.equipmentId) * 10000 + uint32(fs.quality) * 100 + fs.pos);
669         }
670     }
671 
672 
673     /// @dev Race token info returned based on Token ID transfered (64 at most)
674     function getFashionsAttrs(uint256[] _tokens) external view returns(uint256[] attrs) {
675         uint256 length = _tokens.length;
676         attrs = new uint256[](length * 14);
677         uint256 tokenId;
678         uint256 index;
679         for (uint256 i = 0; i < length; ++i) {
680             tokenId = _tokens[i];
681             if (fashionIdToOwner[tokenId] != address(0)) {
682                 index = i * 14;
683                 Fashion storage fs = fashionArray[tokenId];
684                 attrs[index]     = fs.equipmentId;
685 				attrs[index + 1] = fs.quality;
686                 attrs[index + 2] = fs.pos;
687                 attrs[index + 3] = fs.production;
688                 attrs[index + 4] = fs.attack;
689                 attrs[index + 5] = fs.defense;
690                 attrs[index + 6] = fs.plunder;
691                 attrs[index + 7] = fs.productionMultiplier;
692                 attrs[index + 8] = fs.attackMultiplier;
693                 attrs[index + 9] = fs.defenseMultiplier;
694                 attrs[index + 10] = fs.plunderMultiplier;
695                 attrs[index + 11] = fs.level;
696                 attrs[index + 12] = fs.isPercent; 
697                 attrs[index + 13] = tokenId;  
698             }   
699         }
700     }
701 }
702 
703 //Tournament bonus interface
704 interface IRaceCoin {
705     function addTotalEtherPool(uint256 amount) external;
706     function addPlayerToList(address player) external;
707     function increasePlayersAttribute(address player, uint16[13] param) external;
708     function reducePlayersAttribute(address player, uint16[13] param) external;
709 }
710 
711 contract EquipmentCompose is Random, AccessService {
712     using SafeMath for uint256;
713 
714     event ComposeSuccess(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos);
715     
716     /// @dev prizepool percent
717     uint256 constant prizePoolPercent = 80;
718     /// @dev prizepool contact address
719     address poolContract;
720     /// @dev DataEquip contract address
721     IDataEquip public equipContract;
722     /// @dev RaceToken(NFT) contract address
723     RaceToken public tokenContract;
724 
725     IRaceCoin public raceCoinContract;
726 
727     function EquipmentCompose(address _nftAddr) public {
728         addrAdmin = msg.sender;
729         addrService = msg.sender;
730         addrFinance = msg.sender;
731 
732         tokenContract = RaceToken(_nftAddr);
733     }
734 
735     function() external payable {
736 
737     }
738 
739     
740     function setPrizePool(address _addr) external onlyAdmin {
741         require(_addr != address(0));
742         poolContract = _addr;
743         raceCoinContract = IRaceCoin(_addr);
744     }
745 
746     function setDataEquip(address _addr) external onlyAdmin {
747         require(_addr != address(0));
748         equipContract = IDataEquip(_addr);
749     }
750 
751     function _getFashionParam(uint256 _seed, uint16 _protoId, uint16 _quality, uint16 _pos) internal pure returns(uint16[13] attrs) {
752         uint256 curSeed = _seed;
753         attrs[0] = _protoId;
754         attrs[1] = _quality;
755         attrs[2] = _pos;
756 
757         uint16 qtyParam = 0;
758         if (_quality <= 3) {
759             qtyParam = _quality - 1;
760         } else if (_quality == 4) {
761             qtyParam = 4;
762         } else if (_quality == 5) {
763             qtyParam = 7;
764         }
765 
766         uint256 rdm = _protoId % 3;
767 
768         curSeed /= 10000;
769         uint256 tmpVal = (curSeed % 10000) % 21 + 90;
770 
771         if (rdm == 0) {
772             if (_pos == 1) {
773                 attrs[3] = uint16((20 + qtyParam * 20) * tmpVal / 100);              // +production
774             } else if (_pos == 2) {
775                 attrs[4] = uint16((100 + qtyParam * 100) * tmpVal / 100);            // +attack
776             } else if (_pos == 3) {
777                 attrs[5] = uint16((70 + qtyParam * 70) * tmpVal / 100);              // +defense
778             } else if (_pos == 4) {
779                 attrs[6] = uint16((500 + qtyParam * 500) * tmpVal / 100);            // +plunder
780             } else if (_pos == 5) {
781                 attrs[7] = uint16((4 + qtyParam * 4) * tmpVal / 100);                // +productionMultiplier
782             } else if (_pos == 6) {
783                 attrs[8] = uint16((5 + qtyParam * 5) * tmpVal / 100);                // +attackMultiplier
784             } else if (_pos == 7) {
785                 attrs[9] = uint16((5 + qtyParam * 5) * tmpVal / 100);                // +defenseMultiplier
786             } else {
787                 attrs[10] = uint16((4 + qtyParam * 4) * tmpVal / 100);               // +plunderMultiplier
788             } 
789         } else if (rdm == 1) {
790             if (_pos == 1) {
791                 attrs[3] = uint16((19 + qtyParam * 19) * tmpVal / 100);              // +production
792             } else if (_pos == 2) {
793                 attrs[4] = uint16((90 + qtyParam * 90) * tmpVal / 100);            // +attack
794             } else if (_pos == 3) {
795                 attrs[5] = uint16((63 + qtyParam * 63) * tmpVal / 100);              // +defense
796             } else if (_pos == 4) {
797                 attrs[6] = uint16((450 + qtyParam * 450) * tmpVal / 100);            // +plunder
798             } else if (_pos == 5) {
799                 attrs[7] = uint16((3 + qtyParam * 3) * tmpVal / 100);                // +productionMultiplier
800             } else if (_pos == 6) {
801                 attrs[8] = uint16((4 + qtyParam * 4) * tmpVal / 100);                // +attackMultiplier
802             } else if (_pos == 7) {
803                 attrs[9] = uint16((4 + qtyParam * 4) * tmpVal / 100);                // +defenseMultiplier
804             } else {
805                 attrs[10] = uint16((3 + qtyParam * 3) * tmpVal / 100);               // +plunderMultiplier
806             } 
807         } else {
808             if (_pos == 1) {
809                 attrs[3] = uint16((21 + qtyParam * 21) * tmpVal / 100);              // +production
810             } else if (_pos == 2) {
811                 attrs[4] = uint16((110 + qtyParam * 110) * tmpVal / 100);            // +attack
812             } else if (_pos == 3) {
813                 attrs[5] = uint16((77 + qtyParam * 77) * tmpVal / 100);              // +defense
814             } else if (_pos == 4) {
815                 attrs[6] = uint16((550 + qtyParam * 550) * tmpVal / 100);            // +plunder
816             } else if (_pos == 5) {
817                 attrs[7] = uint16((5 + qtyParam * 5) * tmpVal / 100);                // +productionMultiplier
818             } else if (_pos == 6) {
819                 attrs[8] = uint16((6 + qtyParam * 6) * tmpVal / 100);                // +attackMultiplier
820             } else if (_pos == 7) {
821                 attrs[9] = uint16((6 + qtyParam * 6) * tmpVal / 100);                // +defenseMultiplier
822             } else {
823                 attrs[10] = uint16((5 + qtyParam * 5) * tmpVal / 100);               // +plunderMultiplier
824             } 
825         }
826         attrs[11] = 0;
827         attrs[12] = 0;
828     }
829 
830     function _transferHelper(uint256 ethVal) private {
831         uint256 fVal;
832         uint256 pVal;
833         
834         fVal = ethVal.mul(prizePoolPercent).div(100);
835         pVal = ethVal.sub(fVal);
836         addrFinance.transfer(pVal);
837         if (poolContract != address(0) && pVal > 0) {
838             poolContract.transfer(fVal);
839             raceCoinContract.addTotalEtherPool(fVal);
840         } 
841     }
842 
843 
844     function highCompose(uint256 token1, uint256 token2, uint256 token3) 
845         external
846         payable
847         whenNotPaused
848     {
849         require(msg.value >= 0.005 ether);
850         require(tokenContract.ownerOf(token1) == msg.sender);
851         require(tokenContract.ownerOf(token2) == msg.sender);
852         require(tokenContract.ownerOf(token3) == msg.sender);
853         require(!equipContract.isEquipedAny3(msg.sender, token1, token2, token3));
854 
855         uint16 protoId;
856         uint16 quality;
857         uint16 pos; 
858         uint16[13] memory fashionData = tokenContract.getFashion(token1);
859         protoId = fashionData[0];
860         quality = fashionData[1];
861         pos = fashionData[2];
862     
863 
864         fashionData = tokenContract.getFashion(token2);
865         require(quality == fashionData[1]);
866         require(pos == fashionData[2]);
867 
868         fashionData = tokenContract.getFashion(token3);
869         require(quality == fashionData[1]);
870         require(pos == fashionData[2]);
871 
872         uint256 seed = _rand();
873         uint16[13] memory attrs = _getFashionParam(seed, protoId, quality + 1, pos);
874 
875         tokenContract.destroyFashion(token1, 1);
876         tokenContract.destroyFashion(token2, 1);
877         tokenContract.destroyFashion(token3, 1);
878 
879         uint256 newTokenId = tokenContract.createFashion(msg.sender, attrs, 4);
880         _transferHelper(0.005 ether);
881 
882         if (msg.value > 0.005 ether) {
883             msg.sender.transfer(msg.value - 0.005 ether);
884         }
885 
886         emit ComposeSuccess(msg.sender, newTokenId, attrs[0], attrs[1], attrs[2]);
887     }
888 }