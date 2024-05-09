1 // SPDX-License-Identifier: MIT
2 
3 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.0
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 
219 // File @openzeppelin/contracts/cryptography/MerkleProof.sol@v3.4.0
220 
221 pragma solidity >=0.6.0 <0.8.0;
222 
223 /**
224  * @dev These functions deal with verification of Merkle trees (hash trees),
225  */
226 library MerkleProof {
227     /**
228      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
229      * defined by `root`. For this, a `proof` must be provided, containing
230      * sibling hashes on the branch from the leaf to the root of the tree. Each
231      * pair of leaves and each pair of pre-images are assumed to be sorted.
232      */
233     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
234         bytes32 computedHash = leaf;
235 
236         for (uint256 i = 0; i < proof.length; i++) {
237             bytes32 proofElement = proof[i];
238 
239             if (computedHash <= proofElement) {
240                 // Hash(current computed hash + current element of the proof)
241                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
242             } else {
243                 // Hash(current element of the proof + current computed hash)
244                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
245             }
246         }
247 
248         // Check if the computed hash (root) is equal to the provided root
249         return computedHash == root;
250     }
251 }
252 
253 
254 // File @openzeppelin/contracts/cryptography/ECDSA.sol@v3.4.0
255 
256 pragma solidity >=0.6.0 <0.8.0;
257 
258 /**
259  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
260  *
261  * These functions can be used to verify that a message was signed by the holder
262  * of the private keys of a given address.
263  */
264 library ECDSA {
265     /**
266      * @dev Returns the address that signed a hashed message (`hash`) with
267      * `signature`. This address can then be used for verification purposes.
268      *
269      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
270      * this function rejects them by requiring the `s` value to be in the lower
271      * half order, and the `v` value to be either 27 or 28.
272      *
273      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
274      * verification to be secure: it is possible to craft signatures that
275      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
276      * this is by receiving a hash of the original message (which may otherwise
277      * be too long), and then calling {toEthSignedMessageHash} on it.
278      */
279     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
280         // Check the signature length
281         if (signature.length != 65) {
282             revert("ECDSA: invalid signature length");
283         }
284 
285         // Divide the signature in r, s and v variables
286         bytes32 r;
287         bytes32 s;
288         uint8 v;
289 
290         // ecrecover takes the signature parameters, and the only way to get them
291         // currently is to use assembly.
292         // solhint-disable-next-line no-inline-assembly
293         assembly {
294             r := mload(add(signature, 0x20))
295             s := mload(add(signature, 0x40))
296             v := byte(0, mload(add(signature, 0x60)))
297         }
298 
299         return recover(hash, v, r, s);
300     }
301 
302     /**
303      * @dev Overload of {ECDSA-recover-bytes32-bytes-} that receives the `v`,
304      * `r` and `s` signature fields separately.
305      */
306     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
307         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
308         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
309         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
310         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
311         //
312         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
313         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
314         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
315         // these malleable signatures as well.
316         require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
317         require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
318 
319         // If the signature is valid (and not malleable), return the signer address
320         address signer = ecrecover(hash, v, r, s);
321         require(signer != address(0), "ECDSA: invalid signature");
322 
323         return signer;
324     }
325 
326     /**
327      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
328      * replicates the behavior of the
329      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
330      * JSON-RPC method.
331      *
332      * See {recover}.
333      */
334     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
335         // 32 is the length in bytes of hash,
336         // enforced by the type signature above
337         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
338     }
339 }
340 
341 
342 // File @openzeppelin/contracts/utils/Context.sol@v3.4.0
343 
344 pragma solidity >=0.6.0 <0.8.0;
345 
346 /*
347  * @dev Provides information about the current execution context, including the
348  * sender of the transaction and its data. While these are generally available
349  * via msg.sender and msg.data, they should not be accessed in such a direct
350  * manner, since when dealing with GSN meta-transactions the account sending and
351  * paying for execution may not be the actual sender (as far as an application
352  * is concerned).
353  *
354  * This contract is only required for intermediate, library-like contracts.
355  */
356 abstract contract Context {
357     function _msgSender() internal view virtual returns (address payable) {
358         return msg.sender;
359     }
360 
361     function _msgData() internal view virtual returns (bytes memory) {
362         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
363         return msg.data;
364     }
365 }
366 
367 
368 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.0
369 
370 pragma solidity >=0.6.0 <0.8.0;
371 
372 /**
373  * @dev Contract module which provides a basic access control mechanism, where
374  * there is an account (an owner) that can be granted exclusive access to
375  * specific functions.
376  *
377  * By default, the owner account will be the one that deploys the contract. This
378  * can later be changed with {transferOwnership}.
379  *
380  * This module is used through inheritance. It will make available the modifier
381  * `onlyOwner`, which can be applied to your functions to restrict their use to
382  * the owner.
383  */
384 abstract contract Ownable is Context {
385     address private _owner;
386 
387     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
388 
389     /**
390      * @dev Initializes the contract setting the deployer as the initial owner.
391      */
392     constructor () internal {
393         address msgSender = _msgSender();
394         _owner = msgSender;
395         emit OwnershipTransferred(address(0), msgSender);
396     }
397 
398     /**
399      * @dev Returns the address of the current owner.
400      */
401     function owner() public view virtual returns (address) {
402         return _owner;
403     }
404 
405     /**
406      * @dev Throws if called by any account other than the owner.
407      */
408     modifier onlyOwner() {
409         require(owner() == _msgSender(), "Ownable: caller is not the owner");
410         _;
411     }
412 
413     /**
414      * @dev Leaves the contract without owner. It will not be possible to call
415      * `onlyOwner` functions anymore. Can only be called by the current owner.
416      *
417      * NOTE: Renouncing ownership will leave the contract without an owner,
418      * thereby removing any functionality that is only available to the owner.
419      */
420     function renounceOwnership() public virtual onlyOwner {
421         emit OwnershipTransferred(_owner, address(0));
422         _owner = address(0);
423     }
424 
425     /**
426      * @dev Transfers ownership of the contract to a new account (`newOwner`).
427      * Can only be called by the current owner.
428      */
429     function transferOwnership(address newOwner) public virtual onlyOwner {
430         require(newOwner != address(0), "Ownable: new owner is the zero address");
431         emit OwnershipTransferred(_owner, newOwner);
432         _owner = newOwner;
433     }
434 }
435 
436 
437 // File @openzeppelin/contracts/introspection/IERC165.sol@v3.4.0
438 
439 pragma solidity >=0.6.0 <0.8.0;
440 
441 /**
442  * @dev Interface of the ERC165 standard, as defined in the
443  * https://eips.ethereum.org/EIPS/eip-165[EIP].
444  *
445  * Implementers can declare support of contract interfaces, which can then be
446  * queried by others ({ERC165Checker}).
447  *
448  * For an implementation, see {ERC165}.
449  */
450 interface IERC165 {
451     /**
452      * @dev Returns true if this contract implements the interface defined by
453      * `interfaceId`. See the corresponding
454      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
455      * to learn more about how these ids are created.
456      *
457      * This function call must use less than 30 000 gas.
458      */
459     function supportsInterface(bytes4 interfaceId) external view returns (bool);
460 }
461 
462 
463 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v3.4.0
464 
465 pragma solidity >=0.6.2 <0.8.0;
466 
467 /**
468  * @dev Required interface of an ERC721 compliant contract.
469  */
470 interface IERC721 is IERC165 {
471     /**
472      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
473      */
474     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
475 
476     /**
477      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
478      */
479     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
480 
481     /**
482      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
483      */
484     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
485 
486     /**
487      * @dev Returns the number of tokens in ``owner``'s account.
488      */
489     function balanceOf(address owner) external view returns (uint256 balance);
490 
491     /**
492      * @dev Returns the owner of the `tokenId` token.
493      *
494      * Requirements:
495      *
496      * - `tokenId` must exist.
497      */
498     function ownerOf(uint256 tokenId) external view returns (address owner);
499 
500     /**
501      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
502      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
503      *
504      * Requirements:
505      *
506      * - `from` cannot be the zero address.
507      * - `to` cannot be the zero address.
508      * - `tokenId` token must exist and be owned by `from`.
509      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
510      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
511      *
512      * Emits a {Transfer} event.
513      */
514     function safeTransferFrom(address from, address to, uint256 tokenId) external;
515 
516     /**
517      * @dev Transfers `tokenId` token from `from` to `to`.
518      *
519      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
520      *
521      * Requirements:
522      *
523      * - `from` cannot be the zero address.
524      * - `to` cannot be the zero address.
525      * - `tokenId` token must be owned by `from`.
526      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
527      *
528      * Emits a {Transfer} event.
529      */
530     function transferFrom(address from, address to, uint256 tokenId) external;
531 
532     /**
533      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
534      * The approval is cleared when the token is transferred.
535      *
536      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
537      *
538      * Requirements:
539      *
540      * - The caller must own the token or be an approved operator.
541      * - `tokenId` must exist.
542      *
543      * Emits an {Approval} event.
544      */
545     function approve(address to, uint256 tokenId) external;
546 
547     /**
548      * @dev Returns the account approved for `tokenId` token.
549      *
550      * Requirements:
551      *
552      * - `tokenId` must exist.
553      */
554     function getApproved(uint256 tokenId) external view returns (address operator);
555 
556     /**
557      * @dev Approve or remove `operator` as an operator for the caller.
558      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
559      *
560      * Requirements:
561      *
562      * - The `operator` cannot be the caller.
563      *
564      * Emits an {ApprovalForAll} event.
565      */
566     function setApprovalForAll(address operator, bool _approved) external;
567 
568     /**
569      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
570      *
571      * See {setApprovalForAll}
572      */
573     function isApprovedForAll(address owner, address operator) external view returns (bool);
574 
575     /**
576       * @dev Safely transfers `tokenId` token from `from` to `to`.
577       *
578       * Requirements:
579       *
580       * - `from` cannot be the zero address.
581       * - `to` cannot be the zero address.
582       * - `tokenId` token must exist and be owned by `from`.
583       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
584       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
585       *
586       * Emits a {Transfer} event.
587       */
588     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
589 }
590 
591 
592 // File contracts/interfaces/ILobstersNft.sol
593 
594 pragma solidity 0.6.12;
595 
596 interface ILobstersNft {
597   function mintMultiple(address _to, uint256 _count) external;
598 }
599 
600 
601 // File contracts/interfaces/ICryptoPunks.sol
602 
603 pragma solidity 0.6.12;
604 
605 interface ICryptoPunks {
606   function punkIndexToAddress(uint256 _index) external view returns (address);
607 }
608 
609 
610 // File contracts/LobstersMinter.sol
611 
612 pragma solidity 0.6.12;
613 
614 contract LobstersMinter is Ownable {
615   using SafeMath for uint256;
616 
617   event SetMaxClaimAllowedByCollection(address collection, uint256 count);
618   event Claim(address indexed account, uint256 count, uint256 mintCount);
619   event ClaimByCollection(address indexed account, address indexed collection, uint256[] tokenIds, uint256 count);
620 
621   ILobstersNft public lobstersNft;
622   bytes32 public merkleRoot;
623 
624   mapping(address => uint256) public claimedCount;
625 
626   mapping(address => uint256) public maxClaimAllowedByCollection;
627   mapping(address => mapping(uint256 => bool)) public claimedByCollection;
628 
629   address public constant PUNK_COLLECTION = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB;
630 
631   constructor(
632     address _lobstersNft,
633     bytes32 _merkleRoot,
634     address[] memory _allowedCollections,
635     uint256[] memory _allowedCollectionCounts
636   ) public {
637     lobstersNft = ILobstersNft(_lobstersNft);
638     merkleRoot = _merkleRoot;
639 
640     uint256 len = _allowedCollections.length;
641     require(len == _allowedCollectionCounts.length, "LENGTHS_NOT_MATCH");
642     for (uint256 i = 0; i < len; i++) {
643       maxClaimAllowedByCollection[_allowedCollections[i]] = _allowedCollectionCounts[i];
644       emit SetMaxClaimAllowedByCollection(_allowedCollections[i], _allowedCollectionCounts[i]);
645     }
646   }
647 
648   function encode(address _account, uint256 _count) public view returns (bytes memory) {
649     return abi.encodePacked(_account, _count);
650   }
651 
652   function verifyClaim(
653     address _account,
654     uint256 _count,
655     bytes32[] calldata _merkleProof
656   ) public view returns (bool) {
657     bytes32 node = keccak256(encode(_account, _count));
658     return MerkleProof.verify(_merkleProof, merkleRoot, node);
659   }
660 
661   function claim(
662     address _account,
663     uint256 _count,
664     uint256 _mintCount,
665     bytes32[] calldata _merkleProof
666   ) external {
667     require(verifyClaim(_account, _count, _merkleProof), "INVALID_MERKLE_PROOF");
668 
669     claimedCount[_account] = claimedCount[_account].add(_mintCount);
670 
671     require(claimedCount[_account] <= _count, "MINT_COUNT_REACHED");
672 
673     lobstersNft.mintMultiple(_account, _mintCount);
674     emit Claim(_account, _count, _mintCount);
675   }
676 
677   function claimByCollection(address _collection, uint256[] memory _tokenIds) external {
678     uint256 len = _tokenIds.length;
679     require(len > 0, "NULL_LENGTH");
680 
681     address sender = _msgSender();
682     uint256 mintCount = 0;
683     for (uint256 i = 0; i < len; i++) {
684       if (_collection == PUNK_COLLECTION) {
685         require(ICryptoPunks(_collection).punkIndexToAddress(_tokenIds[i]) == sender, "TOKEN_NOT_OWNED_BY_SENDER");
686       } else {
687         require(IERC721(_collection).ownerOf(_tokenIds[i]) == sender, "TOKEN_NOT_OWNED_BY_SENDER");
688       }
689       require(!claimedByCollection[_collection][_tokenIds[i]], "ALREADY_CLAIMED_BY_TOKEN");
690 
691       claimedByCollection[_collection][_tokenIds[i]] = true;
692 
693       maxClaimAllowedByCollection[_collection] = maxClaimAllowedByCollection[_collection].sub(1);
694 
695       mintCount = mintCount.add(1);
696     }
697 
698     lobstersNft.mintMultiple(sender, mintCount);
699 
700     emit ClaimByCollection(sender, _collection, _tokenIds, len);
701   }
702 }