1 /* ==================================================================== */
2 /* Copyright (c) 2018 The ether.online Project.  All rights reserved.
3 /* 
4 /* https://ether.online  The first RPG game of blockchain                 
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
36 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
37 interface ERC721Metadata /* is ERC721 */ {
38     function name() external pure returns (string _name);
39     function symbol() external pure returns (string _symbol);
40     function tokenURI(uint256 _tokenId) external view returns (string);
41 }
42 
43 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
44 interface ERC721Enumerable /* is ERC721 */ {
45     function totalSupply() external view returns (uint256);
46     function tokenByIndex(uint256 _index) external view returns (uint256);
47     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
48 }
49 
50 contract AccessAdmin {
51     bool public isPaused = false;
52     address public addrAdmin;  
53 
54     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
55 
56     function AccessAdmin() public {
57         addrAdmin = msg.sender;
58     }  
59 
60 
61     modifier onlyAdmin() {
62         require(msg.sender == addrAdmin);
63         _;
64     }
65 
66     modifier whenNotPaused() {
67         require(!isPaused);
68         _;
69     }
70 
71     modifier whenPaused {
72         require(isPaused);
73         _;
74     }
75 
76     function setAdmin(address _newAdmin) external onlyAdmin {
77         require(_newAdmin != address(0));
78         AdminTransferred(addrAdmin, _newAdmin);
79         addrAdmin = _newAdmin;
80     }
81 
82     function doPause() external onlyAdmin whenNotPaused {
83         isPaused = true;
84     }
85 
86     function doUnpause() external onlyAdmin whenPaused {
87         isPaused = false;
88     }
89 }
90 
91 /// This Random is inspired by https://github.com/axiomzen/eth-random
92 contract Random {
93     uint256 _seed;
94 
95     /// @dev 根据合约记录的上一次种子生产一个随机数
96     /// @return 返回一个随机数
97     function _rand() internal returns (uint256) {
98         _seed = uint256(keccak256(_seed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
99         return _seed;
100     }
101 
102     /// @dev 根据给定的种子生产一个随机数
103     /// @param _outSeed 外部给定的种子
104     /// @return 返回一个随机数
105     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
106         return uint256(keccak256(_outSeed, block.blockhash(block.number - 1), block.coinbase, block.difficulty));
107     }
108 
109     /*
110     function _randByRange(uint256 _min, uint256 _max) internal returns (uint256) {
111         if (_min >= _max) {
112             return _min;
113         }
114         return (_rand() % (_max - _min)) + _min;
115     }
116 
117     function _rankByNumber(uint256 _max) internal returns (uint256) {
118         return _rand() % _max;
119     }
120     */
121 }
122 
123 contract WarToken is ERC721, AccessAdmin {
124     /// @dev The equipment info
125     struct Fashion {
126         uint16 protoId;     // 0  Equipment ID
127         uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
128         uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets
129         uint16 health;      // 3  Health
130         uint16 atkMin;      // 4  Min attack
131         uint16 atkMax;      // 5  Max attack
132         uint16 defence;     // 6  Defennse
133         uint16 crit;        // 7  Critical rate
134         uint16 attrExt1;    // 8  future stat 1
135         uint16 attrExt2;    // 9  future stat 2
136         uint16 attrExt3;    // 10 future stat 3
137         uint16 attrExt4;    // 11 future stat 4
138     }
139 
140     /// @dev All equipments tokenArray (not exceeding 2^32-1)
141     Fashion[] public fashionArray;
142 
143     /// @dev Amount of tokens destroyed
144     uint256 destroyFashionCount;
145 
146     /// @dev Equipment token ID vs owner address
147     mapping (uint256 => address) fashionIdToOwner;
148 
149     /// @dev Equipments owner by the owner (array)
150     mapping (address => uint256[]) ownerToFashionArray;
151 
152     /// @dev Equipment token ID search in owner array
153     mapping (uint256 => uint256) fashionIdToOwnerIndex;
154 
155     /// @dev The authorized address for each WAR
156     mapping (uint256 => address) fashionIdToApprovals;
157 
158     /// @dev The authorized operators for each address
159     mapping (address => mapping (address => bool)) operatorToApprovals;
160 
161     /// @dev Trust contract
162     mapping (address => bool) actionContracts;
163 
164     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
165         actionContracts[_actionAddr] = _useful;
166     }
167 
168     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
169         return actionContracts[_actionAddr];
170     }
171 
172     /// @dev This emits when the approved address for an WAR is changed or reaffirmed.
173     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
174 
175     /// @dev This emits when an operator is enabled or disabled for an owner.
176     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
177 
178     /// @dev This emits when the equipment ownership changed 
179     event Transfer(address indexed from, address indexed to, uint256 tokenId);
180 
181     /// @dev This emits when the equipment created
182     event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);
183 
184     /// @dev This emits when the equipment's attributes changed
185     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
186 
187     /// @dev This emits when the equipment destroyed
188     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
189     
190     function WarToken() public {
191         addrAdmin = msg.sender;
192         fashionArray.length += 1;
193     }
194 
195     // modifier
196     /// @dev Check if token ID is valid
197     modifier isValidToken(uint256 _tokenId) {
198         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
199         require(fashionIdToOwner[_tokenId] != address(0)); 
200         _;
201     }
202 
203     modifier canTransfer(uint256 _tokenId) {
204         address owner = fashionIdToOwner[_tokenId];
205         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
206         _;
207     }
208 
209     // ERC721
210     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
211         // ERC165 || ERC721 || ERC165^ERC721
212         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
213     }
214         
215     function name() public pure returns(string) {
216         return "WAR Token";
217     }
218 
219     function symbol() public pure returns(string) {
220         return "WAR";
221     }
222 
223     /// @dev Search for token quantity address
224     /// @param _owner Address that needs to be searched
225     /// @return Returns token quantity
226     function balanceOf(address _owner) external view returns(uint256) {
227         require(_owner != address(0));
228         return ownerToFashionArray[_owner].length;
229     }
230 
231     /// @dev Find the owner of an WAR
232     /// @param _tokenId The tokenId of WAR
233     /// @return Give The address of the owner of this WAR
234     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
235         return fashionIdToOwner[_tokenId];
236     }
237 
238     /// @dev Transfers the ownership of an WAR from one address to another address
239     /// @param _from The current owner of the WAR
240     /// @param _to The new owner
241     /// @param _tokenId The WAR to transfer
242     /// @param data Additional data with no specified format, sent in call to `_to`
243     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
244         external
245         whenNotPaused
246     {
247         _safeTransferFrom(_from, _to, _tokenId, data);
248     }
249 
250     /// @dev Transfers the ownership of an WAR from one address to another address
251     /// @param _from The current owner of the WAR
252     /// @param _to The new owner
253     /// @param _tokenId The WAR to transfer
254     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
255         external
256         whenNotPaused
257     {
258         _safeTransferFrom(_from, _to, _tokenId, "");
259     }
260 
261     /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost
262     /// @param _from The current owner of the WAR
263     /// @param _to The new owner
264     /// @param _tokenId The WAR to transfer
265     function transferFrom(address _from, address _to, uint256 _tokenId)
266         external
267         whenNotPaused
268         isValidToken(_tokenId)
269         canTransfer(_tokenId)
270     {
271         address owner = fashionIdToOwner[_tokenId];
272         require(owner != address(0));
273         require(_to != address(0));
274         require(owner == _from);
275         
276         _transfer(_from, _to, _tokenId);
277     }
278 
279     /// @dev Set or reaffirm the approved address for an WAR
280     /// @param _approved The new approved WAR controller
281     /// @param _tokenId The WAR to approve
282     function approve(address _approved, uint256 _tokenId)
283         external
284         whenNotPaused
285     {
286         address owner = fashionIdToOwner[_tokenId];
287         require(owner != address(0));
288         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
289 
290         fashionIdToApprovals[_tokenId] = _approved;
291         Approval(owner, _approved, _tokenId);
292     }
293 
294     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
295     /// @param _operator Address to add to the set of authorized operators.
296     /// @param _approved True if the operators is approved, false to revoke approval
297     function setApprovalForAll(address _operator, bool _approved) 
298         external 
299         whenNotPaused
300     {
301         operatorToApprovals[msg.sender][_operator] = _approved;
302         ApprovalForAll(msg.sender, _operator, _approved);
303     }
304 
305     /// @dev Get the approved address for a single WAR
306     /// @param _tokenId The WAR to find the approved address for
307     /// @return The approved address for this WAR, or the zero address if there is none
308     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
309         return fashionIdToApprovals[_tokenId];
310     }
311 
312     /// @dev Query if an address is an authorized operator for another address
313     /// @param _owner The address that owns the WARs
314     /// @param _operator The address that acts on behalf of the owner
315     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
316     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
317         return operatorToApprovals[_owner][_operator];
318     }
319 
320     /// @dev Count WARs tracked by this contract
321     /// @return A count of valid WARs tracked by this contract, where each one of
322     ///  them has an assigned and queryable owner not equal to the zero address
323     function totalSupply() external view returns (uint256) {
324         return fashionArray.length - destroyFashionCount - 1;
325     }
326 
327     /// @dev Do the real transfer with out any condition checking
328     /// @param _from The old owner of this WAR(If created: 0x0)
329     /// @param _to The new owner of this WAR 
330     /// @param _tokenId The tokenId of the WAR
331     function _transfer(address _from, address _to, uint256 _tokenId) internal {
332         if (_from != address(0)) {
333             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
334             uint256[] storage fsArray = ownerToFashionArray[_from];
335             require(fsArray[indexFrom] == _tokenId);
336 
337             // If the WAR is not the element of array, change it to with the last
338             if (indexFrom != fsArray.length - 1) {
339                 uint256 lastTokenId = fsArray[fsArray.length - 1];
340                 fsArray[indexFrom] = lastTokenId; 
341                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
342             }
343             fsArray.length -= 1; 
344             
345             if (fashionIdToApprovals[_tokenId] != address(0)) {
346                 delete fashionIdToApprovals[_tokenId];
347             }      
348         }
349 
350         // Give the WAR to '_to'
351         fashionIdToOwner[_tokenId] = _to;
352         ownerToFashionArray[_to].push(_tokenId);
353         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
354         
355         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
356     }
357 
358     /// @dev Actually perform the safeTransferFrom
359     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
360         internal
361         isValidToken(_tokenId) 
362         canTransfer(_tokenId)
363     {
364         address owner = fashionIdToOwner[_tokenId];
365         require(owner != address(0));
366         require(_to != address(0));
367         require(owner == _from);
368         
369         _transfer(_from, _to, _tokenId);
370 
371         // Do the callback after everything is done to avoid reentrancy attack
372         uint256 codeSize;
373         assembly { codeSize := extcodesize(_to) }
374         if (codeSize == 0) {
375             return;
376         }
377         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
378         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
379         require(retval == 0xf0b9e5ba);
380     }
381 
382     //----------------------------------------------------------------------------------------------------------
383 
384     /// @dev Equipment creation
385     /// @param _owner Owner of the equipment created
386     /// @param _attrs Attributes of the equipment created
387     /// @return Token ID of the equipment created
388     function createFashion(address _owner, uint16[9] _attrs) 
389         external 
390         whenNotPaused
391         returns(uint256)
392     {
393         require(actionContracts[msg.sender]);
394         require(_owner != address(0));
395 
396         uint256 newFashionId = fashionArray.length;
397         require(newFashionId < 4294967296);
398 
399         fashionArray.length += 1;
400         Fashion storage fs = fashionArray[newFashionId];
401         fs.protoId = _attrs[0];
402         fs.quality = _attrs[1];
403         fs.pos = _attrs[2];
404         if (_attrs[3] != 0) {
405             fs.health = _attrs[3];
406         }
407         
408         if (_attrs[4] != 0) {
409             fs.atkMin = _attrs[4];
410             fs.atkMax = _attrs[5];
411         }
412        
413         if (_attrs[6] != 0) {
414             fs.defence = _attrs[6];
415         }
416         
417         if (_attrs[7] != 0) {
418             fs.crit = _attrs[7];
419         }
420         
421         _transfer(0, _owner, newFashionId);
422         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _attrs[8]);
423         return newFashionId;
424     }
425 
426     /// @dev One specific attribute of the equipment modified
427     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
428         if (_index == 3) {
429             _fs.health = _val;
430         } else if(_index == 4) {
431             _fs.atkMin = _val;
432         } else if(_index == 5) {
433             _fs.atkMax = _val;
434         } else if(_index == 6) {
435             _fs.defence = _val;
436         } else if(_index == 7) {
437             _fs.crit = _val;
438         } else if(_index == 8) {
439             _fs.attrExt1 = _val;
440         } else if(_index == 9) {
441             _fs.attrExt2 = _val;
442         } else if(_index == 10) {
443             _fs.attrExt3 = _val;
444         } else {
445             _fs.attrExt4 = _val;
446         }
447     }
448 
449     /// @dev Equiment attributes modified (max 4 stats modified)
450     /// @param _tokenId Equipment Token ID
451     /// @param _idxArray Stats order that must be modified
452     /// @param _params Stat value that must be modified
453     /// @param _changeType Modification type such as enhance, socket, etc.
454     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
455         external 
456         whenNotPaused
457         isValidToken(_tokenId) 
458     {
459         require(actionContracts[msg.sender]);
460 
461         Fashion storage fs = fashionArray[_tokenId];
462         if (_idxArray[0] > 0) {
463             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
464         }
465 
466         if (_idxArray[1] > 0) {
467             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
468         }
469 
470         if (_idxArray[2] > 0) {
471             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
472         }
473 
474         if (_idxArray[3] > 0) {
475             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
476         }
477 
478         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
479     }
480 
481     /// @dev Equipment destruction
482     /// @param _tokenId Equipment Token ID
483     /// @param _deleteType Destruction type, such as craft
484     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
485         external 
486         whenNotPaused
487         isValidToken(_tokenId) 
488     {
489         require(actionContracts[msg.sender]);
490 
491         address _from = fashionIdToOwner[_tokenId];
492         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
493         uint256[] storage fsArray = ownerToFashionArray[_from]; 
494         require(fsArray[indexFrom] == _tokenId);
495 
496         if (indexFrom != fsArray.length - 1) {
497             uint256 lastTokenId = fsArray[fsArray.length - 1];
498             fsArray[indexFrom] = lastTokenId; 
499             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
500         }
501         fsArray.length -= 1; 
502 
503         fashionIdToOwner[_tokenId] = address(0);
504         delete fashionIdToOwnerIndex[_tokenId];
505         destroyFashionCount += 1;
506 
507         Transfer(_from, 0, _tokenId);
508 
509         DeleteFashion(_from, _tokenId, _deleteType);
510     }
511 
512     /// @dev Safe transfer by trust contracts
513     function safeTransferByContract(uint256 _tokenId, address _to) 
514         external
515         whenNotPaused
516     {
517         require(actionContracts[msg.sender]);
518 
519         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
520         address owner = fashionIdToOwner[_tokenId];
521         require(owner != address(0));
522         require(_to != address(0));
523         require(owner != _to);
524 
525         _transfer(owner, _to, _tokenId);
526     }
527 
528     //----------------------------------------------------------------------------------------------------------
529 
530     /// @dev Get fashion attrs by tokenId
531     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {
532         Fashion storage fs = fashionArray[_tokenId];
533         datas[0] = fs.protoId;
534         datas[1] = fs.quality;
535         datas[2] = fs.pos;
536         datas[3] = fs.health;
537         datas[4] = fs.atkMin;
538         datas[5] = fs.atkMax;
539         datas[6] = fs.defence;
540         datas[7] = fs.crit;
541         datas[8] = fs.attrExt1;
542         datas[9] = fs.attrExt2;
543         datas[10] = fs.attrExt3;
544         datas[11] = fs.attrExt4;
545     }
546 
547     /// @dev Get tokenIds and flags by owner
548     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
549         require(_owner != address(0));
550         uint256[] storage fsArray = ownerToFashionArray[_owner];
551         uint256 length = fsArray.length;
552         tokens = new uint256[](length);
553         flags = new uint32[](length);
554         for (uint256 i = 0; i < length; ++i) {
555             tokens[i] = fsArray[i];
556             Fashion storage fs = fashionArray[fsArray[i]];
557             flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);
558         }
559     }
560 
561     /// @dev WAR token info returned based on Token ID transfered (64 at most)
562     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
563         uint256 length = _tokens.length;
564         require(length <= 64);
565         attrs = new uint16[](length * 11);
566         uint256 tokenId;
567         uint256 index;
568         for (uint256 i = 0; i < length; ++i) {
569             tokenId = _tokens[i];
570             if (fashionIdToOwner[tokenId] != address(0)) {
571                 index = i * 11;
572                 Fashion storage fs = fashionArray[tokenId];
573                 attrs[index] = fs.health;
574                 attrs[index + 1] = fs.atkMin;
575                 attrs[index + 2] = fs.atkMax;
576                 attrs[index + 3] = fs.defence;
577                 attrs[index + 4] = fs.crit;
578                 attrs[index + 5] = fs.attrExt1;
579                 attrs[index + 6] = fs.attrExt2;
580                 attrs[index + 7] = fs.attrExt3;
581                 attrs[index + 8] = fs.attrExt4;
582             }   
583         }
584     }
585 }