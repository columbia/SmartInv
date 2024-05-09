1 pragma solidity ^0.4.24;
2 
3 // File: contracts/estate/IEstateRegistry.sol
4 
5 contract IEstateRegistry {
6   function mint(address to, string metadata) external returns (uint256);
7 
8   // Events
9 
10   event CreateEstate(
11     address indexed _owner,
12     uint256 indexed _estateId,
13     string _data
14   );
15 
16   event AddLand(
17     uint256 indexed _estateId,
18     uint256 indexed _landId
19   );
20 
21   event RemoveLand(
22     uint256 indexed _estateId,
23     uint256 indexed _landId,
24     address indexed _destinatary
25   );
26 
27   event Update(
28     uint256 indexed _assetId,
29     address indexed _holder,
30     address indexed _operator,
31     string _data
32   );
33 
34   event UpdateOperator(
35     uint256 indexed _estateId,
36     address indexed _operator
37   );
38 
39   event SetLANDRegistry(
40     address indexed _registry
41   );
42 }
43 
44 // File: contracts/land/LANDStorage.sol
45 
46 contract LANDStorage {
47   mapping (address => uint) public latestPing;
48 
49   uint256 constant clearLow = 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;
50   uint256 constant clearHigh = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
51   uint256 constant factor = 0x100000000000000000000000000000000;
52 
53   mapping (address => bool) public authorizedDeploy;
54 
55   mapping (uint256 => address) public updateOperator;
56 
57   IEstateRegistry public estateRegistry;
58 }
59 
60 // File: contracts/upgradable/OwnableStorage.sol
61 
62 contract OwnableStorage {
63 
64   address public owner;
65 
66   constructor() internal {
67     owner = msg.sender;
68   }
69 
70 }
71 
72 // File: contracts/upgradable/ProxyStorage.sol
73 
74 contract ProxyStorage {
75 
76   /**
77    * Current contract to which we are proxing
78    */
79   address public currentContract;
80   address public proxyOwner;
81 }
82 
83 // File: erc821/contracts/AssetRegistryStorage.sol
84 
85 contract AssetRegistryStorage {
86 
87   string internal _name;
88   string internal _symbol;
89   string internal _description;
90 
91   /**
92    * Stores the total count of assets managed by this registry
93    */
94   uint256 internal _count;
95 
96   /**
97    * Stores an array of assets owned by a given account
98    */
99   mapping(address => uint256[]) internal _assetsOf;
100 
101   /**
102    * Stores the current holder of an asset
103    */
104   mapping(uint256 => address) internal _holderOf;
105 
106   /**
107    * Stores the index of an asset in the `_assetsOf` array of its holder
108    */
109   mapping(uint256 => uint256) internal _indexOfAsset;
110 
111   /**
112    * Stores the data associated with an asset
113    */
114   mapping(uint256 => string) internal _assetData;
115 
116   /**
117    * For a given account, for a given operator, store whether that operator is
118    * allowed to transfer and modify assets on behalf of them.
119    */
120   mapping(address => mapping(address => bool)) internal _operators;
121 
122   /**
123    * Approval array
124    */
125   mapping(uint256 => address) internal _approval;
126 }
127 
128 // File: contracts/Storage.sol
129 
130 contract Storage is ProxyStorage, OwnableStorage, AssetRegistryStorage, LANDStorage {
131 }
132 
133 // File: erc821/contracts/ERC165.sol
134 
135 interface ERC165 {
136   function supportsInterface(bytes4 interfaceID) external view returns (bool);
137 }
138 
139 // File: contracts/metadata/IMetadataHolder.sol
140 
141 contract IMetadataHolder is ERC165 {
142   function getMetadata(uint256 /* assetId */) external view returns (string);
143 }
144 
145 // File: contracts/upgradable/IApplication.sol
146 
147 contract IApplication {
148   function initialize(bytes data) public;
149 }
150 
151 // File: contracts/upgradable/Ownable.sol
152 
153 contract Ownable is Storage {
154 
155   event OwnerUpdate(address _prevOwner, address _newOwner);
156 
157   modifier onlyOwner {
158     assert(msg.sender == owner);
159     _;
160   }
161 
162   function transferOwnership(address _newOwner) public onlyOwner {
163     require(_newOwner != owner, "Cannot transfer to yourself");
164     owner = _newOwner;
165   }
166 }
167 
168 // File: contracts/land/ILANDRegistry.sol
169 
170 interface ILANDRegistry {
171 
172   // LAND can be assigned by the owner
173   function assignNewParcel(int x, int y, address beneficiary) external;
174   function assignMultipleParcels(int[] x, int[] y, address beneficiary) external;
175 
176   // After one year, LAND can be claimed from an inactive public key
177   function ping() external;
178 
179   // LAND-centric getters
180   function encodeTokenId(int x, int y) external pure returns (uint256);
181   function decodeTokenId(uint value) external pure returns (int, int);
182   function exists(int x, int y) external view returns (bool);
183   function ownerOfLand(int x, int y) external view returns (address);
184   function ownerOfLandMany(int[] x, int[] y) external view returns (address[]);
185   function landOf(address owner) external view returns (int[], int[]);
186   function landData(int x, int y) external view returns (string);
187 
188   // Transfer LAND
189   function transferLand(int x, int y, address to) external;
190   function transferManyLand(int[] x, int[] y, address to) external;
191 
192   // Update LAND
193   function updateLandData(int x, int y, string data) external;
194   function updateManyLandData(int[] x, int[] y, string data) external;
195 
196   // Events
197 
198   event Update(
199     uint256 indexed assetId,
200     address indexed holder,
201     address indexed operator,
202     string data
203   );
204 
205   event UpdateOperator(
206     uint256 indexed assetId,
207     address indexed operator
208   );
209 }
210 
211 // File: erc821/contracts/IERC721Base.sol
212 
213 interface IERC721Base {
214   function totalSupply() external view returns (uint256);
215 
216   // function exists(uint256 assetId) external view returns (bool);
217   function ownerOf(uint256 assetId) external view returns (address);
218 
219   function balanceOf(address holder) external view returns (uint256);
220 
221   function safeTransferFrom(address from, address to, uint256 assetId) external;
222   function safeTransferFrom(address from, address to, uint256 assetId, bytes userData) external;
223 
224   function transferFrom(address from, address to, uint256 assetId) external;
225 
226   function approve(address operator, uint256 assetId) external;
227   function setApprovalForAll(address operator, bool authorized) external;
228 
229   function getApprovedAddress(uint256 assetId) external view returns (address);
230   function isApprovedForAll(address operator, address assetOwner) external view returns (bool);
231 
232   function isAuthorized(address operator, uint256 assetId) external view returns (bool);
233 
234   /**
235    * @dev Deprecated transfer event. Now we use the standard with three parameters
236    * It is only used in the ABI to get old transfer events. Do not remove
237    */
238   event Transfer(
239     address indexed from,
240     address indexed to,
241     uint256 indexed assetId,
242     address operator,
243     bytes userData
244   );
245   event Transfer(
246     address indexed from,
247     address indexed to,
248     uint256 indexed assetId
249   );
250   event ApprovalForAll(
251     address indexed operator,
252     address indexed holder,
253     bool authorized
254   );
255   event Approval(
256     address indexed owner,
257     address indexed operator,
258     uint256 indexed assetId
259   );
260 }
261 
262 // File: erc821/contracts/IERC721Receiver.sol
263 
264 interface IERC721Receiver {
265   function onERC721Received(
266     address _operator,
267     address _from,
268     uint256 _tokenId,
269     bytes   _userData
270   ) external returns (bytes4);
271 }
272 
273 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
274 
275 /**
276  * @title SafeMath
277  * @dev Math operations with safety checks that throw on error
278  */
279 library SafeMath {
280 
281   /**
282   * @dev Multiplies two numbers, throws on overflow.
283   */
284   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
285     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
286     // benefit is lost if 'b' is also tested.
287     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
288     if (_a == 0) {
289       return 0;
290     }
291 
292     c = _a * _b;
293     assert(c / _a == _b);
294     return c;
295   }
296 
297   /**
298   * @dev Integer division of two numbers, truncating the quotient.
299   */
300   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
301     // assert(_b > 0); // Solidity automatically throws when dividing by 0
302     // uint256 c = _a / _b;
303     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
304     return _a / _b;
305   }
306 
307   /**
308   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
309   */
310   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
311     assert(_b <= _a);
312     return _a - _b;
313   }
314 
315   /**
316   * @dev Adds two numbers, throws on overflow.
317   */
318   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
319     c = _a + _b;
320     assert(c >= _a);
321     return c;
322   }
323 }
324 
325 // File: erc821/contracts/ERC721Base.sol
326 
327 contract ERC721Base is AssetRegistryStorage, IERC721Base, ERC165 {
328   using SafeMath for uint256;
329 
330   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
331   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
332 
333   //
334   // Global Getters
335   //
336 
337   /**
338    * @dev Gets the total amount of assets stored by the contract
339    * @return uint256 representing the total amount of assets
340    */
341   function totalSupply() external view returns (uint256) {
342     return _totalSupply();
343   }
344   function _totalSupply() internal view returns (uint256) {
345     return _count;
346   }
347 
348   //
349   // Asset-centric getter functions
350   //
351 
352   /**
353    * @dev Queries what address owns an asset. This method does not throw.
354    * In order to check if the asset exists, use the `exists` function or check if the
355    * return value of this call is `0`.
356    * @return uint256 the assetId
357    */
358   function ownerOf(uint256 assetId) external view returns (address) {
359     return _ownerOf(assetId);
360   }
361   function _ownerOf(uint256 assetId) internal view returns (address) {
362     return _holderOf[assetId];
363   }
364 
365   //
366   // Holder-centric getter functions
367   //
368   /**
369    * @dev Gets the balance of the specified address
370    * @param owner address to query the balance of
371    * @return uint256 representing the amount owned by the passed address
372    */
373   function balanceOf(address owner) external view returns (uint256) {
374     return _balanceOf(owner);
375   }
376   function _balanceOf(address owner) internal view returns (uint256) {
377     return _assetsOf[owner].length;
378   }
379 
380   //
381   // Authorization getters
382   //
383 
384   /**
385    * @dev Query whether an address has been authorized to move any assets on behalf of someone else
386    * @param operator the address that might be authorized
387    * @param assetHolder the address that provided the authorization
388    * @return bool true if the operator has been authorized to move any assets
389    */
390   function isApprovedForAll(address assetHolder, address operator)
391     external view returns (bool)
392   {
393     return _isApprovedForAll(assetHolder, operator);
394   }
395   function _isApprovedForAll(address assetHolder, address operator)
396     internal view returns (bool)
397   {
398     return _operators[assetHolder][operator];
399   }
400 
401   /**
402    * @dev Query what address has been particularly authorized to move an asset
403    * @param assetId the asset to be queried for
404    * @return bool true if the asset has been approved by the holder
405    */
406   function getApproved(uint256 assetId) external view returns (address) {
407     return _getApprovedAddress(assetId);
408   }
409   function getApprovedAddress(uint256 assetId) external view returns (address) {
410     return _getApprovedAddress(assetId);
411   }
412   function _getApprovedAddress(uint256 assetId) internal view returns (address) {
413     return _approval[assetId];
414   }
415 
416   /**
417    * @dev Query if an operator can move an asset.
418    * @param operator the address that might be authorized
419    * @param assetId the asset that has been `approved` for transfer
420    * @return bool true if the asset has been approved by the holder
421    */
422   function isAuthorized(address operator, uint256 assetId) external view returns (bool) {
423     return _isAuthorized(operator, assetId);
424   }
425   function _isAuthorized(address operator, uint256 assetId) internal view returns (bool)
426   {
427     require(operator != 0);
428     address owner = _ownerOf(assetId);
429     if (operator == owner) {
430       return true;
431     }
432     return _isApprovedForAll(owner, operator) || _getApprovedAddress(assetId) == operator;
433   }
434 
435   //
436   // Authorization
437   //
438 
439   /**
440    * @dev Authorize a third party operator to manage (send) msg.sender's asset
441    * @param operator address to be approved
442    * @param authorized bool set to true to authorize, false to withdraw authorization
443    */
444   function setApprovalForAll(address operator, bool authorized) external {
445     return _setApprovalForAll(operator, authorized);
446   }
447   function _setApprovalForAll(address operator, bool authorized) internal {
448     if (authorized) {
449       require(!_isApprovedForAll(msg.sender, operator));
450       _addAuthorization(operator, msg.sender);
451     } else {
452       require(_isApprovedForAll(msg.sender, operator));
453       _clearAuthorization(operator, msg.sender);
454     }
455     emit ApprovalForAll(msg.sender, operator, authorized);
456   }
457 
458   /**
459    * @dev Authorize a third party operator to manage one particular asset
460    * @param operator address to be approved
461    * @param assetId asset to approve
462    */
463   function approve(address operator, uint256 assetId) external {
464     address holder = _ownerOf(assetId);
465     require(msg.sender == holder || _isApprovedForAll(msg.sender, holder));
466     require(operator != holder);
467 
468     if (_getApprovedAddress(assetId) != operator) {
469       _approval[assetId] = operator;
470       emit Approval(holder, operator, assetId);
471     }
472   }
473 
474   function _addAuthorization(address operator, address holder) private {
475     _operators[holder][operator] = true;
476   }
477 
478   function _clearAuthorization(address operator, address holder) private {
479     _operators[holder][operator] = false;
480   }
481 
482   //
483   // Internal Operations
484   //
485 
486   function _addAssetTo(address to, uint256 assetId) internal {
487     _holderOf[assetId] = to;
488 
489     uint256 length = _balanceOf(to);
490 
491     _assetsOf[to].push(assetId);
492 
493     _indexOfAsset[assetId] = length;
494 
495     _count = _count.add(1);
496   }
497 
498   function _removeAssetFrom(address from, uint256 assetId) internal {
499     uint256 assetIndex = _indexOfAsset[assetId];
500     uint256 lastAssetIndex = _balanceOf(from).sub(1);
501     uint256 lastAssetId = _assetsOf[from][lastAssetIndex];
502 
503     _holderOf[assetId] = 0;
504 
505     // Insert the last asset into the position previously occupied by the asset to be removed
506     _assetsOf[from][assetIndex] = lastAssetId;
507 
508     // Resize the array
509     _assetsOf[from][lastAssetIndex] = 0;
510     _assetsOf[from].length--;
511 
512     // Remove the array if no more assets are owned to prevent pollution
513     if (_assetsOf[from].length == 0) {
514       delete _assetsOf[from];
515     }
516 
517     // Update the index of positions for the asset
518     _indexOfAsset[assetId] = 0;
519     _indexOfAsset[lastAssetId] = assetIndex;
520 
521     _count = _count.sub(1);
522   }
523 
524   function _clearApproval(address holder, uint256 assetId) internal {
525     if (_ownerOf(assetId) == holder && _approval[assetId] != 0) {
526       _approval[assetId] = 0;
527       emit Approval(holder, 0, assetId);
528     }
529   }
530 
531   //
532   // Supply-altering functions
533   //
534 
535   function _generate(uint256 assetId, address beneficiary) internal {
536     require(_holderOf[assetId] == 0);
537 
538     _addAssetTo(beneficiary, assetId);
539 
540     emit Transfer(0, beneficiary, assetId);
541   }
542 
543   function _destroy(uint256 assetId) internal {
544     address holder = _holderOf[assetId];
545     require(holder != 0);
546 
547     _removeAssetFrom(holder, assetId);
548 
549     emit Transfer(holder, 0, assetId);
550   }
551 
552   //
553   // Transaction related operations
554   //
555 
556   modifier onlyHolder(uint256 assetId) {
557     require(_ownerOf(assetId) == msg.sender);
558     _;
559   }
560 
561   modifier onlyAuthorized(uint256 assetId) {
562     require(_isAuthorized(msg.sender, assetId));
563     _;
564   }
565 
566   modifier isCurrentOwner(address from, uint256 assetId) {
567     require(_ownerOf(assetId) == from);
568     _;
569   }
570 
571   modifier isDestinataryDefined(address destinatary) {
572     require(destinatary != 0);
573     _;
574   }
575 
576   modifier destinataryIsNotHolder(uint256 assetId, address to) {
577     require(_ownerOf(assetId) != to);
578     _;
579   }
580 
581   /**
582    * @dev Alias of `safeTransferFrom(from, to, assetId, '')`
583    *
584    * @param from address that currently owns an asset
585    * @param to address to receive the ownership of the asset
586    * @param assetId uint256 ID of the asset to be transferred
587    */
588   function safeTransferFrom(address from, address to, uint256 assetId) external {
589     return _doTransferFrom(from, to, assetId, '', true);
590   }
591 
592   /**
593    * @dev Securely transfers the ownership of a given asset from one address to
594    * another address, calling the method `onNFTReceived` on the target address if
595    * there's code associated with it
596    *
597    * @param from address that currently owns an asset
598    * @param to address to receive the ownership of the asset
599    * @param assetId uint256 ID of the asset to be transferred
600    * @param userData bytes arbitrary user information to attach to this transfer
601    */
602   function safeTransferFrom(address from, address to, uint256 assetId, bytes userData) external {
603     return _doTransferFrom(from, to, assetId, userData, true);
604   }
605 
606   /**
607    * @dev Transfers the ownership of a given asset from one address to another address
608    * Warning! This function does not attempt to verify that the target address can send
609    * tokens.
610    *
611    * @param from address sending the asset
612    * @param to address to receive the ownership of the asset
613    * @param assetId uint256 ID of the asset to be transferred
614    */
615   function transferFrom(address from, address to, uint256 assetId) external {
616     return _doTransferFrom(from, to, assetId, '', false);
617   }
618 
619   function _doTransferFrom(
620     address from,
621     address to,
622     uint256 assetId,
623     bytes userData,
624     bool doCheck
625   )
626     onlyAuthorized(assetId)
627     internal
628   {
629     _moveToken(from, to, assetId, userData, doCheck);
630   }
631 
632   function _moveToken(
633     address from,
634     address to,
635     uint256 assetId,
636     bytes userData,
637     bool doCheck
638   )
639     isDestinataryDefined(to)
640     destinataryIsNotHolder(assetId, to)
641     isCurrentOwner(from, assetId)
642     internal
643   {
644     address holder = _holderOf[assetId];
645     _removeAssetFrom(holder, assetId);
646     _clearApproval(holder, assetId);
647     _addAssetTo(to, assetId);
648 
649     if (doCheck && _isContract(to)) {
650       // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
651       require(
652         IERC721Receiver(to).onERC721Received(
653           msg.sender, holder, assetId, userData
654         ) == ERC721_RECEIVED
655       );
656     }
657 
658     emit Transfer(holder, to, assetId);
659   }
660 
661   /**
662    * Internal function that moves an asset from one holder to another
663    */
664 
665   /**
666    * @dev Returns `true` if the contract implements `interfaceID` and `interfaceID` is not 0xffffffff, `false` otherwise
667    * @param  _interfaceID The interface identifier, as specified in ERC-165
668    */
669   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
670 
671     if (_interfaceID == 0xffffffff) {
672       return false;
673     }
674     return (_interfaceID == 0x01ffc9a7) || (_interfaceID == 0x7c0633c6);
675   }
676 
677   //
678   // Utilities
679   //
680 
681   function _isContract(address addr) internal view returns (bool) {
682     uint size;
683     assembly { size := extcodesize(addr) }
684     return size > 0;
685   }
686 }
687 
688 // File: erc821/contracts/IERC721Enumerable.sol
689 
690 contract IERC721Enumerable {
691 
692   /**
693    * @notice Enumerate active tokens
694    * @dev Throws if `index` >= `totalSupply()`, otherwise SHALL NOT throw.
695    * @param index A counter less than `totalSupply()`
696    * @return The identifier for the `index`th asset, (sort order not
697    *  specified)
698    */
699   // TODO (eordano): Not implemented
700   // function tokenByIndex(uint256 index) public view returns (uint256 _assetId);
701 
702   /**
703    * @notice Count of owners which own at least one asset
704    *  Must not throw.
705    * @return A count of the number of owners which own asset
706    */
707   // TODO (eordano): Not implemented
708   // function countOfOwners() public view returns (uint256 _count);
709 
710   /**
711    * @notice Enumerate owners
712    * @dev Throws if `index` >= `countOfOwners()`, otherwise must not throw.
713    * @param index A counter less than `countOfOwners()`
714    * @return The address of the `index`th owner (sort order not specified)
715    */
716   // TODO (eordano): Not implemented
717   // function ownerByIndex(uint256 index) public view returns (address owner);
718 
719   /**
720    * @notice Get all tokens of a given address
721    * @dev This is not intended to be used on-chain
722    * @param owner address of the owner to query
723    * @return a list of all assetIds of a user
724    */
725   function tokensOf(address owner) external view returns (uint256[]);
726 
727   /**
728    * @notice Enumerate tokens assigned to an owner
729    * @dev Throws if `index` >= `balanceOf(owner)` or if
730    *  `owner` is the zero address, representing invalid assets.
731    *  Otherwise this must not throw.
732    * @param owner An address where we are interested in assets owned by them
733    * @param index A counter less than `balanceOf(owner)`
734    * @return The identifier for the `index`th asset assigned to `owner`,
735    *   (sort order not specified)
736    */
737   function tokenOfOwnerByIndex(
738     address owner, uint256 index
739   ) external view returns (uint256 tokenId);
740 }
741 
742 // File: erc821/contracts/ERC721Enumerable.sol
743 
744 contract ERC721Enumerable is AssetRegistryStorage, IERC721Enumerable {
745 
746   /**
747    * @notice Get all tokens of a given address
748    * @dev This is not intended to be used on-chain
749    * @param owner address of the owner to query
750    * @return a list of all assetIds of a user
751    */
752   function tokensOf(address owner) external view returns (uint256[]) {
753     return _assetsOf[owner];
754   }
755 
756   /**
757    * @notice Enumerate tokens assigned to an owner
758    * @dev Throws if `index` >= `balanceOf(owner)` or if
759    *  `owner` is the zero address, representing invalid assets.
760    *  Otherwise this must not throw.
761    * @param owner An address where we are interested in assets owned by them
762    * @param index A counter less than `balanceOf(owner)`
763    * @return The identifier for the `index`th asset assigned to `owner`,
764    *   (sort order not specified)
765    */
766   function tokenOfOwnerByIndex(
767     address owner, uint256 index
768   )
769     external
770     view
771     returns (uint256 assetId)
772   {
773     require(index < _assetsOf[owner].length);
774     require(index < (1<<127));
775     return _assetsOf[owner][index];
776   }
777 
778 }
779 
780 // File: erc821/contracts/IERC721Metadata.sol
781 
782 contract IERC721Metadata {
783 
784   /**
785    * @notice A descriptive name for a collection of NFTs in this contract
786    */
787   function name() external view returns (string);
788 
789   /**
790    * @notice An abbreviated name for NFTs in this contract
791    */
792   function symbol() external view returns (string);
793 
794   /**
795    * @notice A description of what this DAR is used for
796    */
797   function description() external view returns (string);
798 
799   /**
800    * Stores arbitrary info about a token
801    */
802   function tokenMetadata(uint256 assetId) external view returns (string);
803 }
804 
805 // File: erc821/contracts/ERC721Metadata.sol
806 
807 contract ERC721Metadata is AssetRegistryStorage, IERC721Metadata {
808   function name() external view returns (string) {
809     return _name;
810   }
811   function symbol() external view returns (string) {
812     return _symbol;
813   }
814   function description() external view returns (string) {
815     return _description;
816   }
817   function tokenMetadata(uint256 assetId) external view returns (string) {
818     return _assetData[assetId];
819   }
820   function _update(uint256 assetId, string data) internal {
821     _assetData[assetId] = data;
822   }
823 }
824 
825 // File: erc821/contracts/FullAssetRegistry.sol
826 
827 contract FullAssetRegistry is ERC721Base, ERC721Enumerable, ERC721Metadata {
828   constructor() public {
829   }
830 
831   /**
832    * @dev Method to check if an asset identified by the given id exists under this DAR.
833    * @return uint256 the assetId
834    */
835   function exists(uint256 assetId) external view returns (bool) {
836     return _exists(assetId);
837   }
838   function _exists(uint256 assetId) internal view returns (bool) {
839     return _holderOf[assetId] != 0;
840   }
841 
842   function decimals() external pure returns (uint256) {
843     return 0;
844   }
845 }
846 
847 // File: contracts/land/LANDRegistry.sol
848 
849 /* solium-disable function-order */
850 contract LANDRegistry is Storage, Ownable, FullAssetRegistry, ILANDRegistry {
851   bytes4 constant public GET_METADATA = bytes4(keccak256("getMetadata(uint256)"));
852 
853   function initialize(bytes) external {
854     _name = "Decentraland LAND";
855     _symbol = "LAND";
856     _description = "Contract that stores the Decentraland LAND registry";
857   }
858 
859   modifier onlyProxyOwner() {
860     require(msg.sender == proxyOwner, "This function can only be called by the proxy owner");
861     _;
862   }
863 
864   //
865   // LAND Create and destroy
866   //
867 
868   modifier onlyOwnerOf(uint256 assetId) {
869     require(
870       msg.sender == _ownerOf(assetId),
871       "This function can only be called by the owner of the asset"
872     );
873     _;
874   }
875 
876   modifier onlyUpdateAuthorized(uint256 tokenId) {
877     require(
878       msg.sender == _ownerOf(tokenId) || _isUpdateAuthorized(msg.sender, tokenId),
879       "msg.sender is not authorized to update"
880     );
881     _;
882   }
883 
884   function isUpdateAuthorized(address operator, uint256 assetId) external view returns (bool) {
885     return _isUpdateAuthorized(operator, assetId);
886   }
887 
888   function _isUpdateAuthorized(address operator, uint256 assetId) internal view returns (bool) {
889     return operator == _ownerOf(assetId) || updateOperator[assetId] == operator;
890   }
891 
892   function authorizeDeploy(address beneficiary) external onlyProxyOwner {
893     authorizedDeploy[beneficiary] = true;
894   }
895 
896   function forbidDeploy(address beneficiary) external onlyProxyOwner {
897     authorizedDeploy[beneficiary] = false;
898   }
899 
900   function assignNewParcel(int x, int y, address beneficiary) external onlyProxyOwner {
901     _generate(_encodeTokenId(x, y), beneficiary);
902   }
903 
904   function assignMultipleParcels(int[] x, int[] y, address beneficiary) external onlyProxyOwner {
905     for (uint i = 0; i < x.length; i++) {
906       _generate(_encodeTokenId(x[i], y[i]), beneficiary);
907     }
908   }
909 
910   //
911   // Inactive keys after 1 year lose ownership
912   //
913 
914   function ping() external {
915     // solium-disable-next-line security/no-block-members
916     latestPing[msg.sender] = block.timestamp;
917   }
918 
919   function setLatestToNow(address user) external {
920     require(msg.sender == proxyOwner || _isApprovedForAll(msg.sender, user), "Unauthorized user");
921     // solium-disable-next-line security/no-block-members
922     latestPing[user] = block.timestamp;
923   }
924 
925   //
926   // LAND Getters
927   //
928 
929   function encodeTokenId(int x, int y) external pure returns (uint) {
930     return _encodeTokenId(x, y);
931   }
932 
933   function _encodeTokenId(int x, int y) internal pure returns (uint result) {
934     require(
935       -1000000 < x && x < 1000000 && -1000000 < y && y < 1000000,
936       "The coordinates should be inside bounds"
937     );
938     return _unsafeEncodeTokenId(x, y);
939   }
940 
941   function _unsafeEncodeTokenId(int x, int y) internal pure returns (uint) {
942     return ((uint(x) * factor) & clearLow) | (uint(y) & clearHigh);
943   }
944 
945   function decodeTokenId(uint value) external pure returns (int, int) {
946     return _decodeTokenId(value);
947   }
948 
949   function _unsafeDecodeTokenId(uint value) internal pure returns (int x, int y) {
950     x = expandNegative128BitCast((value & clearLow) >> 128);
951     y = expandNegative128BitCast(value & clearHigh);
952   }
953 
954   function _decodeTokenId(uint value) internal pure returns (int x, int y) {
955     (x, y) = _unsafeDecodeTokenId(value);
956     require(
957       -1000000 < x && x < 1000000 && -1000000 < y && y < 1000000,
958       "The coordinates should be inside bounds"
959     );
960   }
961 
962   function expandNegative128BitCast(uint value) internal pure returns (int) {
963     if (value & (1<<127) != 0) {
964       return int(value | clearLow);
965     }
966     return int(value);
967   }
968 
969   function exists(int x, int y) external view returns (bool) {
970     return _exists(x, y);
971   }
972 
973   function _exists(int x, int y) internal view returns (bool) {
974     return _exists(_encodeTokenId(x, y));
975   }
976 
977   function ownerOfLand(int x, int y) external view returns (address) {
978     return _ownerOfLand(x, y);
979   }
980 
981   function _ownerOfLand(int x, int y) internal view returns (address) {
982     return _ownerOf(_encodeTokenId(x, y));
983   }
984 
985   function ownerOfLandMany(int[] x, int[] y) external view returns (address[]) {
986     require(x.length > 0, "You should supply at least one coordinate");
987     require(x.length == y.length, "The coordinates should have the same length");
988 
989     address[] memory addrs = new address[](x.length);
990     for (uint i = 0; i < x.length; i++) {
991       addrs[i] = _ownerOfLand(x[i], y[i]);
992     }
993 
994     return addrs;
995   }
996 
997   function landOf(address owner) external view returns (int[], int[]) {
998     uint256 len = _assetsOf[owner].length;
999     int[] memory x = new int[](len);
1000     int[] memory y = new int[](len);
1001 
1002     int assetX;
1003     int assetY;
1004     for (uint i = 0; i < len; i++) {
1005       (assetX, assetY) = _decodeTokenId(_assetsOf[owner][i]);
1006       x[i] = assetX;
1007       y[i] = assetY;
1008     }
1009 
1010     return (x, y);
1011   }
1012 
1013   function tokenMetadata(uint256 assetId) external view returns (string) {
1014     return _tokenMetadata(assetId);
1015   }
1016 
1017   function _tokenMetadata(uint256 assetId) internal view returns (string) {
1018     address _owner = _ownerOf(assetId);
1019     if (_isContract(_owner) && _owner != address(estateRegistry)) {
1020       if ((ERC165(_owner)).supportsInterface(GET_METADATA)) {
1021         return IMetadataHolder(_owner).getMetadata(assetId);
1022       }
1023     }
1024     return _assetData[assetId];
1025   }
1026 
1027   function landData(int x, int y) external view returns (string) {
1028     return _tokenMetadata(_encodeTokenId(x, y));
1029   }
1030 
1031   //
1032   // LAND Transfer
1033   //
1034 
1035   function transferFrom(address from, address to, uint256 assetId) external {
1036     require(to != address(estateRegistry), "EstateRegistry unsafe transfers are not allowed");
1037     return _doTransferFrom(
1038       from,
1039       to,
1040       assetId,
1041       "",
1042       false
1043     );
1044   }
1045 
1046 
1047   function transferLand(int x, int y, address to) external {
1048     uint256 tokenId = _encodeTokenId(x, y);
1049     _doTransferFrom(
1050       _ownerOf(tokenId),
1051       to,
1052       tokenId,
1053       "",
1054       true
1055     );
1056   }
1057 
1058   function transferManyLand(int[] x, int[] y, address to) external {
1059     require(x.length > 0, "You should supply at least one coordinate");
1060     require(x.length == y.length, "The coordinates should have the same length");
1061 
1062     for (uint i = 0; i < x.length; i++) {
1063       uint256 tokenId = _encodeTokenId(x[i], y[i]);
1064       _doTransferFrom(
1065         _ownerOf(tokenId),
1066         to,
1067         tokenId,
1068         "",
1069         true
1070       );
1071     }
1072   }
1073 
1074   function transferLandToEstate(int x, int y, uint256 estateId) external {
1075     uint256 tokenId = _encodeTokenId(x, y);
1076     _doTransferFrom(
1077       _ownerOf(tokenId),
1078       address(estateRegistry),
1079       tokenId,
1080       toBytes(estateId),
1081       true
1082     );
1083   }
1084 
1085   function transferManyLandToEstate(int[] x, int[] y, uint256 estateId) external {
1086     require(x.length > 0, "You should supply at least one coordinate");
1087     require(x.length == y.length, "The coordinates should have the same length");
1088 
1089     for (uint i = 0; i < x.length; i++) {
1090       uint256 tokenId = _encodeTokenId(x[i], y[i]);
1091       _doTransferFrom(
1092         _ownerOf(tokenId),
1093         address(estateRegistry),
1094         tokenId,
1095         toBytes(estateId),
1096         true
1097       );
1098     }
1099   }
1100 
1101   function setUpdateOperator(uint256 assetId, address operator) external onlyOwnerOf(assetId) {
1102     updateOperator[assetId] = operator;
1103     emit UpdateOperator(assetId, operator);
1104   }
1105 
1106   //
1107   // Estate generation
1108   //
1109 
1110   event EstateRegistrySet(address indexed registry);
1111 
1112   function setEstateRegistry(address registry) external onlyProxyOwner {
1113     estateRegistry = IEstateRegistry(registry);
1114     emit EstateRegistrySet(registry);
1115   }
1116 
1117   function createEstate(int[] x, int[] y, address beneficiary) external returns (uint256) {
1118     // solium-disable-next-line arg-overflow
1119     return _createEstate(x, y, beneficiary, "");
1120   }
1121 
1122   function createEstateWithMetadata(
1123     int[] x,
1124     int[] y,
1125     address beneficiary,
1126     string metadata
1127   )
1128     external
1129     returns (uint256)
1130   {
1131     // solium-disable-next-line arg-overflow
1132     return _createEstate(x, y, beneficiary, metadata);
1133   }
1134 
1135   function _createEstate(
1136     int[] x,
1137     int[] y,
1138     address beneficiary,
1139     string metadata
1140   )
1141     internal
1142     returns (uint256)
1143   {
1144     require(x.length > 0, "You should supply at least one coordinate");
1145     require(x.length == y.length, "The coordinates should have the same length");
1146     require(address(estateRegistry) != 0, "The Estate registry should be set");
1147 
1148     uint256 estateTokenId = estateRegistry.mint(beneficiary, metadata);
1149     bytes memory estateTokenIdBytes = toBytes(estateTokenId);
1150 
1151     for (uint i = 0; i < x.length; i++) {
1152       uint256 tokenId = _encodeTokenId(x[i], y[i]);
1153       _doTransferFrom(
1154         _ownerOf(tokenId),
1155         address(estateRegistry),
1156         tokenId,
1157         estateTokenIdBytes,
1158         true
1159       );
1160     }
1161 
1162     return estateTokenId;
1163   }
1164 
1165   function toBytes(uint256 x) internal pure returns (bytes b) {
1166     b = new bytes(32);
1167     // solium-disable-next-line security/no-inline-assembly
1168     assembly { mstore(add(b, 32), x) }
1169   }
1170 
1171   //
1172   // LAND Update
1173   //
1174 
1175   function updateLandData(
1176     int x,
1177     int y,
1178     string data
1179   )
1180     external
1181     onlyUpdateAuthorized(_encodeTokenId(x, y))
1182   {
1183     return _updateLandData(x, y, data);
1184   }
1185 
1186   function _updateLandData(
1187     int x,
1188     int y,
1189     string data
1190   )
1191     internal
1192     onlyUpdateAuthorized(_encodeTokenId(x, y))
1193   {
1194     uint256 assetId = _encodeTokenId(x, y);
1195     address owner = _holderOf[assetId];
1196 
1197     _update(assetId, data);
1198 
1199     emit Update(
1200       assetId,
1201       owner,
1202       msg.sender,
1203       data
1204     );
1205   }
1206 
1207   function updateManyLandData(int[] x, int[] y, string data) external {
1208     require(x.length > 0, "You should supply at least one coordinate");
1209     require(x.length == y.length, "The coordinates should have the same length");
1210     for (uint i = 0; i < x.length; i++) {
1211       _updateLandData(x[i], y[i], data);
1212     }
1213   }
1214 
1215   function _doTransferFrom(
1216     address from,
1217     address to,
1218     uint256 assetId,
1219     bytes userData,
1220     bool doCheck
1221   )
1222     internal
1223   {
1224     updateOperator[assetId] = address(0);
1225 
1226     super._doTransferFrom(
1227       from,
1228       to,
1229       assetId,
1230       userData,
1231       doCheck
1232     );
1233   }
1234 
1235   function _isContract(address addr) internal view returns (bool) {
1236     uint size;
1237     // solium-disable-next-line security/no-inline-assembly
1238     assembly { size := extcodesize(addr) }
1239     return size > 0;
1240   }
1241 }