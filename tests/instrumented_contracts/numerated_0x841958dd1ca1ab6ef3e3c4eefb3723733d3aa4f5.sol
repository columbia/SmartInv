1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
56 // File: @openzeppelin/contracts/utils/Counters.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @title Counters
65  * @author Matt Condon (@shrugs)
66  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
67  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
68  *
69  * Include with `using Counters for Counters.Counter;`
70  */
71 library Counters {
72     struct Counter {
73         // This variable should never be directly accessed by users of the library: interactions must be restricted to
74         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
75         // this feature: see https://github.com/ethereum/solidity/issues/4637
76         uint256 _value; // default: 0
77     }
78 
79     function current(Counter storage counter) internal view returns (uint256) {
80         return counter._value;
81     }
82 
83     function increment(Counter storage counter) internal {
84         unchecked {
85             counter._value += 1;
86         }
87     }
88 
89     function decrement(Counter storage counter) internal {
90         uint256 value = counter._value;
91         require(value > 0, "Counter: decrement overflow");
92         unchecked {
93             counter._value = value - 1;
94         }
95     }
96 
97     function reset(Counter storage counter) internal {
98         counter._value = 0;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Strings.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev String operations.
111  */
112 library Strings {
113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
117      */
118     function toString(uint256 value) internal pure returns (string memory) {
119         // Inspired by OraclizeAPI's implementation - MIT licence
120         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
121 
122         if (value == 0) {
123             return "0";
124         }
125         uint256 temp = value;
126         uint256 digits;
127         while (temp != 0) {
128             digits++;
129             temp /= 10;
130         }
131         bytes memory buffer = new bytes(digits);
132         while (value != 0) {
133             digits -= 1;
134             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
135             value /= 10;
136         }
137         return string(buffer);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
142      */
143     function toHexString(uint256 value) internal pure returns (string memory) {
144         if (value == 0) {
145             return "0x00";
146         }
147         uint256 temp = value;
148         uint256 length = 0;
149         while (temp != 0) {
150             length++;
151             temp >>= 8;
152         }
153         return toHexString(value, length);
154     }
155 
156     /**
157      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
158      */
159     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
160         bytes memory buffer = new bytes(2 * length + 2);
161         buffer[0] = "0";
162         buffer[1] = "x";
163         for (uint256 i = 2 * length + 1; i > 1; --i) {
164             buffer[i] = _HEX_SYMBOLS[value & 0xf];
165             value >>= 4;
166         }
167         require(value == 0, "Strings: hex length insufficient");
168         return string(buffer);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Address.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Collection of functions related to the address type
181  */
182 library Address {
183     /**
184      * @dev Returns true if `account` is a contract.
185      *
186      * [IMPORTANT]
187      * ====
188      * It is unsafe to assume that an address for which this function returns
189      * false is an externally-owned account (EOA) and not a contract.
190      *
191      * Among others, `isContract` will return false for the following
192      * types of addresses:
193      *
194      *  - an externally-owned account
195      *  - a contract in construction
196      *  - an address where a contract will be created
197      *  - an address where a contract lived, but was destroyed
198      * ====
199      */
200     function isContract(address account) internal view returns (bool) {
201         // This method relies on extcodesize, which returns 0 for contracts in
202         // construction, since the code is only stored at the end of the
203         // constructor execution.
204 
205         uint256 size;
206         assembly {
207             size := extcodesize(account)
208         }
209         return size > 0;
210     }
211 
212     /**
213      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
214      * `recipient`, forwarding all available gas and reverting on errors.
215      *
216      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
217      * of certain opcodes, possibly making contracts go over the 2300 gas limit
218      * imposed by `transfer`, making them unable to receive funds via
219      * `transfer`. {sendValue} removes this limitation.
220      *
221      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
222      *
223      * IMPORTANT: because control is transferred to `recipient`, care must be
224      * taken to not create reentrancy vulnerabilities. Consider using
225      * {ReentrancyGuard} or the
226      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
227      */
228     function sendValue(address payable recipient, uint256 amount) internal {
229         require(address(this).balance >= amount, "Address: insufficient balance");
230 
231         (bool success, ) = recipient.call{value: amount}("");
232         require(success, "Address: unable to send value, recipient may have reverted");
233     }
234 
235     /**
236      * @dev Performs a Solidity function call using a low level `call`. A
237      * plain `call` is an unsafe replacement for a function call: use this
238      * function instead.
239      *
240      * If `target` reverts with a revert reason, it is bubbled up by this
241      * function (like regular Solidity function calls).
242      *
243      * Returns the raw returned data. To convert to the expected return value,
244      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
245      *
246      * Requirements:
247      *
248      * - `target` must be a contract.
249      * - calling `target` with `data` must not revert.
250      *
251      * _Available since v3.1._
252      */
253     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
254         return functionCall(target, data, "Address: low-level call failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
259      * `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCall(
264         address target,
265         bytes memory data,
266         string memory errorMessage
267     ) internal returns (bytes memory) {
268         return functionCallWithValue(target, data, 0, errorMessage);
269     }
270 
271     /**
272      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
273      * but also transferring `value` wei to `target`.
274      *
275      * Requirements:
276      *
277      * - the calling contract must have an ETH balance of at least `value`.
278      * - the called Solidity function must be `payable`.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(
283         address target,
284         bytes memory data,
285         uint256 value
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
292      * with `errorMessage` as a fallback revert reason when `target` reverts.
293      *
294      * _Available since v3.1._
295      */
296     function functionCallWithValue(
297         address target,
298         bytes memory data,
299         uint256 value,
300         string memory errorMessage
301     ) internal returns (bytes memory) {
302         require(address(this).balance >= value, "Address: insufficient balance for call");
303         require(isContract(target), "Address: call to non-contract");
304 
305         (bool success, bytes memory returndata) = target.call{value: value}(data);
306         return verifyCallResult(success, returndata, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but performing a static call.
312      *
313      * _Available since v3.3._
314      */
315     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
316         return functionStaticCall(target, data, "Address: low-level static call failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
321      * but performing a static call.
322      *
323      * _Available since v3.3._
324      */
325     function functionStaticCall(
326         address target,
327         bytes memory data,
328         string memory errorMessage
329     ) internal view returns (bytes memory) {
330         require(isContract(target), "Address: static call to non-contract");
331 
332         (bool success, bytes memory returndata) = target.staticcall(data);
333         return verifyCallResult(success, returndata, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but performing a delegate call.
339      *
340      * _Available since v3.4._
341      */
342     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
343         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
348      * but performing a delegate call.
349      *
350      * _Available since v3.4._
351      */
352     function functionDelegateCall(
353         address target,
354         bytes memory data,
355         string memory errorMessage
356     ) internal returns (bytes memory) {
357         require(isContract(target), "Address: delegate call to non-contract");
358 
359         (bool success, bytes memory returndata) = target.delegatecall(data);
360         return verifyCallResult(success, returndata, errorMessage);
361     }
362 
363     /**
364      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
365      * revert reason using the provided one.
366      *
367      * _Available since v4.3._
368      */
369     function verifyCallResult(
370         bool success,
371         bytes memory returndata,
372         string memory errorMessage
373     ) internal pure returns (bytes memory) {
374         if (success) {
375             return returndata;
376         } else {
377             // Look for revert reason and bubble it up if present
378             if (returndata.length > 0) {
379                 // The easiest way to bubble the revert reason is using memory via assembly
380 
381                 assembly {
382                     let returndata_size := mload(returndata)
383                     revert(add(32, returndata), returndata_size)
384                 }
385             } else {
386                 revert(errorMessage);
387             }
388         }
389     }
390 }
391 
392 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
393 
394 
395 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
396 
397 pragma solidity ^0.8.0;
398 
399 /**
400  * @title ERC721 token receiver interface
401  * @dev Interface for any contract that wants to support safeTransfers
402  * from ERC721 asset contracts.
403  */
404 interface IERC721Receiver {
405     /**
406      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
407      * by `operator` from `from`, this function is called.
408      *
409      * It must return its Solidity selector to confirm the token transfer.
410      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
411      *
412      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
413      */
414     function onERC721Received(
415         address operator,
416         address from,
417         uint256 tokenId,
418         bytes calldata data
419     ) external returns (bytes4);
420 }
421 
422 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
423 
424 
425 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @dev Interface of the ERC165 standard, as defined in the
431  * https://eips.ethereum.org/EIPS/eip-165[EIP].
432  *
433  * Implementers can declare support of contract interfaces, which can then be
434  * queried by others ({ERC165Checker}).
435  *
436  * For an implementation, see {ERC165}.
437  */
438 interface IERC165 {
439     /**
440      * @dev Returns true if this contract implements the interface defined by
441      * `interfaceId`. See the corresponding
442      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
443      * to learn more about how these ids are created.
444      *
445      * This function call must use less than 30 000 gas.
446      */
447     function supportsInterface(bytes4 interfaceId) external view returns (bool);
448 }
449 
450 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
451 
452 
453 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
454 
455 pragma solidity ^0.8.0;
456 
457 
458 /**
459  * @dev Implementation of the {IERC165} interface.
460  *
461  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
462  * for the additional interface id that will be supported. For example:
463  *
464  * ```solidity
465  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
466  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
467  * }
468  * ```
469  *
470  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
471  */
472 abstract contract ERC165 is IERC165 {
473     /**
474      * @dev See {IERC165-supportsInterface}.
475      */
476     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
477         return interfaceId == type(IERC165).interfaceId;
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 
489 /**
490  * @dev Required interface of an ERC721 compliant contract.
491  */
492 interface IERC721 is IERC165 {
493     /**
494      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
495      */
496     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
497 
498     /**
499      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
500      */
501     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
502 
503     /**
504      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
505      */
506     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
507 
508     /**
509      * @dev Returns the number of tokens in ``owner``'s account.
510      */
511     function balanceOf(address owner) external view returns (uint256 balance);
512 
513     /**
514      * @dev Returns the owner of the `tokenId` token.
515      *
516      * Requirements:
517      *
518      * - `tokenId` must exist.
519      */
520     function ownerOf(uint256 tokenId) external view returns (address owner);
521 
522     /**
523      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
524      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
525      *
526      * Requirements:
527      *
528      * - `from` cannot be the zero address.
529      * - `to` cannot be the zero address.
530      * - `tokenId` token must exist and be owned by `from`.
531      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
532      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
533      *
534      * Emits a {Transfer} event.
535      */
536     function safeTransferFrom(
537         address from,
538         address to,
539         uint256 tokenId
540     ) external;
541 
542     /**
543      * @dev Transfers `tokenId` token from `from` to `to`.
544      *
545      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
546      *
547      * Requirements:
548      *
549      * - `from` cannot be the zero address.
550      * - `to` cannot be the zero address.
551      * - `tokenId` token must be owned by `from`.
552      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
553      *
554      * Emits a {Transfer} event.
555      */
556     function transferFrom(
557         address from,
558         address to,
559         uint256 tokenId
560     ) external;
561 
562     /**
563      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
564      * The approval is cleared when the token is transferred.
565      *
566      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
567      *
568      * Requirements:
569      *
570      * - The caller must own the token or be an approved operator.
571      * - `tokenId` must exist.
572      *
573      * Emits an {Approval} event.
574      */
575     function approve(address to, uint256 tokenId) external;
576 
577     /**
578      * @dev Returns the account approved for `tokenId` token.
579      *
580      * Requirements:
581      *
582      * - `tokenId` must exist.
583      */
584     function getApproved(uint256 tokenId) external view returns (address operator);
585 
586     /**
587      * @dev Approve or remove `operator` as an operator for the caller.
588      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
589      *
590      * Requirements:
591      *
592      * - The `operator` cannot be the caller.
593      *
594      * Emits an {ApprovalForAll} event.
595      */
596     function setApprovalForAll(address operator, bool _approved) external;
597 
598     /**
599      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
600      *
601      * See {setApprovalForAll}
602      */
603     function isApprovedForAll(address owner, address operator) external view returns (bool);
604 
605     /**
606      * @dev Safely transfers `tokenId` token from `from` to `to`.
607      *
608      * Requirements:
609      *
610      * - `from` cannot be the zero address.
611      * - `to` cannot be the zero address.
612      * - `tokenId` token must exist and be owned by `from`.
613      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
614      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
615      *
616      * Emits a {Transfer} event.
617      */
618     function safeTransferFrom(
619         address from,
620         address to,
621         uint256 tokenId,
622         bytes calldata data
623     ) external;
624 }
625 
626 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
627 
628 
629 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 
634 /**
635  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
636  * @dev See https://eips.ethereum.org/EIPS/eip-721
637  */
638 interface IERC721Metadata is IERC721 {
639     /**
640      * @dev Returns the token collection name.
641      */
642     function name() external view returns (string memory);
643 
644     /**
645      * @dev Returns the token collection symbol.
646      */
647     function symbol() external view returns (string memory);
648 
649     /**
650      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
651      */
652     function tokenURI(uint256 tokenId) external view returns (string memory);
653 }
654 
655 // File: @openzeppelin/contracts/utils/Context.sol
656 
657 
658 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 /**
663  * @dev Provides information about the current execution context, including the
664  * sender of the transaction and its data. While these are generally available
665  * via msg.sender and msg.data, they should not be accessed in such a direct
666  * manner, since when dealing with meta-transactions the account sending and
667  * paying for execution may not be the actual sender (as far as an application
668  * is concerned).
669  *
670  * This contract is only required for intermediate, library-like contracts.
671  */
672 abstract contract Context {
673     function _msgSender() internal view virtual returns (address) {
674         return msg.sender;
675     }
676 
677     function _msgData() internal view virtual returns (bytes calldata) {
678         return msg.data;
679     }
680 }
681 
682 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
683 
684 
685 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 
690 
691 
692 
693 
694 
695 
696 /**
697  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
698  * the Metadata extension, but not including the Enumerable extension, which is available separately as
699  * {ERC721Enumerable}.
700  */
701 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
702     using Address for address;
703     using Strings for uint256;
704 
705     // Token name
706     string private _name;
707 
708     // Token symbol
709     string private _symbol;
710 
711     // Mapping from token ID to owner address
712     mapping(uint256 => address) private _owners;
713 
714     // Mapping owner address to token count
715     mapping(address => uint256) private _balances;
716 
717     // Mapping from token ID to approved address
718     mapping(uint256 => address) private _tokenApprovals;
719 
720     // Mapping from owner to operator approvals
721     mapping(address => mapping(address => bool)) private _operatorApprovals;
722 
723     /**
724      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
725      */
726     constructor(string memory name_, string memory symbol_) {
727         _name = name_;
728         _symbol = symbol_;
729     }
730 
731     /**
732      * @dev See {IERC165-supportsInterface}.
733      */
734     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
735         return
736             interfaceId == type(IERC721).interfaceId ||
737             interfaceId == type(IERC721Metadata).interfaceId ||
738             super.supportsInterface(interfaceId);
739     }
740 
741     /**
742      * @dev See {IERC721-balanceOf}.
743      */
744     function balanceOf(address owner) public view virtual override returns (uint256) {
745         require(owner != address(0), "ERC721: balance query for the zero address");
746         return _balances[owner];
747     }
748 
749     /**
750      * @dev See {IERC721-ownerOf}.
751      */
752     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
753         address owner = _owners[tokenId];
754         require(owner != address(0), "ERC721: owner query for nonexistent token");
755         return owner;
756     }
757 
758     /**
759      * @dev See {IERC721Metadata-name}.
760      */
761     function name() public view virtual override returns (string memory) {
762         return _name;
763     }
764 
765     /**
766      * @dev See {IERC721Metadata-symbol}.
767      */
768     function symbol() public view virtual override returns (string memory) {
769         return _symbol;
770     }
771 
772     /**
773      * @dev See {IERC721Metadata-tokenURI}.
774      */
775     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
776         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
777 
778         string memory baseURI = _baseURI();
779         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
780     }
781 
782     /**
783      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
784      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
785      * by default, can be overriden in child contracts.
786      */
787     function _baseURI() internal view virtual returns (string memory) {
788         return "";
789     }
790 
791     /**
792      * @dev See {IERC721-approve}.
793      */
794     function approve(address to, uint256 tokenId) public virtual override {
795         address owner = ERC721.ownerOf(tokenId);
796         require(to != owner, "ERC721: approval to current owner");
797 
798         require(
799             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
800             "ERC721: approve caller is not owner nor approved for all"
801         );
802 
803         _approve(to, tokenId);
804     }
805 
806     /**
807      * @dev See {IERC721-getApproved}.
808      */
809     function getApproved(uint256 tokenId) public view virtual override returns (address) {
810         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
811 
812         return _tokenApprovals[tokenId];
813     }
814 
815     /**
816      * @dev See {IERC721-setApprovalForAll}.
817      */
818     function setApprovalForAll(address operator, bool approved) public virtual override {
819         _setApprovalForAll(_msgSender(), operator, approved);
820     }
821 
822     /**
823      * @dev See {IERC721-isApprovedForAll}.
824      */
825     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
826         return _operatorApprovals[owner][operator];
827     }
828 
829     /**
830      * @dev See {IERC721-transferFrom}.
831      */
832     function transferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) public virtual override {
837         //solhint-disable-next-line max-line-length
838         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
839 
840         _transfer(from, to, tokenId);
841     }
842 
843     /**
844      * @dev See {IERC721-safeTransferFrom}.
845      */
846     function safeTransferFrom(
847         address from,
848         address to,
849         uint256 tokenId
850     ) public virtual override {
851         safeTransferFrom(from, to, tokenId, "");
852     }
853 
854     /**
855      * @dev See {IERC721-safeTransferFrom}.
856      */
857     function safeTransferFrom(
858         address from,
859         address to,
860         uint256 tokenId,
861         bytes memory _data
862     ) public virtual override {
863         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
864         _safeTransfer(from, to, tokenId, _data);
865     }
866 
867     /**
868      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
869      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
870      *
871      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
872      *
873      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
874      * implement alternative mechanisms to perform token transfer, such as signature-based.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must exist and be owned by `from`.
881      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
882      *
883      * Emits a {Transfer} event.
884      */
885     function _safeTransfer(
886         address from,
887         address to,
888         uint256 tokenId,
889         bytes memory _data
890     ) internal virtual {
891         _transfer(from, to, tokenId);
892         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
893     }
894 
895     /**
896      * @dev Returns whether `tokenId` exists.
897      *
898      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
899      *
900      * Tokens start existing when they are minted (`_mint`),
901      * and stop existing when they are burned (`_burn`).
902      */
903     function _exists(uint256 tokenId) internal view virtual returns (bool) {
904         return _owners[tokenId] != address(0);
905     }
906 
907     /**
908      * @dev Returns whether `spender` is allowed to manage `tokenId`.
909      *
910      * Requirements:
911      *
912      * - `tokenId` must exist.
913      */
914     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
915         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
916         address owner = ERC721.ownerOf(tokenId);
917         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
918     }
919 
920     /**
921      * @dev Safely mints `tokenId` and transfers it to `to`.
922      *
923      * Requirements:
924      *
925      * - `tokenId` must not exist.
926      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
927      *
928      * Emits a {Transfer} event.
929      */
930     function _safeMint(address to, uint256 tokenId) internal virtual {
931         _safeMint(to, tokenId, "");
932     }
933 
934     /**
935      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
936      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
937      */
938     function _safeMint(
939         address to,
940         uint256 tokenId,
941         bytes memory _data
942     ) internal virtual {
943         _mint(to, tokenId);
944         require(
945             _checkOnERC721Received(address(0), to, tokenId, _data),
946             "ERC721: transfer to non ERC721Receiver implementer"
947         );
948     }
949 
950     /**
951      * @dev Mints `tokenId` and transfers it to `to`.
952      *
953      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
954      *
955      * Requirements:
956      *
957      * - `tokenId` must not exist.
958      * - `to` cannot be the zero address.
959      *
960      * Emits a {Transfer} event.
961      */
962     function _mint(address to, uint256 tokenId) internal virtual {
963         require(to != address(0), "ERC721: mint to the zero address");
964         require(!_exists(tokenId), "ERC721: token already minted");
965 
966         _beforeTokenTransfer(address(0), to, tokenId);
967 
968         _balances[to] += 1;
969         _owners[tokenId] = to;
970 
971         emit Transfer(address(0), to, tokenId);
972     }
973 
974     /**
975      * @dev Destroys `tokenId`.
976      * The approval is cleared when the token is burned.
977      *
978      * Requirements:
979      *
980      * - `tokenId` must exist.
981      *
982      * Emits a {Transfer} event.
983      */
984     function _burn(uint256 tokenId) internal virtual {
985         address owner = ERC721.ownerOf(tokenId);
986 
987         _beforeTokenTransfer(owner, address(0), tokenId);
988 
989         // Clear approvals
990         _approve(address(0), tokenId);
991 
992         _balances[owner] -= 1;
993         delete _owners[tokenId];
994 
995         emit Transfer(owner, address(0), tokenId);
996     }
997 
998     /**
999      * @dev Transfers `tokenId` from `from` to `to`.
1000      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1001      *
1002      * Requirements:
1003      *
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must be owned by `from`.
1006      *
1007      * Emits a {Transfer} event.
1008      */
1009     function _transfer(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) internal virtual {
1014         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1015         require(to != address(0), "ERC721: transfer to the zero address");
1016 
1017         _beforeTokenTransfer(from, to, tokenId);
1018 
1019         // Clear approvals from the previous owner
1020         _approve(address(0), tokenId);
1021 
1022         _balances[from] -= 1;
1023         _balances[to] += 1;
1024         _owners[tokenId] = to;
1025 
1026         emit Transfer(from, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev Approve `to` to operate on `tokenId`
1031      *
1032      * Emits a {Approval} event.
1033      */
1034     function _approve(address to, uint256 tokenId) internal virtual {
1035         _tokenApprovals[tokenId] = to;
1036         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1037     }
1038 
1039     /**
1040      * @dev Approve `operator` to operate on all of `owner` tokens
1041      *
1042      * Emits a {ApprovalForAll} event.
1043      */
1044     function _setApprovalForAll(
1045         address owner,
1046         address operator,
1047         bool approved
1048     ) internal virtual {
1049         require(owner != operator, "ERC721: approve to caller");
1050         _operatorApprovals[owner][operator] = approved;
1051         emit ApprovalForAll(owner, operator, approved);
1052     }
1053 
1054     /**
1055      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1056      * The call is not executed if the target address is not a contract.
1057      *
1058      * @param from address representing the previous owner of the given token ID
1059      * @param to target address that will receive the tokens
1060      * @param tokenId uint256 ID of the token to be transferred
1061      * @param _data bytes optional data to send along with the call
1062      * @return bool whether the call correctly returned the expected magic value
1063      */
1064     function _checkOnERC721Received(
1065         address from,
1066         address to,
1067         uint256 tokenId,
1068         bytes memory _data
1069     ) private returns (bool) {
1070         if (to.isContract()) {
1071             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1072                 return retval == IERC721Receiver.onERC721Received.selector;
1073             } catch (bytes memory reason) {
1074                 if (reason.length == 0) {
1075                     revert("ERC721: transfer to non ERC721Receiver implementer");
1076                 } else {
1077                     assembly {
1078                         revert(add(32, reason), mload(reason))
1079                     }
1080                 }
1081             }
1082         } else {
1083             return true;
1084         }
1085     }
1086 
1087     /**
1088      * @dev Hook that is called before any token transfer. This includes minting
1089      * and burning.
1090      *
1091      * Calling conditions:
1092      *
1093      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1094      * transferred to `to`.
1095      * - When `from` is zero, `tokenId` will be minted for `to`.
1096      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1097      * - `from` and `to` are never both zero.
1098      *
1099      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1100      */
1101     function _beforeTokenTransfer(
1102         address from,
1103         address to,
1104         uint256 tokenId
1105     ) internal virtual {}
1106 }
1107 
1108 // File: @openzeppelin/contracts/access/Ownable.sol
1109 
1110 
1111 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 
1116 /**
1117  * @dev Contract module which provides a basic access control mechanism, where
1118  * there is an account (an owner) that can be granted exclusive access to
1119  * specific functions.
1120  *
1121  * By default, the owner account will be the one that deploys the contract. This
1122  * can later be changed with {transferOwnership}.
1123  *
1124  * This module is used through inheritance. It will make available the modifier
1125  * `onlyOwner`, which can be applied to your functions to restrict their use to
1126  * the owner.
1127  */
1128 abstract contract Ownable is Context {
1129     address private _owner;
1130 
1131     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1132 
1133     /**
1134      * @dev Initializes the contract setting the deployer as the initial owner.
1135      */
1136     constructor() {
1137         _transferOwnership(_msgSender());
1138     }
1139 
1140     /**
1141      * @dev Returns the address of the current owner.
1142      */
1143     function owner() public view virtual returns (address) {
1144         return _owner;
1145     }
1146 
1147     /**
1148      * @dev Throws if called by any account other than the owner.
1149      */
1150     modifier onlyOwner() {
1151         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1152         _;
1153     }
1154 
1155     /**
1156      * @dev Leaves the contract without owner. It will not be possible to call
1157      * `onlyOwner` functions anymore. Can only be called by the current owner.
1158      *
1159      * NOTE: Renouncing ownership will leave the contract without an owner,
1160      * thereby removing any functionality that is only available to the owner.
1161      */
1162     function renounceOwnership() public virtual onlyOwner {
1163         _transferOwnership(address(0));
1164     }
1165 
1166     /**
1167      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1168      * Can only be called by the current owner.
1169      */
1170     function transferOwnership(address newOwner) public virtual onlyOwner {
1171         require(newOwner != address(0), "Ownable: new owner is the zero address");
1172         _transferOwnership(newOwner);
1173     }
1174 
1175     /**
1176      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1177      * Internal function without access restriction.
1178      */
1179     function _transferOwnership(address newOwner) internal virtual {
1180         address oldOwner = _owner;
1181         _owner = newOwner;
1182         emit OwnershipTransferred(oldOwner, newOwner);
1183     }
1184 }
1185 
1186 // File: MetaManiacs.sol
1187 
1188 // SPDX-License-Identifier: MIT
1189 
1190 // File: contracts/MetaManiacs.sol
1191 
1192 pragma solidity >=0.8.4;
1193 
1194 /**
1195 
1196     $$\      $$\            $$\                     $$\      $$\                     $$\                               
1197     $$$\    $$$ |           $$ |                    $$$\    $$$ |                    \__|                              
1198     $$$$\  $$$$ | $$$$$$\ $$$$$$\    $$$$$$\        $$$$\  $$$$ | $$$$$$\  $$$$$$$\  $$\  $$$$$$\   $$$$$$$\  $$$$$$$\ 
1199     $$\$$\$$ $$ |$$  __$$\\_$$  _|   \____$$\       $$\$$\$$ $$ | \____$$\ $$  __$$\ $$ | \____$$\ $$  _____|$$  _____|
1200     $$ \$$$  $$ |$$$$$$$$ | $$ |     $$$$$$$ |      $$ \$$$  $$ | $$$$$$$ |$$ |  $$ |$$ | $$$$$$$ |$$ /      \$$$$$$\  
1201     $$ |\$  /$$ |$$   ____| $$ |$$\ $$  __$$ |      $$ |\$  /$$ |$$  __$$ |$$ |  $$ |$$ |$$  __$$ |$$ |       \____$$\ 
1202     $$ | \_/ $$ |\$$$$$$$\  \$$$$  |\$$$$$$$ |      $$ | \_/ $$ |\$$$$$$$ |$$ |  $$ |$$ |\$$$$$$$ |\$$$$$$$\ $$$$$$$  |
1203     \__|     \__| \_______|  \____/  \_______|      \__|     \__| \_______|\__|  \__|\__| \_______| \_______|\_______/ 
1204                                                                                                                     
1205     by HLT                                                                                                    
1206                                                                                                                    
1207 */
1208 
1209 
1210 
1211 
1212 
1213 contract MetaManiacs is ERC721, Ownable {
1214     using Strings for uint256;
1215     using Counters for Counters.Counter;
1216 
1217     Counters.Counter private supply;
1218 
1219     bytes32 public merkleRoot;
1220 
1221     address private _proxyRegistryAddress; // For OpenSea WhiteListing
1222     address public withdrawAddress = 0xa0b3A364084A106b25a8b5132F0c00657F81bc82;
1223 
1224     uint256 public immutable maxSupply = 10000;
1225     uint256 public cost = 0.16 ether; // 160000000000000000 Wei
1226     uint256 public preCost = 0.12 ether; // 120000000000000000 Wei
1227     uint256 public maxMintAmountPerTx = 10;
1228     uint256 public maxPerPresaleAddress = 3;
1229     uint256 public reserveCount;
1230     uint256 public reserveLimit = 100;
1231 
1232     bool public paused;
1233     bool public revealed;
1234     bool public presale;
1235 
1236     string private _uriPrefix;
1237     string public uriSuffix;
1238     string public uriHidden;
1239 
1240     mapping(address => uint256) private _presaleClaimed;
1241 
1242     constructor(
1243         bytes32 _merkleRoot,
1244         address proxyRegistryAddress,
1245         string memory _uriHidden
1246     ) ERC721("Meta Maniacs", "MEMA") {
1247         merkleRoot = _merkleRoot;
1248         _proxyRegistryAddress = proxyRegistryAddress;
1249         _uriPrefix = "UNREVEALED";
1250         uriSuffix = ".json";
1251         uriHidden = _uriHidden;
1252         maxMintAmountPerTx = 10;
1253         reserveCount = 0;
1254         paused = true;
1255         revealed = false;
1256         presale = true;
1257     }
1258 
1259     /**
1260      * MINT FUNCTIONS
1261      */
1262 
1263     // PRESALE
1264     function mintPresale(
1265         address account,
1266         uint256 _mintAmount,
1267         bytes32[] calldata merkleProof
1268     ) public payable mintCompliance(_mintAmount) {
1269         // Verify the merkle proof.
1270         bytes32 node = keccak256(
1271             abi.encodePacked(account, maxPerPresaleAddress)
1272         );
1273         require(
1274             MerkleProof.verify(merkleProof, merkleRoot, node),
1275             "Invalid whitelist proof."
1276         );
1277         require(presale, "No presale minting currently.");
1278         require(msg.value >= preCost * _mintAmount, "Insufficient funds.");
1279         require(
1280             _presaleClaimed[account] + _mintAmount <= maxPerPresaleAddress,
1281             "Exceeds max mints for presale."
1282         );
1283 
1284         _mintLoop(account, _mintAmount);
1285 
1286         _presaleClaimed[account] += _mintAmount;
1287     }
1288 
1289     // PUBLIC SALE
1290     function mint(uint256 _mintAmount)
1291         public
1292         payable
1293         mintCompliance(_mintAmount)
1294     {
1295         require(!presale, "Only presale minting currently.");
1296         require(msg.value >= cost * _mintAmount, "Insufficient funds.");
1297 
1298         _mintLoop(msg.sender, _mintAmount);
1299     }
1300 
1301     // MINT COMPLIANCE
1302     modifier mintCompliance(uint256 _mintAmount) {
1303         require(!paused, "The sale is paused.");
1304         require(_mintAmount > 0, "Must be greater than 0.");
1305         // require(_mintAmount < 11, "Invalid mint amount.");
1306         require(_mintAmount <= maxMintAmountPerTx, "Invalid mint amount.");
1307         require(
1308             supply.current() + _mintAmount <= maxSupply,
1309             "Max supply exceeded."
1310         );
1311         _;
1312     }
1313 
1314     // MINT LOOP
1315     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1316         for (uint256 i = 0; i < _mintAmount; i++) {
1317             supply.increment();
1318             _safeMint(_receiver, supply.current());
1319         }
1320     }
1321 
1322     // OWNER MINT
1323     function mintForAddress(uint256 _mintAmount, address _receiver)
1324         public
1325         mintCompliance(_mintAmount)
1326         onlyOwner
1327     {
1328         // Reserve limited implemented here. Set @ 50.
1329         require(
1330             reserveCount + _mintAmount <= reserveLimit,
1331             "Exceeds max of 50 reserved."
1332         );
1333         _mintLoop(_receiver, _mintAmount);
1334         reserveCount += _mintAmount;
1335     }
1336 
1337     /**
1338      * GETTERS
1339      */
1340 
1341     // GET TOKEN URI
1342     function tokenURI(uint256 _tokenId)
1343         public
1344         view
1345         virtual
1346         override
1347         returns (string memory)
1348     {
1349         require(
1350             _exists(_tokenId),
1351             "ERC721Metadata: URI query for nonexistent token."
1352         );
1353         if (revealed == false) {
1354             return uriHidden;
1355         }
1356         string memory currentBaseURI = _baseURI();
1357         return
1358             bytes(currentBaseURI).length > 0
1359                 ? string(
1360                     abi.encodePacked(
1361                         currentBaseURI,
1362                         _tokenId.toString(),
1363                         uriSuffix
1364                     )
1365                 )
1366                 : "";
1367     }
1368 
1369     // GET BASE URI (INTERNAL)
1370     function _baseURI() internal view virtual override returns (string memory) {
1371         return _uriPrefix;
1372     }
1373 
1374     // GET URI PREFIX
1375     function getUriPrefix() public view onlyOwner returns (string memory) {
1376         return _uriPrefix;
1377     }
1378 
1379     // GET OS PROXY ADDY
1380     function getProxyRegistryAddress() public view onlyOwner returns (address) {
1381         return _proxyRegistryAddress;
1382     }
1383 
1384     // GET SUPPLY
1385     function totalSupply() public view returns (uint256) {
1386         return supply.current();
1387     }
1388 
1389     // RETURNS TOKEN IDS OF A WALLET ADDRESS
1390     function walletOfOwner(address _owner)
1391         public
1392         view
1393         returns (uint256[] memory)
1394     {
1395         uint256 ownerTokenCount = balanceOf(_owner);
1396         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1397         uint256 currentTokenId = 1;
1398         uint256 ownedTokenIndex = 0;
1399 
1400         while (
1401             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1402         ) {
1403             address currentTokenOwner = ownerOf(currentTokenId);
1404 
1405             if (currentTokenOwner == _owner) {
1406                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1407 
1408                 ownedTokenIndex++;
1409             }
1410 
1411             currentTokenId++;
1412         }
1413 
1414         return ownedTokenIds;
1415     }
1416 
1417     /**
1418      * SETTERS
1419      */
1420 
1421     // WL
1422     // SET WL ROOT
1423     function setMerkleRoot(bytes32 newRoot) public onlyOwner {
1424         merkleRoot = newRoot;
1425     }
1426 
1427     // URIs
1428     // SET UNREVEALED URI
1429     function setUriHidden(string memory _uriHidden) public onlyOwner {
1430         uriHidden = _uriHidden;
1431     }
1432 
1433     // SET URI PREFIX
1434     function setUriPrefix(string memory uriPrefixNew) public onlyOwner {
1435         _uriPrefix = uriPrefixNew;
1436     }
1437 
1438     // SET URI SUFFIX
1439     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1440         uriSuffix = _uriSuffix;
1441     }
1442 
1443     // SET COST
1444     function setCost(uint256 _cost) public onlyOwner {
1445         cost = _cost;
1446     }
1447 
1448     // SET PRESALE COST
1449     function setPreCost(uint256 _cost) public onlyOwner {
1450         preCost = _cost;
1451     }
1452 
1453     // SET RESERVE LIMIT
1454     function setReserveLimit(uint256 _newLimit) public onlyOwner {
1455         reserveLimit = _newLimit;
1456     }
1457 
1458     // SET MAX TOKENS PER ADDRESS FOR PRESALE
1459     function setMaxPerPresaleAddress(uint256 _maxPerPresaleAddress)
1460         public
1461         onlyOwner
1462     {
1463         maxPerPresaleAddress = _maxPerPresaleAddress;
1464     }
1465 
1466     // SET TOKENS PER MINT TX
1467     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
1468         public
1469         onlyOwner
1470     {
1471         maxMintAmountPerTx = _maxMintAmountPerTx;
1472     }
1473 
1474     // SET PAUSED
1475     function setPaused(bool _state) public onlyOwner {
1476         paused = _state;
1477     }
1478 
1479     // SET PRESALE
1480     function setPresale(bool _state) public onlyOwner {
1481         presale = _state;
1482     }
1483 
1484     // SET REVEALED
1485     function setRevealed(bool _state) public onlyOwner {
1486         revealed = _state;
1487     }
1488 
1489     // SET WITHDRAW ADDRESS
1490     function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
1491         withdrawAddress = _withdrawAddress;
1492     }
1493 
1494     /**
1495      * OPENSEA TRADING WHITELISTING
1496      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1497      */
1498 
1499     // SET OS WL ADDY
1500     function setProxyRegistryAddress(address proxyRegistryAddress)
1501         external
1502         onlyOwner
1503     {
1504         _proxyRegistryAddress = proxyRegistryAddress;
1505     }
1506 
1507     // OVERRIDE
1508     function isApprovedForAll(address owner, address operator)
1509         public
1510         view
1511         override
1512         returns (bool)
1513     {
1514         // Whitelist OpenSea proxy contract for easy trading.
1515         ProxyRegistry proxyRegistry = ProxyRegistry(_proxyRegistryAddress);
1516         if (address(proxyRegistry.proxies(owner)) == operator) {
1517             return true;
1518         }
1519 
1520         return super.isApprovedForAll(owner, operator);
1521     }
1522 
1523     // WITHDRAW
1524     function withdraw() public onlyOwner {
1525         (bool os, ) = payable(withdrawAddress).call{
1526             value: address(this).balance
1527         }("");
1528         require(os);
1529     }
1530 }
1531 
1532 // For OpenSea WhiteListing
1533 contract OwnableDelegateProxy {
1534 
1535 }
1536 
1537 contract ProxyRegistry {
1538     mapping(address => OwnableDelegateProxy) public proxies;
1539 }