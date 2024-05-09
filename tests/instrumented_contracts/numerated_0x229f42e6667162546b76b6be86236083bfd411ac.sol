1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev These functions deal with verification of Merkle Trees proofs.
7  *
8  * The proofs can be generated using the JavaScript library
9  * https://github.com/miguelmota/merkletreejs[merkletreejs].
10  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
11  *
12  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
13  */
14 library MerkleProof {
15     /**
16      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
17      * defined by `root`. For this, a `proof` must be provided, containing
18      * sibling hashes on the branch from the leaf to the root of the tree. Each
19      * pair of leaves and each pair of pre-images are assumed to be sorted.
20      */
21     function verify(
22         bytes32[] memory proof,
23         bytes32 root,
24         bytes32 leaf
25     ) internal pure returns (bool) {
26         return processProof(proof, leaf) == root;
27     }
28 
29     /**
30      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
31      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
32      * hash matches the root of the tree. When processing the proof, the pairs
33      * of leafs & pre-images are assumed to be sorted.
34      *
35      * _Available since v4.4._
36      */
37     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
38         bytes32 computedHash = leaf;
39         for (uint256 i = 0; i < proof.length; i++) {
40             bytes32 proofElement = proof[i];
41             if (computedHash <= proofElement) {
42                 // Hash(current computed hash + current element of the proof)
43                 computedHash = _efficientHash(computedHash, proofElement);
44             } else {
45                 // Hash(current element of the proof + current computed hash)
46                 computedHash = _efficientHash(proofElement, computedHash);
47             }
48         }
49         return computedHash;
50     }
51 
52     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
53         assembly {
54             mstore(0x00, a)
55             mstore(0x20, b)
56             value := keccak256(0x00, 0x40)
57         }
58     }
59 }
60 
61 /**
62  * @dev Interface of the ERC165 standard, as defined in the
63  * https://eips.ethereum.org/EIPS/eip-165[EIP].
64  *
65  * Implementers can declare support of contract interfaces, which can then be
66  * queried by others ({ERC165Checker}).
67  *
68  * For an implementation, see {ERC165}.
69  */
70 interface IERC165 {
71     /**
72      * @dev Returns true if this contract implements the interface defined by
73      * `interfaceId`. See the corresponding
74      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
75      * to learn more about how these ids are created.
76      *
77      * This function call must use less than 30 000 gas.
78      */
79     function supportsInterface(bytes4 interfaceId) external view returns (bool);
80 }
81 
82 /**
83  * @dev Required interface of an ERC721 compliant contract.
84  */
85 interface IERC721 is IERC165 {
86     /**
87      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
90 
91     /**
92      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
93      */
94     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
95 
96     /**
97      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
98      */
99     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
100 
101     /**
102      * @dev Returns the number of tokens in ``owner``'s account.
103      */
104     function balanceOf(address owner) external view returns (uint256 balance);
105 
106     /**
107      * @dev Returns the owner of the `tokenId` token.
108      *
109      * Requirements:
110      *
111      * - `tokenId` must exist.
112      */
113     function ownerOf(uint256 tokenId) external view returns (address owner);
114 
115     /**
116      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
117      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
118      *
119      * Requirements:
120      *
121      * - `from` cannot be the zero address.
122      * - `to` cannot be the zero address.
123      * - `tokenId` token must exist and be owned by `from`.
124      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
125      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
126      *
127      * Emits a {Transfer} event.
128      */
129     function safeTransferFrom(
130         address from,
131         address to,
132         uint256 tokenId
133     ) external;
134 
135     /**
136      * @dev Transfers `tokenId` token from `from` to `to`.
137      *
138      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
139      *
140      * Requirements:
141      *
142      * - `from` cannot be the zero address.
143      * - `to` cannot be the zero address.
144      * - `tokenId` token must be owned by `from`.
145      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
146      *
147      * Emits a {Transfer} event.
148      */
149     function transferFrom(
150         address from,
151         address to,
152         uint256 tokenId
153     ) external;
154 
155     /**
156      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
157      * The approval is cleared when the token is transferred.
158      *
159      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
160      *
161      * Requirements:
162      *
163      * - The caller must own the token or be an approved operator.
164      * - `tokenId` must exist.
165      *
166      * Emits an {Approval} event.
167      */
168     function approve(address to, uint256 tokenId) external;
169 
170     /**
171      * @dev Returns the account approved for `tokenId` token.
172      *
173      * Requirements:
174      *
175      * - `tokenId` must exist.
176      */
177     function getApproved(uint256 tokenId) external view returns (address operator);
178 
179     /**
180      * @dev Approve or remove `operator` as an operator for the caller.
181      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
182      *
183      * Requirements:
184      *
185      * - The `operator` cannot be the caller.
186      *
187      * Emits an {ApprovalForAll} event.
188      */
189     function setApprovalForAll(address operator, bool _approved) external;
190 
191     /**
192      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
193      *
194      * See {setApprovalForAll}
195      */
196     function isApprovedForAll(address owner, address operator) external view returns (bool);
197 
198     /**
199      * @dev Safely transfers `tokenId` token from `from` to `to`.
200      *
201      * Requirements:
202      *
203      * - `from` cannot be the zero address.
204      * - `to` cannot be the zero address.
205      * - `tokenId` token must exist and be owned by `from`.
206      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
207      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
208      *
209      * Emits a {Transfer} event.
210      */
211     function safeTransferFrom(
212         address from,
213         address to,
214         uint256 tokenId,
215         bytes calldata data
216     ) external;
217 }
218 
219 /**
220  * @title ERC721 token receiver interface
221  * @dev Interface for any contract that wants to support safeTransfers
222  * from ERC721 asset contracts.
223  */
224 interface IERC721Receiver {
225     /**
226      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
227      * by `operator` from `from`, this function is called.
228      *
229      * It must return its Solidity selector to confirm the token transfer.
230      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
231      *
232      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
233      */
234     function onERC721Received(
235         address operator,
236         address from,
237         uint256 tokenId,
238         bytes calldata data
239     ) external returns (bytes4);
240 }
241 
242 /**
243  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
244  * @dev See https://eips.ethereum.org/EIPS/eip-721
245  */
246 interface IERC721Metadata is IERC721 {
247     /**
248      * @dev Returns the token collection name.
249      */
250     function name() external view returns (string memory);
251 
252     /**
253      * @dev Returns the token collection symbol.
254      */
255     function symbol() external view returns (string memory);
256 
257     /**
258      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
259      */
260     function tokenURI(uint256 tokenId) external view returns (string memory);
261 }
262 
263 /**
264  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
265  * @dev See https://eips.ethereum.org/EIPS/eip-721
266  */
267 interface IERC721Enumerable is IERC721 {
268     /**
269      * @dev Returns the total amount of tokens stored by the contract.
270      */
271     function totalSupply() external view returns (uint256);
272 
273     /**
274      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
275      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
276      */
277     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
278 
279     /**
280      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
281      * Use along with {totalSupply} to enumerate all tokens.
282      */
283     function tokenByIndex(uint256 index) external view returns (uint256);
284 }
285 
286 /**
287  * @dev Collection of functions related to the address type
288  */
289 library Address {
290     /**
291      * @dev Returns true if `account` is a contract.
292      *
293      * [IMPORTANT]
294      * ====
295      * It is unsafe to assume that an address for which this function returns
296      * false is an externally-owned account (EOA) and not a contract.
297      *
298      * Among others, `isContract` will return false for the following
299      * types of addresses:
300      *
301      *  - an externally-owned account
302      *  - a contract in construction
303      *  - an address where a contract will be created
304      *  - an address where a contract lived, but was destroyed
305      * ====
306      *
307      * [IMPORTANT]
308      * ====
309      * You shouldn't rely on `isContract` to protect against flash loan attacks!
310      *
311      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
312      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
313      * constructor.
314      * ====
315      */
316     function isContract(address account) internal view returns (bool) {
317         // This method relies on extcodesize/address.code.length, which returns 0
318         // for contracts in construction, since the code is only stored at the end
319         // of the constructor execution.
320 
321         return account.code.length > 0;
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(address(this).balance >= amount, "Address: insufficient balance");
342 
343         (bool success, ) = recipient.call{value: amount}("");
344         require(success, "Address: unable to send value, recipient may have reverted");
345     }
346 
347     /**
348      * @dev Performs a Solidity function call using a low level `call`. A
349      * plain `call` is an unsafe replacement for a function call: use this
350      * function instead.
351      *
352      * If `target` reverts with a revert reason, it is bubbled up by this
353      * function (like regular Solidity function calls).
354      *
355      * Returns the raw returned data. To convert to the expected return value,
356      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
357      *
358      * Requirements:
359      *
360      * - `target` must be a contract.
361      * - calling `target` with `data` must not revert.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
366         return functionCall(target, data, "Address: low-level call failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
371      * `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCall(
376         address target,
377         bytes memory data,
378         string memory errorMessage
379     ) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, 0, errorMessage);
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
385      * but also transferring `value` wei to `target`.
386      *
387      * Requirements:
388      *
389      * - the calling contract must have an ETH balance of at least `value`.
390      * - the called Solidity function must be `payable`.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(
395         address target,
396         bytes memory data,
397         uint256 value
398     ) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
400     }
401 
402     /**
403      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404      * with `errorMessage` as a fallback revert reason when `target` reverts.
405      *
406      * _Available since v3.1._
407      */
408     function functionCallWithValue(
409         address target,
410         bytes memory data,
411         uint256 value,
412         string memory errorMessage
413     ) internal returns (bytes memory) {
414         require(address(this).balance >= value, "Address: insufficient balance for call");
415         require(isContract(target), "Address: call to non-contract");
416 
417         (bool success, bytes memory returndata) = target.call{value: value}(data);
418         return verifyCallResult(success, returndata, errorMessage);
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
423      * but performing a static call.
424      *
425      * _Available since v3.3._
426      */
427     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
428         return functionStaticCall(target, data, "Address: low-level static call failed");
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
433      * but performing a static call.
434      *
435      * _Available since v3.3._
436      */
437     function functionStaticCall(
438         address target,
439         bytes memory data,
440         string memory errorMessage
441     ) internal view returns (bytes memory) {
442         require(isContract(target), "Address: static call to non-contract");
443 
444         (bool success, bytes memory returndata) = target.staticcall(data);
445         return verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but performing a delegate call.
451      *
452      * _Available since v3.4._
453      */
454     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
455         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a delegate call.
461      *
462      * _Available since v3.4._
463      */
464     function functionDelegateCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal returns (bytes memory) {
469         require(isContract(target), "Address: delegate call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.delegatecall(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
477      * revert reason using the provided one.
478      *
479      * _Available since v4.3._
480      */
481     function verifyCallResult(
482         bool success,
483         bytes memory returndata,
484         string memory errorMessage
485     ) internal pure returns (bytes memory) {
486         if (success) {
487             return returndata;
488         } else {
489             // Look for revert reason and bubble it up if present
490             if (returndata.length > 0) {
491                 // The easiest way to bubble the revert reason is using memory via assembly
492 
493                 assembly {
494                     let returndata_size := mload(returndata)
495                     revert(add(32, returndata), returndata_size)
496                 }
497             } else {
498                 revert(errorMessage);
499             }
500         }
501     }
502 }
503 
504 /**
505  * @dev Provides information about the current execution context, including the
506  * sender of the transaction and its data. While these are generally available
507  * via msg.sender and msg.data, they should not be accessed in such a direct
508  * manner, since when dealing with meta-transactions the account sending and
509  * paying for execution may not be the actual sender (as far as an application
510  * is concerned).
511  *
512  * This contract is only required for intermediate, library-like contracts.
513  */
514 abstract contract Context {
515     function _msgSender() internal view virtual returns (address) {
516         return msg.sender;
517     }
518 
519     function _msgData() internal view virtual returns (bytes calldata) {
520         return msg.data;
521     }
522 }
523 
524 /**
525  * @dev String operations.
526  */
527 library Strings {
528     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
532      */
533     function toString(uint256 value) internal pure returns (string memory) {
534         // Inspired by OraclizeAPI's implementation - MIT licence
535         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
536 
537         if (value == 0) {
538             return "0";
539         }
540         uint256 temp = value;
541         uint256 digits;
542         while (temp != 0) {
543             digits++;
544             temp /= 10;
545         }
546         bytes memory buffer = new bytes(digits);
547         while (value != 0) {
548             digits -= 1;
549             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
550             value /= 10;
551         }
552         return string(buffer);
553     }
554 
555     /**
556      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
557      */
558     function toHexString(uint256 value) internal pure returns (string memory) {
559         if (value == 0) {
560             return "0x00";
561         }
562         uint256 temp = value;
563         uint256 length = 0;
564         while (temp != 0) {
565             length++;
566             temp >>= 8;
567         }
568         return toHexString(value, length);
569     }
570 
571     /**
572      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
573      */
574     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
575         bytes memory buffer = new bytes(2 * length + 2);
576         buffer[0] = "0";
577         buffer[1] = "x";
578         for (uint256 i = 2 * length + 1; i > 1; --i) {
579             buffer[i] = _HEX_SYMBOLS[value & 0xf];
580             value >>= 4;
581         }
582         require(value == 0, "Strings: hex length insufficient");
583         return string(buffer);
584     }
585 }
586 
587 /**
588  * @dev Implementation of the {IERC165} interface.
589  *
590  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
591  * for the additional interface id that will be supported. For example:
592  *
593  * ```solidity
594  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
595  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
596  * }
597  * ```
598  *
599  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
600  */
601 abstract contract ERC165 is IERC165 {
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606         return interfaceId == type(IERC165).interfaceId;
607     }
608 }
609 
610 /**
611  * @dev Contract module which provides a basic access control mechanism, where
612  * there is an account (an owner) that can be granted exclusive access to
613  * specific functions.
614  *
615  * By default, the owner account will be the one that deploys the contract. This
616  * can later be changed with {transferOwnership}.
617  *
618  * This module is used through inheritance. It will make available the modifier
619  * `onlyOwner`, which can be applied to your functions to restrict their use to
620  * the owner.
621  */
622 abstract contract Ownable is Context {
623     address private _owner;
624 
625     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
626 
627     /**
628      * @dev Initializes the contract setting the deployer as the initial owner.
629      */
630     constructor() {
631         _transferOwnership(_msgSender());
632     }
633 
634     /**
635      * @dev Returns the address of the current owner.
636      */
637     function owner() public view virtual returns (address) {
638         return _owner;
639     }
640 
641     /**
642      * @dev Throws if called by any account other than the owner.
643      */
644     modifier onlyOwner() {
645         require(owner() == _msgSender(), "Ownable: caller is not the owner");
646         _;
647     }
648 
649     /**
650      * @dev Leaves the contract without owner. It will not be possible to call
651      * `onlyOwner` functions anymore. Can only be called by the current owner.
652      *
653      * NOTE: Renouncing ownership will leave the contract without an owner,
654      * thereby removing any functionality that is only available to the owner.
655      */
656     function renounceOwnership() public virtual onlyOwner {
657         _transferOwnership(address(0));
658     }
659 
660     /**
661      * @dev Transfers ownership of the contract to a new account (`newOwner`).
662      * Can only be called by the current owner.
663      */
664     function transferOwnership(address newOwner) public virtual onlyOwner {
665         require(newOwner != address(0), "Ownable: new owner is the zero address");
666         _transferOwnership(newOwner);
667     }
668 
669     /**
670      * @dev Transfers ownership of the contract to a new account (`newOwner`).
671      * Internal function without access restriction.
672      */
673     function _transferOwnership(address newOwner) internal virtual {
674         address oldOwner = _owner;
675         _owner = newOwner;
676         emit OwnershipTransferred(oldOwner, newOwner);
677     }
678 }
679 
680 /**
681  * @dev Contract module that helps prevent reentrant calls to a function.
682  *
683  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
684  * available, which can be applied to functions to make sure there are no nested
685  * (reentrant) calls to them.
686  *
687  * Note that because there is a single `nonReentrant` guard, functions marked as
688  * `nonReentrant` may not call one another. This can be worked around by making
689  * those functions `private`, and then adding `external` `nonReentrant` entry
690  * points to them.
691  *
692  * TIP: If you would like to learn more about reentrancy and alternative ways
693  * to protect against it, check out our blog post
694  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
695  */
696 abstract contract ReentrancyGuard {
697     // Booleans are more expensive than uint256 or any type that takes up a full
698     // word because each write operation emits an extra SLOAD to first read the
699     // slot's contents, replace the bits taken up by the boolean, and then write
700     // back. This is the compiler's defense against contract upgrades and
701     // pointer aliasing, and it cannot be disabled.
702 
703     // The values being non-zero value makes deployment a bit more expensive,
704     // but in exchange the refund on every call to nonReentrant will be lower in
705     // amount. Since refunds are capped to a percentage of the total
706     // transaction's gas, it is best to keep them low in cases like this one, to
707     // increase the likelihood of the full refund coming into effect.
708     uint256 private constant _NOT_ENTERED = 1;
709     uint256 private constant _ENTERED = 2;
710 
711     uint256 private _status;
712 
713     constructor() {
714         _status = _NOT_ENTERED;
715     }
716 
717     /**
718      * @dev Prevents a contract from calling itself, directly or indirectly.
719      * Calling a `nonReentrant` function from another `nonReentrant`
720      * function is not supported. It is possible to prevent this from happening
721      * by making the `nonReentrant` function external, and making it call a
722      * `private` function that does the actual work.
723      */
724     modifier nonReentrant() {
725         // On the first call to nonReentrant, _notEntered will be true
726         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
727 
728         // Any calls to nonReentrant after this point will fail
729         _status = _ENTERED;
730 
731         _;
732 
733         // By storing the original value once again, a refund is triggered (see
734         // https://eips.ethereum.org/EIPS/eip-2200)
735         _status = _NOT_ENTERED;
736     }
737 }
738 
739 /**
740  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
741  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
742  *
743  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
744  *
745  * Does not support burning tokens to address(0).
746  *
747  * Assumes that an owner cannot have more than the 2**128 - 1 (max value of uint128) of supply
748  */
749 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
750     using Address for address;
751     using Strings for uint256;
752 
753     struct TokenOwnership {
754         address addr;
755         uint64 startTimestamp;
756     }
757 
758     struct AddressData {
759         uint128 balance;
760         uint128 numberMinted;
761     }
762 
763     uint256 internal currentIndex;
764 
765     // Token name
766     string private _name;
767 
768     // Token symbol
769     string private _symbol;
770 
771     // Mapping from token ID to ownership details
772     // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
773     mapping(uint256 => TokenOwnership) internal _ownerships;
774 
775     // Mapping owner address to address data
776     mapping(address => AddressData) private _addressData;
777 
778     // Mapping from token ID to approved address
779     mapping(uint256 => address) private _tokenApprovals;
780 
781     // Mapping from owner to operator approvals
782     mapping(address => mapping(address => bool)) private _operatorApprovals;
783 
784     constructor(string memory name_, string memory symbol_) {
785         _name = name_;
786         _symbol = symbol_;
787     }
788 
789     /**
790      * @dev See {IERC721Enumerable-totalSupply}.
791      */
792     function totalSupply() public view override returns (uint256) {
793         return currentIndex;
794     }
795 
796     /**
797      * @dev See {IERC721Enumerable-tokenByIndex}.
798      */
799     function tokenByIndex(uint256 index) public view override returns (uint256) {
800         require(index < totalSupply(), 'ERC721A: global index out of bounds');
801         return index;
802     }
803 
804     /**
805      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
806      * This read function is O(totalSupply). If calling from a separate contract, be sure to test gas first.
807      * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
808      */
809     function tokenOfOwnerByIndex(address owner, uint256 index) public view override returns (uint256) {
810         require(index < balanceOf(owner), 'ERC721A: owner index out of bounds');
811         uint256 numMintedSoFar = totalSupply();
812         uint256 tokenIdsIdx;
813         address currOwnershipAddr;
814 
815         // Counter overflow is impossible as the loop breaks when uint256 i is equal to another uint256 numMintedSoFar.
816         unchecked {
817             for (uint256 i; i < numMintedSoFar; i++) {
818                 TokenOwnership memory ownership = _ownerships[i];
819                 if (ownership.addr != address(0)) {
820                     currOwnershipAddr = ownership.addr;
821                 }
822                 if (currOwnershipAddr == owner) {
823                     if (tokenIdsIdx == index) {
824                         return i;
825                     }
826                     tokenIdsIdx++;
827                 }
828             }
829         }
830 
831         revert('ERC721A: unable to get token of owner by index');
832     }
833 
834     /**
835      * @dev See {IERC165-supportsInterface}.
836      */
837     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
838         return
839             interfaceId == type(IERC721).interfaceId ||
840             interfaceId == type(IERC721Metadata).interfaceId ||
841             interfaceId == type(IERC721Enumerable).interfaceId ||
842             super.supportsInterface(interfaceId);
843     }
844 
845     /**
846      * @dev See {IERC721-balanceOf}.
847      */
848     function balanceOf(address owner) public view override returns (uint256) {
849         require(owner != address(0), 'ERC721A: balance query for the zero address');
850         return uint256(_addressData[owner].balance);
851     }
852 
853     function _numberMinted(address owner) internal view returns (uint256) {
854         require(owner != address(0), 'ERC721A: number minted query for the zero address');
855         return uint256(_addressData[owner].numberMinted);
856     }
857 
858     /**
859      * Gas spent here starts off proportional to the maximum mint batch size.
860      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
861      */
862     function ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
863         require(_exists(tokenId), 'ERC721A: owner query for nonexistent token');
864 
865         unchecked {
866             for (uint256 curr = tokenId; curr >= 0; curr--) {
867                 TokenOwnership memory ownership = _ownerships[curr];
868                 if (ownership.addr != address(0)) {
869                     return ownership;
870                 }
871             }
872         }
873 
874         revert('ERC721A: unable to determine the owner of token');
875     }
876 
877     /**
878      * @dev See {IERC721-ownerOf}.
879      */
880     function ownerOf(uint256 tokenId) public view override returns (address) {
881         return ownershipOf(tokenId).addr;
882     }
883 
884     /**
885      * @dev See {IERC721Metadata-name}.
886      */
887     function name() public view virtual override returns (string memory) {
888         return _name;
889     }
890 
891     /**
892      * @dev See {IERC721Metadata-symbol}.
893      */
894     function symbol() public view virtual override returns (string memory) {
895         return _symbol;
896     }
897 
898     /**
899      * @dev See {IERC721Metadata-tokenURI}.
900      */
901     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
902         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
903 
904         string memory baseURI = _baseURI();
905         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
906     }
907 
908     /**
909      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
910      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
911      * by default, can be overriden in child contracts.
912      */
913     function _baseURI() internal view virtual returns (string memory) {
914         return '';
915     }
916 
917     /**
918      * @dev See {IERC721-approve}.
919      */
920     function approve(address to, uint256 tokenId) public override {
921         address owner = ERC721A.ownerOf(tokenId);
922         require(to != owner, 'ERC721A: approval to current owner');
923 
924         require(
925             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
926             'ERC721A: approve caller is not owner nor approved for all'
927         );
928 
929         _approve(to, tokenId, owner);
930     }
931 
932     /**
933      * @dev See {IERC721-getApproved}.
934      */
935     function getApproved(uint256 tokenId) public view override returns (address) {
936         require(_exists(tokenId), 'ERC721A: approved query for nonexistent token');
937 
938         return _tokenApprovals[tokenId];
939     }
940 
941     /**
942      * @dev See {IERC721-setApprovalForAll}.
943      */
944     function setApprovalForAll(address operator, bool approved) public override {
945         require(operator != _msgSender(), 'ERC721A: approve to caller');
946 
947         _operatorApprovals[_msgSender()][operator] = approved;
948         emit ApprovalForAll(_msgSender(), operator, approved);
949     }
950 
951     /**
952      * @dev See {IERC721-isApprovedForAll}.
953      */
954     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
955         return _operatorApprovals[owner][operator];
956     }
957 
958     /**
959      * @dev See {IERC721-transferFrom}.
960      */
961     function transferFrom(
962         address from,
963         address to,
964         uint256 tokenId
965     ) public virtual override {
966         _transfer(from, to, tokenId);
967     }
968 
969     /**
970      * @dev See {IERC721-safeTransferFrom}.
971      */
972     function safeTransferFrom(
973         address from,
974         address to,
975         uint256 tokenId
976     ) public virtual override {
977         safeTransferFrom(from, to, tokenId, '');
978     }
979 
980     /**
981      * @dev See {IERC721-safeTransferFrom}.
982      */
983     function safeTransferFrom(
984         address from,
985         address to,
986         uint256 tokenId,
987         bytes memory _data
988     ) public virtual override {
989         _transfer(from, to, tokenId);
990         require(
991             _checkOnERC721Received(from, to, tokenId, _data),
992             'ERC721A: transfer to non ERC721Receiver implementer'
993         );
994     }
995 
996     /**
997      * @dev Returns whether `tokenId` exists.
998      *
999      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1000      *
1001      * Tokens start existing when they are minted (`_mint`),
1002      */
1003     function _exists(uint256 tokenId) internal view returns (bool) {
1004         return tokenId < currentIndex;
1005     }
1006 
1007     function _safeMint(address to, uint256 quantity) internal {
1008         _safeMint(to, quantity, '');
1009     }
1010 
1011     /**
1012      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1013      *
1014      * Requirements:
1015      *
1016      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1017      * - `quantity` must be greater than 0.
1018      *
1019      * Emits a {Transfer} event.
1020      */
1021     function _safeMint(
1022         address to,
1023         uint256 quantity,
1024         bytes memory _data
1025     ) internal {
1026         _mint(to, quantity, _data, true);
1027     }
1028 
1029     /**
1030      * @dev Mints `quantity` tokens and transfers them to `to`.
1031      *
1032      * Requirements:
1033      *
1034      * - `to` cannot be the zero address.
1035      * - `quantity` must be greater than 0.
1036      *
1037      * Emits a {Transfer} event.
1038      */
1039     function _mint(
1040         address to,
1041         uint256 quantity,
1042         bytes memory _data,
1043         bool safe
1044     ) internal {
1045         uint256 startTokenId = currentIndex;
1046         require(to != address(0), 'ERC721A: mint to the zero address');
1047         require(quantity != 0, 'ERC721A: quantity must be greater than 0');
1048 
1049         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1050 
1051         // Overflows are incredibly unrealistic.
1052         // balance or numberMinted overflow if current value of either + quantity > 3.4e38 (2**128) - 1
1053         // updatedIndex overflows if currentIndex + quantity > 1.56e77 (2**256) - 1
1054         unchecked {
1055             _addressData[to].balance += uint128(quantity);
1056             _addressData[to].numberMinted += uint128(quantity);
1057 
1058             _ownerships[startTokenId].addr = to;
1059             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1060 
1061             uint256 updatedIndex = startTokenId;
1062 
1063             for (uint256 i; i < quantity; i++) {
1064                 emit Transfer(address(0), to, updatedIndex);
1065                 if (safe) {
1066                     require(
1067                         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1068                         'ERC721A: transfer to non ERC721Receiver implementer'
1069                     );
1070                 }
1071 
1072                 updatedIndex++;
1073             }
1074 
1075             currentIndex = updatedIndex;
1076         }
1077 
1078         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1079     }
1080 
1081     /**
1082      * @dev Transfers `tokenId` from `from` to `to`.
1083      *
1084      * Requirements:
1085      *
1086      * - `to` cannot be the zero address.
1087      * - `tokenId` token must be owned by `from`.
1088      *
1089      * Emits a {Transfer} event.
1090      */
1091     function _transfer(
1092         address from,
1093         address to,
1094         uint256 tokenId
1095     ) private {
1096         TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1097 
1098         bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1099             getApproved(tokenId) == _msgSender() ||
1100             isApprovedForAll(prevOwnership.addr, _msgSender()));
1101 
1102         require(isApprovedOrOwner, 'ERC721A: transfer caller is not owner nor approved');
1103 
1104         require(prevOwnership.addr == from, 'ERC721A: transfer from incorrect owner');
1105         require(to != address(0), 'ERC721A: transfer to the zero address');
1106 
1107         _beforeTokenTransfers(from, to, tokenId, 1);
1108 
1109         // Clear approvals from the previous owner
1110         _approve(address(0), tokenId, prevOwnership.addr);
1111 
1112         // Underflow of the sender's balance is impossible because we check for
1113         // ownership above and the recipient's balance can't realistically overflow.
1114         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1115         unchecked {
1116             _addressData[from].balance -= 1;
1117             _addressData[to].balance += 1;
1118 
1119             _ownerships[tokenId].addr = to;
1120             _ownerships[tokenId].startTimestamp = uint64(block.timestamp);
1121 
1122             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1123             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1124             uint256 nextTokenId = tokenId + 1;
1125             if (_ownerships[nextTokenId].addr == address(0)) {
1126                 if (_exists(nextTokenId)) {
1127                     _ownerships[nextTokenId].addr = prevOwnership.addr;
1128                     _ownerships[nextTokenId].startTimestamp = prevOwnership.startTimestamp;
1129                 }
1130             }
1131         }
1132 
1133         emit Transfer(from, to, tokenId);
1134         _afterTokenTransfers(from, to, tokenId, 1);
1135     }
1136 
1137     /**
1138      * @dev Approve `to` to operate on `tokenId`
1139      *
1140      * Emits a {Approval} event.
1141      */
1142     function _approve(
1143         address to,
1144         uint256 tokenId,
1145         address owner
1146     ) private {
1147         _tokenApprovals[tokenId] = to;
1148         emit Approval(owner, to, tokenId);
1149     }
1150 
1151     /**
1152      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1153      * The call is not executed if the target address is not a contract.
1154      *
1155      * @param from address representing the previous owner of the given token ID
1156      * @param to target address that will receive the tokens
1157      * @param tokenId uint256 ID of the token to be transferred
1158      * @param _data bytes optional data to send along with the call
1159      * @return bool whether the call correctly returned the expected magic value
1160      */
1161     function _checkOnERC721Received(
1162         address from,
1163         address to,
1164         uint256 tokenId,
1165         bytes memory _data
1166     ) private returns (bool) {
1167         if (to.isContract()) {
1168             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1169                 return retval == IERC721Receiver(to).onERC721Received.selector;
1170             } catch (bytes memory reason) {
1171                 if (reason.length == 0) {
1172                     revert('ERC721A: transfer to non ERC721Receiver implementer');
1173                 } else {
1174                     assembly {
1175                         revert(add(32, reason), mload(reason))
1176                     }
1177                 }
1178             }
1179         } else {
1180             return true;
1181         }
1182     }
1183 
1184     /**
1185      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1186      *
1187      * startTokenId - the first token id to be transferred
1188      * quantity - the amount to be transferred
1189      *
1190      * Calling conditions:
1191      *
1192      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1193      * transferred to `to`.
1194      * - When `from` is zero, `tokenId` will be minted for `to`.
1195      */
1196     function _beforeTokenTransfers(
1197         address from,
1198         address to,
1199         uint256 startTokenId,
1200         uint256 quantity
1201     ) internal virtual {}
1202 
1203     /**
1204      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1205      * minting.
1206      *
1207      * startTokenId - the first token id to be transferred
1208      * quantity - the amount to be transferred
1209      *
1210      * Calling conditions:
1211      *
1212      * - when `from` and `to` are both non-zero.
1213      * - `from` and `to` are never both zero.
1214      */
1215     function _afterTokenTransfers(
1216         address from,
1217         address to,
1218         uint256 startTokenId,
1219         uint256 quantity
1220     ) internal virtual {}
1221 }
1222 
1223 //OperatorFilter
1224 interface IOperatorFilterRegistry {
1225     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1226     function register(address registrant) external;
1227     function registerAndSubscribe(address registrant, address subscription) external;
1228     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1229     function updateOperator(address registrant, address operator, bool filtered) external;
1230     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1231     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1232     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1233     function subscribe(address registrant, address registrantToSubscribe) external;
1234     function unsubscribe(address registrant, bool copyExistingEntries) external;
1235     function subscriptionOf(address addr) external returns (address registrant);
1236     function subscribers(address registrant) external returns (address[] memory);
1237     function subscriberAt(address registrant, uint256 index) external returns (address);
1238     function copyEntriesOf(address registrant, address registrantToCopy) external;
1239     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1240     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1241     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1242     function filteredOperators(address addr) external returns (address[] memory);
1243     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1244     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1245     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1246     function isRegistered(address addr) external returns (bool);
1247     function codeHashOf(address addr) external returns (bytes32);
1248 }
1249 
1250 abstract contract OperatorFilterer721 { 
1251     error OperatorNotAllowed(address operator);
1252 
1253     IOperatorFilterRegistry constant operatorFilterRegistry =
1254         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1255 
1256     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1257         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1258         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1259         // order for the modifier to filter addresses.
1260         if (address(operatorFilterRegistry).code.length > 0) {
1261             if (subscribe) {
1262                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1263             } else {
1264                 if (subscriptionOrRegistrantToCopy != address(0)) {
1265                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1266                 } else {
1267                     operatorFilterRegistry.register(address(this));
1268                 }
1269             }
1270         }
1271     }
1272 
1273     modifier onlyAllowedOperator(address from) virtual {
1274         // Check registry code length to facilitate testing in environments without a deployed registry.
1275         if (address(operatorFilterRegistry).code.length > 0) {
1276             // Allow spending tokens from addresses with balance
1277             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1278             // from an EOA.
1279             if (from == msg.sender) {
1280                 _;
1281                 return;
1282             }
1283             if (
1284                 !(
1285                     operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)
1286                         && operatorFilterRegistry.isOperatorAllowed(address(this), from)
1287                 )
1288             ) {
1289                 revert OperatorNotAllowed(msg.sender);
1290             }
1291         }
1292         _;
1293     }
1294 }
1295 
1296 abstract contract DefaultOperatorFilterer721 is OperatorFilterer721 {
1297     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1298 
1299     constructor() OperatorFilterer721(DEFAULT_SUBSCRIPTION, true) {}
1300 }
1301 
1302 interface IRegularTicket {
1303     function transfer(address _recipient, uint256 _amount) external returns (bool);
1304     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1305     function balanceOf(address account) external view returns (uint256);
1306     function totalSupply() external view returns (uint256);
1307 }
1308 
1309 interface IPlatiumTicket {
1310     function transfer(address _recipient, uint256 _amount) external returns (bool);
1311     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
1312     function balanceOf(address account) external view returns (uint256);
1313     function totalSupply() external view returns (uint256);
1314 }
1315 
1316 contract Nonkiverse is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer721 {
1317     using Strings for uint256;
1318 
1319     uint256 public MAX_SUPPLY = 5555;
1320     uint256 public MAX_WHITELIST_MINTS = 2;
1321     uint256 public MAX_ALLOWLIST_MINTS = 2;
1322     uint256 public MAX_PUBLIC_MINTS = 10;
1323     uint256 public MAX_SPECIAL_MINTS = 10;
1324 
1325     
1326     uint256 public TICKET_PORTAL_LIMIT = 1111;
1327     
1328     uint256 public WHITELIST_PRICE = 0.04 ether;
1329     uint256 public ALLOWLIST_PRICE = 0.06 ether;
1330     uint256 public PUBLIC_PRICE = 0.08 ether;
1331 
1332     bool public whitelistStart;
1333     bool public allowlistStart;
1334     bool public publicSaleStart;
1335     bool public ticketMintStart;
1336     bool public specialMintStart;
1337 
1338     address public SPECIAL_MINT_CONTRACT;
1339     
1340     bool public revealed = false;
1341     string public notRevealedUri;
1342 
1343     bytes32 public whitelistMerkleRoot;
1344     bytes32 public allowlistMerkleRoot;
1345 
1346     mapping(address => uint256) private _whitelisted;
1347     mapping(address => uint256) private _allowed;
1348 
1349     string private _baseURIextended;
1350 
1351     IRegularTicket public regularTicket;
1352     IPlatiumTicket public platiumTicket;
1353 
1354     address public ticketPoolAddress;
1355 
1356     constructor() ERC721A("Nonkiverse", "NV") {
1357         whitelistStart = false;
1358         allowlistStart = false;
1359         publicSaleStart = false;
1360         ticketMintStart = false;
1361     }
1362 
1363     modifier isValidMerkleProof(bytes32[] memory merkleProof, bytes32 root) {
1364         require(MerkleProof.verify(merkleProof, root, keccak256(abi.encodePacked(msg.sender))), "Address does not exist in list");
1365         _;
1366     }
1367 
1368     function whitelistMint(bytes32[] calldata _proof, uint256 nMints) external payable isValidMerkleProof(_proof, whitelistMerkleRoot) nonReentrant {
1369         require(msg.sender == tx.origin, "Can't mint through another contract");
1370         require(whitelistStart, "Whitelist Mint not active");
1371         require(nMints <= MAX_WHITELIST_MINTS, "Exceeds max token purchase");
1372         require(totalSupply() + nMints <= MAX_SUPPLY - TICKET_PORTAL_LIMIT, "Mint exceeds total supply");
1373         require(WHITELIST_PRICE * nMints <= msg.value, "Sent incorrect ETH value");
1374         require(_whitelisted[msg.sender] + nMints <= MAX_WHITELIST_MINTS, "Exceeds whitelist mint limit");
1375 
1376         // Keep track of mints for each address
1377         if (_whitelisted[msg.sender] > 0) {
1378             _whitelisted[msg.sender] = _whitelisted[msg.sender] + nMints;
1379         } else {
1380             _whitelisted[msg.sender] = nMints;
1381         }
1382 
1383         _safeMint(msg.sender, nMints);
1384     }
1385 
1386     function allowlistMint(bytes32[] calldata _proof, uint256 nMints) external payable isValidMerkleProof(_proof, allowlistMerkleRoot) nonReentrant {
1387         require(msg.sender == tx.origin, "Can't mint through another contract");
1388         require(allowlistStart, "Allowlist Mint not active");
1389         require(nMints <= MAX_ALLOWLIST_MINTS, "Exceeds max token purchase");
1390         require(totalSupply() + nMints <= MAX_SUPPLY - TICKET_PORTAL_LIMIT, "Mint exceeds total supply");
1391         require(ALLOWLIST_PRICE * nMints <= msg.value, "Sent incorrect ETH value");
1392         require(_allowed[msg.sender] + nMints <= MAX_ALLOWLIST_MINTS, "Exceeds allowlist mint limit");
1393 
1394         // Keep track of mints for each address
1395         if (_allowed[msg.sender] > 0) {
1396             _allowed[msg.sender] = _allowed[msg.sender] + nMints;
1397         } else {
1398             _allowed[msg.sender] = nMints;
1399         }
1400 
1401         _safeMint(msg.sender, nMints);
1402     }
1403 
1404     function publicMint(uint256 nMints) external payable nonReentrant {
1405         require(totalSupply() + nMints <= MAX_SUPPLY - TICKET_PORTAL_LIMIT, "Mint exceeds total supply");
1406         require(nMints <= MAX_PUBLIC_MINTS, "Exceeds max token purchase");
1407         require(publicSaleStart, "Public sale not active");
1408         require(PUBLIC_PRICE * nMints <= msg.value, "Sent incorrect ETH value");
1409 
1410         _safeMint(msg.sender, nMints);
1411     }
1412 
1413     function ticketMint(uint256 nRegularTickets, uint256 nPlatiumTickets) external nonReentrant{
1414         uint256 nMints = nRegularTickets + nPlatiumTickets;
1415         require(totalSupply() + nMints <= MAX_SUPPLY, "Mint exceeds total supply");
1416         require(ticketMintStart, "Ticket mint not active");
1417         require(nRegularTickets > 0 || nPlatiumTickets > 0, "Can't mint with no tickets");
1418         
1419         if(nRegularTickets > 0) regularTicket.transferFrom(msg.sender, ticketPoolAddress, nRegularTickets);
1420         if(nPlatiumTickets > 0) platiumTicket.transferFrom(msg.sender, ticketPoolAddress, nPlatiumTickets);
1421 
1422         _safeMint(msg.sender, nMints);
1423     }
1424 
1425     function specialMint(uint256 nMints, address _to) external nonReentrant {
1426         require(totalSupply() + nMints <= MAX_SUPPLY, "Mint exceeds total supply");
1427         require(nMints <= MAX_SPECIAL_MINTS, "Exceeds max token purchase");
1428         require(specialMintStart, "Special mint not active");
1429         require(SPECIAL_MINT_CONTRACT == msg.sender, "Can't mint with that address");
1430 
1431         _safeMint(_to, nMints);
1432     }
1433 
1434     function mintForOwner(uint256 nMints) external payable nonReentrant onlyOwner {
1435         require(msg.sender == tx.origin, "Can't mint through another contract");
1436         require(nMints <= MAX_WHITELIST_MINTS, "Exceeds max token purchase");
1437         require(totalSupply() + nMints <= MAX_SUPPLY, "Mint exceeds total supply");
1438 
1439         _safeMint(msg.sender, nMints);
1440     }
1441 
1442     function reserveMint(uint256 nMints, uint256 batchSize, address to) external onlyOwner {
1443         require(totalSupply() + nMints <= MAX_SUPPLY, "Mint exceeds total supply");
1444         require(nMints % batchSize == 0, "Can only mint a multiple of batchSize");
1445 
1446         for (uint256 i = 0; i < nMints / batchSize; i++) {
1447             _safeMint(to, batchSize);
1448         }
1449     }
1450 
1451     function _withdraw(address _address, uint256 _amount) private {
1452         (bool success, ) = _address.call{value: _amount}("");
1453         require(success, "Transfer failed.");
1454     }
1455 
1456     function withdrawAll() external onlyOwner {
1457         require(address(this).balance > 0, "No funds to withdraw");
1458         uint256 contractBalance = address(this).balance;
1459         _withdraw(msg.sender, contractBalance);
1460     }
1461 
1462     function reveal() external onlyOwner {
1463         revealed = true;
1464     }
1465 
1466     function _baseURI() internal view virtual override returns (string memory) {
1467         return _baseURIextended;
1468     }
1469 
1470     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1471         require(_exists(tokenId), 'ERC721Metadata: URI query for nonexistent token');
1472 
1473         if(revealed == false) {
1474             return notRevealedUri;
1475         }
1476 
1477         string memory baseURI = _baseURI();
1478         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, (tokenId + 1).toString(), '.json')) : '';
1479     }
1480 
1481     function setBaseURI(string calldata baseURI_) external onlyOwner {
1482         _baseURIextended = baseURI_;
1483     }
1484 
1485     function setNotRevealedUri(string memory _uri) external onlyOwner {
1486         notRevealedUri = _uri;
1487     }
1488 
1489     function setWhitelistMerkleRoot(bytes32 _whitelistMerkleRoot) external onlyOwner {
1490         whitelistMerkleRoot = _whitelistMerkleRoot;
1491     }
1492 
1493     function setAllowlistMerkleRoot(bytes32 _allowlistMerkleRoot) external onlyOwner {
1494         allowlistMerkleRoot = _allowlistMerkleRoot;
1495     }
1496 
1497     function setWhitelistStart(bool _whitelistStart) external onlyOwner {
1498         whitelistStart = _whitelistStart;
1499     }
1500 
1501     function setAllowlistStart(bool _allowlistStart) external onlyOwner {
1502         allowlistStart = _allowlistStart;
1503     }
1504 
1505     function setPublicSaleStart(bool _publicSaleStart) external onlyOwner {
1506         publicSaleStart = _publicSaleStart;
1507     }
1508 
1509     function setTicketMintStart(bool _ticketMintStart) external onlyOwner {
1510         ticketMintStart = _ticketMintStart;
1511     }
1512 
1513     function setRegularTicket(address _regularTicket) public onlyOwner {
1514         regularTicket = IRegularTicket(_regularTicket);
1515     }
1516 
1517     function setPlatiumTicket(address _platiumTicket) public onlyOwner {
1518         platiumTicket = IPlatiumTicket(_platiumTicket);
1519     }
1520 
1521     function setTicketPoolAddress(address _address) public onlyOwner {
1522         ticketPoolAddress = _address;
1523     }
1524 
1525     function setWhitelistPrice(uint256 _whitelistPrice) public onlyOwner {
1526         WHITELIST_PRICE = _whitelistPrice;
1527     } 
1528 
1529     function setAllowlistPrice(uint256 _allowlistPrice) public onlyOwner {
1530         ALLOWLIST_PRICE = _allowlistPrice;
1531     }
1532 
1533     function setPublicPrice(uint256 _publicPrice) public onlyOwner {
1534         PUBLIC_PRICE = _publicPrice;
1535     }
1536 
1537     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
1538         MAX_SUPPLY = _maxSupply;
1539     }
1540 
1541     function setMaxWhitelistMints(uint256 _maxWhitelistMints) public onlyOwner {
1542         MAX_WHITELIST_MINTS = _maxWhitelistMints;
1543     }
1544 
1545     function setMaxAllowlistMints(uint256 _maxAllowlistMints) public onlyOwner {
1546         MAX_ALLOWLIST_MINTS = _maxAllowlistMints;
1547     }
1548 
1549     function setPublicMints(uint256 _maxPublicMints) public onlyOwner {
1550         MAX_PUBLIC_MINTS = _maxPublicMints;
1551     }
1552 
1553     function setTicketPortalLimit(uint256 _ticketPortalLimit) public onlyOwner {
1554         TICKET_PORTAL_LIMIT = _ticketPortalLimit;
1555     }
1556 
1557     function setSpecialMintContract(address _specialMintContract) public onlyOwner {
1558         SPECIAL_MINT_CONTRACT = _specialMintContract;
1559     }
1560 
1561     function setSpecialMintStart(bool _specialMintStart) public onlyOwner {
1562         specialMintStart = _specialMintStart;
1563     }
1564 
1565     function setRevealed(bool _revealed) external onlyOwner {
1566         revealed = _revealed;
1567     }
1568 
1569     function getCurrentBlockTimeStamp() public view returns (uint256) {
1570         return block.timestamp;
1571     }
1572 
1573     // OperatorFilter overrides
1574     function transferFrom(
1575         address _from,
1576         address _to,
1577         uint256 _tokenId
1578     )
1579         public
1580         override 
1581         onlyAllowedOperator(_from)
1582     {
1583         super.transferFrom(_from, _to, _tokenId);
1584     }
1585 
1586     function safeTransferFrom(
1587         address _from,
1588         address _to,
1589         uint256 _tokenId
1590     ) 
1591         public
1592         override 
1593         onlyAllowedOperator(_from)
1594     {
1595         super.safeTransferFrom(_from, _to, _tokenId);
1596     }
1597 
1598     function safeTransferFrom(
1599         address _from,
1600         address _to,
1601         uint256 _tokenId,
1602         bytes memory _data
1603     )
1604         public
1605         override
1606         onlyAllowedOperator(_from)
1607     {
1608         super.safeTransferFrom(_from, _to, _tokenId, _data);
1609     }
1610 }