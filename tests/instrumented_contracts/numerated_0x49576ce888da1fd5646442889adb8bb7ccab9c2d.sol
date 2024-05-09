1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
8 
9 
10 pragma solidity ^0.8.0;
11 
12 
13 /**
14  * @dev These functions deal with verification of Merkle Trees proofs.
15  *
16  * The proofs can be generated using the JavaScript library
17  * https://github.com/miguelmota/merkletreejs[merkletreejs].
18  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
19  *
20  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37 
38     /**
39      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
40      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
41      * hash matches the root of the tree. When processing the proof, the pairs
42      * of leafs & pre-images are assumed to be sorted.
43      *
44      * _Available since v4.4._
45      */
46     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
47         bytes32 computedHash = leaf;
48         for (uint256 i = 0; i < proof.length; i++) {
49             bytes32 proofElement = proof[i];
50             if (computedHash <= proofElement) {
51                 // Hash(current computed hash + current element of the proof)
52                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
53             } else {
54                 // Hash(current element of the proof + current computed hash)
55                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
56             }
57         }
58         return computedHash;
59     }
60 }
61 
62 
63 // File: @openzeppelin/contracts/utils/Counters.sol
64 
65 
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
69 
70 
71 pragma solidity ^0.8.0;
72 
73 
74 /**
75  * @title Counters
76  * @author Matt Condon (@shrugs)
77  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
78  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
79  *
80  * Include with `using Counters for Counters.Counter;`
81  */
82 library Counters {
83     struct Counter {
84         // This variable should never be directly accessed by users of the library: interactions must be restricted to
85         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
86         // this feature: see https://github.com/ethereum/solidity/issues/4637
87         uint256 _value; // default: 0
88     }
89 
90 
91     function current(Counter storage counter) internal view returns (uint256) {
92         return counter._value;
93     }
94 
95 
96     function increment(Counter storage counter) internal {
97         unchecked {
98             counter._value += 1;
99         }
100     }
101 
102 
103     function decrement(Counter storage counter) internal {
104         uint256 value = counter._value;
105         require(value > 0, "Counter: decrement overflow");
106         unchecked {
107             counter._value = value - 1;
108         }
109     }
110 
111 
112     function reset(Counter storage counter) internal {
113         counter._value = 0;
114     }
115 }
116 
117 
118 // File: @openzeppelin/contracts/utils/Strings.sol
119 
120 
121 
122 
123 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
124 
125 
126 pragma solidity ^0.8.0;
127 
128 
129 /**
130  * @dev String operations.
131  */
132 library Strings {
133     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
134 
135 
136     /**
137      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
138      */
139     function toString(uint256 value) internal pure returns (string memory) {
140         // Inspired by OraclizeAPI's implementation - MIT licence
141         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
142 
143 
144         if (value == 0) {
145             return "0";
146         }
147         uint256 temp = value;
148         uint256 digits;
149         while (temp != 0) {
150             digits++;
151             temp /= 10;
152         }
153         bytes memory buffer = new bytes(digits);
154         while (value != 0) {
155             digits -= 1;
156             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
157             value /= 10;
158         }
159         return string(buffer);
160     }
161 
162 
163     /**
164      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
165      */
166     function toHexString(uint256 value) internal pure returns (string memory) {
167         if (value == 0) {
168             return "0x00";
169         }
170         uint256 temp = value;
171         uint256 length = 0;
172         while (temp != 0) {
173             length++;
174             temp >>= 8;
175         }
176         return toHexString(value, length);
177     }
178 
179 
180     /**
181      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
182      */
183     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
184         bytes memory buffer = new bytes(2 * length + 2);
185         buffer[0] = "0";
186         buffer[1] = "x";
187         for (uint256 i = 2 * length + 1; i > 1; --i) {
188             buffer[i] = _HEX_SYMBOLS[value & 0xf];
189             value >>= 4;
190         }
191         require(value == 0, "Strings: hex length insufficient");
192         return string(buffer);
193     }
194 }
195 
196 
197 // File: @openzeppelin/contracts/utils/Context.sol
198 
199 
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
203 
204 
205 pragma solidity ^0.8.0;
206 
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
223 
224     function _msgData() internal view virtual returns (bytes calldata) {
225         return msg.data;
226     }
227 }
228 
229 
230 // File: @openzeppelin/contracts/access/Ownable.sol
231 
232 
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
236 
237 
238 pragma solidity ^0.8.0;
239 
240 
241 
242 
243 /**
244  * @dev Contract module which provides a basic access control mechanism, where
245  * there is an account (an owner) that can be granted exclusive access to
246  * specific functions.
247  *
248  * By default, the owner account will be the one that deploys the contract. This
249  * can later be changed with {transferOwnership}.
250  *
251  * This module is used through inheritance. It will make available the modifier
252  * `onlyOwner`, which can be applied to your functions to restrict their use to
253  * the owner.
254  */
255 abstract contract Ownable is Context {
256     address private _owner;
257 
258 
259     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
260 
261 
262     /**
263      * @dev Initializes the contract setting the deployer as the initial owner.
264      */
265     constructor() {
266         _transferOwnership(_msgSender());
267     }
268 
269 
270     /**
271      * @dev Returns the address of the current owner.
272      */
273     function owner() public view virtual returns (address) {
274         return _owner;
275     }
276 
277 
278     /**
279      * @dev Throws if called by any account other than the owner.
280      */
281     modifier onlyOwner() {
282         require(owner() == _msgSender(), "Ownable: caller is not the owner");
283         _;
284     }
285 
286 
287     /**
288      * @dev Leaves the contract without owner. It will not be possible to call
289      * `onlyOwner` functions anymore. Can only be called by the current owner.
290      *
291      * NOTE: Renouncing ownership will leave the contract without an owner,
292      * thereby removing any functionality that is only available to the owner.
293      */
294     function renounceOwnership() public virtual onlyOwner {
295         _transferOwnership(address(0));
296     }
297 
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Can only be called by the current owner.
302      */
303     function transferOwnership(address newOwner) public virtual onlyOwner {
304         require(newOwner != address(0), "Ownable: new owner is the zero address");
305         _transferOwnership(newOwner);
306     }
307 
308 
309     /**
310      * @dev Transfers ownership of the contract to a new account (`newOwner`).
311      * Internal function without access restriction.
312      */
313     function _transferOwnership(address newOwner) internal virtual {
314         address oldOwner = _owner;
315         _owner = newOwner;
316         emit OwnershipTransferred(oldOwner, newOwner);
317     }
318 }
319 
320 
321 // File: @openzeppelin/contracts/utils/Address.sol
322 
323 
324 
325 
326 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
327 
328 
329 pragma solidity ^0.8.0;
330 
331 
332 /**
333  * @dev Collection of functions related to the address type
334  */
335 library Address {
336     /**
337      * @dev Returns true if `account` is a contract.
338      *
339      * [IMPORTANT]
340      * ====
341      * It is unsafe to assume that an address for which this function returns
342      * false is an externally-owned account (EOA) and not a contract.
343      *
344      * Among others, `isContract` will return false for the following
345      * types of addresses:
346      *
347      *  - an externally-owned account
348      *  - a contract in construction
349      *  - an address where a contract will be created
350      *  - an address where a contract lived, but was destroyed
351      * ====
352      */
353     function isContract(address account) internal view returns (bool) {
354         // This method relies on extcodesize, which returns 0 for contracts in
355         // construction, since the code is only stored at the end of the
356         // constructor execution.
357 
358 
359         uint256 size;
360         assembly {
361             size := extcodesize(account)
362         }
363         return size > 0;
364     }
365 
366 
367     /**
368      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
369      * `recipient`, forwarding all available gas and reverting on errors.
370      *
371      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
372      * of certain opcodes, possibly making contracts go over the 2300 gas limit
373      * imposed by `transfer`, making them unable to receive funds via
374      * `transfer`. {sendValue} removes this limitation.
375      *
376      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
377      *
378      * IMPORTANT: because control is transferred to `recipient`, care must be
379      * taken to not create reentrancy vulnerabilities. Consider using
380      * {ReentrancyGuard} or the
381      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
382      */
383     function sendValue(address payable recipient, uint256 amount) internal {
384         require(address(this).balance >= amount, "Address: insufficient balance");
385 
386 
387         (bool success, ) = recipient.call{value: amount}("");
388         require(success, "Address: unable to send value, recipient may have reverted");
389     }
390 
391 
392     /**
393      * @dev Performs a Solidity function call using a low level `call`. A
394      * plain `call` is an unsafe replacement for a function call: use this
395      * function instead.
396      *
397      * If `target` reverts with a revert reason, it is bubbled up by this
398      * function (like regular Solidity function calls).
399      *
400      * Returns the raw returned data. To convert to the expected return value,
401      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
402      *
403      * Requirements:
404      *
405      * - `target` must be a contract.
406      * - calling `target` with `data` must not revert.
407      *
408      * _Available since v3.1._
409      */
410     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
411         return functionCall(target, data, "Address: low-level call failed");
412     }
413 
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
417      * `errorMessage` as a fallback revert reason when `target` reverts.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(
422         address target,
423         bytes memory data,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, 0, errorMessage);
427     }
428 
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
446         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
447     }
448 
449 
450     /**
451      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
452      * with `errorMessage` as a fallback revert reason when `target` reverts.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value,
460         string memory errorMessage
461     ) internal returns (bytes memory) {
462         require(address(this).balance >= value, "Address: insufficient balance for call");
463         require(isContract(target), "Address: call to non-contract");
464 
465 
466         (bool success, bytes memory returndata) = target.call{value: value}(data);
467         return verifyCallResult(success, returndata, errorMessage);
468     }
469 
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
478         return functionStaticCall(target, data, "Address: low-level static call failed");
479     }
480 
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a static call.
485      *
486      * _Available since v3.3._
487      */
488     function functionStaticCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal view returns (bytes memory) {
493         require(isContract(target), "Address: static call to non-contract");
494 
495 
496         (bool success, bytes memory returndata) = target.staticcall(data);
497         return verifyCallResult(success, returndata, errorMessage);
498     }
499 
500 
501     /**
502      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
503      * but performing a delegate call.
504      *
505      * _Available since v3.4._
506      */
507     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
508         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
509     }
510 
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         require(isContract(target), "Address: delegate call to non-contract");
524 
525 
526         (bool success, bytes memory returndata) = target.delegatecall(data);
527         return verifyCallResult(success, returndata, errorMessage);
528     }
529 
530 
531     /**
532      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
533      * revert reason using the provided one.
534      *
535      * _Available since v4.3._
536      */
537     function verifyCallResult(
538         bool success,
539         bytes memory returndata,
540         string memory errorMessage
541     ) internal pure returns (bytes memory) {
542         if (success) {
543             return returndata;
544         } else {
545             // Look for revert reason and bubble it up if present
546             if (returndata.length > 0) {
547                 // The easiest way to bubble the revert reason is using memory via assembly
548 
549 
550                 assembly {
551                     let returndata_size := mload(returndata)
552                     revert(add(32, returndata), returndata_size)
553                 }
554             } else {
555                 revert(errorMessage);
556             }
557         }
558     }
559 }
560 
561 
562 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
563 
564 
565 
566 
567 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
568 
569 
570 pragma solidity ^0.8.0;
571 
572 
573 /**
574  * @title ERC721 token receiver interface
575  * @dev Interface for any contract that wants to support safeTransfers
576  * from ERC721 asset contracts.
577  */
578 interface IERC721Receiver {
579     /**
580      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
581      * by `operator` from `from`, this function is called.
582      *
583      * It must return its Solidity selector to confirm the token transfer.
584      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
585      *
586      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
587      */
588     function onERC721Received(
589         address operator,
590         address from,
591         uint256 tokenId,
592         bytes calldata data
593     ) external returns (bytes4);
594 }
595 
596 
597 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
598 
599 
600 
601 
602 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
603 
604 
605 pragma solidity ^0.8.0;
606 
607 
608 /**
609  * @dev Interface of the ERC165 standard, as defined in the
610  * https://eips.ethereum.org/EIPS/eip-165[EIP].
611  *
612  * Implementers can declare support of contract interfaces, which can then be
613  * queried by others ({ERC165Checker}).
614  *
615  * For an implementation, see {ERC165}.
616  */
617 interface IERC165 {
618     /**
619      * @dev Returns true if this contract implements the interface defined by
620      * `interfaceId`. See the corresponding
621      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
622      * to learn more about how these ids are created.
623      *
624      * This function call must use less than 30 000 gas.
625      */
626     function supportsInterface(bytes4 interfaceId) external view returns (bool);
627 }
628 
629 
630 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
631 
632 
633 
634 
635 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
636 
637 
638 pragma solidity ^0.8.0;
639 
640 
641 
642 
643 /**
644  * @dev Implementation of the {IERC165} interface.
645  *
646  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
647  * for the additional interface id that will be supported. For example:
648  *
649  * ```solidity
650  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
651  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
652  * }
653  * ```
654  *
655  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
656  */
657 abstract contract ERC165 is IERC165 {
658     /**
659      * @dev See {IERC165-supportsInterface}.
660      */
661     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
662         return interfaceId == type(IERC165).interfaceId;
663     }
664 }
665 
666 
667 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
668 
669 
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
673 
674 
675 pragma solidity ^0.8.0;
676 
677 
678 
679 
680 /**
681  * @dev Required interface of an ERC721 compliant contract.
682  */
683 interface IERC721 is IERC165 {
684     /**
685      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
686      */
687     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
688 
689 
690     /**
691      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
692      */
693     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
694 
695 
696     /**
697      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
698      */
699     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
700 
701 
702     /**
703      * @dev Returns the number of tokens in ``owner``'s account.
704      */
705     function balanceOf(address owner) external view returns (uint256 balance);
706 
707 
708     /**
709      * @dev Returns the owner of the `tokenId` token.
710      *
711      * Requirements:
712      *
713      * - `tokenId` must exist.
714      */
715     function ownerOf(uint256 tokenId) external view returns (address owner);
716 
717 
718     /**
719      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
720      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
721      *
722      * Requirements:
723      *
724      * - `from` cannot be the zero address.
725      * - `to` cannot be the zero address.
726      * - `tokenId` token must exist and be owned by `from`.
727      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
728      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
729      *
730      * Emits a {Transfer} event.
731      */
732     function safeTransferFrom(
733         address from,
734         address to,
735         uint256 tokenId
736     ) external;
737 
738 
739     /**
740      * @dev Transfers `tokenId` token from `from` to `to`.
741      *
742      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
743      *
744      * Requirements:
745      *
746      * - `from` cannot be the zero address.
747      * - `to` cannot be the zero address.
748      * - `tokenId` token must be owned by `from`.
749      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
750      *
751      * Emits a {Transfer} event.
752      */
753     function transferFrom(
754         address from,
755         address to,
756         uint256 tokenId
757     ) external;
758 
759 
760     /**
761      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
762      * The approval is cleared when the token is transferred.
763      *
764      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
765      *
766      * Requirements:
767      *
768      * - The caller must own the token or be an approved operator.
769      * - `tokenId` must exist.
770      *
771      * Emits an {Approval} event.
772      */
773     function approve(address to, uint256 tokenId) external;
774 
775 
776     /**
777      * @dev Returns the account approved for `tokenId` token.
778      *
779      * Requirements:
780      *
781      * - `tokenId` must exist.
782      */
783     function getApproved(uint256 tokenId) external view returns (address operator);
784 
785 
786     /**
787      * @dev Approve or remove `operator` as an operator for the caller.
788      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
789      *
790      * Requirements:
791      *
792      * - The `operator` cannot be the caller.
793      *
794      * Emits an {ApprovalForAll} event.
795      */
796     function setApprovalForAll(address operator, bool _approved) external;
797 
798 
799     /**
800      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
801      *
802      * See {setApprovalForAll}
803      */
804     function isApprovedForAll(address owner, address operator) external view returns (bool);
805 
806 
807     /**
808      * @dev Safely transfers `tokenId` token from `from` to `to`.
809      *
810      * Requirements:
811      *
812      * - `from` cannot be the zero address.
813      * - `to` cannot be the zero address.
814      * - `tokenId` token must exist and be owned by `from`.
815      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
816      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
817      *
818      * Emits a {Transfer} event.
819      */
820     function safeTransferFrom(
821         address from,
822         address to,
823         uint256 tokenId,
824         bytes calldata data
825     ) external;
826 }
827 
828 
829 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
830 
831 
832 
833 
834 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
835 
836 
837 pragma solidity ^0.8.0;
838 
839 
840 
841 
842 /**
843  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
844  * @dev See https://eips.ethereum.org/EIPS/eip-721
845  */
846 interface IERC721Metadata is IERC721 {
847     /**
848      * @dev Returns the token collection name.
849      */
850     function name() external view returns (string memory);
851 
852 
853     /**
854      * @dev Returns the token collection symbol.
855      */
856     function symbol() external view returns (string memory);
857 
858 
859     /**
860      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
861      */
862     function tokenURI(uint256 tokenId) external view returns (string memory);
863 }
864 
865 
866 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
867 
868 
869 
870 
871 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
872 
873 
874 pragma solidity ^0.8.0;
875 
876 
877 
878 
879 
880 
881 
882 
883 
884 
885 
886 
887 
888 
889 
890 
891 /**
892  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
893  * the Metadata extension, but not including the Enumerable extension, which is available separately as
894  * {ERC721Enumerable}.
895  */
896 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
897     using Address for address;
898     using Strings for uint256;
899 
900 
901     // Token name
902     string private _name;
903 
904 
905     // Token symbol
906     string private _symbol;
907 
908 
909     // Mapping from token ID to owner address
910     mapping(uint256 => address) private _owners;
911 
912 
913     // Mapping owner address to token count
914     mapping(address => uint256) private _balances;
915 
916 
917     // Mapping from token ID to approved address
918     mapping(uint256 => address) private _tokenApprovals;
919 
920 
921     // Mapping from owner to operator approvals
922     mapping(address => mapping(address => bool)) private _operatorApprovals;
923 
924 
925     /**
926      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
927      */
928     constructor(string memory name_, string memory symbol_) {
929         _name = name_;
930         _symbol = symbol_;
931     }
932 
933 
934     /**
935      * @dev See {IERC165-supportsInterface}.
936      */
937     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
938         return
939             interfaceId == type(IERC721).interfaceId ||
940             interfaceId == type(IERC721Metadata).interfaceId ||
941             super.supportsInterface(interfaceId);
942     }
943 
944 
945     /**
946      * @dev See {IERC721-balanceOf}.
947      */
948     function balanceOf(address owner) public view virtual override returns (uint256) {
949         require(owner != address(0), "ERC721: balance query for the zero address");
950         return _balances[owner];
951     }
952 
953 
954     /**
955      * @dev See {IERC721-ownerOf}.
956      */
957     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
958         address owner = _owners[tokenId];
959         require(owner != address(0), "ERC721: owner query for nonexistent token");
960         return owner;
961     }
962 
963 
964     /**
965      * @dev See {IERC721Metadata-name}.
966      */
967     function name() public view virtual override returns (string memory) {
968         return _name;
969     }
970 
971 
972     /**
973      * @dev See {IERC721Metadata-symbol}.
974      */
975     function symbol() public view virtual override returns (string memory) {
976         return _symbol;
977     }
978 
979 
980     /**
981      * @dev See {IERC721Metadata-tokenURI}.
982      */
983     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
984         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
985 
986 
987         string memory baseURI = _baseURI();
988         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
989     }
990 
991 
992     /**
993      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
994      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
995      * by default, can be overriden in child contracts.
996      */
997     function _baseURI() internal view virtual returns (string memory) {
998         return "";
999     }
1000 
1001 
1002     /**
1003      * @dev See {IERC721-approve}.
1004      */
1005     function approve(address to, uint256 tokenId) public virtual override {
1006         address owner = ERC721.ownerOf(tokenId);
1007         require(to != owner, "ERC721: approval to current owner");
1008 
1009 
1010         require(
1011             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1012             "ERC721: approve caller is not owner nor approved for all"
1013         );
1014 
1015 
1016         _approve(to, tokenId);
1017     }
1018 
1019 
1020     /**
1021      * @dev See {IERC721-getApproved}.
1022      */
1023     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1024         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1025 
1026 
1027         return _tokenApprovals[tokenId];
1028     }
1029 
1030 
1031     /**
1032      * @dev See {IERC721-setApprovalForAll}.
1033      */
1034     function setApprovalForAll(address operator, bool approved) public virtual override {
1035         _setApprovalForAll(_msgSender(), operator, approved);
1036     }
1037 
1038 
1039     /**
1040      * @dev See {IERC721-isApprovedForAll}.
1041      */
1042     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1043         return _operatorApprovals[owner][operator];
1044     }
1045 
1046 
1047     /**
1048      * @dev See {IERC721-transferFrom}.
1049      */
1050     function transferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) public virtual override {
1055         //solhint-disable-next-line max-line-length
1056         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1057 
1058 
1059         _transfer(from, to, tokenId);
1060     }
1061 
1062 
1063     /**
1064      * @dev See {IERC721-safeTransferFrom}.
1065      */
1066     function safeTransferFrom(
1067         address from,
1068         address to,
1069         uint256 tokenId
1070     ) public virtual override {
1071         safeTransferFrom(from, to, tokenId, "");
1072     }
1073 
1074 
1075     /**
1076      * @dev See {IERC721-safeTransferFrom}.
1077      */
1078     function safeTransferFrom(
1079         address from,
1080         address to,
1081         uint256 tokenId,
1082         bytes memory _data
1083     ) public virtual override {
1084         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1085         _safeTransfer(from, to, tokenId, _data);
1086     }
1087 
1088 
1089     /**
1090      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1091      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1092      *
1093      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1094      *
1095      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1096      * implement alternative mechanisms to perform token transfer, such as signature-based.
1097      *
1098      * Requirements:
1099      *
1100      * - `from` cannot be the zero address.
1101      * - `to` cannot be the zero address.
1102      * - `tokenId` token must exist and be owned by `from`.
1103      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _safeTransfer(
1108         address from,
1109         address to,
1110         uint256 tokenId,
1111         bytes memory _data
1112     ) internal virtual {
1113         _transfer(from, to, tokenId);
1114         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1115     }
1116 
1117 
1118     /**
1119      * @dev Returns whether `tokenId` exists.
1120      *
1121      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1122      *
1123      * Tokens start existing when they are minted (`_mint`),
1124      * and stop existing when they are burned (`_burn`).
1125      */
1126     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1127         return _owners[tokenId] != address(0);
1128     }
1129 
1130 
1131     /**
1132      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1133      *
1134      * Requirements:
1135      *
1136      * - `tokenId` must exist.
1137      */
1138     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1139         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1140         address owner = ERC721.ownerOf(tokenId);
1141         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1142     }
1143 
1144 
1145     /**
1146      * @dev Safely mints `tokenId` and transfers it to `to`.
1147      *
1148      * Requirements:
1149      *
1150      * - `tokenId` must not exist.
1151      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1152      *
1153      * Emits a {Transfer} event.
1154      */
1155     function _safeMint(address to, uint256 tokenId) internal virtual {
1156         _safeMint(to, tokenId, "");
1157     }
1158 
1159 
1160     /**
1161      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1162      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1163      */
1164     function _safeMint(
1165         address to,
1166         uint256 tokenId,
1167         bytes memory _data
1168     ) internal virtual {
1169         _mint(to, tokenId);
1170         require(
1171             _checkOnERC721Received(address(0), to, tokenId, _data),
1172             "ERC721: transfer to non ERC721Receiver implementer"
1173         );
1174     }
1175 
1176 
1177     /**
1178      * @dev Mints `tokenId` and transfers it to `to`.
1179      *
1180      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1181      *
1182      * Requirements:
1183      *
1184      * - `tokenId` must not exist.
1185      * - `to` cannot be the zero address.
1186      *
1187      * Emits a {Transfer} event.
1188      */
1189     function _mint(address to, uint256 tokenId) internal virtual {
1190         require(to != address(0), "ERC721: mint to the zero address");
1191         require(!_exists(tokenId), "ERC721: token already minted");
1192 
1193 
1194         _beforeTokenTransfer(address(0), to, tokenId);
1195 
1196 
1197         _balances[to] += 1;
1198         _owners[tokenId] = to;
1199 
1200 
1201         emit Transfer(address(0), to, tokenId);
1202     }
1203 
1204 
1205     /**
1206      * @dev Destroys `tokenId`.
1207      * The approval is cleared when the token is burned.
1208      *
1209      * Requirements:
1210      *
1211      * - `tokenId` must exist.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _burn(uint256 tokenId) internal virtual {
1216         address owner = ERC721.ownerOf(tokenId);
1217 
1218 
1219         _beforeTokenTransfer(owner, address(0), tokenId);
1220 
1221 
1222         // Clear approvals
1223         _approve(address(0), tokenId);
1224 
1225 
1226         _balances[owner] -= 1;
1227         delete _owners[tokenId];
1228 
1229 
1230         emit Transfer(owner, address(0), tokenId);
1231     }
1232 
1233 
1234     /**
1235      * @dev Transfers `tokenId` from `from` to `to`.
1236      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1237      *
1238      * Requirements:
1239      *
1240      * - `to` cannot be the zero address.
1241      * - `tokenId` token must be owned by `from`.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function _transfer(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) internal virtual {
1250         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1251         require(to != address(0), "ERC721: transfer to the zero address");
1252 
1253 
1254         _beforeTokenTransfer(from, to, tokenId);
1255 
1256 
1257         // Clear approvals from the previous owner
1258         _approve(address(0), tokenId);
1259 
1260 
1261         _balances[from] -= 1;
1262         _balances[to] += 1;
1263         _owners[tokenId] = to;
1264 
1265 
1266         emit Transfer(from, to, tokenId);
1267     }
1268 
1269 
1270     /**
1271      * @dev Approve `to` to operate on `tokenId`
1272      *
1273      * Emits a {Approval} event.
1274      */
1275     function _approve(address to, uint256 tokenId) internal virtual {
1276         _tokenApprovals[tokenId] = to;
1277         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1278     }
1279 
1280 
1281     /**
1282      * @dev Approve `operator` to operate on all of `owner` tokens
1283      *
1284      * Emits a {ApprovalForAll} event.
1285      */
1286     function _setApprovalForAll(
1287         address owner,
1288         address operator,
1289         bool approved
1290     ) internal virtual {
1291         require(owner != operator, "ERC721: approve to caller");
1292         _operatorApprovals[owner][operator] = approved;
1293         emit ApprovalForAll(owner, operator, approved);
1294     }
1295 
1296 
1297     /**
1298      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1299      * The call is not executed if the target address is not a contract.
1300      *
1301      * @param from address representing the previous owner of the given token ID
1302      * @param to target address that will receive the tokens
1303      * @param tokenId uint256 ID of the token to be transferred
1304      * @param _data bytes optional data to send along with the call
1305      * @return bool whether the call correctly returned the expected magic value
1306      */
1307     function _checkOnERC721Received(
1308         address from,
1309         address to,
1310         uint256 tokenId,
1311         bytes memory _data
1312     ) private returns (bool) {
1313         if (to.isContract()) {
1314             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1315                 return retval == IERC721Receiver.onERC721Received.selector;
1316             } catch (bytes memory reason) {
1317                 if (reason.length == 0) {
1318                     revert("ERC721: transfer to non ERC721Receiver implementer");
1319                 } else {
1320                     assembly {
1321                         revert(add(32, reason), mload(reason))
1322                     }
1323                 }
1324             }
1325         } else {
1326             return true;
1327         }
1328     }
1329 
1330 
1331     /**
1332      * @dev Hook that is called before any token transfer. This includes minting
1333      * and burning.
1334      *
1335      * Calling conditions:
1336      *
1337      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1338      * transferred to `to`.
1339      * - When `from` is zero, `tokenId` will be minted for `to`.
1340      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1341      * - `from` and `to` are never both zero.
1342      *
1343      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1344      */
1345     function _beforeTokenTransfer(
1346         address from,
1347         address to,
1348         uint256 tokenId
1349     ) internal virtual {}
1350 }
1351 
1352 
1353 // File: contracts/CrypToadz.sol
1354 
1355 
1356 pragma solidity ^0.8.0;
1357 
1358 
1359 contract OxToadz is ERC721, Ownable {
1360   using Strings for uint256;
1361   using Counters for Counters.Counter;
1362   Counters.Counter private supply;
1363   string public uriPrefix = "ipfs:///";
1364   string public uriSuffix = ".json";
1365   string public hiddenMetadataUri;
1366   uint256 public preSaleWalletLimit = 100;
1367   uint256 public publicSaleWalletLimit = 100;
1368   uint256 public preSaleCost = 0.0169 ether;
1369   uint256 public publicSaleCost = 0.0289 ether;
1370   uint256 public maxSupply = 5555;
1371   uint256 public maxMintAmountPerTx = 20;
1372   bool public paused = false;
1373   bool public revealed = false;
1374   bool public onlyWhitelisted = true;
1375   bytes32 public RootHash = 0xe26368e92badeb5ea0817a8814f964e631eb7656e7c8647827fb7912c4cab989;
1376 
1377 
1378   constructor() ERC721("0xToadz", "0xToadz") {
1379     setHiddenMetadataUri("ipfs://QmXJtsCJSWxJrWXrWfC3kM9EbQuJ1A5ZUcFQg2ZJjNYXm7/hidden.json");
1380   }
1381 
1382 
1383   modifier mintCompliance(uint256 _mintAmount) {
1384     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1385     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1386     _;
1387   }
1388 
1389 
1390   function totalSupply() public view returns (uint256) {
1391     return supply.current();
1392   }
1393 
1394 
1395   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount){
1396     require(!paused, "Sale has not started");
1397     require(!onlyWhitelisted,"Public sale is not open yet");
1398     require(msg.value >= publicSaleCost * _mintAmount, "Insufficient funds!");
1399     uint ownerMintedCount = balanceOf(msg.sender);
1400         require(
1401             ownerMintedCount + _mintAmount <= publicSaleWalletLimit,
1402             "Max NFT mint limit reached. Try minting from another wallet"
1403         );
1404     _mintLoop(msg.sender, _mintAmount);
1405     
1406   }
1407 
1408 
1409   function whitelistMint(uint _mintAmount, bytes32[] calldata _merkleProof) external payable mintCompliance(_mintAmount) {
1410     require(!paused, "Sale has not started");
1411       if (onlyWhitelisted == true){
1412         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1413         require(MerkleProof.verify(_merkleProof, RootHash, leaf), "You are not Whitelisted. Try minting in public sale");
1414         uint ownerMintedCount = balanceOf(msg.sender);
1415         require(
1416             ownerMintedCount + _mintAmount <= preSaleWalletLimit,
1417             "Max NFT mint limit reached. Try minting in public sale"
1418         );
1419       }
1420       require(msg.value >= preSaleCost * _mintAmount, "Insufficient funds!");
1421 
1422 
1423       _mintLoop(msg.sender, _mintAmount);
1424   }
1425 
1426 
1427   // Owner quota for the team and giveaways
1428   function ownerMint(uint256 _mintAmount, address _receiver) public onlyOwner {
1429     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount!");
1430     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1431     _mintLoop(_receiver, _mintAmount);
1432   }
1433 
1434 
1435   function walletOfOwner(address _owner)
1436     public
1437     view
1438     returns (uint256[] memory)
1439   {
1440     uint256 ownerTokenCount = balanceOf(_owner);
1441     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1442     uint256 currentTokenId = 1;
1443     uint256 ownedTokenIndex = 0;
1444 
1445 
1446     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1447       address currentTokenOwner = ownerOf(currentTokenId);
1448 
1449 
1450       if (currentTokenOwner == _owner) {
1451         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1452 
1453 
1454         ownedTokenIndex++;
1455       }
1456 
1457 
1458       currentTokenId++;
1459     }
1460 
1461 
1462     return ownedTokenIds;
1463   }
1464 
1465 
1466   function tokenURI(uint256 _tokenId)
1467     public
1468     view
1469     virtual
1470     override
1471     returns (string memory)
1472   {
1473     require(
1474       _exists(_tokenId),
1475       "ERC721Metadata: URI query for nonexistent token"
1476     );
1477 
1478 
1479     if (revealed == false) {
1480       return hiddenMetadataUri;
1481     }
1482 
1483 
1484     string memory currentBaseURI = _baseURI();
1485     return bytes(currentBaseURI).length > 0
1486         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1487         : "";
1488   }
1489 
1490 
1491   function setRevealed(bool _state) public onlyOwner {
1492     revealed = _state;
1493   }
1494 
1495 
1496   function setRootHash(bytes32 _Root) public onlyOwner {
1497     RootHash = _Root;
1498   }
1499 
1500 
1501   function setPreSaleCost(uint256 _cost) public onlyOwner {
1502     preSaleCost = _cost;
1503   }
1504 
1505 
1506   function setPublicSaleCost(uint256 _cost) public onlyOwner {
1507     publicSaleCost = _cost;
1508   }
1509 
1510 
1511   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1512     maxMintAmountPerTx = _maxMintAmountPerTx;
1513   }
1514 
1515 
1516   function setPreSaleWalletLimit(uint256 _PreSaleWalletLimit) public onlyOwner {
1517     preSaleWalletLimit = _PreSaleWalletLimit;
1518   }
1519 
1520 
1521   function setPublicSaleWalletLimit(uint256 _PublicSaleWalletLimit) public onlyOwner {
1522     publicSaleWalletLimit = _PublicSaleWalletLimit;
1523   }
1524 
1525 
1526   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1527     hiddenMetadataUri = _hiddenMetadataUri;
1528   }
1529 
1530 
1531   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1532     uriPrefix = _uriPrefix;
1533   }
1534 
1535 
1536   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1537     uriSuffix = _uriSuffix;
1538   }
1539 
1540 
1541   function setOnlyWhitelisted(bool _state) public onlyOwner {
1542       onlyWhitelisted = _state;
1543   }
1544 
1545 
1546   function setPaused(bool _state) public onlyOwner {
1547     paused = _state;
1548   }
1549 
1550 
1551   function withdraw() public onlyOwner {    
1552     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1553     require(os);    
1554   }
1555 
1556 
1557   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1558     for (uint256 i = 0; i < _mintAmount; i++) {
1559       supply.increment();
1560       _safeMint(_receiver, supply.current());
1561     }
1562   }
1563 
1564 
1565   function _baseURI() internal view virtual override returns (string memory) {
1566     return uriPrefix;
1567   }
1568 }