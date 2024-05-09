1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.13;
3 
4 /// @dev Initialization call information
5 struct InitInfo {
6     // Address of target contract
7     address target;
8     // Initialization data
9     bytes data;
10     // Merkle proof for call
11     bytes32[] proof;
12 }
13 
14 /// @dev Interface for Vault proxy contract
15 interface IVault {
16     /// @dev Emitted when execution reverted with no reason
17     error ExecutionReverted();
18     /// @dev Emitted when the caller is not the owner
19     error NotAuthorized(address _caller, address _target, bytes4 _selector);
20     /// @dev Emitted when the caller is not the owner
21     error NotOwner(address _owner, address _caller);
22     /// @dev Emitted when the caller is not the factory
23     error NotFactory(address _factory, address _caller);
24     /// @dev Emitted when passing an EOA or an undeployed contract as the target
25     error TargetInvalid(address _target);
26 
27     /// @dev Event log for executing transactions
28     /// @param _target Address of target contract
29     /// @param _data Transaction data being executed
30     /// @param _response Return data of delegatecall
31     event Execute(address indexed _target, bytes _data, bytes _response);
32 
33     function execute(
34         address _target,
35         bytes memory _data,
36         bytes32[] memory _proof
37     ) external payable returns (bool success, bytes memory response);
38 
39     function MERKLE_ROOT() external view returns (bytes32);
40 
41     function OWNER() external view returns (address);
42 
43     function FACTORY() external view returns (address);
44 }
45 
46 /// @dev Vault permissions
47 struct Permission {
48     // Address of module contract
49     address module;
50     // Address of target contract
51     address target;
52     // Function selector from target contract
53     bytes4 selector;
54 }
55 
56 /// @dev Vault information
57 struct VaultInfo {
58     // Address of Rae token contract
59     address token;
60     // ID of the token type
61     uint256 id;
62 }
63 
64 /// @dev Interface for VaultRegistry contract
65 interface IVaultRegistry {
66     /// @dev Emitted when the caller is not the controller
67     error InvalidController(address _controller, address _sender);
68     /// @dev Emitted when the caller is not a registered vault
69     error UnregisteredVault(address _sender);
70 
71     /// @dev Event log for deploying vault
72     /// @param _vault Address of the vault
73     /// @param _token Address of the token
74     /// @param _id Id of the token
75     event VaultDeployed(address indexed _vault, address indexed _token, uint256 indexed _id);
76 
77     function createFor(
78         bytes32 _merkleRoot,
79         address _owner,
80         InitInfo[] calldata _calls
81     ) external returns (address vault);
82 
83     function createFor(bytes32 _merkleRoot, address _owner) external returns (address vault);
84 
85     function create(bytes32 _merkleRoot, InitInfo[] calldata _calls)
86         external
87         returns (address vault);
88 
89     function create(bytes32 _merkleRoot) external returns (address vault);
90 
91     function createCollectionFor(
92         bytes32 _merkleRoot,
93         address _controller,
94         InitInfo[] calldata _calls
95     ) external returns (address vault, address token);
96 
97     function createCollection(bytes32 _merkleRoot, InitInfo[] calldata _calls)
98         external
99         returns (address vault, address token);
100 
101     function createInCollection(
102         bytes32 _merkleRoot,
103         address _token,
104         InitInfo[] calldata _calls
105     ) external returns (address vault);
106 
107     function factory() external view returns (address);
108 
109     function rae() external view returns (address);
110 
111     function raeImplementation() external view returns (address);
112 
113     function burn(address _from, uint256 _value) external;
114 
115     function mint(address _to, uint256 _value) external;
116 
117     function nextId(address) external view returns (uint256);
118 
119     function totalSupply(address _vault) external view returns (uint256);
120 
121     function uri(address _vault) external view returns (string memory);
122 
123     function vaultToToken(address) external view returns (address token, uint256 id);
124 }
125 
126 /// @dev Interface for generic Module contract
127 interface IModule {
128     function getLeaves() external view returns (bytes32[] memory leaves);
129 
130     function getUnhashedLeaves() external view returns (bytes[] memory leaves);
131 
132     function getPermissions() external view returns (Permission[] memory permissions);
133 }
134 
135 /// @title Module
136 /// @author Tessera
137 /// @notice Base module contract for converting vault permissions into leaf nodes
138 contract Module is IModule {
139     /// @notice Gets the list of hashed leaf nodes used to generate a merkle tree
140     /// @dev Leaf nodes are hashed permissions of the merkle tree
141     /// @return leaves Hashed leaf nodes
142     function getLeaves() external view returns (bytes32[] memory leaves) {
143         Permission[] memory permissions = getPermissions();
144         uint256 length = permissions.length;
145         leaves = new bytes32[](length);
146         unchecked {
147             for (uint256 i; i < length; ++i) {
148                 leaves[i] = keccak256(abi.encode(permissions[i]));
149             }
150         }
151     }
152 
153     /// @notice Gets the list of unhashed leaf nodes used to generate a merkle tree
154     /// @dev Only used for third party APIs (Lanyard) that require unhashed leaves
155     /// @return leaves Unhashed leaf nodes
156     function getUnhashedLeaves() external view returns (bytes[] memory leaves) {
157         Permission[] memory permissions = getPermissions();
158         uint256 length = permissions.length;
159         leaves = new bytes[](length);
160         unchecked {
161             for (uint256 i; i < length; ++i) {
162                 leaves[i] = abi.encode(permissions[i]);
163             }
164         }
165     }
166 
167     /// @notice Gets the list of permissions installed on a vault
168     /// @dev Intentionally left empty to be overridden by the module inheriting from this contract
169     /// @return permissions List of vault permissions
170     function getPermissions() public view virtual returns (Permission[] memory permissions) {}
171 }
172 
173 /// @dev Interface for generic Protoform contract
174 interface IProtoform {
175     /// @dev Event log for modules that are enabled on a vault
176     /// @param _vault The vault deployed
177     /// @param _modules The modules being activated on deployed vault
178     event ActiveModules(address indexed _vault, address[] _modules);
179 
180     function generateMerkleTree(address[] memory _modules)
181         external
182         view
183         returns (bytes32[] memory tree);
184 
185     function generateUnhashedMerkleTree(address[] memory _modules)
186         external
187         view
188         returns (bytes[] memory tree);
189 }
190 
191 /// @title Merkle Base
192 /// @author Modified from Murky (https://github.com/dmfxyz/murky/blob/main/src/common/MurkyBase.sol)
193 /// @notice Utility contract for generating merkle roots and verifying proofs
194 abstract contract MerkleBase {
195     constructor() {}
196 
197     /// @notice Hashes two leaf pairs
198     /// @param _left Node on left side of tree level
199     /// @param _right Node on right side of tree level
200     /// @return data Result hash of node params
201     function hashLeafPairs(bytes32 _left, bytes32 _right) public pure returns (bytes32 data) {
202         // Return opposite node if checked node is of bytes zero value
203         if (_left == bytes32(0)) return _right;
204         if (_right == bytes32(0)) return _left;
205 
206         assembly {
207             // TODO: This can be aesthetically simplified with a switch. Not sure it will
208             // save much gas but there are other optimizations to be had in here.
209             if or(lt(_left, _right), eq(_left, _right)) {
210                 mstore(0x0, _left)
211                 mstore(0x20, _right)
212             }
213             if gt(_left, _right) {
214                 mstore(0x0, _right)
215                 mstore(0x20, _left)
216             }
217             data := keccak256(0x0, 0x40)
218         }
219     }
220 
221     /// @notice Verifies the merkle proof of a given value
222     /// @param _root Hash of merkle root
223     /// @param _proof Merkle proof
224     /// @param _valueToProve Leaf node being proven
225     /// @return Status of proof verification
226     function verifyProof(
227         bytes32 _root,
228         bytes32[] memory _proof,
229         bytes32 _valueToProve
230     ) public pure returns (bool) {
231         // proof length must be less than max array size
232         bytes32 rollingHash = _valueToProve;
233         unchecked {
234             for (uint256 i = 0; i < _proof.length; ++i) {
235                 rollingHash = hashLeafPairs(rollingHash, _proof[i]);
236             }
237         }
238         return _root == rollingHash;
239     }
240 
241     /// @notice Generates the merkle root of a tree
242     /// @param _data Leaf nodes of the merkle tree
243     /// @return Hash of merkle root
244     function getRoot(bytes32[] memory _data) public pure returns (bytes32) {
245         require(_data.length > 1, "wont generate root for single leaf");
246         while (_data.length > 1) {
247             _data = hashLevel(_data);
248         }
249         return _data[0];
250     }
251 
252     /// @notice Generates the merkle proof for a leaf node in a given tree
253     /// @param _data Leaf nodes of the merkle tree
254     /// @param _node Index of the node in the tree
255     /// @return proof Merkle proof
256     function getProof(bytes32[] memory _data, uint256 _node)
257         public
258         pure
259         returns (bytes32[] memory proof)
260     {
261         require(_data.length > 1, "wont generate proof for single leaf");
262         // The size of the proof is equal to the ceiling of log2(numLeaves)
263         uint256 size = log2ceil_naive(_data.length);
264         bytes32[] memory result = new bytes32[](size);
265         uint256 pos;
266         uint256 counter;
267 
268         // Two overflow risks: node, pos
269         // node: max array size is 2**256-1. Largest index in the array will be 1 less than that. Also,
270         // for dynamic arrays, size is limited to 2**64-1
271         // pos: pos is bounded by log2(data.length), which should be less than type(uint256).max
272         while (_data.length > 1) {
273             unchecked {
274                 if (_node % 2 == 1) {
275                     result[pos] = _data[_node - 1];
276                 } else if (_node + 1 == _data.length) {
277                     result[pos] = bytes32(0);
278                     ++counter;
279                 } else {
280                     result[pos] = _data[_node + 1];
281                 }
282                 ++pos;
283                 _node = _node / 2;
284             }
285             _data = hashLevel(_data);
286         }
287 
288         // Dynamic array to filter out address(0) since proof size is rounded up
289         // This is done to return the actual proof size of the indexed node
290         uint256 offset;
291         proof = new bytes32[](size - counter);
292         unchecked {
293             for (uint256 i; i < size; ++i) {
294                 if (result[i] != bytes32(0)) {
295                     proof[i - offset] = result[i];
296                 } else {
297                     ++offset;
298                 }
299             }
300         }
301     }
302 
303     /// @dev Hashes nodes at the given tree level
304     /// @param _data Nodes at the current level
305     /// @return result Hashes of nodes at the next level
306     function hashLevel(bytes32[] memory _data) private pure returns (bytes32[] memory result) {
307         // Function is private, and all internal callers check that data.length >=2.
308         // Underflow is not possible as lowest possible value for data/result index is 1
309         // overflow should be safe as length is / 2 always.
310         unchecked {
311             uint256 length = _data.length;
312             if (length & 0x1 == 1) {
313                 result = new bytes32[]((length >> 1) + 1);
314                 result[result.length - 1] = hashLeafPairs(_data[length - 1], bytes32(0));
315             } else {
316                 result = new bytes32[](length >> 1);
317             }
318 
319             // pos is upper bounded by data.length / 2, so safe even if array is at max size
320             uint256 pos;
321             for (uint256 i; i < length - 1; i += 2) {
322                 result[pos] = hashLeafPairs(_data[i], _data[i + 1]);
323                 ++pos;
324             }
325         }
326     }
327 
328     /// @notice Calculates proof size based on size of tree
329     /// @dev Note that x is assumed > 0 and proof size is not precise
330     /// @param x Size of the merkle tree
331     /// @return ceil Rounded value of proof size
332     function log2ceil_naive(uint256 x) public pure returns (uint256 ceil) {
333         uint256 pOf2;
334         // If x is a power of 2, then this function will return a ceiling
335         // that is 1 greater than the actual ceiling. So we need to check if
336         // x is a power of 2, and subtract one from ceil if so.
337         assembly {
338             // we check by seeing if x == (~x + 1) & x. This applies a mask
339             // to find the lowest set bit of x and then checks it for equality
340             // with x. If they are equal, then x is a power of 2.
341 
342             /* Example
343                 x has single bit set
344                 x := 0000_1000
345                 (~x + 1) = (1111_0111) + 1 = 1111_1000
346                 (1111_1000 & 0000_1000) = 0000_1000 == x
347                 x has multiple bits set
348                 x := 1001_0010
349                 (~x + 1) = (0110_1101 + 1) = 0110_1110
350                 (0110_1110 & x) = 0000_0010 != x
351             */
352 
353             // we do some assembly magic to treat the bool as an integer later on
354             pOf2 := eq(and(add(not(x), 1), x), x)
355         }
356 
357         // if x == type(uint256).max, than ceil is capped at 256
358         // if x == 0, then pO2 == 0, so ceil won't underflow
359         unchecked {
360             while (x > 0) {
361                 x >>= 1;
362                 ceil++;
363             }
364             ceil -= pOf2;
365         }
366     }
367 }
368 
369 /// @title Protoform
370 /// @author Tessera
371 /// @notice Base protoform contract for generating merkle trees
372 contract Protoform is IProtoform, MerkleBase {
373     /// @notice Generates a merkle tree from the hashed permissions of the given modules
374     /// @param _modules List of module contracts
375     /// @return tree Merkle tree of hashed leaf nodes
376     function generateMerkleTree(address[] memory _modules)
377         public
378         view
379         returns (bytes32[] memory tree)
380     {
381         uint256 counter;
382         uint256 modulesLength = _modules.length;
383         uint256 treeSize = _getTreeSize(_modules, modulesLength);
384         tree = new bytes32[](treeSize);
385         unchecked {
386             /* _sortList(_modules, modulesLength); */
387             for (uint256 i; i < modulesLength; ++i) {
388                 bytes32[] memory leaves = IModule(_modules[i]).getLeaves();
389                 uint256 leavesLength = leaves.length;
390                 for (uint256 j; j < leavesLength; ++j) {
391                     tree[counter++] = leaves[j];
392                 }
393             }
394         }
395     }
396 
397     /// @notice Generates a merkle tree from the unhashed permissions of the given modules
398     /// @dev Only used for third party APIs (Lanyard) that require unhashed leaves
399     /// @param _modules List of module contracts
400     /// @return tree Merkle tree of unhashed leaf nodes
401     function generateUnhashedMerkleTree(address[] memory _modules)
402         public
403         view
404         returns (bytes[] memory tree)
405     {
406         uint256 counter;
407         uint256 modulesLength = _modules.length;
408         uint256 treeSize = _getTreeSize(_modules, modulesLength);
409         tree = new bytes[](treeSize);
410         unchecked {
411             /* _sortList(_modules, modulesLength); */
412             for (uint256 i; i < modulesLength; ++i) {
413                 bytes[] memory leaves = IModule(_modules[i]).getUnhashedLeaves();
414                 uint256 leavesLength = leaves.length;
415                 for (uint256 j; j < leavesLength; ++j) {
416                     tree[counter++] = leaves[j];
417                 }
418             }
419         }
420     }
421 
422     /// @dev Gets the size of a merkle tree based on the total permissions across all modules
423     /// @param _modules List of module contracts
424     /// @param _length Size of modules array
425     /// @return size Total size of the merkle tree
426     function _getTreeSize(address[] memory _modules, uint256 _length)
427         internal
428         view
429         returns (uint256 size)
430     {
431         unchecked {
432             for (uint256 i; i < _length; ++i) {
433                 size += IModule(_modules[i]).getLeaves().length;
434             }
435         }
436     }
437 
438     /// @dev Sorts the list of modules in ascending order
439     function _sortList(address[] memory _modules, uint256 _length) internal pure {
440         for (uint256 i; i < _length; ++i) {
441             for (uint256 j = i + 1; j < _length; ++j) {
442                 if (_modules[i] > _modules[j]) {
443                     (_modules[i], _modules[j]) = (_modules[j], _modules[i]);
444                 }
445             }
446         }
447     }
448 }
449 
450 /// @dev Interface for Supply target contract
451 interface ISupply {
452     /// @dev Emitted when an account being called as an assumed contract does not have code and returns no data
453     error MintError(address _account);
454     /// @dev Emitted when an account being called as an assumed contract does not have code and returns no data
455     error BurnError(address _account);
456 
457     function mint(address _to, uint256 _value) external;
458 
459     function burn(address _from, uint256 _value) external;
460 }
461 
462 struct LPDAInfo {
463     /// the start time of the auction
464     uint32 startTime;
465     /// the end time of the auction
466     uint32 endTime;
467     /// the price decrease per second
468     uint64 dropPerSecond;
469     /// the price of the item at startTime
470     uint128 startPrice;
471     /// the price that startPrice drops down
472     uint128 endPrice;
473     /// the lowest price paid in a successful LPDA
474     uint128 minBid;
475     /// the total supply of raes being auctioned
476     uint16 supply;
477     /// the number of raes currently sold in the auction
478     uint16 numSold;
479     /// the amount of eth claimed by the curator
480     uint128 curatorClaimed;
481     /// the address of the curator of the auctioned item
482     address curator;
483 }
484 
485 enum LPDAState {
486     NotLive,
487     Live,
488     Successful,
489     NotSuccessful
490 }
491 
492 interface ILPDA {
493     event CreatedLPDA(
494         address indexed _vault,
495         address indexed _token,
496         uint256 _id,
497         LPDAInfo _lpdaInfo
498     );
499 
500     /// @notice event emitted when a new bid is entered
501     event BidEntered(
502         address indexed _vault,
503         address indexed _user,
504         uint256 _quantity,
505         uint256 _price
506     );
507 
508     /// @notice event emitted when settling an auction and a user is owed a refund
509     event Refunded(address indexed _vault, address indexed _user, uint256 _balance);
510 
511     /// @notice event emitted when settling a successful auction with minted quantity
512     event MintedRaes(
513         address indexed _vault,
514         address indexed _user,
515         uint256 _quantity,
516         uint256 _price
517     );
518 
519     /// @notice event emitted when settling a successful auction with curator receiving a percentage
520     event CuratorClaimed(address indexed _vault, address indexed _curator, uint256 _amount);
521 
522     /// @notice event emitted when settling a successful auction and fees dispersed
523     event FeeDispersed(address indexed _vault, address indexed _receiver, uint256 _amount);
524 
525     /// @notice event emitted when settling a successful auction and royalty assessed
526     event RoyaltyPaid(address indexed _vault, address indexed _royaltyReceiver, uint256 _amount);
527 
528     /// @notice event emitted after an unsuccessful auction and the curator withdraws their nft
529     event CuratorRedeemedNFT(
530         address indexed _vault,
531         address indexed _curator,
532         address indexed _token,
533         uint256 _tokenId
534     );
535 
536     function deployVault(
537         address[] calldata _modules,
538         address[] calldata _plugins,
539         bytes4[] calldata _selectors,
540         LPDAInfo calldata _lpdaInfo,
541         address _token,
542         uint256 _id,
543         bytes32[] calldata _mintProof
544     ) external returns (address vault);
545 
546     function enterBid(address _vault, uint16 _amount) external payable;
547 
548     function settleAddress(address _vault, address _minter) external;
549 
550     function settleCurator(address _vault) external;
551 
552     function redeemNFTCurator(
553         address _vault,
554         address _token,
555         uint256 _tokenId,
556         bytes32[] calldata _erc721TransferProof
557     ) external;
558 
559     function updateFeeReceiver(address _receiver) external;
560 
561     function currentPrice(address _vault) external returns (uint256 price);
562 
563     function getAuctionState(address _vault) external returns (LPDAState state);
564 
565     function refundOwed(address _vault, address _minter) external returns (uint256 owed);
566 }
567 
568 library LibLPDAInfo {
569     function getAuctionState(LPDAInfo memory _info) internal view returns (LPDAState) {
570         if (isNotLive(_info)) return LPDAState.NotLive;
571         if (isLive(_info)) return LPDAState.Live;
572         if (isSuccessful(_info)) return LPDAState.Successful;
573         return LPDAState.NotSuccessful;
574     }
575 
576     function isNotLive(LPDAInfo memory _info) internal view returns (bool) {
577         return (_info.startTime > block.timestamp);
578     }
579 
580     function isLive(LPDAInfo memory _info) internal view returns (bool) {
581         return (block.timestamp > _info.startTime &&
582             block.timestamp < _info.endTime &&
583             _info.numSold < _info.supply);
584     }
585 
586     function isSuccessful(LPDAInfo memory _info) internal pure returns (bool) {
587         return (_info.numSold == _info.supply);
588     }
589 
590     function isNotSuccessful(LPDAInfo memory _info) internal view returns (bool) {
591         return (block.timestamp > _info.endTime && _info.numSold < _info.supply);
592     }
593 
594     function isOver(LPDAInfo memory _info) internal view returns (bool) {
595         return (isNotSuccessful(_info) || isSuccessful(_info));
596     }
597 
598     function remainingSupply(LPDAInfo memory _info) internal pure returns (uint256) {
599         return (_info.supply - _info.numSold);
600     }
601 
602     function validateAndRecordBid(
603         LPDAInfo storage _info,
604         uint128 price,
605         uint16 amount
606     ) internal {
607         _validateBid(_info, price, amount);
608         _info.numSold += amount;
609         if (_info.numSold == _info.supply) _info.minBid = price;
610     }
611 
612     function validateAuctionInfo(LPDAInfo memory _info) internal view {
613         require(_info.startTime >= uint32(block.timestamp), "LPDA: Invalid time");
614         require(_info.startTime < _info.endTime, "LPDA: Invalid time");
615         require(_info.dropPerSecond > 0, "LPDA: Invalid drop");
616         require(_info.startPrice > _info.endPrice, "LPDA: Invalid price");
617         require(_info.minBid == 0, "LPDA: Invalid min bid");
618         require(_info.supply > 0, "LPDA: Invalid supply");
619         require(_info.numSold == 0, "LPDA: Invalid sold");
620         require(_info.curatorClaimed == 0, "LPDA: Invalid curatorClaimed");
621     }
622 
623     function _validateBid(
624         LPDAInfo memory _info,
625         uint128 price,
626         uint16 amount
627     ) internal view {
628         require(msg.value >= (price * amount), "LPDA: Insufficient value");
629         require(_info.supply != 0, "LPDA: Auction doesnt exist");
630         require(remainingSupply(_info) >= amount, "LPDA: Not enough remaining");
631         require(isLive(_info), "LPDA: Not Live");
632         require(amount > 0, "LPDA: Must bid atleast 1 rae");
633     }
634 }
635 
636 /// @dev Interface for Transfer target contract
637 interface ITransfer {
638     /// @dev Emitted when an ERC-20 token transfer returns a falsey value
639     /// @param _token The token for which the ERC20 transfer was attempted
640     /// @param _from The source of the attempted ERC20 transfer
641     /// @param _to The recipient of the attempted ERC20 transfer
642     /// @param _amount The amount for the attempted ERC20 transfer
643     error BadReturnValueFromERC20OnTransfer(
644         address _token,
645         address _from,
646         address _to,
647         uint256 _amount
648     );
649     /// @dev Emitted when the transfer of ether is unsuccessful
650     error ETHTransferUnsuccessful();
651     /// @dev Emitted when a batch ERC-1155 token transfer reverts
652     /// @param _token The token for which the transfer was attempted
653     /// @param _from The source of the attempted transfer
654     /// @param _to The recipient of the attempted transfer
655     /// @param _identifiers The identifiers for the attempted transfer
656     /// @param _amounts The amounts for the attempted transfer
657     error ERC1155BatchTransferGenericFailure(
658         address _token,
659         address _from,
660         address _to,
661         uint256[] _identifiers,
662         uint256[] _amounts
663     );
664     /// @dev Emitted when an ERC-721 transfer with amount other than one is attempted
665     error InvalidERC721TransferAmount();
666     /// @dev Emitted when attempting to fulfill an order where an item has an amount of zero
667     error MissingItemAmount();
668     /// @dev Emitted when an account being called as an assumed contract does not have code and returns no data
669     /// @param _account The account that should contain code
670     error NoContract(address _account);
671     /// @dev Emitted when an ERC-20, ERC-721, or ERC-1155 token transfer fails
672     /// @param _token The token for which the transfer was attempted
673     /// @param _from The source of the attempted transfer
674     /// @param _to The recipient of the attempted transfer
675     /// @param _identifier The identifier for the attempted transfer
676     /// @param _amount The amount for the attempted transfer
677     error TokenTransferGenericFailure(
678         address _token,
679         address _from,
680         address _to,
681         uint256 _identifier,
682         uint256 _amount
683     );
684 
685     function ETHTransfer(address _to, uint256 _value) external returns (bool);
686 
687     function ERC20Transfer(
688         address _token,
689         address _to,
690         uint256 _value
691     ) external;
692 
693     function ERC721TransferFrom(
694         address _token,
695         address _from,
696         address _to,
697         uint256 _tokenId
698     ) external;
699 
700     function ERC1155TransferFrom(
701         address _token,
702         address _from,
703         address _to,
704         uint256 _id,
705         uint256 _value
706     ) external;
707 
708     function ERC1155BatchTransferFrom(
709         address _token,
710         address _from,
711         address _to,
712         uint256[] calldata _ids,
713         uint256[] calldata _values
714     ) external;
715 }
716 
717 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
718 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
719 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
720 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
721 abstract contract ERC20 {
722     /*//////////////////////////////////////////////////////////////
723                                  EVENTS
724     //////////////////////////////////////////////////////////////*/
725 
726     event Transfer(address indexed from, address indexed to, uint256 amount);
727 
728     event Approval(address indexed owner, address indexed spender, uint256 amount);
729 
730     /*//////////////////////////////////////////////////////////////
731                             METADATA STORAGE
732     //////////////////////////////////////////////////////////////*/
733 
734     string public name;
735 
736     string public symbol;
737 
738     uint8 public immutable decimals;
739 
740     /*//////////////////////////////////////////////////////////////
741                               ERC20 STORAGE
742     //////////////////////////////////////////////////////////////*/
743 
744     uint256 public totalSupply;
745 
746     mapping(address => uint256) public balanceOf;
747 
748     mapping(address => mapping(address => uint256)) public allowance;
749 
750     /*//////////////////////////////////////////////////////////////
751                             EIP-2612 STORAGE
752     //////////////////////////////////////////////////////////////*/
753 
754     uint256 internal immutable INITIAL_CHAIN_ID;
755 
756     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
757 
758     mapping(address => uint256) public nonces;
759 
760     /*//////////////////////////////////////////////////////////////
761                                CONSTRUCTOR
762     //////////////////////////////////////////////////////////////*/
763 
764     constructor(
765         string memory _name,
766         string memory _symbol,
767         uint8 _decimals
768     ) {
769         name = _name;
770         symbol = _symbol;
771         decimals = _decimals;
772 
773         INITIAL_CHAIN_ID = block.chainid;
774         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
775     }
776 
777     /*//////////////////////////////////////////////////////////////
778                                ERC20 LOGIC
779     //////////////////////////////////////////////////////////////*/
780 
781     function approve(address spender, uint256 amount) public virtual returns (bool) {
782         allowance[msg.sender][spender] = amount;
783 
784         emit Approval(msg.sender, spender, amount);
785 
786         return true;
787     }
788 
789     function transfer(address to, uint256 amount) public virtual returns (bool) {
790         balanceOf[msg.sender] -= amount;
791 
792         // Cannot overflow because the sum of all user
793         // balances can't exceed the max uint256 value.
794         unchecked {
795             balanceOf[to] += amount;
796         }
797 
798         emit Transfer(msg.sender, to, amount);
799 
800         return true;
801     }
802 
803     function transferFrom(
804         address from,
805         address to,
806         uint256 amount
807     ) public virtual returns (bool) {
808         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
809 
810         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
811 
812         balanceOf[from] -= amount;
813 
814         // Cannot overflow because the sum of all user
815         // balances can't exceed the max uint256 value.
816         unchecked {
817             balanceOf[to] += amount;
818         }
819 
820         emit Transfer(from, to, amount);
821 
822         return true;
823     }
824 
825     /*//////////////////////////////////////////////////////////////
826                              EIP-2612 LOGIC
827     //////////////////////////////////////////////////////////////*/
828 
829     function permit(
830         address owner,
831         address spender,
832         uint256 value,
833         uint256 deadline,
834         uint8 v,
835         bytes32 r,
836         bytes32 s
837     ) public virtual {
838         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
839 
840         // Unchecked because the only math done is incrementing
841         // the owner's nonce which cannot realistically overflow.
842         unchecked {
843             address recoveredAddress = ecrecover(
844                 keccak256(
845                     abi.encodePacked(
846                         "\x19\x01",
847                         DOMAIN_SEPARATOR(),
848                         keccak256(
849                             abi.encode(
850                                 keccak256(
851                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
852                                 ),
853                                 owner,
854                                 spender,
855                                 value,
856                                 nonces[owner]++,
857                                 deadline
858                             )
859                         )
860                     )
861                 ),
862                 v,
863                 r,
864                 s
865             );
866 
867             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
868 
869             allowance[recoveredAddress][spender] = value;
870         }
871 
872         emit Approval(owner, spender, value);
873     }
874 
875     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
876         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
877     }
878 
879     function computeDomainSeparator() internal view virtual returns (bytes32) {
880         return
881             keccak256(
882                 abi.encode(
883                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
884                     keccak256(bytes(name)),
885                     keccak256("1"),
886                     block.chainid,
887                     address(this)
888                 )
889             );
890     }
891 
892     /*//////////////////////////////////////////////////////////////
893                         INTERNAL MINT/BURN LOGIC
894     //////////////////////////////////////////////////////////////*/
895 
896     function _mint(address to, uint256 amount) internal virtual {
897         totalSupply += amount;
898 
899         // Cannot overflow because the sum of all user
900         // balances can't exceed the max uint256 value.
901         unchecked {
902             balanceOf[to] += amount;
903         }
904 
905         emit Transfer(address(0), to, amount);
906     }
907 
908     function _burn(address from, uint256 amount) internal virtual {
909         balanceOf[from] -= amount;
910 
911         // Cannot underflow because a user's balance
912         // will never be larger than the total supply.
913         unchecked {
914             totalSupply -= amount;
915         }
916 
917         emit Transfer(from, address(0), amount);
918     }
919 }
920 
921 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
922 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
923 /// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
924 /// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.
925 library SafeTransferLib {
926     /*//////////////////////////////////////////////////////////////
927                              ETH OPERATIONS
928     //////////////////////////////////////////////////////////////*/
929 
930     function safeTransferETH(address to, uint256 amount) internal {
931         bool success;
932 
933         /// @solidity memory-safe-assembly
934         assembly {
935             // Transfer the ETH and store if it succeeded or not.
936             success := call(gas(), to, amount, 0, 0, 0, 0)
937         }
938 
939         require(success, "ETH_TRANSFER_FAILED");
940     }
941 
942     /*//////////////////////////////////////////////////////////////
943                             ERC20 OPERATIONS
944     //////////////////////////////////////////////////////////////*/
945 
946     function safeTransferFrom(
947         ERC20 token,
948         address from,
949         address to,
950         uint256 amount
951     ) internal {
952         bool success;
953 
954         /// @solidity memory-safe-assembly
955         assembly {
956             // Get a pointer to some free memory.
957             let freeMemoryPointer := mload(0x40)
958 
959             // Write the abi-encoded calldata into memory, beginning with the function selector.
960             mstore(freeMemoryPointer, 0x23b872dd00000000000000000000000000000000000000000000000000000000)
961             mstore(add(freeMemoryPointer, 4), from) // Append the "from" argument.
962             mstore(add(freeMemoryPointer, 36), to) // Append the "to" argument.
963             mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument.
964 
965             success := and(
966                 // Set success to whether the call reverted, if not we check it either
967                 // returned exactly 1 (can't just be non-zero data), or had no return data.
968                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
969                 // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.
970                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
971                 // Counterintuitively, this call must be positioned second to the or() call in the
972                 // surrounding and() call or else returndatasize() will be zero during the computation.
973                 call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)
974             )
975         }
976 
977         require(success, "TRANSFER_FROM_FAILED");
978     }
979 
980     function safeTransfer(
981         ERC20 token,
982         address to,
983         uint256 amount
984     ) internal {
985         bool success;
986 
987         /// @solidity memory-safe-assembly
988         assembly {
989             // Get a pointer to some free memory.
990             let freeMemoryPointer := mload(0x40)
991 
992             // Write the abi-encoded calldata into memory, beginning with the function selector.
993             mstore(freeMemoryPointer, 0xa9059cbb00000000000000000000000000000000000000000000000000000000)
994             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
995             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
996 
997             success := and(
998                 // Set success to whether the call reverted, if not we check it either
999                 // returned exactly 1 (can't just be non-zero data), or had no return data.
1000                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
1001                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
1002                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
1003                 // Counterintuitively, this call must be positioned second to the or() call in the
1004                 // surrounding and() call or else returndatasize() will be zero during the computation.
1005                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
1006             )
1007         }
1008 
1009         require(success, "TRANSFER_FAILED");
1010     }
1011 
1012     function safeApprove(
1013         ERC20 token,
1014         address to,
1015         uint256 amount
1016     ) internal {
1017         bool success;
1018 
1019         /// @solidity memory-safe-assembly
1020         assembly {
1021             // Get a pointer to some free memory.
1022             let freeMemoryPointer := mload(0x40)
1023 
1024             // Write the abi-encoded calldata into memory, beginning with the function selector.
1025             mstore(freeMemoryPointer, 0x095ea7b300000000000000000000000000000000000000000000000000000000)
1026             mstore(add(freeMemoryPointer, 4), to) // Append the "to" argument.
1027             mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument.
1028 
1029             success := and(
1030                 // Set success to whether the call reverted, if not we check it either
1031                 // returned exactly 1 (can't just be non-zero data), or had no return data.
1032                 or(and(eq(mload(0), 1), gt(returndatasize(), 31)), iszero(returndatasize())),
1033                 // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
1034                 // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
1035                 // Counterintuitively, this call must be positioned second to the or() call in the
1036                 // surrounding and() call or else returndatasize() will be zero during the computation.
1037                 call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
1038             )
1039         }
1040 
1041         require(success, "APPROVE_FAILED");
1042     }
1043 }
1044 
1045 /// @notice Minimalist and modern Wrapped Ether implementation.
1046 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/WETH.sol)
1047 /// @author Inspired by WETH9 (https://github.com/dapphub/ds-weth/blob/master/src/weth9.sol)
1048 contract WETH is ERC20("Wrapped Ether", "WETH", 18) {
1049     using SafeTransferLib for address;
1050 
1051     event Deposit(address indexed from, uint256 amount);
1052 
1053     event Withdrawal(address indexed to, uint256 amount);
1054 
1055     function deposit() public payable virtual {
1056         _mint(msg.sender, msg.value);
1057 
1058         emit Deposit(msg.sender, msg.value);
1059     }
1060 
1061     function withdraw(uint256 amount) public virtual {
1062         _burn(msg.sender, amount);
1063 
1064         emit Withdrawal(msg.sender, amount);
1065 
1066         msg.sender.safeTransferETH(amount);
1067     }
1068 
1069     receive() external payable virtual {
1070         deposit();
1071     }
1072 }
1073 
1074 /// @title SafeSend
1075 /// @author Tessera
1076 /// @notice Utility contract for sending Ether or WETH value to an address
1077 abstract contract SafeSend {
1078     /// @notice Address for WETH contract on network
1079     /// mainnet: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
1080     address payable public immutable WETH_ADDRESS;
1081 
1082     constructor(address payable _weth) {
1083         WETH_ADDRESS = _weth;
1084     }
1085 
1086     /// @notice Attempts to send ether to an address
1087     /// @param _to Address attemping to send to
1088     /// @param _value Amount to send
1089     /// @return success Status of transfer
1090     function _attemptETHTransfer(address _to, uint256 _value) internal returns (bool success) {
1091         // Here increase the gas limit a reasonable amount above the default, and try
1092         // to send ETH to the recipient.
1093         // NOTE: This might allow the recipient to attempt a limited reentrancy attack.
1094         (success, ) = _to.call{value: _value, gas: 30000}("");
1095     }
1096 
1097     /// @notice Sends eth or weth to an address
1098     /// @param _to Address to send to
1099     /// @param _value Amount to send
1100     function _sendEthOrWeth(address _to, uint256 _value) internal {
1101         if (!_attemptETHTransfer(_to, _value)) {
1102             WETH(WETH_ADDRESS).deposit{value: _value}();
1103             WETH(WETH_ADDRESS).transfer(_to, _value);
1104         }
1105     }
1106 }
1107 
1108 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
1109 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
1110 abstract contract ERC721 {
1111     /*//////////////////////////////////////////////////////////////
1112                                  EVENTS
1113     //////////////////////////////////////////////////////////////*/
1114 
1115     event Transfer(address indexed from, address indexed to, uint256 indexed id);
1116 
1117     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
1118 
1119     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1120 
1121     /*//////////////////////////////////////////////////////////////
1122                          METADATA STORAGE/LOGIC
1123     //////////////////////////////////////////////////////////////*/
1124 
1125     string public name;
1126 
1127     string public symbol;
1128 
1129     function tokenURI(uint256 id) public view virtual returns (string memory);
1130 
1131     /*//////////////////////////////////////////////////////////////
1132                       ERC721 BALANCE/OWNER STORAGE
1133     //////////////////////////////////////////////////////////////*/
1134 
1135     mapping(uint256 => address) internal _ownerOf;
1136 
1137     mapping(address => uint256) internal _balanceOf;
1138 
1139     function ownerOf(uint256 id) public view virtual returns (address owner) {
1140         require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
1141     }
1142 
1143     function balanceOf(address owner) public view virtual returns (uint256) {
1144         require(owner != address(0), "ZERO_ADDRESS");
1145 
1146         return _balanceOf[owner];
1147     }
1148 
1149     /*//////////////////////////////////////////////////////////////
1150                          ERC721 APPROVAL STORAGE
1151     //////////////////////////////////////////////////////////////*/
1152 
1153     mapping(uint256 => address) public getApproved;
1154 
1155     mapping(address => mapping(address => bool)) public isApprovedForAll;
1156 
1157     /*//////////////////////////////////////////////////////////////
1158                                CONSTRUCTOR
1159     //////////////////////////////////////////////////////////////*/
1160 
1161     constructor(string memory _name, string memory _symbol) {
1162         name = _name;
1163         symbol = _symbol;
1164     }
1165 
1166     /*//////////////////////////////////////////////////////////////
1167                               ERC721 LOGIC
1168     //////////////////////////////////////////////////////////////*/
1169 
1170     function approve(address spender, uint256 id) public virtual {
1171         address owner = _ownerOf[id];
1172 
1173         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
1174 
1175         getApproved[id] = spender;
1176 
1177         emit Approval(owner, spender, id);
1178     }
1179 
1180     function setApprovalForAll(address operator, bool approved) public virtual {
1181         isApprovedForAll[msg.sender][operator] = approved;
1182 
1183         emit ApprovalForAll(msg.sender, operator, approved);
1184     }
1185 
1186     function transferFrom(
1187         address from,
1188         address to,
1189         uint256 id
1190     ) public virtual {
1191         require(from == _ownerOf[id], "WRONG_FROM");
1192 
1193         require(to != address(0), "INVALID_RECIPIENT");
1194 
1195         require(
1196             msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[id],
1197             "NOT_AUTHORIZED"
1198         );
1199 
1200         // Underflow of the sender's balance is impossible because we check for
1201         // ownership above and the recipient's balance can't realistically overflow.
1202         unchecked {
1203             _balanceOf[from]--;
1204 
1205             _balanceOf[to]++;
1206         }
1207 
1208         _ownerOf[id] = to;
1209 
1210         delete getApproved[id];
1211 
1212         emit Transfer(from, to, id);
1213     }
1214 
1215     function safeTransferFrom(
1216         address from,
1217         address to,
1218         uint256 id
1219     ) public virtual {
1220         transferFrom(from, to, id);
1221 
1222         require(
1223             to.code.length == 0 ||
1224                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
1225                 ERC721TokenReceiver.onERC721Received.selector,
1226             "UNSAFE_RECIPIENT"
1227         );
1228     }
1229 
1230     function safeTransferFrom(
1231         address from,
1232         address to,
1233         uint256 id,
1234         bytes calldata data
1235     ) public virtual {
1236         transferFrom(from, to, id);
1237 
1238         require(
1239             to.code.length == 0 ||
1240                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
1241                 ERC721TokenReceiver.onERC721Received.selector,
1242             "UNSAFE_RECIPIENT"
1243         );
1244     }
1245 
1246     /*//////////////////////////////////////////////////////////////
1247                               ERC165 LOGIC
1248     //////////////////////////////////////////////////////////////*/
1249 
1250     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
1251         return
1252             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
1253             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
1254             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
1255     }
1256 
1257     /*//////////////////////////////////////////////////////////////
1258                         INTERNAL MINT/BURN LOGIC
1259     //////////////////////////////////////////////////////////////*/
1260 
1261     function _mint(address to, uint256 id) internal virtual {
1262         require(to != address(0), "INVALID_RECIPIENT");
1263 
1264         require(_ownerOf[id] == address(0), "ALREADY_MINTED");
1265 
1266         // Counter overflow is incredibly unrealistic.
1267         unchecked {
1268             _balanceOf[to]++;
1269         }
1270 
1271         _ownerOf[id] = to;
1272 
1273         emit Transfer(address(0), to, id);
1274     }
1275 
1276     function _burn(uint256 id) internal virtual {
1277         address owner = _ownerOf[id];
1278 
1279         require(owner != address(0), "NOT_MINTED");
1280 
1281         // Ownership check above ensures no underflow.
1282         unchecked {
1283             _balanceOf[owner]--;
1284         }
1285 
1286         delete _ownerOf[id];
1287 
1288         delete getApproved[id];
1289 
1290         emit Transfer(owner, address(0), id);
1291     }
1292 
1293     /*//////////////////////////////////////////////////////////////
1294                         INTERNAL SAFE MINT LOGIC
1295     //////////////////////////////////////////////////////////////*/
1296 
1297     function _safeMint(address to, uint256 id) internal virtual {
1298         _mint(to, id);
1299 
1300         require(
1301             to.code.length == 0 ||
1302                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
1303                 ERC721TokenReceiver.onERC721Received.selector,
1304             "UNSAFE_RECIPIENT"
1305         );
1306     }
1307 
1308     function _safeMint(
1309         address to,
1310         uint256 id,
1311         bytes memory data
1312     ) internal virtual {
1313         _mint(to, id);
1314 
1315         require(
1316             to.code.length == 0 ||
1317                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
1318                 ERC721TokenReceiver.onERC721Received.selector,
1319             "UNSAFE_RECIPIENT"
1320         );
1321     }
1322 }
1323 
1324 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
1325 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
1326 abstract contract ERC721TokenReceiver {
1327     function onERC721Received(
1328         address,
1329         address,
1330         uint256,
1331         bytes calldata
1332     ) external virtual returns (bytes4) {
1333         return ERC721TokenReceiver.onERC721Received.selector;
1334     }
1335 }
1336 
1337 /// @notice Minimalist and gas efficient standard ERC1155 implementation.
1338 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC1155.sol)
1339 abstract contract ERC1155 {
1340     /*//////////////////////////////////////////////////////////////
1341                                  EVENTS
1342     //////////////////////////////////////////////////////////////*/
1343 
1344     event TransferSingle(
1345         address indexed operator,
1346         address indexed from,
1347         address indexed to,
1348         uint256 id,
1349         uint256 amount
1350     );
1351 
1352     event TransferBatch(
1353         address indexed operator,
1354         address indexed from,
1355         address indexed to,
1356         uint256[] ids,
1357         uint256[] amounts
1358     );
1359 
1360     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1361 
1362     event URI(string value, uint256 indexed id);
1363 
1364     /*//////////////////////////////////////////////////////////////
1365                              ERC1155 STORAGE
1366     //////////////////////////////////////////////////////////////*/
1367 
1368     mapping(address => mapping(uint256 => uint256)) public balanceOf;
1369 
1370     mapping(address => mapping(address => bool)) public isApprovedForAll;
1371 
1372     /*//////////////////////////////////////////////////////////////
1373                              METADATA LOGIC
1374     //////////////////////////////////////////////////////////////*/
1375 
1376     function uri(uint256 id) public view virtual returns (string memory);
1377 
1378     /*//////////////////////////////////////////////////////////////
1379                               ERC1155 LOGIC
1380     //////////////////////////////////////////////////////////////*/
1381 
1382     function setApprovalForAll(address operator, bool approved) public virtual {
1383         isApprovedForAll[msg.sender][operator] = approved;
1384 
1385         emit ApprovalForAll(msg.sender, operator, approved);
1386     }
1387 
1388     function safeTransferFrom(
1389         address from,
1390         address to,
1391         uint256 id,
1392         uint256 amount,
1393         bytes calldata data
1394     ) public virtual {
1395         require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
1396 
1397         balanceOf[from][id] -= amount;
1398         balanceOf[to][id] += amount;
1399 
1400         emit TransferSingle(msg.sender, from, to, id, amount);
1401 
1402         require(
1403             to.code.length == 0
1404                 ? to != address(0)
1405                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, from, id, amount, data) ==
1406                     ERC1155TokenReceiver.onERC1155Received.selector,
1407             "UNSAFE_RECIPIENT"
1408         );
1409     }
1410 
1411     function safeBatchTransferFrom(
1412         address from,
1413         address to,
1414         uint256[] calldata ids,
1415         uint256[] calldata amounts,
1416         bytes calldata data
1417     ) public virtual {
1418         require(ids.length == amounts.length, "LENGTH_MISMATCH");
1419 
1420         require(msg.sender == from || isApprovedForAll[from][msg.sender], "NOT_AUTHORIZED");
1421 
1422         // Storing these outside the loop saves ~15 gas per iteration.
1423         uint256 id;
1424         uint256 amount;
1425 
1426         for (uint256 i = 0; i < ids.length; ) {
1427             id = ids[i];
1428             amount = amounts[i];
1429 
1430             balanceOf[from][id] -= amount;
1431             balanceOf[to][id] += amount;
1432 
1433             // An array can't have a total length
1434             // larger than the max uint256 value.
1435             unchecked {
1436                 ++i;
1437             }
1438         }
1439 
1440         emit TransferBatch(msg.sender, from, to, ids, amounts);
1441 
1442         require(
1443             to.code.length == 0
1444                 ? to != address(0)
1445                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, from, ids, amounts, data) ==
1446                     ERC1155TokenReceiver.onERC1155BatchReceived.selector,
1447             "UNSAFE_RECIPIENT"
1448         );
1449     }
1450 
1451     function balanceOfBatch(address[] calldata owners, uint256[] calldata ids)
1452         public
1453         view
1454         virtual
1455         returns (uint256[] memory balances)
1456     {
1457         require(owners.length == ids.length, "LENGTH_MISMATCH");
1458 
1459         balances = new uint256[](owners.length);
1460 
1461         // Unchecked because the only math done is incrementing
1462         // the array index counter which cannot possibly overflow.
1463         unchecked {
1464             for (uint256 i = 0; i < owners.length; ++i) {
1465                 balances[i] = balanceOf[owners[i]][ids[i]];
1466             }
1467         }
1468     }
1469 
1470     /*//////////////////////////////////////////////////////////////
1471                               ERC165 LOGIC
1472     //////////////////////////////////////////////////////////////*/
1473 
1474     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
1475         return
1476             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
1477             interfaceId == 0xd9b67a26 || // ERC165 Interface ID for ERC1155
1478             interfaceId == 0x0e89341c; // ERC165 Interface ID for ERC1155MetadataURI
1479     }
1480 
1481     /*//////////////////////////////////////////////////////////////
1482                         INTERNAL MINT/BURN LOGIC
1483     //////////////////////////////////////////////////////////////*/
1484 
1485     function _mint(
1486         address to,
1487         uint256 id,
1488         uint256 amount,
1489         bytes memory data
1490     ) internal virtual {
1491         balanceOf[to][id] += amount;
1492 
1493         emit TransferSingle(msg.sender, address(0), to, id, amount);
1494 
1495         require(
1496             to.code.length == 0
1497                 ? to != address(0)
1498                 : ERC1155TokenReceiver(to).onERC1155Received(msg.sender, address(0), id, amount, data) ==
1499                     ERC1155TokenReceiver.onERC1155Received.selector,
1500             "UNSAFE_RECIPIENT"
1501         );
1502     }
1503 
1504     function _batchMint(
1505         address to,
1506         uint256[] memory ids,
1507         uint256[] memory amounts,
1508         bytes memory data
1509     ) internal virtual {
1510         uint256 idsLength = ids.length; // Saves MLOADs.
1511 
1512         require(idsLength == amounts.length, "LENGTH_MISMATCH");
1513 
1514         for (uint256 i = 0; i < idsLength; ) {
1515             balanceOf[to][ids[i]] += amounts[i];
1516 
1517             // An array can't have a total length
1518             // larger than the max uint256 value.
1519             unchecked {
1520                 ++i;
1521             }
1522         }
1523 
1524         emit TransferBatch(msg.sender, address(0), to, ids, amounts);
1525 
1526         require(
1527             to.code.length == 0
1528                 ? to != address(0)
1529                 : ERC1155TokenReceiver(to).onERC1155BatchReceived(msg.sender, address(0), ids, amounts, data) ==
1530                     ERC1155TokenReceiver.onERC1155BatchReceived.selector,
1531             "UNSAFE_RECIPIENT"
1532         );
1533     }
1534 
1535     function _batchBurn(
1536         address from,
1537         uint256[] memory ids,
1538         uint256[] memory amounts
1539     ) internal virtual {
1540         uint256 idsLength = ids.length; // Saves MLOADs.
1541 
1542         require(idsLength == amounts.length, "LENGTH_MISMATCH");
1543 
1544         for (uint256 i = 0; i < idsLength; ) {
1545             balanceOf[from][ids[i]] -= amounts[i];
1546 
1547             // An array can't have a total length
1548             // larger than the max uint256 value.
1549             unchecked {
1550                 ++i;
1551             }
1552         }
1553 
1554         emit TransferBatch(msg.sender, from, address(0), ids, amounts);
1555     }
1556 
1557     function _burn(
1558         address from,
1559         uint256 id,
1560         uint256 amount
1561     ) internal virtual {
1562         balanceOf[from][id] -= amount;
1563 
1564         emit TransferSingle(msg.sender, from, address(0), id, amount);
1565     }
1566 }
1567 
1568 /// @notice A generic interface for a contract which properly accepts ERC1155 tokens.
1569 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC1155.sol)
1570 abstract contract ERC1155TokenReceiver {
1571     function onERC1155Received(
1572         address,
1573         address,
1574         uint256,
1575         uint256,
1576         bytes calldata
1577     ) external virtual returns (bytes4) {
1578         return ERC1155TokenReceiver.onERC1155Received.selector;
1579     }
1580 
1581     function onERC1155BatchReceived(
1582         address,
1583         address,
1584         uint256[] calldata,
1585         uint256[] calldata,
1586         bytes calldata
1587     ) external virtual returns (bytes4) {
1588         return ERC1155TokenReceiver.onERC1155BatchReceived.selector;
1589     }
1590 }
1591 
1592 /// @title NFT Receiver
1593 /// @author Tessera
1594 /// @notice Plugin contract for handling receipts of non-fungible tokens
1595 contract NFTReceiver is ERC721TokenReceiver, ERC1155TokenReceiver {
1596     /// @notice Handles the receipt of a single ERC721 token
1597     function onERC721Received(
1598         address,
1599         address,
1600         uint256,
1601         bytes calldata
1602     ) external virtual override returns (bytes4) {
1603         return ERC721TokenReceiver.onERC721Received.selector;
1604     }
1605 
1606     /// @notice Handles the receipt of a single ERC1155 token type
1607     function onERC1155Received(
1608         address,
1609         address,
1610         uint256,
1611         uint256,
1612         bytes calldata
1613     ) external virtual override returns (bytes4) {
1614         return ERC1155TokenReceiver.onERC1155Received.selector;
1615     }
1616 
1617     /// @notice Handles the receipt of multiple ERC1155 token types
1618     function onERC1155BatchReceived(
1619         address,
1620         address,
1621         uint256[] calldata,
1622         uint256[] calldata,
1623         bytes calldata
1624     ) external virtual override returns (bytes4) {
1625         return ERC1155TokenReceiver.onERC1155BatchReceived.selector;
1626     }
1627 }
1628 
1629 /// @dev Interface for Minter module contract
1630 interface IMinter {
1631     function getPermissions() external view returns (Permission[] memory permissions);
1632 
1633     function supply() external view returns (address);
1634 }
1635 
1636 /// @title Minter
1637 /// @author Tessera
1638 /// @notice Module contract for minting a fixed supply of Raes
1639 contract Minter is IMinter, Module {
1640     /// @notice Address of Supply target contract
1641     address public immutable supply;
1642 
1643     /// @notice Initializes supply target contract
1644     constructor(address _supply) {
1645         supply = _supply;
1646     }
1647 
1648     /// @notice Gets the list of permissions installed on a vault
1649     /// @dev Permissions consist of a module contract, target contract, and function selector
1650     /// @return permissions A list of Permission Structs
1651     function getPermissions()
1652         public
1653         view
1654         virtual
1655         override(IMinter, Module)
1656         returns (Permission[] memory permissions)
1657     {
1658         permissions = new Permission[](1);
1659         permissions[0] = Permission(address(this), supply, ISupply.mint.selector);
1660     }
1661 
1662     /// @notice Mints a Rae supply
1663     /// @param _vault Address of the Vault
1664     /// @param _to Address of the receiver of Raes
1665     /// @param _raeSupply Number of NFT Raes minted to control the vault
1666     /// @param _mintProof List of proofs to execute a mint function
1667     function _mintRaes(
1668         address _vault,
1669         address _to,
1670         uint256 _raeSupply,
1671         bytes32[] calldata _mintProof
1672     ) internal {
1673         bytes memory data = abi.encodeCall(ISupply.mint, (_to, _raeSupply));
1674         IVault(payable(_vault)).execute(supply, data, _mintProof);
1675     }
1676 }
1677 
1678 /// @notice Gas optimized reentrancy protection for smart contracts.
1679 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ReentrancyGuard.sol)
1680 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol)
1681 abstract contract ReentrancyGuard {
1682     uint256 private locked = 1;
1683 
1684     modifier nonReentrant() virtual {
1685         require(locked == 1, "REENTRANCY");
1686 
1687         locked = 2;
1688 
1689         _;
1690 
1691         locked = 1;
1692     }
1693 }
1694 
1695 /// @dev Interface for ERC-721 token contract
1696 interface IERC721 {
1697     event Approval(address indexed _owner, address indexed _spender, uint256 indexed _id);
1698     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
1699     event Transfer(address indexed _from, address indexed _to, uint256 indexed _id);
1700 
1701     function approve(address _spender, uint256 _id) external;
1702 
1703     function balanceOf(address _owner) external view returns (uint256);
1704 
1705     function getApproved(uint256) external view returns (address);
1706 
1707     function isApprovedForAll(address, address) external view returns (bool);
1708 
1709     function name() external view returns (string memory);
1710 
1711     function ownerOf(uint256 _id) external view returns (address owner);
1712 
1713     function safeTransferFrom(
1714         address _from,
1715         address _to,
1716         uint256 _id
1717     ) external;
1718 
1719     function safeTransferFrom(
1720         address _from,
1721         address _to,
1722         uint256 _id,
1723         bytes memory _data
1724     ) external;
1725 
1726     function setApprovalForAll(address _operator, bool _approved) external;
1727 
1728     function supportsInterface(bytes4 _interfaceId) external view returns (bool);
1729 
1730     function symbol() external view returns (string memory);
1731 
1732     function tokenURI(uint256 _id) external view returns (string memory);
1733 
1734     function transferFrom(
1735         address _from,
1736         address _to,
1737         uint256 _id
1738     ) external;
1739 }
1740 
1741 /// @dev Interface for ERC-1155 token contract
1742 interface IERC1155 {
1743     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
1744     event TransferBatch(
1745         address indexed _operator,
1746         address indexed _from,
1747         address indexed _to,
1748         uint256[] _ids,
1749         uint256[] _amounts
1750     );
1751     event TransferSingle(
1752         address indexed _operator,
1753         address indexed _from,
1754         address indexed _to,
1755         uint256 _id,
1756         uint256 _amount
1757     );
1758     event URI(string _value, uint256 indexed _id);
1759 
1760     function balanceOf(address, uint256) external view returns (uint256);
1761 
1762     function balanceOfBatch(address[] memory _owners, uint256[] memory ids)
1763         external
1764         view
1765         returns (uint256[] memory balances);
1766 
1767     function isApprovedForAll(address, address) external view returns (bool);
1768 
1769     function safeBatchTransferFrom(
1770         address _from,
1771         address _to,
1772         uint256[] memory _ids,
1773         uint256[] memory _amounts,
1774         bytes memory _data
1775     ) external;
1776 
1777     function safeTransferFrom(
1778         address _from,
1779         address _to,
1780         uint256 _id,
1781         uint256 _amount,
1782         bytes memory _data
1783     ) external;
1784 
1785     function setApprovalForAll(address _operator, bool _approved) external;
1786 
1787     function supportsInterface(bytes4 _interfaceId) external view returns (bool);
1788 
1789     function uri(uint256 _id) external view returns (string memory);
1790 }
1791 
1792 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1793 
1794 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1795 
1796 /**
1797  * @dev Interface of the ERC165 standard, as defined in the
1798  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1799  *
1800  * Implementers can declare support of contract interfaces, which can then be
1801  * queried by others ({ERC165Checker}).
1802  *
1803  * For an implementation, see {ERC165}.
1804  */
1805 interface IERC165 {
1806     /**
1807      * @dev Returns true if this contract implements the interface defined by
1808      * `interfaceId`. See the corresponding
1809      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1810      * to learn more about how these ids are created.
1811      *
1812      * This function call must use less than 30 000 gas.
1813      */
1814     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1815 }
1816 
1817 /**
1818  * @dev Interface for the NFT Royalty Standard.
1819  *
1820  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1821  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1822  *
1823  * _Available since v4.5._
1824  */
1825 interface IERC2981 is IERC165 {
1826     /**
1827      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1828      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1829      */
1830     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1831         external
1832         view
1833         returns (address receiver, uint256 royaltyAmount);
1834 }
1835 
1836 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
1837 
1838 /// @title LPDA
1839 /// @author Tessera
1840 /// @notice Last Price Dutch Auction contract for distributing Raes
1841 contract LPDA is ILPDA, Protoform, Minter, ReentrancyGuard, SafeSend, NFTReceiver {
1842     using LibLPDAInfo for LPDAInfo;
1843     /// @notice Address of VaultRegistry contract
1844     address public immutable registry;
1845     /// @notice Address of Transfer target contract
1846     address public immutable transfer;
1847     /// @notice Address of fee receiver on initial distrubtion
1848     address public feeReceiver;
1849     /// @notice Max fee a curator will pay
1850     uint256 public constant MAX_FEE = 1250;
1851     /// @notice vault => user => total amount paid by user
1852     mapping(address => mapping(address => uint256)) public balanceContributed;
1853     /// @notice vault => user => total amount refunded to user
1854     mapping(address => mapping(address => uint256)) public balanceRefunded;
1855     /// @notice vault => user => total # of raes minted by user
1856     mapping(address => mapping(address => uint256)) public numMinted;
1857     /// @notice vault => royalty token
1858     mapping(address => address) public vaultRoyaltyToken;
1859     /// @notice vault => royalty token Id
1860     mapping(address => uint256) public vaultRoyaltyTokenId;
1861     /// @notice vault => auction info struct for LPDA
1862     mapping(address => LPDAInfo) public vaultLPDAInfo;
1863     /// @notice vault => enumerated list of minters for the LPDA
1864     mapping(address => address[]) public vaultLPDAMinters;
1865 
1866     constructor(
1867         address _registry,
1868         address _supply,
1869         address _transfer,
1870         address payable _weth,
1871         address _feeReceiver
1872     ) Minter(_supply) SafeSend(_weth) {
1873         registry = _registry;
1874         transfer = _transfer;
1875         feeReceiver = _feeReceiver;
1876     }
1877 
1878     /// @notice Deploys a new Vault and mints initial supply of Raes
1879     /// @param _modules The list of modules to be installed on the vault
1880     function deployVault(
1881         address[] calldata _modules,
1882         address[] calldata _plugins,
1883         bytes4[] calldata _selectors,
1884         LPDAInfo calldata _lpdaInfo,
1885         address _token,
1886         uint256 _id,
1887         bytes32[] calldata _mintProof
1888     ) external returns (address vault) {
1889         _lpdaInfo.validateAuctionInfo();
1890         bytes32[] memory leafNodes = generateMerkleTree(_modules);
1891         bytes32 merkleRoot = getRoot(leafNodes);
1892         vault = IVaultRegistry(registry).create(merkleRoot);
1893         if (IERC165(_token).supportsInterface(type(IERC2981).interfaceId))
1894             (vaultRoyaltyToken[vault] = _token, vaultRoyaltyTokenId[vault] = _id);
1895 
1896         vaultLPDAInfo[vault] = _lpdaInfo;
1897 
1898         IERC721(_token).transferFrom(msg.sender, vault, _id);
1899         _mintRaes(vault, address(this), _lpdaInfo.supply, _mintProof);
1900 
1901         emit ActiveModules(vault, _modules);
1902         emit CreatedLPDA(vault, _token, _id, _lpdaInfo);
1903     }
1904 
1905     /// @notice Enters a bid for a given vault
1906     /// @param _vault The vault to bid on raes for
1907     /// @param _amount The quantity of raes to bid for
1908     function enterBid(address _vault, uint16 _amount) external payable {
1909         LPDAInfo storage lpda = vaultLPDAInfo[_vault];
1910         uint256 price = currentPrice(_vault);
1911         lpda.validateAndRecordBid(uint128(price), _amount);
1912 
1913         vaultLPDAMinters[_vault].push(msg.sender);
1914         balanceContributed[_vault][msg.sender] += msg.value;
1915         numMinted[_vault][msg.sender] += _amount;
1916 
1917         emit BidEntered(_vault, msg.sender, _amount, price);
1918     }
1919 
1920     /// @notice Settles the auction for a given vault's LPDA
1921     /// @param _vault The vault to settle the LPDA for
1922     /// @param _minter The minter to settle their share of the LPDA
1923     function settleAddress(address _vault, address _minter) external nonReentrant {
1924         LPDAInfo memory lpda = vaultLPDAInfo[_vault];
1925         require(lpda.isOver(), "LPDA: Auction NOT over");
1926         uint256 amount = numMinted[_vault][_minter];
1927         delete numMinted[_vault][_minter];
1928         if (lpda.isSuccessful()) {
1929             (address token, uint256 id) = IVaultRegistry(registry).vaultToToken(_vault);
1930             IERC1155(token).safeTransferFrom(address(this), _minter, id, amount, "");
1931             _refundAddress(_vault, _minter, amount, lpda.minBid);
1932             emit MintedRaes(_vault, _minter, amount, lpda.minBid);
1933         } else if (lpda.isNotSuccessful()) {
1934             _refundAddress(_vault, _minter, amount, lpda.minBid);
1935         } else {
1936             revert("LPDA: Auction NOT over");
1937         }
1938     }
1939 
1940     /// @notice Settles the curators account for a given vault
1941     /// @notice _vault The vault to settle the curator for
1942     function settleCurator(address _vault) external nonReentrant {
1943         LPDAInfo storage lpda = vaultLPDAInfo[_vault];
1944         require(lpda.isSuccessful(), "LPDA: Not sold out");
1945         require(lpda.curatorClaimed == 0, "LPDA: Curator already claimed");
1946         uint256 total = lpda.minBid * lpda.numSold;
1947         uint256 min = lpda.endPrice * lpda.numSold;
1948         uint256 feePercent = MAX_FEE;
1949         if (min != 0) {
1950             uint256 diff = total - min;
1951             feePercent = ((diff * 1e18) / (min * 5) / 1e14) + 250;
1952             feePercent = feePercent > MAX_FEE ? MAX_FEE : feePercent;
1953         }
1954         uint256 fee = (feePercent * total) / 1e4;
1955         lpda.curatorClaimed += uint128(total);
1956         address token = vaultRoyaltyToken[_vault];
1957         uint256 id = vaultRoyaltyTokenId[_vault];
1958         (address royaltyReceiver, uint256 royaltyAmount) = token == address(0)
1959             ? (address(0), 0)
1960             : IERC2981(token).royaltyInfo(id, total);
1961         _sendEthOrWeth(royaltyReceiver, royaltyAmount);
1962         emit RoyaltyPaid(_vault, royaltyReceiver, royaltyAmount);
1963         _sendEthOrWeth(feeReceiver, fee);
1964         emit FeeDispersed(_vault, feeReceiver, fee);
1965         _sendEthOrWeth(lpda.curator, total - fee - royaltyAmount);
1966         emit CuratorClaimed(_vault, lpda.curator, total - fee - royaltyAmount);
1967     }
1968 
1969     /// @notice Redeems the curator's NFT for a given vault if the LPDA was unsuccessful
1970     /// @param _vault The vault to redeem the curator's NFT for
1971     /// @param _token The token contract to redeem
1972     /// @param _tokenId The tokenId to redeem
1973     /// @param _erc721TransferProof The proofs required to transfer the NFT
1974     function redeemNFTCurator(
1975         address _vault,
1976         address _token,
1977         uint256 _tokenId,
1978         bytes32[] calldata _erc721TransferProof
1979     ) external {
1980         LPDAInfo memory lpda = vaultLPDAInfo[_vault];
1981         require(lpda.isNotSuccessful(), "LPDA: Auction NOT Successful");
1982         require(msg.sender == lpda.curator, "LPDA: Not curator");
1983 
1984         bytes memory data = abi.encodeCall(
1985             ITransfer.ERC721TransferFrom,
1986             (_token, _vault, msg.sender, _tokenId)
1987         );
1988         IVault(payable(_vault)).execute(transfer, data, _erc721TransferProof);
1989 
1990         emit CuratorRedeemedNFT(_vault, msg.sender, _token, _tokenId);
1991     }
1992 
1993     /// @notice Transfer the feeReceiver account
1994     /// @param _receiver The new feeReceiver
1995     function updateFeeReceiver(address _receiver) external {
1996         require(msg.sender == feeReceiver, "LPDA: Not fee receiver");
1997         feeReceiver = _receiver;
1998     }
1999 
2000     /// @notice returns the current dutch auction price
2001     /// @param _vault The vault to get the current price of the LPDA for
2002     /// @return price The current price of the LPDA
2003     function currentPrice(address _vault) public view returns (uint256 price) {
2004         LPDAInfo memory lpda = vaultLPDAInfo[_vault];
2005         uint256 deduction = (block.timestamp - lpda.startTime) * lpda.dropPerSecond;
2006         price = (deduction > lpda.startPrice) ? 0 : lpda.startPrice - deduction;
2007         price = (price > lpda.endPrice) ? price : lpda.endPrice;
2008     }
2009 
2010     function getMinters(address _vault) public view returns (address[] memory) {
2011         return vaultLPDAMinters[_vault];
2012     }
2013 
2014     /// @notice returns the current lpda auction state for a vault
2015     /// @param _vault The vault to get the current auction state for
2016     function getAuctionState(address _vault) public view returns (LPDAState) {
2017         return vaultLPDAInfo[_vault].getAuctionState();
2018     }
2019 
2020     /// @notice Check the refund owned to an account
2021     /// @param _vault The vault to check the refund for
2022     /// @param _minter the acount to check the refund for
2023     /// @return The refund still owed to the minter account
2024     function refundOwed(address _vault, address _minter) public view returns (uint256) {
2025         LPDAInfo memory lpda = vaultLPDAInfo[_vault];
2026         uint256 totalCost = lpda.minBid * numMinted[_vault][_minter];
2027         uint256 alreadyRefunded = balanceRefunded[_vault][_minter];
2028         uint256 balance = balanceContributed[_vault][_minter];
2029         return balance - alreadyRefunded - totalCost;
2030     }
2031 
2032     /// @notice Gets the list of permissions installed on a vault
2033     /// @dev Permissions consist of a module contract, target contract, and function selector
2034     /// @return permissions A list of Permission Structs
2035     function getPermissions()
2036         public
2037         view
2038         virtual
2039         override(Minter)
2040         returns (Permission[] memory permissions)
2041     {
2042         permissions = new Permission[](2);
2043         permissions[0] = super.getPermissions()[0];
2044         permissions[1] = Permission(address(this), transfer, ITransfer.ERC721TransferFrom.selector);
2045     }
2046 
2047     function _refundAddress(
2048         address _vault,
2049         address _minter,
2050         uint256 _mints,
2051         uint128 _minBid
2052     ) internal {
2053         uint256 owed = balanceContributed[_vault][_minter];
2054         owed -= (_minBid * _mints + balanceRefunded[_vault][_minter]);
2055         if (owed > 0) {
2056             balanceRefunded[_vault][_minter] += owed;
2057             _sendEthOrWeth(_minter, owed);
2058             emit Refunded(_vault, _minter, owed);
2059         }
2060     }
2061 }