1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
71 
72 pragma solidity ^0.8.0;
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
112                 computedHash = _efficientHash(computedHash, proofElement);
113             } else {
114                 // Hash(current element of the proof + current computed hash)
115                 computedHash = _efficientHash(proofElement, computedHash);
116             }
117         }
118         return computedHash;
119     }
120 
121     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
122         assembly {
123             mstore(0x00, a)
124             mstore(0x20, b)
125             value := keccak256(0x00, 0x40)
126         }
127     }
128 }
129 
130 // File: @openzeppelin/contracts/utils/Strings.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev String operations.
139  */
140 library Strings {
141     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
142 
143     /**
144      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
145      */
146     function toString(uint256 value) internal pure returns (string memory) {
147         // Inspired by OraclizeAPI's implementation - MIT licence
148         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
149 
150         if (value == 0) {
151             return "0";
152         }
153         uint256 temp = value;
154         uint256 digits;
155         while (temp != 0) {
156             digits++;
157             temp /= 10;
158         }
159         bytes memory buffer = new bytes(digits);
160         while (value != 0) {
161             digits -= 1;
162             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
163             value /= 10;
164         }
165         return string(buffer);
166     }
167 
168     /**
169      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
170      */
171     function toHexString(uint256 value) internal pure returns (string memory) {
172         if (value == 0) {
173             return "0x00";
174         }
175         uint256 temp = value;
176         uint256 length = 0;
177         while (temp != 0) {
178             length++;
179             temp >>= 8;
180         }
181         return toHexString(value, length);
182     }
183 
184     /**
185      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
186      */
187     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
188         bytes memory buffer = new bytes(2 * length + 2);
189         buffer[0] = "0";
190         buffer[1] = "x";
191         for (uint256 i = 2 * length + 1; i > 1; --i) {
192             buffer[i] = _HEX_SYMBOLS[value & 0xf];
193             value >>= 4;
194         }
195         require(value == 0, "Strings: hex length insufficient");
196         return string(buffer);
197     }
198 }
199 
200 // File: @openzeppelin/contracts/utils/Context.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Provides information about the current execution context, including the
209  * sender of the transaction and its data. While these are generally available
210  * via msg.sender and msg.data, they should not be accessed in such a direct
211  * manner, since when dealing with meta-transactions the account sending and
212  * paying for execution may not be the actual sender (as far as an application
213  * is concerned).
214  *
215  * This contract is only required for intermediate, library-like contracts.
216  */
217 abstract contract Context {
218     function _msgSender() internal view virtual returns (address) {
219         return msg.sender;
220     }
221 
222     function _msgData() internal view virtual returns (bytes calldata) {
223         return msg.data;
224     }
225 }
226 
227 // File: @openzeppelin/contracts/access/Ownable.sol
228 
229 
230 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 
235 /**
236  * @dev Contract module which provides a basic access control mechanism, where
237  * there is an account (an owner) that can be granted exclusive access to
238  * specific functions.
239  *
240  * By default, the owner account will be the one that deploys the contract. This
241  * can later be changed with {transferOwnership}.
242  *
243  * This module is used through inheritance. It will make available the modifier
244  * `onlyOwner`, which can be applied to your functions to restrict their use to
245  * the owner.
246  */
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     /**
253      * @dev Initializes the contract setting the deployer as the initial owner.
254      */
255     constructor() {
256         _transferOwnership(_msgSender());
257     }
258 
259     /**
260      * @dev Returns the address of the current owner.
261      */
262     function owner() public view virtual returns (address) {
263         return _owner;
264     }
265 
266     /**
267      * @dev Throws if called by any account other than the owner.
268      */
269     modifier onlyOwner() {
270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
271         _;
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         _transferOwnership(address(0));
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      * Internal function without access restriction.
297      */
298     function _transferOwnership(address newOwner) internal virtual {
299         address oldOwner = _owner;
300         _owner = newOwner;
301         emit OwnershipTransferred(oldOwner, newOwner);
302     }
303 }
304 
305 // File: @openzeppelin/contracts/utils/Address.sol
306 
307 
308 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
309 
310 pragma solidity ^0.8.0;
311 
312 /**
313  * @dev Collection of functions related to the address type
314  */
315 library Address {
316     /**
317      * @dev Returns true if `account` is a contract.
318      *
319      * [IMPORTANT]
320      * ====
321      * It is unsafe to assume that an address for which this function returns
322      * false is an externally-owned account (EOA) and not a contract.
323      *
324      * Among others, `isContract` will return false for the following
325      * types of addresses:
326      *
327      *  - an externally-owned account
328      *  - a contract in construction
329      *  - an address where a contract will be created
330      *  - an address where a contract lived, but was destroyed
331      * ====
332      */
333     function isContract(address account) internal view returns (bool) {
334         // This method relies on extcodesize, which returns 0 for contracts in
335         // construction, since the code is only stored at the end of the
336         // constructor execution.
337 
338         uint256 size;
339         assembly {
340             size := extcodesize(account)
341         }
342         return size > 0;
343     }
344 
345     /**
346      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
347      * `recipient`, forwarding all available gas and reverting on errors.
348      *
349      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
350      * of certain opcodes, possibly making contracts go over the 2300 gas limit
351      * imposed by `transfer`, making them unable to receive funds via
352      * `transfer`. {sendValue} removes this limitation.
353      *
354      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
355      *
356      * IMPORTANT: because control is transferred to `recipient`, care must be
357      * taken to not create reentrancy vulnerabilities. Consider using
358      * {ReentrancyGuard} or the
359      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
360      */
361     function sendValue(address payable recipient, uint256 amount) internal {
362         require(address(this).balance >= amount, "Address: insufficient balance");
363 
364         (bool success, ) = recipient.call{value: amount}("");
365         require(success, "Address: unable to send value, recipient may have reverted");
366     }
367 
368     /**
369      * @dev Performs a Solidity function call using a low level `call`. A
370      * plain `call` is an unsafe replacement for a function call: use this
371      * function instead.
372      *
373      * If `target` reverts with a revert reason, it is bubbled up by this
374      * function (like regular Solidity function calls).
375      *
376      * Returns the raw returned data. To convert to the expected return value,
377      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
378      *
379      * Requirements:
380      *
381      * - `target` must be a contract.
382      * - calling `target` with `data` must not revert.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
387         return functionCall(target, data, "Address: low-level call failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
392      * `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCall(
397         address target,
398         bytes memory data,
399         string memory errorMessage
400     ) internal returns (bytes memory) {
401         return functionCallWithValue(target, data, 0, errorMessage);
402     }
403 
404     /**
405      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
406      * but also transferring `value` wei to `target`.
407      *
408      * Requirements:
409      *
410      * - the calling contract must have an ETH balance of at least `value`.
411      * - the called Solidity function must be `payable`.
412      *
413      * _Available since v3.1._
414      */
415     function functionCallWithValue(
416         address target,
417         bytes memory data,
418         uint256 value
419     ) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
425      * with `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(
430         address target,
431         bytes memory data,
432         uint256 value,
433         string memory errorMessage
434     ) internal returns (bytes memory) {
435         require(address(this).balance >= value, "Address: insufficient balance for call");
436         require(isContract(target), "Address: call to non-contract");
437 
438         (bool success, bytes memory returndata) = target.call{value: value}(data);
439         return verifyCallResult(success, returndata, errorMessage);
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
449         return functionStaticCall(target, data, "Address: low-level static call failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
454      * but performing a static call.
455      *
456      * _Available since v3.3._
457      */
458     function functionStaticCall(
459         address target,
460         bytes memory data,
461         string memory errorMessage
462     ) internal view returns (bytes memory) {
463         require(isContract(target), "Address: static call to non-contract");
464 
465         (bool success, bytes memory returndata) = target.staticcall(data);
466         return verifyCallResult(success, returndata, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
476         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(
486         address target,
487         bytes memory data,
488         string memory errorMessage
489     ) internal returns (bytes memory) {
490         require(isContract(target), "Address: delegate call to non-contract");
491 
492         (bool success, bytes memory returndata) = target.delegatecall(data);
493         return verifyCallResult(success, returndata, errorMessage);
494     }
495 
496     /**
497      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
498      * revert reason using the provided one.
499      *
500      * _Available since v4.3._
501      */
502     function verifyCallResult(
503         bool success,
504         bytes memory returndata,
505         string memory errorMessage
506     ) internal pure returns (bytes memory) {
507         if (success) {
508             return returndata;
509         } else {
510             // Look for revert reason and bubble it up if present
511             if (returndata.length > 0) {
512                 // The easiest way to bubble the revert reason is using memory via assembly
513 
514                 assembly {
515                     let returndata_size := mload(returndata)
516                     revert(add(32, returndata), returndata_size)
517                 }
518             } else {
519                 revert(errorMessage);
520             }
521         }
522     }
523 }
524 
525 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
526 
527 
528 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
529 
530 pragma solidity ^0.8.0;
531 
532 /**
533  * @title ERC721 token receiver interface
534  * @dev Interface for any contract that wants to support safeTransfers
535  * from ERC721 asset contracts.
536  */
537 interface IERC721Receiver {
538     /**
539      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
540      * by `operator` from `from`, this function is called.
541      *
542      * It must return its Solidity selector to confirm the token transfer.
543      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
544      *
545      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
546      */
547     function onERC721Received(
548         address operator,
549         address from,
550         uint256 tokenId,
551         bytes calldata data
552     ) external returns (bytes4);
553 }
554 
555 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Interface of the ERC165 standard, as defined in the
564  * https://eips.ethereum.org/EIPS/eip-165[EIP].
565  *
566  * Implementers can declare support of contract interfaces, which can then be
567  * queried by others ({ERC165Checker}).
568  *
569  * For an implementation, see {ERC165}.
570  */
571 interface IERC165 {
572     /**
573      * @dev Returns true if this contract implements the interface defined by
574      * `interfaceId`. See the corresponding
575      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
576      * to learn more about how these ids are created.
577      *
578      * This function call must use less than 30 000 gas.
579      */
580     function supportsInterface(bytes4 interfaceId) external view returns (bool);
581 }
582 
583 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Implementation of the {IERC165} interface.
593  *
594  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
595  * for the additional interface id that will be supported. For example:
596  *
597  * ```solidity
598  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
599  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
600  * }
601  * ```
602  *
603  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
604  */
605 abstract contract ERC165 is IERC165 {
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
610         return interfaceId == type(IERC165).interfaceId;
611     }
612 }
613 
614 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
615 
616 
617 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 
622 /**
623  * @dev Required interface of an ERC721 compliant contract.
624  */
625 interface IERC721 is IERC165 {
626     /**
627      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
628      */
629     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
630 
631     /**
632      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
633      */
634     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
635 
636     /**
637      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
638      */
639     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
640 
641     /**
642      * @dev Returns the number of tokens in ``owner``'s account.
643      */
644     function balanceOf(address owner) external view returns (uint256 balance);
645 
646     /**
647      * @dev Returns the owner of the `tokenId` token.
648      *
649      * Requirements:
650      *
651      * - `tokenId` must exist.
652      */
653     function ownerOf(uint256 tokenId) external view returns (address owner);
654 
655     /**
656      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
657      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
658      *
659      * Requirements:
660      *
661      * - `from` cannot be the zero address.
662      * - `to` cannot be the zero address.
663      * - `tokenId` token must exist and be owned by `from`.
664      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
665      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
666      *
667      * Emits a {Transfer} event.
668      */
669     function safeTransferFrom(
670         address from,
671         address to,
672         uint256 tokenId
673     ) external;
674 
675     /**
676      * @dev Transfers `tokenId` token from `from` to `to`.
677      *
678      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must be owned by `from`.
685      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
686      *
687      * Emits a {Transfer} event.
688      */
689     function transferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) external;
694 
695     /**
696      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
697      * The approval is cleared when the token is transferred.
698      *
699      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
700      *
701      * Requirements:
702      *
703      * - The caller must own the token or be an approved operator.
704      * - `tokenId` must exist.
705      *
706      * Emits an {Approval} event.
707      */
708     function approve(address to, uint256 tokenId) external;
709 
710     /**
711      * @dev Returns the account approved for `tokenId` token.
712      *
713      * Requirements:
714      *
715      * - `tokenId` must exist.
716      */
717     function getApproved(uint256 tokenId) external view returns (address operator);
718 
719     /**
720      * @dev Approve or remove `operator` as an operator for the caller.
721      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
722      *
723      * Requirements:
724      *
725      * - The `operator` cannot be the caller.
726      *
727      * Emits an {ApprovalForAll} event.
728      */
729     function setApprovalForAll(address operator, bool _approved) external;
730 
731     /**
732      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
733      *
734      * See {setApprovalForAll}
735      */
736     function isApprovedForAll(address owner, address operator) external view returns (bool);
737 
738     /**
739      * @dev Safely transfers `tokenId` token from `from` to `to`.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must exist and be owned by `from`.
746      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
747      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
748      *
749      * Emits a {Transfer} event.
750      */
751     function safeTransferFrom(
752         address from,
753         address to,
754         uint256 tokenId,
755         bytes calldata data
756     ) external;
757 }
758 
759 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
760 
761 
762 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
763 
764 pragma solidity ^0.8.0;
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
788 // File: erc721a/contracts/ERC721A.sol
789 
790 
791 // Creator: Chiru Labs
792 
793 pragma solidity ^0.8.4;
794 
795 
796 
797 
798 
799 
800 
801 
802 error ApprovalCallerNotOwnerNorApproved();
803 error ApprovalQueryForNonexistentToken();
804 error ApproveToCaller();
805 error ApprovalToCurrentOwner();
806 error BalanceQueryForZeroAddress();
807 error MintToZeroAddress();
808 error MintZeroQuantity();
809 error OwnerQueryForNonexistentToken();
810 error TransferCallerNotOwnerNorApproved();
811 error TransferFromIncorrectOwner();
812 error TransferToNonERC721ReceiverImplementer();
813 error TransferToZeroAddress();
814 error URIQueryForNonexistentToken();
815 
816 /**
817  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
818  * the Metadata extension. Built to optimize for lower gas during batch mints.
819  *
820  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
821  *
822  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
823  *
824  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
825  */
826 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
827     using Address for address;
828     using Strings for uint256;
829 
830     // Compiler will pack this into a single 256bit word.
831     struct TokenOwnership {
832         // The address of the owner.
833         address addr;
834         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
835         uint64 startTimestamp;
836         // Whether the token has been burned.
837         bool burned;
838     }
839 
840     // Compiler will pack this into a single 256bit word.
841     struct AddressData {
842         // Realistically, 2**64-1 is more than enough.
843         uint64 balance;
844         // Keeps track of mint count with minimal overhead for tokenomics.
845         uint64 numberMinted;
846         // Keeps track of burn count with minimal overhead for tokenomics.
847         uint64 numberBurned;
848         // For miscellaneous variable(s) pertaining to the address
849         // (e.g. number of whitelist mint slots used).
850         // If there are multiple variables, please pack them into a uint64.
851         uint64 aux;
852     }
853 
854     // The tokenId of the next token to be minted.
855     uint256 internal _currentIndex;
856 
857     // The number of tokens burned.
858     uint256 internal _burnCounter;
859 
860     // Token name
861     string private _name;
862 
863     // Token symbol
864     string private _symbol;
865 
866     // Mapping from token ID to ownership details
867     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
868     mapping(uint256 => TokenOwnership) internal _ownerships;
869 
870     // Mapping owner address to address data
871     mapping(address => AddressData) private _addressData;
872 
873     // Mapping from token ID to approved address
874     mapping(uint256 => address) private _tokenApprovals;
875 
876     // Mapping from owner to operator approvals
877     mapping(address => mapping(address => bool)) private _operatorApprovals;
878 
879     constructor(string memory name_, string memory symbol_) {
880         _name = name_;
881         _symbol = symbol_;
882         _currentIndex = _startTokenId();
883     }
884 
885     /**
886      * To change the starting tokenId, please override this function.
887      */
888     function _startTokenId() internal view virtual returns (uint256) {
889         return 0;
890     }
891 
892     /**
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
936         return uint256(_addressData[owner].numberMinted);
937     }
938 
939     /**
940      * Returns the number of tokens burned by or on behalf of `owner`.
941      */
942     function _numberBurned(address owner) internal view returns (uint256) {
943         return uint256(_addressData[owner].numberBurned);
944     }
945 
946     /**
947      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
948      */
949     function _getAux(address owner) internal view returns (uint64) {
950         return _addressData[owner].aux;
951     }
952 
953     /**
954      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
955      * If there are multiple variables, please pack them into a uint64.
956      */
957     function _setAux(address owner, uint64 aux) internal {
958         _addressData[owner].aux = aux;
959     }
960 
961     /**
962      * Gas spent here starts off proportional to the maximum mint batch size.
963      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
964      */
965     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
966         uint256 curr = tokenId;
967 
968         unchecked {
969             if (_startTokenId() <= curr && curr < _currentIndex) {
970                 TokenOwnership memory ownership = _ownerships[curr];
971                 if (!ownership.burned) {
972                     if (ownership.addr != address(0)) {
973                         return ownership;
974                     }
975                     // Invariant:
976                     // There will always be an ownership that has an address and is not burned
977                     // before an ownership that does not have an address and is not burned.
978                     // Hence, curr will not underflow.
979                     while (true) {
980                         curr--;
981                         ownership = _ownerships[curr];
982                         if (ownership.addr != address(0)) {
983                             return ownership;
984                         }
985                     }
986                 }
987             }
988         }
989         revert OwnerQueryForNonexistentToken();
990     }
991 
992     /**
993      * @dev See {IERC721-ownerOf}.
994      */
995     function ownerOf(uint256 tokenId) public view override returns (address) {
996         return _ownershipOf(tokenId).addr;
997     }
998 
999     /**
1000      * @dev See {IERC721Metadata-name}.
1001      */
1002     function name() public view virtual override returns (string memory) {
1003         return _name;
1004     }
1005 
1006     /**
1007      * @dev See {IERC721Metadata-symbol}.
1008      */
1009     function symbol() public view virtual override returns (string memory) {
1010         return _symbol;
1011     }
1012 
1013     /**
1014      * @dev See {IERC721Metadata-tokenURI}.
1015      */
1016     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1017         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1018 
1019         string memory baseURI = _baseURI();
1020         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1021     }
1022 
1023     /**
1024      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1025      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1026      * by default, can be overriden in child contracts.
1027      */
1028     function _baseURI() internal view virtual returns (string memory) {
1029         return '';
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-approve}.
1034      */
1035     function approve(address to, uint256 tokenId) public override {
1036         address owner = ERC721A.ownerOf(tokenId);
1037         if (to == owner) revert ApprovalToCurrentOwner();
1038 
1039         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1040             revert ApprovalCallerNotOwnerNorApproved();
1041         }
1042 
1043         _approve(to, tokenId, owner);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-getApproved}.
1048      */
1049     function getApproved(uint256 tokenId) public view override returns (address) {
1050         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1051 
1052         return _tokenApprovals[tokenId];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-setApprovalForAll}.
1057      */
1058     function setApprovalForAll(address operator, bool approved) public virtual override {
1059         if (operator == _msgSender()) revert ApproveToCaller();
1060 
1061         _operatorApprovals[_msgSender()][operator] = approved;
1062         emit ApprovalForAll(_msgSender(), operator, approved);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-isApprovedForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public virtual override {
1080         _transfer(from, to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-safeTransferFrom}.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) public virtual override {
1091         safeTransferFrom(from, to, tokenId, '');
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-safeTransferFrom}.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) public virtual override {
1103         _transfer(from, to, tokenId);
1104         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1105             revert TransferToNonERC721ReceiverImplementer();
1106         }
1107     }
1108 
1109     /**
1110      * @dev Returns whether `tokenId` exists.
1111      *
1112      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1113      *
1114      * Tokens start existing when they are minted (`_mint`),
1115      */
1116     function _exists(uint256 tokenId) internal view returns (bool) {
1117         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1118             !_ownerships[tokenId].burned;
1119     }
1120 
1121     function _safeMint(address to, uint256 quantity) internal {
1122         _safeMint(to, quantity, '');
1123     }
1124 
1125     /**
1126      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1127      *
1128      * Requirements:
1129      *
1130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1131      * - `quantity` must be greater than 0.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _safeMint(
1136         address to,
1137         uint256 quantity,
1138         bytes memory _data
1139     ) internal {
1140         _mint(to, quantity, _data, true);
1141     }
1142 
1143     /**
1144      * @dev Mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _mint(
1154         address to,
1155         uint256 quantity,
1156         bytes memory _data,
1157         bool safe
1158     ) internal {
1159         uint256 startTokenId = _currentIndex;
1160         if (to == address(0)) revert MintToZeroAddress();
1161         if (quantity == 0) revert MintZeroQuantity();
1162 
1163         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1164 
1165         // Overflows are incredibly unrealistic.
1166         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1167         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1168         unchecked {
1169             _addressData[to].balance += uint64(quantity);
1170             _addressData[to].numberMinted += uint64(quantity);
1171 
1172             _ownerships[startTokenId].addr = to;
1173             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1174 
1175             uint256 updatedIndex = startTokenId;
1176             uint256 end = updatedIndex + quantity;
1177 
1178             if (safe && to.isContract()) {
1179                 do {
1180                     emit Transfer(address(0), to, updatedIndex);
1181                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1182                         revert TransferToNonERC721ReceiverImplementer();
1183                     }
1184                 } while (updatedIndex != end);
1185                 // Reentrancy protection
1186                 if (_currentIndex != startTokenId) revert();
1187             } else {
1188                 do {
1189                     emit Transfer(address(0), to, updatedIndex++);
1190                 } while (updatedIndex != end);
1191             }
1192             _currentIndex = updatedIndex;
1193         }
1194         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1195     }
1196 
1197     /**
1198      * @dev Transfers `tokenId` from `from` to `to`.
1199      *
1200      * Requirements:
1201      *
1202      * - `to` cannot be the zero address.
1203      * - `tokenId` token must be owned by `from`.
1204      *
1205      * Emits a {Transfer} event.
1206      */
1207     function _transfer(
1208         address from,
1209         address to,
1210         uint256 tokenId
1211     ) private {
1212         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1213 
1214         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1215 
1216         bool isApprovedOrOwner = (_msgSender() == from ||
1217             isApprovedForAll(from, _msgSender()) ||
1218             getApproved(tokenId) == _msgSender());
1219 
1220         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1221         if (to == address(0)) revert TransferToZeroAddress();
1222 
1223         _beforeTokenTransfers(from, to, tokenId, 1);
1224 
1225         // Clear approvals from the previous owner
1226         _approve(address(0), tokenId, from);
1227 
1228         // Underflow of the sender's balance is impossible because we check for
1229         // ownership above and the recipient's balance can't realistically overflow.
1230         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1231         unchecked {
1232             _addressData[from].balance -= 1;
1233             _addressData[to].balance += 1;
1234 
1235             TokenOwnership storage currSlot = _ownerships[tokenId];
1236             currSlot.addr = to;
1237             currSlot.startTimestamp = uint64(block.timestamp);
1238 
1239             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1240             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1241             uint256 nextTokenId = tokenId + 1;
1242             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1243             if (nextSlot.addr == address(0)) {
1244                 // This will suffice for checking _exists(nextTokenId),
1245                 // as a burned slot cannot contain the zero address.
1246                 if (nextTokenId != _currentIndex) {
1247                     nextSlot.addr = from;
1248                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1249                 }
1250             }
1251         }
1252 
1253         emit Transfer(from, to, tokenId);
1254         _afterTokenTransfers(from, to, tokenId, 1);
1255     }
1256 
1257     /**
1258      * @dev This is equivalent to _burn(tokenId, false)
1259      */
1260     function _burn(uint256 tokenId) internal virtual {
1261         _burn(tokenId, false);
1262     }
1263 
1264     /**
1265      * @dev Destroys `tokenId`.
1266      * The approval is cleared when the token is burned.
1267      *
1268      * Requirements:
1269      *
1270      * - `tokenId` must exist.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1275         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1276 
1277         address from = prevOwnership.addr;
1278 
1279         if (approvalCheck) {
1280             bool isApprovedOrOwner = (_msgSender() == from ||
1281                 isApprovedForAll(from, _msgSender()) ||
1282                 getApproved(tokenId) == _msgSender());
1283 
1284             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1285         }
1286 
1287         _beforeTokenTransfers(from, address(0), tokenId, 1);
1288 
1289         // Clear approvals from the previous owner
1290         _approve(address(0), tokenId, from);
1291 
1292         // Underflow of the sender's balance is impossible because we check for
1293         // ownership above and the recipient's balance can't realistically overflow.
1294         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1295         unchecked {
1296             AddressData storage addressData = _addressData[from];
1297             addressData.balance -= 1;
1298             addressData.numberBurned += 1;
1299 
1300             // Keep track of who burned the token, and the timestamp of burning.
1301             TokenOwnership storage currSlot = _ownerships[tokenId];
1302             currSlot.addr = from;
1303             currSlot.startTimestamp = uint64(block.timestamp);
1304             currSlot.burned = true;
1305 
1306             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1307             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1308             uint256 nextTokenId = tokenId + 1;
1309             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1310             if (nextSlot.addr == address(0)) {
1311                 // This will suffice for checking _exists(nextTokenId),
1312                 // as a burned slot cannot contain the zero address.
1313                 if (nextTokenId != _currentIndex) {
1314                     nextSlot.addr = from;
1315                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1316                 }
1317             }
1318         }
1319 
1320         emit Transfer(from, address(0), tokenId);
1321         _afterTokenTransfers(from, address(0), tokenId, 1);
1322 
1323         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1324         unchecked {
1325             _burnCounter++;
1326         }
1327     }
1328 
1329     /**
1330      * @dev Approve `to` to operate on `tokenId`
1331      *
1332      * Emits a {Approval} event.
1333      */
1334     function _approve(
1335         address to,
1336         uint256 tokenId,
1337         address owner
1338     ) private {
1339         _tokenApprovals[tokenId] = to;
1340         emit Approval(owner, to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1345      *
1346      * @param from address representing the previous owner of the given token ID
1347      * @param to target address that will receive the tokens
1348      * @param tokenId uint256 ID of the token to be transferred
1349      * @param _data bytes optional data to send along with the call
1350      * @return bool whether the call correctly returned the expected magic value
1351      */
1352     function _checkContractOnERC721Received(
1353         address from,
1354         address to,
1355         uint256 tokenId,
1356         bytes memory _data
1357     ) private returns (bool) {
1358         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1359             return retval == IERC721Receiver(to).onERC721Received.selector;
1360         } catch (bytes memory reason) {
1361             if (reason.length == 0) {
1362                 revert TransferToNonERC721ReceiverImplementer();
1363             } else {
1364                 assembly {
1365                     revert(add(32, reason), mload(reason))
1366                 }
1367             }
1368         }
1369     }
1370 
1371     /**
1372      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1373      * And also called before burning one token.
1374      *
1375      * startTokenId - the first token id to be transferred
1376      * quantity - the amount to be transferred
1377      *
1378      * Calling conditions:
1379      *
1380      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1381      * transferred to `to`.
1382      * - When `from` is zero, `tokenId` will be minted for `to`.
1383      * - When `to` is zero, `tokenId` will be burned by `from`.
1384      * - `from` and `to` are never both zero.
1385      */
1386     function _beforeTokenTransfers(
1387         address from,
1388         address to,
1389         uint256 startTokenId,
1390         uint256 quantity
1391     ) internal virtual {}
1392 
1393     /**
1394      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1395      * minting.
1396      * And also called after one token has been burned.
1397      *
1398      * startTokenId - the first token id to be transferred
1399      * quantity - the amount to be transferred
1400      *
1401      * Calling conditions:
1402      *
1403      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1404      * transferred to `to`.
1405      * - When `from` is zero, `tokenId` has been minted for `to`.
1406      * - When `to` is zero, `tokenId` has been burned by `from`.
1407      * - `from` and `to` are never both zero.
1408      */
1409     function _afterTokenTransfers(
1410         address from,
1411         address to,
1412         uint256 startTokenId,
1413         uint256 quantity
1414     ) internal virtual {}
1415 }
1416 
1417 // File: InvisibleGirlfriends.sol
1418 
1419 
1420 // Invisible Girlfriends
1421 pragma solidity ^0.8.13;
1422 
1423 /*
1424                               ..............
1425                         ..::....          ....::..
1426                     ..::..                        ::..
1427                   ::..                              ..--..
1428                 ::..                  ....::..............::::..
1429               ::                ..::::..                      ..::..
1430             ....            ::::..                                ::::
1431             ..        ..::..                                        ..::
1432           ::      ..::..                                              ....
1433         ....  ..::::                                                    ::
1434         ::  ..  ..                                                        ::
1435         ....    ::                                ....::::::::::..        ::
1436         --::......                    ..::==--::::....          ..::..    ....
1437       ::::  ..                  ..--..  ==@@++                      ::      ..
1438       ::                    ..------      ++..                        ..    ..
1439     ::                  ..::--------::  ::..    ::------..            ::::==++--..
1440   ....                ::----------------    ..**%%##****##==        --######++**##==
1441   ..              ::----------------..    ..####++..    --**++    ::####++::    --##==
1442 ....          ..----------------..        **##**          --##--::**##++..        --##::
1443 ..        ..--------------++==----------**####--          ..**++..::##++----::::::::****
1444 ..    ::==------------++##############%%######..            ++**    **++++++------==**##
1445 ::  ::------------++**::..............::**####..            ++**..::##..          ..++##
1446 ::....::--------++##..                  ::####::          ::****++####..          ..**++
1447 ..::  ::--==--==%%--                      **##++        ..--##++::####==          --##--
1448   ::..::----  ::==                        --####--..    ::**##..  ==%%##::      ::****
1449   ::      ::                                **####++--==####::      **%%##==--==####::
1450     ::    ..::..                    ....::::..--########++..          ==**######++..
1451       ::      ..::::::::::::::::::....      ..::::....                    ....
1452         ::::..                      ....::....
1453             ..::::::::::::::::::::....
1454 
1455 */
1456 
1457 
1458 
1459 
1460 
1461 
1462 contract InvisibleGirlfriends is ERC721A, Ownable, ReentrancyGuard {
1463   using Strings for uint256;
1464 
1465   bool public reveal = false;
1466   uint256 public cost = 0.065 ether;
1467   uint256 public max_supply = 5000;
1468   string public baseURI;
1469   string public revealURI;
1470 
1471   mapping(address => uint256) public wallet_minted;
1472   
1473   constructor() ERC721A("Invisible Girlfriends", "INVSBLEG") {}
1474 
1475   function purchase(uint256 _token_amount) external payable nonReentrant {
1476     require(msg.value >= cost * _token_amount, "insufficient_funds");
1477     uint256 supply = totalSupply();
1478     require(_token_amount > 0, "quantity_is_required");
1479     require(_token_amount + supply <= max_supply, "max_supply_exceedeed" );
1480 
1481     wallet_minted[msg.sender] += _token_amount;
1482     _safeMint(msg.sender, _token_amount);
1483   }
1484 
1485   /* token return */
1486   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1487     require(_exists(_tokenId), "non_existant_token");
1488     if (reveal) {
1489       return string(abi.encodePacked(baseURI, _tokenId.toString()));
1490     } else {
1491       return revealURI;
1492     }
1493   }
1494 
1495   /* functions */
1496   function set_base_uri(string memory _new_base_uri) public onlyOwner {
1497     baseURI = _new_base_uri;
1498   }
1499 
1500   function set_reveal_uri(string memory _new_reveal_uri) public onlyOwner {
1501     revealURI = _new_reveal_uri;
1502   }
1503 
1504   function set_reveal(bool _new_reveal) public onlyOwner {
1505     reveal = _new_reveal;
1506   }
1507 
1508   function set_max_supply(uint256 _new_max_supply) public onlyOwner {
1509     max_supply = _new_max_supply;
1510   }
1511 
1512   function set_cost(uint256 _new_cost) public onlyOwner {
1513     cost = _new_cost;
1514   }
1515 
1516   /* withdraw */
1517   function withdraw() public payable onlyOwner {
1518     uint256 balance = address(this).balance;
1519     payable(0xa9cd5bF11DB920165Fc0c5b9Ff82dCA9242873a6).transfer(balance);
1520   }
1521 }