1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13 
14     /**
15      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
16      */
17     function toString(uint256 value) internal pure returns (string memory) {
18         // Inspired by OraclizeAPI's implementation - MIT licence
19         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
20 
21         if (value == 0) {
22             return "0";
23         }
24         uint256 temp = value;
25         uint256 digits;
26         while (temp != 0) {
27             digits++;
28             temp /= 10;
29         }
30         bytes memory buffer = new bytes(digits);
31         while (value != 0) {
32             digits -= 1;
33             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
34             value /= 10;
35         }
36         return string(buffer);
37     }
38 
39     /**
40      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
41      */
42     function toHexString(uint256 value) internal pure returns (string memory) {
43         if (value == 0) {
44             return "0x00";
45         }
46         uint256 temp = value;
47         uint256 length = 0;
48         while (temp != 0) {
49             length++;
50             temp >>= 8;
51         }
52         return toHexString(value, length);
53     }
54 
55     /**
56      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
57      */
58     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
59         bytes memory buffer = new bytes(2 * length + 2);
60         buffer[0] = "0";
61         buffer[1] = "x";
62         for (uint256 i = 2 * length + 1; i > 1; --i) {
63             buffer[i] = _HEX_SYMBOLS[value & 0xf];
64             value >>= 4;
65         }
66         require(value == 0, "Strings: hex length insufficient");
67         return string(buffer);
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/Address.sol
72 
73 
74 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
75 
76 pragma solidity ^0.8.1;
77 
78 /**
79  * @dev Collection of functions related to the address type
80  */
81 library Address {
82     /**
83      * @dev Returns true if `account` is a contract.
84      *
85      * [IMPORTANT]
86      * ====
87      * It is unsafe to assume that an address for which this function returns
88      * false is an externally-owned account (EOA) and not a contract.
89      *
90      * Among others, `isContract` will return false for the following
91      * types of addresses:
92      *
93      *  - an externally-owned account
94      *  - a contract in construction
95      *  - an address where a contract will be created
96      *  - an address where a contract lived, but was destroyed
97      * ====
98      *
99      * [IMPORTANT]
100      * ====
101      * You shouldn't rely on `isContract` to protect against flash loan attacks!
102      *
103      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
104      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
105      * constructor.
106      * ====
107      */
108     function isContract(address account) internal view returns (bool) {
109         // This method relies on extcodesize/address.code.length, which returns 0
110         // for contracts in construction, since the code is only stored at the end
111         // of the constructor execution.
112 
113         return account.code.length > 0;
114     }
115 
116     /**
117      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
118      * `recipient`, forwarding all available gas and reverting on errors.
119      *
120      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
121      * of certain opcodes, possibly making contracts go over the 2300 gas limit
122      * imposed by `transfer`, making them unable to receive funds via
123      * `transfer`. {sendValue} removes this limitation.
124      *
125      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
126      *
127      * IMPORTANT: because control is transferred to `recipient`, care must be
128      * taken to not create reentrancy vulnerabilities. Consider using
129      * {ReentrancyGuard} or the
130      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
131      */
132     function sendValue(address payable recipient, uint256 amount) internal {
133         require(address(this).balance >= amount, "Address: insufficient balance");
134 
135         (bool success, ) = recipient.call{value: amount}("");
136         require(success, "Address: unable to send value, recipient may have reverted");
137     }
138 
139     /**
140      * @dev Performs a Solidity function call using a low level `call`. A
141      * plain `call` is an unsafe replacement for a function call: use this
142      * function instead.
143      *
144      * If `target` reverts with a revert reason, it is bubbled up by this
145      * function (like regular Solidity function calls).
146      *
147      * Returns the raw returned data. To convert to the expected return value,
148      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
149      *
150      * Requirements:
151      *
152      * - `target` must be a contract.
153      * - calling `target` with `data` must not revert.
154      *
155      * _Available since v3.1._
156      */
157     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
158         return functionCall(target, data, "Address: low-level call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
163      * `errorMessage` as a fallback revert reason when `target` reverts.
164      *
165      * _Available since v3.1._
166      */
167     function functionCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal returns (bytes memory) {
172         return functionCallWithValue(target, data, 0, errorMessage);
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
177      * but also transferring `value` wei to `target`.
178      *
179      * Requirements:
180      *
181      * - the calling contract must have an ETH balance of at least `value`.
182      * - the called Solidity function must be `payable`.
183      *
184      * _Available since v3.1._
185      */
186     function functionCallWithValue(
187         address target,
188         bytes memory data,
189         uint256 value
190     ) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
196      * with `errorMessage` as a fallback revert reason when `target` reverts.
197      *
198      * _Available since v3.1._
199      */
200     function functionCallWithValue(
201         address target,
202         bytes memory data,
203         uint256 value,
204         string memory errorMessage
205     ) internal returns (bytes memory) {
206         require(address(this).balance >= value, "Address: insufficient balance for call");
207         require(isContract(target), "Address: call to non-contract");
208 
209         (bool success, bytes memory returndata) = target.call{value: value}(data);
210         return verifyCallResult(success, returndata, errorMessage);
211     }
212 
213     /**
214      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
215      * but performing a static call.
216      *
217      * _Available since v3.3._
218      */
219     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
220         return functionStaticCall(target, data, "Address: low-level static call failed");
221     }
222 
223     /**
224      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
225      * but performing a static call.
226      *
227      * _Available since v3.3._
228      */
229     function functionStaticCall(
230         address target,
231         bytes memory data,
232         string memory errorMessage
233     ) internal view returns (bytes memory) {
234         require(isContract(target), "Address: static call to non-contract");
235 
236         (bool success, bytes memory returndata) = target.staticcall(data);
237         return verifyCallResult(success, returndata, errorMessage);
238     }
239 
240     /**
241      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
242      * but performing a delegate call.
243      *
244      * _Available since v3.4._
245      */
246     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
247         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
248     }
249 
250     /**
251      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
252      * but performing a delegate call.
253      *
254      * _Available since v3.4._
255      */
256     function functionDelegateCall(
257         address target,
258         bytes memory data,
259         string memory errorMessage
260     ) internal returns (bytes memory) {
261         require(isContract(target), "Address: delegate call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.delegatecall(data);
264         return verifyCallResult(success, returndata, errorMessage);
265     }
266 
267     /**
268      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
269      * revert reason using the provided one.
270      *
271      * _Available since v4.3._
272      */
273     function verifyCallResult(
274         bool success,
275         bytes memory returndata,
276         string memory errorMessage
277     ) internal pure returns (bytes memory) {
278         if (success) {
279             return returndata;
280         } else {
281             // Look for revert reason and bubble it up if present
282             if (returndata.length > 0) {
283                 // The easiest way to bubble the revert reason is using memory via assembly
284 
285                 assembly {
286                     let returndata_size := mload(returndata)
287                     revert(add(32, returndata), returndata_size)
288                 }
289             } else {
290                 revert(errorMessage);
291             }
292         }
293     }
294 }
295 
296 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
297 
298 
299 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
300 
301 pragma solidity ^0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
317      */
318     function onERC721Received(
319         address operator,
320         address from,
321         uint256 tokenId,
322         bytes calldata data
323     ) external returns (bytes4);
324 }
325 
326 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
327 
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev Interface of the ERC165 standard, as defined in the
335  * https://eips.ethereum.org/EIPS/eip-165[EIP].
336  *
337  * Implementers can declare support of contract interfaces, which can then be
338  * queried by others ({ERC165Checker}).
339  *
340  * For an implementation, see {ERC165}.
341  */
342 interface IERC165 {
343     /**
344      * @dev Returns true if this contract implements the interface defined by
345      * `interfaceId`. See the corresponding
346      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
347      * to learn more about how these ids are created.
348      *
349      * This function call must use less than 30 000 gas.
350      */
351     function supportsInterface(bytes4 interfaceId) external view returns (bool);
352 }
353 
354 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 
362 /**
363  * @dev Implementation of the {IERC165} interface.
364  *
365  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
366  * for the additional interface id that will be supported. For example:
367  *
368  * ```solidity
369  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
370  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
371  * }
372  * ```
373  *
374  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
375  */
376 abstract contract ERC165 is IERC165 {
377     /**
378      * @dev See {IERC165-supportsInterface}.
379      */
380     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
381         return interfaceId == type(IERC165).interfaceId;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
386 
387 
388 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 
393 /**
394  * @dev Required interface of an ERC721 compliant contract.
395  */
396 interface IERC721 is IERC165 {
397     /**
398      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
399      */
400     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
401 
402     /**
403      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
404      */
405     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
406 
407     /**
408      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
409      */
410     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
411 
412     /**
413      * @dev Returns the number of tokens in ``owner``'s account.
414      */
415     function balanceOf(address owner) external view returns (uint256 balance);
416 
417     /**
418      * @dev Returns the owner of the `tokenId` token.
419      *
420      * Requirements:
421      *
422      * - `tokenId` must exist.
423      */
424     function ownerOf(uint256 tokenId) external view returns (address owner);
425 
426     /**
427      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
428      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
429      *
430      * Requirements:
431      *
432      * - `from` cannot be the zero address.
433      * - `to` cannot be the zero address.
434      * - `tokenId` token must exist and be owned by `from`.
435      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
436      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
437      *
438      * Emits a {Transfer} event.
439      */
440     function safeTransferFrom(
441         address from,
442         address to,
443         uint256 tokenId
444     ) external;
445 
446     /**
447      * @dev Transfers `tokenId` token from `from` to `to`.
448      *
449      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
450      *
451      * Requirements:
452      *
453      * - `from` cannot be the zero address.
454      * - `to` cannot be the zero address.
455      * - `tokenId` token must be owned by `from`.
456      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
457      *
458      * Emits a {Transfer} event.
459      */
460     function transferFrom(
461         address from,
462         address to,
463         uint256 tokenId
464     ) external;
465 
466     /**
467      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
468      * The approval is cleared when the token is transferred.
469      *
470      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
471      *
472      * Requirements:
473      *
474      * - The caller must own the token or be an approved operator.
475      * - `tokenId` must exist.
476      *
477      * Emits an {Approval} event.
478      */
479     function approve(address to, uint256 tokenId) external;
480 
481     /**
482      * @dev Returns the account approved for `tokenId` token.
483      *
484      * Requirements:
485      *
486      * - `tokenId` must exist.
487      */
488     function getApproved(uint256 tokenId) external view returns (address operator);
489 
490     /**
491      * @dev Approve or remove `operator` as an operator for the caller.
492      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
493      *
494      * Requirements:
495      *
496      * - The `operator` cannot be the caller.
497      *
498      * Emits an {ApprovalForAll} event.
499      */
500     function setApprovalForAll(address operator, bool _approved) external;
501 
502     /**
503      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
504      *
505      * See {setApprovalForAll}
506      */
507     function isApprovedForAll(address owner, address operator) external view returns (bool);
508 
509     /**
510      * @dev Safely transfers `tokenId` token from `from` to `to`.
511      *
512      * Requirements:
513      *
514      * - `from` cannot be the zero address.
515      * - `to` cannot be the zero address.
516      * - `tokenId` token must exist and be owned by `from`.
517      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
518      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
519      *
520      * Emits a {Transfer} event.
521      */
522     function safeTransferFrom(
523         address from,
524         address to,
525         uint256 tokenId,
526         bytes calldata data
527     ) external;
528 }
529 
530 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 
538 /**
539  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
540  * @dev See https://eips.ethereum.org/EIPS/eip-721
541  */
542 interface IERC721Metadata is IERC721 {
543     /**
544      * @dev Returns the token collection name.
545      */
546     function name() external view returns (string memory);
547 
548     /**
549      * @dev Returns the token collection symbol.
550      */
551     function symbol() external view returns (string memory);
552 
553     /**
554      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
555      */
556     function tokenURI(uint256 tokenId) external view returns (string memory);
557 }
558 
559 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
560 
561 
562 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev These functions deal with verification of Merkle Trees proofs.
568  *
569  * The proofs can be generated using the JavaScript library
570  * https://github.com/miguelmota/merkletreejs[merkletreejs].
571  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
572  *
573  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
574  *
575  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
576  * hashing, or use a hash function other than keccak256 for hashing leaves.
577  * This is because the concatenation of a sorted pair of internal nodes in
578  * the merkle tree could be reinterpreted as a leaf value.
579  */
580 library MerkleProof {
581     /**
582      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
583      * defined by `root`. For this, a `proof` must be provided, containing
584      * sibling hashes on the branch from the leaf to the root of the tree. Each
585      * pair of leaves and each pair of pre-images are assumed to be sorted.
586      */
587     function verify(
588         bytes32[] memory proof,
589         bytes32 root,
590         bytes32 leaf
591     ) internal pure returns (bool) {
592         return processProof(proof, leaf) == root;
593     }
594 
595     /**
596      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
597      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
598      * hash matches the root of the tree. When processing the proof, the pairs
599      * of leafs & pre-images are assumed to be sorted.
600      *
601      * _Available since v4.4._
602      */
603     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
604         bytes32 computedHash = leaf;
605         for (uint256 i = 0; i < proof.length; i++) {
606             bytes32 proofElement = proof[i];
607             if (computedHash <= proofElement) {
608                 // Hash(current computed hash + current element of the proof)
609                 computedHash = _efficientHash(computedHash, proofElement);
610             } else {
611                 // Hash(current element of the proof + current computed hash)
612                 computedHash = _efficientHash(proofElement, computedHash);
613             }
614         }
615         return computedHash;
616     }
617 
618     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
619         assembly {
620             mstore(0x00, a)
621             mstore(0x20, b)
622             value := keccak256(0x00, 0x40)
623         }
624     }
625 }
626 
627 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
628 
629 
630 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
631 
632 pragma solidity ^0.8.0;
633 
634 /**
635  * @dev Contract module that helps prevent reentrant calls to a function.
636  *
637  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
638  * available, which can be applied to functions to make sure there are no nested
639  * (reentrant) calls to them.
640  *
641  * Note that because there is a single `nonReentrant` guard, functions marked as
642  * `nonReentrant` may not call one another. This can be worked around by making
643  * those functions `private`, and then adding `external` `nonReentrant` entry
644  * points to them.
645  *
646  * TIP: If you would like to learn more about reentrancy and alternative ways
647  * to protect against it, check out our blog post
648  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
649  */
650 abstract contract ReentrancyGuard {
651     // Booleans are more expensive than uint256 or any type that takes up a full
652     // word because each write operation emits an extra SLOAD to first read the
653     // slot's contents, replace the bits taken up by the boolean, and then write
654     // back. This is the compiler's defense against contract upgrades and
655     // pointer aliasing, and it cannot be disabled.
656 
657     // The values being non-zero value makes deployment a bit more expensive,
658     // but in exchange the refund on every call to nonReentrant will be lower in
659     // amount. Since refunds are capped to a percentage of the total
660     // transaction's gas, it is best to keep them low in cases like this one, to
661     // increase the likelihood of the full refund coming into effect.
662     uint256 private constant _NOT_ENTERED = 1;
663     uint256 private constant _ENTERED = 2;
664 
665     uint256 private _status;
666 
667     constructor() {
668         _status = _NOT_ENTERED;
669     }
670 
671     /**
672      * @dev Prevents a contract from calling itself, directly or indirectly.
673      * Calling a `nonReentrant` function from another `nonReentrant`
674      * function is not supported. It is possible to prevent this from happening
675      * by making the `nonReentrant` function external, and making it call a
676      * `private` function that does the actual work.
677      */
678     modifier nonReentrant() {
679         // On the first call to nonReentrant, _notEntered will be true
680         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
681 
682         // Any calls to nonReentrant after this point will fail
683         _status = _ENTERED;
684 
685         _;
686 
687         // By storing the original value once again, a refund is triggered (see
688         // https://eips.ethereum.org/EIPS/eip-2200)
689         _status = _NOT_ENTERED;
690     }
691 }
692 
693 // File: @openzeppelin/contracts/utils/Context.sol
694 
695 
696 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
697 
698 pragma solidity ^0.8.0;
699 
700 /**
701  * @dev Provides information about the current execution context, including the
702  * sender of the transaction and its data. While these are generally available
703  * via msg.sender and msg.data, they should not be accessed in such a direct
704  * manner, since when dealing with meta-transactions the account sending and
705  * paying for execution may not be the actual sender (as far as an application
706  * is concerned).
707  *
708  * This contract is only required for intermediate, library-like contracts.
709  */
710 abstract contract Context {
711     function _msgSender() internal view virtual returns (address) {
712         return msg.sender;
713     }
714 
715     function _msgData() internal view virtual returns (bytes calldata) {
716         return msg.data;
717     }
718 }
719 
720 // File: contracts/ERC721DEYE.sol
721 
722 
723 // Author: Mas C. (Project Dark Eye)
724 
725 pragma solidity ^0.8.4;
726 
727 
728 
729 
730 
731 
732 
733 
734 error ApprovalCallerNotOwnerNorApproved();
735 error ApprovalQueryForNonexistentToken();
736 error ApproveToCaller();
737 error ApprovalToCurrentOwner();
738 error BalanceQueryForZeroAddress();
739 error MintToZeroAddress();
740 error MintZeroQuantity();
741 error OwnerQueryForNonexistentToken();
742 error TransferCallerNotOwnerNorApproved();
743 error TransferFromIncorrectOwner();
744 error TransferToNonERC721ReceiverImplementer();
745 error TransferToZeroAddress();
746 error URIQueryForNonexistentToken();
747 
748 /**
749  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
750  * the Metadata extension. Built to optimize for lower gas during batch mints.
751  *
752  * This implementation is forked from ERC721A (https://github.com/chiru-labs/ERC721A).
753  *
754  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
755  *
756  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
757  *
758  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
759  */
760 contract ERC721DEYE is Context, ERC165, IERC721, IERC721Metadata {
761     using Address for address;
762     using Strings for uint256;
763 
764     // Compiler will pack this into a single 256bit word.
765     struct TokenOwnership {
766         // The address of the owner.
767         address addr;
768         // Whether the token has been burned.
769         bool burned;
770     }
771 
772     // Compiler will pack this into a single 256bit word.
773     struct AddressData {
774         // Realistically, 2**64-1 is more than enough.
775         uint64 balance;
776         // Keeps track of mint count with minimal overhead for tokenomics.
777         uint64 numberMinted;
778         // Keeps track of burn count with minimal overhead for tokenomics.
779         uint64 numberBurned;
780         // If the address is allowed in presale one.
781         bool presaleOneAllowed;
782         // If the address is allowed in presale two.
783         bool presaleTwoAllowed;
784     }
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
827     function totalSupply() public view returns (uint256) {
828         // Counter underflow is impossible as _burnCounter cannot be incremented
829         // more than _currentIndex - _startTokenId() times
830         unchecked {
831             return _currentIndex - _burnCounter - _startTokenId();
832         }
833     }
834 
835     function totalMinted() public view returns (uint256) {
836         // Counter underflow is impossible as _burnCounter cannot be incremented
837         // more than _currentIndex - _startTokenId() times
838         unchecked {
839             return _currentIndex - _startTokenId();
840         }
841     }
842 
843     /**
844      * Returns the total amount of tokens minted in the contract.
845      */
846     function _totalMinted() internal view returns (uint256) {
847         // Counter underflow is impossible as _currentIndex does not decrement,
848         // and it is initialized to _startTokenId()
849         unchecked {
850             return _currentIndex - _startTokenId();
851         }
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
858         return
859             interfaceId == type(IERC721).interfaceId ||
860             interfaceId == type(IERC721Metadata).interfaceId ||
861             super.supportsInterface(interfaceId);
862     }
863 
864     /**
865      * @dev See {IERC721-balanceOf}.
866      */
867     function balanceOf(address owner) public view override returns (uint256) {
868         if (owner == address(0)) revert BalanceQueryForZeroAddress();
869         return uint256(_addressData[owner].balance);
870     }
871 
872     /**
873      * Returns the number of tokens minted by `owner`.
874      */
875     function _numberMinted(address owner) internal view returns (uint256) {
876         return uint256(_addressData[owner].numberMinted);
877     }
878 
879     /**
880      * Returns the number of tokens burned by or on behalf of `owner`.
881      */
882     function _numberBurned(address owner) internal view returns (uint256) {
883         return uint256(_addressData[owner].numberBurned);
884     }
885 
886     /**
887      * Returns if the address is allowed to mint at each stage.
888      */
889     function _getMintAllowance(address owner) internal view returns (bool, bool) {
890         return (_addressData[owner].presaleOneAllowed, _addressData[owner].presaleTwoAllowed);
891     }
892 
893     /**
894      * Sets if the address is allowed to mint at each stage.
895      */
896     function _setMintAllowance(address owner, bool presaleOneAllowed, bool presaleTwoAllowed) internal {
897         _addressData[owner].presaleOneAllowed = presaleOneAllowed;
898         _addressData[owner].presaleTwoAllowed = presaleTwoAllowed;
899     }
900 
901     /**
902      * Gas spent here starts off proportional to the maximum mint batch size.
903      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
904      */
905     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
906         uint256 curr = tokenId;
907 
908         unchecked {
909             if (_startTokenId() <= curr && curr < _currentIndex) {
910                 TokenOwnership memory ownership = _ownerships[curr];
911                 if (!ownership.burned) {
912                     if (ownership.addr != address(0)) {
913                         return ownership;
914                     }
915                     // Invariant:
916                     // There will always be an ownership that has an address and is not burned
917                     // before an ownership that does not have an address and is not burned.
918                     // Hence, curr will not underflow.
919                     while (true) {
920                         curr--;
921                         ownership = _ownerships[curr];
922                         if (ownership.addr != address(0)) {
923                             return ownership;
924                         }
925                     }
926                 }
927             }
928         }
929         revert OwnerQueryForNonexistentToken();
930     }
931 
932     /**
933      * @dev See {IERC721-ownerOf}.
934      */
935     function ownerOf(uint256 tokenId) public view override returns (address) {
936         return _ownershipOf(tokenId).addr;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-name}.
941      */
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-symbol}.
948      */
949     function symbol() public view virtual override returns (string memory) {
950         return _symbol;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-tokenURI}.
955      */
956     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
957         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
958 
959         string memory baseURI = _baseURI();
960         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
961     }
962 
963     /**
964      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
965      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
966      * by default, can be overriden in child contracts.
967      */
968     function _baseURI() internal view virtual returns (string memory) {
969         return '';
970     }
971 
972     /**
973      * @dev See {IERC721-approve}.
974      */
975     function approve(address to, uint256 tokenId) public override {
976         address owner = ERC721DEYE.ownerOf(tokenId);
977         if (to == owner) revert ApprovalToCurrentOwner();
978 
979         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
980             revert ApprovalCallerNotOwnerNorApproved();
981         }
982 
983         _approve(to, tokenId, owner);
984     }
985 
986     /**
987      * @dev See {IERC721-getApproved}.
988      */
989     function getApproved(uint256 tokenId) public view override returns (address) {
990         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
991 
992         return _tokenApprovals[tokenId];
993     }
994 
995     /**
996      * @dev See {IERC721-setApprovalForAll}.
997      */
998     function setApprovalForAll(address operator, bool approved) public virtual override {
999         if (operator == _msgSender()) revert ApproveToCaller();
1000 
1001         _operatorApprovals[_msgSender()][operator] = approved;
1002         emit ApprovalForAll(_msgSender(), operator, approved);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-isApprovedForAll}.
1007      */
1008     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1009         return _operatorApprovals[owner][operator];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-transferFrom}.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         safeTransferFrom(from, to, tokenId, '');
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1045             revert TransferToNonERC721ReceiverImplementer();
1046         }
1047     }
1048 
1049     /**
1050      * @dev Returns whether `tokenId` exists.
1051      *
1052      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1053      *
1054      * Tokens start existing when they are minted (`_mint`),
1055      */
1056     function _exists(uint256 tokenId) internal view returns (bool) {
1057         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1058             !_ownerships[tokenId].burned;
1059     }
1060 
1061     function _safeMint(address to, uint256 quantity) internal {
1062         _safeMint(to, quantity, '');
1063     }
1064 
1065     /**
1066      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _safeMint(
1076         address to,
1077         uint256 quantity,
1078         bytes memory _data
1079     ) internal {
1080         _mint(to, quantity, _data, true);
1081     }
1082 
1083     /**
1084      * @dev Mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _mint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data,
1097         bool safe
1098     ) internal {
1099         uint256 startTokenId = _currentIndex;
1100         if (to == address(0)) revert MintToZeroAddress();
1101         if (quantity == 0) revert MintZeroQuantity();
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are incredibly unrealistic.
1106         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1107         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1108         unchecked {
1109             _addressData[to].balance += uint64(quantity);
1110             _addressData[to].numberMinted += uint64(quantity);
1111 
1112             _ownerships[startTokenId].addr = to;
1113 
1114             uint256 updatedIndex = startTokenId;
1115             uint256 end = updatedIndex + quantity;
1116 
1117             if (safe && to.isContract()) {
1118                 do {
1119                     emit Transfer(address(0), to, updatedIndex);
1120                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1121                         revert TransferToNonERC721ReceiverImplementer();
1122                     }
1123                 } while (updatedIndex != end);
1124                 // Reentrancy protection
1125                 if (_currentIndex != startTokenId) revert();
1126             } else {
1127                 do {
1128                     emit Transfer(address(0), to, updatedIndex++);
1129                 } while (updatedIndex != end);
1130             }
1131             _currentIndex = updatedIndex;
1132         }
1133         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1134     }
1135 
1136     /**
1137      * @dev Transfers `tokenId` from `from` to `to`.
1138      *
1139      * Requirements:
1140      *
1141      * - `to` cannot be the zero address.
1142      * - `tokenId` token must be owned by `from`.
1143      *
1144      * Emits a {Transfer} event.
1145      */
1146     function _transfer(
1147         address from,
1148         address to,
1149         uint256 tokenId
1150     ) private {
1151         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1152 
1153         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1154 
1155         bool isApprovedOrOwner = (_msgSender() == from ||
1156             isApprovedForAll(from, _msgSender()) ||
1157             getApproved(tokenId) == _msgSender());
1158 
1159         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1160         if (to == address(0)) revert TransferToZeroAddress();
1161 
1162         _beforeTokenTransfers(from, to, tokenId, 1);
1163 
1164         // Clear approvals from the previous owner
1165         _approve(address(0), tokenId, from);
1166 
1167         // Underflow of the sender's balance is impossible because we check for
1168         // ownership above and the recipient's balance can't realistically overflow.
1169         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1170         unchecked {
1171             _addressData[from].balance -= 1;
1172             _addressData[to].balance += 1;
1173 
1174             TokenOwnership storage currSlot = _ownerships[tokenId];
1175             currSlot.addr = to;
1176 
1177             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1178             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1179             uint256 nextTokenId = tokenId + 1;
1180             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1181             if (nextSlot.addr == address(0)) {
1182                 // This will suffice for checking _exists(nextTokenId),
1183                 // as a burned slot cannot contain the zero address.
1184                 if (nextTokenId != _currentIndex) {
1185                     nextSlot.addr = from;
1186                 }
1187             }
1188         }
1189 
1190         emit Transfer(from, to, tokenId);
1191         _afterTokenTransfers(from, to, tokenId, 1);
1192     }
1193 
1194     /**
1195      * @dev This is equivalent to _burn(tokenId, false)
1196      */
1197     function _burn(uint256 tokenId) internal virtual {
1198         _burn(tokenId, false);
1199     }
1200 
1201     /**
1202      * @dev Destroys `tokenId`.
1203      * The approval is cleared when the token is burned.
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must exist.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1212         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1213 
1214         address from = prevOwnership.addr;
1215 
1216         if (approvalCheck) {
1217             bool isApprovedOrOwner = (_msgSender() == from ||
1218                 isApprovedForAll(from, _msgSender()) ||
1219                 getApproved(tokenId) == _msgSender());
1220 
1221             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1222         }
1223 
1224         _beforeTokenTransfers(from, address(0), tokenId, 1);
1225 
1226         // Clear approvals from the previous owner
1227         _approve(address(0), tokenId, from);
1228 
1229         // Underflow of the sender's balance is impossible because we check for
1230         // ownership above and the recipient's balance can't realistically overflow.
1231         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1232         unchecked {
1233             AddressData storage addressData = _addressData[from];
1234             addressData.balance -= 1;
1235             addressData.numberBurned += 1;
1236 
1237             // Keep track of who burned the token, and the timestamp of burning.
1238             TokenOwnership storage currSlot = _ownerships[tokenId];
1239             currSlot.addr = from;
1240             currSlot.burned = true;
1241 
1242             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1243             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1244             uint256 nextTokenId = tokenId + 1;
1245             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1246             if (nextSlot.addr == address(0)) {
1247                 // This will suffice for checking _exists(nextTokenId),
1248                 // as a burned slot cannot contain the zero address.
1249                 if (nextTokenId != _currentIndex) {
1250                     nextSlot.addr = from;
1251                 }
1252             }
1253         }
1254 
1255         emit Transfer(from, address(0), tokenId);
1256         _afterTokenTransfers(from, address(0), tokenId, 1);
1257 
1258         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1259         unchecked {
1260             _burnCounter++;
1261         }
1262     }
1263 
1264     /**
1265      * @dev Approve `to` to operate on `tokenId`
1266      *
1267      * Emits a {Approval} event.
1268      */
1269     function _approve(
1270         address to,
1271         uint256 tokenId,
1272         address owner
1273     ) private {
1274         _tokenApprovals[tokenId] = to;
1275         emit Approval(owner, to, tokenId);
1276     }
1277 
1278     /**
1279      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1280      *
1281      * @param from address representing the previous owner of the given token ID
1282      * @param to target address that will receive the tokens
1283      * @param tokenId uint256 ID of the token to be transferred
1284      * @param _data bytes optional data to send along with the call
1285      * @return bool whether the call correctly returned the expected magic value
1286      */
1287     function _checkContractOnERC721Received(
1288         address from,
1289         address to,
1290         uint256 tokenId,
1291         bytes memory _data
1292     ) private returns (bool) {
1293         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1294             return retval == IERC721Receiver(to).onERC721Received.selector;
1295         } catch (bytes memory reason) {
1296             if (reason.length == 0) {
1297                 revert TransferToNonERC721ReceiverImplementer();
1298             } else {
1299                 assembly {
1300                     revert(add(32, reason), mload(reason))
1301                 }
1302             }
1303         }
1304     }
1305 
1306     /**
1307      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1308      * And also called before burning one token.
1309      *
1310      * startTokenId - the first token id to be transferred
1311      * quantity - the amount to be transferred
1312      *
1313      * Calling conditions:
1314      *
1315      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1316      * transferred to `to`.
1317      * - When `from` is zero, `tokenId` will be minted for `to`.
1318      * - When `to` is zero, `tokenId` will be burned by `from`.
1319      * - `from` and `to` are never both zero.
1320      */
1321     function _beforeTokenTransfers(
1322         address from,
1323         address to,
1324         uint256 startTokenId,
1325         uint256 quantity
1326     ) internal virtual {}
1327 
1328     /**
1329      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1330      * minting.
1331      * And also called after one token has been burned.
1332      *
1333      * startTokenId - the first token id to be transferred
1334      * quantity - the amount to be transferred
1335      *
1336      * Calling conditions:
1337      *
1338      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1339      * transferred to `to`.
1340      * - When `from` is zero, `tokenId` has been minted for `to`.
1341      * - When `to` is zero, `tokenId` has been burned by `from`.
1342      * - `from` and `to` are never both zero.
1343      */
1344     function _afterTokenTransfers(
1345         address from,
1346         address to,
1347         uint256 startTokenId,
1348         uint256 quantity
1349     ) internal virtual {}
1350 }
1351 // File: @openzeppelin/contracts/access/Ownable.sol
1352 
1353 
1354 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1355 
1356 pragma solidity ^0.8.0;
1357 
1358 
1359 /**
1360  * @dev Contract module which provides a basic access control mechanism, where
1361  * there is an account (an owner) that can be granted exclusive access to
1362  * specific functions.
1363  *
1364  * By default, the owner account will be the one that deploys the contract. This
1365  * can later be changed with {transferOwnership}.
1366  *
1367  * This module is used through inheritance. It will make available the modifier
1368  * `onlyOwner`, which can be applied to your functions to restrict their use to
1369  * the owner.
1370  */
1371 abstract contract Ownable is Context {
1372     address private _owner;
1373 
1374     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1375 
1376     /**
1377      * @dev Initializes the contract setting the deployer as the initial owner.
1378      */
1379     constructor() {
1380         _transferOwnership(_msgSender());
1381     }
1382 
1383     /**
1384      * @dev Returns the address of the current owner.
1385      */
1386     function owner() public view virtual returns (address) {
1387         return _owner;
1388     }
1389 
1390     /**
1391      * @dev Throws if called by any account other than the owner.
1392      */
1393     modifier onlyOwner() {
1394         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1395         _;
1396     }
1397 
1398     /**
1399      * @dev Leaves the contract without owner. It will not be possible to call
1400      * `onlyOwner` functions anymore. Can only be called by the current owner.
1401      *
1402      * NOTE: Renouncing ownership will leave the contract without an owner,
1403      * thereby removing any functionality that is only available to the owner.
1404      */
1405     function renounceOwnership() public virtual onlyOwner {
1406         _transferOwnership(address(0));
1407     }
1408 
1409     /**
1410      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1411      * Can only be called by the current owner.
1412      */
1413     function transferOwnership(address newOwner) public virtual onlyOwner {
1414         require(newOwner != address(0), "Ownable: new owner is the zero address");
1415         _transferOwnership(newOwner);
1416     }
1417 
1418     /**
1419      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1420      * Internal function without access restriction.
1421      */
1422     function _transferOwnership(address newOwner) internal virtual {
1423         address oldOwner = _owner;
1424         _owner = newOwner;
1425         emit OwnershipTransferred(oldOwner, newOwner);
1426     }
1427 }
1428 
1429 // File: contracts/Commanders.sol
1430 
1431 
1432 // Author: Mas C. (Project Dark Eye)
1433 
1434 pragma solidity ^0.8.0;
1435 
1436 
1437 
1438 
1439 
1440 contract Commanders is Ownable, ERC721DEYE, ReentrancyGuard {
1441     enum ContractStatus {
1442         Paused,
1443         Presale,
1444         Public
1445     }
1446     ContractStatus public contractStatus = ContractStatus.Paused;
1447 
1448     string  public baseURI;
1449     bytes32 public allowanceMerkleRoot;
1450     uint256 public presalePrice = 0.088 ether;
1451     uint256 public presalePriceHolder = 0.058 ether;
1452     uint256 public totalMintSupply = 6666;
1453     uint256 public publicMintTransactionLimit = 5;
1454 
1455     uint256 public startingTime = 1657090800;
1456     uint256 public startingPrice = 2 ether;
1457     uint256 public discountRate = 0.05 ether;
1458     uint256 public discountTime = 3600;
1459     uint256 public endingPrice = 0.088 ether;
1460 
1461     modifier callerIsUser() {
1462         require(tx.origin == msg.sender, "The caller is another contract");
1463         _;
1464     }
1465 
1466     constructor(string memory contractBaseURI, bytes32 merkleRoot)
1467     ERC721DEYE ("Commanders by Project Dark Eye", "DEYECOMMANDER") {
1468         baseURI = contractBaseURI;
1469         allowanceMerkleRoot = merkleRoot;
1470     }
1471 
1472     function _baseURI() internal view override(ERC721DEYE) returns (string memory) {
1473         return baseURI;
1474     }
1475 
1476     function _startTokenId() internal view virtual override(ERC721DEYE) returns (uint256) {
1477         return 1;
1478     }
1479 
1480     function mintPublic(uint64 quantity) public payable callerIsUser {
1481         require(contractStatus == ContractStatus.Public, "Public minting not available"); 
1482         require(msg.value >= getPrice() * quantity, "Not enough ETH sent");
1483         require(_totalMinted() + quantity <= totalMintSupply, "Not enough supply");
1484         require(quantity <= publicMintTransactionLimit, "Exceeds allowed transaction limit");
1485 
1486         _safeMint(msg.sender, quantity);
1487     }
1488 
1489     function mintPresale(uint64 quantity, uint256 allowance, bytes32[] calldata proof) public payable callerIsUser {
1490         require(contractStatus == ContractStatus.Presale, "Presale #1 not available");
1491         require(verifyAllowance(msg.sender, allowance, proof), "Failed allowance verification");
1492         require(_numberMinted(msg.sender) + quantity <= allowance, "Request higher than allowance");
1493         require(msg.value >= presalePriceHolder * quantity, "Not enough ETH sent");
1494 
1495         _safeMint(msg.sender, quantity);
1496     }
1497 
1498     function verifyAllowance(address account, uint256 allowance, bytes32[] calldata proof) public view returns (bool) {
1499         return MerkleProof.verify(proof, allowanceMerkleRoot, generateAllowanceMerkleLeaf(account, allowance));
1500     }
1501 
1502     function generateAllowanceMerkleLeaf(address account, uint256 allowance) public pure returns (bytes32) {
1503         return keccak256(abi.encodePacked(account, allowance));
1504     }
1505     
1506     function getPrice() public view returns (uint256) {
1507         if (block.timestamp < startingTime) {
1508             return startingPrice;
1509         }
1510         uint256 numDiscounts = (block.timestamp - startingTime) / discountTime;
1511         uint256 discountPrice = startingPrice - numDiscounts * discountRate;
1512         return discountPrice >= endingPrice ? discountPrice : endingPrice;
1513     }
1514 
1515     function getMintedQuantity(address account) public view returns (uint256) {
1516         return _numberMinted(account);
1517     }
1518 
1519     function getTokenOwned(address account, uint256 number) public view returns (uint256) {
1520         uint256 count = 0;
1521         for (uint i = 0; i < totalMinted(); i++) {
1522             if (ownerOf(i+1) == account) {
1523                 count += 1;
1524                 if (number == count) {
1525                     return i+1;
1526                 }
1527             }
1528         }
1529         return 0;
1530     }
1531 
1532     // Owner Only
1533 
1534     function setContractStatus(ContractStatus status) public onlyOwner {
1535         contractStatus = status;
1536     }
1537 
1538     function setTotalMintSupply(uint256 supply) public onlyOwner {
1539         totalMintSupply = supply;
1540     }
1541 
1542     function setBaseURI(string memory uri) public onlyOwner {
1543         baseURI = uri;
1544     }
1545     
1546     function setAllowanceMerkleRoot(bytes32 merkleRoot) public onlyOwner {
1547         require(merkleRoot != allowanceMerkleRoot,"merkleRoot is the same as previous value");
1548         allowanceMerkleRoot = merkleRoot;
1549     }
1550 
1551     function setPublicAuction(uint256 startTime, uint256 startPrice, uint256 dcRate, uint256 dcTime, uint256 endPrice) public onlyOwner {
1552         startingTime = startTime;
1553         startingPrice = startPrice;
1554         discountRate = dcRate;
1555         discountTime = dcTime;
1556         endingPrice = endPrice;
1557     }
1558 
1559     function teamMint(address[] memory addresses, uint64[] memory quantities) external onlyOwner {
1560         require(addresses.length == quantities.length, "addresses does not match quatities length");
1561         uint64 totalQuantity = 0;
1562         for (uint i = 0; i < quantities.length; i++) {
1563             totalQuantity += quantities[i];
1564         }
1565         require(_totalMinted() + totalQuantity <= totalMintSupply, "Not enough supply");
1566         for (uint i = 0; i < addresses.length; i++) {
1567             _safeMint(addresses[i], quantities[i]);
1568         }
1569     }
1570 
1571     function burnTokens(uint256[] memory tokenIds) external onlyOwner {
1572         for (uint i = 0; i < tokenIds.length; i++) {
1573             _burn(tokenIds[i]);
1574         }
1575     }
1576 
1577     function withdraw() public onlyOwner nonReentrant {
1578         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1579         require(success, "Transaction Unsuccessful");
1580     }
1581 }