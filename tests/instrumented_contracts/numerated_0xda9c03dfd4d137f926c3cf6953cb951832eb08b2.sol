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
77 contract WarToken is ERC721, AccessAdmin {
78     /// @dev The equipment info
79     struct Fashion {
80         uint16 protoId;     // 0  Equipment ID
81         uint16 quality;     // 1  Rarity: 1 Coarse/2 Good/3 Rare/4 Epic/5 Legendary
82         uint16 pos;         // 2  Slots: 1 Weapon/2 Hat/3 Cloth/4 Pant/5 Shoes/9 Pets
83         uint16 health;      // 3  Health
84         uint16 atkMin;      // 4  Min attack
85         uint16 atkMax;      // 5  Max attack
86         uint16 defence;     // 6  Defennse
87         uint16 crit;        // 7  Critical rate
88         uint16 isPercent;   // 8  Attr value type
89         uint16 attrExt1;    // 9  future stat 1
90         uint16 attrExt2;    // 10 future stat 2
91         uint16 attrExt3;    // 11 future stat 3
92     }
93 
94     /// @dev All equipments tokenArray (not exceeding 2^32-1)
95     Fashion[] public fashionArray;
96 
97     /// @dev Amount of tokens destroyed
98     uint256 destroyFashionCount;
99 
100     /// @dev Equipment token ID vs owner address
101     mapping (uint256 => address) fashionIdToOwner;
102 
103     /// @dev Equipments owner by the owner (array)
104     mapping (address => uint256[]) ownerToFashionArray;
105 
106     /// @dev Equipment token ID search in owner array
107     mapping (uint256 => uint256) fashionIdToOwnerIndex;
108 
109     /// @dev The authorized address for each WAR
110     mapping (uint256 => address) fashionIdToApprovals;
111 
112     /// @dev The authorized operators for each address
113     mapping (address => mapping (address => bool)) operatorToApprovals;
114 
115     /// @dev Trust contract
116     mapping (address => bool) actionContracts;
117 
118     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
119         actionContracts[_actionAddr] = _useful;
120     }
121 
122     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
123         return actionContracts[_actionAddr];
124     }
125 
126     /// @dev This emits when the approved address for an WAR is changed or reaffirmed.
127     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
128 
129     /// @dev This emits when an operator is enabled or disabled for an owner.
130     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
131 
132     /// @dev This emits when the equipment ownership changed 
133     event Transfer(address indexed from, address indexed to, uint256 tokenId);
134 
135     /// @dev This emits when the equipment created
136     event CreateFashion(address indexed owner, uint256 tokenId, uint16 protoId, uint16 quality, uint16 pos, uint16 createType);
137 
138     /// @dev This emits when the equipment's attributes changed
139     event ChangeFashion(address indexed owner, uint256 tokenId, uint16 changeType);
140 
141     /// @dev This emits when the equipment destroyed
142     event DeleteFashion(address indexed owner, uint256 tokenId, uint16 deleteType);
143     
144     function WarToken() public {
145         addrAdmin = msg.sender;
146         fashionArray.length += 1;
147     }
148 
149     // modifier
150     /// @dev Check if token ID is valid
151     modifier isValidToken(uint256 _tokenId) {
152         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
153         require(fashionIdToOwner[_tokenId] != address(0)); 
154         _;
155     }
156 
157     modifier canTransfer(uint256 _tokenId) {
158         address owner = fashionIdToOwner[_tokenId];
159         require(msg.sender == owner || msg.sender == fashionIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
160         _;
161     }
162 
163     // ERC721
164     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
165         // ERC165 || ERC721 || ERC165^ERC721
166         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
167     }
168         
169     function name() public pure returns(string) {
170         return "WAR Token";
171     }
172 
173     function symbol() public pure returns(string) {
174         return "WAR";
175     }
176 
177     /// @dev Search for token quantity address
178     /// @param _owner Address that needs to be searched
179     /// @return Returns token quantity
180     function balanceOf(address _owner) external view returns(uint256) {
181         require(_owner != address(0));
182         return ownerToFashionArray[_owner].length;
183     }
184 
185     /// @dev Find the owner of an WAR
186     /// @param _tokenId The tokenId of WAR
187     /// @return Give The address of the owner of this WAR
188     function ownerOf(uint256 _tokenId) external view /*isValidToken(_tokenId)*/ returns (address owner) {
189         return fashionIdToOwner[_tokenId];
190     }
191 
192     /// @dev Transfers the ownership of an WAR from one address to another address
193     /// @param _from The current owner of the WAR
194     /// @param _to The new owner
195     /// @param _tokenId The WAR to transfer
196     /// @param data Additional data with no specified format, sent in call to `_to`
197     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
198         external
199         whenNotPaused
200     {
201         _safeTransferFrom(_from, _to, _tokenId, data);
202     }
203 
204     /// @dev Transfers the ownership of an WAR from one address to another address
205     /// @param _from The current owner of the WAR
206     /// @param _to The new owner
207     /// @param _tokenId The WAR to transfer
208     function safeTransferFrom(address _from, address _to, uint256 _tokenId) 
209         external
210         whenNotPaused
211     {
212         _safeTransferFrom(_from, _to, _tokenId, "");
213     }
214 
215     /// @dev Transfer ownership of an WAR, '_to' must be a vaild address, or the WAR will lost
216     /// @param _from The current owner of the WAR
217     /// @param _to The new owner
218     /// @param _tokenId The WAR to transfer
219     function transferFrom(address _from, address _to, uint256 _tokenId)
220         external
221         whenNotPaused
222         isValidToken(_tokenId)
223         canTransfer(_tokenId)
224     {
225         address owner = fashionIdToOwner[_tokenId];
226         require(owner != address(0));
227         require(_to != address(0));
228         require(owner == _from);
229         
230         _transfer(_from, _to, _tokenId);
231     }
232 
233     /// @dev Set or reaffirm the approved address for an WAR
234     /// @param _approved The new approved WAR controller
235     /// @param _tokenId The WAR to approve
236     function approve(address _approved, uint256 _tokenId)
237         external
238         whenNotPaused
239     {
240         address owner = fashionIdToOwner[_tokenId];
241         require(owner != address(0));
242         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
243 
244         fashionIdToApprovals[_tokenId] = _approved;
245         Approval(owner, _approved, _tokenId);
246     }
247 
248     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
249     /// @param _operator Address to add to the set of authorized operators.
250     /// @param _approved True if the operators is approved, false to revoke approval
251     function setApprovalForAll(address _operator, bool _approved) 
252         external 
253         whenNotPaused
254     {
255         operatorToApprovals[msg.sender][_operator] = _approved;
256         ApprovalForAll(msg.sender, _operator, _approved);
257     }
258 
259     /// @dev Get the approved address for a single WAR
260     /// @param _tokenId The WAR to find the approved address for
261     /// @return The approved address for this WAR, or the zero address if there is none
262     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
263         return fashionIdToApprovals[_tokenId];
264     }
265 
266     /// @dev Query if an address is an authorized operator for another address
267     /// @param _owner The address that owns the WARs
268     /// @param _operator The address that acts on behalf of the owner
269     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
270     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
271         return operatorToApprovals[_owner][_operator];
272     }
273 
274     /// @dev Count WARs tracked by this contract
275     /// @return A count of valid WARs tracked by this contract, where each one of
276     ///  them has an assigned and queryable owner not equal to the zero address
277     function totalSupply() external view returns (uint256) {
278         return fashionArray.length - destroyFashionCount - 1;
279     }
280 
281     /// @dev Do the real transfer with out any condition checking
282     /// @param _from The old owner of this WAR(If created: 0x0)
283     /// @param _to The new owner of this WAR 
284     /// @param _tokenId The tokenId of the WAR
285     function _transfer(address _from, address _to, uint256 _tokenId) internal {
286         if (_from != address(0)) {
287             uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
288             uint256[] storage fsArray = ownerToFashionArray[_from];
289             require(fsArray[indexFrom] == _tokenId);
290 
291             // If the WAR is not the element of array, change it to with the last
292             if (indexFrom != fsArray.length - 1) {
293                 uint256 lastTokenId = fsArray[fsArray.length - 1];
294                 fsArray[indexFrom] = lastTokenId; 
295                 fashionIdToOwnerIndex[lastTokenId] = indexFrom;
296             }
297             fsArray.length -= 1; 
298             
299             if (fashionIdToApprovals[_tokenId] != address(0)) {
300                 delete fashionIdToApprovals[_tokenId];
301             }      
302         }
303 
304         // Give the WAR to '_to'
305         fashionIdToOwner[_tokenId] = _to;
306         ownerToFashionArray[_to].push(_tokenId);
307         fashionIdToOwnerIndex[_tokenId] = ownerToFashionArray[_to].length - 1;
308         
309         Transfer(_from != address(0) ? _from : this, _to, _tokenId);
310     }
311 
312     /// @dev Actually perform the safeTransferFrom
313     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
314         internal
315         isValidToken(_tokenId) 
316         canTransfer(_tokenId)
317     {
318         address owner = fashionIdToOwner[_tokenId];
319         require(owner != address(0));
320         require(_to != address(0));
321         require(owner == _from);
322         
323         _transfer(_from, _to, _tokenId);
324 
325         // Do the callback after everything is done to avoid reentrancy attack
326         uint256 codeSize;
327         assembly { codeSize := extcodesize(_to) }
328         if (codeSize == 0) {
329             return;
330         }
331         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
332         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
333         require(retval == 0xf0b9e5ba);
334     }
335 
336     //----------------------------------------------------------------------------------------------------------
337 
338     /// @dev Equipment creation
339     /// @param _owner Owner of the equipment created
340     /// @param _attrs Attributes of the equipment created
341     /// @return Token ID of the equipment created
342     function createFashion(address _owner, uint16[9] _attrs, uint16 _createType) 
343         external 
344         whenNotPaused
345         returns(uint256)
346     {
347         require(actionContracts[msg.sender]);
348         require(_owner != address(0));
349 
350         uint256 newFashionId = fashionArray.length;
351         require(newFashionId < 4294967296);
352 
353         fashionArray.length += 1;
354         Fashion storage fs = fashionArray[newFashionId];
355         fs.protoId = _attrs[0];
356         fs.quality = _attrs[1];
357         fs.pos = _attrs[2];
358         if (_attrs[3] != 0) {
359             fs.health = _attrs[3];
360         }
361         
362         if (_attrs[4] != 0) {
363             fs.atkMin = _attrs[4];
364             fs.atkMax = _attrs[5];
365         }
366        
367         if (_attrs[6] != 0) {
368             fs.defence = _attrs[6];
369         }
370         
371         if (_attrs[7] != 0) {
372             fs.crit = _attrs[7];
373         }
374 
375         if (_attrs[8] != 0) {
376             fs.isPercent = _attrs[8];
377         }
378         
379         _transfer(0, _owner, newFashionId);
380         CreateFashion(_owner, newFashionId, _attrs[0], _attrs[1], _attrs[2], _createType);
381         return newFashionId;
382     }
383 
384     /// @dev One specific attribute of the equipment modified
385     function _changeAttrByIndex(Fashion storage _fs, uint16 _index, uint16 _val) internal {
386         if (_index == 3) {
387             _fs.health = _val;
388         } else if(_index == 4) {
389             _fs.atkMin = _val;
390         } else if(_index == 5) {
391             _fs.atkMax = _val;
392         } else if(_index == 6) {
393             _fs.defence = _val;
394         } else if(_index == 7) {
395             _fs.crit = _val;
396         } else if(_index == 9) {
397             _fs.attrExt1 = _val;
398         } else if(_index == 10) {
399             _fs.attrExt2 = _val;
400         } else if(_index == 11) {
401             _fs.attrExt3 = _val;
402         }
403     }
404 
405     /// @dev Equiment attributes modified (max 4 stats modified)
406     /// @param _tokenId Equipment Token ID
407     /// @param _idxArray Stats order that must be modified
408     /// @param _params Stat value that must be modified
409     /// @param _changeType Modification type such as enhance, socket, etc.
410     function changeFashionAttr(uint256 _tokenId, uint16[4] _idxArray, uint16[4] _params, uint16 _changeType) 
411         external 
412         whenNotPaused
413         isValidToken(_tokenId) 
414     {
415         require(actionContracts[msg.sender]);
416 
417         Fashion storage fs = fashionArray[_tokenId];
418         if (_idxArray[0] > 0) {
419             _changeAttrByIndex(fs, _idxArray[0], _params[0]);
420         }
421 
422         if (_idxArray[1] > 0) {
423             _changeAttrByIndex(fs, _idxArray[1], _params[1]);
424         }
425 
426         if (_idxArray[2] > 0) {
427             _changeAttrByIndex(fs, _idxArray[2], _params[2]);
428         }
429 
430         if (_idxArray[3] > 0) {
431             _changeAttrByIndex(fs, _idxArray[3], _params[3]);
432         }
433 
434         ChangeFashion(fashionIdToOwner[_tokenId], _tokenId, _changeType);
435     }
436 
437     /// @dev Equipment destruction
438     /// @param _tokenId Equipment Token ID
439     /// @param _deleteType Destruction type, such as craft
440     function destroyFashion(uint256 _tokenId, uint16 _deleteType)
441         external 
442         whenNotPaused
443         isValidToken(_tokenId) 
444     {
445         require(actionContracts[msg.sender]);
446 
447         address _from = fashionIdToOwner[_tokenId];
448         uint256 indexFrom = fashionIdToOwnerIndex[_tokenId];
449         uint256[] storage fsArray = ownerToFashionArray[_from]; 
450         require(fsArray[indexFrom] == _tokenId);
451 
452         if (indexFrom != fsArray.length - 1) {
453             uint256 lastTokenId = fsArray[fsArray.length - 1];
454             fsArray[indexFrom] = lastTokenId; 
455             fashionIdToOwnerIndex[lastTokenId] = indexFrom;
456         }
457         fsArray.length -= 1; 
458 
459         fashionIdToOwner[_tokenId] = address(0);
460         delete fashionIdToOwnerIndex[_tokenId];
461         destroyFashionCount += 1;
462 
463         Transfer(_from, 0, _tokenId);
464 
465         DeleteFashion(_from, _tokenId, _deleteType);
466     }
467 
468     /// @dev Safe transfer by trust contracts
469     function safeTransferByContract(uint256 _tokenId, address _to) 
470         external
471         whenNotPaused
472     {
473         require(actionContracts[msg.sender]);
474 
475         require(_tokenId >= 1 && _tokenId <= fashionArray.length);
476         address owner = fashionIdToOwner[_tokenId];
477         require(owner != address(0));
478         require(_to != address(0));
479         require(owner != _to);
480 
481         _transfer(owner, _to, _tokenId);
482     }
483 
484     //----------------------------------------------------------------------------------------------------------
485 
486     /// @dev Get fashion attrs by tokenId
487     function getFashion(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[12] datas) {
488         Fashion storage fs = fashionArray[_tokenId];
489         datas[0] = fs.protoId;
490         datas[1] = fs.quality;
491         datas[2] = fs.pos;
492         datas[3] = fs.health;
493         datas[4] = fs.atkMin;
494         datas[5] = fs.atkMax;
495         datas[6] = fs.defence;
496         datas[7] = fs.crit;
497         datas[8] = fs.isPercent;
498         datas[9] = fs.attrExt1;
499         datas[10] = fs.attrExt2;
500         datas[11] = fs.attrExt3;
501     }
502 
503     /// @dev Get tokenIds and flags by owner
504     function getOwnFashions(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
505         require(_owner != address(0));
506         uint256[] storage fsArray = ownerToFashionArray[_owner];
507         uint256 length = fsArray.length;
508         tokens = new uint256[](length);
509         flags = new uint32[](length);
510         for (uint256 i = 0; i < length; ++i) {
511             tokens[i] = fsArray[i];
512             Fashion storage fs = fashionArray[fsArray[i]];
513             flags[i] = uint32(uint32(fs.protoId) * 100 + uint32(fs.quality) * 10 + fs.pos);
514         }
515     }
516 
517     /// @dev WAR token info returned based on Token ID transfered (64 at most)
518     function getFashionsAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
519         uint256 length = _tokens.length;
520         require(length <= 64);
521         attrs = new uint16[](length * 11);
522         uint256 tokenId;
523         uint256 index;
524         for (uint256 i = 0; i < length; ++i) {
525             tokenId = _tokens[i];
526             if (fashionIdToOwner[tokenId] != address(0)) {
527                 index = i * 11;
528                 Fashion storage fs = fashionArray[tokenId];
529                 attrs[index] = fs.health;
530                 attrs[index + 1] = fs.atkMin;
531                 attrs[index + 2] = fs.atkMax;
532                 attrs[index + 3] = fs.defence;
533                 attrs[index + 4] = fs.crit;
534                 attrs[index + 5] = fs.isPercent;
535                 attrs[index + 6] = fs.attrExt1;
536                 attrs[index + 7] = fs.attrExt2;
537                 attrs[index + 8] = fs.attrExt3;
538             }   
539         }
540     }
541 }