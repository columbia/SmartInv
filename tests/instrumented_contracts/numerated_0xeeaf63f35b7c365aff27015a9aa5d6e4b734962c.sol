1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
5 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 
57 // File: @openzeppelin/contracts/utils/Strings.sol
58 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
59 pragma solidity ^0.8.0;
60 
61 /**
62  * @dev String operations.
63  */
64 library Strings {
65     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
66 
67     /**
68      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
69      */
70     function toString(uint256 value) internal pure returns (string memory) {
71         // Inspired by OraclizeAPI's implementation - MIT licence
72         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
73 
74         if (value == 0) {
75             return "0";
76         }
77         uint256 temp = value;
78         uint256 digits;
79         while (temp != 0) {
80             digits++;
81             temp /= 10;
82         }
83         bytes memory buffer = new bytes(digits);
84         while (value != 0) {
85             digits -= 1;
86             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
87             value /= 10;
88         }
89         return string(buffer);
90     }
91 
92     /**
93      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
94      */
95     function toHexString(uint256 value) internal pure returns (string memory) {
96         if (value == 0) {
97             return "0x00";
98         }
99         uint256 temp = value;
100         uint256 length = 0;
101         while (temp != 0) {
102             length++;
103             temp >>= 8;
104         }
105         return toHexString(value, length);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
110      */
111     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
112         bytes memory buffer = new bytes(2 * length + 2);
113         buffer[0] = "0";
114         buffer[1] = "x";
115         for (uint256 i = 2 * length + 1; i > 1; --i) {
116             buffer[i] = _HEX_SYMBOLS[value & 0xf];
117             value >>= 4;
118         }
119         require(value == 0, "Strings: hex length insufficient");
120         return string(buffer);
121     }
122 }
123 
124 
125 // File: @openzeppelin/contracts/utils/Address.sol
126 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Collection of functions related to the address type
131  */
132 library Address {
133     /**
134      * @dev Returns true if `account` is a contract.
135      *
136      * [IMPORTANT]
137      * ====
138      * It is unsafe to assume that an address for which this function returns
139      * false is an externally-owned account (EOA) and not a contract.
140      *
141      * Among others, `isContract` will return false for the following
142      * types of addresses:
143      *
144      *  - an externally-owned account
145      *  - a contract in construction
146      *  - an address where a contract will be created
147      *  - an address where a contract lived, but was destroyed
148      * ====
149      */
150     function isContract(address account) internal view returns (bool) {
151         // This method relies on extcodesize, which returns 0 for contracts in
152         // construction, since the code is only stored at the end of the
153         // constructor execution.
154 
155         uint256 size;
156         assembly {
157             size := extcodesize(account)
158         }
159         return size > 0;
160     }
161 
162     /**
163      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
164      * `recipient`, forwarding all available gas and reverting on errors.
165      *
166      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
167      * of certain opcodes, possibly making contracts go over the 2300 gas limit
168      * imposed by `transfer`, making them unable to receive funds via
169      * `transfer`. {sendValue} removes this limitation.
170      *
171      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
172      *
173      * IMPORTANT: because control is transferred to `recipient`, care must be
174      * taken to not create reentrancy vulnerabilities. Consider using
175      * {ReentrancyGuard} or the
176      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
177      */
178     function sendValue(address payable recipient, uint256 amount) internal {
179         require(address(this).balance >= amount, "Address: insufficient balance");
180 
181         (bool success, ) = recipient.call{value: amount}("");
182         require(success, "Address: unable to send value, recipient may have reverted");
183     }
184 
185     /**
186      * @dev Performs a Solidity function call using a low level `call`. A
187      * plain `call` is an unsafe replacement for a function call: use this
188      * function instead.
189      *
190      * If `target` reverts with a revert reason, it is bubbled up by this
191      * function (like regular Solidity function calls).
192      *
193      * Returns the raw returned data. To convert to the expected return value,
194      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
195      *
196      * Requirements:
197      *
198      * - `target` must be a contract.
199      * - calling `target` with `data` must not revert.
200      *
201      * _Available since v3.1._
202      */
203     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
204         return functionCall(target, data, "Address: low-level call failed");
205     }
206 
207     /**
208      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
209      * `errorMessage` as a fallback revert reason when `target` reverts.
210      *
211      * _Available since v3.1._
212      */
213     function functionCall(
214         address target,
215         bytes memory data,
216         string memory errorMessage
217     ) internal returns (bytes memory) {
218         return functionCallWithValue(target, data, 0, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but also transferring `value` wei to `target`.
224      *
225      * Requirements:
226      *
227      * - the calling contract must have an ETH balance of at least `value`.
228      * - the called Solidity function must be `payable`.
229      *
230      * _Available since v3.1._
231      */
232     function functionCallWithValue(
233         address target,
234         bytes memory data,
235         uint256 value
236     ) internal returns (bytes memory) {
237         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
242      * with `errorMessage` as a fallback revert reason when `target` reverts.
243      *
244      * _Available since v3.1._
245      */
246     function functionCallWithValue(
247         address target,
248         bytes memory data,
249         uint256 value,
250         string memory errorMessage
251     ) internal returns (bytes memory) {
252         require(address(this).balance >= value, "Address: insufficient balance for call");
253         require(isContract(target), "Address: call to non-contract");
254 
255         (bool success, bytes memory returndata) = target.call{value: value}(data);
256         return verifyCallResult(success, returndata, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but performing a static call.
262      *
263      * _Available since v3.3._
264      */
265     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
266         return functionStaticCall(target, data, "Address: low-level static call failed");
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(
276         address target,
277         bytes memory data,
278         string memory errorMessage
279     ) internal view returns (bytes memory) {
280         require(isContract(target), "Address: static call to non-contract");
281 
282         (bool success, bytes memory returndata) = target.staticcall(data);
283         return verifyCallResult(success, returndata, errorMessage);
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
288      * but performing a delegate call.
289      *
290      * _Available since v3.4._
291      */
292     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
293         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
294     }
295 
296     /**
297      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
298      * but performing a delegate call.
299      *
300      * _Available since v3.4._
301      */
302     function functionDelegateCall(
303         address target,
304         bytes memory data,
305         string memory errorMessage
306     ) internal returns (bytes memory) {
307         require(isContract(target), "Address: delegate call to non-contract");
308 
309         (bool success, bytes memory returndata) = target.delegatecall(data);
310         return verifyCallResult(success, returndata, errorMessage);
311     }
312 
313     /**
314      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
315      * revert reason using the provided one.
316      *
317      * _Available since v4.3._
318      */
319     function verifyCallResult(
320         bool success,
321         bytes memory returndata,
322         string memory errorMessage
323     ) internal pure returns (bytes memory) {
324         if (success) {
325             return returndata;
326         } else {
327             // Look for revert reason and bubble it up if present
328             if (returndata.length > 0) {
329                 // The easiest way to bubble the revert reason is using memory via assembly
330 
331                 assembly {
332                     let returndata_size := mload(returndata)
333                     revert(add(32, returndata), returndata_size)
334                 }
335             } else {
336                 revert(errorMessage);
337             }
338         }
339     }
340 }
341 
342 
343 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
344 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
345 pragma solidity ^0.8.0;
346 
347 /**
348  * @title ERC721 token receiver interface
349  * @dev Interface for any contract that wants to support safeTransfers
350  * from ERC721 asset contracts.
351  */
352 interface IERC721Receiver {
353     /**
354      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
355      * by `operator` from `from`, this function is called.
356      *
357      * It must return its Solidity selector to confirm the token transfer.
358      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
359      *
360      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
361      */
362     function onERC721Received(
363         address operator,
364         address from,
365         uint256 tokenId,
366         bytes calldata data
367     ) external returns (bytes4);
368 }
369 
370 
371 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
372 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
373 pragma solidity ^0.8.0;
374 
375 /**
376  * @dev Interface of the ERC165 standard, as defined in the
377  * https://eips.ethereum.org/EIPS/eip-165[EIP].
378  *
379  * Implementers can declare support of contract interfaces, which can then be
380  * queried by others ({ERC165Checker}).
381  *
382  * For an implementation, see {ERC165}.
383  */
384 interface IERC165 {
385     /**
386      * @dev Returns true if this contract implements the interface defined by
387      * `interfaceId`. See the corresponding
388      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
389      * to learn more about how these ids are created.
390      *
391      * This function call must use less than 30 000 gas.
392      */
393     function supportsInterface(bytes4 interfaceId) external view returns (bool);
394 }
395 
396 
397 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
398 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Implementation of the {IERC165} interface.
403  *
404  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
405  * for the additional interface id that will be supported. For example:
406  *
407  * ```solidity
408  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
409  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
410  * }
411  * ```
412  *
413  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
414  */
415 abstract contract ERC165 is IERC165 {
416     /**
417      * @dev See {IERC165-supportsInterface}.
418      */
419     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
420         return interfaceId == type(IERC165).interfaceId;
421     }
422 }
423 
424 
425 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
426 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Required interface of an ERC721 compliant contract.
431  */
432 interface IERC721 is IERC165 {
433     /**
434      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
435      */
436     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
437 
438     /**
439      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
440      */
441     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
442 
443     /**
444      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
445      */
446     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
447 
448     /**
449      * @dev Returns the number of tokens in ``owner``'s account.
450      */
451     function balanceOf(address owner) external view returns (uint256 balance);
452 
453     /**
454      * @dev Returns the owner of the `tokenId` token.
455      *
456      * Requirements:
457      *
458      * - `tokenId` must exist.
459      */
460     function ownerOf(uint256 tokenId) external view returns (address owner);
461 
462     /**
463      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
464      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
465      *
466      * Requirements:
467      *
468      * - `from` cannot be the zero address.
469      * - `to` cannot be the zero address.
470      * - `tokenId` token must exist and be owned by `from`.
471      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
472      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
473      *
474      * Emits a {Transfer} event.
475      */
476     function safeTransferFrom(
477         address from,
478         address to,
479         uint256 tokenId
480     ) external;
481 
482     /**
483      * @dev Transfers `tokenId` token from `from` to `to`.
484      *
485      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
486      *
487      * Requirements:
488      *
489      * - `from` cannot be the zero address.
490      * - `to` cannot be the zero address.
491      * - `tokenId` token must be owned by `from`.
492      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
493      *
494      * Emits a {Transfer} event.
495      */
496     function transferFrom(
497         address from,
498         address to,
499         uint256 tokenId
500     ) external;
501 
502     /**
503      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
504      * The approval is cleared when the token is transferred.
505      *
506      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
507      *
508      * Requirements:
509      *
510      * - The caller must own the token or be an approved operator.
511      * - `tokenId` must exist.
512      *
513      * Emits an {Approval} event.
514      */
515     function approve(address to, uint256 tokenId) external;
516 
517     /**
518      * @dev Returns the account approved for `tokenId` token.
519      *
520      * Requirements:
521      *
522      * - `tokenId` must exist.
523      */
524     function getApproved(uint256 tokenId) external view returns (address operator);
525 
526     /**
527      * @dev Approve or remove `operator` as an operator for the caller.
528      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
529      *
530      * Requirements:
531      *
532      * - The `operator` cannot be the caller.
533      *
534      * Emits an {ApprovalForAll} event.
535      */
536     function setApprovalForAll(address operator, bool _approved) external;
537 
538     /**
539      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
540      *
541      * See {setApprovalForAll}
542      */
543     function isApprovedForAll(address owner, address operator) external view returns (bool);
544 
545     /**
546      * @dev Safely transfers `tokenId` token from `from` to `to`.
547      *
548      * Requirements:
549      *
550      * - `from` cannot be the zero address.
551      * - `to` cannot be the zero address.
552      * - `tokenId` token must exist and be owned by `from`.
553      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
554      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
555      *
556      * Emits a {Transfer} event.
557      */
558     function safeTransferFrom(
559         address from,
560         address to,
561         uint256 tokenId,
562         bytes calldata data
563     ) external;
564 }
565 
566 
567 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
568 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
569 pragma solidity ^0.8.0;
570 
571 /**
572  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
573  * @dev See https://eips.ethereum.org/EIPS/eip-721
574  */
575 interface IERC721Metadata is IERC721 {
576     /**
577      * @dev Returns the token collection name.
578      */
579     function name() external view returns (string memory);
580 
581     /**
582      * @dev Returns the token collection symbol.
583      */
584     function symbol() external view returns (string memory);
585 
586     /**
587      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
588      */
589     function tokenURI(uint256 tokenId) external view returns (string memory);
590 }
591 
592 
593 // File: @openzeppelin/contracts/utils/Context.sol
594 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Provides information about the current execution context, including the
599  * sender of the transaction and its data. While these are generally available
600  * via msg.sender and msg.data, they should not be accessed in such a direct
601  * manner, since when dealing with meta-transactions the account sending and
602  * paying for execution may not be the actual sender (as far as an application
603  * is concerned).
604  *
605  * This contract is only required for intermediate, library-like contracts.
606  */
607 abstract contract Context {
608     function _msgSender() internal view virtual returns (address) {
609         return msg.sender;
610     }
611 
612     function _msgData() internal view virtual returns (bytes calldata) {
613         return msg.data;
614     }
615 }
616 
617 
618 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
619 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
624  * the Metadata extension, but not including the Enumerable extension, which is available separately as
625  * {ERC721Enumerable}.
626  */
627 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
628     using Address for address;
629     using Strings for uint256;
630 
631     // Token name
632     string private _name;
633 
634     // Token symbol
635     string private _symbol;
636 
637     // Mapping from token ID to owner address
638     mapping(uint256 => address) private _owners;
639 
640     // Mapping owner address to token count
641     mapping(address => uint256) private _balances;
642 
643     // Mapping from token ID to approved address
644     mapping(uint256 => address) private _tokenApprovals;
645 
646     // Mapping from owner to operator approvals
647     mapping(address => mapping(address => bool)) private _operatorApprovals;
648 
649     /**
650      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
651      */
652     constructor(string memory name_, string memory symbol_) {
653         _name = name_;
654         _symbol = symbol_;
655     }
656 
657     /**
658      * @dev See {IERC165-supportsInterface}.
659      */
660     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
661         return
662             interfaceId == type(IERC721).interfaceId ||
663             interfaceId == type(IERC721Metadata).interfaceId ||
664             super.supportsInterface(interfaceId);
665     }
666 
667     /**
668      * @dev See {IERC721-balanceOf}.
669      */
670     function balanceOf(address owner) public view virtual override returns (uint256) {
671         require(owner != address(0), "ERC721: balance query for the zero address");
672         return _balances[owner];
673     }
674 
675     /**
676      * @dev See {IERC721-ownerOf}.
677      */
678     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
679         address owner = _owners[tokenId];
680         require(owner != address(0), "ERC721: owner query for nonexistent token");
681         return owner;
682     }
683 
684     /**
685      * @dev See {IERC721Metadata-name}.
686      */
687     function name() public view virtual override returns (string memory) {
688         return _name;
689     }
690 
691     /**
692      * @dev See {IERC721Metadata-symbol}.
693      */
694     function symbol() public view virtual override returns (string memory) {
695         return _symbol;
696     }
697 
698     /**
699      * @dev See {IERC721Metadata-tokenURI}.
700      */
701     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
702         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
703 
704         string memory baseURI = _baseURI();
705         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
706     }
707 
708     /**
709      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
710      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
711      * by default, can be overriden in child contracts.
712      */
713     function _baseURI() internal view virtual returns (string memory) {
714         return "";
715     }
716 
717     /**
718      * @dev See {IERC721-approve}.
719      */
720     function approve(address to, uint256 tokenId) public virtual override {
721         address owner = ERC721.ownerOf(tokenId);
722         require(to != owner, "ERC721: approval to current owner");
723 
724         require(
725             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
726             "ERC721: approve caller is not owner nor approved for all"
727         );
728 
729         _approve(to, tokenId);
730     }
731 
732     /**
733      * @dev See {IERC721-getApproved}.
734      */
735     function getApproved(uint256 tokenId) public view virtual override returns (address) {
736         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
737 
738         return _tokenApprovals[tokenId];
739     }
740 
741     /**
742      * @dev See {IERC721-setApprovalForAll}.
743      */
744     function setApprovalForAll(address operator, bool approved) public virtual override {
745         _setApprovalForAll(_msgSender(), operator, approved);
746     }
747 
748     /**
749      * @dev See {IERC721-isApprovedForAll}.
750      */
751     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
752         return _operatorApprovals[owner][operator];
753     }
754 
755     /**
756      * @dev See {IERC721-transferFrom}.
757      */
758     function transferFrom(
759         address from,
760         address to,
761         uint256 tokenId
762     ) public virtual override {
763         //solhint-disable-next-line max-line-length
764         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
765 
766         _transfer(from, to, tokenId);
767     }
768 
769     /**
770      * @dev See {IERC721-safeTransferFrom}.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId
776     ) public virtual override {
777         safeTransferFrom(from, to, tokenId, "");
778     }
779 
780     /**
781      * @dev See {IERC721-safeTransferFrom}.
782      */
783     function safeTransferFrom(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes memory _data
788     ) public virtual override {
789         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
790         _safeTransfer(from, to, tokenId, _data);
791     }
792 
793     /**
794      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
795      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
796      *
797      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
798      *
799      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
800      * implement alternative mechanisms to perform token transfer, such as signature-based.
801      *
802      * Requirements:
803      *
804      * - `from` cannot be the zero address.
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must exist and be owned by `from`.
807      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
808      *
809      * Emits a {Transfer} event.
810      */
811     function _safeTransfer(
812         address from,
813         address to,
814         uint256 tokenId,
815         bytes memory _data
816     ) internal virtual {
817         _transfer(from, to, tokenId);
818         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
819     }
820 
821     /**
822      * @dev Returns whether `tokenId` exists.
823      *
824      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
825      *
826      * Tokens start existing when they are minted (`_mint`),
827      * and stop existing when they are burned (`_burn`).
828      */
829     function _exists(uint256 tokenId) internal view virtual returns (bool) {
830         return _owners[tokenId] != address(0);
831     }
832 
833     /**
834      * @dev Returns whether `spender` is allowed to manage `tokenId`.
835      *
836      * Requirements:
837      *
838      * - `tokenId` must exist.
839      */
840     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
841         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
842         address owner = ERC721.ownerOf(tokenId);
843         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
844     }
845 
846     /**
847      * @dev Safely mints `tokenId` and transfers it to `to`.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must not exist.
852      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
853      *
854      * Emits a {Transfer} event.
855      */
856     function _safeMint(address to, uint256 tokenId) internal virtual {
857         _safeMint(to, tokenId, "");
858     }
859 
860     /**
861      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
862      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
863      */
864     function _safeMint(
865         address to,
866         uint256 tokenId,
867         bytes memory _data
868     ) internal virtual {
869         _mint(to, tokenId);
870         require(
871             _checkOnERC721Received(address(0), to, tokenId, _data),
872             "ERC721: transfer to non ERC721Receiver implementer"
873         );
874     }
875 
876     /**
877      * @dev Mints `tokenId` and transfers it to `to`.
878      *
879      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
880      *
881      * Requirements:
882      *
883      * - `tokenId` must not exist.
884      * - `to` cannot be the zero address.
885      *
886      * Emits a {Transfer} event.
887      */
888     function _mint(address to, uint256 tokenId) internal virtual {
889         require(to != address(0), "ERC721: mint to the zero address");
890         require(!_exists(tokenId), "ERC721: token already minted");
891 
892         _beforeTokenTransfer(address(0), to, tokenId);
893 
894         _balances[to] += 1;
895         _owners[tokenId] = to;
896 
897         emit Transfer(address(0), to, tokenId);
898     }
899 
900     /**
901      * @dev Destroys `tokenId`.
902      * The approval is cleared when the token is burned.
903      *
904      * Requirements:
905      *
906      * - `tokenId` must exist.
907      *
908      * Emits a {Transfer} event.
909      */
910     function _burn(uint256 tokenId) internal virtual {
911         address owner = ERC721.ownerOf(tokenId);
912 
913         _beforeTokenTransfer(owner, address(0), tokenId);
914 
915         // Clear approvals
916         _approve(address(0), tokenId);
917 
918         _balances[owner] -= 1;
919         delete _owners[tokenId];
920 
921         emit Transfer(owner, address(0), tokenId);
922     }
923 
924     /**
925      * @dev Transfers `tokenId` from `from` to `to`.
926      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
927      *
928      * Requirements:
929      *
930      * - `to` cannot be the zero address.
931      * - `tokenId` token must be owned by `from`.
932      *
933      * Emits a {Transfer} event.
934      */
935     function _transfer(
936         address from,
937         address to,
938         uint256 tokenId
939     ) internal virtual {
940         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
941         require(to != address(0), "ERC721: transfer to the zero address");
942 
943         _beforeTokenTransfer(from, to, tokenId);
944 
945         // Clear approvals from the previous owner
946         _approve(address(0), tokenId);
947 
948         _balances[from] -= 1;
949         _balances[to] += 1;
950         _owners[tokenId] = to;
951 
952         emit Transfer(from, to, tokenId);
953     }
954 
955     /**
956      * @dev Approve `to` to operate on `tokenId`
957      *
958      * Emits a {Approval} event.
959      */
960     function _approve(address to, uint256 tokenId) internal virtual {
961         _tokenApprovals[tokenId] = to;
962         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
963     }
964 
965     /**
966      * @dev Approve `operator` to operate on all of `owner` tokens
967      *
968      * Emits a {ApprovalForAll} event.
969      */
970     function _setApprovalForAll(
971         address owner,
972         address operator,
973         bool approved
974     ) internal virtual {
975         require(owner != operator, "ERC721: approve to caller");
976         _operatorApprovals[owner][operator] = approved;
977         emit ApprovalForAll(owner, operator, approved);
978     }
979 
980     /**
981      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
982      * The call is not executed if the target address is not a contract.
983      *
984      * @param from address representing the previous owner of the given token ID
985      * @param to target address that will receive the tokens
986      * @param tokenId uint256 ID of the token to be transferred
987      * @param _data bytes optional data to send along with the call
988      * @return bool whether the call correctly returned the expected magic value
989      */
990     function _checkOnERC721Received(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) private returns (bool) {
996         if (to.isContract()) {
997             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
998                 return retval == IERC721Receiver.onERC721Received.selector;
999             } catch (bytes memory reason) {
1000                 if (reason.length == 0) {
1001                     revert("ERC721: transfer to non ERC721Receiver implementer");
1002                 } else {
1003                     assembly {
1004                         revert(add(32, reason), mload(reason))
1005                     }
1006                 }
1007             }
1008         } else {
1009             return true;
1010         }
1011     }
1012 
1013     /**
1014      * @dev Hook that is called before any token transfer. This includes minting
1015      * and burning.
1016      *
1017      * Calling conditions:
1018      *
1019      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1020      * transferred to `to`.
1021      * - When `from` is zero, `tokenId` will be minted for `to`.
1022      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1023      * - `from` and `to` are never both zero.
1024      *
1025      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1026      */
1027     function _beforeTokenTransfer(
1028         address from,
1029         address to,
1030         uint256 tokenId
1031     ) internal virtual {}
1032 }
1033 
1034 
1035 // File: @openzeppelin/contracts/access/Ownable.sol
1036 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
1037 pragma solidity ^0.8.0;
1038 
1039 /**
1040  * @dev Contract module which provides a basic access control mechanism, where
1041  * there is an account (an owner) that can be granted exclusive access to
1042  * specific functions.
1043  *
1044  * By default, the owner account will be the one that deploys the contract. This
1045  * can later be changed with {transferOwnership}.
1046  *
1047  * This module is used through inheritance. It will make available the modifier
1048  * `onlyOwner`, which can be applied to your functions to restrict their use to
1049  * the owner.
1050  */
1051 abstract contract Ownable is Context {
1052     address private _owner;
1053 
1054     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1055 
1056     /**
1057      * @dev Initializes the contract setting the deployer as the initial owner.
1058      */
1059     constructor() {
1060         _transferOwnership(_msgSender());
1061     }
1062 
1063     /**
1064      * @dev Returns the address of the current owner.
1065      */
1066     function owner() public view virtual returns (address) {
1067         return _owner;
1068     }
1069 
1070     /**
1071      * @dev Throws if called by any account other than the owner.
1072      */
1073     modifier onlyOwner() {
1074         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1075         _;
1076     }
1077 
1078     /**
1079      * @dev Leaves the contract without owner. It will not be possible to call
1080      * `onlyOwner` functions anymore. Can only be called by the current owner.
1081      *
1082      * NOTE: Renouncing ownership will leave the contract without an owner,
1083      * thereby removing any functionality that is only available to the owner.
1084      */
1085     function renounceOwnership() public virtual onlyOwner {
1086         _transferOwnership(address(0));
1087     }
1088 
1089     /**
1090      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1091      * Can only be called by the current owner.
1092      */
1093     function transferOwnership(address newOwner) public virtual onlyOwner {
1094         require(newOwner != address(0), "Ownable: new owner is the zero address");
1095         _transferOwnership(newOwner);
1096     }
1097 
1098     /**
1099      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1100      * Internal function without access restriction.
1101      */
1102     function _transferOwnership(address newOwner) internal virtual {
1103         address oldOwner = _owner;
1104         _owner = newOwner;
1105         emit OwnershipTransferred(oldOwner, newOwner);
1106     }
1107 }
1108 
1109 
1110 // File: contracts/Squadts.sol
1111 pragma solidity ^0.8.13;
1112 
1113 contract Squadts is ERC721, Ownable {
1114     using Strings for uint256;
1115 
1116     string private _baseTokenURI = "";
1117     bool public isMintAllowListActive = false;
1118     bool public isMintEarlyAccessActive = false;
1119     bool public isMintPublicActive = false;
1120     bool public isMintPublicGiveawayActive = false;
1121 
1122     uint256 constant TOKEN_IDS_STARTS_AT = 1;
1123     uint256 public constant TOTAL_TOKENS = 8888;
1124     uint256 public constant TOTAL_PRIVATE_TOKENS = 100;
1125     uint256 public constant TOTAL_PUBLIC_TOKENS = TOTAL_TOKENS - TOTAL_PRIVATE_TOKENS;
1126     uint256 public constant PRICE = 0.07 ether;
1127     uint256 public constant MINT_ALLOW_LIST_LIMIT = 5;
1128     uint256 public constant MINT_EARLY_ACCESS_LIMIT = 10;
1129     uint256 public constant MINT_PUBLIC_LIMIT = 10;
1130     uint256 public MINT_PUBLIC_GIVEAWAY_LIMIT = 1;
1131     uint256 public privateTokensCount = 0;
1132     uint256 public publicTokensCount = 0;
1133 
1134     bytes32 public merkleRoot = 0x5662aa1481ad8acf4d65287062577c5609832383d249827884a2183e5b3e2c32;
1135 
1136     mapping(address => bool) public earlyAccessContracts;
1137     mapping(address => bool) public giveawayAddresses;
1138     mapping(address => uint256) public allowListClaimed;
1139     mapping(address => uint256) public earlyAccessClaimed;
1140     mapping(address => uint256) public publicGiveawayClaimed;
1141 
1142     // add "baseURI" to our constructor
1143     constructor(
1144         string memory name,
1145         string memory symbol,
1146         string memory baseURI
1147     ) ERC721(name, symbol) {
1148         setBaseURI(baseURI);
1149         setEarlyAccessContract(0x0Ee24c748445Fb48028a74b0ccb6b46d7D3e3b33, true); // Nah Fungible Bones
1150         setEarlyAccessContract(0x6317C4CAB501655D7B85128A5868E98a094C0082, true); // MonsterBuds
1151     }
1152 
1153     // Getters & Setters
1154     function _baseURI() internal view virtual override returns (string memory) {
1155         return _baseTokenURI;
1156     }
1157     function setBaseURI(string memory value) public onlyOwner {
1158         _baseTokenURI = value;
1159     }
1160     function setMintAllowListActive(bool value) external onlyOwner {
1161         isMintAllowListActive = value;
1162     }
1163     function setMintEarlyAccessActive(bool value) external onlyOwner {
1164         isMintEarlyAccessActive = value;
1165     }
1166     function setMintPublicActive(bool value) external onlyOwner {
1167         isMintPublicActive = value;
1168     }
1169     function setMintPublicGiveawayActive(bool value) external onlyOwner {
1170         isMintPublicGiveawayActive = value;
1171     }
1172     function setMintPublicGiveawayLimit(uint256 value) external onlyOwner {
1173         MINT_PUBLIC_GIVEAWAY_LIMIT = value;
1174     }
1175     function setEarlyAccessContract(address contractAddress, bool value) public onlyOwner {
1176         earlyAccessContracts[contractAddress] = value;
1177     }
1178     function setGiveawayAddress(address giveawayAddress, bool value) public onlyOwner {
1179         giveawayAddresses[giveawayAddress] = value;
1180     }
1181     function getPrice(uint256 amount) public pure returns (uint256) {
1182         return PRICE * amount;
1183     }
1184     function totalSupply() public view returns (uint256) {
1185         return privateTokensCount + publicTokensCount;
1186     }
1187 
1188     // Minting
1189     function mint(uint256 amount) external payable {
1190         require(isMintPublicActive, "Public minting is inactive");
1191         require(amount > 0, "Need to mint at least one token");
1192         require(amount <= MINT_PUBLIC_LIMIT, "Over mint limit");
1193         uint256 supply = totalSupply();
1194         require(supply < TOTAL_TOKENS, "All tokens minted");
1195         require(supply + amount <= TOTAL_TOKENS, "Over total tokens");
1196         require(publicTokensCount < TOTAL_PUBLIC_TOKENS, "All public tokens minted");
1197         require(publicTokensCount + amount <= TOTAL_PUBLIC_TOKENS, "Over total public tokens");
1198         require(msg.value >= getPrice(amount), "Value is below price");
1199         for (uint256 i = 0; i < amount; i++) {
1200             publicTokensCount += 1;
1201             _safeMint(msg.sender, TOKEN_IDS_STARTS_AT + supply + i);
1202         }
1203     }
1204     function mintAllowList(uint256 amount, bytes32[] calldata merkleProof) external payable {
1205         require(isMintAllowListActive, "Allow list is inactive");
1206 
1207         bytes32 merkleLeaf = keccak256(abi.encodePacked(msg.sender));
1208         require(MerkleProof.verify(merkleProof, merkleRoot, merkleLeaf), "Address is not on the allow list list");
1209 
1210         require(amount > 0, "Need to mint at least one token");
1211         require(amount <= MINT_ALLOW_LIST_LIMIT, "Over allow list mint limit");
1212         require(allowListClaimed[msg.sender] + amount <= MINT_ALLOW_LIST_LIMIT, "Over allow list limit");
1213         uint256 supply = totalSupply();
1214         require(supply < TOTAL_TOKENS, "All tokens minted");
1215         require(supply + amount <= TOTAL_TOKENS, "Over total tokens");
1216         require(publicTokensCount < TOTAL_PUBLIC_TOKENS, "All public tokens minted");
1217         require(publicTokensCount + amount <= TOTAL_PUBLIC_TOKENS, "Over total public tokens");
1218         require(msg.value >= getPrice(amount), "Value is below price");
1219         for (uint256 i = 0; i < amount; i++) {
1220             publicTokensCount += 1;
1221             allowListClaimed[msg.sender] += 1;
1222             _safeMint(msg.sender, TOKEN_IDS_STARTS_AT + supply + i);
1223         }
1224     }
1225     function mintEarlyAccess(address contractAddress, uint256 amount) external payable {
1226         require(isMintEarlyAccessActive, "Early access is inactive");
1227         require(earlyAccessContracts[contractAddress], "Invalid contract address");
1228         require(ERC721(contractAddress).balanceOf(msg.sender) > 0, "Wallet is missing token");
1229         require(amount > 0, "Need to mint at least one token");
1230         require(amount <= MINT_EARLY_ACCESS_LIMIT, "Over early access mint limit");
1231         require(earlyAccessClaimed[msg.sender] + amount <= MINT_EARLY_ACCESS_LIMIT, "Over early access limit");
1232         uint256 supply = totalSupply();
1233         require(supply < TOTAL_TOKENS, "All tokens minted");
1234         require(supply + amount <= TOTAL_TOKENS, "Over total tokens");
1235         require(publicTokensCount < TOTAL_PUBLIC_TOKENS, "All public tokens minted");
1236         require(publicTokensCount + amount <= TOTAL_PUBLIC_TOKENS, "Over total public tokens");
1237         require(msg.value >= getPrice(amount), "Value is below price");
1238         for (uint256 i = 0; i < amount; i++) {
1239             publicTokensCount += 1;
1240             earlyAccessClaimed[msg.sender] += 1;
1241             _safeMint(msg.sender, TOKEN_IDS_STARTS_AT + supply + i);
1242         }
1243     }
1244     function mintPublicGiveaway(uint256 amount) external payable {
1245         require(isMintPublicGiveawayActive, "Public giveaway is inactive");
1246         require(balanceOf(msg.sender) > 0, "Wallet is missing token");
1247         require(amount > 0, "Need to mint at least one token");
1248         require(amount <= MINT_PUBLIC_GIVEAWAY_LIMIT, "Over public giveaway mint limit");
1249         require(publicGiveawayClaimed[msg.sender] + amount <= MINT_PUBLIC_GIVEAWAY_LIMIT, "Over public giveaway limit");
1250         uint256 supply = totalSupply();
1251         require(supply < TOTAL_TOKENS, "All tokens minted");
1252         require(supply + amount <= TOTAL_TOKENS, "Over total tokens");
1253         require(publicTokensCount < TOTAL_PUBLIC_TOKENS, "All public tokens minted");
1254         require(publicTokensCount + amount <= TOTAL_PUBLIC_TOKENS, "Over total public tokens");
1255         for (uint256 i = 0; i < amount; i++) {
1256             publicTokensCount += 1;
1257             publicGiveawayClaimed[msg.sender] += 1;
1258             _safeMint(msg.sender, TOKEN_IDS_STARTS_AT + supply + i);
1259         }
1260     }
1261     function mintGiveaway() external payable {
1262         require(giveawayAddresses[msg.sender], "Address is not on the giveaway list");
1263         uint256 supply = totalSupply();
1264         require(supply < TOTAL_TOKENS, "All tokens minted");
1265         require(supply + 1 <= TOTAL_TOKENS, "Over total tokens");
1266         require(privateTokensCount < TOTAL_PRIVATE_TOKENS, "All private tokens minted");
1267         require(privateTokensCount + 1 <= TOTAL_PRIVATE_TOKENS, "Over total private tokens");
1268         privateTokensCount += 1;
1269         giveawayAddresses[msg.sender] = false;
1270         _safeMint(msg.sender, TOKEN_IDS_STARTS_AT + supply);
1271     }
1272     function gift(address to, uint256 amount) external onlyOwner {
1273         require(amount > 0, "Need to mint at least one token");
1274         uint256 supply = totalSupply();
1275         require(supply < TOTAL_TOKENS, "All tokens minted");
1276         require(supply + amount <= TOTAL_TOKENS, "Over total tokens");
1277         require(privateTokensCount < TOTAL_PRIVATE_TOKENS, "All private tokens minted");
1278         require(privateTokensCount + amount <= TOTAL_PRIVATE_TOKENS, "Over total private tokens");
1279         for (uint256 i = 0; i < amount; i++) {
1280             privateTokensCount += 1;
1281             _safeMint(to, TOKEN_IDS_STARTS_AT + supply + i);
1282         }
1283     }
1284 
1285     // Withdraw
1286     function withdraw() external payable onlyOwner {
1287         uint256 balance = address(this).balance;
1288         (bool success, ) = payable(msg.sender).call{value: balance}("");
1289         require(success, "Transfer failed");
1290     }
1291 
1292 }