1 // SPDX-License-Identifier: MIT
2 
3 // File: contracts/dystopians copy.sol
4 
5 
6 
7 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
8 
9 
10 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev These functions deal with verification of Merkle Trees proofs.
16  *
17  * The proofs can be generated using the JavaScript library
18  * https://github.com/miguelmota/merkletreejs[merkletreejs].
19  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
20  *
21  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
22  */
23 library MerkleProof {
24     /**
25      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
26      * defined by `root`. For this, a `proof` must be provided, containing
27      * sibling hashes on the branch from the leaf to the root of the tree. Each
28      * pair of leaves and each pair of pre-images are assumed to be sorted.
29      */
30     function verify(
31         bytes32[] memory proof,
32         bytes32 root,
33         bytes32 leaf
34     ) internal pure returns (bool) {
35         return processProof(proof, leaf) == root;
36     }
37 
38     /**
39      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
40      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
41      * hash matches the root of the tree. When processing the proof, the pairs
42      * of leafs & pre-images are assumed to be sorted.
43      *
44      * _Available since v4.4._
45      */
46     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
47         bytes32 computedHash = leaf;
48         for (uint256 i = 0; i < proof.length; i++) {
49             bytes32 proofElement = proof[i];
50             if (computedHash <= proofElement) {
51                 // Hash(current computed hash + current element of the proof)
52                 computedHash = _efficientHash(computedHash, proofElement);
53             } else {
54                 // Hash(current element of the proof + current computed hash)
55                 computedHash = _efficientHash(proofElement, computedHash);
56             }
57         }
58         return computedHash;
59     }
60 
61     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
62         assembly {
63             mstore(0x00, a)
64             mstore(0x20, b)
65             value := keccak256(0x00, 0x40)
66         }
67     }
68 }
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
764 // File: erc721a/contracts/ERC721A.sol
765 
766 
767 // Creator: Chiru Labs
768 
769 pragma solidity ^0.8.4;
770 
771 
772 
773 
774 
775 
776 
777 
778 
779 error ApprovalCallerNotOwnerNorApproved();
780 error ApprovalQueryForNonexistentToken();
781 error ApproveToCaller();
782 error ApprovalToCurrentOwner();
783 error BalanceQueryForZeroAddress();
784 error MintedQueryForZeroAddress();
785 error BurnedQueryForZeroAddress();
786 error AuxQueryForZeroAddress();
787 error MintToZeroAddress();
788 error MintZeroQuantity();
789 error OwnerIndexOutOfBounds();
790 error OwnerQueryForNonexistentToken();
791 error TokenIndexOutOfBounds();
792 error TransferCallerNotOwnerNorApproved();
793 error TransferFromIncorrectOwner();
794 error TransferToNonERC721ReceiverImplementer();
795 error TransferToZeroAddress();
796 error URIQueryForNonexistentToken();
797 
798 /**
799  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
800  * the Metadata extension. Built to optimize for lower gas during batch mints.
801  *
802  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
803  *
804  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
805  *
806  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
807  */
808 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
809     using Address for address;
810     using Strings for uint256;
811 
812     // Compiler will pack this into a single 256bit word.
813     struct TokenOwnership {
814         // The address of the owner.
815         address addr;
816         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
817         uint64 startTimestamp;
818         // Whether the token has been burned.
819         bool burned;
820     }
821 
822     // Compiler will pack this into a single 256bit word.
823     struct AddressData {
824         // Realistically, 2**64-1 is more than enough.
825         uint64 balance;
826         // Keeps track of mint count with minimal overhead for tokenomics.
827         uint64 numberMinted;
828         // Keeps track of burn count with minimal overhead for tokenomics.
829         uint64 numberBurned;
830         // For miscellaneous variable(s) pertaining to the address
831         // (e.g. number of whitelist mint slots used).
832         // If there are multiple variables, please pack them into a uint64.
833         uint64 aux;
834     }
835 
836     // The tokenId of the next token to be minted.
837     uint256 internal _currentIndex;
838 
839     // The number of tokens burned.
840     uint256 internal _burnCounter;
841 
842     // Token name
843     string private _name;
844 
845     // Token symbol
846     string private _symbol;
847 
848     // Mapping from token ID to ownership details
849     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
850     mapping(uint256 => TokenOwnership) internal _ownerships;
851 
852     // Mapping owner address to address data
853     mapping(address => AddressData) private _addressData;
854 
855     // Mapping from token ID to approved address
856     mapping(uint256 => address) private _tokenApprovals;
857 
858     // Mapping from owner to operator approvals
859     mapping(address => mapping(address => bool)) private _operatorApprovals;
860 
861     constructor(string memory name_, string memory symbol_) {
862         _name = name_;
863         _symbol = symbol_;
864         _currentIndex = _startTokenId();
865     }
866 
867     /**
868      * To change the starting tokenId, please override this function.
869      */
870     function _startTokenId() internal view virtual returns (uint256) {
871         return 0;
872     }
873 
874     /**
875      * @dev See {IERC721Enumerable-totalSupply}.
876      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
877      */
878     function totalSupply() public view returns (uint256) {
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
900     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
901         return
902             interfaceId == type(IERC721).interfaceId ||
903             interfaceId == type(IERC721Metadata).interfaceId ||
904             super.supportsInterface(interfaceId);
905     }
906 
907     /**
908      * @dev See {IERC721-balanceOf}.
909      */
910     function balanceOf(address owner) public view override returns (uint256) {
911         if (owner == address(0)) revert BalanceQueryForZeroAddress();
912         return uint256(_addressData[owner].balance);
913     }
914 
915     /**
916      * Returns the number of tokens minted by `owner`.
917      */
918     function _numberMinted(address owner) internal view returns (uint256) {
919         if (owner == address(0)) revert MintedQueryForZeroAddress();
920         return uint256(_addressData[owner].numberMinted);
921     }
922 
923     /**
924      * Returns the number of tokens burned by or on behalf of `owner`.
925      */
926     function _numberBurned(address owner) internal view returns (uint256) {
927         if (owner == address(0)) revert BurnedQueryForZeroAddress();
928         return uint256(_addressData[owner].numberBurned);
929     }
930 
931     /**
932      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
933      */
934     function _getAux(address owner) internal view returns (uint64) {
935         if (owner == address(0)) revert AuxQueryForZeroAddress();
936         return _addressData[owner].aux;
937     }
938 
939     /**
940      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
941      * If there are multiple variables, please pack them into a uint64.
942      */
943     function _setAux(address owner, uint64 aux) internal {
944         if (owner == address(0)) revert AuxQueryForZeroAddress();
945         _addressData[owner].aux = aux;
946     }
947 
948     /**
949      * Gas spent here starts off proportional to the maximum mint batch size.
950      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
951      */
952     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
953         uint256 curr = tokenId;
954 
955         unchecked {
956             if (_startTokenId() <= curr && curr < _currentIndex) {
957                 TokenOwnership memory ownership = _ownerships[curr];
958                 if (!ownership.burned) {
959                     if (ownership.addr != address(0)) {
960                         return ownership;
961                     }
962                     // Invariant:
963                     // There will always be an ownership that has an address and is not burned
964                     // before an ownership that does not have an address and is not burned.
965                     // Hence, curr will not underflow.
966                     while (true) {
967                         curr--;
968                         ownership = _ownerships[curr];
969                         if (ownership.addr != address(0)) {
970                             return ownership;
971                         }
972                     }
973                 }
974             }
975         }
976         revert OwnerQueryForNonexistentToken();
977     }
978 
979     /**
980      * @dev See {IERC721-ownerOf}.
981      */
982     function ownerOf(uint256 tokenId) public view override returns (address) {
983         return ownershipOf(tokenId).addr;
984     }
985 
986     /**
987      * @dev See {IERC721Metadata-name}.
988      */
989     function name() public view virtual override returns (string memory) {
990         return _name;
991     }
992 
993     /**
994      * @dev See {IERC721Metadata-symbol}.
995      */
996     function symbol() public view virtual override returns (string memory) {
997         return _symbol;
998     }
999 
1000     /**
1001      * @dev See {IERC721Metadata-tokenURI}.
1002      */
1003     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1004         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1005 
1006         string memory baseURI = _baseURI();
1007         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1008     }
1009 
1010     /**
1011      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1012      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1013      * by default, can be overriden in child contracts.
1014      */
1015     function _baseURI() internal view virtual returns (string memory) {
1016         return '';
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-approve}.
1021      */
1022     function approve(address to, uint256 tokenId) public override {
1023         address owner = ERC721A.ownerOf(tokenId);
1024         if (to == owner) revert ApprovalToCurrentOwner();
1025 
1026         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1027             revert ApprovalCallerNotOwnerNorApproved();
1028         }
1029 
1030         _approve(to, tokenId, owner);
1031     }
1032 
1033     /**
1034      * @dev See {IERC721-getApproved}.
1035      */
1036     function getApproved(uint256 tokenId) public view override returns (address) {
1037         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1038 
1039         return _tokenApprovals[tokenId];
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-setApprovalForAll}.
1044      */
1045     function setApprovalForAll(address operator, bool approved) public override {
1046         if (operator == _msgSender()) revert ApproveToCaller();
1047 
1048         _operatorApprovals[_msgSender()][operator] = approved;
1049         emit ApprovalForAll(_msgSender(), operator, approved);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-isApprovedForAll}.
1054      */
1055     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1056         return _operatorApprovals[owner][operator];
1057     }
1058 
1059     /**
1060      * @dev See {IERC721-transferFrom}.
1061      */
1062     function transferFrom(
1063         address from,
1064         address to,
1065         uint256 tokenId
1066     ) public virtual override {
1067         _transfer(from, to, tokenId);
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-safeTransferFrom}.
1072      */
1073     function safeTransferFrom(
1074         address from,
1075         address to,
1076         uint256 tokenId
1077     ) public virtual override {
1078         safeTransferFrom(from, to, tokenId, '');
1079     }
1080 
1081     /**
1082      * @dev See {IERC721-safeTransferFrom}.
1083      */
1084     function safeTransferFrom(
1085         address from,
1086         address to,
1087         uint256 tokenId,
1088         bytes memory _data
1089     ) public virtual override {
1090         _transfer(from, to, tokenId);
1091         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1092             revert TransferToNonERC721ReceiverImplementer();
1093         }
1094     }
1095 
1096     /**
1097      * @dev Returns whether `tokenId` exists.
1098      *
1099      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1100      *
1101      * Tokens start existing when they are minted (`_mint`),
1102      */
1103     function _exists(uint256 tokenId) internal view returns (bool) {
1104         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1105             !_ownerships[tokenId].burned;
1106     }
1107 
1108     function _safeMint(address to, uint256 quantity) internal {
1109         _safeMint(to, quantity, '');
1110     }
1111 
1112     /**
1113      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1118      * - `quantity` must be greater than 0.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function _safeMint(
1123         address to,
1124         uint256 quantity,
1125         bytes memory _data
1126     ) internal {
1127         _mint(to, quantity, _data, true);
1128     }
1129 
1130     /**
1131      * @dev Mints `quantity` tokens and transfers them to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - `to` cannot be the zero address.
1136      * - `quantity` must be greater than 0.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _mint(
1141         address to,
1142         uint256 quantity,
1143         bytes memory _data,
1144         bool safe
1145     ) internal {
1146         uint256 startTokenId = _currentIndex;
1147         if (to == address(0)) revert MintToZeroAddress();
1148         if (quantity == 0) revert MintZeroQuantity();
1149 
1150         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1151 
1152         // Overflows are incredibly unrealistic.
1153         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1154         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1155         unchecked {
1156             _addressData[to].balance += uint64(quantity);
1157             _addressData[to].numberMinted += uint64(quantity);
1158 
1159             _ownerships[startTokenId].addr = to;
1160             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1161 
1162             uint256 updatedIndex = startTokenId;
1163             uint256 end = updatedIndex + quantity;
1164 
1165             if (safe && to.isContract()) {
1166                 do {
1167                     emit Transfer(address(0), to, updatedIndex);
1168                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1169                         revert TransferToNonERC721ReceiverImplementer();
1170                     }
1171                 } while (updatedIndex != end);
1172                 // Reentrancy protection
1173                 if (_currentIndex != startTokenId) revert();
1174             } else {
1175                 do {
1176                     emit Transfer(address(0), to, updatedIndex++);
1177                 } while (updatedIndex != end);
1178             }
1179             _currentIndex = updatedIndex;
1180         }
1181         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1182     }
1183 
1184     /**
1185      * @dev Transfers `tokenId` from `from` to `to`.
1186      *
1187      * Requirements:
1188      *
1189      * - `to` cannot be the zero address.
1190      * - `tokenId` token must be owned by `from`.
1191      *
1192      * Emits a {Transfer} event.
1193      */
1194     function _transfer(
1195         address from,
1196         address to,
1197         uint256 tokenId
1198     ) private {
1199         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1200 
1201         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1202             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1203             getApproved(tokenId) == _msgSender());
1204 
1205         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1206         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1207         if (to == address(0)) revert TransferToZeroAddress();
1208 
1209         _beforeTokenTransfers(from, to, tokenId, 1);
1210 
1211         // Clear approvals from the previous owner
1212         _approve(address(0), tokenId, prevOwnership.addr);
1213 
1214         // Underflow of the sender's balance is impossible because we check for
1215         // ownership above and the recipient's balance can't realistically overflow.
1216         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1217         unchecked {
1218             _addressData[from].balance -= 1;
1219             _addressData[to].balance += 1;
1220 
1221             _ownerships[tokenId].addr = to;
1222             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1223 
1224             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1225             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1226             uint256 nextTokenId = tokenId + 1;
1227             if (_ownerships[nextTokenId].addr == address(0)) {
1228                 // This will suffice for checking _exists(nextTokenId),
1229                 // as a burned slot cannot contain the zero address.
1230                 if (nextTokenId < _currentIndex) {
1231                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1232                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1233                 }
1234             }
1235         }
1236 
1237         emit Transfer(from, to, tokenId);
1238         _afterTokenTransfers(from, to, tokenId, 1);
1239     }
1240 
1241     /**
1242      * @dev Destroys `tokenId`.
1243      * The approval is cleared when the token is burned.
1244      *
1245      * Requirements:
1246      *
1247      * - `tokenId` must exist.
1248      *
1249      * Emits a {Transfer} event.
1250      */
1251     function _burn(uint256 tokenId) internal virtual {
1252         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1253 
1254         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1255 
1256         // Clear approvals from the previous owner
1257         _approve(address(0), tokenId, prevOwnership.addr);
1258 
1259         // Underflow of the sender's balance is impossible because we check for
1260         // ownership above and the recipient's balance can't realistically overflow.
1261         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1262         unchecked {
1263             _addressData[prevOwnership.addr].balance -= 1;
1264             _addressData[prevOwnership.addr].numberBurned += 1;
1265 
1266             // Keep track of who burned the token, and the timestamp of burning.
1267             _ownerships[tokenId].addr = prevOwnership.addr;
1268             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1269             _ownerships[tokenId].burned = true;
1270 
1271             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1272             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1273             uint256 nextTokenId = tokenId + 1;
1274             if (_ownerships[nextTokenId].addr == address(0)) {
1275                 // This will suffice for checking _exists(nextTokenId),
1276                 // as a burned slot cannot contain the zero address.
1277                 if (nextTokenId < _currentIndex) {
1278                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1279                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1280                 }
1281             }
1282         }
1283 
1284         emit Transfer(prevOwnership.addr, address(0), tokenId);
1285         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1286 
1287         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1288         unchecked {
1289             _burnCounter++;
1290         }
1291     }
1292 
1293     /**
1294      * @dev Approve `to` to operate on `tokenId`
1295      *
1296      * Emits a {Approval} event.
1297      */
1298     function _approve(
1299         address to,
1300         uint256 tokenId,
1301         address owner
1302     ) private {
1303         _tokenApprovals[tokenId] = to;
1304         emit Approval(owner, to, tokenId);
1305     }
1306 
1307     /**
1308      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1309      *
1310      * @param from address representing the previous owner of the given token ID
1311      * @param to target address that will receive the tokens
1312      * @param tokenId uint256 ID of the token to be transferred
1313      * @param _data bytes optional data to send along with the call
1314      * @return bool whether the call correctly returned the expected magic value
1315      */
1316     function _checkContractOnERC721Received(
1317         address from,
1318         address to,
1319         uint256 tokenId,
1320         bytes memory _data
1321     ) private returns (bool) {
1322         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1323             return retval == IERC721Receiver(to).onERC721Received.selector;
1324         } catch (bytes memory reason) {
1325             if (reason.length == 0) {
1326                 revert TransferToNonERC721ReceiverImplementer();
1327             } else {
1328                 assembly {
1329                     revert(add(32, reason), mload(reason))
1330                 }
1331             }
1332         }
1333     }
1334 
1335     /**
1336      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1337      * And also called before burning one token.
1338      *
1339      * startTokenId - the first token id to be transferred
1340      * quantity - the amount to be transferred
1341      *
1342      * Calling conditions:
1343      *
1344      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1345      * transferred to `to`.
1346      * - When `from` is zero, `tokenId` will be minted for `to`.
1347      * - When `to` is zero, `tokenId` will be burned by `from`.
1348      * - `from` and `to` are never both zero.
1349      */
1350     function _beforeTokenTransfers(
1351         address from,
1352         address to,
1353         uint256 startTokenId,
1354         uint256 quantity
1355     ) internal virtual {}
1356 
1357     /**
1358      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1359      * minting.
1360      * And also called after one token has been burned.
1361      *
1362      * startTokenId - the first token id to be transferred
1363      * quantity - the amount to be transferred
1364      *
1365      * Calling conditions:
1366      *
1367      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1368      * transferred to `to`.
1369      * - When `from` is zero, `tokenId` has been minted for `to`.
1370      * - When `to` is zero, `tokenId` has been burned by `from`.
1371      * - `from` and `to` are never both zero.
1372      */
1373     function _afterTokenTransfers(
1374         address from,
1375         address to,
1376         uint256 startTokenId,
1377         uint256 quantity
1378     ) internal virtual {}
1379 }
1380 
1381 // File: contracts/dystopian.sol
1382 
1383 
1384 
1385 
1386 
1387 
1388 pragma solidity ^0.8.12;
1389 
1390 contract Dystopians is ERC721A, Ownable {
1391     using Strings for uint256;
1392 
1393     uint256 public constant FOR_SALE_TOKENS = 666;
1394 
1395     uint256 public constant STAGE_STOPPED = 0;
1396     uint256 public constant STAGE_PRESALE = 1;
1397     uint256 public constant STAGE_PUBLIC  = 2;
1398     uint256 public currentStage = STAGE_STOPPED;
1399 
1400     uint256 public tokenPricePresale = 0.00666 ether;
1401     uint256 public tokenPricePublicSale = 0.0000000001 ether;
1402 
1403     uint256 public maxTokensPerAddressPresale = 1;
1404     uint256 public maxTokensPerAddress = 3;
1405     uint256 public maxTokensPerTransaction = maxTokensPerAddress;
1406 
1407     uint256 public presaleTotalLimit = 66;
1408 
1409     bytes32 public whitelistRootOG;
1410     bytes32 public whitelistRoot;
1411 
1412     string public tokenBaseURI = "ipfs://QmaAJtaajyVfiaY2Usc8fGjFVeJk1VRvCAPQ1tarEt6JyC/";
1413 
1414     uint256 public soldAmount = 0;
1415     mapping(address => uint256) public purchased;
1416 
1417     constructor() ERC721A("Dystopians", "DYST") {
1418         
1419     }
1420 
1421     function _startTokenId() internal pure override(ERC721A) returns (uint256) {
1422         return 1;
1423     }
1424 
1425     function stopSale() external onlyOwner {
1426         currentStage = STAGE_STOPPED;
1427     }
1428 
1429     function startPresale() external onlyOwner {
1430         currentStage = STAGE_PRESALE;
1431     }
1432 
1433     function startPublicSale() external onlyOwner {
1434         currentStage = STAGE_PUBLIC;
1435     }
1436 
1437     function setTokenPricePresale(uint256 val) external onlyOwner {
1438         tokenPricePresale = val;
1439     }
1440     
1441     function setTokenPricePublicSale(uint256 val) external onlyOwner {
1442         tokenPricePublicSale = val;
1443     }
1444 
1445     function setMaxTokensPerTransaction(uint256 val) external onlyOwner {
1446         maxTokensPerTransaction = val;
1447     }
1448 
1449     function setMaxTokensPerAddressPresale(uint256 val) external onlyOwner {
1450         maxTokensPerAddressPresale = val;
1451     }
1452 
1453     function setMaxTokensPerAddress(uint256 val) external onlyOwner {
1454         maxTokensPerAddress = val;
1455     }
1456 
1457     function setPresaleTotalLimit(uint256 val) external onlyOwner {
1458         presaleTotalLimit = val;
1459     }
1460 
1461     function setWhitelistRoot(bytes32 val) external onlyOwner {
1462         whitelistRoot = val;
1463     }
1464 
1465     function gift(uint256 amount, address to) external onlyOwner {
1466         require(soldAmount + amount <= FOR_SALE_TOKENS, "No tokens left");
1467         _safeMint(to, amount);
1468         soldAmount += amount;
1469     }
1470 
1471     function giftToMultiple(uint256 amount, address[] calldata toAddresses) external onlyOwner {
1472         uint256 totalAmount = amount * toAddresses.length;
1473         require(soldAmount + totalAmount <= FOR_SALE_TOKENS, "No tokens left");
1474 
1475         for (uint256 i = 0; i < toAddresses.length; i++) {
1476             _safeMint(toAddresses[i], amount);
1477         }
1478 
1479         soldAmount += totalAmount;
1480     }
1481 
1482     function tokenPrice() public view returns (uint256) {
1483         if (currentStage == STAGE_PUBLIC) {
1484             return tokenPricePublicSale;
1485         } else if (currentStage == STAGE_PRESALE) {
1486             return tokenPricePresale;
1487         } else {
1488             return 0;
1489         }
1490     }
1491 
1492     function getMaxTokensForPhase(address target, bytes32[] memory proof) public view returns (uint256) {
1493         bytes32 leaf = keccak256(abi.encodePacked(target));
1494 
1495         if (currentStage == STAGE_PUBLIC) {
1496             return maxTokensPerAddress;
1497         } else if (currentStage == STAGE_PRESALE) {
1498             if (MerkleProof.verify(proof, whitelistRoot, leaf)) {
1499                 return maxTokensPerAddressPresale;
1500             } else {
1501                 return 0;
1502             }
1503         } else {
1504             return 0;
1505         }
1506     }
1507 
1508     function safeSub(uint256 a, uint256 b) internal pure returns (uint256) {
1509         if (a < b) {
1510             return 0;
1511         }
1512         return a - b;
1513     }
1514 
1515     function getMaxTokensAllowed(address target, bytes32[] memory proof) public view returns (uint256) {
1516         uint256 maxAllowedTokens = getMaxTokensForPhase(target, proof);
1517 
1518         uint256 tokensLeftForAddress = safeSub(maxAllowedTokens, purchased[target]);
1519         maxAllowedTokens = min(maxAllowedTokens, tokensLeftForAddress);
1520 
1521         if (currentStage == STAGE_PRESALE) {
1522             uint256 presaleTokensLeft = safeSub(presaleTotalLimit, soldAmount);
1523             maxAllowedTokens = min(maxAllowedTokens, presaleTokensLeft);
1524         }
1525 
1526         uint256 publicSaleTokensLeft = safeSub(FOR_SALE_TOKENS, soldAmount);
1527         maxAllowedTokens = min(maxAllowedTokens, publicSaleTokensLeft);
1528 
1529         return min(maxAllowedTokens, maxTokensPerTransaction);
1530     }
1531 
1532     function getContractInfo(address target, bytes32[] memory proof) external view returns (
1533         uint256 _currentStage,
1534         uint256 _maxTokensAllowed,
1535         uint256 _tokenPrice,
1536         uint256 _soldAmount,
1537         uint256 _purchasedAmount,
1538         uint256 _presaleTotalLimit,
1539         bytes32 _whitelistRoot,
1540         bytes32 _whitelistRootOG
1541     ) {
1542         _currentStage = currentStage;
1543         _maxTokensAllowed = getMaxTokensAllowed(target, proof);
1544         _tokenPrice = tokenPrice(); 
1545         _soldAmount = soldAmount;
1546         _purchasedAmount = purchased[target];
1547         _presaleTotalLimit = presaleTotalLimit;
1548         _whitelistRoot = whitelistRoot;
1549         _whitelistRootOG = whitelistRootOG;
1550     }
1551 
1552     function mint(uint256 amount, bytes32[] memory proof) external payable {
1553         require(msg.value >= tokenPrice() * amount, "Incorrect ETH sent");
1554         require(amount <= getMaxTokensAllowed(msg.sender, proof), "Cannot mint more than the max allowed tokens");
1555 
1556         _safeMint(msg.sender, amount);
1557         purchased[msg.sender] += amount;
1558         soldAmount += amount;
1559     }
1560 
1561     function _baseURI() internal view override(ERC721A) returns (string memory) {
1562         return tokenBaseURI;
1563     }
1564    
1565     function setBaseURI(string calldata URI) external onlyOwner {
1566         tokenBaseURI = URI;
1567     }
1568 
1569     function withdraw() external onlyOwner {
1570         require(payable(msg.sender).send(address(this).balance));
1571     }
1572     
1573     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1574         return a < b ? a : b;
1575     }
1576 }