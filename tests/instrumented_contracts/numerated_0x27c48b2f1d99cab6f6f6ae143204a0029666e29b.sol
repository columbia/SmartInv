1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11   event OwnershipRenounced(address indexed previousOwner);
12   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14   /**
15    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
16    * account.
17    */
18   constructor() public {
19     owner = msg.sender;
20   }
21 
22   /**
23    * @dev Throws if called by any account other than the owner.
24    */
25   modifier onlyOwner() {
26     require(msg.sender == owner);
27     _;
28   }
29 
30   /**
31    * @dev Allows the current owner to transfer control of the contract to a newOwner.
32    * @param newOwner The address to transfer ownership to.
33    */
34   function transferOwnership(address newOwner) public onlyOwner {
35     require(newOwner != address(0));
36     emit OwnershipTransferred(owner, newOwner);
37     owner = newOwner;
38   }
39 
40   /**
41    * @dev Allows the current owner to relinquish control of the contract.
42    */
43   function renounceOwnership() public onlyOwner {
44     emit OwnershipRenounced(owner);
45     owner = address(0);
46   }
47 }
48 
49 contract ClockAuctionBase {
50   function createAuction(
51     uint256 _tokenId,
52     uint256 _startingPrice,
53     uint256 _endingPrice,
54     uint256 _duration,
55     address _seller
56   ) external;
57 
58   function isSaleAuction() public returns (bool);
59 }
60 
61 /**
62  * @title ERC721 token receiver interface
63  * @dev Interface for any contract that wants to support safeTransfers
64  * from ERC721 asset contracts.
65  */
66 contract ERC721Receiver {
67   /**
68    * @dev Magic value to be returned upon successful reception of an NFT
69    *  Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`,
70    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
71    */
72   bytes4 internal constant ERC721_RECEIVED = 0x150b7a02;
73 
74   /**
75    * @notice Handle the receipt of an NFT
76    * @dev The ERC721 smart contract calls this function on the recipient
77    * after a `safetransfer`. This function MAY throw to revert and reject the
78    * transfer. Return of other than the magic value MUST result in the
79    * transaction being reverted.
80    * Note: the contract address is always the message sender.
81    * @param _operator The address which called `safeTransferFrom` function
82    * @param _from The address which previously owned the token
83    * @param _tokenId The NFT identifier which is being transferred
84    * @param _data Additional data with no specified format
85    * @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
86    */
87   function onERC721Received(
88     address _operator,
89     address _from,
90     uint256 _tokenId,
91     bytes _data
92   )
93     public
94     returns(bytes4);
95 }
96 
97 /**
98  * Utility library of inline functions on addresses
99  */
100 library AddressUtils {
101   /**
102    * Returns whether the target address is a contract
103    * @dev This function will return false if invoked during the constructor of a contract,
104    * as the code is not actually created until after the constructor finishes.
105    * @param _account address of the account to check
106    * @return whether the target address is a contract
107    */
108   function isContract(address _account) internal view returns (bool) {
109     uint256 size;
110     // XXX Currently there is no better way to check if there is a contract in an address
111     // than to check the size of the code at that address.
112     // See https://ethereum.stackexchange.com/a/14016/36603
113     // for more details about how this works.
114     // TODO Check this again before the Serenity release, because all addresses will be
115     // contracts then.
116     // solium-disable-next-line security/no-inline-assembly
117     assembly { size := extcodesize(_account) }
118     return size > 0;
119   }
120 }
121 
122 contract CardBase is Ownable {
123   bytes4 constant InterfaceSignature_ERC165 = 0x01ffc9a7;
124   bytes4 constant InterfaceSignature_ERC721 = 0x80ac58cd;
125   bytes4 internal constant InterfaceId_ERC721Exists = 0x4f558e79;
126 
127   /// @notice Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
128   ///  Returns true for any standardized interfaces implemented by this contract. We implement
129   ///  ERC-165 (obviously!) and ERC-721.
130   function supportsInterface(bytes4 _interfaceID) external view returns (bool)
131   {
132     return (
133       (_interfaceID == InterfaceSignature_ERC165) ||
134       (_interfaceID == InterfaceSignature_ERC721) ||
135       (_interfaceID == InterfaceId_ERC721Exists)
136     );
137   }
138 }
139 
140 contract CardMint is CardBase {
141 
142   using AddressUtils for address;
143 
144   /* EVENTS */
145   event TemplateMint(uint256 _templateId);
146   // Transfer from address 0x0 = newly minted card.
147   event Transfer(
148     address indexed _from,
149     address indexed _to,
150     uint256 indexed _tokenId
151   );
152   event Approval(
153     address indexed _owner,
154     address indexed _approved,
155     uint256 indexed _tokenId
156   );
157   event ApprovalForAll(
158     address indexed _owner,
159     address indexed _operator,
160     bool _approved
161   );
162 
163   /* DATA TYPES */
164   struct Template {
165     uint256 generation;
166     uint256 category;
167     uint256 variation;
168     string name;
169   }
170 
171   /* STORAGE */
172   // Minter address can mint cards but not templates.
173   address public minter;
174 
175   Template[] internal templates;
176   // Each Card is a template ID (index of a template in `templates`).
177   uint256[] internal cards;
178 
179   // Template ID => max number of cards that can be minted with this template ID.
180   mapping (uint256 => uint256) internal templateIdToMintLimit;
181   // Template ID => number of cards that have been minted with this template ID.
182   mapping (uint256 => uint256) internal templateIdToMintCount;
183   // Card ID => owner of card.
184   mapping (uint256 => address) internal cardIdToOwner;
185   // Owner => number of cards owner owns.
186   mapping (address => uint256) internal ownerToCardCount;
187   // Card ID => address approved to transfer on behalf of owner.
188   mapping (uint256 => address) internal cardIdToApproved;
189   // Operator => from address to operated or not.
190   mapping (address => mapping (address => bool)) internal operatorToApprovals;
191 
192   /* MODIFIERS */
193   modifier onlyMinter() {
194     require(msg.sender == minter);
195     _;
196   }
197 
198   /* FUNCTIONS */
199   /** PRIVATE FUNCTIONS **/
200   function _addTokenTo(address _to, uint256 _tokenId) internal {
201     require(cardIdToOwner[_tokenId] == address(0));
202     ownerToCardCount[_to] = ownerToCardCount[_to] + 1;
203     cardIdToOwner[_tokenId] = _to;
204   }
205 
206   /** PUBLIC FUNCTIONS **/
207   function setMinter(address _minter) external onlyOwner {
208     minter = _minter;
209   }
210 
211   function mintTemplate(
212     uint256 _mintLimit,
213     uint256 _generation,
214     uint256 _category,
215     uint256 _variation,
216     string _name
217   ) external onlyOwner {
218     require(_mintLimit > 0);
219 
220     uint256 newTemplateId = templates.push(Template({
221       generation: _generation,
222       category: _category,
223       variation: _variation,
224       name: _name
225     })) - 1;
226     templateIdToMintLimit[newTemplateId] = _mintLimit;
227 
228     emit TemplateMint(newTemplateId);
229   }
230 
231   function mintCard(
232     uint256 _templateId,
233     address _owner
234   ) external onlyMinter {
235     require(templateIdToMintCount[_templateId] < templateIdToMintLimit[_templateId]);
236     templateIdToMintCount[_templateId] = templateIdToMintCount[_templateId] + 1;
237 
238     uint256 newCardId = cards.push(_templateId) - 1;
239     _addTokenTo(_owner, newCardId);
240 
241     emit Transfer(0, _owner, newCardId);
242   }
243 
244   function mintCards(
245     uint256[] _templateIds,
246     address _owner
247   ) external onlyMinter {
248     uint256 mintCount = _templateIds.length;
249     uint256 templateId;
250 
251     for (uint256 i = 0; i < mintCount; ++i) {
252       templateId = _templateIds[i];
253 
254       require(templateIdToMintCount[templateId] < templateIdToMintLimit[templateId]);
255       templateIdToMintCount[templateId] = templateIdToMintCount[templateId] + 1;
256 
257       uint256 newCardId = cards.push(templateId) - 1;
258       cardIdToOwner[newCardId] = _owner;
259 
260       emit Transfer(0, _owner, newCardId);
261     }
262 
263     // Bulk add to ownerToCardCount.
264     ownerToCardCount[_owner] = ownerToCardCount[_owner] + mintCount;
265   }
266 }
267 
268 contract CardOwnership is CardMint {
269 
270   /* FUNCTIONS */
271   /** PRIVATE FUNCTIONS **/
272   function _approve(address _owner, address _approved, uint256 _tokenId) internal {
273     cardIdToApproved[_tokenId] = _approved;
274     emit Approval(_owner, _approved, _tokenId);
275   }
276 
277   function _clearApproval(address _owner, uint256 _tokenId) internal {
278     require(ownerOf(_tokenId) == _owner);
279     if (cardIdToApproved[_tokenId] != address(0)) {
280       cardIdToApproved[_tokenId] = address(0);
281     }
282   }
283 
284   function _removeTokenFrom(address _from, uint256 _tokenId) internal {
285     require(ownerOf(_tokenId) == _from);
286     ownerToCardCount[_from] = ownerToCardCount[_from] - 1;
287     cardIdToOwner[_tokenId] = address(0);
288   }
289 
290   /** PUBLIC FUNCTIONS **/
291   function approve(address _to, uint256 _tokenId) external {
292     address owner = ownerOf(_tokenId);
293     require(_to != owner);
294     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
295 
296     _approve(owner, _to, _tokenId);
297   }
298 
299   function transferFrom(address _from, address _to, uint256 _tokenId) public {
300     require(isApprovedOrOwner(msg.sender, _tokenId));
301     require(_from != address(0));
302     require(_to != address(0));
303     require(_to != address(this));
304 
305     _clearApproval(_from, _tokenId);
306     _removeTokenFrom(_from, _tokenId);
307     _addTokenTo(_to, _tokenId);
308 
309     emit Transfer(_from, _to, _tokenId);
310   }
311 
312   /**
313    * @dev Safely transfers the ownership of a given token ID to another address
314    * If the target address is a contract, it must implement `onERC721Received`,
315    * which is called upon a safe transfer, and return the magic value
316    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
317    * the transfer is reverted.
318    *
319    * Requires the msg sender to be the owner, approved, or operator
320    * @param _from current owner of the token
321    * @param _to address to receive the ownership of the given token ID
322    * @param _tokenId uint256 ID of the token to be transferred
323   */
324   function safeTransferFrom(
325     address _from,
326     address _to,
327     uint256 _tokenId
328   ) public {
329     safeTransferFrom(_from, _to, _tokenId, "");
330   }
331 
332   /**
333    * @dev Safely transfers the ownership of a given token ID to another address
334    * If the target address is a contract, it must implement `onERC721Received`,
335    * which is called upon a safe transfer, and return the magic value
336    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
337    * the transfer is reverted.
338    * Requires the msg sender to be the owner, approved, or operator
339    * @param _from current owner of the token
340    * @param _to address to receive the ownership of the given token ID
341    * @param _tokenId uint256 ID of the token to be transferred
342    * @param _data bytes data to send along with a safe transfer check
343    */
344   function safeTransferFrom(
345     address _from,
346     address _to,
347     uint256 _tokenId,
348     bytes _data
349   ) public {
350     transferFrom(_from, _to, _tokenId);
351     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
352   }
353 
354   function checkAndCallSafeTransfer(
355     address _from,
356     address _to,
357     uint256 _tokenId,
358     bytes _data
359   ) internal returns (bool) {
360     if (!_to.isContract()) {
361       return true;
362     }
363     bytes4 retval = ERC721Receiver(_to).onERC721Received(
364       msg.sender, _from, _tokenId, _data);
365     return (retval == 0x150b7a02);
366   }
367 
368   /**
369    * @dev Returns whether the given spender can transfer a given token ID
370    * @param _spender address of the spender to query
371    * @param _tokenId uint256 ID of the token to be transferred
372    * @return bool whether the msg.sender is approved for the given token ID,
373    *  is an operator of the owner, or is the owner of the token
374    */
375   function isApprovedOrOwner(
376     address _spender,
377     uint256 _tokenId
378   ) internal view returns (bool) {
379     address owner = ownerOf(_tokenId);
380     return (
381       _spender == owner ||
382       getApproved(_tokenId) == _spender ||
383       isApprovedForAll(owner, _spender)
384     );
385   }
386 
387   /**
388    * @dev Sets or unsets the approval of a given operator
389    * An operator is allowed to transfer all tokens of the sender on their behalf
390    * @param _operator operator address to set the approval
391    * @param _approved representing the status of the approval to be set
392    */
393   function setApprovalForAll(address _operator, bool _approved) public {
394     require(_operator != msg.sender);
395     require(_operator != address(0));
396     operatorToApprovals[msg.sender][_operator] = _approved;
397     emit ApprovalForAll(msg.sender, _operator, _approved);
398   }
399 
400   /**
401    * @dev Gets the approved address for a token ID, or zero if no address set
402    * @param _tokenId uint256 ID of the token to query the approval of
403    * @return address currently approved for the given token ID
404    */
405   function getApproved(uint256 _tokenId) public view returns (address) {
406     return cardIdToApproved[_tokenId];
407   }
408 
409   /**
410    * @dev Tells whether an operator is approved by a given owner
411    * @param _owner owner address which you want to query the approval of
412    * @param _operator operator address which you want to query the approval of
413    * @return bool whether the given operator is approved by the given owner
414    */
415   function isApprovedForAll(
416     address _owner,
417     address _operator
418   ) public view returns (bool) {
419     return operatorToApprovals[_owner][_operator];
420   }
421 
422   function ownerOf(uint256 _tokenId) public view returns (address) {
423     address owner = cardIdToOwner[_tokenId];
424     require(owner != address(0));
425     return owner;
426   }
427 
428   function exists(uint256 _tokenId) public view returns (bool) {
429     address owner = cardIdToOwner[_tokenId];
430     return owner != address(0);
431   }
432 }
433 
434 contract CardAuction is CardOwnership {
435 
436   ClockAuctionBase public saleAuction;
437 
438   function setSaleAuction(address _address) external onlyOwner {
439     ClockAuctionBase candidateContract = ClockAuctionBase(_address);
440     require(candidateContract.isSaleAuction());
441     saleAuction = candidateContract;
442   }
443 
444   function createSaleAuction(
445     uint256 _tokenId,
446     uint256 _startingPrice,
447     uint256 _endingPrice,
448     uint256 _duration
449   ) external {
450     require(saleAuction != address(0));
451     require(msg.sender == cardIdToOwner[_tokenId]);
452 
453     _approve(msg.sender, saleAuction, _tokenId);
454     saleAuction.createAuction(
455         _tokenId,
456         _startingPrice,
457         _endingPrice,
458         _duration,
459         msg.sender
460     );
461   }
462 }
463 
464 contract CardTreasury is CardAuction {
465 
466   /* FUNCTIONS */
467   /** PUBLIC FUNCTIONS **/
468   function getTemplate(uint256 _templateId)
469     external
470     view
471     returns (
472       uint256 generation,
473       uint256 category,
474       uint256 variation,
475       string name
476     )
477   {
478     require(_templateId < templates.length);
479 
480     Template storage template = templates[_templateId];
481 
482     generation = template.generation;
483     category = template.category;
484     variation = template.variation;
485     name = template.name;
486   }
487 
488   function getCard(uint256 _cardId)
489     external
490     view
491     returns (
492       uint256 generation,
493       uint256 category,
494       uint256 variation,
495       string name
496     )
497   {
498     require(_cardId < cards.length);
499 
500     uint256 templateId = cards[_cardId];
501     Template storage template = templates[templateId];
502 
503     generation = template.generation;
504     category = template.category;
505     variation = template.variation;
506     name = template.name;
507   }
508 
509   function templateIdOf(uint256 _cardId) external view returns (uint256) {
510     require(_cardId < cards.length);
511     return cards[_cardId];
512   }
513 
514   function balanceOf(address _owner) public view returns (uint256) {
515     require(_owner != address(0));
516     return ownerToCardCount[_owner];
517   }
518 
519   function templateSupply() external view returns (uint256) {
520     return templates.length;
521   }
522 
523   function totalSupply() external view returns (uint256) {
524     return cards.length;
525   }
526 
527   function mintLimitByTemplate(uint256 _templateId) external view returns(uint256) {
528     require(_templateId < templates.length);
529     return templateIdToMintLimit[_templateId];
530   }
531 
532   function mintCountByTemplate(uint256 _templateId) external view returns(uint256) {
533     require(_templateId < templates.length);
534     return templateIdToMintCount[_templateId];
535   }
536 
537   function name() external pure returns (string) {
538     return "Battlebound";
539   }
540 
541   function symbol() external pure returns (string) {
542     return "BB";
543   }
544 
545   function tokensOfOwner(address _owner) external view returns (uint256[]) {
546     uint256 tokenCount = balanceOf(_owner);
547 
548     if (tokenCount == 0) {
549       return new uint256[](0);
550     } else {
551       uint256[] memory result = new uint256[](tokenCount);
552       uint256 resultIndex = 0;
553 
554       for (uint256 cardId = 0; cardId < cards.length; ++cardId) {
555         if (cardIdToOwner[cardId] == _owner) {
556           result[resultIndex] = cardId;
557           ++resultIndex;
558         }
559       }
560 
561       return result;
562     }
563   }
564 
565   function templatesOfOwner(address _owner) external view returns (uint256[]) {
566     uint256 tokenCount = balanceOf(_owner);
567 
568     if (tokenCount == 0) {
569       return new uint256[](0);
570     } else {
571       uint256[] memory result = new uint256[](tokenCount);
572       uint256 resultIndex = 0;
573 
574       for (uint256 cardId = 0; cardId < cards.length; ++cardId) {
575         if (cardIdToOwner[cardId] == _owner) {
576           uint256 templateId = cards[cardId];
577           result[resultIndex] = templateId;
578           ++resultIndex;
579         }
580       }
581 
582       return result;
583     }
584   }
585 
586   function variationsOfOwner(address _owner) external view returns (uint256[]) {
587     uint256 tokenCount = balanceOf(_owner);
588 
589     if (tokenCount == 0) {
590       return new uint256[](0);
591     } else {
592       uint256[] memory result = new uint256[](tokenCount);
593       uint256 resultIndex = 0;
594 
595       for (uint256 cardId = 0; cardId < cards.length; ++cardId) {
596         if (cardIdToOwner[cardId] == _owner) {
597           uint256 templateId = cards[cardId];
598           Template storage template = templates[templateId];
599           result[resultIndex] = template.variation;
600           ++resultIndex;
601         }
602       }
603 
604       return result;
605     }
606   }
607 }