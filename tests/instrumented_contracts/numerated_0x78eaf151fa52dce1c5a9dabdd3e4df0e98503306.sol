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
728 // File: erc721a/contracts/ERC721A.sol
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
742 error ApprovalCallerNotOwnerNorApproved();
743 error ApprovalQueryForNonexistentToken();
744 error ApproveToCaller();
745 error ApprovalToCurrentOwner();
746 error BalanceQueryForZeroAddress();
747 error MintToZeroAddress();
748 error MintZeroQuantity();
749 error OwnerQueryForNonexistentToken();
750 error TransferCallerNotOwnerNorApproved();
751 error TransferFromIncorrectOwner();
752 error TransferToNonERC721ReceiverImplementer();
753 error TransferToZeroAddress();
754 error URIQueryForNonexistentToken();
755 
756 /**
757  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
758  * the Metadata extension. Built to optimize for lower gas during batch mints.
759  *
760  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
761  *
762  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
763  *
764  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
765  */
766 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
767     using Address for address;
768     using Strings for uint256;
769 
770     // Compiler will pack this into a single 256bit word.
771     struct TokenOwnership {
772         // The address of the owner.
773         address addr;
774         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
775         uint64 startTimestamp;
776         // Whether the token has been burned.
777         bool burned;
778     }
779 
780     // Compiler will pack this into a single 256bit word.
781     struct AddressData {
782         // Realistically, 2**64-1 is more than enough.
783         uint64 balance;
784         // Keeps track of mint count with minimal overhead for tokenomics.
785         uint64 numberMinted;
786         // Keeps track of burn count with minimal overhead for tokenomics.
787         uint64 numberBurned;
788         // For miscellaneous variable(s) pertaining to the address
789         // (e.g. number of whitelist mint slots used).
790         // If there are multiple variables, please pack them into a uint64.
791         uint64 aux;
792     }
793 
794     // The tokenId of the next token to be minted.
795     uint256 internal _currentIndex;
796 
797     // The number of tokens burned.
798     uint256 internal _burnCounter;
799 
800     // Token name
801     string private _name;
802 
803     // Token symbol
804     string private _symbol;
805 
806     // Mapping from token ID to ownership details
807     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
808     mapping(uint256 => TokenOwnership) internal _ownerships;
809 
810     // Mapping owner address to address data
811     mapping(address => AddressData) private _addressData;
812 
813     // Mapping from token ID to approved address
814     mapping(uint256 => address) private _tokenApprovals;
815 
816     // Mapping from owner to operator approvals
817     mapping(address => mapping(address => bool)) private _operatorApprovals;
818 
819     constructor(string memory name_, string memory symbol_) {
820         _name = name_;
821         _symbol = symbol_;
822         _currentIndex = _startTokenId();
823     }
824 
825     /**
826      * To change the starting tokenId, please override this function.
827      */
828     function _startTokenId() internal view virtual returns (uint256) {
829         return 0;
830     }
831 
832     /**
833      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
834      */
835     function totalSupply() public view returns (uint256) {
836         // Counter underflow is impossible as _burnCounter cannot be incremented
837         // more than _currentIndex - _startTokenId() times
838         unchecked {
839             return _currentIndex - _burnCounter - _startTokenId();
840         }
841     }
842 
843     /**
844      * Returns the total amount of tokens minted in the contract.
845      */
846     function _totalMinted() internal view returns (uint256) {
847         // Counter underflow is impossible as _currentIndex does not decrement,
848         // and it is initialized to _startTokenId()
849         unchecked {
850             return _currentIndex - _startTokenId();
851         }
852     }
853 
854     /**
855      * @dev See {IERC165-supportsInterface}.
856      */
857     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
858         return
859             interfaceId == type(IERC721).interfaceId ||
860             interfaceId == type(IERC721Metadata).interfaceId ||
861             super.supportsInterface(interfaceId);
862     }
863 
864     /**
865      * @dev See {IERC721-balanceOf}.
866      */
867     function balanceOf(address owner) public view override returns (uint256) {
868         if (owner == address(0)) revert BalanceQueryForZeroAddress();
869         return uint256(_addressData[owner].balance);
870     }
871 
872     /**
873      * Returns the number of tokens minted by `owner`.
874      */
875     function _numberMinted(address owner) internal view returns (uint256) {
876         return uint256(_addressData[owner].numberMinted);
877     }
878 
879     /**
880      * Returns the number of tokens burned by or on behalf of `owner`.
881      */
882     function _numberBurned(address owner) internal view returns (uint256) {
883         return uint256(_addressData[owner].numberBurned);
884     }
885 
886     /**
887      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
888      */
889     function _getAux(address owner) internal view returns (uint64) {
890         return _addressData[owner].aux;
891     }
892 
893     /**
894      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
895      * If there are multiple variables, please pack them into a uint64.
896      */
897     function _setAux(address owner, uint64 aux) internal {
898         _addressData[owner].aux = aux;
899     }
900 
901     /**
902      * Gas spent here starts off proportional to the maximum mint batch size.
903      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
904      */
905     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
906         uint256 curr = tokenId;
907 
908         unchecked {
909             if (_startTokenId() <= curr && curr < _currentIndex) {
910                 TokenOwnership memory ownership = _ownerships[curr];
911                 if (!ownership.burned) {
912                     if (ownership.addr != address(0)) {
913                         return ownership;
914                     }
915                     // Invariant:
916                     // There will always be an ownership that has an address and is not burned
917                     // before an ownership that does not have an address and is not burned.
918                     // Hence, curr will not underflow.
919                     while (true) {
920                         curr--;
921                         ownership = _ownerships[curr];
922                         if (ownership.addr != address(0)) {
923                             return ownership;
924                         }
925                     }
926                 }
927             }
928         }
929         revert OwnerQueryForNonexistentToken();
930     }
931 
932     /**
933      * @dev See {IERC721-ownerOf}.
934      */
935     function ownerOf(uint256 tokenId) public view override returns (address) {
936         return _ownershipOf(tokenId).addr;
937     }
938 
939     /**
940      * @dev See {IERC721Metadata-name}.
941      */
942     function name() public view virtual override returns (string memory) {
943         return _name;
944     }
945 
946     /**
947      * @dev See {IERC721Metadata-symbol}.
948      */
949     function symbol() public view virtual override returns (string memory) {
950         return _symbol;
951     }
952 
953     /**
954      * @dev See {IERC721Metadata-tokenURI}.
955      */
956     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
957         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
958 
959         string memory baseURI = _baseURI();
960         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
961     }
962 
963     /**
964      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
965      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
966      * by default, can be overriden in child contracts.
967      */
968     function _baseURI() internal view virtual returns (string memory) {
969         return '';
970     }
971 
972     /**
973      * @dev See {IERC721-approve}.
974      */
975     function approve(address to, uint256 tokenId) public override {
976         address owner = ERC721A.ownerOf(tokenId);
977         if (to == owner) revert ApprovalToCurrentOwner();
978 
979         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
980             revert ApprovalCallerNotOwnerNorApproved();
981         }
982 
983         _approve(to, tokenId, owner);
984     }
985 
986     /**
987      * @dev See {IERC721-getApproved}.
988      */
989     function getApproved(uint256 tokenId) public view override returns (address) {
990         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
991 
992         return _tokenApprovals[tokenId];
993     }
994 
995     /**
996      * @dev See {IERC721-setApprovalForAll}.
997      */
998     function setApprovalForAll(address operator, bool approved) public virtual override {
999         if (operator == _msgSender()) revert ApproveToCaller();
1000 
1001         _operatorApprovals[_msgSender()][operator] = approved;
1002         emit ApprovalForAll(_msgSender(), operator, approved);
1003     }
1004 
1005     /**
1006      * @dev See {IERC721-isApprovedForAll}.
1007      */
1008     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1009         return _operatorApprovals[owner][operator];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-transferFrom}.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) public virtual override {
1020         _transfer(from, to, tokenId);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-safeTransferFrom}.
1025      */
1026     function safeTransferFrom(
1027         address from,
1028         address to,
1029         uint256 tokenId
1030     ) public virtual override {
1031         safeTransferFrom(from, to, tokenId, '');
1032     }
1033 
1034     /**
1035      * @dev See {IERC721-safeTransferFrom}.
1036      */
1037     function safeTransferFrom(
1038         address from,
1039         address to,
1040         uint256 tokenId,
1041         bytes memory _data
1042     ) public virtual override {
1043         _transfer(from, to, tokenId);
1044         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1045             revert TransferToNonERC721ReceiverImplementer();
1046         }
1047     }
1048 
1049     /**
1050      * @dev Returns whether `tokenId` exists.
1051      *
1052      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1053      *
1054      * Tokens start existing when they are minted (`_mint`),
1055      */
1056     function _exists(uint256 tokenId) internal view returns (bool) {
1057         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1058             !_ownerships[tokenId].burned;
1059     }
1060 
1061     function _safeMint(address to, uint256 quantity) internal {
1062         _safeMint(to, quantity, '');
1063     }
1064 
1065     /**
1066      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1067      *
1068      * Requirements:
1069      *
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1071      * - `quantity` must be greater than 0.
1072      *
1073      * Emits a {Transfer} event.
1074      */
1075     function _safeMint(
1076         address to,
1077         uint256 quantity,
1078         bytes memory _data
1079     ) internal {
1080         _mint(to, quantity, _data, true);
1081     }
1082 
1083     /**
1084      * @dev Mints `quantity` tokens and transfers them to `to`.
1085      *
1086      * Requirements:
1087      *
1088      * - `to` cannot be the zero address.
1089      * - `quantity` must be greater than 0.
1090      *
1091      * Emits a {Transfer} event.
1092      */
1093     function _mint(
1094         address to,
1095         uint256 quantity,
1096         bytes memory _data,
1097         bool safe
1098     ) internal {
1099         uint256 startTokenId = _currentIndex;
1100         if (to == address(0)) revert MintToZeroAddress();
1101         if (quantity == 0) revert MintZeroQuantity();
1102 
1103         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1104 
1105         // Overflows are incredibly unrealistic.
1106         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1107         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1108         unchecked {
1109             _addressData[to].balance += uint64(quantity);
1110             _addressData[to].numberMinted += uint64(quantity);
1111 
1112             _ownerships[startTokenId].addr = to;
1113             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1114 
1115             uint256 updatedIndex = startTokenId;
1116             uint256 end = updatedIndex + quantity;
1117 
1118             if (safe && to.isContract()) {
1119                 do {
1120                     emit Transfer(address(0), to, updatedIndex);
1121                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1122                         revert TransferToNonERC721ReceiverImplementer();
1123                     }
1124                 } while (updatedIndex != end);
1125                 // Reentrancy protection
1126                 if (_currentIndex != startTokenId) revert();
1127             } else {
1128                 do {
1129                     emit Transfer(address(0), to, updatedIndex++);
1130                 } while (updatedIndex != end);
1131             }
1132             _currentIndex = updatedIndex;
1133         }
1134         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1135     }
1136 
1137     /**
1138      * @dev Transfers `tokenId` from `from` to `to`.
1139      *
1140      * Requirements:
1141      *
1142      * - `to` cannot be the zero address.
1143      * - `tokenId` token must be owned by `from`.
1144      *
1145      * Emits a {Transfer} event.
1146      */
1147     function _transfer(
1148         address from,
1149         address to,
1150         uint256 tokenId
1151     ) private {
1152         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1153 
1154         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1155 
1156         bool isApprovedOrOwner = (_msgSender() == from ||
1157             isApprovedForAll(from, _msgSender()) ||
1158             getApproved(tokenId) == _msgSender());
1159 
1160         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1161         if (to == address(0)) revert TransferToZeroAddress();
1162 
1163         _beforeTokenTransfers(from, to, tokenId, 1);
1164 
1165         // Clear approvals from the previous owner
1166         _approve(address(0), tokenId, from);
1167 
1168         // Underflow of the sender's balance is impossible because we check for
1169         // ownership above and the recipient's balance can't realistically overflow.
1170         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1171         unchecked {
1172             _addressData[from].balance -= 1;
1173             _addressData[to].balance += 1;
1174 
1175             TokenOwnership storage currSlot = _ownerships[tokenId];
1176             currSlot.addr = to;
1177             currSlot.startTimestamp = uint64(block.timestamp);
1178 
1179             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1180             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1181             uint256 nextTokenId = tokenId + 1;
1182             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1183             if (nextSlot.addr == address(0)) {
1184                 // This will suffice for checking _exists(nextTokenId),
1185                 // as a burned slot cannot contain the zero address.
1186                 if (nextTokenId != _currentIndex) {
1187                     nextSlot.addr = from;
1188                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1189                 }
1190             }
1191         }
1192 
1193         emit Transfer(from, to, tokenId);
1194         _afterTokenTransfers(from, to, tokenId, 1);
1195     }
1196 
1197     /**
1198      * @dev This is equivalent to _burn(tokenId, false)
1199      */
1200     function _burn(uint256 tokenId) internal virtual {
1201         _burn(tokenId, false);
1202     }
1203 
1204     /**
1205      * @dev Destroys `tokenId`.
1206      * The approval is cleared when the token is burned.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1215         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1216 
1217         address from = prevOwnership.addr;
1218 
1219         if (approvalCheck) {
1220             bool isApprovedOrOwner = (_msgSender() == from ||
1221                 isApprovedForAll(from, _msgSender()) ||
1222                 getApproved(tokenId) == _msgSender());
1223 
1224             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1225         }
1226 
1227         _beforeTokenTransfers(from, address(0), tokenId, 1);
1228 
1229         // Clear approvals from the previous owner
1230         _approve(address(0), tokenId, from);
1231 
1232         // Underflow of the sender's balance is impossible because we check for
1233         // ownership above and the recipient's balance can't realistically overflow.
1234         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1235         unchecked {
1236             AddressData storage addressData = _addressData[from];
1237             addressData.balance -= 1;
1238             addressData.numberBurned += 1;
1239 
1240             // Keep track of who burned the token, and the timestamp of burning.
1241             TokenOwnership storage currSlot = _ownerships[tokenId];
1242             currSlot.addr = from;
1243             currSlot.startTimestamp = uint64(block.timestamp);
1244             currSlot.burned = true;
1245 
1246             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1247             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1248             uint256 nextTokenId = tokenId + 1;
1249             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1250             if (nextSlot.addr == address(0)) {
1251                 // This will suffice for checking _exists(nextTokenId),
1252                 // as a burned slot cannot contain the zero address.
1253                 if (nextTokenId != _currentIndex) {
1254                     nextSlot.addr = from;
1255                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1256                 }
1257             }
1258         }
1259 
1260         emit Transfer(from, address(0), tokenId);
1261         _afterTokenTransfers(from, address(0), tokenId, 1);
1262 
1263         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1264         unchecked {
1265             _burnCounter++;
1266         }
1267     }
1268 
1269     /**
1270      * @dev Approve `to` to operate on `tokenId`
1271      *
1272      * Emits a {Approval} event.
1273      */
1274     function _approve(
1275         address to,
1276         uint256 tokenId,
1277         address owner
1278     ) private {
1279         _tokenApprovals[tokenId] = to;
1280         emit Approval(owner, to, tokenId);
1281     }
1282 
1283     /**
1284      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1285      *
1286      * @param from address representing the previous owner of the given token ID
1287      * @param to target address that will receive the tokens
1288      * @param tokenId uint256 ID of the token to be transferred
1289      * @param _data bytes optional data to send along with the call
1290      * @return bool whether the call correctly returned the expected magic value
1291      */
1292     function _checkContractOnERC721Received(
1293         address from,
1294         address to,
1295         uint256 tokenId,
1296         bytes memory _data
1297     ) private returns (bool) {
1298         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1299             return retval == IERC721Receiver(to).onERC721Received.selector;
1300         } catch (bytes memory reason) {
1301             if (reason.length == 0) {
1302                 revert TransferToNonERC721ReceiverImplementer();
1303             } else {
1304                 assembly {
1305                     revert(add(32, reason), mload(reason))
1306                 }
1307             }
1308         }
1309     }
1310 
1311     /**
1312      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1313      * And also called before burning one token.
1314      *
1315      * startTokenId - the first token id to be transferred
1316      * quantity - the amount to be transferred
1317      *
1318      * Calling conditions:
1319      *
1320      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1321      * transferred to `to`.
1322      * - When `from` is zero, `tokenId` will be minted for `to`.
1323      * - When `to` is zero, `tokenId` will be burned by `from`.
1324      * - `from` and `to` are never both zero.
1325      */
1326     function _beforeTokenTransfers(
1327         address from,
1328         address to,
1329         uint256 startTokenId,
1330         uint256 quantity
1331     ) internal virtual {}
1332 
1333     /**
1334      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1335      * minting.
1336      * And also called after one token has been burned.
1337      *
1338      * startTokenId - the first token id to be transferred
1339      * quantity - the amount to be transferred
1340      *
1341      * Calling conditions:
1342      *
1343      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1344      * transferred to `to`.
1345      * - When `from` is zero, `tokenId` has been minted for `to`.
1346      * - When `to` is zero, `tokenId` has been burned by `from`.
1347      * - `from` and `to` are never both zero.
1348      */
1349     function _afterTokenTransfers(
1350         address from,
1351         address to,
1352         uint256 startTokenId,
1353         uint256 quantity
1354     ) internal virtual {}
1355 }
1356 pragma solidity ^0.8.0;
1357 
1358 /**
1359  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1360  * @dev See https://eips.ethereum.org/EIPS/eip-721
1361  */
1362 interface IERC721Enumerable is IERC721 {
1363     /**
1364      * @dev Returns the total amount of tokens stored by the contract.
1365      */
1366     function totalSupply() external view returns (uint256);
1367 
1368     /**
1369      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1370      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1371      */
1372     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1373 
1374     /**
1375      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1376      * Use along with {totalSupply} to enumerate all tokens.
1377      */
1378     function tokenByIndex(uint256 index) external view returns (uint256);
1379 }
1380 
1381 pragma solidity ^0.8.12;
1382 
1383 contract Nukes is ERC721A, Ownable {
1384     using Strings for uint256;
1385 
1386     uint256 public constant RESERVED_TOKENS = 50;
1387     uint256 public constant TOTAL_TOKENS = 10000;
1388 
1389     address public constant RESERVED_TOKENS_ADDRESS =
1390         0xA04d10c6Be637a0aD4c1623A596A6C9d7Bf8b977;
1391 
1392     uint256 public constant STAGE_STOPPED = 0;
1393     uint256 public constant STAGE_PRESALE = 1;
1394     uint256 public constant STAGE_PUBLIC = 2;
1395     uint256 public constant STAGE_CLAIM = 3;
1396     uint256 public constant STAGE_AFTERCLAIMSALE = 4;
1397     uint256 public currentStage = STAGE_STOPPED;
1398 
1399     address public crazySkullz = 0x3a4cA1c1bB243D299032753fdd75e8FEc1F0d585;
1400     uint256 public crazySkullzNeededPerClaimedToken = 2;
1401     mapping(uint256 => bool) public usedSkullIds;
1402 
1403     uint256 public tokenPricePresale = 0.06 ether;
1404     uint256 public tokenPricePublicSale = 0.08 ether;
1405 
1406     uint256 public maxTokensPerAddressPresale = 2;
1407     uint256 public maxTokensPerAddress = 4;
1408     uint256 public maxTokensPerTransaction = maxTokensPerAddress;
1409 
1410     uint256 public publicSaleTotalLimit = 5000;
1411     uint256 public claimTotalLimit = 5000;
1412 
1413     bytes32 public whitelistRoot;
1414 
1415     string public tokenBaseURI = "ipfs://Qma2ZRi3tyjNRPgMmzcdp4rnXrNuVM3PbSSQn1YvF7unMy/";
1416     
1417     uint256 public soldAmount = 0;
1418     uint256 public claimedAmount = 0;
1419     mapping(address => uint256) public purchased;
1420 
1421     constructor() ERC721A("Nukes", "Nukes") {
1422         if (RESERVED_TOKENS >= 0) {
1423             _safeMint(RESERVED_TOKENS_ADDRESS, RESERVED_TOKENS);
1424             claimedAmount += RESERVED_TOKENS;
1425         }
1426     }
1427 
1428     function _startTokenId() internal pure override(ERC721A) returns (uint256) {
1429         return 1;
1430     }
1431 
1432     function stopSale() external onlyOwner {
1433         currentStage = STAGE_STOPPED;
1434     }
1435 
1436     function startPresale() external onlyOwner {
1437         currentStage = STAGE_PRESALE;
1438     }
1439 
1440     function startPublicSale() external onlyOwner {
1441         currentStage = STAGE_PUBLIC;
1442     }
1443 
1444     function startClaimingStage() external onlyOwner {
1445         currentStage = STAGE_CLAIM;
1446     }
1447 
1448     function startAfterClaimSale() external onlyOwner {
1449         currentStage = STAGE_AFTERCLAIMSALE;
1450     }
1451 
1452     function setSkullzAddress(address val) external onlyOwner {
1453         crazySkullz = val;
1454     }
1455 
1456     function setCrazySkullzNeededPerClaimedToken(uint256 val)
1457         external
1458         onlyOwner
1459     {
1460         crazySkullzNeededPerClaimedToken = val;
1461     }
1462 
1463     function setTokenPricePresale(uint256 val) external onlyOwner {
1464         tokenPricePresale = val;
1465     }
1466 
1467     function setTokenPricePublicSale(uint256 val) external onlyOwner {
1468         tokenPricePublicSale = val;
1469     }
1470 
1471     function setMaxTokensPerTransaction(uint256 val) external onlyOwner {
1472         maxTokensPerTransaction = val;
1473     }
1474 
1475     function setMaxTokensPerAddressPresale(uint256 val) external onlyOwner {
1476         maxTokensPerAddressPresale = val;
1477     }
1478 
1479     function setMaxTokensPerAddress(uint256 val) external onlyOwner {
1480         maxTokensPerAddress = val;
1481     }
1482 
1483     function setWhitelistRoot(bytes32 val) external onlyOwner {
1484         whitelistRoot = val;
1485     }
1486 
1487     function setPublicSaleTotalLimit(uint256 val) external onlyOwner {
1488         publicSaleTotalLimit = val;
1489     }
1490 
1491     function setClaimTotalLimit(uint256 val) external onlyOwner {
1492         claimTotalLimit = val;
1493     }
1494 
1495     function tokenPrice() public view returns (uint256) {
1496         if (currentStage == STAGE_PRESALE) {
1497             return tokenPricePresale;
1498         }
1499         return tokenPricePublicSale;
1500     }
1501 
1502     function getMaxTokensForPhase(address target, bytes32[] memory proof)
1503         public
1504         view
1505         returns (uint256)
1506     {
1507         bytes32 leaf = keccak256(abi.encodePacked(target));
1508 
1509         if (currentStage == STAGE_PUBLIC || currentStage == STAGE_AFTERCLAIMSALE) {
1510             return maxTokensPerAddress;
1511         } else if (currentStage == STAGE_PRESALE) {
1512             if (MerkleProof.verify(proof, whitelistRoot, leaf)) {
1513                 return maxTokensPerAddressPresale;
1514             } else {
1515                 return 0;
1516             }
1517         } else if (currentStage == STAGE_CLAIM) {
1518             return TOTAL_TOKENS;
1519         } else {
1520             return 0;
1521         }
1522     }
1523 
1524     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
1525         if (a < b) {
1526             return 0;
1527         }
1528         return a - b;
1529     }
1530 
1531     function getMaxTokensAllowed(address target, bytes32[] memory proof)
1532         public
1533         view
1534         returns (uint256)
1535     {
1536         uint256 maxAllowedTokens = getMaxTokensForPhase(target, proof);
1537 
1538         
1539         if (currentStage != STAGE_CLAIM) {
1540             uint256 tokensLeftForAddress = safeSub(
1541                 maxAllowedTokens,
1542                 purchased[target]
1543             );
1544             maxAllowedTokens = min(maxAllowedTokens, tokensLeftForAddress);
1545         }
1546 
1547         if (currentStage == STAGE_PUBLIC || currentStage == STAGE_PRESALE) {
1548             uint256 publicSaleTokensLeft = safeSub(
1549                 publicSaleTotalLimit,
1550                 soldAmount
1551             );
1552             maxAllowedTokens = min(maxAllowedTokens, publicSaleTokensLeft);
1553         } else if (currentStage == STAGE_CLAIM) {
1554             uint256 forClaimTokensLeft = safeSub(claimTotalLimit, claimedAmount);
1555             maxAllowedTokens = min(maxAllowedTokens, forClaimTokensLeft);
1556         }
1557 
1558         uint256 totalTokensLeft = safeSub(
1559             TOTAL_TOKENS,
1560             soldAmount + claimedAmount
1561         );
1562         maxAllowedTokens = min(maxAllowedTokens, totalTokensLeft);
1563 
1564         return min(maxAllowedTokens, maxTokensPerTransaction);
1565     }
1566 
1567     function getContractInfo(address target, bytes32[] memory proof)
1568         external
1569         view
1570         returns (
1571             uint256 _currentStage,
1572             uint256 _maxTokensAllowed,
1573             uint256 _tokenPrice,
1574             uint256 _soldAmount,
1575             uint256 _purchasedAmount,
1576             uint256 _presaleTotalLimit,
1577             bytes32 _whitelistRoot
1578         )
1579     {
1580         _currentStage = currentStage;
1581         _maxTokensAllowed = getMaxTokensAllowed(target, proof);
1582         _tokenPrice = tokenPrice();
1583         _soldAmount = soldAmount;
1584         _purchasedAmount = purchased[target];
1585         _presaleTotalLimit = TOTAL_TOKENS;
1586         _whitelistRoot = whitelistRoot;
1587     }
1588 
1589     function mint(uint256 amount, bytes32[] calldata proof) external payable {
1590         require(msg.sender == tx.origin, "Caller must not be a contract");
1591         require(
1592             currentStage == STAGE_PRESALE || currentStage == STAGE_PUBLIC || currentStage == STAGE_AFTERCLAIMSALE,
1593             "Cannot mint tokens at this stage"
1594         );
1595         require(msg.value >= tokenPrice() * amount, "Incorrect ETH sent");
1596         require(
1597             amount <= getMaxTokensAllowed(msg.sender, proof),
1598             "Cannot mint more than the max allowed tokens"
1599         );
1600 
1601         _safeMint(msg.sender, amount);
1602         purchased[msg.sender] += amount;
1603         soldAmount += amount;
1604     }
1605 
1606     function teamMintFromForSale(uint256 amount, address[] calldata addresses)
1607         external
1608         onlyOwner
1609     {
1610         uint256 totalMintAmount = amount * addresses.length;
1611         require(
1612             soldAmount + claimedAmount + totalMintAmount <= TOTAL_TOKENS,
1613             "Cannot mint more than the total amount of tokens"
1614         );
1615         require(
1616             soldAmount + totalMintAmount <= publicSaleTotalLimit,
1617             "Cannot mint more than the public sale total limit"
1618         );
1619         for (uint256 i = 0; i < addresses.length; i++) {
1620             _safeMint(addresses[i], amount);
1621         }
1622 
1623         soldAmount += totalMintAmount;
1624     }
1625 
1626     function teamMintFromForClaim(uint256 amount, address[] calldata addresses)
1627         external
1628         onlyOwner
1629     {
1630         uint256 totalMintAmount = amount * addresses.length;
1631         require(
1632             soldAmount + claimedAmount + totalMintAmount <= TOTAL_TOKENS,
1633             "Cannot mint more than the total amount of tokens"
1634         );
1635         require(
1636             claimedAmount + totalMintAmount <= claimTotalLimit,
1637             "Cannot mint more than the claim total limit"
1638         );
1639         for (uint256 i = 0; i < addresses.length; i++) {
1640             _safeMint(addresses[i], amount);
1641         }
1642         claimedAmount += totalMintAmount;
1643     }
1644 
1645     function claim(uint256 amount, uint256[] calldata skullIds)
1646         external
1647     {
1648         require(
1649             currentStage == STAGE_CLAIM,
1650             "Cannot mint tokens at this stage"
1651         );
1652         require(
1653             amount * crazySkullzNeededPerClaimedToken == skullIds.length,
1654             "Incorrect amount of tokens sent"
1655         );
1656         require(
1657             soldAmount + claimedAmount + amount <= TOTAL_TOKENS,
1658             "Cannot claim more than the max allowed tokens"
1659         );
1660 
1661         for (uint256 i = 0; i < skullIds.length; i++) {
1662             require(
1663                 IERC721(crazySkullz).ownerOf(skullIds[i]) == msg.sender,
1664                 "Must use own tokens to claim"
1665             );
1666             require(
1667                 usedSkullIds[skullIds[i]] == false,
1668                 "Cannot use a token for claiming twice"
1669             );
1670             usedSkullIds[skullIds[i]] = true;
1671         }
1672 
1673         _safeMint(msg.sender, amount);
1674 
1675         claimedAmount += amount;
1676     }
1677 
1678     function getValidIdsForClaim(address target) external view returns (uint256[] memory) {
1679         uint256 count = 0;
1680 
1681         uint256 balance = IERC721(crazySkullz).balanceOf(target);
1682         for (uint256 i = 0; i < balance; i++) {
1683             uint256 id = IERC721Enumerable(crazySkullz).tokenOfOwnerByIndex(target, i);
1684             if (!usedSkullIds[id]) {
1685                 count++;
1686             }
1687         }
1688 
1689         uint256[] memory result = new uint256[](count);
1690         uint256 idx = 0;
1691         for (uint256 i = 0; i < balance; i++) {
1692             uint256 id = IERC721Enumerable(crazySkullz).tokenOfOwnerByIndex(target, i);
1693             if (!usedSkullIds[id]) {
1694                 result[idx] = id;
1695                 idx++;
1696             }
1697         }
1698 
1699         return result;
1700     }
1701 
1702     function checkToken(uint256 tokenId, address target) external view returns (bool isUsed, bool isOwned) {
1703         isUsed = usedSkullIds[tokenId];
1704         isOwned = IERC721(crazySkullz).ownerOf(tokenId) == target;
1705     }
1706 
1707     function _baseURI()
1708         internal
1709         view
1710         override(ERC721A)
1711         returns (string memory)
1712     {
1713         return tokenBaseURI;
1714     }
1715 
1716     function setBaseURI(string calldata URI) external onlyOwner {
1717         tokenBaseURI = URI;
1718     }
1719 
1720     function withdraw() external onlyOwner {
1721         require(payable(RESERVED_TOKENS_ADDRESS).send(address(this).balance));
1722     }
1723 
1724     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1725         return a < b ? a : b;
1726     }
1727 }