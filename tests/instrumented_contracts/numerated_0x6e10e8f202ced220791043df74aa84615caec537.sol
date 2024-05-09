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
237 
238 contract KittyToken is AccessAdmin, ERC721 {
239   using SafeMath for SafeMath;
240   //event 
241   event CreateGift(uint tokenId,uint32 cardId, address _owner, uint256 _price);
242   //ERC721
243   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
244   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
245   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
246 
247   struct Kitty {
248     uint32 kittyId;
249   }
250 
251   Kitty[] public kitties; //dynamic Array
252   function KittyToken() public {
253     kitties.length += 1;
254     setAdminContract(msg.sender,true);
255     setActionContract(msg.sender,true);
256   }
257 
258   /**MAPPING**/
259   /// @dev tokenId to owner  tokenId -> address
260   mapping (uint256 => address) public TokenIdToOwner;
261   /// @dev Equipment token ID search in owner array kittyId -> tokenId
262   mapping (uint256 => uint256) kittyIdToOwnerIndex;  
263   /// @dev kittys owner by the owner (array)
264   mapping (address => uint256[]) ownerTokittyArray;
265   /// @dev price of each token
266   mapping (uint256 => uint256) TokenIdToPrice;
267   /// @dev token count of kitty
268   mapping (uint32 => uint256) tokenCountOfkitty;
269   /// @dev tokens by the kitty
270   mapping (uint256 => uint32) IndexTokitty;
271   /// @dev The authorized address for each kitty
272   mapping (uint256 => address) kittyTokenIdToApprovals;
273   /// @dev The authorized operators for each address
274   mapping (address => mapping (address => bool)) operatorToApprovals;
275   mapping(uint256 => bool) tokenToSell;
276   
277 
278   /*** CONSTRUCTOR ***/
279   /// @dev Amount of tokens destroyed
280   uint256 destroyKittyCount;
281   uint256 onAuction;
282   // modifier
283   /// @dev Check if token ID is valid
284   modifier isValidToken(uint256 _tokenId) {
285     require(_tokenId >= 1 && _tokenId <= kitties.length);
286     require(TokenIdToOwner[_tokenId] != address(0)); 
287     _;
288   }
289   modifier canTransfer(uint256 _tokenId) {
290     require(msg.sender == TokenIdToOwner[_tokenId]);
291     _;
292   }
293   /// @dev Creates a new kitty with the given name.
294   function CreateKittyToken(address _owner,uint256 _price, uint32 _cardId) public onlyAccess {
295     _createKittyToken(_owner,_price,_cardId);
296   }
297 
298     /// For creating GiftToken
299   function _createKittyToken(address _owner, uint256 _price, uint32 _kittyId) 
300   internal {
301     uint256 newTokenId = kitties.length;
302     Kitty memory _kitty = Kitty({
303       kittyId: _kittyId
304     });
305     kitties.push(_kitty);
306     //event
307     CreateGift(newTokenId, _kittyId, _owner, _price);
308     TokenIdToPrice[newTokenId] = _price;
309     IndexTokitty[newTokenId] = _kittyId;
310     tokenCountOfkitty[_kittyId] = SafeMath.add(tokenCountOfkitty[_kittyId],1);
311     // This will assign ownership, and also emit the Transfer event as
312     // per ERC721 draft
313     _transfer(address(0), _owner, newTokenId);
314   } 
315   /// @dev let owner set the token price
316   function setTokenPriceByOwner(uint256 _tokenId, uint256 _price) external {
317     require(TokenIdToOwner[_tokenId] == msg.sender);
318     TokenIdToPrice[_tokenId] = _price;
319   }
320 
321     /// @dev set the token price
322   function setTokenPrice(uint256 _tokenId, uint256 _price) external onlyAccess {
323     TokenIdToPrice[_tokenId] = _price;
324   }
325 
326   /// @notice Returns all the relevant information about a specific tokenId.
327   /// @param _tokenId The tokenId of the captain
328   function getKittyInfo(uint256 _tokenId) external view returns (
329     uint32 kittyId,  
330     uint256 price,
331     address owner,
332     bool selled
333   ) {
334     Kitty storage kitty = kitties[_tokenId];
335     kittyId = kitty.kittyId;
336     price = TokenIdToPrice[_tokenId];
337     owner = TokenIdToOwner[_tokenId];
338     selled = tokenToSell[_tokenId];
339   }
340   /// @dev Do the real transfer with out any condition checking
341   /// @param _from The old owner of this kitty(If created: 0x0)
342   /// @param _to The new owner of this kitty 
343   /// @param _tokenId The tokenId of the kitty
344   function _transfer(address _from, address _to, uint256 _tokenId) internal {
345     if (_from != address(0)) {
346       uint256 indexFrom = kittyIdToOwnerIndex[_tokenId];  // tokenId -> kittyId
347       uint256[] storage cpArray = ownerTokittyArray[_from];
348       require(cpArray[indexFrom] == _tokenId);
349 
350       // If the kitty is not the element of array, change it to with the last
351       if (indexFrom != cpArray.length - 1) {
352         uint256 lastTokenId = cpArray[cpArray.length - 1];
353         cpArray[indexFrom] = lastTokenId; 
354         kittyIdToOwnerIndex[lastTokenId] = indexFrom;
355       }
356       cpArray.length -= 1; 
357     
358       if (kittyTokenIdToApprovals[_tokenId] != address(0)) {
359         delete kittyTokenIdToApprovals[_tokenId];
360       }      
361     }
362 
363     // Give the kitty to '_to'
364     TokenIdToOwner[_tokenId] = _to;
365     ownerTokittyArray[_to].push(_tokenId);
366     kittyIdToOwnerIndex[_tokenId] = ownerTokittyArray[_to].length - 1;
367         
368     Transfer(_from != address(0) ? _from : this, _to, _tokenId);
369   }
370 
371   /// @dev Return all the auction tokens
372   function getAuctions() external view returns (uint256[]) {
373     uint256 totalgifts = kitties.length - destroyKittyCount - 1;
374 
375     uint256[] memory result = new uint256[](onAuction);
376     uint256 tokenId = 1;
377     for (uint i=0;i< totalgifts;i++) {
378       if (tokenToSell[tokenId] == true) {
379         result[i] = tokenId;
380         tokenId ++;
381       }
382     }
383     return result;
384   }
385   /// ERC721 
386 
387   function balanceOf(address _owner) external view returns (uint256) {
388     require(_owner != address(0));
389     return ownerTokittyArray[_owner].length;
390   }
391 
392   function ownerOf(uint256 _tokenId) external view returns (address) {
393     return TokenIdToOwner[_tokenId];
394   }
395   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable {
396     _safeTransferFrom(_from, _to, _tokenId, data);
397   }
398   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
399     _safeTransferFrom(_from, _to, _tokenId, "");
400   }
401 
402   /// @dev Actually perform the safeTransferFrom
403   function _safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) 
404     internal
405     isValidToken(_tokenId) 
406     canTransfer(_tokenId)
407     {
408     address owner = TokenIdToOwner[_tokenId];
409     require(owner != address(0) && owner == _from);
410     require(_to != address(0));
411         
412     _transfer(_from, _to, _tokenId);
413 
414     // Do the callback after everything is done to avoid reentrancy attack
415     /*uint256 codeSize;
416     assembly { codeSize := extcodesize(_to) }
417     if (codeSize == 0) {
418       return;
419     }*/
420     bytes4 retval = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
421     // bytes4(keccak256("onERC721Received(address,uint256,bytes)")) = 0xf0b9e5ba;
422     require(retval == 0xf0b9e5ba);
423   }
424     
425   /// @dev Transfer ownership of an kitty, '_to' must be a vaild address, or the WAR will lost
426   /// @param _from The current owner of the kitty
427   /// @param _to The new owner
428   /// @param _tokenId The kitty to transfer
429   function transferFrom(address _from, address _to, uint256 _tokenId)
430         external
431         whenNotPaused
432         isValidToken(_tokenId)
433         canTransfer(_tokenId)
434         payable
435     {
436     address owner = TokenIdToOwner[_tokenId];
437     require(owner != address(0));
438     require(owner == _from);
439     require(_to != address(0));
440         
441     _transfer(_from, _to, _tokenId);
442   }
443 
444   /// @dev Safe transfer by trust contracts
445   function safeTransferByContract(address _from,address _to, uint256 _tokenId) 
446   external
447   whenNotPaused
448   {
449     require(actionContracts[msg.sender]);
450 
451     require(_tokenId >= 1 && _tokenId <= kitties.length);
452     address owner = TokenIdToOwner[_tokenId];
453     require(owner != address(0));
454     require(_to != address(0));
455     require(owner != _to);
456     require(_from == owner);
457 
458     _transfer(owner, _to, _tokenId);
459   }
460 
461   /// @dev Set or reaffirm the approved address for an kitty
462   /// @param _approved The new approved kitty controller
463   /// @param _tokenId The kitty to approve
464   function approve(address _approved, uint256 _tokenId)
465     external
466     whenNotPaused 
467     payable
468   {
469     address owner = TokenIdToOwner[_tokenId];
470     require(owner != address(0));
471     require(msg.sender == owner || operatorToApprovals[owner][msg.sender]);
472 
473     kittyTokenIdToApprovals[_tokenId] = _approved;
474     Approval(owner, _approved, _tokenId);
475   }
476 
477   /// @dev Enable or disable approval for a third party ("operator") to manage all your asset.
478   /// @param _operator Address to add to the set of authorized operators.
479   /// @param _approved True if the operators is approved, false to revoke approval
480   function setApprovalForAll(address _operator, bool _approved) 
481     external 
482     whenNotPaused
483   {
484     operatorToApprovals[msg.sender][_operator] = _approved;
485     ApprovalForAll(msg.sender, _operator, _approved);
486   }
487 
488   /// @dev Get the approved address for a single kitty
489   /// @param _tokenId The WAR to find the approved address for
490   /// @return The approved address for this WAR, or the zero address if there is none
491   function getApproved(uint256 _tokenId) external view isValidToken(_tokenId) returns (address) {
492     return kittyTokenIdToApprovals[_tokenId];
493   }
494   
495   /// @dev Query if an address is an authorized operator for another address
496   /// @param _owner The address that owns the WARs
497   /// @param _operator The address that acts on behalf of the owner
498   /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
499   function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
500     return operatorToApprovals[_owner][_operator];
501   }
502   /// @notice A descriptive name for a collection of NFTs in this contract
503   function name() public pure returns(string) {
504     return "Pirate Kitty Token";
505   }
506   /// @notice An abbreviated name for NFTs in this contract
507   function symbol() public pure returns(string) {
508     return "KCT";
509   }
510   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
511   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
512   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
513   ///  Metadata JSON Schema".
514   //function tokenURI(uint256 _tokenId) external view returns (string);
515 
516   /// @notice Count NFTs tracked by this contract
517   /// @return A count of valid NFTs tracked by this contract, where each one of
518   ///  them has an assigned and queryable owner not equal to the zero address
519   function totalSupply() external view returns (uint256) {
520     return kitties.length - destroyKittyCount -1;
521   }
522   /// @notice Enumerate valid NFTs
523   /// @dev Throws if `_index` >= `totalSupply()`.
524   /// @param _index A counter less than `totalSupply()`
525   /// @return The token identifier for the `_index`th NFT,
526   ///  (sort order not specified)
527   function tokenByIndex(uint256 _index) external view returns (uint256) {
528     require(_index<(kitties.length - destroyKittyCount));
529     //return kittyIdToOwnerIndex[_index];
530     return _index;
531   }
532   /// @notice Enumerate NFTs assigned to an owner
533   /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
534   ///  `_owner` is the zero address, representing invalid NFTs.
535   /// @param _owner An address where we are interested in NFTs owned by them
536   /// @param _index A counter less than `balanceOf(_owner)`
537   /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
538   ///   (sort order not specified)
539   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256) {
540     require(_index < ownerTokittyArray[_owner].length);
541     if (_owner != address(0)) {
542       uint256 tokenId = ownerTokittyArray[_owner][_index];
543       return tokenId;
544     }
545   }
546 
547   /// @param _owner The owner whose celebrity tokens we are interested in.
548   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
549   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
550   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
551   ///  not contract-to-contract calls.
552   function tokensOfOwner(address _owner) external view returns (uint256[],uint32[]) {
553     uint256 len = ownerTokittyArray[_owner].length;
554     uint256[] memory tokens = new uint256[](len);
555     uint32[] memory kittyss = new uint32[](len);
556     uint256 icount;
557     if (_owner != address(0)) {
558       for (uint256 i=0;i<len;i++) {
559         tokens[i] = ownerTokittyArray[_owner][icount];
560         kittyss[i] = IndexTokitty[ownerTokittyArray[_owner][icount]];
561         icount++;
562       }
563     }
564     return (tokens,kittyss);
565   }
566 
567   /// @param _kittyId The kitty whose celebrity tokens we are interested in.
568   /// @dev This method MUST NEVER be called by smart contract code. First, it's fairly
569   ///  expensive (it walks the entire Persons array looking for persons belonging to owner),
570   ///  but it also returns a dynamic array, which is only supported for web3 calls, and
571   ///  not contract-to-contract calls.
572   function tokensOfkitty(uint32 _kittyId) public view returns(uint256[] kittyTokens) {
573     uint256 tokenCount = tokenCountOfkitty[_kittyId];
574     if (tokenCount == 0) {
575         // Return an empty array
576       return new uint256[](0);
577     } else {
578       uint256[] memory result = new uint256[](tokenCount);
579       uint256 totalkitties = kitties.length - destroyKittyCount - 1;
580       uint256 resultIndex = 0;
581 
582       uint256 tokenId;
583       for (tokenId = 0; tokenId <= totalkitties; tokenId++) {
584         if (IndexTokitty[tokenId] == _kittyId) {
585           result[resultIndex] = tokenId;
586           resultIndex++;
587         }
588       }
589       return result;
590     }
591   } 
592 }