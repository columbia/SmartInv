1 pragma solidity 0.4.21;
2 
3 // File: contracts/land/LANDStorage.sol
4 
5 contract LANDStorage {
6 
7   mapping (address => uint) public latestPing;
8 
9   uint256 constant clearLow = 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;
10   uint256 constant clearHigh = 0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff;
11   uint256 constant factor = 0x100000000000000000000000000000000;
12 
13   mapping (address => bool) public authorizedDeploy;
14 
15   mapping (uint256 => address) public updateOperator;
16 }
17 
18 // File: contracts/upgradable/OwnableStorage.sol
19 
20 contract OwnableStorage {
21 
22   address public owner;
23 
24   function OwnableStorage() internal {
25     owner = msg.sender;
26   }
27 
28 }
29 
30 // File: contracts/upgradable/ProxyStorage.sol
31 
32 contract ProxyStorage {
33 
34   /**
35    * Current contract to which we are proxing
36    */
37   address public currentContract;
38   address public proxyOwner;
39 }
40 
41 // File: erc821/contracts/AssetRegistryStorage.sol
42 
43 contract AssetRegistryStorage {
44 
45   string internal _name;
46   string internal _symbol;
47   string internal _description;
48 
49   /**
50    * Stores the total count of assets managed by this registry
51    */
52   uint256 internal _count;
53 
54   /**
55    * Stores an array of assets owned by a given account
56    */
57   mapping(address => uint256[]) internal _assetsOf;
58 
59   /**
60    * Stores the current holder of an asset
61    */
62   mapping(uint256 => address) internal _holderOf;
63 
64   /**
65    * Stores the index of an asset in the `_assetsOf` array of its holder
66    */
67   mapping(uint256 => uint256) internal _indexOfAsset;
68 
69   /**
70    * Stores the data associated with an asset
71    */
72   mapping(uint256 => string) internal _assetData;
73 
74   /**
75    * For a given account, for a given operator, store whether that operator is
76    * allowed to transfer and modify assets on behalf of them.
77    */
78   mapping(address => mapping(address => bool)) internal _operators;
79 
80   /**
81    * Approval array
82    */
83   mapping(uint256 => address) internal _approval;
84 }
85 
86 // File: contracts/Storage.sol
87 
88 contract Storage is ProxyStorage, OwnableStorage, AssetRegistryStorage, LANDStorage {
89 }
90 
91 // File: contracts/upgradable/IApplication.sol
92 
93 contract IApplication {
94   function initialize(bytes data) public;
95 }
96 
97 // File: contracts/upgradable/Ownable.sol
98 
99 contract Ownable is Storage {
100 
101   event OwnerUpdate(address _prevOwner, address _newOwner);
102 
103   function bytesToAddress (bytes b) pure public returns (address) {
104     uint result = 0;
105     for (uint i = b.length-1; i+1 > 0; i--) {
106       uint c = uint(b[i]);
107       uint to_inc = c * ( 16 ** ((b.length - i-1) * 2));
108       result += to_inc;
109     }
110     return address(result);
111   }
112 
113   modifier onlyOwner {
114     assert(msg.sender == owner);
115     _;
116   }
117 
118   function transferOwnership(address _newOwner) public onlyOwner {
119     require(_newOwner != owner);
120     owner = _newOwner;
121   }
122 }
123 
124 // File: contracts/land/ILANDRegistry.sol
125 
126 interface ILANDRegistry {
127 
128   // LAND can be assigned by the owner
129   function assignNewParcel(int x, int y, address beneficiary) public;
130   function assignMultipleParcels(int[] x, int[] y, address beneficiary) public;
131 
132   // After one year, land can be claimed from an inactive public key
133   function ping() public;
134 
135   // LAND-centric getters
136   function encodeTokenId(int x, int y) view public returns (uint256);
137   function decodeTokenId(uint value) view public returns (int, int);
138   function exists(int x, int y) view public returns (bool);
139   function ownerOfLand(int x, int y) view public returns (address);
140   function ownerOfLandMany(int[] x, int[] y) view public returns (address[]);
141   function landOf(address owner) view public returns (int[], int[]);
142   function landData(int x, int y) view public returns (string);
143 
144   // Transfer LAND
145   function transferLand(int x, int y, address to) public;
146   function transferManyLand(int[] x, int[] y, address to) public;
147 
148   // Update LAND
149   function updateLandData(int x, int y, string data) public;
150   function updateManyLandData(int[] x, int[] y, string data) public;
151 
152   // Events
153 
154   event Update(  
155     uint256 indexed assetId, 
156     address indexed holder,  
157     address indexed operator,  
158     string data  
159   );
160 }
161 
162 // File: erc821/contracts/IERC721Base.sol
163 
164 interface IERC721Base {
165   function totalSupply() public view returns (uint256);
166 
167   // function exists(uint256 assetId) public view returns (bool);
168   function ownerOf(uint256 assetId) public view returns (address);
169 
170   function balanceOf(address holder) public view returns (uint256);
171 
172   function safeTransferFrom(address from, address to, uint256 assetId) public;
173   function safeTransferFrom(address from, address to, uint256 assetId, bytes userData) public;
174 
175   function transferFrom(address from, address to, uint256 assetId) public;
176 
177   function approve(address operator, uint256 assetId) public;
178   function setApprovalForAll(address operator, bool authorized) public;
179 
180   function getApprovedAddress(uint256 assetId) public view returns (address);
181   function isApprovedForAll(address operator, address assetOwner) public view returns (bool);
182 
183   function isAuthorized(address operator, uint256 assetId) public view returns (bool);
184 
185   event Transfer(
186     address indexed from,
187     address indexed to,
188     uint256 indexed assetId,
189     address operator,
190     bytes userData
191   );
192   event ApprovalForAll(
193     address indexed operator,
194     address indexed holder,
195     bool authorized
196   );
197   event Approval(
198     address indexed owner,
199     address indexed operator,
200     uint256 indexed assetId
201   );
202 }
203 
204 // File: erc821/contracts/IERC721Receiver.sol
205 
206 interface IERC721Receiver {
207   function onERC721Received(
208     uint256 _tokenId,
209     address _oldOwner,
210     bytes   _userData
211   ) public returns (bytes4);
212 }
213 
214 // File: zeppelin-solidity/contracts/math/SafeMath.sol
215 
216 /**
217  * @title SafeMath
218  * @dev Math operations with safety checks that throw on error
219  */
220 library SafeMath {
221 
222   /**
223   * @dev Multiplies two numbers, throws on overflow.
224   */
225   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226     if (a == 0) {
227       return 0;
228     }
229     uint256 c = a * b;
230     assert(c / a == b);
231     return c;
232   }
233 
234   /**
235   * @dev Integer division of two numbers, truncating the quotient.
236   */
237   function div(uint256 a, uint256 b) internal pure returns (uint256) {
238     // assert(b > 0); // Solidity automatically throws when dividing by 0
239     uint256 c = a / b;
240     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241     return c;
242   }
243 
244   /**
245   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
246   */
247   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
248     assert(b <= a);
249     return a - b;
250   }
251 
252   /**
253   * @dev Adds two numbers, throws on overflow.
254   */
255   function add(uint256 a, uint256 b) internal pure returns (uint256) {
256     uint256 c = a + b;
257     assert(c >= a);
258     return c;
259   }
260 }
261 
262 // File: erc821/contracts/ERC721Base.sol
263 
264 interface ERC165 {
265   function supportsInterface(bytes4 interfaceID) public view returns (bool);
266 }
267 
268 contract ERC721Base is AssetRegistryStorage, IERC721Base, ERC165 {
269   using SafeMath for uint256;
270 
271   //
272   // Global Getters
273   //
274 
275   /**
276    * @dev Gets the total amount of assets stored by the contract
277    * @return uint256 representing the total amount of assets
278    */
279   function totalSupply() public view returns (uint256) {
280     return _count;
281   }
282 
283   //
284   // Asset-centric getter functions
285   //
286 
287   /**
288    * @dev Queries what address owns an asset. This method does not throw.
289    * In order to check if the asset exists, use the `exists` function or check if the
290    * return value of this call is `0`.
291    * @return uint256 the assetId
292    */
293   function ownerOf(uint256 assetId) public view returns (address) {
294     return _holderOf[assetId];
295   }
296 
297   //
298   // Holder-centric getter functions
299   //
300   /**
301    * @dev Gets the balance of the specified address
302    * @param owner address to query the balance of
303    * @return uint256 representing the amount owned by the passed address
304    */
305   function balanceOf(address owner) public view returns (uint256) {
306     return _assetsOf[owner].length;
307   }
308 
309   //
310   // Authorization getters
311   //
312 
313   /**
314    * @dev Query whether an address has been authorized to move any assets on behalf of someone else
315    * @param operator the address that might be authorized
316    * @param assetHolder the address that provided the authorization
317    * @return bool true if the operator has been authorized to move any assets
318    */
319   function isApprovedForAll(address operator, address assetHolder)
320     public view returns (bool)
321   {
322     return _operators[assetHolder][operator];
323   }
324 
325   /**
326    * @dev Query what address has been particularly authorized to move an asset
327    * @param assetId the asset to be queried for
328    * @return bool true if the asset has been approved by the holder
329    */
330   function getApprovedAddress(uint256 assetId) public view returns (address) {
331     return _approval[assetId];
332   }
333 
334   /**
335    * @dev Query if an operator can move an asset.
336    * @param operator the address that might be authorized
337    * @param assetId the asset that has been `approved` for transfer
338    * @return bool true if the asset has been approved by the holder
339    */
340   function isAuthorized(address operator, uint256 assetId)
341     public view returns (bool)
342   {
343     require(operator != 0);
344     address owner = ownerOf(assetId);
345     if (operator == owner) {
346       return true;
347     }
348     return isApprovedForAll(operator, owner) || getApprovedAddress(assetId) == operator;
349   }
350 
351   //
352   // Authorization
353   //
354 
355   /**
356    * @dev Authorize a third party operator to manage (send) msg.sender's asset
357    * @param operator address to be approved
358    * @param authorized bool set to true to authorize, false to withdraw authorization
359    */
360   function setApprovalForAll(address operator, bool authorized) public {
361     if (authorized) {
362       require(!isApprovedForAll(operator, msg.sender));
363       _addAuthorization(operator, msg.sender);
364     } else {
365       require(isApprovedForAll(operator, msg.sender));
366       _clearAuthorization(operator, msg.sender);
367     }
368     ApprovalForAll(operator, msg.sender, authorized);
369   }
370 
371   /**
372    * @dev Authorize a third party operator to manage one particular asset
373    * @param operator address to be approved
374    * @param assetId asset to approve
375    */
376   function approve(address operator, uint256 assetId) public {
377     address holder = ownerOf(assetId);
378     require(operator != holder);
379     if (getApprovedAddress(assetId) != operator) {
380       _approval[assetId] = operator;
381       Approval(holder, operator, assetId);
382     }
383   }
384 
385   function _addAuthorization(address operator, address holder) private {
386     _operators[holder][operator] = true;
387   }
388 
389   function _clearAuthorization(address operator, address holder) private {
390     _operators[holder][operator] = false;
391   }
392 
393   //
394   // Internal Operations
395   //
396 
397   function _addAssetTo(address to, uint256 assetId) internal {
398     _holderOf[assetId] = to;
399 
400     uint256 length = balanceOf(to);
401 
402     _assetsOf[to].push(assetId);
403 
404     _indexOfAsset[assetId] = length;
405 
406     _count = _count.add(1);
407   }
408 
409   function _removeAssetFrom(address from, uint256 assetId) internal {
410     uint256 assetIndex = _indexOfAsset[assetId];
411     uint256 lastAssetIndex = balanceOf(from).sub(1);
412     uint256 lastAssetId = _assetsOf[from][lastAssetIndex];
413 
414     _holderOf[assetId] = 0;
415 
416     // Insert the last asset into the position previously occupied by the asset to be removed
417     _assetsOf[from][assetIndex] = lastAssetId;
418 
419     // Resize the array
420     _assetsOf[from][lastAssetIndex] = 0;
421     _assetsOf[from].length--;
422 
423     // Remove the array if no more assets are owned to prevent pollution
424     if (_assetsOf[from].length == 0) {
425       delete _assetsOf[from];
426     }
427 
428     // Update the index of positions for the asset
429     _indexOfAsset[assetId] = 0;
430     _indexOfAsset[lastAssetId] = assetIndex;
431 
432     _count = _count.sub(1);
433   }
434 
435   function _clearApproval(address holder, uint256 assetId) internal {
436     if (ownerOf(assetId) == holder && _approval[assetId] != 0) {
437       _approval[assetId] = 0;
438       Approval(holder, 0, assetId);
439     }
440   }
441 
442   //
443   // Supply-altering functions
444   //
445 
446   function _generate(uint256 assetId, address beneficiary) internal {
447     require(_holderOf[assetId] == 0);
448 
449     _addAssetTo(beneficiary, assetId);
450 
451     Transfer(0, beneficiary, assetId, msg.sender, '');
452   }
453 
454   function _destroy(uint256 assetId) internal {
455     address holder = _holderOf[assetId];
456     require(holder != 0);
457 
458     _removeAssetFrom(holder, assetId);
459 
460     Transfer(holder, 0, assetId, msg.sender, '');
461   }
462 
463   //
464   // Transaction related operations
465   //
466 
467   modifier onlyHolder(uint256 assetId) {
468     require(_holderOf[assetId] == msg.sender);
469     _;
470   }
471 
472   modifier onlyAuthorized(uint256 assetId) {
473     require(isAuthorized(msg.sender, assetId));
474     _;
475   }
476 
477   modifier isCurrentOwner(address from, uint256 assetId) {
478     require(_holderOf[assetId] == from);
479     _;
480   }
481 
482   modifier isDestinataryDefined(address destinatary) {
483     require(destinatary != 0);
484     _;
485   }
486 
487   modifier destinataryIsNotHolder(uint256 assetId, address to) {
488     require(_holderOf[assetId] != to);
489     _;
490   }
491 
492   /**
493    * @dev Alias of `safeTransferFrom(from, to, assetId, '')`
494    *
495    * @param from address that currently owns an asset
496    * @param to address to receive the ownership of the asset
497    * @param assetId uint256 ID of the asset to be transferred
498    */
499   function safeTransferFrom(address from, address to, uint256 assetId) public {
500     return _doTransferFrom(from, to, assetId, '', msg.sender, true);
501   }
502 
503   /**
504    * @dev Securely transfers the ownership of a given asset from one address to
505    * another address, calling the method `onNFTReceived` on the target address if
506    * there's code associated with it
507    *
508    * @param from address that currently owns an asset
509    * @param to address to receive the ownership of the asset
510    * @param assetId uint256 ID of the asset to be transferred
511    * @param userData bytes arbitrary user information to attach to this transfer
512    */
513   function safeTransferFrom(address from, address to, uint256 assetId, bytes userData) public {
514     return _doTransferFrom(from, to, assetId, userData, msg.sender, true);
515   }
516 
517   /**
518    * @dev Transfers the ownership of a given asset from one address to another address
519    * Warning! This function does not attempt to verify that the target address can send
520    * tokens.
521    *
522    * @param from address sending the asset
523    * @param to address to receive the ownership of the asset
524    * @param assetId uint256 ID of the asset to be transferred
525    */
526   function transferFrom(address from, address to, uint256 assetId) public {
527     return _doTransferFrom(from, to, assetId, '', msg.sender, false);
528   }
529 
530   function _doTransferFrom(
531     address from,
532     address to,
533     uint256 assetId,
534     bytes userData,
535     address operator,
536     bool doCheck
537   )
538     isDestinataryDefined(to)
539     destinataryIsNotHolder(assetId, to)
540     isCurrentOwner(from, assetId)
541     onlyAuthorized(assetId)
542     internal
543   {
544     address holder = _holderOf[assetId];
545     _removeAssetFrom(holder, assetId);
546     _clearApproval(holder, assetId);
547     _addAssetTo(to, assetId);
548 
549     if (doCheck && _isContract(to)) {
550       // Equals to bytes4(keccak256("onERC721Received(address,uint256,bytes)"))
551       bytes4 ERC721_RECEIVED = bytes4(0xf0b9e5ba);
552       require(
553         IERC721Receiver(to).onERC721Received(
554           assetId, holder, userData
555         ) == ERC721_RECEIVED
556       );
557     }
558 
559     Transfer(holder, to, assetId, operator, userData);
560   }
561 
562   /**
563    * @dev Returns `true` if the contract implements `interfaceID` and `interfaceID` is not 0xffffffff, `false` otherwise
564    * @param  _interfaceID The interface identifier, as specified in ERC-165
565    */
566   function supportsInterface(bytes4 _interfaceID) public view returns (bool) {
567 
568     if (_interfaceID == 0xffffffff) {
569       return false;
570     }
571     return _interfaceID == 0x01ffc9a7 || _interfaceID == 0x7c0633c6;
572   }
573 
574   //
575   // Utilities
576   //
577 
578   function _isContract(address addr) internal view returns (bool) {
579     uint size;
580     assembly { size := extcodesize(addr) }
581     return size > 0;
582   }
583 }
584 
585 // File: erc821/contracts/IERC721Enumerable.sol
586 
587 contract IERC721Enumerable {
588 
589   /**
590    * @notice Enumerate active tokens
591    * @dev Throws if `index` >= `totalSupply()`, otherwise SHALL NOT throw.
592    * @param index A counter less than `totalSupply()`
593    * @return The identifier for the `index`th asset, (sort order not
594    *  specified)
595    */
596   // TODO (eordano): Not implemented
597   // function tokenByIndex(uint256 index) public view returns (uint256 _assetId);
598 
599   /**
600    * @notice Count of owners which own at least one asset
601    *  Must not throw.
602    * @return A count of the number of owners which own asset
603    */
604   // TODO (eordano): Not implemented
605   // function countOfOwners() public view returns (uint256 _count);
606 
607   /**
608    * @notice Enumerate owners
609    * @dev Throws if `index` >= `countOfOwners()`, otherwise must not throw.
610    * @param index A counter less than `countOfOwners()`
611    * @return The address of the `index`th owner (sort order not specified)
612    */
613   // TODO (eordano): Not implemented
614   // function ownerByIndex(uint256 index) public view returns (address owner);
615 
616   /**
617    * @notice Get all tokens of a given address
618    * @dev This is not intended to be used on-chain
619    * @param owner address of the owner to query
620    * @return a list of all assetIds of a user
621    */
622   function tokensOf(address owner) public view returns (uint256[]);
623 
624   /**
625    * @notice Enumerate tokens assigned to an owner
626    * @dev Throws if `index` >= `balanceOf(owner)` or if
627    *  `owner` is the zero address, representing invalid assets.
628    *  Otherwise this must not throw.
629    * @param owner An address where we are interested in assets owned by them
630    * @param index A counter less than `balanceOf(owner)`
631    * @return The identifier for the `index`th asset assigned to `owner`,
632    *   (sort order not specified)
633    */
634   function tokenOfOwnerByIndex(
635     address owner, uint256 index
636   ) public view returns (uint256 tokenId);
637 }
638 
639 // File: erc821/contracts/ERC721Enumerable.sol
640 
641 contract ERC721Enumerable is AssetRegistryStorage, IERC721Enumerable {
642 
643   /**
644    * @notice Get all tokens of a given address
645    * @dev This is not intended to be used on-chain
646    * @param owner address of the owner to query
647    * @return a list of all assetIds of a user
648    */
649   function tokensOf(address owner) public view returns (uint256[]) {
650     return _assetsOf[owner];
651   }
652 
653   /**
654    * @notice Enumerate tokens assigned to an owner
655    * @dev Throws if `index` >= `balanceOf(owner)` or if
656    *  `owner` is the zero address, representing invalid assets.
657    *  Otherwise this must not throw.
658    * @param owner An address where we are interested in assets owned by them
659    * @param index A counter less than `balanceOf(owner)`
660    * @return The identifier for the `index`th asset assigned to `owner`,
661    *   (sort order not specified)
662    */
663   function tokenOfOwnerByIndex(
664     address owner, uint256 index
665     ) public view returns (uint256 assetId)
666   {
667     require(index < _assetsOf[owner].length);
668     require(index < (1<<127));
669     return _assetsOf[owner][index];
670   }
671 
672 }
673 
674 // File: erc821/contracts/IERC721Metadata.sol
675 
676 contract IERC721Metadata {
677 
678   /**
679    * @notice A descriptive name for a collection of NFTs in this contract
680    */
681   function name() public view returns (string);
682 
683   /**
684    * @notice An abbreviated name for NFTs in this contract
685    */
686   function symbol() public view returns (string);
687 
688   /**
689    * @notice A description of what this DAR is used for
690    */
691   function description() public view returns (string);
692 
693   /**
694    * Stores arbitrary info about a token
695    */
696   function tokenMetadata(uint256 assetId) public view returns (string);
697 }
698 
699 // File: erc821/contracts/ERC721Metadata.sol
700 
701 contract ERC721Metadata is AssetRegistryStorage, IERC721Metadata {
702   function name() public view returns (string) {
703     return _name;
704   }
705   function symbol() public view returns (string) {
706     return _symbol;
707   }
708   function description() public view returns (string) {
709     return _description;
710   }
711   function tokenMetadata(uint256 assetId) public view returns (string) {
712     return _assetData[assetId];
713   }
714   function _update(uint256 assetId, string data) internal {
715     _assetData[assetId] = data;
716   }
717 }
718 
719 // File: erc821/contracts/FullAssetRegistry.sol
720 
721 contract FullAssetRegistry is ERC721Base, ERC721Enumerable, ERC721Metadata {
722   function FullAssetRegistry() public {
723   }
724 
725   /**
726    * @dev Method to check if an asset identified by the given id exists under this DAR.
727    * @return uint256 the assetId
728    */
729   function exists(uint256 assetId) public view returns (bool) {
730     return _holderOf[assetId] != 0;
731   }
732 
733   function decimals() public pure returns (uint256) {
734     return 0;
735   }
736 }
737 
738 // File: contracts/land/LANDRegistry.sol
739 
740 contract LANDRegistry is Storage,
741   Ownable, FullAssetRegistry,
742   ILANDRegistry
743 {
744 
745   function initialize(bytes) public {
746     _name = 'Decentraland LAND';
747     _symbol = 'LAND';
748     _description = 'Contract that stores the Decentraland LAND registry';
749   }
750 
751   modifier onlyProxyOwner() {
752     require(msg.sender == proxyOwner);
753     _;
754   }
755 
756   //
757   // LAND Create and destroy
758   //
759 
760   modifier onlyOwnerOf(uint256 assetId) {
761     require(msg.sender == ownerOf(assetId));
762     _;
763   }
764 
765   modifier onlyUpdateAuthorized(uint256 tokenId) {
766     require(msg.sender == ownerOf(tokenId) || isUpdateAuthorized(msg.sender, tokenId));
767     _;
768   }
769 
770   function isUpdateAuthorized(address operator, uint256 assetId) public view returns (bool) {
771     return operator == ownerOf(assetId) || updateOperator[assetId] == operator;
772   }
773 
774   function authorizeDeploy(address beneficiary) public onlyProxyOwner {
775     authorizedDeploy[beneficiary] = true;
776   }
777   function forbidDeploy(address beneficiary) public onlyProxyOwner {
778     authorizedDeploy[beneficiary] = false;
779   }
780 
781   function assignNewParcel(int x, int y, address beneficiary) public onlyProxyOwner {
782     _generate(encodeTokenId(x, y), beneficiary);
783   }
784 
785   function assignMultipleParcels(int[] x, int[] y, address beneficiary) public onlyProxyOwner {
786     for (uint i = 0; i < x.length; i++) {
787       _generate(encodeTokenId(x[i], y[i]), beneficiary);
788     }
789   }
790 
791   //
792   // Inactive keys after 1 year lose ownership
793   //
794 
795   function ping() public {
796     latestPing[msg.sender] = now;
797   }
798 
799   function setLatestToNow(address user) public {
800     require(msg.sender == proxyOwner || isApprovedForAll(msg.sender, user));
801     latestPing[user] = now;
802   }
803 
804   //
805   // LAND Getters
806   //
807 
808   function encodeTokenId(int x, int y) view public returns (uint) {
809     return ((uint(x) * factor) & clearLow) | (uint(y) & clearHigh);
810   }
811 
812   function decodeTokenId(uint value) view public returns (int, int) {
813     uint x = (value & clearLow) >> 128;
814     uint y = (value & clearHigh);
815     return (expandNegative128BitCast(x), expandNegative128BitCast(y));
816   }
817 
818   function expandNegative128BitCast(uint value) pure internal returns (int) {
819     if (value & (1<<127) != 0) {
820       return int(value | clearLow);
821     }
822     return int(value);
823   }
824 
825   function exists(int x, int y) view public returns (bool) {
826     return exists(encodeTokenId(x, y));
827   }
828 
829   function ownerOfLand(int x, int y) view public returns (address) {
830     return ownerOf(encodeTokenId(x, y));
831   }
832 
833   function ownerOfLandMany(int[] x, int[] y) view public returns (address[]) {
834     require(x.length > 0);
835     require(x.length == y.length);
836 
837     address[] memory addrs = new address[](x.length);
838     for (uint i = 0; i < x.length; i++) {
839       addrs[i] = ownerOfLand(x[i], y[i]);
840     }
841 
842     return addrs;
843   }
844 
845   function landOf(address owner) public view returns (int[], int[]) {
846     uint256 len = _assetsOf[owner].length;
847     int[] memory x = new int[](len);
848     int[] memory y = new int[](len);
849 
850     int assetX;
851     int assetY;
852     for (uint i = 0; i < len; i++) {
853       (assetX, assetY) = decodeTokenId(_assetsOf[owner][i]);
854       x[i] = assetX;
855       y[i] = assetY;
856     }
857 
858     return (x, y);
859   }
860 
861   function landData(int x, int y) view public returns (string) {
862     return tokenMetadata(encodeTokenId(x, y));
863   }
864 
865   //
866   // LAND Transfer
867   //
868 
869   function transferLand(int x, int y, address to) public {
870     uint256 tokenId = encodeTokenId(x, y);
871     safeTransferFrom(ownerOf(tokenId), to, tokenId);
872   }
873 
874   function transferManyLand(int[] x, int[] y, address to) public {
875     require(x.length > 0);
876     require(x.length == y.length);
877 
878     for (uint i = 0; i < x.length; i++) {
879       uint256 tokenId = encodeTokenId(x[i], y[i]);
880       safeTransferFrom(ownerOf(tokenId), to, tokenId);
881     }
882   }
883 
884   function setUpdateOperator(uint256 assetId, address operator) public onlyOwnerOf(assetId) {
885     updateOperator[assetId] = operator;
886   }
887 
888   //
889   // LAND Update
890   //
891 
892   function updateLandData(int x, int y, string data) public onlyUpdateAuthorized (encodeTokenId(x, y)) {
893     uint256 assetId = encodeTokenId(x, y);
894     _update(assetId, data);
895 
896     Update(assetId, _holderOf[assetId], msg.sender, data);
897   }
898 
899   function updateManyLandData(int[] x, int[] y, string data) public {
900     require(x.length > 0);
901     require(x.length == y.length);
902     for (uint i = 0; i < x.length; i++) {
903       updateLandData(x[i], y[i], data);
904     }
905   }
906 
907   function _doTransferFrom(
908     address from,
909     address to,
910     uint256 assetId,
911     bytes userData,
912     address operator,
913     bool doCheck
914   ) internal {
915     updateOperator[assetId] = address(0);
916     super._doTransferFrom(from, to, assetId, userData, operator, doCheck);
917   }
918 }