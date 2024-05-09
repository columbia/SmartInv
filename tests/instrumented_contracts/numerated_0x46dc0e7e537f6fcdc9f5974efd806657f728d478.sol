1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-06
3 */
4 
5 //SPDX-License-Identifier: MIT
6 /**
7  *Submitted for verification at Etherscan.io on 2022-03-05
8 */
9 
10 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
11 
12 
13 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
14 
15 pragma solidity ^0.8.0;
16 
17 /**
18  * @dev These functions deal with verification of Merkle Trees proofs.
19  *
20  * The proofs can be generated using the JavaScript library
21  * https://github.com/miguelmota/merkletreejs[merkletreejs].
22  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
23  *
24  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
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
42      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
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
170 // File: @openzeppelin/contracts/access/Ownable.sol
171 
172 
173 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
174 
175 pragma solidity ^0.8.0;
176 
177 
178 /**
179  * @dev Contract module which provides a basic access control mechanism, where
180  * there is an account (an owner) that can be granted exclusive access to
181  * specific functions.
182  *
183  * By default, the owner account will be the one that deploys the contract. This
184  * can later be changed with {transferOwnership}.
185  *
186  * This module is used through inheritance. It will make available the modifier
187  * `onlyOwner`, which can be applied to your functions to restrict their use to
188  * the owner.
189  */
190 abstract contract Ownable is Context {
191     address private _owner;
192 
193     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
194 
195     /**
196      * @dev Initializes the contract setting the deployer as the initial owner.
197      */
198     constructor() {
199         _transferOwnership(_msgSender());
200     }
201 
202     /**
203      * @dev Returns the address of the current owner.
204      */
205     function owner() public view virtual returns (address) {
206         return _owner;
207     }
208 
209     /**
210      * @dev Throws if called by any account other than the owner.
211      */
212     modifier onlyOwner() {
213         require(owner() == _msgSender(), "Ownable: caller is not the owner");
214         _;
215     }
216 
217     /**
218      * @dev Leaves the contract without owner. It will not be possible to call
219      * `onlyOwner` functions anymore. Can only be called by the current owner.
220      *
221      * NOTE: Renouncing ownership will leave the contract without an owner,
222      * thereby removing any functionality that is only available to the owner.
223      */
224     function renounceOwnership() public virtual onlyOwner {
225         _transferOwnership(address(0));
226     }
227 
228     /**
229      * @dev Transfers ownership of the contract to a new account (`newOwner`).
230      * Can only be called by the current owner.
231      */
232     function transferOwnership(address newOwner) public virtual onlyOwner {
233         require(newOwner != address(0), "Ownable: new owner is the zero address");
234         _transferOwnership(newOwner);
235     }
236 
237     /**
238      * @dev Transfers ownership of the contract to a new account (`newOwner`).
239      * Internal function without access restriction.
240      */
241     function _transferOwnership(address newOwner) internal virtual {
242         address oldOwner = _owner;
243         _owner = newOwner;
244         emit OwnershipTransferred(oldOwner, newOwner);
245     }
246 }
247 
248 // File: @openzeppelin/contracts/utils/Address.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
252 
253 pragma solidity ^0.8.1;
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      *
276      * [IMPORTANT]
277      * ====
278      * You shouldn't rely on `isContract` to protect against flash loan attacks!
279      *
280      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
281      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
282      * constructor.
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // This method relies on extcodesize/address.code.length, which returns 0
287         // for contracts in construction, since the code is only stored at the end
288         // of the constructor execution.
289 
290         return account.code.length > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         (bool success, ) = recipient.call{value: amount}("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain `call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335         return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal returns (bytes memory) {
349         return functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(
364         address target,
365         bytes memory data,
366         uint256 value
367     ) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value,
381         string memory errorMessage
382     ) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         require(isContract(target), "Address: call to non-contract");
385 
386         (bool success, bytes memory returndata) = target.call{value: value}(data);
387         return verifyCallResult(success, returndata, errorMessage);
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
392      * but performing a static call.
393      *
394      * _Available since v3.3._
395      */
396     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
397         return functionStaticCall(target, data, "Address: low-level static call failed");
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
402      * but performing a static call.
403      *
404      * _Available since v3.3._
405      */
406     function functionStaticCall(
407         address target,
408         bytes memory data,
409         string memory errorMessage
410     ) internal view returns (bytes memory) {
411         require(isContract(target), "Address: static call to non-contract");
412 
413         (bool success, bytes memory returndata) = target.staticcall(data);
414         return verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419      * but performing a delegate call.
420      *
421      * _Available since v3.4._
422      */
423     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
424         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429      * but performing a delegate call.
430      *
431      * _Available since v3.4._
432      */
433     function functionDelegateCall(
434         address target,
435         bytes memory data,
436         string memory errorMessage
437     ) internal returns (bytes memory) {
438         require(isContract(target), "Address: delegate call to non-contract");
439 
440         (bool success, bytes memory returndata) = target.delegatecall(data);
441         return verifyCallResult(success, returndata, errorMessage);
442     }
443 
444     /**
445      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
446      * revert reason using the provided one.
447      *
448      * _Available since v4.3._
449      */
450     function verifyCallResult(
451         bool success,
452         bytes memory returndata,
453         string memory errorMessage
454     ) internal pure returns (bytes memory) {
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 assembly {
463                     let returndata_size := mload(returndata)
464                     revert(add(32, returndata), returndata_size)
465                 }
466             } else {
467                 revert(errorMessage);
468             }
469         }
470     }
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @title ERC721 token receiver interface
482  * @dev Interface for any contract that wants to support safeTransfers
483  * from ERC721 asset contracts.
484  */
485 interface IERC721Receiver {
486     /**
487      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
488      * by `operator` from `from`, this function is called.
489      *
490      * It must return its Solidity selector to confirm the token transfer.
491      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
492      *
493      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
494      */
495     function onERC721Received(
496         address operator,
497         address from,
498         uint256 tokenId,
499         bytes calldata data
500     ) external returns (bytes4);
501 }
502 
503 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
504 
505 
506 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
507 
508 pragma solidity ^0.8.0;
509 
510 /**
511  * @dev Interface of the ERC165 standard, as defined in the
512  * https://eips.ethereum.org/EIPS/eip-165[EIP].
513  *
514  * Implementers can declare support of contract interfaces, which can then be
515  * queried by others ({ERC165Checker}).
516  *
517  * For an implementation, see {ERC165}.
518  */
519 interface IERC165 {
520     /**
521      * @dev Returns true if this contract implements the interface defined by
522      * `interfaceId`. See the corresponding
523      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
524      * to learn more about how these ids are created.
525      *
526      * This function call must use less than 30 000 gas.
527      */
528     function supportsInterface(bytes4 interfaceId) external view returns (bool);
529 }
530 
531 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 
539 /**
540  * @dev Implementation of the {IERC165} interface.
541  *
542  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
543  * for the additional interface id that will be supported. For example:
544  *
545  * ```solidity
546  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
547  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
548  * }
549  * ```
550  *
551  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
552  */
553 abstract contract ERC165 is IERC165 {
554     /**
555      * @dev See {IERC165-supportsInterface}.
556      */
557     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
558         return interfaceId == type(IERC165).interfaceId;
559     }
560 }
561 
562 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
563 
564 
565 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
566 
567 pragma solidity ^0.8.0;
568 
569 
570 /**
571  * @dev Required interface of an ERC721 compliant contract.
572  */
573 interface IERC721 is IERC165 {
574     /**
575      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
576      */
577     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
578 
579     /**
580      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
581      */
582     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
583 
584     /**
585      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
586      */
587     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
588 
589     /**
590      * @dev Returns the number of tokens in ``owner``'s account.
591      */
592     function balanceOf(address owner) external view returns (uint256 balance);
593 
594     /**
595      * @dev Returns the owner of the `tokenId` token.
596      *
597      * Requirements:
598      *
599      * - `tokenId` must exist.
600      */
601     function ownerOf(uint256 tokenId) external view returns (address owner);
602 
603     /**
604      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
605      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
606      *
607      * Requirements:
608      *
609      * - `from` cannot be the zero address.
610      * - `to` cannot be the zero address.
611      * - `tokenId` token must exist and be owned by `from`.
612      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
613      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
614      *
615      * Emits a {Transfer} event.
616      */
617     function safeTransferFrom(
618         address from,
619         address to,
620         uint256 tokenId
621     ) external;
622 
623     /**
624      * @dev Transfers `tokenId` token from `from` to `to`.
625      *
626      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
627      *
628      * Requirements:
629      *
630      * - `from` cannot be the zero address.
631      * - `to` cannot be the zero address.
632      * - `tokenId` token must be owned by `from`.
633      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
634      *
635      * Emits a {Transfer} event.
636      */
637     function transferFrom(
638         address from,
639         address to,
640         uint256 tokenId
641     ) external;
642 
643     /**
644      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
645      * The approval is cleared when the token is transferred.
646      *
647      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
648      *
649      * Requirements:
650      *
651      * - The caller must own the token or be an approved operator.
652      * - `tokenId` must exist.
653      *
654      * Emits an {Approval} event.
655      */
656     function approve(address to, uint256 tokenId) external;
657 
658     /**
659      * @dev Returns the account approved for `tokenId` token.
660      *
661      * Requirements:
662      *
663      * - `tokenId` must exist.
664      */
665     function getApproved(uint256 tokenId) external view returns (address operator);
666 
667     /**
668      * @dev Approve or remove `operator` as an operator for the caller.
669      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
670      *
671      * Requirements:
672      *
673      * - The `operator` cannot be the caller.
674      *
675      * Emits an {ApprovalForAll} event.
676      */
677     function setApprovalForAll(address operator, bool _approved) external;
678 
679     /**
680      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
681      *
682      * See {setApprovalForAll}
683      */
684     function isApprovedForAll(address owner, address operator) external view returns (bool);
685 
686     /**
687      * @dev Safely transfers `tokenId` token from `from` to `to`.
688      *
689      * Requirements:
690      *
691      * - `from` cannot be the zero address.
692      * - `to` cannot be the zero address.
693      * - `tokenId` token must exist and be owned by `from`.
694      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
695      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
696      *
697      * Emits a {Transfer} event.
698      */
699     function safeTransferFrom(
700         address from,
701         address to,
702         uint256 tokenId,
703         bytes calldata data
704     ) external;
705 }
706 
707 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
708 
709 
710 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
711 
712 pragma solidity ^0.8.0;
713 
714 
715 /**
716  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
717  * @dev See https://eips.ethereum.org/EIPS/eip-721
718  */
719 interface IERC721Enumerable is IERC721 {
720     /**
721      * @dev Returns the total amount of tokens stored by the contract.
722      */
723     function totalSupply() external view returns (uint256);
724 
725     /**
726      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
727      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
728      */
729     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
730 
731     /**
732      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
733      * Use along with {totalSupply} to enumerate all tokens.
734      */
735     function tokenByIndex(uint256 index) external view returns (uint256);
736 }
737 
738 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
739 
740 
741 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
742 
743 pragma solidity ^0.8.0;
744 
745 
746 /**
747  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
748  * @dev See https://eips.ethereum.org/EIPS/eip-721
749  */
750 interface IERC721Metadata is IERC721 {
751     /**
752      * @dev Returns the token collection name.
753      */
754     function name() external view returns (string memory);
755 
756     /**
757      * @dev Returns the token collection symbol.
758      */
759     function symbol() external view returns (string memory);
760 
761     /**
762      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
763      */
764     function tokenURI(uint256 tokenId) external view returns (string memory);
765 }
766 
767 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
768 
769 
770 // Creator: Chiru Labs
771 
772 pragma solidity ^0.8.4;
773 
774 
775 
776 
777 
778 
779 
780 
781 
782 error ApprovalCallerNotOwnerNorApproved();
783 error ApprovalQueryForNonexistentToken();
784 error ApproveToCaller();
785 error ApprovalToCurrentOwner();
786 error BalanceQueryForZeroAddress();
787 error MintedQueryForZeroAddress();
788 error BurnedQueryForZeroAddress();
789 error AuxQueryForZeroAddress();
790 error MintToZeroAddress();
791 error MintZeroQuantity();
792 error OwnerIndexOutOfBounds();
793 error OwnerQueryForNonexistentToken();
794 error TokenIndexOutOfBounds();
795 error TransferCallerNotOwnerNorApproved();
796 error TransferFromIncorrectOwner();
797 error TransferToNonERC721ReceiverImplementer();
798 error TransferToZeroAddress();
799 error URIQueryForNonexistentToken();
800 
801 /**
802  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
803  * the Metadata extension. Built to optimize for lower gas during batch mints.
804  *
805  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
806  *
807  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
808  *
809  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
810  */
811 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
812     using Address for address;
813     using Strings for uint256;
814 
815     // Compiler will pack this into a single 256bit word.
816     struct TokenOwnership {
817         // The address of the owner.
818         address addr;
819         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
820         uint64 startTimestamp;
821         // Whether the token has been burned.
822         bool burned;
823     }
824 
825     // Compiler will pack this into a single 256bit word.
826     struct AddressData {
827         // Realistically, 2**64-1 is more than enough.
828         uint64 balance;
829         // Keeps track of mint count with minimal overhead for tokenomics.
830         uint64 numberMinted;
831         // Keeps track of burn count with minimal overhead for tokenomics.
832         uint64 numberBurned;
833         // For miscellaneous variable(s) pertaining to the address
834         // (e.g. number of whitelist mint slots used).
835         // If there are multiple variables, please pack them into a uint64.
836         uint64 aux;
837     }
838 
839     // The tokenId of the next token to be minted.
840     uint256 internal _currentIndex;
841 
842     // The number of tokens burned.
843     uint256 internal _burnCounter;
844 
845     // Token name
846     string private _name;
847 
848     // Token symbol
849     string private _symbol;
850 
851     // Mapping from token ID to ownership details
852     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
853     mapping(uint256 => TokenOwnership) internal _ownerships;
854 
855     // Mapping owner address to address data
856     mapping(address => AddressData) private _addressData;
857 
858     // Mapping from token ID to approved address
859     mapping(uint256 => address) private _tokenApprovals;
860 
861     // Mapping from owner to operator approvals
862     mapping(address => mapping(address => bool)) private _operatorApprovals;
863 
864     constructor(string memory name_, string memory symbol_) {
865         _name = name_;
866         _symbol = symbol_;
867         _currentIndex = _startTokenId();
868     }
869 
870     /**
871      * To change the starting tokenId, please override this function.
872      */
873     function _startTokenId() internal view virtual returns (uint256) {
874         return 0;
875     }
876 
877     /**
878      * @dev See {IERC721Enumerable-totalSupply}.
879      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
880      */
881     function totalSupply() public view returns (uint256) {
882         // Counter underflow is impossible as _burnCounter cannot be incremented
883         // more than _currentIndex - _startTokenId() times
884         unchecked {
885             return _currentIndex - _burnCounter - _startTokenId();
886         }
887     }
888 
889     /**
890      * Returns the total amount of tokens minted in the contract.
891      */
892     function _totalMinted() internal view returns (uint256) {
893         // Counter underflow is impossible as _currentIndex does not decrement,
894         // and it is initialized to _startTokenId()
895         unchecked {
896             return _currentIndex - _startTokenId();
897         }
898     }
899 
900     /**
901      * @dev See {IERC165-supportsInterface}.
902      */
903     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
904         return
905             interfaceId == type(IERC721).interfaceId ||
906             interfaceId == type(IERC721Metadata).interfaceId ||
907             super.supportsInterface(interfaceId);
908     }
909 
910     /**
911      * @dev See {IERC721-balanceOf}.
912      */
913     function balanceOf(address owner) public view override returns (uint256) {
914         if (owner == address(0)) revert BalanceQueryForZeroAddress();
915         return uint256(_addressData[owner].balance);
916     }
917 
918     /**
919      * Returns the number of tokens minted by `owner`.
920      */
921     function _numberMinted(address owner) internal view returns (uint256) {
922         if (owner == address(0)) revert MintedQueryForZeroAddress();
923         return uint256(_addressData[owner].numberMinted);
924     }
925 
926     /**
927      * Returns the number of tokens burned by or on behalf of `owner`.
928      */
929     function _numberBurned(address owner) internal view returns (uint256) {
930         if (owner == address(0)) revert BurnedQueryForZeroAddress();
931         return uint256(_addressData[owner].numberBurned);
932     }
933 
934     /**
935      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
936      */
937     function _getAux(address owner) internal view returns (uint64) {
938         if (owner == address(0)) revert AuxQueryForZeroAddress();
939         return _addressData[owner].aux;
940     }
941 
942     /**
943      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
944      * If there are multiple variables, please pack them into a uint64.
945      */
946     function _setAux(address owner, uint64 aux) internal {
947         if (owner == address(0)) revert AuxQueryForZeroAddress();
948         _addressData[owner].aux = aux;
949     }
950 
951     /**
952      * Gas spent here starts off proportional to the maximum mint batch size.
953      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
954      */
955     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
956         uint256 curr = tokenId;
957 
958         unchecked {
959             if (_startTokenId() <= curr && curr < _currentIndex) {
960                 TokenOwnership memory ownership = _ownerships[curr];
961                 if (!ownership.burned) {
962                     if (ownership.addr != address(0)) {
963                         return ownership;
964                     }
965                     // Invariant:
966                     // There will always be an ownership that has an address and is not burned
967                     // before an ownership that does not have an address and is not burned.
968                     // Hence, curr will not underflow.
969                     while (true) {
970                         curr--;
971                         ownership = _ownerships[curr];
972                         if (ownership.addr != address(0)) {
973                             return ownership;
974                         }
975                     }
976                 }
977             }
978         }
979         revert OwnerQueryForNonexistentToken();
980     }
981 
982     /**
983      * @dev See {IERC721-ownerOf}.
984      */
985     function ownerOf(uint256 tokenId) public view override returns (address) {
986         return ownershipOf(tokenId).addr;
987     }
988 
989     /**
990      * @dev See {IERC721Metadata-name}.
991      */
992     function name() public view virtual override returns (string memory) {
993         return _name;
994     }
995 
996     /**
997      * @dev See {IERC721Metadata-symbol}.
998      */
999     function symbol() public view virtual override returns (string memory) {
1000         return _symbol;
1001     }
1002 
1003     /**
1004      * @dev See {IERC721Metadata-tokenURI}.
1005      */
1006     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1007         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1008 
1009         string memory baseURI = _baseURI();
1010         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1011     }
1012 
1013     /**
1014      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1015      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1016      * by default, can be overriden in child contracts.
1017      */
1018     function _baseURI() internal view virtual returns (string memory) {
1019         return '';
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-approve}.
1024      */
1025     function approve(address to, uint256 tokenId) public override {
1026         address owner = ERC721A.ownerOf(tokenId);
1027         if (to == owner) revert ApprovalToCurrentOwner();
1028 
1029         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1030             revert ApprovalCallerNotOwnerNorApproved();
1031         }
1032 
1033         _approve(to, tokenId, owner);
1034     }
1035 
1036     /**
1037      * @dev See {IERC721-getApproved}.
1038      */
1039     function getApproved(uint256 tokenId) public view override returns (address) {
1040         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1041 
1042         return _tokenApprovals[tokenId];
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-setApprovalForAll}.
1047      */
1048     function setApprovalForAll(address operator, bool approved) public override {
1049         if (operator == _msgSender()) revert ApproveToCaller();
1050 
1051         _operatorApprovals[_msgSender()][operator] = approved;
1052         emit ApprovalForAll(_msgSender(), operator, approved);
1053     }
1054 
1055     /**
1056      * @dev See {IERC721-isApprovedForAll}.
1057      */
1058     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1059         return _operatorApprovals[owner][operator];
1060     }
1061 
1062     /**
1063      * @dev See {IERC721-transferFrom}.
1064      */
1065     function transferFrom(
1066         address from,
1067         address to,
1068         uint256 tokenId
1069     ) public virtual override {
1070         _transfer(from, to, tokenId);
1071     }
1072 
1073     /**
1074      * @dev See {IERC721-safeTransferFrom}.
1075      */
1076     function safeTransferFrom(
1077         address from,
1078         address to,
1079         uint256 tokenId
1080     ) public virtual override {
1081         safeTransferFrom(from, to, tokenId, '');
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-safeTransferFrom}.
1086      */
1087     function safeTransferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId,
1091         bytes memory _data
1092     ) public virtual override {
1093         _transfer(from, to, tokenId);
1094         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1095             revert TransferToNonERC721ReceiverImplementer();
1096         }
1097     }
1098 
1099     /**
1100      * @dev Returns whether `tokenId` exists.
1101      *
1102      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1103      *
1104      * Tokens start existing when they are minted (`_mint`),
1105      */
1106     function _exists(uint256 tokenId) internal view returns (bool) {
1107         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1108             !_ownerships[tokenId].burned;
1109     }
1110 
1111     function _safeMint(address to, uint256 quantity) internal {
1112         _safeMint(to, quantity, '');
1113     }
1114 
1115     /**
1116      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1117      *
1118      * Requirements:
1119      *
1120      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1121      * - `quantity` must be greater than 0.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _safeMint(
1126         address to,
1127         uint256 quantity,
1128         bytes memory _data
1129     ) internal {
1130         _mint(to, quantity, _data, true);
1131     }
1132 
1133     /**
1134      * @dev Mints `quantity` tokens and transfers them to `to`.
1135      *
1136      * Requirements:
1137      *
1138      * - `to` cannot be the zero address.
1139      * - `quantity` must be greater than 0.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function _mint(
1144         address to,
1145         uint256 quantity,
1146         bytes memory _data,
1147         bool safe
1148     ) internal {
1149         uint256 startTokenId = _currentIndex;
1150         if (to == address(0)) revert MintToZeroAddress();
1151         if (quantity == 0) revert MintZeroQuantity();
1152 
1153         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1154 
1155         // Overflows are incredibly unrealistic.
1156         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1157         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1158         unchecked {
1159             _addressData[to].balance += uint64(quantity);
1160             _addressData[to].numberMinted += uint64(quantity);
1161 
1162             _ownerships[startTokenId].addr = to;
1163             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1164 
1165             uint256 updatedIndex = startTokenId;
1166             uint256 end = updatedIndex + quantity;
1167 
1168             if (safe && to.isContract()) {
1169                 do {
1170                     emit Transfer(address(0), to, updatedIndex);
1171                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1172                         revert TransferToNonERC721ReceiverImplementer();
1173                     }
1174                 } while (updatedIndex != end);
1175                 // Reentrancy protection
1176                 if (_currentIndex != startTokenId) revert();
1177             } else {
1178                 do {
1179                     emit Transfer(address(0), to, updatedIndex++);
1180                 } while (updatedIndex != end);
1181             }
1182             _currentIndex = updatedIndex;
1183         }
1184         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1185     }
1186 
1187     /**
1188      * @dev Transfers `tokenId` from `from` to `to`.
1189      *
1190      * Requirements:
1191      *
1192      * - `to` cannot be the zero address.
1193      * - `tokenId` token must be owned by `from`.
1194      *
1195      * Emits a {Transfer} event.
1196      */
1197     function _transfer(
1198         address from,
1199         address to,
1200         uint256 tokenId
1201     ) private {
1202         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1203 
1204         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1205             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1206             getApproved(tokenId) == _msgSender());
1207 
1208         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1209         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1210         if (to == address(0)) revert TransferToZeroAddress();
1211 
1212         _beforeTokenTransfers(from, to, tokenId, 1);
1213 
1214         // Clear approvals from the previous owner
1215         _approve(address(0), tokenId, prevOwnership.addr);
1216 
1217         // Underflow of the sender's balance is impossible because we check for
1218         // ownership above and the recipient's balance can't realistically overflow.
1219         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1220         unchecked {
1221             _addressData[from].balance -= 1;
1222             _addressData[to].balance += 1;
1223 
1224             _ownerships[tokenId].addr = to;
1225             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1226 
1227             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1228             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1229             uint256 nextTokenId = tokenId + 1;
1230             if (_ownerships[nextTokenId].addr == address(0)) {
1231                 // This will suffice for checking _exists(nextTokenId),
1232                 // as a burned slot cannot contain the zero address.
1233                 if (nextTokenId < _currentIndex) {
1234                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1235                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1236                 }
1237             }
1238         }
1239 
1240         emit Transfer(from, to, tokenId);
1241         _afterTokenTransfers(from, to, tokenId, 1);
1242     }
1243 
1244     /**
1245      * @dev Destroys `tokenId`.
1246      * The approval is cleared when the token is burned.
1247      *
1248      * Requirements:
1249      *
1250      * - `tokenId` must exist.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function _burn(uint256 tokenId) internal virtual {
1255         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1256 
1257         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1258 
1259         // Clear approvals from the previous owner
1260         _approve(address(0), tokenId, prevOwnership.addr);
1261 
1262         // Underflow of the sender's balance is impossible because we check for
1263         // ownership above and the recipient's balance can't realistically overflow.
1264         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1265         unchecked {
1266             _addressData[prevOwnership.addr].balance -= 1;
1267             _addressData[prevOwnership.addr].numberBurned += 1;
1268 
1269             // Keep track of who burned the token, and the timestamp of burning.
1270             _ownerships[tokenId].addr = prevOwnership.addr;
1271             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1272             _ownerships[tokenId].burned = true;
1273 
1274             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1275             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1276             uint256 nextTokenId = tokenId + 1;
1277             if (_ownerships[nextTokenId].addr == address(0)) {
1278                 // This will suffice for checking _exists(nextTokenId),
1279                 // as a burned slot cannot contain the zero address.
1280                 if (nextTokenId < _currentIndex) {
1281                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1282                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1283                 }
1284             }
1285         }
1286 
1287         emit Transfer(prevOwnership.addr, address(0), tokenId);
1288         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1289 
1290         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1291         unchecked {
1292             _burnCounter++;
1293         }
1294     }
1295 
1296     /**
1297      * @dev Approve `to` to operate on `tokenId`
1298      *
1299      * Emits a {Approval} event.
1300      */
1301     function _approve(
1302         address to,
1303         uint256 tokenId,
1304         address owner
1305     ) private {
1306         _tokenApprovals[tokenId] = to;
1307         emit Approval(owner, to, tokenId);
1308     }
1309 
1310     /**
1311      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1312      *
1313      * @param from address representing the previous owner of the given token ID
1314      * @param to target address that will receive the tokens
1315      * @param tokenId uint256 ID of the token to be transferred
1316      * @param _data bytes optional data to send along with the call
1317      * @return bool whether the call correctly returned the expected magic value
1318      */
1319     function _checkContractOnERC721Received(
1320         address from,
1321         address to,
1322         uint256 tokenId,
1323         bytes memory _data
1324     ) private returns (bool) {
1325         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1326             return retval == IERC721Receiver(to).onERC721Received.selector;
1327         } catch (bytes memory reason) {
1328             if (reason.length == 0) {
1329                 revert TransferToNonERC721ReceiverImplementer();
1330             } else {
1331                 assembly {
1332                     revert(add(32, reason), mload(reason))
1333                 }
1334             }
1335         }
1336     }
1337 
1338     /**
1339      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1340      * And also called before burning one token.
1341      *
1342      * startTokenId - the first token id to be transferred
1343      * quantity - the amount to be transferred
1344      *
1345      * Calling conditions:
1346      *
1347      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1348      * transferred to `to`.
1349      * - When `from` is zero, `tokenId` will be minted for `to`.
1350      * - When `to` is zero, `tokenId` will be burned by `from`.
1351      * - `from` and `to` are never both zero.
1352      */
1353     function _beforeTokenTransfers(
1354         address from,
1355         address to,
1356         uint256 startTokenId,
1357         uint256 quantity
1358     ) internal virtual {}
1359 
1360     /**
1361      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1362      * minting.
1363      * And also called after one token has been burned.
1364      *
1365      * startTokenId - the first token id to be transferred
1366      * quantity - the amount to be transferred
1367      *
1368      * Calling conditions:
1369      *
1370      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1371      * transferred to `to`.
1372      * - When `from` is zero, `tokenId` has been minted for `to`.
1373      * - When `to` is zero, `tokenId` has been burned by `from`.
1374      * - `from` and `to` are never both zero.
1375      */
1376     function _afterTokenTransfers(
1377         address from,
1378         address to,
1379         uint256 startTokenId,
1380         uint256 quantity
1381     ) internal virtual {}
1382 }
1383 
1384 // File: contracts/Sloodle.sol
1385 
1386 
1387 pragma solidity ^0.8.7;
1388 
1389 
1390 
1391 
1392 contract eye is ERC721A, Ownable {
1393     using Strings for uint256;
1394     address breedingContract;
1395 
1396     string public baseApiURI;
1397     string public baseExtension = ".json";
1398     bytes32 private whitelistRoot;
1399   
1400 
1401     //General Settings
1402     uint16 public maxMintAmountPerTransaction = 1;
1403     uint16 public maxMintAmountPerWallet = 1;
1404 
1405     //whitelisting Settings
1406     uint16 public maxMintAmountPerWhitelist = 1;
1407    
1408 
1409     //Inventory
1410     uint256 public maxSupply = 5000;
1411 
1412     //Prices
1413     uint256 public cost = 0.00 ether;
1414     uint256 public whitelistCost = 0.00 ether;
1415 
1416     //Utility
1417     bool public paused = true;
1418     bool public whiteListingSale = false;
1419 
1420     //mapping
1421     mapping(address => uint256) private whitelistedMints;
1422 
1423     constructor(string memory _baseUrl) ERC721A("EYE EYE EYE", "EYE") {
1424         baseApiURI = _baseUrl;
1425     }
1426 
1427     //This function will be used to extend the project with more capabilities 
1428     function setBreedingContractAddress(address _bAddress) public onlyOwner {
1429         breedingContract = _bAddress;
1430     }
1431 
1432     //this function can be called only from the extending contract
1433     function mintExternal(address _address, uint256 _mintAmount) external {
1434         require(
1435             msg.sender == breedingContract,
1436             "NOT ALLOWED"
1437         );
1438         _safeMint(_address, _mintAmount);
1439     }
1440 
1441     function setWhitelistingRoot(bytes32 _root) public onlyOwner {
1442         whitelistRoot = _root;
1443     }
1444 
1445    
1446 
1447  
1448     // Verify that a given leaf is in the tree.
1449     function _verify(
1450         bytes32 _leafNode,
1451         bytes32[] memory proof
1452     ) internal view returns (bool) {
1453         return MerkleProof.verify(proof, whitelistRoot, _leafNode);
1454     }
1455 
1456     // Generate the leaf node (just the hash of tokenID concatenated with the account address)
1457     function _leaf(address account) internal pure returns (bytes32) {
1458         return keccak256(abi.encodePacked(account));
1459     }
1460 
1461     //whitelist mint
1462     function mintWhitelist(
1463         bytes32[] calldata proof,
1464         uint256 _mintAmount
1465     ) public payable {
1466      
1467 
1468                 
1469                 //Normal WL Verifications
1470                  require(
1471                 totalSupply() + _mintAmount <= maxSupply,
1472                 "SOLD THE FUCK OUT"
1473             );
1474 
1475                 require(
1476                     _verify(_leaf(msg.sender), proof),
1477                     "Invalid proof"
1478                 );
1479                 require(
1480                     (whitelistedMints[msg.sender] + _mintAmount) <=
1481                         maxMintAmountPerWhitelist,
1482                     "DONT BE GREEDY"
1483                 );
1484 
1485                 require(
1486                     msg.value >= (whitelistCost * _mintAmount),
1487                     "YOU CANT AFFORD FREE?"
1488                 );
1489 
1490                 //END WL Verifications
1491 
1492                 //Mint
1493                 _mintLoop(msg.sender, _mintAmount);
1494                 whitelistedMints[msg.sender] =
1495                     whitelistedMints[msg.sender] +
1496                     _mintAmount;
1497     }
1498 
1499     function numberMinted(address owner) public view returns (uint256) {
1500         return _numberMinted(owner);
1501     }
1502 
1503     // public
1504     function mint(uint256 _mintAmount) public payable {
1505         if (msg.sender != owner()) {
1506             uint256 ownerTokenCount = balanceOf(msg.sender);
1507 
1508             require(!paused);
1509             require(!whiteListingSale, "YOU SHOULDNT BE HERE");
1510             require(_mintAmount > 0, "CANT BE ZERO DUMBASS");
1511             require(
1512                 _mintAmount <= maxMintAmountPerTransaction,
1513                 "MINT ONE. STOP BEING FUCKING GREEDY"
1514             );
1515             require(
1516                 totalSupply() + _mintAmount <= maxSupply,
1517                 "THATS TOO MANY"
1518             );
1519             require(
1520                 (ownerTokenCount + _mintAmount) <= maxMintAmountPerWallet,
1521                 "YOU ALREADY GOT ONE ASSHOLE."
1522             );
1523 
1524             require(msg.value >= cost * _mintAmount, "ITS FREE, FIND SOME SPARE CHANGE");
1525         }
1526 
1527         _mintLoop(msg.sender, _mintAmount);
1528     }
1529 
1530     function gift(address _to, uint256 _mintAmount) public onlyOwner {
1531         _mintLoop(_to, _mintAmount);
1532     }
1533 
1534     function airdrop(address[] memory _airdropAddresses) public onlyOwner {
1535         for (uint256 i = 0; i < _airdropAddresses.length; i++) {
1536             address to = _airdropAddresses[i];
1537             _mintLoop(to, 1);
1538         }
1539     }
1540 
1541     function _baseURI() internal view virtual override returns (string memory) {
1542         return baseApiURI;
1543     }
1544 
1545     function tokenURI(uint256 tokenId)
1546         public
1547         view
1548         virtual
1549         override
1550         returns (string memory)
1551     {
1552         require(
1553             _exists(tokenId),
1554             "ERC721Metadata: URI query for nonexistent token"
1555         );
1556         string memory currentBaseURI = _baseURI();
1557         return
1558             bytes(currentBaseURI).length > 0
1559                 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1560                 : "";
1561     }
1562 
1563     function setCost(uint256 _newCost) public onlyOwner {
1564         cost = _newCost;
1565     }
1566 
1567     function setWhitelistingCost(uint256 _newCost) public onlyOwner {
1568         whitelistCost = _newCost;
1569     }
1570 
1571     function setmaxMintAmountPerTransaction(uint16 _amount) public onlyOwner {
1572         maxMintAmountPerTransaction = _amount;
1573     }
1574 
1575     function setMaxMintAmountPerWallet(uint16 _amount) public onlyOwner {
1576         maxMintAmountPerWallet = _amount;
1577     }
1578 
1579     function setMaxMintAmountPerWhitelist(uint16 _amount) public onlyOwner {
1580         maxMintAmountPerWhitelist = _amount;
1581     }
1582 
1583     function setMaxSupply(uint256 _supply) public onlyOwner {
1584         maxSupply = _supply;
1585     }
1586 
1587     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1588         baseApiURI = _newBaseURI;
1589     }
1590 
1591     function togglePause() public onlyOwner {
1592         paused = !paused;
1593     }
1594 
1595     function toggleWhiteSale() public onlyOwner {
1596         whiteListingSale = !whiteListingSale;
1597     }
1598 
1599     function _mintLoop(address _receiver, uint256 _mintAmount) internal {
1600         _safeMint(_receiver, _mintAmount);
1601     }
1602 
1603     function getOwnershipData(uint256 tokenId)
1604         external
1605         view
1606         returns (TokenOwnership memory)
1607     {
1608         return ownershipOf(tokenId);
1609     }
1610 
1611     function withdraw() public payable onlyOwner {
1612 
1613         (bool hq, ) = payable(owner()).call{value: address(this).balance}("");
1614         require(hq);
1615     }
1616 }