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
749 
750 pragma solidity ^0.8.0;
751 
752 
753 
754 
755 
756 
757 
758 
759 
760 /**
761  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
762  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
763  *
764  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
765  *
766  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
767  *
768  * Does not support burning tokens to address(0).
769  */
770 contract ERC721A is
771   Context,
772   ERC165,
773   IERC721,
774   IERC721Metadata,
775   IERC721Enumerable
776 {
777   using Address for address;
778   using Strings for uint256;
779 
780   struct TokenOwnership {
781     address addr;
782     uint64 startTimestamp;
783   }
784 
785   struct AddressData {
786     uint128 balance;
787     uint128 numberMinted;
788   }
789 
790   uint256 private currentIndex = 0;
791   uint256 internal collectionSize;
792   uint256 internal maxBatchSize;
793 
794   // Token name
795   string private _name;
796 
797   // Token symbol
798   string private _symbol;
799 
800   // Mapping from token ID to ownership details
801   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
802   mapping(uint256 => TokenOwnership) private _ownerships;
803 
804   // Mapping owner address to address data
805   mapping(address => AddressData) private _addressData;
806 
807   // Mapping from token ID to approved address
808   mapping(uint256 => address) private _tokenApprovals;
809 
810   // Mapping from owner to operator approvals
811   mapping(address => mapping(address => bool)) private _operatorApprovals;
812 
813   /**
814    * @dev
815    * `maxBatchSize` refers to how much a minter can mint at a time.
816    * `collectionSize_` refers to how many tokens are in the collection.
817    */
818   constructor(
819     string memory name_,
820     string memory symbol_,
821     uint256 maxBatchSize_,
822     uint256 collectionSize_
823   ) {
824     require(
825       collectionSize_ > 0,
826       "ERC721A: collection must have a nonzero supply"
827     );
828     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
829     _name = name_;
830     _symbol = symbol_;
831     maxBatchSize = maxBatchSize_;
832     collectionSize = collectionSize_;
833   }
834 
835   function changeCollectionSize(uint256 newCollectionSize) public{
836     collectionSize = newCollectionSize;
837   }
838 
839   /**
840    * @dev See {IERC721Enumerable-totalSupply}.
841    */
842   function totalSupply() public view override returns (uint256) {
843     return currentIndex;
844   }
845 
846   /**
847    * @dev See {IERC721Enumerable-tokenByIndex}.
848    */
849   function tokenByIndex(uint256 index) public view override returns (uint256) {
850     require(index < totalSupply(), "ERC721A: global index out of bounds");
851     return index;
852   }
853 
854   /**
855    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
856    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
857    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
858    */
859   function tokenOfOwnerByIndex(address owner, uint256 index)
860     public
861     view
862     override
863     returns (uint256)
864   {
865     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
866     uint256 numMintedSoFar = totalSupply();
867     uint256 tokenIdsIdx = 0;
868     address currOwnershipAddr = address(0);
869     for (uint256 i = 0; i < numMintedSoFar; i++) {
870       TokenOwnership memory ownership = _ownerships[i];
871       if (ownership.addr != address(0)) {
872         currOwnershipAddr = ownership.addr;
873       }
874       if (currOwnershipAddr == owner) {
875         if (tokenIdsIdx == index) {
876           return i;
877         }
878         tokenIdsIdx++;
879       }
880     }
881     revert("ERC721A: unable to get token of owner by index");
882   }
883 
884   /**
885    * @dev See {IERC165-supportsInterface}.
886    */
887   function supportsInterface(bytes4 interfaceId)
888     public
889     view
890     virtual
891     override(ERC165, IERC165)
892     returns (bool)
893   {
894     return
895       interfaceId == type(IERC721).interfaceId ||
896       interfaceId == type(IERC721Metadata).interfaceId ||
897       interfaceId == type(IERC721Enumerable).interfaceId ||
898       super.supportsInterface(interfaceId);
899   }
900 
901   /**
902    * @dev See {IERC721-balanceOf}.
903    */
904   function balanceOf(address owner) public view override returns (uint256) {
905     require(owner != address(0), "ERC721A: balance query for the zero address");
906     return uint256(_addressData[owner].balance);
907   }
908 
909   function _numberMinted(address owner) internal view returns (uint256) {
910     require(
911       owner != address(0),
912       "ERC721A: number minted query for the zero address"
913     );
914     return uint256(_addressData[owner].numberMinted);
915   }
916 
917   function ownershipOf(uint256 tokenId)
918     internal
919     view
920     returns (TokenOwnership memory)
921   {
922     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
923 
924     uint256 lowestTokenToCheck;
925     if (tokenId >= maxBatchSize) {
926       lowestTokenToCheck = tokenId - maxBatchSize + 1;
927     }
928 
929     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
930       TokenOwnership memory ownership = _ownerships[curr];
931       if (ownership.addr != address(0)) {
932         return ownership;
933       }
934     }
935 
936     revert("ERC721A: unable to determine the owner of token");
937   }
938 
939   /**
940    * @dev See {IERC721-ownerOf}.
941    */
942   function ownerOf(uint256 tokenId) public view override returns (address) {
943     return ownershipOf(tokenId).addr;
944   }
945 
946   /**
947    * @dev See {IERC721Metadata-name}.
948    */
949   function name() public view virtual override returns (string memory) {
950     return _name;
951   }
952 
953   /**
954    * @dev See {IERC721Metadata-symbol}.
955    */
956   function symbol() public view virtual override returns (string memory) {
957     return _symbol;
958   }
959 
960   /**
961    * @dev See {IERC721Metadata-tokenURI}.
962    */
963   function tokenURI(uint256 tokenId)
964     public
965     view
966     virtual
967     override
968     returns (string memory)
969   {
970     require(
971       _exists(tokenId),
972       "ERC721Metadata: URI query for nonexistent token"
973     );
974 
975     string memory baseURI = _baseURI();
976     return
977       bytes(baseURI).length > 0
978         ? string(abi.encodePacked(baseURI, tokenId.toString()))
979         : "";
980   }
981 
982   /**
983    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
984    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
985    * by default, can be overriden in child contracts.
986    */
987   function _baseURI() internal view virtual returns (string memory) {
988     return "";
989   }
990 
991   /**
992    * @dev See {IERC721-approve}.
993    */
994   function approve(address to, uint256 tokenId) public override {
995     address owner = ERC721A.ownerOf(tokenId);
996     require(to != owner, "ERC721A: approval to current owner");
997 
998     require(
999       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1000       "ERC721A: approve caller is not owner nor approved for all"
1001     );
1002 
1003     _approve(to, tokenId, owner);
1004   }
1005 
1006   /**
1007    * @dev See {IERC721-getApproved}.
1008    */
1009   function getApproved(uint256 tokenId) public view override returns (address) {
1010     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1011 
1012     return _tokenApprovals[tokenId];
1013   }
1014 
1015   /**
1016    * @dev See {IERC721-setApprovalForAll}.
1017    */
1018   function setApprovalForAll(address operator, bool approved) public override {
1019     require(operator != _msgSender(), "ERC721A: approve to caller");
1020 
1021     _operatorApprovals[_msgSender()][operator] = approved;
1022     emit ApprovalForAll(_msgSender(), operator, approved);
1023   }
1024 
1025   /**
1026    * @dev See {IERC721-isApprovedForAll}.
1027    */
1028   function isApprovedForAll(address owner, address operator)
1029     public
1030     view
1031     virtual
1032     override
1033     returns (bool)
1034   {
1035     return _operatorApprovals[owner][operator];
1036   }
1037 
1038   /**
1039    * @dev See {IERC721-transferFrom}.
1040    */
1041   function transferFrom(
1042     address from,
1043     address to,
1044     uint256 tokenId
1045   ) public virtual override {
1046     _transfer(from, to, tokenId);
1047   }
1048 
1049   /**
1050    * @dev See {IERC721-safeTransferFrom}.
1051    */
1052   function safeTransferFrom(
1053     address from,
1054     address to,
1055     uint256 tokenId
1056   ) public virtual override {
1057     safeTransferFrom(from, to, tokenId, "");
1058   }
1059 
1060   /**
1061    * @dev See {IERC721-safeTransferFrom}.
1062    */
1063   function safeTransferFrom(
1064     address from,
1065     address to,
1066     uint256 tokenId,
1067     bytes memory _data
1068   ) public virtual override {
1069     _transfer(from, to, tokenId);
1070     require(
1071       _checkOnERC721Received(from, to, tokenId, _data),
1072       "ERC721A: transfer to non ERC721Receiver implementer"
1073     );
1074   }
1075 
1076   /**
1077    * @dev Returns whether `tokenId` exists.
1078    *
1079    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1080    *
1081    * Tokens start existing when they are minted (`_mint`),
1082    */
1083   function _exists(uint256 tokenId) internal view returns (bool) {
1084     return tokenId < currentIndex;
1085   }
1086 
1087   function _safeMint(address to, uint256 quantity) internal {
1088     _safeMint(to, quantity, "");
1089   }
1090 
1091   /**
1092    * @dev Mints `quantity` tokens and transfers them to `to`.
1093    *
1094    * Requirements:
1095    *
1096    * - there must be `quantity` tokens remaining unminted in the total collection.
1097    * - `to` cannot be the zero address.
1098    * - `quantity` cannot be larger than the max batch size.
1099    *
1100    * Emits a {Transfer} event.
1101    */
1102   function _safeMint(
1103     address to,
1104     uint256 quantity,
1105     bytes memory _data
1106   ) internal {
1107     uint256 startTokenId = currentIndex;
1108     require(to != address(0), "ERC721A: mint to the zero address");
1109     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1110     require(!_exists(startTokenId), "ERC721A: token already minted");
1111     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1112 
1113     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1114 
1115     AddressData memory addressData = _addressData[to];
1116     _addressData[to] = AddressData(
1117       addressData.balance + uint128(quantity),
1118       addressData.numberMinted + uint128(quantity)
1119     );
1120     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1121 
1122     uint256 updatedIndex = startTokenId;
1123 
1124     for (uint256 i = 0; i < quantity; i++) {
1125       emit Transfer(address(0), to, updatedIndex);
1126       require(
1127         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1128         "ERC721A: transfer to non ERC721Receiver implementer"
1129       );
1130       updatedIndex++;
1131     }
1132 
1133     currentIndex = updatedIndex;
1134     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1135   }
1136 
1137   /**
1138    * @dev Transfers `tokenId` from `from` to `to`.
1139    *
1140    * Requirements:
1141    *
1142    * - `to` cannot be the zero address.
1143    * - `tokenId` token must be owned by `from`.
1144    *
1145    * Emits a {Transfer} event.
1146    */
1147   function _transfer(
1148     address from,
1149     address to,
1150     uint256 tokenId
1151   ) private {
1152     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1153 
1154     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1155       getApproved(tokenId) == _msgSender() ||
1156       isApprovedForAll(prevOwnership.addr, _msgSender()));
1157 
1158     require(
1159       isApprovedOrOwner,
1160       "ERC721A: transfer caller is not owner nor approved"
1161     );
1162 
1163     require(
1164       prevOwnership.addr == from,
1165       "ERC721A: transfer from incorrect owner"
1166     );
1167     require(to != address(0), "ERC721A: transfer to the zero address");
1168 
1169     _beforeTokenTransfers(from, to, tokenId, 1);
1170 
1171     // Clear approvals from the previous owner
1172     _approve(address(0), tokenId, prevOwnership.addr);
1173 
1174     _addressData[from].balance -= 1;
1175     _addressData[to].balance += 1;
1176     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1177 
1178     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1179     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1180     uint256 nextTokenId = tokenId + 1;
1181     if (_ownerships[nextTokenId].addr == address(0)) {
1182       if (_exists(nextTokenId)) {
1183         _ownerships[nextTokenId] = TokenOwnership(
1184           prevOwnership.addr,
1185           prevOwnership.startTimestamp
1186         );
1187       }
1188     }
1189 
1190     emit Transfer(from, to, tokenId);
1191     _afterTokenTransfers(from, to, tokenId, 1);
1192   }
1193 
1194   /**
1195    * @dev Approve `to` to operate on `tokenId`
1196    *
1197    * Emits a {Approval} event.
1198    */
1199   function _approve(
1200     address to,
1201     uint256 tokenId,
1202     address owner
1203   ) private {
1204     _tokenApprovals[tokenId] = to;
1205     emit Approval(owner, to, tokenId);
1206   }
1207 
1208   uint256 public nextOwnerToExplicitlySet = 0;
1209 
1210   /**
1211    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1212    */
1213   function _setOwnersExplicit(uint256 quantity) internal {
1214     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1215     require(quantity > 0, "quantity must be nonzero");
1216     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1217     if (endIndex > collectionSize - 1) {
1218       endIndex = collectionSize - 1;
1219     }
1220     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1221     require(_exists(endIndex), "not enough minted yet for this cleanup");
1222     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1223       if (_ownerships[i].addr == address(0)) {
1224         TokenOwnership memory ownership = ownershipOf(i);
1225         _ownerships[i] = TokenOwnership(
1226           ownership.addr,
1227           ownership.startTimestamp
1228         );
1229       }
1230     }
1231     nextOwnerToExplicitlySet = endIndex + 1;
1232   }
1233 
1234   /**
1235    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1236    * The call is not executed if the target address is not a contract.
1237    *
1238    * @param from address representing the previous owner of the given token ID
1239    * @param to target address that will receive the tokens
1240    * @param tokenId uint256 ID of the token to be transferred
1241    * @param _data bytes optional data to send along with the call
1242    * @return bool whether the call correctly returned the expected magic value
1243    */
1244   function _checkOnERC721Received(
1245     address from,
1246     address to,
1247     uint256 tokenId,
1248     bytes memory _data
1249   ) private returns (bool) {
1250     if (to.isContract()) {
1251       try
1252         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1253       returns (bytes4 retval) {
1254         return retval == IERC721Receiver(to).onERC721Received.selector;
1255       } catch (bytes memory reason) {
1256         if (reason.length == 0) {
1257           revert("ERC721A: transfer to non ERC721Receiver implementer");
1258         } else {
1259           assembly {
1260             revert(add(32, reason), mload(reason))
1261           }
1262         }
1263       }
1264     } else {
1265       return true;
1266     }
1267   }
1268 
1269   /**
1270    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1271    *
1272    * startTokenId - the first token id to be transferred
1273    * quantity - the amount to be transferred
1274    *
1275    * Calling conditions:
1276    *
1277    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1278    * transferred to `to`.
1279    * - When `from` is zero, `tokenId` will be minted for `to`.
1280    */
1281   function _beforeTokenTransfers(
1282     address from,
1283     address to,
1284     uint256 startTokenId,
1285     uint256 quantity
1286   ) internal virtual {}
1287 
1288   /**
1289    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1290    * minting.
1291    *
1292    * startTokenId - the first token id to be transferred
1293    * quantity - the amount to be transferred
1294    *
1295    * Calling conditions:
1296    *
1297    * - when `from` and `to` are both non-zero.
1298    * - `from` and `to` are never both zero.
1299    */
1300   function _afterTokenTransfers(
1301     address from,
1302     address to,
1303     uint256 startTokenId,
1304     uint256 quantity
1305   ) internal virtual {}
1306 }
1307 // File: @openzeppelin/contracts/access/Ownable.sol
1308 
1309 
1310 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1311 
1312 pragma solidity ^0.8.0;
1313 
1314 
1315 /**
1316  * @dev Contract module which provides a basic access control mechanism, where
1317  * there is an account (an owner) that can be granted exclusive access to
1318  * specific functions.
1319  *
1320  * By default, the owner account will be the one that deploys the contract. This
1321  * can later be changed with {transferOwnership}.
1322  *
1323  * This module is used through inheritance. It will make available the modifier
1324  * `onlyOwner`, which can be applied to your functions to restrict their use to
1325  * the owner.
1326  */
1327 abstract contract Ownable is Context {
1328     address private _owner;
1329 
1330     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1331 
1332     /**
1333      * @dev Initializes the contract setting the deployer as the initial owner.
1334      */
1335     constructor() {
1336         _transferOwnership(_msgSender());
1337     }
1338 
1339     /**
1340      * @dev Returns the address of the current owner.
1341      */
1342     function owner() public view virtual returns (address) {
1343         return _owner;
1344     }
1345 
1346     /**
1347      * @dev Throws if called by any account other than the owner.
1348      */
1349     modifier onlyOwner() {
1350         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1351         _;
1352     }
1353 
1354     /**
1355      * @dev Leaves the contract without owner. It will not be possible to call
1356      * `onlyOwner` functions anymore. Can only be called by the current owner.
1357      *
1358      * NOTE: Renouncing ownership will leave the contract without an owner,
1359      * thereby removing any functionality that is only available to the owner.
1360      */
1361     function renounceOwnership() public virtual onlyOwner {
1362         _transferOwnership(address(0));
1363     }
1364 
1365     /**
1366      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1367      * Can only be called by the current owner.
1368      */
1369     function transferOwnership(address newOwner) public virtual onlyOwner {
1370         require(newOwner != address(0), "Ownable: new owner is the zero address");
1371         _transferOwnership(newOwner);
1372     }
1373 
1374     /**
1375      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1376      * Internal function without access restriction.
1377      */
1378     function _transferOwnership(address newOwner) internal virtual {
1379         address oldOwner = _owner;
1380         _owner = newOwner;
1381         emit OwnershipTransferred(oldOwner, newOwner);
1382     }
1383 }
1384 
1385 // File: contracts/PrimalBeasts.sol
1386 
1387 
1388 
1389 pragma solidity ^0.8.0;
1390 
1391 
1392 
1393 
1394 
1395 
1396 interface MAMMOTH {
1397     function burn(address _from, uint256 _amount) external;
1398     function mintMammoth(address _to, uint256 _amount) external;
1399     }
1400 
1401 contract PrimalBeasts is Ownable, ERC721A, ReentrancyGuard {
1402 
1403   constructor(
1404     uint256 maxBatchSize_,
1405     uint256 collectionSize_,
1406     uint256 amountForAuctionAndDev_,
1407     uint256 amountForDevs_
1408   ) ERC721A("PrimalBeasts", "PB", maxBatchSize_, collectionSize_) {
1409     require(amountForAuctionAndDev_ <= collectionSize_, "larger collection size needed" );
1410   }
1411 
1412 
1413 
1414   ///////////// MINT SECTION /////////////
1415     uint256 public pricePer = 0.0777 ether;
1416     mapping(address => bool) public minted;
1417     uint256 maxSupplyGenesis = 1000;
1418     bool public saleStart = false; 
1419     bool public publicSaleStart = false;
1420     bytes32 public MerkleRoot;
1421     mapping(address => uint256) public balanceGenesis;
1422 
1423     function emergencyBalanceGenesis(address to, uint256 balance) public onlyOwner{
1424       balanceGenesis[to] = balance;
1425     }
1426 
1427     modifier isValidMerkleProof(bytes32[] calldata merkleProof, bytes32 root) {
1428       require(
1429         MerkleProof.verify(
1430           merkleProof,
1431           root,
1432           keccak256(abi.encodePacked(msg.sender))
1433           ),
1434         "Address does not exist in list"
1435       );
1436     _;
1437     }
1438 
1439     function setMerkle (bytes32 merkleRoot) public onlyOwner{ 
1440       MerkleRoot = merkleRoot;
1441     }
1442 
1443     function setPublicSale(bool start) public onlyOwner{
1444       publicSaleStart = start;
1445     }
1446 
1447     function setWLSale(bool start) public onlyOwner{
1448       saleStart = start;
1449     }
1450   
1451     function setPrice(uint256 price) public onlyOwner{
1452       pricePer = price;
1453     }
1454 
1455     function setGenSupply(uint256 newMax) public onlyOwner{
1456       maxSupplyGenesis = newMax;
1457     }
1458 
1459     function mintMarketing(address to, uint256 quantity) external onlyOwner {
1460       require(totalSupply() + quantity <= maxTotalSupply, "Sold out");
1461       if (totalSupply() < maxSupplyGenesis){
1462         balanceGenesis[to]++;
1463         lastClaimed[to] = block.timestamp; 
1464       }
1465       _safeMint(to, quantity);
1466     }
1467 
1468     function mint(uint256 quantity) external payable{
1469       balanceGenesis[msg.sender]++;
1470       lastClaimed[msg.sender] = block.timestamp; 
1471 
1472       require(publicSaleStart, "Sale not started");
1473       require(quantity == 1, "Cant mint more than 1 at once");
1474       require(totalSupply() + quantity <= maxSupplyGenesis, "Sold out");
1475       require(msg.value >= pricePer * quantity, "Not enough Eth");
1476       _safeMint(msg.sender, quantity);
1477     }
1478 
1479     function mintWL(bytes32[] calldata merkleProof) external payable isValidMerkleProof(merkleProof, MerkleRoot){
1480       require(saleStart, "Sale not started");
1481       balanceGenesis[msg.sender]++;
1482       require(minted[msg.sender] == false, "Cant mint more than 1");
1483       require(totalSupply() + 1 <= maxSupplyGenesis, "Sold out");
1484       require(msg.value >= pricePer, "Not enough Eth");
1485       minted[msg.sender] = true;
1486       lastClaimed[msg.sender] = block.timestamp; 
1487       _safeMint(msg.sender, 1);
1488     }
1489 
1490   ///////////// MAMMOTH SECTION /////////////
1491 
1492 
1493     MAMMOTH public MammothContract;
1494     mapping(address => uint256) public claimableReward;
1495     mapping(address => uint256) public lastClaimed;
1496     uint256 public dailyMammoth = 5 ether;
1497     bool public mammothEnabled = true;
1498     mapping(address => bool) approvedAddress;
1499 
1500     function addController(address owner, bool access) external onlyOwner {
1501     approvedAddress[owner] = access;
1502   }
1503 
1504     function activateMammoth(bool mammothGo) external onlyOwner{
1505         mammothEnabled = mammothGo;
1506     }
1507 
1508     function setMammoth(address mammothAddy) external onlyOwner{
1509         MammothContract = MAMMOTH(mammothAddy);
1510     }
1511 
1512     function calcNewReward(address from) public view returns(uint256){
1513       return (balanceGenesis[from] * (block.timestamp - lastClaimed[from]) * dailyMammoth / 86400);
1514     }
1515 
1516     function setReward(address ownerAddress, uint256 newReward) public {
1517       require(approvedAddress[msg.sender], "Only controllers can set reward");
1518       claimableReward[ownerAddress] = newReward;
1519     }
1520 
1521     function claimRewards(address claimer) public nonReentrant{
1522         require(mammothEnabled, "Mammoth is paused.");
1523         require(claimer == msg.sender, "Can't claim for others");
1524         claimableReward[claimer] += calcNewReward(claimer);
1525         lastClaimed[claimer] = block.timestamp;
1526         if (claimableReward[claimer] > 0) {
1527             MammothContract.mintMammoth(claimer, claimableReward[claimer]);
1528         }
1529         claimableReward[claimer] = 0;
1530     }
1531 
1532 ///////////// BABY SECTION /////////////
1533     event babyMade(uint256 mom, uint256 dad, uint256 tokenIDBaby);
1534     uint256 maxTotalSupply = 3000;
1535     function setTotalSupply(uint256 newMax) public onlyOwner{
1536       maxTotalSupply = newMax;
1537     }
1538     uint256 babyCost = 600 ether; 
1539     function babyCostChange(uint256 newCost) public onlyOwner{
1540       babyCost = newCost;
1541     }
1542     bool public babyTime = false;
1543     bool public migrateCurrency = false;
1544     function setbabyTime(bool breedingReady) public onlyOwner{
1545       babyTime = breedingReady;
1546     }
1547     function setmigrateCurrency(bool abandonShip) public onlyOwner{
1548       migrateCurrency = abandonShip;
1549     }
1550 
1551   function breed(uint256 dad, uint256 mom) external {
1552         require(babyTime, "Babies not ready!");
1553         require(ownerOf(dad) == msg.sender && ownerOf(mom) == msg.sender, "Must own parents" );
1554         require(totalSupply() + 1 < maxTotalSupply, "Max Supply Reached");
1555         require(dad < maxSupplyGenesis && mom < maxSupplyGenesis, "Baby Beast can't breed.");
1556         require(dad != mom, "Parents are the same");
1557         claimableReward[msg.sender] += calcNewReward(msg.sender);
1558         lastClaimed[msg.sender] = block.timestamp;
1559         if (claimableReward[msg.sender] < babyCost || migrateCurrency){
1560           MammothContract.burn(msg.sender, babyCost);
1561         }
1562         else{
1563           claimableReward[msg.sender] -= babyCost;
1564         }
1565         _safeMint(msg.sender, 1);
1566         emit babyMade(mom, dad, totalSupply());
1567     }
1568 
1569 
1570     function transferFrom(address from, address to, uint256 tokenId) public override {
1571         if (tokenId < maxSupplyGenesis) {
1572           claimableReward[to] += calcNewReward(to);
1573           lastClaimed[to] = block.timestamp;
1574           claimableReward[from] += calcNewReward(from);
1575           lastClaimed[from] = block.timestamp;
1576           balanceGenesis[from]--;
1577           balanceGenesis[to]++;
1578         }
1579         ERC721A.transferFrom(from, to, tokenId);
1580     }
1581 
1582     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override {
1583         if (tokenId < maxSupplyGenesis) {
1584           claimableReward[to] += calcNewReward(to);
1585           lastClaimed[to] = block.timestamp;
1586           claimableReward[from] += calcNewReward(from);
1587           lastClaimed[from] = block.timestamp;
1588           balanceGenesis[from]--;
1589           balanceGenesis[to]++;
1590         }
1591         ERC721A.safeTransferFrom(from, to, tokenId, data);
1592     }
1593 
1594   
1595 
1596   // // metadata URI
1597   string private _baseTokenURI = "ipfs://QmQ1J49dpXCA2xudbjfCFbmz89wvoK7fCFFb3fpYR3RSpb/";
1598   string private unrevealedURI = "ipfs://QmW7WDfsYmtLyPnyDq7nGY38RUMB5ZCcLE1PrHMwuLSz7j";
1599 
1600   function setUnrevealedURI(string memory unrevealedURI_) public onlyOwner{
1601     unrevealedURI = unrevealedURI_;
1602   }
1603 
1604   function order66() public onlyOwner{
1605     delete unrevealedURI;
1606   }
1607 
1608   function tokenURI(uint256 tokenId_)
1609     public
1610     view
1611     override
1612     returns (string memory)
1613   {
1614     if ((bytes(unrevealedURI).length > 0) && tokenId_ > 4) return unrevealedURI;
1615     return
1616       string(abi.encodePacked(_baseTokenURI, Strings.toString(tokenId_)));
1617   }
1618 
1619   function _baseURI() internal view virtual override returns (string memory) {
1620     return _baseTokenURI;
1621   }
1622 
1623   function setBaseURI(string calldata baseURI) external onlyOwner {
1624     _baseTokenURI = baseURI;
1625   }
1626 
1627   function withdrawMoney() external onlyOwner nonReentrant {
1628     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1629     require(success, "Transfer failed.");
1630   }
1631 
1632   function setOwnersExplicit(uint256 quantity) external onlyOwner nonReentrant {
1633     _setOwnersExplicit(quantity);
1634   }
1635 
1636   function numberMinted(address owner) public view returns (uint256) {
1637     return _numberMinted(owner);
1638   }
1639 
1640   function getOwnershipData(uint256 tokenId)
1641     external
1642     view
1643     returns (TokenOwnership memory)
1644   {
1645     return ownershipOf(tokenId);
1646   }
1647 }