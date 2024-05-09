1 pragma solidity ^0.4.18;
2 /* ==================================================================== */
3 /* Copyright (c) 2018 The Priate Conquest Project.  All rights reserved.
4 /* 
5 /* https://www.pirateconquest.com One of the world's slg games of blockchain 
6 /*  
7 /* authors rainy@livestar.com/Jonny.Fu@livestar.com
8 /*                 
9 /* ==================================================================== */
10 /// @title ERC-721 Non-Fungible Token Standard
11 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
12 ///  Note: the ERC-165 identifier for this interface is 0x80ac58cd
13 contract ERC721 /* is ERC165 */ {
14   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
15   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
16   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
17 
18   function balanceOf(address _owner) external view returns (uint256);
19   function ownerOf(uint256 _tokenId) external view returns (address);
20   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
21   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
22   function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
23   function approve(address _approved, uint256 _tokenId) external payable;
24   function setApprovalForAll(address _operator, bool _approved) external;
25   function getApproved(uint256 _tokenId) external view returns (address);
26   function isApprovedForAll(address _owner, address _operator) external view returns (bool);
27 }
28 
29 interface ERC165 {
30      function supportsInterface(bytes4 interfaceID) external view returns (bool);
31 }
32 
33 /// @title ERC-721 Non-Fungible Token Standard
34 interface ERC721TokenReceiver {
35 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
36 }
37 
38 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
39 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
40 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
41 interface ERC721Metadata /* is ERC721 */ {
42     function name() external view returns (string _name);
43     function symbol() external view returns (string _symbol);
44     function tokenURI(uint256 _tokenId) external view returns (string);
45 }
46 
47 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
48 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
49 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63
50 interface ERC721Enumerable /* is ERC721 */ {
51     function totalSupply() external view returns (uint256);
52     function tokenByIndex(uint256 _index) external view returns (uint256);
53     function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256);
54 }
55 
56 /**
57  * @title Ownable
58  * @dev The Ownable contract has an owner address, and provides basic authorization control
59  * functions, this simplifies the implementation of "user permissions".
60  */
61 contract Ownable {
62   address public owner;
63 
64   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66   /*
67    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
68    * account.
69    */
70   function Ownable() public {
71     owner = msg.sender;
72   }
73 
74   /**
75    * @dev Throws if called by any account other than the owner.
76    */
77   modifier onlyOwner() {
78     require(msg.sender == owner);
79     _;
80   }
81 
82   /**
83    * @dev Allows the current owner to transfer control of the contract to a newOwner.
84    * @param newOwner The address to transfer ownership to.
85    */
86   function transferOwnership(address newOwner) public onlyOwner {
87     require(newOwner != address(0));
88     OwnershipTransferred(owner, newOwner);
89     owner = newOwner;
90   }
91 }
92 
93 
94 /**
95  * @title Pausable
96  * @dev Base contract which allows children to implement an emergency stop mechanism.
97  */
98 contract Pausable is Ownable {
99   event Pause();
100   event Unpause();
101 
102   bool public paused = false;
103 
104 
105   /**
106    * @dev modifier to allow actions only when the contract IS paused
107    */
108   modifier whenNotPaused() {
109     require(!paused);
110     _;
111   }
112 
113   /**
114    * @dev modifier to allow actions only when the contract IS NOT paused
115    */
116   modifier whenPaused {
117     require(paused);
118     _;
119   }
120 
121   /**
122    * @dev called by the owner to pause, triggers stopped state
123    */
124   function pause() external onlyOwner whenNotPaused returns (bool) {
125     paused = true;
126     Pause();
127     return true;
128   }
129 
130   /**
131    * @dev called by the owner to unpause, returns to normal state
132    */
133   function unpause() external onlyOwner whenPaused returns (bool) {
134     paused = false;
135     Unpause();
136     return true;
137   }
138 }
139 
140 library SafeMath {
141 
142   /**
143   * @dev Multiplies two numbers, throws on overflow.
144   */
145   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146     if (a == 0) {
147       return 0;
148     }
149     uint256 c = a * b;
150     assert(c / a == b);
151     return c;
152   }
153 
154   function mul32(uint32 a, uint32 b) internal pure returns (uint32) {
155     if (a == 0) {
156       return 0;
157     }
158     uint32 c = a * b;
159     assert(c / a == b);
160     return c;
161   }
162 
163   /**
164   * @dev Integer division of two numbers, truncating the quotient.
165   */
166   function div(uint256 a, uint256 b) internal pure returns (uint256) {
167     // assert(b > 0); // Solidity automatically throws when dividing by 0
168     uint256 c = a / b;
169     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
170     return c;
171   }
172 
173   function div32(uint32 a, uint32 b) internal pure returns (uint32) {
174     // assert(b > 0); // Solidity automatically throws when dividing by 0
175     uint32 c = a / b;
176     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177     return c;
178   }
179 
180   /**
181   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
182   */
183   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184     assert(b <= a);
185     return a - b;
186   }
187 
188   function sub32(uint32 a, uint32 b) internal pure returns (uint32) {
189     assert(b <= a);
190     return a - b;
191   }
192 
193   /**
194   * @dev Adds two numbers, throws on overflow.
195   */
196   function add(uint256 a, uint256 b) internal pure returns (uint256) {
197     uint256 c = a + b;
198     assert(c >= a);
199     return c;
200   }
201 
202   function add32(uint32 a, uint32 b) internal pure returns (uint32) {
203     uint32 c = a + b;
204     assert(c >= a);
205     return c;
206   }
207 }
208 
209 contract AccessAdmin is Pausable {
210 
211   /// @dev Admin Address
212   mapping (address => bool) adminContracts;
213 
214   /// @dev Trust contract
215   mapping (address => bool) actionContracts;
216 
217   function setAdminContract(address _addr, bool _useful) public onlyOwner {
218     require(_addr != address(0));
219     adminContracts[_addr] = _useful;
220   }
221 
222   modifier onlyAdmin {
223     require(adminContracts[msg.sender]); 
224     _;
225   }
226 
227   function setActionContract(address _actionAddr, bool _useful) public onlyAdmin {
228     actionContracts[_actionAddr] = _useful;
229   }
230 
231   modifier onlyAccess() {
232     require(actionContracts[msg.sender]);
233     _;
234   }
235 }
236 
237 interface CaptainGameConfigInterface {
238   function getLevelConfig(uint32 cardId, uint32 level) external view returns (uint32 atk,uint32 defense,uint32 atk_min,uint32 atk_max);
239 }
240 contract CaptainToken is AccessAdmin, ERC721 {
241   using SafeMath for SafeMath;
242   //event 
243   event CreateCaptain(uint tokenId,uint32 captainId, address _owner, uint256 _price);
244   //ERC721
245   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
246   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
247   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
248   event LevelUP(address indexed _owner,uint32 oldLevel, uint32 newLevel);
249 
250   struct Captain {
251     uint32 captainId;  
252     uint32 color; // 1,2,3,4  
253     uint32 atk; 
254     uint32 defense;
255     uint32 level;
256     uint256 exp;
257   }
258   CaptainGameConfigInterface public config;
259 
260   Captain[] public captains; //dynamic Array
261   function CaptainToken() public {
262     captains.length += 1;
263     setAdminContract(msg.sender,true);
264     setActionContract(msg.sender,true);
265   }
266   //setting configuration
267   function setGameConfigContract(address _address) external onlyOwner {
268     config = CaptainGameConfigInterface(_address);
269   }
270 
271   /**MAPPING**/
272   /// @dev tokenId to owner  tokenId -> address
273   mapping (uint256 => address) public captainTokenIdToOwner;
274   /// @dev Equipment token ID search in owner array captainId -> tokenId
275   mapping (uint256 => uint256) captainIdToOwnerIndex;  
276   /// @dev captains owner by the owner (array)
277   mapping (address => uint256[]) ownerToCaptainArray;
278   /// @dev price of each token
279   mapping (uint256 => uint256) captainTokenIdToPrice;
280   /// @dev token count of captain
281   mapping (uint32 => uint256) tokenCountOfCaptain;
282   /// @dev tokens by the captain
283   mapping (uint256 => uint32) IndexToCaptain;
284   /// @dev The authorized address for each Captain
285   mapping (uint256 => address) captainTokenIdToApprovals;
286   /// @dev The authorized operators for each address
287   mapping (address => mapping (address => bool)) operatorToApprovals;
288   mapping(uint256 => bool) tokenToSell;
289   
290 
291   /*** CONSTRUCTOR ***/
292   /// @dev Amount of tokens destroyed
293   uint256 destroyCaptainCount;
294   
295   // modifier
296   /// @dev Check if token ID is valid
297   modifier isValidToken(uint256 _tokenId) {
298     require(_tokenId >= 1 && _tokenId <= captains.length);
299     require(captainTokenIdToOwner[_tokenId] != address(0)); 
300     _;
301   }
302   modifier canTransfer(uint256 _tokenId) {
303     require(msg.sender == captainTokenIdToOwner[_tokenId] || msg.sender == captainTokenIdToApprovals[_tokenId]);
304     _;
305   }
306   /// @dev Creates a new Captain with the given name.
307   function CreateCaptainToken(address _owner,uint256 _price, uint32 _captainId, uint32 _color,uint32 _atk,uint32 _defense,uint32 _level,uint256 _exp) public onlyAccess {
308     _createCaptainToken(_owner,_price,_captainId,_color,_atk,_defense,_level,_exp);
309   }
310 
311   /// For creating CaptainToken
312   function _createCaptainToken(address _owner, uint256 _price, uint32 _captainId, uint32 _color, uint32 _atk, uint32 _defense,uint32 _level,uint256 _exp) 
313   internal {
314     uint256 newTokenId = captains.length;
315     Captain memory _captain = Captain({
316       captainId: _captainId,
317       color: _color,
318       atk: _atk,
319       defense: _defense,
320       level: _level,
321       exp: _exp 
322     });
323     captains.push(_captain);
324     //event
325     CreateCaptain(newTokenId, _captainId, _owner, _price);
326     captainTokenIdToPrice[newTokenId] = _price;
327     IndexToCaptain[newTokenId] = _captainId;
328     tokenCountOfCaptain[_captainId] = SafeMath.add(tokenCountOfCaptain[_captainId],1);
329     // This will assign ownership, and also emit the Transfer event as
330     // per ERC721 draft
331     _transfer(address(0), _owner, newTokenId);
332   } 
333   /// @dev set the token price
334   function setTokenPrice(uint256 _tokenId, uint256 _price) external onlyAccess {
335     captainTokenIdToPrice[_tokenId] = _price;
336   }
337 
338   /// @dev let owner set the token price
339   function setTokenPriceByOwner(uint256 _tokenId, uint256 _price) external {
340     require(captainTokenIdToOwner[_tokenId] == msg.sender);
341     captainTokenIdToPrice[_tokenId] = _price;
342   }
343 
344   /// @dev set sellable
345   function setSelled(uint256 _tokenId, bool fsell) external onlyAccess {
346     tokenToSell[_tokenId] = fsell;
347   }
348 
349   function getSelled(uint256 _tokenId) external view returns (bool) {
350     return tokenToSell[_tokenId];
351   }
352 
353   /// @dev Do the real transfer with out any condition checking
354   /// @param _from The old owner of this Captain(If created: 0x0)
355   /// @param _to The new owner of this Captain 
356   /// @param _tokenId The tokenId of the Captain
357   function _transfer(address _from, address _to, uint256 _tokenId) internal {
358     if (_from != address(0)) {
359       uint256 indexFrom = captainIdToOwnerIndex[_tokenId];  // tokenId -> captainId
360       uint256[] storage cpArray = ownerToCaptainArray[_from];
361       require(cpArray[indexFrom] == _tokenId);
362 
363       // If the Captain is not the element of array, change it to with the last
364       if (indexFrom != cpArray.length - 1) {
365         uint256 lastTokenId = cpArray[cpArray.length - 1];
366         cpArray[indexFrom] = lastTokenId; 
367         captainIdToOwnerIndex[lastTokenId] = indexFrom;
368       }
369       cpArray.length -= 1; 
370     
371       if (captainTokenIdToApprovals[_tokenId] != address(0)) {
372         delete captainTokenIdToApprovals[_tokenId];
373       }      
374     }
375 
376     // Give the Captain to '_to'
377     captainTokenIdToOwner[_tokenId] = _to;
378     ownerToCaptainArray[_to].push(_tokenId);
379     captainIdToOwnerIndex[_tokenId] = ownerToCaptainArray[_to].length - 1;
380         
381     Transfer(_from != address(0) ? _from : this, _to, _tokenId);
382   }
383 
384 
385   /// @notice Returns all the relevant information about a specific tokenId.
386   /// @param _tokenId The tokenId of the captain
387   function getCaptainInfo(uint256 _tokenId) external view returns (
388     uint32 captainId,  
389     uint32 color, 
390     uint32 atk,
391     uint32 defense,
392     uint32 level,
393     uint256 exp, 
394     uint256 price,
395     address owner,
396     bool selled
397   ) {
398     Captain storage captain = captains[_tokenId];
399     captainId = captain.captainId;
400     color = captain.color;
401     atk = captain.atk;
402     defense = captain.defense;
403     level = captain.level;
404     exp = captain.exp;
405     price = captainTokenIdToPrice[_tokenId];
406     owner = captainTokenIdToOwner[_tokenId];
407     selled = tokenToSell[_tokenId];
408   }
409 
410   /// @dev levelUp 
411   function LevelUp(uint256 _tokenId,uint32 _level) external payable {
412     require(msg.sender == captainTokenIdToOwner[_tokenId]);
413     Captain storage captain = captains[_tokenId];
414     uint32 captainId = captain.captainId;
415     uint32 level = captain.level;
416     uint256 cur_exp = SafeMath.mul(SafeMath.mul(level,SafeMath.sub(level,1)),25); // level*(level-1)*25
417     uint256 req_exp = SafeMath.mul(SafeMath.mul(_level,SafeMath.sub(_level,1)),25);
418     require(captain.exp>=SafeMath.sub(req_exp,cur_exp));
419     uint256 exp = SafeMath.sub(captain.exp,SafeMath.sub(req_exp,cur_exp));
420     if (SafeMath.add32(level,_level)>=99) {
421       captains[_tokenId].level = 99;
422     } else {
423       captains[_tokenId].level = _level;
424     }
425 
426     (captains[_tokenId].atk,captains[_tokenId].defense,,) = config.getLevelConfig(captainId,captains[_tokenId].level);
427     captains[_tokenId].exp = exp;
428     //event tell the world
429     LevelUP(msg.sender,level,captain.level);
430   }
431 
432   /// ERC721 
433 
434   function balanceOf(address _owner) external view returns (uint256) {
435     require(_owner != address(0));
436     return ownerToCaptainArray[_owner].length;
437   }
438 
439   function ownerOf(uint256 _tokenId) external view returns (address) {
440     return captainTokenIdToOwner[_tokenId];
441   }
442   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable {
443     _safeTransferFrom(_from, _to, _tokenId, data);
444   }
445   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
446     _safeTransferFrom(_from, _to, _tokenId, "");
447   }
448 
449   /// @dev Actually perform the safeTransferFrom
450   function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
451     internal
452     isValidToken(_tokenId) 
453     canTransfer(_tokenId)
454     {
455     address owner = captainTokenIdToOwner[_tokenId];
456     require(owner != address(0) && owner == _from);
457     require(_to != address(0));
458         
459     _transfer(_from, _to, _tokenId);
460 
461     // Do the callback after everything is done to avoid reentrancy attack
462     /*uint256 codeSize;
463     assembly { codeSize := extcodesize(_to) }
464     if (codeSize == 0) {
465       return;
466     }*/
467     bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
468     // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
469     require(retval == 0xf0b9e5ba);
470   }
471     
472   /// @dev Transfer ownership of an Captain, '_to' must be a vaild address, or the WAR will lost
473   /// @param _from The current owner of the Captain
474   /// @param _to The new owner
475   /// @param _tokenId The Captain to transfer
476   function transferFrom(address _from, address _to, uint256 _tokenId)
477         external
478         whenNotPaused
479         isValidToken(_tokenId)
480         canTransfer(_tokenId)
481         payable
482     {
483     address owner = captainTokenIdToOwner[_tokenId];
484     require(owner != address(0));
485     require(owner == _from);
486     require(_to != address(0));
487         
488     _transfer(_from, _to, _tokenId);
489   }
490 
491   /// @dev Safe transfer by trust contracts
492   function safeTransferByContract(address _from,address _to, uint256 _tokenId) 
493   external
494   whenNotPaused
495   {
496     require(actionContracts[msg.sender]);
497 
498     require(_tokenId >= 1 && _tokenId <= captains.length);
499     address owner = captainTokenIdToOwner[_tokenId];
500     require(owner != address(0));
501     require(_to != address(0));
502     require(owner != _to);
503     require(_from == owner);
504 
505     _transfer(owner, _to, _tokenId);
506   }
507 
508   /// @dev Set or reaffirm the approved address for an captain
509   /// @param _approved The new approved captain controller
510   /// @param _tokenId The captain to approve
511   function approve(address _approved, uint256 _tokenId)
512     external
513     whenNotPaused 
514     payable
515   {
516     address owner = captainTokenIdToOwner[_tokenId];
517     require(owner != address(0));
518     require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
519 
520     captainTokenIdToApprovals[_tokenId] = _approved;
521     Approval(owner, _approved, _tokenId);
522   }
523 
524   /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
525   /// @param _operator Address to add to the set of authorized operators.
526   /// @param _approved True if the operators is approved, false to revoke approval
527   function setApprovalForAll(address _operator, bool _approved) 
528     external 
529     whenNotPaused
530   {
531     operatorToApprovals[msg.sender][_operator] = _approved;
532     ApprovalForAll(msg.sender, _operator, _approved);
533   }
534 
535   /// @dev Get the approved address for a single Captain
536   /// @param _tokenId The WAR to find the approved address for
537   /// @return The approved address for this WAR, or the zero address if there is none
538   function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
539     return captainTokenIdToApprovals[_tokenId];
540   }
541   
542   /// @dev Query if an address is an authorized operator for another address
543   /// @param _owner The address that owns the WARs
544   /// @param _operator The address that acts on behalf of the owner
545   /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
546   function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
547     return operatorToApprovals[_owner][_operator];
548   }
549   /// @notice A descriptive name for a collection of NFTs in this contract
550   function name() public pure returns(string) {
551     return "Pirate Conquest Token";
552   }
553   /// @notice An abbreviated name for NFTs in this contract
554   function symbol() public pure returns(string) {
555     return "PCT";
556   }
557   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
558   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
559   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
560   ///  Metadata JSON Schema".
561   //function tokenURI(uint256 _tokenId) external view returns (string);
562 
563   /// @notice Count NFTs tracked by this contract
564   /// @return A count of valid NFTs tracked by this contract, where each one of
565   ///  them has an assigned and queryable owner not equal to the zero address
566   function totalSupply() external view returns (uint256) {
567     return captains.length - destroyCaptainCount -1;
568   }
569   /// @notice Enumerate valid NFTs
570   /// @dev Throws if `_index` >= `totalSupply()`.
571   /// @param _index A counter less than `totalSupply()`
572   /// @return The token identifier for the `_index`th NFT,
573   ///  (sort order not specified)
574   function tokenByIndex(uint256 _index) external view returns (uint256) {
575     require(_index<(captains.length - destroyCaptainCount));
576     //return captainIdToOwnerIndex[_index];
577     return _index;
578   }
579   /// @notice Enumerate NFTs assigned to an owner
580   /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
581   ///  `_owner` is the zero address, representing invalid NFTs.
582   /// @param _owner An address where we are interested in NFTs owned by them
583   /// @param _index A counter less than `balanceOf(_owner)`
584   /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
585   ///   (sort order not specified)
586   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
587     require(_index < ownerToCaptainArray[_owner].length);
588     if (_owner != address(0)) {
589       uint256 tokenId = ownerToCaptainArray[_owner][_index];
590       return tokenId;
591     }
592   }
593 
594   /// @param _owner The owner whose celebrity tokens we are interested in.
595   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
596   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
597   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
598   ///  not contract-to-contract calls.
599   function tokensOfOwner(address _owner) external view returns (uint256[],uint32[]) {
600     uint256 len = ownerToCaptainArray[_owner].length;
601     uint256[] memory tokens = new uint256[](len);
602     uint32[] memory captainss = new uint32[](len);
603     uint256 icount;
604     if (_owner != address(0)) {
605       for (uint256 i=0;i<len;i++) {
606         tokens[i] = ownerToCaptainArray[_owner][icount];
607         captainss[i] = IndexToCaptain[ownerToCaptainArray[_owner][icount]];
608         icount++;
609       }
610     }
611     return (tokens,captainss);
612   }
613 
614   /// @param _captainId The captain whose celebrity tokens we are interested in.
615   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
616   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
617   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
618   ///  not contract-to-contract calls.
619   function tokensOfCaptain(uint32 _captainId) public view returns(uint256[] captainTokens) {
620     uint256 tokenCount = tokenCountOfCaptain[_captainId];
621     if (tokenCount == 0) {
622         // Return an empty array
623       return new uint256[](0);
624     } else {
625       uint256[] memory result = new uint256[](tokenCount);
626       uint256 totalcaptains = captains.length - destroyCaptainCount - 1;
627       uint256 resultIndex = 0;
628 
629       uint256 tokenId;
630       for (tokenId = 0; tokenId <= totalcaptains; tokenId++) {
631         if (IndexToCaptain[tokenId] == _captainId) {
632           result[resultIndex] = tokenId;
633           resultIndex++;
634         }
635       }
636       return result;
637     }
638   } 
639 }