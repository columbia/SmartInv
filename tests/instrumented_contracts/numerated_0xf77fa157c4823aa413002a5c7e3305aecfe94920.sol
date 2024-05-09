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
779 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
780 
781 
782 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
783 
784 pragma solidity ^0.8.0;
785 
786 
787 
788 
789 
790 
791 
792 
793 /**
794  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
795  * the Metadata extension, but not including the Enumerable extension, which is available separately as
796  * {ERC721Enumerable}.
797  */
798 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
799     using Address for address;
800     using Strings for uint256;
801 
802     // Token name
803     string private _name;
804 
805     // Token symbol
806     string private _symbol;
807 
808     // Mapping from token ID to owner address
809     mapping(uint256 => address) private _owners;
810 
811     // Mapping owner address to token count
812     mapping(address => uint256) private _balances;
813 
814     // Mapping from token ID to approved address
815     mapping(uint256 => address) private _tokenApprovals;
816 
817     // Mapping from owner to operator approvals
818     mapping(address => mapping(address => bool)) private _operatorApprovals;
819 
820     /**
821      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
822      */
823     constructor(string memory name_, string memory symbol_) {
824         _name = name_;
825         _symbol = symbol_;
826     }
827 
828     /**
829      * @dev See {IERC165-supportsInterface}.
830      */
831     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
832         return
833             interfaceId == type(IERC721).interfaceId ||
834             interfaceId == type(IERC721Metadata).interfaceId ||
835             super.supportsInterface(interfaceId);
836     }
837 
838     /**
839      * @dev See {IERC721-balanceOf}.
840      */
841     function balanceOf(address owner) public view virtual override returns (uint256) {
842         require(owner != address(0), "ERC721: balance query for the zero address");
843         return _balances[owner];
844     }
845 
846     /**
847      * @dev See {IERC721-ownerOf}.
848      */
849     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
850         address owner = _owners[tokenId];
851         require(owner != address(0), "ERC721: owner query for nonexistent token");
852         return owner;
853     }
854 
855     /**
856      * @dev See {IERC721Metadata-name}.
857      */
858     function name() public view virtual override returns (string memory) {
859         return _name;
860     }
861 
862     /**
863      * @dev See {IERC721Metadata-symbol}.
864      */
865     function symbol() public view virtual override returns (string memory) {
866         return _symbol;
867     }
868 
869     /**
870      * @dev See {IERC721Metadata-tokenURI}.
871      */
872     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
873         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
874 
875         string memory baseURI = _baseURI();
876         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
877     }
878 
879     /**
880      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
881      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
882      * by default, can be overridden in child contracts.
883      */
884     function _baseURI() internal view virtual returns (string memory) {
885         return "";
886     }
887 
888     /**
889      * @dev See {IERC721-approve}.
890      */
891     function approve(address to, uint256 tokenId) public virtual override {
892         address owner = ERC721.ownerOf(tokenId);
893         require(to != owner, "ERC721: approval to current owner");
894 
895         require(
896             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
897             "ERC721: approve caller is not owner nor approved for all"
898         );
899 
900         _approve(to, tokenId);
901     }
902 
903     /**
904      * @dev See {IERC721-getApproved}.
905      */
906     function getApproved(uint256 tokenId) public view virtual override returns (address) {
907         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
908 
909         return _tokenApprovals[tokenId];
910     }
911 
912     /**
913      * @dev See {IERC721-setApprovalForAll}.
914      */
915     function setApprovalForAll(address operator, bool approved) public virtual override {
916         _setApprovalForAll(_msgSender(), operator, approved);
917     }
918 
919     /**
920      * @dev See {IERC721-isApprovedForAll}.
921      */
922     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
923         return _operatorApprovals[owner][operator];
924     }
925 
926     /**
927      * @dev See {IERC721-transferFrom}.
928      */
929     function transferFrom(
930         address from,
931         address to,
932         uint256 tokenId
933     ) public virtual override {
934         //solhint-disable-next-line max-line-length
935         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
936 
937         _transfer(from, to, tokenId);
938     }
939 
940     /**
941      * @dev See {IERC721-safeTransferFrom}.
942      */
943     function safeTransferFrom(
944         address from,
945         address to,
946         uint256 tokenId
947     ) public virtual override {
948         safeTransferFrom(from, to, tokenId, "");
949     }
950 
951     /**
952      * @dev See {IERC721-safeTransferFrom}.
953      */
954     function safeTransferFrom(
955         address from,
956         address to,
957         uint256 tokenId,
958         bytes memory _data
959     ) public virtual override {
960         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
961         _safeTransfer(from, to, tokenId, _data);
962     }
963 
964     /**
965      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
966      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
967      *
968      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
969      *
970      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
971      * implement alternative mechanisms to perform token transfer, such as signature-based.
972      *
973      * Requirements:
974      *
975      * - `from` cannot be the zero address.
976      * - `to` cannot be the zero address.
977      * - `tokenId` token must exist and be owned by `from`.
978      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
979      *
980      * Emits a {Transfer} event.
981      */
982     function _safeTransfer(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) internal virtual {
988         _transfer(from, to, tokenId);
989         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
990     }
991 
992     /**
993      * @dev Returns whether `tokenId` exists.
994      *
995      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
996      *
997      * Tokens start existing when they are minted (`_mint`),
998      * and stop existing when they are burned (`_burn`).
999      */
1000     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1001         return _owners[tokenId] != address(0);
1002     }
1003 
1004     /**
1005      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1006      *
1007      * Requirements:
1008      *
1009      * - `tokenId` must exist.
1010      */
1011     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1012         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1013         address owner = ERC721.ownerOf(tokenId);
1014         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1015     }
1016 
1017     /**
1018      * @dev Safely mints `tokenId` and transfers it to `to`.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must not exist.
1023      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1024      *
1025      * Emits a {Transfer} event.
1026      */
1027     function _safeMint(address to, uint256 tokenId) internal virtual {
1028         _safeMint(to, tokenId, "");
1029     }
1030 
1031     /**
1032      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1033      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1034      */
1035     function _safeMint(
1036         address to,
1037         uint256 tokenId,
1038         bytes memory _data
1039     ) internal virtual {
1040         _mint(to, tokenId);
1041         require(
1042             _checkOnERC721Received(address(0), to, tokenId, _data),
1043             "ERC721: transfer to non ERC721Receiver implementer"
1044         );
1045     }
1046 
1047     /**
1048      * @dev Mints `tokenId` and transfers it to `to`.
1049      *
1050      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1051      *
1052      * Requirements:
1053      *
1054      * - `tokenId` must not exist.
1055      * - `to` cannot be the zero address.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _mint(address to, uint256 tokenId) internal virtual {
1060         require(to != address(0), "ERC721: mint to the zero address");
1061         require(!_exists(tokenId), "ERC721: token already minted");
1062 
1063         _beforeTokenTransfer(address(0), to, tokenId);
1064 
1065         _balances[to] += 1;
1066         _owners[tokenId] = to;
1067 
1068         emit Transfer(address(0), to, tokenId);
1069 
1070         _afterTokenTransfer(address(0), to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev Destroys `tokenId`.
1075      * The approval is cleared when the token is burned.
1076      *
1077      * Requirements:
1078      *
1079      * - `tokenId` must exist.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function _burn(uint256 tokenId) internal virtual {
1084         address owner = ERC721.ownerOf(tokenId);
1085 
1086         _beforeTokenTransfer(owner, address(0), tokenId);
1087 
1088         // Clear approvals
1089         _approve(address(0), tokenId);
1090 
1091         _balances[owner] -= 1;
1092         delete _owners[tokenId];
1093 
1094         emit Transfer(owner, address(0), tokenId);
1095 
1096         _afterTokenTransfer(owner, address(0), tokenId);
1097     }
1098 
1099     /**
1100      * @dev Transfers `tokenId` from `from` to `to`.
1101      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1102      *
1103      * Requirements:
1104      *
1105      * - `to` cannot be the zero address.
1106      * - `tokenId` token must be owned by `from`.
1107      *
1108      * Emits a {Transfer} event.
1109      */
1110     function _transfer(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) internal virtual {
1115         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1116         require(to != address(0), "ERC721: transfer to the zero address");
1117 
1118         _beforeTokenTransfer(from, to, tokenId);
1119 
1120         // Clear approvals from the previous owner
1121         _approve(address(0), tokenId);
1122 
1123         _balances[from] -= 1;
1124         _balances[to] += 1;
1125         _owners[tokenId] = to;
1126 
1127         emit Transfer(from, to, tokenId);
1128 
1129         _afterTokenTransfer(from, to, tokenId);
1130     }
1131 
1132     /**
1133      * @dev Approve `to` to operate on `tokenId`
1134      *
1135      * Emits a {Approval} event.
1136      */
1137     function _approve(address to, uint256 tokenId) internal virtual {
1138         _tokenApprovals[tokenId] = to;
1139         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1140     }
1141 
1142     /**
1143      * @dev Approve `operator` to operate on all of `owner` tokens
1144      *
1145      * Emits a {ApprovalForAll} event.
1146      */
1147     function _setApprovalForAll(
1148         address owner,
1149         address operator,
1150         bool approved
1151     ) internal virtual {
1152         require(owner != operator, "ERC721: approve to caller");
1153         _operatorApprovals[owner][operator] = approved;
1154         emit ApprovalForAll(owner, operator, approved);
1155     }
1156 
1157     /**
1158      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1159      * The call is not executed if the target address is not a contract.
1160      *
1161      * @param from address representing the previous owner of the given token ID
1162      * @param to target address that will receive the tokens
1163      * @param tokenId uint256 ID of the token to be transferred
1164      * @param _data bytes optional data to send along with the call
1165      * @return bool whether the call correctly returned the expected magic value
1166      */
1167     function _checkOnERC721Received(
1168         address from,
1169         address to,
1170         uint256 tokenId,
1171         bytes memory _data
1172     ) private returns (bool) {
1173         if (to.isContract()) {
1174             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1175                 return retval == IERC721Receiver.onERC721Received.selector;
1176             } catch (bytes memory reason) {
1177                 if (reason.length == 0) {
1178                     revert("ERC721: transfer to non ERC721Receiver implementer");
1179                 } else {
1180                     assembly {
1181                         revert(add(32, reason), mload(reason))
1182                     }
1183                 }
1184             }
1185         } else {
1186             return true;
1187         }
1188     }
1189 
1190     /**
1191      * @dev Hook that is called before any token transfer. This includes minting
1192      * and burning.
1193      *
1194      * Calling conditions:
1195      *
1196      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1197      * transferred to `to`.
1198      * - When `from` is zero, `tokenId` will be minted for `to`.
1199      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1200      * - `from` and `to` are never both zero.
1201      *
1202      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1203      */
1204     function _beforeTokenTransfer(
1205         address from,
1206         address to,
1207         uint256 tokenId
1208     ) internal virtual {}
1209 
1210     /**
1211      * @dev Hook that is called after any transfer of tokens. This includes
1212      * minting and burning.
1213      *
1214      * Calling conditions:
1215      *
1216      * - when `from` and `to` are both non-zero.
1217      * - `from` and `to` are never both zero.
1218      *
1219      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1220      */
1221     function _afterTokenTransfer(
1222         address from,
1223         address to,
1224         uint256 tokenId
1225     ) internal virtual {}
1226 }
1227 
1228 // File: contracts/KaziV2.sol
1229 
1230 
1231 
1232 pragma solidity >=0.7.0 <0.9.0;
1233 
1234 
1235 
1236 
1237 
1238 contract KaziContract is ERC721, Ownable {
1239   using Strings for uint256;
1240   using Counters for Counters.Counter;
1241 
1242   Counters.Counter private supply;
1243 
1244   bytes32 public root = 0x6584ca7f18181ef50fe9120f31f5e42b7ae02c44893c217fe0f7407e8bcc8ae1;
1245 
1246   mapping(address => bool) public whitelistClaimed;
1247 
1248   string public uriPrefix = "";
1249   string public uriSuffix = ".json";
1250   string public hiddenMetadataUri;  
1251 
1252   uint256 private cost = 0.0025 ether;
1253   uint256 public maxSupply = 3000;
1254   uint256 public maxMintAmount = 2;
1255 
1256   bool public paused = true;
1257   bool public revealed = false;
1258   bool public whitelistMintEnabled = true;
1259 
1260   constructor() ERC721("KaziNFT", "KAZI") {
1261     setHiddenMetadataUri("ipfs://QmRcZ3tqvQ9gBfiTQgaqFNEDBMEP4112Q8HYR964WuTQRT/hidden.json");
1262   }
1263 
1264   modifier mintCompliance(uint256 _mintAmount) {
1265     require(_mintAmount > 0 && _mintAmount <= maxMintAmount, 'Invalid mint amount!');
1266     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1267     _;
1268   }
1269 
1270   modifier mintPriceCompliance(uint256 _mintAmount) {
1271     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1272     _;
1273   }
1274 
1275   function totalSupply() public view returns (uint256) {
1276     return supply.current();
1277   }
1278 
1279   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1280     require(!paused, "The contract is paused!");
1281     require(msg.value >= cost * _mintAmount, "Insufficient funds!");
1282 
1283     _mintLoop(msg.sender, _mintAmount);
1284   }
1285   
1286   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1287     _mintLoop(_receiver, _mintAmount);
1288   }
1289 
1290   function walletOfOwner(address _owner)
1291     private
1292     view
1293     returns (uint256[] memory)
1294   {
1295     uint256 ownerTokenCount = balanceOf(_owner);
1296     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1297     uint256 currentTokenId = 1;
1298     uint256 ownedTokenIndex = 0;
1299 
1300     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1301       address currentTokenOwner = ownerOf(currentTokenId);
1302 
1303       if (currentTokenOwner == _owner) {
1304         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1305 
1306         ownedTokenIndex++;
1307       }
1308 
1309       currentTokenId++;
1310     }
1311 
1312     return ownedTokenIds;
1313   }
1314 
1315   function tokenURI(uint256 _tokenId)
1316     public
1317     view
1318     virtual
1319     override
1320     returns (string memory)
1321   {
1322     require(
1323       _exists(_tokenId),
1324       "ERC721Metadata: URI query for nonexistent token"
1325     );
1326 
1327     if (revealed == false) {
1328       return hiddenMetadataUri;
1329     }
1330 
1331     string memory currentBaseURI = _baseURI();
1332     return bytes(currentBaseURI).length > 0
1333         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1334         : "";
1335   }
1336 
1337   function setRevealed(bool _state) public onlyOwner {
1338     revealed = _state;
1339   }
1340 
1341   function setCost(uint256 _cost) private onlyOwner {
1342     cost = _cost;
1343   }
1344 
1345   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1346     hiddenMetadataUri = _hiddenMetadataUri;
1347   }
1348 
1349   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1350     uriPrefix = _uriPrefix;
1351   }
1352 
1353   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1354     uriSuffix = _uriSuffix;
1355   }
1356 
1357   function setPaused(bool _state) public onlyOwner {
1358     paused = _state;
1359   }
1360 
1361   function withdraw() public onlyOwner {
1362     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1363     require(os);
1364   }
1365 
1366   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1367     for (uint256 i = 0; i < _mintAmount; i++) {
1368       supply.increment();
1369       _safeMint(_receiver, supply.current());
1370     }
1371   }
1372 
1373   function _baseURI() internal view virtual override returns (string memory) {
1374     return uriPrefix;
1375   }
1376 
1377   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1378     maxMintAmount = _newmaxMintAmount;
1379   }
1380 
1381   function setWhitelistMintEnabled(bool _state) public onlyOwner {
1382     whitelistMintEnabled = _state;
1383   }
1384 
1385   function checkValidity(bytes32[] calldata _merkleProof) public view returns (bool){
1386         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1387         require(MerkleProof.verify(_merkleProof, root, leaf), "IGNORE THIS ERROR: Correct proof given");
1388         return true; // Or you can mint tokens here
1389     }
1390 }