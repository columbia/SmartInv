1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
3 
4 pragma solidity ^0.8.0;
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
27 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
28 
29 
30 
31 /**
32  * @dev String operations.
33  */
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
39      */
40     function toString(uint256 value) internal pure returns (string memory) {
41         // Inspired by OraclizeAPI's implementation - MIT licence
42         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
64      */
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
80      */
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 }
93 
94 
95 
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
99 
100 
101 
102 
103 
104 /**
105  * @dev Required interface of an ERC721 compliant contract.
106  */
107 interface IERC721 is IERC165 {
108     /**
109      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
112 
113     /**
114      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
115      */
116     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
117 
118     /**
119      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
120      */
121     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
122 
123     /**
124      * @dev Returns the number of tokens in ``owner``'s account.
125      */
126     function balanceOf(address owner) external view returns (uint256 balance);
127 
128     /**
129      * @dev Returns the owner of the `tokenId` token.
130      *
131      * Requirements:
132      *
133      * - `tokenId` must exist.
134      */
135     function ownerOf(uint256 tokenId) external view returns (address owner);
136 
137     /**
138      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
139      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
140      *
141      * Requirements:
142      *
143      * - `from` cannot be the zero address.
144      * - `to` cannot be the zero address.
145      * - `tokenId` token must exist and be owned by `from`.
146      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
147      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
148      *
149      * Emits a {Transfer} event.
150      */
151     function safeTransferFrom(
152         address from,
153         address to,
154         uint256 tokenId
155     ) external;
156 
157     /**
158      * @dev Transfers `tokenId` token from `from` to `to`.
159      *
160      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
161      *
162      * Requirements:
163      *
164      * - `from` cannot be the zero address.
165      * - `to` cannot be the zero address.
166      * - `tokenId` token must be owned by `from`.
167      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(
172         address from,
173         address to,
174         uint256 tokenId
175     ) external;
176 
177     /**
178      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
179      * The approval is cleared when the token is transferred.
180      *
181      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
182      *
183      * Requirements:
184      *
185      * - The caller must own the token or be an approved operator.
186      * - `tokenId` must exist.
187      *
188      * Emits an {Approval} event.
189      */
190     function approve(address to, uint256 tokenId) external;
191 
192     /**
193      * @dev Returns the account approved for `tokenId` token.
194      *
195      * Requirements:
196      *
197      * - `tokenId` must exist.
198      */
199     function getApproved(uint256 tokenId) external view returns (address operator);
200 
201     /**
202      * @dev Approve or remove `operator` as an operator for the caller.
203      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
204      *
205      * Requirements:
206      *
207      * - The `operator` cannot be the caller.
208      *
209      * Emits an {ApprovalForAll} event.
210      */
211     function setApprovalForAll(address operator, bool _approved) external;
212 
213     /**
214      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
215      *
216      * See {setApprovalForAll}
217      */
218     function isApprovedForAll(address owner, address operator) external view returns (bool);
219 
220     /**
221      * @dev Safely transfers `tokenId` token from `from` to `to`.
222      *
223      * Requirements:
224      *
225      * - `from` cannot be the zero address.
226      * - `to` cannot be the zero address.
227      * - `tokenId` token must exist and be owned by `from`.
228      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
229      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
230      *
231      * Emits a {Transfer} event.
232      */
233     function safeTransferFrom(
234         address from,
235         address to,
236         uint256 tokenId,
237         bytes calldata data
238     ) external;
239 }
240 
241 
242 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
243 
244 
245 
246 /**
247  * @title ERC721 token receiver interface
248  * @dev Interface for any contract that wants to support safeTransfers
249  * from ERC721 asset contracts.
250  */
251 interface IERC721Receiver {
252     /**
253      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
254      * by `operator` from `from`, this function is called.
255      *
256      * It must return its Solidity selector to confirm the token transfer.
257      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
258      *
259      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
260      */
261     function onERC721Received(
262         address operator,
263         address from,
264         uint256 tokenId,
265         bytes calldata data
266     ) external returns (bytes4);
267 }
268 
269 
270 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
271 
272 
273 
274 
275 
276 /**
277  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
278  * @dev See https://eips.ethereum.org/EIPS/eip-721
279  */
280 interface IERC721Metadata is IERC721 {
281     /**
282      * @dev Returns the token collection name.
283      */
284     function name() external view returns (string memory);
285 
286     /**
287      * @dev Returns the token collection symbol.
288      */
289     function symbol() external view returns (string memory);
290 
291     /**
292      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
293      */
294     function tokenURI(uint256 tokenId) external view returns (string memory);
295 }
296 
297 
298 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
299 
300 
301 
302 /**
303  * @dev Collection of functions related to the address type
304  */
305 library Address {
306     /**
307      * @dev Returns true if `account` is a contract.
308      *
309      * [IMPORTANT]
310      * ====
311      * It is unsafe to assume that an address for which this function returns
312      * false is an externally-owned account (EOA) and not a contract.
313      *
314      * Among others, `isContract` will return false for the following
315      * types of addresses:
316      *
317      *  - an externally-owned account
318      *  - a contract in construction
319      *  - an address where a contract will be created
320      *  - an address where a contract lived, but was destroyed
321      * ====
322      *
323      * [IMPORTANT]
324      * ====
325      * You shouldn't rely on `isContract` to protect against flash loan attacks!
326      *
327      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
328      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
329      * constructor.
330      * ====
331      */
332     function isContract(address account) internal view returns (bool) {
333         // This method relies on extcodesize/address.code.length, which returns 0
334         // for contracts in construction, since the code is only stored at the end
335         // of the constructor execution.
336 
337         return account.code.length > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         (bool success, ) = recipient.call{value: amount}("");
360         require(success, "Address: unable to send value, recipient may have reverted");
361     }
362 
363     /**
364      * @dev Performs a Solidity function call using a low level `call`. A
365      * plain `call` is an unsafe replacement for a function call: use this
366      * function instead.
367      *
368      * If `target` reverts with a revert reason, it is bubbled up by this
369      * function (like regular Solidity function calls).
370      *
371      * Returns the raw returned data. To convert to the expected return value,
372      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
373      *
374      * Requirements:
375      *
376      * - `target` must be a contract.
377      * - calling `target` with `data` must not revert.
378      *
379      * _Available since v3.1._
380      */
381     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
420      * with `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(address(this).balance >= value, "Address: insufficient balance for call");
431         require(isContract(target), "Address: call to non-contract");
432 
433         (bool success, bytes memory returndata) = target.call{value: value}(data);
434         return verifyCallResult(success, returndata, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but performing a static call.
440      *
441      * _Available since v3.3._
442      */
443     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
444         return functionStaticCall(target, data, "Address: low-level static call failed");
445     }
446 
447     /**
448      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
449      * but performing a static call.
450      *
451      * _Available since v3.3._
452      */
453     function functionStaticCall(
454         address target,
455         bytes memory data,
456         string memory errorMessage
457     ) internal view returns (bytes memory) {
458         require(isContract(target), "Address: static call to non-contract");
459 
460         (bool success, bytes memory returndata) = target.staticcall(data);
461         return verifyCallResult(success, returndata, errorMessage);
462     }
463 
464     /**
465      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
466      * but performing a delegate call.
467      *
468      * _Available since v3.4._
469      */
470     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
471         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
472     }
473 
474     /**
475      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
476      * but performing a delegate call.
477      *
478      * _Available since v3.4._
479      */
480     function functionDelegateCall(
481         address target,
482         bytes memory data,
483         string memory errorMessage
484     ) internal returns (bytes memory) {
485         require(isContract(target), "Address: delegate call to non-contract");
486 
487         (bool success, bytes memory returndata) = target.delegatecall(data);
488         return verifyCallResult(success, returndata, errorMessage);
489     }
490 
491     /**
492      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
493      * revert reason using the provided one.
494      *
495      * _Available since v4.3._
496      */
497     function verifyCallResult(
498         bool success,
499         bytes memory returndata,
500         string memory errorMessage
501     ) internal pure returns (bytes memory) {
502         if (success) {
503             return returndata;
504         } else {
505             // Look for revert reason and bubble it up if present
506             if (returndata.length > 0) {
507                 // The easiest way to bubble the revert reason is using memory via assembly
508 
509                 assembly {
510                     let returndata_size := mload(returndata)
511                     revert(add(32, returndata), returndata_size)
512                 }
513             } else {
514                 revert(errorMessage);
515             }
516         }
517     }
518 }
519 
520 
521 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
522 
523 
524 
525 /**
526  * @dev Provides information about the current execution context, including the
527  * sender of the transaction and its data. While these are generally available
528  * via msg.sender and msg.data, they should not be accessed in such a direct
529  * manner, since when dealing with meta-transactions the account sending and
530  * paying for execution may not be the actual sender (as far as an application
531  * is concerned).
532  *
533  * This contract is only required for intermediate, library-like contracts.
534  */
535 abstract contract Context {
536     function _msgSender() internal view virtual returns (address) {
537         return msg.sender;
538     }
539 
540     function _msgData() internal view virtual returns (bytes calldata) {
541         return msg.data;
542     }
543 }
544 
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
548 
549 
550 
551 
552 
553 /**
554  * @dev Implementation of the {IERC165} interface.
555  *
556  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
557  * for the additional interface id that will be supported. For example:
558  *
559  * ```solidity
560  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
561  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
562  * }
563  * ```
564  *
565  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
566  */
567 abstract contract ERC165 is IERC165 {
568     /**
569      * @dev See {IERC165-supportsInterface}.
570      */
571     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
572         return interfaceId == type(IERC165).interfaceId;
573     }
574 }
575 
576 
577 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
578 
579 
580 
581 
582 
583 /**
584  * @dev Contract module which provides a basic access control mechanism, where
585  * there is an account (an owner) that can be granted exclusive access to
586  * specific functions.
587  *
588  * By default, the owner account will be the one that deploys the contract. This
589  * can later be changed with {transferOwnership}.
590  *
591  * This module is used through inheritance. It will make available the modifier
592  * `onlyOwner`, which can be applied to your functions to restrict their use to
593  * the owner.
594  */
595 abstract contract Ownable is Context {
596     address private _owner;
597 
598     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
599 
600     /**
601      * @dev Initializes the contract setting the deployer as the initial owner.
602      */
603     constructor() {
604         _transferOwnership(_msgSender());
605     }
606 
607     /**
608      * @dev Returns the address of the current owner.
609      */
610     function owner() public view virtual returns (address) {
611         return _owner;
612     }
613 
614     /**
615      * @dev Throws if called by any account other than the owner.
616      */
617     modifier onlyOwner() {
618         require(owner() == _msgSender(), "Ownable: caller is not the owner");
619         _;
620     }
621 
622     /**
623      * @dev Leaves the contract without owner. It will not be possible to call
624      * `onlyOwner` functions anymore. Can only be called by the current owner.
625      *
626      * NOTE: Renouncing ownership will leave the contract without an owner,
627      * thereby removing any functionality that is only available to the owner.
628      */
629     function renounceOwnership() public virtual onlyOwner {
630         _transferOwnership(address(0));
631     }
632 
633     /**
634      * @dev Transfers ownership of the contract to a new account (`newOwner`).
635      * Can only be called by the current owner.
636      */
637     function transferOwnership(address newOwner) public virtual onlyOwner {
638         require(newOwner != address(0), "Ownable: new owner is the zero address");
639         _transferOwnership(newOwner);
640     }
641 
642     /**
643      * @dev Transfers ownership of the contract to a new account (`newOwner`).
644      * Internal function without access restriction.
645      */
646     function _transferOwnership(address newOwner) internal virtual {
647         address oldOwner = _owner;
648         _owner = newOwner;
649         emit OwnershipTransferred(oldOwner, newOwner);
650     }
651 }
652 
653 
654 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
655 
656 
657 
658 /**
659  * @dev These functions deal with verification of Merkle Trees proofs.
660  *
661  * The proofs can be generated using the JavaScript library
662  * https://github.com/miguelmota/merkletreejs[merkletreejs].
663  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
664  *
665  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
666  */
667 library MerkleProof {
668     /**
669      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
670      * defined by `root`. For this, a `proof` must be provided, containing
671      * sibling hashes on the branch from the leaf to the root of the tree. Each
672      * pair of leaves and each pair of pre-images are assumed to be sorted.
673      */
674     function verify(
675         bytes32[] memory proof,
676         bytes32 root,
677         bytes32 leaf
678     ) internal pure returns (bool) {
679         return processProof(proof, leaf) == root;
680     }
681 
682     /**
683      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
684      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
685      * hash matches the root of the tree. When processing the proof, the pairs
686      * of leafs & pre-images are assumed to be sorted.
687      *
688      * _Available since v4.4._
689      */
690     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
691         bytes32 computedHash = leaf;
692         for (uint256 i = 0; i < proof.length; i++) {
693             bytes32 proofElement = proof[i];
694             if (computedHash <= proofElement) {
695                 // Hash(current computed hash + current element of the proof)
696                 computedHash = _efficientHash(computedHash, proofElement);
697             } else {
698                 // Hash(current element of the proof + current computed hash)
699                 computedHash = _efficientHash(proofElement, computedHash);
700             }
701         }
702         return computedHash;
703     }
704 
705     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
706         assembly {
707             mstore(0x00, a)
708             mstore(0x20, b)
709             value := keccak256(0x00, 0x40)
710         }
711     }
712 }
713 
714 
715 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
716 
717 
718 
719 /**
720  * @dev Contract module that helps prevent reentrant calls to a function.
721  *
722  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
723  * available, which can be applied to functions to make sure there are no nested
724  * (reentrant) calls to them.
725  *
726  * Note that because there is a single `nonReentrant` guard, functions marked as
727  * `nonReentrant` may not call one another. This can be worked around by making
728  * those functions `private`, and then adding `external` `nonReentrant` entry
729  * points to them.
730  *
731  * TIP: If you would like to learn more about reentrancy and alternative ways
732  * to protect against it, check out our blog post
733  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
734  */
735 abstract contract ReentrancyGuard {
736     // Booleans are more expensive than uint256 or any type that takes up a full
737     // word because each write operation emits an extra SLOAD to first read the
738     // slot's contents, replace the bits taken up by the boolean, and then write
739     // back. This is the compiler's defense against contract upgrades and
740     // pointer aliasing, and it cannot be disabled.
741 
742     // The values being non-zero value makes deployment a bit more expensive,
743     // but in exchange the refund on every call to nonReentrant will be lower in
744     // amount. Since refunds are capped to a percentage of the total
745     // transaction's gas, it is best to keep them low in cases like this one, to
746     // increase the likelihood of the full refund coming into effect.
747     uint256 private constant _NOT_ENTERED = 1;
748     uint256 private constant _ENTERED = 2;
749 
750     uint256 private _status;
751 
752     constructor() {
753         _status = _NOT_ENTERED;
754     }
755 
756     /**
757      * @dev Prevents a contract from calling itself, directly or indirectly.
758      * Calling a `nonReentrant` function from another `nonReentrant`
759      * function is not supported. It is possible to prevent this from happening
760      * by making the `nonReentrant` function external, and making it call a
761      * `private` function that does the actual work.
762      */
763     modifier nonReentrant() {
764         // On the first call to nonReentrant, _notEntered will be true
765         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
766 
767         // Any calls to nonReentrant after this point will fail
768         _status = _ENTERED;
769 
770         _;
771 
772         // By storing the original value once again, a refund is triggered (see
773         // https://eips.ethereum.org/EIPS/eip-2200)
774         _status = _NOT_ENTERED;
775     }
776 }
777 
778 
779 error ApprovalCallerNotOwnerNorApproved();
780 error ApprovalQueryForNonexistentToken();
781 error ApproveToCaller();
782 error ApprovalToCurrentOwner();
783 error BalanceQueryForZeroAddress();
784 error MintToZeroAddress();
785 error MintZeroQuantity();
786 error OwnerQueryForNonexistentToken();
787 error TransferCallerNotOwnerNorApproved();
788 error TransferFromIncorrectOwner();
789 error TransferToNonERC721ReceiverImplementer();
790 error TransferToZeroAddress();
791 error URIQueryForNonexistentToken();
792 
793 /**
794  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
795  * the Metadata extension. Built to optimize for lower gas during batch mints.
796  *
797  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
798  *
799  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
800  *
801  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
802  */
803 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
804     using Address for address;
805     using Strings for uint256;
806 
807     // Compiler will pack this into a single 256bit word.
808     struct TokenOwnership {
809         // The address of the owner.
810         address addr;
811         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
812         uint64 startTimestamp;
813         // Whether the token has been burned.
814         bool burned;
815     }
816 
817     // Compiler will pack this into a single 256bit word.
818     struct AddressData {
819         // Realistically, 2**64-1 is more than enough.
820         uint64 balance;
821         // Keeps track of mint count with minimal overhead for tokenomics.
822         uint64 numberMinted;
823         // Keeps track of burn count with minimal overhead for tokenomics.
824         uint64 numberBurned;
825         // For miscellaneous variable(s) pertaining to the address
826         // (e.g. number of whitelist mint slots used).
827         // If there are multiple variables, please pack them into a uint64.
828         uint64 aux;
829     }
830 
831     // The tokenId of the next token to be minted.
832     uint256 internal _currentIndex;
833 
834     // The number of tokens burned.
835     uint256 internal _burnCounter;
836 
837     // Token name
838     string private _name;
839 
840     // Token symbol
841     string private _symbol;
842 
843     // Mapping from token ID to ownership details
844     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
845     mapping(uint256 => TokenOwnership) internal _ownerships;
846 
847     // Mapping owner address to address data
848     mapping(address => AddressData) private _addressData;
849 
850     // Mapping from token ID to approved address
851     mapping(uint256 => address) private _tokenApprovals;
852 
853     // Mapping from owner to operator approvals
854     mapping(address => mapping(address => bool)) private _operatorApprovals;
855 
856     constructor(string memory name_, string memory symbol_) {
857         _name = name_;
858         _symbol = symbol_;
859         _currentIndex = _startTokenId();
860     }
861 
862     /**
863      * To change the starting tokenId, please override this function.
864      */
865     function _startTokenId() internal view virtual returns (uint256) {
866         return 0;
867     }
868 
869     /**
870      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
871      */
872     function totalSupply() public view returns (uint256) {
873         // Counter underflow is impossible as _burnCounter cannot be incremented
874         // more than _currentIndex - _startTokenId() times
875         unchecked {
876             return _currentIndex - _burnCounter - _startTokenId();
877         }
878     }
879 
880     /**
881      * Returns the total amount of tokens minted in the contract.
882      */
883     function _totalMinted() internal view returns (uint256) {
884         // Counter underflow is impossible as _currentIndex does not decrement,
885         // and it is initialized to _startTokenId()
886         unchecked {
887             return _currentIndex - _startTokenId();
888         }
889     }
890 
891     /**
892      * @dev See {IERC165-supportsInterface}.
893      */
894     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
895         return
896             interfaceId == type(IERC721).interfaceId ||
897             interfaceId == type(IERC721Metadata).interfaceId ||
898             super.supportsInterface(interfaceId);
899     }
900 
901     /**
902      * @dev See {IERC721-balanceOf}.
903      */
904     function balanceOf(address owner) public view override returns (uint256) {
905         if (owner == address(0)) revert BalanceQueryForZeroAddress();
906         return uint256(_addressData[owner].balance);
907     }
908 
909     /**
910      * Returns the number of tokens minted by `owner`.
911      */
912     function _numberMinted(address owner) internal view returns (uint256) {
913         return uint256(_addressData[owner].numberMinted);
914     }
915 
916     /**
917      * Returns the number of tokens burned by or on behalf of `owner`.
918      */
919     function _numberBurned(address owner) internal view returns (uint256) {
920         return uint256(_addressData[owner].numberBurned);
921     }
922 
923     /**
924      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
925      */
926     function _getAux(address owner) internal view returns (uint64) {
927         return _addressData[owner].aux;
928     }
929 
930     /**
931      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
932      * If there are multiple variables, please pack them into a uint64.
933      */
934     function _setAux(address owner, uint64 aux) internal {
935         _addressData[owner].aux = aux;
936     }
937 
938     /**
939      * Gas spent here starts off proportional to the maximum mint batch size.
940      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
941      */
942     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
943         uint256 curr = tokenId;
944 
945         unchecked {
946             if (_startTokenId() <= curr && curr < _currentIndex) {
947                 TokenOwnership memory ownership = _ownerships[curr];
948                 if (!ownership.burned) {
949                     if (ownership.addr != address(0)) {
950                         return ownership;
951                     }
952                     // Invariant:
953                     // There will always be an ownership that has an address and is not burned
954                     // before an ownership that does not have an address and is not burned.
955                     // Hence, curr will not underflow.
956                     while (true) {
957                         curr--;
958                         ownership = _ownerships[curr];
959                         if (ownership.addr != address(0)) {
960                             return ownership;
961                         }
962                     }
963                 }
964             }
965         }
966         revert OwnerQueryForNonexistentToken();
967     }
968 
969     /**
970      * @dev See {IERC721-ownerOf}.
971      */
972     function ownerOf(uint256 tokenId) public view override returns (address) {
973         return _ownershipOf(tokenId).addr;
974     }
975 
976     /**
977      * @dev See {IERC721Metadata-name}.
978      */
979     function name() public view virtual override returns (string memory) {
980         return _name;
981     }
982 
983     /**
984      * @dev See {IERC721Metadata-symbol}.
985      */
986     function symbol() public view virtual override returns (string memory) {
987         return _symbol;
988     }
989 
990     /**
991      * @dev See {IERC721Metadata-tokenURI}.
992      */
993     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
994         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
995 
996         string memory baseURI = _baseURI();
997         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
998     }
999 
1000     /**
1001      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1002      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1003      * by default, can be overriden in child contracts.
1004      */
1005     function _baseURI() internal view virtual returns (string memory) {
1006         return '';
1007     }
1008 
1009     /**
1010      * @dev See {IERC721-approve}.
1011      */
1012     function approve(address to, uint256 tokenId) public override {
1013         address owner = ERC721A.ownerOf(tokenId);
1014         if (to == owner) revert ApprovalToCurrentOwner();
1015 
1016         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1017             revert ApprovalCallerNotOwnerNorApproved();
1018         }
1019 
1020         _approve(to, tokenId, owner);
1021     }
1022 
1023     /**
1024      * @dev See {IERC721-getApproved}.
1025      */
1026     function getApproved(uint256 tokenId) public view override returns (address) {
1027         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1028 
1029         return _tokenApprovals[tokenId];
1030     }
1031 
1032     /**
1033      * @dev See {IERC721-setApprovalForAll}.
1034      */
1035     function setApprovalForAll(address operator, bool approved) public virtual override {
1036         if (operator == _msgSender()) revert ApproveToCaller();
1037 
1038         _operatorApprovals[_msgSender()][operator] = approved;
1039         emit ApprovalForAll(_msgSender(), operator, approved);
1040     }
1041 
1042     /**
1043      * @dev See {IERC721-isApprovedForAll}.
1044      */
1045     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1046         return _operatorApprovals[owner][operator];
1047     }
1048 
1049     /**
1050      * @dev See {IERC721-transferFrom}.
1051      */
1052     function transferFrom(
1053         address from,
1054         address to,
1055         uint256 tokenId
1056     ) public virtual override {
1057         _transfer(from, to, tokenId);
1058     }
1059 
1060     /**
1061      * @dev See {IERC721-safeTransferFrom}.
1062      */
1063     function safeTransferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) public virtual override {
1068         safeTransferFrom(from, to, tokenId, '');
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-safeTransferFrom}.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId,
1078         bytes memory _data
1079     ) public virtual override {
1080         _transfer(from, to, tokenId);
1081         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1082             revert TransferToNonERC721ReceiverImplementer();
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns whether `tokenId` exists.
1088      *
1089      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1090      *
1091      * Tokens start existing when they are minted (`_mint`),
1092      */
1093     function _exists(uint256 tokenId) internal view returns (bool) {
1094         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1095     }
1096 
1097     function _safeMint(address to, uint256 quantity) internal {
1098         _safeMint(to, quantity, '');
1099     }
1100 
1101     /**
1102      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1103      *
1104      * Requirements:
1105      *
1106      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1107      * - `quantity` must be greater than 0.
1108      *
1109      * Emits a {Transfer} event.
1110      */
1111     function _safeMint(
1112         address to,
1113         uint256 quantity,
1114         bytes memory _data
1115     ) internal {
1116         _mint(to, quantity, _data, true);
1117     }
1118 
1119     /**
1120      * @dev Mints `quantity` tokens and transfers them to `to`.
1121      *
1122      * Requirements:
1123      *
1124      * - `to` cannot be the zero address.
1125      * - `quantity` must be greater than 0.
1126      *
1127      * Emits a {Transfer} event.
1128      */
1129     function _mint(
1130         address to,
1131         uint256 quantity,
1132         bytes memory _data,
1133         bool safe
1134     ) internal {
1135         uint256 startTokenId = _currentIndex;
1136         if (to == address(0)) revert MintToZeroAddress();
1137         if (quantity == 0) revert MintZeroQuantity();
1138 
1139         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1140 
1141         // Overflows are incredibly unrealistic.
1142         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1143         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1144         unchecked {
1145             _addressData[to].balance += uint64(quantity);
1146             _addressData[to].numberMinted += uint64(quantity);
1147 
1148             _ownerships[startTokenId].addr = to;
1149             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1150 
1151             uint256 updatedIndex = startTokenId;
1152             uint256 end = updatedIndex + quantity;
1153 
1154             if (safe && to.isContract()) {
1155                 do {
1156                     emit Transfer(address(0), to, updatedIndex);
1157                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1158                         revert TransferToNonERC721ReceiverImplementer();
1159                     }
1160                 } while (updatedIndex != end);
1161                 // Reentrancy protection
1162                 if (_currentIndex != startTokenId) revert();
1163             } else {
1164                 do {
1165                     emit Transfer(address(0), to, updatedIndex++);
1166                 } while (updatedIndex != end);
1167             }
1168             _currentIndex = updatedIndex;
1169         }
1170         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1171     }
1172 
1173     /**
1174      * @dev Transfers `tokenId` from `from` to `to`.
1175      *
1176      * Requirements:
1177      *
1178      * - `to` cannot be the zero address.
1179      * - `tokenId` token must be owned by `from`.
1180      *
1181      * Emits a {Transfer} event.
1182      */
1183     function _transfer(
1184         address from,
1185         address to,
1186         uint256 tokenId
1187     ) private {
1188         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1189 
1190         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1191 
1192         bool isApprovedOrOwner = (_msgSender() == from ||
1193             isApprovedForAll(from, _msgSender()) ||
1194             getApproved(tokenId) == _msgSender());
1195 
1196         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1197         if (to == address(0)) revert TransferToZeroAddress();
1198 
1199         _beforeTokenTransfers(from, to, tokenId, 1);
1200 
1201         // Clear approvals from the previous owner
1202         _approve(address(0), tokenId, from);
1203 
1204         // Underflow of the sender's balance is impossible because we check for
1205         // ownership above and the recipient's balance can't realistically overflow.
1206         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1207         unchecked {
1208             _addressData[from].balance -= 1;
1209             _addressData[to].balance += 1;
1210 
1211             TokenOwnership storage currSlot = _ownerships[tokenId];
1212             currSlot.addr = to;
1213             currSlot.startTimestamp = uint64(block.timestamp);
1214 
1215             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1216             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1217             uint256 nextTokenId = tokenId + 1;
1218             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1219             if (nextSlot.addr == address(0)) {
1220                 // This will suffice for checking _exists(nextTokenId),
1221                 // as a burned slot cannot contain the zero address.
1222                 if (nextTokenId != _currentIndex) {
1223                     nextSlot.addr = from;
1224                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1225                 }
1226             }
1227         }
1228 
1229         emit Transfer(from, to, tokenId);
1230         _afterTokenTransfers(from, to, tokenId, 1);
1231     }
1232 
1233     /**
1234      * @dev This is equivalent to _burn(tokenId, false)
1235      */
1236     function _burn(uint256 tokenId) internal virtual {
1237         _burn(tokenId, false);
1238     }
1239 
1240     /**
1241      * @dev Destroys `tokenId`.
1242      * The approval is cleared when the token is burned.
1243      *
1244      * Requirements:
1245      *
1246      * - `tokenId` must exist.
1247      *
1248      * Emits a {Transfer} event.
1249      */
1250     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1251         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1252 
1253         address from = prevOwnership.addr;
1254 
1255         if (approvalCheck) {
1256             bool isApprovedOrOwner = (_msgSender() == from ||
1257                 isApprovedForAll(from, _msgSender()) ||
1258                 getApproved(tokenId) == _msgSender());
1259 
1260             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1261         }
1262 
1263         _beforeTokenTransfers(from, address(0), tokenId, 1);
1264 
1265         // Clear approvals from the previous owner
1266         _approve(address(0), tokenId, from);
1267 
1268         // Underflow of the sender's balance is impossible because we check for
1269         // ownership above and the recipient's balance can't realistically overflow.
1270         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1271         unchecked {
1272             AddressData storage addressData = _addressData[from];
1273             addressData.balance -= 1;
1274             addressData.numberBurned += 1;
1275 
1276             // Keep track of who burned the token, and the timestamp of burning.
1277             TokenOwnership storage currSlot = _ownerships[tokenId];
1278             currSlot.addr = from;
1279             currSlot.startTimestamp = uint64(block.timestamp);
1280             currSlot.burned = true;
1281 
1282             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1283             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1284             uint256 nextTokenId = tokenId + 1;
1285             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1286             if (nextSlot.addr == address(0)) {
1287                 // This will suffice for checking _exists(nextTokenId),
1288                 // as a burned slot cannot contain the zero address.
1289                 if (nextTokenId != _currentIndex) {
1290                     nextSlot.addr = from;
1291                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1292                 }
1293             }
1294         }
1295 
1296         emit Transfer(from, address(0), tokenId);
1297         _afterTokenTransfers(from, address(0), tokenId, 1);
1298 
1299         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1300         unchecked {
1301             _burnCounter++;
1302         }
1303     }
1304 
1305     /**
1306      * @dev Approve `to` to operate on `tokenId`
1307      *
1308      * Emits a {Approval} event.
1309      */
1310     function _approve(
1311         address to,
1312         uint256 tokenId,
1313         address owner
1314     ) private {
1315         _tokenApprovals[tokenId] = to;
1316         emit Approval(owner, to, tokenId);
1317     }
1318 
1319     /**
1320      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1321      *
1322      * @param from address representing the previous owner of the given token ID
1323      * @param to target address that will receive the tokens
1324      * @param tokenId uint256 ID of the token to be transferred
1325      * @param _data bytes optional data to send along with the call
1326      * @return bool whether the call correctly returned the expected magic value
1327      */
1328     function _checkContractOnERC721Received(
1329         address from,
1330         address to,
1331         uint256 tokenId,
1332         bytes memory _data
1333     ) private returns (bool) {
1334         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1335             return retval == IERC721Receiver(to).onERC721Received.selector;
1336         } catch (bytes memory reason) {
1337             if (reason.length == 0) {
1338                 revert TransferToNonERC721ReceiverImplementer();
1339             } else {
1340                 assembly {
1341                     revert(add(32, reason), mload(reason))
1342                 }
1343             }
1344         }
1345     }
1346 
1347     /**
1348      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1349      * And also called before burning one token.
1350      *
1351      * startTokenId - the first token id to be transferred
1352      * quantity - the amount to be transferred
1353      *
1354      * Calling conditions:
1355      *
1356      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1357      * transferred to `to`.
1358      * - When `from` is zero, `tokenId` will be minted for `to`.
1359      * - When `to` is zero, `tokenId` will be burned by `from`.
1360      * - `from` and `to` are never both zero.
1361      */
1362     function _beforeTokenTransfers(
1363         address from,
1364         address to,
1365         uint256 startTokenId,
1366         uint256 quantity
1367     ) internal virtual {}
1368 
1369     /**
1370      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1371      * minting.
1372      * And also called after one token has been burned.
1373      *
1374      * startTokenId - the first token id to be transferred
1375      * quantity - the amount to be transferred
1376      *
1377      * Calling conditions:
1378      *
1379      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1380      * transferred to `to`.
1381      * - When `from` is zero, `tokenId` has been minted for `to`.
1382      * - When `to` is zero, `tokenId` has been burned by `from`.
1383      * - `from` and `to` are never both zero.
1384      */
1385     function _afterTokenTransfers(
1386         address from,
1387         address to,
1388         uint256 startTokenId,
1389         uint256 quantity
1390     ) internal virtual {}
1391 }
1392 
1393 contract SpaceBoo is ERC721A, Ownable, ReentrancyGuard {
1394 
1395   using Strings for uint256;
1396 
1397   bytes32 public merkleRoot;
1398   
1399   uint256 public constant WHITELIST_MAX_MINT_AMOUNT = 4;
1400 
1401 
1402   string public uriPrefix = '';
1403   string public uriSuffix = '.json';
1404   string public hiddenMetadataUri;
1405   
1406   uint256 public cost = 0.035 ether;
1407   uint256 public wlCost = 0.02 ether;
1408   uint256 public maxSupply = 8888;
1409   uint256 public maxMintAmountPerTx = 4;
1410   uint256 public TOTAL_MAX_MINT_AMOUNT = 6;
1411 
1412   bool public paused = true;
1413   bool public onlyWhitelisted = true;
1414   bool public revealed = false;
1415   mapping(address => uint256) public wlTokenMint;
1416   mapping(address => bool) whitelistedAddresses;
1417 
1418 
1419 
1420   constructor(
1421     string memory _tokenName,
1422     string memory _tokenSymbol,
1423     string memory _initBaseURI,
1424     string memory _hiddenMetadataUri
1425   ) ERC721A(_tokenName, _tokenSymbol) {
1426     setUriPrefix(_initBaseURI);
1427     setHiddenMetadataUri(_hiddenMetadataUri);
1428   }
1429 
1430   modifier mintCompliance(uint256 _mintAmount) {
1431     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, 'Invalid mint amount!');
1432     require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1433     _;
1434   }
1435 
1436   modifier mintPriceCompliance(uint256 _mintAmount) {
1437     require(msg.value >= cost * _mintAmount, 'Insufficient funds!');
1438     _;
1439   }
1440 
1441   modifier wlMintPriceCompliance(uint256 _mintAmount) {
1442     require(msg.value >= wlCost * _mintAmount, 'Insufficient funds!');
1443     _;
1444   }
1445 
1446   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount) {
1447     require(!paused, 'The contract is paused!');
1448     require(!onlyWhitelisted, "Not open to public yet!");
1449     require(balanceOf(msg.sender) + _mintAmount <= TOTAL_MAX_MINT_AMOUNT, "Exceed Mint Limit");
1450 
1451     _safeMint(_msgSender(), _mintAmount);
1452   }
1453 
1454   function ownerMint(uint256 _mintAmount) public payable onlyOwner {
1455      require(_mintAmount > 0, 'Invalid mint amount!');
1456      require(totalSupply() + _mintAmount <= maxSupply, 'Max supply exceeded!');
1457     _safeMint(_msgSender(), _mintAmount);
1458   }
1459 
1460   function wlMint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) wlMintPriceCompliance(_mintAmount) {
1461       require(!paused, 'The contract is paused!');
1462       require(onlyWhitelisted, "Only allowed to mint during whitelist");
1463       require(isWhitelisted(msg.sender), "user is not whitelisted");
1464       uint256 minted = wlMintAmount(msg.sender);
1465       require(minted + _mintAmount <= WHITELIST_MAX_MINT_AMOUNT, "Exceeed WL Mint Amount");
1466       _safeMint(_msgSender(), _mintAmount);
1467       wlTokenMint[msg.sender] = minted + _mintAmount;
1468   }
1469 
1470   function wlMintAmount(address _user) public view returns (uint256) {
1471       return wlTokenMint[_user];
1472   }
1473 
1474   function isWhitelisted(address _user) public view returns (bool) {
1475     return whitelistedAddresses[_user];
1476   }
1477   
1478   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
1479     _safeMint(_receiver, _mintAmount);
1480   }
1481 
1482   function walletOfOwner(address _owner) public view returns (uint256[] memory) {
1483     uint256 ownerTokenCount = balanceOf(_owner);
1484     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
1485     uint256 currentTokenId = _startTokenId();
1486     uint256 ownedTokenIndex = 0;
1487     address latestOwnerAddress;
1488 
1489     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
1490       TokenOwnership memory ownership = _ownerships[currentTokenId];
1491 
1492       if (!ownership.burned && ownership.addr != address(0)) {
1493         latestOwnerAddress = ownership.addr;
1494       }
1495 
1496       if (latestOwnerAddress == _owner) {
1497         ownedTokenIds[ownedTokenIndex] = currentTokenId;
1498 
1499         ownedTokenIndex++;
1500       }
1501 
1502       currentTokenId++;
1503     }
1504 
1505     return ownedTokenIds;
1506   }
1507 
1508   function _startTokenId() internal view virtual override returns (uint256) {
1509     return 1;
1510   }
1511 
1512   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1513     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1514 
1515     if (revealed == false) {
1516       return hiddenMetadataUri;
1517     }
1518 
1519     string memory currentBaseURI = _baseURI();
1520     return bytes(currentBaseURI).length > 0
1521         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1522         : '';
1523   }
1524 
1525   function setRevealed(bool _state) public onlyOwner {
1526     revealed = _state;
1527   }
1528 
1529   function setCost(uint256 _cost) public onlyOwner {
1530     cost = _cost;
1531   }
1532 
1533   function setTotalMaxMintAmount(uint _amount) public onlyOwner {
1534       require(_amount <= 8888, "Exceed total amount");
1535       TOTAL_MAX_MINT_AMOUNT = _amount;
1536   }
1537 
1538   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
1539     maxMintAmountPerTx = _maxMintAmountPerTx;
1540   }
1541 
1542   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
1543     hiddenMetadataUri = _hiddenMetadataUri;
1544   }
1545 
1546   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1547     uriPrefix = _uriPrefix;
1548   }
1549 
1550   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1551     uriSuffix = _uriSuffix;
1552   }
1553 
1554   function setPaused(bool _state) public onlyOwner {
1555     paused = _state;
1556   }
1557 
1558   function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1559     merkleRoot = _merkleRoot;
1560   }
1561 
1562   function setOnlyWhitelisted(bool _state) public onlyOwner {
1563     onlyWhitelisted = _state;
1564   }
1565 
1566   function withdraw() public onlyOwner nonReentrant {
1567     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1568     require(os);
1569   }
1570 
1571   function addWhitelistUsers(address[] calldata _users) public onlyOwner {
1572       for (uint i=0; i < _users.length; i++) {
1573         whitelistedAddresses[_users[i]] = true;
1574     }
1575   }
1576 
1577   function _baseURI() internal view virtual override returns (string memory) {
1578     return uriPrefix;
1579   }
1580 }