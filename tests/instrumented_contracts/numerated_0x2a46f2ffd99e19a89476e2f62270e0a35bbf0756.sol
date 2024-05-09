1 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/math/SafeMath.sol
2 
3 pragma solidity ^0.4.21;
4 
5 
6 /**
7  * @title SafeMath
8  * @dev Math operations with safety checks that throw on error
9  */
10 library SafeMath {
11 
12   /**
13   * @dev Multiplies two numbers, throws on overflow.
14   */
15   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
16     if (a == 0) {
17       return 0;
18     }
19     c = a * b;
20     assert(c / a == b);
21     return c;
22   }
23 
24   /**
25   * @dev Integer division of two numbers, truncating the quotient.
26   */
27   function div(uint256 a, uint256 b) internal pure returns (uint256) {
28     // assert(b > 0); // Solidity automatically throws when dividing by 0
29     // uint256 c = a / b;
30     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
31     return a / b;
32   }
33 
34   /**
35   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
36   */
37   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   /**
43   * @dev Adds two numbers, throws on overflow.
44   */
45   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
46     c = a + b;
47     assert(c >= a);
48     return c;
49   }
50 }
51 
52 // File: REMIX_FILE_SYNC/ApprovedCreatorRegistryInterface.sol
53 
54 pragma solidity ^0.4.22;
55 
56 
57 /**
58  * Interface to the digital media store external contract that is 
59  * responsible for storing the common digital media and collection data.
60  * This allows for new token contracts to be deployed and continue to reference
61  * the digital media and collection data.
62  */
63 contract ApprovedCreatorRegistryInterface {
64 
65     function getVersion() public pure returns (uint);
66     function typeOfContract() public pure returns (string);
67     function isOperatorApprovedForCustodialAccount(
68         address _operator,
69         address _custodialAddress) public view returns (bool);
70 
71 }
72 
73 // File: REMIX_FILE_SYNC/DigitalMediaStoreInterface.sol
74 
75 pragma solidity 0.4.25;
76 
77 
78 /**
79  * Interface to the digital media store external contract that is 
80  * responsible for storing the common digital media and collection data.
81  * This allows for new token contracts to be deployed and continue to reference
82  * the digital media and collection data.
83  */
84 contract DigitalMediaStoreInterface {
85 
86     function getDigitalMediaStoreVersion() public pure returns (uint);
87 
88     function getStartingDigitalMediaId() public view returns (uint256);
89 
90     function registerTokenContractAddress() external;
91 
92     /**
93      * Creates a new digital media object in storage
94      * @param  _creator address the address of the creator
95      * @param  _printIndex uint32 the current print index for the limited edition media
96      * @param  _totalSupply uint32 the total allowable prints for this media
97      * @param  _collectionId uint256 the collection id that this media belongs to
98      * @param  _metadataPath string the ipfs metadata path
99      * @return the id of the new digital media created
100      */
101     function createDigitalMedia(
102                 address _creator, 
103                 uint32 _printIndex, 
104                 uint32 _totalSupply, 
105                 uint256 _collectionId, 
106                 string _metadataPath) external returns (uint);
107 
108     /**
109      * Increments the current print index of the digital media object
110      * @param  _digitalMediaId uint256 the id of the digital media
111      * @param  _increment uint32 the amount to increment by
112      */
113     function incrementDigitalMediaPrintIndex(
114                 uint256 _digitalMediaId, 
115                 uint32 _increment)  external;
116 
117     /**
118      * Retrieves the digital media object by id
119      * @param  _digitalMediaId uint256 the address of the creator
120      */
121     function getDigitalMedia(uint256 _digitalMediaId) external view returns(
122                 uint256 id,
123                 uint32 totalSupply,
124                 uint32 printIndex,
125                 uint256 collectionId,
126                 address creator,
127                 string metadataPath);
128 
129     /**
130      * Creates a new collection
131      * @param  _creator address the address of the creator
132      * @param  _metadataPath string the ipfs metadata path
133      * @return the id of the new collection created
134      */
135     function createCollection(address _creator, string _metadataPath) external returns (uint);
136 
137     /**
138      * Retrieves a collection by id
139      * @param  _collectionId uint256
140      */
141     function getCollection(uint256 _collectionId) external view
142             returns(
143                 uint256 id,
144                 address creator,
145                 string metadataPath);
146 }
147 
148 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/ownership/Ownable.sol
149 
150 pragma solidity ^0.4.21;
151 
152 
153 /**
154  * @title Ownable
155  * @dev The Ownable contract has an owner address, and provides basic authorization control
156  * functions, this simplifies the implementation of "user permissions".
157  */
158 contract Ownable {
159   address public owner;
160 
161 
162   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
163 
164 
165   /**
166    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
167    * account.
168    */
169   function Ownable() public {
170     owner = msg.sender;
171   }
172 
173   /**
174    * @dev Throws if called by any account other than the owner.
175    */
176   modifier onlyOwner() {
177     require(msg.sender == owner);
178     _;
179   }
180 
181   /**
182    * @dev Allows the current owner to transfer control of the contract to a newOwner.
183    * @param newOwner The address to transfer ownership to.
184    */
185   function transferOwnership(address newOwner) public onlyOwner {
186     require(newOwner != address(0));
187     emit OwnershipTransferred(owner, newOwner);
188     owner = newOwner;
189   }
190 
191 }
192 
193 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/lifecycle/Pausable.sol
194 
195 pragma solidity ^0.4.21;
196 
197 
198 
199 /**
200  * @title Pausable
201  * @dev Base contract which allows children to implement an emergency stop mechanism.
202  */
203 contract Pausable is Ownable {
204   event Pause();
205   event Unpause();
206 
207   bool public paused = false;
208 
209 
210   /**
211    * @dev Modifier to make a function callable only when the contract is not paused.
212    */
213   modifier whenNotPaused() {
214     require(!paused);
215     _;
216   }
217 
218   /**
219    * @dev Modifier to make a function callable only when the contract is paused.
220    */
221   modifier whenPaused() {
222     require(paused);
223     _;
224   }
225 
226   /**
227    * @dev called by the owner to pause, triggers stopped state
228    */
229   function pause() onlyOwner whenNotPaused public {
230     paused = true;
231     emit Pause();
232   }
233 
234   /**
235    * @dev called by the owner to unpause, returns to normal state
236    */
237   function unpause() onlyOwner whenPaused public {
238     paused = false;
239     emit Unpause();
240   }
241 }
242 
243 // File: REMIX_FILE_SYNC/MediaStoreVersionControl.sol
244 
245 pragma solidity 0.4.25;
246 
247 
248 
249 /**
250  * A special control class that is used to configure and manage a token contract's 
251  * different digital media store versions.
252  *
253  * Older versions of token contracts had the ability to increment the digital media's
254  * print edition in the media store, which was necessary in the early stages to provide
255  * upgradeability and flexibility.
256  *
257  * New verions will get rid of this ability now that token contract logic
258  * is more stable and we've built in burn capabilities.  
259  *
260  * In order to support the older tokens, we need to be able to look up the appropriate digital
261  * media store associated with a given digital media id on the latest token contract.
262  */
263 contract MediaStoreVersionControl is Pausable {
264 
265     // The single allowed creator for this digital media contract.
266     DigitalMediaStoreInterface public v1DigitalMediaStore;
267 
268     // The current digitial media store, used for this tokens creation.
269     DigitalMediaStoreInterface public currentDigitalMediaStore;
270     uint256 public currentStartingDigitalMediaId;
271 
272 
273     /**
274      * Validates that the managers are initialized.
275      */
276     modifier managersInitialized() {
277         require(v1DigitalMediaStore != address(0));
278         require(currentDigitalMediaStore != address(0));
279         _;
280     }
281 
282     /**
283      * Sets a digital media store address upon construction.  
284      * Once set it's immutable, so that a token contract is always
285      * tied to one digital media store.
286      */
287     function setDigitalMediaStoreAddress(address _dmsAddress)  
288             internal {
289         DigitalMediaStoreInterface candidateDigitalMediaStore = DigitalMediaStoreInterface(_dmsAddress);
290         require(candidateDigitalMediaStore.getDigitalMediaStoreVersion() == 2, "Incorrect version.");
291         currentDigitalMediaStore = candidateDigitalMediaStore;
292         currentDigitalMediaStore.registerTokenContractAddress();
293         currentStartingDigitalMediaId = currentDigitalMediaStore.getStartingDigitalMediaId();
294     }
295 
296     /**
297      * Publicly callable by the owner, but can only be set one time, so don't make 
298      * a mistake when setting it.
299      *
300      * Will also check that the version on the other end of the contract is in fact correct.
301      */
302     function setV1DigitalMediaStoreAddress(address _dmsAddress) public onlyOwner {
303         require(address(v1DigitalMediaStore) == 0, "V1 media store already set.");
304         DigitalMediaStoreInterface candidateDigitalMediaStore = DigitalMediaStoreInterface(_dmsAddress);
305         require(candidateDigitalMediaStore.getDigitalMediaStoreVersion() == 1, "Incorrect version.");
306         v1DigitalMediaStore = candidateDigitalMediaStore;
307         v1DigitalMediaStore.registerTokenContractAddress();
308     }
309 
310     /**
311      * Depending on the digital media id, determines whether to return the previous
312      * version of the digital media manager.
313      */
314     function _getDigitalMediaStore(uint256 _digitalMediaId) 
315             internal 
316             view
317             managersInitialized
318             returns (DigitalMediaStoreInterface) {
319         if (_digitalMediaId < currentStartingDigitalMediaId) {
320             return v1DigitalMediaStore;
321         } else {
322             return currentDigitalMediaStore;
323         }
324     }  
325 }
326 
327 // File: REMIX_FILE_SYNC/DigitalMediaManager.sol
328 
329 pragma solidity 0.4.25;
330 
331 
332 
333 
334 /**
335  * Manager that interfaces with the underlying digital media store contract.
336  */
337 contract DigitalMediaManager is MediaStoreVersionControl {
338 
339     struct DigitalMedia {
340         uint256 id;
341         uint32 totalSupply;
342         uint32 printIndex;
343         uint256 collectionId;
344         address creator;
345         string metadataPath;
346     }
347 
348     struct DigitalMediaCollection {
349         uint256 id;
350         address creator;
351         string metadataPath;
352     }
353 
354     ApprovedCreatorRegistryInterface public creatorRegistryStore;
355 
356     // Set the creator registry address upon construction. Immutable.
357     function setCreatorRegistryStore(address _crsAddress) internal {
358         ApprovedCreatorRegistryInterface candidateCreatorRegistryStore = ApprovedCreatorRegistryInterface(_crsAddress);
359         require(candidateCreatorRegistryStore.getVersion() == 1);
360         // Simple check to make sure we are adding the registry contract indeed
361         // https://fravoll.github.io/solidity-patterns/string_equality_comparison.html
362         require(keccak256(candidateCreatorRegistryStore.typeOfContract()) == keccak256("approvedCreatorRegistry"));
363         creatorRegistryStore = candidateCreatorRegistryStore;
364     }
365 
366     /**
367      * Validates that the Registered store is initialized.
368      */
369     modifier registryInitialized() {
370         require(creatorRegistryStore != address(0));
371         _;
372     }
373 
374     /**
375      * Retrieves a collection object by id.
376      */
377     function _getCollection(uint256 _id) 
378             internal 
379             view 
380             managersInitialized 
381             returns(DigitalMediaCollection) {
382         uint256 id;
383         address creator;
384         string memory metadataPath;
385         (id, creator, metadataPath) = currentDigitalMediaStore.getCollection(_id);
386         DigitalMediaCollection memory collection = DigitalMediaCollection({
387             id: id,
388             creator: creator,
389             metadataPath: metadataPath
390         });
391         return collection;
392     }
393 
394     /**
395      * Retrieves a digital media object by id.
396      */
397     function _getDigitalMedia(uint256 _id) 
398             internal 
399             view 
400             managersInitialized 
401             returns(DigitalMedia) {
402         uint256 id;
403         uint32 totalSupply;
404         uint32 printIndex;
405         uint256 collectionId;
406         address creator;
407         string memory metadataPath;
408         DigitalMediaStoreInterface _digitalMediaStore = _getDigitalMediaStore(_id);
409         (id, totalSupply, printIndex, collectionId, creator, metadataPath) = _digitalMediaStore.getDigitalMedia(_id);
410         DigitalMedia memory digitalMedia = DigitalMedia({
411             id: id,
412             creator: creator,
413             totalSupply: totalSupply,
414             printIndex: printIndex,
415             collectionId: collectionId,
416             metadataPath: metadataPath
417         });
418         return digitalMedia;
419     }
420 
421     /**
422      * Increments the print index of a digital media object by some increment.
423      */
424     function _incrementDigitalMediaPrintIndex(DigitalMedia _dm, uint32 _increment) 
425             internal 
426             managersInitialized {
427         DigitalMediaStoreInterface _digitalMediaStore = _getDigitalMediaStore(_dm.id);
428         _digitalMediaStore.incrementDigitalMediaPrintIndex(_dm.id, _increment);
429     }
430 
431     // Check if the token operator is approved for the owner address
432     function isOperatorApprovedForCustodialAccount(
433         address _operator, 
434         address _owner) internal view registryInitialized returns(bool) {
435         return creatorRegistryStore.isOperatorApprovedForCustodialAccount(
436             _operator, _owner);
437     }
438 }
439 
440 // File: REMIX_FILE_SYNC/SingleCreatorControl.sol
441 
442 pragma solidity 0.4.25;
443 
444 
445 /**
446  * A special control class that's used to help enforce that a DigitalMedia contract
447  * will service only a single creator's address.  This is used when deploying a 
448  * custom token contract owned and managed by a single creator.
449  */
450 contract SingleCreatorControl {
451 
452     // The single allowed creator for this digital media contract.
453     address public singleCreatorAddress;
454 
455     // The single creator has changed.
456     event SingleCreatorChanged(
457         address indexed previousCreatorAddress, 
458         address indexed newCreatorAddress);
459 
460     /**
461      * Sets the single creator associated with this contract.  This function
462      * can only ever be called once, and should ideally be called at the point
463      * of constructing the smart contract.
464      */
465     function setSingleCreator(address _singleCreatorAddress) internal {
466         require(singleCreatorAddress == address(0), "Single creator address already set.");
467         singleCreatorAddress = _singleCreatorAddress;
468     }
469 
470     /**
471      * Checks whether a given creator address matches the single creator address.
472      * Will always return true if a single creator address was never set.
473      */
474     function isAllowedSingleCreator(address _creatorAddress) internal view returns (bool) {
475         require(_creatorAddress != address(0), "0x0 creator addresses are not allowed.");
476         return singleCreatorAddress == address(0) || singleCreatorAddress == _creatorAddress;
477     }
478 
479     /**
480      * A publicly accessible function that allows the current single creator
481      * assigned to this contract to change to another address.
482      */
483     function changeSingleCreator(address _newCreatorAddress) public {
484         require(_newCreatorAddress != address(0));
485         require(msg.sender == singleCreatorAddress, "Not approved to change single creator.");
486         singleCreatorAddress = _newCreatorAddress;
487         emit SingleCreatorChanged(singleCreatorAddress, _newCreatorAddress);
488     }
489 }
490 
491 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/token/ERC721/ERC721Basic.sol
492 
493 pragma solidity ^0.4.21;
494 
495 
496 /**
497  * @title ERC721 Non-Fungible Token Standard basic interface
498  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
499  */
500 contract ERC721Basic {
501   event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
502   event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
503   event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
504 
505   function balanceOf(address _owner) public view returns (uint256 _balance);
506   function ownerOf(uint256 _tokenId) public view returns (address _owner);
507   function exists(uint256 _tokenId) public view returns (bool _exists);
508 
509   function approve(address _to, uint256 _tokenId) public;
510   function getApproved(uint256 _tokenId) public view returns (address _operator);
511 
512   function setApprovalForAll(address _operator, bool _approved) public;
513   function isApprovedForAll(address _owner, address _operator) public view returns (bool);
514 
515   function transferFrom(address _from, address _to, uint256 _tokenId) public;
516   function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
517   function safeTransferFrom(
518     address _from,
519     address _to,
520     uint256 _tokenId,
521     bytes _data
522   )
523     public;
524 }
525 
526 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
527 
528 pragma solidity ^0.4.21;
529 
530 
531 
532 /**
533  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
534  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
535  */
536 contract ERC721Enumerable is ERC721Basic {
537   function totalSupply() public view returns (uint256);
538   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256 _tokenId);
539   function tokenByIndex(uint256 _index) public view returns (uint256);
540 }
541 
542 
543 /**
544  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
545  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
546  */
547 contract ERC721Metadata is ERC721Basic {
548   function name() public view returns (string _name);
549   function symbol() public view returns (string _symbol);
550   function tokenURI(uint256 _tokenId) public view returns (string);
551 }
552 
553 
554 /**
555  * @title ERC-721 Non-Fungible Token Standard, full implementation interface
556  * @dev See https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
557  */
558 contract ERC721 is ERC721Basic, ERC721Enumerable, ERC721Metadata {
559 }
560 
561 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/token/ERC721/ERC721Receiver.sol
562 
563 pragma solidity ^0.4.21;
564 
565 
566 /**
567  * @title ERC721 token receiver interface
568  * @dev Interface for any contract that wants to support safeTransfers
569  *  from ERC721 asset contracts.
570  */
571 contract ERC721Receiver {
572   /**
573    * @dev Magic value to be returned upon successful reception of an NFT
574    *  Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`,
575    *  which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
576    */
577   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
578 
579   /**
580    * @notice Handle the receipt of an NFT
581    * @dev The ERC721 smart contract calls this function on the recipient
582    *  after a `safetransfer`. This function MAY throw to revert and reject the
583    *  transfer. This function MUST use 50,000 gas or less. Return of other
584    *  than the magic value MUST result in the transaction being reverted.
585    *  Note: the contract address is always the message sender.
586    * @param _from The sending address
587    * @param _tokenId The NFT identifier which is being transfered
588    * @param _data Additional data with no specified format
589    * @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
590    */
591   function onERC721Received(address _from, uint256 _tokenId, bytes _data) public returns(bytes4);
592 }
593 
594 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/AddressUtils.sol
595 
596 pragma solidity ^0.4.21;
597 
598 
599 /**
600  * Utility library of inline functions on addresses
601  */
602 library AddressUtils {
603 
604   /**
605    * Returns whether the target address is a contract
606    * @dev This function will return false if invoked during the constructor of a contract,
607    *  as the code is not actually created until after the constructor finishes.
608    * @param addr address to check
609    * @return whether the target address is a contract
610    */
611   function isContract(address addr) internal view returns (bool) {
612     uint256 size;
613     // XXX Currently there is no better way to check if there is a contract in an address
614     // than to check the size of the code at that address.
615     // See https://ethereum.stackexchange.com/a/14016/36603
616     // for more details about how this works.
617     // TODO Check this again before the Serenity release, because all addresses will be
618     // contracts then.
619     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
620     return size > 0;
621   }
622 
623 }
624 
625 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/token/ERC721/ERC721BasicToken.sol
626 
627 pragma solidity ^0.4.21;
628 
629 
630 
631 
632 
633 
634 /**
635  * @title ERC721 Non-Fungible Token Standard basic implementation
636  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
637  */
638 contract ERC721BasicToken is ERC721Basic {
639   using SafeMath for uint256;
640   using AddressUtils for address;
641 
642   // Equals to `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
643   // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
644   bytes4 constant ERC721_RECEIVED = 0xf0b9e5ba;
645 
646   // Mapping from token ID to owner
647   mapping (uint256 => address) internal tokenOwner;
648 
649   // Mapping from token ID to approved address
650   mapping (uint256 => address) internal tokenApprovals;
651 
652   // Mapping from owner to number of owned token
653   mapping (address => uint256) internal ownedTokensCount;
654 
655   // Mapping from owner to operator approvals
656   mapping (address => mapping (address => bool)) internal operatorApprovals;
657 
658   /**
659    * @dev Guarantees msg.sender is owner of the given token
660    * @param _tokenId uint256 ID of the token to validate its ownership belongs to msg.sender
661    */
662   modifier onlyOwnerOf(uint256 _tokenId) {
663     require(ownerOf(_tokenId) == msg.sender);
664     _;
665   }
666 
667   /**
668    * @dev Checks msg.sender can transfer a token, by being owner, approved, or operator
669    * @param _tokenId uint256 ID of the token to validate
670    */
671   modifier canTransfer(uint256 _tokenId) {
672     require(isApprovedOrOwner(msg.sender, _tokenId));
673     _;
674   }
675 
676   /**
677    * @dev Gets the balance of the specified address
678    * @param _owner address to query the balance of
679    * @return uint256 representing the amount owned by the passed address
680    */
681   function balanceOf(address _owner) public view returns (uint256) {
682     require(_owner != address(0));
683     return ownedTokensCount[_owner];
684   }
685 
686   /**
687    * @dev Gets the owner of the specified token ID
688    * @param _tokenId uint256 ID of the token to query the owner of
689    * @return owner address currently marked as the owner of the given token ID
690    */
691   function ownerOf(uint256 _tokenId) public view returns (address) {
692     address owner = tokenOwner[_tokenId];
693     require(owner != address(0));
694     return owner;
695   }
696 
697   /**
698    * @dev Returns whether the specified token exists
699    * @param _tokenId uint256 ID of the token to query the existance of
700    * @return whether the token exists
701    */
702   function exists(uint256 _tokenId) public view returns (bool) {
703     address owner = tokenOwner[_tokenId];
704     return owner != address(0);
705   }
706 
707   /**
708    * @dev Approves another address to transfer the given token ID
709    * @dev The zero address indicates there is no approved address.
710    * @dev There can only be one approved address per token at a given time.
711    * @dev Can only be called by the token owner or an approved operator.
712    * @param _to address to be approved for the given token ID
713    * @param _tokenId uint256 ID of the token to be approved
714    */
715   function approve(address _to, uint256 _tokenId) public {
716     address owner = ownerOf(_tokenId);
717     require(_to != owner);
718     require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
719 
720     if (getApproved(_tokenId) != address(0) || _to != address(0)) {
721       tokenApprovals[_tokenId] = _to;
722       emit Approval(owner, _to, _tokenId);
723     }
724   }
725 
726   /**
727    * @dev Gets the approved address for a token ID, or zero if no address set
728    * @param _tokenId uint256 ID of the token to query the approval of
729    * @return address currently approved for a the given token ID
730    */
731   function getApproved(uint256 _tokenId) public view returns (address) {
732     return tokenApprovals[_tokenId];
733   }
734 
735   /**
736    * @dev Sets or unsets the approval of a given operator
737    * @dev An operator is allowed to transfer all tokens of the sender on their behalf
738    * @param _to operator address to set the approval
739    * @param _approved representing the status of the approval to be set
740    */
741   function setApprovalForAll(address _to, bool _approved) public {
742     require(_to != msg.sender);
743     operatorApprovals[msg.sender][_to] = _approved;
744     emit ApprovalForAll(msg.sender, _to, _approved);
745   }
746 
747   /**
748    * @dev Tells whether an operator is approved by a given owner
749    * @param _owner owner address which you want to query the approval of
750    * @param _operator operator address which you want to query the approval of
751    * @return bool whether the given operator is approved by the given owner
752    */
753   function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
754     return operatorApprovals[_owner][_operator];
755   }
756 
757   /**
758    * @dev Transfers the ownership of a given token ID to another address
759    * @dev Usage of this method is discouraged, use `safeTransferFrom` whenever possible
760    * @dev Requires the msg sender to be the owner, approved, or operator
761    * @param _from current owner of the token
762    * @param _to address to receive the ownership of the given token ID
763    * @param _tokenId uint256 ID of the token to be transferred
764   */
765   function transferFrom(address _from, address _to, uint256 _tokenId) public canTransfer(_tokenId) {
766     require(_from != address(0));
767     require(_to != address(0));
768 
769     clearApproval(_from, _tokenId);
770     removeTokenFrom(_from, _tokenId);
771     addTokenTo(_to, _tokenId);
772 
773     emit Transfer(_from, _to, _tokenId);
774   }
775 
776   /**
777    * @dev Safely transfers the ownership of a given token ID to another address
778    * @dev If the target address is a contract, it must implement `onERC721Received`,
779    *  which is called upon a safe transfer, and return the magic value
780    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
781    *  the transfer is reverted.
782    * @dev Requires the msg sender to be the owner, approved, or operator
783    * @param _from current owner of the token
784    * @param _to address to receive the ownership of the given token ID
785    * @param _tokenId uint256 ID of the token to be transferred
786   */
787   function safeTransferFrom(
788     address _from,
789     address _to,
790     uint256 _tokenId
791   )
792     public
793     canTransfer(_tokenId)
794   {
795     // solium-disable-next-line arg-overflow
796     safeTransferFrom(_from, _to, _tokenId, "");
797   }
798 
799   /**
800    * @dev Safely transfers the ownership of a given token ID to another address
801    * @dev If the target address is a contract, it must implement `onERC721Received`,
802    *  which is called upon a safe transfer, and return the magic value
803    *  `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`; otherwise,
804    *  the transfer is reverted.
805    * @dev Requires the msg sender to be the owner, approved, or operator
806    * @param _from current owner of the token
807    * @param _to address to receive the ownership of the given token ID
808    * @param _tokenId uint256 ID of the token to be transferred
809    * @param _data bytes data to send along with a safe transfer check
810    */
811   function safeTransferFrom(
812     address _from,
813     address _to,
814     uint256 _tokenId,
815     bytes _data
816   )
817     public
818     canTransfer(_tokenId)
819   {
820     transferFrom(_from, _to, _tokenId);
821     // solium-disable-next-line arg-overflow
822     require(checkAndCallSafeTransfer(_from, _to, _tokenId, _data));
823   }
824 
825   /**
826    * @dev Returns whether the given spender can transfer a given token ID
827    * @param _spender address of the spender to query
828    * @param _tokenId uint256 ID of the token to be transferred
829    * @return bool whether the msg.sender is approved for the given token ID,
830    *  is an operator of the owner, or is the owner of the token
831    */
832   function isApprovedOrOwner(address _spender, uint256 _tokenId) internal view returns (bool) {
833     address owner = ownerOf(_tokenId);
834     return _spender == owner || getApproved(_tokenId) == _spender || isApprovedForAll(owner, _spender);
835   }
836 
837   /**
838    * @dev Internal function to mint a new token
839    * @dev Reverts if the given token ID already exists
840    * @param _to The address that will own the minted token
841    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
842    */
843   function _mint(address _to, uint256 _tokenId) internal {
844     require(_to != address(0));
845     addTokenTo(_to, _tokenId);
846     emit Transfer(address(0), _to, _tokenId);
847   }
848 
849   /**
850    * @dev Internal function to burn a specific token
851    * @dev Reverts if the token does not exist
852    * @param _tokenId uint256 ID of the token being burned by the msg.sender
853    */
854   function _burn(address _owner, uint256 _tokenId) internal {
855     clearApproval(_owner, _tokenId);
856     removeTokenFrom(_owner, _tokenId);
857     emit Transfer(_owner, address(0), _tokenId);
858   }
859 
860   /**
861    * @dev Internal function to clear current approval of a given token ID
862    * @dev Reverts if the given address is not indeed the owner of the token
863    * @param _owner owner of the token
864    * @param _tokenId uint256 ID of the token to be transferred
865    */
866   function clearApproval(address _owner, uint256 _tokenId) internal {
867     require(ownerOf(_tokenId) == _owner);
868     if (tokenApprovals[_tokenId] != address(0)) {
869       tokenApprovals[_tokenId] = address(0);
870       emit Approval(_owner, address(0), _tokenId);
871     }
872   }
873 
874   /**
875    * @dev Internal function to add a token ID to the list of a given address
876    * @param _to address representing the new owner of the given token ID
877    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
878    */
879   function addTokenTo(address _to, uint256 _tokenId) internal {
880     require(tokenOwner[_tokenId] == address(0));
881     tokenOwner[_tokenId] = _to;
882     ownedTokensCount[_to] = ownedTokensCount[_to].add(1);
883   }
884 
885   /**
886    * @dev Internal function to remove a token ID from the list of a given address
887    * @param _from address representing the previous owner of the given token ID
888    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
889    */
890   function removeTokenFrom(address _from, uint256 _tokenId) internal {
891     require(ownerOf(_tokenId) == _from);
892     ownedTokensCount[_from] = ownedTokensCount[_from].sub(1);
893     tokenOwner[_tokenId] = address(0);
894   }
895 
896   /**
897    * @dev Internal function to invoke `onERC721Received` on a target address
898    * @dev The call is not executed if the target address is not a contract
899    * @param _from address representing the previous owner of the given token ID
900    * @param _to target address that will receive the tokens
901    * @param _tokenId uint256 ID of the token to be transferred
902    * @param _data bytes optional data to send along with the call
903    * @return whether the call correctly returned the expected magic value
904    */
905   function checkAndCallSafeTransfer(
906     address _from,
907     address _to,
908     uint256 _tokenId,
909     bytes _data
910   )
911     internal
912     returns (bool)
913   {
914     if (!_to.isContract()) {
915       return true;
916     }
917     bytes4 retval = ERC721Receiver(_to).onERC721Received(_from, _tokenId, _data);
918     return (retval == ERC721_RECEIVED);
919   }
920 }
921 
922 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/token/ERC721/ERC721Token.sol
923 
924 pragma solidity ^0.4.21;
925 
926 
927 
928 
929 /**
930  * @title Full ERC721 Token
931  * This implementation includes all the required and some optional functionality of the ERC721 standard
932  * Moreover, it includes approve all functionality using operator terminology
933  * @dev see https://github.com/ethereum/EIPs/blob/master/EIPS/eip-721.md
934  */
935 contract ERC721Token is ERC721, ERC721BasicToken {
936   // Token name
937   string internal name_;
938 
939   // Token symbol
940   string internal symbol_;
941 
942   // Mapping from owner to list of owned token IDs
943   mapping (address => uint256[]) internal ownedTokens;
944 
945   // Mapping from token ID to index of the owner tokens list
946   mapping(uint256 => uint256) internal ownedTokensIndex;
947 
948   // Array with all token ids, used for enumeration
949   uint256[] internal allTokens;
950 
951   // Mapping from token id to position in the allTokens array
952   mapping(uint256 => uint256) internal allTokensIndex;
953 
954   // Optional mapping for token URIs
955   mapping(uint256 => string) internal tokenURIs;
956 
957   /**
958    * @dev Constructor function
959    */
960   function ERC721Token(string _name, string _symbol) public {
961     name_ = _name;
962     symbol_ = _symbol;
963   }
964 
965   /**
966    * @dev Gets the token name
967    * @return string representing the token name
968    */
969   function name() public view returns (string) {
970     return name_;
971   }
972 
973   /**
974    * @dev Gets the token symbol
975    * @return string representing the token symbol
976    */
977   function symbol() public view returns (string) {
978     return symbol_;
979   }
980 
981   /**
982    * @dev Returns an URI for a given token ID
983    * @dev Throws if the token ID does not exist. May return an empty string.
984    * @param _tokenId uint256 ID of the token to query
985    */
986   function tokenURI(uint256 _tokenId) public view returns (string) {
987     require(exists(_tokenId));
988     return tokenURIs[_tokenId];
989   }
990 
991   /**
992    * @dev Gets the token ID at a given index of the tokens list of the requested owner
993    * @param _owner address owning the tokens list to be accessed
994    * @param _index uint256 representing the index to be accessed of the requested tokens list
995    * @return uint256 token ID at the given index of the tokens list owned by the requested address
996    */
997   function tokenOfOwnerByIndex(address _owner, uint256 _index) public view returns (uint256) {
998     require(_index < balanceOf(_owner));
999     return ownedTokens[_owner][_index];
1000   }
1001 
1002   /**
1003    * @dev Gets the total amount of tokens stored by the contract
1004    * @return uint256 representing the total amount of tokens
1005    */
1006   function totalSupply() public view returns (uint256) {
1007     return allTokens.length;
1008   }
1009 
1010   /**
1011    * @dev Gets the token ID at a given index of all the tokens in this contract
1012    * @dev Reverts if the index is greater or equal to the total number of tokens
1013    * @param _index uint256 representing the index to be accessed of the tokens list
1014    * @return uint256 token ID at the given index of the tokens list
1015    */
1016   function tokenByIndex(uint256 _index) public view returns (uint256) {
1017     require(_index < totalSupply());
1018     return allTokens[_index];
1019   }
1020 
1021   /**
1022    * @dev Internal function to set the token URI for a given token
1023    * @dev Reverts if the token ID does not exist
1024    * @param _tokenId uint256 ID of the token to set its URI
1025    * @param _uri string URI to assign
1026    */
1027   function _setTokenURI(uint256 _tokenId, string _uri) internal {
1028     require(exists(_tokenId));
1029     tokenURIs[_tokenId] = _uri;
1030   }
1031 
1032   /**
1033    * @dev Internal function to add a token ID to the list of a given address
1034    * @param _to address representing the new owner of the given token ID
1035    * @param _tokenId uint256 ID of the token to be added to the tokens list of the given address
1036    */
1037   function addTokenTo(address _to, uint256 _tokenId) internal {
1038     super.addTokenTo(_to, _tokenId);
1039     uint256 length = ownedTokens[_to].length;
1040     ownedTokens[_to].push(_tokenId);
1041     ownedTokensIndex[_tokenId] = length;
1042   }
1043 
1044   /**
1045    * @dev Internal function to remove a token ID from the list of a given address
1046    * @param _from address representing the previous owner of the given token ID
1047    * @param _tokenId uint256 ID of the token to be removed from the tokens list of the given address
1048    */
1049   function removeTokenFrom(address _from, uint256 _tokenId) internal {
1050     super.removeTokenFrom(_from, _tokenId);
1051 
1052     uint256 tokenIndex = ownedTokensIndex[_tokenId];
1053     uint256 lastTokenIndex = ownedTokens[_from].length.sub(1);
1054     uint256 lastToken = ownedTokens[_from][lastTokenIndex];
1055 
1056     ownedTokens[_from][tokenIndex] = lastToken;
1057     ownedTokens[_from][lastTokenIndex] = 0;
1058     // Note that this will handle single-element arrays. In that case, both tokenIndex and lastTokenIndex are going to
1059     // be zero. Then we can make sure that we will remove _tokenId from the ownedTokens list since we are first swapping
1060     // the lastToken to the first position, and then dropping the element placed in the last position of the list
1061 
1062     ownedTokens[_from].length--;
1063     ownedTokensIndex[_tokenId] = 0;
1064     ownedTokensIndex[lastToken] = tokenIndex;
1065   }
1066 
1067   /**
1068    * @dev Internal function to mint a new token
1069    * @dev Reverts if the given token ID already exists
1070    * @param _to address the beneficiary that will own the minted token
1071    * @param _tokenId uint256 ID of the token to be minted by the msg.sender
1072    */
1073   function _mint(address _to, uint256 _tokenId) internal {
1074     super._mint(_to, _tokenId);
1075 
1076     allTokensIndex[_tokenId] = allTokens.length;
1077     allTokens.push(_tokenId);
1078   }
1079 
1080   /**
1081    * @dev Internal function to burn a specific token
1082    * @dev Reverts if the token does not exist
1083    * @param _owner owner of the token to burn
1084    * @param _tokenId uint256 ID of the token being burned by the msg.sender
1085    */
1086   function _burn(address _owner, uint256 _tokenId) internal {
1087     super._burn(_owner, _tokenId);
1088 
1089     // Clear metadata (if any)
1090     if (bytes(tokenURIs[_tokenId]).length != 0) {
1091       delete tokenURIs[_tokenId];
1092     }
1093 
1094     // Reorg all tokens array
1095     uint256 tokenIndex = allTokensIndex[_tokenId];
1096     uint256 lastTokenIndex = allTokens.length.sub(1);
1097     uint256 lastToken = allTokens[lastTokenIndex];
1098 
1099     allTokens[tokenIndex] = lastToken;
1100     allTokens[lastTokenIndex] = 0;
1101 
1102     allTokens.length--;
1103     allTokensIndex[_tokenId] = 0;
1104     allTokensIndex[lastToken] = tokenIndex;
1105   }
1106 
1107 }
1108 
1109 // File: REMIX_FILE_SYNC/ERC721Safe.sol
1110 
1111 pragma solidity 0.4.25;
1112 
1113 // We have to specify what version of compiler this code will compile with
1114 
1115 
1116 
1117 contract ERC721Safe is ERC721Token {
1118     bytes4 constant internal InterfaceSignature_ERC165 =
1119         bytes4(keccak256('supportsInterface(bytes4)'));
1120 
1121     bytes4 constant internal InterfaceSignature_ERC721 =
1122         bytes4(keccak256('name()')) ^
1123         bytes4(keccak256('symbol()')) ^
1124         bytes4(keccak256('totalSupply()')) ^
1125         bytes4(keccak256('balanceOf(address)')) ^
1126         bytes4(keccak256('ownerOf(uint256)')) ^
1127         bytes4(keccak256('approve(address,uint256)')) ^
1128         bytes4(keccak256('safeTransferFrom(address,address,uint256)'));
1129 	
1130    function supportsInterface(bytes4 _interfaceID) external view returns (bool);
1131 }
1132 
1133 // File: REMIX_FILE_SYNC/Memory.sol
1134 
1135 pragma solidity 0.4.25;
1136 
1137 
1138 library Memory {
1139 
1140     // Size of a word, in bytes.
1141     uint internal constant WORD_SIZE = 32;
1142     // Size of the header of a 'bytes' array.
1143     uint internal constant BYTES_HEADER_SIZE = 32;
1144     // Address of the free memory pointer.
1145     uint internal constant FREE_MEM_PTR = 0x40;
1146 
1147     // Compares the 'len' bytes starting at address 'addr' in memory with the 'len'
1148     // bytes starting at 'addr2'.
1149     // Returns 'true' if the bytes are the same, otherwise 'false'.
1150     function equals(uint addr, uint addr2, uint len) internal pure returns (bool equal) {
1151         assembly {
1152             equal := eq(keccak256(addr, len), keccak256(addr2, len))
1153         }
1154     }
1155 
1156     // Compares the 'len' bytes starting at address 'addr' in memory with the bytes stored in
1157     // 'bts'. It is allowed to set 'len' to a lower value then 'bts.length', in which case only
1158     // the first 'len' bytes will be compared.
1159     // Requires that 'bts.length >= len'
1160     function equals(uint addr, uint len, bytes memory bts) internal pure returns (bool equal) {
1161         require(bts.length >= len);
1162         uint addr2;
1163         assembly {
1164             addr2 := add(bts, /*BYTES_HEADER_SIZE*/32)
1165         }
1166         return equals(addr, addr2, len);
1167     }
1168 
1169     // Allocates 'numBytes' bytes in memory. This will prevent the Solidity compiler
1170     // from using this area of memory. It will also initialize the area by setting
1171     // each byte to '0'.
1172     function allocate(uint numBytes) internal pure returns (uint addr) {
1173         // Take the current value of the free memory pointer, and update.
1174         assembly {
1175             addr := mload(/*FREE_MEM_PTR*/0x40)
1176             mstore(/*FREE_MEM_PTR*/0x40, add(addr, numBytes))
1177         }
1178         uint words = (numBytes + WORD_SIZE - 1) / WORD_SIZE;
1179         for (uint i = 0; i < words; i++) {
1180             assembly {
1181                 mstore(add(addr, mul(i, /*WORD_SIZE*/32)), 0)
1182             }
1183         }
1184     }
1185 
1186     // Copy 'len' bytes from memory address 'src', to address 'dest'.
1187     // This function does not check the or destination, it only copies
1188     // the bytes.
1189     function copy(uint src, uint dest, uint len) internal pure {
1190         // Copy word-length chunks while possible
1191         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
1192             assembly {
1193                 mstore(dest, mload(src))
1194             }
1195             dest += WORD_SIZE;
1196             src += WORD_SIZE;
1197         }
1198 
1199         // Copy remaining bytes
1200         uint mask = 256 ** (WORD_SIZE - len) - 1;
1201         assembly {
1202             let srcpart := and(mload(src), not(mask))
1203             let destpart := and(mload(dest), mask)
1204             mstore(dest, or(destpart, srcpart))
1205         }
1206     }
1207 
1208     // Returns a memory pointer to the provided bytes array.
1209     function ptr(bytes memory bts) internal pure returns (uint addr) {
1210         assembly {
1211             addr := bts
1212         }
1213     }
1214 
1215     // Returns a memory pointer to the data portion of the provided bytes array.
1216     function dataPtr(bytes memory bts) internal pure returns (uint addr) {
1217         assembly {
1218             addr := add(bts, /*BYTES_HEADER_SIZE*/32)
1219         }
1220     }
1221 
1222     // This function does the same as 'dataPtr(bytes memory)', but will also return the
1223     // length of the provided bytes array.
1224     function fromBytes(bytes memory bts) internal pure returns (uint addr, uint len) {
1225         len = bts.length;
1226         assembly {
1227             addr := add(bts, /*BYTES_HEADER_SIZE*/32)
1228         }
1229     }
1230 
1231     // Creates a 'bytes memory' variable from the memory address 'addr', with the
1232     // length 'len'. The function will allocate new memory for the bytes array, and
1233     // the 'len bytes starting at 'addr' will be copied into that new memory.
1234     function toBytes(uint addr, uint len) internal pure returns (bytes memory bts) {
1235         bts = new bytes(len);
1236         uint btsptr;
1237         assembly {
1238             btsptr := add(bts, /*BYTES_HEADER_SIZE*/32)
1239         }
1240         copy(addr, btsptr, len);
1241     }
1242 
1243     // Get the word stored at memory address 'addr' as a 'uint'.
1244     function toUint(uint addr) internal pure returns (uint n) {
1245         assembly {
1246             n := mload(addr)
1247         }
1248     }
1249 
1250     // Get the word stored at memory address 'addr' as a 'bytes32'.
1251     function toBytes32(uint addr) internal pure returns (bytes32 bts) {
1252         assembly {
1253             bts := mload(addr)
1254         }
1255     }
1256 
1257     /*
1258     // Get the byte stored at memory address 'addr' as a 'byte'.
1259     function toByte(uint addr, uint8 index) internal pure returns (byte b) {
1260         require(index < WORD_SIZE);
1261         uint8 n;
1262         assembly {
1263             n := byte(index, mload(addr))
1264         }
1265         b = byte(n);
1266     }
1267     */
1268 }
1269 
1270 // File: REMIX_FILE_SYNC/HelperUtils.sol
1271 
1272 pragma solidity 0.4.25;
1273 
1274 
1275 /**
1276  * Internal helper functions
1277  */
1278 contract HelperUtils {
1279 
1280     // converts bytes32 to a string
1281     // enable this when you use it. Saving gas for now
1282     // function bytes32ToString(bytes32 x) private pure returns (string) {
1283     //     bytes memory bytesString = new bytes(32);
1284     //     uint charCount = 0;
1285     //     for (uint j = 0; j < 32; j++) {
1286     //         byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
1287     //         if (char != 0) {
1288     //             bytesString[charCount] = char;
1289     //             charCount++;
1290     //         }
1291     //     }
1292     //     bytes memory bytesStringTrimmed = new bytes(charCount);
1293     //     for (j = 0; j < charCount; j++) {
1294     //         bytesStringTrimmed[j] = bytesString[j];
1295     //     }
1296     //     return string(bytesStringTrimmed);
1297     // } 
1298 
1299     /**
1300      * Concatenates two strings
1301      * @param  _a string
1302      * @param  _b string
1303      * @return string concatenation of two string
1304      */
1305     function strConcat(string _a, string _b) internal pure returns (string) {
1306         bytes memory _ba = bytes(_a);
1307         bytes memory _bb = bytes(_b);
1308         string memory ab = new string(_ba.length + _bb.length);
1309         bytes memory bab = bytes(ab);
1310         uint k = 0;
1311         for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
1312         for (i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
1313         return string(bab);
1314     }
1315 }
1316 
1317 // File: REMIX_FILE_SYNC/DigitalMediaToken.sol
1318 
1319 pragma solidity 0.4.25;
1320 
1321 
1322 
1323 
1324 
1325 /**
1326  * The DigitalMediaToken contract.  Fully implements the ERC721 contract
1327  * from OpenZeppelin without any modifications to it.
1328  * 
1329  * This contract allows for the creation of:
1330  *  1. New Collections
1331  *  2. New DigitalMedia objects
1332  *  3. New DigitalMediaRelease objects
1333  * 
1334  * The primary piece of logic is to ensure that an ERC721 token can 
1335  * have a supply and print edition that is enforced by this contract.
1336  */
1337 contract DigitalMediaToken is DigitalMediaManager, ERC721Safe, HelperUtils, SingleCreatorControl {
1338 
1339     event DigitalMediaReleaseCreateEvent(
1340         uint256 id, 
1341         address owner,
1342         uint32 printEdition,
1343         string tokenURI, 
1344         uint256 digitalMediaId);
1345 
1346     // Event fired when a new digital media is created
1347     event DigitalMediaCreateEvent(
1348         uint256 id, 
1349         address storeContractAddress,
1350         address creator, 
1351         uint32 totalSupply, 
1352         uint32 printIndex, 
1353         uint256 collectionId, 
1354         string metadataPath);
1355 
1356     // Event fired when a digital media's collection is 
1357     event DigitalMediaCollectionCreateEvent(
1358         uint256 id, 
1359         address storeContractAddress,
1360         address creator, 
1361         string metadataPath);
1362 
1363     // Event fired when a digital media is burned
1364     event DigitalMediaBurnEvent(
1365         uint256 id,
1366         address caller,
1367         address storeContractAddress);
1368 
1369     // Event fired when burning a token
1370     event DigitalMediaReleaseBurnEvent(
1371         uint256 tokenId, 
1372         address owner);
1373 
1374     event UpdateDigitalMediaPrintIndexEvent(
1375         uint256 digitalMediaId,
1376         uint32 printEdition);
1377 
1378     // Event fired when a creator assigns a new creator address.
1379     event ChangedCreator(
1380         address creator,
1381         address newCreator);
1382 
1383     struct DigitalMediaRelease {
1384         // The unique edition number of this digital media release
1385         uint32 printEdition;
1386 
1387         // Reference ID to the digital media metadata
1388         uint256 digitalMediaId;
1389     }
1390 
1391     // Maps internal ERC721 token ID to digital media release object.
1392     mapping (uint256 => DigitalMediaRelease) public tokenIdToDigitalMediaRelease;
1393 
1394     // Maps a creator address to a new creator address.  Useful if a creator
1395     // changes their address or the previous address gets compromised.
1396     mapping (address => address) public approvedCreators;
1397 
1398     // Token ID counter
1399     uint256 internal tokenIdCounter = 0;
1400 
1401     constructor (string _tokenName, string _tokenSymbol, uint256 _tokenIdStartingCounter) 
1402             public ERC721Token(_tokenName, _tokenSymbol) {
1403         tokenIdCounter = _tokenIdStartingCounter;
1404     }
1405 
1406     /**
1407      * Creates a new digital media object.
1408      * @param  _creator address  the creator of this digital media
1409      * @param  _totalSupply uint32 the total supply a creation could have
1410      * @param  _collectionId uint256 the collectionId that it belongs to
1411      * @param  _metadataPath string the path to the ipfs metadata
1412      * @return uint the new digital media id
1413      */
1414     function _createDigitalMedia(
1415           address _creator, uint32 _totalSupply, uint256 _collectionId, string _metadataPath) 
1416           internal 
1417           returns (uint) {
1418 
1419         require(_validateCollection(_collectionId, _creator), "Creator for collection not approved.");
1420 
1421         uint256 newDigitalMediaId = currentDigitalMediaStore.createDigitalMedia(
1422             _creator,
1423             0, 
1424             _totalSupply,
1425             _collectionId,
1426             _metadataPath);
1427 
1428         emit DigitalMediaCreateEvent(
1429             newDigitalMediaId,
1430             address(currentDigitalMediaStore),
1431             _creator,
1432             _totalSupply,
1433             0,
1434             _collectionId,
1435             _metadataPath);
1436 
1437         return newDigitalMediaId;
1438     }
1439 
1440     /**
1441      * Burns a token for a given tokenId and caller.
1442      * @param  _tokenId the id of the token to burn.
1443      * @param  _caller the address of the caller.
1444      */
1445     function _burnToken(uint256 _tokenId, address _caller) internal {
1446         address owner = ownerOf(_tokenId);
1447         require(_caller == owner || 
1448                 getApproved(_tokenId) == _caller || 
1449                 isApprovedForAll(owner, _caller),
1450                 "Failed token burn.  Caller is not approved.");
1451         _burn(owner, _tokenId);
1452         delete tokenIdToDigitalMediaRelease[_tokenId];
1453         emit DigitalMediaReleaseBurnEvent(_tokenId, owner);
1454     }
1455 
1456     /**
1457      * Burns a digital media.  Once this function succeeds, this digital media
1458      * will no longer be able to mint any more tokens.  Existing tokens need to be 
1459      * burned individually though.
1460      * @param  _digitalMediaId the id of the digital media to burn
1461      * @param  _caller the address of the caller.
1462      */
1463     function _burnDigitalMedia(uint256 _digitalMediaId, address _caller) internal {
1464         DigitalMedia memory _digitalMedia = _getDigitalMedia(_digitalMediaId);
1465         require(_checkApprovedCreator(_digitalMedia.creator, _caller) || 
1466                 isApprovedForAll(_digitalMedia.creator, _caller), 
1467                 "Failed digital media burn.  Caller not approved.");
1468 
1469         uint32 increment = _digitalMedia.totalSupply - _digitalMedia.printIndex;
1470         _incrementDigitalMediaPrintIndex(_digitalMedia, increment);
1471         address _burnDigitalMediaStoreAddress = address(_getDigitalMediaStore(_digitalMedia.id));
1472         emit DigitalMediaBurnEvent(
1473           _digitalMediaId, _caller, _burnDigitalMediaStoreAddress);
1474     }
1475 
1476     /**
1477      * Creates a new collection
1478      * @param  _creator address the creator of this collection
1479      * @param  _metadataPath string the path to the collection ipfs metadata
1480      * @return uint the new collection id
1481      */
1482     function _createCollection(
1483           address _creator, string _metadataPath) 
1484           internal 
1485           returns (uint) {
1486         uint256 newCollectionId = currentDigitalMediaStore.createCollection(
1487             _creator,
1488             _metadataPath);
1489 
1490         emit DigitalMediaCollectionCreateEvent(
1491             newCollectionId,
1492             address(currentDigitalMediaStore),
1493             _creator,
1494             _metadataPath);
1495 
1496         return newCollectionId;
1497     }
1498 
1499     /**
1500      * Creates _count number of new digital media releases (i.e a token).  
1501      * Bumps up the print index by _count.
1502      * @param  _owner address the owner of the digital media object
1503      * @param  _digitalMediaId uint256 the digital media id
1504      */
1505     function _createDigitalMediaReleases(
1506         address _owner, uint256 _digitalMediaId, uint32 _count)
1507         internal {
1508 
1509         require(_count > 0, "Failed print edition.  Creation count must be > 0.");
1510         require(_count < 10000, "Cannot print more than 10K tokens at once");
1511         DigitalMedia memory _digitalMedia = _getDigitalMedia(_digitalMediaId);
1512         uint32 currentPrintIndex = _digitalMedia.printIndex;
1513         require(_checkApprovedCreator(_digitalMedia.creator, _owner), "Creator not approved.");
1514         require(isAllowedSingleCreator(_owner), "Creator must match single creator address.");
1515         require(_count + currentPrintIndex <= _digitalMedia.totalSupply, "Total supply exceeded.");
1516         
1517         string memory tokenURI = HelperUtils.strConcat("ipfs://ipfs/", _digitalMedia.metadataPath);
1518 
1519         for (uint32 i=0; i < _count; i++) {
1520             uint32 newPrintEdition = currentPrintIndex + 1 + i;
1521             DigitalMediaRelease memory _digitalMediaRelease = DigitalMediaRelease({
1522                 printEdition: newPrintEdition,
1523                 digitalMediaId: _digitalMediaId
1524             });
1525 
1526             uint256 newDigitalMediaReleaseId = _getNextTokenId();
1527             tokenIdToDigitalMediaRelease[newDigitalMediaReleaseId] = _digitalMediaRelease;
1528         
1529             emit DigitalMediaReleaseCreateEvent(
1530                 newDigitalMediaReleaseId,
1531                 _owner,
1532                 newPrintEdition,
1533                 tokenURI,
1534                 _digitalMediaId
1535             );
1536 
1537             // This will assign ownership and also emit the Transfer event as per ERC721
1538             _mint(_owner, newDigitalMediaReleaseId);
1539             _setTokenURI(newDigitalMediaReleaseId, tokenURI);
1540             tokenIdCounter = tokenIdCounter.add(1);
1541 
1542         }
1543         _incrementDigitalMediaPrintIndex(_digitalMedia, _count);
1544         emit UpdateDigitalMediaPrintIndexEvent(_digitalMediaId, currentPrintIndex + _count);
1545     }
1546 
1547     /**
1548      * Checks that a given caller is an approved creator and is allowed to mint or burn
1549      * tokens.  If the creator was changed it will check against the updated creator.
1550      * @param  _caller the calling address
1551      * @return bool allowed or not
1552      */
1553     function _checkApprovedCreator(address _creator, address _caller) 
1554             internal 
1555             view 
1556             returns (bool) {
1557         address approvedCreator = approvedCreators[_creator];
1558         if (approvedCreator != address(0)) {
1559             return approvedCreator == _caller;
1560         } else {
1561             return _creator == _caller;
1562         }
1563     }
1564 
1565     /**
1566      * Validates the an address is allowed to create a digital media on a
1567      * given collection.  Collections are tied to addresses.
1568      */
1569     function _validateCollection(uint256 _collectionId, address _address) 
1570             private 
1571             view 
1572             returns (bool) {
1573         if (_collectionId == 0 ) {
1574             return true;
1575         }
1576 
1577         DigitalMediaCollection memory collection = _getCollection(_collectionId);
1578         return _checkApprovedCreator(collection.creator, _address);
1579     }
1580 
1581     /**
1582     * Generates a new token id.
1583     */
1584     function _getNextTokenId() private view returns (uint256) {
1585         return tokenIdCounter.add(1); 
1586     }
1587 
1588     /**
1589      * Changes the creator that is approved to printing new tokens and creations.
1590      * Either the _caller must be the _creator or the _caller must be the existing
1591      * approvedCreator.
1592      * @param _caller the address of the caller
1593      * @param  _creator the address of the current creator
1594      * @param  _newCreator the address of the new approved creator
1595      */
1596     function _changeCreator(address _caller, address _creator, address _newCreator) internal {
1597         address approvedCreator = approvedCreators[_creator];
1598         require(_caller != address(0) && _creator != address(0), "Creator must be valid non 0x0 address.");
1599         require(_caller == _creator || _caller == approvedCreator, "Unauthorized caller.");
1600         if (approvedCreator == address(0)) {
1601             approvedCreators[_caller] = _newCreator;
1602         } else {
1603             require(_caller == approvedCreator, "Unauthorized caller.");
1604             approvedCreators[_creator] = _newCreator;
1605         }
1606         emit ChangedCreator(_creator, _newCreator);
1607     }
1608 
1609     /**
1610      * Introspection interface as per ERC-165 (https://github.com/ethereum/EIPs/issues/165).
1611      */
1612     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
1613         return ((_interfaceID == InterfaceSignature_ERC165) || (_interfaceID == InterfaceSignature_ERC721));
1614     }
1615 
1616 }
1617 
1618 // File: REMIX_FILE_SYNC/OBOControl.sol
1619 
1620 pragma solidity 0.4.25;
1621 
1622 
1623 
1624 contract OBOControl is Pausable {
1625 	// List of approved on behalf of users.
1626     mapping (address => bool) public approvedOBOs;
1627 
1628 	/**
1629      * Add a new approved on behalf of user address.
1630      */
1631     function addApprovedOBO(address _oboAddress) external onlyOwner {
1632         approvedOBOs[_oboAddress] = true;
1633     }
1634 
1635     /**
1636      * Removes an approved on bhealf of user address.
1637      */
1638     function removeApprovedOBO(address _oboAddress) external onlyOwner {
1639         delete approvedOBOs[_oboAddress];
1640     }
1641 
1642     /**
1643     * @dev Modifier to make the obo calls only callable by approved addressess
1644     */
1645     modifier isApprovedOBO() {
1646         require(approvedOBOs[msg.sender] == true);
1647         _;
1648     }
1649 }
1650 
1651 // File: REMIX_FILE_SYNC/WithdrawFundsControl.sol
1652 
1653 pragma solidity 0.4.25;
1654 
1655 
1656 
1657 contract WithdrawFundsControl is Pausable {
1658 
1659 	// List of approved on withdraw addresses
1660     mapping (address => uint256) public approvedWithdrawAddresses;
1661 
1662     // Full day wait period before an approved withdraw address becomes active
1663     uint256 constant internal withdrawApprovalWaitPeriod = 60 * 60 * 24;
1664 
1665     event WithdrawAddressAdded(address withdrawAddress);
1666     event WithdrawAddressRemoved(address widthdrawAddress);
1667 
1668 	/**
1669      * Add a new approved on behalf of user address.
1670      */
1671     function addApprovedWithdrawAddress(address _withdrawAddress) external onlyOwner {
1672         approvedWithdrawAddresses[_withdrawAddress] = now;
1673         emit WithdrawAddressAdded(_withdrawAddress);
1674     }
1675 
1676     /**
1677      * Removes an approved on bhealf of user address.
1678      */
1679     function removeApprovedWithdrawAddress(address _withdrawAddress) external onlyOwner {
1680         delete approvedWithdrawAddresses[_withdrawAddress];
1681         emit WithdrawAddressRemoved(_withdrawAddress);
1682     }
1683 
1684     /**
1685      * Checks that a given withdraw address ia approved and is past it's required
1686      * wait time.
1687      */
1688     function isApprovedWithdrawAddress(address _withdrawAddress) internal view returns (bool)  {
1689         uint256 approvalTime = approvedWithdrawAddresses[_withdrawAddress];
1690         require (approvalTime > 0);
1691         return now - approvalTime > withdrawApprovalWaitPeriod;
1692     }
1693 }
1694 
1695 // File: REMIX_FILE_SYNC/openzeppelin-solidity/contracts/token/ERC721/ERC721Holder.sol
1696 
1697 pragma solidity ^0.4.21;
1698 
1699 
1700 
1701 contract ERC721Holder is ERC721Receiver {
1702   function onERC721Received(address, uint256, bytes) public returns(bytes4) {
1703     return ERC721_RECEIVED;
1704   }
1705 }
1706 
1707 // File: REMIX_FILE_SYNC/DigitalMediaSaleBase.sol
1708 
1709 pragma solidity 0.4.25;
1710 
1711 
1712 
1713 
1714 
1715 
1716 
1717 /**
1718  * Base class that manages the underlying functions of a Digital Media Sale,
1719  * most importantly the escrow of digital tokens.
1720  *
1721  * Manages ensuring that only approved addresses interact with this contract.
1722  *
1723  */
1724 contract DigitalMediaSaleBase is ERC721Holder, Pausable, OBOControl, WithdrawFundsControl {
1725     using SafeMath for uint256;
1726 
1727      // Mapping of token contract address to bool indicated approval.
1728     mapping (address => bool) public approvedTokenContracts;
1729 
1730     /**
1731      * Adds a new token contract address to be approved to be called.
1732      */
1733     function addApprovedTokenContract(address _tokenContractAddress) 
1734             public onlyOwner {
1735         approvedTokenContracts[_tokenContractAddress] = true;
1736     }
1737 
1738     /**
1739      * Remove an approved token contract address from the list of approved addresses.
1740      */
1741     function removeApprovedTokenContract(address _tokenContractAddress) 
1742             public onlyOwner {            
1743         delete approvedTokenContracts[_tokenContractAddress];
1744     }
1745 
1746     /**
1747      * Checks that a particular token contract address is a valid address.
1748      */
1749     function _isValidTokenContract(address _tokenContractAddress) 
1750             internal view returns (bool) {
1751         return approvedTokenContracts[_tokenContractAddress];
1752     }
1753 
1754     /**
1755      * Returns an ERC721 instance of a token contract address.  Throws otherwise.
1756      * Only valid and approved token contracts are allowed to be interacted with.
1757      */
1758     function _getTokenContract(address _tokenContractAddress) internal view returns (ERC721Safe) {
1759         require(_isValidTokenContract(_tokenContractAddress));
1760         return ERC721Safe(_tokenContractAddress);
1761     }
1762 
1763     /**
1764      * Checks with the ERC-721 token contract that the _claimant actually owns the token.
1765      */
1766     function _owns(address _claimant, uint256 _tokenId, address _tokenContractAddress) internal view returns (bool) {
1767         ERC721Safe tokenContract = _getTokenContract(_tokenContractAddress);
1768         return (tokenContract.ownerOf(_tokenId) == _claimant);
1769     }
1770 
1771     /**
1772      * Checks with the ERC-721 token contract the owner of the a token
1773      */
1774     function _ownerOf(uint256 _tokenId, address _tokenContractAddress) internal view returns (address) {
1775         ERC721Safe tokenContract = _getTokenContract(_tokenContractAddress);
1776         return tokenContract.ownerOf(_tokenId);
1777     }
1778 
1779     /**
1780      * Checks to ensure that the token owner has approved the escrow contract 
1781      */
1782     function _approvedForEscrow(address _seller, uint256 _tokenId, address _tokenContractAddress) internal view returns (bool) {
1783         ERC721Safe tokenContract = _getTokenContract(_tokenContractAddress);
1784         return (tokenContract.isApprovedForAll(_seller, this) || 
1785                 tokenContract.getApproved(_tokenId) == address(this));
1786     }
1787 
1788     /**
1789      * Escrows an ERC-721 token from the seller to this contract.  Assumes that the escrow contract
1790      * is already approved to make the transfer, otherwise it will fail.
1791      */
1792     function _escrow(address _seller, uint256 _tokenId, address _tokenContractAddress) internal {
1793         // it will throw if transfer fails
1794         ERC721Safe tokenContract = _getTokenContract(_tokenContractAddress);
1795         tokenContract.safeTransferFrom(_seller, this, _tokenId);
1796     }
1797 
1798     /**
1799      * Transfer an ERC-721 token from escrow to the buyer.  This is to be called after a purchase is
1800      * completed.
1801      */
1802     function _transfer(address _receiver, uint256 _tokenId, address _tokenContractAddress) internal {
1803         // it will throw if transfer fails
1804         ERC721Safe tokenContract = _getTokenContract(_tokenContractAddress);
1805         tokenContract.safeTransferFrom(this, _receiver, _tokenId);
1806     }
1807 
1808     /**
1809      * Method to check whether this is an escrow contract
1810      */
1811     function isEscrowContract() public pure returns(bool) {
1812         return true;
1813     }
1814 
1815     /**
1816      * Withdraws all the funds to a specified non-zero address
1817      */
1818     function withdrawFunds(address _withdrawAddress) public onlyOwner {
1819         require(isApprovedWithdrawAddress(_withdrawAddress));
1820         _withdrawAddress.transfer(address(this).balance);
1821     }
1822 }
1823 
1824 // File: REMIX_FILE_SYNC/DigitalMediaCore.sol
1825 
1826 pragma solidity 0.4.25;
1827 
1828 
1829 
1830 
1831 
1832 /**
1833  * This is the main driver contract that is used to control and run the service. Funds 
1834  * are managed through this function, underlying contracts are also updated through 
1835  * this contract.
1836  *
1837  * This class also exposes a set of creation methods that are allowed to be created
1838  * by an approved token creator, on behalf of a particular address.  This is meant
1839  * to simply the creation flow for MakersToken users that aren't familiar with 
1840  * the blockchain.  The ERC721 tokens that are created are still fully compliant, 
1841  * although it is possible for a malicious token creator to mint unwanted tokens 
1842  * on behalf of a creator.  Worst case, the creator can burn those tokens.
1843  */
1844 contract DigitalMediaCore is DigitalMediaToken {
1845     using SafeMath for uint32;
1846 
1847     // List of approved token creators (on behalf of the owner)
1848     mapping (address => bool) public approvedTokenCreators;
1849 
1850     // Mapping from owner to operator accounts.
1851     mapping (address => mapping (address => bool)) internal oboOperatorApprovals;
1852 
1853     // Mapping of all disabled OBO operators.
1854     mapping (address => bool) public disabledOboOperators;
1855 
1856     // OboApproveAll Event
1857     event OboApprovalForAll(
1858         address _owner, 
1859         address _operator, 
1860         bool _approved);
1861 
1862     // Fired when disbaling obo capability.
1863     event OboDisabledForAll(address _operator);
1864 
1865     constructor (
1866         string _tokenName, 
1867         string _tokenSymbol, 
1868         uint256 _tokenIdStartingCounter, 
1869         address _dmsAddress,
1870         address _crsAddress)
1871             public DigitalMediaToken(
1872                 _tokenName, 
1873                 _tokenSymbol,
1874                 _tokenIdStartingCounter) {
1875         paused = true;
1876         setDigitalMediaStoreAddress(_dmsAddress);
1877         setCreatorRegistryStore(_crsAddress);
1878     }
1879 
1880     /**
1881      * Retrieves a Digital Media object.
1882      */
1883     function getDigitalMedia(uint256 _id) 
1884             external 
1885             view 
1886             returns (
1887             uint256 id,
1888             uint32 totalSupply,
1889             uint32 printIndex,
1890             uint256 collectionId,
1891             address creator,
1892             string metadataPath) {
1893 
1894         DigitalMedia memory digitalMedia = _getDigitalMedia(_id);
1895         require(digitalMedia.creator != address(0), "DigitalMedia not found.");
1896         id = _id;
1897         totalSupply = digitalMedia.totalSupply;
1898         printIndex = digitalMedia.printIndex;
1899         collectionId = digitalMedia.collectionId;
1900         creator = digitalMedia.creator;
1901         metadataPath = digitalMedia.metadataPath;
1902     }
1903 
1904     /**
1905      * Retrieves a collection.
1906      */
1907     function getCollection(uint256 _id) 
1908             external 
1909             view 
1910             returns (
1911             uint256 id,
1912             address creator,
1913             string metadataPath) {
1914         DigitalMediaCollection memory digitalMediaCollection = _getCollection(_id);
1915         require(digitalMediaCollection.creator != address(0), "Collection not found.");
1916         id = _id;
1917         creator = digitalMediaCollection.creator;
1918         metadataPath = digitalMediaCollection.metadataPath;
1919     }
1920 
1921     /**
1922      * Retrieves a Digital Media Release (i.e a token)
1923      */
1924     function getDigitalMediaRelease(uint256 _id) 
1925             external 
1926             view 
1927             returns (
1928             uint256 id,
1929             uint32 printEdition,
1930             uint256 digitalMediaId) {
1931         require(exists(_id));
1932         DigitalMediaRelease storage digitalMediaRelease = tokenIdToDigitalMediaRelease[_id];
1933         id = _id;
1934         printEdition = digitalMediaRelease.printEdition;
1935         digitalMediaId = digitalMediaRelease.digitalMediaId;
1936     }
1937 
1938     /**
1939      * Creates a new collection.
1940      *
1941      * No creations of any kind are allowed when the contract is paused.
1942      */
1943     function createCollection(string _metadataPath) 
1944             external 
1945             whenNotPaused {
1946         _createCollection(msg.sender, _metadataPath);
1947     }
1948 
1949     /**
1950      * Creates a new digital media object.
1951      */
1952     function createDigitalMedia(uint32 _totalSupply, uint256 _collectionId, string _metadataPath) 
1953             external 
1954             whenNotPaused {
1955         _createDigitalMedia(msg.sender, _totalSupply, _collectionId, _metadataPath);
1956     }
1957 
1958     /**
1959      * Creates a new digital media object and mints it's first digital media release token.
1960      *
1961      * No creations of any kind are allowed when the contract is paused.
1962      */
1963     function createDigitalMediaAndReleases(
1964                 uint32 _totalSupply,
1965                 uint256 _collectionId,
1966                 string _metadataPath,
1967                 uint32 _numReleases)
1968             external 
1969             whenNotPaused {
1970         uint256 digitalMediaId = _createDigitalMedia(msg.sender, _totalSupply, _collectionId, _metadataPath);
1971         _createDigitalMediaReleases(msg.sender, digitalMediaId, _numReleases);
1972     }
1973 
1974     /**
1975      * Creates a new collection, a new digital media object within it and mints a new
1976      * digital media release token.
1977      *
1978      * No creations of any kind are allowed when the contract is paused.
1979      */
1980     function createDigitalMediaAndReleasesInNewCollection(
1981                 uint32 _totalSupply, 
1982                 string _digitalMediaMetadataPath,
1983                 string _collectionMetadataPath,
1984                 uint32 _numReleases)
1985             external 
1986             whenNotPaused {
1987         uint256 collectionId = _createCollection(msg.sender, _collectionMetadataPath);
1988         uint256 digitalMediaId = _createDigitalMedia(msg.sender, _totalSupply, collectionId, _digitalMediaMetadataPath);
1989         _createDigitalMediaReleases(msg.sender, digitalMediaId, _numReleases);
1990     }
1991 
1992     /**
1993      * Creates a new digital media release (token) for a given digital media id.
1994      *
1995      * No creations of any kind are allowed when the contract is paused.
1996      */
1997     function createDigitalMediaReleases(uint256 _digitalMediaId, uint32 _numReleases) 
1998             external 
1999             whenNotPaused {
2000         _createDigitalMediaReleases(msg.sender, _digitalMediaId, _numReleases);
2001     }
2002 
2003     /**
2004      * Deletes a token / digital media release. Doesn't modify the current print index
2005      * and total to be printed. Although dangerous, the owner of a token should always 
2006      * be able to burn a token they own.
2007      *
2008      * Only the owner of the token or accounts approved by the owner can burn this token.
2009      */
2010     function burnToken(uint256 _tokenId) external {
2011         _burnToken(_tokenId, msg.sender);
2012     }
2013 
2014     /* Support ERC721 burn method */
2015     function burn(uint256 tokenId) public {
2016         _burnToken(tokenId, msg.sender);
2017     }
2018 
2019     /**
2020      * Ends the production run of a digital media.  Afterwards no more tokens
2021      * will be allowed to be printed for this digital media.  Used when a creator
2022      * makes a mistake and wishes to burn and recreate their digital media.
2023      * 
2024      * When a contract is paused we do not allow new tokens to be created, 
2025      * so stopping the production of a token doesn't have much purpose.
2026      */
2027     function burnDigitalMedia(uint256 _digitalMediaId) external whenNotPaused {
2028         _burnDigitalMedia(_digitalMediaId, msg.sender);
2029     }
2030 
2031     /**
2032      * Resets the approval rights for a given tokenId.
2033      */
2034     function resetApproval(uint256 _tokenId) external {
2035         clearApproval(msg.sender, _tokenId);
2036     }
2037 
2038     /**
2039      * Changes the creator for the current sender, in the event we 
2040      * need to be able to mint new tokens from an existing digital media 
2041      * print production. When changing creator, the old creator will
2042      * no longer be able to mint tokens.
2043      *
2044      * A creator may need to be changed:
2045      * 1. If we want to allow a creator to take control over their token minting (i.e go decentralized)
2046      * 2. If we want to re-issue private keys due to a compromise.  For this reason, we can call this function
2047      * when the contract is paused.
2048      * @param _creator the creator address
2049      * @param _newCreator the new creator address
2050      */
2051     function changeCreator(address _creator, address _newCreator) external {
2052         _changeCreator(msg.sender, _creator, _newCreator);
2053     }
2054 
2055     /**********************************************************************/
2056     /**Calls that are allowed to be called by approved creator addresses **/ 
2057     /**********************************************************************/
2058     
2059     /**
2060      * Add a new approved token creator.
2061      *
2062      * Only the owner of this contract can update approved Obo accounts.
2063      */
2064     function addApprovedTokenCreator(address _creatorAddress) external onlyOwner {
2065         require(disabledOboOperators[_creatorAddress] != true, "Address disabled.");
2066         approvedTokenCreators[_creatorAddress] = true;
2067     }
2068 
2069     /**
2070      * Removes an approved token creator.
2071      *
2072      * Only the owner of this contract can update approved Obo accounts.
2073      */
2074     function removeApprovedTokenCreator(address _creatorAddress) external onlyOwner {
2075         delete approvedTokenCreators[_creatorAddress];
2076     }
2077 
2078     /**
2079     * @dev Modifier to make the approved creation calls only callable by approved token creators
2080     */
2081     modifier isApprovedCreator() {
2082         require(
2083             (approvedTokenCreators[msg.sender] == true && 
2084              disabledOboOperators[msg.sender] != true), 
2085             "Unapproved OBO address.");
2086         _;
2087     }
2088 
2089     /**
2090      * Only the owner address can set a special obo approval list.
2091      * When issuing OBO management accounts, we should give approvals through
2092      * this method only so that we can very easily reset it's approval in
2093      * the event of a disaster scenario.
2094      *
2095      * Only the owner themselves is allowed to give OboApproveAll access.
2096      */
2097     function setOboApprovalForAll(address _to, bool _approved) public {
2098         require(_to != msg.sender, "Approval address is same as approver.");
2099         require(approvedTokenCreators[_to], "Unrecognized OBO address.");
2100         require(disabledOboOperators[_to] != true, "Approval address is disabled.");
2101         oboOperatorApprovals[msg.sender][_to] = _approved;
2102         emit OboApprovalForAll(msg.sender, _to, _approved);
2103     }
2104 
2105     /**
2106      * Only called in a disaster scenario if the account has been compromised.  
2107      * There's no turning back from this and the oboAddress will no longer be 
2108      * able to be given approval rights or perform obo functions.  
2109      * 
2110      * Only the owner of this contract is allowed to disable an Obo address.
2111      *
2112      */
2113     function disableOboAddress(address _oboAddress) public onlyOwner {
2114         require(approvedTokenCreators[_oboAddress], "Unrecognized OBO address.");
2115         disabledOboOperators[_oboAddress] = true;
2116         delete approvedTokenCreators[_oboAddress];
2117         emit OboDisabledForAll(_oboAddress);
2118     }
2119 
2120     /**
2121      * Override the isApprovalForAll to check for a special oboApproval list.  Reason for this
2122      * is that we can can easily remove obo operators if they every become compromised.
2123      */
2124     function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
2125         if (disabledOboOperators[_operator] == true) {
2126             return false;
2127         } else if (isOperatorApprovedForCustodialAccount(_operator, _owner) == true) {
2128             return true;
2129         } else if (oboOperatorApprovals[_owner][_operator]) {
2130             return true;
2131         } else {
2132             return super.isApprovedForAll(_owner, _operator);
2133         }
2134     }
2135 
2136     /**
2137      * Creates a new digital media object and mints it's digital media release tokens.
2138      * Called on behalf of the _owner. Pass count to mint `n` number of tokens.
2139      *
2140      * Only approved creators are allowed to create Obo.
2141      *
2142      * No creations of any kind are allowed when the contract is paused.
2143      */
2144     function oboCreateDigitalMediaAndReleases(
2145                 address _owner,
2146                 uint32 _totalSupply, 
2147                 uint256 _collectionId, 
2148                 string _metadataPath,
2149                 uint32 _numReleases)
2150             external 
2151             whenNotPaused
2152             isApprovedCreator {
2153         uint256 digitalMediaId = _createDigitalMedia(_owner, _totalSupply, _collectionId, _metadataPath);
2154         _createDigitalMediaReleases(_owner, digitalMediaId, _numReleases);
2155     }
2156 
2157     /**
2158      * Creates a new collection, a new digital media object within it and mints a new
2159      * digital media release token.
2160      * Called on behalf of the _owner.
2161      *
2162      * Only approved creators are allowed to create Obo.
2163      *
2164      * No creations of any kind are allowed when the contract is paused.
2165      */
2166     function oboCreateDigitalMediaAndReleasesInNewCollection(
2167                 address _owner,
2168                 uint32 _totalSupply, 
2169                 string _digitalMediaMetadataPath,
2170                 string _collectionMetadataPath,
2171                 uint32 _numReleases)
2172             external 
2173             whenNotPaused
2174             isApprovedCreator {
2175         uint256 collectionId = _createCollection(_owner, _collectionMetadataPath);
2176         uint256 digitalMediaId = _createDigitalMedia(_owner, _totalSupply, collectionId, _digitalMediaMetadataPath);
2177         _createDigitalMediaReleases(_owner, digitalMediaId, _numReleases);
2178     }
2179 
2180     /**
2181      * Creates multiple digital media releases (tokens) for a given digital media id.
2182      * Called on behalf of the _owner.
2183      *
2184      * Only approved creators are allowed to create Obo.
2185      *
2186      * No creations of any kind are allowed when the contract is paused.
2187      */
2188     function oboCreateDigitalMediaReleases(
2189                 address _owner,
2190                 uint256 _digitalMediaId,
2191                 uint32 _numReleases) 
2192             external 
2193             whenNotPaused
2194             isApprovedCreator {
2195         _createDigitalMediaReleases(_owner, _digitalMediaId, _numReleases);
2196     }
2197 
2198 }