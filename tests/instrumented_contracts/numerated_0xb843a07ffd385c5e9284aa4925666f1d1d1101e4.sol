1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
7 
8 pragma solidity ^0.8.0;
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
72 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev These functions deal with verification of Merkle Trees proofs.
78  *
79  * The proofs can be generated using the JavaScript library
80  * https://github.com/miguelmota/merkletreejs[merkletreejs].
81  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
82  *
83  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
84  *
85  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
86  * hashing, or use a hash function other than keccak256 for hashing leaves.
87  * This is because the concatenation of a sorted pair of internal nodes in
88  * the merkle tree could be reinterpreted as a leaf value.
89  */
90 library MerkleProof {
91     /**
92      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
93      * defined by `root`. For this, a `proof` must be provided, containing
94      * sibling hashes on the branch from the leaf to the root of the tree. Each
95      * pair of leaves and each pair of pre-images are assumed to be sorted.
96      */
97     function verify(
98         bytes32[] memory proof,
99         bytes32 root,
100         bytes32 leaf
101     ) internal pure returns (bool) {
102         return processProof(proof, leaf) == root;
103     }
104 
105     /**
106      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
107      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
108      * hash matches the root of the tree. When processing the proof, the pairs
109      * of leafs & pre-images are assumed to be sorted.
110      *
111      * _Available since v4.4._
112      */
113     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
114         bytes32 computedHash = leaf;
115         for (uint256 i = 0; i < proof.length; i++) {
116             bytes32 proofElement = proof[i];
117             if (computedHash <= proofElement) {
118                 // Hash(current computed hash + current element of the proof)
119                 computedHash = _efficientHash(computedHash, proofElement);
120             } else {
121                 // Hash(current element of the proof + current computed hash)
122                 computedHash = _efficientHash(proofElement, computedHash);
123             }
124         }
125         return computedHash;
126     }
127 
128     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
129         assembly {
130             mstore(0x00, a)
131             mstore(0x20, b)
132             value := keccak256(0x00, 0x40)
133         }
134     }
135 }
136 
137 // File: @openzeppelin/contracts/utils/Strings.sol
138 
139 
140 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
141 
142 pragma solidity ^0.8.0;
143 
144 /**
145  * @dev String operations.
146  */
147 library Strings {
148     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
149 
150     /**
151      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
152      */
153     function toString(uint256 value) internal pure returns (string memory) {
154         // Inspired by OraclizeAPI's implementation - MIT licence
155         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
156 
157         if (value == 0) {
158             return "0";
159         }
160         uint256 temp = value;
161         uint256 digits;
162         while (temp != 0) {
163             digits++;
164             temp /= 10;
165         }
166         bytes memory buffer = new bytes(digits);
167         while (value != 0) {
168             digits -= 1;
169             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
170             value /= 10;
171         }
172         return string(buffer);
173     }
174 
175     /**
176      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
177      */
178     function toHexString(uint256 value) internal pure returns (string memory) {
179         if (value == 0) {
180             return "0x00";
181         }
182         uint256 temp = value;
183         uint256 length = 0;
184         while (temp != 0) {
185             length++;
186             temp >>= 8;
187         }
188         return toHexString(value, length);
189     }
190 
191     /**
192      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
193      */
194     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
195         bytes memory buffer = new bytes(2 * length + 2);
196         buffer[0] = "0";
197         buffer[1] = "x";
198         for (uint256 i = 2 * length + 1; i > 1; --i) {
199             buffer[i] = _HEX_SYMBOLS[value & 0xf];
200             value >>= 4;
201         }
202         require(value == 0, "Strings: hex length insufficient");
203         return string(buffer);
204     }
205 }
206 
207 // File: @openzeppelin/contracts/utils/Context.sol
208 
209 
210 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
211 
212 pragma solidity ^0.8.0;
213 
214 /**
215  * @dev Provides information about the current execution context, including the
216  * sender of the transaction and its data. While these are generally available
217  * via msg.sender and msg.data, they should not be accessed in such a direct
218  * manner, since when dealing with meta-transactions the account sending and
219  * paying for execution may not be the actual sender (as far as an application
220  * is concerned).
221  *
222  * This contract is only required for intermediate, library-like contracts.
223  */
224 abstract contract Context {
225     function _msgSender() internal view virtual returns (address) {
226         return msg.sender;
227     }
228 
229     function _msgData() internal view virtual returns (bytes calldata) {
230         return msg.data;
231     }
232 }
233 
234 // File: @openzeppelin/contracts/access/Ownable.sol
235 
236 
237 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
238 
239 pragma solidity ^0.8.0;
240 
241 
242 /**
243  * @dev Contract module which provides a basic access control mechanism, where
244  * there is an account (an owner) that can be granted exclusive access to
245  * specific functions.
246  *
247  * By default, the owner account will be the one that deploys the contract. This
248  * can later be changed with {transferOwnership}.
249  *
250  * This module is used through inheritance. It will make available the modifier
251  * `onlyOwner`, which can be applied to your functions to restrict their use to
252  * the owner.
253  */
254 abstract contract Ownable is Context {
255     address private _owner;
256 
257     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
258 
259     /**
260      * @dev Initializes the contract setting the deployer as the initial owner.
261      */
262     constructor() {
263         _transferOwnership(_msgSender());
264     }
265 
266     /**
267      * @dev Returns the address of the current owner.
268      */
269     function owner() public view virtual returns (address) {
270         return _owner;
271     }
272 
273     /**
274      * @dev Throws if called by any account other than the owner.
275      */
276     modifier onlyOwner() {
277         require(owner() == _msgSender(), "Ownable: caller is not the owner");
278         _;
279     }
280 
281     /**
282      * @dev Leaves the contract without owner. It will not be possible to call
283      * `onlyOwner` functions anymore. Can only be called by the current owner.
284      *
285      * NOTE: Renouncing ownership will leave the contract without an owner,
286      * thereby removing any functionality that is only available to the owner.
287      */
288     function renounceOwnership() public virtual onlyOwner {
289         _transferOwnership(address(0));
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Can only be called by the current owner.
295      */
296     function transferOwnership(address newOwner) public virtual onlyOwner {
297         require(newOwner != address(0), "Ownable: new owner is the zero address");
298         _transferOwnership(newOwner);
299     }
300 
301     /**
302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
303      * Internal function without access restriction.
304      */
305     function _transferOwnership(address newOwner) internal virtual {
306         address oldOwner = _owner;
307         _owner = newOwner;
308         emit OwnershipTransferred(oldOwner, newOwner);
309     }
310 }
311 
312 // File: @openzeppelin/contracts/utils/Address.sol
313 
314 
315 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
316 
317 pragma solidity ^0.8.1;
318 
319 /**
320  * @dev Collection of functions related to the address type
321  */
322 library Address {
323     /**
324      * @dev Returns true if `account` is a contract.
325      *
326      * [IMPORTANT]
327      * ====
328      * It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      *
331      * Among others, `isContract` will return false for the following
332      * types of addresses:
333      *
334      *  - an externally-owned account
335      *  - a contract in construction
336      *  - an address where a contract will be created
337      *  - an address where a contract lived, but was destroyed
338      * ====
339      *
340      * [IMPORTANT]
341      * ====
342      * You shouldn't rely on `isContract` to protect against flash loan attacks!
343      *
344      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
345      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
346      * constructor.
347      * ====
348      */
349     function isContract(address account) internal view returns (bool) {
350         // This method relies on extcodesize/address.code.length, which returns 0
351         // for contracts in construction, since the code is only stored at the end
352         // of the constructor execution.
353 
354         return account.code.length > 0;
355     }
356 
357     /**
358      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
359      * `recipient`, forwarding all available gas and reverting on errors.
360      *
361      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
362      * of certain opcodes, possibly making contracts go over the 2300 gas limit
363      * imposed by `transfer`, making them unable to receive funds via
364      * `transfer`. {sendValue} removes this limitation.
365      *
366      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
367      *
368      * IMPORTANT: because control is transferred to `recipient`, care must be
369      * taken to not create reentrancy vulnerabilities. Consider using
370      * {ReentrancyGuard} or the
371      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
372      */
373     function sendValue(address payable recipient, uint256 amount) internal {
374         require(address(this).balance >= amount, "Address: insufficient balance");
375 
376         (bool success, ) = recipient.call{value: amount}("");
377         require(success, "Address: unable to send value, recipient may have reverted");
378     }
379 
380     /**
381      * @dev Performs a Solidity function call using a low level `call`. A
382      * plain `call` is an unsafe replacement for a function call: use this
383      * function instead.
384      *
385      * If `target` reverts with a revert reason, it is bubbled up by this
386      * function (like regular Solidity function calls).
387      *
388      * Returns the raw returned data. To convert to the expected return value,
389      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
390      *
391      * Requirements:
392      *
393      * - `target` must be a contract.
394      * - calling `target` with `data` must not revert.
395      *
396      * _Available since v3.1._
397      */
398     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
399         return functionCall(target, data, "Address: low-level call failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
404      * `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCall(
409         address target,
410         bytes memory data,
411         string memory errorMessage
412     ) internal returns (bytes memory) {
413         return functionCallWithValue(target, data, 0, errorMessage);
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
418      * but also transferring `value` wei to `target`.
419      *
420      * Requirements:
421      *
422      * - the calling contract must have an ETH balance of at least `value`.
423      * - the called Solidity function must be `payable`.
424      *
425      * _Available since v3.1._
426      */
427     function functionCallWithValue(
428         address target,
429         bytes memory data,
430         uint256 value
431     ) internal returns (bytes memory) {
432         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
433     }
434 
435     /**
436      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
437      * with `errorMessage` as a fallback revert reason when `target` reverts.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(
442         address target,
443         bytes memory data,
444         uint256 value,
445         string memory errorMessage
446     ) internal returns (bytes memory) {
447         require(address(this).balance >= value, "Address: insufficient balance for call");
448         require(isContract(target), "Address: call to non-contract");
449 
450         (bool success, bytes memory returndata) = target.call{value: value}(data);
451         return verifyCallResult(success, returndata, errorMessage);
452     }
453 
454     /**
455      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
456      * but performing a static call.
457      *
458      * _Available since v3.3._
459      */
460     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
461         return functionStaticCall(target, data, "Address: low-level static call failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
466      * but performing a static call.
467      *
468      * _Available since v3.3._
469      */
470     function functionStaticCall(
471         address target,
472         bytes memory data,
473         string memory errorMessage
474     ) internal view returns (bytes memory) {
475         require(isContract(target), "Address: static call to non-contract");
476 
477         (bool success, bytes memory returndata) = target.staticcall(data);
478         return verifyCallResult(success, returndata, errorMessage);
479     }
480 
481     /**
482      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
483      * but performing a delegate call.
484      *
485      * _Available since v3.4._
486      */
487     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
488         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
489     }
490 
491     /**
492      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
493      * but performing a delegate call.
494      *
495      * _Available since v3.4._
496      */
497     function functionDelegateCall(
498         address target,
499         bytes memory data,
500         string memory errorMessage
501     ) internal returns (bytes memory) {
502         require(isContract(target), "Address: delegate call to non-contract");
503 
504         (bool success, bytes memory returndata) = target.delegatecall(data);
505         return verifyCallResult(success, returndata, errorMessage);
506     }
507 
508     /**
509      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
510      * revert reason using the provided one.
511      *
512      * _Available since v4.3._
513      */
514     function verifyCallResult(
515         bool success,
516         bytes memory returndata,
517         string memory errorMessage
518     ) internal pure returns (bytes memory) {
519         if (success) {
520             return returndata;
521         } else {
522             // Look for revert reason and bubble it up if present
523             if (returndata.length > 0) {
524                 // The easiest way to bubble the revert reason is using memory via assembly
525 
526                 assembly {
527                     let returndata_size := mload(returndata)
528                     revert(add(32, returndata), returndata_size)
529                 }
530             } else {
531                 revert(errorMessage);
532             }
533         }
534     }
535 }
536 
537 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
538 
539 
540 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 /**
545  * @title ERC721 token receiver interface
546  * @dev Interface for any contract that wants to support safeTransfers
547  * from ERC721 asset contracts.
548  */
549 interface IERC721Receiver {
550     /**
551      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
552      * by `operator` from `from`, this function is called.
553      *
554      * It must return its Solidity selector to confirm the token transfer.
555      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
556      *
557      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
558      */
559     function onERC721Received(
560         address operator,
561         address from,
562         uint256 tokenId,
563         bytes calldata data
564     ) external returns (bytes4);
565 }
566 
567 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
568 
569 
570 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
571 
572 pragma solidity ^0.8.0;
573 
574 /**
575  * @dev Interface of the ERC165 standard, as defined in the
576  * https://eips.ethereum.org/EIPS/eip-165[EIP].
577  *
578  * Implementers can declare support of contract interfaces, which can then be
579  * queried by others ({ERC165Checker}).
580  *
581  * For an implementation, see {ERC165}.
582  */
583 interface IERC165 {
584     /**
585      * @dev Returns true if this contract implements the interface defined by
586      * `interfaceId`. See the corresponding
587      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
588      * to learn more about how these ids are created.
589      *
590      * This function call must use less than 30 000 gas.
591      */
592     function supportsInterface(bytes4 interfaceId) external view returns (bool);
593 }
594 
595 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
596 
597 
598 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
599 
600 pragma solidity ^0.8.0;
601 
602 
603 /**
604  * @dev Implementation of the {IERC165} interface.
605  *
606  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
607  * for the additional interface id that will be supported. For example:
608  *
609  * ```solidity
610  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
611  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
612  * }
613  * ```
614  *
615  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
616  */
617 abstract contract ERC165 is IERC165 {
618     /**
619      * @dev See {IERC165-supportsInterface}.
620      */
621     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
622         return interfaceId == type(IERC165).interfaceId;
623     }
624 }
625 
626 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
627 
628 
629 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 
634 /**
635  * @dev Required interface of an ERC721 compliant contract.
636  */
637 interface IERC721 is IERC165 {
638     /**
639      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
640      */
641     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
642 
643     /**
644      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
645      */
646     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
647 
648     /**
649      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
650      */
651     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
652 
653     /**
654      * @dev Returns the number of tokens in ``owner``'s account.
655      */
656     function balanceOf(address owner) external view returns (uint256 balance);
657 
658     /**
659      * @dev Returns the owner of the `tokenId` token.
660      *
661      * Requirements:
662      *
663      * - `tokenId` must exist.
664      */
665     function ownerOf(uint256 tokenId) external view returns (address owner);
666 
667     /**
668      * @dev Safely transfers `tokenId` token from `from` to `to`.
669      *
670      * Requirements:
671      *
672      * - `from` cannot be the zero address.
673      * - `to` cannot be the zero address.
674      * - `tokenId` token must exist and be owned by `from`.
675      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
676      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
677      *
678      * Emits a {Transfer} event.
679      */
680     function safeTransferFrom(
681         address from,
682         address to,
683         uint256 tokenId,
684         bytes calldata data
685     ) external;
686 
687     /**
688      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
689      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must exist and be owned by `from`.
696      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
697      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
698      *
699      * Emits a {Transfer} event.
700      */
701     function safeTransferFrom(
702         address from,
703         address to,
704         uint256 tokenId
705     ) external;
706 
707     /**
708      * @dev Transfers `tokenId` token from `from` to `to`.
709      *
710      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
711      *
712      * Requirements:
713      *
714      * - `from` cannot be the zero address.
715      * - `to` cannot be the zero address.
716      * - `tokenId` token must be owned by `from`.
717      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
718      *
719      * Emits a {Transfer} event.
720      */
721     function transferFrom(
722         address from,
723         address to,
724         uint256 tokenId
725     ) external;
726 
727     /**
728      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
729      * The approval is cleared when the token is transferred.
730      *
731      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
732      *
733      * Requirements:
734      *
735      * - The caller must own the token or be an approved operator.
736      * - `tokenId` must exist.
737      *
738      * Emits an {Approval} event.
739      */
740     function approve(address to, uint256 tokenId) external;
741 
742     /**
743      * @dev Approve or remove `operator` as an operator for the caller.
744      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
745      *
746      * Requirements:
747      *
748      * - The `operator` cannot be the caller.
749      *
750      * Emits an {ApprovalForAll} event.
751      */
752     function setApprovalForAll(address operator, bool _approved) external;
753 
754     /**
755      * @dev Returns the account approved for `tokenId` token.
756      *
757      * Requirements:
758      *
759      * - `tokenId` must exist.
760      */
761     function getApproved(uint256 tokenId) external view returns (address operator);
762 
763     /**
764      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
765      *
766      * See {setApprovalForAll}
767      */
768     function isApprovedForAll(address owner, address operator) external view returns (bool);
769 }
770 
771 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
772 
773 
774 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
775 
776 pragma solidity ^0.8.0;
777 
778 
779 /**
780  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
781  * @dev See https://eips.ethereum.org/EIPS/eip-721
782  */
783 interface IERC721Metadata is IERC721 {
784     /**
785      * @dev Returns the token collection name.
786      */
787     function name() external view returns (string memory);
788 
789     /**
790      * @dev Returns the token collection symbol.
791      */
792     function symbol() external view returns (string memory);
793 
794     /**
795      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
796      */
797     function tokenURI(uint256 tokenId) external view returns (string memory);
798 }
799 
800 // File: erc721a/contracts/IERC721A.sol
801 
802 
803 // ERC721A Contracts v3.3.0
804 // Creator: Chiru Labs
805 
806 pragma solidity ^0.8.4;
807 
808 
809 
810 /**
811  * @dev Interface of an ERC721A compliant contract.
812  */
813 interface IERC721A is IERC721, IERC721Metadata {
814     /**
815      * The caller must own the token or be an approved operator.
816      */
817     error ApprovalCallerNotOwnerNorApproved();
818 
819     /**
820      * The token does not exist.
821      */
822     error ApprovalQueryForNonexistentToken();
823 
824     /**
825      * The caller cannot approve to their own address.
826      */
827     error ApproveToCaller();
828 
829     /**
830      * The caller cannot approve to the current owner.
831      */
832     error ApprovalToCurrentOwner();
833 
834     /**
835      * Cannot query the balance for the zero address.
836      */
837     error BalanceQueryForZeroAddress();
838 
839     /**
840      * Cannot mint to the zero address.
841      */
842     error MintToZeroAddress();
843 
844     /**
845      * The quantity of tokens minted must be more than zero.
846      */
847     error MintZeroQuantity();
848 
849     /**
850      * The token does not exist.
851      */
852     error OwnerQueryForNonexistentToken();
853 
854     /**
855      * The caller must own the token or be an approved operator.
856      */
857     error TransferCallerNotOwnerNorApproved();
858 
859     /**
860      * The token must be owned by `from`.
861      */
862     error TransferFromIncorrectOwner();
863 
864     /**
865      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
866      */
867     error TransferToNonERC721ReceiverImplementer();
868 
869     /**
870      * Cannot transfer to the zero address.
871      */
872     error TransferToZeroAddress();
873 
874     /**
875      * The token does not exist.
876      */
877     error URIQueryForNonexistentToken();
878 
879     // Compiler will pack this into a single 256bit word.
880     struct TokenOwnership {
881         // The address of the owner.
882         address addr;
883         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
884         uint64 startTimestamp;
885         // Whether the token has been burned.
886         bool burned;
887     }
888 
889     // Compiler will pack this into a single 256bit word.
890     struct AddressData {
891         // Realistically, 2**64-1 is more than enough.
892         uint64 balance;
893         // Keeps track of mint count with minimal overhead for tokenomics.
894         uint64 numberMinted;
895         // Keeps track of burn count with minimal overhead for tokenomics.
896         uint64 numberBurned;
897         // For miscellaneous variable(s) pertaining to the address
898         // (e.g. number of whitelist mint slots used).
899         // If there are multiple variables, please pack them into a uint64.
900         uint64 aux;
901     }
902 
903     /**
904      * @dev Returns the total amount of tokens stored by the contract.
905      * 
906      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
907      */
908     function totalSupply() external view returns (uint256);
909 }
910 
911 // File: erc721a/contracts/ERC721A.sol
912 
913 
914 // ERC721A Contracts v3.3.0
915 // Creator: Chiru Labs
916 
917 pragma solidity ^0.8.4;
918 
919 
920 
921 
922 
923 
924 
925 /**
926  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
927  * the Metadata extension. Built to optimize for lower gas during batch mints.
928  *
929  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
930  *
931  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
932  *
933  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
934  */
935 contract ERC721A is Context, ERC165, IERC721A {
936     using Address for address;
937     using Strings for uint256;
938 
939     // The tokenId of the next token to be minted.
940     uint256 internal _currentIndex;
941 
942     // The number of tokens burned.
943     uint256 internal _burnCounter;
944 
945     // Token name
946     string private _name;
947 
948     // Token symbol
949     string private _symbol;
950 
951     // Mapping from token ID to ownership details
952     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
953     mapping(uint256 => TokenOwnership) internal _ownerships;
954 
955     // Mapping owner address to address data
956     mapping(address => AddressData) private _addressData;
957 
958     // Mapping from token ID to approved address
959     mapping(uint256 => address) private _tokenApprovals;
960 
961     // Mapping from owner to operator approvals
962     mapping(address => mapping(address => bool)) private _operatorApprovals;
963 
964     constructor(string memory name_, string memory symbol_) {
965         _name = name_;
966         _symbol = symbol_;
967         _currentIndex = _startTokenId();
968     }
969 
970     /**
971      * To change the starting tokenId, please override this function.
972      */
973     function _startTokenId() internal view virtual returns (uint256) {
974         return 0;
975     }
976 
977     /**
978      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
979      */
980     function totalSupply() public view override returns (uint256) {
981         // Counter underflow is impossible as _burnCounter cannot be incremented
982         // more than _currentIndex - _startTokenId() times
983         unchecked {
984             return _currentIndex - _burnCounter - _startTokenId();
985         }
986     }
987 
988     /**
989      * Returns the total amount of tokens minted in the contract.
990      */
991     function _totalMinted() internal view returns (uint256) {
992         // Counter underflow is impossible as _currentIndex does not decrement,
993         // and it is initialized to _startTokenId()
994         unchecked {
995             return _currentIndex - _startTokenId();
996         }
997     }
998 
999     /**
1000      * @dev See {IERC165-supportsInterface}.
1001      */
1002     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1003         return
1004             interfaceId == type(IERC721).interfaceId ||
1005             interfaceId == type(IERC721Metadata).interfaceId ||
1006             super.supportsInterface(interfaceId);
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-balanceOf}.
1011      */
1012     function balanceOf(address owner) public view override returns (uint256) {
1013         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1014         return uint256(_addressData[owner].balance);
1015     }
1016 
1017     /**
1018      * Returns the number of tokens minted by `owner`.
1019      */
1020     function _numberMinted(address owner) internal view returns (uint256) {
1021         return uint256(_addressData[owner].numberMinted);
1022     }
1023 
1024     /**
1025      * Returns the number of tokens burned by or on behalf of `owner`.
1026      */
1027     function _numberBurned(address owner) internal view returns (uint256) {
1028         return uint256(_addressData[owner].numberBurned);
1029     }
1030 
1031     /**
1032      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1033      */
1034     function _getAux(address owner) internal view returns (uint64) {
1035         return _addressData[owner].aux;
1036     }
1037 
1038     /**
1039      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1040      * If there are multiple variables, please pack them into a uint64.
1041      */
1042     function _setAux(address owner, uint64 aux) internal {
1043         _addressData[owner].aux = aux;
1044     }
1045 
1046     /**
1047      * Gas spent here starts off proportional to the maximum mint batch size.
1048      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1049      */
1050     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1051         uint256 curr = tokenId;
1052 
1053         unchecked {
1054             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1055                 TokenOwnership memory ownership = _ownerships[curr];
1056                 if (!ownership.burned) {
1057                     if (ownership.addr != address(0)) {
1058                         return ownership;
1059                     }
1060                     // Invariant:
1061                     // There will always be an ownership that has an address and is not burned
1062                     // before an ownership that does not have an address and is not burned.
1063                     // Hence, curr will not underflow.
1064                     while (true) {
1065                         curr--;
1066                         ownership = _ownerships[curr];
1067                         if (ownership.addr != address(0)) {
1068                             return ownership;
1069                         }
1070                     }
1071                 }
1072             }
1073         }
1074         revert OwnerQueryForNonexistentToken();
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-ownerOf}.
1079      */
1080     function ownerOf(uint256 tokenId) public view override returns (address) {
1081         return _ownershipOf(tokenId).addr;
1082     }
1083 
1084     /**
1085      * @dev See {IERC721Metadata-name}.
1086      */
1087     function name() public view virtual override returns (string memory) {
1088         return _name;
1089     }
1090 
1091     /**
1092      * @dev See {IERC721Metadata-symbol}.
1093      */
1094     function symbol() public view virtual override returns (string memory) {
1095         return _symbol;
1096     }
1097 
1098     /**
1099      * @dev See {IERC721Metadata-tokenURI}.
1100      */
1101     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1102         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1103 
1104         string memory baseURI = _baseURI();
1105         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1106     }
1107 
1108     /**
1109      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1110      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1111      * by default, can be overriden in child contracts.
1112      */
1113     function _baseURI() internal view virtual returns (string memory) {
1114         return '';
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-approve}.
1119      */
1120     function approve(address to, uint256 tokenId) public override {
1121         address owner = ERC721A.ownerOf(tokenId);
1122         if (to == owner) revert ApprovalToCurrentOwner();
1123 
1124         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1125             revert ApprovalCallerNotOwnerNorApproved();
1126         }
1127 
1128         _approve(to, tokenId, owner);
1129     }
1130 
1131     /**
1132      * @dev See {IERC721-getApproved}.
1133      */
1134     function getApproved(uint256 tokenId) public view override returns (address) {
1135         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1136 
1137         return _tokenApprovals[tokenId];
1138     }
1139 
1140     /**
1141      * @dev See {IERC721-setApprovalForAll}.
1142      */
1143     function setApprovalForAll(address operator, bool approved) public virtual override {
1144         if (operator == _msgSender()) revert ApproveToCaller();
1145 
1146         _operatorApprovals[_msgSender()][operator] = approved;
1147         emit ApprovalForAll(_msgSender(), operator, approved);
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-isApprovedForAll}.
1152      */
1153     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1154         return _operatorApprovals[owner][operator];
1155     }
1156 
1157     /**
1158      * @dev See {IERC721-transferFrom}.
1159      */
1160     function transferFrom(
1161         address from,
1162         address to,
1163         uint256 tokenId
1164     ) public virtual override {
1165         _transfer(from, to, tokenId);
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-safeTransferFrom}.
1170      */
1171     function safeTransferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) public virtual override {
1176         safeTransferFrom(from, to, tokenId, '');
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-safeTransferFrom}.
1181      */
1182     function safeTransferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId,
1186         bytes memory _data
1187     ) public virtual override {
1188         _transfer(from, to, tokenId);
1189         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1190             revert TransferToNonERC721ReceiverImplementer();
1191         }
1192     }
1193 
1194     /**
1195      * @dev Returns whether `tokenId` exists.
1196      *
1197      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1198      *
1199      * Tokens start existing when they are minted (`_mint`),
1200      */
1201     function _exists(uint256 tokenId) internal view returns (bool) {
1202         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1203     }
1204 
1205     /**
1206      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1207      */
1208     function _safeMint(address to, uint256 quantity) internal {
1209         _safeMint(to, quantity, '');
1210     }
1211 
1212     /**
1213      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1214      *
1215      * Requirements:
1216      *
1217      * - If `to` refers to a smart contract, it must implement
1218      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1219      * - `quantity` must be greater than 0.
1220      *
1221      * Emits a {Transfer} event.
1222      */
1223     function _safeMint(
1224         address to,
1225         uint256 quantity,
1226         bytes memory _data
1227     ) internal {
1228         uint256 startTokenId = _currentIndex;
1229         if (to == address(0)) revert MintToZeroAddress();
1230         if (quantity == 0) revert MintZeroQuantity();
1231 
1232         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1233 
1234         // Overflows are incredibly unrealistic.
1235         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1236         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1237         unchecked {
1238             _addressData[to].balance += uint64(quantity);
1239             _addressData[to].numberMinted += uint64(quantity);
1240 
1241             _ownerships[startTokenId].addr = to;
1242             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1243 
1244             uint256 updatedIndex = startTokenId;
1245             uint256 end = updatedIndex + quantity;
1246 
1247             if (to.isContract()) {
1248                 do {
1249                     emit Transfer(address(0), to, updatedIndex);
1250                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1251                         revert TransferToNonERC721ReceiverImplementer();
1252                     }
1253                 } while (updatedIndex < end);
1254                 // Reentrancy protection
1255                 if (_currentIndex != startTokenId) revert();
1256             } else {
1257                 do {
1258                     emit Transfer(address(0), to, updatedIndex++);
1259                 } while (updatedIndex < end);
1260             }
1261             _currentIndex = updatedIndex;
1262         }
1263         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1264     }
1265 
1266     /**
1267      * @dev Mints `quantity` tokens and transfers them to `to`.
1268      *
1269      * Requirements:
1270      *
1271      * - `to` cannot be the zero address.
1272      * - `quantity` must be greater than 0.
1273      *
1274      * Emits a {Transfer} event.
1275      */
1276     function _mint(address to, uint256 quantity) internal {
1277         uint256 startTokenId = _currentIndex;
1278         if (to == address(0)) revert MintToZeroAddress();
1279         if (quantity == 0) revert MintZeroQuantity();
1280 
1281         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1282 
1283         // Overflows are incredibly unrealistic.
1284         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1285         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1286         unchecked {
1287             _addressData[to].balance += uint64(quantity);
1288             _addressData[to].numberMinted += uint64(quantity);
1289 
1290             _ownerships[startTokenId].addr = to;
1291             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1292 
1293             uint256 updatedIndex = startTokenId;
1294             uint256 end = updatedIndex + quantity;
1295 
1296             do {
1297                 emit Transfer(address(0), to, updatedIndex++);
1298             } while (updatedIndex < end);
1299 
1300             _currentIndex = updatedIndex;
1301         }
1302         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1303     }
1304 
1305     /**
1306      * @dev Transfers `tokenId` from `from` to `to`.
1307      *
1308      * Requirements:
1309      *
1310      * - `to` cannot be the zero address.
1311      * - `tokenId` token must be owned by `from`.
1312      *
1313      * Emits a {Transfer} event.
1314      */
1315     function _transfer(
1316         address from,
1317         address to,
1318         uint256 tokenId
1319     ) private {
1320         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1321 
1322         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1323 
1324         bool isApprovedOrOwner = (_msgSender() == from ||
1325             isApprovedForAll(from, _msgSender()) ||
1326             getApproved(tokenId) == _msgSender());
1327 
1328         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1329         if (to == address(0)) revert TransferToZeroAddress();
1330 
1331         _beforeTokenTransfers(from, to, tokenId, 1);
1332 
1333         // Clear approvals from the previous owner
1334         _approve(address(0), tokenId, from);
1335 
1336         // Underflow of the sender's balance is impossible because we check for
1337         // ownership above and the recipient's balance can't realistically overflow.
1338         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1339         unchecked {
1340             _addressData[from].balance -= 1;
1341             _addressData[to].balance += 1;
1342 
1343             TokenOwnership storage currSlot = _ownerships[tokenId];
1344             currSlot.addr = to;
1345             currSlot.startTimestamp = uint64(block.timestamp);
1346 
1347             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1348             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1349             uint256 nextTokenId = tokenId + 1;
1350             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1351             if (nextSlot.addr == address(0)) {
1352                 // This will suffice for checking _exists(nextTokenId),
1353                 // as a burned slot cannot contain the zero address.
1354                 if (nextTokenId != _currentIndex) {
1355                     nextSlot.addr = from;
1356                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1357                 }
1358             }
1359         }
1360 
1361         emit Transfer(from, to, tokenId);
1362         _afterTokenTransfers(from, to, tokenId, 1);
1363     }
1364 
1365     /**
1366      * @dev Equivalent to `_burn(tokenId, false)`.
1367      */
1368     function _burn(uint256 tokenId) internal virtual {
1369         _burn(tokenId, false);
1370     }
1371 
1372     /**
1373      * @dev Destroys `tokenId`.
1374      * The approval is cleared when the token is burned.
1375      *
1376      * Requirements:
1377      *
1378      * - `tokenId` must exist.
1379      *
1380      * Emits a {Transfer} event.
1381      */
1382     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1383         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1384 
1385         address from = prevOwnership.addr;
1386 
1387         if (approvalCheck) {
1388             bool isApprovedOrOwner = (_msgSender() == from ||
1389                 isApprovedForAll(from, _msgSender()) ||
1390                 getApproved(tokenId) == _msgSender());
1391 
1392             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1393         }
1394 
1395         _beforeTokenTransfers(from, address(0), tokenId, 1);
1396 
1397         // Clear approvals from the previous owner
1398         _approve(address(0), tokenId, from);
1399 
1400         // Underflow of the sender's balance is impossible because we check for
1401         // ownership above and the recipient's balance can't realistically overflow.
1402         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1403         unchecked {
1404             AddressData storage addressData = _addressData[from];
1405             addressData.balance -= 1;
1406             addressData.numberBurned += 1;
1407 
1408             // Keep track of who burned the token, and the timestamp of burning.
1409             TokenOwnership storage currSlot = _ownerships[tokenId];
1410             currSlot.addr = from;
1411             currSlot.startTimestamp = uint64(block.timestamp);
1412             currSlot.burned = true;
1413 
1414             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1415             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1416             uint256 nextTokenId = tokenId + 1;
1417             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1418             if (nextSlot.addr == address(0)) {
1419                 // This will suffice for checking _exists(nextTokenId),
1420                 // as a burned slot cannot contain the zero address.
1421                 if (nextTokenId != _currentIndex) {
1422                     nextSlot.addr = from;
1423                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1424                 }
1425             }
1426         }
1427 
1428         emit Transfer(from, address(0), tokenId);
1429         _afterTokenTransfers(from, address(0), tokenId, 1);
1430 
1431         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1432         unchecked {
1433             _burnCounter++;
1434         }
1435     }
1436 
1437     /**
1438      * @dev Approve `to` to operate on `tokenId`
1439      *
1440      * Emits a {Approval} event.
1441      */
1442     function _approve(
1443         address to,
1444         uint256 tokenId,
1445         address owner
1446     ) private {
1447         _tokenApprovals[tokenId] = to;
1448         emit Approval(owner, to, tokenId);
1449     }
1450 
1451     /**
1452      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1453      *
1454      * @param from address representing the previous owner of the given token ID
1455      * @param to target address that will receive the tokens
1456      * @param tokenId uint256 ID of the token to be transferred
1457      * @param _data bytes optional data to send along with the call
1458      * @return bool whether the call correctly returned the expected magic value
1459      */
1460     function _checkContractOnERC721Received(
1461         address from,
1462         address to,
1463         uint256 tokenId,
1464         bytes memory _data
1465     ) private returns (bool) {
1466         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1467             return retval == IERC721Receiver(to).onERC721Received.selector;
1468         } catch (bytes memory reason) {
1469             if (reason.length == 0) {
1470                 revert TransferToNonERC721ReceiverImplementer();
1471             } else {
1472                 assembly {
1473                     revert(add(32, reason), mload(reason))
1474                 }
1475             }
1476         }
1477     }
1478 
1479     /**
1480      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1481      * And also called before burning one token.
1482      *
1483      * startTokenId - the first token id to be transferred
1484      * quantity - the amount to be transferred
1485      *
1486      * Calling conditions:
1487      *
1488      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1489      * transferred to `to`.
1490      * - When `from` is zero, `tokenId` will be minted for `to`.
1491      * - When `to` is zero, `tokenId` will be burned by `from`.
1492      * - `from` and `to` are never both zero.
1493      */
1494     function _beforeTokenTransfers(
1495         address from,
1496         address to,
1497         uint256 startTokenId,
1498         uint256 quantity
1499     ) internal virtual {}
1500 
1501     /**
1502      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1503      * minting.
1504      * And also called after one token has been burned.
1505      *
1506      * startTokenId - the first token id to be transferred
1507      * quantity - the amount to be transferred
1508      *
1509      * Calling conditions:
1510      *
1511      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1512      * transferred to `to`.
1513      * - When `from` is zero, `tokenId` has been minted for `to`.
1514      * - When `to` is zero, `tokenId` has been burned by `from`.
1515      * - `from` and `to` are never both zero.
1516      */
1517     function _afterTokenTransfers(
1518         address from,
1519         address to,
1520         uint256 startTokenId,
1521         uint256 quantity
1522     ) internal virtual {}
1523 }
1524 
1525 // File: contracts/Nothing.sol
1526 
1527 
1528 
1529 pragma solidity >=0.8.9 <0.9.0;
1530 
1531 
1532 
1533 
1534 
1535 contract Nothing is ERC721A, Ownable, ReentrancyGuard {
1536     using Strings for uint256;
1537 
1538     bytes32 public merkleRoot;
1539     mapping(address => bool) public whitelistClaimed;
1540 
1541     string public uriPrefix = "ipfs://QmWdv2MXjX6X96vyzLkunYeWrQxvUESCWpUi7TE9Sk4WmC/";
1542     string public uriSuffix = ".json";
1543     string public hiddenMetadataUri;
1544 
1545     uint256 public cost;
1546     uint256 public maxSupply;
1547     uint256 public maxMintAmountPerTx;
1548     uint256 public maxMintAmountPerAddress;
1549 
1550     bool public paused = true;
1551     bool public whitelistMintEnabled = false;
1552     bool public revealed = true;
1553 
1554     mapping(address => uint256) public totalMintedByAddress;
1555 
1556     constructor(
1557         string memory _tokenName,
1558         string memory _tokenSymbol,
1559         uint256 _cost,
1560         uint256 _maxSupply,
1561         uint256 _maxMintAmountPerTx,
1562         uint256 _maxMintAmountPerAddress,
1563         string memory _hiddenMetadataUri
1564     ) ERC721A(_tokenName, _tokenSymbol) {
1565         setCost(_cost);
1566         maxSupply = _maxSupply;
1567         setMaxMintAmountPerTx(_maxMintAmountPerTx);
1568         setMaxMintAmountPerAddress(_maxMintAmountPerAddress);
1569         setHiddenMetadataUri(_hiddenMetadataUri);
1570     }
1571 
1572     modifier mintCompliance(uint256 _mintAmount) {
1573         require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1574         require(totalSupply() + _mintAmount <= maxSupply, "Max supply exceeded!");
1575         _;
1576     }
1577 
1578     modifier mintPriceCompliance(uint256 _mintAmount) {
1579         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1580         _;
1581     }
1582 
1583     function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1584         // Verify whitelist requirements
1585         require(whitelistMintEnabled, "The whitelist sale is not enabled!");
1586         require(!whitelistClaimed[_msgSender()], "Address already claimed!");
1587         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1588         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Invalid proof!");
1589 
1590         whitelistClaimed[_msgSender()] = true;
1591         _safeMint(_msgSender(), _mintAmount);
1592     }
1593 
1594     function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1595         require(totalMintedByAddress[msg.sender] + _mintAmount <= maxMintAmountPerAddress, "Exceeded maximum total amount!");
1596         require(!paused, "The contract is paused!");
1597 
1598         for (uint256 i = 0; i < _mintAmount; i++) {
1599             totalMintedByAddress[msg.sender]++;
1600         }
1601 
1602         _safeMint(_msgSender(), _mintAmount);
1603     }
1604 
1605     function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1606         _safeMint(_receiver, _mintAmount);
1607     }
1608 
1609     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1610         uint256 ownerTokenCount = balanceOf(_owner);
1611         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1612         uint256 currentTokenId = _startTokenId();
1613         uint256 ownedTokenIndex = 0;
1614         address latestOwnerAddress;
1615 
1616         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1617             TokenOwnership memory ownership = _ownerships[currentTokenId];
1618 
1619             if (!ownership.burned && ownership.addr != address(0)) {
1620                 latestOwnerAddress = ownership.addr;
1621             }
1622 
1623             if (latestOwnerAddress == _owner) {
1624                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1625 
1626                 ownedTokenIndex++;
1627             }
1628 
1629             currentTokenId++;
1630         }
1631 
1632         return ownedTokenIds;
1633     }
1634 
1635     function _startTokenId() internal view virtual override returns (uint256) {
1636         return 1;
1637     }
1638 
1639     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1640         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1641 
1642         if (revealed == false) {
1643             return hiddenMetadataUri;
1644         }
1645 
1646         string memory currentBaseURI = _baseURI();
1647         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)) : "";
1648     }
1649 
1650     function setRevealed(bool _state) public onlyOwner {
1651         revealed = _state;
1652     }
1653 
1654     function setCost(uint256 _cost) public onlyOwner {
1655         cost = _cost;
1656     }
1657 
1658     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1659         maxMintAmountPerTx = _maxMintAmountPerTx;
1660     }
1661 
1662     function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1663         hiddenMetadataUri = _hiddenMetadataUri;
1664     }
1665 
1666     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1667         uriPrefix = _uriPrefix;
1668     }
1669 
1670     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1671         uriSuffix = _uriSuffix;
1672     }
1673 
1674     function setPaused(bool _state) public onlyOwner {
1675         paused = _state;
1676     }
1677 
1678     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1679         merkleRoot = _merkleRoot;
1680     }
1681 
1682     function setWhitelistMintEnabled(bool _state) public onlyOwner {
1683         whitelistMintEnabled = _state;
1684     }
1685 
1686     function setMaxMintAmountPerAddress(uint256 _maxMintAmountPerAddress) public onlyOwner {
1687         maxMintAmountPerAddress = _maxMintAmountPerAddress;
1688     }
1689 
1690     function withdraw() public onlyOwner nonReentrant {
1691         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1692         require(os);
1693     }
1694 
1695     function _baseURI() internal view virtual override returns (string memory) {
1696         return uriPrefix;
1697     }
1698 }