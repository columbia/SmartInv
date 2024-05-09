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
728 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
729 
730 
731 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 
736 
737 
738 
739 
740 
741 
742 /**
743  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
744  * the Metadata extension, but not including the Enumerable extension, which is available separately as
745  * {ERC721Enumerable}.
746  */
747 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
748     using Address for address;
749     using Strings for uint256;
750 
751     // Token name
752     string private _name;
753 
754     // Token symbol
755     string private _symbol;
756 
757     // Mapping from token ID to owner address
758     mapping(uint256 => address) private _owners;
759 
760     // Mapping owner address to token count
761     mapping(address => uint256) private _balances;
762 
763     // Mapping from token ID to approved address
764     mapping(uint256 => address) private _tokenApprovals;
765 
766     // Mapping from owner to operator approvals
767     mapping(address => mapping(address => bool)) private _operatorApprovals;
768 
769     /**
770      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
771      */
772     constructor(string memory name_, string memory symbol_) {
773         _name = name_;
774         _symbol = symbol_;
775     }
776 
777     /**
778      * @dev See {IERC165-supportsInterface}.
779      */
780     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
781         return
782             interfaceId == type(IERC721).interfaceId ||
783             interfaceId == type(IERC721Metadata).interfaceId ||
784             super.supportsInterface(interfaceId);
785     }
786 
787     /**
788      * @dev See {IERC721-balanceOf}.
789      */
790     function balanceOf(address owner) public view virtual override returns (uint256) {
791         require(owner != address(0), "ERC721: balance query for the zero address");
792         return _balances[owner];
793     }
794 
795     /**
796      * @dev See {IERC721-ownerOf}.
797      */
798     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
799         address owner = _owners[tokenId];
800         require(owner != address(0), "ERC721: owner query for nonexistent token");
801         return owner;
802     }
803 
804     /**
805      * @dev See {IERC721Metadata-name}.
806      */
807     function name() public view virtual override returns (string memory) {
808         return _name;
809     }
810 
811     /**
812      * @dev See {IERC721Metadata-symbol}.
813      */
814     function symbol() public view virtual override returns (string memory) {
815         return _symbol;
816     }
817 
818     /**
819      * @dev See {IERC721Metadata-tokenURI}.
820      */
821     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
822         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
823 
824         string memory baseURI = _baseURI();
825         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
826     }
827 
828     /**
829      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
830      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
831      * by default, can be overriden in child contracts.
832      */
833     function _baseURI() internal view virtual returns (string memory) {
834         return "";
835     }
836 
837     /**
838      * @dev See {IERC721-approve}.
839      */
840     function approve(address to, uint256 tokenId) public virtual override {
841         address owner = ERC721.ownerOf(tokenId);
842         require(to != owner, "ERC721: approval to current owner");
843 
844         require(
845             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
846             "ERC721: approve caller is not owner nor approved for all"
847         );
848 
849         _approve(to, tokenId);
850     }
851 
852     /**
853      * @dev See {IERC721-getApproved}.
854      */
855     function getApproved(uint256 tokenId) public view virtual override returns (address) {
856         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
857 
858         return _tokenApprovals[tokenId];
859     }
860 
861     /**
862      * @dev See {IERC721-setApprovalForAll}.
863      */
864     function setApprovalForAll(address operator, bool approved) public virtual override {
865         _setApprovalForAll(_msgSender(), operator, approved);
866     }
867 
868     /**
869      * @dev See {IERC721-isApprovedForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
872         return _operatorApprovals[owner][operator];
873     }
874 
875     /**
876      * @dev See {IERC721-transferFrom}.
877      */
878     function transferFrom(
879         address from,
880         address to,
881         uint256 tokenId
882     ) public virtual override {
883         //solhint-disable-next-line max-line-length
884         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
885 
886         _transfer(from, to, tokenId);
887     }
888 
889     /**
890      * @dev See {IERC721-safeTransferFrom}.
891      */
892     function safeTransferFrom(
893         address from,
894         address to,
895         uint256 tokenId
896     ) public virtual override {
897         safeTransferFrom(from, to, tokenId, "");
898     }
899 
900     /**
901      * @dev See {IERC721-safeTransferFrom}.
902      */
903     function safeTransferFrom(
904         address from,
905         address to,
906         uint256 tokenId,
907         bytes memory _data
908     ) public virtual override {
909         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
910         _safeTransfer(from, to, tokenId, _data);
911     }
912 
913     /**
914      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
915      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
916      *
917      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
918      *
919      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
920      * implement alternative mechanisms to perform token transfer, such as signature-based.
921      *
922      * Requirements:
923      *
924      * - `from` cannot be the zero address.
925      * - `to` cannot be the zero address.
926      * - `tokenId` token must exist and be owned by `from`.
927      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
928      *
929      * Emits a {Transfer} event.
930      */
931     function _safeTransfer(
932         address from,
933         address to,
934         uint256 tokenId,
935         bytes memory _data
936     ) internal virtual {
937         _transfer(from, to, tokenId);
938         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
939     }
940 
941     /**
942      * @dev Returns whether `tokenId` exists.
943      *
944      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
945      *
946      * Tokens start existing when they are minted (`_mint`),
947      * and stop existing when they are burned (`_burn`).
948      */
949     function _exists(uint256 tokenId) internal view virtual returns (bool) {
950         return _owners[tokenId] != address(0);
951     }
952 
953     /**
954      * @dev Returns whether `spender` is allowed to manage `tokenId`.
955      *
956      * Requirements:
957      *
958      * - `tokenId` must exist.
959      */
960     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
961         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
962         address owner = ERC721.ownerOf(tokenId);
963         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
964     }
965 
966     /**
967      * @dev Safely mints `tokenId` and transfers it to `to`.
968      *
969      * Requirements:
970      *
971      * - `tokenId` must not exist.
972      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
973      *
974      * Emits a {Transfer} event.
975      */
976     function _safeMint(address to, uint256 tokenId) internal virtual {
977         _safeMint(to, tokenId, "");
978     }
979 
980     /**
981      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
982      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
983      */
984     function _safeMint(
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) internal virtual {
989         _mint(to, tokenId);
990         require(
991             _checkOnERC721Received(address(0), to, tokenId, _data),
992             "ERC721: transfer to non ERC721Receiver implementer"
993         );
994     }
995 
996     /**
997      * @dev Mints `tokenId` and transfers it to `to`.
998      *
999      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1000      *
1001      * Requirements:
1002      *
1003      * - `tokenId` must not exist.
1004      * - `to` cannot be the zero address.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function _mint(address to, uint256 tokenId) internal virtual {
1009         require(to != address(0), "ERC721: mint to the zero address");
1010         require(!_exists(tokenId), "ERC721: token already minted");
1011 
1012         _beforeTokenTransfer(address(0), to, tokenId);
1013 
1014         _balances[to] += 1;
1015         _owners[tokenId] = to;
1016 
1017         emit Transfer(address(0), to, tokenId);
1018 
1019         _afterTokenTransfer(address(0), to, tokenId);
1020     }
1021 
1022     /**
1023      * @dev Destroys `tokenId`.
1024      * The approval is cleared when the token is burned.
1025      *
1026      * Requirements:
1027      *
1028      * - `tokenId` must exist.
1029      *
1030      * Emits a {Transfer} event.
1031      */
1032     function _burn(uint256 tokenId) internal virtual {
1033         address owner = ERC721.ownerOf(tokenId);
1034 
1035         _beforeTokenTransfer(owner, address(0), tokenId);
1036 
1037         // Clear approvals
1038         _approve(address(0), tokenId);
1039 
1040         _balances[owner] -= 1;
1041         delete _owners[tokenId];
1042 
1043         emit Transfer(owner, address(0), tokenId);
1044 
1045         _afterTokenTransfer(owner, address(0), tokenId);
1046     }
1047 
1048     /**
1049      * @dev Transfers `tokenId` from `from` to `to`.
1050      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1051      *
1052      * Requirements:
1053      *
1054      * - `to` cannot be the zero address.
1055      * - `tokenId` token must be owned by `from`.
1056      *
1057      * Emits a {Transfer} event.
1058      */
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 tokenId
1063     ) internal virtual {
1064         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1065         require(to != address(0), "ERC721: transfer to the zero address");
1066 
1067         _beforeTokenTransfer(from, to, tokenId);
1068 
1069         // Clear approvals from the previous owner
1070         _approve(address(0), tokenId);
1071 
1072         _balances[from] -= 1;
1073         _balances[to] += 1;
1074         _owners[tokenId] = to;
1075 
1076         emit Transfer(from, to, tokenId);
1077 
1078         _afterTokenTransfer(from, to, tokenId);
1079     }
1080 
1081     /**
1082      * @dev Approve `to` to operate on `tokenId`
1083      *
1084      * Emits a {Approval} event.
1085      */
1086     function _approve(address to, uint256 tokenId) internal virtual {
1087         _tokenApprovals[tokenId] = to;
1088         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1089     }
1090 
1091     /**
1092      * @dev Approve `operator` to operate on all of `owner` tokens
1093      *
1094      * Emits a {ApprovalForAll} event.
1095      */
1096     function _setApprovalForAll(
1097         address owner,
1098         address operator,
1099         bool approved
1100     ) internal virtual {
1101         require(owner != operator, "ERC721: approve to caller");
1102         _operatorApprovals[owner][operator] = approved;
1103         emit ApprovalForAll(owner, operator, approved);
1104     }
1105 
1106     /**
1107      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1108      * The call is not executed if the target address is not a contract.
1109      *
1110      * @param from address representing the previous owner of the given token ID
1111      * @param to target address that will receive the tokens
1112      * @param tokenId uint256 ID of the token to be transferred
1113      * @param _data bytes optional data to send along with the call
1114      * @return bool whether the call correctly returned the expected magic value
1115      */
1116     function _checkOnERC721Received(
1117         address from,
1118         address to,
1119         uint256 tokenId,
1120         bytes memory _data
1121     ) private returns (bool) {
1122         if (to.isContract()) {
1123             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1124                 return retval == IERC721Receiver.onERC721Received.selector;
1125             } catch (bytes memory reason) {
1126                 if (reason.length == 0) {
1127                     revert("ERC721: transfer to non ERC721Receiver implementer");
1128                 } else {
1129                     assembly {
1130                         revert(add(32, reason), mload(reason))
1131                     }
1132                 }
1133             }
1134         } else {
1135             return true;
1136         }
1137     }
1138 
1139     /**
1140      * @dev Hook that is called before any token transfer. This includes minting
1141      * and burning.
1142      *
1143      * Calling conditions:
1144      *
1145      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1146      * transferred to `to`.
1147      * - When `from` is zero, `tokenId` will be minted for `to`.
1148      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1149      * - `from` and `to` are never both zero.
1150      *
1151      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1152      */
1153     function _beforeTokenTransfer(
1154         address from,
1155         address to,
1156         uint256 tokenId
1157     ) internal virtual {}
1158 
1159     /**
1160      * @dev Hook that is called after any transfer of tokens. This includes
1161      * minting and burning.
1162      *
1163      * Calling conditions:
1164      *
1165      * - when `from` and `to` are both non-zero.
1166      * - `from` and `to` are never both zero.
1167      *
1168      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1169      */
1170     function _afterTokenTransfer(
1171         address from,
1172         address to,
1173         uint256 tokenId
1174     ) internal virtual {}
1175 }
1176 
1177 // File: IBISChessclub.sol
1178 
1179 
1180 pragma solidity ^0.8.7;
1181 
1182 abstract contract CATS {
1183     function balanceOf(address owner) external virtual view returns (uint256 balance);
1184 }
1185 
1186 abstract contract FLS {
1187     function balanceOf(address owner) external virtual view returns (uint256 balance);
1188 }
1189 
1190 contract IBISChessclub is ERC721, Ownable {
1191     CATS private cats;
1192     FLS private fls;
1193 
1194     using Strings for uint256;
1195 
1196     address catsAdress = 0x568a1f8554Edcea5CB5F94E463ac69A9C49c0A2d;
1197     address flsAddress = 0xf11B3a52e636dD04aa740cC97C5813CAAb0b75d0;
1198 
1199     uint256 public firstPawnId = 382;
1200     uint256 public firstKnightId = 748;
1201     uint256 public firstBishopId = 1196;
1202     uint256 public firstRookId = 1617;
1203     uint256 public firstQueenId = 2053;
1204     uint256 public firstKingId = 2517;
1205     uint256 public firstSpecialId = 2967;
1206 
1207     uint256 public MAX_SUPPLY_PAWNS = 366;
1208     uint256 public MAX_SUPPLY_KNIGHTS = 448;
1209     uint256 public MAX_SUPPLY_BISHOPS = 421;
1210     uint256 public MAX_SUPPLY_ROOKS = 436;
1211     uint256 public MAX_SUPPLY_QUEENS = 464;
1212     uint256 public MAX_SUPPLY_KINGS = 450;
1213     uint256 public MAX_SUPPLY_SPECIAL = 175;
1214 
1215     uint256 public numSpecial = 0;
1216     uint256 public numKings = 0;
1217     uint256 public numQueens = 0;
1218     uint256 public numRooks = 0;
1219     uint256 public numBishops = 0;
1220     uint256 public numKnights = 0;
1221     uint256 public numPawns = 0;
1222 
1223     uint256 public pawnPrice =     31400000000000000;
1224     uint256 public knightPrice =   42000000000000000;
1225     uint256 public bishopPrice =   69000000000000000;
1226     uint256 public rookPrice =     89000000000000000;
1227     uint256 public queenPrice =   111100000000000000;
1228     uint256 public kingPrice =    130000000000000000;
1229     uint256 public specialPrice = 210000000000000000;
1230 
1231     uint256 public saleState = 0; // 0 = no sale, 1 = freemint, 2 = presale, 3 = public sale
1232 
1233     string private baseURI;
1234 
1235     bytes32 public freeMintRoot = 0x2b97f8602f78fbab8ac7bb9fef77d88b04f5c2b152c727328ced917ffae3ca13;
1236     bytes32 public whitelistRoot;
1237 
1238     mapping(address => uint256) public whiteListTx;
1239     mapping(address => uint256) public freemintTx;
1240 
1241     enum ChessPiece { Pawn, Knight, Bishop, Rook, Queen, King, Special }
1242 
1243     constructor() ERC721("Ibis Chess Club", "IBIS") {
1244         baseURI = "http://ibis.mintthepieces.com/metadata/";
1245 
1246         cats = CATS(catsAdress);
1247         fls = FLS(flsAddress);
1248     }
1249 
1250     function setSaleStatus(uint256 _saleState) external onlyOwner {  // 0 = no sale, 1 = freemint, 2 = presale, 3 = public sale
1251         require(_saleState >= 0 && _saleState < 4, "No such sale state");
1252         saleState = _saleState;
1253     }
1254 
1255     function getPiecePrices() external view returns(uint256[7] memory prices) {
1256         return [pawnPrice, knightPrice, bishopPrice, rookPrice, queenPrice, kingPrice, specialPrice];
1257     }
1258 
1259     function reservePieces(uint256 amount) external onlyOwner {
1260         uint256 nonce = 0;
1261         uint256 rand;
1262         for (uint256 i = 0; i < amount; i++) {
1263             rand = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % 100;
1264             if (rand < 14) {
1265                 // pawn
1266                 randomMintPiece(ChessPiece.Pawn, 1);
1267             } else if (rand < 29) {
1268                 // knight
1269                 randomMintPiece(ChessPiece.Knight, 1);
1270             } else if (rand < 44) {
1271                 // bishop
1272                 randomMintPiece(ChessPiece.Bishop, 1);
1273             } else if (rand < 60) {
1274                 // rook
1275                 randomMintPiece(ChessPiece.Rook, 1);
1276             } else if (rand < 78) {
1277                 // queen
1278                 randomMintPiece(ChessPiece.Queen, 1);
1279             } else if (rand < 93) {
1280                 // king
1281                 randomMintPiece(ChessPiece.King, 1);
1282             } else {
1283                 // special
1284                 randomMintPiece(ChessPiece.Special, 1);
1285             }
1286             nonce++;
1287         }
1288     }
1289 
1290     function setPiecePrices(uint256[] calldata prices) external onlyOwner {
1291         require(prices.length == 7, "Wrong number of parameters given");
1292         if (prices[0] > 0) {
1293             pawnPrice = prices[0];
1294         }
1295         if (prices[1] > 0) {
1296             knightPrice = prices[1];
1297         }
1298         if (prices[2] > 0) {
1299             bishopPrice = prices[2];
1300         }
1301         if (prices[3] > 0) {
1302             rookPrice = prices[3];
1303         }
1304         if (prices[4] > 0) {
1305             queenPrice = prices[4];
1306         }
1307         if (prices[5] > 0) {
1308             kingPrice = prices[5];
1309         }
1310         if (prices[6] > 0) {
1311             kingPrice = prices[6];
1312         }
1313     }
1314 
1315     function _baseURI() internal view override returns (string memory) {
1316         return baseURI;
1317     }
1318 
1319     function tokenURI(uint256 tokenId) public override view returns (string memory) {
1320         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
1321     }
1322 
1323     // set new freemint root
1324     function setFreeMintRoot(bytes32 _root) external onlyOwner {
1325         freeMintRoot = _root;
1326     }
1327 
1328     // set new whitelist root
1329     function setWhitelistRoot(bytes32 _root) external onlyOwner {
1330         whitelistRoot = _root;
1331     }
1332 
1333     function setBaseURI(string memory uri) public onlyOwner {
1334         baseURI = uri;
1335     }
1336 
1337     // emergency claim function if someone forgets to claim their free token
1338     function ownerClaimToken(uint256 id) external onlyOwner {
1339         require(!_exists(id), "Token already exists");
1340         _safeMint(msg.sender, id);
1341     }
1342 
1343     function freeClaimMint(bytes32[] calldata proof, uint256[] calldata tokenIds) external {
1344         require(saleState == 1, "Free claim not available right now");
1345         require(freemintTx[msg.sender] == 0, "Already claimed your tokens");
1346         bytes32 node = keccak256(abi.encodePacked(msg.sender));       
1347         require(MerkleProof.verify(proof, freeMintRoot, node), "Address is not available for free claim mint");
1348 
1349         for (uint256 i = 0; i < tokenIds.length; i++) {
1350             require(!_exists(tokenIds[i]), "Token already claimed");
1351         }
1352         freemintTx[msg.sender] = 1;
1353         for (uint256 i = 0; i < tokenIds.length; i++) {
1354             _safeMint(msg.sender, tokenIds[i]);
1355         }
1356     }
1357 
1358     function whitelistMint(bytes32[] calldata proof, uint256 typeId) external payable {
1359         require(saleState == 2, "Whitelist minting closed");
1360         require(whiteListTx[msg.sender] == 0, "Already have minted during presale");
1361         require(hasEnoughTokensSingle(typeId), "Would exceed maximum supply of this piece");
1362         require(checkValueOne(typeId, msg.value), "Incorrect value sent");
1363         bytes32 node = keccak256(abi.encodePacked(msg.sender));
1364         require(MerkleProof.verify(proof, whitelistRoot, node), "Address is not on whitelist");
1365 
1366         whiteListTx[msg.sender] = 1;
1367         randomMintPiece(ChessPiece(typeId), 1);
1368     }
1369 
1370     function mintFlsCats(uint256 typeId) external payable {
1371         require(saleState == 2, "Whitelist minting closed");
1372         require(whiteListTx[msg.sender] == 0, "Already have minted during presale");
1373         require(hasEnoughTokensSingle(typeId), "Would exceed maximum supply of this piece");
1374         require(checkValueOne(typeId, msg.value), "Incorrect value sent");
1375         require(fls.balanceOf(msg.sender) > 0 || cats.balanceOf(msg.sender) > 0, "Address does not own a Stranger nor a Cat");
1376 
1377         whiteListTx[msg.sender] = 1;
1378         randomMintPiece(ChessPiece(typeId), 1);
1379     }
1380 
1381     function randomNumber(uint256 max, uint256 offset, uint256 nonce) private view returns(uint256) {
1382         uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, nonce))) % max + offset;
1383         return rand;
1384     }
1385 
1386     function randomMintPiece(ChessPiece piece, uint256 amount) private {
1387         uint256 index;
1388         uint256 nonce = 0;
1389 
1390         if (piece == ChessPiece.Pawn) {
1391             for (uint256 i = 0; i < amount; i++) {
1392                 nonce = randomNumber(MAX_SUPPLY_PAWNS, firstPawnId, nonce);
1393                 index = randomNumber(MAX_SUPPLY_PAWNS, firstPawnId, nonce);
1394                 while (_exists(index)) {
1395                     nonce++;
1396                     index = randomNumber(MAX_SUPPLY_PAWNS, firstPawnId, nonce);
1397                 }
1398                 numPawns++;
1399                 _safeMint(msg.sender, index);
1400             }
1401         }
1402 
1403         if (piece == ChessPiece.Knight) {
1404             for (uint256 i = 0; i < amount; i++) {
1405                 nonce = randomNumber(MAX_SUPPLY_KNIGHTS, firstKnightId, nonce);
1406                 index = randomNumber(MAX_SUPPLY_KNIGHTS, firstKnightId, nonce);
1407                 while (_exists(index)) {
1408                     nonce++;
1409                     index = randomNumber(MAX_SUPPLY_KNIGHTS, firstKnightId, nonce);
1410                 }
1411                 numKnights++;
1412                 _safeMint(msg.sender, index);
1413             }
1414         }
1415 
1416         if (piece == ChessPiece.Bishop) {
1417             for (uint256 i = 0; i < amount; i++) {
1418                 nonce = randomNumber(MAX_SUPPLY_BISHOPS, firstBishopId, nonce);
1419                 index = randomNumber(MAX_SUPPLY_BISHOPS, firstBishopId, nonce);
1420                 while (_exists(index)) {
1421                     nonce++;
1422                     index = randomNumber(MAX_SUPPLY_BISHOPS, firstBishopId, nonce);
1423                 }
1424                 numBishops++;
1425                 _safeMint(msg.sender, index);
1426             }
1427         }
1428 
1429         if (piece == ChessPiece.Rook) {
1430             for (uint256 i = 0; i < amount; i++) {
1431                 nonce = randomNumber(MAX_SUPPLY_ROOKS, firstRookId, nonce);
1432                 index = randomNumber(MAX_SUPPLY_ROOKS, firstRookId, nonce);
1433                 while (_exists(index)) {
1434                     nonce++;
1435                     index = randomNumber(MAX_SUPPLY_ROOKS, firstRookId, nonce);
1436                 }
1437                 numRooks++;
1438                 _safeMint(msg.sender, index);
1439             }
1440         }
1441 
1442         if (piece == ChessPiece.Queen) {
1443             for (uint256 i = 0; i < amount; i++) {
1444                 nonce = randomNumber(MAX_SUPPLY_QUEENS, firstQueenId, nonce);
1445                 index = randomNumber(MAX_SUPPLY_QUEENS, firstQueenId, nonce);
1446                 while (_exists(index)) {
1447                     nonce++;
1448                     index = randomNumber(MAX_SUPPLY_QUEENS, firstQueenId, nonce);
1449                 }
1450                 numQueens++;
1451                 _safeMint(msg.sender, index);
1452             }
1453         }
1454 
1455         if (piece == ChessPiece.King) {
1456             for (uint256 i = 0; i < amount; i++) {
1457                 nonce = randomNumber(MAX_SUPPLY_KINGS, firstKingId, nonce);
1458                 index = randomNumber(MAX_SUPPLY_KINGS, firstKingId, nonce);
1459                 while (_exists(index)) {
1460                     nonce++;
1461                     index = randomNumber(MAX_SUPPLY_KINGS, firstKingId, nonce);
1462                 }
1463                 numKings++;
1464                 _safeMint(msg.sender, index);
1465             }
1466         }
1467 
1468         if (piece == ChessPiece.Special) {
1469             for (uint256 i = 0; i < amount; i++) {
1470                 nonce = randomNumber(MAX_SUPPLY_SPECIAL, firstSpecialId, nonce);
1471                 index = randomNumber(MAX_SUPPLY_SPECIAL, firstSpecialId, nonce);
1472                 while (_exists(index)) {
1473                     nonce++;
1474                     index = randomNumber(MAX_SUPPLY_SPECIAL, firstSpecialId, nonce);
1475                 }
1476                 numSpecial++;
1477                 _safeMint(msg.sender, index);
1478             }
1479         }
1480     }
1481 
1482     function hasEnoughTokensMultiple(uint256[] calldata ids) private view returns(bool) {
1483         return ids[0] + numPawns <= MAX_SUPPLY_PAWNS
1484                 && ids[1] + numKnights <= MAX_SUPPLY_KNIGHTS 
1485                 && ids[2] + numBishops <= MAX_SUPPLY_BISHOPS 
1486                 && ids[3] + numRooks <= MAX_SUPPLY_ROOKS 
1487                 && ids[4] + numQueens <= MAX_SUPPLY_QUEENS 
1488                 && ids[5] + numKings <= MAX_SUPPLY_KINGS
1489                 && ids[6] + numSpecial <= MAX_SUPPLY_SPECIAL;
1490     }
1491 
1492     function hasEnoughTokensSingle(uint256 typeId) private view returns(bool) {
1493         if (typeId == 0) {
1494             return numPawns + 1 <= MAX_SUPPLY_PAWNS;
1495         } else if (typeId == 1) {
1496             return numKnights + 1 <= MAX_SUPPLY_KNIGHTS;
1497         } else if (typeId == 2) {
1498             return numBishops + 1 <= MAX_SUPPLY_BISHOPS;
1499         } else if (typeId == 3) {
1500             return numRooks + 1 <= MAX_SUPPLY_ROOKS;
1501         } else if (typeId == 4) {
1502             return numQueens + 1 <= MAX_SUPPLY_QUEENS;
1503         } else if (typeId == 5) {
1504             return numKings + 1 <= MAX_SUPPLY_KINGS;
1505         } else {
1506             return numSpecial + 1 <= MAX_SUPPLY_SPECIAL;
1507         }
1508     }
1509 
1510     function checkValueMultiple(uint256[] calldata ids, uint256 value) private view returns(bool) {
1511         uint256 price = (ids[0] * pawnPrice) + (ids[1] * knightPrice) + (ids[2] * bishopPrice) + (ids[3] * rookPrice) + (ids[4] * queenPrice) + (ids[5] * kingPrice) + (ids[6] * specialPrice);
1512         return price == value;
1513     }
1514 
1515     function checkValueOne(uint256 typeId, uint256 value) private view returns(bool) {
1516         uint256 price;
1517 
1518         if (typeId == 0) {
1519             price = pawnPrice;
1520         } else if (typeId == 1) {
1521             price = knightPrice;
1522         } else if (typeId == 2) {
1523             price = bishopPrice;
1524         } else if (typeId == 3) {
1525             price = rookPrice;
1526         } else if (typeId == 4) {
1527             price = queenPrice;
1528         } else if (typeId == 5) {
1529             price = kingPrice;
1530         } else {
1531             price = specialPrice;
1532         }
1533         
1534         return price == value;
1535     }
1536 
1537     function publicMint(uint256[] calldata ids) external payable {
1538         require(saleState == 3, "Sale currently closed");
1539         require(checkValueMultiple(ids, msg.value), "Incorrect value sent");
1540         require(hasEnoughTokensMultiple(ids), "Order will exceed max number of tokens");
1541 
1542 
1543         if (ids[0] > 0) {
1544             randomMintPiece(ChessPiece.Pawn, ids[0]);
1545         }
1546 
1547         if (ids[1] > 0) {
1548             randomMintPiece(ChessPiece.Knight, ids[1]);
1549         }
1550 
1551         if (ids[2] > 0) {
1552             randomMintPiece(ChessPiece.Bishop, ids[2]);
1553         }
1554 
1555         if (ids[3] > 0) {
1556             randomMintPiece(ChessPiece.Rook, ids[3]);
1557         }
1558 
1559         if (ids[4] > 0) {
1560             randomMintPiece(ChessPiece.Queen, ids[4]);
1561         }
1562         
1563         if (ids[5] > 0) {
1564             randomMintPiece(ChessPiece.King, ids[5]);
1565         }
1566 
1567         if (ids[6] > 0) {
1568             randomMintPiece(ChessPiece.Special, ids[6]);
1569         }
1570     }
1571 
1572     function withdraw() public onlyOwner {
1573         uint256 balance = address(this).balance;
1574 
1575         address acct = 0x88110386fC2e19C7aECb9Ed242E65d5eEd165EE0;
1576         address studio = 0x388CcBf8c1A37F444DcFF6eDE0014DfA85BeDC1B;
1577 
1578         uint256 acct_share = balance / 100 * 85;
1579         uint256 studio_share = balance / 100 * 15;
1580 
1581         payable(acct).transfer(acct_share);
1582         payable(studio).transfer(studio_share);
1583     }
1584 
1585     function burn(uint256 tokenId) public virtual {
1586         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1587         _burn(tokenId);
1588     }
1589 }