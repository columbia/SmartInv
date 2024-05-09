1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
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
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
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
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/Counters.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @title Counters
78  * @author Matt Condon (@shrugs)
79  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
80  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
81  *
82  * Include with `using Counters for Counters.Counter;`
83  */
84 library Counters {
85     struct Counter {
86         // This variable should never be directly accessed by users of the library: interactions must be restricted to
87         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
88         // this feature: see https://github.com/ethereum/solidity/issues/4637
89         uint256 _value; // default: 0
90     }
91 
92     function current(Counter storage counter) internal view returns (uint256) {
93         return counter._value;
94     }
95 
96     function increment(Counter storage counter) internal {
97         unchecked {
98             counter._value += 1;
99         }
100     }
101 
102     function decrement(Counter storage counter) internal {
103         uint256 value = counter._value;
104         require(value > 0, "Counter: decrement overflow");
105         unchecked {
106             counter._value = value - 1;
107         }
108     }
109 
110     function reset(Counter storage counter) internal {
111         counter._value = 0;
112     }
113 }
114 
115 // File: @openzeppelin/contracts/utils/Strings.sol
116 
117 
118 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
119 
120 pragma solidity ^0.8.0;
121 
122 /**
123  * @dev String operations.
124  */
125 library Strings {
126     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
130      */
131     function toString(uint256 value) internal pure returns (string memory) {
132         // Inspired by OraclizeAPI's implementation - MIT licence
133         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
134 
135         if (value == 0) {
136             return "0";
137         }
138         uint256 temp = value;
139         uint256 digits;
140         while (temp != 0) {
141             digits++;
142             temp /= 10;
143         }
144         bytes memory buffer = new bytes(digits);
145         while (value != 0) {
146             digits -= 1;
147             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
148             value /= 10;
149         }
150         return string(buffer);
151     }
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
155      */
156     function toHexString(uint256 value) internal pure returns (string memory) {
157         if (value == 0) {
158             return "0x00";
159         }
160         uint256 temp = value;
161         uint256 length = 0;
162         while (temp != 0) {
163             length++;
164             temp >>= 8;
165         }
166         return toHexString(value, length);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
171      */
172     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
173         bytes memory buffer = new bytes(2 * length + 2);
174         buffer[0] = "0";
175         buffer[1] = "x";
176         for (uint256 i = 2 * length + 1; i > 1; --i) {
177             buffer[i] = _HEX_SYMBOLS[value & 0xf];
178             value >>= 4;
179         }
180         require(value == 0, "Strings: hex length insufficient");
181         return string(buffer);
182     }
183 }
184 
185 // File: @openzeppelin/contracts/utils/Context.sol
186 
187 
188 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev Provides information about the current execution context, including the
194  * sender of the transaction and its data. While these are generally available
195  * via msg.sender and msg.data, they should not be accessed in such a direct
196  * manner, since when dealing with meta-transactions the account sending and
197  * paying for execution may not be the actual sender (as far as an application
198  * is concerned).
199  *
200  * This contract is only required for intermediate, library-like contracts.
201  */
202 abstract contract Context {
203     function _msgSender() internal view virtual returns (address) {
204         return msg.sender;
205     }
206 
207     function _msgData() internal view virtual returns (bytes calldata) {
208         return msg.data;
209     }
210 }
211 
212 // File: @openzeppelin/contracts/access/Ownable.sol
213 
214 
215 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
216 
217 pragma solidity ^0.8.0;
218 
219 
220 /**
221  * @dev Contract module which provides a basic access control mechanism, where
222  * there is an account (an owner) that can be granted exclusive access to
223  * specific functions.
224  *
225  * By default, the owner account will be the one that deploys the contract. This
226  * can later be changed with {transferOwnership}.
227  *
228  * This module is used through inheritance. It will make available the modifier
229  * `onlyOwner`, which can be applied to your functions to restrict their use to
230  * the owner.
231  */
232 abstract contract Ownable is Context {
233     address private _owner;
234 
235     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237     /**
238      * @dev Initializes the contract setting the deployer as the initial owner.
239      */
240     constructor() {
241         _transferOwnership(_msgSender());
242     }
243 
244     /**
245      * @dev Returns the address of the current owner.
246      */
247     function owner() public view virtual returns (address) {
248         return _owner;
249     }
250 
251     /**
252      * @dev Throws if called by any account other than the owner.
253      */
254     modifier onlyOwner() {
255         require(owner() == _msgSender(), "Ownable: caller is not the owner");
256         _;
257     }
258 
259     /**
260      * @dev Leaves the contract without owner. It will not be possible to call
261      * `onlyOwner` functions anymore. Can only be called by the current owner.
262      *
263      * NOTE: Renouncing ownership will leave the contract without an owner,
264      * thereby removing any functionality that is only available to the owner.
265      */
266     function renounceOwnership() public virtual onlyOwner {
267         _transferOwnership(address(0));
268     }
269 
270     /**
271      * @dev Transfers ownership of the contract to a new account (`newOwner`).
272      * Can only be called by the current owner.
273      */
274     function transferOwnership(address newOwner) public virtual onlyOwner {
275         require(newOwner != address(0), "Ownable: new owner is the zero address");
276         _transferOwnership(newOwner);
277     }
278 
279     /**
280      * @dev Transfers ownership of the contract to a new account (`newOwner`).
281      * Internal function without access restriction.
282      */
283     function _transferOwnership(address newOwner) internal virtual {
284         address oldOwner = _owner;
285         _owner = newOwner;
286         emit OwnershipTransferred(oldOwner, newOwner);
287     }
288 }
289 
290 // File: @openzeppelin/contracts/utils/Address.sol
291 
292 
293 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
294 
295 pragma solidity ^0.8.1;
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      *
318      * [IMPORTANT]
319      * ====
320      * You shouldn't rely on `isContract` to protect against flash loan attacks!
321      *
322      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
323      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
324      * constructor.
325      * ====
326      */
327     function isContract(address account) internal view returns (bool) {
328         // This method relies on extcodesize/address.code.length, which returns 0
329         // for contracts in construction, since the code is only stored at the end
330         // of the constructor execution.
331 
332         return account.code.length > 0;
333     }
334 
335     /**
336      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
337      * `recipient`, forwarding all available gas and reverting on errors.
338      *
339      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
340      * of certain opcodes, possibly making contracts go over the 2300 gas limit
341      * imposed by `transfer`, making them unable to receive funds via
342      * `transfer`. {sendValue} removes this limitation.
343      *
344      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
345      *
346      * IMPORTANT: because control is transferred to `recipient`, care must be
347      * taken to not create reentrancy vulnerabilities. Consider using
348      * {ReentrancyGuard} or the
349      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
350      */
351     function sendValue(address payable recipient, uint256 amount) internal {
352         require(address(this).balance >= amount, "Address: insufficient balance");
353 
354         (bool success, ) = recipient.call{value: amount}("");
355         require(success, "Address: unable to send value, recipient may have reverted");
356     }
357 
358     /**
359      * @dev Performs a Solidity function call using a low level `call`. A
360      * plain `call` is an unsafe replacement for a function call: use this
361      * function instead.
362      *
363      * If `target` reverts with a revert reason, it is bubbled up by this
364      * function (like regular Solidity function calls).
365      *
366      * Returns the raw returned data. To convert to the expected return value,
367      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
368      *
369      * Requirements:
370      *
371      * - `target` must be a contract.
372      * - calling `target` with `data` must not revert.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
377         return functionCall(target, data, "Address: low-level call failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
382      * `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCall(
387         address target,
388         bytes memory data,
389         string memory errorMessage
390     ) internal returns (bytes memory) {
391         return functionCallWithValue(target, data, 0, errorMessage);
392     }
393 
394     /**
395      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
396      * but also transferring `value` wei to `target`.
397      *
398      * Requirements:
399      *
400      * - the calling contract must have an ETH balance of at least `value`.
401      * - the called Solidity function must be `payable`.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(
406         address target,
407         bytes memory data,
408         uint256 value
409     ) internal returns (bytes memory) {
410         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
415      * with `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCallWithValue(
420         address target,
421         bytes memory data,
422         uint256 value,
423         string memory errorMessage
424     ) internal returns (bytes memory) {
425         require(address(this).balance >= value, "Address: insufficient balance for call");
426         require(isContract(target), "Address: call to non-contract");
427 
428         (bool success, bytes memory returndata) = target.call{value: value}(data);
429         return verifyCallResult(success, returndata, errorMessage);
430     }
431 
432     /**
433      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
434      * but performing a static call.
435      *
436      * _Available since v3.3._
437      */
438     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
439         return functionStaticCall(target, data, "Address: low-level static call failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
444      * but performing a static call.
445      *
446      * _Available since v3.3._
447      */
448     function functionStaticCall(
449         address target,
450         bytes memory data,
451         string memory errorMessage
452     ) internal view returns (bytes memory) {
453         require(isContract(target), "Address: static call to non-contract");
454 
455         (bool success, bytes memory returndata) = target.staticcall(data);
456         return verifyCallResult(success, returndata, errorMessage);
457     }
458 
459     /**
460      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
461      * but performing a delegate call.
462      *
463      * _Available since v3.4._
464      */
465     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
466         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
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
517 
518 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @title ERC721 token receiver interface
524  * @dev Interface for any contract that wants to support safeTransfers
525  * from ERC721 asset contracts.
526  */
527 interface IERC721Receiver {
528     /**
529      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
530      * by `operator` from `from`, this function is called.
531      *
532      * It must return its Solidity selector to confirm the token transfer.
533      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
534      *
535      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
536      */
537     function onERC721Received(
538         address operator,
539         address from,
540         uint256 tokenId,
541         bytes calldata data
542     ) external returns (bytes4);
543 }
544 
545 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
546 
547 
548 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
549 
550 pragma solidity ^0.8.0;
551 
552 /**
553  * @dev Interface of the ERC165 standard, as defined in the
554  * https://eips.ethereum.org/EIPS/eip-165[EIP].
555  *
556  * Implementers can declare support of contract interfaces, which can then be
557  * queried by others ({ERC165Checker}).
558  *
559  * For an implementation, see {ERC165}.
560  */
561 interface IERC165 {
562     /**
563      * @dev Returns true if this contract implements the interface defined by
564      * `interfaceId`. See the corresponding
565      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
566      * to learn more about how these ids are created.
567      *
568      * This function call must use less than 30 000 gas.
569      */
570     function supportsInterface(bytes4 interfaceId) external view returns (bool);
571 }
572 
573 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
574 
575 
576 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 
581 /**
582  * @dev Implementation of the {IERC165} interface.
583  *
584  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
585  * for the additional interface id that will be supported. For example:
586  *
587  * ```solidity
588  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
589  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
590  * }
591  * ```
592  *
593  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
594  */
595 abstract contract ERC165 is IERC165 {
596     /**
597      * @dev See {IERC165-supportsInterface}.
598      */
599     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
600         return interfaceId == type(IERC165).interfaceId;
601     }
602 }
603 
604 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
605 
606 
607 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 
612 /**
613  * @dev Required interface of an ERC721 compliant contract.
614  */
615 interface IERC721 is IERC165 {
616     /**
617      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
618      */
619     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
620 
621     /**
622      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
623      */
624     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
625 
626     /**
627      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
628      */
629     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
630 
631     /**
632      * @dev Returns the number of tokens in ``owner``'s account.
633      */
634     function balanceOf(address owner) external view returns (uint256 balance);
635 
636     /**
637      * @dev Returns the owner of the `tokenId` token.
638      *
639      * Requirements:
640      *
641      * - `tokenId` must exist.
642      */
643     function ownerOf(uint256 tokenId) external view returns (address owner);
644 
645     /**
646      * @dev Safely transfers `tokenId` token from `from` to `to`.
647      *
648      * Requirements:
649      *
650      * - `from` cannot be the zero address.
651      * - `to` cannot be the zero address.
652      * - `tokenId` token must exist and be owned by `from`.
653      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
654      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
655      *
656      * Emits a {Transfer} event.
657      */
658     function safeTransferFrom(
659         address from,
660         address to,
661         uint256 tokenId,
662         bytes calldata data
663     ) external;
664 
665     /**
666      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
667      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
668      *
669      * Requirements:
670      *
671      * - `from` cannot be the zero address.
672      * - `to` cannot be the zero address.
673      * - `tokenId` token must exist and be owned by `from`.
674      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
676      *
677      * Emits a {Transfer} event.
678      */
679     function safeTransferFrom(
680         address from,
681         address to,
682         uint256 tokenId
683     ) external;
684 
685     /**
686      * @dev Transfers `tokenId` token from `from` to `to`.
687      *
688      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
689      *
690      * Requirements:
691      *
692      * - `from` cannot be the zero address.
693      * - `to` cannot be the zero address.
694      * - `tokenId` token must be owned by `from`.
695      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
696      *
697      * Emits a {Transfer} event.
698      */
699     function transferFrom(
700         address from,
701         address to,
702         uint256 tokenId
703     ) external;
704 
705     /**
706      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
707      * The approval is cleared when the token is transferred.
708      *
709      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
710      *
711      * Requirements:
712      *
713      * - The caller must own the token or be an approved operator.
714      * - `tokenId` must exist.
715      *
716      * Emits an {Approval} event.
717      */
718     function approve(address to, uint256 tokenId) external;
719 
720     /**
721      * @dev Approve or remove `operator` as an operator for the caller.
722      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
723      *
724      * Requirements:
725      *
726      * - The `operator` cannot be the caller.
727      *
728      * Emits an {ApprovalForAll} event.
729      */
730     function setApprovalForAll(address operator, bool _approved) external;
731 
732     /**
733      * @dev Returns the account approved for `tokenId` token.
734      *
735      * Requirements:
736      *
737      * - `tokenId` must exist.
738      */
739     function getApproved(uint256 tokenId) external view returns (address operator);
740 
741     /**
742      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
743      *
744      * See {setApprovalForAll}
745      */
746     function isApprovedForAll(address owner, address operator) external view returns (bool);
747 }
748 
749 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 
757 /**
758  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
759  * @dev See https://eips.ethereum.org/EIPS/eip-721
760  */
761 interface IERC721Metadata is IERC721 {
762     /**
763      * @dev Returns the token collection name.
764      */
765     function name() external view returns (string memory);
766 
767     /**
768      * @dev Returns the token collection symbol.
769      */
770     function symbol() external view returns (string memory);
771 
772     /**
773      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
774      */
775     function tokenURI(uint256 tokenId) external view returns (string memory);
776 }
777 
778 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
779 
780 
781 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 
786 
787 
788 
789 
790 
791 
792 /**
793  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
794  * the Metadata extension, but not including the Enumerable extension, which is available separately as
795  * {ERC721Enumerable}.
796  */
797 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
798     using Address for address;
799     using Strings for uint256;
800 
801     // Token name
802     string private _name;
803 
804     // Token symbol
805     string private _symbol;
806 
807     // Mapping from token ID to owner address
808     mapping(uint256 => address) private _owners;
809 
810     // Mapping owner address to token count
811     mapping(address => uint256) private _balances;
812 
813     // Mapping from token ID to approved address
814     mapping(uint256 => address) private _tokenApprovals;
815 
816     // Mapping from owner to operator approvals
817     mapping(address => mapping(address => bool)) private _operatorApprovals;
818 
819     /**
820      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
821      */
822     constructor(string memory name_, string memory symbol_) {
823         _name = name_;
824         _symbol = symbol_;
825     }
826 
827     /**
828      * @dev See {IERC165-supportsInterface}.
829      */
830     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
831         return
832             interfaceId == type(IERC721).interfaceId ||
833             interfaceId == type(IERC721Metadata).interfaceId ||
834             super.supportsInterface(interfaceId);
835     }
836 
837     /**
838      * @dev See {IERC721-balanceOf}.
839      */
840     function balanceOf(address owner) public view virtual override returns (uint256) {
841         require(owner != address(0), "ERC721: balance query for the zero address");
842         return _balances[owner];
843     }
844 
845     /**
846      * @dev See {IERC721-ownerOf}.
847      */
848     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
849         address owner = _owners[tokenId];
850         require(owner != address(0), "ERC721: owner query for nonexistent token");
851         return owner;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-name}.
856      */
857     function name() public view virtual override returns (string memory) {
858         return _name;
859     }
860 
861     /**
862      * @dev See {IERC721Metadata-symbol}.
863      */
864     function symbol() public view virtual override returns (string memory) {
865         return _symbol;
866     }
867 
868     /**
869      * @dev See {IERC721Metadata-tokenURI}.
870      */
871     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
872         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
873 
874         string memory baseURI = _baseURI();
875         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
876     }
877 
878     /**
879      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
880      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
881      * by default, can be overridden in child contracts.
882      */
883     function _baseURI() internal view virtual returns (string memory) {
884         return "";
885     }
886 
887     /**
888      * @dev See {IERC721-approve}.
889      */
890     function approve(address to, uint256 tokenId) public virtual override {
891         address owner = ERC721.ownerOf(tokenId);
892         require(to != owner, "ERC721: approval to current owner");
893 
894         require(
895             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
896             "ERC721: approve caller is not owner nor approved for all"
897         );
898 
899         _approve(to, tokenId);
900     }
901 
902     /**
903      * @dev See {IERC721-getApproved}.
904      */
905     function getApproved(uint256 tokenId) public view virtual override returns (address) {
906         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
907 
908         return _tokenApprovals[tokenId];
909     }
910 
911     /**
912      * @dev See {IERC721-setApprovalForAll}.
913      */
914     function setApprovalForAll(address operator, bool approved) public virtual override {
915         _setApprovalForAll(_msgSender(), operator, approved);
916     }
917 
918     /**
919      * @dev See {IERC721-isApprovedForAll}.
920      */
921     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
922         return _operatorApprovals[owner][operator];
923     }
924 
925     /**
926      * @dev See {IERC721-transferFrom}.
927      */
928     function transferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) public virtual override {
933         //solhint-disable-next-line max-line-length
934         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
935 
936         _transfer(from, to, tokenId);
937     }
938 
939     /**
940      * @dev See {IERC721-safeTransferFrom}.
941      */
942     function safeTransferFrom(
943         address from,
944         address to,
945         uint256 tokenId
946     ) public virtual override {
947         safeTransferFrom(from, to, tokenId, "");
948     }
949 
950     /**
951      * @dev See {IERC721-safeTransferFrom}.
952      */
953     function safeTransferFrom(
954         address from,
955         address to,
956         uint256 tokenId,
957         bytes memory _data
958     ) public virtual override {
959         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
960         _safeTransfer(from, to, tokenId, _data);
961     }
962 
963     /**
964      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
965      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
966      *
967      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
968      *
969      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
970      * implement alternative mechanisms to perform token transfer, such as signature-based.
971      *
972      * Requirements:
973      *
974      * - `from` cannot be the zero address.
975      * - `to` cannot be the zero address.
976      * - `tokenId` token must exist and be owned by `from`.
977      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
978      *
979      * Emits a {Transfer} event.
980      */
981     function _safeTransfer(
982         address from,
983         address to,
984         uint256 tokenId,
985         bytes memory _data
986     ) internal virtual {
987         _transfer(from, to, tokenId);
988         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
989     }
990 
991     /**
992      * @dev Returns whether `tokenId` exists.
993      *
994      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
995      *
996      * Tokens start existing when they are minted (`_mint`),
997      * and stop existing when they are burned (`_burn`).
998      */
999     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1000         return _owners[tokenId] != address(0);
1001     }
1002 
1003     /**
1004      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1005      *
1006      * Requirements:
1007      *
1008      * - `tokenId` must exist.
1009      */
1010     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1011         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1012         address owner = ERC721.ownerOf(tokenId);
1013         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1014     }
1015 
1016     /**
1017      * @dev Safely mints `tokenId` and transfers it to `to`.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must not exist.
1022      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _safeMint(address to, uint256 tokenId) internal virtual {
1027         _safeMint(to, tokenId, "");
1028     }
1029 
1030     /**
1031      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1032      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1033      */
1034     function _safeMint(
1035         address to,
1036         uint256 tokenId,
1037         bytes memory _data
1038     ) internal virtual {
1039         _mint(to, tokenId);
1040         require(
1041             _checkOnERC721Received(address(0), to, tokenId, _data),
1042             "ERC721: transfer to non ERC721Receiver implementer"
1043         );
1044     }
1045 
1046     /**
1047      * @dev Mints `tokenId` and transfers it to `to`.
1048      *
1049      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must not exist.
1054      * - `to` cannot be the zero address.
1055      *
1056      * Emits a {Transfer} event.
1057      */
1058     function _mint(address to, uint256 tokenId) internal virtual {
1059         require(to != address(0), "ERC721: mint to the zero address");
1060         require(!_exists(tokenId), "ERC721: token already minted");
1061 
1062         _beforeTokenTransfer(address(0), to, tokenId);
1063 
1064         _balances[to] += 1;
1065         _owners[tokenId] = to;
1066 
1067         emit Transfer(address(0), to, tokenId);
1068 
1069         _afterTokenTransfer(address(0), to, tokenId);
1070     }
1071 
1072     /**
1073      * @dev Destroys `tokenId`.
1074      * The approval is cleared when the token is burned.
1075      *
1076      * Requirements:
1077      *
1078      * - `tokenId` must exist.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function _burn(uint256 tokenId) internal virtual {
1083         address owner = ERC721.ownerOf(tokenId);
1084 
1085         _beforeTokenTransfer(owner, address(0), tokenId);
1086 
1087         // Clear approvals
1088         _approve(address(0), tokenId);
1089 
1090         _balances[owner] -= 1;
1091         delete _owners[tokenId];
1092 
1093         emit Transfer(owner, address(0), tokenId);
1094 
1095         _afterTokenTransfer(owner, address(0), tokenId);
1096     }
1097 
1098     /**
1099      * @dev Transfers `tokenId` from `from` to `to`.
1100      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1101      *
1102      * Requirements:
1103      *
1104      * - `to` cannot be the zero address.
1105      * - `tokenId` token must be owned by `from`.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _transfer(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) internal virtual {
1114         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1115         require(to != address(0), "ERC721: transfer to the zero address");
1116 
1117         _beforeTokenTransfer(from, to, tokenId);
1118 
1119         // Clear approvals from the previous owner
1120         _approve(address(0), tokenId);
1121 
1122         _balances[from] -= 1;
1123         _balances[to] += 1;
1124         _owners[tokenId] = to;
1125 
1126         emit Transfer(from, to, tokenId);
1127 
1128         _afterTokenTransfer(from, to, tokenId);
1129     }
1130 
1131     /**
1132      * @dev Approve `to` to operate on `tokenId`
1133      *
1134      * Emits a {Approval} event.
1135      */
1136     function _approve(address to, uint256 tokenId) internal virtual {
1137         _tokenApprovals[tokenId] = to;
1138         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1139     }
1140 
1141     /**
1142      * @dev Approve `operator` to operate on all of `owner` tokens
1143      *
1144      * Emits a {ApprovalForAll} event.
1145      */
1146     function _setApprovalForAll(
1147         address owner,
1148         address operator,
1149         bool approved
1150     ) internal virtual {
1151         require(owner != operator, "ERC721: approve to caller");
1152         _operatorApprovals[owner][operator] = approved;
1153         emit ApprovalForAll(owner, operator, approved);
1154     }
1155 
1156     /**
1157      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1158      * The call is not executed if the target address is not a contract.
1159      *
1160      * @param from address representing the previous owner of the given token ID
1161      * @param to target address that will receive the tokens
1162      * @param tokenId uint256 ID of the token to be transferred
1163      * @param _data bytes optional data to send along with the call
1164      * @return bool whether the call correctly returned the expected magic value
1165      */
1166     function _checkOnERC721Received(
1167         address from,
1168         address to,
1169         uint256 tokenId,
1170         bytes memory _data
1171     ) private returns (bool) {
1172         if (to.isContract()) {
1173             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1174                 return retval == IERC721Receiver.onERC721Received.selector;
1175             } catch (bytes memory reason) {
1176                 if (reason.length == 0) {
1177                     revert("ERC721: transfer to non ERC721Receiver implementer");
1178                 } else {
1179                     assembly {
1180                         revert(add(32, reason), mload(reason))
1181                     }
1182                 }
1183             }
1184         } else {
1185             return true;
1186         }
1187     }
1188 
1189     /**
1190      * @dev Hook that is called before any token transfer. This includes minting
1191      * and burning.
1192      *
1193      * Calling conditions:
1194      *
1195      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1196      * transferred to `to`.
1197      * - When `from` is zero, `tokenId` will be minted for `to`.
1198      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1199      * - `from` and `to` are never both zero.
1200      *
1201      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1202      */
1203     function _beforeTokenTransfer(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) internal virtual {}
1208 
1209     /**
1210      * @dev Hook that is called after any transfer of tokens. This includes
1211      * minting and burning.
1212      *
1213      * Calling conditions:
1214      *
1215      * - when `from` and `to` are both non-zero.
1216      * - `from` and `to` are never both zero.
1217      *
1218      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1219      */
1220     function _afterTokenTransfer(
1221         address from,
1222         address to,
1223         uint256 tokenId
1224     ) internal virtual {}
1225 }
1226 
1227 // File: alphabulls.sol
1228 
1229 
1230 pragma solidity >=0.7.0 <0.9.0;
1231 
1232 
1233 
1234 
1235 
1236 
1237 contract AlphaBulls is ERC721, Ownable {
1238     using Strings for uint256;
1239     using Counters for Counters.Counter;
1240 
1241     Counters.Counter private supply;
1242 
1243     // URI
1244     string public uriPrefix = "ipfs://QmYVc4UdyZbHvWNLhgQHSwyLP3XQV6LeNbDd7xUMqAhA1Q/";
1245     string public uriSuffix = ".json";
1246     string public hiddenMetadataURI;
1247     
1248     // Cost
1249     uint256 public presaleCost = 0.055 ether;
1250     uint256 public publicsaleCost = 0.077 ether;
1251 
1252     // Supply
1253     uint256 public maxSupply = 7777;
1254     uint256 public maxSupplyLimit = 7777;
1255     
1256     uint256 public freesaleSupply = 777;
1257 
1258     // Per Address & TX Limit
1259     uint256 public nftFreesalePerAddressLimit = 1;
1260     uint256 public nftPresalePerAddressLimit = 2;
1261     uint256 public nftPublicsalePerAddressLimit = 10;
1262 
1263     // States
1264     bool public paused = true;
1265     
1266     bool public freesale = true;
1267     bool public presale = false;
1268 
1269     bool public revealed = false;
1270 
1271     // Minted Balance
1272     mapping(address => uint256) public addressFreesaleMintedBalance;
1273     mapping(address => uint256) public addressPresaleMintedBalance;
1274     mapping(address => uint256) public addressPublicsaleMintedBalance;
1275 
1276     // Merkle Tree Root
1277     bytes32 public freesaleMerkleTreeRoot;
1278     bytes32 public presaleMerkleTreeRoot;
1279 
1280     // Constructor
1281     constructor(bytes32 _freesaleMerkleTreeRoot, bytes32 _presaleMerkleTreeRoot) ERC721("Alpha Bulls", "AB") {
1282         setHiddenMetadataURI("ipfs://QmSyEc7chRFiopb23ckpAXt19iL4W7Efne9NgKNjjXxJdp/");
1283 
1284         freesaleMerkleTreeRoot = _freesaleMerkleTreeRoot;
1285         presaleMerkleTreeRoot = _presaleMerkleTreeRoot;
1286     }
1287 
1288     // Functions: URI
1289     function _baseURI() internal view virtual override returns (string memory) {
1290         return uriPrefix;
1291     }
1292 
1293     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1294         uriPrefix = _uriPrefix;
1295     }
1296 
1297     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1298         uriSuffix = _uriSuffix;
1299     }
1300 
1301     function setHiddenMetadataURI(string memory _hiddenMetadataURI) public onlyOwner {
1302         hiddenMetadataURI = _hiddenMetadataURI;
1303     }
1304 
1305     // Functions: Cost
1306     function setPresaleCost(uint256 _cost) public onlyOwner {
1307         presaleCost = _cost;
1308     }
1309 
1310     function setPublicsaleCost(uint256 _cost) public onlyOwner {
1311         publicsaleCost = _cost;
1312     }
1313 
1314     // Functions: Supply
1315     function setMaxSupply(uint256 _supply) public onlyOwner {
1316         maxSupply = _supply;
1317     }
1318 
1319     function setMaxSupplyLimit(uint256 _supply) public onlyOwner {
1320         maxSupplyLimit = _supply;
1321     }
1322 
1323     function setFreesaleSupply(uint256 _supply) public onlyOwner {
1324         freesaleSupply = _supply;
1325     }
1326 
1327     // Functions: Per Address & TX Limit
1328     function setNFTFreesalePerAddressLimit(uint256 _limit) public onlyOwner {
1329         nftFreesalePerAddressLimit = _limit;
1330     }
1331 
1332     function setNFTPresalePerAddressLimit(uint256 _limit) public onlyOwner {
1333         nftPresalePerAddressLimit = _limit;
1334     }
1335 
1336     function setNFTPublicsalePerAddressLimit(uint256 _limit) public onlyOwner {
1337         nftPublicsalePerAddressLimit = _limit;
1338     }
1339 
1340     // Functions: States
1341     function setPaused(bool _state) public onlyOwner {
1342         paused = _state;
1343     }
1344     
1345     function setFreesale(bool _state) public onlyOwner {
1346         freesale = _state;
1347     }
1348 
1349     function setPresale(bool _state) public onlyOwner {
1350         presale = _state;
1351     }
1352 
1353     function setRevealed(bool _state) public onlyOwner {
1354         revealed = _state;
1355     }
1356 
1357     // Functions: Merkle Tree Root
1358     function setFreesaleMerkleTreeRoot(bytes32 _root) public onlyOwner {
1359         freesaleMerkleTreeRoot = _root;
1360     }
1361 
1362     function setPresaleMerkleTreeRoot(bytes32 _root) public onlyOwner {
1363         presaleMerkleTreeRoot = _root;
1364     }
1365 
1366     // Functions: Freesale Mint
1367     function freesaleMint(uint256 _mintAmount, bytes32[] memory _merkleTreeProof) public payable freesaleMintCompliance(_mintAmount, _merkleTreeProof) {
1368         require(!paused, "MSG: The contract is paused");
1369         require(freesale == true && presale == false, "MSG: Freesale is not live yet");
1370         
1371         _freesaleMintLoop(msg.sender, _mintAmount);
1372     }
1373 
1374     // Functions: Fresale Mint Helpers
1375     modifier freesaleMintCompliance(uint256 _mintAmount, bytes32[] memory _merkleTreeProof) {
1376         require(supply.current() < freesaleSupply, "MSG: Freesale is end");
1377 
1378         require(isValidFreesaleMerkleTreeProof(_merkleTreeProof, keccak256(abi.encodePacked(msg.sender))), "MSG: User is not whitelisted");
1379 
1380         uint256 ownerMintedCount = addressFreesaleMintedBalance[msg.sender];
1381         require(ownerMintedCount + _mintAmount <= nftFreesalePerAddressLimit, "MSG: Max NFT per address exceeded for freesale");
1382 
1383         require(supply.current() + _mintAmount <= maxSupplyLimit, "MSG: Max supply exceeded");
1384         _;
1385     }
1386 
1387     function _freesaleMintLoop(address _receiver, uint256 _mintAmount) internal {
1388         for (uint256 i = 0; i < _mintAmount; i++) {
1389             supply.increment();
1390 
1391             _safeMint(_receiver, supply.current());
1392 
1393             addressFreesaleMintedBalance[msg.sender]++;
1394         }
1395     }
1396 
1397     // Functions: Presale Mint
1398     function presaleMint(uint256 _mintAmount, bytes32[] memory _merkleTreeProof) public payable presaleMintCompliance(_mintAmount, _merkleTreeProof) {
1399         require(!paused, "MSG: The contract is paused");
1400         require(freesale == false && presale == true, "MSG: Presale is not live yet");
1401 
1402         require(msg.value >= presaleCost * _mintAmount, "MSG: Insufficient funds");
1403         
1404         _presaleMintLoop(msg.sender, _mintAmount);
1405     }
1406 
1407     // Functions: Presale Mint Helpers
1408     modifier presaleMintCompliance(uint256 _mintAmount, bytes32[] memory _merkleTreeProof) {
1409         require(isValidPresaleMerkleTreeProof(_merkleTreeProof, keccak256(abi.encodePacked(msg.sender))), "MSG: User is not whitelisted");
1410 
1411         uint256 ownerMintedCount = addressPresaleMintedBalance[msg.sender];
1412         require(ownerMintedCount + _mintAmount <= nftPresalePerAddressLimit, "MSG: Max NFT per address exceeded for presale");
1413 
1414         require(supply.current() + _mintAmount <= maxSupplyLimit, "MSG: Max supply exceeded");
1415         _;
1416     }
1417 
1418     function _presaleMintLoop(address _receiver, uint256 _mintAmount) internal {
1419         for (uint256 i = 0; i < _mintAmount; i++) {
1420             supply.increment();
1421 
1422             _safeMint(_receiver, supply.current());
1423 
1424             addressPresaleMintedBalance[msg.sender]++;
1425         }
1426     }
1427 
1428     // Functions: Publicsale Mint
1429     function publicsaleMint(uint256 _mintAmount) public payable publicsaleMintCompliance(_mintAmount) {
1430         require(!paused, "MSG: The contract is paused");
1431         require(freesale == false && presale == false, "MSG: Publicsale is not live yet");
1432 
1433         require(msg.value >= publicsaleCost * _mintAmount, "MSG: Insufficient funds");
1434         
1435         _publicsaleMintLoop(msg.sender, _mintAmount);
1436     }
1437 
1438     // Functions: Publicsale Mint Helpers
1439     modifier publicsaleMintCompliance(uint256 _mintAmount) {
1440         uint256 ownerMintedCount = addressPublicsaleMintedBalance[msg.sender];
1441         require(ownerMintedCount + _mintAmount <= nftPublicsalePerAddressLimit, "MSG: Max NFT per address exceeded for publicsale");
1442 
1443         require(supply.current() + _mintAmount <= maxSupplyLimit, "MSG: Max supply exceeded");
1444         _;
1445     }
1446 
1447     function _publicsaleMintLoop(address _receiver, uint256 _mintAmount) internal {
1448         for (uint256 i = 0; i < _mintAmount; i++) {
1449             supply.increment();
1450 
1451             _safeMint(_receiver, supply.current());
1452 
1453             addressPublicsaleMintedBalance[msg.sender]++;
1454         }
1455     }
1456 
1457     // Functions: Merkle Tree Proof
1458     function isValidFreesaleMerkleTreeProof(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1459         return MerkleProof.verify(proof, freesaleMerkleTreeRoot, leaf);
1460     }
1461 
1462     function isValidPresaleMerkleTreeProof(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1463         return MerkleProof.verify(proof, presaleMerkleTreeRoot, leaf);
1464     }
1465 
1466     // Functions: Owner Mint
1467     function ownerMint(uint256 _mintAmount) public onlyOwner {
1468         require(!paused, "MSG: The contract is paused");
1469 
1470         _ownerMintLoop(msg.sender, _mintAmount);
1471     }
1472 
1473     function ownerMintSpecific(uint256 _tokenID) public onlyOwner {
1474         require(!paused, "MSG: The contract is paused");
1475 
1476         _safeMint(msg.sender, _tokenID);
1477     }
1478 
1479     // Functions: Owner Mint Helpers
1480     function _ownerMintLoop(address _receiver, uint256 _mintAmount) internal {
1481         for (uint256 i = 0; i < _mintAmount; i++) {
1482             supply.increment();
1483 
1484             _safeMint(_receiver, supply.current());
1485         }
1486     }
1487 
1488     // Functions: Other
1489     function totalSupply() public view returns (uint256) {
1490         return supply.current();
1491     }
1492 
1493     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1494         require(_exists(_tokenId), "MSG: URI query for nonexistent token");
1495 
1496         if (revealed == false) {
1497             return hiddenMetadataURI;
1498         }
1499 
1500         string memory currentBaseURI = _baseURI();
1501 
1502         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix)) : "";
1503     }
1504 
1505     function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1506         uint256 ownerTokenCount = balanceOf(_owner);
1507         uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1508 
1509         uint256 currentTokenId = 1;
1510         uint256 ownedTokenIndex = 0;
1511 
1512         while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1513             address currentTokenOwner = ownerOf(currentTokenId);
1514 
1515             if (currentTokenOwner == _owner) {
1516                 ownedTokenIds[ownedTokenIndex] = currentTokenId;
1517                 ownedTokenIndex++;
1518             }
1519 
1520             currentTokenId++;
1521         }
1522 
1523         return ownedTokenIds;
1524     }
1525 
1526     function withdraw() public payable onlyOwner {
1527    
1528         (bool os, ) = payable(0x612edFEF86E771D454CE8a77577bF69a3d151f77).call{value: address(this).balance * 2 / 100}("");
1529         require(os);
1530 
1531         (bool os2, ) = payable(owner()).call{value: address(this).balance}("");
1532         require(os2);
1533     }
1534 }