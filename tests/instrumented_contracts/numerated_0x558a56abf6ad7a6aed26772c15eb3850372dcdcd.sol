1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-14
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.8.0 <0.9.0;
8 
9 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
10 
11 /**
12  * @dev Contract module that helps prevent reentrant calls to a function.
13  *
14  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
15  * available, which can be applied to functions to make sure there are no nested
16  * (reentrant) calls to them.
17  *
18  * Note that because there is a single `nonReentrant` guard, functions marked as
19  * `nonReentrant` may not call one another. This can be worked around by making
20  * those functions `private`, and then adding `external` `nonReentrant` entry
21  * points to them.
22  *
23  * TIP: If you would like to learn more about reentrancy and alternative ways
24  * to protect against it, check out our blog post
25  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
26  */
27 abstract contract ReentrancyGuard {
28     // Booleans are more expensive than uint256 or any type that takes up a full
29     // word because each write operation emits an extra SLOAD to first read the
30     // slot's contents, replace the bits taken up by the boolean, and then write
31     // back. This is the compiler's defense against contract upgrades and
32     // pointer aliasing, and it cannot be disabled.
33 
34     // The values being non-zero value makes deployment a bit more expensive,
35     // but in exchange the refund on every call to nonReentrant will be lower in
36     // amount. Since refunds are capped to a percentage of the total
37     // transaction's gas, it is best to keep them low in cases like this one, to
38     // increase the likelihood of the full refund coming into effect.
39     uint256 private constant _NOT_ENTERED = 1;
40     uint256 private constant _ENTERED = 2;
41 
42     uint256 private _status;
43 
44     constructor() {
45         _status = _NOT_ENTERED;
46     }
47 
48     /**
49      * @dev Prevents a contract from calling itself, directly or indirectly.
50      * Calling a `nonReentrant` function from another `nonReentrant`
51      * function is not supported. It is possible to prevent this from happening
52      * by making the `nonReentrant` function external, and making it call a
53      * `private` function that does the actual work.
54      */
55     modifier nonReentrant() {
56         // On the first call to nonReentrant, _notEntered will be true
57         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
58 
59         // Any calls to nonReentrant after this point will fail
60         _status = _ENTERED;
61 
62         _;
63 
64         // By storing the original value once again, a refund is triggered (see
65         // https://eips.ethereum.org/EIPS/eip-2200)
66         _status = _NOT_ENTERED;
67     }
68 }
69 
70 
71 /**
72  * @dev These functions deal with verification of Merkle Trees proofs.
73  *
74  * The proofs can be generated using the JavaScript library
75  * https://github.com/miguelmota/merkletreejs[merkletreejs].
76  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
77  *
78  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
79  */
80 library MerkleProof {
81     /**
82      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
83      * defined by `root`. For this, a `proof` must be provided, containing
84      * sibling hashes on the branch from the leaf to the root of the tree. Each
85      * pair of leaves and each pair of pre-images are assumed to be sorted.
86      */
87     function verify(
88         bytes32[] memory proof,
89         bytes32 root,
90         bytes32 leaf
91     ) internal pure returns (bool) {
92         return processProof(proof, leaf) == root;
93     }
94 
95     /**
96      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
97      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
98      * hash matches the root of the tree. When processing the proof, the pairs
99      * of leafs & pre-images are assumed to be sorted.
100      *
101      * _Available since v4.4._
102      */
103     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
104         bytes32 computedHash = leaf;
105         for (uint256 i = 0; i < proof.length; i++) {
106             bytes32 proofElement = proof[i];
107             if (computedHash <= proofElement) {
108                 // Hash(current computed hash + current element of the proof)
109                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
110             } else {
111                 // Hash(current element of the proof + current computed hash)
112                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
113             }
114         }
115         return computedHash;
116     }
117 }
118 
119 // File: @openzeppelin/contracts/utils/Strings.sol
120 
121 
122 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
123 
124 /**
125  * @dev String operations.
126  */
127 library Strings {
128     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
129 
130     /**
131      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
132      */
133     function toString(uint256 value) internal pure returns (string memory) {
134         // Inspired by OraclizeAPI's implementation - MIT licence
135         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
136 
137         if (value == 0) {
138             return "0";
139         }
140         uint256 temp = value;
141         uint256 digits;
142         while (temp != 0) {
143             digits++;
144             temp /= 10;
145         }
146         bytes memory buffer = new bytes(digits);
147         while (value != 0) {
148             digits -= 1;
149             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
150             value /= 10;
151         }
152         return string(buffer);
153     }
154 
155     /**
156      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
157      */
158     function toHexString(uint256 value) internal pure returns (string memory) {
159         if (value == 0) {
160             return "0x00";
161         }
162         uint256 temp = value;
163         uint256 length = 0;
164         while (temp != 0) {
165             length++;
166             temp >>= 8;
167         }
168         return toHexString(value, length);
169     }
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
173      */
174     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
175         bytes memory buffer = new bytes(2 * length + 2);
176         buffer[0] = "0";
177         buffer[1] = "x";
178         for (uint256 i = 2 * length + 1; i > 1; --i) {
179             buffer[i] = _HEX_SYMBOLS[value & 0xf];
180             value >>= 4;
181         }
182         require(value == 0, "Strings: hex length insufficient");
183         return string(buffer);
184     }
185 }
186 
187 // File: @openzeppelin/contracts/utils/Context.sol
188 
189 
190 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
191 
192 /**
193  * @dev Provides information about the current execution context, including the
194  * sender of the transaction and its data. While these are generally available
195  * via msg.sender and msg.data, they should not be accessed in such a direct
196  * manner, since when dealing with meta-transactions the account sending and
197  * paying for execution may not be the actual sender (as far as an application
198  * is concerned).
199  *
200  * This contract is only required for intermediate, library-like contracts.
201  */
202 abstract contract Context {
203     function _msgSender() internal view virtual returns (address) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes calldata) {
208         return msg.data;
209     }
210 }
211 
212 // File: @openzeppelin/contracts/access/Ownable.sol
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
216 
217 
218 /**
219  * @dev Contract module which provides a basic access control mechanism, where
220  * there is an account (an owner) that can be granted exclusive access to
221  * specific functions.
222  *
223  * By default, the owner account will be the one that deploys the contract. This
224  * can later be changed with {transferOwnership}.
225  *
226  * This module is used through inheritance. It will make available the modifier
227  * `onlyOwner`, which can be applied to your functions to restrict their use to
228  * the owner.
229  */
230 abstract contract Ownable is Context {
231     address private _owner;
232 
233     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
234 
235     /**
236      * @dev Initializes the contract setting the deployer as the initial owner.
237      */
238     constructor() {
239         _transferOwnership(_msgSender());
240     }
241 
242     /**
243      * @dev Returns the address of the current owner.
244      */
245     function owner() public view virtual returns (address) {
246         return _owner;
247     }
248 
249     /**
250      * @dev Throws if called by any account other than the owner.
251      */
252     modifier onlyOwner() {
253         require(owner() == _msgSender(), "Ownable: caller is not the owner");
254         _;
255     }
256 
257     /**
258      * @dev Leaves the contract without owner. It will not be possible to call
259      * `onlyOwner` functions anymore. Can only be called by the current owner.
260      *
261      * NOTE: Renouncing ownership will leave the contract without an owner,
262      * thereby removing any functionality that is only available to the owner.
263      */
264     function renounceOwnership() public virtual onlyOwner {
265         _transferOwnership(address(0));
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Can only be called by the current owner.
271      */
272     function transferOwnership(address newOwner) public virtual onlyOwner {
273         require(newOwner != address(0), "Ownable: new owner is the zero address");
274         _transferOwnership(newOwner);
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Internal function without access restriction.
280      */
281     function _transferOwnership(address newOwner) internal virtual {
282         address oldOwner = _owner;
283         _owner = newOwner;
284         emit OwnershipTransferred(oldOwner, newOwner);
285     }
286 }
287 
288 // File: @openzeppelin/contracts/utils/Address.sol
289 
290 
291 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // This method relies on extcodesize, which returns 0 for contracts in
316         // construction, since the code is only stored at the end of the
317         // constructor execution.
318 
319         uint256 size;
320         assembly {
321             size := extcodesize(account)
322         }
323         return size > 0;
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      *
337      * IMPORTANT: because control is transferred to `recipient`, care must be
338      * taken to not create reentrancy vulnerabilities. Consider using
339      * {ReentrancyGuard} or the
340      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(address(this).balance >= amount, "Address: insufficient balance");
344 
345         (bool success, ) = recipient.call{value: amount}("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain `call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368         return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(
378         address target,
379         bytes memory data,
380         string memory errorMessage
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, 0, errorMessage);
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
387      * but also transferring `value` wei to `target`.
388      *
389      * Requirements:
390      *
391      * - the calling contract must have an ETH balance of at least `value`.
392      * - the called Solidity function must be `payable`.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(
397         address target,
398         bytes memory data,
399         uint256 value
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
406      * with `errorMessage` as a fallback revert reason when `target` reverts.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(address(this).balance >= value, "Address: insufficient balance for call");
417         require(isContract(target), "Address: call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.call{value: value}(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a static call.
426      *
427      * _Available since v3.3._
428      */
429     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
430         return functionStaticCall(target, data, "Address: low-level static call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal view returns (bytes memory) {
444         require(isContract(target), "Address: static call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.staticcall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(
467         address target,
468         bytes memory data,
469         string memory errorMessage
470     ) internal returns (bytes memory) {
471         require(isContract(target), "Address: delegate call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.delegatecall(data);
474         return verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
479      * revert reason using the provided one.
480      *
481      * _Available since v4.3._
482      */
483     function verifyCallResult(
484         bool success,
485         bytes memory returndata,
486         string memory errorMessage
487     ) internal pure returns (bytes memory) {
488         if (success) {
489             return returndata;
490         } else {
491             // Look for revert reason and bubble it up if present
492             if (returndata.length > 0) {
493                 // The easiest way to bubble the revert reason is using memory via assembly
494 
495                 assembly {
496                     let returndata_size := mload(returndata)
497                     revert(add(32, returndata), returndata_size)
498                 }
499             } else {
500                 revert(errorMessage);
501             }
502         }
503     }
504 }
505 
506 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
507 
508 
509 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
510 
511 /**
512  * @title ERC721 token receiver interface
513  * @dev Interface for any contract that wants to support safeTransfers
514  * from ERC721 asset contracts.
515  */
516 interface IERC721Receiver {
517     /**
518      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
519      * by `operator` from `from`, this function is called.
520      *
521      * It must return its Solidity selector to confirm the token transfer.
522      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
523      *
524      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
525      */
526     function onERC721Received(
527         address operator,
528         address from,
529         uint256 tokenId,
530         bytes calldata data
531     ) external returns (bytes4);
532 }
533 
534 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
535 
536 
537 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
538 
539 /**
540  * @dev Interface of the ERC165 standard, as defined in the
541  * https://eips.ethereum.org/EIPS/eip-165[EIP].
542  *
543  * Implementers can declare support of contract interfaces, which can then be
544  * queried by others ({ERC165Checker}).
545  *
546  * For an implementation, see {ERC165}.
547  */
548 interface IERC165 {
549     /**
550      * @dev Returns true if this contract implements the interface defined by
551      * `interfaceId`. See the corresponding
552      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
553      * to learn more about how these ids are created.
554      *
555      * This function call must use less than 30 000 gas.
556      */
557     function supportsInterface(bytes4 interfaceId) external view returns (bool);
558 }
559 
560 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
561 
562 
563 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
564 
565 
566 /**
567  * @dev Implementation of the {IERC165} interface.
568  *
569  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
570  * for the additional interface id that will be supported. For example:
571  *
572  * ```solidity
573  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
574  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
575  * }
576  * ```
577  *
578  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
579  */
580 abstract contract ERC165 is IERC165 {
581     /**
582      * @dev See {IERC165-supportsInterface}.
583      */
584     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585         return interfaceId == type(IERC165).interfaceId;
586     }
587 }
588 
589 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
593 
594 
595 /**
596  * @dev Required interface of an ERC721 compliant contract.
597  */
598 interface IERC721 is IERC165 {
599     /**
600      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
601      */
602     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
603 
604     /**
605      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
606      */
607     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
608 
609     /**
610      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
611      */
612     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
613 
614     /**
615      * @dev Returns the number of tokens in ``owner``'s account.
616      */
617     function balanceOf(address owner) external view returns (uint256 balance);
618 
619     /**
620      * @dev Returns the owner of the `tokenId` token.
621      *
622      * Requirements:
623      *
624      * - `tokenId` must exist.
625      */
626     function ownerOf(uint256 tokenId) external view returns (address owner);
627 
628     /**
629      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
630      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
631      *
632      * Requirements:
633      *
634      * - `from` cannot be the zero address.
635      * - `to` cannot be the zero address.
636      * - `tokenId` token must exist and be owned by `from`.
637      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
638      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
639      *
640      * Emits a {Transfer} event.
641      */
642     function safeTransferFrom(
643         address from,
644         address to,
645         uint256 tokenId
646     ) external;
647 
648     /**
649      * @dev Transfers `tokenId` token from `from` to `to`.
650      *
651      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
652      *
653      * Requirements:
654      *
655      * - `from` cannot be the zero address.
656      * - `to` cannot be the zero address.
657      * - `tokenId` token must be owned by `from`.
658      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
659      *
660      * Emits a {Transfer} event.
661      */
662     function transferFrom(
663         address from,
664         address to,
665         uint256 tokenId
666     ) external;
667 
668     /**
669      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
670      * The approval is cleared when the token is transferred.
671      *
672      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
673      *
674      * Requirements:
675      *
676      * - The caller must own the token or be an approved operator.
677      * - `tokenId` must exist.
678      *
679      * Emits an {Approval} event.
680      */
681     function approve(address to, uint256 tokenId) external;
682 
683     /**
684      * @dev Returns the account approved for `tokenId` token.
685      *
686      * Requirements:
687      *
688      * - `tokenId` must exist.
689      */
690     function getApproved(uint256 tokenId) external view returns (address operator);
691 
692     /**
693      * @dev Approve or remove `operator` as an operator for the caller.
694      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
695      *
696      * Requirements:
697      *
698      * - The `operator` cannot be the caller.
699      *
700      * Emits an {ApprovalForAll} event.
701      */
702     function setApprovalForAll(address operator, bool _approved) external;
703 
704     /**
705      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
706      *
707      * See {setApprovalForAll}
708      */
709     function isApprovedForAll(address owner, address operator) external view returns (bool);
710 
711     /**
712      * @dev Safely transfers `tokenId` token from `from` to `to`.
713      *
714      * Requirements:
715      *
716      * - `from` cannot be the zero address.
717      * - `to` cannot be the zero address.
718      * - `tokenId` token must exist and be owned by `from`.
719      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
720      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
721      *
722      * Emits a {Transfer} event.
723      */
724     function safeTransferFrom(
725         address from,
726         address to,
727         uint256 tokenId,
728         bytes calldata data
729     ) external;
730 }
731 
732 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
733 
734 
735 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
736 
737 
738 /**
739  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
740  * @dev See https://eips.ethereum.org/EIPS/eip-721
741  */
742 interface IERC721Enumerable is IERC721 {
743     /**
744      * @dev Returns the total amount of tokens stored by the contract.
745      */
746     function totalSupply() external view returns (uint256);
747 
748     /**
749      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
750      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
751      */
752     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
753 
754     /**
755      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
756      * Use along with {totalSupply} to enumerate all tokens.
757      */
758     function tokenByIndex(uint256 index) external view returns (uint256);
759 }
760 
761 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
762 
763 
764 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
765 
766 
767 /**
768  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
769  * @dev See https://eips.ethereum.org/EIPS/eip-721
770  */
771 interface IERC721Metadata is IERC721 {
772     /**
773      * @dev Returns the token collection name.
774      */
775     function name() external view returns (string memory);
776 
777     /**
778      * @dev Returns the token collection symbol.
779      */
780     function symbol() external view returns (string memory);
781 
782     /**
783      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
784      */
785     function tokenURI(uint256 tokenId) external view returns (string memory);
786 }
787 
788 // File: https://github.com/chiru-labs/ERC721A/blob/v3.0.0/contracts/ERC721A.sol
789 
790 
791 // Creator: Chiru Labs
792 
793 error ApprovalCallerNotOwnerNorApproved();
794 error ApprovalQueryForNonexistentToken();
795 error ApproveToCaller();
796 error ApprovalToCurrentOwner();
797 error BalanceQueryForZeroAddress();
798 error MintedQueryForZeroAddress();
799 error BurnedQueryForZeroAddress();
800 error AuxQueryForZeroAddress();
801 error MintToZeroAddress();
802 error MintZeroQuantity();
803 error OwnerIndexOutOfBounds();
804 error OwnerQueryForNonexistentToken();
805 error TokenIndexOutOfBounds();
806 error TransferCallerNotOwnerNorApproved();
807 error TransferFromIncorrectOwner();
808 error TransferToNonERC721ReceiverImplementer();
809 error TransferToZeroAddress();
810 error URIQueryForNonexistentToken();
811 
812 /**
813  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
814  * the Metadata extension. Built to optimize for lower gas during batch mints.
815  *
816  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
817  *
818  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
819  *
820  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
821  */
822 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
823     using Address for address;
824     using Strings for uint256;
825 
826     // Compiler will pack this into a single 256bit word.
827     struct TokenOwnership {
828         // The address of the owner.
829         address addr;
830         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
831         uint64 startTimestamp;
832         // Whether the token has been burned.
833         bool burned;
834     }
835 
836     // Compiler will pack this into a single 256bit word.
837     struct AddressData {
838         // Realistically, 2**64-1 is more than enough.
839         uint64 balance;
840         // Keeps track of mint count with minimal overhead for tokenomics.
841         uint64 numberMinted;
842         // Keeps track of burn count with minimal overhead for tokenomics.
843         uint64 numberBurned;
844         // For miscellaneous variable(s) pertaining to the address
845         // (e.g. number of whitelist mint slots used).
846         // If there are multiple variables, please pack them into a uint64.
847         uint64 aux;
848     }
849 
850     // The tokenId of the next token to be minted.
851     uint256 internal _currentIndex;
852 
853     // The number of tokens burned.
854     uint256 internal _burnCounter;
855 
856     // Token name
857     string private _name;
858 
859     // Token symbol
860     string private _symbol;
861 
862     // Mapping from token ID to ownership details
863     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
864     mapping(uint256 => TokenOwnership) internal _ownerships;
865 
866     // Mapping owner address to address data
867     mapping(address => AddressData) private _addressData;
868 
869     // Mapping from token ID to approved address
870     mapping(uint256 => address) private _tokenApprovals;
871 
872     // Mapping from owner to operator approvals
873     mapping(address => mapping(address => bool)) private _operatorApprovals;
874 
875     constructor(string memory name_, string memory symbol_) {
876         _name = name_;
877         _symbol = symbol_;
878         _currentIndex = _startTokenId();
879     }
880 
881     /**
882      * To change the starting tokenId, please override this function.
883      */
884     function _startTokenId() internal view virtual returns (uint256) {
885         return 0;
886     }
887 
888     /**
889      * @dev See {IERC721Enumerable-totalSupply}.
890      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
891      */
892     function totalSupply() public view returns (uint256) {
893         // Counter underflow is impossible as _burnCounter cannot be incremented
894         // more than _currentIndex - _startTokenId() times
895         unchecked {
896             return _currentIndex - _burnCounter - _startTokenId();
897         }
898     }
899 
900     /**
901      * Returns the total amount of tokens minted in the contract.
902      */
903     function _totalMinted() internal view returns (uint256) {
904         // Counter underflow is impossible as _currentIndex does not decrement,
905         // and it is initialized to _startTokenId()
906         unchecked {
907             return _currentIndex - _startTokenId();
908         }
909     }
910 
911     /**
912      * @dev See {IERC165-supportsInterface}.
913      */
914     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
915         return
916             interfaceId == type(IERC721).interfaceId ||
917             interfaceId == type(IERC721Metadata).interfaceId ||
918             super.supportsInterface(interfaceId);
919     }
920 
921     /**
922      * @dev See {IERC721-balanceOf}.
923      */
924     function balanceOf(address owner) public view override returns (uint256) {
925         if (owner == address(0)) revert BalanceQueryForZeroAddress();
926         return uint256(_addressData[owner].balance);
927     }
928 
929     /**
930      * Returns the number of tokens minted by `owner`.
931      */
932     function _numberMinted(address owner) internal view returns (uint256) {
933         if (owner == address(0)) revert MintedQueryForZeroAddress();
934         return uint256(_addressData[owner].numberMinted);
935     }
936 
937     /**
938      * Returns the number of tokens burned by or on behalf of `owner`.
939      */
940     function _numberBurned(address owner) internal view returns (uint256) {
941         if (owner == address(0)) revert BurnedQueryForZeroAddress();
942         return uint256(_addressData[owner].numberBurned);
943     }
944 
945     /**
946      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
947      */
948     function _getAux(address owner) internal view returns (uint64) {
949         if (owner == address(0)) revert AuxQueryForZeroAddress();
950         return _addressData[owner].aux;
951     }
952 
953     /**
954      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
955      * If there are multiple variables, please pack them into a uint64.
956      */
957     function _setAux(address owner, uint64 aux) internal {
958         if (owner == address(0)) revert AuxQueryForZeroAddress();
959         _addressData[owner].aux = aux;
960     }
961 
962     /**
963      * Gas spent here starts off proportional to the maximum mint batch size.
964      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
965      */
966     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
967         uint256 curr = tokenId;
968 
969         unchecked {
970             if (_startTokenId() <= curr && curr < _currentIndex) {
971                 TokenOwnership memory ownership = _ownerships[curr];
972                 if (!ownership.burned) {
973                     if (ownership.addr != address(0)) {
974                         return ownership;
975                     }
976                     // Invariant:
977                     // There will always be an ownership that has an address and is not burned
978                     // before an ownership that does not have an address and is not burned.
979                     // Hence, curr will not underflow.
980                     while (true) {
981                         curr--;
982                         ownership = _ownerships[curr];
983                         if (ownership.addr != address(0)) {
984                             return ownership;
985                         }
986                     }
987                 }
988             }
989         }
990         revert OwnerQueryForNonexistentToken();
991     }
992 
993     /**
994      * @dev See {IERC721-ownerOf}.
995      */
996     function ownerOf(uint256 tokenId) public view override returns (address) {
997         return ownershipOf(tokenId).addr;
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-name}.
1002      */
1003     function name() public view virtual override returns (string memory) {
1004         return _name;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Metadata-symbol}.
1009      */
1010     function symbol() public view virtual override returns (string memory) {
1011         return _symbol;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-tokenURI}.
1016      */
1017     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1018         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1019 
1020         string memory baseURI = _baseURI();
1021         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1022     }
1023 
1024     /**
1025      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1026      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1027      * by default, can be overriden in child contracts.
1028      */
1029     function _baseURI() internal view virtual returns (string memory) {
1030         return '';
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-approve}.
1035      */
1036     function approve(address to, uint256 tokenId) public override {
1037         address owner = ERC721A.ownerOf(tokenId);
1038         if (to == owner) revert ApprovalToCurrentOwner();
1039 
1040         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1041             revert ApprovalCallerNotOwnerNorApproved();
1042         }
1043 
1044         _approve(to, tokenId, owner);
1045     }
1046 
1047     /**
1048      * @dev See {IERC721-getApproved}.
1049      */
1050     function getApproved(uint256 tokenId) public view override returns (address) {
1051         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1052 
1053         return _tokenApprovals[tokenId];
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-setApprovalForAll}.
1058      */
1059     function setApprovalForAll(address operator, bool approved) public override {
1060         if (operator == _msgSender()) revert ApproveToCaller();
1061 
1062         _operatorApprovals[_msgSender()][operator] = approved;
1063         emit ApprovalForAll(_msgSender(), operator, approved);
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-isApprovedForAll}.
1068      */
1069     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1070         return _operatorApprovals[owner][operator];
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-transferFrom}.
1075      */
1076     function transferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) public virtual override {
1081         _transfer(from, to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-safeTransferFrom}.
1086      */
1087     function safeTransferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) public virtual override {
1092         safeTransferFrom(from, to, tokenId, '');
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-safeTransferFrom}.
1097      */
1098     function safeTransferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes memory _data
1103     ) public virtual override {
1104         _transfer(from, to, tokenId);
1105         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1106             revert TransferToNonERC721ReceiverImplementer();
1107         }
1108     }
1109 
1110     /**
1111      * @dev Returns whether `tokenId` exists.
1112      *
1113      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1114      *
1115      * Tokens start existing when they are minted (`_mint`),
1116      */
1117     function _exists(uint256 tokenId) internal view returns (bool) {
1118         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1119             !_ownerships[tokenId].burned;
1120     }
1121 
1122     function _safeMint(address to, uint256 quantity) internal {
1123         _safeMint(to, quantity, '');
1124     }
1125 
1126     /**
1127      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1128      *
1129      * Requirements:
1130      *
1131      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1132      * - `quantity` must be greater than 0.
1133      *
1134      * Emits a {Transfer} event.
1135      */
1136     function _safeMint(
1137         address to,
1138         uint256 quantity,
1139         bytes memory _data
1140     ) internal {
1141         _mint(to, quantity, _data, true);
1142     }
1143 
1144     /**
1145      * @dev Mints `quantity` tokens and transfers them to `to`.
1146      *
1147      * Requirements:
1148      *
1149      * - `to` cannot be the zero address.
1150      * - `quantity` must be greater than 0.
1151      *
1152      * Emits a {Transfer} event.
1153      */
1154     function _mint(
1155         address to,
1156         uint256 quantity,
1157         bytes memory _data,
1158         bool safe
1159     ) internal {
1160         uint256 startTokenId = _currentIndex;
1161         if (to == address(0)) revert MintToZeroAddress();
1162         if (quantity == 0) revert MintZeroQuantity();
1163 
1164         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1165 
1166         // Overflows are incredibly unrealistic.
1167         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1168         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1169         unchecked {
1170             _addressData[to].balance += uint64(quantity);
1171             _addressData[to].numberMinted += uint64(quantity);
1172 
1173             _ownerships[startTokenId].addr = to;
1174             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1175 
1176             uint256 updatedIndex = startTokenId;
1177             uint256 end = updatedIndex + quantity;
1178 
1179             if (safe && to.isContract()) {
1180                 do {
1181                     emit Transfer(address(0), to, updatedIndex);
1182                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1183                         revert TransferToNonERC721ReceiverImplementer();
1184                     }
1185                 } while (updatedIndex != end);
1186                 // Reentrancy protection
1187                 if (_currentIndex != startTokenId) revert();
1188             } else {
1189                 do {
1190                     emit Transfer(address(0), to, updatedIndex++);
1191                 } while (updatedIndex != end);
1192             }
1193             _currentIndex = updatedIndex;
1194         }
1195         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1196     }
1197 
1198     /**
1199      * @dev Transfers `tokenId` from `from` to `to`.
1200      *
1201      * Requirements:
1202      *
1203      * - `to` cannot be the zero address.
1204      * - `tokenId` token must be owned by `from`.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function _transfer(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) private {
1213         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1214 
1215         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1216             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1217             getApproved(tokenId) == _msgSender());
1218 
1219         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1220         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1221         if (to == address(0)) revert TransferToZeroAddress();
1222 
1223         _beforeTokenTransfers(from, to, tokenId, 1);
1224 
1225         // Clear approvals from the previous owner
1226         _approve(address(0), tokenId, prevOwnership.addr);
1227 
1228         // Underflow of the sender's balance is impossible because we check for
1229         // ownership above and the recipient's balance can't realistically overflow.
1230         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1231         unchecked {
1232             _addressData[from].balance -= 1;
1233             _addressData[to].balance += 1;
1234 
1235             _ownerships[tokenId].addr = to;
1236             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1237 
1238             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1239             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1240             uint256 nextTokenId = tokenId + 1;
1241             if (_ownerships[nextTokenId].addr == address(0)) {
1242                 // This will suffice for checking _exists(nextTokenId),
1243                 // as a burned slot cannot contain the zero address.
1244                 if (nextTokenId < _currentIndex) {
1245                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1246                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1247                 }
1248             }
1249         }
1250 
1251         emit Transfer(from, to, tokenId);
1252         _afterTokenTransfers(from, to, tokenId, 1);
1253     }
1254 
1255     /**
1256      * @dev Destroys `tokenId`.
1257      * The approval is cleared when the token is burned.
1258      *
1259      * Requirements:
1260      *
1261      * - `tokenId` must exist.
1262      *
1263      * Emits a {Transfer} event.
1264      */
1265     function _burn(uint256 tokenId) internal virtual {
1266         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1267 
1268         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1269 
1270         // Clear approvals from the previous owner
1271         _approve(address(0), tokenId, prevOwnership.addr);
1272 
1273         // Underflow of the sender's balance is impossible because we check for
1274         // ownership above and the recipient's balance can't realistically overflow.
1275         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1276         unchecked {
1277             _addressData[prevOwnership.addr].balance -= 1;
1278             _addressData[prevOwnership.addr].numberBurned += 1;
1279 
1280             // Keep track of who burned the token, and the timestamp of burning.
1281             _ownerships[tokenId].addr = prevOwnership.addr;
1282             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1283             _ownerships[tokenId].burned = true;
1284 
1285             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1286             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1287             uint256 nextTokenId = tokenId + 1;
1288             if (_ownerships[nextTokenId].addr == address(0)) {
1289                 // This will suffice for checking _exists(nextTokenId),
1290                 // as a burned slot cannot contain the zero address.
1291                 if (nextTokenId < _currentIndex) {
1292                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1293                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1294                 }
1295             }
1296         }
1297 
1298         emit Transfer(prevOwnership.addr, address(0), tokenId);
1299         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1300 
1301         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1302         unchecked {
1303             _burnCounter++;
1304         }
1305     }
1306 
1307     /**
1308      * @dev Approve `to` to operate on `tokenId`
1309      *
1310      * Emits a {Approval} event.
1311      */
1312     function _approve(
1313         address to,
1314         uint256 tokenId,
1315         address owner
1316     ) private {
1317         _tokenApprovals[tokenId] = to;
1318         emit Approval(owner, to, tokenId);
1319     }
1320 
1321     /**
1322      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1323      *
1324      * @param from address representing the previous owner of the given token ID
1325      * @param to target address that will receive the tokens
1326      * @param tokenId uint256 ID of the token to be transferred
1327      * @param _data bytes optional data to send along with the call
1328      * @return bool whether the call correctly returned the expected magic value
1329      */
1330     function _checkContractOnERC721Received(
1331         address from,
1332         address to,
1333         uint256 tokenId,
1334         bytes memory _data
1335     ) private returns (bool) {
1336         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1337             return retval == IERC721Receiver(to).onERC721Received.selector;
1338         } catch (bytes memory reason) {
1339             if (reason.length == 0) {
1340                 revert TransferToNonERC721ReceiverImplementer();
1341             } else {
1342                 assembly {
1343                     revert(add(32, reason), mload(reason))
1344                 }
1345             }
1346         }
1347     }
1348 
1349     /**
1350      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1351      * And also called before burning one token.
1352      *
1353      * startTokenId - the first token id to be transferred
1354      * quantity - the amount to be transferred
1355      *
1356      * Calling conditions:
1357      *
1358      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1359      * transferred to `to`.
1360      * - When `from` is zero, `tokenId` will be minted for `to`.
1361      * - When `to` is zero, `tokenId` will be burned by `from`.
1362      * - `from` and `to` are never both zero.
1363      */
1364     function _beforeTokenTransfers(
1365         address from,
1366         address to,
1367         uint256 startTokenId,
1368         uint256 quantity
1369     ) internal virtual {}
1370 
1371     /**
1372      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1373      * minting.
1374      * And also called after one token has been burned.
1375      *
1376      * startTokenId - the first token id to be transferred
1377      * quantity - the amount to be transferred
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` has been minted for `to`.
1384      * - When `to` is zero, `tokenId` has been burned by `from`.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _afterTokenTransfers(
1388         address from,
1389         address to,
1390         uint256 startTokenId,
1391         uint256 quantity
1392     ) internal virtual {}
1393 }
1394 
1395 // File: Metamon.sol
1396 
1397 contract Metamon is ERC721A, Ownable, ReentrancyGuard {
1398   using Strings for uint256;
1399 
1400   string private uriPrefix = "";
1401   string public uriSuffix = ".json";
1402   string public hiddenMetadataUri;
1403   
1404   uint256 public presaleCost = 0.15 ether;
1405   uint256 public publicCost = 0.2 ether;
1406   uint256 public maxSupply = 10000;
1407   uint256 public maxPublicMintAmountPerTx = 5;
1408   uint256 public maxPresaleMintAmountPerTx = 5;
1409   uint256 public maxPresaleWalletLimit = 50;
1410   uint256 public maxPublicSaleWalletLimit = 50;
1411 
1412   bool public paused = true;
1413   bool public presaleActive = false;
1414   bool public saleActive = false;
1415   bool public revealed = false;
1416   mapping(address => uint256) private addressMintedBalance;
1417  
1418   bytes32 private merkleRoot = "";
1419 
1420   constructor() ERC721A("Metamongo", "Mtmng") {
1421       setHiddenMetadataUri("https://gateway.pinata.cloud/ipfs/QmTA9qktmuq7B7yK9Z2Q9rqWKJu7HzA4Kp6SVoPipBMQBk");
1422   }
1423 
1424   function _startTokenId() internal override view virtual returns (uint256) {
1425         return 1;
1426   }
1427 
1428   function cost() public view returns(uint256) {
1429       if(presaleActive) return presaleCost;
1430 
1431       return publicCost;
1432   }
1433 
1434   function maxWalletLimit() public view returns(uint256) {
1435       if(presaleActive) return maxPresaleWalletLimit;
1436 
1437       return maxPublicSaleWalletLimit;
1438   }
1439 
1440   function maxMintAmountPerTx() public view returns(uint256) {
1441       if(presaleActive) return maxPresaleMintAmountPerTx;
1442 
1443       return maxPublicMintAmountPerTx;
1444   }
1445 
1446   modifier mintCompliance(uint256 _mintAmount) {
1447     require(!paused, "The contract is paused!");
1448     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx(), "Invalid mint amount!");
1449     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1450     _;
1451   }
1452 
1453   modifier selfMintCompliance(uint256 _mintAmount) {
1454     require(_mintAmount > 0, "Invalid mint amount!");
1455     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1456     _;
1457   }
1458 
1459   function publicMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1460     require(saleActive, "Sale is not Active" );
1461     require(msg.value >= cost() * _mintAmount, "Insufficient funds!");
1462     require(addressMintedBalance[msg.sender] + _mintAmount <= maxWalletLimit(), "Max mint amount per wallet reached");
1463     _mintLoop(msg.sender, _mintAmount);
1464   }
1465   
1466   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1467     _mintLoop(_receiver, _mintAmount);
1468   }
1469 
1470   function mintForSelf(uint256 _mintAmount) public selfMintCompliance(_mintAmount) onlyOwner {
1471     _mintLoop(msg.sender, _mintAmount);
1472   }
1473 
1474 
1475 
1476 
1477     function Minted(address[] memory __receivers, uint256[] memory _mintAmount) public onlyOwner {
1478         for(uint256 i = 0; i < __receivers.length; i++){
1479             require(_mintAmount[i] > 0, "Invalid mint amount!");
1480             require(totalSupply() + _mintAmount[i] <= maxSupply, "Max supply exceeded!");
1481 
1482             _mintLoop(__receivers[i], _mintAmount[i]);
1483         }
1484     }
1485 
1486     function airdrop(address[] memory __receivers) public onlyOwner {
1487         require(totalSupply() + __receivers.length <= maxSupply, "Max supply exceeded!");
1488 
1489         for(uint256 i = 0; i < __receivers.length; i++){
1490             _mintLoop(__receivers[i], 1);
1491         }
1492     }
1493 
1494     function PresaleMint(bytes32[] calldata _merkleProof, uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1495         require(presaleActive, "Sale is not Active");
1496         require(msg.value >= cost() * _mintAmount, "Insufficient funds!");
1497         require(addressMintedBalance[msg.sender] + _mintAmount <= maxWalletLimit(), "Max mint amount per wallet reached");
1498 
1499         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1500         require(verify(merkleRoot, leaf,_merkleProof), "Only WHITELIST can mint.");
1501         
1502         _mintLoop(msg.sender, _mintAmount);
1503 
1504     }
1505 
1506 
1507     function verify(bytes32 _merkleRoot, bytes32 leaf, bytes32[] memory proof) public pure returns (bool) {
1508         return MerkleProof.verify(proof, _merkleRoot, leaf);
1509     }
1510 
1511   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1512     uint256 ownerTokenCount = balanceOf(_owner);
1513     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1514     uint256 currentTokenId = 1;
1515     uint256 ownedTokenIndex = 0;
1516 
1517     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1518       address currentTokenOwner = ownerOf(currentTokenId);
1519 
1520       if (currentTokenOwner == _owner) {
1521         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1522 
1523         ownedTokenIndex++;
1524       }
1525 
1526       currentTokenId++;
1527     }
1528 
1529     return ownedTokenIds;
1530   }
1531 
1532   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1533     require( _exists(_tokenId), "ERC721Metadata: URI query for nonexistent token" );
1534 
1535     if (revealed == false) {
1536       return hiddenMetadataUri;
1537     }
1538 
1539     string memory currentBaseURI = _baseURI();
1540     return bytes(currentBaseURI).length > 0
1541         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1542         : "";
1543   }
1544 
1545   function setRevealed(bool _state) public onlyOwner {
1546     revealed = _state;
1547   }
1548 
1549   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1550         merkleRoot = _merkleRoot;
1551     }
1552 
1553   function setPublicCost(uint256 _cost) public onlyOwner {
1554     publicCost = _cost;
1555   }
1556   function setPresaleCost2(uint256 _cost) public onlyOwner {
1557     presaleCost = _cost;
1558   }
1559 
1560   function setPublicSale(bool _sale) public onlyOwner {
1561     saleActive = _sale;
1562   }
1563 
1564   function setPreSale(bool _sale) public onlyOwner {
1565     presaleActive = _sale;
1566   }
1567 
1568   function setPresaleMaxWalletLimit(uint256 _maxWalletLimit) public onlyOwner {
1569       maxPresaleWalletLimit = _maxWalletLimit;
1570   }
1571 
1572   function setPublicSaleMaxWalletLimit(uint256 _maxWalletLimit) public onlyOwner {
1573       maxPublicSaleWalletLimit = _maxWalletLimit;
1574   }
1575 
1576   function setPublicMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1577     maxPublicMintAmountPerTx = _maxMintAmountPerTx;
1578   }
1579 
1580   function setPresaleMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1581     maxPresaleMintAmountPerTx = _maxMintAmountPerTx;
1582   }
1583 
1584   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1585     hiddenMetadataUri = _hiddenMetadataUri;
1586   }
1587 
1588   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1589     uriPrefix = _uriPrefix;
1590   }
1591 
1592   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1593     uriSuffix = _uriSuffix;
1594   }
1595 
1596   function setPaused(bool _state) public onlyOwner {
1597     paused = _state;
1598   }
1599 
1600   function withdraw() public onlyOwner {
1601     require(address(this).balance > 0, "Balance is 0");
1602     payable(owner()).transfer(address(this).balance);
1603   }
1604 
1605   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1606     addressMintedBalance[_receiver]+= _mintAmount;
1607     _safeMint(_receiver, _mintAmount);
1608   }
1609 
1610   function _baseURI() internal view virtual override returns (string memory) {
1611     return uriPrefix;
1612   }
1613 }