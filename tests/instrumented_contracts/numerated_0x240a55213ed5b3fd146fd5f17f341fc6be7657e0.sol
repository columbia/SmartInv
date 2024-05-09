1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
5 
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
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/Strings.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev String operations.
65  */
66 library Strings {
67     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
71      */
72     function toString(uint256 value) internal pure returns (string memory) {
73         // Inspired by OraclizeAPI's implementation - MIT licence
74         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
75 
76         if (value == 0) {
77             return "0";
78         }
79         uint256 temp = value;
80         uint256 digits;
81         while (temp != 0) {
82             digits++;
83             temp /= 10;
84         }
85         bytes memory buffer = new bytes(digits);
86         while (value != 0) {
87             digits -= 1;
88             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
89             value /= 10;
90         }
91         return string(buffer);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
96      */
97     function toHexString(uint256 value) internal pure returns (string memory) {
98         if (value == 0) {
99             return "0x00";
100         }
101         uint256 temp = value;
102         uint256 length = 0;
103         while (temp != 0) {
104             length++;
105             temp >>= 8;
106         }
107         return toHexString(value, length);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
112      */
113     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
114         bytes memory buffer = new bytes(2 * length + 2);
115         buffer[0] = "0";
116         buffer[1] = "x";
117         for (uint256 i = 2 * length + 1; i > 1; --i) {
118             buffer[i] = _HEX_SYMBOLS[value & 0xf];
119             value >>= 4;
120         }
121         require(value == 0, "Strings: hex length insufficient");
122         return string(buffer);
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Context.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/access/Ownable.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 /**
162  * @dev Contract module which provides a basic access control mechanism, where
163  * there is an account (an owner) that can be granted exclusive access to
164  * specific functions.
165  *
166  * By default, the owner account will be the one that deploys the contract. This
167  * can later be changed with {transferOwnership}.
168  *
169  * This module is used through inheritance. It will make available the modifier
170  * `onlyOwner`, which can be applied to your functions to restrict their use to
171  * the owner.
172  */
173 abstract contract Ownable is Context {
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     /**
179      * @dev Initializes the contract setting the deployer as the initial owner.
180      */
181     constructor() {
182         _transferOwnership(_msgSender());
183     }
184 
185     /**
186      * @dev Returns the address of the current owner.
187      */
188     function owner() public view virtual returns (address) {
189         return _owner;
190     }
191 
192     /**
193      * @dev Throws if called by any account other than the owner.
194      */
195     modifier onlyOwner() {
196         require(owner() == _msgSender(), "Ownable: caller is not the owner");
197         _;
198     }
199 
200     /**
201      * @dev Leaves the contract without owner. It will not be possible to call
202      * `onlyOwner` functions anymore. Can only be called by the current owner.
203      *
204      * NOTE: Renouncing ownership will leave the contract without an owner,
205      * thereby removing any functionality that is only available to the owner.
206      */
207     function renounceOwnership() public virtual onlyOwner {
208         _transferOwnership(address(0));
209     }
210 
211     /**
212      * @dev Transfers ownership of the contract to a new account (`newOwner`).
213      * Can only be called by the current owner.
214      */
215     function transferOwnership(address newOwner) public virtual onlyOwner {
216         require(newOwner != address(0), "Ownable: new owner is the zero address");
217         _transferOwnership(newOwner);
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      * Internal function without access restriction.
223      */
224     function _transferOwnership(address newOwner) internal virtual {
225         address oldOwner = _owner;
226         _owner = newOwner;
227         emit OwnershipTransferred(oldOwner, newOwner);
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // This method relies on extcodesize, which returns 0 for contracts in
261         // construction, since the code is only stored at the end of the
262         // constructor execution.
263 
264         uint256 size;
265         assembly {
266             size := extcodesize(account)
267         }
268         return size > 0;
269     }
270 
271     /**
272      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
273      * `recipient`, forwarding all available gas and reverting on errors.
274      *
275      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
276      * of certain opcodes, possibly making contracts go over the 2300 gas limit
277      * imposed by `transfer`, making them unable to receive funds via
278      * `transfer`. {sendValue} removes this limitation.
279      *
280      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
281      *
282      * IMPORTANT: because control is transferred to `recipient`, care must be
283      * taken to not create reentrancy vulnerabilities. Consider using
284      * {ReentrancyGuard} or the
285      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
286      */
287     function sendValue(address payable recipient, uint256 amount) internal {
288         require(address(this).balance >= amount, "Address: insufficient balance");
289 
290         (bool success, ) = recipient.call{value: amount}("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain `call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313         return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(
323         address target,
324         bytes memory data,
325         string memory errorMessage
326     ) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, 0, errorMessage);
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
332      * but also transferring `value` wei to `target`.
333      *
334      * Requirements:
335      *
336      * - the calling contract must have an ETH balance of at least `value`.
337      * - the called Solidity function must be `payable`.
338      *
339      * _Available since v3.1._
340      */
341     function functionCallWithValue(
342         address target,
343         bytes memory data,
344         uint256 value
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value,
359         string memory errorMessage
360     ) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         require(isContract(target), "Address: call to non-contract");
363 
364         (bool success, bytes memory returndata) = target.call{value: value}(data);
365         return verifyCallResult(success, returndata, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but performing a static call.
371      *
372      * _Available since v3.3._
373      */
374     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
375         return functionStaticCall(target, data, "Address: low-level static call failed");
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
380      * but performing a static call.
381      *
382      * _Available since v3.3._
383      */
384     function functionStaticCall(
385         address target,
386         bytes memory data,
387         string memory errorMessage
388     ) internal view returns (bytes memory) {
389         require(isContract(target), "Address: static call to non-contract");
390 
391         (bool success, bytes memory returndata) = target.staticcall(data);
392         return verifyCallResult(success, returndata, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but performing a delegate call.
398      *
399      * _Available since v3.4._
400      */
401     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
402         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
403     }
404 
405     /**
406      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
407      * but performing a delegate call.
408      *
409      * _Available since v3.4._
410      */
411     function functionDelegateCall(
412         address target,
413         bytes memory data,
414         string memory errorMessage
415     ) internal returns (bytes memory) {
416         require(isContract(target), "Address: delegate call to non-contract");
417 
418         (bool success, bytes memory returndata) = target.delegatecall(data);
419         return verifyCallResult(success, returndata, errorMessage);
420     }
421 
422     /**
423      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
424      * revert reason using the provided one.
425      *
426      * _Available since v4.3._
427      */
428     function verifyCallResult(
429         bool success,
430         bytes memory returndata,
431         string memory errorMessage
432     ) internal pure returns (bytes memory) {
433         if (success) {
434             return returndata;
435         } else {
436             // Look for revert reason and bubble it up if present
437             if (returndata.length > 0) {
438                 // The easiest way to bubble the revert reason is using memory via assembly
439 
440                 assembly {
441                     let returndata_size := mload(returndata)
442                     revert(add(32, returndata), returndata_size)
443                 }
444             } else {
445                 revert(errorMessage);
446             }
447         }
448     }
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
452 
453 
454 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @title ERC721 token receiver interface
460  * @dev Interface for any contract that wants to support safeTransfers
461  * from ERC721 asset contracts.
462  */
463 interface IERC721Receiver {
464     /**
465      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
466      * by `operator` from `from`, this function is called.
467      *
468      * It must return its Solidity selector to confirm the token transfer.
469      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
470      *
471      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
472      */
473     function onERC721Received(
474         address operator,
475         address from,
476         uint256 tokenId,
477         bytes calldata data
478     ) external returns (bytes4);
479 }
480 
481 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
482 
483 
484 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 /**
489  * @dev Interface of the ERC165 standard, as defined in the
490  * https://eips.ethereum.org/EIPS/eip-165[EIP].
491  *
492  * Implementers can declare support of contract interfaces, which can then be
493  * queried by others ({ERC165Checker}).
494  *
495  * For an implementation, see {ERC165}.
496  */
497 interface IERC165 {
498     /**
499      * @dev Returns true if this contract implements the interface defined by
500      * `interfaceId`. See the corresponding
501      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
502      * to learn more about how these ids are created.
503      *
504      * This function call must use less than 30 000 gas.
505      */
506     function supportsInterface(bytes4 interfaceId) external view returns (bool);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 
517 /**
518  * @dev Implementation of the {IERC165} interface.
519  *
520  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
521  * for the additional interface id that will be supported. For example:
522  *
523  * ```solidity
524  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
525  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
526  * }
527  * ```
528  *
529  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
530  */
531 abstract contract ERC165 is IERC165 {
532     /**
533      * @dev See {IERC165-supportsInterface}.
534      */
535     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
536         return interfaceId == type(IERC165).interfaceId;
537     }
538 }
539 
540 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
541 
542 
543 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev Required interface of an ERC721 compliant contract.
550  */
551 interface IERC721 is IERC165 {
552     /**
553      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
554      */
555     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
556 
557     /**
558      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
559      */
560     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
561 
562     /**
563      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
564      */
565     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
566 
567     /**
568      * @dev Returns the number of tokens in ``owner``'s account.
569      */
570     function balanceOf(address owner) external view returns (uint256 balance);
571 
572     /**
573      * @dev Returns the owner of the `tokenId` token.
574      *
575      * Requirements:
576      *
577      * - `tokenId` must exist.
578      */
579     function ownerOf(uint256 tokenId) external view returns (address owner);
580 
581     /**
582      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
583      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
584      *
585      * Requirements:
586      *
587      * - `from` cannot be the zero address.
588      * - `to` cannot be the zero address.
589      * - `tokenId` token must exist and be owned by `from`.
590      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
591      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
592      *
593      * Emits a {Transfer} event.
594      */
595     function safeTransferFrom(
596         address from,
597         address to,
598         uint256 tokenId
599     ) external;
600 
601     /**
602      * @dev Transfers `tokenId` token from `from` to `to`.
603      *
604      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
605      *
606      * Requirements:
607      *
608      * - `from` cannot be the zero address.
609      * - `to` cannot be the zero address.
610      * - `tokenId` token must be owned by `from`.
611      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
612      *
613      * Emits a {Transfer} event.
614      */
615     function transferFrom(
616         address from,
617         address to,
618         uint256 tokenId
619     ) external;
620 
621     /**
622      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
623      * The approval is cleared when the token is transferred.
624      *
625      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
626      *
627      * Requirements:
628      *
629      * - The caller must own the token or be an approved operator.
630      * - `tokenId` must exist.
631      *
632      * Emits an {Approval} event.
633      */
634     function approve(address to, uint256 tokenId) external;
635 
636     /**
637      * @dev Returns the account approved for `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function getApproved(uint256 tokenId) external view returns (address operator);
644 
645     /**
646      * @dev Approve or remove `operator` as an operator for the caller.
647      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
648      *
649      * Requirements:
650      *
651      * - The `operator` cannot be the caller.
652      *
653      * Emits an {ApprovalForAll} event.
654      */
655     function setApprovalForAll(address operator, bool _approved) external;
656 
657     /**
658      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
659      *
660      * See {setApprovalForAll}
661      */
662     function isApprovedForAll(address owner, address operator) external view returns (bool);
663 
664     /**
665      * @dev Safely transfers `tokenId` token from `from` to `to`.
666      *
667      * Requirements:
668      *
669      * - `from` cannot be the zero address.
670      * - `to` cannot be the zero address.
671      * - `tokenId` token must exist and be owned by `from`.
672      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
673      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
674      *
675      * Emits a {Transfer} event.
676      */
677     function safeTransferFrom(
678         address from,
679         address to,
680         uint256 tokenId,
681         bytes calldata data
682     ) external;
683 }
684 
685 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
686 
687 
688 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
689 
690 pragma solidity ^0.8.0;
691 
692 
693 /**
694  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
695  * @dev See https://eips.ethereum.org/EIPS/eip-721
696  */
697 interface IERC721Enumerable is IERC721 {
698     /**
699      * @dev Returns the total amount of tokens stored by the contract.
700      */
701     function totalSupply() external view returns (uint256);
702 
703     /**
704      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
705      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
706      */
707     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
708 
709     /**
710      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
711      * Use along with {totalSupply} to enumerate all tokens.
712      */
713     function tokenByIndex(uint256 index) external view returns (uint256);
714 }
715 
716 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
717 
718 
719 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 
724 /**
725  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
726  * @dev See https://eips.ethereum.org/EIPS/eip-721
727  */
728 interface IERC721Metadata is IERC721 {
729     /**
730      * @dev Returns the token collection name.
731      */
732     function name() external view returns (string memory);
733 
734     /**
735      * @dev Returns the token collection symbol.
736      */
737     function symbol() external view returns (string memory);
738 
739     /**
740      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
741      */
742     function tokenURI(uint256 tokenId) external view returns (string memory);
743 }
744 
745 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
746 
747 
748 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
749 
750 pragma solidity ^0.8.0;
751 
752 
753 
754 
755 
756 
757 
758 
759 /**
760  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
761  * the Metadata extension, but not including the Enumerable extension, which is available separately as
762  * {ERC721Enumerable}.
763  */
764 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
765     using Address for address;
766     using Strings for uint256;
767 
768     // Token name
769     string private _name;
770 
771     // Token symbol
772     string private _symbol;
773 
774     // Mapping from token ID to owner address
775     mapping(uint256 => address) private _owners;
776 
777     // Mapping owner address to token count
778     mapping(address => uint256) private _balances;
779 
780     // Mapping from token ID to approved address
781     mapping(uint256 => address) private _tokenApprovals;
782 
783     // Mapping from owner to operator approvals
784     mapping(address => mapping(address => bool)) private _operatorApprovals;
785 
786     /**
787      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
788      */
789     constructor(string memory name_, string memory symbol_) {
790         _name = name_;
791         _symbol = symbol_;
792     }
793 
794     /**
795      * @dev See {IERC165-supportsInterface}.
796      */
797     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
798         return
799             interfaceId == type(IERC721).interfaceId ||
800             interfaceId == type(IERC721Metadata).interfaceId ||
801             super.supportsInterface(interfaceId);
802     }
803 
804     /**
805      * @dev See {IERC721-balanceOf}.
806      */
807     function balanceOf(address owner) public view virtual override returns (uint256) {
808         require(owner != address(0), "ERC721: balance query for the zero address");
809         return _balances[owner];
810     }
811 
812     /**
813      * @dev See {IERC721-ownerOf}.
814      */
815     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
816         address owner = _owners[tokenId];
817         require(owner != address(0), "ERC721: owner query for nonexistent token");
818         return owner;
819     }
820 
821     /**
822      * @dev See {IERC721Metadata-name}.
823      */
824     function name() public view virtual override returns (string memory) {
825         return _name;
826     }
827 
828     /**
829      * @dev See {IERC721Metadata-symbol}.
830      */
831     function symbol() public view virtual override returns (string memory) {
832         return _symbol;
833     }
834 
835     /**
836      * @dev See {IERC721Metadata-tokenURI}.
837      */
838     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
839         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
840 
841         string memory baseURI = _baseURI();
842         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
843     }
844 
845     /**
846      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
847      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
848      * by default, can be overriden in child contracts.
849      */
850     function _baseURI() internal view virtual returns (string memory) {
851         return "";
852     }
853 
854     /**
855      * @dev See {IERC721-approve}.
856      */
857     function approve(address to, uint256 tokenId) public virtual override {
858         address owner = ERC721.ownerOf(tokenId);
859         require(to != owner, "ERC721: approval to current owner");
860 
861         require(
862             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
863             "ERC721: approve caller is not owner nor approved for all"
864         );
865 
866         _approve(to, tokenId);
867     }
868 
869     /**
870      * @dev See {IERC721-getApproved}.
871      */
872     function getApproved(uint256 tokenId) public view virtual override returns (address) {
873         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
874 
875         return _tokenApprovals[tokenId];
876     }
877 
878     /**
879      * @dev See {IERC721-setApprovalForAll}.
880      */
881     function setApprovalForAll(address operator, bool approved) public virtual override {
882         _setApprovalForAll(_msgSender(), operator, approved);
883     }
884 
885     /**
886      * @dev See {IERC721-isApprovedForAll}.
887      */
888     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
889         return _operatorApprovals[owner][operator];
890     }
891 
892     /**
893      * @dev See {IERC721-transferFrom}.
894      */
895     function transferFrom(
896         address from,
897         address to,
898         uint256 tokenId
899     ) public virtual override {
900         //solhint-disable-next-line max-line-length
901         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
902 
903         _transfer(from, to, tokenId);
904     }
905 
906     /**
907      * @dev See {IERC721-safeTransferFrom}.
908      */
909     function safeTransferFrom(
910         address from,
911         address to,
912         uint256 tokenId
913     ) public virtual override {
914         safeTransferFrom(from, to, tokenId, "");
915     }
916 
917     /**
918      * @dev See {IERC721-safeTransferFrom}.
919      */
920     function safeTransferFrom(
921         address from,
922         address to,
923         uint256 tokenId,
924         bytes memory _data
925     ) public virtual override {
926         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
927         _safeTransfer(from, to, tokenId, _data);
928     }
929 
930     /**
931      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
932      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
933      *
934      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
935      *
936      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
937      * implement alternative mechanisms to perform token transfer, such as signature-based.
938      *
939      * Requirements:
940      *
941      * - `from` cannot be the zero address.
942      * - `to` cannot be the zero address.
943      * - `tokenId` token must exist and be owned by `from`.
944      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
945      *
946      * Emits a {Transfer} event.
947      */
948     function _safeTransfer(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory _data
953     ) internal virtual {
954         _transfer(from, to, tokenId);
955         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
956     }
957 
958     /**
959      * @dev Returns whether `tokenId` exists.
960      *
961      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
962      *
963      * Tokens start existing when they are minted (`_mint`),
964      * and stop existing when they are burned (`_burn`).
965      */
966     function _exists(uint256 tokenId) internal view virtual returns (bool) {
967         return _owners[tokenId] != address(0);
968     }
969 
970     /**
971      * @dev Returns whether `spender` is allowed to manage `tokenId`.
972      *
973      * Requirements:
974      *
975      * - `tokenId` must exist.
976      */
977     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
978         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
979         address owner = ERC721.ownerOf(tokenId);
980         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
981     }
982 
983     /**
984      * @dev Safely mints `tokenId` and transfers it to `to`.
985      *
986      * Requirements:
987      *
988      * - `tokenId` must not exist.
989      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
990      *
991      * Emits a {Transfer} event.
992      */
993     function _safeMint(address to, uint256 tokenId) internal virtual {
994         _safeMint(to, tokenId, "");
995     }
996 
997     /**
998      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
999      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1000      */
1001     function _safeMint(
1002         address to,
1003         uint256 tokenId,
1004         bytes memory _data
1005     ) internal virtual {
1006         _mint(to, tokenId);
1007         require(
1008             _checkOnERC721Received(address(0), to, tokenId, _data),
1009             "ERC721: transfer to non ERC721Receiver implementer"
1010         );
1011     }
1012 
1013     /**
1014      * @dev Mints `tokenId` and transfers it to `to`.
1015      *
1016      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must not exist.
1021      * - `to` cannot be the zero address.
1022      *
1023      * Emits a {Transfer} event.
1024      */
1025     function _mint(address to, uint256 tokenId) internal virtual {
1026         require(to != address(0), "ERC721: mint to the zero address");
1027         require(!_exists(tokenId), "ERC721: token already minted");
1028 
1029         _beforeTokenTransfer(address(0), to, tokenId);
1030 
1031         _balances[to] += 1;
1032         _owners[tokenId] = to;
1033 
1034         emit Transfer(address(0), to, tokenId);
1035     }
1036 
1037     /**
1038      * @dev Destroys `tokenId`.
1039      * The approval is cleared when the token is burned.
1040      *
1041      * Requirements:
1042      *
1043      * - `tokenId` must exist.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function _burn(uint256 tokenId) internal virtual {
1048         address owner = ERC721.ownerOf(tokenId);
1049 
1050         _beforeTokenTransfer(owner, address(0), tokenId);
1051 
1052         // Clear approvals
1053         _approve(address(0), tokenId);
1054 
1055         _balances[owner] -= 1;
1056         delete _owners[tokenId];
1057 
1058         emit Transfer(owner, address(0), tokenId);
1059     }
1060 
1061     /**
1062      * @dev Transfers `tokenId` from `from` to `to`.
1063      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1064      *
1065      * Requirements:
1066      *
1067      * - `to` cannot be the zero address.
1068      * - `tokenId` token must be owned by `from`.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function _transfer(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) internal virtual {
1077         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1078         require(to != address(0), "ERC721: transfer to the zero address");
1079 
1080         _beforeTokenTransfer(from, to, tokenId);
1081 
1082         // Clear approvals from the previous owner
1083         _approve(address(0), tokenId);
1084 
1085         _balances[from] -= 1;
1086         _balances[to] += 1;
1087         _owners[tokenId] = to;
1088 
1089         emit Transfer(from, to, tokenId);
1090     }
1091 
1092     /**
1093      * @dev Approve `to` to operate on `tokenId`
1094      *
1095      * Emits a {Approval} event.
1096      */
1097     function _approve(address to, uint256 tokenId) internal virtual {
1098         _tokenApprovals[tokenId] = to;
1099         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1100     }
1101 
1102     /**
1103      * @dev Approve `operator` to operate on all of `owner` tokens
1104      *
1105      * Emits a {ApprovalForAll} event.
1106      */
1107     function _setApprovalForAll(
1108         address owner,
1109         address operator,
1110         bool approved
1111     ) internal virtual {
1112         require(owner != operator, "ERC721: approve to caller");
1113         _operatorApprovals[owner][operator] = approved;
1114         emit ApprovalForAll(owner, operator, approved);
1115     }
1116 
1117     /**
1118      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1119      * The call is not executed if the target address is not a contract.
1120      *
1121      * @param from address representing the previous owner of the given token ID
1122      * @param to target address that will receive the tokens
1123      * @param tokenId uint256 ID of the token to be transferred
1124      * @param _data bytes optional data to send along with the call
1125      * @return bool whether the call correctly returned the expected magic value
1126      */
1127     function _checkOnERC721Received(
1128         address from,
1129         address to,
1130         uint256 tokenId,
1131         bytes memory _data
1132     ) private returns (bool) {
1133         if (to.isContract()) {
1134             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1135                 return retval == IERC721Receiver.onERC721Received.selector;
1136             } catch (bytes memory reason) {
1137                 if (reason.length == 0) {
1138                     revert("ERC721: transfer to non ERC721Receiver implementer");
1139                 } else {
1140                     assembly {
1141                         revert(add(32, reason), mload(reason))
1142                     }
1143                 }
1144             }
1145         } else {
1146             return true;
1147         }
1148     }
1149 
1150     /**
1151      * @dev Hook that is called before any token transfer. This includes minting
1152      * and burning.
1153      *
1154      * Calling conditions:
1155      *
1156      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1157      * transferred to `to`.
1158      * - When `from` is zero, `tokenId` will be minted for `to`.
1159      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1160      * - `from` and `to` are never both zero.
1161      *
1162      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1163      */
1164     function _beforeTokenTransfer(
1165         address from,
1166         address to,
1167         uint256 tokenId
1168     ) internal virtual {}
1169 }
1170 
1171 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1172 
1173 
1174 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1175 
1176 pragma solidity ^0.8.0;
1177 
1178 
1179 
1180 /**
1181  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1182  * enumerability of all the token ids in the contract as well as all token ids owned by each
1183  * account.
1184  */
1185 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1186     // Mapping from owner to list of owned token IDs
1187     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1188 
1189     // Mapping from token ID to index of the owner tokens list
1190     mapping(uint256 => uint256) private _ownedTokensIndex;
1191 
1192     // Array with all token ids, used for enumeration
1193     uint256[] private _allTokens;
1194 
1195     // Mapping from token id to position in the allTokens array
1196     mapping(uint256 => uint256) private _allTokensIndex;
1197 
1198     /**
1199      * @dev See {IERC165-supportsInterface}.
1200      */
1201     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1202         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1203     }
1204 
1205     /**
1206      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1207      */
1208     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1209         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1210         return _ownedTokens[owner][index];
1211     }
1212 
1213     /**
1214      * @dev See {IERC721Enumerable-totalSupply}.
1215      */
1216     function totalSupply() public view virtual override returns (uint256) {
1217         return _allTokens.length;
1218     }
1219 
1220     /**
1221      * @dev See {IERC721Enumerable-tokenByIndex}.
1222      */
1223     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1224         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1225         return _allTokens[index];
1226     }
1227 
1228     /**
1229      * @dev Hook that is called before any token transfer. This includes minting
1230      * and burning.
1231      *
1232      * Calling conditions:
1233      *
1234      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1235      * transferred to `to`.
1236      * - When `from` is zero, `tokenId` will be minted for `to`.
1237      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      *
1241      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1242      */
1243     function _beforeTokenTransfer(
1244         address from,
1245         address to,
1246         uint256 tokenId
1247     ) internal virtual override {
1248         super._beforeTokenTransfer(from, to, tokenId);
1249 
1250         if (from == address(0)) {
1251             _addTokenToAllTokensEnumeration(tokenId);
1252         } else if (from != to) {
1253             _removeTokenFromOwnerEnumeration(from, tokenId);
1254         }
1255         if (to == address(0)) {
1256             _removeTokenFromAllTokensEnumeration(tokenId);
1257         } else if (to != from) {
1258             _addTokenToOwnerEnumeration(to, tokenId);
1259         }
1260     }
1261 
1262     /**
1263      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1264      * @param to address representing the new owner of the given token ID
1265      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1266      */
1267     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1268         uint256 length = ERC721.balanceOf(to);
1269         _ownedTokens[to][length] = tokenId;
1270         _ownedTokensIndex[tokenId] = length;
1271     }
1272 
1273     /**
1274      * @dev Private function to add a token to this extension's token tracking data structures.
1275      * @param tokenId uint256 ID of the token to be added to the tokens list
1276      */
1277     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1278         _allTokensIndex[tokenId] = _allTokens.length;
1279         _allTokens.push(tokenId);
1280     }
1281 
1282     /**
1283      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1284      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1285      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1286      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1287      * @param from address representing the previous owner of the given token ID
1288      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1289      */
1290     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1291         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1292         // then delete the last slot (swap and pop).
1293 
1294         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1295         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1296 
1297         // When the token to delete is the last token, the swap operation is unnecessary
1298         if (tokenIndex != lastTokenIndex) {
1299             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1300 
1301             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1302             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1303         }
1304 
1305         // This also deletes the contents at the last position of the array
1306         delete _ownedTokensIndex[tokenId];
1307         delete _ownedTokens[from][lastTokenIndex];
1308     }
1309 
1310     /**
1311      * @dev Private function to remove a token from this extension's token tracking data structures.
1312      * This has O(1) time complexity, but alters the order of the _allTokens array.
1313      * @param tokenId uint256 ID of the token to be removed from the tokens list
1314      */
1315     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1316         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1317         // then delete the last slot (swap and pop).
1318 
1319         uint256 lastTokenIndex = _allTokens.length - 1;
1320         uint256 tokenIndex = _allTokensIndex[tokenId];
1321 
1322         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1323         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1324         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1325         uint256 lastTokenId = _allTokens[lastTokenIndex];
1326 
1327         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1328         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1329 
1330         // This also deletes the contents at the last position of the array
1331         delete _allTokensIndex[tokenId];
1332         _allTokens.pop();
1333     }
1334 }
1335 
1336 // File: CyberLegends.sol
1337 
1338 
1339 //   ___  _  _  ____  ____  ____  __    ____  ___  ____  __ _  ____  ____
1340 //  / __)( \/ )(  _ \(  __)(  _ \(  )  (  __)/ __)(  __)(  ( \(    \/ ___)
1341 // ( (__  )  /  ) _ ( ) _)  )   // (_/\ ) _)( (_ \ ) _) /    / ) D (\___ \
1342 //  \___)(__/  (____/(____)(__\_)\____/(____)\___/(____)\_)__)(____/(____/
1343 
1344 pragma solidity ^0.8.9;
1345 
1346 
1347 
1348 
1349 contract CyberLegends is ERC721Enumerable, Ownable {
1350     using Strings for uint256;
1351     string public baseURI;
1352     string public baseExtension = ".json";
1353     uint256 public cost = 0.25 ether;
1354     uint256 public whitelistCost = 0.22 ether;
1355     uint256 public goldlistCost = 0.18 ether;
1356     uint256 public maxSupply = 8888;
1357     uint256 public maxPerWallet = 5;
1358     uint256 public minted = 0;
1359     bool public paused = false;
1360     bool public revealed = false;
1361     string public notRevealedURI;
1362     bytes32 public wlMerkleRoot;
1363     bytes32 public glMerkleRoot;
1364 
1365     constructor(
1366         string memory _name,
1367         string memory _symbol,
1368         string memory _initBaseURI,
1369         string memory _initNotRevealedURI,
1370         bytes32 _wlMerkleRoot,
1371         bytes32 _glMerkleRoot
1372     ) ERC721(_name, _symbol) {
1373         setBaseURI(_initBaseURI);
1374         setMerkleRoots(_wlMerkleRoot, _glMerkleRoot);
1375         setNotRevealedURI(_initNotRevealedURI);
1376         mint(88);
1377         pause(true);
1378     }
1379 
1380     // internal
1381     function _baseURI() internal view virtual override returns (string memory) {
1382         return baseURI;
1383     }
1384 
1385     // public sale
1386     function mint(uint256 _mintAmount) public payable {
1387         require(!paused, "Contract is paused");
1388         require(_mintAmount > 0, "Mint amount cannot be null");
1389         uint256 supply = totalSupply();
1390 
1391         if (msg.sender != owner()) {
1392             uint256 nftCount = balanceOf(msg.sender) + _mintAmount;
1393             require(supply + _mintAmount <= maxSupply, "Mint amount exceed max supply");
1394             require(nftCount <= maxPerWallet, "Max per wallet reached");
1395             require(msg.value >= cost * _mintAmount, "Not enough ether sent");
1396         }
1397 
1398         for (uint256 i = 1; i <= _mintAmount; i++) {
1399             _safeMint(msg.sender, supply + i);
1400             minted += 1;
1401         }
1402     }
1403     
1404     // Multi level mint using _list - 1 = whitelist, 2 = goldlist
1405     function privilegedMint(uint256 _mintAmount, bytes32[] calldata _merkleProof, uint256 _list) public payable {
1406         require(!paused, "Contract is paused");
1407         require(_mintAmount > 0, "Mint amount cannot be null");
1408         require(_list == 1 || _list == 2, "Unknown list");
1409         uint256 nftCount = balanceOf(msg.sender) + _mintAmount;
1410         uint256 supply = totalSupply();
1411         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1412         require(supply + _mintAmount <= maxSupply, "Mint amount exceeds max supply");
1413         require(nftCount <= maxPerWallet, "You cannot mint that much");
1414         if (_list == 1) {
1415           require(MerkleProof.verify(_merkleProof, wlMerkleRoot, leaf), "Not in whitelist");
1416           require(msg.value >= whitelistCost * _mintAmount, "Not enough ether sent");
1417         }
1418         if (_list == 2) {
1419           require(MerkleProof.verify(_merkleProof, glMerkleRoot, leaf), "Not in goldlist");
1420           require(msg.value >= goldlistCost * _mintAmount, "Not enough ether sent");
1421         }
1422         
1423         for (uint256 i = 1; i <= _mintAmount; i++) {
1424             _safeMint(msg.sender, supply + i);
1425             minted += 1;
1426         }
1427     }
1428 
1429     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1430         uint256 ownerTokenCount = balanceOf(_owner);
1431         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1432         for (uint256 i; i < ownerTokenCount; i++) {
1433             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1434         }
1435         return tokenIds;
1436     }
1437 
1438     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1439         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1440 
1441         if (revealed == false) {
1442             return notRevealedURI;
1443         }
1444 
1445         string memory currentBaseURI = _baseURI();
1446         return
1447             bytes(currentBaseURI).length > 0
1448                 ? string(
1449                     abi.encodePacked(
1450                         currentBaseURI,
1451                         tokenId.toString(),
1452                         baseExtension
1453                     )
1454                 )
1455                 : "";
1456     }
1457 
1458     function setCost(uint256 _newCost) public onlyOwner {
1459         cost = _newCost;
1460     }
1461 
1462     function setWhitelistCost(uint256 _newCost) public onlyOwner {
1463         whitelistCost = _newCost;
1464     }
1465 
1466     function setGoldlistCost(uint256 _newCost) public onlyOwner {
1467         goldlistCost = _newCost;
1468     }
1469 
1470     function setMaxPerWallet(uint256 _newMaxPerWallet) public onlyOwner {
1471         maxPerWallet = _newMaxPerWallet;
1472     }
1473 
1474     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1475         baseURI = _newBaseURI;
1476     }
1477 
1478     function setNotRevealedURI(string memory _newNotRevealedURI) public onlyOwner {
1479         notRevealedURI = _newNotRevealedURI;
1480     }
1481 
1482     function setMerkleRoots(bytes32 _wlMerkleRoot, bytes32 _glMerkleRoot) public onlyOwner {
1483         wlMerkleRoot = _wlMerkleRoot;
1484         glMerkleRoot = _glMerkleRoot;
1485     }
1486 
1487     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1488         baseExtension = _newBaseExtension;
1489     }
1490 
1491     function reveal(bool _state) public onlyOwner {
1492         revealed = _state;
1493     }
1494 
1495     function pause(bool _state) public onlyOwner {
1496         paused = _state;
1497     }
1498 
1499     function withdraw() public payable onlyOwner {
1500         require(payable(msg.sender).send(address(this).balance));
1501     }
1502 }