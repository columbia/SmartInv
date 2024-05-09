1 pragma solidity ^0.8.0;
2 
3 // File @openzeppelin/contracts/utils/cryptography/MerkleProof.sol@v4.4.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 /**
57  * @dev Contract module that helps prevent reentrant calls to a function.
58  *
59  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
60  * available, which can be applied to functions to make sure there are no nested
61  * (reentrant) calls to them.
62  *
63  * Note that because there is a single `nonReentrant` guard, functions marked as
64  * `nonReentrant` may not call one another. This can be worked around by making
65  * those functions `private`, and then adding `external` `nonReentrant` entry
66  * points to them.
67  *
68  * TIP: If you would like to learn more about reentrancy and alternative ways
69  * to protect against it, check out our blog post
70  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
71  */
72 abstract contract ReentrancyGuard {
73     // Booleans are more expensive than uint256 or any type that takes up a full
74     // word because each write operation emits an extra SLOAD to first read the
75     // slot's contents, replace the bits taken up by the boolean, and then write
76     // back. This is the compiler's defense against contract upgrades and
77     // pointer aliasing, and it cannot be disabled.
78 
79     // The values being non-zero value makes deployment a bit more expensive,
80     // but in exchange the refund on every call to nonReentrant will be lower in
81     // amount. Since refunds are capped to a percentage of the total
82     // transaction's gas, it is best to keep them low in cases like this one, to
83     // increase the likelihood of the full refund coming into effect.
84     uint256 private constant _NOT_ENTERED = 1;
85     uint256 private constant _ENTERED = 2;
86 
87     uint256 private _status;
88 
89     constructor() {
90         _status = _NOT_ENTERED;
91     }
92 
93     /**
94      * @dev Prevents a contract from calling itself, directly or indirectly.
95      * Calling a `nonReentrant` function from another `nonReentrant`
96      * function is not supported. It is possible to prevent this from happening
97      * by making the `nonReentrant` function external, and making it call a
98      * `private` function that does the actual work.
99      */
100     modifier nonReentrant() {
101         // On the first call to nonReentrant, _notEntered will be true
102         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
103 
104         // Any calls to nonReentrant after this point will fail
105         _status = _ENTERED;
106 
107         _;
108 
109         // By storing the original value once again, a refund is triggered (see
110         // https://eips.ethereum.org/EIPS/eip-2200)
111         _status = _NOT_ENTERED;
112     }
113 }
114 
115 
116 
117 /**
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         return msg.data;
134     }
135 }
136 
137 
138 // File @openzeppelin/contracts/access/Ownable.sol@v4.4.2
139 
140 
141 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
142 
143 
144 
145 /**
146  * @dev Contract module which provides a basic access control mechanism, where
147  * there is an account (an owner) that can be granted exclusive access to
148  * specific functions.
149  *
150  * By default, the owner account will be the one that deploys the contract. This
151  * can later be changed with {transferOwnership}.
152  *
153  * This module is used through inheritance. It will make available the modifier
154  * `onlyOwner`, which can be applied to your functions to restrict their use to
155  * the owner.
156  */
157 abstract contract Ownable is Context {
158     address private _owner;
159 
160     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
161 
162     /**
163      * @dev Initializes the contract setting the deployer as the initial owner.
164      */
165     constructor() {
166         _transferOwnership(_msgSender());
167     }
168 
169     /**
170      * @dev Returns the address of the current owner.
171      */
172     function owner() public view virtual returns (address) {
173         return _owner;
174     }
175 
176     /**
177      * @dev Throws if called by any account other than the owner.
178      */
179     modifier onlyOwner() {
180         require(owner() == _msgSender(), "Ownable: caller is not the owner");
181         _;
182     }
183 
184     /**
185      * @dev Leaves the contract without owner. It will not be possible to call
186      * `onlyOwner` functions anymore. Can only be called by the current owner.
187      *
188      * NOTE: Renouncing ownership will leave the contract without an owner,
189      * thereby removing any functionality that is only available to the owner.
190      */
191     function renounceOwnership() public virtual onlyOwner {
192         _transferOwnership(address(0));
193     }
194 
195     /**
196      * @dev Transfers ownership of the contract to a new account (`newOwner`).
197      * Can only be called by the current owner.
198      */
199     function transferOwnership(address newOwner) public virtual onlyOwner {
200         require(newOwner != address(0), "Ownable: new owner is the zero address");
201         _transferOwnership(newOwner);
202     }
203 
204     /**
205      * @dev Transfers ownership of the contract to a new account (`newOwner`).
206      * Internal function without access restriction.
207      */
208     function _transferOwnership(address newOwner) internal virtual {
209         address oldOwner = _owner;
210         _owner = newOwner;
211         emit OwnershipTransferred(oldOwner, newOwner);
212     }
213 }
214 
215 
216 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
220 
221 
222 
223 /**
224  * @dev String operations.
225  */
226 library Strings {
227     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
228 
229     /**
230      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
231      */
232     function toString(uint256 value) internal pure returns (string memory) {
233         // Inspired by OraclizeAPI's implementation - MIT licence
234         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
235 
236         if (value == 0) {
237             return "0";
238         }
239         uint256 temp = value;
240         uint256 digits;
241         while (temp != 0) {
242             digits++;
243             temp /= 10;
244         }
245         bytes memory buffer = new bytes(digits);
246         while (value != 0) {
247             digits -= 1;
248             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
249             value /= 10;
250         }
251         return string(buffer);
252     }
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
256      */
257     function toHexString(uint256 value) internal pure returns (string memory) {
258         if (value == 0) {
259             return "0x00";
260         }
261         uint256 temp = value;
262         uint256 length = 0;
263         while (temp != 0) {
264             length++;
265             temp >>= 8;
266         }
267         return toHexString(value, length);
268     }
269 
270     /**
271      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
272      */
273     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
274         bytes memory buffer = new bytes(2 * length + 2);
275         buffer[0] = "0";
276         buffer[1] = "x";
277         for (uint256 i = 2 * length + 1; i > 1; --i) {
278             buffer[i] = _HEX_SYMBOLS[value & 0xf];
279             value >>= 4;
280         }
281         require(value == 0, "Strings: hex length insufficient");
282         return string(buffer);
283     }
284 }
285 
286 
287 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
288 
289 
290 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
291 
292 
293 
294 /**
295  * @dev Interface of the ERC165 standard, as defined in the
296  * https://eips.ethereum.org/EIPS/eip-165[EIP].
297  *
298  * Implementers can declare support of contract interfaces, which can then be
299  * queried by others ({ERC165Checker}).
300  *
301  * For an implementation, see {ERC165}.
302  */
303 interface IERC165 {
304     /**
305      * @dev Returns true if this contract implements the interface defined by
306      * `interfaceId`. See the corresponding
307      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
308      * to learn more about how these ids are created.
309      *
310      * This function call must use less than 30 000 gas.
311      */
312     function supportsInterface(bytes4 interfaceId) external view returns (bool);
313 }
314 
315 
316 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.2
317 
318 
319 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
320 
321 
322 
323 /**
324  * @dev Required interface of an ERC721 compliant contract.
325  */
326 interface IERC721 is IERC165 {
327     /**
328      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
329      */
330     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
331 
332     /**
333      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
334      */
335     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
336 
337     /**
338      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
339      */
340     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
341 
342     /**
343      * @dev Returns the number of tokens in ``owner``'s account.
344      */
345     function balanceOf(address owner) external view returns (uint256 balance);
346 
347     /**
348      * @dev Returns the owner of the `tokenId` token.
349      *
350      * Requirements:
351      *
352      * - `tokenId` must exist.
353      */
354     function ownerOf(uint256 tokenId) external view returns (address owner);
355 
356     /**
357      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
358      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
359      *
360      * Requirements:
361      *
362      * - `from` cannot be the zero address.
363      * - `to` cannot be the zero address.
364      * - `tokenId` token must exist and be owned by `from`.
365      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
366      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
367      *
368      * Emits a {Transfer} event.
369      */
370     function safeTransferFrom(
371         address from,
372         address to,
373         uint256 tokenId
374     ) external;
375 
376     /**
377      * @dev Transfers `tokenId` token from `from` to `to`.
378      *
379      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
380      *
381      * Requirements:
382      *
383      * - `from` cannot be the zero address.
384      * - `to` cannot be the zero address.
385      * - `tokenId` token must be owned by `from`.
386      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 tokenId
394     ) external;
395 
396     /**
397      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
398      * The approval is cleared when the token is transferred.
399      *
400      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
401      *
402      * Requirements:
403      *
404      * - The caller must own the token or be an approved operator.
405      * - `tokenId` must exist.
406      *
407      * Emits an {Approval} event.
408      */
409     function approve(address to, uint256 tokenId) external;
410 
411     /**
412      * @dev Returns the account approved for `tokenId` token.
413      *
414      * Requirements:
415      *
416      * - `tokenId` must exist.
417      */
418     function getApproved(uint256 tokenId) external view returns (address operator);
419 
420     /**
421      * @dev Approve or remove `operator` as an operator for the caller.
422      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
423      *
424      * Requirements:
425      *
426      * - The `operator` cannot be the caller.
427      *
428      * Emits an {ApprovalForAll} event.
429      */
430     function setApprovalForAll(address operator, bool _approved) external;
431 
432     /**
433      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
434      *
435      * See {setApprovalForAll}
436      */
437     function isApprovedForAll(address owner, address operator) external view returns (bool);
438 
439     /**
440      * @dev Safely transfers `tokenId` token from `from` to `to`.
441      *
442      * Requirements:
443      *
444      * - `from` cannot be the zero address.
445      * - `to` cannot be the zero address.
446      * - `tokenId` token must exist and be owned by `from`.
447      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
448      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
449      *
450      * Emits a {Transfer} event.
451      */
452     function safeTransferFrom(
453         address from,
454         address to,
455         uint256 tokenId,
456         bytes calldata data
457     ) external;
458 }
459 
460 
461 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.2
462 
463 
464 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
465 
466 
467 
468 /**
469  * @title ERC721 token receiver interface
470  * @dev Interface for any contract that wants to support safeTransfers
471  * from ERC721 asset contracts.
472  */
473 interface IERC721Receiver {
474     /**
475      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
476      * by `operator` from `from`, this function is called.
477      *
478      * It must return its Solidity selector to confirm the token transfer.
479      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
480      *
481      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
482      */
483     function onERC721Received(
484         address operator,
485         address from,
486         uint256 tokenId,
487         bytes calldata data
488     ) external returns (bytes4);
489 }
490 
491 
492 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.2
493 
494 
495 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
496 
497 
498 
499 /**
500  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
501  * @dev See https://eips.ethereum.org/EIPS/eip-721
502  */
503 interface IERC721Metadata is IERC721 {
504     /**
505      * @dev Returns the token collection name.
506      */
507     function name() external view returns (string memory);
508 
509     /**
510      * @dev Returns the token collection symbol.
511      */
512     function symbol() external view returns (string memory);
513 
514     /**
515      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
516      */
517     function tokenURI(uint256 tokenId) external view returns (string memory);
518 }
519 
520 
521 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.2
522 
523 
524 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
525 
526 
527 
528 /**
529  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
530  * @dev See https://eips.ethereum.org/EIPS/eip-721
531  */
532 interface IERC721Enumerable is IERC721 {
533     /**
534      * @dev Returns the total amount of tokens stored by the contract.
535      */
536     function totalSupply() external view returns (uint256);
537 
538     /**
539      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
540      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
541      */
542     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
543 
544     /**
545      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
546      * Use along with {totalSupply} to enumerate all tokens.
547      */
548     function tokenByIndex(uint256 index) external view returns (uint256);
549 }
550 
551 
552 // File @openzeppelin/contracts/utils/Address.sol@v4.4.2
553 
554 
555 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
556 
557 
558 
559 /**
560  * @dev Collection of functions related to the address type
561  */
562 library Address {
563     /**
564      * @dev Returns true if `account` is a contract.
565      *
566      * [IMPORTANT]
567      * ====
568      * It is unsafe to assume that an address for which this function returns
569      * false is an externally-owned account (EOA) and not a contract.
570      *
571      * Among others, `isContract` will return false for the following
572      * types of addresses:
573      *
574      *  - an externally-owned account
575      *  - a contract in construction
576      *  - an address where a contract will be created
577      *  - an address where a contract lived, but was destroyed
578      * ====
579      */
580     function isContract(address account) internal view returns (bool) {
581         // This method relies on extcodesize, which returns 0 for contracts in
582         // construction, since the code is only stored at the end of the
583         // constructor execution.
584 
585         uint256 size;
586         assembly {
587             size := extcodesize(account)
588         }
589         return size > 0;
590     }
591 
592     /**
593      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
594      * `recipient`, forwarding all available gas and reverting on errors.
595      *
596      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
597      * of certain opcodes, possibly making contracts go over the 2300 gas limit
598      * imposed by `transfer`, making them unable to receive funds via
599      * `transfer`. {sendValue} removes this limitation.
600      *
601      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
602      *
603      * IMPORTANT: because control is transferred to `recipient`, care must be
604      * taken to not create reentrancy vulnerabilities. Consider using
605      * {ReentrancyGuard} or the
606      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
607      */
608     function sendValue(address payable recipient, uint256 amount) internal {
609         require(address(this).balance >= amount, "Address: insufficient balance");
610 
611         (bool success, ) = recipient.call{value: amount}("");
612         require(success, "Address: unable to send value, recipient may have reverted");
613     }
614 
615     /**
616      * @dev Performs a Solidity function call using a low level `call`. A
617      * plain `call` is an unsafe replacement for a function call: use this
618      * function instead.
619      *
620      * If `target` reverts with a revert reason, it is bubbled up by this
621      * function (like regular Solidity function calls).
622      *
623      * Returns the raw returned data. To convert to the expected return value,
624      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
625      *
626      * Requirements:
627      *
628      * - `target` must be a contract.
629      * - calling `target` with `data` must not revert.
630      *
631      * _Available since v3.1._
632      */
633     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
634         return functionCall(target, data, "Address: low-level call failed");
635     }
636 
637     /**
638      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
639      * `errorMessage` as a fallback revert reason when `target` reverts.
640      *
641      * _Available since v3.1._
642      */
643     function functionCall(
644         address target,
645         bytes memory data,
646         string memory errorMessage
647     ) internal returns (bytes memory) {
648         return functionCallWithValue(target, data, 0, errorMessage);
649     }
650 
651     /**
652      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
653      * but also transferring `value` wei to `target`.
654      *
655      * Requirements:
656      *
657      * - the calling contract must have an ETH balance of at least `value`.
658      * - the called Solidity function must be `payable`.
659      *
660      * _Available since v3.1._
661      */
662     function functionCallWithValue(
663         address target,
664         bytes memory data,
665         uint256 value
666     ) internal returns (bytes memory) {
667         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
668     }
669 
670     /**
671      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
672      * with `errorMessage` as a fallback revert reason when `target` reverts.
673      *
674      * _Available since v3.1._
675      */
676     function functionCallWithValue(
677         address target,
678         bytes memory data,
679         uint256 value,
680         string memory errorMessage
681     ) internal returns (bytes memory) {
682         require(address(this).balance >= value, "Address: insufficient balance for call");
683         require(isContract(target), "Address: call to non-contract");
684 
685         (bool success, bytes memory returndata) = target.call{value: value}(data);
686         return verifyCallResult(success, returndata, errorMessage);
687     }
688 
689     /**
690      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
691      * but performing a static call.
692      *
693      * _Available since v3.3._
694      */
695     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
696         return functionStaticCall(target, data, "Address: low-level static call failed");
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
701      * but performing a static call.
702      *
703      * _Available since v3.3._
704      */
705     function functionStaticCall(
706         address target,
707         bytes memory data,
708         string memory errorMessage
709     ) internal view returns (bytes memory) {
710         require(isContract(target), "Address: static call to non-contract");
711 
712         (bool success, bytes memory returndata) = target.staticcall(data);
713         return verifyCallResult(success, returndata, errorMessage);
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
718      * but performing a delegate call.
719      *
720      * _Available since v3.4._
721      */
722     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
723         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
724     }
725 
726     /**
727      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
728      * but performing a delegate call.
729      *
730      * _Available since v3.4._
731      */
732     function functionDelegateCall(
733         address target,
734         bytes memory data,
735         string memory errorMessage
736     ) internal returns (bytes memory) {
737         require(isContract(target), "Address: delegate call to non-contract");
738 
739         (bool success, bytes memory returndata) = target.delegatecall(data);
740         return verifyCallResult(success, returndata, errorMessage);
741     }
742 
743     /**
744      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
745      * revert reason using the provided one.
746      *
747      * _Available since v4.3._
748      */
749     function verifyCallResult(
750         bool success,
751         bytes memory returndata,
752         string memory errorMessage
753     ) internal pure returns (bytes memory) {
754         if (success) {
755             return returndata;
756         } else {
757             // Look for revert reason and bubble it up if present
758             if (returndata.length > 0) {
759                 // The easiest way to bubble the revert reason is using memory via assembly
760 
761                 assembly {
762                     let returndata_size := mload(returndata)
763                     revert(add(32, returndata), returndata_size)
764                 }
765             } else {
766                 revert(errorMessage);
767             }
768         }
769     }
770 }
771 
772 
773 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
774 
775 
776 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
777 
778 
779 
780 /**
781  * @dev Implementation of the {IERC165} interface.
782  *
783  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
784  * for the additional interface id that will be supported. For example:
785  *
786  * ```solidity
787  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
788  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
789  * }
790  * ```
791  *
792  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
793  */
794 abstract contract ERC165 is IERC165 {
795     /**
796      * @dev See {IERC165-supportsInterface}.
797      */
798     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
799         return interfaceId == type(IERC165).interfaceId;
800     }
801 }
802 
803 
804 // File contracts/ERC721A.sol
805 
806 
807 // Creator: Chiru Labs
808 
809 
810 /**
811  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
812  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
813  *
814  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
815  *
816  * Does not support burning tokens to address(0).
817  *
818  * Assumes that an owner cannot have more than the 2**128 (max value of uint128) of supply
819  */
820 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
821     using Address for address;
822     using Strings for uint256;
823 
824     struct TokenOwnership {
825         address addr;
826         uint64 startTimestamp;
827     }
828 
829     struct AddressData {
830         uint128 balance;
831         uint128 numberMinted;
832     }
833 
834     uint256 internal currentIndex = 0;
835 
836     // Token name
837     string private _name;
838 
839     // Token symbol
840     string private _symbol;
841 
842     // Mapping from token ID to ownership details
843     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
844     mapping(uint256 => TokenOwnership) internal _ownerships;
845 
846     // Mapping owner address to address data
847     mapping(address => AddressData) private _addressData;
848 
849     // Mapping from token ID to approved address
850     mapping(uint256 => address) private _tokenApprovals;
851 
852     // Mapping from owner to operator approvals
853     mapping(address => mapping(address => bool)) private _operatorApprovals;
854 
855     constructor(string memory name_, string memory symbol_) {
856         _name = name_;
857         _symbol = symbol_;
858     }
859 
860     /**
861      * @dev See {IERC721Enumerable-totalSupply}.
862      */
863     function totalSupply() public view override returns (uint256) {
864         return currentIndex;
865     }
866 
867     /**
868      * @dev See {IERC721Enumerable-tokenByIndex}.
869      */
870     function tokenByIndex(uint256 index) public view override returns (uint256) {
871         require(index < totalSupply(), 'ERC721A: global index out of bounds');
872         return index;
873     }
874 
875     /**
876      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
877      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
878      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
879      */
880     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
881         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
882         uint256 numMintedSoFar = totalSupply();
883         uint256 tokenIdsIdx = 0;
884         address currOwnershipAddr = address(0);
885         for (uint256 i = 0; i < numMintedSoFar; i++) {
886             TokenOwnership memory ownership = _ownerships[i];
887             if (ownership.addr != address(0)) {
888                 currOwnershipAddr = ownership.addr;
889             }
890             if (currOwnershipAddr == owner) {
891                 if (tokenIdsIdx == index) {
892                     return i;
893                 }
894                 tokenIdsIdx++;
895             }
896         }
897         revert('ERC721A: unable to get token of owner by index');
898     }
899 
900     /**
901      * @dev See {IERC165-supportsInterface}.
902      */
903     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
904         return
905             interfaceId == type(IERC721).interfaceId ||
906             interfaceId == type(IERC721Metadata).interfaceId ||
907             interfaceId == type(IERC721Enumerable).interfaceId ||
908             super.supportsInterface(interfaceId);
909     }
910 
911     /**
912      * @dev See {IERC721-balanceOf}.
913      */
914     function balanceOf(address owner) public view override returns (uint256) {
915         require(owner != address(0), 'ERC721A: balance query for the zero address');
916         return uint256(_addressData[owner].balance);
917     }
918 
919     function _numberMinted(address owner) internal view returns (uint256) {
920         require(owner != address(0), 'ERC721A: number minted query for the zero address');
921         return uint256(_addressData[owner].numberMinted);
922     }
923 
924     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
925         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
926 
927         for (uint256 curr = tokenId; ; curr--) {
928             TokenOwnership memory ownership = _ownerships[curr];
929             if (ownership.addr != address(0)) {
930                 return ownership;
931             }
932         }
933 
934         revert('ERC721A: unable to determine the owner of token');
935     }
936 
937     /**
938      * @dev See {IERC721-ownerOf}.
939      */
940     function ownerOf(uint256 tokenId) public view override returns (address) {
941         return ownershipOf(tokenId).addr;
942     }
943 
944     /**
945      * @dev See {IERC721Metadata-name}.
946      */
947     function name() public view virtual override returns (string memory) {
948         return _name;
949     }
950 
951     /**
952      * @dev See {IERC721Metadata-symbol}.
953      */
954     function symbol() public view virtual override returns (string memory) {
955         return _symbol;
956     }
957 
958     /**
959      * @dev See {IERC721Metadata-tokenURI}.
960      */
961     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
962         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
963 
964         string memory baseURI = _baseURI();
965         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
966     }
967 
968     /**
969      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
970      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
971      * by default, can be overriden in child contracts.
972      */
973     function _baseURI() internal view virtual returns (string memory) {
974         return '';
975     }
976 
977     /**
978      * @dev See {IERC721-approve}.
979      */
980     function approve(address to, uint256 tokenId) public override {
981         address owner = ERC721A.ownerOf(tokenId);
982         require(to != owner, 'ERC721A: approval to current owner');
983 
984         require(
985             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
986             'ERC721A: approve caller is not owner nor approved for all'
987         );
988 
989         _approve(to, tokenId, owner);
990     }
991 
992     /**
993      * @dev See {IERC721-getApproved}.
994      */
995     function getApproved(uint256 tokenId) public view override returns (address) {
996         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
997 
998         return _tokenApprovals[tokenId];
999     }
1000 
1001     /**
1002      * @dev See {IERC721-setApprovalForAll}.
1003      */
1004     function setApprovalForAll(address operator, bool approved) public override {
1005         require(operator != _msgSender(), 'ERC721A: approve to caller');
1006 
1007         _operatorApprovals[_msgSender()][operator] = approved;
1008         emit ApprovalForAll(_msgSender(), operator, approved);
1009     }
1010 
1011     /**
1012      * @dev See {IERC721-isApprovedForAll}.
1013      */
1014     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1015         return _operatorApprovals[owner][operator];
1016     }
1017 
1018     /**
1019      * @dev See {IERC721-transferFrom}.
1020      */
1021     function transferFrom(
1022         address from,
1023         address to,
1024         uint256 tokenId
1025     ) public override {
1026         _transfer(from, to, tokenId);
1027     }
1028 
1029     /**
1030      * @dev See {IERC721-safeTransferFrom}.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) public override {
1037         safeTransferFrom(from, to, tokenId, '');
1038     }
1039 
1040     /**
1041      * @dev See {IERC721-safeTransferFrom}.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId,
1047         bytes memory _data
1048     ) public override {
1049         _transfer(from, to, tokenId);
1050         require(
1051             _checkOnERC721Received(from, to, tokenId, _data),
1052             'ERC721A: transfer to non ERC721Receiver implementer'
1053         );
1054     }
1055 
1056     /**
1057      * @dev Returns whether `tokenId` exists.
1058      *
1059      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1060      *
1061      * Tokens start existing when they are minted (`_mint`),
1062      */
1063     function _exists(uint256 tokenId) internal view returns (bool) {
1064         return tokenId < currentIndex;
1065     }
1066 
1067     function _safeMint(address to, uint256 quantity) internal {
1068         _safeMint(to, quantity, '');
1069     }
1070 
1071     /**
1072      * @dev Mints `quantity` tokens and transfers them to `to`.
1073      *
1074      * Requirements:
1075      *
1076      * - `to` cannot be the zero address.
1077      * - `quantity` cannot be larger than the max batch size.
1078      *
1079      * Emits a {Transfer} event.
1080      */
1081     function _safeMint(
1082         address to,
1083         uint256 quantity,
1084         bytes memory _data
1085     ) internal {
1086         uint256 startTokenId = currentIndex;
1087         require(to != address(0), 'ERC721A: mint to the zero address');
1088         // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1089         require(!_exists(startTokenId), 'ERC721A: token already minted');
1090         require(quantity > 0, 'ERC721A: quantity must be greater 0');
1091 
1092         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1093 
1094         AddressData memory addressData = _addressData[to];
1095         _addressData[to] = AddressData(
1096             addressData.balance + uint128(quantity),
1097             addressData.numberMinted + uint128(quantity)
1098         );
1099         _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1100 
1101         uint256 updatedIndex = startTokenId;
1102 
1103         for (uint256 i = 0; i < quantity; i++) {
1104             emit Transfer(address(0), to, updatedIndex);
1105             require(
1106                 _checkOnERC721Received(address(0), to, updatedIndex, _data),
1107                 'ERC721A: transfer to non ERC721Receiver implementer'
1108             );
1109             updatedIndex++;
1110         }
1111 
1112         currentIndex = updatedIndex;
1113         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1114     }
1115 
1116     /**
1117      * @dev Transfers `tokenId` from `from` to `to`.
1118      *
1119      * Requirements:
1120      *
1121      * - `to` cannot be the zero address.
1122      * - `tokenId` token must be owned by `from`.
1123      *
1124      * Emits a {Transfer} event.
1125      */
1126     function _transfer(
1127         address from,
1128         address to,
1129         uint256 tokenId
1130     ) private {
1131         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1132 
1133         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1134             getApproved(tokenId) == _msgSender() ||
1135             isApprovedForAll(prevOwnership.addr, _msgSender()));
1136 
1137         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1138 
1139         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1140         require(to != address(0), 'ERC721A: transfer to the zero address');
1141 
1142         _beforeTokenTransfers(from, to, tokenId, 1);
1143 
1144         // Clear approvals from the previous owner
1145         _approve(address(0), tokenId, prevOwnership.addr);
1146 
1147         // Underflow of the sender's balance is impossible because we check for
1148         // ownership above and the recipient's balance can't realistically overflow.
1149         unchecked {
1150             _addressData[from].balance -= 1;
1151             _addressData[to].balance += 1;
1152         }
1153 
1154         _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1155 
1156         // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1157         // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1158         uint256 nextTokenId = tokenId + 1;
1159         if (_ownerships[nextTokenId].addr == address(0)) {
1160             if (_exists(nextTokenId)) {
1161                 _ownerships[nextTokenId] = TokenOwnership(prevOwnership.addr, prevOwnership.startTimestamp);
1162             }
1163         }
1164 
1165         emit Transfer(from, to, tokenId);
1166         _afterTokenTransfers(from, to, tokenId, 1);
1167     }
1168 
1169     /**
1170      * @dev Approve `to` to operate on `tokenId`
1171      *
1172      * Emits a {Approval} event.
1173      */
1174     function _approve(
1175         address to,
1176         uint256 tokenId,
1177         address owner
1178     ) private {
1179         _tokenApprovals[tokenId] = to;
1180         emit Approval(owner, to, tokenId);
1181     }
1182 
1183     /**
1184      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1185      * The call is not executed if the target address is not a contract.
1186      *
1187      * @param from address representing the previous owner of the given token ID
1188      * @param to target address that will receive the tokens
1189      * @param tokenId uint256 ID of the token to be transferred
1190      * @param _data bytes optional data to send along with the call
1191      * @return bool whether the call correctly returned the expected magic value
1192      */
1193     function _checkOnERC721Received(
1194         address from,
1195         address to,
1196         uint256 tokenId,
1197         bytes memory _data
1198     ) private returns (bool) {
1199         if (to.isContract()) {
1200             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1201                 return retval == IERC721Receiver(to).onERC721Received.selector;
1202             } catch (bytes memory reason) {
1203                 if (reason.length == 0) {
1204                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1205                 } else {
1206                     assembly {
1207                         revert(add(32, reason), mload(reason))
1208                     }
1209                 }
1210             }
1211         } else {
1212             return true;
1213         }
1214     }
1215 
1216     /**
1217      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1218      *
1219      * startTokenId - the first token id to be transferred
1220      * quantity - the amount to be transferred
1221      *
1222      * Calling conditions:
1223      *
1224      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1225      * transferred to `to`.
1226      * - When `from` is zero, `tokenId` will be minted for `to`.
1227      */
1228     function _beforeTokenTransfers(
1229         address from,
1230         address to,
1231         uint256 startTokenId,
1232         uint256 quantity
1233     ) internal virtual {}
1234 
1235     /**
1236      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1237      * minting.
1238      *
1239      * startTokenId - the first token id to be transferred
1240      * quantity - the amount to be transferred
1241      *
1242      * Calling conditions:
1243      *
1244      * - when `from` and `to` are both non-zero.
1245      * - `from` and `to` are never both zero.
1246      */
1247     function _afterTokenTransfers(
1248         address from,
1249         address to,
1250         uint256 startTokenId,
1251         uint256 quantity
1252     ) internal virtual {}
1253 }
1254 
1255 // CAUTION
1256 // This version of SafeMath should only be used with Solidity 0.8 or later,
1257 // because it relies on the compiler's built in overflow checks.
1258 
1259 /**
1260  * @dev Wrappers over Solidity's arithmetic operations.
1261  *
1262  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1263  * now has built in overflow checking.
1264  */
1265 library SafeMath {
1266     /**
1267      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1268      *
1269      * _Available since v3.4._
1270      */
1271     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1272         unchecked {
1273             uint256 c = a + b;
1274             if (c < a) return (false, 0);
1275             return (true, c);
1276         }
1277     }
1278 
1279     /**
1280      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1281      *
1282      * _Available since v3.4._
1283      */
1284     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1285         unchecked {
1286             if (b > a) return (false, 0);
1287             return (true, a - b);
1288         }
1289     }
1290 
1291     /**
1292      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1293      *
1294      * _Available since v3.4._
1295      */
1296     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1297         unchecked {
1298             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1299             // benefit is lost if 'b' is also tested.
1300             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1301             if (a == 0) return (true, 0);
1302             uint256 c = a * b;
1303             if (c / a != b) return (false, 0);
1304             return (true, c);
1305         }
1306     }
1307 
1308     /**
1309      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1310      *
1311      * _Available since v3.4._
1312      */
1313     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1314         unchecked {
1315             if (b == 0) return (false, 0);
1316             return (true, a / b);
1317         }
1318     }
1319 
1320     /**
1321      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1322      *
1323      * _Available since v3.4._
1324      */
1325     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1326         unchecked {
1327             if (b == 0) return (false, 0);
1328             return (true, a % b);
1329         }
1330     }
1331 
1332     /**
1333      * @dev Returns the addition of two unsigned integers, reverting on
1334      * overflow.
1335      *
1336      * Counterpart to Solidity's `+` operator.
1337      *
1338      * Requirements:
1339      *
1340      * - Addition cannot overflow.
1341      */
1342     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1343         return a + b;
1344     }
1345 
1346     /**
1347      * @dev Returns the subtraction of two unsigned integers, reverting on
1348      * overflow (when the result is negative).
1349      *
1350      * Counterpart to Solidity's `-` operator.
1351      *
1352      * Requirements:
1353      *
1354      * - Subtraction cannot overflow.
1355      */
1356     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1357         return a - b;
1358     }
1359 
1360     /**
1361      * @dev Returns the multiplication of two unsigned integers, reverting on
1362      * overflow.
1363      *
1364      * Counterpart to Solidity's `*` operator.
1365      *
1366      * Requirements:
1367      *
1368      * - Multiplication cannot overflow.
1369      */
1370     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1371         return a * b;
1372     }
1373 
1374     /**
1375      * @dev Returns the integer division of two unsigned integers, reverting on
1376      * division by zero. The result is rounded towards zero.
1377      *
1378      * Counterpart to Solidity's `/` operator.
1379      *
1380      * Requirements:
1381      *
1382      * - The divisor cannot be zero.
1383      */
1384     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1385         return a / b;
1386     }
1387 
1388     /**
1389      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1390      * reverting when dividing by zero.
1391      *
1392      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1393      * opcode (which leaves remaining gas untouched) while Solidity uses an
1394      * invalid opcode to revert (consuming all remaining gas).
1395      *
1396      * Requirements:
1397      *
1398      * - The divisor cannot be zero.
1399      */
1400     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1401         return a % b;
1402     }
1403 
1404     /**
1405      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1406      * overflow (when the result is negative).
1407      *
1408      * CAUTION: This function is deprecated because it requires allocating memory for the error
1409      * message unnecessarily. For custom revert reasons use {trySub}.
1410      *
1411      * Counterpart to Solidity's `-` operator.
1412      *
1413      * Requirements:
1414      *
1415      * - Subtraction cannot overflow.
1416      */
1417     function sub(
1418         uint256 a,
1419         uint256 b,
1420         string memory errorMessage
1421     ) internal pure returns (uint256) {
1422         unchecked {
1423             require(b <= a, errorMessage);
1424             return a - b;
1425         }
1426     }
1427 
1428     /**
1429      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1430      * division by zero. The result is rounded towards zero.
1431      *
1432      * Counterpart to Solidity's `/` operator. Note: this function uses a
1433      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1434      * uses an invalid opcode to revert (consuming all remaining gas).
1435      *
1436      * Requirements:
1437      *
1438      * - The divisor cannot be zero.
1439      */
1440     function div(
1441         uint256 a,
1442         uint256 b,
1443         string memory errorMessage
1444     ) internal pure returns (uint256) {
1445         unchecked {
1446             require(b > 0, errorMessage);
1447             return a / b;
1448         }
1449     }
1450 
1451     /**
1452      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1453      * reverting with custom message when dividing by zero.
1454      *
1455      * CAUTION: This function is deprecated because it requires allocating memory for the error
1456      * message unnecessarily. For custom revert reasons use {tryMod}.
1457      *
1458      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1459      * opcode (which leaves remaining gas untouched) while Solidity uses an
1460      * invalid opcode to revert (consuming all remaining gas).
1461      *
1462      * Requirements:
1463      *
1464      * - The divisor cannot be zero.
1465      */
1466     function mod(
1467         uint256 a,
1468         uint256 b,
1469         string memory errorMessage
1470     ) internal pure returns (uint256) {
1471         unchecked {
1472             require(b > 0, errorMessage);
1473             return a % b;
1474         }
1475     }
1476 }
1477 
1478 contract OwnableDelegateProxy { }
1479 contract ProxyRegistry {
1480     mapping(address => OwnableDelegateProxy) public proxies;
1481 }
1482 
1483 //Huevos Club Genesis Contract
1484 
1485 contract HuevosClub is ERC721A, Ownable, ReentrancyGuard  {
1486 
1487     address public constant proxyRegistryAddress = 0xa5409ec958C83C3f309868babACA7c86DCB077c1;
1488 
1489     struct PresaleData {
1490         uint256 price;
1491         bytes32 merkleroot;
1492     }
1493 
1494     using SafeMath for uint256;
1495     using MerkleProof for bytes32[];
1496 
1497     uint256 public saleState;
1498     uint256 public maxSupply;
1499     uint256 public maxMintPerTransaction;
1500     uint256 public price;
1501     uint256 public teamSupply;
1502     string public baseURI;
1503     string public baseExtension;
1504     PresaleData public presaleData;
1505 
1506     modifier whenPublicSaleStarted() {
1507         require(saleState==2,"Public Sale not active");
1508         _;
1509     }
1510 
1511      modifier whenSaleStarted() {
1512         require(saleState > 0,"Sale not active");
1513         _;
1514     }
1515     
1516     modifier whenSaleStopped() {
1517         require(saleState == 0,"Sale already started");
1518         _;
1519     }
1520 
1521     modifier whenWhiteListSaleActive() {
1522         require(saleState == 1, "White list Sale not active");
1523         _;
1524     }
1525 
1526     modifier whenMerklerootSet() {
1527         require(presaleData.merkleroot!=0,"Merkleroot not set for presale");
1528         _;
1529     }
1530 
1531     modifier whenAddressOnWhitelist(bytes32[] memory _merkleproof) {
1532         require(MerkleProof.verify(
1533             _merkleproof,
1534             presaleData.merkleroot,
1535             keccak256(abi.encodePacked(msg.sender))
1536             ),
1537             "Not on white list"
1538         );
1539         _;
1540     }
1541 
1542     constructor() ERC721A("HuevosClub", "HUEVOS") {
1543         
1544         baseURI = "ipfs://QmdVr8LfqASfSaM83FVkymTUQuZarhQ3YiFKKoVJAMbd8P/";
1545         baseExtension = ".json";
1546         price = 0.05 ether;
1547         saleState = 0;
1548         maxSupply = 1111;
1549         teamSupply = 180;
1550         maxMintPerTransaction = 5;
1551         presaleData.price = 0.045 ether;
1552         presaleData.merkleroot = 0x55ec3c6a9f4cbcae5fc2544b56d09805613f9e9095f2c894ffe5b20458bdaa9a;
1553     }
1554 
1555     function reservedTeamMint(uint256 _amount, address _to) external onlyOwner {
1556         require(teamSupply >= _amount, "Exceeds airdrop for team");
1557         teamSupply -= _amount;
1558         _safeMint(_to, _amount);
1559     }
1560 
1561     function isApprovedForAll(address owner, address operator)
1562         override
1563         public
1564         view
1565         returns (bool)
1566     {
1567         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1568         if (address(proxyRegistry.proxies(owner)) == operator) {
1569             return true;
1570         }
1571         return super.isApprovedForAll(owner, operator);
1572     }
1573 
1574     function startPublicSale() external onlyOwner() {
1575         require(saleState != 2, "Sale already started");
1576         saleState = 2;
1577     }
1578 
1579     function startWhitelistSale() external 
1580         whenSaleStopped()
1581         whenMerklerootSet()
1582         onlyOwner() 
1583     {
1584         saleState = 1;
1585     }
1586     
1587     function stopSale() external whenSaleStarted() onlyOwner() {
1588         saleState = 0;
1589     }
1590 
1591     function mintPublic(uint256 _numTokens) external payable whenPublicSaleStarted() {
1592         uint256 supply = totalSupply();
1593         require(_numTokens <= maxMintPerTransaction, "Minting too many Huevo tokens at once!");
1594         require(supply.add(_numTokens) + teamSupply <= maxSupply, "Not enough Huevo Tokens remaining.");
1595         require(_numTokens.mul(price) <= msg.value, "Incorrect amount sent!");
1596         _safeMint(msg.sender, _numTokens);
1597     }
1598 
1599     function mintWhitelist(uint256 _numTokens, bytes32[] calldata _merkleproof) external payable 
1600         whenWhiteListSaleActive()
1601         whenMerklerootSet()
1602         whenAddressOnWhitelist(_merkleproof)
1603     {
1604         uint256 supply = totalSupply();
1605         require(_numTokens <= maxMintPerTransaction, "Minting too many Huevo tokens at once!");
1606         require(supply.add(_numTokens) + teamSupply <= maxSupply, "Not enough Huevo Tokens remaining.");
1607         require(_numTokens.mul(presaleData.price) <= msg.value, "Incorrect amount sent!");
1608         _safeMint(msg.sender, _numTokens);
1609     }
1610 
1611     function setBaseURI(string memory _URI) external onlyOwner {
1612         baseURI = _URI;
1613     }
1614 
1615     function setBaseExtension(string memory _extension) external onlyOwner {
1616         baseExtension = _extension;
1617     }
1618 
1619     function setPrice(uint256 _price) external onlyOwner {
1620         price = _price;
1621     }
1622 
1623     function setMerkleroot(bytes32 _merkleRoot) public 
1624         whenSaleStopped() 
1625         onlyOwner 
1626     {
1627         presaleData.merkleroot = _merkleRoot;
1628     }
1629 
1630     function withdraw() external onlyOwner nonReentrant {
1631         uint256 balance = address(this).balance;
1632         (bool success, ) = _msgSender().call{value: balance}("");
1633         require(success, "Failed to send");
1634     }
1635 
1636     function walletMints(address owner) public view returns(uint256) {
1637        return _numberMinted(owner);
1638     }
1639 
1640     function tokensInWallet(address _owner) public view returns(uint256[] memory) {
1641         uint256 tokenCount = balanceOf(_owner);
1642         uint256[] memory tokensId = new uint256[](tokenCount);
1643         for(uint256 i; i < tokenCount; i++){
1644             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
1645         }
1646         return tokensId;
1647     }
1648 
1649     function tokenURI(uint256 _tokenId) public view override returns (string memory) {
1650         require(_exists(_tokenId), "Token does not exist.");
1651         return bytes(baseURI).length > 0 ? string(
1652             abi.encodePacked(
1653               baseURI,
1654               Strings.toString(_tokenId),
1655               baseExtension
1656             )
1657         ) : "";
1658     }
1659 
1660     function mintableCount() public view returns(uint256) {
1661         uint256 supply = totalSupply();
1662         return maxSupply.sub(supply).sub(teamSupply);
1663     }
1664 
1665     /*
1666     replacement for burn functionality as not in ERC721a, supply is only 
1667     alowed to be reduced 
1668     */
1669     function reduceSupplyEmergency(uint256 _maxSupply) external onlyOwner {
1670         require(_maxSupply < maxSupply);
1671         maxSupply = _maxSupply;
1672     }
1673 }