1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.0 <0.9.0;
4 
5 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
6 
7 
8 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
9 
10 /**
11  * @dev Contract module that helps prevent reentrant calls to a function.
12  *
13  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
14  * available, which can be applied to functions to make sure there are no nested
15  * (reentrant) calls to them.
16  *
17  * Note that because there is a single `nonReentrant` guard, functions marked as
18  * `nonReentrant` may not call one another. This can be worked around by making
19  * those functions `private`, and then adding `external` `nonReentrant` entry
20  * points to them.
21  *
22  * TIP: If you would like to learn more about reentrancy and alternative ways
23  * to protect against it, check out our blog post
24  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
25  */
26 abstract contract ReentrancyGuard {
27     // Booleans are more expensive than uint256 or any type that takes up a full
28     // word because each write operation emits an extra SLOAD to first read the
29     // slot's contents, replace the bits taken up by the boolean, and then write
30     // back. This is the compiler's defense against contract upgrades and
31     // pointer aliasing, and it cannot be disabled.
32 
33     // The values being non-zero value makes deployment a bit more expensive,
34     // but in exchange the refund on every call to nonReentrant will be lower in
35     // amount. Since refunds are capped to a percentage of the total
36     // transaction's gas, it is best to keep them low in cases like this one, to
37     // increase the likelihood of the full refund coming into effect.
38     uint256 private constant _NOT_ENTERED = 1;
39     uint256 private constant _ENTERED = 2;
40 
41     uint256 private _status;
42 
43     constructor() {
44         _status = _NOT_ENTERED;
45     }
46 
47     /**
48      * @dev Prevents a contract from calling itself, directly or indirectly.
49      * Calling a `nonReentrant` function from another `nonReentrant`
50      * function is not supported. It is possible to prevent this from happening
51      * by making the `nonReentrant` function external, and making it call a
52      * `private` function that does the actual work.
53      */
54     modifier nonReentrant() {
55         // On the first call to nonReentrant, _notEntered will be true
56         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
57 
58         // Any calls to nonReentrant after this point will fail
59         _status = _ENTERED;
60 
61         _;
62 
63         // By storing the original value once again, a refund is triggered (see
64         // https://eips.ethereum.org/EIPS/eip-2200)
65         _status = _NOT_ENTERED;
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
73 
74 /**
75  * @dev These functions deal with verification of Merkle Trees proofs.
76  *
77  * The proofs can be generated using the JavaScript library
78  * https://github.com/miguelmota/merkletreejs[merkletreejs].
79  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
80  *
81  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
82  */
83 library MerkleProof {
84     /**
85      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
86      * defined by `root`. For this, a `proof` must be provided, containing
87      * sibling hashes on the branch from the leaf to the root of the tree. Each
88      * pair of leaves and each pair of pre-images are assumed to be sorted.
89      */
90     function verify(
91         bytes32[] memory proof,
92         bytes32 root,
93         bytes32 leaf
94     ) internal pure returns (bool) {
95         return processProof(proof, leaf) == root;
96     }
97 
98     /**
99      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
100      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
101      * hash matches the root of the tree. When processing the proof, the pairs
102      * of leafs & pre-images are assumed to be sorted.
103      *
104      * _Available since v4.4._
105      */
106     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
107         bytes32 computedHash = leaf;
108         for (uint256 i = 0; i < proof.length; i++) {
109             bytes32 proofElement = proof[i];
110             if (computedHash <= proofElement) {
111                 // Hash(current computed hash + current element of the proof)
112                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
113             } else {
114                 // Hash(current element of the proof + current computed hash)
115                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
116             }
117         }
118         return computedHash;
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Strings.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
126 
127 /**
128  * @dev String operations.
129  */
130 library Strings {
131     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
135      */
136     function toString(uint256 value) internal pure returns (string memory) {
137         // Inspired by OraclizeAPI's implementation - MIT licence
138         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
139 
140         if (value == 0) {
141             return "0";
142         }
143         uint256 temp = value;
144         uint256 digits;
145         while (temp != 0) {
146             digits++;
147             temp /= 10;
148         }
149         bytes memory buffer = new bytes(digits);
150         while (value != 0) {
151             digits -= 1;
152             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
153             value /= 10;
154         }
155         return string(buffer);
156     }
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
160      */
161     function toHexString(uint256 value) internal pure returns (string memory) {
162         if (value == 0) {
163             return "0x00";
164         }
165         uint256 temp = value;
166         uint256 length = 0;
167         while (temp != 0) {
168             length++;
169             temp >>= 8;
170         }
171         return toHexString(value, length);
172     }
173 
174     /**
175      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
176      */
177     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
178         bytes memory buffer = new bytes(2 * length + 2);
179         buffer[0] = "0";
180         buffer[1] = "x";
181         for (uint256 i = 2 * length + 1; i > 1; --i) {
182             buffer[i] = _HEX_SYMBOLS[value & 0xf];
183             value >>= 4;
184         }
185         require(value == 0, "Strings: hex length insufficient");
186         return string(buffer);
187     }
188 }
189 
190 // File: @openzeppelin/contracts/utils/Context.sol
191 
192 
193 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
194 
195 /**
196  * @dev Provides information about the current execution context, including the
197  * sender of the transaction and its data. While these are generally available
198  * via msg.sender and msg.data, they should not be accessed in such a direct
199  * manner, since when dealing with meta-transactions the account sending and
200  * paying for execution may not be the actual sender (as far as an application
201  * is concerned).
202  *
203  * This contract is only required for intermediate, library-like contracts.
204  */
205 abstract contract Context {
206     function _msgSender() internal view virtual returns (address) {
207         return msg.sender;
208     }
209 
210     function _msgData() internal view virtual returns (bytes calldata) {
211         return msg.data;
212     }
213 }
214 
215 // File: @openzeppelin/contracts/access/Ownable.sol
216 
217 
218 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
219 
220 
221 /**
222  * @dev Contract module which provides a basic access control mechanism, where
223  * there is an account (an owner) that can be granted exclusive access to
224  * specific functions.
225  *
226  * By default, the owner account will be the one that deploys the contract. This
227  * can later be changed with {transferOwnership}.
228  *
229  * This module is used through inheritance. It will make available the modifier
230  * `onlyOwner`, which can be applied to your functions to restrict their use to
231  * the owner.
232  */
233 abstract contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor() {
242         _transferOwnership(_msgSender());
243     }
244 
245     /**
246      * @dev Returns the address of the current owner.
247      */
248     function owner() public view virtual returns (address) {
249         return _owner;
250     }
251 
252     /**
253      * @dev Throws if called by any account other than the owner.
254      */
255     modifier onlyOwner() {
256         require(owner() == _msgSender(), "Ownable: caller is not the owner");
257         _;
258     }
259 
260     /**
261      * @dev Leaves the contract without owner. It will not be possible to call
262      * `onlyOwner` functions anymore. Can only be called by the current owner.
263      *
264      * NOTE: Renouncing ownership will leave the contract without an owner,
265      * thereby removing any functionality that is only available to the owner.
266      */
267     function renounceOwnership() public virtual onlyOwner {
268         _transferOwnership(address(0));
269     }
270 
271     /**
272      * @dev Transfers ownership of the contract to a new account (`newOwner`).
273      * Can only be called by the current owner.
274      */
275     function transferOwnership(address newOwner) public virtual onlyOwner {
276         require(newOwner != address(0), "Ownable: new owner is the zero address");
277         _transferOwnership(newOwner);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Internal function without access restriction.
283      */
284     function _transferOwnership(address newOwner) internal virtual {
285         address oldOwner = _owner;
286         _owner = newOwner;
287         emit OwnershipTransferred(oldOwner, newOwner);
288     }
289 }
290 
291 // File: @openzeppelin/contracts/utils/Address.sol
292 
293 
294 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      */
317     function isContract(address account) internal view returns (bool) {
318         // This method relies on extcodesize, which returns 0 for contracts in
319         // construction, since the code is only stored at the end of the
320         // constructor execution.
321 
322         uint256 size;
323         assembly {
324             size := extcodesize(account)
325         }
326         return size > 0;
327     }
328 
329     /**
330      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
331      * `recipient`, forwarding all available gas and reverting on errors.
332      *
333      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
334      * of certain opcodes, possibly making contracts go over the 2300 gas limit
335      * imposed by `transfer`, making them unable to receive funds via
336      * `transfer`. {sendValue} removes this limitation.
337      *
338      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
339      *
340      * IMPORTANT: because control is transferred to `recipient`, care must be
341      * taken to not create reentrancy vulnerabilities. Consider using
342      * {ReentrancyGuard} or the
343      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
344      */
345     function sendValue(address payable recipient, uint256 amount) internal {
346         require(address(this).balance >= amount, "Address: insufficient balance");
347 
348         (bool success, ) = recipient.call{value: amount}("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353      * @dev Performs a Solidity function call using a low level `call`. A
354      * plain `call` is an unsafe replacement for a function call: use this
355      * function instead.
356      *
357      * If `target` reverts with a revert reason, it is bubbled up by this
358      * function (like regular Solidity function calls).
359      *
360      * Returns the raw returned data. To convert to the expected return value,
361      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362      *
363      * Requirements:
364      *
365      * - `target` must be a contract.
366      * - calling `target` with `data` must not revert.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(
381         address target,
382         bytes memory data,
383         string memory errorMessage
384     ) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, 0, errorMessage);
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
390      * but also transferring `value` wei to `target`.
391      *
392      * Requirements:
393      *
394      * - the calling contract must have an ETH balance of at least `value`.
395      * - the called Solidity function must be `payable`.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(
400         address target,
401         bytes memory data,
402         uint256 value
403     ) internal returns (bytes memory) {
404         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
409      * with `errorMessage` as a fallback revert reason when `target` reverts.
410      *
411      * _Available since v3.1._
412      */
413     function functionCallWithValue(
414         address target,
415         bytes memory data,
416         uint256 value,
417         string memory errorMessage
418     ) internal returns (bytes memory) {
419         require(address(this).balance >= value, "Address: insufficient balance for call");
420         require(isContract(target), "Address: call to non-contract");
421 
422         (bool success, bytes memory returndata) = target.call{value: value}(data);
423         return verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
433         return functionStaticCall(target, data, "Address: low-level static call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(
443         address target,
444         bytes memory data,
445         string memory errorMessage
446     ) internal view returns (bytes memory) {
447         require(isContract(target), "Address: static call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.staticcall(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but performing a delegate call.
456      *
457      * _Available since v3.4._
458      */
459     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
460         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a delegate call.
466      *
467      * _Available since v3.4._
468      */
469     function functionDelegateCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal returns (bytes memory) {
474         require(isContract(target), "Address: delegate call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.delegatecall(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
482      * revert reason using the provided one.
483      *
484      * _Available since v4.3._
485      */
486     function verifyCallResult(
487         bool success,
488         bytes memory returndata,
489         string memory errorMessage
490     ) internal pure returns (bytes memory) {
491         if (success) {
492             return returndata;
493         } else {
494             // Look for revert reason and bubble it up if present
495             if (returndata.length > 0) {
496                 // The easiest way to bubble the revert reason is using memory via assembly
497 
498                 assembly {
499                     let returndata_size := mload(returndata)
500                     revert(add(32, returndata), returndata_size)
501                 }
502             } else {
503                 revert(errorMessage);
504             }
505         }
506     }
507 }
508 
509 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
513 
514 /**
515  * @title ERC721 token receiver interface
516  * @dev Interface for any contract that wants to support safeTransfers
517  * from ERC721 asset contracts.
518  */
519 interface IERC721Receiver {
520     /**
521      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
522      * by `operator` from `from`, this function is called.
523      *
524      * It must return its Solidity selector to confirm the token transfer.
525      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
526      *
527      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
528      */
529     function onERC721Received(
530         address operator,
531         address from,
532         uint256 tokenId,
533         bytes calldata data
534     ) external returns (bytes4);
535 }
536 
537 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
541 
542 /**
543  * @dev Interface of the ERC165 standard, as defined in the
544  * https://eips.ethereum.org/EIPS/eip-165[EIP].
545  *
546  * Implementers can declare support of contract interfaces, which can then be
547  * queried by others ({ERC165Checker}).
548  *
549  * For an implementation, see {ERC165}.
550  */
551 interface IERC165 {
552     /**
553      * @dev Returns true if this contract implements the interface defined by
554      * `interfaceId`. See the corresponding
555      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
556      * to learn more about how these ids are created.
557      *
558      * This function call must use less than 30 000 gas.
559      */
560     function supportsInterface(bytes4 interfaceId) external view returns (bool);
561 }
562 
563 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
564 
565 
566 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
567 
568 
569 /**
570  * @dev Implementation of the {IERC165} interface.
571  *
572  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
573  * for the additional interface id that will be supported. For example:
574  *
575  * ```solidity
576  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
577  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
578  * }
579  * ```
580  *
581  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
582  */
583 abstract contract ERC165 is IERC165 {
584     /**
585      * @dev See {IERC165-supportsInterface}.
586      */
587     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
588         return interfaceId == type(IERC165).interfaceId;
589     }
590 }
591 
592 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
593 
594 
595 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
596 
597 
598 /**
599  * @dev Required interface of an ERC721 compliant contract.
600  */
601 interface IERC721 is IERC165 {
602     /**
603      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
604      */
605     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
606 
607     /**
608      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
609      */
610     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
611 
612     /**
613      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
614      */
615     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
616 
617     /**
618      * @dev Returns the number of tokens in ``owner``'s account.
619      */
620     function balanceOf(address owner) external view returns (uint256 balance);
621 
622     /**
623      * @dev Returns the owner of the `tokenId` token.
624      *
625      * Requirements:
626      *
627      * - `tokenId` must exist.
628      */
629     function ownerOf(uint256 tokenId) external view returns (address owner);
630 
631     /**
632      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
633      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
634      *
635      * Requirements:
636      *
637      * - `from` cannot be the zero address.
638      * - `to` cannot be the zero address.
639      * - `tokenId` token must exist and be owned by `from`.
640      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
641      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
642      *
643      * Emits a {Transfer} event.
644      */
645     function safeTransferFrom(
646         address from,
647         address to,
648         uint256 tokenId
649     ) external;
650 
651     /**
652      * @dev Transfers `tokenId` token from `from` to `to`.
653      *
654      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
655      *
656      * Requirements:
657      *
658      * - `from` cannot be the zero address.
659      * - `to` cannot be the zero address.
660      * - `tokenId` token must be owned by `from`.
661      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
662      *
663      * Emits a {Transfer} event.
664      */
665     function transferFrom(
666         address from,
667         address to,
668         uint256 tokenId
669     ) external;
670 
671     /**
672      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
673      * The approval is cleared when the token is transferred.
674      *
675      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
676      *
677      * Requirements:
678      *
679      * - The caller must own the token or be an approved operator.
680      * - `tokenId` must exist.
681      *
682      * Emits an {Approval} event.
683      */
684     function approve(address to, uint256 tokenId) external;
685 
686     /**
687      * @dev Returns the account approved for `tokenId` token.
688      *
689      * Requirements:
690      *
691      * - `tokenId` must exist.
692      */
693     function getApproved(uint256 tokenId) external view returns (address operator);
694 
695     /**
696      * @dev Approve or remove `operator` as an operator for the caller.
697      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
698      *
699      * Requirements:
700      *
701      * - The `operator` cannot be the caller.
702      *
703      * Emits an {ApprovalForAll} event.
704      */
705     function setApprovalForAll(address operator, bool _approved) external;
706 
707     /**
708      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
709      *
710      * See {setApprovalForAll}
711      */
712     function isApprovedForAll(address owner, address operator) external view returns (bool);
713 
714     /**
715      * @dev Safely transfers `tokenId` token from `from` to `to`.
716      *
717      * Requirements:
718      *
719      * - `from` cannot be the zero address.
720      * - `to` cannot be the zero address.
721      * - `tokenId` token must exist and be owned by `from`.
722      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
723      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
724      *
725      * Emits a {Transfer} event.
726      */
727     function safeTransferFrom(
728         address from,
729         address to,
730         uint256 tokenId,
731         bytes calldata data
732     ) external;
733 }
734 
735 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
736 
737 
738 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
739 
740 
741 /**
742  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
743  * @dev See https://eips.ethereum.org/EIPS/eip-721
744  */
745 interface IERC721Enumerable is IERC721 {
746     /**
747      * @dev Returns the total amount of tokens stored by the contract.
748      */
749     function totalSupply() external view returns (uint256);
750 
751     /**
752      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
753      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
754      */
755     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
756 
757     /**
758      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
759      * Use along with {totalSupply} to enumerate all tokens.
760      */
761     function tokenByIndex(uint256 index) external view returns (uint256);
762 }
763 
764 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
765 
766 
767 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
768 
769 
770 /**
771  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
772  * @dev See https://eips.ethereum.org/EIPS/eip-721
773  */
774 interface IERC721Metadata is IERC721 {
775     /**
776      * @dev Returns the token collection name.
777      */
778     function name() external view returns (string memory);
779 
780     /**
781      * @dev Returns the token collection symbol.
782      */
783     function symbol() external view returns (string memory);
784 
785     /**
786      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
787      */
788     function tokenURI(uint256 tokenId) external view returns (string memory);
789 }
790 
791 // File: https://github.com/chiru-labs/ERC721A/blob/v3.0.0/contracts/ERC721A.sol
792 
793 
794 // Creator: Chiru Labs
795 
796 error ApprovalCallerNotOwnerNorApproved();
797 error ApprovalQueryForNonexistentToken();
798 error ApproveToCaller();
799 error ApprovalToCurrentOwner();
800 error BalanceQueryForZeroAddress();
801 error MintedQueryForZeroAddress();
802 error BurnedQueryForZeroAddress();
803 error AuxQueryForZeroAddress();
804 error MintToZeroAddress();
805 error MintZeroQuantity();
806 error OwnerIndexOutOfBounds();
807 error OwnerQueryForNonexistentToken();
808 error TokenIndexOutOfBounds();
809 error TransferCallerNotOwnerNorApproved();
810 error TransferFromIncorrectOwner();
811 error TransferToNonERC721ReceiverImplementer();
812 error TransferToZeroAddress();
813 error URIQueryForNonexistentToken();
814 
815 /**
816  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
817  * the Metadata extension. Built to optimize for lower gas during batch mints.
818  *
819  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
820  *
821  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
822  *
823  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
824  */
825 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
826     using Address for address;
827     using Strings for uint256;
828 
829     // Compiler will pack this into a single 256bit word.
830     struct TokenOwnership {
831         // The address of the owner.
832         address addr;
833         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
834         uint64 startTimestamp;
835         // Whether the token has been burned.
836         bool burned;
837     }
838 
839     // Compiler will pack this into a single 256bit word.
840     struct AddressData {
841         // Realistically, 2**64-1 is more than enough.
842         uint64 balance;
843         // Keeps track of mint count with minimal overhead for tokenomics.
844         uint64 numberMinted;
845         // Keeps track of burn count with minimal overhead for tokenomics.
846         uint64 numberBurned;
847         // For miscellaneous variable(s) pertaining to the address
848         // (e.g. number of whitelist mint slots used).
849         // If there are multiple variables, please pack them into a uint64.
850         uint64 aux;
851     }
852 
853     // The tokenId of the next token to be minted.
854     uint256 internal _currentIndex;
855 
856     // The number of tokens burned.
857     uint256 internal _burnCounter;
858 
859     // Token name
860     string private _name;
861 
862     // Token symbol
863     string private _symbol;
864 
865     // Mapping from token ID to ownership details
866     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
867     mapping(uint256 => TokenOwnership) internal _ownerships;
868 
869     // Mapping owner address to address data
870     mapping(address => AddressData) private _addressData;
871 
872     // Mapping from token ID to approved address
873     mapping(uint256 => address) private _tokenApprovals;
874 
875     // Mapping from owner to operator approvals
876     mapping(address => mapping(address => bool)) private _operatorApprovals;
877 
878     constructor(string memory name_, string memory symbol_) {
879         _name = name_;
880         _symbol = symbol_;
881         _currentIndex = _startTokenId();
882     }
883 
884     /**
885      * To change the starting tokenId, please override this function.
886      */
887     function _startTokenId() internal view virtual returns (uint256) {
888         return 0;
889     }
890 
891     /**
892      * @dev See {IERC721Enumerable-totalSupply}.
893      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
894      */
895     function totalSupply() public view returns (uint256) {
896         // Counter underflow is impossible as _burnCounter cannot be incremented
897         // more than _currentIndex - _startTokenId() times
898         unchecked {
899             return _currentIndex - _burnCounter - _startTokenId();
900         }
901     }
902 
903     /**
904      * Returns the total amount of tokens minted in the contract.
905      */
906     function _totalMinted() internal view returns (uint256) {
907         // Counter underflow is impossible as _currentIndex does not decrement,
908         // and it is initialized to _startTokenId()
909         unchecked {
910             return _currentIndex - _startTokenId();
911         }
912     }
913 
914     /**
915      * @dev See {IERC165-supportsInterface}.
916      */
917     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
918         return
919             interfaceId == type(IERC721).interfaceId ||
920             interfaceId == type(IERC721Metadata).interfaceId ||
921             super.supportsInterface(interfaceId);
922     }
923 
924     /**
925      * @dev See {IERC721-balanceOf}.
926      */
927     function balanceOf(address owner) public view override returns (uint256) {
928         if (owner == address(0)) revert BalanceQueryForZeroAddress();
929         return uint256(_addressData[owner].balance);
930     }
931 
932     /**
933      * Returns the number of tokens minted by `owner`.
934      */
935     function _numberMinted(address owner) internal view returns (uint256) {
936         if (owner == address(0)) revert MintedQueryForZeroAddress();
937         return uint256(_addressData[owner].numberMinted);
938     }
939 
940     /**
941      * Returns the number of tokens burned by or on behalf of `owner`.
942      */
943     function _numberBurned(address owner) internal view returns (uint256) {
944         if (owner == address(0)) revert BurnedQueryForZeroAddress();
945         return uint256(_addressData[owner].numberBurned);
946     }
947 
948     /**
949      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
950      */
951     function _getAux(address owner) internal view returns (uint64) {
952         if (owner == address(0)) revert AuxQueryForZeroAddress();
953         return _addressData[owner].aux;
954     }
955 
956     /**
957      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
958      * If there are multiple variables, please pack them into a uint64.
959      */
960     function _setAux(address owner, uint64 aux) internal {
961         if (owner == address(0)) revert AuxQueryForZeroAddress();
962         _addressData[owner].aux = aux;
963     }
964 
965     /**
966      * Gas spent here starts off proportional to the maximum mint batch size.
967      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
968      */
969     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
970         uint256 curr = tokenId;
971 
972         unchecked {
973             if (_startTokenId() <= curr && curr < _currentIndex) {
974                 TokenOwnership memory ownership = _ownerships[curr];
975                 if (!ownership.burned) {
976                     if (ownership.addr != address(0)) {
977                         return ownership;
978                     }
979                     // Invariant:
980                     // There will always be an ownership that has an address and is not burned
981                     // before an ownership that does not have an address and is not burned.
982                     // Hence, curr will not underflow.
983                     while (true) {
984                         curr--;
985                         ownership = _ownerships[curr];
986                         if (ownership.addr != address(0)) {
987                             return ownership;
988                         }
989                     }
990                 }
991             }
992         }
993         revert OwnerQueryForNonexistentToken();
994     }
995 
996     /**
997      * @dev See {IERC721-ownerOf}.
998      */
999     function ownerOf(uint256 tokenId) public view override returns (address) {
1000         return ownershipOf(tokenId).addr;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-name}.
1005      */
1006     function name() public view virtual override returns (string memory) {
1007         return _name;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-symbol}.
1012      */
1013     function symbol() public view virtual override returns (string memory) {
1014         return _symbol;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-tokenURI}.
1019      */
1020     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1021         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1022 
1023         string memory baseURI = _baseURI();
1024         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1025     }
1026 
1027     /**
1028      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1029      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1030      * by default, can be overriden in child contracts.
1031      */
1032     function _baseURI() internal view virtual returns (string memory) {
1033         return '';
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-approve}.
1038      */
1039     function approve(address to, uint256 tokenId) public override {
1040         address owner = ERC721A.ownerOf(tokenId);
1041         if (to == owner) revert ApprovalToCurrentOwner();
1042 
1043         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1044             revert ApprovalCallerNotOwnerNorApproved();
1045         }
1046 
1047         _approve(to, tokenId, owner);
1048     }
1049 
1050     /**
1051      * @dev See {IERC721-getApproved}.
1052      */
1053     function getApproved(uint256 tokenId) public view override returns (address) {
1054         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1055 
1056         return _tokenApprovals[tokenId];
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-setApprovalForAll}.
1061      */
1062     function setApprovalForAll(address operator, bool approved) public override {
1063         if (operator == _msgSender()) revert ApproveToCaller();
1064 
1065         _operatorApprovals[_msgSender()][operator] = approved;
1066         emit ApprovalForAll(_msgSender(), operator, approved);
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-isApprovedForAll}.
1071      */
1072     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1073         return _operatorApprovals[owner][operator];
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-transferFrom}.
1078      */
1079     function transferFrom(
1080         address from,
1081         address to,
1082         uint256 tokenId
1083     ) public virtual override {
1084         _transfer(from, to, tokenId);
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-safeTransferFrom}.
1089      */
1090     function safeTransferFrom(
1091         address from,
1092         address to,
1093         uint256 tokenId
1094     ) public virtual override {
1095         safeTransferFrom(from, to, tokenId, '');
1096     }
1097 
1098     /**
1099      * @dev See {IERC721-safeTransferFrom}.
1100      */
1101     function safeTransferFrom(
1102         address from,
1103         address to,
1104         uint256 tokenId,
1105         bytes memory _data
1106     ) public virtual override {
1107         _transfer(from, to, tokenId);
1108         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1109             revert TransferToNonERC721ReceiverImplementer();
1110         }
1111     }
1112 
1113     /**
1114      * @dev Returns whether `tokenId` exists.
1115      *
1116      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1117      *
1118      * Tokens start existing when they are minted (`_mint`),
1119      */
1120     function _exists(uint256 tokenId) internal view returns (bool) {
1121         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1122             !_ownerships[tokenId].burned;
1123     }
1124 
1125     function _safeMint(address to, uint256 quantity) internal {
1126         _safeMint(to, quantity, '');
1127     }
1128 
1129     /**
1130      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1131      *
1132      * Requirements:
1133      *
1134      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1135      * - `quantity` must be greater than 0.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function _safeMint(
1140         address to,
1141         uint256 quantity,
1142         bytes memory _data
1143     ) internal {
1144         _mint(to, quantity, _data, true);
1145     }
1146 
1147     /**
1148      * @dev Mints `quantity` tokens and transfers them to `to`.
1149      *
1150      * Requirements:
1151      *
1152      * - `to` cannot be the zero address.
1153      * - `quantity` must be greater than 0.
1154      *
1155      * Emits a {Transfer} event.
1156      */
1157     function _mint(
1158         address to,
1159         uint256 quantity,
1160         bytes memory _data,
1161         bool safe
1162     ) internal {
1163         uint256 startTokenId = _currentIndex;
1164         if (to == address(0)) revert MintToZeroAddress();
1165         if (quantity == 0) revert MintZeroQuantity();
1166 
1167         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1168 
1169         // Overflows are incredibly unrealistic.
1170         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1171         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1172         unchecked {
1173             _addressData[to].balance += uint64(quantity);
1174             _addressData[to].numberMinted += uint64(quantity);
1175 
1176             _ownerships[startTokenId].addr = to;
1177             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1178 
1179             uint256 updatedIndex = startTokenId;
1180             uint256 end = updatedIndex + quantity;
1181 
1182             if (safe && to.isContract()) {
1183                 do {
1184                     emit Transfer(address(0), to, updatedIndex);
1185                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1186                         revert TransferToNonERC721ReceiverImplementer();
1187                     }
1188                 } while (updatedIndex != end);
1189                 // Reentrancy protection
1190                 if (_currentIndex != startTokenId) revert();
1191             } else {
1192                 do {
1193                     emit Transfer(address(0), to, updatedIndex++);
1194                 } while (updatedIndex != end);
1195             }
1196             _currentIndex = updatedIndex;
1197         }
1198         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1199     }
1200 
1201     /**
1202      * @dev Transfers `tokenId` from `from` to `to`.
1203      *
1204      * Requirements:
1205      *
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must be owned by `from`.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _transfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) private {
1216         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1217 
1218         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1219             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1220             getApproved(tokenId) == _msgSender());
1221 
1222         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1223         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1224         if (to == address(0)) revert TransferToZeroAddress();
1225 
1226         _beforeTokenTransfers(from, to, tokenId, 1);
1227 
1228         // Clear approvals from the previous owner
1229         _approve(address(0), tokenId, prevOwnership.addr);
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1234         unchecked {
1235             _addressData[from].balance -= 1;
1236             _addressData[to].balance += 1;
1237 
1238             _ownerships[tokenId].addr = to;
1239             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1240 
1241             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1242             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1243             uint256 nextTokenId = tokenId + 1;
1244             if (_ownerships[nextTokenId].addr == address(0)) {
1245                 // This will suffice for checking _exists(nextTokenId),
1246                 // as a burned slot cannot contain the zero address.
1247                 if (nextTokenId < _currentIndex) {
1248                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1249                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1250                 }
1251             }
1252         }
1253 
1254         emit Transfer(from, to, tokenId);
1255         _afterTokenTransfers(from, to, tokenId, 1);
1256     }
1257 
1258     /**
1259      * @dev Destroys `tokenId`.
1260      * The approval is cleared when the token is burned.
1261      *
1262      * Requirements:
1263      *
1264      * - `tokenId` must exist.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _burn(uint256 tokenId) internal virtual {
1269         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1270 
1271         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1272 
1273         // Clear approvals from the previous owner
1274         _approve(address(0), tokenId, prevOwnership.addr);
1275 
1276         // Underflow of the sender's balance is impossible because we check for
1277         // ownership above and the recipient's balance can't realistically overflow.
1278         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1279         unchecked {
1280             _addressData[prevOwnership.addr].balance -= 1;
1281             _addressData[prevOwnership.addr].numberBurned += 1;
1282 
1283             // Keep track of who burned the token, and the timestamp of burning.
1284             _ownerships[tokenId].addr = prevOwnership.addr;
1285             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1286             _ownerships[tokenId].burned = true;
1287 
1288             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1289             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1290             uint256 nextTokenId = tokenId + 1;
1291             if (_ownerships[nextTokenId].addr == address(0)) {
1292                 // This will suffice for checking _exists(nextTokenId),
1293                 // as a burned slot cannot contain the zero address.
1294                 if (nextTokenId < _currentIndex) {
1295                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1296                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1297                 }
1298             }
1299         }
1300 
1301         emit Transfer(prevOwnership.addr, address(0), tokenId);
1302         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1303 
1304         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1305         unchecked {
1306             _burnCounter++;
1307         }
1308     }
1309 
1310     /**
1311      * @dev Approve `to` to operate on `tokenId`
1312      *
1313      * Emits a {Approval} event.
1314      */
1315     function _approve(
1316         address to,
1317         uint256 tokenId,
1318         address owner
1319     ) private {
1320         _tokenApprovals[tokenId] = to;
1321         emit Approval(owner, to, tokenId);
1322     }
1323 
1324     /**
1325      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1326      *
1327      * @param from address representing the previous owner of the given token ID
1328      * @param to target address that will receive the tokens
1329      * @param tokenId uint256 ID of the token to be transferred
1330      * @param _data bytes optional data to send along with the call
1331      * @return bool whether the call correctly returned the expected magic value
1332      */
1333     function _checkContractOnERC721Received(
1334         address from,
1335         address to,
1336         uint256 tokenId,
1337         bytes memory _data
1338     ) private returns (bool) {
1339         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1340             return retval == IERC721Receiver(to).onERC721Received.selector;
1341         } catch (bytes memory reason) {
1342             if (reason.length == 0) {
1343                 revert TransferToNonERC721ReceiverImplementer();
1344             } else {
1345                 assembly {
1346                     revert(add(32, reason), mload(reason))
1347                 }
1348             }
1349         }
1350     }
1351 
1352     /**
1353      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1354      * And also called before burning one token.
1355      *
1356      * startTokenId - the first token id to be transferred
1357      * quantity - the amount to be transferred
1358      *
1359      * Calling conditions:
1360      *
1361      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1362      * transferred to `to`.
1363      * - When `from` is zero, `tokenId` will be minted for `to`.
1364      * - When `to` is zero, `tokenId` will be burned by `from`.
1365      * - `from` and `to` are never both zero.
1366      */
1367     function _beforeTokenTransfers(
1368         address from,
1369         address to,
1370         uint256 startTokenId,
1371         uint256 quantity
1372     ) internal virtual {}
1373 
1374     /**
1375      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1376      * minting.
1377      * And also called after one token has been burned.
1378      *
1379      * startTokenId - the first token id to be transferred
1380      * quantity - the amount to be transferred
1381      *
1382      * Calling conditions:
1383      *
1384      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1385      * transferred to `to`.
1386      * - When `from` is zero, `tokenId` has been minted for `to`.
1387      * - When `to` is zero, `tokenId` has been burned by `from`.
1388      * - `from` and `to` are never both zero.
1389      */
1390     function _afterTokenTransfers(
1391         address from,
1392         address to,
1393         uint256 startTokenId,
1394         uint256 quantity
1395     ) internal virtual {}
1396 }
1397 
1398 // File: MAKC.sol
1399 
1400 contract MAKC is ERC721A, Ownable, ReentrancyGuard {
1401   using Strings for uint256;
1402 
1403   string private uriPrefix = "";
1404   string public uriSuffix = ".json";
1405   string public hiddenMetadataUri;
1406   
1407   uint256 public cost = 0.07 ether;
1408   uint256 public maxSupply = 3333;
1409   uint256 public maxMintAmountPerTx = 10;
1410   uint256 public maxWalletLimit = 10;
1411 
1412   bool public paused = true;
1413   bool public presaleActive = false;
1414   bool public saleActive = false;
1415   mapping(address => uint256) private addressMintedBalance;
1416   bytes32 private merkleRoot = "";
1417 
1418   constructor() ERC721A("MAKC Mutant Buddies", "MAKCMB") {}
1419 
1420   function _startTokenId() internal override view virtual returns (uint256) {
1421         return 1;
1422   }
1423 
1424   modifier mintCompliance(uint256 _mintAmount) {
1425     require(!paused, "The contract is paused!");
1426     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1427     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1428     _;
1429   }
1430 
1431   modifier selfMintCompliance(uint256 _mintAmount) {
1432     require(_mintAmount > 0, "Invalid mint amount!");
1433     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1434     _;
1435   }
1436 
1437   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1438     require(saleActive, "Sale is not Active" );
1439     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1440     require(addressMintedBalance[msg.sender] + _mintAmount <= maxWalletLimit, "Max mint amount per wallet reached");
1441     _mintLoop(msg.sender, _mintAmount);
1442   }
1443   
1444   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1445     _mintLoop(_receiver, _mintAmount);
1446   }
1447 
1448   function mintForSelf(uint256 _mintAmount) public selfMintCompliance(_mintAmount) onlyOwner {
1449     _mintLoop(msg.sender, _mintAmount);
1450   }
1451 
1452   function whitelistMint(uint256 _mintAmount, uint256 _mintLimit, bytes32 leaf, bytes32[] memory proof) external payable mintCompliance(_mintAmount) {
1453     require(presaleActive, "Sale is not Active" );
1454     require(merkleRoot != '', "Merkle Root not set");
1455     // Verify that (msg.sender, amount) correspond to Merkle leaf
1456     require(keccak256(abi.encodePacked(msg.sender, _mintLimit)) == leaf, "Sender and amount don't match Merkle leaf");
1457 
1458      // Verify that (leaf, proof) matches the Merkle root
1459     require(verify(merkleRoot, leaf, proof), "Not a valid leaf in the Merkle tree");
1460     require(addressMintedBalance[msg.sender] + _mintAmount <= _mintLimit, "Max mint amount per wallet reached");
1461     _mintLoop(msg.sender, _mintAmount);
1462   }
1463 
1464   function verify(bytes32 _merkleRoot, bytes32 leaf, bytes32[] memory proof) public pure returns (bool) {
1465         return MerkleProof.verify(proof, _merkleRoot, leaf);
1466     }
1467 
1468   function walletOfOwner(address _owner)
1469     public
1470     view
1471     returns (uint256[] memory)
1472   {
1473     uint256 ownerTokenCount = balanceOf(_owner);
1474     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1475     uint256 currentTokenId = 1;
1476     uint256 ownedTokenIndex = 0;
1477 
1478     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1479       address currentTokenOwner = ownerOf(currentTokenId);
1480 
1481       if (currentTokenOwner == _owner) {
1482         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1483 
1484         ownedTokenIndex++;
1485       }
1486 
1487       currentTokenId++;
1488     }
1489 
1490     return ownedTokenIds;
1491   }
1492 
1493   function tokenURI(uint256 _tokenId)
1494     public
1495     view
1496     virtual
1497     override
1498     returns (string memory)
1499   {
1500     require(
1501       _exists(_tokenId),
1502       "ERC721Metadata: URI query for nonexistent token"
1503     );
1504 
1505     string memory currentBaseURI = _baseURI();
1506     return bytes(currentBaseURI).length > 0
1507         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1508         : "";
1509   }
1510 
1511   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1512         merkleRoot = _merkleRoot;
1513     }
1514 
1515   function setCost(uint256 _cost) public onlyOwner {
1516     cost = _cost;
1517   }
1518 
1519   function setPublicSale(bool _sale) public onlyOwner {
1520     saleActive = _sale;
1521   }
1522 
1523   function setPreSale(bool _sale) public onlyOwner {
1524     presaleActive = _sale;
1525   }
1526 
1527   function setMaxWalletLimit(uint256 _maxWalletLimit) public onlyOwner {
1528       maxWalletLimit = _maxWalletLimit;
1529   }
1530 
1531   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1532     maxMintAmountPerTx = _maxMintAmountPerTx;
1533   }
1534 
1535   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1536     hiddenMetadataUri = _hiddenMetadataUri;
1537   }
1538 
1539   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1540     uriPrefix = _uriPrefix;
1541   }
1542 
1543   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1544     uriSuffix = _uriSuffix;
1545   }
1546 
1547   function setPaused(bool _state) public onlyOwner {
1548     paused = _state;
1549   }
1550 
1551   function withdraw() public onlyOwner {
1552     require(address(this).balance > 0, "Balance is 0");
1553     payable(owner()).transfer(address(this).balance);
1554   }
1555 
1556   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1557     addressMintedBalance[_receiver]+= _mintAmount;
1558     _safeMint(_receiver, _mintAmount);
1559   }
1560 
1561   function _baseURI() internal view virtual override returns (string memory) {
1562     return uriPrefix;
1563   }
1564 }