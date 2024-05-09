1 // File: contracts/alloutwar_character.sol
2 
3 /**
4  *Submitted for verification at Etherscan.io on 2022-09-10
5 */
6 
7 // File: @openzeppelin/contracts/utils/Address.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
11 
12 pragma solidity ^0.8.1;
13 
14 /**
15  * @dev Collection of functions related to the address type
16  */
17 library Address {
18     /**
19      * @dev Returns true if `account` is a contract.
20      *
21      * [IMPORTANT]
22      * ====
23      * It is unsafe to assume that an address for which this function returns
24      * false is an externally-owned account (EOA) and not a contract.
25      *
26      * Among others, `isContract` will return false for the following
27      * types of addresses:
28      *
29      *  - an externally-owned account
30      *  - a contract in construction
31      *  - an address where a contract will be created
32      *  - an address where a contract lived, but was destroyed
33      * ====
34      *
35      * [IMPORTANT]
36      * ====
37      * You shouldn't rely on `isContract` to protect against flash loan attacks!
38      *
39      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
40      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
41      * constructor.
42      * ====
43      */
44     function isContract(address account) internal view returns (bool) {
45         // This method relies on extcodesize/address.code.length, which returns 0
46         // for contracts in construction, since the code is only stored at the end
47         // of the constructor execution.
48 
49         return account.code.length > 0;
50     }
51 
52     /**
53      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
54      * `recipient`, forwarding all available gas and reverting on errors.
55      *
56      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
57      * of certain opcodes, possibly making contracts go over the 2300 gas limit
58      * imposed by `transfer`, making them unable to receive funds via
59      * `transfer`. {sendValue} removes this limitation.
60      *
61      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
62      *
63      * IMPORTANT: because control is transferred to `recipient`, care must be
64      * taken to not create reentrancy vulnerabilities. Consider using
65      * {ReentrancyGuard} or the
66      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
67      */
68     function sendValue(address payable recipient, uint256 amount) internal {
69         require(address(this).balance >= amount, "Address: insufficient balance");
70 
71         (bool success, ) = recipient.call{value: amount}("");
72         require(success, "Address: unable to send value, recipient may have reverted");
73     }
74 
75     /**
76      * @dev Performs a Solidity function call using a low level `call`. A
77      * plain `call` is an unsafe replacement for a function call: use this
78      * function instead.
79      *
80      * If `target` reverts with a revert reason, it is bubbled up by this
81      * function (like regular Solidity function calls).
82      *
83      * Returns the raw returned data. To convert to the expected return value,
84      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
85      *
86      * Requirements:
87      *
88      * - `target` must be a contract.
89      * - calling `target` with `data` must not revert.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
94         return functionCall(target, data, "Address: low-level call failed");
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
99      * `errorMessage` as a fallback revert reason when `target` reverts.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(
104         address target,
105         bytes memory data,
106         string memory errorMessage
107     ) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, 0, errorMessage);
109     }
110 
111     /**
112      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
113      * but also transferring `value` wei to `target`.
114      *
115      * Requirements:
116      *
117      * - the calling contract must have an ETH balance of at least `value`.
118      * - the called Solidity function must be `payable`.
119      *
120      * _Available since v3.1._
121      */
122     function functionCallWithValue(
123         address target,
124         bytes memory data,
125         uint256 value
126     ) internal returns (bytes memory) {
127         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
128     }
129 
130     /**
131      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
132      * with `errorMessage` as a fallback revert reason when `target` reverts.
133      *
134      * _Available since v3.1._
135      */
136     function functionCallWithValue(
137         address target,
138         bytes memory data,
139         uint256 value,
140         string memory errorMessage
141     ) internal returns (bytes memory) {
142         require(address(this).balance >= value, "Address: insufficient balance for call");
143         require(isContract(target), "Address: call to non-contract");
144 
145         (bool success, bytes memory returndata) = target.call{value: value}(data);
146         return verifyCallResult(success, returndata, errorMessage);
147     }
148 
149     /**
150      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
151      * but performing a static call.
152      *
153      * _Available since v3.3._
154      */
155     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
156         return functionStaticCall(target, data, "Address: low-level static call failed");
157     }
158 
159     /**
160      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
161      * but performing a static call.
162      *
163      * _Available since v3.3._
164      */
165     function functionStaticCall(
166         address target,
167         bytes memory data,
168         string memory errorMessage
169     ) internal view returns (bytes memory) {
170         require(isContract(target), "Address: static call to non-contract");
171 
172         (bool success, bytes memory returndata) = target.staticcall(data);
173         return verifyCallResult(success, returndata, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
183         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
188      * but performing a delegate call.
189      *
190      * _Available since v3.4._
191      */
192     function functionDelegateCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         require(isContract(target), "Address: delegate call to non-contract");
198 
199         (bool success, bytes memory returndata) = target.delegatecall(data);
200         return verifyCallResult(success, returndata, errorMessage);
201     }
202 
203     /**
204      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
205      * revert reason using the provided one.
206      *
207      * _Available since v4.3._
208      */
209     function verifyCallResult(
210         bool success,
211         bytes memory returndata,
212         string memory errorMessage
213     ) internal pure returns (bytes memory) {
214         if (success) {
215             return returndata;
216         } else {
217             // Look for revert reason and bubble it up if present
218             if (returndata.length > 0) {
219                 // The easiest way to bubble the revert reason is using memory via assembly
220                 /// @solidity memory-safe-assembly
221                 assembly {
222                     let returndata_size := mload(returndata)
223                     revert(add(32, returndata), returndata_size)
224                 }
225             } else {
226                 revert(errorMessage);
227             }
228         }
229     }
230 }
231 
232 // File: @openzeppelin/contracts/utils/Context.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 /**
240  * @dev Provides information about the current execution context, including the
241  * sender of the transaction and its data. While these are generally available
242  * via msg.sender and msg.data, they should not be accessed in such a direct
243  * manner, since when dealing with meta-transactions the account sending and
244  * paying for execution may not be the actual sender (as far as an application
245  * is concerned).
246  *
247  * This contract is only required for intermediate, library-like contracts.
248  */
249 abstract contract Context {
250     function _msgSender() internal view virtual returns (address) {
251         return msg.sender;
252     }
253 
254     function _msgData() internal view virtual returns (bytes calldata) {
255         return msg.data;
256     }
257 }
258 
259 // File: @openzeppelin/contracts/access/Ownable.sol
260 
261 
262 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 
267 /**
268  * @dev Contract module which provides a basic access control mechanism, where
269  * there is an account (an owner) that can be granted exclusive access to
270  * specific functions.
271  *
272  * By default, the owner account will be the one that deploys the contract. This
273  * can later be changed with {transferOwnership}.
274  *
275  * This module is used through inheritance. It will make available the modifier
276  * `onlyOwner`, which can be applied to your functions to restrict their use to
277  * the owner.
278  */
279 abstract contract Ownable is Context {
280     address private _owner;
281 
282     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
283 
284     /**
285      * @dev Initializes the contract setting the deployer as the initial owner.
286      */
287     constructor() {
288         _transferOwnership(_msgSender());
289     }
290 
291     /**
292      * @dev Throws if called by any account other than the owner.
293      */
294     modifier onlyOwner() {
295         _checkOwner();
296         _;
297     }
298 
299     /**
300      * @dev Returns the address of the current owner.
301      */
302     function owner() public view virtual returns (address) {
303         return _owner;
304     }
305 
306     /**
307      * @dev Throws if the sender is not the owner.
308      */
309     function _checkOwner() internal view virtual {
310         require(owner() == _msgSender(), "Ownable: caller is not the owner");
311     }
312 
313     /**
314      * @dev Leaves the contract without owner. It will not be possible to call
315      * `onlyOwner` functions anymore. Can only be called by the current owner.
316      *
317      * NOTE: Renouncing ownership will leave the contract without an owner,
318      * thereby removing any functionality that is only available to the owner.
319      */
320     function renounceOwnership() public virtual onlyOwner {
321         _transferOwnership(address(0));
322     }
323 
324     /**
325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
326      * Can only be called by the current owner.
327      */
328     function transferOwnership(address newOwner) public virtual onlyOwner {
329         require(newOwner != address(0), "Ownable: new owner is the zero address");
330         _transferOwnership(newOwner);
331     }
332 
333     /**
334      * @dev Transfers ownership of the contract to a new account (`newOwner`).
335      * Internal function without access restriction.
336      */
337     function _transferOwnership(address newOwner) internal virtual {
338         address oldOwner = _owner;
339         _owner = newOwner;
340         emit OwnershipTransferred(oldOwner, newOwner);
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Strings.sol
345 
346 
347 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev String operations.
353  */
354 library Strings {
355     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
356     uint8 private constant _ADDRESS_LENGTH = 20;
357 
358     /**
359      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
360      */
361     function toString(uint256 value) internal pure returns (string memory) {
362         // Inspired by OraclizeAPI's implementation - MIT licence
363         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
364 
365         if (value == 0) {
366             return "0";
367         }
368         uint256 temp = value;
369         uint256 digits;
370         while (temp != 0) {
371             digits++;
372             temp /= 10;
373         }
374         bytes memory buffer = new bytes(digits);
375         while (value != 0) {
376             digits -= 1;
377             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
378             value /= 10;
379         }
380         return string(buffer);
381     }
382 
383     /**
384      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
385      */
386     function toHexString(uint256 value) internal pure returns (string memory) {
387         if (value == 0) {
388             return "0x00";
389         }
390         uint256 temp = value;
391         uint256 length = 0;
392         while (temp != 0) {
393             length++;
394             temp >>= 8;
395         }
396         return toHexString(value, length);
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
401      */
402     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
403         bytes memory buffer = new bytes(2 * length + 2);
404         buffer[0] = "0";
405         buffer[1] = "x";
406         for (uint256 i = 2 * length + 1; i > 1; --i) {
407             buffer[i] = _HEX_SYMBOLS[value & 0xf];
408             value >>= 4;
409         }
410         require(value == 0, "Strings: hex length insufficient");
411         return string(buffer);
412     }
413 
414     /**
415      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
416      */
417     function toHexString(address addr) internal pure returns (string memory) {
418         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
419     }
420 }
421 
422 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
423 
424 
425 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
426 
427 pragma solidity ^0.8.0;
428 
429 /**
430  * @title ERC721 token receiver interface
431  * @dev Interface for any contract that wants to support safeTransfers
432  * from ERC721 asset contracts.
433  */
434 interface IERC721Receiver {
435     /**
436      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
437      * by `operator` from `from`, this function is called.
438      *
439      * It must return its Solidity selector to confirm the token transfer.
440      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
441      *
442      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
443      */
444     function onERC721Received(
445         address operator,
446         address from,
447         uint256 tokenId,
448         bytes calldata data
449     ) external returns (bytes4);
450 }
451 
452 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
453 
454 
455 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
456 
457 pragma solidity ^0.8.0;
458 
459 /**
460  * @dev Interface of the ERC165 standard, as defined in the
461  * https://eips.ethereum.org/EIPS/eip-165[EIP].
462  *
463  * Implementers can declare support of contract interfaces, which can then be
464  * queried by others ({ERC165Checker}).
465  *
466  * For an implementation, see {ERC165}.
467  */
468 interface IERC165 {
469     /**
470      * @dev Returns true if this contract implements the interface defined by
471      * `interfaceId`. See the corresponding
472      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
473      * to learn more about how these ids are created.
474      *
475      * This function call must use less than 30 000 gas.
476      */
477     function supportsInterface(bytes4 interfaceId) external view returns (bool);
478 }
479 
480 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
481 
482 
483 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
484 
485 pragma solidity ^0.8.0;
486 
487 
488 /**
489  * @dev Implementation of the {IERC165} interface.
490  *
491  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
492  * for the additional interface id that will be supported. For example:
493  *
494  * ```solidity
495  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
496  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
497  * }
498  * ```
499  *
500  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
501  */
502 abstract contract ERC165 is IERC165 {
503     /**
504      * @dev See {IERC165-supportsInterface}.
505      */
506     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
507         return interfaceId == type(IERC165).interfaceId;
508     }
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
512 
513 
514 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
515 
516 pragma solidity ^0.8.0;
517 
518 
519 /**
520  * @dev Required interface of an ERC721 compliant contract.
521  */
522 interface IERC721 is IERC165 {
523     /**
524      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
525      */
526     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
527 
528     /**
529      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
530      */
531     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
532 
533     /**
534      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
535      */
536     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
537 
538     /**
539      * @dev Returns the number of tokens in ``owner``'s account.
540      */
541     function balanceOf(address owner) external view returns (uint256 balance);
542 
543     /**
544      * @dev Returns the owner of the `tokenId` token.
545      *
546      * Requirements:
547      *
548      * - `tokenId` must exist.
549      */
550     function ownerOf(uint256 tokenId) external view returns (address owner);
551 
552     /**
553      * @dev Safely transfers `tokenId` token from `from` to `to`.
554      *
555      * Requirements:
556      *
557      * - `from` cannot be the zero address.
558      * - `to` cannot be the zero address.
559      * - `tokenId` token must exist and be owned by `from`.
560      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
561      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
562      *
563      * Emits a {Transfer} event.
564      */
565     function safeTransferFrom(
566         address from,
567         address to,
568         uint256 tokenId,
569         bytes calldata data
570     ) external;
571 
572     /**
573      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
574      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
575      *
576      * Requirements:
577      *
578      * - `from` cannot be the zero address.
579      * - `to` cannot be the zero address.
580      * - `tokenId` token must exist and be owned by `from`.
581      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
582      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
583      *
584      * Emits a {Transfer} event.
585      */
586     function safeTransferFrom(
587         address from,
588         address to,
589         uint256 tokenId
590     ) external;
591 
592     /**
593      * @dev Transfers `tokenId` token from `from` to `to`.
594      *
595      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
596      *
597      * Requirements:
598      *
599      * - `from` cannot be the zero address.
600      * - `to` cannot be the zero address.
601      * - `tokenId` token must be owned by `from`.
602      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
603      *
604      * Emits a {Transfer} event.
605      */
606     function transferFrom(
607         address from,
608         address to,
609         uint256 tokenId
610     ) external;
611 
612     /**
613      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
614      * The approval is cleared when the token is transferred.
615      *
616      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
617      *
618      * Requirements:
619      *
620      * - The caller must own the token or be an approved operator.
621      * - `tokenId` must exist.
622      *
623      * Emits an {Approval} event.
624      */
625     function approve(address to, uint256 tokenId) external;
626 
627     /**
628      * @dev Approve or remove `operator` as an operator for the caller.
629      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
630      *
631      * Requirements:
632      *
633      * - The `operator` cannot be the caller.
634      *
635      * Emits an {ApprovalForAll} event.
636      */
637     function setApprovalForAll(address operator, bool _approved) external;
638 
639     /**
640      * @dev Returns the account approved for `tokenId` token.
641      *
642      * Requirements:
643      *
644      * - `tokenId` must exist.
645      */
646     function getApproved(uint256 tokenId) external view returns (address operator);
647 
648     /**
649      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
650      *
651      * See {setApprovalForAll}
652      */
653     function isApprovedForAll(address owner, address operator) external view returns (bool);
654 }
655 
656 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
657 
658 
659 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
660 
661 pragma solidity ^0.8.0;
662 
663 
664 /**
665  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
666  * @dev See https://eips.ethereum.org/EIPS/eip-721
667  */
668 interface IERC721Metadata is IERC721 {
669     /**
670      * @dev Returns the token collection name.
671      */
672     function name() external view returns (string memory);
673 
674     /**
675      * @dev Returns the token collection symbol.
676      */
677     function symbol() external view returns (string memory);
678 
679     /**
680      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
681      */
682     function tokenURI(uint256 tokenId) external view returns (string memory);
683 }
684 
685 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
686 
687 
688 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
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
707     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
708 
709     /**
710      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
711      * Use along with {totalSupply} to enumerate all tokens.
712      */
713     function tokenByIndex(uint256 index) external view returns (uint256);
714 }
715 
716 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
717 
718 
719 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
720 
721 pragma solidity ^0.8.0;
722 
723 /**
724  * @dev These functions deal with verification of Merkle Tree proofs.
725  *
726  * The proofs can be generated using the JavaScript library
727  * https://github.com/miguelmota/merkletreejs[merkletreejs].
728  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
729  *
730  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
731  *
732  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
733  * hashing, or use a hash function other than keccak256 for hashing leaves.
734  * This is because the concatenation of a sorted pair of internal nodes in
735  * the merkle tree could be reinterpreted as a leaf value.
736  */
737 library MerkleProof {
738     /**
739      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
740      * defined by `root`. For this, a `proof` must be provided, containing
741      * sibling hashes on the branch from the leaf to the root of the tree. Each
742      * pair of leaves and each pair of pre-images are assumed to be sorted.
743      */
744     function verify(
745         bytes32[] memory proof,
746         bytes32 root,
747         bytes32 leaf
748     ) internal pure returns (bool) {
749         return processProof(proof, leaf) == root;
750     }
751 
752     /**
753      * @dev Calldata version of {verify}
754      *
755      * _Available since v4.7._
756      */
757     function verifyCalldata(
758         bytes32[] calldata proof,
759         bytes32 root,
760         bytes32 leaf
761     ) internal pure returns (bool) {
762         return processProofCalldata(proof, leaf) == root;
763     }
764 
765     /**
766      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
767      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
768      * hash matches the root of the tree. When processing the proof, the pairs
769      * of leafs & pre-images are assumed to be sorted.
770      *
771      * _Available since v4.4._
772      */
773     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
774         bytes32 computedHash = leaf;
775         for (uint256 i = 0; i < proof.length; i++) {
776             computedHash = _hashPair(computedHash, proof[i]);
777         }
778         return computedHash;
779     }
780 
781     /**
782      * @dev Calldata version of {processProof}
783      *
784      * _Available since v4.7._
785      */
786     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
787         bytes32 computedHash = leaf;
788         for (uint256 i = 0; i < proof.length; i++) {
789             computedHash = _hashPair(computedHash, proof[i]);
790         }
791         return computedHash;
792     }
793 
794     /**
795      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
796      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
797      *
798      * _Available since v4.7._
799      */
800     function multiProofVerify(
801         bytes32[] memory proof,
802         bool[] memory proofFlags,
803         bytes32 root,
804         bytes32[] memory leaves
805     ) internal pure returns (bool) {
806         return processMultiProof(proof, proofFlags, leaves) == root;
807     }
808 
809     /**
810      * @dev Calldata version of {multiProofVerify}
811      *
812      * _Available since v4.7._
813      */
814     function multiProofVerifyCalldata(
815         bytes32[] calldata proof,
816         bool[] calldata proofFlags,
817         bytes32 root,
818         bytes32[] memory leaves
819     ) internal pure returns (bool) {
820         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
821     }
822 
823     /**
824      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
825      * consuming from one or the other at each step according to the instructions given by
826      * `proofFlags`.
827      *
828      * _Available since v4.7._
829      */
830     function processMultiProof(
831         bytes32[] memory proof,
832         bool[] memory proofFlags,
833         bytes32[] memory leaves
834     ) internal pure returns (bytes32 merkleRoot) {
835         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
836         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
837         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
838         // the merkle tree.
839         uint256 leavesLen = leaves.length;
840         uint256 totalHashes = proofFlags.length;
841 
842         // Check proof validity.
843         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
844 
845         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
846         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
847         bytes32[] memory hashes = new bytes32[](totalHashes);
848         uint256 leafPos = 0;
849         uint256 hashPos = 0;
850         uint256 proofPos = 0;
851         // At each step, we compute the next hash using two values:
852         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
853         //   get the next hash.
854         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
855         //   `proof` array.
856         for (uint256 i = 0; i < totalHashes; i++) {
857             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
858             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
859             hashes[i] = _hashPair(a, b);
860         }
861 
862         if (totalHashes > 0) {
863             return hashes[totalHashes - 1];
864         } else if (leavesLen > 0) {
865             return leaves[0];
866         } else {
867             return proof[0];
868         }
869     }
870 
871     /**
872      * @dev Calldata version of {processMultiProof}
873      *
874      * _Available since v4.7._
875      */
876     function processMultiProofCalldata(
877         bytes32[] calldata proof,
878         bool[] calldata proofFlags,
879         bytes32[] memory leaves
880     ) internal pure returns (bytes32 merkleRoot) {
881         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
882         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
883         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
884         // the merkle tree.
885         uint256 leavesLen = leaves.length;
886         uint256 totalHashes = proofFlags.length;
887 
888         // Check proof validity.
889         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
890 
891         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
892         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
893         bytes32[] memory hashes = new bytes32[](totalHashes);
894         uint256 leafPos = 0;
895         uint256 hashPos = 0;
896         uint256 proofPos = 0;
897         // At each step, we compute the next hash using two values:
898         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
899         //   get the next hash.
900         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
901         //   `proof` array.
902         for (uint256 i = 0; i < totalHashes; i++) {
903             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
904             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
905             hashes[i] = _hashPair(a, b);
906         }
907 
908         if (totalHashes > 0) {
909             return hashes[totalHashes - 1];
910         } else if (leavesLen > 0) {
911             return leaves[0];
912         } else {
913             return proof[0];
914         }
915     }
916 
917     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
918         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
919     }
920 
921     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
922         /// @solidity memory-safe-assembly
923         assembly {
924             mstore(0x00, a)
925             mstore(0x20, b)
926             value := keccak256(0x00, 0x40)
927         }
928     }
929 }
930 
931 // File: contracts/alloutwar_character.sol
932 
933 
934 //     _  _     _    _ _  ___        _ __        __         
935 //   _| || |_  / \  | | |/ _ \ _   _| |\ \      / /_ _ _ __ 
936 //  |_  ..  _|/ _ \ | | | | | | | | | __\ \ /\ / / _` | '__|
937 //  |_      _/ ___ \| | | |_| | |_| | |_ \ V  V / (_| | |   
938 //    |_||_|/_/   \_\_|_|\___/ \__,_|\__| \_/\_/ \__,_|_|   
939 
940 
941 
942 
943 
944 
945 
946 
947 
948 
949 
950 
951 
952 pragma solidity ^0.8.1;
953 
954 interface IERC20 {
955     /**
956      * @dev Emitted when `value` tokens are moved from one account (`from`) to
957      * another (`to`).
958      *
959      * Note that `value` may be zero.
960      */
961     event Transfer(address indexed from, address indexed to, uint256 value);
962 
963     /**
964      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
965      * a call to {approve}. `value` is the new allowance.
966      */
967     event Approval(address indexed owner, address indexed spender, uint256 value);
968 
969     /**
970      * @dev Returns the amount of tokens in existence.
971      */
972     function totalSupply() external view returns (uint256);
973 
974     /**
975      * @dev Returns the amount of tokens owned by `account`.
976      */
977     function balanceOf(address account) external view returns (uint256);
978 
979     /**
980      * @dev Moves `amount` tokens from the caller's account to `to`.
981      *
982      * Returns a boolean value indicating whether the operation succeeded.
983      *
984      * Emits a {Transfer} event.
985      */
986     function transfer(address to, uint256 amount) external returns (bool);
987 
988     /**
989      * @dev Returns the remaining number of tokens that `spender` will be
990      * allowed to spend on behalf of `owner` through {transferFrom}. This is
991      * zero by default.
992      *
993      * This value changes when {approve} or {transferFrom} are called.
994      */
995     function allowance(address owner, address spender) external view returns (uint256);
996 
997     /**
998      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
999      *
1000      * Returns a boolean value indicating whether the operation succeeded.
1001      *
1002      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1003      * that someone may use both the old and the new allowance by unfortunate
1004      * transaction ordering. One possible solution to mitigate this race
1005      * condition is to first reduce the spender's allowance to 0 and set the
1006      * desired value afterwards:
1007      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1008      *
1009      * Emits an {Approval} event.
1010      */
1011     function approve(address spender, uint256 amount) external returns (bool);
1012 
1013     /**
1014      * @dev Moves `amount` tokens from `from` to `to` using the
1015      * allowance mechanism. `amount` is then deducted from the caller's
1016      * allowance.
1017      *
1018      * Returns a boolean value indicating whether the operation succeeded.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function transferFrom(
1023         address from,
1024         address to,
1025         uint256 amount
1026     ) external returns (bool);
1027 }
1028 
1029 contract ERC721A is
1030     Context,
1031     ERC165,
1032     IERC721,
1033     IERC721Metadata,
1034     IERC721Enumerable
1035 {
1036     using Address for address;
1037     using Strings for uint256;
1038 
1039     struct TokenOwnership {
1040         address addr;
1041         uint64 startTimestamp;
1042     }
1043 
1044     struct AddressData {
1045         uint128 balance;
1046         uint128 numberMinted;
1047     }
1048 
1049     uint256 public currentIndex = 0;
1050 
1051     uint256 internal immutable collectionSize;
1052     uint256 internal immutable maxBatchSize;
1053 
1054     // Token name
1055     string private _name;
1056 
1057     // Token symbol
1058     string private _symbol;
1059 
1060     // Mapping from token ID to ownership details
1061     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1062     mapping(uint256 => TokenOwnership) private _ownerships;
1063 
1064     // Mapping owner address to address data
1065     mapping(address => AddressData) private _addressData;
1066 
1067     // Mapping from token ID to approved address
1068     mapping(uint256 => address) private _tokenApprovals;
1069 
1070     // Mapping from owner to operator approvals
1071     mapping(address => mapping(address => bool)) private _operatorApprovals;
1072 
1073     /**
1074      * @dev
1075      * `maxBatchSize` refers to how much a minter can mint at a time.
1076      * `collectionSize_` refers to how many tokens are in the collection.
1077      */
1078     constructor(
1079         string memory name_,
1080         string memory symbol_,
1081         uint256 maxBatchSize_,
1082         uint256 collectionSize_
1083     ) {
1084         require(
1085             collectionSize_ > 0,
1086             "ERC721A: collection must have a nonzero supply"
1087         );
1088         require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1089         _name = name_;
1090         _symbol = symbol_;
1091         maxBatchSize = maxBatchSize_;
1092         collectionSize = collectionSize_;
1093     }
1094 
1095     /**
1096      * @dev See {IERC721Enumerable-totalSupply}.
1097      */
1098     function totalSupply() public view override returns (uint256) {
1099         return currentIndex;
1100     }
1101 
1102     /**
1103      * @dev See {IERC721Enumerable-tokenByIndex}.
1104      */
1105     function tokenByIndex(uint256 index)
1106         public
1107         view
1108         override
1109         returns (uint256)
1110     {
1111         require(index < totalSupply(), "ERC721A: global index out of bounds");
1112         return index;
1113     }
1114 
1115 
1116     /**
1117      * @dev Destroys `tokenId`.
1118      * The approval is cleared when the token is burned.
1119      * This is an internal function that does not check if the sender is authorized to operate on the token.
1120      *
1121      * Requirements:
1122      *
1123      * - `tokenId` must exist.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function _burn(uint256 tokenId) public {
1128         address owner = ERC721A.ownerOf(tokenId);
1129 
1130         _beforeTokenTransfers(owner, address(0), tokenId, 1);
1131 
1132         
1133 
1134         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1135         owner = ERC721A.ownerOf(tokenId);
1136 
1137         // Clear approvals
1138         delete _tokenApprovals[tokenId];
1139 
1140         unchecked {
1141             // Cannot overflow, as that would require more tokens to be burned/transferred
1142             // out than the owner initially received through minting and transferring in.
1143             _addressData[owner].balance -= 1;
1144         }
1145         delete _ownerships[tokenId];
1146 
1147         emit Transfer(owner, address(0), tokenId);
1148 
1149         _afterTokenTransfers(owner, address(0), tokenId,1);
1150     }
1151 
1152 
1153     /**
1154      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1155      * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1156      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1157      */
1158     function tokenOfOwnerByIndex(address owner, uint256 index)
1159         public
1160         view
1161         override
1162         returns (uint256)
1163     {
1164         require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1165         uint256 numMintedSoFar = totalSupply();
1166         uint256 tokenIdsIdx = 0;
1167         address currOwnershipAddr = address(0);
1168         for (uint256 i = 0; i < numMintedSoFar; i++) {
1169             TokenOwnership memory ownership = _ownerships[i];
1170             if (ownership.addr != address(0)) {
1171                 currOwnershipAddr = ownership.addr;
1172             }
1173             if (currOwnershipAddr == owner) {
1174                 if (tokenIdsIdx == index) {
1175                     return i;
1176                 }
1177                 tokenIdsIdx++;
1178             }
1179         }
1180         revert("ERC721A: unable to get token of owner by index");
1181     }
1182 
1183     /**
1184      * @dev See {IERC165-supportsInterface}.
1185      */
1186     function supportsInterface(bytes4 interfaceId)
1187         public
1188         view
1189         virtual
1190         override(ERC165, IERC165)
1191         returns (bool)
1192     {
1193         return
1194             interfaceId == type(IERC721).interfaceId ||
1195             interfaceId == type(IERC721Metadata).interfaceId ||
1196             interfaceId == type(IERC721Enumerable).interfaceId ||
1197             super.supportsInterface(interfaceId);
1198     }
1199 
1200     /**
1201      * @dev See {IERC721-balanceOf}.
1202      */
1203     function balanceOf(address owner) public view override returns (uint256) {
1204         require(
1205             owner != address(0),
1206             "ERC721A: balance query for the zero address"
1207         );
1208         return uint256(_addressData[owner].balance);
1209     }
1210 
1211     function _numberMinted(address owner) internal view returns (uint256) {
1212         require(
1213             owner != address(0),
1214             "ERC721A: number minted query for the zero address"
1215         );
1216         return uint256(_addressData[owner].numberMinted);
1217     }
1218 
1219     function ownershipOf(uint256 tokenId)
1220         internal
1221         view
1222         returns (TokenOwnership memory)
1223     {
1224         require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1225 
1226         uint256 lowestTokenToCheck;
1227         if (tokenId >= maxBatchSize) {
1228             lowestTokenToCheck = tokenId - maxBatchSize + 1;
1229         }
1230 
1231         for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1232             TokenOwnership memory ownership = _ownerships[curr];
1233             if (ownership.addr != address(0)) {
1234                 return ownership;
1235             }
1236         }
1237 
1238         revert("ERC721A: unable to determine the owner of token");
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-ownerOf}.
1243      */
1244     function ownerOf(uint256 tokenId) public view override returns (address) {
1245         return ownershipOf(tokenId).addr;
1246     }
1247 
1248     /**
1249      * @dev See {IERC721Metadata-name}.
1250      */
1251     function name() public view virtual override returns (string memory) {
1252         return _name;
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Metadata-symbol}.
1257      */
1258     function symbol() public view virtual override returns (string memory) {
1259         return _symbol;
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Metadata-tokenURI}.
1264      */
1265     function tokenURI(uint256 tokenId)
1266         public
1267         view
1268         virtual
1269         override
1270         returns (string memory)
1271     {
1272         require(
1273             _exists(tokenId),
1274             "ERC721Metadata: URI query for nonexistent token"
1275         );
1276 
1277         string memory baseURI = _baseURI();
1278         return
1279             bytes(baseURI).length > 0
1280                 ? string(abi.encodePacked(baseURI, tokenId.toString()))
1281                 : "";
1282     }
1283 
1284     /**
1285      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1286      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1287      * by default, can be overriden in child contracts.
1288      */
1289     function _baseURI() internal view virtual returns (string memory) {
1290         return "";
1291     }
1292 
1293     /**
1294      * @dev See {IERC721-approve}.
1295      */
1296     function approve(address to, uint256 tokenId) public override {
1297         address owner = ERC721A.ownerOf(tokenId);
1298         require(to != owner, "ERC721A: approval to current owner");
1299 
1300         require(
1301             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1302             "ERC721A: approve caller is not owner nor approved for all"
1303         );
1304 
1305         _approve(to, tokenId, owner);
1306     }
1307 
1308     /**
1309      * @dev See {IERC721-getApproved}.
1310      */
1311     function getApproved(uint256 tokenId)
1312         public
1313         view
1314         override
1315         returns (address)
1316     {
1317         require(
1318             _exists(tokenId),
1319             "ERC721A: approved query for nonexistent token"
1320         );
1321 
1322         return _tokenApprovals[tokenId];
1323     }
1324 
1325     /**
1326      * @dev See {IERC721-setApprovalForAll}.
1327      */
1328     function setApprovalForAll(address operator, bool approved)
1329         public
1330         override
1331     {
1332         require(operator != _msgSender(), "ERC721A: approve to caller");
1333 
1334         _operatorApprovals[_msgSender()][operator] = approved;
1335         emit ApprovalForAll(_msgSender(), operator, approved);
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-isApprovedForAll}.
1340      */
1341     function isApprovedForAll(address owner, address operator)
1342         public
1343         view
1344         virtual
1345         override
1346         returns (bool)
1347     {
1348         return _operatorApprovals[owner][operator];
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-transferFrom}.
1353      */
1354     function transferFrom(
1355         address from,
1356         address to,
1357         uint256 tokenId
1358     ) public override {
1359         _transfer(from, to, tokenId);
1360     }
1361 
1362     /**
1363      * @dev See {IERC721-safeTransferFrom}.
1364      */
1365     function safeTransferFrom(
1366         address from,
1367         address to,
1368         uint256 tokenId
1369     ) public override {
1370         safeTransferFrom(from, to, tokenId, "");
1371     }
1372 
1373     /**
1374      * @dev See {IERC721-safeTransferFrom}.
1375      */
1376     function safeTransferFrom(
1377         address from,
1378         address to,
1379         uint256 tokenId,
1380         bytes memory _data
1381     ) public override {
1382         _transfer(from, to, tokenId);
1383         require(
1384             _checkOnERC721Received(from, to, tokenId, _data),
1385             "ERC721A: transfer to non ERC721Receiver implementer"
1386         );
1387     }
1388 
1389     /**
1390      * @dev Returns whether `tokenId` exists.
1391      *
1392      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1393      *
1394      * Tokens start existing when they are minted (`_mint`),
1395      */
1396     function _exists(uint256 tokenId) internal view returns (bool) {
1397         return tokenId < currentIndex;
1398     }
1399 
1400     function _safeMint(address to, uint256 quantity) internal {
1401         _safeMint(to, quantity, "");
1402     }
1403 
1404     /**
1405      * @dev Mints `quantity` tokens and transfers them to `to`.
1406      *
1407      * Requirements:
1408      *
1409      * - there must be `quantity` tokens remaining unminted in the total collection.
1410      * - `to` cannot be the zero address.
1411      * - `quantity` cannot be larger than the max batch size.
1412      *
1413      * Emits a {Transfer} event.
1414      */
1415     function _safeMint(
1416         address to,
1417         uint256 quantity,
1418         bytes memory _data
1419     ) internal {
1420         uint256 startTokenId = currentIndex;
1421         require(to != address(0), "ERC721A: mint to the zero address");
1422         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1423         require(!_exists(startTokenId), "ERC721A: token already minted");
1424         require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1425 
1426         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1427 
1428         AddressData memory addressData = _addressData[to];
1429         _addressData[to] = AddressData(
1430             addressData.balance + uint128(quantity),
1431             addressData.numberMinted + uint128(quantity)
1432         );
1433         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1434 
1435         uint256 updatedIndex = startTokenId;
1436 
1437         for (uint256 i = 0; i < quantity; i++) {
1438             emit Transfer(address(0), to, updatedIndex);
1439             require(
1440                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1441                 "ERC721A: transfer to non ERC721Receiver implementer"
1442             );
1443             updatedIndex++;
1444         }
1445 
1446         currentIndex = updatedIndex;
1447         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1448     }
1449 
1450     /**
1451      * @dev Transfers `tokenId` from `from` to `to`.
1452      *
1453      * Requirements:
1454      *
1455      * - `to` cannot be the zero address.
1456      * - `tokenId` token must be owned by `from`.
1457      *
1458      * Emits a {Transfer} event.
1459      */
1460     function _transfer(
1461         address from,
1462         address to,
1463         uint256 tokenId
1464     ) private {
1465         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1466 
1467         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1468             getApproved(tokenId) == _msgSender() ||
1469             isApprovedForAll(prevOwnership.addr, _msgSender()));
1470 
1471         require(
1472             isApprovedOrOwner,
1473             "ERC721A: transfer caller is not owner nor approved"
1474         );
1475 
1476         require(
1477             prevOwnership.addr == from,
1478             "ERC721A: transfer from incorrect owner"
1479         );
1480         require(to != address(0), "ERC721A: transfer to the zero address");
1481 
1482         _beforeTokenTransfers(from, to, tokenId, 1);
1483 
1484         // Clear approvals from the previous owner
1485         _approve(address(0), tokenId, prevOwnership.addr);
1486 
1487         _addressData[from].balance -= 1;
1488         _addressData[to].balance += 1;
1489         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1490 
1491         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1492         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1493         uint256 nextTokenId = tokenId + 1;
1494         if (_ownerships[nextTokenId].addr == address(0)) {
1495             if (_exists(nextTokenId)) {
1496                 _ownerships[nextTokenId] = TokenOwnership(
1497                     prevOwnership.addr,
1498                     prevOwnership.startTimestamp
1499                 );
1500             }
1501         }
1502 
1503         emit Transfer(from, to, tokenId);
1504         _afterTokenTransfers(from, to, tokenId, 1);
1505     }
1506 
1507     /**
1508      * @dev Approve `to` to operate on `tokenId`
1509      *
1510      * Emits a {Approval} event.
1511      */
1512     function _approve(
1513         address to,
1514         uint256 tokenId,
1515         address owner
1516     ) private {
1517         _tokenApprovals[tokenId] = to;
1518         emit Approval(owner, to, tokenId);
1519     }
1520 
1521     uint256 public nextOwnerToExplicitlySet = 0;
1522 
1523     /**
1524      * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1525      */
1526     function _setOwnersExplicit(uint256 quantity) internal {
1527         uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1528         require(quantity > 0, "quantity must be nonzero");
1529         uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1530         if (endIndex > collectionSize - 1) {
1531             endIndex = collectionSize - 1;
1532         }
1533         // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1534         require(_exists(endIndex), "not enough minted yet for this cleanup");
1535         for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1536             if (_ownerships[i].addr == address(0)) {
1537                 TokenOwnership memory ownership = ownershipOf(i);
1538                 _ownerships[i] = TokenOwnership(
1539                     ownership.addr,
1540                     ownership.startTimestamp
1541                 );
1542             }
1543         }
1544         nextOwnerToExplicitlySet = endIndex + 1;
1545     }
1546 
1547     /**
1548      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1549      * The call is not executed if the target address is not a contract.
1550      *
1551      * @param from address representing the previous owner of the given token ID
1552      * @param to target address that will receive the tokens
1553      * @param tokenId uint256 ID of the token to be transferred
1554      * @param _data bytes optional data to send along with the call
1555      * @return bool whether the call correctly returned the expected magic value
1556      */
1557     function _checkOnERC721Received(
1558         address from,
1559         address to,
1560         uint256 tokenId,
1561         bytes memory _data
1562     ) private returns (bool) {
1563         if (to.isContract()) {
1564             try
1565                 IERC721Receiver(to).onERC721Received(
1566                     _msgSender(),
1567                     from,
1568                     tokenId,
1569                     _data
1570                 )
1571             returns (bytes4 retval) {
1572                 return retval == IERC721Receiver(to).onERC721Received.selector;
1573             } catch (bytes memory reason) {
1574                 if (reason.length == 0) {
1575                     revert(
1576                         "ERC721A: transfer to non ERC721Receiver implementer"
1577                     );
1578                 } else {
1579                     assembly {
1580                         revert(add(32, reason), mload(reason))
1581                     }
1582                 }
1583             }
1584         } else {
1585             return true;
1586         }
1587     }
1588 
1589     /**
1590      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1591      *
1592      * startTokenId - the first token id to be transferred
1593      * quantity - the amount to be transferred
1594      *
1595      * Calling conditions:
1596      *
1597      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1598      * transferred to `to`.
1599      * - When `from` is zero, `tokenId` will be minted for `to`.
1600      */
1601     function _beforeTokenTransfers(
1602         address from,
1603         address to,
1604         uint256 startTokenId,
1605         uint256 quantity
1606     ) internal virtual {}
1607 
1608     /**
1609      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1610      * minting.
1611      *
1612      * startTokenId - the first token id to be transferred
1613      * quantity - the amount to be transferred
1614      *
1615      * Calling conditions:
1616      *
1617      * - when `from` and `to` are both non-zero.
1618      * - `from` and `to` are never both zero.
1619      */
1620     function _afterTokenTransfers(
1621         address from,
1622         address to,
1623         uint256 startTokenId,
1624         uint256 quantity
1625     ) internal virtual {}
1626 }
1627 
1628 contract AOW_Character_Base is ERC721A, Ownable {
1629 
1630     // errors
1631     error SALE_NOT_STARTED();
1632     error NOT_OWNER();
1633     error NO_CONTRACTS_ALLOWED();
1634     error INVALID_PROOF();
1635     error TOTAL_EXCEEDED(uint256 limit);
1636     error WALLET_LIMIT_EXCEEDED(uint256 limit);
1637     error FREE_MINT_USED();
1638     error FREE_EXCEEDED();
1639     error NO_MORE_AVAILABLE();
1640     error CANT_MINT_SAME_BLOCK();
1641     error NOT_ENOUGH_FUNDS(uint256 amountRequired);
1642     error SALE_ENDED();
1643 
1644     // Numbers
1645     uint256 public PRICE = 0.0098 ether;
1646     uint256 public PRICE_PUB = 0.0196 ether;
1647     uint256 public FREE_COUNT = 2000;
1648     uint256 public WL_COUNT = 5000;
1649     uint256 public PUB_COUNT = 1000;
1650     uint256 constant public TOTAL = 8001;
1651     uint256 private MINT_LIMIT = 2;
1652 
1653     // Start time
1654     uint256 public mintStartTime = 1662919200; // 2022/11/09 18:00 UTC
1655     uint256 public mintEndTime = 1662930000;
1656 
1657     // Security, mmerkle tree root
1658     bytes32 RECRUIT_ROOT;
1659     mapping(address => uint256) ADDRESS_BLOCK_BOUGHT;
1660     mapping(address => bool)  hasMintedFree;
1661 
1662     // addresses
1663     address public GAME_WALLET = 0xbb43fcEFF7Cb40F87f88D34F37f9b7b311D3a6fD;
1664     address public constant OWNER = 0xD3090CF8D7ECD9c1f41ebFb07c915B637BF4F466; //TC
1665     address public constant MARKETING = 0xb23e3c30CEE40b6F07cee3705E3Ab2198c3b9F2D; //LL
1666 
1667     event minted(uint256 count);
1668     event minted_free();
1669     event minted_pub(uint256 count);
1670     event burnt(uint256 tokenId);
1671 
1672     string private baseURI = "https://api.alloutwar.io";
1673 
1674     constructor() ERC721A("AllOutWar", "AOW_CHARS", 10, 200000) { 
1675         _safeMint(0xbb43fcEFF7Cb40F87f88D34F37f9b7b311D3a6fD, 1);
1676     }
1677 
1678     modifier isAllowed() {
1679         if(msg.sender != owner() || msg.sender != address(GAME_WALLET)) revert NOT_OWNER();
1680         _; 
1681     }
1682 
1683     modifier securityChecks() {
1684        if(msg.sender != tx.origin) revert NO_CONTRACTS_ALLOWED();
1685        if(ADDRESS_BLOCK_BOUGHT[msg.sender] == block.timestamp) revert CANT_MINT_SAME_BLOCK();
1686         _; 
1687     }
1688 
1689     modifier canWithdraw() {
1690         require(
1691             msg.sender == owner()  || 
1692             msg.sender == OWNER ||
1693             msg.sender == MARKETING,
1694             "Only specific wallets can withdraw"
1695         );
1696         
1697         _;  
1698     }
1699     function Mint_WL(bytes32[] memory proof, uint256 numberOfToken) external payable securityChecks() {
1700         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1701         if(!MerkleProof.verify(proof, RECRUIT_ROOT, leaf)) revert INVALID_PROOF();
1702 
1703         if(block.timestamp < mintStartTime) revert SALE_NOT_STARTED();
1704         if(block.timestamp > mintEndTime) revert SALE_ENDED();
1705         if(WL_COUNT == 0 || WL_COUNT < numberOfToken) revert NO_MORE_AVAILABLE();
1706         if( numberOfToken > MINT_LIMIT || numberMinted(msg.sender) + numberOfToken > MINT_LIMIT + 1) revert WALLET_LIMIT_EXCEEDED(3);
1707         if(msg.value < PRICE * numberOfToken) revert NOT_ENOUGH_FUNDS(PRICE * numberOfToken);
1708 
1709         // Add a free token if available
1710         WL_COUNT -= numberOfToken;
1711         if(FREE_COUNT > 0 && !hasMintedFree[msg.sender]) {
1712             FREE_COUNT -= 1;
1713             hasMintedFree[msg.sender] = true;
1714             numberOfToken +=1;
1715             if(totalSupply() + numberOfToken > TOTAL) revert TOTAL_EXCEEDED(TOTAL);
1716        }
1717         
1718         // Set verification data and continue
1719         ADDRESS_BLOCK_BOUGHT[msg.sender] = block.timestamp;
1720         _safeMint(msg.sender, numberOfToken);
1721         emit minted_free();  
1722     }
1723 
1724     function Mint(
1725         uint256 numberOfToken
1726     ) external payable  securityChecks() {
1727 
1728         if(block.timestamp < mintStartTime) revert SALE_NOT_STARTED();
1729         if(totalSupply() + numberOfToken > TOTAL) revert TOTAL_EXCEEDED(TOTAL);
1730         if( PUB_COUNT == 0 || PUB_COUNT < numberOfToken) revert NO_MORE_AVAILABLE();
1731         if( numberOfToken > MINT_LIMIT || numberMinted(msg.sender) + numberOfToken > MINT_LIMIT) revert WALLET_LIMIT_EXCEEDED(2);
1732         if(msg.value < PRICE_PUB * numberOfToken) revert NOT_ENOUGH_FUNDS(PRICE_PUB * numberOfToken);
1733 
1734         ADDRESS_BLOCK_BOUGHT[msg.sender] = block.timestamp;
1735         PUB_COUNT -= 1;
1736         _safeMint(msg.sender, numberOfToken);
1737         emit minted(numberOfToken);
1738     }
1739 
1740     function amIWhitelisted(bytes32[] memory proof) external view returns (bool) {
1741         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1742         if(!MerkleProof.verify(proof, RECRUIT_ROOT, leaf)) return false;
1743         return true;
1744     }
1745 
1746     function burn(uint256 tokenId) external isAllowed {
1747         _burn(tokenId);
1748         emit burnt(tokenId);
1749     }
1750 
1751     function batchBurn(uint256[] memory token) external isAllowed {
1752         for (uint256 i = 0; i < token.length; i++) {
1753             this.burn(token[i]);
1754         }
1755     }
1756 
1757     function setBaseURI(string calldata URI) external onlyOwner {
1758         baseURI = URI;
1759     }
1760 
1761     // Allow both owner and marketing to call withdraw
1762     function withdraw() external canWithdraw {
1763         require(address(this).balance > 0, "No balance to withdraw");
1764 
1765         uint256 balance = address(this).balance;
1766 
1767         payable(OWNER).transfer(balance / 100 * 70); // 70% of balance
1768         payable(MARKETING).transfer(balance / 100 * 30); // 30% of balance
1769     }
1770 
1771     function tokenURI(uint256 tokenId)
1772         public
1773         view
1774         virtual
1775         override
1776         returns (string memory)
1777     {
1778         require(_exists(tokenId),"Token not minted yet");
1779         
1780         return string(abi.encodePacked(
1781             baseURI,"/meta/",
1782             Strings.toString(tokenId)));
1783     }
1784 
1785     function contractURI() public view returns (string memory) {
1786         return string(abi.encodePacked(baseURI,"/meta/contract"));
1787     }
1788 
1789     function tokensOfOwner(address owner)
1790         public
1791         view
1792         returns (uint256[] memory)
1793     {
1794         uint256 tokenCount = balanceOf(owner);
1795         uint256[] memory tokenIds = new uint256[](tokenCount);
1796         for (uint256 i = 0; i < tokenCount; i++) {
1797             tokenIds[i] = tokenOfOwnerByIndex(owner, i);
1798         }
1799         return tokenIds;
1800     }
1801 
1802     function numberMinted(address owner) public view returns (uint256) {
1803         return _numberMinted(owner);
1804     }
1805  
1806     function setMintLimit(uint256 _mintLimit) external onlyOwner{
1807         MINT_LIMIT = _mintLimit;
1808     }
1809 
1810     function hasFreeMintDone(address wallet) external view returns (bool) {
1811         return hasMintedFree[wallet];
1812     }
1813 
1814     function setGameWallet(address gameWalletAddress) external onlyOwner {
1815         GAME_WALLET = gameWalletAddress;
1816     }
1817 
1818     function setPrice(uint256 _wlPrice, uint256 _pubPrice) external onlyOwner {
1819         PRICE = _wlPrice;
1820         PRICE_PUB = _pubPrice;
1821     }
1822 
1823     function setStartTime(uint256 _startTime, uint256 _endTime) external onlyOwner {
1824         mintStartTime = _startTime;
1825         mintEndTime = _endTime;
1826     }
1827     
1828     function setRecruitRoot(bytes32 recruitRoot) external onlyOwner {
1829         RECRUIT_ROOT = recruitRoot;
1830     }
1831 
1832     function updateCounts(uint256 _newWL, uint256 _newPub) external onlyOwner {
1833 
1834         require(totalSupply() + _newWL + _newPub <= TOTAL, "Total supply exceeded");
1835 
1836         PUB_COUNT = _newPub;
1837         WL_COUNT = _newWL;
1838     }
1839 }