1 // SPDX-License-Identifier: MIT
2 //
3 // ███████╗ ██████╗ ██╗   ██╗███╗   ██╗██████╗ ███████╗██████╗ ███████╗     ██████╗ ███████╗
4 // ██╔════╝██╔═══██╗██║   ██║████╗  ██║██╔══██╗██╔════╝██╔══██╗██╔════╝    ██╔═══██╗██╔════╝
5 // █████╗  ██║   ██║██║   ██║██╔██╗ ██║██║  ██║█████╗  ██████╔╝███████╗    ██║   ██║█████╗  
6 // ██╔══╝  ██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══╝  ██╔══██╗╚════██║    ██║   ██║██╔══╝  
7 // ██║     ╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝███████╗██║  ██║███████║    ╚██████╔╝██║     
8 // ╚═╝      ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝     ╚═════╝ ╚═╝     
9 //  
10 // ███████╗ ██████╗     ██╗    ██╗ ██████╗ ██████╗ ██╗     ██████╗                          
11 // ╚══███╔╝██╔═══██╗    ██║    ██║██╔═══██╗██╔══██╗██║     ██╔══██╗                         
12 //   ███╔╝ ██║   ██║    ██║ █╗ ██║██║   ██║██████╔╝██║     ██║  ██║                         
13 //  ███╔╝  ██║   ██║    ██║███╗██║██║   ██║██╔══██╗██║     ██║  ██║                         
14 // ███████╗╚██████╔╝    ╚███╔███╔╝╚██████╔╝██║  ██║███████╗██████╔╝                         
15 // ╚══════╝ ╚═════╝      ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚══════╝╚═════╝                          
16 //
17 
18 
19 // File: openzeppelin-solidity/contracts/utils/Strings.sol
20 pragma solidity ^0.8.0;
21 
22 /**
23  * @dev String operations.
24  */
25 library Strings {
26     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
27 
28     /**
29      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
30      */
31     function toString(uint256 value) internal pure returns (string memory) {
32         // Inspired by OraclizeAPI's implementation - MIT licence
33         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
34 
35         if (value == 0) {
36             return "0";
37         }
38         uint256 temp = value;
39         uint256 digits;
40         while (temp != 0) {
41             digits++;
42             temp /= 10;
43         }
44         bytes memory buffer = new bytes(digits);
45         while (value != 0) {
46             digits -= 1;
47             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
48             value /= 10;
49         }
50         return string(buffer);
51     }
52 
53     /**
54      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
55      */
56     function toHexString(uint256 value) internal pure returns (string memory) {
57         if (value == 0) {
58             return "0x00";
59         }
60         uint256 temp = value;
61         uint256 length = 0;
62         while (temp != 0) {
63             length++;
64             temp >>= 8;
65         }
66         return toHexString(value, length);
67     }
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
71      */
72     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
73         bytes memory buffer = new bytes(2 * length + 2);
74         buffer[0] = "0";
75         buffer[1] = "x";
76         for (uint256 i = 2 * length + 1; i > 1; --i) {
77             buffer[i] = _HEX_SYMBOLS[value & 0xf];
78             value >>= 4;
79         }
80         require(value == 0, "Strings: hex length insufficient");
81         return string(buffer);
82     }
83 }
84 
85 // File: openzeppelin-solidity/contracts/utils/Address.sol
86 
87 
88 
89 pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Collection of functions related to the address type
93  */
94 library Address {
95     /**
96      * @dev Returns true if `account` is a contract.
97      *
98      * [IMPORTANT]
99      * ====
100      * It is unsafe to assume that an address for which this function returns
101      * false is an externally-owned account (EOA) and not a contract.
102      *
103      * Among others, `isContract` will return false for the following
104      * types of addresses:
105      *
106      *  - an externally-owned account
107      *  - a contract in construction
108      *  - an address where a contract will be created
109      *  - an address where a contract lived, but was destroyed
110      * ====
111      */
112     function isContract(address account) internal view returns (bool) {
113         // This method relies on extcodesize, which returns 0 for contracts in
114         // construction, since the code is only stored at the end of the
115         // constructor execution.
116 
117         uint256 size;
118         assembly {
119             size := extcodesize(account)
120         }
121         return size > 0;
122     }
123 
124     /**
125      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
126      * `recipient`, forwarding all available gas and reverting on errors.
127      *
128      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
129      * of certain opcodes, possibly making contracts go over the 2300 gas limit
130      * imposed by `transfer`, making them unable to receive funds via
131      * `transfer`. {sendValue} removes this limitation.
132      *
133      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
134      *
135      * IMPORTANT: because control is transferred to `recipient`, care must be
136      * taken to not create reentrancy vulnerabilities. Consider using
137      * {ReentrancyGuard} or the
138      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
139      */
140     function sendValue(address payable recipient, uint256 amount) internal {
141         require(address(this).balance >= amount, "Address: insufficient balance");
142 
143         (bool success, ) = recipient.call{value: amount}("");
144         require(success, "Address: unable to send value, recipient may have reverted");
145     }
146 
147     /**
148      * @dev Performs a Solidity function call using a low level `call`. A
149      * plain `call` is an unsafe replacement for a function call: use this
150      * function instead.
151      *
152      * If `target` reverts with a revert reason, it is bubbled up by this
153      * function (like regular Solidity function calls).
154      *
155      * Returns the raw returned data. To convert to the expected return value,
156      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
157      *
158      * Requirements:
159      *
160      * - `target` must be a contract.
161      * - calling `target` with `data` must not revert.
162      *
163      * _Available since v3.1._
164      */
165     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
166         return functionCall(target, data, "Address: low-level call failed");
167     }
168 
169     /**
170      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
171      * `errorMessage` as a fallback revert reason when `target` reverts.
172      *
173      * _Available since v3.1._
174      */
175     function functionCall(
176         address target,
177         bytes memory data,
178         string memory errorMessage
179     ) internal returns (bytes memory) {
180         return functionCallWithValue(target, data, 0, errorMessage);
181     }
182 
183     /**
184      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
185      * but also transferring `value` wei to `target`.
186      *
187      * Requirements:
188      *
189      * - the calling contract must have an ETH balance of at least `value`.
190      * - the called Solidity function must be `payable`.
191      *
192      * _Available since v3.1._
193      */
194     function functionCallWithValue(
195         address target,
196         bytes memory data,
197         uint256 value
198     ) internal returns (bytes memory) {
199         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
200     }
201 
202     /**
203      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
204      * with `errorMessage` as a fallback revert reason when `target` reverts.
205      *
206      * _Available since v3.1._
207      */
208     function functionCallWithValue(
209         address target,
210         bytes memory data,
211         uint256 value,
212         string memory errorMessage
213     ) internal returns (bytes memory) {
214         require(address(this).balance >= value, "Address: insufficient balance for call");
215         require(isContract(target), "Address: call to non-contract");
216 
217         (bool success, bytes memory returndata) = target.call{value: value}(data);
218         return verifyCallResult(success, returndata, errorMessage);
219     }
220 
221     /**
222      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
223      * but performing a static call.
224      *
225      * _Available since v3.3._
226      */
227     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
228         return functionStaticCall(target, data, "Address: low-level static call failed");
229     }
230 
231     /**
232      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
233      * but performing a static call.
234      *
235      * _Available since v3.3._
236      */
237     function functionStaticCall(
238         address target,
239         bytes memory data,
240         string memory errorMessage
241     ) internal view returns (bytes memory) {
242         require(isContract(target), "Address: static call to non-contract");
243 
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(
265         address target,
266         bytes memory data,
267         string memory errorMessage
268     ) internal returns (bytes memory) {
269         require(isContract(target), "Address: delegate call to non-contract");
270 
271         (bool success, bytes memory returndata) = target.delegatecall(data);
272         return verifyCallResult(success, returndata, errorMessage);
273     }
274 
275     /**
276      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
277      * revert reason using the provided one.
278      *
279      * _Available since v4.3._
280      */
281     function verifyCallResult(
282         bool success,
283         bytes memory returndata,
284         string memory errorMessage
285     ) internal pure returns (bytes memory) {
286         if (success) {
287             return returndata;
288         } else {
289             // Look for revert reason and bubble it up if present
290             if (returndata.length > 0) {
291                 // The easiest way to bubble the revert reason is using memory via assembly
292 
293                 assembly {
294                     let returndata_size := mload(returndata)
295                     revert(add(32, returndata), returndata_size)
296                 }
297             } else {
298                 revert(errorMessage);
299             }
300         }
301     }
302 }
303 
304 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
305 
306 
307 
308 pragma solidity ^0.8.0;
309 
310 /**
311  * @title ERC721 token receiver interface
312  * @dev Interface for any contract that wants to support safeTransfers
313  * from ERC721 asset contracts.
314  */
315 interface IERC721Receiver {
316     /**
317      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
318      * by `operator` from `from`, this function is called.
319      *
320      * It must return its Solidity selector to confirm the token transfer.
321      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
322      *
323      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
324      */
325     function onERC721Received(
326         address operator,
327         address from,
328         uint256 tokenId,
329         bytes calldata data
330     ) external returns (bytes4);
331 }
332 
333 // File: openzeppelin-solidity/contracts/utils/introspection/IERC165.sol
334 
335 
336 
337 pragma solidity ^0.8.0;
338 
339 /**
340  * @dev Interface of the ERC165 standard, as defined in the
341  * https://eips.ethereum.org/EIPS/eip-165[EIP].
342  *
343  * Implementers can declare support of contract interfaces, which can then be
344  * queried by others ({ERC165Checker}).
345  *
346  * For an implementation, see {ERC165}.
347  */
348 interface IERC165 {
349     /**
350      * @dev Returns true if this contract implements the interface defined by
351      * `interfaceId`. See the corresponding
352      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
353      * to learn more about how these ids are created.
354      *
355      * This function call must use less than 30 000 gas.
356      */
357     function supportsInterface(bytes4 interfaceId) external view returns (bool);
358 }
359 
360 // File: openzeppelin-solidity/contracts/utils/introspection/ERC165.sol
361 
362 
363 
364 pragma solidity ^0.8.0;
365 
366 
367 /**
368  * @dev Implementation of the {IERC165} interface.
369  *
370  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
371  * for the additional interface id that will be supported. For example:
372  *
373  * ```solidity
374  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
375  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
376  * }
377  * ```
378  *
379  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
380  */
381 abstract contract ERC165 is IERC165 {
382     /**
383      * @dev See {IERC165-supportsInterface}.
384      */
385     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
386         return interfaceId == type(IERC165).interfaceId;
387     }
388 }
389 
390 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
391 
392 
393 
394 pragma solidity ^0.8.0;
395 
396 
397 /**
398  * @dev Required interface of an ERC721 compliant contract.
399  */
400 interface IERC721 is IERC165 {
401     /**
402      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
403      */
404     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
405 
406     /**
407      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
408      */
409     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
410 
411     /**
412      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
413      */
414     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
415 
416     /**
417      * @dev Returns the number of tokens in ``owner``'s account.
418      */
419     function balanceOf(address owner) external view returns (uint256 balance);
420 
421     /**
422      * @dev Returns the owner of the `tokenId` token.
423      *
424      * Requirements:
425      *
426      * - `tokenId` must exist.
427      */
428     function ownerOf(uint256 tokenId) external view returns (address owner);
429 
430     /**
431      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
432      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
433      *
434      * Requirements:
435      *
436      * - `from` cannot be the zero address.
437      * - `to` cannot be the zero address.
438      * - `tokenId` token must exist and be owned by `from`.
439      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
440      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
441      *
442      * Emits a {Transfer} event.
443      */
444     function safeTransferFrom(
445         address from,
446         address to,
447         uint256 tokenId
448     ) external;
449 
450     /**
451      * @dev Transfers `tokenId` token from `from` to `to`.
452      *
453      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must be owned by `from`.
460      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
461      *
462      * Emits a {Transfer} event.
463      */
464     function transferFrom(
465         address from,
466         address to,
467         uint256 tokenId
468     ) external;
469 
470     /**
471      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
472      * The approval is cleared when the token is transferred.
473      *
474      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
475      *
476      * Requirements:
477      *
478      * - The caller must own the token or be an approved operator.
479      * - `tokenId` must exist.
480      *
481      * Emits an {Approval} event.
482      */
483     function approve(address to, uint256 tokenId) external;
484 
485     /**
486      * @dev Returns the account approved for `tokenId` token.
487      *
488      * Requirements:
489      *
490      * - `tokenId` must exist.
491      */
492     function getApproved(uint256 tokenId) external view returns (address operator);
493 
494     /**
495      * @dev Approve or remove `operator` as an operator for the caller.
496      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
497      *
498      * Requirements:
499      *
500      * - The `operator` cannot be the caller.
501      *
502      * Emits an {ApprovalForAll} event.
503      */
504     function setApprovalForAll(address operator, bool _approved) external;
505 
506     /**
507      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
508      *
509      * See {setApprovalForAll}
510      */
511     function isApprovedForAll(address owner, address operator) external view returns (bool);
512 
513     /**
514      * @dev Safely transfers `tokenId` token from `from` to `to`.
515      *
516      * Requirements:
517      *
518      * - `from` cannot be the zero address.
519      * - `to` cannot be the zero address.
520      * - `tokenId` token must exist and be owned by `from`.
521      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
522      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
523      *
524      * Emits a {Transfer} event.
525      */
526     function safeTransferFrom(
527         address from,
528         address to,
529         uint256 tokenId,
530         bytes calldata data
531     ) external;
532 }
533 
534 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Enumerable.sol
535 
536 
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
543  * @dev See https://eips.ethereum.org/EIPS/eip-721
544  */
545 interface IERC721Enumerable is IERC721 {
546     /**
547      * @dev Returns the total amount of tokens stored by the contract.
548      */
549     function totalSupply() external view returns (uint256);
550 
551     /**
552      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
553      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
554      */
555     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
556 
557     /**
558      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
559      * Use along with {totalSupply} to enumerate all tokens.
560      */
561     function tokenByIndex(uint256 index) external view returns (uint256);
562 }
563 
564 // File: openzeppelin-solidity/contracts/token/ERC721/extensions/IERC721Metadata.sol
565 
566 
567 
568 pragma solidity ^0.8.0;
569 
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
592 // File: openzeppelin-solidity/contracts/utils/cryptography/MerkleProof.sol
593 
594 
595 
596 pragma solidity ^0.8.0;
597 
598 /**
599  * @dev These functions deal with verification of Merkle Trees proofs.
600  *
601  * The proofs can be generated using the JavaScript library
602  * https://github.com/miguelmota/merkletreejs[merkletreejs].
603  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
604  *
605  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
606  */
607 library MerkleProof {
608     /**
609      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
610      * defined by `root`. For this, a `proof` must be provided, containing
611      * sibling hashes on the branch from the leaf to the root of the tree. Each
612      * pair of leaves and each pair of pre-images are assumed to be sorted.
613      */
614     function verify(
615         bytes32[] memory proof,
616         bytes32 root,
617         bytes32 leaf
618     ) internal pure returns (bool) {
619         bytes32 computedHash = leaf;
620 
621         for (uint256 i = 0; i < proof.length; i++) {
622             bytes32 proofElement = proof[i];
623 
624             if (computedHash <= proofElement) {
625                 // Hash(current computed hash + current element of the proof)
626                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
627             } else {
628                 // Hash(current element of the proof + current computed hash)
629                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
630             }
631         }
632 
633         // Check if the computed hash (root) is equal to the provided root
634         return computedHash == root;
635     }
636 }
637 
638 // File: openzeppelin-solidity/contracts/security/ReentrancyGuard.sol
639 
640 
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev Contract module that helps prevent reentrant calls to a function.
646  *
647  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
648  * available, which can be applied to functions to make sure there are no nested
649  * (reentrant) calls to them.
650  *
651  * Note that because there is a single `nonReentrant` guard, functions marked as
652  * `nonReentrant` may not call one another. This can be worked around by making
653  * those functions `private`, and then adding `external` `nonReentrant` entry
654  * points to them.
655  *
656  * TIP: If you would like to learn more about reentrancy and alternative ways
657  * to protect against it, check out our blog post
658  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
659  */
660 abstract contract ReentrancyGuard {
661     // Booleans are more expensive than uint256 or any type that takes up a full
662     // word because each write operation emits an extra SLOAD to first read the
663     // slot's contents, replace the bits taken up by the boolean, and then write
664     // back. This is the compiler's defense against contract upgrades and
665     // pointer aliasing, and it cannot be disabled.
666 
667     // The values being non-zero value makes deployment a bit more expensive,
668     // but in exchange the refund on every call to nonReentrant will be lower in
669     // amount. Since refunds are capped to a percentage of the total
670     // transaction's gas, it is best to keep them low in cases like this one, to
671     // increase the likelihood of the full refund coming into effect.
672     uint256 private constant _NOT_ENTERED = 1;
673     uint256 private constant _ENTERED = 2;
674 
675     uint256 private _status;
676 
677     constructor() {
678         _status = _NOT_ENTERED;
679     }
680 
681     /**
682      * @dev Prevents a contract from calling itself, directly or indirectly.
683      * Calling a `nonReentrant` function from another `nonReentrant`
684      * function is not supported. It is possible to prevent this from happening
685      * by making the `nonReentrant` function external, and make it call a
686      * `private` function that does the actual work.
687      */
688     modifier nonReentrant() {
689         // On the first call to nonReentrant, _notEntered will be true
690         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
691 
692         // Any calls to nonReentrant after this point will fail
693         _status = _ENTERED;
694 
695         _;
696 
697         // By storing the original value once again, a refund is triggered (see
698         // https://eips.ethereum.org/EIPS/eip-2200)
699         _status = _NOT_ENTERED;
700     }
701 }
702 
703 // File: openzeppelin-solidity/contracts/utils/Context.sol
704 
705 
706 
707 pragma solidity ^0.8.0;
708 
709 /**
710  * @dev Provides information about the current execution context, including the
711  * sender of the transaction and its data. While these are generally available
712  * via msg.sender and msg.data, they should not be accessed in such a direct
713  * manner, since when dealing with meta-transactions the account sending and
714  * paying for execution may not be the actual sender (as far as an application
715  * is concerned).
716  *
717  * This contract is only required for intermediate, library-like contracts.
718  */
719 abstract contract Context {
720     function _msgSender() internal view virtual returns (address) {
721         return msg.sender;
722     }
723 
724     function _msgData() internal view virtual returns (bytes calldata) {
725         return msg.data;
726     }
727 }
728 
729 // File: contracts/ERC721A.sol
730 
731 
732 pragma solidity ^0.8.0;
733 
734 
735 
736 
737 
738 
739 
740 
741 
742 /**
743  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
744  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
745  *
746  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
747  *
748  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
749  *
750  * Does not support burning tokens to address(0).
751  */
752 contract ERC721A is
753   Context,
754   ERC165,
755   IERC721,
756   IERC721Metadata,
757   IERC721Enumerable
758 {
759   using Address for address;
760   using Strings for uint256;
761 
762   struct TokenOwnership {
763     address addr;
764     uint64 startTimestamp;
765   }
766 
767   struct AddressData {
768     uint128 balance;
769     uint128 numberMinted;
770   }
771 
772   uint256 private currentIndex = 0;
773 
774   uint256 internal immutable collectionSize;
775   uint256 internal immutable maxBatchSize;
776 
777   // Token name
778   string private _name;
779 
780   // Token symbol
781   string private _symbol;
782 
783   // Mapping from token ID to ownership details
784   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
785   mapping(uint256 => TokenOwnership) private _ownerships;
786 
787   // Mapping owner address to address data
788   mapping(address => AddressData) private _addressData;
789 
790   // Mapping from token ID to approved address
791   mapping(uint256 => address) private _tokenApprovals;
792 
793   // Mapping from owner to operator approvals
794   mapping(address => mapping(address => bool)) private _operatorApprovals;
795 
796   /**
797    * @dev
798    * `maxBatchSize` refers to how much a minter can mint at a time.
799    * `collectionSize_` refers to how many tokens are in the collection.
800    */
801   constructor(
802     string memory name_,
803     string memory symbol_,
804     uint256 maxBatchSize_,
805     uint256 collectionSize_
806   ) {
807     require(
808       collectionSize_ > 0,
809       "ERC721A: collection must have a nonzero supply"
810     );
811     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
812     _name = name_;
813     _symbol = symbol_;
814     maxBatchSize = maxBatchSize_;
815     collectionSize = collectionSize_;
816   }
817 
818   /**
819    * @dev See {IERC721Enumerable-totalSupply}.
820    */
821   function totalSupply() public view override returns (uint256) {
822     return currentIndex;
823   }
824 
825   /**
826    * @dev See {IERC721Enumerable-tokenByIndex}.
827    */
828   function tokenByIndex(uint256 index) public view override returns (uint256) {
829     require(index < totalSupply(), "ERC721A: global index out of bounds");
830     return index;
831   }
832 
833   /**
834    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
835    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
836    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
837    */
838   function tokenOfOwnerByIndex(address owner, uint256 index)
839     public
840     view
841     override
842     returns (uint256)
843   {
844     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
845     uint256 numMintedSoFar = totalSupply();
846     uint256 tokenIdsIdx = 0;
847     address currOwnershipAddr = address(0);
848     for (uint256 i = 0; i < numMintedSoFar; i++) {
849       TokenOwnership memory ownership = _ownerships[i];
850       if (ownership.addr != address(0)) {
851         currOwnershipAddr = ownership.addr;
852       }
853       if (currOwnershipAddr == owner) {
854         if (tokenIdsIdx == index) {
855           return i;
856         }
857         tokenIdsIdx++;
858       }
859     }
860     revert("ERC721A: unable to get token of owner by index");
861   }
862 
863   /**
864    * @dev See {IERC165-supportsInterface}.
865    */
866   function supportsInterface(bytes4 interfaceId)
867     public
868     view
869     virtual
870     override(ERC165, IERC165)
871     returns (bool)
872   {
873     return
874       interfaceId == type(IERC721).interfaceId ||
875       interfaceId == type(IERC721Metadata).interfaceId ||
876       interfaceId == type(IERC721Enumerable).interfaceId ||
877       super.supportsInterface(interfaceId);
878   }
879 
880   /**
881    * @dev See {IERC721-balanceOf}.
882    */
883   function balanceOf(address owner) public view override returns (uint256) {
884     require(owner != address(0), "ERC721A: balance query for the zero address");
885     return uint256(_addressData[owner].balance);
886   }
887 
888   function _numberMinted(address owner) internal view returns (uint256) {
889     require(
890       owner != address(0),
891       "ERC721A: number minted query for the zero address"
892     );
893     return uint256(_addressData[owner].numberMinted);
894   }
895 
896   function ownershipOf(uint256 tokenId)
897     internal
898     view
899     returns (TokenOwnership memory)
900   {
901     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
902 
903     uint256 lowestTokenToCheck;
904     if (tokenId >= maxBatchSize) {
905       lowestTokenToCheck = tokenId - maxBatchSize + 1;
906     }
907 
908     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
909       TokenOwnership memory ownership = _ownerships[curr];
910       if (ownership.addr != address(0)) {
911         return ownership;
912       }
913     }
914 
915     revert("ERC721A: unable to determine the owner of token");
916   }
917 
918   /**
919    * @dev See {IERC721-ownerOf}.
920    */
921   function ownerOf(uint256 tokenId) public view override returns (address) {
922     return ownershipOf(tokenId).addr;
923   }
924 
925   /**
926    * @dev See {IERC721Metadata-name}.
927    */
928   function name() public view virtual override returns (string memory) {
929     return _name;
930   }
931 
932   /**
933    * @dev See {IERC721Metadata-symbol}.
934    */
935   function symbol() public view virtual override returns (string memory) {
936     return _symbol;
937   }
938 
939   /**
940    * @dev See {IERC721Metadata-tokenURI}.
941    */
942   function tokenURI(uint256 tokenId)
943     public
944     view
945     virtual
946     override
947     returns (string memory)
948   {
949     require(
950       _exists(tokenId),
951       "ERC721Metadata: URI query for nonexistent token"
952     );
953 
954     string memory baseURI = _baseURI();
955     return
956       bytes(baseURI).length > 0
957         ? string(abi.encodePacked(baseURI, tokenId.toString()))
958         : "";
959   }
960 
961   /**
962    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
963    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
964    * by default, can be overriden in child contracts.
965    */
966   function _baseURI() internal view virtual returns (string memory) {
967     return "";
968   }
969 
970   /**
971    * @dev See {IERC721-approve}.
972    */
973   function approve(address to, uint256 tokenId) public override {
974     address owner = ERC721A.ownerOf(tokenId);
975     require(to != owner, "ERC721A: approval to current owner");
976 
977     require(
978       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
979       "ERC721A: approve caller is not owner nor approved for all"
980     );
981 
982     _approve(to, tokenId, owner);
983   }
984 
985   /**
986    * @dev See {IERC721-getApproved}.
987    */
988   function getApproved(uint256 tokenId) public view override returns (address) {
989     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
990 
991     return _tokenApprovals[tokenId];
992   }
993 
994   /**
995    * @dev See {IERC721-setApprovalForAll}.
996    */
997   function setApprovalForAll(address operator, bool approved) public override {
998     require(operator != _msgSender(), "ERC721A: approve to caller");
999 
1000     _operatorApprovals[_msgSender()][operator] = approved;
1001     emit ApprovalForAll(_msgSender(), operator, approved);
1002   }
1003 
1004   /**
1005    * @dev See {IERC721-isApprovedForAll}.
1006    */
1007   function isApprovedForAll(address owner, address operator)
1008     public
1009     view
1010     virtual
1011     override
1012     returns (bool)
1013   {
1014     return _operatorApprovals[owner][operator];
1015   }
1016 
1017   /**
1018    * @dev See {IERC721-transferFrom}.
1019    */
1020   function transferFrom(
1021     address from,
1022     address to,
1023     uint256 tokenId
1024   ) public override {
1025     _transfer(from, to, tokenId);
1026   }
1027 
1028   /**
1029    * @dev See {IERC721-safeTransferFrom}.
1030    */
1031   function safeTransferFrom(
1032     address from,
1033     address to,
1034     uint256 tokenId
1035   ) public override {
1036     safeTransferFrom(from, to, tokenId, "");
1037   }
1038 
1039   /**
1040    * @dev See {IERC721-safeTransferFrom}.
1041    */
1042   function safeTransferFrom(
1043     address from,
1044     address to,
1045     uint256 tokenId,
1046     bytes memory _data
1047   ) public override {
1048     _transfer(from, to, tokenId);
1049     require(
1050       _checkOnERC721Received(from, to, tokenId, _data),
1051       "ERC721A: transfer to non ERC721Receiver implementer"
1052     );
1053   }
1054 
1055   /**
1056    * @dev Returns whether `tokenId` exists.
1057    *
1058    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1059    *
1060    * Tokens start existing when they are minted (`_mint`),
1061    */
1062   function _exists(uint256 tokenId) internal view returns (bool) {
1063     return tokenId < currentIndex;
1064   }
1065 
1066   function _safeMint(address to, uint256 quantity) internal {
1067     _safeMint(to, quantity, "");
1068   }
1069 
1070   /**
1071    * @dev Mints `quantity` tokens and transfers them to `to`.
1072    *
1073    * Requirements:
1074    *
1075    * - there must be `quantity` tokens remaining unminted in the total collection.
1076    * - `to` cannot be the zero address.
1077    * - `quantity` cannot be larger than the max batch size.
1078    *
1079    * Emits a {Transfer} event.
1080    */
1081   function _safeMint(
1082     address to,
1083     uint256 quantity,
1084     bytes memory _data
1085   ) internal {
1086     uint256 startTokenId = currentIndex;
1087     require(to != address(0), "ERC721A: mint to the zero address");
1088     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1089     require(!_exists(startTokenId), "ERC721A: token already minted");
1090     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1091 
1092     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1093 
1094     AddressData memory addressData = _addressData[to];
1095     _addressData[to] = AddressData(
1096       addressData.balance + uint128(quantity),
1097       addressData.numberMinted + uint128(quantity)
1098     );
1099     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1100 
1101     uint256 updatedIndex = startTokenId;
1102 
1103     for (uint256 i = 0; i < quantity; i++) {
1104       emit Transfer(address(0), to, updatedIndex);
1105       require(
1106         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1107         "ERC721A: transfer to non ERC721Receiver implementer"
1108       );
1109       updatedIndex++;
1110     }
1111 
1112     currentIndex = updatedIndex;
1113     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1114   }
1115 
1116   /**
1117    * @dev Transfers `tokenId` from `from` to `to`.
1118    *
1119    * Requirements:
1120    *
1121    * - `to` cannot be the zero address.
1122    * - `tokenId` token must be owned by `from`.
1123    *
1124    * Emits a {Transfer} event.
1125    */
1126   function _transfer(
1127     address from,
1128     address to,
1129     uint256 tokenId
1130   ) private {
1131     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1132 
1133     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1134       getApproved(tokenId) == _msgSender() ||
1135       isApprovedForAll(prevOwnership.addr, _msgSender()));
1136 
1137     require(
1138       isApprovedOrOwner,
1139       "ERC721A: transfer caller is not owner nor approved"
1140     );
1141 
1142     require(
1143       prevOwnership.addr == from,
1144       "ERC721A: transfer from incorrect owner"
1145     );
1146     require(to != address(0), "ERC721A: transfer to the zero address");
1147 
1148     _beforeTokenTransfers(from, to, tokenId, 1);
1149 
1150     // Clear approvals from the previous owner
1151     _approve(address(0), tokenId, prevOwnership.addr);
1152 
1153     _addressData[from].balance -= 1;
1154     _addressData[to].balance += 1;
1155     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1156 
1157     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1158     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1159     uint256 nextTokenId = tokenId + 1;
1160     if (_ownerships[nextTokenId].addr == address(0)) {
1161       if (_exists(nextTokenId)) {
1162         _ownerships[nextTokenId] = TokenOwnership(
1163           prevOwnership.addr,
1164           prevOwnership.startTimestamp
1165         );
1166       }
1167     }
1168 
1169     emit Transfer(from, to, tokenId);
1170     _afterTokenTransfers(from, to, tokenId, 1);
1171   }
1172 
1173   /**
1174    * @dev Approve `to` to operate on `tokenId`
1175    *
1176    * Emits a {Approval} event.
1177    */
1178   function _approve(
1179     address to,
1180     uint256 tokenId,
1181     address owner
1182   ) private {
1183     _tokenApprovals[tokenId] = to;
1184     emit Approval(owner, to, tokenId);
1185   }
1186 
1187   uint256 public nextOwnerToExplicitlySet = 0;
1188 
1189   /**
1190    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1191    */
1192   function _setOwnersExplicit(uint256 quantity) internal {
1193     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1194     require(quantity > 0, "quantity must be nonzero");
1195     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1196     if (endIndex > collectionSize - 1) {
1197       endIndex = collectionSize - 1;
1198     }
1199     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1200     require(_exists(endIndex), "not enough minted yet for this cleanup");
1201     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1202       if (_ownerships[i].addr == address(0)) {
1203         TokenOwnership memory ownership = ownershipOf(i);
1204         _ownerships[i] = TokenOwnership(
1205           ownership.addr,
1206           ownership.startTimestamp
1207         );
1208       }
1209     }
1210     nextOwnerToExplicitlySet = endIndex + 1;
1211   }
1212 
1213   /**
1214    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1215    * The call is not executed if the target address is not a contract.
1216    *
1217    * @param from address representing the previous owner of the given token ID
1218    * @param to target address that will receive the tokens
1219    * @param tokenId uint256 ID of the token to be transferred
1220    * @param _data bytes optional data to send along with the call
1221    * @return bool whether the call correctly returned the expected magic value
1222    */
1223   function _checkOnERC721Received(
1224     address from,
1225     address to,
1226     uint256 tokenId,
1227     bytes memory _data
1228   ) private returns (bool) {
1229     if (to.isContract()) {
1230       try
1231         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1232       returns (bytes4 retval) {
1233         return retval == IERC721Receiver(to).onERC721Received.selector;
1234       } catch (bytes memory reason) {
1235         if (reason.length == 0) {
1236           revert("ERC721A: transfer to non ERC721Receiver implementer");
1237         } else {
1238           assembly {
1239             revert(add(32, reason), mload(reason))
1240           }
1241         }
1242       }
1243     } else {
1244       return true;
1245     }
1246   }
1247 
1248   /**
1249    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1250    *
1251    * startTokenId - the first token id to be transferred
1252    * quantity - the amount to be transferred
1253    *
1254    * Calling conditions:
1255    *
1256    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1257    * transferred to `to`.
1258    * - When `from` is zero, `tokenId` will be minted for `to`.
1259    */
1260   function _beforeTokenTransfers(
1261     address from,
1262     address to,
1263     uint256 startTokenId,
1264     uint256 quantity
1265   ) internal virtual {}
1266 
1267   /**
1268    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1269    * minting.
1270    *
1271    * startTokenId - the first token id to be transferred
1272    * quantity - the amount to be transferred
1273    *
1274    * Calling conditions:
1275    *
1276    * - when `from` and `to` are both non-zero.
1277    * - `from` and `to` are never both zero.
1278    */
1279   function _afterTokenTransfers(
1280     address from,
1281     address to,
1282     uint256 startTokenId,
1283     uint256 quantity
1284   ) internal virtual {}
1285 }
1286 // File: openzeppelin-solidity/contracts/access/Ownable.sol
1287 
1288 
1289 
1290 pragma solidity ^0.8.0;
1291 
1292 
1293 /**
1294  * @dev Contract module which provides a basic access control mechanism, where
1295  * there is an account (an owner) that can be granted exclusive access to
1296  * specific functions.
1297  *
1298  * By default, the owner account will be the one that deploys the contract. This
1299  * can later be changed with {transferOwnership}.
1300  *
1301  * This module is used through inheritance. It will make available the modifier
1302  * `onlyOwner`, which can be applied to your functions to restrict their use to
1303  * the owner.
1304  */
1305 abstract contract Ownable is Context {
1306     address private _owner;
1307 
1308     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1309 
1310     /**
1311      * @dev Initializes the contract setting the deployer as the initial owner.
1312      */
1313     constructor() {
1314         _setOwner(_msgSender());
1315     }
1316 
1317     /**
1318      * @dev Returns the address of the current owner.
1319      */
1320     function owner() public view virtual returns (address) {
1321         return _owner;
1322     }
1323 
1324     /**
1325      * @dev Throws if called by any account other than the owner.
1326      */
1327     modifier onlyOwner() {
1328         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1329         _;
1330     }
1331 
1332     /**
1333      * @dev Leaves the contract without owner. It will not be possible to call
1334      * `onlyOwner` functions anymore. Can only be called by the current owner.
1335      *
1336      * NOTE: Renouncing ownership will leave the contract without an owner,
1337      * thereby removing any functionality that is only available to the owner.
1338      */
1339     function renounceOwnership() public virtual onlyOwner {
1340         _setOwner(address(0));
1341     }
1342 
1343     /**
1344      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1345      * Can only be called by the current owner.
1346      */
1347     function transferOwnership(address newOwner) public virtual onlyOwner {
1348         require(newOwner != address(0), "Ownable: new owner is the zero address");
1349         _setOwner(newOwner);
1350     }
1351 
1352     function _setOwner(address newOwner) private {
1353         address oldOwner = _owner;
1354         _owner = newOwner;
1355         emit OwnershipTransferred(oldOwner, newOwner);
1356     }
1357 }
1358 
1359 // File: contracts/Founder.sol
1360 
1361 pragma solidity ^0.8.0;
1362 
1363 
1364 contract Founder is Ownable, ERC721A, ReentrancyGuard {
1365     bool public frozen;
1366     
1367     uint256 public immutable teamMintMax = 1111;
1368 
1369     uint256 public teamMinted;
1370     uint256 public publicMax;
1371     uint256 public pricePerMint;
1372 
1373     bytes32 public merkleRoot;
1374     uint256 public earlyAccessStart;
1375     uint256 public purchaseStart;
1376 
1377     string private tokenBaseURI;
1378     string private tokenBaseURIExt;
1379     uint256 private immutable preSaleMaxMint = 4;
1380     
1381     constructor(
1382     ) ERC721A(
1383         "Founders of Zo World", 
1384         "\\z/", 
1385         10, 
1386         11111
1387     ) {}
1388 
1389     function tokenURI(
1390         uint256 tokenId
1391     ) public view override returns (
1392         string memory
1393     ) {
1394         require(
1395             _exists(tokenId),
1396             "Nonexistent token"
1397         );
1398         return string(
1399             abi.encodePacked(
1400                 tokenBaseURI, 
1401                 Strings.toString(tokenId), 
1402                 tokenBaseURIExt
1403             )
1404         );
1405     }
1406 
1407     function mint(
1408         uint256 amount
1409     ) external payable {
1410         require(
1411             block.timestamp >= purchaseStart,
1412             "sale hasn't started"
1413         );
1414         _mintPublic(
1415             _msgSender(),
1416             amount,
1417             msg.value
1418         );
1419     }
1420 
1421     function mintEarly(
1422         uint256 amount,
1423         bytes32[] calldata merkleProof
1424     ) external payable {
1425         require(
1426             block.timestamp >= earlyAccessStart,
1427             "window closed"
1428         );
1429         require(
1430             balanceOf(_msgSender()) + amount <= preSaleMaxMint,
1431             "wallet mint limit"
1432         );
1433         require(
1434             tx.origin == _msgSender(), 
1435             "contracts not allowed"
1436         );
1437         bytes32 node = keccak256(abi.encodePacked(_msgSender()));
1438         require(
1439             MerkleProof.verify(merkleProof, merkleRoot, node),
1440             "invalid proof"
1441         );
1442         _mintPublic(
1443             _msgSender(),
1444             amount,
1445             msg.value
1446         );
1447     }
1448     
1449     function setPublicMax(
1450         uint256 _publicMax
1451     ) external onlyOwner {
1452         require(
1453             _publicMax <= collectionSize - teamMintMax, 
1454             "too high"
1455         );
1456         publicMax = _publicMax;
1457     }
1458     
1459     function setPricePerMint(
1460         uint256 _pricePerMint
1461     ) external onlyOwner {
1462         pricePerMint = _pricePerMint;
1463     }
1464     
1465     function setMerkleRoot(
1466         bytes32 _merkleRoot
1467     ) external onlyOwner {
1468         merkleRoot = _merkleRoot;
1469     }
1470     
1471     function setEarlyAccessStart(
1472         uint256 _earlyAccessStart
1473     ) external onlyOwner {
1474         earlyAccessStart = _earlyAccessStart;
1475     }
1476     
1477     function setPurchaseStart(
1478         uint256 _purchaseStart
1479     ) external onlyOwner {
1480         purchaseStart = _purchaseStart;
1481     }
1482 
1483     function mintGrant(
1484         address[] calldata _addresses,
1485         uint256[] calldata _amounts
1486     ) external onlyOwner {
1487         require(
1488             _addresses.length == _amounts.length,
1489             "length mismatch"
1490         );
1491         for (uint256 i = 0; i < _addresses.length; i++) {
1492             require(
1493                 teamMinted + _amounts[i] <= teamMintMax,
1494                 "team limit reached"
1495             );
1496             for (uint256 j = 0; j < _amounts[i] / maxBatchSize; j++) {
1497                 _safeMint(_addresses[i], maxBatchSize);
1498             }
1499             _safeMint(_addresses[i], _amounts[i] % maxBatchSize);
1500             teamMinted += _amounts[i];
1501         }
1502     }
1503 
1504     function setURI(
1505         string calldata _tokenBaseURI,
1506         string calldata _tokenBaseURIExt
1507     ) external onlyOwner {
1508         require(
1509             !frozen,
1510             "Contract is frozen"
1511         );
1512         tokenBaseURI = _tokenBaseURI;
1513         tokenBaseURIExt = _tokenBaseURIExt;
1514     }
1515 
1516     function freezeBaseURI(
1517     ) external onlyOwner {
1518         frozen = true;
1519     }
1520     
1521     function withdraw(
1522     ) external onlyOwner {
1523         payable(
1524             0x19aFb0C4f63983d619A3f983D065A68780734336
1525         ).transfer(
1526             address(this).balance
1527         );
1528     }
1529 
1530     function _mintPublic(
1531         address _address,
1532         uint256 amount,
1533         uint256 value
1534     ) internal {
1535         require(
1536             amount <= maxBatchSize,
1537             "max batch limit"
1538         );
1539         require(
1540             totalSupply() + amount <= collectionSize, 
1541             "reached max supply"
1542         );
1543         require(
1544             totalSupply() + amount <= publicMax + teamMinted, 
1545             "reached max public"
1546         );
1547         require(
1548             value >= pricePerMint * amount,
1549             "Not enough ETH sent"
1550         );
1551         _safeMint(_address, amount);
1552     }
1553 
1554 }