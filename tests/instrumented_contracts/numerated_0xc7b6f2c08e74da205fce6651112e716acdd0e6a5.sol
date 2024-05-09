1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
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
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/Strings.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev String operations.
65  */
66 library Strings {
67     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
68 
69     /**
70      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
71      */
72     function toString(uint256 value) internal pure returns (string memory) {
73         // Inspired by OraclizeAPI's implementation - MIT licence
74         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
75 
76         if (value == 0) {
77             return "0";
78         }
79         uint256 temp = value;
80         uint256 digits;
81         while (temp != 0) {
82             digits++;
83             temp /= 10;
84         }
85         bytes memory buffer = new bytes(digits);
86         while (value != 0) {
87             digits -= 1;
88             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
89             value /= 10;
90         }
91         return string(buffer);
92     }
93 
94     /**
95      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
96      */
97     function toHexString(uint256 value) internal pure returns (string memory) {
98         if (value == 0) {
99             return "0x00";
100         }
101         uint256 temp = value;
102         uint256 length = 0;
103         while (temp != 0) {
104             length++;
105             temp >>= 8;
106         }
107         return toHexString(value, length);
108     }
109 
110     /**
111      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
112      */
113     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
114         bytes memory buffer = new bytes(2 * length + 2);
115         buffer[0] = "0";
116         buffer[1] = "x";
117         for (uint256 i = 2 * length + 1; i > 1; --i) {
118             buffer[i] = _HEX_SYMBOLS[value & 0xf];
119             value >>= 4;
120         }
121         require(value == 0, "Strings: hex length insufficient");
122         return string(buffer);
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Context.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/security/Pausable.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 /**
162  * @dev Contract module which allows children to implement an emergency stop
163  * mechanism that can be triggered by an authorized account.
164  *
165  * This module is used through inheritance. It will make available the
166  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
167  * the functions of your contract. Note that they will not be pausable by
168  * simply including this module, only once the modifiers are put in place.
169  */
170 abstract contract Pausable is Context {
171     /**
172      * @dev Emitted when the pause is triggered by `account`.
173      */
174     event Paused(address account);
175 
176     /**
177      * @dev Emitted when the pause is lifted by `account`.
178      */
179     event Unpaused(address account);
180 
181     bool private _paused;
182 
183     /**
184      * @dev Initializes the contract in unpaused state.
185      */
186     constructor() {
187         _paused = false;
188     }
189 
190     /**
191      * @dev Returns true if the contract is paused, and false otherwise.
192      */
193     function paused() public view virtual returns (bool) {
194         return _paused;
195     }
196 
197     /**
198      * @dev Modifier to make a function callable only when the contract is not paused.
199      *
200      * Requirements:
201      *
202      * - The contract must not be paused.
203      */
204     modifier whenNotPaused() {
205         require(!paused(), "Pausable: paused");
206         _;
207     }
208 
209     /**
210      * @dev Modifier to make a function callable only when the contract is paused.
211      *
212      * Requirements:
213      *
214      * - The contract must be paused.
215      */
216     modifier whenPaused() {
217         require(paused(), "Pausable: not paused");
218         _;
219     }
220 
221     /**
222      * @dev Triggers stopped state.
223      *
224      * Requirements:
225      *
226      * - The contract must not be paused.
227      */
228     function _pause() internal virtual whenNotPaused {
229         _paused = true;
230         emit Paused(_msgSender());
231     }
232 
233     /**
234      * @dev Returns to normal state.
235      *
236      * Requirements:
237      *
238      * - The contract must be paused.
239      */
240     function _unpause() internal virtual whenPaused {
241         _paused = false;
242         emit Unpaused(_msgSender());
243     }
244 }
245 
246 // File: @openzeppelin/contracts/access/Ownable.sol
247 
248 
249 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
250 
251 pragma solidity ^0.8.0;
252 
253 
254 /**
255  * @dev Contract module which provides a basic access control mechanism, where
256  * there is an account (an owner) that can be granted exclusive access to
257  * specific functions.
258  *
259  * By default, the owner account will be the one that deploys the contract. This
260  * can later be changed with {transferOwnership}.
261  *
262  * This module is used through inheritance. It will make available the modifier
263  * `onlyOwner`, which can be applied to your functions to restrict their use to
264  * the owner.
265  */
266 abstract contract Ownable is Context {
267     address private _owner;
268 
269     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
270 
271     /**
272      * @dev Initializes the contract setting the deployer as the initial owner.
273      */
274     constructor() {
275         _transferOwnership(_msgSender());
276     }
277 
278     /**
279      * @dev Returns the address of the current owner.
280      */
281     function owner() public view virtual returns (address) {
282         return _owner;
283     }
284 
285     /**
286      * @dev Throws if called by any account other than the owner.
287      */
288     modifier onlyOwner() {
289         require(owner() == _msgSender(), "Ownable: caller is not the owner");
290         _;
291     }
292 
293     /**
294      * @dev Leaves the contract without owner. It will not be possible to call
295      * `onlyOwner` functions anymore. Can only be called by the current owner.
296      *
297      * NOTE: Renouncing ownership will leave the contract without an owner,
298      * thereby removing any functionality that is only available to the owner.
299      */
300     function renounceOwnership() public virtual onlyOwner {
301         _transferOwnership(address(0));
302     }
303 
304     /**
305      * @dev Transfers ownership of the contract to a new account (`newOwner`).
306      * Can only be called by the current owner.
307      */
308     function transferOwnership(address newOwner) public virtual onlyOwner {
309         require(newOwner != address(0), "Ownable: new owner is the zero address");
310         _transferOwnership(newOwner);
311     }
312 
313     /**
314      * @dev Transfers ownership of the contract to a new account (`newOwner`).
315      * Internal function without access restriction.
316      */
317     function _transferOwnership(address newOwner) internal virtual {
318         address oldOwner = _owner;
319         _owner = newOwner;
320         emit OwnershipTransferred(oldOwner, newOwner);
321     }
322 }
323 
324 // File: @openzeppelin/contracts/utils/Address.sol
325 
326 
327 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
328 
329 pragma solidity ^0.8.0;
330 
331 /**
332  * @dev Collection of functions related to the address type
333  */
334 library Address {
335     /**
336      * @dev Returns true if `account` is a contract.
337      *
338      * [IMPORTANT]
339      * ====
340      * It is unsafe to assume that an address for which this function returns
341      * false is an externally-owned account (EOA) and not a contract.
342      *
343      * Among others, `isContract` will return false for the following
344      * types of addresses:
345      *
346      *  - an externally-owned account
347      *  - a contract in construction
348      *  - an address where a contract will be created
349      *  - an address where a contract lived, but was destroyed
350      * ====
351      */
352     function isContract(address account) internal view returns (bool) {
353         // This method relies on extcodesize, which returns 0 for contracts in
354         // construction, since the code is only stored at the end of the
355         // constructor execution.
356 
357         uint256 size;
358         assembly {
359             size := extcodesize(account)
360         }
361         return size > 0;
362     }
363 
364     /**
365      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
366      * `recipient`, forwarding all available gas and reverting on errors.
367      *
368      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
369      * of certain opcodes, possibly making contracts go over the 2300 gas limit
370      * imposed by `transfer`, making them unable to receive funds via
371      * `transfer`. {sendValue} removes this limitation.
372      *
373      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
374      *
375      * IMPORTANT: because control is transferred to `recipient`, care must be
376      * taken to not create reentrancy vulnerabilities. Consider using
377      * {ReentrancyGuard} or the
378      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
379      */
380     function sendValue(address payable recipient, uint256 amount) internal {
381         require(address(this).balance >= amount, "Address: insufficient balance");
382 
383         (bool success, ) = recipient.call{value: amount}("");
384         require(success, "Address: unable to send value, recipient may have reverted");
385     }
386 
387     /**
388      * @dev Performs a Solidity function call using a low level `call`. A
389      * plain `call` is an unsafe replacement for a function call: use this
390      * function instead.
391      *
392      * If `target` reverts with a revert reason, it is bubbled up by this
393      * function (like regular Solidity function calls).
394      *
395      * Returns the raw returned data. To convert to the expected return value,
396      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
397      *
398      * Requirements:
399      *
400      * - `target` must be a contract.
401      * - calling `target` with `data` must not revert.
402      *
403      * _Available since v3.1._
404      */
405     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
406         return functionCall(target, data, "Address: low-level call failed");
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
411      * `errorMessage` as a fallback revert reason when `target` reverts.
412      *
413      * _Available since v3.1._
414      */
415     function functionCall(
416         address target,
417         bytes memory data,
418         string memory errorMessage
419     ) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, 0, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but also transferring `value` wei to `target`.
426      *
427      * Requirements:
428      *
429      * - the calling contract must have an ETH balance of at least `value`.
430      * - the called Solidity function must be `payable`.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(
435         address target,
436         bytes memory data,
437         uint256 value
438     ) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(
449         address target,
450         bytes memory data,
451         uint256 value,
452         string memory errorMessage
453     ) internal returns (bytes memory) {
454         require(address(this).balance >= value, "Address: insufficient balance for call");
455         require(isContract(target), "Address: call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.call{value: value}(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a static call.
464      *
465      * _Available since v3.3._
466      */
467     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
468         return functionStaticCall(target, data, "Address: low-level static call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a static call.
474      *
475      * _Available since v3.3._
476      */
477     function functionStaticCall(
478         address target,
479         bytes memory data,
480         string memory errorMessage
481     ) internal view returns (bytes memory) {
482         require(isContract(target), "Address: static call to non-contract");
483 
484         (bool success, bytes memory returndata) = target.staticcall(data);
485         return verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     /**
489      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
490      * but performing a delegate call.
491      *
492      * _Available since v3.4._
493      */
494     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
495         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
496     }
497 
498     /**
499      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
500      * but performing a delegate call.
501      *
502      * _Available since v3.4._
503      */
504     function functionDelegateCall(
505         address target,
506         bytes memory data,
507         string memory errorMessage
508     ) internal returns (bytes memory) {
509         require(isContract(target), "Address: delegate call to non-contract");
510 
511         (bool success, bytes memory returndata) = target.delegatecall(data);
512         return verifyCallResult(success, returndata, errorMessage);
513     }
514 
515     /**
516      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
517      * revert reason using the provided one.
518      *
519      * _Available since v4.3._
520      */
521     function verifyCallResult(
522         bool success,
523         bytes memory returndata,
524         string memory errorMessage
525     ) internal pure returns (bytes memory) {
526         if (success) {
527             return returndata;
528         } else {
529             // Look for revert reason and bubble it up if present
530             if (returndata.length > 0) {
531                 // The easiest way to bubble the revert reason is using memory via assembly
532 
533                 assembly {
534                     let returndata_size := mload(returndata)
535                     revert(add(32, returndata), returndata_size)
536                 }
537             } else {
538                 revert(errorMessage);
539             }
540         }
541     }
542 }
543 
544 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @title ERC721 token receiver interface
553  * @dev Interface for any contract that wants to support safeTransfers
554  * from ERC721 asset contracts.
555  */
556 interface IERC721Receiver {
557     /**
558      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
559      * by `operator` from `from`, this function is called.
560      *
561      * It must return its Solidity selector to confirm the token transfer.
562      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
563      *
564      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
565      */
566     function onERC721Received(
567         address operator,
568         address from,
569         uint256 tokenId,
570         bytes calldata data
571     ) external returns (bytes4);
572 }
573 
574 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 /**
582  * @dev Interface of the ERC165 standard, as defined in the
583  * https://eips.ethereum.org/EIPS/eip-165[EIP].
584  *
585  * Implementers can declare support of contract interfaces, which can then be
586  * queried by others ({ERC165Checker}).
587  *
588  * For an implementation, see {ERC165}.
589  */
590 interface IERC165 {
591     /**
592      * @dev Returns true if this contract implements the interface defined by
593      * `interfaceId`. See the corresponding
594      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
595      * to learn more about how these ids are created.
596      *
597      * This function call must use less than 30 000 gas.
598      */
599     function supportsInterface(bytes4 interfaceId) external view returns (bool);
600 }
601 
602 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
603 
604 
605 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
606 
607 pragma solidity ^0.8.0;
608 
609 
610 /**
611  * @dev Implementation of the {IERC165} interface.
612  *
613  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
614  * for the additional interface id that will be supported. For example:
615  *
616  * ```solidity
617  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
618  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
619  * }
620  * ```
621  *
622  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
623  */
624 abstract contract ERC165 is IERC165 {
625     /**
626      * @dev See {IERC165-supportsInterface}.
627      */
628     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
629         return interfaceId == type(IERC165).interfaceId;
630     }
631 }
632 
633 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
634 
635 
636 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 
641 /**
642  * @dev Required interface of an ERC721 compliant contract.
643  */
644 interface IERC721 is IERC165 {
645     /**
646      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
647      */
648     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
649 
650     /**
651      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
652      */
653     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
654 
655     /**
656      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
657      */
658     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
659 
660     /**
661      * @dev Returns the number of tokens in ``owner``'s account.
662      */
663     function balanceOf(address owner) external view returns (uint256 balance);
664 
665     /**
666      * @dev Returns the owner of the `tokenId` token.
667      *
668      * Requirements:
669      *
670      * - `tokenId` must exist.
671      */
672     function ownerOf(uint256 tokenId) external view returns (address owner);
673 
674     /**
675      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
676      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
677      *
678      * Requirements:
679      *
680      * - `from` cannot be the zero address.
681      * - `to` cannot be the zero address.
682      * - `tokenId` token must exist and be owned by `from`.
683      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
684      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
685      *
686      * Emits a {Transfer} event.
687      */
688     function safeTransferFrom(
689         address from,
690         address to,
691         uint256 tokenId
692     ) external;
693 
694     /**
695      * @dev Transfers `tokenId` token from `from` to `to`.
696      *
697      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
698      *
699      * Requirements:
700      *
701      * - `from` cannot be the zero address.
702      * - `to` cannot be the zero address.
703      * - `tokenId` token must be owned by `from`.
704      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
705      *
706      * Emits a {Transfer} event.
707      */
708     function transferFrom(
709         address from,
710         address to,
711         uint256 tokenId
712     ) external;
713 
714     /**
715      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
716      * The approval is cleared when the token is transferred.
717      *
718      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
719      *
720      * Requirements:
721      *
722      * - The caller must own the token or be an approved operator.
723      * - `tokenId` must exist.
724      *
725      * Emits an {Approval} event.
726      */
727     function approve(address to, uint256 tokenId) external;
728 
729     /**
730      * @dev Returns the account approved for `tokenId` token.
731      *
732      * Requirements:
733      *
734      * - `tokenId` must exist.
735      */
736     function getApproved(uint256 tokenId) external view returns (address operator);
737 
738     /**
739      * @dev Approve or remove `operator` as an operator for the caller.
740      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
741      *
742      * Requirements:
743      *
744      * - The `operator` cannot be the caller.
745      *
746      * Emits an {ApprovalForAll} event.
747      */
748     function setApprovalForAll(address operator, bool _approved) external;
749 
750     /**
751      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
752      *
753      * See {setApprovalForAll}
754      */
755     function isApprovedForAll(address owner, address operator) external view returns (bool);
756 
757     /**
758      * @dev Safely transfers `tokenId` token from `from` to `to`.
759      *
760      * Requirements:
761      *
762      * - `from` cannot be the zero address.
763      * - `to` cannot be the zero address.
764      * - `tokenId` token must exist and be owned by `from`.
765      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
766      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
767      *
768      * Emits a {Transfer} event.
769      */
770     function safeTransferFrom(
771         address from,
772         address to,
773         uint256 tokenId,
774         bytes calldata data
775     ) external;
776 }
777 
778 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
779 
780 
781 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 
786 /**
787  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
788  * @dev See https://eips.ethereum.org/EIPS/eip-721
789  */
790 interface IERC721Metadata is IERC721 {
791     /**
792      * @dev Returns the token collection name.
793      */
794     function name() external view returns (string memory);
795 
796     /**
797      * @dev Returns the token collection symbol.
798      */
799     function symbol() external view returns (string memory);
800 
801     /**
802      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
803      */
804     function tokenURI(uint256 tokenId) external view returns (string memory);
805 }
806 
807 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
808 
809 
810 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
811 
812 pragma solidity ^0.8.0;
813 
814 
815 
816 
817 
818 
819 
820 
821 /**
822  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
823  * the Metadata extension, but not including the Enumerable extension, which is available separately as
824  * {ERC721Enumerable}.
825  */
826 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
827     using Address for address;
828     using Strings for uint256;
829 
830     // Token name
831     string private _name;
832 
833     // Token symbol
834     string private _symbol;
835 
836     // Mapping from token ID to owner address
837     mapping(uint256 => address) private _owners;
838 
839     // Mapping owner address to token count
840     mapping(address => uint256) private _balances;
841 
842     // Mapping from token ID to approved address
843     mapping(uint256 => address) private _tokenApprovals;
844 
845     // Mapping from owner to operator approvals
846     mapping(address => mapping(address => bool)) private _operatorApprovals;
847 
848     /**
849      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
850      */
851     constructor(string memory name_, string memory symbol_) {
852         _name = name_;
853         _symbol = symbol_;
854     }
855 
856     /**
857      * @dev See {IERC165-supportsInterface}.
858      */
859     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
860         return
861             interfaceId == type(IERC721).interfaceId ||
862             interfaceId == type(IERC721Metadata).interfaceId ||
863             super.supportsInterface(interfaceId);
864     }
865 
866     /**
867      * @dev See {IERC721-balanceOf}.
868      */
869     function balanceOf(address owner) public view virtual override returns (uint256) {
870         require(owner != address(0), "ERC721: balance query for the zero address");
871         return _balances[owner];
872     }
873 
874     /**
875      * @dev See {IERC721-ownerOf}.
876      */
877     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
878         address owner = _owners[tokenId];
879         require(owner != address(0), "ERC721: owner query for nonexistent token");
880         return owner;
881     }
882 
883     /**
884      * @dev See {IERC721Metadata-name}.
885      */
886     function name() public view virtual override returns (string memory) {
887         return _name;
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-symbol}.
892      */
893     function symbol() public view virtual override returns (string memory) {
894         return _symbol;
895     }
896 
897     /**
898      * @dev See {IERC721Metadata-tokenURI}.
899      */
900     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
901         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
902 
903         string memory baseURI = _baseURI();
904         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
905     }
906 
907     /**
908      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
909      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
910      * by default, can be overriden in child contracts.
911      */
912     function _baseURI() internal view virtual returns (string memory) {
913         return "";
914     }
915 
916     /**
917      * @dev See {IERC721-approve}.
918      */
919     function approve(address to, uint256 tokenId) public virtual override {
920         address owner = ERC721.ownerOf(tokenId);
921         require(to != owner, "ERC721: approval to current owner");
922 
923         require(
924             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
925             "ERC721: approve caller is not owner nor approved for all"
926         );
927 
928         _approve(to, tokenId);
929     }
930 
931     /**
932      * @dev See {IERC721-getApproved}.
933      */
934     function getApproved(uint256 tokenId) public view virtual override returns (address) {
935         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
936 
937         return _tokenApprovals[tokenId];
938     }
939 
940     /**
941      * @dev See {IERC721-setApprovalForAll}.
942      */
943     function setApprovalForAll(address operator, bool approved) public virtual override {
944         _setApprovalForAll(_msgSender(), operator, approved);
945     }
946 
947     /**
948      * @dev See {IERC721-isApprovedForAll}.
949      */
950     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
951         return _operatorApprovals[owner][operator];
952     }
953 
954     /**
955      * @dev See {IERC721-transferFrom}.
956      */
957     function transferFrom(
958         address from,
959         address to,
960         uint256 tokenId
961     ) public virtual override {
962         //solhint-disable-next-line max-line-length
963         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
964 
965         _transfer(from, to, tokenId);
966     }
967 
968     /**
969      * @dev See {IERC721-safeTransferFrom}.
970      */
971     function safeTransferFrom(
972         address from,
973         address to,
974         uint256 tokenId
975     ) public virtual override {
976         safeTransferFrom(from, to, tokenId, "");
977     }
978 
979     /**
980      * @dev See {IERC721-safeTransferFrom}.
981      */
982     function safeTransferFrom(
983         address from,
984         address to,
985         uint256 tokenId,
986         bytes memory _data
987     ) public virtual override {
988         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
989         _safeTransfer(from, to, tokenId, _data);
990     }
991 
992     /**
993      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
994      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
995      *
996      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
997      *
998      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
999      * implement alternative mechanisms to perform token transfer, such as signature-based.
1000      *
1001      * Requirements:
1002      *
1003      * - `from` cannot be the zero address.
1004      * - `to` cannot be the zero address.
1005      * - `tokenId` token must exist and be owned by `from`.
1006      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1007      *
1008      * Emits a {Transfer} event.
1009      */
1010     function _safeTransfer(
1011         address from,
1012         address to,
1013         uint256 tokenId,
1014         bytes memory _data
1015     ) internal virtual {
1016         _transfer(from, to, tokenId);
1017         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1018     }
1019 
1020     /**
1021      * @dev Returns whether `tokenId` exists.
1022      *
1023      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1024      *
1025      * Tokens start existing when they are minted (`_mint`),
1026      * and stop existing when they are burned (`_burn`).
1027      */
1028     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1029         return _owners[tokenId] != address(0);
1030     }
1031 
1032     /**
1033      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1034      *
1035      * Requirements:
1036      *
1037      * - `tokenId` must exist.
1038      */
1039     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1040         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1041         address owner = ERC721.ownerOf(tokenId);
1042         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1043     }
1044 
1045     /**
1046      * @dev Safely mints `tokenId` and transfers it to `to`.
1047      *
1048      * Requirements:
1049      *
1050      * - `tokenId` must not exist.
1051      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1052      *
1053      * Emits a {Transfer} event.
1054      */
1055     function _safeMint(address to, uint256 tokenId) internal virtual {
1056         _safeMint(to, tokenId, "");
1057     }
1058 
1059     /**
1060      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1061      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1062      */
1063     function _safeMint(
1064         address to,
1065         uint256 tokenId,
1066         bytes memory _data
1067     ) internal virtual {
1068         _mint(to, tokenId);
1069         require(
1070             _checkOnERC721Received(address(0), to, tokenId, _data),
1071             "ERC721: transfer to non ERC721Receiver implementer"
1072         );
1073     }
1074 
1075     /**
1076      * @dev Mints `tokenId` and transfers it to `to`.
1077      *
1078      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1079      *
1080      * Requirements:
1081      *
1082      * - `tokenId` must not exist.
1083      * - `to` cannot be the zero address.
1084      *
1085      * Emits a {Transfer} event.
1086      */
1087     function _mint(address to, uint256 tokenId) internal virtual {
1088         require(to != address(0), "ERC721: mint to the zero address");
1089         require(!_exists(tokenId), "ERC721: token already minted");
1090 
1091         _beforeTokenTransfer(address(0), to, tokenId);
1092 
1093         _balances[to] += 1;
1094         _owners[tokenId] = to;
1095 
1096         emit Transfer(address(0), to, tokenId);
1097     }
1098 
1099     /**
1100      * @dev Destroys `tokenId`.
1101      * The approval is cleared when the token is burned.
1102      *
1103      * Requirements:
1104      *
1105      * - `tokenId` must exist.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _burn(uint256 tokenId) internal virtual {
1110         address owner = ERC721.ownerOf(tokenId);
1111 
1112         _beforeTokenTransfer(owner, address(0), tokenId);
1113 
1114         // Clear approvals
1115         _approve(address(0), tokenId);
1116 
1117         _balances[owner] -= 1;
1118         delete _owners[tokenId];
1119 
1120         emit Transfer(owner, address(0), tokenId);
1121     }
1122 
1123     /**
1124      * @dev Transfers `tokenId` from `from` to `to`.
1125      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1126      *
1127      * Requirements:
1128      *
1129      * - `to` cannot be the zero address.
1130      * - `tokenId` token must be owned by `from`.
1131      *
1132      * Emits a {Transfer} event.
1133      */
1134     function _transfer(
1135         address from,
1136         address to,
1137         uint256 tokenId
1138     ) internal virtual {
1139         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1140         require(to != address(0), "ERC721: transfer to the zero address");
1141 
1142         _beforeTokenTransfer(from, to, tokenId);
1143 
1144         // Clear approvals from the previous owner
1145         _approve(address(0), tokenId);
1146 
1147         _balances[from] -= 1;
1148         _balances[to] += 1;
1149         _owners[tokenId] = to;
1150 
1151         emit Transfer(from, to, tokenId);
1152     }
1153 
1154     /**
1155      * @dev Approve `to` to operate on `tokenId`
1156      *
1157      * Emits a {Approval} event.
1158      */
1159     function _approve(address to, uint256 tokenId) internal virtual {
1160         _tokenApprovals[tokenId] = to;
1161         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1162     }
1163 
1164     /**
1165      * @dev Approve `operator` to operate on all of `owner` tokens
1166      *
1167      * Emits a {ApprovalForAll} event.
1168      */
1169     function _setApprovalForAll(
1170         address owner,
1171         address operator,
1172         bool approved
1173     ) internal virtual {
1174         require(owner != operator, "ERC721: approve to caller");
1175         _operatorApprovals[owner][operator] = approved;
1176         emit ApprovalForAll(owner, operator, approved);
1177     }
1178 
1179     /**
1180      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1181      * The call is not executed if the target address is not a contract.
1182      *
1183      * @param from address representing the previous owner of the given token ID
1184      * @param to target address that will receive the tokens
1185      * @param tokenId uint256 ID of the token to be transferred
1186      * @param _data bytes optional data to send along with the call
1187      * @return bool whether the call correctly returned the expected magic value
1188      */
1189     function _checkOnERC721Received(
1190         address from,
1191         address to,
1192         uint256 tokenId,
1193         bytes memory _data
1194     ) private returns (bool) {
1195         if (to.isContract()) {
1196             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1197                 return retval == IERC721Receiver.onERC721Received.selector;
1198             } catch (bytes memory reason) {
1199                 if (reason.length == 0) {
1200                     revert("ERC721: transfer to non ERC721Receiver implementer");
1201                 } else {
1202                     assembly {
1203                         revert(add(32, reason), mload(reason))
1204                     }
1205                 }
1206             }
1207         } else {
1208             return true;
1209         }
1210     }
1211 
1212     /**
1213      * @dev Hook that is called before any token transfer. This includes minting
1214      * and burning.
1215      *
1216      * Calling conditions:
1217      *
1218      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1219      * transferred to `to`.
1220      * - When `from` is zero, `tokenId` will be minted for `to`.
1221      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1222      * - `from` and `to` are never both zero.
1223      *
1224      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1225      */
1226     function _beforeTokenTransfer(
1227         address from,
1228         address to,
1229         uint256 tokenId
1230     ) internal virtual {}
1231 }
1232 
1233 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol
1234 
1235 
1236 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Pausable.sol)
1237 
1238 pragma solidity ^0.8.0;
1239 
1240 
1241 
1242 /**
1243  * @dev ERC721 token with pausable token transfers, minting and burning.
1244  *
1245  * Useful for scenarios such as preventing trades until the end of an evaluation
1246  * period, or having an emergency switch for freezing all token transfers in the
1247  * event of a large bug.
1248  */
1249 abstract contract ERC721Pausable is ERC721, Pausable {
1250     /**
1251      * @dev See {ERC721-_beforeTokenTransfer}.
1252      *
1253      * Requirements:
1254      *
1255      * - the contract must not be paused.
1256      */
1257     function _beforeTokenTransfer(
1258         address from,
1259         address to,
1260         uint256 tokenId
1261     ) internal virtual override {
1262         super._beforeTokenTransfer(from, to, tokenId);
1263 
1264         require(!paused(), "ERC721Pausable: token transfer while paused");
1265     }
1266 }
1267 
1268 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol
1269 
1270 
1271 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1272 
1273 pragma solidity ^0.8.0;
1274 
1275 
1276 
1277 /**
1278  * @title ERC721 Burnable Token
1279  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1280  */
1281 abstract contract ERC721Burnable is Context, ERC721 {
1282     /**
1283      * @dev Burns `tokenId`. See {ERC721-_burn}.
1284      *
1285      * Requirements:
1286      *
1287      * - The caller must own `tokenId` or be an approved operator.
1288      */
1289     function burn(uint256 tokenId) public virtual {
1290         //solhint-disable-next-line max-line-length
1291         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1292         _burn(tokenId);
1293     }
1294 }
1295 
1296 // File: twf2.sol
1297 
1298 
1299 pragma solidity ^0.8.0;
1300 
1301 
1302 
1303 
1304 
1305 
1306 contract TWF is ERC721, Ownable, ERC721Burnable, ERC721Pausable {
1307     uint256 private _tokenIdTracker;
1308 
1309     uint256 public constant MAX_ELEMENTS = 9999;
1310     uint256 public constant PRESALE_ELEMENTS = 9999;
1311     uint256 public constant PRESALE_PRICE = 0.059 ether;
1312     uint256 public constant PRICE = 0.069 ether;
1313     uint256 public constant MAX_BY_MINT = 5;
1314     uint256 public constant maxMintPreSale = 5;
1315 
1316     string public baseTokenURI;
1317 
1318     address public withdrawAddress;
1319 
1320     bytes32 public merkleRoot;
1321 
1322     mapping(address => uint256) public whitelistClaimed;
1323 
1324     bool public publicSaleOpen;
1325 
1326     event CreateItem(uint256 indexed id);
1327     event PublicSaleStarted(bool started);
1328     constructor()
1329     ERC721("Trees With Faces", "TWF!")
1330     {
1331         pause(true);
1332         setWithdrawAddress(0xA1d34Fd7c675d95d2d03Fb3576f9f0D2DC8239eF);
1333     }
1334 
1335     modifier saleIsOpen {
1336         require(_tokenIdTracker <= MAX_ELEMENTS, "Sale end");
1337         if (_msgSender() != owner()) {
1338             require(!paused(), "Pausable: paused");
1339         }
1340         _;
1341     }
1342 
1343     modifier noContract() {
1344         address account = msg.sender;
1345         require(account == tx.origin, "Caller is a contract");
1346         require(account.code.length == 0, "Caller is a contract");
1347         _;
1348     }
1349 
1350     function totalSupply() public view returns (uint256) {
1351         return _tokenIdTracker;
1352     }
1353 
1354     function setPublicSale(bool val) public onlyOwner {
1355         publicSaleOpen = val;
1356         emit PublicSaleStarted(val);
1357     }
1358 
1359     function mint(uint256 _count) public payable saleIsOpen noContract {
1360         uint256 total = totalSupply();
1361         require(publicSaleOpen, "Public sale not open yet");
1362         require(total + _count <= MAX_ELEMENTS, "Max limit");
1363         require(_count <= MAX_BY_MINT, "Exceeds number");
1364         require(msg.value == PRICE * _count, "Value is over or under price.");
1365 
1366         for (uint256 i = 0; i < _count; i++) {
1367             _mintAnElement(msg.sender);
1368         }
1369     }
1370 
1371     function presaleMint(uint256 _count, bytes32[] calldata _proof) public payable saleIsOpen noContract {
1372         uint256 total = totalSupply();
1373         require(msg.value == PRESALE_PRICE * _count, "Value is over or under price.");
1374         require(total + _count <= PRESALE_ELEMENTS, "Max limit");
1375         require(verifySender(_proof), "Sender is not whitelisted");
1376         require(canMintAmount(_count), "Sender max presale mint amount already met");
1377 
1378         whitelistClaimed[msg.sender] += _count;
1379         for (uint256 i = 0; i < _count; i++) {
1380             _mintAnElement(msg.sender);
1381         }
1382     }
1383 
1384     function ownerMint(uint256 _count) public onlyOwner {
1385         uint256 total = totalSupply();
1386         require(total + _count <= MAX_ELEMENTS, "Sale end");
1387 
1388         for (uint256 i = 0; i < _count; i++) {
1389             _mintAnElement(msg.sender);
1390         }
1391     }
1392 
1393     function _mintAnElement(address _to) private {
1394         uint id = totalSupply();
1395         _tokenIdTracker += 1;
1396         _mint(_to, id);
1397         emit CreateItem(id);
1398     }
1399 
1400     function canMintAmount(uint256 _count) public view returns (bool) {
1401         return whitelistClaimed[msg.sender] + _count <= maxMintPreSale;
1402     }
1403 
1404     function setWhitelistMerkleRoot(bytes32 _merkleRoot) external onlyOwner {
1405         merkleRoot = _merkleRoot;
1406     }
1407 
1408     function verifySender(bytes32[] calldata proof) public view returns (bool) {
1409         return _verify(proof, _hash(msg.sender));
1410     }
1411 
1412     function _verify(bytes32[] calldata proof, bytes32 addressHash) internal view returns (bool) {
1413         return MerkleProof.verify(proof, merkleRoot, addressHash);
1414     }
1415 
1416     function _hash(address _address) internal pure returns (bytes32) {
1417         return keccak256(abi.encodePacked(_address));
1418     }
1419 
1420     function _baseURI() internal view virtual override returns (string memory) {
1421         return baseTokenURI;
1422     }
1423 
1424     function setBaseURI(string memory baseURI) public onlyOwner {
1425         baseTokenURI = baseURI;
1426     }
1427 
1428     function pause(bool val) public onlyOwner {
1429         if (val == true) {
1430             _pause();
1431             return;
1432         }
1433         _unpause();
1434     }
1435 
1436     function withdrawAll() public onlyOwner {
1437         uint256 balance = address(this).balance;
1438         require(balance > 0);
1439         _withdraw(withdrawAddress, balance);
1440     }
1441 
1442     function setWithdrawAddress(address _withdrawAddress) public onlyOwner {
1443         withdrawAddress = _withdrawAddress;
1444     }
1445 
1446     function _withdraw(address _address, uint256 _amount) private {
1447         (bool success, ) = _address.call{value: _amount}("");
1448         require(success, "Transfer failed.");
1449     }
1450 
1451     function _beforeTokenTransfer(
1452         address from,
1453         address to,
1454         uint256 tokenId
1455     ) internal virtual override(ERC721, ERC721Pausable) {
1456         super._beforeTokenTransfer(from, to, tokenId);
1457     }
1458 
1459     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
1460         return super.supportsInterface(interfaceId);
1461     }
1462 }