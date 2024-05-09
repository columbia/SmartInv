1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
105     function processProof(bytes32[] memory proof, bytes32 leaf)
106         internal
107         pure
108         returns (bytes32)
109     {
110         bytes32 computedHash = leaf;
111         for (uint256 i = 0; i < proof.length; i++) {
112             bytes32 proofElement = proof[i];
113             if (computedHash <= proofElement) {
114                 // Hash(current computed hash + current element of the proof)
115                 computedHash = _efficientHash(computedHash, proofElement);
116             } else {
117                 // Hash(current element of the proof + current computed hash)
118                 computedHash = _efficientHash(proofElement, computedHash);
119             }
120         }
121         return computedHash;
122     }
123 
124     function _efficientHash(bytes32 a, bytes32 b)
125         private
126         pure
127         returns (bytes32 value)
128     {
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
193     function toHexString(uint256 value, uint256 length)
194         internal
195         pure
196         returns (string memory)
197     {
198         bytes memory buffer = new bytes(2 * length + 2);
199         buffer[0] = "0";
200         buffer[1] = "x";
201         for (uint256 i = 2 * length + 1; i > 1; --i) {
202             buffer[i] = _HEX_SYMBOLS[value & 0xf];
203             value >>= 4;
204         }
205         require(value == 0, "Strings: hex length insufficient");
206         return string(buffer);
207     }
208 }
209 
210 // File: @openzeppelin/contracts/utils/Context.sol
211 
212 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
213 
214 pragma solidity ^0.8.0;
215 
216 /**
217  * @dev Provides information about the current execution context, including the
218  * sender of the transaction and its data. While these are generally available
219  * via msg.sender and msg.data, they should not be accessed in such a direct
220  * manner, since when dealing with meta-transactions the account sending and
221  * paying for execution may not be the actual sender (as far as an application
222  * is concerned).
223  *
224  * This contract is only required for intermediate, library-like contracts.
225  */
226 abstract contract Context {
227     function _msgSender() internal view virtual returns (address) {
228         return msg.sender;
229     }
230 
231     function _msgData() internal view virtual returns (bytes calldata) {
232         return msg.data;
233     }
234 }
235 
236 // File: @openzeppelin/contracts/access/Ownable.sol
237 
238 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
239 
240 pragma solidity ^0.8.0;
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
257     event OwnershipTransferred(
258         address indexed previousOwner,
259         address indexed newOwner
260     );
261 
262     /**
263      * @dev Initializes the contract setting the deployer as the initial owner.
264      */
265     constructor() {
266         _transferOwnership(_msgSender());
267     }
268 
269     /**
270      * @dev Returns the address of the current owner.
271      */
272     function owner() public view virtual returns (address) {
273         return _owner;
274     }
275 
276     /**
277      * @dev Throws if called by any account other than the owner.
278      */
279     modifier onlyOwner() {
280         require(owner() == _msgSender(), "Ownable: caller is not the owner");
281         _;
282     }
283 
284     /**
285      * @dev Leaves the contract without owner. It will not be possible to call
286      * `onlyOwner` functions anymore. Can only be called by the current owner.
287      *
288      * NOTE: Renouncing ownership will leave the contract without an owner,
289      * thereby removing any functionality that is only available to the owner.
290      */
291     function renounceOwnership() public virtual onlyOwner {
292         _transferOwnership(address(0));
293     }
294 
295     /**
296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
297      * Can only be called by the current owner.
298      */
299     function transferOwnership(address newOwner) public virtual onlyOwner {
300         require(
301             newOwner != address(0),
302             "Ownable: new owner is the zero address"
303         );
304         _transferOwnership(newOwner);
305     }
306 
307     /**
308      * @dev Transfers ownership of the contract to a new account (`newOwner`).
309      * Internal function without access restriction.
310      */
311     function _transferOwnership(address newOwner) internal virtual {
312         address oldOwner = _owner;
313         _owner = newOwner;
314         emit OwnershipTransferred(oldOwner, newOwner);
315     }
316 }
317 
318 // File: @openzeppelin/contracts/utils/Address.sol
319 
320 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
321 
322 pragma solidity ^0.8.1;
323 
324 /**
325  * @dev Collection of functions related to the address type
326  */
327 library Address {
328     /**
329      * @dev Returns true if `account` is a contract.
330      *
331      * [IMPORTANT]
332      * ====
333      * It is unsafe to assume that an address for which this function returns
334      * false is an externally-owned account (EOA) and not a contract.
335      *
336      * Among others, `isContract` will return false for the following
337      * types of addresses:
338      *
339      *  - an externally-owned account
340      *  - a contract in construction
341      *  - an address where a contract will be created
342      *  - an address where a contract lived, but was destroyed
343      * ====
344      *
345      * [IMPORTANT]
346      * ====
347      * You shouldn't rely on `isContract` to protect against flash loan attacks!
348      *
349      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
350      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
351      * constructor.
352      * ====
353      */
354     function isContract(address account) internal view returns (bool) {
355         // This method relies on extcodesize/address.code.length, which returns 0
356         // for contracts in construction, since the code is only stored at the end
357         // of the constructor execution.
358 
359         return account.code.length > 0;
360     }
361 
362     /**
363      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
364      * `recipient`, forwarding all available gas and reverting on errors.
365      *
366      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
367      * of certain opcodes, possibly making contracts go over the 2300 gas limit
368      * imposed by `transfer`, making them unable to receive funds via
369      * `transfer`. {sendValue} removes this limitation.
370      *
371      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
372      *
373      * IMPORTANT: because control is transferred to `recipient`, care must be
374      * taken to not create reentrancy vulnerabilities. Consider using
375      * {ReentrancyGuard} or the
376      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
377      */
378     function sendValue(address payable recipient, uint256 amount) internal {
379         require(
380             address(this).balance >= amount,
381             "Address: insufficient balance"
382         );
383 
384         (bool success, ) = recipient.call{value: amount}("");
385         require(
386             success,
387             "Address: unable to send value, recipient may have reverted"
388         );
389     }
390 
391     /**
392      * @dev Performs a Solidity function call using a low level `call`. A
393      * plain `call` is an unsafe replacement for a function call: use this
394      * function instead.
395      *
396      * If `target` reverts with a revert reason, it is bubbled up by this
397      * function (like regular Solidity function calls).
398      *
399      * Returns the raw returned data. To convert to the expected return value,
400      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
401      *
402      * Requirements:
403      *
404      * - `target` must be a contract.
405      * - calling `target` with `data` must not revert.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(address target, bytes memory data)
410         internal
411         returns (bytes memory)
412     {
413         return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(
423         address target,
424         bytes memory data,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         return functionCallWithValue(target, data, 0, errorMessage);
428     }
429 
430     /**
431      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
432      * but also transferring `value` wei to `target`.
433      *
434      * Requirements:
435      *
436      * - the calling contract must have an ETH balance of at least `value`.
437      * - the called Solidity function must be `payable`.
438      *
439      * _Available since v3.1._
440      */
441     function functionCallWithValue(
442         address target,
443         bytes memory data,
444         uint256 value
445     ) internal returns (bytes memory) {
446         return
447             functionCallWithValue(
448                 target,
449                 data,
450                 value,
451                 "Address: low-level call with value failed"
452             );
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
457      * with `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCallWithValue(
462         address target,
463         bytes memory data,
464         uint256 value,
465         string memory errorMessage
466     ) internal returns (bytes memory) {
467         require(
468             address(this).balance >= value,
469             "Address: insufficient balance for call"
470         );
471         require(isContract(target), "Address: call to non-contract");
472 
473         (bool success, bytes memory returndata) = target.call{value: value}(
474             data
475         );
476         return verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a static call.
482      *
483      * _Available since v3.3._
484      */
485     function functionStaticCall(address target, bytes memory data)
486         internal
487         view
488         returns (bytes memory)
489     {
490         return
491             functionStaticCall(
492                 target,
493                 data,
494                 "Address: low-level static call failed"
495             );
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
500      * but performing a static call.
501      *
502      * _Available since v3.3._
503      */
504     function functionStaticCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal view returns (bytes memory) {
509         require(isContract(target), "Address: static call to non-contract");
510 
511         (bool success, bytes memory returndata) = target.staticcall(data);
512         return verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
517      * but performing a delegate call.
518      *
519      * _Available since v3.4._
520      */
521     function functionDelegateCall(address target, bytes memory data)
522         internal
523         returns (bytes memory)
524     {
525         return
526             functionDelegateCall(
527                 target,
528                 data,
529                 "Address: low-level delegate call failed"
530             );
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
535      * but performing a delegate call.
536      *
537      * _Available since v3.4._
538      */
539     function functionDelegateCall(
540         address target,
541         bytes memory data,
542         string memory errorMessage
543     ) internal returns (bytes memory) {
544         require(isContract(target), "Address: delegate call to non-contract");
545 
546         (bool success, bytes memory returndata) = target.delegatecall(data);
547         return verifyCallResult(success, returndata, errorMessage);
548     }
549 
550     /**
551      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
552      * revert reason using the provided one.
553      *
554      * _Available since v4.3._
555      */
556     function verifyCallResult(
557         bool success,
558         bytes memory returndata,
559         string memory errorMessage
560     ) internal pure returns (bytes memory) {
561         if (success) {
562             return returndata;
563         } else {
564             // Look for revert reason and bubble it up if present
565             if (returndata.length > 0) {
566                 // The easiest way to bubble the revert reason is using memory via assembly
567 
568                 assembly {
569                     let returndata_size := mload(returndata)
570                     revert(add(32, returndata), returndata_size)
571                 }
572             } else {
573                 revert(errorMessage);
574             }
575         }
576     }
577 }
578 
579 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
580 
581 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 /**
586  * @title ERC721 token receiver interface
587  * @dev Interface for any contract that wants to support safeTransfers
588  * from ERC721 asset contracts.
589  */
590 interface IERC721Receiver {
591     /**
592      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
593      * by `operator` from `from`, this function is called.
594      *
595      * It must return its Solidity selector to confirm the token transfer.
596      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
597      *
598      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
599      */
600     function onERC721Received(
601         address operator,
602         address from,
603         uint256 tokenId,
604         bytes calldata data
605     ) external returns (bytes4);
606 }
607 
608 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
609 
610 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
611 
612 pragma solidity ^0.8.0;
613 
614 /**
615  * @dev Interface of the ERC165 standard, as defined in the
616  * https://eips.ethereum.org/EIPS/eip-165[EIP].
617  *
618  * Implementers can declare support of contract interfaces, which can then be
619  * queried by others ({ERC165Checker}).
620  *
621  * For an implementation, see {ERC165}.
622  */
623 interface IERC165 {
624     /**
625      * @dev Returns true if this contract implements the interface defined by
626      * `interfaceId`. See the corresponding
627      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
628      * to learn more about how these ids are created.
629      *
630      * This function call must use less than 30 000 gas.
631      */
632     function supportsInterface(bytes4 interfaceId) external view returns (bool);
633 }
634 
635 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
636 
637 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 /**
642  * @dev Implementation of the {IERC165} interface.
643  *
644  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
645  * for the additional interface id that will be supported. For example:
646  *
647  * ```solidity
648  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
649  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
650  * }
651  * ```
652  *
653  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
654  */
655 abstract contract ERC165 is IERC165 {
656     /**
657      * @dev See {IERC165-supportsInterface}.
658      */
659     function supportsInterface(bytes4 interfaceId)
660         public
661         view
662         virtual
663         override
664         returns (bool)
665     {
666         return interfaceId == type(IERC165).interfaceId;
667     }
668 }
669 
670 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
671 
672 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev Required interface of an ERC721 compliant contract.
678  */
679 interface IERC721 is IERC165 {
680     /**
681      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
682      */
683     event Transfer(
684         address indexed from,
685         address indexed to,
686         uint256 indexed tokenId
687     );
688 
689     /**
690      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
691      */
692     event Approval(
693         address indexed owner,
694         address indexed approved,
695         uint256 indexed tokenId
696     );
697 
698     /**
699      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
700      */
701     event ApprovalForAll(
702         address indexed owner,
703         address indexed operator,
704         bool approved
705     );
706 
707     /**
708      * @dev Returns the number of tokens in ``owner``'s account.
709      */
710     function balanceOf(address owner) external view returns (uint256 balance);
711 
712     /**
713      * @dev Returns the owner of the `tokenId` token.
714      *
715      * Requirements:
716      *
717      * - `tokenId` must exist.
718      */
719     function ownerOf(uint256 tokenId) external view returns (address owner);
720 
721     /**
722      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
723      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
724      *
725      * Requirements:
726      *
727      * - `from` cannot be the zero address.
728      * - `to` cannot be the zero address.
729      * - `tokenId` token must exist and be owned by `from`.
730      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
731      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
732      *
733      * Emits a {Transfer} event.
734      */
735     function safeTransferFrom(
736         address from,
737         address to,
738         uint256 tokenId
739     ) external;
740 
741     /**
742      * @dev Transfers `tokenId` token from `from` to `to`.
743      *
744      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
745      *
746      * Requirements:
747      *
748      * - `from` cannot be the zero address.
749      * - `to` cannot be the zero address.
750      * - `tokenId` token must be owned by `from`.
751      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
752      *
753      * Emits a {Transfer} event.
754      */
755     function transferFrom(
756         address from,
757         address to,
758         uint256 tokenId
759     ) external;
760 
761     /**
762      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
763      * The approval is cleared when the token is transferred.
764      *
765      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
766      *
767      * Requirements:
768      *
769      * - The caller must own the token or be an approved operator.
770      * - `tokenId` must exist.
771      *
772      * Emits an {Approval} event.
773      */
774     function approve(address to, uint256 tokenId) external;
775 
776     /**
777      * @dev Returns the account approved for `tokenId` token.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function getApproved(uint256 tokenId)
784         external
785         view
786         returns (address operator);
787 
788     /**
789      * @dev Approve or remove `operator` as an operator for the caller.
790      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
791      *
792      * Requirements:
793      *
794      * - The `operator` cannot be the caller.
795      *
796      * Emits an {ApprovalForAll} event.
797      */
798     function setApprovalForAll(address operator, bool _approved) external;
799 
800     /**
801      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
802      *
803      * See {setApprovalForAll}
804      */
805     function isApprovedForAll(address owner, address operator)
806         external
807         view
808         returns (bool);
809 
810     /**
811      * @dev Safely transfers `tokenId` token from `from` to `to`.
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must exist and be owned by `from`.
818      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
819      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
820      *
821      * Emits a {Transfer} event.
822      */
823     function safeTransferFrom(
824         address from,
825         address to,
826         uint256 tokenId,
827         bytes calldata data
828     ) external;
829 }
830 
831 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
832 
833 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
834 
835 pragma solidity ^0.8.0;
836 
837 /**
838  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
839  * @dev See https://eips.ethereum.org/EIPS/eip-721
840  */
841 interface IERC721Metadata is IERC721 {
842     /**
843      * @dev Returns the token collection name.
844      */
845     function name() external view returns (string memory);
846 
847     /**
848      * @dev Returns the token collection symbol.
849      */
850     function symbol() external view returns (string memory);
851 
852     /**
853      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
854      */
855     function tokenURI(uint256 tokenId) external view returns (string memory);
856 }
857 
858 // File: erc721a/contracts/ERC721A.sol
859 
860 // Creator: Chiru Labs
861 
862 pragma solidity ^0.8.4;
863 
864 error ApprovalCallerNotOwnerNorApproved();
865 error ApprovalQueryForNonexistentToken();
866 error ApproveToCaller();
867 error ApprovalToCurrentOwner();
868 error BalanceQueryForZeroAddress();
869 error MintToZeroAddress();
870 error MintZeroQuantity();
871 error OwnerQueryForNonexistentToken();
872 error TransferCallerNotOwnerNorApproved();
873 error TransferFromIncorrectOwner();
874 error TransferToNonERC721ReceiverImplementer();
875 error TransferToZeroAddress();
876 error URIQueryForNonexistentToken();
877 
878 /**
879  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
880  * the Metadata extension. Built to optimize for lower gas during batch mints.
881  *
882  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
883  *
884  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
885  *
886  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
887  */
888 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
889     using Address for address;
890     using Strings for uint256;
891 
892     // Compiler will pack this into a single 256bit word.
893     struct TokenOwnership {
894         // The address of the owner.
895         address addr;
896         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
897         uint64 startTimestamp;
898         // Whether the token has been burned.
899         bool burned;
900     }
901 
902     // Compiler will pack this into a single 256bit word.
903     struct AddressData {
904         // Realistically, 2**64-1 is more than enough.
905         uint64 balance;
906         // Keeps track of mint count with minimal overhead for tokenomics.
907         uint64 numberMinted;
908         // Keeps track of burn count with minimal overhead for tokenomics.
909         uint64 numberBurned;
910         // For miscellaneous variable(s) pertaining to the address
911         // (e.g. number of whitelist mint slots used).
912         // If there are multiple variables, please pack them into a uint64.
913         uint64 aux;
914     }
915 
916     // The tokenId of the next token to be minted.
917     uint256 internal _currentIndex;
918 
919     // The number of tokens burned.
920     uint256 internal _burnCounter;
921 
922     // Token name
923     string private _name;
924 
925     // Token symbol
926     string private _symbol;
927 
928     // Mapping from token ID to ownership details
929     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
930     mapping(uint256 => TokenOwnership) internal _ownerships;
931 
932     // Mapping owner address to address data
933     mapping(address => AddressData) private _addressData;
934 
935     // Mapping from token ID to approved address
936     mapping(uint256 => address) private _tokenApprovals;
937 
938     // Mapping from owner to operator approvals
939     mapping(address => mapping(address => bool)) private _operatorApprovals;
940 
941     constructor(string memory name_, string memory symbol_) {
942         _name = name_;
943         _symbol = symbol_;
944         _currentIndex = _startTokenId();
945     }
946 
947     /**
948      * To change the starting tokenId, please override this function.
949      */
950     function _startTokenId() internal view virtual returns (uint256) {
951         return 0;
952     }
953 
954     /**
955      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
956      */
957     function totalSupply() public view returns (uint256) {
958         // Counter underflow is impossible as _burnCounter cannot be incremented
959         // more than _currentIndex - _startTokenId() times
960         unchecked {
961             return _currentIndex - _burnCounter - _startTokenId();
962         }
963     }
964 
965     /**
966      * Returns the total amount of tokens minted in the contract.
967      */
968     function _totalMinted() internal view returns (uint256) {
969         // Counter underflow is impossible as _currentIndex does not decrement,
970         // and it is initialized to _startTokenId()
971         unchecked {
972             return _currentIndex - _startTokenId();
973         }
974     }
975 
976     /**
977      * @dev See {IERC165-supportsInterface}.
978      */
979     function supportsInterface(bytes4 interfaceId)
980         public
981         view
982         virtual
983         override(ERC165, IERC165)
984         returns (bool)
985     {
986         return
987             interfaceId == type(IERC721).interfaceId ||
988             interfaceId == type(IERC721Metadata).interfaceId ||
989             super.supportsInterface(interfaceId);
990     }
991 
992     /**
993      * @dev See {IERC721-balanceOf}.
994      */
995     function balanceOf(address owner) public view override returns (uint256) {
996         if (owner == address(0)) revert BalanceQueryForZeroAddress();
997         return uint256(_addressData[owner].balance);
998     }
999 
1000     /**
1001      * Returns the number of tokens minted by `owner`.
1002      */
1003     function _numberMinted(address owner) internal view returns (uint256) {
1004         return uint256(_addressData[owner].numberMinted);
1005     }
1006 
1007     /**
1008      * Returns the number of tokens burned by or on behalf of `owner`.
1009      */
1010     function _numberBurned(address owner) internal view returns (uint256) {
1011         return uint256(_addressData[owner].numberBurned);
1012     }
1013 
1014     /**
1015      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1016      */
1017     function _getAux(address owner) internal view returns (uint64) {
1018         return _addressData[owner].aux;
1019     }
1020 
1021     /**
1022      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1023      * If there are multiple variables, please pack them into a uint64.
1024      */
1025     function _setAux(address owner, uint64 aux) internal {
1026         _addressData[owner].aux = aux;
1027     }
1028 
1029     /**
1030      * Gas spent here starts off proportional to the maximum mint batch size.
1031      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1032      */
1033     function _ownershipOf(uint256 tokenId)
1034         internal
1035         view
1036         returns (TokenOwnership memory)
1037     {
1038         uint256 curr = tokenId;
1039 
1040         unchecked {
1041             if (_startTokenId() <= curr && curr < _currentIndex) {
1042                 TokenOwnership memory ownership = _ownerships[curr];
1043                 if (!ownership.burned) {
1044                     if (ownership.addr != address(0)) {
1045                         return ownership;
1046                     }
1047                     // Invariant:
1048                     // There will always be an ownership that has an address and is not burned
1049                     // before an ownership that does not have an address and is not burned.
1050                     // Hence, curr will not underflow.
1051                     while (true) {
1052                         curr--;
1053                         ownership = _ownerships[curr];
1054                         if (ownership.addr != address(0)) {
1055                             return ownership;
1056                         }
1057                     }
1058                 }
1059             }
1060         }
1061         revert OwnerQueryForNonexistentToken();
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-ownerOf}.
1066      */
1067     function ownerOf(uint256 tokenId) public view override returns (address) {
1068         return _ownershipOf(tokenId).addr;
1069     }
1070 
1071     /**
1072      * @dev See {IERC721Metadata-name}.
1073      */
1074     function name() public view virtual override returns (string memory) {
1075         return _name;
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-symbol}.
1080      */
1081     function symbol() public view virtual override returns (string memory) {
1082         return _symbol;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-tokenURI}.
1087      */
1088     function tokenURI(uint256 tokenId)
1089         public
1090         view
1091         virtual
1092         override
1093         returns (string memory)
1094     {
1095         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1096 
1097         string memory baseURI = _baseURI();
1098         return
1099             bytes(baseURI).length != 0
1100                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1101                 : "";
1102     }
1103 
1104     /**
1105      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1106      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1107      * by default, can be overriden in child contracts.
1108      */
1109     function _baseURI() internal view virtual returns (string memory) {
1110         return "";
1111     }
1112 
1113     /**
1114      * @dev See {IERC721-approve}.
1115      */
1116     function approve(address to, uint256 tokenId) public override {
1117         address owner = ERC721A.ownerOf(tokenId);
1118         if (to == owner) revert ApprovalToCurrentOwner();
1119 
1120         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1121             revert ApprovalCallerNotOwnerNorApproved();
1122         }
1123 
1124         _approve(to, tokenId, owner);
1125     }
1126 
1127     /**
1128      * @dev See {IERC721-getApproved}.
1129      */
1130     function getApproved(uint256 tokenId)
1131         public
1132         view
1133         override
1134         returns (address)
1135     {
1136         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1137 
1138         return _tokenApprovals[tokenId];
1139     }
1140 
1141     /**
1142      * @dev See {IERC721-setApprovalForAll}.
1143      */
1144     function setApprovalForAll(address operator, bool approved)
1145         public
1146         virtual
1147         override
1148     {
1149         if (operator == _msgSender()) revert ApproveToCaller();
1150 
1151         _operatorApprovals[_msgSender()][operator] = approved;
1152         emit ApprovalForAll(_msgSender(), operator, approved);
1153     }
1154 
1155     /**
1156      * @dev See {IERC721-isApprovedForAll}.
1157      */
1158     function isApprovedForAll(address owner, address operator)
1159         public
1160         view
1161         virtual
1162         override
1163         returns (bool)
1164     {
1165         return _operatorApprovals[owner][operator];
1166     }
1167 
1168     /**
1169      * @dev See {IERC721-transferFrom}.
1170      */
1171     function transferFrom(
1172         address from,
1173         address to,
1174         uint256 tokenId
1175     ) public virtual override {
1176         _transfer(from, to, tokenId);
1177     }
1178 
1179     /**
1180      * @dev See {IERC721-safeTransferFrom}.
1181      */
1182     function safeTransferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId
1186     ) public virtual override {
1187         safeTransferFrom(from, to, tokenId, "");
1188     }
1189 
1190     /**
1191      * @dev See {IERC721-safeTransferFrom}.
1192      */
1193     function safeTransferFrom(
1194         address from,
1195         address to,
1196         uint256 tokenId,
1197         bytes memory _data
1198     ) public virtual override {
1199         _transfer(from, to, tokenId);
1200         if (
1201             to.isContract() &&
1202             !_checkContractOnERC721Received(from, to, tokenId, _data)
1203         ) {
1204             revert TransferToNonERC721ReceiverImplementer();
1205         }
1206     }
1207 
1208     /**
1209      * @dev Returns whether `tokenId` exists.
1210      *
1211      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1212      *
1213      * Tokens start existing when they are minted (`_mint`),
1214      */
1215     function _exists(uint256 tokenId) internal view returns (bool) {
1216         return
1217             _startTokenId() <= tokenId &&
1218             tokenId < _currentIndex &&
1219             !_ownerships[tokenId].burned;
1220     }
1221 
1222     function _safeMint(address to, uint256 quantity) internal {
1223         _safeMint(to, quantity, "");
1224     }
1225 
1226     /**
1227      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1228      *
1229      * Requirements:
1230      *
1231      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1232      * - `quantity` must be greater than 0.
1233      *
1234      * Emits a {Transfer} event.
1235      */
1236     function _safeMint(
1237         address to,
1238         uint256 quantity,
1239         bytes memory _data
1240     ) internal {
1241         _mint(to, quantity, _data, true);
1242     }
1243 
1244     /**
1245      * @dev Mints `quantity` tokens and transfers them to `to`.
1246      *
1247      * Requirements:
1248      *
1249      * - `to` cannot be the zero address.
1250      * - `quantity` must be greater than 0.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _mint(
1255         address to,
1256         uint256 quantity,
1257         bytes memory _data,
1258         bool safe
1259     ) internal {
1260         uint256 startTokenId = _currentIndex;
1261         if (to == address(0)) revert MintToZeroAddress();
1262         if (quantity == 0) revert MintZeroQuantity();
1263 
1264         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1265 
1266         // Overflows are incredibly unrealistic.
1267         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1268         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1269         unchecked {
1270             _addressData[to].balance += uint64(quantity);
1271             _addressData[to].numberMinted += uint64(quantity);
1272 
1273             _ownerships[startTokenId].addr = to;
1274             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1275 
1276             uint256 updatedIndex = startTokenId;
1277             uint256 end = updatedIndex + quantity;
1278 
1279             if (safe && to.isContract()) {
1280                 do {
1281                     emit Transfer(address(0), to, updatedIndex);
1282                     if (
1283                         !_checkContractOnERC721Received(
1284                             address(0),
1285                             to,
1286                             updatedIndex++,
1287                             _data
1288                         )
1289                     ) {
1290                         revert TransferToNonERC721ReceiverImplementer();
1291                     }
1292                 } while (updatedIndex != end);
1293                 // Reentrancy protection
1294                 if (_currentIndex != startTokenId) revert();
1295             } else {
1296                 do {
1297                     emit Transfer(address(0), to, updatedIndex++);
1298                 } while (updatedIndex != end);
1299             }
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
1366      * @dev This is equivalent to _burn(tokenId, false)
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
1466         try
1467             IERC721Receiver(to).onERC721Received(
1468                 _msgSender(),
1469                 from,
1470                 tokenId,
1471                 _data
1472             )
1473         returns (bytes4 retval) {
1474             return retval == IERC721Receiver(to).onERC721Received.selector;
1475         } catch (bytes memory reason) {
1476             if (reason.length == 0) {
1477                 revert TransferToNonERC721ReceiverImplementer();
1478             } else {
1479                 assembly {
1480                     revert(add(32, reason), mload(reason))
1481                 }
1482             }
1483         }
1484     }
1485 
1486     /**
1487      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1488      * And also called before burning one token.
1489      *
1490      * startTokenId - the first token id to be transferred
1491      * quantity - the amount to be transferred
1492      *
1493      * Calling conditions:
1494      *
1495      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1496      * transferred to `to`.
1497      * - When `from` is zero, `tokenId` will be minted for `to`.
1498      * - When `to` is zero, `tokenId` will be burned by `from`.
1499      * - `from` and `to` are never both zero.
1500      */
1501     function _beforeTokenTransfers(
1502         address from,
1503         address to,
1504         uint256 startTokenId,
1505         uint256 quantity
1506     ) internal virtual {}
1507 
1508     /**
1509      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1510      * minting.
1511      * And also called after one token has been burned.
1512      *
1513      * startTokenId - the first token id to be transferred
1514      * quantity - the amount to be transferred
1515      *
1516      * Calling conditions:
1517      *
1518      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1519      * transferred to `to`.
1520      * - When `from` is zero, `tokenId` has been minted for `to`.
1521      * - When `to` is zero, `tokenId` has been burned by `from`.
1522      * - `from` and `to` are never both zero.
1523      */
1524     function _afterTokenTransfers(
1525         address from,
1526         address to,
1527         uint256 startTokenId,
1528         uint256 quantity
1529     ) internal virtual {}
1530 }
1531 
1532 contract TheNightWatchNFT is ERC721A, Ownable, ReentrancyGuard {
1533     using Strings for uint256;
1534 
1535     bytes32 public merkleRoot;
1536     mapping(address => bool) public whitelistClaimed;
1537 
1538     string public uriPrefix;
1539     string public uriSuffix = ".json";
1540     string public hiddenMetadataURI;
1541 
1542     uint256 public cost;
1543     uint256 public maxSupply;
1544     uint256 public maxMintAmountPerTx;
1545     uint256 public maxMintAmountPerWallet = 3;
1546     uint256 private pauseMintAfter;
1547 
1548     bool public paused = false;
1549     bool public whitelistMintEnabled = false;
1550     bool public revealed = true;
1551 
1552     mapping(address => uint256) public ownerTokenMapping;
1553 
1554     constructor(
1555         string memory _tokenName,
1556         string memory _tokenSymbol,
1557         uint256 _cost,
1558         uint256 _pauseMint,
1559         uint256 _maxSupply,
1560         uint256 _maxMintAmountPerTx,
1561         string memory _uriPrefix,
1562         string memory _hiddenMetadataURI
1563     ) ERC721A(_tokenName, _tokenSymbol) {
1564         setCost(_cost);
1565         setPauseMint(_pauseMint);
1566         maxSupply = _maxSupply;
1567         setMaxMintAmountPerTx(_maxMintAmountPerTx);
1568         setUriPrefix(_uriPrefix);
1569         sethiddenMetadataURI(_hiddenMetadataURI);
1570     }
1571 
1572     modifier mintCompliance(uint256 _mintAmount) {
1573         require(
1574             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
1575             "Invalid mint amount!"
1576         );
1577         require(
1578             totalSupply() + _mintAmount <= maxSupply,
1579             "Max supply exceeded!"
1580         );
1581         _;
1582     }
1583     modifier mintPriceCompliance(uint256 _mintAmount) {
1584         require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1585         _;
1586     }
1587 
1588     function whitelistMint(uint256 _mintAmount, bytes32[] calldata _merkleProof)
1589         public
1590         payable
1591         mintCompliance(_mintAmount)
1592         mintPriceCompliance(_mintAmount)
1593     {
1594         // Verify whitelist requirements
1595         require(whitelistMintEnabled, "The whitelist sale is not enabled!");
1596         require(!whitelistClaimed[_msgSender()], "Address already claimed!");
1597         require(
1598             ownerTokenMapping[msg.sender] + _mintAmount <=
1599                 maxMintAmountPerWallet,
1600             "Max NFTs minted"
1601         );
1602         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1603         require(
1604             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1605             "Invalid proof!"
1606         );
1607         whitelistClaimed[_msgSender()] = true;
1608         _safeMint(_msgSender(), _mintAmount);
1609         ownerTokenMapping[msg.sender] += _mintAmount;
1610     }
1611 
1612     function mint(uint256 _mintAmount)
1613         public
1614         payable
1615         mintCompliance(_mintAmount)
1616         mintPriceCompliance(_mintAmount)
1617     {
1618         require(!paused, "The contract is paused!");
1619         require(
1620             ownerTokenMapping[msg.sender] + _mintAmount <=
1621                 maxMintAmountPerWallet,
1622             "Max NFTs minted"
1623         );
1624         _safeMint(_msgSender(), _mintAmount);
1625         ownerTokenMapping[msg.sender] += _mintAmount;
1626         doPauseMint();
1627     }
1628 
1629     function mintForAddress(uint256 _mintAmount, address _receiver)
1630         public
1631         mintCompliance(_mintAmount)
1632         onlyOwner
1633     {
1634         _safeMint(_receiver, _mintAmount);
1635 
1636         doPauseMint();
1637     }
1638 
1639     function mintForMultipleAddresses(address[] memory _addresses)
1640         public
1641         onlyOwner
1642     {
1643         require(
1644             _addresses.length > 0 && _addresses.length <= maxMintAmountPerTx,
1645             "Invalid mint amount!"
1646         );
1647         require(
1648             totalSupply() + _addresses.length <= maxSupply,
1649             "Max supply exceeded!"
1650         );
1651 
1652         for (uint256 i = 0; i < _addresses.length; i++) {
1653             _safeMint(_addresses[i], 1);
1654             doPauseMint();
1655         }
1656     }
1657 
1658     function walletOfOwner(address _owner)
1659         public
1660         view
1661         returns (uint256[] memory)
1662     {
1663         uint256 ownerTokenCount = balanceOf(_owner);
1664         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1665         uint256 currentTokenId = _startTokenId();
1666         uint256 ownedTokenIndex = 0;
1667         address latestOwnerAddress;
1668         while (
1669             ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply
1670         ) {
1671             TokenOwnership memory ownership = _ownerships[currentTokenId];
1672             if (!ownership.burned && ownership.addr != address(0)) {
1673                 latestOwnerAddress = ownership.addr;
1674             }
1675             if (latestOwnerAddress == _owner) {
1676                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1677                 ownedTokenIndex++;
1678             }
1679             currentTokenId++;
1680         }
1681         return ownedTokenIds;
1682     }
1683 
1684     function _startTokenId() internal view virtual override returns (uint256) {
1685         return 1;
1686     }
1687 
1688     function tokenURI(uint256 _tokenId)
1689         public
1690         view
1691         virtual
1692         override
1693         returns (string memory)
1694     {
1695         require(
1696             _exists(_tokenId),
1697             "ERC721Metadata: URI query for nonexistent token"
1698         );
1699         if (revealed == false) {
1700             return hiddenMetadataURI;
1701         }
1702         string memory currentBaseURI = _baseURI();
1703         return
1704             bytes(currentBaseURI).length > 0
1705                 ? string(
1706                     abi.encodePacked(
1707                         currentBaseURI,
1708                         _tokenId.toString(),
1709                         uriSuffix
1710                     )
1711                 )
1712                 : "";
1713     }
1714 
1715     function setRevealed(bool _state) public onlyOwner {
1716         revealed = _state;
1717     }
1718 
1719     function setCost(uint256 _cost) public onlyOwner {
1720         cost = _cost;
1721     }
1722 
1723     function setPauseMint(uint256 _amount) public onlyOwner {
1724         pauseMintAfter = _amount;
1725     }
1726 
1727     function doPauseMint() internal {
1728         if (totalSupply() >= pauseMintAfter) {
1729             paused = true;
1730             pauseMintAfter = pauseMintAfter + pauseMintAfter;
1731         }
1732     }
1733 
1734     function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx)
1735         public
1736         onlyOwner
1737     {
1738         maxMintAmountPerTx = _maxMintAmountPerTx;
1739     }
1740 
1741     function setMaxMintAmountPerWallet(uint256 _maxMintAmountPerWallet)
1742         public
1743         onlyOwner
1744     {
1745         maxMintAmountPerWallet = _maxMintAmountPerWallet;
1746     }
1747 
1748     function sethiddenMetadataURI(string memory _hiddenMetadataURI)
1749         public
1750         onlyOwner
1751     {
1752         hiddenMetadataURI = _hiddenMetadataURI;
1753     }
1754 
1755     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1756         uriPrefix = _uriPrefix;
1757     }
1758 
1759     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1760         uriSuffix = _uriSuffix;
1761     }
1762 
1763     function setPaused(bool _state) public onlyOwner {
1764         paused = _state;
1765     }
1766 
1767     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1768         merkleRoot = _merkleRoot;
1769     }
1770 
1771     function setWhitelistMintEnabled(bool _state) public onlyOwner {
1772         whitelistMintEnabled = _state;
1773     }
1774 
1775     function withdraw() public onlyOwner nonReentrant {
1776         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1777         require(os);
1778     }
1779 
1780     function _baseURI() internal view virtual override returns (string memory) {
1781         return uriPrefix;
1782     }
1783 }