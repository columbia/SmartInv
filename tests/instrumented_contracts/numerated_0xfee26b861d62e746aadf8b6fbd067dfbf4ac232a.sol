1 // File: contracts/Mempo/IERC2981Royalties.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /// @title IERC2981Royalties
7 /// @dev Interface for the ERC2981 - Token Royalty standard
8 interface IERC2981Royalties {
9     /// @notice Called with the sale price to determine how much royalty
10     //          is owed and to whom.
11     /// @param _tokenId - the NFT asset queried for royalty information
12     /// @param _value - the sale price of the NFT asset specified by _tokenId
13     /// @return _receiver - address of who should be sent the royalty payment
14     /// @return _royaltyAmount - the royalty payment amount for value sale price
15     function royaltyInfo(uint256 _tokenId, uint256 _value)
16         external
17         view
18         returns (address _receiver, uint256 _royaltyAmount);
19 }
20 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
21 
22 
23 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev These functions deal with verification of Merkle Trees proofs.
29  *
30  * The proofs can be generated using the JavaScript library
31  * https://github.com/miguelmota/merkletreejs[merkletreejs].
32  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
33  *
34  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
35  */
36 library MerkleProof {
37     /**
38      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
39      * defined by `root`. For this, a `proof` must be provided, containing
40      * sibling hashes on the branch from the leaf to the root of the tree. Each
41      * pair of leaves and each pair of pre-images are assumed to be sorted.
42      */
43     function verify(
44         bytes32[] memory proof,
45         bytes32 root,
46         bytes32 leaf
47     ) internal pure returns (bool) {
48         return processProof(proof, leaf) == root;
49     }
50 
51     /**
52      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
53      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
54      * hash matches the root of the tree. When processing the proof, the pairs
55      * of leafs & pre-images are assumed to be sorted.
56      *
57      * _Available since v4.4._
58      */
59     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
60         bytes32 computedHash = leaf;
61         for (uint256 i = 0; i < proof.length; i++) {
62             bytes32 proofElement = proof[i];
63             if (computedHash <= proofElement) {
64                 // Hash(current computed hash + current element of the proof)
65                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
66             } else {
67                 // Hash(current element of the proof + current computed hash)
68                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
69             }
70         }
71         return computedHash;
72     }
73 }
74 
75 // File: @openzeppelin/contracts/utils/Strings.sol
76 
77 
78 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
79 
80 pragma solidity ^0.8.0;
81 
82 /**
83  * @dev String operations.
84  */
85 library Strings {
86     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
87 
88     /**
89      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
90      */
91     function toString(uint256 value) internal pure returns (string memory) {
92         // Inspired by OraclizeAPI's implementation - MIT licence
93         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
94 
95         if (value == 0) {
96             return "0";
97         }
98         uint256 temp = value;
99         uint256 digits;
100         while (temp != 0) {
101             digits++;
102             temp /= 10;
103         }
104         bytes memory buffer = new bytes(digits);
105         while (value != 0) {
106             digits -= 1;
107             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
108             value /= 10;
109         }
110         return string(buffer);
111     }
112 
113     /**
114      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
115      */
116     function toHexString(uint256 value) internal pure returns (string memory) {
117         if (value == 0) {
118             return "0x00";
119         }
120         uint256 temp = value;
121         uint256 length = 0;
122         while (temp != 0) {
123             length++;
124             temp >>= 8;
125         }
126         return toHexString(value, length);
127     }
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
131      */
132     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
133         bytes memory buffer = new bytes(2 * length + 2);
134         buffer[0] = "0";
135         buffer[1] = "x";
136         for (uint256 i = 2 * length + 1; i > 1; --i) {
137             buffer[i] = _HEX_SYMBOLS[value & 0xf];
138             value >>= 4;
139         }
140         require(value == 0, "Strings: hex length insufficient");
141         return string(buffer);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/Context.sol
146 
147 
148 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev Provides information about the current execution context, including the
154  * sender of the transaction and its data. While these are generally available
155  * via msg.sender and msg.data, they should not be accessed in such a direct
156  * manner, since when dealing with meta-transactions the account sending and
157  * paying for execution may not be the actual sender (as far as an application
158  * is concerned).
159  *
160  * This contract is only required for intermediate, library-like contracts.
161  */
162 abstract contract Context {
163     function _msgSender() internal view virtual returns (address) {
164         return msg.sender;
165     }
166 
167     function _msgData() internal view virtual returns (bytes calldata) {
168         return msg.data;
169     }
170 }
171 
172 // File: @openzeppelin/contracts/access/Ownable.sol
173 
174 
175 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
176 
177 pragma solidity ^0.8.0;
178 
179 
180 /**
181  * @dev Contract module which provides a basic access control mechanism, where
182  * there is an account (an owner) that can be granted exclusive access to
183  * specific functions.
184  *
185  * By default, the owner account will be the one that deploys the contract. This
186  * can later be changed with {transferOwnership}.
187  *
188  * This module is used through inheritance. It will make available the modifier
189  * `onlyOwner`, which can be applied to your functions to restrict their use to
190  * the owner.
191  */
192 abstract contract Ownable is Context {
193     address private _owner;
194 
195     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
196 
197     /**
198      * @dev Initializes the contract setting the deployer as the initial owner.
199      */
200     constructor() {
201         _transferOwnership(_msgSender());
202     }
203 
204     /**
205      * @dev Returns the address of the current owner.
206      */
207     function owner() public view virtual returns (address) {
208         return _owner;
209     }
210 
211     /**
212      * @dev Throws if called by any account other than the owner.
213      */
214     modifier onlyOwner() {
215         require(owner() == _msgSender(), "Ownable: caller is not the owner");
216         _;
217     }
218 
219     /**
220      * @dev Leaves the contract without owner. It will not be possible to call
221      * `onlyOwner` functions anymore. Can only be called by the current owner.
222      *
223      * NOTE: Renouncing ownership will leave the contract without an owner,
224      * thereby removing any functionality that is only available to the owner.
225      */
226     function renounceOwnership() public virtual onlyOwner {
227         _transferOwnership(address(0));
228     }
229 
230     /**
231      * @dev Transfers ownership of the contract to a new account (`newOwner`).
232      * Can only be called by the current owner.
233      */
234     function transferOwnership(address newOwner) public virtual onlyOwner {
235         require(newOwner != address(0), "Ownable: new owner is the zero address");
236         _transferOwnership(newOwner);
237     }
238 
239     /**
240      * @dev Transfers ownership of the contract to a new account (`newOwner`).
241      * Internal function without access restriction.
242      */
243     function _transferOwnership(address newOwner) internal virtual {
244         address oldOwner = _owner;
245         _owner = newOwner;
246         emit OwnershipTransferred(oldOwner, newOwner);
247     }
248 }
249 
250 // File: @openzeppelin/contracts/utils/Address.sol
251 
252 
253 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev Collection of functions related to the address type
259  */
260 library Address {
261     /**
262      * @dev Returns true if `account` is a contract.
263      *
264      * [IMPORTANT]
265      * ====
266      * It is unsafe to assume that an address for which this function returns
267      * false is an externally-owned account (EOA) and not a contract.
268      *
269      * Among others, `isContract` will return false for the following
270      * types of addresses:
271      *
272      *  - an externally-owned account
273      *  - a contract in construction
274      *  - an address where a contract will be created
275      *  - an address where a contract lived, but was destroyed
276      * ====
277      */
278     function isContract(address account) internal view returns (bool) {
279         // This method relies on extcodesize, which returns 0 for contracts in
280         // construction, since the code is only stored at the end of the
281         // constructor execution.
282 
283         uint256 size;
284         assembly {
285             size := extcodesize(account)
286         }
287         return size > 0;
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
559 // File: contracts/Mempo/ERC2981Base.sol
560 
561 
562 pragma solidity ^0.8.0;
563 
564 
565 
566 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
567 abstract contract ERC2981Base is ERC165, IERC2981Royalties {
568     struct RoyaltyInfo {
569         address recipient;
570         uint24 amount;
571     }
572 
573     /// @inheritdoc	ERC165
574     function supportsInterface(bytes4 interfaceId)
575         public
576         view
577         virtual
578         override
579         returns (bool)
580     {
581         return
582             interfaceId == type(IERC2981Royalties).interfaceId ||
583             super.supportsInterface(interfaceId);
584     }
585 }
586 // File: contracts/Mempo/ERC2981ContractWideRoyalties.sol
587 
588 
589 pragma solidity ^0.8.0;
590 
591 
592 
593 /// @dev This is a contract used to add ERC2981 support to ERC721 and 1155
594 /// @dev This implementation has the same royalties for each and every tokens
595 abstract contract ERC2981ContractWideRoyalties is ERC2981Base {
596     RoyaltyInfo private _royalties;
597 
598     /// @dev Sets token royalties
599     /// @param recipient recipient of the royalties
600     /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
601     function _setRoyalties(address recipient, uint256 value) internal {
602         require(value <= 10000, 'ERC2981Royalties: Too high');
603         _royalties = RoyaltyInfo(recipient, uint24(value));
604     }
605 
606     /// @inheritdoc	IERC2981Royalties
607     function royaltyInfo(uint256, uint256 value)
608         external
609         view
610         override
611         returns (address receiver, uint256 royaltyAmount)
612     {
613         RoyaltyInfo memory royalties = _royalties;
614         receiver = royalties.recipient;
615         royaltyAmount = (value * royalties.amount) / 10000;
616     }
617 }
618 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
619 
620 
621 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
622 
623 pragma solidity ^0.8.0;
624 
625 
626 /**
627  * @dev Required interface of an ERC721 compliant contract.
628  */
629 interface IERC721 is IERC165 {
630     /**
631      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
632      */
633     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
634 
635     /**
636      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
637      */
638     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
639 
640     /**
641      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
642      */
643     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
644 
645     /**
646      * @dev Returns the number of tokens in ``owner``'s account.
647      */
648     function balanceOf(address owner) external view returns (uint256 balance);
649 
650     /**
651      * @dev Returns the owner of the `tokenId` token.
652      *
653      * Requirements:
654      *
655      * - `tokenId` must exist.
656      */
657     function ownerOf(uint256 tokenId) external view returns (address owner);
658 
659     /**
660      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
661      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
662      *
663      * Requirements:
664      *
665      * - `from` cannot be the zero address.
666      * - `to` cannot be the zero address.
667      * - `tokenId` token must exist and be owned by `from`.
668      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
669      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
670      *
671      * Emits a {Transfer} event.
672      */
673     function safeTransferFrom(
674         address from,
675         address to,
676         uint256 tokenId
677     ) external;
678 
679     /**
680      * @dev Transfers `tokenId` token from `from` to `to`.
681      *
682      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
683      *
684      * Requirements:
685      *
686      * - `from` cannot be the zero address.
687      * - `to` cannot be the zero address.
688      * - `tokenId` token must be owned by `from`.
689      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
690      *
691      * Emits a {Transfer} event.
692      */
693     function transferFrom(
694         address from,
695         address to,
696         uint256 tokenId
697     ) external;
698 
699     /**
700      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
701      * The approval is cleared when the token is transferred.
702      *
703      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
704      *
705      * Requirements:
706      *
707      * - The caller must own the token or be an approved operator.
708      * - `tokenId` must exist.
709      *
710      * Emits an {Approval} event.
711      */
712     function approve(address to, uint256 tokenId) external;
713 
714     /**
715      * @dev Returns the account approved for `tokenId` token.
716      *
717      * Requirements:
718      *
719      * - `tokenId` must exist.
720      */
721     function getApproved(uint256 tokenId) external view returns (address operator);
722 
723     /**
724      * @dev Approve or remove `operator` as an operator for the caller.
725      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
726      *
727      * Requirements:
728      *
729      * - The `operator` cannot be the caller.
730      *
731      * Emits an {ApprovalForAll} event.
732      */
733     function setApprovalForAll(address operator, bool _approved) external;
734 
735     /**
736      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
737      *
738      * See {setApprovalForAll}
739      */
740     function isApprovedForAll(address owner, address operator) external view returns (bool);
741 
742     /**
743      * @dev Safely transfers `tokenId` token from `from` to `to`.
744      *
745      * Requirements:
746      *
747      * - `from` cannot be the zero address.
748      * - `to` cannot be the zero address.
749      * - `tokenId` token must exist and be owned by `from`.
750      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
751      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
752      *
753      * Emits a {Transfer} event.
754      */
755     function safeTransferFrom(
756         address from,
757         address to,
758         uint256 tokenId,
759         bytes calldata data
760     ) external;
761 }
762 
763 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
764 
765 
766 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
767 
768 pragma solidity ^0.8.0;
769 
770 
771 /**
772  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
773  * @dev See https://eips.ethereum.org/EIPS/eip-721
774  */
775 interface IERC721Enumerable is IERC721 {
776     /**
777      * @dev Returns the total amount of tokens stored by the contract.
778      */
779     function totalSupply() external view returns (uint256);
780 
781     /**
782      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
783      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
784      */
785     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
786 
787     /**
788      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
789      * Use along with {totalSupply} to enumerate all tokens.
790      */
791     function tokenByIndex(uint256 index) external view returns (uint256);
792 }
793 
794 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
795 
796 
797 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
798 
799 pragma solidity ^0.8.0;
800 
801 
802 /**
803  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
804  * @dev See https://eips.ethereum.org/EIPS/eip-721
805  */
806 interface IERC721Metadata is IERC721 {
807     /**
808      * @dev Returns the token collection name.
809      */
810     function name() external view returns (string memory);
811 
812     /**
813      * @dev Returns the token collection symbol.
814      */
815     function symbol() external view returns (string memory);
816 
817     /**
818      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
819      */
820     function tokenURI(uint256 tokenId) external view returns (string memory);
821 }
822 
823 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
824 
825 
826 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 
831 
832 
833 
834 
835 
836 
837 /**
838  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
839  * the Metadata extension, but not including the Enumerable extension, which is available separately as
840  * {ERC721Enumerable}.
841  */
842 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
843     using Address for address;
844     using Strings for uint256;
845 
846     // Token name
847     string private _name;
848 
849     // Token symbol
850     string private _symbol;
851 
852     // Mapping from token ID to owner address
853     mapping(uint256 => address) private _owners;
854 
855     // Mapping owner address to token count
856     mapping(address => uint256) private _balances;
857 
858     // Mapping from token ID to approved address
859     mapping(uint256 => address) private _tokenApprovals;
860 
861     // Mapping from owner to operator approvals
862     mapping(address => mapping(address => bool)) private _operatorApprovals;
863 
864     /**
865      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
866      */
867     constructor(string memory name_, string memory symbol_) {
868         _name = name_;
869         _symbol = symbol_;
870     }
871 
872     /**
873      * @dev See {IERC165-supportsInterface}.
874      */
875     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
876         return
877             interfaceId == type(IERC721).interfaceId ||
878             interfaceId == type(IERC721Metadata).interfaceId ||
879             super.supportsInterface(interfaceId);
880     }
881 
882     /**
883      * @dev See {IERC721-balanceOf}.
884      */
885     function balanceOf(address owner) public view virtual override returns (uint256) {
886         require(owner != address(0), "ERC721: balance query for the zero address");
887         return _balances[owner];
888     }
889 
890     /**
891      * @dev See {IERC721-ownerOf}.
892      */
893     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
894         address owner = _owners[tokenId];
895         require(owner != address(0), "ERC721: owner query for nonexistent token");
896         return owner;
897     }
898 
899     /**
900      * @dev See {IERC721Metadata-name}.
901      */
902     function name() public view virtual override returns (string memory) {
903         return _name;
904     }
905 
906     /**
907      * @dev See {IERC721Metadata-symbol}.
908      */
909     function symbol() public view virtual override returns (string memory) {
910         return _symbol;
911     }
912 
913     /**
914      * @dev See {IERC721Metadata-tokenURI}.
915      */
916     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
917         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
918 
919         string memory baseURI = _baseURI();
920         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
921     }
922 
923     /**
924      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
925      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
926      * by default, can be overriden in child contracts.
927      */
928     function _baseURI() internal view virtual returns (string memory) {
929         return "";
930     }
931 
932     /**
933      * @dev See {IERC721-approve}.
934      */
935     function approve(address to, uint256 tokenId) public virtual override {
936         address owner = ERC721.ownerOf(tokenId);
937         require(to != owner, "ERC721: approval to current owner");
938 
939         require(
940             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
941             "ERC721: approve caller is not owner nor approved for all"
942         );
943 
944         _approve(to, tokenId);
945     }
946 
947     /**
948      * @dev See {IERC721-getApproved}.
949      */
950     function getApproved(uint256 tokenId) public view virtual override returns (address) {
951         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
952 
953         return _tokenApprovals[tokenId];
954     }
955 
956     /**
957      * @dev See {IERC721-setApprovalForAll}.
958      */
959     function setApprovalForAll(address operator, bool approved) public virtual override {
960         _setApprovalForAll(_msgSender(), operator, approved);
961     }
962 
963     /**
964      * @dev See {IERC721-isApprovedForAll}.
965      */
966     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
967         return _operatorApprovals[owner][operator];
968     }
969 
970     /**
971      * @dev See {IERC721-transferFrom}.
972      */
973     function transferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) public virtual override {
978         //solhint-disable-next-line max-line-length
979         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
980 
981         _transfer(from, to, tokenId);
982     }
983 
984     /**
985      * @dev See {IERC721-safeTransferFrom}.
986      */
987     function safeTransferFrom(
988         address from,
989         address to,
990         uint256 tokenId
991     ) public virtual override {
992         safeTransferFrom(from, to, tokenId, "");
993     }
994 
995     /**
996      * @dev See {IERC721-safeTransferFrom}.
997      */
998     function safeTransferFrom(
999         address from,
1000         address to,
1001         uint256 tokenId,
1002         bytes memory _data
1003     ) public virtual override {
1004         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1005         _safeTransfer(from, to, tokenId, _data);
1006     }
1007 
1008     /**
1009      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1010      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1011      *
1012      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1013      *
1014      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1015      * implement alternative mechanisms to perform token transfer, such as signature-based.
1016      *
1017      * Requirements:
1018      *
1019      * - `from` cannot be the zero address.
1020      * - `to` cannot be the zero address.
1021      * - `tokenId` token must exist and be owned by `from`.
1022      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1023      *
1024      * Emits a {Transfer} event.
1025      */
1026     function _safeTransfer(
1027         address from,
1028         address to,
1029         uint256 tokenId,
1030         bytes memory _data
1031     ) internal virtual {
1032         _transfer(from, to, tokenId);
1033         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1034     }
1035 
1036     /**
1037      * @dev Returns whether `tokenId` exists.
1038      *
1039      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1040      *
1041      * Tokens start existing when they are minted (`_mint`),
1042      * and stop existing when they are burned (`_burn`).
1043      */
1044     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1045         return _owners[tokenId] != address(0);
1046     }
1047 
1048     /**
1049      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      */
1055     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1056         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1057         address owner = ERC721.ownerOf(tokenId);
1058         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1059     }
1060 
1061     /**
1062      * @dev Safely mints `tokenId` and transfers it to `to`.
1063      *
1064      * Requirements:
1065      *
1066      * - `tokenId` must not exist.
1067      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1068      *
1069      * Emits a {Transfer} event.
1070      */
1071     function _safeMint(address to, uint256 tokenId) internal virtual {
1072         _safeMint(to, tokenId, "");
1073     }
1074 
1075     /**
1076      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1077      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1078      */
1079     function _safeMint(
1080         address to,
1081         uint256 tokenId,
1082         bytes memory _data
1083     ) internal virtual {
1084         _mint(to, tokenId);
1085         require(
1086             _checkOnERC721Received(address(0), to, tokenId, _data),
1087             "ERC721: transfer to non ERC721Receiver implementer"
1088         );
1089     }
1090 
1091     /**
1092      * @dev Mints `tokenId` and transfers it to `to`.
1093      *
1094      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1095      *
1096      * Requirements:
1097      *
1098      * - `tokenId` must not exist.
1099      * - `to` cannot be the zero address.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function _mint(address to, uint256 tokenId) internal virtual {
1104         require(to != address(0), "ERC721: mint to the zero address");
1105         require(!_exists(tokenId), "ERC721: token already minted");
1106 
1107         _beforeTokenTransfer(address(0), to, tokenId);
1108 
1109         _balances[to] += 1;
1110         _owners[tokenId] = to;
1111 
1112         emit Transfer(address(0), to, tokenId);
1113     }
1114 
1115     /**
1116      * @dev Destroys `tokenId`.
1117      * The approval is cleared when the token is burned.
1118      *
1119      * Requirements:
1120      *
1121      * - `tokenId` must exist.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function _burn(uint256 tokenId) internal virtual {
1126         address owner = ERC721.ownerOf(tokenId);
1127 
1128         _beforeTokenTransfer(owner, address(0), tokenId);
1129 
1130         // Clear approvals
1131         _approve(address(0), tokenId);
1132 
1133         _balances[owner] -= 1;
1134         delete _owners[tokenId];
1135 
1136         emit Transfer(owner, address(0), tokenId);
1137     }
1138 
1139     /**
1140      * @dev Transfers `tokenId` from `from` to `to`.
1141      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - `tokenId` token must be owned by `from`.
1147      *
1148      * Emits a {Transfer} event.
1149      */
1150     function _transfer(
1151         address from,
1152         address to,
1153         uint256 tokenId
1154     ) internal virtual {
1155         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1156         require(to != address(0), "ERC721: transfer to the zero address");
1157 
1158         _beforeTokenTransfer(from, to, tokenId);
1159 
1160         // Clear approvals from the previous owner
1161         _approve(address(0), tokenId);
1162 
1163         _balances[from] -= 1;
1164         _balances[to] += 1;
1165         _owners[tokenId] = to;
1166 
1167         emit Transfer(from, to, tokenId);
1168     }
1169 
1170     /**
1171      * @dev Approve `to` to operate on `tokenId`
1172      *
1173      * Emits a {Approval} event.
1174      */
1175     function _approve(address to, uint256 tokenId) internal virtual {
1176         _tokenApprovals[tokenId] = to;
1177         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1178     }
1179 
1180     /**
1181      * @dev Approve `operator` to operate on all of `owner` tokens
1182      *
1183      * Emits a {ApprovalForAll} event.
1184      */
1185     function _setApprovalForAll(
1186         address owner,
1187         address operator,
1188         bool approved
1189     ) internal virtual {
1190         require(owner != operator, "ERC721: approve to caller");
1191         _operatorApprovals[owner][operator] = approved;
1192         emit ApprovalForAll(owner, operator, approved);
1193     }
1194 
1195     /**
1196      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1197      * The call is not executed if the target address is not a contract.
1198      *
1199      * @param from address representing the previous owner of the given token ID
1200      * @param to target address that will receive the tokens
1201      * @param tokenId uint256 ID of the token to be transferred
1202      * @param _data bytes optional data to send along with the call
1203      * @return bool whether the call correctly returned the expected magic value
1204      */
1205     function _checkOnERC721Received(
1206         address from,
1207         address to,
1208         uint256 tokenId,
1209         bytes memory _data
1210     ) private returns (bool) {
1211         if (to.isContract()) {
1212             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1213                 return retval == IERC721Receiver.onERC721Received.selector;
1214             } catch (bytes memory reason) {
1215                 if (reason.length == 0) {
1216                     revert("ERC721: transfer to non ERC721Receiver implementer");
1217                 } else {
1218                     assembly {
1219                         revert(add(32, reason), mload(reason))
1220                     }
1221                 }
1222             }
1223         } else {
1224             return true;
1225         }
1226     }
1227 
1228     /**
1229      * @dev Hook that is called before any token transfer. This includes minting
1230      * and burning.
1231      *
1232      * Calling conditions:
1233      *
1234      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1235      * transferred to `to`.
1236      * - When `from` is zero, `tokenId` will be minted for `to`.
1237      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1238      * - `from` and `to` are never both zero.
1239      *
1240      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1241      */
1242     function _beforeTokenTransfer(
1243         address from,
1244         address to,
1245         uint256 tokenId
1246     ) internal virtual {}
1247 }
1248 
1249 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1250 
1251 
1252 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1253 
1254 pragma solidity ^0.8.0;
1255 
1256 
1257 
1258 /**
1259  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1260  * enumerability of all the token ids in the contract as well as all token ids owned by each
1261  * account.
1262  */
1263 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1264     // Mapping from owner to list of owned token IDs
1265     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1266 
1267     // Mapping from token ID to index of the owner tokens list
1268     mapping(uint256 => uint256) private _ownedTokensIndex;
1269 
1270     // Array with all token ids, used for enumeration
1271     uint256[] private _allTokens;
1272 
1273     // Mapping from token id to position in the allTokens array
1274     mapping(uint256 => uint256) private _allTokensIndex;
1275 
1276     /**
1277      * @dev See {IERC165-supportsInterface}.
1278      */
1279     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1280         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1281     }
1282 
1283     /**
1284      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1285      */
1286     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1287         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1288         return _ownedTokens[owner][index];
1289     }
1290 
1291     /**
1292      * @dev See {IERC721Enumerable-totalSupply}.
1293      */
1294     function totalSupply() public view virtual override returns (uint256) {
1295         return _allTokens.length;
1296     }
1297 
1298     /**
1299      * @dev See {IERC721Enumerable-tokenByIndex}.
1300      */
1301     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1302         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1303         return _allTokens[index];
1304     }
1305 
1306     /**
1307      * @dev Hook that is called before any token transfer. This includes minting
1308      * and burning.
1309      *
1310      * Calling conditions:
1311      *
1312      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1313      * transferred to `to`.
1314      * - When `from` is zero, `tokenId` will be minted for `to`.
1315      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1316      * - `from` cannot be the zero address.
1317      * - `to` cannot be the zero address.
1318      *
1319      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1320      */
1321     function _beforeTokenTransfer(
1322         address from,
1323         address to,
1324         uint256 tokenId
1325     ) internal virtual override {
1326         super._beforeTokenTransfer(from, to, tokenId);
1327 
1328         if (from == address(0)) {
1329             _addTokenToAllTokensEnumeration(tokenId);
1330         } else if (from != to) {
1331             _removeTokenFromOwnerEnumeration(from, tokenId);
1332         }
1333         if (to == address(0)) {
1334             _removeTokenFromAllTokensEnumeration(tokenId);
1335         } else if (to != from) {
1336             _addTokenToOwnerEnumeration(to, tokenId);
1337         }
1338     }
1339 
1340     /**
1341      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1342      * @param to address representing the new owner of the given token ID
1343      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1344      */
1345     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1346         uint256 length = ERC721.balanceOf(to);
1347         _ownedTokens[to][length] = tokenId;
1348         _ownedTokensIndex[tokenId] = length;
1349     }
1350 
1351     /**
1352      * @dev Private function to add a token to this extension's token tracking data structures.
1353      * @param tokenId uint256 ID of the token to be added to the tokens list
1354      */
1355     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1356         _allTokensIndex[tokenId] = _allTokens.length;
1357         _allTokens.push(tokenId);
1358     }
1359 
1360     /**
1361      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1362      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1363      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1364      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1365      * @param from address representing the previous owner of the given token ID
1366      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1367      */
1368     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1369         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1370         // then delete the last slot (swap and pop).
1371 
1372         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1373         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1374 
1375         // When the token to delete is the last token, the swap operation is unnecessary
1376         if (tokenIndex != lastTokenIndex) {
1377             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1378 
1379             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1380             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1381         }
1382 
1383         // This also deletes the contents at the last position of the array
1384         delete _ownedTokensIndex[tokenId];
1385         delete _ownedTokens[from][lastTokenIndex];
1386     }
1387 
1388     /**
1389      * @dev Private function to remove a token from this extension's token tracking data structures.
1390      * This has O(1) time complexity, but alters the order of the _allTokens array.
1391      * @param tokenId uint256 ID of the token to be removed from the tokens list
1392      */
1393     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1394         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1395         // then delete the last slot (swap and pop).
1396 
1397         uint256 lastTokenIndex = _allTokens.length - 1;
1398         uint256 tokenIndex = _allTokensIndex[tokenId];
1399 
1400         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1401         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1402         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1403         uint256 lastTokenId = _allTokens[lastTokenIndex];
1404 
1405         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1406         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1407 
1408         // This also deletes the contents at the last position of the array
1409         delete _allTokensIndex[tokenId];
1410         _allTokens.pop();
1411     }
1412 }
1413 
1414 // File: contracts/Mempo/Mempo.sol
1415 
1416 
1417 
1418 pragma solidity >=0.7.0 <0.9.0;
1419 
1420 
1421 
1422 
1423 
1424 contract Mempo is ERC721Enumerable, Ownable, ERC2981ContractWideRoyalties {
1425     using Strings for uint256;
1426     string public baseURI;
1427     string public baseExtension = ".json";
1428     uint256 public cost = 0.15 ether;
1429     uint256 public maxLimit = 10000;
1430     uint256 public maxSupply = 5000;
1431     uint256 public maxMintAmountPerTx = 2;
1432     bool public paused = true;
1433     bool public presaleActive = false;
1434     bytes32 private seedPhrase = 0x6abe10cdef935bbc20e799c9ecc3ed3f94f70081687588d1fc0e81319936e6d8;
1435     bytes32 public merkleRoot = 0x6a3375101d42b3eb58b92e7bbc169175139f15e27519e2db3921c814d42f72f8;
1436     mapping(address => uint256) public whiteListMintedNFTs;
1437     uint256 public contractOwnerNFTs = 225;
1438     uint256 public mintedByOwner = 0;
1439     uint256 public publicNFTStartingTokenId = 225;
1440     address payable private contractOwner;
1441 
1442     constructor(
1443         string memory _name,
1444         string memory _symbol,
1445         string memory _initBaseURI
1446     ) ERC721(_name, _symbol) {
1447         setBaseURI(_initBaseURI);
1448         contractOwner = payable(msg.sender);
1449     }
1450 
1451     function _baseURI() internal view virtual override returns (string memory) {
1452         return baseURI;
1453     }
1454 
1455     //Royalties Function
1456     function supportsInterface(bytes4 interfaceId)
1457         public
1458         view
1459         virtual
1460         override(ERC721Enumerable, ERC2981Base)
1461         returns (bool)
1462     {
1463         return super.supportsInterface(interfaceId);
1464     }
1465 
1466     /// @notice Allows to set the royalties on the contract
1467     /// @dev This function in a real contract should be protected with a onlOwner (or equivalent) modifier
1468     /// @param recipient the royalties recipient
1469     /// @param value royalties value (between 0 and 10000)
1470     function setRoyalties(address recipient, uint256 value) public {
1471         _setRoyalties(recipient, value);
1472     }
1473 
1474     // public
1475     function mint(string memory phrase, uint256 _mintAmount) public payable {
1476         require(!paused, "the contract is paused");
1477         require(!presaleActive, "Can not use this function during presale");
1478         require(msg.value >= cost * _mintAmount, "insufficient funds");
1479         require(
1480             msg.sender != owner(),
1481             "This function can only be called by an outsider"
1482         );
1483         bytes32 hashedWord = sha256(abi.encodePacked(phrase));
1484         require(hashedWord == seedPhrase, "Password doesn't match");
1485         require(
1486             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
1487             "max mint amount per session exceeded"
1488         );
1489 
1490         uint256 supply = totalSupply();
1491         require(
1492             supply + _mintAmount <= maxSupply,
1493             "max NFT limit exceeded, Try minting less NFTs"
1494         );
1495 
1496         for (uint256 i = 0; i < _mintAmount; i++) {
1497             _safeMint(msg.sender, publicNFTStartingTokenId+i);   
1498         }
1499         publicNFTStartingTokenId = publicNFTStartingTokenId + _mintAmount;
1500         contractOwner.transfer(address(this).balance);
1501     }
1502 
1503     function whiteListMint(bytes32[] calldata _merkleProof, uint256 _mintAmount)
1504         public
1505         payable
1506     {
1507         require(presaleActive, "presale is not active");
1508         require(msg.value >= cost * _mintAmount, "insufficient funds");
1509         require(
1510             msg.sender != owner(),
1511             "This function can only be called by an outsider"
1512         );
1513         require(_mintAmount <= 2, "Max 2 nfts could be minted");
1514         require(
1515             whiteListMintedNFTs[msg.sender] < 2,
1516             "Address has already claimed."
1517         );
1518 
1519         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1520         require(
1521             MerkleProof.verify(_merkleProof, merkleRoot, leaf),
1522             "Invalid proof."
1523         );
1524         uint256 supply = totalSupply();
1525         require(
1526             supply + _mintAmount <= maxSupply,
1527             "max NFT limit exceeded, Try minting less NFTs"
1528         );
1529 
1530         for (uint256 i = 0; i < _mintAmount; i++) {
1531             _safeMint(msg.sender, publicNFTStartingTokenId+i);
1532             
1533         }
1534         publicNFTStartingTokenId = publicNFTStartingTokenId + _mintAmount;
1535         whiteListMintedNFTs[msg.sender] =
1536             whiteListMintedNFTs[msg.sender] +
1537             _mintAmount;
1538         contractOwner.transfer(address(this).balance);
1539     }
1540 
1541     function mintReservedNFTs(uint256 _mintAmount) public onlyOwner {
1542         require(
1543             mintedByOwner + _mintAmount <= contractOwnerNFTs,
1544             "Owner's NFT quota Ended"
1545         );
1546         require(_mintAmount > 0, "need to mint at least 1 NFT");
1547         require(
1548             _mintAmount <= maxMintAmountPerTx,
1549             "max mint amount per session exceeded"
1550         );
1551 
1552         for (uint256 i = 0; i < _mintAmount; i++) {
1553             _safeMint(msg.sender, mintedByOwner+i);
1554         }
1555         mintedByOwner = mintedByOwner + _mintAmount;
1556     }
1557 
1558     function walletOfOwner(address _owner)
1559         public
1560         view
1561         returns (uint256[] memory)
1562     {
1563         uint256 ownerTokenCount = balanceOf(_owner);
1564         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1565         for (uint256 i; i < ownerTokenCount; i++) {
1566             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1567         }
1568         return tokenIds;
1569     }
1570 
1571     function tokenURI(uint256 tokenId)
1572         public
1573         view
1574         virtual
1575         override
1576         returns (string memory)
1577     {
1578         require(
1579             _exists(tokenId),
1580             "ERC721Metadata: URI query for nonexistent token"
1581         );
1582 
1583         string memory currentBaseURI = _baseURI();
1584         return
1585             bytes(currentBaseURI).length > 0
1586                 ? string(
1587                     abi.encodePacked(
1588                         currentBaseURI,
1589                         tokenId.toString(),
1590                         baseExtension
1591                     )
1592                 )
1593                 : "";
1594     }
1595 
1596     //only owner
1597     function setCost(uint256 _newCost) public onlyOwner {
1598         cost = _newCost;
1599     }
1600 
1601     function setmaxMintAmountPerTx(uint256 _newmaxMintAmountPerTx)
1602         public
1603         onlyOwner
1604     {
1605         require(
1606             _newmaxMintAmountPerTx <= 20,
1607             "You can set msxMintAmount max to 20"
1608         );
1609         maxMintAmountPerTx = _newmaxMintAmountPerTx;
1610     }
1611 
1612     function setMaxsupply(uint256 _newMaxSupply) public onlyOwner {
1613         require(
1614             _newMaxSupply <= maxLimit,
1615             "maxSupply can not be greater than the max Limit"
1616         );
1617         require(
1618             _newMaxSupply > maxSupply,
1619             "maxSupply can not be less than previous maxSupply"
1620         );
1621         maxSupply = _newMaxSupply;
1622     }
1623 
1624     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1625         baseURI = _newBaseURI;
1626     }
1627 
1628     function pause(bool _state) public onlyOwner {
1629         paused = _state;
1630     }
1631 
1632     function setPresaleStatus(bool _presaleActive) public onlyOwner {
1633         presaleActive = _presaleActive;
1634     }
1635 
1636     function increasePresaleLimit(
1637         address _walletAddress,
1638         uint256 _increaseByAmount
1639     ) public onlyOwner {
1640         require(_increaseByAmount <= 2, "You can only increase the limit by 2");
1641         uint256 increaseBy = whiteListMintedNFTs[_walletAddress] -
1642             _increaseByAmount;
1643         whiteListMintedNFTs[_walletAddress] = increaseBy;
1644     }
1645 
1646     function setSecret(bytes32 _secret) public onlyOwner {
1647         seedPhrase = _secret;
1648     }
1649 
1650     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1651         merkleRoot = _merkleRoot;
1652     }
1653 
1654     function withdrawBalance() public onlyOwner {
1655         contractOwner.transfer(address(this).balance);
1656     }
1657 }