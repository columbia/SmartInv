1 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev These functions deal with verification of Merkle Trees proofs.
7  *
8  * The proofs can be generated using the JavaScript library
9  * https://github.com/miguelmota/merkletreejs[merkletreejs].
10  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
11  *
12  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
13  */
14 library MerkleProof {
15     /**
16      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
17      * defined by `root`. For this, a `proof` must be provided, containing
18      * sibling hashes on the branch from the leaf to the root of the tree. Each
19      * pair of leaves and each pair of pre-images are assumed to be sorted.
20      */
21     function verify(
22         bytes32[] memory proof,
23         bytes32 root,
24         bytes32 leaf
25     ) internal pure returns (bool) {
26         return processProof(proof, leaf) == root;
27     }
28 
29     /**
30      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
31      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
32      * hash matches the root of the tree. When processing the proof, the pairs
33      * of leafs & pre-images are assumed to be sorted.
34      *
35      * _Available since v4.4._
36      */
37     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
38         bytes32 computedHash = leaf;
39         for (uint256 i = 0; i < proof.length; i++) {
40             bytes32 proofElement = proof[i];
41             if (computedHash <= proofElement) {
42                 // Hash(current computed hash + current element of the proof)
43                 computedHash = _efficientHash(computedHash, proofElement);
44             } else {
45                 // Hash(current element of the proof + current computed hash)
46                 computedHash = _efficientHash(proofElement, computedHash);
47             }
48         }
49         return computedHash;
50     }
51 
52     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
53         assembly {
54             mstore(0x00, a)
55             mstore(0x20, b)
56             value := keccak256(0x00, 0x40)
57         }
58     }
59 }
60 
61 // File: @openzeppelin/contracts/utils/Strings.sol
62 
63 
64 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
65 
66 pragma solidity ^0.8.0;
67 
68 
69 /**
70  * @dev String operations.
71  */
72 library Strings {
73     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
74 
75     /**
76      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
77      */
78     function toString(uint256 value) internal pure returns (string memory) {
79         // Inspired by OraclizeAPI's implementation - MIT licence
80         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
81 
82         if (value == 0) {
83             return "0";
84         }
85         uint256 temp = value;
86         uint256 digits;
87         while (temp != 0) {
88             digits++;
89             temp /= 10;
90         }
91         bytes memory buffer = new bytes(digits);
92         while (value != 0) {
93             digits -= 1;
94             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
95             value /= 10;
96         }
97         return string(buffer);
98     }
99 
100     /**
101      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
102      */
103     function toHexString(uint256 value) internal pure returns (string memory) {
104         if (value == 0) {
105             return "0x00";
106         }
107         uint256 temp = value;
108         uint256 length = 0;
109         while (temp != 0) {
110             length++;
111             temp >>= 8;
112         }
113         return toHexString(value, length);
114     }
115 
116     /**
117      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
118      */
119     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
120         bytes memory buffer = new bytes(2 * length + 2);
121         buffer[0] = "0";
122         buffer[1] = "x";
123         for (uint256 i = 2 * length + 1; i > 1; --i) {
124             buffer[i] = _HEX_SYMBOLS[value & 0xf];
125             value >>= 4;
126         }
127         require(value == 0, "Strings: hex length insufficient");
128         return string(buffer);
129     }
130 }
131 
132 // File: @openzeppelin/contracts/utils/Address.sol
133 
134 
135 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
136 
137 pragma solidity ^0.8.1;
138 
139 /**
140  * @dev Collection of functions related to the address type
141  */
142 library Address {
143     /**
144      * @dev Returns true if `account` is a contract.
145      *
146      * [IMPORTANT]
147      * ====
148      * It is unsafe to assume that an address for which this function returns
149      * false is an externally-owned account (EOA) and not a contract.
150      *
151      * Among others, `isContract` will return false for the following
152      * types of addresses:
153      *
154      *  - an externally-owned account
155      *  - a contract in construction
156      *  - an address where a contract will be created
157      *  - an address where a contract lived, but was destroyed
158      * ====
159      *
160      * [IMPORTANT]
161      * ====
162      * You shouldn't rely on `isContract` to protect against flash loan attacks!
163      *
164      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
165      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
166      * constructor.
167      * ====
168      */
169     function isContract(address account) internal view returns (bool) {
170         // This method relies on extcodesize/address.code.length, which returns 0
171         // for contracts in construction, since the code is only stored at the end
172         // of the constructor execution.
173 
174         return account.code.length > 0;
175     }
176 
177     /**
178      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
179      * `recipient`, forwarding all available gas and reverting on errors.
180      *
181      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
182      * of certain opcodes, possibly making contracts go over the 2300 gas limit
183      * imposed by `transfer`, making them unable to receive funds via
184      * `transfer`. {sendValue} removes this limitation.
185      *
186      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
187      *
188      * IMPORTANT: because control is transferred to `recipient`, care must be
189      * taken to not create reentrancy vulnerabilities. Consider using
190      * {ReentrancyGuard} or the
191      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
192      */
193     function sendValue(address payable recipient, uint256 amount) internal {
194         require(address(this).balance >= amount, "Address: insufficient balance");
195 
196         (bool success, ) = recipient.call{value: amount}("");
197         require(success, "Address: unable to send value, recipient may have reverted");
198     }
199 
200     /**
201      * @dev Performs a Solidity function call using a low level `call`. A
202      * plain `call` is an unsafe replacement for a function call: use this
203      * function instead.
204      *
205      * If `target` reverts with a revert reason, it is bubbled up by this
206      * function (like regular Solidity function calls).
207      *
208      * Returns the raw returned data. To convert to the expected return value,
209      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
210      *
211      * Requirements:
212      *
213      * - `target` must be a contract.
214      * - calling `target` with `data` must not revert.
215      *
216      * _Available since v3.1._
217      */
218     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
219         return functionCall(target, data, "Address: low-level call failed");
220     }
221 
222     /**
223      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
224      * `errorMessage` as a fallback revert reason when `target` reverts.
225      *
226      * _Available since v3.1._
227      */
228     function functionCall(
229         address target,
230         bytes memory data,
231         string memory errorMessage
232     ) internal returns (bytes memory) {
233         return functionCallWithValue(target, data, 0, errorMessage);
234     }
235 
236     /**
237      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
238      * but also transferring `value` wei to `target`.
239      *
240      * Requirements:
241      *
242      * - the calling contract must have an ETH balance of at least `value`.
243      * - the called Solidity function must be `payable`.
244      *
245      * _Available since v3.1._
246      */
247     function functionCallWithValue(
248         address target,
249         bytes memory data,
250         uint256 value
251     ) internal returns (bytes memory) {
252         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
257      * with `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCallWithValue(
262         address target,
263         bytes memory data,
264         uint256 value,
265         string memory errorMessage
266     ) internal returns (bytes memory) {
267         require(address(this).balance >= value, "Address: insufficient balance for call");
268         require(isContract(target), "Address: call to non-contract");
269 
270         (bool success, bytes memory returndata) = target.call{value: value}(data);
271         return verifyCallResult(success, returndata, errorMessage);
272     }
273 
274     /**
275      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
276      * but performing a static call.
277      *
278      * _Available since v3.3._
279      */
280     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
281         return functionStaticCall(target, data, "Address: low-level static call failed");
282     }
283 
284     /**
285      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
286      * but performing a static call.
287      *
288      * _Available since v3.3._
289      */
290     function functionStaticCall(
291         address target,
292         bytes memory data,
293         string memory errorMessage
294     ) internal view returns (bytes memory) {
295         require(isContract(target), "Address: static call to non-contract");
296 
297         (bool success, bytes memory returndata) = target.staticcall(data);
298         return verifyCallResult(success, returndata, errorMessage);
299     }
300 
301     /**
302      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
303      * but performing a delegate call.
304      *
305      * _Available since v3.4._
306      */
307     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
308         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
313      * but performing a delegate call.
314      *
315      * _Available since v3.4._
316      */
317     function functionDelegateCall(
318         address target,
319         bytes memory data,
320         string memory errorMessage
321     ) internal returns (bytes memory) {
322         require(isContract(target), "Address: delegate call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.delegatecall(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
330      * revert reason using the provided one.
331      *
332      * _Available since v4.3._
333      */
334     function verifyCallResult(
335         bool success,
336         bytes memory returndata,
337         string memory errorMessage
338     ) internal pure returns (bytes memory) {
339         if (success) {
340             return returndata;
341         } else {
342             // Look for revert reason and bubble it up if present
343             if (returndata.length > 0) {
344                 // The easiest way to bubble the revert reason is using memory via assembly
345 
346                 assembly {
347                     let returndata_size := mload(returndata)
348                     revert(add(32, returndata), returndata_size)
349                 }
350             } else {
351                 revert(errorMessage);
352             }
353         }
354     }
355 }
356 
357 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
358 
359 
360 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
361 
362 pragma solidity ^0.8.0;
363 
364 /**
365  * @title ERC721 token receiver interface
366  * @dev Interface for any contract that wants to support safeTransfers
367  * from ERC721 asset contracts.
368  */
369 interface IERC721Receiver {
370     /**
371      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
372      * by `operator` from `from`, this function is called.
373      *
374      * It must return its Solidity selector to confirm the token transfer.
375      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
376      *
377      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
378      */
379     function onERC721Received(
380         address operator,
381         address from,
382         uint256 tokenId,
383         bytes calldata data
384     ) external returns (bytes4);
385 }
386 
387 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
388 
389 
390 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
391 
392 pragma solidity ^0.8.0;
393 
394 /**
395  * @dev Interface of the ERC165 standard, as defined in the
396  * https://eips.ethereum.org/EIPS/eip-165[EIP].
397  *
398  * Implementers can declare support of contract interfaces, which can then be
399  * queried by others ({ERC165Checker}).
400  *
401  * For an implementation, see {ERC165}.
402  */
403 interface IERC165 {
404     /**
405      * @dev Returns true if this contract implements the interface defined by
406      * `interfaceId`. See the corresponding
407      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
408      * to learn more about how these ids are created.
409      *
410      * This function call must use less than 30 000 gas.
411      */
412     function supportsInterface(bytes4 interfaceId) external view returns (bool);
413 }
414 
415 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
416 
417 
418 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 
423 /**
424  * @dev Implementation of the {IERC165} interface.
425  *
426  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
427  * for the additional interface id that will be supported. For example:
428  *
429  * ```solidity
430  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
431  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
432  * }
433  * ```
434  *
435  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
436  */
437 abstract contract ERC165 is IERC165 {
438     /**
439      * @dev See {IERC165-supportsInterface}.
440      */
441     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
442         return interfaceId == type(IERC165).interfaceId;
443     }
444 }
445 
446 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
447 
448 
449 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 
454 /**
455  * @dev Required interface of an ERC721 compliant contract.
456  */
457 interface IERC721 is IERC165 {
458     /**
459      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
460      */
461     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
462 
463     /**
464      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
465      */
466     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
467 
468     /**
469      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
470      */
471     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
472 
473     /**
474      * @dev Returns the number of tokens in ``owner``'s account.
475      */
476     function balanceOf(address owner) external view returns (uint256 balance);
477 
478     /**
479      * @dev Returns the owner of the `tokenId` token.
480      *
481      * Requirements:
482      *
483      * - `tokenId` must exist.
484      */
485     function ownerOf(uint256 tokenId) external view returns (address owner);
486 
487     /**
488      * @dev Safely transfers `tokenId` token from `from` to `to`.
489      *
490      * Requirements:
491      *
492      * - `from` cannot be the zero address.
493      * - `to` cannot be the zero address.
494      * - `tokenId` token must exist and be owned by `from`.
495      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
496      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
497      *
498      * Emits a {Transfer} event.
499      */
500     function safeTransferFrom(
501         address from,
502         address to,
503         uint256 tokenId,
504         bytes calldata data
505     ) external;
506 
507     /**
508      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
509      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
510      *
511      * Requirements:
512      *
513      * - `from` cannot be the zero address.
514      * - `to` cannot be the zero address.
515      * - `tokenId` token must exist and be owned by `from`.
516      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
518      *
519      * Emits a {Transfer} event.
520      */
521     function safeTransferFrom(
522         address from,
523         address to,
524         uint256 tokenId
525     ) external;
526 
527     /**
528      * @dev Transfers `tokenId` token from `from` to `to`.
529      *
530      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
531      *
532      * Requirements:
533      *
534      * - `from` cannot be the zero address.
535      * - `to` cannot be the zero address.
536      * - `tokenId` token must be owned by `from`.
537      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
538      *
539      * Emits a {Transfer} event.
540      */
541     function transferFrom(
542         address from,
543         address to,
544         uint256 tokenId
545     ) external;
546 
547     /**
548      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
549      * The approval is cleared when the token is transferred.
550      *
551      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
552      *
553      * Requirements:
554      *
555      * - The caller must own the token or be an approved operator.
556      * - `tokenId` must exist.
557      *
558      * Emits an {Approval} event.
559      */
560     function approve(address to, uint256 tokenId) external;
561 
562     /**
563      * @dev Approve or remove `operator` as an operator for the caller.
564      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
565      *
566      * Requirements:
567      *
568      * - The `operator` cannot be the caller.
569      *
570      * Emits an {ApprovalForAll} event.
571      */
572     function setApprovalForAll(address operator, bool _approved) external;
573 
574     /**
575      * @dev Returns the account approved for `tokenId` token.
576      *
577      * Requirements:
578      *
579      * - `tokenId` must exist.
580      */
581     function getApproved(uint256 tokenId) external view returns (address operator);
582 
583     /**
584      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
585      *
586      * See {setApprovalForAll}
587      */
588     function isApprovedForAll(address owner, address operator) external view returns (bool);
589 }
590 
591 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
592 
593 
594 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
595 
596 pragma solidity ^0.8.0;
597 
598 
599 /**
600  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
601  * @dev See https://eips.ethereum.org/EIPS/eip-721
602  */
603 interface IERC721Metadata is IERC721 {
604     /**
605      * @dev Returns the token collection name.
606      */
607     function name() external view returns (string memory);
608 
609     /**
610      * @dev Returns the token collection symbol.
611      */
612     function symbol() external view returns (string memory);
613 
614     /**
615      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
616      */
617     function tokenURI(uint256 tokenId) external view returns (string memory);
618 }
619 
620 // File: erc721a/contracts/IERC721A.sol
621 
622 
623 // ERC721A Contracts v3.3.0
624 // Creator: Chiru Labs
625 
626 pragma solidity ^0.8.4;
627 
628 
629 
630 /**
631  * @dev Interface of an ERC721A compliant contract.
632  */
633 interface IERC721A is IERC721, IERC721Metadata {
634     /**
635      * The caller must own the token or be an approved operator.
636      */
637     error ApprovalCallerNotOwnerNorApproved();
638 
639     /**
640      * The token does not exist.
641      */
642     error ApprovalQueryForNonexistentToken();
643 
644     /**
645      * The caller cannot approve to their own address.
646      */
647     error ApproveToCaller();
648 
649     /**
650      * The caller cannot approve to the current owner.
651      */
652     error ApprovalToCurrentOwner();
653 
654     /**
655      * Cannot query the balance for the zero address.
656      */
657     error BalanceQueryForZeroAddress();
658 
659     /**
660      * Cannot mint to the zero address.
661      */
662     error MintToZeroAddress();
663 
664     /**
665      * The quantity of tokens minted must be more than zero.
666      */
667     error MintZeroQuantity();
668 
669     /**
670      * The token does not exist.
671      */
672     error OwnerQueryForNonexistentToken();
673 
674     /**
675      * The caller must own the token or be an approved operator.
676      */
677     error TransferCallerNotOwnerNorApproved();
678 
679     /**
680      * The token must be owned by `from`.
681      */
682     error TransferFromIncorrectOwner();
683 
684     /**
685      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
686      */
687     error TransferToNonERC721ReceiverImplementer();
688 
689     /**
690      * Cannot transfer to the zero address.
691      */
692     error TransferToZeroAddress();
693 
694     /**
695      * The token does not exist.
696      */
697     error URIQueryForNonexistentToken();
698 
699     // Compiler will pack this into a single 256bit word.
700     struct TokenOwnership {
701         // The address of the owner.
702         address addr;
703         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
704         uint64 startTimestamp;
705         // Whether the token has been burned.
706         bool burned;
707     }
708 
709     // Compiler will pack this into a single 256bit word.
710     struct AddressData {
711         // Realistically, 2**64-1 is more than enough.
712         uint64 balance;
713         // Keeps track of mint count with minimal overhead for tokenomics.
714         uint64 numberMinted;
715         // Keeps track of burn count with minimal overhead for tokenomics.
716         uint64 numberBurned;
717         // For miscellaneous variable(s) pertaining to the address
718         // (e.g. number of whitelist mint slots used).
719         // If there are multiple variables, please pack them into a uint64.
720         uint64 aux;
721     }
722 
723     /**
724      * @dev Returns the total amount of tokens stored by the contract.
725      * 
726      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
727      */
728     function totalSupply() external view returns (uint256);
729 }
730 
731 // File: @openzeppelin/contracts/utils/Context.sol
732 
733 
734 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev Provides information about the current execution context, including the
740  * sender of the transaction and its data. While these are generally available
741  * via msg.sender and msg.data, they should not be accessed in such a direct
742  * manner, since when dealing with meta-transactions the account sending and
743  * paying for execution may not be the actual sender (as far as an application
744  * is concerned).
745  *
746  * This contract is only required for intermediate, library-like contracts.
747  */
748 abstract contract Context {
749     function _msgSender() internal view virtual returns (address) {
750         return msg.sender;
751     }
752 
753     function _msgData() internal view virtual returns (bytes calldata) {
754         return msg.data;
755     }
756 }
757 
758 // File: erc721a/contracts/ERC721A.sol
759 
760 
761 // ERC721A Contracts v3.3.0
762 // Creator: Chiru Labs
763 
764 pragma solidity ^0.8.4;
765 
766 
767 
768 
769 
770 
771 
772 /**
773  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
774  * the Metadata extension. Built to optimize for lower gas during batch mints.
775  *
776  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
777  *
778  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
779  *
780  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
781  */
782 contract ERC721A is Context, ERC165, IERC721A {
783     using Address for address;
784     using Strings for uint256;
785 
786     // The tokenId of the next token to be minted.
787     uint256 internal _currentIndex;
788 
789     // The number of tokens burned.
790     uint256 internal _burnCounter;
791 
792     // Token name
793     string private _name;
794 
795     // Token symbol
796     string private _symbol;
797 
798     // Mapping from token ID to ownership details
799     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
800     mapping(uint256 => TokenOwnership) internal _ownerships;
801 
802     // Mapping owner address to address data
803     mapping(address => AddressData) private _addressData;
804 
805     // Mapping from token ID to approved address
806     mapping(uint256 => address) private _tokenApprovals;
807 
808     // Mapping from owner to operator approvals
809     mapping(address => mapping(address => bool)) private _operatorApprovals;
810 
811     constructor(string memory name_, string memory symbol_) {
812         _name = name_;
813         _symbol = symbol_;
814         _currentIndex = _startTokenId();
815     }
816 
817     /**
818      * To change the starting tokenId, please override this function.
819      */
820     function _startTokenId() internal view virtual returns (uint256) {
821         return 0;
822     }
823 
824     /**
825      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
826      */
827     function totalSupply() public view override returns (uint256) {
828         // Counter underflow is impossible as _burnCounter cannot be incremented
829         // more than _currentIndex - _startTokenId() times
830         unchecked {
831             return _currentIndex - _burnCounter - _startTokenId();
832         }
833     }
834 
835     /**
836      * Returns the total amount of tokens minted in the contract.
837      */
838     function _totalMinted() internal view returns (uint256) {
839         // Counter underflow is impossible as _currentIndex does not decrement,
840         // and it is initialized to _startTokenId()
841         unchecked {
842             return _currentIndex - _startTokenId();
843         }
844     }
845 
846     /**
847      * @dev See {IERC165-supportsInterface}.
848      */
849     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
850         return
851             interfaceId == type(IERC721).interfaceId ||
852             interfaceId == type(IERC721Metadata).interfaceId ||
853             super.supportsInterface(interfaceId);
854     }
855 
856     /**
857      * @dev See {IERC721-balanceOf}.
858      */
859     function balanceOf(address owner) public view override returns (uint256) {
860         if (owner == address(0)) revert BalanceQueryForZeroAddress();
861         return uint256(_addressData[owner].balance);
862     }
863 
864     /**
865      * Returns the number of tokens minted by `owner`.
866      */
867     function _numberMinted(address owner) internal view returns (uint256) {
868         return uint256(_addressData[owner].numberMinted);
869     }
870 
871     /**
872      * Returns the number of tokens burned by or on behalf of `owner`.
873      */
874     function _numberBurned(address owner) internal view returns (uint256) {
875         return uint256(_addressData[owner].numberBurned);
876     }
877 
878     /**
879      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
880      */
881     function _getAux(address owner) internal view returns (uint64) {
882         return _addressData[owner].aux;
883     }
884 
885     /**
886      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
887      * If there are multiple variables, please pack them into a uint64.
888      */
889     function _setAux(address owner, uint64 aux) internal {
890         _addressData[owner].aux = aux;
891     }
892 
893     /**
894      * Gas spent here starts off proportional to the maximum mint batch size.
895      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
896      */
897     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
898         uint256 curr = tokenId;
899 
900         unchecked {
901             if (_startTokenId() <= curr) if (curr < _currentIndex) {
902                 TokenOwnership memory ownership = _ownerships[curr];
903                 if (!ownership.burned) {
904                     if (ownership.addr != address(0)) {
905                         return ownership;
906                     }
907                     // Invariant:
908                     // There will always be an ownership that has an address and is not burned
909                     // before an ownership that does not have an address and is not burned.
910                     // Hence, curr will not underflow.
911                     while (true) {
912                         curr--;
913                         ownership = _ownerships[curr];
914                         if (ownership.addr != address(0)) {
915                             return ownership;
916                         }
917                     }
918                 }
919             }
920         }
921         revert OwnerQueryForNonexistentToken();
922     }
923 
924     /**
925      * @dev See {IERC721-ownerOf}.
926      */
927     function ownerOf(uint256 tokenId) public view override returns (address) {
928         return _ownershipOf(tokenId).addr;
929     }
930 
931     /**
932      * @dev See {IERC721Metadata-name}.
933      */
934     function name() public view virtual override returns (string memory) {
935         return _name;
936     }
937 
938     /**
939      * @dev See {IERC721Metadata-symbol}.
940      */
941     function symbol() public view virtual override returns (string memory) {
942         return _symbol;
943     }
944 
945     /**
946      * @dev See {IERC721Metadata-tokenURI}.
947      */
948     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
949         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
950 
951         string memory baseURI = _baseURI();
952         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
953     }
954 
955     /**
956      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
957      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
958      * by default, can be overriden in child contracts.
959      */
960     function _baseURI() internal view virtual returns (string memory) {
961         return '';
962     }
963 
964     /**
965      * @dev See {IERC721-approve}.
966      */
967     function approve(address to, uint256 tokenId) public override {
968         address owner = ERC721A.ownerOf(tokenId);
969         if (to == owner) revert ApprovalToCurrentOwner();
970 
971         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
972             revert ApprovalCallerNotOwnerNorApproved();
973         }
974 
975         _approve(to, tokenId, owner);
976     }
977 
978     /**
979      * @dev See {IERC721-getApproved}.
980      */
981     function getApproved(uint256 tokenId) public view override returns (address) {
982         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
983 
984         return _tokenApprovals[tokenId];
985     }
986 
987     /**
988      * @dev See {IERC721-setApprovalForAll}.
989      */
990     function setApprovalForAll(address operator, bool approved) public virtual override {
991         if (operator == _msgSender()) revert ApproveToCaller();
992 
993         _operatorApprovals[_msgSender()][operator] = approved;
994         emit ApprovalForAll(_msgSender(), operator, approved);
995     }
996 
997     /**
998      * @dev See {IERC721-isApprovedForAll}.
999      */
1000     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1001         return _operatorApprovals[owner][operator];
1002     }
1003 
1004     /**
1005      * @dev See {IERC721-transferFrom}.
1006      */
1007     function transferFrom(
1008         address from,
1009         address to,
1010         uint256 tokenId
1011     ) public virtual override {
1012         _transfer(from, to, tokenId);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-safeTransferFrom}.
1017      */
1018     function safeTransferFrom(
1019         address from,
1020         address to,
1021         uint256 tokenId
1022     ) public virtual override {
1023         safeTransferFrom(from, to, tokenId, '');
1024     }
1025 
1026     /**
1027      * @dev See {IERC721-safeTransferFrom}.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId,
1033         bytes memory _data
1034     ) public virtual override {
1035         _transfer(from, to, tokenId);
1036         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1037             revert TransferToNonERC721ReceiverImplementer();
1038         }
1039     }
1040 
1041     /**
1042      * @dev Returns whether `tokenId` exists.
1043      *
1044      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1045      *
1046      * Tokens start existing when they are minted (`_mint`),
1047      */
1048     function _exists(uint256 tokenId) internal view returns (bool) {
1049         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1050     }
1051 
1052     /**
1053      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1054      */
1055     function _safeMint(address to, uint256 quantity) internal {
1056         _safeMint(to, quantity, '');
1057     }
1058 
1059     /**
1060      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1061      *
1062      * Requirements:
1063      *
1064      * - If `to` refers to a smart contract, it must implement
1065      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1066      * - `quantity` must be greater than 0.
1067      *
1068      * Emits a {Transfer} event.
1069      */
1070     function _safeMint(
1071         address to,
1072         uint256 quantity,
1073         bytes memory _data
1074     ) internal {
1075         uint256 startTokenId = _currentIndex;
1076         if (to == address(0)) revert MintToZeroAddress();
1077         if (quantity == 0) revert MintZeroQuantity();
1078 
1079         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1080 
1081         // Overflows are incredibly unrealistic.
1082         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1083         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1084         unchecked {
1085             _addressData[to].balance += uint64(quantity);
1086             _addressData[to].numberMinted += uint64(quantity);
1087 
1088             _ownerships[startTokenId].addr = to;
1089             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1090 
1091             uint256 updatedIndex = startTokenId;
1092             uint256 end = updatedIndex + quantity;
1093 
1094             if (to.isContract()) {
1095                 do {
1096                     emit Transfer(address(0), to, updatedIndex);
1097                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1098                         revert TransferToNonERC721ReceiverImplementer();
1099                     }
1100                 } while (updatedIndex < end);
1101                 // Reentrancy protection
1102                 if (_currentIndex != startTokenId) revert();
1103             } else {
1104                 do {
1105                     emit Transfer(address(0), to, updatedIndex++);
1106                 } while (updatedIndex < end);
1107             }
1108             _currentIndex = updatedIndex;
1109         }
1110         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1111     }
1112 
1113     /**
1114      * @dev Mints `quantity` tokens and transfers them to `to`.
1115      *
1116      * Requirements:
1117      *
1118      * - `to` cannot be the zero address.
1119      * - `quantity` must be greater than 0.
1120      *
1121      * Emits a {Transfer} event.
1122      */
1123     function _mint(address to, uint256 quantity) internal {
1124         uint256 startTokenId = _currentIndex;
1125         if (to == address(0)) revert MintToZeroAddress();
1126         if (quantity == 0) revert MintZeroQuantity();
1127 
1128         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1129 
1130         // Overflows are incredibly unrealistic.
1131         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1132         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1133         unchecked {
1134             _addressData[to].balance += uint64(quantity);
1135             _addressData[to].numberMinted += uint64(quantity);
1136 
1137             _ownerships[startTokenId].addr = to;
1138             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1139 
1140             uint256 updatedIndex = startTokenId;
1141             uint256 end = updatedIndex + quantity;
1142 
1143             do {
1144                 emit Transfer(address(0), to, updatedIndex++);
1145             } while (updatedIndex < end);
1146 
1147             _currentIndex = updatedIndex;
1148         }
1149         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1150     }
1151 
1152     /**
1153      * @dev Transfers `tokenId` from `from` to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - `to` cannot be the zero address.
1158      * - `tokenId` token must be owned by `from`.
1159      *
1160      * Emits a {Transfer} event.
1161      */
1162     function _transfer(
1163         address from,
1164         address to,
1165         uint256 tokenId
1166     ) private {
1167         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1168 
1169         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1170 
1171         bool isApprovedOrOwner = (_msgSender() == from ||
1172             isApprovedForAll(from, _msgSender()) ||
1173             getApproved(tokenId) == _msgSender());
1174 
1175         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1176         if (to == address(0)) revert TransferToZeroAddress();
1177 
1178         _beforeTokenTransfers(from, to, tokenId, 1);
1179 
1180         // Clear approvals from the previous owner
1181         _approve(address(0), tokenId, from);
1182 
1183         // Underflow of the sender's balance is impossible because we check for
1184         // ownership above and the recipient's balance can't realistically overflow.
1185         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1186         unchecked {
1187             _addressData[from].balance -= 1;
1188             _addressData[to].balance += 1;
1189 
1190             TokenOwnership storage currSlot = _ownerships[tokenId];
1191             currSlot.addr = to;
1192             currSlot.startTimestamp = uint64(block.timestamp);
1193 
1194             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1195             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1196             uint256 nextTokenId = tokenId + 1;
1197             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1198             if (nextSlot.addr == address(0)) {
1199                 // This will suffice for checking _exists(nextTokenId),
1200                 // as a burned slot cannot contain the zero address.
1201                 if (nextTokenId != _currentIndex) {
1202                     nextSlot.addr = from;
1203                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1204                 }
1205             }
1206         }
1207 
1208         emit Transfer(from, to, tokenId);
1209         _afterTokenTransfers(from, to, tokenId, 1);
1210     }
1211 
1212     /**
1213      * @dev Equivalent to `_burn(tokenId, false)`.
1214      */
1215     function _burn(uint256 tokenId) internal virtual {
1216         _burn(tokenId, false);
1217     }
1218 
1219     /**
1220      * @dev Destroys `tokenId`.
1221      * The approval is cleared when the token is burned.
1222      *
1223      * Requirements:
1224      *
1225      * - `tokenId` must exist.
1226      *
1227      * Emits a {Transfer} event.
1228      */
1229     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1230         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1231 
1232         address from = prevOwnership.addr;
1233 
1234         if (approvalCheck) {
1235             bool isApprovedOrOwner = (_msgSender() == from ||
1236                 isApprovedForAll(from, _msgSender()) ||
1237                 getApproved(tokenId) == _msgSender());
1238 
1239             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1240         }
1241 
1242         _beforeTokenTransfers(from, address(0), tokenId, 1);
1243 
1244         // Clear approvals from the previous owner
1245         _approve(address(0), tokenId, from);
1246 
1247         // Underflow of the sender's balance is impossible because we check for
1248         // ownership above and the recipient's balance can't realistically overflow.
1249         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1250         unchecked {
1251             AddressData storage addressData = _addressData[from];
1252             addressData.balance -= 1;
1253             addressData.numberBurned += 1;
1254 
1255             // Keep track of who burned the token, and the timestamp of burning.
1256             TokenOwnership storage currSlot = _ownerships[tokenId];
1257             currSlot.addr = from;
1258             currSlot.startTimestamp = uint64(block.timestamp);
1259             currSlot.burned = true;
1260 
1261             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1262             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1263             uint256 nextTokenId = tokenId + 1;
1264             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1265             if (nextSlot.addr == address(0)) {
1266                 // This will suffice for checking _exists(nextTokenId),
1267                 // as a burned slot cannot contain the zero address.
1268                 if (nextTokenId != _currentIndex) {
1269                     nextSlot.addr = from;
1270                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1271                 }
1272             }
1273         }
1274 
1275         emit Transfer(from, address(0), tokenId);
1276         _afterTokenTransfers(from, address(0), tokenId, 1);
1277 
1278         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1279         unchecked {
1280             _burnCounter++;
1281         }
1282     }
1283 
1284     /**
1285      * @dev Approve `to` to operate on `tokenId`
1286      *
1287      * Emits a {Approval} event.
1288      */
1289     function _approve(
1290         address to,
1291         uint256 tokenId,
1292         address owner
1293     ) private {
1294         _tokenApprovals[tokenId] = to;
1295         emit Approval(owner, to, tokenId);
1296     }
1297 
1298     /**
1299      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1300      *
1301      * @param from address representing the previous owner of the given token ID
1302      * @param to target address that will receive the tokens
1303      * @param tokenId uint256 ID of the token to be transferred
1304      * @param _data bytes optional data to send along with the call
1305      * @return bool whether the call correctly returned the expected magic value
1306      */
1307     function _checkContractOnERC721Received(
1308         address from,
1309         address to,
1310         uint256 tokenId,
1311         bytes memory _data
1312     ) private returns (bool) {
1313         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1314             return retval == IERC721Receiver(to).onERC721Received.selector;
1315         } catch (bytes memory reason) {
1316             if (reason.length == 0) {
1317                 revert TransferToNonERC721ReceiverImplementer();
1318             } else {
1319                 assembly {
1320                     revert(add(32, reason), mload(reason))
1321                 }
1322             }
1323         }
1324     }
1325 
1326     /**
1327      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1328      * And also called before burning one token.
1329      *
1330      * startTokenId - the first token id to be transferred
1331      * quantity - the amount to be transferred
1332      *
1333      * Calling conditions:
1334      *
1335      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1336      * transferred to `to`.
1337      * - When `from` is zero, `tokenId` will be minted for `to`.
1338      * - When `to` is zero, `tokenId` will be burned by `from`.
1339      * - `from` and `to` are never both zero.
1340      */
1341     function _beforeTokenTransfers(
1342         address from,
1343         address to,
1344         uint256 startTokenId,
1345         uint256 quantity
1346     ) internal virtual {}
1347 
1348     /**
1349      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1350      * minting.
1351      * And also called after one token has been burned.
1352      *
1353      * startTokenId - the first token id to be transferred
1354      * quantity - the amount to be transferred
1355      *
1356      * Calling conditions:
1357      *
1358      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1359      * transferred to `to`.
1360      * - When `from` is zero, `tokenId` has been minted for `to`.
1361      * - When `to` is zero, `tokenId` has been burned by `from`.
1362      * - `from` and `to` are never both zero.
1363      */
1364     function _afterTokenTransfers(
1365         address from,
1366         address to,
1367         uint256 startTokenId,
1368         uint256 quantity
1369     ) internal virtual {}
1370 }
1371 
1372 // File: @openzeppelin/contracts/access/Ownable.sol
1373 
1374 
1375 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 
1380 /**
1381  * @dev Contract module which provides a basic access control mechanism, where
1382  * there is an account (an owner) that can be granted exclusive access to
1383  * specific functions.
1384  *
1385  * By default, the owner account will be the one that deploys the contract. This
1386  * can later be changed with {transferOwnership}.
1387  *
1388  * This module is used through inheritance. It will make available the modifier
1389  * `onlyOwner`, which can be applied to your functions to restrict their use to
1390  * the owner.
1391  */
1392 abstract contract Ownable is Context {
1393     address private _owner;
1394 
1395     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1396 
1397     /**
1398      * @dev Initializes the contract setting the deployer as the initial owner.
1399      */
1400     constructor() {
1401         _transferOwnership(_msgSender());
1402     }
1403 
1404     /**
1405      * @dev Returns the address of the current owner.
1406      */
1407     function owner() public view virtual returns (address) {
1408         return _owner;
1409     }
1410 
1411     /**
1412      * @dev Throws if called by any account other than the owner.
1413      */
1414     modifier onlyOwner() {
1415         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1416         _;
1417     }
1418 
1419     /**
1420      * @dev Leaves the contract without owner. It will not be possible to call
1421      * `onlyOwner` functions anymore. Can only be called by the current owner.
1422      *
1423      * NOTE: Renouncing ownership will leave the contract without an owner,
1424      * thereby removing any functionality that is only available to the owner.
1425      */
1426     function renounceOwnership() public virtual onlyOwner {
1427         _transferOwnership(address(0));
1428     }
1429 
1430     /**
1431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1432      * Can only be called by the current owner.
1433      */
1434     function transferOwnership(address newOwner) public virtual onlyOwner {
1435         require(newOwner != address(0), "Ownable: new owner is the zero address");
1436         _transferOwnership(newOwner);
1437     }
1438 
1439     /**
1440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1441      * Internal function without access restriction.
1442      */
1443     function _transferOwnership(address newOwner) internal virtual {
1444         address oldOwner = _owner;
1445         _owner = newOwner;
1446         emit OwnershipTransferred(oldOwner, newOwner);
1447     }
1448 }
1449 
1450 
1451 
1452 pragma solidity ^0.8.0;
1453 
1454 contract TheVerdyctResurgence is ERC721A, Ownable {
1455     bytes32 public root;
1456 	using Strings for uint;
1457 
1458 	uint public PUBLIC_MINT_PRICE = 0.006 ether;
1459 	uint public MAX_NFT_PER_TRAN = 3;
1460     uint public MAX_PER_WALLET = 100;
1461     uint public MAX_FREE_MINT = 1;
1462 	uint public FREE_CLAIM_LIMIT = 1000;
1463 	uint public maxSupply = 2000;
1464 
1465 	bool public isPublicMint = false;
1466     bool public isMetadataFinal;
1467     string private _baseURL;
1468 	string public prerevealURL = "ipfs://bafybeigl2iqnrnwnhgr3nkrw5mklhjkqmeuoqhaeda2p5gnjvohrxuvhfi/unrevealed.json";
1469 	mapping(address => uint) private _walletMintedCount;
1470 	mapping(address => uint) private _freeMintedCount;
1471 
1472     // Name
1473 	constructor()
1474 	ERC721A('The Verdyct', 'VERDYCT') {
1475     }
1476 
1477 	function _baseURI() internal view override returns (string memory) {
1478 		return _baseURL;
1479 	}
1480 
1481 	function _startTokenId() internal pure override returns (uint) {
1482 		return 1;
1483 	}
1484 
1485 	function contractURI() public pure returns (string memory) {
1486 		return "";
1487 	}
1488 
1489     function finalizeMetadata() external onlyOwner {
1490         isMetadataFinal = true;
1491     }
1492 
1493 	function reveal(string memory url) external onlyOwner {
1494         require(!isMetadataFinal, "Metadata is finalized");
1495 		_baseURL = url;
1496 	}
1497 
1498     function setPrereveal(string memory url) external onlyOwner {
1499 		prerevealURL = url;
1500 	}
1501 
1502     function mintedCount(address owner) external view returns (uint) {
1503         return _walletMintedCount[owner];
1504     }
1505 
1506     function setRoot(bytes32 _root) external onlyOwner {
1507 		root = _root;
1508 	}
1509 
1510 	function setPublicState(bool value) external onlyOwner {
1511 		isPublicMint = value;
1512 	}
1513 
1514 
1515     // Splitter
1516     
1517     function withdraw() public onlyOwner {
1518         uint256 balance = address(this).balance;
1519 
1520         //Dev Wallet
1521         address _wallet1 = 0x52a3b74b0C0607BE3BB1Ca09dC3d2aE3081746e6;
1522         uint _payable1 = balance * 25 / 100; // 25%
1523         payable(_wallet1).transfer(_payable1);
1524 
1525         //Founder Wallet
1526         address _wallet2 = 0xD2d9B8a80997c335CE8980a8da015036C3e7d331;
1527         uint _payable2 = balance * 75 / 100; // 75%
1528         payable(_wallet2).transfer(_payable2);
1529     }
1530 
1531     // function withdraw() public onlyOwner {
1532     //     uint256 balance = address(this).balance;
1533     //     payable(msg.sender).transfer(balance);
1534     // }
1535 
1536 	function reserveMint(address to, uint count) external onlyOwner {
1537 		require(
1538 			_totalMinted() + count <= maxSupply,
1539 			'Exceeds max supply'
1540 		);
1541 		_safeMint(to, count);
1542 	}
1543 
1544     function setCost(uint newCost) external onlyOwner {
1545 		PUBLIC_MINT_PRICE = newCost;
1546 	}
1547 
1548 	function reduceSupply(uint newMaxSupply) external onlyOwner {
1549 		maxSupply = newMaxSupply;
1550 	}
1551 
1552     function setNumFreeMints(uint newFreeMints) external onlyOwner {
1553 		MAX_FREE_MINT = newFreeMints;
1554 	}
1555 
1556     function setFreeClaimLimit(uint newLimit) external onlyOwner {
1557 		FREE_CLAIM_LIMIT = newLimit;
1558 	}
1559 
1560 	function tokenURI(uint tokenId)
1561 		public
1562 		view
1563 		override
1564 		returns (string memory)
1565 	{
1566         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1567 
1568         return bytes(_baseURI()).length > 0 
1569             ? string(abi.encodePacked(_baseURI(), tokenId.toString(), ".json"))
1570             : prerevealURL;
1571 	}
1572 
1573 	function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1574         return MerkleProof.verify(proof, root, leaf);
1575     }
1576     
1577     function publicMint(uint count) external payable {
1578 		require(isPublicMint, "Mint has not started");
1579 		require(count <= MAX_NFT_PER_TRAN,'Exceeds NFT per transaction limit');
1580 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1581         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET,'Exceeds max per wallet');
1582 
1583 		require(
1584 			msg.value >= count * PUBLIC_MINT_PRICE,
1585 			'Ether value sent is not sufficient'
1586 		);
1587 
1588 		_walletMintedCount[msg.sender] += count;
1589 		_safeMint(msg.sender, count);
1590 	}
1591 
1592     function freeClaim() public  {
1593         uint count = 1;
1594         uint freeSoFar = _freeMintedCount[msg.sender];
1595 
1596         // //require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "You are not on the allowlist");
1597         // if (isValid(proof, keccak256(abi.encodePacked(msg.sender)))) {
1598         //     revert NotWhitelisted();
1599         // }
1600 
1601 		require(isPublicMint, "Mint has not started");
1602 		require(totalSupply() < FREE_CLAIM_LIMIT, "Exceeds max free claim supply");
1603 		require(freeSoFar < MAX_FREE_MINT, "You have already claimed your free NFT");
1604 		require(_totalMinted() + count <= maxSupply,'Exceeds max supply');
1605         require(_walletMintedCount[msg.sender] + count <= MAX_PER_WALLET,'Exceeds max per wallet');
1606 
1607 		_freeMintedCount[msg.sender] += count;
1608 		_safeMint(msg.sender, count);
1609 	}
1610 }