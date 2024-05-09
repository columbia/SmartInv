1 // File: @openzeppelin/contracts@4.5.0/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
64 // File: @openzeppelin/contracts/utils/Strings.sol
65 
66 
67 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @dev String operations.
73  */
74 library Strings {
75     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
76     uint8 private constant _ADDRESS_LENGTH = 20;
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 
134     /**
135      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
136      */
137     function toHexString(address addr) internal pure returns (string memory) {
138         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
139     }
140 }
141 
142 // File: @openzeppelin/contracts/utils/Context.sol
143 
144 
145 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
146 
147 pragma solidity ^0.8.0;
148 
149 /**
150  * @dev Provides information about the current execution context, including the
151  * sender of the transaction and its data. While these are generally available
152  * via msg.sender and msg.data, they should not be accessed in such a direct
153  * manner, since when dealing with meta-transactions the account sending and
154  * paying for execution may not be the actual sender (as far as an application
155  * is concerned).
156  *
157  * This contract is only required for intermediate, library-like contracts.
158  */
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address) {
161         return msg.sender;
162     }
163 
164     function _msgData() internal view virtual returns (bytes calldata) {
165         return msg.data;
166     }
167 }
168 
169 // File: @openzeppelin/contracts/access/Ownable.sol
170 
171 
172 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
173 
174 pragma solidity ^0.8.0;
175 
176 
177 /**
178  * @dev Contract module which provides a basic access control mechanism, where
179  * there is an account (an owner) that can be granted exclusive access to
180  * specific functions.
181  *
182  * By default, the owner account will be the one that deploys the contract. This
183  * can later be changed with {transferOwnership}.
184  *
185  * This module is used through inheritance. It will make available the modifier
186  * `onlyOwner`, which can be applied to your functions to restrict their use to
187  * the owner.
188  */
189 abstract contract Ownable is Context {
190     address private _owner;
191 
192     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
193 
194     /**
195      * @dev Initializes the contract setting the deployer as the initial owner.
196      */
197     constructor() {
198         _transferOwnership(_msgSender());
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         _checkOwner();
206         _;
207     }
208 
209     /**
210      * @dev Returns the address of the current owner.
211      */
212     function owner() public view virtual returns (address) {
213         return _owner;
214     }
215 
216     /**
217      * @dev Throws if the sender is not the owner.
218      */
219     function _checkOwner() internal view virtual {
220         require(owner() == _msgSender(), "Ownable: caller is not the owner");
221     }
222 
223     /**
224      * @dev Leaves the contract without owner. It will not be possible to call
225      * `onlyOwner` functions anymore. Can only be called by the current owner.
226      *
227      * NOTE: Renouncing ownership will leave the contract without an owner,
228      * thereby removing any functionality that is only available to the owner.
229      */
230     function renounceOwnership() public virtual onlyOwner {
231         _transferOwnership(address(0));
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Can only be called by the current owner.
237      */
238     function transferOwnership(address newOwner) public virtual onlyOwner {
239         require(newOwner != address(0), "Ownable: new owner is the zero address");
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
256 
257 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
258 
259 pragma solidity ^0.8.1;
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      *
282      * [IMPORTANT]
283      * ====
284      * You shouldn't rely on `isContract` to protect against flash loan attacks!
285      *
286      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
287      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
288      * constructor.
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies on extcodesize/address.code.length, which returns 0
293         // for contracts in construction, since the code is only stored at the end
294         // of the constructor execution.
295 
296         return account.code.length > 0;
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         (bool success, ) = recipient.call{value: amount}("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain `call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341         return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(
351         address target,
352         bytes memory data,
353         string memory errorMessage
354     ) internal returns (bytes memory) {
355         return functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value
373     ) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(
384         address target,
385         bytes memory data,
386         uint256 value,
387         string memory errorMessage
388     ) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         require(isContract(target), "Address: call to non-contract");
391 
392         (bool success, bytes memory returndata) = target.call{value: value}(data);
393         return verifyCallResult(success, returndata, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but performing a static call.
399      *
400      * _Available since v3.3._
401      */
402     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
403         return functionStaticCall(target, data, "Address: low-level static call failed");
404     }
405 
406     /**
407      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
408      * but performing a static call.
409      *
410      * _Available since v3.3._
411      */
412     function functionStaticCall(
413         address target,
414         bytes memory data,
415         string memory errorMessage
416     ) internal view returns (bytes memory) {
417         require(isContract(target), "Address: static call to non-contract");
418 
419         (bool success, bytes memory returndata) = target.staticcall(data);
420         return verifyCallResult(success, returndata, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but performing a delegate call.
426      *
427      * _Available since v3.4._
428      */
429     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
430         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
435      * but performing a delegate call.
436      *
437      * _Available since v3.4._
438      */
439     function functionDelegateCall(
440         address target,
441         bytes memory data,
442         string memory errorMessage
443     ) internal returns (bytes memory) {
444         require(isContract(target), "Address: delegate call to non-contract");
445 
446         (bool success, bytes memory returndata) = target.delegatecall(data);
447         return verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
452      * revert reason using the provided one.
453      *
454      * _Available since v4.3._
455      */
456     function verifyCallResult(
457         bool success,
458         bytes memory returndata,
459         string memory errorMessage
460     ) internal pure returns (bytes memory) {
461         if (success) {
462             return returndata;
463         } else {
464             // Look for revert reason and bubble it up if present
465             if (returndata.length > 0) {
466                 // The easiest way to bubble the revert reason is using memory via assembly
467                 /// @solidity memory-safe-assembly
468                 assembly {
469                     let returndata_size := mload(returndata)
470                     revert(add(32, returndata), returndata_size)
471                 }
472             } else {
473                 revert(errorMessage);
474             }
475         }
476     }
477 }
478 
479 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
480 
481 
482 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @title ERC721 token receiver interface
488  * @dev Interface for any contract that wants to support safeTransfers
489  * from ERC721 asset contracts.
490  */
491 interface IERC721Receiver {
492     /**
493      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
494      * by `operator` from `from`, this function is called.
495      *
496      * It must return its Solidity selector to confirm the token transfer.
497      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
498      *
499      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
500      */
501     function onERC721Received(
502         address operator,
503         address from,
504         uint256 tokenId,
505         bytes calldata data
506     ) external returns (bytes4);
507 }
508 
509 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
510 
511 
512 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
513 
514 pragma solidity ^0.8.0;
515 
516 /**
517  * @dev Interface of the ERC165 standard, as defined in the
518  * https://eips.ethereum.org/EIPS/eip-165[EIP].
519  *
520  * Implementers can declare support of contract interfaces, which can then be
521  * queried by others ({ERC165Checker}).
522  *
523  * For an implementation, see {ERC165}.
524  */
525 interface IERC165 {
526     /**
527      * @dev Returns true if this contract implements the interface defined by
528      * `interfaceId`. See the corresponding
529      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
530      * to learn more about how these ids are created.
531      *
532      * This function call must use less than 30 000 gas.
533      */
534     function supportsInterface(bytes4 interfaceId) external view returns (bool);
535 }
536 
537 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
538 
539 
540 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
541 
542 pragma solidity ^0.8.0;
543 
544 
545 /**
546  * @dev Implementation of the {IERC165} interface.
547  *
548  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
549  * for the additional interface id that will be supported. For example:
550  *
551  * ```solidity
552  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
553  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
554  * }
555  * ```
556  *
557  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
558  */
559 abstract contract ERC165 is IERC165 {
560     /**
561      * @dev See {IERC165-supportsInterface}.
562      */
563     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
564         return interfaceId == type(IERC165).interfaceId;
565     }
566 }
567 
568 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
569 
570 
571 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
572 
573 pragma solidity ^0.8.0;
574 
575 
576 /**
577  * @dev Required interface of an ERC721 compliant contract.
578  */
579 interface IERC721 is IERC165 {
580     /**
581      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
582      */
583     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
584 
585     /**
586      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
587      */
588     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
589 
590     /**
591      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
592      */
593     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
594 
595     /**
596      * @dev Returns the number of tokens in ``owner``'s account.
597      */
598     function balanceOf(address owner) external view returns (uint256 balance);
599 
600     /**
601      * @dev Returns the owner of the `tokenId` token.
602      *
603      * Requirements:
604      *
605      * - `tokenId` must exist.
606      */
607     function ownerOf(uint256 tokenId) external view returns (address owner);
608 
609     /**
610      * @dev Safely transfers `tokenId` token from `from` to `to`.
611      *
612      * Requirements:
613      *
614      * - `from` cannot be the zero address.
615      * - `to` cannot be the zero address.
616      * - `tokenId` token must exist and be owned by `from`.
617      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
619      *
620      * Emits a {Transfer} event.
621      */
622     function safeTransferFrom(
623         address from,
624         address to,
625         uint256 tokenId,
626         bytes calldata data
627     ) external;
628 
629     /**
630      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
631      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
632      *
633      * Requirements:
634      *
635      * - `from` cannot be the zero address.
636      * - `to` cannot be the zero address.
637      * - `tokenId` token must exist and be owned by `from`.
638      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
639      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
640      *
641      * Emits a {Transfer} event.
642      */
643     function safeTransferFrom(
644         address from,
645         address to,
646         uint256 tokenId
647     ) external;
648 
649     /**
650      * @dev Transfers `tokenId` token from `from` to `to`.
651      *
652      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
653      *
654      * Requirements:
655      *
656      * - `from` cannot be the zero address.
657      * - `to` cannot be the zero address.
658      * - `tokenId` token must be owned by `from`.
659      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
660      *
661      * Emits a {Transfer} event.
662      */
663     function transferFrom(
664         address from,
665         address to,
666         uint256 tokenId
667     ) external;
668 
669     /**
670      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
671      * The approval is cleared when the token is transferred.
672      *
673      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
674      *
675      * Requirements:
676      *
677      * - The caller must own the token or be an approved operator.
678      * - `tokenId` must exist.
679      *
680      * Emits an {Approval} event.
681      */
682     function approve(address to, uint256 tokenId) external;
683 
684     /**
685      * @dev Approve or remove `operator` as an operator for the caller.
686      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
687      *
688      * Requirements:
689      *
690      * - The `operator` cannot be the caller.
691      *
692      * Emits an {ApprovalForAll} event.
693      */
694     function setApprovalForAll(address operator, bool _approved) external;
695 
696     /**
697      * @dev Returns the account approved for `tokenId` token.
698      *
699      * Requirements:
700      *
701      * - `tokenId` must exist.
702      */
703     function getApproved(uint256 tokenId) external view returns (address operator);
704 
705     /**
706      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
707      *
708      * See {setApprovalForAll}
709      */
710     function isApprovedForAll(address owner, address operator) external view returns (bool);
711 }
712 
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
714 
715 
716 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Metadata is IERC721 {
726     /**
727      * @dev Returns the token collection name.
728      */
729     function name() external view returns (string memory);
730 
731     /**
732      * @dev Returns the token collection symbol.
733      */
734     function symbol() external view returns (string memory);
735 
736     /**
737      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
738      */
739     function tokenURI(uint256 tokenId) external view returns (string memory);
740 }
741 
742 // File: contracts/ERC721A.sol
743 
744 
745 // Creator: Chiru Labs
746 
747 pragma solidity ^0.8.4;
748 
749 
750 
751 
752 
753 
754 
755 
756 error ApprovalCallerNotOwnerNorApproved();
757 error ApprovalQueryForNonexistentToken();
758 error ApproveToCaller();
759 error ApprovalToCurrentOwner();
760 error BalanceQueryForZeroAddress();
761 error MintToZeroAddress();
762 error MintZeroQuantity();
763 error OwnerQueryForNonexistentToken();
764 error TransferCallerNotOwnerNorApproved();
765 error TransferFromIncorrectOwner();
766 error TransferToNonERC721ReceiverImplementer();
767 error TransferToZeroAddress();
768 error URIQueryForNonexistentToken();
769 
770 /**
771  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
772  * the Metadata extension. Built to optimize for lower gas during batch mints.
773  *
774  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
775  *
776  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
777  *
778  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
779  */
780 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
781     using Address for address;
782     using Strings for uint256;
783 
784     // Compiler will pack this into a single 256bit word.
785     struct TokenOwnership {
786         // The address of the owner.
787         address addr;
788         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
789         uint64 startTimestamp;
790         // Whether the token has been burned.
791         bool burned;
792     }
793 
794     // Compiler will pack this into a single 256bit word.
795     struct AddressData {
796         // Realistically, 2**64-1 is more than enough.
797         uint64 balance;
798         // Keeps track of mint count with minimal overhead for tokenomics.
799         uint64 numberMinted;
800         // Keeps track of burn count with minimal overhead for tokenomics.
801         uint64 numberBurned;
802         // For miscellaneous variable(s) pertaining to the address
803         // (e.g. number of whitelist mint slots used).
804         // If there are multiple variables, please pack them into a uint64.
805         uint64 aux;
806     }
807 
808     // The tokenId of the next token to be minted.
809     uint256 internal _currentIndex;
810 
811     // The number of tokens burned.
812     uint256 internal _burnCounter;
813 
814     // Token name
815     string private _name;
816 
817     // Token symbol
818     string private _symbol;
819 
820     // Mapping from token ID to ownership details
821     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
822     mapping(uint256 => TokenOwnership) internal _ownerships;
823 
824     // Mapping owner address to address data
825     mapping(address => AddressData) private _addressData;
826 
827     // Mapping from token ID to approved address
828     mapping(uint256 => address) private _tokenApprovals;
829 
830     // Mapping from owner to operator approvals
831     mapping(address => mapping(address => bool)) private _operatorApprovals;
832 
833     constructor(string memory name_, string memory symbol_) {
834         _name = name_;
835         _symbol = symbol_;
836         _currentIndex = _startTokenId();
837     }
838 
839     /**
840      * To change the starting tokenId, please override this function.
841      */
842     function _startTokenId() internal view virtual returns (uint256) {
843         return 0;
844     }
845 
846     /**
847      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
848      */
849     function totalSupply() public view returns (uint256) {
850         // Counter underflow is impossible as _burnCounter cannot be incremented
851         // more than _currentIndex - _startTokenId() times
852         unchecked {
853             return _currentIndex - _burnCounter - _startTokenId();
854         }
855     }
856 
857     /**
858      * Returns the total amount of tokens minted in the contract.
859      */
860     function _totalMinted() internal view returns (uint256) {
861         // Counter underflow is impossible as _currentIndex does not decrement,
862         // and it is initialized to _startTokenId()
863         unchecked {
864             return _currentIndex - _startTokenId();
865         }
866     }
867 
868     /**
869      * @dev See {IERC165-supportsInterface}.
870      */
871     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
872         return
873             interfaceId == type(IERC721).interfaceId ||
874             interfaceId == type(IERC721Metadata).interfaceId ||
875             super.supportsInterface(interfaceId);
876     }
877 
878     /**
879      * @dev See {IERC721-balanceOf}.
880      */
881     function balanceOf(address owner) public view override returns (uint256) {
882         if (owner == address(0)) revert BalanceQueryForZeroAddress();
883         return uint256(_addressData[owner].balance);
884     }
885 
886     function getHolderWL(address owner) public view returns (uint256) {
887        uint256 holderWL;
888        holderWL = uint256(IERC721(0x6FEFb647395e680339bADC84dC774E3CA8bCA7B9).balanceOf(owner));
889        return holderWL;
890     }
891 
892     /**
893      * Returns the number of tokens minted by `owner`.
894      */
895     function _numberMinted(address owner) internal view returns (uint256) {
896         return uint256(_addressData[owner].numberMinted);
897     }
898 
899     /**
900      * Returns the number of tokens burned by or on behalf of `owner`.
901      */
902     function _numberBurned(address owner) internal view returns (uint256) {
903         return uint256(_addressData[owner].numberBurned);
904     }
905 
906     /**
907      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
908      */
909     function _getAux(address owner) internal view returns (uint64) {
910         return _addressData[owner].aux;
911     }
912 
913     /**
914      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
915      * If there are multiple variables, please pack them into a uint64.
916      */
917     function _setAux(address owner, uint64 aux) internal {
918         _addressData[owner].aux = aux;
919     }
920 
921     /**
922      * Gas spent here starts off proportional to the maximum mint batch size.
923      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
924      */
925     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
926         uint256 curr = tokenId;
927 
928         unchecked {
929             if (_startTokenId() <= curr && curr < _currentIndex) {
930                 TokenOwnership memory ownership = _ownerships[curr];
931                 if (!ownership.burned) {
932                     if (ownership.addr != address(0)) {
933                         return ownership;
934                     }
935                     // Invariant:
936                     // There will always be an ownership that has an address and is not burned
937                     // before an ownership that does not have an address and is not burned.
938                     // Hence, curr will not underflow.
939                     while (true) {
940                         curr--;
941                         ownership = _ownerships[curr];
942                         if (ownership.addr != address(0)) {
943                             return ownership;
944                         }
945                     }
946                 }
947             }
948         }
949         revert OwnerQueryForNonexistentToken();
950     }
951 
952     /**
953      * @dev See {IERC721-ownerOf}.
954      */
955     function ownerOf(uint256 tokenId) public view override returns (address) {
956         return _ownershipOf(tokenId).addr;
957     }
958 
959     /**
960      * @dev See {IERC721Metadata-name}.
961      */
962     function name() public view virtual override returns (string memory) {
963         return _name;
964     }
965 
966     /**
967      * @dev See {IERC721Metadata-symbol}.
968      */
969     function symbol() public view virtual override returns (string memory) {
970         return _symbol;
971     }
972 
973     /**
974      * @dev See {IERC721Metadata-tokenURI}.
975      */
976     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
977         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
978 
979         string memory baseURI = _baseURI();
980         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
981     }
982 
983     /**
984      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
985      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
986      * by default, can be overriden in child contracts.
987      */
988     function _baseURI() internal view virtual returns (string memory) {
989         return '';
990     }
991 
992     /**
993      * @dev See {IERC721-approve}.
994      */
995     function approve(address to, uint256 tokenId) public override {
996         address owner = ERC721A.ownerOf(tokenId);
997         if (to == owner) revert ApprovalToCurrentOwner();
998 
999         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1000             revert ApprovalCallerNotOwnerNorApproved();
1001         }
1002 
1003         _approve(to, tokenId, owner);
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-getApproved}.
1008      */
1009     function getApproved(uint256 tokenId) public view override returns (address) {
1010         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1011 
1012         return _tokenApprovals[tokenId];
1013     }
1014 
1015     /**
1016      * @dev See {IERC721-setApprovalForAll}.
1017      */
1018     function setApprovalForAll(address operator, bool approved) public virtual override {
1019         if (operator == _msgSender()) revert ApproveToCaller();
1020 
1021         _operatorApprovals[_msgSender()][operator] = approved;
1022         emit ApprovalForAll(_msgSender(), operator, approved);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-isApprovedForAll}.
1027      */
1028     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1029         return _operatorApprovals[owner][operator];
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-transferFrom}.
1034      */
1035     function transferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId
1039     ) public virtual override {
1040         _transfer(from, to, tokenId);
1041     }
1042 
1043     /**
1044      * @dev See {IERC721-safeTransferFrom}.
1045      */
1046     function safeTransferFrom(
1047         address from,
1048         address to,
1049         uint256 tokenId
1050     ) public virtual override {
1051         safeTransferFrom(from, to, tokenId, '');
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-safeTransferFrom}.
1056      */
1057     function safeTransferFrom(
1058         address from,
1059         address to,
1060         uint256 tokenId,
1061         bytes memory _data
1062     ) public virtual override {
1063         _transfer(from, to, tokenId);
1064         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1065             revert TransferToNonERC721ReceiverImplementer();
1066         }
1067     }
1068 
1069     /**
1070      * @dev Returns whether `tokenId` exists.
1071      *
1072      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1073      *
1074      * Tokens start existing when they are minted (`_mint`),
1075      */
1076     function _exists(uint256 tokenId) internal view returns (bool) {
1077         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1078     }
1079 
1080     function _safeMint(address to, uint256 quantity) internal {
1081         _safeMint(to, quantity, '');
1082     }
1083 
1084     /**
1085      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1086      *
1087      * Requirements:
1088      *
1089      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1090      * - `quantity` must be greater than 0.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function _safeMint(
1095         address to,
1096         uint256 quantity,
1097         bytes memory _data
1098     ) internal {
1099         _mint(to, quantity, _data, true);
1100     }
1101 
1102     /**
1103      * @dev Mints `quantity` tokens and transfers them to `to`.
1104      *
1105      * Requirements:
1106      *
1107      * - `to` cannot be the zero address.
1108      * - `quantity` must be greater than 0.
1109      *
1110      * Emits a {Transfer} event.
1111      */
1112     function _mint(
1113         address to,
1114         uint256 quantity,
1115         bytes memory _data,
1116         bool safe
1117     ) internal {
1118         uint256 startTokenId = _currentIndex;
1119         if (to == address(0)) revert MintToZeroAddress();
1120         if (quantity == 0) revert MintZeroQuantity();
1121 
1122         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1123 
1124         // Overflows are incredibly unrealistic.
1125         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1126         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1127         unchecked {
1128             _addressData[to].balance += uint64(quantity);
1129             _addressData[to].numberMinted += uint64(quantity);
1130 
1131             _ownerships[startTokenId].addr = to;
1132             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1133 
1134             uint256 updatedIndex = startTokenId;
1135             uint256 end = updatedIndex + quantity;
1136 
1137             if (safe && to.isContract()) {
1138                 do {
1139                     emit Transfer(address(0), to, updatedIndex);
1140                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1141                         revert TransferToNonERC721ReceiverImplementer();
1142                     }
1143                 } while (updatedIndex != end);
1144                 // Reentrancy protection
1145                 if (_currentIndex != startTokenId) revert();
1146             } else {
1147                 do {
1148                     emit Transfer(address(0), to, updatedIndex++);
1149                 } while (updatedIndex != end);
1150             }
1151             _currentIndex = updatedIndex;
1152         }
1153         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1154     }
1155 
1156     /**
1157      * @dev Transfers `tokenId` from `from` to `to`.
1158      *
1159      * Requirements:
1160      *
1161      * - `to` cannot be the zero address.
1162      * - `tokenId` token must be owned by `from`.
1163      *
1164      * Emits a {Transfer} event.
1165      */
1166     function _transfer(
1167         address from,
1168         address to,
1169         uint256 tokenId
1170     ) private {
1171         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1172 
1173         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1174 
1175         bool isApprovedOrOwner = (_msgSender() == from ||
1176             isApprovedForAll(from, _msgSender()) ||
1177             getApproved(tokenId) == _msgSender());
1178 
1179         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1180         if (to == address(0)) revert TransferToZeroAddress();
1181 
1182         _beforeTokenTransfers(from, to, tokenId, 1);
1183 
1184         // Clear approvals from the previous owner
1185         _approve(address(0), tokenId, from);
1186 
1187         // Underflow of the sender's balance is impossible because we check for
1188         // ownership above and the recipient's balance can't realistically overflow.
1189         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1190         unchecked {
1191             _addressData[from].balance -= 1;
1192             _addressData[to].balance += 1;
1193 
1194             TokenOwnership storage currSlot = _ownerships[tokenId];
1195             currSlot.addr = to;
1196             currSlot.startTimestamp = uint64(block.timestamp);
1197 
1198             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1199             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1200             uint256 nextTokenId = tokenId + 1;
1201             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1202             if (nextSlot.addr == address(0)) {
1203                 // This will suffice for checking _exists(nextTokenId),
1204                 // as a burned slot cannot contain the zero address.
1205                 if (nextTokenId != _currentIndex) {
1206                     nextSlot.addr = from;
1207                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1208                 }
1209             }
1210         }
1211 
1212         emit Transfer(from, to, tokenId);
1213         _afterTokenTransfers(from, to, tokenId, 1);
1214     }
1215 
1216     /**
1217      * @dev This is equivalent to _burn(tokenId, false)
1218      */
1219     function _burn(uint256 tokenId) internal virtual {
1220         _burn(tokenId, false);
1221     }
1222 
1223     /**
1224      * @dev Destroys `tokenId`.
1225      * The approval is cleared when the token is burned.
1226      *
1227      * Requirements:
1228      *
1229      * - `tokenId` must exist.
1230      *
1231      * Emits a {Transfer} event.
1232      */
1233     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1234         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1235 
1236         address from = prevOwnership.addr;
1237 
1238         if (approvalCheck) {
1239             bool isApprovedOrOwner = (_msgSender() == from ||
1240                 isApprovedForAll(from, _msgSender()) ||
1241                 getApproved(tokenId) == _msgSender());
1242 
1243             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1244         }
1245 
1246         _beforeTokenTransfers(from, address(0), tokenId, 1);
1247 
1248         // Clear approvals from the previous owner
1249         _approve(address(0), tokenId, from);
1250 
1251         // Underflow of the sender's balance is impossible because we check for
1252         // ownership above and the recipient's balance can't realistically overflow.
1253         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1254         unchecked {
1255             AddressData storage addressData = _addressData[from];
1256             addressData.balance -= 1;
1257             addressData.numberBurned += 1;
1258 
1259             // Keep track of who burned the token, and the timestamp of burning.
1260             TokenOwnership storage currSlot = _ownerships[tokenId];
1261             currSlot.addr = from;
1262             currSlot.startTimestamp = uint64(block.timestamp);
1263             currSlot.burned = true;
1264 
1265             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1266             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1267             uint256 nextTokenId = tokenId + 1;
1268             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1269             if (nextSlot.addr == address(0)) {
1270                 // This will suffice for checking _exists(nextTokenId),
1271                 // as a burned slot cannot contain the zero address.
1272                 if (nextTokenId != _currentIndex) {
1273                     nextSlot.addr = from;
1274                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1275                 }
1276             }
1277         }
1278 
1279         emit Transfer(from, address(0), tokenId);
1280         _afterTokenTransfers(from, address(0), tokenId, 1);
1281 
1282         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1283         unchecked {
1284             _burnCounter++;
1285         }
1286     }
1287 
1288     /**
1289      * @dev Approve `to` to operate on `tokenId`
1290      *
1291      * Emits a {Approval} event.
1292      */
1293     function _approve(
1294         address to,
1295         uint256 tokenId,
1296         address owner
1297     ) private {
1298         _tokenApprovals[tokenId] = to;
1299         emit Approval(owner, to, tokenId);
1300     }
1301 
1302     /**
1303      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1304      *
1305      * @param from address representing the previous owner of the given token ID
1306      * @param to target address that will receive the tokens
1307      * @param tokenId uint256 ID of the token to be transferred
1308      * @param _data bytes optional data to send along with the call
1309      * @return bool whether the call correctly returned the expected magic value
1310      */
1311     function _checkContractOnERC721Received(
1312         address from,
1313         address to,
1314         uint256 tokenId,
1315         bytes memory _data
1316     ) private returns (bool) {
1317         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1318             return retval == IERC721Receiver(to).onERC721Received.selector;
1319         } catch (bytes memory reason) {
1320             if (reason.length == 0) {
1321                 revert TransferToNonERC721ReceiverImplementer();
1322             } else {
1323                 assembly {
1324                     revert(add(32, reason), mload(reason))
1325                 }
1326             }
1327         }
1328     }
1329 
1330     /**
1331      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1332      * And also called before burning one token.
1333      *
1334      * startTokenId - the first token id to be transferred
1335      * quantity - the amount to be transferred
1336      *
1337      * Calling conditions:
1338      *
1339      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1340      * transferred to `to`.
1341      * - When `from` is zero, `tokenId` will be minted for `to`.
1342      * - When `to` is zero, `tokenId` will be burned by `from`.
1343      * - `from` and `to` are never both zero.
1344      */
1345     function _beforeTokenTransfers(
1346         address from,
1347         address to,
1348         uint256 startTokenId,
1349         uint256 quantity
1350     ) internal virtual {}
1351 
1352     /**
1353      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1354      * minting.
1355      * And also called after one token has been burned.
1356      *
1357      * startTokenId - the first token id to be transferred
1358      * quantity - the amount to be transferred
1359      *
1360      * Calling conditions:
1361      *
1362      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1363      * transferred to `to`.
1364      * - When `from` is zero, `tokenId` has been minted for `to`.
1365      * - When `to` is zero, `tokenId` has been burned by `from`.
1366      * - `from` and `to` are never both zero.
1367      */
1368     function _afterTokenTransfers(
1369         address from,
1370         address to,
1371         uint256 startTokenId,
1372         uint256 quantity
1373     ) internal virtual {}
1374 }
1375 // File: contracts/SliceOfHeaven.sol
1376 
1377 //SPDX-License-Identifier: MIT
1378 pragma solidity ^0.8.9;
1379 
1380 
1381 
1382 
1383 
1384 contract SLICEOFHEAVEN is ERC721A, Ownable {
1385     using Strings for uint256;
1386     uint256 public constant maxSupply = 1000;
1387     uint256 public cost = 0.02 ether;
1388     uint256 public WLcost = 0.02 ether;
1389     uint256 public pubCost = 0.04 ether;
1390     uint256 public holderQ;
1391     bytes32 private merkleRoot;
1392     bool public holderSaleActive;
1393     bool public pubActive;
1394     string private baseURI;
1395     bool public appendedID;
1396     mapping(address => uint256) public holderFreeMintAmount;
1397     mapping(address => uint256) public holderPaidMintAmount;
1398     mapping(address => uint256) public whitelistFreeClaimed;
1399     mapping(address => uint256) public whitelistPaidClaimed;
1400     mapping(address => uint256) public pubPaidMintAmount;
1401 
1402     constructor() ERC721A("Slice Of Heaven By BEEBLE", "SLICEOFHEAVEN") {
1403     }
1404 
1405     function mintFreeHolder(uint256 _quantity, bytes32[] memory _merkleProof) external payable {
1406         uint256 supply = totalSupply();
1407         holderQ = getHolderWL(msg.sender);
1408         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1409         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1410         require(supply + _quantity <= maxSupply, "Cant go over supply");
1411         require(holderSaleActive, "HOLDERSALE_INACTIVE");
1412         require(holderFreeMintAmount[msg.sender] + _quantity <= holderQ, "HOLDERSALEFREE_MAXED");
1413         unchecked {
1414             holderFreeMintAmount[msg.sender] += _quantity;
1415         }
1416         _safeMint(msg.sender, 1);
1417     }
1418 
1419     function mintPaidHolder(uint256 _quantity, bytes32[] memory _merkleProof) external payable {
1420         uint256 supply = totalSupply();
1421         holderQ = getHolderWL(msg.sender);
1422         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1423         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1424         require(supply + _quantity <= maxSupply, "Cant go over supply");
1425         require(holderSaleActive, "HOLDERSALE_INACTIVE");
1426         require(holderPaidMintAmount[msg.sender] + _quantity <= holderQ*2, "HOLDERSALEPAID_MAXED");
1427         require(msg.value >= cost, "INCORRECT_ETH");
1428         unchecked {
1429             holderPaidMintAmount[msg.sender] += _quantity;
1430         }
1431         _safeMint(msg.sender, _quantity);
1432     }
1433 
1434     function mintPaidWL(uint256 _quantity, bytes32[] memory _merkleProof) public payable {
1435         require(holderSaleActive, "HOLDERSALE_INACTIVE");
1436         holderQ = getHolderWL(msg.sender);
1437         require(holderQ == 0);
1438         uint256 s = totalSupply();
1439         require(s + _quantity <= maxSupply, "Cant go over supply");
1440         require(msg.value >= WLcost);
1441         bytes32 leaf = keccak256(abi.encodePacked(_msgSender()));
1442         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), 'Invalid proof!');
1443         require(whitelistPaidClaimed[msg.sender] + _quantity <= 2, "WLPAID_MAXED");
1444         unchecked {
1445             whitelistPaidClaimed[msg.sender] += _quantity;
1446         }
1447         _safeMint(msg.sender, 1);
1448         delete s;
1449     }
1450 
1451 
1452     function mintPaidPublic(uint256 _quantity) external payable {
1453         uint256 s = totalSupply();
1454         require(s + _quantity <= maxSupply, "Cant go over supply");
1455         require(pubActive, "PUBLIC_INACTIVE");
1456         require(msg.value >= pubCost, "INCORRECT_ETH");
1457         require(pubPaidMintAmount[msg.sender] + _quantity <= 4, "PUBLICPAID_MAXED");
1458         unchecked {
1459             pubPaidMintAmount[msg.sender] += _quantity;
1460         }
1461         _safeMint(msg.sender, _quantity);
1462     }
1463 
1464     function treasuryMint(address _account, uint256 _quantity)
1465         external
1466         onlyOwner
1467     {
1468         uint256 s = totalSupply();
1469         require(s + _quantity <= maxSupply, "Over Supply");
1470         require(_quantity > 0, "QUANTITY_INVALID");
1471         _safeMint(_account, _quantity);
1472     }
1473 
1474     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1475         merkleRoot = _merkleRoot;
1476     }
1477 
1478     function setHolderCost(uint256 _newCost) public onlyOwner {
1479         cost = _newCost;
1480     }
1481 
1482     function setPubCost(uint256 _newCost) public onlyOwner {
1483         pubCost = _newCost;
1484     }
1485 
1486     function activateHolderSale() external onlyOwner {
1487         !holderSaleActive ? holderSaleActive = true : holderSaleActive = false;
1488     }
1489 
1490     function activatePublicSale() external onlyOwner {
1491         !pubActive ? pubActive = true : pubActive = false;
1492     }
1493 
1494     function numberMinted(address owner) external view returns (uint256) {
1495         return _numberMinted(owner);
1496     }
1497 
1498     function setBaseURI(string calldata _baseURI, bool appendID) external onlyOwner {
1499         if (!appendedID && appendID) appendedID = appendID; 
1500         baseURI = _baseURI;
1501     }
1502 
1503     function tokenURI(uint256 _tokenId)
1504         public
1505         view
1506         virtual
1507         override
1508         returns (string memory)
1509     {
1510         require(_exists(_tokenId), "Cannot query non-existent token");
1511         if (appendedID) {
1512         return string(abi.encodePacked(baseURI, _tokenId.toString()));
1513         } else {
1514             return baseURI;
1515         }
1516     }
1517 
1518     function withdraw() public payable onlyOwner {
1519         (bool success, ) = payable(msg.sender).call{
1520             value: address(this).balance
1521         }("");
1522         require(success);
1523     }
1524 
1525     function withdrawAny(uint256 _amount) public payable onlyOwner {
1526         (bool success, ) = payable(msg.sender).call{value: _amount}("");
1527         require(success);
1528     }
1529 }