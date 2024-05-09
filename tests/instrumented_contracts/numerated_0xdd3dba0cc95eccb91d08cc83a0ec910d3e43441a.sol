1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev These functions deal with verification of Merkle Trees proofs.
77  *
78  * The proofs can be generated using the JavaScript library
79  * https://github.com/miguelmota/merkletreejs[merkletreejs].
80  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
81  *
82  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
83  *
84  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
85  * hashing, or use a hash function other than keccak256 for hashing leaves.
86  * This is because the concatenation of a sorted pair of internal nodes in
87  * the merkle tree could be reinterpreted as a leaf value.
88  */
89 library MerkleProof {
90     /**
91      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
92      * defined by `root`. For this, a `proof` must be provided, containing
93      * sibling hashes on the branch from the leaf to the root of the tree. Each
94      * pair of leaves and each pair of pre-images are assumed to be sorted.
95      */
96     function verify(
97         bytes32[] memory proof,
98         bytes32 root,
99         bytes32 leaf
100     ) internal pure returns (bool) {
101         return processProof(proof, leaf) == root;
102     }
103 
104     /**
105      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
106      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
107      * hash matches the root of the tree. When processing the proof, the pairs
108      * of leafs & pre-images are assumed to be sorted.
109      *
110      * _Available since v4.4._
111      */
112     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
113         bytes32 computedHash = leaf;
114         for (uint256 i = 0; i < proof.length; i++) {
115             bytes32 proofElement = proof[i];
116             if (computedHash <= proofElement) {
117                 // Hash(current computed hash + current element of the proof)
118                 computedHash = _efficientHash(computedHash, proofElement);
119             } else {
120                 // Hash(current element of the proof + current computed hash)
121                 computedHash = _efficientHash(proofElement, computedHash);
122             }
123         }
124         return computedHash;
125     }
126 
127     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
128         assembly {
129             mstore(0x00, a)
130             mstore(0x20, b)
131             value := keccak256(0x00, 0x40)
132         }
133     }
134 }
135 
136 // File: @openzeppelin/contracts/utils/Strings.sol
137 
138 
139 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
140 
141 pragma solidity ^0.8.0;
142 
143 /**
144  * @dev String operations.
145  */
146 library Strings {
147     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
151      */
152     function toString(uint256 value) internal pure returns (string memory) {
153         // Inspired by OraclizeAPI's implementation - MIT licence
154         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
155 
156         if (value == 0) {
157             return "0";
158         }
159         uint256 temp = value;
160         uint256 digits;
161         while (temp != 0) {
162             digits++;
163             temp /= 10;
164         }
165         bytes memory buffer = new bytes(digits);
166         while (value != 0) {
167             digits -= 1;
168             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
169             value /= 10;
170         }
171         return string(buffer);
172     }
173 
174     /**
175      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
176      */
177     function toHexString(uint256 value) internal pure returns (string memory) {
178         if (value == 0) {
179             return "0x00";
180         }
181         uint256 temp = value;
182         uint256 length = 0;
183         while (temp != 0) {
184             length++;
185             temp >>= 8;
186         }
187         return toHexString(value, length);
188     }
189 
190     /**
191      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
192      */
193     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
194         bytes memory buffer = new bytes(2 * length + 2);
195         buffer[0] = "0";
196         buffer[1] = "x";
197         for (uint256 i = 2 * length + 1; i > 1; --i) {
198             buffer[i] = _HEX_SYMBOLS[value & 0xf];
199             value >>= 4;
200         }
201         require(value == 0, "Strings: hex length insufficient");
202         return string(buffer);
203     }
204 }
205 
206 // File: @openzeppelin/contracts/utils/Context.sol
207 
208 
209 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
210 
211 pragma solidity ^0.8.0;
212 
213 /**
214  * @dev Provides information about the current execution context, including the
215  * sender of the transaction and its data. While these are generally available
216  * via msg.sender and msg.data, they should not be accessed in such a direct
217  * manner, since when dealing with meta-transactions the account sending and
218  * paying for execution may not be the actual sender (as far as an application
219  * is concerned).
220  *
221  * This contract is only required for intermediate, library-like contracts.
222  */
223 abstract contract Context {
224     function _msgSender() internal view virtual returns (address) {
225         return msg.sender;
226     }
227 
228     function _msgData() internal view virtual returns (bytes calldata) {
229         return msg.data;
230     }
231 }
232 
233 // File: @openzeppelin/contracts/access/Ownable.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 
241 /**
242  * @dev Contract module which provides a basic access control mechanism, where
243  * there is an account (an owner) that can be granted exclusive access to
244  * specific functions.
245  *
246  * By default, the owner account will be the one that deploys the contract. This
247  * can later be changed with {transferOwnership}.
248  *
249  * This module is used through inheritance. It will make available the modifier
250  * `onlyOwner`, which can be applied to your functions to restrict their use to
251  * the owner.
252  */
253 abstract contract Ownable is Context {
254     address private _owner;
255 
256     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258     /**
259      * @dev Initializes the contract setting the deployer as the initial owner.
260      */
261     constructor() {
262         _transferOwnership(_msgSender());
263     }
264 
265     /**
266      * @dev Returns the address of the current owner.
267      */
268     function owner() public view virtual returns (address) {
269         return _owner;
270     }
271 
272     /**
273      * @dev Throws if called by any account other than the owner.
274      */
275     modifier onlyOwner() {
276         require(owner() == _msgSender(), "Ownable: caller is not the owner");
277         _;
278     }
279 
280     /**
281      * @dev Leaves the contract without owner. It will not be possible to call
282      * `onlyOwner` functions anymore. Can only be called by the current owner.
283      *
284      * NOTE: Renouncing ownership will leave the contract without an owner,
285      * thereby removing any functionality that is only available to the owner.
286      */
287     function renounceOwnership() public virtual onlyOwner {
288         _transferOwnership(address(0));
289     }
290 
291     /**
292      * @dev Transfers ownership of the contract to a new account (`newOwner`).
293      * Can only be called by the current owner.
294      */
295     function transferOwnership(address newOwner) public virtual onlyOwner {
296         require(newOwner != address(0), "Ownable: new owner is the zero address");
297         _transferOwnership(newOwner);
298     }
299 
300     /**
301      * @dev Transfers ownership of the contract to a new account (`newOwner`).
302      * Internal function without access restriction.
303      */
304     function _transferOwnership(address newOwner) internal virtual {
305         address oldOwner = _owner;
306         _owner = newOwner;
307         emit OwnershipTransferred(oldOwner, newOwner);
308     }
309 }
310 
311 // File: @openzeppelin/contracts/utils/Address.sol
312 
313 
314 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
315 
316 pragma solidity ^0.8.1;
317 
318 /**
319  * @dev Collection of functions related to the address type
320  */
321 library Address {
322     /**
323      * @dev Returns true if `account` is a contract.
324      *
325      * [IMPORTANT]
326      * ====
327      * It is unsafe to assume that an address for which this function returns
328      * false is an externally-owned account (EOA) and not a contract.
329      *
330      * Among others, `isContract` will return false for the following
331      * types of addresses:
332      *
333      *  - an externally-owned account
334      *  - a contract in construction
335      *  - an address where a contract will be created
336      *  - an address where a contract lived, but was destroyed
337      * ====
338      *
339      * [IMPORTANT]
340      * ====
341      * You shouldn't rely on `isContract` to protect against flash loan attacks!
342      *
343      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
344      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
345      * constructor.
346      * ====
347      */
348     function isContract(address account) internal view returns (bool) {
349         // This method relies on extcodesize/address.code.length, which returns 0
350         // for contracts in construction, since the code is only stored at the end
351         // of the constructor execution.
352 
353         return account.code.length > 0;
354     }
355 
356     /**
357      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
358      * `recipient`, forwarding all available gas and reverting on errors.
359      *
360      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
361      * of certain opcodes, possibly making contracts go over the 2300 gas limit
362      * imposed by `transfer`, making them unable to receive funds via
363      * `transfer`. {sendValue} removes this limitation.
364      *
365      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
366      *
367      * IMPORTANT: because control is transferred to `recipient`, care must be
368      * taken to not create reentrancy vulnerabilities. Consider using
369      * {ReentrancyGuard} or the
370      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
371      */
372     function sendValue(address payable recipient, uint256 amount) internal {
373         require(address(this).balance >= amount, "Address: insufficient balance");
374 
375         (bool success, ) = recipient.call{value: amount}("");
376         require(success, "Address: unable to send value, recipient may have reverted");
377     }
378 
379     /**
380      * @dev Performs a Solidity function call using a low level `call`. A
381      * plain `call` is an unsafe replacement for a function call: use this
382      * function instead.
383      *
384      * If `target` reverts with a revert reason, it is bubbled up by this
385      * function (like regular Solidity function calls).
386      *
387      * Returns the raw returned data. To convert to the expected return value,
388      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389      *
390      * Requirements:
391      *
392      * - `target` must be a contract.
393      * - calling `target` with `data` must not revert.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
398         return functionCall(target, data, "Address: low-level call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
403      * `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(
408         address target,
409         bytes memory data,
410         string memory errorMessage
411     ) internal returns (bytes memory) {
412         return functionCallWithValue(target, data, 0, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but also transferring `value` wei to `target`.
418      *
419      * Requirements:
420      *
421      * - the calling contract must have an ETH balance of at least `value`.
422      * - the called Solidity function must be `payable`.
423      *
424      * _Available since v3.1._
425      */
426     function functionCallWithValue(
427         address target,
428         bytes memory data,
429         uint256 value
430     ) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
436      * with `errorMessage` as a fallback revert reason when `target` reverts.
437      *
438      * _Available since v3.1._
439      */
440     function functionCallWithValue(
441         address target,
442         bytes memory data,
443         uint256 value,
444         string memory errorMessage
445     ) internal returns (bytes memory) {
446         require(address(this).balance >= value, "Address: insufficient balance for call");
447         require(isContract(target), "Address: call to non-contract");
448 
449         (bool success, bytes memory returndata) = target.call{value: value}(data);
450         return verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
460         return functionStaticCall(target, data, "Address: low-level static call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a static call.
466      *
467      * _Available since v3.3._
468      */
469     function functionStaticCall(
470         address target,
471         bytes memory data,
472         string memory errorMessage
473     ) internal view returns (bytes memory) {
474         require(isContract(target), "Address: static call to non-contract");
475 
476         (bool success, bytes memory returndata) = target.staticcall(data);
477         return verifyCallResult(success, returndata, errorMessage);
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
487         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
492      * but performing a delegate call.
493      *
494      * _Available since v3.4._
495      */
496     function functionDelegateCall(
497         address target,
498         bytes memory data,
499         string memory errorMessage
500     ) internal returns (bytes memory) {
501         require(isContract(target), "Address: delegate call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.delegatecall(data);
504         return verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
509      * revert reason using the provided one.
510      *
511      * _Available since v4.3._
512      */
513     function verifyCallResult(
514         bool success,
515         bytes memory returndata,
516         string memory errorMessage
517     ) internal pure returns (bytes memory) {
518         if (success) {
519             return returndata;
520         } else {
521             // Look for revert reason and bubble it up if present
522             if (returndata.length > 0) {
523                 // The easiest way to bubble the revert reason is using memory via assembly
524 
525                 assembly {
526                     let returndata_size := mload(returndata)
527                     revert(add(32, returndata), returndata_size)
528                 }
529             } else {
530                 revert(errorMessage);
531             }
532         }
533     }
534 }
535 
536 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
537 
538 
539 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
540 
541 pragma solidity ^0.8.0;
542 
543 /**
544  * @title ERC721 token receiver interface
545  * @dev Interface for any contract that wants to support safeTransfers
546  * from ERC721 asset contracts.
547  */
548 interface IERC721Receiver {
549     /**
550      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
551      * by `operator` from `from`, this function is called.
552      *
553      * It must return its Solidity selector to confirm the token transfer.
554      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
555      *
556      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
557      */
558     function onERC721Received(
559         address operator,
560         address from,
561         uint256 tokenId,
562         bytes calldata data
563     ) external returns (bytes4);
564 }
565 
566 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
567 
568 
569 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @dev Interface of the ERC165 standard, as defined in the
575  * https://eips.ethereum.org/EIPS/eip-165[EIP].
576  *
577  * Implementers can declare support of contract interfaces, which can then be
578  * queried by others ({ERC165Checker}).
579  *
580  * For an implementation, see {ERC165}.
581  */
582 interface IERC165 {
583     /**
584      * @dev Returns true if this contract implements the interface defined by
585      * `interfaceId`. See the corresponding
586      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
587      * to learn more about how these ids are created.
588      *
589      * This function call must use less than 30 000 gas.
590      */
591     function supportsInterface(bytes4 interfaceId) external view returns (bool);
592 }
593 
594 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
595 
596 
597 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 
602 /**
603  * @dev Implementation of the {IERC165} interface.
604  *
605  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
606  * for the additional interface id that will be supported. For example:
607  *
608  * ```solidity
609  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
610  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
611  * }
612  * ```
613  *
614  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
615  */
616 abstract contract ERC165 is IERC165 {
617     /**
618      * @dev See {IERC165-supportsInterface}.
619      */
620     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
621         return interfaceId == type(IERC165).interfaceId;
622     }
623 }
624 
625 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
626 
627 
628 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
629 
630 pragma solidity ^0.8.0;
631 
632 
633 /**
634  * @dev Required interface of an ERC721 compliant contract.
635  */
636 interface IERC721 is IERC165 {
637     /**
638      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
639      */
640     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
641 
642     /**
643      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
644      */
645     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
646 
647     /**
648      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
649      */
650     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
651 
652     /**
653      * @dev Returns the number of tokens in ``owner``'s account.
654      */
655     function balanceOf(address owner) external view returns (uint256 balance);
656 
657     /**
658      * @dev Returns the owner of the `tokenId` token.
659      *
660      * Requirements:
661      *
662      * - `tokenId` must exist.
663      */
664     function ownerOf(uint256 tokenId) external view returns (address owner);
665 
666     /**
667      * @dev Safely transfers `tokenId` token from `from` to `to`.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must exist and be owned by `from`.
674      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676      *
677      * Emits a {Transfer} event.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId,
683         bytes calldata data
684     ) external;
685 
686     /**
687      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
688      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must exist and be owned by `from`.
695      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
696      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
697      *
698      * Emits a {Transfer} event.
699      */
700     function safeTransferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) external;
705 
706     /**
707      * @dev Transfers `tokenId` token from `from` to `to`.
708      *
709      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
710      *
711      * Requirements:
712      *
713      * - `from` cannot be the zero address.
714      * - `to` cannot be the zero address.
715      * - `tokenId` token must be owned by `from`.
716      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
717      *
718      * Emits a {Transfer} event.
719      */
720     function transferFrom(
721         address from,
722         address to,
723         uint256 tokenId
724     ) external;
725 
726     /**
727      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
728      * The approval is cleared when the token is transferred.
729      *
730      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
731      *
732      * Requirements:
733      *
734      * - The caller must own the token or be an approved operator.
735      * - `tokenId` must exist.
736      *
737      * Emits an {Approval} event.
738      */
739     function approve(address to, uint256 tokenId) external;
740 
741     /**
742      * @dev Approve or remove `operator` as an operator for the caller.
743      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
744      *
745      * Requirements:
746      *
747      * - The `operator` cannot be the caller.
748      *
749      * Emits an {ApprovalForAll} event.
750      */
751     function setApprovalForAll(address operator, bool _approved) external;
752 
753     /**
754      * @dev Returns the account approved for `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function getApproved(uint256 tokenId) external view returns (address operator);
761 
762     /**
763      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
764      *
765      * See {setApprovalForAll}
766      */
767     function isApprovedForAll(address owner, address operator) external view returns (bool);
768 }
769 
770 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
771 
772 
773 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
774 
775 pragma solidity ^0.8.0;
776 
777 
778 /**
779  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
780  * @dev See https://eips.ethereum.org/EIPS/eip-721
781  */
782 interface IERC721Metadata is IERC721 {
783     /**
784      * @dev Returns the token collection name.
785      */
786     function name() external view returns (string memory);
787 
788     /**
789      * @dev Returns the token collection symbol.
790      */
791     function symbol() external view returns (string memory);
792 
793     /**
794      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
795      */
796     function tokenURI(uint256 tokenId) external view returns (string memory);
797 }
798 
799 // File: erc721a/contracts/ERC721A.sol
800 
801 
802 // Creator: Chiru Labs
803 
804 pragma solidity ^0.8.4;
805 
806 
807 
808 
809 
810 
811 
812 
813 error ApprovalCallerNotOwnerNorApproved();
814 error ApprovalQueryForNonexistentToken();
815 error ApproveToCaller();
816 error ApprovalToCurrentOwner();
817 error BalanceQueryForZeroAddress();
818 error MintToZeroAddress();
819 error MintZeroQuantity();
820 error OwnerQueryForNonexistentToken();
821 error TransferCallerNotOwnerNorApproved();
822 error TransferFromIncorrectOwner();
823 error TransferToNonERC721ReceiverImplementer();
824 error TransferToZeroAddress();
825 error URIQueryForNonexistentToken();
826 
827 /**
828  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
829  * the Metadata extension. Built to optimize for lower gas during batch mints.
830  *
831  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
832  *
833  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
834  *
835  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
836  */
837 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
838     using Address for address;
839     using Strings for uint256;
840 
841     // Compiler will pack this into a single 256bit word.
842     struct TokenOwnership {
843         // The address of the owner.
844         address addr;
845         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
846         uint64 startTimestamp;
847         // Whether the token has been burned.
848         bool burned;
849     }
850 
851     // Compiler will pack this into a single 256bit word.
852     struct AddressData {
853         // Realistically, 2**64-1 is more than enough.
854         uint64 balance;
855         // Keeps track of mint count with minimal overhead for tokenomics.
856         uint64 numberMinted;
857         // Keeps track of burn count with minimal overhead for tokenomics.
858         uint64 numberBurned;
859         // For miscellaneous variable(s) pertaining to the address
860         // (e.g. number of whitelist mint slots used).
861         // If there are multiple variables, please pack them into a uint64.
862         uint64 aux;
863     }
864 
865     // The tokenId of the next token to be minted.
866     uint256 internal _currentIndex;
867 
868     // The number of tokens burned.
869     uint256 internal _burnCounter;
870 
871     // Token name
872     string private _name;
873 
874     // Token symbol
875     string private _symbol;
876 
877     // Mapping from token ID to ownership details
878     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
879     mapping(uint256 => TokenOwnership) internal _ownerships;
880 
881     // Mapping owner address to address data
882     mapping(address => AddressData) private _addressData;
883 
884     // Mapping from token ID to approved address
885     mapping(uint256 => address) private _tokenApprovals;
886 
887     // Mapping from owner to operator approvals
888     mapping(address => mapping(address => bool)) private _operatorApprovals;
889 
890     constructor(string memory name_, string memory symbol_) {
891         _name = name_;
892         _symbol = symbol_;
893         _currentIndex = _startTokenId();
894     }
895 
896     /**
897      * To change the starting tokenId, please override this function.
898      */
899     function _startTokenId() internal view virtual returns (uint256) {
900         return 0;
901     }
902 
903     /**
904      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
905      */
906     function totalSupply() public view returns (uint256) {
907         // Counter underflow is impossible as _burnCounter cannot be incremented
908         // more than _currentIndex - _startTokenId() times
909         unchecked {
910             return _currentIndex - _burnCounter - _startTokenId();
911         }
912     }
913 
914     /**
915      * Returns the total amount of tokens minted in the contract.
916      */
917     function _totalMinted() internal view returns (uint256) {
918         // Counter underflow is impossible as _currentIndex does not decrement,
919         // and it is initialized to _startTokenId()
920         unchecked {
921             return _currentIndex - _startTokenId();
922         }
923     }
924 
925     /**
926      * @dev See {IERC165-supportsInterface}.
927      */
928     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
929         return
930             interfaceId == type(IERC721).interfaceId ||
931             interfaceId == type(IERC721Metadata).interfaceId ||
932             super.supportsInterface(interfaceId);
933     }
934 
935     /**
936      * @dev See {IERC721-balanceOf}.
937      */
938     function balanceOf(address owner) public view override returns (uint256) {
939         if (owner == address(0)) revert BalanceQueryForZeroAddress();
940         return uint256(_addressData[owner].balance);
941     }
942 
943     /**
944      * Returns the number of tokens minted by `owner`.
945      */
946     function _numberMinted(address owner) internal view returns (uint256) {
947         return uint256(_addressData[owner].numberMinted);
948     }
949 
950     /**
951      * Returns the number of tokens burned by or on behalf of `owner`.
952      */
953     function _numberBurned(address owner) internal view returns (uint256) {
954         return uint256(_addressData[owner].numberBurned);
955     }
956 
957     /**
958      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
959      */
960     function _getAux(address owner) internal view returns (uint64) {
961         return _addressData[owner].aux;
962     }
963 
964     /**
965      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
966      * If there are multiple variables, please pack them into a uint64.
967      */
968     function _setAux(address owner, uint64 aux) internal {
969         _addressData[owner].aux = aux;
970     }
971 
972     /**
973      * Gas spent here starts off proportional to the maximum mint batch size.
974      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
975      */
976     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
977         uint256 curr = tokenId;
978 
979         unchecked {
980             if (_startTokenId() <= curr && curr < _currentIndex) {
981                 TokenOwnership memory ownership = _ownerships[curr];
982                 if (!ownership.burned) {
983                     if (ownership.addr != address(0)) {
984                         return ownership;
985                     }
986                     // Invariant:
987                     // There will always be an ownership that has an address and is not burned
988                     // before an ownership that does not have an address and is not burned.
989                     // Hence, curr will not underflow.
990                     while (true) {
991                         curr--;
992                         ownership = _ownerships[curr];
993                         if (ownership.addr != address(0)) {
994                             return ownership;
995                         }
996                     }
997                 }
998             }
999         }
1000         revert OwnerQueryForNonexistentToken();
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-ownerOf}.
1005      */
1006     function ownerOf(uint256 tokenId) public view override returns (address) {
1007         return _ownershipOf(tokenId).addr;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-name}.
1012      */
1013     function name() public view virtual override returns (string memory) {
1014         return _name;
1015     }
1016 
1017     /**
1018      * @dev See {IERC721Metadata-symbol}.
1019      */
1020     function symbol() public view virtual override returns (string memory) {
1021         return _symbol;
1022     }
1023 
1024     /**
1025      * @dev See {IERC721Metadata-tokenURI}.
1026      */
1027     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1028         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1029 
1030         string memory baseURI = _baseURI();
1031         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1032     }
1033 
1034     /**
1035      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1036      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1037      * by default, can be overriden in child contracts.
1038      */
1039     function _baseURI() internal view virtual returns (string memory) {
1040         return '';
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-approve}.
1045      */
1046     function approve(address to, uint256 tokenId) public override {
1047         address owner = ERC721A.ownerOf(tokenId);
1048         if (to == owner) revert ApprovalToCurrentOwner();
1049 
1050         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1051             revert ApprovalCallerNotOwnerNorApproved();
1052         }
1053 
1054         _approve(to, tokenId, owner);
1055     }
1056 
1057     /**
1058      * @dev See {IERC721-getApproved}.
1059      */
1060     function getApproved(uint256 tokenId) public view override returns (address) {
1061         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1062 
1063         return _tokenApprovals[tokenId];
1064     }
1065 
1066     /**
1067      * @dev See {IERC721-setApprovalForAll}.
1068      */
1069     function setApprovalForAll(address operator, bool approved) public virtual override {
1070         if (operator == _msgSender()) revert ApproveToCaller();
1071 
1072         _operatorApprovals[_msgSender()][operator] = approved;
1073         emit ApprovalForAll(_msgSender(), operator, approved);
1074     }
1075 
1076     /**
1077      * @dev See {IERC721-isApprovedForAll}.
1078      */
1079     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1080         return _operatorApprovals[owner][operator];
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-transferFrom}.
1085      */
1086     function transferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) public virtual override {
1091         _transfer(from, to, tokenId);
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-safeTransferFrom}.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId
1101     ) public virtual override {
1102         safeTransferFrom(from, to, tokenId, '');
1103     }
1104 
1105     /**
1106      * @dev See {IERC721-safeTransferFrom}.
1107      */
1108     function safeTransferFrom(
1109         address from,
1110         address to,
1111         uint256 tokenId,
1112         bytes memory _data
1113     ) public virtual override {
1114         _transfer(from, to, tokenId);
1115         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1116             revert TransferToNonERC721ReceiverImplementer();
1117         }
1118     }
1119 
1120     /**
1121      * @dev Returns whether `tokenId` exists.
1122      *
1123      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1124      *
1125      * Tokens start existing when they are minted (`_mint`),
1126      */
1127     function _exists(uint256 tokenId) internal view returns (bool) {
1128         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1129     }
1130 
1131     function _safeMint(address to, uint256 quantity) internal {
1132         _safeMint(to, quantity, '');
1133     }
1134 
1135     /**
1136      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1137      *
1138      * Requirements:
1139      *
1140      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1141      * - `quantity` must be greater than 0.
1142      *
1143      * Emits a {Transfer} event.
1144      */
1145     function _safeMint(
1146         address to,
1147         uint256 quantity,
1148         bytes memory _data
1149     ) internal {
1150         _mint(to, quantity, _data, true);
1151     }
1152 
1153     /**
1154      * @dev Mints `quantity` tokens and transfers them to `to`.
1155      *
1156      * Requirements:
1157      *
1158      * - `to` cannot be the zero address.
1159      * - `quantity` must be greater than 0.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _mint(
1164         address to,
1165         uint256 quantity,
1166         bytes memory _data,
1167         bool safe
1168     ) internal {
1169         uint256 startTokenId = _currentIndex;
1170         if (to == address(0)) revert MintToZeroAddress();
1171         if (quantity == 0) revert MintZeroQuantity();
1172 
1173         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1174 
1175         // Overflows are incredibly unrealistic.
1176         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1177         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1178         unchecked {
1179             _addressData[to].balance += uint64(quantity);
1180             _addressData[to].numberMinted += uint64(quantity);
1181 
1182             _ownerships[startTokenId].addr = to;
1183             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1184 
1185             uint256 updatedIndex = startTokenId;
1186             uint256 end = updatedIndex + quantity;
1187 
1188             if (safe && to.isContract()) {
1189                 do {
1190                     emit Transfer(address(0), to, updatedIndex);
1191                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1192                         revert TransferToNonERC721ReceiverImplementer();
1193                     }
1194                 } while (updatedIndex != end);
1195                 // Reentrancy protection
1196                 if (_currentIndex != startTokenId) revert();
1197             } else {
1198                 do {
1199                     emit Transfer(address(0), to, updatedIndex++);
1200                 } while (updatedIndex != end);
1201             }
1202             _currentIndex = updatedIndex;
1203         }
1204         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1205     }
1206 
1207     /**
1208      * @dev Transfers `tokenId` from `from` to `to`.
1209      *
1210      * Requirements:
1211      *
1212      * - `to` cannot be the zero address.
1213      * - `tokenId` token must be owned by `from`.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function _transfer(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) private {
1222         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1223 
1224         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1225 
1226         bool isApprovedOrOwner = (_msgSender() == from ||
1227             isApprovedForAll(from, _msgSender()) ||
1228             getApproved(tokenId) == _msgSender());
1229 
1230         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1231         if (to == address(0)) revert TransferToZeroAddress();
1232 
1233         _beforeTokenTransfers(from, to, tokenId, 1);
1234 
1235         // Clear approvals from the previous owner
1236         _approve(address(0), tokenId, from);
1237 
1238         // Underflow of the sender's balance is impossible because we check for
1239         // ownership above and the recipient's balance can't realistically overflow.
1240         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1241         unchecked {
1242             _addressData[from].balance -= 1;
1243             _addressData[to].balance += 1;
1244 
1245             TokenOwnership storage currSlot = _ownerships[tokenId];
1246             currSlot.addr = to;
1247             currSlot.startTimestamp = uint64(block.timestamp);
1248 
1249             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1250             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1251             uint256 nextTokenId = tokenId + 1;
1252             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1253             if (nextSlot.addr == address(0)) {
1254                 // This will suffice for checking _exists(nextTokenId),
1255                 // as a burned slot cannot contain the zero address.
1256                 if (nextTokenId != _currentIndex) {
1257                     nextSlot.addr = from;
1258                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1259                 }
1260             }
1261         }
1262 
1263         emit Transfer(from, to, tokenId);
1264         _afterTokenTransfers(from, to, tokenId, 1);
1265     }
1266 
1267     /**
1268      * @dev This is equivalent to _burn(tokenId, false)
1269      */
1270     function _burn(uint256 tokenId) internal virtual {
1271         _burn(tokenId, false);
1272     }
1273 
1274     /**
1275      * @dev Destroys `tokenId`.
1276      * The approval is cleared when the token is burned.
1277      *
1278      * Requirements:
1279      *
1280      * - `tokenId` must exist.
1281      *
1282      * Emits a {Transfer} event.
1283      */
1284     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1285         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1286 
1287         address from = prevOwnership.addr;
1288 
1289         if (approvalCheck) {
1290             bool isApprovedOrOwner = (_msgSender() == from ||
1291                 isApprovedForAll(from, _msgSender()) ||
1292                 getApproved(tokenId) == _msgSender());
1293 
1294             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1295         }
1296 
1297         _beforeTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Clear approvals from the previous owner
1300         _approve(address(0), tokenId, from);
1301 
1302         // Underflow of the sender's balance is impossible because we check for
1303         // ownership above and the recipient's balance can't realistically overflow.
1304         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1305         unchecked {
1306             AddressData storage addressData = _addressData[from];
1307             addressData.balance -= 1;
1308             addressData.numberBurned += 1;
1309 
1310             // Keep track of who burned the token, and the timestamp of burning.
1311             TokenOwnership storage currSlot = _ownerships[tokenId];
1312             currSlot.addr = from;
1313             currSlot.startTimestamp = uint64(block.timestamp);
1314             currSlot.burned = true;
1315 
1316             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1317             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1318             uint256 nextTokenId = tokenId + 1;
1319             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1320             if (nextSlot.addr == address(0)) {
1321                 // This will suffice for checking _exists(nextTokenId),
1322                 // as a burned slot cannot contain the zero address.
1323                 if (nextTokenId != _currentIndex) {
1324                     nextSlot.addr = from;
1325                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1326                 }
1327             }
1328         }
1329 
1330         emit Transfer(from, address(0), tokenId);
1331         _afterTokenTransfers(from, address(0), tokenId, 1);
1332 
1333         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1334         unchecked {
1335             _burnCounter++;
1336         }
1337     }
1338 
1339     /**
1340      * @dev Approve `to` to operate on `tokenId`
1341      *
1342      * Emits a {Approval} event.
1343      */
1344     function _approve(
1345         address to,
1346         uint256 tokenId,
1347         address owner
1348     ) private {
1349         _tokenApprovals[tokenId] = to;
1350         emit Approval(owner, to, tokenId);
1351     }
1352 
1353     /**
1354      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1355      *
1356      * @param from address representing the previous owner of the given token ID
1357      * @param to target address that will receive the tokens
1358      * @param tokenId uint256 ID of the token to be transferred
1359      * @param _data bytes optional data to send along with the call
1360      * @return bool whether the call correctly returned the expected magic value
1361      */
1362     function _checkContractOnERC721Received(
1363         address from,
1364         address to,
1365         uint256 tokenId,
1366         bytes memory _data
1367     ) private returns (bool) {
1368         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1369             return retval == IERC721Receiver(to).onERC721Received.selector;
1370         } catch (bytes memory reason) {
1371             if (reason.length == 0) {
1372                 revert TransferToNonERC721ReceiverImplementer();
1373             } else {
1374                 assembly {
1375                     revert(add(32, reason), mload(reason))
1376                 }
1377             }
1378         }
1379     }
1380 
1381     /**
1382      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1383      * And also called before burning one token.
1384      *
1385      * startTokenId - the first token id to be transferred
1386      * quantity - the amount to be transferred
1387      *
1388      * Calling conditions:
1389      *
1390      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1391      * transferred to `to`.
1392      * - When `from` is zero, `tokenId` will be minted for `to`.
1393      * - When `to` is zero, `tokenId` will be burned by `from`.
1394      * - `from` and `to` are never both zero.
1395      */
1396     function _beforeTokenTransfers(
1397         address from,
1398         address to,
1399         uint256 startTokenId,
1400         uint256 quantity
1401     ) internal virtual {}
1402 
1403     /**
1404      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1405      * minting.
1406      * And also called after one token has been burned.
1407      *
1408      * startTokenId - the first token id to be transferred
1409      * quantity - the amount to be transferred
1410      *
1411      * Calling conditions:
1412      *
1413      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1414      * transferred to `to`.
1415      * - When `from` is zero, `tokenId` has been minted for `to`.
1416      * - When `to` is zero, `tokenId` has been burned by `from`.
1417      * - `from` and `to` are never both zero.
1418      */
1419     function _afterTokenTransfers(
1420         address from,
1421         address to,
1422         uint256 startTokenId,
1423         uint256 quantity
1424     ) internal virtual {}
1425 }
1426 
1427 // File: contracts/abc.sol
1428 
1429 
1430 
1431 
1432 
1433 pragma solidity >=0.8.9 <0.9.0;
1434 
1435 
1436 
1437 
1438 
1439 
1440 
1441 contract Buckbuck is ERC721A, Ownable, ReentrancyGuard {
1442 
1443     using Strings for uint256;
1444 
1445 
1446 
1447     bytes32 public merkleRoot;
1448 
1449     mapping(address => bool) public whitelistClaimed;
1450 
1451 
1452 
1453     string public uriPrefix = "";
1454 
1455     string public uriSuffix = ".json";
1456 
1457     string public hiddenMetadataUri;
1458 
1459 
1460 
1461     uint256 public cost;
1462 
1463     uint256 public maxSupply;
1464 
1465     uint256 public maxMintAmountPerTx;
1466 
1467     uint256 public maxMintAmountPerAddress;
1468 
1469 
1470 
1471     bool public paused = true;
1472 
1473     bool public whitelistMintEnabled = false;
1474 
1475     bool public revealed = true;
1476 
1477 
1478 
1479     mapping(address => uint256) public totalMintedByAddress;
1480 
1481 
1482 
1483     constructor(
1484 
1485         string memory _tokenName,
1486 
1487         string memory _tokenSymbol,
1488 
1489         uint256 _cost,
1490 
1491         uint256 _maxSupply,
1492 
1493         uint256 _maxMintAmountPerTx,
1494 
1495         uint256 _maxMintAmountPerAddress,
1496 
1497         string memory _hiddenMetadataUri
1498 
1499     ) ERC721A(_tokenName, _tokenSymbol) {
1500 
1501         setCost(_cost);
1502 
1503         maxSupply = _maxSupply;
1504 
1505         setMaxMintAmountPerTx(_maxMintAmountPerTx);
1506 
1507         setMaxMintAmountPerAddress(_maxMintAmountPerAddress);
1508 
1509         setHiddenMetadataUri(_hiddenMetadataUri);
1510 
1511     }
1512 
1513 
1514 
1515     modifier mintCompliance(uint256 _mintAmount) {
1516 
1517         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1518 
1519         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1520 
1521         _;
1522 
1523     }
1524 
1525 
1526 
1527     modifier mintPriceCompliance(uint256 _mintAmount) {
1528 
1529         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1530 
1531         _;
1532 
1533     }
1534 
1535 
1536 
1537     function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1538 
1539         // Verify whitelist requirements
1540 
1541         require(whitelistMintEnabled, "The whitelist sale is not enabled!");
1542 
1543         require(!whitelistClaimed[_msgSender()], "Address already claimed!");
1544 
1545         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1546 
1547         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof!");
1548 
1549 
1550 
1551         whitelistClaimed[_msgSender()] = true;
1552 
1553         _safeMint(_msgSender(), _mintAmount);
1554 
1555     }
1556 
1557 
1558 
1559     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1560 
1561         require(totalMintedByAddress[msg.sender] + _mintAmount <= maxMintAmountPerAddress, "Exceeded maximum total amount!");
1562 
1563         require(!paused, "The contract is paused!");
1564 
1565 
1566 
1567         for (uint256 i = 0; i < _mintAmount; i++) {
1568 
1569             totalMintedByAddress[msg.sender]++;
1570 
1571         }
1572 
1573 
1574 
1575         _safeMint(_msgSender(), _mintAmount);
1576 
1577     }
1578 
1579 
1580 
1581     function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1582 
1583         _safeMint(_receiver, _mintAmount);
1584 
1585     }
1586 
1587 
1588 
1589     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1590 
1591         uint256 ownerTokenCount = balanceOf(_owner);
1592 
1593         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1594 
1595         uint256 currentTokenId = _startTokenId();
1596 
1597         uint256 ownedTokenIndex = 0;
1598 
1599         address latestOwnerAddress;
1600 
1601 
1602 
1603         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1604 
1605             TokenOwnership memory ownership = _ownerships[currentTokenId];
1606 
1607 
1608 
1609             if (!ownership.burned && ownership.addr != address(0)) {
1610 
1611                 latestOwnerAddress = ownership.addr;
1612 
1613             }
1614 
1615 
1616 
1617             if (latestOwnerAddress == _owner) {
1618 
1619                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1620 
1621 
1622 
1623                 ownedTokenIndex++;
1624 
1625             }
1626 
1627 
1628 
1629             currentTokenId++;
1630 
1631         }
1632 
1633 
1634 
1635         return ownedTokenIds;
1636 
1637     }
1638 
1639 
1640 
1641     function _startTokenId() internal view virtual override returns (uint256) {
1642 
1643         return 1;
1644 
1645     }
1646 
1647 
1648 
1649     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1650 
1651         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1652 
1653 
1654 
1655         if (revealed == false) {
1656 
1657             return hiddenMetadataUri;
1658 
1659         }
1660 
1661 
1662 
1663         string memory currentBaseURI = _baseURI();
1664 
1665         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)) : "";
1666 
1667     }
1668 
1669 
1670 
1671     function setRevealed(bool _state) public onlyOwner {
1672 
1673         revealed = _state;
1674 
1675     }
1676 
1677 
1678 
1679     function setCost(uint256 _cost) public onlyOwner {
1680 
1681         cost = _cost;
1682 
1683     }
1684 
1685 
1686 
1687     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1688 
1689         maxMintAmountPerTx = _maxMintAmountPerTx;
1690 
1691     }
1692 
1693 
1694 
1695     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1696 
1697         hiddenMetadataUri = _hiddenMetadataUri;
1698 
1699     }
1700 
1701 
1702 
1703     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1704 
1705         uriPrefix = _uriPrefix;
1706 
1707     }
1708 
1709 
1710 
1711     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1712 
1713         uriSuffix = _uriSuffix;
1714 
1715     }
1716 
1717 
1718 
1719     function setPaused(bool _state) public onlyOwner {
1720 
1721         paused = _state;
1722 
1723     }
1724 
1725 
1726 
1727     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1728 
1729         merkleRoot = _merkleRoot;
1730 
1731     }
1732 
1733 
1734 
1735     function setWhitelistMintEnabled(bool _state) public onlyOwner {
1736 
1737         whitelistMintEnabled = _state;
1738 
1739     }
1740 
1741 
1742 
1743     function setMaxMintAmountPerAddress(uint256 _maxMintAmountPerAddress) public onlyOwner {
1744 
1745         maxMintAmountPerAddress = _maxMintAmountPerAddress;
1746 
1747     }
1748 
1749 
1750 
1751     function withdraw() public onlyOwner nonReentrant {
1752 
1753         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1754 
1755         require(os);
1756 
1757     }
1758 
1759 
1760 
1761     function _baseURI() internal view virtual override returns (string memory) {
1762 
1763         return uriPrefix;
1764 
1765     }
1766 
1767 }