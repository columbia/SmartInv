1 pragma solidity ^0.4.19;
2 
3 // File: contracts/erc/erc165/IERC165.sol
4 
5 /// @title ERC-165 Standard Interface Detection
6 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
7 interface IERC165 {
8   /// @notice Query if a contract implements an interface
9   /// @param interfaceID The interface identifier, as specified in ERC-165
10   /// @dev Interface identification is specified in ERC-165. This function
11   ///  uses less than 30,000 gas.
12   /// @return `true` if the contract implements `interfaceID` and
13   ///  `interfaceID` is not 0xffffffff, `false` otherwise
14   function supportsInterface(bytes4 interfaceID) external view returns (bool);
15 }
16 
17 // File: contracts/erc/erc165/ERC165.sol
18 
19 contract ERC165 is IERC165 {
20   /// @dev You must not set element 0xffffffff to true
21   mapping (bytes4 => bool) internal supportedInterfaces;
22 
23   function ERC165() internal {
24     supportedInterfaces[0x01ffc9a7] = true; // ERC-165
25   }
26 
27   function supportsInterface(bytes4 interfaceID) external view returns (bool) {
28     return supportedInterfaces[interfaceID];
29   }
30 }
31 
32 // File: contracts/erc/erc721/IERC721Base.sol
33 
34 /// @title ERC-721 Non-Fungible Token Standard
35 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
36 ///  Note: the ERC-165 identifier for this interface is 0x6466353c
37 interface IERC721Base /* is IERC165  */ {
38   /// @dev This emits when ownership of any NFT changes by any mechanism.
39   ///  This event emits when NFTs are created (`from` == 0) and destroyed
40   ///  (`to` == 0). Exception: during contract creation, any number of NFTs
41   ///  may be created and assigned without emitting Transfer. At the time of
42   ///  any transfer, the approved address for that NFT (if any) is reset to none.
43   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
44 
45   /// @dev This emits when the approved address for an NFT is changed or
46   ///  reaffirmed. The zero address indicates there is no approved address.
47   ///  When a Transfer event emits, this also indicates that the approved
48   ///  address for that NFT (if any) is reset to none.
49   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
50 
51   /// @dev This emits when an operator is enabled or disabled for an owner.
52   ///  The operator can manage all NFTs of the owner.
53   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
54 
55   /// @notice Count all NFTs assigned to an owner
56   /// @dev NFTs assigned to the zero address are considered invalid, and this
57   ///  function throws for queries about the zero address.
58   /// @param _owner An address for whom to query the balance
59   /// @return The number of NFTs owned by `_owner`, possibly zero
60   function balanceOf(address _owner) external view returns (uint256);
61 
62   /// @notice Find the owner of an NFT
63   /// @param _tokenId The identifier for an NFT
64   /// @dev NFTs assigned to zero address are considered invalid, and queries
65   ///  about them do throw.
66   /// @return The address of the owner of the NFT
67   function ownerOf(uint256 _tokenId) external view returns (address);
68 
69   /// @notice Transfers the ownership of an NFT from one address to another address
70   /// @dev Throws unless `msg.sender` is the current owner, an authorized
71   ///  operator, or the approved address for this NFT. Throws if `_from` is
72   ///  not the current owner. Throws if `_to` is the zero address. Throws if
73   ///  `_tokenId` is not a valid NFT. When transfer is complete, this function
74   ///  checks if `_to` is a smart contract (code size > 0). If so, it calls
75   ///  `onERC721Received` on `_to` and throws if the return value is not
76   ///  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`.
77   /// @param _from The current owner of the NFT
78   /// @param _to The new owner
79   /// @param _tokenId The NFT to transfer
80   /// @param _data Additional data with no specified format, sent in call to `_to`
81   // solium-disable-next-line arg-overflow
82   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external payable;
83 
84   /// @notice Transfers the ownership of an NFT from one address to another address
85   /// @dev This works identically to the other function with an extra data parameter,
86   ///  except this function just sets data to []
87   /// @param _from The current owner of the NFT
88   /// @param _to The new owner
89   /// @param _tokenId The NFT to transfer
90   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
91 
92   /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
93   ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
94   ///  THEY MAY BE PERMANENTLY LOST
95   /// @dev Throws unless `msg.sender` is the current owner, an authorized
96   ///  operator, or the approved address for this NFT. Throws if `_from` is
97   ///  not the current owner. Throws if `_to` is the zero address. Throws if
98   ///  `_tokenId` is not a valid NFT.
99   /// @param _from The current owner of the NFT
100   /// @param _to The new owner
101   /// @param _tokenId The NFT to transfer
102   function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
103 
104   /// @notice Set or reaffirm the approved address for an NFT
105   /// @dev The zero address indicates there is no approved address.
106   /// @dev Throws unless `msg.sender` is the current NFT owner, or an authorized
107   ///  operator of the current owner.
108   /// @param _approved The new approved NFT controller
109   /// @param _tokenId The NFT to approve
110   function approve(address _approved, uint256 _tokenId) external payable;
111 
112   /// @notice Enable or disable approval for a third party ("operator") to manage
113   ///  all your asset.
114   /// @dev Emits the ApprovalForAll event
115   /// @param _operator Address to add to the set of authorized operators.
116   /// @param _approved True if the operators is approved, false to revoke approval
117   function setApprovalForAll(address _operator, bool _approved) external;
118 
119   /// @notice Get the approved address for a single NFT
120   /// @dev Throws if `_tokenId` is not a valid NFT
121   /// @param _tokenId The NFT to find the approved address for
122   /// @return The approved address for this NFT, or the zero address if there is none
123   function getApproved(uint256 _tokenId) external view returns (address);
124 
125   /// @notice Query if an address is an authorized operator for another address
126   /// @param _owner The address that owns the NFTs
127   /// @param _operator The address that acts on behalf of the owner
128   /// @return True if `_operator` is an approved operator for `_owner`, false otherwise
129   function isApprovedForAll(address _owner, address _operator) external view returns (bool);
130 }
131 
132 // File: contracts/erc/erc721/IERC721Enumerable.sol
133 
134 /// @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
135 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
136 ///  Note: the ERC-165 identifier for this interface is 0x780e9d63
137 interface IERC721Enumerable /* is IERC721Base */ {
138   /// @notice Count NFTs tracked by this contract
139   /// @return A count of valid NFTs tracked by this contract, where each one of
140   ///  them has an assigned and queryable owner not equal to the zero address
141   function totalSupply() external view returns (uint256);
142 
143   /// @notice Enumerate valid NFTs
144   /// @dev Throws if `_index` >= `totalSupply()`.
145   /// @param _index A counter less than `totalSupply()`
146   /// @return The token identifier for the `_index`th NFT,
147   ///  (sort order not specified)
148   function tokenByIndex(uint256 _index) external view returns (uint256);
149 
150   /// @notice Enumerate NFTs assigned to an owner
151   /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
152   ///  `_owner` is the zero address, representing invalid NFTs.
153   /// @param _owner An address where we are interested in NFTs owned by them
154   /// @param _index A counter less than `balanceOf(_owner)`
155   /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
156   ///   (sort order not specified)
157   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId);
158 }
159 
160 // File: contracts/erc/erc721/IERC721TokenReceiver.sol
161 
162 /// @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
163 interface IERC721TokenReceiver {
164   /// @notice Handle the receipt of an NFT
165   /// @dev The ERC721 smart contract calls this function on the recipient
166   ///  after a `transfer`. This function MAY throw to revert and reject the
167   ///  transfer. This function MUST use 50,000 gas or less. Return of other
168   ///  than the magic value MUST result in the transaction being reverted.
169   ///  Note: the contract address is always the message sender.
170   /// @param _from The sending address
171   /// @param _tokenId The NFT identifier which is being transfered
172   /// @param _data Additional data with no specified format
173   /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
174   ///  unless throwing
175 	function onERC721Received(address _from, uint256 _tokenId, bytes _data) external returns (bytes4);
176 }
177 
178 // File: contracts/core/dependency/AxieManager.sol
179 
180 interface AxieSpawningManager {
181 	function isSpawningAllowed(uint256 _genes, address _owner) external returns (bool);
182   function isRebirthAllowed(uint256 _axieId, uint256 _genes) external returns (bool);
183 }
184 
185 interface AxieRetirementManager {
186   function isRetirementAllowed(uint256 _axieId, bool _rip) external returns (bool);
187 }
188 
189 interface AxieMarketplaceManager {
190   function isTransferAllowed(address _from, address _to, uint256 _axieId) external returns (bool);
191 }
192 
193 interface AxieGeneManager {
194   function isEvolvementAllowed(uint256 _axieId, uint256 _newGenes) external returns (bool);
195 }
196 
197 // File: contracts/core/dependency/AxieDependency.sol
198 
199 contract AxieDependency {
200 
201   address public whitelistSetterAddress;
202 
203   AxieSpawningManager public spawningManager;
204   AxieRetirementManager public retirementManager;
205   AxieMarketplaceManager public marketplaceManager;
206   AxieGeneManager public geneManager;
207 
208   mapping (address => bool) public whitelistedSpawner;
209   mapping (address => bool) public whitelistedByeSayer;
210   mapping (address => bool) public whitelistedMarketplace;
211   mapping (address => bool) public whitelistedGeneScientist;
212 
213   function AxieDependency() internal {
214     whitelistSetterAddress = msg.sender;
215   }
216 
217   modifier onlyWhitelistSetter() {
218     require(msg.sender == whitelistSetterAddress);
219     _;
220   }
221 
222   modifier whenSpawningAllowed(uint256 _genes, address _owner) {
223     require(
224       spawningManager == address(0) ||
225         spawningManager.isSpawningAllowed(_genes, _owner)
226     );
227     _;
228   }
229 
230   modifier whenRebirthAllowed(uint256 _axieId, uint256 _genes) {
231     require(
232       spawningManager == address(0) ||
233         spawningManager.isRebirthAllowed(_axieId, _genes)
234     );
235     _;
236   }
237 
238   modifier whenRetirementAllowed(uint256 _axieId, bool _rip) {
239     require(
240       retirementManager == address(0) ||
241         retirementManager.isRetirementAllowed(_axieId, _rip)
242     );
243     _;
244   }
245 
246   modifier whenTransferAllowed(address _from, address _to, uint256 _axieId) {
247     require(
248       marketplaceManager == address(0) ||
249         marketplaceManager.isTransferAllowed(_from, _to, _axieId)
250     );
251     _;
252   }
253 
254   modifier whenEvolvementAllowed(uint256 _axieId, uint256 _newGenes) {
255     require(
256       geneManager == address(0) ||
257         geneManager.isEvolvementAllowed(_axieId, _newGenes)
258     );
259     _;
260   }
261 
262   modifier onlySpawner() {
263     require(whitelistedSpawner[msg.sender]);
264     _;
265   }
266 
267   modifier onlyByeSayer() {
268     require(whitelistedByeSayer[msg.sender]);
269     _;
270   }
271 
272   modifier onlyMarketplace() {
273     require(whitelistedMarketplace[msg.sender]);
274     _;
275   }
276 
277   modifier onlyGeneScientist() {
278     require(whitelistedGeneScientist[msg.sender]);
279     _;
280   }
281 
282   /*
283    * @dev Setting the whitelist setter address to `address(0)` would be a irreversible process.
284    *  This is to lock changes to Axie's contracts after their development is done.
285    */
286   function setWhitelistSetter(address _newSetter) external onlyWhitelistSetter {
287     whitelistSetterAddress = _newSetter;
288   }
289 
290   function setSpawningManager(address _manager) external onlyWhitelistSetter {
291     spawningManager = AxieSpawningManager(_manager);
292   }
293 
294   function setRetirementManager(address _manager) external onlyWhitelistSetter {
295     retirementManager = AxieRetirementManager(_manager);
296   }
297 
298   function setMarketplaceManager(address _manager) external onlyWhitelistSetter {
299     marketplaceManager = AxieMarketplaceManager(_manager);
300   }
301 
302   function setGeneManager(address _manager) external onlyWhitelistSetter {
303     geneManager = AxieGeneManager(_manager);
304   }
305 
306   function setSpawner(address _spawner, bool _whitelisted) external onlyWhitelistSetter {
307     require(whitelistedSpawner[_spawner] != _whitelisted);
308     whitelistedSpawner[_spawner] = _whitelisted;
309   }
310 
311   function setByeSayer(address _byeSayer, bool _whitelisted) external onlyWhitelistSetter {
312     require(whitelistedByeSayer[_byeSayer] != _whitelisted);
313     whitelistedByeSayer[_byeSayer] = _whitelisted;
314   }
315 
316   function setMarketplace(address _marketplace, bool _whitelisted) external onlyWhitelistSetter {
317     require(whitelistedMarketplace[_marketplace] != _whitelisted);
318     whitelistedMarketplace[_marketplace] = _whitelisted;
319   }
320 
321   function setGeneScientist(address _geneScientist, bool _whitelisted) external onlyWhitelistSetter {
322     require(whitelistedGeneScientist[_geneScientist] != _whitelisted);
323     whitelistedGeneScientist[_geneScientist] = _whitelisted;
324   }
325 }
326 
327 // File: contracts/core/AxieAccessControl.sol
328 
329 contract AxieAccessControl {
330 
331   address public ceoAddress;
332   address public cfoAddress;
333   address public cooAddress;
334 
335   function AxieAccessControl() internal {
336     ceoAddress = msg.sender;
337   }
338 
339   modifier onlyCEO() {
340     require(msg.sender == ceoAddress);
341     _;
342   }
343 
344   modifier onlyCFO() {
345     require(msg.sender == cfoAddress);
346     _;
347   }
348 
349   modifier onlyCOO() {
350     require(msg.sender == cooAddress);
351     _;
352   }
353 
354   modifier onlyCLevel() {
355     require(
356       // solium-disable operator-whitespace
357       msg.sender == ceoAddress ||
358         msg.sender == cfoAddress ||
359         msg.sender == cooAddress
360       // solium-enable operator-whitespace
361     );
362     _;
363   }
364 
365   function setCEO(address _newCEO) external onlyCEO {
366     require(_newCEO != address(0));
367     ceoAddress = _newCEO;
368   }
369 
370   function setCFO(address _newCFO) external onlyCEO {
371     cfoAddress = _newCFO;
372   }
373 
374   function setCOO(address _newCOO) external onlyCEO {
375     cooAddress = _newCOO;
376   }
377 
378   function withdrawBalance() external onlyCFO {
379     cfoAddress.transfer(this.balance);
380   }
381 }
382 
383 // File: contracts/core/lifecycle/AxiePausable.sol
384 
385 contract AxiePausable is AxieAccessControl {
386 
387   bool public paused = false;
388 
389   modifier whenNotPaused() {
390     require(!paused);
391     _;
392   }
393 
394   modifier whenPaused {
395     require(paused);
396     _;
397   }
398 
399   function pause() external onlyCLevel whenNotPaused {
400     paused = true;
401   }
402 
403   function unpause() public onlyCEO whenPaused {
404     paused = false;
405   }
406 }
407 
408 // File: zeppelin/contracts/math/SafeMath.sol
409 
410 /**
411  * @title SafeMath
412  * @dev Math operations with safety checks that throw on error
413  */
414 library SafeMath {
415   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
416     uint256 c = a * b;
417     assert(a == 0 || c / a == b);
418     return c;
419   }
420 
421   function div(uint256 a, uint256 b) internal constant returns (uint256) {
422     // assert(b > 0); // Solidity automatically throws when dividing by 0
423     uint256 c = a / b;
424     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
425     return c;
426   }
427 
428   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
429     assert(b <= a);
430     return a - b;
431   }
432 
433   function add(uint256 a, uint256 b) internal constant returns (uint256) {
434     uint256 c = a + b;
435     assert(c >= a);
436     return c;
437   }
438 }
439 
440 // File: contracts/core/erc721/AxieERC721BaseEnumerable.sol
441 
442 contract AxieERC721BaseEnumerable is ERC165, IERC721Base, IERC721Enumerable, AxieDependency, AxiePausable {
443   using SafeMath for uint256;
444 
445   // @dev Total amount of tokens.
446   uint256 private _totalTokens;
447 
448   // @dev Mapping from token index to ID.
449   mapping (uint256 => uint256) private _overallTokenId;
450 
451   // @dev Mapping from token ID to index.
452   mapping (uint256 => uint256) private _overallTokenIndex;
453 
454   // @dev Mapping from token ID to owner.
455   mapping (uint256 => address) private _tokenOwner;
456 
457   // @dev For a given owner and a given operator, store whether
458   //  the operator is allowed to manage tokens on behalf of the owner.
459   mapping (address => mapping (address => bool)) private _tokenOperator;
460 
461   // @dev Mapping from token ID to approved address.
462   mapping (uint256 => address) private _tokenApproval;
463 
464   // @dev Mapping from owner to list of owned token IDs.
465   mapping (address => uint256[]) private _ownedTokens;
466 
467   // @dev Mapping from token ID to index in the owned token list.
468   mapping (uint256 => uint256) private _ownedTokenIndex;
469 
470   function AxieERC721BaseEnumerable() internal {
471     supportedInterfaces[0x6466353c] = true; // ERC-721 Base
472     supportedInterfaces[0x780e9d63] = true; // ERC-721 Enumerable
473   }
474 
475   // solium-disable function-order
476 
477   modifier mustBeValidToken(uint256 _tokenId) {
478     require(_tokenOwner[_tokenId] != address(0));
479     _;
480   }
481 
482   function _isTokenOwner(address _ownerToCheck, uint256 _tokenId) private view returns (bool) {
483     return _tokenOwner[_tokenId] == _ownerToCheck;
484   }
485 
486   function _isTokenOperator(address _operatorToCheck, uint256 _tokenId) private view returns (bool) {
487     return whitelistedMarketplace[_operatorToCheck] ||
488       _tokenOperator[_tokenOwner[_tokenId]][_operatorToCheck];
489   }
490 
491   function _isApproved(address _approvedToCheck, uint256 _tokenId) private view returns (bool) {
492     return _tokenApproval[_tokenId] == _approvedToCheck;
493   }
494 
495   modifier onlyTokenOwner(uint256 _tokenId) {
496     require(_isTokenOwner(msg.sender, _tokenId));
497     _;
498   }
499 
500   modifier onlyTokenOwnerOrOperator(uint256 _tokenId) {
501     require(_isTokenOwner(msg.sender, _tokenId) || _isTokenOperator(msg.sender, _tokenId));
502     _;
503   }
504 
505   modifier onlyTokenAuthorized(uint256 _tokenId) {
506     require(
507       // solium-disable operator-whitespace
508       _isTokenOwner(msg.sender, _tokenId) ||
509         _isTokenOperator(msg.sender, _tokenId) ||
510         _isApproved(msg.sender, _tokenId)
511       // solium-enable operator-whitespace
512     );
513     _;
514   }
515 
516   // ERC-721 Base
517 
518   function balanceOf(address _owner) external view returns (uint256) {
519     require(_owner != address(0));
520     return _ownedTokens[_owner].length;
521   }
522 
523   function ownerOf(uint256 _tokenId) external view mustBeValidToken(_tokenId) returns (address) {
524     return _tokenOwner[_tokenId];
525   }
526 
527   function _addTokenTo(address _to, uint256 _tokenId) private {
528     require(_to != address(0));
529 
530     _tokenOwner[_tokenId] = _to;
531 
532     uint256 length = _ownedTokens[_to].length;
533     _ownedTokens[_to].push(_tokenId);
534     _ownedTokenIndex[_tokenId] = length;
535   }
536 
537   function _mint(address _to, uint256 _tokenId) internal {
538     require(_tokenOwner[_tokenId] == address(0));
539 
540     _addTokenTo(_to, _tokenId);
541 
542     _overallTokenId[_totalTokens] = _tokenId;
543     _overallTokenIndex[_tokenId] = _totalTokens;
544     _totalTokens = _totalTokens.add(1);
545 
546     Transfer(address(0), _to, _tokenId);
547   }
548 
549   function _removeTokenFrom(address _from, uint256 _tokenId) private {
550     require(_from != address(0));
551 
552     uint256 _tokenIndex = _ownedTokenIndex[_tokenId];
553     uint256 _lastTokenIndex = _ownedTokens[_from].length.sub(1);
554     uint256 _lastTokenId = _ownedTokens[_from][_lastTokenIndex];
555 
556     _tokenOwner[_tokenId] = address(0);
557 
558     // Insert the last token into the position previously occupied by the removed token.
559     _ownedTokens[_from][_tokenIndex] = _lastTokenId;
560     _ownedTokenIndex[_lastTokenId] = _tokenIndex;
561 
562     // Resize the array.
563     delete _ownedTokens[_from][_lastTokenIndex];
564     _ownedTokens[_from].length--;
565 
566     // Remove the array if no more tokens are owned to prevent pollution.
567     if (_ownedTokens[_from].length == 0) {
568       delete _ownedTokens[_from];
569     }
570 
571     // Update the index of the removed token.
572     delete _ownedTokenIndex[_tokenId];
573   }
574 
575   function _burn(uint256 _tokenId) internal {
576     address _from = _tokenOwner[_tokenId];
577 
578     require(_from != address(0));
579 
580     _removeTokenFrom(_from, _tokenId);
581     _totalTokens = _totalTokens.sub(1);
582 
583     uint256 _tokenIndex = _overallTokenIndex[_tokenId];
584     uint256 _lastTokenId = _overallTokenId[_totalTokens];
585 
586     delete _overallTokenIndex[_tokenId];
587     delete _overallTokenId[_totalTokens];
588     _overallTokenId[_tokenIndex] = _lastTokenId;
589     _overallTokenIndex[_lastTokenId] = _tokenIndex;
590 
591     Transfer(_from, address(0), _tokenId);
592   }
593 
594   function _isContract(address _address) private view returns (bool) {
595     uint _size;
596     // solium-disable-next-line security/no-inline-assembly
597     assembly { _size := extcodesize(_address) }
598     return _size > 0;
599   }
600 
601   function _transferFrom(
602     address _from,
603     address _to,
604     uint256 _tokenId,
605     bytes _data,
606     bool _check
607   )
608     internal
609     mustBeValidToken(_tokenId)
610     onlyTokenAuthorized(_tokenId)
611     whenTransferAllowed(_from, _to, _tokenId)
612   {
613     require(_isTokenOwner(_from, _tokenId));
614     require(_to != address(0));
615     require(_to != _from);
616 
617     _removeTokenFrom(_from, _tokenId);
618 
619     delete _tokenApproval[_tokenId];
620     Approval(_from, address(0), _tokenId);
621 
622     _addTokenTo(_to, _tokenId);
623 
624     if (_check && _isContract(_to)) {
625       IERC721TokenReceiver(_to).onERC721Received.gas(50000)(_from, _tokenId, _data);
626     }
627 
628     Transfer(_from, _to, _tokenId);
629   }
630 
631   // solium-disable arg-overflow
632 
633   function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external payable {
634     _transferFrom(_from, _to, _tokenId, _data, true);
635   }
636 
637   function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable {
638     _transferFrom(_from, _to, _tokenId, "", true);
639   }
640 
641   function transferFrom(address _from, address _to, uint256 _tokenId) external payable {
642     _transferFrom(_from, _to, _tokenId, "", false);
643   }
644 
645   // solium-enable arg-overflow
646 
647   function approve(
648     address _approved,
649     uint256 _tokenId
650   )
651     external
652     payable
653     mustBeValidToken(_tokenId)
654     onlyTokenOwnerOrOperator(_tokenId)
655     whenNotPaused
656   {
657     address _owner = _tokenOwner[_tokenId];
658 
659     require(_owner != _approved);
660     require(_tokenApproval[_tokenId] != _approved);
661 
662     _tokenApproval[_tokenId] = _approved;
663 
664     Approval(_owner, _approved, _tokenId);
665   }
666 
667   function setApprovalForAll(address _operator, bool _approved) external whenNotPaused {
668     require(_tokenOperator[msg.sender][_operator] != _approved);
669     _tokenOperator[msg.sender][_operator] = _approved;
670     ApprovalForAll(msg.sender, _operator, _approved);
671   }
672 
673   function getApproved(uint256 _tokenId) external view mustBeValidToken(_tokenId) returns (address) {
674     return _tokenApproval[_tokenId];
675   }
676 
677   function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
678     return _tokenOperator[_owner][_operator];
679   }
680 
681   // ERC-721 Enumerable
682 
683   function totalSupply() external view returns (uint256) {
684     return _totalTokens;
685   }
686 
687   function tokenByIndex(uint256 _index) external view returns (uint256) {
688     require(_index < _totalTokens);
689     return _overallTokenId[_index];
690   }
691 
692   function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 _tokenId) {
693     require(_owner != address(0));
694     require(_index < _ownedTokens[_owner].length);
695     return _ownedTokens[_owner][_index];
696   }
697 }
698 
699 // File: contracts/erc/erc721/IERC721Metadata.sol
700 
701 /// @title ERC-721 Non-Fungible Token Standard, optional metadata extension
702 /// @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
703 ///  Note: the ERC-165 identifier for this interface is 0x5b5e139f
704 interface IERC721Metadata /* is IERC721Base */ {
705   /// @notice A descriptive name for a collection of NFTs in this contract
706   function name() external pure returns (string _name);
707 
708   /// @notice An abbreviated name for NFTs in this contract
709   function symbol() external pure returns (string _symbol);
710 
711   /// @notice A distinct Uniform Resource Identifier (URI) for a given asset.
712   /// @dev Throws if `_tokenId` is not a valid NFT. URIs are defined in RFC
713   ///  3986. The URI may point to a JSON file that conforms to the "ERC721
714   ///  Metadata JSON Schema".
715   function tokenURI(uint256 _tokenId) external view returns (string);
716 }
717 
718 // File: contracts/core/erc721/AxieERC721Metadata.sol
719 
720 contract AxieERC721Metadata is AxieERC721BaseEnumerable, IERC721Metadata {
721   string public tokenURIPrefix = "https://axieinfinity.com/erc/721/axies/";
722   string public tokenURISuffix = ".json";
723 
724   function AxieERC721Metadata() internal {
725     supportedInterfaces[0x5b5e139f] = true; // ERC-721 Metadata
726   }
727 
728   function name() external pure returns (string) {
729     return "Axie";
730   }
731 
732   function symbol() external pure returns (string) {
733     return "AXIE";
734   }
735 
736   function setTokenURIAffixes(string _prefix, string _suffix) external onlyCEO {
737     tokenURIPrefix = _prefix;
738     tokenURISuffix = _suffix;
739   }
740 
741   function tokenURI(
742     uint256 _tokenId
743   )
744     external
745     view
746     mustBeValidToken(_tokenId)
747     returns (string)
748   {
749     bytes memory _tokenURIPrefixBytes = bytes(tokenURIPrefix);
750     bytes memory _tokenURISuffixBytes = bytes(tokenURISuffix);
751     uint256 _tmpTokenId = _tokenId;
752     uint256 _length;
753 
754     do {
755       _length++;
756       _tmpTokenId /= 10;
757     } while (_tmpTokenId > 0);
758 
759     bytes memory _tokenURIBytes = new bytes(_tokenURIPrefixBytes.length + _length + 5);
760     uint256 _i = _tokenURIBytes.length - 6;
761 
762     _tmpTokenId = _tokenId;
763 
764     do {
765       _tokenURIBytes[_i--] = byte(48 + _tmpTokenId % 10);
766       _tmpTokenId /= 10;
767     } while (_tmpTokenId > 0);
768 
769     for (_i = 0; _i < _tokenURIPrefixBytes.length; _i++) {
770       _tokenURIBytes[_i] = _tokenURIPrefixBytes[_i];
771     }
772 
773     for (_i = 0; _i < _tokenURISuffixBytes.length; _i++) {
774       _tokenURIBytes[_tokenURIBytes.length + _i - 5] = _tokenURISuffixBytes[_i];
775     }
776 
777     return string(_tokenURIBytes);
778   }
779 }
780 
781 // File: contracts/core/erc721/AxieERC721.sol
782 
783 // solium-disable-next-line no-empty-blocks
784 contract AxieERC721 is AxieERC721BaseEnumerable, AxieERC721Metadata {
785 }
786 
787 // File: contracts/core/AxieCore.sol
788 
789 // solium-disable-next-line no-empty-blocks
790 contract AxieCore is AxieERC721 {
791   struct Axie {
792     uint256 genes;
793     uint256 bornAt;
794   }
795 
796   Axie[] axies;
797 
798   event AxieSpawned(uint256 indexed _axieId, address indexed _owner, uint256 _genes);
799   event AxieRebirthed(uint256 indexed _axieId, uint256 _genes);
800   event AxieRetired(uint256 indexed _axieId);
801   event AxieEvolved(uint256 indexed _axieId, uint256 _oldGenes, uint256 _newGenes);
802 
803   function AxieCore() public {
804     axies.push(Axie(0, now)); // The void Axie
805     _spawnAxie(0, msg.sender); // Will be Puff
806     _spawnAxie(0, msg.sender); // Will be Kotaro
807     _spawnAxie(0, msg.sender); // Will be Ginger
808     _spawnAxie(0, msg.sender); // Will be Stella
809   }
810 
811   function getAxie(
812     uint256 _axieId
813   )
814     external
815     view
816     mustBeValidToken(_axieId)
817     returns (uint256 /* _genes */, uint256 /* _bornAt */)
818   {
819     Axie storage _axie = axies[_axieId];
820     return (_axie.genes, _axie.bornAt);
821   }
822 
823   function spawnAxie(
824     uint256 _genes,
825     address _owner
826   )
827     external
828     onlySpawner
829     whenSpawningAllowed(_genes, _owner)
830     returns (uint256)
831   {
832     return _spawnAxie(_genes, _owner);
833   }
834 
835   function rebirthAxie(
836     uint256 _axieId,
837     uint256 _genes
838   )
839     external
840     onlySpawner
841     mustBeValidToken(_axieId)
842     whenRebirthAllowed(_axieId, _genes)
843   {
844     Axie storage _axie = axies[_axieId];
845     _axie.genes = _genes;
846     _axie.bornAt = now;
847     AxieRebirthed(_axieId, _genes);
848   }
849 
850   function retireAxie(
851     uint256 _axieId,
852     bool _rip
853   )
854     external
855     onlyByeSayer
856     whenRetirementAllowed(_axieId, _rip)
857   {
858     _burn(_axieId);
859 
860     if (_rip) {
861       delete axies[_axieId];
862     }
863 
864     AxieRetired(_axieId);
865   }
866 
867   function evolveAxie(
868     uint256 _axieId,
869     uint256 _newGenes
870   )
871     external
872     onlyGeneScientist
873     mustBeValidToken(_axieId)
874     whenEvolvementAllowed(_axieId, _newGenes)
875   {
876     uint256 _oldGenes = axies[_axieId].genes;
877     axies[_axieId].genes = _newGenes;
878     AxieEvolved(_axieId, _oldGenes, _newGenes);
879   }
880 
881   function _spawnAxie(uint256 _genes, address _owner) private returns (uint256 _axieId) {
882     Axie memory _axie = Axie(_genes, now);
883     _axieId = axies.push(_axie) - 1;
884     _mint(_owner, _axieId);
885     AxieSpawned(_axieId, _owner, _genes);
886   }
887 }