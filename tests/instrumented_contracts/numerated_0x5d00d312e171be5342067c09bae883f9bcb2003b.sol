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
336         require(_owner != address(0));
337         EtheremonDataBase data = EtheremonDataBase(dataContract);
338         return data.getMonsterDexSize(_owner);
339     }
340 
341     function ownerOf(uint256 _tokenId) external view returns (address _owner) {
342         EtheremonDataBase data = EtheremonDataBase(dataContract);
343         MonsterObjAcc memory obj;
344         (obj.monsterId, obj.classId, _owner, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
345         require(_owner != address(0));
346     }
347 
348 
349     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external {
350         _safeTransferFrom(_from, _to, _tokenId, _data);
351     }
352 
353     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external {
354         _safeTransferFrom(_from, _to, _tokenId, "");
355     }
356 
357     function transferFrom(address _from, address _to, uint256 _tokenId) external {
358         EtheremonDataBase data = EtheremonDataBase(dataContract);
359         MonsterObjAcc memory obj;
360         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
361         require(obj.trainer != address(0));
362         _canTransfer(_tokenId, obj.trainer);
363         
364         require(obj.trainer == _from);
365         require(_to != address(0));
366         _transfer(obj.trainer, _to, _tokenId);
367     }
368 
369     function transfer(address _to, uint256 _tokenId) external {
370         EtheremonDataBase data = EtheremonDataBase(dataContract);
371         MonsterObjAcc memory obj;
372         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
373         require(obj.trainer != address(0));
374         _canTransfer(_tokenId, obj.trainer);
375         
376         require(obj.trainer == msg.sender);
377         require(_to != address(0));
378         _transfer(obj.trainer, _to, _tokenId);
379     }
380 
381     function approve(address _approved, uint256 _tokenId) external {
382         EtheremonDataBase data = EtheremonDataBase(dataContract);
383         MonsterObjAcc memory obj;
384         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
385         require(obj.trainer != address(0));
386         _canOperate(obj.trainer);
387         EtheremonBattle battle = EtheremonBattle(battleContract);
388         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
389         if(battle.isOnBattle(obj.monsterId) || trade.isOnTrading(obj.monsterId))
390             revert();
391         
392         require(_approved != obj.trainer);
393 
394         idToApprovals[_tokenId] = _approved;
395         emit Approval(obj.trainer, _approved, _tokenId);
396     }
397 
398     function setApprovalForAll(address _operator, bool _approved) external {
399         require(_operator != address(0));
400         ownerToOperators[msg.sender][_operator] = _approved;
401         emit ApprovalForAll(msg.sender, _operator, _approved);
402     }
403 
404     function getApproved(uint256 _tokenId) public view returns (address) {
405         EtheremonDataBase data = EtheremonDataBase(dataContract);
406         MonsterObjAcc memory obj;
407         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
408         require(obj.trainer != address(0));
409         return idToApprovals[_tokenId];
410     }
411 
412     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
413         require(_owner != address(0));
414         require(_operator != address(0));
415         return ownerToOperators[_owner][_operator];
416     }
417 
418     function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) internal {
419         EtheremonDataBase data = EtheremonDataBase(dataContract);
420         MonsterObjAcc memory obj;
421         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
422         require(obj.trainer != address(0));
423         _canTransfer(_tokenId, obj.trainer);
424         
425         require(obj.trainer == _from);
426         require(_to != address(0));
427 
428         _transfer(obj.trainer, _to, _tokenId);
429 
430         if (_to.isContract()) {
431             bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data);
432             require(retval == MAGIC_ON_ERC721_RECEIVED);
433         }
434     }
435 
436     function _transfer(address _from, address _to, uint256 _tokenId) private {
437         _clearApproval(_tokenId);
438         EtheremonDataBase data = EtheremonDataBase(dataContract);
439         data.removeMonsterIdMapping(_from, uint64(_tokenId));
440         data.addMonsterIdMapping(_to, uint64(_tokenId));
441         emit Transfer(_from, _to, _tokenId);
442     }
443 
444 
445     function _burn(uint256 _tokenId) internal { 
446         _clearApproval(_tokenId);
447         
448         EtheremonDataBase data = EtheremonDataBase(dataContract);
449         MonsterObjAcc memory obj;
450         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(uint64(_tokenId));
451         require(obj.trainer != address(0));
452         
453         EtheremonBattle battle = EtheremonBattle(battleContract);
454         EtheremonTradeInterface trade = EtheremonTradeInterface(tradeContract);
455         if(battle.isOnBattle(obj.monsterId) || trade.isOnTrading(obj.monsterId))
456             revert();
457         
458         data.removeMonsterIdMapping(obj.trainer, uint64(_tokenId));
459         
460         emit Transfer(obj.trainer, address(0), _tokenId);
461     }
462 
463     function _clearApproval(uint256 _tokenId) internal {
464         if(idToApprovals[_tokenId] != 0) {
465             delete idToApprovals[_tokenId];
466         }
467     }
468 
469 }
470 
471 
472 contract EtheremonMonsterEnumerable is EtheremonMonsterTokenBasic, ERC721Enumerable {
473 
474     constructor() public {
475         supportedInterfaces[0x780e9d63] = true; // ERC721Enumerable
476     }
477 
478     function totalSupply() external view returns (uint256) {
479         EtheremonDataBase data = EtheremonDataBase(dataContract);
480         return data.totalMonster();
481     }
482 
483     function tokenByIndex(uint256 _index) external view returns (uint256) {
484         return _index;
485     }
486 
487     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
488         require(_owner != address(0));
489         EtheremonDataBase data = EtheremonDataBase(dataContract);
490         return data.getMonsterObjId(_owner, _index);
491     }
492 
493 }
494 
495 
496 contract EtheremonMonsterStandard is EtheremonMonsterEnumerable, ERC721Metadata {
497     string internal nftName;
498     string internal nftSymbol;
499     
500     mapping (uint256 => string) internal idToUri;
501     
502     constructor(string _name, string _symbol) public {
503         nftName = _name;
504         nftSymbol = _symbol;
505         supportedInterfaces[0x5b5e139f] = true; // ERC721Metadata
506     }
507     
508     function _burn(uint256 _tokenId) internal {
509         super._burn(_tokenId);
510         if (bytes(idToUri[_tokenId]).length != 0) {
511             delete idToUri[_tokenId];
512         }
513     }
514     
515     function _setTokenUri(uint256 _tokenId, string _uri) internal {
516         idToUri[_tokenId] = _uri;
517     }
518     
519     function name() external view returns (string _name) {
520         _name = nftName;
521     }
522     
523     function symbol() external view returns (string _symbol) {
524         _symbol = nftSymbol;
525     }
526     
527     function tokenURI(uint256 _tokenId) external view returns (string) {
528         return idToUri[_tokenId];
529     }
530 }
531 
532 contract EtheremonMonsterToken is EtheremonMonsterStandard("EtheremonMonster", "EMONA") {
533     uint8 constant public STAT_COUNT = 6;
534     uint8 constant public STAT_MAX = 32;
535 
536     uint seed = 0;
537     
538     mapping(uint8 => uint32) public levelExps;
539     mapping(uint32 => bool) classWhitelist;
540     mapping(address => bool) addressWhitelist;
541     
542     uint public gapFactor = 0.001 ether;
543     uint16 public priceIncreasingRatio = 1000;
544     
545     function setPriceIncreasingRatio(uint16 _ratio) onlyModerators external {
546         priceIncreasingRatio = _ratio;
547     }
548     
549     function setFactor(uint _gapFactor) onlyModerators public {
550         gapFactor = _gapFactor;
551     }
552     
553     function genLevelExp() onlyModerators external {
554         uint8 level = 1;
555         uint32 requirement = 100;
556         uint32 sum = requirement;
557         while(level <= 100) {
558             levelExps[level] = sum;
559             level += 1;
560             requirement = (requirement * 11) / 10 + 5;
561             sum += requirement;
562         }
563     }
564     
565     function setClassWhitelist(uint32 _classId, bool _status) onlyModerators external {
566         classWhitelist[_classId] = _status;
567     }
568 
569     function setAddressWhitelist(address _smartcontract, bool _status) onlyModerators external {
570         addressWhitelist[_smartcontract] = _status;
571     }
572 
573     function setTokenURI(uint256 _tokenId, string _uri) onlyModerators external {
574         _setTokenUri(_tokenId, _uri);
575     }
576     
577     function withdrawEther(address _sendTo, uint _amount) onlyOwner public {
578         if (_amount > address(this).balance) {
579             revert();
580         }
581         _sendTo.transfer(_amount);
582     }
583     
584     function mintMonster(uint32 _classId, address _trainer, string _name) onlyModerators external returns(uint){
585         EtheremonDataBase data = EtheremonDataBase(dataContract);
586         // add monster
587         uint64 objId = data.addMonsterObj(_classId, _trainer, _name);
588         uint8 value;
589         seed = getRandom(_trainer, block.number-1, seed, objId);
590         // generate base stat for the previous one
591         for (uint i=0; i < STAT_COUNT; i+= 1) {
592             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
593             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
594         }
595         emit Transfer(address(0), _trainer, objId);
596         return objId;
597     }
598     
599     function burnMonster(uint64 _tokenId) onlyModerators external {
600         _burn(_tokenId);
601     }
602     
603     function clearApproval(uint _tokenId) onlyModerators external {
604         _clearApproval(_tokenId);
605     }
606     
607     function triggerTransferEvent(address _from, address _to, uint _tokenId) onlyModerators external {
608         _clearApproval(_tokenId);
609         emit Transfer(_from, _to, _tokenId);
610     }
611     
612     // public api 
613     function getRandom(address _player, uint _block, uint _seed, uint _count) view public returns(uint) {
614         return uint(keccak256(abi.encodePacked(blockhash(_block), _player, _seed, _count)));
615     }
616     
617     function getLevel(uint32 exp) view public returns (uint8) {
618         uint8 minIndex = 1;
619         uint8 maxIndex = 100;
620         uint8 currentIndex;
621      
622         while (minIndex < maxIndex) {
623             currentIndex = (minIndex + maxIndex) / 2;
624             if (exp < levelExps[currentIndex])
625                 maxIndex = currentIndex;
626             else
627                 minIndex = currentIndex + 1;
628         }
629 
630         return minIndex;
631     }
632     
633     function getMonsterBaseStats(uint64 _monsterId) constant external returns(uint hp, uint pa, uint pd, uint sa, uint sd, uint speed) {
634         EtheremonDataBase data = EtheremonDataBase(dataContract);
635         uint[6] memory stats;
636         for(uint i=0; i < STAT_COUNT; i+=1) {
637             stats[i] = data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_BASE, _monsterId, i);
638         }
639         return (stats[0], stats[1], stats[2], stats[3], stats[4], stats[5]);
640     }
641     
642     function getMonsterCurrentStats(uint64 _monsterId) constant external returns(uint exp, uint level, uint hp, uint pa, uint pd, uint sa, uint sd, uint speed) {
643         EtheremonDataBase data = EtheremonDataBase(dataContract);
644         MonsterObjAcc memory obj;
645         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_monsterId);
646         
647         uint[6] memory stats;
648         uint i = 0;
649         level = getLevel(obj.exp);
650         for(i=0; i < STAT_COUNT; i+=1) {
651             stats[i] = data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_BASE, _monsterId, i);
652         }
653         for(i=0; i < STAT_COUNT; i++) {
654             stats[i] += uint(data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_STEP, obj.classId, i)) * level * 3;
655         }
656         
657         return (obj.exp, level, stats[0], stats[1], stats[2], stats[3], stats[4], stats[5]);
658     }
659     
660     function getMonsterCP(uint64 _monsterId) constant external returns(uint cp) {
661         EtheremonDataBase data = EtheremonDataBase(dataContract);
662         MonsterObjAcc memory obj;
663         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_monsterId);
664         
665         uint[6] memory stats;
666         uint i = 0;
667         cp = getLevel(obj.exp);
668         for(i=0; i < STAT_COUNT; i+=1) {
669             stats[i] = data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_BASE, _monsterId, i);
670         }
671         for(i=0; i < STAT_COUNT; i++) {
672             stats[i] += uint(data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_STEP, obj.classId, i)) * cp * 3;
673         }
674         
675         cp = (stats[0] + stats[1] + stats[2] + stats[3] + stats[4] + stats[5]) / 6;
676     }
677     
678     function getPrice(uint32 _classId) constant external returns(bool catchable, uint price) {
679         EtheremonDataBase data = EtheremonDataBase(dataContract);
680         MonsterClassAcc memory class;
681         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
682         
683         price = class.price;
684         if (class.total > 0)
685             price += class.price*(class.total-1)/priceIncreasingRatio;
686         
687         if (class.catchable == false) {
688             if (addressWhitelist[msg.sender] == true && classWhitelist[_classId] == true) {
689                 return (true, price);
690             }
691         }
692         
693         return (class.catchable, price);
694     }
695     
696     function getMonsterClassBasic(uint32 _classId) constant external returns(uint256, uint256, uint256, bool) {
697         EtheremonDataBase data = EtheremonDataBase(dataContract);
698         MonsterClassAcc memory class;
699         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
700         return (class.price, class.returnPrice, class.total, class.catchable);
701     }
702     
703     function renameMonster(uint64 _objId, string name) isActive external {
704         EtheremonDataBase data = EtheremonDataBase(dataContract);
705         MonsterObjAcc memory obj;
706         (obj.monsterId, obj.classId, obj.trainer, obj.exp, obj.createIndex, obj.lastClaimIndex, obj.createTime) = data.getMonsterObj(_objId);
707         if (obj.monsterId != _objId || obj.trainer != msg.sender) {
708             revert();
709         }
710         data.setMonsterObj(_objId, name, obj.exp, obj.createIndex, obj.lastClaimIndex);
711     }
712     
713     function catchMonster(address _player, uint32 _classId, string _name) isActive external payable returns(uint tokenId) {
714         EtheremonDataBase data = EtheremonDataBase(dataContract);
715         MonsterClassAcc memory class;
716         (class.classId, class.price, class.returnPrice, class.total, class.catchable) = data.getMonsterClass(_classId);
717         if (class.classId == 0) {
718             revert();
719         }
720         
721         if (class.catchable == false) {
722             if (addressWhitelist[msg.sender] == false || classWhitelist[_classId] == false) {
723                 revert();
724             }
725         }
726         
727         uint price = class.price;
728         if (class.total > 0)
729             price += class.price*(class.total-1)/priceIncreasingRatio;
730         if (msg.value + gapFactor < price) {
731             revert();
732         }
733         
734         // add new monster 
735         uint64 objId = data.addMonsterObj(_classId, _player, _name);
736         uint8 value;
737         seed = getRandom(_player, block.number-1, seed, objId);
738         // generate base stat for the previous one
739         for (uint i=0; i < STAT_COUNT; i+= 1) {
740             value = uint8(seed % STAT_MAX) + data.getElementInArrayType(EtheremonEnum.ArrayType.STAT_START, uint64(_classId), i);
741             data.addElementToArrayType(EtheremonEnum.ArrayType.STAT_BASE, objId, value);
742         }
743         
744         emit Transfer(address(0), _player, objId);
745 
746         return objId; 
747     }
748     
749     
750 }