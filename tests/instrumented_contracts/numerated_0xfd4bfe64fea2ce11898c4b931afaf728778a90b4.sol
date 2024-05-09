1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = _efficientHash(computedHash, proofElement);
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = _efficientHash(proofElement, computedHash);
51             }
52         }
53         return computedHash;
54     }
55 
56     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
57         assembly {
58             mstore(0x00, a)
59             mstore(0x20, b)
60             value := keccak256(0x00, 0x40)
61         }
62     }
63 }
64 
65 // File: @openzeppelin/contracts/utils/Strings.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev String operations.
74  */
75 library Strings {
76     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
80      */
81     function toString(uint256 value) internal pure returns (string memory) {
82         // Inspired by OraclizeAPI's implementation - MIT licence
83         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
84 
85         if (value == 0) {
86             return "0";
87         }
88         uint256 temp = value;
89         uint256 digits;
90         while (temp != 0) {
91             digits++;
92             temp /= 10;
93         }
94         bytes memory buffer = new bytes(digits);
95         while (value != 0) {
96             digits -= 1;
97             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
98             value /= 10;
99         }
100         return string(buffer);
101     }
102 
103     /**
104      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
105      */
106     function toHexString(uint256 value) internal pure returns (string memory) {
107         if (value == 0) {
108             return "0x00";
109         }
110         uint256 temp = value;
111         uint256 length = 0;
112         while (temp != 0) {
113             length++;
114             temp >>= 8;
115         }
116         return toHexString(value, length);
117     }
118 
119     /**
120      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
121      */
122     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
123         bytes memory buffer = new bytes(2 * length + 2);
124         buffer[0] = "0";
125         buffer[1] = "x";
126         for (uint256 i = 2 * length + 1; i > 1; --i) {
127             buffer[i] = _HEX_SYMBOLS[value & 0xf];
128             value >>= 4;
129         }
130         require(value == 0, "Strings: hex length insufficient");
131         return string(buffer);
132     }
133 }
134 
135 // File: @openzeppelin/contracts/utils/Context.sol
136 
137 
138 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
139 
140 pragma solidity ^0.8.0;
141 
142 /**
143  * @dev Provides information about the current execution context, including the
144  * sender of the transaction and its data. While these are generally available
145  * via msg.sender and msg.data, they should not be accessed in such a direct
146  * manner, since when dealing with meta-transactions the account sending and
147  * paying for execution may not be the actual sender (as far as an application
148  * is concerned).
149  *
150  * This contract is only required for intermediate, library-like contracts.
151  */
152 abstract contract Context {
153     function _msgSender() internal view virtual returns (address) {
154         return msg.sender;
155     }
156 
157     function _msgData() internal view virtual returns (bytes calldata) {
158         return msg.data;
159     }
160 }
161 
162 // File: @openzeppelin/contracts/access/Ownable.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 
170 /**
171  * @dev Contract module which provides a basic access control mechanism, where
172  * there is an account (an owner) that can be granted exclusive access to
173  * specific functions.
174  *
175  * By default, the owner account will be the one that deploys the contract. This
176  * can later be changed with {transferOwnership}.
177  *
178  * This module is used through inheritance. It will make available the modifier
179  * `onlyOwner`, which can be applied to your functions to restrict their use to
180  * the owner.
181  */
182 abstract contract Ownable is Context {
183     address private _owner;
184 
185     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
186 
187     /**
188      * @dev Initializes the contract setting the deployer as the initial owner.
189      */
190     constructor() {
191         _transferOwnership(_msgSender());
192     }
193 
194     /**
195      * @dev Returns the address of the current owner.
196      */
197     function owner() public view virtual returns (address) {
198         return _owner;
199     }
200 
201     /**
202      * @dev Throws if called by any account other than the owner.
203      */
204     modifier onlyOwner() {
205         require(owner() == _msgSender(), "Ownable: caller is not the owner");
206         _;
207     }
208 
209     /**
210      * @dev Leaves the contract without owner. It will not be possible to call
211      * `onlyOwner` functions anymore. Can only be called by the current owner.
212      *
213      * NOTE: Renouncing ownership will leave the contract without an owner,
214      * thereby removing any functionality that is only available to the owner.
215      */
216     function renounceOwnership() public virtual onlyOwner {
217         _transferOwnership(address(0));
218     }
219 
220     /**
221      * @dev Transfers ownership of the contract to a new account (`newOwner`).
222      * Can only be called by the current owner.
223      */
224     function transferOwnership(address newOwner) public virtual onlyOwner {
225         require(newOwner != address(0), "Ownable: new owner is the zero address");
226         _transferOwnership(newOwner);
227     }
228 
229     /**
230      * @dev Transfers ownership of the contract to a new account (`newOwner`).
231      * Internal function without access restriction.
232      */
233     function _transferOwnership(address newOwner) internal virtual {
234         address oldOwner = _owner;
235         _owner = newOwner;
236         emit OwnershipTransferred(oldOwner, newOwner);
237     }
238 }
239 
240 // File: @openzeppelin/contracts/utils/Address.sol
241 
242 
243 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
244 
245 pragma solidity ^0.8.1;
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      *
268      * [IMPORTANT]
269      * ====
270      * You shouldn't rely on `isContract` to protect against flash loan attacks!
271      *
272      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
273      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
274      * constructor.
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // This method relies on extcodesize/address.code.length, which returns 0
279         // for contracts in construction, since the code is only stored at the end
280         // of the constructor execution.
281 
282         return account.code.length > 0;
283     }
284 
285     /**
286      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
287      * `recipient`, forwarding all available gas and reverting on errors.
288      *
289      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
290      * of certain opcodes, possibly making contracts go over the 2300 gas limit
291      * imposed by `transfer`, making them unable to receive funds via
292      * `transfer`. {sendValue} removes this limitation.
293      *
294      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
295      *
296      * IMPORTANT: because control is transferred to `recipient`, care must be
297      * taken to not create reentrancy vulnerabilities. Consider using
298      * {ReentrancyGuard} or the
299      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         (bool success, ) = recipient.call{value: amount}("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain `call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         return functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(
356         address target,
357         bytes memory data,
358         uint256 value
359     ) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(
370         address target,
371         bytes memory data,
372         uint256 value,
373         string memory errorMessage
374     ) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         require(isContract(target), "Address: call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.call{value: value}(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
384      * but performing a static call.
385      *
386      * _Available since v3.3._
387      */
388     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
389         return functionStaticCall(target, data, "Address: low-level static call failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
394      * but performing a static call.
395      *
396      * _Available since v3.3._
397      */
398     function functionStaticCall(
399         address target,
400         bytes memory data,
401         string memory errorMessage
402     ) internal view returns (bytes memory) {
403         require(isContract(target), "Address: static call to non-contract");
404 
405         (bool success, bytes memory returndata) = target.staticcall(data);
406         return verifyCallResult(success, returndata, errorMessage);
407     }
408 
409     /**
410      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
411      * but performing a delegate call.
412      *
413      * _Available since v3.4._
414      */
415     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
416         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
417     }
418 
419     /**
420      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
421      * but performing a delegate call.
422      *
423      * _Available since v3.4._
424      */
425     function functionDelegateCall(
426         address target,
427         bytes memory data,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(isContract(target), "Address: delegate call to non-contract");
431 
432         (bool success, bytes memory returndata) = target.delegatecall(data);
433         return verifyCallResult(success, returndata, errorMessage);
434     }
435 
436     /**
437      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
438      * revert reason using the provided one.
439      *
440      * _Available since v4.3._
441      */
442     function verifyCallResult(
443         bool success,
444         bytes memory returndata,
445         string memory errorMessage
446     ) internal pure returns (bytes memory) {
447         if (success) {
448             return returndata;
449         } else {
450             // Look for revert reason and bubble it up if present
451             if (returndata.length > 0) {
452                 // The easiest way to bubble the revert reason is using memory via assembly
453 
454                 assembly {
455                     let returndata_size := mload(returndata)
456                     revert(add(32, returndata), returndata_size)
457                 }
458             } else {
459                 revert(errorMessage);
460             }
461         }
462     }
463 }
464 
465 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
466 
467 
468 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
469 
470 pragma solidity ^0.8.0;
471 
472 /**
473  * @title ERC721 token receiver interface
474  * @dev Interface for any contract that wants to support safeTransfers
475  * from ERC721 asset contracts.
476  */
477 interface IERC721Receiver {
478     /**
479      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
480      * by `operator` from `from`, this function is called.
481      *
482      * It must return its Solidity selector to confirm the token transfer.
483      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
484      *
485      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
486      */
487     function onERC721Received(
488         address operator,
489         address from,
490         uint256 tokenId,
491         bytes calldata data
492     ) external returns (bytes4);
493 }
494 
495 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
496 
497 
498 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
499 
500 pragma solidity ^0.8.0;
501 
502 /**
503  * @dev Interface of the ERC165 standard, as defined in the
504  * https://eips.ethereum.org/EIPS/eip-165[EIP].
505  *
506  * Implementers can declare support of contract interfaces, which can then be
507  * queried by others ({ERC165Checker}).
508  *
509  * For an implementation, see {ERC165}.
510  */
511 interface IERC165 {
512     /**
513      * @dev Returns true if this contract implements the interface defined by
514      * `interfaceId`. See the corresponding
515      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
516      * to learn more about how these ids are created.
517      *
518      * This function call must use less than 30 000 gas.
519      */
520     function supportsInterface(bytes4 interfaceId) external view returns (bool);
521 }
522 
523 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
524 
525 
526 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 
531 /**
532  * @dev Implementation of the {IERC165} interface.
533  *
534  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
535  * for the additional interface id that will be supported. For example:
536  *
537  * ```solidity
538  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
539  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
540  * }
541  * ```
542  *
543  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
544  */
545 abstract contract ERC165 is IERC165 {
546     /**
547      * @dev See {IERC165-supportsInterface}.
548      */
549     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
550         return interfaceId == type(IERC165).interfaceId;
551     }
552 }
553 
554 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
555 
556 
557 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
558 
559 pragma solidity ^0.8.0;
560 
561 
562 /**
563  * @dev Required interface of an ERC721 compliant contract.
564  */
565 interface IERC721 is IERC165 {
566     /**
567      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
568      */
569     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
570 
571     /**
572      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
573      */
574     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
578      */
579     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
580 
581     /**
582      * @dev Returns the number of tokens in ``owner``'s account.
583      */
584     function balanceOf(address owner) external view returns (uint256 balance);
585 
586     /**
587      * @dev Returns the owner of the `tokenId` token.
588      *
589      * Requirements:
590      *
591      * - `tokenId` must exist.
592      */
593     function ownerOf(uint256 tokenId) external view returns (address owner);
594 
595     /**
596      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
597      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
598      *
599      * Requirements:
600      *
601      * - `from` cannot be the zero address.
602      * - `to` cannot be the zero address.
603      * - `tokenId` token must exist and be owned by `from`.
604      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
605      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
606      *
607      * Emits a {Transfer} event.
608      */
609     function safeTransferFrom(
610         address from,
611         address to,
612         uint256 tokenId
613     ) external;
614 
615     /**
616      * @dev Transfers `tokenId` token from `from` to `to`.
617      *
618      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
619      *
620      * Requirements:
621      *
622      * - `from` cannot be the zero address.
623      * - `to` cannot be the zero address.
624      * - `tokenId` token must be owned by `from`.
625      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
626      *
627      * Emits a {Transfer} event.
628      */
629     function transferFrom(
630         address from,
631         address to,
632         uint256 tokenId
633     ) external;
634 
635     /**
636      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
637      * The approval is cleared when the token is transferred.
638      *
639      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
640      *
641      * Requirements:
642      *
643      * - The caller must own the token or be an approved operator.
644      * - `tokenId` must exist.
645      *
646      * Emits an {Approval} event.
647      */
648     function approve(address to, uint256 tokenId) external;
649 
650     /**
651      * @dev Returns the account approved for `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function getApproved(uint256 tokenId) external view returns (address operator);
658 
659     /**
660      * @dev Approve or remove `operator` as an operator for the caller.
661      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
662      *
663      * Requirements:
664      *
665      * - The `operator` cannot be the caller.
666      *
667      * Emits an {ApprovalForAll} event.
668      */
669     function setApprovalForAll(address operator, bool _approved) external;
670 
671     /**
672      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
673      *
674      * See {setApprovalForAll}
675      */
676     function isApprovedForAll(address owner, address operator) external view returns (bool);
677 
678     /**
679      * @dev Safely transfers `tokenId` token from `from` to `to`.
680      *
681      * Requirements:
682      *
683      * - `from` cannot be the zero address.
684      * - `to` cannot be the zero address.
685      * - `tokenId` token must exist and be owned by `from`.
686      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
687      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
688      *
689      * Emits a {Transfer} event.
690      */
691     function safeTransferFrom(
692         address from,
693         address to,
694         uint256 tokenId,
695         bytes calldata data
696     ) external;
697 }
698 
699 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 
707 /**
708  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
709  * @dev See https://eips.ethereum.org/EIPS/eip-721
710  */
711 interface IERC721Metadata is IERC721 {
712     /**
713      * @dev Returns the token collection name.
714      */
715     function name() external view returns (string memory);
716 
717     /**
718      * @dev Returns the token collection symbol.
719      */
720     function symbol() external view returns (string memory);
721 
722     /**
723      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
724      */
725     function tokenURI(uint256 tokenId) external view returns (string memory);
726 }
727 
728 // File: contracts/SoulSplicers.sol
729 
730 
731 // Creator: Chiru Labs
732 
733 pragma solidity ^0.8.4;
734 
735 
736 
737 
738 
739 
740 
741 
742 
743 
744 error ApprovalCallerNotOwnerNorApproved();
745 error ApprovalQueryForNonexistentToken();
746 error ApproveToCaller();
747 error ApprovalToCurrentOwner();
748 error BalanceQueryForZeroAddress();
749 error MintToZeroAddress();
750 error MintZeroQuantity();
751 error OwnerQueryForNonexistentToken();
752 error TransferCallerNotOwnerNorApproved();
753 error TransferFromIncorrectOwner();
754 error TransferToNonERC721ReceiverImplementer();
755 error TransferToZeroAddress();
756 error URIQueryForNonexistentToken();
757 
758 /**
759  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
760  * the Metadata extension. Built to optimize for lower gas during batch mints.
761  *
762  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
763  *
764  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
765  *
766  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
767  */
768 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
769     using Address for address;
770     using Strings for uint256;
771 
772     // Compiler will pack this into a single 256bit word.
773     struct TokenOwnership {
774         // The address of the owner.
775         address addr;
776         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
777         uint64 startTimestamp;
778         // Whether the token has been burned.
779         bool burned;
780     }
781 
782     // Compiler will pack this into a single 256bit word.
783     struct AddressData {
784         // Realistically, 2**64-1 is more than enough.
785         uint64 balance;
786         // Keeps track of mint count with minimal overhead for tokenomics.
787         uint64 numberMinted;
788         // Keeps track of burn count with minimal overhead for tokenomics.
789         uint64 numberBurned;
790         // For miscellaneous variable(s) pertaining to the address
791         // (e.g. number of whitelist mint slots used).
792         // If there are multiple variables, please pack them into a uint64.
793         uint64 aux;
794     }
795 
796     // The tokenId of the next token to be minted.
797     uint256 internal _currentIndex;
798 
799     // The number of tokens burned.
800     uint256 internal _burnCounter;
801 
802     // Token name
803     string private _name;
804 
805     // Token symbol
806     string private _symbol;
807 
808     // Mapping from token ID to ownership details
809     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
810     mapping(uint256 => TokenOwnership) internal _ownerships;
811 
812     // Mapping owner address to address data
813     mapping(address => AddressData) private _addressData;
814 
815     // Mapping from token ID to approved address
816     mapping(uint256 => address) private _tokenApprovals;
817 
818     // Mapping from owner to operator approvals
819     mapping(address => mapping(address => bool)) private _operatorApprovals;
820 
821     constructor(string memory name_, string memory symbol_) {
822         _name = name_;
823         _symbol = symbol_;
824         _currentIndex = _startTokenId();
825     }
826 
827     /**
828      * To change the starting tokenId, please override this function.
829      */
830     function _startTokenId() internal view virtual returns (uint256) {
831         return 0;
832     }
833 
834     /**
835      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
836      */
837     function totalSupply() public view returns (uint256) {
838         // Counter underflow is impossible as _burnCounter cannot be incremented
839         // more than _currentIndex - _startTokenId() times
840         unchecked {
841             return _currentIndex - _burnCounter - _startTokenId();
842         }
843     }
844 
845     /**
846      * Returns the total amount of tokens minted in the contract.
847      */
848     function _totalMinted() internal view returns (uint256) {
849         // Counter underflow is impossible as _currentIndex does not decrement,
850         // and it is initialized to _startTokenId()
851         unchecked {
852             return _currentIndex - _startTokenId();
853         }
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
869     function balanceOf(address owner) public view override returns (uint256) {
870         if (owner == address(0)) revert BalanceQueryForZeroAddress();
871         return uint256(_addressData[owner].balance);
872     }
873 
874     /**
875      * Returns the number of tokens minted by `owner`.
876      */
877     function _numberMinted(address owner) internal view returns (uint256) {
878         return uint256(_addressData[owner].numberMinted);
879     }
880 
881     /**
882      * Returns the number of tokens burned by or on behalf of `owner`.
883      */
884     function _numberBurned(address owner) internal view returns (uint256) {
885         return uint256(_addressData[owner].numberBurned);
886     }
887 
888     /**
889      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
890      */
891     function _getAux(address owner) internal view returns (uint64) {
892         return _addressData[owner].aux;
893     }
894 
895     /**
896      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
897      * If there are multiple variables, please pack them into a uint64.
898      */
899     function _setAux(address owner, uint64 aux) internal {
900         _addressData[owner].aux = aux;
901     }
902 
903     /**
904      * Gas spent here starts off proportional to the maximum mint batch size.
905      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
906      */
907     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
908         uint256 curr = tokenId;
909 
910         unchecked {
911             if (_startTokenId() <= curr && curr < _currentIndex) {
912                 TokenOwnership memory ownership = _ownerships[curr];
913                 if (!ownership.burned) {
914                     if (ownership.addr != address(0)) {
915                         return ownership;
916                     }
917                     // Invariant:
918                     // There will always be an ownership that has an address and is not burned
919                     // before an ownership that does not have an address and is not burned.
920                     // Hence, curr will not underflow.
921                     while (true) {
922                         curr--;
923                         ownership = _ownerships[curr];
924                         if (ownership.addr != address(0)) {
925                             return ownership;
926                         }
927                     }
928                 }
929             }
930         }
931         revert OwnerQueryForNonexistentToken();
932     }
933 
934     /**
935      * @dev See {IERC721-ownerOf}.
936      */
937     function ownerOf(uint256 tokenId) public view override returns (address) {
938         return _ownershipOf(tokenId).addr;
939     }
940 
941     /**
942      * @dev See {IERC721Metadata-name}.
943      */
944     function name() public view virtual override returns (string memory) {
945         return _name;
946     }
947 
948     /**
949      * @dev See {IERC721Metadata-symbol}.
950      */
951     function symbol() public view virtual override returns (string memory) {
952         return _symbol;
953     }
954 
955     /**
956      * @dev See {IERC721Metadata-tokenURI}.
957      */
958     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
959         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
960 
961         string memory baseURI = _baseURI();
962         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
963     }
964 
965     /**
966      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
967      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
968      * by default, can be overriden in child contracts.
969      */
970     function _baseURI() internal view virtual returns (string memory) {
971         return '';
972     }
973 
974     /**
975      * @dev See {IERC721-approve}.
976      */
977     function approve(address to, uint256 tokenId) public override {
978         address owner = ERC721A.ownerOf(tokenId);
979         if (to == owner) revert ApprovalToCurrentOwner();
980 
981         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
982             revert ApprovalCallerNotOwnerNorApproved();
983         }
984 
985         _approve(to, tokenId, owner);
986     }
987 
988     /**
989      * @dev See {IERC721-getApproved}.
990      */
991     function getApproved(uint256 tokenId) public view override returns (address) {
992         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
993 
994         return _tokenApprovals[tokenId];
995     }
996 
997     /**
998      * @dev See {IERC721-setApprovalForAll}.
999      */
1000     function setApprovalForAll(address operator, bool approved) public virtual override {
1001         if (operator == _msgSender()) revert ApproveToCaller();
1002 
1003         _operatorApprovals[_msgSender()][operator] = approved;
1004         emit ApprovalForAll(_msgSender(), operator, approved);
1005     }
1006 
1007     /**
1008      * @dev See {IERC721-isApprovedForAll}.
1009      */
1010     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1011         return _operatorApprovals[owner][operator];
1012     }
1013 
1014     /**
1015      * @dev See {IERC721-transferFrom}.
1016      */
1017     function transferFrom(
1018         address from,
1019         address to,
1020         uint256 tokenId
1021     ) public virtual override {
1022         _transfer(from, to, tokenId);
1023     }
1024 
1025     /**
1026      * @dev See {IERC721-safeTransferFrom}.
1027      */
1028     function safeTransferFrom(
1029         address from,
1030         address to,
1031         uint256 tokenId
1032     ) public virtual override {
1033         safeTransferFrom(from, to, tokenId, '');
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-safeTransferFrom}.
1038      */
1039     function safeTransferFrom(
1040         address from,
1041         address to,
1042         uint256 tokenId,
1043         bytes memory _data
1044     ) public virtual override {
1045         _transfer(from, to, tokenId);
1046         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1047             revert TransferToNonERC721ReceiverImplementer();
1048         }
1049     }
1050 
1051     /**
1052      * @dev Returns whether `tokenId` exists.
1053      *
1054      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1055      *
1056      * Tokens start existing when they are minted (`_mint`),
1057      */
1058     function _exists(uint256 tokenId) internal view returns (bool) {
1059         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1060             !_ownerships[tokenId].burned;
1061     }
1062 
1063     function _safeMint(address to, uint256 quantity) internal {
1064         _safeMint(to, quantity, '');
1065     }
1066 
1067     /**
1068      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1069      *
1070      * Requirements:
1071      *
1072      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1073      * - `quantity` must be greater than 0.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function _safeMint(
1078         address to,
1079         uint256 quantity,
1080         bytes memory _data
1081     ) internal {
1082         _mint(to, quantity, _data, true);
1083     }
1084 
1085     /**
1086      * @dev Mints `quantity` tokens and transfers them to `to`.
1087      *
1088      * Requirements:
1089      *
1090      * - `to` cannot be the zero address.
1091      * - `quantity` must be greater than 0.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _mint(
1096         address to,
1097         uint256 quantity,
1098         bytes memory _data,
1099         bool safe
1100     ) internal {
1101         uint256 startTokenId = _currentIndex;
1102         if (to == address(0)) revert MintToZeroAddress();
1103         if (quantity == 0) revert MintZeroQuantity();
1104 
1105         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1106 
1107         // Overflows are incredibly unrealistic.
1108         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1109         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1110         unchecked {
1111             _addressData[to].balance += uint64(quantity);
1112             _addressData[to].numberMinted += uint64(quantity);
1113 
1114             _ownerships[startTokenId].addr = to;
1115             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1116 
1117             uint256 updatedIndex = startTokenId;
1118             uint256 end = updatedIndex + quantity;
1119 
1120             if (safe && to.isContract()) {
1121                 do {
1122                     emit Transfer(address(0), to, updatedIndex);
1123                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1124                         revert TransferToNonERC721ReceiverImplementer();
1125                     }
1126                 } while (updatedIndex != end);
1127                 // Reentrancy protection
1128                 if (_currentIndex != startTokenId) revert();
1129             } else {
1130                 do {
1131                     emit Transfer(address(0), to, updatedIndex++);
1132                 } while (updatedIndex != end);
1133             }
1134             _currentIndex = updatedIndex;
1135         }
1136         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1137     }
1138 
1139     /**
1140      * @dev Transfers `tokenId` from `from` to `to`.
1141      *
1142      * Requirements:
1143      *
1144      * - `to` cannot be the zero address.
1145      * - `tokenId` token must be owned by `from`.
1146      *
1147      * Emits a {Transfer} event.
1148      */
1149     function _transfer(
1150         address from,
1151         address to,
1152         uint256 tokenId
1153     ) private {
1154         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1155 
1156         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1157 
1158         bool isApprovedOrOwner = (_msgSender() == from ||
1159             isApprovedForAll(from, _msgSender()) ||
1160             getApproved(tokenId) == _msgSender());
1161 
1162         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1163         if (to == address(0)) revert TransferToZeroAddress();
1164 
1165         _beforeTokenTransfers(from, to, tokenId, 1);
1166 
1167         // Clear approvals from the previous owner
1168         _approve(address(0), tokenId, from);
1169 
1170         // Underflow of the sender's balance is impossible because we check for
1171         // ownership above and the recipient's balance can't realistically overflow.
1172         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1173         unchecked {
1174             _addressData[from].balance -= 1;
1175             _addressData[to].balance += 1;
1176 
1177             TokenOwnership storage currSlot = _ownerships[tokenId];
1178             currSlot.addr = to;
1179             currSlot.startTimestamp = uint64(block.timestamp);
1180 
1181             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1182             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1183             uint256 nextTokenId = tokenId + 1;
1184             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1185             if (nextSlot.addr == address(0)) {
1186                 // This will suffice for checking _exists(nextTokenId),
1187                 // as a burned slot cannot contain the zero address.
1188                 if (nextTokenId != _currentIndex) {
1189                     nextSlot.addr = from;
1190                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1191                 }
1192             }
1193         }
1194 
1195         emit Transfer(from, to, tokenId);
1196         _afterTokenTransfers(from, to, tokenId, 1);
1197     }
1198 
1199     /**
1200      * @dev This is equivalent to _burn(tokenId, false)
1201      */
1202     function _burn(uint256 tokenId) internal virtual {
1203         _burn(tokenId, false);
1204     }
1205 
1206     /**
1207      * @dev Destroys `tokenId`.
1208      * The approval is cleared when the token is burned.
1209      *
1210      * Requirements:
1211      *
1212      * - `tokenId` must exist.
1213      *
1214      * Emits a {Transfer} event.
1215      */
1216     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1217         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1218 
1219         address from = prevOwnership.addr;
1220 
1221         if (approvalCheck) {
1222             bool isApprovedOrOwner = (_msgSender() == from ||
1223                 isApprovedForAll(from, _msgSender()) ||
1224                 getApproved(tokenId) == _msgSender());
1225 
1226             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1227         }
1228 
1229         _beforeTokenTransfers(from, address(0), tokenId, 1);
1230 
1231         // Clear approvals from the previous owner
1232         _approve(address(0), tokenId, from);
1233 
1234         // Underflow of the sender's balance is impossible because we check for
1235         // ownership above and the recipient's balance can't realistically overflow.
1236         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1237         unchecked {
1238             AddressData storage addressData = _addressData[from];
1239             addressData.balance -= 1;
1240             addressData.numberBurned += 1;
1241 
1242             // Keep track of who burned the token, and the timestamp of burning.
1243             TokenOwnership storage currSlot = _ownerships[tokenId];
1244             currSlot.addr = from;
1245             currSlot.startTimestamp = uint64(block.timestamp);
1246             currSlot.burned = true;
1247 
1248             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1249             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1250             uint256 nextTokenId = tokenId + 1;
1251             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1252             if (nextSlot.addr == address(0)) {
1253                 // This will suffice for checking _exists(nextTokenId),
1254                 // as a burned slot cannot contain the zero address.
1255                 if (nextTokenId != _currentIndex) {
1256                     nextSlot.addr = from;
1257                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1258                 }
1259             }
1260         }
1261 
1262         emit Transfer(from, address(0), tokenId);
1263         _afterTokenTransfers(from, address(0), tokenId, 1);
1264 
1265         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1266         unchecked {
1267             _burnCounter++;
1268         }
1269     }
1270 
1271     /**
1272      * @dev Approve `to` to operate on `tokenId`
1273      *
1274      * Emits a {Approval} event.
1275      */
1276     function _approve(
1277         address to,
1278         uint256 tokenId,
1279         address owner
1280     ) private {
1281         _tokenApprovals[tokenId] = to;
1282         emit Approval(owner, to, tokenId);
1283     }
1284 
1285     /**
1286      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1287      *
1288      * @param from address representing the previous owner of the given token ID
1289      * @param to target address that will receive the tokens
1290      * @param tokenId uint256 ID of the token to be transferred
1291      * @param _data bytes optional data to send along with the call
1292      * @return bool whether the call correctly returned the expected magic value
1293      */
1294     function _checkContractOnERC721Received(
1295         address from,
1296         address to,
1297         uint256 tokenId,
1298         bytes memory _data
1299     ) private returns (bool) {
1300         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1301             return retval == IERC721Receiver(to).onERC721Received.selector;
1302         } catch (bytes memory reason) {
1303             if (reason.length == 0) {
1304                 revert TransferToNonERC721ReceiverImplementer();
1305             } else {
1306                 assembly {
1307                     revert(add(32, reason), mload(reason))
1308                 }
1309             }
1310         }
1311     }
1312 
1313     /**
1314      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1315      * And also called before burning one token.
1316      *
1317      * startTokenId - the first token id to be transferred
1318      * quantity - the amount to be transferred
1319      *
1320      * Calling conditions:
1321      *
1322      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1323      * transferred to `to`.
1324      * - When `from` is zero, `tokenId` will be minted for `to`.
1325      * - When `to` is zero, `tokenId` will be burned by `from`.
1326      * - `from` and `to` are never both zero.
1327      */
1328     function _beforeTokenTransfers(
1329         address from,
1330         address to,
1331         uint256 startTokenId,
1332         uint256 quantity
1333     ) internal virtual {}
1334 
1335     /**
1336      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1337      * minting.
1338      * And also called after one token has been burned.
1339      *
1340      * startTokenId - the first token id to be transferred
1341      * quantity - the amount to be transferred
1342      *
1343      * Calling conditions:
1344      *
1345      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1346      * transferred to `to`.
1347      * - When `from` is zero, `tokenId` has been minted for `to`.
1348      * - When `to` is zero, `tokenId` has been burned by `from`.
1349      * - `from` and `to` are never both zero.
1350      */
1351     function _afterTokenTransfers(
1352         address from,
1353         address to,
1354         uint256 startTokenId,
1355         uint256 quantity
1356     ) internal virtual {}
1357 }
1358 
1359 pragma solidity ^0.8.4;
1360 
1361 error ExceedingMaxMintAmountPerTx();
1362 error ExceedingMaxSupply();
1363 error ContractPaused();
1364 error WhitelistMintNotActive();
1365 error InsufficientFunds();
1366 error ExceedingWhitelistMintAmount();
1367 error InvalidMerkleProof();
1368 error WithdrawalFailed();
1369 error PublicMintNotActive();
1370 
1371 contract SoulSplicers is ERC721A, Ownable {
1372   using Strings for uint256;
1373 
1374   bytes32 public merkleRootInternal = 0x95f3250742edff790f3d0aeb3930422b1b94cc92920540669f8fc76c2a3a95d8;
1375   bytes32 public merkleRootCommunity = 0x95f3250742edff790f3d0aeb3930422b1b94cc92920540669f8fc76c2a3a95d8;
1376   string public URI;
1377   uint256 public cost = 0.08 ether;
1378   uint256 public maxSupply = 9950;
1379   uint256 public maxMintAmountPerTx = 5;
1380   bool public whitelistMintingActive = false;
1381   bool public publicMintingActive = false;
1382 
1383   constructor() ERC721A("SoulSplicers", "SOUL") {}
1384 
1385   // internal
1386   function _baseURI() internal view virtual override returns (string memory) {
1387     return URI;
1388   }
1389 
1390   modifier mintRequirements(uint256 _mintAmount)
1391   {
1392       if (_mintAmount > maxMintAmountPerTx) revert ExceedingMaxMintAmountPerTx();
1393       if (totalSupply() + _mintAmount > maxSupply) revert ExceedingMaxSupply();
1394       if (msg.value < cost * _mintAmount) revert InsufficientFunds();      
1395       _;
1396   }
1397 
1398   // public
1399   function mint(uint256 _mintAmount) public payable mintRequirements(_mintAmount) {
1400       if (!publicMintingActive) revert PublicMintNotActive();        
1401       _safeMint(msg.sender, _mintAmount);
1402   }
1403 
1404   function whitelistMint(uint _mintAmount, bytes32[] calldata _merkleProof, bool _internal) public payable mintRequirements(_mintAmount)
1405   {
1406       if (!whitelistMintingActive) revert WhitelistMintNotActive();
1407       uint256 remainingMints = getRemainingWhitelistMints(msg.sender, _merkleProof, _internal);
1408       if (_mintAmount > remainingMints) revert ExceedingWhitelistMintAmount();
1409       _safeMint(msg.sender, _mintAmount);
1410   }
1411 
1412   function walletOfOwner(address _owner)
1413     public
1414     view
1415     returns (uint256[] memory)
1416   {
1417     uint256 ownerTokenCount = balanceOf(_owner);
1418     uint256 currentTokenId = 0;
1419     uint256 ownedTokenIndex = 0;
1420     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1421 
1422     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply)
1423     {
1424         if (ownerOf(currentTokenId) == _owner)
1425         {
1426             tokenIds[ownedTokenIndex] = currentTokenId;
1427             ownedTokenIndex++;
1428         }
1429         currentTokenId++;
1430     }
1431     return tokenIds;
1432   }
1433 
1434   function getRemainingWhitelistMints(address _user, bytes32[] calldata _merkleProof, bool _internal) public view returns (uint256) {
1435       bytes32 leaf = keccak256(abi.encodePacked(_user));
1436       uint256 maxWhitelistMints = 0;
1437 
1438       if (_internal) {
1439         if (MerkleProof.verify(_merkleProof, merkleRootInternal, leaf)){
1440             maxWhitelistMints = 3;
1441         }
1442       } else {
1443         if (MerkleProof.verify(_merkleProof, merkleRootCommunity, leaf)) {
1444             maxWhitelistMints = 1;
1445         }
1446       }
1447       
1448       if (maxWhitelistMints == 0) revert InvalidMerkleProof();
1449 
1450       return maxWhitelistMints - _numberMinted(_user);
1451   }
1452 
1453   //only owner
1454   function OwnerMint(uint256 _mintAmount) public onlyOwner {
1455       if (totalSupply() + _mintAmount > maxSupply) revert ExceedingMaxSupply();
1456       _safeMint(msg.sender, _mintAmount);
1457   }
1458   
1459   function setCost(uint256 _newCost) public onlyOwner {
1460     cost = _newCost;
1461   }
1462 
1463   function setNewSupply(uint256 _newSupply) public onlyOwner {
1464     maxSupply = _newSupply;
1465   }
1466 
1467   function setMerkleRootInternal(bytes32 _newRoot) public onlyOwner {
1468     merkleRootInternal = _newRoot;
1469   }
1470 
1471   function setMerkleRootCommunity(bytes32 _newRoot) public onlyOwner {
1472     merkleRootCommunity = _newRoot;
1473   }
1474 
1475   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1476     URI = _newBaseURI;
1477   }
1478 
1479   function setPublicMinting(bool _state) public onlyOwner {
1480     publicMintingActive = _state;
1481   }  
1482 
1483   function setWhitelistMintingState(bool _state) public onlyOwner {
1484     whitelistMintingActive = _state;
1485   }
1486  
1487   function withdraw() public payable onlyOwner {
1488     (bool withdrawComplete, ) = msg.sender.call{value: address(this).balance}("");
1489     if (!withdrawComplete) revert WithdrawalFailed();
1490   }
1491 }