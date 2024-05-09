1 // SPDX-License-Identifier: GPL-3.0
2 
3 // Amended by Predep
4 /**
5     !Disclaimer!
6 STREET MELTS SOCIETY CONTRACT CREATED BY @PREDEP7
7 AMENDED AND AUDITED BY ASTERIA LABS
8 */
9 
10 
11 // Merkle tree presale & optimisations by @Danny_One_
12 
13 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev These functions deal with verification of Merkle Trees proofs.
19  *
20  * The proofs can be generated using the JavaScript library
21  * https://github.com/miguelmota/merkletreejs[merkletreejs].
22  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
23  *
24  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
25  */
26 library MerkleProof {
27     /**
28      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
29      * defined by `root`. For this, a `proof` must be provided, containing
30      * sibling hashes on the branch from the leaf to the root of the tree. Each
31      * pair of leaves and each pair of pre-images are assumed to be sorted.
32      */
33     function verify(
34         bytes32[] memory proof,
35         bytes32 root,
36         bytes32 leaf
37     ) internal pure returns (bool) {
38         return processProof(proof, leaf) == root;
39     }
40 
41     /**
42      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
43      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
44      * hash matches the root of the tree. When processing the proof, the pairs
45      * of leafs & pre-images are assumed to be sorted.
46      *
47      * _Available since v4.4._
48      */
49     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
50         bytes32 computedHash = leaf;
51         for (uint256 i = 0; i < proof.length; i++) {
52             bytes32 proofElement = proof[i];
53             if (computedHash <= proofElement) {
54                 // Hash(current computed hash + current element of the proof)
55                 computedHash = _efficientHash(computedHash, proofElement);
56             } else {
57                 // Hash(current element of the proof + current computed hash)
58                 computedHash = _efficientHash(proofElement, computedHash);
59             }
60         }
61         return computedHash;
62     }
63 
64     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
65         assembly {
66             mstore(0x00, a)
67             mstore(0x20, b)
68             value := keccak256(0x00, 0x40)
69         }
70     }
71 }
72 
73 
74 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
75 pragma solidity ^0.8.0;
76 /**
77  * @dev Interface of the ERC165 standard, as defined in the
78  * https://eips.ethereum.org/EIPS/eip-165[EIP].
79  *
80  * Implementers can declare support of contract interfaces, which can then be
81  * queried by others ({ERC165Checker}).
82  *
83  * For an implementation, see {ERC165}.
84  */
85 interface IERC165 {
86     /**
87      * @dev Returns true if this contract implements the interface defined by
88      * `interfaceId`. See the corresponding
89      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
90      * to learn more about how these ids are created.
91      *
92      * This function call must use less than 30 000 gas.
93      */
94     function supportsInterface(bytes4 interfaceId) external view returns (bool);
95 }
96 
97 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
98 pragma solidity ^0.8.0;
99 /**
100  * @dev Required interface of an ERC721 compliant contract.
101  */
102 interface IERC721 is IERC165 {
103     /**
104      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
107 
108     /**
109      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
110      */
111     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
112 
113     /**
114      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
115      */
116     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
117 
118     /**
119      * @dev Returns the number of tokens in ``owner``'s account.
120      */
121     function balanceOf(address owner) external view returns (uint256 balance);
122 
123     /**
124      * @dev Returns the owner of the `tokenId` token.
125      *
126      * Requirements:
127      *
128      * - `tokenId` must exist.
129      */
130     function ownerOf(uint256 tokenId) external view returns (address owner);
131 
132     /**
133      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
134      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
135      *
136      * Requirements:
137      *
138      * - `from` cannot be the zero address.
139      * - `to` cannot be the zero address.
140      * - `tokenId` token must exist and be owned by `from`.
141      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
142      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
143      *
144      * Emits a {Transfer} event.
145      */
146     function safeTransferFrom(
147         address from,
148         address to,
149         uint256 tokenId
150     ) external;
151 
152     /**
153      * @dev Transfers `tokenId` token from `from` to `to`.
154      *
155      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
156      *
157      * Requirements:
158      *
159      * - `from` cannot be the zero address.
160      * - `to` cannot be the zero address.
161      * - `tokenId` token must be owned by `from`.
162      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transferFrom(
167         address from,
168         address to,
169         uint256 tokenId
170     ) external;
171 
172     /**
173      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
174      * The approval is cleared when the token is transferred.
175      *
176      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
177      *
178      * Requirements:
179      *
180      * - The caller must own the token or be an approved operator.
181      * - `tokenId` must exist.
182      *
183      * Emits an {Approval} event.
184      */
185     function approve(address to, uint256 tokenId) external;
186 
187     /**
188      * @dev Returns the account approved for `tokenId` token.
189      *
190      * Requirements:
191      *
192      * - `tokenId` must exist.
193      */
194     function getApproved(uint256 tokenId) external view returns (address operator);
195 
196     /**
197      * @dev Approve or remove `operator` as an operator for the caller.
198      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
199      *
200      * Requirements:
201      *
202      * - The `operator` cannot be the caller.
203      *
204      * Emits an {ApprovalForAll} event.
205      */
206     function setApprovalForAll(address operator, bool _approved) external;
207 
208     /**
209      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
210      *
211      * See {setApprovalForAll}
212      */
213     function isApprovedForAll(address owner, address operator) external view returns (bool);
214 
215     /**
216      * @dev Safely transfers `tokenId` token from `from` to `to`.
217      *
218      * Requirements:
219      *
220      * - `from` cannot be the zero address.
221      * - `to` cannot be the zero address.
222      * - `tokenId` token must exist and be owned by `from`.
223      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
224      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
225      *
226      * Emits a {Transfer} event.
227      */
228     function safeTransferFrom(
229         address from,
230         address to,
231         uint256 tokenId,
232         bytes calldata data
233     ) external;
234 }
235 
236 
237 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
238 pragma solidity ^0.8.0;
239 /**
240  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
241  * @dev See https://eips.ethereum.org/EIPS/eip-721
242  */
243 interface IERC721Enumerable is IERC721 {
244     /**
245      * @dev Returns the total amount of tokens stored by the contract.
246      */
247     function totalSupply() external view returns (uint256);
248 
249     /**
250      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
251      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
252      */
253     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
254 
255     /**
256      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
257      * Use along with {totalSupply} to enumerate all tokens.
258      */
259     function tokenByIndex(uint256 index) external view returns (uint256);
260 }
261 
262 
263 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
264 pragma solidity ^0.8.0;
265 /**
266  * @dev Implementation of the {IERC165} interface.
267  *
268  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
269  * for the additional interface id that will be supported. For example:
270  *
271  * ```solidity
272  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
273  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
274  * }
275  * ```
276  *
277  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
278  */
279 abstract contract ERC165 is IERC165 {
280     /**
281      * @dev See {IERC165-supportsInterface}.
282      */
283     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
284         return interfaceId == type(IERC165).interfaceId;
285     }
286 }
287 
288 // File: @openzeppelin/contracts/utils/Strings.sol
289 
290 
291 
292 pragma solidity ^0.8.0;
293 
294 /**
295  * @dev String operations.
296  */
297 library Strings {
298     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
299 
300     /**
301      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
302      */
303     function toString(uint256 value) internal pure returns (string memory) {
304         // Inspired by OraclizeAPI's implementation - MIT licence
305         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
306 
307         if (value == 0) {
308             return "0";
309         }
310         uint256 temp = value;
311         uint256 digits;
312         while (temp != 0) {
313             digits++;
314             temp /= 10;
315         }
316         bytes memory buffer = new bytes(digits);
317         while (value != 0) {
318             digits -= 1;
319             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
320             value /= 10;
321         }
322         return string(buffer);
323     }
324 
325     /**
326      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
327      */
328     function toHexString(uint256 value) internal pure returns (string memory) {
329         if (value == 0) {
330             return "0x00";
331         }
332         uint256 temp = value;
333         uint256 length = 0;
334         while (temp != 0) {
335             length++;
336             temp >>= 8;
337         }
338         return toHexString(value, length);
339     }
340 
341     /**
342      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
343      */
344     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
345         bytes memory buffer = new bytes(2 * length + 2);
346         buffer[0] = "0";
347         buffer[1] = "x";
348         for (uint256 i = 2 * length + 1; i > 1; --i) {
349             buffer[i] = _HEX_SYMBOLS[value & 0xf];
350             value >>= 4;
351         }
352         require(value == 0, "Strings: hex length insufficient");
353         return string(buffer);
354     }
355 }
356 
357 // File: @openzeppelin/contracts/utils/Address.sol
358 
359 
360 
361 pragma solidity ^0.8.0;
362 
363 /**
364  * @dev Collection of functions related to the address type
365  */
366 library Address {
367     /**
368      * @dev Returns true if `account` is a contract.
369      *
370      * [IMPORTANT]
371      * ====
372      * It is unsafe to assume that an address for which this function returns
373      * false is an externally-owned account (EOA) and not a contract.
374      *
375      * Among others, `isContract` will return false for the following
376      * types of addresses:
377      *
378      *  - an externally-owned account
379      *  - a contract in construction
380      *  - an address where a contract will be created
381      *  - an address where a contract lived, but was destroyed
382      * ====
383      */
384     function isContract(address account) internal view returns (bool) {
385         // This method relies on extcodesize, which returns 0 for contracts in
386         // construction, since the code is only stored at the end of the
387         // constructor execution.
388 
389         uint256 size;
390         assembly {
391             size := extcodesize(account)
392         }
393         return size > 0;
394     }
395 
396     /**
397      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
398      * `recipient`, forwarding all available gas and reverting on errors.
399      *
400      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
401      * of certain opcodes, possibly making contracts go over the 2300 gas limit
402      * imposed by `transfer`, making them unable to receive funds via
403      * `transfer`. {sendValue} removes this limitation.
404      *
405      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
406      *
407      * IMPORTANT: because control is transferred to `recipient`, care must be
408      * taken to not create reentrancy vulnerabilities. Consider using
409      * {ReentrancyGuard} or the
410      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
411      */
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(address(this).balance >= amount, "Address: insufficient balance");
414 
415         (bool success, ) = recipient.call{value: amount}("");
416         require(success, "Address: unable to send value, recipient may have reverted");
417     }
418 
419     /**
420      * @dev Performs a Solidity function call using a low level `call`. A
421      * plain `call` is an unsafe replacement for a function call: use this
422      * function instead.
423      *
424      * If `target` reverts with a revert reason, it is bubbled up by this
425      * function (like regular Solidity function calls).
426      *
427      * Returns the raw returned data. To convert to the expected return value,
428      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
429      *
430      * Requirements:
431      *
432      * - `target` must be a contract.
433      * - calling `target` with `data` must not revert.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionCall(target, data, "Address: low-level call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
443      * `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, 0, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but also transferring `value` wei to `target`.
458      *
459      * Requirements:
460      *
461      * - the calling contract must have an ETH balance of at least `value`.
462      * - the called Solidity function must be `payable`.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(
467         address target,
468         bytes memory data,
469         uint256 value
470     ) internal returns (bytes memory) {
471         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
476      * with `errorMessage` as a fallback revert reason when `target` reverts.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value,
484         string memory errorMessage
485     ) internal returns (bytes memory) {
486         require(address(this).balance >= value, "Address: insufficient balance for call");
487         require(isContract(target), "Address: call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.call{value: value}(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
500         return functionStaticCall(target, data, "Address: low-level static call failed");
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(
510         address target,
511         bytes memory data,
512         string memory errorMessage
513     ) internal view returns (bytes memory) {
514         require(isContract(target), "Address: static call to non-contract");
515 
516         (bool success, bytes memory returndata) = target.staticcall(data);
517         return verifyCallResult(success, returndata, errorMessage);
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
527         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
532      * but performing a delegate call.
533      *
534      * _Available since v3.4._
535      */
536     function functionDelegateCall(
537         address target,
538         bytes memory data,
539         string memory errorMessage
540     ) internal returns (bytes memory) {
541         require(isContract(target), "Address: delegate call to non-contract");
542 
543         (bool success, bytes memory returndata) = target.delegatecall(data);
544         return verifyCallResult(success, returndata, errorMessage);
545     }
546 
547     /**
548      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
549      * revert reason using the provided one.
550      *
551      * _Available since v4.3._
552      */
553     function verifyCallResult(
554         bool success,
555         bytes memory returndata,
556         string memory errorMessage
557     ) internal pure returns (bytes memory) {
558         if (success) {
559             return returndata;
560         } else {
561             // Look for revert reason and bubble it up if present
562             if (returndata.length > 0) {
563                 // The easiest way to bubble the revert reason is using memory via assembly
564 
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 }
575 
576 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
577 
578 
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
585  * @dev See https://eips.ethereum.org/EIPS/eip-721
586  */
587 interface IERC721Metadata is IERC721 {
588     /**
589      * @dev Returns the token collection name.
590      */
591     function name() external view returns (string memory);
592 
593     /**
594      * @dev Returns the token collection symbol.
595      */
596     function symbol() external view returns (string memory);
597 
598     /**
599      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
600      */
601     function tokenURI(uint256 tokenId) external view returns (string memory);
602 }
603 
604 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
605 
606 
607 
608 pragma solidity ^0.8.0;
609 
610 /**
611  * @title ERC721 token receiver interface
612  * @dev Interface for any contract that wants to support safeTransfers
613  * from ERC721 asset contracts.
614  */
615 interface IERC721Receiver {
616     /**
617      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
618      * by `operator` from `from`, this function is called.
619      *
620      * It must return its Solidity selector to confirm the token transfer.
621      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
622      *
623      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
624      */
625     function onERC721Received(
626         address operator,
627         address from,
628         uint256 tokenId,
629         bytes calldata data
630     ) external returns (bytes4);
631 }
632 
633 // File: @openzeppelin/contracts/utils/Context.sol
634 pragma solidity ^0.8.0;
635 /**
636  * @dev Provides information about the current execution context, including the
637  * sender of the transaction and its data. While these are generally available
638  * via msg.sender and msg.data, they should not be accessed in such a direct
639  * manner, since when dealing with meta-transactions the account sending and
640  * paying for execution may not be the actual sender (as far as an application
641  * is concerned).
642  *
643  * This contract is only required for intermediate, library-like contracts.
644  */
645 abstract contract Context {
646     function _msgSender() internal view virtual returns (address) {
647         return msg.sender;
648     }
649 
650     function _msgData() internal view virtual returns (bytes calldata) {
651         return msg.data;
652     }
653 }
654 
655 
656 /**
657  * @title nonReentrant module to prevent recursive calling of functions
658  * @dev See https://medium.com/coinmonks/protect-your-solidity-smart-contracts-from-reentrancy-attacks-9972c3af7c21
659  */
660  
661 abstract contract nonReentrant {
662     bool private _reentryKey = false;
663     modifier reentryLock {
664         require(!_reentryKey, "cannot reenter a locked function");
665         _reentryKey = true;
666         _;
667         _reentryKey = false;
668     }
669 }
670 
671 
672 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
673 pragma solidity ^0.8.0;
674 /**
675  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
676  * the Metadata extension, but not including the Enumerable extension, which is available separately as
677  * {ERC721Enumerable}.
678  */
679 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
680     using Address for address;
681     using Strings for uint256;
682 
683     // Token name
684     string private _name;
685 
686     // Token symbol
687     string private _symbol;
688 
689     // owner address list (replaces default mappings)
690     address[] internal _owners;
691 
692     // Mapping from token ID to approved address
693     mapping(uint256 => address) private _tokenApprovals;
694 
695     // Mapping from owner to operator approvals
696     mapping(address => mapping(address => bool)) private _operatorApprovals;
697 
698     /**
699      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
700      */
701     constructor(string memory name_, string memory symbol_) {
702         _name = name_;
703         _symbol = symbol_;
704     }
705 
706     /**
707      * @dev See {IERC165-supportsInterface}.
708      */
709     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
710         return
711             interfaceId == type(IERC721).interfaceId ||
712             interfaceId == type(IERC721Metadata).interfaceId ||
713             super.supportsInterface(interfaceId);
714     }
715 
716     /**
717      * @dev See {IERC721-balanceOf}.
718      */
719     function balanceOf(address owner) public view virtual override returns (uint256) {
720         require(owner != address(0), "ERC721: balance query for the zero address");
721 		uint256 _ownerBalance = 0;
722 		for(uint i = 0; i < _owners.length; i++) {
723 			if(_owners[i] == owner) _ownerBalance ++;
724 		}
725         return _ownerBalance;
726     }
727 
728     /**
729      * @dev See {IERC721-ownerOf}.
730      */
731     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
732         address owner = _owners[tokenId];
733         require(owner != address(0), "ERC721: owner query for nonexistent token");
734         return owner;
735     }
736 
737     /**
738      * @dev See {IERC721Metadata-name}.
739      */
740     function name() public view virtual override returns (string memory) {
741         return _name;
742     }
743 
744     /**
745      * @dev See {IERC721Metadata-symbol}.
746      */
747     function symbol() public view virtual override returns (string memory) {
748         return _symbol;
749     }
750 
751     /**
752      * @dev See {IERC721Metadata-tokenURI}.
753      */
754     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
755         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
756 
757         string memory baseURI = _baseURI();
758         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
759     }
760 
761     /**
762      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
763      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
764      * by default, can be overriden in child contracts.
765      */
766     function _baseURI() internal view virtual returns (string memory) {
767         return "";
768     }
769 
770     /**
771      * @dev See {IERC721-approve}.
772      */
773     function approve(address to, uint256 tokenId) public virtual override {
774         address owner = ERC721.ownerOf(tokenId);
775         require(to != owner, "ERC721: approval to current owner");
776 
777         require(
778             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
779             "ERC721: approve caller is not owner nor approved for all"
780         );
781 
782         _approve(to, tokenId);
783     }
784 
785     /**
786      * @dev See {IERC721-getApproved}.
787      */
788     function getApproved(uint256 tokenId) public view virtual override returns (address) {
789         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
790 
791         return _tokenApprovals[tokenId];
792     }
793 
794     /**
795      * @dev See {IERC721-setApprovalForAll}.
796      */
797     function setApprovalForAll(address operator, bool approved) public virtual override {
798         require(operator != _msgSender(), "ERC721: approve to caller");
799 
800         _operatorApprovals[_msgSender()][operator] = approved;
801         emit ApprovalForAll(_msgSender(), operator, approved);
802     }
803 
804     /**
805      * @dev See {IERC721-isApprovedForAll}.
806      */
807     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
808         return _operatorApprovals[owner][operator];
809     }
810 
811     /**
812      * @dev See {IERC721-transferFrom}.
813      */
814     function transferFrom(
815         address from,
816         address to,
817         uint256 tokenId
818     ) public virtual override {
819         //solhint-disable-next-line max-line-length
820         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
821 
822         _transfer(from, to, tokenId);
823     }
824 
825     /**
826      * @dev See {IERC721-safeTransferFrom}.
827      */
828     function safeTransferFrom(
829         address from,
830         address to,
831         uint256 tokenId
832     ) public virtual override {
833         safeTransferFrom(from, to, tokenId, "");
834     }
835 
836     /**
837      * @dev See {IERC721-safeTransferFrom}.
838      */
839     function safeTransferFrom(
840         address from,
841         address to,
842         uint256 tokenId,
843         bytes memory _data
844     ) public virtual override {
845         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
846         _safeTransfer(from, to, tokenId, _data);
847     }
848 
849     /**
850      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
851      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
852      *
853      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
854      *
855      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
856      * implement alternative mechanisms to perform token transfer, such as signature-based.
857      *
858      * Requirements:
859      *
860      * - `from` cannot be the zero address.
861      * - `to` cannot be the zero address.
862      * - `tokenId` token must exist and be owned by `from`.
863      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
864      *
865      * Emits a {Transfer} event.
866      */
867     function _safeTransfer(
868         address from,
869         address to,
870         uint256 tokenId,
871         bytes memory _data
872     ) internal virtual {
873         _transfer(from, to, tokenId);
874         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
875     }
876 
877     /**
878      * @dev Returns whether `tokenId` exists.
879      *
880      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
881      *
882      * Tokens start existing when they are minted (`_mint`),
883      * and stop existing when they are burned (`_burn`).
884      */
885     function _exists(uint256 tokenId) internal view virtual returns (bool) {
886         return tokenId < _owners.length && _owners[tokenId] != address(0);
887     }
888 
889     /**
890      * @dev Returns whether `spender` is allowed to manage `tokenId`.
891      *
892      * Requirements:
893      *
894      * - `tokenId` must exist.
895      */
896     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
897         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
898         address owner = ERC721.ownerOf(tokenId);
899         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
900     }
901 
902     /**
903      * @dev Safely mints `tokenId` and transfers it to `to`.
904      *
905      * Requirements:
906      *
907      * - `tokenId` must not exist.
908      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
909      *
910      * Emits a {Transfer} event.
911      */
912     function _safeMint(address to, uint256 tokenId) internal virtual {
913         _safeMint(to, tokenId, "");
914     }
915 
916     /**
917      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
918      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
919      */
920     function _safeMint(
921         address to,
922         uint256 tokenId,
923         bytes memory _data
924     ) internal virtual {
925         _mint(to, tokenId);
926         require(
927             _checkOnERC721Received(address(0), to, tokenId, _data),
928             "ERC721: transfer to non ERC721Receiver implementer"
929         );
930     }
931 
932     /**
933      * @dev Mints `tokenId` and transfers it to `to`.
934      *
935      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
936      *
937      * Requirements:
938      *
939      * - `tokenId` must not exist.
940      * - `to` cannot be the zero address.
941      *
942      * Emits a {Transfer} event.
943      */
944     function _mint(address to, uint256 tokenId) internal virtual {
945         require(to != address(0), "ERC721: mint to the zero address");
946         require(!_exists(tokenId), "ERC721: token already minted");
947 
948         _beforeTokenTransfer(address(0), to, tokenId);
949 
950         _owners.push(to);
951 
952         emit Transfer(address(0), to, tokenId);
953     }
954 
955     /**
956      * @dev Destroys `tokenId`.
957      * The approval is cleared when the token is burned.
958      *
959      * Requirements:
960      *
961      * - `tokenId` must exist.
962      *
963      * Emits a {Transfer} event.
964      */
965     function _burn(uint256 tokenId) internal virtual {
966         address owner = ERC721.ownerOf(tokenId);
967 
968         _beforeTokenTransfer(owner, address(0), tokenId);
969 
970         // Clear approvals
971         _approve(address(0), tokenId);
972 
973         _owners[tokenId] = address(0);
974 
975         emit Transfer(owner, address(0), tokenId);
976     }
977 
978     /**
979      * @dev Transfers `tokenId` from `from` to `to`.
980      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
981      *
982      * Requirements:
983      *
984      * - `to` cannot be the zero address.
985      * - `tokenId` token must be owned by `from`.
986      *
987      * Emits a {Transfer} event.
988      */
989     function _transfer(
990         address from,
991         address to,
992         uint256 tokenId
993     ) internal virtual {
994         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
995         require(to != address(0), "ERC721: transfer to the zero address");
996 
997         _beforeTokenTransfer(from, to, tokenId);
998 
999         // Clear approvals from the previous owner
1000         _approve(address(0), tokenId);
1001 
1002         _owners[tokenId] = to;
1003 
1004         emit Transfer(from, to, tokenId);
1005     }
1006 
1007     /**
1008      * @dev Approve `to` to operate on `tokenId`
1009      *
1010      * Emits a {Approval} event.
1011      */
1012     function _approve(address to, uint256 tokenId) internal virtual {
1013         _tokenApprovals[tokenId] = to;
1014         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1019      * The call is not executed if the target address is not a contract.
1020      *
1021      * @param from address representing the previous owner of the given token ID
1022      * @param to target address that will receive the tokens
1023      * @param tokenId uint256 ID of the token to be transferred
1024      * @param _data bytes optional data to send along with the call
1025      * @return bool whether the call correctly returned the expected magic value
1026      */
1027     function _checkOnERC721Received(
1028         address from,
1029         address to,
1030         uint256 tokenId,
1031         bytes memory _data
1032     ) private returns (bool) {
1033         if (to.isContract()) {
1034             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1035                 return retval == IERC721Receiver.onERC721Received.selector;
1036             } catch (bytes memory reason) {
1037                 if (reason.length == 0) {
1038                     revert("ERC721: transfer to non ERC721Receiver implementer");
1039                 } else {
1040                     assembly {
1041                         revert(add(32, reason), mload(reason))
1042                     }
1043                 }
1044             }
1045         } else {
1046             return true;
1047         }
1048     }
1049 
1050     /**
1051      * @dev Hook that is called before any token transfer. This includes minting
1052      * and burning.
1053      *
1054      * Calling conditions:
1055      *
1056      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1057      * transferred to `to`.
1058      * - When `from` is zero, `tokenId` will be minted for `to`.
1059      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1060      * - `from` and `to` are never both zero.
1061      *
1062      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1063      */
1064     function _beforeTokenTransfer(
1065         address from,
1066         address to,
1067         uint256 tokenId
1068     ) internal virtual {}
1069 }
1070 
1071 
1072 
1073 
1074 
1075 
1076 
1077 /**
1078  * borrowed from Nuclear Nerds implementation
1079  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1080  * enumerability of all the token ids in the contract as well as all token ids owned by each
1081  * account but rips out the core of the gas-wasting processing that comes from OpenZeppelin.
1082  */
1083 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1084     /**
1085      * @dev See {IERC165-supportsInterface}.
1086      */
1087     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1088         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721Enumerable-totalSupply}.
1093      */
1094     function totalSupply() public view virtual override returns (uint256) {
1095         return _owners.length;
1096     }
1097 
1098     /**
1099      * @dev See {IERC721Enumerable-tokenByIndex}.
1100      */
1101     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1102         require(index < _owners.length, "ERC721Enumerable: global index out of bounds");
1103         return index;
1104     }
1105 
1106     /**
1107      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1108      */
1109     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256 tokenId) {
1110         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1111 
1112         uint count;
1113         for(uint i; i < _owners.length; i++){
1114             if(owner == _owners[i]){
1115                 if(count == index) return i;
1116                 else count++;
1117             }
1118         }
1119 
1120         revert("ERC721Enumerable: owner index out of bounds");
1121     }
1122 }
1123 
1124 
1125 // File: @openzeppelin/contracts/access/Ownable.sol
1126 pragma solidity ^0.8.0;
1127 /**
1128  * @dev Contract module which provides a basic access control mechanism, where
1129  * there is an account (an owner) that can be granted exclusive access to
1130  * specific functions.
1131  *
1132  * By default, the owner account will be the one that deploys the contract. This
1133  * can later be changed with {transferOwnership}.
1134  *
1135  * This module is used through inheritance. It will make available the modifier
1136  * `onlyOwner`, which can be applied to your functions to restrict their use to
1137  * the owner.
1138  */
1139 abstract contract Ownable is Context {
1140     address private _owner;
1141 
1142     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1143 
1144     /**
1145      * @dev Initializes the contract setting the deployer as the initial owner.
1146      */
1147     constructor() {
1148         _setOwner(_msgSender());
1149     }
1150 
1151     /**
1152      * @dev Returns the address of the current owner.
1153      */
1154     function owner() public view virtual returns (address) {
1155         return _owner;
1156     }
1157 
1158     /**
1159      * @dev Throws if called by any account other than the owner.
1160      */
1161     modifier onlyOwner() {
1162         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1163         _;
1164     }
1165 
1166     /**
1167      * @dev Leaves the contract without owner. It will not be possible to call
1168      * `onlyOwner` functions anymore. Can only be called by the current owner.
1169      *
1170      * NOTE: Renouncing ownership will leave the contract without an owner,
1171      * thereby removing any functionality that is only available to the owner.
1172      */
1173     function renounceOwnership() public virtual onlyOwner {
1174         _setOwner(address(0));
1175     }
1176 
1177     /**
1178      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1179      * Can only be called by the current owner.
1180      */
1181     function transferOwnership(address newOwner) public virtual onlyOwner {
1182         require(newOwner != address(0), "Ownable: new owner is the zero address");
1183         _setOwner(newOwner);
1184     }
1185 
1186     function _setOwner(address newOwner) private {
1187         address oldOwner = _owner;
1188         _owner = newOwner;
1189         emit OwnershipTransferred(oldOwner, newOwner);
1190     }
1191 }
1192 
1193 
1194 
1195 pragma solidity >=0.8.0 <0.9.0;
1196 
1197 contract StreetMeltsSociety is ERC721Enumerable, Ownable, nonReentrant {
1198   using Strings for uint256;
1199 
1200   string public baseURI;
1201   string public baseExtension = ".json";
1202   string public notRevealedUri;
1203   uint256 public cost = 0.06 ether;
1204   
1205   bytes32 public MerkleRoot;
1206   
1207   uint256 public constant maxSupply = 7777;
1208   
1209   uint256 public maxMintAmount = 10;
1210   uint256 public maxPresaleAmount = 3;
1211   bool public saleActive = false;
1212   bool public revealed = false;
1213 
1214   // borrowed from doggoverse by ngenator.eth
1215   struct OwnerMintCount {
1216 	uint128 presaleMinted;
1217 	uint128 freeClaims;
1218   }
1219   
1220   
1221   mapping(address => OwnerMintCount) public ownerMintCount;
1222 	
1223 
1224 
1225   constructor(
1226     string memory _name,
1227     string memory _symbol,
1228     string memory _initBaseURI,
1229     string memory _initNotRevealedUri
1230   ) ERC721(_name, _symbol) {
1231     setBaseURI(_initBaseURI);
1232     setNotRevealedURI(_initNotRevealedUri);
1233   }
1234 
1235   // internal
1236   function _baseURI() internal view virtual override returns (string memory) {
1237     return baseURI;
1238   }
1239 
1240   // public
1241   function mint(uint256 _mintAmount) public payable reentryLock {
1242     require(saleActive, "public sale is not active");
1243     uint256 supply = totalSupply();
1244     require(_mintAmount > 0, "need to mint at least 1 NFT");
1245     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1246     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1247 	
1248 	require(msg.value >= _mintAmount * cost, "not enough ETH sent");
1249 
1250     for (uint256 i = 0; i < _mintAmount; i++) {
1251       _safeMint(msg.sender, supply + i);
1252     }
1253   }
1254   
1255   function mintPresale(bytes32[] memory _proof, bytes1 _maxAmountKey, uint256 _mintAmount) public payable reentryLock {
1256     require(MerkleRoot > 0x00, "claim period not started!");
1257     uint256 supply = totalSupply();
1258     require(supply + _mintAmount < maxSupply + 1, "max collection limit exceeded");
1259 	
1260 	bytes32 senderHash = keccak256(abi.encodePacked(msg.sender, _maxAmountKey));
1261     bool proven = MerkleProof.verify(_proof, MerkleRoot, senderHash);
1262 	require(proven, "unauthorized proof-key combo for sender");
1263 	
1264 	uint _maxAmount = uint8(_maxAmountKey);
1265 	if(msg.value == 0) {
1266 		// FREE MINT REQUEST
1267 		require(ownerMintCount[msg.sender].freeClaims + _mintAmount < _maxAmount + 1, "max free NFT claims exceeded");
1268 		ownerMintCount[msg.sender].freeClaims += uint128(_mintAmount);
1269 	} else {
1270 		// PRE-SALE
1271 		require(ownerMintCount[msg.sender].presaleMinted + _mintAmount < maxPresaleAmount + 1, "max NFT pre-sales exceeded");
1272 		require(msg.value >= _mintAmount * cost, "not enought ETH sent");
1273 		ownerMintCount[msg.sender].presaleMinted += uint128(_mintAmount);
1274 	}
1275 	
1276     for (uint256 i = 0; i < _mintAmount; i++) {
1277       _safeMint(msg.sender, supply + i);
1278     }
1279   }
1280   
1281   
1282   function checkProofWithKey(bytes32[] memory proof, bytes memory key) public view returns(bool) {
1283     bytes32 senderHash = keccak256(abi.encodePacked(msg.sender, key));
1284     bytes32 _MerkleRoot32 = MerkleRoot;
1285     bool proven = MerkleProof.verify(proof, _MerkleRoot32, senderHash);
1286     return proven;
1287   }
1288 
1289   
1290 
1291   function walletOfOwner(address _owner)
1292     public
1293     view
1294     returns (uint256[] memory)
1295   {
1296     uint256 ownerTokenCount = balanceOf(_owner);
1297     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1298     for (uint256 i; i < ownerTokenCount; i++) {
1299       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1300     }
1301     return tokenIds;
1302   }
1303 
1304   function tokenURI(uint256 tokenId)
1305     public
1306     view
1307     virtual
1308     override
1309     returns (string memory)
1310   {
1311     require(
1312       _exists(tokenId),
1313       "ERC721Metadata: URI query for nonexistent token"
1314     );
1315     
1316     if(revealed == false) {
1317         return notRevealedUri;
1318     }
1319 
1320     string memory currentBaseURI = _baseURI();
1321     return bytes(currentBaseURI).length > 0
1322         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1323         : "";
1324   }
1325 
1326   //only owner
1327   function flipSaleState() public onlyOwner {
1328     saleActive = !saleActive;
1329   }
1330   
1331   function flipReveal() public onlyOwner {
1332     revealed = !revealed;
1333   }
1334   
1335   function setMerkle_Root(bytes32 _MerkleRoot) public onlyOwner {
1336 	MerkleRoot = _MerkleRoot;
1337   }  
1338     
1339   function teamMint(address _receiver, uint256 _mintAmount) public payable onlyOwner {
1340     uint256 supply = totalSupply();
1341     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1342 
1343     for (uint256 i = 0; i < _mintAmount; i++) {
1344       _safeMint(_receiver, supply + i);
1345     }
1346   }
1347   
1348   // teamMint max = 136
1349     
1350   function setCost(uint256 _newCost) public onlyOwner {
1351     cost = _newCost;
1352   }
1353 
1354   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1355     maxMintAmount = _newmaxMintAmount;
1356   }
1357 
1358   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1359     baseURI = _newBaseURI;
1360   }
1361 
1362   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1363     baseExtension = _newBaseExtension;
1364   }
1365   
1366   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1367     notRevealedUri = _notRevealedURI;
1368   }
1369 
1370   function withdraw() public payable onlyOwner {
1371     (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
1372     require(success);
1373   }
1374 }