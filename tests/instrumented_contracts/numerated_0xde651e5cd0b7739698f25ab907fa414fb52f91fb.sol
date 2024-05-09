1 // SPDX-License-Identifier: MIT
2 
3 // Scroll down to the bottom to find the contract of interest. 
4 
5 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
6 
7 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev These functions deal with verification of Merkle Trees proofs.
13  *
14  * The proofs can be generated using the JavaScript library
15  * https://github.com/miguelmota/merkletreejs[merkletreejs].
16  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
17  *
18  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
19  */
20 library MerkleProof {
21     /**
22      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
23      * defined by `root`. For this, a `proof` must be provided, containing
24      * sibling hashes on the branch from the leaf to the root of the tree. Each
25      * pair of leaves and each pair of pre-images are assumed to be sorted.
26      */
27     function verify(
28         bytes32[] memory proof,
29         bytes32 root,
30         bytes32 leaf
31     ) internal pure returns (bool) {
32         return processProof(proof, leaf) == root;
33     }
34 
35     /**
36      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
37      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
38      * hash matches the root of the tree. When processing the proof, the pairs
39      * of leafs & pre-images are assumed to be sorted.
40      *
41      * _Available since v4.4._
42      */
43     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
44         bytes32 computedHash = leaf;
45         for (uint256 i = 0; i < proof.length; i++) {
46             bytes32 proofElement = proof[i];
47             if (computedHash <= proofElement) {
48                 // Hash(current computed hash + current element of the proof)
49                 computedHash = _efficientHash(computedHash, proofElement);
50             } else {
51                 // Hash(current element of the proof + current computed hash)
52                 computedHash = _efficientHash(proofElement, computedHash);
53             }
54         }
55         return computedHash;
56     }
57 
58     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
59         assembly {
60             mstore(0x00, a)
61             mstore(0x20, b)
62             value := keccak256(0x00, 0x40)
63         }
64     }
65 }
66 
67 
68 // File: @openzeppelin/contracts/utils/Context.sol
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Provides information about the current execution context, including the
76  * sender of the transaction and its data. While these are generally available
77  * via msg.sender and msg.data, they should not be accessed in such a direct
78  * manner, since when dealing with meta-transactions the account sending and
79  * paying for execution may not be the actual sender (as far as an application
80  * is concerned).
81  *
82  * This contract is only required for intermediate, library-like contracts.
83  */
84 abstract contract Context {
85     function _msgSender() internal view virtual returns (address) {
86         return msg.sender;
87     }
88 
89     function _msgData() internal view virtual returns (bytes calldata) {
90         return msg.data;
91     }
92 }
93 
94 
95 // File: @openzeppelin/contracts/access/Ownable.sol
96 
97 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 // import "@openzeppelin/contracts/utils/Context.sol";
102 
103 /**
104  * @dev Contract module which provides a basic access control mechanism, where
105  * there is an account (an owner) that can be granted exclusive access to
106  * specific functions.
107  *
108  * By default, the owner account will be the one that deploys the contract. This
109  * can later be changed with {transferOwnership}.
110  *
111  * This module is used through inheritance. It will make available the modifier
112  * `onlyOwner`, which can be applied to your functions to restrict their use to
113  * the owner.
114  */
115 abstract contract Ownable is Context {
116     address private _owner;
117 
118     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
119 
120     /**
121      * @dev Initializes the contract setting the deployer as the initial owner.
122      */
123     constructor() {
124         _transferOwnership(_msgSender());
125     }
126 
127     /**
128      * @dev Returns the address of the current owner.
129      */
130     function owner() public view virtual returns (address) {
131         return _owner;
132     }
133 
134     /**
135      * @dev Throws if called by any account other than the owner.
136      */
137     modifier onlyOwner() {
138         require(owner() == _msgSender(), "Ownable: caller is not the owner");
139         _;
140     }
141 
142     /**
143      * @dev Leaves the contract without owner. It will not be possible to call
144      * `onlyOwner` functions anymore. Can only be called by the current owner.
145      *
146      * NOTE: Renouncing ownership will leave the contract without an owner,
147      * thereby removing any functionality that is only available to the owner.
148      */
149     function renounceOwnership() public virtual onlyOwner {
150         _transferOwnership(address(0));
151     }
152 
153     /**
154      * @dev Transfers ownership of the contract to a new account (`newOwner`).
155      * Can only be called by the current owner.
156      */
157     function transferOwnership(address newOwner) public virtual onlyOwner {
158         require(newOwner != address(0), "Ownable: new owner is the zero address");
159         _transferOwnership(newOwner);
160     }
161 
162     /**
163      * @dev Transfers ownership of the contract to a new account (`newOwner`).
164      * Internal function without access restriction.
165      */
166     function _transferOwnership(address newOwner) internal virtual {
167         address oldOwner = _owner;
168         _owner = newOwner;
169         emit OwnershipTransferred(oldOwner, newOwner);
170     }
171 }
172 
173 
174 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
175 
176 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
177 
178 pragma solidity ^0.8.0;
179 
180 /**
181  * @dev Interface of the ERC20 standard as defined in the EIP.
182  */
183 interface IERC20 {
184     /**
185      * @dev Returns the amount of tokens in existence.
186      */
187     function totalSupply() external view returns (uint256);
188 
189     /**
190      * @dev Returns the amount of tokens owned by `account`.
191      */
192     function balanceOf(address account) external view returns (uint256);
193 
194     /**
195      * @dev Moves `amount` tokens from the caller's account to `to`.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * Emits a {Transfer} event.
200      */
201     function transfer(address to, uint256 amount) external returns (bool);
202 
203     /**
204      * @dev Returns the remaining number of tokens that `spender` will be
205      * allowed to spend on behalf of `owner` through {transferFrom}. This is
206      * zero by default.
207      *
208      * This value changes when {approve} or {transferFrom} are called.
209      */
210     function allowance(address owner, address spender) external view returns (uint256);
211 
212     /**
213      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * IMPORTANT: Beware that changing an allowance with this method brings the risk
218      * that someone may use both the old and the new allowance by unfortunate
219      * transaction ordering. One possible solution to mitigate this race
220      * condition is to first reduce the spender's allowance to 0 and set the
221      * desired value afterwards:
222      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
223      *
224      * Emits an {Approval} event.
225      */
226     function approve(address spender, uint256 amount) external returns (bool);
227 
228     /**
229      * @dev Moves `amount` tokens from `from` to `to` using the
230      * allowance mechanism. `amount` is then deducted from the caller's
231      * allowance.
232      *
233      * Returns a boolean value indicating whether the operation succeeded.
234      *
235      * Emits a {Transfer} event.
236      */
237     function transferFrom(
238         address from,
239         address to,
240         uint256 amount
241     ) external returns (bool);
242 
243     /**
244      * @dev Emitted when `value` tokens are moved from one account (`from`) to
245      * another (`to`).
246      *
247      * Note that `value` may be zero.
248      */
249     event Transfer(address indexed from, address indexed to, uint256 value);
250 
251     /**
252      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
253      * a call to {approve}. `value` is the new allowance.
254      */
255     event Approval(address indexed owner, address indexed spender, uint256 value);
256 }
257 
258 
259 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
260 
261 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Interface of the ERC165 standard, as defined in the
267  * https://eips.ethereum.org/EIPS/eip-165[EIP].
268  *
269  * Implementers can declare support of contract interfaces, which can then be
270  * queried by others ({ERC165Checker}).
271  *
272  * For an implementation, see {ERC165}.
273  */
274 interface IERC165 {
275     /**
276      * @dev Returns true if this contract implements the interface defined by
277      * `interfaceId`. See the corresponding
278      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
279      * to learn more about how these ids are created.
280      *
281      * This function call must use less than 30 000 gas.
282      */
283     function supportsInterface(bytes4 interfaceId) external view returns (bool);
284 }
285 
286 
287 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
288 
289 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 // import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
294 
295 /**
296  * @dev Required interface of an ERC721 compliant contract.
297  */
298 interface IERC721 is IERC165 {
299     /**
300      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
301      */
302     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
303 
304     /**
305      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
306      */
307     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
308 
309     /**
310      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
311      */
312     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
313 
314     /**
315      * @dev Returns the number of tokens in ``owner``'s account.
316      */
317     function balanceOf(address owner) external view returns (uint256 balance);
318 
319     /**
320      * @dev Returns the owner of the `tokenId` token.
321      *
322      * Requirements:
323      *
324      * - `tokenId` must exist.
325      */
326     function ownerOf(uint256 tokenId) external view returns (address owner);
327 
328     /**
329      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
330      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
331      *
332      * Requirements:
333      *
334      * - `from` cannot be the zero address.
335      * - `to` cannot be the zero address.
336      * - `tokenId` token must exist and be owned by `from`.
337      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
338      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
339      *
340      * Emits a {Transfer} event.
341      */
342     function safeTransferFrom(
343         address from,
344         address to,
345         uint256 tokenId
346     ) external;
347 
348     /**
349      * @dev Transfers `tokenId` token from `from` to `to`.
350      *
351      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
352      *
353      * Requirements:
354      *
355      * - `from` cannot be the zero address.
356      * - `to` cannot be the zero address.
357      * - `tokenId` token must be owned by `from`.
358      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
359      *
360      * Emits a {Transfer} event.
361      */
362     function transferFrom(
363         address from,
364         address to,
365         uint256 tokenId
366     ) external;
367 
368     /**
369      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
370      * The approval is cleared when the token is transferred.
371      *
372      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
373      *
374      * Requirements:
375      *
376      * - The caller must own the token or be an approved operator.
377      * - `tokenId` must exist.
378      *
379      * Emits an {Approval} event.
380      */
381     function approve(address to, uint256 tokenId) external;
382 
383     /**
384      * @dev Returns the account approved for `tokenId` token.
385      *
386      * Requirements:
387      *
388      * - `tokenId` must exist.
389      */
390     function getApproved(uint256 tokenId) external view returns (address operator);
391 
392     /**
393      * @dev Approve or remove `operator` as an operator for the caller.
394      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
395      *
396      * Requirements:
397      *
398      * - The `operator` cannot be the caller.
399      *
400      * Emits an {ApprovalForAll} event.
401      */
402     function setApprovalForAll(address operator, bool _approved) external;
403 
404     /**
405      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
406      *
407      * See {setApprovalForAll}
408      */
409     function isApprovedForAll(address owner, address operator) external view returns (bool);
410 
411     /**
412      * @dev Safely transfers `tokenId` token from `from` to `to`.
413      *
414      * Requirements:
415      *
416      * - `from` cannot be the zero address.
417      * - `to` cannot be the zero address.
418      * - `tokenId` token must exist and be owned by `from`.
419      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
420      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
421      *
422      * Emits a {Transfer} event.
423      */
424     function safeTransferFrom(
425         address from,
426         address to,
427         uint256 tokenId,
428         bytes calldata data
429     ) external;
430 }
431 
432 
433 // File: @rari-capital/solmate/src/tokens/ERC20.sol
434 
435 pragma solidity >=0.8.0;
436 
437 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
438 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/tokens/ERC20.sol)
439 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
440 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
441 abstract contract ERC20 {
442     /*///////////////////////////////////////////////////////////////
443                                   EVENTS
444     //////////////////////////////////////////////////////////////*/
445 
446     event Transfer(address indexed from, address indexed to, uint256 amount);
447 
448     event Approval(address indexed owner, address indexed spender, uint256 amount);
449 
450     /*///////////////////////////////////////////////////////////////
451                              METADATA STORAGE
452     //////////////////////////////////////////////////////////////*/
453 
454     string public name;
455 
456     string public symbol;
457 
458     uint8 public immutable decimals;
459 
460     /*///////////////////////////////////////////////////////////////
461                               ERC20 STORAGE
462     //////////////////////////////////////////////////////////////*/
463 
464     uint256 public totalSupply;
465 
466     mapping(address => uint256) public balanceOf;
467 
468     mapping(address => mapping(address => uint256)) public allowance;
469 
470     /*///////////////////////////////////////////////////////////////
471                              EIP-2612 STORAGE
472     //////////////////////////////////////////////////////////////*/
473 
474     bytes32 public constant PERMIT_TYPEHASH =
475         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
476 
477     uint256 internal immutable INITIAL_CHAIN_ID;
478 
479     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
480 
481     mapping(address => uint256) public nonces;
482 
483     /*///////////////////////////////////////////////////////////////
484                                CONSTRUCTOR
485     //////////////////////////////////////////////////////////////*/
486 
487     constructor(
488         string memory _name,
489         string memory _symbol,
490         uint8 _decimals
491     ) {
492         name = _name;
493         symbol = _symbol;
494         decimals = _decimals;
495 
496         INITIAL_CHAIN_ID = block.chainid;
497         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
498     }
499 
500     /*///////////////////////////////////////////////////////////////
501                               ERC20 LOGIC
502     //////////////////////////////////////////////////////////////*/
503 
504     function approve(address spender, uint256 amount) public virtual returns (bool) {
505         allowance[msg.sender][spender] = amount;
506 
507         emit Approval(msg.sender, spender, amount);
508 
509         return true;
510     }
511 
512     function transfer(address to, uint256 amount) public virtual returns (bool) {
513         balanceOf[msg.sender] -= amount;
514 
515         // Cannot overflow because the sum of all user
516         // balances can't exceed the max uint256 value.
517         unchecked {
518             balanceOf[to] += amount;
519         }
520 
521         emit Transfer(msg.sender, to, amount);
522 
523         return true;
524     }
525 
526     function transferFrom(
527         address from,
528         address to,
529         uint256 amount
530     ) public virtual returns (bool) {
531         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
532 
533         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
534 
535         balanceOf[from] -= amount;
536 
537         // Cannot overflow because the sum of all user
538         // balances can't exceed the max uint256 value.
539         unchecked {
540             balanceOf[to] += amount;
541         }
542 
543         emit Transfer(from, to, amount);
544 
545         return true;
546     }
547 
548     /*///////////////////////////////////////////////////////////////
549                               EIP-2612 LOGIC
550     //////////////////////////////////////////////////////////////*/
551 
552     function permit(
553         address owner,
554         address spender,
555         uint256 value,
556         uint256 deadline,
557         uint8 v,
558         bytes32 r,
559         bytes32 s
560     ) public virtual {
561         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
562 
563         // Unchecked because the only math done is incrementing
564         // the owner's nonce which cannot realistically overflow.
565         unchecked {
566             bytes32 digest = keccak256(
567                 abi.encodePacked(
568                     "\x19\x01",
569                     DOMAIN_SEPARATOR(),
570                     keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
571                 )
572             );
573 
574             address recoveredAddress = ecrecover(digest, v, r, s);
575 
576             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
577 
578             allowance[recoveredAddress][spender] = value;
579         }
580 
581         emit Approval(owner, spender, value);
582     }
583 
584     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
585         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
586     }
587 
588     function computeDomainSeparator() internal view virtual returns (bytes32) {
589         return
590             keccak256(
591                 abi.encode(
592                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
593                     keccak256(bytes(name)),
594                     keccak256("1"),
595                     block.chainid,
596                     address(this)
597                 )
598             );
599     }
600 
601     /*///////////////////////////////////////////////////////////////
602                        INTERNAL MINT/BURN LOGIC
603     //////////////////////////////////////////////////////////////*/
604 
605     function _mint(address to, uint256 amount) internal virtual {
606         totalSupply += amount;
607 
608         // Cannot overflow because the sum of all user
609         // balances can't exceed the max uint256 value.
610         unchecked {
611             balanceOf[to] += amount;
612         }
613 
614         emit Transfer(address(0), to, amount);
615     }
616 
617     function _burn(address from, uint256 amount) internal virtual {
618         balanceOf[from] -= amount;
619 
620         // Cannot underflow because a user's balance
621         // will never be larger than the total supply.
622         unchecked {
623             totalSupply -= amount;
624         }
625 
626         emit Transfer(from, address(0), amount);
627     }
628 }
629 
630 
631 // File: eth/contracts/Dreams.sol
632 
633 pragma solidity ^0.8.0;
634 pragma abicoder v2;
635 
636 // import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol"; 
637 // import "@openzeppelin/contracts/access/Ownable.sol";
638 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
639 // import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
640 // import "@rari-capital/solmate/src/tokens/ERC20.sol";
641 
642 error InvalidProof();
643 error Unauthorized();
644 error NotActive();
645 error IndexOutOfBounds();
646 error NoMoreAvailableToMint();
647 
648 abstract contract ERC20MintCapped is ERC20, Ownable {
649 
650     uint256 public immutable mintCap;
651 
652     uint256 public immutable harvestMintCap;
653 
654     uint128 public totalMinted;
655 
656     uint128 public totalHarvestMinted;
657 
658     mapping(address => bool) public minters;
659 
660     constructor(uint128 mintCap_, uint128 harvestMintCap_) { 
661         mintCap = mintCap_;
662         harvestMintCap = harvestMintCap_;
663         if (harvestMintCap_ > mintCap_) revert();
664         minters[msg.sender] = true;
665     }
666 
667     function _cappedMint(address to, uint256 amount) internal returns (uint256) {
668         if (amount == 0) return 0;
669         uint256 diff;
670         unchecked {
671             uint256 curr = totalMinted;
672             uint256 next = curr + amount;
673             if (amount > type(uint128).max) revert();
674             if (next > mintCap) { // If the next total amount exceeds the mintCap,
675                 next = mintCap; // set the total amount to the mintCap.
676             }
677             diff = next - curr; // The amount needed to be minted.
678             if (diff == 0) revert NoMoreAvailableToMint();
679             if (next > type(uint128).max) revert();
680             totalMinted = uint128(next);    
681         }
682         _mint(to, diff);
683         return diff;
684     }
685 
686     function _harvestCappedMint(address to, uint256 amount) internal returns (uint256) {
687         if (amount == 0) return 0;
688         uint256 diff;
689         unchecked {
690             uint256 curr = totalHarvestMinted;
691             uint256 next = curr + amount;
692             if (amount > type(uint128).max) revert();
693             if (next > harvestMintCap) { // If the next total amount exceeds the harvestMintCap,
694                 next = harvestMintCap; // set the total amount to the harvestMintCap.
695             }
696             diff = next - curr; // The amount needed to be minted.
697             if (diff == 0) revert NoMoreAvailableToMint();
698             if (next > type(uint128).max) revert();
699             totalHarvestMinted = uint128(next);    
700         }
701         return _cappedMint(to, diff);
702     }
703 
704     function authorizeMinter(address minter) external onlyOwner {
705         minters[minter] = true;
706     }
707 
708     function revokeMinter(address minter) external onlyOwner {
709         minters[minter] = false;
710     }
711     
712     function mint(address to, uint256 amount) external {
713         if (!minters[msg.sender]) revert Unauthorized();
714         _cappedMint(to, amount);
715     }
716 
717     function selfMint(uint256 amount) external {
718         if (!minters[msg.sender]) revert Unauthorized();
719         _cappedMint(msg.sender, amount);
720     }
721 }
722 
723 
724 abstract contract ERC20Claimable is ERC20MintCapped {
725     
726     bytes32 internal _claimMerkleRoot;
727 
728     mapping(uint256 => uint256) internal _claimed;
729 
730     constructor(bytes32 claimMerkleRoot) {
731         _claimMerkleRoot = claimMerkleRoot;
732     }
733 
734     function setClaimMerkleRoot(bytes32 root) public onlyOwner {
735         _claimMerkleRoot = root;
736     }
737 
738     function isClaimed(uint256 slot) external view returns (bool) {
739         uint256 q = slot >> 8;
740         uint256 r = slot & 255;
741         uint256 b = 1 << r;
742         return _claimed[q] & b != 0;
743     }
744 
745     function claim(address to, uint256 amount, uint256 slot, bytes32[] calldata proof) external {
746         uint256 q = slot >> 8;
747         uint256 r = slot & 255;
748         uint256 b = 1 << r;
749         require(_claimed[q] & b == 0, "Already claimed.");
750         bytes32 leaf = keccak256(abi.encodePacked(to, amount, slot));
751         bool isValidLeaf = MerkleProof.verify(proof, _claimMerkleRoot, leaf);
752         if (!isValidLeaf) revert InvalidProof();
753         _claimed[q] |= b;
754 
755         _cappedMint(to, amount);
756     }
757 }
758 
759 
760 abstract contract ERC20Burnable is ERC20 {
761 
762     function _checkedBurn(address account, uint256 amount) internal {
763         require(balanceOf[account] >= amount, "Insufficient balance.");
764         _burn(account, amount);
765     }
766 
767     function burn(uint256 amount) public {
768         _checkedBurn(msg.sender, amount);
769     }
770 
771     function burnFrom(address account, uint256 amount) public {
772         uint256 currentAllowance = allowance[account][msg.sender];
773         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
774         unchecked {
775             allowance[account][msg.sender] -= amount;
776         }
777         _checkedBurn(account, amount);
778     }
779 }
780 
781 
782 abstract contract Coin is ERC20, ERC20Burnable, ERC20MintCapped, ERC20Claimable {
783 
784     constructor(
785         string memory name_, 
786         string memory symbol_, 
787         uint128 mintCap_, 
788         uint128 harvestMintCap_
789     )
790     ERC20(name_, symbol_, 18) 
791     ERC20MintCapped(mintCap_, harvestMintCap_) {}
792 }
793 
794 
795 abstract contract Shop is Coin {
796 
797     struct PriceListing {
798         uint248 price;
799         bool active;
800     }
801 
802     uint256 internal constant BITWIDTH_TOKEN_UID = 16;
803     uint256 internal constant BITWIDTH_TOKEN_ID = BITWIDTH_TOKEN_UID - 1;
804     uint256 internal constant BITMASK_TOKEN_ID = (1 << BITWIDTH_TOKEN_ID) - 1;
805 
806     address public immutable gen0;
807     address public immutable gen1;
808 
809     constructor(address _gen0, address _gen1) {
810         gen0 = _gen0;
811         gen1 = _gen1;
812     }
813 
814     function _gen(uint256 gen) internal view returns (IERC721) {
815         return IERC721(gen == 0 ? gen0 : gen1);
816     }
817 }
818 
819 
820 abstract contract NFTStaker is Shop {
821 
822     uint256 internal constant BITSHIFT_OWNER = 96;
823     uint256 internal constant BITWIDTH_BLOCK_NUM = 31;
824     uint256 internal constant BITMASK_BLOCK_NUM = (1 << BITWIDTH_BLOCK_NUM) - 1;
825     uint256 internal constant BITWIDTH_STAKE = (BITWIDTH_TOKEN_UID + BITWIDTH_BLOCK_NUM);
826     uint256 internal constant BITMASK_STAKE = (1 << BITWIDTH_STAKE) - 1;
827     uint256 internal constant BITMOD_STAKE = (256 / BITWIDTH_STAKE);
828     uint256 internal constant BITPOS_NUM_STAKED = BITMOD_STAKE * BITWIDTH_STAKE;
829     uint256 internal constant BITMASK_STAKES = (1 << BITPOS_NUM_STAKED) - 1;
830     
831     uint256 internal constant BITWIDTH_RATE = 4;
832     uint256 internal constant BITMOD_RATE = (256 / BITWIDTH_RATE);
833     uint256 internal constant BITMASK_RATE = (1 << BITWIDTH_RATE) - 1;
834     uint256 internal constant DEFAULT_RATE = 5;
835 
836     mapping(uint256 => uint256) internal _vault;
837 
838     bytes32 internal _ratesMerkleRoot;
839 
840     uint128 public harvestBaseRate;
841 
842     uint32 public minStakeBlocks;
843 
844     bool private _reentrancyGuard;
845 
846     constructor(
847         uint128 harvestBaseRate_, 
848         uint32 minStakeBlocks_, 
849         bytes32 ratesMerkleRoot_
850     ) {
851         harvestBaseRate = harvestBaseRate_;
852         minStakeBlocks = minStakeBlocks_;
853         _ratesMerkleRoot = ratesMerkleRoot_;
854     }
855 
856     modifier nonReentrant() {
857         if (_reentrancyGuard) revert();
858         _reentrancyGuard = true;
859         _;
860         _reentrancyGuard = false;
861     }
862 
863     function setRatesMerkleRoot(bytes32 value) external onlyOwner {
864         _ratesMerkleRoot = value;
865     }
866 
867     function setMinStakeBlocks(uint32 value) external onlyOwner {
868         minStakeBlocks = value;
869     }
870 
871     function setHarvestBaseRate(uint128 value) external onlyOwner {
872         harvestBaseRate = value;
873     }
874 
875     function _blockNumber() internal view virtual returns (uint256) {
876         return block.number;
877     }
878 
879     function stakeNFTs(uint256[] memory tokenUids) 
880     external nonReentrant {
881         unchecked {
882             uint256 n = tokenUids.length;
883             require(n > 0, "Please submit at least 1 token.");
884             uint256 o = uint256(uint160(msg.sender)) << BITSHIFT_OWNER;
885             uint256 f = _vault[o];
886             uint256 m = f >> BITPOS_NUM_STAKED;
887 
888             uint256 j = m;
889 
890             _vault[o] = f ^ ((m ^ (m + n)) << BITPOS_NUM_STAKED);
891 
892             uint256 blockNumCurr = _blockNumber();
893             for (uint256 i; i < n; ++i) {
894                 uint256 e = tokenUids[i];
895                 
896                 // Transfer NFT from owner to contract.
897                 uint256 gen = e >> BITWIDTH_TOKEN_ID;
898                 uint256 tokenId = e & BITMASK_TOKEN_ID;
899                 _gen(gen).transferFrom(msg.sender, address(this), tokenId);
900 
901                 uint256 q = (j / BITMOD_STAKE) | o;
902                 uint256 r = (j % BITMOD_STAKE) * BITWIDTH_STAKE;
903                 uint256 s = (e << BITWIDTH_BLOCK_NUM) | blockNumCurr;
904                 _vault[q] |= (s << r);
905                 ++j;
906             }
907         }
908     }
909 
910     function stakedNFTs(address owner) 
911     external view returns (uint256[] memory) {
912         unchecked {
913             uint256 o = uint256(uint160(owner)) << BITSHIFT_OWNER;
914             uint256 f = _vault[o];
915             uint256 m = f >> BITPOS_NUM_STAKED;
916 
917             uint256[] memory a = new uint256[](m);
918             for (uint256 j; j < m; ++j) {
919                 uint256 q = (j / BITMOD_STAKE) | o;
920                 uint256 r = (j % BITMOD_STAKE) * BITWIDTH_STAKE;
921                 uint256 s = (_vault[q] >> r) & BITMASK_STAKE;
922                 a[j] = s >> BITWIDTH_BLOCK_NUM;
923             }
924             return a;
925         }
926     }
927 
928     function stakedNFTByIndex(address owner, uint256 index) public view returns (uint256) {
929         unchecked {
930             uint256 j = index;
931             uint256 o = uint256(uint160(owner)) << BITSHIFT_OWNER;
932             uint256 f = _vault[o];
933             uint256 m = f >> BITPOS_NUM_STAKED;
934             if (j >= m) revert IndexOutOfBounds();
935             uint256 q = (j / BITMOD_STAKE) | o;
936             uint256 r = (j % BITMOD_STAKE) * BITWIDTH_STAKE;
937             uint256 s = (_vault[q] >> r) & BITMASK_STAKE;
938             return s >> BITWIDTH_BLOCK_NUM;
939         }        
940     }
941 
942     function unstakeNFTs(uint256[] calldata indices, uint256 numStaked) 
943     external nonReentrant {
944         unchecked {
945             uint256 o = uint256(uint160(msg.sender)) << BITSHIFT_OWNER;
946             uint256 f = _vault[o];
947             uint256 m = f >> BITPOS_NUM_STAKED;      
948             if (m != numStaked) revert IndexOutOfBounds();
949             uint256 n = indices.length;
950             require(n > 0, "Please submit at least 1 token.");
951             if (m < n) revert IndexOutOfBounds();
952 
953             _vault[o] = f ^ ((m ^ (m - n)) << BITPOS_NUM_STAKED);
954             uint256 p = type(uint256).max;
955             for (uint256 i; i < n; ++i) {
956                 uint256 j = indices[i];
957                 if (j >= m || j >= p) revert IndexOutOfBounds();
958                 uint256 q = (j / BITMOD_STAKE) | o;
959                 uint256 r = (j % BITMOD_STAKE) * BITWIDTH_STAKE;
960                 uint256 s = (_vault[q] >> r) & BITMASK_STAKE;
961                 
962                 uint256 tokenUid = s >> BITWIDTH_BLOCK_NUM;
963                 
964                 // Transfer NFT from contract to owner.
965                 uint256 gen = tokenUid >> BITWIDTH_TOKEN_ID;
966                 uint256 tokenId = tokenUid & BITMASK_TOKEN_ID;
967                 _gen(gen).transferFrom(address(this), msg.sender, tokenId);
968 
969                 --m;
970                 uint256 u = (m / BITMOD_STAKE) | o;
971                 uint256 v = (m % BITMOD_STAKE) * BITWIDTH_STAKE;
972                 uint256 w = (_vault[u] >> v) & BITMASK_STAKE;
973                 _vault[q] ^= ((s ^ w) << r);
974                 _vault[u] ^= (w << v);
975                 p = j;
976             }
977         }
978     }
979 
980     function harvest(uint256[] calldata rates, bytes32[][] calldata proofs) 
981     external nonReentrant returns (uint256) {
982         unchecked {
983             uint256 o = uint256(uint160(msg.sender)) << BITSHIFT_OWNER;
984             uint256 m = _vault[o] >> BITPOS_NUM_STAKED;
985             uint256 amount;
986             if (m != rates.length || m != proofs.length)
987                 revert InvalidProof();
988             
989             uint256 blockNumCurr = _blockNumber();
990             uint256 thres = minStakeBlocks;
991             bytes32 root = _ratesMerkleRoot;
992             
993             for (uint256 j; j < m; ++j) {
994                 bytes32[] memory proof = proofs[j];
995                 uint256 rate = rates[j];
996                 uint256 q = (j / BITMOD_STAKE) | o;
997                 uint256 r = (j % BITMOD_STAKE) * BITWIDTH_STAKE;
998                 uint256 s = (_vault[q] >> r) & BITMASK_STAKE;
999                 
1000                 uint256 blockNum = s & BITMASK_BLOCK_NUM;
1001                 uint256 tokenUid = s >> BITWIDTH_BLOCK_NUM;
1002                 
1003                 if (blockNum + thres > blockNumCurr) continue;
1004 
1005                 if (!MerkleProof.verify(proof, root, 
1006                     keccak256(abi.encodePacked(tokenUid, rate)))) 
1007                     revert InvalidProof();
1008 
1009                 amount += rate * (blockNumCurr - blockNum);
1010 
1011                 uint256 w = (tokenUid << BITWIDTH_BLOCK_NUM) | blockNumCurr;
1012                 _vault[q] ^= ((s ^ w) << r);                    
1013             }
1014             amount *= harvestBaseRate;
1015 
1016             return _harvestCappedMint(msg.sender, amount);
1017         }
1018     }
1019 }
1020 
1021 
1022 abstract contract NFTDataChanger is NFTStaker {
1023 
1024     mapping(uint256 => PriceListing) public nftDataPrices;
1025 
1026     // nftData[tokenUid][dataTypeId]
1027     mapping(uint256 => mapping(uint256 => bytes32)) public nftData;
1028 
1029     event NFTDataChanged(uint256 tokenUid, uint256 dataTypeId, bytes32 value);
1030 
1031     function setNFTDataPrice(uint256 dataTypeId, uint248 price, bool active) external onlyOwner {
1032         nftDataPrices[dataTypeId].price = price;
1033         nftDataPrices[dataTypeId].active = active;
1034     }
1035 
1036     function _setNFTData(uint256 tokenUid, uint256 dataTypeId, bytes32 value) internal {
1037         if (!nftDataPrices[dataTypeId].active) revert NotActive();
1038         burn(nftDataPrices[dataTypeId].price);
1039 
1040         nftData[tokenUid][dataTypeId] = value;
1041         emit NFTDataChanged(tokenUid, dataTypeId, value);
1042     }
1043 
1044     function setNFTData(uint256 tokenUid, uint256 dataTypeId, bytes32 value) external {
1045         uint256 gen = tokenUid >> BITWIDTH_TOKEN_ID;
1046         uint256 tokenId = tokenUid & BITMASK_TOKEN_ID;
1047         if (msg.sender != _gen(gen).ownerOf(tokenId)) revert Unauthorized();
1048         _setNFTData(tokenUid, dataTypeId, value);
1049     }
1050 
1051     function setStakedNFTData(uint256 tokenUid, uint256 index, uint256 dataTypeId, bytes32 value) external {
1052         if (stakedNFTByIndex(msg.sender, index) != tokenUid) revert Unauthorized();
1053         _setNFTData(tokenUid, dataTypeId, value);
1054     }
1055 
1056     function getNFTData(uint256[] calldata tokenUids, uint256[] calldata dataTypeIds) 
1057     external view returns (bytes32[] memory) {
1058         unchecked {
1059             uint256 m = tokenUids.length;
1060             uint256 n = dataTypeIds.length;
1061             bytes32[] memory a = new bytes32[](m * n);
1062             for (uint256 j; j < m; ++j) {
1063                 for (uint256 i; i < n; ++i) {
1064                     a[j * n + i] = nftData[tokenUids[j]][dataTypeIds[i]];
1065                 }
1066             }
1067             return a;    
1068         }
1069     }
1070 }
1071 
1072 
1073 abstract contract TicketShop is Shop {
1074 
1075     mapping(uint256 => PriceListing) public ticketPrices;
1076 
1077     mapping(uint256 => address[]) public ticketPurchases;
1078 
1079     mapping(uint256 => mapping(address => bool)) public hasPurchasedTicket;
1080 
1081     function setTicketPrice(uint256 ticketTypeId, uint248 price, bool active) external onlyOwner {
1082         ticketPrices[ticketTypeId].price = price;
1083         ticketPrices[ticketTypeId].active = active;
1084     }
1085 
1086     function purchaseTicket(uint256 ticketTypeId) public {
1087         if (!ticketPrices[ticketTypeId].active) revert NotActive();
1088         burn(ticketPrices[ticketTypeId].price);
1089 
1090         ticketPurchases[ticketTypeId].push(msg.sender);
1091         hasPurchasedTicket[ticketTypeId][msg.sender] = true;
1092     }
1093 }
1094 
1095 
1096 interface IGen1 is IERC721 {
1097     
1098     function forceMint(address[] memory _addresses) external;
1099 }
1100 
1101 
1102 abstract contract Gen1Minter is Shop {
1103 
1104     PriceListing public gen1MintPrice;
1105 
1106     function setGen1MintPrice(uint128 price, bool active) external onlyOwner {
1107         gen1MintPrice.price = price;
1108         gen1MintPrice.active = active;
1109     }
1110 
1111     function passBackGen1Ownership() external onlyOwner {
1112         Ownable(gen1).transferOwnership(owner());
1113     }
1114 
1115     function mintGen1(uint256 numTokens) external {
1116         if (!gen1MintPrice.active) revert NotActive();
1117         burn(gen1MintPrice.price * numTokens);
1118 
1119         address[] memory a = new address[](numTokens);
1120         unchecked {
1121             for (uint i; i < numTokens; ++i) {
1122                 a[i] = msg.sender;
1123             }
1124         }
1125         IGen1(gen1).forceMint(a);
1126     }
1127 }
1128 
1129 
1130 abstract contract NFTCoinShop is NFTDataChanger, TicketShop, Gen1Minter {
1131 
1132     constructor(
1133         string memory name_, 
1134         string memory symbol_, 
1135         uint128 mintCap_, 
1136         uint128 harvestMintCap_, 
1137         address gen0_, 
1138         address gen1_,
1139         bytes32 claimMerkleRoot_,
1140         uint128 harvestBaseRate_, 
1141         uint32 minStakeBlocks_, 
1142         bytes32 ratesMerkleRoot_) 
1143     Coin(name_, symbol_, mintCap_, harvestMintCap_)
1144     Shop(gen0_, gen1_)
1145     ERC20Claimable(claimMerkleRoot_)
1146     NFTStaker(harvestBaseRate_, minStakeBlocks_, ratesMerkleRoot_) {}
1147 }
1148 
1149 
1150 // Replace class name with actual value in prod.
1151 contract Dreams is NFTCoinShop {
1152 
1153     constructor() 
1154     NFTCoinShop(
1155         // Name
1156         "Dreams", 
1157         // Symbol
1158         "DREAMS", 
1159         // Mint cap
1160         10000000 * 1000000000000000000, 
1161         // Harvest mint cap
1162         7000000 * 1000000000000000000, 
1163         // Gen 0 
1164         0x4e2781e3aD94b2DfcF34c51De0D8e9358c69F296, 
1165         // Gen 1
1166         0xAB9F99e6460f6B7940aB7920F44D97b725e0FA4c, 
1167         // Claim Merkle Root
1168         0xef35dac8c7728a6c30dc702829819d9d3349f1435480726d0a865665ef8ace69,
1169         // Harvest base Rate
1170         100000000000000,
1171         // Harvest min stake blocks
1172         66000, 
1173         // Harvest rates merkle root
1174         0x8b032d7c4c594507e68c268cbee1026fb7321f4eee5d333862bac183598d338d
1175     ) {}
1176 
1177 }