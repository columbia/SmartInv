1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-23
3 */
4 
5 //     _   ____________  _   __   ____  __    _______  ____  _______
6 //    / | / / ____/ __ \/ | / /  / __ \/ /   / ____/ |/ / / / / ___/
7 //   /  |/ / __/ / / / /  |/ /  / /_/ / /   / __/  |   / / / /\__ \ 
8 //  / /|  / /___/ /_/ / /|  /  / ____/ /___/ /___ /   / /_/ /___/ / 
9 // /_/_|_/_____/\____/_/_|_/  /_/_  /_____/_____//_/|_\____//____/  
10 //  / __ \ |  / / ____/ __ \/ __ \/  _/ __ \/ ____/                
11 //  / / / / | / / __/ / /_/ / /_/ // // / / / __/                   
12 // / /_/ /| |/ / /___/ _, _/ _, _// // /_/ / /___                   
13 // \____/ |___/_____/_/ |_/_/ |_/___/_____/_____/                   
14                                                                  
15 // NEON PLEXUS: Override created by pixelpolyn8r & team
16 
17 // Sources flattened with hardhat v2.9.3 https://hardhat.org
18 
19 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
20 
21 // 
22 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
23 
24 pragma solidity ^0.8.0;
25 
26 /**
27  * @dev Interface of the ERC165 standard, as defined in the
28  * https://eips.ethereum.org/EIPS/eip-165[EIP].
29  *
30  * Implementers can declare support of contract interfaces, which can then be
31  * queried by others ({ERC165Checker}).
32  *
33  * For an implementation, see {ERC165}.
34  */
35 interface IERC165 {
36     /**
37      * @dev Returns true if this contract implements the interface defined by
38      * `interfaceId`. See the corresponding
39      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
40      * to learn more about how these ids are created.
41      *
42      * This function call must use less than 30 000 gas.
43      */
44     function supportsInterface(bytes4 interfaceId) external view returns (bool);
45 }
46 
47 
48 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
49 
50 // 
51 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Required interface of an ERC721 compliant contract.
57  */
58 interface IERC721 is IERC165 {
59     /**
60      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
61      */
62     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
63 
64     /**
65      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
66      */
67     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
68 
69     /**
70      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
71      */
72     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
73 
74     /**
75      * @dev Returns the number of tokens in ``owner``'s account.
76      */
77     function balanceOf(address owner) external view returns (uint256 balance);
78 
79     /**
80      * @dev Returns the owner of the `tokenId` token.
81      *
82      * Requirements:
83      *
84      * - `tokenId` must exist.
85      */
86     function ownerOf(uint256 tokenId) external view returns (address owner);
87 
88     /**
89      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
90      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
91      *
92      * Requirements:
93      *
94      * - `from` cannot be the zero address.
95      * - `to` cannot be the zero address.
96      * - `tokenId` token must exist and be owned by `from`.
97      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
98      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
99      *
100      * Emits a {Transfer} event.
101      */
102     function safeTransferFrom(
103         address from,
104         address to,
105         uint256 tokenId
106     ) external;
107 
108     /**
109      * @dev Transfers `tokenId` token from `from` to `to`.
110      *
111      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
112      *
113      * Requirements:
114      *
115      * - `from` cannot be the zero address.
116      * - `to` cannot be the zero address.
117      * - `tokenId` token must be owned by `from`.
118      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transferFrom(
123         address from,
124         address to,
125         uint256 tokenId
126     ) external;
127 
128     /**
129      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
130      * The approval is cleared when the token is transferred.
131      *
132      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
133      *
134      * Requirements:
135      *
136      * - The caller must own the token or be an approved operator.
137      * - `tokenId` must exist.
138      *
139      * Emits an {Approval} event.
140      */
141     function approve(address to, uint256 tokenId) external;
142 
143     /**
144      * @dev Returns the account approved for `tokenId` token.
145      *
146      * Requirements:
147      *
148      * - `tokenId` must exist.
149      */
150     function getApproved(uint256 tokenId) external view returns (address operator);
151 
152     /**
153      * @dev Approve or remove `operator` as an operator for the caller.
154      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
155      *
156      * Requirements:
157      *
158      * - The `operator` cannot be the caller.
159      *
160      * Emits an {ApprovalForAll} event.
161      */
162     function setApprovalForAll(address operator, bool _approved) external;
163 
164     /**
165      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
166      *
167      * See {setApprovalForAll}
168      */
169     function isApprovedForAll(address owner, address operator) external view returns (bool);
170 
171     /**
172      * @dev Safely transfers `tokenId` token from `from` to `to`.
173      *
174      * Requirements:
175      *
176      * - `from` cannot be the zero address.
177      * - `to` cannot be the zero address.
178      * - `tokenId` token must exist and be owned by `from`.
179      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
180      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
181      *
182      * Emits a {Transfer} event.
183      */
184     function safeTransferFrom(
185         address from,
186         address to,
187         uint256 tokenId,
188         bytes calldata data
189     ) external;
190 }
191 
192 
193 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
194 
195 // 
196 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
202  * @dev See https://eips.ethereum.org/EIPS/eip-721
203  */
204 interface IERC721Enumerable is IERC721 {
205     /**
206      * @dev Returns the total amount of tokens stored by the contract.
207      */
208     function totalSupply() external view returns (uint256);
209 
210     /**
211      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
212      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
213      */
214     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
215 
216     /**
217      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
218      * Use along with {totalSupply} to enumerate all tokens.
219      */
220     function tokenByIndex(uint256 index) external view returns (uint256);
221 }
222 
223 
224 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
225 
226 // 
227 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Provides information about the current execution context, including the
233  * sender of the transaction and its data. While these are generally available
234  * via msg.sender and msg.data, they should not be accessed in such a direct
235  * manner, since when dealing with meta-transactions the account sending and
236  * paying for execution may not be the actual sender (as far as an application
237  * is concerned).
238  *
239  * This contract is only required for intermediate, library-like contracts.
240  */
241 abstract contract Context {
242     function _msgSender() internal view virtual returns (address) {
243         return msg.sender;
244     }
245 
246     function _msgData() internal view virtual returns (bytes calldata) {
247         return msg.data;
248     }
249 }
250 
251 
252 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
253 
254 // 
255 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
256 
257 pragma solidity ^0.8.0;
258 
259 /**
260  * @dev Contract module which provides a basic access control mechanism, where
261  * there is an account (an owner) that can be granted exclusive access to
262  * specific functions.
263  *
264  * By default, the owner account will be the one that deploys the contract. This
265  * can later be changed with {transferOwnership}.
266  *
267  * This module is used through inheritance. It will make available the modifier
268  * `onlyOwner`, which can be applied to your functions to restrict their use to
269  * the owner.
270  */
271 abstract contract Ownable is Context {
272     address private _owner;
273 
274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
275 
276     /**
277      * @dev Initializes the contract setting the deployer as the initial owner.
278      */
279     constructor() {
280         _transferOwnership(_msgSender());
281     }
282 
283     /**
284      * @dev Returns the address of the current owner.
285      */
286     function owner() public view virtual returns (address) {
287         return _owner;
288     }
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     /**
299      * @dev Leaves the contract without owner. It will not be possible to call
300      * `onlyOwner` functions anymore. Can only be called by the current owner.
301      *
302      * NOTE: Renouncing ownership will leave the contract without an owner,
303      * thereby removing any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public virtual onlyOwner {
306         _transferOwnership(address(0));
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(newOwner != address(0), "Ownable: new owner is the zero address");
315         _transferOwnership(newOwner);
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Internal function without access restriction.
321      */
322     function _transferOwnership(address newOwner) internal virtual {
323         address oldOwner = _owner;
324         _owner = newOwner;
325         emit OwnershipTransferred(oldOwner, newOwner);
326     }
327 }
328 
329 
330 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
331 
332 // 
333 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
334 
335 pragma solidity ^0.8.0;
336 
337 /**
338  * @dev Contract module which allows children to implement an emergency stop
339  * mechanism that can be triggered by an authorized account.
340  *
341  * This module is used through inheritance. It will make available the
342  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
343  * the functions of your contract. Note that they will not be pausable by
344  * simply including this module, only once the modifiers are put in place.
345  */
346 abstract contract Pausable is Context {
347     /**
348      * @dev Emitted when the pause is triggered by `account`.
349      */
350     event Paused(address account);
351 
352     /**
353      * @dev Emitted when the pause is lifted by `account`.
354      */
355     event Unpaused(address account);
356 
357     bool private _paused;
358 
359     /**
360      * @dev Initializes the contract in unpaused state.
361      */
362     constructor() {
363         _paused = false;
364     }
365 
366     /**
367      * @dev Returns true if the contract is paused, and false otherwise.
368      */
369     function paused() public view virtual returns (bool) {
370         return _paused;
371     }
372 
373     /**
374      * @dev Modifier to make a function callable only when the contract is not paused.
375      *
376      * Requirements:
377      *
378      * - The contract must not be paused.
379      */
380     modifier whenNotPaused() {
381         require(!paused(), "Pausable: paused");
382         _;
383     }
384 
385     /**
386      * @dev Modifier to make a function callable only when the contract is paused.
387      *
388      * Requirements:
389      *
390      * - The contract must be paused.
391      */
392     modifier whenPaused() {
393         require(paused(), "Pausable: not paused");
394         _;
395     }
396 
397     /**
398      * @dev Triggers stopped state.
399      *
400      * Requirements:
401      *
402      * - The contract must not be paused.
403      */
404     function _pause() internal virtual whenNotPaused {
405         _paused = true;
406         emit Paused(_msgSender());
407     }
408 
409     /**
410      * @dev Returns to normal state.
411      *
412      * Requirements:
413      *
414      * - The contract must be paused.
415      */
416     function _unpause() internal virtual whenPaused {
417         _paused = false;
418         emit Unpaused(_msgSender());
419     }
420 }
421 
422 
423 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.5.0
424 
425 // 
426 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 /**
431  * @dev Contract module that helps prevent reentrant calls to a function.
432  *
433  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
434  * available, which can be applied to functions to make sure there are no nested
435  * (reentrant) calls to them.
436  *
437  * Note that because there is a single `nonReentrant` guard, functions marked as
438  * `nonReentrant` may not call one another. This can be worked around by making
439  * those functions `private`, and then adding `external` `nonReentrant` entry
440  * points to them.
441  *
442  * TIP: If you would like to learn more about reentrancy and alternative ways
443  * to protect against it, check out our blog post
444  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
445  */
446 abstract contract ReentrancyGuard {
447     // Booleans are more expensive than uint256 or any type that takes up a full
448     // word because each write operation emits an extra SLOAD to first read the
449     // slot's contents, replace the bits taken up by the boolean, and then write
450     // back. This is the compiler's defense against contract upgrades and
451     // pointer aliasing, and it cannot be disabled.
452 
453     // The values being non-zero value makes deployment a bit more expensive,
454     // but in exchange the refund on every call to nonReentrant will be lower in
455     // amount. Since refunds are capped to a percentage of the total
456     // transaction's gas, it is best to keep them low in cases like this one, to
457     // increase the likelihood of the full refund coming into effect.
458     uint256 private constant _NOT_ENTERED = 1;
459     uint256 private constant _ENTERED = 2;
460 
461     uint256 private _status;
462 
463     constructor() {
464         _status = _NOT_ENTERED;
465     }
466 
467     /**
468      * @dev Prevents a contract from calling itself, directly or indirectly.
469      * Calling a `nonReentrant` function from another `nonReentrant`
470      * function is not supported. It is possible to prevent this from happening
471      * by making the `nonReentrant` function external, and making it call a
472      * `private` function that does the actual work.
473      */
474     modifier nonReentrant() {
475         // On the first call to nonReentrant, _notEntered will be true
476         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
477 
478         // Any calls to nonReentrant after this point will fail
479         _status = _ENTERED;
480 
481         _;
482 
483         // By storing the original value once again, a refund is triggered (see
484         // https://eips.ethereum.org/EIPS/eip-2200)
485         _status = _NOT_ENTERED;
486     }
487 }
488 
489 
490 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
491 
492 // 
493 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev These functions deal with verification of Merkle Trees proofs.
499  *
500  * The proofs can be generated using the JavaScript library
501  * https://github.com/miguelmota/merkletreejs[merkletreejs].
502  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
503  *
504  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
505  */
506 library MerkleProof {
507     /**
508      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
509      * defined by `root`. For this, a `proof` must be provided, containing
510      * sibling hashes on the branch from the leaf to the root of the tree. Each
511      * pair of leaves and each pair of pre-images are assumed to be sorted.
512      */
513     function verify(
514         bytes32[] memory proof,
515         bytes32 root,
516         bytes32 leaf
517     ) internal pure returns (bool) {
518         return processProof(proof, leaf) == root;
519     }
520 
521     /**
522      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
523      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
524      * hash matches the root of the tree. When processing the proof, the pairs
525      * of leafs & pre-images are assumed to be sorted.
526      *
527      * _Available since v4.4._
528      */
529     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
530         bytes32 computedHash = leaf;
531         for (uint256 i = 0; i < proof.length; i++) {
532             bytes32 proofElement = proof[i];
533             if (computedHash <= proofElement) {
534                 // Hash(current computed hash + current element of the proof)
535                 computedHash = _efficientHash(computedHash, proofElement);
536             } else {
537                 // Hash(current element of the proof + current computed hash)
538                 computedHash = _efficientHash(proofElement, computedHash);
539             }
540         }
541         return computedHash;
542     }
543 
544     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
545         assembly {
546             mstore(0x00, a)
547             mstore(0x20, b)
548             value := keccak256(0x00, 0x40)
549         }
550     }
551 }
552 
553 
554 // File contracts/OverrideNftSaleV2.sol
555 
556 // 
557 pragma solidity ^0.8.9;
558 
559 
560 
561 
562 
563 interface IOverrideNftSaleV2 { 
564   function mintBatch(address to, uint256[] memory tokenIds) external;
565 }
566 
567 contract OverrideNftSaleV2 is Ownable, Pausable, ReentrancyGuard {
568 
569     uint256 constant FREE_INDEX = 0;
570     uint256 constant PREMIUM_DISCOUNT_INDEX = 1;
571     uint256 constant DISCOUNT_INDEX = 2;
572 
573     uint256 public constant MAX_SUPPLY = 9000;
574     uint256 public constant MAX_TREASURY_SUPPLY = 100;
575     uint256 public maxMintPerTx = 10;
576 
577     bytes32 public freeRoot;
578     bytes32 public premiumDiscountRoot;
579     bytes32 public discountRoot;
580 
581     address public nftContract;
582     uint256 public treasuryTotalSupply = MAX_TREASURY_SUPPLY;
583 
584     uint64 public freeMinted;
585     uint64 public premiumDiscountMinted;
586     uint64 public discountMinted;
587 
588     uint256 public constant PRICE = 0.08 ether;
589     uint256 public constant DISCOUNT_PRICE = 0.07 ether;
590     uint256 public constant PREMIUM_DISCOUNT_PRICE = 0.06 ether;
591 
592     uint256 public whitelistStartTime; // See whitelistMint
593     uint256 public whitelistEndTime; // See whitelistMint
594     uint256 public saleStartTime; // See saleMint
595 
596     // uncompressed balances by type
597     mapping(address => uint64) freeMints;
598     mapping(address => uint64) premiumDiscountMints;
599     mapping(address => uint64) discountMints;
600 
601     event Minted(address sender, uint256 count);
602     event Reserved(address sender, uint256 count);
603 
604     constructor(address _nftContract, 
605         uint256 _whitelistStartTime,
606         uint256 _whitelistEndTime, 
607         uint256 _saleStartTime) Ownable() ReentrancyGuard() {
608         nftContract = _nftContract;
609         whitelistStartTime = _whitelistStartTime;
610         whitelistEndTime = _whitelistEndTime;
611         saleStartTime = _saleStartTime;
612     }
613 
614     modifier callerIsUser() {
615         require(tx.origin == msg.sender, "The caller is another contract");
616         _;
617     }
618 
619     function withdrawETH() external onlyOwner {
620         payable(msg.sender).transfer(address(this).balance);
621     }
622 
623     function setTimes(uint256 _whitelistStartTime, uint256 _whitelistEndTime, uint256 _saleStartTime) external onlyOwner {
624         whitelistStartTime = _whitelistStartTime;
625         whitelistEndTime = _whitelistEndTime;
626         saleStartTime = _saleStartTime;
627     }
628 
629     function setWhitelistRoots(bytes32 _freeRoot, bytes32 _premiumDiscountRoot, bytes32 _discountRoot) external onlyOwner {
630         freeRoot = _freeRoot;
631         premiumDiscountRoot = _premiumDiscountRoot;
632         discountRoot = _discountRoot;
633     }
634 
635     function setNftContract(address _nftContract) public onlyOwner {
636         nftContract = _nftContract;
637     }
638 
639     function setMaxMintPerTx(uint256 _maxMintPerTx) public onlyOwner {
640         maxMintPerTx = _maxMintPerTx;
641     }
642     
643     function freeBalance(address who) external view returns (uint256) {
644         return freeMints[who];
645     }
646 
647     function premiumDiscountBalance(address who) external view returns (uint256) {
648         return premiumDiscountMints[who];
649     }
650 
651     function discountBalance(address who) external view returns (uint256) {
652         return discountMints[who];
653     }
654 
655     //NOTE:compbow Plan to mint during Whitelist Sale
656     function treasuryMint() public onlyOwner {
657         require(treasuryTotalSupply == MAX_TREASURY_SUPPLY, "treasury already minted");
658 
659         uint256 targetMintIndex = currentMintIndex();
660 
661         require(
662         targetMintIndex + MAX_TREASURY_SUPPLY <= MAX_SUPPLY,
663         "not enough remaining reserved for auction to support desired mint amount"
664         );
665 
666         uint256[] memory ids = new uint256[](MAX_TREASURY_SUPPLY);
667         for (uint256 i; i < MAX_TREASURY_SUPPLY; ++i) {
668             ids[i] = targetMintIndex + i;
669         }
670 
671         IOverrideNftSaleV2(nftContract).mintBatch(msg.sender, ids);
672 
673         treasuryTotalSupply = treasuryTotalSupply - MAX_TREASURY_SUPPLY;
674 
675         emit Minted(msg.sender, MAX_TREASURY_SUPPLY);
676     }
677 
678     function whitelistMint(uint256[3] calldata amountsToBuy, 
679         uint256[3] calldata amounts, 
680         uint256[3] calldata indexes, 
681         bytes32[][3] calldata merkleProof) external payable nonReentrant callerIsUser {
682 
683         require(whitelistStartTime != 0 && block.timestamp >= whitelistStartTime,"whitelist mint has not started yet");
684         require(block.timestamp < whitelistEndTime, "whitelist mint has ended");
685         require(amountsToBuy.length == 3, "Not right length");
686         require(amountsToBuy.length == amounts.length, "Not equal amounts");
687         require(amounts.length == indexes.length, "Not equal indexes");
688         require(indexes.length == merkleProof.length, "Not equal proof");
689 
690         uint256 expectedPayment;
691         if (merkleProof[PREMIUM_DISCOUNT_INDEX].length != 0) {
692             expectedPayment += amountsToBuy[PREMIUM_DISCOUNT_INDEX]*PREMIUM_DISCOUNT_PRICE;
693         }
694         if (merkleProof[DISCOUNT_INDEX].length != 0) {
695             expectedPayment += amountsToBuy[DISCOUNT_INDEX]*DISCOUNT_PRICE;
696         } 
697         require(msg.value == expectedPayment, "Not right ETH sent");
698 
699         uint256 quantity;
700         if (merkleProof[FREE_INDEX].length != 0 && amountsToBuy[FREE_INDEX] > 0) {
701             require(freeRoot.length != 0, "free root not assigned");
702             bytes32 node = keccak256(abi.encodePacked(indexes[FREE_INDEX], msg.sender, amounts[FREE_INDEX]));
703             require(MerkleProof.verify(merkleProof[FREE_INDEX], freeRoot, node), 'MerkleProof: Invalid team proof.');
704             require(amountsToBuy[FREE_INDEX] <= amounts[FREE_INDEX], "Free Cant buy this many: too many");
705             require(((amounts[FREE_INDEX] - freeMints[msg.sender]) - amountsToBuy[FREE_INDEX]) >= 0, "Free Cant buy this many: too few");
706             uint256 amountToBuy = amountsToBuy[FREE_INDEX];
707             quantity += amountToBuy;
708             freeMinted += uint64(amountToBuy);
709             freeMints[msg.sender] += uint64(amountToBuy);
710         }
711         if (merkleProof[PREMIUM_DISCOUNT_INDEX].length != 0 && amountsToBuy[PREMIUM_DISCOUNT_INDEX] > 0) {
712             require(premiumDiscountRoot.length != 0, "Premium Discount root not assigned");
713             bytes32 node = keccak256(abi.encodePacked(indexes[PREMIUM_DISCOUNT_INDEX], msg.sender, amounts[PREMIUM_DISCOUNT_INDEX]));
714             require(MerkleProof.verify(merkleProof[PREMIUM_DISCOUNT_INDEX], premiumDiscountRoot, node), 'MerkleProof: Invalid uwu proof.');
715             require(amountsToBuy[PREMIUM_DISCOUNT_INDEX] <= amounts[PREMIUM_DISCOUNT_INDEX], "Premium Discount Cant buy this many");
716             require(((amounts[PREMIUM_DISCOUNT_INDEX] - premiumDiscountMints[msg.sender]) - amountsToBuy[PREMIUM_DISCOUNT_INDEX]) >= 0, "Premium Discount Cant buy this many: too few");
717             uint256 amountToBuy = amountsToBuy[PREMIUM_DISCOUNT_INDEX];
718             quantity += amountToBuy;
719             premiumDiscountMinted += uint64(amountToBuy);
720             premiumDiscountMints[msg.sender] += uint64(amountToBuy);
721         }
722         if (merkleProof[DISCOUNT_INDEX].length != 0 && amountsToBuy[DISCOUNT_INDEX] > 0) {
723             require(discountRoot.length != 0, "Discount root not assigned");
724             bytes32 node = keccak256(abi.encodePacked(indexes[DISCOUNT_INDEX], msg.sender, amounts[DISCOUNT_INDEX]));
725             require(MerkleProof.verify(merkleProof[DISCOUNT_INDEX], discountRoot, node), 'MerkleProof: Invalid wl proof.');
726             require(amountsToBuy[DISCOUNT_INDEX] <= amounts[DISCOUNT_INDEX], "Discount Cant buy this many");
727             require(((amounts[DISCOUNT_INDEX] - discountMints[msg.sender]) - amountsToBuy[DISCOUNT_INDEX]) >= 0, "Discount Cant buy this many: too few");
728             uint256 amountToBuy = amountsToBuy[DISCOUNT_INDEX];
729             quantity += amountToBuy;
730             discountMinted += uint64(amountToBuy);
731             discountMints[msg.sender] += uint64(amountToBuy);
732         }  
733 
734         uint256 targetMintIndex = currentMintIndex();
735 
736         require(targetMintIndex + quantity <= MAX_SUPPLY,
737             "not enough remaining reserved for auction to support desired mint amount");
738 
739         uint256[] memory ids = new uint256[](quantity);
740         for (uint256 i; i < quantity; ++i) {
741             ids[i] = targetMintIndex + i;
742         }
743 
744         IOverrideNftSaleV2(nftContract).mintBatch(msg.sender, ids);
745 
746         emit Reserved(msg.sender, quantity);
747     }
748 
749     function saleMint(uint256 quantity) external payable nonReentrant callerIsUser {
750 
751         require(quantity > 0, "Cannot mint 0");
752         require(quantity <= maxMintPerTx, "per tx limit: can not mint this many in a tx");
753         require(
754         saleStartTime != 0 && block.timestamp >= saleStartTime,
755         "sale mint has not started yet"
756         );
757 
758         require(msg.value == quantity * PRICE, "Not right ETH sent");
759 
760         uint256 targetMintIndex = currentMintIndex();
761 
762         require(targetMintIndex + quantity <= MAX_SUPPLY, "Sold out! Sorry!");
763 
764         uint256[] memory ids = new uint256[](quantity);
765         for (uint256 i; i < quantity; ++i) {
766             ids[i] = targetMintIndex + i;
767         }
768 
769         IOverrideNftSaleV2(nftContract).mintBatch(msg.sender, ids);
770 
771         emit Minted(msg.sender, quantity);
772     }
773 
774     function currentMintIndex() public view returns (uint256) {
775         return totalSupply() + 1;
776     }
777 
778     function totalSupply() public view returns (uint256) {
779         // remaining supply
780         return IERC721Enumerable(nftContract).totalSupply();
781     }
782 }