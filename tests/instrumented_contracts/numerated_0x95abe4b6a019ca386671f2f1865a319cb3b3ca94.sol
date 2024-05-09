1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev These functions deal with verification of Merkle Trees proofs.
11  *
12  * The proofs can be generated using the JavaScript library
13  * https://github.com/miguelmota/merkletreejs[merkletreejs].
14  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
15  *
16  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf)
42         internal
43         pure
44         returns (bytes32)
45     {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b)
61         private
62         pure
63         returns (bytes32 value)
64     {
65         assembly {
66             mstore(0x00, a)
67             mstore(0x20, b)
68             value := keccak256(0x00, 0x40)
69         }
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/Strings.sol
74 
75 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev String operations.
81  */
82 library Strings {
83     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
84 
85     /**
86      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
87      */
88     function toString(uint256 value) internal pure returns (string memory) {
89         // Inspired by OraclizeAPI's implementation - MIT licence
90         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
91 
92         if (value == 0) {
93             return "0";
94         }
95         uint256 temp = value;
96         uint256 digits;
97         while (temp != 0) {
98             digits++;
99             temp /= 10;
100         }
101         bytes memory buffer = new bytes(digits);
102         while (value != 0) {
103             digits -= 1;
104             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
105             value /= 10;
106         }
107         return string(buffer);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
112      */
113     function toHexString(uint256 value) internal pure returns (string memory) {
114         if (value == 0) {
115             return "0x00";
116         }
117         uint256 temp = value;
118         uint256 length = 0;
119         while (temp != 0) {
120             length++;
121             temp >>= 8;
122         }
123         return toHexString(value, length);
124     }
125 
126     /**
127      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
128      */
129     function toHexString(uint256 value, uint256 length)
130         internal
131         pure
132         returns (string memory)
133     {
134         bytes memory buffer = new bytes(2 * length + 2);
135         buffer[0] = "0";
136         buffer[1] = "x";
137         for (uint256 i = 2 * length + 1; i > 1; --i) {
138             buffer[i] = _HEX_SYMBOLS[value & 0xf];
139             value >>= 4;
140         }
141         require(value == 0, "Strings: hex length insufficient");
142         return string(buffer);
143     }
144 }
145 
146 // File: @openzeppelin/contracts/utils/Context.sol
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/access/Ownable.sol
173 
174 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
175 
176 pragma solidity ^0.8.0;
177 
178 /**
179  * @dev Contract module which provides a basic access control mechanism, where
180  * there is an account (an owner) that can be granted exclusive access to
181  * specific functions.
182  *
183  * By default, the owner account will be the one that deploys the contract. This
184  * can later be changed with {transferOwnership}.
185  *
186  * This module is used through inheritance. It will make available the modifier
187  * `onlyOwner`, which can be applied to your functions to restrict their use to
188  * the owner.
189  */
190 abstract contract Ownable is Context {
191     address private _owner;
192 
193     event OwnershipTransferred(
194         address indexed previousOwner,
195         address indexed newOwner
196     );
197 
198     /**
199      * @dev Initializes the contract setting the deployer as the initial owner.
200      */
201     constructor() {
202         _transferOwnership(_msgSender());
203     }
204 
205     /**
206      * @dev Returns the address of the current owner.
207      */
208     function owner() public view virtual returns (address) {
209         return _owner;
210     }
211 
212     /**
213      * @dev Throws if called by any account other than the owner.
214      */
215     modifier onlyOwner() {
216         require(owner() == _msgSender(), "Ownable: caller is not the owner");
217         _;
218     }
219 
220     /**
221      * @dev Leaves the contract without owner. It will not be possible to call
222      * `onlyOwner` functions anymore. Can only be called by the current owner.
223      *
224      * NOTE: Renouncing ownership will leave the contract without an owner,
225      * thereby removing any functionality that is only available to the owner.
226      */
227     function renounceOwnership() public virtual onlyOwner {
228         _transferOwnership(address(0));
229     }
230 
231     /**
232      * @dev Transfers ownership of the contract to a new account (`newOwner`).
233      * Can only be called by the current owner.
234      */
235     function transferOwnership(address newOwner) public virtual onlyOwner {
236         require(
237             newOwner != address(0),
238             "Ownable: new owner is the zero address"
239         );
240         _transferOwnership(newOwner);
241     }
242 
243     /**
244      * @dev Transfers ownership of the contract to a new account (`newOwner`).
245      * Internal function without access restriction.
246      */
247     function _transferOwnership(address newOwner) internal virtual {
248         address oldOwner = _owner;
249         _owner = newOwner;
250         emit OwnershipTransferred(oldOwner, newOwner);
251     }
252 }
253 
254 // File: @openzeppelin/contracts/utils/Address.sol
255 
256 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
257 
258 pragma solidity ^0.8.1;
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      *
281      * [IMPORTANT]
282      * ====
283      * You shouldn't rely on `isContract` to protect against flash loan attacks!
284      *
285      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
286      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
287      * constructor.
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // This method relies on extcodesize/address.code.length, which returns 0
292         // for contracts in construction, since the code is only stored at the end
293         // of the constructor execution.
294 
295         return account.code.length > 0;
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(
316             address(this).balance >= amount,
317             "Address: insufficient balance"
318         );
319 
320         (bool success, ) = recipient.call{value: amount}("");
321         require(
322             success,
323             "Address: unable to send value, recipient may have reverted"
324         );
325     }
326 
327     /**
328      * @dev Performs a Solidity function call using a low level `call`. A
329      * plain `call` is an unsafe replacement for a function call: use this
330      * function instead.
331      *
332      * If `target` reverts with a revert reason, it is bubbled up by this
333      * function (like regular Solidity function calls).
334      *
335      * Returns the raw returned data. To convert to the expected return value,
336      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
337      *
338      * Requirements:
339      *
340      * - `target` must be a contract.
341      * - calling `target` with `data` must not revert.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data)
346         internal
347         returns (bytes memory)
348     {
349         return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value
381     ) internal returns (bytes memory) {
382         return
383             functionCallWithValue(
384                 target,
385                 data,
386                 value,
387                 "Address: low-level call with value failed"
388             );
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
393      * with `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(
398         address target,
399         bytes memory data,
400         uint256 value,
401         string memory errorMessage
402     ) internal returns (bytes memory) {
403         require(
404             address(this).balance >= value,
405             "Address: insufficient balance for call"
406         );
407         require(isContract(target), "Address: call to non-contract");
408 
409         (bool success, bytes memory returndata) = target.call{value: value}(
410             data
411         );
412         return verifyCallResult(success, returndata, errorMessage);
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
417      * but performing a static call.
418      *
419      * _Available since v3.3._
420      */
421     function functionStaticCall(address target, bytes memory data)
422         internal
423         view
424         returns (bytes memory)
425     {
426         return
427             functionStaticCall(
428                 target,
429                 data,
430                 "Address: low-level static call failed"
431             );
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
436      * but performing a static call.
437      *
438      * _Available since v3.3._
439      */
440     function functionStaticCall(
441         address target,
442         bytes memory data,
443         string memory errorMessage
444     ) internal view returns (bytes memory) {
445         require(isContract(target), "Address: static call to non-contract");
446 
447         (bool success, bytes memory returndata) = target.staticcall(data);
448         return verifyCallResult(success, returndata, errorMessage);
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
453      * but performing a delegate call.
454      *
455      * _Available since v3.4._
456      */
457     function functionDelegateCall(address target, bytes memory data)
458         internal
459         returns (bytes memory)
460     {
461         return
462             functionDelegateCall(
463                 target,
464                 data,
465                 "Address: low-level delegate call failed"
466             );
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
471      * but performing a delegate call.
472      *
473      * _Available since v3.4._
474      */
475     function functionDelegateCall(
476         address target,
477         bytes memory data,
478         string memory errorMessage
479     ) internal returns (bytes memory) {
480         require(isContract(target), "Address: delegate call to non-contract");
481 
482         (bool success, bytes memory returndata) = target.delegatecall(data);
483         return verifyCallResult(success, returndata, errorMessage);
484     }
485 
486     /**
487      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
488      * revert reason using the provided one.
489      *
490      * _Available since v4.3._
491      */
492     function verifyCallResult(
493         bool success,
494         bytes memory returndata,
495         string memory errorMessage
496     ) internal pure returns (bytes memory) {
497         if (success) {
498             return returndata;
499         } else {
500             // Look for revert reason and bubble it up if present
501             if (returndata.length > 0) {
502                 // The easiest way to bubble the revert reason is using memory via assembly
503 
504                 assembly {
505                     let returndata_size := mload(returndata)
506                     revert(add(32, returndata), returndata_size)
507                 }
508             } else {
509                 revert(errorMessage);
510             }
511         }
512     }
513 }
514 
515 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
516 
517 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
518 
519 pragma solidity ^0.8.0;
520 
521 /**
522  * @title ERC721 token receiver interface
523  * @dev Interface for any contract that wants to support safeTransfers
524  * from ERC721 asset contracts.
525  */
526 interface IERC721Receiver {
527     /**
528      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
529      * by `operator` from `from`, this function is called.
530      *
531      * It must return its Solidity selector to confirm the token transfer.
532      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
533      *
534      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
535      */
536     function onERC721Received(
537         address operator,
538         address from,
539         uint256 tokenId,
540         bytes calldata data
541     ) external returns (bytes4);
542 }
543 
544 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
545 
546 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
547 
548 pragma solidity ^0.8.0;
549 
550 /**
551  * @dev Interface of the ERC165 standard, as defined in the
552  * https://eips.ethereum.org/EIPS/eip-165[EIP].
553  *
554  * Implementers can declare support of contract interfaces, which can then be
555  * queried by others ({ERC165Checker}).
556  *
557  * For an implementation, see {ERC165}.
558  */
559 interface IERC165 {
560     /**
561      * @dev Returns true if this contract implements the interface defined by
562      * `interfaceId`. See the corresponding
563      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
564      * to learn more about how these ids are created.
565      *
566      * This function call must use less than 30 000 gas.
567      */
568     function supportsInterface(bytes4 interfaceId) external view returns (bool);
569 }
570 
571 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
572 
573 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
574 
575 pragma solidity ^0.8.0;
576 
577 /**
578  * @dev Implementation of the {IERC165} interface.
579  *
580  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
581  * for the additional interface id that will be supported. For example:
582  *
583  * ```solidity
584  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
585  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
586  * }
587  * ```
588  *
589  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
590  */
591 abstract contract ERC165 is IERC165 {
592     /**
593      * @dev See {IERC165-supportsInterface}.
594      */
595     function supportsInterface(bytes4 interfaceId)
596         public
597         view
598         virtual
599         override
600         returns (bool)
601     {
602         return interfaceId == type(IERC165).interfaceId;
603     }
604 }
605 
606 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
607 
608 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 /**
613  * @dev Required interface of an ERC721 compliant contract.
614  */
615 interface IERC721 is IERC165 {
616     /**
617      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
618      */
619     event Transfer(
620         address indexed from,
621         address indexed to,
622         uint256 indexed tokenId
623     );
624 
625     /**
626      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
627      */
628     event Approval(
629         address indexed owner,
630         address indexed approved,
631         uint256 indexed tokenId
632     );
633 
634     /**
635      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
636      */
637     event ApprovalForAll(
638         address indexed owner,
639         address indexed operator,
640         bool approved
641     );
642 
643     /**
644      * @dev Returns the number of tokens in ``owner``'s account.
645      */
646     function balanceOf(address owner) external view returns (uint256 balance);
647 
648     /**
649      * @dev Returns the owner of the `tokenId` token.
650      *
651      * Requirements:
652      *
653      * - `tokenId` must exist.
654      */
655     function ownerOf(uint256 tokenId) external view returns (address owner);
656 
657     /**
658      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
659      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
660      *
661      * Requirements:
662      *
663      * - `from` cannot be the zero address.
664      * - `to` cannot be the zero address.
665      * - `tokenId` token must exist and be owned by `from`.
666      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
667      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
668      *
669      * Emits a {Transfer} event.
670      */
671     function safeTransferFrom(
672         address from,
673         address to,
674         uint256 tokenId
675     ) external;
676 
677     /**
678      * @dev Transfers `tokenId` token from `from` to `to`.
679      *
680      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
681      *
682      * Requirements:
683      *
684      * - `from` cannot be the zero address.
685      * - `to` cannot be the zero address.
686      * - `tokenId` token must be owned by `from`.
687      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
688      *
689      * Emits a {Transfer} event.
690      */
691     function transferFrom(
692         address from,
693         address to,
694         uint256 tokenId
695     ) external;
696 
697     /**
698      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
699      * The approval is cleared when the token is transferred.
700      *
701      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
702      *
703      * Requirements:
704      *
705      * - The caller must own the token or be an approved operator.
706      * - `tokenId` must exist.
707      *
708      * Emits an {Approval} event.
709      */
710     function approve(address to, uint256 tokenId) external;
711 
712     /**
713      * @dev Returns the account approved for `tokenId` token.
714      *
715      * Requirements:
716      *
717      * - `tokenId` must exist.
718      */
719     function getApproved(uint256 tokenId)
720         external
721         view
722         returns (address operator);
723 
724     /**
725      * @dev Approve or remove `operator` as an operator for the caller.
726      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
727      *
728      * Requirements:
729      *
730      * - The `operator` cannot be the caller.
731      *
732      * Emits an {ApprovalForAll} event.
733      */
734     function setApprovalForAll(address operator, bool _approved) external;
735 
736     /**
737      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
738      *
739      * See {setApprovalForAll}
740      */
741     function isApprovedForAll(address owner, address operator)
742         external
743         view
744         returns (bool);
745 
746     /**
747      * @dev Safely transfers `tokenId` token from `from` to `to`.
748      *
749      * Requirements:
750      *
751      * - `from` cannot be the zero address.
752      * - `to` cannot be the zero address.
753      * - `tokenId` token must exist and be owned by `from`.
754      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
755      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
756      *
757      * Emits a {Transfer} event.
758      */
759     function safeTransferFrom(
760         address from,
761         address to,
762         uint256 tokenId,
763         bytes calldata data
764     ) external;
765 }
766 
767 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
768 
769 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
770 
771 pragma solidity ^0.8.0;
772 
773 /**
774  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
775  * @dev See https://eips.ethereum.org/EIPS/eip-721
776  */
777 interface IERC721Metadata is IERC721 {
778     /**
779      * @dev Returns the token collection name.
780      */
781     function name() external view returns (string memory);
782 
783     /**
784      * @dev Returns the token collection symbol.
785      */
786     function symbol() external view returns (string memory);
787 
788     /**
789      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
790      */
791     function tokenURI(uint256 tokenId) external view returns (string memory);
792 }
793 
794 // File: erc721a/contracts/ERC721A.sol
795 
796 // Creator: Chiru Labs
797 
798 pragma solidity ^0.8.4;
799 
800 error ApprovalCallerNotOwnerNorApproved();
801 error ApprovalQueryForNonexistentToken();
802 error ApproveToCaller();
803 error ApprovalToCurrentOwner();
804 error BalanceQueryForZeroAddress();
805 error MintToZeroAddress();
806 error MintZeroQuantity();
807 error OwnerQueryForNonexistentToken();
808 error TransferCallerNotOwnerNorApproved();
809 error TransferFromIncorrectOwner();
810 error TransferToNonERC721ReceiverImplementer();
811 error TransferToZeroAddress();
812 error URIQueryForNonexistentToken();
813 
814 /**
815  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
816  * the Metadata extension. Built to optimize for lower gas during batch mints.
817  *
818  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
819  *
820  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
821  *
822  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
823  */
824 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
825     using Address for address;
826     using Strings for uint256;
827 
828     // Compiler will pack this into a single 256bit word.
829     struct TokenOwnership {
830         // The address of the owner.
831         address addr;
832         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
833         uint64 startTimestamp;
834         // Whether the token has been burned.
835         bool burned;
836     }
837 
838     // Compiler will pack this into a single 256bit word.
839     struct AddressData {
840         // Realistically, 2**64-1 is more than enough.
841         uint64 balance;
842         // Keeps track of mint count with minimal overhead for tokenomics.
843         uint64 numberMinted;
844         // Keeps track of burn count with minimal overhead for tokenomics.
845         uint64 numberBurned;
846         // For miscellaneous variable(s) pertaining to the address
847         // (e.g. number of whitelist mint slots used).
848         // If there are multiple variables, please pack them into a uint64.
849         uint64 aux;
850     }
851 
852     // The tokenId of the next token to be minted.
853     uint256 internal _currentIndex;
854 
855     // The number of tokens burned.
856     uint256 internal _burnCounter;
857 
858     // Token name
859     string private _name;
860 
861     // Token symbol
862     string private _symbol;
863 
864     // Mapping from token ID to ownership details
865     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
866     mapping(uint256 => TokenOwnership) internal _ownerships;
867 
868     // Mapping owner address to address data
869     mapping(address => AddressData) private _addressData;
870 
871     // Mapping from token ID to approved address
872     mapping(uint256 => address) private _tokenApprovals;
873 
874     // Mapping from owner to operator approvals
875     mapping(address => mapping(address => bool)) private _operatorApprovals;
876 
877     constructor(string memory name_, string memory symbol_) {
878         _name = name_;
879         _symbol = symbol_;
880         _currentIndex = _startTokenId();
881     }
882 
883     /**
884      * To change the starting tokenId, please override this function.
885      */
886     function _startTokenId() internal view virtual returns (uint256) {
887         return 0;
888     }
889 
890     /**
891      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
892      */
893     function totalSupply() public view returns (uint256) {
894         // Counter underflow is impossible as _burnCounter cannot be incremented
895         // more than _currentIndex - _startTokenId() times
896         unchecked {
897             return _currentIndex - _burnCounter - _startTokenId();
898         }
899     }
900 
901     /**
902      * Returns the total amount of tokens minted in the contract.
903      */
904     function _totalMinted() internal view returns (uint256) {
905         // Counter underflow is impossible as _currentIndex does not decrement,
906         // and it is initialized to _startTokenId()
907         unchecked {
908             return _currentIndex - _startTokenId();
909         }
910     }
911 
912     /**
913      * @dev See {IERC165-supportsInterface}.
914      */
915     function supportsInterface(bytes4 interfaceId)
916         public
917         view
918         virtual
919         override(ERC165, IERC165)
920         returns (bool)
921     {
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
969     function _ownershipOf(uint256 tokenId)
970         internal
971         view
972         returns (TokenOwnership memory)
973     {
974         uint256 curr = tokenId;
975 
976         unchecked {
977             if (_startTokenId() <= curr && curr < _currentIndex) {
978                 TokenOwnership memory ownership = _ownerships[curr];
979                 if (!ownership.burned) {
980                     if (ownership.addr != address(0)) {
981                         return ownership;
982                     }
983                     // Invariant:
984                     // There will always be an ownership that has an address and is not burned
985                     // before an ownership that does not have an address and is not burned.
986                     // Hence, curr will not underflow.
987                     while (true) {
988                         curr--;
989                         ownership = _ownerships[curr];
990                         if (ownership.addr != address(0)) {
991                             return ownership;
992                         }
993                     }
994                 }
995             }
996         }
997         revert OwnerQueryForNonexistentToken();
998     }
999 
1000     /**
1001      * @dev See {IERC721-ownerOf}.
1002      */
1003     function ownerOf(uint256 tokenId) public view override returns (address) {
1004         return _ownershipOf(tokenId).addr;
1005     }
1006 
1007     /**
1008      * @dev See {IERC721Metadata-name}.
1009      */
1010     function name() public view virtual override returns (string memory) {
1011         return _name;
1012     }
1013 
1014     /**
1015      * @dev See {IERC721Metadata-symbol}.
1016      */
1017     function symbol() public view virtual override returns (string memory) {
1018         return _symbol;
1019     }
1020 
1021     /**
1022      * @dev See {IERC721Metadata-tokenURI}.
1023      */
1024     function tokenURI(uint256 tokenId)
1025         public
1026         view
1027         virtual
1028         override
1029         returns (string memory)
1030     {
1031         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1032 
1033         string memory baseURI = _baseURI();
1034         return
1035             bytes(baseURI).length != 0
1036                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1037                 : "";
1038     }
1039 
1040     /**
1041      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1042      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1043      * by default, can be overriden in child contracts.
1044      */
1045     function _baseURI() internal view virtual returns (string memory) {
1046         return "";
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-approve}.
1051      */
1052     function approve(address to, uint256 tokenId) public override {
1053         address owner = ERC721A.ownerOf(tokenId);
1054         if (to == owner) revert ApprovalToCurrentOwner();
1055 
1056         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1057             revert ApprovalCallerNotOwnerNorApproved();
1058         }
1059 
1060         _approve(to, tokenId, owner);
1061     }
1062 
1063     /**
1064      * @dev See {IERC721-getApproved}.
1065      */
1066     function getApproved(uint256 tokenId)
1067         public
1068         view
1069         override
1070         returns (address)
1071     {
1072         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1073 
1074         return _tokenApprovals[tokenId];
1075     }
1076 
1077     /**
1078      * @dev See {IERC721-setApprovalForAll}.
1079      */
1080     function setApprovalForAll(address operator, bool approved)
1081         public
1082         virtual
1083         override
1084     {
1085         if (operator == _msgSender()) revert ApproveToCaller();
1086 
1087         _operatorApprovals[_msgSender()][operator] = approved;
1088         emit ApprovalForAll(_msgSender(), operator, approved);
1089     }
1090 
1091     /**
1092      * @dev See {IERC721-isApprovedForAll}.
1093      */
1094     function isApprovedForAll(address owner, address operator)
1095         public
1096         view
1097         virtual
1098         override
1099         returns (bool)
1100     {
1101         return _operatorApprovals[owner][operator];
1102     }
1103 
1104     /**
1105      * @dev See {IERC721-transferFrom}.
1106      */
1107     function transferFrom(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) public virtual override {
1112         _transfer(from, to, tokenId);
1113     }
1114 
1115     /**
1116      * @dev See {IERC721-safeTransferFrom}.
1117      */
1118     function safeTransferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) public virtual override {
1123         safeTransferFrom(from, to, tokenId, "");
1124     }
1125 
1126     /**
1127      * @dev See {IERC721-safeTransferFrom}.
1128      */
1129     function safeTransferFrom(
1130         address from,
1131         address to,
1132         uint256 tokenId,
1133         bytes memory _data
1134     ) public virtual override {
1135         _transfer(from, to, tokenId);
1136         if (
1137             to.isContract() &&
1138             !_checkContractOnERC721Received(from, to, tokenId, _data)
1139         ) {
1140             revert TransferToNonERC721ReceiverImplementer();
1141         }
1142     }
1143 
1144     /**
1145      * @dev Returns whether `tokenId` exists.
1146      *
1147      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1148      *
1149      * Tokens start existing when they are minted (`_mint`),
1150      */
1151     function _exists(uint256 tokenId) internal view returns (bool) {
1152         return
1153             _startTokenId() <= tokenId &&
1154             tokenId < _currentIndex &&
1155             !_ownerships[tokenId].burned;
1156     }
1157 
1158     function _safeMint(address to, uint256 quantity) internal {
1159         _safeMint(to, quantity, "");
1160     }
1161 
1162     /**
1163      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1164      *
1165      * Requirements:
1166      *
1167      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1168      * - `quantity` must be greater than 0.
1169      *
1170      * Emits a {Transfer} event.
1171      */
1172     function _safeMint(
1173         address to,
1174         uint256 quantity,
1175         bytes memory _data
1176     ) internal {
1177         _mint(to, quantity, _data, true);
1178     }
1179 
1180     /**
1181      * @dev Mints `quantity` tokens and transfers them to `to`.
1182      *
1183      * Requirements:
1184      *
1185      * - `to` cannot be the zero address.
1186      * - `quantity` must be greater than 0.
1187      *
1188      * Emits a {Transfer} event.
1189      */
1190     function _mint(
1191         address to,
1192         uint256 quantity,
1193         bytes memory _data,
1194         bool safe
1195     ) internal {
1196         uint256 startTokenId = _currentIndex;
1197         if (to == address(0)) revert MintToZeroAddress();
1198         if (quantity == 0) revert MintZeroQuantity();
1199 
1200         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1201 
1202         // Overflows are incredibly unrealistic.
1203         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1204         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1205         unchecked {
1206             _addressData[to].balance += uint64(quantity);
1207             _addressData[to].numberMinted += uint64(quantity);
1208 
1209             _ownerships[startTokenId].addr = to;
1210             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1211 
1212             uint256 updatedIndex = startTokenId;
1213             uint256 end = updatedIndex + quantity;
1214 
1215             if (safe && to.isContract()) {
1216                 do {
1217                     emit Transfer(address(0), to, updatedIndex);
1218                     if (
1219                         !_checkContractOnERC721Received(
1220                             address(0),
1221                             to,
1222                             updatedIndex++,
1223                             _data
1224                         )
1225                     ) {
1226                         revert TransferToNonERC721ReceiverImplementer();
1227                     }
1228                 } while (updatedIndex != end);
1229                 // Reentrancy protection
1230                 if (_currentIndex != startTokenId) revert();
1231             } else {
1232                 do {
1233                     emit Transfer(address(0), to, updatedIndex++);
1234                 } while (updatedIndex != end);
1235             }
1236             _currentIndex = updatedIndex;
1237         }
1238         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1239     }
1240 
1241     /**
1242      * @dev Transfers `tokenId` from `from` to `to`.
1243      *
1244      * Requirements:
1245      *
1246      * - `to` cannot be the zero address.
1247      * - `tokenId` token must be owned by `from`.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _transfer(
1252         address from,
1253         address to,
1254         uint256 tokenId
1255     ) private {
1256         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1257 
1258         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1259 
1260         bool isApprovedOrOwner = (_msgSender() == from ||
1261             isApprovedForAll(from, _msgSender()) ||
1262             getApproved(tokenId) == _msgSender());
1263 
1264         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1265         if (to == address(0)) revert TransferToZeroAddress();
1266 
1267         _beforeTokenTransfers(from, to, tokenId, 1);
1268 
1269         // Clear approvals from the previous owner
1270         _approve(address(0), tokenId, from);
1271 
1272         // Underflow of the sender's balance is impossible because we check for
1273         // ownership above and the recipient's balance can't realistically overflow.
1274         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1275         unchecked {
1276             _addressData[from].balance -= 1;
1277             _addressData[to].balance += 1;
1278 
1279             TokenOwnership storage currSlot = _ownerships[tokenId];
1280             currSlot.addr = to;
1281             currSlot.startTimestamp = uint64(block.timestamp);
1282 
1283             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1284             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1285             uint256 nextTokenId = tokenId + 1;
1286             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1287             if (nextSlot.addr == address(0)) {
1288                 // This will suffice for checking _exists(nextTokenId),
1289                 // as a burned slot cannot contain the zero address.
1290                 if (nextTokenId != _currentIndex) {
1291                     nextSlot.addr = from;
1292                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1293                 }
1294             }
1295         }
1296 
1297         emit Transfer(from, to, tokenId);
1298         _afterTokenTransfers(from, to, tokenId, 1);
1299     }
1300 
1301     /**
1302      * @dev This is equivalent to _burn(tokenId, false)
1303      */
1304     function _burn(uint256 tokenId) internal virtual {
1305         _burn(tokenId, false);
1306     }
1307 
1308     /**
1309      * @dev Destroys `tokenId`.
1310      * The approval is cleared when the token is burned.
1311      *
1312      * Requirements:
1313      *
1314      * - `tokenId` must exist.
1315      *
1316      * Emits a {Transfer} event.
1317      */
1318     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1319         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1320 
1321         address from = prevOwnership.addr;
1322 
1323         if (approvalCheck) {
1324             bool isApprovedOrOwner = (_msgSender() == from ||
1325                 isApprovedForAll(from, _msgSender()) ||
1326                 getApproved(tokenId) == _msgSender());
1327 
1328             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1329         }
1330 
1331         _beforeTokenTransfers(from, address(0), tokenId, 1);
1332 
1333         // Clear approvals from the previous owner
1334         _approve(address(0), tokenId, from);
1335 
1336         // Underflow of the sender's balance is impossible because we check for
1337         // ownership above and the recipient's balance can't realistically overflow.
1338         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1339         unchecked {
1340             AddressData storage addressData = _addressData[from];
1341             addressData.balance -= 1;
1342             addressData.numberBurned += 1;
1343 
1344             // Keep track of who burned the token, and the timestamp of burning.
1345             TokenOwnership storage currSlot = _ownerships[tokenId];
1346             currSlot.addr = from;
1347             currSlot.startTimestamp = uint64(block.timestamp);
1348             currSlot.burned = true;
1349 
1350             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1351             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1352             uint256 nextTokenId = tokenId + 1;
1353             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1354             if (nextSlot.addr == address(0)) {
1355                 // This will suffice for checking _exists(nextTokenId),
1356                 // as a burned slot cannot contain the zero address.
1357                 if (nextTokenId != _currentIndex) {
1358                     nextSlot.addr = from;
1359                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1360                 }
1361             }
1362         }
1363 
1364         emit Transfer(from, address(0), tokenId);
1365         _afterTokenTransfers(from, address(0), tokenId, 1);
1366 
1367         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1368         unchecked {
1369             _burnCounter++;
1370         }
1371     }
1372 
1373     /**
1374      * @dev Approve `to` to operate on `tokenId`
1375      *
1376      * Emits a {Approval} event.
1377      */
1378     function _approve(
1379         address to,
1380         uint256 tokenId,
1381         address owner
1382     ) private {
1383         _tokenApprovals[tokenId] = to;
1384         emit Approval(owner, to, tokenId);
1385     }
1386 
1387     /**
1388      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1389      *
1390      * @param from address representing the previous owner of the given token ID
1391      * @param to target address that will receive the tokens
1392      * @param tokenId uint256 ID of the token to be transferred
1393      * @param _data bytes optional data to send along with the call
1394      * @return bool whether the call correctly returned the expected magic value
1395      */
1396     function _checkContractOnERC721Received(
1397         address from,
1398         address to,
1399         uint256 tokenId,
1400         bytes memory _data
1401     ) private returns (bool) {
1402         try
1403             IERC721Receiver(to).onERC721Received(
1404                 _msgSender(),
1405                 from,
1406                 tokenId,
1407                 _data
1408             )
1409         returns (bytes4 retval) {
1410             return retval == IERC721Receiver(to).onERC721Received.selector;
1411         } catch (bytes memory reason) {
1412             if (reason.length == 0) {
1413                 revert TransferToNonERC721ReceiverImplementer();
1414             } else {
1415                 assembly {
1416                     revert(add(32, reason), mload(reason))
1417                 }
1418             }
1419         }
1420     }
1421 
1422     /**
1423      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1424      * And also called before burning one token.
1425      *
1426      * startTokenId - the first token id to be transferred
1427      * quantity - the amount to be transferred
1428      *
1429      * Calling conditions:
1430      *
1431      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1432      * transferred to `to`.
1433      * - When `from` is zero, `tokenId` will be minted for `to`.
1434      * - When `to` is zero, `tokenId` will be burned by `from`.
1435      * - `from` and `to` are never both zero.
1436      */
1437     function _beforeTokenTransfers(
1438         address from,
1439         address to,
1440         uint256 startTokenId,
1441         uint256 quantity
1442     ) internal virtual {}
1443 
1444     /**
1445      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1446      * minting.
1447      * And also called after one token has been burned.
1448      *
1449      * startTokenId - the first token id to be transferred
1450      * quantity - the amount to be transferred
1451      *
1452      * Calling conditions:
1453      *
1454      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1455      * transferred to `to`.
1456      * - When `from` is zero, `tokenId` has been minted for `to`.
1457      * - When `to` is zero, `tokenId` has been burned by `from`.
1458      * - `from` and `to` are never both zero.
1459      */
1460     function _afterTokenTransfers(
1461         address from,
1462         address to,
1463         uint256 startTokenId,
1464         uint256 quantity
1465     ) internal virtual {}
1466 }
1467 
1468 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1469 
1470 // Creator: Chiru Labs
1471 
1472 pragma solidity ^0.8.4;
1473 
1474 error InvalidQueryRange();
1475 
1476 /**
1477  * @title ERC721A Queryable
1478  * @dev ERC721A subclass with convenience query functions.
1479  */
1480 abstract contract ERC721AQueryable is ERC721A {
1481     /**
1482      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1483      *
1484      * If the `tokenId` is out of bounds:
1485      *   - `addr` = `address(0)`
1486      *   - `startTimestamp` = `0`
1487      *   - `burned` = `false`
1488      *
1489      * If the `tokenId` is burned:
1490      *   - `addr` = `<Address of owner before token was burned>`
1491      *   - `startTimestamp` = `<Timestamp when token was burned>`
1492      *   - `burned = `true`
1493      *
1494      * Otherwise:
1495      *   - `addr` = `<Address of owner>`
1496      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1497      *   - `burned = `false`
1498      */
1499     function explicitOwnershipOf(uint256 tokenId)
1500         public
1501         view
1502         returns (TokenOwnership memory)
1503     {
1504         TokenOwnership memory ownership;
1505         if (tokenId < _startTokenId() || tokenId >= _currentIndex) {
1506             return ownership;
1507         }
1508         ownership = _ownerships[tokenId];
1509         if (ownership.burned) {
1510             return ownership;
1511         }
1512         return _ownershipOf(tokenId);
1513     }
1514 
1515     /**
1516      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1517      * See {ERC721AQueryable-explicitOwnershipOf}
1518      */
1519     function explicitOwnershipsOf(uint256[] memory tokenIds)
1520         external
1521         view
1522         returns (TokenOwnership[] memory)
1523     {
1524         unchecked {
1525             uint256 tokenIdsLength = tokenIds.length;
1526             TokenOwnership[] memory ownerships = new TokenOwnership[](
1527                 tokenIdsLength
1528             );
1529             for (uint256 i; i != tokenIdsLength; ++i) {
1530                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1531             }
1532             return ownerships;
1533         }
1534     }
1535 
1536     /**
1537      * @dev Returns an array of token IDs owned by `owner`,
1538      * in the range [`start`, `stop`)
1539      * (i.e. `start <= tokenId < stop`).
1540      *
1541      * This function allows for tokens to be queried if the collection
1542      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1543      *
1544      * Requirements:
1545      *
1546      * - `start` < `stop`
1547      */
1548     function tokensOfOwnerIn(
1549         address owner,
1550         uint256 start,
1551         uint256 stop
1552     ) external view returns (uint256[] memory) {
1553         unchecked {
1554             if (start >= stop) revert InvalidQueryRange();
1555             uint256 tokenIdsIdx;
1556             uint256 stopLimit = _currentIndex;
1557             // Set `start = max(start, _startTokenId())`.
1558             if (start < _startTokenId()) {
1559                 start = _startTokenId();
1560             }
1561             // Set `stop = min(stop, _currentIndex)`.
1562             if (stop > stopLimit) {
1563                 stop = stopLimit;
1564             }
1565             uint256 tokenIdsMaxLength = balanceOf(owner);
1566             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1567             // to cater for cases where `balanceOf(owner)` is too big.
1568             if (start < stop) {
1569                 uint256 rangeLength = stop - start;
1570                 if (rangeLength < tokenIdsMaxLength) {
1571                     tokenIdsMaxLength = rangeLength;
1572                 }
1573             } else {
1574                 tokenIdsMaxLength = 0;
1575             }
1576             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1577             if (tokenIdsMaxLength == 0) {
1578                 return tokenIds;
1579             }
1580             // We need to call `explicitOwnershipOf(start)`,
1581             // because the slot at `start` may not be initialized.
1582             TokenOwnership memory ownership = explicitOwnershipOf(start);
1583             address currOwnershipAddr;
1584             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1585             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1586             if (!ownership.burned) {
1587                 currOwnershipAddr = ownership.addr;
1588             }
1589             for (
1590                 uint256 i = start;
1591                 i != stop && tokenIdsIdx != tokenIdsMaxLength;
1592                 ++i
1593             ) {
1594                 ownership = _ownerships[i];
1595                 if (ownership.burned) {
1596                     continue;
1597                 }
1598                 if (ownership.addr != address(0)) {
1599                     currOwnershipAddr = ownership.addr;
1600                 }
1601                 if (currOwnershipAddr == owner) {
1602                     tokenIds[tokenIdsIdx++] = i;
1603                 }
1604             }
1605             // Downsize the array to fit.
1606             assembly {
1607                 mstore(tokenIds, tokenIdsIdx)
1608             }
1609             return tokenIds;
1610         }
1611     }
1612 
1613     /**
1614      * @dev Returns an array of token IDs owned by `owner`.
1615      *
1616      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1617      * It is meant to be called off-chain.
1618      *
1619      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1620      * multiple smaller scans if the collection is large enough to cause
1621      * an out-of-gas error (10K pfp collections should be fine).
1622      */
1623     function tokensOfOwner(address owner)
1624         external
1625         view
1626         returns (uint256[] memory)
1627     {
1628         unchecked {
1629             uint256 tokenIdsIdx;
1630             address currOwnershipAddr;
1631             uint256 tokenIdsLength = balanceOf(owner);
1632             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1633             TokenOwnership memory ownership;
1634             for (
1635                 uint256 i = _startTokenId();
1636                 tokenIdsIdx != tokenIdsLength;
1637                 ++i
1638             ) {
1639                 ownership = _ownerships[i];
1640                 if (ownership.burned) {
1641                     continue;
1642                 }
1643                 if (ownership.addr != address(0)) {
1644                     currOwnershipAddr = ownership.addr;
1645                 }
1646                 if (currOwnershipAddr == owner) {
1647                     tokenIds[tokenIdsIdx++] = i;
1648                 }
1649             }
1650             return tokenIds;
1651         }
1652     }
1653 }
1654 
1655 // File: contracts/EthernalGates.sol
1656 
1657 pragma solidity 0.8.4;
1658 
1659 error ExceedsMaximumSupply();
1660 error SupplyExceedingMaxSupply();
1661 error TransferFailed();
1662 error CallerIsContract();
1663 error PresaleNotStarted();
1664 error AddressNotEligibleForPresaleMint();
1665 error CountExceedsAllowedMintCount();
1666 error IncorrectEtherSent();
1667 error PublicSaleNotStarted();
1668 error TransactionExceedsMaxNFTsAllowedInPresale();
1669 
1670 /// @author Hammad Ghazi
1671 contract EthernalGates is ERC721AQueryable, Ownable {
1672     using MerkleProof for bytes32[];
1673 
1674     enum SALE_STATUS {
1675         OFF,
1676         INVESTOR,
1677         VIP,
1678         WL,
1679         PUBLIC
1680     }
1681 
1682     SALE_STATUS public saleStatus;
1683 
1684     string private baseTokenURI;
1685 
1686     // Max Supply of Ethernal Gates
1687     uint256 public constant MAX_SUPPLY = 6000;
1688 
1689     // Holds max number of NFTs that can be minted at the moment
1690     uint256 public currentSupply = 2000;
1691 
1692     uint256 public presalePrice = 0.49 ether;
1693     uint256 public publicPrice = 0.59 ether;
1694 
1695     bytes32 public merkleRoot;
1696 
1697     // To store NFTs a particular address has minted in each whitelist phase
1698     struct MintCounts {
1699         uint16 investorMintCount;
1700         uint16 vipMintCount;
1701         uint16 wlMintCount;
1702     }
1703 
1704     mapping(address => MintCounts) public mintCounts;
1705 
1706     constructor(string memory baseURI)
1707         ERC721A("Ethernal Gates", "Ethernal Gates")
1708     {
1709         baseTokenURI = baseURI;
1710     }
1711 
1712     modifier soldOut(uint256 _count) {
1713         if (_totalMinted() + _count > currentSupply)
1714             revert ExceedsMaximumSupply();
1715         _;
1716     }
1717 
1718     // Admin only functions
1719 
1720     // To update sale status
1721     function setSaleStatus(SALE_STATUS _status) external onlyOwner {
1722         saleStatus = _status;
1723     }
1724 
1725     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1726         merkleRoot = _merkleRoot;
1727     }
1728 
1729     function setBaseURI(string calldata baseURI) external onlyOwner {
1730         baseTokenURI = baseURI;
1731     }
1732 
1733     function changePresalePrice(uint256 _presalePrice) external onlyOwner {
1734         presalePrice = _presalePrice;
1735     }
1736 
1737     function changePublicPrice(uint256 _publicPrice) external onlyOwner {
1738         publicPrice = _publicPrice;
1739     }
1740 
1741     // To increase the supply, can't exceed 6000
1742     function increaseSupply(uint256 _increaseBy) external onlyOwner {
1743         if (currentSupply + _increaseBy > MAX_SUPPLY)
1744             revert SupplyExceedingMaxSupply();
1745         unchecked {
1746             currentSupply += _increaseBy;
1747         }
1748     }
1749 
1750     function withdraw() external onlyOwner {
1751         (bool success, ) = msg.sender.call{value: address(this).balance}("");
1752         if (!success) revert TransferFailed();
1753     }
1754 
1755     // Set some Ethernal Gates aside
1756     function reserveEthernalGates(uint256 _count)
1757         external
1758         onlyOwner
1759         soldOut(_count)
1760     {
1761         mint(msg.sender, _count);
1762     }
1763 
1764     function airdrop(address[] memory _addresses, uint256 _count)
1765         external
1766         onlyOwner
1767         soldOut(_count * _addresses.length)
1768     {
1769         uint256 stop = _addresses.length;
1770         for (uint256 i; i != stop; ) {
1771             _mint(_addresses[i], _count, "", false);
1772             unchecked {
1773                 i++;
1774             }
1775         }
1776     }
1777 
1778     // Getter functions
1779 
1780     function _baseURI() internal view virtual override returns (string memory) {
1781         return baseTokenURI;
1782     }
1783 
1784     function _startTokenId() internal pure virtual override returns (uint256) {
1785         return 1;
1786     }
1787 
1788     //Mint functions
1789 
1790     /**
1791      * @dev '_allowedCount' represents number of NFTs caller is allowed to mint in presale, and,
1792      * '_count' indiciates number of NFTs caller wants to mint in the transaction
1793      */
1794     function presaleMint(
1795         bytes32[] calldata _proof,
1796         uint256 _allowedCount,
1797         uint16 _count
1798     ) external payable soldOut(_count) {
1799         SALE_STATUS saleState = saleStatus;
1800         MintCounts memory mintCount = mintCounts[msg.sender];
1801         if (saleState == SALE_STATUS.OFF || saleState == SALE_STATUS.PUBLIC)
1802             revert PresaleNotStarted();
1803         if (
1804             !MerkleProof.verify(
1805                 _proof,
1806                 merkleRoot,
1807                 keccak256(abi.encodePacked(msg.sender, _allowedCount))
1808             )
1809         ) revert AddressNotEligibleForPresaleMint();
1810         if (_count > _allowedCount) revert CountExceedsAllowedMintCount();
1811         if (msg.value < presalePrice * _count) revert IncorrectEtherSent();
1812         if (saleState == SALE_STATUS.INVESTOR) {
1813             if (_allowedCount < mintCount.investorMintCount + _count)
1814                 revert TransactionExceedsMaxNFTsAllowedInPresale();
1815             mintCount.investorMintCount += _count;
1816         } else if (saleState == SALE_STATUS.VIP) {
1817             if (_allowedCount < mintCount.vipMintCount + _count)
1818                 revert TransactionExceedsMaxNFTsAllowedInPresale();
1819             mintCount.vipMintCount += _count;
1820         } else {
1821             if (_allowedCount < mintCount.wlMintCount + _count)
1822                 revert TransactionExceedsMaxNFTsAllowedInPresale();
1823             mintCount.wlMintCount += _count;
1824         }
1825         mintCounts[msg.sender] = mintCount;
1826         mint(msg.sender, _count);
1827     }
1828 
1829     // Public mint
1830 
1831     function publicMint(uint256 _count) external payable soldOut(_count) {
1832         if (saleStatus != SALE_STATUS.PUBLIC) revert PublicSaleNotStarted();
1833         if (msg.value < publicPrice * _count) revert IncorrectEtherSent();
1834         mint(msg.sender, _count);
1835     }
1836 
1837     function mint(address _addr, uint256 quantity) private {
1838         if (tx.origin != msg.sender) revert CallerIsContract();
1839         _mint(_addr, quantity, "", false);
1840     }
1841 }