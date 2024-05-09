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
713 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
714 
715 
716 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
717 
718 pragma solidity ^0.8.0;
719 
720 
721 /**
722  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
723  * @dev See https://eips.ethereum.org/EIPS/eip-721
724  */
725 interface IERC721Enumerable is IERC721 {
726     /**
727      * @dev Returns the total amount of tokens stored by the contract.
728      */
729     function totalSupply() external view returns (uint256);
730 
731     /**
732      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
733      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
734      */
735     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
736 
737     /**
738      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
739      * Use along with {totalSupply} to enumerate all tokens.
740      */
741     function tokenByIndex(uint256 index) external view returns (uint256);
742 }
743 
744 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
745 
746 
747 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 
752 /**
753  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
754  * @dev See https://eips.ethereum.org/EIPS/eip-721
755  */
756 interface IERC721Metadata is IERC721 {
757     /**
758      * @dev Returns the token collection name.
759      */
760     function name() external view returns (string memory);
761 
762     /**
763      * @dev Returns the token collection symbol.
764      */
765     function symbol() external view returns (string memory);
766 
767     /**
768      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
769      */
770     function tokenURI(uint256 tokenId) external view returns (string memory);
771 }
772 
773 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
774 
775 
776 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
777 
778 pragma solidity ^0.8.0;
779 
780 
781 
782 
783 
784 
785 
786 
787 /**
788  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
789  * the Metadata extension, but not including the Enumerable extension, which is available separately as
790  * {ERC721Enumerable}.
791  */
792 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
793     using Address for address;
794     using Strings for uint256;
795 
796     // Token name
797     string private _name;
798 
799     // Token symbol
800     string private _symbol;
801 
802     // Mapping from token ID to owner address
803     mapping(uint256 => address) private _owners;
804 
805     // Mapping owner address to token count
806     mapping(address => uint256) private _balances;
807 
808     // Mapping from token ID to approved address
809     mapping(uint256 => address) private _tokenApprovals;
810 
811     // Mapping from owner to operator approvals
812     mapping(address => mapping(address => bool)) private _operatorApprovals;
813 
814     /**
815      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
816      */
817     constructor(string memory name_, string memory symbol_) {
818         _name = name_;
819         _symbol = symbol_;
820     }
821 
822     /**
823      * @dev See {IERC165-supportsInterface}.
824      */
825     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
826         return
827             interfaceId == type(IERC721).interfaceId ||
828             interfaceId == type(IERC721Metadata).interfaceId ||
829             super.supportsInterface(interfaceId);
830     }
831 
832     /**
833      * @dev See {IERC721-balanceOf}.
834      */
835     function balanceOf(address owner) public view virtual override returns (uint256) {
836         require(owner != address(0), "ERC721: address zero is not a valid owner");
837         return _balances[owner];
838     }
839 
840     /**
841      * @dev See {IERC721-ownerOf}.
842      */
843     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
844         address owner = _owners[tokenId];
845         require(owner != address(0), "ERC721: invalid token ID");
846         return owner;
847     }
848 
849     /**
850      * @dev See {IERC721Metadata-name}.
851      */
852     function name() public view virtual override returns (string memory) {
853         return _name;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-symbol}.
858      */
859     function symbol() public view virtual override returns (string memory) {
860         return _symbol;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-tokenURI}.
865      */
866     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
867         _requireMinted(tokenId);
868 
869         string memory baseURI = _baseURI();
870         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
871     }
872 
873     /**
874      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
875      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
876      * by default, can be overridden in child contracts.
877      */
878     function _baseURI() internal view virtual returns (string memory) {
879         return "";
880     }
881 
882     /**
883      * @dev See {IERC721-approve}.
884      */
885     function approve(address to, uint256 tokenId) public virtual override {
886         address owner = ERC721.ownerOf(tokenId);
887         require(to != owner, "ERC721: approval to current owner");
888 
889         require(
890             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
891             "ERC721: approve caller is not token owner nor approved for all"
892         );
893 
894         _approve(to, tokenId);
895     }
896 
897     /**
898      * @dev See {IERC721-getApproved}.
899      */
900     function getApproved(uint256 tokenId) public view virtual override returns (address) {
901         _requireMinted(tokenId);
902 
903         return _tokenApprovals[tokenId];
904     }
905 
906     /**
907      * @dev See {IERC721-setApprovalForAll}.
908      */
909     function setApprovalForAll(address operator, bool approved) public virtual override {
910         _setApprovalForAll(_msgSender(), operator, approved);
911     }
912 
913     /**
914      * @dev See {IERC721-isApprovedForAll}.
915      */
916     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
917         return _operatorApprovals[owner][operator];
918     }
919 
920     /**
921      * @dev See {IERC721-transferFrom}.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 tokenId
927     ) public virtual override {
928         //solhint-disable-next-line max-line-length
929         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
930 
931         _transfer(from, to, tokenId);
932     }
933 
934     /**
935      * @dev See {IERC721-safeTransferFrom}.
936      */
937     function safeTransferFrom(
938         address from,
939         address to,
940         uint256 tokenId
941     ) public virtual override {
942         safeTransferFrom(from, to, tokenId, "");
943     }
944 
945     /**
946      * @dev See {IERC721-safeTransferFrom}.
947      */
948     function safeTransferFrom(
949         address from,
950         address to,
951         uint256 tokenId,
952         bytes memory data
953     ) public virtual override {
954         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
955         _safeTransfer(from, to, tokenId, data);
956     }
957 
958     /**
959      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
960      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
961      *
962      * `data` is additional data, it has no specified format and it is sent in call to `to`.
963      *
964      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
965      * implement alternative mechanisms to perform token transfer, such as signature-based.
966      *
967      * Requirements:
968      *
969      * - `from` cannot be the zero address.
970      * - `to` cannot be the zero address.
971      * - `tokenId` token must exist and be owned by `from`.
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _safeTransfer(
977         address from,
978         address to,
979         uint256 tokenId,
980         bytes memory data
981     ) internal virtual {
982         _transfer(from, to, tokenId);
983         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
984     }
985 
986     /**
987      * @dev Returns whether `tokenId` exists.
988      *
989      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
990      *
991      * Tokens start existing when they are minted (`_mint`),
992      * and stop existing when they are burned (`_burn`).
993      */
994     function _exists(uint256 tokenId) internal view virtual returns (bool) {
995         return _owners[tokenId] != address(0);
996     }
997 
998     /**
999      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must exist.
1004      */
1005     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1006         address owner = ERC721.ownerOf(tokenId);
1007         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1008     }
1009 
1010     /**
1011      * @dev Safely mints `tokenId` and transfers it to `to`.
1012      *
1013      * Requirements:
1014      *
1015      * - `tokenId` must not exist.
1016      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1017      *
1018      * Emits a {Transfer} event.
1019      */
1020     function _safeMint(address to, uint256 tokenId) internal virtual {
1021         _safeMint(to, tokenId, "");
1022     }
1023 
1024     /**
1025      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1026      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1027      */
1028     function _safeMint(
1029         address to,
1030         uint256 tokenId,
1031         bytes memory data
1032     ) internal virtual {
1033         _mint(to, tokenId);
1034         require(
1035             _checkOnERC721Received(address(0), to, tokenId, data),
1036             "ERC721: transfer to non ERC721Receiver implementer"
1037         );
1038     }
1039 
1040     /**
1041      * @dev Mints `tokenId` and transfers it to `to`.
1042      *
1043      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1044      *
1045      * Requirements:
1046      *
1047      * - `tokenId` must not exist.
1048      * - `to` cannot be the zero address.
1049      *
1050      * Emits a {Transfer} event.
1051      */
1052     function _mint(address to, uint256 tokenId) internal virtual {
1053         require(to != address(0), "ERC721: mint to the zero address");
1054         require(!_exists(tokenId), "ERC721: token already minted");
1055 
1056         _beforeTokenTransfer(address(0), to, tokenId);
1057 
1058         _balances[to] += 1;
1059         _owners[tokenId] = to;
1060 
1061         emit Transfer(address(0), to, tokenId);
1062 
1063         _afterTokenTransfer(address(0), to, tokenId);
1064     }
1065 
1066     /**
1067      * @dev Destroys `tokenId`.
1068      * The approval is cleared when the token is burned.
1069      *
1070      * Requirements:
1071      *
1072      * - `tokenId` must exist.
1073      *
1074      * Emits a {Transfer} event.
1075      */
1076     function _burn(uint256 tokenId) internal virtual {
1077         address owner = ERC721.ownerOf(tokenId);
1078 
1079         _beforeTokenTransfer(owner, address(0), tokenId);
1080 
1081         // Clear approvals
1082         _approve(address(0), tokenId);
1083 
1084         _balances[owner] -= 1;
1085         delete _owners[tokenId];
1086 
1087         emit Transfer(owner, address(0), tokenId);
1088 
1089         _afterTokenTransfer(owner, address(0), tokenId);
1090     }
1091 
1092     /**
1093      * @dev Transfers `tokenId` from `from` to `to`.
1094      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1095      *
1096      * Requirements:
1097      *
1098      * - `to` cannot be the zero address.
1099      * - `tokenId` token must be owned by `from`.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _transfer(
1104         address from,
1105         address to,
1106         uint256 tokenId
1107     ) internal virtual {
1108         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1109         require(to != address(0), "ERC721: transfer to the zero address");
1110 
1111         _beforeTokenTransfer(from, to, tokenId);
1112 
1113         // Clear approvals from the previous owner
1114         _approve(address(0), tokenId);
1115 
1116         _balances[from] -= 1;
1117         _balances[to] += 1;
1118         _owners[tokenId] = to;
1119 
1120         emit Transfer(from, to, tokenId);
1121 
1122         _afterTokenTransfer(from, to, tokenId);
1123     }
1124 
1125     /**
1126      * @dev Approve `to` to operate on `tokenId`
1127      *
1128      * Emits an {Approval} event.
1129      */
1130     function _approve(address to, uint256 tokenId) internal virtual {
1131         _tokenApprovals[tokenId] = to;
1132         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1133     }
1134 
1135     /**
1136      * @dev Approve `operator` to operate on all of `owner` tokens
1137      *
1138      * Emits an {ApprovalForAll} event.
1139      */
1140     function _setApprovalForAll(
1141         address owner,
1142         address operator,
1143         bool approved
1144     ) internal virtual {
1145         require(owner != operator, "ERC721: approve to caller");
1146         _operatorApprovals[owner][operator] = approved;
1147         emit ApprovalForAll(owner, operator, approved);
1148     }
1149 
1150     /**
1151      * @dev Reverts if the `tokenId` has not been minted yet.
1152      */
1153     function _requireMinted(uint256 tokenId) internal view virtual {
1154         require(_exists(tokenId), "ERC721: invalid token ID");
1155     }
1156 
1157     /**
1158      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1159      * The call is not executed if the target address is not a contract.
1160      *
1161      * @param from address representing the previous owner of the given token ID
1162      * @param to target address that will receive the tokens
1163      * @param tokenId uint256 ID of the token to be transferred
1164      * @param data bytes optional data to send along with the call
1165      * @return bool whether the call correctly returned the expected magic value
1166      */
1167     function _checkOnERC721Received(
1168         address from,
1169         address to,
1170         uint256 tokenId,
1171         bytes memory data
1172     ) private returns (bool) {
1173         if (to.isContract()) {
1174             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1175                 return retval == IERC721Receiver.onERC721Received.selector;
1176             } catch (bytes memory reason) {
1177                 if (reason.length == 0) {
1178                     revert("ERC721: transfer to non ERC721Receiver implementer");
1179                 } else {
1180                     /// @solidity memory-safe-assembly
1181                     assembly {
1182                         revert(add(32, reason), mload(reason))
1183                     }
1184                 }
1185             }
1186         } else {
1187             return true;
1188         }
1189     }
1190 
1191     /**
1192      * @dev Hook that is called before any token transfer. This includes minting
1193      * and burning.
1194      *
1195      * Calling conditions:
1196      *
1197      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1198      * transferred to `to`.
1199      * - When `from` is zero, `tokenId` will be minted for `to`.
1200      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1201      * - `from` and `to` are never both zero.
1202      *
1203      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1204      */
1205     function _beforeTokenTransfer(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) internal virtual {}
1210 
1211     /**
1212      * @dev Hook that is called after any transfer of tokens. This includes
1213      * minting and burning.
1214      *
1215      * Calling conditions:
1216      *
1217      * - when `from` and `to` are both non-zero.
1218      * - `from` and `to` are never both zero.
1219      *
1220      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1221      */
1222     function _afterTokenTransfer(
1223         address from,
1224         address to,
1225         uint256 tokenId
1226     ) internal virtual {}
1227 }
1228 
1229 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1230 
1231 
1232 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1233 
1234 pragma solidity ^0.8.0;
1235 
1236 
1237 
1238 /**
1239  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1240  * enumerability of all the token ids in the contract as well as all token ids owned by each
1241  * account.
1242  */
1243 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1244     // Mapping from owner to list of owned token IDs
1245     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1246 
1247     // Mapping from token ID to index of the owner tokens list
1248     mapping(uint256 => uint256) private _ownedTokensIndex;
1249 
1250     // Array with all token ids, used for enumeration
1251     uint256[] private _allTokens;
1252 
1253     // Mapping from token id to position in the allTokens array
1254     mapping(uint256 => uint256) private _allTokensIndex;
1255 
1256     /**
1257      * @dev See {IERC165-supportsInterface}.
1258      */
1259     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1260         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1265      */
1266     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1267         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1268         return _ownedTokens[owner][index];
1269     }
1270 
1271     /**
1272      * @dev See {IERC721Enumerable-totalSupply}.
1273      */
1274     function totalSupply() public view virtual override returns (uint256) {
1275         return _allTokens.length;
1276     }
1277 
1278     /**
1279      * @dev See {IERC721Enumerable-tokenByIndex}.
1280      */
1281     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1282         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1283         return _allTokens[index];
1284     }
1285 
1286     /**
1287      * @dev Hook that is called before any token transfer. This includes minting
1288      * and burning.
1289      *
1290      * Calling conditions:
1291      *
1292      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1293      * transferred to `to`.
1294      * - When `from` is zero, `tokenId` will be minted for `to`.
1295      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1296      * - `from` cannot be the zero address.
1297      * - `to` cannot be the zero address.
1298      *
1299      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1300      */
1301     function _beforeTokenTransfer(
1302         address from,
1303         address to,
1304         uint256 tokenId
1305     ) internal virtual override {
1306         super._beforeTokenTransfer(from, to, tokenId);
1307 
1308         if (from == address(0)) {
1309             _addTokenToAllTokensEnumeration(tokenId);
1310         } else if (from != to) {
1311             _removeTokenFromOwnerEnumeration(from, tokenId);
1312         }
1313         if (to == address(0)) {
1314             _removeTokenFromAllTokensEnumeration(tokenId);
1315         } else if (to != from) {
1316             _addTokenToOwnerEnumeration(to, tokenId);
1317         }
1318     }
1319 
1320     /**
1321      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1322      * @param to address representing the new owner of the given token ID
1323      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1324      */
1325     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1326         uint256 length = ERC721.balanceOf(to);
1327         _ownedTokens[to][length] = tokenId;
1328         _ownedTokensIndex[tokenId] = length;
1329     }
1330 
1331     /**
1332      * @dev Private function to add a token to this extension's token tracking data structures.
1333      * @param tokenId uint256 ID of the token to be added to the tokens list
1334      */
1335     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1336         _allTokensIndex[tokenId] = _allTokens.length;
1337         _allTokens.push(tokenId);
1338     }
1339 
1340     /**
1341      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1342      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1343      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1344      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1345      * @param from address representing the previous owner of the given token ID
1346      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1347      */
1348     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1349         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1350         // then delete the last slot (swap and pop).
1351 
1352         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1353         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1354 
1355         // When the token to delete is the last token, the swap operation is unnecessary
1356         if (tokenIndex != lastTokenIndex) {
1357             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1358 
1359             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1360             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1361         }
1362 
1363         // This also deletes the contents at the last position of the array
1364         delete _ownedTokensIndex[tokenId];
1365         delete _ownedTokens[from][lastTokenIndex];
1366     }
1367 
1368     /**
1369      * @dev Private function to remove a token from this extension's token tracking data structures.
1370      * This has O(1) time complexity, but alters the order of the _allTokens array.
1371      * @param tokenId uint256 ID of the token to be removed from the tokens list
1372      */
1373     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1374         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1375         // then delete the last slot (swap and pop).
1376 
1377         uint256 lastTokenIndex = _allTokens.length - 1;
1378         uint256 tokenIndex = _allTokensIndex[tokenId];
1379 
1380         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1381         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1382         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1383         uint256 lastTokenId = _allTokens[lastTokenIndex];
1384 
1385         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1386         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1387 
1388         // This also deletes the contents at the last position of the array
1389         delete _allTokensIndex[tokenId];
1390         _allTokens.pop();
1391     }
1392 }
1393 
1394 // File: contracts/banner.sol
1395 
1396 // Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
1397 
1398 pragma solidity ^0.8.0;
1399 
1400 
1401 
1402 
1403 
1404 
1405 contract Banner is ERC721Enumerable, Ownable {
1406     using Strings for uint256;
1407 
1408     bool public _isSaleActive = false;
1409     bool public _isPublicSaleActive = false;
1410     bool public _revealed = false;
1411 
1412     // Constants
1413     uint256 public constant MAX_SUPPLY = 1000;
1414     uint256 public mintPrice = 0 ether;
1415     uint256 public maxBalance = 1;
1416     uint256 public maxMint = 1;
1417 
1418     string baseURI;
1419     string public notRevealedUri;
1420     string public baseExtension = ".json";
1421 
1422     mapping(uint256 => string) private _tokenURIs;
1423     mapping(address => uint256) public walletMints;
1424 
1425     bytes32 public root;
1426 
1427 
1428     constructor(string memory initBaseURI, string memory initNotRevealedUri, bytes32 _root)
1429         ERC721("Underground Workshop Banner", "UWB")
1430     {
1431         setBaseURI(initBaseURI);
1432         setNotRevealedURI(initNotRevealedUri);
1433         root = _root;
1434 
1435     }
1436 
1437     function mintBanner(uint256 tokenQuantity, bytes32[] memory proof) public payable {
1438         
1439         require(isValid(proof, keccak256(abi.encodePacked(msg.sender))), "Not a part of Allowlist");
1440         require( totalSupply() + tokenQuantity <= MAX_SUPPLY, "Sale would exceed max supply");
1441         require(_isSaleActive, "Sale must be active to mint Banner");
1442         require(walletMints[msg.sender] + tokenQuantity <= maxMint, "Can only mint 1 tokens at a time");
1443 
1444         walletMints[msg.sender] += tokenQuantity;
1445         _mintBanner(tokenQuantity);
1446     }
1447 
1448         function mintPublicBanner(uint256 tokenQuantity) public payable {
1449         
1450         require( totalSupply() + tokenQuantity <= MAX_SUPPLY-100, "Sale would exceed max supply");
1451         require(_isPublicSaleActive, "Public sale must be active to mint Banner");
1452         require(walletMints[msg.sender] + tokenQuantity <= maxMint+1, "Can only mint up to 2 tokens");
1453         
1454 
1455         walletMints[msg.sender] += tokenQuantity;
1456         _mintBanner(tokenQuantity);
1457     }
1458 
1459     function mintMine(uint256 tokenQuantity) public payable onlyOwner {
1460         require( totalSupply() + tokenQuantity <= MAX_SUPPLY, "Sale would exceed max supply");
1461         _mintBanner(tokenQuantity);
1462     }
1463 
1464     function _mintBanner(uint256 tokenQuantity) internal {
1465         for (uint256 i = 0; i < tokenQuantity; i++) {
1466             uint256 mintIndex = totalSupply();
1467             if (totalSupply() < MAX_SUPPLY) {
1468                 _safeMint(msg.sender, mintIndex);
1469             }
1470         }
1471     }
1472 
1473     function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1474         return MerkleProof.verify(proof, root, leaf);
1475     }
1476 
1477     function tokenURI(uint256 tokenId)
1478         public
1479         view
1480         virtual
1481         override
1482         returns (string memory)
1483     {
1484         require(
1485             _exists(tokenId),
1486             "ERC721Metadata: URI query for nonexistent token"
1487         );
1488 
1489         if (_revealed == false) {
1490             return notRevealedUri;
1491         }
1492 
1493         string memory _tokenURI = _tokenURIs[tokenId];
1494         string memory base = _baseURI();
1495 
1496         // If there is no base URI, return the token URI.
1497         if (bytes(base).length == 0) {
1498             return _tokenURI;
1499         }
1500         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1501         if (bytes(_tokenURI).length > 0) {
1502             return string(abi.encodePacked(base, _tokenURI));
1503         }
1504         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1505         return
1506             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
1507     }
1508 
1509     // internal
1510     function _baseURI() internal view virtual override returns (string memory) {
1511         return baseURI;
1512     }
1513 
1514     //only owner
1515     function flipSaleActive() public onlyOwner {
1516         _isSaleActive = !_isSaleActive;
1517     }
1518 
1519     function flipPublicSaleActive() public onlyOwner {
1520         _isPublicSaleActive = !_isPublicSaleActive;
1521         _isSaleActive = !_isSaleActive;
1522     }
1523 
1524     function flipReveal() public onlyOwner {
1525         _revealed = !_revealed;
1526     }
1527 
1528     function setMintPrice(uint256 _mintPrice) public onlyOwner {
1529         mintPrice = _mintPrice;
1530     }
1531 
1532     function setRoot(bytes32 _root) public onlyOwner {
1533         root = _root;
1534     }
1535 
1536     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1537         notRevealedUri = _notRevealedURI;
1538     }
1539 
1540     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1541         baseURI = _newBaseURI;
1542     }
1543 
1544     function setBaseExtension(string memory _newBaseExtension)
1545         public
1546         onlyOwner
1547     {
1548         baseExtension = _newBaseExtension;
1549     }
1550 
1551     function setMaxBalance(uint256 _maxBalance) public onlyOwner {
1552         maxBalance = _maxBalance;
1553     }
1554 
1555     function setMaxMint(uint256 _maxMint) public onlyOwner {
1556         maxMint = _maxMint;
1557     }
1558 
1559     function withdraw(address to) public onlyOwner {
1560         uint256 balance = address(this).balance;
1561         payable(to).transfer(balance);
1562     }
1563 
1564     function getMyWalletMints() public view returns (uint256) {
1565         return walletMints[msg.sender];
1566     }
1567 }