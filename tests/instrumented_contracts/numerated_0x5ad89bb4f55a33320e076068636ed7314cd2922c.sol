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
78 /* ==================================================================== */
79 /* equipmentId 
80 /* 10001	T1
81 /* 10002	T2
82 /* 10003	T3
83 /* 10004	T4
84 /* 10005	T5
85 /* 10006	T6 
86 /* 10007	freeCar          
87 /* ==================================================================== */
88 
89 contract RaceToken is ERC721, AccessAdmin {
90     /// @dev The equipment info
91     struct Fashion {
92         uint16 equipmentId;             // 0  Equipment ID
93         uint16 quality;     	        // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary  If car  /1 T1 /2 T2 /3 T3 /4 T4 /5 T5 /6 T6  /7 free
94         uint16 pos;         	        // 2  Slots: 1 Engine/2 Turbine/3 BodySystem/4 Pipe/5 Suspension/6 NO2/7 Tyre/8 Transmission/9 Car
95         uint16 production;    	        // 3  Race bonus productivity
96         uint16 attack;	                // 4  Attack
97         uint16 defense;                 // 5  Defense
98         uint16 plunder;     	        // 6  Plunder
99         uint16 productionMultiplier;    // 7  Percent value
100         uint16 attackMultiplier;     	// 8  Percent value
101         uint16 defenseMultiplier;     	// 9  Percent value
102         uint16 plunderMultiplier;     	// 10 Percent value
103         uint16 level;       	        // 11 level
104         uint16 isPercent;   	        // 12  Percent value
105     }
106 
107     /// @dev All equipments tokenArray (not exceeding 2^32-1)
108     Fashion[] public fashionArray;
109 
110     /// @dev Amount of tokens destroyed
111     uint256 destroyFashionCount;
112 
113     /// @dev Equipment token ID belong to owner address
114     mapping (uint256 => address) fashionIdToOwner;
115 
116     /// @dev Equipments owner by the owner (array)
117     mapping (address => uint256[]) ownerToFashionArray;
118 
119     /// @dev Equipment token ID search in owner array
120     mapping (uint256 => uint256) fashionIdToOwnerIndex;
121 
122     /// @dev The authorized address for each Race
123     mapping (uint256 => address) fashionIdToApprovals;
124 
125     /// @dev The authorized operators for each address
126     mapping (address => mapping (address => bool)) operatorToApprovals;
127 
128     /// @dev Trust contract
129     mapping (address => bool) actionContracts;
130 
131 	
132     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
133         actionContracts[_actionAddr] = _useful;
134     }
135 
136     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
137         return actionContracts[_actionAddr];
138     }
139 
140     /// @dev This emits when the approved address for an Race is changed or reaffirmed.
141     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
142 
143     /// @dev This emits when an operator is enabled or disabled for an owner.
144     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
145 
146     /// @dev This emits when the equipment ownership changed 
147     event Transfer(address indexed from, address indexed to, uint256 tokenId);
148 
149     /// @dev This emits when the equipment created
150     event CreateFashion(address indexed owner, uint256 tokenId, uint16 equipmentId, uint16 quality, uint16 pos, uint16 level, uint16 createType);
151 
152     /// @dev This emits when the equipment's attributes changed
153     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
154 
155     /// @dev This emits when the equipment destroyed
156     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
157     
158     function RaceToken() public {
159         addrAdmin = msg.sender;
160         fashionArray.length += 1;
161     }
162 
163     // modifier
164     /// @dev Check if token ID is valid
165     modifier isValidToken(uint256 _tokenId) {
166         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
167         require(fashionIdToOwner[_tokenId] != address(0)); 
168         _;
169     }
170 
171     modifier canTransfer(uint256 _tokenId) {
172         address owner = fashionIdToOwner[_tokenId];
173         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
174         _;
175     }
176 
177     // ERC721
178     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
179         // ERC165 || ERC721 || ERC165^ERC721
180         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
181     }
182         
183     function name() public pure returns(string) {
184         return "Race Token";
185     }
186 
187     function symbol() public pure returns(string) {
188         return "Race";
189     }
190 
191     /// @dev Search for token quantity address
192     /// @param _owner Address that needs to be searched
193     /// @return Returns token quantity
194     function balanceOf(address _owner) external view returns(uint256) {
195         require(_owner != address(0));
196         return ownerToFashionArray[_owner].length;
197     }
198 
199     /// @dev Find the owner of an Race
200     /// @param _tokenId The tokenId of Race
201     /// @return Give The address of the owner of this Race
202     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
203         return fashionIdToOwner[_tokenId];
204     }
205 
206     /// @dev Transfers the ownership of an Race from one address to another address
207     /// @param _from The current owner of the Race
208     /// @param _to The new owner
209     /// @param _tokenId The Race to transfer
210     /// @param data Additional data with no specified format, sent in call to `_to`
211     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
212         external
213         whenNotPaused
214     {
215         _safeTransferFrom(_from, _to, _tokenId, data);
216     }
217 
218     /// @dev Transfers the ownership of an Race from one address to another address
219     /// @param _from The current owner of the Race
220     /// @param _to The new owner
221     /// @param _tokenId The Race to transfer
222     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
223         external
224         whenNotPaused
225     {
226         _safeTransferFrom(_from, _to, _tokenId, "");
227     }
228 
229     /// @dev Transfer ownership of an Race, '_to' must be a vaild address, or the Race will lost
230     /// @param _from The current owner of the Race
231     /// @param _to The new owner
232     /// @param _tokenId The Race to transfer
233     function transferFrom(address _from, address _to, uint256 _tokenId)
234         external
235         whenNotPaused
236         isValidToken(_tokenId)
237         canTransfer(_tokenId)
238     {
239         address owner = fashionIdToOwner[_tokenId];
240         require(owner != address(0));
241         require(_to != address(0));
242         require(owner == _from);
243         
244         _transfer(_from, _to, _tokenId);
245     }
246 
247     /// @dev Set or reaffirm the approved address for an Race
248     /// @param _approved The new approved Race controller
249     /// @param _tokenId The Race to approve
250     function approve(address _approved, uint256 _tokenId)
251         external
252         whenNotPaused
253     {
254         address owner = fashionIdToOwner[_tokenId];
255         require(owner != address(0));
256         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
257 
258         fashionIdToApprovals[_tokenId] = _approved;
259         Approval(owner, _approved, _tokenId);
260     }
261 
262     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
263     /// @param _operator Address to add to the set of authorized operators.
264     /// @param _approved True if the operators is approved, false to revoke approval
265     function setApprovalForAll(address _operator, bool _approved) 
266         external 
267         whenNotPaused
268     {
269         operatorToApprovals[msg.sender][_operator] = _approved;
270         ApprovalForAll(msg.sender, _operator, _approved);
271     }
272 
273     /// @dev Get the approved address for a single Race
274     /// @param _tokenId The Race to find the approved address for
275     /// @return The approved address for this Race, or the zero address if there is none
276     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
277         return fashionIdToApprovals[_tokenId];
278     }
279 
280     /// @dev Query if an address is an authorized operator for another address
281     /// @param _owner The address that owns the Races
282     /// @param _operator The address that acts on behalf of the owner
283     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
284     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
285         return operatorToApprovals[_owner][_operator];
286     }
287 
288     /// @dev Count Races tracked by this contract
289     /// @return A count of valid Races tracked by this contract, where each one of
290     ///  them has an assigned and queryable owner not equal to the zero address
291     function totalSupply() external view returns (uint256) {
292         return fashionArray.length - destroyFashionCount - 1;
293     }
294 
295     /// @dev Do the real transfer with out any condition checking
296     /// @param _from The old owner of this Race(If created: 0x0)
297     /// @param _to The new owner of this Race 
298     /// @param _tokenId The tokenId of the Race
299     function _transfer(address _from, address _to, uint256 _tokenId) internal {
300         if (_from != address(0)) {
301             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
302             uint256[] storage fsArray = ownerToFashionArray[_from];
303             require(fsArray[indexFrom] == _tokenId);
304 
305             // If the Race is not the element of array, change it to with the last
306             if (indexFrom != fsArray.length - 1) {
307                 uint256 lastTokenId = fsArray[fsArray.length - 1];
308                 fsArray[indexFrom] = lastTokenId; 
309                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
310             }
311             fsArray.length -= 1; 
312             
313             if (fashionIdToApprovals[_tokenId] != address(0)) {
314                 delete fashionIdToApprovals[_tokenId];
315             }      
316         }
317 
318         // Give the Race to '_to'
319         fashionIdToOwner[_tokenId] = _to;
320         ownerToFashionArray[_to].push(_tokenId);
321         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
322         
323         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
324     }
325 
326     /// @dev Actually perform the safeTransferFrom
327     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
328         internal
329         isValidToken(_tokenId) 
330         canTransfer(_tokenId)
331     {
332         address owner = fashionIdToOwner[_tokenId];
333         require(owner != address(0));
334         require(_to != address(0));
335         require(owner == _from);
336         
337         _transfer(_from, _to, _tokenId);
338 
339         // Do the callback after everything is done to avoid reentrancy attack
340         uint256 codeSize;
341         assembly { codeSize := extcodesize(_to) }
342         if (codeSize == 0) {
343             return;
344         }
345         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
346         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
347         require(retval == 0xf0b9e5ba);
348     }
349 
350     //----------------------------------------------------------------------------------------------------------
351 
352     /// @dev Equipment creation
353     /// @param _owner Owner of the equipment created
354     /// @param _attrs Attributes of the equipment created
355     /// @return Token ID of the equipment created
356     function createFashion(address _owner, uint16[13] _attrs, uint16 _createType) 
357         external 
358         whenNotPaused
359         returns(uint256)
360     {
361         require(actionContracts[msg.sender]);
362         require(_owner != address(0));
363 
364         uint256 newFashionId = fashionArray.length;
365         require(newFashionId < 4294967296);
366 
367         fashionArray.length += 1;
368         Fashion storage fs = fashionArray[newFashionId];
369         fs.equipmentId = _attrs[0];
370         fs.quality = _attrs[1];
371         fs.pos = _attrs[2];
372         if (_attrs[3] != 0) {
373             fs.production = _attrs[3];
374         }
375         
376         if (_attrs[4] != 0) {
377             fs.attack = _attrs[4];
378         }
379 		
380 		if (_attrs[5] != 0) {
381             fs.defense = _attrs[5];
382         }
383        
384         if (_attrs[6] != 0) {
385             fs.plunder = _attrs[6];
386         }
387         
388         if (_attrs[7] != 0) {
389             fs.productionMultiplier = _attrs[7];
390         }
391 
392         if (_attrs[8] != 0) {
393             fs.attackMultiplier = _attrs[8];
394         }
395 
396         if (_attrs[9] != 0) {
397             fs.defenseMultiplier = _attrs[9];
398         }
399 
400         if (_attrs[10] != 0) {
401             fs.plunderMultiplier = _attrs[10];
402         }
403 
404         if (_attrs[11] != 0) {
405             fs.level = _attrs[11];
406         }
407 
408         if (_attrs[12] != 0) {
409             fs.isPercent = _attrs[12];
410         }
411         
412         _transfer(0, _owner, newFashionId);
413         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _attrs[11], _createType);
414         return newFashionId;
415     }
416 
417     /// @dev One specific attribute of the equipment modified
418     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
419         if (_index == 3) {
420             _fs.production = _val;
421         } else if(_index == 4) {
422             _fs.attack = _val;
423         } else if(_index == 5) {
424             _fs.defense = _val;
425         } else if(_index == 6) {
426             _fs.plunder = _val;
427         }else if(_index == 7) {
428             _fs.productionMultiplier = _val;
429         }else if(_index == 8) {
430             _fs.attackMultiplier = _val;
431         }else if(_index == 9) {
432             _fs.defenseMultiplier = _val;
433         }else if(_index == 10) {
434             _fs.plunderMultiplier = _val;
435         } else if(_index == 11) {
436             _fs.level = _val;
437         } 
438        
439     }
440 
441     /// @dev Equiment attributes modified (max 4 stats modified)
442     /// @param _tokenId Equipment Token ID
443     /// @param _idxArray Stats order that must be modified
444     /// @param _params Stat value that must be modified
445     /// @param _changeType Modification type such as enhance, socket, etc.
446     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
447         external 
448         whenNotPaused
449         isValidToken(_tokenId) 
450     {
451         require(actionContracts[msg.sender]);
452 
453         Fashion storage fs = fashionArray[_tokenId];
454         if (_idxArray[0] > 0) {
455             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
456         }
457 
458         if (_idxArray[1] > 0) {
459             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
460         }
461 
462         if (_idxArray[2] > 0) {
463             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
464         }
465 
466         if (_idxArray[3] > 0) {
467             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
468         }
469 
470         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
471     }
472 
473     /// @dev Equipment destruction
474     /// @param _tokenId Equipment Token ID
475     /// @param _deleteType Destruction type, such as craft
476     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
477         external 
478         whenNotPaused
479         isValidToken(_tokenId) 
480     {
481         require(actionContracts[msg.sender]);
482 
483         address _from = fashionIdToOwner[_tokenId];
484         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
485         uint256[] storage fsArray = ownerToFashionArray[_from]; 
486         require(fsArray[indexFrom] == _tokenId);
487 
488         if (indexFrom != fsArray.length - 1) {
489             uint256 lastTokenId = fsArray[fsArray.length - 1];
490             fsArray[indexFrom] = lastTokenId; 
491             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
492         }
493         fsArray.length -= 1; 
494 
495         fashionIdToOwner[_tokenId] = address(0);
496         delete fashionIdToOwnerIndex[_tokenId];
497         destroyFashionCount += 1;
498 
499         Transfer(_from, 0, _tokenId);
500 
501         DeleteFashion(_from, _tokenId, _deleteType);
502     }
503 
504     /// @dev Safe transfer by trust contracts
505     function safeTransferByContract(uint256 _tokenId, address _to) 
506         external
507         whenNotPaused
508     {
509         require(actionContracts[msg.sender]);
510 
511         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
512         address owner = fashionIdToOwner[_tokenId];
513         require(owner != address(0));
514         require(_to != address(0));
515         require(owner != _to);
516 
517         _transfer(owner, _to, _tokenId);
518     }
519 
520     //----------------------------------------------------------------------------------------------------------
521 
522 
523     /// @dev Get fashion attrs by tokenId
524     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[13] datas) {
525         Fashion storage fs = fashionArray[_tokenId];
526         datas[0] = fs.equipmentId;
527         datas[1] = fs.quality;
528         datas[2] = fs.pos;
529         datas[3] = fs.production;
530         datas[4] = fs.attack;
531         datas[5] = fs.defense;
532         datas[6] = fs.plunder;
533         datas[7] = fs.productionMultiplier;
534         datas[8] = fs.attackMultiplier;
535         datas[9] = fs.defenseMultiplier;
536         datas[10] = fs.plunderMultiplier;
537         datas[11] = fs.level;
538         datas[12] = fs.isPercent;      
539     }
540 
541 
542     /// @dev Get tokenIds and flags by owner
543     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
544         require(_owner != address(0));
545         uint256[] storage fsArray = ownerToFashionArray[_owner];
546         uint256 length = fsArray.length;
547         tokens = new uint256[](length);
548         flags = new uint32[](length);
549         for (uint256 i = 0; i < length; ++i) {
550             tokens[i] = fsArray[i];
551             Fashion storage fs = fashionArray[fsArray[i]];
552             flags[i] = uint32(uint32(fs.equipmentId) * 10000 + uint32(fs.quality) * 100 + fs.pos);
553         }
554     }
555 
556 
557     /// @dev Race token info returned based on Token ID transfered (64 at most)
558     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
559         uint256 length = _tokens.length;
560         require(length <= 64);
561         attrs = new uint16[](length * 13);
562         uint256 tokenId;
563         uint256 index;
564         for (uint256 i = 0; i < length; ++i) {
565             tokenId = _tokens[i];
566             if (fashionIdToOwner[tokenId] != address(0)) {
567                 index = i * 13;
568                 Fashion storage fs = fashionArray[tokenId];
569                 attrs[index]     = fs.equipmentId;
570 				attrs[index + 1] = fs.quality;
571                 attrs[index + 2] = fs.pos;
572                 attrs[index + 3] = fs.production;
573                 attrs[index + 4] = fs.attack;
574                 attrs[index + 5] = fs.defense;
575                 attrs[index + 6] = fs.plunder;
576                 attrs[index + 7] = fs.productionMultiplier;
577                 attrs[index + 8] = fs.attackMultiplier;
578                 attrs[index + 9] = fs.defenseMultiplier;
579                 attrs[index + 10] = fs.plunderMultiplier;
580                 attrs[index + 11] = fs.level;
581                 attrs[index + 12] = fs.isPercent;  
582             }   
583         }
584     }
585 }