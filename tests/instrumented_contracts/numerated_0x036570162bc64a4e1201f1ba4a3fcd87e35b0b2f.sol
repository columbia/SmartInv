1 pragma solidity ^0.4.24;
2 
3 // File: contracts/upgradable/ProxyStorage.sol
4 
5 contract ProxyStorage {
6 
7   /**
8    * Current contract to which we are proxing
9    */
10   address public currentContract;
11   address public proxyOwner;
12 }
13 
14 // File: contracts/upgradable/OwnableStorage.sol
15 
16 contract OwnableStorage {
17 
18   address public owner;
19 
20   constructor() internal {
21     owner = msg.sender;
22   }
23 
24 }
25 
26 // File: erc821/contracts/AssetRegistryStorage.sol
27 
28 contract AssetRegistryStorage {
29 
30   string internal _name;
31   string internal _symbol;
32   string internal _description;
33 
34   /**
35    * Stores the total count of assets managed by this registry
36    */
37   uint256 internal _count;
38 
39   /**
40    * Stores an array of assets owned by a given account
41    */
42   mapping(address => uint256[]) internal _assetsOf;
43 
44   /**
45    * Stores the current holder of an asset
46    */
47   mapping(uint256 => address) internal _holderOf;
48 
49   /**
50    * Stores the index of an asset in the `_assetsOf` array of its holder
51    */
52   mapping(uint256 => uint256) internal _indexOfAsset;
53 
54   /**
55    * Stores the data associated with an asset
56    */
57   mapping(uint256 => string) internal _assetData;
58 
59   /**
60    * For a given account, for a given operator, store whether that operator is
61    * allowed to transfer and modify assets on behalf of them.
62    */
63   mapping(address => mapping(address => bool)) internal _operators;
64 
65   /**
66    * Approval array
67    */
68   mapping(uint256 => address) internal _approval;
69 }
70 
71 // File: contracts/estate/IEstateRegistry.sol
72 
73 contract IEstateRegistry {
74   function mint(address to, string metadata) external returns (uint256);
75   function ownerOf(uint256 _tokenId) public view returns (address _owner); // from ERC721
76 
77   // Events
78 
79   event CreateEstate(
80     address indexed _owner,
81     uint256 indexed _estateId,
82     string _data
83   );
84 
85   event AddLand(
86     uint256 indexed _estateId,
87     uint256 indexed _landId
88   );
89 
90   event RemoveLand(
91     uint256 indexed _estateId,
92     uint256 indexed _landId,
93     address indexed _destinatary
94   );
95 
96   event Update(
97     uint256 indexed _assetId,
98     address indexed _holder,
99     address indexed _operator,
100     string _data
101   );
102 
103   event UpdateOperator(
104     uint256 indexed _estateId,
105     address indexed _operator
106   );
107 
108   event SetLANDRegistry(
109     address indexed _registry
110   );
111 }
112 
113 // File: contracts/land/LANDStorage.sol
114 
115 contract LANDStorage {
116   mapping (address => uint) public latestPing;
117 
118   uint256 constant clearLow = 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;
119   uint256 constant clearHigh = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
120   uint256 constant factor = 0x100000000000000000000000000000000;
121 
122   mapping (address => bool) internal _deprecated_authorizedDeploy;
123 
124   mapping (uint256 => address) public updateOperator;
125 
126   IEstateRegistry public estateRegistry;
127 
128   mapping (address => bool) public authorizedDeploy;
129 }
130 
131 // File: contracts/Storage.sol
132 
133 contract Storage is ProxyStorage, OwnableStorage, AssetRegistryStorage, LANDStorage {
134 }
135 
136 // File: contracts/upgradable/Ownable.sol
137 
138 contract Ownable is Storage {
139 
140   event OwnerUpdate(address _prevOwner, address _newOwner);
141 
142   modifier onlyOwner {
143     assert(msg.sender == owner);
144     _;
145   }
146 
147   function transferOwnership(address _newOwner) public onlyOwner {
148     require(_newOwner != owner, "Cannot transfer to yourself");
149     owner = _newOwner;
150   }
151 }
152 
153 // File: contracts/upgradable/IApplication.sol
154 
155 contract IApplication {
156   function initialize(bytes data) public;
157 }
158 
159 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
160 
161 /**
162  * @title SafeMath
163  * @dev Math operations with safety checks that throw on error
164  */
165 library SafeMath {
166 
167   /**
168   * @dev Multiplies two numbers, throws on overflow.
169   */
170   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
171     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
172     // benefit is lost if 'b' is also tested.
173     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
174     if (_a == 0) {
175       return 0;
176     }
177 
178     c = _a * _b;
179     assert(c / _a == _b);
180     return c;
181   }
182 
183   /**
184   * @dev Integer division of two numbers, truncating the quotient.
185   */
186   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
187     // assert(_b > 0); // Solidity automatically throws when dividing by 0
188     // uint256 c = _a / _b;
189     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
190     return _a / _b;
191   }
192 
193   /**
194   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
195   */
196   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
197     assert(_b <= _a);
198     return _a - _b;
199   }
200 
201   /**
202   * @dev Adds two numbers, throws on overflow.
203   */
204   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
205     c = _a + _b;
206     assert(c >= _a);
207     return c;
208   }
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
230   function isApprovedForAll(address assetHolder, address operator) external view returns (bool);
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
273 // File: erc821/contracts/ERC165.sol
274 
275 interface ERC165 {
276   function supportsInterface(bytes4 interfaceID) external view returns (bool);
277 }
278 
279 // File: erc821/contracts/ERC721Base.sol
280 
281 contract ERC721Base is AssetRegistryStorage, IERC721Base, ERC165 {
282   using SafeMath for uint256;
283 
284   // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
285   bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
286 
287   bytes4 private constant InterfaceId_ERC165 = 0x01ffc9a7;
288   /*
289    * 0x01ffc9a7 ===
290    *   bytes4(keccak256('supportsInterface(bytes4)'))
291    */
292 
293   bytes4 private constant Old_InterfaceId_ERC721 = 0x7c0633c6;
294   bytes4 private constant InterfaceId_ERC721 = 0x80ac58cd;
295    /*
296    * 0x80ac58cd ===
297    *   bytes4(keccak256('balanceOf(address)')) ^
298    *   bytes4(keccak256('ownerOf(uint256)')) ^
299    *   bytes4(keccak256('approve(address,uint256)')) ^
300    *   bytes4(keccak256('getApproved(uint256)')) ^
301    *   bytes4(keccak256('setApprovalForAll(address,bool)')) ^
302    *   bytes4(keccak256('isApprovedForAll(address,address)')) ^
303    *   bytes4(keccak256('transferFrom(address,address,uint256)')) ^
304    *   bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
305    *   bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
306    */
307 
308   //
309   // Global Getters
310   //
311 
312   /**
313    * @dev Gets the total amount of assets stored by the contract
314    * @return uint256 representing the total amount of assets
315    */
316   function totalSupply() external view returns (uint256) {
317     return _totalSupply();
318   }
319   function _totalSupply() internal view returns (uint256) {
320     return _count;
321   }
322 
323   //
324   // Asset-centric getter functions
325   //
326 
327   /**
328    * @dev Queries what address owns an asset. This method does not throw.
329    * In order to check if the asset exists, use the `exists` function or check if the
330    * return value of this call is `0`.
331    * @return uint256 the assetId
332    */
333   function ownerOf(uint256 assetId) external view returns (address) {
334     return _ownerOf(assetId);
335   }
336   function _ownerOf(uint256 assetId) internal view returns (address) {
337     return _holderOf[assetId];
338   }
339 
340   //
341   // Holder-centric getter functions
342   //
343   /**
344    * @dev Gets the balance of the specified address
345    * @param owner address to query the balance of
346    * @return uint256 representing the amount owned by the passed address
347    */
348   function balanceOf(address owner) external view returns (uint256) {
349     return _balanceOf(owner);
350   }
351   function _balanceOf(address owner) internal view returns (uint256) {
352     return _assetsOf[owner].length;
353   }
354 
355   //
356   // Authorization getters
357   //
358 
359   /**
360    * @dev Query whether an address has been authorized to move any assets on behalf of someone else
361    * @param operator the address that might be authorized
362    * @param assetHolder the address that provided the authorization
363    * @return bool true if the operator has been authorized to move any assets
364    */
365   function isApprovedForAll(address assetHolder, address operator)
366     external view returns (bool)
367   {
368     return _isApprovedForAll(assetHolder, operator);
369   }
370   function _isApprovedForAll(address assetHolder, address operator)
371     internal view returns (bool)
372   {
373     return _operators[assetHolder][operator];
374   }
375 
376   /**
377    * @dev Query what address has been particularly authorized to move an asset
378    * @param assetId the asset to be queried for
379    * @return bool true if the asset has been approved by the holder
380    */
381   function getApproved(uint256 assetId) external view returns (address) {
382     return _getApprovedAddress(assetId);
383   }
384   function getApprovedAddress(uint256 assetId) external view returns (address) {
385     return _getApprovedAddress(assetId);
386   }
387   function _getApprovedAddress(uint256 assetId) internal view returns (address) {
388     return _approval[assetId];
389   }
390 
391   /**
392    * @dev Query if an operator can move an asset.
393    * @param operator the address that might be authorized
394    * @param assetId the asset that has been `approved` for transfer
395    * @return bool true if the asset has been approved by the holder
396    */
397   function isAuthorized(address operator, uint256 assetId) external view returns (bool) {
398     return _isAuthorized(operator, assetId);
399   }
400   function _isAuthorized(address operator, uint256 assetId) internal view returns (bool)
401   {
402     require(operator != 0);
403     address owner = _ownerOf(assetId);
404     if (operator == owner) {
405       return true;
406     }
407     return _isApprovedForAll(owner, operator) || _getApprovedAddress(assetId) == operator;
408   }
409 
410   //
411   // Authorization
412   //
413 
414   /**
415    * @dev Authorize a third party operator to manage (send) msg.sender's asset
416    * @param operator address to be approved
417    * @param authorized bool set to true to authorize, false to withdraw authorization
418    */
419   function setApprovalForAll(address operator, bool authorized) external {
420     return _setApprovalForAll(operator, authorized);
421   }
422   function _setApprovalForAll(address operator, bool authorized) internal {
423     if (authorized) {
424       require(!_isApprovedForAll(msg.sender, operator));
425       _addAuthorization(operator, msg.sender);
426     } else {
427       require(_isApprovedForAll(msg.sender, operator));
428       _clearAuthorization(operator, msg.sender);
429     }
430     emit ApprovalForAll(msg.sender, operator, authorized);
431   }
432 
433   /**
434    * @dev Authorize a third party operator to manage one particular asset
435    * @param operator address to be approved
436    * @param assetId asset to approve
437    */
438   function approve(address operator, uint256 assetId) external {
439     address holder = _ownerOf(assetId);
440     require(msg.sender == holder || _isApprovedForAll(msg.sender, holder));
441     require(operator != holder);
442 
443     if (_getApprovedAddress(assetId) != operator) {
444       _approval[assetId] = operator;
445       emit Approval(holder, operator, assetId);
446     }
447   }
448 
449   function _addAuthorization(address operator, address holder) private {
450     _operators[holder][operator] = true;
451   }
452 
453   function _clearAuthorization(address operator, address holder) private {
454     _operators[holder][operator] = false;
455   }
456 
457   //
458   // Internal Operations
459   //
460 
461   function _addAssetTo(address to, uint256 assetId) internal {
462     _holderOf[assetId] = to;
463 
464     uint256 length = _balanceOf(to);
465 
466     _assetsOf[to].push(assetId);
467 
468     _indexOfAsset[assetId] = length;
469 
470     _count = _count.add(1);
471   }
472 
473   function _removeAssetFrom(address from, uint256 assetId) internal {
474     uint256 assetIndex = _indexOfAsset[assetId];
475     uint256 lastAssetIndex = _balanceOf(from).sub(1);
476     uint256 lastAssetId = _assetsOf[from][lastAssetIndex];
477 
478     _holderOf[assetId] = 0;
479 
480     // Insert the last asset into the position previously occupied by the asset to be removed
481     _assetsOf[from][assetIndex] = lastAssetId;
482 
483     // Resize the array
484     _assetsOf[from][lastAssetIndex] = 0;
485     _assetsOf[from].length--;
486 
487     // Remove the array if no more assets are owned to prevent pollution
488     if (_assetsOf[from].length == 0) {
489       delete _assetsOf[from];
490     }
491 
492     // Update the index of positions for the asset
493     _indexOfAsset[assetId] = 0;
494     _indexOfAsset[lastAssetId] = assetIndex;
495 
496     _count = _count.sub(1);
497   }
498 
499   function _clearApproval(address holder, uint256 assetId) internal {
500     if (_ownerOf(assetId) == holder && _approval[assetId] != 0) {
501       _approval[assetId] = 0;
502       emit Approval(holder, 0, assetId);
503     }
504   }
505 
506   //
507   // Supply-altering functions
508   //
509 
510   function _generate(uint256 assetId, address beneficiary) internal {
511     require(_holderOf[assetId] == 0);
512 
513     _addAssetTo(beneficiary, assetId);
514 
515     emit Transfer(0, beneficiary, assetId);
516   }
517 
518   function _destroy(uint256 assetId) internal {
519     address holder = _holderOf[assetId];
520     require(holder != 0);
521 
522     _removeAssetFrom(holder, assetId);
523 
524     emit Transfer(holder, 0, assetId);
525   }
526 
527   //
528   // Transaction related operations
529   //
530 
531   modifier onlyHolder(uint256 assetId) {
532     require(_ownerOf(assetId) == msg.sender);
533     _;
534   }
535 
536   modifier onlyAuthorized(uint256 assetId) {
537     require(_isAuthorized(msg.sender, assetId));
538     _;
539   }
540 
541   modifier isCurrentOwner(address from, uint256 assetId) {
542     require(_ownerOf(assetId) == from);
543     _;
544   }
545 
546   modifier isDestinataryDefined(address destinatary) {
547     require(destinatary != 0);
548     _;
549   }
550 
551   modifier destinataryIsNotHolder(uint256 assetId, address to) {
552     require(_ownerOf(assetId) != to);
553     _;
554   }
555 
556   /**
557    * @dev Alias of `safeTransferFrom(from, to, assetId, '')`
558    *
559    * @param from address that currently owns an asset
560    * @param to address to receive the ownership of the asset
561    * @param assetId uint256 ID of the asset to be transferred
562    */
563   function safeTransferFrom(address from, address to, uint256 assetId) external {
564     return _doTransferFrom(from, to, assetId, '', true);
565   }
566 
567   /**
568    * @dev Securely transfers the ownership of a given asset from one address to
569    * another address, calling the method `onNFTReceived` on the target address if
570    * there's code associated with it
571    *
572    * @param from address that currently owns an asset
573    * @param to address to receive the ownership of the asset
574    * @param assetId uint256 ID of the asset to be transferred
575    * @param userData bytes arbitrary user information to attach to this transfer
576    */
577   function safeTransferFrom(address from, address to, uint256 assetId, bytes userData) external {
578     return _doTransferFrom(from, to, assetId, userData, true);
579   }
580 
581   /**
582    * @dev Transfers the ownership of a given asset from one address to another address
583    * Warning! This function does not attempt to verify that the target address can send
584    * tokens.
585    *
586    * @param from address sending the asset
587    * @param to address to receive the ownership of the asset
588    * @param assetId uint256 ID of the asset to be transferred
589    */
590   function transferFrom(address from, address to, uint256 assetId) external {
591     return _doTransferFrom(from, to, assetId, '', false);
592   }
593 
594   function _doTransferFrom(
595     address from,
596     address to,
597     uint256 assetId,
598     bytes userData,
599     bool doCheck
600   )
601     onlyAuthorized(assetId)
602     internal
603   {
604     _moveToken(from, to, assetId, userData, doCheck);
605   }
606 
607   function _moveToken(
608     address from,
609     address to,
610     uint256 assetId,
611     bytes userData,
612     bool doCheck
613   )
614     isDestinataryDefined(to)
615     destinataryIsNotHolder(assetId, to)
616     isCurrentOwner(from, assetId)
617     internal
618   {
619     address holder = _holderOf[assetId];
620     _removeAssetFrom(holder, assetId);
621     _clearApproval(holder, assetId);
622     _addAssetTo(to, assetId);
623 
624     if (doCheck && _isContract(to)) {
625       // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))
626       require(
627         IERC721Receiver(to).onERC721Received(
628           msg.sender, holder, assetId, userData
629         ) == ERC721_RECEIVED
630       );
631     }
632 
633     emit Transfer(holder, to, assetId);
634   }
635 
636   /**
637    * Internal function that moves an asset from one holder to another
638    */
639 
640   /**
641    * @dev Returns `true` if the contract implements `interfaceID` and `interfaceID` is not 0xffffffff, `false` otherwise
642    * @param  _interfaceID The interface identifier, as specified in ERC-165
643    */
644   function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
645 
646     if (_interfaceID == 0xffffffff) {
647       return false;
648     }
649     return _interfaceID == InterfaceId_ERC165 || _interfaceID == Old_InterfaceId_ERC721 || _interfaceID == InterfaceId_ERC721;
650   }
651 
652   //
653   // Utilities
654   //
655 
656   function _isContract(address addr) internal view returns (bool) {
657     uint size;
658     assembly { size := extcodesize(addr) }
659     return size > 0;
660   }
661 }
662 
663 // File: erc821/contracts/IERC721Enumerable.sol
664 
665 contract IERC721Enumerable {
666 
667   /**
668    * @notice Enumerate active tokens
669    * @dev Throws if `index` >= `totalSupply()`, otherwise SHALL NOT throw.
670    * @param index A counter less than `totalSupply()`
671    * @return The identifier for the `index`th asset, (sort order not
672    *  specified)
673    */
674   // TODO (eordano): Not implemented
675   // function tokenByIndex(uint256 index) public view returns (uint256 _assetId);
676 
677   /**
678    * @notice Count of owners which own at least one asset
679    *  Must not throw.
680    * @return A count of the number of owners which own asset
681    */
682   // TODO (eordano): Not implemented
683   // function countOfOwners() public view returns (uint256 _count);
684 
685   /**
686    * @notice Enumerate owners
687    * @dev Throws if `index` >= `countOfOwners()`, otherwise must not throw.
688    * @param index A counter less than `countOfOwners()`
689    * @return The address of the `index`th owner (sort order not specified)
690    */
691   // TODO (eordano): Not implemented
692   // function ownerByIndex(uint256 index) public view returns (address owner);
693 
694   /**
695    * @notice Get all tokens of a given address
696    * @dev This is not intended to be used on-chain
697    * @param owner address of the owner to query
698    * @return a list of all assetIds of a user
699    */
700   function tokensOf(address owner) external view returns (uint256[]);
701 
702   /**
703    * @notice Enumerate tokens assigned to an owner
704    * @dev Throws if `index` >= `balanceOf(owner)` or if
705    *  `owner` is the zero address, representing invalid assets.
706    *  Otherwise this must not throw.
707    * @param owner An address where we are interested in assets owned by them
708    * @param index A counter less than `balanceOf(owner)`
709    * @return The identifier for the `index`th asset assigned to `owner`,
710    *   (sort order not specified)
711    */
712   function tokenOfOwnerByIndex(
713     address owner, uint256 index
714   ) external view returns (uint256 tokenId);
715 }
716 
717 // File: erc821/contracts/ERC721Enumerable.sol
718 
719 contract ERC721Enumerable is AssetRegistryStorage, IERC721Enumerable {
720 
721   /**
722    * @notice Get all tokens of a given address
723    * @dev This is not intended to be used on-chain
724    * @param owner address of the owner to query
725    * @return a list of all assetIds of a user
726    */
727   function tokensOf(address owner) external view returns (uint256[]) {
728     return _assetsOf[owner];
729   }
730 
731   /**
732    * @notice Enumerate tokens assigned to an owner
733    * @dev Throws if `index` >= `balanceOf(owner)` or if
734    *  `owner` is the zero address, representing invalid assets.
735    *  Otherwise this must not throw.
736    * @param owner An address where we are interested in assets owned by them
737    * @param index A counter less than `balanceOf(owner)`
738    * @return The identifier for the `index`th asset assigned to `owner`,
739    *   (sort order not specified)
740    */
741   function tokenOfOwnerByIndex(
742     address owner, uint256 index
743   )
744     external
745     view
746     returns (uint256 assetId)
747   {
748     require(index < _assetsOf[owner].length);
749     require(index < (1<<127));
750     return _assetsOf[owner][index];
751   }
752 
753 }
754 
755 // File: erc821/contracts/IERC721Metadata.sol
756 
757 contract IERC721Metadata {
758 
759   /**
760    * @notice A descriptive name for a collection of NFTs in this contract
761    */
762   function name() external view returns (string);
763 
764   /**
765    * @notice An abbreviated name for NFTs in this contract
766    */
767   function symbol() external view returns (string);
768 
769   /**
770    * @notice A description of what this DAR is used for
771    */
772   function description() external view returns (string);
773 
774   /**
775    * Stores arbitrary info about a token
776    */
777   function tokenMetadata(uint256 assetId) external view returns (string);
778 }
779 
780 // File: erc821/contracts/ERC721Metadata.sol
781 
782 contract ERC721Metadata is AssetRegistryStorage, IERC721Metadata {
783   function name() external view returns (string) {
784     return _name;
785   }
786   function symbol() external view returns (string) {
787     return _symbol;
788   }
789   function description() external view returns (string) {
790     return _description;
791   }
792   function tokenMetadata(uint256 assetId) external view returns (string) {
793     return _assetData[assetId];
794   }
795   function _update(uint256 assetId, string data) internal {
796     _assetData[assetId] = data;
797   }
798 }
799 
800 // File: erc821/contracts/FullAssetRegistry.sol
801 
802 contract FullAssetRegistry is ERC721Base, ERC721Enumerable, ERC721Metadata {
803   constructor() public {
804   }
805 
806   /**
807    * @dev Method to check if an asset identified by the given id exists under this DAR.
808    * @return uint256 the assetId
809    */
810   function exists(uint256 assetId) external view returns (bool) {
811     return _exists(assetId);
812   }
813   function _exists(uint256 assetId) internal view returns (bool) {
814     return _holderOf[assetId] != 0;
815   }
816 
817   function decimals() external pure returns (uint256) {
818     return 0;
819   }
820 }
821 
822 // File: contracts/land/ILANDRegistry.sol
823 
824 interface ILANDRegistry {
825 
826   // LAND can be assigned by the owner
827   function assignNewParcel(int x, int y, address beneficiary) external;
828   function assignMultipleParcels(int[] x, int[] y, address beneficiary) external;
829 
830   // After one year, LAND can be claimed from an inactive public key
831   function ping() external;
832 
833   // LAND-centric getters
834   function encodeTokenId(int x, int y) external pure returns (uint256);
835   function decodeTokenId(uint value) external pure returns (int, int);
836   function exists(int x, int y) external view returns (bool);
837   function ownerOfLand(int x, int y) external view returns (address);
838   function ownerOfLandMany(int[] x, int[] y) external view returns (address[]);
839   function landOf(address owner) external view returns (int[], int[]);
840   function landData(int x, int y) external view returns (string);
841 
842   // Transfer LAND
843   function transferLand(int x, int y, address to) external;
844   function transferManyLand(int[] x, int[] y, address to) external;
845 
846   // Update LAND
847   function updateLandData(int x, int y, string data) external;
848   function updateManyLandData(int[] x, int[] y, string data) external;
849 
850   // Events
851 
852   event Update(
853     uint256 indexed assetId,
854     address indexed holder,
855     address indexed operator,
856     string data
857   );
858 
859   event UpdateOperator(
860     uint256 indexed assetId,
861     address indexed operator
862   );
863 
864   event DeployAuthorized(
865     address indexed _caller,
866     address indexed _deployer
867   );
868 
869   event DeployForbidden(
870     address indexed _caller,
871     address indexed _deployer
872   );
873 }
874 
875 // File: contracts/metadata/IMetadataHolder.sol
876 
877 contract IMetadataHolder is ERC165 {
878   function getMetadata(uint256 /* assetId */) external view returns (string);
879 }
880 
881 // File: contracts/land/LANDRegistry.sol
882 
883 /* solium-disable function-order */
884 contract LANDRegistry is Storage, Ownable, FullAssetRegistry, ILANDRegistry {
885   bytes4 constant public GET_METADATA = bytes4(keccak256("getMetadata(uint256)"));
886 
887   function initialize(bytes) external {
888     _name = "Decentraland LAND";
889     _symbol = "LAND";
890     _description = "Contract that stores the Decentraland LAND registry";
891   }
892 
893   modifier onlyProxyOwner() {
894     require(msg.sender == proxyOwner, "This function can only be called by the proxy owner");
895     _;
896   }
897 
898   modifier onlyDeployer() {
899     require(msg.sender == proxyOwner || authorizedDeploy[msg.sender], "This function can only be called by an authorized deployer");
900     _;
901   }
902 
903   modifier onlyOwnerOf(uint256 assetId) {
904     require(
905       msg.sender == _ownerOf(assetId),
906       "This function can only be called by the owner of the asset"
907     );
908     _;
909   }
910 
911   modifier onlyUpdateAuthorized(uint256 tokenId) {
912     require(
913       msg.sender == _ownerOf(tokenId) || _isUpdateAuthorized(msg.sender, tokenId),
914       "msg.sender is not authorized to update"
915     );
916     _;
917   }
918 
919   //
920   // Authorization
921   //
922 
923   function isUpdateAuthorized(address operator, uint256 assetId) external view returns (bool) {
924     return _isUpdateAuthorized(operator, assetId);
925   }
926 
927   function _isUpdateAuthorized(address operator, uint256 assetId) internal view returns (bool) {
928     return operator == _ownerOf(assetId) || updateOperator[assetId] == operator;
929   }
930 
931   function authorizeDeploy(address beneficiary) external {
932     require(beneficiary != address(0), "invalid address");
933     require(authorizedDeploy[beneficiary] == false, "address is already authorized");
934 
935     authorizedDeploy[beneficiary] = true;
936     emit DeployAuthorized(msg.sender, beneficiary);
937   }
938 
939   function forbidDeploy(address beneficiary) external onlyProxyOwner {
940     require(beneficiary != address(0), "invalid address");
941     require(authorizedDeploy[beneficiary], "address is already forbidden");
942     
943     authorizedDeploy[beneficiary] = false;
944     emit DeployForbidden(msg.sender, beneficiary);
945   }
946 
947   //
948   // LAND Create
949   //
950 
951   function assignNewParcel(int x, int y, address beneficiary) external onlyDeployer {
952     _generate(_encodeTokenId(x, y), beneficiary);
953   }
954 
955   function assignMultipleParcels(int[] x, int[] y, address beneficiary) external onlyDeployer {
956     for (uint i = 0; i < x.length; i++) {
957       _generate(_encodeTokenId(x[i], y[i]), beneficiary);
958     }
959   }
960 
961   //
962   // Inactive keys after 1 year lose ownership
963   //
964 
965   function ping() external {
966     // solium-disable-next-line security/no-block-members
967     latestPing[msg.sender] = block.timestamp;
968   }
969 
970   function setLatestToNow(address user) external {
971     require(msg.sender == proxyOwner || _isApprovedForAll(msg.sender, user), "Unauthorized user");
972     // solium-disable-next-line security/no-block-members
973     latestPing[user] = block.timestamp;
974   }
975 
976   //
977   // LAND Getters
978   //
979 
980   function encodeTokenId(int x, int y) external pure returns (uint) {
981     return _encodeTokenId(x, y);
982   }
983 
984   function _encodeTokenId(int x, int y) internal pure returns (uint result) {
985     require(
986       -1000000 < x && x < 1000000 && -1000000 < y && y < 1000000,
987       "The coordinates should be inside bounds"
988     );
989     return _unsafeEncodeTokenId(x, y);
990   }
991 
992   function _unsafeEncodeTokenId(int x, int y) internal pure returns (uint) {
993     return ((uint(x) * factor) & clearLow) | (uint(y) & clearHigh);
994   }
995 
996   function decodeTokenId(uint value) external pure returns (int, int) {
997     return _decodeTokenId(value);
998   }
999 
1000   function _unsafeDecodeTokenId(uint value) internal pure returns (int x, int y) {
1001     x = expandNegative128BitCast((value & clearLow) >> 128);
1002     y = expandNegative128BitCast(value & clearHigh);
1003   }
1004 
1005   function _decodeTokenId(uint value) internal pure returns (int x, int y) {
1006     (x, y) = _unsafeDecodeTokenId(value);
1007     require(
1008       -1000000 < x && x < 1000000 && -1000000 < y && y < 1000000,
1009       "The coordinates should be inside bounds"
1010     );
1011   }
1012 
1013   function expandNegative128BitCast(uint value) internal pure returns (int) {
1014     if (value & (1<<127) != 0) {
1015       return int(value | clearLow);
1016     }
1017     return int(value);
1018   }
1019 
1020   function exists(int x, int y) external view returns (bool) {
1021     return _exists(x, y);
1022   }
1023 
1024   function _exists(int x, int y) internal view returns (bool) {
1025     return _exists(_encodeTokenId(x, y));
1026   }
1027 
1028   function ownerOfLand(int x, int y) external view returns (address) {
1029     return _ownerOfLand(x, y);
1030   }
1031 
1032   function _ownerOfLand(int x, int y) internal view returns (address) {
1033     return _ownerOf(_encodeTokenId(x, y));
1034   }
1035 
1036   function ownerOfLandMany(int[] x, int[] y) external view returns (address[]) {
1037     require(x.length > 0, "You should supply at least one coordinate");
1038     require(x.length == y.length, "The coordinates should have the same length");
1039 
1040     address[] memory addrs = new address[](x.length);
1041     for (uint i = 0; i < x.length; i++) {
1042       addrs[i] = _ownerOfLand(x[i], y[i]);
1043     }
1044 
1045     return addrs;
1046   }
1047 
1048   function landOf(address owner) external view returns (int[], int[]) {
1049     uint256 len = _assetsOf[owner].length;
1050     int[] memory x = new int[](len);
1051     int[] memory y = new int[](len);
1052 
1053     int assetX;
1054     int assetY;
1055     for (uint i = 0; i < len; i++) {
1056       (assetX, assetY) = _decodeTokenId(_assetsOf[owner][i]);
1057       x[i] = assetX;
1058       y[i] = assetY;
1059     }
1060 
1061     return (x, y);
1062   }
1063 
1064   function tokenMetadata(uint256 assetId) external view returns (string) {
1065     return _tokenMetadata(assetId);
1066   }
1067 
1068   function _tokenMetadata(uint256 assetId) internal view returns (string) {
1069     address _owner = _ownerOf(assetId);
1070     if (_isContract(_owner) && _owner != address(estateRegistry)) {
1071       if ((ERC165(_owner)).supportsInterface(GET_METADATA)) {
1072         return IMetadataHolder(_owner).getMetadata(assetId);
1073       }
1074     }
1075     return _assetData[assetId];
1076   }
1077 
1078   function landData(int x, int y) external view returns (string) {
1079     return _tokenMetadata(_encodeTokenId(x, y));
1080   }
1081 
1082   //
1083   // LAND Transfer
1084   //
1085 
1086   function transferFrom(address from, address to, uint256 assetId) external {
1087     require(to != address(estateRegistry), "EstateRegistry unsafe transfers are not allowed");
1088     return _doTransferFrom(
1089       from,
1090       to,
1091       assetId,
1092       "",
1093       false
1094     );
1095   }
1096 
1097   function transferLand(int x, int y, address to) external {
1098     uint256 tokenId = _encodeTokenId(x, y);
1099     _doTransferFrom(
1100       _ownerOf(tokenId),
1101       to,
1102       tokenId,
1103       "",
1104       true
1105     );
1106   }
1107 
1108   function transferManyLand(int[] x, int[] y, address to) external {
1109     require(x.length > 0, "You should supply at least one coordinate");
1110     require(x.length == y.length, "The coordinates should have the same length");
1111 
1112     for (uint i = 0; i < x.length; i++) {
1113       uint256 tokenId = _encodeTokenId(x[i], y[i]);
1114       _doTransferFrom(
1115         _ownerOf(tokenId),
1116         to,
1117         tokenId,
1118         "",
1119         true
1120       );
1121     }
1122   }
1123 
1124   function transferLandToEstate(int x, int y, uint256 estateId) external {
1125     require(
1126       estateRegistry.ownerOf(estateId) == msg.sender,
1127       "You must own the Estate you want to transfer to"
1128     );
1129 
1130     uint256 tokenId = _encodeTokenId(x, y);
1131     _doTransferFrom(
1132       _ownerOf(tokenId),
1133       address(estateRegistry),
1134       tokenId,
1135       toBytes(estateId),
1136       true
1137     );
1138   }
1139 
1140   function transferManyLandToEstate(int[] x, int[] y, uint256 estateId) external {
1141     require(x.length > 0, "You should supply at least one coordinate");
1142     require(x.length == y.length, "The coordinates should have the same length");
1143     require(
1144       estateRegistry.ownerOf(estateId) == msg.sender,
1145       "You must own the Estate you want to transfer to"
1146     );
1147 
1148     for (uint i = 0; i < x.length; i++) {
1149       uint256 tokenId = _encodeTokenId(x[i], y[i]);
1150       _doTransferFrom(
1151         _ownerOf(tokenId),
1152         address(estateRegistry),
1153         tokenId,
1154         toBytes(estateId),
1155         true
1156       );
1157     }
1158   }
1159 
1160   function setUpdateOperator(uint256 assetId, address operator) external onlyOwnerOf(assetId) {
1161     updateOperator[assetId] = operator;
1162     emit UpdateOperator(assetId, operator);
1163   }
1164 
1165   //
1166   // Estate generation
1167   //
1168 
1169   event EstateRegistrySet(address indexed registry);
1170 
1171   function setEstateRegistry(address registry) external onlyProxyOwner {
1172     estateRegistry = IEstateRegistry(registry);
1173     emit EstateRegistrySet(registry);
1174   }
1175 
1176   function createEstate(int[] x, int[] y, address beneficiary) external returns (uint256) {
1177     // solium-disable-next-line arg-overflow
1178     return _createEstate(x, y, beneficiary, "");
1179   }
1180 
1181   function createEstateWithMetadata(
1182     int[] x,
1183     int[] y,
1184     address beneficiary,
1185     string metadata
1186   )
1187     external
1188     returns (uint256)
1189   {
1190     // solium-disable-next-line arg-overflow
1191     return _createEstate(x, y, beneficiary, metadata);
1192   }
1193 
1194   function _createEstate(
1195     int[] x,
1196     int[] y,
1197     address beneficiary,
1198     string metadata
1199   )
1200     internal
1201     returns (uint256)
1202   {
1203     require(x.length > 0, "You should supply at least one coordinate");
1204     require(x.length == y.length, "The coordinates should have the same length");
1205     require(address(estateRegistry) != 0, "The Estate registry should be set");
1206 
1207     uint256 estateTokenId = estateRegistry.mint(beneficiary, metadata);
1208     bytes memory estateTokenIdBytes = toBytes(estateTokenId);
1209 
1210     for (uint i = 0; i < x.length; i++) {
1211       uint256 tokenId = _encodeTokenId(x[i], y[i]);
1212       _doTransferFrom(
1213         _ownerOf(tokenId),
1214         address(estateRegistry),
1215         tokenId,
1216         estateTokenIdBytes,
1217         true
1218       );
1219     }
1220 
1221     return estateTokenId;
1222   }
1223 
1224   function toBytes(uint256 x) internal pure returns (bytes b) {
1225     b = new bytes(32);
1226     // solium-disable-next-line security/no-inline-assembly
1227     assembly { mstore(add(b, 32), x) }
1228   }
1229 
1230   //
1231   // LAND Update
1232   //
1233 
1234   function updateLandData(
1235     int x,
1236     int y,
1237     string data
1238   )
1239     external
1240     onlyUpdateAuthorized(_encodeTokenId(x, y))
1241   {
1242     return _updateLandData(x, y, data);
1243   }
1244 
1245   function _updateLandData(
1246     int x,
1247     int y,
1248     string data
1249   )
1250     internal
1251     onlyUpdateAuthorized(_encodeTokenId(x, y))
1252   {
1253     uint256 assetId = _encodeTokenId(x, y);
1254     address owner = _holderOf[assetId];
1255 
1256     _update(assetId, data);
1257 
1258     emit Update(
1259       assetId,
1260       owner,
1261       msg.sender,
1262       data
1263     );
1264   }
1265 
1266   function updateManyLandData(int[] x, int[] y, string data) external {
1267     require(x.length > 0, "You should supply at least one coordinate");
1268     require(x.length == y.length, "The coordinates should have the same length");
1269     for (uint i = 0; i < x.length; i++) {
1270       _updateLandData(x[i], y[i], data);
1271     }
1272   }
1273 
1274   function _doTransferFrom(
1275     address from,
1276     address to,
1277     uint256 assetId,
1278     bytes userData,
1279     bool doCheck
1280   )
1281     internal
1282   {
1283     updateOperator[assetId] = address(0);
1284 
1285     super._doTransferFrom(
1286       from,
1287       to,
1288       assetId,
1289       userData,
1290       doCheck
1291     );
1292   }
1293 
1294   function _isContract(address addr) internal view returns (bool) {
1295     uint size;
1296     // solium-disable-next-line security/no-inline-assembly
1297     assembly { size := extcodesize(addr) }
1298     return size > 0;
1299   }
1300 }