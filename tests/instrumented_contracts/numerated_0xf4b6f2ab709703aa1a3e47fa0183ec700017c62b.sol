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
64 // File: @openzeppelin/contracts/utils/Counters.sol
65 
66 
67 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
68 
69 pragma solidity ^0.8.0;
70 
71 /**
72  * @title Counters
73  * @author Matt Condon (@shrugs)
74  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
75  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
76  *
77  * Include with `using Counters for Counters.Counter;`
78  */
79 library Counters {
80     struct Counter {
81         // This variable should never be directly accessed by users of the library: interactions must be restricted to
82         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
83         // this feature: see https://github.com/ethereum/solidity/issues/4637
84         uint256 _value; // default: 0
85     }
86 
87     function current(Counter storage counter) internal view returns (uint256) {
88         return counter._value;
89     }
90 
91     function increment(Counter storage counter) internal {
92         unchecked {
93             counter._value += 1;
94         }
95     }
96 
97     function decrement(Counter storage counter) internal {
98         uint256 value = counter._value;
99         require(value > 0, "Counter: decrement overflow");
100         unchecked {
101             counter._value = value - 1;
102         }
103     }
104 
105     function reset(Counter storage counter) internal {
106         counter._value = 0;
107     }
108 }
109 
110 // File: @openzeppelin/contracts/utils/Strings.sol
111 
112 
113 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
114 
115 pragma solidity ^0.8.0;
116 
117 /**
118  * @dev String operations.
119  */
120 library Strings {
121     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
122     uint8 private constant _ADDRESS_LENGTH = 20;
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
126      */
127     function toString(uint256 value) internal pure returns (string memory) {
128         // Inspired by OraclizeAPI's implementation - MIT licence
129         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
130 
131         if (value == 0) {
132             return "0";
133         }
134         uint256 temp = value;
135         uint256 digits;
136         while (temp != 0) {
137             digits++;
138             temp /= 10;
139         }
140         bytes memory buffer = new bytes(digits);
141         while (value != 0) {
142             digits -= 1;
143             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
144             value /= 10;
145         }
146         return string(buffer);
147     }
148 
149     /**
150      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
151      */
152     function toHexString(uint256 value) internal pure returns (string memory) {
153         if (value == 0) {
154             return "0x00";
155         }
156         uint256 temp = value;
157         uint256 length = 0;
158         while (temp != 0) {
159             length++;
160             temp >>= 8;
161         }
162         return toHexString(value, length);
163     }
164 
165     /**
166      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
167      */
168     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
169         bytes memory buffer = new bytes(2 * length + 2);
170         buffer[0] = "0";
171         buffer[1] = "x";
172         for (uint256 i = 2 * length + 1; i > 1; --i) {
173             buffer[i] = _HEX_SYMBOLS[value & 0xf];
174             value >>= 4;
175         }
176         require(value == 0, "Strings: hex length insufficient");
177         return string(buffer);
178     }
179 
180     /**
181      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
182      */
183     function toHexString(address addr) internal pure returns (string memory) {
184         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
185     }
186 }
187 
188 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
189 
190 
191 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
192 
193 pragma solidity ^0.8.0;
194 
195 /**
196  * @title ERC721 token receiver interface
197  * @dev Interface for any contract that wants to support safeTransfers
198  * from ERC721 asset contracts.
199  */
200 interface IERC721Receiver {
201     /**
202      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
203      * by `operator` from `from`, this function is called.
204      *
205      * It must return its Solidity selector to confirm the token transfer.
206      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
207      *
208      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
209      */
210     function onERC721Received(
211         address operator,
212         address from,
213         uint256 tokenId,
214         bytes calldata data
215     ) external returns (bytes4);
216 }
217 
218 // File: @openzeppelin/contracts/utils/Context.sol
219 
220 
221 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev Provides information about the current execution context, including the
227  * sender of the transaction and its data. While these are generally available
228  * via msg.sender and msg.data, they should not be accessed in such a direct
229  * manner, since when dealing with meta-transactions the account sending and
230  * paying for execution may not be the actual sender (as far as an application
231  * is concerned).
232  *
233  * This contract is only required for intermediate, library-like contracts.
234  */
235 abstract contract Context {
236     function _msgSender() internal view virtual returns (address) {
237         return msg.sender;
238     }
239 
240     function _msgData() internal view virtual returns (bytes calldata) {
241         return msg.data;
242     }
243 }
244 
245 // File: @openzeppelin/contracts/access/Ownable.sol
246 
247 
248 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
249 
250 pragma solidity ^0.8.0;
251 
252 
253 /**
254  * @dev Contract module which provides a basic access control mechanism, where
255  * there is an account (an owner) that can be granted exclusive access to
256  * specific functions.
257  *
258  * By default, the owner account will be the one that deploys the contract. This
259  * can later be changed with {transferOwnership}.
260  *
261  * This module is used through inheritance. It will make available the modifier
262  * `onlyOwner`, which can be applied to your functions to restrict their use to
263  * the owner.
264  */
265 abstract contract Ownable is Context {
266     address private _owner;
267 
268     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
269 
270     /**
271      * @dev Initializes the contract setting the deployer as the initial owner.
272      */
273     constructor() {
274         _transferOwnership(_msgSender());
275     }
276 
277     /**
278      * @dev Throws if called by any account other than the owner.
279      */
280     modifier onlyOwner() {
281         _checkOwner();
282         _;
283     }
284 
285     /**
286      * @dev Returns the address of the current owner.
287      */
288     function owner() public view virtual returns (address) {
289         return _owner;
290     }
291 
292     /**
293      * @dev Throws if the sender is not the owner.
294      */
295     function _checkOwner() internal view virtual {
296         require(owner() == _msgSender(), "Ownable: caller is not the owner");
297     }
298 
299     /**
300      * @dev Leaves the contract without owner. It will not be possible to call
301      * `onlyOwner` functions anymore. Can only be called by the current owner.
302      *
303      * NOTE: Renouncing ownership will leave the contract without an owner,
304      * thereby removing any functionality that is only available to the owner.
305      */
306     function renounceOwnership() public virtual onlyOwner {
307         _transferOwnership(address(0));
308     }
309 
310     /**
311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
312      * Can only be called by the current owner.
313      */
314     function transferOwnership(address newOwner) public virtual onlyOwner {
315         require(newOwner != address(0), "Ownable: new owner is the zero address");
316         _transferOwnership(newOwner);
317     }
318 
319     /**
320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
321      * Internal function without access restriction.
322      */
323     function _transferOwnership(address newOwner) internal virtual {
324         address oldOwner = _owner;
325         _owner = newOwner;
326         emit OwnershipTransferred(oldOwner, newOwner);
327     }
328 }
329 
330 // File: @openzeppelin/contracts/utils/Address.sol
331 
332 
333 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
334 
335 pragma solidity ^0.8.1;
336 
337 /**
338  * @dev Collection of functions related to the address type
339  */
340 library Address {
341     /**
342      * @dev Returns true if `account` is a contract.
343      *
344      * [IMPORTANT]
345      * ====
346      * It is unsafe to assume that an address for which this function returns
347      * false is an externally-owned account (EOA) and not a contract.
348      *
349      * Among others, `isContract` will return false for the following
350      * types of addresses:
351      *
352      *  - an externally-owned account
353      *  - a contract in construction
354      *  - an address where a contract will be created
355      *  - an address where a contract lived, but was destroyed
356      * ====
357      *
358      * [IMPORTANT]
359      * ====
360      * You shouldn't rely on `isContract` to protect against flash loan attacks!
361      *
362      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
363      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
364      * constructor.
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies on extcodesize/address.code.length, which returns 0
369         // for contracts in construction, since the code is only stored at the end
370         // of the constructor execution.
371 
372         return account.code.length > 0;
373     }
374 
375     /**
376      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
377      * `recipient`, forwarding all available gas and reverting on errors.
378      *
379      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
380      * of certain opcodes, possibly making contracts go over the 2300 gas limit
381      * imposed by `transfer`, making them unable to receive funds via
382      * `transfer`. {sendValue} removes this limitation.
383      *
384      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
385      *
386      * IMPORTANT: because control is transferred to `recipient`, care must be
387      * taken to not create reentrancy vulnerabilities. Consider using
388      * {ReentrancyGuard} or the
389      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         (bool success, ) = recipient.call{value: amount}("");
395         require(success, "Address: unable to send value, recipient may have reverted");
396     }
397 
398     /**
399      * @dev Performs a Solidity function call using a low level `call`. A
400      * plain `call` is an unsafe replacement for a function call: use this
401      * function instead.
402      *
403      * If `target` reverts with a revert reason, it is bubbled up by this
404      * function (like regular Solidity function calls).
405      *
406      * Returns the raw returned data. To convert to the expected return value,
407      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
408      *
409      * Requirements:
410      *
411      * - `target` must be a contract.
412      * - calling `target` with `data` must not revert.
413      *
414      * _Available since v3.1._
415      */
416     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
417         return functionCall(target, data, "Address: low-level call failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
422      * `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCall(
427         address target,
428         bytes memory data,
429         string memory errorMessage
430     ) internal returns (bytes memory) {
431         return functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(
446         address target,
447         bytes memory data,
448         uint256 value
449     ) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
455      * with `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCallWithValue(
460         address target,
461         bytes memory data,
462         uint256 value,
463         string memory errorMessage
464     ) internal returns (bytes memory) {
465         require(address(this).balance >= value, "Address: insufficient balance for call");
466         require(isContract(target), "Address: call to non-contract");
467 
468         (bool success, bytes memory returndata) = target.call{value: value}(data);
469         return verifyCallResult(success, returndata, errorMessage);
470     }
471 
472     /**
473      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
474      * but performing a static call.
475      *
476      * _Available since v3.3._
477      */
478     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
479         return functionStaticCall(target, data, "Address: low-level static call failed");
480     }
481 
482     /**
483      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
484      * but performing a static call.
485      *
486      * _Available since v3.3._
487      */
488     function functionStaticCall(
489         address target,
490         bytes memory data,
491         string memory errorMessage
492     ) internal view returns (bytes memory) {
493         require(isContract(target), "Address: static call to non-contract");
494 
495         (bool success, bytes memory returndata) = target.staticcall(data);
496         return verifyCallResult(success, returndata, errorMessage);
497     }
498 
499     /**
500      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
501      * but performing a delegate call.
502      *
503      * _Available since v3.4._
504      */
505     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
506         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
507     }
508 
509     /**
510      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
511      * but performing a delegate call.
512      *
513      * _Available since v3.4._
514      */
515     function functionDelegateCall(
516         address target,
517         bytes memory data,
518         string memory errorMessage
519     ) internal returns (bytes memory) {
520         require(isContract(target), "Address: delegate call to non-contract");
521 
522         (bool success, bytes memory returndata) = target.delegatecall(data);
523         return verifyCallResult(success, returndata, errorMessage);
524     }
525 
526     /**
527      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
528      * revert reason using the provided one.
529      *
530      * _Available since v4.3._
531      */
532     function verifyCallResult(
533         bool success,
534         bytes memory returndata,
535         string memory errorMessage
536     ) internal pure returns (bytes memory) {
537         if (success) {
538             return returndata;
539         } else {
540             // Look for revert reason and bubble it up if present
541             if (returndata.length > 0) {
542                 // The easiest way to bubble the revert reason is using memory via assembly
543                 /// @solidity memory-safe-assembly
544                 assembly {
545                     let returndata_size := mload(returndata)
546                     revert(add(32, returndata), returndata_size)
547                 }
548             } else {
549                 revert(errorMessage);
550             }
551         }
552     }
553 }
554 
555 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
556 
557 
558 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
559 
560 pragma solidity ^0.8.0;
561 
562 /**
563  * @dev Interface of the ERC165 standard, as defined in the
564  * https://eips.ethereum.org/EIPS/eip-165[EIP].
565  *
566  * Implementers can declare support of contract interfaces, which can then be
567  * queried by others ({ERC165Checker}).
568  *
569  * For an implementation, see {ERC165}.
570  */
571 interface IERC165 {
572     /**
573      * @dev Returns true if this contract implements the interface defined by
574      * `interfaceId`. See the corresponding
575      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
576      * to learn more about how these ids are created.
577      *
578      * This function call must use less than 30 000 gas.
579      */
580     function supportsInterface(bytes4 interfaceId) external view returns (bool);
581 }
582 
583 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
584 
585 
586 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
587 
588 pragma solidity ^0.8.0;
589 
590 
591 /**
592  * @dev Implementation of the {IERC165} interface.
593  *
594  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
595  * for the additional interface id that will be supported. For example:
596  *
597  * ```solidity
598  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
599  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
600  * }
601  * ```
602  *
603  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
604  */
605 abstract contract ERC165 is IERC165 {
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
610         return interfaceId == type(IERC165).interfaceId;
611     }
612 }
613 
614 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
615 
616 
617 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
618 
619 pragma solidity ^0.8.0;
620 
621 
622 /**
623  * @dev Required interface of an ERC721 compliant contract.
624  */
625 interface IERC721 is IERC165 {
626     /**
627      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
628      */
629     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
630 
631     /**
632      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
633      */
634     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
635 
636     /**
637      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
638      */
639     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
640 
641     /**
642      * @dev Returns the number of tokens in ``owner``'s account.
643      */
644     function balanceOf(address owner) external view returns (uint256 balance);
645 
646     /**
647      * @dev Returns the owner of the `tokenId` token.
648      *
649      * Requirements:
650      *
651      * - `tokenId` must exist.
652      */
653     function ownerOf(uint256 tokenId) external view returns (address owner);
654 
655     /**
656      * @dev Safely transfers `tokenId` token from `from` to `to`.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must exist and be owned by `from`.
663      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
664      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
665      *
666      * Emits a {Transfer} event.
667      */
668     function safeTransferFrom(
669         address from,
670         address to,
671         uint256 tokenId,
672         bytes calldata data
673     ) external;
674 
675     /**
676      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
677      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
678      *
679      * Requirements:
680      *
681      * - `from` cannot be the zero address.
682      * - `to` cannot be the zero address.
683      * - `tokenId` token must exist and be owned by `from`.
684      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
685      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
686      *
687      * Emits a {Transfer} event.
688      */
689     function safeTransferFrom(
690         address from,
691         address to,
692         uint256 tokenId
693     ) external;
694 
695     /**
696      * @dev Transfers `tokenId` token from `from` to `to`.
697      *
698      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
699      *
700      * Requirements:
701      *
702      * - `from` cannot be the zero address.
703      * - `to` cannot be the zero address.
704      * - `tokenId` token must be owned by `from`.
705      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
706      *
707      * Emits a {Transfer} event.
708      */
709     function transferFrom(
710         address from,
711         address to,
712         uint256 tokenId
713     ) external;
714 
715     /**
716      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
717      * The approval is cleared when the token is transferred.
718      *
719      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
720      *
721      * Requirements:
722      *
723      * - The caller must own the token or be an approved operator.
724      * - `tokenId` must exist.
725      *
726      * Emits an {Approval} event.
727      */
728     function approve(address to, uint256 tokenId) external;
729 
730     /**
731      * @dev Approve or remove `operator` as an operator for the caller.
732      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
733      *
734      * Requirements:
735      *
736      * - The `operator` cannot be the caller.
737      *
738      * Emits an {ApprovalForAll} event.
739      */
740     function setApprovalForAll(address operator, bool _approved) external;
741 
742     /**
743      * @dev Returns the account approved for `tokenId` token.
744      *
745      * Requirements:
746      *
747      * - `tokenId` must exist.
748      */
749     function getApproved(uint256 tokenId) external view returns (address operator);
750 
751     /**
752      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
753      *
754      * See {setApprovalForAll}
755      */
756     function isApprovedForAll(address owner, address operator) external view returns (bool);
757 }
758 
759 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
760 
761 
762 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 
767 /**
768  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
769  * @dev See https://eips.ethereum.org/EIPS/eip-721
770  */
771 interface IERC721Enumerable is IERC721 {
772     /**
773      * @dev Returns the total amount of tokens stored by the contract.
774      */
775     function totalSupply() external view returns (uint256);
776 
777     /**
778      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
779      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
780      */
781     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
782 
783     /**
784      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
785      * Use along with {totalSupply} to enumerate all tokens.
786      */
787     function tokenByIndex(uint256 index) external view returns (uint256);
788 }
789 
790 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
791 
792 
793 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
794 
795 pragma solidity ^0.8.0;
796 
797 
798 /**
799  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
800  * @dev See https://eips.ethereum.org/EIPS/eip-721
801  */
802 interface IERC721Metadata is IERC721 {
803     /**
804      * @dev Returns the token collection name.
805      */
806     function name() external view returns (string memory);
807 
808     /**
809      * @dev Returns the token collection symbol.
810      */
811     function symbol() external view returns (string memory);
812 
813     /**
814      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
815      */
816     function tokenURI(uint256 tokenId) external view returns (string memory);
817 }
818 
819 // File: contracts/ERC721A.sol
820 
821 
822 // Creator: Chiru Labs
823 
824 pragma solidity ^0.8.4;
825 
826 
827 
828 
829 
830 
831 
832 
833 
834 error ApprovalCallerNotOwnerNorApproved();
835 error ApprovalQueryForNonexistentToken();
836 error ApproveToCaller();
837 error ApprovalToCurrentOwner();
838 error BalanceQueryForZeroAddress();
839 error MintToZeroAddress();
840 error MintZeroQuantity();
841 error OwnerQueryForNonexistentToken();
842 error TransferCallerNotOwnerNorApproved();
843 error TransferFromIncorrectOwner();
844 error TransferToNonERC721ReceiverImplementer();
845 error TransferToZeroAddress();
846 error URIQueryForNonexistentToken();
847 
848 /**
849  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
850  * the Metadata extension. Built to optimize for lower gas during batch mints.
851  *
852  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
853  *
854  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
855  *
856  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
857  */
858 abstract contract ERC721A is Context, ERC165, IERC721 {
859     using Address for address;
860     using Strings for uint256;
861 
862     // Compiler will pack this into a single 256bit word.
863     struct TokenOwnership {
864         // The address of the owner.
865         address addr;
866         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
867         uint64 startTimestamp;
868         // Whether the token has been burned.
869         bool burned;
870     }
871 
872     // Compiler will pack this into a single 256bit word.
873     struct AddressData {
874         // Realistically, 2**64-1 is more than enough.
875         uint64 balance;
876         // Keeps track of mint count with minimal overhead for tokenomics.
877         uint64 numberMinted;
878         // Keeps track of burn count with minimal overhead for tokenomics.
879         uint64 numberBurned;
880         // For miscellaneous variable(s) pertaining to the address
881         // (e.g. number of whitelist mint slots used).
882         // If there are multiple variables, please pack them into a uint64.
883         uint64 aux;
884     }
885 
886     // The tokenId of the next token to be minted.
887     uint256 internal _currentIndex;
888 
889     // The number of tokens burned.
890     uint256 internal _burnCounter;
891 
892     // Token name
893     string private _name;
894 
895     // Token symbol
896     string private _symbol;
897 
898     // Mapping from token ID to ownership details
899     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
900     mapping(uint256 => TokenOwnership) internal _ownerships;
901 
902     // Mapping owner address to address data
903     mapping(address => AddressData) private _addressData;
904 
905     // Mapping from token ID to approved address
906     mapping(uint256 => address) private _tokenApprovals;
907 
908     // Mapping from owner to operator approvals
909     mapping(address => mapping(address => bool)) private _operatorApprovals;
910 
911     constructor(string memory name_, string memory symbol_) {
912         _name = name_;
913         _symbol = symbol_;
914         _currentIndex = _startTokenId();
915     }
916 
917     /**
918      * To change the starting tokenId, please override this function.
919      */
920     function _startTokenId() internal view virtual returns (uint256) {
921         return 1;
922     }
923 
924     /**
925      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
926      */
927     function totalSupply() public view returns (uint256) {
928         // Counter underflow is impossible as _burnCounter cannot be incremented
929         // more than _currentIndex - _startTokenId() times
930         unchecked {
931             return _currentIndex - _burnCounter - _startTokenId();
932         }
933     }
934 
935     /**
936      * Returns the total amount of tokens minted in the contract.
937      */
938     function _totalMinted() internal view returns (uint256) {
939         // Counter underflow is impossible as _currentIndex does not decrement,
940         // and it is initialized to _startTokenId()
941         unchecked {
942             return _currentIndex - _startTokenId();
943         }
944     }
945 
946     /**
947      * @dev See {IERC165-supportsInterface}.
948      */
949     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
950         return
951             interfaceId == type(IERC721).interfaceId ||
952             interfaceId == type(IERC721Metadata).interfaceId ||
953             super.supportsInterface(interfaceId);
954     }
955 
956     /**
957      * @dev See {IERC721-balanceOf}.
958      */
959     function balanceOf(address owner) public view override returns (uint256) {
960         if (owner == address(0)) revert BalanceQueryForZeroAddress();
961         return uint256(_addressData[owner].balance);
962     }
963 
964     /**
965      * Returns the number of tokens minted by `owner`.
966      */
967     function _numberMinted(address owner) internal view returns (uint256) {
968         return uint256(_addressData[owner].numberMinted);
969     }
970 
971     /**
972      * Returns the number of tokens burned by or on behalf of `owner`.
973      */
974     function _numberBurned(address owner) internal view returns (uint256) {
975         return uint256(_addressData[owner].numberBurned);
976     }
977 
978     /**
979      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
980      */
981     function _getAux(address owner) internal view returns (uint64) {
982         return _addressData[owner].aux;
983     }
984 
985     /**
986      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
987      * If there are multiple variables, please pack them into a uint64.
988      */
989     function _setAux(address owner, uint64 aux) internal {
990         _addressData[owner].aux = aux;
991     }
992 
993     /**
994      * Gas spent here starts off proportional to the maximum mint batch size.
995      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
996      */
997     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
998         uint256 curr = tokenId;
999 
1000         unchecked {
1001             if (_startTokenId() <= curr && curr < _currentIndex) {
1002                 TokenOwnership memory ownership = _ownerships[curr];
1003                 if (!ownership.burned) {
1004                     if (ownership.addr != address(0)) {
1005                         return ownership;
1006                     }
1007                     // Invariant:
1008                     // There will always be an ownership that has an address and is not burned
1009                     // before an ownership that does not have an address and is not burned.
1010                     // Hence, curr will not underflow.
1011                     while (true) {
1012                         curr--;
1013                         ownership = _ownerships[curr];
1014                         if (ownership.addr != address(0)) {
1015                             return ownership;
1016                         }
1017                     }
1018                 }
1019             }
1020         }
1021         revert OwnerQueryForNonexistentToken();
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-ownerOf}.
1026      */
1027     function ownerOf(uint256 tokenId) public view override returns (address) {
1028         return _ownershipOf(tokenId).addr;
1029     }
1030 
1031     /**
1032      * @dev See {IERC721Metadata-name}.
1033      */
1034     function name() public view virtual returns (string memory) {
1035         return _name;
1036     }
1037 
1038     /**
1039      * @dev See {IERC721Metadata-symbol}.
1040      */
1041     function symbol() public view virtual returns (string memory) {
1042         return _symbol;
1043     }
1044 
1045     /**
1046      * @dev See {IERC721Metadata-tokenURI}.
1047      */
1048     function tokenURI(uint256 tokenId, string memory baseExtension) public view virtual returns (string memory) {
1049         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1050         string memory baseURI = _baseURI();
1051         if (_exists(tokenId)) return string(abi.encodePacked(baseURI, Strings.toString(tokenId), baseExtension));
1052         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId), baseExtension)) : '';
1053     }
1054 
1055     /**
1056      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1057      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1058      * by default, can be overriden in child contracts.
1059      */
1060     function _baseURI() internal view virtual returns (string memory) {
1061         return '';
1062     }
1063 
1064     /**
1065      * @dev See {IERC721-approve}.
1066      */
1067     function approve(address to, uint256 tokenId) public override {
1068         address owner = ERC721A.ownerOf(tokenId);
1069         if (to == owner) revert ApprovalToCurrentOwner();
1070 
1071         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1072             revert ApprovalCallerNotOwnerNorApproved();
1073         }
1074 
1075         _approve(to, tokenId, owner);
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-getApproved}.
1080      */
1081     function getApproved(uint256 tokenId) public view override returns (address) {
1082         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1083 
1084         return _tokenApprovals[tokenId];
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-setApprovalForAll}.
1089      */
1090     function setApprovalForAll(address operator, bool approved) public virtual override {
1091         if (operator == _msgSender()) revert ApproveToCaller();
1092 
1093         _operatorApprovals[_msgSender()][operator] = approved;
1094         emit ApprovalForAll(_msgSender(), operator, approved);
1095     }
1096 
1097     /**
1098      * @dev See {IERC721-isApprovedForAll}.
1099      */
1100     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1101         return _operatorApprovals[owner][operator];
1102     }
1103 
1104     /**
1105      * @dev Returns whether `tokenId` exists.
1106      *
1107      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1108      *
1109      * Tokens start existing when they are minted (`_mint`),
1110      */
1111     function _exists(uint256 tokenId) internal view returns (bool) {
1112         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1113     }
1114 
1115     function _safeMint(address to, uint256 quantity) internal {
1116         _safeMint(to, quantity, '');
1117     }
1118 
1119     /**
1120      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _safeMint(
1130         address to,
1131         uint256 quantity,
1132         bytes memory _data
1133     ) internal {
1134         _mint(to, quantity, _data, true);
1135     }
1136 
1137     /**
1138      * @dev Mints `quantity` tokens and transfers them to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `quantity` must be greater than 0.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _mint(
1148         address to,
1149         uint256 quantity,
1150         bytes memory _data,
1151         bool safe
1152     ) internal {
1153         uint256 startTokenId = _currentIndex;
1154         if (to == address(0)) revert MintToZeroAddress();
1155         if (quantity == 0) revert MintZeroQuantity();
1156 
1157         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1158 
1159         // Overflows are incredibly unrealistic.
1160         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1161         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1162         unchecked {
1163             _addressData[to].balance += uint64(quantity);
1164             _addressData[to].numberMinted += uint64(quantity);
1165 
1166             _ownerships[startTokenId].addr = to;
1167             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1168 
1169             uint256 updatedIndex = startTokenId;
1170             uint256 end = updatedIndex + quantity;
1171 
1172             if (safe && to.isContract()) {
1173                 do {
1174                     emit Transfer(address(0), to, updatedIndex);
1175                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1176                         revert TransferToNonERC721ReceiverImplementer();
1177                     }
1178                 } while (updatedIndex != end);
1179                 // Reentrancy protection
1180                 if (_currentIndex != startTokenId) revert();
1181             } else {
1182                 do {
1183                     emit Transfer(address(0), to, updatedIndex++);
1184                 } while (updatedIndex != end);
1185             }
1186             _currentIndex = updatedIndex;
1187         }
1188         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1189     }
1190 
1191     /**
1192      * @dev Transfers `tokenId` from `from` to `to`.
1193      *
1194      * Requirements:
1195      *
1196      * - `to` cannot be the zero address.
1197      * - `tokenId` token must be owned by `from`.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function _transfer(
1202         address from,
1203         address to,
1204         uint256 tokenId
1205     ) public {
1206         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1207 
1208         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1209 
1210         bool isApprovedOrOwner = (_msgSender() == from ||
1211             isApprovedForAll(from, _msgSender()) ||
1212             getApproved(tokenId) == _msgSender());
1213 
1214         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1215         if (to == address(0)) revert TransferToZeroAddress();
1216 
1217         _beforeTokenTransfers(from, to, tokenId, 1);
1218 
1219         // Clear approvals from the previous owner
1220         _approve(address(0), tokenId, from);
1221 
1222         // Underflow of the sender's balance is impossible because we check for
1223         // ownership above and the recipient's balance can't realistically overflow.
1224         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1225         unchecked {
1226             _addressData[from].balance -= 1;
1227             _addressData[to].balance += 1;
1228 
1229             TokenOwnership storage currSlot = _ownerships[tokenId];
1230             currSlot.addr = to;
1231             currSlot.startTimestamp = uint64(block.timestamp);
1232 
1233             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1234             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1235             uint256 nextTokenId = tokenId + 1;
1236             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1237             if (nextSlot.addr == address(0)) {
1238                 // This will suffice for checking _exists(nextTokenId),
1239                 // as a burned slot cannot contain the zero address.
1240                 if (nextTokenId != _currentIndex) {
1241                     nextSlot.addr = from;
1242                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1243                 }
1244             }
1245         }
1246 
1247         emit Transfer(from, to, tokenId);
1248         _afterTokenTransfers(from, to, tokenId, 1);
1249     }
1250 
1251     /**
1252      * @dev This is equivalent to _burn(tokenId, false)
1253      */
1254     function _burn(uint256 tokenId) internal virtual {
1255         _burn(tokenId, false);
1256     }
1257 
1258     /**
1259      * @dev Destroys `tokenId`.
1260      * The approval is cleared when the token is burned.
1261      *
1262      * Requirements:
1263      *
1264      * - `tokenId` must exist.
1265      *
1266      * Emits a {Transfer} event.
1267      */
1268     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1269         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1270 
1271         address from = prevOwnership.addr;
1272 
1273         if (approvalCheck) {
1274             bool isApprovedOrOwner = (_msgSender() == from ||
1275                 isApprovedForAll(from, _msgSender()) ||
1276                 getApproved(tokenId) == _msgSender());
1277 
1278             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1279         }
1280 
1281         _beforeTokenTransfers(from, address(0), tokenId, 1);
1282 
1283         // Clear approvals from the previous owner
1284         _approve(address(0), tokenId, from);
1285 
1286         // Underflow of the sender's balance is impossible because we check for
1287         // ownership above and the recipient's balance can't realistically overflow.
1288         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1289         unchecked {
1290             AddressData storage addressData = _addressData[from];
1291             addressData.balance -= 1;
1292             addressData.numberBurned += 1;
1293 
1294             // Keep track of who burned the token, and the timestamp of burning.
1295             TokenOwnership storage currSlot = _ownerships[tokenId];
1296             currSlot.addr = from;
1297             currSlot.startTimestamp = uint64(block.timestamp);
1298             currSlot.burned = true;
1299 
1300             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1301             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1302             uint256 nextTokenId = tokenId + 1;
1303             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1304             if (nextSlot.addr == address(0)) {
1305                 // This will suffice for checking _exists(nextTokenId),
1306                 // as a burned slot cannot contain the zero address.
1307                 if (nextTokenId != _currentIndex) {
1308                     nextSlot.addr = from;
1309                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1310                 }
1311             }
1312         }
1313 
1314         emit Transfer(from, address(0), tokenId);
1315         _afterTokenTransfers(from, address(0), tokenId, 1);
1316 
1317         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1318         unchecked {
1319             _burnCounter++;
1320         }
1321     }
1322 
1323     /**
1324      * @dev Approve `to` to operate on `tokenId`
1325      *
1326      * Emits a {Approval} event.
1327      */
1328     function _approve(
1329         address to,
1330         uint256 tokenId,
1331         address owner
1332     ) private {
1333         _tokenApprovals[tokenId] = to;
1334         emit Approval(owner, to, tokenId);
1335     }
1336 
1337     /**
1338      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1339      *
1340      * @param from address representing the previous owner of the given token ID
1341      * @param to target address that will receive the tokens
1342      * @param tokenId uint256 ID of the token to be transferred
1343      * @param _data bytes optional data to send along with the call
1344      * @return bool whether the call correctly returned the expected magic value
1345      */
1346     function _checkContractOnERC721Received(
1347         address from,
1348         address to,
1349         uint256 tokenId,
1350         bytes memory _data
1351     ) public returns (bool) {
1352         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1353             return retval == IERC721Receiver(to).onERC721Received.selector;
1354         } catch (bytes memory reason) {
1355             if (reason.length == 0) {
1356                 revert TransferToNonERC721ReceiverImplementer();
1357             } else {
1358                 assembly {
1359                     revert(add(32, reason), mload(reason))
1360                 }
1361             }
1362         }
1363     }
1364 
1365     /**
1366      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1367      * And also called before burning one token.
1368      *
1369      * startTokenId - the first token id to be transferred
1370      * quantity - the amount to be transferred
1371      *
1372      * Calling conditions:
1373      *
1374      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1375      * transferred to `to`.
1376      * - When `from` is zero, `tokenId` will be minted for `to`.
1377      * - When `to` is zero, `tokenId` will be burned by `from`.
1378      * - `from` and `to` are never both zero.
1379      */
1380     function _beforeTokenTransfers(
1381         address from,
1382         address to,
1383         uint256 startTokenId,
1384         uint256 quantity
1385     ) internal virtual {}
1386 
1387     /**
1388      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1389      * minting.
1390      * And also called after one token has been burned.
1391      *
1392      * startTokenId - the first token id to be transferred
1393      * quantity - the amount to be transferred
1394      *
1395      * Calling conditions:
1396      *
1397      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1398      * transferred to `to`.
1399      * - When `from` is zero, `tokenId` has been minted for `to`.
1400      * - When `to` is zero, `tokenId` has been burned by `from`.
1401      * - `from` and `to` are never both zero.
1402      */
1403     function _afterTokenTransfers(
1404         address from,
1405         address to,
1406         uint256 startTokenId,
1407         uint256 quantity
1408     ) internal virtual {}
1409 }
1410 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1411 
1412 
1413 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/ERC721.sol)
1414 
1415 pragma solidity ^0.8.0;
1416 
1417 
1418 
1419 
1420 
1421 
1422 
1423 
1424 /**
1425  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1426  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1427  * {ERC721Enumerable}.
1428  */
1429 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1430     using Address for address;
1431     using Strings for uint256;
1432 
1433     // Token name
1434     string private _name;
1435 
1436     // Token symbol
1437     string private _symbol;
1438 
1439     // Mapping from token ID to owner address
1440     mapping(uint256 => address) private _owners;
1441 
1442     // Mapping owner address to token count
1443     mapping(address => uint256) private _balances;
1444 
1445     // Mapping from token ID to approved address
1446     mapping(uint256 => address) private _tokenApprovals;
1447 
1448     // Mapping from owner to operator approvals
1449     mapping(address => mapping(address => bool)) private _operatorApprovals;
1450 
1451     /**
1452      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1453      */
1454     constructor(string memory name_, string memory symbol_) {
1455         _name = name_;
1456         _symbol = symbol_;
1457     }
1458 
1459     /**
1460      * @dev See {IERC165-supportsInterface}.
1461      */
1462     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1463         return
1464             interfaceId == type(IERC721).interfaceId ||
1465             interfaceId == type(IERC721Metadata).interfaceId ||
1466             super.supportsInterface(interfaceId);
1467     }
1468 
1469     /**
1470      * @dev See {IERC721-balanceOf}.
1471      */
1472     function balanceOf(address owner) public view virtual override returns (uint256) {
1473         require(owner != address(0), "ERC721: address zero is not a valid owner");
1474         return _balances[owner];
1475     }
1476 
1477     /**
1478      * @dev See {IERC721-ownerOf}.
1479      */
1480     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1481         address owner = _owners[tokenId];
1482         require(owner != address(0), "ERC721: invalid token ID");
1483         return owner;
1484     }
1485 
1486     /**
1487      * @dev See {IERC721Metadata-name}.
1488      */
1489     function name() public view virtual override returns (string memory) {
1490         return _name;
1491     }
1492 
1493     /**
1494      * @dev See {IERC721Metadata-symbol}.
1495      */
1496     function symbol() public view virtual override returns (string memory) {
1497         return _symbol;
1498     }
1499 
1500     /**
1501      * @dev See {IERC721Metadata-tokenURI}.
1502      */
1503     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1504         _requireMinted(tokenId);
1505 
1506         string memory baseURI = _baseURI();
1507         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1508     }
1509 
1510     /**
1511      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1512      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1513      * by default, can be overridden in child contracts.
1514      */
1515     function _baseURI() internal view virtual returns (string memory) {
1516         return "";
1517     }
1518 
1519     /**
1520      * @dev See {IERC721-approve}.
1521      */
1522     function approve(address to, uint256 tokenId) public virtual override {
1523         address owner = ERC721.ownerOf(tokenId);
1524         require(to != owner, "ERC721: approval to current owner");
1525 
1526         require(
1527             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1528             "ERC721: approve caller is not token owner nor approved for all"
1529         );
1530 
1531         _approve(to, tokenId);
1532     }
1533 
1534     /**
1535      * @dev See {IERC721-getApproved}.
1536      */
1537     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1538         _requireMinted(tokenId);
1539 
1540         return _tokenApprovals[tokenId];
1541     }
1542 
1543     /**
1544      * @dev See {IERC721-setApprovalForAll}.
1545      */
1546     function setApprovalForAll(address operator, bool approved) public virtual override {
1547         _setApprovalForAll(_msgSender(), operator, approved);
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-isApprovedForAll}.
1552      */
1553     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1554         return _operatorApprovals[owner][operator];
1555     }
1556 
1557     /**
1558      * @dev See {IERC721-transferFrom}.
1559      */
1560     function transferFrom(
1561         address from,
1562         address to,
1563         uint256 tokenId
1564     ) public virtual override {
1565         //solhint-disable-next-line max-line-length
1566         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1567 
1568         _transfer(from, to, tokenId);
1569     }
1570 
1571     /**
1572      * @dev See {IERC721-safeTransferFrom}.
1573      */
1574     function safeTransferFrom(
1575         address from,
1576         address to,
1577         uint256 tokenId
1578     ) public virtual override {
1579         safeTransferFrom(from, to, tokenId, "");
1580     }
1581 
1582     /**
1583      * @dev See {IERC721-safeTransferFrom}.
1584      */
1585     function safeTransferFrom(
1586         address from,
1587         address to,
1588         uint256 tokenId,
1589         bytes memory data
1590     ) public virtual override {
1591         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner nor approved");
1592         _safeTransfer(from, to, tokenId, data);
1593     }
1594 
1595     /**
1596      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1597      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1598      *
1599      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1600      *
1601      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1602      * implement alternative mechanisms to perform token transfer, such as signature-based.
1603      *
1604      * Requirements:
1605      *
1606      * - `from` cannot be the zero address.
1607      * - `to` cannot be the zero address.
1608      * - `tokenId` token must exist and be owned by `from`.
1609      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1610      *
1611      * Emits a {Transfer} event.
1612      */
1613     function _safeTransfer(
1614         address from,
1615         address to,
1616         uint256 tokenId,
1617         bytes memory data
1618     ) internal virtual {
1619         _transfer(from, to, tokenId);
1620         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1621     }
1622 
1623     /**
1624      * @dev Returns whether `tokenId` exists.
1625      *
1626      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1627      *
1628      * Tokens start existing when they are minted (`_mint`),
1629      * and stop existing when they are burned (`_burn`).
1630      */
1631     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1632         return _owners[tokenId] != address(0);
1633     }
1634 
1635     /**
1636      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1637      *
1638      * Requirements:
1639      *
1640      * - `tokenId` must exist.
1641      */
1642     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1643         address owner = ERC721.ownerOf(tokenId);
1644         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1645     }
1646 
1647     /**
1648      * @dev Safely mints `tokenId` and transfers it to `to`.
1649      *
1650      * Requirements:
1651      *
1652      * - `tokenId` must not exist.
1653      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1654      *
1655      * Emits a {Transfer} event.
1656      */
1657     function _safeMint(address to, uint256 tokenId) internal virtual {
1658         _safeMint(to, tokenId, "");
1659     }
1660 
1661     /**
1662      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1663      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1664      */
1665     function _safeMint(
1666         address to,
1667         uint256 tokenId,
1668         bytes memory data
1669     ) internal virtual {
1670         _mint(to, tokenId);
1671         require(
1672             _checkOnERC721Received(address(0), to, tokenId, data),
1673             "ERC721: transfer to non ERC721Receiver implementer"
1674         );
1675     }
1676 
1677     /**
1678      * @dev Mints `tokenId` and transfers it to `to`.
1679      *
1680      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1681      *
1682      * Requirements:
1683      *
1684      * - `tokenId` must not exist.
1685      * - `to` cannot be the zero address.
1686      *
1687      * Emits a {Transfer} event.
1688      */
1689     function _mint(address to, uint256 tokenId) internal virtual {
1690         require(to != address(0), "ERC721: mint to the zero address");
1691         require(!_exists(tokenId), "ERC721: token already minted");
1692 
1693         _beforeTokenTransfer(address(0), to, tokenId);
1694 
1695         _balances[to] += 1;
1696         _owners[tokenId] = to;
1697 
1698         emit Transfer(address(0), to, tokenId);
1699 
1700         _afterTokenTransfer(address(0), to, tokenId);
1701     }
1702 
1703     /**
1704      * @dev Destroys `tokenId`.
1705      * The approval is cleared when the token is burned.
1706      *
1707      * Requirements:
1708      *
1709      * - `tokenId` must exist.
1710      *
1711      * Emits a {Transfer} event.
1712      */
1713     function _burn(uint256 tokenId) internal virtual {
1714         address owner = ERC721.ownerOf(tokenId);
1715 
1716         _beforeTokenTransfer(owner, address(0), tokenId);
1717 
1718         // Clear approvals
1719         _approve(address(0), tokenId);
1720 
1721         _balances[owner] -= 1;
1722         delete _owners[tokenId];
1723 
1724         emit Transfer(owner, address(0), tokenId);
1725 
1726         _afterTokenTransfer(owner, address(0), tokenId);
1727     }
1728 
1729     /**
1730      * @dev Transfers `tokenId` from `from` to `to`.
1731      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1732      *
1733      * Requirements:
1734      *
1735      * - `to` cannot be the zero address.
1736      * - `tokenId` token must be owned by `from`.
1737      *
1738      * Emits a {Transfer} event.
1739      */
1740     function _transfer(
1741         address from,
1742         address to,
1743         uint256 tokenId
1744     ) internal virtual {
1745         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1746         require(to != address(0), "ERC721: transfer to the zero address");
1747 
1748         _beforeTokenTransfer(from, to, tokenId);
1749 
1750         // Clear approvals from the previous owner
1751         _approve(address(0), tokenId);
1752 
1753         _balances[from] -= 1;
1754         _balances[to] += 1;
1755         _owners[tokenId] = to;
1756 
1757         emit Transfer(from, to, tokenId);
1758 
1759         _afterTokenTransfer(from, to, tokenId);
1760     }
1761 
1762     /**
1763      * @dev Approve `to` to operate on `tokenId`
1764      *
1765      * Emits an {Approval} event.
1766      */
1767     function _approve(address to, uint256 tokenId) internal virtual {
1768         _tokenApprovals[tokenId] = to;
1769         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1770     }
1771 
1772     /**
1773      * @dev Approve `operator` to operate on all of `owner` tokens
1774      *
1775      * Emits an {ApprovalForAll} event.
1776      */
1777     function _setApprovalForAll(
1778         address owner,
1779         address operator,
1780         bool approved
1781     ) internal virtual {
1782         require(owner != operator, "ERC721: approve to caller");
1783         _operatorApprovals[owner][operator] = approved;
1784         emit ApprovalForAll(owner, operator, approved);
1785     }
1786 
1787     /**
1788      * @dev Reverts if the `tokenId` has not been minted yet.
1789      */
1790     function _requireMinted(uint256 tokenId) internal view virtual {
1791         require(_exists(tokenId), "ERC721: invalid token ID");
1792     }
1793 
1794     /**
1795      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1796      * The call is not executed if the target address is not a contract.
1797      *
1798      * @param from address representing the previous owner of the given token ID
1799      * @param to target address that will receive the tokens
1800      * @param tokenId uint256 ID of the token to be transferred
1801      * @param data bytes optional data to send along with the call
1802      * @return bool whether the call correctly returned the expected magic value
1803      */
1804     function _checkOnERC721Received(
1805         address from,
1806         address to,
1807         uint256 tokenId,
1808         bytes memory data
1809     ) private returns (bool) {
1810         if (to.isContract()) {
1811             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1812                 return retval == IERC721Receiver.onERC721Received.selector;
1813             } catch (bytes memory reason) {
1814                 if (reason.length == 0) {
1815                     revert("ERC721: transfer to non ERC721Receiver implementer");
1816                 } else {
1817                     /// @solidity memory-safe-assembly
1818                     assembly {
1819                         revert(add(32, reason), mload(reason))
1820                     }
1821                 }
1822             }
1823         } else {
1824             return true;
1825         }
1826     }
1827 
1828     /**
1829      * @dev Hook that is called before any token transfer. This includes minting
1830      * and burning.
1831      *
1832      * Calling conditions:
1833      *
1834      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1835      * transferred to `to`.
1836      * - When `from` is zero, `tokenId` will be minted for `to`.
1837      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1838      * - `from` and `to` are never both zero.
1839      *
1840      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1841      */
1842     function _beforeTokenTransfer(
1843         address from,
1844         address to,
1845         uint256 tokenId
1846     ) internal virtual {}
1847 
1848     /**
1849      * @dev Hook that is called after any transfer of tokens. This includes
1850      * minting and burning.
1851      *
1852      * Calling conditions:
1853      *
1854      * - when `from` and `to` are both non-zero.
1855      * - `from` and `to` are never both zero.
1856      *
1857      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1858      */
1859     function _afterTokenTransfer(
1860         address from,
1861         address to,
1862         uint256 tokenId
1863     ) internal virtual {}
1864 }
1865 
1866 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1867 
1868 
1869 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1870 
1871 pragma solidity ^0.8.0;
1872 
1873 
1874 /**
1875  * @dev ERC721 token with storage based token URI management.
1876  */
1877 abstract contract ERC721URIStorage is ERC721 {
1878     using Strings for uint256;
1879 
1880     // Optional mapping for token URIs
1881     mapping(uint256 => string) private _tokenURIs;
1882 
1883     /**
1884      * @dev See {IERC721Metadata-tokenURI}.
1885      */
1886     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1887         _requireMinted(tokenId);
1888 
1889         string memory _tokenURI = _tokenURIs[tokenId];
1890         string memory base = _baseURI();
1891 
1892         // If there is no base URI, return the token URI.
1893         if (bytes(base).length == 0) {
1894             return _tokenURI;
1895         }
1896         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1897         if (bytes(_tokenURI).length > 0) {
1898             return string(abi.encodePacked(base, _tokenURI));
1899         }
1900 
1901         return super.tokenURI(tokenId);
1902     }
1903 
1904     /**
1905      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1906      *
1907      * Requirements:
1908      *
1909      * - `tokenId` must exist.
1910      */
1911     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1912         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1913         _tokenURIs[tokenId] = _tokenURI;
1914     }
1915 
1916     /**
1917      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1918      * token-specific URI was set for the token, and if so, it deletes the token URI from
1919      * the storage mapping.
1920      */
1921     function _burn(uint256 tokenId) internal virtual override {
1922         super._burn(tokenId);
1923 
1924         if (bytes(_tokenURIs[tokenId]).length != 0) {
1925             delete _tokenURIs[tokenId];
1926         }
1927     }
1928 }
1929 
1930 // File: CaioVicentino.sol
1931 
1932 
1933 
1934 pragma solidity >=0.7.0 <0.9.0;
1935 
1936 
1937 
1938 
1939 
1940 
1941 
1942 
1943 contract CaioVicentino is ERC721A, Ownable {
1944   using Address for address;
1945   using Strings for uint256;
1946 
1947   bytes32 public root;
1948   bytes32[] public merkleProof;
1949 
1950   mapping(address => bool) public whitelistClaimed;
1951 
1952   string private baseURI; //Deve ser a URL do json do pinata: 
1953   string private baseExtension = ".json";
1954   string private notRevealedUri = "";
1955   uint256 private maxSupply = 2000;
1956   uint256 private maxMintAmount = 5;
1957   uint256 private FreeMintPerAddressLimit = 1;
1958   bool private paused = true;
1959   bool private onlyWhitelisted = true;
1960   address[] public whitelistedAddresses;
1961   mapping(address => uint256) private addressMintedBalance;
1962   mapping(uint256 => uint) private _availableTokens;
1963   uint256 private _numAvailableTokens;
1964 
1965   string private _contractUri;
1966 
1967   address _contractOwner;
1968 
1969   mapping (address => bool) private _affiliates;
1970   bool private _allowAffiliateProgram = true;
1971   uint private _affiliateProgramPercentage = 15;
1972 
1973   bool private _allowRecommendation = true;
1974   uint256 private _recommendationPercentage = 10;
1975   uint256 private _royalties = 10;
1976   uint256 royaltiesSpender;
1977 
1978   mapping(address => uint256) private _addressLastMintedTokenId;
1979 
1980   bool private _isFreeMint = false;
1981   uint256 private _nftEtherValue = 250000000000000000;
1982 
1983   event _transferSend(address _from, address _to, uint _amount);
1984 
1985   constructor(
1986     string memory _initBaseURI,
1987     bytes32 _root,
1988     string memory _contractURI
1989   ) ERC721A("Yield Hacker PASS", "YHP") {
1990     setBaseURI(_initBaseURI);
1991     root = _root;
1992     _contractUri = _contractURI;
1993     _contractOwner = msg.sender;
1994   }
1995 
1996     function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
1997       return MerkleProof.verify(proof, root, leaf);
1998     }
1999 
2000     // internal
2001     function _baseURI() internal view virtual override returns (string memory) {
2002       return baseURI;
2003     }
2004 
2005     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2006       baseURI = _newBaseURI;
2007     }
2008 
2009     function setFreeMintPerAddressLimit(uint256 _limit) public onlyOwner {
2010       FreeMintPerAddressLimit = _limit;
2011     }
2012 
2013     function setOnlyWhitelisted(bool _state) public onlyOwner {
2014       onlyWhitelisted = _state;
2015     }
2016 
2017     function isOnlyWhitelist() public view returns (bool) {
2018       return onlyWhitelisted;
2019     }
2020 
2021     function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
2022       maxMintAmount = _maxMintAmount;
2023     }
2024 
2025     function pause(bool _state) public onlyOwner {
2026       paused = _state;
2027     }
2028 
2029     function setAllowAffiliateProgram(bool _state) public onlyOwner {
2030       _allowAffiliateProgram = _state;
2031     }
2032 
2033     function setAffiliateProgramPercentage(uint256 percentage) public onlyOwner {
2034       _affiliateProgramPercentage = percentage;
2035     }
2036 
2037     function withdraw() public payable onlyOwner {
2038       (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2039       require(os);
2040     }
2041 
2042     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2043       maxSupply = _maxSupply;
2044     }
2045 
2046     function setNftEtherValue(uint256 nftEtherValue) public onlyOwner {
2047       _nftEtherValue = nftEtherValue;
2048     }
2049 
2050     function setAffiliate(address manager, bool state) public onlyOwner {
2051       _affiliates[manager] = state;
2052     }
2053 
2054     function setIsFreeMint(bool state) public onlyOwner {
2055         _isFreeMint = state;
2056     }
2057 
2058     function getQtdAvailableTokens() public view returns (uint256) {
2059       if(_numAvailableTokens > 0){
2060         return _numAvailableTokens;
2061       }
2062       return maxSupply;
2063     }
2064 
2065     function getMaxSupply() public view returns (uint) {
2066       return maxSupply;
2067     }
2068 
2069     function getNftEtherValue() public view returns (uint) {
2070       return _nftEtherValue;
2071     }
2072 
2073     function getAddressLastMintedTokenId(address wallet) public view returns (uint256) {
2074       return _addressLastMintedTokenId[wallet];
2075     }
2076 
2077     function getMaxMintAmount() public view returns (uint256) {
2078       return maxMintAmount;
2079     }
2080 
2081     function getBalance() public view returns (uint) {
2082      return msg.sender.balance;
2083     }
2084 
2085     function getBaseURI() public view returns (string memory) {
2086       return baseURI;
2087     }
2088 
2089     function getNFTURI(uint256 tokenId) public view returns(string memory){
2090       return string(abi.encodePacked(baseURI, Strings.toString(tokenId), baseExtension));
2091     }
2092 
2093     function isAffliliated(address wallet) public view returns (bool) {
2094      return _affiliates[wallet];
2095     }
2096 
2097     function contractIsFreeMint() public view returns (bool) {
2098      return _isFreeMint;
2099     }
2100 
2101     function isPaused() public view returns (bool) {
2102       return paused;
2103     }
2104 
2105     function isWhitelisted(address _user, bytes32[] memory proof) public view returns (bool) {
2106       if( isValid( proof, keccak256( abi.encodePacked(_user) ) ) ) {
2107         if (whitelistClaimed[_user]) {
2108           return false;
2109         }
2110         return true;
2111       } else {
2112         return false;
2113       }
2114     }
2115 
2116   
2117     function mintWhitelist(
2118       uint256 _mintAmount,
2119       address payable _recommendedBy,
2120       uint256 _indicationType, //1=directlink, 2=affiliate, 3=recomendation
2121       address payable endUser,
2122       bytes32[] memory proof
2123     ) public payable {
2124       require(!paused, "O contrato pausado");
2125       uint256 supply = totalSupply();
2126       require(_mintAmount > 0, "Precisa mintar pelo menos 1 NFT");
2127       require(_mintAmount + balanceOf(endUser) <= maxMintAmount, "Quantidade limite de mint por carteira excedida");
2128       require(supply + _mintAmount <= maxSupply, "Quantidade limite de NFT excedida");
2129 
2130       if(onlyWhitelisted) {
2131         require(!whitelistClaimed[endUser], "Address ja reivindicado");
2132         require(isValid(proof, keccak256(abi.encodePacked(endUser))), "Nao faz parte da Whitelist");
2133       }
2134 
2135       if(_indicationType == 2) {
2136         require(_allowAffiliateProgram, "No momento o programa de afiliados se encontra desativado");
2137       }
2138 
2139       if(!_isFreeMint ) {
2140         if(!isValid(proof, keccak256(abi.encodePacked(endUser)))) {
2141           split(_mintAmount, _recommendedBy, _indicationType);
2142         } else {
2143           uint tokensIds = walletOfOwner(endUser);
2144           if(tokensIds > 0){
2145             split(_mintAmount, _recommendedBy, _indicationType);
2146           }
2147         }
2148       }
2149 
2150       uint256 updatedNumAvailableTokens = maxSupply - totalSupply();
2151       
2152       for (uint256 i = 1; i <= _mintAmount; i++) {
2153         addressMintedBalance[endUser]++;
2154         _safeMint(endUser, 1);
2155         uint256 newIdToken = supply + 1;
2156         tokenURI(newIdToken);
2157         --updatedNumAvailableTokens;
2158         _addressLastMintedTokenId[endUser] = i;
2159       }
2160 
2161       if (onlyWhitelisted) {
2162         whitelistClaimed[endUser] = true;
2163       }
2164       _numAvailableTokens = updatedNumAvailableTokens;
2165     }
2166 
2167     function mint(
2168       uint256 _mintAmount,
2169       address payable _recommendedBy,
2170       uint256 _indicationType, //1=directlink, 2=affiliate, 3=recomendation
2171       address payable endUser
2172     ) public payable {
2173       require(!paused, "O contrato pausado");
2174       uint256 supply = totalSupply();
2175       require(_mintAmount > 0, "Precisa mintar pelo menos 1 NFT");
2176       require(_mintAmount + balanceOf(endUser) <= maxMintAmount, "Quantidade limite de mint por carteira excedida");
2177       require(supply + _mintAmount <= maxSupply, "Quantidade limite de NFT excedida");
2178 
2179       if(onlyWhitelisted) {
2180         require(!whitelistClaimed[endUser], "Address ja reivindicado");
2181       }
2182 
2183       if(_indicationType == 2) {
2184         require(_allowAffiliateProgram, "No momento o programa de afiliados se encontra desativado");
2185       }
2186 
2187       split(_mintAmount, _recommendedBy, _indicationType);
2188 
2189       uint256 updatedNumAvailableTokens = maxSupply - totalSupply();
2190       
2191       for (uint256 i = 1; i <= _mintAmount; i++) {
2192         addressMintedBalance[endUser]++;
2193         _safeMint(endUser, 1);
2194         uint256 newIdToken = supply + 1;
2195         tokenURI(newIdToken);
2196         --updatedNumAvailableTokens;
2197         _addressLastMintedTokenId[endUser] = i;
2198       }
2199 
2200       if (onlyWhitelisted) {
2201         whitelistClaimed[endUser] = true;
2202       }
2203       _numAvailableTokens = updatedNumAvailableTokens;
2204     }
2205 
2206     function contractURI() external view returns (string memory) {
2207       return _contractUri;
2208     }
2209   
2210     function setContractURI(string memory contractURI_) external onlyOwner {
2211       _contractUri = contractURI_;
2212     }
2213 
2214     function tokenURI(uint256 tokenId)
2215       public
2216       view
2217       virtual
2218       returns (string memory)
2219     {
2220       require(
2221         _exists(tokenId),
2222         "ERC721Metadata: URI query for nonexistent token"
2223       );
2224 
2225       string memory currentBaseURI = _baseURI();
2226       return bytes(currentBaseURI).length > 0
2227           ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
2228           : "";
2229     }
2230 
2231     function walletOfOwner(address _owner)
2232       public
2233       view
2234       returns (uint)
2235     {
2236       return addressMintedBalance[_owner];
2237     }
2238 
2239     function split(uint256 _mintAmount, address payable _recommendedBy, uint256 _indicationType ) public payable{
2240       require(msg.value >= (_nftEtherValue * _mintAmount), "Valor da mintagem diferente do valor definido no contrato");
2241 
2242       uint ownerAmount = msg.value;
2243 
2244       if(_indicationType > 1){
2245 
2246         uint256 _splitPercentage = _recommendationPercentage;
2247         if(_indicationType == 2 && _allowAffiliateProgram){
2248             if( _affiliates[_recommendedBy] ){
2249               _splitPercentage = _affiliateProgramPercentage;
2250             }
2251         }
2252 
2253         uint256 amount = msg.value * _splitPercentage / 100;
2254         ownerAmount = msg.value - amount;
2255 
2256         emit _transferSend(msg.sender, _recommendedBy, amount);
2257         _recommendedBy.transfer(amount);
2258       }
2259       payable(_contractOwner).transfer(ownerAmount);
2260     }
2261 
2262     /**
2263      * @dev See {IERC721-transferFrom}.
2264      */
2265     function transferFrom(
2266         address from,
2267         address to,
2268         uint256 tokenId
2269     ) public virtual override {
2270       _transfer(from, to, tokenId);
2271     }
2272 
2273     /**
2274      * @dev See {IERC721-safeTransferFrom}.
2275      */
2276     function safeTransferFrom(
2277         address from,
2278         address to,
2279         uint256 tokenId
2280     ) public virtual override {
2281         safeTransferFrom(from, to, tokenId, '');
2282     }
2283 
2284     /**
2285      * @dev See {IERC721-safeTransferFrom}.
2286      */
2287     function safeTransferFrom(
2288       address from,
2289       address to,
2290       uint256 tokenId,
2291       bytes memory _data
2292     ) public virtual override {
2293       _transfer(from, to, tokenId);
2294       if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
2295           revert TransferToNonERC721ReceiverImplementer();
2296       }
2297       emit Transfer(from, to, tokenId);
2298     }
2299 }