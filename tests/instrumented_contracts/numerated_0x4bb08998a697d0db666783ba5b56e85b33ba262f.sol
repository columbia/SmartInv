1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
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
17  */
18 library MerkleProof {
19     /**
20      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
21      * defined by `root`. For this, a `proof` must be provided, containing
22      * sibling hashes on the branch from the leaf to the root of the tree. Each
23      * pair of leaves and each pair of pre-images are assumed to be sorted.
24      */
25     function verify(
26         bytes32[] memory proof,
27         bytes32 root,
28         bytes32 leaf
29     ) internal pure returns (bool) {
30         return processProof(proof, leaf) == root;
31     }
32 
33     /**
34      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
35      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
36      * hash matches the root of the tree. When processing the proof, the pairs
37      * of leafs & pre-images are assumed to be sorted.
38      *
39      * _Available since v4.4._
40      */
41     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
42         bytes32 computedHash = leaf;
43         for (uint256 i = 0; i < proof.length; i++) {
44             bytes32 proofElement = proof[i];
45             if (computedHash <= proofElement) {
46                 // Hash(current computed hash + current element of the proof)
47                 computedHash = _efficientHash(computedHash, proofElement);
48             } else {
49                 // Hash(current element of the proof + current computed hash)
50                 computedHash = _efficientHash(proofElement, computedHash);
51             }
52         }
53         return computedHash;
54     }
55 
56     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
57         assembly {
58             mstore(0x00, a)
59             mstore(0x20, b)
60             value := keccak256(0x00, 0x40)
61         }
62     }
63 }
64 
65 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
66 
67 
68 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
69 
70 pragma solidity ^0.8.0;
71 
72 /**
73  * @dev Contract module that helps prevent reentrant calls to a function.
74  *
75  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
76  * available, which can be applied to functions to make sure there are no nested
77  * (reentrant) calls to them.
78  *
79  * Note that because there is a single `nonReentrant` guard, functions marked as
80  * `nonReentrant` may not call one another. This can be worked around by making
81  * those functions `private`, and then adding `external` `nonReentrant` entry
82  * points to them.
83  *
84  * TIP: If you would like to learn more about reentrancy and alternative ways
85  * to protect against it, check out our blog post
86  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
87  */
88 abstract contract ReentrancyGuard {
89     // Booleans are more expensive than uint256 or any type that takes up a full
90     // word because each write operation emits an extra SLOAD to first read the
91     // slot's contents, replace the bits taken up by the boolean, and then write
92     // back. This is the compiler's defense against contract upgrades and
93     // pointer aliasing, and it cannot be disabled.
94 
95     // The values being non-zero value makes deployment a bit more expensive,
96     // but in exchange the refund on every call to nonReentrant will be lower in
97     // amount. Since refunds are capped to a percentage of the total
98     // transaction's gas, it is best to keep them low in cases like this one, to
99     // increase the likelihood of the full refund coming into effect.
100     uint256 private constant _NOT_ENTERED = 1;
101     uint256 private constant _ENTERED = 2;
102 
103     uint256 private _status;
104 
105     constructor() {
106         _status = _NOT_ENTERED;
107     }
108 
109     /**
110      * @dev Prevents a contract from calling itself, directly or indirectly.
111      * Calling a `nonReentrant` function from another `nonReentrant`
112      * function is not supported. It is possible to prevent this from happening
113      * by making the `nonReentrant` function external, and making it call a
114      * `private` function that does the actual work.
115      */
116     modifier nonReentrant() {
117         // On the first call to nonReentrant, _notEntered will be true
118         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
119 
120         // Any calls to nonReentrant after this point will fail
121         _status = _ENTERED;
122 
123         _;
124 
125         // By storing the original value once again, a refund is triggered (see
126         // https://eips.ethereum.org/EIPS/eip-2200)
127         _status = _NOT_ENTERED;
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
765 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
766 
767 
768 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
769 
770 pragma solidity ^0.8.0;
771 
772 
773 /**
774  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
775  * @dev See https://eips.ethereum.org/EIPS/eip-721
776  */
777 interface IERC721Enumerable is IERC721 {
778     /**
779      * @dev Returns the total amount of tokens stored by the contract.
780      */
781     function totalSupply() external view returns (uint256);
782 
783     /**
784      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
785      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
786      */
787     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
788 
789     /**
790      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
791      * Use along with {totalSupply} to enumerate all tokens.
792      */
793     function tokenByIndex(uint256 index) external view returns (uint256);
794 }
795 
796 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
797 
798 
799 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 
804 /**
805  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
806  * @dev See https://eips.ethereum.org/EIPS/eip-721
807  */
808 interface IERC721Metadata is IERC721 {
809     /**
810      * @dev Returns the token collection name.
811      */
812     function name() external view returns (string memory);
813 
814     /**
815      * @dev Returns the token collection symbol.
816      */
817     function symbol() external view returns (string memory);
818 
819     /**
820      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
821      */
822     function tokenURI(uint256 tokenId) external view returns (string memory);
823 }
824 
825 // File: contracts/ERC721A.sol
826 
827 
828 
829 pragma solidity ^0.8.0;
830 
831 
832 
833 
834 
835 
836 
837 
838 
839 /**
840  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
841  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
842  *
843  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
844  *
845  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
846  *
847  * Does not support burning tokens to address(0).
848  */
849 
850 
851 contract ERC721A is
852   Context,
853   ERC165,
854   IERC721,
855   IERC721Metadata,
856   IERC721Enumerable
857 {
858   using Address for address;
859   using Strings for uint256;
860 
861   struct TokenOwnership {
862     address addr;
863     uint64 startTimestamp;
864   }
865 
866   struct AddressData {
867     uint128 balance;
868     uint128 numberMinted;
869   }
870 
871   uint256 private currentIndex = 0;
872 
873   uint256 internal immutable collectionSize;
874   uint256 internal immutable maxBatchSize;
875 
876   // Token name
877   string private _name;
878 
879   // Token symbol
880   string private _symbol;
881 
882   // Mapping from token ID to ownership details
883   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
884   mapping(uint256 => TokenOwnership) private _ownerships;
885 
886   // Mapping owner address to address data
887   mapping(address => AddressData) private _addressData;
888 
889   // Mapping from token ID to approved address
890   mapping(uint256 => address) private _tokenApprovals;
891 
892   // Mapping from owner to operator approvals
893   mapping(address => mapping(address => bool)) private _operatorApprovals;
894 
895   /**
896    * @dev
897    * `maxBatchSize` refers to how much a minter can mint at a time.
898    * `collectionSize_` refers to how many tokens are in the collection.
899    */
900   constructor(
901     string memory name_,
902     string memory symbol_,
903     uint256 maxBatchSize_,
904     uint256 collectionSize_
905   ) {
906     require(
907       collectionSize_ > 0,
908       "ERC721A: collection must have a nonzero supply"
909     );
910     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
911     _name = name_;
912     _symbol = symbol_;
913     maxBatchSize = maxBatchSize_;
914     collectionSize = collectionSize_;
915   }
916 
917   /**
918    * @dev See {IERC721Enumerable-totalSupply}.
919    */
920   function totalSupply() public view override returns (uint256) {
921     return currentIndex;
922   }
923 
924   /**
925    * @dev See {IERC721Enumerable-tokenByIndex}.
926    */
927   function tokenByIndex(uint256 index) public view override returns (uint256) {
928     require(index < totalSupply(), "ERC721A: global index out of bounds");
929     return index;
930   }
931 
932   /**
933    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
934    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
935    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
936    */
937   function tokenOfOwnerByIndex(address owner, uint256 index)
938     public
939     view
940     override
941     returns (uint256)
942   {
943     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
944     uint256 numMintedSoFar = totalSupply();
945     uint256 tokenIdsIdx = 0;
946     address currOwnershipAddr = address(0);
947     for (uint256 i = 0; i < numMintedSoFar; i++) {
948       TokenOwnership memory ownership = _ownerships[i];
949       if (ownership.addr != address(0)) {
950         currOwnershipAddr = ownership.addr;
951       }
952       if (currOwnershipAddr == owner) {
953         if (tokenIdsIdx == index) {
954           return i;
955         }
956         tokenIdsIdx++;
957       }
958     }
959     revert("ERC721A: unable to get token of owner by index");
960   }
961 
962   /**
963    * @dev See {IERC165-supportsInterface}.
964    */
965   function supportsInterface(bytes4 interfaceId)
966     public
967     view
968     virtual
969     override(ERC165, IERC165)
970     returns (bool)
971   {
972     return
973       interfaceId == type(IERC721).interfaceId ||
974       interfaceId == type(IERC721Metadata).interfaceId ||
975       interfaceId == type(IERC721Enumerable).interfaceId ||
976       super.supportsInterface(interfaceId);
977   }
978 
979   /**
980    * @dev See {IERC721-balanceOf}.
981    */
982   function balanceOf(address owner) public view override returns (uint256) {
983     require(owner != address(0), "ERC721A: balance query for the zero address");
984     return uint256(_addressData[owner].balance);
985   }
986 
987   function _numberMinted(address owner) internal view returns (uint256) {
988     require(
989       owner != address(0),
990       "ERC721A: number minted query for the zero address"
991     );
992     return uint256(_addressData[owner].numberMinted);
993   }
994 
995   function ownershipOf(uint256 tokenId)
996     internal
997     view
998     returns (TokenOwnership memory)
999   {
1000     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1001 
1002     uint256 lowestTokenToCheck;
1003     if (tokenId >= maxBatchSize) {
1004       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1005     }
1006 
1007     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1008       TokenOwnership memory ownership = _ownerships[curr];
1009       if (ownership.addr != address(0)) {
1010         return ownership;
1011       }
1012     }
1013 
1014     revert("ERC721A: unable to determine the owner of token");
1015   }
1016 
1017   /**
1018    * @dev See {IERC721-ownerOf}.
1019    */
1020   function ownerOf(uint256 tokenId) public view override returns (address) {
1021     return ownershipOf(tokenId).addr;
1022   }
1023 
1024   /**
1025    * @dev See {IERC721Metadata-name}.
1026    */
1027   function name() public view virtual override returns (string memory) {
1028     return _name;
1029   }
1030 
1031   /**
1032    * @dev See {IERC721Metadata-symbol}.
1033    */
1034   function symbol() public view virtual override returns (string memory) {
1035     return _symbol;
1036   }
1037 
1038   /**
1039    * @dev See {IERC721Metadata-tokenURI}.
1040    */
1041   function tokenURI(uint256 tokenId)
1042     public
1043     view
1044     virtual
1045     override
1046     returns (string memory)
1047   {
1048     require(
1049       _exists(tokenId),
1050       "ERC721Metadata: URI query for nonexistent token"
1051     );
1052 
1053     string memory baseURI = _baseURI();
1054     return
1055       bytes(baseURI).length > 0
1056         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1057         : "";
1058   }
1059 
1060   /**
1061    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1062    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1063    * by default, can be overriden in child contracts.
1064    */
1065   function _baseURI() internal view virtual returns (string memory) {
1066     return "";
1067   }
1068 
1069   /**
1070    * @dev See {IERC721-approve}.
1071    */
1072   function approve(address to, uint256 tokenId) public override {
1073     address owner = ERC721A.ownerOf(tokenId);
1074     require(to != owner, "ERC721A: approval to current owner");
1075 
1076     require(
1077       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1078       "ERC721A: approve caller is not owner nor approved for all"
1079     );
1080 
1081     _approve(to, tokenId, owner);
1082   }
1083 
1084   /**
1085    * @dev See {IERC721-getApproved}.
1086    */
1087   function getApproved(uint256 tokenId) public view override returns (address) {
1088     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1089 
1090     return _tokenApprovals[tokenId];
1091   }
1092 
1093   /**
1094    * @dev See {IERC721-setApprovalForAll}.
1095    */
1096   function setApprovalForAll(address operator, bool approved) public override {
1097     require(operator != _msgSender(), "ERC721A: approve to caller");
1098 
1099     _operatorApprovals[_msgSender()][operator] = approved;
1100     emit ApprovalForAll(_msgSender(), operator, approved);
1101   }
1102 
1103   /**
1104    * @dev See {IERC721-isApprovedForAll}.
1105    */
1106   function isApprovedForAll(address owner, address operator)
1107     public
1108     view
1109     virtual
1110     override
1111     returns (bool)
1112   {
1113     return _operatorApprovals[owner][operator];
1114   }
1115 
1116   /**
1117    * @dev See {IERC721-transferFrom}.
1118    */
1119   function transferFrom(
1120     address from,
1121     address to,
1122     uint256 tokenId
1123   ) public override {
1124     _transfer(from, to, tokenId);
1125   }
1126 
1127   /**
1128    * @dev See {IERC721-safeTransferFrom}.
1129    */
1130   function safeTransferFrom(
1131     address from,
1132     address to,
1133     uint256 tokenId
1134   ) public override {
1135     safeTransferFrom(from, to, tokenId, "");
1136   }
1137 
1138   /**
1139    * @dev See {IERC721-safeTransferFrom}.
1140    */
1141   function safeTransferFrom(
1142     address from,
1143     address to,
1144     uint256 tokenId,
1145     bytes memory _data
1146   ) public override {
1147     _transfer(from, to, tokenId);
1148     require(
1149       _checkOnERC721Received(from, to, tokenId, _data),
1150       "ERC721A: transfer to non ERC721Receiver implementer"
1151     );
1152   }
1153 
1154   /**
1155    * @dev Returns whether `tokenId` exists.
1156    *
1157    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1158    *
1159    * Tokens start existing when they are minted (`_mint`),
1160    */
1161   function _exists(uint256 tokenId) internal view returns (bool) {
1162     return tokenId < currentIndex;
1163   }
1164 
1165   function _safeMint(address to, uint256 quantity) internal {
1166     _safeMint(to, quantity, "");
1167   }
1168 
1169   /**
1170    * @dev Mints `quantity` tokens and transfers them to `to`.
1171    *
1172    * Requirements:
1173    *
1174    * - there must be `quantity` tokens remaining unminted in the total collection.
1175    * - `to` cannot be the zero address.
1176    * - `quantity` cannot be larger than the max batch size.
1177    *
1178    * Emits a {Transfer} event.
1179    */
1180   function _safeMint(
1181     address to,
1182     uint256 quantity,
1183     bytes memory _data
1184   ) internal {
1185     uint256 startTokenId = currentIndex;
1186     require(to != address(0), "ERC721A: mint to the zero address");
1187     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1188     require(!_exists(startTokenId), "ERC721A: token already minted");
1189     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1190 
1191     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1192 
1193     AddressData memory addressData = _addressData[to];
1194     _addressData[to] = AddressData(
1195       addressData.balance + uint128(quantity),
1196       addressData.numberMinted + uint128(quantity)
1197     );
1198     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1199 
1200     uint256 updatedIndex = startTokenId;
1201 
1202     for (uint256 i = 0; i < quantity; i++) {
1203       emit Transfer(address(0), to, updatedIndex);
1204       require(
1205         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1206         "ERC721A: transfer to non ERC721Receiver implementer"
1207       );
1208       updatedIndex++;
1209     }
1210 
1211     currentIndex = updatedIndex;
1212     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1213   }
1214 
1215   /**
1216    * @dev Transfers `tokenId` from `from` to `to`.
1217    *
1218    * Requirements:
1219    *
1220    * - `to` cannot be the zero address.
1221    * - `tokenId` token must be owned by `from`.
1222    *
1223    * Emits a {Transfer} event.
1224    */
1225   function _transfer(
1226     address from,
1227     address to,
1228     uint256 tokenId
1229   ) private {
1230     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1231 
1232     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1233       getApproved(tokenId) == _msgSender() ||
1234       isApprovedForAll(prevOwnership.addr, _msgSender()));
1235 
1236     require(
1237       isApprovedOrOwner,
1238       "ERC721A: transfer caller is not owner nor approved"
1239     );
1240 
1241     require(
1242       prevOwnership.addr == from,
1243       "ERC721A: transfer from incorrect owner"
1244     );
1245     require(to != address(0), "ERC721A: transfer to the zero address");
1246 
1247     _beforeTokenTransfers(from, to, tokenId, 1);
1248 
1249     // Clear approvals from the previous owner
1250     _approve(address(0), tokenId, prevOwnership.addr);
1251 
1252     _addressData[from].balance -= 1;
1253     _addressData[to].balance += 1;
1254     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1255 
1256     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1257     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1258     uint256 nextTokenId = tokenId + 1;
1259     if (_ownerships[nextTokenId].addr == address(0)) {
1260       if (_exists(nextTokenId)) {
1261         _ownerships[nextTokenId] = TokenOwnership(
1262           prevOwnership.addr,
1263           prevOwnership.startTimestamp
1264         );
1265       }
1266     }
1267 
1268     emit Transfer(from, to, tokenId);
1269     _afterTokenTransfers(from, to, tokenId, 1);
1270   }
1271 
1272   /**
1273    * @dev Approve `to` to operate on `tokenId`
1274    *
1275    * Emits a {Approval} event.
1276    */
1277   function _approve(
1278     address to,
1279     uint256 tokenId,
1280     address owner
1281   ) private {
1282     _tokenApprovals[tokenId] = to;
1283     emit Approval(owner, to, tokenId);
1284   }
1285 
1286   uint256 public nextOwnerToExplicitlySet = 0;
1287 
1288   /**
1289    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1290    */
1291   function _setOwnersExplicit(uint256 quantity) internal {
1292     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1293     require(quantity > 0, "quantity must be nonzero");
1294     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1295     if (endIndex > collectionSize - 1) {
1296       endIndex = collectionSize - 1;
1297     }
1298     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1299     require(_exists(endIndex), "not enough minted yet for this cleanup");
1300     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1301       if (_ownerships[i].addr == address(0)) {
1302         TokenOwnership memory ownership = ownershipOf(i);
1303         _ownerships[i] = TokenOwnership(
1304           ownership.addr,
1305           ownership.startTimestamp
1306         );
1307       }
1308     }
1309     nextOwnerToExplicitlySet = endIndex + 1;
1310   }
1311 
1312   /**
1313    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1314    * The call is not executed if the target address is not a contract.
1315    *
1316    * @param from address representing the previous owner of the given token ID
1317    * @param to target address that will receive the tokens
1318    * @param tokenId uint256 ID of the token to be transferred
1319    * @param _data bytes optional data to send along with the call
1320    * @return bool whether the call correctly returned the expected magic value
1321    */
1322   function _checkOnERC721Received(
1323     address from,
1324     address to,
1325     uint256 tokenId,
1326     bytes memory _data
1327   ) private returns (bool) {
1328     if (to.isContract()) {
1329       try
1330         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1331       returns (bytes4 retval) {
1332         return retval == IERC721Receiver(to).onERC721Received.selector;
1333       } catch (bytes memory reason) {
1334         if (reason.length == 0) {
1335           revert("ERC721A: transfer to non ERC721Receiver implementer");
1336         } else {
1337           assembly {
1338             revert(add(32, reason), mload(reason))
1339           }
1340         }
1341       }
1342     } else {
1343       return true;
1344     }
1345   }
1346 
1347   /**
1348    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1349    *
1350    * startTokenId - the first token id to be transferred
1351    * quantity - the amount to be transferred
1352    *
1353    * Calling conditions:
1354    *
1355    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1356    * transferred to `to`.
1357    * - When `from` is zero, `tokenId` will be minted for `to`.
1358    */
1359   function _beforeTokenTransfers(
1360     address from,
1361     address to,
1362     uint256 startTokenId,
1363     uint256 quantity
1364   ) internal virtual {}
1365 
1366   /**
1367    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1368    * minting.
1369    *
1370    * startTokenId - the first token id to be transferred
1371    * quantity - the amount to be transferred
1372    *
1373    * Calling conditions:
1374    *
1375    * - when `from` and `to` are both non-zero.
1376    * - `from` and `to` are never both zero.
1377    */
1378   function _afterTokenTransfers(
1379     address from,
1380     address to,
1381     uint256 startTokenId,
1382     uint256 quantity
1383   ) internal virtual {}
1384 }
1385 // File: contracts/Fanda.sol
1386 
1387 
1388 pragma solidity 0.8.7;
1389 
1390 
1391 
1392 
1393 
1394 contract FANDAS is ERC721A, Ownable, ReentrancyGuard {
1395 
1396     using Address for address;
1397     using Strings for uint256;
1398     using MerkleProof for bytes32[];
1399 
1400     string public baseURI;
1401     string public baseExtension = ".json";
1402 
1403     uint256 public presaleMintPrice = 0.04 ether;
1404     uint256 public publicMintPrice = 0.05 ether;
1405     uint256 public maxMintPerWallet = 3;
1406     uint256 public maxMintPerTx = 3;
1407 
1408 
1409     bool public whitelistOpen = true;
1410 
1411     bytes32 whitelistMerkleRoot = 0xaccf7d34fbd84c5cbcb9dc624ce046254c6c77b603b2de1ce6c3376632db7c4c;
1412 
1413     mapping(address => uint256) public MintedAmountWhitelist;
1414     mapping(address => uint256) public MintedAmountPublic;
1415 
1416 
1417     // ===== Constructor =====
1418     constructor() ERC721A("Frenly Pandas", "FANDAS", maxMintPerWallet, 10000) {
1419         
1420     }
1421 
1422     function changePublicPrice(uint256 _price) public onlyOwner
1423     {
1424         publicMintPrice = _price;
1425     }
1426 
1427     function devMint(uint256 amount) public onlyOwner
1428     {
1429         _safeMint(msg.sender, amount);
1430     }
1431 
1432     // ===== Modifier =====
1433     function _onlySender() private view {
1434         require(msg.sender == tx.origin);
1435     }
1436 
1437     modifier onlySender {
1438         _onlySender();
1439         _;
1440     }
1441 
1442     modifier whitelistIsOpen {
1443         require(whitelistOpen == true);
1444         _;
1445     }
1446 
1447     modifier whitelistIsClosed {
1448         require(whitelistOpen == false);
1449         _;
1450     }
1451 
1452     function flipSale() public onlyOwner
1453     {
1454         whitelistOpen = !whitelistOpen;
1455     }
1456 
1457     function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
1458         whitelistMerkleRoot = _merkleRoot;
1459     }
1460 
1461     function whitelistMint(bytes32[] calldata _merkleProof, uint256 amount) public payable nonReentrant onlySender whitelistIsOpen
1462     {      
1463         require(msg.value >= presaleMintPrice, "Minting a Panda Costs 0.05 Ether Each!");
1464         
1465         bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
1466         require(MerkleProof.verify(_merkleProof, whitelistMerkleRoot, leaf), "Invalid proof.");
1467 
1468         require(
1469             amount <= maxMintPerTx,
1470             "Minting amount exceeds allowance per tx"
1471         );
1472 
1473         require(
1474             MintedAmountWhitelist[msg.sender] + amount <= maxMintPerWallet,
1475             "Minting amount exceeds allowance per wallet"
1476         );
1477         MintedAmountWhitelist[msg.sender] += amount;
1478 
1479         require((totalSupply() + amount) <= collectionSize, "Sold out!");
1480         _safeMint(msg.sender, amount);
1481         
1482     }
1483 
1484 
1485     function publicMint(uint256 amount) public payable nonReentrant onlySender whitelistIsClosed
1486     {      
1487         require(msg.value >= publicMintPrice, "Minting a Panda Costs 0.06 Ether Each!");
1488         
1489         require(
1490             amount <= maxMintPerTx,
1491             "Minting amount exceeds allowance per tx"
1492         );
1493         
1494         require(
1495             MintedAmountPublic[msg.sender] + amount <= maxMintPerWallet,
1496             "Minting amount exceeds allowance per wallet"
1497         );
1498 
1499 
1500         MintedAmountPublic[msg.sender] += amount;
1501 
1502         require((totalSupply() + amount) <= collectionSize, "Sold out!");
1503         _safeMint(msg.sender, amount);
1504         
1505     }
1506 
1507     function _withdraw(address payable address_, uint256 amount_) internal {
1508         (bool success, ) = payable(address_).call{value: amount_}("");
1509         require(success, "Transfer failed");
1510     }
1511 
1512     function withdrawEther() external onlyOwner {
1513         _withdraw(payable(msg.sender), address(this).balance);
1514     }
1515 
1516     function withdrawEtherTo(address payable to_) external onlyOwner {
1517         _withdraw(to_, address(this).balance);
1518     }
1519     
1520     function setBaseURI(string memory _newBaseURI) public onlyOwner {
1521         baseURI = _newBaseURI;
1522     }
1523     function _baseURI() internal view virtual override returns (string memory) {
1524         return baseURI;
1525     }   
1526     function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
1527     {
1528         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1529 
1530         string memory currentBaseURI = _baseURI();
1531         return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension)) : "";
1532     }
1533 
1534     function walletOfOwner(address address_) public virtual view returns (uint256[] memory) {
1535         uint256 _balance = balanceOf(address_);
1536         uint256[] memory _tokens = new uint256[] (_balance);
1537         uint256 _index;
1538         uint256 _loopThrough = totalSupply();
1539         for (uint256 i = 0; i < _loopThrough; i++) {
1540             bool _exists = _exists(i);
1541             if (_exists) {
1542                 if (ownerOf(i) == address_) { _tokens[_index] = i; _index++; }
1543             }
1544             else if (!_exists && _tokens[_balance - 1] == 0) { _loopThrough++; }
1545         }
1546         return _tokens;
1547     }
1548 }