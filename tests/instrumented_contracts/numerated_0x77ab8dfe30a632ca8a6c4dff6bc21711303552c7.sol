1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes calldata) {
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
29 
30 pragma solidity ^0.8.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 abstract contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor() {
53         _setOwner(_msgSender());
54     }
55 
56     /**
57      * @dev Returns the address of the current owner.
58      */
59     function owner() public view virtual returns (address) {
60         return _owner;
61     }
62 
63     /**
64      * @dev Throws if called by any account other than the owner.
65      */
66     modifier onlyOwner() {
67         require(owner() == _msgSender(), "Ownable: caller is not the owner");
68         _;
69     }
70 
71     /**
72      * @dev Leaves the contract without owner. It will not be possible to call
73      * `onlyOwner` functions anymore. Can only be called by the current owner.
74      *
75      * NOTE: Renouncing ownership will leave the contract without an owner,
76      * thereby removing any functionality that is only available to the owner.
77      */
78     function renounceOwnership() public virtual onlyOwner {
79         _setOwner(address(0));
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         _setOwner(newOwner);
89     }
90 
91     function _setOwner(address newOwner) private {
92         address oldOwner = _owner;
93         _owner = newOwner;
94         emit OwnershipTransferred(oldOwner, newOwner);
95     }
96 }
97 
98 // File: @openzeppelin/contracts/security/Pausable.sol
99 
100 
101 pragma solidity ^0.8.0;
102 
103 /**
104  * @dev Contract module which allows children to implement an emergency stop
105  * mechanism that can be triggered by an authorized account.
106  *
107  * This module is used through inheritance. It will make available the
108  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
109  * the functions of your contract. Note that they will not be pausable by
110  * simply including this module, only once the modifiers are put in place.
111  */
112 abstract contract Pausable is Context {
113     /**
114      * @dev Emitted when the pause is triggered by `account`.
115      */
116     event Paused(address account);
117 
118     /**
119      * @dev Emitted when the pause is lifted by `account`.
120      */
121     event Unpaused(address account);
122 
123     bool private _paused;
124 
125     /**
126      * @dev Initializes the contract in unpaused state.
127      */
128     constructor() {
129         _paused = false;
130     }
131 
132     /**
133      * @dev Returns true if the contract is paused, and false otherwise.
134      */
135     function paused() public view virtual returns (bool) {
136         return _paused;
137     }
138 
139     /**
140      * @dev Modifier to make a function callable only when the contract is not paused.
141      *
142      * Requirements:
143      *
144      * - The contract must not be paused.
145      */
146     modifier whenNotPaused() {
147         require(!paused(), "Pausable: paused");
148         _;
149     }
150 
151     /**
152      * @dev Modifier to make a function callable only when the contract is paused.
153      *
154      * Requirements:
155      *
156      * - The contract must be paused.
157      */
158     modifier whenPaused() {
159         require(paused(), "Pausable: not paused");
160         _;
161     }
162 
163     /**
164      * @dev Triggers stopped state.
165      *
166      * Requirements:
167      *
168      * - The contract must not be paused.
169      */
170     function _pause() internal virtual whenNotPaused {
171         _paused = true;
172         emit Paused(_msgSender());
173     }
174 
175     /**
176      * @dev Returns to normal state.
177      *
178      * Requirements:
179      *
180      * - The contract must be paused.
181      */
182     function _unpause() internal virtual whenPaused {
183         _paused = false;
184         emit Unpaused(_msgSender());
185     }
186 }
187 
188 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
189 
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev These functions deal with verification of Merkle Trees proofs.
195  *
196  * The proofs can be generated using the JavaScript library
197  * https://github.com/miguelmota/merkletreejs[merkletreejs].
198  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
199  *
200  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
201  */
202 library MerkleProof {
203     /**
204      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
205      * defined by `root`. For this, a `proof` must be provided, containing
206      * sibling hashes on the branch from the leaf to the root of the tree. Each
207      * pair of leaves and each pair of pre-images are assumed to be sorted.
208      */
209     function verify(
210         bytes32[] memory proof,
211         bytes32 root,
212         bytes32 leaf
213     ) internal pure returns (bool) {
214         bytes32 computedHash = leaf;
215 
216         for (uint256 i = 0; i < proof.length; i++) {
217             bytes32 proofElement = proof[i];
218 
219             if (computedHash <= proofElement) {
220                 // Hash(current computed hash + current element of the proof)
221                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
222             } else {
223                 // Hash(current element of the proof + current computed hash)
224                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
225             }
226         }
227 
228         // Check if the computed hash (root) is equal to the provided root
229         return computedHash == root;
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
234 
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Interface of the ERC165 standard, as defined in the
240  * https://eips.ethereum.org/EIPS/eip-165[EIP].
241  *
242  * Implementers can declare support of contract interfaces, which can then be
243  * queried by others ({ERC165Checker}).
244  *
245  * For an implementation, see {ERC165}.
246  */
247 interface IERC165 {
248     /**
249      * @dev Returns true if this contract implements the interface defined by
250      * `interfaceId`. See the corresponding
251      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
252      * to learn more about how these ids are created.
253      *
254      * This function call must use less than 30 000 gas.
255      */
256     function supportsInterface(bytes4 interfaceId) external view returns (bool);
257 }
258 
259 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
260 
261 
262 pragma solidity ^0.8.0;
263 
264 /**
265  * @dev Implementation of the {IERC165} interface.
266  *
267  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
268  * for the additional interface id that will be supported. For example:
269  *
270  * ```solidity
271  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
272  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
273  * }
274  * ```
275  *
276  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
277  */
278 abstract contract ERC165 is IERC165 {
279     /**
280      * @dev See {IERC165-supportsInterface}.
281      */
282     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
283         return interfaceId == type(IERC165).interfaceId;
284     }
285 }
286 
287 // File: contracts/factory/extensions/INFTExtension.sol
288 
289 pragma solidity ^0.8.9;
290 
291 interface INFTExtension is IERC165 {
292 }
293 
294 interface INFTURIExtension is INFTExtension {
295     function tokenURI(uint256 tokenId) external view returns (string memory);
296 }
297 
298 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
299 
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @dev Required interface of an ERC721 compliant contract.
305  */
306 interface IERC721 is IERC165 {
307     /**
308      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
309      */
310     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
311 
312     /**
313      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
314      */
315     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
316 
317     /**
318      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
319      */
320     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
321 
322     /**
323      * @dev Returns the number of tokens in ``owner``'s account.
324      */
325     function balanceOf(address owner) external view returns (uint256 balance);
326 
327     /**
328      * @dev Returns the owner of the `tokenId` token.
329      *
330      * Requirements:
331      *
332      * - `tokenId` must exist.
333      */
334     function ownerOf(uint256 tokenId) external view returns (address owner);
335 
336     /**
337      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
338      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
339      *
340      * Requirements:
341      *
342      * - `from` cannot be the zero address.
343      * - `to` cannot be the zero address.
344      * - `tokenId` token must exist and be owned by `from`.
345      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
346      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
347      *
348      * Emits a {Transfer} event.
349      */
350     function safeTransferFrom(
351         address from,
352         address to,
353         uint256 tokenId
354     ) external;
355 
356     /**
357      * @dev Transfers `tokenId` token from `from` to `to`.
358      *
359      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
360      *
361      * Requirements:
362      *
363      * - `from` cannot be the zero address.
364      * - `to` cannot be the zero address.
365      * - `tokenId` token must be owned by `from`.
366      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
367      *
368      * Emits a {Transfer} event.
369      */
370     function transferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
378      * The approval is cleared when the token is transferred.
379      *
380      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
381      *
382      * Requirements:
383      *
384      * - The caller must own the token or be an approved operator.
385      * - `tokenId` must exist.
386      *
387      * Emits an {Approval} event.
388      */
389     function approve(address to, uint256 tokenId) external;
390 
391     /**
392      * @dev Returns the account approved for `tokenId` token.
393      *
394      * Requirements:
395      *
396      * - `tokenId` must exist.
397      */
398     function getApproved(uint256 tokenId) external view returns (address operator);
399 
400     /**
401      * @dev Approve or remove `operator` as an operator for the caller.
402      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
403      *
404      * Requirements:
405      *
406      * - The `operator` cannot be the caller.
407      *
408      * Emits an {ApprovalForAll} event.
409      */
410     function setApprovalForAll(address operator, bool _approved) external;
411 
412     /**
413      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
414      *
415      * See {setApprovalForAll}
416      */
417     function isApprovedForAll(address owner, address operator) external view returns (bool);
418 
419     /**
420      * @dev Safely transfers `tokenId` token from `from` to `to`.
421      *
422      * Requirements:
423      *
424      * - `from` cannot be the zero address.
425      * - `to` cannot be the zero address.
426      * - `tokenId` token must exist and be owned by `from`.
427      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
428      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
429      *
430      * Emits a {Transfer} event.
431      */
432     function safeTransferFrom(
433         address from,
434         address to,
435         uint256 tokenId,
436         bytes calldata data
437     ) external;
438 }
439 
440 // File: contracts/factory/IMetaverseNFT.sol
441 
442 pragma solidity ^0.8.9;
443 
444 interface IAvatarNFT {
445     function DEVELOPER() external pure returns (string memory _url);
446     function DEVELOPER_ADDRESS() external pure returns (address payable _dev);
447 
448     // ------ View functions ------
449     function saleStarted() external view returns (bool);
450     function isExtensionAdded(address extension) external view returns (bool);
451 
452     /**
453         Extra information stored for each tokenId. Optional, provided on mint
454      */
455     function data(uint256 tokenId) external view returns (bytes32);
456 
457     // ------ Mint functions ------
458     /**
459         Mint from NFTExtension contract. Optionally provide data parameter.
460      */
461     function mintExternal(uint256 tokenId, address to, bytes32 data) external payable;
462 
463     // ------ Admin functions ------
464     function addExtension(address extension) external;
465     function revokeExtension(address extension) external;
466     function withdraw() external;
467 }
468 
469 
470 interface IMetaverseNFT is IAvatarNFT {
471     // ------ View functions ------
472     /**
473         Recommended royalty for tokenId sale.
474      */
475     function royaltyInfo(uint256 tokenId, uint256 salePrice) external view returns (address receiver, uint256 royaltyAmount);
476     function totalSupply() external view returns (uint256);
477 
478     // ------ Admin functions ------
479     function setRoyaltyReceiver(address receiver) external;
480     function setRoyaltyFee(uint256 fee) external;
481 }
482 
483 // File: contracts/factory/extensions/NFTExtension.sol
484 
485 pragma solidity ^0.8.9;
486 
487 
488 contract NFTExtension is INFTExtension, ERC165 {
489     IMetaverseNFT public immutable nft;
490 
491     constructor(address _nft) {
492         nft = IMetaverseNFT(_nft);
493     }
494 
495     function beforeMint() internal view {
496         require(nft.isExtensionAdded(address(this)), "NFTExtension: this contract is not allowed to be used as an extension");
497     }
498 
499     function supportsInterface(bytes4 interfaceId) public virtual override(IERC165, ERC165) view returns (bool) {
500         return interfaceId == type(INFTExtension).interfaceId || super.supportsInterface(interfaceId);
501     }
502 
503 }
504 
505 // File: contracts/factory/extensions/SaleControl.sol
506 
507 pragma solidity ^0.8.9;
508 
509 abstract contract SaleControl is Ownable {
510 
511     uint256 public constant __SALE_NEVER_STARTS = 2**256 - 1;
512 
513     uint256 public startTimestamp = __SALE_NEVER_STARTS;
514 
515     modifier whenSaleStarted {
516         require(saleStarted(), "Sale not started yet");
517         _;
518     }
519 
520     function updateStartTimestamp(uint256 _startTimestamp) public onlyOwner {
521         startTimestamp = _startTimestamp;
522     }
523 
524     function startSale() public onlyOwner {
525         startTimestamp = block.timestamp;
526     }
527 
528     function stopSale() public onlyOwner {
529         startTimestamp = __SALE_NEVER_STARTS;
530     }
531 
532     function saleStarted() public view returns (bool) {
533         return block.timestamp >= startTimestamp;
534     }
535 }
536 
537 // File: contracts/factory/extensions/PresaleListExtension.sol
538 
539 pragma solidity ^0.8.9;
540 
541 
542 
543 
544 contract PresaleListExtension is NFTExtension, Ownable, SaleControl {
545 
546     uint256 public price;
547     uint256 public maxPerAddress;
548 
549     bytes32 public whitelistRoot;
550 
551     mapping (address => uint256) public claimedByAddress;
552 
553     constructor(address _nft, bytes32 _whitelistRoot, uint256 _price, uint256 _maxPerAddress) NFTExtension(_nft) SaleControl() {
554         stopSale();
555 
556         price = _price;
557         maxPerAddress = _maxPerAddress;
558         whitelistRoot = _whitelistRoot;
559     }
560 
561     function updatePrice(uint256 _price) public onlyOwner {
562         price = _price;
563     }
564 
565     function updateMaxPerAddress(uint256 _maxPerAddress) public onlyOwner {
566         maxPerAddress = _maxPerAddress;
567     }
568 
569     function updateWhitelistRoot(bytes32 _whitelistRoot) public onlyOwner {
570         whitelistRoot = _whitelistRoot;
571     }
572 
573     function mint(uint256 nTokens, bytes32[] memory proof) external whenSaleStarted payable {
574 
575         require(isWhitelisted(whitelistRoot, msg.sender, proof), "Not whitelisted");
576 
577         require(claimedByAddress[msg.sender] + nTokens <= maxPerAddress, "Cannot claim more per address");
578 
579         require(msg.value >= nTokens * price, "Not enough ETH to mint");
580 
581         claimedByAddress[msg.sender] += nTokens;
582 
583         nft.mintExternal{ value: msg.value }(nTokens, msg.sender, bytes32(0x0));
584 
585     }
586 
587     function isWhitelisted(bytes32 root, address receiver, bytes32[] memory proof) public pure returns (bool) {
588         bytes32 leaf = keccak256(abi.encodePacked(receiver));
589 
590         return MerkleProof.verify(proof, root, leaf);
591     }
592 
593 }
