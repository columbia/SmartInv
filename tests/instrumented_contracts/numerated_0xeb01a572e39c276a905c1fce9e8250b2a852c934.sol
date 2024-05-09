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
778 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
779 
780 
781 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
782 
783 pragma solidity ^0.8.0;
784 
785 
786 /**
787  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
788  * @dev See https://eips.ethereum.org/EIPS/eip-721
789  */
790 interface IERC721Enumerable is IERC721 {
791     /**
792      * @dev Returns the total amount of tokens stored by the contract.
793      */
794     function totalSupply() external view returns (uint256);
795 
796     /**
797      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
798      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
799      */
800     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
801 
802     /**
803      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
804      * Use along with {totalSupply} to enumerate all tokens.
805      */
806     function tokenByIndex(uint256 index) external view returns (uint256);
807 }
808 
809 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
810 
811 
812 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
813 
814 pragma solidity ^0.8.0;
815 
816 
817 /**
818  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
819  * @dev See https://eips.ethereum.org/EIPS/eip-721
820  */
821 interface IERC721Metadata is IERC721 {
822     /**
823      * @dev Returns the token collection name.
824      */
825     function name() external view returns (string memory);
826 
827     /**
828      * @dev Returns the token collection symbol.
829      */
830     function symbol() external view returns (string memory);
831 
832     /**
833      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
834      */
835     function tokenURI(uint256 tokenId) external view returns (string memory);
836 }
837 
838 // File: erc721a/contracts/ERC721A.sol
839 
840 
841 // Creator: Chiru Labs
842 
843 pragma solidity ^0.8.0;
844 
845 
846 
847 
848 
849 
850 
851 
852 
853 /**
854  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
855  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
856  *
857  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
858  *
859  * Does not support burning tokens to address(0).
860  *
861  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
862  */
863 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
864     using Address for address;
865     using Strings for uint256;
866 
867     struct TokenOwnership {
868         address addr;
869         uint64 startTimestamp;
870     }
871 
872     struct AddressData {
873         uint128 balance;
874         uint128 numberMinted;
875     }
876 
877     uint256 internal currentIndex;
878 
879     // Token name
880     string private _name;
881 
882     // Token symbol
883     string private _symbol;
884 
885     // Mapping from token ID to ownership details
886     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
887     mapping(uint256 => TokenOwnership) internal _ownerships;
888 
889     // Mapping owner address to address data
890     mapping(address => AddressData) private _addressData;
891 
892     // Mapping from token ID to approved address
893     mapping(uint256 => address) private _tokenApprovals;
894 
895     // Mapping from owner to operator approvals
896     mapping(address => mapping(address => bool)) private _operatorApprovals;
897 
898     constructor(string memory name_, string memory symbol_) {
899         _name = name_;
900         _symbol = symbol_;
901     }
902 
903     /**
904      * @dev See {IERC721Enumerable-totalSupply}.
905      */
906     function totalSupply() public view override returns (uint256) {
907         return currentIndex;
908     }
909 
910     /**
911      * @dev See {IERC721Enumerable-tokenByIndex}.
912      */
913     function tokenByIndex(uint256 index) public view override returns (uint256) {
914         require(index < totalSupply(), 'ERC721A: global index out of bounds');
915         return index;
916     }
917 
918     /**
919      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
920      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
921      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
922      */
923     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
924         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
925         uint256 numMintedSoFar = totalSupply();
926         uint256 tokenIdsIdx;
927         address currOwnershipAddr;
928 
929         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
930         unchecked {
931             for (uint256 i; i < numMintedSoFar; i++) {
932                 TokenOwnership memory ownership = _ownerships[i];
933                 if (ownership.addr != address(0)) {
934                     currOwnershipAddr = ownership.addr;
935                 }
936                 if (currOwnershipAddr == owner) {
937                     if (tokenIdsIdx == index) {
938                         return i;
939                     }
940                     tokenIdsIdx++;
941                 }
942             }
943         }
944 
945         revert('ERC721A: unable to get token of owner by index');
946     }
947 
948     /**
949      * @dev See {IERC165-supportsInterface}.
950      */
951     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
952         return
953             interfaceId == type(IERC721).interfaceId ||
954             interfaceId == type(IERC721Metadata).interfaceId ||
955             interfaceId == type(IERC721Enumerable).interfaceId ||
956             super.supportsInterface(interfaceId);
957     }
958 
959     /**
960      * @dev See {IERC721-balanceOf}.
961      */
962     function balanceOf(address owner) public view override returns (uint256) {
963         require(owner != address(0), 'ERC721A: balance query for the zero address');
964         return uint256(_addressData[owner].balance);
965     }
966 
967     function _numberMinted(address owner) internal view returns (uint256) {
968         require(owner != address(0), 'ERC721A: number minted query for the zero address');
969         return uint256(_addressData[owner].numberMinted);
970     }
971 
972     /**
973      * Gas spent here starts off proportional to the maximum mint batch size.
974      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
975      */
976     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
977         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
978 
979         unchecked {
980             for (uint256 curr = tokenId; curr >= 0; curr--) {
981                 TokenOwnership memory ownership = _ownerships[curr];
982                 if (ownership.addr != address(0)) {
983                     return ownership;
984                 }
985             }
986         }
987 
988         revert('ERC721A: unable to determine the owner of token');
989     }
990 
991     /**
992      * @dev See {IERC721-ownerOf}.
993      */
994     function ownerOf(uint256 tokenId) public view override returns (address) {
995         return ownershipOf(tokenId).addr;
996     }
997 
998     /**
999      * @dev See {IERC721Metadata-name}.
1000      */
1001     function name() public view virtual override returns (string memory) {
1002         return _name;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-symbol}.
1007      */
1008     function symbol() public view virtual override returns (string memory) {
1009         return _symbol;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-tokenURI}.
1014      */
1015     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1016         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1017 
1018         string memory baseURI = _baseURI();
1019         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1020     }
1021 
1022     /**
1023      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1024      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1025      * by default, can be overriden in child contracts.
1026      */
1027     function _baseURI() internal view virtual returns (string memory) {
1028         return '';
1029     }
1030 
1031     /**
1032      * @dev See {IERC721-approve}.
1033      */
1034     function approve(address to, uint256 tokenId) public override {
1035         address owner = ERC721A.ownerOf(tokenId);
1036         require(to != owner, 'ERC721A: approval to current owner');
1037 
1038         require(
1039             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1040             'ERC721A: approve caller is not owner nor approved for all'
1041         );
1042 
1043         _approve(to, tokenId, owner);
1044     }
1045 
1046     /**
1047      * @dev See {IERC721-getApproved}.
1048      */
1049     function getApproved(uint256 tokenId) public view override returns (address) {
1050         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
1051 
1052         return _tokenApprovals[tokenId];
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-setApprovalForAll}.
1057      */
1058     function setApprovalForAll(address operator, bool approved) public override {
1059         require(operator != _msgSender(), 'ERC721A: approve to caller');
1060 
1061         _operatorApprovals[_msgSender()][operator] = approved;
1062         emit ApprovalForAll(_msgSender(), operator, approved);
1063     }
1064 
1065     /**
1066      * @dev See {IERC721-isApprovedForAll}.
1067      */
1068     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1069         return _operatorApprovals[owner][operator];
1070     }
1071 
1072     /**
1073      * @dev See {IERC721-transferFrom}.
1074      */
1075     function transferFrom(
1076         address from,
1077         address to,
1078         uint256 tokenId
1079     ) public override {
1080         _transfer(from, to, tokenId);
1081     }
1082 
1083     /**
1084      * @dev See {IERC721-safeTransferFrom}.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId
1090     ) public override {
1091         safeTransferFrom(from, to, tokenId, '');
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-safeTransferFrom}.
1096      */
1097     function safeTransferFrom(
1098         address from,
1099         address to,
1100         uint256 tokenId,
1101         bytes memory _data
1102     ) public override {
1103         _transfer(from, to, tokenId);
1104         require(
1105             _checkOnERC721Received(from, to, tokenId, _data),
1106             'ERC721A: transfer to non ERC721Receiver implementer'
1107         );
1108     }
1109 
1110     /**
1111      * @dev Returns whether `tokenId` exists.
1112      *
1113      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1114      *
1115      * Tokens start existing when they are minted (`_mint`),
1116      */
1117     function _exists(uint256 tokenId) internal view returns (bool) {
1118         return tokenId < currentIndex;
1119     }
1120 
1121     function _safeMint(address to, uint256 quantity) internal {
1122         _safeMint(to, quantity, '');
1123     }
1124 
1125     /**
1126      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1127      *
1128      * Requirements:
1129      *
1130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1131      * - `quantity` must be greater than 0.
1132      *
1133      * Emits a {Transfer} event.
1134      */
1135     function _safeMint(
1136         address to,
1137         uint256 quantity,
1138         bytes memory _data
1139     ) internal {
1140         _mint(to, quantity, _data, true);
1141     }
1142 
1143     /**
1144      * @dev Mints `quantity` tokens and transfers them to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - `to` cannot be the zero address.
1149      * - `quantity` must be greater than 0.
1150      *
1151      * Emits a {Transfer} event.
1152      */
1153     function _mint(
1154         address to,
1155         uint256 quantity,
1156         bytes memory _data,
1157         bool safe
1158     ) internal {
1159         uint256 startTokenId = currentIndex;
1160         require(to != address(0), 'ERC721A: mint to the zero address');
1161         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1162 
1163         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1164 
1165         // Overflows are incredibly unrealistic.
1166         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1167         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1168         unchecked {
1169             _addressData[to].balance += uint128(quantity);
1170             _addressData[to].numberMinted += uint128(quantity);
1171 
1172             _ownerships[startTokenId].addr = to;
1173             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1174 
1175             uint256 updatedIndex = startTokenId;
1176 
1177             for (uint256 i; i < quantity; i++) {
1178                 emit Transfer(address(0), to, updatedIndex);
1179                 if (safe) {
1180                     require(
1181                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1182                         'ERC721A: transfer to non ERC721Receiver implementer'
1183                     );
1184                 }
1185 
1186                 updatedIndex++;
1187             }
1188 
1189             currentIndex = updatedIndex;
1190         }
1191 
1192         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1193     }
1194 
1195     /**
1196      * @dev Transfers `tokenId` from `from` to `to`.
1197      *
1198      * Requirements:
1199      *
1200      * - `to` cannot be the zero address.
1201      * - `tokenId` token must be owned by `from`.
1202      *
1203      * Emits a {Transfer} event.
1204      */
1205     function _transfer(
1206         address from,
1207         address to,
1208         uint256 tokenId
1209     ) private {
1210         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1211 
1212         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1213             getApproved(tokenId) == _msgSender() ||
1214             isApprovedForAll(prevOwnership.addr, _msgSender()));
1215 
1216         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1217 
1218         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1219         require(to != address(0), 'ERC721A: transfer to the zero address');
1220 
1221         _beforeTokenTransfers(from, to, tokenId, 1);
1222 
1223         // Clear approvals from the previous owner
1224         _approve(address(0), tokenId, prevOwnership.addr);
1225 
1226         // Underflow of the sender's balance is impossible because we check for
1227         // ownership above and the recipient's balance can't realistically overflow.
1228         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1229         unchecked {
1230             _addressData[from].balance -= 1;
1231             _addressData[to].balance += 1;
1232 
1233             _ownerships[tokenId].addr = to;
1234             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1235 
1236             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1237             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1238             uint256 nextTokenId = tokenId + 1;
1239             if (_ownerships[nextTokenId].addr == address(0)) {
1240                 if (_exists(nextTokenId)) {
1241                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1242                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1243                 }
1244             }
1245         }
1246 
1247         emit Transfer(from, to, tokenId);
1248         _afterTokenTransfers(from, to, tokenId, 1);
1249     }
1250 
1251     /**
1252      * @dev Approve `to` to operate on `tokenId`
1253      *
1254      * Emits a {Approval} event.
1255      */
1256     function _approve(
1257         address to,
1258         uint256 tokenId,
1259         address owner
1260     ) private {
1261         _tokenApprovals[tokenId] = to;
1262         emit Approval(owner, to, tokenId);
1263     }
1264 
1265     /**
1266      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1267      * The call is not executed if the target address is not a contract.
1268      *
1269      * @param from address representing the previous owner of the given token ID
1270      * @param to target address that will receive the tokens
1271      * @param tokenId uint256 ID of the token to be transferred
1272      * @param _data bytes optional data to send along with the call
1273      * @return bool whether the call correctly returned the expected magic value
1274      */
1275     function _checkOnERC721Received(
1276         address from,
1277         address to,
1278         uint256 tokenId,
1279         bytes memory _data
1280     ) private returns (bool) {
1281         if (to.isContract()) {
1282             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1283                 return retval == IERC721Receiver(to).onERC721Received.selector;
1284             } catch (bytes memory reason) {
1285                 if (reason.length == 0) {
1286                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1287                 } else {
1288                     assembly {
1289                         revert(add(32, reason), mload(reason))
1290                     }
1291                 }
1292             }
1293         } else {
1294             return true;
1295         }
1296     }
1297 
1298     /**
1299      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1300      *
1301      * startTokenId - the first token id to be transferred
1302      * quantity - the amount to be transferred
1303      *
1304      * Calling conditions:
1305      *
1306      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1307      * transferred to `to`.
1308      * - When `from` is zero, `tokenId` will be minted for `to`.
1309      */
1310     function _beforeTokenTransfers(
1311         address from,
1312         address to,
1313         uint256 startTokenId,
1314         uint256 quantity
1315     ) internal virtual {}
1316 
1317     /**
1318      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1319      * minting.
1320      *
1321      * startTokenId - the first token id to be transferred
1322      * quantity - the amount to be transferred
1323      *
1324      * Calling conditions:
1325      *
1326      * - when `from` and `to` are both non-zero.
1327      * - `from` and `to` are never both zero.
1328      */
1329     function _afterTokenTransfers(
1330         address from,
1331         address to,
1332         uint256 startTokenId,
1333         uint256 quantity
1334     ) internal virtual {}
1335 }
1336 
1337 // File: contracts/BadCardsClub.sol
1338 
1339 
1340 pragma solidity 0.8.11;
1341 
1342 
1343 
1344 
1345 
1346 
1347 /// @title Bad Cards Club
1348 contract BadCardsClub is Ownable, Pausable, ERC721A {
1349   using MerkleProof for bytes32[];
1350   using Strings for uint256;
1351 
1352   /* -------------------------------------------------------------------------- */
1353   /*                                Token Details                               */
1354   /* -------------------------------------------------------------------------- */
1355 
1356   /// @notice Unrevealed metadata uri.
1357   string public unrevealedURI;
1358 
1359   /// @notice Token metadata uri.
1360   string public baseURI;
1361 
1362   /* -------------------------------------------------------------------------- */
1363   /*                                Sale Details                                */
1364   /* -------------------------------------------------------------------------- */
1365 
1366   /// @notice Token max supply.
1367   uint256 public constant BCC_SUPPLY = 6969;
1368 
1369   /// @notice Token price at public sale.
1370   uint256 public constant BCC_PRICE = 0.042 ether;
1371 
1372   /// @notice Max buy amount per transaction.
1373   uint256 public perTX = 5;
1374 
1375   /// @notice Max buy amount per transaction at presale.
1376   uint256 public perWL = 5;
1377 
1378   /// @notice Max buys per address.
1379   uint256 public perAddress = 10;
1380 
1381   /// @notice Sale state.
1382   /// @dev 0 = CLOSED, 1 = allowlist, 2 = OPEN.
1383   uint256 public saleState;
1384 
1385   /// @notice Allowlist merkle root.
1386   bytes32 public root;
1387 
1388   /// @notice Tokens bought by address at public sale.
1389   mapping(address => uint256) public bought;
1390 
1391   /// @notice Tokens bought by address at presale.
1392   mapping(address => uint256) public boughtPresale;
1393 
1394   constructor(string memory newUnrevealedURI, bytes32 newRoot) ERC721A("Bad Cards Club", "BAD") {
1395     unrevealedURI = newUnrevealedURI;
1396     root = newRoot;
1397   }
1398 
1399   /* -------------------------------------------------------------------------- */
1400   /*                                 Sale Logic                                 */
1401   /* -------------------------------------------------------------------------- */
1402 
1403   /// @notice Buy one or more tokens.
1404   /// @dev If minting on public sale, just input an empty array as the proof.
1405   /// @param amount Amount of tokens to buy.
1406   /// @param proof Allowlist proof for presale purchases.
1407   function buy(uint256 amount, bytes32[] memory proof) external payable {
1408     require(saleState == 1 || saleState == 2, "Sale is closed");
1409     require(totalSupply() < BCC_SUPPLY, "Max suply exceeded");
1410     require(msg.value == amount * BCC_PRICE, "Invalid ether amount");
1411 
1412     if (saleState == 1) {
1413       // Presale
1414       require(amount > 0 && amount <= perWL, "Invalid buy amount");
1415       require(amount + boughtPresale[msg.sender] <= perWL, "Allowlist buy cap exceeded");
1416       require(proof.verify(root, keccak256(abi.encodePacked(msg.sender))), "Invalid buy proof");
1417       boughtPresale[msg.sender] += amount;
1418     } else {
1419       // Public sale
1420       require(amount > 0 && amount <= perTX, "Invalid buy amount");
1421       require(amount + bought[msg.sender] <= perAddress, "Address buy cap exceeded");
1422       bought[msg.sender] += amount;
1423     }
1424 
1425     _safeMint(msg.sender, amount);
1426   }
1427 
1428   /// @notice Buy reserved tokens.
1429   /// @dev Must be called by the owner.
1430   /// @param amount Amount of tokens to buy.
1431   function buyReserved(uint256 amount) external onlyOwner {
1432     require(totalSupply() < BCC_SUPPLY, "Max supply exceeded");
1433     super._safeMint(msg.sender, amount);
1434   }
1435 
1436   /* -------------------------------------------------------------------------- */
1437   /*                                 Owner Logic                                */
1438   /* -------------------------------------------------------------------------- */
1439 
1440   /// @notice Set per transaction buy amount.
1441   /// @param newPerTX New per transaction buy amount.
1442   function setPerTX(uint256 newPerTX) external onlyOwner {
1443     perTX = newPerTX;
1444   }
1445 
1446   /// @notice Set per allowlist buy amount.
1447   /// @param newPerWL New per allowlist buy amount.
1448   function setPerWL(uint256 newPerWL) external onlyOwner {
1449     perWL = newPerWL;
1450   }
1451 
1452   /// @notice Set per address buy amount.
1453   /// @param newPerAddress New per address buy amount.
1454   function setPerAddress(uint256 newPerAddress) external onlyOwner {
1455     perAddress = newPerAddress;
1456   }
1457 
1458   /// @notice Set allowlist merkle root.
1459   /// @param newRoot New allowlist merkle root.
1460   function setRoot(bytes32 newRoot) external onlyOwner {
1461     root = newRoot;
1462   }
1463 
1464   /// @notice Set sale state.
1465   /// @param newSaleState New sale state.
1466   function setSaleState(uint256 newSaleState) external onlyOwner {
1467     saleState = newSaleState;
1468   }
1469 
1470   /// @notice Set metadata unrevealed uri.
1471   /// @param newUnrevealedURI New unrevealed uri.
1472   function setUnrevealedURI(string memory newUnrevealedURI) external onlyOwner {
1473     unrevealedURI = newUnrevealedURI;
1474   }
1475 
1476   /// @notice Set metadata base uri.
1477   /// @param newBaseURI New base uri.
1478   function setBaseURI(string memory newBaseURI) external onlyOwner {
1479     baseURI = newBaseURI;
1480     delete unrevealedURI;
1481   }
1482 
1483   /// @notice Toggle contract paused state.
1484   function togglePaused() external onlyOwner {
1485     if (super.paused()) _unpause();
1486     else _pause();
1487   }
1488 
1489   /// @notice Withdraw contract ether to the owner.
1490   function withdraw() external onlyOwner {
1491     (bool success, ) = super.owner().call{value: address(this).balance}("");
1492     require(success, "Withdraw failed");
1493   }
1494 
1495   /* -------------------------------------------------------------------------- */
1496   /*                                ERC-721 Logic                               */
1497   /* -------------------------------------------------------------------------- */
1498 
1499   /// @notice See {ERC721Metadata-tokenURI}.
1500   function tokenURI(uint256 tokenId) public view override returns (string memory) {
1501     require(_exists(tokenId), "ERC721Metadata: query for nonexisting token");
1502 
1503     if (bytes(unrevealedURI).length > 0) return unrevealedURI;
1504     return string(abi.encodePacked(baseURI, tokenId.toString()));
1505   }
1506 }