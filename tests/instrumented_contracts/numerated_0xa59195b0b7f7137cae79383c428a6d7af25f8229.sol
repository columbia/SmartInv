1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
48 
49 
50 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev These functions deal with verification of Merkle Trees proofs.
56  *
57  * The proofs can be generated using the JavaScript library
58  * https://github.com/miguelmota/merkletreejs[merkletreejs].
59  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
60  *
61  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
62  */
63 library MerkleProof {
64     /**
65      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
66      * defined by `root`. For this, a `proof` must be provided, containing
67      * sibling hashes on the branch from the leaf to the root of the tree. Each
68      * pair of leaves and each pair of pre-images are assumed to be sorted.
69      */
70     function verify(
71         bytes32[] memory proof,
72         bytes32 root,
73         bytes32 leaf
74     ) internal pure returns (bool) {
75         return processProof(proof, leaf) == root;
76     }
77 
78     /**
79      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
80      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
81      * hash matches the root of the tree. When processing the proof, the pairs
82      * of leafs & pre-images are assumed to be sorted.
83      *
84      * _Available since v4.4._
85      */
86     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
87         bytes32 computedHash = leaf;
88         for (uint256 i = 0; i < proof.length; i++) {
89             bytes32 proofElement = proof[i];
90             if (computedHash <= proofElement) {
91                 // Hash(current computed hash + current element of the proof)
92                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
93             } else {
94                 // Hash(current element of the proof + current computed hash)
95                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
96             }
97         }
98         return computedHash;
99     }
100 }
101 
102 // File: @openzeppelin/contracts/utils/Strings.sol
103 
104 
105 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev String operations.
111  */
112 library Strings {
113     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
114 
115     /**
116      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
117      */
118     function toString(uint256 value) internal pure returns (string memory) {
119         // Inspired by OraclizeAPI's implementation - MIT licence
120         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
121 
122         if (value == 0) {
123             return "0";
124         }
125         uint256 temp = value;
126         uint256 digits;
127         while (temp != 0) {
128             digits++;
129             temp /= 10;
130         }
131         bytes memory buffer = new bytes(digits);
132         while (value != 0) {
133             digits -= 1;
134             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
135             value /= 10;
136         }
137         return string(buffer);
138     }
139 
140     /**
141      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
142      */
143     function toHexString(uint256 value) internal pure returns (string memory) {
144         if (value == 0) {
145             return "0x00";
146         }
147         uint256 temp = value;
148         uint256 length = 0;
149         while (temp != 0) {
150             length++;
151             temp >>= 8;
152         }
153         return toHexString(value, length);
154     }
155 
156     /**
157      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
158      */
159     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
160         bytes memory buffer = new bytes(2 * length + 2);
161         buffer[0] = "0";
162         buffer[1] = "x";
163         for (uint256 i = 2 * length + 1; i > 1; --i) {
164             buffer[i] = _HEX_SYMBOLS[value & 0xf];
165             value >>= 4;
166         }
167         require(value == 0, "Strings: hex length insufficient");
168         return string(buffer);
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Context.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 /**
180  * @dev Provides information about the current execution context, including the
181  * sender of the transaction and its data. While these are generally available
182  * via msg.sender and msg.data, they should not be accessed in such a direct
183  * manner, since when dealing with meta-transactions the account sending and
184  * paying for execution may not be the actual sender (as far as an application
185  * is concerned).
186  *
187  * This contract is only required for intermediate, library-like contracts.
188  */
189 abstract contract Context {
190     function _msgSender() internal view virtual returns (address) {
191         return msg.sender;
192     }
193 
194     function _msgData() internal view virtual returns (bytes calldata) {
195         return msg.data;
196     }
197 }
198 
199 // File: @openzeppelin/contracts/security/Pausable.sol
200 
201 
202 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 
207 /**
208  * @dev Contract module which allows children to implement an emergency stop
209  * mechanism that can be triggered by an authorized account.
210  *
211  * This module is used through inheritance. It will make available the
212  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
213  * the functions of your contract. Note that they will not be pausable by
214  * simply including this module, only once the modifiers are put in place.
215  */
216 abstract contract Pausable is Context {
217     /**
218      * @dev Emitted when the pause is triggered by `account`.
219      */
220     event Paused(address account);
221 
222     /**
223      * @dev Emitted when the pause is lifted by `account`.
224      */
225     event Unpaused(address account);
226 
227     bool private _paused;
228 
229     /**
230      * @dev Initializes the contract in unpaused state.
231      */
232     constructor() {
233         _paused = false;
234     }
235 
236     /**
237      * @dev Returns true if the contract is paused, and false otherwise.
238      */
239     function paused() public view virtual returns (bool) {
240         return _paused;
241     }
242 
243     /**
244      * @dev Modifier to make a function callable only when the contract is not paused.
245      *
246      * Requirements:
247      *
248      * - The contract must not be paused.
249      */
250     modifier whenNotPaused() {
251         require(!paused(), "Pausable: paused");
252         _;
253     }
254 
255     /**
256      * @dev Modifier to make a function callable only when the contract is paused.
257      *
258      * Requirements:
259      *
260      * - The contract must be paused.
261      */
262     modifier whenPaused() {
263         require(paused(), "Pausable: not paused");
264         _;
265     }
266 
267     /**
268      * @dev Triggers stopped state.
269      *
270      * Requirements:
271      *
272      * - The contract must not be paused.
273      */
274     function _pause() internal virtual whenNotPaused {
275         _paused = true;
276         emit Paused(_msgSender());
277     }
278 
279     /**
280      * @dev Returns to normal state.
281      *
282      * Requirements:
283      *
284      * - The contract must be paused.
285      */
286     function _unpause() internal virtual whenPaused {
287         _paused = false;
288         emit Unpaused(_msgSender());
289     }
290 }
291 
292 // File: @openzeppelin/contracts/access/Ownable.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 
300 /**
301  * @dev Contract module which provides a basic access control mechanism, where
302  * there is an account (an owner) that can be granted exclusive access to
303  * specific functions.
304  *
305  * By default, the owner account will be the one that deploys the contract. This
306  * can later be changed with {transferOwnership}.
307  *
308  * This module is used through inheritance. It will make available the modifier
309  * `onlyOwner`, which can be applied to your functions to restrict their use to
310  * the owner.
311  */
312 abstract contract Ownable is Context {
313     address private _owner;
314 
315     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
316 
317     /**
318      * @dev Initializes the contract setting the deployer as the initial owner.
319      */
320     constructor() {
321         _transferOwnership(_msgSender());
322     }
323 
324     /**
325      * @dev Returns the address of the current owner.
326      */
327     function owner() public view virtual returns (address) {
328         return _owner;
329     }
330 
331     /**
332      * @dev Throws if called by any account other than the owner.
333      */
334     modifier onlyOwner() {
335         require(owner() == _msgSender(), "Ownable: caller is not the owner");
336         _;
337     }
338 
339     /**
340      * @dev Leaves the contract without owner. It will not be possible to call
341      * `onlyOwner` functions anymore. Can only be called by the current owner.
342      *
343      * NOTE: Renouncing ownership will leave the contract without an owner,
344      * thereby removing any functionality that is only available to the owner.
345      */
346     function renounceOwnership() public virtual onlyOwner {
347         _transferOwnership(address(0));
348     }
349 
350     /**
351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
352      * Can only be called by the current owner.
353      */
354     function transferOwnership(address newOwner) public virtual onlyOwner {
355         require(newOwner != address(0), "Ownable: new owner is the zero address");
356         _transferOwnership(newOwner);
357     }
358 
359     /**
360      * @dev Transfers ownership of the contract to a new account (`newOwner`).
361      * Internal function without access restriction.
362      */
363     function _transferOwnership(address newOwner) internal virtual {
364         address oldOwner = _owner;
365         _owner = newOwner;
366         emit OwnershipTransferred(oldOwner, newOwner);
367     }
368 }
369 
370 // File: @openzeppelin/contracts/utils/Address.sol
371 
372 
373 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 /**
378  * @dev Collection of functions related to the address type
379  */
380 library Address {
381     /**
382      * @dev Returns true if `account` is a contract.
383      *
384      * [IMPORTANT]
385      * ====
386      * It is unsafe to assume that an address for which this function returns
387      * false is an externally-owned account (EOA) and not a contract.
388      *
389      * Among others, `isContract` will return false for the following
390      * types of addresses:
391      *
392      *  - an externally-owned account
393      *  - a contract in construction
394      *  - an address where a contract will be created
395      *  - an address where a contract lived, but was destroyed
396      * ====
397      */
398     function isContract(address account) internal view returns (bool) {
399         // This method relies on extcodesize, which returns 0 for contracts in
400         // construction, since the code is only stored at the end of the
401         // constructor execution.
402 
403         uint256 size;
404         assembly {
405             size := extcodesize(account)
406         }
407         return size > 0;
408     }
409 
410     /**
411      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
412      * `recipient`, forwarding all available gas and reverting on errors.
413      *
414      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
415      * of certain opcodes, possibly making contracts go over the 2300 gas limit
416      * imposed by `transfer`, making them unable to receive funds via
417      * `transfer`. {sendValue} removes this limitation.
418      *
419      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
420      *
421      * IMPORTANT: because control is transferred to `recipient`, care must be
422      * taken to not create reentrancy vulnerabilities. Consider using
423      * {ReentrancyGuard} or the
424      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
425      */
426     function sendValue(address payable recipient, uint256 amount) internal {
427         require(address(this).balance >= amount, "Address: insufficient balance");
428 
429         (bool success, ) = recipient.call{value: amount}("");
430         require(success, "Address: unable to send value, recipient may have reverted");
431     }
432 
433     /**
434      * @dev Performs a Solidity function call using a low level `call`. A
435      * plain `call` is an unsafe replacement for a function call: use this
436      * function instead.
437      *
438      * If `target` reverts with a revert reason, it is bubbled up by this
439      * function (like regular Solidity function calls).
440      *
441      * Returns the raw returned data. To convert to the expected return value,
442      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
443      *
444      * Requirements:
445      *
446      * - `target` must be a contract.
447      * - calling `target` with `data` must not revert.
448      *
449      * _Available since v3.1._
450      */
451     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
452         return functionCall(target, data, "Address: low-level call failed");
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
457      * `errorMessage` as a fallback revert reason when `target` reverts.
458      *
459      * _Available since v3.1._
460      */
461     function functionCall(
462         address target,
463         bytes memory data,
464         string memory errorMessage
465     ) internal returns (bytes memory) {
466         return functionCallWithValue(target, data, 0, errorMessage);
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
471      * but also transferring `value` wei to `target`.
472      *
473      * Requirements:
474      *
475      * - the calling contract must have an ETH balance of at least `value`.
476      * - the called Solidity function must be `payable`.
477      *
478      * _Available since v3.1._
479      */
480     function functionCallWithValue(
481         address target,
482         bytes memory data,
483         uint256 value
484     ) internal returns (bytes memory) {
485         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
490      * with `errorMessage` as a fallback revert reason when `target` reverts.
491      *
492      * _Available since v3.1._
493      */
494     function functionCallWithValue(
495         address target,
496         bytes memory data,
497         uint256 value,
498         string memory errorMessage
499     ) internal returns (bytes memory) {
500         require(address(this).balance >= value, "Address: insufficient balance for call");
501         require(isContract(target), "Address: call to non-contract");
502 
503         (bool success, bytes memory returndata) = target.call{value: value}(data);
504         return verifyCallResult(success, returndata, errorMessage);
505     }
506 
507     /**
508      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
509      * but performing a static call.
510      *
511      * _Available since v3.3._
512      */
513     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
514         return functionStaticCall(target, data, "Address: low-level static call failed");
515     }
516 
517     /**
518      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
519      * but performing a static call.
520      *
521      * _Available since v3.3._
522      */
523     function functionStaticCall(
524         address target,
525         bytes memory data,
526         string memory errorMessage
527     ) internal view returns (bytes memory) {
528         require(isContract(target), "Address: static call to non-contract");
529 
530         (bool success, bytes memory returndata) = target.staticcall(data);
531         return verifyCallResult(success, returndata, errorMessage);
532     }
533 
534     /**
535      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
536      * but performing a delegate call.
537      *
538      * _Available since v3.4._
539      */
540     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
541         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
546      * but performing a delegate call.
547      *
548      * _Available since v3.4._
549      */
550     function functionDelegateCall(
551         address target,
552         bytes memory data,
553         string memory errorMessage
554     ) internal returns (bytes memory) {
555         require(isContract(target), "Address: delegate call to non-contract");
556 
557         (bool success, bytes memory returndata) = target.delegatecall(data);
558         return verifyCallResult(success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
563      * revert reason using the provided one.
564      *
565      * _Available since v4.3._
566      */
567     function verifyCallResult(
568         bool success,
569         bytes memory returndata,
570         string memory errorMessage
571     ) internal pure returns (bytes memory) {
572         if (success) {
573             return returndata;
574         } else {
575             // Look for revert reason and bubble it up if present
576             if (returndata.length > 0) {
577                 // The easiest way to bubble the revert reason is using memory via assembly
578 
579                 assembly {
580                     let returndata_size := mload(returndata)
581                     revert(add(32, returndata), returndata_size)
582                 }
583             } else {
584                 revert(errorMessage);
585             }
586         }
587     }
588 }
589 
590 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
591 
592 
593 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @title ERC721 token receiver interface
599  * @dev Interface for any contract that wants to support safeTransfers
600  * from ERC721 asset contracts.
601  */
602 interface IERC721Receiver {
603     /**
604      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
605      * by `operator` from `from`, this function is called.
606      *
607      * It must return its Solidity selector to confirm the token transfer.
608      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
609      *
610      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
611      */
612     function onERC721Received(
613         address operator,
614         address from,
615         uint256 tokenId,
616         bytes calldata data
617     ) external returns (bytes4);
618 }
619 
620 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 /**
628  * @dev Interface of the ERC165 standard, as defined in the
629  * https://eips.ethereum.org/EIPS/eip-165[EIP].
630  *
631  * Implementers can declare support of contract interfaces, which can then be
632  * queried by others ({ERC165Checker}).
633  *
634  * For an implementation, see {ERC165}.
635  */
636 interface IERC165 {
637     /**
638      * @dev Returns true if this contract implements the interface defined by
639      * `interfaceId`. See the corresponding
640      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
641      * to learn more about how these ids are created.
642      *
643      * This function call must use less than 30 000 gas.
644      */
645     function supportsInterface(bytes4 interfaceId) external view returns (bool);
646 }
647 
648 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
649 
650 
651 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
652 
653 pragma solidity ^0.8.0;
654 
655 
656 /**
657  * @dev Implementation of the {IERC165} interface.
658  *
659  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
660  * for the additional interface id that will be supported. For example:
661  *
662  * ```solidity
663  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
664  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
665  * }
666  * ```
667  *
668  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
669  */
670 abstract contract ERC165 is IERC165 {
671     /**
672      * @dev See {IERC165-supportsInterface}.
673      */
674     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
675         return interfaceId == type(IERC165).interfaceId;
676     }
677 }
678 
679 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 
687 /**
688  * @dev Required interface of an ERC721 compliant contract.
689  */
690 interface IERC721 is IERC165 {
691     /**
692      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
693      */
694     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
695 
696     /**
697      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
698      */
699     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
700 
701     /**
702      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
703      */
704     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
705 
706     /**
707      * @dev Returns the number of tokens in ``owner``'s account.
708      */
709     function balanceOf(address owner) external view returns (uint256 balance);
710 
711     /**
712      * @dev Returns the owner of the `tokenId` token.
713      *
714      * Requirements:
715      *
716      * - `tokenId` must exist.
717      */
718     function ownerOf(uint256 tokenId) external view returns (address owner);
719 
720     /**
721      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
722      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
723      *
724      * Requirements:
725      *
726      * - `from` cannot be the zero address.
727      * - `to` cannot be the zero address.
728      * - `tokenId` token must exist and be owned by `from`.
729      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
730      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
731      *
732      * Emits a {Transfer} event.
733      */
734     function safeTransferFrom(
735         address from,
736         address to,
737         uint256 tokenId
738     ) external;
739 
740     /**
741      * @dev Transfers `tokenId` token from `from` to `to`.
742      *
743      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must be owned by `from`.
750      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
751      *
752      * Emits a {Transfer} event.
753      */
754     function transferFrom(
755         address from,
756         address to,
757         uint256 tokenId
758     ) external;
759 
760     /**
761      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
762      * The approval is cleared when the token is transferred.
763      *
764      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
765      *
766      * Requirements:
767      *
768      * - The caller must own the token or be an approved operator.
769      * - `tokenId` must exist.
770      *
771      * Emits an {Approval} event.
772      */
773     function approve(address to, uint256 tokenId) external;
774 
775     /**
776      * @dev Returns the account approved for `tokenId` token.
777      *
778      * Requirements:
779      *
780      * - `tokenId` must exist.
781      */
782     function getApproved(uint256 tokenId) external view returns (address operator);
783 
784     /**
785      * @dev Approve or remove `operator` as an operator for the caller.
786      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
787      *
788      * Requirements:
789      *
790      * - The `operator` cannot be the caller.
791      *
792      * Emits an {ApprovalForAll} event.
793      */
794     function setApprovalForAll(address operator, bool _approved) external;
795 
796     /**
797      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
798      *
799      * See {setApprovalForAll}
800      */
801     function isApprovedForAll(address owner, address operator) external view returns (bool);
802 
803     /**
804      * @dev Safely transfers `tokenId` token from `from` to `to`.
805      *
806      * Requirements:
807      *
808      * - `from` cannot be the zero address.
809      * - `to` cannot be the zero address.
810      * - `tokenId` token must exist and be owned by `from`.
811      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
812      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
813      *
814      * Emits a {Transfer} event.
815      */
816     function safeTransferFrom(
817         address from,
818         address to,
819         uint256 tokenId,
820         bytes calldata data
821     ) external;
822 }
823 
824 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
825 
826 
827 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
828 
829 pragma solidity ^0.8.0;
830 
831 
832 /**
833  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
834  * @dev See https://eips.ethereum.org/EIPS/eip-721
835  */
836 interface IERC721Enumerable is IERC721 {
837     /**
838      * @dev Returns the total amount of tokens stored by the contract.
839      */
840     function totalSupply() external view returns (uint256);
841 
842     /**
843      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
844      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
845      */
846     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
847 
848     /**
849      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
850      * Use along with {totalSupply} to enumerate all tokens.
851      */
852     function tokenByIndex(uint256 index) external view returns (uint256);
853 }
854 
855 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
856 
857 
858 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
859 
860 pragma solidity ^0.8.0;
861 
862 
863 /**
864  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
865  * @dev See https://eips.ethereum.org/EIPS/eip-721
866  */
867 interface IERC721Metadata is IERC721 {
868     /**
869      * @dev Returns the token collection name.
870      */
871     function name() external view returns (string memory);
872 
873     /**
874      * @dev Returns the token collection symbol.
875      */
876     function symbol() external view returns (string memory);
877 
878     /**
879      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
880      */
881     function tokenURI(uint256 tokenId) external view returns (string memory);
882 }
883 
884 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
885 
886 
887 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
888 
889 pragma solidity ^0.8.0;
890 
891 
892 
893 
894 
895 
896 
897 
898 /**
899  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
900  * the Metadata extension, but not including the Enumerable extension, which is available separately as
901  * {ERC721Enumerable}.
902  */
903 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
904     using Address for address;
905     using Strings for uint256;
906 
907     // Token name
908     string private _name;
909 
910     // Token symbol
911     string private _symbol;
912 
913     // Mapping from token ID to owner address
914     mapping(uint256 => address) private _owners;
915 
916     // Mapping owner address to token count
917     mapping(address => uint256) private _balances;
918 
919     // Mapping from token ID to approved address
920     mapping(uint256 => address) private _tokenApprovals;
921 
922     // Mapping from owner to operator approvals
923     mapping(address => mapping(address => bool)) private _operatorApprovals;
924 
925     /**
926      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
927      */
928     constructor(string memory name_, string memory symbol_) {
929         _name = name_;
930         _symbol = symbol_;
931     }
932 
933     /**
934      * @dev See {IERC165-supportsInterface}.
935      */
936     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
937         return
938             interfaceId == type(IERC721).interfaceId ||
939             interfaceId == type(IERC721Metadata).interfaceId ||
940             super.supportsInterface(interfaceId);
941     }
942 
943     /**
944      * @dev See {IERC721-balanceOf}.
945      */
946     function balanceOf(address owner) public view virtual override returns (uint256) {
947         require(owner != address(0), "ERC721: balance query for the zero address");
948         return _balances[owner];
949     }
950 
951     /**
952      * @dev See {IERC721-ownerOf}.
953      */
954     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
955         address owner = _owners[tokenId];
956         require(owner != address(0), "ERC721: owner query for nonexistent token");
957         return owner;
958     }
959 
960     /**
961      * @dev See {IERC721Metadata-name}.
962      */
963     function name() public view virtual override returns (string memory) {
964         return _name;
965     }
966 
967     /**
968      * @dev See {IERC721Metadata-symbol}.
969      */
970     function symbol() public view virtual override returns (string memory) {
971         return _symbol;
972     }
973 
974     /**
975      * @dev See {IERC721Metadata-tokenURI}.
976      */
977     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
978         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
979 
980         string memory baseURI = _baseURI();
981         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
982     }
983 
984     /**
985      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
986      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
987      * by default, can be overriden in child contracts.
988      */
989     function _baseURI() internal view virtual returns (string memory) {
990         return "";
991     }
992 
993     /**
994      * @dev See {IERC721-approve}.
995      */
996     function approve(address to, uint256 tokenId) public virtual override {
997         address owner = ERC721.ownerOf(tokenId);
998         require(to != owner, "ERC721: approval to current owner");
999 
1000         require(
1001             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1002             "ERC721: approve caller is not owner nor approved for all"
1003         );
1004 
1005         _approve(to, tokenId);
1006     }
1007 
1008     /**
1009      * @dev See {IERC721-getApproved}.
1010      */
1011     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1012         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1013 
1014         return _tokenApprovals[tokenId];
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-setApprovalForAll}.
1019      */
1020     function setApprovalForAll(address operator, bool approved) public virtual override {
1021         _setApprovalForAll(_msgSender(), operator, approved);
1022     }
1023 
1024     /**
1025      * @dev See {IERC721-isApprovedForAll}.
1026      */
1027     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1028         return _operatorApprovals[owner][operator];
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-transferFrom}.
1033      */
1034     function transferFrom(
1035         address from,
1036         address to,
1037         uint256 tokenId
1038     ) public virtual override {
1039         //solhint-disable-next-line max-line-length
1040         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1041 
1042         _transfer(from, to, tokenId);
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-safeTransferFrom}.
1047      */
1048     function safeTransferFrom(
1049         address from,
1050         address to,
1051         uint256 tokenId
1052     ) public virtual override {
1053         safeTransferFrom(from, to, tokenId, "");
1054     }
1055 
1056     /**
1057      * @dev See {IERC721-safeTransferFrom}.
1058      */
1059     function safeTransferFrom(
1060         address from,
1061         address to,
1062         uint256 tokenId,
1063         bytes memory _data
1064     ) public virtual override {
1065         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1066         _safeTransfer(from, to, tokenId, _data);
1067     }
1068 
1069     /**
1070      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1071      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1072      *
1073      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1074      *
1075      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1076      * implement alternative mechanisms to perform token transfer, such as signature-based.
1077      *
1078      * Requirements:
1079      *
1080      * - `from` cannot be the zero address.
1081      * - `to` cannot be the zero address.
1082      * - `tokenId` token must exist and be owned by `from`.
1083      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _safeTransfer(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) internal virtual {
1093         _transfer(from, to, tokenId);
1094         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1095     }
1096 
1097     /**
1098      * @dev Returns whether `tokenId` exists.
1099      *
1100      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1101      *
1102      * Tokens start existing when they are minted (`_mint`),
1103      * and stop existing when they are burned (`_burn`).
1104      */
1105     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1106         return _owners[tokenId] != address(0);
1107     }
1108 
1109     /**
1110      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1111      *
1112      * Requirements:
1113      *
1114      * - `tokenId` must exist.
1115      */
1116     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1117         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1118         address owner = ERC721.ownerOf(tokenId);
1119         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1120     }
1121 
1122     /**
1123      * @dev Safely mints `tokenId` and transfers it to `to`.
1124      *
1125      * Requirements:
1126      *
1127      * - `tokenId` must not exist.
1128      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1129      *
1130      * Emits a {Transfer} event.
1131      */
1132     function _safeMint(address to, uint256 tokenId) internal virtual {
1133         _safeMint(to, tokenId, "");
1134     }
1135 
1136     /**
1137      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1138      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1139      */
1140     function _safeMint(
1141         address to,
1142         uint256 tokenId,
1143         bytes memory _data
1144     ) internal virtual {
1145         _mint(to, tokenId);
1146         require(
1147             _checkOnERC721Received(address(0), to, tokenId, _data),
1148             "ERC721: transfer to non ERC721Receiver implementer"
1149         );
1150     }
1151 
1152     /**
1153      * @dev Mints `tokenId` and transfers it to `to`.
1154      *
1155      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1156      *
1157      * Requirements:
1158      *
1159      * - `tokenId` must not exist.
1160      * - `to` cannot be the zero address.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _mint(address to, uint256 tokenId) internal virtual {
1165         require(to != address(0), "ERC721: mint to the zero address");
1166         require(!_exists(tokenId), "ERC721: token already minted");
1167 
1168         _beforeTokenTransfer(address(0), to, tokenId);
1169 
1170         _balances[to] += 1;
1171         _owners[tokenId] = to;
1172 
1173         emit Transfer(address(0), to, tokenId);
1174     }
1175 
1176     /**
1177      * @dev Destroys `tokenId`.
1178      * The approval is cleared when the token is burned.
1179      *
1180      * Requirements:
1181      *
1182      * - `tokenId` must exist.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function _burn(uint256 tokenId) internal virtual {
1187         address owner = ERC721.ownerOf(tokenId);
1188 
1189         _beforeTokenTransfer(owner, address(0), tokenId);
1190 
1191         // Clear approvals
1192         _approve(address(0), tokenId);
1193 
1194         _balances[owner] -= 1;
1195         delete _owners[tokenId];
1196 
1197         emit Transfer(owner, address(0), tokenId);
1198     }
1199 
1200     /**
1201      * @dev Transfers `tokenId` from `from` to `to`.
1202      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1203      *
1204      * Requirements:
1205      *
1206      * - `to` cannot be the zero address.
1207      * - `tokenId` token must be owned by `from`.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function _transfer(
1212         address from,
1213         address to,
1214         uint256 tokenId
1215     ) internal virtual {
1216         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1217         require(to != address(0), "ERC721: transfer to the zero address");
1218 
1219         _beforeTokenTransfer(from, to, tokenId);
1220 
1221         // Clear approvals from the previous owner
1222         _approve(address(0), tokenId);
1223 
1224         _balances[from] -= 1;
1225         _balances[to] += 1;
1226         _owners[tokenId] = to;
1227 
1228         emit Transfer(from, to, tokenId);
1229     }
1230 
1231     /**
1232      * @dev Approve `to` to operate on `tokenId`
1233      *
1234      * Emits a {Approval} event.
1235      */
1236     function _approve(address to, uint256 tokenId) internal virtual {
1237         _tokenApprovals[tokenId] = to;
1238         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1239     }
1240 
1241     /**
1242      * @dev Approve `operator` to operate on all of `owner` tokens
1243      *
1244      * Emits a {ApprovalForAll} event.
1245      */
1246     function _setApprovalForAll(
1247         address owner,
1248         address operator,
1249         bool approved
1250     ) internal virtual {
1251         require(owner != operator, "ERC721: approve to caller");
1252         _operatorApprovals[owner][operator] = approved;
1253         emit ApprovalForAll(owner, operator, approved);
1254     }
1255 
1256     /**
1257      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1258      * The call is not executed if the target address is not a contract.
1259      *
1260      * @param from address representing the previous owner of the given token ID
1261      * @param to target address that will receive the tokens
1262      * @param tokenId uint256 ID of the token to be transferred
1263      * @param _data bytes optional data to send along with the call
1264      * @return bool whether the call correctly returned the expected magic value
1265      */
1266     function _checkOnERC721Received(
1267         address from,
1268         address to,
1269         uint256 tokenId,
1270         bytes memory _data
1271     ) private returns (bool) {
1272         if (to.isContract()) {
1273             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1274                 return retval == IERC721Receiver.onERC721Received.selector;
1275             } catch (bytes memory reason) {
1276                 if (reason.length == 0) {
1277                     revert("ERC721: transfer to non ERC721Receiver implementer");
1278                 } else {
1279                     assembly {
1280                         revert(add(32, reason), mload(reason))
1281                     }
1282                 }
1283             }
1284         } else {
1285             return true;
1286         }
1287     }
1288 
1289     /**
1290      * @dev Hook that is called before any token transfer. This includes minting
1291      * and burning.
1292      *
1293      * Calling conditions:
1294      *
1295      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1296      * transferred to `to`.
1297      * - When `from` is zero, `tokenId` will be minted for `to`.
1298      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1299      * - `from` and `to` are never both zero.
1300      *
1301      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1302      */
1303     function _beforeTokenTransfer(
1304         address from,
1305         address to,
1306         uint256 tokenId
1307     ) internal virtual {}
1308 }
1309 
1310 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1311 
1312 
1313 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1314 
1315 pragma solidity ^0.8.0;
1316 
1317 
1318 
1319 /**
1320  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1321  * enumerability of all the token ids in the contract as well as all token ids owned by each
1322  * account.
1323  */
1324 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1325     // Mapping from owner to list of owned token IDs
1326     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1327 
1328     // Mapping from token ID to index of the owner tokens list
1329     mapping(uint256 => uint256) private _ownedTokensIndex;
1330 
1331     // Array with all token ids, used for enumeration
1332     uint256[] private _allTokens;
1333 
1334     // Mapping from token id to position in the allTokens array
1335     mapping(uint256 => uint256) private _allTokensIndex;
1336 
1337     /**
1338      * @dev See {IERC165-supportsInterface}.
1339      */
1340     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1341         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1342     }
1343 
1344     /**
1345      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1346      */
1347     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1348         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1349         return _ownedTokens[owner][index];
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Enumerable-totalSupply}.
1354      */
1355     function totalSupply() public view virtual override returns (uint256) {
1356         return _allTokens.length;
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Enumerable-tokenByIndex}.
1361      */
1362     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1363         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1364         return _allTokens[index];
1365     }
1366 
1367     /**
1368      * @dev Hook that is called before any token transfer. This includes minting
1369      * and burning.
1370      *
1371      * Calling conditions:
1372      *
1373      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1374      * transferred to `to`.
1375      * - When `from` is zero, `tokenId` will be minted for `to`.
1376      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1377      * - `from` cannot be the zero address.
1378      * - `to` cannot be the zero address.
1379      *
1380      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1381      */
1382     function _beforeTokenTransfer(
1383         address from,
1384         address to,
1385         uint256 tokenId
1386     ) internal virtual override {
1387         super._beforeTokenTransfer(from, to, tokenId);
1388 
1389         if (from == address(0)) {
1390             _addTokenToAllTokensEnumeration(tokenId);
1391         } else if (from != to) {
1392             _removeTokenFromOwnerEnumeration(from, tokenId);
1393         }
1394         if (to == address(0)) {
1395             _removeTokenFromAllTokensEnumeration(tokenId);
1396         } else if (to != from) {
1397             _addTokenToOwnerEnumeration(to, tokenId);
1398         }
1399     }
1400 
1401     /**
1402      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1403      * @param to address representing the new owner of the given token ID
1404      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1405      */
1406     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1407         uint256 length = ERC721.balanceOf(to);
1408         _ownedTokens[to][length] = tokenId;
1409         _ownedTokensIndex[tokenId] = length;
1410     }
1411 
1412     /**
1413      * @dev Private function to add a token to this extension's token tracking data structures.
1414      * @param tokenId uint256 ID of the token to be added to the tokens list
1415      */
1416     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1417         _allTokensIndex[tokenId] = _allTokens.length;
1418         _allTokens.push(tokenId);
1419     }
1420 
1421     /**
1422      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1423      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1424      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1425      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1426      * @param from address representing the previous owner of the given token ID
1427      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1428      */
1429     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1430         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1431         // then delete the last slot (swap and pop).
1432 
1433         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1434         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1435 
1436         // When the token to delete is the last token, the swap operation is unnecessary
1437         if (tokenIndex != lastTokenIndex) {
1438             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1439 
1440             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1441             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1442         }
1443 
1444         // This also deletes the contents at the last position of the array
1445         delete _ownedTokensIndex[tokenId];
1446         delete _ownedTokens[from][lastTokenIndex];
1447     }
1448 
1449     /**
1450      * @dev Private function to remove a token from this extension's token tracking data structures.
1451      * This has O(1) time complexity, but alters the order of the _allTokens array.
1452      * @param tokenId uint256 ID of the token to be removed from the tokens list
1453      */
1454     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1455         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1456         // then delete the last slot (swap and pop).
1457 
1458         uint256 lastTokenIndex = _allTokens.length - 1;
1459         uint256 tokenIndex = _allTokensIndex[tokenId];
1460 
1461         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1462         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1463         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1464         uint256 lastTokenId = _allTokens[lastTokenIndex];
1465 
1466         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1467         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1468 
1469         // This also deletes the contents at the last position of the array
1470         delete _allTokensIndex[tokenId];
1471         _allTokens.pop();
1472     }
1473 }
1474 
1475 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1476 
1477 
1478 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721URIStorage.sol)
1479 
1480 pragma solidity ^0.8.0;
1481 
1482 
1483 /**
1484  * @dev ERC721 token with storage based token URI management.
1485  */
1486 abstract contract ERC721URIStorage is ERC721 {
1487     using Strings for uint256;
1488 
1489     // Optional mapping for token URIs
1490     mapping(uint256 => string) private _tokenURIs;
1491 
1492     /**
1493      * @dev See {IERC721Metadata-tokenURI}.
1494      */
1495     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1496         require(_exists(tokenId), "ERC721URIStorage: URI query for nonexistent token");
1497 
1498         string memory _tokenURI = _tokenURIs[tokenId];
1499         string memory base = _baseURI();
1500 
1501         // If there is no base URI, return the token URI.
1502         if (bytes(base).length == 0) {
1503             return _tokenURI;
1504         }
1505         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1506         if (bytes(_tokenURI).length > 0) {
1507             return string(abi.encodePacked(base, _tokenURI));
1508         }
1509 
1510         return super.tokenURI(tokenId);
1511     }
1512 
1513     /**
1514      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1515      *
1516      * Requirements:
1517      *
1518      * - `tokenId` must exist.
1519      */
1520     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1521         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1522         _tokenURIs[tokenId] = _tokenURI;
1523     }
1524 
1525     /**
1526      * @dev Destroys `tokenId`.
1527      * The approval is cleared when the token is burned.
1528      *
1529      * Requirements:
1530      *
1531      * - `tokenId` must exist.
1532      *
1533      * Emits a {Transfer} event.
1534      */
1535     function _burn(uint256 tokenId) internal virtual override {
1536         super._burn(tokenId);
1537 
1538         if (bytes(_tokenURIs[tokenId]).length != 0) {
1539             delete _tokenURIs[tokenId];
1540         }
1541     }
1542 }
1543 
1544 // File: github/tokenly/330ai-contracts/contracts/CollectorsPassG1/CollectorPassG1.sol
1545 
1546 
1547 pragma solidity 0.8.11;
1548 
1549 
1550 
1551 
1552 
1553 
1554 
1555 contract MerkleValidator {
1556     // The root of Merkle tree for all whitelisted addresses.
1557     bytes32 public immutable merkleroot;
1558 
1559     /// Caller not whitelisted or invalid Merkle proof provided.
1560     error InvalidMerkleProof(address caller);
1561 
1562     // Verifies `msg.sender` address to see if valid leaf node of `merkleroot`.
1563     modifier senderWhitelisted(bytes32[] calldata proof) {
1564         if (!_verify(_leaf(msg.sender), proof)) revert InvalidMerkleProof({ caller: msg.sender });
1565         _;
1566     }
1567 
1568     constructor(bytes32 merkleroot_) {
1569         merkleroot = merkleroot_;
1570     }
1571 
1572     // Returns `keccak256` hash of provided address.
1573     function _leaf(address account) internal pure returns (bytes32) {
1574         return keccak256(abi.encodePacked(account));
1575     }
1576 
1577     // Verifies `proof` to see if `leaf` valid node of `merkleroot`.
1578     function _verify(bytes32 leaf, bytes32[] memory proof) internal view returns (bool) {
1579         return MerkleProof.verify(proof, merkleroot, leaf);
1580     }
1581 }
1582 
1583 contract CollectorsPassG1 is ERC721URIStorage, ERC721Enumerable, MerkleValidator, Ownable, Pausable {
1584     // Use OpenZeppelin's Counters to generate token ids.
1585     using Counters for Counters.Counter;
1586 
1587     // ============ Immutable Storage ============
1588 
1589     // The address that is able to withdraw funds.
1590     address payable public immutable beneficiaryAddress;
1591     // The maximum number of tokens this contract can create.
1592     uint256 public immutable maxSupply;
1593     // The price set to mint a token in Wei; must represent at least 0.1 ETH.
1594     uint256 public immutable mintPriceWei = 100000000000000000;
1595     // Timestamp representing beginning of whitelist mint window.
1596     uint256 public immutable whitelistNotBeforeTime;
1597     // Timestamp representing end of whitelist mint window.
1598     uint256 public immutable whitelistMintEndTime;
1599 
1600     // ============ Mutable Storage ============
1601 
1602     /**
1603      * In order to open minting to anyone, contract owner must
1604      * first call `setOpenMintActive()`, which sets `openMintActive`.
1605      */
1606     bool public openMintActive;
1607     /**
1608      * By calling `endAllMinting()`, value for `allMintingIsEnded` will
1609      * be set to `true`. Once set, this value cannot be unset,
1610      * and locks all remaining minting for the contract permanently.
1611      */
1612     bool public allMintingIsEnded;
1613     // Points to resource which returns token metadata.
1614     string public baseTokenURI;
1615     // Next token id to be set; initially incremented to `1`.
1616     Counters.Counter private _tokenIds;
1617 
1618     // ============ Events ============
1619 
1620     event PassClaimed();
1621     event OpenMintActivated();
1622     event OpenMintDeactivated();
1623     event AllMintingEnded();
1624     event ContractPaused();
1625     event ContractUnpaused();
1626 
1627     // ============ Errors ============
1628 
1629     /// Mint price set too low.
1630     error MintPriceTooLow();
1631     /// Caller has already claimed pass.
1632     error PassAlreadyClaimed();
1633     /// No pass available. Maximum supply has been reached.
1634     error MaxSupplyReached();
1635     /// Caller has sent incorrect amount of ETH.
1636     error IncorrectEthEmount();
1637     /// The whitelist mint is not yet active.
1638     error WhitelistMintNotStarted();
1639     /// The whitelist mint has not yet ended.
1640     error WhitelistMintNotEnded();
1641     /// The whitelist mint has ended.
1642     error WhitelistMintEnded();
1643     /// The open mint is not yet active.
1644     error OpenMintNotActive();
1645     /// All minting has been ended.
1646     error AllMintingAlreadyEnded();
1647     /// The function `endAllMinting()` has already been called.
1648     error EndAllMintingAlreadyCalled();
1649     /// Sender is not beneficiary
1650     error SenderNotBeneficiary();
1651     /// Owner cannot be beneficiary
1652     error OwnerCannotBeBeneficiary();
1653     /// Sender is not adminRecovery
1654     error SenderNotAdminRecovery();
1655 
1656     // ============ Modifiers ============
1657 
1658     modifier allMintingNotEnded() {
1659         if (allMintingIsEnded) revert AllMintingAlreadyEnded();
1660         _;
1661     }
1662 
1663     modifier whitelistMintActive() {
1664         if (block.timestamp < whitelistNotBeforeTime) revert WhitelistMintNotStarted();
1665         if (block.timestamp > whitelistMintEndTime) revert WhitelistMintEnded();
1666         _;
1667     }
1668 
1669     modifier whitelistMintEnded() {
1670         if (block.timestamp < whitelistMintEndTime) revert WhitelistMintNotEnded();
1671         _;
1672     }
1673 
1674     modifier openMintingActive() {
1675         if (!openMintActive) revert OpenMintNotActive();
1676         _;
1677     }
1678 
1679     modifier notAlreadyClaimed() {
1680         if (ERC721.balanceOf(msg.sender) > 0) revert PassAlreadyClaimed();
1681         _;
1682     }
1683 
1684     modifier maxSupplyNotReached() {
1685         if (totalSupply() >= maxSupply) revert MaxSupplyReached();
1686         _;
1687     }
1688 
1689     modifier costs(uint256 price) {
1690         if (msg.value != price) revert IncorrectEthEmount();
1691         _;
1692     }
1693 
1694     modifier onlyBeneficiary() {
1695         if (msg.sender != beneficiaryAddress) revert SenderNotBeneficiary();
1696         _;
1697     }
1698 
1699     // ============ Constructor ============
1700 
1701     constructor(
1702         string memory baseTokenURI_,
1703         uint256 maxSupply_,
1704         bytes32 merkleroot_,
1705         uint256 whitelistNotBeforeTime_,
1706         uint256 whitelistMintDurationSeconds,
1707         address payable beneficiaryAddress_
1708     ) ERC721("Pixelmind Collector's Pass", "PX PASS") MerkleValidator(merkleroot_) {
1709         if (beneficiaryAddress_ == msg.sender) revert OwnerCannotBeBeneficiary();
1710         baseTokenURI = baseTokenURI_;
1711         maxSupply = maxSupply_;
1712         whitelistNotBeforeTime = whitelistNotBeforeTime_;
1713         whitelistMintEndTime = whitelistNotBeforeTime_ + whitelistMintDurationSeconds;
1714         beneficiaryAddress = beneficiaryAddress_;
1715         _tokenIds.increment();
1716     }
1717 
1718     function setBaseURI(string memory baseURI) external onlyOwner {
1719         baseTokenURI = baseURI;
1720     }
1721 
1722     function _baseURI() internal view virtual override returns (string memory) {
1723         return baseTokenURI;
1724     }
1725 
1726     function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
1727         return super.tokenURI(tokenId);
1728     }
1729 
1730     function _beforeTokenTransfer(
1731         address from,
1732         address to,
1733         uint256 tokenId
1734     ) internal override(ERC721, ERC721Enumerable) {
1735         super._beforeTokenTransfer(from, to, tokenId);
1736     }
1737 
1738     function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
1739         super._burn(tokenId);
1740     }
1741 
1742     function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
1743         return super.supportsInterface(interfaceId);
1744     }
1745 
1746     // ============ Redeem ============
1747 
1748     function whitelistMintRedeem(bytes32[] calldata proof)
1749         external
1750         payable
1751         whenNotPaused
1752         allMintingNotEnded
1753         whitelistMintActive
1754         senderWhitelisted(proof)
1755         costs(mintPriceWei)
1756     {
1757         _redeem();
1758     }
1759 
1760     function openMintRedeem() external payable whenNotPaused allMintingNotEnded openMintingActive costs(mintPriceWei) {
1761         _redeem();
1762     }
1763 
1764     // ============ Private Functions ============
1765 
1766     function _redeem() private notAlreadyClaimed maxSupplyNotReached {
1767         uint256 tokenId = 420 + _tokenIds.current();
1768         _tokenIds.increment();
1769         _safeMint(msg.sender, tokenId);
1770         emit PassClaimed();
1771     }
1772 
1773     // ============ Owner Functions ============
1774 
1775     function setOpenMintActive() external onlyOwner whenNotPaused whitelistMintEnded {
1776         openMintActive = true;
1777         emit OpenMintActivated();
1778     }
1779 
1780     function endAllMinting() external onlyOwner whitelistMintEnded {
1781         if (allMintingIsEnded) revert EndAllMintingAlreadyCalled();
1782         allMintingIsEnded = true;
1783         emit AllMintingEnded();
1784     }
1785 
1786     // ============ Beneficiary Functions ============
1787 
1788     function withdraw() external onlyBeneficiary whenNotPaused {
1789         beneficiaryAddress.transfer(address(this).balance);
1790     }
1791 
1792     // ============ Admin Functions ============
1793 
1794     function pauseContract() external onlyOwner {
1795         _pause();
1796         emit Paused(msg.sender);
1797     }
1798 
1799     function unpauseContract() external onlyOwner {
1800         _unpause();
1801         emit Unpaused(msg.sender);
1802     }
1803 
1804     function recoverEth() external onlyOwner whenPaused {
1805         payable(owner()).transfer(address(this).balance);
1806     }
1807 
1808     // ============ Miscellaneous Public and External ============
1809 
1810     function checkWhitelistRedeem(bytes32[] calldata proof)
1811         external
1812         view
1813         whenNotPaused
1814         allMintingNotEnded
1815         whitelistMintActive
1816         senderWhitelisted(proof)
1817         notAlreadyClaimed
1818         maxSupplyNotReached
1819         returns (bool)
1820     {
1821         return true;
1822     }
1823 
1824     function checkOpenRedeem()
1825         external
1826         view
1827         whenNotPaused
1828         allMintingNotEnded
1829         openMintingActive
1830         notAlreadyClaimed
1831         maxSupplyNotReached
1832         returns (bool)
1833     {
1834         return true;
1835     }
1836 }