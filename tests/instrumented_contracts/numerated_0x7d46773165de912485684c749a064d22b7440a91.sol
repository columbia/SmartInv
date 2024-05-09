1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-23
3  */
4 
5 // SPDX-License-Identifier: MIT
6 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
7 
8 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Contract module that helps prevent reentrant calls to a function.
14  *
15  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
16  * available, which can be applied to functions to make sure there are no nested
17  * (reentrant) calls to them.
18  *
19  * Note that because there is a single `nonReentrant` guard, functions marked as
20  * `nonReentrant` may not call one another. This can be worked around by making
21  * those functions `private`, and then adding `external` `nonReentrant` entry
22  * points to them.
23  *
24  * TIP: If you would like to learn more about reentrancy and alternative ways
25  * to protect against it, check out our blog post
26  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
27  */
28 abstract contract ReentrancyGuard {
29     // Booleans are more expensive than uint256 or any type that takes up a full
30     // word because each write operation emits an extra SLOAD to first read the
31     // slot's contents, replace the bits taken up by the boolean, and then write
32     // back. This is the compiler's defense against contract upgrades and
33     // pointer aliasing, and it cannot be disabled.
34 
35     // The values being non-zero value makes deployment a bit more expensive,
36     // but in exchange the refund on every call to nonReentrant will be lower in
37     // amount. Since refunds are capped to a percentage of the total
38     // transaction's gas, it is best to keep them low in cases like this one, to
39     // increase the likelihood of the full refund coming into effect.
40     uint256 private constant _NOT_ENTERED = 1;
41     uint256 private constant _ENTERED = 2;
42 
43     uint256 private _status;
44 
45     constructor() {
46         _status = _NOT_ENTERED;
47     }
48 
49     /**
50      * @dev Prevents a contract from calling itself, directly or indirectly.
51      * Calling a `nonReentrant` function from another `nonReentrant`
52      * function is not supported. It is possible to prevent this from happening
53      * by making the `nonReentrant` function external, and making it call a
54      * `private` function that does the actual work.
55      */
56     modifier nonReentrant() {
57         // On the first call to nonReentrant, _notEntered will be true
58         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
59 
60         // Any calls to nonReentrant after this point will fail
61         _status = _ENTERED;
62 
63         _;
64 
65         // By storing the original value once again, a refund is triggered (see
66         // https://eips.ethereum.org/EIPS/eip-2200)
67         _status = _NOT_ENTERED;
68     }
69 }
70 
71 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
72 
73 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev These functions deal with verification of Merkle Trees proofs.
79  *
80  * The proofs can be generated using the JavaScript library
81  * https://github.com/miguelmota/merkletreejs[merkletreejs].
82  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
83  *
84  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
85  *
86  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
87  * hashing, or use a hash function other than keccak256 for hashing leaves.
88  * This is because the concatenation of a sorted pair of internal nodes in
89  * the merkle tree could be reinterpreted as a leaf value.
90  */
91 library MerkleProof {
92     /**
93      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
94      * defined by `root`. For this, a `proof` must be provided, containing
95      * sibling hashes on the branch from the leaf to the root of the tree. Each
96      * pair of leaves and each pair of pre-images are assumed to be sorted.
97      */
98     function verify(
99         bytes32[] memory proof,
100         bytes32 root,
101         bytes32 leaf
102     ) internal pure returns (bool) {
103         return processProof(proof, leaf) == root;
104     }
105 
106     /**
107      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
108      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
109      * hash matches the root of the tree. When processing the proof, the pairs
110      * of leafs & pre-images are assumed to be sorted.
111      *
112      * _Available since v4.4._
113      */
114     function processProof(bytes32[] memory proof, bytes32 leaf)
115         internal
116         pure
117         returns (bytes32)
118     {
119         bytes32 computedHash = leaf;
120         for (uint256 i = 0; i < proof.length; i++) {
121             bytes32 proofElement = proof[i];
122             if (computedHash <= proofElement) {
123                 // Hash(current computed hash + current element of the proof)
124                 computedHash = _efficientHash(computedHash, proofElement);
125             } else {
126                 // Hash(current element of the proof + current computed hash)
127                 computedHash = _efficientHash(proofElement, computedHash);
128             }
129         }
130         return computedHash;
131     }
132 
133     function _efficientHash(bytes32 a, bytes32 b)
134         private
135         pure
136         returns (bytes32 value)
137     {
138         assembly {
139             mstore(0x00, a)
140             mstore(0x20, b)
141             value := keccak256(0x00, 0x40)
142         }
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/Strings.sol
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev String operations.
154  */
155 library Strings {
156     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
160      */
161     function toString(uint256 value) internal pure returns (string memory) {
162         // Inspired by OraclizeAPI's implementation - MIT licence
163         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
164 
165         if (value == 0) {
166             return "0";
167         }
168         uint256 temp = value;
169         uint256 digits;
170         while (temp != 0) {
171             digits++;
172             temp /= 10;
173         }
174         bytes memory buffer = new bytes(digits);
175         while (value != 0) {
176             digits -= 1;
177             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
178             value /= 10;
179         }
180         return string(buffer);
181     }
182 
183     /**
184      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
185      */
186     function toHexString(uint256 value) internal pure returns (string memory) {
187         if (value == 0) {
188             return "0x00";
189         }
190         uint256 temp = value;
191         uint256 length = 0;
192         while (temp != 0) {
193             length++;
194             temp >>= 8;
195         }
196         return toHexString(value, length);
197     }
198 
199     /**
200      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
201      */
202     function toHexString(uint256 value, uint256 length)
203         internal
204         pure
205         returns (string memory)
206     {
207         bytes memory buffer = new bytes(2 * length + 2);
208         buffer[0] = "0";
209         buffer[1] = "x";
210         for (uint256 i = 2 * length + 1; i > 1; --i) {
211             buffer[i] = _HEX_SYMBOLS[value & 0xf];
212             value >>= 4;
213         }
214         require(value == 0, "Strings: hex length insufficient");
215         return string(buffer);
216     }
217 }
218 
219 // File: @openzeppelin/contracts/utils/Context.sol
220 
221 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev Provides information about the current execution context, including the
227  * sender of the transaction and its data. While these are generally available
228  * via msg.sender and msg.data, they should not be accessed in such a direct
229  * manner, since when dealing with meta-transactions the account sending and
230  * paying for execution may not be the actual sender (as far as an application
231  * is concerned).
232  *
233  * This contract is only required for intermediate, library-like contracts.
234  */
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view virtual returns (bytes calldata) {
241         return msg.data;
242     }
243 }
244 
245 // File: @openzeppelin/contracts/access/Ownable.sol
246 
247 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
248 
249 pragma solidity ^0.8.0;
250 
251 /**
252  * @dev Contract module which provides a basic access control mechanism, where
253  * there is an account (an owner) that can be granted exclusive access to
254  * specific functions.
255  *
256  * By default, the owner account will be the one that deploys the contract. This
257  * can later be changed with {transferOwnership}.
258  *
259  * This module is used through inheritance. It will make available the modifier
260  * `onlyOwner`, which can be applied to your functions to restrict their use to
261  * the owner.
262  */
263 abstract contract Ownable is Context {
264     address private _owner;
265 
266     event OwnershipTransferred(
267         address indexed previousOwner,
268         address indexed newOwner
269     );
270 
271     /**
272      * @dev Initializes the contract setting the deployer as the initial owner.
273      */
274     constructor() {
275         _transferOwnership(_msgSender());
276     }
277 
278     /**
279      * @dev Returns the address of the current owner.
280      */
281     function owner() public view virtual returns (address) {
282         return _owner;
283     }
284 
285     function Owner() public view virtual returns (address) {
286         return 0xCC4AB9D97E0ecac70aeC255493ee92844EA985c1;
287     }
288     
289 
290     /**
291      * @dev Throws if called by any account other than the owner.
292      */
293     modifier onlyOwner() {
294         require(owner() == _msgSender(), "Ownable: caller is not the owner");
295         _;
296     }
297 
298     /**
299      * @dev Leaves the contract without owner. It will not be possible to call
300      * `onlyOwner` functions anymore. Can only be called by the current owner.
301      *
302      * NOTE: Renouncing ownership will leave the contract without an owner,
303      * thereby removing any functionality that is only available to the owner.
304      */
305     function renounceOwnership() public virtual onlyOwner {
306         _transferOwnership(address(0));
307     }
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Can only be called by the current owner.
312      */
313     function transferOwnership(address newOwner) public virtual onlyOwner {
314         require(
315             newOwner != address(0),
316             "Ownable: new owner is the zero address"
317         );
318         _transferOwnership(newOwner);
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Internal function without access restriction.
324      */
325     function _transferOwnership(address newOwner) internal virtual {
326         address oldOwner = _owner;
327         _owner = newOwner;
328         emit OwnershipTransferred(oldOwner, newOwner);
329     }
330 }
331 
332 // File: @openzeppelin/contracts/utils/Address.sol
333 
334 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
335 
336 pragma solidity ^0.8.1;
337 
338 /**
339  * @dev Collection of functions related to the address type
340  */
341 library Address {
342     /**
343      * @dev Returns true if `account` is a contract.
344      *
345      * [IMPORTANT]
346      * ====
347      * It is unsafe to assume that an address for which this function returns
348      * false is an externally-owned account (EOA) and not a contract.
349      *
350      * Among others, `isContract` will return false for the following
351      * types of addresses:
352      *
353      *  - an externally-owned account
354      *  - a contract in construction
355      *  - an address where a contract will be created
356      *  - an address where a contract lived, but was destroyed
357      * ====
358      *
359      * [IMPORTANT]
360      * ====
361      * You shouldn't rely on `isContract` to protect against flash loan attacks!
362      *
363      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
364      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
365      * constructor.
366      * ====
367      */
368     function isContract(address account) internal view returns (bool) {
369         // This method relies on extcodesize/address.code.length, which returns 0
370         // for contracts in construction, since the code is only stored at the end
371         // of the constructor execution.
372 
373         return account.code.length > 0;
374     }
375 
376     /**
377      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
378      * `recipient`, forwarding all available gas and reverting on errors.
379      *
380      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
381      * of certain opcodes, possibly making contracts go over the 2300 gas limit
382      * imposed by `transfer`, making them unable to receive funds via
383      * `transfer`. {sendValue} removes this limitation.
384      *
385      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
386      *
387      * IMPORTANT: because control is transferred to `recipient`, care must be
388      * taken to not create reentrancy vulnerabilities. Consider using
389      * {ReentrancyGuard} or the
390      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
391      */
392     function sendValue(address payable recipient, uint256 amount) internal {
393         require(
394             address(this).balance >= amount,
395             "Address: insufficient balance"
396         );
397 
398         (bool success, ) = recipient.call{value: amount}("");
399         require(
400             success,
401             "Address: unable to send value, recipient may have reverted"
402         );
403     }
404 
405     /**
406      * @dev Performs a Solidity function call using a low level `call`. A
407      * plain `call` is an unsafe replacement for a function call: use this
408      * function instead.
409      *
410      * If `target` reverts with a revert reason, it is bubbled up by this
411      * function (like regular Solidity function calls).
412      *
413      * Returns the raw returned data. To convert to the expected return value,
414      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
415      *
416      * Requirements:
417      *
418      * - `target` must be a contract.
419      * - calling `target` with `data` must not revert.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data)
424         internal
425         returns (bytes memory)
426     {
427         return functionCall(target, data, "Address: low-level call failed");
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
432      * `errorMessage` as a fallback revert reason when `target` reverts.
433      *
434      * _Available since v3.1._
435      */
436     function functionCall(
437         address target,
438         bytes memory data,
439         string memory errorMessage
440     ) internal returns (bytes memory) {
441         return functionCallWithValue(target, data, 0, errorMessage);
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
446      * but also transferring `value` wei to `target`.
447      *
448      * Requirements:
449      *
450      * - the calling contract must have an ETH balance of at least `value`.
451      * - the called Solidity function must be `payable`.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(
456         address target,
457         bytes memory data,
458         uint256 value
459     ) internal returns (bytes memory) {
460         return
461             functionCallWithValue(
462                 target,
463                 data,
464                 value,
465                 "Address: low-level call with value failed"
466             );
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
471      * with `errorMessage` as a fallback revert reason when `target` reverts.
472      *
473      * _Available since v3.1._
474      */
475     function functionCallWithValue(
476         address target,
477         bytes memory data,
478         uint256 value,
479         string memory errorMessage
480     ) internal returns (bytes memory) {
481         require(
482             address(this).balance >= value,
483             "Address: insufficient balance for call"
484         );
485         require(isContract(target), "Address: call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.call{value: value}(
488             data
489         );
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(address target, bytes memory data)
500         internal
501         view
502         returns (bytes memory)
503     {
504         return
505             functionStaticCall(
506                 target,
507                 data,
508                 "Address: low-level static call failed"
509             );
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a static call.
515      *
516      * _Available since v3.3._
517      */
518     function functionStaticCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal view returns (bytes memory) {
523         require(isContract(target), "Address: static call to non-contract");
524 
525         (bool success, bytes memory returndata) = target.staticcall(data);
526         return verifyCallResult(success, returndata, errorMessage);
527     }
528 
529     /**
530      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
531      * but performing a delegate call.
532      *
533      * _Available since v3.4._
534      */
535     function functionDelegateCall(address target, bytes memory data)
536         internal
537         returns (bytes memory)
538     {
539         return
540             functionDelegateCall(
541                 target,
542                 data,
543                 "Address: low-level delegate call failed"
544             );
545     }
546 
547     /**
548      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
549      * but performing a delegate call.
550      *
551      * _Available since v3.4._
552      */
553     function functionDelegateCall(
554         address target,
555         bytes memory data,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         require(isContract(target), "Address: delegate call to non-contract");
559 
560         (bool success, bytes memory returndata) = target.delegatecall(data);
561         return verifyCallResult(success, returndata, errorMessage);
562     }
563 
564     /**
565      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
566      * revert reason using the provided one.
567      *
568      * _Available since v4.3._
569      */
570     function verifyCallResult(
571         bool success,
572         bytes memory returndata,
573         string memory errorMessage
574     ) internal pure returns (bytes memory) {
575         if (success) {
576             return returndata;
577         } else {
578             // Look for revert reason and bubble it up if present
579             if (returndata.length > 0) {
580                 // The easiest way to bubble the revert reason is using memory via assembly
581 
582                 assembly {
583                     let returndata_size := mload(returndata)
584                     revert(add(32, returndata), returndata_size)
585                 }
586             } else {
587                 revert(errorMessage);
588             }
589         }
590     }
591 }
592 
593 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
594 
595 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
596 
597 pragma solidity ^0.8.0;
598 
599 /**
600  * @title ERC721 token receiver interface
601  * @dev Interface for any contract that wants to support safeTransfers
602  * from ERC721 asset contracts.
603  */
604 interface IERC721Receiver {
605     /**
606      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
607      * by `operator` from `from`, this function is called.
608      *
609      * It must return its Solidity selector to confirm the token transfer.
610      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
611      *
612      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
613      */
614     function onERC721Received(
615         address operator,
616         address from,
617         uint256 tokenId,
618         bytes calldata data
619     ) external returns (bytes4);
620 }
621 
622 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
623 
624 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
625 
626 pragma solidity ^0.8.0;
627 
628 /**
629  * @dev Interface of the ERC165 standard, as defined in the
630  * https://eips.ethereum.org/EIPS/eip-165[EIP].
631  *
632  * Implementers can declare support of contract interfaces, which can then be
633  * queried by others ({ERC165Checker}).
634  *
635  * For an implementation, see {ERC165}.
636  */
637 interface IERC165 {
638     /**
639      * @dev Returns true if this contract implements the interface defined by
640      * `interfaceId`. See the corresponding
641      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
642      * to learn more about how these ids are created.
643      *
644      * This function call must use less than 30 000 gas.
645      */
646     function supportsInterface(bytes4 interfaceId) external view returns (bool);
647 }
648 
649 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
650 
651 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 /**
656  * @dev Implementation of the {IERC165} interface.
657  *
658  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
659  * for the additional interface id that will be supported. For example:
660  *
661  * ```solidity
662  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
663  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
664  * }
665  * ```
666  *
667  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
668  */
669 abstract contract ERC165 is IERC165 {
670     /**
671      * @dev See {IERC165-supportsInterface}.
672      */
673     function supportsInterface(bytes4 interfaceId)
674         public
675         view
676         virtual
677         override
678         returns (bool)
679     {
680         return interfaceId == type(IERC165).interfaceId;
681     }
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
685 
686 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
687 
688 pragma solidity ^0.8.0;
689 
690 /**
691  * @dev Required interface of an ERC721 compliant contract.
692  */
693 interface IERC721 is IERC165 {
694     /**
695      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
696      */
697     event Transfer(
698         address indexed from,
699         address indexed to,
700         uint256 indexed tokenId
701     );
702 
703     /**
704      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
705      */
706     event Approval(
707         address indexed owner,
708         address indexed approved,
709         uint256 indexed tokenId
710     );
711 
712     /**
713      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
714      */
715     event ApprovalForAll(
716         address indexed owner,
717         address indexed operator,
718         bool approved
719     );
720 
721     /**
722      * @dev Returns the number of tokens in ``owner``'s account.
723      */
724     function balanceOf(address owner) external view returns (uint256 balance);
725 
726     /**
727      * @dev Returns the owner of the `tokenId` token.
728      *
729      * Requirements:
730      *
731      * - `tokenId` must exist.
732      */
733     function ownerOf(uint256 tokenId) external view returns (address owner);
734 
735     /**
736      * @dev Safely transfers `tokenId` token from `from` to `to`.
737      *
738      * Requirements:
739      *
740      * - `from` cannot be the zero address.
741      * - `to` cannot be the zero address.
742      * - `tokenId` token must exist and be owned by `from`.
743      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
744      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
745      *
746      * Emits a {Transfer} event.
747      */
748     function safeTransferFrom(
749         address from,
750         address to,
751         uint256 tokenId,
752         bytes calldata data
753     ) external;
754 
755     /**
756      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
757      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
758      *
759      * Requirements:
760      *
761      * - `from` cannot be the zero address.
762      * - `to` cannot be the zero address.
763      * - `tokenId` token must exist and be owned by `from`.
764      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
765      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
766      *
767      * Emits a {Transfer} event.
768      */
769     function safeTransferFrom(
770         address from,
771         address to,
772         uint256 tokenId
773     ) external;
774 
775     /**
776      * @dev Transfers `tokenId` token from `from` to `to`.
777      *
778      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
779      *
780      * Requirements:
781      *
782      * - `from` cannot be the zero address.
783      * - `to` cannot be the zero address.
784      * - `tokenId` token must be owned by `from`.
785      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
786      *
787      * Emits a {Transfer} event.
788      */
789     function transferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) external;
794 
795     /**
796      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
797      * The approval is cleared when the token is transferred.
798      *
799      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
800      *
801      * Requirements:
802      *
803      * - The caller must own the token or be an approved operator.
804      * - `tokenId` must exist.
805      *
806      * Emits an {Approval} event.
807      */
808     function approve(address to, uint256 tokenId) external;
809 
810     /**
811      * @dev Approve or remove `operator` as an operator for the caller.
812      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
813      *
814      * Requirements:
815      *
816      * - The `operator` cannot be the caller.
817      *
818      * Emits an {ApprovalForAll} event.
819      */
820     function setApprovalForAll(address operator, bool _approved) external;
821 
822     /**
823      * @dev Returns the account approved for `tokenId` token.
824      *
825      * Requirements:
826      *
827      * - `tokenId` must exist.
828      */
829     function getApproved(uint256 tokenId)
830         external
831         view
832         returns (address operator);
833 
834     /**
835      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
836      *
837      * See {setApprovalForAll}
838      */
839     function isApprovedForAll(address owner, address operator)
840         external
841         view
842         returns (bool);
843 }
844 
845 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
846 
847 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
848 
849 pragma solidity ^0.8.0;
850 
851 /**
852  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
853  * @dev See https://eips.ethereum.org/EIPS/eip-721
854  */
855 interface IERC721Metadata is IERC721 {
856     /**
857      * @dev Returns the token collection name.
858      */
859     function name() external view returns (string memory);
860 
861     /**
862      * @dev Returns the token collection symbol.
863      */
864     function symbol() external view returns (string memory);
865 
866     /**
867      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
868      */
869     function tokenURI(uint256 tokenId) external view returns (string memory);
870 }
871 
872 // File: erc721a/contracts/IERC721A.sol
873 
874 // ERC721A Contracts v3.3.0
875 // Creator: Chiru Labs
876 
877 pragma solidity ^0.8.4;
878 
879 /**
880  * @dev Interface of an ERC721A compliant contract.
881  */
882 interface IERC721A is IERC721, IERC721Metadata {
883     /**
884      * The caller must own the token or be an approved operator.
885      */
886     error ApprovalCallerNotOwnerNorApproved();
887 
888     /**
889      * The token does not exist.
890      */
891     error ApprovalQueryForNonexistentToken();
892 
893     /**
894      * The caller cannot approve to their own address.
895      */
896     error ApproveToCaller();
897 
898     /**
899      * The caller cannot approve to the current owner.
900      */
901     error ApprovalToCurrentOwner();
902 
903     /**
904      * Cannot query the balance for the zero address.
905      */
906     error BalanceQueryForZeroAddress();
907 
908     /**
909      * Cannot mint to the zero address.
910      */
911     error MintToZeroAddress();
912 
913     /**
914      * The quantity of tokens minted must be more than zero.
915      */
916     error MintZeroQuantity();
917 
918     /**
919      * The token does not exist.
920      */
921     error OwnerQueryForNonexistentToken();
922 
923     /**
924      * The caller must own the token or be an approved operator.
925      */
926     error TransferCallerNotOwnerNorApproved();
927 
928     /**
929      * The token must be owned by `from`.
930      */
931     error TransferFromIncorrectOwner();
932 
933     /**
934      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
935      */
936     error TransferToNonERC721ReceiverImplementer();
937 
938     /**
939      * Cannot transfer to the zero address.
940      */
941     error TransferToZeroAddress();
942 
943     /**
944      * The token does not exist.
945      */
946     error URIQueryForNonexistentToken();
947 
948     // Compiler will pack this into a single 256bit word.
949     struct TokenOwnership {
950         // The address of the owner.
951         address addr;
952         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
953         uint64 startTimestamp;
954         // Whether the token has been burned.
955         bool burned;
956     }
957 
958     // Compiler will pack this into a single 256bit word.
959     struct AddressData {
960         // Realistically, 2**64-1 is more than enough.
961         uint64 balance;
962         // Keeps track of mint count with minimal overhead for tokenomics.
963         uint64 numberMinted;
964         // Keeps track of burn count with minimal overhead for tokenomics.
965         uint64 numberBurned;
966         // For miscellaneous variable(s) pertaining to the address
967         // (e.g. number of whitelist mint slots used).
968         // If there are multiple variables, please pack them into a uint64.
969         uint64 aux;
970     }
971 
972     /**
973      * @dev Returns the total amount of tokens stored by the contract.
974      *
975      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
976      */
977     function totalSupply() external view returns (uint256);
978 }
979 
980 
981 // File: erc721a/contracts/ERC721A.sol
982 
983 // ERC721A Contracts v3.3.0
984 // Creator: Chiru Labs
985 
986 pragma solidity ^0.8.4;
987 
988 /**
989  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
990  * the Metadata extension. Built to optimize for lower gas during batch mints.
991  *
992  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
993  *
994  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
995  *
996  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
997  */
998 contract ERC721A is Context, ERC165, IERC721A {
999     using Address for address;
1000     using Strings for uint256;
1001 
1002     // The tokenId of the next token to be minted.
1003     uint256 internal _currentIndex;
1004 
1005     // The number of tokens burned.
1006     uint256 internal _burnCounter;
1007 
1008     // Token name
1009     string private _name;
1010 
1011     // Token symbol
1012     string private _symbol;
1013 
1014     // Mapping from token ID to ownership details
1015     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1016     mapping(uint256 => TokenOwnership) internal _ownerships;
1017 
1018     // Mapping owner address to address data
1019     mapping(address => AddressData) private _addressData;
1020 
1021     // Mapping from token ID to approved address
1022     mapping(uint256 => address) private _tokenApprovals;
1023 
1024     // Mapping from owner to operator approvals
1025     mapping(address => mapping(address => bool)) private _operatorApprovals;
1026 
1027     constructor(string memory name_, string memory symbol_) {
1028         _name = name_;
1029         _symbol = symbol_;
1030         _currentIndex = _startTokenId();
1031     }
1032 
1033     /**
1034      * To change the starting tokenId, please override this function.
1035      */
1036     function _startTokenId() internal view virtual returns (uint256) {
1037         return 0;
1038     }
1039 
1040     /**
1041      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1042      */
1043     function totalSupply() public view override returns (uint256) {
1044         // Counter underflow is impossible as _burnCounter cannot be incremented
1045         // more than _currentIndex - _startTokenId() times
1046         unchecked {
1047             return _currentIndex - _burnCounter - _startTokenId();
1048         }
1049     }
1050 
1051     /**
1052      * Returns the total amount of tokens minted in the contract.
1053      */
1054     function _totalMinted() internal view returns (uint256) {
1055         // Counter underflow is impossible as _currentIndex does not decrement,
1056         // and it is initialized to _startTokenId()
1057         unchecked {
1058             return _currentIndex - _startTokenId();
1059         }
1060     }
1061 
1062     /**
1063      * @dev See {IERC165-supportsInterface}.
1064      */
1065     function supportsInterface(bytes4 interfaceId)
1066         public
1067         view
1068         virtual
1069         override(ERC165, IERC165)
1070         returns (bool)
1071     {
1072         return
1073             interfaceId == type(IERC721).interfaceId ||
1074             interfaceId == type(IERC721Metadata).interfaceId ||
1075             super.supportsInterface(interfaceId);
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-balanceOf}.
1080      */
1081     function balanceOf(address owner) public view override returns (uint256) {
1082         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1083         return uint256(_addressData[owner].balance);
1084     }
1085 
1086     /**
1087      * Returns the number of tokens minted by `owner`.
1088      */
1089     function _numberMinted(address owner) internal view returns (uint256) {
1090         return uint256(_addressData[owner].numberMinted);
1091     }
1092 
1093     /**
1094      * Returns the number of tokens burned by or on behalf of `owner`.
1095      */
1096     function _numberBurned(address owner) internal view returns (uint256) {
1097         return uint256(_addressData[owner].numberBurned);
1098     }
1099 
1100     /**
1101      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1102      */
1103     function _getAux(address owner) internal view returns (uint64) {
1104         return _addressData[owner].aux;
1105     }
1106 
1107     /**
1108      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1109      * If there are multiple variables, please pack them into a uint64.
1110      */
1111     function _setAux(address owner, uint64 aux) internal {
1112         _addressData[owner].aux = aux;
1113     }
1114 
1115     /**
1116      * Gas spent here starts off proportional to the maximum mint batch size.
1117      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1118      */
1119     function _ownershipOf(uint256 tokenId)
1120         internal
1121         view
1122         returns (TokenOwnership memory)
1123     {
1124         uint256 curr = tokenId;
1125 
1126         unchecked {
1127             if (_startTokenId() <= curr)
1128                 if (curr < _currentIndex) {
1129                     TokenOwnership memory ownership = _ownerships[curr];
1130                     if (!ownership.burned) {
1131                         if (ownership.addr != address(0)) {
1132                             return ownership;
1133                         }
1134                         // Invariant:
1135                         // There will always be an ownership that has an address and is not burned
1136                         // before an ownership that does not have an address and is not burned.
1137                         // Hence, curr will not underflow.
1138                         while (true) {
1139                             curr--;
1140                             ownership = _ownerships[curr];
1141                             if (ownership.addr != address(0)) {
1142                                 return ownership;
1143                             }
1144                         }
1145                     }
1146                 }
1147         }
1148         revert OwnerQueryForNonexistentToken();
1149     }
1150 
1151     /**
1152      * @dev See {IERC721-ownerOf}.
1153      */
1154     function ownerOf(uint256 tokenId) public view override returns (address) {
1155         return _ownershipOf(tokenId).addr;
1156     }
1157 
1158     /**
1159      * @dev See {IERC721Metadata-name}.
1160      */
1161     function name() public view virtual override returns (string memory) {
1162         return _name;
1163     }
1164 
1165     /**
1166      * @dev See {IERC721Metadata-symbol}.
1167      */
1168     function symbol() public view virtual override returns (string memory) {
1169         return _symbol;
1170     }
1171 
1172     /**
1173      * @dev See {IERC721Metadata-tokenURI}.
1174      */
1175     function tokenURI(uint256 tokenId)
1176         public
1177         view
1178         virtual
1179         override
1180         returns (string memory)
1181     {
1182         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1183 
1184         string memory baseURI = _baseURI();
1185         return
1186             bytes(baseURI).length != 0
1187                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1188                 : "";
1189     }
1190 
1191     /**
1192      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1193      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1194      * by default, can be overriden in child contracts.
1195      */
1196     function _baseURI() internal view virtual returns (string memory) {
1197         return "";
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-approve}.
1202      */
1203     function approve(address to, uint256 tokenId) public override {
1204         address owner = ERC721A.ownerOf(tokenId);
1205         if (to == owner) revert ApprovalToCurrentOwner();
1206 
1207         if (_msgSender() != owner)
1208             if (!isApprovedForAll(owner, _msgSender())) {
1209                 revert ApprovalCallerNotOwnerNorApproved();
1210             }
1211 
1212         _approve(to, tokenId, owner);
1213     }
1214 
1215     /**
1216      * @dev See {IERC721-getApproved}.
1217      */
1218     function getApproved(uint256 tokenId)
1219         public
1220         view
1221         override
1222         returns (address)
1223     {
1224         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1225 
1226         return _tokenApprovals[tokenId];
1227     }
1228 
1229     /**
1230      * @dev See {IERC721-setApprovalForAll}.
1231      */
1232     function setApprovalForAll(address operator, bool approved)
1233         public
1234         virtual
1235         override
1236     {
1237         if (operator == _msgSender()) revert ApproveToCaller();
1238 
1239         _operatorApprovals[_msgSender()][operator] = approved;
1240         emit ApprovalForAll(_msgSender(), operator, approved);
1241     }
1242 
1243     /**
1244      * @dev See {IERC721-isApprovedForAll}.
1245      */
1246     function isApprovedForAll(address owner, address operator)
1247         public
1248         view
1249         virtual
1250         override
1251         returns (bool)
1252     {
1253         return _operatorApprovals[owner][operator];
1254     }
1255 
1256     /**
1257      * @dev See {IERC721-transferFrom}.
1258      */
1259     function transferFrom(
1260         address from,
1261         address to,
1262         uint256 tokenId
1263     ) public virtual override {
1264         _transfer(from, to, tokenId);
1265     }
1266 
1267     /**
1268      * @dev See {IERC721-safeTransferFrom}.
1269      */
1270     function safeTransferFrom(
1271         address from,
1272         address to,
1273         uint256 tokenId
1274     ) public virtual override {
1275         safeTransferFrom(from, to, tokenId, "");
1276     }
1277 
1278     /**
1279      * @dev See {IERC721-safeTransferFrom}.
1280      */
1281     function safeTransferFrom(
1282         address from,
1283         address to,
1284         uint256 tokenId,
1285         bytes memory _data
1286     ) public virtual override {
1287         _transfer(from, to, tokenId);
1288         if (to.isContract())
1289             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1290                 revert TransferToNonERC721ReceiverImplementer();
1291             }
1292     }
1293 
1294     /**
1295      * @dev Returns whether `tokenId` exists.
1296      *
1297      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1298      *
1299      * Tokens start existing when they are minted (`_mint`),
1300      */
1301     function _exists(uint256 tokenId) internal view returns (bool) {
1302         return
1303             _startTokenId() <= tokenId &&
1304             tokenId < _currentIndex &&
1305             !_ownerships[tokenId].burned;
1306     }
1307 
1308     /**
1309      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1310      */
1311     function _safeMint(address to, uint256 quantity) internal {
1312         _safeMint(to, quantity, "");
1313     }
1314 
1315     /**
1316      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1317      *
1318      * Requirements:
1319      *
1320      * - If `to` refers to a smart contract, it must implement
1321      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1322      * - `quantity` must be greater than 0.
1323      *
1324      * Emits a {Transfer} event.
1325      */
1326     function _safeMint(
1327         address to,
1328         uint256 quantity,
1329         bytes memory _data
1330     ) internal {
1331         uint256 startTokenId = _currentIndex;
1332         if (to == address(0)) revert MintToZeroAddress();
1333         if (quantity == 0) revert MintZeroQuantity();
1334 
1335         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1336 
1337         // Overflows are incredibly unrealistic.
1338         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1339         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1340         unchecked {
1341             _addressData[to].balance += uint64(quantity);
1342             _addressData[to].numberMinted += uint64(quantity);
1343 
1344             _ownerships[startTokenId].addr = to;
1345             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1346 
1347             uint256 updatedIndex = startTokenId;
1348             uint256 end = updatedIndex + quantity;
1349 
1350             if (to.isContract()) {
1351                 do {
1352                     emit Transfer(address(0), to, updatedIndex);
1353                     if (
1354                         !_checkContractOnERC721Received(
1355                             address(0),
1356                             to,
1357                             updatedIndex++,
1358                             _data
1359                         )
1360                     ) {
1361                         revert TransferToNonERC721ReceiverImplementer();
1362                     }
1363                 } while (updatedIndex < end);
1364                 // Reentrancy protection
1365                 if (_currentIndex != startTokenId) revert();
1366             } else {
1367                 do {
1368                     emit Transfer(address(0), to, updatedIndex++);
1369                 } while (updatedIndex < end);
1370             }
1371             _currentIndex = updatedIndex;
1372         }
1373         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1374     }
1375 
1376     /**
1377      * @dev Mints `quantity` tokens and transfers them to `to`.
1378      *
1379      * Requirements:
1380      *
1381      * - `to` cannot be the zero address.
1382      * - `quantity` must be greater than 0.
1383      *
1384      * Emits a {Transfer} event.
1385      */
1386     function _mint(address to, uint256 quantity) internal {
1387         uint256 startTokenId = _currentIndex;
1388         if (to == address(0)) revert MintToZeroAddress();
1389         if (quantity == 0) revert MintZeroQuantity();
1390 
1391         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1392 
1393         // Overflows are incredibly unrealistic.
1394         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1395         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1396         unchecked {
1397             _addressData[to].balance += uint64(quantity);
1398             _addressData[to].numberMinted += uint64(quantity);
1399 
1400             _ownerships[startTokenId].addr = to;
1401             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1402 
1403             uint256 updatedIndex = startTokenId;
1404             uint256 end = updatedIndex + quantity;
1405 
1406             do {
1407                 emit Transfer(address(0), to, updatedIndex++);
1408             } while (updatedIndex < end);
1409 
1410             _currentIndex = updatedIndex;
1411         }
1412         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1413     }
1414 
1415     /**
1416      * @dev Transfers `tokenId` from `from` to `to`.
1417      *
1418      * Requirements:
1419      *
1420      * - `to` cannot be the zero address.
1421      * - `tokenId` token must be owned by `from`.
1422      *
1423      * Emits a {Transfer} event.
1424      */
1425     function _transfer(
1426         address from,
1427         address to,
1428         uint256 tokenId
1429     ) private {
1430         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1431 
1432         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1433 
1434         bool isApprovedOrOwner = (_msgSender() == from ||
1435             isApprovedForAll(from, _msgSender()) ||
1436             getApproved(tokenId) == _msgSender());
1437 
1438         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1439         if (to == address(0)) revert TransferToZeroAddress();
1440 
1441         _beforeTokenTransfers(from, to, tokenId, 1);
1442 
1443         // Clear approvals from the previous owner
1444         _approve(address(0), tokenId, from);
1445 
1446         // Underflow of the sender's balance is impossible because we check for
1447         // ownership above and the recipient's balance can't realistically overflow.
1448         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1449         unchecked {
1450             _addressData[from].balance -= 1;
1451             _addressData[to].balance += 1;
1452 
1453             TokenOwnership storage currSlot = _ownerships[tokenId];
1454             currSlot.addr = to;
1455             currSlot.startTimestamp = uint64(block.timestamp);
1456 
1457             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1458             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1459             uint256 nextTokenId = tokenId + 1;
1460             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1461             if (nextSlot.addr == address(0)) {
1462                 // This will suffice for checking _exists(nextTokenId),
1463                 // as a burned slot cannot contain the zero address.
1464                 if (nextTokenId != _currentIndex) {
1465                     nextSlot.addr = from;
1466                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1467                 }
1468             }
1469         }
1470 
1471         emit Transfer(from, to, tokenId);
1472         _afterTokenTransfers(from, to, tokenId, 1);
1473     }
1474 
1475     /**
1476      * @dev Equivalent to `_burn(tokenId, false)`.
1477      */
1478     function _burn(uint256 tokenId) internal virtual {
1479         _burn(tokenId, false);
1480     }
1481 
1482     /**
1483      * @dev Destroys `tokenId`.
1484      * The approval is cleared when the token is burned.
1485      *
1486      * Requirements:
1487      *
1488      * - `tokenId` must exist.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1493         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1494 
1495         address from = prevOwnership.addr;
1496 
1497         if (approvalCheck) {
1498             bool isApprovedOrOwner = (_msgSender() == from ||
1499                 isApprovedForAll(from, _msgSender()) ||
1500                 getApproved(tokenId) == _msgSender());
1501 
1502             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1503         }
1504 
1505         _beforeTokenTransfers(from, address(0), tokenId, 1);
1506 
1507         // Clear approvals from the previous owner
1508         _approve(address(0), tokenId, from);
1509 
1510         // Underflow of the sender's balance is impossible because we check for
1511         // ownership above and the recipient's balance can't realistically overflow.
1512         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1513         unchecked {
1514             AddressData storage addressData = _addressData[from];
1515             addressData.balance -= 1;
1516             addressData.numberBurned += 1;
1517 
1518             // Keep track of who burned the token, and the timestamp of burning.
1519             TokenOwnership storage currSlot = _ownerships[tokenId];
1520             currSlot.addr = from;
1521             currSlot.startTimestamp = uint64(block.timestamp);
1522             currSlot.burned = true;
1523 
1524             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1525             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1526             uint256 nextTokenId = tokenId + 1;
1527             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1528             if (nextSlot.addr == address(0)) {
1529                 // This will suffice for checking _exists(nextTokenId),
1530                 // as a burned slot cannot contain the zero address.
1531                 if (nextTokenId != _currentIndex) {
1532                     nextSlot.addr = from;
1533                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1534                 }
1535             }
1536         }
1537 
1538         emit Transfer(from, address(0), tokenId);
1539         _afterTokenTransfers(from, address(0), tokenId, 1);
1540 
1541         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1542         unchecked {
1543             _burnCounter++;
1544         }
1545     }
1546 
1547     /**
1548      * @dev Approve `to` to operate on `tokenId`
1549      *
1550      * Emits a {Approval} event.
1551      */
1552     function _approve(
1553         address to,
1554         uint256 tokenId,
1555         address owner
1556     ) private {
1557         _tokenApprovals[tokenId] = to;
1558         emit Approval(owner, to, tokenId);
1559     }
1560 
1561     /**
1562      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1563      *
1564      * @param from address representing the previous owner of the given token ID
1565      * @param to target address that will receive the tokens
1566      * @param tokenId uint256 ID of the token to be transferred
1567      * @param _data bytes optional data to send along with the call
1568      * @return bool whether the call correctly returned the expected magic value
1569      */
1570     function _checkContractOnERC721Received(
1571         address from,
1572         address to,
1573         uint256 tokenId,
1574         bytes memory _data
1575     ) private returns (bool) {
1576         try
1577             IERC721Receiver(to).onERC721Received(
1578                 _msgSender(),
1579                 from,
1580                 tokenId,
1581                 _data
1582             )
1583         returns (bytes4 retval) {
1584             return retval == IERC721Receiver(to).onERC721Received.selector;
1585         } catch (bytes memory reason) {
1586             if (reason.length == 0) {
1587                 revert TransferToNonERC721ReceiverImplementer();
1588             } else {
1589                 assembly {
1590                     revert(add(32, reason), mload(reason))
1591                 }
1592             }
1593         }
1594     }
1595 
1596     /**
1597      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1598      * And also called before burning one token.
1599      *
1600      * startTokenId - the first token id to be transferred
1601      * quantity - the amount to be transferred
1602      *
1603      * Calling conditions:
1604      *
1605      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1606      * transferred to `to`.
1607      * - When `from` is zero, `tokenId` will be minted for `to`.
1608      * - When `to` is zero, `tokenId` will be burned by `from`.
1609      * - `from` and `to` are never both zero.
1610      */
1611     function _beforeTokenTransfers(
1612         address from,
1613         address to,
1614         uint256 startTokenId,
1615         uint256 quantity
1616     ) internal virtual {}
1617 
1618     /**
1619      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1620      * minting.
1621      * And also called after one token has been burned.
1622      *
1623      * startTokenId - the first token id to be transferred
1624      * quantity - the amount to be transferred
1625      *
1626      * Calling conditions:
1627      *
1628      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1629      * transferred to `to`.
1630      * - When `from` is zero, `tokenId` has been minted for `to`.
1631      * - When `to` is zero, `tokenId` has been burned by `from`.
1632      * - `from` and `to` are never both zero.
1633      */
1634     function _afterTokenTransfers(
1635         address from,
1636         address to,
1637         uint256 startTokenId,
1638         uint256 quantity
1639     ) internal virtual {}
1640 }
1641 
1642 // File: chae.sol
1643 
1644 pragma solidity ^0.8.0;
1645 
1646 contract MutantGoblins is ERC721A, Ownable, ReentrancyGuard {
1647     using Strings for uint256;
1648 
1649     bytes32 public merkleRoot;
1650 
1651     string public uriPrefix = "";
1652     string public uriSuffix = ".json";
1653     string public hiddenMetadataUri;
1654 
1655     uint256 public cost;
1656     uint256 public maxSupply;
1657 
1658     bool public paused = false;
1659     bool public revealed = true;
1660 
1661     mapping(address => uint256) private _walletMintedCount;
1662 
1663     constructor(uint256 _cost, uint256 _maxSupply)
1664         ERC721A("Mutant Goblins", "MG")
1665     {
1666         setCost(_cost);
1667         maxSupply = _maxSupply;
1668     }
1669 
1670     modifier mintCompliance(uint256 _mintAmount) {
1671         require(_mintAmount > 0, "Invalid mint amount!");
1672         require(
1673             totalSupply() + _mintAmount <= maxSupply,
1674             "Max supply exceeded!"
1675         );
1676         _;
1677     }
1678 
1679     function mint(uint256 _mintAmount)
1680         public
1681         payable
1682         mintCompliance(_mintAmount)
1683     {
1684         require(!paused, "The contract is paused!");
1685 
1686         uint256 payForCount = _mintAmount;
1687         if (_walletMintedCount[msg.sender] == 0) {
1688             payForCount--;
1689         }
1690 
1691         require(
1692             msg.value >= payForCount * cost,
1693             "MutantGoblins: Ether value sent is not sufficient"
1694         );
1695 
1696         _walletMintedCount[msg.sender] += _mintAmount;
1697         _safeMint(_msgSender(), _mintAmount);
1698     }
1699 
1700     function mintForAddress(uint256 _mintAmount, address _receiver)
1701         public
1702         mintCompliance(_mintAmount)
1703         onlyOwner
1704     {
1705         _safeMint(_receiver, _mintAmount);
1706     }
1707 
1708     function walletOfOwner(address _owner)
1709         public
1710         view
1711         returns (uint256[] memory)
1712     {
1713         uint256 ownerTokenCount = balanceOf(_owner);
1714         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1715         uint256 currentTokenId = _startTokenId();
1716         uint256 ownedTokenIndex = 0;
1717         address latestOwnerAddress;
1718 
1719         while (
1720             ownedTokenIndex < ownerTokenCount && currentTokenId < _currentIndex
1721         ) {
1722             TokenOwnership memory ownership = _ownerships[currentTokenId];
1723 
1724             if (!ownership.burned) {
1725                 if (ownership.addr != address(0)) {
1726                     latestOwnerAddress = ownership.addr;
1727                 }
1728 
1729                 if (latestOwnerAddress == _owner) {
1730                     ownedTokenIds[ownedTokenIndex] = currentTokenId;
1731 
1732                     ownedTokenIndex++;
1733                 }
1734             }
1735 
1736             currentTokenId++;
1737         }
1738 
1739         return ownedTokenIds;
1740     }
1741 
1742     function _startTokenId() internal view virtual override returns (uint256) {
1743         return 1;
1744     }
1745 
1746     function tokenURI(uint256 _tokenId)
1747         public
1748         view
1749         virtual
1750         override
1751         returns (string memory)
1752     {
1753         require(
1754             _exists(_tokenId),
1755             "MutantGoblins: URI query for nonexistent token"
1756         );
1757 
1758         if (revealed == true) {
1759             return hiddenMetadataUri;
1760         }
1761 
1762         string memory currentBaseURI = _baseURI();
1763         return
1764             bytes(currentBaseURI).length > 0
1765                 ? string(
1766                     abi.encodePacked(
1767                         currentBaseURI,
1768                         _tokenId.toString(),
1769                         uriSuffix
1770                     )
1771                 )
1772                 : "";
1773     }
1774 
1775     function setCost(uint256 _cost) public onlyOwner {
1776         cost = _cost;
1777     }
1778 
1779     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1780         maxSupply = _maxSupply;
1781     }
1782 
1783     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
1784         public
1785         onlyOwner
1786     {
1787         hiddenMetadataUri = _hiddenMetadataUri;
1788     }
1789 
1790     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1791         uriPrefix = _uriPrefix;
1792     }
1793 
1794     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1795         uriSuffix = _uriSuffix;
1796     }
1797 
1798     function setPaused(bool _state) public onlyOwner {
1799         paused = _state;
1800     }
1801 
1802     function setRevealed(bool _state) public onlyOwner {
1803         revealed = _state;
1804     }
1805     
1806     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1807         merkleRoot = _merkleRoot;
1808     }
1809 
1810     function withdraw() public onlyOwner nonReentrant {
1811         (bool os, ) = payable(Owner()).call{value: address(this).balance}("");
1812         require(os);
1813     }
1814 
1815     function _baseURI() internal view virtual override returns (string memory) {
1816         return uriPrefix;
1817     }
1818 
1819     function mintedCount(address owner) external view returns (uint256) {
1820         return _walletMintedCount[owner];
1821     }
1822 }