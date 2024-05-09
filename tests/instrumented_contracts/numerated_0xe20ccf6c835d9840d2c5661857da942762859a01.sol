1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
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
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
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
52                 computedHash = _efficientHash(computedHash, proofElement);
53             } else {
54                 // Hash(current element of the proof + current computed hash)
55                 computedHash = _efficientHash(proofElement, computedHash);
56             }
57         }
58         return computedHash;
59     }
60 
61     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
62         assembly {
63             mstore(0x00, a)
64             mstore(0x20, b)
65             value := keccak256(0x00, 0x40)
66         }
67     }
68 }
69 
70 // File: @openzeppelin/contracts/utils/Counters.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @title Counters
79  * @author Matt Condon (@shrugs)
80  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
81  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
82  *
83  * Include with `using Counters for Counters.Counter;`
84  */
85 library Counters {
86     struct Counter {
87         // This variable should never be directly accessed by users of the library: interactions must be restricted to
88         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
89         // this feature: see https://github.com/ethereum/solidity/issues/4637
90         uint256 _value; // default: 0
91     }
92 
93     function current(Counter storage counter) internal view returns (uint256) {
94         return counter._value;
95     }
96 
97     function increment(Counter storage counter) internal {
98         unchecked {
99             counter._value += 1;
100         }
101     }
102 
103     function decrement(Counter storage counter) internal {
104         uint256 value = counter._value;
105         require(value > 0, "Counter: decrement overflow");
106         unchecked {
107             counter._value = value - 1;
108         }
109     }
110 
111     function reset(Counter storage counter) internal {
112         counter._value = 0;
113     }
114 }
115 
116 // File: @openzeppelin/contracts/utils/Strings.sol
117 
118 
119 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev String operations.
125  */
126 library Strings {
127     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
131      */
132     function toString(uint256 value) internal pure returns (string memory) {
133         // Inspired by OraclizeAPI's implementation - MIT licence
134         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
135 
136         if (value == 0) {
137             return "0";
138         }
139         uint256 temp = value;
140         uint256 digits;
141         while (temp != 0) {
142             digits++;
143             temp /= 10;
144         }
145         bytes memory buffer = new bytes(digits);
146         while (value != 0) {
147             digits -= 1;
148             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
149             value /= 10;
150         }
151         return string(buffer);
152     }
153 
154     /**
155      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
156      */
157     function toHexString(uint256 value) internal pure returns (string memory) {
158         if (value == 0) {
159             return "0x00";
160         }
161         uint256 temp = value;
162         uint256 length = 0;
163         while (temp != 0) {
164             length++;
165             temp >>= 8;
166         }
167         return toHexString(value, length);
168     }
169 
170     /**
171      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
172      */
173     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
174         bytes memory buffer = new bytes(2 * length + 2);
175         buffer[0] = "0";
176         buffer[1] = "x";
177         for (uint256 i = 2 * length + 1; i > 1; --i) {
178             buffer[i] = _HEX_SYMBOLS[value & 0xf];
179             value >>= 4;
180         }
181         require(value == 0, "Strings: hex length insufficient");
182         return string(buffer);
183     }
184 }
185 
186 // File: @openzeppelin/contracts/utils/Context.sol
187 
188 
189 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev Provides information about the current execution context, including the
195  * sender of the transaction and its data. While these are generally available
196  * via msg.sender and msg.data, they should not be accessed in such a direct
197  * manner, since when dealing with meta-transactions the account sending and
198  * paying for execution may not be the actual sender (as far as an application
199  * is concerned).
200  *
201  * This contract is only required for intermediate, library-like contracts.
202  */
203 abstract contract Context {
204     function _msgSender() internal view virtual returns (address) {
205         return msg.sender;
206     }
207 
208     function _msgData() internal view virtual returns (bytes calldata) {
209         return msg.data;
210     }
211 }
212 
213 // File: @openzeppelin/contracts/access/Ownable.sol
214 
215 
216 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
217 
218 pragma solidity ^0.8.0;
219 
220 
221 /**
222  * @dev Contract module which provides a basic access control mechanism, where
223  * there is an account (an owner) that can be granted exclusive access to
224  * specific functions.
225  *
226  * By default, the owner account will be the one that deploys the contract. This
227  * can later be changed with {transferOwnership}.
228  *
229  * This module is used through inheritance. It will make available the modifier
230  * `onlyOwner`, which can be applied to your functions to restrict their use to
231  * the owner.
232  */
233 abstract contract Ownable is Context {
234     address private _owner;
235 
236     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
237 
238     /**
239      * @dev Initializes the contract setting the deployer as the initial owner.
240      */
241     constructor() {
242         _transferOwnership(_msgSender());
243     }
244 
245     /**
246      * @dev Returns the address of the current owner.
247      */
248     function owner() public view virtual returns (address) {
249         return _owner;
250     }
251 
252     /**
253      * @dev Throws if called by any account other than the owner.
254      */
255     modifier onlyOwner() {
256         require(owner() == _msgSender(), "Ownable: caller is not the owner");
257         _;
258     }
259 
260     /**
261      * @dev Leaves the contract without owner. It will not be possible to call
262      * `onlyOwner` functions anymore. Can only be called by the current owner.
263      *
264      * NOTE: Renouncing ownership will leave the contract without an owner,
265      * thereby removing any functionality that is only available to the owner.
266      */
267     function renounceOwnership() public virtual onlyOwner {
268         _transferOwnership(address(0));
269     }
270 
271     /**
272      * @dev Transfers ownership of the contract to a new account (`newOwner`).
273      * Can only be called by the current owner.
274      */
275     function transferOwnership(address newOwner) public virtual onlyOwner {
276         require(newOwner != address(0), "Ownable: new owner is the zero address");
277         _transferOwnership(newOwner);
278     }
279 
280     /**
281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
282      * Internal function without access restriction.
283      */
284     function _transferOwnership(address newOwner) internal virtual {
285         address oldOwner = _owner;
286         _owner = newOwner;
287         emit OwnershipTransferred(oldOwner, newOwner);
288     }
289 }
290 
291 // File: @openzeppelin/contracts/utils/Address.sol
292 
293 
294 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
295 
296 pragma solidity ^0.8.1;
297 
298 /**
299  * @dev Collection of functions related to the address type
300  */
301 library Address {
302     /**
303      * @dev Returns true if `account` is a contract.
304      *
305      * [IMPORTANT]
306      * ====
307      * It is unsafe to assume that an address for which this function returns
308      * false is an externally-owned account (EOA) and not a contract.
309      *
310      * Among others, `isContract` will return false for the following
311      * types of addresses:
312      *
313      *  - an externally-owned account
314      *  - a contract in construction
315      *  - an address where a contract will be created
316      *  - an address where a contract lived, but was destroyed
317      * ====
318      *
319      * [IMPORTANT]
320      * ====
321      * You shouldn't rely on `isContract` to protect against flash loan attacks!
322      *
323      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
324      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
325      * constructor.
326      * ====
327      */
328     function isContract(address account) internal view returns (bool) {
329         // This method relies on extcodesize/address.code.length, which returns 0
330         // for contracts in construction, since the code is only stored at the end
331         // of the constructor execution.
332 
333         return account.code.length > 0;
334     }
335 
336     /**
337      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
338      * `recipient`, forwarding all available gas and reverting on errors.
339      *
340      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
341      * of certain opcodes, possibly making contracts go over the 2300 gas limit
342      * imposed by `transfer`, making them unable to receive funds via
343      * `transfer`. {sendValue} removes this limitation.
344      *
345      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
346      *
347      * IMPORTANT: because control is transferred to `recipient`, care must be
348      * taken to not create reentrancy vulnerabilities. Consider using
349      * {ReentrancyGuard} or the
350      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
351      */
352     function sendValue(address payable recipient, uint256 amount) internal {
353         require(address(this).balance >= amount, "Address: insufficient balance");
354 
355         (bool success, ) = recipient.call{value: amount}("");
356         require(success, "Address: unable to send value, recipient may have reverted");
357     }
358 
359     /**
360      * @dev Performs a Solidity function call using a low level `call`. A
361      * plain `call` is an unsafe replacement for a function call: use this
362      * function instead.
363      *
364      * If `target` reverts with a revert reason, it is bubbled up by this
365      * function (like regular Solidity function calls).
366      *
367      * Returns the raw returned data. To convert to the expected return value,
368      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
369      *
370      * Requirements:
371      *
372      * - `target` must be a contract.
373      * - calling `target` with `data` must not revert.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
378         return functionCall(target, data, "Address: low-level call failed");
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
383      * `errorMessage` as a fallback revert reason when `target` reverts.
384      *
385      * _Available since v3.1._
386      */
387     function functionCall(
388         address target,
389         bytes memory data,
390         string memory errorMessage
391     ) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, 0, errorMessage);
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
397      * but also transferring `value` wei to `target`.
398      *
399      * Requirements:
400      *
401      * - the calling contract must have an ETH balance of at least `value`.
402      * - the called Solidity function must be `payable`.
403      *
404      * _Available since v3.1._
405      */
406     function functionCallWithValue(
407         address target,
408         bytes memory data,
409         uint256 value
410     ) internal returns (bytes memory) {
411         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
416      * with `errorMessage` as a fallback revert reason when `target` reverts.
417      *
418      * _Available since v3.1._
419      */
420     function functionCallWithValue(
421         address target,
422         bytes memory data,
423         uint256 value,
424         string memory errorMessage
425     ) internal returns (bytes memory) {
426         require(address(this).balance >= value, "Address: insufficient balance for call");
427         require(isContract(target), "Address: call to non-contract");
428 
429         (bool success, bytes memory returndata) = target.call{value: value}(data);
430         return verifyCallResult(success, returndata, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but performing a static call.
436      *
437      * _Available since v3.3._
438      */
439     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
440         return functionStaticCall(target, data, "Address: low-level static call failed");
441     }
442 
443     /**
444      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
445      * but performing a static call.
446      *
447      * _Available since v3.3._
448      */
449     function functionStaticCall(
450         address target,
451         bytes memory data,
452         string memory errorMessage
453     ) internal view returns (bytes memory) {
454         require(isContract(target), "Address: static call to non-contract");
455 
456         (bool success, bytes memory returndata) = target.staticcall(data);
457         return verifyCallResult(success, returndata, errorMessage);
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
467         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
472      * but performing a delegate call.
473      *
474      * _Available since v3.4._
475      */
476     function functionDelegateCall(
477         address target,
478         bytes memory data,
479         string memory errorMessage
480     ) internal returns (bytes memory) {
481         require(isContract(target), "Address: delegate call to non-contract");
482 
483         (bool success, bytes memory returndata) = target.delegatecall(data);
484         return verifyCallResult(success, returndata, errorMessage);
485     }
486 
487     /**
488      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
489      * revert reason using the provided one.
490      *
491      * _Available since v4.3._
492      */
493     function verifyCallResult(
494         bool success,
495         bytes memory returndata,
496         string memory errorMessage
497     ) internal pure returns (bytes memory) {
498         if (success) {
499             return returndata;
500         } else {
501             // Look for revert reason and bubble it up if present
502             if (returndata.length > 0) {
503                 // The easiest way to bubble the revert reason is using memory via assembly
504 
505                 assembly {
506                     let returndata_size := mload(returndata)
507                     revert(add(32, returndata), returndata_size)
508                 }
509             } else {
510                 revert(errorMessage);
511             }
512         }
513     }
514 }
515 
516 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
517 
518 
519 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
520 
521 pragma solidity ^0.8.0;
522 
523 /**
524  * @title ERC721 token receiver interface
525  * @dev Interface for any contract that wants to support safeTransfers
526  * from ERC721 asset contracts.
527  */
528 interface IERC721Receiver {
529     /**
530      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
531      * by `operator` from `from`, this function is called.
532      *
533      * It must return its Solidity selector to confirm the token transfer.
534      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
535      *
536      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
537      */
538     function onERC721Received(
539         address operator,
540         address from,
541         uint256 tokenId,
542         bytes calldata data
543     ) external returns (bytes4);
544 }
545 
546 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
547 
548 
549 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev Interface of the ERC165 standard, as defined in the
555  * https://eips.ethereum.org/EIPS/eip-165[EIP].
556  *
557  * Implementers can declare support of contract interfaces, which can then be
558  * queried by others ({ERC165Checker}).
559  *
560  * For an implementation, see {ERC165}.
561  */
562 interface IERC165 {
563     /**
564      * @dev Returns true if this contract implements the interface defined by
565      * `interfaceId`. See the corresponding
566      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
567      * to learn more about how these ids are created.
568      *
569      * This function call must use less than 30 000 gas.
570      */
571     function supportsInterface(bytes4 interfaceId) external view returns (bool);
572 }
573 
574 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @dev Implementation of the {IERC165} interface.
584  *
585  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
586  * for the additional interface id that will be supported. For example:
587  *
588  * ```solidity
589  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
590  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
591  * }
592  * ```
593  *
594  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
595  */
596 abstract contract ERC165 is IERC165 {
597     /**
598      * @dev See {IERC165-supportsInterface}.
599      */
600     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
601         return interfaceId == type(IERC165).interfaceId;
602     }
603 }
604 
605 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
606 
607 
608 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
609 
610 pragma solidity ^0.8.0;
611 
612 
613 /**
614  * @dev Required interface of an ERC721 compliant contract.
615  */
616 interface IERC721 is IERC165 {
617     /**
618      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
619      */
620     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
621 
622     /**
623      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
624      */
625     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
626 
627     /**
628      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
629      */
630     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
631 
632     /**
633      * @dev Returns the number of tokens in ``owner``'s account.
634      */
635     function balanceOf(address owner) external view returns (uint256 balance);
636 
637     /**
638      * @dev Returns the owner of the `tokenId` token.
639      *
640      * Requirements:
641      *
642      * - `tokenId` must exist.
643      */
644     function ownerOf(uint256 tokenId) external view returns (address owner);
645 
646     /**
647      * @dev Safely transfers `tokenId` token from `from` to `to`.
648      *
649      * Requirements:
650      *
651      * - `from` cannot be the zero address.
652      * - `to` cannot be the zero address.
653      * - `tokenId` token must exist and be owned by `from`.
654      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
655      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
656      *
657      * Emits a {Transfer} event.
658      */
659     function safeTransferFrom(
660         address from,
661         address to,
662         uint256 tokenId,
663         bytes calldata data
664     ) external;
665 
666     /**
667      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
668      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
669      *
670      * Requirements:
671      *
672      * - `from` cannot be the zero address.
673      * - `to` cannot be the zero address.
674      * - `tokenId` token must exist and be owned by `from`.
675      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
676      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
677      *
678      * Emits a {Transfer} event.
679      */
680     function safeTransferFrom(
681         address from,
682         address to,
683         uint256 tokenId
684     ) external;
685 
686     /**
687      * @dev Transfers `tokenId` token from `from` to `to`.
688      *
689      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
690      *
691      * Requirements:
692      *
693      * - `from` cannot be the zero address.
694      * - `to` cannot be the zero address.
695      * - `tokenId` token must be owned by `from`.
696      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
697      *
698      * Emits a {Transfer} event.
699      */
700     function transferFrom(
701         address from,
702         address to,
703         uint256 tokenId
704     ) external;
705 
706     /**
707      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
708      * The approval is cleared when the token is transferred.
709      *
710      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
711      *
712      * Requirements:
713      *
714      * - The caller must own the token or be an approved operator.
715      * - `tokenId` must exist.
716      *
717      * Emits an {Approval} event.
718      */
719     function approve(address to, uint256 tokenId) external;
720 
721     /**
722      * @dev Approve or remove `operator` as an operator for the caller.
723      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
724      *
725      * Requirements:
726      *
727      * - The `operator` cannot be the caller.
728      *
729      * Emits an {ApprovalForAll} event.
730      */
731     function setApprovalForAll(address operator, bool _approved) external;
732 
733     /**
734      * @dev Returns the account approved for `tokenId` token.
735      *
736      * Requirements:
737      *
738      * - `tokenId` must exist.
739      */
740     function getApproved(uint256 tokenId) external view returns (address operator);
741 
742     /**
743      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
744      *
745      * See {setApprovalForAll}
746      */
747     function isApprovedForAll(address owner, address operator) external view returns (bool);
748 }
749 
750 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
751 
752 
753 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 
758 /**
759  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
760  * @dev See https://eips.ethereum.org/EIPS/eip-721
761  */
762 interface IERC721Metadata is IERC721 {
763     /**
764      * @dev Returns the token collection name.
765      */
766     function name() external view returns (string memory);
767 
768     /**
769      * @dev Returns the token collection symbol.
770      */
771     function symbol() external view returns (string memory);
772 
773     /**
774      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
775      */
776     function tokenURI(uint256 tokenId) external view returns (string memory);
777 }
778 
779 // File: contracts/IERC721A.sol
780 
781 
782 // ERC721A Contracts v3.3.0
783 // Creator: Chiru Labs
784 
785 pragma solidity ^0.8.4;
786 
787 
788 
789 /**
790  * @dev Interface of an ERC721A compliant contract.
791  */
792 interface IERC721A is IERC721, IERC721Metadata {
793     /**
794      * The caller must own the token or be an approved operator.
795      */
796     error ApprovalCallerNotOwnerNorApproved();
797 
798     /**
799      * The token does not exist.
800      */
801     error ApprovalQueryForNonexistentToken();
802 
803     /**
804      * The caller cannot approve to their own address.
805      */
806     error ApproveToCaller();
807 
808     /**
809      * The caller cannot approve to the current owner.
810      */
811     error ApprovalToCurrentOwner();
812 
813     /**
814      * Cannot query the balance for the zero address.
815      */
816     error BalanceQueryForZeroAddress();
817 
818     /**
819      * Cannot mint to the zero address.
820      */
821     error MintToZeroAddress();
822 
823     /**
824      * The quantity of tokens minted must be more than zero.
825      */
826     error MintZeroQuantity();
827 
828     /**
829      * The token does not exist.
830      */
831     error OwnerQueryForNonexistentToken();
832 
833     /**
834      * The caller must own the token or be an approved operator.
835      */
836     error TransferCallerNotOwnerNorApproved();
837 
838     /**
839      * The token must be owned by `from`.
840      */
841     error TransferFromIncorrectOwner();
842 
843     /**
844      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
845      */
846     error TransferToNonERC721ReceiverImplementer();
847 
848     /**
849      * Cannot transfer to the zero address.
850      */
851     error TransferToZeroAddress();
852 
853     /**
854      * The token does not exist.
855      */
856     error URIQueryForNonexistentToken();
857 
858     // Compiler will pack this into a single 256bit word.
859     struct TokenOwnership {
860         // The address of the owner.
861         address addr;
862         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
863         uint64 startTimestamp;
864         // Whether the token has been burned.
865         bool burned;
866     }
867 
868     // Compiler will pack this into a single 256bit word.
869     struct AddressData {
870         // Realistically, 2**64-1 is more than enough.
871         uint64 balance;
872         // Keeps track of mint count with minimal overhead for tokenomics.
873         uint64 numberMinted;
874         // Keeps track of burn count with minimal overhead for tokenomics.
875         uint64 numberBurned;
876         // For miscellaneous variable(s) pertaining to the address
877         // (e.g. number of whitelist mint slots used).
878         // If there are multiple variables, please pack them into a uint64.
879         uint64 aux;
880     }
881 
882     /**
883      * @dev Returns the total amount of tokens stored by the contract.
884      * 
885      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
886      */
887     function totalSupply() external view returns (uint256);
888 }
889 
890 // File: contracts/ERC721A.sol
891 
892 
893 // ERC721A Contracts v3.3.0
894 // Creator: Chiru Labs
895 
896 pragma solidity ^0.8.4;
897 
898 
899 
900 
901 
902 
903 
904 /**
905  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
906  * the Metadata extension. Built to optimize for lower gas during batch mints.
907  *
908  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
909  *
910  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
911  *
912  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
913  */
914 contract ERC721A is Context, ERC165, IERC721A {
915     using Address for address;
916     using Strings for uint256;
917 
918     // The tokenId of the next token to be minted.
919     uint256 internal _currentIndex;
920 
921     // The number of tokens burned.
922     uint256 internal _burnCounter;
923 
924     // Token name
925     string private _name;
926 
927     // Token symbol
928     string private _symbol;
929 
930     // Mapping from token ID to ownership details
931     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
932     mapping(uint256 => TokenOwnership) internal _ownerships;
933 
934     // Mapping owner address to address data
935     mapping(address => AddressData) private _addressData;
936 
937     // Mapping from token ID to approved address
938     mapping(uint256 => address) private _tokenApprovals;
939 
940     // Mapping from owner to operator approvals
941     mapping(address => mapping(address => bool)) private _operatorApprovals;
942 
943     constructor(string memory name_, string memory symbol_) {
944         _name = name_;
945         _symbol = symbol_;
946         _currentIndex = _startTokenId();
947     }
948 
949     /**
950      * To change the starting tokenId, please override this function.
951      */
952     function _startTokenId() internal view virtual returns (uint256) {
953         return 0;
954     }
955 
956     /**
957      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
958      */
959     function totalSupply() public view override returns (uint256) {
960         // Counter underflow is impossible as _burnCounter cannot be incremented
961         // more than _currentIndex - _startTokenId() times
962         unchecked {
963             return _currentIndex - _burnCounter - _startTokenId();
964         }
965     }
966 
967     /**
968      * Returns the total amount of tokens minted in the contract.
969      */
970     function _totalMinted() internal view returns (uint256) {
971         // Counter underflow is impossible as _currentIndex does not decrement,
972         // and it is initialized to _startTokenId()
973         unchecked {
974             return _currentIndex - _startTokenId();
975         }
976     }
977 
978     /**
979      * @dev See {IERC165-supportsInterface}.
980      */
981     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
982         return
983             interfaceId == type(IERC721).interfaceId ||
984             interfaceId == type(IERC721Metadata).interfaceId ||
985             super.supportsInterface(interfaceId);
986     }
987 
988     /**
989      * @dev See {IERC721-balanceOf}.
990      */
991     function balanceOf(address owner) public view override returns (uint256) {
992         if (owner == address(0)) revert BalanceQueryForZeroAddress();
993         return uint256(_addressData[owner].balance);
994     }
995 
996     /**
997      * Returns the number of tokens minted by `owner`.
998      */
999     function _numberMinted(address owner) internal view returns (uint256) {
1000         return uint256(_addressData[owner].numberMinted);
1001     }
1002 
1003     /**
1004      * Returns the number of tokens burned by or on behalf of `owner`.
1005      */
1006     function _numberBurned(address owner) internal view returns (uint256) {
1007         return uint256(_addressData[owner].numberBurned);
1008     }
1009 
1010     /**
1011      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1012      */
1013     function _getAux(address owner) internal view returns (uint64) {
1014         return _addressData[owner].aux;
1015     }
1016 
1017     /**
1018      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1019      * If there are multiple variables, please pack them into a uint64.
1020      */
1021     function _setAux(address owner, uint64 aux) internal {
1022         _addressData[owner].aux = aux;
1023     }
1024 
1025     /**
1026      * Gas spent here starts off proportional to the maximum mint batch size.
1027      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1028      */
1029     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1030         uint256 curr = tokenId;
1031 
1032         unchecked {
1033             if (_startTokenId() <= curr) if (curr < _currentIndex) {
1034                 TokenOwnership memory ownership = _ownerships[curr];
1035                 if (!ownership.burned) {
1036                     if (ownership.addr != address(0)) {
1037                         return ownership;
1038                     }
1039                     // Invariant:
1040                     // There will always be an ownership that has an address and is not burned
1041                     // before an ownership that does not have an address and is not burned.
1042                     // Hence, curr will not underflow.
1043                     while (true) {
1044                         curr--;
1045                         ownership = _ownerships[curr];
1046                         if (ownership.addr != address(0)) {
1047                             return ownership;
1048                         }
1049                     }
1050                 }
1051             }
1052         }
1053         revert OwnerQueryForNonexistentToken();
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-ownerOf}.
1058      */
1059     function ownerOf(uint256 tokenId) public view override returns (address) {
1060         return _ownershipOf(tokenId).addr;
1061     }
1062 
1063     /**
1064      * @dev See {IERC721Metadata-name}.
1065      */
1066     function name() public view virtual override returns (string memory) {
1067         return _name;
1068     }
1069 
1070     /**
1071      * @dev See {IERC721Metadata-symbol}.
1072      */
1073     function symbol() public view virtual override returns (string memory) {
1074         return _symbol;
1075     }
1076 
1077     /**
1078      * @dev See {IERC721Metadata-tokenURI}.
1079      */
1080     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1081         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1082 
1083         string memory baseURI = _baseURI();
1084         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1085     }
1086 
1087     /**
1088      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1089      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1090      * by default, can be overriden in child contracts.
1091      */
1092     function _baseURI() internal view virtual returns (string memory) {
1093         return '';
1094     }
1095 
1096     /**
1097      * @dev See {IERC721-approve}.
1098      */
1099     function approve(address to, uint256 tokenId) public override {
1100         address owner = ERC721A.ownerOf(tokenId);
1101         if (to == owner) revert ApprovalToCurrentOwner();
1102 
1103         if (_msgSender() != owner) if(!isApprovedForAll(owner, _msgSender())) {
1104             revert ApprovalCallerNotOwnerNorApproved();
1105         }
1106 
1107         _tokenApprovals[tokenId] = to;
1108         emit Approval(owner, to, tokenId);
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-getApproved}.
1113      */
1114     function getApproved(uint256 tokenId) public view override returns (address) {
1115         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1116 
1117         return _tokenApprovals[tokenId];
1118     }
1119 
1120     /**
1121      * @dev See {IERC721-setApprovalForAll}.
1122      */
1123     function setApprovalForAll(address operator, bool approved) public virtual override {
1124         if (operator == _msgSender()) revert ApproveToCaller();
1125 
1126         _operatorApprovals[_msgSender()][operator] = approved;
1127         emit ApprovalForAll(_msgSender(), operator, approved);
1128     }
1129 
1130     /**
1131      * @dev See {IERC721-isApprovedForAll}.
1132      */
1133     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1134         return _operatorApprovals[owner][operator];
1135     }
1136 
1137     /**
1138      * @dev See {IERC721-transferFrom}.
1139      */
1140     function transferFrom(
1141         address from,
1142         address to,
1143         uint256 tokenId
1144     ) public virtual override {
1145         _transfer(from, to, tokenId);
1146     }
1147 
1148     /**
1149      * @dev See {IERC721-safeTransferFrom}.
1150      */
1151     function safeTransferFrom(
1152         address from,
1153         address to,
1154         uint256 tokenId
1155     ) public virtual override {
1156         safeTransferFrom(from, to, tokenId, '');
1157     }
1158 
1159     /**
1160      * @dev See {IERC721-safeTransferFrom}.
1161      */
1162     function safeTransferFrom(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) public virtual override {
1168         _transfer(from, to, tokenId);
1169         if (to.isContract()) if(!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1170             revert TransferToNonERC721ReceiverImplementer();
1171         }
1172     }
1173 
1174     /**
1175      * @dev Returns whether `tokenId` exists.
1176      *
1177      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1178      *
1179      * Tokens start existing when they are minted (`_mint`),
1180      */
1181     function _exists(uint256 tokenId) internal view returns (bool) {
1182         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1183     }
1184 
1185     /**
1186      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1187      */
1188     function _safeMint(address to, uint256 quantity) internal {
1189         _safeMint(to, quantity, '');
1190     }
1191 
1192     /**
1193      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1194      *
1195      * Requirements:
1196      *
1197      * - If `to` refers to a smart contract, it must implement
1198      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1199      * - `quantity` must be greater than 0.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function _safeMint(
1204         address to,
1205         uint256 quantity,
1206         bytes memory _data
1207     ) internal {
1208         uint256 startTokenId = _currentIndex;
1209         if (to == address(0)) revert MintToZeroAddress();
1210         if (quantity == 0) revert MintZeroQuantity();
1211 
1212         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1213 
1214         // Overflows are incredibly unrealistic.
1215         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1216         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1217         unchecked {
1218             _addressData[to].balance += uint64(quantity);
1219             _addressData[to].numberMinted += uint64(quantity);
1220 
1221             _ownerships[startTokenId].addr = to;
1222             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1223 
1224             uint256 updatedIndex = startTokenId;
1225             uint256 end = updatedIndex + quantity;
1226 
1227             if (to.isContract()) {
1228                 do {
1229                     emit Transfer(address(0), to, updatedIndex);
1230                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1231                         revert TransferToNonERC721ReceiverImplementer();
1232                     }
1233                 } while (updatedIndex < end);
1234                 // Reentrancy protection
1235                 if (_currentIndex != startTokenId) revert();
1236             } else {
1237                 do {
1238                     emit Transfer(address(0), to, updatedIndex++);
1239                 } while (updatedIndex < end);
1240             }
1241             _currentIndex = updatedIndex;
1242         }
1243         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1244     }
1245 
1246     /**
1247      * @dev Mints `quantity` tokens and transfers them to `to`.
1248      *
1249      * Requirements:
1250      *
1251      * - `to` cannot be the zero address.
1252      * - `quantity` must be greater than 0.
1253      *
1254      * Emits a {Transfer} event.
1255      */
1256     function _mint(address to, uint256 quantity) internal {
1257         uint256 startTokenId = _currentIndex;
1258         if (to == address(0)) revert MintToZeroAddress();
1259         if (quantity == 0) revert MintZeroQuantity();
1260 
1261         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1262 
1263         // Overflows are incredibly unrealistic.
1264         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1265         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1266         unchecked {
1267             _addressData[to].balance += uint64(quantity);
1268             _addressData[to].numberMinted += uint64(quantity);
1269 
1270             _ownerships[startTokenId].addr = to;
1271             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1272 
1273             uint256 updatedIndex = startTokenId;
1274             uint256 end = updatedIndex + quantity;
1275 
1276             do {
1277                 emit Transfer(address(0), to, updatedIndex++);
1278             } while (updatedIndex < end);
1279 
1280             _currentIndex = updatedIndex;
1281         }
1282         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1283     }
1284 
1285     /**
1286      * @dev Transfers `tokenId` from `from` to `to`.
1287      *
1288      * Requirements:
1289      *
1290      * - `to` cannot be the zero address.
1291      * - `tokenId` token must be owned by `from`.
1292      *
1293      * Emits a {Transfer} event.
1294      */
1295     function _transfer(
1296         address from,
1297         address to,
1298         uint256 tokenId
1299     ) private {
1300         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1301 
1302         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1303 
1304         bool isApprovedOrOwner = (_msgSender() == from ||
1305             isApprovedForAll(from, _msgSender()) ||
1306             getApproved(tokenId) == _msgSender());
1307 
1308         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1309         if (to == address(0)) revert TransferToZeroAddress();
1310 
1311         _beforeTokenTransfers(from, to, tokenId, 1);
1312 
1313         // Clear approvals from the previous owner.
1314         delete _tokenApprovals[tokenId];
1315 
1316         // Underflow of the sender's balance is impossible because we check for
1317         // ownership above and the recipient's balance can't realistically overflow.
1318         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1319         unchecked {
1320             _addressData[from].balance -= 1;
1321             _addressData[to].balance += 1;
1322 
1323             TokenOwnership storage currSlot = _ownerships[tokenId];
1324             currSlot.addr = to;
1325             currSlot.startTimestamp = uint64(block.timestamp);
1326 
1327             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1328             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1329             uint256 nextTokenId = tokenId + 1;
1330             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1331             if (nextSlot.addr == address(0)) {
1332                 // This will suffice for checking _exists(nextTokenId),
1333                 // as a burned slot cannot contain the zero address.
1334                 if (nextTokenId != _currentIndex) {
1335                     nextSlot.addr = from;
1336                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1337                 }
1338             }
1339         }
1340 
1341         emit Transfer(from, to, tokenId);
1342         _afterTokenTransfers(from, to, tokenId, 1);
1343     }
1344 
1345     /**
1346      * @dev Equivalent to `_burn(tokenId, false)`.
1347      */
1348     function _burn(uint256 tokenId) internal virtual {
1349         _burn(tokenId, false);
1350     }
1351 
1352     /**
1353      * @dev Destroys `tokenId`.
1354      * The approval is cleared when the token is burned.
1355      *
1356      * Requirements:
1357      *
1358      * - `tokenId` must exist.
1359      *
1360      * Emits a {Transfer} event.
1361      */
1362     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1363         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1364 
1365         address from = prevOwnership.addr;
1366 
1367         if (approvalCheck) {
1368             bool isApprovedOrOwner = (_msgSender() == from ||
1369                 isApprovedForAll(from, _msgSender()) ||
1370                 getApproved(tokenId) == _msgSender());
1371 
1372             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1373         }
1374 
1375         _beforeTokenTransfers(from, address(0), tokenId, 1);
1376 
1377         // Clear approvals from the previous owner.
1378         delete _tokenApprovals[tokenId];
1379 
1380         // Underflow of the sender's balance is impossible because we check for
1381         // ownership above and the recipient's balance can't realistically overflow.
1382         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1383         unchecked {
1384             AddressData storage addressData = _addressData[from];
1385             addressData.balance -= 1;
1386             addressData.numberBurned += 1;
1387 
1388             // Keep track of who burned the token, and the timestamp of burning.
1389             TokenOwnership storage currSlot = _ownerships[tokenId];
1390             currSlot.addr = from;
1391             currSlot.startTimestamp = uint64(block.timestamp);
1392             currSlot.burned = true;
1393 
1394             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1395             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1396             uint256 nextTokenId = tokenId + 1;
1397             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1398             if (nextSlot.addr == address(0)) {
1399                 // This will suffice for checking _exists(nextTokenId),
1400                 // as a burned slot cannot contain the zero address.
1401                 if (nextTokenId != _currentIndex) {
1402                     nextSlot.addr = from;
1403                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1404                 }
1405             }
1406         }
1407 
1408         emit Transfer(from, address(0), tokenId);
1409         _afterTokenTransfers(from, address(0), tokenId, 1);
1410 
1411         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1412         unchecked {
1413             _burnCounter++;
1414         }
1415     }
1416 
1417     /**
1418      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1419      *
1420      * @param from address representing the previous owner of the given token ID
1421      * @param to target address that will receive the tokens
1422      * @param tokenId uint256 ID of the token to be transferred
1423      * @param _data bytes optional data to send along with the call
1424      * @return bool whether the call correctly returned the expected magic value
1425      */
1426     function _checkContractOnERC721Received(
1427         address from,
1428         address to,
1429         uint256 tokenId,
1430         bytes memory _data
1431     ) private returns (bool) {
1432         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1433             return retval == IERC721Receiver(to).onERC721Received.selector;
1434         } catch (bytes memory reason) {
1435             if (reason.length == 0) {
1436                 revert TransferToNonERC721ReceiverImplementer();
1437             } else {
1438                 assembly {
1439                     revert(add(32, reason), mload(reason))
1440                 }
1441             }
1442         }
1443     }
1444 
1445     /**
1446      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1447      * And also called before burning one token.
1448      *
1449      * startTokenId - the first token id to be transferred
1450      * quantity - the amount to be transferred
1451      *
1452      * Calling conditions:
1453      *
1454      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1455      * transferred to `to`.
1456      * - When `from` is zero, `tokenId` will be minted for `to`.
1457      * - When `to` is zero, `tokenId` will be burned by `from`.
1458      * - `from` and `to` are never both zero.
1459      */
1460     function _beforeTokenTransfers(
1461         address from,
1462         address to,
1463         uint256 startTokenId,
1464         uint256 quantity
1465     ) internal virtual {}
1466 
1467     /**
1468      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1469      * minting.
1470      * And also called after one token has been burned.
1471      *
1472      * startTokenId - the first token id to be transferred
1473      * quantity - the amount to be transferred
1474      *
1475      * Calling conditions:
1476      *
1477      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1478      * transferred to `to`.
1479      * - When `from` is zero, `tokenId` has been minted for `to`.
1480      * - When `to` is zero, `tokenId` has been burned by `from`.
1481      * - `from` and `to` are never both zero.
1482      */
1483     function _afterTokenTransfers(
1484         address from,
1485         address to,
1486         uint256 startTokenId,
1487         uint256 quantity
1488     ) internal virtual {}
1489 }
1490 
1491 // File: contracts/TheKidsTest.sol
1492 
1493 
1494 
1495 pragma solidity >=0.7.0 <0.9.0;
1496 
1497 contract TheKids is ERC721A, Ownable {
1498   using Strings for uint256;
1499 
1500   string private uriPrefix = "";
1501   string private uriSuffix = ".json";
1502   string public hiddenMetadataUri = "";
1503   
1504   uint256 public MAX_SUPPLY = 9001; 
1505   uint256 public OG_MINT_PRICE = 0 ether;
1506   uint256 public WHITELIST_MINT_PRICE = 0.03 ether;
1507   uint256 public PUBLIC_MINT_PRICE = 0.05 ether;
1508   uint256 public MAX_OG_WHITELIST_MINT_AMOUNT = 3;
1509   uint256 public MAX_PUBLIC_MINT_AMOUNT = 4;
1510   uint256 public MAX_AMOUNT_PER_WALLET = 10;
1511 
1512   // MINT STATES
1513   bool public ogMintActive = true;
1514   bool public whiteListMintActive = false;
1515   bool public publicMintActive = false;
1516 
1517   bool public paused = true;
1518   bool public revealed = false;
1519 
1520   //Mint amounts per wallet
1521   mapping(address => uint256) private totalPublicMint;
1522   mapping(address => uint256) private totalWhiteListMint;
1523   mapping(address => uint256) private totalOGMint;
1524 
1525   bytes32 private whiteListMerkleRoot;
1526   bytes32 private ogListMerkleRoot;
1527 
1528   constructor() ERC721A("We The Kids", "KIDS") {
1529     setHiddenMetadataUri("https://kids.mypinata.cloud/ipfs/QmZEFAbQNiCT7DSEjhgp7dhRygGYmaptQPcXGX5wETRnbi/");
1530   }
1531   
1532   modifier mintModifier(uint256 _mintAmount) {
1533     require(!paused, "The contract is paused!");
1534     require(_mintAmount > 0, "invalid Mint amount");
1535     require(totalSupply() + _mintAmount <= MAX_SUPPLY, "Max supply exceeded!");
1536     require((totalOGMint[msg.sender] + totalWhiteListMint[msg.sender] + totalPublicMint[msg.sender]) <= MAX_AMOUNT_PER_WALLET,
1537       "maximum mint amount reached for this wallet");
1538     require(tx.origin == msg.sender, "No minting from contracts");
1539     _;
1540   }
1541 
1542   function mint(uint256 _mintAmount) public payable mintModifier(_mintAmount) {
1543     require(publicMintActive, "Public mint is not active :/");
1544     require((totalPublicMint[msg.sender] + _mintAmount) <= MAX_PUBLIC_MINT_AMOUNT, "Cannot Mint more than the public max amount");
1545 
1546     require(msg.value >= ( PUBLIC_MINT_PRICE * _mintAmount ), "Insufficient funds");
1547   
1548     totalPublicMint[msg.sender] += _mintAmount;
1549     _abstractMint(msg.sender, _mintAmount);
1550   }
1551 
1552   function whiteListMint(bytes32[] memory _merkleProof, uint256 _mintAmount) external payable mintModifier(_mintAmount) {
1553     require(whiteListMintActive, "Whitelist mint is not active :/");
1554     require((totalWhiteListMint[msg.sender] + _mintAmount) <= MAX_OG_WHITELIST_MINT_AMOUNT, "cannot Mint more than whitelist max amount");
1555 
1556     require(msg.value >= (WHITELIST_MINT_PRICE * _mintAmount), "Insufficient funds");
1557 
1558     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1559     require(MerkleProof.verify(_merkleProof, whiteListMerkleRoot, leaf), "Invalid Proof - Address not in the list!");
1560 
1561     totalWhiteListMint[msg.sender] += _mintAmount;
1562     _abstractMint(msg.sender, _mintAmount);
1563   }
1564 
1565   function ogListMint(bytes32[] memory _merkleProof, uint256 _mintAmount) external payable mintModifier(_mintAmount) {
1566     require(ogMintActive, "OG Mint is not active");
1567     require((totalOGMint[msg.sender] + _mintAmount) <= MAX_OG_WHITELIST_MINT_AMOUNT, "cannot mint more than OG max amount");
1568 
1569     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1570     require(MerkleProof.verify(_merkleProof, ogListMerkleRoot, leaf), "Invalid Proof - Address not in the list!");
1571 
1572     totalOGMint[msg.sender] += _mintAmount;
1573     _abstractMint(msg.sender, _mintAmount);
1574   }
1575 
1576   function teamMint(uint256 _mintAmount) public onlyOwner {
1577     _abstractMint(msg.sender, _mintAmount);
1578   }
1579 
1580   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1581     _abstractMint(_receiver, _mintAmount);
1582   }
1583 
1584   function setWhiteListMerkleRoot(bytes32 _root) public onlyOwner {
1585     whiteListMerkleRoot = _root;
1586   }
1587 
1588   function setOGMerkleRoot(bytes32 _root) public onlyOwner {
1589     ogListMerkleRoot = _root;
1590   }
1591 
1592   function setOriginalKidsMintState(bool _state) public onlyOwner {
1593     ogMintActive = _state;
1594   }
1595 
1596   function setWhiteListMintState(bool _state) public onlyOwner {
1597     whiteListMintActive = _state;
1598   }
1599 
1600   function setPublicMintState(bool _state) public onlyOwner {
1601     publicMintActive = _state;
1602   }
1603 
1604   function setRevealed(bool _state) public onlyOwner {
1605     revealed = _state;
1606   }
1607 
1608   function setOG_Cost(uint256 _cost) public onlyOwner {
1609     OG_MINT_PRICE = _cost;
1610   }
1611 
1612   function setWhitelistCost(uint256 _cost) public onlyOwner {
1613     WHITELIST_MINT_PRICE = _cost;
1614   }
1615 
1616   function setPublicCost(uint256 _cost) public onlyOwner {
1617     PUBLIC_MINT_PRICE = _cost;
1618   }
1619 
1620   function setMaxAmountPerOG_or_Whitelist(uint256 _maxMintAmountPerTx) public onlyOwner {
1621     MAX_OG_WHITELIST_MINT_AMOUNT = _maxMintAmountPerTx;
1622   }
1623 
1624   function setMaxAmountPerWallet(uint256 _maxAmountPerWallet) public onlyOwner {
1625     MAX_AMOUNT_PER_WALLET = _maxAmountPerWallet;
1626   }
1627 
1628   function setMaxAmountPublicMint(uint256 _maxMintAmountPublic) public onlyOwner {
1629     MAX_PUBLIC_MINT_AMOUNT = _maxMintAmountPublic;
1630   }
1631 
1632   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1633     hiddenMetadataUri = _hiddenMetadataUri;
1634   }
1635 
1636   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1637     uriPrefix = _uriPrefix;
1638   }
1639 
1640   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1641     uriSuffix = _uriSuffix;
1642   }
1643 
1644   function setPaused(bool _state) public onlyOwner {
1645     paused = _state;
1646   }
1647 
1648   function setMaxSupply(uint256 _max_supply) public onlyOwner {
1649     MAX_SUPPLY = _max_supply;
1650   }
1651 
1652   function withdraw() public onlyOwner {
1653     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1654     require(os);
1655   }
1656 
1657   function _abstractMint(address _receiver, uint256 _mintAmount) internal {
1658     _safeMint(_receiver, _mintAmount);
1659   }
1660 
1661   function _baseURI() internal view virtual override returns (string memory) {
1662     return uriPrefix;
1663   }
1664 
1665   function walletOf(address _owner) external view returns (uint256[] memory)  
1666   {
1667     uint256 ownerTokenCount = balanceOf(_owner);
1668     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1669     uint256 currentTokenId = 1;
1670     uint256 ownedTokenIndex = 0;
1671 
1672     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= MAX_SUPPLY) {
1673       address currentTokenOwner = ownerOf(currentTokenId);
1674       if (currentTokenOwner == _owner) {
1675         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1676 
1677         ownedTokenIndex++;
1678       }
1679       currentTokenId++;
1680     }
1681     return ownedTokenIds;
1682   }
1683 
1684   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory)
1685   {
1686     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1687 
1688     if (revealed == false) {
1689         return string(abi.encodePacked(hiddenMetadataUri, (_tokenId +1).toString(), uriSuffix));
1690          // if hidden show hidden metadata
1691     }
1692 
1693     string memory currentBaseURI = _baseURI(); //gets base uri for hosted image
1694     // appends the base uri to the token id + suffix to point to correct ipfs image
1695     return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, (_tokenId +1).toString(), uriSuffix)) : "";
1696   }
1697 }