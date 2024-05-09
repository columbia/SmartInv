1 // SPDX-License-Identifier: UNLICENSED
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
51             }
52         }
53         return computedHash;
54     }
55 }
56 
57 // File: @openzeppelin/contracts/utils/Strings.sol
58 
59 
60 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
61 
62 pragma solidity ^0.8.0;
63 
64 /**
65  * @dev String operations.
66  */
67 library Strings {
68     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
69 
70     /**
71      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
72      */
73     function toString(uint256 value) internal pure returns (string memory) {
74         // Inspired by OraclizeAPI's implementation - MIT licence
75         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
76 
77         if (value == 0) {
78             return "0";
79         }
80         uint256 temp = value;
81         uint256 digits;
82         while (temp != 0) {
83             digits++;
84             temp /= 10;
85         }
86         bytes memory buffer = new bytes(digits);
87         while (value != 0) {
88             digits -= 1;
89             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
90             value /= 10;
91         }
92         return string(buffer);
93     }
94 
95     /**
96      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
97      */
98     function toHexString(uint256 value) internal pure returns (string memory) {
99         if (value == 0) {
100             return "0x00";
101         }
102         uint256 temp = value;
103         uint256 length = 0;
104         while (temp != 0) {
105             length++;
106             temp >>= 8;
107         }
108         return toHexString(value, length);
109     }
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
113      */
114     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
115         bytes memory buffer = new bytes(2 * length + 2);
116         buffer[0] = "0";
117         buffer[1] = "x";
118         for (uint256 i = 2 * length + 1; i > 1; --i) {
119             buffer[i] = _HEX_SYMBOLS[value & 0xf];
120             value >>= 4;
121         }
122         require(value == 0, "Strings: hex length insufficient");
123         return string(buffer);
124     }
125 }
126 
127 // File: @openzeppelin/contracts/utils/Context.sol
128 
129 
130 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Provides information about the current execution context, including the
136  * sender of the transaction and its data. While these are generally available
137  * via msg.sender and msg.data, they should not be accessed in such a direct
138  * manner, since when dealing with meta-transactions the account sending and
139  * paying for execution may not be the actual sender (as far as an application
140  * is concerned).
141  *
142  * This contract is only required for intermediate, library-like contracts.
143  */
144 abstract contract Context {
145     function _msgSender() internal view virtual returns (address) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view virtual returns (bytes calldata) {
150         return msg.data;
151     }
152 }
153 
154 // File: @openzeppelin/contracts/access/Ownable.sol
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 
162 /**
163  * @dev Contract module which provides a basic access control mechanism, where
164  * there is an account (an owner) that can be granted exclusive access to
165  * specific functions.
166  *
167  * By default, the owner account will be the one that deploys the contract. This
168  * can later be changed with {transferOwnership}.
169  *
170  * This module is used through inheritance. It will make available the modifier
171  * `onlyOwner`, which can be applied to your functions to restrict their use to
172  * the owner.
173  */
174 abstract contract Ownable is Context {
175     address private _owner;
176 
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178 
179     /**
180      * @dev Initializes the contract setting the deployer as the initial owner.
181      */
182     constructor() {
183         _transferOwnership(_msgSender());
184     }
185 
186     /**
187      * @dev Returns the address of the current owner.
188      */
189     function owner() public view virtual returns (address) {
190         return _owner;
191     }
192 
193     /**
194      * @dev Throws if called by any account other than the owner.
195      */
196     modifier onlyOwner() {
197         require(owner() == _msgSender(), "Ownable: caller is not the owner");
198         _;
199     }
200 
201     /**
202      * @dev Leaves the contract without owner. It will not be possible to call
203      * `onlyOwner` functions anymore. Can only be called by the current owner.
204      *
205      * NOTE: Renouncing ownership will leave the contract without an owner,
206      * thereby removing any functionality that is only available to the owner.
207      */
208     function renounceOwnership() public virtual onlyOwner {
209         _transferOwnership(address(0));
210     }
211 
212     /**
213      * @dev Transfers ownership of the contract to a new account (`newOwner`).
214      * Can only be called by the current owner.
215      */
216     function transferOwnership(address newOwner) public virtual onlyOwner {
217         require(newOwner != address(0), "Ownable: new owner is the zero address");
218         _transferOwnership(newOwner);
219     }
220 
221     /**
222      * @dev Transfers ownership of the contract to a new account (`newOwner`).
223      * Internal function without access restriction.
224      */
225     function _transferOwnership(address newOwner) internal virtual {
226         address oldOwner = _owner;
227         _owner = newOwner;
228         emit OwnershipTransferred(oldOwner, newOwner);
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/Address.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Collection of functions related to the address type
241  */
242 library Address {
243     /**
244      * @dev Returns true if `account` is a contract.
245      *
246      * [IMPORTANT]
247      * ====
248      * It is unsafe to assume that an address for which this function returns
249      * false is an externally-owned account (EOA) and not a contract.
250      *
251      * Among others, `isContract` will return false for the following
252      * types of addresses:
253      *
254      *  - an externally-owned account
255      *  - a contract in construction
256      *  - an address where a contract will be created
257      *  - an address where a contract lived, but was destroyed
258      * ====
259      */
260     function isContract(address account) internal view returns (bool) {
261         // This method relies on extcodesize, which returns 0 for contracts in
262         // construction, since the code is only stored at the end of the
263         // constructor execution.
264 
265         uint256 size;
266         assembly {
267             size := extcodesize(account)
268         }
269         return size > 0;
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
452 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @title ERC721 token receiver interface
461  * @dev Interface for any contract that wants to support safeTransfers
462  * from ERC721 asset contracts.
463  */
464 interface IERC721Receiver {
465     /**
466      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
467      * by `operator` from `from`, this function is called.
468      *
469      * It must return its Solidity selector to confirm the token transfer.
470      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
471      *
472      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
473      */
474     function onERC721Received(
475         address operator,
476         address from,
477         uint256 tokenId,
478         bytes calldata data
479     ) external returns (bytes4);
480 }
481 
482 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
483 
484 
485 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
486 
487 pragma solidity ^0.8.0;
488 
489 /**
490  * @dev Interface of the ERC165 standard, as defined in the
491  * https://eips.ethereum.org/EIPS/eip-165[EIP].
492  *
493  * Implementers can declare support of contract interfaces, which can then be
494  * queried by others ({ERC165Checker}).
495  *
496  * For an implementation, see {ERC165}.
497  */
498 interface IERC165 {
499     /**
500      * @dev Returns true if this contract implements the interface defined by
501      * `interfaceId`. See the corresponding
502      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
503      * to learn more about how these ids are created.
504      *
505      * This function call must use less than 30 000 gas.
506      */
507     function supportsInterface(bytes4 interfaceId) external view returns (bool);
508 }
509 
510 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
511 
512 
513 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @dev Implementation of the {IERC165} interface.
520  *
521  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
522  * for the additional interface id that will be supported. For example:
523  *
524  * ```solidity
525  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
526  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
527  * }
528  * ```
529  *
530  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
531  */
532 abstract contract ERC165 is IERC165 {
533     /**
534      * @dev See {IERC165-supportsInterface}.
535      */
536     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
537         return interfaceId == type(IERC165).interfaceId;
538     }
539 }
540 
541 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
542 
543 
544 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
545 
546 pragma solidity ^0.8.0;
547 
548 
549 /**
550  * @dev Required interface of an ERC721 compliant contract.
551  */
552 interface IERC721 is IERC165 {
553     /**
554      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
555      */
556     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
557 
558     /**
559      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
560      */
561     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
562 
563     /**
564      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
565      */
566     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
567 
568     /**
569      * @dev Returns the number of tokens in ``owner``'s account.
570      */
571     function balanceOf(address owner) external view returns (uint256 balance);
572 
573     /**
574      * @dev Returns the owner of the `tokenId` token.
575      *
576      * Requirements:
577      *
578      * - `tokenId` must exist.
579      */
580     function ownerOf(uint256 tokenId) external view returns (address owner);
581 
582     /**
583      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
584      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
585      *
586      * Requirements:
587      *
588      * - `from` cannot be the zero address.
589      * - `to` cannot be the zero address.
590      * - `tokenId` token must exist and be owned by `from`.
591      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
593      *
594      * Emits a {Transfer} event.
595      */
596     function safeTransferFrom(
597         address from,
598         address to,
599         uint256 tokenId
600     ) external;
601 
602     /**
603      * @dev Transfers `tokenId` token from `from` to `to`.
604      *
605      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must be owned by `from`.
612      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
613      *
614      * Emits a {Transfer} event.
615      */
616     function transferFrom(
617         address from,
618         address to,
619         uint256 tokenId
620     ) external;
621 
622     /**
623      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
624      * The approval is cleared when the token is transferred.
625      *
626      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
627      *
628      * Requirements:
629      *
630      * - The caller must own the token or be an approved operator.
631      * - `tokenId` must exist.
632      *
633      * Emits an {Approval} event.
634      */
635     function approve(address to, uint256 tokenId) external;
636 
637     /**
638      * @dev Returns the account approved for `tokenId` token.
639      *
640      * Requirements:
641      *
642      * - `tokenId` must exist.
643      */
644     function getApproved(uint256 tokenId) external view returns (address operator);
645 
646     /**
647      * @dev Approve or remove `operator` as an operator for the caller.
648      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
649      *
650      * Requirements:
651      *
652      * - The `operator` cannot be the caller.
653      *
654      * Emits an {ApprovalForAll} event.
655      */
656     function setApprovalForAll(address operator, bool _approved) external;
657 
658     /**
659      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
660      *
661      * See {setApprovalForAll}
662      */
663     function isApprovedForAll(address owner, address operator) external view returns (bool);
664 
665     /**
666      * @dev Safely transfers `tokenId` token from `from` to `to`.
667      *
668      * Requirements:
669      *
670      * - `from` cannot be the zero address.
671      * - `to` cannot be the zero address.
672      * - `tokenId` token must exist and be owned by `from`.
673      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
674      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
675      *
676      * Emits a {Transfer} event.
677      */
678     function safeTransferFrom(
679         address from,
680         address to,
681         uint256 tokenId,
682         bytes calldata data
683     ) external;
684 }
685 
686 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
687 
688 
689 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
690 
691 pragma solidity ^0.8.0;
692 
693 
694 /**
695  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
696  * @dev See https://eips.ethereum.org/EIPS/eip-721
697  */
698 interface IERC721Enumerable is IERC721 {
699     /**
700      * @dev Returns the total amount of tokens stored by the contract.
701      */
702     function totalSupply() external view returns (uint256);
703 
704     /**
705      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
706      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
707      */
708     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
709 
710     /**
711      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
712      * Use along with {totalSupply} to enumerate all tokens.
713      */
714     function tokenByIndex(uint256 index) external view returns (uint256);
715 }
716 
717 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
718 
719 
720 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
721 
722 pragma solidity ^0.8.0;
723 
724 
725 /**
726  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
727  * @dev See https://eips.ethereum.org/EIPS/eip-721
728  */
729 interface IERC721Metadata is IERC721 {
730     /**
731      * @dev Returns the token collection name.
732      */
733     function name() external view returns (string memory);
734 
735     /**
736      * @dev Returns the token collection symbol.
737      */
738     function symbol() external view returns (string memory);
739 
740     /**
741      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
742      */
743     function tokenURI(uint256 tokenId) external view returns (string memory);
744 }
745 
746 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
747 
748 
749 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
750 
751 pragma solidity ^0.8.0;
752 
753 
754 
755 
756 
757 
758 
759 
760 /**
761  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
762  * the Metadata extension, but not including the Enumerable extension, which is available separately as
763  * {ERC721Enumerable}.
764  */
765 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
766     using Address for address;
767     using Strings for uint256;
768 
769     // Token name
770     string private _name;
771 
772     // Token symbol
773     string private _symbol;
774 
775     // Mapping from token ID to owner address
776     mapping(uint256 => address) private _owners;
777 
778     // Mapping owner address to token count
779     mapping(address => uint256) private _balances;
780 
781     // Mapping from token ID to approved address
782     mapping(uint256 => address) private _tokenApprovals;
783 
784     // Mapping from owner to operator approvals
785     mapping(address => mapping(address => bool)) private _operatorApprovals;
786 
787     /**
788      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
789      */
790     constructor(string memory name_, string memory symbol_) {
791         _name = name_;
792         _symbol = symbol_;
793     }
794 
795     /**
796      * @dev See {IERC165-supportsInterface}.
797      */
798     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
799         return
800             interfaceId == type(IERC721).interfaceId ||
801             interfaceId == type(IERC721Metadata).interfaceId ||
802             super.supportsInterface(interfaceId);
803     }
804 
805     /**
806      * @dev See {IERC721-balanceOf}.
807      */
808     function balanceOf(address owner) public view virtual override returns (uint256) {
809         require(owner != address(0), "ERC721: balance query for the zero address");
810         return _balances[owner];
811     }
812 
813     /**
814      * @dev See {IERC721-ownerOf}.
815      */
816     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
817         address owner = _owners[tokenId];
818         require(owner != address(0), "ERC721: owner query for nonexistent token");
819         return owner;
820     }
821 
822     /**
823      * @dev See {IERC721Metadata-name}.
824      */
825     function name() public view virtual override returns (string memory) {
826         return _name;
827     }
828 
829     /**
830      * @dev See {IERC721Metadata-symbol}.
831      */
832     function symbol() public view virtual override returns (string memory) {
833         return _symbol;
834     }
835 
836     /**
837      * @dev See {IERC721Metadata-tokenURI}.
838      */
839     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
840         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
841 
842         string memory baseURI = _baseURI();
843         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
844     }
845 
846     /**
847      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
848      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
849      * by default, can be overriden in child contracts.
850      */
851     function _baseURI() internal view virtual returns (string memory) {
852         return "";
853     }
854 
855     /**
856      * @dev See {IERC721-approve}.
857      */
858     function approve(address to, uint256 tokenId) public virtual override {
859         address owner = ERC721.ownerOf(tokenId);
860         require(to != owner, "ERC721: approval to current owner");
861 
862         require(
863             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
864             "ERC721: approve caller is not owner nor approved for all"
865         );
866 
867         _approve(to, tokenId);
868     }
869 
870     /**
871      * @dev See {IERC721-getApproved}.
872      */
873     function getApproved(uint256 tokenId) public view virtual override returns (address) {
874         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
875 
876         return _tokenApprovals[tokenId];
877     }
878 
879     /**
880      * @dev See {IERC721-setApprovalForAll}.
881      */
882     function setApprovalForAll(address operator, bool approved) public virtual override {
883         _setApprovalForAll(_msgSender(), operator, approved);
884     }
885 
886     /**
887      * @dev See {IERC721-isApprovedForAll}.
888      */
889     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
890         return _operatorApprovals[owner][operator];
891     }
892 
893     /**
894      * @dev See {IERC721-transferFrom}.
895      */
896     function transferFrom(
897         address from,
898         address to,
899         uint256 tokenId
900     ) public virtual override {
901         //solhint-disable-next-line max-line-length
902         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
903 
904         _transfer(from, to, tokenId);
905     }
906 
907     /**
908      * @dev See {IERC721-safeTransferFrom}.
909      */
910     function safeTransferFrom(
911         address from,
912         address to,
913         uint256 tokenId
914     ) public virtual override {
915         safeTransferFrom(from, to, tokenId, "");
916     }
917 
918     /**
919      * @dev See {IERC721-safeTransferFrom}.
920      */
921     function safeTransferFrom(
922         address from,
923         address to,
924         uint256 tokenId,
925         bytes memory _data
926     ) public virtual override {
927         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
928         _safeTransfer(from, to, tokenId, _data);
929     }
930 
931     /**
932      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
933      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
934      *
935      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
936      *
937      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
938      * implement alternative mechanisms to perform token transfer, such as signature-based.
939      *
940      * Requirements:
941      *
942      * - `from` cannot be the zero address.
943      * - `to` cannot be the zero address.
944      * - `tokenId` token must exist and be owned by `from`.
945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function _safeTransfer(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes memory _data
954     ) internal virtual {
955         _transfer(from, to, tokenId);
956         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
957     }
958 
959     /**
960      * @dev Returns whether `tokenId` exists.
961      *
962      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
963      *
964      * Tokens start existing when they are minted (`_mint`),
965      * and stop existing when they are burned (`_burn`).
966      */
967     function _exists(uint256 tokenId) internal view virtual returns (bool) {
968         return _owners[tokenId] != address(0);
969     }
970 
971     /**
972      * @dev Returns whether `spender` is allowed to manage `tokenId`.
973      *
974      * Requirements:
975      *
976      * - `tokenId` must exist.
977      */
978     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
979         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
980         address owner = ERC721.ownerOf(tokenId);
981         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
982     }
983 
984     /**
985      * @dev Safely mints `tokenId` and transfers it to `to`.
986      *
987      * Requirements:
988      *
989      * - `tokenId` must not exist.
990      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
991      *
992      * Emits a {Transfer} event.
993      */
994     function _safeMint(address to, uint256 tokenId) internal virtual {
995         _safeMint(to, tokenId, "");
996     }
997 
998     /**
999      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1000      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1001      */
1002     function _safeMint(
1003         address to,
1004         uint256 tokenId,
1005         bytes memory _data
1006     ) internal virtual {
1007         _mint(to, tokenId);
1008         require(
1009             _checkOnERC721Received(address(0), to, tokenId, _data),
1010             "ERC721: transfer to non ERC721Receiver implementer"
1011         );
1012     }
1013 
1014     /**
1015      * @dev Mints `tokenId` and transfers it to `to`.
1016      *
1017      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must not exist.
1022      * - `to` cannot be the zero address.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _mint(address to, uint256 tokenId) internal virtual {
1027         require(to != address(0), "ERC721: mint to the zero address");
1028         require(!_exists(tokenId), "ERC721: token already minted");
1029 
1030         _beforeTokenTransfer(address(0), to, tokenId);
1031 
1032         _balances[to] += 1;
1033         _owners[tokenId] = to;
1034 
1035         emit Transfer(address(0), to, tokenId);
1036     }
1037 
1038     /**
1039      * @dev Destroys `tokenId`.
1040      * The approval is cleared when the token is burned.
1041      *
1042      * Requirements:
1043      *
1044      * - `tokenId` must exist.
1045      *
1046      * Emits a {Transfer} event.
1047      */
1048     function _burn(uint256 tokenId) internal virtual {
1049         address owner = ERC721.ownerOf(tokenId);
1050 
1051         _beforeTokenTransfer(owner, address(0), tokenId);
1052 
1053         // Clear approvals
1054         _approve(address(0), tokenId);
1055 
1056         _balances[owner] -= 1;
1057         delete _owners[tokenId];
1058 
1059         emit Transfer(owner, address(0), tokenId);
1060     }
1061 
1062     /**
1063      * @dev Transfers `tokenId` from `from` to `to`.
1064      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1065      *
1066      * Requirements:
1067      *
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must be owned by `from`.
1070      *
1071      * Emits a {Transfer} event.
1072      */
1073     function _transfer(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) internal virtual {
1078         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1079         require(to != address(0), "ERC721: transfer to the zero address");
1080 
1081         _beforeTokenTransfer(from, to, tokenId);
1082 
1083         // Clear approvals from the previous owner
1084         _approve(address(0), tokenId);
1085 
1086         _balances[from] -= 1;
1087         _balances[to] += 1;
1088         _owners[tokenId] = to;
1089 
1090         emit Transfer(from, to, tokenId);
1091     }
1092 
1093     /**
1094      * @dev Approve `to` to operate on `tokenId`
1095      *
1096      * Emits a {Approval} event.
1097      */
1098     function _approve(address to, uint256 tokenId) internal virtual {
1099         _tokenApprovals[tokenId] = to;
1100         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1101     }
1102 
1103     /**
1104      * @dev Approve `operator` to operate on all of `owner` tokens
1105      *
1106      * Emits a {ApprovalForAll} event.
1107      */
1108     function _setApprovalForAll(
1109         address owner,
1110         address operator,
1111         bool approved
1112     ) internal virtual {
1113         require(owner != operator, "ERC721: approve to caller");
1114         _operatorApprovals[owner][operator] = approved;
1115         emit ApprovalForAll(owner, operator, approved);
1116     }
1117 
1118     /**
1119      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1120      * The call is not executed if the target address is not a contract.
1121      *
1122      * @param from address representing the previous owner of the given token ID
1123      * @param to target address that will receive the tokens
1124      * @param tokenId uint256 ID of the token to be transferred
1125      * @param _data bytes optional data to send along with the call
1126      * @return bool whether the call correctly returned the expected magic value
1127      */
1128     function _checkOnERC721Received(
1129         address from,
1130         address to,
1131         uint256 tokenId,
1132         bytes memory _data
1133     ) private returns (bool) {
1134         if (to.isContract()) {
1135             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1136                 return retval == IERC721Receiver.onERC721Received.selector;
1137             } catch (bytes memory reason) {
1138                 if (reason.length == 0) {
1139                     revert("ERC721: transfer to non ERC721Receiver implementer");
1140                 } else {
1141                     assembly {
1142                         revert(add(32, reason), mload(reason))
1143                     }
1144                 }
1145             }
1146         } else {
1147             return true;
1148         }
1149     }
1150 
1151     /**
1152      * @dev Hook that is called before any token transfer. This includes minting
1153      * and burning.
1154      *
1155      * Calling conditions:
1156      *
1157      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1158      * transferred to `to`.
1159      * - When `from` is zero, `tokenId` will be minted for `to`.
1160      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1161      * - `from` and `to` are never both zero.
1162      *
1163      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1164      */
1165     function _beforeTokenTransfer(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) internal virtual {}
1170 }
1171 
1172 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1173 
1174 
1175 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1176 
1177 pragma solidity ^0.8.0;
1178 
1179 
1180 
1181 /**
1182  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1183  * enumerability of all the token ids in the contract as well as all token ids owned by each
1184  * account.
1185  */
1186 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1187     // Mapping from owner to list of owned token IDs
1188     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1189 
1190     // Mapping from token ID to index of the owner tokens list
1191     mapping(uint256 => uint256) private _ownedTokensIndex;
1192 
1193     // Array with all token ids, used for enumeration
1194     uint256[] private _allTokens;
1195 
1196     // Mapping from token id to position in the allTokens array
1197     mapping(uint256 => uint256) private _allTokensIndex;
1198 
1199     /**
1200      * @dev See {IERC165-supportsInterface}.
1201      */
1202     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1203         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1204     }
1205 
1206     /**
1207      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1208      */
1209     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1210         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1211         return _ownedTokens[owner][index];
1212     }
1213 
1214     /**
1215      * @dev See {IERC721Enumerable-totalSupply}.
1216      */
1217     function totalSupply() public view virtual override returns (uint256) {
1218         return _allTokens.length;
1219     }
1220 
1221     /**
1222      * @dev See {IERC721Enumerable-tokenByIndex}.
1223      */
1224     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1225         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1226         return _allTokens[index];
1227     }
1228 
1229     /**
1230      * @dev Hook that is called before any token transfer. This includes minting
1231      * and burning.
1232      *
1233      * Calling conditions:
1234      *
1235      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1236      * transferred to `to`.
1237      * - When `from` is zero, `tokenId` will be minted for `to`.
1238      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1239      * - `from` cannot be the zero address.
1240      * - `to` cannot be the zero address.
1241      *
1242      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1243      */
1244     function _beforeTokenTransfer(
1245         address from,
1246         address to,
1247         uint256 tokenId
1248     ) internal virtual override {
1249         super._beforeTokenTransfer(from, to, tokenId);
1250 
1251         if (from == address(0)) {
1252             _addTokenToAllTokensEnumeration(tokenId);
1253         } else if (from != to) {
1254             _removeTokenFromOwnerEnumeration(from, tokenId);
1255         }
1256         if (to == address(0)) {
1257             _removeTokenFromAllTokensEnumeration(tokenId);
1258         } else if (to != from) {
1259             _addTokenToOwnerEnumeration(to, tokenId);
1260         }
1261     }
1262 
1263     /**
1264      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1265      * @param to address representing the new owner of the given token ID
1266      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1267      */
1268     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1269         uint256 length = ERC721.balanceOf(to);
1270         _ownedTokens[to][length] = tokenId;
1271         _ownedTokensIndex[tokenId] = length;
1272     }
1273 
1274     /**
1275      * @dev Private function to add a token to this extension's token tracking data structures.
1276      * @param tokenId uint256 ID of the token to be added to the tokens list
1277      */
1278     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1279         _allTokensIndex[tokenId] = _allTokens.length;
1280         _allTokens.push(tokenId);
1281     }
1282 
1283     /**
1284      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1285      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1286      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1287      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1288      * @param from address representing the previous owner of the given token ID
1289      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1290      */
1291     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1292         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1293         // then delete the last slot (swap and pop).
1294 
1295         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1296         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1297 
1298         // When the token to delete is the last token, the swap operation is unnecessary
1299         if (tokenIndex != lastTokenIndex) {
1300             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1301 
1302             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1303             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1304         }
1305 
1306         // This also deletes the contents at the last position of the array
1307         delete _ownedTokensIndex[tokenId];
1308         delete _ownedTokens[from][lastTokenIndex];
1309     }
1310 
1311     /**
1312      * @dev Private function to remove a token from this extension's token tracking data structures.
1313      * This has O(1) time complexity, but alters the order of the _allTokens array.
1314      * @param tokenId uint256 ID of the token to be removed from the tokens list
1315      */
1316     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1317         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1318         // then delete the last slot (swap and pop).
1319 
1320         uint256 lastTokenIndex = _allTokens.length - 1;
1321         uint256 tokenIndex = _allTokensIndex[tokenId];
1322 
1323         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1324         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1325         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1326         uint256 lastTokenId = _allTokens[lastTokenIndex];
1327 
1328         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1329         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1330 
1331         // This also deletes the contents at the last position of the array
1332         delete _allTokensIndex[tokenId];
1333         _allTokens.pop();
1334     }
1335 }
1336 
1337 // File: contracts/lucidpaths.sol
1338 
1339 
1340 pragma solidity >=0.7.0 <0.9.0;
1341 
1342 
1343 
1344 
1345 contract LucidPaths is ERC721Enumerable, Ownable {
1346   using Strings for uint256;
1347 
1348   string public baseURI;
1349   string public baseExtension = ".json";
1350   uint256 public cost = .045 ether;
1351   uint256 public maxSupply = 1000;
1352   uint256 public maxMintAmount = 1;
1353   uint256 public nftPerAddressLimit = 1;
1354   bool public paused = false;
1355   bool public onlyWhitelisted = true;
1356   bytes32 private merkleRoot;
1357   mapping(address => uint256) private whiteListClaimed;
1358 
1359   constructor(
1360     string memory _name,
1361     string memory _symbol,
1362     string memory _initBaseURI,
1363     bytes32 _merkleRoot
1364   ) ERC721(_name, _symbol) {
1365     setBaseURI(_initBaseURI);
1366     setMerkleRoot(_merkleRoot);
1367     uint256 supply = totalSupply();
1368     for (uint256 i = 1; i <= 14; i++) {
1369       _safeMint(msg.sender, supply + i);
1370     }
1371   }
1372 
1373   function setMerkleRoot(bytes32 root) public onlyOwner {
1374     merkleRoot = root;
1375   }
1376   function _baseURI() internal view virtual override returns (string memory) {
1377     return baseURI;
1378   }
1379 
1380   function mint(uint256 _mintAmount, bytes32[] memory _merkleProof) public payable {
1381     require(!paused, "The contract is paused");
1382     require(_mintAmount > 0, "Must mint at least 1 NFT");
1383     uint256 supply = totalSupply();
1384     require(supply + _mintAmount <= maxSupply, "All NFTs have been minted");
1385     address operator = _msgSender();
1386     if (operator != owner()) {
1387         require(_mintAmount <= maxMintAmount, "Cannot mint this many per call");
1388         if(onlyWhitelisted == true) {
1389             require(reachedMintingLimit(),"Already minted");
1390             require( onWhiteList(_merkleProof),'Not white listed');
1391         }
1392         require(msg.value >= cost * _mintAmount, "Insufficient funds");
1393     }
1394     for (uint256 i = 1; i <= _mintAmount; i++) {
1395       whiteListClaimed[operator]++;
1396       _safeMint(msg.sender, supply + i);
1397     }
1398   }
1399 
1400   function onWhiteList(bytes32[] memory _merkleProof) private view returns(bool){
1401     bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1402     return MerkleProof.verify(_merkleProof, merkleRoot, leaf);
1403   }
1404 
1405   function reachedMintingLimit() private view returns(bool){
1406     return whiteListClaimed[_msgSender()] < nftPerAddressLimit;
1407   }
1408 
1409   function canMint(bytes32[] memory _merkleProof) public view returns(bool){
1410     uint256 supply = totalSupply();
1411     bool supplyLeft = supply < maxSupply;
1412     if(onlyWhitelisted == true){
1413       return reachedMintingLimit() && onWhiteList(_merkleProof) && supplyLeft && !paused;
1414     }
1415     return supplyLeft;
1416   }
1417 
1418 
1419   function walletOfOwner(address _owner)
1420     public
1421     view
1422     returns (uint256[] memory)
1423   {
1424     uint256 ownerTokenCount = balanceOf(_owner);
1425     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1426     for (uint256 i; i < ownerTokenCount; i++) {
1427       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1428     }
1429     return tokenIds;
1430   }
1431 
1432   function tokenURI(uint256 tokenId)
1433     public
1434     view
1435     virtual
1436     override
1437     returns (string memory)
1438   {
1439     require(
1440       _exists(tokenId),
1441       "ERC721Metadata: URI query for nonexistent token"
1442     );
1443     string memory currentBaseURI = _baseURI();
1444     return bytes(currentBaseURI).length > 0
1445         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1446         : "";
1447   }
1448 
1449   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1450     nftPerAddressLimit = _limit;
1451   }
1452 
1453   function setCost(uint256 _newCost) public onlyOwner {
1454     cost = _newCost;
1455   }
1456 
1457   function setMaxMintAmount(uint256 _newMaxMintAmount) public onlyOwner {
1458     maxMintAmount = _newMaxMintAmount;
1459   }
1460 
1461   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1462     baseURI = _newBaseURI;
1463   }
1464 
1465   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1466     baseExtension = _newBaseExtension;
1467   }
1468 
1469   function pause(bool _state) public onlyOwner {
1470     paused = _state;
1471   }
1472 
1473   function setOnlyWhitelisted(bool _state) public onlyOwner {
1474     onlyWhitelisted = _state;
1475   }
1476 
1477   function withdraw() external payable onlyOwner {
1478     payable(_msgSender()).transfer(address(this).balance);
1479   }
1480 }