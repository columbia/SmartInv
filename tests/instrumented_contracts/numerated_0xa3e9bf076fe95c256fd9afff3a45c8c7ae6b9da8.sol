1 /**
2  *Submitted for verification at Etherscan.io on 2022-05-27
3 */
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = _efficientHash(computedHash, proofElement);
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = _efficientHash(proofElement, computedHash);
50             }
51         }
52         return computedHash;
53     }
54 
55     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
56         assembly {
57             mstore(0x00, a)
58             mstore(0x20, b)
59             value := keccak256(0x00, 0x40)
60         }
61     }
62 }
63 
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev String operations.
69  */
70 library Strings {
71     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
75      */
76     function toString(uint256 value) internal pure returns (string memory) {
77         // Inspired by OraclizeAPI's implementation - MIT licence
78         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
79 
80         if (value == 0) {
81             return "0";
82         }
83         uint256 temp = value;
84         uint256 digits;
85         while (temp != 0) {
86             digits++;
87             temp /= 10;
88         }
89         bytes memory buffer = new bytes(digits);
90         while (value != 0) {
91             digits -= 1;
92             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
93             value /= 10;
94         }
95         return string(buffer);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
100      */
101     function toHexString(uint256 value) internal pure returns (string memory) {
102         if (value == 0) {
103             return "0x00";
104         }
105         uint256 temp = value;
106         uint256 length = 0;
107         while (temp != 0) {
108             length++;
109             temp >>= 8;
110         }
111         return toHexString(value, length);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
116      */
117     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
118         bytes memory buffer = new bytes(2 * length + 2);
119         buffer[0] = "0";
120         buffer[1] = "x";
121         for (uint256 i = 2 * length + 1; i > 1; --i) {
122             buffer[i] = _HEX_SYMBOLS[value & 0xf];
123             value >>= 4;
124         }
125         require(value == 0, "Strings: hex length insufficient");
126         return string(buffer);
127     }
128 }
129 
130 
131 
132 
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev Provides information about the current execution context, including the
137  * sender of the transaction and its data. While these are generally available
138  * via msg.sender and msg.data, they should not be accessed in such a direct
139  * manner, since when dealing with meta-transactions the account sending and
140  * paying for execution may not be the actual sender (as far as an application
141  * is concerned).
142  *
143  * This contract is only required for intermediate, library-like contracts.
144  */
145 abstract contract Context {
146     function _msgSender() internal view virtual returns (address) {
147         return msg.sender;
148     }
149 
150     function _msgData() internal view virtual returns (bytes calldata) {
151         return msg.data;
152     }
153 }
154 
155 
156 
157 pragma solidity ^0.8.0;
158 
159 /**
160  * @dev Contract module which provides a basic access control mechanism, where
161  * there is an account (an owner) that can be granted exclusive access to
162  * specific functions.
163  *
164  * By default, the owner account will be the one that deploys the contract. This
165  * can later be changed with {transferOwnership}.
166  *
167  * This module is used through inheritance. It will make available the modifier
168  * `onlyOwner`, which can be applied to your functions to restrict their use to
169  * the owner.
170  */
171 abstract contract Ownable is Context {
172     address private _owner;
173 
174     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
175 
176     /**
177      * @dev Initializes the contract setting the deployer as the initial owner.
178      */
179     constructor() {
180         _transferOwnership(_msgSender());
181     }
182 
183     /**
184      * @dev Returns the address of the current owner.
185      */
186     function owner() public view virtual returns (address) {
187         return _owner;
188     }
189 
190     /**
191      * @dev Throws if called by any account other than the owner.
192      */
193     modifier onlyOwner() {
194         require(owner() == _msgSender(), "Ownable: caller is not the owner");
195         _;
196     }
197 
198     /**
199      * @dev Leaves the contract without owner. It will not be possible to call
200      * `onlyOwner` functions anymore. Can only be called by the current owner.
201      *
202      * NOTE: Renouncing ownership will leave the contract without an owner,
203      * thereby removing any functionality that is only available to the owner.
204      */
205     function renounceOwnership() public virtual onlyOwner {
206         _transferOwnership(address(0));
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Can only be called by the current owner.
212      */
213     function transferOwnership(address newOwner) public virtual onlyOwner {
214         require(newOwner != address(0), "Ownable: new owner is the zero address");
215         _transferOwnership(newOwner);
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Internal function without access restriction.
221      */
222     function _transferOwnership(address newOwner) internal virtual {
223         address oldOwner = _owner;
224         _owner = newOwner;
225         emit OwnershipTransferred(oldOwner, newOwner);
226     }
227 }
228 
229 
230 
231 
232 pragma solidity ^0.8.1;
233 
234 /**
235  * @dev Collection of functions related to the address type
236  */
237 library Address {
238     /**
239      * @dev Returns true if `account` is a contract.
240      *
241      * [IMPORTANT]
242      * ====
243      * It is unsafe to assume that an address for which this function returns
244      * false is an externally-owned account (EOA) and not a contract.
245      *
246      * Among others, `isContract` will return false for the following
247      * types of addresses:
248      *
249      *  - an externally-owned account
250      *  - a contract in construction
251      *  - an address where a contract will be created
252      *  - an address where a contract lived, but was destroyed
253      * ====
254      *
255      * [IMPORTANT]
256      * ====
257      * You shouldn't rely on `isContract` to protect against flash loan attacks!
258      *
259      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
260      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
261      * constructor.
262      * ====
263      */
264     function isContract(address account) internal view returns (bool) {
265         // This method relies on extcodesize/address.code.length, which returns 0
266         // for contracts in construction, since the code is only stored at the end
267         // of the constructor execution.
268 
269         return account.code.length > 0;
270     }
271 
272     /**
273      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
274      * `recipient`, forwarding all available gas and reverting on errors.
275      *
276      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
277      * of certain opcodes, possibly making contracts go over the 2300 gas limit
278      * imposed by `transfer`, making them unable to receive funds via
279      * `transfer`. {sendValue} removes this limitation.
280      *
281      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
282      *
283      * IMPORTANT: because control is transferred to `recipient`, care must be
284      * taken to not create reentrancy vulnerabilities. Consider using
285      * {ReentrancyGuard} or the
286      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
287      */
288     function sendValue(address payable recipient, uint256 amount) internal {
289         require(address(this).balance >= amount, "Address: insufficient balance");
290 
291         (bool success, ) = recipient.call{value: amount}("");
292         require(success, "Address: unable to send value, recipient may have reverted");
293     }
294 
295     /**
296      * @dev Performs a Solidity function call using a low level `call`. A
297      * plain `call` is an unsafe replacement for a function call: use this
298      * function instead.
299      *
300      * If `target` reverts with a revert reason, it is bubbled up by this
301      * function (like regular Solidity function calls).
302      *
303      * Returns the raw returned data. To convert to the expected return value,
304      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
305      *
306      * Requirements:
307      *
308      * - `target` must be a contract.
309      * - calling `target` with `data` must not revert.
310      *
311      * _Available since v3.1._
312      */
313     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
314         return functionCall(target, data, "Address: low-level call failed");
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
319      * `errorMessage` as a fallback revert reason when `target` reverts.
320      *
321      * _Available since v3.1._
322      */
323     function functionCall(
324         address target,
325         bytes memory data,
326         string memory errorMessage
327     ) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, 0, errorMessage);
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
333      * but also transferring `value` wei to `target`.
334      *
335      * Requirements:
336      *
337      * - the calling contract must have an ETH balance of at least `value`.
338      * - the called Solidity function must be `payable`.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(
343         address target,
344         bytes memory data,
345         uint256 value
346     ) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(
357         address target,
358         bytes memory data,
359         uint256 value,
360         string memory errorMessage
361     ) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         require(isContract(target), "Address: call to non-contract");
364 
365         (bool success, bytes memory returndata) = target.call{value: value}(data);
366         return verifyCallResult(success, returndata, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but performing a static call.
372      *
373      * _Available since v3.3._
374      */
375     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
376         return functionStaticCall(target, data, "Address: low-level static call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
381      * but performing a static call.
382      *
383      * _Available since v3.3._
384      */
385     function functionStaticCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal view returns (bytes memory) {
390         require(isContract(target), "Address: static call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.staticcall(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a delegate call.
399      *
400      * _Available since v3.4._
401      */
402     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
403         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a delegate call.
409      *
410      * _Available since v3.4._
411      */
412     function functionDelegateCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal returns (bytes memory) {
417         require(isContract(target), "Address: delegate call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.delegatecall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
425      * revert reason using the provided one.
426      *
427      * _Available since v4.3._
428      */
429     function verifyCallResult(
430         bool success,
431         bytes memory returndata,
432         string memory errorMessage
433     ) internal pure returns (bytes memory) {
434         if (success) {
435             return returndata;
436         } else {
437             // Look for revert reason and bubble it up if present
438             if (returndata.length > 0) {
439                 // The easiest way to bubble the revert reason is using memory via assembly
440 
441                 assembly {
442                     let returndata_size := mload(returndata)
443                     revert(add(32, returndata), returndata_size)
444                 }
445             } else {
446                 revert(errorMessage);
447             }
448         }
449     }
450 }
451 
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @title ERC721 token receiver interface
457  * @dev Interface for any contract that wants to support safeTransfers
458  * from ERC721 asset contracts.
459  */
460 interface IERC721Receiver {
461     /**
462      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
463      * by `operator` from `from`, this function is called.
464      *
465      * It must return its Solidity selector to confirm the token transfer.
466      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
467      *
468      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
469      */
470     function onERC721Received(
471         address operator,
472         address from,
473         uint256 tokenId,
474         bytes calldata data
475     ) external returns (bytes4);
476 }
477 
478 
479 
480 pragma solidity ^0.8.0;
481 
482 /**
483  * @dev Interface of the ERC165 standard, as defined in the
484  * https://eips.ethereum.org/EIPS/eip-165[EIP].
485  *
486  * Implementers can declare support of contract interfaces, which can then be
487  * queried by others ({ERC165Checker}).
488  *
489  * For an implementation, see {ERC165}.
490  */
491 interface IERC165 {
492     /**
493      * @dev Returns true if this contract implements the interface defined by
494      * `interfaceId`. See the corresponding
495      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
496      * to learn more about how these ids are created.
497      *
498      * This function call must use less than 30 000 gas.
499      */
500     function supportsInterface(bytes4 interfaceId) external view returns (bool);
501 }
502 
503 
504 
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @dev Implementation of the {IERC165} interface.
510  *
511  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
512  * for the additional interface id that will be supported. For example:
513  *
514  * ```solidity
515  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
516  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
517  * }
518  * ```
519  *
520  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
521  */
522 abstract contract ERC165 is IERC165 {
523     /**
524      * @dev See {IERC165-supportsInterface}.
525      */
526     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
527         return interfaceId == type(IERC165).interfaceId;
528     }
529 }
530 
531 
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @dev Required interface of an ERC721 compliant contract.
538  */
539 interface IERC721 is IERC165 {
540     /**
541      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
542      */
543     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
544 
545     /**
546      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
547      */
548     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
549 
550     /**
551      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
552      */
553     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
554 
555     /**
556      * @dev Returns the number of tokens in ``owner``'s account.
557      */
558     function balanceOf(address owner) external view returns (uint256 balance);
559 
560     /**
561      * @dev Returns the owner of the `tokenId` token.
562      *
563      * Requirements:
564      *
565      * - `tokenId` must exist.
566      */
567     function ownerOf(uint256 tokenId) external view returns (address owner);
568 
569     /**
570      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
571      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
572      *
573      * Requirements:
574      *
575      * - `from` cannot be the zero address.
576      * - `to` cannot be the zero address.
577      * - `tokenId` token must exist and be owned by `from`.
578      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
579      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
580      *
581      * Emits a {Transfer} event.
582      */
583     function safeTransferFrom(
584         address from,
585         address to,
586         uint256 tokenId
587     ) external;
588 
589     /**
590      * @dev Transfers `tokenId` token from `from` to `to`.
591      *
592      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
593      *
594      * Requirements:
595      *
596      * - `from` cannot be the zero address.
597      * - `to` cannot be the zero address.
598      * - `tokenId` token must be owned by `from`.
599      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
600      *
601      * Emits a {Transfer} event.
602      */
603     function transferFrom(
604         address from,
605         address to,
606         uint256 tokenId
607     ) external;
608 
609     /**
610      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
611      * The approval is cleared when the token is transferred.
612      *
613      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
614      *
615      * Requirements:
616      *
617      * - The caller must own the token or be an approved operator.
618      * - `tokenId` must exist.
619      *
620      * Emits an {Approval} event.
621      */
622     function approve(address to, uint256 tokenId) external;
623 
624     /**
625      * @dev Returns the account approved for `tokenId` token.
626      *
627      * Requirements:
628      *
629      * - `tokenId` must exist.
630      */
631     function getApproved(uint256 tokenId) external view returns (address operator);
632 
633     /**
634      * @dev Approve or remove `operator` as an operator for the caller.
635      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
636      *
637      * Requirements:
638      *
639      * - The `operator` cannot be the caller.
640      *
641      * Emits an {ApprovalForAll} event.
642      */
643     function setApprovalForAll(address operator, bool _approved) external;
644 
645     /**
646      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
647      *
648      * See {setApprovalForAll}
649      */
650     function isApprovedForAll(address owner, address operator) external view returns (bool);
651 
652     /**
653      * @dev Safely transfers `tokenId` token from `from` to `to`.
654      *
655      * Requirements:
656      *
657      * - `from` cannot be the zero address.
658      * - `to` cannot be the zero address.
659      * - `tokenId` token must exist and be owned by `from`.
660      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
661      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
662      *
663      * Emits a {Transfer} event.
664      */
665     function safeTransferFrom(
666         address from,
667         address to,
668         uint256 tokenId,
669         bytes calldata data
670     ) external;
671 }
672 
673 
674 
675 
676 pragma solidity ^0.8.0;
677 
678 /**
679  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
680  * @dev See https://eips.ethereum.org/EIPS/eip-721
681  */
682 interface IERC721Enumerable is IERC721 {
683     /**
684      * @dev Returns the total amount of tokens stored by the contract.
685      */
686     function totalSupply() external view returns (uint256);
687 
688     /**
689      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
690      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
691      */
692     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
693 
694     /**
695      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
696      * Use along with {totalSupply} to enumerate all tokens.
697      */
698     function tokenByIndex(uint256 index) external view returns (uint256);
699 }
700 
701 
702 pragma solidity ^0.8.0;
703 
704 
705 /**
706  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
707  * @dev See https://eips.ethereum.org/EIPS/eip-721
708  */
709 interface IERC721Metadata is IERC721 {
710     /**
711      * @dev Returns the token collection name.
712      */
713     function name() external view returns (string memory);
714 
715     /**
716      * @dev Returns the token collection symbol.
717      */
718     function symbol() external view returns (string memory);
719 
720     /**
721      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
722      */
723     function tokenURI(uint256 tokenId) external view returns (string memory);
724 }
725 
726 
727 pragma solidity ^0.8.4;
728 
729 error ApprovalCallerNotOwnerNorApproved();
730 error ApprovalQueryForNonexistentToken();
731 error ApproveToCaller();
732 error ApprovalToCurrentOwner();
733 error BalanceQueryForZeroAddress();
734 error MintedQueryForZeroAddress();
735 error MintToZeroAddress();
736 error MintZeroQuantity();
737 error OwnerIndexOutOfBounds();
738 error OwnerQueryForNonexistentToken();
739 error TokenIndexOutOfBounds();
740 error TransferCallerNotOwnerNorApproved();
741 error TransferFromIncorrectOwner();
742 error TransferToNonERC721ReceiverImplementer();
743 error TransferToZeroAddress();
744 error UnableDetermineTokenOwner();
745 error URIQueryForNonexistentToken();
746 
747 /**
748  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
749  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
750  *
751  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
752  *
753  * Does not support burning tokens to address(0).
754  *
755  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
756  */
757 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
758     using Address for address;
759     using Strings for uint256;
760 
761     struct TokenOwnership {
762         address addr;
763         uint64 startTimestamp;
764     }
765 
766     struct AddressData {
767         uint128 balance;
768         uint128 numberMinted;
769     }
770 
771     uint256 internal _currentIndex;
772 
773     // Token name
774     string private _name;
775 
776     // Token symbol
777     string private _symbol;
778 
779     // Mapping from token ID to ownership details
780     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
781     mapping(uint256 => TokenOwnership) internal _ownerships;
782 
783     // Mapping owner address to address data
784     mapping(address => AddressData) private _addressData;
785 
786     // Mapping from token ID to approved address
787     mapping(uint256 => address) private _tokenApprovals;
788 
789     // Mapping from owner to operator approvals
790     mapping(address => mapping(address => bool)) private _operatorApprovals;
791 
792     constructor(string memory name_, string memory symbol_) {
793         _name = name_;
794         _symbol = symbol_;
795     }
796 
797     /**
798      * @dev See {IERC721Enumerable-totalSupply}.
799      */
800     function totalSupply() public view override returns (uint256) {
801         return _currentIndex;
802     }
803 
804     /**
805      * @dev See {IERC721Enumerable-tokenByIndex}.
806      */
807     function tokenByIndex(uint256 index) public view override returns (uint256) {
808         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
809         return index;
810     }
811 
812     /**
813      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
814      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
815      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
816      */
817     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
818         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
819         uint256 numMintedSoFar = totalSupply();
820         uint256 tokenIdsIdx;
821         address currOwnershipAddr;
822 
823         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
824         unchecked {
825             for (uint256 i; i < numMintedSoFar; i++) {
826                 TokenOwnership memory ownership = _ownerships[i];
827                 if (ownership.addr != address(0)) {
828                     currOwnershipAddr = ownership.addr;
829                 }
830                 if (currOwnershipAddr == owner) {
831                     if (tokenIdsIdx == index) {
832                         return i;
833                     }
834                     tokenIdsIdx++;
835                 }
836             }
837         }
838 
839         // Execution should never reach this point.
840         assert(false);
841         return tokenIdsIdx;
842     }
843 
844     /**
845      * @dev See {IERC165-supportsInterface}.
846      */
847     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
848         return
849             interfaceId == type(IERC721).interfaceId ||
850             interfaceId == type(IERC721Metadata).interfaceId ||
851             interfaceId == type(IERC721Enumerable).interfaceId ||
852             super.supportsInterface(interfaceId);
853     }
854 
855     /**
856      * @dev See {IERC721-balanceOf}.
857      */
858     function balanceOf(address owner) public view override returns (uint256) {
859         if (owner == address(0)) revert BalanceQueryForZeroAddress();
860         return uint256(_addressData[owner].balance);
861     }
862 
863     function _numberMinted(address owner) internal view returns (uint256) {
864         if (owner == address(0)) revert MintedQueryForZeroAddress();
865         return uint256(_addressData[owner].numberMinted);
866     }
867 
868     /**
869      * Gas spent here starts off proportional to the maximum mint batch size.
870      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
871      */
872     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
873         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
874 
875         unchecked {
876             for (uint256 curr = tokenId; curr >= 0; curr--) {
877                 TokenOwnership memory ownership = _ownerships[curr];
878                 if (ownership.addr != address(0)) {
879                     return ownership;
880                 }
881             }
882         }
883 
884         revert UnableDetermineTokenOwner();
885     }
886 
887     /**
888      * @dev See {IERC721-ownerOf}.
889      */
890     function ownerOf(uint256 tokenId) public view override returns (address) {
891         return ownershipOf(tokenId).addr;
892     }
893 
894     /**
895      * @dev See {IERC721Metadata-name}.
896      */
897     function name() public view virtual override returns (string memory) {
898         return _name;
899     }
900 
901     /**
902      * @dev See {IERC721Metadata-symbol}.
903      */
904     function symbol() public view virtual override returns (string memory) {
905         return _symbol;
906     }
907 
908     /**
909      * @dev See {IERC721Metadata-tokenURI}.
910      */
911     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
912         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
913 
914         string memory baseURI = _baseURI();
915         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
916     }
917 
918     /**
919      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
920      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
921      * by default, can be overriden in child contracts.
922      */
923     function _baseURI() internal view virtual returns (string memory) {
924         return '';
925     }
926 
927     /**
928      * @dev See {IERC721-approve}.
929      */
930     function approve(address to, uint256 tokenId) public override {
931         address owner = ERC721A.ownerOf(tokenId);
932         if (to == owner) revert ApprovalToCurrentOwner();
933 
934         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
935 
936         _approve(to, tokenId, owner);
937     }
938 
939     /**
940      * @dev See {IERC721-getApproved}.
941      */
942     function getApproved(uint256 tokenId) public view override returns (address) {
943         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
944 
945         return _tokenApprovals[tokenId];
946     }
947 
948     /**
949      * @dev See {IERC721-setApprovalForAll}.
950      */
951     function setApprovalForAll(address operator, bool approved) public override {
952         if (operator == _msgSender()) revert ApproveToCaller();
953 
954         _operatorApprovals[_msgSender()][operator] = approved;
955         emit ApprovalForAll(_msgSender(), operator, approved);
956     }
957 
958     /**
959      * @dev See {IERC721-isApprovedForAll}.
960      */
961     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
962         return _operatorApprovals[owner][operator];
963     }
964 
965     /**
966      * @dev See {IERC721-transferFrom}.
967      */
968     function transferFrom(
969         address from,
970         address to,
971         uint256 tokenId
972     ) public virtual override {
973         _transfer(from, to, tokenId);
974     }
975 
976     /**
977      * @dev See {IERC721-safeTransferFrom}.
978      */
979     function safeTransferFrom(
980         address from,
981         address to,
982         uint256 tokenId
983     ) public virtual override {
984         safeTransferFrom(from, to, tokenId, '');
985     }
986 
987     /**
988      * @dev See {IERC721-safeTransferFrom}.
989      */
990     function safeTransferFrom(
991         address from,
992         address to,
993         uint256 tokenId,
994         bytes memory _data
995     ) public override {
996         _transfer(from, to, tokenId);
997         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
998     }
999 
1000     /**
1001      * @dev Returns whether `tokenId` exists.
1002      *
1003      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1004      *
1005      * Tokens start existing when they are minted (`_mint`),
1006      */
1007     function _exists(uint256 tokenId) internal view returns (bool) {
1008         return tokenId < _currentIndex;
1009     }
1010 
1011     function _safeMint(address to, uint256 quantity) internal {
1012         _safeMint(to, quantity, '');
1013     }
1014 
1015     /**
1016      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1017      *
1018      * Requirements:
1019      *
1020      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1021      * - `quantity` must be greater than 0.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _safeMint(
1026         address to,
1027         uint256 quantity,
1028         bytes memory _data
1029     ) internal {
1030         _mint(to, quantity, _data, true);
1031     }
1032 
1033     /**
1034      * @dev Mints `quantity` tokens and transfers them to `to`.
1035      *
1036      * Requirements:
1037      *
1038      * - `to` cannot be the zero address.
1039      * - `quantity` must be greater than 0.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function _mint(
1044         address to,
1045         uint256 quantity,
1046         bytes memory _data,
1047         bool safe
1048     ) internal {
1049         uint256 startTokenId = _currentIndex;
1050         if (to == address(0)) revert MintToZeroAddress();
1051         if (quantity == 0) revert MintZeroQuantity();
1052 
1053         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1054 
1055         // Overflows are incredibly unrealistic.
1056         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1057         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1058         unchecked {
1059             _addressData[to].balance += uint128(quantity);
1060             _addressData[to].numberMinted += uint128(quantity);
1061 
1062             _ownerships[startTokenId].addr = to;
1063             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1064 
1065             uint256 updatedIndex = startTokenId;
1066 
1067             for (uint256 i; i < quantity; i++) {
1068                 emit Transfer(address(0), to, updatedIndex);
1069                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1070                     revert TransferToNonERC721ReceiverImplementer();
1071                 }
1072 
1073                 updatedIndex++;
1074             }
1075 
1076             _currentIndex = updatedIndex;
1077         }
1078 
1079         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1080     }
1081 
1082     /**
1083      * @dev Transfers `tokenId` from `from` to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `to` cannot be the zero address.
1088      * - `tokenId` token must be owned by `from`.
1089      *
1090      * Emits a {Transfer} event.
1091      */
1092     function _transfer(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) private {
1097         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1098 
1099         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1100             getApproved(tokenId) == _msgSender() ||
1101             isApprovedForAll(prevOwnership.addr, _msgSender()));
1102 
1103         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1104         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1105         if (to == address(0)) revert TransferToZeroAddress();
1106 
1107         _beforeTokenTransfers(from, to, tokenId, 1);
1108 
1109         // Clear approvals from the previous owner
1110         _approve(address(0), tokenId, prevOwnership.addr);
1111 
1112         // Underflow of the sender's balance is impossible because we check for
1113         // ownership above and the recipient's balance can't realistically overflow.
1114         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1115         unchecked {
1116             _addressData[from].balance -= 1;
1117             _addressData[to].balance += 1;
1118 
1119             _ownerships[tokenId].addr = to;
1120             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1121 
1122             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1123             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1124             uint256 nextTokenId = tokenId + 1;
1125             if (_ownerships[nextTokenId].addr == address(0)) {
1126                 if (_exists(nextTokenId)) {
1127                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1128                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1129                 }
1130             }
1131         }
1132 
1133         emit Transfer(from, to, tokenId);
1134         _afterTokenTransfers(from, to, tokenId, 1);
1135     }
1136 
1137     /**
1138      * @dev Approve `to` to operate on `tokenId`
1139      *
1140      * Emits a {Approval} event.
1141      */
1142     function _approve(
1143         address to,
1144         uint256 tokenId,
1145         address owner
1146     ) private {
1147         _tokenApprovals[tokenId] = to;
1148         emit Approval(owner, to, tokenId);
1149     }
1150 
1151     /**
1152      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1153      * The call is not executed if the target address is not a contract.
1154      *
1155      * @param from address representing the previous owner of the given token ID
1156      * @param to target address that will receive the tokens
1157      * @param tokenId uint256 ID of the token to be transferred
1158      * @param _data bytes optional data to send along with the call
1159      * @return bool whether the call correctly returned the expected magic value
1160      */
1161     function _checkOnERC721Received(
1162         address from,
1163         address to,
1164         uint256 tokenId,
1165         bytes memory _data
1166     ) private returns (bool) {
1167         if (to.isContract()) {
1168             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1169                 return retval == IERC721Receiver(to).onERC721Received.selector;
1170             } catch (bytes memory reason) {
1171                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1172                 else {
1173                     assembly {
1174                         revert(add(32, reason), mload(reason))
1175                     }
1176                 }
1177             }
1178         } else {
1179             return true;
1180         }
1181     }
1182 
1183     /**
1184      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1185      *
1186      * startTokenId - the first token id to be transferred
1187      * quantity - the amount to be transferred
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` will be minted for `to`.
1194      */
1195     function _beforeTokenTransfers(
1196         address from,
1197         address to,
1198         uint256 startTokenId,
1199         uint256 quantity
1200     ) internal virtual {}
1201 
1202     /**
1203      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1204      * minting.
1205      *
1206      * startTokenId - the first token id to be transferred
1207      * quantity - the amount to be transferred
1208      *
1209      * Calling conditions:
1210      *
1211      * - when `from` and `to` are both non-zero.
1212      * - `from` and `to` are never both zero.
1213      */
1214     function _afterTokenTransfers(
1215         address from,
1216         address to,
1217         uint256 startTokenId,
1218         uint256 quantity
1219     ) internal virtual {}
1220 }
1221 
1222 
1223 pragma solidity ^0.8.0;
1224 
1225 
1226 contract ReigningBearsLoungeClub is ERC721A, Ownable{
1227     using Strings for uint256;
1228 
1229     uint256 public constant MAX_SUPPLY = 4888;
1230     uint256 public constant MAX_PUBLIC_MINT = 10;
1231     uint256 public constant MAX_WHITELIST_MINT = 5;
1232     uint256 public constant PUBLIC_SALE_PRICE = 0.06 ether;
1233     uint256 public constant WHITELIST_SALE_PRICE = 0.04 ether;
1234 
1235     string private  baseTokenUri;
1236     string public   placeholderTokenUri;
1237 
1238     //deploy smart contract, toggle WL, toggle WL when done, toggle publicSale 
1239     //2 days later toggle reveal
1240     bool public isRevealed;
1241     bool public publicSale;
1242     bool public whiteListSale;
1243     bool public pause;
1244     
1245     bytes32 private merkleRoot;
1246 
1247     mapping(address => uint256) public totalPublicMint;
1248     mapping(address => uint256) public totalWhitelistMint;
1249 
1250     constructor() ERC721A("Reigning Bears Lounge Club", "RBLC"){
1251 
1252     }
1253 
1254     modifier callerIsUser() {
1255         require(tx.origin == msg.sender, "Cannot be called by a contract");
1256         _;
1257     }
1258 
1259     function mint(uint256 _quantity) external payable callerIsUser{
1260         require(publicSale, "Not Yet Active.");
1261         require((totalSupply() + _quantity) <= MAX_SUPPLY, "Beyond Max Supply");
1262         require((totalPublicMint[msg.sender] +_quantity) <= MAX_PUBLIC_MINT, "Already minted 3 times!");
1263         require(msg.value >= (PUBLIC_SALE_PRICE * _quantity), "Below ");
1264 
1265         totalPublicMint[msg.sender] += _quantity;
1266         _safeMint(msg.sender, _quantity);
1267     }
1268 
1269     function whitelistMint(bytes32[] memory _merkleProof, uint256 _quantity) external payable callerIsUser{
1270         require(whiteListSale, "Minting is on Pause");
1271         require((totalSupply() + _quantity) <= MAX_SUPPLY, "Cannot mint beyond max supply");
1272         require((totalWhitelistMint[msg.sender] + _quantity)  <= MAX_WHITELIST_MINT, "Cannot mint beyond whitelist max mint!");
1273         require(msg.value >= (WHITELIST_SALE_PRICE * _quantity), "Payment is below the price");
1274         //create leaf node
1275         bytes32 sender = keccak256(abi.encodePacked(msg.sender));
1276         require(MerkleProof.verify(_merkleProof, merkleRoot, sender), "You are not whitelisted");
1277 
1278         totalWhitelistMint[msg.sender] += _quantity;
1279         _safeMint(msg.sender, _quantity);
1280     }
1281 
1282     function teamMint(uint256 _quantity) external onlyOwner{
1283     _safeMint(msg.sender, _quantity);
1284     }
1285 
1286     function _baseURI() internal view virtual override returns (string memory) {
1287         return baseTokenUri;
1288     }
1289 
1290     //return uri for certain token
1291     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1292         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1293 
1294         uint256 trueId = tokenId + 1;
1295 
1296         if(!isRevealed){
1297             return placeholderTokenUri;
1298         }
1299         //string memory baseURI = _baseURI();
1300         return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, trueId.toString(), ".json")) : "";
1301     }
1302 
1303     /// @dev walletOf() function shouldn't be called on-chain due to gas consumption
1304     function walletOf() external view returns(uint256[] memory){
1305         address _owner = msg.sender;
1306         uint256 numberOfOwnedNFT = balanceOf(_owner);
1307         uint256[] memory ownerIds = new uint256[](numberOfOwnedNFT);
1308 
1309         for(uint256 index = 0; index < numberOfOwnedNFT; index++){
1310             ownerIds[index] = tokenOfOwnerByIndex(_owner, index);
1311         }
1312 
1313         return ownerIds;
1314     }
1315 
1316     function setTokenUri(string memory _baseTokenUri) external onlyOwner{
1317         baseTokenUri = _baseTokenUri;
1318     }
1319     function setPlaceHolderUri(string memory _placeholderTokenUri) external onlyOwner{
1320         placeholderTokenUri = _placeholderTokenUri;
1321     }
1322 
1323     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
1324         merkleRoot = _merkleRoot;
1325     }
1326 
1327     function getMerkleRoot() external view returns (bytes32){
1328         return merkleRoot;
1329     }
1330 
1331     function togglePause() external onlyOwner{
1332         pause = !pause;
1333     }
1334 
1335     function toggleWhiteListSale() external onlyOwner{
1336         whiteListSale = !whiteListSale;
1337     }
1338 
1339     function togglePublicSale() external onlyOwner{
1340         publicSale = !publicSale;
1341     }
1342 
1343     function toggleReveal() external onlyOwner{
1344         isRevealed = !isRevealed;
1345     }
1346 
1347     function withdraw() external onlyOwner{
1348         payable(msg.sender).transfer(address(this).balance);
1349     }
1350 }