1 // SPDX-License-Identifier: GPL-3.0
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
69 
70 
71 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @dev These functions deal with verification of Merkle Trees proofs.
77  *
78  * The proofs can be generated using the JavaScript library
79  * https://github.com/miguelmota/merkletreejs[merkletreejs].
80  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
81  *
82  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
83  */
84 library MerkleProof {
85     /**
86      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
87      * defined by `root`. For this, a `proof` must be provided, containing
88      * sibling hashes on the branch from the leaf to the root of the tree. Each
89      * pair of leaves and each pair of pre-images are assumed to be sorted.
90      */
91     function verify(
92         bytes32[] memory proof,
93         bytes32 root,
94         bytes32 leaf
95     ) internal pure returns (bool) {
96         return processProof(proof, leaf) == root;
97     }
98 
99     /**
100      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
101      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
102      * hash matches the root of the tree. When processing the proof, the pairs
103      * of leafs & pre-images are assumed to be sorted.
104      *
105      * _Available since v4.4._
106      */
107     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
108         bytes32 computedHash = leaf;
109         for (uint256 i = 0; i < proof.length; i++) {
110             bytes32 proofElement = proof[i];
111             if (computedHash <= proofElement) {
112                 // Hash(current computed hash + current element of the proof)
113                 computedHash = _efficientHash(computedHash, proofElement);
114             } else {
115                 // Hash(current element of the proof + current computed hash)
116                 computedHash = _efficientHash(proofElement, computedHash);
117             }
118         }
119         return computedHash;
120     }
121 
122     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
123         assembly {
124             mstore(0x00, a)
125             mstore(0x20, b)
126             value := keccak256(0x00, 0x40)
127         }
128     }
129 }
130 
131 // File: @openzeppelin/contracts/utils/Strings.sol
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev String operations.
140  */
141 library Strings {
142     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
143 
144     /**
145      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
146      */
147     function toString(uint256 value) internal pure returns (string memory) {
148         // Inspired by OraclizeAPI's implementation - MIT licence
149         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
150 
151         if (value == 0) {
152             return "0";
153         }
154         uint256 temp = value;
155         uint256 digits;
156         while (temp != 0) {
157             digits++;
158             temp /= 10;
159         }
160         bytes memory buffer = new bytes(digits);
161         while (value != 0) {
162             digits -= 1;
163             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
164             value /= 10;
165         }
166         return string(buffer);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
171      */
172     function toHexString(uint256 value) internal pure returns (string memory) {
173         if (value == 0) {
174             return "0x00";
175         }
176         uint256 temp = value;
177         uint256 length = 0;
178         while (temp != 0) {
179             length++;
180             temp >>= 8;
181         }
182         return toHexString(value, length);
183     }
184 
185     /**
186      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
187      */
188     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
189         bytes memory buffer = new bytes(2 * length + 2);
190         buffer[0] = "0";
191         buffer[1] = "x";
192         for (uint256 i = 2 * length + 1; i > 1; --i) {
193             buffer[i] = _HEX_SYMBOLS[value & 0xf];
194             value >>= 4;
195         }
196         require(value == 0, "Strings: hex length insufficient");
197         return string(buffer);
198     }
199 }
200 
201 // File: @openzeppelin/contracts/utils/Context.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Provides information about the current execution context, including the
210  * sender of the transaction and its data. While these are generally available
211  * via msg.sender and msg.data, they should not be accessed in such a direct
212  * manner, since when dealing with meta-transactions the account sending and
213  * paying for execution may not be the actual sender (as far as an application
214  * is concerned).
215  *
216  * This contract is only required for intermediate, library-like contracts.
217  */
218 abstract contract Context {
219     function _msgSender() internal view virtual returns (address) {
220         return msg.sender;
221     }
222 
223     function _msgData() internal view virtual returns (bytes calldata) {
224         return msg.data;
225     }
226 }
227 
228 // File: @openzeppelin/contracts/access/Ownable.sol
229 
230 
231 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 /**
237  * @dev Contract module which provides a basic access control mechanism, where
238  * there is an account (an owner) that can be granted exclusive access to
239  * specific functions.
240  *
241  * By default, the owner account will be the one that deploys the contract. This
242  * can later be changed with {transferOwnership}.
243  *
244  * This module is used through inheritance. It will make available the modifier
245  * `onlyOwner`, which can be applied to your functions to restrict their use to
246  * the owner.
247  */
248 abstract contract Ownable is Context {
249     address private _owner;
250 
251     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
252 
253     /**
254      * @dev Initializes the contract setting the deployer as the initial owner.
255      */
256     constructor() {
257         _transferOwnership(_msgSender());
258     }
259 
260     /**
261      * @dev Returns the address of the current owner.
262      */
263     function owner() public view virtual returns (address) {
264         return _owner;
265     }
266 
267     /**
268      * @dev Throws if called by any account other than the owner.
269      */
270     modifier onlyOwner() {
271         require(owner() == _msgSender(), "Ownable: caller is not the owner");
272         _;
273     }
274 
275     /**
276      * @dev Leaves the contract without owner. It will not be possible to call
277      * `onlyOwner` functions anymore. Can only be called by the current owner.
278      *
279      * NOTE: Renouncing ownership will leave the contract without an owner,
280      * thereby removing any functionality that is only available to the owner.
281      */
282     function renounceOwnership() public virtual onlyOwner {
283         _transferOwnership(address(0));
284     }
285 
286     /**
287      * @dev Transfers ownership of the contract to a new account (`newOwner`).
288      * Can only be called by the current owner.
289      */
290     function transferOwnership(address newOwner) public virtual onlyOwner {
291         require(newOwner != address(0), "Ownable: new owner is the zero address");
292         _transferOwnership(newOwner);
293     }
294 
295     /**
296      * @dev Transfers ownership of the contract to a new account (`newOwner`).
297      * Internal function without access restriction.
298      */
299     function _transferOwnership(address newOwner) internal virtual {
300         address oldOwner = _owner;
301         _owner = newOwner;
302         emit OwnershipTransferred(oldOwner, newOwner);
303     }
304 }
305 
306 // File: @openzeppelin/contracts/utils/Address.sol
307 
308 
309 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
310 
311 pragma solidity ^0.8.1;
312 
313 /**
314  * @dev Collection of functions related to the address type
315  */
316 library Address {
317     /**
318      * @dev Returns true if `account` is a contract.
319      *
320      * [IMPORTANT]
321      * ====
322      * It is unsafe to assume that an address for which this function returns
323      * false is an externally-owned account (EOA) and not a contract.
324      *
325      * Among others, `isContract` will return false for the following
326      * types of addresses:
327      *
328      *  - an externally-owned account
329      *  - a contract in construction
330      *  - an address where a contract will be created
331      *  - an address where a contract lived, but was destroyed
332      * ====
333      *
334      * [IMPORTANT]
335      * ====
336      * You shouldn't rely on `isContract` to protect against flash loan attacks!
337      *
338      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
339      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
340      * constructor.
341      * ====
342      */
343     function isContract(address account) internal view returns (bool) {
344         // This method relies on extcodesize/address.code.length, which returns 0
345         // for contracts in construction, since the code is only stored at the end
346         // of the constructor execution.
347 
348         return account.code.length > 0;
349     }
350 
351     /**
352      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
353      * `recipient`, forwarding all available gas and reverting on errors.
354      *
355      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
356      * of certain opcodes, possibly making contracts go over the 2300 gas limit
357      * imposed by `transfer`, making them unable to receive funds via
358      * `transfer`. {sendValue} removes this limitation.
359      *
360      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
361      *
362      * IMPORTANT: because control is transferred to `recipient`, care must be
363      * taken to not create reentrancy vulnerabilities. Consider using
364      * {ReentrancyGuard} or the
365      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
366      */
367     function sendValue(address payable recipient, uint256 amount) internal {
368         require(address(this).balance >= amount, "Address: insufficient balance");
369 
370         (bool success, ) = recipient.call{value: amount}("");
371         require(success, "Address: unable to send value, recipient may have reverted");
372     }
373 
374     /**
375      * @dev Performs a Solidity function call using a low level `call`. A
376      * plain `call` is an unsafe replacement for a function call: use this
377      * function instead.
378      *
379      * If `target` reverts with a revert reason, it is bubbled up by this
380      * function (like regular Solidity function calls).
381      *
382      * Returns the raw returned data. To convert to the expected return value,
383      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
384      *
385      * Requirements:
386      *
387      * - `target` must be a contract.
388      * - calling `target` with `data` must not revert.
389      *
390      * _Available since v3.1._
391      */
392     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
393         return functionCall(target, data, "Address: low-level call failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
398      * `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCall(
403         address target,
404         bytes memory data,
405         string memory errorMessage
406     ) internal returns (bytes memory) {
407         return functionCallWithValue(target, data, 0, errorMessage);
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
412      * but also transferring `value` wei to `target`.
413      *
414      * Requirements:
415      *
416      * - the calling contract must have an ETH balance of at least `value`.
417      * - the called Solidity function must be `payable`.
418      *
419      * _Available since v3.1._
420      */
421     function functionCallWithValue(
422         address target,
423         bytes memory data,
424         uint256 value
425     ) internal returns (bytes memory) {
426         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
427     }
428 
429     /**
430      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
431      * with `errorMessage` as a fallback revert reason when `target` reverts.
432      *
433      * _Available since v3.1._
434      */
435     function functionCallWithValue(
436         address target,
437         bytes memory data,
438         uint256 value,
439         string memory errorMessage
440     ) internal returns (bytes memory) {
441         require(address(this).balance >= value, "Address: insufficient balance for call");
442         require(isContract(target), "Address: call to non-contract");
443 
444         (bool success, bytes memory returndata) = target.call{value: value}(data);
445         return verifyCallResult(success, returndata, errorMessage);
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
450      * but performing a static call.
451      *
452      * _Available since v3.3._
453      */
454     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
455         return functionStaticCall(target, data, "Address: low-level static call failed");
456     }
457 
458     /**
459      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
460      * but performing a static call.
461      *
462      * _Available since v3.3._
463      */
464     function functionStaticCall(
465         address target,
466         bytes memory data,
467         string memory errorMessage
468     ) internal view returns (bytes memory) {
469         require(isContract(target), "Address: static call to non-contract");
470 
471         (bool success, bytes memory returndata) = target.staticcall(data);
472         return verifyCallResult(success, returndata, errorMessage);
473     }
474 
475     /**
476      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
477      * but performing a delegate call.
478      *
479      * _Available since v3.4._
480      */
481     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
482         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
483     }
484 
485     /**
486      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
487      * but performing a delegate call.
488      *
489      * _Available since v3.4._
490      */
491     function functionDelegateCall(
492         address target,
493         bytes memory data,
494         string memory errorMessage
495     ) internal returns (bytes memory) {
496         require(isContract(target), "Address: delegate call to non-contract");
497 
498         (bool success, bytes memory returndata) = target.delegatecall(data);
499         return verifyCallResult(success, returndata, errorMessage);
500     }
501 
502     /**
503      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
504      * revert reason using the provided one.
505      *
506      * _Available since v4.3._
507      */
508     function verifyCallResult(
509         bool success,
510         bytes memory returndata,
511         string memory errorMessage
512     ) internal pure returns (bytes memory) {
513         if (success) {
514             return returndata;
515         } else {
516             // Look for revert reason and bubble it up if present
517             if (returndata.length > 0) {
518                 // The easiest way to bubble the revert reason is using memory via assembly
519 
520                 assembly {
521                     let returndata_size := mload(returndata)
522                     revert(add(32, returndata), returndata_size)
523                 }
524             } else {
525                 revert(errorMessage);
526             }
527         }
528     }
529 }
530 
531 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
532 
533 
534 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
535 
536 pragma solidity ^0.8.0;
537 
538 /**
539  * @title ERC721 token receiver interface
540  * @dev Interface for any contract that wants to support safeTransfers
541  * from ERC721 asset contracts.
542  */
543 interface IERC721Receiver {
544     /**
545      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
546      * by `operator` from `from`, this function is called.
547      *
548      * It must return its Solidity selector to confirm the token transfer.
549      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
550      *
551      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
552      */
553     function onERC721Received(
554         address operator,
555         address from,
556         uint256 tokenId,
557         bytes calldata data
558     ) external returns (bytes4);
559 }
560 
561 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
562 
563 
564 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
565 
566 pragma solidity ^0.8.0;
567 
568 /**
569  * @dev Interface of the ERC165 standard, as defined in the
570  * https://eips.ethereum.org/EIPS/eip-165[EIP].
571  *
572  * Implementers can declare support of contract interfaces, which can then be
573  * queried by others ({ERC165Checker}).
574  *
575  * For an implementation, see {ERC165}.
576  */
577 interface IERC165 {
578     /**
579      * @dev Returns true if this contract implements the interface defined by
580      * `interfaceId`. See the corresponding
581      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
582      * to learn more about how these ids are created.
583      *
584      * This function call must use less than 30 000 gas.
585      */
586     function supportsInterface(bytes4 interfaceId) external view returns (bool);
587 }
588 
589 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 
597 /**
598  * @dev Implementation of the {IERC165} interface.
599  *
600  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
601  * for the additional interface id that will be supported. For example:
602  *
603  * ```solidity
604  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
605  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
606  * }
607  * ```
608  *
609  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
610  */
611 abstract contract ERC165 is IERC165 {
612     /**
613      * @dev See {IERC165-supportsInterface}.
614      */
615     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
616         return interfaceId == type(IERC165).interfaceId;
617     }
618 }
619 
620 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
621 
622 
623 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
624 
625 pragma solidity ^0.8.0;
626 
627 
628 /**
629  * @dev Required interface of an ERC721 compliant contract.
630  */
631 interface IERC721 is IERC165 {
632     /**
633      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
634      */
635     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
636 
637     /**
638      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
639      */
640     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
641 
642     /**
643      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
644      */
645     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
646 
647     /**
648      * @dev Returns the number of tokens in ``owner``'s account.
649      */
650     function balanceOf(address owner) external view returns (uint256 balance);
651 
652     /**
653      * @dev Returns the owner of the `tokenId` token.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      */
659     function ownerOf(uint256 tokenId) external view returns (address owner);
660 
661     /**
662      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
663      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
664      *
665      * Requirements:
666      *
667      * - `from` cannot be the zero address.
668      * - `to` cannot be the zero address.
669      * - `tokenId` token must exist and be owned by `from`.
670      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
671      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
672      *
673      * Emits a {Transfer} event.
674      */
675     function safeTransferFrom(
676         address from,
677         address to,
678         uint256 tokenId
679     ) external;
680 
681     /**
682      * @dev Transfers `tokenId` token from `from` to `to`.
683      *
684      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
685      *
686      * Requirements:
687      *
688      * - `from` cannot be the zero address.
689      * - `to` cannot be the zero address.
690      * - `tokenId` token must be owned by `from`.
691      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
692      *
693      * Emits a {Transfer} event.
694      */
695     function transferFrom(
696         address from,
697         address to,
698         uint256 tokenId
699     ) external;
700 
701     /**
702      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
703      * The approval is cleared when the token is transferred.
704      *
705      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
706      *
707      * Requirements:
708      *
709      * - The caller must own the token or be an approved operator.
710      * - `tokenId` must exist.
711      *
712      * Emits an {Approval} event.
713      */
714     function approve(address to, uint256 tokenId) external;
715 
716     /**
717      * @dev Returns the account approved for `tokenId` token.
718      *
719      * Requirements:
720      *
721      * - `tokenId` must exist.
722      */
723     function getApproved(uint256 tokenId) external view returns (address operator);
724 
725     /**
726      * @dev Approve or remove `operator` as an operator for the caller.
727      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
728      *
729      * Requirements:
730      *
731      * - The `operator` cannot be the caller.
732      *
733      * Emits an {ApprovalForAll} event.
734      */
735     function setApprovalForAll(address operator, bool _approved) external;
736 
737     /**
738      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
739      *
740      * See {setApprovalForAll}
741      */
742     function isApprovedForAll(address owner, address operator) external view returns (bool);
743 
744     /**
745      * @dev Safely transfers `tokenId` token from `from` to `to`.
746      *
747      * Requirements:
748      *
749      * - `from` cannot be the zero address.
750      * - `to` cannot be the zero address.
751      * - `tokenId` token must exist and be owned by `from`.
752      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
753      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
754      *
755      * Emits a {Transfer} event.
756      */
757     function safeTransferFrom(
758         address from,
759         address to,
760         uint256 tokenId,
761         bytes calldata data
762     ) external;
763 }
764 
765 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
766 
767 
768 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
769 
770 pragma solidity ^0.8.0;
771 
772 
773 /**
774  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
775  * @dev See https://eips.ethereum.org/EIPS/eip-721
776  */
777 interface IERC721Metadata is IERC721 {
778     /**
779      * @dev Returns the token collection name.
780      */
781     function name() external view returns (string memory);
782 
783     /**
784      * @dev Returns the token collection symbol.
785      */
786     function symbol() external view returns (string memory);
787 
788     /**
789      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
790      */
791     function tokenURI(uint256 tokenId) external view returns (string memory);
792 }
793 
794 // File: erc721a/contracts/ERC721A.sol
795 
796 
797 // Creator: Chiru Labs
798 
799 pragma solidity ^0.8.4;
800 
801 
802 
803 
804 
805 
806 
807 
808 error ApprovalCallerNotOwnerNorApproved();
809 error ApprovalQueryForNonexistentToken();
810 error ApproveToCaller();
811 error ApprovalToCurrentOwner();
812 error BalanceQueryForZeroAddress();
813 error MintToZeroAddress();
814 error MintZeroQuantity();
815 error OwnerQueryForNonexistentToken();
816 error TransferCallerNotOwnerNorApproved();
817 error TransferFromIncorrectOwner();
818 error TransferToNonERC721ReceiverImplementer();
819 error TransferToZeroAddress();
820 error URIQueryForNonexistentToken();
821 
822 /**
823  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
824  * the Metadata extension. Built to optimize for lower gas during batch mints.
825  *
826  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
827  *
828  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
829  *
830  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
831  */
832 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
833     using Address for address;
834     using Strings for uint256;
835 
836     // Compiler will pack this into a single 256bit word.
837     struct TokenOwnership {
838         // The address of the owner.
839         address addr;
840         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
841         uint64 startTimestamp;
842         // Whether the token has been burned.
843         bool burned;
844     }
845 
846     // Compiler will pack this into a single 256bit word.
847     struct AddressData {
848         // Realistically, 2**64-1 is more than enough.
849         uint64 balance;
850         // Keeps track of mint count with minimal overhead for tokenomics.
851         uint64 numberMinted;
852         // Keeps track of burn count with minimal overhead for tokenomics.
853         uint64 numberBurned;
854         // For miscellaneous variable(s) pertaining to the address
855         // (e.g. number of whitelist mint slots used).
856         // If there are multiple variables, please pack them into a uint64.
857         uint64 aux;
858     }
859 
860     // The tokenId of the next token to be minted.
861     uint256 internal _currentIndex;
862 
863     // The number of tokens burned.
864     uint256 internal _burnCounter;
865 
866     // Token name
867     string private _name;
868 
869     // Token symbol
870     string private _symbol;
871 
872     // Mapping from token ID to ownership details
873     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
874     mapping(uint256 => TokenOwnership) internal _ownerships;
875 
876     // Mapping owner address to address data
877     mapping(address => AddressData) private _addressData;
878 
879     // Mapping from token ID to approved address
880     mapping(uint256 => address) private _tokenApprovals;
881 
882     // Mapping from owner to operator approvals
883     mapping(address => mapping(address => bool)) private _operatorApprovals;
884 
885     constructor(string memory name_, string memory symbol_) {
886         _name = name_;
887         _symbol = symbol_;
888         _currentIndex = _startTokenId();
889     }
890 
891     /**
892      * To change the starting tokenId, please override this function.
893      */
894     function _startTokenId() internal view virtual returns (uint256) {
895         return 0;
896     }
897 
898     /**
899      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
900      */
901     function totalSupply() public view returns (uint256) {
902         // Counter underflow is impossible as _burnCounter cannot be incremented
903         // more than _currentIndex - _startTokenId() times
904         unchecked {
905             return _currentIndex - _burnCounter - _startTokenId();
906         }
907     }
908 
909     /**
910      * Returns the total amount of tokens minted in the contract.
911      */
912     function _totalMinted() internal view returns (uint256) {
913         // Counter underflow is impossible as _currentIndex does not decrement,
914         // and it is initialized to _startTokenId()
915         unchecked {
916             return _currentIndex - _startTokenId();
917         }
918     }
919 
920     /**
921      * @dev See {IERC165-supportsInterface}.
922      */
923     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
924         return
925             interfaceId == type(IERC721).interfaceId ||
926             interfaceId == type(IERC721Metadata).interfaceId ||
927             super.supportsInterface(interfaceId);
928     }
929 
930     /**
931      * @dev See {IERC721-balanceOf}.
932      */
933     function balanceOf(address owner) public view override returns (uint256) {
934         if (owner == address(0)) revert BalanceQueryForZeroAddress();
935         return uint256(_addressData[owner].balance);
936     }
937 
938     /**
939      * Returns the number of tokens minted by `owner`.
940      */
941     function _numberMinted(address owner) internal view returns (uint256) {
942         return uint256(_addressData[owner].numberMinted);
943     }
944 
945     /**
946      * Returns the number of tokens burned by or on behalf of `owner`.
947      */
948     function _numberBurned(address owner) internal view returns (uint256) {
949         return uint256(_addressData[owner].numberBurned);
950     }
951 
952     /**
953      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
954      */
955     function _getAux(address owner) internal view returns (uint64) {
956         return _addressData[owner].aux;
957     }
958 
959     /**
960      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
961      * If there are multiple variables, please pack them into a uint64.
962      */
963     function _setAux(address owner, uint64 aux) internal {
964         _addressData[owner].aux = aux;
965     }
966 
967     /**
968      * Gas spent here starts off proportional to the maximum mint batch size.
969      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
970      */
971     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
972         uint256 curr = tokenId;
973 
974         unchecked {
975             if (_startTokenId() <= curr && curr < _currentIndex) {
976                 TokenOwnership memory ownership = _ownerships[curr];
977                 if (!ownership.burned) {
978                     if (ownership.addr != address(0)) {
979                         return ownership;
980                     }
981                     // Invariant:
982                     // There will always be an ownership that has an address and is not burned
983                     // before an ownership that does not have an address and is not burned.
984                     // Hence, curr will not underflow.
985                     while (true) {
986                         curr--;
987                         ownership = _ownerships[curr];
988                         if (ownership.addr != address(0)) {
989                             return ownership;
990                         }
991                     }
992                 }
993             }
994         }
995         revert OwnerQueryForNonexistentToken();
996     }
997 
998     /**
999      * @dev See {IERC721-ownerOf}.
1000      */
1001     function ownerOf(uint256 tokenId) public view override returns (address) {
1002         return _ownershipOf(tokenId).addr;
1003     }
1004 
1005     /**
1006      * @dev See {IERC721Metadata-name}.
1007      */
1008     function name() public view virtual override returns (string memory) {
1009         return _name;
1010     }
1011 
1012     /**
1013      * @dev See {IERC721Metadata-symbol}.
1014      */
1015     function symbol() public view virtual override returns (string memory) {
1016         return _symbol;
1017     }
1018 
1019     /**
1020      * @dev See {IERC721Metadata-tokenURI}.
1021      */
1022     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1023         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1024 
1025         string memory baseURI = _baseURI();
1026         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1027     }
1028 
1029     /**
1030      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1031      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1032      * by default, can be overriden in child contracts.
1033      */
1034     function _baseURI() internal view virtual returns (string memory) {
1035         return '';
1036     }
1037 
1038     /**
1039      * @dev See {IERC721-approve}.
1040      */
1041     function approve(address to, uint256 tokenId) public override {
1042         address owner = ERC721A.ownerOf(tokenId);
1043         if (to == owner) revert ApprovalToCurrentOwner();
1044 
1045         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1046             revert ApprovalCallerNotOwnerNorApproved();
1047         }
1048 
1049         _approve(to, tokenId, owner);
1050     }
1051 
1052     /**
1053      * @dev See {IERC721-getApproved}.
1054      */
1055     function getApproved(uint256 tokenId) public view override returns (address) {
1056         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1057 
1058         return _tokenApprovals[tokenId];
1059     }
1060 
1061     /**
1062      * @dev See {IERC721-setApprovalForAll}.
1063      */
1064     function setApprovalForAll(address operator, bool approved) public virtual override {
1065         if (operator == _msgSender()) revert ApproveToCaller();
1066 
1067         _operatorApprovals[_msgSender()][operator] = approved;
1068         emit ApprovalForAll(_msgSender(), operator, approved);
1069     }
1070 
1071     /**
1072      * @dev See {IERC721-isApprovedForAll}.
1073      */
1074     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1075         return _operatorApprovals[owner][operator];
1076     }
1077 
1078     /**
1079      * @dev See {IERC721-transferFrom}.
1080      */
1081     function transferFrom(
1082         address from,
1083         address to,
1084         uint256 tokenId
1085     ) public virtual override {
1086         _transfer(from, to, tokenId);
1087     }
1088 
1089     /**
1090      * @dev See {IERC721-safeTransferFrom}.
1091      */
1092     function safeTransferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) public virtual override {
1097         safeTransferFrom(from, to, tokenId, '');
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-safeTransferFrom}.
1102      */
1103     function safeTransferFrom(
1104         address from,
1105         address to,
1106         uint256 tokenId,
1107         bytes memory _data
1108     ) public virtual override {
1109         _transfer(from, to, tokenId);
1110         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1111             revert TransferToNonERC721ReceiverImplementer();
1112         }
1113     }
1114 
1115     /**
1116      * @dev Returns whether `tokenId` exists.
1117      *
1118      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1119      *
1120      * Tokens start existing when they are minted (`_mint`),
1121      */
1122     function _exists(uint256 tokenId) internal view returns (bool) {
1123         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
1124     }
1125 
1126     function _safeMint(address to, uint256 quantity) internal {
1127         _safeMint(to, quantity, '');
1128     }
1129 
1130     /**
1131      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1132      *
1133      * Requirements:
1134      *
1135      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1136      * - `quantity` must be greater than 0.
1137      *
1138      * Emits a {Transfer} event.
1139      */
1140     function _safeMint(
1141         address to,
1142         uint256 quantity,
1143         bytes memory _data
1144     ) internal {
1145         _mint(to, quantity, _data, true);
1146     }
1147 
1148     /**
1149      * @dev Mints `quantity` tokens and transfers them to `to`.
1150      *
1151      * Requirements:
1152      *
1153      * - `to` cannot be the zero address.
1154      * - `quantity` must be greater than 0.
1155      *
1156      * Emits a {Transfer} event.
1157      */
1158     function _mint(
1159         address to,
1160         uint256 quantity,
1161         bytes memory _data,
1162         bool safe
1163     ) internal {
1164         uint256 startTokenId = _currentIndex;
1165         if (to == address(0)) revert MintToZeroAddress();
1166         if (quantity == 0) revert MintZeroQuantity();
1167 
1168         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1169 
1170         // Overflows are incredibly unrealistic.
1171         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1172         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1173         unchecked {
1174             _addressData[to].balance += uint64(quantity);
1175             _addressData[to].numberMinted += uint64(quantity);
1176 
1177             _ownerships[startTokenId].addr = to;
1178             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1179 
1180             uint256 updatedIndex = startTokenId;
1181             uint256 end = updatedIndex + quantity;
1182 
1183             if (safe && to.isContract()) {
1184                 do {
1185                     emit Transfer(address(0), to, updatedIndex);
1186                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1187                         revert TransferToNonERC721ReceiverImplementer();
1188                     }
1189                 } while (updatedIndex != end);
1190                 // Reentrancy protection
1191                 if (_currentIndex != startTokenId) revert();
1192             } else {
1193                 do {
1194                     emit Transfer(address(0), to, updatedIndex++);
1195                 } while (updatedIndex != end);
1196             }
1197             _currentIndex = updatedIndex;
1198         }
1199         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1200     }
1201 
1202     /**
1203      * @dev Transfers `tokenId` from `from` to `to`.
1204      *
1205      * Requirements:
1206      *
1207      * - `to` cannot be the zero address.
1208      * - `tokenId` token must be owned by `from`.
1209      *
1210      * Emits a {Transfer} event.
1211      */
1212     function _transfer(
1213         address from,
1214         address to,
1215         uint256 tokenId
1216     ) private {
1217         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1218 
1219         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1220 
1221         bool isApprovedOrOwner = (_msgSender() == from ||
1222             isApprovedForAll(from, _msgSender()) ||
1223             getApproved(tokenId) == _msgSender());
1224 
1225         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1226         if (to == address(0)) revert TransferToZeroAddress();
1227 
1228         _beforeTokenTransfers(from, to, tokenId, 1);
1229 
1230         // Clear approvals from the previous owner
1231         _approve(address(0), tokenId, from);
1232 
1233         // Underflow of the sender's balance is impossible because we check for
1234         // ownership above and the recipient's balance can't realistically overflow.
1235         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1236         unchecked {
1237             _addressData[from].balance -= 1;
1238             _addressData[to].balance += 1;
1239 
1240             TokenOwnership storage currSlot = _ownerships[tokenId];
1241             currSlot.addr = to;
1242             currSlot.startTimestamp = uint64(block.timestamp);
1243 
1244             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1245             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1246             uint256 nextTokenId = tokenId + 1;
1247             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1248             if (nextSlot.addr == address(0)) {
1249                 // This will suffice for checking _exists(nextTokenId),
1250                 // as a burned slot cannot contain the zero address.
1251                 if (nextTokenId != _currentIndex) {
1252                     nextSlot.addr = from;
1253                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1254                 }
1255             }
1256         }
1257 
1258         emit Transfer(from, to, tokenId);
1259         _afterTokenTransfers(from, to, tokenId, 1);
1260     }
1261 
1262     /**
1263      * @dev This is equivalent to _burn(tokenId, false)
1264      */
1265     function _burn(uint256 tokenId) internal virtual {
1266         _burn(tokenId, false);
1267     }
1268 
1269     /**
1270      * @dev Destroys `tokenId`.
1271      * The approval is cleared when the token is burned.
1272      *
1273      * Requirements:
1274      *
1275      * - `tokenId` must exist.
1276      *
1277      * Emits a {Transfer} event.
1278      */
1279     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1280         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1281 
1282         address from = prevOwnership.addr;
1283 
1284         if (approvalCheck) {
1285             bool isApprovedOrOwner = (_msgSender() == from ||
1286                 isApprovedForAll(from, _msgSender()) ||
1287                 getApproved(tokenId) == _msgSender());
1288 
1289             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1290         }
1291 
1292         _beforeTokenTransfers(from, address(0), tokenId, 1);
1293 
1294         // Clear approvals from the previous owner
1295         _approve(address(0), tokenId, from);
1296 
1297         // Underflow of the sender's balance is impossible because we check for
1298         // ownership above and the recipient's balance can't realistically overflow.
1299         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1300         unchecked {
1301             AddressData storage addressData = _addressData[from];
1302             addressData.balance -= 1;
1303             addressData.numberBurned += 1;
1304 
1305             // Keep track of who burned the token, and the timestamp of burning.
1306             TokenOwnership storage currSlot = _ownerships[tokenId];
1307             currSlot.addr = from;
1308             currSlot.startTimestamp = uint64(block.timestamp);
1309             currSlot.burned = true;
1310 
1311             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1312             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1313             uint256 nextTokenId = tokenId + 1;
1314             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1315             if (nextSlot.addr == address(0)) {
1316                 // This will suffice for checking _exists(nextTokenId),
1317                 // as a burned slot cannot contain the zero address.
1318                 if (nextTokenId != _currentIndex) {
1319                     nextSlot.addr = from;
1320                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1321                 }
1322             }
1323         }
1324 
1325         emit Transfer(from, address(0), tokenId);
1326         _afterTokenTransfers(from, address(0), tokenId, 1);
1327 
1328         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1329         unchecked {
1330             _burnCounter++;
1331         }
1332     }
1333 
1334     /**
1335      * @dev Approve `to` to operate on `tokenId`
1336      *
1337      * Emits a {Approval} event.
1338      */
1339     function _approve(
1340         address to,
1341         uint256 tokenId,
1342         address owner
1343     ) private {
1344         _tokenApprovals[tokenId] = to;
1345         emit Approval(owner, to, tokenId);
1346     }
1347 
1348     /**
1349      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1350      *
1351      * @param from address representing the previous owner of the given token ID
1352      * @param to target address that will receive the tokens
1353      * @param tokenId uint256 ID of the token to be transferred
1354      * @param _data bytes optional data to send along with the call
1355      * @return bool whether the call correctly returned the expected magic value
1356      */
1357     function _checkContractOnERC721Received(
1358         address from,
1359         address to,
1360         uint256 tokenId,
1361         bytes memory _data
1362     ) private returns (bool) {
1363         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1364             return retval == IERC721Receiver(to).onERC721Received.selector;
1365         } catch (bytes memory reason) {
1366             if (reason.length == 0) {
1367                 revert TransferToNonERC721ReceiverImplementer();
1368             } else {
1369                 assembly {
1370                     revert(add(32, reason), mload(reason))
1371                 }
1372             }
1373         }
1374     }
1375 
1376     /**
1377      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1378      * And also called before burning one token.
1379      *
1380      * startTokenId - the first token id to be transferred
1381      * quantity - the amount to be transferred
1382      *
1383      * Calling conditions:
1384      *
1385      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1386      * transferred to `to`.
1387      * - When `from` is zero, `tokenId` will be minted for `to`.
1388      * - When `to` is zero, `tokenId` will be burned by `from`.
1389      * - `from` and `to` are never both zero.
1390      */
1391     function _beforeTokenTransfers(
1392         address from,
1393         address to,
1394         uint256 startTokenId,
1395         uint256 quantity
1396     ) internal virtual {}
1397 
1398     /**
1399      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1400      * minting.
1401      * And also called after one token has been burned.
1402      *
1403      * startTokenId - the first token id to be transferred
1404      * quantity - the amount to be transferred
1405      *
1406      * Calling conditions:
1407      *
1408      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1409      * transferred to `to`.
1410      * - When `from` is zero, `tokenId` has been minted for `to`.
1411      * - When `to` is zero, `tokenId` has been burned by `from`.
1412      * - `from` and `to` are never both zero.
1413      */
1414     function _afterTokenTransfers(
1415         address from,
1416         address to,
1417         uint256 startTokenId,
1418         uint256 quantity
1419     ) internal virtual {}
1420 }
1421 
1422 contract VibezKartel is Ownable, ERC721A, ReentrancyGuard{
1423   using Strings for uint256;
1424 
1425   string public baseURI; 
1426   string public baseExtension = ".json";
1427 
1428   uint256 public cost = 0.000000002 ether;
1429   uint256 public maxSupply = 163;
1430   uint256 public maxMintAmount = 5;
1431   uint256 public nftPerAddressLimit = 5;
1432 
1433   bool public paused = false;
1434   bool public onlyWhitelisted = true;
1435 
1436   address[] public whitelistedAddresses;
1437   
1438   mapping(address => uint256) public addressMintedBalance;
1439 
1440 
1441   constructor(
1442     string memory _name,
1443     string memory _symbol,
1444     string memory _initBaseURI
1445   ) ERC721A(_name, _symbol) {
1446     setBaseURI(_initBaseURI);
1447   }
1448 
1449   // internal
1450   function _baseURI() internal view virtual override returns (string memory) {
1451     return baseURI;
1452   }
1453 
1454   // public
1455   function mint(uint256 _mintAmount) public payable {
1456     require(!paused, "the contract is paused");
1457     uint256 supply = totalSupply();
1458     require(_mintAmount > 0, "need to mint at least 1 NFT");
1459     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1460     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1461 
1462     if (msg.sender != owner()) {
1463         if(onlyWhitelisted == true) {
1464             require(isWhitelisted(msg.sender), "user is not whitelisted");
1465             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1466             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1467         }
1468         require(msg.value >= cost * _mintAmount, "insufficient funds");
1469     }
1470     
1471     for (uint256 i = 1; i <= _mintAmount; i++) {
1472         addressMintedBalance[msg.sender]++;
1473       _safeMint(msg.sender, supply + i);
1474     }
1475   }
1476   
1477   function isWhitelisted(address _user) public view returns (bool) {
1478     for (uint i = 0; i < whitelistedAddresses.length; i++) {
1479       if (whitelistedAddresses[i] == _user) {
1480           return true;
1481       }
1482     }
1483     return false;
1484   }
1485 
1486     function _startTokenId() internal view virtual override returns (uint256) {
1487     return 1;
1488   }
1489 
1490   function tokenURI(uint256 tokenId)
1491     public
1492     view
1493     virtual
1494     override
1495     returns (string memory)
1496   {
1497     require(
1498       _exists(tokenId),
1499       "ERC721Metadata: URI query for nonexistent token"
1500     );
1501 
1502     string memory currentBaseURI = _baseURI();
1503     return bytes(currentBaseURI).length > 0
1504         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1505         : "";
1506   }
1507 
1508   //only owner
1509   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1510     nftPerAddressLimit = _limit;
1511   }
1512   
1513   function setCost(uint256 _newCost) public onlyOwner {
1514     cost = _newCost;
1515   }
1516 
1517   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1518     maxMintAmount = _newmaxMintAmount;
1519   }
1520 
1521   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1522     baseURI = _newBaseURI;
1523   }
1524 
1525   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1526     baseExtension = _newBaseExtension;
1527   }
1528 
1529   function pause(bool _state) public onlyOwner {
1530     paused = _state;
1531   }
1532   
1533   function setOnlyWhitelisted(bool _state) public onlyOwner {
1534     onlyWhitelisted = _state;
1535   }
1536   
1537   function whitelistUsers(address[] calldata _users) public onlyOwner {
1538     delete whitelistedAddresses;
1539     whitelistedAddresses = _users;
1540   }
1541   
1542 function withdraw() public onlyOwner nonReentrant {  
1543     (bool cm, ) = payable(0x10e99C1E1d676717bC72a652b05dCD6EE5C8f39B).call{value: address(this).balance * 50 / 100}("");
1544     require(cm);
1545 
1546     (bool ar, ) = payable(0xce84f7FE1b268BaaC5305AE23Ae97c9a488e8693).call{value: address(this).balance * 50 / 100}("");
1547     require(ar);
1548 
1549     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
1550     require(os);
1551 
1552   }
1553 }