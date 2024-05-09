1 pragma solidity ^0.4.13;
2 
3 contract SplitPayment {
4   using SafeMath for uint256;
5 
6   uint256 public totalShares = 0;
7   uint256 public totalReleased = 0;
8 
9   mapping(address => uint256) public shares;
10   mapping(address => uint256) public released;
11   address[] public payees;
12 
13   /**
14    * @dev Constructor
15    */
16   function SplitPayment(address[] _payees, uint256[] _shares) public payable {
17     require(_payees.length == _shares.length);
18 
19     for (uint256 i = 0; i < _payees.length; i++) {
20       addPayee(_payees[i], _shares[i]);
21     }
22   }
23 
24   /**
25    * @dev payable fallback
26    */
27   function () public payable {}
28 
29   /**
30    * @dev Claim your share of the balance.
31    */
32   function claim() public {
33     address payee = msg.sender;
34 
35     require(shares[payee] > 0);
36 
37     uint256 totalReceived = this.balance.add(totalReleased);
38     uint256 payment = totalReceived.mul(shares[payee]).div(totalShares).sub(released[payee]);
39 
40     require(payment != 0);
41     require(this.balance >= payment);
42 
43     released[payee] = released[payee].add(payment);
44     totalReleased = totalReleased.add(payment);
45 
46     payee.transfer(payment);
47   }
48 
49   /**
50    * @dev Add a new payee to the contract.
51    * @param _payee The address of the payee to add.
52    * @param _shares The number of shares owned by the payee.
53    */
54   function addPayee(address _payee, uint256 _shares) internal {
55     require(_payee != address(0));
56     require(_shares > 0);
57     require(shares[_payee] == 0);
58 
59     payees.push(_payee);
60     shares[_payee] = _shares;
61     totalShares = totalShares.add(_shares);
62   }
63 }
64 
65 interface ERC721Metadata /* is ERC721 */ {
66     /// @notice A descriptive name for a collection of NFTs in this contract
67     function name() external pure returns (string _name);
68 
69     /// @notice An abbreviated name for NFTs in this contract
70     function symbol() external pure returns (string _symbol);
71 
72     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
73     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
74     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
75     ///  Metadata JSON Schema".
76     function tokenURI(uint256 _tokenId) external view returns (string);
77 }
78 
79 library SafeMath {
80 
81   /**
82   * @dev Multiplies two numbers, throws on overflow.
83   */
84   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
85     if (a == 0) {
86       return 0;
87     }
88     uint256 c = a * b;
89     assert(c / a == b);
90     return c;
91   }
92 
93   /**
94   * @dev Integer division of two numbers, truncating the quotient.
95   */
96   function div(uint256 a, uint256 b) internal pure returns (uint256) {
97     // assert(b > 0); // Solidity automatically throws when dividing by 0
98     uint256 c = a / b;
99     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
100     return c;
101   }
102 
103   /**
104   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
105   */
106   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
107     assert(b <= a);
108     return a - b;
109   }
110 
111   /**
112   * @dev Adds two numbers, throws on overflow.
113   */
114   function add(uint256 a, uint256 b) internal pure returns (uint256) {
115     uint256 c = a + b;
116     assert(c >= a);
117     return c;
118   }
119 }
120 
121 interface ERC721 /* is ERC165 */ {
122     /// @dev This emits when ownership of any NFT changes by any mechanism.
123     ///  This event emits when NFTs are created (`from` == 0) and destroyed
124     ///  (`to` == 0). Exception: during contract creation, any number of NFTs
125     ///  may be created and assigned without emitting Transfer. At the time of
126     ///  any transfer, the approved address for that NFT (if any) is reset to none.
127     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
128 
129     /// @dev This emits when the approved address for an NFT is changed or
130     ///  reaffirmed. The zero address indicates there is no approved address.
131     ///  When a Transfer event emits, this also indicates that the approved
132     ///  address for that NFT (if any) is reset to none.
133     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
134 
135     /// @dev This emits when an operator is enabled or disabled for an owner.
136     ///  The operator can manage all NFTs of the owner.
137     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
138 
139     /// @notice Count all NFTs assigned to an owner
140     /// @dev NFTs assigned to the zero address are considered invalid, and this
141     ///  function throws for queries about the zero address.
142     /// @param _owner An address for whom to query the balance
143     /// @return The number of NFTs owned by `_owner`, possibly zero
144     function balanceOf(address _owner) external view returns (uint256);
145 
146     /// @notice Find the owner of an NFT
147     /// @param _tokenId The identifier for an NFT
148     /// @dev NFTs assigned to zero address are considered invalid, and queries
149     ///  about them do throw.
150     /// @return The address of the owner of the NFT
151     function ownerOf(uint256 _tokenId) external view returns (address);
152 
153     /// @notice Transfers the ownership of an NFT from one address to another address
154     /// @dev Throws unless `msg.sender` is the current owner, an authorized
155     ///  operator, or the approved address for this NFT. Throws if `_from` is
156     ///  not the current owner. Throws if `_to` is the zero address. Throws if
157     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
158     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
159     ///  `onERC721Received` on `_to` and throws if the return value is not
160     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
161     /// @param _from The current owner of the NFT
162     /// @param _to The new owner
163     /// @param _tokenId The NFT to transfer
164     /// @param data Additional data with no specified format, sent in call to `_to`
165     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable;
166 	
167     /// @notice Transfers the ownership of an NFT from one address to another address
168     /// @dev This works identically to the other function with an extra data parameter,
169     ///  except this function just sets data to ""
170     /// @param _from The current owner of the NFT
171     /// @param _to The new owner
172     /// @param _tokenId The NFT to transfer
173     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
174 
175     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
176     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
177     ///  THEY MAY BE PERMANENTLY LOST
178     /// @dev Throws unless `msg.sender` is the current owner, an authorized
179     ///  operator, or the approved address for this NFT. Throws if `_from` is
180     ///  not the current owner. Throws if `_to` is the zero address. Throws if
181     ///  `_tokenId` is not a valid NFT.
182     /// @param _from The current owner of the NFT
183     /// @param _to The new owner
184     /// @param _tokenId The NFT to transfer
185     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
186 
187     /// @notice Set or reaffirm the approved address for an NFT
188     /// @dev The zero address indicates there is no approved address.
189     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
190     ///  operator of the current owner.
191     /// @param _approved The new approved NFT controller
192     /// @param _tokenId The NFT to approve
193     function approve(address _approved, uint256 _tokenId) external payable;
194 
195     /// @notice Enable or disable approval for a third party ("operator") to manage
196     ///  all your assets.
197     /// @dev Throws unless `msg.sender` is the current NFT owner.
198     /// @dev Emits the ApprovalForAll event
199     /// @param _operator Address to add to the set of authorized operators.
200     /// @param _approved True if the operators is approved, false to revoke approval
201     function setApprovalForAll(address _operator, bool _approved) external;
202 
203     /// @notice Get the approved address for a single NFT
204     /// @dev Throws if `_tokenId` is not a valid NFT
205     /// @param _tokenId The NFT to find the approved address for
206     /// @return The approved address for this NFT, or the zero address if there is none
207     function getApproved(uint256 _tokenId) external view returns (address);
208 
209     /// @notice Query if an address is an authorized operator for another address
210     /// @param _owner The address that owns the NFTs
211     /// @param _operator The address that acts on behalf of the owner
212     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
213     function isApprovedForAll(address _owner, address _operator) external view returns (bool);
214 }
215 
216 contract CorsariumAccessControl is SplitPayment {
217 //contract CorsariumAccessControl {
218    
219     event ContractUpgrade(address newContract);
220 
221     // The addresses of the accounts (or contracts) that can execute actions within each roles.
222     address public megoAddress = 0x4ab6C984E72CbaB4162429721839d72B188010E3;
223     address public publisherAddress = 0x00C0bCa70EAaADF21A158141EC7eA699a17D63ed;
224     // cat, rene, pablo,  cristean, chulini, pablo, david, mego
225     address[] public teamAddresses = [0x4978FaF663A3F1A6c74ACCCCBd63294Efec64624, 0x772009E69B051879E1a5255D9af00723df9A6E04, 0xA464b05832a72a1a47Ace2Be18635E3a4c9a240A, 0xd450fCBfbB75CDAeB65693849A6EFF0c2976026F, 0xd129BBF705dC91F50C5d9B44749507f458a733C8, 0xfDC2ad68fd1EF5341a442d0E2fC8b974E273AC16, 0x4ab6C984E72CbaB4162429721839d72B188010E3];
226     // todo: add addresses of creators
227 
228     // @dev Keeps track whether the contract is paused. When that is true, most actions are blocked
229     bool public paused = false;
230 
231     modifier onlyTeam() {
232         require(msg.sender == teamAddresses[0] || msg.sender == teamAddresses[1] || msg.sender == teamAddresses[2] || msg.sender == teamAddresses[3] || msg.sender == teamAddresses[4] || msg.sender == teamAddresses[5] || msg.sender == teamAddresses[6] || msg.sender == teamAddresses[7]);
233         _; // do the rest
234     }
235 
236     modifier onlyPublisher() {
237         require(msg.sender == publisherAddress);
238         _;
239     }
240 
241     modifier onlyMEGO() {
242         require(msg.sender == megoAddress);
243         _;
244     }
245 
246     /*** Pausable functionality adapted from OpenZeppelin ***/
247 
248     /// @dev Modifier to allow actions only when the contract IS NOT paused
249     modifier whenNotPaused() {
250         require(!paused);
251         _;
252     }
253 
254     /// @dev Modifier to allow actions only when the contract IS paused
255     modifier whenPaused {
256         require(paused);
257         _;
258     }
259 
260     function CorsariumAccessControl() public {
261         megoAddress = msg.sender;
262     }
263 
264     /// @dev Called by any team member to pause the contract. Used only when
265     ///  a bug or exploit is detected and we need to limit damage.
266     function pause() external onlyTeam whenNotPaused {
267         paused = true;
268     }
269 
270     /// @dev Unpauses the smart contract. Can only be called by MEGO, since
271     ///  one reason we may pause the contract is when team accounts are
272     ///  compromised.
273     /// @notice This is public rather than external so it can be called by
274     ///  derived contracts.
275     function unpause() public onlyMEGO whenPaused {
276         // can't unpause if contract was upgraded
277         paused = false;
278     }
279 
280 }
281 
282 contract CardBase is CorsariumAccessControl, ERC721, ERC721Metadata {
283 
284     /*** EVENTS ***/
285 
286     /// @dev The Print event is fired whenever a new card comes into existence.
287     event Print(address owner, uint256 cardId);
288     
289     uint256 lastPrintedCard = 0;
290      
291     mapping (uint256 => address) public tokenIdToOwner;  // 721 tokenIdToOwner
292     mapping (address => uint256) public ownerTokenCount; // 721 ownerTokenCount
293     mapping (uint256 => address) public tokenIdToApproved; // 721 tokenIdToApprovedAddress
294     mapping (uint256 => uint256) public tokenToCardIndex; // 721 tokenIdToMetadata
295     //mapping (uint256 => uint256) public tokenCountIndex;
296     //mapping (address => uint256[]) internal ownerToTokensOwned;
297     //mapping (uint256 => uint256) internal tokenIdToOwnerArrayIndex;
298 
299     /// @dev Assigns ownership of a specific card to an address.
300     /*function _transfer(address _from, address _to, uint256 _tokenId) internal {
301       
302         ownershipTokenCount[_to]++;
303         // transfer ownership
304         cardIndexToOwner[_tokenId] = _to;
305        
306         // Emit the transfer event.
307         Transfer(_from, _to, _tokenId);
308         
309     }*/
310     
311     function _createCard(uint256 _prototypeId, address _owner) internal returns (uint) {
312 
313         // This will assign ownership, and also emit the Transfer event as
314         // per ERC721 draft
315         require(uint256(1000000) > lastPrintedCard);
316         lastPrintedCard++;
317         tokenToCardIndex[lastPrintedCard] = _prototypeId;
318         _setTokenOwner(lastPrintedCard, _owner);
319         //_addTokenToOwnersList(_owner, lastPrintedCard);
320         Transfer(0, _owner, lastPrintedCard);
321         //tokenCountIndex[_prototypeId]++;
322         
323         //_transfer(0, _owner, lastPrintedCard); //<-- asd
324         
325 
326         return lastPrintedCard;
327     }
328 
329     function _clearApprovalAndTransfer(address _from, address _to, uint _tokenId) internal {
330         _clearTokenApproval(_tokenId);
331         //_removeTokenFromOwnersList(_from, _tokenId);
332         ownerTokenCount[_from]--;
333         _setTokenOwner(_tokenId, _to);
334         //_addTokenToOwnersList(_to, _tokenId);
335     }
336 
337     function _ownerOf(uint _tokenId) internal view returns (address _owner) {
338         return tokenIdToOwner[_tokenId];
339     }
340 
341     function _approve(address _to, uint _tokenId) internal {
342         tokenIdToApproved[_tokenId] = _to;
343     }
344 
345     function _getApproved(uint _tokenId) internal view returns (address _approved) {
346         return tokenIdToApproved[_tokenId];
347     }
348 
349     function _clearTokenApproval(uint _tokenId) internal {
350         tokenIdToApproved[_tokenId] = address(0);
351     }
352 
353     function _setTokenOwner(uint _tokenId, address _owner) internal {
354         tokenIdToOwner[_tokenId] = _owner;
355         ownerTokenCount[_owner]++;
356     }
357 
358 }
359 
360 contract CardOwnership is CardBase {
361     /// @notice Count all NFTs assigned to an owner
362     /// @dev NFTs assigned to the zero address are considered invalid, and this
363     ///  function throws for queries about the zero address.
364     /// @param _owner An address for whom to query the balance
365     /// @return The number of NFTs owned by `_owner`, possibly zero
366     function balanceOf(address _owner) external view returns (uint256) {
367         require(_owner != address(0));
368         return ownerTokenCount[_owner];
369     }
370 
371     /// @notice Find the owner of an NFT
372     /// @param _tokenId The identifier for an NFT
373     /// @dev NFTs assigned to zero address are considered invalid, and queries
374     ///  about them do throw.
375     /// @return The address of the owner of the NFT
376     function ownerOf(uint256 _tokenId) external view returns (address _owner) {
377         _owner = tokenIdToOwner[_tokenId];
378         require(_owner != address(0));
379     }
380 
381     /// @notice Transfers the ownership of an NFT from one address to another address
382     /// @dev Throws unless `msg.sender` is the current owner, an authorized
383     ///  operator, or the approved address for this NFT. Throws if `_from` is
384     ///  not the current owner. Throws if `_to` is the zero address. Throws if
385     ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
386     ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
387     ///  `onERC721Received` on `_to` and throws if the return value is not
388     ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
389     /// @param _from The current owner of the NFT
390     /// @param _to The new owner
391     /// @param _tokenId The NFT to transfer
392     /// @param data Additional data with no specified format, sent in call to `_to`
393     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes data) external payable {
394         require(_getApproved(_tokenId) == msg.sender);
395         require(_ownerOf(_tokenId) == _from);
396         require(_to != address(0));
397 
398         _clearApprovalAndTransfer(_from, _to, _tokenId);
399 
400         Approval(_from, 0, _tokenId);
401         Transfer(_from, _to, _tokenId);
402 
403         if (isContract(_to)) {
404             bytes4 value = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, data);
405 
406             if (value != bytes4(keccak256("onERC721Received(address,uint256,bytes)"))) {
407                 revert();
408             }
409         }
410     }
411 	
412     /// @notice Transfers the ownership of an NFT from one address to another address
413     /// @dev This works identically to the other function with an extra data parameter,
414     ///  except this function just sets data to ""
415     /// @param _from The current owner of the NFT
416     /// @param _to The new owner
417     /// @param _tokenId The NFT to transfer
418     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
419         require(_getApproved(_tokenId) == msg.sender);
420         require(_ownerOf(_tokenId) == _from);
421         require(_to != address(0));
422 
423         _clearApprovalAndTransfer(_from, _to, _tokenId);
424 
425         Approval(_from, 0, _tokenId);
426         Transfer(_from, _to, _tokenId);
427 
428         if (isContract(_to)) {
429             bytes4 value = ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, "");
430 
431             if (value != bytes4(keccak256("onERC721Received(address,uint256,bytes)"))) {
432                 revert();
433             }
434         }
435     }
436 
437     /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
438     ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
439     ///  THEY MAY BE PERMANENTLY LOST
440     /// @dev Throws unless `msg.sender` is the current owner, an authorized
441     ///  operator, or the approved address for this NFT. Throws if `_from` is
442     ///  not the current owner. Throws if `_to` is the zero address. Throws if
443     ///  `_tokenId` is not a valid NFT.
444     /// @param _from The current owner of the NFT
445     /// @param _to The new owner
446     /// @param _tokenId The NFT to transfer
447     function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
448         require(_getApproved(_tokenId) == msg.sender);
449         require(_ownerOf(_tokenId) == _from);
450         require(_to != address(0));
451 
452         _clearApprovalAndTransfer(_from, _to, _tokenId);
453 
454         Approval(_from, 0, _tokenId);
455         Transfer(_from, _to, _tokenId);
456     }
457 
458     /// @notice Set or reaffirm the approved address for an NFT
459     /// @dev The zero address indicates there is no approved address.
460     /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
461     ///  operator of the current owner.
462     /// @param _approved The new approved NFT controller
463     /// @param _tokenId The NFT to approve
464     function approve(address _approved, uint256 _tokenId) external payable {
465         require(msg.sender == _ownerOf(_tokenId));
466         require(msg.sender != _approved);
467         
468         if (_getApproved(_tokenId) != address(0) || _approved != address(0)) {
469             _approve(_approved, _tokenId);
470             Approval(msg.sender, _approved, _tokenId);
471         }
472     }
473 
474     /// @notice Enable or disable approval for a third party ("operator") to manage
475     ///  all your assets.
476     /// @dev Throws unless `msg.sender` is the current NFT owner.
477     /// @dev Emits the ApprovalForAll event
478     /// @param _operator Address to add to the set of authorized operators.
479     /// @param _approved True if the operators is approved, false to revoke approval
480     function setApprovalForAll(address _operator, bool _approved) external {
481         revert();
482     }
483 
484     /// @notice Get the approved address for a single NFT
485     /// @dev Throws if `_tokenId` is not a valid NFT
486     /// @param _tokenId The NFT to find the approved address for
487     /// @return The approved address for this NFT, or the zero address if there is none
488     function getApproved(uint256 _tokenId) external view returns (address) {
489         return _getApproved(_tokenId);
490     }
491 
492     /// @notice Query if an address is an authorized operator for another address
493     /// @param _owner The address that owns the NFTs
494     /// @param _operator The address that acts on behalf of the owner
495     /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
496     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
497         return _owner == _operator;
498     }
499 
500     /// @notice A descriptive name for a collection of NFTs in this contract
501     function name() external pure returns (string _name) {
502         return "Dark Winds First Edition Cards";
503     }
504 
505     /// @notice An abbreviated name for NFTs in this contract
506     function symbol() external pure returns (string _symbol) {
507         return "DW1ST";
508     }
509 
510     /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
511     /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
512     ///  3986. The URI may point to a JSON file that conforms to the "ERC721
513     ///  Metadata JSON Schema".
514     function tokenURI(uint256 _tokenId) external view returns (string _tokenURI) {
515         _tokenURI = "https://corsarium.playdarkwinds.com/cards/00000.json"; //37 36 35 34 33
516         bytes memory tokenUriBytes = bytes(_tokenURI);
517         tokenUriBytes[33] = byte(48 + (tokenToCardIndex[_tokenId] / 10000) % 10);
518         tokenUriBytes[34] = byte(48 + (tokenToCardIndex[_tokenId] / 1000) % 10);
519         tokenUriBytes[35] = byte(48 + (tokenToCardIndex[_tokenId] / 100) % 10);
520         tokenUriBytes[36] = byte(48 + (tokenToCardIndex[_tokenId] / 10) % 10);
521         tokenUriBytes[37] = byte(48 + (tokenToCardIndex[_tokenId] / 1) % 10);
522     }
523 
524     function totalSupply() public view returns (uint256 _total) {
525         _total = lastPrintedCard;
526     }
527 
528     function isContract(address _addr) internal view returns (bool) {
529         uint256 size;
530         assembly { 
531             size := extcodesize(_addr)
532         }
533         return size > 0;
534     }
535 }
536 
537 contract CorsariumCore is CardOwnership {
538 
539     uint256 nonce = 1;
540     uint256 public cardCost = 1 finney;
541 
542     function CorsariumCore(address[] _payees, uint256[] _shares) SplitPayment(_payees, _shares) public {
543 
544     }
545 
546     // payable fallback
547     function () public payable {}
548 
549     function changeCardCost(uint256 _newCost) onlyTeam public {
550         cardCost = _newCost;
551     }
552 
553     function getCard(uint _token_id) public view returns (uint256) {
554         assert(_token_id <= lastPrintedCard);
555         return tokenToCardIndex[_token_id];
556     }
557 
558     function buyBoosterPack() public payable {
559         uint amount = msg.value/cardCost;
560         uint blockNumber = block.timestamp;
561         for (uint i = 0; i < amount; i++) {
562             _createCard(i%5 == 1 ? (uint256(keccak256(i+nonce+blockNumber)) % 50) : (uint256(keccak256(i+nonce+blockNumber)) % 50) + (nonce%50), msg.sender);
563         }
564         nonce += amount;
565 
566     }
567     
568     function cardsOfOwner(address _owner) external view returns (uint256[] ownerCards) {
569         uint256 tokenCount = ownerTokenCount[_owner];
570 
571         if (tokenCount == 0) {
572             // Return an empty array
573             return new uint256[](0);
574         } else {
575             uint256[] memory result = new uint256[](tokenCount);
576             uint256 resultIndex = 0;
577 
578             // We count on the fact that all cards have IDs starting at 1 and increasing
579             // sequentially up to the totalCards count.
580             uint256 cardId;
581 
582             for (cardId = 1; cardId <= lastPrintedCard; cardId++) {
583                 if (tokenIdToOwner[cardId] == _owner) {
584                     result[resultIndex] = cardId;
585                     resultIndex++;
586                 }
587             }
588 
589             return result;
590         }
591     }
592 
593     function tokensOfOwner(address _owner) external view returns (uint256[] ownerCards) {
594         uint256 tokenCount = ownerTokenCount[_owner];
595 
596         if (tokenCount == 0) {
597             // Return an empty array
598             return new uint256[](0);
599         } else {
600             uint256[] memory result = new uint256[](tokenCount);
601             uint256 resultIndex = 0;
602 
603             // We count on the fact that all cards have IDs starting at 1 and increasing
604             // sequentially up to the totalCards count.
605             uint256 cardId;
606 
607             for (cardId = 1; cardId <= lastPrintedCard; cardId++) {
608                 if (tokenIdToOwner[cardId] == _owner) {
609                     result[resultIndex] = cardId;
610                     resultIndex++;
611                 }
612             }
613 
614             return result;
615         }
616     }
617 
618     function cardSupply() external view returns (uint256[] printedCards) {
619 
620         if (totalSupply() == 0) {
621             // Return an empty array
622             return new uint256[](0);
623         } else {
624             uint256[] memory result = new uint256[](100);
625             //uint256 totalCards = 1000000;
626             //uint256 resultIndex = 0;
627 
628             // We count on the fact that all cards have IDs starting at 1 and increasing
629             // sequentially up to 1000000
630             uint256 cardId;
631 
632             for (cardId = 1; cardId < 1000000; cardId++) {
633                 result[tokenToCardIndex[cardId]]++;
634                 //resultIndex++;
635             }
636 
637             return result;
638         }
639     }
640     
641 }
642 
643 interface ERC721TokenReceiver {
644     /// @notice Handle the receipt of an NFT
645     /// @dev The ERC721 smart contract calls this function on the recipient
646     ///  after a `transfer`. This function MAY throw to revert and reject the
647     ///  transfer. This function MUST use 50,000 gas or less. Return of other
648     ///  than the magic value MUST result in the transaction being reverted.
649     ///  Note: the contract address is always the message sender.
650     /// @param _from The sending address 
651     /// @param _tokenId The NFT identifier which is being transfered
652     /// @param data Additional data with no specified format
653     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
654     ///  unless throwing
655 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
656 }
657 
658 interface ERC165 {
659     /// @notice Query if a contract implements an interface
660     /// @param interfaceID The interface identifier, as specified in ERC-165
661     /// @dev Interface identification is specified in ERC-165. This function
662     ///  uses less than 30,000 gas.
663     /// @return `true` if the contract implements `interfaceID` and
664     ///  `interfaceID` is not 0xffffffff, `false` otherwise
665     function supportsInterface(bytes4 interfaceID) external view returns (bool);
666 }