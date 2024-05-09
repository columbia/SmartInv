1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Contract module that helps prevent reentrant calls to a function.
9  *
10  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
11  * available, which can be applied to functions to make sure there are no nested
12  * (reentrant) calls to them.
13  *
14  * Note that because there is a single `nonReentrant` guard, functions marked as
15  * `nonReentrant` may not call one another. This can be worked around by making
16  * those functions `private`, and then adding `external` `nonReentrant` entry
17  * points to them.
18  *
19  * TIP: If you would like to learn more about reentrancy and alternative ways
20  * to protect against it, check out our blog post
21  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
22  */
23 abstract contract ReentrancyGuard {
24     // Booleans are more expensive than uint256 or any type that takes up a full
25     // word because each write operation emits an extra SLOAD to first read the
26     // slot's contents, replace the bits taken up by the boolean, and then write
27     // back. This is the compiler's defense against contract upgrades and
28     // pointer aliasing, and it cannot be disabled.
29 
30     // The values being non-zero value makes deployment a bit more expensive,
31     // but in exchange the refund on every call to nonReentrant will be lower in
32     // amount. Since refunds are capped to a percentage of the total
33     // transaction's gas, it is best to keep them low in cases like this one, to
34     // increase the likelihood of the full refund coming into effect.
35     uint256 private constant _NOT_ENTERED = 1;
36     uint256 private constant _ENTERED = 2;
37 
38     uint256 private _status;
39 
40     constructor() {
41         _status = _NOT_ENTERED;
42     }
43 
44     /**
45      * @dev Prevents a contract from calling itself, directly or indirectly.
46      * Calling a `nonReentrant` function from another `nonReentrant`
47      * function is not supported. It is possible to prevent this from happening
48      * by making the `nonReentrant` function external, and making it call a
49      * `private` function that does the actual work.
50      */
51     modifier nonReentrant() {
52         // On the first call to nonReentrant, _notEntered will be true
53         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
54 
55         // Any calls to nonReentrant after this point will fail
56         _status = _ENTERED;
57 
58         _;
59 
60         // By storing the original value once again, a refund is triggered (see
61         // https://eips.ethereum.org/EIPS/eip-2200)
62         _status = _NOT_ENTERED;
63     }
64 }
65 
66 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
67 
68 
69 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
70 
71 pragma solidity ^0.8.0;
72 
73 /**
74  * @dev These functions deal with verification of Merkle Trees proofs.
75  *
76  * The proofs can be generated using the JavaScript library
77  * https://github.com/miguelmota/merkletreejs[merkletreejs].
78  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
79  *
80  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
81  */
82 library MerkleProof {
83     /**
84      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
85      * defined by `root`. For this, a `proof` must be provided, containing
86      * sibling hashes on the branch from the leaf to the root of the tree. Each
87      * pair of leaves and each pair of pre-images are assumed to be sorted.
88      */
89     function verify(
90         bytes32[] memory proof,
91         bytes32 root,
92         bytes32 leaf
93     ) internal pure returns (bool) {
94         return processProof(proof, leaf) == root;
95     }
96 
97     /**
98      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
99      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
100      * hash matches the root of the tree. When processing the proof, the pairs
101      * of leafs & pre-images are assumed to be sorted.
102      *
103      * _Available since v4.4._
104      */
105     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
106         bytes32 computedHash = leaf;
107         for (uint256 i = 0; i < proof.length; i++) {
108             bytes32 proofElement = proof[i];
109             if (computedHash <= proofElement) {
110                 // Hash(current computed hash + current element of the proof)
111                 computedHash = _efficientHash(computedHash, proofElement);
112             } else {
113                 // Hash(current element of the proof + current computed hash)
114                 computedHash = _efficientHash(proofElement, computedHash);
115             }
116         }
117         return computedHash;
118     }
119 
120     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
121         assembly {
122             mstore(0x00, a)
123             mstore(0x20, b)
124             value := keccak256(0x00, 0x40)
125         }
126     }
127 }
128 
129 // File: @openzeppelin/contracts/utils/Strings.sol
130 
131 
132 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 /**
137  * @dev String operations.
138  */
139 library Strings {
140     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
141 
142     /**
143      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
144      */
145     function toString(uint256 value) internal pure returns (string memory) {
146         // Inspired by OraclizeAPI's implementation - MIT licence
147         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
148 
149         if (value == 0) {
150             return "0";
151         }
152         uint256 temp = value;
153         uint256 digits;
154         while (temp != 0) {
155             digits++;
156             temp /= 10;
157         }
158         bytes memory buffer = new bytes(digits);
159         while (value != 0) {
160             digits -= 1;
161             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
162             value /= 10;
163         }
164         return string(buffer);
165     }
166 
167     /**
168      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
169      */
170     function toHexString(uint256 value) internal pure returns (string memory) {
171         if (value == 0) {
172             return "0x00";
173         }
174         uint256 temp = value;
175         uint256 length = 0;
176         while (temp != 0) {
177             length++;
178             temp >>= 8;
179         }
180         return toHexString(value, length);
181     }
182 
183     /**
184      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
185      */
186     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
187         bytes memory buffer = new bytes(2 * length + 2);
188         buffer[0] = "0";
189         buffer[1] = "x";
190         for (uint256 i = 2 * length + 1; i > 1; --i) {
191             buffer[i] = _HEX_SYMBOLS[value & 0xf];
192             value >>= 4;
193         }
194         require(value == 0, "Strings: hex length insufficient");
195         return string(buffer);
196     }
197 }
198 
199 // File: @openzeppelin/contracts/utils/Context.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Provides information about the current execution context, including the
208  * sender of the transaction and its data. While these are generally available
209  * via msg.sender and msg.data, they should not be accessed in such a direct
210  * manner, since when dealing with meta-transactions the account sending and
211  * paying for execution may not be the actual sender (as far as an application
212  * is concerned).
213  *
214  * This contract is only required for intermediate, library-like contracts.
215  */
216 abstract contract Context {
217     function _msgSender() internal view virtual returns (address) {
218         return msg.sender;
219     }
220 
221     function _msgData() internal view virtual returns (bytes calldata) {
222         return msg.data;
223     }
224 }
225 
226 // File: @openzeppelin/contracts/access/Ownable.sol
227 
228 
229 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
230 
231 pragma solidity ^0.8.0;
232 
233 
234 /**
235  * @dev Contract module which provides a basic access control mechanism, where
236  * there is an account (an owner) that can be granted exclusive access to
237  * specific functions.
238  *
239  * By default, the owner account will be the one that deploys the contract. This
240  * can later be changed with {transferOwnership}.
241  *
242  * This module is used through inheritance. It will make available the modifier
243  * `onlyOwner`, which can be applied to your functions to restrict their use to
244  * the owner.
245  */
246 abstract contract Ownable is Context {
247     address private _owner;
248 
249     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
250 
251     /**
252      * @dev Initializes the contract setting the deployer as the initial owner.
253      */
254     constructor() {
255         _transferOwnership(_msgSender());
256     }
257 
258     /**
259      * @dev Returns the address of the current owner.
260      */
261     function owner() public view virtual returns (address) {
262         return _owner;
263     }
264 
265     /**
266      * @dev Throws if called by any account other than the owner.
267      */
268     modifier onlyOwner() {
269         require(owner() == _msgSender(), "Ownable: caller is not the owner");
270         _;
271     }
272 
273     /**
274      * @dev Leaves the contract without owner. It will not be possible to call
275      * `onlyOwner` functions anymore. Can only be called by the current owner.
276      *
277      * NOTE: Renouncing ownership will leave the contract without an owner,
278      * thereby removing any functionality that is only available to the owner.
279      */
280     function renounceOwnership() public virtual onlyOwner {
281         _transferOwnership(address(0));
282     }
283 
284     /**
285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
286      * Can only be called by the current owner.
287      */
288     function transferOwnership(address newOwner) public virtual onlyOwner {
289         require(newOwner != address(0), "Ownable: new owner is the zero address");
290         _transferOwnership(newOwner);
291     }
292 
293     /**
294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
295      * Internal function without access restriction.
296      */
297     function _transferOwnership(address newOwner) internal virtual {
298         address oldOwner = _owner;
299         _owner = newOwner;
300         emit OwnershipTransferred(oldOwner, newOwner);
301     }
302 }
303 
304 // File: @openzeppelin/contracts/utils/Address.sol
305 
306 
307 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
308 
309 pragma solidity ^0.8.1;
310 
311 /**
312  * @dev Collection of functions related to the address type
313  */
314 library Address {
315     /**
316      * @dev Returns true if `account` is a contract.
317      *
318      * [IMPORTANT]
319      * ====
320      * It is unsafe to assume that an address for which this function returns
321      * false is an externally-owned account (EOA) and not a contract.
322      *
323      * Among others, `isContract` will return false for the following
324      * types of addresses:
325      *
326      *  - an externally-owned account
327      *  - a contract in construction
328      *  - an address where a contract will be created
329      *  - an address where a contract lived, but was destroyed
330      * ====
331      *
332      * [IMPORTANT]
333      * ====
334      * You shouldn't rely on `isContract` to protect against flash loan attacks!
335      *
336      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
337      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
338      * constructor.
339      * ====
340      */
341     function isContract(address account) internal view returns (bool) {
342         // This method relies on extcodesize/address.code.length, which returns 0
343         // for contracts in construction, since the code is only stored at the end
344         // of the constructor execution.
345 
346         return account.code.length > 0;
347     }
348 
349     /**
350      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
351      * `recipient`, forwarding all available gas and reverting on errors.
352      *
353      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
354      * of certain opcodes, possibly making contracts go over the 2300 gas limit
355      * imposed by `transfer`, making them unable to receive funds via
356      * `transfer`. {sendValue} removes this limitation.
357      *
358      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
359      *
360      * IMPORTANT: because control is transferred to `recipient`, care must be
361      * taken to not create reentrancy vulnerabilities. Consider using
362      * {ReentrancyGuard} or the
363      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
364      */
365     function sendValue(address payable recipient, uint256 amount) internal {
366         require(address(this).balance >= amount, "Address: insufficient balance");
367 
368         (bool success, ) = recipient.call{value: amount}("");
369         require(success, "Address: unable to send value, recipient may have reverted");
370     }
371 
372     /**
373      * @dev Performs a Solidity function call using a low level `call`. A
374      * plain `call` is an unsafe replacement for a function call: use this
375      * function instead.
376      *
377      * If `target` reverts with a revert reason, it is bubbled up by this
378      * function (like regular Solidity function calls).
379      *
380      * Returns the raw returned data. To convert to the expected return value,
381      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
382      *
383      * Requirements:
384      *
385      * - `target` must be a contract.
386      * - calling `target` with `data` must not revert.
387      *
388      * _Available since v3.1._
389      */
390     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
391         return functionCall(target, data, "Address: low-level call failed");
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
396      * `errorMessage` as a fallback revert reason when `target` reverts.
397      *
398      * _Available since v3.1._
399      */
400     function functionCall(
401         address target,
402         bytes memory data,
403         string memory errorMessage
404     ) internal returns (bytes memory) {
405         return functionCallWithValue(target, data, 0, errorMessage);
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
410      * but also transferring `value` wei to `target`.
411      *
412      * Requirements:
413      *
414      * - the calling contract must have an ETH balance of at least `value`.
415      * - the called Solidity function must be `payable`.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value
423     ) internal returns (bytes memory) {
424         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
429      * with `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCallWithValue(
434         address target,
435         bytes memory data,
436         uint256 value,
437         string memory errorMessage
438     ) internal returns (bytes memory) {
439         require(address(this).balance >= value, "Address: insufficient balance for call");
440         require(isContract(target), "Address: call to non-contract");
441 
442         (bool success, bytes memory returndata) = target.call{value: value}(data);
443         return verifyCallResult(success, returndata, errorMessage);
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
448      * but performing a static call.
449      *
450      * _Available since v3.3._
451      */
452     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
453         return functionStaticCall(target, data, "Address: low-level static call failed");
454     }
455 
456     /**
457      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
458      * but performing a static call.
459      *
460      * _Available since v3.3._
461      */
462     function functionStaticCall(
463         address target,
464         bytes memory data,
465         string memory errorMessage
466     ) internal view returns (bytes memory) {
467         require(isContract(target), "Address: static call to non-contract");
468 
469         (bool success, bytes memory returndata) = target.staticcall(data);
470         return verifyCallResult(success, returndata, errorMessage);
471     }
472 
473     /**
474      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
475      * but performing a delegate call.
476      *
477      * _Available since v3.4._
478      */
479     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
480         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
485      * but performing a delegate call.
486      *
487      * _Available since v3.4._
488      */
489     function functionDelegateCall(
490         address target,
491         bytes memory data,
492         string memory errorMessage
493     ) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         (bool success, bytes memory returndata) = target.delegatecall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500     /**
501      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
502      * revert reason using the provided one.
503      *
504      * _Available since v4.3._
505      */
506     function verifyCallResult(
507         bool success,
508         bytes memory returndata,
509         string memory errorMessage
510     ) internal pure returns (bytes memory) {
511         if (success) {
512             return returndata;
513         } else {
514             // Look for revert reason and bubble it up if present
515             if (returndata.length > 0) {
516                 // The easiest way to bubble the revert reason is using memory via assembly
517 
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
530 
531 
532 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
533 
534 pragma solidity ^0.8.0;
535 
536 /**
537  * @title ERC721 token receiver interface
538  * @dev Interface for any contract that wants to support safeTransfers
539  * from ERC721 asset contracts.
540  */
541 interface IERC721Receiver {
542     /**
543      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
544      * by `operator` from `from`, this function is called.
545      *
546      * It must return its Solidity selector to confirm the token transfer.
547      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
548      *
549      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
550      */
551     function onERC721Received(
552         address operator,
553         address from,
554         uint256 tokenId,
555         bytes calldata data
556     ) external returns (bytes4);
557 }
558 
559 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Interface of the ERC165 standard, as defined in the
568  * https://eips.ethereum.org/EIPS/eip-165[EIP].
569  *
570  * Implementers can declare support of contract interfaces, which can then be
571  * queried by others ({ERC165Checker}).
572  *
573  * For an implementation, see {ERC165}.
574  */
575 interface IERC165 {
576     /**
577      * @dev Returns true if this contract implements the interface defined by
578      * `interfaceId`. See the corresponding
579      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
580      * to learn more about how these ids are created.
581      *
582      * This function call must use less than 30 000 gas.
583      */
584     function supportsInterface(bytes4 interfaceId) external view returns (bool);
585 }
586 
587 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
588 
589 
590 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
591 
592 pragma solidity ^0.8.0;
593 
594 
595 /**
596  * @dev Implementation of the {IERC165} interface.
597  *
598  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
599  * for the additional interface id that will be supported. For example:
600  *
601  * ```solidity
602  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
603  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
604  * }
605  * ```
606  *
607  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
608  */
609 abstract contract ERC165 is IERC165 {
610     /**
611      * @dev See {IERC165-supportsInterface}.
612      */
613     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
614         return interfaceId == type(IERC165).interfaceId;
615     }
616 }
617 
618 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
619 
620 
621 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @dev Required interface of an ERC721 compliant contract.
628  */
629 interface IERC721 is IERC165 {
630     /**
631      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
632      */
633     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
634 
635     /**
636      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
637      */
638     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
639 
640     /**
641      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
642      */
643     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
644 
645     /**
646      * @dev Returns the number of tokens in ``owner``'s account.
647      */
648     function balanceOf(address owner) external view returns (uint256 balance);
649 
650     /**
651      * @dev Returns the owner of the `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function ownerOf(uint256 tokenId) external view returns (address owner);
658 
659     /**
660      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
661      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must exist and be owned by `from`.
668      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
669      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
670      *
671      * Emits a {Transfer} event.
672      */
673     function safeTransferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) external;
678 
679     /**
680      * @dev Transfers `tokenId` token from `from` to `to`.
681      *
682      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must be owned by `from`.
689      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
690      *
691      * Emits a {Transfer} event.
692      */
693     function transferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) external;
698 
699     /**
700      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
701      * The approval is cleared when the token is transferred.
702      *
703      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
704      *
705      * Requirements:
706      *
707      * - The caller must own the token or be an approved operator.
708      * - `tokenId` must exist.
709      *
710      * Emits an {Approval} event.
711      */
712     function approve(address to, uint256 tokenId) external;
713 
714     /**
715      * @dev Returns the account approved for `tokenId` token.
716      *
717      * Requirements:
718      *
719      * - `tokenId` must exist.
720      */
721     function getApproved(uint256 tokenId) external view returns (address operator);
722 
723     /**
724      * @dev Approve or remove `operator` as an operator for the caller.
725      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
726      *
727      * Requirements:
728      *
729      * - The `operator` cannot be the caller.
730      *
731      * Emits an {ApprovalForAll} event.
732      */
733     function setApprovalForAll(address operator, bool _approved) external;
734 
735     /**
736      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
737      *
738      * See {setApprovalForAll}
739      */
740     function isApprovedForAll(address owner, address operator) external view returns (bool);
741 
742     /**
743      * @dev Safely transfers `tokenId` token from `from` to `to`.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must exist and be owned by `from`.
750      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
751      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
752      *
753      * Emits a {Transfer} event.
754      */
755     function safeTransferFrom(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes calldata data
760     ) external;
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
764 
765 
766 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
773  * @dev See https://eips.ethereum.org/EIPS/eip-721
774  */
775 interface IERC721Metadata is IERC721 {
776     /**
777      * @dev Returns the token collection name.
778      */
779     function name() external view returns (string memory);
780 
781     /**
782      * @dev Returns the token collection symbol.
783      */
784     function symbol() external view returns (string memory);
785 
786     /**
787      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
788      */
789     function tokenURI(uint256 tokenId) external view returns (string memory);
790 }
791 
792 // File: erc721a/contracts/ERC721A.sol
793 
794 
795 // Creator: Chiru Labs
796 
797 pragma solidity ^0.8.4;
798 
799 
800 
801 
802 
803 
804 
805 
806 error ApprovalCallerNotOwnerNorApproved();
807 error ApprovalQueryForNonexistentToken();
808 error ApproveToCaller();
809 error ApprovalToCurrentOwner();
810 error BalanceQueryForZeroAddress();
811 error MintToZeroAddress();
812 error MintZeroQuantity();
813 error OwnerQueryForNonexistentToken();
814 error TransferCallerNotOwnerNorApproved();
815 error TransferFromIncorrectOwner();
816 error TransferToNonERC721ReceiverImplementer();
817 error TransferToZeroAddress();
818 error URIQueryForNonexistentToken();
819 
820 /**
821  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
822  * the Metadata extension. Built to optimize for lower gas during batch mints.
823  *
824  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
825  *
826  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
827  *
828  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
829  */
830 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
831     using Address for address;
832     using Strings for uint256;
833 
834     // Compiler will pack this into a single 256bit word.
835     struct TokenOwnership {
836         // The address of the owner.
837         address addr;
838         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
839         uint64 startTimestamp;
840         // Whether the token has been burned.
841         bool burned;
842     }
843 
844     // Compiler will pack this into a single 256bit word.
845     struct AddressData {
846         // Realistically, 2**64-1 is more than enough.
847         uint64 balance;
848         // Keeps track of mint count with minimal overhead for tokenomics.
849         uint64 numberMinted;
850         // Keeps track of burn count with minimal overhead for tokenomics.
851         uint64 numberBurned;
852         // For miscellaneous variable(s) pertaining to the address
853         // (e.g. number of whitelist mint slots used).
854         // If there are multiple variables, please pack them into a uint64.
855         uint64 aux;
856     }
857 
858     // The tokenId of the next token to be minted.
859     uint256 internal _currentIndex;
860 
861     // The number of tokens burned.
862     uint256 internal _burnCounter;
863 
864     // Token name
865     string private _name;
866 
867     // Token symbol
868     string private _symbol;
869 
870     // Mapping from token ID to ownership details
871     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
872     mapping(uint256 => TokenOwnership) internal _ownerships;
873 
874     // Mapping owner address to address data
875     mapping(address => AddressData) private _addressData;
876 
877     // Mapping from token ID to approved address
878     mapping(uint256 => address) private _tokenApprovals;
879 
880     // Mapping from owner to operator approvals
881     mapping(address => mapping(address => bool)) private _operatorApprovals;
882 
883     constructor(string memory name_, string memory symbol_) {
884         _name = name_;
885         _symbol = symbol_;
886         _currentIndex = _startTokenId();
887     }
888 
889     /**
890      * To change the starting tokenId, please override this function.
891      */
892     function _startTokenId() internal view virtual returns (uint256) {
893         return 0;
894     }
895 
896     /**
897      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
898      */
899     function totalSupply() public view returns (uint256) {
900         // Counter underflow is impossible as _burnCounter cannot be incremented
901         // more than _currentIndex - _startTokenId() times
902         unchecked {
903             return _currentIndex - _burnCounter - _startTokenId();
904         }
905     }
906 
907     /**
908      * Returns the total amount of tokens minted in the contract.
909      */
910     function _totalMinted() internal view returns (uint256) {
911         // Counter underflow is impossible as _currentIndex does not decrement,
912         // and it is initialized to _startTokenId()
913         unchecked {
914             return _currentIndex - _startTokenId();
915         }
916     }
917 
918     /**
919      * @dev See {IERC165-supportsInterface}.
920      */
921     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
922         return
923             interfaceId == type(IERC721).interfaceId ||
924             interfaceId == type(IERC721Metadata).interfaceId ||
925             super.supportsInterface(interfaceId);
926     }
927 
928     /**
929      * @dev See {IERC721-balanceOf}.
930      */
931     function balanceOf(address owner) public view override returns (uint256) {
932         if (owner == address(0)) revert BalanceQueryForZeroAddress();
933         return uint256(_addressData[owner].balance);
934     }
935 
936     /**
937      * Returns the number of tokens minted by `owner`.
938      */
939     function _numberMinted(address owner) internal view returns (uint256) {
940         return uint256(_addressData[owner].numberMinted);
941     }
942 
943     /**
944      * Returns the number of tokens burned by or on behalf of `owner`.
945      */
946     function _numberBurned(address owner) internal view returns (uint256) {
947         return uint256(_addressData[owner].numberBurned);
948     }
949 
950     /**
951      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
952      */
953     function _getAux(address owner) internal view returns (uint64) {
954         return _addressData[owner].aux;
955     }
956 
957     /**
958      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
959      * If there are multiple variables, please pack them into a uint64.
960      */
961     function _setAux(address owner, uint64 aux) internal {
962         _addressData[owner].aux = aux;
963     }
964 
965     /**
966      * Gas spent here starts off proportional to the maximum mint batch size.
967      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
968      */
969     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
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
1000         return _ownershipOf(tokenId).addr;
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
1062     function setApprovalForAll(address operator, bool approved) public virtual override {
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
1121         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1122     }
1123 
1124     function _safeMint(address to, uint256 quantity) internal {
1125         _safeMint(to, quantity, '');
1126     }
1127 
1128     /**
1129      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1130      *
1131      * Requirements:
1132      *
1133      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1134      * - `quantity` must be greater than 0.
1135      *
1136      * Emits a {Transfer} event.
1137      */
1138     function _safeMint(
1139         address to,
1140         uint256 quantity,
1141         bytes memory _data
1142     ) internal {
1143         _mint(to, quantity, _data, true);
1144     }
1145 
1146     /**
1147      * @dev Mints `quantity` tokens and transfers them to `to`.
1148      *
1149      * Requirements:
1150      *
1151      * - `to` cannot be the zero address.
1152      * - `quantity` must be greater than 0.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function _mint(
1157         address to,
1158         uint256 quantity,
1159         bytes memory _data,
1160         bool safe
1161     ) internal {
1162         uint256 startTokenId = _currentIndex;
1163         if (to == address(0)) revert MintToZeroAddress();
1164         if (quantity == 0) revert MintZeroQuantity();
1165 
1166         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1167 
1168         // Overflows are incredibly unrealistic.
1169         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1170         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1171         unchecked {
1172             _addressData[to].balance += uint64(quantity);
1173             _addressData[to].numberMinted += uint64(quantity);
1174 
1175             _ownerships[startTokenId].addr = to;
1176             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1177 
1178             uint256 updatedIndex = startTokenId;
1179             uint256 end = updatedIndex + quantity;
1180 
1181             if (safe && to.isContract()) {
1182                 do {
1183                     emit Transfer(address(0), to, updatedIndex);
1184                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1185                         revert TransferToNonERC721ReceiverImplementer();
1186                     }
1187                 } while (updatedIndex != end);
1188                 // Reentrancy protection
1189                 if (_currentIndex != startTokenId) revert();
1190             } else {
1191                 do {
1192                     emit Transfer(address(0), to, updatedIndex++);
1193                 } while (updatedIndex != end);
1194             }
1195             _currentIndex = updatedIndex;
1196         }
1197         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1198     }
1199 
1200     /**
1201      * @dev Transfers `tokenId` from `from` to `to`.
1202      *
1203      * Requirements:
1204      *
1205      * - `to` cannot be the zero address.
1206      * - `tokenId` token must be owned by `from`.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function _transfer(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) private {
1215         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1216 
1217         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1218 
1219         bool isApprovedOrOwner = (_msgSender() == from ||
1220             isApprovedForAll(from, _msgSender()) ||
1221             getApproved(tokenId) == _msgSender());
1222 
1223         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1224         if (to == address(0)) revert TransferToZeroAddress();
1225 
1226         _beforeTokenTransfers(from, to, tokenId, 1);
1227 
1228         // Clear approvals from the previous owner
1229         _approve(address(0), tokenId, from);
1230 
1231         // Underflow of the sender's balance is impossible because we check for
1232         // ownership above and the recipient's balance can't realistically overflow.
1233         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1234         unchecked {
1235             _addressData[from].balance -= 1;
1236             _addressData[to].balance += 1;
1237 
1238             TokenOwnership storage currSlot = _ownerships[tokenId];
1239             currSlot.addr = to;
1240             currSlot.startTimestamp = uint64(block.timestamp);
1241 
1242             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1243             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1244             uint256 nextTokenId = tokenId + 1;
1245             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1246             if (nextSlot.addr == address(0)) {
1247                 // This will suffice for checking _exists(nextTokenId),
1248                 // as a burned slot cannot contain the zero address.
1249                 if (nextTokenId != _currentIndex) {
1250                     nextSlot.addr = from;
1251                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1252                 }
1253             }
1254         }
1255 
1256         emit Transfer(from, to, tokenId);
1257         _afterTokenTransfers(from, to, tokenId, 1);
1258     }
1259 
1260     /**
1261      * @dev This is equivalent to _burn(tokenId, false)
1262      */
1263     function _burn(uint256 tokenId) internal virtual {
1264         _burn(tokenId, false);
1265     }
1266 
1267     /**
1268      * @dev Destroys `tokenId`.
1269      * The approval is cleared when the token is burned.
1270      *
1271      * Requirements:
1272      *
1273      * - `tokenId` must exist.
1274      *
1275      * Emits a {Transfer} event.
1276      */
1277     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1278         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1279 
1280         address from = prevOwnership.addr;
1281 
1282         if (approvalCheck) {
1283             bool isApprovedOrOwner = (_msgSender() == from ||
1284                 isApprovedForAll(from, _msgSender()) ||
1285                 getApproved(tokenId) == _msgSender());
1286 
1287             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1288         }
1289 
1290         _beforeTokenTransfers(from, address(0), tokenId, 1);
1291 
1292         // Clear approvals from the previous owner
1293         _approve(address(0), tokenId, from);
1294 
1295         // Underflow of the sender's balance is impossible because we check for
1296         // ownership above and the recipient's balance can't realistically overflow.
1297         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1298         unchecked {
1299             AddressData storage addressData = _addressData[from];
1300             addressData.balance -= 1;
1301             addressData.numberBurned += 1;
1302 
1303             // Keep track of who burned the token, and the timestamp of burning.
1304             TokenOwnership storage currSlot = _ownerships[tokenId];
1305             currSlot.addr = from;
1306             currSlot.startTimestamp = uint64(block.timestamp);
1307             currSlot.burned = true;
1308 
1309             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1310             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1311             uint256 nextTokenId = tokenId + 1;
1312             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1313             if (nextSlot.addr == address(0)) {
1314                 // This will suffice for checking _exists(nextTokenId),
1315                 // as a burned slot cannot contain the zero address.
1316                 if (nextTokenId != _currentIndex) {
1317                     nextSlot.addr = from;
1318                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1319                 }
1320             }
1321         }
1322 
1323         emit Transfer(from, address(0), tokenId);
1324         _afterTokenTransfers(from, address(0), tokenId, 1);
1325 
1326         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1327         unchecked {
1328             _burnCounter++;
1329         }
1330     }
1331 
1332     /**
1333      * @dev Approve `to` to operate on `tokenId`
1334      *
1335      * Emits a {Approval} event.
1336      */
1337     function _approve(
1338         address to,
1339         uint256 tokenId,
1340         address owner
1341     ) private {
1342         _tokenApprovals[tokenId] = to;
1343         emit Approval(owner, to, tokenId);
1344     }
1345 
1346     /**
1347      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1348      *
1349      * @param from address representing the previous owner of the given token ID
1350      * @param to target address that will receive the tokens
1351      * @param tokenId uint256 ID of the token to be transferred
1352      * @param _data bytes optional data to send along with the call
1353      * @return bool whether the call correctly returned the expected magic value
1354      */
1355     function _checkContractOnERC721Received(
1356         address from,
1357         address to,
1358         uint256 tokenId,
1359         bytes memory _data
1360     ) private returns (bool) {
1361         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1362             return retval == IERC721Receiver(to).onERC721Received.selector;
1363         } catch (bytes memory reason) {
1364             if (reason.length == 0) {
1365                 revert TransferToNonERC721ReceiverImplementer();
1366             } else {
1367                 assembly {
1368                     revert(add(32, reason), mload(reason))
1369                 }
1370             }
1371         }
1372     }
1373 
1374     /**
1375      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1376      * And also called before burning one token.
1377      *
1378      * startTokenId - the first token id to be transferred
1379      * quantity - the amount to be transferred
1380      *
1381      * Calling conditions:
1382      *
1383      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1384      * transferred to `to`.
1385      * - When `from` is zero, `tokenId` will be minted for `to`.
1386      * - When `to` is zero, `tokenId` will be burned by `from`.
1387      * - `from` and `to` are never both zero.
1388      */
1389     function _beforeTokenTransfers(
1390         address from,
1391         address to,
1392         uint256 startTokenId,
1393         uint256 quantity
1394     ) internal virtual {}
1395 
1396     /**
1397      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1398      * minting.
1399      * And also called after one token has been burned.
1400      *
1401      * startTokenId - the first token id to be transferred
1402      * quantity - the amount to be transferred
1403      *
1404      * Calling conditions:
1405      *
1406      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1407      * transferred to `to`.
1408      * - When `from` is zero, `tokenId` has been minted for `to`.
1409      * - When `to` is zero, `tokenId` has been burned by `from`.
1410      * - `from` and `to` are never both zero.
1411      */
1412     function _afterTokenTransfers(
1413         address from,
1414         address to,
1415         uint256 startTokenId,
1416         uint256 quantity
1417     ) internal virtual {}
1418 }
1419 
1420 // File: OkayJoyfulApeYachtClub.sol
1421 
1422 
1423 
1424 pragma solidity >=0.8.9 <0.9.0;
1425 
1426 
1427 
1428 
1429 
1430 contract OkayJoyfulApeYachtClub is ERC721A, Ownable, ReentrancyGuard {
1431 
1432   using Strings for uint256;
1433 
1434   bytes32 public merkleRoot;
1435   mapping(address => bool) public whitelistClaimed;
1436 
1437   string public uriPrefix = '';
1438   string public uriSuffix = '.json';
1439   string public hiddenMetadataUri;
1440   
1441   uint256 public cost;
1442   uint256 public maxSupply;
1443   uint256 public maxMintAmountPerTx;
1444 
1445   bool public paused = true;
1446   bool public whitelistMintEnabled = false;
1447   bool public revealed = false;
1448 
1449   constructor(
1450     string memory _tokenName,
1451     string memory _tokenSymbol,
1452     uint256 _cost,
1453     uint256 _maxSupply,
1454     uint256 _maxMintAmountPerTx,
1455     string memory _hiddenMetadataUri
1456   ) ERC721A(_tokenName, _tokenSymbol) {
1457     setCost(_cost);
1458     maxSupply = _maxSupply;
1459     setMaxMintAmountPerTx(_maxMintAmountPerTx);
1460     setHiddenMetadataUri(_hiddenMetadataUri);
1461   }
1462 
1463   modifier mintCompliance(uint256 _mintAmount) {
1464     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1465     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1466     _;
1467   }
1468 
1469   modifier mintPriceCompliance(uint256 _mintAmount) {
1470     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1471     _;
1472   }
1473 
1474   function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1475     // Verify whitelist requirements
1476     require(whitelistMintEnabled, 'The whitelist sale is not enabled!');
1477     require(!whitelistClaimed[_msgSender()], 'Address already claimed!');
1478     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1479     require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1480 
1481     whitelistClaimed[_msgSender()] = true;
1482     _safeMint(_msgSender(), _mintAmount);
1483   }
1484 
1485   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1486     require(!paused, 'The contract is paused!');
1487 
1488     _safeMint(_msgSender(), _mintAmount);
1489   }
1490   
1491   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1492     _safeMint(_receiver, _mintAmount);
1493   }
1494 
1495   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1496     uint256 ownerTokenCount = balanceOf(_owner);
1497     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1498     uint256 currentTokenId = _startTokenId();
1499     uint256 ownedTokenIndex = 0;
1500     address latestOwnerAddress;
1501 
1502     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1503       TokenOwnership memory ownership = _ownerships[currentTokenId];
1504 
1505       if (!ownership.burned && ownership.addr != address(0)) {
1506         latestOwnerAddress = ownership.addr;
1507       }
1508 
1509       if (latestOwnerAddress == _owner) {
1510         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1511 
1512         ownedTokenIndex++;
1513       }
1514 
1515       currentTokenId++;
1516     }
1517 
1518     return ownedTokenIds;
1519   }
1520 
1521   function _startTokenId() internal view virtual override returns (uint256) {
1522     return 1;
1523   }
1524 
1525   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1526     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1527 
1528     if (revealed == false) {
1529       return hiddenMetadataUri;
1530     }
1531 
1532     string memory currentBaseURI = _baseURI();
1533     return bytes(currentBaseURI).length > 0
1534         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1535         : '';
1536   }
1537 
1538   function setRevealed(bool _state) public onlyOwner {
1539     revealed = _state;
1540   }
1541 
1542   function setCost(uint256 _cost) public onlyOwner {
1543     cost = _cost;
1544   }
1545 
1546   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1547     maxMintAmountPerTx = _maxMintAmountPerTx;
1548   }
1549 
1550   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1551     hiddenMetadataUri = _hiddenMetadataUri;
1552   }
1553 
1554   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1555     uriPrefix = _uriPrefix;
1556   }
1557 
1558   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1559     uriSuffix = _uriSuffix;
1560   }
1561 
1562   function setPaused(bool _state) public onlyOwner {
1563     paused = _state;
1564   }
1565 
1566   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1567     merkleRoot = _merkleRoot;
1568   }
1569 
1570   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1571     whitelistMintEnabled = _state;
1572   }
1573 
1574   function withdraw() public onlyOwner nonReentrant {
1575     // This will transfer the remaining contract balance to the owner.
1576     // Do not remove this otherwise you will not be able to withdraw the funds.
1577     // =============================================================================
1578     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1579     require(os);
1580     // =============================================================================
1581   }
1582 
1583   function _baseURI() internal view virtual override returns (string memory) {
1584     return uriPrefix;
1585   }
1586 }