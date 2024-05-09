1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13     if (a == 0) {
14       return 0;
15     }
16     c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return a / b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43     c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 /**
50  * Utility library of inline functions on addresses
51  */
52 library AddressUtils {
53 
54   /**
55    * Returns whether the target address is a contract
56    * @dev This function will return false if invoked during the constructor of a contract,
57    *  as the code is not actually created until after the constructor finishes.
58    * @param addr address to check
59    * @return whether the target address is a contract
60    */
61   function isContract(address addr) internal view returns (bool) {
62     uint256 size;
63     // XXX Currently there is no better way to check if there is a contract in an address
64     // than to check the size of the code at that address.
65     // See https://ethereum.stackexchange.com/a/14016/36603
66     // for more details about how this works.
67     // TODO Check this again before the Serenity release, because all addresses will be
68     // contracts then.
69     // solium-disable-next-line security/no-inline-assembly
70     assembly { size := extcodesize(addr) }
71     return size > 0;
72   }
73 
74 }
75 
76 interface ERC165 {
77     function supportsInterface(bytes4 _interfaceID) external view returns (bool);
78 }
79 
80 contract SupportsInterface is ERC165 {
81     
82     mapping(bytes4 => bool) internal supportedInterfaces;
83 
84     constructor() public {
85         supportedInterfaces[0x01ffc9a7] = true; // ERC165
86     }
87 
88     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
89         return supportedInterfaces[_interfaceID];
90     }
91 }
92 
93 interface ERC721 {
94     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
95     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
96     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
97     
98     function balanceOf(address _owner) external view returns (uint256);
99     function ownerOf(uint256 _tokenId) external view returns (address);
100     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external;
101     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
102     
103     function transferFrom(address _from, address _to, uint256 _tokenId) external;
104     function transfer(address _to, uint256 _tokenId) external;
105     function approve(address _approved, uint256 _tokenId) external;
106     function setApprovalForAll(address _operator, bool _approved) external;
107     
108     function getApproved(uint256 _tokenId) external view returns (address);
109     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
110 }
111 
112 interface ERC721Enumerable {
113     function totalSupply() external view returns (uint256);
114     function tokenByIndex(uint256 _index) external view returns (uint256);
115     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
116 }
117 
118 interface ERC721Metadata {
119     function name() external view returns (string _name);
120     function symbol() external view returns (string _symbol);
121     function tokenURI(uint256 _tokenId) external view returns (string);
122 }
123 
124 interface ERC721TokenReceiver {
125   function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
126 }
127 
128 contract BasicAccessControl {
129     address public owner;
130     // address[] public moderators;
131     uint16 public totalModerators = 0;
132     mapping (address => bool) public moderators;
133     bool public isMaintaining = false;
134 
135     constructor() public {
136         owner = msg.sender;
137     }
138 
139     modifier onlyOwner {
140         require(msg.sender == owner);
141         _;
142     }
143 
144     modifier onlyModerators() {
145         require(msg.sender == owner || moderators[msg.sender] == true);
146         _;
147     }
148 
149     modifier isActive {
150         require(!isMaintaining);
151         _;
152     }
153 
154     function ChangeOwner(address _newOwner) onlyOwner public {
155         if (_newOwner != address(0)) {
156             owner = _newOwner;
157         }
158     }
159 
160 
161     function AddModerator(address _newModerator) onlyOwner public {
162         if (moderators[_newModerator] == false) {
163             moderators[_newModerator] = true;
164             totalModerators += 1;
165         }
166     }
167     
168     function RemoveModerator(address _oldModerator) onlyOwner public {
169         if (moderators[_oldModerator] == true) {
170             moderators[_oldModerator] = false;
171             totalModerators -= 1;
172         }
173     }
174 
175     function UpdateMaintaining(bool _isMaintaining) onlyOwner public {
176         isMaintaining = _isMaintaining;
177     }
178 }
179 
180 contract EtheremonEnum {
181 
182     enum ResultCode {
183         SUCCESS,
184         ERROR_CLASS_NOT_FOUND,
185         ERROR_LOW_BALANCE,
186         ERROR_SEND_FAIL,
187         ERROR_NOT_TRAINER,
188         ERROR_NOT_ENOUGH_MONEY,
189         ERROR_INVALID_AMOUNT
190     }
191     
192     enum ArrayType {
193         CLASS_TYPE,
194         STAT_STEP,
195         STAT_START,
196         STAT_BASE,
197         OBJ_SKILL
198     }
199     
200     enum PropertyType {
201         ANCESTOR,
202         XFACTOR
203     }
204 }
205 
206 contract EtheremonDataBase {
207     
208     uint64 public totalMonster;
209     uint32 public totalClass;
210     
211     // write
212     function withdrawEther(address _sendTo, uint _amount) external returns(EtheremonEnum.ResultCode);
213     function addElementToArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint8 _value) external returns(uint);
214     function updateIndexOfArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint _index, uint8 _value) external returns(uint);
215     function setMonsterClass(uint32 _classId, uint256 _price, uint256 _returnPrice, bool _catchable) external returns(uint32);
216     function addMonsterObj(uint32 _classId, address _trainer, string _name) external returns(uint64);
217     function setMonsterObj(uint64 _objId, string _name, uint32 _exp, uint32 _createIndex, uint32 _lastClaimIndex) external;
218     function increaseMonsterExp(uint64 _objId, uint32 amount) external;
219     function decreaseMonsterExp(uint64 _objId, uint32 amount) external;
220     function removeMonsterIdMapping(address _trainer, uint64 _monsterId) external;
221     function addMonsterIdMapping(address _trainer, uint64 _monsterId) external;
222     function clearMonsterReturnBalance(uint64 _monsterId) external returns(uint256 amount);
223     function collectAllReturnBalance(address _trainer) external returns(uint256 amount);
224     function transferMonster(address _from, address _to, uint64 _monsterId) external returns(EtheremonEnum.ResultCode);
225     function addExtraBalance(address _trainer, uint256 _amount) external returns(uint256);
226     function deductExtraBalance(address _trainer, uint256 _amount) external returns(uint256);
227     function setExtraBalance(address _trainer, uint256 _amount) external;
228     
229     // read
230     function getSizeArrayType(EtheremonEnum.ArrayType _type, uint64 _id) constant external returns(uint);
231     function getElementInArrayType(EtheremonEnum.ArrayType _type, uint64 _id, uint _index) constant external returns(uint8);
232     function getMonsterClass(uint32 _classId) constant external returns(uint32 classId, uint256 price, uint256 returnPrice, uint32 total, bool catchable);
233     function getMonsterObj(uint64 _objId) constant external returns(uint64 objId, uint32 classId, address trainer, uint32 exp, uint32 createIndex, uint32 lastClaimIndex, uint createTime);
234     function getMonsterName(uint64 _objId) constant external returns(string name);
235     function getExtraBalance(address _trainer) constant external returns(uint256);
236     function getMonsterDexSize(address _trainer) constant external returns(uint);
237     function getMonsterObjId(address _trainer, uint index) constant external returns(uint64);
238     function getExpectedBalance(address _trainer) constant external returns(uint256);
239     function getMonsterReturn(uint64 _objId) constant external returns(uint256 current, uint256 total);
240 }
241 
242 interface EtheremonBattle {
243     function isOnBattle(uint64 _objId) constant external returns(bool);
244 }
245 
246 interface EtheremonTradeInterface {
247     function isOnTrading(uint64 _objId) constant external returns(bool);
248 }
249 
250 
251 contract EtheremonMonsterTokenBasic is ERC721, SupportsInterface, BasicAccessControl {
252 
253     using SafeMath for uint256;
254     using AddressUtils for address;
255     
256     struct MonsterClassAcc {
257         uint32 classId;
258         uint256 price;
259         uint256 returnPrice;
260         uint32 total;
261         bool catchable;
262     }
263 
264     struct MonsterObjAcc {
265         uint64 monsterId;
266         uint32 classId;
267         address trainer;
268         string name;
269         uint32 exp;
270         uint32 createIndex;
271         uint32 lastClaimIndex;
272         uint createTime;
273     }
274 
275     // data contract
276     address public dataContract;
277     address public battleContract;
278     address public tradeContract;
279     
280     // Mapping from NFT ID to approved address.
281     mapping (uint256 => address) internal idToApprovals;
282     
283     // Mapping from owner address to mapping of operator addresses.
284     mapping (address => mapping (address => bool)) internal ownerToOperators;
285     
286     /**
287     * @dev Magic value of a smart contract that can recieve NFT.
288     * Equal to: bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")).
289     */
290     bytes4 constant MAGIC_ON_ERC721_RECEIVED = 0x150b7a02;
291 
292     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
293     event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
294     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
295     
296     // internal function
297     function _canOperate(address _tokenOwner) constant internal {
298         require(_tokenOwner == msg.sender || ownerToOperators[_tokenOwner][msg.sender]);
299     }
300     
301     function _canTransfer(uint256 _tokenId, address _tokenOwner) constant internal {
302         EtheremonBattle battle = EtheremonBattle(battleContract);
303         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
304         require(!battle.isOnBattle(uint64(_tokenId)) && !trade.isOnTrading(uint64(_tokenId)));
305         require(_tokenOwner != address(0));
306         require(_tokenOwner == msg.sender || idToApprovals[_tokenId] == msg.sender || ownerToOperators[_tokenOwner][msg.sender]);
307     }
308     
309     function setOperationContracts(address _dataContract, address _battleContract, address _tradeContract) onlyModerators external {
310         dataContract = _dataContract;
311         battleContract = _battleContract;
312         tradeContract = _tradeContract;
313     }
314     
315     // public function
316 
317     constructor() public {
318         supportedInterfaces[0x80ac58cd] = true; // ERC721
319     }
320 
321     function isApprovable(address _owner, uint256 _tokenId) public constant returns(bool) {
322         EtheremonDataBase data = EtheremonDataBase(dataContract);
323         MonsterObjAcc memory obj;
324         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
325         if (obj.monsterId != uint64(_tokenId))
326             return false;
327         if (obj.trainer != _owner)
328             return false;
329         // check battle & trade contract 
330         EtheremonBattle battle = EtheremonBattle(battleContract);
331         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
332         return (!battle.isOnBattle(obj.monsterId) && !trade.isOnTrading(obj.monsterId));
333     }
334 
335     function balanceOf(address _owner) external view returns (uint256) {
336         EtheremonDataBase data = EtheremonDataBase(dataContract);
337         return data.getMonsterDexSize(_owner);
338     }
339 
340     function ownerOf(uint256 _tokenId) external view returns (address _owner) {
341         EtheremonDataBase data = EtheremonDataBase(dataContract);
342         MonsterObjAcc memory obj;
343         (obj.monsterId, obj.classId, _owner, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
344         require(_owner != address(0));
345     }
346 
347 
348     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
349         _safeTransferFrom(_from, _to, _tokenId, _data);
350     }
351 
352     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
353         _safeTransferFrom(_from, _to, _tokenId, "");
354     }
355 
356     function transferFrom(address _from, address _to, uint256 _tokenId) external {
357         EtheremonDataBase data = EtheremonDataBase(dataContract);
358         MonsterObjAcc memory obj;
359         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
360         require(obj.trainer != address(0));
361         _canTransfer(_tokenId, obj.trainer);
362         
363         require(obj.trainer == _from);
364         require(_to != address(0));
365         _transfer(obj.trainer, _to, _tokenId);
366     }
367 
368     function transfer(address _to, uint256 _tokenId) external {
369         EtheremonDataBase data = EtheremonDataBase(dataContract);
370         MonsterObjAcc memory obj;
371         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
372         require(obj.trainer != address(0));
373         _canTransfer(_tokenId, obj.trainer);
374         
375         require(obj.trainer == msg.sender);
376         require(_to != address(0));
377         _transfer(obj.trainer, _to, _tokenId);
378     }
379 
380     function approve(address _approved, uint256 _tokenId) external {
381         EtheremonDataBase data = EtheremonDataBase(dataContract);
382         MonsterObjAcc memory obj;
383         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
384         require(obj.trainer != address(0));
385         _canOperate(obj.trainer);
386         EtheremonBattle battle = EtheremonBattle(battleContract);
387         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
388         if(battle.isOnBattle(obj.monsterId) || trade.isOnTrading(obj.monsterId))
389             revert();
390         
391         require(_approved != obj.trainer);
392 
393         idToApprovals[_tokenId] = _approved;
394         emit Approval(obj.trainer, _approved, _tokenId);
395     }
396 
397     function setApprovalForAll(address _operator, bool _approved) external {
398         require(_operator != address(0));
399         ownerToOperators[msg.sender][_operator] = _approved;
400         emit ApprovalForAll(msg.sender, _operator, _approved);
401     }
402 
403     function getApproved(uint256 _tokenId) public view returns (address) {
404         EtheremonDataBase data = EtheremonDataBase(dataContract);
405         MonsterObjAcc memory obj;
406         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
407         require(obj.trainer != address(0));
408         return idToApprovals[_tokenId];
409     }
410 
411     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
412         require(_owner != address(0));
413         require(_operator != address(0));
414         return ownerToOperators[_owner][_operator];
415     }
416 
417     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) internal {
418         EtheremonDataBase data = EtheremonDataBase(dataContract);
419         MonsterObjAcc memory obj;
420         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
421         require(obj.trainer != address(0));
422         _canTransfer(_tokenId, obj.trainer);
423         
424         require(obj.trainer == _from);
425         require(_to != address(0));
426 
427         _transfer(obj.trainer, _to, _tokenId);
428 
429         if (_to.isContract()) {
430             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
431             require(retval == MAGIC_ON_ERC721_RECEIVED);
432         }
433     }
434 
435     function _transfer(address _from, address _to, uint256 _tokenId) private {
436         _clearApproval(_tokenId);
437         EtheremonDataBase data = EtheremonDataBase(dataContract);
438         data.removeMonsterIdMapping(_from, uint64(_tokenId));
439         data.addMonsterIdMapping(_to, uint64(_tokenId));
440         emit Transfer(_from, _to, _tokenId);
441     }
442 
443 
444     function _burn(uint256 _tokenId) internal { 
445         _clearApproval(_tokenId);
446         
447         EtheremonDataBase data = EtheremonDataBase(dataContract);
448         MonsterObjAcc memory obj;
449         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
450         require(obj.trainer != address(0));
451         
452         EtheremonBattle battle = EtheremonBattle(battleContract);
453         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
454         if(battle.isOnBattle(obj.monsterId) || trade.isOnTrading(obj.monsterId))
455             revert();
456         
457         data.removeMonsterIdMapping(obj.trainer, uint64(_tokenId));
458         
459         emit Transfer(obj.trainer, address(0), _tokenId);
460     }
461 
462     function _clearApproval(uint256 _tokenId) internal {
463         if(idToApprovals[_tokenId] != 0) {
464             delete idToApprovals[_tokenId];
465         }
466     }
467 
468 }
469 
470 
471 contract EtheremonMonsterEnumerable is EtheremonMonsterTokenBasic, ERC721Enumerable {
472 
473     constructor() public {
474         supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
475     }
476 
477     function totalSupply() external view returns (uint256) {
478         EtheremonDataBase data = EtheremonDataBase(dataContract);
479         return data.totalMonster();
480     }
481 
482     function tokenByIndex(uint256 _index) external view returns (uint256) {
483         return _index;
484     }
485 
486     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
487         EtheremonDataBase data = EtheremonDataBase(dataContract);
488         return data.getMonsterObjId(_owner, _index);
489     }
490 
491 }
492 
493 
494 contract EtheremonMonsterStandard is EtheremonMonsterEnumerable, ERC721Metadata {
495     string internal nftName;
496     string internal nftSymbol;
497     
498     mapping (uint256 => string) internal idToUri;
499     
500     constructor(string _name, string _symbol) public {
501         nftName = _name;
502         nftSymbol = _symbol;
503         supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
504     }
505     
506     function _burn(uint256 _tokenId) internal {
507         super._burn(_tokenId);
508         if (bytes(idToUri[_tokenId]).length != 0) {
509             delete idToUri[_tokenId];
510         }
511     }
512     
513     function _setTokenUri(uint256 _tokenId, string _uri) internal {
514         idToUri[_tokenId] = _uri;
515     }
516     
517     function name() external view returns (string _name) {
518         _name = nftName;
519     }
520     
521     function symbol() external view returns (string _symbol) {
522         _symbol = nftSymbol;
523     }
524     
525     function tokenURI(uint256 _tokenId) external view returns (string) {
526         return idToUri[_tokenId];
527     }
528 }
529 
530 contract EtheremonMonsterToken is EtheremonMonsterStandard("EtheremonMonster", "EMONA") {
531     uint8 constant public STAT_COUNT = 6;
532     uint8 constant public STAT_MAX = 32;
533 
534     uint seed = 0;
535     
536     mapping(uint8 => uint32) public levelExps;
537     mapping(uint32 => bool) classWhitelist;
538     mapping(address => bool) addressWhitelist;
539     
540     uint public gapFactor = 0.001 ether;
541     uint16 public priceIncreasingRatio = 1000;
542     
543     function setPriceIncreasingRatio(uint16 _ratio) onlyModerators external {
544         priceIncreasingRatio = _ratio;
545     }
546     
547     function setFactor(uint _gapFactor) onlyModerators public {
548         gapFactor = _gapFactor;
549     }
550     
551     function genLevelExp() onlyModerators external {
552         uint8 level = 1;
553         uint32 requirement = 100;
554         uint32 sum = requirement;
555         while(level <= 100) {
556             levelExps[level] = sum;
557             level += 1;
558             requirement = (requirement * 11) / 10 + 5;
559             sum += requirement;
560         }
561     }
562     
563     function setClassWhitelist(uint32 _classId, bool _status) onlyModerators external {
564         classWhitelist[_classId] = _status;
565     }
566 
567     function setAddressWhitelist(address _smartcontract, bool _status) onlyModerators external {
568         addressWhitelist[_smartcontract] = _status;
569     }
570 
571     function setTokenURI(uint256 _tokenId, string _uri) onlyModerators external {
572         _setTokenUri(_tokenId, _uri);
573     }
574     
575     function withdrawEther(address _sendTo, uint _amount) onlyOwner public {
576         if (_amount > address(this).balance) {
577             revert();
578         }
579         _sendTo.transfer(_amount);
580     }
581     
582     function mintMonster(uint32 _classId, address _trainer, string _name) onlyModerators external returns(uint){
583         EtheremonDataBase data = EtheremonDataBase(dataContract);
584         // add monster
585         uint64 objId = data.addMonsterObj(_classId, _trainer, _name);
586         uint8 value;
587         seed = getRandom(_trainer, block.number-1, seed, objId);
588         // generate base stat for the previous one
589         for (uint i=0; i < STAT_COUNT; i+= 1) {
590             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
591             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
592         }
593         emit Transfer(address(0), _trainer, objId);
594         return objId;
595     }
596     
597     function burnMonster(uint64 _tokenId) onlyModerators external {
598         _burn(_tokenId);
599     }
600     
601     function clearApproval(uint _tokenId) onlyModerators external {
602         _clearApproval(_tokenId);
603     }
604     
605     function triggerTransferEvent(address _from, address _to, uint _tokenId) onlyModerators external {
606         _clearApproval(_tokenId);
607         emit Transfer(_from, _to, _tokenId);
608     }
609     
610     // public api 
611     function getRandom(address _player, uint _block, uint _seed, uint _count) view public returns(uint) {
612         return uint(keccak256(abi.encodePacked(blockhash(_block), _player, _seed, _count)));
613     }
614     
615     function getLevel(uint32 exp) view public returns (uint8) {
616         uint8 minIndex = 1;
617         uint8 maxIndex = 100;
618         uint8 currentIndex;
619      
620         while (minIndex < maxIndex) {
621             currentIndex = (minIndex + maxIndex) / 2;
622             if (exp < levelExps[currentIndex])
623                 maxIndex = currentIndex;
624             else
625                 minIndex = currentIndex + 1;
626         }
627 
628         return minIndex;
629     }
630     
631     function getMonsterBaseStats(uint64 _monsterId) constant external returns(uint hp, uint pa, uint pd, uint sa, uint sd, uint speed) {
632         EtheremonDataBase data = EtheremonDataBase(dataContract);
633         uint[6] memory stats;
634         for(uint i=0; i < STAT_COUNT; i+=1) {
635             stats[i] = data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_BASE, _monsterId, i);
636         }
637         return (stats[0], stats[1], stats[2], stats[3], stats[4], stats[5]);
638     }
639     
640     function getMonsterCurrentStats(uint64 _monsterId) constant external returns(uint exp, uint level, uint hp, uint pa, uint pd, uint sa, uint sd, uint speed) {
641         EtheremonDataBase data = EtheremonDataBase(dataContract);
642         MonsterObjAcc memory obj;
643         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_monsterId);
644         
645         uint[6] memory stats;
646         uint i = 0;
647         level = getLevel(obj.exp);
648         for(i=0; i < STAT_COUNT; i+=1) {
649             stats[i] = data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_BASE, _monsterId, i);
650         }
651         for(i=0; i < STAT_COUNT; i++) {
652             stats[i] += uint(data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_STEP, obj.classId, i)) * level * 3;
653         }
654         
655         return (obj.exp, level, stats[0], stats[1], stats[2], stats[3], stats[4], stats[5]);
656     }
657     
658     function getMonsterCP(uint64 _monsterId) constant external returns(uint cp) {
659         EtheremonDataBase data = EtheremonDataBase(dataContract);
660         MonsterObjAcc memory obj;
661         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_monsterId);
662         
663         uint[6] memory stats;
664         uint i = 0;
665         cp = getLevel(obj.exp);
666         for(i=0; i < STAT_COUNT; i+=1) {
667             stats[i] = data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_BASE, _monsterId, i);
668         }
669         for(i=0; i < STAT_COUNT; i++) {
670             stats[i] += uint(data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_STEP, obj.classId, i)) * cp * 3;
671         }
672         
673         cp = (stats[0] + stats[1] + stats[2] + stats[3] + stats[4] + stats[5]) / 6;
674     }
675     
676     function getPrice(uint32 _classId) constant external returns(bool catchable, uint price) {
677         EtheremonDataBase data = EtheremonDataBase(dataContract);
678         MonsterClassAcc memory class;
679         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
680         
681         price = class.price;
682         if (class.total > 0)
683             price += class.price*(class.total-1)/priceIncreasingRatio;
684         
685         if (class.catchable == false) {
686             if (addressWhitelist[msg.sender] == true && classWhitelist[_classId] == true) {
687                 return (true, price);
688             }
689         }
690         
691         return (class.catchable, price);
692     }
693     
694     function getMonsterClassBasic(uint32 _classId) constant external returns(uint256, uint256, uint256, bool) {
695         EtheremonDataBase data = EtheremonDataBase(dataContract);
696         MonsterClassAcc memory class;
697         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
698         return (class.price, class.returnPrice, class.total, class.catchable);
699     }
700     
701     function renameMonster(uint64 _objId, string name) isActive external {
702         EtheremonDataBase data = EtheremonDataBase(dataContract);
703         MonsterObjAcc memory obj;
704         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
705         if (obj.monsterId != _objId || obj.trainer != msg.sender) {
706             revert();
707         }
708         data.setMonsterObj(_objId, name, obj.exp, obj.createIndex, obj.lastClaimIndex);
709     }
710     
711     function catchMonster(address _player, uint32 _classId, string _name) isActive external payable returns(uint tokenId) {
712         EtheremonDataBase data = EtheremonDataBase(dataContract);
713         MonsterClassAcc memory class;
714         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
715         if (class.classId == 0) {
716             revert();
717         }
718         
719         if (class.catchable == false) {
720             if (addressWhitelist[msg.sender] == false || classWhitelist[_classId] == false) {
721                 revert();
722             }
723         }
724         
725         uint price = class.price;
726         if (class.total > 0)
727             price += class.price*(class.total-1)/priceIncreasingRatio;
728         if (msg.value + gapFactor < price) {
729             revert();
730         }
731         
732         // add new monster 
733         uint64 objId = data.addMonsterObj(_classId, _player, _name);
734         uint8 value;
735         seed = getRandom(_player, block.number-1, seed, objId);
736         // generate base stat for the previous one
737         for (uint i=0; i < STAT_COUNT; i+= 1) {
738             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
739             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
740         }
741         
742         emit Transfer(address(0), _player, objId);
743 
744         return objId; 
745     }
746     
747     
748 }