1 /* ==================================================================== */
2 /* Copyright (c) 2018 The CryptoRacing Project.  All rights reserved.
3 /* 
4 /*   The first idle car race game of blockchain                 
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
103 }
104 
105 
106 
107 
108 
109 /* ==================================================================== */
110 /* equipmentId 
111 /* 10001	T1
112 /* 10002	T2
113 /* 10003	T3
114 /* 10004	T4
115 /* 10005	T5
116 /* 10006	T6 
117 /* 10007	freeCar          
118 /* ==================================================================== */
119 
120 contract RaceToken is ERC721, AccessAdmin {
121     /// @dev The equipment info
122     struct Fashion {
123         uint16 equipmentId;             // 0  Equipment ID
124         uint16 quality;     	        // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
125         uint16 pos;         	        // 2  Slots: 1 Engine/2 Turbine/3 BodySystem/4 Pipe/5 Suspension/6 NO2/7 Tyre/8 Transmission/9 Car
126         uint16 production;    	        // 3  Race bonus productivity
127         uint16 attack;	                // 4  Attack
128         uint16 defense;                 // 5  Defense
129         uint16 plunder;     	        // 6  Plunder
130         uint16 productionMultiplier;    // 7  Percent value
131         uint16 attackMultiplier;     	// 8  Percent value
132         uint16 defenseMultiplier;     	// 9  Percent value
133         uint16 plunderMultiplier;     	// 10 Percent value
134         uint16 level;       	        // 11 level
135         uint16 isPercent;   	        // 12  Percent value
136     }
137 
138     /// @dev All equipments tokenArray (not exceeding 2^32-1)
139     Fashion[] public fashionArray;
140 
141     /// @dev Amount of tokens destroyed
142     uint256 destroyFashionCount;
143 
144     /// @dev Equipment token ID belong to owner address
145     mapping (uint256 => address) fashionIdToOwner;
146 
147     /// @dev Equipments owner by the owner (array)
148     mapping (address => uint256[]) ownerToFashionArray;
149 
150     /// @dev Equipment token ID search in owner array
151     mapping (uint256 => uint256) fashionIdToOwnerIndex;
152 
153     /// @dev The authorized address for each Race
154     mapping (uint256 => address) fashionIdToApprovals;
155 
156     /// @dev The authorized operators for each address
157     mapping (address => mapping (address => bool)) operatorToApprovals;
158 
159     /// @dev Trust contract
160     mapping (address => bool) actionContracts;
161 
162 	//设置可调用当前合约的其他合约
163     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
164         actionContracts[_actionAddr] = _useful;
165     }
166 
167     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
168         return actionContracts[_actionAddr];
169     }
170 
171     /// @dev This emits when the approved address for an Race is changed or reaffirmed.
172     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
173 
174     /// @dev This emits when an operator is enabled or disabled for an owner.
175     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
176 
177     /// @dev This emits when the equipment ownership changed 
178     event Transfer(address indexed from, address indexed to, uint256 tokenId);
179 
180     /// @dev This emits when the equipment created
181     event CreateFashion(address indexed owner, uint256 tokenId, uint16 equipmentId, uint16 quality, uint16 pos, uint16 level, uint16 createType);
182 
183     /// @dev This emits when the equipment's attributes changed
184     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
185 
186     /// @dev This emits when the equipment destroyed
187     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
188     
189     function RaceToken() public {
190         addrAdmin = msg.sender;
191         fashionArray.length += 1;
192     }
193 
194     // modifier
195     /// @dev Check if token ID is valid
196     modifier isValidToken(uint256 _tokenId) {
197         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
198         require(fashionIdToOwner[_tokenId] != address(0)); 
199         _;
200     }
201 
202     modifier canTransfer(uint256 _tokenId) {
203         address owner = fashionIdToOwner[_tokenId];
204         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
205         _;
206     }
207 
208     // ERC721
209     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
210         // ERC165 || ERC721 || ERC165^ERC721
211         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
212     }
213         
214     function name() public pure returns(string) {
215         return "Race Token";
216     }
217 
218     function symbol() public pure returns(string) {
219         return "Race";
220     }
221 
222     /// @dev Search for token quantity address
223     /// @param _owner Address that needs to be searched
224     /// @return Returns token quantity
225     function balanceOf(address _owner) external view returns(uint256) {
226         require(_owner != address(0));
227         return ownerToFashionArray[_owner].length;
228     }
229 
230     /// @dev Find the owner of an Race
231     /// @param _tokenId The tokenId of Race
232     /// @return Give The address of the owner of this Race
233     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
234         return fashionIdToOwner[_tokenId];
235     }
236 
237     /// @dev Transfers the ownership of an Race from one address to another address
238     /// @param _from The current owner of the Race
239     /// @param _to The new owner
240     /// @param _tokenId The Race to transfer
241     /// @param data Additional data with no specified format, sent in call to `_to`
242     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
243         external
244         whenNotPaused
245     {
246         _safeTransferFrom(_from, _to, _tokenId, data);
247     }
248 
249     /// @dev Transfers the ownership of an Race from one address to another address
250     /// @param _from The current owner of the Race
251     /// @param _to The new owner
252     /// @param _tokenId The Race to transfer
253     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
254         external
255         whenNotPaused
256     {
257         _safeTransferFrom(_from, _to, _tokenId, "");
258     }
259 
260     /// @dev Transfer ownership of an Race, '_to' must be a vaild address, or the Race will lost
261     /// @param _from The current owner of the Race
262     /// @param _to The new owner
263     /// @param _tokenId The Race to transfer
264     function transferFrom(address _from, address _to, uint256 _tokenId)
265         external
266         whenNotPaused
267         isValidToken(_tokenId)
268         canTransfer(_tokenId)
269     {
270         address owner = fashionIdToOwner[_tokenId];
271         require(owner != address(0));
272         require(_to != address(0));
273         require(owner == _from);
274         
275         _transfer(_from, _to, _tokenId);
276     }
277 
278     /// @dev Set or reaffirm the approved address for an Race
279     /// @param _approved The new approved Race controller
280     /// @param _tokenId The Race to approve
281     function approve(address _approved, uint256 _tokenId)
282         external
283         whenNotPaused
284     {
285         address owner = fashionIdToOwner[_tokenId];
286         require(owner != address(0));
287         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
288 
289         fashionIdToApprovals[_tokenId] = _approved;
290         Approval(owner, _approved, _tokenId);
291     }
292 
293     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
294     /// @param _operator Address to add to the set of authorized operators.
295     /// @param _approved True if the operators is approved, false to revoke approval
296     function setApprovalForAll(address _operator, bool _approved) 
297         external 
298         whenNotPaused
299     {
300         operatorToApprovals[msg.sender][_operator] = _approved;
301         ApprovalForAll(msg.sender, _operator, _approved);
302     }
303 
304     /// @dev Get the approved address for a single Race
305     /// @param _tokenId The Race to find the approved address for
306     /// @return The approved address for this Race, or the zero address if there is none
307     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
308         return fashionIdToApprovals[_tokenId];
309     }
310 
311     /// @dev Query if an address is an authorized operator for another address
312     /// @param _owner The address that owns the Races
313     /// @param _operator The address that acts on behalf of the owner
314     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
315     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
316         return operatorToApprovals[_owner][_operator];
317     }
318 
319     /// @dev Count Races tracked by this contract
320     /// @return A count of valid Races tracked by this contract, where each one of
321     ///  them has an assigned and queryable owner not equal to the zero address
322     function totalSupply() external view returns (uint256) {
323         return fashionArray.length - destroyFashionCount - 1;
324     }
325 
326     /// @dev Do the real transfer with out any condition checking
327     /// @param _from The old owner of this Race(If created: 0x0)
328     /// @param _to The new owner of this Race 
329     /// @param _tokenId The tokenId of the Race
330     function _transfer(address _from, address _to, uint256 _tokenId) internal {
331         if (_from != address(0)) {
332             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
333             uint256[] storage fsArray = ownerToFashionArray[_from];
334             require(fsArray[indexFrom] == _tokenId);
335 
336             // If the Race is not the element of array, change it to with the last
337             if (indexFrom != fsArray.length - 1) {
338                 uint256 lastTokenId = fsArray[fsArray.length - 1];
339                 fsArray[indexFrom] = lastTokenId; 
340                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
341             }
342             fsArray.length -= 1; 
343             
344             if (fashionIdToApprovals[_tokenId] != address(0)) {
345                 delete fashionIdToApprovals[_tokenId];
346             }      
347         }
348 
349         // Give the Race to '_to'
350         fashionIdToOwner[_tokenId] = _to;
351         ownerToFashionArray[_to].push(_tokenId);
352         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
353         
354         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
355     }
356 
357     /// @dev Actually perform the safeTransferFrom
358     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
359         internal
360         isValidToken(_tokenId) 
361         canTransfer(_tokenId)
362     {
363         address owner = fashionIdToOwner[_tokenId];
364         require(owner != address(0));
365         require(_to != address(0));
366         require(owner == _from);
367         
368         _transfer(_from, _to, _tokenId);
369 
370         // Do the callback after everything is done to avoid reentrancy attack
371         uint256 codeSize;
372         assembly { codeSize := extcodesize(_to) }
373         if (codeSize == 0) {
374             return;
375         }
376         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
377         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
378         require(retval == 0xf0b9e5ba);
379     }
380 
381     //----------------------------------------------------------------------------------------------------------
382 
383     /// @dev Equipment creation
384     /// @param _owner Owner of the equipment created
385     /// @param _attrs Attributes of the equipment created
386     /// @return Token ID of the equipment created
387     function createFashion(address _owner, uint16[13] _attrs, uint16 _createType) 
388         external 
389         whenNotPaused
390         returns(uint256)
391     {
392         require(actionContracts[msg.sender]);
393         require(_owner != address(0));
394 
395         uint256 newFashionId = fashionArray.length;
396         require(newFashionId < 4294967296);
397 
398         fashionArray.length += 1;
399         Fashion storage fs = fashionArray[newFashionId];
400         fs.equipmentId = _attrs[0];
401         fs.quality = _attrs[1];
402         fs.pos = _attrs[2];
403         if (_attrs[3] != 0) {
404             fs.production = _attrs[3];
405         }
406         
407         if (_attrs[4] != 0) {
408             fs.attack = _attrs[4];
409         }
410 		
411 		if (_attrs[5] != 0) {
412             fs.defense = _attrs[5];
413         }
414        
415         if (_attrs[6] != 0) {
416             fs.plunder = _attrs[6];
417         }
418         
419         if (_attrs[7] != 0) {
420             fs.productionMultiplier = _attrs[7];
421         }
422 
423         if (_attrs[8] != 0) {
424             fs.attackMultiplier = _attrs[8];
425         }
426 
427         if (_attrs[9] != 0) {
428             fs.defenseMultiplier = _attrs[9];
429         }
430 
431         if (_attrs[10] != 0) {
432             fs.plunderMultiplier = _attrs[10];
433         }
434 
435         if (_attrs[11] != 0) {
436             fs.level = _attrs[11];
437         }
438 
439         if (_attrs[12] != 0) {
440             fs.isPercent = _attrs[12];
441         }
442         
443         _transfer(0, _owner, newFashionId);
444         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _attrs[11], _createType);
445         return newFashionId;
446     }
447 
448     /// @dev One specific attribute of the equipment modified
449     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
450         if (_index == 3) {
451             _fs.production = _val;
452         } else if(_index == 4) {
453             _fs.attack = _val;
454         } else if(_index == 5) {
455             _fs.defense = _val;
456         } else if(_index == 6) {
457             _fs.plunder = _val;
458         }else if(_index == 7) {
459             _fs.productionMultiplier = _val;
460         }else if(_index == 8) {
461             _fs.attackMultiplier = _val;
462         }else if(_index == 9) {
463             _fs.defenseMultiplier = _val;
464         }else if(_index == 10) {
465             _fs.plunderMultiplier = _val;
466         } else if(_index == 11) {
467             _fs.level = _val;
468         } 
469        
470     }
471 
472     /// @dev Equiment attributes modified (max 4 stats modified)
473     /// @param _tokenId Equipment Token ID
474     /// @param _idxArray Stats order that must be modified
475     /// @param _params Stat value that must be modified
476     /// @param _changeType Modification type such as enhance, socket, etc.
477     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
478         external 
479         whenNotPaused
480         isValidToken(_tokenId) 
481     {
482         require(actionContracts[msg.sender]);
483 
484         Fashion storage fs = fashionArray[_tokenId];
485         if (_idxArray[0] > 0) {
486             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
487         }
488 
489         if (_idxArray[1] > 0) {
490             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
491         }
492 
493         if (_idxArray[2] > 0) {
494             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
495         }
496 
497         if (_idxArray[3] > 0) {
498             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
499         }
500 
501         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
502     }
503 
504     /// @dev Equipment destruction
505     /// @param _tokenId Equipment Token ID
506     /// @param _deleteType Destruction type, such as craft
507     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
508         external 
509         whenNotPaused
510         isValidToken(_tokenId) 
511     {
512         require(actionContracts[msg.sender]);
513 
514         address _from = fashionIdToOwner[_tokenId];
515         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
516         uint256[] storage fsArray = ownerToFashionArray[_from]; 
517         require(fsArray[indexFrom] == _tokenId);
518 
519         if (indexFrom != fsArray.length - 1) {
520             uint256 lastTokenId = fsArray[fsArray.length - 1];
521             fsArray[indexFrom] = lastTokenId; 
522             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
523         }
524         fsArray.length -= 1; 
525 
526         fashionIdToOwner[_tokenId] = address(0);
527         delete fashionIdToOwnerIndex[_tokenId];
528         destroyFashionCount += 1;
529 
530         Transfer(_from, 0, _tokenId);
531 
532         DeleteFashion(_from, _tokenId, _deleteType);
533     }
534 
535     /// @dev Safe transfer by trust contracts
536     function safeTransferByContract(uint256 _tokenId, address _to) 
537         external
538         whenNotPaused
539     {
540         require(actionContracts[msg.sender]);
541 
542         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
543         address owner = fashionIdToOwner[_tokenId];
544         require(owner != address(0));
545         require(_to != address(0));
546         require(owner != _to);
547 
548         _transfer(owner, _to, _tokenId);
549     }
550 
551     //----------------------------------------------------------------------------------------------------------
552 
553 	/// @dev Get fashion attrs by tokenId front
554     function getFashionFront(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint256[14] datas) {
555         Fashion storage fs = fashionArray[_tokenId];
556         datas[0] = fs.equipmentId;
557         datas[1] = fs.quality;
558         datas[2] = fs.pos;
559         datas[3] = fs.production;
560         datas[4] = fs.attack;
561         datas[5] = fs.defense;
562         datas[6] = fs.plunder;
563         datas[7] = fs.productionMultiplier;
564         datas[8] = fs.attackMultiplier;
565         datas[9] = fs.defenseMultiplier;
566         datas[10] = fs.plunderMultiplier;
567         datas[11] = fs.level;
568         datas[12] = fs.isPercent; 
569         datas[13] = _tokenId;      
570     }
571 
572     /// @dev Get fashion attrs by tokenId back
573     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[13] datas) {
574         Fashion storage fs = fashionArray[_tokenId];
575         datas[0] = fs.equipmentId;
576         datas[1] = fs.quality;
577         datas[2] = fs.pos;
578         datas[3] = fs.production;
579         datas[4] = fs.attack;
580         datas[5] = fs.defense;
581         datas[6] = fs.plunder;
582         datas[7] = fs.productionMultiplier;
583         datas[8] = fs.attackMultiplier;
584         datas[9] = fs.defenseMultiplier;
585         datas[10] = fs.plunderMultiplier;
586         datas[11] = fs.level;
587         datas[12] = fs.isPercent;      
588     }
589 
590 
591     /// @dev Get tokenIds and flags by owner
592     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
593         require(_owner != address(0));
594         uint256[] storage fsArray = ownerToFashionArray[_owner];
595         uint256 length = fsArray.length;
596         tokens = new uint256[](length);
597         flags = new uint32[](length);
598         for (uint256 i = 0; i < length; ++i) {
599             tokens[i] = fsArray[i];
600             Fashion storage fs = fashionArray[fsArray[i]];
601             flags[i] = uint32(uint32(fs.equipmentId) * 10000 + uint32(fs.quality) * 100 + fs.pos);
602         }
603     }
604 
605 
606     /// @dev Race token info returned based on Token ID transfered (64 at most)
607     function getFashionsAttrs(uint256[] _tokens) external view returns(uint256[] attrs) {
608         uint256 length = _tokens.length;
609         attrs = new uint256[](length * 14);
610         uint256 tokenId;
611         uint256 index;
612         for (uint256 i = 0; i < length; ++i) {
613             tokenId = _tokens[i];
614             if (fashionIdToOwner[tokenId] != address(0)) {
615                 index = i * 14;
616                 Fashion storage fs = fashionArray[tokenId];
617                 attrs[index]     = fs.equipmentId;
618 				attrs[index + 1] = fs.quality;
619                 attrs[index + 2] = fs.pos;
620                 attrs[index + 3] = fs.production;
621                 attrs[index + 4] = fs.attack;
622                 attrs[index + 5] = fs.defense;
623                 attrs[index + 6] = fs.plunder;
624                 attrs[index + 7] = fs.productionMultiplier;
625                 attrs[index + 8] = fs.attackMultiplier;
626                 attrs[index + 9] = fs.defenseMultiplier;
627                 attrs[index + 10] = fs.plunderMultiplier;
628                 attrs[index + 11] = fs.level;
629                 attrs[index + 12] = fs.isPercent; 
630                 attrs[index + 13] = tokenId;  
631             }   
632         }
633     }
634 }
635 
636 
637 //Tournament bonus interface
638 interface IRaceCoin {
639     function addTotalEtherPool(uint256 amount) external;
640     function addPlayerToList(address player) external;
641     function increasePlayersAttribute(address player, uint16[13] param) external;
642     function reducePlayersAttribute(address player, uint16[13] param) external;
643 }
644 
645 contract CarsPresell is AccessService {
646 
647     using SafeMath for uint256;
648     
649     RaceToken tokenContract;
650 
651     IRaceCoin public raceCoinContract;
652 
653    
654     //Bonus pool address
655     address poolContract;
656 
657     ///Bonus pool ratio
658     uint256 constant prizeGoldPercent = 80;
659 
660     //referer
661     uint256 constant refererPercent = 5;
662 
663     //The maximum number of cars per quality
664 	uint16 private carCountsLimit;
665 
666 
667    
668 
669 
670 
671     mapping (uint16 => uint16) carPresellCounter;
672     mapping (address => uint16[]) presellLimit;
673 
674     mapping (address => uint16) freeCarCount;
675 
676     event CarPreSelled(address indexed buyer, uint16 equipmentId);
677     event FreeCarsObtained(address indexed buyer, uint16 equipmentId);
678 
679     event PresellReferalGain(address referal, address player, uint256 amount);
680 
681     function CarsPresell(address _nftAddr) public {
682         addrAdmin = msg.sender;
683         addrService = msg.sender;
684         addrFinance = msg.sender;
685 
686         tokenContract = RaceToken(_nftAddr);
687 		
688 		//Maximum number of vehicles per class
689 		carCountsLimit = 500;
690 
691         carPresellCounter[10001] = 100;
692         carPresellCounter[10002] = 100;
693         carPresellCounter[10003] = 100;
694         carPresellCounter[10004] = 100;
695         carPresellCounter[10005] = 100;
696 		carPresellCounter[10006] = 100;
697 
698     }
699 
700     function() external payable {
701 
702     }
703 
704     function setRaceTokenAddr(address _nftAddr) external onlyAdmin {
705         tokenContract = RaceToken(_nftAddr);
706     }
707 
708    
709     //Set up tournament bonus address
710     function setRaceCoin(address _addr) external onlyAdmin {
711         require(_addr != address(0));
712         poolContract = _addr;
713         raceCoinContract = IRaceCoin(_addr);
714     }
715 	
716 	
717 	//Increase the number of pre-sale cars, the maximum limit of each vehicle is 500 vehicles.
718 	function setCarCounts(uint16 _carId, uint16 _carCounts) external onlyAdmin {
719 		require( carPresellCounter[_carId] <= carCountsLimit);
720 		uint16 curSupply = carPresellCounter[_carId];
721 		require((curSupply + _carCounts)<= carCountsLimit);
722         carPresellCounter[_carId] = curSupply + _carCounts;
723     }
724 
725 
726     //Get free cars
727     function freeCar(uint16 _equipmentId)
728         external
729         payable
730         whenNotPaused 
731     {
732         require(freeCarCount[msg.sender] != 1);
733 
734         uint256 payBack = 0;
735 
736         uint16[] storage buyArray = presellLimit[msg.sender];
737 
738         if(_equipmentId == 10007){
739             require(msg.value >= 0.0 ether);
740             payBack = (msg.value - 0.0 ether);
741             uint16[13] memory param0 = [10007, 7, 9, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0];
742             tokenContract.createFashion(msg.sender, param0, 1);
743             raceCoinContract.increasePlayersAttribute(msg.sender, param0);
744             buyArray.push(10007);
745 
746             if (payBack > 0) {
747                 msg.sender.transfer(payBack);
748             }
749 
750             freeCarCount[msg.sender] = 1;
751 
752             raceCoinContract.addPlayerToList(msg.sender);
753 
754             emit FreeCarsObtained(msg.sender,_equipmentId);
755         }
756     }
757 
758     //Whether a free car has been received.
759     function getFreeCarCount(address _owner) external view returns(uint16){
760 
761         require(_owner != address(0));
762         if(freeCarCount[msg.sender] != 1){
763             freeCarCount[msg.sender] = 0;
764         }
765 
766         return  freeCarCount[msg.sender];
767     }
768 
769 
770 
771     function UpdateCurrentCarCount(uint16 _equipmentId,uint16 curSupply) internal {
772         carPresellCounter[_equipmentId] = (curSupply - 1);
773     }
774 
775 
776     function carPresell(address referer,uint16 _equipmentId) 
777         external
778         payable
779         whenNotPaused 
780     {
781         uint16 curSupply = carPresellCounter[_equipmentId];
782         require(curSupply > 0);
783         uint16[] storage buyArray = presellLimit[msg.sender];
784         uint256 curBuyCnt = buyArray.length;
785 		
786         require(curBuyCnt < 21);
787 
788         uint256 payBack = 0;
789         if (_equipmentId == 10001) {
790             require(msg.value >= 0.075 ether);
791             payBack = (msg.value - 0.075 ether);
792             uint16[13] memory param1 = [10001, 1, 9, 10, 0, 0, 0, 5, 0, 0, 0, 0, 0];       // 10 productivity 5% productivity plus
793             tokenContract.createFashion(msg.sender, param1, 1);
794             raceCoinContract.increasePlayersAttribute(msg.sender, param1);
795             buyArray.push(10001);
796             raceCoinContract.addPlayerToList(msg.sender);
797         } else if(_equipmentId == 10002) {
798             require(msg.value >= 0.112 ether);
799             payBack = (msg.value - 0.112 ether);
800             uint16[13] memory param2 = [10002, 2, 9, 15, 0, 0, 0, 8, 5, 0, 0, 0, 0];       // 15 productivity 8% productivity plus 5% attack bonus
801             tokenContract.createFashion(msg.sender, param2, 1);
802             raceCoinContract.increasePlayersAttribute(msg.sender, param2);
803             buyArray.push(10002);
804             raceCoinContract.addPlayerToList(msg.sender);
805         } else if(_equipmentId == 10003) {
806             require(msg.value >= 0.225 ether);
807             payBack = (msg.value - 0.225 ether);
808             uint16[13] memory param3 = [10003, 3, 9, 30, 0, 0, 0, 15, 10, 5, 0, 0, 0];        // 30 productivity 15% productivity plus 10% attack plus 5% defense plus
809             tokenContract.createFashion(msg.sender, param3, 1);
810             raceCoinContract.increasePlayersAttribute(msg.sender, param3);
811             buyArray.push(10003);
812             raceCoinContract.addPlayerToList(msg.sender);
813         } else if(_equipmentId == 10004) {
814             require(msg.value >= 0.563 ether);
815             payBack = (msg.value - 0.563 ether);
816             uint16[13] memory param4 = [10004, 4, 9, 75, 0, 0, 0, 38, 25, 13, 5, 0, 0];        // 75 productivity 38% productivity plus 25% attack plus 13% defense plus 5% predatory addition.
817             tokenContract.createFashion(msg.sender, param4, 1);
818             raceCoinContract.increasePlayersAttribute(msg.sender, param4);
819             buyArray.push(10004);
820             raceCoinContract.addPlayerToList(msg.sender);
821         } else if(_equipmentId == 10005){
822             require(msg.value >= 1.7 ether);
823             payBack = (msg.value - 1.7 ether);
824             uint16[13] memory param5 = [10005, 5, 9, 225, 0, 0, 0, 113, 75, 38, 15, 0, 0];      // 225 productivity 113% productivity plus 75% attack plus 38% defense plus 15% predatory addition.
825             tokenContract.createFashion(msg.sender, param5, 1);
826             raceCoinContract.increasePlayersAttribute(msg.sender, param5);
827             buyArray.push(10005);
828             raceCoinContract.addPlayerToList(msg.sender);
829         }else if(_equipmentId == 10006){
830             require(msg.value >= 6 ether);
831             payBack = (msg.value - 6 ether);
832             uint16[13] memory param6 = [10006, 6, 9, 788, 0, 0, 0, 394, 263, 131, 53, 0, 0];      // 788 productivity 394% productivity plus 263% attack plus 131% defense plus 53% predatory addition.
833             tokenContract.createFashion(msg.sender, param6, 1);
834             raceCoinContract.increasePlayersAttribute(msg.sender, param6);
835             buyArray.push(10006);
836             raceCoinContract.addPlayerToList(msg.sender);
837         }
838 
839         UpdateCurrentCarCount(_equipmentId,curSupply);
840 
841 
842         emit CarPreSelled(msg.sender, _equipmentId);
843 
844 
845 
846         uint256 ethVal = msg.value.sub(payBack);
847 
848         uint256 referalDivs;
849         if (referer != address(0) && referer != msg.sender) {
850             referalDivs = ethVal.mul(refererPercent).div(100); // 5%
851             referer.transfer(referalDivs);
852             emit PresellReferalGain(referer, msg.sender, referalDivs);
853         }
854 
855 
856         //Capital injection into capital pool
857         if (poolContract != address(0) && ethVal.mul(prizeGoldPercent).div(100) > 0) {
858             poolContract.transfer(ethVal.mul(prizeGoldPercent).div(100));
859             raceCoinContract.addTotalEtherPool(ethVal.mul(prizeGoldPercent).div(100));
860         }
861 
862         //The rest of the account is entered into the developer account.
863         if(referalDivs > 0){
864             addrFinance.transfer(ethVal.sub(ethVal.mul(prizeGoldPercent).div(100)).sub(ethVal.mul(refererPercent).div(100)));
865         }else{
866             addrFinance.transfer(ethVal.sub(ethVal.mul(prizeGoldPercent).div(100)));
867         }
868         
869 
870            
871         if (payBack > 0) {
872             msg.sender.transfer(payBack);
873         }
874     }
875 
876     function withdraw() 
877         external 
878     {
879         require(msg.sender == addrFinance || msg.sender == addrAdmin);
880         addrFinance.transfer(this.balance);
881     }
882 
883     function getCarCanPresellCount() external view returns (uint16[6] cntArray) {
884         cntArray[0] = carPresellCounter[10001];
885         cntArray[1] = carPresellCounter[10002];
886         cntArray[2] = carPresellCounter[10003];
887         cntArray[3] = carPresellCounter[10004];
888         cntArray[4] = carPresellCounter[10005];
889 		cntArray[5] = carPresellCounter[10006];  		
890     }
891 
892     function getBuyCount(address _owner) external view returns (uint32) {
893         return uint32(presellLimit[_owner].length);
894     }
895 
896     function getBuyArray(address _owner) external view returns (uint16[]) {
897         uint16[] storage buyArray = presellLimit[_owner];
898         return buyArray;
899     }
900 }
901 
902 /**
903  * @title SafeMath
904  * @dev Math operations with safety checks that throw on error
905  */
906 library SafeMath {
907     /**
908     * @dev Multiplies two numbers, throws on overflow.
909     */
910     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
911         if (a == 0) {
912             return 0;
913         }
914         uint256 c = a * b;
915         assert(c / a == b);
916         return c;
917     }
918 
919     /**
920     * @dev Integer division of two numbers, truncating the quotient.
921     */
922     function div(uint256 a, uint256 b) internal pure returns (uint256) {
923         // assert(b > 0); // Solidity automatically throws when dividing by 0
924         uint256 c = a / b;
925         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
926         return c;
927     }
928 
929     /**
930     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
931     */
932     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
933         assert(b <= a);
934         return a - b;
935     }
936 
937     /**
938     * @dev Adds two numbers, throws on overflow.
939     */
940     function add(uint256 a, uint256 b) internal pure returns (uint256) {
941         uint256 c = a + b;
942         assert(c >= a);
943         return c;
944     }
945 }