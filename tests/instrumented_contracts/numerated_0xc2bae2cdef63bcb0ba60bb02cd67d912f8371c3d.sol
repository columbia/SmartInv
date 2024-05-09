1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity >=0.7.0 <0.9.0;
4 
5 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
9 
10 pragma solidity ^0.8.0;
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
73 // File: @openzeppelin/contracts/utils/Strings.sol
74 
75 
76 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev String operations.
82  */
83 library Strings {
84     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
85 
86     /**
87      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
88      */
89     function toString(uint256 value) internal pure returns (string memory) {
90         // Inspired by OraclizeAPI's implementation - MIT licence
91         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
92 
93         if (value == 0) {
94             return "0";
95         }
96         uint256 temp = value;
97         uint256 digits;
98         while (temp != 0) {
99             digits++;
100             temp /= 10;
101         }
102         bytes memory buffer = new bytes(digits);
103         while (value != 0) {
104             digits -= 1;
105             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
106             value /= 10;
107         }
108         return string(buffer);
109     }
110 
111     /**
112      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
113      */
114     function toHexString(uint256 value) internal pure returns (string memory) {
115         if (value == 0) {
116             return "0x00";
117         }
118         uint256 temp = value;
119         uint256 length = 0;
120         while (temp != 0) {
121             length++;
122             temp >>= 8;
123         }
124         return toHexString(value, length);
125     }
126 
127     /**
128      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
129      */
130     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
131         bytes memory buffer = new bytes(2 * length + 2);
132         buffer[0] = "0";
133         buffer[1] = "x";
134         for (uint256 i = 2 * length + 1; i > 1; --i) {
135             buffer[i] = _HEX_SYMBOLS[value & 0xf];
136             value >>= 4;
137         }
138         require(value == 0, "Strings: hex length insufficient");
139         return string(buffer);
140     }
141 }
142 
143 // File: @openzeppelin/contracts/utils/Context.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Provides information about the current execution context, including the
152  * sender of the transaction and its data. While these are generally available
153  * via msg.sender and msg.data, they should not be accessed in such a direct
154  * manner, since when dealing with meta-transactions the account sending and
155  * paying for execution may not be the actual sender (as far as an application
156  * is concerned).
157  *
158  * This contract is only required for intermediate, library-like contracts.
159  */
160 abstract contract Context {
161     function _msgSender() internal view virtual returns (address) {
162         return msg.sender;
163     }
164 
165     function _msgData() internal view virtual returns (bytes calldata) {
166         return msg.data;
167     }
168 }
169 
170 // File: @openzeppelin/contracts/security/Pausable.sol
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 
178 /**
179  * @dev Contract module which allows children to implement an emergency stop
180  * mechanism that can be triggered by an authorized account.
181  *
182  * This module is used through inheritance. It will make available the
183  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
184  * the functions of your contract. Note that they will not be pausable by
185  * simply including this module, only once the modifiers are put in place.
186  */
187 abstract contract Pausable is Context {
188     /**
189      * @dev Emitted when the pause is triggered by `account`.
190      */
191     event Paused(address account);
192 
193     /**
194      * @dev Emitted when the pause is lifted by `account`.
195      */
196     event Unpaused(address account);
197 
198     bool private _paused;
199 
200     /**
201      * @dev Initializes the contract in unpaused state.
202      */
203     constructor() {
204         _paused = false;
205     }
206 
207     /**
208      * @dev Returns true if the contract is paused, and false otherwise.
209      */
210     function paused() public view virtual returns (bool) {
211         return _paused;
212     }
213 
214     /**
215      * @dev Modifier to make a function callable only when the contract is not paused.
216      *
217      * Requirements:
218      *
219      * - The contract must not be paused.
220      */
221     modifier whenNotPaused() {
222         require(!paused(), "Pausable: paused");
223         _;
224     }
225 
226     /**
227      * @dev Modifier to make a function callable only when the contract is paused.
228      *
229      * Requirements:
230      *
231      * - The contract must be paused.
232      */
233     modifier whenPaused() {
234         require(paused(), "Pausable: not paused");
235         _;
236     }
237 
238     /**
239      * @dev Triggers stopped state.
240      *
241      * Requirements:
242      *
243      * - The contract must not be paused.
244      */
245     function _pause() internal virtual whenNotPaused {
246         _paused = true;
247         emit Paused(_msgSender());
248     }
249 
250     /**
251      * @dev Returns to normal state.
252      *
253      * Requirements:
254      *
255      * - The contract must be paused.
256      */
257     function _unpause() internal virtual whenPaused {
258         _paused = false;
259         emit Unpaused(_msgSender());
260     }
261 }
262 
263 // File: @openzeppelin/contracts/access/Ownable.sol
264 
265 
266 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
267 
268 pragma solidity ^0.8.0;
269 
270 
271 /**
272  * @dev Contract module which provides a basic access control mechanism, where
273  * there is an account (an owner) that can be granted exclusive access to
274  * specific functions.
275  *
276  * By default, the owner account will be the one that deploys the contract. This
277  * can later be changed with {transferOwnership}.
278  *
279  * This module is used through inheritance. It will make available the modifier
280  * `onlyOwner`, which can be applied to your functions to restrict their use to
281  * the owner.
282  */
283 abstract contract Ownable is Context {
284     address private _owner;
285 
286     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288     /**
289      * @dev Initializes the contract setting the deployer as the initial owner.
290      */
291     constructor() {
292         _transferOwnership(_msgSender());
293     }
294 
295     /**
296      * @dev Returns the address of the current owner.
297      */
298     function owner() public view virtual returns (address) {
299         return _owner;
300     }
301 
302     /**
303      * @dev Throws if called by any account other than the owner.
304      */
305     modifier onlyOwner() {
306         require(owner() == _msgSender(), "Ownable: caller is not the owner");
307         _;
308     }
309 
310     /**
311      * @dev Leaves the contract without owner. It will not be possible to call
312      * `onlyOwner` functions anymore. Can only be called by the current owner.
313      *
314      * NOTE: Renouncing ownership will leave the contract without an owner,
315      * thereby removing any functionality that is only available to the owner.
316      */
317     function renounceOwnership() public virtual onlyOwner {
318         _transferOwnership(address(0));
319     }
320 
321     /**
322      * @dev Transfers ownership of the contract to a new account (`newOwner`).
323      * Can only be called by the current owner.
324      */
325     function transferOwnership(address newOwner) public virtual onlyOwner {
326         require(newOwner != address(0), "Ownable: new owner is the zero address");
327         _transferOwnership(newOwner);
328     }
329 
330     /**
331      * @dev Transfers ownership of the contract to a new account (`newOwner`).
332      * Internal function without access restriction.
333      */
334     function _transferOwnership(address newOwner) internal virtual {
335         address oldOwner = _owner;
336         _owner = newOwner;
337         emit OwnershipTransferred(oldOwner, newOwner);
338     }
339 }
340 
341 // File: @openzeppelin/contracts/utils/Address.sol
342 
343 
344 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
345 
346 pragma solidity ^0.8.1;
347 
348 /**
349  * @dev Collection of functions related to the address type
350  */
351 library Address {
352     /**
353      * @dev Returns true if `account` is a contract.
354      *
355      * [IMPORTANT]
356      * ====
357      * It is unsafe to assume that an address for which this function returns
358      * false is an externally-owned account (EOA) and not a contract.
359      *
360      * Among others, `isContract` will return false for the following
361      * types of addresses:
362      *
363      *  - an externally-owned account
364      *  - a contract in construction
365      *  - an address where a contract will be created
366      *  - an address where a contract lived, but was destroyed
367      * ====
368      *
369      * [IMPORTANT]
370      * ====
371      * You shouldn't rely on `isContract` to protect against flash loan attacks!
372      *
373      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
374      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
375      * constructor.
376      * ====
377      */
378     function isContract(address account) internal view returns (bool) {
379         // This method relies on extcodesize/address.code.length, which returns 0
380         // for contracts in construction, since the code is only stored at the end
381         // of the constructor execution.
382 
383         return account.code.length > 0;
384     }
385 
386     /**
387      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
388      * `recipient`, forwarding all available gas and reverting on errors.
389      *
390      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
391      * of certain opcodes, possibly making contracts go over the 2300 gas limit
392      * imposed by `transfer`, making them unable to receive funds via
393      * `transfer`. {sendValue} removes this limitation.
394      *
395      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
396      *
397      * IMPORTANT: because control is transferred to `recipient`, care must be
398      * taken to not create reentrancy vulnerabilities. Consider using
399      * {ReentrancyGuard} or the
400      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
401      */
402     function sendValue(address payable recipient, uint256 amount) internal {
403         require(address(this).balance >= amount, "Address: insufficient balance");
404 
405         (bool success, ) = recipient.call{value: amount}("");
406         require(success, "Address: unable to send value, recipient may have reverted");
407     }
408 
409     /**
410      * @dev Performs a Solidity function call using a low level `call`. A
411      * plain `call` is an unsafe replacement for a function call: use this
412      * function instead.
413      *
414      * If `target` reverts with a revert reason, it is bubbled up by this
415      * function (like regular Solidity function calls).
416      *
417      * Returns the raw returned data. To convert to the expected return value,
418      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
419      *
420      * Requirements:
421      *
422      * - `target` must be a contract.
423      * - calling `target` with `data` must not revert.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
428         return functionCall(target, data, "Address: low-level call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
433      * `errorMessage` as a fallback revert reason when `target` reverts.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal returns (bytes memory) {
442         return functionCallWithValue(target, data, 0, errorMessage);
443     }
444 
445     /**
446      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
447      * but also transferring `value` wei to `target`.
448      *
449      * Requirements:
450      *
451      * - the calling contract must have an ETH balance of at least `value`.
452      * - the called Solidity function must be `payable`.
453      *
454      * _Available since v3.1._
455      */
456     function functionCallWithValue(
457         address target,
458         bytes memory data,
459         uint256 value
460     ) internal returns (bytes memory) {
461         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
466      * with `errorMessage` as a fallback revert reason when `target` reverts.
467      *
468      * _Available since v3.1._
469      */
470     function functionCallWithValue(
471         address target,
472         bytes memory data,
473         uint256 value,
474         string memory errorMessage
475     ) internal returns (bytes memory) {
476         require(address(this).balance >= value, "Address: insufficient balance for call");
477         require(isContract(target), "Address: call to non-contract");
478 
479         (bool success, bytes memory returndata) = target.call{value: value}(data);
480         return verifyCallResult(success, returndata, errorMessage);
481     }
482 
483     /**
484      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
485      * but performing a static call.
486      *
487      * _Available since v3.3._
488      */
489     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
490         return functionStaticCall(target, data, "Address: low-level static call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
495      * but performing a static call.
496      *
497      * _Available since v3.3._
498      */
499     function functionStaticCall(
500         address target,
501         bytes memory data,
502         string memory errorMessage
503     ) internal view returns (bytes memory) {
504         require(isContract(target), "Address: static call to non-contract");
505 
506         (bool success, bytes memory returndata) = target.staticcall(data);
507         return verifyCallResult(success, returndata, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but performing a delegate call.
513      *
514      * _Available since v3.4._
515      */
516     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
517         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
518     }
519 
520     /**
521      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
522      * but performing a delegate call.
523      *
524      * _Available since v3.4._
525      */
526     function functionDelegateCall(
527         address target,
528         bytes memory data,
529         string memory errorMessage
530     ) internal returns (bytes memory) {
531         require(isContract(target), "Address: delegate call to non-contract");
532 
533         (bool success, bytes memory returndata) = target.delegatecall(data);
534         return verifyCallResult(success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
539      * revert reason using the provided one.
540      *
541      * _Available since v4.3._
542      */
543     function verifyCallResult(
544         bool success,
545         bytes memory returndata,
546         string memory errorMessage
547     ) internal pure returns (bytes memory) {
548         if (success) {
549             return returndata;
550         } else {
551             // Look for revert reason and bubble it up if present
552             if (returndata.length > 0) {
553                 // The easiest way to bubble the revert reason is using memory via assembly
554 
555                 assembly {
556                     let returndata_size := mload(returndata)
557                     revert(add(32, returndata), returndata_size)
558                 }
559             } else {
560                 revert(errorMessage);
561             }
562         }
563     }
564 }
565 
566 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
567 
568 
569 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
570 
571 pragma solidity ^0.8.0;
572 
573 /**
574  * @title ERC721 token receiver interface
575  * @dev Interface for any contract that wants to support safeTransfers
576  * from ERC721 asset contracts.
577  */
578 interface IERC721Receiver {
579     /**
580      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
581      * by `operator` from `from`, this function is called.
582      *
583      * It must return its Solidity selector to confirm the token transfer.
584      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
585      *
586      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
587      */
588     function onERC721Received(
589         address operator,
590         address from,
591         uint256 tokenId,
592         bytes calldata data
593     ) external returns (bytes4);
594 }
595 
596 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
597 
598 
599 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 /**
604  * @dev Interface of the ERC165 standard, as defined in the
605  * https://eips.ethereum.org/EIPS/eip-165[EIP].
606  *
607  * Implementers can declare support of contract interfaces, which can then be
608  * queried by others ({ERC165Checker}).
609  *
610  * For an implementation, see {ERC165}.
611  */
612 interface IERC165 {
613     /**
614      * @dev Returns true if this contract implements the interface defined by
615      * `interfaceId`. See the corresponding
616      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
617      * to learn more about how these ids are created.
618      *
619      * This function call must use less than 30 000 gas.
620      */
621     function supportsInterface(bytes4 interfaceId) external view returns (bool);
622 }
623 
624 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
625 
626 
627 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
628 
629 pragma solidity ^0.8.0;
630 
631 
632 /**
633  * @dev Implementation of the {IERC165} interface.
634  *
635  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
636  * for the additional interface id that will be supported. For example:
637  *
638  * ```solidity
639  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
640  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
641  * }
642  * ```
643  *
644  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
645  */
646 abstract contract ERC165 is IERC165 {
647     /**
648      * @dev See {IERC165-supportsInterface}.
649      */
650     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
651         return interfaceId == type(IERC165).interfaceId;
652     }
653 }
654 
655 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
656 
657 
658 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
659 
660 pragma solidity ^0.8.0;
661 
662 
663 /**
664  * @dev Required interface of an ERC721 compliant contract.
665  */
666 interface IERC721 is IERC165 {
667     /**
668      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
669      */
670     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
671 
672     /**
673      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
674      */
675     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
676 
677     /**
678      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
679      */
680     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
681 
682     /**
683      * @dev Returns the number of tokens in ``owner``'s account.
684      */
685     function balanceOf(address owner) external view returns (uint256 balance);
686 
687     /**
688      * @dev Returns the owner of the `tokenId` token.
689      *
690      * Requirements:
691      *
692      * - `tokenId` must exist.
693      */
694     function ownerOf(uint256 tokenId) external view returns (address owner);
695 
696     /**
697      * @dev Safely transfers `tokenId` token from `from` to `to`.
698      *
699      * Requirements:
700      *
701      * - `from` cannot be the zero address.
702      * - `to` cannot be the zero address.
703      * - `tokenId` token must exist and be owned by `from`.
704      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
705      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
706      *
707      * Emits a {Transfer} event.
708      */
709     function safeTransferFrom(
710         address from,
711         address to,
712         uint256 tokenId,
713         bytes calldata data
714     ) external;
715 
716     /**
717      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
718      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
719      *
720      * Requirements:
721      *
722      * - `from` cannot be the zero address.
723      * - `to` cannot be the zero address.
724      * - `tokenId` token must exist and be owned by `from`.
725      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
726      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
727      *
728      * Emits a {Transfer} event.
729      */
730     function safeTransferFrom(
731         address from,
732         address to,
733         uint256 tokenId
734     ) external;
735 
736     /**
737      * @dev Transfers `tokenId` token from `from` to `to`.
738      *
739      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
740      *
741      * Requirements:
742      *
743      * - `from` cannot be the zero address.
744      * - `to` cannot be the zero address.
745      * - `tokenId` token must be owned by `from`.
746      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
747      *
748      * Emits a {Transfer} event.
749      */
750     function transferFrom(
751         address from,
752         address to,
753         uint256 tokenId
754     ) external;
755 
756     /**
757      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
758      * The approval is cleared when the token is transferred.
759      *
760      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
761      *
762      * Requirements:
763      *
764      * - The caller must own the token or be an approved operator.
765      * - `tokenId` must exist.
766      *
767      * Emits an {Approval} event.
768      */
769     function approve(address to, uint256 tokenId) external;
770 
771     /**
772      * @dev Approve or remove `operator` as an operator for the caller.
773      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
774      *
775      * Requirements:
776      *
777      * - The `operator` cannot be the caller.
778      *
779      * Emits an {ApprovalForAll} event.
780      */
781     function setApprovalForAll(address operator, bool _approved) external;
782 
783     /**
784      * @dev Returns the account approved for `tokenId` token.
785      *
786      * Requirements:
787      *
788      * - `tokenId` must exist.
789      */
790     function getApproved(uint256 tokenId) external view returns (address operator);
791 
792     /**
793      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
794      *
795      * See {setApprovalForAll}
796      */
797     function isApprovedForAll(address owner, address operator) external view returns (bool);
798 }
799 
800 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
801 
802 
803 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
804 
805 pragma solidity ^0.8.0;
806 
807 
808 /**
809  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
810  * @dev See https://eips.ethereum.org/EIPS/eip-721
811  */
812 interface IERC721Enumerable is IERC721 {
813     /**
814      * @dev Returns the total amount of tokens stored by the contract.
815      */
816     function totalSupply() external view returns (uint256);
817 
818     /**
819      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
820      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
821      */
822     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
823 
824     /**
825      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
826      * Use along with {totalSupply} to enumerate all tokens.
827      */
828     function tokenByIndex(uint256 index) external view returns (uint256);
829 }
830 
831 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
832 
833 
834 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
835 
836 pragma solidity ^0.8.0;
837 
838 
839 /**
840  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
841  * @dev See https://eips.ethereum.org/EIPS/eip-721
842  */
843 interface IERC721Metadata is IERC721 {
844     /**
845      * @dev Returns the token collection name.
846      */
847     function name() external view returns (string memory);
848 
849     /**
850      * @dev Returns the token collection symbol.
851      */
852     function symbol() external view returns (string memory);
853 
854     /**
855      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
856      */
857     function tokenURI(uint256 tokenId) external view returns (string memory);
858 }
859 
860 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
861 
862 
863 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
864 
865 pragma solidity ^0.8.0;
866 
867 
868 
869 
870 
871 
872 
873 
874 /**
875  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
876  * the Metadata extension, but not including the Enumerable extension, which is available separately as
877  * {ERC721Enumerable}.
878  */
879 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
880     using Address for address;
881     using Strings for uint256;
882 
883     // Token name
884     string private _name;
885 
886     // Token symbol
887     string private _symbol;
888 
889     // Mapping from token ID to owner address
890     mapping(uint256 => address) private _owners;
891 
892     // Mapping owner address to token count
893     mapping(address => uint256) private _balances;
894 
895     // Mapping from token ID to approved address
896     mapping(uint256 => address) private _tokenApprovals;
897 
898     // Mapping from owner to operator approvals
899     mapping(address => mapping(address => bool)) private _operatorApprovals;
900 
901     /**
902      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
903      */
904     constructor(string memory name_, string memory symbol_) {
905         _name = name_;
906         _symbol = symbol_;
907     }
908 
909     /**
910      * @dev See {IERC165-supportsInterface}.
911      */
912     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
913         return
914             interfaceId == type(IERC721).interfaceId ||
915             interfaceId == type(IERC721Metadata).interfaceId ||
916             super.supportsInterface(interfaceId);
917     }
918 
919     /**
920      * @dev See {IERC721-balanceOf}.
921      */
922     function balanceOf(address owner) public view virtual override returns (uint256) {
923         require(owner != address(0), "ERC721: balance query for the zero address");
924         return _balances[owner];
925     }
926 
927     /**
928      * @dev See {IERC721-ownerOf}.
929      */
930     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
931         address owner = _owners[tokenId];
932         require(owner != address(0), "ERC721: owner query for nonexistent token");
933         return owner;
934     }
935 
936     /**
937      * @dev See {IERC721Metadata-name}.
938      */
939     function name() public view virtual override returns (string memory) {
940         return _name;
941     }
942 
943     /**
944      * @dev See {IERC721Metadata-symbol}.
945      */
946     function symbol() public view virtual override returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev See {IERC721Metadata-tokenURI}.
952      */
953     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
954         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
955 
956         string memory baseURI = _baseURI();
957         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
958     }
959 
960     /**
961      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
962      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
963      * by default, can be overridden in child contracts.
964      */
965     function _baseURI() internal view virtual returns (string memory) {
966         return "";
967     }
968 
969     /**
970      * @dev See {IERC721-approve}.
971      */
972     function approve(address to, uint256 tokenId) public virtual override {
973         address owner = ERC721.ownerOf(tokenId);
974         require(to != owner, "ERC721: approval to current owner");
975 
976         require(
977             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
978             "ERC721: approve caller is not owner nor approved for all"
979         );
980 
981         _approve(to, tokenId);
982     }
983 
984     /**
985      * @dev See {IERC721-getApproved}.
986      */
987     function getApproved(uint256 tokenId) public view virtual override returns (address) {
988         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
989 
990         return _tokenApprovals[tokenId];
991     }
992 
993     /**
994      * @dev See {IERC721-setApprovalForAll}.
995      */
996     function setApprovalForAll(address operator, bool approved) public virtual override {
997         _setApprovalForAll(_msgSender(), operator, approved);
998     }
999 
1000     /**
1001      * @dev See {IERC721-isApprovedForAll}.
1002      */
1003     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1004         return _operatorApprovals[owner][operator];
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-transferFrom}.
1009      */
1010     function transferFrom(
1011         address from,
1012         address to,
1013         uint256 tokenId
1014     ) public virtual override {
1015         //solhint-disable-next-line max-line-length
1016         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1017 
1018         _transfer(from, to, tokenId);
1019     }
1020 
1021     /**
1022      * @dev See {IERC721-safeTransferFrom}.
1023      */
1024     function safeTransferFrom(
1025         address from,
1026         address to,
1027         uint256 tokenId
1028     ) public virtual override {
1029         safeTransferFrom(from, to, tokenId, "");
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-safeTransferFrom}.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes memory _data
1040     ) public virtual override {
1041         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1042         _safeTransfer(from, to, tokenId, _data);
1043     }
1044 
1045     /**
1046      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1047      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1048      *
1049      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1050      *
1051      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1052      * implement alternative mechanisms to perform token transfer, such as signature-based.
1053      *
1054      * Requirements:
1055      *
1056      * - `from` cannot be the zero address.
1057      * - `to` cannot be the zero address.
1058      * - `tokenId` token must exist and be owned by `from`.
1059      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function _safeTransfer(
1064         address from,
1065         address to,
1066         uint256 tokenId,
1067         bytes memory _data
1068     ) internal virtual {
1069         _transfer(from, to, tokenId);
1070         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1071     }
1072 
1073     /**
1074      * @dev Returns whether `tokenId` exists.
1075      *
1076      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1077      *
1078      * Tokens start existing when they are minted (`_mint`),
1079      * and stop existing when they are burned (`_burn`).
1080      */
1081     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1082         return _owners[tokenId] != address(0);
1083     }
1084 
1085     /**
1086      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1087      *
1088      * Requirements:
1089      *
1090      * - `tokenId` must exist.
1091      */
1092     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1093         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1094         address owner = ERC721.ownerOf(tokenId);
1095         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1096     }
1097 
1098     /**
1099      * @dev Safely mints `tokenId` and transfers it to `to`.
1100      *
1101      * Requirements:
1102      *
1103      * - `tokenId` must not exist.
1104      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1105      *
1106      * Emits a {Transfer} event.
1107      */
1108     function _safeMint(address to, uint256 tokenId) internal virtual {
1109         _safeMint(to, tokenId, "");
1110     }
1111 
1112     /**
1113      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1114      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1115      */
1116     function _safeMint(
1117         address to,
1118         uint256 tokenId,
1119         bytes memory _data
1120     ) internal virtual {
1121         _mint(to, tokenId);
1122         require(
1123             _checkOnERC721Received(address(0), to, tokenId, _data),
1124             "ERC721: transfer to non ERC721Receiver implementer"
1125         );
1126     }
1127 
1128     /**
1129      * @dev Mints `tokenId` and transfers it to `to`.
1130      *
1131      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1132      *
1133      * Requirements:
1134      *
1135      * - `tokenId` must not exist.
1136      * - `to` cannot be the zero address.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _mint(address to, uint256 tokenId) internal virtual {
1141         require(to != address(0), "ERC721: mint to the zero address");
1142         require(!_exists(tokenId), "ERC721: token already minted");
1143 
1144         _beforeTokenTransfer(address(0), to, tokenId);
1145 
1146         _balances[to] += 1;
1147         _owners[tokenId] = to;
1148 
1149         emit Transfer(address(0), to, tokenId);
1150 
1151         _afterTokenTransfer(address(0), to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev Destroys `tokenId`.
1156      * The approval is cleared when the token is burned.
1157      *
1158      * Requirements:
1159      *
1160      * - `tokenId` must exist.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _burn(uint256 tokenId) internal virtual {
1165         address owner = ERC721.ownerOf(tokenId);
1166 
1167         _beforeTokenTransfer(owner, address(0), tokenId);
1168 
1169         // Clear approvals
1170         _approve(address(0), tokenId);
1171 
1172         _balances[owner] -= 1;
1173         delete _owners[tokenId];
1174 
1175         emit Transfer(owner, address(0), tokenId);
1176 
1177         _afterTokenTransfer(owner, address(0), tokenId);
1178     }
1179 
1180     /**
1181      * @dev Transfers `tokenId` from `from` to `to`.
1182      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1183      *
1184      * Requirements:
1185      *
1186      * - `to` cannot be the zero address.
1187      * - `tokenId` token must be owned by `from`.
1188      *
1189      * Emits a {Transfer} event.
1190      */
1191     function _transfer(
1192         address from,
1193         address to,
1194         uint256 tokenId
1195     ) internal virtual {
1196         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1197         require(to != address(0), "ERC721: transfer to the zero address");
1198 
1199         _beforeTokenTransfer(from, to, tokenId);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId);
1203 
1204         _balances[from] -= 1;
1205         _balances[to] += 1;
1206         _owners[tokenId] = to;
1207 
1208         emit Transfer(from, to, tokenId);
1209 
1210         _afterTokenTransfer(from, to, tokenId);
1211     }
1212 
1213     /**
1214      * @dev Approve `to` to operate on `tokenId`
1215      *
1216      * Emits a {Approval} event.
1217      */
1218     function _approve(address to, uint256 tokenId) internal virtual {
1219         _tokenApprovals[tokenId] = to;
1220         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1221     }
1222 
1223     /**
1224      * @dev Approve `operator` to operate on all of `owner` tokens
1225      *
1226      * Emits a {ApprovalForAll} event.
1227      */
1228     function _setApprovalForAll(
1229         address owner,
1230         address operator,
1231         bool approved
1232     ) internal virtual {
1233         require(owner != operator, "ERC721: approve to caller");
1234         _operatorApprovals[owner][operator] = approved;
1235         emit ApprovalForAll(owner, operator, approved);
1236     }
1237 
1238     /**
1239      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1240      * The call is not executed if the target address is not a contract.
1241      *
1242      * @param from address representing the previous owner of the given token ID
1243      * @param to target address that will receive the tokens
1244      * @param tokenId uint256 ID of the token to be transferred
1245      * @param _data bytes optional data to send along with the call
1246      * @return bool whether the call correctly returned the expected magic value
1247      */
1248     function _checkOnERC721Received(
1249         address from,
1250         address to,
1251         uint256 tokenId,
1252         bytes memory _data
1253     ) private returns (bool) {
1254         if (to.isContract()) {
1255             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1256                 return retval == IERC721Receiver.onERC721Received.selector;
1257             } catch (bytes memory reason) {
1258                 if (reason.length == 0) {
1259                     revert("ERC721: transfer to non ERC721Receiver implementer");
1260                 } else {
1261                     assembly {
1262                         revert(add(32, reason), mload(reason))
1263                     }
1264                 }
1265             }
1266         } else {
1267             return true;
1268         }
1269     }
1270 
1271     /**
1272      * @dev Hook that is called before any token transfer. This includes minting
1273      * and burning.
1274      *
1275      * Calling conditions:
1276      *
1277      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1278      * transferred to `to`.
1279      * - When `from` is zero, `tokenId` will be minted for `to`.
1280      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1281      * - `from` and `to` are never both zero.
1282      *
1283      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1284      */
1285     function _beforeTokenTransfer(
1286         address from,
1287         address to,
1288         uint256 tokenId
1289     ) internal virtual {}
1290 
1291     /**
1292      * @dev Hook that is called after any transfer of tokens. This includes
1293      * minting and burning.
1294      *
1295      * Calling conditions:
1296      *
1297      * - when `from` and `to` are both non-zero.
1298      * - `from` and `to` are never both zero.
1299      *
1300      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1301      */
1302     function _afterTokenTransfer(
1303         address from,
1304         address to,
1305         uint256 tokenId
1306     ) internal virtual {}
1307 }
1308 
1309 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1310 
1311 
1312 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1313 
1314 pragma solidity ^0.8.0;
1315 
1316 
1317 
1318 /**
1319  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1320  * enumerability of all the token ids in the contract as well as all token ids owned by each
1321  * account.
1322  */
1323 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1324     // Mapping from owner to list of owned token IDs
1325     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1326 
1327     // Mapping from token ID to index of the owner tokens list
1328     mapping(uint256 => uint256) private _ownedTokensIndex;
1329 
1330     // Array with all token ids, used for enumeration
1331     uint256[] private _allTokens;
1332 
1333     // Mapping from token id to position in the allTokens array
1334     mapping(uint256 => uint256) private _allTokensIndex;
1335 
1336     /**
1337      * @dev See {IERC165-supportsInterface}.
1338      */
1339     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1340         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1341     }
1342 
1343     /**
1344      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1345      */
1346     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1347         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1348         return _ownedTokens[owner][index];
1349     }
1350 
1351     /**
1352      * @dev See {IERC721Enumerable-totalSupply}.
1353      */
1354     function totalSupply() public view virtual override returns (uint256) {
1355         return _allTokens.length;
1356     }
1357 
1358     /**
1359      * @dev See {IERC721Enumerable-tokenByIndex}.
1360      */
1361     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1362         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1363         return _allTokens[index];
1364     }
1365 
1366     /**
1367      * @dev Hook that is called before any token transfer. This includes minting
1368      * and burning.
1369      *
1370      * Calling conditions:
1371      *
1372      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1373      * transferred to `to`.
1374      * - When `from` is zero, `tokenId` will be minted for `to`.
1375      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1376      * - `from` cannot be the zero address.
1377      * - `to` cannot be the zero address.
1378      *
1379      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1380      */
1381     function _beforeTokenTransfer(
1382         address from,
1383         address to,
1384         uint256 tokenId
1385     ) internal virtual override {
1386         super._beforeTokenTransfer(from, to, tokenId);
1387 
1388         if (from == address(0)) {
1389             _addTokenToAllTokensEnumeration(tokenId);
1390         } else if (from != to) {
1391             _removeTokenFromOwnerEnumeration(from, tokenId);
1392         }
1393         if (to == address(0)) {
1394             _removeTokenFromAllTokensEnumeration(tokenId);
1395         } else if (to != from) {
1396             _addTokenToOwnerEnumeration(to, tokenId);
1397         }
1398     }
1399 
1400     /**
1401      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1402      * @param to address representing the new owner of the given token ID
1403      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1404      */
1405     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1406         uint256 length = ERC721.balanceOf(to);
1407         _ownedTokens[to][length] = tokenId;
1408         _ownedTokensIndex[tokenId] = length;
1409     }
1410 
1411     /**
1412      * @dev Private function to add a token to this extension's token tracking data structures.
1413      * @param tokenId uint256 ID of the token to be added to the tokens list
1414      */
1415     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1416         _allTokensIndex[tokenId] = _allTokens.length;
1417         _allTokens.push(tokenId);
1418     }
1419 
1420     /**
1421      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1422      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1423      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1424      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1425      * @param from address representing the previous owner of the given token ID
1426      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1427      */
1428     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1429         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1430         // then delete the last slot (swap and pop).
1431 
1432         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1433         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1434 
1435         // When the token to delete is the last token, the swap operation is unnecessary
1436         if (tokenIndex != lastTokenIndex) {
1437             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1438 
1439             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1440             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1441         }
1442 
1443         // This also deletes the contents at the last position of the array
1444         delete _ownedTokensIndex[tokenId];
1445         delete _ownedTokens[from][lastTokenIndex];
1446     }
1447 
1448     /**
1449      * @dev Private function to remove a token from this extension's token tracking data structures.
1450      * This has O(1) time complexity, but alters the order of the _allTokens array.
1451      * @param tokenId uint256 ID of the token to be removed from the tokens list
1452      */
1453     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1454         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1455         // then delete the last slot (swap and pop).
1456 
1457         uint256 lastTokenIndex = _allTokens.length - 1;
1458         uint256 tokenIndex = _allTokensIndex[tokenId];
1459 
1460         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1461         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1462         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1463         uint256 lastTokenId = _allTokens[lastTokenIndex];
1464 
1465         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1466         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1467 
1468         // This also deletes the contents at the last position of the array
1469         delete _allTokensIndex[tokenId];
1470         _allTokens.pop();
1471     }
1472 }
1473 
1474 // File: contracts/SuperCreatorsGenZ.sol
1475 
1476 
1477 
1478 pragma solidity >=0.7.0 <0.9.0;
1479 
1480 
1481 
1482 
1483 
1484 
1485 contract SuperCreatorsGenZ is ERC721Enumerable, Ownable,Pausable {
1486     using Strings for uint256;
1487        
1488     string public baseURI;
1489     string public notRevealedUri;
1490     string public baseExtension = ".json";
1491     uint256 public Price = 0.01 ether;
1492     
1493     uint256 public maxGenCount = 5500; 
1494     uint256 public maxSuperBabiesCount = 55; 
1495 
1496     uint256 public maxMintTokens = 5;
1497 
1498     bytes32 public merkleRoot;
1499     bytes32 public merkleRootSuperBabies;
1500     
1501     uint256 private superBabiesMinted = 0;
1502     uint256 public requireTokenForSuperBabies=5;
1503 
1504     bool public revealed = false;
1505     bool public publicSale =  false;
1506     bool public superBabiesSale = false;
1507            
1508     event mintLog(uint256 scid,address minter,uint256 _type);
1509     event superBabiesLog(uint256[] usedTokens, uint256 SBid,address minter);
1510     
1511     
1512   constructor() ERC721("Super Creators - Gen Z", "SCGENZ") {
1513     setNotRevealedURI("ipfs://QmQZnvLSJbm54kE89C4zxdc35uVdJGMHb8jioNEpQznwJ3");
1514     setBaseURI("ipfs://");
1515     
1516   }
1517 
1518     // internal
1519   function _baseURI() internal view virtual override returns (string memory) {
1520     return baseURI;
1521   }
1522 
1523   // public functions
1524   function mint(uint256 _noOfTokens,bytes32[] calldata _merkleProof) public whenNotPaused payable {
1525     uint256 supply = totalSupply();
1526     require(_noOfTokens > 0);
1527     require(supply + _noOfTokens <= maxGenCount);
1528     
1529 
1530       if (msg.sender != owner()) {
1531         require(_noOfTokens <= maxMintTokens);
1532         require(maxMintTokens >= balanceOf(msg.sender) +_noOfTokens ,"Not eligible to mint this allocation." ); 
1533         require(publicSale,"Public sale has not started yet.");
1534         require(msg.value >= Price * _noOfTokens ,"Not enough ethers to mint NFTs.");
1535         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1536         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf),"ADDRESS_NOT_ELIGIBLE_FOR_ALLOW_LIST");
1537       }
1538 
1539       for (uint256 i = 1; i <= _noOfTokens; i++) {
1540         _safeMint(msg.sender, supply+i);
1541         emit mintLog (supply+i, msg.sender,0);
1542       
1543     }
1544    
1545   }
1546    
1547    function superBabiesMint(uint256[] memory babiesTokens,bytes32[] calldata _merkleProof)public whenNotPaused{
1548     uint256 SuperBabiesId = maxGenCount + superBabiesMinted;
1549     require(maxMintTokens >= balanceOf(msg.sender)+1 ,"Not eligible to mint this allocation." );
1550     require(superBabiesSale,"Super Babies sale not started");
1551     require(superBabiesMinted<=maxSuperBabiesCount,"All super babies minted");
1552     require(requireTokenForSuperBabies <= babiesTokens.length,"Require token less for mint super babies");
1553     bytes32 leafSB = keccak256(abi.encodePacked(msg.sender));
1554     require(MerkleProof.verify(_merkleProof, merkleRootSuperBabies, leafSB),"ADDRESS_NOT_ELIGIBLE_FOR_ALLOW_LIST");
1555 
1556     for (uint256 i = 0; i < babiesTokens.length; i++) {
1557       require(ownerOf(babiesTokens[i]) == msg.sender, "Cannot interact with a SuperCreators you do not own.");
1558     }
1559     _safeMint(msg.sender, SuperBabiesId+1);
1560      superBabiesMinted = superBabiesMinted+1;
1561     emit superBabiesLog(babiesTokens,SuperBabiesId,msg.sender);
1562    }
1563   
1564   function walletOfOwner(address _owner)
1565     public
1566     view
1567     returns (uint256[] memory)
1568   {
1569     uint256 ownerTokenCount = balanceOf(_owner);
1570     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1571     for (uint256 i; i < ownerTokenCount; i++) {
1572       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1573     }
1574     return tokenIds;
1575   }
1576 
1577   
1578   function tokenURI(uint256 tokenId)
1579     public
1580     view
1581     virtual
1582     override
1583     returns (string memory)
1584   {
1585     require(
1586       _exists(tokenId),
1587       "ERC721Metadata: URI query for nonexistent token"
1588     );
1589     
1590     if(revealed == false) {
1591         return notRevealedUri;
1592     }
1593 
1594     string memory currentBaseURI = _baseURI();
1595     return bytes(currentBaseURI).length > 0
1596         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1597         : "";
1598   }
1599 
1600   //only owner functions
1601   
1602   function pause() public onlyOwner {
1603         _pause();
1604     }
1605 
1606   function unpause() public onlyOwner {
1607       _unpause();
1608     }
1609 
1610   function reveal(bool _state) public onlyOwner {
1611       revealed = _state;
1612   }
1613   
1614   function publicSaleStarted(bool _state) public onlyOwner{
1615     publicSale = _state;
1616   }
1617 
1618   function setSuperBabiesSale(bool _state) public onlyOwner{
1619     superBabiesSale  = _state;
1620   }
1621 
1622   function setPrice(uint256 _newPrice) public onlyOwner {
1623     Price = _newPrice;
1624   }
1625 
1626   function setMaxMintPerWallet(uint256 _newmaxMintTokens) public onlyOwner {
1627     maxMintTokens = _newmaxMintTokens;
1628   } 
1629 
1630   function setSuperBabySupplyLimit(uint256 _newLimit) public onlyOwner {
1631     maxSuperBabiesCount = _newLimit;
1632   } 
1633 
1634   function setNumTokensRquiredForSuperBabyMint(uint256 _newNumTokens) public onlyOwner {
1635     requireTokenForSuperBabies = _newNumTokens;
1636   } 
1637   
1638   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1639     notRevealedUri = _notRevealedURI;
1640   }
1641 
1642   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1643     baseURI = _newBaseURI;
1644   }
1645 
1646     function setBabySupplyLimit(uint256 _newLimit) public onlyOwner() {
1647         maxGenCount = _newLimit;
1648     }
1649 
1650 
1651   function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1652         merkleRoot = _merkleRoot;
1653   }
1654   function setMerkleRootSuperBabies(bytes32 _merkleRoot) external onlyOwner {
1655         merkleRootSuperBabies = _merkleRoot;
1656   }
1657   
1658  function withdraw() public payable onlyOwner {
1659 	     uint balance = address(this).balance;
1660 	     require(balance > 0, "Not enough Ether to withdraw!");
1661 	     (bool success, ) = (msg.sender).call{value: balance}("");
1662 	     require(success, "Transaction failed.");
1663 	}
1664 }