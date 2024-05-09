1 // Sources flattened with hardhat v2.9.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
4 
5 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 
30 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
31 
32 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
108 
109 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
110 
111 pragma solidity ^0.8.0;
112 
113 /**
114  * @dev Collection of functions related to the address type
115  */
116 library Address {
117     /**
118      * @dev Returns true if `account` is a contract.
119      *
120      * [IMPORTANT]
121      * ====
122      * It is unsafe to assume that an address for which this function returns
123      * false is an externally-owned account (EOA) and not a contract.
124      *
125      * Among others, `isContract` will return false for the following
126      * types of addresses:
127      *
128      *  - an externally-owned account
129      *  - a contract in construction
130      *  - an address where a contract will be created
131      *  - an address where a contract lived, but was destroyed
132      * ====
133      */
134     function isContract(address account) internal view returns (bool) {
135         // This method relies on extcodesize, which returns 0 for contracts in
136         // construction, since the code is only stored at the end of the
137         // constructor execution.
138 
139         uint256 size;
140         assembly {
141             size := extcodesize(account)
142         }
143         return size > 0;
144     }
145 
146     /**
147      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
148      * `recipient`, forwarding all available gas and reverting on errors.
149      *
150      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
151      * of certain opcodes, possibly making contracts go over the 2300 gas limit
152      * imposed by `transfer`, making them unable to receive funds via
153      * `transfer`. {sendValue} removes this limitation.
154      *
155      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
156      *
157      * IMPORTANT: because control is transferred to `recipient`, care must be
158      * taken to not create reentrancy vulnerabilities. Consider using
159      * {ReentrancyGuard} or the
160      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
161      */
162     function sendValue(address payable recipient, uint256 amount) internal {
163         require(address(this).balance >= amount, "Address: insufficient balance");
164 
165         (bool success, ) = recipient.call{value: amount}("");
166         require(success, "Address: unable to send value, recipient may have reverted");
167     }
168 
169     /**
170      * @dev Performs a Solidity function call using a low level `call`. A
171      * plain `call` is an unsafe replacement for a function call: use this
172      * function instead.
173      *
174      * If `target` reverts with a revert reason, it is bubbled up by this
175      * function (like regular Solidity function calls).
176      *
177      * Returns the raw returned data. To convert to the expected return value,
178      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
179      *
180      * Requirements:
181      *
182      * - `target` must be a contract.
183      * - calling `target` with `data` must not revert.
184      *
185      * _Available since v3.1._
186      */
187     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
188         return functionCall(target, data, "Address: low-level call failed");
189     }
190 
191     /**
192      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
193      * `errorMessage` as a fallback revert reason when `target` reverts.
194      *
195      * _Available since v3.1._
196      */
197     function functionCall(
198         address target,
199         bytes memory data,
200         string memory errorMessage
201     ) internal returns (bytes memory) {
202         return functionCallWithValue(target, data, 0, errorMessage);
203     }
204 
205     /**
206      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
207      * but also transferring `value` wei to `target`.
208      *
209      * Requirements:
210      *
211      * - the calling contract must have an ETH balance of at least `value`.
212      * - the called Solidity function must be `payable`.
213      *
214      * _Available since v3.1._
215      */
216     function functionCallWithValue(
217         address target,
218         bytes memory data,
219         uint256 value
220     ) internal returns (bytes memory) {
221         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
226      * with `errorMessage` as a fallback revert reason when `target` reverts.
227      *
228      * _Available since v3.1._
229      */
230     function functionCallWithValue(
231         address target,
232         bytes memory data,
233         uint256 value,
234         string memory errorMessage
235     ) internal returns (bytes memory) {
236         require(address(this).balance >= value, "Address: insufficient balance for call");
237         require(isContract(target), "Address: call to non-contract");
238 
239         (bool success, bytes memory returndata) = target.call{value: value}(data);
240         return verifyCallResult(success, returndata, errorMessage);
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
245      * but performing a static call.
246      *
247      * _Available since v3.3._
248      */
249     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
250         return functionStaticCall(target, data, "Address: low-level static call failed");
251     }
252 
253     /**
254      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
255      * but performing a static call.
256      *
257      * _Available since v3.3._
258      */
259     function functionStaticCall(
260         address target,
261         bytes memory data,
262         string memory errorMessage
263     ) internal view returns (bytes memory) {
264         require(isContract(target), "Address: static call to non-contract");
265 
266         (bool success, bytes memory returndata) = target.staticcall(data);
267         return verifyCallResult(success, returndata, errorMessage);
268     }
269 
270     /**
271      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
272      * but performing a delegate call.
273      *
274      * _Available since v3.4._
275      */
276     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
277         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
282      * but performing a delegate call.
283      *
284      * _Available since v3.4._
285      */
286     function functionDelegateCall(
287         address target,
288         bytes memory data,
289         string memory errorMessage
290     ) internal returns (bytes memory) {
291         require(isContract(target), "Address: delegate call to non-contract");
292 
293         (bool success, bytes memory returndata) = target.delegatecall(data);
294         return verifyCallResult(success, returndata, errorMessage);
295     }
296 
297     /**
298      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
299      * revert reason using the provided one.
300      *
301      * _Available since v4.3._
302      */
303     function verifyCallResult(
304         bool success,
305         bytes memory returndata,
306         string memory errorMessage
307     ) internal pure returns (bytes memory) {
308         if (success) {
309             return returndata;
310         } else {
311             // Look for revert reason and bubble it up if present
312             if (returndata.length > 0) {
313                 // The easiest way to bubble the revert reason is using memory via assembly
314 
315                 assembly {
316                     let returndata_size := mload(returndata)
317                     revert(add(32, returndata), returndata_size)
318                 }
319             } else {
320                 revert(errorMessage);
321             }
322         }
323     }
324 }
325 
326 
327 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
328 
329 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
330 
331 pragma solidity ^0.8.0;
332 
333 /**
334  * @dev String operations.
335  */
336 library Strings {
337     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
338 
339     /**
340      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
341      */
342     function toString(uint256 value) internal pure returns (string memory) {
343         // Inspired by OraclizeAPI's implementation - MIT licence
344         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
345 
346         if (value == 0) {
347             return "0";
348         }
349         uint256 temp = value;
350         uint256 digits;
351         while (temp != 0) {
352             digits++;
353             temp /= 10;
354         }
355         bytes memory buffer = new bytes(digits);
356         while (value != 0) {
357             digits -= 1;
358             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
359             value /= 10;
360         }
361         return string(buffer);
362     }
363 
364     /**
365      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
366      */
367     function toHexString(uint256 value) internal pure returns (string memory) {
368         if (value == 0) {
369             return "0x00";
370         }
371         uint256 temp = value;
372         uint256 length = 0;
373         while (temp != 0) {
374             length++;
375             temp >>= 8;
376         }
377         return toHexString(value, length);
378     }
379 
380     /**
381      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
382      */
383     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
384         bytes memory buffer = new bytes(2 * length + 2);
385         buffer[0] = "0";
386         buffer[1] = "x";
387         for (uint256 i = 2 * length + 1; i > 1; --i) {
388             buffer[i] = _HEX_SYMBOLS[value & 0xf];
389             value >>= 4;
390         }
391         require(value == 0, "Strings: hex length insufficient");
392         return string(buffer);
393     }
394 }
395 
396 
397 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.2
398 
399 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
400 
401 pragma solidity ^0.8.0;
402 
403 /**
404  * @dev These functions deal with verification of Merkle Trees proofs.
405  *
406  * The proofs can be generated using the JavaScript library
407  * https://github.com/miguelmota/merkletreejs[merkletreejs].
408  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
409  *
410  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
411  */
412 library MerkleProof {
413     /**
414      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
415      * defined by `root`. For this, a `proof` must be provided, containing
416      * sibling hashes on the branch from the leaf to the root of the tree. Each
417      * pair of leaves and each pair of pre-images are assumed to be sorted.
418      */
419     function verify(
420         bytes32[] memory proof,
421         bytes32 root,
422         bytes32 leaf
423     ) internal pure returns (bool) {
424         return processProof(proof, leaf) == root;
425     }
426 
427     /**
428      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
429      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
430      * hash matches the root of the tree. When processing the proof, the pairs
431      * of leafs & pre-images are assumed to be sorted.
432      *
433      * _Available since v4.4._
434      */
435     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
436         bytes32 computedHash = leaf;
437         for (uint256 i = 0; i < proof.length; i++) {
438             bytes32 proofElement = proof[i];
439             if (computedHash <= proofElement) {
440                 // Hash(current computed hash + current element of the proof)
441                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
442             } else {
443                 // Hash(current element of the proof + current computed hash)
444                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
445             }
446         }
447         return computedHash;
448     }
449 }
450 
451 
452 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
453 
454 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
455 
456 pragma solidity ^0.8.0;
457 
458 /**
459  * @dev Interface of the ERC165 standard, as defined in the
460  * https://eips.ethereum.org/EIPS/eip-165[EIP].
461  *
462  * Implementers can declare support of contract interfaces, which can then be
463  * queried by others ({ERC165Checker}).
464  *
465  * For an implementation, see {ERC165}.
466  */
467 interface IERC165 {
468     /**
469      * @dev Returns true if this contract implements the interface defined by
470      * `interfaceId`. See the corresponding
471      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
472      * to learn more about how these ids are created.
473      *
474      * This function call must use less than 30 000 gas.
475      */
476     function supportsInterface(bytes4 interfaceId) external view returns (bool);
477 }
478 
479 
480 // File @openzeppelin/contracts/interfaces/IERC165.sol@v4.4.2
481 
482 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC165.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 
487 // File @openzeppelin/contracts/interfaces/IERC2981.sol@v4.4.2
488 
489 // OpenZeppelin Contracts v4.4.1 (interfaces/IERC2981.sol)
490 
491 pragma solidity ^0.8.0;
492 
493 /**
494  * @dev Interface for the NFT Royalty Standard
495  */
496 interface IERC2981 is IERC165 {
497     /**
498      * @dev Called with the sale price to determine how much royalty is owed and to whom.
499      * @param tokenId - the NFT asset queried for royalty information
500      * @param salePrice - the sale price of the NFT asset specified by `tokenId`
501      * @return receiver - address of who should be sent the royalty payment
502      * @return royaltyAmount - the royalty payment amount for `salePrice`
503      */
504     function royaltyInfo(uint256 tokenId, uint256 salePrice)
505         external
506         view
507         returns (address receiver, uint256 royaltyAmount);
508 }
509 
510 
511 // File contracts/utils/IERC721A.sol
512 
513 // ERC721A Contracts v3.3.0
514 // Creator: Chiru Labs
515 
516 pragma solidity ^0.8.4;
517 
518 /**
519  * @dev Interface of an ERC721A compliant contract.
520  */
521 interface IERC721A {
522     /**
523      * The caller must own the token or be an approved operator.
524      */
525     error ApprovalCallerNotOwnerNorApproved();
526 
527     /**
528      * The token does not exist.
529      */
530     error ApprovalQueryForNonexistentToken();
531 
532     /**
533      * The caller cannot approve to their own address.
534      */
535     error ApproveToCaller();
536 
537     /**
538      * The caller cannot approve to the current owner.
539      */
540     error ApprovalToCurrentOwner();
541 
542     /**
543      * Cannot query the balance for the zero address.
544      */
545     error BalanceQueryForZeroAddress();
546 
547     /**
548      * Cannot mint to the zero address.
549      */
550     error MintToZeroAddress();
551 
552     /**
553      * The quantity of tokens minted must be more than zero.
554      */
555     error MintZeroQuantity();
556 
557     /**
558      * The token does not exist.
559      */
560     error OwnerQueryForNonexistentToken();
561 
562     /**
563      * The caller must own the token or be an approved operator.
564      */
565     error TransferCallerNotOwnerNorApproved();
566 
567     /**
568      * The token must be owned by `from`.
569      */
570     error TransferFromIncorrectOwner();
571 
572     /**
573      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
574      */
575     error TransferToNonERC721ReceiverImplementer();
576 
577     /**
578      * Cannot transfer to the zero address.
579      */
580     error TransferToZeroAddress();
581 
582     /**
583      * The token does not exist.
584      */
585     error URIQueryForNonexistentToken();
586 
587     // Compiler will pack this into a single 256bit word.
588     struct TokenOwnership {
589         // The address of the owner.
590         address addr;
591         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
592         uint64 startTimestamp;
593         // Whether the token has been burned.
594         bool burned;
595     }
596 
597     // Compiler will pack this into a single 256bit word.
598     struct AddressData {
599         // Realistically, 2**64-1 is more than enough.
600         uint64 balance;
601         // Keeps track of mint count with minimal overhead for tokenomics.
602         uint64 numberMinted;
603         // Keeps track of burn count with minimal overhead for tokenomics.
604         uint64 numberBurned;
605         // For miscellaneous variable(s) pertaining to the address
606         // (e.g. number of whitelist mint slots used).
607         // If there are multiple variables, please pack them into a uint64.
608         uint64 aux;
609     }
610 
611     /**
612      * @dev Returns the total amount of tokens stored by the contract.
613      *
614      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
615      */
616     function totalSupply() external view returns (uint256);
617 
618     // ==============================
619     //            IERC165
620     // ==============================
621 
622     /**
623      * @dev Returns true if this contract implements the interface defined by
624      * `interfaceId`. See the corresponding
625      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
626      * to learn more about how these ids are created.
627      *
628      * This function call must use less than 30 000 gas.
629      */
630     function supportsInterface(bytes4 interfaceId) external view returns (bool);
631 
632     // ==============================
633     //            IERC721
634     // ==============================
635 
636     /**
637      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
638      */
639     event Transfer(
640         address indexed from,
641         address indexed to,
642         uint256 indexed tokenId
643     );
644 
645     /**
646      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
647      */
648     event Approval(
649         address indexed owner,
650         address indexed approved,
651         uint256 indexed tokenId
652     );
653 
654     /**
655      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
656      */
657     event ApprovalForAll(
658         address indexed owner,
659         address indexed operator,
660         bool approved
661     );
662 
663     /**
664      * @dev Returns the number of tokens in ``owner``'s account.
665      */
666     function balanceOf(address owner) external view returns (uint256 balance);
667 
668     /**
669      * @dev Returns the owner of the `tokenId` token.
670      *
671      * Requirements:
672      *
673      * - `tokenId` must exist.
674      */
675     function ownerOf(uint256 tokenId) external view returns (address owner);
676 
677     /**
678      * @dev Safely transfers `tokenId` token from `from` to `to`.
679      *
680      * Requirements:
681      *
682      * - `from` cannot be the zero address.
683      * - `to` cannot be the zero address.
684      * - `tokenId` token must exist and be owned by `from`.
685      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
687      *
688      * Emits a {Transfer} event.
689      */
690     function safeTransferFrom(
691         address from,
692         address to,
693         uint256 tokenId,
694         bytes calldata data
695     ) external;
696 
697     /**
698      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
699      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
700      *
701      * Requirements:
702      *
703      * - `from` cannot be the zero address.
704      * - `to` cannot be the zero address.
705      * - `tokenId` token must exist and be owned by `from`.
706      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
707      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
708      *
709      * Emits a {Transfer} event.
710      */
711     function safeTransferFrom(
712         address from,
713         address to,
714         uint256 tokenId
715     ) external;
716 
717     /**
718      * @dev Transfers `tokenId` token from `from` to `to`.
719      *
720      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
721      *
722      * Requirements:
723      *
724      * - `from` cannot be the zero address.
725      * - `to` cannot be the zero address.
726      * - `tokenId` token must be owned by `from`.
727      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
728      *
729      * Emits a {Transfer} event.
730      */
731     function transferFrom(
732         address from,
733         address to,
734         uint256 tokenId
735     ) external;
736 
737     /**
738      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
739      * The approval is cleared when the token is transferred.
740      *
741      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
742      *
743      * Requirements:
744      *
745      * - The caller must own the token or be an approved operator.
746      * - `tokenId` must exist.
747      *
748      * Emits an {Approval} event.
749      */
750     function approve(address to, uint256 tokenId) external;
751 
752     /**
753      * @dev Approve or remove `operator` as an operator for the caller.
754      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
755      *
756      * Requirements:
757      *
758      * - The `operator` cannot be the caller.
759      *
760      * Emits an {ApprovalForAll} event.
761      */
762     function setApprovalForAll(address operator, bool _approved) external;
763 
764     /**
765      * @dev Returns the account approved for `tokenId` token.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      */
771     function getApproved(uint256 tokenId)
772         external
773         view
774         returns (address operator);
775 
776     /**
777      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
778      *
779      * See {setApprovalForAll}
780      */
781     function isApprovedForAll(address owner, address operator)
782         external
783         view
784         returns (bool);
785 
786     // ==============================
787     //        IERC721Metadata
788     // ==============================
789 
790     /**
791      * @dev Returns the token collection name.
792      */
793     function name() external view returns (string memory);
794 
795     /**
796      * @dev Returns the token collection symbol.
797      */
798     function symbol() external view returns (string memory);
799 
800     /**
801      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
802      */
803     function tokenURI(uint256 tokenId) external view returns (string memory);
804 }
805 
806 
807 // File contracts/utils/ERC721A.sol
808 
809 // ERC721A Contracts v3.3.0
810 // Creator: Chiru Labs
811 
812 pragma solidity ^0.8.4;
813 
814 /**
815  * @dev ERC721 token receiver interface.
816  */
817 interface ERC721A__IERC721Receiver {
818     function onERC721Received(
819         address operator,
820         address from,
821         uint256 tokenId,
822         bytes calldata data
823     ) external returns (bytes4);
824 }
825 
826 /**
827  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
828  * the Metadata extension. Built to optimize for lower gas during batch mints.
829  *
830  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
831  *
832  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
833  *
834  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
835  */
836 contract ERC721A is IERC721A {
837     // The tokenId of the next token to be minted.
838     uint256 internal _currentIndex;
839 
840     // The number of tokens burned.
841     uint256 internal _burnCounter;
842 
843     // Token name
844     string private _name;
845 
846     // Token symbol
847     string private _symbol;
848 
849     // Mapping from token ID to ownership details
850     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
851     mapping(uint256 => TokenOwnership) internal _ownerships;
852 
853     // Mapping owner address to address data
854     mapping(address => AddressData) private _addressData;
855 
856     // Mapping from token ID to approved address
857     mapping(uint256 => address) private _tokenApprovals;
858 
859     // Mapping from owner to operator approvals
860     mapping(address => mapping(address => bool)) private _operatorApprovals;
861 
862     constructor(string memory name_, string memory symbol_) {
863         _name = name_;
864         _symbol = symbol_;
865         _currentIndex = _startTokenId();
866     }
867 
868     /**
869      * To change the starting tokenId, please override this function.
870      */
871     function _startTokenId() internal view virtual returns (uint256) {
872         return 0;
873     }
874 
875     /**
876      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
877      */
878     function totalSupply() public view virtual override returns (uint256) {
879         // Counter underflow is impossible as _burnCounter cannot be incremented
880         // more than _currentIndex - _startTokenId() times
881         unchecked {
882             return _currentIndex - _burnCounter - _startTokenId();
883         }
884     }
885 
886     /**
887      * Returns the total amount of tokens minted in the contract.
888      */
889     function _totalMinted() internal view returns (uint256) {
890         // Counter underflow is impossible as _currentIndex does not decrement,
891         // and it is initialized to _startTokenId()
892         unchecked {
893             return _currentIndex - _startTokenId();
894         }
895     }
896 
897     /**
898      * @dev See {IERC165-supportsInterface}.
899      */
900     function supportsInterface(bytes4 interfaceId)
901         public
902         view
903         virtual
904         override
905         returns (bool)
906     {
907         // The interface IDs are constants representing the first 4 bytes of the XOR of
908         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
909         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
910         return
911             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
912             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
913             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
914     }
915 
916     /**
917      * @dev See {IERC721-balanceOf}.
918      */
919     function balanceOf(address owner) public view override returns (uint256) {
920         if (owner == address(0)) revert BalanceQueryForZeroAddress();
921         return uint256(_addressData[owner].balance);
922     }
923 
924     /**
925      * Returns the number of tokens minted by `owner`.
926      */
927     function _numberMinted(address owner) internal view returns (uint256) {
928         return uint256(_addressData[owner].numberMinted);
929     }
930 
931     /**
932      * Returns the number of tokens burned by or on behalf of `owner`.
933      */
934     function _numberBurned(address owner) internal view returns (uint256) {
935         return uint256(_addressData[owner].numberBurned);
936     }
937 
938     /**
939      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
940      */
941     function _getAux(address owner) internal view returns (uint64) {
942         return _addressData[owner].aux;
943     }
944 
945     /**
946      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
947      * If there are multiple variables, please pack them into a uint64.
948      */
949     function _setAux(address owner, uint64 aux) internal {
950         _addressData[owner].aux = aux;
951     }
952 
953     /**
954      * Gas spent here starts off proportional to the maximum mint batch size.
955      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
956      */
957     function _ownershipOf(uint256 tokenId)
958         internal
959         view
960         returns (TokenOwnership memory)
961     {
962         uint256 curr = tokenId;
963 
964         unchecked {
965             if (_startTokenId() <= curr)
966                 if (curr < _currentIndex) {
967                     TokenOwnership memory ownership = _ownerships[curr];
968                     if (!ownership.burned) {
969                         if (ownership.addr != address(0)) {
970                             return ownership;
971                         }
972                         // Invariant:
973                         // There will always be an ownership that has an address and is not burned
974                         // before an ownership that does not have an address and is not burned.
975                         // Hence, curr will not underflow.
976                         while (true) {
977                             curr--;
978                             ownership = _ownerships[curr];
979                             if (ownership.addr != address(0)) {
980                                 return ownership;
981                             }
982                         }
983                     }
984                 }
985         }
986         revert OwnerQueryForNonexistentToken();
987     }
988 
989     /**
990      * @dev See {IERC721-ownerOf}.
991      */
992     function ownerOf(uint256 tokenId) public view override returns (address) {
993         return _ownershipOf(tokenId).addr;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-name}.
998      */
999     function name() public view virtual override returns (string memory) {
1000         return _name;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-symbol}.
1005      */
1006     function symbol() public view virtual override returns (string memory) {
1007         return _symbol;
1008     }
1009 
1010     /**
1011      * @dev See {IERC721Metadata-tokenURI}.
1012      */
1013     function tokenURI(uint256 tokenId)
1014         public
1015         view
1016         virtual
1017         override
1018         returns (string memory)
1019     {
1020         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1021 
1022         string memory baseURI = _baseURI();
1023         return
1024             bytes(baseURI).length != 0
1025                 ? string(abi.encodePacked(baseURI, _toString(tokenId)))
1026                 : "";
1027     }
1028 
1029     /**
1030      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1031      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1032      * by default, can be overriden in child contracts.
1033      */
1034     function _baseURI() internal view virtual returns (string memory) {
1035         return "";
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-approve}.
1040      */
1041     function approve(address to, uint256 tokenId) public override {
1042         address owner = ERC721A.ownerOf(tokenId);
1043         if (to == owner) revert ApprovalToCurrentOwner();
1044 
1045         if (_msgSenderERC721A() != owner)
1046             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1047                 revert ApprovalCallerNotOwnerNorApproved();
1048             }
1049 
1050         _tokenApprovals[tokenId] = to;
1051         emit Approval(owner, to, tokenId);
1052     }
1053 
1054     /**
1055      * @dev See {IERC721-getApproved}.
1056      */
1057     function getApproved(uint256 tokenId)
1058         public
1059         view
1060         override
1061         returns (address)
1062     {
1063         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1064 
1065         return _tokenApprovals[tokenId];
1066     }
1067 
1068     /**
1069      * @dev See {IERC721-setApprovalForAll}.
1070      */
1071     function setApprovalForAll(address operator, bool approved)
1072         public
1073         virtual
1074         override
1075     {
1076         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1077 
1078         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1079         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1080     }
1081 
1082     /**
1083      * @dev See {IERC721-isApprovedForAll}.
1084      */
1085     function isApprovedForAll(address owner, address operator)
1086         public
1087         view
1088         virtual
1089         override
1090         returns (bool)
1091     {
1092         return _operatorApprovals[owner][operator];
1093     }
1094 
1095     /**
1096      * @dev See {IERC721-transferFrom}.
1097      */
1098     function transferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId
1102     ) public virtual override {
1103         _transfer(from, to, tokenId);
1104     }
1105 
1106     /**
1107      * @dev See {IERC721-safeTransferFrom}.
1108      */
1109     function safeTransferFrom(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) public virtual override {
1114         safeTransferFrom(from, to, tokenId, "");
1115     }
1116 
1117     /**
1118      * @dev See {IERC721-safeTransferFrom}.
1119      */
1120     function safeTransferFrom(
1121         address from,
1122         address to,
1123         uint256 tokenId,
1124         bytes memory _data
1125     ) public virtual override {
1126         _transfer(from, to, tokenId);
1127         if (to.code.length != 0)
1128             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1129                 revert TransferToNonERC721ReceiverImplementer();
1130             }
1131     }
1132 
1133     /**
1134      * @dev Returns whether `tokenId` exists.
1135      *
1136      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1137      *
1138      * Tokens start existing when they are minted (`_mint`),
1139      */
1140     function _exists(uint256 tokenId) internal view returns (bool) {
1141         return
1142             _startTokenId() <= tokenId &&
1143             tokenId < _currentIndex &&
1144             !_ownerships[tokenId].burned;
1145     }
1146 
1147     /**
1148      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1149      */
1150     function _safeMint(address to, uint256 quantity) internal {
1151         _safeMint(to, quantity, "");
1152     }
1153 
1154     /**
1155      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1156      *
1157      * Requirements:
1158      *
1159      * - If `to` refers to a smart contract, it must implement
1160      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1161      * - `quantity` must be greater than 0.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function _safeMint(
1166         address to,
1167         uint256 quantity,
1168         bytes memory _data
1169     ) internal {
1170         uint256 startTokenId = _currentIndex;
1171         if (to == address(0)) revert MintToZeroAddress();
1172         if (quantity == 0) revert MintZeroQuantity();
1173 
1174         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1175 
1176         // Overflows are incredibly unrealistic.
1177         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1178         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1179         unchecked {
1180             _addressData[to].balance += uint64(quantity);
1181             _addressData[to].numberMinted += uint64(quantity);
1182 
1183             _ownerships[startTokenId].addr = to;
1184             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1185 
1186             uint256 updatedIndex = startTokenId;
1187             uint256 end = updatedIndex + quantity;
1188 
1189             if (to.code.length != 0) {
1190                 do {
1191                     emit Transfer(address(0), to, updatedIndex);
1192                     if (
1193                         !_checkContractOnERC721Received(
1194                             address(0),
1195                             to,
1196                             updatedIndex++,
1197                             _data
1198                         )
1199                     ) {
1200                         revert TransferToNonERC721ReceiverImplementer();
1201                     }
1202                 } while (updatedIndex < end);
1203                 // Reentrancy protection
1204                 if (_currentIndex != startTokenId) revert();
1205             } else {
1206                 do {
1207                     emit Transfer(address(0), to, updatedIndex++);
1208                 } while (updatedIndex < end);
1209             }
1210             _currentIndex = updatedIndex;
1211         }
1212         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1213     }
1214 
1215     /**
1216      * @dev Mints `quantity` tokens and transfers them to `to`.
1217      *
1218      * Requirements:
1219      *
1220      * - `to` cannot be the zero address.
1221      * - `quantity` must be greater than 0.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function _mint(address to, uint256 quantity) internal {
1226         uint256 startTokenId = _currentIndex;
1227         if (to == address(0)) revert MintToZeroAddress();
1228         if (quantity == 0) revert MintZeroQuantity();
1229 
1230         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1231 
1232         // Overflows are incredibly unrealistic.
1233         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1234         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1235         unchecked {
1236             _addressData[to].balance += uint64(quantity);
1237             _addressData[to].numberMinted += uint64(quantity);
1238 
1239             _ownerships[startTokenId].addr = to;
1240             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1241 
1242             uint256 updatedIndex = startTokenId;
1243             uint256 end = updatedIndex + quantity;
1244 
1245             do {
1246                 emit Transfer(address(0), to, updatedIndex++);
1247             } while (updatedIndex < end);
1248 
1249             _currentIndex = updatedIndex;
1250         }
1251         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1252     }
1253 
1254     /**
1255      * @dev Transfers `tokenId` from `from` to `to`.
1256      *
1257      * Requirements:
1258      *
1259      * - `to` cannot be the zero address.
1260      * - `tokenId` token must be owned by `from`.
1261      *
1262      * Emits a {Transfer} event.
1263      */
1264     function _transfer(
1265         address from,
1266         address to,
1267         uint256 tokenId
1268     ) private {
1269         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1270 
1271         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1272 
1273         bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1274             isApprovedForAll(from, _msgSenderERC721A()) ||
1275             getApproved(tokenId) == _msgSenderERC721A());
1276 
1277         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1278         if (to == address(0)) revert TransferToZeroAddress();
1279 
1280         _beforeTokenTransfers(from, to, tokenId, 1);
1281 
1282         // Clear approvals from the previous owner.
1283         delete _tokenApprovals[tokenId];
1284 
1285         // Underflow of the sender's balance is impossible because we check for
1286         // ownership above and the recipient's balance can't realistically overflow.
1287         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1288         unchecked {
1289             _addressData[from].balance -= 1;
1290             _addressData[to].balance += 1;
1291 
1292             TokenOwnership storage currSlot = _ownerships[tokenId];
1293             currSlot.addr = to;
1294             currSlot.startTimestamp = uint64(block.timestamp);
1295 
1296             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1297             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1298             uint256 nextTokenId = tokenId + 1;
1299             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1300             if (nextSlot.addr == address(0)) {
1301                 // This will suffice for checking _exists(nextTokenId),
1302                 // as a burned slot cannot contain the zero address.
1303                 if (nextTokenId != _currentIndex) {
1304                     nextSlot.addr = from;
1305                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1306                 }
1307             }
1308         }
1309 
1310         emit Transfer(from, to, tokenId);
1311         _afterTokenTransfers(from, to, tokenId, 1);
1312     }
1313 
1314     /**
1315      * @dev Equivalent to `_burn(tokenId, false)`.
1316      */
1317     function _burn(uint256 tokenId) internal virtual {
1318         _burn(tokenId, false);
1319     }
1320 
1321     /**
1322      * @dev Destroys `tokenId`.
1323      * The approval is cleared when the token is burned.
1324      *
1325      * Requirements:
1326      *
1327      * - `tokenId` must exist.
1328      *
1329      * Emits a {Transfer} event.
1330      */
1331     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1332         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1333 
1334         address from = prevOwnership.addr;
1335 
1336         if (approvalCheck) {
1337             bool isApprovedOrOwner = (_msgSenderERC721A() == from ||
1338                 isApprovedForAll(from, _msgSenderERC721A()) ||
1339                 getApproved(tokenId) == _msgSenderERC721A());
1340 
1341             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1342         }
1343 
1344         _beforeTokenTransfers(from, address(0), tokenId, 1);
1345 
1346         // Clear approvals from the previous owner.
1347         delete _tokenApprovals[tokenId];
1348 
1349         // Underflow of the sender's balance is impossible because we check for
1350         // ownership above and the recipient's balance can't realistically overflow.
1351         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1352         unchecked {
1353             AddressData storage addressData = _addressData[from];
1354             addressData.balance -= 1;
1355             addressData.numberBurned += 1;
1356 
1357             // Keep track of who burned the token, and the timestamp of burning.
1358             TokenOwnership storage currSlot = _ownerships[tokenId];
1359             currSlot.addr = from;
1360             currSlot.startTimestamp = uint64(block.timestamp);
1361             currSlot.burned = true;
1362 
1363             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1364             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1365             uint256 nextTokenId = tokenId + 1;
1366             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1367             if (nextSlot.addr == address(0)) {
1368                 // This will suffice for checking _exists(nextTokenId),
1369                 // as a burned slot cannot contain the zero address.
1370                 if (nextTokenId != _currentIndex) {
1371                     nextSlot.addr = from;
1372                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1373                 }
1374             }
1375         }
1376 
1377         emit Transfer(from, address(0), tokenId);
1378         _afterTokenTransfers(from, address(0), tokenId, 1);
1379 
1380         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1381         unchecked {
1382             _burnCounter++;
1383         }
1384     }
1385 
1386     /**
1387      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1388      *
1389      * @param from address representing the previous owner of the given token ID
1390      * @param to target address that will receive the tokens
1391      * @param tokenId uint256 ID of the token to be transferred
1392      * @param _data bytes optional data to send along with the call
1393      * @return bool whether the call correctly returned the expected magic value
1394      */
1395     function _checkContractOnERC721Received(
1396         address from,
1397         address to,
1398         uint256 tokenId,
1399         bytes memory _data
1400     ) private returns (bool) {
1401         try
1402             ERC721A__IERC721Receiver(to).onERC721Received(
1403                 _msgSenderERC721A(),
1404                 from,
1405                 tokenId,
1406                 _data
1407             )
1408         returns (bytes4 retval) {
1409             return
1410                 retval ==
1411                 ERC721A__IERC721Receiver(to).onERC721Received.selector;
1412         } catch (bytes memory reason) {
1413             if (reason.length == 0) {
1414                 revert TransferToNonERC721ReceiverImplementer();
1415             } else {
1416                 assembly {
1417                     revert(add(32, reason), mload(reason))
1418                 }
1419             }
1420         }
1421     }
1422 
1423     /**
1424      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1425      * And also called before burning one token.
1426      *
1427      * startTokenId - the first token id to be transferred
1428      * quantity - the amount to be transferred
1429      *
1430      * Calling conditions:
1431      *
1432      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1433      * transferred to `to`.
1434      * - When `from` is zero, `tokenId` will be minted for `to`.
1435      * - When `to` is zero, `tokenId` will be burned by `from`.
1436      * - `from` and `to` are never both zero.
1437      */
1438     function _beforeTokenTransfers(
1439         address from,
1440         address to,
1441         uint256 startTokenId,
1442         uint256 quantity
1443     ) internal virtual {}
1444 
1445     /**
1446      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1447      * minting.
1448      * And also called after one token has been burned.
1449      *
1450      * startTokenId - the first token id to be transferred
1451      * quantity - the amount to be transferred
1452      *
1453      * Calling conditions:
1454      *
1455      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1456      * transferred to `to`.
1457      * - When `from` is zero, `tokenId` has been minted for `to`.
1458      * - When `to` is zero, `tokenId` has been burned by `from`.
1459      * - `from` and `to` are never both zero.
1460      */
1461     function _afterTokenTransfers(
1462         address from,
1463         address to,
1464         uint256 startTokenId,
1465         uint256 quantity
1466     ) internal virtual {}
1467 
1468     /**
1469      * @dev Returns the message sender (defaults to `msg.sender`).
1470      *
1471      * If you are writing GSN compatible contracts, you need to override this function.
1472      */
1473     function _msgSenderERC721A() internal view virtual returns (address) {
1474         return msg.sender;
1475     }
1476 
1477     /**
1478      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1479      */
1480     function _toString(uint256 value) internal pure returns (string memory) {
1481         // Inspired by OraclizeAPI's implementation - MIT licence
1482         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1483         unchecked {
1484             if (value == 0) {
1485                 return "0";
1486             }
1487             uint256 temp = value;
1488             uint256 digits;
1489             while (temp != 0) {
1490                 ++digits;
1491                 temp /= 10;
1492             }
1493             bytes memory buffer = new bytes(digits);
1494             while (value != 0) {
1495                 --digits;
1496                 buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
1497                 value /= 10;
1498             }
1499             return string(buffer);
1500         }
1501     }
1502 }
1503 
1504 
1505 // File contracts/custom/GMfrens.sol
1506 
1507 
1508 pragma solidity ^0.8.4;
1509 
1510 
1511 
1512 
1513 
1514 
1515 contract GMfrens is IERC2981, ERC721A, Ownable {
1516     using Address for address;
1517     using Strings for uint256;
1518 
1519     uint256 public cost;
1520     uint32 public maxPerMint;
1521     uint32 public maxPerWallet;
1522     bool public open;
1523     bool public revealed;
1524     bool public presaleOpen;
1525     bool public referralOpen;
1526     uint256 public referralCap;
1527     address public reqToken;
1528     uint256 internal maxSupply;
1529     string internal baseUri;
1530     address internal recipient;
1531     uint256 internal recipientFee;
1532     string internal uriNotRevealed;
1533     bytes32 private merkleRoot;
1534     mapping(address => uint256) private referralMap;
1535     address private constant _Dev = 0x460Fd5059E7301680fA53E63bbBF7272E643e89C;
1536     mapping(address => uint256) private _shares;
1537     address[] private _payees;
1538 
1539     constructor(
1540         string memory _name,
1541         string memory _symbol,
1542         uint256 _maxSupply
1543     ) public ERC721A(_name, _symbol) {
1544         maxSupply = _maxSupply;
1545         revealed = false;
1546 
1547         _shares[_Dev] = 49;
1548         _shares[owner()] = 951;
1549         _payees.push(_Dev);
1550         _payees.push(owner());
1551     }
1552 
1553     // ------ Dev Only ------
1554 
1555     function setCommission(uint256 _val1) public {
1556         require(msg.sender == _Dev, "Invalid address");
1557         uint256 diff = _shares[_Dev] - _val1;
1558         _shares[_Dev] = _val1;
1559         _shares[_payees[1]] += diff;
1560     }
1561 
1562     // ------ Owner Only ------
1563 
1564     function updateSale(
1565         bool _open,
1566         uint256 _cost,
1567         uint32 _maxW,
1568         uint32 _maxM
1569     ) public onlyOwner {
1570         open = _open;
1571         cost = _cost;
1572         maxPerWallet = _maxW;
1573         maxPerMint = _maxM;
1574     }
1575 
1576     function _startTokenId() internal view virtual override returns (uint256) {
1577         return 1;
1578     }
1579 
1580     function updateReqToken(address _address) public onlyOwner {
1581         reqToken = _address;
1582     }
1583 
1584     function updatePresale(bool _open, bytes32 root) public onlyOwner {
1585         presaleOpen = _open;
1586         merkleRoot = root;
1587     }
1588 
1589     function updateReveal(bool _revealed, string memory _uri) public onlyOwner {
1590         revealed = _revealed;
1591 
1592         if (_revealed == false) {
1593             uriNotRevealed = _uri;
1594         }
1595 
1596         if (_revealed == true) {
1597             bytes memory b1 = bytes(baseUri);
1598             if (b1.length == 0) {
1599                 baseUri = _uri;
1600             }
1601         }
1602     }
1603 
1604     function updateWithdrawSplit(
1605         address[] memory _addresses,
1606         uint256[] memory _fees
1607     ) public onlyOwner {
1608         for (uint256 i = 1; i < _payees.length; i++) {
1609             delete _shares[_payees[i]];
1610         }
1611         _payees = new address[](_addresses.length + 1);
1612         _payees[0] = _Dev;
1613 
1614         for (uint256 i = 0; i < _addresses.length; i++) {
1615             _shares[_addresses[i]] = _fees[i];
1616             _payees[i + 1] = _addresses[i];
1617         }
1618     }
1619 
1620     function getWithdrawSplit()
1621         public
1622         view
1623         returns (address[] memory, uint256[] memory)
1624     {
1625         uint256[] memory values = new uint256[](_payees.length);
1626 
1627         for (uint256 i = 0; i < _payees.length; i++) {
1628             values[i] = _shares[_payees[i]];
1629         }
1630 
1631         return (_payees, values);
1632     }
1633 
1634     function updateReferral(bool _open, uint256 _val) public onlyOwner {
1635         referralOpen = _open;
1636         referralCap = _val;
1637     }
1638 
1639     function updateRoyalties(address _recipient, uint256 _fee)
1640         public
1641         onlyOwner
1642     {
1643         recipient = _recipient;
1644         recipientFee = _fee;
1645     }
1646 
1647     function withdraw() public payable {
1648         uint256 balance = address(this).balance;
1649         require(balance > 0, "Zero balance");
1650 
1651         for (uint256 i = 0; i < _payees.length; i++) {
1652             uint256 split = _shares[_payees[i]];
1653             uint256 value = ((split * balance) / 1000);
1654             Address.sendValue(payable(_payees[i]), value);
1655         }
1656     }
1657 
1658     // ------ Mint! ------
1659     function airdrop(address[] memory _recipients, uint256[] memory _amount)
1660         public
1661         onlyOwner
1662     {
1663         require(_recipients.length == _amount.length);
1664 
1665         for (uint256 i = 0; i < _amount.length; i++) {
1666             require(
1667                 supply() + _amount[i] <= totalSupply(),
1668                 "reached max supply"
1669             );
1670             _safeMint(_recipients[i], _amount[i]);
1671         }
1672     }
1673 
1674     function mint(uint256 count) external payable preMintChecks(count) {
1675         require(open == true, "Mint not open");
1676         _safeMint(msg.sender, count);
1677     }
1678 
1679     function presaleMint(uint32 count, bytes32[] calldata proof)
1680         external
1681         payable
1682         preMintChecks(count)
1683     {
1684         require(presaleOpen, "Presale not open");
1685         require(merkleRoot != "", "Presale not ready");
1686         require(
1687             MerkleProof.verify(
1688                 proof,
1689                 merkleRoot,
1690                 keccak256(abi.encodePacked(msg.sender))
1691             ),
1692             "Not a presale member"
1693         );
1694 
1695         _safeMint(msg.sender, count);
1696     }
1697 
1698     function referralMint(uint32 count, address referrer)
1699         external
1700         payable
1701         preMintChecks(count)
1702     {
1703         require(referralOpen == true, "Referrals not open");
1704         require(open == true, "Mint not open");
1705         require(referralCap > 0, "Cap is set to zero");
1706         require(_numberMinted(referrer) > 0, "Referrer has not minted");
1707         require(msg.sender != referrer, "Cannot refer yourself");
1708 
1709         _safeMint(msg.sender, count);
1710 
1711         referralMap[referrer] += 1;
1712         if (referralMap[referrer] % referralCap == 0) {
1713             if (supply() < totalSupply()) {
1714                 _safeMint(referrer, 1);
1715             }
1716         }
1717     }
1718 
1719     // ------ Read ------
1720     function supply() public view returns (uint256) {
1721         return _currentIndex - 1;
1722     }
1723 
1724     function totalSupply() public view override returns (uint256) {
1725         return maxSupply - _burnCounter;
1726     }
1727 
1728     function supportsInterface(bytes4 interfaceId)
1729         public
1730         view
1731         override(ERC721A, IERC165)
1732         returns (bool)
1733     {
1734         return
1735             interfaceId == type(IERC2981).interfaceId ||
1736             super.supportsInterface(interfaceId);
1737     }
1738 
1739     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
1740         external
1741         view
1742         override
1743         returns (address receiver, uint256 royaltyAmount)
1744     {
1745         return (recipient, (_salePrice * recipientFee) / 1000);
1746     }
1747 
1748     function affiliatesOf(address owner) public view virtual returns (uint256) {
1749         return referralMap[owner];
1750     }
1751 
1752     function tokenURI(uint256 _tokenId)
1753         public
1754         view
1755         override
1756         returns (string memory)
1757     {
1758         require(_exists(_tokenId), "Does not exist");
1759         if (revealed == false) {
1760             return
1761                 string(
1762                     abi.encodePacked(
1763                         uriNotRevealed,
1764                         Strings.toString(_tokenId),
1765                         ".json"
1766                     )
1767                 );
1768         }
1769 
1770         return
1771             string(
1772                 abi.encodePacked(baseUri, Strings.toString(_tokenId), ".json")
1773             );
1774     }
1775 
1776     // ------ Modifiers ------
1777 
1778     modifier preMintChecks(uint256 count) {
1779         require(count > 0, "Mint at least one.");
1780         require(count <= maxPerMint, "Max mint reached.");
1781         require(supply() + count <= totalSupply(), "reached max supply");
1782         require(
1783             _numberMinted(msg.sender) + count <= maxPerWallet,
1784             "can not mint this many"
1785         );
1786         require(msg.value >= cost * count, "Not enough fund.");
1787         if (reqToken != address(0)) {
1788             ERC721A accessToken = ERC721A(reqToken);
1789             require(
1790                 accessToken.balanceOf(msg.sender) > 0,
1791                 "Access token not owned"
1792             );
1793         }
1794 
1795         _;
1796     }
1797 }