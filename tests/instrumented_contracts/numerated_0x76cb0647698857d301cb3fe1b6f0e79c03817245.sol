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
71 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
83  */
84 library MerkleProof {
85     /**
86      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
87      * defined by `root`. For this, a `proof` must be provided, containing
88      * sibling hashes on the branch from the leaf to the root of the tree. Each
89      * pair of leaves and each pair of pre-images are assumed to be sorted.
90      */
91     function verify(
92         bytes32[] memory proof,
93         bytes32 root,
94         bytes32 leaf
95     ) internal pure returns (bool) {
96         return processProof(proof, leaf) == root;
97     }
98 
99     /**
100      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
101      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
102      * hash matches the root of the tree. When processing the proof, the pairs
103      * of leafs & pre-images are assumed to be sorted.
104      *
105      * _Available since v4.4._
106      */
107     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
108         bytes32 computedHash = leaf;
109         for (uint256 i = 0; i < proof.length; i++) {
110             bytes32 proofElement = proof[i];
111             if (computedHash <= proofElement) {
112                 // Hash(current computed hash + current element of the proof)
113                 computedHash = _efficientHash(computedHash, proofElement);
114             } else {
115                 // Hash(current element of the proof + current computed hash)
116                 computedHash = _efficientHash(proofElement, computedHash);
117             }
118         }
119         return computedHash;
120     }
121 
122     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
123         assembly {
124             mstore(0x00, a)
125             mstore(0x20, b)
126             value := keccak256(0x00, 0x40)
127         }
128     }
129 }
130 
131 // File: @openzeppelin/contracts/utils/Strings.sol
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev String operations.
140  */
141 library Strings {
142     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
146      */
147     function toString(uint256 value) internal pure returns (string memory) {
148         // Inspired by OraclizeAPI's implementation - MIT licence
149         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
150 
151         if (value == 0) {
152             return "0";
153         }
154         uint256 temp = value;
155         uint256 digits;
156         while (temp != 0) {
157             digits++;
158             temp /= 10;
159         }
160         bytes memory buffer = new bytes(digits);
161         while (value != 0) {
162             digits -= 1;
163             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
164             value /= 10;
165         }
166         return string(buffer);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
171      */
172     function toHexString(uint256 value) internal pure returns (string memory) {
173         if (value == 0) {
174             return "0x00";
175         }
176         uint256 temp = value;
177         uint256 length = 0;
178         while (temp != 0) {
179             length++;
180             temp >>= 8;
181         }
182         return toHexString(value, length);
183     }
184 
185     /**
186      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
187      */
188     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
189         bytes memory buffer = new bytes(2 * length + 2);
190         buffer[0] = "0";
191         buffer[1] = "x";
192         for (uint256 i = 2 * length + 1; i > 1; --i) {
193             buffer[i] = _HEX_SYMBOLS[value & 0xf];
194             value >>= 4;
195         }
196         require(value == 0, "Strings: hex length insufficient");
197         return string(buffer);
198     }
199 }
200 
201 // File: @openzeppelin/contracts/utils/Context.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Provides information about the current execution context, including the
210  * sender of the transaction and its data. While these are generally available
211  * via msg.sender and msg.data, they should not be accessed in such a direct
212  * manner, since when dealing with meta-transactions the account sending and
213  * paying for execution may not be the actual sender (as far as an application
214  * is concerned).
215  *
216  * This contract is only required for intermediate, library-like contracts.
217  */
218 abstract contract Context {
219     function _msgSender() internal view virtual returns (address) {
220         return msg.sender;
221     }
222 
223     function _msgData() internal view virtual returns (bytes calldata) {
224         return msg.data;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/access/Ownable.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 /**
237  * @dev Contract module which provides a basic access control mechanism, where
238  * there is an account (an owner) that can be granted exclusive access to
239  * specific functions.
240  *
241  * By default, the owner account will be the one that deploys the contract. This
242  * can later be changed with {transferOwnership}.
243  *
244  * This module is used through inheritance. It will make available the modifier
245  * `onlyOwner`, which can be applied to your functions to restrict their use to
246  * the owner.
247  */
248 abstract contract Ownable is Context {
249     address private _owner;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     /**
254      * @dev Initializes the contract setting the deployer as the initial owner.
255      */
256     constructor() {
257         _transferOwnership(_msgSender());
258     }
259 
260     /**
261      * @dev Returns the address of the current owner.
262      */
263     function owner() public view virtual returns (address) {
264         return _owner;
265     }
266 
267     /**
268      * @dev Throws if called by any account other than the owner.
269      */
270     modifier onlyOwner() {
271         require(owner() == _msgSender(), "Ownable: caller is not the owner");
272         _;
273     }
274 
275     /**
276      * @dev Leaves the contract without owner. It will not be possible to call
277      * `onlyOwner` functions anymore. Can only be called by the current owner.
278      *
279      * NOTE: Renouncing ownership will leave the contract without an owner,
280      * thereby removing any functionality that is only available to the owner.
281      */
282     function renounceOwnership() public virtual onlyOwner {
283         _transferOwnership(address(0));
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Can only be called by the current owner.
289      */
290     function transferOwnership(address newOwner) public virtual onlyOwner {
291         require(newOwner != address(0), "Ownable: new owner is the zero address");
292         _transferOwnership(newOwner);
293     }
294 
295     /**
296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
297      * Internal function without access restriction.
298      */
299     function _transferOwnership(address newOwner) internal virtual {
300         address oldOwner = _owner;
301         _owner = newOwner;
302         emit OwnershipTransferred(oldOwner, newOwner);
303     }
304 }
305 
306 // File: @openzeppelin/contracts/utils/Address.sol
307 
308 
309 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
310 
311 pragma solidity ^0.8.0;
312 
313 /**
314  * @dev Collection of functions related to the address type
315  */
316 library Address {
317     /**
318      * @dev Returns true if `account` is a contract.
319      *
320      * [IMPORTANT]
321      * ====
322      * It is unsafe to assume that an address for which this function returns
323      * false is an externally-owned account (EOA) and not a contract.
324      *
325      * Among others, `isContract` will return false for the following
326      * types of addresses:
327      *
328      *  - an externally-owned account
329      *  - a contract in construction
330      *  - an address where a contract will be created
331      *  - an address where a contract lived, but was destroyed
332      * ====
333      */
334     function isContract(address account) internal view returns (bool) {
335         // This method relies on extcodesize, which returns 0 for contracts in
336         // construction, since the code is only stored at the end of the
337         // constructor execution.
338 
339         uint256 size;
340         assembly {
341             size := extcodesize(account)
342         }
343         return size > 0;
344     }
345 
346     /**
347      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
348      * `recipient`, forwarding all available gas and reverting on errors.
349      *
350      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
351      * of certain opcodes, possibly making contracts go over the 2300 gas limit
352      * imposed by `transfer`, making them unable to receive funds via
353      * `transfer`. {sendValue} removes this limitation.
354      *
355      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
356      *
357      * IMPORTANT: because control is transferred to `recipient`, care must be
358      * taken to not create reentrancy vulnerabilities. Consider using
359      * {ReentrancyGuard} or the
360      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
361      */
362     function sendValue(address payable recipient, uint256 amount) internal {
363         require(address(this).balance >= amount, "Address: insufficient balance");
364 
365         (bool success, ) = recipient.call{value: amount}("");
366         require(success, "Address: unable to send value, recipient may have reverted");
367     }
368 
369     /**
370      * @dev Performs a Solidity function call using a low level `call`. A
371      * plain `call` is an unsafe replacement for a function call: use this
372      * function instead.
373      *
374      * If `target` reverts with a revert reason, it is bubbled up by this
375      * function (like regular Solidity function calls).
376      *
377      * Returns the raw returned data. To convert to the expected return value,
378      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
379      *
380      * Requirements:
381      *
382      * - `target` must be a contract.
383      * - calling `target` with `data` must not revert.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
388         return functionCall(target, data, "Address: low-level call failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
393      * `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(
398         address target,
399         bytes memory data,
400         string memory errorMessage
401     ) internal returns (bytes memory) {
402         return functionCallWithValue(target, data, 0, errorMessage);
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
407      * but also transferring `value` wei to `target`.
408      *
409      * Requirements:
410      *
411      * - the calling contract must have an ETH balance of at least `value`.
412      * - the called Solidity function must be `payable`.
413      *
414      * _Available since v3.1._
415      */
416     function functionCallWithValue(
417         address target,
418         bytes memory data,
419         uint256 value
420     ) internal returns (bytes memory) {
421         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(address(this).balance >= value, "Address: insufficient balance for call");
437         require(isContract(target), "Address: call to non-contract");
438 
439         (bool success, bytes memory returndata) = target.call{value: value}(data);
440         return verifyCallResult(success, returndata, errorMessage);
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
450         return functionStaticCall(target, data, "Address: low-level static call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal view returns (bytes memory) {
464         require(isContract(target), "Address: static call to non-contract");
465 
466         (bool success, bytes memory returndata) = target.staticcall(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
477         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
482      * but performing a delegate call.
483      *
484      * _Available since v3.4._
485      */
486     function functionDelegateCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         require(isContract(target), "Address: delegate call to non-contract");
492 
493         (bool success, bytes memory returndata) = target.delegatecall(data);
494         return verifyCallResult(success, returndata, errorMessage);
495     }
496 
497     /**
498      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
499      * revert reason using the provided one.
500      *
501      * _Available since v4.3._
502      */
503     function verifyCallResult(
504         bool success,
505         bytes memory returndata,
506         string memory errorMessage
507     ) internal pure returns (bytes memory) {
508         if (success) {
509             return returndata;
510         } else {
511             // Look for revert reason and bubble it up if present
512             if (returndata.length > 0) {
513                 // The easiest way to bubble the revert reason is using memory via assembly
514 
515                 assembly {
516                     let returndata_size := mload(returndata)
517                     revert(add(32, returndata), returndata_size)
518                 }
519             } else {
520                 revert(errorMessage);
521             }
522         }
523     }
524 }
525 
526 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
527 
528 
529 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
530 
531 pragma solidity ^0.8.0;
532 
533 /**
534  * @title ERC721 token receiver interface
535  * @dev Interface for any contract that wants to support safeTransfers
536  * from ERC721 asset contracts.
537  */
538 interface IERC721Receiver {
539     /**
540      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
541      * by `operator` from `from`, this function is called.
542      *
543      * It must return its Solidity selector to confirm the token transfer.
544      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
545      *
546      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
547      */
548     function onERC721Received(
549         address operator,
550         address from,
551         uint256 tokenId,
552         bytes calldata data
553     ) external returns (bytes4);
554 }
555 
556 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
557 
558 
559 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
560 
561 pragma solidity ^0.8.0;
562 
563 /**
564  * @dev Interface of the ERC165 standard, as defined in the
565  * https://eips.ethereum.org/EIPS/eip-165[EIP].
566  *
567  * Implementers can declare support of contract interfaces, which can then be
568  * queried by others ({ERC165Checker}).
569  *
570  * For an implementation, see {ERC165}.
571  */
572 interface IERC165 {
573     /**
574      * @dev Returns true if this contract implements the interface defined by
575      * `interfaceId`. See the corresponding
576      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
577      * to learn more about how these ids are created.
578      *
579      * This function call must use less than 30 000 gas.
580      */
581     function supportsInterface(bytes4 interfaceId) external view returns (bool);
582 }
583 
584 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
585 
586 
587 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
588 
589 pragma solidity ^0.8.0;
590 
591 
592 /**
593  * @dev Implementation of the {IERC165} interface.
594  *
595  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
596  * for the additional interface id that will be supported. For example:
597  *
598  * ```solidity
599  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
601  * }
602  * ```
603  *
604  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
605  */
606 abstract contract ERC165 is IERC165 {
607     /**
608      * @dev See {IERC165-supportsInterface}.
609      */
610     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
611         return interfaceId == type(IERC165).interfaceId;
612     }
613 }
614 
615 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
616 
617 
618 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
619 
620 pragma solidity ^0.8.0;
621 
622 
623 /**
624  * @dev Required interface of an ERC721 compliant contract.
625  */
626 interface IERC721 is IERC165 {
627     /**
628      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
629      */
630     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
631 
632     /**
633      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
634      */
635     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
636 
637     /**
638      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
639      */
640     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
641 
642     /**
643      * @dev Returns the number of tokens in ``owner``'s account.
644      */
645     function balanceOf(address owner) external view returns (uint256 balance);
646 
647     /**
648      * @dev Returns the owner of the `tokenId` token.
649      *
650      * Requirements:
651      *
652      * - `tokenId` must exist.
653      */
654     function ownerOf(uint256 tokenId) external view returns (address owner);
655 
656     /**
657      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
658      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must exist and be owned by `from`.
665      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
666      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
667      *
668      * Emits a {Transfer} event.
669      */
670     function safeTransferFrom(
671         address from,
672         address to,
673         uint256 tokenId
674     ) external;
675 
676     /**
677      * @dev Transfers `tokenId` token from `from` to `to`.
678      *
679      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      *
688      * Emits a {Transfer} event.
689      */
690     function transferFrom(
691         address from,
692         address to,
693         uint256 tokenId
694     ) external;
695 
696     /**
697      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
698      * The approval is cleared when the token is transferred.
699      *
700      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
701      *
702      * Requirements:
703      *
704      * - The caller must own the token or be an approved operator.
705      * - `tokenId` must exist.
706      *
707      * Emits an {Approval} event.
708      */
709     function approve(address to, uint256 tokenId) external;
710 
711     /**
712      * @dev Returns the account approved for `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function getApproved(uint256 tokenId) external view returns (address operator);
719 
720     /**
721      * @dev Approve or remove `operator` as an operator for the caller.
722      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
723      *
724      * Requirements:
725      *
726      * - The `operator` cannot be the caller.
727      *
728      * Emits an {ApprovalForAll} event.
729      */
730     function setApprovalForAll(address operator, bool _approved) external;
731 
732     /**
733      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
734      *
735      * See {setApprovalForAll}
736      */
737     function isApprovedForAll(address owner, address operator) external view returns (bool);
738 
739     /**
740      * @dev Safely transfers `tokenId` token from `from` to `to`.
741      *
742      * Requirements:
743      *
744      * - `from` cannot be the zero address.
745      * - `to` cannot be the zero address.
746      * - `tokenId` token must exist and be owned by `from`.
747      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
748      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
749      *
750      * Emits a {Transfer} event.
751      */
752     function safeTransferFrom(
753         address from,
754         address to,
755         uint256 tokenId,
756         bytes calldata data
757     ) external;
758 }
759 
760 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
770  * @dev See https://eips.ethereum.org/EIPS/eip-721
771  */
772 interface IERC721Metadata is IERC721 {
773     /**
774      * @dev Returns the token collection name.
775      */
776     function name() external view returns (string memory);
777 
778     /**
779      * @dev Returns the token collection symbol.
780      */
781     function symbol() external view returns (string memory);
782 
783     /**
784      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
785      */
786     function tokenURI(uint256 tokenId) external view returns (string memory);
787 }
788 
789 // File: erc721a/contracts/ERC721A.sol
790 
791 
792 // Creator: Chiru Labs
793 
794 pragma solidity ^0.8.4;
795 
796 
797 
798 
799 
800 
801 
802 
803 error ApprovalCallerNotOwnerNorApproved();
804 error ApprovalQueryForNonexistentToken();
805 error ApproveToCaller();
806 error ApprovalToCurrentOwner();
807 error BalanceQueryForZeroAddress();
808 error MintToZeroAddress();
809 error MintZeroQuantity();
810 error OwnerQueryForNonexistentToken();
811 error TransferCallerNotOwnerNorApproved();
812 error TransferFromIncorrectOwner();
813 error TransferToNonERC721ReceiverImplementer();
814 error TransferToZeroAddress();
815 error URIQueryForNonexistentToken();
816 
817 /**
818  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
819  * the Metadata extension. Built to optimize for lower gas during batch mints.
820  *
821  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
822  *
823  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
824  *
825  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
826  */
827 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
828     using Address for address;
829     using Strings for uint256;
830 
831     // Compiler will pack this into a single 256bit word.
832     struct TokenOwnership {
833         // The address of the owner.
834         address addr;
835         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
836         uint64 startTimestamp;
837         // Whether the token has been burned.
838         bool burned;
839     }
840 
841     // Compiler will pack this into a single 256bit word.
842     struct AddressData {
843         // Realistically, 2**64-1 is more than enough.
844         uint64 balance;
845         // Keeps track of mint count with minimal overhead for tokenomics.
846         uint64 numberMinted;
847         // Keeps track of burn count with minimal overhead for tokenomics.
848         uint64 numberBurned;
849         // For miscellaneous variable(s) pertaining to the address
850         // (e.g. number of whitelist mint slots used).
851         // If there are multiple variables, please pack them into a uint64.
852         uint64 aux;
853     }
854 
855     // The tokenId of the next token to be minted.
856     uint256 internal _currentIndex;
857 
858     // The number of tokens burned.
859     uint256 internal _burnCounter;
860 
861     // Token name
862     string private _name;
863 
864     // Token symbol
865     string private _symbol;
866 
867     // Mapping from token ID to ownership details
868     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
869     mapping(uint256 => TokenOwnership) internal _ownerships;
870 
871     // Mapping owner address to address data
872     mapping(address => AddressData) private _addressData;
873 
874     // Mapping from token ID to approved address
875     mapping(uint256 => address) private _tokenApprovals;
876 
877     // Mapping from owner to operator approvals
878     mapping(address => mapping(address => bool)) private _operatorApprovals;
879 
880     constructor(string memory name_, string memory symbol_) {
881         _name = name_;
882         _symbol = symbol_;
883         _currentIndex = _startTokenId();
884     }
885 
886     /**
887      * To change the starting tokenId, please override this function.
888      */
889     function _startTokenId() internal view virtual returns (uint256) {
890         return 0;
891     }
892 
893     /**
894      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
895      */
896     function totalSupply() public view returns (uint256) {
897         // Counter underflow is impossible as _burnCounter cannot be incremented
898         // more than _currentIndex - _startTokenId() times
899         unchecked {
900             return _currentIndex - _burnCounter - _startTokenId();
901         }
902     }
903 
904     /**
905      * Returns the total amount of tokens minted in the contract.
906      */
907     function _totalMinted() internal view returns (uint256) {
908         // Counter underflow is impossible as _currentIndex does not decrement,
909         // and it is initialized to _startTokenId()
910         unchecked {
911             return _currentIndex - _startTokenId();
912         }
913     }
914 
915     /**
916      * @dev See {IERC165-supportsInterface}.
917      */
918     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
919         return
920             interfaceId == type(IERC721).interfaceId ||
921             interfaceId == type(IERC721Metadata).interfaceId ||
922             super.supportsInterface(interfaceId);
923     }
924 
925     /**
926      * @dev See {IERC721-balanceOf}.
927      */
928     function balanceOf(address owner) public view override returns (uint256) {
929         if (owner == address(0)) revert BalanceQueryForZeroAddress();
930         return uint256(_addressData[owner].balance);
931     }
932 
933     /**
934      * Returns the number of tokens minted by `owner`.
935      */
936     function _numberMinted(address owner) internal view returns (uint256) {
937         return uint256(_addressData[owner].numberMinted);
938     }
939 
940     /**
941      * Returns the number of tokens burned by or on behalf of `owner`.
942      */
943     function _numberBurned(address owner) internal view returns (uint256) {
944         return uint256(_addressData[owner].numberBurned);
945     }
946 
947     /**
948      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
949      */
950     function _getAux(address owner) internal view returns (uint64) {
951         return _addressData[owner].aux;
952     }
953 
954     /**
955      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
956      * If there are multiple variables, please pack them into a uint64.
957      */
958     function _setAux(address owner, uint64 aux) internal {
959         _addressData[owner].aux = aux;
960     }
961 
962     /**
963      * Gas spent here starts off proportional to the maximum mint batch size.
964      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
965      */
966     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
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
997         return _ownershipOf(tokenId).addr;
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
1059     function setApprovalForAll(address operator, bool approved) public virtual override {
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
1213         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1214 
1215         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1216 
1217         bool isApprovedOrOwner = (_msgSender() == from ||
1218             isApprovedForAll(from, _msgSender()) ||
1219             getApproved(tokenId) == _msgSender());
1220 
1221         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1222         if (to == address(0)) revert TransferToZeroAddress();
1223 
1224         _beforeTokenTransfers(from, to, tokenId, 1);
1225 
1226         // Clear approvals from the previous owner
1227         _approve(address(0), tokenId, from);
1228 
1229         // Underflow of the sender's balance is impossible because we check for
1230         // ownership above and the recipient's balance can't realistically overflow.
1231         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1232         unchecked {
1233             _addressData[from].balance -= 1;
1234             _addressData[to].balance += 1;
1235 
1236             TokenOwnership storage currSlot = _ownerships[tokenId];
1237             currSlot.addr = to;
1238             currSlot.startTimestamp = uint64(block.timestamp);
1239 
1240             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1241             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1242             uint256 nextTokenId = tokenId + 1;
1243             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1244             if (nextSlot.addr == address(0)) {
1245                 // This will suffice for checking _exists(nextTokenId),
1246                 // as a burned slot cannot contain the zero address.
1247                 if (nextTokenId != _currentIndex) {
1248                     nextSlot.addr = from;
1249                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1250                 }
1251             }
1252         }
1253 
1254         emit Transfer(from, to, tokenId);
1255         _afterTokenTransfers(from, to, tokenId, 1);
1256     }
1257 
1258     /**
1259      * @dev This is equivalent to _burn(tokenId, false)
1260      */
1261     function _burn(uint256 tokenId) internal virtual {
1262         _burn(tokenId, false);
1263     }
1264 
1265     /**
1266      * @dev Destroys `tokenId`.
1267      * The approval is cleared when the token is burned.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      *
1273      * Emits a {Transfer} event.
1274      */
1275     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1276         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1277 
1278         address from = prevOwnership.addr;
1279 
1280         if (approvalCheck) {
1281             bool isApprovedOrOwner = (_msgSender() == from ||
1282                 isApprovedForAll(from, _msgSender()) ||
1283                 getApproved(tokenId) == _msgSender());
1284 
1285             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1286         }
1287 
1288         _beforeTokenTransfers(from, address(0), tokenId, 1);
1289 
1290         // Clear approvals from the previous owner
1291         _approve(address(0), tokenId, from);
1292 
1293         // Underflow of the sender's balance is impossible because we check for
1294         // ownership above and the recipient's balance can't realistically overflow.
1295         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1296         unchecked {
1297             AddressData storage addressData = _addressData[from];
1298             addressData.balance -= 1;
1299             addressData.numberBurned += 1;
1300 
1301             // Keep track of who burned the token, and the timestamp of burning.
1302             TokenOwnership storage currSlot = _ownerships[tokenId];
1303             currSlot.addr = from;
1304             currSlot.startTimestamp = uint64(block.timestamp);
1305             currSlot.burned = true;
1306 
1307             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1308             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1309             uint256 nextTokenId = tokenId + 1;
1310             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1311             if (nextSlot.addr == address(0)) {
1312                 // This will suffice for checking _exists(nextTokenId),
1313                 // as a burned slot cannot contain the zero address.
1314                 if (nextTokenId != _currentIndex) {
1315                     nextSlot.addr = from;
1316                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1317                 }
1318             }
1319         }
1320 
1321         emit Transfer(from, address(0), tokenId);
1322         _afterTokenTransfers(from, address(0), tokenId, 1);
1323 
1324         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1325         unchecked {
1326             _burnCounter++;
1327         }
1328     }
1329 
1330     /**
1331      * @dev Approve `to` to operate on `tokenId`
1332      *
1333      * Emits a {Approval} event.
1334      */
1335     function _approve(
1336         address to,
1337         uint256 tokenId,
1338         address owner
1339     ) private {
1340         _tokenApprovals[tokenId] = to;
1341         emit Approval(owner, to, tokenId);
1342     }
1343 
1344     /**
1345      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1346      *
1347      * @param from address representing the previous owner of the given token ID
1348      * @param to target address that will receive the tokens
1349      * @param tokenId uint256 ID of the token to be transferred
1350      * @param _data bytes optional data to send along with the call
1351      * @return bool whether the call correctly returned the expected magic value
1352      */
1353     function _checkContractOnERC721Received(
1354         address from,
1355         address to,
1356         uint256 tokenId,
1357         bytes memory _data
1358     ) private returns (bool) {
1359         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1360             return retval == IERC721Receiver(to).onERC721Received.selector;
1361         } catch (bytes memory reason) {
1362             if (reason.length == 0) {
1363                 revert TransferToNonERC721ReceiverImplementer();
1364             } else {
1365                 assembly {
1366                     revert(add(32, reason), mload(reason))
1367                 }
1368             }
1369         }
1370     }
1371 
1372     /**
1373      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1374      * And also called before burning one token.
1375      *
1376      * startTokenId - the first token id to be transferred
1377      * quantity - the amount to be transferred
1378      *
1379      * Calling conditions:
1380      *
1381      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1382      * transferred to `to`.
1383      * - When `from` is zero, `tokenId` will be minted for `to`.
1384      * - When `to` is zero, `tokenId` will be burned by `from`.
1385      * - `from` and `to` are never both zero.
1386      */
1387     function _beforeTokenTransfers(
1388         address from,
1389         address to,
1390         uint256 startTokenId,
1391         uint256 quantity
1392     ) internal virtual {}
1393 
1394     /**
1395      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1396      * minting.
1397      * And also called after one token has been burned.
1398      *
1399      * startTokenId - the first token id to be transferred
1400      * quantity - the amount to be transferred
1401      *
1402      * Calling conditions:
1403      *
1404      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1405      * transferred to `to`.
1406      * - When `from` is zero, `tokenId` has been minted for `to`.
1407      * - When `to` is zero, `tokenId` has been burned by `from`.
1408      * - `from` and `to` are never both zero.
1409      */
1410     function _afterTokenTransfers(
1411         address from,
1412         address to,
1413         uint256 startTokenId,
1414         uint256 quantity
1415     ) internal virtual {}
1416 }
1417 
1418 // File: contracts/new_flat.sol
1419 
1420 
1421 pragma solidity >=0.8.9 <0.9.0;
1422 
1423 
1424 
1425 
1426 
1427 contract monte_booker_kolors is ERC721A, Ownable, ReentrancyGuard {
1428 
1429   using Strings for uint256;
1430 
1431   bytes32 public merkleRoot;
1432   mapping(address => bool) public whitelistClaimed;
1433 
1434   string public uriPrefix = "";
1435   string public uriSuffix = ".json";
1436   string public hiddenMetadataUri;
1437   
1438   uint256 public cost;
1439   uint256 public maxSupply;
1440   uint256 public maxMintAmountPerTx;
1441 
1442   bool public paused = true;
1443   bool public whitelistMintEnabled = false;
1444   bool public revealed = false;
1445 
1446   address payable private payments; 
1447 
1448   constructor(
1449     string memory _tokenName,
1450     string memory _tokenSymbol,
1451     uint256 _cost,
1452     uint256 _maxSupply,
1453     uint256 _maxMintAmountPerTx,
1454     string memory _hiddenMetadataUri,
1455     address _payments
1456   ) ERC721A(_tokenName, _tokenSymbol) {
1457     cost = _cost;
1458     maxSupply = _maxSupply;
1459     maxMintAmountPerTx = _maxMintAmountPerTx;
1460     setHiddenMetadataUri(_hiddenMetadataUri);
1461     payments=payable(_payments);
1462   }
1463 
1464   modifier mintCompliance(uint256 _mintAmount) {
1465     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1466     require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1467     _;
1468   }
1469 
1470   modifier mintPriceCompliance(uint256 _mintAmount) {
1471     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1472     _;
1473   }
1474 
1475   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1476     // Verify whitelist requirements
1477     require(whitelistMintEnabled, "The whitelist sale is not enabled!");
1478     require(!whitelistClaimed[_msgSender()], "Address already claimed!");
1479     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1480     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof!");
1481 
1482     whitelistClaimed[_msgSender()] = true;
1483     _safeMint(_msgSender(), _mintAmount);
1484   }
1485 
1486   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1487     require(!paused, "The contract is paused!");
1488 
1489     _safeMint(_msgSender(), _mintAmount);
1490   }
1491   
1492   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1493     _safeMint(_receiver, _mintAmount);
1494   }
1495 
1496   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1497     uint256 ownerTokenCount = balanceOf(_owner);
1498     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1499     uint256 currentTokenId = _startTokenId();
1500     uint256 ownedTokenIndex = 0;
1501     address latestOwnerAddress;
1502 
1503     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1504       TokenOwnership memory ownership = _ownerships[currentTokenId];
1505 
1506       if (!ownership.burned && ownership.addr != address(0)) {
1507         latestOwnerAddress = ownership.addr;
1508       }
1509 
1510       if (latestOwnerAddress == _owner) {
1511         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1512 
1513         ownedTokenIndex++;
1514       }
1515 
1516       currentTokenId++;
1517     }
1518 
1519     return ownedTokenIds;
1520   }
1521 
1522   function _startTokenId() internal view virtual override returns (uint256) {
1523         return 1;
1524     }
1525 
1526   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1527     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1528 
1529     if (revealed == false) {
1530       return hiddenMetadataUri;
1531     }
1532 
1533     string memory currentBaseURI = _baseURI();
1534     return bytes(currentBaseURI).length > 0
1535         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1536         : "";
1537   }
1538 
1539   function setRevealed(bool _state) public onlyOwner {
1540     revealed = _state;
1541   }
1542 
1543   function setCost(uint256 _cost) public onlyOwner {
1544     cost = _cost;
1545   }
1546 
1547   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1548     maxMintAmountPerTx = _maxMintAmountPerTx;
1549   }
1550 
1551   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1552     hiddenMetadataUri = _hiddenMetadataUri;
1553   }
1554 
1555   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1556     uriPrefix = _uriPrefix;
1557   }
1558 
1559   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1560     uriSuffix = _uriSuffix;
1561   }
1562 
1563   function setPaused(bool _state) public onlyOwner {
1564     paused = _state;
1565   }
1566 
1567   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1568     merkleRoot = _merkleRoot;
1569   }
1570 
1571   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1572     whitelistMintEnabled = _state;
1573   }
1574 
1575   function withdraw() public payable onlyOwner {
1576     (bool success, ) = payable(payments).call{value: address(this).balance}("");
1577     require(success);
1578   }
1579 
1580   function _baseURI() internal view virtual override returns (string memory) {
1581     return uriPrefix;
1582   }
1583 }