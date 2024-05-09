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
794 // File: contracts/IERC721A.sol
795 
796 // ERC721A Contracts v3.3.0
797 // Creator: Chiru Labs
798 
799 pragma solidity ^0.8.4;
800 
801 /**
802  * @dev Interface of an ERC721A compliant contract.
803  */
804 interface IERC721A is IERC721, IERC721Metadata {
805     /**
806      * The caller must own the token or be an approved operator.
807      */
808     error ApprovalCallerNotOwnerNorApproved();
809 
810     /**
811      * The token does not exist.
812      */
813     error ApprovalQueryForNonexistentToken();
814 
815     /**
816      * The caller cannot approve to their own address.
817      */
818     error ApproveToCaller();
819 
820     /**
821      * The caller cannot approve to the current owner.
822      */
823     error ApprovalToCurrentOwner();
824 
825     /**
826      * Cannot query the balance for the zero address.
827      */
828     error BalanceQueryForZeroAddress();
829 
830     /**
831      * Cannot mint to the zero address.
832      */
833     error MintToZeroAddress();
834 
835     /**
836      * The quantity of tokens minted must be more than zero.
837      */
838     error MintZeroQuantity();
839 
840     /**
841      * The token does not exist.
842      */
843     error OwnerQueryForNonexistentToken();
844 
845     /**
846      * The caller must own the token or be an approved operator.
847      */
848     error TransferCallerNotOwnerNorApproved();
849 
850     /**
851      * The token must be owned by `from`.
852      */
853     error TransferFromIncorrectOwner();
854 
855     /**
856      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
857      */
858     error TransferToNonERC721ReceiverImplementer();
859 
860     /**
861      * Cannot transfer to the zero address.
862      */
863     error TransferToZeroAddress();
864 
865     /**
866      * The token does not exist.
867      */
868     error URIQueryForNonexistentToken();
869 
870     // Compiler will pack this into a single 256bit word.
871     struct TokenOwnership {
872         // The address of the owner.
873         address addr;
874         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
875         uint64 startTimestamp;
876         // Whether the token has been burned.
877         bool burned;
878     }
879 
880     // Compiler will pack this into a single 256bit word.
881     struct AddressData {
882         // Realistically, 2**64-1 is more than enough.
883         uint64 balance;
884         // Keeps track of mint count with minimal overhead for tokenomics.
885         uint64 numberMinted;
886         // Keeps track of burn count with minimal overhead for tokenomics.
887         uint64 numberBurned;
888         // For miscellaneous variable(s) pertaining to the address
889         // (e.g. number of whitelist mint slots used).
890         // If there are multiple variables, please pack them into a uint64.
891         uint64 aux;
892     }
893 
894     /**
895      * @dev Returns the total amount of tokens stored by the contract.
896      *
897      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
898      */
899     function totalSupply() external view returns (uint256);
900 }
901 
902 // File: contracts/ERC721A.sol
903 
904 // ERC721A Contracts v3.3.0
905 // Creator: Chiru Labs
906 
907 pragma solidity ^0.8.4;
908 
909 /**
910  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
911  * the Metadata extension. Built to optimize for lower gas during batch mints.
912  *
913  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
914  *
915  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
916  *
917  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
918  */
919 contract ERC721A is Context, ERC165, IERC721A {
920     using Address for address;
921     using Strings for uint256;
922 
923     // The tokenId of the next token to be minted.
924     uint256 internal _currentIndex;
925 
926     // The number of tokens burned.
927     uint256 internal _burnCounter;
928 
929     // Token name
930     string private _name;
931 
932     // Token symbol
933     string private _symbol;
934 
935     // Mapping from token ID to ownership details
936     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
937     mapping(uint256 => TokenOwnership) internal _ownerships;
938 
939     // Mapping owner address to address data
940     mapping(address => AddressData) private _addressData;
941 
942     // Mapping from token ID to approved address
943     mapping(uint256 => address) private _tokenApprovals;
944 
945     // Mapping from owner to operator approvals
946     mapping(address => mapping(address => bool)) private _operatorApprovals;
947 
948     constructor(string memory name_, string memory symbol_) {
949         _name = name_;
950         _symbol = symbol_;
951         _currentIndex = _startTokenId();
952     }
953 
954     /**
955      * To change the starting tokenId, please override this function.
956      */
957     function _startTokenId() internal view virtual returns (uint256) {
958         return 0;
959     }
960 
961     /**
962      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
963      */
964     function totalSupply() public view override returns (uint256) {
965         // Counter underflow is impossible as _burnCounter cannot be incremented
966         // more than _currentIndex - _startTokenId() times
967         unchecked {
968             return _currentIndex - _burnCounter - _startTokenId();
969         }
970     }
971 
972     /**
973      * Returns the total amount of tokens minted in the contract.
974      */
975     function _totalMinted() internal view returns (uint256) {
976         // Counter underflow is impossible as _currentIndex does not decrement,
977         // and it is initialized to _startTokenId()
978         unchecked {
979             return _currentIndex - _startTokenId();
980         }
981     }
982 
983     /**
984      * @dev See {IERC165-supportsInterface}.
985      */
986     function supportsInterface(bytes4 interfaceId)
987         public
988         view
989         virtual
990         override(ERC165, IERC165)
991         returns (bool)
992     {
993         return
994             interfaceId == type(IERC721).interfaceId ||
995             interfaceId == type(IERC721Metadata).interfaceId ||
996             super.supportsInterface(interfaceId);
997     }
998 
999     /**
1000      * @dev See {IERC721-balanceOf}.
1001      */
1002     function balanceOf(address owner) public view override returns (uint256) {
1003         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1004         return uint256(_addressData[owner].balance);
1005     }
1006 
1007     /**
1008      * Returns the number of tokens minted by `owner`.
1009      */
1010     function _numberMinted(address owner) internal view returns (uint256) {
1011         return uint256(_addressData[owner].numberMinted);
1012     }
1013 
1014     /**
1015      * Returns the number of tokens burned by or on behalf of `owner`.
1016      */
1017     function _numberBurned(address owner) internal view returns (uint256) {
1018         return uint256(_addressData[owner].numberBurned);
1019     }
1020 
1021     /**
1022      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1023      */
1024     function _getAux(address owner) internal view returns (uint64) {
1025         return _addressData[owner].aux;
1026     }
1027 
1028     /**
1029      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1030      * If there are multiple variables, please pack them into a uint64.
1031      */
1032     function _setAux(address owner, uint64 aux) internal {
1033         _addressData[owner].aux = aux;
1034     }
1035 
1036     /**
1037      * Gas spent here starts off proportional to the maximum mint batch size.
1038      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1039      */
1040     function _ownershipOf(uint256 tokenId)
1041         internal
1042         view
1043         returns (TokenOwnership memory)
1044     {
1045         uint256 curr = tokenId;
1046 
1047         unchecked {
1048             if (_startTokenId() <= curr && curr < _currentIndex) {
1049                 TokenOwnership memory ownership = _ownerships[curr];
1050                 if (!ownership.burned) {
1051                     if (ownership.addr != address(0)) {
1052                         return ownership;
1053                     }
1054                     // Invariant:
1055                     // There will always be an ownership that has an address and is not burned
1056                     // before an ownership that does not have an address and is not burned.
1057                     // Hence, curr will not underflow.
1058                     while (true) {
1059                         curr--;
1060                         ownership = _ownerships[curr];
1061                         if (ownership.addr != address(0)) {
1062                             return ownership;
1063                         }
1064                     }
1065                 }
1066             }
1067         }
1068         revert OwnerQueryForNonexistentToken();
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-ownerOf}.
1073      */
1074     function ownerOf(uint256 tokenId) public view override returns (address) {
1075         return _ownershipOf(tokenId).addr;
1076     }
1077 
1078     /**
1079      * @dev See {IERC721Metadata-name}.
1080      */
1081     function name() public view virtual override returns (string memory) {
1082         return _name;
1083     }
1084 
1085     /**
1086      * @dev See {IERC721Metadata-symbol}.
1087      */
1088     function symbol() public view virtual override returns (string memory) {
1089         return _symbol;
1090     }
1091 
1092     /**
1093      * @dev See {IERC721Metadata-tokenURI}.
1094      */
1095     function tokenURI(uint256 tokenId)
1096         public
1097         view
1098         virtual
1099         override
1100         returns (string memory)
1101     {
1102         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1103 
1104         string memory baseURI = _baseURI();
1105         return
1106             bytes(baseURI).length != 0
1107                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1108                 : "";
1109     }
1110 
1111     /**
1112      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1113      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1114      * by default, can be overriden in child contracts.
1115      */
1116     function _baseURI() internal view virtual returns (string memory) {
1117         return "";
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-approve}.
1122      */
1123     function approve(address to, uint256 tokenId) public override {
1124         address owner = ERC721A.ownerOf(tokenId);
1125         if (to == owner) revert ApprovalToCurrentOwner();
1126 
1127         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1128             revert ApprovalCallerNotOwnerNorApproved();
1129         }
1130 
1131         _approve(to, tokenId, owner);
1132     }
1133 
1134     /**
1135      * @dev See {IERC721-getApproved}.
1136      */
1137     function getApproved(uint256 tokenId)
1138         public
1139         view
1140         override
1141         returns (address)
1142     {
1143         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1144 
1145         return _tokenApprovals[tokenId];
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-setApprovalForAll}.
1150      */
1151     function setApprovalForAll(address operator, bool approved)
1152         public
1153         virtual
1154         override
1155     {
1156         if (operator == _msgSender()) revert ApproveToCaller();
1157 
1158         _operatorApprovals[_msgSender()][operator] = approved;
1159         emit ApprovalForAll(_msgSender(), operator, approved);
1160     }
1161 
1162     /**
1163      * @dev See {IERC721-isApprovedForAll}.
1164      */
1165     function isApprovedForAll(address owner, address operator)
1166         public
1167         view
1168         virtual
1169         override
1170         returns (bool)
1171     {
1172         return _operatorApprovals[owner][operator];
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-transferFrom}.
1177      */
1178     function transferFrom(
1179         address from,
1180         address to,
1181         uint256 tokenId
1182     ) public virtual override {
1183         _transfer(from, to, tokenId);
1184     }
1185 
1186     /**
1187      * @dev See {IERC721-safeTransferFrom}.
1188      */
1189     function safeTransferFrom(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) public virtual override {
1194         safeTransferFrom(from, to, tokenId, "");
1195     }
1196 
1197     /**
1198      * @dev See {IERC721-safeTransferFrom}.
1199      */
1200     function safeTransferFrom(
1201         address from,
1202         address to,
1203         uint256 tokenId,
1204         bytes memory _data
1205     ) public virtual override {
1206         _transfer(from, to, tokenId);
1207         if (
1208             to.isContract() &&
1209             !_checkContractOnERC721Received(from, to, tokenId, _data)
1210         ) {
1211             revert TransferToNonERC721ReceiverImplementer();
1212         }
1213     }
1214 
1215     /**
1216      * @dev Returns whether `tokenId` exists.
1217      *
1218      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1219      *
1220      * Tokens start existing when they are minted (`_mint`),
1221      */
1222     function _exists(uint256 tokenId) internal view returns (bool) {
1223         return
1224             _startTokenId() <= tokenId &&
1225             tokenId < _currentIndex &&
1226             !_ownerships[tokenId].burned;
1227     }
1228 
1229     /**
1230      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1231      */
1232     function _safeMint(address to, uint256 quantity) internal {
1233         _safeMint(to, quantity, "");
1234     }
1235 
1236     /**
1237      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1238      *
1239      * Requirements:
1240      *
1241      * - If `to` refers to a smart contract, it must implement
1242      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1243      * - `quantity` must be greater than 0.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _safeMint(
1248         address to,
1249         uint256 quantity,
1250         bytes memory _data
1251     ) internal {
1252         uint256 startTokenId = _currentIndex;
1253         if (to == address(0)) revert MintToZeroAddress();
1254         if (quantity == 0) revert MintZeroQuantity();
1255 
1256         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1257 
1258         // Overflows are incredibly unrealistic.
1259         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1260         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1261         unchecked {
1262             _addressData[to].balance += uint64(quantity);
1263             _addressData[to].numberMinted += uint64(quantity);
1264 
1265             _ownerships[startTokenId].addr = to;
1266             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1267 
1268             uint256 updatedIndex = startTokenId;
1269             uint256 end = updatedIndex + quantity;
1270 
1271             if (to.isContract()) {
1272                 do {
1273                     emit Transfer(address(0), to, updatedIndex);
1274                     if (
1275                         !_checkContractOnERC721Received(
1276                             address(0),
1277                             to,
1278                             updatedIndex++,
1279                             _data
1280                         )
1281                     ) {
1282                         revert TransferToNonERC721ReceiverImplementer();
1283                     }
1284                 } while (updatedIndex < end);
1285                 // Reentrancy protection
1286                 if (_currentIndex != startTokenId) revert();
1287             } else {
1288                 do {
1289                     emit Transfer(address(0), to, updatedIndex++);
1290                 } while (updatedIndex < end);
1291             }
1292             _currentIndex = updatedIndex;
1293         }
1294         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1295     }
1296 
1297     /**
1298      * @dev Mints `quantity` tokens and transfers them to `to`.
1299      *
1300      * Requirements:
1301      *
1302      * - `to` cannot be the zero address.
1303      * - `quantity` must be greater than 0.
1304      *
1305      * Emits a {Transfer} event.
1306      */
1307     function _mint(address to, uint256 quantity) internal {
1308         uint256 startTokenId = _currentIndex;
1309         if (to == address(0)) revert MintToZeroAddress();
1310         if (quantity == 0) revert MintZeroQuantity();
1311 
1312         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1313 
1314         // Overflows are incredibly unrealistic.
1315         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1316         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1317         unchecked {
1318             _addressData[to].balance += uint64(quantity);
1319             _addressData[to].numberMinted += uint64(quantity);
1320 
1321             _ownerships[startTokenId].addr = to;
1322             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1323 
1324             uint256 updatedIndex = startTokenId;
1325             uint256 end = updatedIndex + quantity;
1326 
1327             do {
1328                 emit Transfer(address(0), to, updatedIndex++);
1329             } while (updatedIndex < end);
1330 
1331             _currentIndex = updatedIndex;
1332         }
1333         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1334     }
1335 
1336     /**
1337      * @dev Transfers `tokenId` from `from` to `to`.
1338      *
1339      * Requirements:
1340      *
1341      * - `to` cannot be the zero address.
1342      * - `tokenId` token must be owned by `from`.
1343      *
1344      * Emits a {Transfer} event.
1345      */
1346     function _transfer(
1347         address from,
1348         address to,
1349         uint256 tokenId
1350     ) private {
1351         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1352 
1353         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1354 
1355         bool isApprovedOrOwner = (_msgSender() == from ||
1356             isApprovedForAll(from, _msgSender()) ||
1357             getApproved(tokenId) == _msgSender());
1358 
1359         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1360         if (to == address(0)) revert TransferToZeroAddress();
1361 
1362         _beforeTokenTransfers(from, to, tokenId, 1);
1363 
1364         // Clear approvals from the previous owner
1365         _approve(address(0), tokenId, from);
1366 
1367         // Underflow of the sender's balance is impossible because we check for
1368         // ownership above and the recipient's balance can't realistically overflow.
1369         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1370         unchecked {
1371             _addressData[from].balance -= 1;
1372             _addressData[to].balance += 1;
1373 
1374             TokenOwnership storage currSlot = _ownerships[tokenId];
1375             currSlot.addr = to;
1376             currSlot.startTimestamp = uint64(block.timestamp);
1377 
1378             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1379             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1380             uint256 nextTokenId = tokenId + 1;
1381             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1382             if (nextSlot.addr == address(0)) {
1383                 // This will suffice for checking _exists(nextTokenId),
1384                 // as a burned slot cannot contain the zero address.
1385                 if (nextTokenId != _currentIndex) {
1386                     nextSlot.addr = from;
1387                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1388                 }
1389             }
1390         }
1391 
1392         emit Transfer(from, to, tokenId);
1393         _afterTokenTransfers(from, to, tokenId, 1);
1394     }
1395 
1396     /**
1397      * @dev Equivalent to `_burn(tokenId, false)`.
1398      */
1399     function _burn(uint256 tokenId) internal virtual {
1400         _burn(tokenId, false);
1401     }
1402 
1403     /**
1404      * @dev Destroys `tokenId`.
1405      * The approval is cleared when the token is burned.
1406      *
1407      * Requirements:
1408      *
1409      * - `tokenId` must exist.
1410      *
1411      * Emits a {Transfer} event.
1412      */
1413     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1414         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1415 
1416         address from = prevOwnership.addr;
1417 
1418         if (approvalCheck) {
1419             bool isApprovedOrOwner = (_msgSender() == from ||
1420                 isApprovedForAll(from, _msgSender()) ||
1421                 getApproved(tokenId) == _msgSender());
1422 
1423             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1424         }
1425 
1426         _beforeTokenTransfers(from, address(0), tokenId, 1);
1427 
1428         // Clear approvals from the previous owner
1429         _approve(address(0), tokenId, from);
1430 
1431         // Underflow of the sender's balance is impossible because we check for
1432         // ownership above and the recipient's balance can't realistically overflow.
1433         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1434         unchecked {
1435             AddressData storage addressData = _addressData[from];
1436             addressData.balance -= 1;
1437             addressData.numberBurned += 1;
1438 
1439             // Keep track of who burned the token, and the timestamp of burning.
1440             TokenOwnership storage currSlot = _ownerships[tokenId];
1441             currSlot.addr = from;
1442             currSlot.startTimestamp = uint64(block.timestamp);
1443             currSlot.burned = true;
1444 
1445             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1446             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1447             uint256 nextTokenId = tokenId + 1;
1448             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1449             if (nextSlot.addr == address(0)) {
1450                 // This will suffice for checking _exists(nextTokenId),
1451                 // as a burned slot cannot contain the zero address.
1452                 if (nextTokenId != _currentIndex) {
1453                     nextSlot.addr = from;
1454                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1455                 }
1456             }
1457         }
1458 
1459         emit Transfer(from, address(0), tokenId);
1460         _afterTokenTransfers(from, address(0), tokenId, 1);
1461 
1462         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1463         unchecked {
1464             _burnCounter++;
1465         }
1466     }
1467 
1468     /**
1469      * @dev Approve `to` to operate on `tokenId`
1470      *
1471      * Emits a {Approval} event.
1472      */
1473     function _approve(
1474         address to,
1475         uint256 tokenId,
1476         address owner
1477     ) private {
1478         _tokenApprovals[tokenId] = to;
1479         emit Approval(owner, to, tokenId);
1480     }
1481 
1482     /**
1483      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1484      *
1485      * @param from address representing the previous owner of the given token ID
1486      * @param to target address that will receive the tokens
1487      * @param tokenId uint256 ID of the token to be transferred
1488      * @param _data bytes optional data to send along with the call
1489      * @return bool whether the call correctly returned the expected magic value
1490      */
1491     function _checkContractOnERC721Received(
1492         address from,
1493         address to,
1494         uint256 tokenId,
1495         bytes memory _data
1496     ) private returns (bool) {
1497         try
1498             IERC721Receiver(to).onERC721Received(
1499                 _msgSender(),
1500                 from,
1501                 tokenId,
1502                 _data
1503             )
1504         returns (bytes4 retval) {
1505             return retval == IERC721Receiver(to).onERC721Received.selector;
1506         } catch (bytes memory reason) {
1507             if (reason.length == 0) {
1508                 revert TransferToNonERC721ReceiverImplementer();
1509             } else {
1510                 assembly {
1511                     revert(add(32, reason), mload(reason))
1512                 }
1513             }
1514         }
1515     }
1516 
1517     /**
1518      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1519      * And also called before burning one token.
1520      *
1521      * startTokenId - the first token id to be transferred
1522      * quantity - the amount to be transferred
1523      *
1524      * Calling conditions:
1525      *
1526      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1527      * transferred to `to`.
1528      * - When `from` is zero, `tokenId` will be minted for `to`.
1529      * - When `to` is zero, `tokenId` will be burned by `from`.
1530      * - `from` and `to` are never both zero.
1531      */
1532     function _beforeTokenTransfers(
1533         address from,
1534         address to,
1535         uint256 startTokenId,
1536         uint256 quantity
1537     ) internal virtual {}
1538 
1539     /**
1540      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1541      * minting.
1542      * And also called after one token has been burned.
1543      *
1544      * startTokenId - the first token id to be transferred
1545      * quantity - the amount to be transferred
1546      *
1547      * Calling conditions:
1548      *
1549      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1550      * transferred to `to`.
1551      * - When `from` is zero, `tokenId` has been minted for `to`.
1552      * - When `to` is zero, `tokenId` has been burned by `from`.
1553      * - `from` and `to` are never both zero.
1554      */
1555     function _afterTokenTransfers(
1556         address from,
1557         address to,
1558         uint256 startTokenId,
1559         uint256 quantity
1560     ) internal virtual {}
1561 }
1562 
1563 // File: contracts/SpaceRidersOGPass.sol
1564 
1565 pragma solidity >=0.8.0 <0.9.0;
1566 
1567 interface StarToken {
1568     function updateReward(address _from, address _to) external;
1569 
1570     function spend(address _from, uint256 _amount) external;
1571 
1572     function balanceOf(address _address)
1573         external
1574         view
1575         returns (uint256 balance);
1576 }
1577 
1578 interface SpaceRiders {
1579     function balanceOf(address owner) external view returns (uint256 balance);
1580 }
1581 
1582 error Paused();
1583 error NoSpaceRider();
1584 error MaxMintAmountExceed();
1585 error SupplyExceeded();
1586 error NotWhitelisted();
1587 error InsufficientStar();
1588 error EthSalePaused();
1589 error InvalidValue();
1590 error NewClaimableReserveToHigh();
1591 error NewSupplyToLow();
1592 error NewSupplyToHigh();
1593 error NoBalanceToWithdraw();
1594 error WithdrawFailed();
1595 
1596 contract SpaceRidersOGPass is ERC721A, Ownable {
1597     using Strings for uint256;
1598     using MerkleProof for bytes32[];
1599 
1600     bytes32 merkleRoot;
1601 
1602     string public baseURI;
1603 
1604     bool public isPaused = true;
1605     bool public isEthSalePaused = true;
1606 
1607     uint256 public MAX_SUPPLY = 1000;
1608     uint256 public constant MAX_MINT_AMOUNT = 1;
1609     uint256 public cost = 0.02 ether;
1610     uint256 public starCost = 1000 ether;
1611     uint256 public claimableReserve = 750;
1612 
1613     StarToken public starToken =
1614         StarToken(0xDaa58A1851672a6490E2bb9Fdc8868918cDd86e6);
1615     SpaceRiders public spaceRiders =
1616         SpaceRiders(0xC9d198089D6c31d0Ca5Cc5B92C97a57A97BBfdE2);
1617 
1618     event NewOGPassMinted(address sender);
1619 
1620     constructor(string memory _initialBaseURI)
1621         ERC721A("Space Riders OG Pass", "SROG")
1622     {
1623         setBaseURI(_initialBaseURI);
1624     }
1625 
1626     modifier mustPassChecks() {
1627         if (isPaused) revert Paused();
1628         if (spaceRiders.balanceOf(msg.sender) < 1) revert NoSpaceRider();
1629         if (_numberMinted(msg.sender) >= MAX_MINT_AMOUNT)
1630             revert MaxMintAmountExceed();
1631         _;
1632     }
1633 
1634     function _startTokenId() internal view virtual override returns (uint256) {
1635         return 1;
1636     }
1637 
1638     function _baseURI() internal view virtual override returns (string memory) {
1639         return baseURI;
1640     }
1641 
1642     function tokenURI(uint256 tokenId)
1643         public
1644         view
1645         virtual
1646         override
1647         returns (string memory)
1648     {
1649         string memory currentBaseURI = _baseURI();
1650         return
1651             bytes(currentBaseURI).length > 0
1652                 ? string(
1653                     abi.encodePacked(
1654                         currentBaseURI,
1655                         tokenId.toString(),
1656                         ".json"
1657                     )
1658                 )
1659                 : "";
1660     }
1661 
1662     function claim(bytes32[] memory proof) public mustPassChecks {
1663         if (totalSupply() >= MAX_SUPPLY) revert SupplyExceeded();
1664         if (!proof.verify(merkleRoot, keccak256(abi.encodePacked(msg.sender))))
1665             revert NotWhitelisted();
1666         _safeMint(msg.sender, 1);
1667         claimableReserve--;
1668         emit NewOGPassMinted(msg.sender);
1669     }
1670 
1671     function mintWithStar() public mustPassChecks {
1672         if (totalSupply() >= MAX_SUPPLY - claimableReserve)
1673             revert SupplyExceeded();
1674         if (starToken.balanceOf(msg.sender) < starCost)
1675             revert InsufficientStar();
1676         starToken.spend(msg.sender, starCost);
1677         _safeMint(msg.sender, 1);
1678         emit NewOGPassMinted(msg.sender);
1679     }
1680 
1681     function mintWithEth() public payable mustPassChecks {
1682         if (isEthSalePaused) revert EthSalePaused();
1683         if (totalSupply() >= MAX_SUPPLY - claimableReserve)
1684             revert SupplyExceeded();
1685         if (msg.value != cost) revert InvalidValue();
1686         _safeMint(msg.sender, 1);
1687         emit NewOGPassMinted(msg.sender);
1688     }
1689 
1690     function mintedTotalOf(address _owner) public view returns (uint256) {
1691         return _numberMinted(_owner);
1692     }
1693 
1694     function mintToAddress(address _address) public onlyOwner {
1695         if (totalSupply() >= MAX_SUPPLY - claimableReserve)
1696             revert SupplyExceeded();
1697         _safeMint(_address, 1);
1698         emit NewOGPassMinted(msg.sender);
1699     }
1700 
1701     function toggleIsPaused() public onlyOwner {
1702         isPaused = !isPaused;
1703     }
1704 
1705     function toggleIsEthSalePaused() public onlyOwner {
1706         isEthSalePaused = !isEthSalePaused;
1707     }
1708 
1709     function setToken(address _contract) external onlyOwner {
1710         starToken = StarToken(_contract);
1711     }
1712 
1713     function setSpaceRiders(address _contract) external onlyOwner {
1714         spaceRiders = SpaceRiders(_contract);
1715     }
1716 
1717     function setCost(uint256 _newCost) public onlyOwner {
1718         cost = _newCost;
1719     }
1720 
1721     function setStarCost(uint256 _newStarCost) public onlyOwner {
1722         starCost = _newStarCost;
1723     }
1724 
1725     function setMerkleRoot(bytes32 root) public onlyOwner {
1726         merkleRoot = root;
1727     }
1728 
1729     function setClaimableReserve(uint256 _newClaimableReserve)
1730         public
1731         onlyOwner
1732     {
1733         if (_newClaimableReserve > MAX_SUPPLY - totalSupply())
1734             revert NewClaimableReserveToHigh();
1735 
1736         claimableReserve = _newClaimableReserve;
1737     }
1738 
1739     function setMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1740         if (_newMaxSupply < totalSupply() + claimableReserve)
1741             revert NewSupplyToLow();
1742         if (_newMaxSupply > MAX_SUPPLY) revert NewSupplyToHigh();
1743         MAX_SUPPLY = _newMaxSupply;
1744     }
1745 
1746     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1747         baseURI = _newBaseURI;
1748     }
1749 
1750     function withdraw() public payable onlyOwner {
1751         uint256 balance = address(this).balance;
1752         if (balance == 0) revert NoBalanceToWithdraw();
1753         (bool success, ) = payable(0x2A76bAA2F2cFB1b17aE672C995B3C41398e86cCD)
1754             .call{value: balance}("");
1755         if (!success) revert WithdrawFailed();
1756     }
1757 
1758     function _beforeTokenTransfers(
1759         address from,
1760         address to,
1761         uint256 tokenId,
1762         uint256 quantity
1763     ) internal virtual override {
1764         super._beforeTokenTransfers(from, to, tokenId, quantity);
1765         starToken.updateReward(from, to);
1766     }
1767 
1768     function spendTokens(uint256 _amount) external {
1769         starToken.spend(msg.sender, _amount);
1770     }
1771 }