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
123 
124 
125 contract Random {
126     uint256 _seed;
127 
128     function _rand() internal returns (uint256) {
129         _seed = uint256(keccak256(_seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
130         return _seed;
131     }
132 
133     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
134         return uint256(keccak256(_outSeed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
135     }
136 }
137 
138 /**
139  * @title SafeMath
140  * @dev Math operations with safety checks that throw on error
141  */
142 library SafeMath {
143     /**
144     * @dev Multiplies two numbers, throws on overflow.
145     */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         if (a == 0) {
148             return 0;
149         }
150         uint256 c = a * b;
151         assert(c / a == b);
152         return c;
153     }
154 
155     /**
156     * @dev Integer division of two numbers, truncating the quotient.
157     */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         // assert(b > 0); // Solidity automatically throws when dividing by 0
160         uint256 c = a / b;
161         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
162         return c;
163     }
164 
165     /**
166     * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
167     */
168     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169         assert(b <= a);
170         return a - b;
171     }
172 
173     /**
174     * @dev Adds two numbers, throws on overflow.
175     */
176     function add(uint256 a, uint256 b) internal pure returns (uint256) {
177         uint256 c = a + b;
178         assert(c >= a);
179         return c;
180     }
181 }
182 
183 contract RaceToken is ERC721, AccessAdmin {
184     /// @dev The equipment info
185     struct Fashion {
186         uint16 equipmentId;             // 0  Equipment ID
187         uint16 quality;     	        // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
188         uint16 pos;         	        // 2  Slots: 1 Engine/2 Turbine/3 BodySystem/4 Pipe/5 Suspension/6 NO2/7 Tyre/8 Transmission/9 Car
189         uint16 production;    	        // 3  Race bonus productivity
190         uint16 attack;	                // 4  Attack
191         uint16 defense;                 // 5  Defense
192         uint16 plunder;     	        // 6  Plunder
193         uint16 productionMultiplier;    // 7  Percent value
194         uint16 attackMultiplier;     	// 8  Percent value
195         uint16 defenseMultiplier;     	// 9  Percent value
196         uint16 plunderMultiplier;     	// 10 Percent value
197         uint16 level;       	        // 11 level
198         uint16 isPercent;   	        // 12  Percent value
199     }
200 
201     /// @dev All equipments tokenArray (not exceeding 2^32-1)
202     Fashion[] public fashionArray;
203 
204     /// @dev Amount of tokens destroyed
205     uint256 destroyFashionCount;
206 
207     /// @dev Equipment token ID belong to owner address
208     mapping (uint256 => address) fashionIdToOwner;
209 
210     /// @dev Equipments owner by the owner (array)
211     mapping (address => uint256[]) ownerToFashionArray;
212 
213     /// @dev Equipment token ID search in owner array
214     mapping (uint256 => uint256) fashionIdToOwnerIndex;
215 
216     /// @dev The authorized address for each Race
217     mapping (uint256 => address) fashionIdToApprovals;
218 
219     /// @dev The authorized operators for each address
220     mapping (address => mapping (address => bool)) operatorToApprovals;
221 
222     /// @dev Trust contract
223     mapping (address => bool) actionContracts;
224 
225 	
226     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
227         actionContracts[_actionAddr] = _useful;
228     }
229 
230     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
231         return actionContracts[_actionAddr];
232     }
233 
234     /// @dev This emits when the approved address for an Race is changed or reaffirmed.
235     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
236 
237     /// @dev This emits when an operator is enabled or disabled for an owner.
238     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
239 
240     /// @dev This emits when the equipment ownership changed 
241     event Transfer(address indexed from, address indexed to, uint256 tokenId);
242 
243     /// @dev This emits when the equipment created
244     event CreateFashion(address indexed owner, uint256 tokenId, uint16 equipmentId, uint16 quality, uint16 pos, uint16 level, uint16 createType);
245 
246     /// @dev This emits when the equipment's attributes changed
247     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
248 
249     /// @dev This emits when the equipment destroyed
250     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
251     
252     function RaceToken() public {
253         addrAdmin = msg.sender;
254         fashionArray.length += 1;
255     }
256 
257     // modifier
258     /// @dev Check if token ID is valid
259     modifier isValidToken(uint256 _tokenId) {
260         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
261         require(fashionIdToOwner[_tokenId] != address(0)); 
262         _;
263     }
264 
265     modifier canTransfer(uint256 _tokenId) {
266         address owner = fashionIdToOwner[_tokenId];
267         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
268         _;
269     }
270 
271     // ERC721
272     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
273         // ERC165 || ERC721 || ERC165^ERC721
274         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
275     }
276         
277     function name() public pure returns(string) {
278         return "Race Token";
279     }
280 
281     function symbol() public pure returns(string) {
282         return "Race";
283     }
284 
285     /// @dev Search for token quantity address
286     /// @param _owner Address that needs to be searched
287     /// @return Returns token quantity
288     function balanceOf(address _owner) external view returns(uint256) {
289         require(_owner != address(0));
290         return ownerToFashionArray[_owner].length;
291     }
292 
293     /// @dev Find the owner of an Race
294     /// @param _tokenId The tokenId of Race
295     /// @return Give The address of the owner of this Race
296     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
297         return fashionIdToOwner[_tokenId];
298     }
299 
300     /// @dev Transfers the ownership of an Race from one address to another address
301     /// @param _from The current owner of the Race
302     /// @param _to The new owner
303     /// @param _tokenId The Race to transfer
304     /// @param data Additional data with no specified format, sent in call to `_to`
305     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
306         external
307         whenNotPaused
308     {
309         _safeTransferFrom(_from, _to, _tokenId, data);
310     }
311 
312     /// @dev Transfers the ownership of an Race from one address to another address
313     /// @param _from The current owner of the Race
314     /// @param _to The new owner
315     /// @param _tokenId The Race to transfer
316     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
317         external
318         whenNotPaused
319     {
320         _safeTransferFrom(_from, _to, _tokenId, "");
321     }
322 
323     /// @dev Transfer ownership of an Race, '_to' must be a vaild address, or the Race will lost
324     /// @param _from The current owner of the Race
325     /// @param _to The new owner
326     /// @param _tokenId The Race to transfer
327     function transferFrom(address _from, address _to, uint256 _tokenId)
328         external
329         whenNotPaused
330         isValidToken(_tokenId)
331         canTransfer(_tokenId)
332     {
333         address owner = fashionIdToOwner[_tokenId];
334         require(owner != address(0));
335         require(_to != address(0));
336         require(owner == _from);
337         
338         _transfer(_from, _to, _tokenId);
339     }
340 
341     /// @dev Set or reaffirm the approved address for an Race
342     /// @param _approved The new approved Race controller
343     /// @param _tokenId The Race to approve
344     function approve(address _approved, uint256 _tokenId)
345         external
346         whenNotPaused
347     {
348         address owner = fashionIdToOwner[_tokenId];
349         require(owner != address(0));
350         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
351 
352         fashionIdToApprovals[_tokenId] = _approved;
353         Approval(owner, _approved, _tokenId);
354     }
355 
356     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
357     /// @param _operator Address to add to the set of authorized operators.
358     /// @param _approved True if the operators is approved, false to revoke approval
359     function setApprovalForAll(address _operator, bool _approved) 
360         external 
361         whenNotPaused
362     {
363         operatorToApprovals[msg.sender][_operator] = _approved;
364         ApprovalForAll(msg.sender, _operator, _approved);
365     }
366 
367     /// @dev Get the approved address for a single Race
368     /// @param _tokenId The Race to find the approved address for
369     /// @return The approved address for this Race, or the zero address if there is none
370     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
371         return fashionIdToApprovals[_tokenId];
372     }
373 
374     /// @dev Query if an address is an authorized operator for another address
375     /// @param _owner The address that owns the Races
376     /// @param _operator The address that acts on behalf of the owner
377     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
378     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
379         return operatorToApprovals[_owner][_operator];
380     }
381 
382     /// @dev Count Races tracked by this contract
383     /// @return A count of valid Races tracked by this contract, where each one of
384     ///  them has an assigned and queryable owner not equal to the zero address
385     function totalSupply() external view returns (uint256) {
386         return fashionArray.length - destroyFashionCount - 1;
387     }
388 
389     /// @dev Do the real transfer with out any condition checking
390     /// @param _from The old owner of this Race(If created: 0x0)
391     /// @param _to The new owner of this Race 
392     /// @param _tokenId The tokenId of the Race
393     function _transfer(address _from, address _to, uint256 _tokenId) internal {
394         if (_from != address(0)) {
395             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
396             uint256[] storage fsArray = ownerToFashionArray[_from];
397             require(fsArray[indexFrom] == _tokenId);
398 
399             // If the Race is not the element of array, change it to with the last
400             if (indexFrom != fsArray.length - 1) {
401                 uint256 lastTokenId = fsArray[fsArray.length - 1];
402                 fsArray[indexFrom] = lastTokenId; 
403                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
404             }
405             fsArray.length -= 1; 
406             
407             if (fashionIdToApprovals[_tokenId] != address(0)) {
408                 delete fashionIdToApprovals[_tokenId];
409             }      
410         }
411 
412         // Give the Race to '_to'
413         fashionIdToOwner[_tokenId] = _to;
414         ownerToFashionArray[_to].push(_tokenId);
415         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
416         
417         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
418     }
419 
420     /// @dev Actually perform the safeTransferFrom
421     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
422         internal
423         isValidToken(_tokenId) 
424         canTransfer(_tokenId)
425     {
426         address owner = fashionIdToOwner[_tokenId];
427         require(owner != address(0));
428         require(_to != address(0));
429         require(owner == _from);
430         
431         _transfer(_from, _to, _tokenId);
432 
433         // Do the callback after everything is done to avoid reentrancy attack
434         uint256 codeSize;
435         assembly { codeSize := extcodesize(_to) }
436         if (codeSize == 0) {
437             return;
438         }
439         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
440         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
441         require(retval == 0xf0b9e5ba);
442     }
443 
444     //----------------------------------------------------------------------------------------------------------
445 
446     /// @dev Equipment creation
447     /// @param _owner Owner of the equipment created
448     /// @param _attrs Attributes of the equipment created
449     /// @return Token ID of the equipment created
450     function createFashion(address _owner, uint16[13] _attrs, uint16 _createType) 
451         external 
452         whenNotPaused
453         returns(uint256)
454     {
455         require(actionContracts[msg.sender]);
456         require(_owner != address(0));
457 
458         uint256 newFashionId = fashionArray.length;
459         require(newFashionId < 4294967296);
460 
461         fashionArray.length += 1;
462         Fashion storage fs = fashionArray[newFashionId];
463         fs.equipmentId = _attrs[0];
464         fs.quality = _attrs[1];
465         fs.pos = _attrs[2];
466         if (_attrs[3] != 0) {
467             fs.production = _attrs[3];
468         }
469         
470         if (_attrs[4] != 0) {
471             fs.attack = _attrs[4];
472         }
473 		
474 		if (_attrs[5] != 0) {
475             fs.defense = _attrs[5];
476         }
477        
478         if (_attrs[6] != 0) {
479             fs.plunder = _attrs[6];
480         }
481         
482         if (_attrs[7] != 0) {
483             fs.productionMultiplier = _attrs[7];
484         }
485 
486         if (_attrs[8] != 0) {
487             fs.attackMultiplier = _attrs[8];
488         }
489 
490         if (_attrs[9] != 0) {
491             fs.defenseMultiplier = _attrs[9];
492         }
493 
494         if (_attrs[10] != 0) {
495             fs.plunderMultiplier = _attrs[10];
496         }
497 
498         if (_attrs[11] != 0) {
499             fs.level = _attrs[11];
500         }
501 
502         if (_attrs[12] != 0) {
503             fs.isPercent = _attrs[12];
504         }
505         
506         _transfer(0, _owner, newFashionId);
507         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _attrs[11], _createType);
508         return newFashionId;
509     }
510 
511     /// @dev One specific attribute of the equipment modified
512     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
513         if (_index == 3) {
514             _fs.production = _val;
515         } else if(_index == 4) {
516             _fs.attack = _val;
517         } else if(_index == 5) {
518             _fs.defense = _val;
519         } else if(_index == 6) {
520             _fs.plunder = _val;
521         }else if(_index == 7) {
522             _fs.productionMultiplier = _val;
523         }else if(_index == 8) {
524             _fs.attackMultiplier = _val;
525         }else if(_index == 9) {
526             _fs.defenseMultiplier = _val;
527         }else if(_index == 10) {
528             _fs.plunderMultiplier = _val;
529         } else if(_index == 11) {
530             _fs.level = _val;
531         } 
532        
533     }
534 
535     /// @dev Equiment attributes modified (max 4 stats modified)
536     /// @param _tokenId Equipment Token ID
537     /// @param _idxArray Stats order that must be modified
538     /// @param _params Stat value that must be modified
539     /// @param _changeType Modification type such as enhance, socket, etc.
540     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
541         external 
542         whenNotPaused
543         isValidToken(_tokenId) 
544     {
545         require(actionContracts[msg.sender]);
546 
547         Fashion storage fs = fashionArray[_tokenId];
548         if (_idxArray[0] > 0) {
549             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
550         }
551 
552         if (_idxArray[1] > 0) {
553             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
554         }
555 
556         if (_idxArray[2] > 0) {
557             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
558         }
559 
560         if (_idxArray[3] > 0) {
561             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
562         }
563 
564         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
565     }
566 
567     /// @dev Equipment destruction
568     /// @param _tokenId Equipment Token ID
569     /// @param _deleteType Destruction type, such as craft
570     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
571         external 
572         whenNotPaused
573         isValidToken(_tokenId) 
574     {
575         require(actionContracts[msg.sender]);
576 
577         address _from = fashionIdToOwner[_tokenId];
578         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
579         uint256[] storage fsArray = ownerToFashionArray[_from]; 
580         require(fsArray[indexFrom] == _tokenId);
581 
582         if (indexFrom != fsArray.length - 1) {
583             uint256 lastTokenId = fsArray[fsArray.length - 1];
584             fsArray[indexFrom] = lastTokenId; 
585             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
586         }
587         fsArray.length -= 1; 
588 
589         fashionIdToOwner[_tokenId] = address(0);
590         delete fashionIdToOwnerIndex[_tokenId];
591         destroyFashionCount += 1;
592 
593         Transfer(_from, 0, _tokenId);
594 
595         DeleteFashion(_from, _tokenId, _deleteType);
596     }
597 
598     /// @dev Safe transfer by trust contracts
599     function safeTransferByContract(uint256 _tokenId, address _to) 
600         external
601         whenNotPaused
602     {
603         require(actionContracts[msg.sender]);
604 
605         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
606         address owner = fashionIdToOwner[_tokenId];
607         require(owner != address(0));
608         require(_to != address(0));
609         require(owner != _to);
610 
611         _transfer(owner, _to, _tokenId);
612     }
613 
614     //----------------------------------------------------------------------------------------------------------
615 
616     /// @dev Get fashion attrs by tokenId front
617     function getFashionFront(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint256[14] datas) {
618         Fashion storage fs = fashionArray[_tokenId];
619         datas[0] = fs.equipmentId;
620         datas[1] = fs.quality;
621         datas[2] = fs.pos;
622         datas[3] = fs.production;
623         datas[4] = fs.attack;
624         datas[5] = fs.defense;
625         datas[6] = fs.plunder;
626         datas[7] = fs.productionMultiplier;
627         datas[8] = fs.attackMultiplier;
628         datas[9] = fs.defenseMultiplier;
629         datas[10] = fs.plunderMultiplier;
630         datas[11] = fs.level;
631         datas[12] = fs.isPercent; 
632         datas[13] = _tokenId;      
633     }
634 
635     /// @dev Get fashion attrs by tokenId back
636     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[13] datas) {
637         Fashion storage fs = fashionArray[_tokenId];
638         datas[0] = fs.equipmentId;
639         datas[1] = fs.quality;
640         datas[2] = fs.pos;
641         datas[3] = fs.production;
642         datas[4] = fs.attack;
643         datas[5] = fs.defense;
644         datas[6] = fs.plunder;
645         datas[7] = fs.productionMultiplier;
646         datas[8] = fs.attackMultiplier;
647         datas[9] = fs.defenseMultiplier;
648         datas[10] = fs.plunderMultiplier;
649         datas[11] = fs.level;
650         datas[12] = fs.isPercent;      
651     }
652 
653 
654     /// @dev Get tokenIds and flags by owner
655     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
656         require(_owner != address(0));
657         uint256[] storage fsArray = ownerToFashionArray[_owner];
658         uint256 length = fsArray.length;
659         tokens = new uint256[](length);
660         flags = new uint32[](length);
661         for (uint256 i = 0; i < length; ++i) {
662             tokens[i] = fsArray[i];
663             Fashion storage fs = fashionArray[fsArray[i]];
664             flags[i] = uint32(uint32(fs.equipmentId) * 10000 + uint32(fs.quality) * 100 + fs.pos);
665         }
666     }
667 
668 
669     /// @dev Race token info returned based on Token ID transfered (64 at most)
670     function getFashionsAttrs(uint256[] _tokens) external view returns(uint256[] attrs) {
671         uint256 length = _tokens.length;
672         attrs = new uint256[](length * 14);
673         uint256 tokenId;
674         uint256 index;
675         for (uint256 i = 0; i < length; ++i) {
676             tokenId = _tokens[i];
677             if (fashionIdToOwner[tokenId] != address(0)) {
678                 index = i * 14;
679                 Fashion storage fs = fashionArray[tokenId];
680                 attrs[index]     = fs.equipmentId;
681 				attrs[index + 1] = fs.quality;
682                 attrs[index + 2] = fs.pos;
683                 attrs[index + 3] = fs.production;
684                 attrs[index + 4] = fs.attack;
685                 attrs[index + 5] = fs.defense;
686                 attrs[index + 6] = fs.plunder;
687                 attrs[index + 7] = fs.productionMultiplier;
688                 attrs[index + 8] = fs.attackMultiplier;
689                 attrs[index + 9] = fs.defenseMultiplier;
690                 attrs[index + 10] = fs.plunderMultiplier;
691                 attrs[index + 11] = fs.level;
692                 attrs[index + 12] = fs.isPercent; 
693                 attrs[index + 13] = tokenId;  
694             }   
695         }
696     }
697 }
698 
699 //Tournament bonus interface
700 interface IRaceCoin {
701     function addTotalEtherPool(uint256 amount) external;
702     function addPlayerToList(address player) external;
703     function increasePlayersAttribute(address player, uint16[13] param) external;
704     function reducePlayersAttribute(address player, uint16[13] param) external;
705 }
706 
707 contract ChestMining is Random, AccessService {
708     using SafeMath for uint256;
709 
710     event MiningOrderCreated(uint256 indexed index, address indexed miner, uint64 chestCnt);
711     event MiningResolved(uint256 indexed index, address indexed miner, uint64 chestCnt);
712 
713     struct MiningOrder {
714         address miner;      
715         uint64 chestCnt;    
716         uint64 tmCreate;    
717         uint64 tmResolve;   
718     }
719 
720     /// @dev Max fashion suit id
721     uint16 maxProtoId;
722     /// @dev prizepool percent
723     uint256 constant prizePoolPercent = 80;
724     /// @dev prizepool contact address
725     address poolContract;
726     /// @dev RaceToken(NFT) contract address
727     RaceToken public tokenContract;
728     /// @dev DataMining contract address
729     IDataMining public dataContract;
730     /// @dev mining order array
731     MiningOrder[] public ordersArray;
732 
733     IRaceCoin public raceCoinContract;
734 
735 
736     mapping (uint16 => uint256) public protoIdToCount;
737 
738 
739     function ChestMining(address _nftAddr, uint16 _maxProtoId) public {
740         addrAdmin = msg.sender;
741         addrService = msg.sender;
742         addrFinance = msg.sender;
743 
744         tokenContract = RaceToken(_nftAddr);
745         maxProtoId = _maxProtoId;
746         
747         MiningOrder memory order = MiningOrder(0, 0, 1, 1);
748         ordersArray.push(order);
749     }
750 
751     function() external payable {
752 
753     }
754 
755     function getOrderCount() external view returns(uint256) {
756         return ordersArray.length - 1;
757     }
758 
759     function setDataMining(address _addr) external onlyAdmin {
760         require(_addr != address(0));
761         dataContract = IDataMining(_addr);
762     }
763     
764     function setPrizePool(address _addr) external onlyAdmin {
765         require(_addr != address(0));
766         poolContract = _addr;
767         raceCoinContract = IRaceCoin(_addr);
768     }
769 
770     
771 
772     function setMaxProtoId(uint16 _maxProtoId) external onlyAdmin {
773         require(_maxProtoId > 0 && _maxProtoId < 10000);
774         require(_maxProtoId != maxProtoId);
775         maxProtoId = _maxProtoId;
776     }
777 
778     
779 
780     function setFashionSuitCount(uint16 _protoId, uint256 _cnt) external onlyAdmin {
781         require(_protoId > 0 && _protoId <= maxProtoId);
782         require(_cnt > 0 && _cnt <= 8);
783         require(protoIdToCount[_protoId] != _cnt);
784         protoIdToCount[_protoId] = _cnt;
785     }
786 
787     function _getFashionParam(uint256 _seed) internal view returns(uint16[13] attrs) {
788         uint256 curSeed = _seed;
789         // quality
790         uint256 rdm = curSeed % 10000;
791         uint16 qtyParam;
792         if (rdm < 6900) {
793             attrs[1] = 1;
794             qtyParam = 0;
795         } else if (rdm < 8700) {
796             attrs[1] = 2;
797             qtyParam = 1;
798         } else if (rdm < 9600) {
799             attrs[1] = 3;
800             qtyParam = 2;
801         } else if (rdm < 9900) {
802             attrs[1] = 4;
803             qtyParam = 4;
804         } else {
805             attrs[1] = 5;
806             qtyParam = 7;
807         }
808 
809         // protoId
810         curSeed /= 10000;
811         rdm = ((curSeed % 10000) / (9999 / maxProtoId)) + 1;
812         attrs[0] = uint16(rdm <= maxProtoId ? rdm : maxProtoId);
813 
814         // pos
815         curSeed /= 10000;
816         uint256 tmpVal = protoIdToCount[attrs[0]];
817         if (tmpVal == 0) {
818             tmpVal = 8;
819         }
820         rdm = ((curSeed % 10000) / (9999 / tmpVal)) + 1;
821         uint16 pos = uint16(rdm <= tmpVal ? rdm : tmpVal);
822         attrs[2] = pos;
823 
824         rdm = attrs[0] % 3;
825 
826         curSeed /= 10000;
827         tmpVal = (curSeed % 10000) % 21 + 90;
828 
829         if (rdm == 0) {
830             if (pos == 1) {
831                 attrs[3] = uint16((20 + qtyParam * 20) * tmpVal / 100);              // +production
832             } else if (pos == 2) {
833                 attrs[4] = uint16((100 + qtyParam * 100) * tmpVal / 100);            // +attack
834             } else if (pos == 3) {
835                 attrs[5] = uint16((70 + qtyParam * 70) * tmpVal / 100);              // +defense
836             } else if (pos == 4) {
837                 attrs[6] = uint16((500 + qtyParam * 500) * tmpVal / 100);            // +plunder
838             } else if (pos == 5) {
839                 attrs[7] = uint16((4 + qtyParam * 4) * tmpVal / 100);                // +productionMultiplier
840             } else if (pos == 6) {
841                 attrs[8] = uint16((5 + qtyParam * 5) * tmpVal / 100);                // +attackMultiplier
842             } else if (pos == 7) {
843                 attrs[9] = uint16((5 + qtyParam * 5) * tmpVal / 100);                // +defenseMultiplier
844             } else {
845                 attrs[10] = uint16((4 + qtyParam * 4) * tmpVal / 100);               // +plunderMultiplier
846             } 
847         } else if (rdm == 1) {
848             if (pos == 1) {
849                 attrs[3] = uint16((19 + qtyParam * 19) * tmpVal / 100);              // +production
850             } else if (pos == 2) {
851                 attrs[4] = uint16((90 + qtyParam * 90) * tmpVal / 100);            // +attack
852             } else if (pos == 3) {
853                 attrs[5] = uint16((63 + qtyParam * 63) * tmpVal / 100);              // +defense
854             } else if (pos == 4) {
855                 attrs[6] = uint16((450 + qtyParam * 450) * tmpVal / 100);            // +plunder
856             } else if (pos == 5) {
857                 attrs[7] = uint16((3 + qtyParam * 3) * tmpVal / 100);                // +productionMultiplier
858             } else if (pos == 6) {
859                 attrs[8] = uint16((4 + qtyParam * 4) * tmpVal / 100);                // +attackMultiplier
860             } else if (pos == 7) {
861                 attrs[9] = uint16((4 + qtyParam * 4) * tmpVal / 100);                // +defenseMultiplier
862             } else {
863                 attrs[10] = uint16((3 + qtyParam * 3) * tmpVal / 100);               // +plunderMultiplier
864             } 
865         } else {
866             if (pos == 1) {
867                 attrs[3] = uint16((21 + qtyParam * 21) * tmpVal / 100);              // +production
868             } else if (pos == 2) {
869                 attrs[4] = uint16((110 + qtyParam * 110) * tmpVal / 100);            // +attack
870             } else if (pos == 3) {
871                 attrs[5] = uint16((77 + qtyParam * 77) * tmpVal / 100);              // +defense
872             } else if (pos == 4) {
873                 attrs[6] = uint16((550 + qtyParam * 550) * tmpVal / 100);            // +plunder
874             } else if (pos == 5) {
875                 attrs[7] = uint16((5 + qtyParam * 5) * tmpVal / 100);                // +productionMultiplier
876             } else if (pos == 6) {
877                 attrs[8] = uint16((6 + qtyParam * 6) * tmpVal / 100);                // +attackMultiplier
878             } else if (pos == 7) {
879                 attrs[9] = uint16((6 + qtyParam * 6) * tmpVal / 100);                // +defenseMultiplier
880             } else {
881                 attrs[10] = uint16((5 + qtyParam * 5) * tmpVal / 100);               // +plunderMultiplier
882             } 
883         }
884         attrs[11] = 0;
885         attrs[12] = 0;
886     }
887 
888     function _addOrder(address _miner, uint64 _chestCnt) internal {
889         uint64 newOrderId = uint64(ordersArray.length);
890         ordersArray.length += 1;
891         MiningOrder storage order = ordersArray[newOrderId];
892         order.miner = _miner;
893         order.chestCnt = _chestCnt;
894         order.tmCreate = uint64(block.timestamp);
895 
896         emit MiningOrderCreated(newOrderId, _miner, _chestCnt);
897     }
898 
899     function _transferHelper(uint256 ethVal) private {
900 
901         uint256 fVal;
902         uint256 pVal;
903         
904         fVal = ethVal.mul(prizePoolPercent).div(100);
905         pVal = ethVal.sub(fVal);
906         addrFinance.transfer(pVal);
907         if (poolContract != address(0) && pVal > 0) {
908             poolContract.transfer(fVal);
909             raceCoinContract.addTotalEtherPool(fVal);
910         }        
911         
912     }
913 
914     function miningOneFree()
915         external
916         payable
917         whenNotPaused
918     {
919         require(dataContract != address(0));
920 
921         uint256 seed = _rand();
922         uint16[13] memory attrs = _getFashionParam(seed);
923 
924         require(dataContract.subFreeMineral(msg.sender));
925 
926         tokenContract.createFashion(msg.sender, attrs, 3);
927 
928         emit MiningResolved(0, msg.sender, 1);
929     }
930 
931     function miningOneSelf() 
932         external 
933         payable 
934         whenNotPaused
935     {
936         require(msg.value >= 0.01 ether);
937 
938         uint256 seed = _rand();
939         uint16[13] memory attrs = _getFashionParam(seed);
940 
941         tokenContract.createFashion(msg.sender, attrs, 2);
942         _transferHelper(0.01 ether);
943 
944         if (msg.value > 0.01 ether) {
945             msg.sender.transfer(msg.value - 0.01 ether);
946         }
947 
948         emit MiningResolved(0, msg.sender, 1);
949     }
950 
951 
952     function miningThreeSelf() 
953         external 
954         payable 
955         whenNotPaused
956     {
957         require(msg.value >= 0.03 ether);
958 
959 
960         for (uint64 i = 0; i < 3; ++i) {
961             uint256 seed = _rand();
962             uint16[13] memory attrs = _getFashionParam(seed);
963             tokenContract.createFashion(msg.sender, attrs, 2);
964         }
965 
966         _transferHelper(0.03 ether);
967 
968         if (msg.value > 0.03 ether) {
969             msg.sender.transfer(msg.value - 0.03 ether);
970         }
971 
972         emit MiningResolved(0, msg.sender, 3);
973     }
974 
975     function miningFiveSelf() 
976         external 
977         payable 
978         whenNotPaused
979     {
980         require(msg.value >= 0.0475 ether);
981 
982 
983         for (uint64 i = 0; i < 5; ++i) {
984             uint256 seed = _rand();
985             uint16[13] memory attrs = _getFashionParam(seed);
986             tokenContract.createFashion(msg.sender, attrs, 2);
987         }
988 
989         _transferHelper(0.0475 ether);
990 
991         if (msg.value > 0.0475 ether) {
992             msg.sender.transfer(msg.value - 0.0475 ether);
993         }
994 
995         emit MiningResolved(0, msg.sender, 5);
996     }
997 
998 
999     function miningTenSelf() 
1000         external 
1001         payable 
1002         whenNotPaused
1003     {
1004         require(msg.value >= 0.09 ether);
1005 
1006 
1007         for (uint64 i = 0; i < 10; ++i) {
1008             uint256 seed = _rand();
1009             uint16[13] memory attrs = _getFashionParam(seed);
1010             tokenContract.createFashion(msg.sender, attrs, 2);
1011         }
1012 
1013         _transferHelper(0.09 ether);
1014 
1015         if (msg.value > 0.09 ether) {
1016             msg.sender.transfer(msg.value - 0.09 ether);
1017         }
1018 
1019         emit MiningResolved(0, msg.sender, 10);
1020     }
1021     
1022 
1023     function miningOne() 
1024         external 
1025         payable 
1026         whenNotPaused
1027     {
1028         require(msg.value >= 0.01 ether);
1029 
1030         _addOrder(msg.sender, 1);
1031         _transferHelper(0.01 ether);
1032 
1033         if (msg.value > 0.01 ether) {
1034             msg.sender.transfer(msg.value - 0.01 ether);
1035         }
1036     }
1037 
1038     function miningThree() 
1039         external 
1040         payable 
1041         whenNotPaused
1042     {
1043         require(msg.value >= 0.03 ether);
1044 
1045         _addOrder(msg.sender, 3);
1046         _transferHelper(0.03 ether);
1047 
1048         if (msg.value > 0.03 ether) {
1049             msg.sender.transfer(msg.value - 0.03 ether);
1050         }
1051     }
1052 
1053     function miningFive() 
1054         external 
1055         payable 
1056         whenNotPaused
1057     {
1058         require(msg.value >= 0.0475 ether);
1059 
1060         _addOrder(msg.sender, 5);
1061         _transferHelper(0.0475 ether);
1062 
1063         if (msg.value > 0.0475 ether) {
1064             msg.sender.transfer(msg.value - 0.0475 ether);
1065         }
1066     }
1067 
1068     function miningTen() 
1069         external 
1070         payable 
1071         whenNotPaused
1072     {
1073         require(msg.value >= 0.09 ether);
1074         
1075         _addOrder(msg.sender, 10);
1076         _transferHelper(0.09 ether);
1077 
1078         if (msg.value > 0.09 ether) {
1079             msg.sender.transfer(msg.value - 0.09 ether);
1080         }
1081     }
1082 
1083     function miningResolve(uint256 _orderIndex, uint256 _seed) 
1084         external 
1085         onlyService
1086     {
1087         require(_orderIndex > 0 && _orderIndex < ordersArray.length);
1088         MiningOrder storage order = ordersArray[_orderIndex];
1089         require(order.tmResolve == 0);
1090         address miner = order.miner;
1091         require(miner != address(0));
1092         uint64 chestCnt = order.chestCnt;
1093         require(chestCnt >= 1 && chestCnt <= 10);
1094 
1095         uint256 rdm = _seed;
1096         uint16[13] memory attrs;
1097         for (uint64 i = 0; i < chestCnt; ++i) {
1098             rdm = _randBySeed(rdm);
1099             attrs = _getFashionParam(rdm);
1100             tokenContract.createFashion(miner, attrs, 2);
1101         }
1102         order.tmResolve = uint64(block.timestamp);
1103         emit MiningResolved(_orderIndex, miner, chestCnt);
1104     }
1105 }