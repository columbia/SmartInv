1 pragma solidity ^0.4.23;
2 /// @title ERC-165 Standard Interface Detection
3 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
4 interface ERC165 {
5     function supportsInterface(bytes4 interfaceID) external view returns (bool);
6 }
7 
8 /// @title ERC-721 Non-Fungible Token Standard
9 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
10 contract ERC721 is ERC165 {
11     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
12     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
13     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
14     function balanceOf(address _owner) external view returns (uint256);
15     function ownerOf(uint256 _tokenId) external view returns (address);
16     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external;
17     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
18     function transferFrom(address _from, address _to, uint256 _tokenId) external;
19     function approve(address _approved, uint256 _tokenId) external;
20     function setApprovalForAll(address _operator, bool _approved) external;
21     function getApproved(uint256 _tokenId) external view returns (address);
22     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
23 }
24 
25 /// @title ERC-721 Non-Fungible Token Standard
26 interface ERC721TokenReceiver {
27 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
28 }
29 
30 contract Random {
31     uint256 _seed;
32 
33     function _rand() internal returns (uint256) {
34         _seed = uint256(keccak256(_seed, blockhash(block.number - 1), block.coinbase, block.difficulty));
35         return _seed;
36     }
37 
38     function _randBySeed(uint256 _outSeed) internal view returns (uint256) {
39         return uint256(keccak256(_outSeed, blockhash(block.number - 1), block.coinbase, block.difficulty));
40     }
41 }
42 
43 contract AccessAdmin {
44     bool public isPaused = false;
45     address public addrAdmin;  
46 
47     event AdminTransferred(address indexed preAdmin, address indexed newAdmin);
48 
49     constructor() public {
50         addrAdmin = msg.sender;
51     }  
52 
53 
54     modifier onlyAdmin() {
55         require(msg.sender == addrAdmin);
56         _;
57     }
58 
59     modifier whenNotPaused() {
60         require(!isPaused);
61         _;
62     }
63 
64     modifier whenPaused {
65         require(isPaused);
66         _;
67     }
68 
69     function setAdmin(address _newAdmin) external onlyAdmin {
70         require(_newAdmin != address(0));
71         emit AdminTransferred(addrAdmin, _newAdmin);
72         addrAdmin = _newAdmin;
73     }
74 
75     function doPause() external onlyAdmin whenNotPaused {
76         isPaused = true;
77     }
78 
79     function doUnpause() external onlyAdmin whenPaused {
80         isPaused = false;
81     }
82 }
83 
84 contract AccessService is AccessAdmin {
85     address public addrService;
86     address public addrFinance;
87 
88     modifier onlyService() {
89         require(msg.sender == addrService);
90         _;
91     }
92 
93     modifier onlyFinance() {
94         require(msg.sender == addrFinance);
95         _;
96     }
97 
98     function setService(address _newService) external {
99         require(msg.sender == addrService || msg.sender == addrAdmin);
100         require(_newService != address(0));
101         addrService = _newService;
102     }
103 
104     function setFinance(address _newFinance) external {
105         require(msg.sender == addrFinance || msg.sender == addrAdmin);
106         require(_newFinance != address(0));
107         addrFinance = _newFinance;
108     }
109 }
110 
111 //Ether League Hero Token
112 contract ELHeroToken is ERC721,AccessAdmin{
113     struct Card {
114         uint16 protoId;     // 0  10001-10025 Gen 0 Heroes
115         uint16 hero;        // 1  1-25 hero ID
116         uint16 quality;     // 2  rarities: 1 Common 2 Uncommon 3 Rare 4 Epic 5 Legendary 6 Gen 0 Heroes
117         uint16 feature;     // 3  feature
118         uint16 level;       // 4  level
119         uint16 attrExt1;    // 5  future stat 1
120         uint16 attrExt2;    // 6  future stat 2
121     }
122     
123     /// @dev All card tokenArray (not exceeding 2^32-1)
124     Card[] public cardArray;
125 
126     /// @dev Amount of tokens destroyed
127     uint256 destroyCardCount;
128 
129     /// @dev Card token ID vs owner address
130     mapping (uint256 => address) cardIdToOwner;
131 
132     /// @dev cards owner by the owner (array)
133     mapping (address => uint256[]) ownerToCardArray;
134     
135     /// @dev card token ID search in owner array
136     mapping (uint256 => uint256) cardIdToOwnerIndex;
137 
138     /// @dev The authorized address for each token
139     mapping (uint256 => address) cardIdToApprovals;
140 
141     /// @dev The authorized operators for each address
142     mapping (address => mapping (address => bool)) operatorToApprovals;
143 
144     /// @dev Trust contract
145     mapping (address => bool) actionContracts;
146 
147     function setActionContract(address _actionAddr, bool _useful) external onlyAdmin {
148         actionContracts[_actionAddr] = _useful;
149     }
150 
151     function getActionContract(address _actionAddr) external view onlyAdmin returns(bool) {
152         return actionContracts[_actionAddr];
153     }
154 
155     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
156     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
157     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
158     event CreateCard(address indexed owner, uint256 tokenId, uint16 protoId, uint16 hero, uint16 quality, uint16 createType);
159     event DeleteCard(address indexed owner, uint256 tokenId, uint16 deleteType);
160     event ChangeCard(address indexed owner, uint256 tokenId, uint16 changeType);
161     
162 
163     modifier isValidToken(uint256 _tokenId) {
164         require(_tokenId >= 1 && _tokenId <= cardArray.length);
165         require(cardIdToOwner[_tokenId] != address(0)); 
166         _;
167     }
168 
169     modifier canTransfer(uint256 _tokenId) {
170         address owner = cardIdToOwner[_tokenId];
171         require(msg.sender == owner || msg.sender == cardIdToApprovals[_tokenId] || operatorToApprovals[owner][msg.sender]);
172         _;
173     }
174 
175     // ERC721
176     function supportsInterface(bytes4 _interfaceId) external view returns(bool) {
177         // ERC165 || ERC721 || ERC165^ERC721
178         return (_interfaceId == 0x01ffc9a7 || _interfaceId == 0x80ac58cd || _interfaceId == 0x8153916a) && (_interfaceId != 0xffffffff);
179     }
180 
181     constructor() public {
182         addrAdmin = msg.sender;
183         cardArray.length += 1;
184     }
185 
186 
187     function name() public pure returns(string) {
188         return "Ether League Hero Token";
189     }
190 
191     function symbol() public pure returns(string) {
192         return "ELHT";
193     }
194 
195     /// @dev Search for token quantity address
196     /// @param _owner Address that needs to be searched
197     /// @return Returns token quantity
198     function balanceOf(address _owner) external view returns (uint256){
199         require(_owner != address(0));
200         return ownerToCardArray[_owner].length;
201     }
202 
203     /// @dev Find the owner of an ELHT
204     /// @param _tokenId The tokenId of ELHT
205     /// @return Give The address of the owner of this ELHT
206     function ownerOf(uint256 _tokenId) external view returns (address){
207         return cardIdToOwner[_tokenId];
208     }
209 
210     /// @dev Transfers the ownership of an ELHT from one address to another address
211     /// @param _from The current owner of the ELHT
212     /// @param _to The new owner
213     /// @param _tokenId The ELHT to transfer
214     /// @param data Additional data with no specified format, sent in call to `_to`
215     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external whenNotPaused{
216         _safeTransferFrom(_from, _to, _tokenId, data);
217     }
218 
219     /// @dev Transfers the ownership of an ELHT from one address to another address
220     /// @param _from The current owner of the ELHT
221     /// @param _to The new owner
222     /// @param _tokenId The ELHT to transfer
223     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused{
224         _safeTransferFrom(_from, _to, _tokenId, "");
225     }
226 
227     /// @dev Transfer ownership of an ELHT, '_to' must be a vaild address, or the ELHT will lost
228     /// @param _from The current owner of the ELHT
229     /// @param _to The new owner
230     /// @param _tokenId The ELHT to transfer
231     function transferFrom(address _from, address _to, uint256 _tokenId) external whenNotPaused isValidToken(_tokenId) canTransfer(_tokenId){
232         address owner = cardIdToOwner[_tokenId];
233         require(owner != address(0));
234         require(_to != address(0));
235         require(owner == _from);
236         
237         _transfer(_from, _to, _tokenId);
238     }
239     
240 
241     /// @dev Set or reaffirm the approved address for an ELHT
242     /// @param _approved The new approved ELHT controller
243     /// @param _tokenId The ELHT to approve
244     function approve(address _approved, uint256 _tokenId) external whenNotPaused{
245         address owner = cardIdToOwner[_tokenId];
246         require(owner != address(0));
247         require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
248 
249         cardIdToApprovals[_tokenId] = _approved;
250         emit Approval(owner, _approved, _tokenId);
251     }
252 
253     /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
254     /// @param _operator Address to add to the set of authorized operators.
255     /// @param _approved True if the operators is approved, false to revoke approval
256     function setApprovalForAll(address _operator, bool _approved) external whenNotPaused{
257         operatorToApprovals[msg.sender][_operator] = _approved;
258         emit ApprovalForAll(msg.sender, _operator, _approved);
259     }
260 
261     /// @dev Get the approved address for a single ELHT
262     /// @param _tokenId The ELHT to find the approved address for
263     /// @return The approved address for this ELHT, or the zero address if there is none
264     function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
265         return cardIdToApprovals[_tokenId];
266     }
267 
268     /// @dev Query if an address is an authorized operator for another address 查询地址是否为另一地址的授权操作者
269     /// @param _owner The address that owns the ELHTs
270     /// @param _operator The address that acts on behalf of the owner
271     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
272     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
273         return operatorToApprovals[_owner][_operator];
274     }
275 
276     /// @dev Count ELHTs tracked by this contract
277     /// @return A count of valid ELHTs tracked by this contract, where each one of them has an assigned and queryable owner not equal to the zero address
278     function totalSupply() external view returns (uint256) {
279         return cardArray.length - destroyCardCount - 1;
280     }
281 
282     /// @dev Actually perform the safeTransferFrom
283     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) internal isValidToken(_tokenId) canTransfer(_tokenId){
284         address owner = cardIdToOwner[_tokenId];
285         require(owner != address(0));
286         require(_to != address(0));
287         require(owner == _from);
288         
289         _transfer(_from, _to, _tokenId);
290 
291         // Do the callback after everything is done to avoid reentrancy attack
292         uint256 codeSize;
293         assembly { codeSize := extcodesize(_to) }
294         if (codeSize == 0) {
295             return;
296         }
297         bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
298         // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
299         require(retval == 0xf0b9e5ba);
300     }
301 
302     /// @dev Do the real transfer with out any condition checking
303     /// @param _from The old owner of this ELHT(If created: 0x0)
304     /// @param _to The new owner of this ELHT 
305     /// @param _tokenId The tokenId of the ELHT
306     function _transfer(address _from, address _to, uint256 _tokenId) internal {
307         if (_from != address(0)) {
308             uint256 indexFrom = cardIdToOwnerIndex[_tokenId];
309             uint256[] storage cdArray = ownerToCardArray[_from];
310             require(cdArray[indexFrom] == _tokenId);
311 
312             // If the ELHT is not the element of array, change it to with the last
313             if (indexFrom != cdArray.length - 1) {
314                 uint256 lastTokenId = cdArray[cdArray.length - 1];
315                 cdArray[indexFrom] = lastTokenId; 
316                 cardIdToOwnerIndex[lastTokenId] = indexFrom;
317             }
318             cdArray.length -= 1; 
319             
320             if (cardIdToApprovals[_tokenId] != address(0)) {
321                 delete cardIdToApprovals[_tokenId];
322             }      
323         }
324 
325         // Give the ELHT to '_to'
326         cardIdToOwner[_tokenId] = _to;
327         ownerToCardArray[_to].push(_tokenId);
328         cardIdToOwnerIndex[_tokenId] = ownerToCardArray[_to].length - 1;
329         
330         emit Transfer(_from != address(0) ? _from : this, _to, _tokenId);
331     }
332 
333 
334 
335     /*----------------------------------------------------------------------------------------------------------*/
336 
337 
338     /// @dev Card creation
339     /// @param _owner Owner of the equipment created
340     /// @param _attrs Attributes of the equipment created
341     /// @return Token ID of the equipment created
342     function createCard(address _owner, uint16[5] _attrs, uint16 _createType) external whenNotPaused returns(uint256){
343         require(actionContracts[msg.sender]);
344         require(_owner != address(0));
345         uint256 newCardId = cardArray.length;
346         require(newCardId < 4294967296);
347 
348         cardArray.length += 1;
349         Card storage cd = cardArray[newCardId];
350         cd.protoId = _attrs[0];
351         cd.hero = _attrs[1];
352         cd.quality = _attrs[2];
353         cd.feature = _attrs[3];
354         cd.level = _attrs[4];
355 
356         _transfer(0, _owner, newCardId);
357         emit CreateCard(_owner, newCardId, _attrs[0], _attrs[1], _attrs[2], _createType);
358         return newCardId;
359     }
360 
361     /// @dev One specific attribute of the equipment modified
362     function _changeAttrByIndex(Card storage _cd, uint16 _index, uint16 _val) internal {
363         if (_index == 2) {
364             _cd.quality = _val;
365         } else if(_index == 3) {
366             _cd.feature = _val;
367         } else if(_index == 4) {
368             _cd.level = _val;
369         } else if(_index == 5) {
370             _cd.attrExt1 = _val;
371         } else if(_index == 6) {
372             _cd.attrExt2 = _val;
373         }
374     }
375 
376     /// @dev Equiment attributes modified (max 4 stats modified)
377     /// @param _tokenId Equipment Token ID
378     /// @param _idxArray Stats order that must be modified
379     /// @param _params Stat value that must be modified
380     /// @param _changeType Modification type such as enhance, socket, etc.
381     function changeCardAttr(uint256 _tokenId, uint16[5] _idxArray, uint16[5] _params, uint16 _changeType) external whenNotPaused isValidToken(_tokenId) {
382         require(actionContracts[msg.sender]);
383 
384         Card storage cd = cardArray[_tokenId];
385         if (_idxArray[0] > 0) _changeAttrByIndex(cd, _idxArray[0], _params[0]);
386         if (_idxArray[1] > 0) _changeAttrByIndex(cd, _idxArray[1], _params[1]);
387         if (_idxArray[2] > 0) _changeAttrByIndex(cd, _idxArray[2], _params[2]);
388         if (_idxArray[3] > 0) _changeAttrByIndex(cd, _idxArray[3], _params[3]);
389         if (_idxArray[4] > 0) _changeAttrByIndex(cd, _idxArray[4], _params[4]);
390         
391         emit ChangeCard(cardIdToOwner[_tokenId], _tokenId, _changeType);
392     }
393 
394     /// @dev Equipment destruction
395     /// @param _tokenId Equipment Token ID
396     /// @param _deleteType Destruction type, such as craft
397     function destroyCard(uint256 _tokenId, uint16 _deleteType) external whenNotPaused isValidToken(_tokenId) {
398         require(actionContracts[msg.sender]);
399 
400         address _from = cardIdToOwner[_tokenId];
401         uint256 indexFrom = cardIdToOwnerIndex[_tokenId];
402         uint256[] storage cdArray = ownerToCardArray[_from]; 
403         require(cdArray[indexFrom] == _tokenId);
404 
405         if (indexFrom != cdArray.length - 1) {
406             uint256 lastTokenId = cdArray[cdArray.length - 1];
407             cdArray[indexFrom] = lastTokenId; 
408             cardIdToOwnerIndex[lastTokenId] = indexFrom;
409         }
410         cdArray.length -= 1; 
411 
412         cardIdToOwner[_tokenId] = address(0);
413         delete cardIdToOwnerIndex[_tokenId];
414         destroyCardCount += 1;
415 
416         emit Transfer(_from, 0, _tokenId);
417 
418         emit DeleteCard(_from, _tokenId, _deleteType);
419     }
420 
421     /// @dev Safe transfer by trust contracts
422     function safeTransferByContract(uint256 _tokenId, address _to) external whenNotPaused{
423         require(actionContracts[msg.sender]);
424 
425         require(_tokenId >= 1 && _tokenId <= cardArray.length);
426         address owner = cardIdToOwner[_tokenId];
427         require(owner != address(0));
428         require(_to != address(0));
429         require(owner != _to);
430 
431         _transfer(owner, _to, _tokenId);
432     }
433 
434     /// @dev Get fashion attrs by tokenId
435     function getCard(uint256 _tokenId) external view isValidToken(_tokenId) returns (uint16[7] datas) {
436         Card storage cd = cardArray[_tokenId];
437         datas[0] = cd.protoId;
438         datas[1] = cd.hero;
439         datas[2] = cd.quality;
440         datas[3] = cd.feature;
441         datas[4] = cd.level;
442         datas[5] = cd.attrExt1;
443         datas[6] = cd.attrExt2;
444     }
445 
446     /// Get tokenIds and flags by owner
447     function getOwnCard(address _owner) external view returns(uint256[] tokens, uint32[] flags) {
448         require(_owner != address(0));
449         uint256[] storage cdArray = ownerToCardArray[_owner];
450         uint256 length = cdArray.length;
451         tokens = new uint256[](length);
452         flags = new uint32[](length);
453         for (uint256 i = 0; i < length; ++i) {
454             tokens[i] = cdArray[i];
455             Card storage cd = cardArray[cdArray[i]];
456             flags[i] = uint32(uint32(cd.protoId) * 1000 + uint32(cd.hero) * 10 + cd.quality);
457         }
458     }
459 
460     /// ELHT token info returned based on Token ID transfered (64 at most)
461     function getCardAttrs(uint256[] _tokens) external view returns(uint16[] attrs) {
462         uint256 length = _tokens.length;
463         require(length <= 64);
464         attrs = new uint16[](length * 11);
465         uint256 tokenId;
466         uint256 index;
467         for (uint256 i = 0; i < length; ++i) {
468             tokenId = _tokens[i];
469             if (cardIdToOwner[tokenId] != address(0)) {
470                 index = i * 11;
471                 Card storage cd = cardArray[tokenId];
472                 attrs[index] = cd.hero;
473                 attrs[index + 1] = cd.quality;
474                 attrs[index + 2] = cd.feature;
475                 attrs[index + 3] = cd.level;
476                 attrs[index + 4] = cd.attrExt1;
477                 attrs[index + 5] = cd.attrExt2;
478             }   
479         }
480     }
481 
482 
483 }
484 
485 contract Presale is AccessService, Random {
486     ELHeroToken tokenContract;
487     mapping (uint16 => uint16) public cardPresaleCounter;
488     mapping (address => uint16[]) OwnerToPresale;
489     uint256 public jackpotBalance;
490 
491     event CardPreSelled(address indexed buyer, uint16 protoId);
492     event Jackpot(address indexed _winner, uint256 _value, uint16 _type);
493 
494     constructor(address _nftAddr) public {
495         addrAdmin = msg.sender;
496         addrService = msg.sender;
497         addrFinance = msg.sender;
498 
499         tokenContract = ELHeroToken(_nftAddr);
500 
501         cardPresaleCounter[1] = 20; //Human Fighter
502         cardPresaleCounter[2] = 20; //Human Tank
503         cardPresaleCounter[3] = 20; //Human Marksman
504         cardPresaleCounter[4] = 20; //Human Mage
505         cardPresaleCounter[5] = 20; //Human Support
506         cardPresaleCounter[6] = 20; //Elf Fighter
507         cardPresaleCounter[7] = 20; //Elf Tank
508         cardPresaleCounter[8] = 20; //...
509         cardPresaleCounter[9] = 20;
510         cardPresaleCounter[10] = 20;
511         cardPresaleCounter[11] = 20;//Orc
512         cardPresaleCounter[12] = 20;
513         cardPresaleCounter[13] = 20;
514         cardPresaleCounter[14] = 20;
515         cardPresaleCounter[15] = 20;
516         cardPresaleCounter[16] = 20;//Undead
517         cardPresaleCounter[17] = 20;
518         cardPresaleCounter[18] = 20;
519         cardPresaleCounter[19] = 20;
520         cardPresaleCounter[20] = 20;
521         cardPresaleCounter[21] = 20;//Spirit
522         cardPresaleCounter[22] = 20;
523         cardPresaleCounter[23] = 20;
524         cardPresaleCounter[24] = 20;
525         cardPresaleCounter[25] = 20;
526     }
527 
528     function() external payable {
529         require(msg.value > 0);
530         jackpotBalance += msg.value;
531     }
532 
533     function setELHeroTokenAddr(address _nftAddr) external onlyAdmin {
534         tokenContract = ELHeroToken(_nftAddr);
535 
536     }
537 
538     function cardPresale(uint16 _protoId) external payable whenNotPaused{
539         uint16 curSupply = cardPresaleCounter[_protoId];
540         require(curSupply > 0);
541         require(msg.value == 0.25 ether);
542         uint16[] storage buyArray = OwnerToPresale[msg.sender];
543         uint16[5] memory param = [10000 + _protoId, _protoId, 6, 0, 1];
544         tokenContract.createCard(msg.sender, param, 1);
545         buyArray.push(_protoId);
546         cardPresaleCounter[_protoId] = curSupply - 1;
547         emit CardPreSelled(msg.sender, _protoId);
548 
549         jackpotBalance += msg.value * 2 / 10;
550         addrFinance.transfer(address(this).balance - jackpotBalance);
551         //1%
552         uint256 seed = _rand();
553         if(seed % 100 == 99){
554             emit Jackpot(msg.sender, jackpotBalance, 2);
555             msg.sender.transfer(jackpotBalance);
556         }
557     }
558 
559     function withdraw() external {
560         require(msg.sender == addrFinance || msg.sender == addrAdmin);
561         addrFinance.transfer(address(this).balance);
562     }
563 
564     function getCardCanPresaleCount() external view returns (uint16[25] cntArray) {
565         cntArray[0] = cardPresaleCounter[1];
566         cntArray[1] = cardPresaleCounter[2];
567         cntArray[2] = cardPresaleCounter[3];
568         cntArray[3] = cardPresaleCounter[4];
569         cntArray[4] = cardPresaleCounter[5];
570         cntArray[5] = cardPresaleCounter[6];
571         cntArray[6] = cardPresaleCounter[7];
572         cntArray[7] = cardPresaleCounter[8];
573         cntArray[8] = cardPresaleCounter[9];
574         cntArray[9] = cardPresaleCounter[10];
575         cntArray[10] = cardPresaleCounter[11];
576         cntArray[11] = cardPresaleCounter[12];
577         cntArray[12] = cardPresaleCounter[13];
578         cntArray[13] = cardPresaleCounter[14];
579         cntArray[14] = cardPresaleCounter[15];
580         cntArray[15] = cardPresaleCounter[16];
581         cntArray[16] = cardPresaleCounter[17];
582         cntArray[17] = cardPresaleCounter[18];
583         cntArray[18] = cardPresaleCounter[19];
584         cntArray[19] = cardPresaleCounter[20];
585         cntArray[20] = cardPresaleCounter[21];
586         cntArray[21] = cardPresaleCounter[22];
587         cntArray[22] = cardPresaleCounter[23];
588         cntArray[23] = cardPresaleCounter[24];
589         cntArray[24] = cardPresaleCounter[25];
590     }
591 
592     function getBuyCount(address _owner) external view returns (uint32) {
593         return uint32(OwnerToPresale[_owner].length);
594     }
595 
596     function getBuyArray(address _owner) external view returns (uint16[]) {
597         uint16[] storage buyArray = OwnerToPresale[_owner];
598         return buyArray;
599     }
600 }