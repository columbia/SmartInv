1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 
5 
6 /**
7  * @dev Interface of the ERC165 standard, as defined in the
8  * https://eips.ethereum.org/EIPS/eip-165[EIP].
9  *
10  * Implementers can declare support of contract interfaces, which can then be
11  * queried by others ({ERC165Checker}).
12  *
13  * For an implementation, see {ERC165}.
14  */
15 interface IERC165 {
16     /**
17      * @dev Returns true if this contract implements the interface defined by
18      * `interfaceId`. See the corresponding
19      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
20      * to learn more about how these ids are created.
21      *
22      * This function call must use less than 30 000 gas.
23      */
24     function supportsInterface(bytes4 interfaceId) external view returns (bool);
25 }
26 
27 
28 
29 /**
30  * @dev String operations.
31  */
32 library Strings {
33     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
34 
35     /**
36      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
37      */
38     function toString(uint256 value) internal pure returns (string memory) {
39         // Inspired by OraclizeAPI's implementation - MIT licence
40         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
41 
42         if (value == 0) {
43             return "0";
44         }
45         uint256 temp = value;
46         uint256 digits;
47         while (temp != 0) {
48             digits++;
49             temp /= 10;
50         }
51         bytes memory buffer = new bytes(digits);
52         while (value != 0) {
53             digits -= 1;
54             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
55             value /= 10;
56         }
57         return string(buffer);
58     }
59 
60     /**
61      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
62      */
63     function toHexString(uint256 value) internal pure returns (string memory) {
64         if (value == 0) {
65             return "0x00";
66         }
67         uint256 temp = value;
68         uint256 length = 0;
69         while (temp != 0) {
70             length++;
71             temp >>= 8;
72         }
73         return toHexString(value, length);
74     }
75 
76     /**
77      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
78      */
79     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
80         bytes memory buffer = new bytes(2 * length + 2);
81         buffer[0] = "0";
82         buffer[1] = "x";
83         for (uint256 i = 2 * length + 1; i > 1; --i) {
84             buffer[i] = _HEX_SYMBOLS[value & 0xf];
85             value >>= 4;
86         }
87         require(value == 0, "Strings: hex length insufficient");
88         return string(buffer);
89     }
90 }
91 
92 
93 
94 /**
95  * @dev Required interface of an ERC721 compliant contract.
96  */
97 interface IERC721 is IERC165 {
98     /**
99      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
102 
103     /**
104      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
105      */
106     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
107 
108     /**
109      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
110      */
111     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
112 
113     /**
114      * @dev Returns the number of tokens in ``owner``'s account.
115      */
116     function balanceOf(address owner) external view returns (uint256 balance);
117 
118     /**
119      * @dev Returns the owner of the `tokenId` token.
120      *
121      * Requirements:
122      *
123      * - `tokenId` must exist.
124      */
125     function ownerOf(uint256 tokenId) external view returns (address owner);
126 
127     /**
128      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
129      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
130      *
131      * Requirements:
132      *
133      * - `from` cannot be the zero address.
134      * - `to` cannot be the zero address.
135      * - `tokenId` token must exist and be owned by `from`.
136      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
137      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
138      *
139      * Emits a {Transfer} event.
140      */
141     function safeTransferFrom(
142         address from,
143         address to,
144         uint256 tokenId
145     ) external;
146 
147     /**
148      * @dev Transfers `tokenId` token from `from` to `to`.
149      *
150      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
151      *
152      * Requirements:
153      *
154      * - `from` cannot be the zero address.
155      * - `to` cannot be the zero address.
156      * - `tokenId` token must be owned by `from`.
157      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(
162         address from,
163         address to,
164         uint256 tokenId
165     ) external;
166 
167     /**
168      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
169      * The approval is cleared when the token is transferred.
170      *
171      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
172      *
173      * Requirements:
174      *
175      * - The caller must own the token or be an approved operator.
176      * - `tokenId` must exist.
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address to, uint256 tokenId) external;
181 
182     /**
183      * @dev Returns the account approved for `tokenId` token.
184      *
185      * Requirements:
186      *
187      * - `tokenId` must exist.
188      */
189     function getApproved(uint256 tokenId) external view returns (address operator);
190 
191     /**
192      * @dev Approve or remove `operator` as an operator for the caller.
193      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
194      *
195      * Requirements:
196      *
197      * - The `operator` cannot be the caller.
198      *
199      * Emits an {ApprovalForAll} event.
200      */
201     function setApprovalForAll(address operator, bool _approved) external;
202 
203     /**
204      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
205      *
206      * See {setApprovalForAll}
207      */
208     function isApprovedForAll(address owner, address operator) external view returns (bool);
209 
210     /**
211      * @dev Safely transfers `tokenId` token from `from` to `to`.
212      *
213      * Requirements:
214      *
215      * - `from` cannot be the zero address.
216      * - `to` cannot be the zero address.
217      * - `tokenId` token must exist and be owned by `from`.
218      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
219      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
220      *
221      * Emits a {Transfer} event.
222      */
223     function safeTransferFrom(
224         address from,
225         address to,
226         uint256 tokenId,
227         bytes calldata data
228     ) external;
229 }
230 
231 
232 
233 /**
234  * @title ERC721 token receiver interface
235  * @dev Interface for any contract that wants to support safeTransfers
236  * from ERC721 asset contracts.
237  */
238 interface IERC721Receiver {
239     /**
240      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
241      * by `operator` from `from`, this function is called.
242      *
243      * It must return its Solidity selector to confirm the token transfer.
244      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
245      *
246      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
247      */
248     function onERC721Received(
249         address operator,
250         address from,
251         uint256 tokenId,
252         bytes calldata data
253     ) external returns (bytes4);
254 }
255 
256 
257 
258 /**
259  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
260  * @dev See https://eips.ethereum.org/EIPS/eip-721
261  */
262 interface IERC721Metadata is IERC721 {
263     /**
264      * @dev Returns the token collection name.
265      */
266     function name() external view returns (string memory);
267 
268     /**
269      * @dev Returns the token collection symbol.
270      */
271     function symbol() external view returns (string memory);
272 
273     /**
274      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
275      */
276     function tokenURI(uint256 tokenId) external view returns (string memory);
277 }
278 
279 
280 
281 /**
282  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
283  * @dev See https://eips.ethereum.org/EIPS/eip-721
284  */
285 interface IERC721Enumerable is IERC721 {
286     /**
287      * @dev Returns the total amount of tokens stored by the contract.
288      */
289     function totalSupply() external view returns (uint256);
290 
291     /**
292      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
293      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
294      */
295     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
296 
297     /**
298      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
299      * Use along with {totalSupply} to enumerate all tokens.
300      */
301     function tokenByIndex(uint256 index) external view returns (uint256);
302 }
303 
304 
305 
306 /**
307  * @dev Collection of functions related to the address type
308  */
309 library Address {
310     /**
311      * @dev Returns true if `account` is a contract.
312      *
313      * [IMPORTANT]
314      * ====
315      * It is unsafe to assume that an address for which this function returns
316      * false is an externally-owned account (EOA) and not a contract.
317      *
318      * Among others, `isContract` will return false for the following
319      * types of addresses:
320      *
321      *  - an externally-owned account
322      *  - a contract in construction
323      *  - an address where a contract will be created
324      *  - an address where a contract lived, but was destroyed
325      * ====
326      *
327      * [IMPORTANT]
328      * ====
329      * You shouldn't rely on `isContract` to protect against flash loan attacks!
330      *
331      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
332      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
333      * constructor.
334      * ====
335      */
336     function isContract(address account) internal view returns (bool) {
337         // This method relies on extcodesize/address.code.length, which returns 0
338         // for contracts in construction, since the code is only stored at the end
339         // of the constructor execution.
340 
341         return account.code.length > 0;
342     }
343 
344     /**
345      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
346      * `recipient`, forwarding all available gas and reverting on errors.
347      *
348      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
349      * of certain opcodes, possibly making contracts go over the 2300 gas limit
350      * imposed by `transfer`, making them unable to receive funds via
351      * `transfer`. {sendValue} removes this limitation.
352      *
353      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
354      *
355      * IMPORTANT: because control is transferred to `recipient`, care must be
356      * taken to not create reentrancy vulnerabilities. Consider using
357      * {ReentrancyGuard} or the
358      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
359      */
360     function sendValue(address payable recipient, uint256 amount) internal {
361         require(address(this).balance >= amount, "Address: insufficient balance");
362 
363         (bool success, ) = recipient.call{value: amount}("");
364         require(success, "Address: unable to send value, recipient may have reverted");
365     }
366 
367     /**
368      * @dev Performs a Solidity function call using a low level `call`. A
369      * plain `call` is an unsafe replacement for a function call: use this
370      * function instead.
371      *
372      * If `target` reverts with a revert reason, it is bubbled up by this
373      * function (like regular Solidity function calls).
374      *
375      * Returns the raw returned data. To convert to the expected return value,
376      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
377      *
378      * Requirements:
379      *
380      * - `target` must be a contract.
381      * - calling `target` with `data` must not revert.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
386         return functionCall(target, data, "Address: low-level call failed");
387     }
388 
389     /**
390      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
391      * `errorMessage` as a fallback revert reason when `target` reverts.
392      *
393      * _Available since v3.1._
394      */
395     function functionCall(
396         address target,
397         bytes memory data,
398         string memory errorMessage
399     ) internal returns (bytes memory) {
400         return functionCallWithValue(target, data, 0, errorMessage);
401     }
402 
403     /**
404      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
405      * but also transferring `value` wei to `target`.
406      *
407      * Requirements:
408      *
409      * - the calling contract must have an ETH balance of at least `value`.
410      * - the called Solidity function must be `payable`.
411      *
412      * _Available since v3.1._
413      */
414     function functionCallWithValue(
415         address target,
416         bytes memory data,
417         uint256 value
418     ) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(
429         address target,
430         bytes memory data,
431         uint256 value,
432         string memory errorMessage
433     ) internal returns (bytes memory) {
434         require(address(this).balance >= value, "Address: insufficient balance for call");
435         require(isContract(target), "Address: call to non-contract");
436 
437         (bool success, bytes memory returndata) = target.call{value: value}(data);
438         return verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443      * but performing a static call.
444      *
445      * _Available since v3.3._
446      */
447     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
448         return functionStaticCall(target, data, "Address: low-level static call failed");
449     }
450 
451     /**
452      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453      * but performing a static call.
454      *
455      * _Available since v3.3._
456      */
457     function functionStaticCall(
458         address target,
459         bytes memory data,
460         string memory errorMessage
461     ) internal view returns (bytes memory) {
462         require(isContract(target), "Address: static call to non-contract");
463 
464         (bool success, bytes memory returndata) = target.staticcall(data);
465         return verifyCallResult(success, returndata, errorMessage);
466     }
467 
468     /**
469      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
470      * but performing a delegate call.
471      *
472      * _Available since v3.4._
473      */
474     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
475         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
476     }
477 
478     /**
479      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
480      * but performing a delegate call.
481      *
482      * _Available since v3.4._
483      */
484     function functionDelegateCall(
485         address target,
486         bytes memory data,
487         string memory errorMessage
488     ) internal returns (bytes memory) {
489         require(isContract(target), "Address: delegate call to non-contract");
490 
491         (bool success, bytes memory returndata) = target.delegatecall(data);
492         return verifyCallResult(success, returndata, errorMessage);
493     }
494 
495     /**
496      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
497      * revert reason using the provided one.
498      *
499      * _Available since v4.3._
500      */
501     function verifyCallResult(
502         bool success,
503         bytes memory returndata,
504         string memory errorMessage
505     ) internal pure returns (bytes memory) {
506         if (success) {
507             return returndata;
508         } else {
509             // Look for revert reason and bubble it up if present
510             if (returndata.length > 0) {
511                 // The easiest way to bubble the revert reason is using memory via assembly
512 
513                 assembly {
514                     let returndata_size := mload(returndata)
515                     revert(add(32, returndata), returndata_size)
516                 }
517             } else {
518                 revert(errorMessage);
519             }
520         }
521     }
522 }
523 
524 
525 
526 /**
527  * @dev Provides information about the current execution context, including the
528  * sender of the transaction and its data. While these are generally available
529  * via msg.sender and msg.data, they should not be accessed in such a direct
530  * manner, since when dealing with meta-transactions the account sending and
531  * paying for execution may not be the actual sender (as far as an application
532  * is concerned).
533  *
534  * This contract is only required for intermediate, library-like contracts.
535  */
536 abstract contract Context {
537     function _msgSender() internal view virtual returns (address) {
538         return msg.sender;
539     }
540 
541     function _msgData() internal view virtual returns (bytes calldata) {
542         return msg.data;
543     }
544 }
545 
546 
547 
548 /**
549  * @dev Contract module which provides a basic access control mechanism, where
550  * there is an account (an owner) that can be granted exclusive access to
551  * specific functions.
552  *
553  * By default, the owner account will be the one that deploys the contract. This
554  * can later be changed with {transferOwnership}.
555  *
556  * This module is used through inheritance. It will make available the modifier
557  * `onlyOwner`, which can be applied to your functions to restrict their use to
558  * the owner.
559  */
560 abstract contract Ownable is Context {
561     address private _owner;
562 
563     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
564 
565     /**
566      * @dev Initializes the contract setting the deployer as the initial owner.
567      */
568     constructor() {
569         _transferOwnership(_msgSender());
570     }
571 
572     /**
573      * @dev Returns the address of the current owner.
574      */
575     function owner() public view virtual returns (address) {
576         return _owner;
577     }
578 
579     /**
580      * @dev Throws if called by any account other than the owner.
581      */
582     modifier onlyOwner() {
583         require(owner() == _msgSender(), "Ownable: caller is not the owner");
584         _;
585     }
586 
587     /**
588      * @dev Leaves the contract without owner. It will not be possible to call
589      * `onlyOwner` functions anymore. Can only be called by the current owner.
590      *
591      * NOTE: Renouncing ownership will leave the contract without an owner,
592      * thereby removing any functionality that is only available to the owner.
593      */
594     function renounceOwnership() public virtual onlyOwner {
595         _transferOwnership(address(0));
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Can only be called by the current owner.
601      */
602     function transferOwnership(address newOwner) public virtual onlyOwner {
603         require(newOwner != address(0), "Ownable: new owner is the zero address");
604         _transferOwnership(newOwner);
605     }
606 
607     /**
608      * @dev Transfers ownership of the contract to a new account (`newOwner`).
609      * Internal function without access restriction.
610      */
611     function _transferOwnership(address newOwner) internal virtual {
612         address oldOwner = _owner;
613         _owner = newOwner;
614         emit OwnershipTransferred(oldOwner, newOwner);
615     }
616 }
617 
618 
619 
620 /**
621  * @dev These functions deal with verification of Merkle Trees proofs.
622  *
623  * The proofs can be generated using the JavaScript library
624  * https://github.com/miguelmota/merkletreejs[merkletreejs].
625  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
626  *
627  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
628  *
629  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
630  * hashing, or use a hash function other than keccak256 for hashing leaves.
631  * This is because the concatenation of a sorted pair of internal nodes in
632  * the merkle tree could be reinterpreted as a leaf value.
633  */
634 library MerkleProof {
635     /**
636      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
637      * defined by `root`. For this, a `proof` must be provided, containing
638      * sibling hashes on the branch from the leaf to the root of the tree. Each
639      * pair of leaves and each pair of pre-images are assumed to be sorted.
640      */
641     function verify(
642         bytes32[] memory proof,
643         bytes32 root,
644         bytes32 leaf
645     ) internal pure returns (bool) {
646         return processProof(proof, leaf) == root;
647     }
648 
649     /**
650      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
651      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
652      * hash matches the root of the tree. When processing the proof, the pairs
653      * of leafs & pre-images are assumed to be sorted.
654      *
655      * _Available since v4.4._
656      */
657     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
658         bytes32 computedHash = leaf;
659         for (uint256 i = 0; i < proof.length; i++) {
660             bytes32 proofElement = proof[i];
661             if (computedHash <= proofElement) {
662                 // Hash(current computed hash + current element of the proof)
663                 computedHash = _efficientHash(computedHash, proofElement);
664             } else {
665                 // Hash(current element of the proof + current computed hash)
666                 computedHash = _efficientHash(proofElement, computedHash);
667             }
668         }
669         return computedHash;
670     }
671 
672     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
673         assembly {
674             mstore(0x00, a)
675             mstore(0x20, b)
676             value := keccak256(0x00, 0x40)
677         }
678     }
679 }
680 
681 
682 
683 /**
684  * @dev Contract module that helps prevent reentrant calls to a function.
685  *
686  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
687  * available, which can be applied to functions to make sure there are no nested
688  * (reentrant) calls to them.
689  *
690  * Note that because there is a single `nonReentrant` guard, functions marked as
691  * `nonReentrant` may not call one another. This can be worked around by making
692  * those functions `private`, and then adding `external` `nonReentrant` entry
693  * points to them.
694  *
695  * TIP: If you would like to learn more about reentrancy and alternative ways
696  * to protect against it, check out our blog post
697  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
698  */
699 abstract contract ReentrancyGuard {
700     // Booleans are more expensive than uint256 or any type that takes up a full
701     // word because each write operation emits an extra SLOAD to first read the
702     // slot's contents, replace the bits taken up by the boolean, and then write
703     // back. This is the compiler's defense against contract upgrades and
704     // pointer aliasing, and it cannot be disabled.
705 
706     // The values being non-zero value makes deployment a bit more expensive,
707     // but in exchange the refund on every call to nonReentrant will be lower in
708     // amount. Since refunds are capped to a percentage of the total
709     // transaction's gas, it is best to keep them low in cases like this one, to
710     // increase the likelihood of the full refund coming into effect.
711     uint256 private constant _NOT_ENTERED = 1;
712     uint256 private constant _ENTERED = 2;
713 
714     uint256 private _status;
715 
716     constructor() {
717         _status = _NOT_ENTERED;
718     }
719 
720     /**
721      * @dev Prevents a contract from calling itself, directly or indirectly.
722      * Calling a `nonReentrant` function from another `nonReentrant`
723      * function is not supported. It is possible to prevent this from happening
724      * by making the `nonReentrant` function external, and making it call a
725      * `private` function that does the actual work.
726      */
727     modifier nonReentrant() {
728         // On the first call to nonReentrant, _notEntered will be true
729         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
730 
731         // Any calls to nonReentrant after this point will fail
732         _status = _ENTERED;
733 
734         _;
735 
736         // By storing the original value once again, a refund is triggered (see
737         // https://eips.ethereum.org/EIPS/eip-2200)
738         _status = _NOT_ENTERED;
739     }
740 }
741 
742 
743 
744 /**
745  * @dev Implementation of the {IERC165} interface.
746  *
747  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
748  * for the additional interface id that will be supported. For example:
749  *
750  * ```solidity
751  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
752  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
753  * }
754  * ```
755  *
756  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
757  */
758 abstract contract ERC165 is IERC165 {
759     /**
760      * @dev See {IERC165-supportsInterface}.
761      */
762     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
763         return interfaceId == type(IERC165).interfaceId;
764     }
765 }
766 
767 
768 
769 error ApprovalCallerNotOwnerNorApproved();
770 error ApprovalQueryForNonexistentToken();
771 error ApproveToCaller();
772 error ApprovalToCurrentOwner();
773 error BalanceQueryForZeroAddress();
774 error MintedQueryForZeroAddress();
775 error BurnedQueryForZeroAddress();
776 error AuxQueryForZeroAddress();
777 error MintToZeroAddress();
778 error MintZeroQuantity();
779 error OwnerIndexOutOfBounds();
780 error OwnerQueryForNonexistentToken();
781 error TokenIndexOutOfBounds();
782 error TransferCallerNotOwnerNorApproved();
783 error TransferFromIncorrectOwner();
784 error TransferToNonERC721ReceiverImplementer();
785 error TransferToZeroAddress();
786 error URIQueryForNonexistentToken();
787 
788 /**
789  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
790  * the Metadata extension. Built to optimize for lower gas during batch mints.
791  *
792  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
793  *
794  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
795  *
796  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
797  */
798 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
799     using Address for address;
800     using Strings for uint256;
801 
802     // Compiler will pack this into a single 256bit word.
803     struct TokenOwnership {
804         // The address of the owner.
805         address addr;
806         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
807         uint64 startTimestamp;
808         // Whether the token has been burned.
809         bool burned;
810     }
811 
812     // Compiler will pack this into a single 256bit word.
813     struct AddressData {
814         // Realistically, 2**64-1 is more than enough.
815         uint64 balance;
816         // Keeps track of mint count with minimal overhead for tokenomics.
817         uint64 numberMinted;
818         // Keeps track of burn count with minimal overhead for tokenomics.
819         uint64 numberBurned;
820         // For miscellaneous variable(s) pertaining to the address
821         // (e.g. number of whitelist mint slots used). 
822         // If there are multiple variables, please pack them into a uint64.
823         uint64 aux;
824     }
825 
826     // The tokenId of the next token to be minted.
827     uint256 internal _currentIndex;
828 
829     // The number of tokens burned.
830     uint256 internal _burnCounter;
831 
832     // Token name
833     string private _name;
834 
835     // Token symbol
836     string private _symbol;
837 
838     // Mapping from token ID to ownership details
839     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
840     mapping(uint256 => TokenOwnership) internal _ownerships;
841 
842     // Mapping owner address to address data
843     mapping(address => AddressData) private _addressData;
844 
845     // Mapping from token ID to approved address
846     mapping(uint256 => address) private _tokenApprovals;
847 
848     // Mapping from owner to operator approvals
849     mapping(address => mapping(address => bool)) private _operatorApprovals;
850 
851     constructor(string memory name_, string memory symbol_) {
852         _name = name_;
853         _symbol = symbol_;
854     }
855 
856     /**
857      * @dev See {IERC721Enumerable-totalSupply}.
858      */
859     function totalSupply() public view returns (uint256) {
860         // Counter underflow is impossible as _burnCounter cannot be incremented
861         // more than _currentIndex times
862         unchecked {
863             return _currentIndex - _burnCounter;    
864         }
865     }
866 
867     /**
868      * @dev See {IERC165-supportsInterface}.
869      */
870     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
871         return
872             interfaceId == type(IERC721).interfaceId ||
873             interfaceId == type(IERC721Metadata).interfaceId ||
874             super.supportsInterface(interfaceId);
875     }
876 
877     /**
878      * @dev See {IERC721-balanceOf}.
879      */
880     function balanceOf(address owner) public view override returns (uint256) {
881         if (owner == address(0)) revert BalanceQueryForZeroAddress();
882         return uint256(_addressData[owner].balance);
883     }
884 
885     /**
886      * Returns the number of tokens minted by `owner`.
887      */
888     function _numberMinted(address owner) internal view returns (uint256) {
889         if (owner == address(0)) revert MintedQueryForZeroAddress();
890         return uint256(_addressData[owner].numberMinted);
891     }
892 
893     /**
894      * Returns the number of tokens burned by or on behalf of `owner`.
895      */
896     function _numberBurned(address owner) internal view returns (uint256) {
897         if (owner == address(0)) revert BurnedQueryForZeroAddress();
898         return uint256(_addressData[owner].numberBurned);
899     }
900 
901     /**
902      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
903      */
904     function _getAux(address owner) internal view returns (uint64) {
905         if (owner == address(0)) revert AuxQueryForZeroAddress();
906         return _addressData[owner].aux;
907     }
908 
909     /**
910      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
911      * If there are multiple variables, please pack them into a uint64.
912      */
913     function _setAux(address owner, uint64 aux) internal {
914         if (owner == address(0)) revert AuxQueryForZeroAddress();
915         _addressData[owner].aux = aux;
916     }
917 
918     /**
919      * Gas spent here starts off proportional to the maximum mint batch size.
920      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
921      */
922     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
923         uint256 curr = tokenId;
924 
925         unchecked {
926             if (curr < _currentIndex) {
927                 TokenOwnership memory ownership = _ownerships[curr];
928                 if (!ownership.burned) {
929                     if (ownership.addr != address(0)) {
930                         return ownership;
931                     }
932                     // Invariant: 
933                     // There will always be an ownership that has an address and is not burned 
934                     // before an ownership that does not have an address and is not burned.
935                     // Hence, curr will not underflow.
936                     while (true) {
937                         curr--;
938                         ownership = _ownerships[curr];
939                         if (ownership.addr != address(0)) {
940                             return ownership;
941                         }
942                     }
943                 }
944             }
945         }
946         revert OwnerQueryForNonexistentToken();
947     }
948 
949     /**
950      * @dev See {IERC721-ownerOf}.
951      */
952     function ownerOf(uint256 tokenId) public view override returns (address) {
953         return ownershipOf(tokenId).addr;
954     }
955 
956     /**
957      * @dev See {IERC721Metadata-name}.
958      */
959     function name() public view virtual override returns (string memory) {
960         return _name;
961     }
962 
963     /**
964      * @dev See {IERC721Metadata-symbol}.
965      */
966     function symbol() public view virtual override returns (string memory) {
967         return _symbol;
968     }
969 
970     /**
971      * @dev See {IERC721Metadata-tokenURI}.
972      */
973     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
974         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
975 
976         string memory baseURI = _baseURI();
977         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
978     }
979 
980     /**
981      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
982      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
983      * by default, can be overriden in child contracts.
984      */
985     function _baseURI() internal view virtual returns (string memory) {
986         return '';
987     }
988 
989     /**
990      * @dev See {IERC721-approve}.
991      */
992     function approve(address to, uint256 tokenId) public override {
993         address owner = ERC721A.ownerOf(tokenId);
994         if (to == owner) revert ApprovalToCurrentOwner();
995 
996         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
997             revert ApprovalCallerNotOwnerNorApproved();
998         }
999 
1000         _approve(to, tokenId, owner);
1001     }
1002 
1003     /**
1004      * @dev See {IERC721-getApproved}.
1005      */
1006     function getApproved(uint256 tokenId) public view override returns (address) {
1007         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1008 
1009         return _tokenApprovals[tokenId];
1010     }
1011 
1012     /**
1013      * @dev See {IERC721-setApprovalForAll}.
1014      */
1015     function setApprovalForAll(address operator, bool approved) public override {
1016         if (operator == _msgSender()) revert ApproveToCaller();
1017 
1018         _operatorApprovals[_msgSender()][operator] = approved;
1019         emit ApprovalForAll(_msgSender(), operator, approved);
1020     }
1021 
1022     /**
1023      * @dev See {IERC721-isApprovedForAll}.
1024      */
1025     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1026         return _operatorApprovals[owner][operator];
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-transferFrom}.
1031      */
1032     function transferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public virtual override {
1037         _transfer(from, to, tokenId);
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) public virtual override {
1048         safeTransferFrom(from, to, tokenId, '');
1049     }
1050 
1051     /**
1052      * @dev See {IERC721-safeTransferFrom}.
1053      */
1054     function safeTransferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId,
1058         bytes memory _data
1059     ) public virtual override {
1060         _transfer(from, to, tokenId);
1061         if (!_checkOnERC721Received(from, to, tokenId, _data)) {
1062             revert TransferToNonERC721ReceiverImplementer();
1063         }
1064     }
1065 
1066     /**
1067      * @dev Returns whether `tokenId` exists.
1068      *
1069      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1070      *
1071      * Tokens start existing when they are minted (`_mint`),
1072      */
1073     function _exists(uint256 tokenId) internal view returns (bool) {
1074         return tokenId < _currentIndex && !_ownerships[tokenId].burned;
1075     }
1076 
1077     function _safeMint(address to, uint256 quantity) internal {
1078         _safeMint(to, quantity, '');
1079     }
1080 
1081     /**
1082      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1087      * - `quantity` must be greater than 0.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _safeMint(
1092         address to,
1093         uint256 quantity,
1094         bytes memory _data
1095     ) internal {
1096         _mint(to, quantity, _data, true);
1097     }
1098 
1099     /**
1100      * @dev Mints `quantity` tokens and transfers them to `to`.
1101      *
1102      * Requirements:
1103      *
1104      * - `to` cannot be the zero address.
1105      * - `quantity` must be greater than 0.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function _mint(
1110         address to,
1111         uint256 quantity,
1112         bytes memory _data,
1113         bool safe
1114     ) internal {
1115         uint256 startTokenId = _currentIndex;
1116         if (to == address(0)) revert MintToZeroAddress();
1117         if (quantity == 0) revert MintZeroQuantity();
1118 
1119         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1120 
1121         // Overflows are incredibly unrealistic.
1122         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1123         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1124         unchecked {
1125             _addressData[to].balance += uint64(quantity);
1126             _addressData[to].numberMinted += uint64(quantity);
1127 
1128             _ownerships[startTokenId].addr = to;
1129             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1130 
1131             uint256 updatedIndex = startTokenId;
1132 
1133             for (uint256 i; i < quantity; i++) {
1134                 emit Transfer(address(0), to, updatedIndex);
1135                 if (safe && !_checkOnERC721Received(address(0), to, updatedIndex, _data)) {
1136                     revert TransferToNonERC721ReceiverImplementer();
1137                 }
1138                 updatedIndex++;
1139             }
1140 
1141             _currentIndex = updatedIndex;
1142         }
1143         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1144     }
1145 
1146     /**
1147      * @dev Transfers `tokenId` from `from` to `to`.
1148      *
1149      * Requirements:
1150      *
1151      * - `to` cannot be the zero address.
1152      * - `tokenId` token must be owned by `from`.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function _transfer(
1157         address from,
1158         address to,
1159         uint256 tokenId
1160     ) private {
1161         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1162 
1163         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1164             isApprovedForAll(prevOwnership.addr, _msgSender()) ||
1165             getApproved(tokenId) == _msgSender());
1166 
1167         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1168         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1169         if (to == address(0)) revert TransferToZeroAddress();
1170 
1171         _beforeTokenTransfers(from, to, tokenId, 1);
1172 
1173         // Clear approvals from the previous owner
1174         _approve(address(0), tokenId, prevOwnership.addr);
1175 
1176         // Underflow of the sender's balance is impossible because we check for
1177         // ownership above and the recipient's balance can't realistically overflow.
1178         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1179         unchecked {
1180             _addressData[from].balance -= 1;
1181             _addressData[to].balance += 1;
1182 
1183             _ownerships[tokenId].addr = to;
1184             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1185 
1186             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1187             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1188             uint256 nextTokenId = tokenId + 1;
1189             if (_ownerships[nextTokenId].addr == address(0)) {
1190                 // This will suffice for checking _exists(nextTokenId),
1191                 // as a burned slot cannot contain the zero address.
1192                 if (nextTokenId < _currentIndex) {
1193                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1194                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1195                 }
1196             }
1197         }
1198 
1199         emit Transfer(from, to, tokenId);
1200         _afterTokenTransfers(from, to, tokenId, 1);
1201     }
1202 
1203     /**
1204      * @dev Destroys `tokenId`.
1205      * The approval is cleared when the token is burned.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must exist.
1210      *
1211      * Emits a {Transfer} event.
1212      */
1213     function _burn(uint256 tokenId) internal virtual {
1214         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1215 
1216         _beforeTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1217 
1218         // Clear approvals from the previous owner
1219         _approve(address(0), tokenId, prevOwnership.addr);
1220 
1221         // Underflow of the sender's balance is impossible because we check for
1222         // ownership above and the recipient's balance can't realistically overflow.
1223         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1224         unchecked {
1225             _addressData[prevOwnership.addr].balance -= 1;
1226             _addressData[prevOwnership.addr].numberBurned += 1;
1227 
1228             // Keep track of who burned the token, and the timestamp of burning.
1229             _ownerships[tokenId].addr = prevOwnership.addr;
1230             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1231             _ownerships[tokenId].burned = true;
1232 
1233             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1234             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1235             uint256 nextTokenId = tokenId + 1;
1236             if (_ownerships[nextTokenId].addr == address(0)) {
1237                 // This will suffice for checking _exists(nextTokenId),
1238                 // as a burned slot cannot contain the zero address.
1239                 if (nextTokenId < _currentIndex) {
1240                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1241                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1242                 }
1243             }
1244         }
1245 
1246         emit Transfer(prevOwnership.addr, address(0), tokenId);
1247         _afterTokenTransfers(prevOwnership.addr, address(0), tokenId, 1);
1248 
1249         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1250         unchecked { 
1251             _burnCounter++;
1252         }
1253     }
1254 
1255     /**
1256      * @dev Approve `to` to operate on `tokenId`
1257      *
1258      * Emits a {Approval} event.
1259      */
1260     function _approve(
1261         address to,
1262         uint256 tokenId,
1263         address owner
1264     ) private {
1265         _tokenApprovals[tokenId] = to;
1266         emit Approval(owner, to, tokenId);
1267     }
1268 
1269     /**
1270      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1271      * The call is not executed if the target address is not a contract.
1272      *
1273      * @param from address representing the previous owner of the given token ID
1274      * @param to target address that will receive the tokens
1275      * @param tokenId uint256 ID of the token to be transferred
1276      * @param _data bytes optional data to send along with the call
1277      * @return bool whether the call correctly returned the expected magic value
1278      */
1279     function _checkOnERC721Received(
1280         address from,
1281         address to,
1282         uint256 tokenId,
1283         bytes memory _data
1284     ) private returns (bool) {
1285         if (to.isContract()) {
1286             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1287                 return retval == IERC721Receiver(to).onERC721Received.selector;
1288             } catch (bytes memory reason) {
1289                 if (reason.length == 0) {
1290                     revert TransferToNonERC721ReceiverImplementer();
1291                 } else {
1292                     assembly {
1293                         revert(add(32, reason), mload(reason))
1294                     }
1295                 }
1296             }
1297         } else {
1298             return true;
1299         }
1300     }
1301 
1302     /**
1303      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1304      * And also called before burning one token.
1305      *
1306      * startTokenId - the first token id to be transferred
1307      * quantity - the amount to be transferred
1308      *
1309      * Calling conditions:
1310      *
1311      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1312      * transferred to `to`.
1313      * - When `from` is zero, `tokenId` will be minted for `to`.
1314      * - When `to` is zero, `tokenId` will be burned by `from`.
1315      * - `from` and `to` are never both zero.
1316      */
1317     function _beforeTokenTransfers(
1318         address from,
1319         address to,
1320         uint256 startTokenId,
1321         uint256 quantity
1322     ) internal virtual {}
1323 
1324     /**
1325      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1326      * minting.
1327      * And also called after one token has been burned.
1328      *
1329      * startTokenId - the first token id to be transferred
1330      * quantity - the amount to be transferred
1331      *
1332      * Calling conditions:
1333      *
1334      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1335      * transferred to `to`.
1336      * - When `from` is zero, `tokenId` has been minted for `to`.
1337      * - When `to` is zero, `tokenId` has been burned by `from`.
1338      * - `from` and `to` are never both zero.
1339      */
1340     function _afterTokenTransfers(
1341         address from,
1342         address to,
1343         uint256 startTokenId,
1344         uint256 quantity
1345     ) internal virtual {}
1346 }
1347 
1348 
1349 
1350 contract LegendsOfAtlantis is ERC721A, Ownable, ReentrancyGuard {
1351     using Strings for uint256;
1352 
1353     string  public baseURI;
1354     string  public hiddenURI;
1355     string  public legendaryURI;
1356     bytes32 public whitelistMerkleRoot;
1357 
1358     uint256 public constant whitelistCost     = 0.099 ether;
1359     uint256 public          publicCost        = 0.125 ether;
1360     uint256 public constant maxSupply         = 7777;
1361     uint256 public          maxMintPerAddress = 3;
1362 
1363     bool public paused          = true;
1364     bool public revealed        = false;
1365     bool public onlyWhitelisted = true;
1366 
1367     mapping(address => uint256) addressAlreadyMinted;
1368     mapping(uint256 => bool) public isLegendary;
1369 
1370     constructor() ERC721A("Legends of Atlantis", "LOA") {}
1371 
1372     function mint(uint256 _mintAmount, bytes32[] calldata _merkleProof) public payable nonReentrant {
1373         require(!paused, "Contract is paused!");
1374         require(totalSupply() + _mintAmount < maxSupply + 1, "Max supply exceeded!");
1375         require(addressAlreadyMinted[msg.sender] + _mintAmount < maxMintPerAddress + 1, "Max NFT per address exceeded!");
1376 
1377         if (onlyWhitelisted == true) {
1378             require(_isWhitelisted(msg.sender, _merkleProof), "Not a whitelisted user!");
1379             require(msg.value >= whitelistCost * _mintAmount, "Insufficient funds!");
1380         } else {
1381             require(msg.value >= publicCost * _mintAmount, "Insufficient funds!");
1382         }
1383 
1384         addressAlreadyMinted[msg.sender] += _mintAmount;
1385         _mint(msg.sender, _mintAmount, "", true);
1386     }
1387 
1388     function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
1389         require(totalSupply() + _mintAmount < maxSupply + 1, "Max supply exceeded!");
1390         _mint(_receiver, _mintAmount, "", true);
1391     }
1392 
1393     function tokenURI(uint256 _tokenId)
1394         public
1395         view
1396         virtual
1397         override
1398         returns (string memory)
1399     {
1400         require(
1401             _exists(_tokenId),
1402             "ERC721Metadata: URI query for nonexistent token"
1403         );
1404 
1405         if (revealed == false) {
1406             if (isLegendary[_tokenId] == true) {
1407                 return legendaryURI;
1408             }
1409             return hiddenURI;
1410         }
1411 
1412         string memory currentBaseURI = _baseURI();
1413         return bytes(currentBaseURI).length > 0
1414             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), ".json"))
1415             : "";
1416     }
1417 
1418     function getMintedCount(address _address) public view returns(uint256) {
1419         return addressAlreadyMinted[_address];
1420     }
1421 
1422     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1423         baseURI = _newBaseURI;
1424     }
1425 
1426     function setHiddenURI(string memory _newHiddenURI) public onlyOwner {
1427         hiddenURI = _newHiddenURI;
1428     }
1429 
1430     function setLegendaryURI(string memory _newLegendaryURI) public onlyOwner {
1431         legendaryURI = _newLegendaryURI;
1432     }
1433 
1434     function setLegendary(uint256 _id) public onlyOwner {
1435         isLegendary[_id] = true;
1436     }
1437 
1438     function setOnlyWhitelisted(bool _state) public onlyOwner {
1439         onlyWhitelisted = _state;
1440     }
1441 
1442     function setWhitelistMerkleRoot(bytes32 _root) public onlyOwner {
1443         whitelistMerkleRoot = _root;
1444     }
1445 
1446     function setPaused(bool _state) public onlyOwner {
1447         paused = _state;
1448     }
1449 
1450     function setRevealed(bool _state) public onlyOwner {
1451         revealed = _state;
1452     }
1453 
1454     function setPublicCost(uint256 _price) public onlyOwner {
1455         publicCost = _price;
1456     }
1457 
1458     function setMaxMintPerAddress(uint256 _newLimit) public onlyOwner {
1459         maxMintPerAddress = _newLimit;
1460     }
1461 
1462     function withdraw() public {
1463         (bool os, ) = payable(0xC9f2bCEb813509e452FA8096ee2d9D93E21E31Ce).call{value: address(this).balance }("");
1464         require(os, "Withdraw failed!");
1465     }
1466 
1467     function _baseURI() internal view virtual override returns (string memory) {
1468         return baseURI;
1469     }
1470 
1471     function _isWhitelisted(address _user, bytes32[] calldata _merkleProof) internal view returns (bool) {
1472         // get leaf 
1473         bytes32 leaf = keccak256(abi.encodePacked(_user));
1474         // verify using MerkleProof.sol
1475         require(MerkleProof.verify(_merkleProof, whitelistMerkleRoot, leaf), "Invalid proof!"); // verify the proof
1476         return true;
1477     }
1478 }