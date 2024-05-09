1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
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
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76 
77     /**
78      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
79      */
80     function toString(uint256 value) internal pure returns (string memory) {
81         // Inspired by OraclizeAPI's implementation - MIT licence
82         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
83 
84         if (value == 0) {
85             return "0";
86         }
87         uint256 temp = value;
88         uint256 digits;
89         while (temp != 0) {
90             digits++;
91             temp /= 10;
92         }
93         bytes memory buffer = new bytes(digits);
94         while (value != 0) {
95             digits -= 1;
96             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
97             value /= 10;
98         }
99         return string(buffer);
100     }
101 
102     /**
103      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
104      */
105     function toHexString(uint256 value) internal pure returns (string memory) {
106         if (value == 0) {
107             return "0x00";
108         }
109         uint256 temp = value;
110         uint256 length = 0;
111         while (temp != 0) {
112             length++;
113             temp >>= 8;
114         }
115         return toHexString(value, length);
116     }
117 
118     /**
119      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
120      */
121     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
122         bytes memory buffer = new bytes(2 * length + 2);
123         buffer[0] = "0";
124         buffer[1] = "x";
125         for (uint256 i = 2 * length + 1; i > 1; --i) {
126             buffer[i] = _HEX_SYMBOLS[value & 0xf];
127             value >>= 4;
128         }
129         require(value == 0, "Strings: hex length insufficient");
130         return string(buffer);
131     }
132 }
133 
134 // File: @openzeppelin/contracts/utils/Address.sol
135 
136 
137 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
138 
139 pragma solidity ^0.8.1;
140 
141 /**
142  * @dev Collection of functions related to the address type
143  */
144 library Address {
145     /**
146      * @dev Returns true if `account` is a contract.
147      *
148      * [IMPORTANT]
149      * ====
150      * It is unsafe to assume that an address for which this function returns
151      * false is an externally-owned account (EOA) and not a contract.
152      *
153      * Among others, `isContract` will return false for the following
154      * types of addresses:
155      *
156      *  - an externally-owned account
157      *  - a contract in construction
158      *  - an address where a contract will be created
159      *  - an address where a contract lived, but was destroyed
160      * ====
161      *
162      * [IMPORTANT]
163      * ====
164      * You shouldn't rely on `isContract` to protect against flash loan attacks!
165      *
166      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
167      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
168      * constructor.
169      * ====
170      */
171     function isContract(address account) internal view returns (bool) {
172         // This method relies on extcodesize/address.code.length, which returns 0
173         // for contracts in construction, since the code is only stored at the end
174         // of the constructor execution.
175 
176         return account.code.length > 0;
177     }
178 
179     /**
180      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
181      * `recipient`, forwarding all available gas and reverting on errors.
182      *
183      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
184      * of certain opcodes, possibly making contracts go over the 2300 gas limit
185      * imposed by `transfer`, making them unable to receive funds via
186      * `transfer`. {sendValue} removes this limitation.
187      *
188      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
189      *
190      * IMPORTANT: because control is transferred to `recipient`, care must be
191      * taken to not create reentrancy vulnerabilities. Consider using
192      * {ReentrancyGuard} or the
193      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
194      */
195     function sendValue(address payable recipient, uint256 amount) internal {
196         require(address(this).balance >= amount, "Address: insufficient balance");
197 
198         (bool success, ) = recipient.call{value: amount}("");
199         require(success, "Address: unable to send value, recipient may have reverted");
200     }
201 
202     /**
203      * @dev Performs a Solidity function call using a low level `call`. A
204      * plain `call` is an unsafe replacement for a function call: use this
205      * function instead.
206      *
207      * If `target` reverts with a revert reason, it is bubbled up by this
208      * function (like regular Solidity function calls).
209      *
210      * Returns the raw returned data. To convert to the expected return value,
211      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
212      *
213      * Requirements:
214      *
215      * - `target` must be a contract.
216      * - calling `target` with `data` must not revert.
217      *
218      * _Available since v3.1._
219      */
220     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
221         return functionCall(target, data, "Address: low-level call failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
226      * `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCall(
231         address target,
232         bytes memory data,
233         string memory errorMessage
234     ) internal returns (bytes memory) {
235         return functionCallWithValue(target, data, 0, errorMessage);
236     }
237 
238     /**
239      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
240      * but also transferring `value` wei to `target`.
241      *
242      * Requirements:
243      *
244      * - the calling contract must have an ETH balance of at least `value`.
245      * - the called Solidity function must be `payable`.
246      *
247      * _Available since v3.1._
248      */
249     function functionCallWithValue(
250         address target,
251         bytes memory data,
252         uint256 value
253     ) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
259      * with `errorMessage` as a fallback revert reason when `target` reverts.
260      *
261      * _Available since v3.1._
262      */
263     function functionCallWithValue(
264         address target,
265         bytes memory data,
266         uint256 value,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(address(this).balance >= value, "Address: insufficient balance for call");
270         require(isContract(target), "Address: call to non-contract");
271 
272         (bool success, bytes memory returndata) = target.call{value: value}(data);
273         return verifyCallResult(success, returndata, errorMessage);
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
278      * but performing a static call.
279      *
280      * _Available since v3.3._
281      */
282     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
283         return functionStaticCall(target, data, "Address: low-level static call failed");
284     }
285 
286     /**
287      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
288      * but performing a static call.
289      *
290      * _Available since v3.3._
291      */
292     function functionStaticCall(
293         address target,
294         bytes memory data,
295         string memory errorMessage
296     ) internal view returns (bytes memory) {
297         require(isContract(target), "Address: static call to non-contract");
298 
299         (bool success, bytes memory returndata) = target.staticcall(data);
300         return verifyCallResult(success, returndata, errorMessage);
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
305      * but performing a delegate call.
306      *
307      * _Available since v3.4._
308      */
309     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
310         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
315      * but performing a delegate call.
316      *
317      * _Available since v3.4._
318      */
319     function functionDelegateCall(
320         address target,
321         bytes memory data,
322         string memory errorMessage
323     ) internal returns (bytes memory) {
324         require(isContract(target), "Address: delegate call to non-contract");
325 
326         (bool success, bytes memory returndata) = target.delegatecall(data);
327         return verifyCallResult(success, returndata, errorMessage);
328     }
329 
330     /**
331      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
332      * revert reason using the provided one.
333      *
334      * _Available since v4.3._
335      */
336     function verifyCallResult(
337         bool success,
338         bytes memory returndata,
339         string memory errorMessage
340     ) internal pure returns (bytes memory) {
341         if (success) {
342             return returndata;
343         } else {
344             // Look for revert reason and bubble it up if present
345             if (returndata.length > 0) {
346                 // The easiest way to bubble the revert reason is using memory via assembly
347 
348                 assembly {
349                     let returndata_size := mload(returndata)
350                     revert(add(32, returndata), returndata_size)
351                 }
352             } else {
353                 revert(errorMessage);
354             }
355         }
356     }
357 }
358 
359 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
360 
361 
362 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
363 
364 pragma solidity ^0.8.0;
365 
366 /**
367  * @title ERC721 token receiver interface
368  * @dev Interface for any contract that wants to support safeTransfers
369  * from ERC721 asset contracts.
370  */
371 interface IERC721Receiver {
372     /**
373      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
374      * by `operator` from `from`, this function is called.
375      *
376      * It must return its Solidity selector to confirm the token transfer.
377      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
378      *
379      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
380      */
381     function onERC721Received(
382         address operator,
383         address from,
384         uint256 tokenId,
385         bytes calldata data
386     ) external returns (bytes4);
387 }
388 
389 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
390 
391 
392 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Interface of the ERC165 standard, as defined in the
398  * https://eips.ethereum.org/EIPS/eip-165[EIP].
399  *
400  * Implementers can declare support of contract interfaces, which can then be
401  * queried by others ({ERC165Checker}).
402  *
403  * For an implementation, see {ERC165}.
404  */
405 interface IERC165 {
406     /**
407      * @dev Returns true if this contract implements the interface defined by
408      * `interfaceId`. See the corresponding
409      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
410      * to learn more about how these ids are created.
411      *
412      * This function call must use less than 30 000 gas.
413      */
414     function supportsInterface(bytes4 interfaceId) external view returns (bool);
415 }
416 
417 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
418 
419 
420 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
421 
422 pragma solidity ^0.8.0;
423 
424 
425 /**
426  * @dev Implementation of the {IERC165} interface.
427  *
428  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
429  * for the additional interface id that will be supported. For example:
430  *
431  * ```solidity
432  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
433  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
434  * }
435  * ```
436  *
437  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
438  */
439 abstract contract ERC165 is IERC165 {
440     /**
441      * @dev See {IERC165-supportsInterface}.
442      */
443     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
444         return interfaceId == type(IERC165).interfaceId;
445     }
446 }
447 
448 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
449 
450 
451 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
452 
453 pragma solidity ^0.8.0;
454 
455 
456 /**
457  * @dev Required interface of an ERC721 compliant contract.
458  */
459 interface IERC721 is IERC165 {
460     /**
461      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
462      */
463     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
464 
465     /**
466      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
467      */
468     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
469 
470     /**
471      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
472      */
473     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
474 
475     /**
476      * @dev Returns the number of tokens in ``owner``'s account.
477      */
478     function balanceOf(address owner) external view returns (uint256 balance);
479 
480     /**
481      * @dev Returns the owner of the `tokenId` token.
482      *
483      * Requirements:
484      *
485      * - `tokenId` must exist.
486      */
487     function ownerOf(uint256 tokenId) external view returns (address owner);
488 
489     /**
490      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
491      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
492      *
493      * Requirements:
494      *
495      * - `from` cannot be the zero address.
496      * - `to` cannot be the zero address.
497      * - `tokenId` token must exist and be owned by `from`.
498      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
499      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
500      *
501      * Emits a {Transfer} event.
502      */
503     function safeTransferFrom(
504         address from,
505         address to,
506         uint256 tokenId
507     ) external;
508 
509     /**
510      * @dev Transfers `tokenId` token from `from` to `to`.
511      *
512      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
513      *
514      * Requirements:
515      *
516      * - `from` cannot be the zero address.
517      * - `to` cannot be the zero address.
518      * - `tokenId` token must be owned by `from`.
519      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
520      *
521      * Emits a {Transfer} event.
522      */
523     function transferFrom(
524         address from,
525         address to,
526         uint256 tokenId
527     ) external;
528 
529     /**
530      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
531      * The approval is cleared when the token is transferred.
532      *
533      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
534      *
535      * Requirements:
536      *
537      * - The caller must own the token or be an approved operator.
538      * - `tokenId` must exist.
539      *
540      * Emits an {Approval} event.
541      */
542     function approve(address to, uint256 tokenId) external;
543 
544     /**
545      * @dev Returns the account approved for `tokenId` token.
546      *
547      * Requirements:
548      *
549      * - `tokenId` must exist.
550      */
551     function getApproved(uint256 tokenId) external view returns (address operator);
552 
553     /**
554      * @dev Approve or remove `operator` as an operator for the caller.
555      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
556      *
557      * Requirements:
558      *
559      * - The `operator` cannot be the caller.
560      *
561      * Emits an {ApprovalForAll} event.
562      */
563     function setApprovalForAll(address operator, bool _approved) external;
564 
565     /**
566      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
567      *
568      * See {setApprovalForAll}
569      */
570     function isApprovedForAll(address owner, address operator) external view returns (bool);
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`.
574      *
575      * Requirements:
576      *
577      * - `from` cannot be the zero address.
578      * - `to` cannot be the zero address.
579      * - `tokenId` token must exist and be owned by `from`.
580      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
581      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
582      *
583      * Emits a {Transfer} event.
584      */
585     function safeTransferFrom(
586         address from,
587         address to,
588         uint256 tokenId,
589         bytes calldata data
590     ) external;
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
594 
595 
596 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
597 
598 pragma solidity ^0.8.0;
599 
600 
601 /**
602  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
603  * @dev See https://eips.ethereum.org/EIPS/eip-721
604  */
605 interface IERC721Enumerable is IERC721 {
606     /**
607      * @dev Returns the total amount of tokens stored by the contract.
608      */
609     function totalSupply() external view returns (uint256);
610 
611     /**
612      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
613      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
614      */
615     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
616 
617     /**
618      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
619      * Use along with {totalSupply} to enumerate all tokens.
620      */
621     function tokenByIndex(uint256 index) external view returns (uint256);
622 }
623 
624 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
625 
626 
627 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 
632 /**
633  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
634  * @dev See https://eips.ethereum.org/EIPS/eip-721
635  */
636 interface IERC721Metadata is IERC721 {
637     /**
638      * @dev Returns the token collection name.
639      */
640     function name() external view returns (string memory);
641 
642     /**
643      * @dev Returns the token collection symbol.
644      */
645     function symbol() external view returns (string memory);
646 
647     /**
648      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
649      */
650     function tokenURI(uint256 tokenId) external view returns (string memory);
651 }
652 
653 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
654 
655 
656 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
657 
658 pragma solidity ^0.8.0;
659 
660 /**
661  * @dev Contract module that helps prevent reentrant calls to a function.
662  *
663  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
664  * available, which can be applied to functions to make sure there are no nested
665  * (reentrant) calls to them.
666  *
667  * Note that because there is a single `nonReentrant` guard, functions marked as
668  * `nonReentrant` may not call one another. This can be worked around by making
669  * those functions `private`, and then adding `external` `nonReentrant` entry
670  * points to them.
671  *
672  * TIP: If you would like to learn more about reentrancy and alternative ways
673  * to protect against it, check out our blog post
674  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
675  */
676 abstract contract ReentrancyGuard {
677     // Booleans are more expensive than uint256 or any type that takes up a full
678     // word because each write operation emits an extra SLOAD to first read the
679     // slot's contents, replace the bits taken up by the boolean, and then write
680     // back. This is the compiler's defense against contract upgrades and
681     // pointer aliasing, and it cannot be disabled.
682 
683     // The values being non-zero value makes deployment a bit more expensive,
684     // but in exchange the refund on every call to nonReentrant will be lower in
685     // amount. Since refunds are capped to a percentage of the total
686     // transaction's gas, it is best to keep them low in cases like this one, to
687     // increase the likelihood of the full refund coming into effect.
688     uint256 private constant _NOT_ENTERED = 1;
689     uint256 private constant _ENTERED = 2;
690 
691     uint256 private _status;
692 
693     constructor() {
694         _status = _NOT_ENTERED;
695     }
696 
697     /**
698      * @dev Prevents a contract from calling itself, directly or indirectly.
699      * Calling a `nonReentrant` function from another `nonReentrant`
700      * function is not supported. It is possible to prevent this from happening
701      * by making the `nonReentrant` function external, and making it call a
702      * `private` function that does the actual work.
703      */
704     modifier nonReentrant() {
705         // On the first call to nonReentrant, _notEntered will be true
706         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
707 
708         // Any calls to nonReentrant after this point will fail
709         _status = _ENTERED;
710 
711         _;
712 
713         // By storing the original value once again, a refund is triggered (see
714         // https://eips.ethereum.org/EIPS/eip-2200)
715         _status = _NOT_ENTERED;
716     }
717 }
718 
719 // File: @openzeppelin/contracts/utils/Context.sol
720 
721 
722 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
723 
724 pragma solidity ^0.8.0;
725 
726 /**
727  * @dev Provides information about the current execution context, including the
728  * sender of the transaction and its data. While these are generally available
729  * via msg.sender and msg.data, they should not be accessed in such a direct
730  * manner, since when dealing with meta-transactions the account sending and
731  * paying for execution may not be the actual sender (as far as an application
732  * is concerned).
733  *
734  * This contract is only required for intermediate, library-like contracts.
735  */
736 abstract contract Context {
737     function _msgSender() internal view virtual returns (address) {
738         return msg.sender;
739     }
740 
741     function _msgData() internal view virtual returns (bytes calldata) {
742         return msg.data;
743     }
744 }
745 
746 // File: contracts/ERC721A.sol
747 
748 
749 // Creator: Chiru Labs
750 
751 pragma solidity ^0.8.4;
752 
753 
754 
755 
756 
757 
758 
759 
760 
761 error ApprovalCallerNotOwnerNorApproved();
762 error ApprovalQueryForNonexistentToken();
763 error ApproveToCaller();
764 error ApprovalToCurrentOwner();
765 error BalanceQueryForZeroAddress();
766 error MintedQueryForZeroAddress();
767 error BurnedQueryForZeroAddress();
768 error AuxQueryForZeroAddress();
769 error MintToZeroAddress();
770 error MintZeroQuantity();
771 error OwnerIndexOutOfBounds();
772 error OwnerQueryForNonexistentToken();
773 error TokenIndexOutOfBounds();
774 error TransferCallerNotOwnerNorApproved();
775 error TransferFromIncorrectOwner();
776 error TransferToNonERC721ReceiverImplementer();
777 error TransferToZeroAddress();
778 error URIQueryForNonexistentToken();
779 
780 /**
781  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
782  * the Metadata extension. Built to optimize for lower gas during batch mints.
783  *
784  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
785  *
786  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
787  *
788  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
789  */
790 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
791     using Address for address;
792     using Strings for uint256;
793 
794     // Compiler will pack this into a single 256bit word.
795     struct TokenOwnership {
796         // The address of the owner.
797         address addr;
798         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
799         uint64 startTimestamp;
800         // Whether the token has been burned.
801         bool burned;
802     }
803 
804     // Compiler will pack this into a single 256bit word.
805     struct AddressData {
806         // Realistically, 2**64-1 is more than enough.
807         uint64 balance;
808         // Keeps track of mint count with minimal overhead for tokenomics.
809         uint64 numberMinted;
810         // Keeps track of burn count with minimal overhead for tokenomics.
811         uint64 numberBurned;
812         // For miscellaneous variable(s) pertaining to the address
813         // (e.g. number of whitelist mint slots used).
814         // If there are multiple variables, please pack them into a uint64.
815         uint64 aux;
816     }
817 
818     // The tokenId of the next token to be minted.
819     uint256 internal _currentIndex;
820 
821     // The number of tokens burned.
822     uint256 internal _burnCounter;
823 
824     // Token name
825     string private _name;
826 
827     // Token symbol
828     string private _symbol;
829 
830     // Mapping from token ID to ownership details
831     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
832     mapping(uint256 => TokenOwnership) internal _ownerships;
833 
834     // Mapping owner address to address data
835     mapping(address => AddressData) private _addressData;
836 
837     // Mapping from token ID to approved address
838     mapping(uint256 => address) private _tokenApprovals;
839 
840     // Mapping from owner to operator approvals
841     mapping(address => mapping(address => bool)) private _operatorApprovals;
842 
843     constructor(string memory name_, string memory symbol_) {
844         _name = name_;
845         _symbol = symbol_;
846         _currentIndex = _startTokenId();
847     }
848 
849     /**
850      * To change the starting tokenId, please override this function.
851      */
852     function _startTokenId() internal view virtual returns (uint256) {
853         return 0;
854     }
855 
856     /**
857      * @dev See {IERC721Enumerable-totalSupply}.
858      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
859      */
860     function totalSupply() public view returns (uint256) {
861         // Counter underflow is impossible as _burnCounter cannot be incremented
862         // more than _currentIndex - _startTokenId() times
863         unchecked {
864             return _currentIndex - _burnCounter - _startTokenId();
865         }
866     }
867 
868     /**
869      * Returns the total amount of tokens minted in the contract.
870      */
871     function _totalMinted() internal view returns (uint256) {
872         // Counter underflow is impossible as _currentIndex does not decrement,
873         // and it is initialized to _startTokenId()
874         unchecked {
875             return _currentIndex - _startTokenId();
876         }
877     }
878 
879     /**
880      * @dev See {IERC165-supportsInterface}.
881      */
882     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
883         return
884             interfaceId == type(IERC721).interfaceId ||
885             interfaceId == type(IERC721Metadata).interfaceId ||
886             super.supportsInterface(interfaceId);
887     }
888 
889     /**
890      * @dev See {IERC721-balanceOf}.
891      */
892     function balanceOf(address owner) public view override returns (uint256) {
893         if (owner == address(0)) revert BalanceQueryForZeroAddress();
894         return uint256(_addressData[owner].balance);
895     }
896 
897     /**
898      * Returns the number of tokens minted by `owner`.
899      */
900     function _numberMinted(address owner) internal view returns (uint256) {
901         if (owner == address(0)) revert MintedQueryForZeroAddress();
902         return uint256(_addressData[owner].numberMinted);
903     }
904 
905     /**
906      * Returns the number of tokens burned by or on behalf of `owner`.
907      */
908     function _numberBurned(address owner) internal view returns (uint256) {
909         if (owner == address(0)) revert BurnedQueryForZeroAddress();
910         return uint256(_addressData[owner].numberBurned);
911     }
912 
913     /**
914      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
915      */
916     function _getAux(address owner) internal view returns (uint64) {
917         if (owner == address(0)) revert AuxQueryForZeroAddress();
918         return _addressData[owner].aux;
919     }
920 
921     /**
922      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
923      * If there are multiple variables, please pack them into a uint64.
924      */
925     function _setAux(address owner, uint64 aux) internal {
926         if (owner == address(0)) revert AuxQueryForZeroAddress();
927         _addressData[owner].aux = aux;
928     }
929 
930     /**
931      * Gas spent here starts off proportional to the maximum mint batch size.
932      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
933      */
934     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
935         uint256 curr = tokenId;
936 
937         unchecked {
938             if (_startTokenId() <= curr && curr < _currentIndex) {
939                 TokenOwnership memory ownership = _ownerships[curr];
940                 if (!ownership.burned) {
941                     if (ownership.addr != address(0)) {
942                         return ownership;
943                     }
944                     // Invariant:
945                     // There will always be an ownership that has an address and is not burned
946                     // before an ownership that does not have an address and is not burned.
947                     // Hence, curr will not underflow.
948                     while (true) {
949                         curr--;
950                         ownership = _ownerships[curr];
951                         if (ownership.addr != address(0)) {
952                             return ownership;
953                         }
954                     }
955                 }
956             }
957         }
958         revert OwnerQueryForNonexistentToken();
959     }
960 
961     /**
962      * @dev See {IERC721-ownerOf}.
963      */
964     function ownerOf(uint256 tokenId) public view override returns (address) {
965         return ownershipOf(tokenId).addr;
966     }
967 
968     /**
969      * @dev See {IERC721Metadata-name}.
970      */
971     function name() public view virtual override returns (string memory) {
972         return _name;
973     }
974 
975     /**
976      * @dev See {IERC721Metadata-symbol}.
977      */
978     function symbol() public view virtual override returns (string memory) {
979         return _symbol;
980     }
981 
982     /**
983      * @dev See {IERC721Metadata-tokenURI}.
984      */
985     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
986         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
987 
988         string memory baseURI = _baseURI();
989         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
990     }
991 
992     /**
993      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
994      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
995      * by default, can be overriden in child contracts.
996      */
997     function _baseURI() internal view virtual returns (string memory) {
998         return '';
999     }
1000 
1001     /**
1002      * @dev See {IERC721-approve}.
1003      */
1004     function approve(address to, uint256 tokenId) public override {
1005         address owner = ERC721A.ownerOf(tokenId);
1006         if (to == owner) revert ApprovalToCurrentOwner();
1007 
1008         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1009             revert ApprovalCallerNotOwnerNorApproved();
1010         }
1011 
1012         _approve(to, tokenId, owner);
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-getApproved}.
1017      */
1018     function getApproved(uint256 tokenId) public view override returns (address) {
1019         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1020 
1021         return _tokenApprovals[tokenId];
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-setApprovalForAll}.
1026      */
1027     function setApprovalForAll(address operator, bool approved) public virtual override {
1028         if (operator == _msgSender()) revert ApproveToCaller();
1029 
1030         _operatorApprovals[_msgSender()][operator] = approved;
1031         emit ApprovalForAll(_msgSender(), operator, approved);
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-isApprovedForAll}.
1036      */
1037     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1038         return _operatorApprovals[owner][operator];
1039     }
1040 
1041     /**
1042      * @dev See {IERC721-transferFrom}.
1043      */
1044     function transferFrom(
1045         address from,
1046         address to,
1047         uint256 tokenId
1048     ) public virtual override {
1049         _transfer(from, to, tokenId);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-safeTransferFrom}.
1054      */
1055     function safeTransferFrom(
1056         address from,
1057         address to,
1058         uint256 tokenId
1059     ) public virtual override {
1060         safeTransferFrom(from, to, tokenId, '');
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-safeTransferFrom}.
1065      */
1066     function safeTransferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId,
1070         bytes memory _data
1071     ) public virtual override {
1072         _transfer(from, to, tokenId);
1073         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1074             revert TransferToNonERC721ReceiverImplementer();
1075         }
1076     }
1077 
1078     /**
1079      * @dev Returns whether `tokenId` exists.
1080      *
1081      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1082      *
1083      * Tokens start existing when they are minted (`_mint`),
1084      */
1085     function _exists(uint256 tokenId) internal view returns (bool) {
1086         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1087             !_ownerships[tokenId].burned;
1088     }
1089 
1090     function _safeMint(address to, uint256 quantity) internal {
1091         _safeMint(to, quantity, '');
1092     }
1093 
1094     /**
1095      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1096      *
1097      * Requirements:
1098      *
1099      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1100      * - `quantity` must be greater than 0.
1101      *
1102      * Emits a {Transfer} event.
1103      */
1104     function _safeMint(
1105         address to,
1106         uint256 quantity,
1107         bytes memory _data
1108     ) internal {
1109         _mint(to, quantity, _data, true);
1110     }
1111 
1112     /**
1113      * @dev Mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `to` cannot be the zero address.
1118      * - `quantity` must be greater than 0.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _mint(
1123         address to,
1124         uint256 quantity,
1125         bytes memory _data,
1126         bool safe
1127     ) internal {
1128         uint256 startTokenId = _currentIndex;
1129         if (to == address(0)) revert MintToZeroAddress();
1130         if (quantity == 0) revert MintZeroQuantity();
1131 
1132         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1133 
1134         // Overflows are incredibly unrealistic.
1135         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1136         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1137         unchecked {
1138             _addressData[to].balance += uint64(quantity);
1139             _addressData[to].numberMinted += uint64(quantity);
1140 
1141             _ownerships[startTokenId].addr = to;
1142             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1143 
1144             uint256 updatedIndex = startTokenId;
1145             uint256 end = updatedIndex + quantity;
1146 
1147             if (safe && to.isContract()) {
1148                 do {
1149                     emit Transfer(address(0), to, updatedIndex);
1150                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1151                         revert TransferToNonERC721ReceiverImplementer();
1152                     }
1153                 } while (updatedIndex != end);
1154                 // Reentrancy protection
1155                 if (_currentIndex != startTokenId) revert();
1156             } else {
1157                 do {
1158                     emit Transfer(address(0), to, updatedIndex++);
1159                 } while (updatedIndex != end);
1160             }
1161             _currentIndex = updatedIndex;
1162         }
1163         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1164     }
1165 
1166     /**
1167      * @dev Transfers `tokenId` from `from` to `to`.
1168      *
1169      * Requirements:
1170      *
1171      * - `to` cannot be the zero address.
1172      * - `tokenId` token must be owned by `from`.
1173      *
1174      * Emits a {Transfer} event.
1175      */
1176     function _transfer(
1177         address from,
1178         address to,
1179         uint256 tokenId
1180     ) private {
1181         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1182 
1183         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1184             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1185             getApproved(tokenId) == _msgSender());
1186 
1187         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1188         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1189         if (to == address(0)) revert TransferToZeroAddress();
1190 
1191         _beforeTokenTransfers(from, to, tokenId, 1);
1192 
1193         // Clear approvals from the previous owner
1194         _approve(address(0), tokenId, prevOwnership.addr);
1195 
1196         // Underflow of the sender's balance is impossible because we check for
1197         // ownership above and the recipient's balance can't realistically overflow.
1198         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1199         unchecked {
1200             _addressData[from].balance -= 1;
1201             _addressData[to].balance += 1;
1202 
1203             _ownerships[tokenId].addr = to;
1204             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1205 
1206             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1207             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1208             uint256 nextTokenId = tokenId + 1;
1209             if (_ownerships[nextTokenId].addr == address(0)) {
1210                 // This will suffice for checking _exists(nextTokenId),
1211                 // as a burned slot cannot contain the zero address.
1212                 if (nextTokenId < _currentIndex) {
1213                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1214                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1215                 }
1216             }
1217         }
1218 
1219         emit Transfer(from, to, tokenId);
1220         _afterTokenTransfers(from, to, tokenId, 1);
1221     }
1222 
1223     /**
1224      * @dev Destroys `tokenId`.
1225      * The approval is cleared when the token is burned.
1226      *
1227      * Requirements:
1228      *
1229      * - `tokenId` must exist.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _burn(uint256 tokenId) internal virtual {
1234         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1235 
1236         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1237 
1238         // Clear approvals from the previous owner
1239         _approve(address(0), tokenId, prevOwnership.addr);
1240 
1241         // Underflow of the sender's balance is impossible because we check for
1242         // ownership above and the recipient's balance can't realistically overflow.
1243         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1244         unchecked {
1245             _addressData[prevOwnership.addr].balance -= 1;
1246             _addressData[prevOwnership.addr].numberBurned += 1;
1247 
1248             // Keep track of who burned the token, and the timestamp of burning.
1249             _ownerships[tokenId].addr = prevOwnership.addr;
1250             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1251             _ownerships[tokenId].burned = true;
1252 
1253             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1254             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1255             uint256 nextTokenId = tokenId + 1;
1256             if (_ownerships[nextTokenId].addr == address(0)) {
1257                 // This will suffice for checking _exists(nextTokenId),
1258                 // as a burned slot cannot contain the zero address.
1259                 if (nextTokenId < _currentIndex) {
1260                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1261                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1262                 }
1263             }
1264         }
1265 
1266         emit Transfer(prevOwnership.addr, address(0), tokenId);
1267         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1268 
1269         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1270         unchecked {
1271             _burnCounter++;
1272         }
1273     }
1274 
1275     /**
1276      * @dev Approve `to` to operate on `tokenId`
1277      *
1278      * Emits a {Approval} event.
1279      */
1280     function _approve(
1281         address to,
1282         uint256 tokenId,
1283         address owner
1284     ) private {
1285         _tokenApprovals[tokenId] = to;
1286         emit Approval(owner, to, tokenId);
1287     }
1288 
1289     /**
1290      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1291      *
1292      * @param from address representing the previous owner of the given token ID
1293      * @param to target address that will receive the tokens
1294      * @param tokenId uint256 ID of the token to be transferred
1295      * @param _data bytes optional data to send along with the call
1296      * @return bool whether the call correctly returned the expected magic value
1297      */
1298     function _checkContractOnERC721Received(
1299         address from,
1300         address to,
1301         uint256 tokenId,
1302         bytes memory _data
1303     ) private returns (bool) {
1304         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1305             return retval == IERC721Receiver(to).onERC721Received.selector;
1306         } catch (bytes memory reason) {
1307             if (reason.length == 0) {
1308                 revert TransferToNonERC721ReceiverImplementer();
1309             } else {
1310                 assembly {
1311                     revert(add(32, reason), mload(reason))
1312                 }
1313             }
1314         }
1315     }
1316 
1317     /**
1318      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1319      * And also called before burning one token.
1320      *
1321      * startTokenId - the first token id to be transferred
1322      * quantity - the amount to be transferred
1323      *
1324      * Calling conditions:
1325      *
1326      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1327      * transferred to `to`.
1328      * - When `from` is zero, `tokenId` will be minted for `to`.
1329      * - When `to` is zero, `tokenId` will be burned by `from`.
1330      * - `from` and `to` are never both zero.
1331      */
1332     function _beforeTokenTransfers(
1333         address from,
1334         address to,
1335         uint256 startTokenId,
1336         uint256 quantity
1337     ) internal virtual {}
1338 
1339     /**
1340      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1341      * minting.
1342      * And also called after one token has been burned.
1343      *
1344      * startTokenId - the first token id to be transferred
1345      * quantity - the amount to be transferred
1346      *
1347      * Calling conditions:
1348      *
1349      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1350      * transferred to `to`.
1351      * - When `from` is zero, `tokenId` has been minted for `to`.
1352      * - When `to` is zero, `tokenId` has been burned by `from`.
1353      * - `from` and `to` are never both zero.
1354      */
1355     function _afterTokenTransfers(
1356         address from,
1357         address to,
1358         uint256 startTokenId,
1359         uint256 quantity
1360     ) internal virtual {}
1361 }
1362 // File: @openzeppelin/contracts/access/Ownable.sol
1363 
1364 
1365 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1366 
1367 pragma solidity ^0.8.0;
1368 
1369 
1370 /**
1371  * @dev Contract module which provides a basic access control mechanism, where
1372  * there is an account (an owner) that can be granted exclusive access to
1373  * specific functions.
1374  *
1375  * By default, the owner account will be the one that deploys the contract. This
1376  * can later be changed with {transferOwnership}.
1377  *
1378  * This module is used through inheritance. It will make available the modifier
1379  * `onlyOwner`, which can be applied to your functions to restrict their use to
1380  * the owner.
1381  */
1382 abstract contract Ownable is Context {
1383     address private _owner;
1384 
1385     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1386 
1387     /**
1388      * @dev Initializes the contract setting the deployer as the initial owner.
1389      */
1390     constructor() {
1391         _transferOwnership(_msgSender());
1392     }
1393 
1394     /**
1395      * @dev Returns the address of the current owner.
1396      */
1397     function owner() public view virtual returns (address) {
1398         return _owner;
1399     }
1400 
1401     /**
1402      * @dev Throws if called by any account other than the owner.
1403      */
1404     modifier onlyOwner() {
1405         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1406         _;
1407     }
1408 
1409     /**
1410      * @dev Leaves the contract without owner. It will not be possible to call
1411      * `onlyOwner` functions anymore. Can only be called by the current owner.
1412      *
1413      * NOTE: Renouncing ownership will leave the contract without an owner,
1414      * thereby removing any functionality that is only available to the owner.
1415      */
1416     function renounceOwnership() public virtual onlyOwner {
1417         _transferOwnership(address(0));
1418     }
1419 
1420     /**
1421      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1422      * Can only be called by the current owner.
1423      */
1424     function transferOwnership(address newOwner) public virtual onlyOwner {
1425         require(newOwner != address(0), "Ownable: new owner is the zero address");
1426         _transferOwnership(newOwner);
1427     }
1428 
1429     /**
1430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1431      * Internal function without access restriction.
1432      */
1433     function _transferOwnership(address newOwner) internal virtual {
1434         address oldOwner = _owner;
1435         _owner = newOwner;
1436         emit OwnershipTransferred(oldOwner, newOwner);
1437     }
1438 }
1439 
1440 // File: contracts/Shinsekai.sol
1441 
1442 
1443 
1444 pragma solidity ^0.8.0;
1445 
1446 
1447 
1448 
1449 
1450 
1451 contract Shinsekai is Ownable, ERC721A, ReentrancyGuard {
1452     uint256 public immutable amountForTeam;
1453     uint private constant MAX_SUPPLY = 10000;
1454     uint private constant MAX_BATCH = 5;
1455     bytes32 public portalAccessRoot;
1456     bytes32 public reserveCorpRoot;
1457     bytes32 public publicRegistrationRoot;
1458     mapping(address => uint256) public portalAccessClaimed;
1459     mapping(address => bool) public portalAccessClaimedChecker;
1460     mapping(address => uint256) public reserveCorpClaimed;
1461     mapping(address => bool) public reserveCorpClaimedChecker;
1462     mapping(address => uint256) public publicRegistrationClaimed;
1463     mapping(address => bool) public publicRegistrationChecker;
1464     
1465 
1466     struct SaleConfig {
1467         uint32 publicSaleStartTime;
1468         uint32 publicSaleKey;
1469         uint64 portalAccessPrice;
1470         uint64 reserveCorpPrice;
1471         uint64 publicRegistrationPrice;
1472         uint64 publicPrice;
1473         
1474     }
1475 
1476     SaleConfig public saleConfig;
1477 
1478     constructor(
1479         uint256 amountForTeam_
1480     ) ERC721A("Shinsekai", "SSK") {
1481         
1482         amountForTeam = amountForTeam_;
1483         require(
1484             amountForTeam_ <= MAX_SUPPLY,
1485             "larger collection size needed"
1486         );
1487     }
1488 
1489     modifier callerIsUser() {
1490         require(tx.origin == msg.sender, "The caller is another contract");
1491         _;
1492     }
1493 
1494     function gift(address[] calldata receivers) external onlyOwner {
1495         require(totalSupply() + receivers.length <= MAX_SUPPLY, "MAX_MINT");
1496         for (uint256 i = 0; i < receivers.length; i++) {
1497             _safeMint(receivers[i], 1);
1498         }
1499     }
1500 
1501     function reserveGiveaway(uint256 num, address walletAddress)
1502         public
1503         onlyOwner
1504     {
1505         require(totalSupply() + num <= MAX_SUPPLY, "Exceeds total supply");
1506         _safeMint(walletAddress, num);
1507     }
1508 
1509     function portalAccess(bytes32[] calldata _merkleProof, uint256 quantity) external payable callerIsUser {
1510         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1511         require(MerkleProof.verify(_merkleProof, portalAccessRoot, leaf),
1512             "Invalid Merkle Proof.");
1513         uint256 price = uint256(saleConfig.portalAccessPrice);
1514         require(price != 0, "whitelist sale has not begun yet");
1515         require(totalSupply() + quantity <= 8000, "Exceeds total supply");
1516         if (!portalAccessClaimedChecker[msg.sender]) {
1517             portalAccessClaimedChecker[msg.sender] = true;
1518             portalAccessClaimed[msg.sender] = 2;
1519         }
1520         require(portalAccessClaimed[msg.sender] - quantity >= 0, "Address already minted num of tokens allowed");
1521         portalAccessClaimed[msg.sender] = portalAccessClaimed[msg.sender] - quantity;
1522         _safeMint(msg.sender, quantity);
1523         refundIfOver(price * quantity);
1524     }
1525 
1526 
1527     function reserveCorp(bytes32[] calldata _merkleProof, uint256 quantity) external payable callerIsUser {
1528         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1529         require(MerkleProof.verify(_merkleProof, reserveCorpRoot, leaf),
1530             "Invalid Merkle Proof.");
1531         uint256 price = uint256(saleConfig.reserveCorpPrice);
1532         require(price != 0, "whitelist sale has not begun yet");
1533         require(totalSupply() + quantity <= 9000, "Exceeds total supply");
1534         if (!reserveCorpClaimedChecker[msg.sender]) {
1535             reserveCorpClaimedChecker[msg.sender] = true;
1536             reserveCorpClaimed[msg.sender] = 2;
1537         }
1538         require(reserveCorpClaimed[msg.sender] - quantity >= 0, "Address already minted num of tokens allowed");
1539         reserveCorpClaimed[msg.sender] = reserveCorpClaimed[msg.sender] - quantity;
1540         _safeMint(msg.sender, quantity);
1541         refundIfOver(price * quantity);
1542     }
1543 
1544     function publicRegistration(bytes32[] calldata _merkleProof, uint256 quantity) external payable callerIsUser {
1545         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1546         require(MerkleProof.verify(_merkleProof, publicRegistrationRoot, leaf),
1547             "Invalid Merkle Proof.");
1548         uint256 price = uint256(saleConfig.publicRegistrationPrice);
1549         require(price != 0, "whitelist sale has not begun yet");
1550         require(totalSupply() + quantity <= MAX_SUPPLY, "Exceeds total supply");
1551         if (!publicRegistrationChecker[msg.sender]) {
1552             publicRegistrationChecker[msg.sender] = true;
1553             publicRegistrationClaimed[msg.sender] = 2;
1554         }
1555         require(publicRegistrationClaimed[msg.sender] - quantity >= 0, "Address already minted num of tokens allowed");
1556         publicRegistrationClaimed[msg.sender] = publicRegistrationClaimed[msg.sender] - quantity;
1557         _safeMint(msg.sender, quantity);
1558         refundIfOver(price * quantity);
1559     }
1560 
1561     function publicSaleMint(uint256 quantity, uint256 callerPublicSaleKey)
1562         external
1563         payable
1564         callerIsUser
1565     {
1566         SaleConfig memory config = saleConfig;
1567         uint256 publicSaleKey = uint256(config.publicSaleKey);
1568         uint256 publicPrice = uint256(config.publicPrice);
1569         uint256 publicSaleStartTime = uint256(config.publicSaleStartTime);
1570         require(
1571             publicSaleKey == callerPublicSaleKey,
1572             "called with incorrect public sale key"
1573         );
1574 
1575         require(
1576             isPublicSaleOn(publicPrice, publicSaleKey, publicSaleStartTime),
1577             "public sale has not begun yet"
1578         );
1579         require(
1580             totalSupply() + quantity <= MAX_SUPPLY,
1581             "reached max supply"
1582         );
1583        
1584         _safeMint(msg.sender, quantity);
1585         refundIfOver(publicPrice * quantity);
1586     }
1587 
1588     function refundIfOver(uint256 price) private {
1589         require(msg.value >= price, "Need to send more ETH.");
1590         if (msg.value > price) {
1591             payable(msg.sender).transfer(msg.value - price);
1592         }
1593     }
1594 
1595     function isPublicSaleOn(
1596         uint256 publicPriceWei,
1597         uint256 publicSaleKey,
1598         uint256 publicSaleStartTime
1599     ) public view returns (bool) {
1600         return
1601             publicPriceWei != 0 &&
1602             publicSaleKey != 0 &&
1603             block.timestamp >= publicSaleStartTime;
1604     }
1605 
1606     function setupSaleInfo(
1607         uint64 whitelistPriceWei2,
1608         uint64 whitelistPriceWei1,
1609         uint64 publicRegistrationPrice,
1610         uint64 publicPriceWei,
1611         uint32 publicSaleStartTime
1612     ) external onlyOwner {
1613         saleConfig = SaleConfig(
1614             publicSaleStartTime,
1615             saleConfig.publicSaleKey,
1616             whitelistPriceWei1,
1617             whitelistPriceWei2,
1618             publicRegistrationPrice,
1619             publicPriceWei
1620         );
1621     }
1622 
1623     function setPublicSaleKey(uint32 key) external onlyOwner {
1624         saleConfig.publicSaleKey = key;
1625     }
1626 
1627     function setPublicPrice(uint64 price) external onlyOwner {
1628         saleConfig.publicPrice = price;
1629     }
1630 
1631     function setPublicRegistrationPrice(uint64 price) external onlyOwner {
1632         saleConfig.publicRegistrationPrice = price;
1633     }
1634 
1635     function setPortalAccessPrice(uint64 price) external onlyOwner {
1636         saleConfig.portalAccessPrice = price;
1637     }
1638 
1639     function setReserveCorpPrice(uint64 price) external onlyOwner {
1640         saleConfig.reserveCorpPrice = price;
1641     }
1642 
1643     function setPublicSaleStartTime(uint32 time) external onlyOwner {
1644         saleConfig.publicSaleStartTime = time;
1645     }
1646 
1647     function setPortalAccessRoot(bytes32 merkle_root) external onlyOwner {
1648         portalAccessRoot = merkle_root;
1649     }
1650 
1651     function setPublicRegistrationRoot(bytes32 merkle_root) external onlyOwner {
1652         publicRegistrationRoot = merkle_root;
1653     }
1654 
1655     function setReserveCorpRoot(bytes32 merkle_root) external onlyOwner {
1656         reserveCorpRoot = merkle_root;
1657     }
1658 
1659     function teamMint(uint256 quantity, address walletAddress)
1660         external
1661         onlyOwner
1662     {
1663         require(
1664             totalSupply() + quantity <= amountForTeam,
1665             "too many already minted for team mint"
1666         );
1667         require(
1668             quantity % MAX_BATCH == 0,
1669             "can only mint a multiple of the MAX_BATCH"
1670         );
1671         uint256 numChunks = quantity / MAX_BATCH;
1672         for (uint256 i = 0; i < numChunks; i++) {
1673             _safeMint(walletAddress, MAX_BATCH);
1674         }
1675     }
1676 
1677     string private _baseTokenURI;
1678 
1679     function _baseURI() internal view virtual override returns (string memory) {
1680         return _baseTokenURI;
1681     }
1682 
1683     function setBaseURI(string calldata baseURI) external onlyOwner {
1684         _baseTokenURI = baseURI;
1685     }
1686 
1687     function withdraw() external onlyOwner nonReentrant {
1688         uint256 balance = address(this).balance;
1689 
1690         payable(0xa6Fc099Cc057b647B1E01562305D3e8150ADf847).transfer(
1691             balance
1692         );
1693     }
1694 
1695     function withdrawAmount(uint _amount) external onlyOwner nonReentrant {
1696         payable(0xa6Fc099Cc057b647B1E01562305D3e8150ADf847).transfer(_amount);
1697     }
1698 
1699     
1700 
1701     function numberMinted(address owner) public view returns (uint256) {
1702         return _numberMinted(owner);
1703     }
1704 
1705     function getOwnershipData(uint256 tokenId)
1706         external
1707         view
1708         returns (TokenOwnership memory)
1709     {
1710         return ownershipOf(tokenId);
1711     }
1712 }