1 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.5.0
2 
3 // SPDX-License-Identifier: MIT
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
5 
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
40     function processProof(bytes32[] memory proof, bytes32 leaf)
41         internal
42         pure
43         returns (bytes32)
44     {
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
59     function _efficientHash(bytes32 a, bytes32 b)
60         private
61         pure
62         returns (bytes32 value)
63     {
64         assembly {
65             mstore(0x00, a)
66             mstore(0x20, b)
67             value := keccak256(0x00, 0x40)
68         }
69     }
70 }
71 
72 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
73 
74 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
75 
76 pragma solidity ^0.8.0;
77 
78 /**
79  * @dev Interface of the ERC165 standard, as defined in the
80  * https://eips.ethereum.org/EIPS/eip-165[EIP].
81  *
82  * Implementers can declare support of contract interfaces, which can then be
83  * queried by others ({ERC165Checker}).
84  *
85  * For an implementation, see {ERC165}.
86  */
87 interface IERC165 {
88     /**
89      * @dev Returns true if this contract implements the interface defined by
90      * `interfaceId`. See the corresponding
91      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
92      * to learn more about how these ids are created.
93      *
94      * This function call must use less than 30 000 gas.
95      */
96     function supportsInterface(bytes4 interfaceId) external view returns (bool);
97 }
98 
99 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
100 
101 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
102 
103 pragma solidity ^0.8.0;
104 
105 /**
106  * @dev Required interface of an ERC721 compliant contract.
107  */
108 interface IERC721 is IERC165 {
109     /**
110      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
111      */
112     event Transfer(
113         address indexed from,
114         address indexed to,
115         uint256 indexed tokenId
116     );
117 
118     /**
119      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
120      */
121     event Approval(
122         address indexed owner,
123         address indexed approved,
124         uint256 indexed tokenId
125     );
126 
127     /**
128      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
129      */
130     event ApprovalForAll(
131         address indexed owner,
132         address indexed operator,
133         bool approved
134     );
135 
136     /**
137      * @dev Returns the number of tokens in ``owner``'s account.
138      */
139     function balanceOf(address owner) external view returns (uint256 balance);
140 
141     /**
142      * @dev Returns the owner of the `tokenId` token.
143      *
144      * Requirements:
145      *
146      * - `tokenId` must exist.
147      */
148     function ownerOf(uint256 tokenId) external view returns (address owner);
149 
150     /**
151      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
152      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
153      *
154      * Requirements:
155      *
156      * - `from` cannot be the zero address.
157      * - `to` cannot be the zero address.
158      * - `tokenId` token must exist and be owned by `from`.
159      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
161      *
162      * Emits a {Transfer} event.
163      */
164     function safeTransferFrom(
165         address from,
166         address to,
167         uint256 tokenId
168     ) external;
169 
170     /**
171      * @dev Transfers `tokenId` token from `from` to `to`.
172      *
173      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
174      *
175      * Requirements:
176      *
177      * - `from` cannot be the zero address.
178      * - `to` cannot be the zero address.
179      * - `tokenId` token must be owned by `from`.
180      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transferFrom(
185         address from,
186         address to,
187         uint256 tokenId
188     ) external;
189 
190     /**
191      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
192      * The approval is cleared when the token is transferred.
193      *
194      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
195      *
196      * Requirements:
197      *
198      * - The caller must own the token or be an approved operator.
199      * - `tokenId` must exist.
200      *
201      * Emits an {Approval} event.
202      */
203     function approve(address to, uint256 tokenId) external;
204 
205     /**
206      * @dev Returns the account approved for `tokenId` token.
207      *
208      * Requirements:
209      *
210      * - `tokenId` must exist.
211      */
212     function getApproved(uint256 tokenId)
213         external
214         view
215         returns (address operator);
216 
217     /**
218      * @dev Approve or remove `operator` as an operator for the caller.
219      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
220      *
221      * Requirements:
222      *
223      * - The `operator` cannot be the caller.
224      *
225      * Emits an {ApprovalForAll} event.
226      */
227     function setApprovalForAll(address operator, bool _approved) external;
228 
229     /**
230      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
231      *
232      * See {setApprovalForAll}
233      */
234     function isApprovedForAll(address owner, address operator)
235         external
236         view
237         returns (bool);
238 
239     /**
240      * @dev Safely transfers `tokenId` token from `from` to `to`.
241      *
242      * Requirements:
243      *
244      * - `from` cannot be the zero address.
245      * - `to` cannot be the zero address.
246      * - `tokenId` token must exist and be owned by `from`.
247      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
248      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
249      *
250      * Emits a {Transfer} event.
251      */
252     function safeTransferFrom(
253         address from,
254         address to,
255         uint256 tokenId,
256         bytes calldata data
257     ) external;
258 }
259 
260 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
261 
262 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @title ERC721 token receiver interface
268  * @dev Interface for any contract that wants to support safeTransfers
269  * from ERC721 asset contracts.
270  */
271 interface IERC721Receiver {
272     /**
273      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
274      * by `operator` from `from`, this function is called.
275      *
276      * It must return its Solidity selector to confirm the token transfer.
277      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
278      *
279      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
280      */
281     function onERC721Received(
282         address operator,
283         address from,
284         uint256 tokenId,
285         bytes calldata data
286     ) external returns (bytes4);
287 }
288 
289 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
290 
291 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
292 
293 pragma solidity ^0.8.0;
294 
295 /**
296  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
297  * @dev See https://eips.ethereum.org/EIPS/eip-721
298  */
299 interface IERC721Metadata is IERC721 {
300     /**
301      * @dev Returns the token collection name.
302      */
303     function name() external view returns (string memory);
304 
305     /**
306      * @dev Returns the token collection symbol.
307      */
308     function symbol() external view returns (string memory);
309 
310     /**
311      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
312      */
313     function tokenURI(uint256 tokenId) external view returns (string memory);
314 }
315 
316 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
317 
318 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
319 
320 pragma solidity ^0.8.1;
321 
322 /**
323  * @dev Collection of functions related to the address type
324  */
325 library Address {
326     /**
327      * @dev Returns true if `account` is a contract.
328      *
329      * [IMPORTANT]
330      * ====
331      * It is unsafe to assume that an address for which this function returns
332      * false is an externally-owned account (EOA) and not a contract.
333      *
334      * Among others, `isContract` will return false for the following
335      * types of addresses:
336      *
337      *  - an externally-owned account
338      *  - a contract in construction
339      *  - an address where a contract will be created
340      *  - an address where a contract lived, but was destroyed
341      * ====
342      *
343      * [IMPORTANT]
344      * ====
345      * You shouldn't rely on `isContract` to protect against flash loan attacks!
346      *
347      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
348      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
349      * constructor.
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize/address.code.length, which returns 0
354         // for contracts in construction, since the code is only stored at the end
355         // of the constructor execution.
356 
357         return account.code.length > 0;
358     }
359 
360     /**
361      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
362      * `recipient`, forwarding all available gas and reverting on errors.
363      *
364      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
365      * of certain opcodes, possibly making contracts go over the 2300 gas limit
366      * imposed by `transfer`, making them unable to receive funds via
367      * `transfer`. {sendValue} removes this limitation.
368      *
369      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
370      *
371      * IMPORTANT: because control is transferred to `recipient`, care must be
372      * taken to not create reentrancy vulnerabilities. Consider using
373      * {ReentrancyGuard} or the
374      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
375      */
376     function sendValue(address payable recipient, uint256 amount) internal {
377         require(
378             address(this).balance >= amount,
379             "Address: insufficient balance"
380         );
381 
382         (bool success, ) = recipient.call{value: amount}("");
383         require(
384             success,
385             "Address: unable to send value, recipient may have reverted"
386         );
387     }
388 
389     /**
390      * @dev Performs a Solidity function call using a low level `call`. A
391      * plain `call` is an unsafe replacement for a function call: use this
392      * function instead.
393      *
394      * If `target` reverts with a revert reason, it is bubbled up by this
395      * function (like regular Solidity function calls).
396      *
397      * Returns the raw returned data. To convert to the expected return value,
398      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
399      *
400      * Requirements:
401      *
402      * - `target` must be a contract.
403      * - calling `target` with `data` must not revert.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data)
408         internal
409         returns (bytes memory)
410     {
411         return functionCall(target, data, "Address: low-level call failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
416      * `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(
421         address target,
422         bytes memory data,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         return functionCallWithValue(target, data, 0, errorMessage);
426     }
427 
428     /**
429      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
430      * but also transferring `value` wei to `target`.
431      *
432      * Requirements:
433      *
434      * - the calling contract must have an ETH balance of at least `value`.
435      * - the called Solidity function must be `payable`.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(
440         address target,
441         bytes memory data,
442         uint256 value
443     ) internal returns (bytes memory) {
444         return
445             functionCallWithValue(
446                 target,
447                 data,
448                 value,
449                 "Address: low-level call with value failed"
450             );
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
455      * with `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         require(
466             address(this).balance >= value,
467             "Address: insufficient balance for call"
468         );
469         require(isContract(target), "Address: call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.call{value: value}(
472             data
473         );
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but performing a static call.
480      *
481      * _Available since v3.3._
482      */
483     function functionStaticCall(address target, bytes memory data)
484         internal
485         view
486         returns (bytes memory)
487     {
488         return
489             functionStaticCall(
490                 target,
491                 data,
492                 "Address: low-level static call failed"
493             );
494     }
495 
496     /**
497      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
498      * but performing a static call.
499      *
500      * _Available since v3.3._
501      */
502     function functionStaticCall(
503         address target,
504         bytes memory data,
505         string memory errorMessage
506     ) internal view returns (bytes memory) {
507         require(isContract(target), "Address: static call to non-contract");
508 
509         (bool success, bytes memory returndata) = target.staticcall(data);
510         return verifyCallResult(success, returndata, errorMessage);
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
515      * but performing a delegate call.
516      *
517      * _Available since v3.4._
518      */
519     function functionDelegateCall(address target, bytes memory data)
520         internal
521         returns (bytes memory)
522     {
523         return
524             functionDelegateCall(
525                 target,
526                 data,
527                 "Address: low-level delegate call failed"
528             );
529     }
530 
531     /**
532      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
533      * but performing a delegate call.
534      *
535      * _Available since v3.4._
536      */
537     function functionDelegateCall(
538         address target,
539         bytes memory data,
540         string memory errorMessage
541     ) internal returns (bytes memory) {
542         require(isContract(target), "Address: delegate call to non-contract");
543 
544         (bool success, bytes memory returndata) = target.delegatecall(data);
545         return verifyCallResult(success, returndata, errorMessage);
546     }
547 
548     /**
549      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
550      * revert reason using the provided one.
551      *
552      * _Available since v4.3._
553      */
554     function verifyCallResult(
555         bool success,
556         bytes memory returndata,
557         string memory errorMessage
558     ) internal pure returns (bytes memory) {
559         if (success) {
560             return returndata;
561         } else {
562             // Look for revert reason and bubble it up if present
563             if (returndata.length > 0) {
564                 // The easiest way to bubble the revert reason is using memory via assembly
565 
566                 assembly {
567                     let returndata_size := mload(returndata)
568                     revert(add(32, returndata), returndata_size)
569                 }
570             } else {
571                 revert(errorMessage);
572             }
573         }
574     }
575 }
576 
577 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
578 
579 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
580 
581 pragma solidity ^0.8.0;
582 
583 /**
584  * @dev Provides information about the current execution context, including the
585  * sender of the transaction and its data. While these are generally available
586  * via msg.sender and msg.data, they should not be accessed in such a direct
587  * manner, since when dealing with meta-transactions the account sending and
588  * paying for execution may not be the actual sender (as far as an application
589  * is concerned).
590  *
591  * This contract is only required for intermediate, library-like contracts.
592  */
593 abstract contract Context {
594     function _msgSender() internal view virtual returns (address) {
595         return msg.sender;
596     }
597 
598     function _msgData() internal view virtual returns (bytes calldata) {
599         return msg.data;
600     }
601 }
602 
603 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
604 
605 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 /**
610  * @dev String operations.
611  */
612 library Strings {
613     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
614 
615     /**
616      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
617      */
618     function toString(uint256 value) internal pure returns (string memory) {
619         // Inspired by OraclizeAPI's implementation - MIT licence
620         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
621 
622         if (value == 0) {
623             return "0";
624         }
625         uint256 temp = value;
626         uint256 digits;
627         while (temp != 0) {
628             digits++;
629             temp /= 10;
630         }
631         bytes memory buffer = new bytes(digits);
632         while (value != 0) {
633             digits -= 1;
634             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
635             value /= 10;
636         }
637         return string(buffer);
638     }
639 
640     /**
641      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
642      */
643     function toHexString(uint256 value) internal pure returns (string memory) {
644         if (value == 0) {
645             return "0x00";
646         }
647         uint256 temp = value;
648         uint256 length = 0;
649         while (temp != 0) {
650             length++;
651             temp >>= 8;
652         }
653         return toHexString(value, length);
654     }
655 
656     /**
657      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
658      */
659     function toHexString(uint256 value, uint256 length)
660         internal
661         pure
662         returns (string memory)
663     {
664         bytes memory buffer = new bytes(2 * length + 2);
665         buffer[0] = "0";
666         buffer[1] = "x";
667         for (uint256 i = 2 * length + 1; i > 1; --i) {
668             buffer[i] = _HEX_SYMBOLS[value & 0xf];
669             value >>= 4;
670         }
671         require(value == 0, "Strings: hex length insufficient");
672         return string(buffer);
673     }
674 }
675 
676 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
677 
678 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
679 
680 pragma solidity ^0.8.0;
681 
682 /**
683  * @dev Implementation of the {IERC165} interface.
684  *
685  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
686  * for the additional interface id that will be supported. For example:
687  *
688  * ```solidity
689  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
690  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
691  * }
692  * ```
693  *
694  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
695  */
696 abstract contract ERC165 is IERC165 {
697     /**
698      * @dev See {IERC165-supportsInterface}.
699      */
700     function supportsInterface(bytes4 interfaceId)
701         public
702         view
703         virtual
704         override
705         returns (bool)
706     {
707         return interfaceId == type(IERC165).interfaceId;
708     }
709 }
710 
711 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
712 
713 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
714 
715 pragma solidity ^0.8.0;
716 
717 /**
718  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
719  * the Metadata extension, but not including the Enumerable extension, which is available separately as
720  * {ERC721Enumerable}.
721  */
722 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
723     using Address for address;
724     using Strings for uint256;
725 
726     // Token name
727     string private _name;
728 
729     // Token symbol
730     string private _symbol;
731 
732     // Mapping from token ID to owner address
733     mapping(uint256 => address) private _owners;
734 
735     // Mapping owner address to token count
736     mapping(address => uint256) private _balances;
737 
738     // Mapping from token ID to approved address
739     mapping(uint256 => address) private _tokenApprovals;
740 
741     // Mapping from owner to operator approvals
742     mapping(address => mapping(address => bool)) private _operatorApprovals;
743 
744     /**
745      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
746      */
747     constructor(string memory name_, string memory symbol_) {
748         _name = name_;
749         _symbol = symbol_;
750     }
751 
752     /**
753      * @dev See {IERC165-supportsInterface}.
754      */
755     function supportsInterface(bytes4 interfaceId)
756         public
757         view
758         virtual
759         override(ERC165, IERC165)
760         returns (bool)
761     {
762         return
763             interfaceId == type(IERC721).interfaceId ||
764             interfaceId == type(IERC721Metadata).interfaceId ||
765             super.supportsInterface(interfaceId);
766     }
767 
768     /**
769      * @dev See {IERC721-balanceOf}.
770      */
771     function balanceOf(address owner)
772         public
773         view
774         virtual
775         override
776         returns (uint256)
777     {
778         require(
779             owner != address(0),
780             "ERC721: balance query for the zero address"
781         );
782         return _balances[owner];
783     }
784 
785     /**
786      * @dev See {IERC721-ownerOf}.
787      */
788     function ownerOf(uint256 tokenId)
789         public
790         view
791         virtual
792         override
793         returns (address)
794     {
795         address owner = _owners[tokenId];
796         require(
797             owner != address(0),
798             "ERC721: owner query for nonexistent token"
799         );
800         return owner;
801     }
802 
803     /**
804      * @dev See {IERC721Metadata-name}.
805      */
806     function name() public view virtual override returns (string memory) {
807         return _name;
808     }
809 
810     /**
811      * @dev See {IERC721Metadata-symbol}.
812      */
813     function symbol() public view virtual override returns (string memory) {
814         return _symbol;
815     }
816 
817     /**
818      * @dev See {IERC721Metadata-tokenURI}.
819      */
820     function tokenURI(uint256 tokenId)
821         public
822         view
823         virtual
824         override
825         returns (string memory)
826     {
827         require(
828             _exists(tokenId),
829             "ERC721Metadata: URI query for nonexistent token"
830         );
831 
832         string memory baseURI = _baseURI();
833         return
834             bytes(baseURI).length > 0
835                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
836                 : "";
837     }
838 
839     /**
840      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
841      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
842      * by default, can be overriden in child contracts.
843      */
844     function _baseURI() internal view virtual returns (string memory) {
845         return "";
846     }
847 
848     /**
849      * @dev See {IERC721-approve}.
850      */
851     function approve(address to, uint256 tokenId) public virtual override {
852         address owner = ERC721.ownerOf(tokenId);
853         require(to != owner, "ERC721: approval to current owner");
854 
855         require(
856             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
857             "ERC721: approve caller is not owner nor approved for all"
858         );
859 
860         _approve(to, tokenId);
861     }
862 
863     /**
864      * @dev See {IERC721-getApproved}.
865      */
866     function getApproved(uint256 tokenId)
867         public
868         view
869         virtual
870         override
871         returns (address)
872     {
873         require(
874             _exists(tokenId),
875             "ERC721: approved query for nonexistent token"
876         );
877 
878         return _tokenApprovals[tokenId];
879     }
880 
881     /**
882      * @dev See {IERC721-setApprovalForAll}.
883      */
884     function setApprovalForAll(address operator, bool approved)
885         public
886         virtual
887         override
888     {
889         _setApprovalForAll(_msgSender(), operator, approved);
890     }
891 
892     /**
893      * @dev See {IERC721-isApprovedForAll}.
894      */
895     function isApprovedForAll(address owner, address operator)
896         public
897         view
898         virtual
899         override
900         returns (bool)
901     {
902         return _operatorApprovals[owner][operator];
903     }
904 
905     /**
906      * @dev See {IERC721-transferFrom}.
907      */
908     function transferFrom(
909         address from,
910         address to,
911         uint256 tokenId
912     ) public virtual override {
913         //solhint-disable-next-line max-line-length
914         require(
915             _isApprovedOrOwner(_msgSender(), tokenId),
916             "ERC721: transfer caller is not owner nor approved"
917         );
918 
919         _transfer(from, to, tokenId);
920     }
921 
922     /**
923      * @dev See {IERC721-safeTransferFrom}.
924      */
925     function safeTransferFrom(
926         address from,
927         address to,
928         uint256 tokenId
929     ) public virtual override {
930         safeTransferFrom(from, to, tokenId, "");
931     }
932 
933     /**
934      * @dev See {IERC721-safeTransferFrom}.
935      */
936     function safeTransferFrom(
937         address from,
938         address to,
939         uint256 tokenId,
940         bytes memory _data
941     ) public virtual override {
942         require(
943             _isApprovedOrOwner(_msgSender(), tokenId),
944             "ERC721: transfer caller is not owner nor approved"
945         );
946         _safeTransfer(from, to, tokenId, _data);
947     }
948 
949     /**
950      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
951      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
952      *
953      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
954      *
955      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
956      * implement alternative mechanisms to perform token transfer, such as signature-based.
957      *
958      * Requirements:
959      *
960      * - `from` cannot be the zero address.
961      * - `to` cannot be the zero address.
962      * - `tokenId` token must exist and be owned by `from`.
963      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _safeTransfer(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) internal virtual {
973         _transfer(from, to, tokenId);
974         require(
975             _checkOnERC721Received(from, to, tokenId, _data),
976             "ERC721: transfer to non ERC721Receiver implementer"
977         );
978     }
979 
980     /**
981      * @dev Returns whether `tokenId` exists.
982      *
983      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
984      *
985      * Tokens start existing when they are minted (`_mint`),
986      * and stop existing when they are burned (`_burn`).
987      */
988     function _exists(uint256 tokenId) internal view virtual returns (bool) {
989         return _owners[tokenId] != address(0);
990     }
991 
992     /**
993      * @dev Returns whether `spender` is allowed to manage `tokenId`.
994      *
995      * Requirements:
996      *
997      * - `tokenId` must exist.
998      */
999     function _isApprovedOrOwner(address spender, uint256 tokenId)
1000         internal
1001         view
1002         virtual
1003         returns (bool)
1004     {
1005         require(
1006             _exists(tokenId),
1007             "ERC721: operator query for nonexistent token"
1008         );
1009         address owner = ERC721.ownerOf(tokenId);
1010         return (spender == owner ||
1011             getApproved(tokenId) == spender ||
1012             isApprovedForAll(owner, spender));
1013     }
1014 
1015     /**
1016      * @dev Safely mints `tokenId` and transfers it to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must not exist.
1021      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _safeMint(address to, uint256 tokenId) internal virtual {
1026         _safeMint(to, tokenId, "");
1027     }
1028 
1029     /**
1030      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1031      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1032      */
1033     function _safeMint(
1034         address to,
1035         uint256 tokenId,
1036         bytes memory _data
1037     ) internal virtual {
1038         _mint(to, tokenId);
1039         require(
1040             _checkOnERC721Received(address(0), to, tokenId, _data),
1041             "ERC721: transfer to non ERC721Receiver implementer"
1042         );
1043     }
1044 
1045     /**
1046      * @dev Mints `tokenId` and transfers it to `to`.
1047      *
1048      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1049      *
1050      * Requirements:
1051      *
1052      * - `tokenId` must not exist.
1053      * - `to` cannot be the zero address.
1054      *
1055      * Emits a {Transfer} event.
1056      */
1057     function _mint(address to, uint256 tokenId) internal virtual {
1058         require(to != address(0), "ERC721: mint to the zero address");
1059         require(!_exists(tokenId), "ERC721: token already minted");
1060 
1061         _beforeTokenTransfer(address(0), to, tokenId);
1062 
1063         _balances[to] += 1;
1064         _owners[tokenId] = to;
1065 
1066         emit Transfer(address(0), to, tokenId);
1067 
1068         _afterTokenTransfer(address(0), to, tokenId);
1069     }
1070 
1071     /**
1072      * @dev Destroys `tokenId`.
1073      * The approval is cleared when the token is burned.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _burn(uint256 tokenId) internal virtual {
1082         address owner = ERC721.ownerOf(tokenId);
1083 
1084         _beforeTokenTransfer(owner, address(0), tokenId);
1085 
1086         // Clear approvals
1087         _approve(address(0), tokenId);
1088 
1089         _balances[owner] -= 1;
1090         delete _owners[tokenId];
1091 
1092         emit Transfer(owner, address(0), tokenId);
1093 
1094         _afterTokenTransfer(owner, address(0), tokenId);
1095     }
1096 
1097     /**
1098      * @dev Transfers `tokenId` from `from` to `to`.
1099      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1100      *
1101      * Requirements:
1102      *
1103      * - `to` cannot be the zero address.
1104      * - `tokenId` token must be owned by `from`.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _transfer(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) internal virtual {
1113         require(
1114             ERC721.ownerOf(tokenId) == from,
1115             "ERC721: transfer from incorrect owner"
1116         );
1117         require(to != address(0), "ERC721: transfer to the zero address");
1118 
1119         _beforeTokenTransfer(from, to, tokenId);
1120 
1121         // Clear approvals from the previous owner
1122         _approve(address(0), tokenId);
1123 
1124         _balances[from] -= 1;
1125         _balances[to] += 1;
1126         _owners[tokenId] = to;
1127 
1128         emit Transfer(from, to, tokenId);
1129 
1130         _afterTokenTransfer(from, to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev Approve `to` to operate on `tokenId`
1135      *
1136      * Emits a {Approval} event.
1137      */
1138     function _approve(address to, uint256 tokenId) internal virtual {
1139         _tokenApprovals[tokenId] = to;
1140         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1141     }
1142 
1143     /**
1144      * @dev Approve `operator` to operate on all of `owner` tokens
1145      *
1146      * Emits a {ApprovalForAll} event.
1147      */
1148     function _setApprovalForAll(
1149         address owner,
1150         address operator,
1151         bool approved
1152     ) internal virtual {
1153         require(owner != operator, "ERC721: approve to caller");
1154         _operatorApprovals[owner][operator] = approved;
1155         emit ApprovalForAll(owner, operator, approved);
1156     }
1157 
1158     /**
1159      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1160      * The call is not executed if the target address is not a contract.
1161      *
1162      * @param from address representing the previous owner of the given token ID
1163      * @param to target address that will receive the tokens
1164      * @param tokenId uint256 ID of the token to be transferred
1165      * @param _data bytes optional data to send along with the call
1166      * @return bool whether the call correctly returned the expected magic value
1167      */
1168     function _checkOnERC721Received(
1169         address from,
1170         address to,
1171         uint256 tokenId,
1172         bytes memory _data
1173     ) private returns (bool) {
1174         if (to.isContract()) {
1175             try
1176                 IERC721Receiver(to).onERC721Received(
1177                     _msgSender(),
1178                     from,
1179                     tokenId,
1180                     _data
1181                 )
1182             returns (bytes4 retval) {
1183                 return retval == IERC721Receiver.onERC721Received.selector;
1184             } catch (bytes memory reason) {
1185                 if (reason.length == 0) {
1186                     revert(
1187                         "ERC721: transfer to non ERC721Receiver implementer"
1188                     );
1189                 } else {
1190                     assembly {
1191                         revert(add(32, reason), mload(reason))
1192                     }
1193                 }
1194             }
1195         } else {
1196             return true;
1197         }
1198     }
1199 
1200     /**
1201      * @dev Hook that is called before any token transfer. This includes minting
1202      * and burning.
1203      *
1204      * Calling conditions:
1205      *
1206      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1207      * transferred to `to`.
1208      * - When `from` is zero, `tokenId` will be minted for `to`.
1209      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1210      * - `from` and `to` are never both zero.
1211      *
1212      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1213      */
1214     function _beforeTokenTransfer(
1215         address from,
1216         address to,
1217         uint256 tokenId
1218     ) internal virtual {}
1219 
1220     /**
1221      * @dev Hook that is called after any transfer of tokens. This includes
1222      * minting and burning.
1223      *
1224      * Calling conditions:
1225      *
1226      * - when `from` and `to` are both non-zero.
1227      * - `from` and `to` are never both zero.
1228      *
1229      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1230      */
1231     function _afterTokenTransfer(
1232         address from,
1233         address to,
1234         uint256 tokenId
1235     ) internal virtual {}
1236 }
1237 
1238 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.5.0
1239 
1240 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1241 
1242 pragma solidity ^0.8.0;
1243 
1244 /**
1245  * @title ERC721 Burnable Token
1246  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1247  */
1248 abstract contract ERC721Burnable is Context, ERC721 {
1249     /**
1250      * @dev Burns `tokenId`. See {ERC721-_burn}.
1251      *
1252      * Requirements:
1253      *
1254      * - The caller must own `tokenId` or be an approved operator.
1255      */
1256     function burn(uint256 tokenId) public virtual {
1257         //solhint-disable-next-line max-line-length
1258         require(
1259             _isApprovedOrOwner(_msgSender(), tokenId),
1260             "ERC721Burnable: caller is not owner nor approved"
1261         );
1262         _burn(tokenId);
1263     }
1264 }
1265 
1266 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
1267 
1268 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1269 
1270 pragma solidity ^0.8.0;
1271 
1272 /**
1273  * @dev Contract module which provides a basic access control mechanism, where
1274  * there is an account (an owner) that can be granted exclusive access to
1275  * specific functions.
1276  *
1277  * By default, the owner account will be the one that deploys the contract. This
1278  * can later be changed with {transferOwnership}.
1279  *
1280  * This module is used through inheritance. It will make available the modifier
1281  * `onlyOwner`, which can be applied to your functions to restrict their use to
1282  * the owner.
1283  */
1284 abstract contract Ownable is Context {
1285     address private _owner;
1286 
1287     event OwnershipTransferred(
1288         address indexed previousOwner,
1289         address indexed newOwner
1290     );
1291 
1292     /**
1293      * @dev Initializes the contract setting the deployer as the initial owner.
1294      */
1295     constructor() {
1296         _transferOwnership(_msgSender());
1297     }
1298 
1299     /**
1300      * @dev Returns the address of the current owner.
1301      */
1302     function owner() public view virtual returns (address) {
1303         return _owner;
1304     }
1305 
1306     /**
1307      * @dev Throws if called by any account other than the owner.
1308      */
1309     modifier onlyOwner() {
1310         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1311         _;
1312     }
1313 
1314     /**
1315      * @dev Leaves the contract without owner. It will not be possible to call
1316      * `onlyOwner` functions anymore. Can only be called by the current owner.
1317      *
1318      * NOTE: Renouncing ownership will leave the contract without an owner,
1319      * thereby removing any functionality that is only available to the owner.
1320      */
1321     function renounceOwnership() public virtual onlyOwner {
1322         _transferOwnership(address(0));
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      * Can only be called by the current owner.
1328      */
1329     function transferOwnership(address newOwner) public virtual onlyOwner {
1330         require(
1331             newOwner != address(0),
1332             "Ownable: new owner is the zero address"
1333         );
1334         _transferOwnership(newOwner);
1335     }
1336 
1337     /**
1338      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1339      * Internal function without access restriction.
1340      */
1341     function _transferOwnership(address newOwner) internal virtual {
1342         address oldOwner = _owner;
1343         _owner = newOwner;
1344         emit OwnershipTransferred(oldOwner, newOwner);
1345     }
1346 }
1347 
1348 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.5.0
1349 
1350 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
1351 
1352 pragma solidity ^0.8.0;
1353 
1354 /**
1355  * @dev External interface of AccessControl declared to support ERC165 detection.
1356  */
1357 interface IAccessControl {
1358     /**
1359      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1360      *
1361      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1362      * {RoleAdminChanged} not being emitted signaling this.
1363      *
1364      * _Available since v3.1._
1365      */
1366     event RoleAdminChanged(
1367         bytes32 indexed role,
1368         bytes32 indexed previousAdminRole,
1369         bytes32 indexed newAdminRole
1370     );
1371 
1372     /**
1373      * @dev Emitted when `account` is granted `role`.
1374      *
1375      * `sender` is the account that originated the contract call, an admin role
1376      * bearer except when using {AccessControl-_setupRole}.
1377      */
1378     event RoleGranted(
1379         bytes32 indexed role,
1380         address indexed account,
1381         address indexed sender
1382     );
1383 
1384     /**
1385      * @dev Emitted when `account` is revoked `role`.
1386      *
1387      * `sender` is the account that originated the contract call:
1388      *   - if using `revokeRole`, it is the admin role bearer
1389      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1390      */
1391     event RoleRevoked(
1392         bytes32 indexed role,
1393         address indexed account,
1394         address indexed sender
1395     );
1396 
1397     /**
1398      * @dev Returns `true` if `account` has been granted `role`.
1399      */
1400     function hasRole(bytes32 role, address account)
1401         external
1402         view
1403         returns (bool);
1404 
1405     /**
1406      * @dev Returns the admin role that controls `role`. See {grantRole} and
1407      * {revokeRole}.
1408      *
1409      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
1410      */
1411     function getRoleAdmin(bytes32 role) external view returns (bytes32);
1412 
1413     /**
1414      * @dev Grants `role` to `account`.
1415      *
1416      * If `account` had not been already granted `role`, emits a {RoleGranted}
1417      * event.
1418      *
1419      * Requirements:
1420      *
1421      * - the caller must have ``role``'s admin role.
1422      */
1423     function grantRole(bytes32 role, address account) external;
1424 
1425     /**
1426      * @dev Revokes `role` from `account`.
1427      *
1428      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1429      *
1430      * Requirements:
1431      *
1432      * - the caller must have ``role``'s admin role.
1433      */
1434     function revokeRole(bytes32 role, address account) external;
1435 
1436     /**
1437      * @dev Revokes `role` from the calling account.
1438      *
1439      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1440      * purpose is to provide a mechanism for accounts to lose their privileges
1441      * if they are compromised (such as when a trusted device is misplaced).
1442      *
1443      * If the calling account had been granted `role`, emits a {RoleRevoked}
1444      * event.
1445      *
1446      * Requirements:
1447      *
1448      * - the caller must be `account`.
1449      */
1450     function renounceRole(bytes32 role, address account) external;
1451 }
1452 
1453 // File @openzeppelin/contracts/access/AccessControl.sol@v4.5.0
1454 
1455 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
1456 
1457 pragma solidity ^0.8.0;
1458 
1459 /**
1460  * @dev Contract module that allows children to implement role-based access
1461  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1462  * members except through off-chain means by accessing the contract event logs. Some
1463  * applications may benefit from on-chain enumerability, for those cases see
1464  * {AccessControlEnumerable}.
1465  *
1466  * Roles are referred to by their `bytes32` identifier. These should be exposed
1467  * in the external API and be unique. The best way to achieve this is by
1468  * using `public constant` hash digests:
1469  *
1470  * ```
1471  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1472  * ```
1473  *
1474  * Roles can be used to represent a set of permissions. To restrict access to a
1475  * function call, use {hasRole}:
1476  *
1477  * ```
1478  * function foo() public {
1479  *     require(hasRole(MY_ROLE, msg.sender));
1480  *     ...
1481  * }
1482  * ```
1483  *
1484  * Roles can be granted and revoked dynamically via the {grantRole} and
1485  * {revokeRole} functions. Each role has an associated admin role, and only
1486  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1487  *
1488  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1489  * that only accounts with this role will be able to grant or revoke other
1490  * roles. More complex role relationships can be created by using
1491  * {_setRoleAdmin}.
1492  *
1493  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1494  * grant and revoke this role. Extra precautions should be taken to secure
1495  * accounts that have been granted it.
1496  */
1497 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1498     struct RoleData {
1499         mapping(address => bool) members;
1500         bytes32 adminRole;
1501     }
1502 
1503     mapping(bytes32 => RoleData) private _roles;
1504 
1505     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1506 
1507     /**
1508      * @dev Modifier that checks that an account has a specific role. Reverts
1509      * with a standardized message including the required role.
1510      *
1511      * The format of the revert reason is given by the following regular expression:
1512      *
1513      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1514      *
1515      * _Available since v4.1._
1516      */
1517     modifier onlyRole(bytes32 role) {
1518         _checkRole(role, _msgSender());
1519         _;
1520     }
1521 
1522     /**
1523      * @dev See {IERC165-supportsInterface}.
1524      */
1525     function supportsInterface(bytes4 interfaceId)
1526         public
1527         view
1528         virtual
1529         override
1530         returns (bool)
1531     {
1532         return
1533             interfaceId == type(IAccessControl).interfaceId ||
1534             super.supportsInterface(interfaceId);
1535     }
1536 
1537     /**
1538      * @dev Returns `true` if `account` has been granted `role`.
1539      */
1540     function hasRole(bytes32 role, address account)
1541         public
1542         view
1543         virtual
1544         override
1545         returns (bool)
1546     {
1547         return _roles[role].members[account];
1548     }
1549 
1550     /**
1551      * @dev Revert with a standard message if `account` is missing `role`.
1552      *
1553      * The format of the revert reason is given by the following regular expression:
1554      *
1555      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1556      */
1557     function _checkRole(bytes32 role, address account) internal view virtual {
1558         if (!hasRole(role, account)) {
1559             revert(
1560                 string(
1561                     abi.encodePacked(
1562                         "AccessControl: account ",
1563                         Strings.toHexString(uint160(account), 20),
1564                         " is missing role ",
1565                         Strings.toHexString(uint256(role), 32)
1566                     )
1567                 )
1568             );
1569         }
1570     }
1571 
1572     /**
1573      * @dev Returns the admin role that controls `role`. See {grantRole} and
1574      * {revokeRole}.
1575      *
1576      * To change a role's admin, use {_setRoleAdmin}.
1577      */
1578     function getRoleAdmin(bytes32 role)
1579         public
1580         view
1581         virtual
1582         override
1583         returns (bytes32)
1584     {
1585         return _roles[role].adminRole;
1586     }
1587 
1588     /**
1589      * @dev Grants `role` to `account`.
1590      *
1591      * If `account` had not been already granted `role`, emits a {RoleGranted}
1592      * event.
1593      *
1594      * Requirements:
1595      *
1596      * - the caller must have ``role``'s admin role.
1597      */
1598     function grantRole(bytes32 role, address account)
1599         public
1600         virtual
1601         override
1602         onlyRole(getRoleAdmin(role))
1603     {
1604         _grantRole(role, account);
1605     }
1606 
1607     /**
1608      * @dev Revokes `role` from `account`.
1609      *
1610      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1611      *
1612      * Requirements:
1613      *
1614      * - the caller must have ``role``'s admin role.
1615      */
1616     function revokeRole(bytes32 role, address account)
1617         public
1618         virtual
1619         override
1620         onlyRole(getRoleAdmin(role))
1621     {
1622         _revokeRole(role, account);
1623     }
1624 
1625     /**
1626      * @dev Revokes `role` from the calling account.
1627      *
1628      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1629      * purpose is to provide a mechanism for accounts to lose their privileges
1630      * if they are compromised (such as when a trusted device is misplaced).
1631      *
1632      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1633      * event.
1634      *
1635      * Requirements:
1636      *
1637      * - the caller must be `account`.
1638      */
1639     function renounceRole(bytes32 role, address account)
1640         public
1641         virtual
1642         override
1643     {
1644         require(
1645             account == _msgSender(),
1646             "AccessControl: can only renounce roles for self"
1647         );
1648 
1649         _revokeRole(role, account);
1650     }
1651 
1652     /**
1653      * @dev Grants `role` to `account`.
1654      *
1655      * If `account` had not been already granted `role`, emits a {RoleGranted}
1656      * event. Note that unlike {grantRole}, this function doesn't perform any
1657      * checks on the calling account.
1658      *
1659      * [WARNING]
1660      * ====
1661      * This function should only be called from the constructor when setting
1662      * up the initial roles for the system.
1663      *
1664      * Using this function in any other way is effectively circumventing the admin
1665      * system imposed by {AccessControl}.
1666      * ====
1667      *
1668      * NOTE: This function is deprecated in favor of {_grantRole}.
1669      */
1670     function _setupRole(bytes32 role, address account) internal virtual {
1671         _grantRole(role, account);
1672     }
1673 
1674     /**
1675      * @dev Sets `adminRole` as ``role``'s admin role.
1676      *
1677      * Emits a {RoleAdminChanged} event.
1678      */
1679     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1680         bytes32 previousAdminRole = getRoleAdmin(role);
1681         _roles[role].adminRole = adminRole;
1682         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1683     }
1684 
1685     /**
1686      * @dev Grants `role` to `account`.
1687      *
1688      * Internal function without access restriction.
1689      */
1690     function _grantRole(bytes32 role, address account) internal virtual {
1691         if (!hasRole(role, account)) {
1692             _roles[role].members[account] = true;
1693             emit RoleGranted(role, account, _msgSender());
1694         }
1695     }
1696 
1697     /**
1698      * @dev Revokes `role` from `account`.
1699      *
1700      * Internal function without access restriction.
1701      */
1702     function _revokeRole(bytes32 role, address account) internal virtual {
1703         if (hasRole(role, account)) {
1704             _roles[role].members[account] = false;
1705             emit RoleRevoked(role, account, _msgSender());
1706         }
1707     }
1708 }
1709 
1710 // File contracts/desire 2/DesireBase.sol
1711 
1712 pragma solidity ^0.8.4;
1713 
1714 // import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
1715 
1716 contract DesireBase is ERC721Burnable, Ownable {
1717     string public __baseURI;
1718 
1719     event BaseURIChanged(string, string);
1720 
1721     constructor(
1722         string memory name_,
1723         string memory symbol_,
1724         string memory baseURI_
1725     ) ERC721(name_, symbol_) {
1726         // set baseURI
1727         setBaseURI(baseURI_);
1728     }
1729 
1730     function _baseURI() internal view virtual override returns (string memory) {
1731         return __baseURI;
1732     }
1733 
1734     function setBaseURI(string memory baseURI_) public onlyOwner {
1735         require(
1736             keccak256(abi.encodePacked(__baseURI)) !=
1737                 keccak256(abi.encodePacked(baseURI_)),
1738             "same baseURI"
1739         );
1740 
1741         string memory oldBaseURI = __baseURI;
1742         __baseURI = baseURI_;
1743 
1744         emit BaseURIChanged(oldBaseURI, baseURI_);
1745     }
1746 
1747     function supportsInterface(bytes4 interfaceId)
1748         public
1749         view
1750         virtual
1751         override(ERC721)
1752         returns (bool)
1753     {
1754         return
1755             interfaceId == type(IERC721).interfaceId ||
1756             interfaceId == type(IERC721Metadata).interfaceId ||
1757             super.supportsInterface(interfaceId);
1758     }
1759 }
1760 
1761 // File contracts/desire 2/Desire.sol
1762 
1763 pragma solidity ^0.8.4;
1764 
1765 contract Desire is DesireBase {
1766     struct BaseInfo {
1767         string name;
1768         string symbol;
1769         string baseURI;
1770         uint256 maxAmountPerUser;
1771     }
1772 
1773     // NOTE: white list info contains all avaiable nft,including public mint nft id range
1774     struct WhiteListInfo {
1775         uint256 beginTime;
1776         uint256 endTime;
1777         uint256 price;
1778         bytes32 merkleRoot;
1779         uint256 start;
1780         uint256 end;
1781     }
1782 
1783     struct PublicMintInfo {
1784         uint256 beginTime;
1785         uint256 endTime;
1786         uint256 price;
1787         // uint256 start;
1788         // uint256 end;
1789     }
1790     uint256 private _royaltyBps;
1791     address payable private _royaltyRecipient;
1792 
1793     uint256 public constant devantId = 1;
1794     uint256 public constant _preserveTokenIdStart = 2;
1795     uint256 public constant _preserveTokenIdEnd = 201;
1796     uint256 public preserveCurrentId;
1797 
1798     WhiteListInfo public whiteListInfo;
1799     uint256 public whiteListCurrentId;
1800     PublicMintInfo public publicMintInfo;
1801     // uint256 public publicMintCurrentId;
1802 
1803     uint256 public immutable maxAmountPerUser;
1804 
1805     uint256 public totalSupply;
1806     // uint256 public mintedAmount;
1807 
1808     // address => minted token amount
1809     mapping(address => uint256) public minted;
1810 
1811     modifier checkAmount(uint256 amount) {
1812         require(amount <= maxAmountPerUser, "check amount: greater than max");
1813         require(
1814             minted[msg.sender] + amount <= maxAmountPerUser,
1815             "check amount: minted greater than max"
1816         );
1817         _;
1818     }
1819 
1820     modifier checkClaimPeriod() {
1821         require(block.timestamp >= whiteListInfo.beginTime, "claim not begin");
1822         require(block.timestamp <= whiteListInfo.endTime, "claim is over");
1823         _;
1824     }
1825 
1826     modifier checkClaimPrice(uint256 amount) {
1827         require(msg.value >= whiteListInfo.price * amount, "claim price");
1828         _;
1829     }
1830 
1831     modifier checkPublicMintPeriod() {
1832         require(block.timestamp >= publicMintInfo.beginTime, "mint not begin");
1833         require(block.timestamp <= publicMintInfo.endTime, "mint is over");
1834         _;
1835     }
1836 
1837     modifier checkPublicMintPrice(uint256 amount) {
1838         require(
1839             msg.value >= publicMintInfo.price * amount,
1840             "public mint price"
1841         );
1842         _;
1843     }
1844 
1845     modifier checkAvailableNFT(uint256 amount) {
1846         require(
1847             whiteListCurrentId + amount - 1 <= whiteListInfo.end,
1848             "mint: no remaining"
1849         );
1850         _;
1851     }
1852 
1853     event UpdateRoot(bytes32 oldRoot, bytes32 newRoot);
1854     event Withdraw(address indexed receiver, uint256 indexed amount);
1855     event Airdrop(address[] receivers, uint256 start);
1856     event MintToBidWinner(address receiver_, uint256 id_);
1857     event UpdateRoyalties(address payable recipient, uint256 bps);
1858     event MintPreserve(address receiver_, uint256 amount);
1859 
1860     constructor(
1861         BaseInfo memory baseInfo_,
1862         WhiteListInfo memory whiteListInfo_,
1863         PublicMintInfo memory publicMintInfo_
1864     ) DesireBase(baseInfo_.name, baseInfo_.symbol, baseInfo_.baseURI) {
1865         require(whiteListInfo_.start <= whiteListInfo_.end, "invalid range");
1866         require(whiteListInfo_.start > _preserveTokenIdEnd, "invalid preserve");
1867 
1868         whiteListInfo = whiteListInfo_;
1869         publicMintInfo = publicMintInfo_;
1870         maxAmountPerUser = baseInfo_.maxAmountPerUser;
1871 
1872         // set current token id
1873         whiteListCurrentId = whiteListInfo_.start;
1874         // publicMintCurrentId = publicMintInfo_.start;
1875 
1876         // // totalSupply = preserve amount + white list amount + 1 devant nft
1877         // totalSupply =
1878         //     (_preserveTokenIdEnd + 1 - _preserveTokenIdStart) +
1879         //     (whiteListInfo.end + 1 - whiteListInfo.start);
1880         // // mintedAmount = 0;
1881 
1882         preserveCurrentId = _preserveTokenIdStart;
1883     }
1884 
1885     // update merkle root for white list
1886     function updateRoot(bytes32 newRoot) public onlyOwner {
1887         require(newRoot != whiteListInfo.merkleRoot, "update root: same root");
1888         bytes32 oldRoot = whiteListInfo.merkleRoot;
1889         whiteListInfo.merkleRoot = newRoot;
1890         emit UpdateRoot(oldRoot, newRoot);
1891     }
1892 
1893     // white list accounts claim their NFT
1894     function claim(bytes32[] calldata proof_, uint256 amount)
1895         public
1896         payable
1897         checkAmount(amount)
1898         checkClaimPeriod
1899         checkClaimPrice(amount)
1900         checkAvailableNFT(amount)
1901     {
1902         // update info
1903         minted[msg.sender] += amount;
1904 
1905         // verify white listin white list
1906         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1907         require(
1908             MerkleProof.verify(proof_, whiteListInfo.merkleRoot, leaf),
1909             "verify failed"
1910         );
1911 
1912         // mint
1913         for (uint256 i = 0; i < amount; i++) {
1914             _safeMintWrapper(msg.sender, whiteListCurrentId + i);
1915         }
1916         whiteListCurrentId += amount;
1917     }
1918 
1919     function _safeMintWrapper(address to, uint256 tokenId) internal {
1920         totalSupply += 1;
1921         _safeMint(to, tokenId);
1922     }
1923 
1924     // public mint
1925     function publicMint(uint256 amount)
1926         public
1927         payable
1928         checkAmount(amount)
1929         checkPublicMintPeriod
1930         checkPublicMintPrice(amount)
1931         checkAvailableNFT(amount)
1932     {
1933         // update info
1934         minted[msg.sender] += amount;
1935 
1936         // mint
1937         for (uint256 i = 0; i < amount; i++) {
1938             _safeMintWrapper(msg.sender, whiteListCurrentId + i);
1939         }
1940         whiteListCurrentId += amount;
1941     }
1942 
1943     function withdraw(address payable receiver_) public onlyOwner {
1944         uint256 balance = address(this).balance;
1945         require(balance > 0, "no balance");
1946         require(receiver_ != address(0), "zero receiver address");
1947 
1948         receiver_.transfer(balance);
1949         emit Withdraw(receiver_, balance);
1950     }
1951 
1952     function mintPreserve(address receiver_, uint256 amount) public onlyOwner {
1953         require(
1954             _preserveTokenIdEnd + 1 - preserveCurrentId >= amount,
1955             "no remaining"
1956         );
1957 
1958         for (uint256 i = 0; i < amount; i++) {
1959             _safeMintWrapper(receiver_, preserveCurrentId + i);
1960         }
1961         preserveCurrentId += amount;
1962 
1963         emit MintPreserve(receiver_, amount);
1964     }
1965 
1966     function mintDevant(address receiver_) public onlyOwner {
1967         _safeMintWrapper(receiver_, devantId);
1968     }
1969 
1970     // royalty functions
1971     function updateRoyalties(address payable recipient, uint256 bps)
1972         external
1973         onlyOwner
1974     {
1975         require(recipient != address(0), "zero royalty recipient address");
1976         _royaltyRecipient = recipient;
1977         _royaltyBps = bps;
1978         emit UpdateRoyalties(recipient, bps);
1979     }
1980 
1981     function getRoyalties(uint256 tokenId)
1982         external
1983         view
1984         returns (address, uint256)
1985     {
1986         require(
1987             _exists(tokenId),
1988             "get royalty info: query for nonexistent token"
1989         );
1990         return (_royaltyRecipient, _royaltyBps);
1991     }
1992 
1993     function getFeeRecipients(uint256 tokenId) external view returns (address) {
1994         require(
1995             _exists(tokenId),
1996             "get fee recipients: query for nonexistent token"
1997         );
1998         return _royaltyRecipient;
1999     }
2000 
2001     function getFeeBps(uint256 tokenId) external view returns (uint256) {
2002         require(_exists(tokenId), "get fee bps: query for nonexistent token");
2003         return _royaltyBps;
2004     }
2005 
2006     function royaltyInfo(uint256 tokenId, uint256 value)
2007         external
2008         view
2009         returns (address, uint256)
2010     {
2011         require(_exists(tokenId), "royalty info: query for nonexistent token");
2012         return (_royaltyRecipient, (value * _royaltyBps) / 10000);
2013     }
2014 }