1 // Sources flattened with hardhat v2.4.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.2.0
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC165 standard, as defined in the
11  * https://eips.ethereum.org/EIPS/eip-165[EIP].
12  *
13  * Implementers can declare support of contract interfaces, which can then be
14  * queried by others ({ERC165Checker}).
15  *
16  * For an implementation, see {ERC165}.
17  */
18 interface IERC165 {
19     /**
20      * @dev Returns true if this contract implements the interface defined by
21      * `interfaceId`. See the corresponding
22      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
23      * to learn more about how these ids are created.
24      *
25      * This function call must use less than 30 000 gas.
26      */
27     function supportsInterface(bytes4 interfaceId) external view returns (bool);
28 }
29 
30 
31 // File contracts/IERC2981.sol
32 
33 
34 
35 pragma solidity >=0.8.5;
36 
37 ///
38 /// @dev Interface for the NFT Royalty Standard
39 ///
40 interface IERC2981 is IERC165 {
41     /// ERC165 bytes to add to interface array - set in parent contract
42     /// implementing this standard
43     ///
44     /// bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
45     /// bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
46     /// _registerInterface(_INTERFACE_ID_ERC2981);
47 
48     /// @notice Called with the sale price to determine how much royalty
49     //          is owed and to whom.
50     /// @param _tokenId - the NFT asset queried for royalty information
51     /// @param _salePrice - the sale price of the NFT asset specified by _tokenId
52     /// @return receiver - address of who should be sent the royalty payment
53     /// @return royaltyAmount - the royalty payment amount for _salePrice
54     function royaltyInfo(
55         uint256 _tokenId,
56         uint256 _salePrice
57     ) external view returns (
58         address receiver,
59         uint256 royaltyAmount
60     );
61 
62     /// @notice Informs callers that this contract supports ERC2981
63     /// @dev If `_registerInterface(_INTERFACE_ID_ERC2981)` is called
64     ///      in the initializer, this should be automatic
65     /// @param interfaceID The interface identifier, as specified in ERC-165
66     /// @return `true` if the contract implements
67     ///         `_INTERFACE_ID_ERC2981` and `false` otherwise
68     function supportsInterface(bytes4 interfaceID) external view override returns (bool);
69 }
70 
71 
72 // File @openzeppelin/contracts/utils/Context.sol@v4.2.0
73 
74 
75 
76 pragma solidity ^0.8.0;
77 
78 /*
79  * @dev Provides information about the current execution context, including the
80  * sender of the transaction and its data. While these are generally available
81  * via msg.sender and msg.data, they should not be accessed in such a direct
82  * manner, since when dealing with meta-transactions the account sending and
83  * paying for execution may not be the actual sender (as far as an application
84  * is concerned).
85  *
86  * This contract is only required for intermediate, library-like contracts.
87  */
88 abstract contract Context {
89     function _msgSender() internal view virtual returns (address) {
90         return msg.sender;
91     }
92 
93     function _msgData() internal view virtual returns (bytes calldata) {
94         return msg.data;
95     }
96 }
97 
98 
99 // File @openzeppelin/contracts/access/Ownable.sol@v4.2.0
100 
101 
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Contract module which provides a basic access control mechanism, where
107  * there is an account (an owner) that can be granted exclusive access to
108  * specific functions.
109  *
110  * By default, the owner account will be the one that deploys the contract. This
111  * can later be changed with {transferOwnership}.
112  *
113  * This module is used through inheritance. It will make available the modifier
114  * `onlyOwner`, which can be applied to your functions to restrict their use to
115  * the owner.
116  */
117 abstract contract Ownable is Context {
118     address private _owner;
119 
120     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
121 
122     /**
123      * @dev Initializes the contract setting the deployer as the initial owner.
124      */
125     constructor() {
126         _setOwner(_msgSender());
127     }
128 
129     /**
130      * @dev Returns the address of the current owner.
131      */
132     function owner() public view virtual returns (address) {
133         return _owner;
134     }
135 
136     /**
137      * @dev Throws if called by any account other than the owner.
138      */
139     modifier onlyOwner() {
140         require(owner() == _msgSender(), "Ownable: caller is not the owner");
141         _;
142     }
143 
144     /**
145      * @dev Leaves the contract without owner. It will not be possible to call
146      * `onlyOwner` functions anymore. Can only be called by the current owner.
147      *
148      * NOTE: Renouncing ownership will leave the contract without an owner,
149      * thereby removing any functionality that is only available to the owner.
150      */
151     function renounceOwnership() public virtual onlyOwner {
152         _setOwner(address(0));
153     }
154 
155     /**
156      * @dev Transfers ownership of the contract to a new account (`newOwner`).
157      * Can only be called by the current owner.
158      */
159     function transferOwnership(address newOwner) public virtual onlyOwner {
160         require(newOwner != address(0), "Ownable: new owner is the zero address");
161         _setOwner(newOwner);
162     }
163 
164     function _setOwner(address newOwner) private {
165         address oldOwner = _owner;
166         _owner = newOwner;
167         emit OwnershipTransferred(oldOwner, newOwner);
168     }
169 }
170 
171 
172 // File contracts/MerkleProof.sol
173 
174 
175 
176 pragma solidity ^0.8.5;
177 
178 /**
179  * @dev These functions deal with verification of Merkle trees (hash trees),
180  */
181 contract MerkleProof is Ownable {
182     // merkle tree root used to validate the provided address and assigned proof
183     bytes32 public root;
184 
185     /**
186      * @dev Set the merkle tree root hash
187      * @param _root hash to save
188      */
189     function setMerkleRoot(bytes32 _root) public onlyOwner {
190         require(_root.length > 0, "Root is empty");
191         require(root == bytes32(""), "Root was already assigned");
192         root = _root;
193     }
194 
195     /**
196      * @dev Modifier to check if the sender can mint tokens
197      * @param proof hashes to validate
198      */
199     modifier canMintEarly(bytes32[] memory proof) {
200         require(isProofValid(proof), "the proof for this sender is not valid");
201         _;
202     }
203 
204 
205     /**
206      * @dev Check if the sender can mint tokens
207      * @param proof hashes to validate
208      */
209     function isProofValid(bytes32[] memory proof) public view returns (bool) {
210         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
211         return verify(leaf, proof);
212     }
213 
214     /**
215      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
216      * defined by `root`. For this, a `proof` must be provided, containing
217      * sibling hashes on the branch from the leaf to the root of the tree. Each
218      * pair of leaves and each pair of pre-images are assumed to be sorted.
219      */
220     function verify(bytes32 leaf, bytes32[] memory proof)
221         internal view
222         returns (bool)
223     {
224         bytes32 computedHash = leaf;
225 
226         for (uint256 i = 0; i < proof.length; i++) {
227             bytes32 proofElement = proof[i];
228 
229             if (computedHash <= proofElement) {
230                 // Hash(current computed hash + current element of the proof)
231                 computedHash = keccak256(
232                     abi.encodePacked(computedHash, proofElement)
233                 );
234             } else {
235                 // Hash(current element of the proof + current computed hash)
236                 computedHash = keccak256(
237                     abi.encodePacked(proofElement, computedHash)
238                 );
239             }
240         }
241 
242         // Check if the computed hash (root) is equal to the provided root
243         return computedHash == root;
244     }
245 }
246 
247 
248 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.2.0
249 
250 
251 
252 pragma solidity ^0.8.0;
253 
254 /**
255  * @dev Required interface of an ERC721 compliant contract.
256  */
257 interface IERC721 is IERC165 {
258     /**
259      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
260      */
261     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
262 
263     /**
264      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
265      */
266     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
267 
268     /**
269      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
270      */
271     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
272 
273     /**
274      * @dev Returns the number of tokens in ``owner``'s account.
275      */
276     function balanceOf(address owner) external view returns (uint256 balance);
277 
278     /**
279      * @dev Returns the owner of the `tokenId` token.
280      *
281      * Requirements:
282      *
283      * - `tokenId` must exist.
284      */
285     function ownerOf(uint256 tokenId) external view returns (address owner);
286 
287     /**
288      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
289      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
290      *
291      * Requirements:
292      *
293      * - `from` cannot be the zero address.
294      * - `to` cannot be the zero address.
295      * - `tokenId` token must exist and be owned by `from`.
296      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
297      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
298      *
299      * Emits a {Transfer} event.
300      */
301     function safeTransferFrom(
302         address from,
303         address to,
304         uint256 tokenId
305     ) external;
306 
307     /**
308      * @dev Transfers `tokenId` token from `from` to `to`.
309      *
310      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
311      *
312      * Requirements:
313      *
314      * - `from` cannot be the zero address.
315      * - `to` cannot be the zero address.
316      * - `tokenId` token must be owned by `from`.
317      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transferFrom(
322         address from,
323         address to,
324         uint256 tokenId
325     ) external;
326 
327     /**
328      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
329      * The approval is cleared when the token is transferred.
330      *
331      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
332      *
333      * Requirements:
334      *
335      * - The caller must own the token or be an approved operator.
336      * - `tokenId` must exist.
337      *
338      * Emits an {Approval} event.
339      */
340     function approve(address to, uint256 tokenId) external;
341 
342     /**
343      * @dev Returns the account approved for `tokenId` token.
344      *
345      * Requirements:
346      *
347      * - `tokenId` must exist.
348      */
349     function getApproved(uint256 tokenId) external view returns (address operator);
350 
351     /**
352      * @dev Approve or remove `operator` as an operator for the caller.
353      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
354      *
355      * Requirements:
356      *
357      * - The `operator` cannot be the caller.
358      *
359      * Emits an {ApprovalForAll} event.
360      */
361     function setApprovalForAll(address operator, bool _approved) external;
362 
363     /**
364      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
365      *
366      * See {setApprovalForAll}
367      */
368     function isApprovedForAll(address owner, address operator) external view returns (bool);
369 
370     /**
371      * @dev Safely transfers `tokenId` token from `from` to `to`.
372      *
373      * Requirements:
374      *
375      * - `from` cannot be the zero address.
376      * - `to` cannot be the zero address.
377      * - `tokenId` token must exist and be owned by `from`.
378      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
379      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
380      *
381      * Emits a {Transfer} event.
382      */
383     function safeTransferFrom(
384         address from,
385         address to,
386         uint256 tokenId,
387         bytes calldata data
388     ) external;
389 }
390 
391 
392 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.2.0
393 
394 
395 
396 pragma solidity ^0.8.0;
397 
398 /**
399  * @title ERC721 token receiver interface
400  * @dev Interface for any contract that wants to support safeTransfers
401  * from ERC721 asset contracts.
402  */
403 interface IERC721Receiver {
404     /**
405      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
406      * by `operator` from `from`, this function is called.
407      *
408      * It must return its Solidity selector to confirm the token transfer.
409      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
410      *
411      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
412      */
413     function onERC721Received(
414         address operator,
415         address from,
416         uint256 tokenId,
417         bytes calldata data
418     ) external returns (bytes4);
419 }
420 
421 
422 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.2.0
423 
424 
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
430  * @dev See https://eips.ethereum.org/EIPS/eip-721
431  */
432 interface IERC721Metadata is IERC721 {
433     /**
434      * @dev Returns the token collection name.
435      */
436     function name() external view returns (string memory);
437 
438     /**
439      * @dev Returns the token collection symbol.
440      */
441     function symbol() external view returns (string memory);
442 
443     /**
444      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
445      */
446     function tokenURI(uint256 tokenId) external view returns (string memory);
447 }
448 
449 
450 // File @openzeppelin/contracts/utils/Address.sol@v4.2.0
451 
452 
453 
454 pragma solidity ^0.8.0;
455 
456 /**
457  * @dev Collection of functions related to the address type
458  */
459 library Address {
460     /**
461      * @dev Returns true if `account` is a contract.
462      *
463      * [IMPORTANT]
464      * ====
465      * It is unsafe to assume that an address for which this function returns
466      * false is an externally-owned account (EOA) and not a contract.
467      *
468      * Among others, `isContract` will return false for the following
469      * types of addresses:
470      *
471      *  - an externally-owned account
472      *  - a contract in construction
473      *  - an address where a contract will be created
474      *  - an address where a contract lived, but was destroyed
475      * ====
476      */
477     function isContract(address account) internal view returns (bool) {
478         // This method relies on extcodesize, which returns 0 for contracts in
479         // construction, since the code is only stored at the end of the
480         // constructor execution.
481 
482         uint256 size;
483         assembly {
484             size := extcodesize(account)
485         }
486         return size > 0;
487     }
488 
489     /**
490      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
491      * `recipient`, forwarding all available gas and reverting on errors.
492      *
493      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
494      * of certain opcodes, possibly making contracts go over the 2300 gas limit
495      * imposed by `transfer`, making them unable to receive funds via
496      * `transfer`. {sendValue} removes this limitation.
497      *
498      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
499      *
500      * IMPORTANT: because control is transferred to `recipient`, care must be
501      * taken to not create reentrancy vulnerabilities. Consider using
502      * {ReentrancyGuard} or the
503      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
504      */
505     function sendValue(address payable recipient, uint256 amount) internal {
506         require(address(this).balance >= amount, "Address: insufficient balance");
507 
508         (bool success, ) = recipient.call{value: amount}("");
509         require(success, "Address: unable to send value, recipient may have reverted");
510     }
511 
512     /**
513      * @dev Performs a Solidity function call using a low level `call`. A
514      * plain `call` is an unsafe replacement for a function call: use this
515      * function instead.
516      *
517      * If `target` reverts with a revert reason, it is bubbled up by this
518      * function (like regular Solidity function calls).
519      *
520      * Returns the raw returned data. To convert to the expected return value,
521      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
522      *
523      * Requirements:
524      *
525      * - `target` must be a contract.
526      * - calling `target` with `data` must not revert.
527      *
528      * _Available since v3.1._
529      */
530     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
531         return functionCall(target, data, "Address: low-level call failed");
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
536      * `errorMessage` as a fallback revert reason when `target` reverts.
537      *
538      * _Available since v3.1._
539      */
540     function functionCall(
541         address target,
542         bytes memory data,
543         string memory errorMessage
544     ) internal returns (bytes memory) {
545         return functionCallWithValue(target, data, 0, errorMessage);
546     }
547 
548     /**
549      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
550      * but also transferring `value` wei to `target`.
551      *
552      * Requirements:
553      *
554      * - the calling contract must have an ETH balance of at least `value`.
555      * - the called Solidity function must be `payable`.
556      *
557      * _Available since v3.1._
558      */
559     function functionCallWithValue(
560         address target,
561         bytes memory data,
562         uint256 value
563     ) internal returns (bytes memory) {
564         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
565     }
566 
567     /**
568      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
569      * with `errorMessage` as a fallback revert reason when `target` reverts.
570      *
571      * _Available since v3.1._
572      */
573     function functionCallWithValue(
574         address target,
575         bytes memory data,
576         uint256 value,
577         string memory errorMessage
578     ) internal returns (bytes memory) {
579         require(address(this).balance >= value, "Address: insufficient balance for call");
580         require(isContract(target), "Address: call to non-contract");
581 
582         (bool success, bytes memory returndata) = target.call{value: value}(data);
583         return _verifyCallResult(success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a static call.
589      *
590      * _Available since v3.3._
591      */
592     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
593         return functionStaticCall(target, data, "Address: low-level static call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a static call.
599      *
600      * _Available since v3.3._
601      */
602     function functionStaticCall(
603         address target,
604         bytes memory data,
605         string memory errorMessage
606     ) internal view returns (bytes memory) {
607         require(isContract(target), "Address: static call to non-contract");
608 
609         (bool success, bytes memory returndata) = target.staticcall(data);
610         return _verifyCallResult(success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
615      * but performing a delegate call.
616      *
617      * _Available since v3.4._
618      */
619     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
620         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
625      * but performing a delegate call.
626      *
627      * _Available since v3.4._
628      */
629     function functionDelegateCall(
630         address target,
631         bytes memory data,
632         string memory errorMessage
633     ) internal returns (bytes memory) {
634         require(isContract(target), "Address: delegate call to non-contract");
635 
636         (bool success, bytes memory returndata) = target.delegatecall(data);
637         return _verifyCallResult(success, returndata, errorMessage);
638     }
639 
640     function _verifyCallResult(
641         bool success,
642         bytes memory returndata,
643         string memory errorMessage
644     ) private pure returns (bytes memory) {
645         if (success) {
646             return returndata;
647         } else {
648             // Look for revert reason and bubble it up if present
649             if (returndata.length > 0) {
650                 // The easiest way to bubble the revert reason is using memory via assembly
651 
652                 assembly {
653                     let returndata_size := mload(returndata)
654                     revert(add(32, returndata), returndata_size)
655                 }
656             } else {
657                 revert(errorMessage);
658             }
659         }
660     }
661 }
662 
663 
664 // File @openzeppelin/contracts/utils/Strings.sol@v4.2.0
665 
666 
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @dev String operations.
672  */
673 library Strings {
674     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
675 
676     /**
677      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
678      */
679     function toString(uint256 value) internal pure returns (string memory) {
680         // Inspired by OraclizeAPI's implementation - MIT licence
681         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
682 
683         if (value == 0) {
684             return "0";
685         }
686         uint256 temp = value;
687         uint256 digits;
688         while (temp != 0) {
689             digits++;
690             temp /= 10;
691         }
692         bytes memory buffer = new bytes(digits);
693         while (value != 0) {
694             digits -= 1;
695             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
696             value /= 10;
697         }
698         return string(buffer);
699     }
700 
701     /**
702      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
703      */
704     function toHexString(uint256 value) internal pure returns (string memory) {
705         if (value == 0) {
706             return "0x00";
707         }
708         uint256 temp = value;
709         uint256 length = 0;
710         while (temp != 0) {
711             length++;
712             temp >>= 8;
713         }
714         return toHexString(value, length);
715     }
716 
717     /**
718      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
719      */
720     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
721         bytes memory buffer = new bytes(2 * length + 2);
722         buffer[0] = "0";
723         buffer[1] = "x";
724         for (uint256 i = 2 * length + 1; i > 1; --i) {
725             buffer[i] = _HEX_SYMBOLS[value & 0xf];
726             value >>= 4;
727         }
728         require(value == 0, "Strings: hex length insufficient");
729         return string(buffer);
730     }
731 }
732 
733 
734 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.2.0
735 
736 
737 
738 pragma solidity ^0.8.0;
739 
740 /**
741  * @dev Implementation of the {IERC165} interface.
742  *
743  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
744  * for the additional interface id that will be supported. For example:
745  *
746  * ```solidity
747  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
748  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
749  * }
750  * ```
751  *
752  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
753  */
754 abstract contract ERC165 is IERC165 {
755     /**
756      * @dev See {IERC165-supportsInterface}.
757      */
758     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
759         return interfaceId == type(IERC165).interfaceId;
760     }
761 }
762 
763 
764 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.2.0
765 
766 
767 
768 pragma solidity ^0.8.0;
769 
770 
771 
772 
773 
774 
775 
776 /**
777  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
778  * the Metadata extension, but not including the Enumerable extension, which is available separately as
779  * {ERC721Enumerable}.
780  */
781 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
782     using Address for address;
783     using Strings for uint256;
784 
785     // Token name
786     string private _name;
787 
788     // Token symbol
789     string private _symbol;
790 
791     // Mapping from token ID to owner address
792     mapping(uint256 => address) private _owners;
793 
794     // Mapping owner address to token count
795     mapping(address => uint256) private _balances;
796 
797     // Mapping from token ID to approved address
798     mapping(uint256 => address) private _tokenApprovals;
799 
800     // Mapping from owner to operator approvals
801     mapping(address => mapping(address => bool)) private _operatorApprovals;
802 
803     /**
804      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
805      */
806     constructor(string memory name_, string memory symbol_) {
807         _name = name_;
808         _symbol = symbol_;
809     }
810 
811     /**
812      * @dev See {IERC165-supportsInterface}.
813      */
814     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
815         return
816             interfaceId == type(IERC721).interfaceId ||
817             interfaceId == type(IERC721Metadata).interfaceId ||
818             super.supportsInterface(interfaceId);
819     }
820 
821     /**
822      * @dev See {IERC721-balanceOf}.
823      */
824     function balanceOf(address owner) public view virtual override returns (uint256) {
825         require(owner != address(0), "ERC721: balance query for the zero address");
826         return _balances[owner];
827     }
828 
829     /**
830      * @dev See {IERC721-ownerOf}.
831      */
832     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
833         address owner = _owners[tokenId];
834         require(owner != address(0), "ERC721: owner query for nonexistent token");
835         return owner;
836     }
837 
838     /**
839      * @dev See {IERC721Metadata-name}.
840      */
841     function name() public view virtual override returns (string memory) {
842         return _name;
843     }
844 
845     /**
846      * @dev See {IERC721Metadata-symbol}.
847      */
848     function symbol() public view virtual override returns (string memory) {
849         return _symbol;
850     }
851 
852     /**
853      * @dev See {IERC721Metadata-tokenURI}.
854      */
855     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
856         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
857 
858         string memory baseURI = _baseURI();
859         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
860     }
861 
862     /**
863      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
864      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
865      * by default, can be overriden in child contracts.
866      */
867     function _baseURI() internal view virtual returns (string memory) {
868         return "";
869     }
870 
871     /**
872      * @dev See {IERC721-approve}.
873      */
874     function approve(address to, uint256 tokenId) public virtual override {
875         address owner = ERC721.ownerOf(tokenId);
876         require(to != owner, "ERC721: approval to current owner");
877 
878         require(
879             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
880             "ERC721: approve caller is not owner nor approved for all"
881         );
882 
883         _approve(to, tokenId);
884     }
885 
886     /**
887      * @dev See {IERC721-getApproved}.
888      */
889     function getApproved(uint256 tokenId) public view virtual override returns (address) {
890         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
891 
892         return _tokenApprovals[tokenId];
893     }
894 
895     /**
896      * @dev See {IERC721-setApprovalForAll}.
897      */
898     function setApprovalForAll(address operator, bool approved) public virtual override {
899         require(operator != _msgSender(), "ERC721: approve to caller");
900 
901         _operatorApprovals[_msgSender()][operator] = approved;
902         emit ApprovalForAll(_msgSender(), operator, approved);
903     }
904 
905     /**
906      * @dev See {IERC721-isApprovedForAll}.
907      */
908     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
909         return _operatorApprovals[owner][operator];
910     }
911 
912     /**
913      * @dev See {IERC721-transferFrom}.
914      */
915     function transferFrom(
916         address from,
917         address to,
918         uint256 tokenId
919     ) public virtual override {
920         //solhint-disable-next-line max-line-length
921         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
922 
923         _transfer(from, to, tokenId);
924     }
925 
926     /**
927      * @dev See {IERC721-safeTransferFrom}.
928      */
929     function safeTransferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public virtual override {
934         safeTransferFrom(from, to, tokenId, "");
935     }
936 
937     /**
938      * @dev See {IERC721-safeTransferFrom}.
939      */
940     function safeTransferFrom(
941         address from,
942         address to,
943         uint256 tokenId,
944         bytes memory _data
945     ) public virtual override {
946         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
947         _safeTransfer(from, to, tokenId, _data);
948     }
949 
950     /**
951      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
952      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
953      *
954      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
955      *
956      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
957      * implement alternative mechanisms to perform token transfer, such as signature-based.
958      *
959      * Requirements:
960      *
961      * - `from` cannot be the zero address.
962      * - `to` cannot be the zero address.
963      * - `tokenId` token must exist and be owned by `from`.
964      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
965      *
966      * Emits a {Transfer} event.
967      */
968     function _safeTransfer(
969         address from,
970         address to,
971         uint256 tokenId,
972         bytes memory _data
973     ) internal virtual {
974         _transfer(from, to, tokenId);
975         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
976     }
977 
978     /**
979      * @dev Returns whether `tokenId` exists.
980      *
981      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
982      *
983      * Tokens start existing when they are minted (`_mint`),
984      * and stop existing when they are burned (`_burn`).
985      */
986     function _exists(uint256 tokenId) internal view virtual returns (bool) {
987         return _owners[tokenId] != address(0);
988     }
989 
990     /**
991      * @dev Returns whether `spender` is allowed to manage `tokenId`.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      */
997     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
998         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
999         address owner = ERC721.ownerOf(tokenId);
1000         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1001     }
1002 
1003     /**
1004      * @dev Safely mints `tokenId` and transfers it to `to`.
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must not exist.
1009      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function _safeMint(address to, uint256 tokenId) internal virtual {
1014         _safeMint(to, tokenId, "");
1015     }
1016 
1017     /**
1018      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1019      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1020      */
1021     function _safeMint(
1022         address to,
1023         uint256 tokenId,
1024         bytes memory _data
1025     ) internal virtual {
1026         _mint(to, tokenId);
1027         require(
1028             _checkOnERC721Received(address(0), to, tokenId, _data),
1029             "ERC721: transfer to non ERC721Receiver implementer"
1030         );
1031     }
1032 
1033     /**
1034      * @dev Mints `tokenId` and transfers it to `to`.
1035      *
1036      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1037      *
1038      * Requirements:
1039      *
1040      * - `tokenId` must not exist.
1041      * - `to` cannot be the zero address.
1042      *
1043      * Emits a {Transfer} event.
1044      */
1045     function _mint(address to, uint256 tokenId) internal virtual {
1046         require(to != address(0), "ERC721: mint to the zero address");
1047         require(!_exists(tokenId), "ERC721: token already minted");
1048 
1049         _beforeTokenTransfer(address(0), to, tokenId);
1050 
1051         _balances[to] += 1;
1052         _owners[tokenId] = to;
1053 
1054         emit Transfer(address(0), to, tokenId);
1055     }
1056 
1057     /**
1058      * @dev Destroys `tokenId`.
1059      * The approval is cleared when the token is burned.
1060      *
1061      * Requirements:
1062      *
1063      * - `tokenId` must exist.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function _burn(uint256 tokenId) internal virtual {
1068         address owner = ERC721.ownerOf(tokenId);
1069 
1070         _beforeTokenTransfer(owner, address(0), tokenId);
1071 
1072         // Clear approvals
1073         _approve(address(0), tokenId);
1074 
1075         _balances[owner] -= 1;
1076         delete _owners[tokenId];
1077 
1078         emit Transfer(owner, address(0), tokenId);
1079     }
1080 
1081     /**
1082      * @dev Transfers `tokenId` from `from` to `to`.
1083      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `tokenId` token must be owned by `from`.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _transfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) internal virtual {
1097         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1098         require(to != address(0), "ERC721: transfer to the zero address");
1099 
1100         _beforeTokenTransfer(from, to, tokenId);
1101 
1102         // Clear approvals from the previous owner
1103         _approve(address(0), tokenId);
1104 
1105         _balances[from] -= 1;
1106         _balances[to] += 1;
1107         _owners[tokenId] = to;
1108 
1109         emit Transfer(from, to, tokenId);
1110     }
1111 
1112     /**
1113      * @dev Approve `to` to operate on `tokenId`
1114      *
1115      * Emits a {Approval} event.
1116      */
1117     function _approve(address to, uint256 tokenId) internal virtual {
1118         _tokenApprovals[tokenId] = to;
1119         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1124      * The call is not executed if the target address is not a contract.
1125      *
1126      * @param from address representing the previous owner of the given token ID
1127      * @param to target address that will receive the tokens
1128      * @param tokenId uint256 ID of the token to be transferred
1129      * @param _data bytes optional data to send along with the call
1130      * @return bool whether the call correctly returned the expected magic value
1131      */
1132     function _checkOnERC721Received(
1133         address from,
1134         address to,
1135         uint256 tokenId,
1136         bytes memory _data
1137     ) private returns (bool) {
1138         if (to.isContract()) {
1139             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1140                 return retval == IERC721Receiver(to).onERC721Received.selector;
1141             } catch (bytes memory reason) {
1142                 if (reason.length == 0) {
1143                     revert("ERC721: transfer to non ERC721Receiver implementer");
1144                 } else {
1145                     assembly {
1146                         revert(add(32, reason), mload(reason))
1147                     }
1148                 }
1149             }
1150         } else {
1151             return true;
1152         }
1153     }
1154 
1155     /**
1156      * @dev Hook that is called before any token transfer. This includes minting
1157      * and burning.
1158      *
1159      * Calling conditions:
1160      *
1161      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1162      * transferred to `to`.
1163      * - When `from` is zero, `tokenId` will be minted for `to`.
1164      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1165      * - `from` and `to` are never both zero.
1166      *
1167      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1168      */
1169     function _beforeTokenTransfer(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) internal virtual {}
1174 }
1175 
1176 
1177 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.2.0
1178 
1179 
1180 
1181 pragma solidity ^0.8.0;
1182 
1183 // CAUTION
1184 // This version of SafeMath should only be used with Solidity 0.8 or later,
1185 // because it relies on the compiler's built in overflow checks.
1186 
1187 /**
1188  * @dev Wrappers over Solidity's arithmetic operations.
1189  *
1190  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1191  * now has built in overflow checking.
1192  */
1193 library SafeMath {
1194     /**
1195      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1196      *
1197      * _Available since v3.4._
1198      */
1199     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1200         unchecked {
1201             uint256 c = a + b;
1202             if (c < a) return (false, 0);
1203             return (true, c);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1209      *
1210      * _Available since v3.4._
1211      */
1212     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1213         unchecked {
1214             if (b > a) return (false, 0);
1215             return (true, a - b);
1216         }
1217     }
1218 
1219     /**
1220      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1221      *
1222      * _Available since v3.4._
1223      */
1224     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1225         unchecked {
1226             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1227             // benefit is lost if 'b' is also tested.
1228             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1229             if (a == 0) return (true, 0);
1230             uint256 c = a * b;
1231             if (c / a != b) return (false, 0);
1232             return (true, c);
1233         }
1234     }
1235 
1236     /**
1237      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1238      *
1239      * _Available since v3.4._
1240      */
1241     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1242         unchecked {
1243             if (b == 0) return (false, 0);
1244             return (true, a / b);
1245         }
1246     }
1247 
1248     /**
1249      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1250      *
1251      * _Available since v3.4._
1252      */
1253     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1254         unchecked {
1255             if (b == 0) return (false, 0);
1256             return (true, a % b);
1257         }
1258     }
1259 
1260     /**
1261      * @dev Returns the addition of two unsigned integers, reverting on
1262      * overflow.
1263      *
1264      * Counterpart to Solidity's `+` operator.
1265      *
1266      * Requirements:
1267      *
1268      * - Addition cannot overflow.
1269      */
1270     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1271         return a + b;
1272     }
1273 
1274     /**
1275      * @dev Returns the subtraction of two unsigned integers, reverting on
1276      * overflow (when the result is negative).
1277      *
1278      * Counterpart to Solidity's `-` operator.
1279      *
1280      * Requirements:
1281      *
1282      * - Subtraction cannot overflow.
1283      */
1284     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1285         return a - b;
1286     }
1287 
1288     /**
1289      * @dev Returns the multiplication of two unsigned integers, reverting on
1290      * overflow.
1291      *
1292      * Counterpart to Solidity's `*` operator.
1293      *
1294      * Requirements:
1295      *
1296      * - Multiplication cannot overflow.
1297      */
1298     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1299         return a * b;
1300     }
1301 
1302     /**
1303      * @dev Returns the integer division of two unsigned integers, reverting on
1304      * division by zero. The result is rounded towards zero.
1305      *
1306      * Counterpart to Solidity's `/` operator.
1307      *
1308      * Requirements:
1309      *
1310      * - The divisor cannot be zero.
1311      */
1312     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1313         return a / b;
1314     }
1315 
1316     /**
1317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1318      * reverting when dividing by zero.
1319      *
1320      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1321      * opcode (which leaves remaining gas untouched) while Solidity uses an
1322      * invalid opcode to revert (consuming all remaining gas).
1323      *
1324      * Requirements:
1325      *
1326      * - The divisor cannot be zero.
1327      */
1328     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1329         return a % b;
1330     }
1331 
1332     /**
1333      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1334      * overflow (when the result is negative).
1335      *
1336      * CAUTION: This function is deprecated because it requires allocating memory for the error
1337      * message unnecessarily. For custom revert reasons use {trySub}.
1338      *
1339      * Counterpart to Solidity's `-` operator.
1340      *
1341      * Requirements:
1342      *
1343      * - Subtraction cannot overflow.
1344      */
1345     function sub(
1346         uint256 a,
1347         uint256 b,
1348         string memory errorMessage
1349     ) internal pure returns (uint256) {
1350         unchecked {
1351             require(b <= a, errorMessage);
1352             return a - b;
1353         }
1354     }
1355 
1356     /**
1357      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1358      * division by zero. The result is rounded towards zero.
1359      *
1360      * Counterpart to Solidity's `/` operator. Note: this function uses a
1361      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1362      * uses an invalid opcode to revert (consuming all remaining gas).
1363      *
1364      * Requirements:
1365      *
1366      * - The divisor cannot be zero.
1367      */
1368     function div(
1369         uint256 a,
1370         uint256 b,
1371         string memory errorMessage
1372     ) internal pure returns (uint256) {
1373         unchecked {
1374             require(b > 0, errorMessage);
1375             return a / b;
1376         }
1377     }
1378 
1379     /**
1380      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1381      * reverting with custom message when dividing by zero.
1382      *
1383      * CAUTION: This function is deprecated because it requires allocating memory for the error
1384      * message unnecessarily. For custom revert reasons use {tryMod}.
1385      *
1386      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1387      * opcode (which leaves remaining gas untouched) while Solidity uses an
1388      * invalid opcode to revert (consuming all remaining gas).
1389      *
1390      * Requirements:
1391      *
1392      * - The divisor cannot be zero.
1393      */
1394     function mod(
1395         uint256 a,
1396         uint256 b,
1397         string memory errorMessage
1398     ) internal pure returns (uint256) {
1399         unchecked {
1400             require(b > 0, errorMessage);
1401             return a % b;
1402         }
1403     }
1404 }
1405 
1406 
1407 // File @openzeppelin/contracts/security/Pausable.sol@v4.2.0
1408 
1409 
1410 
1411 pragma solidity ^0.8.0;
1412 
1413 /**
1414  * @dev Contract module which allows children to implement an emergency stop
1415  * mechanism that can be triggered by an authorized account.
1416  *
1417  * This module is used through inheritance. It will make available the
1418  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1419  * the functions of your contract. Note that they will not be pausable by
1420  * simply including this module, only once the modifiers are put in place.
1421  */
1422 abstract contract Pausable is Context {
1423     /**
1424      * @dev Emitted when the pause is triggered by `account`.
1425      */
1426     event Paused(address account);
1427 
1428     /**
1429      * @dev Emitted when the pause is lifted by `account`.
1430      */
1431     event Unpaused(address account);
1432 
1433     bool private _paused;
1434 
1435     /**
1436      * @dev Initializes the contract in unpaused state.
1437      */
1438     constructor() {
1439         _paused = false;
1440     }
1441 
1442     /**
1443      * @dev Returns true if the contract is paused, and false otherwise.
1444      */
1445     function paused() public view virtual returns (bool) {
1446         return _paused;
1447     }
1448 
1449     /**
1450      * @dev Modifier to make a function callable only when the contract is not paused.
1451      *
1452      * Requirements:
1453      *
1454      * - The contract must not be paused.
1455      */
1456     modifier whenNotPaused() {
1457         require(!paused(), "Pausable: paused");
1458         _;
1459     }
1460 
1461     /**
1462      * @dev Modifier to make a function callable only when the contract is paused.
1463      *
1464      * Requirements:
1465      *
1466      * - The contract must be paused.
1467      */
1468     modifier whenPaused() {
1469         require(paused(), "Pausable: not paused");
1470         _;
1471     }
1472 
1473     /**
1474      * @dev Triggers stopped state.
1475      *
1476      * Requirements:
1477      *
1478      * - The contract must not be paused.
1479      */
1480     function _pause() internal virtual whenNotPaused {
1481         _paused = true;
1482         emit Paused(_msgSender());
1483     }
1484 
1485     /**
1486      * @dev Returns to normal state.
1487      *
1488      * Requirements:
1489      *
1490      * - The contract must be paused.
1491      */
1492     function _unpause() internal virtual whenPaused {
1493         _paused = false;
1494         emit Unpaused(_msgSender());
1495     }
1496 }
1497 
1498 
1499 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol@v4.2.0
1500 
1501 
1502 
1503 pragma solidity ^0.8.0;
1504 
1505 
1506 /**
1507  * @dev ERC721 token with pausable token transfers, minting and burning.
1508  *
1509  * Useful for scenarios such as preventing trades until the end of an evaluation
1510  * period, or having an emergency switch for freezing all token transfers in the
1511  * event of a large bug.
1512  */
1513 abstract contract ERC721Pausable is ERC721, Pausable {
1514     /**
1515      * @dev See {ERC721-_beforeTokenTransfer}.
1516      *
1517      * Requirements:
1518      *
1519      * - the contract must not be paused.
1520      */
1521     function _beforeTokenTransfer(
1522         address from,
1523         address to,
1524         uint256 tokenId
1525     ) internal virtual override {
1526         super._beforeTokenTransfer(from, to, tokenId);
1527 
1528         require(!paused(), "ERC721Pausable: token transfer while paused");
1529     }
1530 }
1531 
1532 
1533 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.2.0
1534 
1535 
1536 
1537 pragma solidity ^0.8.0;
1538 
1539 /**
1540  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1541  * @dev See https://eips.ethereum.org/EIPS/eip-721
1542  */
1543 interface IERC721Enumerable is IERC721 {
1544     /**
1545      * @dev Returns the total amount of tokens stored by the contract.
1546      */
1547     function totalSupply() external view returns (uint256);
1548 
1549     /**
1550      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1551      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1552      */
1553     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1554 
1555     /**
1556      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1557      * Use along with {totalSupply} to enumerate all tokens.
1558      */
1559     function tokenByIndex(uint256 index) external view returns (uint256);
1560 }
1561 
1562 
1563 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.2.0
1564 
1565 
1566 
1567 pragma solidity ^0.8.0;
1568 
1569 
1570 /**
1571  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1572  * enumerability of all the token ids in the contract as well as all token ids owned by each
1573  * account.
1574  */
1575 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1576     // Mapping from owner to list of owned token IDs
1577     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1578 
1579     // Mapping from token ID to index of the owner tokens list
1580     mapping(uint256 => uint256) private _ownedTokensIndex;
1581 
1582     // Array with all token ids, used for enumeration
1583     uint256[] private _allTokens;
1584 
1585     // Mapping from token id to position in the allTokens array
1586     mapping(uint256 => uint256) private _allTokensIndex;
1587 
1588     /**
1589      * @dev See {IERC165-supportsInterface}.
1590      */
1591     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1592         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1593     }
1594 
1595     /**
1596      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1597      */
1598     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1599         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1600         return _ownedTokens[owner][index];
1601     }
1602 
1603     /**
1604      * @dev See {IERC721Enumerable-totalSupply}.
1605      */
1606     function totalSupply() public view virtual override returns (uint256) {
1607         return _allTokens.length;
1608     }
1609 
1610     /**
1611      * @dev See {IERC721Enumerable-tokenByIndex}.
1612      */
1613     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1614         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1615         return _allTokens[index];
1616     }
1617 
1618     /**
1619      * @dev Hook that is called before any token transfer. This includes minting
1620      * and burning.
1621      *
1622      * Calling conditions:
1623      *
1624      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1625      * transferred to `to`.
1626      * - When `from` is zero, `tokenId` will be minted for `to`.
1627      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1628      * - `from` cannot be the zero address.
1629      * - `to` cannot be the zero address.
1630      *
1631      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1632      */
1633     function _beforeTokenTransfer(
1634         address from,
1635         address to,
1636         uint256 tokenId
1637     ) internal virtual override {
1638         super._beforeTokenTransfer(from, to, tokenId);
1639 
1640         if (from == address(0)) {
1641             _addTokenToAllTokensEnumeration(tokenId);
1642         } else if (from != to) {
1643             _removeTokenFromOwnerEnumeration(from, tokenId);
1644         }
1645         if (to == address(0)) {
1646             _removeTokenFromAllTokensEnumeration(tokenId);
1647         } else if (to != from) {
1648             _addTokenToOwnerEnumeration(to, tokenId);
1649         }
1650     }
1651 
1652     /**
1653      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1654      * @param to address representing the new owner of the given token ID
1655      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1656      */
1657     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1658         uint256 length = ERC721.balanceOf(to);
1659         _ownedTokens[to][length] = tokenId;
1660         _ownedTokensIndex[tokenId] = length;
1661     }
1662 
1663     /**
1664      * @dev Private function to add a token to this extension's token tracking data structures.
1665      * @param tokenId uint256 ID of the token to be added to the tokens list
1666      */
1667     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1668         _allTokensIndex[tokenId] = _allTokens.length;
1669         _allTokens.push(tokenId);
1670     }
1671 
1672     /**
1673      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1674      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1675      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1676      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1677      * @param from address representing the previous owner of the given token ID
1678      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1679      */
1680     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1681         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1682         // then delete the last slot (swap and pop).
1683 
1684         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1685         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1686 
1687         // When the token to delete is the last token, the swap operation is unnecessary
1688         if (tokenIndex != lastTokenIndex) {
1689             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1690 
1691             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1692             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1693         }
1694 
1695         // This also deletes the contents at the last position of the array
1696         delete _ownedTokensIndex[tokenId];
1697         delete _ownedTokens[from][lastTokenIndex];
1698     }
1699 
1700     /**
1701      * @dev Private function to remove a token from this extension's token tracking data structures.
1702      * This has O(1) time complexity, but alters the order of the _allTokens array.
1703      * @param tokenId uint256 ID of the token to be removed from the tokens list
1704      */
1705     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1706         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1707         // then delete the last slot (swap and pop).
1708 
1709         uint256 lastTokenIndex = _allTokens.length - 1;
1710         uint256 tokenIndex = _allTokensIndex[tokenId];
1711 
1712         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1713         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1714         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1715         uint256 lastTokenId = _allTokens[lastTokenIndex];
1716 
1717         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1718         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1719 
1720         // This also deletes the contents at the last position of the array
1721         delete _allTokensIndex[tokenId];
1722         _allTokens.pop();
1723     }
1724 }
1725 
1726 
1727 // File @openzeppelin/contracts/utils/introspection/ERC165Storage.sol@v4.2.0
1728 
1729 
1730 
1731 pragma solidity ^0.8.0;
1732 
1733 /**
1734  * @dev Storage based implementation of the {IERC165} interface.
1735  *
1736  * Contracts may inherit from this and call {_registerInterface} to declare
1737  * their support of an interface.
1738  */
1739 abstract contract ERC165Storage is ERC165 {
1740     /**
1741      * @dev Mapping of interface ids to whether or not it's supported.
1742      */
1743     mapping(bytes4 => bool) private _supportedInterfaces;
1744 
1745     /**
1746      * @dev See {IERC165-supportsInterface}.
1747      */
1748     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1749         return super.supportsInterface(interfaceId) || _supportedInterfaces[interfaceId];
1750     }
1751 
1752     /**
1753      * @dev Registers the contract as an implementer of the interface defined by
1754      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1755      * registering its interface id is not required.
1756      *
1757      * See {IERC165-supportsInterface}.
1758      *
1759      * Requirements:
1760      *
1761      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1762      */
1763     function _registerInterface(bytes4 interfaceId) internal virtual {
1764         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1765         _supportedInterfaces[interfaceId] = true;
1766     }
1767 }
1768 
1769 
1770 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.2.0
1771 
1772 
1773 
1774 pragma solidity ^0.8.0;
1775 
1776 /**
1777  * @dev Contract module that helps prevent reentrant calls to a function.
1778  *
1779  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1780  * available, which can be applied to functions to make sure there are no nested
1781  * (reentrant) calls to them.
1782  *
1783  * Note that because there is a single `nonReentrant` guard, functions marked as
1784  * `nonReentrant` may not call one another. This can be worked around by making
1785  * those functions `private`, and then adding `external` `nonReentrant` entry
1786  * points to them.
1787  *
1788  * TIP: If you would like to learn more about reentrancy and alternative ways
1789  * to protect against it, check out our blog post
1790  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1791  */
1792 abstract contract ReentrancyGuard {
1793     // Booleans are more expensive than uint256 or any type that takes up a full
1794     // word because each write operation emits an extra SLOAD to first read the
1795     // slot's contents, replace the bits taken up by the boolean, and then write
1796     // back. This is the compiler's defense against contract upgrades and
1797     // pointer aliasing, and it cannot be disabled.
1798 
1799     // The values being non-zero value makes deployment a bit more expensive,
1800     // but in exchange the refund on every call to nonReentrant will be lower in
1801     // amount. Since refunds are capped to a percentage of the total
1802     // transaction's gas, it is best to keep them low in cases like this one, to
1803     // increase the likelihood of the full refund coming into effect.
1804     uint256 private constant _NOT_ENTERED = 1;
1805     uint256 private constant _ENTERED = 2;
1806 
1807     uint256 private _status;
1808 
1809     constructor() {
1810         _status = _NOT_ENTERED;
1811     }
1812 
1813     /**
1814      * @dev Prevents a contract from calling itself, directly or indirectly.
1815      * Calling a `nonReentrant` function from another `nonReentrant`
1816      * function is not supported. It is possible to prevent this from happening
1817      * by making the `nonReentrant` function external, and make it call a
1818      * `private` function that does the actual work.
1819      */
1820     modifier nonReentrant() {
1821         // On the first call to nonReentrant, _notEntered will be true
1822         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1823 
1824         // Any calls to nonReentrant after this point will fail
1825         _status = _ENTERED;
1826 
1827         _;
1828 
1829         // By storing the original value once again, a refund is triggered (see
1830         // https://eips.ethereum.org/EIPS/eip-2200)
1831         _status = _NOT_ENTERED;
1832     }
1833 }
1834 
1835 
1836 // File contracts/ReaperHills.sol
1837 
1838 
1839 
1840 pragma solidity >=0.8.5;
1841 
1842 
1843 
1844 
1845 
1846 
1847 
1848 
1849 
1850 
1851 
1852 
1853 contract ReaperHills is
1854     MerkleProof,
1855     ERC165Storage,
1856     ERC721Pausable,
1857     ERC721Enumerable,
1858     ReentrancyGuard
1859 {
1860     using SafeMath for uint256;
1861 
1862     // struct that holds information about when a token was created/transferred
1863     struct NFTDetails {
1864         uint256 tokenId;
1865         uint256 starTime;
1866         uint256 endTime;
1867     }
1868 
1869     // emits BaseURIChanged event when the baseUri changes
1870     event BaseURIChanged(
1871         address indexed _owner,
1872         string initialBaseURI,
1873         string finalBaseURI
1874     );
1875     // interface used by marketplaces to get the royalty for a specific sell
1876     bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1877 
1878     // maximum number of tokens that can be minted
1879     uint256 public constant MAX_TOKENS = 10000;
1880     // maximum number of tokens that can be early minted in a single transaction
1881     uint256 public constant MAX_EARLY_TOKENS_PER_PURCHASE = 25;
1882     // maximum number of tokens that can be early minted in a single transaction first day
1883     uint256 public constant MAX_EARLY_TOKENS_PER_PURCHASE_FIRST_DAY = 5;
1884     // maximum number of tokens that can be minted in a single transaction
1885     uint256 public constant MAX_TOKENS_PER_PURCHASE = 50;
1886 
1887     // the price to mint a token
1888     uint256 public constant MINT_PRICE = 60000000000000000; // 0.06 Ether
1889 
1890     // Reserved tokens for Team/Giveaways/Airdrops etc
1891     uint256 public reservedTokens = 100;
1892     // Already minted reserved tokens
1893     uint256 public mintedReservedTokens = 0;
1894 
1895     uint256 public mintingStartTime;
1896 
1897     mapping(address => uint256) public earlyMintedTokensByOwner;
1898 
1899     // royalty got from a sell
1900     uint256 public constant ROYALTY_SELL_PERCENT = 10; // 10% of sell price
1901     // part of royalty that is being distributed to the team 1
1902     uint256 public constant ROYALTY_SELL_PERCENT_TEAM_1 = 40; // 2% of sell price
1903     // part of royalty that is being distributed to the team 2
1904     uint256 public constant ROYALTY_SELL_PERCENT_TEAM_2 = 40; // 2% of sell price
1905     // part of royalty that is being distributed to the team 3
1906     uint256 public constant ROYALTY_SELL_PERCENT_TEAM_3 = 15; // 0.75% of sell price
1907     // part of royalty that is being distributed to the team 4
1908     uint256 public constant ROYALTY_SELL_PERCENT_TEAM_4 = 5; // 0.25% of sell price
1909 
1910     // address team 1 to receive part of royalty
1911     address public royaltyReceiverTeam1;
1912     // address team 2 to receive part of royalty
1913     address public royaltyReceiverTeam2;
1914     // address team 3 to receive part of royalty
1915     address public royaltyReceiverTeam3;
1916     // address team 4 to receive part of royalty
1917     address public royaltyReceiverTeam4;
1918     // address team 4 to receive part of royalty
1919     address public communityAddress;
1920 
1921     // allow early adopters to mint tokens. Once disabled can't be enabled back
1922     bool public earlyMinting = true;
1923     // flag to signal if the owner can change the BaseURI
1924     bool public canChangeBaseURI = true;
1925     // the base uri where the NFT metadata would point to
1926     string public baseURI = "";
1927 
1928     // hash to proof that the images and metadata from IPFS is valid
1929     string public provenance = "";
1930 
1931     // mapping from owner to list of token ids
1932     mapping(address => uint256[]) public ownerTokenList;
1933     // mapping from token ID to token details of the owner tokens list
1934     mapping(address => mapping(uint256 => NFTDetails))
1935         public ownedTokensDetails;
1936 
1937     // nonce to be used on generating the random token id
1938     uint256 private nonce = 0;
1939     uint256[MAX_TOKENS] private indices;
1940 
1941     constructor(
1942         string memory name_,
1943         string memory symbol_,
1944         address royaltyReceiver1_,
1945         address royaltyReceiver2_,
1946         address royaltyReceiver3_,
1947         address royaltyReceiver4_,
1948         address communityAddress_
1949     ) ERC721(name_, symbol_) {
1950         royaltyReceiverTeam1 = royaltyReceiver1_;
1951         royaltyReceiverTeam2 = royaltyReceiver2_;
1952         royaltyReceiverTeam3 = royaltyReceiver3_;
1953         royaltyReceiverTeam4 = royaltyReceiver4_;
1954         communityAddress = communityAddress_;
1955 
1956         // register the supported interfaces to conform to ERC721 via ERC165
1957         _registerInterface(type(IERC721).interfaceId);
1958         _registerInterface(type(IERC721Metadata).interfaceId);
1959         _registerInterface(type(IERC721Enumerable).interfaceId);
1960     }
1961 
1962     function firstMints() public onlyOwner {
1963         for (uint8 id = 1; id <= 6; id++) {
1964             indices[id - 1] = MAX_TOKENS - totalSupply() - 1;
1965             ownerTokenList[communityAddress].push(id);
1966             ownedTokensDetails[communityAddress][id] = NFTDetails(
1967                 id,
1968                 block.timestamp,
1969                 0
1970             );
1971             _safeMint(communityAddress, id);
1972         }
1973     }
1974 
1975     /*
1976      * accepts ether sent with no txData
1977      */
1978     receive() external payable {}
1979 
1980     /*
1981      * refuses ether sent with txData that does not match any function signature in the contract
1982      */
1983     fallback() external {}
1984 
1985     /**
1986      * @dev Triggers stopped state.
1987      *
1988      * Requirements:
1989      *
1990      * - The contract must not be paused.
1991      */
1992     function pause() public onlyOwner {
1993         super._pause();
1994     }
1995 
1996     /**
1997      * @dev Returns to normal state.
1998      *
1999      * Requirements:
2000      *
2001      * - The contract must be paused.
2002      */
2003     function unpause() public onlyOwner {
2004         super._unpause();
2005     }
2006 
2007     /**
2008      * @dev See {ERC721-_beforeTokenTransfer}.
2009      *
2010      * Requirements:
2011      *
2012      * - the contract must not be paused.
2013      */
2014     function _beforeTokenTransfer(
2015         address from,
2016         address to,
2017         uint256 tokenId
2018     ) internal virtual override(ERC721Pausable, ERC721Enumerable) {
2019         super._beforeTokenTransfer(from, to, tokenId);
2020     }
2021 
2022     /**
2023      * @dev Retrieve the ETH balance of the current contract
2024      */
2025     function getBalance() public view returns (uint256) {
2026         return address(this).balance;
2027     }
2028 
2029     /**
2030      * @dev See {IERC165-supportsInterface}.
2031      */
2032     function supportsInterface(bytes4 interfaceId)
2033         public
2034         view
2035         virtual
2036         override(ERC721, ERC165Storage, ERC721Enumerable)
2037         returns (bool)
2038     {
2039         return super.supportsInterface(interfaceId);
2040     }
2041 
2042     /**
2043      * @dev Base URI for computing {tokenURI}. Empty by default, can be overwritten
2044      * in child contracts.
2045      */
2046     function _baseURI() internal view override returns (string memory) {
2047         return baseURI;
2048     }
2049 
2050     /**
2051      * @dev Set the baseURI to a given uri
2052      * @param uri string to save
2053      */
2054     function changeBaseURI(string memory uri) public onlyOwner {
2055         require(canChangeBaseURI, "The baseURI can't be changed anymore");
2056         require(bytes(uri).length > 0, "uri is empty");
2057         string memory initialBaseURI = baseURI;
2058         baseURI = uri;
2059         emit BaseURIChanged(msg.sender, initialBaseURI, baseURI);
2060     }
2061 
2062     /**
2063      * @dev Get the list of tokens for a specific owner
2064      * @param _owner address to retrieve token ids for
2065      */
2066     function tokensByOwner(address _owner)
2067         external
2068         view
2069         returns (uint256[] memory)
2070     {
2071         uint256 tokenCount = balanceOf(_owner);
2072         if (tokenCount == 0) {
2073             return new uint256[](0);
2074         } else {
2075             uint256[] memory result = new uint256[](tokenCount);
2076             uint256 index;
2077             for (index = 0; index < tokenCount; index++) {
2078                 result[index] = tokenOfOwnerByIndex(_owner, index);
2079             }
2080             return result;
2081         }
2082     }
2083 
2084     /**
2085      * @dev Set the NFT IPFS hash proof for tokens metadata
2086      * @param hashProof string to save
2087      */
2088     function setProvenance(string memory hashProof) public onlyOwner {
2089         require(bytes(hashProof).length > 0, "hash proof is empty");
2090         provenance = hashProof;
2091     }
2092 
2093     /**
2094      * @dev Disable early minting
2095      */
2096     function disableEarlyMinting() external onlyOwner {
2097         require(earlyMinting, "Early minting already disabled");
2098         earlyMinting = false;
2099     }
2100 
2101     /**
2102      * @dev Disable changes for baseURI
2103      */
2104     function disableBaseURIChanges() external onlyOwner {
2105         require(canChangeBaseURI, "The owner can't change the baseURI anymore");
2106         canChangeBaseURI = false;
2107     }
2108 
2109     /**
2110      * Credits to LarvaLabs Meebits contract
2111      */
2112     function randomIndex() internal returns (uint256) {
2113         uint256 totalSize = MAX_TOKENS - totalSupply();
2114         uint256 index = uint256(
2115             keccak256(
2116                 abi.encodePacked(
2117                     nonce,
2118                     msg.sender,
2119                     block.difficulty,
2120                     block.timestamp
2121                 )
2122             )
2123         ) % totalSize;
2124         uint256 value = 0;
2125 
2126         if (indices[index] != 0) {
2127             value = indices[index];
2128         } else {
2129             value = index;
2130         }
2131 
2132         // Move last value to selected position
2133         if (indices[totalSize - 1] == 0) {
2134             // Array position not initialized, so use position
2135             indices[index] = totalSize - 1;
2136         } else {
2137             // Array position holds a value so use that
2138             indices[index] = indices[totalSize - 1];
2139         }
2140         nonce++;
2141         // Don't allow a zero index, start counting at 1
2142         return value + 1;
2143     }
2144 
2145     /**
2146      * @dev Mint tokens early
2147      * @param _count the number of tokens to be minted
2148      * @param proof to validate if the sender can mint the tokens early
2149      */
2150     function earlyMint(uint256 _count, bytes32[] memory proof)
2151         public
2152         payable
2153         nonReentrant
2154         canMintEarly(proof)
2155     {
2156         require(
2157             earlyMinting,
2158             "The early minting is disabled. Use the mint function."
2159         );
2160         require(
2161             _count > 0 && _count <= MAX_EARLY_TOKENS_PER_PURCHASE,
2162             "Too many early tokens to mint at once"
2163         );
2164         require(
2165             _count + earlyMintedTokensByOwner[msg.sender] <=
2166                 MAX_EARLY_TOKENS_PER_PURCHASE,
2167             "Too many early tokens to mint"
2168         );
2169         if (block.timestamp - mintingStartTime <= 86400) {
2170             require(
2171                 _count <= MAX_EARLY_TOKENS_PER_PURCHASE_FIRST_DAY,
2172                 "To many tokens to be minted early in the first day"
2173             );
2174         }
2175         earlyMintedTokensByOwner[msg.sender] += _count;
2176         _mint(_count);
2177     }
2178 
2179     /**
2180      * @dev Withdraw contract balance to owner
2181      */
2182     function withdraw() public onlyOwner {
2183         sendValueTo(msg.sender, address(this).balance);
2184     }
2185 
2186     /**
2187      * @dev Mint tokens for community wallet
2188      */
2189     function mintToCommunityWallet(uint8 _count) external onlyOwner {
2190         require(
2191             _count > 0 && _count <= reservedTokens,
2192             "Too many reserved tokens to mint at once"
2193         );
2194         require(
2195             _count + mintedReservedTokens <= reservedTokens,
2196             "Too many reserved tokens to mint"
2197         );
2198         mintedReservedTokens += _count;
2199         mintNTokensFor(communityAddress, _count);
2200     }
2201 
2202     /**
2203      * @dev Mint new tokens
2204      * @param _count the number of tokens to be minted
2205      */
2206     function mint(uint256 _count)
2207         public
2208         payable
2209         nonReentrant
2210     {
2211         require(
2212             !earlyMinting,
2213             "The early minting is enabled. Use earlyMint function."
2214         );
2215         _mint(_count);
2216     }
2217 
2218     /**
2219      * @dev Mint new tokens
2220      * @param _count the number of tokens to be minted
2221      */
2222     function _mint(uint256 _count) internal {
2223         require(!paused(), "The minting of new tokens is paused");
2224         uint256 totalSupply = totalSupply();
2225 
2226         require(
2227             _count > 0 && _count <= MAX_TOKENS_PER_PURCHASE,
2228             "The maximum number of tokens that can be minted was exceeded"
2229         );
2230         require(
2231             totalSupply + _count <= MAX_TOKENS,
2232             "Exceeds maximum tokens available for purchase"
2233         );
2234         require(
2235             msg.value >= MINT_PRICE.mul(_count),
2236             "Ether value sent is not correct"
2237         );
2238 
2239         for (uint256 i = 0; i < _count; i++) {
2240             _mintToken(msg.sender);
2241         }
2242 
2243         uint256 value = msg.value;
2244         sendValueTo(
2245             royaltyReceiverTeam1,
2246             (value * ROYALTY_SELL_PERCENT_TEAM_1) / 100
2247         );
2248         sendValueTo(
2249             royaltyReceiverTeam2,
2250             (value * ROYALTY_SELL_PERCENT_TEAM_2) / 100
2251         );
2252         sendValueTo(
2253             royaltyReceiverTeam3,
2254             (value * ROYALTY_SELL_PERCENT_TEAM_3) / 100
2255         );
2256         sendValueTo(
2257             royaltyReceiverTeam4,
2258             (value * ROYALTY_SELL_PERCENT_TEAM_4) / 100
2259         );
2260     }
2261 
2262     /**
2263      * @dev Mint token for an address
2264      * @param to address to mint token for
2265      */
2266     function _mintToken(address to) internal {
2267         uint256 id = randomIndex();
2268         ownerTokenList[to].push(id);
2269         ownedTokensDetails[to][id] = NFTDetails(id, block.timestamp, 0);
2270         _safeMint(to, id);
2271     }
2272 
2273     /**
2274      * @dev Mint n tokens for an address
2275      * @param to address to mint tokens for
2276      * @param n number of tokens to mint
2277      */
2278     function mintNTokensFor(address to, uint8 n) internal {
2279         for (uint8 i = 0; i < n; i++) {
2280             _mintToken(to);
2281         }
2282     }
2283 
2284     /**
2285      * @dev Send an amount of value to a specific address
2286      * @param to_ address that will receive the value
2287      * @param value to be sent to the address
2288      */
2289     function sendValueTo(address to_, uint256 value) internal {
2290         address payable to = payable(to_);
2291         (bool success, ) = to.call{value: value}("");
2292         require(success, "Transfer failed.");
2293     }
2294 
2295     /**
2296      * @dev Get token history list of sender
2297      */
2298     function getTokenList() public view returns (uint256[] memory) {
2299         return ownerTokenList[msg.sender];
2300     }
2301 
2302     /**
2303      * @dev Get token history list of owner
2304      * @param owner_ for which to get all the tokens
2305      */
2306     function getTokenListFor(address owner_)
2307         public
2308         view
2309         returns (uint256[] memory)
2310     {
2311         return ownerTokenList[owner_];
2312     }
2313 
2314     /**
2315      * @dev Get token details for sender
2316      */
2317     function getTokenDetails() public view returns (NFTDetails[] memory) {
2318         return getTokenDetailsFor(msg.sender);
2319     }
2320 
2321     /**
2322      * @dev Get token details for a specific address
2323      * @param owner_ for which to get all the token details
2324      */
2325     function getTokenDetailsFor(address owner_)
2326         public
2327         view
2328         returns (NFTDetails[] memory)
2329     {
2330         return getTokenDetailsForFromIndex(owner_, 0);
2331     }
2332 
2333     /**
2334      * @dev Get token details for a specific address from an index of owner's token lsit
2335      * @param owner_ for which to get the token details
2336      * @param index from which to start retrieving the token details
2337      */
2338     function getTokenDetailsForFromIndex(address owner_, uint256 index)
2339         public
2340         view
2341         returns (NFTDetails[] memory)
2342     {
2343         uint256[] memory ownerList = ownerTokenList[owner_];
2344         NFTDetails[] memory details = new NFTDetails[](
2345             ownerList.length - index
2346         );
2347         uint256 counter = 0;
2348         for (uint256 i = index; i < ownerList.length; i++) {
2349             details[counter] = ownedTokensDetails[owner_][ownerList[i]];
2350             counter++;
2351         }
2352         return details;
2353     }
2354 
2355     /**
2356      * @dev Change token owner details mappings
2357      */
2358     function _updateTokenOwners(
2359         address from,
2360         address to,
2361         uint256 tokenId
2362     ) internal {
2363         ownedTokensDetails[from][tokenId].endTime = block.timestamp;
2364 
2365         ownerTokenList[to].push(tokenId);
2366         ownedTokensDetails[to][tokenId] = NFTDetails(
2367             tokenId,
2368             block.timestamp,
2369             0
2370         );
2371     }
2372 
2373     /**
2374      * @dev See {IERC721-safeTransferFrom}.
2375      * @param from address from which to transfer the token
2376      * @param to address to which to transfer the token
2377      * @param tokenId to transfer
2378      */
2379     function safeTransferFrom(
2380         address from,
2381         address to,
2382         uint256 tokenId
2383     ) public virtual override {
2384         _updateTokenOwners(from, to, tokenId);
2385         super.safeTransferFrom(from, to, tokenId);
2386     }
2387 
2388     /**
2389      * @dev See {IERC721-transferFrom}.
2390      * @param from address from which to transfer the token
2391      * @param to address to which to transfer the token
2392      * @param tokenId to transfer
2393      */
2394     function transferFrom(
2395         address from,
2396         address to,
2397         uint256 tokenId
2398     ) public virtual override {
2399         _updateTokenOwners(from, to, tokenId);
2400         super.transferFrom(from, to, tokenId);
2401     }
2402 }