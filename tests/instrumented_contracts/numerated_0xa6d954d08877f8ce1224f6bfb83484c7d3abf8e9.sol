1 /**
2  * @title SafeMath
3  * @dev Math operations with safety checks that throw on error
4  */
5 library SafeMath {
6 
7   /**
8   * @dev Multiplies two numbers, throws on overflow.
9   */
10   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
11     if (a == 0) {
12       return 0;
13     }
14     uint256 c = a * b;
15     assert(c / a == b);
16     return c;
17   }
18 
19   /**
20   * @dev Integer division of two numbers, truncating the quotient.
21   */
22   function div(uint256 a, uint256 b) internal pure returns (uint256) {
23     // assert(b > 0); // Solidity automatically throws when dividing by 0
24     uint256 c = a / b;
25     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
26     return c;
27   }
28 
29   /**
30   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
31   */
32   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33     assert(b <= a);
34     return a - b;
35   }
36 
37   /**
38   * @dev Adds two numbers, throws on overflow.
39   */
40   function add(uint256 a, uint256 b) internal pure returns (uint256) {
41     uint256 c = a + b;
42     assert(c >= a);
43     return c;
44   }
45 }
46 
47 
48 /**
49  * @title Ownable
50  * @dev The Ownable contract has an owner address, and provides basic authorization control
51  * functions, this simplifies the implementation of "user permissions".
52  */
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   function Ownable() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to transfer control of the contract to a newOwner.
78    * @param newOwner The address to transfer ownership to.
79    */
80   function transferOwnership(address newOwner) public onlyOwner {
81     require(newOwner != address(0));
82     OwnershipTransferred(owner, newOwner);
83     owner = newOwner;
84   }
85 
86 }
87 
88 
89 /**
90  * @title PullPayment
91  * @dev Base contract supporting async send for pull payments. Inherit from this
92  * contract and use asyncSend instead of send.
93  */
94 contract PullPayment {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) public payments;
98   uint256 public totalPayments;
99 
100   /**
101   * @dev withdraw accumulated balance, called by payee.
102   */
103   function withdrawPayments() public {
104     address payee = msg.sender;
105     uint256 payment = payments[payee];
106 
107     require(payment != 0);
108     require(this.balance >= payment);
109 
110     totalPayments = totalPayments.sub(payment);
111     payments[payee] = 0;
112 
113     assert(payee.send(payment));
114   }
115 
116   /**
117   * @dev Called by the payer to store the sent amount as credit to be pulled.
118   * @param dest The destination address of the funds.
119   * @param amount The amount to transfer.
120   */
121   function asyncSend(address dest, uint256 amount) internal {
122     payments[dest] = payments[dest].add(amount);
123     totalPayments = totalPayments.add(amount);
124   }
125 }
126 
127 
128 /**
129  * @title Pausable
130  * @dev Base contract which allows children to implement an emergency stop mechanism.
131  */
132 contract Pausable is Ownable {
133   event Pause();
134   event Unpause();
135 
136   bool public paused = false;
137 
138 
139   /**
140    * @dev Modifier to make a function callable only when the contract is not paused.
141    */
142   modifier whenNotPaused() {
143     require(!paused);
144     _;
145   }
146 
147   /**
148    * @dev Modifier to make a function callable only when the contract is paused.
149    */
150   modifier whenPaused() {
151     require(paused);
152     _;
153   }
154 
155   /**
156    * @dev called by the owner to pause, triggers stopped state
157    */
158   function pause() onlyOwner whenNotPaused public {
159     paused = true;
160     Pause();
161   }
162 
163   /**
164    * @dev called by the owner to unpause, returns to normal state
165    */
166   function unpause() onlyOwner whenPaused public {
167     paused = false;
168     Unpause();
169   }
170 }
171 
172 pragma solidity ^0.4.18;
173 
174 /**
175  * @title ERC721 interface
176  * @dev see https://github.com/ethereum/eips/issues/721
177  */
178 contract ERC721 {
179   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
180   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
181 
182   function balanceOf(address _owner) public view returns (uint256 _balance);
183   function ownerOf(uint256 _tokenId) public view returns (address _owner);
184   function transfer(address _to, uint256 _tokenId) public;
185   function approve(address _to, uint256 _tokenId) public;
186   function takeOwnership(uint256 _tokenId) public;
187 }
188 
189 /**
190  * @title ERC721Token
191  * Generic implementation for the required functionality of the ERC721 standard
192  */
193 contract ERC721Token is ERC721 {
194   using SafeMath for uint256;
195 
196   // Total amount of tokens
197   uint256 private totalTokens;
198 
199   // Mapping from token ID to owner
200   mapping (uint256 => address) private tokenOwner;
201 
202   // Mapping from token ID to approved address
203   mapping (uint256 => address) private tokenApprovals;
204 
205   // Mapping from owner to list of owned token IDs
206   mapping (address => uint256[]) private ownedTokens;
207 
208   // Mapping from token ID to index of the owner tokens list
209   mapping(uint256 => uint256) private ownedTokensIndex;
210 
211   /**
212   * @dev Guarantees msg.sender is owner of the given token
213   * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
214   */
215   modifier onlyOwnerOf(uint256 _tokenId) {
216     require(ownerOf(_tokenId) == msg.sender);
217     _;
218   }
219 
220   /**
221   * @dev Gets the total amount of tokens stored by the contract
222   * @return uint256 representing the total amount of tokens
223   */
224   function totalSupply() public view returns (uint256) {
225     return totalTokens;
226   }
227 
228   /**
229   * @dev Gets the balance of the specified address
230   * @param _owner address to query the balance of
231   * @return uint256 representing the amount owned by the passed address
232   */
233   function balanceOf(address _owner) public view returns (uint256) {
234     return ownedTokens[_owner].length;
235   }
236 
237   /**
238   * @dev Gets the list of tokens owned by a given address
239   * @param _owner address to query the tokens of
240   * @return uint256[] representing the list of tokens owned by the passed address
241   */
242   function tokensOf(address _owner) public view returns (uint256[]) {
243     return ownedTokens[_owner];
244   }
245 
246   /**
247   * @dev Gets the owner of the specified token ID
248   * @param _tokenId uint256 ID of the token to query the owner of
249   * @return owner address currently marked as the owner of the given token ID
250   */
251   function ownerOf(uint256 _tokenId) public view returns (address) {
252     address owner = tokenOwner[_tokenId];
253     require(owner != address(0));
254     return owner;
255   }
256 
257   /**
258    * @dev Gets the approved address to take ownership of a given token ID
259    * @param _tokenId uint256 ID of the token to query the approval of
260    * @return address currently approved to take ownership of the given token ID
261    */
262   function approvedFor(uint256 _tokenId) public view returns (address) {
263     return tokenApprovals[_tokenId];
264   }
265 
266   /**
267   * @dev Transfers the ownership of a given token ID to another address
268   * @param _to address to receive the ownership of the given token ID
269   * @param _tokenId uint256 ID of the token to be transferred
270   */
271   function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
272     clearApprovalAndTransfer(msg.sender, _to, _tokenId);
273   }
274 
275   /**
276   * @dev Approves another address to claim for the ownership of the given token ID
277   * @param _to address to be approved for the given token ID
278   * @param _tokenId uint256 ID of the token to be approved
279   */
280   function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
281     address owner = ownerOf(_tokenId);
282     require(_to != owner);
283     if (approvedFor(_tokenId) != 0 || _to != 0) {
284       tokenApprovals[_tokenId] = _to;
285       Approval(owner, _to, _tokenId);
286     }
287   }
288 
289   /**
290   * @dev Claims the ownership of a given token ID
291   * @param _tokenId uint256 ID of the token being claimed by the msg.sender
292   */
293   function takeOwnership(uint256 _tokenId) public {
294     require(isApprovedFor(msg.sender, _tokenId));
295     clearApprovalAndTransfer(ownerOf(_tokenId), msg.sender, _tokenId);
296   }
297 
298   /**
299   * @dev Mint token function
300   * @param _to The address that will own the minted token
301   * @param _tokenId uint256 ID of the token to be minted by the msg.sender
302   */
303   function _mint(address _to, uint256 _tokenId) internal {
304     require(_to != address(0));
305     addToken(_to, _tokenId);
306     Transfer(0x0, _to, _tokenId);
307   }
308 
309   /**
310   * @dev Burns a specific token
311   * @param _tokenId uint256 ID of the token being burned by the msg.sender
312   */
313   function _burn(uint256 _tokenId) onlyOwnerOf(_tokenId) internal {
314     if (approvedFor(_tokenId) != 0) {
315       clearApproval(msg.sender, _tokenId);
316     }
317     removeToken(msg.sender, _tokenId);
318     Transfer(msg.sender, 0x0, _tokenId);
319   }
320 
321   /**
322    * @dev Tells whether the msg.sender is approved for the given token ID or not
323    * This function is not private so it can be extended in further implementations like the operatable ERC721
324    * @param _owner address of the owner to query the approval of
325    * @param _tokenId uint256 ID of the token to query the approval of
326    * @return bool whether the msg.sender is approved for the given token ID or not
327    */
328   function isApprovedFor(address _owner, uint256 _tokenId) internal view returns (bool) {
329     return approvedFor(_tokenId) == _owner;
330   }
331 
332   /**
333   * @dev Internal function to clear current approval and transfer the ownership of a given token ID
334   * @param _from address which you want to send tokens from
335   * @param _to address which you want to transfer the token to
336   * @param _tokenId uint256 ID of the token to be transferred
337   */
338   function clearApprovalAndTransfer(address _from, address _to, uint256 _tokenId) internal {
339     require(_to != address(0));
340     require(_to != ownerOf(_tokenId));
341     require(ownerOf(_tokenId) == _from);
342 
343     clearApproval(_from, _tokenId);
344     removeToken(_from, _tokenId);
345     addToken(_to, _tokenId);
346     Transfer(_from, _to, _tokenId);
347   }
348 
349   /**
350   * @dev Internal function to clear current approval of a given token ID
351   * @param _tokenId uint256 ID of the token to be transferred
352   */
353   function clearApproval(address _owner, uint256 _tokenId) private {
354     require(ownerOf(_tokenId) == _owner);
355     tokenApprovals[_tokenId] = 0;
356     Approval(_owner, 0, _tokenId);
357   }
358 
359   /**
360   * @dev Internal function to add a token ID to the list of a given address
361   * @param _to address representing the new owner of the given token ID
362   * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
363   */
364   function addToken(address _to, uint256 _tokenId) private {
365     require(tokenOwner[_tokenId] == address(0));
366     tokenOwner[_tokenId] = _to;
367     uint256 length = balanceOf(_to);
368     ownedTokens[_to].push(_tokenId);
369     ownedTokensIndex[_tokenId] = length;
370     totalTokens = totalTokens.add(1);
371   }
372 
373   /**
374   * @dev Internal function to remove a token ID from the list of a given address
375   * @param _from address representing the previous owner of the given token ID
376   * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
377   */
378   function removeToken(address _from, uint256 _tokenId) private {
379     require(ownerOf(_tokenId) == _from);
380 
381     uint256 tokenIndex = ownedTokensIndex[_tokenId];
382     uint256 lastTokenIndex = balanceOf(_from).sub(1);
383     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
384 
385     tokenOwner[_tokenId] = 0;
386     ownedTokens[_from][tokenIndex] = lastToken;
387     ownedTokens[_from][lastTokenIndex] = 0;
388     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
389     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
390     // the lastToken to the first position, and then dropping the element placed in the last position of the list
391 
392     ownedTokens[_from].length--;
393     ownedTokensIndex[_tokenId] = 0;
394     ownedTokensIndex[lastToken] = tokenIndex;
395     totalTokens = totalTokens.sub(1);
396   }
397 }
398 
399 /**
400  * @title Composable
401  * Composable - a contract to mint compositions
402  */
403 
404 contract Composable is ERC721Token, Ownable, PullPayment, Pausable {
405    
406     // Max number of layers for a composition token
407     uint public constant MAX_LAYERS = 100;
408 
409     // The minimum composition fee for an ethmoji
410     uint256 public minCompositionFee = 0.001 ether;
411 
412     // Mapping from token ID to composition price
413     mapping (uint256 => uint256) public tokenIdToCompositionPrice;
414     
415     // Mapping from token ID to layers representing it
416     mapping (uint256 => uint256[]) public tokenIdToLayers;
417 
418     // Hash of all layers to track uniqueness of ethmojis
419     mapping (bytes32 => bool) public compositions;
420 
421     // Image hashes to track uniquenes of ethmoji images.
422     mapping (uint256 => uint256) public imageHashes;
423 
424     // Event for emitting new base token created 
425     event BaseTokenCreated(uint256 tokenId);
426     
427     // Event for emitting new composition token created 
428     event CompositionTokenCreated(uint256 tokenId, uint256[] layers, address indexed owner);
429     
430     // Event for emitting composition price changing for a token
431     event CompositionPriceChanged(uint256 tokenId, uint256 price, address indexed owner);
432 
433     // Whether or not this contract accepts making compositions with other compositions
434     bool public isCompositionOnlyWithBaseLayers;
435     
436 // ----- EXPOSED METHODS --------------------------------------------------------------------------
437 
438     /**
439     * @dev Mints a base token to an address with a given composition price
440     * @param _to address of the future owner of the token
441     * @param _compositionPrice uint256 composition price for the new token
442     */
443     function mintTo(address _to, uint256 _compositionPrice, uint256 _imageHash) public onlyOwner {
444         uint256 newTokenIndex = _getNextTokenId();
445         _mint(_to, newTokenIndex);
446         tokenIdToLayers[newTokenIndex] = [newTokenIndex];
447         require(_isUnique(tokenIdToLayers[newTokenIndex], _imageHash));
448         compositions[keccak256([newTokenIndex])] = true;
449         imageHashes[_imageHash] = newTokenIndex;      
450         BaseTokenCreated(newTokenIndex);
451         _setCompositionPrice(newTokenIndex, _compositionPrice);
452     }
453 
454     /**
455     * @dev Mints a composition emoji
456     * @param _tokenIds uint256[] the array of layers that will make up the composition
457     */
458     function compose(uint256[] _tokenIds,  uint256 _imageHash) public payable whenNotPaused {
459         uint256 price = getTotalCompositionPrice(_tokenIds);
460         require(msg.sender != address(0) && msg.value >= price);
461         require(_tokenIds.length <= MAX_LAYERS);
462 
463         uint256[] memory layers = new uint256[](MAX_LAYERS);
464         uint actualSize = 0; 
465 
466         for (uint i = 0; i < _tokenIds.length; i++) { 
467             uint256 compositionLayerId = _tokenIds[i];
468             require(_tokenLayersExist(compositionLayerId));
469             uint256[] memory inheritedLayers = tokenIdToLayers[compositionLayerId];
470             if (isCompositionOnlyWithBaseLayers) { 
471                 require(inheritedLayers.length == 1);
472             }
473             require(inheritedLayers.length < MAX_LAYERS);
474             for (uint j = 0; j < inheritedLayers.length; j++) { 
475                 require(actualSize < MAX_LAYERS);
476                 for (uint k = 0; k < layers.length; k++) { 
477                     require(layers[k] != inheritedLayers[j]);
478                     if (layers[k] == 0) { 
479                         break;
480                     }
481                 }
482                 layers[actualSize] = inheritedLayers[j];
483                 actualSize += 1;
484             }
485             require(ownerOf(compositionLayerId) != address(0));
486             asyncSend(ownerOf(compositionLayerId), tokenIdToCompositionPrice[compositionLayerId]);
487         }
488     
489         uint256 newTokenIndex = _getNextTokenId();
490         
491         tokenIdToLayers[newTokenIndex] = _trim(layers, actualSize);
492         require(_isUnique(tokenIdToLayers[newTokenIndex], _imageHash));
493         compositions[keccak256(tokenIdToLayers[newTokenIndex])] = true;
494         imageHashes[_imageHash] = newTokenIndex;
495     
496         _mint(msg.sender, newTokenIndex);
497 
498         if (msg.value > price) {
499             uint256 purchaseExcess = SafeMath.sub(msg.value, price);
500             msg.sender.transfer(purchaseExcess);          
501         }
502 
503         if (!isCompositionOnlyWithBaseLayers) { 
504             _setCompositionPrice(newTokenIndex, minCompositionFee);
505         }
506    
507         CompositionTokenCreated(newTokenIndex, tokenIdToLayers[newTokenIndex], msg.sender);
508     }
509 
510     /**
511     * @dev allows an address to withdraw its balance in the contract
512     * @param _tokenId uint256 the token ID
513     * @return uint256[] list of layers for a token
514     */
515     function getTokenLayers(uint256 _tokenId) public view returns(uint256[]) {
516         return tokenIdToLayers[_tokenId];
517     }
518 
519     /**
520     * @dev given an array of ids, returns whether or not this composition is valid and unique
521     * does not assume the layers array is flattened 
522     * @param _tokenIds uint256[] an array of token IDs
523     * @return bool whether or not the composition is unique
524     */
525     function isValidComposition(uint256[] _tokenIds, uint256 _imageHash) public view returns (bool) { 
526         if (isCompositionOnlyWithBaseLayers) { 
527             return _isValidBaseLayersOnly(_tokenIds, _imageHash);
528         } else { 
529             return _isValidWithCompositions(_tokenIds, _imageHash);
530         }
531     }
532 
533     /**
534     * @dev returns composition price of a given token ID
535     * @param _tokenId uint256 token ID
536     * @return uint256 composition price
537     */
538     function getCompositionPrice(uint256 _tokenId) public view returns(uint256) { 
539         return tokenIdToCompositionPrice[_tokenId];
540     }
541 
542     /**
543     * @dev get total price for minting a composition given the array of desired layers
544     * @param _tokenIds uint256[] an array of token IDs
545     * @return uint256 price for minting a composition with the desired layers
546     */
547     function getTotalCompositionPrice(uint256[] _tokenIds) public view returns(uint256) {
548         uint256 totalCompositionPrice = 0;
549         for (uint i = 0; i < _tokenIds.length; i++) {
550             require(_tokenLayersExist(_tokenIds[i]));
551             totalCompositionPrice = SafeMath.add(totalCompositionPrice, tokenIdToCompositionPrice[_tokenIds[i]]);
552         }
553 
554         totalCompositionPrice = SafeMath.div(SafeMath.mul(totalCompositionPrice, 105), 100);
555 
556         return totalCompositionPrice;
557     }
558 
559     /**
560     * @dev sets the composition price for a token ID. 
561     * Cannot be lower than the current composition fee
562     * @param _tokenId uint256 the token ID
563     * @param _price uint256 the new composition price
564     */
565     function setCompositionPrice(uint256 _tokenId, uint256 _price) public onlyOwnerOf(_tokenId) {
566         _setCompositionPrice(_tokenId, _price);
567     }
568 
569 // ----- PRIVATE FUNCTIONS ------------------------------------------------------------------------
570 
571     /**
572     * @dev given an array of ids, returns whether or not this composition is valid and unique
573     * for when only base layers are allowed
574     * does not assume the layers array is flattened 
575     * @param _tokenIds uint256[] an array of token IDs
576     * @return bool whether or not the composition is unique
577     */
578     function _isValidBaseLayersOnly(uint256[] _tokenIds, uint256 _imageHash) private view returns (bool) { 
579         require(_tokenIds.length <= MAX_LAYERS);
580         uint256[] memory layers = new uint256[](_tokenIds.length);
581 
582         for (uint i = 0; i < _tokenIds.length; i++) { 
583             if (!_tokenLayersExist(_tokenIds[i])) {
584                 return false;
585             }
586 
587             if (tokenIdToLayers[_tokenIds[i]].length != 1) {
588                 return false;
589             }
590 
591             for (uint k = 0; k < layers.length; k++) { 
592                 if (layers[k] == tokenIdToLayers[_tokenIds[i]][0]) {
593                     return false;
594                 }
595                 if (layers[k] == 0) { 
596                     layers[k] = tokenIdToLayers[_tokenIds[i]][0];
597                     break;
598                 }
599             }
600         }
601     
602         return _isUnique(layers, _imageHash);
603     }
604 
605     /**
606     * @dev given an array of ids, returns whether or not this composition is valid and unique
607     * when compositions are allowed
608     * does not assume the layers array is flattened 
609     * @param _tokenIds uint256[] an array of token IDs
610     * @return bool whether or not the composition is unique
611     */
612     function _isValidWithCompositions(uint256[] _tokenIds, uint256 _imageHash) private view returns (bool) { 
613         uint256[] memory layers = new uint256[](MAX_LAYERS);
614         uint actualSize = 0; 
615         if (_tokenIds.length > MAX_LAYERS) { 
616             return false;
617         }
618 
619         for (uint i = 0; i < _tokenIds.length; i++) { 
620             uint256 compositionLayerId = _tokenIds[i];
621             if (!_tokenLayersExist(compositionLayerId)) { 
622                 return false;
623             }
624             uint256[] memory inheritedLayers = tokenIdToLayers[compositionLayerId];
625             require(inheritedLayers.length < MAX_LAYERS);
626             for (uint j = 0; j < inheritedLayers.length; j++) { 
627                 require(actualSize < MAX_LAYERS);
628                 for (uint k = 0; k < layers.length; k++) { 
629                     if (layers[k] == inheritedLayers[j]) {
630                         return false;
631                     }
632                     if (layers[k] == 0) { 
633                         break;
634                     }
635                 }
636                 layers[actualSize] = inheritedLayers[j];
637                 actualSize += 1;
638             }
639         }
640         return _isUnique(_trim(layers, actualSize), _imageHash);
641     }
642 
643     /**
644     * @dev trims the given array to a given size
645     * @param _layers uint256[] the array of layers that will make up the composition
646     * @param _size uint the array of layers that will make up the composition
647     * @return uint256[] array trimmed to given size
648     */
649     function _trim(uint256[] _layers, uint _size) private pure returns(uint256[]) { 
650         uint256[] memory trimmedLayers = new uint256[](_size);
651         for (uint i = 0; i < _size; i++) { 
652             trimmedLayers[i] = _layers[i];
653         }
654 
655         return trimmedLayers;
656     }
657 
658     /**
659     * @dev checks if a token is an existing token by checking if it has non-zero layers
660     * @param _tokenId uint256 token ID
661     * @return bool whether or not the given tokenId exists according to its layers
662     */
663     function _tokenLayersExist(uint256 _tokenId) private view returns (bool) { 
664         return tokenIdToLayers[_tokenId].length != 0;
665     }
666 
667     /**
668     * @dev set composition price for a token
669     * @param _tokenId uint256 token ID
670     * @param _price uint256 new composition price
671     */
672     function _setCompositionPrice(uint256 _tokenId, uint256 _price) private {
673         require(_price >= minCompositionFee);
674         tokenIdToCompositionPrice[_tokenId] = _price;
675         CompositionPriceChanged(_tokenId, _price, msg.sender);
676     }
677 
678     /**
679     * @dev calculates the next token ID based on totalSupply
680     * @return uint256 for the next token ID
681     */
682     function _getNextTokenId() private view returns (uint256) {
683         return totalSupply().add(1); 
684     }
685 
686     /**
687     * @dev given an array of ids, returns whether or not this composition is unique
688     * assumes the layers are all base layers (flattened)
689     * @param _layers uint256[] an array of token IDs
690     * @param _imageHash uint256 image hash for the composition
691     * @return bool whether or not the composition is unique
692     */
693     function _isUnique(uint256[] _layers, uint256 _imageHash) private view returns (bool) { 
694         return compositions[keccak256(_layers)] == false && imageHashes[_imageHash] == 0;
695     }
696 
697 // ----- ONLY OWNER FUNCTIONS ---------------------------------------------------------------------
698 
699     /**
700     * @dev payout method for the contract owner to payout contract profits to a given address
701     * @param _to address for the payout 
702     */
703     function payout (address _to) public onlyOwner { 
704         totalPayments = 0;
705         _to.transfer(this.balance);
706     }
707 
708     /**
709     * @dev sets global default composition fee for all new tokens
710     * @param _price uint256 new default composition price
711     */
712     function setGlobalCompositionFee(uint256 _price) public onlyOwner { 
713         minCompositionFee = _price;
714     }
715 }
716 
717 contract Ethmoji is Composable {
718     using SafeMath for uint256;
719 
720     string public constant NAME = "Ethmoji";
721     string public constant SYMBOL = "EMJ";
722 
723     // Mapping from address to emoji representing avatar
724     mapping (address => uint256) public addressToAvatar;
725 
726     function Ethmoji() public { 
727         isCompositionOnlyWithBaseLayers = true;
728     }
729 
730     /**
731     * @dev Mints a base token to an address with a given composition price
732     * @param _to address of the future owner of the token
733     * @param _compositionPrice uint256 composition price for the new token
734     */
735     function mintTo(address _to, uint256 _compositionPrice, uint256 _imageHash) public onlyOwner {
736         Composable.mintTo(_to, _compositionPrice, _imageHash);
737         _setAvatarIfNoAvatarIsSet(_to, tokensOf(_to)[0]);
738     }
739 
740     /**
741     * @dev Mints a composition emoji
742     * @param _tokenIds uint256[] the array of layers that will make up the composition
743     */
744     function compose(uint256[] _tokenIds,  uint256 _imageHash) public payable whenNotPaused {
745         Composable.compose(_tokenIds, _imageHash);
746         _setAvatarIfNoAvatarIsSet(msg.sender, tokensOf(msg.sender)[0]);
747 
748 
749         // Immediately pay out to layer owners
750         for (uint8 i = 0; i < _tokenIds.length; i++) {
751             _withdrawTo(ownerOf(_tokenIds[i]));
752         }
753     }
754 
755 // ----- EXPOSED METHODS --------------------------------------------------------------------------
756 
757     /**
758     * @dev returns the name ETHMOJI
759     * @return string ETHMOJI
760     */
761     function name() public pure returns (string) {
762         return NAME;
763     }
764 
765     /**
766     * @dev returns the name EMJ
767     * @return string EMJ
768     */
769     function symbol() public pure returns (string) {
770         return SYMBOL;
771     }
772 
773     /**
774     * @dev sets avatar for an address
775     * @param _tokenId uint256 token ID
776     */
777     function setAvatar(uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {
778         addressToAvatar[msg.sender] = _tokenId;
779     }
780 
781     /**
782     * @dev returns the ID representing the avatar of the address
783     * @param _owner address
784     * @return uint256 token ID of the avatar associated with that address
785     */
786     function getAvatar(address _owner) public view returns(uint256) {
787         return addressToAvatar[_owner];
788     }
789 
790     /**
791     * @dev transfer ownership of token. keeps track of avatar logic
792     * @param _to address to whom the token is being transferred to
793     * @param _tokenId uint256 the ID of the token being transferred
794     */
795     function transfer(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) whenNotPaused {
796         // If the transferred token was previous owner's avatar, remove it
797         if (addressToAvatar[msg.sender] == _tokenId) {
798             _removeAvatar(msg.sender);
799         }
800 
801         ERC721Token.transfer(_to, _tokenId);
802     }
803 
804 // ----- PRIVATE FUNCTIONS ------------------------------------------------------------------------
805 
806     /**
807     * @dev sets avatar if no avatar was previously set
808     * @param _owner address of the new vatara owner
809     * @param _tokenId uint256 token ID
810     */
811     function _setAvatarIfNoAvatarIsSet(address _owner, uint256 _tokenId) private {
812         if (addressToAvatar[_owner] == 0) {
813             addressToAvatar[_owner] = _tokenId;
814         }
815     }
816 
817     /**
818     * @dev removes avatar for address
819     * @param _owner address of the avatar owner
820     */
821     function _removeAvatar(address _owner) private {
822         addressToAvatar[_owner] = 0;
823     }
824 
825     /**
826     * @dev withdraw accumulated balance to the payee
827     * @param _payee address to which to withdraw to
828     */
829     function _withdrawTo(address _payee) private {
830         uint256 payment = payments[_payee];
831 
832         if (payment != 0 && this.balance >= payment) {
833             totalPayments = totalPayments.sub(payment);
834             payments[_payee] = 0;
835 
836             _payee.transfer(payment);
837         }
838     }
839 }