1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
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
17  *
18  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
19  * hashing, or use a hash function other than keccak256 for hashing leaves.
20  * This is because the concatenation of a sorted pair of internal nodes in
21  * the merkle tree could be reinterpreted as a leaf value.
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
39      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
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
473 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
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
490      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
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
562 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
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
601      * @dev Safely transfers `tokenId` token from `from` to `to`.
602      *
603      * Requirements:
604      *
605      * - `from` cannot be the zero address.
606      * - `to` cannot be the zero address.
607      * - `tokenId` token must exist and be owned by `from`.
608      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
609      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
610      *
611      * Emits a {Transfer} event.
612      */
613     function safeTransferFrom(
614         address from,
615         address to,
616         uint256 tokenId,
617         bytes calldata data
618     ) external;
619 
620     /**
621      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
622      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
623      *
624      * Requirements:
625      *
626      * - `from` cannot be the zero address.
627      * - `to` cannot be the zero address.
628      * - `tokenId` token must exist and be owned by `from`.
629      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
630      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
631      *
632      * Emits a {Transfer} event.
633      */
634     function safeTransferFrom(
635         address from,
636         address to,
637         uint256 tokenId
638     ) external;
639 
640     /**
641      * @dev Transfers `tokenId` token from `from` to `to`.
642      *
643      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `tokenId` token must be owned by `from`.
650      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
651      *
652      * Emits a {Transfer} event.
653      */
654     function transferFrom(
655         address from,
656         address to,
657         uint256 tokenId
658     ) external;
659 
660     /**
661      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
662      * The approval is cleared when the token is transferred.
663      *
664      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
665      *
666      * Requirements:
667      *
668      * - The caller must own the token or be an approved operator.
669      * - `tokenId` must exist.
670      *
671      * Emits an {Approval} event.
672      */
673     function approve(address to, uint256 tokenId) external;
674 
675     /**
676      * @dev Approve or remove `operator` as an operator for the caller.
677      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
678      *
679      * Requirements:
680      *
681      * - The `operator` cannot be the caller.
682      *
683      * Emits an {ApprovalForAll} event.
684      */
685     function setApprovalForAll(address operator, bool _approved) external;
686 
687     /**
688      * @dev Returns the account approved for `tokenId` token.
689      *
690      * Requirements:
691      *
692      * - `tokenId` must exist.
693      */
694     function getApproved(uint256 tokenId) external view returns (address operator);
695 
696     /**
697      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
698      *
699      * See {setApprovalForAll}
700      */
701     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
764 // File: contracts/ERC721A.sol
765 
766 
767 // Creator: Chiru Labs
768 
769 pragma solidity ^0.8.4;
770 
771 error ApprovalCallerNotOwnerNorApproved();
772 error ApprovalQueryForNonexistentToken();
773 error ApproveToCaller();
774 error ApprovalToCurrentOwner();
775 error BalanceQueryForZeroAddress();
776 error MintedQueryForZeroAddress();
777 error MintToZeroAddress();
778 error MintZeroQuantity();
779 error OwnerIndexOutOfBounds();
780 error OwnerQueryForNonexistentToken();
781 error TokenIndexOutOfBounds();
782 error TransferCallerNotOwnerNorApproved();
783 error TransferFromIncorrectOwner();
784 error TransferToNonERC721ReceiverImplementer();
785 error TransferToZeroAddress();
786 error UnableDetermineTokenOwner();
787 error URIQueryForNonexistentToken();
788 
789 /**
790  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
791  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
792  *
793  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
794  *
795  * Does not support burning tokens to address(0).
796  *
797  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
798  */
799 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
800     using Address for address;
801     using Strings for uint256;
802 
803     struct TokenOwnership {
804         address addr;
805         uint64 startTimestamp;
806     }
807 
808     struct AddressData {
809         uint128 balance;
810         uint128 numberMinted;
811     }
812 
813     uint256 internal _currentIndex;
814 
815     // Token name
816     string private _name;
817 
818     // Token symbol
819     string private _symbol;
820 
821     // Mapping from token ID to ownership details
822     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
823     mapping(uint256 => TokenOwnership) internal _ownerships;
824 
825     // Mapping owner address to address data
826     mapping(address => AddressData) private _addressData;
827 
828     // Mapping from token ID to approved address
829     mapping(uint256 => address) private _tokenApprovals;
830 
831     // Mapping from owner to operator approvals
832     mapping(address => mapping(address => bool)) private _operatorApprovals;
833 
834     constructor(string memory name_, string memory symbol_) {
835         _name = name_;
836         _symbol = symbol_;
837     }
838 
839     /**
840      * @dev See {IERC721Enumerable-totalSupply}.
841      */
842     function totalSupply() public view override returns (uint256) {
843         return _currentIndex;
844     }
845 
846     /**
847      * @dev See {IERC721Enumerable-tokenByIndex}.
848      */
849     function tokenByIndex(uint256 index) public view override returns (uint256) {
850         if (index >= totalSupply()) revert TokenIndexOutOfBounds();
851         return index;
852     }
853 
854     /**
855      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
856      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
857      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
858      */
859     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
860         if (index >= balanceOf(owner)) revert OwnerIndexOutOfBounds();
861         uint256 numMintedSoFar = totalSupply();
862         uint256 tokenIdsIdx;
863         address currOwnershipAddr;
864 
865         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
866         unchecked {
867             for (uint256 i; i < numMintedSoFar; i++) {
868                 TokenOwnership memory ownership = _ownerships[i];
869                 if (ownership.addr != address(0)) {
870                     currOwnershipAddr = ownership.addr;
871                 }
872                 if (currOwnershipAddr == owner) {
873                     if (tokenIdsIdx == index) {
874                         return i;
875                     }
876                     tokenIdsIdx++;
877                 }
878             }
879         }
880 
881         // Execution should never reach this point.
882         assert(false);
883     }
884 
885     /**
886      * @dev See {IERC165-supportsInterface}.
887      */
888     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
889         return
890             interfaceId == type(IERC721).interfaceId ||
891             interfaceId == type(IERC721Metadata).interfaceId ||
892             interfaceId == type(IERC721Enumerable).interfaceId ||
893             super.supportsInterface(interfaceId);
894     }
895 
896     /**
897      * @dev See {IERC721-balanceOf}.
898      */
899     function balanceOf(address owner) public view override returns (uint256) {
900         if (owner == address(0)) revert BalanceQueryForZeroAddress();
901         return uint256(_addressData[owner].balance);
902     }
903 
904     function _numberMinted(address owner) internal view returns (uint256) {
905         if (owner == address(0)) revert MintedQueryForZeroAddress();
906         return uint256(_addressData[owner].numberMinted);
907     }
908 
909     /**
910      * Gas spent here starts off proportional to the maximum mint batch size.
911      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
912      */
913     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
914         if (!_exists(tokenId)) revert OwnerQueryForNonexistentToken();
915 
916         unchecked {
917             for (uint256 curr = tokenId; curr >= 0; curr--) {
918                 TokenOwnership memory ownership = _ownerships[curr];
919                 if (ownership.addr != address(0)) {
920                     return ownership;
921                 }
922             }
923         }
924 
925         revert UnableDetermineTokenOwner();
926     }
927 
928     /**
929      * @dev See {IERC721-ownerOf}.
930      */
931     function ownerOf(uint256 tokenId) public view override returns (address) {
932         return ownershipOf(tokenId).addr;
933     }
934 
935     /**
936      * @dev See {IERC721Metadata-name}.
937      */
938     function name() public view virtual override returns (string memory) {
939         return _name;
940     }
941 
942     /**
943      * @dev See {IERC721Metadata-symbol}.
944      */
945     function symbol() public view virtual override returns (string memory) {
946         return _symbol;
947     }
948 
949     /**
950      * @dev See {IERC721Metadata-tokenURI}.
951      */
952     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
953         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
954 
955         string memory baseURI = _baseURI();
956         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
957     }
958 
959     /**
960      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
961      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
962      * by default, can be overriden in child contracts.
963      */
964     function _baseURI() internal view virtual returns (string memory) {
965         return '';
966     }
967 
968     /**
969      * @dev See {IERC721-approve}.
970      */
971     function approve(address to, uint256 tokenId) public override {
972         address owner = ERC721A.ownerOf(tokenId);
973         if (to == owner) revert ApprovalToCurrentOwner();
974 
975         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) revert ApprovalCallerNotOwnerNorApproved();
976 
977         _approve(to, tokenId, owner);
978     }
979 
980     /**
981      * @dev See {IERC721-getApproved}.
982      */
983     function getApproved(uint256 tokenId) public view override returns (address) {
984         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
985 
986         return _tokenApprovals[tokenId];
987     }
988 
989     /**
990      * @dev See {IERC721-setApprovalForAll}.
991      */
992     function setApprovalForAll(address operator, bool approved) public override {
993         if (operator == _msgSender()) revert ApproveToCaller();
994 
995         _operatorApprovals[_msgSender()][operator] = approved;
996         emit ApprovalForAll(_msgSender(), operator, approved);
997     }
998 
999     /**
1000      * @dev See {IERC721-isApprovedForAll}.
1001      */
1002     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1003         return _operatorApprovals[owner][operator];
1004     }
1005 
1006     /**
1007      * @dev See {IERC721-transferFrom}.
1008      */
1009     function transferFrom(
1010         address from,
1011         address to,
1012         uint256 tokenId
1013     ) public virtual override {
1014         _transfer(from, to, tokenId);
1015     }
1016 
1017     /**
1018      * @dev See {IERC721-safeTransferFrom}.
1019      */
1020     function safeTransferFrom(
1021         address from,
1022         address to,
1023         uint256 tokenId
1024     ) public virtual override {
1025         safeTransferFrom(from, to, tokenId, '');
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-safeTransferFrom}.
1030      */
1031     function safeTransferFrom(
1032         address from,
1033         address to,
1034         uint256 tokenId,
1035         bytes memory _data
1036     ) public override {
1037         _transfer(from, to, tokenId);
1038         if (!_checkOnERC721Received(from, to, tokenId, _data)) revert TransferToNonERC721ReceiverImplementer();
1039     }
1040 
1041     /**
1042      * @dev Returns whether `tokenId` exists.
1043      *
1044      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1045      *
1046      * Tokens start existing when they are minted (`_mint`),
1047      */
1048     function _exists(uint256 tokenId) internal view returns (bool) {
1049         return tokenId < _currentIndex;
1050     }
1051 
1052     function _safeMint(address to, uint256 quantity) internal {
1053         _safeMint(to, quantity, '');
1054     }
1055 
1056     /**
1057      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1058      *
1059      * Requirements:
1060      *
1061      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1062      * - `quantity` must be greater than 0.
1063      *
1064      * Emits a {Transfer} event.
1065      */
1066     function _safeMint(
1067         address to,
1068         uint256 quantity,
1069         bytes memory _data
1070     ) internal {
1071         _mint(to, quantity, _data, true);
1072     }
1073 
1074     /**
1075      * @dev Mints `quantity` tokens and transfers them to `to`.
1076      *
1077      * Requirements:
1078      *
1079      * - `to` cannot be the zero address.
1080      * - `quantity` must be greater than 0.
1081      *
1082      * Emits a {Transfer} event.
1083      */
1084     function _mint(
1085         address to,
1086         uint256 quantity,
1087         bytes memory _data,
1088         bool safe
1089     ) internal {
1090         uint256 startTokenId = _currentIndex;
1091         if (to == address(0)) revert MintToZeroAddress();
1092         if (quantity == 0) revert MintZeroQuantity();
1093 
1094         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1095 
1096         // Overflows are incredibly unrealistic.
1097         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1098         // updatedIndex overflows if _currentIndex + quantity > 1.56e77 (2**256) - 1
1099         unchecked {
1100             _addressData[to].balance += uint128(quantity);
1101             _addressData[to].numberMinted += uint128(quantity);
1102 
1103             _ownerships[startTokenId].addr = to;
1104             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1105 
1106             uint256 updatedIndex = startTokenId;
1107 
1108             for (uint256 i; i < quantity; i++) {
1109                 emit Transfer(address(0), to, updatedIndex);
1110                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1111                     revert TransferToNonERC721ReceiverImplementer();
1112                 }
1113 
1114                 updatedIndex++;
1115             }
1116 
1117             _currentIndex = updatedIndex;
1118         }
1119 
1120         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1121     }
1122 
1123     /**
1124      * @dev Transfers `tokenId` from `from` to `to`.
1125      *
1126      * Requirements:
1127      *
1128      * - `to` cannot be the zero address.
1129      * - `tokenId` token must be owned by `from`.
1130      *
1131      * Emits a {Transfer} event.
1132      */
1133     function _transfer(
1134         address from,
1135         address to,
1136         uint256 tokenId
1137     ) private {
1138         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1139 
1140         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1141             getApproved(tokenId) == _msgSender() ||
1142             isApprovedForAll(prevOwnership.addr, _msgSender()));
1143 
1144         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1145         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1146         if (to == address(0)) revert TransferToZeroAddress();
1147 
1148         _beforeTokenTransfers(from, to, tokenId, 1);
1149 
1150         // Clear approvals from the previous owner
1151         _approve(address(0), tokenId, prevOwnership.addr);
1152 
1153         // Underflow of the sender's balance is impossible because we check for
1154         // ownership above and the recipient's balance can't realistically overflow.
1155         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1156         unchecked {
1157             _addressData[from].balance -= 1;
1158             _addressData[to].balance += 1;
1159 
1160             _ownerships[tokenId].addr = to;
1161             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1162 
1163             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1164             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1165             uint256 nextTokenId = tokenId + 1;
1166             if (_ownerships[nextTokenId].addr == address(0)) {
1167                 if (_exists(nextTokenId)) {
1168                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1169                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1170                 }
1171             }
1172         }
1173 
1174         emit Transfer(from, to, tokenId);
1175         _afterTokenTransfers(from, to, tokenId, 1);
1176     }
1177 
1178     /**
1179      * @dev Approve `to` to operate on `tokenId`
1180      *
1181      * Emits a {Approval} event.
1182      */
1183     function _approve(
1184         address to,
1185         uint256 tokenId,
1186         address owner
1187     ) private {
1188         _tokenApprovals[tokenId] = to;
1189         emit Approval(owner, to, tokenId);
1190     }
1191 
1192     /**
1193      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1194      * The call is not executed if the target address is not a contract.
1195      *
1196      * @param from address representing the previous owner of the given token ID
1197      * @param to target address that will receive the tokens
1198      * @param tokenId uint256 ID of the token to be transferred
1199      * @param _data bytes optional data to send along with the call
1200      * @return bool whether the call correctly returned the expected magic value
1201      */
1202     function _checkOnERC721Received(
1203         address from,
1204         address to,
1205         uint256 tokenId,
1206         bytes memory _data
1207     ) private returns (bool) {
1208         if (to.isContract()) {
1209             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1210                 return retval == IERC721Receiver(to).onERC721Received.selector;
1211             } catch (bytes memory reason) {
1212                 if (reason.length == 0) revert TransferToNonERC721ReceiverImplementer();
1213                 else {
1214                     assembly {
1215                         revert(add(32, reason), mload(reason))
1216                     }
1217                 }
1218             }
1219         } else {
1220             return true;
1221         }
1222     }
1223 
1224     /**
1225      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1226      *
1227      * startTokenId - the first token id to be transferred
1228      * quantity - the amount to be transferred
1229      *
1230      * Calling conditions:
1231      *
1232      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1233      * transferred to `to`.
1234      * - When `from` is zero, `tokenId` will be minted for `to`.
1235      */
1236     function _beforeTokenTransfers(
1237         address from,
1238         address to,
1239         uint256 startTokenId,
1240         uint256 quantity
1241     ) internal virtual {}
1242 
1243     /**
1244      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1245      * minting.
1246      *
1247      * startTokenId - the first token id to be transferred
1248      * quantity - the amount to be transferred
1249      *
1250      * Calling conditions:
1251      *
1252      * - when `from` and `to` are both non-zero.
1253      * - `from` and `to` are never both zero.
1254      */
1255     function _afterTokenTransfers(
1256         address from,
1257         address to,
1258         uint256 startTokenId,
1259         uint256 quantity
1260     ) internal virtual {}
1261 }
1262 // File: contracts/NiceKids.sol
1263 
1264 pragma solidity ^0.8.0;
1265 
1266 contract NiceKids is ERC721A, Ownable{
1267     using Strings for uint256;
1268 
1269     // Max Supply
1270     uint256 public constant MaxSupply = 5555;
1271 
1272     // Prices
1273     uint256 public constant FreeSalePrice = 0.00 ether;
1274     uint256 public constant PrivateSalePrice = 0.12 ether;
1275     uint256 public PublicSalePrice = 0.14 ether;
1276 
1277     // Max Mint / Wallet
1278     uint256 public constant MaxFreeMint = 2;
1279     uint256 public constant MaxPrivateMint = 4;
1280 
1281     mapping(address => uint256) public totalFreeMint;
1282     mapping(address => uint256) public totalWhitelistMint;
1283 
1284     // Reveal and unreveal CIDs
1285     string private  baseTokenUri;
1286     string public   placeholderTokenUri;
1287 
1288     // Phases
1289     bool public FreeSale;
1290     bool public PrivateSale;
1291     bool public PublicSale;
1292     bool public isRevealed;
1293     bool public pause;
1294     bool public teamMinted;
1295 
1296     address[] public whitelistedAddresses;
1297 
1298 
1299     // Name and symbol
1300     constructor() ERC721A("NiceKids", "NK"){
1301 
1302     }
1303 
1304     modifier callerIsUser() {
1305         require(tx.origin == msg.sender, "Cannot be called by a contract");
1306         _;
1307     }
1308 
1309     
1310     function FreeMint(uint256 _quantity) external payable callerIsUser{
1311         require(FreeSale, "Free sale not yet active.");
1312         require(isWhitelisted(msg.sender), "user is not whitelisted");
1313         require((totalSupply() + _quantity) <= MaxSupply, "Beyond max supply");
1314         require((totalFreeMint[msg.sender] + _quantity)  <= MaxFreeMint, "Cannot mint beyond whitelist max mint!");
1315         require(msg.value >= (FreeSalePrice * _quantity), "Payment is below the price");
1316         
1317         totalFreeMint[msg.sender] += _quantity;
1318         _safeMint(msg.sender, _quantity);
1319     }
1320 
1321     function PrivateMint(uint256 _quantity) external payable callerIsUser{
1322         require(PrivateSale, "Private sale not yet active.");
1323         require(isWhitelisted(msg.sender), "user is not whitelisted");
1324         require((totalSupply() + _quantity) <= MaxSupply, "Beyond max supply");
1325         require((totalWhitelistMint[msg.sender] + _quantity)  <= MaxPrivateMint, "Cannot mint beyond whitelist max mint!");
1326         require(msg.value >= (PrivateSalePrice * _quantity), "Payment is below the price");
1327        
1328 
1329         totalWhitelistMint[msg.sender] += _quantity;
1330         _safeMint(msg.sender, _quantity);
1331     }
1332 
1333     function PublicMint(uint256 _quantity) external payable callerIsUser{
1334         require(PublicSale, "Public sale not yet active.");
1335         require((totalSupply() + _quantity) <= MaxSupply, "Beyond Max Supply");
1336         require(msg.value >= (PublicSalePrice * _quantity), "Payment is below the price");
1337 
1338         _safeMint(msg.sender, _quantity);
1339     }
1340 
1341     function teamMint() external onlyOwner{
1342         require(!teamMinted, "Team already minted");
1343         require((totalSupply() + 300) <= MaxSupply, "Beyond Max Supply");
1344         teamMinted = true;
1345         _safeMint(msg.sender, 300);
1346     }
1347 
1348     function _baseURI() internal view virtual override returns (string memory) {
1349         return baseTokenUri;
1350     }
1351 
1352     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1353         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1354 
1355         uint256 trueId = tokenId + 1;
1356 
1357         if(!isRevealed){
1358             return placeholderTokenUri;
1359         }
1360         
1361         return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, trueId.toString(), ".json")) : "";
1362     }
1363 
1364     function walletOf() external view returns(uint256[] memory){
1365         address _owner = msg.sender;
1366         uint256 numberOfOwnedNFT = balanceOf(_owner);
1367         uint256[] memory ownerIds = new uint256[](numberOfOwnedNFT);
1368 
1369         for(uint256 index = 0; index < numberOfOwnedNFT; index++){
1370             ownerIds[index] = tokenOfOwnerByIndex(_owner, index);
1371         }
1372 
1373         return ownerIds;
1374     }
1375 
1376     function airdrop(address _to, uint _quantity) external onlyOwner {
1377     require(totalSupply() + _quantity <= MaxSupply, "Reached max Supply");
1378      _safeMint(_to, _quantity);
1379     }
1380 
1381     
1382     function whitelistUsers(address[] calldata _users) public onlyOwner {
1383     delete whitelistedAddresses;
1384     whitelistedAddresses = _users;
1385     }
1386 
1387     function isWhitelisted(address _user) public view returns (bool) {
1388     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1389       if (whitelistedAddresses[i] == _user) {
1390           return true;
1391       }
1392     }
1393     return false;
1394   }
1395 
1396     function setTokenUri(string memory _baseTokenUri) external onlyOwner{
1397         baseTokenUri = _baseTokenUri;
1398     }
1399     function setPlaceHolderUri(string memory _placeholderTokenUri) external onlyOwner{
1400         placeholderTokenUri = _placeholderTokenUri;
1401     }
1402 
1403     function setPublicSalePrice(uint256 _newPublicSalePrice) public onlyOwner {
1404     PublicSalePrice = _newPublicSalePrice;
1405   }
1406 
1407 
1408     function togglePause() external onlyOwner{
1409         pause = !pause;
1410     }
1411 
1412     function toggleFreeSale() external onlyOwner{
1413         FreeSale = !FreeSale;
1414     }
1415 
1416     function togglePrivateSale() external onlyOwner{
1417         PrivateSale = !PrivateSale;
1418     }
1419 
1420     function togglePublicSale() external onlyOwner{
1421         PublicSale = !PublicSale;
1422     }
1423 
1424     function toggleReveal() external onlyOwner{
1425         isRevealed = !isRevealed;
1426     }
1427 
1428     function withdraw() external onlyOwner{
1429         uint256 withdrawAmount_30A = address(this).balance * 30/100;
1430         payable(0xE2d71B350421Fc1610cFeB2F0c41712daBFe13a2).transfer(withdrawAmount_30A);
1431         uint256 withdrawAmount_30B = address(this).balance * 30/100;
1432         payable(0xf6E76D756726C6cDB523D68835316e5f951260BE).transfer(withdrawAmount_30B);
1433         uint256 withdrawAmount_30C = address(this).balance * 30/100;
1434         payable(0xa7a2EF417075410c652520f8c22Cd2f0231dC284).transfer(withdrawAmount_30C);
1435         uint256 withdrawAmount_10 = address(this).balance * 10/100;
1436         payable(0x6Fbd09CcD3f389412B37C74286Db5941A1bcE02e).transfer(withdrawAmount_10);
1437         
1438         
1439         payable(msg.sender).transfer(address(this).balance);
1440     }
1441 }