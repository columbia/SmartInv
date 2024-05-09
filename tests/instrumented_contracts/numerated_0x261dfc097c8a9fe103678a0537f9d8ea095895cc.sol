1 ///////////////////////////////////////////////////////////////////
2 //                                                               //
3 //                        MetaLamboz NFT                         //
4 //   Contract Development by https://twitter.com/ViperwareLabs   //
5 //                                                               //
6 ///////////////////////////////////////////////////////////////////
7 
8 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev These functions deal with verification of Merkle Trees proofs.
14  *
15  * The proofs can be generated using the JavaScript library
16  * https://github.com/miguelmota/merkletreejs[merkletreejs].
17  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
18  *
19  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
20  */
21 library MerkleProof {
22     /**
23      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
24      * defined by `root`. For this, a `proof` must be provided, containing
25      * sibling hashes on the branch from the leaf to the root of the tree. Each
26      * pair of leaves and each pair of pre-images are assumed to be sorted.
27      */
28     function verify(
29         bytes32[] memory proof,
30         bytes32 root,
31         bytes32 leaf
32     ) internal pure returns (bool) {
33         return processProof(proof, leaf) == root;
34     }
35 
36     /**
37      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
38      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
39      * hash matches the root of the tree. When processing the proof, the pairs
40      * of leafs & pre-images are assumed to be sorted.
41      *
42      * _Available since v4.4._
43      */
44     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
45         bytes32 computedHash = leaf;
46         for (uint256 i = 0; i < proof.length; i++) {
47             bytes32 proofElement = proof[i];
48             if (computedHash <= proofElement) {
49                 // Hash(current computed hash + current element of the proof)
50                 computedHash = _efficientHash(computedHash, proofElement);
51             } else {
52                 // Hash(current element of the proof + current computed hash)
53                 computedHash = _efficientHash(proofElement, computedHash);
54             }
55         }
56         return computedHash;
57     }
58 
59     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
60         assembly {
61             mstore(0x00, a)
62             mstore(0x20, b)
63             value := keccak256(0x00, 0x40)
64         }
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Strings.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 
76 /**
77  * @dev String operations.
78  */
79 library Strings {
80     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
81 
82     /**
83      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
84      */
85     function toString(uint256 value) internal pure returns (string memory) {
86         // Inspired by OraclizeAPI's implementation - MIT licence
87         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
88 
89         if (value == 0) {
90             return "0";
91         }
92         uint256 temp = value;
93         uint256 digits;
94         while (temp != 0) {
95             digits++;
96             temp /= 10;
97         }
98         bytes memory buffer = new bytes(digits);
99         while (value != 0) {
100             digits -= 1;
101             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
102             value /= 10;
103         }
104         return string(buffer);
105     }
106 
107     /**
108      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
109      */
110     function toHexString(uint256 value) internal pure returns (string memory) {
111         if (value == 0) {
112             return "0x00";
113         }
114         uint256 temp = value;
115         uint256 length = 0;
116         while (temp != 0) {
117             length++;
118             temp >>= 8;
119         }
120         return toHexString(value, length);
121     }
122 
123     /**
124      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
125      */
126     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
127         bytes memory buffer = new bytes(2 * length + 2);
128         buffer[0] = "0";
129         buffer[1] = "x";
130         for (uint256 i = 2 * length + 1; i > 1; --i) {
131             buffer[i] = _HEX_SYMBOLS[value & 0xf];
132             value >>= 4;
133         }
134         require(value == 0, "Strings: hex length insufficient");
135         return string(buffer);
136     }
137 }
138 
139 // File: @openzeppelin/contracts/utils/Address.sol
140 
141 
142 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
143 
144 pragma solidity ^0.8.1;
145 
146 /**
147  * @dev Collection of functions related to the address type
148  */
149 library Address {
150     /**
151      * @dev Returns true if `account` is a contract.
152      *
153      * [IMPORTANT]
154      * ====
155      * It is unsafe to assume that an address for which this function returns
156      * false is an externally-owned account (EOA) and not a contract.
157      *
158      * Among others, `isContract` will return false for the following
159      * types of addresses:
160      *
161      *  - an externally-owned account
162      *  - a contract in construction
163      *  - an address where a contract will be created
164      *  - an address where a contract lived, but was destroyed
165      * ====
166      *
167      * [IMPORTANT]
168      * ====
169      * You shouldn't rely on `isContract` to protect against flash loan attacks!
170      *
171      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
172      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
173      * constructor.
174      * ====
175      */
176     function isContract(address account) internal view returns (bool) {
177         // This method relies on extcodesize/address.code.length, which returns 0
178         // for contracts in construction, since the code is only stored at the end
179         // of the constructor execution.
180 
181         return account.code.length > 0;
182     }
183 
184     /**
185      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
186      * `recipient`, forwarding all available gas and reverting on errors.
187      *
188      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
189      * of certain opcodes, possibly making contracts go over the 2300 gas limit
190      * imposed by `transfer`, making them unable to receive funds via
191      * `transfer`. {sendValue} removes this limitation.
192      *
193      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
194      *
195      * IMPORTANT: because control is transferred to `recipient`, care must be
196      * taken to not create reentrancy vulnerabilities. Consider using
197      * {ReentrancyGuard} or the
198      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
199      */
200     function sendValue(address payable recipient, uint256 amount) internal {
201         require(address(this).balance >= amount, "Address: insufficient balance");
202 
203         (bool success, ) = recipient.call{value: amount}("");
204         require(success, "Address: unable to send value, recipient may have reverted");
205     }
206 
207     /**
208      * @dev Performs a Solidity function call using a low level `call`. A
209      * plain `call` is an unsafe replacement for a function call: use this
210      * function instead.
211      *
212      * If `target` reverts with a revert reason, it is bubbled up by this
213      * function (like regular Solidity function calls).
214      *
215      * Returns the raw returned data. To convert to the expected return value,
216      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
217      *
218      * Requirements:
219      *
220      * - `target` must be a contract.
221      * - calling `target` with `data` must not revert.
222      *
223      * _Available since v3.1._
224      */
225     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
226         return functionCall(target, data, "Address: low-level call failed");
227     }
228 
229     /**
230      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
231      * `errorMessage` as a fallback revert reason when `target` reverts.
232      *
233      * _Available since v3.1._
234      */
235     function functionCall(
236         address target,
237         bytes memory data,
238         string memory errorMessage
239     ) internal returns (bytes memory) {
240         return functionCallWithValue(target, data, 0, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but also transferring `value` wei to `target`.
246      *
247      * Requirements:
248      *
249      * - the calling contract must have an ETH balance of at least `value`.
250      * - the called Solidity function must be `payable`.
251      *
252      * _Available since v3.1._
253      */
254     function functionCallWithValue(
255         address target,
256         bytes memory data,
257         uint256 value
258     ) internal returns (bytes memory) {
259         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
260     }
261 
262     /**
263      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
264      * with `errorMessage` as a fallback revert reason when `target` reverts.
265      *
266      * _Available since v3.1._
267      */
268     function functionCallWithValue(
269         address target,
270         bytes memory data,
271         uint256 value,
272         string memory errorMessage
273     ) internal returns (bytes memory) {
274         require(address(this).balance >= value, "Address: insufficient balance for call");
275         require(isContract(target), "Address: call to non-contract");
276 
277         (bool success, bytes memory returndata) = target.call{value: value}(data);
278         return verifyCallResult(success, returndata, errorMessage);
279     }
280 
281     /**
282      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
283      * but performing a static call.
284      *
285      * _Available since v3.3._
286      */
287     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
288         return functionStaticCall(target, data, "Address: low-level static call failed");
289     }
290 
291     /**
292      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
293      * but performing a static call.
294      *
295      * _Available since v3.3._
296      */
297     function functionStaticCall(
298         address target,
299         bytes memory data,
300         string memory errorMessage
301     ) internal view returns (bytes memory) {
302         require(isContract(target), "Address: static call to non-contract");
303 
304         (bool success, bytes memory returndata) = target.staticcall(data);
305         return verifyCallResult(success, returndata, errorMessage);
306     }
307 
308     /**
309      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
310      * but performing a delegate call.
311      *
312      * _Available since v3.4._
313      */
314     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
315         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
316     }
317 
318     /**
319      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
320      * but performing a delegate call.
321      *
322      * _Available since v3.4._
323      */
324     function functionDelegateCall(
325         address target,
326         bytes memory data,
327         string memory errorMessage
328     ) internal returns (bytes memory) {
329         require(isContract(target), "Address: delegate call to non-contract");
330 
331         (bool success, bytes memory returndata) = target.delegatecall(data);
332         return verifyCallResult(success, returndata, errorMessage);
333     }
334 
335     /**
336      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
337      * revert reason using the provided one.
338      *
339      * _Available since v4.3._
340      */
341     function verifyCallResult(
342         bool success,
343         bytes memory returndata,
344         string memory errorMessage
345     ) internal pure returns (bytes memory) {
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
365 
366 
367 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 /**
372  * @title ERC721 token receiver interface
373  * @dev Interface for any contract that wants to support safeTransfers
374  * from ERC721 asset contracts.
375  */
376 interface IERC721Receiver {
377     /**
378      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
379      * by `operator` from `from`, this function is called.
380      *
381      * It must return its Solidity selector to confirm the token transfer.
382      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
383      *
384      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
385      */
386     function onERC721Received(
387         address operator,
388         address from,
389         uint256 tokenId,
390         bytes calldata data
391     ) external returns (bytes4);
392 }
393 
394 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Interface of the ERC165 standard, as defined in the
403  * https://eips.ethereum.org/EIPS/eip-165[EIP].
404  *
405  * Implementers can declare support of contract interfaces, which can then be
406  * queried by others ({ERC165Checker}).
407  *
408  * For an implementation, see {ERC165}.
409  */
410 interface IERC165 {
411     /**
412      * @dev Returns true if this contract implements the interface defined by
413      * `interfaceId`. See the corresponding
414      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
415      * to learn more about how these ids are created.
416      *
417      * This function call must use less than 30 000 gas.
418      */
419     function supportsInterface(bytes4 interfaceId) external view returns (bool);
420 }
421 
422 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 
430 /**
431  * @dev Implementation of the {IERC165} interface.
432  *
433  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
434  * for the additional interface id that will be supported. For example:
435  *
436  * ```solidity
437  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
438  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
439  * }
440  * ```
441  *
442  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
443  */
444 abstract contract ERC165 is IERC165 {
445     /**
446      * @dev See {IERC165-supportsInterface}.
447      */
448     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
449         return interfaceId == type(IERC165).interfaceId;
450     }
451 }
452 
453 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
454 
455 
456 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
457 
458 pragma solidity ^0.8.0;
459 
460 
461 /**
462  * @dev Required interface of an ERC721 compliant contract.
463  */
464 interface IERC721 is IERC165 {
465     /**
466      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
467      */
468     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
469 
470     /**
471      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
472      */
473     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
474 
475     /**
476      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
477      */
478     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
479 
480     /**
481      * @dev Returns the number of tokens in ``owner``'s account.
482      */
483     function balanceOf(address owner) external view returns (uint256 balance);
484 
485     /**
486      * @dev Returns the owner of the `tokenId` token.
487      *
488      * Requirements:
489      *
490      * - `tokenId` must exist.
491      */
492     function ownerOf(uint256 tokenId) external view returns (address owner);
493 
494     /**
495      * @dev Safely transfers `tokenId` token from `from` to `to`.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must exist and be owned by `from`.
502      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
503      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
504      *
505      * Emits a {Transfer} event.
506      */
507     function safeTransferFrom(
508         address from,
509         address to,
510         uint256 tokenId,
511         bytes calldata data
512     ) external;
513 
514     /**
515      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
516      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
517      *
518      * Requirements:
519      *
520      * - `from` cannot be the zero address.
521      * - `to` cannot be the zero address.
522      * - `tokenId` token must exist and be owned by `from`.
523      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
524      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
525      *
526      * Emits a {Transfer} event.
527      */
528     function safeTransferFrom(
529         address from,
530         address to,
531         uint256 tokenId
532     ) external;
533 
534     /**
535      * @dev Transfers `tokenId` token from `from` to `to`.
536      *
537      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
538      *
539      * Requirements:
540      *
541      * - `from` cannot be the zero address.
542      * - `to` cannot be the zero address.
543      * - `tokenId` token must be owned by `from`.
544      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
545      *
546      * Emits a {Transfer} event.
547      */
548     function transferFrom(
549         address from,
550         address to,
551         uint256 tokenId
552     ) external;
553 
554     /**
555      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
556      * The approval is cleared when the token is transferred.
557      *
558      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
559      *
560      * Requirements:
561      *
562      * - The caller must own the token or be an approved operator.
563      * - `tokenId` must exist.
564      *
565      * Emits an {Approval} event.
566      */
567     function approve(address to, uint256 tokenId) external;
568 
569     /**
570      * @dev Approve or remove `operator` as an operator for the caller.
571      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
572      *
573      * Requirements:
574      *
575      * - The `operator` cannot be the caller.
576      *
577      * Emits an {ApprovalForAll} event.
578      */
579     function setApprovalForAll(address operator, bool _approved) external;
580 
581     /**
582      * @dev Returns the account approved for `tokenId` token.
583      *
584      * Requirements:
585      *
586      * - `tokenId` must exist.
587      */
588     function getApproved(uint256 tokenId) external view returns (address operator);
589 
590     /**
591      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
592      *
593      * See {setApprovalForAll}
594      */
595     function isApprovedForAll(address owner, address operator) external view returns (bool);
596 }
597 
598 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
599 
600 
601 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
602 
603 pragma solidity ^0.8.0;
604 
605 
606 /**
607  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
608  * @dev See https://eips.ethereum.org/EIPS/eip-721
609  */
610 interface IERC721Metadata is IERC721 {
611     /**
612      * @dev Returns the token collection name.
613      */
614     function name() external view returns (string memory);
615 
616     /**
617      * @dev Returns the token collection symbol.
618      */
619     function symbol() external view returns (string memory);
620 
621     /**
622      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
623      */
624     function tokenURI(uint256 tokenId) external view returns (string memory);
625 }
626 
627 // File: erc721a/contracts/IERC721A.sol
628 
629 
630 // ERC721A Contracts v3.3.0
631 // Creator: Chiru Labs
632 
633 pragma solidity ^0.8.4;
634 
635 
636 
637 /**
638  * @dev Interface of an ERC721A compliant contract.
639  */
640 interface IERC721A is IERC721, IERC721Metadata {
641     /**
642      * The caller must own the token or be an approved operator.
643      */
644     error ApprovalCallerNotOwnerNorApproved();
645 
646     /**
647      * The token does not exist.
648      */
649     error ApprovalQueryForNonexistentToken();
650 
651     /**
652      * The caller cannot approve to their own address.
653      */
654     error ApproveToCaller();
655 
656     /**
657      * The caller cannot approve to the current owner.
658      */
659     error ApprovalToCurrentOwner();
660 
661     /**
662      * Cannot query the balance for the zero address.
663      */
664     error BalanceQueryForZeroAddress();
665 
666     /**
667      * Cannot mint to the zero address.
668      */
669     error MintToZeroAddress();
670 
671     /**
672      * The quantity of tokens minted must be more than zero.
673      */
674     error MintZeroQuantity();
675 
676     /**
677      * The token does not exist.
678      */
679     error OwnerQueryForNonexistentToken();
680 
681     /**
682      * The caller must own the token or be an approved operator.
683      */
684     error TransferCallerNotOwnerNorApproved();
685 
686     /**
687      * The token must be owned by `from`.
688      */
689     error TransferFromIncorrectOwner();
690 
691     /**
692      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
693      */
694     error TransferToNonERC721ReceiverImplementer();
695 
696     /**
697      * Cannot transfer to the zero address.
698      */
699     error TransferToZeroAddress();
700 
701     /**
702      * The token does not exist.
703      */
704     error URIQueryForNonexistentToken();
705 
706     // Compiler will pack this into a single 256bit word.
707     struct TokenOwnership {
708         // The address of the owner.
709         address addr;
710         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
711         uint64 startTimestamp;
712         // Whether the token has been burned.
713         bool burned;
714     }
715 
716     // Compiler will pack this into a single 256bit word.
717     struct AddressData {
718         // Realistically, 2**64-1 is more than enough.
719         uint64 balance;
720         // Keeps track of mint count with minimal overhead for tokenomics.
721         uint64 numberMinted;
722         // Keeps track of burn count with minimal overhead for tokenomics.
723         uint64 numberBurned;
724         // For miscellaneous variable(s) pertaining to the address
725         // (e.g. number of whitelist mint slots used).
726         // If there are multiple variables, please pack them into a uint64.
727         uint64 aux;
728     }
729 
730     /**
731      * @dev Returns the total amount of tokens stored by the contract.
732      * 
733      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
734      */
735     function totalSupply() external view returns (uint256);
736 }
737 
738 // File: @openzeppelin/contracts/utils/Context.sol
739 
740 
741 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 /**
746  * @dev Provides information about the current execution context, including the
747  * sender of the transaction and its data. While these are generally available
748  * via msg.sender and msg.data, they should not be accessed in such a direct
749  * manner, since when dealing with meta-transactions the account sending and
750  * paying for execution may not be the actual sender (as far as an application
751  * is concerned).
752  *
753  * This contract is only required for intermediate, library-like contracts.
754  */
755 abstract contract Context {
756     function _msgSender() internal view virtual returns (address) {
757         return msg.sender;
758     }
759 
760     function _msgData() internal view virtual returns (bytes calldata) {
761         return msg.data;
762     }
763 }
764 
765 // File: erc721a/contracts/ERC721A.sol
766 
767 
768 // ERC721A Contracts v3.3.0
769 // Creator: Chiru Labs
770 
771 pragma solidity ^0.8.4;
772 
773 
774 
775 
776 
777 
778 
779 /**
780  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
781  * the Metadata extension. Built to optimize for lower gas during batch mints.
782  *
783  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
784  *
785  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
786  *
787  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
788  */
789 contract ERC721A is Context, ERC165, IERC721A {
790     using Address for address;
791     using Strings for uint256;
792 
793     // The tokenId of the next token to be minted.
794     uint256 internal _currentIndex;
795 
796     // The number of tokens burned.
797     uint256 internal _burnCounter;
798 
799     // Token name
800     string private _name;
801 
802     // Token symbol
803     string private _symbol;
804 
805     // Mapping from token ID to ownership details
806     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
807     mapping(uint256 => TokenOwnership) internal _ownerships;
808 
809     // Mapping owner address to address data
810     mapping(address => AddressData) private _addressData;
811 
812     // Mapping from token ID to approved address
813     mapping(uint256 => address) private _tokenApprovals;
814 
815     // Mapping from owner to operator approvals
816     mapping(address => mapping(address => bool)) private _operatorApprovals;
817 
818     constructor(string memory name_, string memory symbol_) {
819         _name = name_;
820         _symbol = symbol_;
821         _currentIndex = _startTokenId();
822     }
823 
824     /**
825      * To change the starting tokenId, please override this function.
826      */
827     function _startTokenId() internal view virtual returns (uint256) {
828         return 0;
829     }
830 
831     /**
832      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
833      */
834     function totalSupply() public view override returns (uint256) {
835         // Counter underflow is impossible as _burnCounter cannot be incremented
836         // more than _currentIndex - _startTokenId() times
837         unchecked {
838             return _currentIndex - _burnCounter - _startTokenId();
839         }
840     }
841 
842     /**
843      * Returns the total amount of tokens minted in the contract.
844      */
845     function _totalMinted() internal view returns (uint256) {
846         // Counter underflow is impossible as _currentIndex does not decrement,
847         // and it is initialized to _startTokenId()
848         unchecked {
849             return _currentIndex - _startTokenId();
850         }
851     }
852 
853     /**
854      * @dev See {IERC165-supportsInterface}.
855      */
856     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
857         return
858             interfaceId == type(IERC721).interfaceId ||
859             interfaceId == type(IERC721Metadata).interfaceId ||
860             super.supportsInterface(interfaceId);
861     }
862 
863     /**
864      * @dev See {IERC721-balanceOf}.
865      */
866     function balanceOf(address owner) public view override returns (uint256) {
867         if (owner == address(0)) revert BalanceQueryForZeroAddress();
868         return uint256(_addressData[owner].balance);
869     }
870 
871     /**
872      * Returns the number of tokens minted by `owner`.
873      */
874     function _numberMinted(address owner) internal view returns (uint256) {
875         return uint256(_addressData[owner].numberMinted);
876     }
877 
878     /**
879      * Returns the number of tokens burned by or on behalf of `owner`.
880      */
881     function _numberBurned(address owner) internal view returns (uint256) {
882         return uint256(_addressData[owner].numberBurned);
883     }
884 
885     /**
886      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
887      */
888     function _getAux(address owner) internal view returns (uint64) {
889         return _addressData[owner].aux;
890     }
891 
892     /**
893      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
894      * If there are multiple variables, please pack them into a uint64.
895      */
896     function _setAux(address owner, uint64 aux) internal {
897         _addressData[owner].aux = aux;
898     }
899 
900     /**
901      * Gas spent here starts off proportional to the maximum mint batch size.
902      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
903      */
904     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
905         uint256 curr = tokenId;
906 
907         unchecked {
908             if (_startTokenId() <= curr) if (curr < _currentIndex) {
909                 TokenOwnership memory ownership = _ownerships[curr];
910                 if (!ownership.burned) {
911                     if (ownership.addr != address(0)) {
912                         return ownership;
913                     }
914                     // Invariant:
915                     // There will always be an ownership that has an address and is not burned
916                     // before an ownership that does not have an address and is not burned.
917                     // Hence, curr will not underflow.
918                     while (true) {
919                         curr--;
920                         ownership = _ownerships[curr];
921                         if (ownership.addr != address(0)) {
922                             return ownership;
923                         }
924                     }
925                 }
926             }
927         }
928         revert OwnerQueryForNonexistentToken();
929     }
930 
931     /**
932      * @dev See {IERC721-ownerOf}.
933      */
934     function ownerOf(uint256 tokenId) public view override returns (address) {
935         return _ownershipOf(tokenId).addr;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-name}.
940      */
941     function name() public view virtual override returns (string memory) {
942         return _name;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-symbol}.
947      */
948     function symbol() public view virtual override returns (string memory) {
949         return _symbol;
950     }
951 
952     /**
953      * @dev See {IERC721Metadata-tokenURI}.
954      */
955     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
956         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
957 
958         string memory baseURI = _baseURI();
959         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
960     }
961 
962     /**
963      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
964      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
965      * by default, can be overriden in child contracts.
966      */
967     function _baseURI() internal view virtual returns (string memory) {
968         return '';
969     }
970 
971     /**
972      * @dev See {IERC721-approve}.
973      */
974     function approve(address to, uint256 tokenId) public override {
975         address owner = ERC721A.ownerOf(tokenId);
976         if (to == owner) revert ApprovalToCurrentOwner();
977 
978         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
979             revert ApprovalCallerNotOwnerNorApproved();
980         }
981 
982         _approve(to, tokenId, owner);
983     }
984 
985     /**
986      * @dev See {IERC721-getApproved}.
987      */
988     function getApproved(uint256 tokenId) public view override returns (address) {
989         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
990 
991         return _tokenApprovals[tokenId];
992     }
993 
994     /**
995      * @dev See {IERC721-setApprovalForAll}.
996      */
997     function setApprovalForAll(address operator, bool approved) public virtual override {
998         if (operator == _msgSender()) revert ApproveToCaller();
999 
1000         _operatorApprovals[_msgSender()][operator] = approved;
1001         emit ApprovalForAll(_msgSender(), operator, approved);
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-isApprovedForAll}.
1006      */
1007     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1008         return _operatorApprovals[owner][operator];
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-transferFrom}.
1013      */
1014     function transferFrom(
1015         address from,
1016         address to,
1017         uint256 tokenId
1018     ) public virtual override {
1019         _transfer(from, to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-safeTransferFrom}.
1024      */
1025     function safeTransferFrom(
1026         address from,
1027         address to,
1028         uint256 tokenId
1029     ) public virtual override {
1030         safeTransferFrom(from, to, tokenId, '');
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-safeTransferFrom}.
1035      */
1036     function safeTransferFrom(
1037         address from,
1038         address to,
1039         uint256 tokenId,
1040         bytes memory _data
1041     ) public virtual override {
1042         _transfer(from, to, tokenId);
1043         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1044             revert TransferToNonERC721ReceiverImplementer();
1045         }
1046     }
1047 
1048     /**
1049      * @dev Returns whether `tokenId` exists.
1050      *
1051      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1052      *
1053      * Tokens start existing when they are minted (`_mint`),
1054      */
1055     function _exists(uint256 tokenId) internal view returns (bool) {
1056         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1057     }
1058 
1059     /**
1060      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1061      */
1062     function _safeMint(address to, uint256 quantity) internal {
1063         _safeMint(to, quantity, '');
1064     }
1065 
1066     /**
1067      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1068      *
1069      * Requirements:
1070      *
1071      * - If `to` refers to a smart contract, it must implement
1072      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _safeMint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data
1081     ) internal {
1082         uint256 startTokenId = _currentIndex;
1083         if (to == address(0)) revert MintToZeroAddress();
1084         if (quantity == 0) revert MintZeroQuantity();
1085 
1086         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1087 
1088         // Overflows are incredibly unrealistic.
1089         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1090         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1091         unchecked {
1092             _addressData[to].balance += uint64(quantity);
1093             _addressData[to].numberMinted += uint64(quantity);
1094 
1095             _ownerships[startTokenId].addr = to;
1096             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1097 
1098             uint256 updatedIndex = startTokenId;
1099             uint256 end = updatedIndex + quantity;
1100 
1101             if (to.isContract()) {
1102                 do {
1103                     emit Transfer(address(0), to, updatedIndex);
1104                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1105                         revert TransferToNonERC721ReceiverImplementer();
1106                     }
1107                 } while (updatedIndex < end);
1108                 // Reentrancy protection
1109                 if (_currentIndex != startTokenId) revert();
1110             } else {
1111                 do {
1112                     emit Transfer(address(0), to, updatedIndex++);
1113                 } while (updatedIndex < end);
1114             }
1115             _currentIndex = updatedIndex;
1116         }
1117         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1118     }
1119 
1120     /**
1121      * @dev Mints `quantity` tokens and transfers them to `to`.
1122      *
1123      * Requirements:
1124      *
1125      * - `to` cannot be the zero address.
1126      * - `quantity` must be greater than 0.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function _mint(address to, uint256 quantity) internal {
1131         uint256 startTokenId = _currentIndex;
1132         if (to == address(0)) revert MintToZeroAddress();
1133         if (quantity == 0) revert MintZeroQuantity();
1134 
1135         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1136 
1137         // Overflows are incredibly unrealistic.
1138         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1139         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1140         unchecked {
1141             _addressData[to].balance += uint64(quantity);
1142             _addressData[to].numberMinted += uint64(quantity);
1143 
1144             _ownerships[startTokenId].addr = to;
1145             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1146 
1147             uint256 updatedIndex = startTokenId;
1148             uint256 end = updatedIndex + quantity;
1149 
1150             do {
1151                 emit Transfer(address(0), to, updatedIndex++);
1152             } while (updatedIndex < end);
1153 
1154             _currentIndex = updatedIndex;
1155         }
1156         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1157     }
1158 
1159     /**
1160      * @dev Transfers `tokenId` from `from` to `to`.
1161      *
1162      * Requirements:
1163      *
1164      * - `to` cannot be the zero address.
1165      * - `tokenId` token must be owned by `from`.
1166      *
1167      * Emits a {Transfer} event.
1168      */
1169     function _transfer(
1170         address from,
1171         address to,
1172         uint256 tokenId
1173     ) private {
1174         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1175 
1176         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1177 
1178         bool isApprovedOrOwner = (_msgSender() == from ||
1179             isApprovedForAll(from, _msgSender()) ||
1180             getApproved(tokenId) == _msgSender());
1181 
1182         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1183         if (to == address(0)) revert TransferToZeroAddress();
1184 
1185         _beforeTokenTransfers(from, to, tokenId, 1);
1186 
1187         // Clear approvals from the previous owner
1188         _approve(address(0), tokenId, from);
1189 
1190         // Underflow of the sender's balance is impossible because we check for
1191         // ownership above and the recipient's balance can't realistically overflow.
1192         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1193         unchecked {
1194             _addressData[from].balance -= 1;
1195             _addressData[to].balance += 1;
1196 
1197             TokenOwnership storage currSlot = _ownerships[tokenId];
1198             currSlot.addr = to;
1199             currSlot.startTimestamp = uint64(block.timestamp);
1200 
1201             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1202             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1203             uint256 nextTokenId = tokenId + 1;
1204             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1205             if (nextSlot.addr == address(0)) {
1206                 // This will suffice for checking _exists(nextTokenId),
1207                 // as a burned slot cannot contain the zero address.
1208                 if (nextTokenId != _currentIndex) {
1209                     nextSlot.addr = from;
1210                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1211                 }
1212             }
1213         }
1214 
1215         emit Transfer(from, to, tokenId);
1216         _afterTokenTransfers(from, to, tokenId, 1);
1217     }
1218 
1219     /**
1220      * @dev Equivalent to `_burn(tokenId, false)`.
1221      */
1222     function _burn(uint256 tokenId) internal virtual {
1223         _burn(tokenId, false);
1224     }
1225 
1226     /**
1227      * @dev Destroys `tokenId`.
1228      * The approval is cleared when the token is burned.
1229      *
1230      * Requirements:
1231      *
1232      * - `tokenId` must exist.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1237         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1238 
1239         address from = prevOwnership.addr;
1240 
1241         if (approvalCheck) {
1242             bool isApprovedOrOwner = (_msgSender() == from ||
1243                 isApprovedForAll(from, _msgSender()) ||
1244                 getApproved(tokenId) == _msgSender());
1245 
1246             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1247         }
1248 
1249         _beforeTokenTransfers(from, address(0), tokenId, 1);
1250 
1251         // Clear approvals from the previous owner
1252         _approve(address(0), tokenId, from);
1253 
1254         // Underflow of the sender's balance is impossible because we check for
1255         // ownership above and the recipient's balance can't realistically overflow.
1256         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1257         unchecked {
1258             AddressData storage addressData = _addressData[from];
1259             addressData.balance -= 1;
1260             addressData.numberBurned += 1;
1261 
1262             // Keep track of who burned the token, and the timestamp of burning.
1263             TokenOwnership storage currSlot = _ownerships[tokenId];
1264             currSlot.addr = from;
1265             currSlot.startTimestamp = uint64(block.timestamp);
1266             currSlot.burned = true;
1267 
1268             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1269             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1270             uint256 nextTokenId = tokenId + 1;
1271             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1272             if (nextSlot.addr == address(0)) {
1273                 // This will suffice for checking _exists(nextTokenId),
1274                 // as a burned slot cannot contain the zero address.
1275                 if (nextTokenId != _currentIndex) {
1276                     nextSlot.addr = from;
1277                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1278                 }
1279             }
1280         }
1281 
1282         emit Transfer(from, address(0), tokenId);
1283         _afterTokenTransfers(from, address(0), tokenId, 1);
1284 
1285         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1286         unchecked {
1287             _burnCounter++;
1288         }
1289     }
1290 
1291     /**
1292      * @dev Approve `to` to operate on `tokenId`
1293      *
1294      * Emits a {Approval} event.
1295      */
1296     function _approve(
1297         address to,
1298         uint256 tokenId,
1299         address owner
1300     ) private {
1301         _tokenApprovals[tokenId] = to;
1302         emit Approval(owner, to, tokenId);
1303     }
1304 
1305     /**
1306      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1307      *
1308      * @param from address representing the previous owner of the given token ID
1309      * @param to target address that will receive the tokens
1310      * @param tokenId uint256 ID of the token to be transferred
1311      * @param _data bytes optional data to send along with the call
1312      * @return bool whether the call correctly returned the expected magic value
1313      */
1314     function _checkContractOnERC721Received(
1315         address from,
1316         address to,
1317         uint256 tokenId,
1318         bytes memory _data
1319     ) private returns (bool) {
1320         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1321             return retval == IERC721Receiver(to).onERC721Received.selector;
1322         } catch (bytes memory reason) {
1323             if (reason.length == 0) {
1324                 revert TransferToNonERC721ReceiverImplementer();
1325             } else {
1326                 assembly {
1327                     revert(add(32, reason), mload(reason))
1328                 }
1329             }
1330         }
1331     }
1332 
1333     /**
1334      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1335      * And also called before burning one token.
1336      *
1337      * startTokenId - the first token id to be transferred
1338      * quantity - the amount to be transferred
1339      *
1340      * Calling conditions:
1341      *
1342      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1343      * transferred to `to`.
1344      * - When `from` is zero, `tokenId` will be minted for `to`.
1345      * - When `to` is zero, `tokenId` will be burned by `from`.
1346      * - `from` and `to` are never both zero.
1347      */
1348     function _beforeTokenTransfers(
1349         address from,
1350         address to,
1351         uint256 startTokenId,
1352         uint256 quantity
1353     ) internal virtual {}
1354 
1355     /**
1356      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1357      * minting.
1358      * And also called after one token has been burned.
1359      *
1360      * startTokenId - the first token id to be transferred
1361      * quantity - the amount to be transferred
1362      *
1363      * Calling conditions:
1364      *
1365      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1366      * transferred to `to`.
1367      * - When `from` is zero, `tokenId` has been minted for `to`.
1368      * - When `to` is zero, `tokenId` has been burned by `from`.
1369      * - `from` and `to` are never both zero.
1370      */
1371     function _afterTokenTransfers(
1372         address from,
1373         address to,
1374         uint256 startTokenId,
1375         uint256 quantity
1376     ) internal virtual {}
1377 }
1378 
1379 // File: @openzeppelin/contracts/access/Ownable.sol
1380 
1381 
1382 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1383 
1384 pragma solidity ^0.8.0;
1385 
1386 
1387 /**
1388  * @dev Contract module which provides a basic access control mechanism, where
1389  * there is an account (an owner) that can be granted exclusive access to
1390  * specific functions.
1391  *
1392  * By default, the owner account will be the one that deploys the contract. This
1393  * can later be changed with {transferOwnership}.
1394  *
1395  * This module is used through inheritance. It will make available the modifier
1396  * `onlyOwner`, which can be applied to your functions to restrict their use to
1397  * the owner.
1398  */
1399 abstract contract Ownable is Context {
1400     address private _owner;
1401 
1402     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1403 
1404     /**
1405      * @dev Initializes the contract setting the deployer as the initial owner.
1406      */
1407     constructor() {
1408         _transferOwnership(_msgSender());
1409     }
1410 
1411     /**
1412      * @dev Returns the address of the current owner.
1413      */
1414     function owner() public view virtual returns (address) {
1415         return _owner;
1416     }
1417 
1418     /**
1419      * @dev Throws if called by any account other than the owner.
1420      */
1421     modifier onlyOwner() {
1422         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1423         _;
1424     }
1425 
1426     /**
1427      * @dev Leaves the contract without owner. It will not be possible to call
1428      * `onlyOwner` functions anymore. Can only be called by the current owner.
1429      *
1430      * NOTE: Renouncing ownership will leave the contract without an owner,
1431      * thereby removing any functionality that is only available to the owner.
1432      */
1433     function renounceOwnership() public virtual onlyOwner {
1434         _transferOwnership(address(0));
1435     }
1436 
1437     /**
1438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1439      * Can only be called by the current owner.
1440      */
1441     function transferOwnership(address newOwner) public virtual onlyOwner {
1442         require(newOwner != address(0), "Ownable: new owner is the zero address");
1443         _transferOwnership(newOwner);
1444     }
1445 
1446     /**
1447      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1448      * Internal function without access restriction.
1449      */
1450     function _transferOwnership(address newOwner) internal virtual {
1451         address oldOwner = _owner;
1452         _owner = newOwner;
1453         emit OwnershipTransferred(oldOwner, newOwner);
1454     }
1455 }
1456 
1457 
1458 
1459 pragma solidity ^0.8.0;
1460 
1461 
1462 
1463 contract MetaLamboz is ERC721A, Ownable {
1464     bytes32 public root;
1465 	using Strings for uint;
1466 
1467 	uint public constant MINT_PRICE = 0 ether;
1468 	uint public constant MAX_NFT_PER_TRAN = 1;
1469     uint public constant MAX_PER_WALLET = 1;
1470     uint public MAX_FREE_MINT = 1;
1471 	uint public maxSupply = 420;
1472 
1473     bool public isWhitelistMint = false;
1474     bool public isPublicMint = false;
1475     bool public isMetadataFinal;
1476     string private _baseURL;
1477 	string public prerevealURL = 'ipfs://bafybeifjjv6x5izvtq6jb65wwivz43lrw7vf7htescaalrlemd3j7tk7n4/prereveal.json';
1478 	mapping(address => uint) private _walletMintedCount;
1479 
1480     // Name
1481 	constructor()
1482 	ERC721A('MetaLamboz', 'LAMBO') {
1483     }
1484 
1485 	function _baseURI() internal view override returns (string memory) {
1486 		return _baseURL;
1487 	}
1488 
1489 	function _startTokenId() internal pure override returns (uint) {
1490 		return 1;
1491 	}
1492 
1493 	function contractURI() public pure returns (string memory) {
1494 		return "";
1495 	}
1496 
1497     function finalizeMetadata() external onlyOwner {
1498         isMetadataFinal = true;
1499     }
1500 
1501 	function reveal(string memory url) external onlyOwner {
1502         require(!isMetadataFinal, "Metadata is finalized");
1503 		_baseURL = url;
1504 	}
1505 
1506     function mintedCount(address owner) external view returns (uint) {
1507         return _walletMintedCount[owner];
1508     }
1509 
1510     function setRoot(bytes32 _root) external onlyOwner {
1511 		root = _root;
1512 	}
1513 
1514     function setWhitelistState(bool value) external onlyOwner {
1515 		isWhitelistMint = value;
1516 	}
1517 
1518     function setPublicState(bool value) external onlyOwner {
1519 		isPublicMint = value;
1520 	}
1521 
1522     function withdraw() public onlyOwner {
1523         uint256 balance = address(this).balance;
1524         payable(msg.sender).transfer(balance);
1525     }
1526 
1527 	function airdrop(address to, uint count) external onlyOwner {
1528 		require(
1529 			_totalMinted() + count <= maxSupply,
1530 			'Exceeds max supply'
1531 		);
1532 		_safeMint(to, count);
1533 	}
1534 
1535 	function reduceSupply(uint newMaxSupply) external onlyOwner {
1536 		maxSupply = newMaxSupply;
1537 	}
1538 
1539     function setNumFreeMints(uint newFreeMints) external onlyOwner {
1540 		MAX_FREE_MINT = newFreeMints;
1541 	}
1542 
1543 	function tokenURI(uint tokenId)
1544 		public
1545 		view
1546 		override
1547 		returns (string memory)
1548 	{
1549         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1550 
1551         return bytes(_baseURI()).length > 0 
1552             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1553             : prerevealURL;
1554 	}
1555 
1556 	function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1557         return MerkleProof.verify(proof, root, leaf);
1558     }
1559 
1560     function WHITELIST_MINT(bytes32[] memory proof) public {
1561         uint count = 1;
1562 		require(isWhitelistMint, "Whitelist mint has not started");
1563         require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Wallet not on the allowlist");
1564 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1565         require(_walletMintedCount[msg.sender] == 0,'Exceeds max free mints');
1566 
1567 		_walletMintedCount[msg.sender] += count;
1568 		_safeMint(msg.sender, count);
1569 	}
1570     
1571     function PUBLIC_MINT(uint count) external payable {
1572 		require(isPublicMint, "Public mint has not started");
1573 		require(count <= MAX_NFT_PER_TRAN,'Exceeds NFT per transaction limit');
1574 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1575         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET,'Exceeds max per wallet');
1576 
1577         uint payForCount = count;
1578         uint mintedSoFar = _walletMintedCount[msg.sender];
1579         
1580         //1 Free Mints Default
1581         uint maxFree = MAX_FREE_MINT;
1582 
1583         if(mintedSoFar < maxFree) {
1584             uint remainingFreeMints = maxFree - mintedSoFar;
1585             if(count > remainingFreeMints) {
1586                 payForCount = count - remainingFreeMints;
1587             }
1588             else {
1589                 payForCount = 0;
1590             }
1591         }
1592 
1593 		require(
1594 			msg.value >= payForCount * MINT_PRICE,
1595 			'Ether value sent is not sufficient'
1596 		);
1597 
1598 		_walletMintedCount[msg.sender] += count;
1599 		_safeMint(msg.sender, count);
1600 	}
1601 }