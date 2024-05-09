1 // SPDX-License-Identifier: MIT
2 
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/MerkleProof.sol
9 
10 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
11 
12 /**
13  * @dev These functions deal with verification of Merkle Trees proofs.
14  *
15  * The proofs can be generated using the JavaScript library
16  * https://github.com/miguelmota/merkletreejs[merkletreejs].
17  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
18  *
19  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
20  *
21  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
22  * hashing, or use a hash function other than keccak256 for hashing leaves.
23  * This is because the concatenation of a sorted pair of internal nodes in
24  * the merkle tree could be reinterpreted as a leaf value.
25  */
26 library MerkleProof {
27     /**
28      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
29      * defined by `root`. For this, a `proof` must be provided, containing
30      * sibling hashes on the branch from the leaf to the root of the tree. Each
31      * pair of leaves and each pair of pre-images are assumed to be sorted.
32      */
33     function verify(
34         bytes32[] memory proof,
35         bytes32 root,
36         bytes32 leaf
37     ) internal pure returns (bool) {
38         return processProof(proof, leaf) == root;
39     }
40 
41     /**
42      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
43      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
44      * hash matches the root of the tree. When processing the proof, the pairs
45      * of leafs & pre-images are assumed to be sorted.
46      *
47      * _Available since v4.4._
48      */
49     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
50         bytes32 computedHash = leaf;
51         for (uint256 i = 0; i < proof.length; i++) {
52             bytes32 proofElement = proof[i];
53             if (computedHash <= proofElement) {
54                 // Hash(current computed hash + current element of the proof)
55                 computedHash = _efficientHash(computedHash, proofElement);
56             } else {
57                 // Hash(current element of the proof + current computed hash)
58                 computedHash = _efficientHash(proofElement, computedHash);
59             }
60         }
61         return computedHash;
62     }
63 
64     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
65         assembly {
66             mstore(0x00, a)
67             mstore(0x20, b)
68             value := keccak256(0x00, 0x40)
69         }
70     }
71 }
72 
73 // File: contracts/Tiny_Frens.sol
74 
75 
76 // File: @openzeppelin/contracts/utils/Counters.sol
77 
78 
79 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
80 
81 pragma solidity ^0.8.0;
82 
83 /**
84  * @title Counters
85  * @author Matt Condon (@shrugs)
86  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
87  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
88  *
89  * Include with `using Counters for Counters.Counter;`
90  */
91 library Counters {
92     struct Counter {
93         // This variable should never be directly accessed by users of the library: interactions must be restricted to
94         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
95         // this feature: see https://github.com/ethereum/solidity/issues/4637
96         uint256 _value; // default: 0
97     }
98 
99     function current(Counter storage counter) internal view returns (uint256) {
100         return counter._value;
101     }
102 
103     function increment(Counter storage counter) internal {
104         unchecked {
105             counter._value += 1;
106         }
107     }
108 
109     function decrement(Counter storage counter) internal {
110         uint256 value = counter._value;
111         require(value > 0, "Counter: decrement overflow");
112         unchecked {
113             counter._value = value - 1;
114         }
115     }
116 
117     function reset(Counter storage counter) internal {
118         counter._value = 0;
119     }
120 }
121 
122 // File: @openzeppelin/contracts/utils/Strings.sol
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev String operations.
131  */
132 library Strings {
133     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
137      */
138     function toString(uint256 value) internal pure returns (string memory) {
139         // Inspired by OraclizeAPI's implementation - MIT licence
140         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
141 
142         if (value == 0) {
143             return "0";
144         }
145         uint256 temp = value;
146         uint256 digits;
147         while (temp != 0) {
148             digits++;
149             temp /= 10;
150         }
151         bytes memory buffer = new bytes(digits);
152         while (value != 0) {
153             digits -= 1;
154             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
155             value /= 10;
156         }
157         return string(buffer);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
162      */
163     function toHexString(uint256 value) internal pure returns (string memory) {
164         if (value == 0) {
165             return "0x00";
166         }
167         uint256 temp = value;
168         uint256 length = 0;
169         while (temp != 0) {
170             length++;
171             temp >>= 8;
172         }
173         return toHexString(value, length);
174     }
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
178      */
179     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
180         bytes memory buffer = new bytes(2 * length + 2);
181         buffer[0] = "0";
182         buffer[1] = "x";
183         for (uint256 i = 2 * length + 1; i > 1; --i) {
184             buffer[i] = _HEX_SYMBOLS[value & 0xf];
185             value >>= 4;
186         }
187         require(value == 0, "Strings: hex length insufficient");
188         return string(buffer);
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Context.sol
193 
194 
195 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Provides information about the current execution context, including the
201  * sender of the transaction and its data. While these are generally available
202  * via msg.sender and msg.data, they should not be accessed in such a direct
203  * manner, since when dealing with meta-transactions the account sending and
204  * paying for execution may not be the actual sender (as far as an application
205  * is concerned).
206  *
207  * This contract is only required for intermediate, library-like contracts.
208  */
209 abstract contract Context {
210     function _msgSender() internal view virtual returns (address) {
211         return msg.sender;
212     }
213 
214     function _msgData() internal view virtual returns (bytes calldata) {
215         return msg.data;
216     }
217 }
218 
219 // File: @openzeppelin/contracts/access/Ownable.sol
220 
221 
222 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
223 
224 pragma solidity ^0.8.0;
225 
226 
227 /**
228  * @dev Contract module which provides a basic access control mechanism, where
229  * there is an account (an owner) that can be granted exclusive access to
230  * specific functions.
231  *
232  * By default, the owner account will be the one that deploys the contract. This
233  * can later be changed with {transferOwnership}.
234  *
235  * This module is used through inheritance. It will make available the modifier
236  * `onlyOwner`, which can be applied to your functions to restrict their use to
237  * the owner.
238  */
239 abstract contract Ownable is Context {
240     address private _owner;
241 
242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
243 
244     /**
245      * @dev Initializes the contract setting the deployer as the initial owner.
246      */
247     constructor() {
248         _transferOwnership(_msgSender());
249     }
250 
251     /**
252      * @dev Returns the address of the current owner.
253      */
254     function owner() public view virtual returns (address) {
255         return _owner;
256     }
257 
258     /**
259      * @dev Throws if called by any account other than the owner.
260      */
261     modifier onlyOwner() {
262         require(owner() == _msgSender(), "Ownable: caller is not the owner");
263         _;
264     }
265 
266     /**
267      * @dev Leaves the contract without owner. It will not be possible to call
268      * `onlyOwner` functions anymore. Can only be called by the current owner.
269      *
270      * NOTE: Renouncing ownership will leave the contract without an owner,
271      * thereby removing any functionality that is only available to the owner.
272      */
273     function renounceOwnership() public virtual onlyOwner {
274         _transferOwnership(address(0));
275     }
276 
277     /**
278      * @dev Transfers ownership of the contract to a new account (`newOwner`).
279      * Can only be called by the current owner.
280      */
281     function transferOwnership(address newOwner) public virtual onlyOwner {
282         require(newOwner != address(0), "Ownable: new owner is the zero address");
283         _transferOwnership(newOwner);
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Internal function without access restriction.
289      */
290     function _transferOwnership(address newOwner) internal virtual {
291         address oldOwner = _owner;
292         _owner = newOwner;
293         emit OwnershipTransferred(oldOwner, newOwner);
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Address.sol
298 
299 
300 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
301 
302 pragma solidity ^0.8.0;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         assembly {
332             size := extcodesize(account)
333         }
334         return size > 0;
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(address(this).balance >= amount, "Address: insufficient balance");
355 
356         (bool success, ) = recipient.call{value: amount}("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain `call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
379         return functionCall(target, data, "Address: low-level call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
384      * `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, 0, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but also transferring `value` wei to `target`.
399      *
400      * Requirements:
401      *
402      * - the calling contract must have an ETH balance of at least `value`.
403      * - the called Solidity function must be `payable`.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(
408         address target,
409         bytes memory data,
410         uint256 value
411     ) internal returns (bytes memory) {
412         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
417      * with `errorMessage` as a fallback revert reason when `target` reverts.
418      *
419      * _Available since v3.1._
420      */
421     function functionCallWithValue(
422         address target,
423         bytes memory data,
424         uint256 value,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(address(this).balance >= value, "Address: insufficient balance for call");
428         require(isContract(target), "Address: call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.call{value: value}(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a static call.
437      *
438      * _Available since v3.3._
439      */
440     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
441         return functionStaticCall(target, data, "Address: low-level static call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a static call.
447      *
448      * _Available since v3.3._
449      */
450     function functionStaticCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal view returns (bytes memory) {
455         require(isContract(target), "Address: static call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.staticcall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
468         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(
478         address target,
479         bytes memory data,
480         string memory errorMessage
481     ) internal returns (bytes memory) {
482         require(isContract(target), "Address: delegate call to non-contract");
483 
484         (bool success, bytes memory returndata) = target.delegatecall(data);
485         return verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     /**
489      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
490      * revert reason using the provided one.
491      *
492      * _Available since v4.3._
493      */
494     function verifyCallResult(
495         bool success,
496         bytes memory returndata,
497         string memory errorMessage
498     ) internal pure returns (bytes memory) {
499         if (success) {
500             return returndata;
501         } else {
502             // Look for revert reason and bubble it up if present
503             if (returndata.length > 0) {
504                 // The easiest way to bubble the revert reason is using memory via assembly
505 
506                 assembly {
507                     let returndata_size := mload(returndata)
508                     revert(add(32, returndata), returndata_size)
509                 }
510             } else {
511                 revert(errorMessage);
512             }
513         }
514     }
515 }
516 
517 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @title ERC721 token receiver interface
526  * @dev Interface for any contract that wants to support safeTransfers
527  * from ERC721 asset contracts.
528  */
529 interface IERC721Receiver {
530     /**
531      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
532      * by `operator` from `from`, this function is called.
533      *
534      * It must return its Solidity selector to confirm the token transfer.
535      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
536      *
537      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
538      */
539     function onERC721Received(
540         address operator,
541         address from,
542         uint256 tokenId,
543         bytes calldata data
544     ) external returns (bytes4);
545 }
546 
547 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
548 
549 
550 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 /**
555  * @dev Interface of the ERC165 standard, as defined in the
556  * https://eips.ethereum.org/EIPS/eip-165[EIP].
557  *
558  * Implementers can declare support of contract interfaces, which can then be
559  * queried by others ({ERC165Checker}).
560  *
561  * For an implementation, see {ERC165}.
562  */
563 interface IERC165 {
564     /**
565      * @dev Returns true if this contract implements the interface defined by
566      * `interfaceId`. See the corresponding
567      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
568      * to learn more about how these ids are created.
569      *
570      * This function call must use less than 30 000 gas.
571      */
572     function supportsInterface(bytes4 interfaceId) external view returns (bool);
573 }
574 
575 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
576 
577 
578 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
579 
580 pragma solidity ^0.8.0;
581 
582 
583 /**
584  * @dev Implementation of the {IERC165} interface.
585  *
586  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
587  * for the additional interface id that will be supported. For example:
588  *
589  * ```solidity
590  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
591  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
592  * }
593  * ```
594  *
595  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
596  */
597 abstract contract ERC165 is IERC165 {
598     /**
599      * @dev See {IERC165-supportsInterface}.
600      */
601     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
602         return interfaceId == type(IERC165).interfaceId;
603     }
604 }
605 
606 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
607 
608 
609 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev Required interface of an ERC721 compliant contract.
616  */
617 interface IERC721 is IERC165 {
618     /**
619      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
620      */
621     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
622 
623     /**
624      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
625      */
626     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
627 
628     /**
629      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
630      */
631     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
632 
633     /**
634      * @dev Returns the number of tokens in ``owner``'s account.
635      */
636     function balanceOf(address owner) external view returns (uint256 balance);
637 
638     /**
639      * @dev Returns the owner of the `tokenId` token.
640      *
641      * Requirements:
642      *
643      * - `tokenId` must exist.
644      */
645     function ownerOf(uint256 tokenId) external view returns (address owner);
646 
647     /**
648      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
649      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
650      *
651      * Requirements:
652      *
653      * - `from` cannot be the zero address.
654      * - `to` cannot be the zero address.
655      * - `tokenId` token must exist and be owned by `from`.
656      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
657      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
658      *
659      * Emits a {Transfer} event.
660      */
661     function safeTransferFrom(
662         address from,
663         address to,
664         uint256 tokenId
665     ) external;
666 
667     /**
668      * @dev Transfers `tokenId` token from `from` to `to`.
669      *
670      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
671      *
672      * Requirements:
673      *
674      * - `from` cannot be the zero address.
675      * - `to` cannot be the zero address.
676      * - `tokenId` token must be owned by `from`.
677      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
678      *
679      * Emits a {Transfer} event.
680      */
681     function transferFrom(
682         address from,
683         address to,
684         uint256 tokenId
685     ) external;
686 
687     /**
688      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
689      * The approval is cleared when the token is transferred.
690      *
691      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
692      *
693      * Requirements:
694      *
695      * - The caller must own the token or be an approved operator.
696      * - `tokenId` must exist.
697      *
698      * Emits an {Approval} event.
699      */
700     function approve(address to, uint256 tokenId) external;
701 
702     /**
703      * @dev Returns the account approved for `tokenId` token.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      */
709     function getApproved(uint256 tokenId) external view returns (address operator);
710 
711     /**
712      * @dev Approve or remove `operator` as an operator for the caller.
713      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
714      *
715      * Requirements:
716      *
717      * - The `operator` cannot be the caller.
718      *
719      * Emits an {ApprovalForAll} event.
720      */
721     function setApprovalForAll(address operator, bool _approved) external;
722 
723     /**
724      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
725      *
726      * See {setApprovalForAll}
727      */
728     function isApprovedForAll(address owner, address operator) external view returns (bool);
729 
730     /**
731      * @dev Safely transfers `tokenId` token from `from` to `to`.
732      *
733      * Requirements:
734      *
735      * - `from` cannot be the zero address.
736      * - `to` cannot be the zero address.
737      * - `tokenId` token must exist and be owned by `from`.
738      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
739      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
740      *
741      * Emits a {Transfer} event.
742      */
743     function safeTransferFrom(
744         address from,
745         address to,
746         uint256 tokenId,
747         bytes calldata data
748     ) external;
749 }
750 
751 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
752 
753 
754 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 
759 /**
760  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
761  * @dev See https://eips.ethereum.org/EIPS/eip-721
762  */
763 interface IERC721Metadata is IERC721 {
764     /**
765      * @dev Returns the token collection name.
766      */
767     function name() external view returns (string memory);
768 
769     /**
770      * @dev Returns the token collection symbol.
771      */
772     function symbol() external view returns (string memory);
773 
774     /**
775      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
776      */
777     function tokenURI(uint256 tokenId) external view returns (string memory);
778 }
779 
780 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
781 
782 
783 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
784 
785 pragma solidity ^0.8.0;
786 
787 
788 
789 
790 
791 
792 
793 
794 /**
795  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
796  * the Metadata extension, but not including the Enumerable extension, which is available separately as
797  * {ERC721Enumerable}.
798  */
799 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
800     using Address for address;
801     using Strings for uint256;
802 
803     // Token name
804     string private _name;
805 
806     // Token symbol
807     string private _symbol;
808 
809     // Mapping from token ID to owner address
810     mapping(uint256 => address) private _owners;
811 
812     // Mapping owner address to token count
813     mapping(address => uint256) private _balances;
814 
815     // Mapping from token ID to approved address
816     mapping(uint256 => address) private _tokenApprovals;
817 
818     // Mapping from owner to operator approvals
819     mapping(address => mapping(address => bool)) private _operatorApprovals;
820 
821     /**
822      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
823      */
824     constructor(string memory name_, string memory symbol_) {
825         _name = name_;
826         _symbol = symbol_;
827     }
828 
829     /**
830      * @dev See {IERC165-supportsInterface}.
831      */
832     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
833         return
834             interfaceId == type(IERC721).interfaceId ||
835             interfaceId == type(IERC721Metadata).interfaceId ||
836             super.supportsInterface(interfaceId);
837     }
838 
839     /**
840      * @dev See {IERC721-balanceOf}.
841      */
842     function balanceOf(address owner) public view virtual override returns (uint256) {
843         require(owner != address(0), "ERC721: balance query for the zero address");
844         return _balances[owner];
845     }
846 
847     /**
848      * @dev See {IERC721-ownerOf}.
849      */
850     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
851         address owner = _owners[tokenId];
852         require(owner != address(0), "ERC721: owner query for nonexistent token");
853         return owner;
854     }
855 
856     /**
857      * @dev See {IERC721Metadata-name}.
858      */
859     function name() public view virtual override returns (string memory) {
860         return _name;
861     }
862 
863     /**
864      * @dev See {IERC721Metadata-symbol}.
865      */
866     function symbol() public view virtual override returns (string memory) {
867         return _symbol;
868     }
869 
870     /**
871      * @dev See {IERC721Metadata-tokenURI}.
872      */
873     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
874         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
875 
876         string memory baseURI = _baseURI();
877         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
878     }
879 
880     /**
881      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
882      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
883      * by default, can be overriden in child contracts.
884      */
885     function _baseURI() internal view virtual returns (string memory) {
886         return "";
887     }
888 
889     /**
890      * @dev See {IERC721-approve}.
891      */
892     function approve(address to, uint256 tokenId) public virtual override {
893         address owner = ERC721.ownerOf(tokenId);
894         require(to != owner, "ERC721: approval to current owner");
895 
896         require(
897             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
898             "ERC721: approve caller is not owner nor approved for all"
899         );
900 
901         _approve(to, tokenId);
902     }
903 
904     /**
905      * @dev See {IERC721-getApproved}.
906      */
907     function getApproved(uint256 tokenId) public view virtual override returns (address) {
908         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
909 
910         return _tokenApprovals[tokenId];
911     }
912 
913     /**
914      * @dev See {IERC721-setApprovalForAll}.
915      */
916     function setApprovalForAll(address operator, bool approved) public virtual override {
917         _setApprovalForAll(_msgSender(), operator, approved);
918     }
919 
920     /**
921      * @dev See {IERC721-isApprovedForAll}.
922      */
923     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
924         return _operatorApprovals[owner][operator];
925     }
926 
927     /**
928      * @dev See {IERC721-transferFrom}.
929      */
930     function transferFrom(
931         address from,
932         address to,
933         uint256 tokenId
934     ) public virtual override {
935         //solhint-disable-next-line max-line-length
936         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
937 
938         _transfer(from, to, tokenId);
939     }
940 
941     /**
942      * @dev See {IERC721-safeTransferFrom}.
943      */
944     function safeTransferFrom(
945         address from,
946         address to,
947         uint256 tokenId
948     ) public virtual override {
949         safeTransferFrom(from, to, tokenId, "");
950     }
951 
952     /**
953      * @dev See {IERC721-safeTransferFrom}.
954      */
955     function safeTransferFrom(
956         address from,
957         address to,
958         uint256 tokenId,
959         bytes memory _data
960     ) public virtual override {
961         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
962         _safeTransfer(from, to, tokenId, _data);
963     }
964 
965     /**
966      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
967      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
968      *
969      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
970      *
971      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
972      * implement alternative mechanisms to perform token transfer, such as signature-based.
973      *
974      * Requirements:
975      *
976      * - `from` cannot be the zero address.
977      * - `to` cannot be the zero address.
978      * - `tokenId` token must exist and be owned by `from`.
979      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
980      *
981      * Emits a {Transfer} event.
982      */
983     function _safeTransfer(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) internal virtual {
989         _transfer(from, to, tokenId);
990         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
991     }
992 
993     /**
994      * @dev Returns whether `tokenId` exists.
995      *
996      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
997      *
998      * Tokens start existing when they are minted (`_mint`),
999      * and stop existing when they are burned (`_burn`).
1000      */
1001     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1002         return _owners[tokenId] != address(0);
1003     }
1004 
1005     /**
1006      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1007      *
1008      * Requirements:
1009      *
1010      * - `tokenId` must exist.
1011      */
1012     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1013         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1014         address owner = ERC721.ownerOf(tokenId);
1015         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1016     }
1017 
1018     /**
1019      * @dev Safely mints `tokenId` and transfers it to `to`.
1020      *
1021      * Requirements:
1022      *
1023      * - `tokenId` must not exist.
1024      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1025      *
1026      * Emits a {Transfer} event.
1027      */
1028     function _safeMint(address to, uint256 tokenId) internal virtual {
1029         _safeMint(to, tokenId, "");
1030     }
1031 
1032     /**
1033      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1034      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1035      */
1036     function _safeMint(
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) internal virtual {
1041         _mint(to, tokenId);
1042         require(
1043             _checkOnERC721Received(address(0), to, tokenId, _data),
1044             "ERC721: transfer to non ERC721Receiver implementer"
1045         );
1046     }
1047 
1048     /**
1049      * @dev Mints `tokenId` and transfers it to `to`.
1050      *
1051      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1052      *
1053      * Requirements:
1054      *
1055      * - `tokenId` must not exist.
1056      * - `to` cannot be the zero address.
1057      *
1058      * Emits a {Transfer} event.
1059      */
1060     function _mint(address to, uint256 tokenId) internal virtual {
1061         require(to != address(0), "ERC721: mint to the zero address");
1062         require(!_exists(tokenId), "ERC721: token already minted");
1063 
1064         _beforeTokenTransfer(address(0), to, tokenId);
1065 
1066         _balances[to] += 1;
1067         _owners[tokenId] = to;
1068 
1069         emit Transfer(address(0), to, tokenId);
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
1094     }
1095 
1096     /**
1097      * @dev Transfers `tokenId` from `from` to `to`.
1098      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1099      *
1100      * Requirements:
1101      *
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      *
1105      * Emits a {Transfer} event.
1106      */
1107     function _transfer(
1108         address from,
1109         address to,
1110         uint256 tokenId
1111     ) internal virtual {
1112         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1113         require(to != address(0), "ERC721: transfer to the zero address");
1114 
1115         _beforeTokenTransfer(from, to, tokenId);
1116 
1117         // Clear approvals from the previous owner
1118         _approve(address(0), tokenId);
1119 
1120         _balances[from] -= 1;
1121         _balances[to] += 1;
1122         _owners[tokenId] = to;
1123 
1124         emit Transfer(from, to, tokenId);
1125     }
1126 
1127     /**
1128      * @dev Approve `to` to operate on `tokenId`
1129      *
1130      * Emits a {Approval} event.
1131      */
1132     function _approve(address to, uint256 tokenId) internal virtual {
1133         _tokenApprovals[tokenId] = to;
1134         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1135     }
1136 
1137     /**
1138      * @dev Approve `operator` to operate on all of `owner` tokens
1139      *
1140      * Emits a {ApprovalForAll} event.
1141      */
1142     function _setApprovalForAll(
1143         address owner,
1144         address operator,
1145         bool approved
1146     ) internal virtual {
1147         require(owner != operator, "ERC721: approve to caller");
1148         _operatorApprovals[owner][operator] = approved;
1149         emit ApprovalForAll(owner, operator, approved);
1150     }
1151 
1152     /**
1153      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1154      * The call is not executed if the target address is not a contract.
1155      *
1156      * @param from address representing the previous owner of the given token ID
1157      * @param to target address that will receive the tokens
1158      * @param tokenId uint256 ID of the token to be transferred
1159      * @param _data bytes optional data to send along with the call
1160      * @return bool whether the call correctly returned the expected magic value
1161      */
1162     function _checkOnERC721Received(
1163         address from,
1164         address to,
1165         uint256 tokenId,
1166         bytes memory _data
1167     ) private returns (bool) {
1168         if (to.isContract()) {
1169             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1170                 return retval == IERC721Receiver.onERC721Received.selector;
1171             } catch (bytes memory reason) {
1172                 if (reason.length == 0) {
1173                     revert("ERC721: transfer to non ERC721Receiver implementer");
1174                 } else {
1175                     assembly {
1176                         revert(add(32, reason), mload(reason))
1177                     }
1178                 }
1179             }
1180         } else {
1181             return true;
1182         }
1183     }
1184 
1185     /**
1186      * @dev Hook that is called before any token transfer. This includes minting
1187      * and burning.
1188      *
1189      * Calling conditions:
1190      *
1191      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1192      * transferred to `to`.
1193      * - When `from` is zero, `tokenId` will be minted for `to`.
1194      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1195      * - `from` and `to` are never both zero.
1196      *
1197      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1198      */
1199     function _beforeTokenTransfer(
1200         address from,
1201         address to,
1202         uint256 tokenId
1203     ) internal virtual {}
1204 }
1205 
1206 // File: contracts/contract.sol
1207 
1208 
1209 
1210 
1211 
1212 pragma solidity >=0.7.0 <0.9.0;
1213 
1214 
1215 contract ApePooClub is ERC721, Ownable {
1216   using Strings for uint256;
1217   using Counters for Counters.Counter;
1218 
1219   Counters.Counter private supply;
1220 
1221   string public uriPrefix = "";
1222   
1223   uint256 public vipSaleCost = 0.1 ether;
1224   uint256 public presaleCost = 0.12 ether;
1225   uint256 public publicSaleCost = 0.15 ether;
1226 
1227   uint256 public maxSupply = 10015;
1228   uint256 public maxMintAmountPerPublicAccount = 5;
1229   uint256 public maxMintAmountPerPresaleAccount = 3;
1230   uint256 public maxMintAmountPerVipAccount = 3;
1231 
1232 
1233   bool public paused = true;
1234   bool public vipSaleActive=true;
1235   bool public presaleActive=false;
1236   bool public publicSaleActive=false;
1237 
1238   bytes32 public merkleRoot= 0x0de6c9f4b501d88b442db96c4f3653e394ef2ce0c67fc9d33527d625663f633c;
1239 
1240   constructor() ERC721("Ape Poo Club", "APC") {
1241     
1242     
1243 
1244   }
1245 
1246   modifier mintCompliance(uint256 _mintAmount) {
1247     require(_mintAmount > 0, "Invalid mint amount!");
1248     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded!");
1249     _;
1250   }
1251 
1252   function totalSupply() public view returns (uint256) {
1253     return supply.current();
1254   }
1255 
1256   function mint(bytes32[] calldata _merkleProof, uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
1257     require(!paused, "The contract is paused!");
1258     if(vipSaleActive==true){
1259       require(msg.value >= vipSaleCost * _mintAmount, "Insufficient funds!");
1260       require(balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerVipAccount, "Mint limit exceeded." );
1261 
1262       //verify the provided _merkleProof
1263       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1264       require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not part of the VIP whitelist.");
1265     }
1266     else if(presaleActive==true){
1267       require(msg.value >= presaleCost * _mintAmount, "Insufficient funds!");
1268       require(balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerPresaleAccount, "Mint limit exceeded." );
1269 
1270       //verify the provided _merkleProof
1271       bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1272       require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "Not part of the Presale whitelist.");
1273     }
1274     else{
1275       require(msg.value >= publicSaleCost * _mintAmount, "Insufficient funds!");
1276       require(balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerPublicAccount, "Mint limit exceeded." );
1277     }
1278     _mintLoop(msg.sender, _mintAmount);
1279   }
1280 
1281   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1282     _mintLoop(_receiver, _mintAmount);
1283   }
1284 
1285   function walletOfOwner(address _owner)
1286     public
1287     view
1288     returns (uint256[] memory)
1289   {
1290     uint256 ownerTokenCount = balanceOf(_owner);
1291     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1292     uint256 currentTokenId = 1;
1293     uint256 ownedTokenIndex = 0;
1294 
1295     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1296       address currentTokenOwner = ownerOf(currentTokenId);
1297 
1298       if (currentTokenOwner == _owner) {
1299         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1300 
1301         ownedTokenIndex++;
1302       }
1303 
1304       currentTokenId++;
1305     }
1306 
1307     return ownedTokenIds;
1308   }
1309 
1310   function tokenURI(uint256 _tokenId)
1311     public
1312     view
1313     virtual
1314     override
1315     returns (string memory)
1316   {
1317     require(
1318       _exists(_tokenId),
1319       "ERC721Metadata: URI query for nonexistent token"
1320     );
1321 
1322     string memory currentBaseURI = _baseURI();
1323     return bytes(currentBaseURI).length > 0
1324         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1325         : "";
1326   }
1327 
1328   function setPublicSaleCost(uint256 _publicSaleCost) public onlyOwner {
1329     publicSaleCost = _publicSaleCost;
1330   }
1331 
1332   function setPresaleCost(uint256 _presaleCost) public onlyOwner {
1333     presaleCost = _presaleCost;
1334   }
1335 
1336   function setVipSaleCost(uint256 _vipSaleCost) public onlyOwner {
1337     vipSaleCost = _vipSaleCost;
1338   }
1339 
1340 
1341   function setMaxMintPerVipAccount(uint256 _maxMintPerVipAccount) public onlyOwner {
1342     maxMintAmountPerVipAccount = _maxMintPerVipAccount;
1343   }
1344 
1345   function setMaxMintPerPresaleAccount(uint256 _maxMintPerPresaleAccount) public onlyOwner {
1346     maxMintAmountPerPresaleAccount = _maxMintPerPresaleAccount;
1347   }
1348    
1349   function setMaxMintPerPublicAccount(uint256 _maxMintPerPublicAccount) public onlyOwner {
1350     maxMintAmountPerPublicAccount = _maxMintPerPublicAccount;
1351   }
1352 
1353   function endVipSale() public onlyOwner {
1354     vipSaleActive = false;
1355     presaleActive = true;
1356     paused=true;
1357   }
1358 
1359   function endPresale() public onlyOwner {
1360     require(vipSaleActive==false);
1361     presaleActive=false;
1362     publicSaleActive=true;
1363     paused=true;
1364   }
1365 
1366   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1367     uriPrefix = _uriPrefix;
1368   }
1369 
1370   function setPaused(bool _state) public onlyOwner {
1371     paused = _state;
1372   }
1373 
1374   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1375     merkleRoot = _merkleRoot;
1376   }
1377 
1378   function withdraw() public onlyOwner {
1379    
1380     // This will transfer the remaining contract balance to the owner.
1381     // Do not remove this otherwise you will not be able to withdraw the funds.
1382     // =============================================================================
1383     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1384     require(os);
1385     // =============================================================================
1386   }
1387 
1388   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1389     for (uint256 i = 0; i < _mintAmount; i++) {
1390       supply.increment();
1391       _safeMint(_receiver, supply.current());
1392     }
1393   }
1394 
1395   function _baseURI() internal view virtual override returns (string memory) {
1396     return uriPrefix;
1397   }
1398 }