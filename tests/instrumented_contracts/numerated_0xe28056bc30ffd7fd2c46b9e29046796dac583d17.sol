1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev These functions deal with verification of Merkle Trees proofs.
12  *
13  * The proofs can be generated using the JavaScript library
14  * https://github.com/miguelmota/merkletreejs[merkletreejs].
15  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
16  *
17  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
18  */
19 library MerkleProof {
20     /**
21      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
22      * defined by `root`. For this, a `proof` must be provided, containing
23      * sibling hashes on the branch from the leaf to the root of the tree. Each
24      * pair of leaves and each pair of pre-images are assumed to be sorted.
25      */
26     function verify(
27         bytes32[] memory proof,
28         bytes32 root,
29         bytes32 leaf
30     ) internal pure returns (bool) {
31         return processProof(proof, leaf) == root;
32     }
33 
34     /**
35      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
36      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
37      * hash matches the root of the tree. When processing the proof, the pairs
38      * of leafs & pre-images are assumed to be sorted.
39      *
40      * _Available since v4.4._
41      */
42     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
43         bytes32 computedHash = leaf;
44         for (uint256 i = 0; i < proof.length; i++) {
45             bytes32 proofElement = proof[i];
46             if (computedHash <= proofElement) {
47                 // Hash(current computed hash + current element of the proof)
48                 computedHash = _efficientHash(computedHash, proofElement);
49             } else {
50                 // Hash(current element of the proof + current computed hash)
51                 computedHash = _efficientHash(proofElement, computedHash);
52             }
53         }
54         return computedHash;
55     }
56 
57     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
58         assembly {
59             mstore(0x00, a)
60             mstore(0x20, b)
61             value := keccak256(0x00, 0x40)
62         }
63     }
64 }
65 
66 // File: default_workspace/contracts/contract.sol
67 
68 
69 
70 // File: @openzeppelin/contracts/utils/Strings.sol
71 
72 
73 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev String operations.
79  */
80 library Strings {
81     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
82 
83     /**
84      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
85      */
86     function toString(uint256 value) internal pure returns (string memory) {
87         // Inspired by OraclizeAPI's implementation - MIT licence
88         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
89 
90         if (value == 0) {
91             return "0";
92         }
93         uint256 temp = value;
94         uint256 digits;
95         while (temp != 0) {
96             digits++;
97             temp /= 10;
98         }
99         bytes memory buffer = new bytes(digits);
100         while (value != 0) {
101             digits -= 1;
102             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
103             value /= 10;
104         }
105         return string(buffer);
106     }
107 
108     /**
109      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
110      */
111     function toHexString(uint256 value) internal pure returns (string memory) {
112         if (value == 0) {
113             return "0x00";
114         }
115         uint256 temp = value;
116         uint256 length = 0;
117         while (temp != 0) {
118             length++;
119             temp >>= 8;
120         }
121         return toHexString(value, length);
122     }
123 
124     /**
125      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
126      */
127     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
128         bytes memory buffer = new bytes(2 * length + 2);
129         buffer[0] = "0";
130         buffer[1] = "x";
131         for (uint256 i = 2 * length + 1; i > 1; --i) {
132             buffer[i] = _HEX_SYMBOLS[value & 0xf];
133             value >>= 4;
134         }
135         require(value == 0, "Strings: hex length insufficient");
136         return string(buffer);
137     }
138 }
139 
140 // File: @openzeppelin/contracts/utils/Context.sol
141 
142 
143 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev Provides information about the current execution context, including the
149  * sender of the transaction and its data. While these are generally available
150  * via msg.sender and msg.data, they should not be accessed in such a direct
151  * manner, since when dealing with meta-transactions the account sending and
152  * paying for execution may not be the actual sender (as far as an application
153  * is concerned).
154  *
155  * This contract is only required for intermediate, library-like contracts.
156  */
157 abstract contract Context {
158     function _msgSender() internal view virtual returns (address) {
159         return msg.sender;
160     }
161 
162     function _msgData() internal view virtual returns (bytes calldata) {
163         return msg.data;
164     }
165 }
166 
167 // File: @openzeppelin/contracts/access/Ownable.sol
168 
169 
170 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
171 
172 pragma solidity ^0.8.0;
173 
174 
175 /**
176  * @dev Contract module which provides a basic access control mechanism, where
177  * there is an account (an owner) that can be granted exclusive access to
178  * specific functions.
179  *
180  * By default, the owner account will be the one that deploys the contract. This
181  * can later be changed with {transferOwnership}.
182  *
183  * This module is used through inheritance. It will make available the modifier
184  * `onlyOwner`, which can be applied to your functions to restrict their use to
185  * the owner.
186  */
187 abstract contract Ownable is Context {
188     address private _owner;
189 
190     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
191 
192     /**
193      * @dev Initializes the contract setting the deployer as the initial owner.
194      */
195     constructor() {
196         _transferOwnership(_msgSender());
197     }
198 
199     /**
200      * @dev Returns the address of the current owner.
201      */
202     function owner() public view virtual returns (address) {
203         return _owner;
204     }
205 
206     /**
207      * @dev Throws if called by any account other than the owner.
208      */
209     modifier onlyOwner() {
210         require(owner() == _msgSender(), "Ownable: caller is not the owner");
211         _;
212     }
213 
214     /**
215      * @dev Leaves the contract without owner. It will not be possible to call
216      * `onlyOwner` functions anymore. Can only be called by the current owner.
217      *
218      * NOTE: Renouncing ownership will leave the contract without an owner,
219      * thereby removing any functionality that is only available to the owner.
220      */
221     function renounceOwnership() public virtual onlyOwner {
222         _transferOwnership(address(0));
223     }
224 
225     /**
226      * @dev Transfers ownership of the contract to a new account (`newOwner`).
227      * Can only be called by the current owner.
228      */
229     function transferOwnership(address newOwner) public virtual onlyOwner {
230         require(newOwner != address(0), "Ownable: new owner is the zero address");
231         _transferOwnership(newOwner);
232     }
233 
234     /**
235      * @dev Transfers ownership of the contract to a new account (`newOwner`).
236      * Internal function without access restriction.
237      */
238     function _transferOwnership(address newOwner) internal virtual {
239         address oldOwner = _owner;
240         _owner = newOwner;
241         emit OwnershipTransferred(oldOwner, newOwner);
242     }
243 }
244 
245 // File: @openzeppelin/contracts/utils/Address.sol
246 
247 
248 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
249 
250 pragma solidity ^0.8.1;
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      *
273      * [IMPORTANT]
274      * ====
275      * You shouldn't rely on `isContract` to protect against flash loan attacks!
276      *
277      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
278      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
279      * constructor.
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // This method relies on extcodesize/address.code.length, which returns 0
284         // for contracts in construction, since the code is only stored at the end
285         // of the constructor execution.
286 
287         return account.code.length > 0;
288     }
289 
290     /**
291      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
292      * `recipient`, forwarding all available gas and reverting on errors.
293      *
294      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
295      * of certain opcodes, possibly making contracts go over the 2300 gas limit
296      * imposed by `transfer`, making them unable to receive funds via
297      * `transfer`. {sendValue} removes this limitation.
298      *
299      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
300      *
301      * IMPORTANT: because control is transferred to `recipient`, care must be
302      * taken to not create reentrancy vulnerabilities. Consider using
303      * {ReentrancyGuard} or the
304      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
305      */
306     function sendValue(address payable recipient, uint256 amount) internal {
307         require(address(this).balance >= amount, "Address: insufficient balance");
308 
309         (bool success, ) = recipient.call{value: amount}("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314      * @dev Performs a Solidity function call using a low level `call`. A
315      * plain `call` is an unsafe replacement for a function call: use this
316      * function instead.
317      *
318      * If `target` reverts with a revert reason, it is bubbled up by this
319      * function (like regular Solidity function calls).
320      *
321      * Returns the raw returned data. To convert to the expected return value,
322      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323      *
324      * Requirements:
325      *
326      * - `target` must be a contract.
327      * - calling `target` with `data` must not revert.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332         return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337      * `errorMessage` as a fallback revert reason when `target` reverts.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(
342         address target,
343         bytes memory data,
344         string memory errorMessage
345     ) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value
364     ) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
370      * with `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(
375         address target,
376         bytes memory data,
377         uint256 value,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         require(isContract(target), "Address: call to non-contract");
382 
383         (bool success, bytes memory returndata) = target.call{value: value}(data);
384         return verifyCallResult(success, returndata, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but performing a static call.
390      *
391      * _Available since v3.3._
392      */
393     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
394         return functionStaticCall(target, data, "Address: low-level static call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
399      * but performing a static call.
400      *
401      * _Available since v3.3._
402      */
403     function functionStaticCall(
404         address target,
405         bytes memory data,
406         string memory errorMessage
407     ) internal view returns (bytes memory) {
408         require(isContract(target), "Address: static call to non-contract");
409 
410         (bool success, bytes memory returndata) = target.staticcall(data);
411         return verifyCallResult(success, returndata, errorMessage);
412     }
413 
414     /**
415      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
416      * but performing a delegate call.
417      *
418      * _Available since v3.4._
419      */
420     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
421         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
426      * but performing a delegate call.
427      *
428      * _Available since v3.4._
429      */
430     function functionDelegateCall(
431         address target,
432         bytes memory data,
433         string memory errorMessage
434     ) internal returns (bytes memory) {
435         require(isContract(target), "Address: delegate call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.delegatecall(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
443      * revert reason using the provided one.
444      *
445      * _Available since v4.3._
446      */
447     function verifyCallResult(
448         bool success,
449         bytes memory returndata,
450         string memory errorMessage
451     ) internal pure returns (bytes memory) {
452         if (success) {
453             return returndata;
454         } else {
455             // Look for revert reason and bubble it up if present
456             if (returndata.length > 0) {
457                 // The easiest way to bubble the revert reason is using memory via assembly
458 
459                 assembly {
460                     let returndata_size := mload(returndata)
461                     revert(add(32, returndata), returndata_size)
462                 }
463             } else {
464                 revert(errorMessage);
465             }
466         }
467     }
468 }
469 
470 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @title ERC721 token receiver interface
479  * @dev Interface for any contract that wants to support safeTransfers
480  * from ERC721 asset contracts.
481  */
482 interface IERC721Receiver {
483     /**
484      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
485      * by `operator` from `from`, this function is called.
486      *
487      * It must return its Solidity selector to confirm the token transfer.
488      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
489      *
490      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
491      */
492     function onERC721Received(
493         address operator,
494         address from,
495         uint256 tokenId,
496         bytes calldata data
497     ) external returns (bytes4);
498 }
499 
500 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
501 
502 
503 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
504 
505 pragma solidity ^0.8.0;
506 
507 /**
508  * @dev Interface of the ERC165 standard, as defined in the
509  * https://eips.ethereum.org/EIPS/eip-165[EIP].
510  *
511  * Implementers can declare support of contract interfaces, which can then be
512  * queried by others ({ERC165Checker}).
513  *
514  * For an implementation, see {ERC165}.
515  */
516 interface IERC165 {
517     /**
518      * @dev Returns true if this contract implements the interface defined by
519      * `interfaceId`. See the corresponding
520      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
521      * to learn more about how these ids are created.
522      *
523      * This function call must use less than 30 000 gas.
524      */
525     function supportsInterface(bytes4 interfaceId) external view returns (bool);
526 }
527 
528 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
529 
530 
531 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
532 
533 pragma solidity ^0.8.0;
534 
535 
536 /**
537  * @dev Implementation of the {IERC165} interface.
538  *
539  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
540  * for the additional interface id that will be supported. For example:
541  *
542  * ```solidity
543  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
544  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
545  * }
546  * ```
547  *
548  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
549  */
550 abstract contract ERC165 is IERC165 {
551     /**
552      * @dev See {IERC165-supportsInterface}.
553      */
554     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
555         return interfaceId == type(IERC165).interfaceId;
556     }
557 }
558 
559 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
560 
561 
562 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
563 
564 pragma solidity ^0.8.0;
565 
566 
567 /**
568  * @dev Required interface of an ERC721 compliant contract.
569  */
570 interface IERC721 is IERC165 {
571     /**
572      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
573      */
574     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
575 
576     /**
577      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
578      */
579     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
580 
581     /**
582      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
583      */
584     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
585 
586     /**
587      * @dev Returns the number of tokens in ``owner``'s account.
588      */
589     function balanceOf(address owner) external view returns (uint256 balance);
590 
591     /**
592      * @dev Returns the owner of the `tokenId` token.
593      *
594      * Requirements:
595      *
596      * - `tokenId` must exist.
597      */
598     function ownerOf(uint256 tokenId) external view returns (address owner);
599 
600     /**
601      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
602      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
603      *
604      * Requirements:
605      *
606      * - `from` cannot be the zero address.
607      * - `to` cannot be the zero address.
608      * - `tokenId` token must exist and be owned by `from`.
609      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
610      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
611      *
612      * Emits a {Transfer} event.
613      */
614     function safeTransferFrom(
615         address from,
616         address to,
617         uint256 tokenId
618     ) external;
619 
620     /**
621      * @dev Transfers `tokenId` token from `from` to `to`.
622      *
623      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
624      *
625      * Requirements:
626      *
627      * - `from` cannot be the zero address.
628      * - `to` cannot be the zero address.
629      * - `tokenId` token must be owned by `from`.
630      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
631      *
632      * Emits a {Transfer} event.
633      */
634     function transferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
642      * The approval is cleared when the token is transferred.
643      *
644      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
645      *
646      * Requirements:
647      *
648      * - The caller must own the token or be an approved operator.
649      * - `tokenId` must exist.
650      *
651      * Emits an {Approval} event.
652      */
653     function approve(address to, uint256 tokenId) external;
654 
655     /**
656      * @dev Returns the account approved for `tokenId` token.
657      *
658      * Requirements:
659      *
660      * - `tokenId` must exist.
661      */
662     function getApproved(uint256 tokenId) external view returns (address operator);
663 
664     /**
665      * @dev Approve or remove `operator` as an operator for the caller.
666      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
667      *
668      * Requirements:
669      *
670      * - The `operator` cannot be the caller.
671      *
672      * Emits an {ApprovalForAll} event.
673      */
674     function setApprovalForAll(address operator, bool _approved) external;
675 
676     /**
677      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
678      *
679      * See {setApprovalForAll}
680      */
681     function isApprovedForAll(address owner, address operator) external view returns (bool);
682 
683     /**
684      * @dev Safely transfers `tokenId` token from `from` to `to`.
685      *
686      * Requirements:
687      *
688      * - `from` cannot be the zero address.
689      * - `to` cannot be the zero address.
690      * - `tokenId` token must exist and be owned by `from`.
691      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
692      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
693      *
694      * Emits a {Transfer} event.
695      */
696     function safeTransferFrom(
697         address from,
698         address to,
699         uint256 tokenId,
700         bytes calldata data
701     ) external;
702 }
703 
704 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
705 
706 
707 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
708 
709 pragma solidity ^0.8.0;
710 
711 
712 /**
713  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
714  * @dev See https://eips.ethereum.org/EIPS/eip-721
715  */
716 interface IERC721Enumerable is IERC721 {
717     /**
718      * @dev Returns the total amount of tokens stored by the contract.
719      */
720     function totalSupply() external view returns (uint256);
721 
722     /**
723      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
724      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
725      */
726     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
727 
728     /**
729      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
730      * Use along with {totalSupply} to enumerate all tokens.
731      */
732     function tokenByIndex(uint256 index) external view returns (uint256);
733 }
734 
735 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
745  * @dev See https://eips.ethereum.org/EIPS/eip-721
746  */
747 interface IERC721Metadata is IERC721 {
748     /**
749      * @dev Returns the token collection name.
750      */
751     function name() external view returns (string memory);
752 
753     /**
754      * @dev Returns the token collection symbol.
755      */
756     function symbol() external view returns (string memory);
757 
758     /**
759      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
760      */
761     function tokenURI(uint256 tokenId) external view returns (string memory);
762 }
763 
764 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
765 
766 
767 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
768 
769 pragma solidity ^0.8.0;
770 
771 
772 
773 
774 
775 
776 
777 
778 /**
779  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
780  * the Metadata extension, but not including the Enumerable extension, which is available separately as
781  * {ERC721Enumerable}.
782  */
783 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
784     using Address for address;
785     using Strings for uint256;
786 
787     // Token name
788     string private _name;
789 
790     // Token symbol
791     string private _symbol;
792 
793     // Mapping from token ID to owner address
794     mapping(uint256 => address) private _owners;
795 
796     // Mapping owner address to token count
797     mapping(address => uint256) private _balances;
798 
799     // Mapping from token ID to approved address
800     mapping(uint256 => address) private _tokenApprovals;
801 
802     // Mapping from owner to operator approvals
803     mapping(address => mapping(address => bool)) private _operatorApprovals;
804 
805     /**
806      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
807      */
808     constructor(string memory name_, string memory symbol_) {
809         _name = name_;
810         _symbol = symbol_;
811     }
812 
813     /**
814      * @dev See {IERC165-supportsInterface}.
815      */
816     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
817         return
818             interfaceId == type(IERC721).interfaceId ||
819             interfaceId == type(IERC721Metadata).interfaceId ||
820             super.supportsInterface(interfaceId);
821     }
822 
823     /**
824      * @dev See {IERC721-balanceOf}.
825      */
826     function balanceOf(address owner) public view virtual override returns (uint256) {
827         require(owner != address(0), "ERC721: balance query for the zero address");
828         return _balances[owner];
829     }
830 
831     /**
832      * @dev See {IERC721-ownerOf}.
833      */
834     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
835         address owner = _owners[tokenId];
836         require(owner != address(0), "ERC721: owner query for nonexistent token");
837         return owner;
838     }
839 
840     /**
841      * @dev See {IERC721Metadata-name}.
842      */
843     function name() public view virtual override returns (string memory) {
844         return _name;
845     }
846 
847     /**
848      * @dev See {IERC721Metadata-symbol}.
849      */
850     function symbol() public view virtual override returns (string memory) {
851         return _symbol;
852     }
853 
854     /**
855      * @dev See {IERC721Metadata-tokenURI}.
856      */
857     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
858         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
859 
860         string memory baseURI = _baseURI();
861         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
862     }
863 
864     /**
865      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
866      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
867      * by default, can be overriden in child contracts.
868      */
869     function _baseURI() internal view virtual returns (string memory) {
870         return "";
871     }
872 
873     /**
874      * @dev See {IERC721-approve}.
875      */
876     function approve(address to, uint256 tokenId) public virtual override {
877         address owner = ERC721.ownerOf(tokenId);
878         require(to != owner, "ERC721: approval to current owner");
879 
880         require(
881             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
882             "ERC721: approve caller is not owner nor approved for all"
883         );
884 
885         _approve(to, tokenId);
886     }
887 
888     /**
889      * @dev See {IERC721-getApproved}.
890      */
891     function getApproved(uint256 tokenId) public view virtual override returns (address) {
892         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
893 
894         return _tokenApprovals[tokenId];
895     }
896 
897     /**
898      * @dev See {IERC721-setApprovalForAll}.
899      */
900     function setApprovalForAll(address operator, bool approved) public virtual override {
901         _setApprovalForAll(_msgSender(), operator, approved);
902     }
903 
904     /**
905      * @dev See {IERC721-isApprovedForAll}.
906      */
907     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
908         return _operatorApprovals[owner][operator];
909     }
910 
911     /**
912      * @dev See {IERC721-transferFrom}.
913      */
914     function transferFrom(
915         address from,
916         address to,
917         uint256 tokenId
918     ) public virtual override {
919         //solhint-disable-next-line max-line-length
920         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
921 
922         _transfer(from, to, tokenId);
923     }
924 
925     /**
926      * @dev See {IERC721-safeTransferFrom}.
927      */
928     function safeTransferFrom(
929         address from,
930         address to,
931         uint256 tokenId
932     ) public virtual override {
933         safeTransferFrom(from, to, tokenId, "");
934     }
935 
936     /**
937      * @dev See {IERC721-safeTransferFrom}.
938      */
939     function safeTransferFrom(
940         address from,
941         address to,
942         uint256 tokenId,
943         bytes memory _data
944     ) public virtual override {
945         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
946         _safeTransfer(from, to, tokenId, _data);
947     }
948 
949     /**
950      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
951      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
952      *
953      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
954      *
955      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
956      * implement alternative mechanisms to perform token transfer, such as signature-based.
957      *
958      * Requirements:
959      *
960      * - `from` cannot be the zero address.
961      * - `to` cannot be the zero address.
962      * - `tokenId` token must exist and be owned by `from`.
963      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
964      *
965      * Emits a {Transfer} event.
966      */
967     function _safeTransfer(
968         address from,
969         address to,
970         uint256 tokenId,
971         bytes memory _data
972     ) internal virtual {
973         _transfer(from, to, tokenId);
974         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
975     }
976 
977     /**
978      * @dev Returns whether `tokenId` exists.
979      *
980      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
981      *
982      * Tokens start existing when they are minted (`_mint`),
983      * and stop existing when they are burned (`_burn`).
984      */
985     function _exists(uint256 tokenId) internal view virtual returns (bool) {
986         return _owners[tokenId] != address(0);
987     }
988 
989     /**
990      * @dev Returns whether `spender` is allowed to manage `tokenId`.
991      *
992      * Requirements:
993      *
994      * - `tokenId` must exist.
995      */
996     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
997         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
998         address owner = ERC721.ownerOf(tokenId);
999         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1000     }
1001 
1002     /**
1003      * @dev Safely mints `tokenId` and transfers it to `to`.
1004      *
1005      * Requirements:
1006      *
1007      * - `tokenId` must not exist.
1008      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1009      *
1010      * Emits a {Transfer} event.
1011      */
1012     function _safeMint(address to, uint256 tokenId) internal virtual {
1013         _safeMint(to, tokenId, "");
1014     }
1015 
1016     /**
1017      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1018      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1019      */
1020     function _safeMint(
1021         address to,
1022         uint256 tokenId,
1023         bytes memory _data
1024     ) internal virtual {
1025         _mint(to, tokenId);
1026         require(
1027             _checkOnERC721Received(address(0), to, tokenId, _data),
1028             "ERC721: transfer to non ERC721Receiver implementer"
1029         );
1030     }
1031 
1032     /**
1033      * @dev Mints `tokenId` and transfers it to `to`.
1034      *
1035      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1036      *
1037      * Requirements:
1038      *
1039      * - `tokenId` must not exist.
1040      * - `to` cannot be the zero address.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function _mint(address to, uint256 tokenId) internal virtual {
1045         require(to != address(0), "ERC721: mint to the zero address");
1046         require(!_exists(tokenId), "ERC721: token already minted");
1047 
1048         _beforeTokenTransfer(address(0), to, tokenId);
1049 
1050         _balances[to] += 1;
1051         _owners[tokenId] = to;
1052 
1053         emit Transfer(address(0), to, tokenId);
1054 
1055         _afterTokenTransfer(address(0), to, tokenId);
1056     }
1057 
1058     /**
1059      * @dev Destroys `tokenId`.
1060      * The approval is cleared when the token is burned.
1061      *
1062      * Requirements:
1063      *
1064      * - `tokenId` must exist.
1065      *
1066      * Emits a {Transfer} event.
1067      */
1068     function _burn(uint256 tokenId) internal virtual {
1069         address owner = ERC721.ownerOf(tokenId);
1070 
1071         _beforeTokenTransfer(owner, address(0), tokenId);
1072 
1073         // Clear approvals
1074         _approve(address(0), tokenId);
1075 
1076         _balances[owner] -= 1;
1077         delete _owners[tokenId];
1078 
1079         emit Transfer(owner, address(0), tokenId);
1080 
1081         _afterTokenTransfer(owner, address(0), tokenId);
1082     }
1083 
1084     /**
1085      * @dev Transfers `tokenId` from `from` to `to`.
1086      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1087      *
1088      * Requirements:
1089      *
1090      * - `to` cannot be the zero address.
1091      * - `tokenId` token must be owned by `from`.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function _transfer(
1096         address from,
1097         address to,
1098         uint256 tokenId
1099     ) internal virtual {
1100         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1101         require(to != address(0), "ERC721: transfer to the zero address");
1102 
1103         _beforeTokenTransfer(from, to, tokenId);
1104 
1105         // Clear approvals from the previous owner
1106         _approve(address(0), tokenId);
1107 
1108         _balances[from] -= 1;
1109         _balances[to] += 1;
1110         _owners[tokenId] = to;
1111 
1112         emit Transfer(from, to, tokenId);
1113 
1114         _afterTokenTransfer(from, to, tokenId);
1115     }
1116 
1117     /**
1118      * @dev Approve `to` to operate on `tokenId`
1119      *
1120      * Emits a {Approval} event.
1121      */
1122     function _approve(address to, uint256 tokenId) internal virtual {
1123         _tokenApprovals[tokenId] = to;
1124         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1125     }
1126 
1127     /**
1128      * @dev Approve `operator` to operate on all of `owner` tokens
1129      *
1130      * Emits a {ApprovalForAll} event.
1131      */
1132     function _setApprovalForAll(
1133         address owner,
1134         address operator,
1135         bool approved
1136     ) internal virtual {
1137         require(owner != operator, "ERC721: approve to caller");
1138         _operatorApprovals[owner][operator] = approved;
1139         emit ApprovalForAll(owner, operator, approved);
1140     }
1141 
1142     /**
1143      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1144      * The call is not executed if the target address is not a contract.
1145      *
1146      * @param from address representing the previous owner of the given token ID
1147      * @param to target address that will receive the tokens
1148      * @param tokenId uint256 ID of the token to be transferred
1149      * @param _data bytes optional data to send along with the call
1150      * @return bool whether the call correctly returned the expected magic value
1151      */
1152     function _checkOnERC721Received(
1153         address from,
1154         address to,
1155         uint256 tokenId,
1156         bytes memory _data
1157     ) private returns (bool) {
1158         if (to.isContract()) {
1159             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1160                 return retval == IERC721Receiver.onERC721Received.selector;
1161             } catch (bytes memory reason) {
1162                 if (reason.length == 0) {
1163                     revert("ERC721: transfer to non ERC721Receiver implementer");
1164                 } else {
1165                     assembly {
1166                         revert(add(32, reason), mload(reason))
1167                     }
1168                 }
1169             }
1170         } else {
1171             return true;
1172         }
1173     }
1174 
1175     /**
1176      * @dev Hook that is called before any token transfer. This includes minting
1177      * and burning.
1178      *
1179      * Calling conditions:
1180      *
1181      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1182      * transferred to `to`.
1183      * - When `from` is zero, `tokenId` will be minted for `to`.
1184      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1185      * - `from` and `to` are never both zero.
1186      *
1187      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1188      */
1189     function _beforeTokenTransfer(
1190         address from,
1191         address to,
1192         uint256 tokenId
1193     ) internal virtual {}
1194 
1195     /**
1196      * @dev Hook that is called after any transfer of tokens. This includes
1197      * minting and burning.
1198      *
1199      * Calling conditions:
1200      *
1201      * - when `from` and `to` are both non-zero.
1202      * - `from` and `to` are never both zero.
1203      *
1204      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1205      */
1206     function _afterTokenTransfer(
1207         address from,
1208         address to,
1209         uint256 tokenId
1210     ) internal virtual {}
1211 }
1212 
1213 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1214 
1215 
1216 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1217 
1218 pragma solidity ^0.8.0;
1219 
1220 
1221 
1222 /**
1223  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1224  * enumerability of all the token ids in the contract as well as all token ids owned by each
1225  * account.
1226  */
1227 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1228     // Mapping from owner to list of owned token IDs
1229     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1230 
1231     // Mapping from token ID to index of the owner tokens list
1232     mapping(uint256 => uint256) private _ownedTokensIndex;
1233 
1234     // Array with all token ids, used for enumeration
1235     uint256[] private _allTokens;
1236 
1237     // Mapping from token id to position in the allTokens array
1238     mapping(uint256 => uint256) private _allTokensIndex;
1239 
1240     /**
1241      * @dev See {IERC165-supportsInterface}.
1242      */
1243     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1244         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1245     }
1246 
1247     /**
1248      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1249      */
1250     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1251         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1252         return _ownedTokens[owner][index];
1253     }
1254 
1255     /**
1256      * @dev See {IERC721Enumerable-totalSupply}.
1257      */
1258     function totalSupply() public view virtual override returns (uint256) {
1259         return _allTokens.length;
1260     }
1261 
1262     /**
1263      * @dev See {IERC721Enumerable-tokenByIndex}.
1264      */
1265     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1266         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1267         return _allTokens[index];
1268     }
1269 
1270     /**
1271      * @dev Hook that is called before any token transfer. This includes minting
1272      * and burning.
1273      *
1274      * Calling conditions:
1275      *
1276      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1277      * transferred to `to`.
1278      * - When `from` is zero, `tokenId` will be minted for `to`.
1279      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1280      * - `from` cannot be the zero address.
1281      * - `to` cannot be the zero address.
1282      *
1283      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1284      */
1285     function _beforeTokenTransfer(
1286         address from,
1287         address to,
1288         uint256 tokenId
1289     ) internal virtual override {
1290         super._beforeTokenTransfer(from, to, tokenId);
1291 
1292         if (from == address(0)) {
1293             _addTokenToAllTokensEnumeration(tokenId);
1294         } else if (from != to) {
1295             _removeTokenFromOwnerEnumeration(from, tokenId);
1296         }
1297         if (to == address(0)) {
1298             _removeTokenFromAllTokensEnumeration(tokenId);
1299         } else if (to != from) {
1300             _addTokenToOwnerEnumeration(to, tokenId);
1301         }
1302     }
1303 
1304     /**
1305      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1306      * @param to address representing the new owner of the given token ID
1307      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1308      */
1309     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1310         uint256 length = ERC721.balanceOf(to);
1311         _ownedTokens[to][length] = tokenId;
1312         _ownedTokensIndex[tokenId] = length;
1313     }
1314 
1315     /**
1316      * @dev Private function to add a token to this extension's token tracking data structures.
1317      * @param tokenId uint256 ID of the token to be added to the tokens list
1318      */
1319     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1320         _allTokensIndex[tokenId] = _allTokens.length;
1321         _allTokens.push(tokenId);
1322     }
1323 
1324     /**
1325      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1326      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1327      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1328      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1329      * @param from address representing the previous owner of the given token ID
1330      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1331      */
1332     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1333         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1334         // then delete the last slot (swap and pop).
1335 
1336         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1337         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1338 
1339         // When the token to delete is the last token, the swap operation is unnecessary
1340         if (tokenIndex != lastTokenIndex) {
1341             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1342 
1343             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1344             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1345         }
1346 
1347         // This also deletes the contents at the last position of the array
1348         delete _ownedTokensIndex[tokenId];
1349         delete _ownedTokens[from][lastTokenIndex];
1350     }
1351 
1352     /**
1353      * @dev Private function to remove a token from this extension's token tracking data structures.
1354      * This has O(1) time complexity, but alters the order of the _allTokens array.
1355      * @param tokenId uint256 ID of the token to be removed from the tokens list
1356      */
1357     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1358         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1359         // then delete the last slot (swap and pop).
1360 
1361         uint256 lastTokenIndex = _allTokens.length - 1;
1362         uint256 tokenIndex = _allTokensIndex[tokenId];
1363 
1364         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1365         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1366         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1367         uint256 lastTokenId = _allTokens[lastTokenIndex];
1368 
1369         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1370         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1371 
1372         // This also deletes the contents at the last position of the array
1373         delete _allTokensIndex[tokenId];
1374         _allTokens.pop();
1375     }
1376 }
1377 
1378 // File: contracts/1_Storage.sol
1379 
1380 
1381 pragma solidity ^0.8.4;
1382 
1383 
1384 
1385 
1386 contract ClubHippo is ERC721Enumerable, Ownable {
1387     using Strings for uint256;
1388 
1389     uint256 public tokenPrice = 0.04 ether;
1390 
1391     uint256 public maxTokensPerMint = 6;
1392     uint256 public maxTokensPerWhitelistedAddress = 3;
1393 
1394     string public tokenBaseURI = "ipfs://QmT5R5TTaeWxAjp4eF95NqSYtaAB5rD2rh6z8NcLAqy4Pe/";
1395 
1396     uint256 public tokensToGift = 5;
1397     uint256 public tokensToBuyAmount = 3500 - tokensToGift;
1398 
1399     bool public hasPresaleStarted = false;
1400     bool public hasPublicSaleStarted = false;
1401 
1402     bytes32 public whitelistRoot;
1403     mapping(address => uint256) public presaleWhitelistPurchased;
1404 
1405     constructor() ERC721("Club Hippo", "HIPPO") {
1406         
1407     }
1408 
1409     function setMaxTokensPerMint(uint256 val) external onlyOwner {
1410         maxTokensPerMint = val;
1411     }
1412 
1413     function setMaxTokensPerWhitelistedAddress(uint256 val) external onlyOwner {
1414         maxTokensPerWhitelistedAddress = val;
1415     }
1416 
1417     function setPresale(bool val) external onlyOwner {
1418         hasPresaleStarted = val;
1419     }
1420 
1421     function setPublicSale(bool val) external onlyOwner {
1422         hasPublicSaleStarted = val;
1423     }
1424     
1425     function setTokenPrice(uint256 val) external onlyOwner {
1426       tokenPrice = val;
1427     }
1428 
1429     function gift(address[] calldata receivers) external onlyOwner {
1430         require(receivers.length <= tokensToGift, "Not enough tokens reserved for gifting");
1431 
1432         uint256 supply = totalSupply();
1433         for (uint256 i = 0; i < receivers.length; i++) {
1434             _safeMint(receivers[i], 1 + supply + i);
1435         }
1436 
1437         tokensToGift -= receivers.length;
1438     }
1439 
1440     function verify(address account, bytes32[] memory proof) public view returns (bool)
1441     {
1442         bytes32 leaf = keccak256(abi.encodePacked(account));
1443         return MerkleProof.verify(proof, whitelistRoot, leaf);
1444     }
1445 
1446 
1447     function mint(uint256 amount, bytes32[] memory proof) external payable {
1448         require(msg.value >= tokenPrice * amount, "Incorrect ETH");
1449         require(hasPresaleStarted, "Cannot mint before presale");
1450         require(hasPublicSaleStarted || verify(msg.sender, proof), "Buyer not whitelisted for presale");
1451         require(amount <= maxTokensPerMint, "Cannot mint more than the max tokens per mint");
1452         require(amount <= tokensToBuyAmount, "No tokens left for minting");
1453         require(hasPublicSaleStarted || (presaleWhitelistPurchased[msg.sender] + amount <= maxTokensPerWhitelistedAddress),
1454             "Cannot mint more than the max tokens per whitelisted address");
1455 
1456         uint256 supply = totalSupply();
1457         for(uint256 i = 0; i < amount; i++) {
1458             _safeMint(msg.sender, 1 + supply + i);
1459         }
1460 
1461         if (!hasPublicSaleStarted) {
1462             presaleWhitelistPurchased[msg.sender] += amount;
1463         }
1464 
1465         tokensToBuyAmount -= amount;
1466     }
1467 
1468     function _baseURI() internal view override(ERC721) returns (string memory) {
1469         return tokenBaseURI;
1470     }
1471    
1472     function setBaseURI(string calldata URI) external onlyOwner {
1473         tokenBaseURI = URI;
1474     }
1475 
1476     function setWhitelistRoot(bytes32 _whitelistRoot) public onlyOwner {
1477         whitelistRoot = _whitelistRoot;
1478     }
1479 
1480     function withdraw() external onlyOwner {
1481         require(payable(msg.sender).send(address(this).balance));
1482     }
1483 
1484     function tokenURI(uint256 tokenId) public view override(ERC721) returns (string memory) {
1485         return string(abi.encodePacked(super.tokenURI(tokenId), ".json"));
1486     }
1487 }